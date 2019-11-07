constant int steps = 64;
constant float minDistance = 0.001;

// https://www.iquilezles.org/www/articles/distfunctions/distfunctions.htm
float sdTorus(float3 p, float2 t)
{
  float2 q = float2(length(p.xz) - t.x, p.y);
  return length(q) - t.y;
}

float4 raymarch(float3 position, float3 direction) {
    float currentDistance = 0;

    for(int i=0; i<steps; i++) {
        float3 currentPosition = position + direction * currentDistance;
        float distance = sdTorus(currentPosition, float2(0.4, 0.1));
        if(distance < minDistance) {
            // visualize the number of steps
            return i / (float)steps;
        }
        
        currentDistance += distance;
    }
    // using a color here to visualize the box, otherwise return 0.0
    return float4(0.029, 0.04, 0.05, 1.0);
}

#pragma transparent
#pragma arguments
float3 cameraPosition;

#pragma body

float3 viewDirection = normalize(in.vposition - in.cameraPosition);

_output.color = raymarch(in.vposition, viewDirection);


