package hawte;

/**
 * Created by batman_2 on 12/19/13.
 */
public class Contact
{
	private Vector2d collisionVector;

	public Vector2d getCollisionVector() { return collisionVector; }

	public Contact(Vector2d collisionVector)
	{
		this.collisionVector = collisionVector;
	}
}
