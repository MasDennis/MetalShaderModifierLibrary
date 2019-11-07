#pragma varyings
float3 vposition;
float3 cameraPosition;

#pragma body
out.vposition = (scn_node.modelTransform * _geometry.position).xyz;
out.cameraPosition = (scn_node.inverseModelViewTransform * float4(0, 0, 0, 1)).xyz;
