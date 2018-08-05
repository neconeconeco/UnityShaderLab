// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "custom/texture/normal map in world space"
{
	Properties{
		_Color("Color Tint", Color) = (1, 1, 1, 1)
		_MainTex("Main Tex", 2D) = "white" {}
		_BumpMap("Bump Map",  2D) = "bump" {}
		_Specular("Specular", Color) = (1, 1, 1, 1)
		_Gloss("Gloss", Range(8.0, 256)) = 20
	}

		Subshader{
			Pass{
				Tags {"LightMode" = "ForwardBase"}

				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				
				#include "Lighting.cginc"
				
				fixed4 _Color;
				sampler2D _MainTex;
				float4 _MainTex_ST;
				sampler2D _BumpMap;
				float4 _BumpMap_ST;
				fixed4 _Specular;
				float _Gloss;

				struct a2v{
					float4 pos : POSITION;
					float4 tangent : TANGENT;
					float3 normal : NORMAL;
					float4 texcoord : TEXCOORD0;
				};

				struct v2f{
					float4 pos : SV_POSITION;
					float4 uv : TEXCOORD0;
					float4 TtoW0 : TEXCOORD1;
					float4 TtoW1 : TEXCOORD2;
					float4 TtoW2 : TEXCOORD3;
				};

				v2f  vert(a2v v){
					v2f o;
					o.pos = UnityObjectToClipPos(v.pos);
				
					o.uv.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
					o.uv.zw = v.texcoord.xy * _BumpMap_ST.xy + _BumpMap_ST.zw;

					float3 worldPos = mul(unity_ObjectToWorld, v.pos).xyz;
					fixed3 worldNormal = UnityObjectToWorldNormal(v.normal);
					fixed3 worldTangent = UnityObjectToWorldDir(v.tangent.xyz);
					fixed3 worldBinormal = cross(worldNormal, worldTangent) * v.tangent.w;

					o.TtoW0 = float4(worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x);
					o.TtoW1 = float4(worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y);
					o.TtoW2 = float4(worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z);

					return o;
				}

				fixed4 frag(v2f i) : SV_TARGET{
					float3 worldPos = float3(i.TtoW0.w, i.TtoW1.w, i.TtoW2.w);
					fixed3 lightDir = normalize(UnityWorldSpaceLightDir(worldPos));
					fixed3 viewDir = normalize(UnityWorldSpaceViewDir(worldPos));

					fixed3 bump = UnpackNormal(tex2D(_BumpMap, i.uv.zw));
					bump = normalize(half3(dot(i.TtoW0.xyz, bump),dot(i.TtoW1.xyz, bump),dot(i.TtoW2.xyz, bump)));
					
					fixed3 albedo = tex2D(_MainTex, i.uv.xy).rgb * _Color.rgb;

			 		fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;

			 		fixed3 diffuse =_LightColor0.rgb * albedo.rgb * saturate(dot(bump, lightDir));

			 		fixed3 halfDir = normalize(viewDir + lightDir);
			 		fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(saturate(dot(halfDir, bump)), _Gloss);
			 	
			 		fixed3 color = ambient + diffuse + specular;

			 		return fixed4(color, 1.0);
				}
				
				ENDCG
			}
		}

		FallBack "Specular"
}
