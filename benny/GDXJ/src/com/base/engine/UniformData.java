package com.base.engine;

public class UniformData 
{
	private int location;
	private String type;
	private String name;
	
	public int getLocation() {return location;}
	public String getType() {return type;}
	public String getName() {return name;}
	
	public void setLocation(int location) {this.location = location;}
	public void setType(String type) {this.type = type;}
	public void setName(String name) {this.name = name;}
	
	public UniformData(int location, String type, String name)
	{
		this.location = location;
		this.type = type;
		this.name = name;
	}
}
