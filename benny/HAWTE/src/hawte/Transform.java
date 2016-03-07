package hawte;

/**
 * Created by batman_2 on 12/18/13.
 */
public class Transform
{
	private Vector2d center;
	private Vector2d halfWidths;
	private double rotation;

	public Vector2d getCornerPos() { return center.sub(halfWidths); }
	public Vector2d getFullSize() { return halfWidths.mul(2); }

	public Vector2d getPos() { return center; }
	public Vector2d getScale() { return halfWidths; }
	public double getRotation() { return rotation; }

	public void setPos(Vector2d center) { this.center = center; }
	public void setScale(Vector2d scale) { this.halfWidths = scale; }
	public void setRotation(double rotation) { this.rotation = rotation; }

	public Transform()
	{
		this(new Vector2d(0,0), new Vector2d(0,0), 0);
	}

	public Transform(Vector2d center, Vector2d halfWidths, double rotation)
	{
		this.center = center;
		this.halfWidths = halfWidths;
		this.rotation = rotation;
	}

	public Contact checkBoxCollision(Transform collider)
	{
		Vector2d direction = collider.getPos().sub(center);
		Vector2d distance = direction.abs().sub(collider.getScale().add(halfWidths));

		if(distance.getX() < 0 && distance.getY() < 0)
		{
			if(distance.getX() > distance.getY())
			{
				if(direction.getX() < 0)
					return new Contact(new Vector2d(distance.getX(), 0));
				else
					return new Contact(new Vector2d(-distance.getX(), 0));
			}
			else
			{
				if(direction.getY() < 0)
					return new Contact(new Vector2d(0, distance.getY()));
				else
					return new Contact(new Vector2d(0, -distance.getY()));
			}
		}

		return null;
	}

	@Override
	public String toString()
	{
		Vector2d pos = this.getPos();
		Vector2d size = this.getScale();

		return (pos.getX() + " " + pos.getY() + " " + size.getX() + " " + size.getY() + " " + rotation);
	}
}
