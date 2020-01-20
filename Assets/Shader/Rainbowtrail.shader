Shader "Unlit/Rainbowtrail"
{
    Properties
    {
        _Margin ("Margin", Range(0.0, 1.0)) = 0.8
    }
    SubShader
    {
		Tags {"Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent"}
        
		Cull Off
		ZWrite Off
		Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
            CGPROGRAM
            #pragma vertex vert alpha
            #pragma fragment frag alpha

            #include "UnityCG.cginc"

			float3 HSVtoRGB(float3 HSV)
			{
				float3 RGB = 0;
				float C = HSV.z * HSV.y;
				float H = HSV.x * 6;
				float X = C * (1 - abs(fmod(H, 2) - 1));
				if (HSV.y != 0)
				{
					float I = floor(H);
					if (I == 0) { RGB = float3(C, X, 0); }
					else if (I == 1) { RGB = float3(X, C, 0); }
					else if (I == 2) { RGB = float3(0, C, X); }
					else if (I == 3) { RGB = float3(0, X, C); }
					else if (I == 4) { RGB = float3(X, 0, C); }
					else { RGB = float3(C, 0, X); }
				}
				float M = HSV.z - C;
				return RGB + M;
			}

			float map(float v, float in_1, float in_2, float out_1, float out_2) {
				float perc = (v - in_1) / (in_2 - in_1);
				return perc * (out_2 - out_1) + in_1;
			}

			float quadBezier(float t, float b0, float b1, float b2) {
				return (b0 - 2*b1 + b2)*t*t + (-2*b0+2*b1)*t + b0;
			}

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
				float3 color_hsv : TEXCOORD1;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
			float _Margin;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;

				o.color_hsv = float3(v.uv.y, 1.0f, 1.0f);

                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
				float4 col = float4(HSVtoRGB(i.color_hsv), 1);
				float p = 2 * abs(i.uv.y - 0.5f);
				float t = map(p, _Margin, 1.0, 1.0, 0.0);
				col.a = p >= _Margin ? quadBezier(t, 0, 0.99, 1) : 1.0;
				clip(col.a);
				return col;
            }
            ENDCG
        }
    }
}
