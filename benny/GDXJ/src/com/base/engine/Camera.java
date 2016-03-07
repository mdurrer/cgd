package com.base.engine;


public class Camera
{
	private static final float MAX_LOOK_ANGLE = 89.99f;
	private static final float MIN_LOOK_ANGLE = -89.99f;
	public static final Vector3f yAxis = new Vector3f(0,1,0);
	
	private Vector3f pos;
	private Quaternion rotation;
	private float upAngle = 0;
	
	public Camera()
	{
		this(new Vector3f(0,0,0));
	}
	
	public Camera(Vector3f pos)
	{
		this(pos, new Quaternion(0,0,0,1));
	}
	
	public Camera(Vector3f pos, Quaternion rotation)
	{
		this.pos = pos;
		this.rotation = rotation;
	}

	boolean mouseLocked = false;
	//Vector2f centerPosition = new Vector2f(Window.getWidth()/2, Window.getHeight()/2);
	
	float defaultMoveSpeed = 10;
	
	public void input()
	{
		float sensitivity = 0.5f;
		float movAmt = (float)(defaultMoveSpeed * Time.getDelta());
//		float rotAmt = (float)(100 * Time.getDelta());
		
		if(Input.getKey(Input.KEY_LSHIFT))
			movAmt *= 4;
		if(Input.getKey(Input.KEY_LCONTROL))
			movAmt /= 4;
		if(Input.getMouseWheelMoved())
		{
			final float factor = (float)(Math.sqrt(2)/2.0);
			
			if(Input.getMouseWheelAmount() > 0)
				defaultMoveSpeed *= factor;
			else
				defaultMoveSpeed /= factor;
			//defaultMoveSpeed -= Input.getMouseWheelAmount() / moveIncreaseFactor;
			if(defaultMoveSpeed < 0)
				defaultMoveSpeed = 0;
		}
		
		if(Input.getKey(Input.KEY_ESCAPE))
		{
			Input.setCursor(true);
			mouseLocked = false;
		}
		if(Input.getMouseDown(0))
		{
			Input.setMousePosition(Window.getCenterPosition());
			Input.setCursor(false);
			mouseLocked = true;
		}
		
		if(Input.getKey(Input.KEY_W))
			move(rotation.getForward(), movAmt);
		if(Input.getKey(Input.KEY_S))
			move(rotation.getForward(), -movAmt);
		if(Input.getKey(Input.KEY_A))
			move(rotation.getLeft(), movAmt);
		if(Input.getKey(Input.KEY_D))
			move(rotation.getRight(), movAmt);
		
		if(mouseLocked)
		{
			Vector2f deltaPos = Input.getMousePosition().sub(Window.getCenterPosition());
			
			boolean rotY = deltaPos.getX() != 0;
			boolean rotX = deltaPos.getY() != 0;
			
			if(rotY)
				rotateY(deltaPos.getX() * sensitivity);
			if(rotX)
			{
				float amt = -deltaPos.getY() * sensitivity;
				if(amt + upAngle > -MIN_LOOK_ANGLE)
				{
					rotateX(-MIN_LOOK_ANGLE - upAngle);
					upAngle = -MIN_LOOK_ANGLE;
				}
				else if(amt + upAngle < -MAX_LOOK_ANGLE)
				{
					rotateX(-MAX_LOOK_ANGLE - upAngle);
					upAngle = -MAX_LOOK_ANGLE;
				}
				else
				{
					rotateX(amt);
					upAngle += amt;
				}
			}
				
			if(rotY || rotX)
				Input.setMousePosition(Window.getCenterPosition());
		}
		
//		if(Input.getKey(Input.KEY_UP))
//			rotateX(-rotAmt);
//		if(Input.getKey(Input.KEY_DOWN))
//			rotateX(rotAmt);
//		if(Input.getKey(Input.KEY_LEFT))
//			rotateY(-rotAmt);
//		if(Input.getKey(Input.KEY_RIGHT))
//			rotateY(rotAmt);
	}
	
	public void move(Vector3f dir, float amt)
	{
		pos = pos.add(dir.mul(amt));
	}
	
	public void rotate(Quaternion quaternion)
	{
		rotation = rotation.mul(quaternion).normalized();
	}
	
	public Vector3f getForward()
	{
		return rotation.getForward();
	}
	
	public Vector3f getRight()
	{
		return rotation.getRight();
	}
	
	public Vector3f getUp()
	{
		return rotation.getUp();
	}
	
	public void rotateY(float angle)
	{
		Quaternion newRotation = new Quaternion(yAxis, -angle).normalized();
		
		rotation = rotation.mul(newRotation).normalized();
	}
	
	public void rotateX(float angle)
	{
		Quaternion newRotation = new Quaternion(rotation.getRight(), -angle).normalized();
		
		rotation = rotation.mul(newRotation).normalized();
	}
	
	public Vector3f getPosition()
	{
		return pos;
	}
	
	public Quaternion getRotation()
	{
		return rotation;
	}

	public void setPosition(Vector3f position)
	{
		this.pos = position;
	}
	
	public void setRotation(Quaternion rotation)
	{
		this.rotation = rotation;
	}
}