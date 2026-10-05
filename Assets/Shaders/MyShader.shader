Shader "Custom/MyShader"
{
    Properties
    {
        _MainTexture("Main Texture", 2D) = "white" {}
        _Color("Test Color", color) = (1,1,1,1)
        _AnimateXY("Animate XY", Vector) = (0,0,0,0)
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 100
        
        Pass
        {
            CGPROGRAM
            #pragma vertex vert     //Vertex Shader
            #pragma fragment frag   //Fragment Shader

            #include "UnityCG.cginc"

            struct appdata //Object data
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };   
            
            struct v2f      //Vertex to Fragment
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };
            
            fixed4 _Color; //have to put the variable here as well.
            sampler2D _MainTexture;
            float4 _MainTexture_ST;
            float4 _AnimateXY;
            
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex); //Moving vertex data to Unity projection
                o.uv = TRANSFORM_TEX(v.uv, _MainTexture);
                o.uv += frac(_AnimateXY.xy * _Time.yy);
                return o;
            }
            
            fixed4 frag (v2f i) : SV_Target
            {
                //fixed4 col = _Color;
                float2 uvs = i.uv;
                fixed4 textureColor = tex2D(_MainTexture, uvs);
                fixed col = fixed4(i.uv, 0, 1);
                return textureColor;
            }
            ENDCG
        }
    }
}
