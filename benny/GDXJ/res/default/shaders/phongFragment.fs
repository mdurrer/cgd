#version 330

const int MAX_POINT_LIGHTS = 4;
const int MAX_SPOT_LIGHTS = 4;

//in vec4 lightSpacePos0;
in vec4 shadowCoord0;
in vec4 shadowCoord1;
in vec4 shadowCoord2;
in vec4 shadowCoord3;
in vec2 texCoord0;
in vec3 normal0;
in vec3 worldPos0;
in mat3 tbnMatrix;

out vec4 fragColor;

struct BaseLight
{
    vec3 color;
    float intensity;
};

struct DirectionalLight
{
    BaseLight base;
    vec3 direction;
};

struct Attenuation
{
    float constant;
    float linear;
    float exponent;
};

struct PointLight
{
    BaseLight base;
    Attenuation atten;
    vec3 position;
    float range;
};

struct SpotLight
{
    PointLight pointLight;
    vec3 direction;
    float cutoff;
};

uniform vec3 baseColor;
uniform vec3 eyePos;
uniform vec3 ambientLight;
uniform sampler2D diffuse;
uniform sampler2D normalMap;
uniform sampler2D bumpMap;

uniform sampler2D shadowMap0;
uniform sampler2D shadowMap1;
uniform sampler2D shadowMap2;
uniform sampler2D shadowMap3;
//uniform sampler2DShadow shadowMap;

uniform float specularIntensity;
uniform float specularPower;
uniform float scale;
uniform float bias;

uniform DirectionalLight directionalLight;
uniform PointLight pointLights[MAX_POINT_LIGHTS];
uniform SpotLight spotLights[MAX_SPOT_LIGHTS];

float calcShadowFactor()
{
    vec4 shadowCoord;
    float distanceToCamera = length(worldPos0 - eyePos);
    
    float offsetFactor;
    
    if(distanceToCamera < 2.5)
        shadowCoord = shadowCoord0;
    else if(distanceToCamera < 7.5)
        shadowCoord = shadowCoord1;
    else if(distanceToCamera < 30)
        shadowCoord = shadowCoord2;
    else
        shadowCoord = shadowCoord3;

    shadowCoord /= shadowCoord.w;
    
    float shadowFactor = 0.0;
    
    const float PCFOffset = 1.0/1024.0;//0.001;
    const float PCFFactor = 3.0;
    const float SHADOW_BIAS = 0.005;
    
    //float bias = clamp(SHADOW_BIAS * tan(acos(cosTheta)), 0.0, 1.0);
    
    for(float i = -PCFOffset; i < PCFOffset; i += 2*PCFOffset/(PCFFactor))
    {
        for(float j = -PCFOffset; j < PCFOffset; j += 2*PCFOffset/(PCFFactor))
        {
            float shadowMapValue;
            
            if(distanceToCamera < 2.5)
                shadowMapValue = texture(shadowMap0, shadowCoord.xy + vec2(i,j)).r;
            else if(distanceToCamera < 7.5)
                shadowMapValue = texture(shadowMap1, shadowCoord.xy + vec2(i,j)).r;
            else if(distanceToCamera < 30)
                shadowMapValue = texture(shadowMap2, shadowCoord.xy + vec2(i,j)).r;
            else
                shadowMapValue = texture(shadowMap3, shadowCoord.xy + vec2(i,j)).r;
        
            //float shadowDistance = (shadowCoord.z - SHADOW_BIAS);
            //float shadowValue = (shadowMapValue - shadowDistance);
            //shadowValue = shadowValue/(shadowDistance * shadowDistance);
            //shadowFactor += clamp(shadowValue, 0.0, 1.0);
            if(shadowMapValue < (shadowCoord.z - SHADOW_BIAS))
                shadowFactor += 0.0;
            else
                shadowFactor += 1.0;
        }
    }
    shadowFactor /= (PCFFactor * PCFFactor);
    return shadowFactor;
    
    
    //return texture(shadowMap, vec3(shadowCoord0.xy, (shadowCoord0.z)/shadowCoord0.w));

    
    //vec3 projectedCoords = lightSpacePos.xyz/lightSpacePos.w;
    //vec2 shadowMapCoords;
    //shadowMapCoords.x = 0.5 * projectedCoords.x + 0.5;
    //shadowMapCoords.y = 0.5 * projectedCoords.y + 0.5;
    //float z = 0.5 * projectedCoords.z + 0.5;
    //float depth = texture(shadowMap, shadowMapCoords).x;
    
    //if(depth < (z + 0.00001))
    //    return 0.0;
    //else
    //    return 1.0;
}

