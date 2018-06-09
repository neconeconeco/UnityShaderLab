// 用物体坐标系下副法线方向作为vertex颜色

Shader "custom/visualization/binormal color object"{
	SubShader{
		Pass{
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct a2v
			{
				float4 vertex : POSITION ;
				float3 normal : NORMAL ;
				float4 tangent : TANGENT ; 
			};

			struct v2f{
				float4 position : SV_POSITION;
				fixed4 color : COLOR0;
			};

			v2f vert(a2v v){
				v2f o;

				o.position = UnityObjectToClipPos(v.vertex);
				float3 binormal = cross(v.normal, v.tangent.xyz)*v.tangent.w;
				o.color = fixed4(binormal, 0.0)*0.5 + fixed4(0.05, 0.5, 0.5, 1.0);

				return o;
			}

			fixed4 frag(v2f i) : SV_Target{
				return i.color;
			}

			ENDCG
		}
	}
}
