#include "renderingEngine.h"
#include "shader.h"
#include "mesh.h"
#include "util.h"

PerspectiveCamera RenderingEngine::DefaultCamera = PerspectiveCamera(Vector3f(0, 1, -5), Vector3f::FORWARD, Vector3f::UP, ToRadians(70.0f), 0.01f, 1000.0f);

RenderingEngine::RenderingEngine(Camera* camera)
{
	m_pCamera = camera;
}

static void RenderPass(GameObject* pGameObject, Shader* pShader)
{
	for(int i = 0; i < pGameObject->GetNumberOfChildren(); i++)
    {
        GameObject* pChild = pGameObject->GetChild(i);
        
        pChild->GetTransform().SetChildModel(pGameObject->GetTransform().GetModel(false));

		pShader->Bind();
		pShader->Update(pChild->GetTransform(), *pChild->GetRenderingComponent()->GetMaterial());
		pChild->GetRenderingComponent()->GetMesh()->Draw();

        RenderPass(pChild, pShader);
    }
}

static void DefaultPass(GameObject* pGameObject)
{
	for(int i = 0; i < pGameObject->GetNumberOfChildren(); i++)
    {
        GameObject* pChild = pGameObject->GetChild(i);
        
        pChild->GetTransform().SetChildModel(pGameObject->GetTransform().GetModel(false));
		pChild->Render();
        DefaultPass(pChild);
    }
}

void RenderingEngine::Render(GameObject* pGameObject)
{
	Transform::CalcViewProjection(m_pCamera);
	RenderPass(pGameObject, Shader::Get("forward-ambient"));

	Engine::GetRenderer()->SetBlending(true);
	Engine::GetRenderer()->SetDepthFunc(true);
	Engine::GetRenderer()->SetDepthWrite(false);

	//TODO: Set up uniforms for light sources and update accordingly!
	RenderPass(pGameObject, Shader::Get("forward-directional"));

	Engine::GetRenderer()->SetBlending(false);
	Engine::GetRenderer()->SetDepthFunc(false);
	Engine::GetRenderer()->SetDepthWrite(true);
	DefaultPass(pGameObject);
}

struct BaseLight
{
	Vector3f color;
	float intensity;
};

struct DirectionalLight
{
	BaseLight base;
	Vector3f direction;
};

void RenderingEngine::UpdateUniform(UniformData* it, Transform& transform, Material& material)
{	
	std::vector<std::string> tokens = Util::Split(it->Name, '.');

	if(tokens[0].compare("directionalLight") == 0)
	{
		std::string flattenedName = tokens[tokens.size() - 1];

		if(flattenedName.compare("color") == 0)
			Engine::GetRenderer()->SetUniformVector3f(it->Location, Vector3f(1,1,1));
		else if(flattenedName.compare("intensity") == 0)
			Engine::GetRenderer()->SetUniformFloat(it->Location, 0.8f);
		else if(flattenedName.compare("direction") == 0)
			Engine::GetRenderer()->SetUniformVector3f(it->Location, Vector3f(1,1,1).Normalized());
	}
	else if(it->Type.compare("sampler2D") == 0)
	{
	    int unit = Material::GetTextureUnit(it->Name);
        material.GetTexture(it->Name)->Bind(unit);
        Engine::GetRenderer()->SetUniformInt(it->Location, unit);
	}
    else if(it->Name.compare("MVP") == 0)
        Engine::GetRenderer()->SetUniformMatrix4f(it->Location, transform.GetMVP());
	else if(it->Name.compare("transform") == 0)
        Engine::GetRenderer()->SetUniformMatrix4f(it->Location, transform.GetModel());
	else if(it->Name.compare("eyePos") == 0)
		Engine::GetRenderer()->SetUniformVector3f(it->Location, Transform::GetEyePosition());
	else
	{
		if(it->Type.compare("float") == 0)
		{
			if(it->Name.compare("ambientColor") == 0)
				Engine::GetRenderer()->SetUniformFloat(it->Location, 0.1f);
			else
				Engine::GetRenderer()->SetUniformFloat(it->Location, material.GetFloat(it->Name));
		}
		else if(it->Type.compare("vec3") == 0)
			Engine::GetRenderer()->SetUniformVector3f(it->Location, material.GetVector3f(it->Name));
		else
			Engine::GetDisplay()->Error("Type " + it->Type + " not currently supported for uniform " + it->Name);
	}
}

void RenderingEngine::SetCamera(Camera* pCamera)
{
	m_pCamera = pCamera;
}

Camera* RenderingEngine::GetCamera()
{
	return m_pCamera;
}