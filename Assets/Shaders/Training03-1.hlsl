half4 _TintColor;
float _Intensity;
float _FlowIntensity, _FlowTime;
float4 _MainTex_ST;
Texture2D _MainTex;
sampler2D _Flowmap;
SamplerState sampler_MainTex;

struct VertexInput
{
    float4 vertex : POSITION;
    float3 normal : NORMAL;
    float2 uv : TEXCOORD0;
};

struct VertexOutput
{
    float4 vertex : SV_POSITION;
    float3 normal : NORMAL;
    float2 uv : TEXCOORD0;
};

VertexOutput vert(VertexInput v)
{
    VertexOutput o;
    o.vertex = TransformObjectToHClip(v.vertex.xyz);

    o.normal = TransformObjectToWorldNormal(v.normal);

    o.uv = v.uv.xy * _MainTex_ST.xy + _MainTex_ST.zw;
    
    half4 noise = tex2Dlod(_Flowmap, float4(o.uv, 0, 0));
    
    half3 positionWS = TransformObjectToWorld(v.vertex.xyz);
    
    o.vertex.y += sin((v.vertex.x + v.vertex.z + _Time.y) * _FlowTime) * noise.r * _FlowIntensity;
    
    return o;
}

half4 frag(VertexOutput i) : SV_Target
{
    // float4 flow = _Flowmap.Sample(sampler_MainTex, i.uv);
    // i.uv += frac(_Time.x * _FlowTime) + flow.rg * _FlowIntensity; // UV의 스케일을 조절하는 것
    float4 color = _MainTex.Sample(sampler_MainTex, i.uv);
    color.rgb *= _TintColor * _Intensity;
    return color;
}