Shader "USB/USB_properties"
{
    // Common Properties
    // _name ("display name", Range(min, max)) = defaultValue;
    // _name ("display name", Float) = defaultValue;
    // _name ("display name", Int) = defaultValue;
    // _name ("display name", Color) = (R, G, B, A)
    // _name ("display name", Vector) = (0, 0, 0, 1)
    // _name ("display name", 2D) = "defaultColorTexture"
    // _name ("display name", Cube) = "defaultColorTexture"
    // _name ("display name", 3D) = "defaultColorTexture"
    
    // Property Drawers
    // [Toggle] _name ("displayName", Float) = 0 or 1 (0 off, 1 on)
    // [KeywordEnum(StateOff, State01, State02, etc...)] _name ("displayName", Float) = 0
    // [Enum(valor, id_00, valor, id_01, etc...)] _name ("displayName", Float) = 0
    // [PowerSlider(responseCurveValue)] _name ("displayName", Range (min, max)) = defaultValue
    // [IntRange] _name ("displayName", Range (min, max)) = defaultValue

    // Layout
    // [Header(title)]
    // [Space(amount)]

    Properties
    {
        [Header(Common properties)]
        _Specular ("Specular", Range(0.0, 1.1)) = 0.3
        _Factor ("Color Factor", Float) = 0.3
        _Cid ("Color id", Int) = 2
        _Color ("Tint", Color) = (1, 1, 1, 1)
        _VPos ("Vertex Position", Vector) = (0, 0, 0, 1)
        _MainTex ("Texture", 2D) = "white" {}
        _Reflection ("Reflection", Cube) = "black" {}
        _3DTexture ("3D Texture", 3D) = "white" {}

        [Space(20)]

        [Header(Drawer properties)]
        [Toggle] _Enable ("Enable ?", Float) = 0
        [KeywordEnum(Off, Red, Blue)] _Options ("Copor Options", Float) = 0
        [Enum(Off, 0, Front, 1, Back, 2)] _Face ("Face Culling", Float) = 0
        [PowerSlider(3.0)] _Brightness ("Brightness", Range (0.01, 1)) = 0.08
        [IntRange] _Samples ("Samples", Range (0, 255)) = 100
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

            // Property Drawer pragmas
            // If only one state is required to be exported and is not mutable
            #pragma shader_feature _ENABLE_ON
            // If all states are required to be exported and are mutable
            #pragma multi_compile _OPTIONS_OFF _OPTIONS_RED _OPTIONS_BLUE

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

            // Properties link variables
            float _Specular;
            float _Factor;
            int _Cid;
            float4 _Color;
            float4 _VPos;
            sampler2D _MainTex;
            float4 _MainTex_ST;
            samplerCUBE _Reflection;
            sampler3D _3DTexture;

            // Properties drawers link variables
            float _Brightness;
            int Samples;

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


                // Toggle Drawer Usage Example
                #if _ENABLE_ON
                    // do something
                #else
                    // do something else
                #endif

                // KeywordEnum Drawer Usage Example
                #if _OPTIONS_OFF
                    // do something
                #elif _OPTIONS_RED
                    // do something else
                #elif _OPTIONS_BLUE
                    // do other thing
                #endif

                return col;
            }
            ENDCG
        }
    }
}
