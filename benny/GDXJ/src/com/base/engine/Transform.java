package com.base.engine;

import java.util.Stack;


public class Transform
{
	private static Stack<Matrix4f> projectionStack = new Stack<Matrix4f>();
	private static Stack<Camera> cameraStack = new Stack<Camera>();
	private static Matrix4f view = new Matrix4f().initIdentity();
	private static Matrix4f projection = new Matrix4f().initIdentity();
	private static Camera camera;
	
	private static float zNear;
	private static float zFar;
	private static float width;
	private static float height;
	private static float fov;
	private static boolean hasProjectionData = false;
	
	private Vector3f position;
	private Quaternion rotation;
	private Vector3f scale;
	private Matrix4f model;
	
	public Transform()
	{
		this(new Vector3f(0,0,0));
	}
	
	public Transform(Vector3f position)
	{
		this(position, new Quaternion(0,0,0,1), new Vector3f(1,1,1));
	}
	
	public Transform(Vector3f position, Vector3f scale)
	{
		this(position, new Quaternion(0,0,0,1), scale);
	}
	
	public Transform(Vector3f position, Quaternion rotation, Vector3f scale)
	{
		this.position = position;
		this.rotation = rotation;
		this.scale = scale;
		model = new Matrix4f().initIdentity();
	}
	
	public void lookAt(Vector3f pos)
	{
		rotation = new Quaternion(position.sub(pos).normalized());
	}
	
	public void rotate(Quaternion rotationAmount)
	{
		rotation = rotationAmount.mul(rotation);
	}
	
	public void rotate(Vector3f eulerAngles)
	{
		rotate(new Quaternion(Vector3f.UP, eulerAngles.getY()));
		rotate(new Quaternion(Vector3f.FORWARD, eulerAngles.getZ()));
		rotate(new Quaternion(Vector3f.RIGHT, eulerAngles.getX()));
	}
	
	public void scale(float amt)
	{
		scale = scale.mul(amt);
	}
	
	public void scale(Vector3f amt)
	{
		scale = scale.mul(amt);
	}
	
	public void move(Vector3f movement)
	{
		position = position.add(movement);
	}
	
	public Vector3f getForward()
	{
		return rotation.getForward();
	}
	
	public Vector3f getRight()
	{
		return rotation.getRight();
	}
	
	public Vector3f getUp()
	{
		return rotation.getUp();
	}
	
	public Vector3f getEulerAngles()
	{
		return rotation.getEulerAngles();
	}
	
	public Matrix4f calcModel()
	{
		Matrix4f translationMatrix = new Matrix4f().initTranslation(position.getX(), position.getY(), position.getZ());
		Matrix4f rotationMatrix = rotation.getRotationMatrix();//new Matrix4f().initRotation(rotation.getX(), rotation.getY(), rotation.getZ());
		Matrix4f scaleMatrix = new Matrix4f().initScale(scale.getX(), scale.getY(), scale.getZ());
		
		model =  translationMatrix.mul(rotationMatrix.mul(scaleMatrix));
		return model;
	}
	
	public Matrix4f calcMVP()
	{
		calcModel();
		calcView();
		
		return getMVP();
	}
	
	public Matrix4f getMVP()
	{
		return projection.mul(view.mul(model));
	}
	
	public Matrix4f getModel()
	{
		return model;
	}
	
	public static void pushProjection(Matrix4f newProjection)
	{
		projectionStack.push(projection);
		projection = newProjection;
	}
	
	public static void popProjection()
	{
		projection = projectionStack.pop();
	}
	
	public static void pushCamera(Camera newCamera)
	{
		cameraStack.push(camera);
		setCamera(newCamera);
	}
	
	public static void popCamera()
	{
		setCamera(cameraStack.pop());
	}
	
	public static Matrix4f getView()
	{
		return view;
	}
	
	public static Matrix4f getProjection()
	{
		return projection;
	}
	
	public void setModel(Matrix4f model)
	{
		this.model = model;
	}
	
	public static void setView(Matrix4f view)
	{
		Transform.view = view;
	}
	
	public static void setView(Camera camera)
	{
		Camera temp = Transform.camera;
		Transform.camera = camera;
		calcView();
		Transform.camera = temp;
	}
	
