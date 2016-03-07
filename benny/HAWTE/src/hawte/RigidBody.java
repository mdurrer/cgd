package hawte;

/**
 * Created by batman_2 on 12/19/13.
 */
public class RigidBody
{
	private Transform transform;
	private Vector2d velocity;
	//private double invMass;

	public RigidBody(Transform transform, Vector2d velocity)
	{
		this.transform = transform;
		this.velocity = velocity;
	}

	public Contact checkCollision(RigidBody body)
	{
		return null;
	}

	public void integrate(double delta)
	{
		Vector2d position = transform.getPos();

		transform.setPos(position.add(velocity.mul(delta)));
	}
}
