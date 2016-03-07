package com.base.engine;


public class Quaternion
{
	private float x;
	private float y;
	private float z;
	private float w;
	
	public Quaternion()
	{
		this(0,0,0,1);
	}
	
	public Quaternion(float x, float y, float z, float w)
	{
		this.x = x;
		this.y = y;
		this.z = z;
		this.w = w;
	}
	
	public Quaternion(Vector3f direction)
	{
		Quaternion res = new Matrix4f().initRotation(direction, Vector3f.UP).toQuaternion().normalized();
		x = res.getX();
		y = res.getY();
		z = res.getZ();
		w = res.getW();
	}
	
	public Quaternion(Vector3f from, Vector3f to)
	{
	     Vector3f H = from.add(to).normalized();

	     w = from.dot(H);
	     x = from.getY()*H.getZ() - from.getZ()*H.getY();
	     y = from.getZ()*H.getX() - from.getX()*H.getZ();
	     z = from.getX()*H.getY() - from.getY()*H.getX();
	}
	
	public Quaternion(Vector3f axis, float angle)
	{
		float halfAngle = (float)Math.toRadians(angle / 2);
		axis = axis.normalized();
		
		float sin = (float)Math.sin(halfAngle);
		float cos = (float)Math.cos(halfAngle);
		
		x = axis.getX() * sin;
		y = axis.getY() * sin;
		z = axis.getZ() * sin;
		w = cos;
	}
	
	public float length()
	{
		return (float)Math.sqrt(x * x + y * y + z * z + w * w);
	}
	
	public float dot(Quaternion r)
	{
		return x * r.getX() + y * r.getY() + z * r.getZ() + w * r.getW();
	}
	
	public Quaternion normalized()
	{
		float length = length();
		
		return new Quaternion(x / length, y / length, z / length, w / length);
	}
	
	public Quaternion conjugate()
	{
		return new Quaternion(-x, -y, -z, w);
	}
	
	public Quaternion add(Quaternion r)
	{
		return new Quaternion(x + r.getX(), y + r.getY(), z + r.getZ(), w + r.getW());
	}
	
	public Quaternion add(float amt)
	{
		return new Quaternion(x + amt, y + amt, z + amt, w + amt);
	}
	
	public Quaternion sub(Quaternion r)
	{
		return new Quaternion(x - r.getX(), x - r.getY(), z - r.getZ(), w - r.getW());
	}
	
	public Quaternion sub(float amt)
	{
		return new Quaternion(x - amt, y - amt, z - amt, w - amt);
	}
	
	public Quaternion mul(Quaternion r)
	{
		float w_ = w * r.getW() - x * r.getX() - y * r.getY() - z * r.getZ();
		float x_ = x * r.getW() + w * r.getX() + y * r.getZ() - z * r.getY();
		float y_ = y * r.getW() + w * r.getY() + z * r.getX() - x * r.getZ();
		float z_ = z * r.getW() + w * r.getZ() + x * r.getY() - y * r.getX();
		
		return new Quaternion(x_, y_, z_, w_);
	}
	
	public Quaternion mul(Vector3f r)
	{
		float w_ = -x * r.getX() - y * r.getY() - z * r.getZ();
		float x_ =  w * r.getX() + y * r.getZ() - z * r.getY();
		float y_ =  w * r.getY() + z * r.getX() - x * r.getZ();
		float z_ =  w * r.getZ() + x * r.getY() - y * r.getX();
		
		return new Quaternion(x_, y_, z_, w_);
	}
	
	public Quaternion mul(float amt)
	{
		return new Quaternion(x * amt, y * amt, z * amt, w * amt);
	}
	
	public Quaternion div(float amt)
	{
		return new Quaternion(x / amt, y / amt, z / amt, w / amt);
	}
	
	public Quaternion lerp(Quaternion r, float amt)
	{
		return this.add((r.sub(this).mul(amt))).normalized();
	}
	
