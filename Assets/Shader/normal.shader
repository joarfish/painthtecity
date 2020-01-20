// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Jonas Shaders/Normal Sprite Shader"
{
    Properties
    {		 
		_MainTex("Sprite Texture", 2D) = "white" {}
		_NormalTex("Sprite Normal Texture", 2D) = "white" {}
		_LightPosition("Light Position", Vector) = (0,0,0)
    }
    SubShader
    {
		Tags{
			"Queue" = "Transparent"
			//"IgnoreProjector" = "True"
			"RenderType" = "Opaque"
			//"PreviewType" = "Plane"
			"CanUseSpriteAtlas" = "True"
		}
        
		Cull Off
		ZWrite Off
		Blend One OneMinusSrcAlpha

        Pass
        {
			Tags {
				"LightMode" = "ForwardBase"
			}

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
				float3 world_position : TEXCOORD1;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
			sampler2D _NormalTex;
			float3 _LightPosition;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
				o.world_position = mul(unity_ObjectToWorld, v.vertex).xyz;
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
				fixed4 normal = mul(unity_ObjectToWorld, float4( (2*tex2D(_NormalTex, i.uv)-1).xyz, 0));

				float3 lightDirection = _WorldSpaceLightPos0.xyz;

				if (_WorldSpaceLightPos0.w == 0) {
					float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz - i.world_position);
				}

				float lum = max(0, dot(lightDirection, normal));

				col.rgb *= lum;

				col.rgb *= col.a;

                return col;
            }
            ENDCG
        }

		Pass
		{
			Tags {
				"LightMode" = "ForwardAdd"
			}

			Blend One One
			ZWrite Off

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float3 world_position : TEXCOORD1;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			sampler2D _NormalTex;
			float3 _LightPosition;
			float4 _MainTex_ST;

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.world_position = mul(unity_ObjectToWorld, v.vertex).xyz;
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);

				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				fixed4 normal = mul(unity_ObjectToWorld, float4((2 * tex2D(_NormalTex, i.uv) - 1).xyz, 0));

				float3 lightDirection = _WorldSpaceLightPos0.xyz;

				if (_WorldSpaceLightPos0.w == 0) {
					float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz - i.world_position);
				}

				float d = distance(_WorldSpaceLightPos0.xyz, i.world_position);
				

				float lum = max(0, dot(lightDirection, normal)) * 3.0/d;

				col.rgb *= lum;

				col.rgb *= col.a;

				return col;
			}
			ENDCG
		}
    }
}
