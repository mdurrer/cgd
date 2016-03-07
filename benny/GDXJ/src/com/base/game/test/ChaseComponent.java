package com.base.game.test;

import com.base.engine.*;

public class ChaseComponent extends Component
{	
	@Override
	public void input()
	{
		final float angle = 10f;
		
		if(Input.getKeyDown(Input.KEY_1))
			Window.setMaximized(!Window.isMaximized());
		if(Input.getKeyDown(Input.KEY_2))
			Window.setResizable(!Window.isResizable());
		if(Input.getKeyDown(Input.KEY_3))
			Window.setFullscreen(!Window.isFullscreen());
		
		DirectionalLight light = Engine.getRenderingEngine().getDirectionalLight();
		
		if(Input.getKeyDown(Input.KEY_R))
			light.setDirection(light.getDirection().rotate(angle, Vector3f.RIGHT));
		if(Input.getKeyDown(Input.KEY_T))
			light.setDirection(light.getDirection().rotate(angle, Vector3f.UP));
		if(Input.getKeyDown(Input.KEY_Y))
			light.setDirection(light.getDirection().rotate(angle, Vector3f.FORWARD));
		
		if(Input.getKeyDown(Input.KEY_F))
			light.setDirection(light.getDirection().rotate(-angle, Vector3f.RIGHT));
		if(Input.getKeyDown(Input.KEY_G))
			light.setDirection(light.getDirection().rotate(-angle, Vector3f.UP));
		if(Input.getKeyDown(Input.KEY_H))
			light.setDirection(light.getDirection().rotate(-angle, Vector3f.FORWARD));
	}
	
	@Override
	public void update()
	{
//		DirectionalLight light = Engine.getRenderer().getDirectionalLight();
//		light.setDirection(Transform.getCamera().getRight());
//		Transform transform = getObject().getTransform();
//		
//		Vector3f directionToCamera = Transform.getCamera().getPosition().sub(transform.getPosition()).normalized();
//		
//		if(directionToCamera.lengthSquared() > 0)
//			transform.move(directionToCamera.mul((float)this.getUpdateDelta()));
//		
//		transform.lookAt(Transform.getCamera().getPosition());
		
//		Transform.getCamera().setRotation(new Quaternion(new Vector3f(0,-1,-1).normalized()));
//		System.out.println("Pos:" + Transform.getCamera().getPosition() + " Rotation:" + Transform.getCamera().getRotation());
//		Camera temp = new Camera(new Vector3f(0,0,0), new Quaternion(Engine.getRenderer().getDirectionalLight().getDirection()));
//		System.out.println("Vs: Pos:" + temp.getPosition() + " Rotation:" + temp.getRotation());
		
		
//		SpotLight temp = Engine.getRenderer().getSpotLights()[0];
//		temp.setDirection(Transform.getCamera().getForward());
//		temp.getPointLight().setPosition(Transform.getCamera().getPosition());
	}
}
