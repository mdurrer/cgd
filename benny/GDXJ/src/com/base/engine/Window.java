package com.base.engine;

import java.awt.Canvas;
import java.awt.Dimension;
import java.awt.GraphicsDevice;
import java.awt.GraphicsEnvironment;
import java.awt.Toolkit;
import java.awt.event.ComponentAdapter;
import java.awt.event.ComponentEvent;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import javax.swing.JFrame;
import javax.swing.JOptionPane;

import org.lwjgl.LWJGLException;
import org.lwjgl.input.Keyboard;
import org.lwjgl.input.Mouse;
import org.lwjgl.opengl.Display;
import org.lwjgl.opengl.DisplayMode;
import static org.lwjgl.opengl.GL11.*;


public class Window 
{
	private static boolean isCreated = false;
	private static JFrame frame;
	private static boolean isResized = false;
	private static boolean isCloseRequested = false;
	private static boolean isResizedReturn = false;
	private static boolean isFullscreen = false;
	private static boolean setTransformSizeOnWindowResize = true;
	
	public static void createWindow(int width, int height, String title)
	{
		frame = new JFrame(title);
		frame.setSize(width,height);
		frame.setLocationRelativeTo(null);
		frame.addWindowListener(new WindowAdapter() 
		{	
        	@Override
        	public void windowClosing(WindowEvent e) 
        	{
        		isCloseRequested = true;
        	}
        });
		
//		frame.addWindowStateListener(new WindowStateListener()
//		{
//			@Override
//			public void windowStateChanged(WindowEvent e)
//			{
//				if(!isCreated)
//					return;
//				//System.out.println("Window state changed!");
//	            int oldState = e.getOldState();
//	            int newState = e.getNewState();
//	
//	            if ((oldState & JFrame.ICONIFIED) == 0 && (newState & JFrame.ICONIFIED) != 0) 
//	            {
//	            	System.out.println("Frame was iconized");
//	            } 
//	            else if ((oldState & JFrame.ICONIFIED) != 0 && (newState & JFrame.ICONIFIED) == 0) 
//	            {
//	            	System.out.println("Frame was deiconized");
//	            }
//	
//	            if ((oldState & JFrame.MAXIMIZED_BOTH) == 0 && (newState & JFrame.MAXIMIZED_BOTH) != 0) 
//	            {
//	            	//System.out.println("Frame was maximized!");
//	            	isMaximized = true;
//	            } 
//	            else if ((oldState & JFrame.MAXIMIZED_BOTH) != 0 && (newState & JFrame.MAXIMIZED_BOTH) == 0) 
//	            {
//	            	//System.out.println("Frame was minimized!");
//	            	isMaximized = false;
//	            }
//				
//			}
//			
//		});

		frame.addComponentListener(new ComponentAdapter() 
		{
            public void componentResized(ComponentEvent e) 
            {
            	if(isCreated)
                {
            		isResized = true;
                }
            }
        });
		
		
		Canvas canvas = new Canvas();
		frame.add(canvas);
		frame.setVisible(true);
		
		try 
		{
			Display.setDisplayMode(new DisplayMode(width, height));
			Display.create();
			Display.setParent(canvas);
			Keyboard.create();
			Mouse.create();
		} 
		catch (LWJGLException e) 
		{
			e.printStackTrace();
		}
		
		initRenderingComponents();
		
		isCreated = true;
	}
	
	private static void initRenderingComponents()
	{
		if(!Transform.isInitialized())
		{
			if(Transform.getCamera() == null)
				Transform.setCamera(new Camera());
			if(!Transform.isInitialized())
				Transform.setProjection(70f, Window.getWidth(), Window.getHeight(), 0.1f, 1000f);
		}
	}
	
	public static void update()
	{
		isResizedReturn = false;
		if(isResized)
		{
        	glViewport(0, 0, frame.getWidth(), frame.getHeight());
        	if(setTransformSizeOnWindowResize)
        		Transform.setSize(Window.getWidth(), Window.getHeight());
        	isResizedReturn = true;
		}
			
		isResized = false;
	}
	
	public static void render()
	{

		Display.update();
	}
	
	public static void dispose()
	{
		Display.destroy();
		Keyboard.destroy();
		Mouse.destroy();
		frame.dispose();
	}
	
	public static boolean isCloseRequested()
	{
		return isCloseRequested;
	}
	
	public static boolean isCreated()
	{
		return isCreated;
	}
	
	public static boolean isResized()
	{
		return isResizedReturn;
	}
	
	public static boolean isMaximized()
	{
		return (frame.getExtendedState() | JFrame.MAXIMIZED_BOTH) == frame.getExtendedState();
	}
	
	public static boolean isResizable()
	{
		return frame.isResizable();
	}
	
	public static boolean isFullscreen()
	{
		return isFullscreen;
	}
	
	public static int getWidth()
	{
		return frame.getWidth();
	}
	
	public static int getHeight()
	{
		return frame.getHeight();
	}
	
	public static Vector2f getCenterPosition()
	{
		return new Vector2f(Window.getWidth()/2, Window.getHeight()/2);
	}
	
	public static String getTitle()
	{
		return frame.getTitle();
	}
	
	public static void setTransformSizeOnWindowResize(boolean enabled)
	{
		setTransformSizeOnWindowResize = enabled;
	}
	
	public static void setResizable(boolean value)
	{
		frame.setResizable(value);
	}
	
	public static void setMaximized(boolean value)
	{
		if(value)
			frame.setExtendedState(JFrame.MAXIMIZED_BOTH);
		else if(isMaximized())
			frame.setExtendedState(frame.getExtendedState() ^ JFrame.MAXIMIZED_BOTH);
	}
	
	public static void setFullscreen(boolean value)
	{
		//frame.setUndecorated(true);
		GraphicsEnvironment ge = GraphicsEnvironment.getLocalGraphicsEnvironment();
		GraphicsDevice vc = ge.getDefaultScreenDevice();
		
		if(value)
		{
//			setResizable(false);
//			
//			Dimension screenSize = Toolkit.getDefaultToolkit().getScreenSize();
//			frame.setSize(screenSize.width, screenSize.height);
//			vc.setFullScreenWindow(frame);
//			java.awt.DisplayMode displayMode = new java.awt.DisplayMode(Window.getWidth(), Window.getHeight(), 32, java.awt.DisplayMode.REFRESH_RATE_UNKNOWN);
//			if(displayMode!=null && vc.isDisplayChangeSupported())
//			{
//				try
//				{
//					
//						vc.setDisplayMode(displayMode);
//				}
//				catch(Exception ex)
//				{
//					ex.printStackTrace();
//					//JOptionPane.showMessageDialog(null,ex.getMessage());
//				}
//			}
//			isFullscreen = true;
		}
		else
		{
//			java.awt.Window w= vc.getFullScreenWindow();
//			if(w != null)
//			{
//				w.dispose();
//			}
//			vc.setFullScreenWindow(null);
//			isFullscreen = false;
		}
	}
}
