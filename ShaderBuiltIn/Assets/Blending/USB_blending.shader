Shader "Unlit/USB_blending"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color ("Tint", Color) = (1, 1, 1, 1)
        [Enum(UnityEngine.Rendering.BlendMode)] _SrcBlend ("SrcFactor", Float) = 1
        [Enum(UnityEngine.Rendering.BlendMode)] _DstBlend ("DstFactor", Float) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" }
        LOD 100

        // B = SrcFactor * SrcValue [OP] DstFactor * DstValue
        //
        // B              : cor final do fragmento
        // SrcValue       : cor que a pass atual deseja pintar o fragmento
        // DstValue       : cor do fragmento atualmente no Render Target
        // SrcFactor      : vector3 modificador de SrcValue
        // DstFactor      : vector3 modificador de DstValue
        //                | Off               : Desabilita o blending do value
        //                | One               : (1, 1, 1)
        //                | Zero              : (0, 0, 0)
        //                | SrcColor          : (SrcValue_R, SrcValue_G, SrcValue_B)
        //                | SrcAlpha          : (SrcValue_A, SrcValue_A, SrcValue_A)
        //                | OneMinusSrcColor  : (1 - SrcValue_R, 1 - SrcValue_G, 1 - SrcValue_B)
        //                | OneMinusSrcAlpha  : (1 - SrcValue_A, 1 - SrcValue_A, 1 - SrcValue_A)
        //                | DstColor          : (DstValue_R, DstValue_G, DstValue_B)
        //                | DstAlpha          : (DstValue_A, DstValue_A, DstValue_A)
        //                | OneMinusDstColor  : (1 - DstValue_R, 1 - DstValue_G, 1 - DstValue_B)
        //                | OneMinusDstAlpha  : (1 - DstValue_A, 1 - DstValue_A, 1 - DstValue_A)
        // OP (Operation) : Operação
        //                | Add
        //                | Sub
        //                | RevSub (a - b se torna b - a)
        //                | Min
        //                | Max 

        // Commands
        // BlendOp <OP>
        // Blend <SrcFactor> <DstFactor>

        BlendOp Add
        //Blend One One
        Blend [_SrcBlend] [_DstBlend]
        ZWrite Off

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
            float4 _Color;

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
                return col * _Color;
            }
            ENDCG
        }
    }
}
