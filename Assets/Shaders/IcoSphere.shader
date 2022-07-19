Shader "Unlit/IcoSphere"
{
    Properties
    {
        _Amplitude ("Amplitude", Range(0,1)) = 0
        _Color("Color", Color) = (1,1,1,1)
        [Enum(UnityEngine.Rendering.BlendMode)] _SrcBlend ("Src Blend", Float) = 1
		[Enum(UnityEngine.Rendering.BlendMode)] _DstBlend ("Dst Blend", Float) = 0
		[Enum(UnityEngine.Rendering.CullMode)] _CullMode("Cull Mode", Float) = 2
        [Enum(Vertex, 0, Normal, 1)] _AnimationMode("Animation Mode", Float) = 0
    }
    SubShader
    {
        Tags { 
            "RenderType"="Transparent"
            "Queue" = "Transparent" 
        }
        LOD 100

        Pass
        {
            Name "Universal Forward"
            Tags {"LightMode" = "UniversalForward"}
            
            Blend [_SrcBlend] [_DstBlend]
            Cull [_CullMode]
            
            HLSLPROGRAM
            #pragma prefer_hlslcc gles
            #pragma exclude_renderers d3d11_9x
            #pragma vertex vert
            #pragma fragment frag
            
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            
            float _Amplitude;
            float4 _Color;
            float _AnimationMode;
            
            struct VertexInput
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float3 viewDir : TEXCOORD0;
            };
            
            struct VertexOutput
            {
                float4 vertex : SV_POSITION;
                float3 normal: NORMAL;
                float3 viewDir : TEXCOORD0;
            };
            
            VertexOutput vert(VertexInput v)
            {
                VertexOutput o;
                _Amplitude = (sin(v.vertex.z * _Time.z * 2000) + 1);
                if(_AnimationMode == 0)
                    o.vertex = TransformObjectToHClip(float4(v.vertex.xyz + normalize(v.vertex) * _Amplitude * 0.2, 1));
                else
                    o.vertex = TransformObjectToHClip(float4(v.vertex.xyz - v.normal * _Amplitude * 0.002, 1));
                o.normal = v.normal;
                o.viewDir = normalize(_WorldSpaceCameraPos.xyz - mul(unity_ObjectToWorld, v.vertex).xyz);
                
                return o;
            }
            
            half4 frag(VertexOutput i) : SV_Target
            {
                float NdotL = 1 - saturate(dot(i.viewDir, i.normal));
                return NdotL * _Color;
            }
            
            ENDHLSL
        }
    }
}
