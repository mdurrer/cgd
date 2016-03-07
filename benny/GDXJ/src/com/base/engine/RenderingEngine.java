package com.base.engine;

import java.nio.FloatBuffer;
import java.util.ArrayList;
import static org.lwjgl.opengl.GL30.*;
import static org.lwjgl.opengl.GL32.*;
import static org.lwjgl.opengl.GL11.*;
import static org.lwjgl.opengl.GL12.*;

public class RenderingEngine
{
	private static final int SHADOW_WIDTH = 1024;
	private static final int SHADOW_HEIGHT = 1024;
	//private static final float LIGHT_VIEW_SIZE = 2.5f;
	private static final float[] LIGHT_VIEW_SIZE = new float[]{2.5f,7.5f,30f,50f};//5,15,60,100 (CascadeValues, divided by 2 in current light view implementation)
	
	
	private Vector3f ambientLight;// = new Vector3f(0.1f,0.1f,0.1f);
	private DirectionalLight directionalLight;// = new DirectionalLight(new Vector3f(1,1,1), 0.8f, new Vector3f(1,1,1));
	private PointLight[] pointLights;// = new PointLight[] {};
	private SpotLight[] spotLights;// = new SpotLight[] {};
	
	//private Matrix4f lightMatrix = new Matrix4f().initIdentity();
	private Matrix4f[] lightMatrix = new Matrix4f[] {new Matrix4f().initIdentity(),new Matrix4f().initIdentity(),new Matrix4f().initIdentity(),new Matrix4f().initIdentity()};//new Matrix4f().initIdentity();
	private Matrix4f[] projMatrix = new Matrix4f[4];
	
	private ArrayList<GameObject> objects;
	
	//private int framebuffer;
	//private int[] shadowMapFrameBuffer = new int[4];
	private Texture[] depthTexture = new Texture[4];
	private Camera[] shadowCamera = new Camera[4];
	
	private Transform transform;
	private Camera camera;
	
	public boolean updateUniform(UniformData uniform, Transform transform, Material material)
	{
		return false;
	}
	
	public void clearScreen()
	{
		//TODO: Stencil Buffer
		glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	}
	
	public void clearDepth()
	{
		glClear(GL_DEPTH_BUFFER_BIT);
	}
	
	public void setClearColor(Vector3f color)
	{
		glClearColor(color.getX(), color.getY(), color.getZ(), 1.0f);
	}
	
	public void initGraphics()
	{
		glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
		
		glFrontFace(GL_CW);
		glCullFace(GL_BACK);
		glEnable(GL_CULL_FACE);
		glEnable(GL_DEPTH_TEST);
		
		glEnable(GL_DEPTH_CLAMP);
		
		glEnable(GL_TEXTURE_2D);
		
		transform = new Transform();
		camera = new Camera();
	}
	
	public void drawRect2D(float x, float y, float width, float height, Material material)
	{
		Transform.pushCamera(camera);
		Transform.pushProjection(Transform.getOrthographicMatrix());
		glDisable(GL_DEPTH_TEST);
		
		transform.setPosition(new Vector3f(x - Window.getWidth()/2 + width/2,-y + Window.getHeight()/2 - height/2,0));
		transform.setScale(new Vector3f(width,height,1));
		
		BasicShader.getInstance().bind();
		BasicShader.getInstance().updateUniforms(transform.calcModel(), transform.getMVP(), material);
		
		Mesh.get("rect").draw();
		
		glEnable(GL_DEPTH_TEST);
		Transform.popCamera();
		Transform.popProjection();
	}
	
	public void init()
	{
		ambientLight  = new Vector3f(0.08f,0.09f,0.1f).mul(2);
		directionalLight = new DirectionalLight(new Vector3f(1,0.9f,0.8f), 0.8f, new Vector3f(0,1,-1));
		pointLights = new PointLight[] {};
		spotLights = new SpotLight[] {};
		
//		perspectiveMatrix = Transform.getPerspectiveMatrix();
//		orthoMatrix = Transform.getOrthographicMatrix();
//		projectionMatrix = perspectiveMatrix;
		
		initShadowData();
		Mesh.generatePrimitives();
		Material.generateDefaultMaterials();
		Transform.setProjection(Transform.getPerspectiveMatrix());
		//Texture.initData();
		//Transform.usePerspectiveProjection();
	}
	
	private void initShadowData()
	{
		for(int i = 0; i < 4; i++)
		{
			projMatrix[i] = new Matrix4f().initOrthographicProjection(-LIGHT_VIEW_SIZE[i],LIGHT_VIEW_SIZE[i],
																	  -LIGHT_VIEW_SIZE[i],LIGHT_VIEW_SIZE[i],
																	  -LIGHT_VIEW_SIZE[i],LIGHT_VIEW_SIZE[i]);

			FloatBuffer data = Util.createFloatBuffer(SHADOW_WIDTH * SHADOW_HEIGHT);
			
			for(int j = 0; j < SHADOW_WIDTH * SHADOW_HEIGHT; j++)
				data.put(1);
			data.flip();
			
			depthTexture[i] = new Texture(SHADOW_WIDTH, SHADOW_HEIGHT, data, GL_LINEAR, GL_CLAMP_TO_EDGE);
			depthTexture[i].initRenderTarget(GL_DEPTH_ATTACHMENT, true);
			
			shadowCamera[i] = new Camera(new Vector3f(0,0,0), new Quaternion(directionalLight.getDirection()));
		}
		Texture.unbindRenderTarget();
	}
	
