float2 uv = _geometry.texcoords[0];

uv -= .5;
float l = length(uv);
uv *= smoothstep(0.0, 0.5, l);
uv += .5;

_geometry.texcoords[0] = uv;
