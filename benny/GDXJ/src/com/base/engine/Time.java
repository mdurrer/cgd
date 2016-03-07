package com.base.engine;

public class Time 
{
	private static final long SECOND = 1000000000L;
	
	private static double delta;
	
	private static double lastTime;
	private static double startTime;
	
	public static void init()
	{
		lastTime = Time.getTime();
		startTime = lastTime;
	}
	
	public static void tick()
	{
		lastTime = startTime;
		startTime = Time.getTime();
	}
	
	public static double getTime()
	{
		return ((double)System.nanoTime() / (double)Time.SECOND);
	}
	
	public static double getDelta()
	{
		return startTime - lastTime;
	}
}
