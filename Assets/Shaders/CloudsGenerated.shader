Shader "Shader Graphs/CloudShaderGenerated"
{
    Properties
    {
        _Rotate_Projection("Rotate Projection", Vector, 4) = (1, 0, 0, 0)
        _Noise_Scale("Noise Scale", Float) = 0.1
        _Noise_Speed("Noise Speed", Float) = 3
        _Noise_Height("Noise Height", Float) = 100
        _Noise_Remap("Noise Remap", Vector, 4) = (0, 1, -1, 1)
        _Color_A("Color A", Color) = (1, 1, 1, 0)
        _Color_B("Color B", Color) = (0, 0, 0, 0)
        _Smooth_Step_1("Smooth Step 1", Float) = 0
        _Smooth_Step_2("Smooth Step 2", Float) = 1
        _Noise_Power("Noise Power", Float) = 1
        _Base_Scale("Base Scale", Float) = 5
        _Base_Speed("Base Speed", Float) = 0.2
        _Base_Strength("Base Strength", Float) = 2
        _Emission_Strength("Emission Strength", Float) = 2
        _Curvature_Radius("Curvature Radius", Float) = 0
        _Fresnel_Effect_Power("Fresnel Effect Power", Float) = 1
        _Fresnel_Effect_Opacity("Fresnel Effect Opacity", Float) = 1
        _Fade_Depth("Fade Depth", Float) = 100
        [HideInInspector]_QueueOffset("_QueueOffset", Float) = 0
        [HideInInspector]_QueueControl("_QueueControl", Float) = -1
        [HideInInspector][NoScaleOffset]unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}
    }
    SubShader
    {
        Tags
        {
            "RenderPipeline"="UniversalPipeline"
            "RenderType"="Transparent"
            "UniversalMaterialType" = "Lit"
            "Queue"="Transparent"
            "DisableBatching"="False"
            "ShaderGraphShader"="true"
            "ShaderGraphTargetId"="UniversalLitSubTarget"
        }
        Pass
        {
            Name "Universal Forward"
            Tags
            {
                "LightMode" = "UniversalForward"
            }
        
        // Render State
        Cull Off
        Blend One OneMinusSrcAlpha, One OneMinusSrcAlpha
        ZTest LEqual
        ZWrite On
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma multi_compile_instancing
        #pragma instancing_options renderinglayer
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma multi_compile_fragment _ _SCREEN_SPACE_OCCLUSION
        #pragma multi_compile_fragment _ _SCREEN_SPACE_IRRADIANCE
        #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DYNAMICLIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma multi_compile _ USE_LEGACY_LIGHTMAPS
        #pragma multi_compile _ LIGHTMAP_BICUBIC_SAMPLING
        #pragma multi_compile _ REFLECTION_PROBE_ROTATION
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
        #pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
        #pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_ATLAS
        #pragma multi_compile_fragment _ _SHADOWS_SOFT _SHADOWS_SOFT_LOW _SHADOWS_SOFT_MEDIUM _SHADOWS_SOFT_HIGH
        #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
        #pragma multi_compile _ SHADOWS_SHADOWMASK
        #pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
        #pragma multi_compile_fragment _ _LIGHT_LAYERS
        #pragma multi_compile_fragment _ DEBUG_DISPLAY
        #pragma multi_compile_fragment _ _LIGHT_COOKIES
        #pragma multi_compile _ _CLUSTER_LIGHT_LOOP
        #pragma multi_compile _ EVALUATE_SH_MIXED EVALUATE_SH_VERTEX
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        #define VARYINGS_NEED_SHADOW_COORD
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_FORWARD
        #define _SURFACE_TYPE_TRANSPARENT 1
        #define _ALPHAPREMULTIPLY_ON 1
        #define REQUIRE_DEPTH_TEXTURE
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Fog.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ProbeVolumeVariants.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
             float4 probeOcclusion;
            #endif
             float4 fogFactorAndVertexLight;
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpaceNormal;
             float3 TangentSpaceNormal;
             float3 WorldSpaceViewDirection;
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 WorldSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float3 WorldSpacePosition;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV : INTERP0;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV : INTERP1;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh : INTERP2;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
             float4 probeOcclusion : INTERP3;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord : INTERP4;
            #endif
             float4 tangentWS : INTERP5;
             float4 fogFactorAndVertexLight : INTERP6;
             float3 positionWS : INTERP7;
             float3 normalWS : INTERP8;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
            output.probeOcclusion = input.probeOcclusion;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.shadowCoord;
            #endif
            output.tangentWS.xyzw = input.tangentWS;
            output.fogFactorAndVertexLight.xyzw = input.fogFactorAndVertexLight;
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
            output.probeOcclusion = input.probeOcclusion;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.shadowCoord;
            #endif
            output.tangentWS = input.tangentWS.xyzw;
            output.fogFactorAndVertexLight = input.fogFactorAndVertexLight.xyzw;
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _Rotate_Projection;
        float _Noise_Scale;
        float _Noise_Speed;
        float _Noise_Height;
        float4 _Noise_Remap;
        float4 _Color_A;
        float4 _Color_B;
        float _Smooth_Step_1;
        float _Smooth_Step_2;
        float _Noise_Power;
        float _Base_Scale;
        float _Base_Speed;
        float _Base_Strength;
        float _Emission_Strength;
        float _Curvature_Radius;
        float _Fresnel_Effect_Power;
        float _Fresnel_Effect_Opacity;
        float _Fade_Depth;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Distance_float3(float3 A, float3 B, out float Out)
        {
            Out = distance(A, B);
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
        {
            Rotation = radians(Rotation);
            float s, c;
            sincos(Rotation, s, c);
            Axis = normalize(Axis);
            Out = In * c + cross(Axis, In) * s + Axis * dot(Axis, In) * (1 - c);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
        {
            float x; Hash_Tchou_2_1_float(p, x);
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
        {
            float2 p = UV * Scale.xy;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_FresnelEffect_float(float3 Normal, float3 ViewDir, float Power, out float Out)
        {
            Out = pow((1.0 - saturate(dot(normalize(Normal), ViewDir))), Power);
        }
        
        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            if (unity_OrthoParams.w == 1.0)
            {
                Out = LinearEyeDepth(ComputeWorldSpacePosition(UV.xy, SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), UNITY_MATRIX_I_VP), UNITY_MATRIX_V);
            }
            else
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Distance_2db07498d99c49328512eaf4405dfb7d_Out_2_Float;
            Unity_Distance_float3(SHADERGRAPH_OBJECT_POSITION, IN.WorldSpacePosition, _Distance_2db07498d99c49328512eaf4405dfb7d_Out_2_Float);
            float _Property_781afe0d084b4e86ba202ae12d2df5c3_Out_0_Float = _Curvature_Radius;
            float _Divide_3a2887a0281d4fb9a0b32e1c0fa89d00_Out_2_Float;
            Unity_Divide_float(_Distance_2db07498d99c49328512eaf4405dfb7d_Out_2_Float, _Property_781afe0d084b4e86ba202ae12d2df5c3_Out_0_Float, _Divide_3a2887a0281d4fb9a0b32e1c0fa89d00_Out_2_Float);
            float _Power_dae4028a0ef04cc885209d872784f592_Out_2_Float;
            Unity_Power_float(_Divide_3a2887a0281d4fb9a0b32e1c0fa89d00_Out_2_Float, float(3), _Power_dae4028a0ef04cc885209d872784f592_Out_2_Float);
            float3 _Multiply_ff35d2ab09754f1c8b2fac2015de70db_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.WorldSpaceNormal, (_Power_dae4028a0ef04cc885209d872784f592_Out_2_Float.xxx), _Multiply_ff35d2ab09754f1c8b2fac2015de70db_Out_2_Vector3);
            float _Property_f05727b79c2d491a8b9c2d8417d4ce68_Out_0_Float = _Smooth_Step_1;
            float _Property_7d43401174f8413091e457476f00d1aa_Out_0_Float = _Smooth_Step_2;
            float4 _Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4 = _Rotate_Projection;
            float _Split_610d0b28a0e94e38b42626a03d9f9794_R_1_Float = _Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4[0];
            float _Split_610d0b28a0e94e38b42626a03d9f9794_G_2_Float = _Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4[1];
            float _Split_610d0b28a0e94e38b42626a03d9f9794_B_3_Float = _Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4[2];
            float _Split_610d0b28a0e94e38b42626a03d9f9794_A_4_Float = _Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4[3];
            float3 _RotateAboutAxis_a415e5a75c24452bbcd60ac1b3811fc6_Out_3_Vector3;
            Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4.xyz), _Split_610d0b28a0e94e38b42626a03d9f9794_A_4_Float, _RotateAboutAxis_a415e5a75c24452bbcd60ac1b3811fc6_Out_3_Vector3);
            float _Property_2ada180c9afb42be8c587ae354b92988_Out_0_Float = _Noise_Speed;
            float _Multiply_ab217b8df9084424b472a49bafb4515d_Out_2_Float;
            Unity_Multiply_float_float(_Property_2ada180c9afb42be8c587ae354b92988_Out_0_Float, IN.TimeParameters.x, _Multiply_ab217b8df9084424b472a49bafb4515d_Out_2_Float);
            float2 _TilingAndOffset_0b468c25d4d14a999d61900af42dd09d_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_a415e5a75c24452bbcd60ac1b3811fc6_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_ab217b8df9084424b472a49bafb4515d_Out_2_Float.xx), _TilingAndOffset_0b468c25d4d14a999d61900af42dd09d_Out_3_Vector2);
            float _Property_4cdc099c195e4d6a8f9f35604045d0b7_Out_0_Float = _Noise_Scale;
            float _GradientNoise_26bc13aecb1b4c2081638300cc42b01d_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_0b468c25d4d14a999d61900af42dd09d_Out_3_Vector2, _Property_4cdc099c195e4d6a8f9f35604045d0b7_Out_0_Float, _GradientNoise_26bc13aecb1b4c2081638300cc42b01d_Out_2_Float);
            float2 _TilingAndOffset_88de901db4e14268b84877dc201207b6_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_a415e5a75c24452bbcd60ac1b3811fc6_Out_3_Vector3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_88de901db4e14268b84877dc201207b6_Out_3_Vector2);
            float _GradientNoise_aa58bf81bf93430985a301e296a23ad8_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_88de901db4e14268b84877dc201207b6_Out_3_Vector2, _Property_4cdc099c195e4d6a8f9f35604045d0b7_Out_0_Float, _GradientNoise_aa58bf81bf93430985a301e296a23ad8_Out_2_Float);
            float _Add_7767c92e2dbe4c9e8ec3922a6c504040_Out_2_Float;
            Unity_Add_float(_GradientNoise_26bc13aecb1b4c2081638300cc42b01d_Out_2_Float, _GradientNoise_aa58bf81bf93430985a301e296a23ad8_Out_2_Float, _Add_7767c92e2dbe4c9e8ec3922a6c504040_Out_2_Float);
            float _Divide_01c8ce94962043679abea203c1772a79_Out_2_Float;
            Unity_Divide_float(_Add_7767c92e2dbe4c9e8ec3922a6c504040_Out_2_Float, float(2), _Divide_01c8ce94962043679abea203c1772a79_Out_2_Float);
            float _Saturate_bf00c156675b44cd9168e9493fa1fa61_Out_1_Float;
            Unity_Saturate_float(_Divide_01c8ce94962043679abea203c1772a79_Out_2_Float, _Saturate_bf00c156675b44cd9168e9493fa1fa61_Out_1_Float);
            float _Property_b932cc0b0679463495ea24f5ae20fe0a_Out_0_Float = _Noise_Power;
            float _Power_bc99b52173a44811b5a653f85b30e92b_Out_2_Float;
            Unity_Power_float(_Saturate_bf00c156675b44cd9168e9493fa1fa61_Out_1_Float, _Property_b932cc0b0679463495ea24f5ae20fe0a_Out_0_Float, _Power_bc99b52173a44811b5a653f85b30e92b_Out_2_Float);
            float4 _Property_e85e1549c7ea4dc8be0b5d3469565ffd_Out_0_Vector4 = _Noise_Remap;
            float _Split_10eb25ab4f03492b8209300701e5f945_R_1_Float = _Property_e85e1549c7ea4dc8be0b5d3469565ffd_Out_0_Vector4[0];
            float _Split_10eb25ab4f03492b8209300701e5f945_G_2_Float = _Property_e85e1549c7ea4dc8be0b5d3469565ffd_Out_0_Vector4[1];
            float _Split_10eb25ab4f03492b8209300701e5f945_B_3_Float = _Property_e85e1549c7ea4dc8be0b5d3469565ffd_Out_0_Vector4[2];
            float _Split_10eb25ab4f03492b8209300701e5f945_A_4_Float = _Property_e85e1549c7ea4dc8be0b5d3469565ffd_Out_0_Vector4[3];
            float4 _Combine_edb179662e1a4052b97e671dbd3421a5_RGBA_4_Vector4;
            float3 _Combine_edb179662e1a4052b97e671dbd3421a5_RGB_5_Vector3;
            float2 _Combine_edb179662e1a4052b97e671dbd3421a5_RG_6_Vector2;
            Unity_Combine_float(_Split_10eb25ab4f03492b8209300701e5f945_R_1_Float, _Split_10eb25ab4f03492b8209300701e5f945_G_2_Float, float(0), float(0), _Combine_edb179662e1a4052b97e671dbd3421a5_RGBA_4_Vector4, _Combine_edb179662e1a4052b97e671dbd3421a5_RGB_5_Vector3, _Combine_edb179662e1a4052b97e671dbd3421a5_RG_6_Vector2);
            float4 _Combine_f12ac3a1b10f4f388dab86453258dcb0_RGBA_4_Vector4;
            float3 _Combine_f12ac3a1b10f4f388dab86453258dcb0_RGB_5_Vector3;
            float2 _Combine_f12ac3a1b10f4f388dab86453258dcb0_RG_6_Vector2;
            Unity_Combine_float(_Split_10eb25ab4f03492b8209300701e5f945_B_3_Float, _Split_10eb25ab4f03492b8209300701e5f945_A_4_Float, float(0), float(0), _Combine_f12ac3a1b10f4f388dab86453258dcb0_RGBA_4_Vector4, _Combine_f12ac3a1b10f4f388dab86453258dcb0_RGB_5_Vector3, _Combine_f12ac3a1b10f4f388dab86453258dcb0_RG_6_Vector2);
            float _Remap_b473bb8bd2254a3faad5291ff8cb7707_Out_3_Float;
            Unity_Remap_float(_Power_bc99b52173a44811b5a653f85b30e92b_Out_2_Float, _Combine_edb179662e1a4052b97e671dbd3421a5_RG_6_Vector2, _Combine_f12ac3a1b10f4f388dab86453258dcb0_RG_6_Vector2, _Remap_b473bb8bd2254a3faad5291ff8cb7707_Out_3_Float);
            float _Absolute_2367964a3dae475891ccd6c90e2885ff_Out_1_Float;
            Unity_Absolute_float(_Remap_b473bb8bd2254a3faad5291ff8cb7707_Out_3_Float, _Absolute_2367964a3dae475891ccd6c90e2885ff_Out_1_Float);
            float _Smoothstep_516feede7acb4f97b595cd89bba389c4_Out_3_Float;
            Unity_Smoothstep_float(_Property_f05727b79c2d491a8b9c2d8417d4ce68_Out_0_Float, _Property_7d43401174f8413091e457476f00d1aa_Out_0_Float, _Absolute_2367964a3dae475891ccd6c90e2885ff_Out_1_Float, _Smoothstep_516feede7acb4f97b595cd89bba389c4_Out_3_Float);
            float _Property_44e53f25d86f4edbaab4f19b6daaa067_Out_0_Float = _Base_Speed;
            float _Multiply_619aff87dcc446c5968bd1a6d44fe8b7_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_44e53f25d86f4edbaab4f19b6daaa067_Out_0_Float, _Multiply_619aff87dcc446c5968bd1a6d44fe8b7_Out_2_Float);
            float2 _TilingAndOffset_7cbf9da6c23b409fb98e46b72acb3373_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_a415e5a75c24452bbcd60ac1b3811fc6_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_619aff87dcc446c5968bd1a6d44fe8b7_Out_2_Float.xx), _TilingAndOffset_7cbf9da6c23b409fb98e46b72acb3373_Out_3_Vector2);
            float _Property_9254f8e15d6447988ec18cd37fe88bdc_Out_0_Float = _Base_Scale;
            float _GradientNoise_ce38dcc651b44efeb82145bfdadbf1fa_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_7cbf9da6c23b409fb98e46b72acb3373_Out_3_Vector2, _Property_9254f8e15d6447988ec18cd37fe88bdc_Out_0_Float, _GradientNoise_ce38dcc651b44efeb82145bfdadbf1fa_Out_2_Float);
            float _Property_56d73ff99ec94119881f3d643422251a_Out_0_Float = _Base_Strength;
            float _Multiply_a28097e44d4c485a867948d5b27a71aa_Out_2_Float;
            Unity_Multiply_float_float(_GradientNoise_ce38dcc651b44efeb82145bfdadbf1fa_Out_2_Float, _Property_56d73ff99ec94119881f3d643422251a_Out_0_Float, _Multiply_a28097e44d4c485a867948d5b27a71aa_Out_2_Float);
            float _Add_c6fbda241fda4ff68e2e16893549192e_Out_2_Float;
            Unity_Add_float(_Smoothstep_516feede7acb4f97b595cd89bba389c4_Out_3_Float, _Multiply_a28097e44d4c485a867948d5b27a71aa_Out_2_Float, _Add_c6fbda241fda4ff68e2e16893549192e_Out_2_Float);
            float _Add_5d9343a646914b1582c5ac00b2068a54_Out_2_Float;
            Unity_Add_float(float(0), _Property_56d73ff99ec94119881f3d643422251a_Out_0_Float, _Add_5d9343a646914b1582c5ac00b2068a54_Out_2_Float);
            float _Divide_fe411acd94ed4c4c83892bba30255329_Out_2_Float;
            Unity_Divide_float(_Add_c6fbda241fda4ff68e2e16893549192e_Out_2_Float, _Add_5d9343a646914b1582c5ac00b2068a54_Out_2_Float, _Divide_fe411acd94ed4c4c83892bba30255329_Out_2_Float);
            float3 _Multiply_b525aac067b04a9a8f9ce1a4c4716765_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.ObjectSpaceNormal, (_Divide_fe411acd94ed4c4c83892bba30255329_Out_2_Float.xxx), _Multiply_b525aac067b04a9a8f9ce1a4c4716765_Out_2_Vector3);
            float _Property_81343da7ab424f29a124d673b8099601_Out_0_Float = _Noise_Height;
            float3 _Multiply_431791af81b04fe4920287cee8e84b36_Out_2_Vector3;
            Unity_Multiply_float3_float3(_Multiply_b525aac067b04a9a8f9ce1a4c4716765_Out_2_Vector3, (_Property_81343da7ab424f29a124d673b8099601_Out_0_Float.xxx), _Multiply_431791af81b04fe4920287cee8e84b36_Out_2_Vector3);
            float3 _Add_e716c01d530b428c8bcb16ba04bed031_Out_2_Vector3;
            Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_431791af81b04fe4920287cee8e84b36_Out_2_Vector3, _Add_e716c01d530b428c8bcb16ba04bed031_Out_2_Vector3);
            float3 _Add_fc53f37eba984ae88bea18cd54a386d0_Out_2_Vector3;
            Unity_Add_float3(_Multiply_ff35d2ab09754f1c8b2fac2015de70db_Out_2_Vector3, _Add_e716c01d530b428c8bcb16ba04bed031_Out_2_Vector3, _Add_fc53f37eba984ae88bea18cd54a386d0_Out_2_Vector3);
            description.Position = _Add_fc53f37eba984ae88bea18cd54a386d0_Out_2_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float3 NormalTS;
            float3 Emission;
            float Metallic;
            float Smoothness;
            float Occlusion;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_08f55cc2215f457abdf288e58daaa696_Out_0_Vector4 = _Color_A;
            float4 _Property_acbafd3dca104c65b7b71611d4639044_Out_0_Vector4 = _Color_B;
            float _Property_f05727b79c2d491a8b9c2d8417d4ce68_Out_0_Float = _Smooth_Step_1;
            float _Property_7d43401174f8413091e457476f00d1aa_Out_0_Float = _Smooth_Step_2;
            float4 _Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4 = _Rotate_Projection;
            float _Split_610d0b28a0e94e38b42626a03d9f9794_R_1_Float = _Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4[0];
            float _Split_610d0b28a0e94e38b42626a03d9f9794_G_2_Float = _Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4[1];
            float _Split_610d0b28a0e94e38b42626a03d9f9794_B_3_Float = _Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4[2];
            float _Split_610d0b28a0e94e38b42626a03d9f9794_A_4_Float = _Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4[3];
            float3 _RotateAboutAxis_a415e5a75c24452bbcd60ac1b3811fc6_Out_3_Vector3;
            Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4.xyz), _Split_610d0b28a0e94e38b42626a03d9f9794_A_4_Float, _RotateAboutAxis_a415e5a75c24452bbcd60ac1b3811fc6_Out_3_Vector3);
            float _Property_2ada180c9afb42be8c587ae354b92988_Out_0_Float = _Noise_Speed;
            float _Multiply_ab217b8df9084424b472a49bafb4515d_Out_2_Float;
            Unity_Multiply_float_float(_Property_2ada180c9afb42be8c587ae354b92988_Out_0_Float, IN.TimeParameters.x, _Multiply_ab217b8df9084424b472a49bafb4515d_Out_2_Float);
            float2 _TilingAndOffset_0b468c25d4d14a999d61900af42dd09d_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_a415e5a75c24452bbcd60ac1b3811fc6_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_ab217b8df9084424b472a49bafb4515d_Out_2_Float.xx), _TilingAndOffset_0b468c25d4d14a999d61900af42dd09d_Out_3_Vector2);
            float _Property_4cdc099c195e4d6a8f9f35604045d0b7_Out_0_Float = _Noise_Scale;
            float _GradientNoise_26bc13aecb1b4c2081638300cc42b01d_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_0b468c25d4d14a999d61900af42dd09d_Out_3_Vector2, _Property_4cdc099c195e4d6a8f9f35604045d0b7_Out_0_Float, _GradientNoise_26bc13aecb1b4c2081638300cc42b01d_Out_2_Float);
            float2 _TilingAndOffset_88de901db4e14268b84877dc201207b6_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_a415e5a75c24452bbcd60ac1b3811fc6_Out_3_Vector3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_88de901db4e14268b84877dc201207b6_Out_3_Vector2);
            float _GradientNoise_aa58bf81bf93430985a301e296a23ad8_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_88de901db4e14268b84877dc201207b6_Out_3_Vector2, _Property_4cdc099c195e4d6a8f9f35604045d0b7_Out_0_Float, _GradientNoise_aa58bf81bf93430985a301e296a23ad8_Out_2_Float);
            float _Add_7767c92e2dbe4c9e8ec3922a6c504040_Out_2_Float;
            Unity_Add_float(_GradientNoise_26bc13aecb1b4c2081638300cc42b01d_Out_2_Float, _GradientNoise_aa58bf81bf93430985a301e296a23ad8_Out_2_Float, _Add_7767c92e2dbe4c9e8ec3922a6c504040_Out_2_Float);
            float _Divide_01c8ce94962043679abea203c1772a79_Out_2_Float;
            Unity_Divide_float(_Add_7767c92e2dbe4c9e8ec3922a6c504040_Out_2_Float, float(2), _Divide_01c8ce94962043679abea203c1772a79_Out_2_Float);
            float _Saturate_bf00c156675b44cd9168e9493fa1fa61_Out_1_Float;
            Unity_Saturate_float(_Divide_01c8ce94962043679abea203c1772a79_Out_2_Float, _Saturate_bf00c156675b44cd9168e9493fa1fa61_Out_1_Float);
            float _Property_b932cc0b0679463495ea24f5ae20fe0a_Out_0_Float = _Noise_Power;
            float _Power_bc99b52173a44811b5a653f85b30e92b_Out_2_Float;
            Unity_Power_float(_Saturate_bf00c156675b44cd9168e9493fa1fa61_Out_1_Float, _Property_b932cc0b0679463495ea24f5ae20fe0a_Out_0_Float, _Power_bc99b52173a44811b5a653f85b30e92b_Out_2_Float);
            float4 _Property_e85e1549c7ea4dc8be0b5d3469565ffd_Out_0_Vector4 = _Noise_Remap;
            float _Split_10eb25ab4f03492b8209300701e5f945_R_1_Float = _Property_e85e1549c7ea4dc8be0b5d3469565ffd_Out_0_Vector4[0];
            float _Split_10eb25ab4f03492b8209300701e5f945_G_2_Float = _Property_e85e1549c7ea4dc8be0b5d3469565ffd_Out_0_Vector4[1];
            float _Split_10eb25ab4f03492b8209300701e5f945_B_3_Float = _Property_e85e1549c7ea4dc8be0b5d3469565ffd_Out_0_Vector4[2];
            float _Split_10eb25ab4f03492b8209300701e5f945_A_4_Float = _Property_e85e1549c7ea4dc8be0b5d3469565ffd_Out_0_Vector4[3];
            float4 _Combine_edb179662e1a4052b97e671dbd3421a5_RGBA_4_Vector4;
            float3 _Combine_edb179662e1a4052b97e671dbd3421a5_RGB_5_Vector3;
            float2 _Combine_edb179662e1a4052b97e671dbd3421a5_RG_6_Vector2;
            Unity_Combine_float(_Split_10eb25ab4f03492b8209300701e5f945_R_1_Float, _Split_10eb25ab4f03492b8209300701e5f945_G_2_Float, float(0), float(0), _Combine_edb179662e1a4052b97e671dbd3421a5_RGBA_4_Vector4, _Combine_edb179662e1a4052b97e671dbd3421a5_RGB_5_Vector3, _Combine_edb179662e1a4052b97e671dbd3421a5_RG_6_Vector2);
            float4 _Combine_f12ac3a1b10f4f388dab86453258dcb0_RGBA_4_Vector4;
            float3 _Combine_f12ac3a1b10f4f388dab86453258dcb0_RGB_5_Vector3;
            float2 _Combine_f12ac3a1b10f4f388dab86453258dcb0_RG_6_Vector2;
            Unity_Combine_float(_Split_10eb25ab4f03492b8209300701e5f945_B_3_Float, _Split_10eb25ab4f03492b8209300701e5f945_A_4_Float, float(0), float(0), _Combine_f12ac3a1b10f4f388dab86453258dcb0_RGBA_4_Vector4, _Combine_f12ac3a1b10f4f388dab86453258dcb0_RGB_5_Vector3, _Combine_f12ac3a1b10f4f388dab86453258dcb0_RG_6_Vector2);
            float _Remap_b473bb8bd2254a3faad5291ff8cb7707_Out_3_Float;
            Unity_Remap_float(_Power_bc99b52173a44811b5a653f85b30e92b_Out_2_Float, _Combine_edb179662e1a4052b97e671dbd3421a5_RG_6_Vector2, _Combine_f12ac3a1b10f4f388dab86453258dcb0_RG_6_Vector2, _Remap_b473bb8bd2254a3faad5291ff8cb7707_Out_3_Float);
            float _Absolute_2367964a3dae475891ccd6c90e2885ff_Out_1_Float;
            Unity_Absolute_float(_Remap_b473bb8bd2254a3faad5291ff8cb7707_Out_3_Float, _Absolute_2367964a3dae475891ccd6c90e2885ff_Out_1_Float);
            float _Smoothstep_516feede7acb4f97b595cd89bba389c4_Out_3_Float;
            Unity_Smoothstep_float(_Property_f05727b79c2d491a8b9c2d8417d4ce68_Out_0_Float, _Property_7d43401174f8413091e457476f00d1aa_Out_0_Float, _Absolute_2367964a3dae475891ccd6c90e2885ff_Out_1_Float, _Smoothstep_516feede7acb4f97b595cd89bba389c4_Out_3_Float);
            float _Property_44e53f25d86f4edbaab4f19b6daaa067_Out_0_Float = _Base_Speed;
            float _Multiply_619aff87dcc446c5968bd1a6d44fe8b7_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_44e53f25d86f4edbaab4f19b6daaa067_Out_0_Float, _Multiply_619aff87dcc446c5968bd1a6d44fe8b7_Out_2_Float);
            float2 _TilingAndOffset_7cbf9da6c23b409fb98e46b72acb3373_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_a415e5a75c24452bbcd60ac1b3811fc6_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_619aff87dcc446c5968bd1a6d44fe8b7_Out_2_Float.xx), _TilingAndOffset_7cbf9da6c23b409fb98e46b72acb3373_Out_3_Vector2);
            float _Property_9254f8e15d6447988ec18cd37fe88bdc_Out_0_Float = _Base_Scale;
            float _GradientNoise_ce38dcc651b44efeb82145bfdadbf1fa_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_7cbf9da6c23b409fb98e46b72acb3373_Out_3_Vector2, _Property_9254f8e15d6447988ec18cd37fe88bdc_Out_0_Float, _GradientNoise_ce38dcc651b44efeb82145bfdadbf1fa_Out_2_Float);
            float _Property_56d73ff99ec94119881f3d643422251a_Out_0_Float = _Base_Strength;
            float _Multiply_a28097e44d4c485a867948d5b27a71aa_Out_2_Float;
            Unity_Multiply_float_float(_GradientNoise_ce38dcc651b44efeb82145bfdadbf1fa_Out_2_Float, _Property_56d73ff99ec94119881f3d643422251a_Out_0_Float, _Multiply_a28097e44d4c485a867948d5b27a71aa_Out_2_Float);
            float _Add_c6fbda241fda4ff68e2e16893549192e_Out_2_Float;
            Unity_Add_float(_Smoothstep_516feede7acb4f97b595cd89bba389c4_Out_3_Float, _Multiply_a28097e44d4c485a867948d5b27a71aa_Out_2_Float, _Add_c6fbda241fda4ff68e2e16893549192e_Out_2_Float);
            float _Add_5d9343a646914b1582c5ac00b2068a54_Out_2_Float;
            Unity_Add_float(float(0), _Property_56d73ff99ec94119881f3d643422251a_Out_0_Float, _Add_5d9343a646914b1582c5ac00b2068a54_Out_2_Float);
            float _Divide_fe411acd94ed4c4c83892bba30255329_Out_2_Float;
            Unity_Divide_float(_Add_c6fbda241fda4ff68e2e16893549192e_Out_2_Float, _Add_5d9343a646914b1582c5ac00b2068a54_Out_2_Float, _Divide_fe411acd94ed4c4c83892bba30255329_Out_2_Float);
            float4 _Lerp_aaaae5c0660549cda8a2edb7a84e8dbb_Out_3_Vector4;
            Unity_Lerp_float4(_Property_08f55cc2215f457abdf288e58daaa696_Out_0_Vector4, _Property_acbafd3dca104c65b7b71611d4639044_Out_0_Vector4, (_Divide_fe411acd94ed4c4c83892bba30255329_Out_2_Float.xxxx), _Lerp_aaaae5c0660549cda8a2edb7a84e8dbb_Out_3_Vector4);
            float _Property_f89c537fda1b403396d59ec61a8b35e5_Out_0_Float = _Fresnel_Effect_Power;
            float _FresnelEffect_f9c84f0b8ff24646bb5cc9ba3035a272_Out_3_Float;
            Unity_FresnelEffect_float(IN.WorldSpaceNormal, IN.WorldSpaceViewDirection, _Property_f89c537fda1b403396d59ec61a8b35e5_Out_0_Float, _FresnelEffect_f9c84f0b8ff24646bb5cc9ba3035a272_Out_3_Float);
            float _Multiply_1bbed182421f4aa8b0945b4daa798b00_Out_2_Float;
            Unity_Multiply_float_float(_Divide_fe411acd94ed4c4c83892bba30255329_Out_2_Float, _FresnelEffect_f9c84f0b8ff24646bb5cc9ba3035a272_Out_3_Float, _Multiply_1bbed182421f4aa8b0945b4daa798b00_Out_2_Float);
            float _Property_303037adb92e43f8a9f46c95f99d6c48_Out_0_Float = _Fresnel_Effect_Opacity;
            float _Multiply_f635d3e8fd1d4391a3dac582c550363f_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_1bbed182421f4aa8b0945b4daa798b00_Out_2_Float, _Property_303037adb92e43f8a9f46c95f99d6c48_Out_0_Float, _Multiply_f635d3e8fd1d4391a3dac582c550363f_Out_2_Float);
            float4 _Add_d7735e7c08de490697e89ff0870bf268_Out_2_Vector4;
            Unity_Add_float4(_Lerp_aaaae5c0660549cda8a2edb7a84e8dbb_Out_3_Vector4, (_Multiply_f635d3e8fd1d4391a3dac582c550363f_Out_2_Float.xxxx), _Add_d7735e7c08de490697e89ff0870bf268_Out_2_Vector4);
            float _Property_9710070004144fc9be45a2565e9ea4ed_Out_0_Float = _Emission_Strength;
            float4 _Multiply_0b1503eba4ae4a5a9ebe8075c9437c3b_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Add_d7735e7c08de490697e89ff0870bf268_Out_2_Vector4, (_Property_9710070004144fc9be45a2565e9ea4ed_Out_0_Float.xxxx), _Multiply_0b1503eba4ae4a5a9ebe8075c9437c3b_Out_2_Vector4);
            float _SceneDepth_7a3cc358e0f44107b8bce7383895b953_Out_1_Float;
            Unity_SceneDepth_Eye_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_7a3cc358e0f44107b8bce7383895b953_Out_1_Float);
            float4 _ScreenPosition_344727010a4a40389b6dd34b4b9b2ac3_Out_0_Vector4 = IN.ScreenPosition;
            float _Split_acb0902b83d148e2a31506c594db0146_R_1_Float = _ScreenPosition_344727010a4a40389b6dd34b4b9b2ac3_Out_0_Vector4[0];
            float _Split_acb0902b83d148e2a31506c594db0146_G_2_Float = _ScreenPosition_344727010a4a40389b6dd34b4b9b2ac3_Out_0_Vector4[1];
            float _Split_acb0902b83d148e2a31506c594db0146_B_3_Float = _ScreenPosition_344727010a4a40389b6dd34b4b9b2ac3_Out_0_Vector4[2];
            float _Split_acb0902b83d148e2a31506c594db0146_A_4_Float = _ScreenPosition_344727010a4a40389b6dd34b4b9b2ac3_Out_0_Vector4[3];
            float _Subtract_3db7c3ced20d44b3a55e93b8d56c3fc1_Out_2_Float;
            Unity_Subtract_float(_Split_acb0902b83d148e2a31506c594db0146_A_4_Float, float(1), _Subtract_3db7c3ced20d44b3a55e93b8d56c3fc1_Out_2_Float);
            float _Subtract_0b683ae745b74caaa4830cb31795132a_Out_2_Float;
            Unity_Subtract_float(_SceneDepth_7a3cc358e0f44107b8bce7383895b953_Out_1_Float, _Subtract_3db7c3ced20d44b3a55e93b8d56c3fc1_Out_2_Float, _Subtract_0b683ae745b74caaa4830cb31795132a_Out_2_Float);
            float _Property_13ffae534f05496e8446dd4eff4d54b3_Out_0_Float = _Fade_Depth;
            float _Divide_5ea1c32f7a9541ce96555bb9c53dad4e_Out_2_Float;
            Unity_Divide_float(_Subtract_0b683ae745b74caaa4830cb31795132a_Out_2_Float, _Property_13ffae534f05496e8446dd4eff4d54b3_Out_0_Float, _Divide_5ea1c32f7a9541ce96555bb9c53dad4e_Out_2_Float);
            float _Saturate_11cb953c9f3a4ad98649c8032095e0a5_Out_1_Float;
            Unity_Saturate_float(_Divide_5ea1c32f7a9541ce96555bb9c53dad4e_Out_2_Float, _Saturate_11cb953c9f3a4ad98649c8032095e0a5_Out_1_Float);
            float _Smoothstep_804d457501334adcb743390e55365a80_Out_3_Float;
            Unity_Smoothstep_float(float(0), float(1), _Saturate_11cb953c9f3a4ad98649c8032095e0a5_Out_1_Float, _Smoothstep_804d457501334adcb743390e55365a80_Out_3_Float);
            surface.BaseColor = (_Lerp_aaaae5c0660549cda8a2edb7a84e8dbb_Out_3_Vector4.xyz);
            surface.NormalTS = IN.TangentSpaceNormal;
            surface.Emission = (_Multiply_0b1503eba4ae4a5a9ebe8075c9437c3b_Out_2_Vector4.xyz);
            surface.Metallic = float(0);
            surface.Smoothness = float(0.5);
            surface.Occlusion = float(1);
            surface.Alpha = _Smoothstep_804d457501334adcb743390e55365a80_Out_3_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.WorldSpaceNormal =                           TransformObjectToWorldNormal(input.normalOS);
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.WorldSpacePosition =                         TransformObjectToWorld(input.positionOS);
            output.TimeParameters =                             _TimeParameters.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
            // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
            float3 unnormalizedNormalWS = input.normalWS;
            const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        
        
            output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        
        
            output.WorldSpaceViewDirection = GetWorldSpaceNormalizeViewDir(input.positionWS);
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRForwardPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "GBuffer"
            Tags
            {
                "LightMode" = "UniversalGBuffer"
            }
        
        // Render State
        Cull Off
        Blend One OneMinusSrcAlpha, One OneMinusSrcAlpha
        ZTest LEqual
        ZWrite On
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 4.5
        #pragma exclude_renderers gles3 glcore
        #pragma multi_compile_instancing
        #pragma instancing_options renderinglayer
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma multi_compile_fragment _ _SCREEN_SPACE_IRRADIANCE
        #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DYNAMICLIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma multi_compile _ USE_LEGACY_LIGHTMAPS
        #pragma multi_compile _ LIGHTMAP_BICUBIC_SAMPLING
        #pragma multi_compile _ REFLECTION_PROBE_ROTATION
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
        #pragma multi_compile_fragment _ _SHADOWS_SOFT _SHADOWS_SOFT_LOW _SHADOWS_SOFT_MEDIUM _SHADOWS_SOFT_HIGH
        #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
        #pragma multi_compile _ SHADOWS_SHADOWMASK
        #pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE
        #pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
        #pragma multi_compile_fragment _ _GBUFFER_NORMALS_OCT
        #pragma multi_compile_fragment _ _RENDER_PASS_ENABLED
        #pragma multi_compile_fragment _ DEBUG_DISPLAY
        #pragma multi_compile _ _CLUSTER_LIGHT_LOOP
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        #define VARYINGS_NEED_SHADOW_COORD
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_GBUFFER
        #define _FOG_FRAGMENT 1
        #define _SURFACE_TYPE_TRANSPARENT 1
        #define _ALPHAPREMULTIPLY_ON 1
        #define REQUIRE_DEPTH_TEXTURE
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Fog.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ProbeVolumeVariants.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
             float4 probeOcclusion;
            #endif
             float4 fogFactorAndVertexLight;
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpaceNormal;
             float3 TangentSpaceNormal;
             float3 WorldSpaceViewDirection;
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 WorldSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float3 WorldSpacePosition;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV : INTERP0;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV : INTERP1;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh : INTERP2;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
             float4 probeOcclusion : INTERP3;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord : INTERP4;
            #endif
             float4 tangentWS : INTERP5;
             float4 fogFactorAndVertexLight : INTERP6;
             float3 positionWS : INTERP7;
             float3 normalWS : INTERP8;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
            output.probeOcclusion = input.probeOcclusion;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.shadowCoord;
            #endif
            output.tangentWS.xyzw = input.tangentWS;
            output.fogFactorAndVertexLight.xyzw = input.fogFactorAndVertexLight;
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
            output.probeOcclusion = input.probeOcclusion;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.shadowCoord;
            #endif
            output.tangentWS = input.tangentWS.xyzw;
            output.fogFactorAndVertexLight = input.fogFactorAndVertexLight.xyzw;
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _Rotate_Projection;
        float _Noise_Scale;
        float _Noise_Speed;
        float _Noise_Height;
        float4 _Noise_Remap;
        float4 _Color_A;
        float4 _Color_B;
        float _Smooth_Step_1;
        float _Smooth_Step_2;
        float _Noise_Power;
        float _Base_Scale;
        float _Base_Speed;
        float _Base_Strength;
        float _Emission_Strength;
        float _Curvature_Radius;
        float _Fresnel_Effect_Power;
        float _Fresnel_Effect_Opacity;
        float _Fade_Depth;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Distance_float3(float3 A, float3 B, out float Out)
        {
            Out = distance(A, B);
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
        {
            Rotation = radians(Rotation);
            float s, c;
            sincos(Rotation, s, c);
            Axis = normalize(Axis);
            Out = In * c + cross(Axis, In) * s + Axis * dot(Axis, In) * (1 - c);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
        {
            float x; Hash_Tchou_2_1_float(p, x);
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
        {
            float2 p = UV * Scale.xy;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_FresnelEffect_float(float3 Normal, float3 ViewDir, float Power, out float Out)
        {
            Out = pow((1.0 - saturate(dot(normalize(Normal), ViewDir))), Power);
        }
        
        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            if (unity_OrthoParams.w == 1.0)
            {
                Out = LinearEyeDepth(ComputeWorldSpacePosition(UV.xy, SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), UNITY_MATRIX_I_VP), UNITY_MATRIX_V);
            }
            else
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Distance_2db07498d99c49328512eaf4405dfb7d_Out_2_Float;
            Unity_Distance_float3(SHADERGRAPH_OBJECT_POSITION, IN.WorldSpacePosition, _Distance_2db07498d99c49328512eaf4405dfb7d_Out_2_Float);
            float _Property_781afe0d084b4e86ba202ae12d2df5c3_Out_0_Float = _Curvature_Radius;
            float _Divide_3a2887a0281d4fb9a0b32e1c0fa89d00_Out_2_Float;
            Unity_Divide_float(_Distance_2db07498d99c49328512eaf4405dfb7d_Out_2_Float, _Property_781afe0d084b4e86ba202ae12d2df5c3_Out_0_Float, _Divide_3a2887a0281d4fb9a0b32e1c0fa89d00_Out_2_Float);
            float _Power_dae4028a0ef04cc885209d872784f592_Out_2_Float;
            Unity_Power_float(_Divide_3a2887a0281d4fb9a0b32e1c0fa89d00_Out_2_Float, float(3), _Power_dae4028a0ef04cc885209d872784f592_Out_2_Float);
            float3 _Multiply_ff35d2ab09754f1c8b2fac2015de70db_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.WorldSpaceNormal, (_Power_dae4028a0ef04cc885209d872784f592_Out_2_Float.xxx), _Multiply_ff35d2ab09754f1c8b2fac2015de70db_Out_2_Vector3);
            float _Property_f05727b79c2d491a8b9c2d8417d4ce68_Out_0_Float = _Smooth_Step_1;
            float _Property_7d43401174f8413091e457476f00d1aa_Out_0_Float = _Smooth_Step_2;
            float4 _Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4 = _Rotate_Projection;
            float _Split_610d0b28a0e94e38b42626a03d9f9794_R_1_Float = _Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4[0];
            float _Split_610d0b28a0e94e38b42626a03d9f9794_G_2_Float = _Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4[1];
            float _Split_610d0b28a0e94e38b42626a03d9f9794_B_3_Float = _Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4[2];
            float _Split_610d0b28a0e94e38b42626a03d9f9794_A_4_Float = _Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4[3];
            float3 _RotateAboutAxis_a415e5a75c24452bbcd60ac1b3811fc6_Out_3_Vector3;
            Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4.xyz), _Split_610d0b28a0e94e38b42626a03d9f9794_A_4_Float, _RotateAboutAxis_a415e5a75c24452bbcd60ac1b3811fc6_Out_3_Vector3);
            float _Property_2ada180c9afb42be8c587ae354b92988_Out_0_Float = _Noise_Speed;
            float _Multiply_ab217b8df9084424b472a49bafb4515d_Out_2_Float;
            Unity_Multiply_float_float(_Property_2ada180c9afb42be8c587ae354b92988_Out_0_Float, IN.TimeParameters.x, _Multiply_ab217b8df9084424b472a49bafb4515d_Out_2_Float);
            float2 _TilingAndOffset_0b468c25d4d14a999d61900af42dd09d_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_a415e5a75c24452bbcd60ac1b3811fc6_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_ab217b8df9084424b472a49bafb4515d_Out_2_Float.xx), _TilingAndOffset_0b468c25d4d14a999d61900af42dd09d_Out_3_Vector2);
            float _Property_4cdc099c195e4d6a8f9f35604045d0b7_Out_0_Float = _Noise_Scale;
            float _GradientNoise_26bc13aecb1b4c2081638300cc42b01d_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_0b468c25d4d14a999d61900af42dd09d_Out_3_Vector2, _Property_4cdc099c195e4d6a8f9f35604045d0b7_Out_0_Float, _GradientNoise_26bc13aecb1b4c2081638300cc42b01d_Out_2_Float);
            float2 _TilingAndOffset_88de901db4e14268b84877dc201207b6_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_a415e5a75c24452bbcd60ac1b3811fc6_Out_3_Vector3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_88de901db4e14268b84877dc201207b6_Out_3_Vector2);
            float _GradientNoise_aa58bf81bf93430985a301e296a23ad8_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_88de901db4e14268b84877dc201207b6_Out_3_Vector2, _Property_4cdc099c195e4d6a8f9f35604045d0b7_Out_0_Float, _GradientNoise_aa58bf81bf93430985a301e296a23ad8_Out_2_Float);
            float _Add_7767c92e2dbe4c9e8ec3922a6c504040_Out_2_Float;
            Unity_Add_float(_GradientNoise_26bc13aecb1b4c2081638300cc42b01d_Out_2_Float, _GradientNoise_aa58bf81bf93430985a301e296a23ad8_Out_2_Float, _Add_7767c92e2dbe4c9e8ec3922a6c504040_Out_2_Float);
            float _Divide_01c8ce94962043679abea203c1772a79_Out_2_Float;
            Unity_Divide_float(_Add_7767c92e2dbe4c9e8ec3922a6c504040_Out_2_Float, float(2), _Divide_01c8ce94962043679abea203c1772a79_Out_2_Float);
            float _Saturate_bf00c156675b44cd9168e9493fa1fa61_Out_1_Float;
            Unity_Saturate_float(_Divide_01c8ce94962043679abea203c1772a79_Out_2_Float, _Saturate_bf00c156675b44cd9168e9493fa1fa61_Out_1_Float);
            float _Property_b932cc0b0679463495ea24f5ae20fe0a_Out_0_Float = _Noise_Power;
            float _Power_bc99b52173a44811b5a653f85b30e92b_Out_2_Float;
            Unity_Power_float(_Saturate_bf00c156675b44cd9168e9493fa1fa61_Out_1_Float, _Property_b932cc0b0679463495ea24f5ae20fe0a_Out_0_Float, _Power_bc99b52173a44811b5a653f85b30e92b_Out_2_Float);
            float4 _Property_e85e1549c7ea4dc8be0b5d3469565ffd_Out_0_Vector4 = _Noise_Remap;
            float _Split_10eb25ab4f03492b8209300701e5f945_R_1_Float = _Property_e85e1549c7ea4dc8be0b5d3469565ffd_Out_0_Vector4[0];
            float _Split_10eb25ab4f03492b8209300701e5f945_G_2_Float = _Property_e85e1549c7ea4dc8be0b5d3469565ffd_Out_0_Vector4[1];
            float _Split_10eb25ab4f03492b8209300701e5f945_B_3_Float = _Property_e85e1549c7ea4dc8be0b5d3469565ffd_Out_0_Vector4[2];
            float _Split_10eb25ab4f03492b8209300701e5f945_A_4_Float = _Property_e85e1549c7ea4dc8be0b5d3469565ffd_Out_0_Vector4[3];
            float4 _Combine_edb179662e1a4052b97e671dbd3421a5_RGBA_4_Vector4;
            float3 _Combine_edb179662e1a4052b97e671dbd3421a5_RGB_5_Vector3;
            float2 _Combine_edb179662e1a4052b97e671dbd3421a5_RG_6_Vector2;
            Unity_Combine_float(_Split_10eb25ab4f03492b8209300701e5f945_R_1_Float, _Split_10eb25ab4f03492b8209300701e5f945_G_2_Float, float(0), float(0), _Combine_edb179662e1a4052b97e671dbd3421a5_RGBA_4_Vector4, _Combine_edb179662e1a4052b97e671dbd3421a5_RGB_5_Vector3, _Combine_edb179662e1a4052b97e671dbd3421a5_RG_6_Vector2);
            float4 _Combine_f12ac3a1b10f4f388dab86453258dcb0_RGBA_4_Vector4;
            float3 _Combine_f12ac3a1b10f4f388dab86453258dcb0_RGB_5_Vector3;
            float2 _Combine_f12ac3a1b10f4f388dab86453258dcb0_RG_6_Vector2;
            Unity_Combine_float(_Split_10eb25ab4f03492b8209300701e5f945_B_3_Float, _Split_10eb25ab4f03492b8209300701e5f945_A_4_Float, float(0), float(0), _Combine_f12ac3a1b10f4f388dab86453258dcb0_RGBA_4_Vector4, _Combine_f12ac3a1b10f4f388dab86453258dcb0_RGB_5_Vector3, _Combine_f12ac3a1b10f4f388dab86453258dcb0_RG_6_Vector2);
            float _Remap_b473bb8bd2254a3faad5291ff8cb7707_Out_3_Float;
            Unity_Remap_float(_Power_bc99b52173a44811b5a653f85b30e92b_Out_2_Float, _Combine_edb179662e1a4052b97e671dbd3421a5_RG_6_Vector2, _Combine_f12ac3a1b10f4f388dab86453258dcb0_RG_6_Vector2, _Remap_b473bb8bd2254a3faad5291ff8cb7707_Out_3_Float);
            float _Absolute_2367964a3dae475891ccd6c90e2885ff_Out_1_Float;
            Unity_Absolute_float(_Remap_b473bb8bd2254a3faad5291ff8cb7707_Out_3_Float, _Absolute_2367964a3dae475891ccd6c90e2885ff_Out_1_Float);
            float _Smoothstep_516feede7acb4f97b595cd89bba389c4_Out_3_Float;
            Unity_Smoothstep_float(_Property_f05727b79c2d491a8b9c2d8417d4ce68_Out_0_Float, _Property_7d43401174f8413091e457476f00d1aa_Out_0_Float, _Absolute_2367964a3dae475891ccd6c90e2885ff_Out_1_Float, _Smoothstep_516feede7acb4f97b595cd89bba389c4_Out_3_Float);
            float _Property_44e53f25d86f4edbaab4f19b6daaa067_Out_0_Float = _Base_Speed;
            float _Multiply_619aff87dcc446c5968bd1a6d44fe8b7_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_44e53f25d86f4edbaab4f19b6daaa067_Out_0_Float, _Multiply_619aff87dcc446c5968bd1a6d44fe8b7_Out_2_Float);
            float2 _TilingAndOffset_7cbf9da6c23b409fb98e46b72acb3373_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_a415e5a75c24452bbcd60ac1b3811fc6_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_619aff87dcc446c5968bd1a6d44fe8b7_Out_2_Float.xx), _TilingAndOffset_7cbf9da6c23b409fb98e46b72acb3373_Out_3_Vector2);
            float _Property_9254f8e15d6447988ec18cd37fe88bdc_Out_0_Float = _Base_Scale;
            float _GradientNoise_ce38dcc651b44efeb82145bfdadbf1fa_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_7cbf9da6c23b409fb98e46b72acb3373_Out_3_Vector2, _Property_9254f8e15d6447988ec18cd37fe88bdc_Out_0_Float, _GradientNoise_ce38dcc651b44efeb82145bfdadbf1fa_Out_2_Float);
            float _Property_56d73ff99ec94119881f3d643422251a_Out_0_Float = _Base_Strength;
            float _Multiply_a28097e44d4c485a867948d5b27a71aa_Out_2_Float;
            Unity_Multiply_float_float(_GradientNoise_ce38dcc651b44efeb82145bfdadbf1fa_Out_2_Float, _Property_56d73ff99ec94119881f3d643422251a_Out_0_Float, _Multiply_a28097e44d4c485a867948d5b27a71aa_Out_2_Float);
            float _Add_c6fbda241fda4ff68e2e16893549192e_Out_2_Float;
            Unity_Add_float(_Smoothstep_516feede7acb4f97b595cd89bba389c4_Out_3_Float, _Multiply_a28097e44d4c485a867948d5b27a71aa_Out_2_Float, _Add_c6fbda241fda4ff68e2e16893549192e_Out_2_Float);
            float _Add_5d9343a646914b1582c5ac00b2068a54_Out_2_Float;
            Unity_Add_float(float(0), _Property_56d73ff99ec94119881f3d643422251a_Out_0_Float, _Add_5d9343a646914b1582c5ac00b2068a54_Out_2_Float);
            float _Divide_fe411acd94ed4c4c83892bba30255329_Out_2_Float;
            Unity_Divide_float(_Add_c6fbda241fda4ff68e2e16893549192e_Out_2_Float, _Add_5d9343a646914b1582c5ac00b2068a54_Out_2_Float, _Divide_fe411acd94ed4c4c83892bba30255329_Out_2_Float);
            float3 _Multiply_b525aac067b04a9a8f9ce1a4c4716765_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.ObjectSpaceNormal, (_Divide_fe411acd94ed4c4c83892bba30255329_Out_2_Float.xxx), _Multiply_b525aac067b04a9a8f9ce1a4c4716765_Out_2_Vector3);
            float _Property_81343da7ab424f29a124d673b8099601_Out_0_Float = _Noise_Height;
            float3 _Multiply_431791af81b04fe4920287cee8e84b36_Out_2_Vector3;
            Unity_Multiply_float3_float3(_Multiply_b525aac067b04a9a8f9ce1a4c4716765_Out_2_Vector3, (_Property_81343da7ab424f29a124d673b8099601_Out_0_Float.xxx), _Multiply_431791af81b04fe4920287cee8e84b36_Out_2_Vector3);
            float3 _Add_e716c01d530b428c8bcb16ba04bed031_Out_2_Vector3;
            Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_431791af81b04fe4920287cee8e84b36_Out_2_Vector3, _Add_e716c01d530b428c8bcb16ba04bed031_Out_2_Vector3);
            float3 _Add_fc53f37eba984ae88bea18cd54a386d0_Out_2_Vector3;
            Unity_Add_float3(_Multiply_ff35d2ab09754f1c8b2fac2015de70db_Out_2_Vector3, _Add_e716c01d530b428c8bcb16ba04bed031_Out_2_Vector3, _Add_fc53f37eba984ae88bea18cd54a386d0_Out_2_Vector3);
            description.Position = _Add_fc53f37eba984ae88bea18cd54a386d0_Out_2_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float3 NormalTS;
            float3 Emission;
            float Metallic;
            float Smoothness;
            float Occlusion;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_08f55cc2215f457abdf288e58daaa696_Out_0_Vector4 = _Color_A;
            float4 _Property_acbafd3dca104c65b7b71611d4639044_Out_0_Vector4 = _Color_B;
            float _Property_f05727b79c2d491a8b9c2d8417d4ce68_Out_0_Float = _Smooth_Step_1;
            float _Property_7d43401174f8413091e457476f00d1aa_Out_0_Float = _Smooth_Step_2;
            float4 _Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4 = _Rotate_Projection;
            float _Split_610d0b28a0e94e38b42626a03d9f9794_R_1_Float = _Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4[0];
            float _Split_610d0b28a0e94e38b42626a03d9f9794_G_2_Float = _Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4[1];
            float _Split_610d0b28a0e94e38b42626a03d9f9794_B_3_Float = _Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4[2];
            float _Split_610d0b28a0e94e38b42626a03d9f9794_A_4_Float = _Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4[3];
            float3 _RotateAboutAxis_a415e5a75c24452bbcd60ac1b3811fc6_Out_3_Vector3;
            Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4.xyz), _Split_610d0b28a0e94e38b42626a03d9f9794_A_4_Float, _RotateAboutAxis_a415e5a75c24452bbcd60ac1b3811fc6_Out_3_Vector3);
            float _Property_2ada180c9afb42be8c587ae354b92988_Out_0_Float = _Noise_Speed;
            float _Multiply_ab217b8df9084424b472a49bafb4515d_Out_2_Float;
            Unity_Multiply_float_float(_Property_2ada180c9afb42be8c587ae354b92988_Out_0_Float, IN.TimeParameters.x, _Multiply_ab217b8df9084424b472a49bafb4515d_Out_2_Float);
            float2 _TilingAndOffset_0b468c25d4d14a999d61900af42dd09d_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_a415e5a75c24452bbcd60ac1b3811fc6_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_ab217b8df9084424b472a49bafb4515d_Out_2_Float.xx), _TilingAndOffset_0b468c25d4d14a999d61900af42dd09d_Out_3_Vector2);
            float _Property_4cdc099c195e4d6a8f9f35604045d0b7_Out_0_Float = _Noise_Scale;
            float _GradientNoise_26bc13aecb1b4c2081638300cc42b01d_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_0b468c25d4d14a999d61900af42dd09d_Out_3_Vector2, _Property_4cdc099c195e4d6a8f9f35604045d0b7_Out_0_Float, _GradientNoise_26bc13aecb1b4c2081638300cc42b01d_Out_2_Float);
            float2 _TilingAndOffset_88de901db4e14268b84877dc201207b6_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_a415e5a75c24452bbcd60ac1b3811fc6_Out_3_Vector3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_88de901db4e14268b84877dc201207b6_Out_3_Vector2);
            float _GradientNoise_aa58bf81bf93430985a301e296a23ad8_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_88de901db4e14268b84877dc201207b6_Out_3_Vector2, _Property_4cdc099c195e4d6a8f9f35604045d0b7_Out_0_Float, _GradientNoise_aa58bf81bf93430985a301e296a23ad8_Out_2_Float);
            float _Add_7767c92e2dbe4c9e8ec3922a6c504040_Out_2_Float;
            Unity_Add_float(_GradientNoise_26bc13aecb1b4c2081638300cc42b01d_Out_2_Float, _GradientNoise_aa58bf81bf93430985a301e296a23ad8_Out_2_Float, _Add_7767c92e2dbe4c9e8ec3922a6c504040_Out_2_Float);
            float _Divide_01c8ce94962043679abea203c1772a79_Out_2_Float;
            Unity_Divide_float(_Add_7767c92e2dbe4c9e8ec3922a6c504040_Out_2_Float, float(2), _Divide_01c8ce94962043679abea203c1772a79_Out_2_Float);
            float _Saturate_bf00c156675b44cd9168e9493fa1fa61_Out_1_Float;
            Unity_Saturate_float(_Divide_01c8ce94962043679abea203c1772a79_Out_2_Float, _Saturate_bf00c156675b44cd9168e9493fa1fa61_Out_1_Float);
            float _Property_b932cc0b0679463495ea24f5ae20fe0a_Out_0_Float = _Noise_Power;
            float _Power_bc99b52173a44811b5a653f85b30e92b_Out_2_Float;
            Unity_Power_float(_Saturate_bf00c156675b44cd9168e9493fa1fa61_Out_1_Float, _Property_b932cc0b0679463495ea24f5ae20fe0a_Out_0_Float, _Power_bc99b52173a44811b5a653f85b30e92b_Out_2_Float);
            float4 _Property_e85e1549c7ea4dc8be0b5d3469565ffd_Out_0_Vector4 = _Noise_Remap;
            float _Split_10eb25ab4f03492b8209300701e5f945_R_1_Float = _Property_e85e1549c7ea4dc8be0b5d3469565ffd_Out_0_Vector4[0];
            float _Split_10eb25ab4f03492b8209300701e5f945_G_2_Float = _Property_e85e1549c7ea4dc8be0b5d3469565ffd_Out_0_Vector4[1];
            float _Split_10eb25ab4f03492b8209300701e5f945_B_3_Float = _Property_e85e1549c7ea4dc8be0b5d3469565ffd_Out_0_Vector4[2];
            float _Split_10eb25ab4f03492b8209300701e5f945_A_4_Float = _Property_e85e1549c7ea4dc8be0b5d3469565ffd_Out_0_Vector4[3];
            float4 _Combine_edb179662e1a4052b97e671dbd3421a5_RGBA_4_Vector4;
            float3 _Combine_edb179662e1a4052b97e671dbd3421a5_RGB_5_Vector3;
            float2 _Combine_edb179662e1a4052b97e671dbd3421a5_RG_6_Vector2;
            Unity_Combine_float(_Split_10eb25ab4f03492b8209300701e5f945_R_1_Float, _Split_10eb25ab4f03492b8209300701e5f945_G_2_Float, float(0), float(0), _Combine_edb179662e1a4052b97e671dbd3421a5_RGBA_4_Vector4, _Combine_edb179662e1a4052b97e671dbd3421a5_RGB_5_Vector3, _Combine_edb179662e1a4052b97e671dbd3421a5_RG_6_Vector2);
            float4 _Combine_f12ac3a1b10f4f388dab86453258dcb0_RGBA_4_Vector4;
            float3 _Combine_f12ac3a1b10f4f388dab86453258dcb0_RGB_5_Vector3;
            float2 _Combine_f12ac3a1b10f4f388dab86453258dcb0_RG_6_Vector2;
            Unity_Combine_float(_Split_10eb25ab4f03492b8209300701e5f945_B_3_Float, _Split_10eb25ab4f03492b8209300701e5f945_A_4_Float, float(0), float(0), _Combine_f12ac3a1b10f4f388dab86453258dcb0_RGBA_4_Vector4, _Combine_f12ac3a1b10f4f388dab86453258dcb0_RGB_5_Vector3, _Combine_f12ac3a1b10f4f388dab86453258dcb0_RG_6_Vector2);
            float _Remap_b473bb8bd2254a3faad5291ff8cb7707_Out_3_Float;
            Unity_Remap_float(_Power_bc99b52173a44811b5a653f85b30e92b_Out_2_Float, _Combine_edb179662e1a4052b97e671dbd3421a5_RG_6_Vector2, _Combine_f12ac3a1b10f4f388dab86453258dcb0_RG_6_Vector2, _Remap_b473bb8bd2254a3faad5291ff8cb7707_Out_3_Float);
            float _Absolute_2367964a3dae475891ccd6c90e2885ff_Out_1_Float;
            Unity_Absolute_float(_Remap_b473bb8bd2254a3faad5291ff8cb7707_Out_3_Float, _Absolute_2367964a3dae475891ccd6c90e2885ff_Out_1_Float);
            float _Smoothstep_516feede7acb4f97b595cd89bba389c4_Out_3_Float;
            Unity_Smoothstep_float(_Property_f05727b79c2d491a8b9c2d8417d4ce68_Out_0_Float, _Property_7d43401174f8413091e457476f00d1aa_Out_0_Float, _Absolute_2367964a3dae475891ccd6c90e2885ff_Out_1_Float, _Smoothstep_516feede7acb4f97b595cd89bba389c4_Out_3_Float);
            float _Property_44e53f25d86f4edbaab4f19b6daaa067_Out_0_Float = _Base_Speed;
            float _Multiply_619aff87dcc446c5968bd1a6d44fe8b7_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_44e53f25d86f4edbaab4f19b6daaa067_Out_0_Float, _Multiply_619aff87dcc446c5968bd1a6d44fe8b7_Out_2_Float);
            float2 _TilingAndOffset_7cbf9da6c23b409fb98e46b72acb3373_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_a415e5a75c24452bbcd60ac1b3811fc6_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_619aff87dcc446c5968bd1a6d44fe8b7_Out_2_Float.xx), _TilingAndOffset_7cbf9da6c23b409fb98e46b72acb3373_Out_3_Vector2);
            float _Property_9254f8e15d6447988ec18cd37fe88bdc_Out_0_Float = _Base_Scale;
            float _GradientNoise_ce38dcc651b44efeb82145bfdadbf1fa_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_7cbf9da6c23b409fb98e46b72acb3373_Out_3_Vector2, _Property_9254f8e15d6447988ec18cd37fe88bdc_Out_0_Float, _GradientNoise_ce38dcc651b44efeb82145bfdadbf1fa_Out_2_Float);
            float _Property_56d73ff99ec94119881f3d643422251a_Out_0_Float = _Base_Strength;
            float _Multiply_a28097e44d4c485a867948d5b27a71aa_Out_2_Float;
            Unity_Multiply_float_float(_GradientNoise_ce38dcc651b44efeb82145bfdadbf1fa_Out_2_Float, _Property_56d73ff99ec94119881f3d643422251a_Out_0_Float, _Multiply_a28097e44d4c485a867948d5b27a71aa_Out_2_Float);
            float _Add_c6fbda241fda4ff68e2e16893549192e_Out_2_Float;
            Unity_Add_float(_Smoothstep_516feede7acb4f97b595cd89bba389c4_Out_3_Float, _Multiply_a28097e44d4c485a867948d5b27a71aa_Out_2_Float, _Add_c6fbda241fda4ff68e2e16893549192e_Out_2_Float);
            float _Add_5d9343a646914b1582c5ac00b2068a54_Out_2_Float;
            Unity_Add_float(float(0), _Property_56d73ff99ec94119881f3d643422251a_Out_0_Float, _Add_5d9343a646914b1582c5ac00b2068a54_Out_2_Float);
            float _Divide_fe411acd94ed4c4c83892bba30255329_Out_2_Float;
            Unity_Divide_float(_Add_c6fbda241fda4ff68e2e16893549192e_Out_2_Float, _Add_5d9343a646914b1582c5ac00b2068a54_Out_2_Float, _Divide_fe411acd94ed4c4c83892bba30255329_Out_2_Float);
            float4 _Lerp_aaaae5c0660549cda8a2edb7a84e8dbb_Out_3_Vector4;
            Unity_Lerp_float4(_Property_08f55cc2215f457abdf288e58daaa696_Out_0_Vector4, _Property_acbafd3dca104c65b7b71611d4639044_Out_0_Vector4, (_Divide_fe411acd94ed4c4c83892bba30255329_Out_2_Float.xxxx), _Lerp_aaaae5c0660549cda8a2edb7a84e8dbb_Out_3_Vector4);
            float _Property_f89c537fda1b403396d59ec61a8b35e5_Out_0_Float = _Fresnel_Effect_Power;
            float _FresnelEffect_f9c84f0b8ff24646bb5cc9ba3035a272_Out_3_Float;
            Unity_FresnelEffect_float(IN.WorldSpaceNormal, IN.WorldSpaceViewDirection, _Property_f89c537fda1b403396d59ec61a8b35e5_Out_0_Float, _FresnelEffect_f9c84f0b8ff24646bb5cc9ba3035a272_Out_3_Float);
            float _Multiply_1bbed182421f4aa8b0945b4daa798b00_Out_2_Float;
            Unity_Multiply_float_float(_Divide_fe411acd94ed4c4c83892bba30255329_Out_2_Float, _FresnelEffect_f9c84f0b8ff24646bb5cc9ba3035a272_Out_3_Float, _Multiply_1bbed182421f4aa8b0945b4daa798b00_Out_2_Float);
            float _Property_303037adb92e43f8a9f46c95f99d6c48_Out_0_Float = _Fresnel_Effect_Opacity;
            float _Multiply_f635d3e8fd1d4391a3dac582c550363f_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_1bbed182421f4aa8b0945b4daa798b00_Out_2_Float, _Property_303037adb92e43f8a9f46c95f99d6c48_Out_0_Float, _Multiply_f635d3e8fd1d4391a3dac582c550363f_Out_2_Float);
            float4 _Add_d7735e7c08de490697e89ff0870bf268_Out_2_Vector4;
            Unity_Add_float4(_Lerp_aaaae5c0660549cda8a2edb7a84e8dbb_Out_3_Vector4, (_Multiply_f635d3e8fd1d4391a3dac582c550363f_Out_2_Float.xxxx), _Add_d7735e7c08de490697e89ff0870bf268_Out_2_Vector4);
            float _Property_9710070004144fc9be45a2565e9ea4ed_Out_0_Float = _Emission_Strength;
            float4 _Multiply_0b1503eba4ae4a5a9ebe8075c9437c3b_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Add_d7735e7c08de490697e89ff0870bf268_Out_2_Vector4, (_Property_9710070004144fc9be45a2565e9ea4ed_Out_0_Float.xxxx), _Multiply_0b1503eba4ae4a5a9ebe8075c9437c3b_Out_2_Vector4);
            float _SceneDepth_7a3cc358e0f44107b8bce7383895b953_Out_1_Float;
            Unity_SceneDepth_Eye_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_7a3cc358e0f44107b8bce7383895b953_Out_1_Float);
            float4 _ScreenPosition_344727010a4a40389b6dd34b4b9b2ac3_Out_0_Vector4 = IN.ScreenPosition;
            float _Split_acb0902b83d148e2a31506c594db0146_R_1_Float = _ScreenPosition_344727010a4a40389b6dd34b4b9b2ac3_Out_0_Vector4[0];
            float _Split_acb0902b83d148e2a31506c594db0146_G_2_Float = _ScreenPosition_344727010a4a40389b6dd34b4b9b2ac3_Out_0_Vector4[1];
            float _Split_acb0902b83d148e2a31506c594db0146_B_3_Float = _ScreenPosition_344727010a4a40389b6dd34b4b9b2ac3_Out_0_Vector4[2];
            float _Split_acb0902b83d148e2a31506c594db0146_A_4_Float = _ScreenPosition_344727010a4a40389b6dd34b4b9b2ac3_Out_0_Vector4[3];
            float _Subtract_3db7c3ced20d44b3a55e93b8d56c3fc1_Out_2_Float;
            Unity_Subtract_float(_Split_acb0902b83d148e2a31506c594db0146_A_4_Float, float(1), _Subtract_3db7c3ced20d44b3a55e93b8d56c3fc1_Out_2_Float);
            float _Subtract_0b683ae745b74caaa4830cb31795132a_Out_2_Float;
            Unity_Subtract_float(_SceneDepth_7a3cc358e0f44107b8bce7383895b953_Out_1_Float, _Subtract_3db7c3ced20d44b3a55e93b8d56c3fc1_Out_2_Float, _Subtract_0b683ae745b74caaa4830cb31795132a_Out_2_Float);
            float _Property_13ffae534f05496e8446dd4eff4d54b3_Out_0_Float = _Fade_Depth;
            float _Divide_5ea1c32f7a9541ce96555bb9c53dad4e_Out_2_Float;
            Unity_Divide_float(_Subtract_0b683ae745b74caaa4830cb31795132a_Out_2_Float, _Property_13ffae534f05496e8446dd4eff4d54b3_Out_0_Float, _Divide_5ea1c32f7a9541ce96555bb9c53dad4e_Out_2_Float);
            float _Saturate_11cb953c9f3a4ad98649c8032095e0a5_Out_1_Float;
            Unity_Saturate_float(_Divide_5ea1c32f7a9541ce96555bb9c53dad4e_Out_2_Float, _Saturate_11cb953c9f3a4ad98649c8032095e0a5_Out_1_Float);
            float _Smoothstep_804d457501334adcb743390e55365a80_Out_3_Float;
            Unity_Smoothstep_float(float(0), float(1), _Saturate_11cb953c9f3a4ad98649c8032095e0a5_Out_1_Float, _Smoothstep_804d457501334adcb743390e55365a80_Out_3_Float);
            surface.BaseColor = (_Lerp_aaaae5c0660549cda8a2edb7a84e8dbb_Out_3_Vector4.xyz);
            surface.NormalTS = IN.TangentSpaceNormal;
            surface.Emission = (_Multiply_0b1503eba4ae4a5a9ebe8075c9437c3b_Out_2_Vector4.xyz);
            surface.Metallic = float(0);
            surface.Smoothness = float(0.5);
            surface.Occlusion = float(1);
            surface.Alpha = _Smoothstep_804d457501334adcb743390e55365a80_Out_3_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.WorldSpaceNormal =                           TransformObjectToWorldNormal(input.normalOS);
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.WorldSpacePosition =                         TransformObjectToWorld(input.positionOS);
            output.TimeParameters =                             _TimeParameters.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
            // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
            float3 unnormalizedNormalWS = input.normalWS;
            const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        
        
            output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        
        
            output.WorldSpaceViewDirection = GetWorldSpaceNormalizeViewDir(input.positionWS);
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/GBufferOutput.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRGBufferPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "ShadowCaster"
            Tags
            {
                "LightMode" = "ShadowCaster"
            }
        
        // Render State
        Cull Off
        ZTest LEqual
        ZWrite On
        ColorMask 0
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma multi_compile_vertex _ _CASTING_PUNCTUAL_LIGHT_SHADOW
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_SHADOWCASTER
        #define REQUIRE_DEPTH_TEXTURE
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 WorldSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float3 WorldSpacePosition;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS : INTERP0;
             float3 normalWS : INTERP1;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _Rotate_Projection;
        float _Noise_Scale;
        float _Noise_Speed;
        float _Noise_Height;
        float4 _Noise_Remap;
        float4 _Color_A;
        float4 _Color_B;
        float _Smooth_Step_1;
        float _Smooth_Step_2;
        float _Noise_Power;
        float _Base_Scale;
        float _Base_Speed;
        float _Base_Strength;
        float _Emission_Strength;
        float _Curvature_Radius;
        float _Fresnel_Effect_Power;
        float _Fresnel_Effect_Opacity;
        float _Fade_Depth;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Distance_float3(float3 A, float3 B, out float Out)
        {
            Out = distance(A, B);
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
        {
            Rotation = radians(Rotation);
            float s, c;
            sincos(Rotation, s, c);
            Axis = normalize(Axis);
            Out = In * c + cross(Axis, In) * s + Axis * dot(Axis, In) * (1 - c);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
        {
            float x; Hash_Tchou_2_1_float(p, x);
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
        {
            float2 p = UV * Scale.xy;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            if (unity_OrthoParams.w == 1.0)
            {
                Out = LinearEyeDepth(ComputeWorldSpacePosition(UV.xy, SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), UNITY_MATRIX_I_VP), UNITY_MATRIX_V);
            }
            else
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Distance_2db07498d99c49328512eaf4405dfb7d_Out_2_Float;
            Unity_Distance_float3(SHADERGRAPH_OBJECT_POSITION, IN.WorldSpacePosition, _Distance_2db07498d99c49328512eaf4405dfb7d_Out_2_Float);
            float _Property_781afe0d084b4e86ba202ae12d2df5c3_Out_0_Float = _Curvature_Radius;
            float _Divide_3a2887a0281d4fb9a0b32e1c0fa89d00_Out_2_Float;
            Unity_Divide_float(_Distance_2db07498d99c49328512eaf4405dfb7d_Out_2_Float, _Property_781afe0d084b4e86ba202ae12d2df5c3_Out_0_Float, _Divide_3a2887a0281d4fb9a0b32e1c0fa89d00_Out_2_Float);
            float _Power_dae4028a0ef04cc885209d872784f592_Out_2_Float;
            Unity_Power_float(_Divide_3a2887a0281d4fb9a0b32e1c0fa89d00_Out_2_Float, float(3), _Power_dae4028a0ef04cc885209d872784f592_Out_2_Float);
            float3 _Multiply_ff35d2ab09754f1c8b2fac2015de70db_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.WorldSpaceNormal, (_Power_dae4028a0ef04cc885209d872784f592_Out_2_Float.xxx), _Multiply_ff35d2ab09754f1c8b2fac2015de70db_Out_2_Vector3);
            float _Property_f05727b79c2d491a8b9c2d8417d4ce68_Out_0_Float = _Smooth_Step_1;
            float _Property_7d43401174f8413091e457476f00d1aa_Out_0_Float = _Smooth_Step_2;
            float4 _Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4 = _Rotate_Projection;
            float _Split_610d0b28a0e94e38b42626a03d9f9794_R_1_Float = _Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4[0];
            float _Split_610d0b28a0e94e38b42626a03d9f9794_G_2_Float = _Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4[1];
            float _Split_610d0b28a0e94e38b42626a03d9f9794_B_3_Float = _Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4[2];
            float _Split_610d0b28a0e94e38b42626a03d9f9794_A_4_Float = _Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4[3];
            float3 _RotateAboutAxis_a415e5a75c24452bbcd60ac1b3811fc6_Out_3_Vector3;
            Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4.xyz), _Split_610d0b28a0e94e38b42626a03d9f9794_A_4_Float, _RotateAboutAxis_a415e5a75c24452bbcd60ac1b3811fc6_Out_3_Vector3);
            float _Property_2ada180c9afb42be8c587ae354b92988_Out_0_Float = _Noise_Speed;
            float _Multiply_ab217b8df9084424b472a49bafb4515d_Out_2_Float;
            Unity_Multiply_float_float(_Property_2ada180c9afb42be8c587ae354b92988_Out_0_Float, IN.TimeParameters.x, _Multiply_ab217b8df9084424b472a49bafb4515d_Out_2_Float);
            float2 _TilingAndOffset_0b468c25d4d14a999d61900af42dd09d_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_a415e5a75c24452bbcd60ac1b3811fc6_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_ab217b8df9084424b472a49bafb4515d_Out_2_Float.xx), _TilingAndOffset_0b468c25d4d14a999d61900af42dd09d_Out_3_Vector2);
            float _Property_4cdc099c195e4d6a8f9f35604045d0b7_Out_0_Float = _Noise_Scale;
            float _GradientNoise_26bc13aecb1b4c2081638300cc42b01d_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_0b468c25d4d14a999d61900af42dd09d_Out_3_Vector2, _Property_4cdc099c195e4d6a8f9f35604045d0b7_Out_0_Float, _GradientNoise_26bc13aecb1b4c2081638300cc42b01d_Out_2_Float);
            float2 _TilingAndOffset_88de901db4e14268b84877dc201207b6_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_a415e5a75c24452bbcd60ac1b3811fc6_Out_3_Vector3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_88de901db4e14268b84877dc201207b6_Out_3_Vector2);
            float _GradientNoise_aa58bf81bf93430985a301e296a23ad8_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_88de901db4e14268b84877dc201207b6_Out_3_Vector2, _Property_4cdc099c195e4d6a8f9f35604045d0b7_Out_0_Float, _GradientNoise_aa58bf81bf93430985a301e296a23ad8_Out_2_Float);
            float _Add_7767c92e2dbe4c9e8ec3922a6c504040_Out_2_Float;
            Unity_Add_float(_GradientNoise_26bc13aecb1b4c2081638300cc42b01d_Out_2_Float, _GradientNoise_aa58bf81bf93430985a301e296a23ad8_Out_2_Float, _Add_7767c92e2dbe4c9e8ec3922a6c504040_Out_2_Float);
            float _Divide_01c8ce94962043679abea203c1772a79_Out_2_Float;
            Unity_Divide_float(_Add_7767c92e2dbe4c9e8ec3922a6c504040_Out_2_Float, float(2), _Divide_01c8ce94962043679abea203c1772a79_Out_2_Float);
            float _Saturate_bf00c156675b44cd9168e9493fa1fa61_Out_1_Float;
            Unity_Saturate_float(_Divide_01c8ce94962043679abea203c1772a79_Out_2_Float, _Saturate_bf00c156675b44cd9168e9493fa1fa61_Out_1_Float);
            float _Property_b932cc0b0679463495ea24f5ae20fe0a_Out_0_Float = _Noise_Power;
            float _Power_bc99b52173a44811b5a653f85b30e92b_Out_2_Float;
            Unity_Power_float(_Saturate_bf00c156675b44cd9168e9493fa1fa61_Out_1_Float, _Property_b932cc0b0679463495ea24f5ae20fe0a_Out_0_Float, _Power_bc99b52173a44811b5a653f85b30e92b_Out_2_Float);
            float4 _Property_e85e1549c7ea4dc8be0b5d3469565ffd_Out_0_Vector4 = _Noise_Remap;
            float _Split_10eb25ab4f03492b8209300701e5f945_R_1_Float = _Property_e85e1549c7ea4dc8be0b5d3469565ffd_Out_0_Vector4[0];
            float _Split_10eb25ab4f03492b8209300701e5f945_G_2_Float = _Property_e85e1549c7ea4dc8be0b5d3469565ffd_Out_0_Vector4[1];
            float _Split_10eb25ab4f03492b8209300701e5f945_B_3_Float = _Property_e85e1549c7ea4dc8be0b5d3469565ffd_Out_0_Vector4[2];
            float _Split_10eb25ab4f03492b8209300701e5f945_A_4_Float = _Property_e85e1549c7ea4dc8be0b5d3469565ffd_Out_0_Vector4[3];
            float4 _Combine_edb179662e1a4052b97e671dbd3421a5_RGBA_4_Vector4;
            float3 _Combine_edb179662e1a4052b97e671dbd3421a5_RGB_5_Vector3;
            float2 _Combine_edb179662e1a4052b97e671dbd3421a5_RG_6_Vector2;
            Unity_Combine_float(_Split_10eb25ab4f03492b8209300701e5f945_R_1_Float, _Split_10eb25ab4f03492b8209300701e5f945_G_2_Float, float(0), float(0), _Combine_edb179662e1a4052b97e671dbd3421a5_RGBA_4_Vector4, _Combine_edb179662e1a4052b97e671dbd3421a5_RGB_5_Vector3, _Combine_edb179662e1a4052b97e671dbd3421a5_RG_6_Vector2);
            float4 _Combine_f12ac3a1b10f4f388dab86453258dcb0_RGBA_4_Vector4;
            float3 _Combine_f12ac3a1b10f4f388dab86453258dcb0_RGB_5_Vector3;
            float2 _Combine_f12ac3a1b10f4f388dab86453258dcb0_RG_6_Vector2;
            Unity_Combine_float(_Split_10eb25ab4f03492b8209300701e5f945_B_3_Float, _Split_10eb25ab4f03492b8209300701e5f945_A_4_Float, float(0), float(0), _Combine_f12ac3a1b10f4f388dab86453258dcb0_RGBA_4_Vector4, _Combine_f12ac3a1b10f4f388dab86453258dcb0_RGB_5_Vector3, _Combine_f12ac3a1b10f4f388dab86453258dcb0_RG_6_Vector2);
            float _Remap_b473bb8bd2254a3faad5291ff8cb7707_Out_3_Float;
            Unity_Remap_float(_Power_bc99b52173a44811b5a653f85b30e92b_Out_2_Float, _Combine_edb179662e1a4052b97e671dbd3421a5_RG_6_Vector2, _Combine_f12ac3a1b10f4f388dab86453258dcb0_RG_6_Vector2, _Remap_b473bb8bd2254a3faad5291ff8cb7707_Out_3_Float);
            float _Absolute_2367964a3dae475891ccd6c90e2885ff_Out_1_Float;
            Unity_Absolute_float(_Remap_b473bb8bd2254a3faad5291ff8cb7707_Out_3_Float, _Absolute_2367964a3dae475891ccd6c90e2885ff_Out_1_Float);
            float _Smoothstep_516feede7acb4f97b595cd89bba389c4_Out_3_Float;
            Unity_Smoothstep_float(_Property_f05727b79c2d491a8b9c2d8417d4ce68_Out_0_Float, _Property_7d43401174f8413091e457476f00d1aa_Out_0_Float, _Absolute_2367964a3dae475891ccd6c90e2885ff_Out_1_Float, _Smoothstep_516feede7acb4f97b595cd89bba389c4_Out_3_Float);
            float _Property_44e53f25d86f4edbaab4f19b6daaa067_Out_0_Float = _Base_Speed;
            float _Multiply_619aff87dcc446c5968bd1a6d44fe8b7_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_44e53f25d86f4edbaab4f19b6daaa067_Out_0_Float, _Multiply_619aff87dcc446c5968bd1a6d44fe8b7_Out_2_Float);
            float2 _TilingAndOffset_7cbf9da6c23b409fb98e46b72acb3373_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_a415e5a75c24452bbcd60ac1b3811fc6_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_619aff87dcc446c5968bd1a6d44fe8b7_Out_2_Float.xx), _TilingAndOffset_7cbf9da6c23b409fb98e46b72acb3373_Out_3_Vector2);
            float _Property_9254f8e15d6447988ec18cd37fe88bdc_Out_0_Float = _Base_Scale;
            float _GradientNoise_ce38dcc651b44efeb82145bfdadbf1fa_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_7cbf9da6c23b409fb98e46b72acb3373_Out_3_Vector2, _Property_9254f8e15d6447988ec18cd37fe88bdc_Out_0_Float, _GradientNoise_ce38dcc651b44efeb82145bfdadbf1fa_Out_2_Float);
            float _Property_56d73ff99ec94119881f3d643422251a_Out_0_Float = _Base_Strength;
            float _Multiply_a28097e44d4c485a867948d5b27a71aa_Out_2_Float;
            Unity_Multiply_float_float(_GradientNoise_ce38dcc651b44efeb82145bfdadbf1fa_Out_2_Float, _Property_56d73ff99ec94119881f3d643422251a_Out_0_Float, _Multiply_a28097e44d4c485a867948d5b27a71aa_Out_2_Float);
            float _Add_c6fbda241fda4ff68e2e16893549192e_Out_2_Float;
            Unity_Add_float(_Smoothstep_516feede7acb4f97b595cd89bba389c4_Out_3_Float, _Multiply_a28097e44d4c485a867948d5b27a71aa_Out_2_Float, _Add_c6fbda241fda4ff68e2e16893549192e_Out_2_Float);
            float _Add_5d9343a646914b1582c5ac00b2068a54_Out_2_Float;
            Unity_Add_float(float(0), _Property_56d73ff99ec94119881f3d643422251a_Out_0_Float, _Add_5d9343a646914b1582c5ac00b2068a54_Out_2_Float);
            float _Divide_fe411acd94ed4c4c83892bba30255329_Out_2_Float;
            Unity_Divide_float(_Add_c6fbda241fda4ff68e2e16893549192e_Out_2_Float, _Add_5d9343a646914b1582c5ac00b2068a54_Out_2_Float, _Divide_fe411acd94ed4c4c83892bba30255329_Out_2_Float);
            float3 _Multiply_b525aac067b04a9a8f9ce1a4c4716765_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.ObjectSpaceNormal, (_Divide_fe411acd94ed4c4c83892bba30255329_Out_2_Float.xxx), _Multiply_b525aac067b04a9a8f9ce1a4c4716765_Out_2_Vector3);
            float _Property_81343da7ab424f29a124d673b8099601_Out_0_Float = _Noise_Height;
            float3 _Multiply_431791af81b04fe4920287cee8e84b36_Out_2_Vector3;
            Unity_Multiply_float3_float3(_Multiply_b525aac067b04a9a8f9ce1a4c4716765_Out_2_Vector3, (_Property_81343da7ab424f29a124d673b8099601_Out_0_Float.xxx), _Multiply_431791af81b04fe4920287cee8e84b36_Out_2_Vector3);
            float3 _Add_e716c01d530b428c8bcb16ba04bed031_Out_2_Vector3;
            Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_431791af81b04fe4920287cee8e84b36_Out_2_Vector3, _Add_e716c01d530b428c8bcb16ba04bed031_Out_2_Vector3);
            float3 _Add_fc53f37eba984ae88bea18cd54a386d0_Out_2_Vector3;
            Unity_Add_float3(_Multiply_ff35d2ab09754f1c8b2fac2015de70db_Out_2_Vector3, _Add_e716c01d530b428c8bcb16ba04bed031_Out_2_Vector3, _Add_fc53f37eba984ae88bea18cd54a386d0_Out_2_Vector3);
            description.Position = _Add_fc53f37eba984ae88bea18cd54a386d0_Out_2_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _SceneDepth_7a3cc358e0f44107b8bce7383895b953_Out_1_Float;
            Unity_SceneDepth_Eye_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_7a3cc358e0f44107b8bce7383895b953_Out_1_Float);
            float4 _ScreenPosition_344727010a4a40389b6dd34b4b9b2ac3_Out_0_Vector4 = IN.ScreenPosition;
            float _Split_acb0902b83d148e2a31506c594db0146_R_1_Float = _ScreenPosition_344727010a4a40389b6dd34b4b9b2ac3_Out_0_Vector4[0];
            float _Split_acb0902b83d148e2a31506c594db0146_G_2_Float = _ScreenPosition_344727010a4a40389b6dd34b4b9b2ac3_Out_0_Vector4[1];
            float _Split_acb0902b83d148e2a31506c594db0146_B_3_Float = _ScreenPosition_344727010a4a40389b6dd34b4b9b2ac3_Out_0_Vector4[2];
            float _Split_acb0902b83d148e2a31506c594db0146_A_4_Float = _ScreenPosition_344727010a4a40389b6dd34b4b9b2ac3_Out_0_Vector4[3];
            float _Subtract_3db7c3ced20d44b3a55e93b8d56c3fc1_Out_2_Float;
            Unity_Subtract_float(_Split_acb0902b83d148e2a31506c594db0146_A_4_Float, float(1), _Subtract_3db7c3ced20d44b3a55e93b8d56c3fc1_Out_2_Float);
            float _Subtract_0b683ae745b74caaa4830cb31795132a_Out_2_Float;
            Unity_Subtract_float(_SceneDepth_7a3cc358e0f44107b8bce7383895b953_Out_1_Float, _Subtract_3db7c3ced20d44b3a55e93b8d56c3fc1_Out_2_Float, _Subtract_0b683ae745b74caaa4830cb31795132a_Out_2_Float);
            float _Property_13ffae534f05496e8446dd4eff4d54b3_Out_0_Float = _Fade_Depth;
            float _Divide_5ea1c32f7a9541ce96555bb9c53dad4e_Out_2_Float;
            Unity_Divide_float(_Subtract_0b683ae745b74caaa4830cb31795132a_Out_2_Float, _Property_13ffae534f05496e8446dd4eff4d54b3_Out_0_Float, _Divide_5ea1c32f7a9541ce96555bb9c53dad4e_Out_2_Float);
            float _Saturate_11cb953c9f3a4ad98649c8032095e0a5_Out_1_Float;
            Unity_Saturate_float(_Divide_5ea1c32f7a9541ce96555bb9c53dad4e_Out_2_Float, _Saturate_11cb953c9f3a4ad98649c8032095e0a5_Out_1_Float);
            float _Smoothstep_804d457501334adcb743390e55365a80_Out_3_Float;
            Unity_Smoothstep_float(float(0), float(1), _Saturate_11cb953c9f3a4ad98649c8032095e0a5_Out_1_Float, _Smoothstep_804d457501334adcb743390e55365a80_Out_3_Float);
            surface.Alpha = _Smoothstep_804d457501334adcb743390e55365a80_Out_3_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.WorldSpaceNormal =                           TransformObjectToWorldNormal(input.normalOS);
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.WorldSpacePosition =                         TransformObjectToWorld(input.positionOS);
            output.TimeParameters =                             _TimeParameters.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "MotionVectors"
            Tags
            {
                "LightMode" = "MotionVectors"
            }
        
        // Render State
        Cull Off
        ZTest LEqual
        ZWrite On
        ColorMask RG
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 3.5
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define VARYINGS_NEED_POSITION_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_MOTION_VECTORS
        #define REQUIRE_DEPTH_TEXTURE
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 WorldSpaceNormal;
             float3 ObjectSpacePosition;
             float3 WorldSpacePosition;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS : INTERP0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.positionWS.xyz = input.positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.positionWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _Rotate_Projection;
        float _Noise_Scale;
        float _Noise_Speed;
        float _Noise_Height;
        float4 _Noise_Remap;
        float4 _Color_A;
        float4 _Color_B;
        float _Smooth_Step_1;
        float _Smooth_Step_2;
        float _Noise_Power;
        float _Base_Scale;
        float _Base_Speed;
        float _Base_Strength;
        float _Emission_Strength;
        float _Curvature_Radius;
        float _Fresnel_Effect_Power;
        float _Fresnel_Effect_Opacity;
        float _Fade_Depth;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Distance_float3(float3 A, float3 B, out float Out)
        {
            Out = distance(A, B);
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
        {
            Rotation = radians(Rotation);
            float s, c;
            sincos(Rotation, s, c);
            Axis = normalize(Axis);
            Out = In * c + cross(Axis, In) * s + Axis * dot(Axis, In) * (1 - c);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
        {
            float x; Hash_Tchou_2_1_float(p, x);
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
        {
            float2 p = UV * Scale.xy;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            if (unity_OrthoParams.w == 1.0)
            {
                Out = LinearEyeDepth(ComputeWorldSpacePosition(UV.xy, SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), UNITY_MATRIX_I_VP), UNITY_MATRIX_V);
            }
            else
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Distance_2db07498d99c49328512eaf4405dfb7d_Out_2_Float;
            Unity_Distance_float3(SHADERGRAPH_OBJECT_POSITION, IN.WorldSpacePosition, _Distance_2db07498d99c49328512eaf4405dfb7d_Out_2_Float);
            float _Property_781afe0d084b4e86ba202ae12d2df5c3_Out_0_Float = _Curvature_Radius;
            float _Divide_3a2887a0281d4fb9a0b32e1c0fa89d00_Out_2_Float;
            Unity_Divide_float(_Distance_2db07498d99c49328512eaf4405dfb7d_Out_2_Float, _Property_781afe0d084b4e86ba202ae12d2df5c3_Out_0_Float, _Divide_3a2887a0281d4fb9a0b32e1c0fa89d00_Out_2_Float);
            float _Power_dae4028a0ef04cc885209d872784f592_Out_2_Float;
            Unity_Power_float(_Divide_3a2887a0281d4fb9a0b32e1c0fa89d00_Out_2_Float, float(3), _Power_dae4028a0ef04cc885209d872784f592_Out_2_Float);
            float3 _Multiply_ff35d2ab09754f1c8b2fac2015de70db_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.WorldSpaceNormal, (_Power_dae4028a0ef04cc885209d872784f592_Out_2_Float.xxx), _Multiply_ff35d2ab09754f1c8b2fac2015de70db_Out_2_Vector3);
            float _Property_f05727b79c2d491a8b9c2d8417d4ce68_Out_0_Float = _Smooth_Step_1;
            float _Property_7d43401174f8413091e457476f00d1aa_Out_0_Float = _Smooth_Step_2;
            float4 _Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4 = _Rotate_Projection;
            float _Split_610d0b28a0e94e38b42626a03d9f9794_R_1_Float = _Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4[0];
            float _Split_610d0b28a0e94e38b42626a03d9f9794_G_2_Float = _Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4[1];
            float _Split_610d0b28a0e94e38b42626a03d9f9794_B_3_Float = _Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4[2];
            float _Split_610d0b28a0e94e38b42626a03d9f9794_A_4_Float = _Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4[3];
            float3 _RotateAboutAxis_a415e5a75c24452bbcd60ac1b3811fc6_Out_3_Vector3;
            Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4.xyz), _Split_610d0b28a0e94e38b42626a03d9f9794_A_4_Float, _RotateAboutAxis_a415e5a75c24452bbcd60ac1b3811fc6_Out_3_Vector3);
            float _Property_2ada180c9afb42be8c587ae354b92988_Out_0_Float = _Noise_Speed;
            float _Multiply_ab217b8df9084424b472a49bafb4515d_Out_2_Float;
            Unity_Multiply_float_float(_Property_2ada180c9afb42be8c587ae354b92988_Out_0_Float, IN.TimeParameters.x, _Multiply_ab217b8df9084424b472a49bafb4515d_Out_2_Float);
            float2 _TilingAndOffset_0b468c25d4d14a999d61900af42dd09d_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_a415e5a75c24452bbcd60ac1b3811fc6_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_ab217b8df9084424b472a49bafb4515d_Out_2_Float.xx), _TilingAndOffset_0b468c25d4d14a999d61900af42dd09d_Out_3_Vector2);
            float _Property_4cdc099c195e4d6a8f9f35604045d0b7_Out_0_Float = _Noise_Scale;
            float _GradientNoise_26bc13aecb1b4c2081638300cc42b01d_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_0b468c25d4d14a999d61900af42dd09d_Out_3_Vector2, _Property_4cdc099c195e4d6a8f9f35604045d0b7_Out_0_Float, _GradientNoise_26bc13aecb1b4c2081638300cc42b01d_Out_2_Float);
            float2 _TilingAndOffset_88de901db4e14268b84877dc201207b6_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_a415e5a75c24452bbcd60ac1b3811fc6_Out_3_Vector3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_88de901db4e14268b84877dc201207b6_Out_3_Vector2);
            float _GradientNoise_aa58bf81bf93430985a301e296a23ad8_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_88de901db4e14268b84877dc201207b6_Out_3_Vector2, _Property_4cdc099c195e4d6a8f9f35604045d0b7_Out_0_Float, _GradientNoise_aa58bf81bf93430985a301e296a23ad8_Out_2_Float);
            float _Add_7767c92e2dbe4c9e8ec3922a6c504040_Out_2_Float;
            Unity_Add_float(_GradientNoise_26bc13aecb1b4c2081638300cc42b01d_Out_2_Float, _GradientNoise_aa58bf81bf93430985a301e296a23ad8_Out_2_Float, _Add_7767c92e2dbe4c9e8ec3922a6c504040_Out_2_Float);
            float _Divide_01c8ce94962043679abea203c1772a79_Out_2_Float;
            Unity_Divide_float(_Add_7767c92e2dbe4c9e8ec3922a6c504040_Out_2_Float, float(2), _Divide_01c8ce94962043679abea203c1772a79_Out_2_Float);
            float _Saturate_bf00c156675b44cd9168e9493fa1fa61_Out_1_Float;
            Unity_Saturate_float(_Divide_01c8ce94962043679abea203c1772a79_Out_2_Float, _Saturate_bf00c156675b44cd9168e9493fa1fa61_Out_1_Float);
            float _Property_b932cc0b0679463495ea24f5ae20fe0a_Out_0_Float = _Noise_Power;
            float _Power_bc99b52173a44811b5a653f85b30e92b_Out_2_Float;
            Unity_Power_float(_Saturate_bf00c156675b44cd9168e9493fa1fa61_Out_1_Float, _Property_b932cc0b0679463495ea24f5ae20fe0a_Out_0_Float, _Power_bc99b52173a44811b5a653f85b30e92b_Out_2_Float);
            float4 _Property_e85e1549c7ea4dc8be0b5d3469565ffd_Out_0_Vector4 = _Noise_Remap;
            float _Split_10eb25ab4f03492b8209300701e5f945_R_1_Float = _Property_e85e1549c7ea4dc8be0b5d3469565ffd_Out_0_Vector4[0];
            float _Split_10eb25ab4f03492b8209300701e5f945_G_2_Float = _Property_e85e1549c7ea4dc8be0b5d3469565ffd_Out_0_Vector4[1];
            float _Split_10eb25ab4f03492b8209300701e5f945_B_3_Float = _Property_e85e1549c7ea4dc8be0b5d3469565ffd_Out_0_Vector4[2];
            float _Split_10eb25ab4f03492b8209300701e5f945_A_4_Float = _Property_e85e1549c7ea4dc8be0b5d3469565ffd_Out_0_Vector4[3];
            float4 _Combine_edb179662e1a4052b97e671dbd3421a5_RGBA_4_Vector4;
            float3 _Combine_edb179662e1a4052b97e671dbd3421a5_RGB_5_Vector3;
            float2 _Combine_edb179662e1a4052b97e671dbd3421a5_RG_6_Vector2;
            Unity_Combine_float(_Split_10eb25ab4f03492b8209300701e5f945_R_1_Float, _Split_10eb25ab4f03492b8209300701e5f945_G_2_Float, float(0), float(0), _Combine_edb179662e1a4052b97e671dbd3421a5_RGBA_4_Vector4, _Combine_edb179662e1a4052b97e671dbd3421a5_RGB_5_Vector3, _Combine_edb179662e1a4052b97e671dbd3421a5_RG_6_Vector2);
            float4 _Combine_f12ac3a1b10f4f388dab86453258dcb0_RGBA_4_Vector4;
            float3 _Combine_f12ac3a1b10f4f388dab86453258dcb0_RGB_5_Vector3;
            float2 _Combine_f12ac3a1b10f4f388dab86453258dcb0_RG_6_Vector2;
            Unity_Combine_float(_Split_10eb25ab4f03492b8209300701e5f945_B_3_Float, _Split_10eb25ab4f03492b8209300701e5f945_A_4_Float, float(0), float(0), _Combine_f12ac3a1b10f4f388dab86453258dcb0_RGBA_4_Vector4, _Combine_f12ac3a1b10f4f388dab86453258dcb0_RGB_5_Vector3, _Combine_f12ac3a1b10f4f388dab86453258dcb0_RG_6_Vector2);
            float _Remap_b473bb8bd2254a3faad5291ff8cb7707_Out_3_Float;
            Unity_Remap_float(_Power_bc99b52173a44811b5a653f85b30e92b_Out_2_Float, _Combine_edb179662e1a4052b97e671dbd3421a5_RG_6_Vector2, _Combine_f12ac3a1b10f4f388dab86453258dcb0_RG_6_Vector2, _Remap_b473bb8bd2254a3faad5291ff8cb7707_Out_3_Float);
            float _Absolute_2367964a3dae475891ccd6c90e2885ff_Out_1_Float;
            Unity_Absolute_float(_Remap_b473bb8bd2254a3faad5291ff8cb7707_Out_3_Float, _Absolute_2367964a3dae475891ccd6c90e2885ff_Out_1_Float);
            float _Smoothstep_516feede7acb4f97b595cd89bba389c4_Out_3_Float;
            Unity_Smoothstep_float(_Property_f05727b79c2d491a8b9c2d8417d4ce68_Out_0_Float, _Property_7d43401174f8413091e457476f00d1aa_Out_0_Float, _Absolute_2367964a3dae475891ccd6c90e2885ff_Out_1_Float, _Smoothstep_516feede7acb4f97b595cd89bba389c4_Out_3_Float);
            float _Property_44e53f25d86f4edbaab4f19b6daaa067_Out_0_Float = _Base_Speed;
            float _Multiply_619aff87dcc446c5968bd1a6d44fe8b7_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_44e53f25d86f4edbaab4f19b6daaa067_Out_0_Float, _Multiply_619aff87dcc446c5968bd1a6d44fe8b7_Out_2_Float);
            float2 _TilingAndOffset_7cbf9da6c23b409fb98e46b72acb3373_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_a415e5a75c24452bbcd60ac1b3811fc6_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_619aff87dcc446c5968bd1a6d44fe8b7_Out_2_Float.xx), _TilingAndOffset_7cbf9da6c23b409fb98e46b72acb3373_Out_3_Vector2);
            float _Property_9254f8e15d6447988ec18cd37fe88bdc_Out_0_Float = _Base_Scale;
            float _GradientNoise_ce38dcc651b44efeb82145bfdadbf1fa_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_7cbf9da6c23b409fb98e46b72acb3373_Out_3_Vector2, _Property_9254f8e15d6447988ec18cd37fe88bdc_Out_0_Float, _GradientNoise_ce38dcc651b44efeb82145bfdadbf1fa_Out_2_Float);
            float _Property_56d73ff99ec94119881f3d643422251a_Out_0_Float = _Base_Strength;
            float _Multiply_a28097e44d4c485a867948d5b27a71aa_Out_2_Float;
            Unity_Multiply_float_float(_GradientNoise_ce38dcc651b44efeb82145bfdadbf1fa_Out_2_Float, _Property_56d73ff99ec94119881f3d643422251a_Out_0_Float, _Multiply_a28097e44d4c485a867948d5b27a71aa_Out_2_Float);
            float _Add_c6fbda241fda4ff68e2e16893549192e_Out_2_Float;
            Unity_Add_float(_Smoothstep_516feede7acb4f97b595cd89bba389c4_Out_3_Float, _Multiply_a28097e44d4c485a867948d5b27a71aa_Out_2_Float, _Add_c6fbda241fda4ff68e2e16893549192e_Out_2_Float);
            float _Add_5d9343a646914b1582c5ac00b2068a54_Out_2_Float;
            Unity_Add_float(float(0), _Property_56d73ff99ec94119881f3d643422251a_Out_0_Float, _Add_5d9343a646914b1582c5ac00b2068a54_Out_2_Float);
            float _Divide_fe411acd94ed4c4c83892bba30255329_Out_2_Float;
            Unity_Divide_float(_Add_c6fbda241fda4ff68e2e16893549192e_Out_2_Float, _Add_5d9343a646914b1582c5ac00b2068a54_Out_2_Float, _Divide_fe411acd94ed4c4c83892bba30255329_Out_2_Float);
            float3 _Multiply_b525aac067b04a9a8f9ce1a4c4716765_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.ObjectSpaceNormal, (_Divide_fe411acd94ed4c4c83892bba30255329_Out_2_Float.xxx), _Multiply_b525aac067b04a9a8f9ce1a4c4716765_Out_2_Vector3);
            float _Property_81343da7ab424f29a124d673b8099601_Out_0_Float = _Noise_Height;
            float3 _Multiply_431791af81b04fe4920287cee8e84b36_Out_2_Vector3;
            Unity_Multiply_float3_float3(_Multiply_b525aac067b04a9a8f9ce1a4c4716765_Out_2_Vector3, (_Property_81343da7ab424f29a124d673b8099601_Out_0_Float.xxx), _Multiply_431791af81b04fe4920287cee8e84b36_Out_2_Vector3);
            float3 _Add_e716c01d530b428c8bcb16ba04bed031_Out_2_Vector3;
            Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_431791af81b04fe4920287cee8e84b36_Out_2_Vector3, _Add_e716c01d530b428c8bcb16ba04bed031_Out_2_Vector3);
            float3 _Add_fc53f37eba984ae88bea18cd54a386d0_Out_2_Vector3;
            Unity_Add_float3(_Multiply_ff35d2ab09754f1c8b2fac2015de70db_Out_2_Vector3, _Add_e716c01d530b428c8bcb16ba04bed031_Out_2_Vector3, _Add_fc53f37eba984ae88bea18cd54a386d0_Out_2_Vector3);
            description.Position = _Add_fc53f37eba984ae88bea18cd54a386d0_Out_2_Vector3;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _SceneDepth_7a3cc358e0f44107b8bce7383895b953_Out_1_Float;
            Unity_SceneDepth_Eye_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_7a3cc358e0f44107b8bce7383895b953_Out_1_Float);
            float4 _ScreenPosition_344727010a4a40389b6dd34b4b9b2ac3_Out_0_Vector4 = IN.ScreenPosition;
            float _Split_acb0902b83d148e2a31506c594db0146_R_1_Float = _ScreenPosition_344727010a4a40389b6dd34b4b9b2ac3_Out_0_Vector4[0];
            float _Split_acb0902b83d148e2a31506c594db0146_G_2_Float = _ScreenPosition_344727010a4a40389b6dd34b4b9b2ac3_Out_0_Vector4[1];
            float _Split_acb0902b83d148e2a31506c594db0146_B_3_Float = _ScreenPosition_344727010a4a40389b6dd34b4b9b2ac3_Out_0_Vector4[2];
            float _Split_acb0902b83d148e2a31506c594db0146_A_4_Float = _ScreenPosition_344727010a4a40389b6dd34b4b9b2ac3_Out_0_Vector4[3];
            float _Subtract_3db7c3ced20d44b3a55e93b8d56c3fc1_Out_2_Float;
            Unity_Subtract_float(_Split_acb0902b83d148e2a31506c594db0146_A_4_Float, float(1), _Subtract_3db7c3ced20d44b3a55e93b8d56c3fc1_Out_2_Float);
            float _Subtract_0b683ae745b74caaa4830cb31795132a_Out_2_Float;
            Unity_Subtract_float(_SceneDepth_7a3cc358e0f44107b8bce7383895b953_Out_1_Float, _Subtract_3db7c3ced20d44b3a55e93b8d56c3fc1_Out_2_Float, _Subtract_0b683ae745b74caaa4830cb31795132a_Out_2_Float);
            float _Property_13ffae534f05496e8446dd4eff4d54b3_Out_0_Float = _Fade_Depth;
            float _Divide_5ea1c32f7a9541ce96555bb9c53dad4e_Out_2_Float;
            Unity_Divide_float(_Subtract_0b683ae745b74caaa4830cb31795132a_Out_2_Float, _Property_13ffae534f05496e8446dd4eff4d54b3_Out_0_Float, _Divide_5ea1c32f7a9541ce96555bb9c53dad4e_Out_2_Float);
            float _Saturate_11cb953c9f3a4ad98649c8032095e0a5_Out_1_Float;
            Unity_Saturate_float(_Divide_5ea1c32f7a9541ce96555bb9c53dad4e_Out_2_Float, _Saturate_11cb953c9f3a4ad98649c8032095e0a5_Out_1_Float);
            float _Smoothstep_804d457501334adcb743390e55365a80_Out_3_Float;
            Unity_Smoothstep_float(float(0), float(1), _Saturate_11cb953c9f3a4ad98649c8032095e0a5_Out_1_Float, _Smoothstep_804d457501334adcb743390e55365a80_Out_3_Float);
            surface.Alpha = _Smoothstep_804d457501334adcb743390e55365a80_Out_3_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.WorldSpaceNormal =                           TransformObjectToWorldNormal(input.normalOS);
            output.ObjectSpacePosition =                        input.positionOS;
            output.WorldSpacePosition =                         TransformObjectToWorld(input.positionOS);
            output.TimeParameters =                             _TimeParameters.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/MotionVectorPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "DepthOnly"
            Tags
            {
                "LightMode" = "DepthOnly"
            }
        
        // Render State
        Cull Off
        ZTest LEqual
        ZWrite On
        ColorMask R
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_POSITION_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define REQUIRE_DEPTH_TEXTURE
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 WorldSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float3 WorldSpacePosition;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS : INTERP0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.positionWS.xyz = input.positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.positionWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _Rotate_Projection;
        float _Noise_Scale;
        float _Noise_Speed;
        float _Noise_Height;
        float4 _Noise_Remap;
        float4 _Color_A;
        float4 _Color_B;
        float _Smooth_Step_1;
        float _Smooth_Step_2;
        float _Noise_Power;
        float _Base_Scale;
        float _Base_Speed;
        float _Base_Strength;
        float _Emission_Strength;
        float _Curvature_Radius;
        float _Fresnel_Effect_Power;
        float _Fresnel_Effect_Opacity;
        float _Fade_Depth;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Distance_float3(float3 A, float3 B, out float Out)
        {
            Out = distance(A, B);
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
        {
            Rotation = radians(Rotation);
            float s, c;
            sincos(Rotation, s, c);
            Axis = normalize(Axis);
            Out = In * c + cross(Axis, In) * s + Axis * dot(Axis, In) * (1 - c);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
        {
            float x; Hash_Tchou_2_1_float(p, x);
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
        {
            float2 p = UV * Scale.xy;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            if (unity_OrthoParams.w == 1.0)
            {
                Out = LinearEyeDepth(ComputeWorldSpacePosition(UV.xy, SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), UNITY_MATRIX_I_VP), UNITY_MATRIX_V);
            }
            else
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Distance_2db07498d99c49328512eaf4405dfb7d_Out_2_Float;
            Unity_Distance_float3(SHADERGRAPH_OBJECT_POSITION, IN.WorldSpacePosition, _Distance_2db07498d99c49328512eaf4405dfb7d_Out_2_Float);
            float _Property_781afe0d084b4e86ba202ae12d2df5c3_Out_0_Float = _Curvature_Radius;
            float _Divide_3a2887a0281d4fb9a0b32e1c0fa89d00_Out_2_Float;
            Unity_Divide_float(_Distance_2db07498d99c49328512eaf4405dfb7d_Out_2_Float, _Property_781afe0d084b4e86ba202ae12d2df5c3_Out_0_Float, _Divide_3a2887a0281d4fb9a0b32e1c0fa89d00_Out_2_Float);
            float _Power_dae4028a0ef04cc885209d872784f592_Out_2_Float;
            Unity_Power_float(_Divide_3a2887a0281d4fb9a0b32e1c0fa89d00_Out_2_Float, float(3), _Power_dae4028a0ef04cc885209d872784f592_Out_2_Float);
            float3 _Multiply_ff35d2ab09754f1c8b2fac2015de70db_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.WorldSpaceNormal, (_Power_dae4028a0ef04cc885209d872784f592_Out_2_Float.xxx), _Multiply_ff35d2ab09754f1c8b2fac2015de70db_Out_2_Vector3);
            float _Property_f05727b79c2d491a8b9c2d8417d4ce68_Out_0_Float = _Smooth_Step_1;
            float _Property_7d43401174f8413091e457476f00d1aa_Out_0_Float = _Smooth_Step_2;
            float4 _Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4 = _Rotate_Projection;
            float _Split_610d0b28a0e94e38b42626a03d9f9794_R_1_Float = _Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4[0];
            float _Split_610d0b28a0e94e38b42626a03d9f9794_G_2_Float = _Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4[1];
            float _Split_610d0b28a0e94e38b42626a03d9f9794_B_3_Float = _Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4[2];
            float _Split_610d0b28a0e94e38b42626a03d9f9794_A_4_Float = _Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4[3];
            float3 _RotateAboutAxis_a415e5a75c24452bbcd60ac1b3811fc6_Out_3_Vector3;
            Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4.xyz), _Split_610d0b28a0e94e38b42626a03d9f9794_A_4_Float, _RotateAboutAxis_a415e5a75c24452bbcd60ac1b3811fc6_Out_3_Vector3);
            float _Property_2ada180c9afb42be8c587ae354b92988_Out_0_Float = _Noise_Speed;
            float _Multiply_ab217b8df9084424b472a49bafb4515d_Out_2_Float;
            Unity_Multiply_float_float(_Property_2ada180c9afb42be8c587ae354b92988_Out_0_Float, IN.TimeParameters.x, _Multiply_ab217b8df9084424b472a49bafb4515d_Out_2_Float);
            float2 _TilingAndOffset_0b468c25d4d14a999d61900af42dd09d_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_a415e5a75c24452bbcd60ac1b3811fc6_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_ab217b8df9084424b472a49bafb4515d_Out_2_Float.xx), _TilingAndOffset_0b468c25d4d14a999d61900af42dd09d_Out_3_Vector2);
            float _Property_4cdc099c195e4d6a8f9f35604045d0b7_Out_0_Float = _Noise_Scale;
            float _GradientNoise_26bc13aecb1b4c2081638300cc42b01d_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_0b468c25d4d14a999d61900af42dd09d_Out_3_Vector2, _Property_4cdc099c195e4d6a8f9f35604045d0b7_Out_0_Float, _GradientNoise_26bc13aecb1b4c2081638300cc42b01d_Out_2_Float);
            float2 _TilingAndOffset_88de901db4e14268b84877dc201207b6_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_a415e5a75c24452bbcd60ac1b3811fc6_Out_3_Vector3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_88de901db4e14268b84877dc201207b6_Out_3_Vector2);
            float _GradientNoise_aa58bf81bf93430985a301e296a23ad8_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_88de901db4e14268b84877dc201207b6_Out_3_Vector2, _Property_4cdc099c195e4d6a8f9f35604045d0b7_Out_0_Float, _GradientNoise_aa58bf81bf93430985a301e296a23ad8_Out_2_Float);
            float _Add_7767c92e2dbe4c9e8ec3922a6c504040_Out_2_Float;
            Unity_Add_float(_GradientNoise_26bc13aecb1b4c2081638300cc42b01d_Out_2_Float, _GradientNoise_aa58bf81bf93430985a301e296a23ad8_Out_2_Float, _Add_7767c92e2dbe4c9e8ec3922a6c504040_Out_2_Float);
            float _Divide_01c8ce94962043679abea203c1772a79_Out_2_Float;
            Unity_Divide_float(_Add_7767c92e2dbe4c9e8ec3922a6c504040_Out_2_Float, float(2), _Divide_01c8ce94962043679abea203c1772a79_Out_2_Float);
            float _Saturate_bf00c156675b44cd9168e9493fa1fa61_Out_1_Float;
            Unity_Saturate_float(_Divide_01c8ce94962043679abea203c1772a79_Out_2_Float, _Saturate_bf00c156675b44cd9168e9493fa1fa61_Out_1_Float);
            float _Property_b932cc0b0679463495ea24f5ae20fe0a_Out_0_Float = _Noise_Power;
            float _Power_bc99b52173a44811b5a653f85b30e92b_Out_2_Float;
            Unity_Power_float(_Saturate_bf00c156675b44cd9168e9493fa1fa61_Out_1_Float, _Property_b932cc0b0679463495ea24f5ae20fe0a_Out_0_Float, _Power_bc99b52173a44811b5a653f85b30e92b_Out_2_Float);
            float4 _Property_e85e1549c7ea4dc8be0b5d3469565ffd_Out_0_Vector4 = _Noise_Remap;
            float _Split_10eb25ab4f03492b8209300701e5f945_R_1_Float = _Property_e85e1549c7ea4dc8be0b5d3469565ffd_Out_0_Vector4[0];
            float _Split_10eb25ab4f03492b8209300701e5f945_G_2_Float = _Property_e85e1549c7ea4dc8be0b5d3469565ffd_Out_0_Vector4[1];
            float _Split_10eb25ab4f03492b8209300701e5f945_B_3_Float = _Property_e85e1549c7ea4dc8be0b5d3469565ffd_Out_0_Vector4[2];
            float _Split_10eb25ab4f03492b8209300701e5f945_A_4_Float = _Property_e85e1549c7ea4dc8be0b5d3469565ffd_Out_0_Vector4[3];
            float4 _Combine_edb179662e1a4052b97e671dbd3421a5_RGBA_4_Vector4;
            float3 _Combine_edb179662e1a4052b97e671dbd3421a5_RGB_5_Vector3;
            float2 _Combine_edb179662e1a4052b97e671dbd3421a5_RG_6_Vector2;
            Unity_Combine_float(_Split_10eb25ab4f03492b8209300701e5f945_R_1_Float, _Split_10eb25ab4f03492b8209300701e5f945_G_2_Float, float(0), float(0), _Combine_edb179662e1a4052b97e671dbd3421a5_RGBA_4_Vector4, _Combine_edb179662e1a4052b97e671dbd3421a5_RGB_5_Vector3, _Combine_edb179662e1a4052b97e671dbd3421a5_RG_6_Vector2);
            float4 _Combine_f12ac3a1b10f4f388dab86453258dcb0_RGBA_4_Vector4;
            float3 _Combine_f12ac3a1b10f4f388dab86453258dcb0_RGB_5_Vector3;
            float2 _Combine_f12ac3a1b10f4f388dab86453258dcb0_RG_6_Vector2;
            Unity_Combine_float(_Split_10eb25ab4f03492b8209300701e5f945_B_3_Float, _Split_10eb25ab4f03492b8209300701e5f945_A_4_Float, float(0), float(0), _Combine_f12ac3a1b10f4f388dab86453258dcb0_RGBA_4_Vector4, _Combine_f12ac3a1b10f4f388dab86453258dcb0_RGB_5_Vector3, _Combine_f12ac3a1b10f4f388dab86453258dcb0_RG_6_Vector2);
            float _Remap_b473bb8bd2254a3faad5291ff8cb7707_Out_3_Float;
            Unity_Remap_float(_Power_bc99b52173a44811b5a653f85b30e92b_Out_2_Float, _Combine_edb179662e1a4052b97e671dbd3421a5_RG_6_Vector2, _Combine_f12ac3a1b10f4f388dab86453258dcb0_RG_6_Vector2, _Remap_b473bb8bd2254a3faad5291ff8cb7707_Out_3_Float);
            float _Absolute_2367964a3dae475891ccd6c90e2885ff_Out_1_Float;
            Unity_Absolute_float(_Remap_b473bb8bd2254a3faad5291ff8cb7707_Out_3_Float, _Absolute_2367964a3dae475891ccd6c90e2885ff_Out_1_Float);
            float _Smoothstep_516feede7acb4f97b595cd89bba389c4_Out_3_Float;
            Unity_Smoothstep_float(_Property_f05727b79c2d491a8b9c2d8417d4ce68_Out_0_Float, _Property_7d43401174f8413091e457476f00d1aa_Out_0_Float, _Absolute_2367964a3dae475891ccd6c90e2885ff_Out_1_Float, _Smoothstep_516feede7acb4f97b595cd89bba389c4_Out_3_Float);
            float _Property_44e53f25d86f4edbaab4f19b6daaa067_Out_0_Float = _Base_Speed;
            float _Multiply_619aff87dcc446c5968bd1a6d44fe8b7_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_44e53f25d86f4edbaab4f19b6daaa067_Out_0_Float, _Multiply_619aff87dcc446c5968bd1a6d44fe8b7_Out_2_Float);
            float2 _TilingAndOffset_7cbf9da6c23b409fb98e46b72acb3373_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_a415e5a75c24452bbcd60ac1b3811fc6_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_619aff87dcc446c5968bd1a6d44fe8b7_Out_2_Float.xx), _TilingAndOffset_7cbf9da6c23b409fb98e46b72acb3373_Out_3_Vector2);
            float _Property_9254f8e15d6447988ec18cd37fe88bdc_Out_0_Float = _Base_Scale;
            float _GradientNoise_ce38dcc651b44efeb82145bfdadbf1fa_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_7cbf9da6c23b409fb98e46b72acb3373_Out_3_Vector2, _Property_9254f8e15d6447988ec18cd37fe88bdc_Out_0_Float, _GradientNoise_ce38dcc651b44efeb82145bfdadbf1fa_Out_2_Float);
            float _Property_56d73ff99ec94119881f3d643422251a_Out_0_Float = _Base_Strength;
            float _Multiply_a28097e44d4c485a867948d5b27a71aa_Out_2_Float;
            Unity_Multiply_float_float(_GradientNoise_ce38dcc651b44efeb82145bfdadbf1fa_Out_2_Float, _Property_56d73ff99ec94119881f3d643422251a_Out_0_Float, _Multiply_a28097e44d4c485a867948d5b27a71aa_Out_2_Float);
            float _Add_c6fbda241fda4ff68e2e16893549192e_Out_2_Float;
            Unity_Add_float(_Smoothstep_516feede7acb4f97b595cd89bba389c4_Out_3_Float, _Multiply_a28097e44d4c485a867948d5b27a71aa_Out_2_Float, _Add_c6fbda241fda4ff68e2e16893549192e_Out_2_Float);
            float _Add_5d9343a646914b1582c5ac00b2068a54_Out_2_Float;
            Unity_Add_float(float(0), _Property_56d73ff99ec94119881f3d643422251a_Out_0_Float, _Add_5d9343a646914b1582c5ac00b2068a54_Out_2_Float);
            float _Divide_fe411acd94ed4c4c83892bba30255329_Out_2_Float;
            Unity_Divide_float(_Add_c6fbda241fda4ff68e2e16893549192e_Out_2_Float, _Add_5d9343a646914b1582c5ac00b2068a54_Out_2_Float, _Divide_fe411acd94ed4c4c83892bba30255329_Out_2_Float);
            float3 _Multiply_b525aac067b04a9a8f9ce1a4c4716765_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.ObjectSpaceNormal, (_Divide_fe411acd94ed4c4c83892bba30255329_Out_2_Float.xxx), _Multiply_b525aac067b04a9a8f9ce1a4c4716765_Out_2_Vector3);
            float _Property_81343da7ab424f29a124d673b8099601_Out_0_Float = _Noise_Height;
            float3 _Multiply_431791af81b04fe4920287cee8e84b36_Out_2_Vector3;
            Unity_Multiply_float3_float3(_Multiply_b525aac067b04a9a8f9ce1a4c4716765_Out_2_Vector3, (_Property_81343da7ab424f29a124d673b8099601_Out_0_Float.xxx), _Multiply_431791af81b04fe4920287cee8e84b36_Out_2_Vector3);
            float3 _Add_e716c01d530b428c8bcb16ba04bed031_Out_2_Vector3;
            Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_431791af81b04fe4920287cee8e84b36_Out_2_Vector3, _Add_e716c01d530b428c8bcb16ba04bed031_Out_2_Vector3);
            float3 _Add_fc53f37eba984ae88bea18cd54a386d0_Out_2_Vector3;
            Unity_Add_float3(_Multiply_ff35d2ab09754f1c8b2fac2015de70db_Out_2_Vector3, _Add_e716c01d530b428c8bcb16ba04bed031_Out_2_Vector3, _Add_fc53f37eba984ae88bea18cd54a386d0_Out_2_Vector3);
            description.Position = _Add_fc53f37eba984ae88bea18cd54a386d0_Out_2_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _SceneDepth_7a3cc358e0f44107b8bce7383895b953_Out_1_Float;
            Unity_SceneDepth_Eye_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_7a3cc358e0f44107b8bce7383895b953_Out_1_Float);
            float4 _ScreenPosition_344727010a4a40389b6dd34b4b9b2ac3_Out_0_Vector4 = IN.ScreenPosition;
            float _Split_acb0902b83d148e2a31506c594db0146_R_1_Float = _ScreenPosition_344727010a4a40389b6dd34b4b9b2ac3_Out_0_Vector4[0];
            float _Split_acb0902b83d148e2a31506c594db0146_G_2_Float = _ScreenPosition_344727010a4a40389b6dd34b4b9b2ac3_Out_0_Vector4[1];
            float _Split_acb0902b83d148e2a31506c594db0146_B_3_Float = _ScreenPosition_344727010a4a40389b6dd34b4b9b2ac3_Out_0_Vector4[2];
            float _Split_acb0902b83d148e2a31506c594db0146_A_4_Float = _ScreenPosition_344727010a4a40389b6dd34b4b9b2ac3_Out_0_Vector4[3];
            float _Subtract_3db7c3ced20d44b3a55e93b8d56c3fc1_Out_2_Float;
            Unity_Subtract_float(_Split_acb0902b83d148e2a31506c594db0146_A_4_Float, float(1), _Subtract_3db7c3ced20d44b3a55e93b8d56c3fc1_Out_2_Float);
            float _Subtract_0b683ae745b74caaa4830cb31795132a_Out_2_Float;
            Unity_Subtract_float(_SceneDepth_7a3cc358e0f44107b8bce7383895b953_Out_1_Float, _Subtract_3db7c3ced20d44b3a55e93b8d56c3fc1_Out_2_Float, _Subtract_0b683ae745b74caaa4830cb31795132a_Out_2_Float);
            float _Property_13ffae534f05496e8446dd4eff4d54b3_Out_0_Float = _Fade_Depth;
            float _Divide_5ea1c32f7a9541ce96555bb9c53dad4e_Out_2_Float;
            Unity_Divide_float(_Subtract_0b683ae745b74caaa4830cb31795132a_Out_2_Float, _Property_13ffae534f05496e8446dd4eff4d54b3_Out_0_Float, _Divide_5ea1c32f7a9541ce96555bb9c53dad4e_Out_2_Float);
            float _Saturate_11cb953c9f3a4ad98649c8032095e0a5_Out_1_Float;
            Unity_Saturate_float(_Divide_5ea1c32f7a9541ce96555bb9c53dad4e_Out_2_Float, _Saturate_11cb953c9f3a4ad98649c8032095e0a5_Out_1_Float);
            float _Smoothstep_804d457501334adcb743390e55365a80_Out_3_Float;
            Unity_Smoothstep_float(float(0), float(1), _Saturate_11cb953c9f3a4ad98649c8032095e0a5_Out_1_Float, _Smoothstep_804d457501334adcb743390e55365a80_Out_3_Float);
            surface.Alpha = _Smoothstep_804d457501334adcb743390e55365a80_Out_3_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.WorldSpaceNormal =                           TransformObjectToWorldNormal(input.normalOS);
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.WorldSpacePosition =                         TransformObjectToWorld(input.positionOS);
            output.TimeParameters =                             _TimeParameters.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "DepthNormals"
            Tags
            {
                "LightMode" = "DepthNormals"
            }
        
        // Render State
        Cull Off
        ZTest LEqual
        ZWrite On
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHNORMALS
        #define REQUIRE_DEPTH_TEXTURE
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv1 : TEXCOORD1;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 TangentSpaceNormal;
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 WorldSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float3 WorldSpacePosition;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 tangentWS : INTERP0;
             float3 positionWS : INTERP1;
             float3 normalWS : INTERP2;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.tangentWS.xyzw = input.tangentWS;
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.tangentWS = input.tangentWS.xyzw;
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _Rotate_Projection;
        float _Noise_Scale;
        float _Noise_Speed;
        float _Noise_Height;
        float4 _Noise_Remap;
        float4 _Color_A;
        float4 _Color_B;
        float _Smooth_Step_1;
        float _Smooth_Step_2;
        float _Noise_Power;
        float _Base_Scale;
        float _Base_Speed;
        float _Base_Strength;
        float _Emission_Strength;
        float _Curvature_Radius;
        float _Fresnel_Effect_Power;
        float _Fresnel_Effect_Opacity;
        float _Fade_Depth;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Distance_float3(float3 A, float3 B, out float Out)
        {
            Out = distance(A, B);
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
        {
            Rotation = radians(Rotation);
            float s, c;
            sincos(Rotation, s, c);
            Axis = normalize(Axis);
            Out = In * c + cross(Axis, In) * s + Axis * dot(Axis, In) * (1 - c);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
        {
            float x; Hash_Tchou_2_1_float(p, x);
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
        {
            float2 p = UV * Scale.xy;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            if (unity_OrthoParams.w == 1.0)
            {
                Out = LinearEyeDepth(ComputeWorldSpacePosition(UV.xy, SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), UNITY_MATRIX_I_VP), UNITY_MATRIX_V);
            }
            else
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Distance_2db07498d99c49328512eaf4405dfb7d_Out_2_Float;
            Unity_Distance_float3(SHADERGRAPH_OBJECT_POSITION, IN.WorldSpacePosition, _Distance_2db07498d99c49328512eaf4405dfb7d_Out_2_Float);
            float _Property_781afe0d084b4e86ba202ae12d2df5c3_Out_0_Float = _Curvature_Radius;
            float _Divide_3a2887a0281d4fb9a0b32e1c0fa89d00_Out_2_Float;
            Unity_Divide_float(_Distance_2db07498d99c49328512eaf4405dfb7d_Out_2_Float, _Property_781afe0d084b4e86ba202ae12d2df5c3_Out_0_Float, _Divide_3a2887a0281d4fb9a0b32e1c0fa89d00_Out_2_Float);
            float _Power_dae4028a0ef04cc885209d872784f592_Out_2_Float;
            Unity_Power_float(_Divide_3a2887a0281d4fb9a0b32e1c0fa89d00_Out_2_Float, float(3), _Power_dae4028a0ef04cc885209d872784f592_Out_2_Float);
            float3 _Multiply_ff35d2ab09754f1c8b2fac2015de70db_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.WorldSpaceNormal, (_Power_dae4028a0ef04cc885209d872784f592_Out_2_Float.xxx), _Multiply_ff35d2ab09754f1c8b2fac2015de70db_Out_2_Vector3);
            float _Property_f05727b79c2d491a8b9c2d8417d4ce68_Out_0_Float = _Smooth_Step_1;
            float _Property_7d43401174f8413091e457476f00d1aa_Out_0_Float = _Smooth_Step_2;
            float4 _Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4 = _Rotate_Projection;
            float _Split_610d0b28a0e94e38b42626a03d9f9794_R_1_Float = _Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4[0];
            float _Split_610d0b28a0e94e38b42626a03d9f9794_G_2_Float = _Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4[1];
            float _Split_610d0b28a0e94e38b42626a03d9f9794_B_3_Float = _Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4[2];
            float _Split_610d0b28a0e94e38b42626a03d9f9794_A_4_Float = _Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4[3];
            float3 _RotateAboutAxis_a415e5a75c24452bbcd60ac1b3811fc6_Out_3_Vector3;
            Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4.xyz), _Split_610d0b28a0e94e38b42626a03d9f9794_A_4_Float, _RotateAboutAxis_a415e5a75c24452bbcd60ac1b3811fc6_Out_3_Vector3);
            float _Property_2ada180c9afb42be8c587ae354b92988_Out_0_Float = _Noise_Speed;
            float _Multiply_ab217b8df9084424b472a49bafb4515d_Out_2_Float;
            Unity_Multiply_float_float(_Property_2ada180c9afb42be8c587ae354b92988_Out_0_Float, IN.TimeParameters.x, _Multiply_ab217b8df9084424b472a49bafb4515d_Out_2_Float);
            float2 _TilingAndOffset_0b468c25d4d14a999d61900af42dd09d_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_a415e5a75c24452bbcd60ac1b3811fc6_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_ab217b8df9084424b472a49bafb4515d_Out_2_Float.xx), _TilingAndOffset_0b468c25d4d14a999d61900af42dd09d_Out_3_Vector2);
            float _Property_4cdc099c195e4d6a8f9f35604045d0b7_Out_0_Float = _Noise_Scale;
            float _GradientNoise_26bc13aecb1b4c2081638300cc42b01d_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_0b468c25d4d14a999d61900af42dd09d_Out_3_Vector2, _Property_4cdc099c195e4d6a8f9f35604045d0b7_Out_0_Float, _GradientNoise_26bc13aecb1b4c2081638300cc42b01d_Out_2_Float);
            float2 _TilingAndOffset_88de901db4e14268b84877dc201207b6_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_a415e5a75c24452bbcd60ac1b3811fc6_Out_3_Vector3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_88de901db4e14268b84877dc201207b6_Out_3_Vector2);
            float _GradientNoise_aa58bf81bf93430985a301e296a23ad8_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_88de901db4e14268b84877dc201207b6_Out_3_Vector2, _Property_4cdc099c195e4d6a8f9f35604045d0b7_Out_0_Float, _GradientNoise_aa58bf81bf93430985a301e296a23ad8_Out_2_Float);
            float _Add_7767c92e2dbe4c9e8ec3922a6c504040_Out_2_Float;
            Unity_Add_float(_GradientNoise_26bc13aecb1b4c2081638300cc42b01d_Out_2_Float, _GradientNoise_aa58bf81bf93430985a301e296a23ad8_Out_2_Float, _Add_7767c92e2dbe4c9e8ec3922a6c504040_Out_2_Float);
            float _Divide_01c8ce94962043679abea203c1772a79_Out_2_Float;
            Unity_Divide_float(_Add_7767c92e2dbe4c9e8ec3922a6c504040_Out_2_Float, float(2), _Divide_01c8ce94962043679abea203c1772a79_Out_2_Float);
            float _Saturate_bf00c156675b44cd9168e9493fa1fa61_Out_1_Float;
            Unity_Saturate_float(_Divide_01c8ce94962043679abea203c1772a79_Out_2_Float, _Saturate_bf00c156675b44cd9168e9493fa1fa61_Out_1_Float);
            float _Property_b932cc0b0679463495ea24f5ae20fe0a_Out_0_Float = _Noise_Power;
            float _Power_bc99b52173a44811b5a653f85b30e92b_Out_2_Float;
            Unity_Power_float(_Saturate_bf00c156675b44cd9168e9493fa1fa61_Out_1_Float, _Property_b932cc0b0679463495ea24f5ae20fe0a_Out_0_Float, _Power_bc99b52173a44811b5a653f85b30e92b_Out_2_Float);
            float4 _Property_e85e1549c7ea4dc8be0b5d3469565ffd_Out_0_Vector4 = _Noise_Remap;
            float _Split_10eb25ab4f03492b8209300701e5f945_R_1_Float = _Property_e85e1549c7ea4dc8be0b5d3469565ffd_Out_0_Vector4[0];
            float _Split_10eb25ab4f03492b8209300701e5f945_G_2_Float = _Property_e85e1549c7ea4dc8be0b5d3469565ffd_Out_0_Vector4[1];
            float _Split_10eb25ab4f03492b8209300701e5f945_B_3_Float = _Property_e85e1549c7ea4dc8be0b5d3469565ffd_Out_0_Vector4[2];
            float _Split_10eb25ab4f03492b8209300701e5f945_A_4_Float = _Property_e85e1549c7ea4dc8be0b5d3469565ffd_Out_0_Vector4[3];
            float4 _Combine_edb179662e1a4052b97e671dbd3421a5_RGBA_4_Vector4;
            float3 _Combine_edb179662e1a4052b97e671dbd3421a5_RGB_5_Vector3;
            float2 _Combine_edb179662e1a4052b97e671dbd3421a5_RG_6_Vector2;
            Unity_Combine_float(_Split_10eb25ab4f03492b8209300701e5f945_R_1_Float, _Split_10eb25ab4f03492b8209300701e5f945_G_2_Float, float(0), float(0), _Combine_edb179662e1a4052b97e671dbd3421a5_RGBA_4_Vector4, _Combine_edb179662e1a4052b97e671dbd3421a5_RGB_5_Vector3, _Combine_edb179662e1a4052b97e671dbd3421a5_RG_6_Vector2);
            float4 _Combine_f12ac3a1b10f4f388dab86453258dcb0_RGBA_4_Vector4;
            float3 _Combine_f12ac3a1b10f4f388dab86453258dcb0_RGB_5_Vector3;
            float2 _Combine_f12ac3a1b10f4f388dab86453258dcb0_RG_6_Vector2;
            Unity_Combine_float(_Split_10eb25ab4f03492b8209300701e5f945_B_3_Float, _Split_10eb25ab4f03492b8209300701e5f945_A_4_Float, float(0), float(0), _Combine_f12ac3a1b10f4f388dab86453258dcb0_RGBA_4_Vector4, _Combine_f12ac3a1b10f4f388dab86453258dcb0_RGB_5_Vector3, _Combine_f12ac3a1b10f4f388dab86453258dcb0_RG_6_Vector2);
            float _Remap_b473bb8bd2254a3faad5291ff8cb7707_Out_3_Float;
            Unity_Remap_float(_Power_bc99b52173a44811b5a653f85b30e92b_Out_2_Float, _Combine_edb179662e1a4052b97e671dbd3421a5_RG_6_Vector2, _Combine_f12ac3a1b10f4f388dab86453258dcb0_RG_6_Vector2, _Remap_b473bb8bd2254a3faad5291ff8cb7707_Out_3_Float);
            float _Absolute_2367964a3dae475891ccd6c90e2885ff_Out_1_Float;
            Unity_Absolute_float(_Remap_b473bb8bd2254a3faad5291ff8cb7707_Out_3_Float, _Absolute_2367964a3dae475891ccd6c90e2885ff_Out_1_Float);
            float _Smoothstep_516feede7acb4f97b595cd89bba389c4_Out_3_Float;
            Unity_Smoothstep_float(_Property_f05727b79c2d491a8b9c2d8417d4ce68_Out_0_Float, _Property_7d43401174f8413091e457476f00d1aa_Out_0_Float, _Absolute_2367964a3dae475891ccd6c90e2885ff_Out_1_Float, _Smoothstep_516feede7acb4f97b595cd89bba389c4_Out_3_Float);
            float _Property_44e53f25d86f4edbaab4f19b6daaa067_Out_0_Float = _Base_Speed;
            float _Multiply_619aff87dcc446c5968bd1a6d44fe8b7_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_44e53f25d86f4edbaab4f19b6daaa067_Out_0_Float, _Multiply_619aff87dcc446c5968bd1a6d44fe8b7_Out_2_Float);
            float2 _TilingAndOffset_7cbf9da6c23b409fb98e46b72acb3373_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_a415e5a75c24452bbcd60ac1b3811fc6_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_619aff87dcc446c5968bd1a6d44fe8b7_Out_2_Float.xx), _TilingAndOffset_7cbf9da6c23b409fb98e46b72acb3373_Out_3_Vector2);
            float _Property_9254f8e15d6447988ec18cd37fe88bdc_Out_0_Float = _Base_Scale;
            float _GradientNoise_ce38dcc651b44efeb82145bfdadbf1fa_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_7cbf9da6c23b409fb98e46b72acb3373_Out_3_Vector2, _Property_9254f8e15d6447988ec18cd37fe88bdc_Out_0_Float, _GradientNoise_ce38dcc651b44efeb82145bfdadbf1fa_Out_2_Float);
            float _Property_56d73ff99ec94119881f3d643422251a_Out_0_Float = _Base_Strength;
            float _Multiply_a28097e44d4c485a867948d5b27a71aa_Out_2_Float;
            Unity_Multiply_float_float(_GradientNoise_ce38dcc651b44efeb82145bfdadbf1fa_Out_2_Float, _Property_56d73ff99ec94119881f3d643422251a_Out_0_Float, _Multiply_a28097e44d4c485a867948d5b27a71aa_Out_2_Float);
            float _Add_c6fbda241fda4ff68e2e16893549192e_Out_2_Float;
            Unity_Add_float(_Smoothstep_516feede7acb4f97b595cd89bba389c4_Out_3_Float, _Multiply_a28097e44d4c485a867948d5b27a71aa_Out_2_Float, _Add_c6fbda241fda4ff68e2e16893549192e_Out_2_Float);
            float _Add_5d9343a646914b1582c5ac00b2068a54_Out_2_Float;
            Unity_Add_float(float(0), _Property_56d73ff99ec94119881f3d643422251a_Out_0_Float, _Add_5d9343a646914b1582c5ac00b2068a54_Out_2_Float);
            float _Divide_fe411acd94ed4c4c83892bba30255329_Out_2_Float;
            Unity_Divide_float(_Add_c6fbda241fda4ff68e2e16893549192e_Out_2_Float, _Add_5d9343a646914b1582c5ac00b2068a54_Out_2_Float, _Divide_fe411acd94ed4c4c83892bba30255329_Out_2_Float);
            float3 _Multiply_b525aac067b04a9a8f9ce1a4c4716765_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.ObjectSpaceNormal, (_Divide_fe411acd94ed4c4c83892bba30255329_Out_2_Float.xxx), _Multiply_b525aac067b04a9a8f9ce1a4c4716765_Out_2_Vector3);
            float _Property_81343da7ab424f29a124d673b8099601_Out_0_Float = _Noise_Height;
            float3 _Multiply_431791af81b04fe4920287cee8e84b36_Out_2_Vector3;
            Unity_Multiply_float3_float3(_Multiply_b525aac067b04a9a8f9ce1a4c4716765_Out_2_Vector3, (_Property_81343da7ab424f29a124d673b8099601_Out_0_Float.xxx), _Multiply_431791af81b04fe4920287cee8e84b36_Out_2_Vector3);
            float3 _Add_e716c01d530b428c8bcb16ba04bed031_Out_2_Vector3;
            Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_431791af81b04fe4920287cee8e84b36_Out_2_Vector3, _Add_e716c01d530b428c8bcb16ba04bed031_Out_2_Vector3);
            float3 _Add_fc53f37eba984ae88bea18cd54a386d0_Out_2_Vector3;
            Unity_Add_float3(_Multiply_ff35d2ab09754f1c8b2fac2015de70db_Out_2_Vector3, _Add_e716c01d530b428c8bcb16ba04bed031_Out_2_Vector3, _Add_fc53f37eba984ae88bea18cd54a386d0_Out_2_Vector3);
            description.Position = _Add_fc53f37eba984ae88bea18cd54a386d0_Out_2_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 NormalTS;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _SceneDepth_7a3cc358e0f44107b8bce7383895b953_Out_1_Float;
            Unity_SceneDepth_Eye_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_7a3cc358e0f44107b8bce7383895b953_Out_1_Float);
            float4 _ScreenPosition_344727010a4a40389b6dd34b4b9b2ac3_Out_0_Vector4 = IN.ScreenPosition;
            float _Split_acb0902b83d148e2a31506c594db0146_R_1_Float = _ScreenPosition_344727010a4a40389b6dd34b4b9b2ac3_Out_0_Vector4[0];
            float _Split_acb0902b83d148e2a31506c594db0146_G_2_Float = _ScreenPosition_344727010a4a40389b6dd34b4b9b2ac3_Out_0_Vector4[1];
            float _Split_acb0902b83d148e2a31506c594db0146_B_3_Float = _ScreenPosition_344727010a4a40389b6dd34b4b9b2ac3_Out_0_Vector4[2];
            float _Split_acb0902b83d148e2a31506c594db0146_A_4_Float = _ScreenPosition_344727010a4a40389b6dd34b4b9b2ac3_Out_0_Vector4[3];
            float _Subtract_3db7c3ced20d44b3a55e93b8d56c3fc1_Out_2_Float;
            Unity_Subtract_float(_Split_acb0902b83d148e2a31506c594db0146_A_4_Float, float(1), _Subtract_3db7c3ced20d44b3a55e93b8d56c3fc1_Out_2_Float);
            float _Subtract_0b683ae745b74caaa4830cb31795132a_Out_2_Float;
            Unity_Subtract_float(_SceneDepth_7a3cc358e0f44107b8bce7383895b953_Out_1_Float, _Subtract_3db7c3ced20d44b3a55e93b8d56c3fc1_Out_2_Float, _Subtract_0b683ae745b74caaa4830cb31795132a_Out_2_Float);
            float _Property_13ffae534f05496e8446dd4eff4d54b3_Out_0_Float = _Fade_Depth;
            float _Divide_5ea1c32f7a9541ce96555bb9c53dad4e_Out_2_Float;
            Unity_Divide_float(_Subtract_0b683ae745b74caaa4830cb31795132a_Out_2_Float, _Property_13ffae534f05496e8446dd4eff4d54b3_Out_0_Float, _Divide_5ea1c32f7a9541ce96555bb9c53dad4e_Out_2_Float);
            float _Saturate_11cb953c9f3a4ad98649c8032095e0a5_Out_1_Float;
            Unity_Saturate_float(_Divide_5ea1c32f7a9541ce96555bb9c53dad4e_Out_2_Float, _Saturate_11cb953c9f3a4ad98649c8032095e0a5_Out_1_Float);
            float _Smoothstep_804d457501334adcb743390e55365a80_Out_3_Float;
            Unity_Smoothstep_float(float(0), float(1), _Saturate_11cb953c9f3a4ad98649c8032095e0a5_Out_1_Float, _Smoothstep_804d457501334adcb743390e55365a80_Out_3_Float);
            surface.NormalTS = IN.TangentSpaceNormal;
            surface.Alpha = _Smoothstep_804d457501334adcb743390e55365a80_Out_3_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.WorldSpaceNormal =                           TransformObjectToWorldNormal(input.normalOS);
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.WorldSpacePosition =                         TransformObjectToWorld(input.positionOS);
            output.TimeParameters =                             _TimeParameters.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthNormalsOnlyPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "Meta"
            Tags
            {
                "LightMode" = "Meta"
            }
        
        // Render State
        Cull Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma shader_feature _ EDITOR_VISUALIZATION
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define ATTRIBUTES_NEED_INSTANCEID
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_TEXCOORD1
        #define VARYINGS_NEED_TEXCOORD2
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_META
        #define _FOG_FRAGMENT 1
        #define REQUIRE_DEPTH_TEXTURE
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MetaInput.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 texCoord0;
             float4 texCoord1;
             float4 texCoord2;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpaceNormal;
             float3 WorldSpaceViewDirection;
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 WorldSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float3 WorldSpacePosition;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0 : INTERP0;
             float4 texCoord1 : INTERP1;
             float4 texCoord2 : INTERP2;
             float3 positionWS : INTERP3;
             float3 normalWS : INTERP4;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.texCoord0.xyzw = input.texCoord0;
            output.texCoord1.xyzw = input.texCoord1;
            output.texCoord2.xyzw = input.texCoord2;
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.texCoord0.xyzw;
            output.texCoord1 = input.texCoord1.xyzw;
            output.texCoord2 = input.texCoord2.xyzw;
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _Rotate_Projection;
        float _Noise_Scale;
        float _Noise_Speed;
        float _Noise_Height;
        float4 _Noise_Remap;
        float4 _Color_A;
        float4 _Color_B;
        float _Smooth_Step_1;
        float _Smooth_Step_2;
        float _Noise_Power;
        float _Base_Scale;
        float _Base_Speed;
        float _Base_Strength;
        float _Emission_Strength;
        float _Curvature_Radius;
        float _Fresnel_Effect_Power;
        float _Fresnel_Effect_Opacity;
        float _Fade_Depth;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Distance_float3(float3 A, float3 B, out float Out)
        {
            Out = distance(A, B);
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
        {
            Rotation = radians(Rotation);
            float s, c;
            sincos(Rotation, s, c);
            Axis = normalize(Axis);
            Out = In * c + cross(Axis, In) * s + Axis * dot(Axis, In) * (1 - c);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
        {
            float x; Hash_Tchou_2_1_float(p, x);
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
        {
            float2 p = UV * Scale.xy;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_FresnelEffect_float(float3 Normal, float3 ViewDir, float Power, out float Out)
        {
            Out = pow((1.0 - saturate(dot(normalize(Normal), ViewDir))), Power);
        }
        
        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            if (unity_OrthoParams.w == 1.0)
            {
                Out = LinearEyeDepth(ComputeWorldSpacePosition(UV.xy, SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), UNITY_MATRIX_I_VP), UNITY_MATRIX_V);
            }
            else
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Distance_2db07498d99c49328512eaf4405dfb7d_Out_2_Float;
            Unity_Distance_float3(SHADERGRAPH_OBJECT_POSITION, IN.WorldSpacePosition, _Distance_2db07498d99c49328512eaf4405dfb7d_Out_2_Float);
            float _Property_781afe0d084b4e86ba202ae12d2df5c3_Out_0_Float = _Curvature_Radius;
            float _Divide_3a2887a0281d4fb9a0b32e1c0fa89d00_Out_2_Float;
            Unity_Divide_float(_Distance_2db07498d99c49328512eaf4405dfb7d_Out_2_Float, _Property_781afe0d084b4e86ba202ae12d2df5c3_Out_0_Float, _Divide_3a2887a0281d4fb9a0b32e1c0fa89d00_Out_2_Float);
            float _Power_dae4028a0ef04cc885209d872784f592_Out_2_Float;
            Unity_Power_float(_Divide_3a2887a0281d4fb9a0b32e1c0fa89d00_Out_2_Float, float(3), _Power_dae4028a0ef04cc885209d872784f592_Out_2_Float);
            float3 _Multiply_ff35d2ab09754f1c8b2fac2015de70db_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.WorldSpaceNormal, (_Power_dae4028a0ef04cc885209d872784f592_Out_2_Float.xxx), _Multiply_ff35d2ab09754f1c8b2fac2015de70db_Out_2_Vector3);
            float _Property_f05727b79c2d491a8b9c2d8417d4ce68_Out_0_Float = _Smooth_Step_1;
            float _Property_7d43401174f8413091e457476f00d1aa_Out_0_Float = _Smooth_Step_2;
            float4 _Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4 = _Rotate_Projection;
            float _Split_610d0b28a0e94e38b42626a03d9f9794_R_1_Float = _Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4[0];
            float _Split_610d0b28a0e94e38b42626a03d9f9794_G_2_Float = _Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4[1];
            float _Split_610d0b28a0e94e38b42626a03d9f9794_B_3_Float = _Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4[2];
            float _Split_610d0b28a0e94e38b42626a03d9f9794_A_4_Float = _Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4[3];
            float3 _RotateAboutAxis_a415e5a75c24452bbcd60ac1b3811fc6_Out_3_Vector3;
            Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4.xyz), _Split_610d0b28a0e94e38b42626a03d9f9794_A_4_Float, _RotateAboutAxis_a415e5a75c24452bbcd60ac1b3811fc6_Out_3_Vector3);
            float _Property_2ada180c9afb42be8c587ae354b92988_Out_0_Float = _Noise_Speed;
            float _Multiply_ab217b8df9084424b472a49bafb4515d_Out_2_Float;
            Unity_Multiply_float_float(_Property_2ada180c9afb42be8c587ae354b92988_Out_0_Float, IN.TimeParameters.x, _Multiply_ab217b8df9084424b472a49bafb4515d_Out_2_Float);
            float2 _TilingAndOffset_0b468c25d4d14a999d61900af42dd09d_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_a415e5a75c24452bbcd60ac1b3811fc6_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_ab217b8df9084424b472a49bafb4515d_Out_2_Float.xx), _TilingAndOffset_0b468c25d4d14a999d61900af42dd09d_Out_3_Vector2);
            float _Property_4cdc099c195e4d6a8f9f35604045d0b7_Out_0_Float = _Noise_Scale;
            float _GradientNoise_26bc13aecb1b4c2081638300cc42b01d_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_0b468c25d4d14a999d61900af42dd09d_Out_3_Vector2, _Property_4cdc099c195e4d6a8f9f35604045d0b7_Out_0_Float, _GradientNoise_26bc13aecb1b4c2081638300cc42b01d_Out_2_Float);
            float2 _TilingAndOffset_88de901db4e14268b84877dc201207b6_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_a415e5a75c24452bbcd60ac1b3811fc6_Out_3_Vector3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_88de901db4e14268b84877dc201207b6_Out_3_Vector2);
            float _GradientNoise_aa58bf81bf93430985a301e296a23ad8_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_88de901db4e14268b84877dc201207b6_Out_3_Vector2, _Property_4cdc099c195e4d6a8f9f35604045d0b7_Out_0_Float, _GradientNoise_aa58bf81bf93430985a301e296a23ad8_Out_2_Float);
            float _Add_7767c92e2dbe4c9e8ec3922a6c504040_Out_2_Float;
            Unity_Add_float(_GradientNoise_26bc13aecb1b4c2081638300cc42b01d_Out_2_Float, _GradientNoise_aa58bf81bf93430985a301e296a23ad8_Out_2_Float, _Add_7767c92e2dbe4c9e8ec3922a6c504040_Out_2_Float);
            float _Divide_01c8ce94962043679abea203c1772a79_Out_2_Float;
            Unity_Divide_float(_Add_7767c92e2dbe4c9e8ec3922a6c504040_Out_2_Float, float(2), _Divide_01c8ce94962043679abea203c1772a79_Out_2_Float);
            float _Saturate_bf00c156675b44cd9168e9493fa1fa61_Out_1_Float;
            Unity_Saturate_float(_Divide_01c8ce94962043679abea203c1772a79_Out_2_Float, _Saturate_bf00c156675b44cd9168e9493fa1fa61_Out_1_Float);
            float _Property_b932cc0b0679463495ea24f5ae20fe0a_Out_0_Float = _Noise_Power;
            float _Power_bc99b52173a44811b5a653f85b30e92b_Out_2_Float;
            Unity_Power_float(_Saturate_bf00c156675b44cd9168e9493fa1fa61_Out_1_Float, _Property_b932cc0b0679463495ea24f5ae20fe0a_Out_0_Float, _Power_bc99b52173a44811b5a653f85b30e92b_Out_2_Float);
            float4 _Property_e85e1549c7ea4dc8be0b5d3469565ffd_Out_0_Vector4 = _Noise_Remap;
            float _Split_10eb25ab4f03492b8209300701e5f945_R_1_Float = _Property_e85e1549c7ea4dc8be0b5d3469565ffd_Out_0_Vector4[0];
            float _Split_10eb25ab4f03492b8209300701e5f945_G_2_Float = _Property_e85e1549c7ea4dc8be0b5d3469565ffd_Out_0_Vector4[1];
            float _Split_10eb25ab4f03492b8209300701e5f945_B_3_Float = _Property_e85e1549c7ea4dc8be0b5d3469565ffd_Out_0_Vector4[2];
            float _Split_10eb25ab4f03492b8209300701e5f945_A_4_Float = _Property_e85e1549c7ea4dc8be0b5d3469565ffd_Out_0_Vector4[3];
            float4 _Combine_edb179662e1a4052b97e671dbd3421a5_RGBA_4_Vector4;
            float3 _Combine_edb179662e1a4052b97e671dbd3421a5_RGB_5_Vector3;
            float2 _Combine_edb179662e1a4052b97e671dbd3421a5_RG_6_Vector2;
            Unity_Combine_float(_Split_10eb25ab4f03492b8209300701e5f945_R_1_Float, _Split_10eb25ab4f03492b8209300701e5f945_G_2_Float, float(0), float(0), _Combine_edb179662e1a4052b97e671dbd3421a5_RGBA_4_Vector4, _Combine_edb179662e1a4052b97e671dbd3421a5_RGB_5_Vector3, _Combine_edb179662e1a4052b97e671dbd3421a5_RG_6_Vector2);
            float4 _Combine_f12ac3a1b10f4f388dab86453258dcb0_RGBA_4_Vector4;
            float3 _Combine_f12ac3a1b10f4f388dab86453258dcb0_RGB_5_Vector3;
            float2 _Combine_f12ac3a1b10f4f388dab86453258dcb0_RG_6_Vector2;
            Unity_Combine_float(_Split_10eb25ab4f03492b8209300701e5f945_B_3_Float, _Split_10eb25ab4f03492b8209300701e5f945_A_4_Float, float(0), float(0), _Combine_f12ac3a1b10f4f388dab86453258dcb0_RGBA_4_Vector4, _Combine_f12ac3a1b10f4f388dab86453258dcb0_RGB_5_Vector3, _Combine_f12ac3a1b10f4f388dab86453258dcb0_RG_6_Vector2);
            float _Remap_b473bb8bd2254a3faad5291ff8cb7707_Out_3_Float;
            Unity_Remap_float(_Power_bc99b52173a44811b5a653f85b30e92b_Out_2_Float, _Combine_edb179662e1a4052b97e671dbd3421a5_RG_6_Vector2, _Combine_f12ac3a1b10f4f388dab86453258dcb0_RG_6_Vector2, _Remap_b473bb8bd2254a3faad5291ff8cb7707_Out_3_Float);
            float _Absolute_2367964a3dae475891ccd6c90e2885ff_Out_1_Float;
            Unity_Absolute_float(_Remap_b473bb8bd2254a3faad5291ff8cb7707_Out_3_Float, _Absolute_2367964a3dae475891ccd6c90e2885ff_Out_1_Float);
            float _Smoothstep_516feede7acb4f97b595cd89bba389c4_Out_3_Float;
            Unity_Smoothstep_float(_Property_f05727b79c2d491a8b9c2d8417d4ce68_Out_0_Float, _Property_7d43401174f8413091e457476f00d1aa_Out_0_Float, _Absolute_2367964a3dae475891ccd6c90e2885ff_Out_1_Float, _Smoothstep_516feede7acb4f97b595cd89bba389c4_Out_3_Float);
            float _Property_44e53f25d86f4edbaab4f19b6daaa067_Out_0_Float = _Base_Speed;
            float _Multiply_619aff87dcc446c5968bd1a6d44fe8b7_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_44e53f25d86f4edbaab4f19b6daaa067_Out_0_Float, _Multiply_619aff87dcc446c5968bd1a6d44fe8b7_Out_2_Float);
            float2 _TilingAndOffset_7cbf9da6c23b409fb98e46b72acb3373_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_a415e5a75c24452bbcd60ac1b3811fc6_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_619aff87dcc446c5968bd1a6d44fe8b7_Out_2_Float.xx), _TilingAndOffset_7cbf9da6c23b409fb98e46b72acb3373_Out_3_Vector2);
            float _Property_9254f8e15d6447988ec18cd37fe88bdc_Out_0_Float = _Base_Scale;
            float _GradientNoise_ce38dcc651b44efeb82145bfdadbf1fa_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_7cbf9da6c23b409fb98e46b72acb3373_Out_3_Vector2, _Property_9254f8e15d6447988ec18cd37fe88bdc_Out_0_Float, _GradientNoise_ce38dcc651b44efeb82145bfdadbf1fa_Out_2_Float);
            float _Property_56d73ff99ec94119881f3d643422251a_Out_0_Float = _Base_Strength;
            float _Multiply_a28097e44d4c485a867948d5b27a71aa_Out_2_Float;
            Unity_Multiply_float_float(_GradientNoise_ce38dcc651b44efeb82145bfdadbf1fa_Out_2_Float, _Property_56d73ff99ec94119881f3d643422251a_Out_0_Float, _Multiply_a28097e44d4c485a867948d5b27a71aa_Out_2_Float);
            float _Add_c6fbda241fda4ff68e2e16893549192e_Out_2_Float;
            Unity_Add_float(_Smoothstep_516feede7acb4f97b595cd89bba389c4_Out_3_Float, _Multiply_a28097e44d4c485a867948d5b27a71aa_Out_2_Float, _Add_c6fbda241fda4ff68e2e16893549192e_Out_2_Float);
            float _Add_5d9343a646914b1582c5ac00b2068a54_Out_2_Float;
            Unity_Add_float(float(0), _Property_56d73ff99ec94119881f3d643422251a_Out_0_Float, _Add_5d9343a646914b1582c5ac00b2068a54_Out_2_Float);
            float _Divide_fe411acd94ed4c4c83892bba30255329_Out_2_Float;
            Unity_Divide_float(_Add_c6fbda241fda4ff68e2e16893549192e_Out_2_Float, _Add_5d9343a646914b1582c5ac00b2068a54_Out_2_Float, _Divide_fe411acd94ed4c4c83892bba30255329_Out_2_Float);
            float3 _Multiply_b525aac067b04a9a8f9ce1a4c4716765_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.ObjectSpaceNormal, (_Divide_fe411acd94ed4c4c83892bba30255329_Out_2_Float.xxx), _Multiply_b525aac067b04a9a8f9ce1a4c4716765_Out_2_Vector3);
            float _Property_81343da7ab424f29a124d673b8099601_Out_0_Float = _Noise_Height;
            float3 _Multiply_431791af81b04fe4920287cee8e84b36_Out_2_Vector3;
            Unity_Multiply_float3_float3(_Multiply_b525aac067b04a9a8f9ce1a4c4716765_Out_2_Vector3, (_Property_81343da7ab424f29a124d673b8099601_Out_0_Float.xxx), _Multiply_431791af81b04fe4920287cee8e84b36_Out_2_Vector3);
            float3 _Add_e716c01d530b428c8bcb16ba04bed031_Out_2_Vector3;
            Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_431791af81b04fe4920287cee8e84b36_Out_2_Vector3, _Add_e716c01d530b428c8bcb16ba04bed031_Out_2_Vector3);
            float3 _Add_fc53f37eba984ae88bea18cd54a386d0_Out_2_Vector3;
            Unity_Add_float3(_Multiply_ff35d2ab09754f1c8b2fac2015de70db_Out_2_Vector3, _Add_e716c01d530b428c8bcb16ba04bed031_Out_2_Vector3, _Add_fc53f37eba984ae88bea18cd54a386d0_Out_2_Vector3);
            description.Position = _Add_fc53f37eba984ae88bea18cd54a386d0_Out_2_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float3 Emission;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_08f55cc2215f457abdf288e58daaa696_Out_0_Vector4 = _Color_A;
            float4 _Property_acbafd3dca104c65b7b71611d4639044_Out_0_Vector4 = _Color_B;
            float _Property_f05727b79c2d491a8b9c2d8417d4ce68_Out_0_Float = _Smooth_Step_1;
            float _Property_7d43401174f8413091e457476f00d1aa_Out_0_Float = _Smooth_Step_2;
            float4 _Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4 = _Rotate_Projection;
            float _Split_610d0b28a0e94e38b42626a03d9f9794_R_1_Float = _Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4[0];
            float _Split_610d0b28a0e94e38b42626a03d9f9794_G_2_Float = _Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4[1];
            float _Split_610d0b28a0e94e38b42626a03d9f9794_B_3_Float = _Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4[2];
            float _Split_610d0b28a0e94e38b42626a03d9f9794_A_4_Float = _Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4[3];
            float3 _RotateAboutAxis_a415e5a75c24452bbcd60ac1b3811fc6_Out_3_Vector3;
            Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4.xyz), _Split_610d0b28a0e94e38b42626a03d9f9794_A_4_Float, _RotateAboutAxis_a415e5a75c24452bbcd60ac1b3811fc6_Out_3_Vector3);
            float _Property_2ada180c9afb42be8c587ae354b92988_Out_0_Float = _Noise_Speed;
            float _Multiply_ab217b8df9084424b472a49bafb4515d_Out_2_Float;
            Unity_Multiply_float_float(_Property_2ada180c9afb42be8c587ae354b92988_Out_0_Float, IN.TimeParameters.x, _Multiply_ab217b8df9084424b472a49bafb4515d_Out_2_Float);
            float2 _TilingAndOffset_0b468c25d4d14a999d61900af42dd09d_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_a415e5a75c24452bbcd60ac1b3811fc6_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_ab217b8df9084424b472a49bafb4515d_Out_2_Float.xx), _TilingAndOffset_0b468c25d4d14a999d61900af42dd09d_Out_3_Vector2);
            float _Property_4cdc099c195e4d6a8f9f35604045d0b7_Out_0_Float = _Noise_Scale;
            float _GradientNoise_26bc13aecb1b4c2081638300cc42b01d_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_0b468c25d4d14a999d61900af42dd09d_Out_3_Vector2, _Property_4cdc099c195e4d6a8f9f35604045d0b7_Out_0_Float, _GradientNoise_26bc13aecb1b4c2081638300cc42b01d_Out_2_Float);
            float2 _TilingAndOffset_88de901db4e14268b84877dc201207b6_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_a415e5a75c24452bbcd60ac1b3811fc6_Out_3_Vector3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_88de901db4e14268b84877dc201207b6_Out_3_Vector2);
            float _GradientNoise_aa58bf81bf93430985a301e296a23ad8_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_88de901db4e14268b84877dc201207b6_Out_3_Vector2, _Property_4cdc099c195e4d6a8f9f35604045d0b7_Out_0_Float, _GradientNoise_aa58bf81bf93430985a301e296a23ad8_Out_2_Float);
            float _Add_7767c92e2dbe4c9e8ec3922a6c504040_Out_2_Float;
            Unity_Add_float(_GradientNoise_26bc13aecb1b4c2081638300cc42b01d_Out_2_Float, _GradientNoise_aa58bf81bf93430985a301e296a23ad8_Out_2_Float, _Add_7767c92e2dbe4c9e8ec3922a6c504040_Out_2_Float);
            float _Divide_01c8ce94962043679abea203c1772a79_Out_2_Float;
            Unity_Divide_float(_Add_7767c92e2dbe4c9e8ec3922a6c504040_Out_2_Float, float(2), _Divide_01c8ce94962043679abea203c1772a79_Out_2_Float);
            float _Saturate_bf00c156675b44cd9168e9493fa1fa61_Out_1_Float;
            Unity_Saturate_float(_Divide_01c8ce94962043679abea203c1772a79_Out_2_Float, _Saturate_bf00c156675b44cd9168e9493fa1fa61_Out_1_Float);
            float _Property_b932cc0b0679463495ea24f5ae20fe0a_Out_0_Float = _Noise_Power;
            float _Power_bc99b52173a44811b5a653f85b30e92b_Out_2_Float;
            Unity_Power_float(_Saturate_bf00c156675b44cd9168e9493fa1fa61_Out_1_Float, _Property_b932cc0b0679463495ea24f5ae20fe0a_Out_0_Float, _Power_bc99b52173a44811b5a653f85b30e92b_Out_2_Float);
            float4 _Property_e85e1549c7ea4dc8be0b5d3469565ffd_Out_0_Vector4 = _Noise_Remap;
            float _Split_10eb25ab4f03492b8209300701e5f945_R_1_Float = _Property_e85e1549c7ea4dc8be0b5d3469565ffd_Out_0_Vector4[0];
            float _Split_10eb25ab4f03492b8209300701e5f945_G_2_Float = _Property_e85e1549c7ea4dc8be0b5d3469565ffd_Out_0_Vector4[1];
            float _Split_10eb25ab4f03492b8209300701e5f945_B_3_Float = _Property_e85e1549c7ea4dc8be0b5d3469565ffd_Out_0_Vector4[2];
            float _Split_10eb25ab4f03492b8209300701e5f945_A_4_Float = _Property_e85e1549c7ea4dc8be0b5d3469565ffd_Out_0_Vector4[3];
            float4 _Combine_edb179662e1a4052b97e671dbd3421a5_RGBA_4_Vector4;
            float3 _Combine_edb179662e1a4052b97e671dbd3421a5_RGB_5_Vector3;
            float2 _Combine_edb179662e1a4052b97e671dbd3421a5_RG_6_Vector2;
            Unity_Combine_float(_Split_10eb25ab4f03492b8209300701e5f945_R_1_Float, _Split_10eb25ab4f03492b8209300701e5f945_G_2_Float, float(0), float(0), _Combine_edb179662e1a4052b97e671dbd3421a5_RGBA_4_Vector4, _Combine_edb179662e1a4052b97e671dbd3421a5_RGB_5_Vector3, _Combine_edb179662e1a4052b97e671dbd3421a5_RG_6_Vector2);
            float4 _Combine_f12ac3a1b10f4f388dab86453258dcb0_RGBA_4_Vector4;
            float3 _Combine_f12ac3a1b10f4f388dab86453258dcb0_RGB_5_Vector3;
            float2 _Combine_f12ac3a1b10f4f388dab86453258dcb0_RG_6_Vector2;
            Unity_Combine_float(_Split_10eb25ab4f03492b8209300701e5f945_B_3_Float, _Split_10eb25ab4f03492b8209300701e5f945_A_4_Float, float(0), float(0), _Combine_f12ac3a1b10f4f388dab86453258dcb0_RGBA_4_Vector4, _Combine_f12ac3a1b10f4f388dab86453258dcb0_RGB_5_Vector3, _Combine_f12ac3a1b10f4f388dab86453258dcb0_RG_6_Vector2);
            float _Remap_b473bb8bd2254a3faad5291ff8cb7707_Out_3_Float;
            Unity_Remap_float(_Power_bc99b52173a44811b5a653f85b30e92b_Out_2_Float, _Combine_edb179662e1a4052b97e671dbd3421a5_RG_6_Vector2, _Combine_f12ac3a1b10f4f388dab86453258dcb0_RG_6_Vector2, _Remap_b473bb8bd2254a3faad5291ff8cb7707_Out_3_Float);
            float _Absolute_2367964a3dae475891ccd6c90e2885ff_Out_1_Float;
            Unity_Absolute_float(_Remap_b473bb8bd2254a3faad5291ff8cb7707_Out_3_Float, _Absolute_2367964a3dae475891ccd6c90e2885ff_Out_1_Float);
            float _Smoothstep_516feede7acb4f97b595cd89bba389c4_Out_3_Float;
            Unity_Smoothstep_float(_Property_f05727b79c2d491a8b9c2d8417d4ce68_Out_0_Float, _Property_7d43401174f8413091e457476f00d1aa_Out_0_Float, _Absolute_2367964a3dae475891ccd6c90e2885ff_Out_1_Float, _Smoothstep_516feede7acb4f97b595cd89bba389c4_Out_3_Float);
            float _Property_44e53f25d86f4edbaab4f19b6daaa067_Out_0_Float = _Base_Speed;
            float _Multiply_619aff87dcc446c5968bd1a6d44fe8b7_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_44e53f25d86f4edbaab4f19b6daaa067_Out_0_Float, _Multiply_619aff87dcc446c5968bd1a6d44fe8b7_Out_2_Float);
            float2 _TilingAndOffset_7cbf9da6c23b409fb98e46b72acb3373_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_a415e5a75c24452bbcd60ac1b3811fc6_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_619aff87dcc446c5968bd1a6d44fe8b7_Out_2_Float.xx), _TilingAndOffset_7cbf9da6c23b409fb98e46b72acb3373_Out_3_Vector2);
            float _Property_9254f8e15d6447988ec18cd37fe88bdc_Out_0_Float = _Base_Scale;
            float _GradientNoise_ce38dcc651b44efeb82145bfdadbf1fa_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_7cbf9da6c23b409fb98e46b72acb3373_Out_3_Vector2, _Property_9254f8e15d6447988ec18cd37fe88bdc_Out_0_Float, _GradientNoise_ce38dcc651b44efeb82145bfdadbf1fa_Out_2_Float);
            float _Property_56d73ff99ec94119881f3d643422251a_Out_0_Float = _Base_Strength;
            float _Multiply_a28097e44d4c485a867948d5b27a71aa_Out_2_Float;
            Unity_Multiply_float_float(_GradientNoise_ce38dcc651b44efeb82145bfdadbf1fa_Out_2_Float, _Property_56d73ff99ec94119881f3d643422251a_Out_0_Float, _Multiply_a28097e44d4c485a867948d5b27a71aa_Out_2_Float);
            float _Add_c6fbda241fda4ff68e2e16893549192e_Out_2_Float;
            Unity_Add_float(_Smoothstep_516feede7acb4f97b595cd89bba389c4_Out_3_Float, _Multiply_a28097e44d4c485a867948d5b27a71aa_Out_2_Float, _Add_c6fbda241fda4ff68e2e16893549192e_Out_2_Float);
            float _Add_5d9343a646914b1582c5ac00b2068a54_Out_2_Float;
            Unity_Add_float(float(0), _Property_56d73ff99ec94119881f3d643422251a_Out_0_Float, _Add_5d9343a646914b1582c5ac00b2068a54_Out_2_Float);
            float _Divide_fe411acd94ed4c4c83892bba30255329_Out_2_Float;
            Unity_Divide_float(_Add_c6fbda241fda4ff68e2e16893549192e_Out_2_Float, _Add_5d9343a646914b1582c5ac00b2068a54_Out_2_Float, _Divide_fe411acd94ed4c4c83892bba30255329_Out_2_Float);
            float4 _Lerp_aaaae5c0660549cda8a2edb7a84e8dbb_Out_3_Vector4;
            Unity_Lerp_float4(_Property_08f55cc2215f457abdf288e58daaa696_Out_0_Vector4, _Property_acbafd3dca104c65b7b71611d4639044_Out_0_Vector4, (_Divide_fe411acd94ed4c4c83892bba30255329_Out_2_Float.xxxx), _Lerp_aaaae5c0660549cda8a2edb7a84e8dbb_Out_3_Vector4);
            float _Property_f89c537fda1b403396d59ec61a8b35e5_Out_0_Float = _Fresnel_Effect_Power;
            float _FresnelEffect_f9c84f0b8ff24646bb5cc9ba3035a272_Out_3_Float;
            Unity_FresnelEffect_float(IN.WorldSpaceNormal, IN.WorldSpaceViewDirection, _Property_f89c537fda1b403396d59ec61a8b35e5_Out_0_Float, _FresnelEffect_f9c84f0b8ff24646bb5cc9ba3035a272_Out_3_Float);
            float _Multiply_1bbed182421f4aa8b0945b4daa798b00_Out_2_Float;
            Unity_Multiply_float_float(_Divide_fe411acd94ed4c4c83892bba30255329_Out_2_Float, _FresnelEffect_f9c84f0b8ff24646bb5cc9ba3035a272_Out_3_Float, _Multiply_1bbed182421f4aa8b0945b4daa798b00_Out_2_Float);
            float _Property_303037adb92e43f8a9f46c95f99d6c48_Out_0_Float = _Fresnel_Effect_Opacity;
            float _Multiply_f635d3e8fd1d4391a3dac582c550363f_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_1bbed182421f4aa8b0945b4daa798b00_Out_2_Float, _Property_303037adb92e43f8a9f46c95f99d6c48_Out_0_Float, _Multiply_f635d3e8fd1d4391a3dac582c550363f_Out_2_Float);
            float4 _Add_d7735e7c08de490697e89ff0870bf268_Out_2_Vector4;
            Unity_Add_float4(_Lerp_aaaae5c0660549cda8a2edb7a84e8dbb_Out_3_Vector4, (_Multiply_f635d3e8fd1d4391a3dac582c550363f_Out_2_Float.xxxx), _Add_d7735e7c08de490697e89ff0870bf268_Out_2_Vector4);
            float _Property_9710070004144fc9be45a2565e9ea4ed_Out_0_Float = _Emission_Strength;
            float4 _Multiply_0b1503eba4ae4a5a9ebe8075c9437c3b_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Add_d7735e7c08de490697e89ff0870bf268_Out_2_Vector4, (_Property_9710070004144fc9be45a2565e9ea4ed_Out_0_Float.xxxx), _Multiply_0b1503eba4ae4a5a9ebe8075c9437c3b_Out_2_Vector4);
            float _SceneDepth_7a3cc358e0f44107b8bce7383895b953_Out_1_Float;
            Unity_SceneDepth_Eye_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_7a3cc358e0f44107b8bce7383895b953_Out_1_Float);
            float4 _ScreenPosition_344727010a4a40389b6dd34b4b9b2ac3_Out_0_Vector4 = IN.ScreenPosition;
            float _Split_acb0902b83d148e2a31506c594db0146_R_1_Float = _ScreenPosition_344727010a4a40389b6dd34b4b9b2ac3_Out_0_Vector4[0];
            float _Split_acb0902b83d148e2a31506c594db0146_G_2_Float = _ScreenPosition_344727010a4a40389b6dd34b4b9b2ac3_Out_0_Vector4[1];
            float _Split_acb0902b83d148e2a31506c594db0146_B_3_Float = _ScreenPosition_344727010a4a40389b6dd34b4b9b2ac3_Out_0_Vector4[2];
            float _Split_acb0902b83d148e2a31506c594db0146_A_4_Float = _ScreenPosition_344727010a4a40389b6dd34b4b9b2ac3_Out_0_Vector4[3];
            float _Subtract_3db7c3ced20d44b3a55e93b8d56c3fc1_Out_2_Float;
            Unity_Subtract_float(_Split_acb0902b83d148e2a31506c594db0146_A_4_Float, float(1), _Subtract_3db7c3ced20d44b3a55e93b8d56c3fc1_Out_2_Float);
            float _Subtract_0b683ae745b74caaa4830cb31795132a_Out_2_Float;
            Unity_Subtract_float(_SceneDepth_7a3cc358e0f44107b8bce7383895b953_Out_1_Float, _Subtract_3db7c3ced20d44b3a55e93b8d56c3fc1_Out_2_Float, _Subtract_0b683ae745b74caaa4830cb31795132a_Out_2_Float);
            float _Property_13ffae534f05496e8446dd4eff4d54b3_Out_0_Float = _Fade_Depth;
            float _Divide_5ea1c32f7a9541ce96555bb9c53dad4e_Out_2_Float;
            Unity_Divide_float(_Subtract_0b683ae745b74caaa4830cb31795132a_Out_2_Float, _Property_13ffae534f05496e8446dd4eff4d54b3_Out_0_Float, _Divide_5ea1c32f7a9541ce96555bb9c53dad4e_Out_2_Float);
            float _Saturate_11cb953c9f3a4ad98649c8032095e0a5_Out_1_Float;
            Unity_Saturate_float(_Divide_5ea1c32f7a9541ce96555bb9c53dad4e_Out_2_Float, _Saturate_11cb953c9f3a4ad98649c8032095e0a5_Out_1_Float);
            float _Smoothstep_804d457501334adcb743390e55365a80_Out_3_Float;
            Unity_Smoothstep_float(float(0), float(1), _Saturate_11cb953c9f3a4ad98649c8032095e0a5_Out_1_Float, _Smoothstep_804d457501334adcb743390e55365a80_Out_3_Float);
            surface.BaseColor = (_Lerp_aaaae5c0660549cda8a2edb7a84e8dbb_Out_3_Vector4.xyz);
            surface.Emission = (_Multiply_0b1503eba4ae4a5a9ebe8075c9437c3b_Out_2_Vector4.xyz);
            surface.Alpha = _Smoothstep_804d457501334adcb743390e55365a80_Out_3_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.WorldSpaceNormal =                           TransformObjectToWorldNormal(input.normalOS);
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.WorldSpacePosition =                         TransformObjectToWorld(input.positionOS);
            output.TimeParameters =                             _TimeParameters.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
            // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
            float3 unnormalizedNormalWS = input.normalWS;
            const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        
        
            output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
        
        
            output.WorldSpaceViewDirection = GetWorldSpaceNormalizeViewDir(input.positionWS);
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/LightingMetaPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "SceneSelectionPass"
            Tags
            {
                "LightMode" = "SceneSelectionPass"
            }
        
        // Render State
        Cull Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_POSITION_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENESELECTIONPASS 1
        #define ALPHA_CLIP_THRESHOLD 1
        #define REQUIRE_DEPTH_TEXTURE
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 WorldSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float3 WorldSpacePosition;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS : INTERP0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.positionWS.xyz = input.positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.positionWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _Rotate_Projection;
        float _Noise_Scale;
        float _Noise_Speed;
        float _Noise_Height;
        float4 _Noise_Remap;
        float4 _Color_A;
        float4 _Color_B;
        float _Smooth_Step_1;
        float _Smooth_Step_2;
        float _Noise_Power;
        float _Base_Scale;
        float _Base_Speed;
        float _Base_Strength;
        float _Emission_Strength;
        float _Curvature_Radius;
        float _Fresnel_Effect_Power;
        float _Fresnel_Effect_Opacity;
        float _Fade_Depth;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Distance_float3(float3 A, float3 B, out float Out)
        {
            Out = distance(A, B);
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
        {
            Rotation = radians(Rotation);
            float s, c;
            sincos(Rotation, s, c);
            Axis = normalize(Axis);
            Out = In * c + cross(Axis, In) * s + Axis * dot(Axis, In) * (1 - c);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
        {
            float x; Hash_Tchou_2_1_float(p, x);
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
        {
            float2 p = UV * Scale.xy;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            if (unity_OrthoParams.w == 1.0)
            {
                Out = LinearEyeDepth(ComputeWorldSpacePosition(UV.xy, SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), UNITY_MATRIX_I_VP), UNITY_MATRIX_V);
            }
            else
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Distance_2db07498d99c49328512eaf4405dfb7d_Out_2_Float;
            Unity_Distance_float3(SHADERGRAPH_OBJECT_POSITION, IN.WorldSpacePosition, _Distance_2db07498d99c49328512eaf4405dfb7d_Out_2_Float);
            float _Property_781afe0d084b4e86ba202ae12d2df5c3_Out_0_Float = _Curvature_Radius;
            float _Divide_3a2887a0281d4fb9a0b32e1c0fa89d00_Out_2_Float;
            Unity_Divide_float(_Distance_2db07498d99c49328512eaf4405dfb7d_Out_2_Float, _Property_781afe0d084b4e86ba202ae12d2df5c3_Out_0_Float, _Divide_3a2887a0281d4fb9a0b32e1c0fa89d00_Out_2_Float);
            float _Power_dae4028a0ef04cc885209d872784f592_Out_2_Float;
            Unity_Power_float(_Divide_3a2887a0281d4fb9a0b32e1c0fa89d00_Out_2_Float, float(3), _Power_dae4028a0ef04cc885209d872784f592_Out_2_Float);
            float3 _Multiply_ff35d2ab09754f1c8b2fac2015de70db_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.WorldSpaceNormal, (_Power_dae4028a0ef04cc885209d872784f592_Out_2_Float.xxx), _Multiply_ff35d2ab09754f1c8b2fac2015de70db_Out_2_Vector3);
            float _Property_f05727b79c2d491a8b9c2d8417d4ce68_Out_0_Float = _Smooth_Step_1;
            float _Property_7d43401174f8413091e457476f00d1aa_Out_0_Float = _Smooth_Step_2;
            float4 _Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4 = _Rotate_Projection;
            float _Split_610d0b28a0e94e38b42626a03d9f9794_R_1_Float = _Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4[0];
            float _Split_610d0b28a0e94e38b42626a03d9f9794_G_2_Float = _Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4[1];
            float _Split_610d0b28a0e94e38b42626a03d9f9794_B_3_Float = _Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4[2];
            float _Split_610d0b28a0e94e38b42626a03d9f9794_A_4_Float = _Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4[3];
            float3 _RotateAboutAxis_a415e5a75c24452bbcd60ac1b3811fc6_Out_3_Vector3;
            Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4.xyz), _Split_610d0b28a0e94e38b42626a03d9f9794_A_4_Float, _RotateAboutAxis_a415e5a75c24452bbcd60ac1b3811fc6_Out_3_Vector3);
            float _Property_2ada180c9afb42be8c587ae354b92988_Out_0_Float = _Noise_Speed;
            float _Multiply_ab217b8df9084424b472a49bafb4515d_Out_2_Float;
            Unity_Multiply_float_float(_Property_2ada180c9afb42be8c587ae354b92988_Out_0_Float, IN.TimeParameters.x, _Multiply_ab217b8df9084424b472a49bafb4515d_Out_2_Float);
            float2 _TilingAndOffset_0b468c25d4d14a999d61900af42dd09d_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_a415e5a75c24452bbcd60ac1b3811fc6_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_ab217b8df9084424b472a49bafb4515d_Out_2_Float.xx), _TilingAndOffset_0b468c25d4d14a999d61900af42dd09d_Out_3_Vector2);
            float _Property_4cdc099c195e4d6a8f9f35604045d0b7_Out_0_Float = _Noise_Scale;
            float _GradientNoise_26bc13aecb1b4c2081638300cc42b01d_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_0b468c25d4d14a999d61900af42dd09d_Out_3_Vector2, _Property_4cdc099c195e4d6a8f9f35604045d0b7_Out_0_Float, _GradientNoise_26bc13aecb1b4c2081638300cc42b01d_Out_2_Float);
            float2 _TilingAndOffset_88de901db4e14268b84877dc201207b6_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_a415e5a75c24452bbcd60ac1b3811fc6_Out_3_Vector3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_88de901db4e14268b84877dc201207b6_Out_3_Vector2);
            float _GradientNoise_aa58bf81bf93430985a301e296a23ad8_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_88de901db4e14268b84877dc201207b6_Out_3_Vector2, _Property_4cdc099c195e4d6a8f9f35604045d0b7_Out_0_Float, _GradientNoise_aa58bf81bf93430985a301e296a23ad8_Out_2_Float);
            float _Add_7767c92e2dbe4c9e8ec3922a6c504040_Out_2_Float;
            Unity_Add_float(_GradientNoise_26bc13aecb1b4c2081638300cc42b01d_Out_2_Float, _GradientNoise_aa58bf81bf93430985a301e296a23ad8_Out_2_Float, _Add_7767c92e2dbe4c9e8ec3922a6c504040_Out_2_Float);
            float _Divide_01c8ce94962043679abea203c1772a79_Out_2_Float;
            Unity_Divide_float(_Add_7767c92e2dbe4c9e8ec3922a6c504040_Out_2_Float, float(2), _Divide_01c8ce94962043679abea203c1772a79_Out_2_Float);
            float _Saturate_bf00c156675b44cd9168e9493fa1fa61_Out_1_Float;
            Unity_Saturate_float(_Divide_01c8ce94962043679abea203c1772a79_Out_2_Float, _Saturate_bf00c156675b44cd9168e9493fa1fa61_Out_1_Float);
            float _Property_b932cc0b0679463495ea24f5ae20fe0a_Out_0_Float = _Noise_Power;
            float _Power_bc99b52173a44811b5a653f85b30e92b_Out_2_Float;
            Unity_Power_float(_Saturate_bf00c156675b44cd9168e9493fa1fa61_Out_1_Float, _Property_b932cc0b0679463495ea24f5ae20fe0a_Out_0_Float, _Power_bc99b52173a44811b5a653f85b30e92b_Out_2_Float);
            float4 _Property_e85e1549c7ea4dc8be0b5d3469565ffd_Out_0_Vector4 = _Noise_Remap;
            float _Split_10eb25ab4f03492b8209300701e5f945_R_1_Float = _Property_e85e1549c7ea4dc8be0b5d3469565ffd_Out_0_Vector4[0];
            float _Split_10eb25ab4f03492b8209300701e5f945_G_2_Float = _Property_e85e1549c7ea4dc8be0b5d3469565ffd_Out_0_Vector4[1];
            float _Split_10eb25ab4f03492b8209300701e5f945_B_3_Float = _Property_e85e1549c7ea4dc8be0b5d3469565ffd_Out_0_Vector4[2];
            float _Split_10eb25ab4f03492b8209300701e5f945_A_4_Float = _Property_e85e1549c7ea4dc8be0b5d3469565ffd_Out_0_Vector4[3];
            float4 _Combine_edb179662e1a4052b97e671dbd3421a5_RGBA_4_Vector4;
            float3 _Combine_edb179662e1a4052b97e671dbd3421a5_RGB_5_Vector3;
            float2 _Combine_edb179662e1a4052b97e671dbd3421a5_RG_6_Vector2;
            Unity_Combine_float(_Split_10eb25ab4f03492b8209300701e5f945_R_1_Float, _Split_10eb25ab4f03492b8209300701e5f945_G_2_Float, float(0), float(0), _Combine_edb179662e1a4052b97e671dbd3421a5_RGBA_4_Vector4, _Combine_edb179662e1a4052b97e671dbd3421a5_RGB_5_Vector3, _Combine_edb179662e1a4052b97e671dbd3421a5_RG_6_Vector2);
            float4 _Combine_f12ac3a1b10f4f388dab86453258dcb0_RGBA_4_Vector4;
            float3 _Combine_f12ac3a1b10f4f388dab86453258dcb0_RGB_5_Vector3;
            float2 _Combine_f12ac3a1b10f4f388dab86453258dcb0_RG_6_Vector2;
            Unity_Combine_float(_Split_10eb25ab4f03492b8209300701e5f945_B_3_Float, _Split_10eb25ab4f03492b8209300701e5f945_A_4_Float, float(0), float(0), _Combine_f12ac3a1b10f4f388dab86453258dcb0_RGBA_4_Vector4, _Combine_f12ac3a1b10f4f388dab86453258dcb0_RGB_5_Vector3, _Combine_f12ac3a1b10f4f388dab86453258dcb0_RG_6_Vector2);
            float _Remap_b473bb8bd2254a3faad5291ff8cb7707_Out_3_Float;
            Unity_Remap_float(_Power_bc99b52173a44811b5a653f85b30e92b_Out_2_Float, _Combine_edb179662e1a4052b97e671dbd3421a5_RG_6_Vector2, _Combine_f12ac3a1b10f4f388dab86453258dcb0_RG_6_Vector2, _Remap_b473bb8bd2254a3faad5291ff8cb7707_Out_3_Float);
            float _Absolute_2367964a3dae475891ccd6c90e2885ff_Out_1_Float;
            Unity_Absolute_float(_Remap_b473bb8bd2254a3faad5291ff8cb7707_Out_3_Float, _Absolute_2367964a3dae475891ccd6c90e2885ff_Out_1_Float);
            float _Smoothstep_516feede7acb4f97b595cd89bba389c4_Out_3_Float;
            Unity_Smoothstep_float(_Property_f05727b79c2d491a8b9c2d8417d4ce68_Out_0_Float, _Property_7d43401174f8413091e457476f00d1aa_Out_0_Float, _Absolute_2367964a3dae475891ccd6c90e2885ff_Out_1_Float, _Smoothstep_516feede7acb4f97b595cd89bba389c4_Out_3_Float);
            float _Property_44e53f25d86f4edbaab4f19b6daaa067_Out_0_Float = _Base_Speed;
            float _Multiply_619aff87dcc446c5968bd1a6d44fe8b7_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_44e53f25d86f4edbaab4f19b6daaa067_Out_0_Float, _Multiply_619aff87dcc446c5968bd1a6d44fe8b7_Out_2_Float);
            float2 _TilingAndOffset_7cbf9da6c23b409fb98e46b72acb3373_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_a415e5a75c24452bbcd60ac1b3811fc6_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_619aff87dcc446c5968bd1a6d44fe8b7_Out_2_Float.xx), _TilingAndOffset_7cbf9da6c23b409fb98e46b72acb3373_Out_3_Vector2);
            float _Property_9254f8e15d6447988ec18cd37fe88bdc_Out_0_Float = _Base_Scale;
            float _GradientNoise_ce38dcc651b44efeb82145bfdadbf1fa_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_7cbf9da6c23b409fb98e46b72acb3373_Out_3_Vector2, _Property_9254f8e15d6447988ec18cd37fe88bdc_Out_0_Float, _GradientNoise_ce38dcc651b44efeb82145bfdadbf1fa_Out_2_Float);
            float _Property_56d73ff99ec94119881f3d643422251a_Out_0_Float = _Base_Strength;
            float _Multiply_a28097e44d4c485a867948d5b27a71aa_Out_2_Float;
            Unity_Multiply_float_float(_GradientNoise_ce38dcc651b44efeb82145bfdadbf1fa_Out_2_Float, _Property_56d73ff99ec94119881f3d643422251a_Out_0_Float, _Multiply_a28097e44d4c485a867948d5b27a71aa_Out_2_Float);
            float _Add_c6fbda241fda4ff68e2e16893549192e_Out_2_Float;
            Unity_Add_float(_Smoothstep_516feede7acb4f97b595cd89bba389c4_Out_3_Float, _Multiply_a28097e44d4c485a867948d5b27a71aa_Out_2_Float, _Add_c6fbda241fda4ff68e2e16893549192e_Out_2_Float);
            float _Add_5d9343a646914b1582c5ac00b2068a54_Out_2_Float;
            Unity_Add_float(float(0), _Property_56d73ff99ec94119881f3d643422251a_Out_0_Float, _Add_5d9343a646914b1582c5ac00b2068a54_Out_2_Float);
            float _Divide_fe411acd94ed4c4c83892bba30255329_Out_2_Float;
            Unity_Divide_float(_Add_c6fbda241fda4ff68e2e16893549192e_Out_2_Float, _Add_5d9343a646914b1582c5ac00b2068a54_Out_2_Float, _Divide_fe411acd94ed4c4c83892bba30255329_Out_2_Float);
            float3 _Multiply_b525aac067b04a9a8f9ce1a4c4716765_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.ObjectSpaceNormal, (_Divide_fe411acd94ed4c4c83892bba30255329_Out_2_Float.xxx), _Multiply_b525aac067b04a9a8f9ce1a4c4716765_Out_2_Vector3);
            float _Property_81343da7ab424f29a124d673b8099601_Out_0_Float = _Noise_Height;
            float3 _Multiply_431791af81b04fe4920287cee8e84b36_Out_2_Vector3;
            Unity_Multiply_float3_float3(_Multiply_b525aac067b04a9a8f9ce1a4c4716765_Out_2_Vector3, (_Property_81343da7ab424f29a124d673b8099601_Out_0_Float.xxx), _Multiply_431791af81b04fe4920287cee8e84b36_Out_2_Vector3);
            float3 _Add_e716c01d530b428c8bcb16ba04bed031_Out_2_Vector3;
            Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_431791af81b04fe4920287cee8e84b36_Out_2_Vector3, _Add_e716c01d530b428c8bcb16ba04bed031_Out_2_Vector3);
            float3 _Add_fc53f37eba984ae88bea18cd54a386d0_Out_2_Vector3;
            Unity_Add_float3(_Multiply_ff35d2ab09754f1c8b2fac2015de70db_Out_2_Vector3, _Add_e716c01d530b428c8bcb16ba04bed031_Out_2_Vector3, _Add_fc53f37eba984ae88bea18cd54a386d0_Out_2_Vector3);
            description.Position = _Add_fc53f37eba984ae88bea18cd54a386d0_Out_2_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _SceneDepth_7a3cc358e0f44107b8bce7383895b953_Out_1_Float;
            Unity_SceneDepth_Eye_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_7a3cc358e0f44107b8bce7383895b953_Out_1_Float);
            float4 _ScreenPosition_344727010a4a40389b6dd34b4b9b2ac3_Out_0_Vector4 = IN.ScreenPosition;
            float _Split_acb0902b83d148e2a31506c594db0146_R_1_Float = _ScreenPosition_344727010a4a40389b6dd34b4b9b2ac3_Out_0_Vector4[0];
            float _Split_acb0902b83d148e2a31506c594db0146_G_2_Float = _ScreenPosition_344727010a4a40389b6dd34b4b9b2ac3_Out_0_Vector4[1];
            float _Split_acb0902b83d148e2a31506c594db0146_B_3_Float = _ScreenPosition_344727010a4a40389b6dd34b4b9b2ac3_Out_0_Vector4[2];
            float _Split_acb0902b83d148e2a31506c594db0146_A_4_Float = _ScreenPosition_344727010a4a40389b6dd34b4b9b2ac3_Out_0_Vector4[3];
            float _Subtract_3db7c3ced20d44b3a55e93b8d56c3fc1_Out_2_Float;
            Unity_Subtract_float(_Split_acb0902b83d148e2a31506c594db0146_A_4_Float, float(1), _Subtract_3db7c3ced20d44b3a55e93b8d56c3fc1_Out_2_Float);
            float _Subtract_0b683ae745b74caaa4830cb31795132a_Out_2_Float;
            Unity_Subtract_float(_SceneDepth_7a3cc358e0f44107b8bce7383895b953_Out_1_Float, _Subtract_3db7c3ced20d44b3a55e93b8d56c3fc1_Out_2_Float, _Subtract_0b683ae745b74caaa4830cb31795132a_Out_2_Float);
            float _Property_13ffae534f05496e8446dd4eff4d54b3_Out_0_Float = _Fade_Depth;
            float _Divide_5ea1c32f7a9541ce96555bb9c53dad4e_Out_2_Float;
            Unity_Divide_float(_Subtract_0b683ae745b74caaa4830cb31795132a_Out_2_Float, _Property_13ffae534f05496e8446dd4eff4d54b3_Out_0_Float, _Divide_5ea1c32f7a9541ce96555bb9c53dad4e_Out_2_Float);
            float _Saturate_11cb953c9f3a4ad98649c8032095e0a5_Out_1_Float;
            Unity_Saturate_float(_Divide_5ea1c32f7a9541ce96555bb9c53dad4e_Out_2_Float, _Saturate_11cb953c9f3a4ad98649c8032095e0a5_Out_1_Float);
            float _Smoothstep_804d457501334adcb743390e55365a80_Out_3_Float;
            Unity_Smoothstep_float(float(0), float(1), _Saturate_11cb953c9f3a4ad98649c8032095e0a5_Out_1_Float, _Smoothstep_804d457501334adcb743390e55365a80_Out_3_Float);
            surface.Alpha = _Smoothstep_804d457501334adcb743390e55365a80_Out_3_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.WorldSpaceNormal =                           TransformObjectToWorldNormal(input.normalOS);
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.WorldSpacePosition =                         TransformObjectToWorld(input.positionOS);
            output.TimeParameters =                             _TimeParameters.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "ScenePickingPass"
            Tags
            {
                "LightMode" = "Picking"
            }
        
        // Render State
        Cull Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_POSITION_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENEPICKINGPASS 1
        #define ALPHA_CLIP_THRESHOLD 1
        #define REQUIRE_DEPTH_TEXTURE
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 WorldSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float3 WorldSpacePosition;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS : INTERP0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.positionWS.xyz = input.positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.positionWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _Rotate_Projection;
        float _Noise_Scale;
        float _Noise_Speed;
        float _Noise_Height;
        float4 _Noise_Remap;
        float4 _Color_A;
        float4 _Color_B;
        float _Smooth_Step_1;
        float _Smooth_Step_2;
        float _Noise_Power;
        float _Base_Scale;
        float _Base_Speed;
        float _Base_Strength;
        float _Emission_Strength;
        float _Curvature_Radius;
        float _Fresnel_Effect_Power;
        float _Fresnel_Effect_Opacity;
        float _Fade_Depth;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Distance_float3(float3 A, float3 B, out float Out)
        {
            Out = distance(A, B);
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
        {
            Rotation = radians(Rotation);
            float s, c;
            sincos(Rotation, s, c);
            Axis = normalize(Axis);
            Out = In * c + cross(Axis, In) * s + Axis * dot(Axis, In) * (1 - c);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
        {
            float x; Hash_Tchou_2_1_float(p, x);
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
        {
            float2 p = UV * Scale.xy;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            if (unity_OrthoParams.w == 1.0)
            {
                Out = LinearEyeDepth(ComputeWorldSpacePosition(UV.xy, SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), UNITY_MATRIX_I_VP), UNITY_MATRIX_V);
            }
            else
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Distance_2db07498d99c49328512eaf4405dfb7d_Out_2_Float;
            Unity_Distance_float3(SHADERGRAPH_OBJECT_POSITION, IN.WorldSpacePosition, _Distance_2db07498d99c49328512eaf4405dfb7d_Out_2_Float);
            float _Property_781afe0d084b4e86ba202ae12d2df5c3_Out_0_Float = _Curvature_Radius;
            float _Divide_3a2887a0281d4fb9a0b32e1c0fa89d00_Out_2_Float;
            Unity_Divide_float(_Distance_2db07498d99c49328512eaf4405dfb7d_Out_2_Float, _Property_781afe0d084b4e86ba202ae12d2df5c3_Out_0_Float, _Divide_3a2887a0281d4fb9a0b32e1c0fa89d00_Out_2_Float);
            float _Power_dae4028a0ef04cc885209d872784f592_Out_2_Float;
            Unity_Power_float(_Divide_3a2887a0281d4fb9a0b32e1c0fa89d00_Out_2_Float, float(3), _Power_dae4028a0ef04cc885209d872784f592_Out_2_Float);
            float3 _Multiply_ff35d2ab09754f1c8b2fac2015de70db_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.WorldSpaceNormal, (_Power_dae4028a0ef04cc885209d872784f592_Out_2_Float.xxx), _Multiply_ff35d2ab09754f1c8b2fac2015de70db_Out_2_Vector3);
            float _Property_f05727b79c2d491a8b9c2d8417d4ce68_Out_0_Float = _Smooth_Step_1;
            float _Property_7d43401174f8413091e457476f00d1aa_Out_0_Float = _Smooth_Step_2;
            float4 _Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4 = _Rotate_Projection;
            float _Split_610d0b28a0e94e38b42626a03d9f9794_R_1_Float = _Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4[0];
            float _Split_610d0b28a0e94e38b42626a03d9f9794_G_2_Float = _Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4[1];
            float _Split_610d0b28a0e94e38b42626a03d9f9794_B_3_Float = _Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4[2];
            float _Split_610d0b28a0e94e38b42626a03d9f9794_A_4_Float = _Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4[3];
            float3 _RotateAboutAxis_a415e5a75c24452bbcd60ac1b3811fc6_Out_3_Vector3;
            Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4.xyz), _Split_610d0b28a0e94e38b42626a03d9f9794_A_4_Float, _RotateAboutAxis_a415e5a75c24452bbcd60ac1b3811fc6_Out_3_Vector3);
            float _Property_2ada180c9afb42be8c587ae354b92988_Out_0_Float = _Noise_Speed;
            float _Multiply_ab217b8df9084424b472a49bafb4515d_Out_2_Float;
            Unity_Multiply_float_float(_Property_2ada180c9afb42be8c587ae354b92988_Out_0_Float, IN.TimeParameters.x, _Multiply_ab217b8df9084424b472a49bafb4515d_Out_2_Float);
            float2 _TilingAndOffset_0b468c25d4d14a999d61900af42dd09d_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_a415e5a75c24452bbcd60ac1b3811fc6_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_ab217b8df9084424b472a49bafb4515d_Out_2_Float.xx), _TilingAndOffset_0b468c25d4d14a999d61900af42dd09d_Out_3_Vector2);
            float _Property_4cdc099c195e4d6a8f9f35604045d0b7_Out_0_Float = _Noise_Scale;
            float _GradientNoise_26bc13aecb1b4c2081638300cc42b01d_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_0b468c25d4d14a999d61900af42dd09d_Out_3_Vector2, _Property_4cdc099c195e4d6a8f9f35604045d0b7_Out_0_Float, _GradientNoise_26bc13aecb1b4c2081638300cc42b01d_Out_2_Float);
            float2 _TilingAndOffset_88de901db4e14268b84877dc201207b6_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_a415e5a75c24452bbcd60ac1b3811fc6_Out_3_Vector3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_88de901db4e14268b84877dc201207b6_Out_3_Vector2);
            float _GradientNoise_aa58bf81bf93430985a301e296a23ad8_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_88de901db4e14268b84877dc201207b6_Out_3_Vector2, _Property_4cdc099c195e4d6a8f9f35604045d0b7_Out_0_Float, _GradientNoise_aa58bf81bf93430985a301e296a23ad8_Out_2_Float);
            float _Add_7767c92e2dbe4c9e8ec3922a6c504040_Out_2_Float;
            Unity_Add_float(_GradientNoise_26bc13aecb1b4c2081638300cc42b01d_Out_2_Float, _GradientNoise_aa58bf81bf93430985a301e296a23ad8_Out_2_Float, _Add_7767c92e2dbe4c9e8ec3922a6c504040_Out_2_Float);
            float _Divide_01c8ce94962043679abea203c1772a79_Out_2_Float;
            Unity_Divide_float(_Add_7767c92e2dbe4c9e8ec3922a6c504040_Out_2_Float, float(2), _Divide_01c8ce94962043679abea203c1772a79_Out_2_Float);
            float _Saturate_bf00c156675b44cd9168e9493fa1fa61_Out_1_Float;
            Unity_Saturate_float(_Divide_01c8ce94962043679abea203c1772a79_Out_2_Float, _Saturate_bf00c156675b44cd9168e9493fa1fa61_Out_1_Float);
            float _Property_b932cc0b0679463495ea24f5ae20fe0a_Out_0_Float = _Noise_Power;
            float _Power_bc99b52173a44811b5a653f85b30e92b_Out_2_Float;
            Unity_Power_float(_Saturate_bf00c156675b44cd9168e9493fa1fa61_Out_1_Float, _Property_b932cc0b0679463495ea24f5ae20fe0a_Out_0_Float, _Power_bc99b52173a44811b5a653f85b30e92b_Out_2_Float);
            float4 _Property_e85e1549c7ea4dc8be0b5d3469565ffd_Out_0_Vector4 = _Noise_Remap;
            float _Split_10eb25ab4f03492b8209300701e5f945_R_1_Float = _Property_e85e1549c7ea4dc8be0b5d3469565ffd_Out_0_Vector4[0];
            float _Split_10eb25ab4f03492b8209300701e5f945_G_2_Float = _Property_e85e1549c7ea4dc8be0b5d3469565ffd_Out_0_Vector4[1];
            float _Split_10eb25ab4f03492b8209300701e5f945_B_3_Float = _Property_e85e1549c7ea4dc8be0b5d3469565ffd_Out_0_Vector4[2];
            float _Split_10eb25ab4f03492b8209300701e5f945_A_4_Float = _Property_e85e1549c7ea4dc8be0b5d3469565ffd_Out_0_Vector4[3];
            float4 _Combine_edb179662e1a4052b97e671dbd3421a5_RGBA_4_Vector4;
            float3 _Combine_edb179662e1a4052b97e671dbd3421a5_RGB_5_Vector3;
            float2 _Combine_edb179662e1a4052b97e671dbd3421a5_RG_6_Vector2;
            Unity_Combine_float(_Split_10eb25ab4f03492b8209300701e5f945_R_1_Float, _Split_10eb25ab4f03492b8209300701e5f945_G_2_Float, float(0), float(0), _Combine_edb179662e1a4052b97e671dbd3421a5_RGBA_4_Vector4, _Combine_edb179662e1a4052b97e671dbd3421a5_RGB_5_Vector3, _Combine_edb179662e1a4052b97e671dbd3421a5_RG_6_Vector2);
            float4 _Combine_f12ac3a1b10f4f388dab86453258dcb0_RGBA_4_Vector4;
            float3 _Combine_f12ac3a1b10f4f388dab86453258dcb0_RGB_5_Vector3;
            float2 _Combine_f12ac3a1b10f4f388dab86453258dcb0_RG_6_Vector2;
            Unity_Combine_float(_Split_10eb25ab4f03492b8209300701e5f945_B_3_Float, _Split_10eb25ab4f03492b8209300701e5f945_A_4_Float, float(0), float(0), _Combine_f12ac3a1b10f4f388dab86453258dcb0_RGBA_4_Vector4, _Combine_f12ac3a1b10f4f388dab86453258dcb0_RGB_5_Vector3, _Combine_f12ac3a1b10f4f388dab86453258dcb0_RG_6_Vector2);
            float _Remap_b473bb8bd2254a3faad5291ff8cb7707_Out_3_Float;
            Unity_Remap_float(_Power_bc99b52173a44811b5a653f85b30e92b_Out_2_Float, _Combine_edb179662e1a4052b97e671dbd3421a5_RG_6_Vector2, _Combine_f12ac3a1b10f4f388dab86453258dcb0_RG_6_Vector2, _Remap_b473bb8bd2254a3faad5291ff8cb7707_Out_3_Float);
            float _Absolute_2367964a3dae475891ccd6c90e2885ff_Out_1_Float;
            Unity_Absolute_float(_Remap_b473bb8bd2254a3faad5291ff8cb7707_Out_3_Float, _Absolute_2367964a3dae475891ccd6c90e2885ff_Out_1_Float);
            float _Smoothstep_516feede7acb4f97b595cd89bba389c4_Out_3_Float;
            Unity_Smoothstep_float(_Property_f05727b79c2d491a8b9c2d8417d4ce68_Out_0_Float, _Property_7d43401174f8413091e457476f00d1aa_Out_0_Float, _Absolute_2367964a3dae475891ccd6c90e2885ff_Out_1_Float, _Smoothstep_516feede7acb4f97b595cd89bba389c4_Out_3_Float);
            float _Property_44e53f25d86f4edbaab4f19b6daaa067_Out_0_Float = _Base_Speed;
            float _Multiply_619aff87dcc446c5968bd1a6d44fe8b7_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_44e53f25d86f4edbaab4f19b6daaa067_Out_0_Float, _Multiply_619aff87dcc446c5968bd1a6d44fe8b7_Out_2_Float);
            float2 _TilingAndOffset_7cbf9da6c23b409fb98e46b72acb3373_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_a415e5a75c24452bbcd60ac1b3811fc6_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_619aff87dcc446c5968bd1a6d44fe8b7_Out_2_Float.xx), _TilingAndOffset_7cbf9da6c23b409fb98e46b72acb3373_Out_3_Vector2);
            float _Property_9254f8e15d6447988ec18cd37fe88bdc_Out_0_Float = _Base_Scale;
            float _GradientNoise_ce38dcc651b44efeb82145bfdadbf1fa_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_7cbf9da6c23b409fb98e46b72acb3373_Out_3_Vector2, _Property_9254f8e15d6447988ec18cd37fe88bdc_Out_0_Float, _GradientNoise_ce38dcc651b44efeb82145bfdadbf1fa_Out_2_Float);
            float _Property_56d73ff99ec94119881f3d643422251a_Out_0_Float = _Base_Strength;
            float _Multiply_a28097e44d4c485a867948d5b27a71aa_Out_2_Float;
            Unity_Multiply_float_float(_GradientNoise_ce38dcc651b44efeb82145bfdadbf1fa_Out_2_Float, _Property_56d73ff99ec94119881f3d643422251a_Out_0_Float, _Multiply_a28097e44d4c485a867948d5b27a71aa_Out_2_Float);
            float _Add_c6fbda241fda4ff68e2e16893549192e_Out_2_Float;
            Unity_Add_float(_Smoothstep_516feede7acb4f97b595cd89bba389c4_Out_3_Float, _Multiply_a28097e44d4c485a867948d5b27a71aa_Out_2_Float, _Add_c6fbda241fda4ff68e2e16893549192e_Out_2_Float);
            float _Add_5d9343a646914b1582c5ac00b2068a54_Out_2_Float;
            Unity_Add_float(float(0), _Property_56d73ff99ec94119881f3d643422251a_Out_0_Float, _Add_5d9343a646914b1582c5ac00b2068a54_Out_2_Float);
            float _Divide_fe411acd94ed4c4c83892bba30255329_Out_2_Float;
            Unity_Divide_float(_Add_c6fbda241fda4ff68e2e16893549192e_Out_2_Float, _Add_5d9343a646914b1582c5ac00b2068a54_Out_2_Float, _Divide_fe411acd94ed4c4c83892bba30255329_Out_2_Float);
            float3 _Multiply_b525aac067b04a9a8f9ce1a4c4716765_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.ObjectSpaceNormal, (_Divide_fe411acd94ed4c4c83892bba30255329_Out_2_Float.xxx), _Multiply_b525aac067b04a9a8f9ce1a4c4716765_Out_2_Vector3);
            float _Property_81343da7ab424f29a124d673b8099601_Out_0_Float = _Noise_Height;
            float3 _Multiply_431791af81b04fe4920287cee8e84b36_Out_2_Vector3;
            Unity_Multiply_float3_float3(_Multiply_b525aac067b04a9a8f9ce1a4c4716765_Out_2_Vector3, (_Property_81343da7ab424f29a124d673b8099601_Out_0_Float.xxx), _Multiply_431791af81b04fe4920287cee8e84b36_Out_2_Vector3);
            float3 _Add_e716c01d530b428c8bcb16ba04bed031_Out_2_Vector3;
            Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_431791af81b04fe4920287cee8e84b36_Out_2_Vector3, _Add_e716c01d530b428c8bcb16ba04bed031_Out_2_Vector3);
            float3 _Add_fc53f37eba984ae88bea18cd54a386d0_Out_2_Vector3;
            Unity_Add_float3(_Multiply_ff35d2ab09754f1c8b2fac2015de70db_Out_2_Vector3, _Add_e716c01d530b428c8bcb16ba04bed031_Out_2_Vector3, _Add_fc53f37eba984ae88bea18cd54a386d0_Out_2_Vector3);
            description.Position = _Add_fc53f37eba984ae88bea18cd54a386d0_Out_2_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_08f55cc2215f457abdf288e58daaa696_Out_0_Vector4 = _Color_A;
            float4 _Property_acbafd3dca104c65b7b71611d4639044_Out_0_Vector4 = _Color_B;
            float _Property_f05727b79c2d491a8b9c2d8417d4ce68_Out_0_Float = _Smooth_Step_1;
            float _Property_7d43401174f8413091e457476f00d1aa_Out_0_Float = _Smooth_Step_2;
            float4 _Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4 = _Rotate_Projection;
            float _Split_610d0b28a0e94e38b42626a03d9f9794_R_1_Float = _Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4[0];
            float _Split_610d0b28a0e94e38b42626a03d9f9794_G_2_Float = _Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4[1];
            float _Split_610d0b28a0e94e38b42626a03d9f9794_B_3_Float = _Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4[2];
            float _Split_610d0b28a0e94e38b42626a03d9f9794_A_4_Float = _Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4[3];
            float3 _RotateAboutAxis_a415e5a75c24452bbcd60ac1b3811fc6_Out_3_Vector3;
            Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4.xyz), _Split_610d0b28a0e94e38b42626a03d9f9794_A_4_Float, _RotateAboutAxis_a415e5a75c24452bbcd60ac1b3811fc6_Out_3_Vector3);
            float _Property_2ada180c9afb42be8c587ae354b92988_Out_0_Float = _Noise_Speed;
            float _Multiply_ab217b8df9084424b472a49bafb4515d_Out_2_Float;
            Unity_Multiply_float_float(_Property_2ada180c9afb42be8c587ae354b92988_Out_0_Float, IN.TimeParameters.x, _Multiply_ab217b8df9084424b472a49bafb4515d_Out_2_Float);
            float2 _TilingAndOffset_0b468c25d4d14a999d61900af42dd09d_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_a415e5a75c24452bbcd60ac1b3811fc6_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_ab217b8df9084424b472a49bafb4515d_Out_2_Float.xx), _TilingAndOffset_0b468c25d4d14a999d61900af42dd09d_Out_3_Vector2);
            float _Property_4cdc099c195e4d6a8f9f35604045d0b7_Out_0_Float = _Noise_Scale;
            float _GradientNoise_26bc13aecb1b4c2081638300cc42b01d_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_0b468c25d4d14a999d61900af42dd09d_Out_3_Vector2, _Property_4cdc099c195e4d6a8f9f35604045d0b7_Out_0_Float, _GradientNoise_26bc13aecb1b4c2081638300cc42b01d_Out_2_Float);
            float2 _TilingAndOffset_88de901db4e14268b84877dc201207b6_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_a415e5a75c24452bbcd60ac1b3811fc6_Out_3_Vector3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_88de901db4e14268b84877dc201207b6_Out_3_Vector2);
            float _GradientNoise_aa58bf81bf93430985a301e296a23ad8_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_88de901db4e14268b84877dc201207b6_Out_3_Vector2, _Property_4cdc099c195e4d6a8f9f35604045d0b7_Out_0_Float, _GradientNoise_aa58bf81bf93430985a301e296a23ad8_Out_2_Float);
            float _Add_7767c92e2dbe4c9e8ec3922a6c504040_Out_2_Float;
            Unity_Add_float(_GradientNoise_26bc13aecb1b4c2081638300cc42b01d_Out_2_Float, _GradientNoise_aa58bf81bf93430985a301e296a23ad8_Out_2_Float, _Add_7767c92e2dbe4c9e8ec3922a6c504040_Out_2_Float);
            float _Divide_01c8ce94962043679abea203c1772a79_Out_2_Float;
            Unity_Divide_float(_Add_7767c92e2dbe4c9e8ec3922a6c504040_Out_2_Float, float(2), _Divide_01c8ce94962043679abea203c1772a79_Out_2_Float);
            float _Saturate_bf00c156675b44cd9168e9493fa1fa61_Out_1_Float;
            Unity_Saturate_float(_Divide_01c8ce94962043679abea203c1772a79_Out_2_Float, _Saturate_bf00c156675b44cd9168e9493fa1fa61_Out_1_Float);
            float _Property_b932cc0b0679463495ea24f5ae20fe0a_Out_0_Float = _Noise_Power;
            float _Power_bc99b52173a44811b5a653f85b30e92b_Out_2_Float;
            Unity_Power_float(_Saturate_bf00c156675b44cd9168e9493fa1fa61_Out_1_Float, _Property_b932cc0b0679463495ea24f5ae20fe0a_Out_0_Float, _Power_bc99b52173a44811b5a653f85b30e92b_Out_2_Float);
            float4 _Property_e85e1549c7ea4dc8be0b5d3469565ffd_Out_0_Vector4 = _Noise_Remap;
            float _Split_10eb25ab4f03492b8209300701e5f945_R_1_Float = _Property_e85e1549c7ea4dc8be0b5d3469565ffd_Out_0_Vector4[0];
            float _Split_10eb25ab4f03492b8209300701e5f945_G_2_Float = _Property_e85e1549c7ea4dc8be0b5d3469565ffd_Out_0_Vector4[1];
            float _Split_10eb25ab4f03492b8209300701e5f945_B_3_Float = _Property_e85e1549c7ea4dc8be0b5d3469565ffd_Out_0_Vector4[2];
            float _Split_10eb25ab4f03492b8209300701e5f945_A_4_Float = _Property_e85e1549c7ea4dc8be0b5d3469565ffd_Out_0_Vector4[3];
            float4 _Combine_edb179662e1a4052b97e671dbd3421a5_RGBA_4_Vector4;
            float3 _Combine_edb179662e1a4052b97e671dbd3421a5_RGB_5_Vector3;
            float2 _Combine_edb179662e1a4052b97e671dbd3421a5_RG_6_Vector2;
            Unity_Combine_float(_Split_10eb25ab4f03492b8209300701e5f945_R_1_Float, _Split_10eb25ab4f03492b8209300701e5f945_G_2_Float, float(0), float(0), _Combine_edb179662e1a4052b97e671dbd3421a5_RGBA_4_Vector4, _Combine_edb179662e1a4052b97e671dbd3421a5_RGB_5_Vector3, _Combine_edb179662e1a4052b97e671dbd3421a5_RG_6_Vector2);
            float4 _Combine_f12ac3a1b10f4f388dab86453258dcb0_RGBA_4_Vector4;
            float3 _Combine_f12ac3a1b10f4f388dab86453258dcb0_RGB_5_Vector3;
            float2 _Combine_f12ac3a1b10f4f388dab86453258dcb0_RG_6_Vector2;
            Unity_Combine_float(_Split_10eb25ab4f03492b8209300701e5f945_B_3_Float, _Split_10eb25ab4f03492b8209300701e5f945_A_4_Float, float(0), float(0), _Combine_f12ac3a1b10f4f388dab86453258dcb0_RGBA_4_Vector4, _Combine_f12ac3a1b10f4f388dab86453258dcb0_RGB_5_Vector3, _Combine_f12ac3a1b10f4f388dab86453258dcb0_RG_6_Vector2);
            float _Remap_b473bb8bd2254a3faad5291ff8cb7707_Out_3_Float;
            Unity_Remap_float(_Power_bc99b52173a44811b5a653f85b30e92b_Out_2_Float, _Combine_edb179662e1a4052b97e671dbd3421a5_RG_6_Vector2, _Combine_f12ac3a1b10f4f388dab86453258dcb0_RG_6_Vector2, _Remap_b473bb8bd2254a3faad5291ff8cb7707_Out_3_Float);
            float _Absolute_2367964a3dae475891ccd6c90e2885ff_Out_1_Float;
            Unity_Absolute_float(_Remap_b473bb8bd2254a3faad5291ff8cb7707_Out_3_Float, _Absolute_2367964a3dae475891ccd6c90e2885ff_Out_1_Float);
            float _Smoothstep_516feede7acb4f97b595cd89bba389c4_Out_3_Float;
            Unity_Smoothstep_float(_Property_f05727b79c2d491a8b9c2d8417d4ce68_Out_0_Float, _Property_7d43401174f8413091e457476f00d1aa_Out_0_Float, _Absolute_2367964a3dae475891ccd6c90e2885ff_Out_1_Float, _Smoothstep_516feede7acb4f97b595cd89bba389c4_Out_3_Float);
            float _Property_44e53f25d86f4edbaab4f19b6daaa067_Out_0_Float = _Base_Speed;
            float _Multiply_619aff87dcc446c5968bd1a6d44fe8b7_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_44e53f25d86f4edbaab4f19b6daaa067_Out_0_Float, _Multiply_619aff87dcc446c5968bd1a6d44fe8b7_Out_2_Float);
            float2 _TilingAndOffset_7cbf9da6c23b409fb98e46b72acb3373_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_a415e5a75c24452bbcd60ac1b3811fc6_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_619aff87dcc446c5968bd1a6d44fe8b7_Out_2_Float.xx), _TilingAndOffset_7cbf9da6c23b409fb98e46b72acb3373_Out_3_Vector2);
            float _Property_9254f8e15d6447988ec18cd37fe88bdc_Out_0_Float = _Base_Scale;
            float _GradientNoise_ce38dcc651b44efeb82145bfdadbf1fa_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_7cbf9da6c23b409fb98e46b72acb3373_Out_3_Vector2, _Property_9254f8e15d6447988ec18cd37fe88bdc_Out_0_Float, _GradientNoise_ce38dcc651b44efeb82145bfdadbf1fa_Out_2_Float);
            float _Property_56d73ff99ec94119881f3d643422251a_Out_0_Float = _Base_Strength;
            float _Multiply_a28097e44d4c485a867948d5b27a71aa_Out_2_Float;
            Unity_Multiply_float_float(_GradientNoise_ce38dcc651b44efeb82145bfdadbf1fa_Out_2_Float, _Property_56d73ff99ec94119881f3d643422251a_Out_0_Float, _Multiply_a28097e44d4c485a867948d5b27a71aa_Out_2_Float);
            float _Add_c6fbda241fda4ff68e2e16893549192e_Out_2_Float;
            Unity_Add_float(_Smoothstep_516feede7acb4f97b595cd89bba389c4_Out_3_Float, _Multiply_a28097e44d4c485a867948d5b27a71aa_Out_2_Float, _Add_c6fbda241fda4ff68e2e16893549192e_Out_2_Float);
            float _Add_5d9343a646914b1582c5ac00b2068a54_Out_2_Float;
            Unity_Add_float(float(0), _Property_56d73ff99ec94119881f3d643422251a_Out_0_Float, _Add_5d9343a646914b1582c5ac00b2068a54_Out_2_Float);
            float _Divide_fe411acd94ed4c4c83892bba30255329_Out_2_Float;
            Unity_Divide_float(_Add_c6fbda241fda4ff68e2e16893549192e_Out_2_Float, _Add_5d9343a646914b1582c5ac00b2068a54_Out_2_Float, _Divide_fe411acd94ed4c4c83892bba30255329_Out_2_Float);
            float4 _Lerp_aaaae5c0660549cda8a2edb7a84e8dbb_Out_3_Vector4;
            Unity_Lerp_float4(_Property_08f55cc2215f457abdf288e58daaa696_Out_0_Vector4, _Property_acbafd3dca104c65b7b71611d4639044_Out_0_Vector4, (_Divide_fe411acd94ed4c4c83892bba30255329_Out_2_Float.xxxx), _Lerp_aaaae5c0660549cda8a2edb7a84e8dbb_Out_3_Vector4);
            float _SceneDepth_7a3cc358e0f44107b8bce7383895b953_Out_1_Float;
            Unity_SceneDepth_Eye_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_7a3cc358e0f44107b8bce7383895b953_Out_1_Float);
            float4 _ScreenPosition_344727010a4a40389b6dd34b4b9b2ac3_Out_0_Vector4 = IN.ScreenPosition;
            float _Split_acb0902b83d148e2a31506c594db0146_R_1_Float = _ScreenPosition_344727010a4a40389b6dd34b4b9b2ac3_Out_0_Vector4[0];
            float _Split_acb0902b83d148e2a31506c594db0146_G_2_Float = _ScreenPosition_344727010a4a40389b6dd34b4b9b2ac3_Out_0_Vector4[1];
            float _Split_acb0902b83d148e2a31506c594db0146_B_3_Float = _ScreenPosition_344727010a4a40389b6dd34b4b9b2ac3_Out_0_Vector4[2];
            float _Split_acb0902b83d148e2a31506c594db0146_A_4_Float = _ScreenPosition_344727010a4a40389b6dd34b4b9b2ac3_Out_0_Vector4[3];
            float _Subtract_3db7c3ced20d44b3a55e93b8d56c3fc1_Out_2_Float;
            Unity_Subtract_float(_Split_acb0902b83d148e2a31506c594db0146_A_4_Float, float(1), _Subtract_3db7c3ced20d44b3a55e93b8d56c3fc1_Out_2_Float);
            float _Subtract_0b683ae745b74caaa4830cb31795132a_Out_2_Float;
            Unity_Subtract_float(_SceneDepth_7a3cc358e0f44107b8bce7383895b953_Out_1_Float, _Subtract_3db7c3ced20d44b3a55e93b8d56c3fc1_Out_2_Float, _Subtract_0b683ae745b74caaa4830cb31795132a_Out_2_Float);
            float _Property_13ffae534f05496e8446dd4eff4d54b3_Out_0_Float = _Fade_Depth;
            float _Divide_5ea1c32f7a9541ce96555bb9c53dad4e_Out_2_Float;
            Unity_Divide_float(_Subtract_0b683ae745b74caaa4830cb31795132a_Out_2_Float, _Property_13ffae534f05496e8446dd4eff4d54b3_Out_0_Float, _Divide_5ea1c32f7a9541ce96555bb9c53dad4e_Out_2_Float);
            float _Saturate_11cb953c9f3a4ad98649c8032095e0a5_Out_1_Float;
            Unity_Saturate_float(_Divide_5ea1c32f7a9541ce96555bb9c53dad4e_Out_2_Float, _Saturate_11cb953c9f3a4ad98649c8032095e0a5_Out_1_Float);
            float _Smoothstep_804d457501334adcb743390e55365a80_Out_3_Float;
            Unity_Smoothstep_float(float(0), float(1), _Saturate_11cb953c9f3a4ad98649c8032095e0a5_Out_1_Float, _Smoothstep_804d457501334adcb743390e55365a80_Out_3_Float);
            surface.BaseColor = (_Lerp_aaaae5c0660549cda8a2edb7a84e8dbb_Out_3_Vector4.xyz);
            surface.Alpha = _Smoothstep_804d457501334adcb743390e55365a80_Out_3_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.WorldSpaceNormal =                           TransformObjectToWorldNormal(input.normalOS);
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.WorldSpacePosition =                         TransformObjectToWorld(input.positionOS);
            output.TimeParameters =                             _TimeParameters.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "Universal 2D"
            Tags
            {
                "LightMode" = "Universal2D"
            }
        
        // Render State
        Cull Off
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
        ZTest LEqual
        ZWrite On
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_POSITION_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_2D
        #define REQUIRE_DEPTH_TEXTURE
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 WorldSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float3 WorldSpacePosition;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS : INTERP0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.positionWS.xyz = input.positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.positionWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _Rotate_Projection;
        float _Noise_Scale;
        float _Noise_Speed;
        float _Noise_Height;
        float4 _Noise_Remap;
        float4 _Color_A;
        float4 _Color_B;
        float _Smooth_Step_1;
        float _Smooth_Step_2;
        float _Noise_Power;
        float _Base_Scale;
        float _Base_Speed;
        float _Base_Strength;
        float _Emission_Strength;
        float _Curvature_Radius;
        float _Fresnel_Effect_Power;
        float _Fresnel_Effect_Opacity;
        float _Fade_Depth;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Distance_float3(float3 A, float3 B, out float Out)
        {
            Out = distance(A, B);
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
        {
            Rotation = radians(Rotation);
            float s, c;
            sincos(Rotation, s, c);
            Axis = normalize(Axis);
            Out = In * c + cross(Axis, In) * s + Axis * dot(Axis, In) * (1 - c);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
        {
            float x; Hash_Tchou_2_1_float(p, x);
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
        {
            float2 p = UV * Scale.xy;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            if (unity_OrthoParams.w == 1.0)
            {
                Out = LinearEyeDepth(ComputeWorldSpacePosition(UV.xy, SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), UNITY_MATRIX_I_VP), UNITY_MATRIX_V);
            }
            else
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Distance_2db07498d99c49328512eaf4405dfb7d_Out_2_Float;
            Unity_Distance_float3(SHADERGRAPH_OBJECT_POSITION, IN.WorldSpacePosition, _Distance_2db07498d99c49328512eaf4405dfb7d_Out_2_Float);
            float _Property_781afe0d084b4e86ba202ae12d2df5c3_Out_0_Float = _Curvature_Radius;
            float _Divide_3a2887a0281d4fb9a0b32e1c0fa89d00_Out_2_Float;
            Unity_Divide_float(_Distance_2db07498d99c49328512eaf4405dfb7d_Out_2_Float, _Property_781afe0d084b4e86ba202ae12d2df5c3_Out_0_Float, _Divide_3a2887a0281d4fb9a0b32e1c0fa89d00_Out_2_Float);
            float _Power_dae4028a0ef04cc885209d872784f592_Out_2_Float;
            Unity_Power_float(_Divide_3a2887a0281d4fb9a0b32e1c0fa89d00_Out_2_Float, float(3), _Power_dae4028a0ef04cc885209d872784f592_Out_2_Float);
            float3 _Multiply_ff35d2ab09754f1c8b2fac2015de70db_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.WorldSpaceNormal, (_Power_dae4028a0ef04cc885209d872784f592_Out_2_Float.xxx), _Multiply_ff35d2ab09754f1c8b2fac2015de70db_Out_2_Vector3);
            float _Property_f05727b79c2d491a8b9c2d8417d4ce68_Out_0_Float = _Smooth_Step_1;
            float _Property_7d43401174f8413091e457476f00d1aa_Out_0_Float = _Smooth_Step_2;
            float4 _Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4 = _Rotate_Projection;
            float _Split_610d0b28a0e94e38b42626a03d9f9794_R_1_Float = _Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4[0];
            float _Split_610d0b28a0e94e38b42626a03d9f9794_G_2_Float = _Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4[1];
            float _Split_610d0b28a0e94e38b42626a03d9f9794_B_3_Float = _Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4[2];
            float _Split_610d0b28a0e94e38b42626a03d9f9794_A_4_Float = _Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4[3];
            float3 _RotateAboutAxis_a415e5a75c24452bbcd60ac1b3811fc6_Out_3_Vector3;
            Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4.xyz), _Split_610d0b28a0e94e38b42626a03d9f9794_A_4_Float, _RotateAboutAxis_a415e5a75c24452bbcd60ac1b3811fc6_Out_3_Vector3);
            float _Property_2ada180c9afb42be8c587ae354b92988_Out_0_Float = _Noise_Speed;
            float _Multiply_ab217b8df9084424b472a49bafb4515d_Out_2_Float;
            Unity_Multiply_float_float(_Property_2ada180c9afb42be8c587ae354b92988_Out_0_Float, IN.TimeParameters.x, _Multiply_ab217b8df9084424b472a49bafb4515d_Out_2_Float);
            float2 _TilingAndOffset_0b468c25d4d14a999d61900af42dd09d_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_a415e5a75c24452bbcd60ac1b3811fc6_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_ab217b8df9084424b472a49bafb4515d_Out_2_Float.xx), _TilingAndOffset_0b468c25d4d14a999d61900af42dd09d_Out_3_Vector2);
            float _Property_4cdc099c195e4d6a8f9f35604045d0b7_Out_0_Float = _Noise_Scale;
            float _GradientNoise_26bc13aecb1b4c2081638300cc42b01d_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_0b468c25d4d14a999d61900af42dd09d_Out_3_Vector2, _Property_4cdc099c195e4d6a8f9f35604045d0b7_Out_0_Float, _GradientNoise_26bc13aecb1b4c2081638300cc42b01d_Out_2_Float);
            float2 _TilingAndOffset_88de901db4e14268b84877dc201207b6_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_a415e5a75c24452bbcd60ac1b3811fc6_Out_3_Vector3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_88de901db4e14268b84877dc201207b6_Out_3_Vector2);
            float _GradientNoise_aa58bf81bf93430985a301e296a23ad8_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_88de901db4e14268b84877dc201207b6_Out_3_Vector2, _Property_4cdc099c195e4d6a8f9f35604045d0b7_Out_0_Float, _GradientNoise_aa58bf81bf93430985a301e296a23ad8_Out_2_Float);
            float _Add_7767c92e2dbe4c9e8ec3922a6c504040_Out_2_Float;
            Unity_Add_float(_GradientNoise_26bc13aecb1b4c2081638300cc42b01d_Out_2_Float, _GradientNoise_aa58bf81bf93430985a301e296a23ad8_Out_2_Float, _Add_7767c92e2dbe4c9e8ec3922a6c504040_Out_2_Float);
            float _Divide_01c8ce94962043679abea203c1772a79_Out_2_Float;
            Unity_Divide_float(_Add_7767c92e2dbe4c9e8ec3922a6c504040_Out_2_Float, float(2), _Divide_01c8ce94962043679abea203c1772a79_Out_2_Float);
            float _Saturate_bf00c156675b44cd9168e9493fa1fa61_Out_1_Float;
            Unity_Saturate_float(_Divide_01c8ce94962043679abea203c1772a79_Out_2_Float, _Saturate_bf00c156675b44cd9168e9493fa1fa61_Out_1_Float);
            float _Property_b932cc0b0679463495ea24f5ae20fe0a_Out_0_Float = _Noise_Power;
            float _Power_bc99b52173a44811b5a653f85b30e92b_Out_2_Float;
            Unity_Power_float(_Saturate_bf00c156675b44cd9168e9493fa1fa61_Out_1_Float, _Property_b932cc0b0679463495ea24f5ae20fe0a_Out_0_Float, _Power_bc99b52173a44811b5a653f85b30e92b_Out_2_Float);
            float4 _Property_e85e1549c7ea4dc8be0b5d3469565ffd_Out_0_Vector4 = _Noise_Remap;
            float _Split_10eb25ab4f03492b8209300701e5f945_R_1_Float = _Property_e85e1549c7ea4dc8be0b5d3469565ffd_Out_0_Vector4[0];
            float _Split_10eb25ab4f03492b8209300701e5f945_G_2_Float = _Property_e85e1549c7ea4dc8be0b5d3469565ffd_Out_0_Vector4[1];
            float _Split_10eb25ab4f03492b8209300701e5f945_B_3_Float = _Property_e85e1549c7ea4dc8be0b5d3469565ffd_Out_0_Vector4[2];
            float _Split_10eb25ab4f03492b8209300701e5f945_A_4_Float = _Property_e85e1549c7ea4dc8be0b5d3469565ffd_Out_0_Vector4[3];
            float4 _Combine_edb179662e1a4052b97e671dbd3421a5_RGBA_4_Vector4;
            float3 _Combine_edb179662e1a4052b97e671dbd3421a5_RGB_5_Vector3;
            float2 _Combine_edb179662e1a4052b97e671dbd3421a5_RG_6_Vector2;
            Unity_Combine_float(_Split_10eb25ab4f03492b8209300701e5f945_R_1_Float, _Split_10eb25ab4f03492b8209300701e5f945_G_2_Float, float(0), float(0), _Combine_edb179662e1a4052b97e671dbd3421a5_RGBA_4_Vector4, _Combine_edb179662e1a4052b97e671dbd3421a5_RGB_5_Vector3, _Combine_edb179662e1a4052b97e671dbd3421a5_RG_6_Vector2);
            float4 _Combine_f12ac3a1b10f4f388dab86453258dcb0_RGBA_4_Vector4;
            float3 _Combine_f12ac3a1b10f4f388dab86453258dcb0_RGB_5_Vector3;
            float2 _Combine_f12ac3a1b10f4f388dab86453258dcb0_RG_6_Vector2;
            Unity_Combine_float(_Split_10eb25ab4f03492b8209300701e5f945_B_3_Float, _Split_10eb25ab4f03492b8209300701e5f945_A_4_Float, float(0), float(0), _Combine_f12ac3a1b10f4f388dab86453258dcb0_RGBA_4_Vector4, _Combine_f12ac3a1b10f4f388dab86453258dcb0_RGB_5_Vector3, _Combine_f12ac3a1b10f4f388dab86453258dcb0_RG_6_Vector2);
            float _Remap_b473bb8bd2254a3faad5291ff8cb7707_Out_3_Float;
            Unity_Remap_float(_Power_bc99b52173a44811b5a653f85b30e92b_Out_2_Float, _Combine_edb179662e1a4052b97e671dbd3421a5_RG_6_Vector2, _Combine_f12ac3a1b10f4f388dab86453258dcb0_RG_6_Vector2, _Remap_b473bb8bd2254a3faad5291ff8cb7707_Out_3_Float);
            float _Absolute_2367964a3dae475891ccd6c90e2885ff_Out_1_Float;
            Unity_Absolute_float(_Remap_b473bb8bd2254a3faad5291ff8cb7707_Out_3_Float, _Absolute_2367964a3dae475891ccd6c90e2885ff_Out_1_Float);
            float _Smoothstep_516feede7acb4f97b595cd89bba389c4_Out_3_Float;
            Unity_Smoothstep_float(_Property_f05727b79c2d491a8b9c2d8417d4ce68_Out_0_Float, _Property_7d43401174f8413091e457476f00d1aa_Out_0_Float, _Absolute_2367964a3dae475891ccd6c90e2885ff_Out_1_Float, _Smoothstep_516feede7acb4f97b595cd89bba389c4_Out_3_Float);
            float _Property_44e53f25d86f4edbaab4f19b6daaa067_Out_0_Float = _Base_Speed;
            float _Multiply_619aff87dcc446c5968bd1a6d44fe8b7_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_44e53f25d86f4edbaab4f19b6daaa067_Out_0_Float, _Multiply_619aff87dcc446c5968bd1a6d44fe8b7_Out_2_Float);
            float2 _TilingAndOffset_7cbf9da6c23b409fb98e46b72acb3373_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_a415e5a75c24452bbcd60ac1b3811fc6_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_619aff87dcc446c5968bd1a6d44fe8b7_Out_2_Float.xx), _TilingAndOffset_7cbf9da6c23b409fb98e46b72acb3373_Out_3_Vector2);
            float _Property_9254f8e15d6447988ec18cd37fe88bdc_Out_0_Float = _Base_Scale;
            float _GradientNoise_ce38dcc651b44efeb82145bfdadbf1fa_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_7cbf9da6c23b409fb98e46b72acb3373_Out_3_Vector2, _Property_9254f8e15d6447988ec18cd37fe88bdc_Out_0_Float, _GradientNoise_ce38dcc651b44efeb82145bfdadbf1fa_Out_2_Float);
            float _Property_56d73ff99ec94119881f3d643422251a_Out_0_Float = _Base_Strength;
            float _Multiply_a28097e44d4c485a867948d5b27a71aa_Out_2_Float;
            Unity_Multiply_float_float(_GradientNoise_ce38dcc651b44efeb82145bfdadbf1fa_Out_2_Float, _Property_56d73ff99ec94119881f3d643422251a_Out_0_Float, _Multiply_a28097e44d4c485a867948d5b27a71aa_Out_2_Float);
            float _Add_c6fbda241fda4ff68e2e16893549192e_Out_2_Float;
            Unity_Add_float(_Smoothstep_516feede7acb4f97b595cd89bba389c4_Out_3_Float, _Multiply_a28097e44d4c485a867948d5b27a71aa_Out_2_Float, _Add_c6fbda241fda4ff68e2e16893549192e_Out_2_Float);
            float _Add_5d9343a646914b1582c5ac00b2068a54_Out_2_Float;
            Unity_Add_float(float(0), _Property_56d73ff99ec94119881f3d643422251a_Out_0_Float, _Add_5d9343a646914b1582c5ac00b2068a54_Out_2_Float);
            float _Divide_fe411acd94ed4c4c83892bba30255329_Out_2_Float;
            Unity_Divide_float(_Add_c6fbda241fda4ff68e2e16893549192e_Out_2_Float, _Add_5d9343a646914b1582c5ac00b2068a54_Out_2_Float, _Divide_fe411acd94ed4c4c83892bba30255329_Out_2_Float);
            float3 _Multiply_b525aac067b04a9a8f9ce1a4c4716765_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.ObjectSpaceNormal, (_Divide_fe411acd94ed4c4c83892bba30255329_Out_2_Float.xxx), _Multiply_b525aac067b04a9a8f9ce1a4c4716765_Out_2_Vector3);
            float _Property_81343da7ab424f29a124d673b8099601_Out_0_Float = _Noise_Height;
            float3 _Multiply_431791af81b04fe4920287cee8e84b36_Out_2_Vector3;
            Unity_Multiply_float3_float3(_Multiply_b525aac067b04a9a8f9ce1a4c4716765_Out_2_Vector3, (_Property_81343da7ab424f29a124d673b8099601_Out_0_Float.xxx), _Multiply_431791af81b04fe4920287cee8e84b36_Out_2_Vector3);
            float3 _Add_e716c01d530b428c8bcb16ba04bed031_Out_2_Vector3;
            Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_431791af81b04fe4920287cee8e84b36_Out_2_Vector3, _Add_e716c01d530b428c8bcb16ba04bed031_Out_2_Vector3);
            float3 _Add_fc53f37eba984ae88bea18cd54a386d0_Out_2_Vector3;
            Unity_Add_float3(_Multiply_ff35d2ab09754f1c8b2fac2015de70db_Out_2_Vector3, _Add_e716c01d530b428c8bcb16ba04bed031_Out_2_Vector3, _Add_fc53f37eba984ae88bea18cd54a386d0_Out_2_Vector3);
            description.Position = _Add_fc53f37eba984ae88bea18cd54a386d0_Out_2_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_08f55cc2215f457abdf288e58daaa696_Out_0_Vector4 = _Color_A;
            float4 _Property_acbafd3dca104c65b7b71611d4639044_Out_0_Vector4 = _Color_B;
            float _Property_f05727b79c2d491a8b9c2d8417d4ce68_Out_0_Float = _Smooth_Step_1;
            float _Property_7d43401174f8413091e457476f00d1aa_Out_0_Float = _Smooth_Step_2;
            float4 _Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4 = _Rotate_Projection;
            float _Split_610d0b28a0e94e38b42626a03d9f9794_R_1_Float = _Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4[0];
            float _Split_610d0b28a0e94e38b42626a03d9f9794_G_2_Float = _Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4[1];
            float _Split_610d0b28a0e94e38b42626a03d9f9794_B_3_Float = _Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4[2];
            float _Split_610d0b28a0e94e38b42626a03d9f9794_A_4_Float = _Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4[3];
            float3 _RotateAboutAxis_a415e5a75c24452bbcd60ac1b3811fc6_Out_3_Vector3;
            Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_dd2edfdf13204e7ca7bbd3a85163e07c_Out_0_Vector4.xyz), _Split_610d0b28a0e94e38b42626a03d9f9794_A_4_Float, _RotateAboutAxis_a415e5a75c24452bbcd60ac1b3811fc6_Out_3_Vector3);
            float _Property_2ada180c9afb42be8c587ae354b92988_Out_0_Float = _Noise_Speed;
            float _Multiply_ab217b8df9084424b472a49bafb4515d_Out_2_Float;
            Unity_Multiply_float_float(_Property_2ada180c9afb42be8c587ae354b92988_Out_0_Float, IN.TimeParameters.x, _Multiply_ab217b8df9084424b472a49bafb4515d_Out_2_Float);
            float2 _TilingAndOffset_0b468c25d4d14a999d61900af42dd09d_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_a415e5a75c24452bbcd60ac1b3811fc6_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_ab217b8df9084424b472a49bafb4515d_Out_2_Float.xx), _TilingAndOffset_0b468c25d4d14a999d61900af42dd09d_Out_3_Vector2);
            float _Property_4cdc099c195e4d6a8f9f35604045d0b7_Out_0_Float = _Noise_Scale;
            float _GradientNoise_26bc13aecb1b4c2081638300cc42b01d_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_0b468c25d4d14a999d61900af42dd09d_Out_3_Vector2, _Property_4cdc099c195e4d6a8f9f35604045d0b7_Out_0_Float, _GradientNoise_26bc13aecb1b4c2081638300cc42b01d_Out_2_Float);
            float2 _TilingAndOffset_88de901db4e14268b84877dc201207b6_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_a415e5a75c24452bbcd60ac1b3811fc6_Out_3_Vector3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_88de901db4e14268b84877dc201207b6_Out_3_Vector2);
            float _GradientNoise_aa58bf81bf93430985a301e296a23ad8_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_88de901db4e14268b84877dc201207b6_Out_3_Vector2, _Property_4cdc099c195e4d6a8f9f35604045d0b7_Out_0_Float, _GradientNoise_aa58bf81bf93430985a301e296a23ad8_Out_2_Float);
            float _Add_7767c92e2dbe4c9e8ec3922a6c504040_Out_2_Float;
            Unity_Add_float(_GradientNoise_26bc13aecb1b4c2081638300cc42b01d_Out_2_Float, _GradientNoise_aa58bf81bf93430985a301e296a23ad8_Out_2_Float, _Add_7767c92e2dbe4c9e8ec3922a6c504040_Out_2_Float);
            float _Divide_01c8ce94962043679abea203c1772a79_Out_2_Float;
            Unity_Divide_float(_Add_7767c92e2dbe4c9e8ec3922a6c504040_Out_2_Float, float(2), _Divide_01c8ce94962043679abea203c1772a79_Out_2_Float);
            float _Saturate_bf00c156675b44cd9168e9493fa1fa61_Out_1_Float;
            Unity_Saturate_float(_Divide_01c8ce94962043679abea203c1772a79_Out_2_Float, _Saturate_bf00c156675b44cd9168e9493fa1fa61_Out_1_Float);
            float _Property_b932cc0b0679463495ea24f5ae20fe0a_Out_0_Float = _Noise_Power;
            float _Power_bc99b52173a44811b5a653f85b30e92b_Out_2_Float;
            Unity_Power_float(_Saturate_bf00c156675b44cd9168e9493fa1fa61_Out_1_Float, _Property_b932cc0b0679463495ea24f5ae20fe0a_Out_0_Float, _Power_bc99b52173a44811b5a653f85b30e92b_Out_2_Float);
            float4 _Property_e85e1549c7ea4dc8be0b5d3469565ffd_Out_0_Vector4 = _Noise_Remap;
            float _Split_10eb25ab4f03492b8209300701e5f945_R_1_Float = _Property_e85e1549c7ea4dc8be0b5d3469565ffd_Out_0_Vector4[0];
            float _Split_10eb25ab4f03492b8209300701e5f945_G_2_Float = _Property_e85e1549c7ea4dc8be0b5d3469565ffd_Out_0_Vector4[1];
            float _Split_10eb25ab4f03492b8209300701e5f945_B_3_Float = _Property_e85e1549c7ea4dc8be0b5d3469565ffd_Out_0_Vector4[2];
            float _Split_10eb25ab4f03492b8209300701e5f945_A_4_Float = _Property_e85e1549c7ea4dc8be0b5d3469565ffd_Out_0_Vector4[3];
            float4 _Combine_edb179662e1a4052b97e671dbd3421a5_RGBA_4_Vector4;
            float3 _Combine_edb179662e1a4052b97e671dbd3421a5_RGB_5_Vector3;
            float2 _Combine_edb179662e1a4052b97e671dbd3421a5_RG_6_Vector2;
            Unity_Combine_float(_Split_10eb25ab4f03492b8209300701e5f945_R_1_Float, _Split_10eb25ab4f03492b8209300701e5f945_G_2_Float, float(0), float(0), _Combine_edb179662e1a4052b97e671dbd3421a5_RGBA_4_Vector4, _Combine_edb179662e1a4052b97e671dbd3421a5_RGB_5_Vector3, _Combine_edb179662e1a4052b97e671dbd3421a5_RG_6_Vector2);
            float4 _Combine_f12ac3a1b10f4f388dab86453258dcb0_RGBA_4_Vector4;
            float3 _Combine_f12ac3a1b10f4f388dab86453258dcb0_RGB_5_Vector3;
            float2 _Combine_f12ac3a1b10f4f388dab86453258dcb0_RG_6_Vector2;
            Unity_Combine_float(_Split_10eb25ab4f03492b8209300701e5f945_B_3_Float, _Split_10eb25ab4f03492b8209300701e5f945_A_4_Float, float(0), float(0), _Combine_f12ac3a1b10f4f388dab86453258dcb0_RGBA_4_Vector4, _Combine_f12ac3a1b10f4f388dab86453258dcb0_RGB_5_Vector3, _Combine_f12ac3a1b10f4f388dab86453258dcb0_RG_6_Vector2);
            float _Remap_b473bb8bd2254a3faad5291ff8cb7707_Out_3_Float;
            Unity_Remap_float(_Power_bc99b52173a44811b5a653f85b30e92b_Out_2_Float, _Combine_edb179662e1a4052b97e671dbd3421a5_RG_6_Vector2, _Combine_f12ac3a1b10f4f388dab86453258dcb0_RG_6_Vector2, _Remap_b473bb8bd2254a3faad5291ff8cb7707_Out_3_Float);
            float _Absolute_2367964a3dae475891ccd6c90e2885ff_Out_1_Float;
            Unity_Absolute_float(_Remap_b473bb8bd2254a3faad5291ff8cb7707_Out_3_Float, _Absolute_2367964a3dae475891ccd6c90e2885ff_Out_1_Float);
            float _Smoothstep_516feede7acb4f97b595cd89bba389c4_Out_3_Float;
            Unity_Smoothstep_float(_Property_f05727b79c2d491a8b9c2d8417d4ce68_Out_0_Float, _Property_7d43401174f8413091e457476f00d1aa_Out_0_Float, _Absolute_2367964a3dae475891ccd6c90e2885ff_Out_1_Float, _Smoothstep_516feede7acb4f97b595cd89bba389c4_Out_3_Float);
            float _Property_44e53f25d86f4edbaab4f19b6daaa067_Out_0_Float = _Base_Speed;
            float _Multiply_619aff87dcc446c5968bd1a6d44fe8b7_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_44e53f25d86f4edbaab4f19b6daaa067_Out_0_Float, _Multiply_619aff87dcc446c5968bd1a6d44fe8b7_Out_2_Float);
            float2 _TilingAndOffset_7cbf9da6c23b409fb98e46b72acb3373_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_a415e5a75c24452bbcd60ac1b3811fc6_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_619aff87dcc446c5968bd1a6d44fe8b7_Out_2_Float.xx), _TilingAndOffset_7cbf9da6c23b409fb98e46b72acb3373_Out_3_Vector2);
            float _Property_9254f8e15d6447988ec18cd37fe88bdc_Out_0_Float = _Base_Scale;
            float _GradientNoise_ce38dcc651b44efeb82145bfdadbf1fa_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_7cbf9da6c23b409fb98e46b72acb3373_Out_3_Vector2, _Property_9254f8e15d6447988ec18cd37fe88bdc_Out_0_Float, _GradientNoise_ce38dcc651b44efeb82145bfdadbf1fa_Out_2_Float);
            float _Property_56d73ff99ec94119881f3d643422251a_Out_0_Float = _Base_Strength;
            float _Multiply_a28097e44d4c485a867948d5b27a71aa_Out_2_Float;
            Unity_Multiply_float_float(_GradientNoise_ce38dcc651b44efeb82145bfdadbf1fa_Out_2_Float, _Property_56d73ff99ec94119881f3d643422251a_Out_0_Float, _Multiply_a28097e44d4c485a867948d5b27a71aa_Out_2_Float);
            float _Add_c6fbda241fda4ff68e2e16893549192e_Out_2_Float;
            Unity_Add_float(_Smoothstep_516feede7acb4f97b595cd89bba389c4_Out_3_Float, _Multiply_a28097e44d4c485a867948d5b27a71aa_Out_2_Float, _Add_c6fbda241fda4ff68e2e16893549192e_Out_2_Float);
            float _Add_5d9343a646914b1582c5ac00b2068a54_Out_2_Float;
            Unity_Add_float(float(0), _Property_56d73ff99ec94119881f3d643422251a_Out_0_Float, _Add_5d9343a646914b1582c5ac00b2068a54_Out_2_Float);
            float _Divide_fe411acd94ed4c4c83892bba30255329_Out_2_Float;
            Unity_Divide_float(_Add_c6fbda241fda4ff68e2e16893549192e_Out_2_Float, _Add_5d9343a646914b1582c5ac00b2068a54_Out_2_Float, _Divide_fe411acd94ed4c4c83892bba30255329_Out_2_Float);
            float4 _Lerp_aaaae5c0660549cda8a2edb7a84e8dbb_Out_3_Vector4;
            Unity_Lerp_float4(_Property_08f55cc2215f457abdf288e58daaa696_Out_0_Vector4, _Property_acbafd3dca104c65b7b71611d4639044_Out_0_Vector4, (_Divide_fe411acd94ed4c4c83892bba30255329_Out_2_Float.xxxx), _Lerp_aaaae5c0660549cda8a2edb7a84e8dbb_Out_3_Vector4);
            float _SceneDepth_7a3cc358e0f44107b8bce7383895b953_Out_1_Float;
            Unity_SceneDepth_Eye_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_7a3cc358e0f44107b8bce7383895b953_Out_1_Float);
            float4 _ScreenPosition_344727010a4a40389b6dd34b4b9b2ac3_Out_0_Vector4 = IN.ScreenPosition;
            float _Split_acb0902b83d148e2a31506c594db0146_R_1_Float = _ScreenPosition_344727010a4a40389b6dd34b4b9b2ac3_Out_0_Vector4[0];
            float _Split_acb0902b83d148e2a31506c594db0146_G_2_Float = _ScreenPosition_344727010a4a40389b6dd34b4b9b2ac3_Out_0_Vector4[1];
            float _Split_acb0902b83d148e2a31506c594db0146_B_3_Float = _ScreenPosition_344727010a4a40389b6dd34b4b9b2ac3_Out_0_Vector4[2];
            float _Split_acb0902b83d148e2a31506c594db0146_A_4_Float = _ScreenPosition_344727010a4a40389b6dd34b4b9b2ac3_Out_0_Vector4[3];
            float _Subtract_3db7c3ced20d44b3a55e93b8d56c3fc1_Out_2_Float;
            Unity_Subtract_float(_Split_acb0902b83d148e2a31506c594db0146_A_4_Float, float(1), _Subtract_3db7c3ced20d44b3a55e93b8d56c3fc1_Out_2_Float);
            float _Subtract_0b683ae745b74caaa4830cb31795132a_Out_2_Float;
            Unity_Subtract_float(_SceneDepth_7a3cc358e0f44107b8bce7383895b953_Out_1_Float, _Subtract_3db7c3ced20d44b3a55e93b8d56c3fc1_Out_2_Float, _Subtract_0b683ae745b74caaa4830cb31795132a_Out_2_Float);
            float _Property_13ffae534f05496e8446dd4eff4d54b3_Out_0_Float = _Fade_Depth;
            float _Divide_5ea1c32f7a9541ce96555bb9c53dad4e_Out_2_Float;
            Unity_Divide_float(_Subtract_0b683ae745b74caaa4830cb31795132a_Out_2_Float, _Property_13ffae534f05496e8446dd4eff4d54b3_Out_0_Float, _Divide_5ea1c32f7a9541ce96555bb9c53dad4e_Out_2_Float);
            float _Saturate_11cb953c9f3a4ad98649c8032095e0a5_Out_1_Float;
            Unity_Saturate_float(_Divide_5ea1c32f7a9541ce96555bb9c53dad4e_Out_2_Float, _Saturate_11cb953c9f3a4ad98649c8032095e0a5_Out_1_Float);
            float _Smoothstep_804d457501334adcb743390e55365a80_Out_3_Float;
            Unity_Smoothstep_float(float(0), float(1), _Saturate_11cb953c9f3a4ad98649c8032095e0a5_Out_1_Float, _Smoothstep_804d457501334adcb743390e55365a80_Out_3_Float);
            surface.BaseColor = (_Lerp_aaaae5c0660549cda8a2edb7a84e8dbb_Out_3_Vector4.xyz);
            surface.Alpha = _Smoothstep_804d457501334adcb743390e55365a80_Out_3_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.WorldSpaceNormal =                           TransformObjectToWorldNormal(input.normalOS);
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.WorldSpacePosition =                         TransformObjectToWorld(input.positionOS);
            output.TimeParameters =                             _TimeParameters.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBR2DPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
    }
    CustomEditor "UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI"
    CustomEditorForRenderPipeline "UnityEditor.ShaderGraphLitGUI" "UnityEngine.Rendering.Universal.UniversalRenderPipelineAsset"
    FallBack "Hidden/Shader Graph/FallbackError"
}