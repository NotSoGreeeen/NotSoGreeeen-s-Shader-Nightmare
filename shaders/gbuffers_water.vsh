#version 460

in vec3 vaPosition; // Vetex position
in vec2 vaUV0; // Texture coordinates
in vec4 vaColor; // Vertex color
in ivec2 vaUV2; // Lightmap coordinates (vanilla space)
in vec3 vaNormal;

uniform vec3 chunkOffset; // Chunk Offset
uniform mat4 modelViewMatrix; // Model View Matrix
uniform mat4 modelViewMatrixInverse;
uniform mat4 projectionMatrix; // Projection Matrix
uniform vec3 cameraPosition; // Camera Position
uniform mat4 gbufferModelViewInverse; // Model View Matris (inverse)
uniform vec3 sunPosition;

uniform int frameCounter; // Count up once per frame

out vec2 texCoord; // Texture coords
out vec4 glcolor; // Color
out vec2 lmCoord; // Lightmap coords
out vec3 normal;
out vec3 sun;
out vec3 pos;

attribute vec4 mc_Entity; // some form of block id lookup(?)

void main() {
    int mat = int(mc_Entity.x); // Get the block ID

    float speed = .01, power;
    texCoord = vaUV0;
    glcolor = vaColor;
    lmCoord = vaUV2 * (1.0 / 256.0) + (1.0 / 32.0);

    vec4 worldSpacePosition = vec4(vaPosition + chunkOffset, 1); // Calculate ModelPos

    if (mat == 32000) { // If water
        power = clamp(lmCoord.y - 0.84, 0.0, 0.01);
        float waveHeight = sin(worldSpacePosition.x + frameCounter * speed) +
                           sin(2.0 * worldSpacePosition.x + frameCounter * speed) +
                           sin(0.1 * worldSpacePosition.x + frameCounter * speed) +
                           sin(0.3 * worldSpacePosition.z + frameCounter * speed) +
                           sin(2.1 * worldSpacePosition.z + frameCounter * speed) +
                           sin(0.67 * worldSpacePosition.z + frameCounter * speed);
        waveHeight *= power;
        waveHeight = clamp(waveHeight, -10.0, 0.0);
        worldSpacePosition.y += waveHeight;

        pos = (projectionMatrix * vec4(vaPosition, 1.)).xyz;
        normal = vec4(projectionMatrix * vec4(vaNormal, 1.)).xyz;
        sun = vec4(gbufferModelViewInverse * vec4(sunPosition, 1.)).xyz;
    }

    gl_Position = projectionMatrix * modelViewMatrix * worldSpacePosition; // Calculate WorldPos (with offset if water)
}