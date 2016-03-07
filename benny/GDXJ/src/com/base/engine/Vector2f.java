package com.base.engine;



public class Vector2f 
{
	private float x;
	private float y;
	
	public Vector2f(float x, float y)
	{
		this.x = x;
		this.y = y;
	}
	
	public Vector2f(Vector3f r)
	{
		this.x = r.getX();
		this.y = r.getY();
	}

	public float lengthSquared()
	{
		return x * x + y * y;
	}
	
	public float length()
	{
		return (float)Math.sqrt(lengthSquared());
	}
	
	public float distance(Vector2f r)
	{
		return this.sub(r).length();
	}
	
	public float angleBetween(Vector2f r)
	{
		float cosTheta = this.dot(r)/(this.length() * r.length());
		
		return (float)Math.acos(cosTheta);
	}
	
	public float dot(Vector2f r)
	{
		return x * r.getX() + y * r.getY();
	}
	
	public float cross(Vector2f r)
	{
		return x * r.getY() - y * r.getX();
	}
	
	public Vector2f normalized()
	{
		float length = length();
		
		return new Vector2f(x / length, y / length);
	}
	
	public Vector2f min(Vector2f r)
	{
		return new Vector2f(Math.min(x, r.getX()), Math.min(y, r.getY()));
	}
	
	public Vector2f max(Vector2f r)
	{
		return new Vector2f(Math.max(x, r.getX()), Math.max(y, r.getY()));
	}
	
	public Vector2f clamp(float maxLength)
	{
		if(lengthSquared() <= maxLength * maxLength)
			return this;
		
		return this.normalized().mul(maxLength);
	}
	
	public Vector2f towards(Vector2f r, float amt)
	{
		Vector2f result = this.sub(r);
		
		if(result.length() < amt)
			return result;
		
		return result.normalized().mul(amt);
	}
	
	public Vector2f rotate(float angle)
	{
		double rad = Math.toRadians(angle);
		double cos = Math.cos(rad);
		double sin = Math.sin(rad);
		
		return new Vector2f((float)(x * cos - y * sin),(float)(x * sin + y * cos));
	}
	
	public Vector2f add(Vector2f r)
	{
		return new Vector2f(x + r.getX(), y + r.getY());
	}
	
	public Vector2f add(float r)
	{
		return new Vector2f(x + r, y + r);
	}
	
	public Vector2f sub(Vector2f r)
	{
		return new Vector2f(x - r.getX(), y - r.getY());
	}
	
	public Vector2f sub(float r)
	{
		return new Vector2f(x - r, y - r);
	}
	
	public Vector2f mul(Vector2f r)
	{
		return new Vector2f(x * r.getX(), y * r.getY());
	}
	
	public Vector2f mul(float r)
	{
		return new Vector2f(x * r, y * r);
	}
	
	public Vector2f div(Vector2f r)
	{
		return new Vector2f(x / r.getX(), y / r.getY());
	}
	
	public Vector2f div(float r)
	{
		return new Vector2f(x / r, y / r);
	}
	
	public Vector2f abs()
	{
		return new Vector2f(Math.abs(x), Math.abs(y));
	}
	
	public Vector2f lerp(Vector2f newVector, float amt)
	{
		return this.sub(newVector).mul(amt).add(newVector);
	}
	
	public String toString()
	{
		return "(" + x + " " + y + ")";
	}
	
	public boolean equals(Vector2f r)
	{
		return r.getX() == x && r.getY() == y;
	}
	
	public float getX() 
	{
		return x;
	}

	public void setX(float x) 
	{
		this.x = x;
	}

	public float getY() 
	{
		return y;
	}

	public void setY(float y)
	{
		this.y = y;
	}
	
	public void set(float x, float y)
	{
		this.x = x;
		this.y = y;
	}
}
