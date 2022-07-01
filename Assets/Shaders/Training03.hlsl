half4 _TintColor;
half _Intensity;

// Texture, Sampler 분리
Texture2D _MainTex, _MainTex02, _MaskTex;
float4 _MainTex_ST, _MainTex02_ST;

SamplerState sampler_MainTex, sampler_MainTex02;

//vertex buffer에서 읽어올 정보를 선언합니다.
struct MeshData
{
    float4 vertex : POSITION;
    float2 uv1 : TEXCOORD0;
    float3 color : COLOR;
};

//보간기를 통해 버텍스 셰이더에서 픽셀 셰이더로 전달할 정보를 선언합니다.
struct Interpolator
{
    float4 vertex : SV_POSITION;
    float2 uv1 : TEXCOORD0;
    float2 uv2 : TEXCOORD1;
    float3 color : COLOR;
};

//버텍스 셰이더
Interpolator vert(MeshData v)
{
    Interpolator o;
    o.vertex = TransformObjectToHClip(v.vertex.xyz);
    // o.uv = v.uv * _MainTex_ST.xy + _MainTex_ST.zw; // Scale, Tiling을 버텍스 셰이더에서 계산
    o.uv1 = v.uv1.xy;
    o.uv2 = v.uv1.xy;
    o.color = TransformObjectToWorld(v.vertex.xyz);

    return o;
}

//픽셀 셰이더
half4 frag(Interpolator i) : SV_Target
{
    float2 uv1 = i.uv1.xy * _MainTex_ST.xy + _MainTex_ST.zw;
    float2 uv2 = i.uv1.xy * _MainTex02_ST.xy + _MainTex02_ST.zw;

    float4 tex01 = _MainTex.Sample(sampler_MainTex, uv1);
    float4 tex02 = _MainTex02.Sample(sampler_MainTex, uv2);

    half4 mask = _MaskTex.Sample(sampler_MainTex, uv1);

    // float4 color = i.uv1.y > 0.5 ? pow(i.uv1.x, 2.2) : i.uv1.x;
    float4 color = lerp(tex01, tex02, i.color.r); 
    
    return color;
}