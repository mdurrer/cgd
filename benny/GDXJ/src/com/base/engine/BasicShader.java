package com.base.engine;

public class BasicShader extends Shader
{
	private static final BasicShader instance = new BasicShader();

	public static BasicShader getInstance()
	{
		return instance;
	}

	private BasicShader()
	{
		super();

		addVertexShaderFromFile("basicVertex.vs");
		addFragmentShaderFromFile("basicFragment.fs");
		compileShader();

		addUniform("transform");
		addUniform("color");

		String shaderText = Shader.loadShader("basicShader.glsl");

		Engine.getRenderer().createVertexShader(shaderText);
		Engine.getRenderer().createFragmentShader(shaderText);
	}

	@Override
	public void updateUniforms(Matrix4f worldMatrix, Matrix4f projectedMatrix, Material material)
	{
		if(material.getDiffuseTexture() != null)
			material.getDiffuseTexture().bind(0);
		else
			Texture.unbind();

		setUniform("transform", projectedMatrix);
		setUniform("color", material.getColor());
	}
}