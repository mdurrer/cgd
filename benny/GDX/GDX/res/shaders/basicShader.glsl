#version 120

attribute vec3 position;
attribute vec2 texCoord;

varying vec2 texCoord0;

uniform mat4 MVP;
uniform sampler2D diffuse;

void VSmain()
{
	gl_Position = MVP * vec4(position, 1.0);
	texCoord0 = texCoord;
}

void FSmain()
{
	gl_FragColor = texture2D(diffuse, texCoord0.xy);
}
