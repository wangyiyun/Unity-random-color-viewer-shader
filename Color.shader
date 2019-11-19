Shader "Custom/Color"
{
	Properties
	{
		_R0("Red From", Range(0, 1)) = 0
		_R1("Red To", Range(0, 1)) = 1
		_G0 ("Green From", Range(0, 1)) = 0
		_G1 ("Green To", Range(0, 1)) = 1
		_B0 ("Blue From", Range(0, 1)) = 0
		_B1 ("Blue To", Range(0, 1)) = 1
		_Speed("Play speed", Range(0, 1)) = 0.5
	}
	SubShader
	{
	   Pass {

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			float _R0, _R1, _G0, _G1, _B0, _B1, _Speed;

			struct v2f {
				float4 pos : SV_POSITION;
				fixed3 color : COLOR0;
			};

			float Remap(float v, float l0, float h0, float ln, float hn)
			{
				return ln + (v - l0) * (hn - ln) / (h0 - l0);
			}

			fixed3 Remap(fixed3 v)
			{
				fixed3 result;
				result.x = Remap(v.x, 0, 1, _R0, _R1);
				result.y = Remap(v.y, 0, 1, _G0, _G1);
				result.z = Remap(v.z, 0, 1, _B0, _B1);
				return result;
			}

			fixed3 Anim(fixed3 v)
			{
				return v * abs(sin(_Time.y*_Speed));
			}

			v2f vert(appdata_base v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.color = Remap(Anim(v.vertex+0.5));
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				return fixed4((i.color), 1);
			}
			ENDCG
		}
    }
    FallBack "Diffuse"
}
