#version 330

layout (location = 0) in vec3 position;

uniform mat4 transformProjected;

void main()
{
    gl_Position = transformProjected * vec4(position, 1.0);
}