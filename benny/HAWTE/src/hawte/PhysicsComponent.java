package hawte;

/**
 * Physics component basis
 */
public class PhysicsComponent extends GameComponent
{
	private Vector2d velocity = new Vector2d(0, 0);

	public Vector2d getVelocity() { return velocity; }

	public void integrate(double delta)
	{
		Transform transform = getGameObject().getTransform();
		Vector2d position = transform.getPos();

		transform.setPos(position.add(velocity.mul(delta)));
	}

	public void onCollision(Contact contact, PhysicsComponent collidedWith)
	{

	}

	public void bounce(Contact contact, double restitution, double offsetAngle)
	{
		Transform transform = getGameObject().getTransform();
		Vector2d pos = transform.getPos();

		transform.setPos(pos.sub(contact.getCollisionVector().mul(2)));

		Vector2d newDirection = getVelocity().reflectComponent(contact.getCollisionVector().normalized(), restitution);
		newDirection = getVelocity().sub(newDirection).rotate(offsetAngle);
		getVelocity().set(newDirection.getX(), newDirection.getY());
	}
}
