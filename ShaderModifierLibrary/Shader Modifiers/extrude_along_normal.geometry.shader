float4 normal = float4(normalize(_geometry.normal.xyz), 0.0);
float4 position = _geometry.position;
float4 extrusion = normal * (0.5 + scn_frame.sinTime / 2.0) * 0.2;
position += extrusion;
_geometry.position = position;
