// 单个光源下平行光的片元高光反射(Blinn Phong model)效果

Shader "custom/light model/blinn phong fragment level"{
	Properties {
		_Diffuse("Diffuse", Color) = (1, 1, 1, 1)
		_Specular("Specular", Color) = (1, 1, 1, 1)
		_Gloss("Gloss", Range(8.0, 256)) = 20
	}
	SubShader {
		Pass {
			Tags{ "LightMode" = "ForwardBase"}

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			#include "Lighting.cginc"

			fixed4 _Diffuse;
			fixed4 _Specular;
			float _Gloss; 

			struct  a2v
			 {
			 	float4 vertex : POSITION;
			 	float3 normal : NORMAL;
			 }; 

			 struct  v2f
			 {
			 	float4 pos : SV_POSITION;
			 	fixed3 world_normal : TEXCOORD0;
			 	float3 world_pos : TEXCOORD1  ;
			 };

			 v2f vert(a2v v) {
			 	v2f o;
			 	o.pos = UnityObjectToClipPos(v.vertex);

			 	o.world_normal = UnityObjectToWorldNormal(v.normal);
			 	o.world_pos = UnityObjectToClipPos(v.vertex).xyz;

			 	return o;
			 }

			 fixed4 frag(v2f i) : SV_Target{
			 	fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;

			 	fixed3 worldNormal = normalize(i.world_normal);
			 	fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);
			 	fixed3 diffuse =_LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldLightDir, worldNormal));

			 	fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.world_pos.xyz);
			 	fixed3 halfDir = normalize(viewDir + worldLightDir);
			 	fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(saturate(dot(halfDir, worldNormal)), _Gloss);
			 	
			 	fixed3 color = ambient + diffuse + specular;

			 	return fixed4(color, 1.0);
			 }

			ENDCG
		}
	}

	FallBack "Diffuse"
}