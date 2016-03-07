#version 120

attribute vec3 position;
attribute vec2 texCoord;

varying vec2 fs_TexCoord;

uniform mat4 X_MVP;
uniform sampler2D diffuse;

void VSmain()
{
	gl_Position = X_MVP * vec4(position, 1.0);
	fs_TexCoord = texCoord;
}

void FSmain()
{
	gl_FragColor = texture2D(diffuse, fs_TexCoord.xy);
}
