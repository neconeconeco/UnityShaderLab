// 单张凹凸纹理贴图

Shader "custom/texture/mask map"{
	Properties {
		_Color("Diffuse", Color) = (1, 1, 1, 1)
		_MainTex("Main Tex", 2D) = "white"{}
		_BumpMap("Nomal Map", 2D) = "bump"{}
		_SpecularMask("Specular Mask", 2D) = "white" {}
		_SpecularScale("Speclual Scale", Float) = 1.0
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

			fixed4 _Color;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _BumpMap;
			float4 _BumpMap_ST;
			sampler2D _SpecularMask;
			float _SpecularScale;
			fixed4 _Specular;
			float _Gloss; 

			struct  a2v
			 {
			 	float4 vertex : POSITION;
			 	float3 normal : NORMAL;
			 	float4 tangent : TANGENT;
			 	float4 texcoord : TEXCOORD0 ;
			 }; 

			 struct  v2f
			 {
			 	float4 pos : SV_POSITION;
			 	float4 uv : TEXCOORD0 ;
			 	float3 lightDir : TEXCOORD1  ;
			 	float3 viewDir : TEXCOORD2 ;
			 };

			 v2f vert(a2v v) {
			 	v2f o;
			 	o.pos = UnityObjectToClipPos(v.vertex);

			 	o.uv.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
 
			 	float3 binormal = cross(normalize(v.normal), normalize(v.tangent.xyz)) * v.tangent.w;
			 	float3x3 rotation = float3x3(v.tangent.xyz, binormal, v.normal);

			 	o.lightDir = mul(rotation, ObjSpaceLightDir(v.vertex)).xyz;
			 	o.viewDir = mul(rotation, ObjSpaceViewDir(v.vertex)).xyz;

			 	return o;
			 }

			 fixed4 frag(v2f i) : SV_Target{
			 	fixed3 tangentLightDir = normalize(i.lightDir);
			 	fixed3 tangentViewDir = normalize(i.viewDir);

			 	fixed4 packedNormal = tex2D(_BumpMap, i.uv.xy);
				fixed3 tangentNormal = UnpackNormal(packedNormal);

			 	fixed3 albedo = tex2D(_MainTex, i.uv.xy).rgb * _Color.rgb;

			 	fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;

			 	fixed3 diffuse =_LightColor0.rgb * albedo.rgb * saturate(dot(tangentNormal, i.lightDir));

			 	fixed3 halfDir = normalize(i.viewDir + i.lightDir);
				fixed specularMask = tex2D(_SpecularMask, i.uv.xy).r*_SpecularScale;
			 	fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(saturate(dot(halfDir, tangentNormal)), _Gloss) * specularMask;
			 	
			 	fixed3 color = ambient + diffuse + specular;

			 	return fixed4(color, 1.0);
			 }

			ENDCG
		}
	}

	FallBack "Specular"
}