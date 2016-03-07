Texture2D diffuse : register( t0 );
SamplerState samLinear : register( s0 );

cbuffer cbChangesEveryFrame : register( b0 )
{
    matrix MVP;
};

struct VS_IN
{
    float4 Pos : POSITION;
    float2 Tex : TEXCOORD0;
};

struct PS_IN
{
    float4 Pos : SV_POSITION;
    float2 Tex : TEXCOORD0;
};

PS_IN VS( VS_INP input )
{
    PS_IN output = (PS_IN)0;
    output.Pos = mul( input.Pos, MVP );
    output.Tex = input.Tex;
    
    return output;
}

float4 PS( PS_INPUT input) : SV_Target
{
    return diffuse.Sample(samLinear, input.Tex);
}