struct VertexInput
{
    float4 vertex : POSITION;
    float3 normal : NORMAL;
};

struct VertexOutput
{
    float4 vertex : SV_POSITION;
    float3 normal : NORMAL;
    // float3 color : COLOR;
};

VertexOutput vert(VertexInput v)
{
    VertexOutput o;
    o.vertex = TransformObjectToHClip(v.vertex.xyz);
    o.normal = TransformObjectToWorldNormal(v.normal); // normal을 월드공간으로 변환
    
    // o.color = TransformObjectToWorld(v.vertex.xyz);
    // float4 positionWS = TransformObjectToHClip(v.vertex.xyz);
    // o.vertex = positionWS + float4(sin(o.color + _Time.y), 1);

    return o;
}

half4 frag(VertexOutput i) : SV_Target
{
    float3 light = _MainLightPosition.xyz;
    float4 color = float4(1,1,1,1);
    // color *= float4(i.color, 1);

    // standard
    float ndot = saturate(dot(i.normal, light));
    color.rgb *= ndot * _MainLightColor.rgb;
    
    // cel shading
    // float cdot = saturate(dot(i.normal, light)) > 0.01 ? 1 : 0;
    // color.rgb *= cdot * _MainLightColor.rgb;
    return color;
}