	public void fullRender()
	{
		Transform.calcView();
		objects = Engine.getGame().getObjects();
		
		for(GameObject object : objects)
		{

			//TODO: Better way to render with different shaders than the game object has
			Mesh tempMesh = object.getMesh();
			Transform tempTransform = object.getTransform();

			NewShader.get("basicShader").bind();
			NewShader.get("basicShader").update(tempTransform, object.getMaterial());
			
			tempMesh.draw();
		}
	}
	
	private void shadowPass()
	{
		for(int i = 0; i < 4; i++)
		{
			Transform.pushProjection(projMatrix[i]);
			
			Vector3f shadowCameraPosition = Transform.getCamera().getPosition().add(Transform.getCamera().getForward().mul(LIGHT_VIEW_SIZE[i]));
			shadowCamera[i].setPosition(shadowCameraPosition);
			shadowCamera[i].setRotation(new Quaternion(directionalLight.getDirection()));
			
			Transform.pushCamera(shadowCamera[i]);
			
			depthTexture[i].bindAsRenderTarget();//glBindFramebuffer(GL_DRAW_FRAMEBUFFER, shadowMapFrameBuffer[i]);
			clearDepth();
			
			ShadowMapShader.getInstance().bind();
			
			for(GameObject object : objects)
			{
				if(!object.canCastShadows())
					continue;
				
				//TODO: Better way to render with different shaders than the game object has
				Mesh tempMesh = object.getMesh();
				Transform tempTransform = object.getTransform();
				
				ShadowMapShader.getInstance().updateUniforms(tempTransform.calcModel(), tempTransform.getMVP(), Material.getDefaultMaterial());
				tempMesh.draw();
			}
			
			Transform.popCamera();
			Transform.popProjection();
			
		}
		Texture.unbindRenderTarget();
	}
	
	private void renderPass()
	{
		Transform.setProjection(Transform.getPerspectiveMatrix());
		clearScreen();
		Matrix4f biasMatrix = new Matrix4f(new float[][] {	{0.5f, 0.0f, 0.0f, 0.5f},
															{0.0f, 0.5f, 0.0f, 0.5f},
															{0.0f, 0.0f, 0.5f, 0.5f},
															{0.0f, 0.0f, 0.0f, 1.0f}});
		for(GameObject object : objects)
		{
			for(int i = 0; i < 4; i++)
			{
				Transform.pushCamera(shadowCamera[i]);
				Transform.pushProjection(projMatrix[i]);
				
				object.getTransform().calcModel();
				lightMatrix[i] = biasMatrix.mul(object.getTransform().getMVP());
				
				
				Transform.popCamera();
				Transform.popProjection();
			}
			
			object.render();
		}
	}
	
//	public void usePerspectiveMatrix()
//	{
//		projectionMatrix = perspectiveMatrix;
//	}
//	
//	public void useOrthographicMatrix()
//	{
//		projectionMatrix = orthoMatrix;
//	}
	
	public Vector3f getAmbientLight()
	{
		return ambientLight;
	}

	public DirectionalLight getDirectionalLight()
	{
		return directionalLight;
	}
	
	public PointLight[] getPointLights()
	{
		return pointLights;
	}
	
	public SpotLight[] getSpotLights()
	{
		return spotLights;
	}
	
//	public Matrix4f getProjectionMatrix()
//	{
//		return projectionMatrix;
//	}
//	
//	public Matrix4f getPerspectiveMatrix()
//	{
//		return perspectiveMatrix;
//	}
//
//	public Matrix4f getOrthoMatrix()
//	{
//		return orthoMatrix;
//	}
	
	public Matrix4f getLightMatrix(int index)
	{
		return lightMatrix[index];
	}
	
	public Texture getShadowMap(int index)
	{
		return depthTexture[index];
	}
	
	public void setAmbientLight(Vector3f ambientLight)
	{
		this.ambientLight = ambientLight;
	}
	
	public void setDirectionalLight(DirectionalLight directionalLight)
	{
		this.directionalLight = directionalLight;
	}
	
	public void setPointLight(PointLight[] pointLights)
	{
		this.pointLights = pointLights;
	}
	
	public void setSpotLights(SpotLight[] spotLights)
	{
		this.spotLights = spotLights;
	}

//	public void setPerspectiveMatrix(Matrix4f perspectiveMatrix)
//	{
//		this.perspectiveMatrix = perspectiveMatrix;
//	}
//
//	public void setOrthoMatrix(Matrix4f orthoMatrix)
//	{
//		this.orthoMatrix = orthoMatrix;
//	}
//	
//	public void setProjectionMatrix(Matrix4f projectionMatrix)
//	{
//		this.projectionMatrix = projectionMatrix;
//	}
}
