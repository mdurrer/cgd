package com.base.engine;

import static org.lwjgl.opengl.GL11.*;
import static org.lwjgl.opengl.GL14.*;
import static org.lwjgl.opengl.GL30.*;
import static org.lwjgl.opengl.GL32.*;

import java.awt.image.BufferedImage;
import java.io.File;
import java.nio.ByteBuffer;
import java.nio.FloatBuffer;
import java.util.HashMap;

import javax.imageio.ImageIO;

public class Texture
{
	public static final String DIRECTORY = "textures/";

    //TODO: Make texture constants dynamic (aka hashmap territory)
	public static final Texture WHITE_PIXEL = new Texture(1, 1, (ByteBuffer)Util.createByteBuffer(4).put(new byte[]{(byte) 0xFF,(byte) 0xFF,(byte) 0xFF,(byte) 0xFF}).flip());
	public static final Texture NORMAL_UP = new Texture(1, 1, (ByteBuffer)Util.createByteBuffer(4).put(new byte[]{(byte) 0x80,(byte) 0x7F,(byte) 0xFF,(byte) 0xFF}).flip()); 
	public static final int DIFFUSE_TEXTURE = 0;
	public static final int NORMAL_TEXTURE = 1;
	public static final int HEIGHT_TEXTURE = 2;
	public static final int SHADOW_TEXTURE_0 = 4;
	public static final int SHADOW_TEXTURE_1 = 5;
	public static final int SHADOW_TEXTURE_2 = 6;
	public static final int SHADOW_TEXTURE_3 = 7;

    private static final HashMap<String, Texture> textures = new HashMap<String, Texture>();

	private static int lastWriteBind = 0;
	private int id;
	private int frameBuffer;
	private int width;
	private int height;

    public int getID(){ return id; }
    public int getWidth()
    {
        return width;
    }
    public int getHeight()
    {
        return height;
    }

    public static Texture get(String name)
    {
        if(textures.containsKey(name))
            return textures.get(name);
        else
        {
            textures.put(name, new Texture(name));
            return textures.get(name);
        }
    }

	public Texture(int width, int height, FloatBuffer data, int filter, int wrapMode)
	{
		int textureID = glGenTextures(); // Generate texture ID
		glBindTexture(GL_TEXTURE_2D, textureID); // Bind texture ID
		
		// Setup wrap mode (GL_CLAMP | GL_REPEAT)
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, wrapMode);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, wrapMode);

		// Setup texture scaling filtering (GL_LINEAR | GL_NEAREST)
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, filter);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, filter);

		// Send texture to graphics card
		glTexImage2D(GL_TEXTURE_2D, 0, GL_DEPTH_COMPONENT16, width, height, 0, GL_DEPTH_COMPONENT, GL_FLOAT, data);

		this.id = textureID;
		this.frameBuffer = 0;
		this.width = width;
		this.height = height;
	}
	
	private Texture(int width, int height, ByteBuffer data)
	{
		this(width, height, data, GL_LINEAR, GL_REPEAT);
	}

    //TODO: Make proper parameters for texture constructor!
	private Texture(int width, int height, ByteBuffer data, int filter, int wrapMode)
	{
		this.width = width;
		this.height = height;
        this.id = Engine.getRenderer().createTexture(width, height, data, true, true);
        this.frameBuffer = 0;
	}
	
	private Texture(String fileName)
	{
		try
		{
			BufferedImage image = ImageIO.read(new File(Engine.getResourcePath(DIRECTORY + fileName)));

			boolean hasAlpha = image.getColorModel().hasAlpha();

			int[] pixels = image.getRGB(0, 0, image.getWidth(),
			image.getHeight(), null, 0, image.getWidth());

			ByteBuffer buffer = Util.createByteBuffer(image.getWidth() * image.getHeight() * 4);

			for (int y = 0; y < image.getHeight(); y++) 
			{
				for (int x = 0; x < image.getWidth(); x++) 
				{
					int pixel = pixels[y * image.getWidth() + x];
		
					buffer.put((byte) ((pixel >> 16) & 0xFF));
					buffer.put((byte) ((pixel >> 8) & 0xFF));
					buffer.put((byte) ((pixel >> 0) & 0xFF));
					if (hasAlpha)
						buffer.put((byte) ((pixel >> 24) & 0xFF));
					else
						buffer.put((byte) (0xFF));
				}
			}

			buffer.flip();

			this.width = image.getWidth();
			this.height = image.getHeight();
            this.id = Engine.getRenderer().createTexture(width, height, buffer, true, true);
            this.frameBuffer = 0;
		}
		catch(Exception e)
		{
			e.printStackTrace();
			System.exit(1);
		}
	}
	
	public void initRenderTarget(int attachment, boolean bind)
	{
		frameBuffer = glGenFramebuffers();
		glBindFramebuffer(GL_FRAMEBUFFER, frameBuffer);
		glFramebufferTexture(GL_FRAMEBUFFER, attachment, id, 0);
		
		if(attachment == GL_DEPTH_ATTACHMENT)
			glDrawBuffer(GL_NONE);
		if(glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE)
		{
			System.err.println("Shadow framebuffer creation has failed");
			new Exception().printStackTrace();
			System.exit(1);
		}
		
		if(bind)
		{
			lastWriteBind = frameBuffer;
			glViewport(0,0,width,height);
		}
		else
			glBindFramebuffer(GL_FRAMEBUFFER, lastWriteBind);
	}
	
	public void bind(int unit)
	{
		Engine.getRenderer().bindTexture(id, unit);
	}
	
	public void bindAsRenderTarget()
	{
		if(lastWriteBind != frameBuffer)
		{
			glBindFramebuffer(GL_FRAMEBUFFER, frameBuffer);
			lastWriteBind = frameBuffer;
			glViewport(0,0,width,height);
		}
	}
	
	public static void unbind()
	{
		glBindTexture(GL_TEXTURE_2D, 0);
	}
	
	public static void unbindRenderTarget()
	{
		glBindFramebuffer(GL_FRAMEBUFFER, 0);
		glViewport(0,0,Window.getWidth(),Window.getHeight());
	}
}
