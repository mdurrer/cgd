package com.base.engine;


public class Vector3f 
{
	public static final Vector3f UP = new Vector3f(0,1,0);
	public static final Vector3f DOWN = new Vector3f(0,-1,0);
	public static final Vector3f LEFT = new Vector3f(-1,0,0);
	public static final Vector3f RIGHT = new Vector3f(1,0,0);
	public static final Vector3f FORWARD = new Vector3f(0,0,1);
	public static final Vector3f BACK = new Vector3f(0,0,-1);
	public static final Vector3f ZERO = new Vector3f(0,0,0);
	public static final Vector3f ONE = new Vector3f(1,1,1);
	
	private float x;
	private float y;
	private float z;
	
	public Vector3f(float x, float y, float z)
	{
		this.x = x;
		this.y = y;
		this.z = z;
	}
	
	public Vector3f(Vector2f r)
	{
		this.x = r.getX();
		this.y = r.getY();
		this.z = 0;
	}

	public float lengthSquared()
	{
		return x * x + y * y + z * z;
	}
	
	public float length()
	{
		return (float)Math.sqrt(lengthSquared());
	}
	
	public float distance(Vector3f r)
	{
		return this.sub(r).length();
	}
	
	public float angleBetween(Vector3f r)
	{
		float cosTheta = this.dot(r)/(this.length() * r.length());
		
		return (float)Math.acos(cosTheta);
	}
	
	public float dot(Vector3f r)
	{
		return x * r.getX() + y * r.getY() + z * r.getZ();
	}
	
	public Vector3f cross(Vector3f r)
	{
		float x_ = y * r.getZ() - z * r.getY();
		float y_ = z * r.getX() - x * r.getZ();
		float z_ = x * r.getY() - y * r.getX();
		
		return new Vector3f(x_, y_, z_);
	}
	
	public Vector3f normalized()
	{
		float length = length();
		
		return new Vector3f(x / length, y / length, z / length);
	}
	
//	public Vector3f normalize()
//	{
//		float length = length();
//		
//		x /= length;
//		y /= length;
//		z /= length;
//		return this;
//	}
	
	public Vector3f min(Vector3f r)
	{
		return new Vector3f(Math.min(x, r.getX()), Math.min(y, r.getY()), Math.min(z, r.getZ()));
	}
	
	public Vector3f max(Vector3f r)
	{
		return new Vector3f(Math.max(x, r.getX()), Math.max(y, r.getY()), Math.max(z, r.getZ()));
	}
	
	public Vector3f clamp(float maxLength)
	{
		if(lengthSquared() <= maxLength * maxLength)
			return this;
		
		return this.normalized().mul(maxLength);
	}
	
	public Vector3f towards(Vector3f r, float amt)
	{
		Vector3f result = r.sub(this);
		
		if(result.length() < amt)
			return this.add(result);
		
		return this.add(result.normalized().mul(amt));
	}
	
	public Vector3f rotate(float angle, Vector3f axis)
	{
		return this.cross(axis.mul((float)Math.sin(Math.toRadians(-angle)))).add(this.mul((float)Math.cos(Math.toRadians(-angle))));
		//return this.rotate(new Quaternion(axis, angle));
	}
	
	public Vector3f rotate(Quaternion rotation)
	{
	     float x1 = rotation.getY() * z - rotation.getZ() * y;
	     float y1 = rotation.getZ() * x - rotation.getX() * z;
	     float z1 = rotation.getX() * y - rotation.getY() * x;

	     float x2 = rotation.getW() * x1 + rotation.getY() * z1 - rotation.getZ() * y1;
	     float y2 = rotation.getW() * y1 + rotation.getZ() * x1 - rotation.getX() * z1;
	     float z2 = rotation.getW() * z1 + rotation.getX() * y1 - rotation.getY() * x1;
	     
	     return new Vector3f(x + 2.0f * x2, y + 2.0f * y2, z + 2.0f * z2);
		
//		Quaternion conjugate = rotation.conjugate();
//		
//		Quaternion w = rotation.mul(this).mul(conjugate);
//		
//		return new Vector3f(w.getX(), w.getY(), w.getZ());
	}
	
