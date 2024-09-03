#version 460

in vec3 vaPosition; // Vetex position
in vec2 vaUV0;
in vec4 vaColor;
in ivec2 vaUV2;
in vec3 vaNormal;

uniform vec3 chunkOffset; // Chunk Offset
uniform mat4 modelViewMatrix; // Model View Matrix
uniform mat4 projectionMatrix; // Projection Matrix
uniform vec3 cameraPosition; // Camera Position
uniform mat4 gbufferModelViewInverse;
uniform mat4 modelViewMatrixInverse;
uniform vec3 sunPosition;
uniform vec3 moonPosition;

uniform int frameCounter;

out vec2 texCoord;
out vec4 foliageColor;
out vec2 lightMapCoords;
out vec3 normal;
out vec3 sun;
out vec3 moon;
out vec3 pos;
out vec4 tag;

attribute vec4 mc_Entity; // some form of block id lookup(?)

void main() {
    float speed, power;
    speed = .001;
    power = .12;
    texCoord = vaUV0;
    foliageColor = vaColor;
    lightMapCoords = vaUV2 * (1. / 256.) + (1. / 32.);

    vec3 worldSpacePosition = cameraPosition + (gbufferModelViewInverse * modelViewMatrix * vec4(vaPosition + chunkOffset, 1)).xyz;

    float distanceFromCamera = distance(worldSpacePosition, cameraPosition);

    vec3 trip = vec3(sin(frameCounter * speed) * power, ((sin(worldSpacePosition.x * sin(frameCounter * speed) + 200) + 2) * power) + (sin(worldSpacePosition.z * sin(frameCounter * speed) + 100) * power), sin(frameCounter * speed) * power);

    gl_Position = projectionMatrix * modelViewMatrix * vec4(vaPosition + chunkOffset, 1);
    pos = (projectionMatrix * vec4(vaPosition, 1.)).xyz;
    normal = vec4(projectionMatrix * vec4(vaNormal, 1.)).xyz;
    sun = vec4(gbufferModelViewInverse * vec4(sunPosition, 1.)).xyz;
    moon = vec4(gbufferModelViewInverse * vec4(moonPosition, 1.)).xyz;
    tag = mc_Entity;
}


//vec3 worldSpacePosition = cameraPosition + (gbufferModelViewInverse * modelViewMatrix * vec4(vaPosition + chunkOffset, 1)).xyz;

//float distanceFromCamera = distance(worldSpacePosition, cameraPosition);