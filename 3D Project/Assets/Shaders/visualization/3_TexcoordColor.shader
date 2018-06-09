// 用纹理坐标作为vertex颜色

Shader "custom/visualization/texcoord color"{
	SubShader{
		Pass{
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct a2v
			{
				float4 vertex : POSITION ;
				float2 texcoord : TEXCOORD0 ; 
			};

			struct v2f{
				float4 position : SV_POSITION;
				fixed4 color : COLOR0;
			};

			v2f vert(a2v v){
				v2f o;

				o.position = UnityObjectToClipPos(v.vertex);
				o.color = fixed4(v.texcoord.xy, 0.0, 1.0);

				return o;
			}

			fixed4 frag(v2f i) : SV_Target{
				return i.color;
			}

			ENDCG
		}
	}
}
