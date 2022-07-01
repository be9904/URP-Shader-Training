// Shader 시작. 셰이더의 폴더와 이름을 여기서 결정합니다.
Shader "Training02"
{
	Properties
	{
		// Properties Block : 셰이더에서 사용할 변수를 선언하고 이를 material inspector에 노출시킵니다
		_TintColor("Color", Color) = (1,1,1,1)
		_Intensity("Intensity", Range(0,10)) = 0
		_MainTex("RGB", 2D) = "white" {}
		// _AlphaCut("AlphaCut", Range(0,1)) = 0.5
		
		[Enum(UnityEngine.Rendering.BlendMode)] _SrcBlend ("Src Blend", Float) = 1
		[Enum(UnityEngine.Rendering.BlendMode)] _DstBlend ("Dst Blend", Float) = 0
		[Enum(UnityEngine.Rendering.CullMode)] _CullMode("Cull Mode", Float) = 2
		[Enum(Off, 0, On, 1)] _ZWrite ("ZWrite", Float) = 0
		[Enum(UnityEngine.Rendering.CompareFunction)] _ZTest("ZTest", Float) = 0
	}
	SubShader
	{
		Tags
		{
			//Render type과 Render Queue를 여기서 결정합니다.
			"RenderPipeline"="UniversalPipeline"
			"RenderType"="Transparent"
			"Queue"="Transparent"
		}
		Pass
		{
			Name "Universal Forward"
			Tags { "LightMode" = "UniversalForward" }
			Blend [_SrcBlend] [_DstBlend]		// 계산된 컬러, 이미 표시된 컬러
			Cull [_CullMode]
			ZWrite [_ZWrite]
			ZTest [_ZTest]
			
			
			HLSLPROGRAM
			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x
			#pragma vertex vert
			#pragma fragment frag
			
			//cg shader는 .cginc를 hlsl shader는 .hlsl을 include하게 됩니다.
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

			half4 _TintColor;
			half _Intensity;

			// Texture, Sampler 분리
			Texture2D _MainTex;
			Texture2D _MainTex02;
			SamplerState sampler_MainTex;

			float4 _MainTex_ST;
			
			//vertex buffer에서 읽어올 정보를 선언합니다.
			struct MeshData
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			//보간기를 통해 버텍스 셰이더에서 픽셀 셰이더로 전달할 정보를 선언합니다.
			struct Interpolator
			{
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
			};

			//버텍스 셰이더
			Interpolator vert(MeshData v)
			{
				Interpolator o;
				o.vertex = TransformObjectToHClip(v.vertex.xyz);
				o.uv = v.uv * _MainTex_ST.xy + _MainTex_ST.zw; // Scale, Tiling을 버텍스 셰이더에서 계산
				return o;
			}
			
			//픽셀 셰이더
			half4 frag(Interpolator i) : SV_Target
			{
				// half4 color = tex2D(_MainTex, i.uv) * _TintColor * _Intensity;
				half4 tex01 = _MainTex.Sample(sampler_MainTex, i.uv) * _TintColor * _Intensity;
				// half4 col02 = _MainTex02.Sample(sampler_MainTex, i.uv) * _TintColor * _Intensity;

				half4 color = tex01.rgba;
				
				color.rgb *= _TintColor;

				color.a *= _Intensity;
				// clip(color.a - _AlphaCut); // 0보다 작은 픽셀 날려버림 -> 반투명이 아니라 픽셀을 아예 지워버림
				
				return color;
			}
			
			ENDHLSL
		}
	}
}