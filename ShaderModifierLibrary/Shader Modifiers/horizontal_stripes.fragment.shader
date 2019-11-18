#pragma transparent
#pragma body

float3 bboxMin = scn_node.boundingBox[0];
float3 bboxMax = scn_node.boundingBox[1];
float3 bboxSize = bboxMax - bboxMin;
float stripeSize = 0.02;

float position = (in.position.y - bboxMin.y) / bboxSize.y;
float stripeAndGap = fmod(position, stripeSize * 2.0);
float stripe = step(stripeAndGap, stripeSize);

_output.color = float4(stripe, stripe, 0.0, 1.0);
