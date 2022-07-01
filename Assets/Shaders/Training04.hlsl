struct VertexInput
{
    float4 vertex : POSITION;
    float3 normal : NORMAL;
};

struct VertexOutput
{
    float4 vertex : SV_POSITION;
    float3 normal : NORMAL;
};

VertexOutput vert(VertexInput v)
{
    VertexOutput o;
    o.vertex = TransformObjectToHClip(v.vertex.xyz);
    o.normal = TransformObjectToWorldNormal(v.normal);
    return o;
}

half4 frag(VertexOutput i) : SV_Target
{
    float3 light = _MainLightPosition.xyz;
    float4 color = float4(1,1,1,1);
    color.rgb *= saturate(dot(i.normal, light)) * _MainLightColor.rgb;
    return color;
}