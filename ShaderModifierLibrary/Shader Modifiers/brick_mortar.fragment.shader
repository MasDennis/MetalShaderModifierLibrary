
float mod(float x, float y) {
    return x - y * floor(x/y);
}

#pragma arguments

float2 quadScale;

#pragma body
float4 brickColor = float4(0.37, 0.1, 0.08, 1.0);
float4 mortarColor = float4(0.56, 0.51, 0.42, 1.0);
float2 brickSize = float2(0.2, 0.05);
float mortarSize = 0.01;
float ratio = quadScale.y / quadScale.x;

float2 uv = _surface.diffuseTexcoord;
uv.y *= ratio;

float x = mod(uv.x, brickSize.x + mortarSize);
float y = mod(uv.y, brickSize.y + mortarSize);
float2 brick = float2(step(x, brickSize.x), step(y, brickSize.y));

_output.color = mix(mortarColor, brickColor, brick.x * brick.y);
