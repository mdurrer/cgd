#version 330

layout (location = 0) in vec3 position;
layout (location = 1) in vec2 texCoord;
layout (location = 2) in vec3 normal;
layout (location = 3) in vec3 tangent;

//out vec4 lightSpacePos0;
out vec4 shadowCoord0;
out vec4 shadowCoord1;
out vec4 shadowCoord2;
out vec4 shadowCoord3;
out vec2 texCoord0;
out vec3 normal0;
out vec3 worldPos0;
out mat3 tbnMatrix;

uniform mat4 transform;
uniform mat4 lightTransform0;
uniform mat4 lightTransform1;
uniform mat4 lightTransform2;
uniform mat4 lightTransform3;
uniform mat4 transformProjected;

void main()
{
    gl_Position = transformProjected * vec4(position, 1.0);
    texCoord0 = texCoord;
    normal0 = (transform * vec4(normal, 0.0)).xyz;
    worldPos0 = (transform * vec4(position, 1.0)).xyz;
    //lightSpacePos0 = lightTransform * vec4(position, 1.0);
    shadowCoord0 = lightTransform0 * vec4(position, 1.0);
    shadowCoord1 = lightTransform1 * vec4(position, 1.0);
    shadowCoord2 = lightTransform2 * vec4(position, 1.0);
    shadowCoord3 = lightTransform3 * vec4(position, 1.0);
    
    vec3 tangent0 = (transform * vec4(tangent, 0.0)).xyz;
    vec3 n = normalize(normal0);
    
    vec3 t = normalize(tangent0);
    t = normalize(t - dot(t, n) * n);
    
    vec3 bitangent = cross(t, n);
    
    tbnMatrix = mat3(t, bitangent, n);
}