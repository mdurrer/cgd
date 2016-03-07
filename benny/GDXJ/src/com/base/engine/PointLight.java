package com.base.engine;


public class PointLight
{
	private BaseLight baseLight;
	private Attenuation atten;
	private Vector3f position;
	private float range;
	
	public PointLight(BaseLight baseLight, Attenuation atten, Vector3f position, float range)
	{
		this.baseLight = baseLight;
		this.atten = atten;
		this.position = position;
		this.range = range;
	}
	
	public PointLight(BaseLight baseLight, Attenuation atten, Vector3f position)
	{
		this.baseLight = baseLight;
		this.atten = atten;
		this.position = position;
		
		float a = atten.getExponent();
		float b = atten.getLinear();
		float c = atten.getConstant();
		float max = Math.max(baseLight.getColor().getZ(), Math.max(baseLight.getColor().getX(), baseLight.getColor().getY()));
		
		this.range = (float)(-b + Math.sqrt(b * b - 4 * a * (c - 256 * max * baseLight.getIntensity())) / (2 * a));
	}
	
	public BaseLight getBaseLight()
	{
		return baseLight;
	}
	public void setBaseLight(BaseLight baseLight)
	{
		this.baseLight = baseLight;
	}
	public Attenuation getAtten()
	{
		return atten;
	}
	public void setAtten(Attenuation atten)
	{
		this.atten = atten;
	}
	public Vector3f getPosition()
	{
		return position;
	}
	public void setPosition(Vector3f position)
	{
		this.position = position;
	}

	public float getRange()
	{
		return range;
	}

	public void setRange(float range)
	{
		this.range = range;
	}
}
