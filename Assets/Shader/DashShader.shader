﻿Shader "ImageEffects/DashShader"
{
    Properties
    {
		_MainTex("Texture", 2D) = "white" {}
        _LastFrame ("Texture", 2D) = "white" {}
    }
    SubShader
    {
		Cull Off ZWrite Off ZTest Always
		//Tags {"Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent"}
		//Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
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
                float4 vertex : SV_POSITION;
            };

			sampler2D _MainTex;
            sampler2D _LastFrame;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
				
				fixed4 col = tex2D(_MainTex, i.uv);
				float a = col.a;
				col.x = col.x * 1.0;
				col.y = col.y * 0.1;
				col.z = col.z * 0.1;
				clip(a);
                return fixed4(col.xyz, a);
            }
            ENDCG
        }
    }
}
