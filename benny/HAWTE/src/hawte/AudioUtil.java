package hawte;

import javax.sound.sampled.*;
import java.io.File;

/**
 * TODO: Refactor into a non-static system
 */
public class AudioUtil
{
	private static final float AUDIO_VOLUME = -5.0f;
	private static final float DECAY_FACTOR = 0.12f;

	public static void playAudio(Clip clip, float distance)
	{
		FloatControl volume = (FloatControl) clip.getControl(FloatControl.Type.MASTER_GAIN);

		float volumeAmount = AUDIO_VOLUME - (distance * distance * DECAY_FACTOR);

		if(volumeAmount < -80)
			volumeAmount = -80;

		volume.setValue(volumeAmount);

		if(clip.isRunning())
			clip.stop();

		clip.setFramePosition(0);
		clip.start();
	}

	public static Clip loadAudio(String fileName, boolean isInJar)
	{
		Clip clip = null;
		AudioInputStream stream;
		try
		{
			if(!isInJar)
				 stream = AudioSystem.getAudioInputStream(new File(fileName));
			else
				stream = AudioSystem.getAudioInputStream(AudioUtil.class.getResource(fileName.substring(1)));

			clip = (Clip) AudioSystem.getLine(new DataLine.Info(Clip.class, stream.getFormat()));
			clip.open(stream);

			return clip;
		}
		catch (Exception e)
		{
			e.printStackTrace();
			System.exit(1);
		}

		return clip;
	}
}