vec4 calcLight(BaseLight base, vec3 direction, vec3 normal)
{
    float diffuseFactor = dot(normal, -direction);
    
    vec4 diffuseColor = vec4(0,0,0,0);
    vec4 specularColor = vec4(0,0,0,0);
    
    if(diffuseFactor > 0)
    {
        diffuseColor = vec4(base.color, 1.0) * base.intensity * diffuseFactor;
        
        vec3 directionToEye = normalize(eyePos - worldPos0);
        vec3 reflectDirection = normalize(reflect(direction, normal));
        
        float specularFactor = dot(directionToEye, reflectDirection);
        specularFactor = pow(specularFactor, specularPower);
        
        if(specularFactor > 0)
        {
            specularColor = vec4(base.color, 1.0) * specularIntensity * specularFactor;
        }
    }
    
    return diffuseColor + specularColor;
}

vec4 calcDirectionalLight(DirectionalLight directionalLight, vec3 normal)
{
    return calcLight(directionalLight.base, -directionalLight.direction, normal);
}

vec4 calcPointLight(PointLight pointLight, vec3 normal)
{
    vec3 lightDirection = worldPos0 - pointLight.position;
    float distanceToPoint = length(lightDirection);
    
    if(distanceToPoint > pointLight.range)
        return vec4(0,0,0,0);
    
    lightDirection = normalize(lightDirection);
    
    vec4 color = calcLight(pointLight.base, lightDirection, normal);
    
    float attenuation = pointLight.atten.constant +
                         pointLight.atten.linear * distanceToPoint +
                         pointLight.atten.exponent * distanceToPoint * distanceToPoint +
                         0.0001;
                         
    return color / attenuation;
}

vec4 calcSpotLight(SpotLight spotLight, vec3 normal)
{
    vec3 lightDirection = normalize(worldPos0 - spotLight.pointLight.position);
    float spotFactor = dot(lightDirection, spotLight.direction);
    
    vec4 color = vec4(0,0,0,0);
    
    if(spotFactor > spotLight.cutoff)
    {
        color = calcPointLight(spotLight.pointLight, normal) *
                (1.0 - (1.0 - spotFactor)/(1.0 - spotLight.cutoff));
    }
    
    return color;
}

vec2 texCoords;

void main()
{ 
    //texCoords = texCoord0.xy;
    //float height = texture(bumpMap, texCoord0.xy).r;
    //vec3 normal = normalize(normal0);
        
    //NOTE: These should be uniforms
    //float scale = 0.04;//0.05;//0.04;
    //float bias = -0.03;//-scale/2.0;//-0.03;
    
    //height = height * scale + bias;
        
    //vec3 viewDirection = normalize(eyePos - worldPos0);
        
    //viewDirection *= tbnMatrix;
        
    //texCoords = texCoords + (viewDirection.xy * height);// / viewDirection.z;
    
    texCoords = texCoord0.xy + ((normalize(eyePos - worldPos0) * tbnMatrix).xy * 
                                (texture(bumpMap, texCoord0.xy).r * scale + bias));
    vec3 normal = normalize(tbnMatrix * (2.0 * texture(normalMap, texCoords).xyz - 1.0));

    //float cosTheta = dot(normal, directionalLight.direction);
    
    vec4 totalLight = vec4(ambientLight,1);
    vec4 color = vec4(baseColor, 1);
    vec4 textureColor = texture(diffuse, texCoords);
    
    if(textureColor != vec4(0,0,0,0))
        color *= textureColor;
    
    totalLight += calcDirectionalLight(directionalLight, normal) * calcShadowFactor();//calcShadowFactor(lightSpacePos0);
    
    for(int i = 0; i < MAX_POINT_LIGHTS; i++)
        if(pointLights[i].base.intensity > 0)
            totalLight += calcPointLight(pointLights[i], normal);
    
    for(int i = 0; i < MAX_SPOT_LIGHTS; i++)
        if(spotLights[i].pointLight.base.intensity > 0)
            totalLight += calcSpotLight(spotLights[i], normal);
    
    fragColor = color * totalLight;
}