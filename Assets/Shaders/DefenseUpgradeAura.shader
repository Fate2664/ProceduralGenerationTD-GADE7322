Shader "Custom/DefenseUpgradeAura"
{
    Properties
    {
        _Ring("Ring Shape", Range(0, 1)) = 0
        _Intensity("Intensity", Range(0, 3)) = 1.4
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
            #pragma vertex AuraVertex
            #pragma fragment AuraFragment
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

            float _Ring;
            float _Intensity;

            Varyings AuraVertex(Attributes input)
            {
                Varyings output;
                output.positionCS = UnityObjectToClipPos(input.positionOS);
                output.color = input.color;
                output.uv = input.uv;
                return output;
            }

            half4 AuraFragment(Varyings input) : SV_Target
            {
                float2 centeredUV = input.uv * 2.0 - 1.0;
                float radius = length(centeredUV);
                float angle = atan2(centeredUV.y, centeredUV.x);
                float band = 1.0 - smoothstep(0.018, 0.065, abs(radius - 0.78));
                float segments = smoothstep(0.15, 0.4, cos(angle * 8.0));
                float rim = 1.0 - smoothstep(0.005, 0.02, abs(radius - 0.91));
                float ring = band * (0.25 + segments * 0.75) + rim * 0.3;
                float diamond = pow(saturate(1.0 - abs(centeredUV.x) - abs(centeredUV.y)), 2.0);
                float glow = pow(saturate(1.0 - radius), 4.0) * 0.35;
                float opacity = lerp(saturate(diamond + glow), ring, _Ring);
                return half4(input.color.rgb * _Intensity, input.color.a * opacity);
            }
            ENDHLSL
        }
    }
}
