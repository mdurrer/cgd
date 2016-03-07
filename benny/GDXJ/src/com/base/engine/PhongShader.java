package com.base.engine;


public class PhongShader extends Shader
{
	private static final int MAX_POINT_LIGHTS = 4;
	private static final int MAX_SPOT_LIGHTS = 4;
	
	private static final PhongShader instance = new PhongShader();
	
	public static PhongShader getInstance()
	{
		return instance;
	}
	
//	private static Vector3f ambientLight = new Vector3f(0.1f,0.1f,0.1f);
//	private static DirectionalLight directionalLight = new DirectionalLight(new BaseLight(new Vector3f(0,0,0), 0), new Vector3f(0,0,0));
//	private static PointLight[] pointLights = new PointLight[] {};
//	private static SpotLight[] spotLights = new SpotLight[] {};
	
	private PhongShader()
	{
		super();
		
		addVertexShaderFromFile("phongVertex.vs");
		addFragmentShaderFromFile("phongFragment.fs");
		compileShader();
		
		addUniform("transform");
		addUniform("lightTransform0");
		addUniform("lightTransform1");
		addUniform("lightTransform2");
		addUniform("lightTransform3");
		addUniform("transformProjected");
		addUniform("baseColor");
		addUniform("ambientLight");
		
		addUniform("diffuse");
		addUniform("normalMap");
		addUniform("bumpMap");
		
		addUniform("shadowMap0");
		addUniform("shadowMap1");
		addUniform("shadowMap2");
		addUniform("shadowMap3");
		
		addUniform("specularIntensity");
		addUniform("specularPower");
		addUniform("scale");
		addUniform("bias");
		addUniform("eyePos");
		
		addUniform("directionalLight.base.color");
		addUniform("directionalLight.base.intensity");
		addUniform("directionalLight.direction");
		
		for(int i = 0; i < MAX_POINT_LIGHTS; i++)
		{
			addUniform("pointLights[" + i + "].base.color");
			addUniform("pointLights[" + i + "].base.intensity");
			addUniform("pointLights[" + i + "].atten.constant");
			addUniform("pointLights[" + i + "].atten.linear");
			addUniform("pointLights[" + i + "].atten.exponent");
			addUniform("pointLights[" + i + "].position");
			addUniform("pointLights[" + i + "].range");
		}
		
		for(int i = 0; i < MAX_SPOT_LIGHTS; i++)
		{
			addUniform("spotLights[" + i + "].pointLight.base.color");
			addUniform("spotLights[" + i + "].pointLight.base.intensity");
			addUniform("spotLights[" + i + "].pointLight.atten.constant");
			addUniform("spotLights[" + i + "].pointLight.atten.linear");
			addUniform("spotLights[" + i + "].pointLight.atten.exponent");
			addUniform("spotLights[" + i + "].pointLight.position");
			addUniform("spotLights[" + i + "].pointLight.range");
			addUniform("spotLights[" + i + "].direction");
			addUniform("spotLights[" + i + "].cutoff");
		}
		
	}
	
	public void updateUniforms(Matrix4f worldMatrix, Matrix4f projectedMatrix, Material material)
	{
		RenderingEngine renderer = Engine.getRenderingEngine();

		renderer.getShadowMap(0).bind(Texture.SHADOW_TEXTURE_0);
		renderer.getShadowMap(1).bind(Texture.SHADOW_TEXTURE_1);
		renderer.getShadowMap(2).bind(Texture.SHADOW_TEXTURE_2);
		renderer.getShadowMap(3).bind(Texture.SHADOW_TEXTURE_3);

		if(material.getNormalTexture() != null)
			material.getNormalTexture().bind(Texture.NORMAL_TEXTURE);
		else
			Texture.unbind();

		if(material.getBumpTexture() != null)
			material.getBumpTexture().bind(Texture.HEIGHT_TEXTURE);
		else
			Texture.unbind();

		if(material.getDiffuseTexture() != null)
			material.getDiffuseTexture().bind(Texture.DIFFUSE_TEXTURE);
		else
			Texture.unbind();
		
		setUniform("transformProjected", projectedMatrix);
		setUniform("lightTransform0", renderer.getLightMatrix(0));
		setUniform("lightTransform1", renderer.getLightMatrix(1));
		setUniform("lightTransform2", renderer.getLightMatrix(2));
		setUniform("lightTransform3", renderer.getLightMatrix(3));
		setUniform("transform", worldMatrix);
		setUniform("baseColor", material.getColor());
		
		setUniform("ambientLight", renderer.getAmbientLight());
		setUniform("directionalLight", renderer.getDirectionalLight());
		
		for(int i = 0; i < renderer.getPointLights().length; i++)
			setUniform("pointLights[" + i + "]", renderer.getPointLights()[i]);
		
		for(int i = 0; i < renderer.getSpotLights().length; i++)
			setUniform("spotLights[" + i + "]", renderer.getSpotLights()[i]);
		
		setUniformf("specularIntensity", material.getSpecularIntensity());
		setUniformf("specularPower", material.getSpecularPower());
		setUniformf("scale", material.getHeightScale());
		setUniformf("bias", material.getHeightBias());
		
		setUniform("eyePos", Transform.getCamera().getPosition());
		
		setUniformi("diffuse", Texture.DIFFUSE_TEXTURE);
		setUniformi("normalMap", Texture.NORMAL_TEXTURE);
		setUniformi("bumpMap", Texture.HEIGHT_TEXTURE);
		setUniformi("shadowMap0", Texture.SHADOW_TEXTURE_0);
		setUniformi("shadowMap1", Texture.SHADOW_TEXTURE_1);
		setUniformi("shadowMap2", Texture.SHADOW_TEXTURE_2);
		setUniformi("shadowMap3", Texture.SHADOW_TEXTURE_3);
	}

	public void setUniform(String uniformName, BaseLight baseLight)
	{
		setUniform(uniformName + ".color", baseLight.getColor());
		setUniformf(uniformName + ".intensity", baseLight.getIntensity());
	}
	
	public void setUniform(String uniformName, DirectionalLight directionalLight)
	{
		setUniform(uniformName + ".base", directionalLight.getBase());
		setUniform(uniformName + ".direction", directionalLight.getDirection());
	}
	
	public void setUniform(String uniformName, PointLight pointLight)
	{
		setUniform(uniformName + ".base", pointLight.getBaseLight());
		setUniformf(uniformName + ".atten.constant", pointLight.getAtten().getConstant());
		setUniformf(uniformName + ".atten.linear", pointLight.getAtten().getLinear());
		setUniformf(uniformName + ".atten.exponent", pointLight.getAtten().getExponent());
		setUniform(uniformName + ".position", pointLight.getPosition());
		setUniformf(uniformName + ".range", pointLight.getRange());
	}
	
	public void setUniform(String uniformName, SpotLight spotLight)
	{
		setUniform(uniformName + ".pointLight", spotLight.getPointLight());
		setUniform(uniformName + ".direction", spotLight.getDirection());
		setUniformf(uniformName + ".cutoff", spotLight.getCutoff());
	}
}
