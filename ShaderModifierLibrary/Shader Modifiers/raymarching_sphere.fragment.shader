constant int steps = 64;
constant float minDistance = 0.001;

float sphereDistance(float3 p, float3 center, float radius) {
    return distance(p, center) - radius;
}

float4 raymarch(float3 position, float3 direction) {
    float currentDistance = 0;

    for(int i=0; i<steps; i++) {
        float3 currentPosition = position + direction * currentDistance;
        float distance = sphereDistance(currentPosition, float3(0), 0.015);
        if(distance < minDistance) {
            return 1.0;
        }
        
        currentDistance += distance;
    }
    return 0.2;
}

#pragma transparent
#pragma arguments
float3 cameraPosition;

#pragma body

float3 viewDirection = normalize(in.worldPosition - cameraPosition);

_output.color = raymarch(cameraPosition, viewDirection);


