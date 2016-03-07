package com.base.engine;

public class Debug 
{
	private static final boolean DISPLAY_MESSAGE_LOG = false;
	
	public static void assertError(boolean condition, String errorMessage)
	{
		if(!condition)
		{
			System.err.println(errorMessage);
			//assert(condition);
			System.exit(1);
		}
	}
	
	public static void println(String text)
	{
		if(DISPLAY_MESSAGE_LOG)
			System.out.println(text);
	}
}
