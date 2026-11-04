Shader "Custom/DefenseRadiantGlow"
{
    Properties
    {
        _Intensity("Intensity", Range(0, 4)) = 1.5
        _CoreStrength("White Core", Range(0, 1)) = 0.65
        _ViewOffset("Offset Toward Camera", Range(0, 0.5)) = 0
    }

    SubShader
    {
        Tags { "Queue" = "Transparent" "RenderType" = "Transparent" }
        Blend SrcAlpha One
        Cull Off
        ZWrite Off
        ZTest LEqual

        Pass
        {
            HLSLPROGRAM
            #pragma vertex GlowVertex
            #pragma fragment GlowFragment
            #include "UnityCG.cginc"

            struct Attributes
            {
                float4 positionOS : POSITION;
                float4 color : COLOR;
                float2 uv : TEXCOORD0;
            };

            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float4 color : COLOR;
                float2 uv : TEXCOORD0;
            };

            float _Intensity;
            float _CoreStrength;
            float _ViewOffset;

            Varyings GlowVertex(Attributes input)
            {
                Varyings output;
                float3 positionWS = mul(unity_ObjectToWorld, input.positionOS).xyz;
                positionWS += UNITY_MATRIX_I_V._m02_m12_m22 * _ViewOffset;
                output.positionCS = mul(UNITY_MATRIX_VP, float4(positionWS, 1.0));
                output.color = input.color;
                output.uv = input.uv;
                return output;
            }

            half4 GlowFragment(Varyings input) : SV_Target
            {
                float2 centeredUV = input.uv * 2.0 - 1.0;
                float radiusSquared = dot(centeredUV, centeredUV);
                float core = exp2(-24.0 * radiusSquared);
                float halo = exp2(-5.0 * radiusSquared);
                float edgeFade = 1.0 - smoothstep(0.65, 1.0, radiusSquared);
                float opacity = saturate(halo * 0.7 + core * 0.6) * edgeFade;
                float3 color = lerp(input.color.rgb, float3(1.0, 1.0, 1.0), core * _CoreStrength);
                return half4(color * _Intensity, input.color.a * opacity);
            }
            ENDHLSL
        }
    }
}
