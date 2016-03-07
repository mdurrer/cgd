package game.pong.components;

import hawte.Contact;
import hawte.Input;
import hawte.PhysicsComponent;
import hawte.Transform;

import java.awt.event.KeyEvent;

/**
 * Created by batman_2 on 12/18/13.
 */
public class PongPlayer extends PongPaddle
{
	@Override
	public void input(Input input)
	{
		getVelocity().set(0, 0);

		if(input.getKey(KeyEvent.VK_W) || input.getKey(KeyEvent.VK_UP))
			getVelocity().incY(-MOVE_SPEED);
		if(input.getKey(KeyEvent.VK_S) || input.getKey(KeyEvent.VK_DOWN))
			getVelocity().incY(MOVE_SPEED);
	}
}
