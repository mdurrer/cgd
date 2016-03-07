package com.base.game.test;

import com.base.engine.*;

public class Test
{
	public static void runTest()
	{
		Engine.init(800, 600, "3D Engine", false);
		Engine.addResourceDirectory("test/");

		Material bricks = new Material(Texture.get("color_map.jpg"), new Vector3f(1,1,1), 1, 8);
		bricks.setNormalTexture(Texture.get("normal_map.jpg"));
		bricks.setBumpTexture(Texture.get("height_map.jpg"));
		bricks.setSpecularIntensity(0.25f);
		bricks.setSpecularPower(1);
		
		GameObject cube = new GameObject(Mesh.get("cube"), bricks);
		cube.addComponent(new ChaseComponent());
		cube.getTransform().move(new Vector3f(0,-0.5f,2));
		cube.getTransform().rotate(new Vector3f(0,30,0));
		cube.getTransform().scale(new Vector3f(12,7,5));
		
		GameObject cube2 = new GameObject(Mesh.get("cube"), bricks);
		//cube.addComponent(new ChaseComponent());
		cube2.getTransform().move(new Vector3f(3,-0.5f,7));
		cube2.getTransform().rotate(new Vector3f(0,-30,0));
		
		GameObject floor = new GameObject(Mesh.get("plane"), Material.getDefaultMaterial());
		floor.getTransform().scale(30);
		floor.setCastShadows(false);
		floor.getTransform().move(new Vector3f(0,-1,3));
		
		Engine.getGame().addObject(cube);
		Engine.getGame().addObject(cube2);
		Engine.getGame().addObject(floor);
		
//		Engine.getRenderer().setDirectionalLight(new DirectionalLight(Vector3f.ZERO, 0, Vector3f.ZERO));
//		Engine.getRenderer().setSpotLights(new SpotLight[] {new SpotLight(new PointLight(new BaseLight(new Vector3f(0,1f,1f), 0.8f), new Attenuation(0,0,0.3f), new Vector3f(-2,0.5f,5f), 30),
//									  new Vector3f(1,-1,-1), 0.7f)});
		
		Engine.start();
	}
}
