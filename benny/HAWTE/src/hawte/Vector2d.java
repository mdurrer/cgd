package hawte;

public class Vector2d
{
	private double x;
	private double y;

	public double getX()
	{
		return x;
	}
	public double getY() { return y; }

	public void setX(double x)
	{
		this.x = x;
	}
	public void setY(double y)
	{
		this.y = y;
	}
	public void set(double x, double y) { this.x = x; this.y = y; }
	public void set(Vector2d xy) { this.x = xy.getX(); this.y = xy.getY(); }

	public void incX(double amt) { x += amt; }
	public void incY(double amt) { y += amt; }

	public Vector2d add(Vector2d r) { return new Vector2d(x + r.getX(), y + r.getY()); }
	public Vector2d add(double r) { return new Vector2d(x + r, y + r); }
	public Vector2d sub(Vector2d r) { return new Vector2d(x - r.getX(), y - r.getY()); }
	public Vector2d sub(double r) { return new Vector2d(x - r, y - r); }
	public Vector2d mul(double r) { return new Vector2d(x * r, y * r); }
	public Vector2d div(double r) { return new Vector2d(x / r, y / r); }
	public Vector2d abs() { return new Vector2d(Math.abs(x), Math.abs(y)); }

	public void addEq(double x, double y) { this.x += x; this.y += y; }

	public Vector2d(Vector2d init)
	{
		this.x = init.getX();
		this.y = init.getY();
	}

	public Vector2d(double x, double y)
	{
		this.x = x;
		this.y = y;
	}

	public double lengthSquared()
	{
		return x * x + y * y;
	}

	public double length()
	{
		return Math.sqrt(lengthSquared());
	}

	public double distance(Vector2d r)
	{
		return this.sub(r).length();
	}

	public double angleBetween(Vector2d r)
	{
		double cosTheta = this.dot(r)/(this.length() * r.length());

		return Math.acos(cosTheta);
	}

	public double dot(Vector2d r)
	{
		return x * r.getX() + y * r.getY();
	}

	public double cross(Vector2d r)
	{
		return x * r.getY() - y * r.getX();
	}

	public Vector2d normalized()
	{
		double length = length();

		return new Vector2d(x / length, y / length);
	}

	public Vector2d min(Vector2d r)
	{
		return new Vector2d(Math.min(x, r.getX()), Math.min(y, r.getY()));
	}

	public Vector2d max(Vector2d r)
	{
		return new Vector2d(Math.max(x, r.getX()), Math.max(y, r.getY()));
	}

	public Vector2d clamp(double maxLength)
	{
		if(lengthSquared() <= maxLength * maxLength)
			return this;

		return this.normalized().mul(maxLength);
	}

	public Vector2d towards(Vector2d r, double amt)
	{
		Vector2d result = this.sub(r);

		if(result.length() < amt)
			return result;

		return result.normalized().mul(amt);
	}

	public Vector2d reflectComponent(Vector2d normal, double restitution)
	{
		return normal.mul(this.dot(normal)).mul(1 + restitution);
	}

	public Vector2d rotate(double angle)
	{
		double cos = Math.cos(angle);
		double sin = Math.sin(angle);

		return new Vector2d(x * cos - y * sin, x * sin + y * cos);
	}

	public Vector2d lerp(Vector2d newVector, double amt)
	{
		return newVector.sub(this).mul(amt).add(this);
	}

	@Override
	public String toString()
	{
		return "(" + x + " " + y + ")";
	}

	public boolean equals(Vector2d r)
	{
		return r.getX() == x && r.getY() == y;
	}
}

