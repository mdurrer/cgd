package hawte;

import javax.swing.*;
import java.awt.*;
import java.awt.image.BufferStrategy;

/**
 * Handy Abstract Window Toolkit Engine primary class.
 */
public class GameEngine extends Canvas implements Runnable
{
	private boolean isRunning;
	private double frameTime;
	private Game game;
	private Input input;
	private Thread thread;

	public GameEngine(int width, int height, int frameRate, Game game)
	{
		Dimension size = new Dimension(width - 10, height - 10);

		setMaximumSize(size);
		setMinimumSize(size);
		setPreferredSize(size);
		setSize(size);

		this.isRunning = false;
		this.frameTime = 1.0 / frameRate;
		this.game = game;
		this.input = new Input();

		addKeyListener(input);
		addFocusListener(input);
		addMouseListener(input);
		addMouseMotionListener(input);

		game.updateEngineParameters(width, height);
	}

	public JFrame createWindow(String title)
	{
		JFrame frame = new JFrame();
		frame.add(this);
		frame.pack();

		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		frame.setResizable(false);
		frame.setLocationRelativeTo(null);
		frame.setTitle(title);
		frame.setVisible(true);

		return frame;
	}

	public void start()
	{
		if(isRunning) return;

		isRunning = true;
		thread = new Thread(this);
		thread.start();
	}

	public void stop()
	{
		if(!isRunning) return;

		isRunning = false;
		try
		{
			thread.join();
		}
		catch(Exception ex){ex.printStackTrace();}
	}

	public void run()
	{
		isRunning = true;
		double unprocessedSeconds = 0;
		long lastTime = System.nanoTime();

		game.init();
		//Starts rendering process immediately
		render();
		render();

		while(isRunning)
		{
			boolean render = false;

			long now = System.nanoTime();
			long passedTime = now - lastTime;
			lastTime = now;

			unprocessedSeconds += passedTime / (1000000000.0);

			while(unprocessedSeconds > frameTime)
			{
				render = true;

				input.update(frameTime);
				game.input(input);
				game.update(frameTime);

				unprocessedSeconds -= frameTime;
			}

			if(render)
			{
				render();
			}
			else
			{
				try
				{
					Thread.sleep(1);
				}
				catch(InterruptedException e)
				{
					e.printStackTrace();
				}
			}
		}
	}

	private void render()
	{
		BufferStrategy bs = getBufferStrategy();
		if(bs == null)
		{
			createBufferStrategy(3);
			return;
		}

		Graphics g = bs.getDrawGraphics();
		g.setColor(Color.BLACK);
		g.fillRect(0, 0, getWidth(), getHeight());
		g.setColor(Color.WHITE);

		game.render(g);

		g.dispose();
		bs.show();
	}
}
