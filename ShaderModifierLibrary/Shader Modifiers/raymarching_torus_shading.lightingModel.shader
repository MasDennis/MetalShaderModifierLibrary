constant int steps = 64;
constant float minDistance = 0.001;
constant float2 torusParams = float2(0.4, 0.1);

constant float epsilon = 0.01;
constant float3 xEpsilon = float3(epsilon, 0, 0);
constant float3 yEpsilon = float3(0, epsilon, 0);
constant float3 zEpsilon = float3(0, 0, epsilon);

// https://www.iquilezles.org/www/articles/distfunctions/distfunctions.htm
float sdTorus(float3 p)
{
  float2 q = float2(length(p.xz) - torusParams.x, p.y);
  return length(q) - torusParams.y;
}

float3 calculateNormal(float3 position) {
    return normalize(
        float3(
            sdTorus(position + xEpsilon) - sdTorus(position - xEpsilon),
            sdTorus(position + yEpsilon) - sdTorus(position - yEpsilon),
            sdTorus(position + zEpsilon) - sdTorus(position - zEpsilon)
        )
    );
}

float4 raymarch(float3 position, float3 direction, float3 lightDirection) {
    float currentDistance = 0;

    for(int i=0; i<steps; i++) {
        float3 currentPosition = position + direction * currentDistance;
        float distance = sdTorus(currentPosition);
        if(distance < minDistance) {
            float3 normal = calculateNormal(currentPosition);
            float NdotL = max(dot(normal, lightDirection), 0.0);
            return float4(float3(1.0, 0.0, 0.0) * NdotL, 1.0);
        }
        
        currentDistance += distance;
    }
    return 0.0;
}

#pragma transparent
#pragma arguments
float3 cameraPosition;

#pragma body

float3 viewDirection = normalize(in.vposition - in.cameraPosition);

_lightingContribution.diffuse = raymarch(in.vposition, viewDirection, _light.direction).rgb;
_lightingContribution.specular = float3(0);
_lightingContribution.ambient = float3(0);
