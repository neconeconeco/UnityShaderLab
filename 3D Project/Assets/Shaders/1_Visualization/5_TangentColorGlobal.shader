// 用世界坐标系下切线方向作为vertex颜色

Shader "custom/visualization/tangent color global"{
	SubShader{
		Pass{
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct a2v
			{
				float4 vertex : POSITION ;
				float4 tangent : TANGENT ; 
			};

			struct v2f{
				float4 position : SV_POSITION;
				fixed4 color : COLOR0;
			};

			v2f vert(a2v v){
				v2f o;

				o.position = UnityObjectToClipPos(v.vertex);
				o.color = fixed4(UnityObjectToWorldDir(v.tangent.xyz), 1.0)*0.5 + fixed4(0.05, 0.5, 0.5, 1.0);

				return o;
			}

			fixed4 frag(v2f i) : SV_Target{
				return i.color;
			}

			ENDCG
		}
	}
}
