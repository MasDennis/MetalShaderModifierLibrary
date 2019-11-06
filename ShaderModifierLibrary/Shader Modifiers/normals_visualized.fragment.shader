#pragma body

// convert normal from view space to model space
float4 localNormal = scn_node.inverseModelViewTransform * float4(_surface.normal.xyz, 0.0);
_output.color = float4(normalize(localNormal.xyz), 1.0);
