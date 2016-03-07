package game;

import hawte.Game;
import hawte.Input;
import hawte.Vector2d;

import javax.imageio.ImageIO;
import java.awt.*;
import java.awt.event.KeyEvent;
import java.awt.event.MouseEvent;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;

public class TestGame extends Game
{
	private BufferedImage image;
	private Vector2d textPos;
	private Vector2d imagePos;

	@Override
	public void init()
	{
		textPos = new Vector2d(50,100);
		imagePos = new Vector2d(0,0);

		try
		{
			image = ImageIO.read(new File("./res/test.png"));
		}
		catch(IOException e)
		{
			e.printStackTrace();
		}
	}

	@Override
	public void input(Input input)
	{
		if(input.getKey(KeyEvent.VK_UP))
			textPos.setY(textPos.getY() - 1);
		if(input.getKey(KeyEvent.VK_DOWN))
			textPos.setY(textPos.getY() + 1);
		if(input.getKey(KeyEvent.VK_LEFT))
			textPos.setX(textPos.getX() - 1);
		if(input.getKey(KeyEvent.VK_RIGHT))
			textPos.setX(textPos.getX() + 1);

		if(input.getMouse(MouseEvent.BUTTON1))
			imagePos.set(input.getMouseX() - image.getWidth() / 2, input.getMouseY() - image.getHeight() / 2);
	}

	@Override
	public void update(double delta)
	{

	}

	@Override
	public void render(Graphics g)
	{
		g.drawImage(image, (int)imagePos.getX(), (int)imagePos.getY(), null);

		g.setColor(Color.BLUE);
		g.setFont(new Font("Monospaced", 0, 100));
		g.drawString("Hello World!", (int)textPos.getX(), (int)textPos.getY());
	}
}