	public Quaternion slerp(Quaternion r, float amt)
	{
		Quaternion r2 = r;
		
		float dot = this.dot(r2);
		
		if(dot < 0)
		{
			r2 = r.mul(-1);
			dot *= -1;
		}
		
		if(dot > 0.9995f) //Too close for accurate slerp
			return this.lerp(r2, amt);
		
//		float theta = (float) (Math.acos(dot) * amt);
//		
//		float sininvamttheta = (float)Math.sin((1.0f - amt) * theta);
//		float sinamttheta = (float)(Math.sin(theta * amt));
//		float sintheta = (float)Math.sin(theta);
//		
//		Quaternion factor2 = r2.mul(sinamttheta).div(sintheta);
//		
//		return this.mul(sininvamttheta).add(factor2).normalized();
		
		if(dot > 1.0f)
			dot = 1.0f;
		if(dot < -1.0f)
			dot = -1.0f;
		
		float theta = (float) ((Math.acos(dot) * amt));
		
		Quaternion res = r.sub(this.mul(dot)).normalized();
		
		return this.mul((float)Math.cos(theta)).add(res.mul((float)Math.sin(theta))).normalized();
	}
	
	public Vector3f getEulerAngles()
	{
		float sqx = x * x;
		float sqy = y * y;
		float sqz = z * z;
		float sqw = w * w;
		float unit = sqx + sqy + sqz + sqw;
		float test = x * y + z * w;
		
		float heading = 0;
		float attitude = 0;
		float bank = 0;
		
		if (test > 0.499f * unit)
		{ // singularity at north pole
			heading = 2.0f * (float)Math.atan2(x, w);
			attitude = (float)Math.PI / 2.0f;
			bank = 0.0f;
		}
		else if (test < -0.499 * unit)
		{ // singularity at south pole
			heading = -2.0f * (float)Math.atan2(x, w);
			attitude = -(float)Math.PI / 2.0f;
			bank = 0.0f;
		}
		else
		{
			heading = (float)Math.atan2(2.0f * y * w - 2.0f * x * z, sqx - sqy - sqz + sqw);
			attitude = (float)Math.asin(2.0f * test / unit);
			bank = (float)Math.atan2(2.0f * x * w - 2.0f * y * z, -sqx + sqy - sqz + sqw);
		}
		
		return new Vector3f((float)Math.toDegrees(bank), (float)Math.toDegrees(heading), (float)Math.toDegrees(attitude));
	}
	
	public Matrix4f getRotationMatrix()
	{
		Vector3f right = getRight();
		Vector3f up = getUp();
		Vector3f forward = getForward();
		
		float[][] m = new float[][] {{right.getX(), right.getY(), right.getZ(), 0.0f},
									   {up.getX(), up.getY(), up.getZ(), 0.0f},
									   {forward.getX(), forward.getY(), forward.getZ(), 0.0f},
									   {0.0f, 0.0f, 0.0f, 1.0f}};
		return new Matrix4f(m);
	}
	
	public Vector3f getForward()
	{
		return new Vector3f(2.0f * (x*z - w*y), 2.0f * (y * z + w * x), 1.0f - 2.0f * (x * x + y * y));
	}
	
	public Vector3f getBack()
	{
		return new Vector3f(-2.0f * (x*z - w*y), -2.0f * (y * z + w * x), -(1.0f - 2.0f * (x * x + y * y)));
	}
	
	public Vector3f getUp()
	{
		return new Vector3f(2.0f * (x*y + w*z), 1.0f - 2.0f * (x*x + z*z), 2.0f * (y*z - w*x));
	}
	
	public Vector3f getDown()
	{
		return new Vector3f(-2.0f * (x*y + w*z), -(1.0f - 2.0f * (x*x + z*z)), -2.0f * (y*z - w*x));
	}
	
	public Vector3f getRight()
	{
		return new Vector3f(1.0f - 2.0f * (y*y + z*z), 2.0f * (x*y - w*z), 2.0f * (x*z + w*y));
	}
	
	public Vector3f getLeft()
	{
		return new Vector3f(-(1.0f - 2.0f * (y*y + z*z)), -2.0f * (x*y - w*z), -2.0f * (x*z + w*y));
	}
	
	public String toString()
	{
		return "(" + x + " " + y + " " + z + " " + w + ")";
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

	public float getW()
	{
		return w;
	}

	public void setW(float w)
	{
		this.w = w;
	}
	
	public void set(float x, float y, float z, float w)
	{
		this.x = x;
		this.y = y;
		this.z = z;
		this.w = w;
	}
}
