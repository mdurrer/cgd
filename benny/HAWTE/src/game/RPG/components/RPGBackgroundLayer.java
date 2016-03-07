package game.RPG.components;

import game.RPG.RPGGrid;
import hawte.GameObject;
import hawte.Vector2d;

import java.awt.*;

/**
 * Assembles and displays the RPGGame background
 */
public class RPGBackgroundLayer extends RPGGridComponent
{
	//TODO: Implement sprite streaming for game background!
	public void init(GameObject parent)
	{
		super.init(parent);
		setColor(Color.GREEN);
	}

	@Override
	public void render(Graphics g)
	{
		Vector2d pos = getGridCornerPos();
		RPGGrid grid = getGameObject().getGrid();
		bindColor(g);
		getGameObject().fillOffsetRect(g, (int) pos.getX(), (int) pos.getY(), RPGGrid.GRID_SPACE_SIZE * grid.getSizeX() - 1, RPGGrid.GRID_SPACE_SIZE * grid.getSizeY() - 1);
	}
}
