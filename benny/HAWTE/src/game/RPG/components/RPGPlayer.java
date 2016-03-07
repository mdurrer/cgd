package game.RPG.components;

import game.RPG.RPGGridObject;
import hawte.*;

import java.awt.*;
import java.awt.event.KeyEvent;
import java.util.Random;

/**
 * RPG Player
 */
public class RPGPlayer extends RPGGridComponent
{
	public static final int MOVE_DELAY_MILLI = 200;
	public static final int MOVE_DELAY_NANO = MOVE_DELAY_MILLI * 1000000;
	public static final int MIN_STEPS_TO_RANDOM_BATTLE = 1;//8;
	public static final int RANDOM_BATTLE_CHANCE = 1;//32;
	private int newX = 0;
	private int newY = 0;
	private boolean moved = false;
	private boolean triedRandomBattle = true;
	private boolean lastMoveSucceeded = false;
	private Delay moveDelay;
	private long lastMoveTime = 0;
	private Vector2d startCornerPos;
	private Vector2d displayPos;
	private Random rand;
	private int numStepsToRandomBattle = 0;

	@Override
	public void init(GameObject parent)
	{
		super.init(parent);
		setColor(Color.RED);
		moveDelay = new Delay(MOVE_DELAY_MILLI);
		displayPos = new Vector2d(0,0);
		rand = new Random();
		calcStepsToRandomBattle();
	}

	private void calcStepsToRandomBattle()
	{
		numStepsToRandomBattle = rand.nextInt(RANDOM_BATTLE_CHANCE) + MIN_STEPS_TO_RANDOM_BATTLE;
	}

	private void move(int x, int y)
	{
		if(moveDelay.isOver())
		{
			lastMoveTime = System.nanoTime();
			newY += y;
			newX += x;
			moved = true;
			triedRandomBattle = false;
			startCornerPos = getGridCornerPos();
		}
	}

	@Override
	public void input(Input input)
	{
		RPGGridObject object = getGameObject();
		newX = object.getX();
		newY = object.getY();
		moved = false;

		if(input.getKey(KeyEvent.VK_W) || input.getKey(KeyEvent.VK_UP))
			move(0, -1);//newY--;
		if(input.getKey(KeyEvent.VK_S) || input.getKey(KeyEvent.VK_DOWN))
			move(0, 1);//newY++;
		if(input.getKey(KeyEvent.VK_A) || input.getKey(KeyEvent.VK_LEFT))
			move(-1, 0);//newX--;
		if(input.getKey(KeyEvent.VK_D) || input.getKey(KeyEvent.VK_RIGHT))
			move(1, 0);//newX++;

		if(moved && moveDelay.isOver())
			moveDelay.restart();


	}

	private boolean moveIfNotBlocking(int x, int y)
	{
		if(getGameObject().getGrid().isBlocking(x, y) || (x == getGameObject().getX() && y == getGameObject().getY()))
			return false;

		getGameObject().setX(x);
		getGameObject().setY(y);

		return true;
	}

	private void checkRandomBattle()
	{
		if(--numStepsToRandomBattle == 0)
		{
			Game game = getGameObject().getGame();

			//TODO: Actual random battle
			RPGBattle battle = new RPGBattle();
			game.addObject(new RPGGridObject(new Transform(), game).addComponent(battle));
			battle.addBattleCharacter(new RPGBattleCharacter().setColor(Color.RED));
			battle.addBattleCharacter(new RPGBattleCharacter().setColor(Color.CYAN));


			game.removeObject(getGameObject().getGrid());
			//System.out.println("Random battle!");
			calcStepsToRandomBattle();
		}

		triedRandomBattle = true;
	}

	@Override
	public void update(double delta)
	{
		RPGGridObject object = getGameObject();

		if(object.getX() != newX || object.getY() != newY)
		{
			lastMoveSucceeded = moveIfNotBlocking(newX, newY);

			if(!lastMoveSucceeded)
				lastMoveSucceeded = moveIfNotBlocking(object.getX(), newY);
			if(!lastMoveSucceeded)
				lastMoveSucceeded = moveIfNotBlocking(newX, object.getY());
		}

		calcDisplayPos();

		if(!triedRandomBattle && lastMoveSucceeded && moveDelay.isOver())
			checkRandomBattle();
	}

	private void calcDisplayPos()
	{
		long currentTime = System.nanoTime();
		if(currentTime > (lastMoveTime + MOVE_DELAY_NANO))
			displayPos = getGridCornerPos();
		else
		{
			double lerpAmount = ((double)(currentTime - lastMoveTime))/((double) MOVE_DELAY_NANO);
			displayPos = startCornerPos.lerp(getGridCornerPos(), lerpAmount);
		}

		Vector2d halfWindowSize = new Vector2d(getGameObject().getGame().getWidth() / 2, getGameObject().getGame().getHeight() / 2);
		getGameObject().getGrid().getTransform().setPos(displayPos.mul(-1).add(halfWindowSize));
	}

	@Override
	public void render(Graphics g)
	{
		drawAtGridPos(g, displayPos);
	}
}