	public static void setProjection(Matrix4f projection)
	{
		Transform.projection = projection;
	}
	
	public static Matrix4f calcView()
	{
		Matrix4f cameraRotation = camera.getRotation().getRotationMatrix();
		Matrix4f cameraTranslation = new Matrix4f().initTranslation(-camera.getPosition().getX(), -camera.getPosition().getY(), -camera.getPosition().getZ());
	
		view = cameraRotation.mul(cameraTranslation);
		return view;
	}
	
	public static Matrix4f getOrthographicMatrix()
	{
		//return new Matrix4f().initOrthographicProjection(-width/2, width/2, height/2, -height/2, zNear, zFar);
		return new Matrix4f().initOrthographicProjection(-width/2, width/2, height/2, -height/2, -zFar, zFar);
	}
	
	public static Matrix4f getPerspectiveMatrix()
	{
		return new Matrix4f().initPerspectiveProjection(fov, width, height, zNear, zFar);
	}
	
	public Vector3f getPosition()
	{
		return position;
	}
	
	public static void setProjection(float fov, float width, float height, float zNear, float zFar)
	{
		Transform.fov = fov;
		Transform.width = width;
		Transform.height = height;
		Transform.zNear = zNear;
		Transform.zFar = zFar;
		Transform.hasProjectionData = true;
	}
	
	public static void setSize(float width, float height)
	{
		Transform.width = width;
		Transform.height = height;
	}
	
	public void setPosition(Vector3f position)
	{
		this.position = position;
	}
	
	public void setPosition(float x, float y, float z)
	{
		this.position = new Vector3f(x, y, z);
	}

	public Quaternion getRotation()
	{
		return rotation;
	}

	public void setRotation(Quaternion rotation)
	{
		this.rotation = rotation;
	}

	public Vector3f getScale()
	{
		return scale;
	}

	public void setScale(Vector3f scale)
	{
		this.scale = scale;
	}
	
	public void setScale(float x, float y, float z)
	{
		this.scale = new Vector3f(x, y, z);
	}

	public static boolean isInitialized()
	{
		return hasProjectionData && camera != null;
	}
	
	public static Camera getCamera()
	{
		return camera;
	}

	public static void setCamera(Camera camera)
	{
		Transform.camera = camera;
		calcView();
	}
	
	public static float getZNear()
	{
		return zNear;
	}
	
	public static float getZFar()
	{
		return zFar;
	}
	
//	public Matrix4f getTransformation()
//	{
//		Matrix4f translationMatrix = new Matrix4f().initTranslation(position.getX(), position.getY(), position.getZ());
//		Matrix4f rotationMatrix = rotation.getRotationMatrix();//new Matrix4f().initRotation(rotation.getX(), rotation.getY(), rotation.getZ());
//		Matrix4f scaleMatrix = new Matrix4f().initScale(scale.getX(), scale.getY(), scale.getZ());
//		
//		model =  translationMatrix.mul(rotationMatrix.mul(scaleMatrix));
//		
//		return model;
//	}
	
//	public Matrix4f getProjectedTransformation()
//	{
//		return getProjectedTransformation(Engine.getRenderer().getProjectionMatrix());
//	}
//	
//	public Matrix4f getPerspectiveTransformation()
//	{	
//		return getCameraMatrix(getPerspectiveMatrix()).mul(getTransformation());
//	}
//	
//	public Matrix4f getOrthographicTransformation()
//	{
//		return getCameraMatrix(getOrthographicMatrix()).mul(getTransformation());
//	}
//	
//	public Matrix4f getProjectedTransformation(Matrix4f baseProjection)
//	{	
//		return getCameraMatrix(baseProjection).mul(getTransformation());
//	}
//	
//	public static Matrix4f getCameraMatrix(Matrix4f baseProjection)
//	{
//		Matrix4f cameraRotation = camera.getRotation().getRotationMatrix();
//		Matrix4f cameraTranslation = new Matrix4f().initTranslation(-camera.getPosition().getX(), -camera.getPosition().getY(), -camera.getPosition().getZ());
//		
//		view = baseProjection.mul(cameraRotation.mul(cameraTranslation));
//		
//		return view;
//	}
}
