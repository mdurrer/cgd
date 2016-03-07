package game.RPG;

import hawte.*;

import java.awt.*;
import java.util.ArrayList;
import java.util.Collections;

/**
 * RPG Grid
 */
public class RPGGrid extends GameObject
{
	public static final int GRID_SPACE_SIZE = 32;
	//public static final int INITIAL_SPACE_CAPACITY = 2;
	private ArrayList<RPGGridObject>[][] gridObjects;
	private ArrayList<RPGGridObject> allGridObjects;
	private boolean needsSorting;

	public int getSizeX() { return gridObjects.length; }
	public int getSizeY() { return gridObjects[0].length; }

	public RPGGrid(Transform transform, Game game)
	{
		super(transform, game);
	}

	public RPGGrid initGrid(int sizeX, int sizeY)
	{
		allGridObjects = new ArrayList<RPGGridObject>();
		gridObjects = new ArrayList[sizeX][sizeY];
		needsSorting = false;
		for(int i = 0; i < getSizeX(); i++)
			for(int j = 0; j < getSizeY(); j++)
				gridObjects[i][j] = new ArrayList<RPGGridObject>();

		return this;
	}

	public void moveObject(RPGGridObject object, int startX, int startY, int destX, int destY)
	{
		gridObjects[startX][startY].remove(object);
		gridObjects[destX][destY].add(object);
		object.setParent(this, destX, destY);
	}

	public void addToGrid(RPGGridObject object, int x, int y)
	{
		object.setParent(this, x, y);
		gridObjects[x][y].add(object);
		allGridObjects.add(object);
		needsSorting = true;
	}

	public boolean isBlocking(int x, int y)
	{
		if(x < 0 || x >= getSizeX() || y < 0 || y >= getSizeY())
			return true;

		for(RPGGridObject object : gridObjects[x][y])
			if(object.isBlocking())
				return true;

		return false;
	}

	@Override
	public void input(Input input)
	{
		super.input(input);

		for(RPGGridObject object : allGridObjects)
			object.input(input);

//		for(int i = 0; i < allGridObjects.size(); i++)
//			allGridObjects.get(i).input(input);
	}

	@Override
	public void update(double delta)
	{
		super.update(delta);

		for(RPGGridObject object : allGridObjects)
			object.update(delta);

//		for(int i = 0; i < allGridObjects.size(); i++)
//			allGridObjects.get(i).update(delta);
	}

	@Override
	public void render(Graphics g)
	{
		super.render(g);

		if(needsSorting)
		{
			Collections.sort(allGridObjects);
			needsSorting = false;
		}

		for(RPGGridObject gridObject : allGridObjects)
		{
			gridObject.setRenderOffset(getTransform().getPos());
			gridObject.render(g);
		}

//		for(int i = 0; i < allGridObjects.size(); i++)
//		{
//			allGridObjects.get(i).setRenderOffset(getTransform().getPos());
//			allGridObjects.get(i).render(g);
//		}
	}
}
