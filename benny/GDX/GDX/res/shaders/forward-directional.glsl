#version 330
#include "lighting.glh"

attribute vec3 position;
attribute vec2 texCoord;
attribute vec3 normal;

varying vec2 texCoord0;
varying vec3 normal0;
varying vec3 worldPos0;

uniform mat4 MVP;
uniform mat4 transform;
uniform vec3 eyePos;
uniform sampler2D diffuse;

uniform float specularIntensity;
uniform float specularPower;

uniform DirectionalLight directionalLight;

void VSmain()
{
	gl_Position = MVP * vec4(position, 1.0);
	texCoord0 = texCoord;
	normal0 = (transform * vec4(normal, 0.0)).xyz;
	worldPos0 = (transform * vec4(position, 1.0)).xyz;
}

void FSmain()
{
	gl_FragColor = texture(diffuse, texCoord0.xy) 
		* CalcDirectionalLight(directionalLight, normalize(normal0), normalize(eyePos - worldPos0), specularIntensity, specularPower);
}
