half4 _TintColor;
float _Intensity;
float4 _MainTex_ST;
Texture2D _MainTex;
SamplerState sampler_MainTex;

struct VertexInput
{
    float4 vertex : POSITION;
    float2 uv : TEXCOORD0;
};

struct VertexOutput
{
    float4 vertex : SV_POSITION;
    float2 uv : TEXCOORD0;
};

VertexOutput vert(VertexInput v)
{ VertexOutput o;
    o.vertex = TransformObjectToHClip(v.vertex.xyz);
    o.uv = v.uv.xy * _MainTex_ST.xy + _MainTex_ST.zw;
    o.uv.x += _Time.x * 3;
    return o;
}

half4 frag(VertexOutput i) : SV_Target
{
    float4 color = _MainTex.Sample(sampler_MainTex, i.uv);
    color.rgb *= _TintColor * _Intensity;
    return color;
}