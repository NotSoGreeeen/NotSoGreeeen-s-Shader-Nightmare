#version 460

uniform sampler2D gtexture;
uniform sampler2D lightmap;
uniform vec3 eyePosition;

/* DRAWBUFFERS:0*/
layout(location = 0) out vec4 fragColor;

in vec2 texCoord;
in vec4 glcolor;
in vec2 lmCoord;
in vec3 normal;
in vec3 sun;
in vec3 pos;

void main() {
    vec4 lightColor = pow(texture(lightmap, lmCoord), vec4(2.2));
    vec3 ambient = (.1 * lightColor).xyz;
    vec3 diffuse = (dot(sun, normalize(normal)) * lightColor).xyz;

    vec4 color = pow(texture(gtexture, texCoord) * glcolor * vec4(pow(lightColor.rgb, vec3(3)) * clamp(diffuse, .2, 1.) + (lightColor.rgb * .4) + ambient, lightColor.a), vec4(2.2));

    if (color.a < .1) {
        discard;
    }

    fragColor = pow(color, vec4(1/2.2));
}