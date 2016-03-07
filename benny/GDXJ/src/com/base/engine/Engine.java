package com.base.engine;

import java.io.File;
import java.util.ArrayList;

public class Engine
{
	private static final String RESOURCE_DIRECTORY = "res/";
	private static final String DEFAULT_RESOURCES = "default/";

	private static ArrayList<String> directories = new ArrayList<String>();
	private static boolean isRunning = false;
	private static Game game;
	private static RenderingEngine renderingEngine;
	private static Renderer renderer;
	
	public static Game getGame(){return game;}
	public static RenderingEngine getRenderingEngine(){return renderingEngine;}
	public static Renderer getRenderer() {return renderer;}
	
	public static void setGame(Game game){Engine.game = game;}
	public static void setRenderingEngine(RenderingEngine renderer){Engine.renderingEngine = renderer;}
	
	public static void init(int width, int height, String title, boolean fullscreen)
	{
		renderer = new Renderer();
		addResourceDirectory(DEFAULT_RESOURCES);

		Engine.game = new Game();
		Engine.renderingEngine = new RenderingEngine();
		Window.createWindow(width, height, title);
		renderingEngine.initGraphics();
		renderingEngine.init();
	}

	public static void addResourceDirectory(String directoryName)
	{
		directories.add(directoryName);
	}

	public static String getResourcePath(String pathFromDirectory)
	{
		for(String path : directories)
		{
			String result = "./" + Engine.RESOURCE_DIRECTORY + path + pathFromDirectory;
			if(new File(result).exists())
				return result;
		}

		return null;
	}
	
	public static void start()
	{
		if(isRunning)
			return;
		
		run();
	}
	
	public static void stop()
	{
		if(!isRunning)
			return;
		
		isRunning = false;
	}
	
	private static void run()
	{
		isRunning = true;
		
		int frames = 0;
		double frameCounter = 0;
		
		Time.init();
		
		while(isRunning)
		{
			frameCounter += Time.getDelta();
			
			if(Window.isCloseRequested())
				stop();
				
			Window.update();
			game.input();
			Input.update();
				
			game.update();
				
			if(frameCounter >= 1.0)
			{
				System.out.println(frames + ": " + 1000.0f/frames + "ms");
				frames = 0;
				frameCounter = 0;
			}
			
			renderingEngine.clearScreen();
			game.render();
			Window.render();
			frames++;
			
			Time.tick();
		}
		
		cleanUp();
	}
	
	private static void cleanUp()
	{
		Window.dispose();
	}
}
