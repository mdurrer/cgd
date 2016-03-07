package game.pong;

import game.pong.components.*;
import hawte.Game;
import hawte.GameObject;
import hawte.Transform;
import hawte.Vector2d;

/**
 * Game of Pong for HAWTE
 */
public class Pong extends Game
{
	@Override
	public void init()
	{
//		this.addObject(new GameObject(new Transform(new Vector2d(this.getWidth() / 2,this.getHeight() / 2),
//													new Vector2d(PongBall.SIZEX / 2, PongBall.SIZEY / 2), 0),
//									  this).addComponent(new PongBall()));
//
//		this.addObject(new GameObject(new Transform(new Vector2d(PongPaddle.SIZEX / 2, this.getHeight() / 2),
//													new Vector2d(PongPaddle.SIZEX / 2, PongPaddle.SIZEY / 2), 0),
//									  this).addComponent(new PongPlayer()));
//
//		this.addObject(new GameObject(new Transform(new Vector2d(this.getWidth() - PongPaddle.SIZEX / 2, this.getHeight() / 2),
//													new Vector2d(PongPaddle.SIZEX / 2, PongPaddle.SIZEY / 2), 0),
//									  this).addComponent(new PongEnemy()));
//
//		this.addObject(new GameObject(new Transform(new Vector2d(this.getWidth() / 2, PongBall.SIZEY / 2),
//													new Vector2d(this.getWidth() / 2, PongBall.SIZEY / 2), 0),
//									  this).addComponent(new PongWall()));
//
//		this.addObject(new GameObject(new Transform(new Vector2d(this.getWidth() / 2, this.getHeight() - PongBall.SIZEY / 2),
//													new Vector2d(this.getWidth() / 2, PongBall.SIZEY / 2), 0),
//									  this).addComponent(new PongWall()));
//		saveScene("./res/pong/main_new.scn");

		loadScene("./res/pong/main.scn", true);
	}
}