	public Vector3f lerp(Vector3f newVector, float amt)
	{
		return this.sub(newVector).mul(amt).add(newVector);
	}
	
	public Vector3f add(Vector3f r)
	{
		return new Vector3f(x + r.getX(), y + r.getY(), z + r.getZ());
	}
	
	public Vector3f add(float r)
	{
		return new Vector3f(x + r, y + r, z + r);
	}
	
//	public Vector3f addEq(Vector3f r)
//	{
//		x += r.getX();
//		y += r.getY();
//		z += r.getZ();
//		return this;
//	}
//	
//	public Vector3f addEq(float r)
//	{
//		x += r;
//		y += r;
//		z += r;
//		return this;
//	}
	
	public Vector3f sub(Vector3f r)
	{
		return new Vector3f(x - r.getX(), y - r.getY(), z - r.getZ());
	}
	
	public Vector3f sub(float r)
	{
		return new Vector3f(x - r, y - r, z - r);
	}
	
//	public Vector3f subEq(Vector3f r)
//	{
//		x -= r.getX();
//		y -= r.getY();
//		z -= r.getZ();
//		return this;
//	}
//	
//	public Vector3f subEq(float r)
//	{
//		x -= r;
//		y -= r;
//		z -= r;
//		return this;
//	}
	
	public Vector3f mul(Vector3f r)
	{
		return new Vector3f(x * r.getX(), y * r.getY(), z * r.getZ());
	}
	
	public Vector3f mul(float r)
	{
		return new Vector3f(x * r, y * r, z * r);
	}
	
//	public Vector3f mulEq(Vector3f r)
//	{
//		x *= r.getX();
//		y *= r.getY();
//		z *= r.getZ();
//		return this;
//	}
//	
//	public Vector3f mulEq(float r)
//	{
//		x *= r;
//		y *= r;
//		z *= r;
//		return this;
//	}
	
	public Vector3f div(Vector3f r)
	{
		return new Vector3f(x / r.getX(), y / r.getY(), z / r.getZ());
	}
	
	public Vector3f div(float r)
	{
		return new Vector3f(x / r, y / r, z / r);
	}
	
//	public Vector3f divEq(Vector3f r)
//	{
//		x /= r.getX();
//		y /= r.getY();
//		z /= r.getZ();
//		return this;
//	}
//	
//	public Vector3f divEq(float r)
//	{
//		x /= r;
//		y /= r;
//		z /= r;
//		return this;
//	}
	
	public Vector3f abs()
	{
		return new Vector3f(Math.abs(x), Math.abs(y), Math.abs(z));
	}
	
	public Quaternion rotationBetween(Vector3f r)
	{
		Vector3f temp = this.cross(r);
		float w = (float)Math.sqrt((this.length() * r.length())) + this.dot(r);
		
		return new Quaternion(temp.getX(), temp.getY(), temp.getZ(), w);
	}
	
	public String toString()
	{
		return "(" + x + " " + y + " " + z + ")";
	}
	
	public boolean equals(Vector3f r)
	{
		return r.getX() == x && r.getY() == y && r.getZ() == z;
	}
	
	public Vector2f getXY()
	{
		return new Vector2f(x,y);
	}
	
	public Vector2f getXZ()
	{
		return new Vector2f(x,z);
	}
	
	public Vector2f getYZ()
	{
		return new Vector2f(y,z);
	}
	
	public Vector2f getYX()
	{
		return new Vector2f(y,x);
	}
	
	public Vector2f getZX()
	{
		return new Vector2f(z,x);
	}
	
	public Vector2f getZY()
	{
		return new Vector2f(z,y);
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

	public float getZ() 
	{
		return z;
	}

	public void setZ(float z) 
	{
		this.z = z;
	}
	
	public void set(float x, float y, float z)
	{
		this.x = x;
		this.y = y;
		this.z = z;
	}
}
