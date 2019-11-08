#pragma arguments

texture2d<float, access::sample> texture1;
texture2d<float, access::sample> texture2;

#pragma body
constexpr sampler smp(filter::linear, address::repeat);

float4 color1 = texture1.sample(smp, _surface.diffuseTexcoord);
float4 color2 = texture2.sample(smp, _surface.diffuseTexcoord);

float mixValue = 0.5 + scn_frame.sinTime * 0.5;

_output.color = mix(color1, color2, mixValue);
