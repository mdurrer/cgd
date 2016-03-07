package game;

import game.RPG.RPGGame;
import game.pong.Pong;
import hawte.GameEngine;

import java.applet.Applet;
import java.awt.*;

/**
 * Applet/Main Class example
 */
public class Main extends Applet
{
	private static final long serialVersionUID = 1L;
	private static GameEngine gameEngine = new GameEngine(800, 600, 60, new RPGGame());

	public void init()
	{
		setLayout(new BorderLayout());
		add(gameEngine, BorderLayout.CENTER);
	}

	public void start()
	{
		gameEngine.start();
	}

	public void stop()
	{
		gameEngine.stop();
	}

	public static void main(String[] args)
	{
		gameEngine.createWindow("RPG");
		gameEngine.start();
	}
}
