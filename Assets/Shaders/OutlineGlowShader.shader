Shader "Custom/OutlineGlowShader"
{
    Properties
    {
        [HDR] _OutlineColor("Outline Color", Color) = (0.1, 0.8, 1, 1)
        _OutlineWidth("Outline Width", Range(0, 0.15)) = 0.025
        _GlowIntensity("Glow Intensity", Range(0, 20)) = 4
        [Toggle] _OutlineEnabled("Outline Enabled", Float) = 0
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" "Queue" = "Geometry" }

        Pass
        {
            Name "GlowOutline"
            Tags {"LightMode" = "SRPDefaultUnlit"}
            
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
                float3 normalOS: NORMAL;
            };

            struct Varyings
            {
                float4 positionHCS : SV_POSITION;
            };

            CBUFFER_START(UnityPerMaterial)
                float4 _OutlineColor;
                float _OutlineWidth;
                float _GlowIntensity;
                float _OutlineEnabled;
            CBUFFER_END

            Varyings OutlineVertex(Attributes input)
            {
                Varyings output;
                
                float3 positionWS = TransformObjectToWorld(input.positionOS.xyz);
                float3 normalWS = TransformObjectToWorldNormal(input.normalOS);
                
                positionWS += normalWS * _OutlineWidth;
                output.positionHCS = TransformWorldToHClip(positionWS);
                
                return output;
            }

            half4 OutlineFragment(Varyings input) : SV_Target
            {
                clip(_OutlineEnabled - 0.5);
                float3 glowColor = _OutlineColor.rgb * _GlowIntensity;
                
                return half4(glowColor, 1.0);
            }
            ENDHLSL
        }
    }
}
