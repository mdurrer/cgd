package com.base.engine;

import java.nio.FloatBuffer;

public class Vertex
{
	public static final int SIZE = 11;
	
	private Vector3f pos;
	private Vector2f texCoord;
	private Vector3f normal;
	private Vector3f tangent;
	
	public Vertex(Vector3f pos)
	{
		this(pos, new Vector2f(0,0));
	}
	
	public Vertex(Vector3f pos, Vector2f texCoord)
	{
		this(pos, texCoord, new Vector3f(0,0,0));
	}
	
	public Vertex(Vector3f pos, Vector2f texCoord, Vector3f normal)
	{
		this(pos, texCoord, normal, new Vector3f(0,0,0));
	}
	
	public Vertex(Vector3f pos, Vector2f texCoord, Vector3f normal, Vector3f tangent)
	{
		this.pos = pos;
		this.texCoord = texCoord;
		this.normal = normal;
		this.tangent = tangent;
	}
	
	public void addToBuffer(FloatBuffer buffer)
	{
		buffer.put(getPos().getX());
		buffer.put(getPos().getY());
		buffer.put(getPos().getZ());
		buffer.put(getTexCoord().getX());
		buffer.put(getTexCoord().getY());
		buffer.put(getNormal().getX());
		buffer.put(getNormal().getY());
		buffer.put(getNormal().getZ());
		buffer.put(getTangent().getX());
		buffer.put(getTangent().getY());
		buffer.put(getTangent().getZ());
	}

	public Vector3f getPos()
	{
		return pos;
	}

	public void setPos(Vector3f pos)
	{
		this.pos = pos;
	}

	public Vector2f getTexCoord()
	{
		return texCoord;
	}

	public void setTexCoord(Vector2f texCoord)
	{
		this.texCoord = texCoord;
	}

	public Vector3f getNormal()
	{
		return normal;
	}

	public void setNormal(Vector3f normal)
	{
		this.normal = normal;
	}

	public Vector3f getTangent()
	{
		return tangent;
	}

	public void setTangent(Vector3f tangent)
	{
		this.tangent = tangent;
	}
}
