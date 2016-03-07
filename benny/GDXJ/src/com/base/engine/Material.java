package com.base.engine;

import java.util.HashMap;


public class Material
{
	private static Material defaultMaterial;
	
	private HashMap<String, Texture> textureList;
	private HashMap<String, Vector3f> vectorList;
	private HashMap<String, Float> parameterList;
	
	private Texture diffuse;
	private Texture normal;
	private Texture bumpMap;
	private Vector3f color;
	private float specularIntensity;
	private float specularPower;
	private float heightScale;
	private float heightBias;
	
	public static void generateDefaultMaterials()
	{
		defaultMaterial = new Material(Texture.get("default.png"), new Vector3f(1,1,1), 1, 8);
		defaultMaterial.setNormalTexture(Texture.NORMAL_UP);
		defaultMaterial.setBumpTexture(Texture.WHITE_PIXEL);
		defaultMaterial.setHeightScale(0);
		defaultMaterial.setHeightBias(0);
	}
	
	public static Material getDefaultMaterial()
	{
		return defaultMaterial;
	}
	
	public Material(Texture texture)
	{
		this(texture, new Vector3f(1,1,1));
	}
	
	public Material(Texture texture, Vector3f color)
	{
		this(texture, color, 0, 0);
	}
	
	public Material(Texture texture, Vector3f color, float specularIntensity, float specularPower)
	{
		this.diffuse = texture;
		this.normal = Texture.NORMAL_UP;
		this.bumpMap = Texture.WHITE_PIXEL;
		//TODO: Default normal/bump textures
		this.color = color;
		this.specularIntensity = specularIntensity;
		this.specularPower = specularPower;
		this.heightScale = 0;
		this.heightBias = 0;
		
		textureList = new HashMap<String, Texture>();
		vectorList = new HashMap<String, Vector3f>();
		parameterList = new HashMap<String, Float>();
	}
	
	public void addTexture(String name, Texture texture)
	{
		if(name.equals("diffuse"))
			setDiffuseTexture(diffuse);
		else if(name.equals("normal"))
			setNormalTexture(normal);
		else if(name.equals("bumpMap"))
			setBumpTexture(bumpMap);
		textureList.put(name, texture);
	}
	
	public void addVector(String name, Vector3f vector)
	{
		vectorList.put(name, vector);
	}
	
	public void addParameter(String name, float value)
	{
		parameterList.put(name, value);
	}
	
	public void removeParameter(String name)
	{
		parameterList.remove(name);
	}
	
	public void removeTexture(String name)
	{
		textureList.remove(name);
	}
	
	public void removeVector(String name)
	{
		vectorList.remove(name);
	}
	
	public Vector3f getVector(String name)
	{
		if(vectorList.containsKey(name))
			return vectorList.get(name);
		else
			return Vector3f.ZERO;
	}
	
	public float getParameter(String name)
	{
		if(parameterList.containsKey(name))
			return parameterList.get(name);
		else
			return 0;
	}
	
	public Texture getTexture(String name)
	{
		if(name.equals("diffuse"))
			return diffuse;
		else if(name.equals("normal"))
			return normal;
		else if(name.equals("bumpMap"))
			return bumpMap;
		else
			return textureList.get(name);
		//TODO: Make this return a default texture if name isn't found
	}
	
	public Texture getBumpTexture()
	{
		return bumpMap;
	}
	
	public void setBumpTexture(Texture texture)
	{
		this.bumpMap = texture;
		if(heightScale == 0 && heightBias == 0)
		{
			this.heightScale = 0.04f;
			this.heightBias = -0.03f;
		}	
	}
	
	public Texture getNormalTexture()
	{
		return normal;
	}
	
	public void setNormalTexture(Texture texture)
	{
		this.normal = texture;
	}
	
	public Texture getDiffuseTexture()
	{
		return diffuse;
	}

	public void setDiffuseTexture(Texture texture)
	{
		this.diffuse = texture;
	}

	public Vector3f getColor()
	{
		return color;
	}

	public void setColor(Vector3f color)
	{
		this.color = color;
	}

	public float getSpecularIntensity()
	{
		return specularIntensity;
	}

	public void setSpecularIntensity(float specularIntensity)
	{
		this.specularIntensity = specularIntensity;
	}

	public float getSpecularPower()
	{
		return specularPower;
	}

	public void setSpecularPower(float specularPower)
	{
		this.specularPower = specularPower;
	}

	public float getHeightScale()
	{
		return heightScale;
	}

	public float getHeightBias()
	{
		return heightBias;
	}

	public void setHeightScale(float heightScale)
	{
		this.heightScale = heightScale;
	}

	public void setHeightBias(float heightBias)
	{
		this.heightBias = heightBias;
	}
}
