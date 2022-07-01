Shader "Training03-1"
{
	Properties {
		_TintColor("Test Color", color) = (1, 1, 1, 1)
		_Intensity("Range Sample", Range(0, 1)) = 0.5
		_MainTex("Main Texture", 2D) = "white" {}
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