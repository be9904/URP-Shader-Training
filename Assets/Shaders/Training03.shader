// Shader 시작. 셰이더의 폴더와 이름을 여기서 결정합니다.
Shader "Training03"
{
	Properties
	{
		// Properties Block : 셰이더에서 사용할 변수를 선언하고 이를 material inspector에 노출시킵니다
		// _TintColor("Color", Color) = (1,1,1,1)
		// _Intensity("Intensity", Range(0,10)) = 0
		_MainTex("RGB 01", 2D) = "white" {}
		_MainTex02("RGB 02", 2D) = "white" {}

		_MaskTex("Mask Texture", 2D) = "white" {}
		// _AlphaCut("AlphaCut", Range(0,1)) = 0.5
		
		// [Enum(UnityEngine.Rendering.BlendMode)] _SrcBlend ("Src Blend", Float) = 1
		// [Enum(UnityEngine.Rendering.BlendMode)] _DstBlend ("Dst Blend", Float) = 0
		// [Enum(UnityEngine.Rendering.CullMode)] _CullMode("Cull Mode", Float) = 2
		// [Enum(Off, 0, On, 1)] _ZWrite ("ZWrite", Float) = 0
		// [Enum(UnityEngine.Rendering.CompareFunction)] _ZTest("ZTest", Float) = 0
	}
	SubShader
	{
		Tags
		{
			//Render type과 Render Queue를 여기서 결정합니다.
			"RenderPipeline"="UniversalPipeline"
			"RenderType"="Opaque"
			"Queue"="Geometry"
		}
		Pass
		{
			Name "Universal Forward"
			Tags { "LightMode" = "UniversalForward" }
			// Blend [_SrcBlend] [_DstBlend]		// 계산된 컬러, 이미 표시된 컬러
			// Cull [_CullMode]
			// ZWrite [_ZWrite]
			// ZTest [_ZTest]
			
			
			HLSLPROGRAM
			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x
			#pragma vertex vert
			#pragma fragment frag
			
			//cg shader는 .cginc를 hlsl shader는 .hlsl을 include하게 됩니다.
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

			#include "Training03.hlsl"

			ENDHLSL
		}
	}
}