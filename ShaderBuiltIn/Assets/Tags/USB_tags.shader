Shader "Unlit/USB_tags"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }

    SubShader
    {
        Tags
        {
            //"Queue"="Background"     0~1499 default:1000
              "Queue"="Geometry"//  1500~2399 default:2000
            //"Queue"="AlphaTest"   2400~2699 default:2450
            //"Queue"="Transparent" 2700~3599 default:3000
            //"Queue"="Overlay"     3600~5000 default:4000
            
            "RenderType"="Opaque"           //default
            //"RenderType"="Transparent"
            //"RenderType"="TransparentCutout"
            //"RenderType"="Background"
            //"RenderType"="Overlay"
            //"RenderType"="TreeOpaque"
            //"RenderType"="TreeTransparentCutout"
            //"RenderType"="TreeBillboard"
            //"RenderType"="Grass"
            //"RenderType"="GrassBillboard"
        }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                fixed4 red = fixed4(1, 0, 0, 1);
                return col * red;
            }
            ENDCG
        }
    }

    SubShader
    {
        Tags
        {
            //"Queue"="Background"     0~1499 default:1000
              "Queue"="Geometry"//  1500~2399 default:2000
            //"Queue"="AlphaTest"   2400~2699 default:2450
            //"Queue"="Transparent" 2700~3599 default:3000
            //"Queue"="Overlay"     3600~5000 default:4000
            
            //"RenderType"="Opaque"           //default
            "RenderType"="Transparent"
            //"RenderType"="TransparentCutout"
            //"RenderType"="Background"
            //"RenderType"="Overlay"
            //"RenderType"="TreeOpaque"
            //"RenderType"="TreeTransparentCutout"
            //"RenderType"="TreeBillboard"
            //"RenderType"="Grass"
            //"RenderType"="GrassBillboard"
        }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                fixed4 blue = fixed4(0, 0, 1, 1);
                return col * blue;
            }
            ENDCG
        }
    }
}
