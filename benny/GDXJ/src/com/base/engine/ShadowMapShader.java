package com.base.engine;

public class ShadowMapShader extends Shader
{
	private static final ShadowMapShader instance = new ShadowMapShader();
	
	public static ShadowMapShader getInstance()
	{
		return instance;
	}
	
	private ShadowMapShader()
	{
		super();
		addVertexShaderFromFile("shadowMap.vs");
		addFragmentShaderFromFile("shadowMap.fs");
		compileShader();
		
		addUniform("transformProjected");
	}
	
	public void updateUniforms(Matrix4f worldMatrix, Matrix4f projectedMatrix, Material material)
	{
		setUniform("transformProjected", projectedMatrix);
	}
}
