#version 460

uniform sampler2D gtexture;
uniform sampler2D lightmap;
uniform sampler2D depthtex1;
uniform vec3 eyePosition;
uniform float sunAngle;
uniform float near, far;

/* DRAWBUFFERS:0*/
layout(location = 0) out vec4 fragColor;

in vec2 texCoord;
in vec4 foliageColor;
in vec2 lightMapCoords;
in vec3 normal;
in vec3 sun;
in vec3 moon;
in vec3 pos;
in vec4 tag;


void main() {
    float ambientStr = 0.1;
    vec2 diffuseLims = vec2(0.1, .7);

    //base light
    vec4 lightColor = texture(lightmap, lightMapCoords);
    //Ambient Lighting
    vec3 ambient = vec3(lightColor * .4);
    
    //Diffuse Lighting
    vec3 sunDiffuse = vec4(dot(sun, normalize(normal))).xyz;
    vec3 moonDiffuse = vec4(dot(moon, normalize(normal))).xyz * .007;
    vec3 diffuse;
    diffuse += clamp(sunDiffuse  * clamp(sin(2. * 3.141592653 * sunAngle + .15) * 3., 0, 1), 0, 1);
    diffuse += clamp(moonDiffuse * clamp(cos(2. * 3.141592653 * sunAngle + 1.7) * 3., 0, 1), 0, 1);

    vec4 lightModel = vec4(clamp(ambient + diffuse, 0, 1.2), 1.);

    vec4 color = texture(gtexture, texCoord) * foliageColor * lightModel;

    if (color.a < .1) {
        discard;
    }

    fragColor = color;
}