package com.base.engine;

import java.util.ArrayList;

public class Game 
{
	private ArrayList<GameObject> objects;
	
	public Game()
	{
		objects = new ArrayList<GameObject>();
	}
	
	public void input()
	{
		Transform.getCamera().input();
		
		for(GameObject object : objects)
			object.input();
	}
	
	public void update()
	{
		for(GameObject object : objects)
			object.update();
	}
	
	public void render()
	{
		Engine.getRenderingEngine().fullRender();
	}

	public ArrayList<GameObject> getObjects()
	{
		return objects;
	}

	public void setObjects(ArrayList<GameObject> objects)
	{
		this.objects = objects;
	}
	
	public void addObject(GameObject object)
	{
		objects.add(object);
	}
	
	public void removeObject(GameObject object)
	{
		objects.remove(object);
	}
}
