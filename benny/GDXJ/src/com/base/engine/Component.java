package com.base.engine;

public class Component
{
	private GameObject gameObject;
	private int updateRate = 60;		//TODO: More generic way of initializing update rate
	private double unprocessedTime = 0;

	public GameObject getObject(){return gameObject;}
	public int getUpdateRate() {return updateRate;}
	public double getUnprocessedTime() {return unprocessedTime;}
	public double getUpdateDelta()
	{
		return 1.0/(double)updateRate;
	}
	
	public void setObject(GameObject gameObject){this.gameObject = gameObject;}
	public void setUpdateRate(int updateRate) {this.updateRate = updateRate;}
	
	public void addUnprocessedTime(double amt)
	{
		unprocessedTime += amt;
	}
	
	public void init()
	{
		
	}
	
	public void input()
	{
		
	}
	
	public void update()
	{
		
	}

	public void render()
	{
		
	}
}
