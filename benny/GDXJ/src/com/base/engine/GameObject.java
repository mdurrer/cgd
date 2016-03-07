package com.base.engine;

import java.util.ArrayList;

public class GameObject
{
	private Transform transform;
	private Mesh mesh;
	private Material material;
	private Shader shader;
	private ArrayList<Component> components;
	private boolean castShadows;

	public Transform getTransform(){return transform;}
	public Material getMaterial() {return material;}
	public Mesh getMesh() {return mesh;}
	public boolean canCastShadows() {return castShadows;}
	public void setCastShadows(boolean castShadows) {this.castShadows = castShadows;}
	
	public GameObject(Mesh mesh, Material material)
	{
		this.transform = new Transform();
		this.mesh = mesh;
		this.material = material;
		this.shader = null; //TODO: Start letting game object be based on the new shader system!
		components = new ArrayList<Component>();
		castShadows = true;
	}
	
	public void input()
	{
		for(Component component : components)
			component.input();
	}
	
	public void update()
	{
		for(Component component : components)
		{
			component.addUnprocessedTime(Time.getDelta());
			final double updateTime = component.getUpdateDelta();
			
			while(component.getUnprocessedTime() > updateTime)
			{
				component.update();
				component.addUnprocessedTime(-updateTime);
			}
		}
	}
	
	public void render()
	{
		for(Component component : components)
			component.render();
		
		if(mesh != null)
		{
			shader.bind();
			shader.updateUniforms(transform.calcModel(), transform.calcMVP(), material);
			mesh.draw();
		}
	}
	
	public void addComponent(Component component)
	{
		component.setObject(this);
		component.init();
		components.add(component);
	}
	
	public void removeComponent(Component component)
	{
		components.remove(component);
	}
}
