package game.RPG;

import game.RPG.components.RPGBackgroundLayer;
import game.RPG.components.RPGPlayer;
import game.RPG.components.RPGWall;
import hawte.Game;
import hawte.Transform;

import java.util.Random;

/**
 * RPG Game class
 */
public class RPGGame extends Game
{
	public static final int GRID_DIM_X = 64;
	public static final int GRID_DIM_Y = 64;
	public static final int WALL_CHANCE = 16;
	public static final int PLAYER_START_X = GRID_DIM_X / 2;
	public static final int PLAYER_START_Y = GRID_DIM_Y / 2;
	public static final int LEVEL_SEED = 0;

	@Override
	public void init()
	{
		RPGGrid grid = new RPGGrid(new Transform(), this).initGrid(GRID_DIM_X, GRID_DIM_Y);
		Random rand = new Random(LEVEL_SEED);

		grid.addToGrid(new RPGGridObject(new Transform(), this).addComponent(new RPGBackgroundLayer()), 0, 0);

		for(int i = 0; i < GRID_DIM_X; i++)
		{
			for(int j = 0; j < GRID_DIM_Y; j++)
			{
				if((rand.nextInt(WALL_CHANCE) == 0 && i != PLAYER_START_X && j != PLAYER_START_Y)
				   || i == 0 || j == 0 || i == GRID_DIM_X - 1 || j == GRID_DIM_Y - 1)
					grid.addToGrid(new RPGGridObject(new Transform(), this).addComponent(new RPGWall()), i, j);
			}
		}

		grid.addToGrid(new RPGGridObject(new Transform(), this).addComponent(new RPGPlayer()).setDrawPriority(Integer.MAX_VALUE), PLAYER_START_X, PLAYER_START_Y);
		addObject(grid);

		//saveScene("./res/rpg/world.scn");
	}
}
