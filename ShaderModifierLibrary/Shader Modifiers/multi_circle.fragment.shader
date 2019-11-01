float circle(float2 uv, float radius, float2 center, float edgeSmoothing) {
    float dist = distance(uv, center);
    return 1.0 - smoothstep(radius - radius * edgeSmoothing,
                            radius + radius * edgeSmoothing,
                            dist);
}

float mod(float x, float y) {
    return x - y * floor(x/y);
}

#pragma arguments

float2 quadScale;

#pragma body

float ratio = quadScale.y / quadScale.x;
float2 uv = _surface.diffuseTexcoord;
uv.y *= ratio;

float numRepeats = 10.0;

uv.x = mod(uv.x * numRepeats, 1.0);
uv.y = mod(uv.y * numRepeats, 1.0);

float2 center = float2(0.5, 0.5);

float c = circle(uv, 0.4, center, 0.01);

_output.color = float4(c, 0, 0, 1.0);
