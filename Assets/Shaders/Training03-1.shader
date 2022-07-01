Shader "Training03-1"
{
	Properties {
		_TintColor("Test Color", color) = (1, 1, 1, 1)
		_Intensity("Range Sample", Range(0, 1)) = 0.5
		_MainTex("Main Texture", 2D) = "white" {}
		[NoScaleOffset] _Flowmap("Flowmap", 2D) = "white" {} // Inspector에서 tiling offset 보이지 않음
		_FlowIntensity("flow Intensity", Range(0,2)) = 1
		_FlowTime("flow time", Range(0,10)) = 1 
	}
	SubShader{
		Tags
		{
			"RenderPipeline"="UniversalPipeline"
			"RenderType"="Opaque"
			"Queue"="Geometry"
		}
		Pass
		{
			Name "Universal Forward"
			Tags {"LightMode" = "UniversalForward"}
			
			HLSLPROGRAM
			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x
			#pragma vertex vert
			#pragma fragment frag

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Training03-1.hlsl"
			
			ENDHLSL
		}
	}
}