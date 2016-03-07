package game.pong.components;

import hawte.GameComponent;
import hawte.Vector2d;

/**
 * The AI Paddle
 */
public class PongEnemy extends PongPaddle
{
	public static final double AI_MOVE_SPEED = MOVE_SPEED * 1;//1.3;
	public static final double FAULT_TOLERANCE_FACTOR = 20;

	private PongBall ball;
	private double bounceSpace = 0;

	@Override
	public void update(double delta)
	{
		if(ball == null)
		{
			GameComponent[] components = getGameObject().getGame().findAllComponents(PongBall.class);
			ball = (PongBall)components[0];
			bounceSpace = getGameObject().getGame().getHeight() - PongBall.SIZEY * 2;
		}

		if(ball.getVelocity().getX() < 0)
		{
//			Vector2d directionToBall = ball.getTransform().getPos().sub(getTransform().getPos());
//
//			if(Math.abs(directionToBall.getY()) > delta * 10)
//			{
//				if(directionToBall.getY() > 0)
//					getVelocity().setY(AI_MOVE_SPEED);
//				else
//					getVelocity().setY(-AI_MOVE_SPEED);
//			}
//			else
//				getVelocity().setY(ball.getVelocity().getY());

			double centerPos = getGameObject().getGame().getHeight() / 2;
			double centerDifference = centerPos - getTransform().getPos().getY();

			if(Math.abs(centerDifference) > delta * FAULT_TOLERANCE_FACTOR)
			{
				if(centerDifference > 0)
					getVelocity().setY(AI_MOVE_SPEED);
				else
					getVelocity().setY(-AI_MOVE_SPEED);
			}
			else
				getVelocity().setY(0);
		}
		else
		{
			Vector2d ballVelocity = ball.getVelocity();
			Vector2d ballPos = ball.getTransform().getPos();
			double xCollisionPos = getTransform().getPos().getX() - getTransform().getScale().getX();
			double xCollisionDistance = xCollisionPos - ballPos.getX();

			double timeToCollision = xCollisionDistance / ballVelocity.getX();

			Vector2d ballCollisionPos = ballPos.add(ballVelocity.mul(timeToCollision));

			double yCollisionPos = ballCollisionPos.getY();
			double yCollisionCounter = yCollisionPos;

			int numBounces = 0;
			while(yCollisionCounter < 0)
			{
				yCollisionCounter += bounceSpace;
				numBounces++;
			}

			while(yCollisionCounter > getGameObject().getGame().getHeight())
			{
				yCollisionCounter -= bounceSpace;
				numBounces++;
			}

			if(numBounces % 2 == 1)
				yCollisionCounter = bounceSpace - yCollisionCounter;

			yCollisionPos = yCollisionCounter;

			//(int)(yCollisionPos / bounceSpace);
			//System.out.println(yCollisionPos + " " + numBounces);
			//yCollisionPos = (double)(((int)yCollisionPos) % (int)bounceSpace);
			//System.out.println(", " + yCollisionPos);

			double yPositionDifference = getTransform().getPos().getY() - yCollisionPos;

			if(Math.abs(yPositionDifference) > delta * FAULT_TOLERANCE_FACTOR)
			{
				if(yPositionDifference < 0)
					getVelocity().setY(AI_MOVE_SPEED);
				else
					getVelocity().setY(-AI_MOVE_SPEED);
			}
			else
				getVelocity().setY(0);
		}

		if(getVelocity().getY() > AI_MOVE_SPEED)
			getVelocity().setY(AI_MOVE_SPEED);
		else if(getVelocity().getY() < -AI_MOVE_SPEED)
			getVelocity().setY(-AI_MOVE_SPEED);

//		double acceleration = directionToBall.getY() * DAMPING;
//
//		getVelocity().incY(acceleration);
//
//		if(getVelocity().getY() > AI_MOVE_SPEED)
//			getVelocity().setY(AI_MOVE_SPEED);
//		else if(getVelocity().getY() < -AI_MOVE_SPEED)
//			getVelocity().setY(-AI_MOVE_SPEED);
	}
}
