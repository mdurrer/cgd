package game.RPG.components;

import hawte.GameObject;

import java.awt.*;

/**
 * Basic Wall
 */
public class RPGWall extends RPGGridComponent
{
	public void init(GameObject parent)
	{
		super.init(parent);
		setColor(Color.BLUE);
		getGameObject().setBlocking(true);
	}
}
