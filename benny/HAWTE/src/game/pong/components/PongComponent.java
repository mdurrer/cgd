package game.pong.components;

import hawte.GameComponent;
import hawte.Input;
import hawte.PhysicsComponent;
import hawte.Vector2d;

import java.awt.*;

/**
 * Created by batman_2 on 12/18/13.
 */
public class PongComponent extends PhysicsComponent
{
	@Override
	public void render(Graphics g)
	{
		Vector2d pos = getGameObject().getTransform().getCornerPos();
		Vector2d size = getGameObject().getTransform().getFullSize();

		//Convert from center + widths to edge + scale)
//		pos = pos.sub(size);
//		size = size.mul(2);

		//g.drawRoundRect((int) pos.getX(), (int) pos.getY(), (int) size.getX(), (int) size.getY(), (int)(size.getX() / 2), (int)(size.getX() / 2));
		g.drawRect((int) pos.getX(), (int) pos.getY(), (int) size.getX(), (int) size.getY());
	}
}
