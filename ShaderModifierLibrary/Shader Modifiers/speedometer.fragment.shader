float sdCircle(float2 p, float r) {
    return length(p) - r;
}

#pragma arguments
float2 quadScale;

#pragma body
float ratio = quadScale.y / quadScale.x;
float2 uv = _surface.diffuseTexcoord;
uv.y *= ratio;

float2 center = float2(0.5);
float2 uvCentered = uv - center;
float outerCircle = sdCircle(uvCentered, 0.45);
outerCircle = 1.0 - smoothstep(0.015, 0.016, outerCircle);
float innerCircle = sdCircle(uvCentered, 0.35);
innerCircle = 1.0 - smoothstep(0.015, 0.016, innerCircle);

float angle = (atan2(uvCentered.y, uvCentered.x) + M_PI_F) / (2.0 * M_PI_F);
float circleMasked = outerCircle - innerCircle;
float background = circleMasked * step(angle, 0.5);
float p = fmod(scn_frame.time * 0.1, 0.5);
float progress = circleMasked * step(angle, p);

float dial = outerCircle * step(angle, p + 0.005) * (1.0 - step(angle, p - 0.005));

float divisionLine = outerCircle * step(fmod(angle * 40.0, 1.0), 0.1);

float3 bgColor = float3(0.7, 0.7, 0.7) * background;
float3 progressColor = float3(1.0, 0.0, 0.0);
float3 dialColor = float3(0.8, 0.0, 1.0);

background *= 1.0 - divisionLine;
progress *= 1.0 - divisionLine;

float3 color = bgColor * background;
color = mix(color, progressColor, progress);
color = mix(color, dialColor, dial);
_output.color.rgb = color;
