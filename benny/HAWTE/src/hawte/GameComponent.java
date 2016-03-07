package hawte;

import java.awt.*;

/**
 * Created by batman_2 on 12/18/13.
 */
public abstract class GameComponent
{
	private GameObject object;

	public Transform getTransform() { return getGameObject().getTransform(); }
	public GameObject getGameObject() { return object; }

	public void init(GameObject parent)
	{
		this.object = parent;
	}

	public void input(Input input) {}
	public void update(double delta) {}
	public void render(Graphics g) {}
}
