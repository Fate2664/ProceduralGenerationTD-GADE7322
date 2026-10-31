Shader "Custom/OutlineShader"
{
    Properties
    {
        _OutlineColor("Outline Color", Color) = (1, 0.8, 0.1, 1)
        _OutlineWidth("Outline Width", Range(0,0.15)) = 0.025
        [HideInInspector] _DefenseOutlineEnabled("Enabled", Float) = 0
        
        
    }
    

        SubShader
        {
            Tags { "RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" "Queue" = "Geometry" }

            Pass
            {
            Name "Outline"

            Tags { "LightMode" = "SRPDefaultUnlit"}

            Cull Front
            ZWrite Off
            ZTest LEqual

            HLSLPROGRAM
            #pragma vertex OutlineVertex
            #pragma fragment OutlineFragment

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            struct Attributes
            {
                float4 positionOS : POSITION;
                float3 normalOS : NORMAL;
            };

            struct Varyings
            {
                 float4 positionHCS : SV_POSITION;
            };

            CBUFFER_START(UnityPerMaterial)
                float4 _OutlineColor;
                float _OutlineWidth;
                float _DefenseOutlineEnabled;
            CBUFFER_END

            //Vertex Shader
            Varyings OutlineVertex(Attributes input)
            {
                Varyings output;
                float3 positionWS = TransformObjectToWorld(input.positionOS.xyz);
                float3 normalWS = TransformObjectToWorldNormal(input.normalOS);

                positionWS += normalWS * _OutlineWidth;
                output.positionHCS = TransformWorldToHClip(positionWS);
                return output;
            }

            //Fragment Shader
            half4 OutlineFragment(Varyings input) : SV_Target
            {
                clip(_DefenseOutlineEnabled - 0.5);
                return half4(_OutlineColor.rgb, 1.0);
            }
            ENDHLSL

        }
    }
}
