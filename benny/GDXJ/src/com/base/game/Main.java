package com.base.game;

import com.base.game.test.Test;
import com.base.game.wolf3d.Wolf3DMain;

public class Main
{
	private static final int PROGRAM = 1;

    public static void main(String[] args)
    {
		switch(PROGRAM)
		{
			case 0:
				Test.runTest();
				break;
			case 1:
				Wolf3DMain.runWolf3D();
				break;
		}
	}
}
