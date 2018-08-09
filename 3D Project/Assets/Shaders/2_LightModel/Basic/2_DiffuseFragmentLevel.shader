// 单个光源下平行光的片元漫反射效果

Shader "custom/light model/basic/diffuse fragment level"{
	Properties {
		_Diffuse("Diffuse", Color) = (1, 1, 1, 1)
	}
	SubShader {
		Pass {
			Tags{ "LightMode" = "ForwardBase"}

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			#include "Lighting.cginc"

			fixed4 _Diffuse;

			struct  a2v
			 {
			 	float4 vertex : POSITION;
			 	float3 normal : NORMAL;
			 }; 

			 struct  v2f
			 {
			 	float4 pos : SV_POSITION;
			 	fixed3 world_normal : TEXCOORD0;
			 };

			 v2f vert(a2v v) {
			 	v2f o;
			 	o.pos = UnityObjectToClipPos(v.vertex);

			 	o.world_normal = UnityObjectToWorldNormal(v.normal); 

			 	return o;
			 }

			 fixed4 frag(v2f i) : SV_Target{
			 	fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;

			 	fixed3 worldNormal = normalize(i.world_normal);
			 	fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);
			 	fixed3 diffuse =_LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldLightDir, worldNormal));

			 	fixed3 color = ambient + diffuse;

			 	return fixed4(color, 1.0);
			 }

			ENDCG
		}
	}

	FallBack "Diffuse"
}