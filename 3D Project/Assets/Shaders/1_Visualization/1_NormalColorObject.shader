// 用物体坐标系的法线方向作为vertex的颜色

Shader "custom/visualization/normal color object"{
	Properties{
		_Color ("Color Tint", Color) = (1.0, 1.0, 1.0, 1.0)
	}

	SubShader{
		Pass{
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			struct a2v{
				float4 position : POSITION;
				float3 normal : NORMAL;
				float4 color : TEXCOORD0;
			};

			struct v2f{
				float4 position : SV_POSITION;
				fixed3 color : COLOR0;
			};

			v2f vert(a2v v){
				v2f o;

				o.position = UnityObjectToClipPos(v.position);
				o.color = v.normal.xyz*0.5 + fixed3(0.5, 0.5, 0.5);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target{
				return fixed4(i.color, 1.0);
			}

			ENDCG
		}
	}
}
