package game.pong.components;

import hawte.*;

/**
 * Created by batman_2 on 12/19/13.
 */
public class PongPaddle extends PongComponent
{
	public static final double SIZEX = 16;
	public static final double SIZEY = SIZEX * 7;
	public static final double MOVE_SPEED = 160;

	@Override
	public void onCollision(Contact contact, PhysicsComponent component)
	{
		if(component instanceof PongWall)
		{
			getTransform().setPos(getTransform().getPos().sub(contact.getCollisionVector()));
		}
	}
}
