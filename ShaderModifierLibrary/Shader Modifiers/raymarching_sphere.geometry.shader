#pragma varyings
float3 worldPosition;

#pragma body
out.worldPosition = (scn_node.modelTransform * _geometry.position).xyz;
//out.worldPosition = _geometry.position.xyz;
