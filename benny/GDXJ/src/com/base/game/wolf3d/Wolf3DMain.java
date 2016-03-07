package com.base.game.wolf3d;

import com.base.engine.*;

public class Wolf3DMain
{
	public static void runWolf3D()
	{
		Engine.init(800, 600, "Wolf 3D", false);
		Engine.addResourceDirectory("wolf3d/");

		GameObject test = new GameObject(Mesh.get("cube"), new Material(Texture.get("default.png")));
		Engine.getGame().addObject(test);

		Engine.start();
	}
}
