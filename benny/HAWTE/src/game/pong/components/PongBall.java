package game.pong.components;

import hawte.*;

import javax.sound.sampled.Clip;
import java.awt.*;
import java.util.Random;

/**
 * The Pong Ball
 */
public class PongBall extends PongComponent
{
	public static final int SIZEX = 16;
	public static final int SIZEY = SIZEX;
	public static final double PACE_FACTOR = 1.75;
	public static final double MAX_SPEEDX = 160 * PACE_FACTOR;
	public static final int FONT_SIZE = 100;
	public static final int FONT_OFFSET_CONSTANT = (int)(FONT_SIZE * 0.6);
	public static final double BALL_CATCH_SCALE = 0.25;
	public static final double SPEED_CHANGE_ON_BOUNCE = 1.05;
	public static final double ERROR_FACTOR = 2 * PACE_FACTOR;
	public static final int MAX_START_ANGLE = 10;

	private Vector2d initialPosition;
	private Font scoreFont;
	private int playerScore;
	private int enemyScore;

	private Clip hitPaddleSound;
	private Clip hitWallSound;
	private Clip resetSound;

	private void initState(double amt)
	{
		getVelocity().setX(MAX_SPEEDX * amt);
		getVelocity().setY(0);
		getGameObject().getTransform().setPos(new Vector2d(initialPosition));

		if(amt < 0)
			playerScore++;
		else
			enemyScore++;

		AudioUtil.playAudio(resetSound, 0);

		Random rand = new Random();
		getVelocity().set(getVelocity().rotate(Math.toRadians(rand.nextInt(MAX_START_ANGLE * 2) - MAX_START_ANGLE)));
	}

	@Override
	public void init(GameObject gameObject)
	{
		super.init(gameObject);
		initialPosition = new Vector2d(getGameObject().getTransform().getPos());
		hitPaddleSound = AudioUtil.loadAudio("./res/pong/beep.wav", true);
		hitWallSound = AudioUtil.loadAudio("./res/pong/plop.wav", true);
		resetSound = AudioUtil.loadAudio("./res/pong/peep.wav", true);
		initState(-1.0);
		playerScore = 0;
		enemyScore = 0;
	}

	@Override
	public void update(double delta)
	{
		Transform transform = getGameObject().getTransform();
		Game game = getGameObject().getGame();

		if(transform.getPos().getX() > game.getWidth())
			initState(-1.0);
		else if(transform.getPos().getX() < 0)
			initState(1.0);

		keepBallFromGlitchingPastTheWalls();
	}

	private void keepBallFromGlitchingPastTheWalls()
	{
		Transform transform = getGameObject().getTransform();
		Game game = getGameObject().getGame();

		if(Math.abs(getVelocity().getX()) < MAX_SPEEDX / ERROR_FACTOR)
		{
			double angle = Math.toRadians(10);

			if(getVelocity().getX() < 0)
			{
				angle = -angle;
				if(getVelocity().getY() > 0)
					angle = -angle;
			}

			getVelocity().set(getVelocity().rotate(angle));
		}

		//Catch the ball if it's out of screen
		if(transform.getPos().getY() > (game.getHeight() * (1.0 + BALL_CATCH_SCALE)) || transform.getPos().getY() < -game.getHeight() * BALL_CATCH_SCALE)
		{
			double initAmt = 1.0;
			int lastPlayerScore = playerScore;
			int lastEnemyScore = enemyScore;

			if(getVelocity().getX() < 0)
				initAmt *= -1;

			initState(initAmt);
			playerScore = lastPlayerScore;
			enemyScore = lastEnemyScore;
		}
	}

	@Override
	public void render(Graphics g)
	{
		if(scoreFont == null)
			scoreFont = new Font("Monospaced", 0, FONT_SIZE);
		g.setFont(scoreFont);

		String scoreText = playerScore + " " + enemyScore;
		//g.fillRect(getGameObject().getGame().getWidth() / 2 - 8, 0, 16, getGameObject().getGame().getHeight());
		g.drawString(scoreText, getGameObject().getGame().getWidth() / 2 - (scoreText.length() * FONT_OFFSET_CONSTANT) / 2, 100);

		super.render(g);
	}

	@Override
	public void onCollision(Contact contact, PhysicsComponent collidedWith)
	{
		double offsetAngle = 0;

		if(collidedWith instanceof PongPlayer || collidedWith instanceof PongEnemy)
		{
			AudioUtil.playAudio(hitPaddleSound, 0);
			Transform myTransform = getGameObject().getTransform();
			Transform otherTransform = collidedWith.getGameObject().getTransform();

			double difference = myTransform.getPos().getY() - otherTransform.getPos().getY();
			difference /= (PongPaddle.SIZEY / 2);

			offsetAngle = 45 * difference;
		}
		else
			AudioUtil.playAudio(hitWallSound, 0);

		bounce(contact, SPEED_CHANGE_ON_BOUNCE, Math.toRadians(offsetAngle));
	}
}
