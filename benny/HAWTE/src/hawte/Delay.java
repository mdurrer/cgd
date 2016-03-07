package hawte;

/**
 * Created by batman_2 on 12/23/13.
 */
public class Delay
{
	private final int length;
	private long endTime;

	public Delay(int length)
	{
		this.length = length;
		endTime = 0;
	}

//	public boolean testAndRestart()
//	{
//		boolean result = isOver();
//
//		if(result)
//			restart();
//
//		return result;
//	}

	public boolean isOver()
	{
		return System.nanoTime() >= endTime;
	}

	public void restart()
	{
		endTime = length * 1000000 + System.nanoTime();
	}
}
