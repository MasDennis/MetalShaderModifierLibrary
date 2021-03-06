float circle(float2 uv, float radius, float2 center, float edgeSmoothing) {
    float dist = distance(uv, center);
    return 1.0 - smoothstep(radius - radius * edgeSmoothing,
                            radius + radius * edgeSmoothing,
                            dist);
}

#pragma arguments

float2 quadScale;

#pragma body

float ratio = quadScale.y / quadScale.x;
float2 uv = _surface.diffuseTexcoord;
uv.y *= ratio;
float c = circle(uv, 0.4, float2(0.5, 0.5 * ratio), 0.01);
_output.color = float4(c, 0, 0, 1.0);
