#include "component.h"
#include "gameObject.h"
#include "mesh.h"
#include "shader.h"
#include "material.h"

std::map<std::string, RenderingComponent*> RenderingComponent::Components = std::map<std::string, RenderingComponent*>();

RenderingComponent* RenderingComponent::Get(const std::string& name)
{
	std::map<std::string, RenderingComponent*>::iterator it = Components.find(name);
	if(it != Components.end())
		return it->second;

	//TODO: Make this load a material from file
	return 0;
}

RenderingComponent* RenderingComponent::Create(const std::string& name, Mesh* pMesh, Material* pMaterial, Shader* pShader)
{
	if(Components.find(name) != Components.end())
		Engine::GetDisplay()->Error("RenderingComponent " + name + " already exists, and therefore cannot be created.");

	Components.insert(std::pair<std::string, RenderingComponent*>(name, new RenderingComponent(pMesh, pMaterial, pShader)));
    return Components.at(name);
}

void RenderingComponent::Delete(const std::string& name)
{
	std::map<std::string, RenderingComponent*>::iterator it = Components.find(name);
	if(it != Components.end()) 
	{
		delete it->second;
		Components.erase(it);
	} 
}

void RenderingComponent::DeleteAll()
{
	for (std::map<std::string, RenderingComponent*>::iterator it=Components.begin(); it!=Components.end(); ++it)
        delete it->second;
}

RenderingComponent::RenderingComponent(Mesh* pMesh, Material* pMaterial, Shader* pShader)
{
	m_pMesh = pMesh;
	m_pMaterial = pMaterial;
	m_pShader = pShader;
}

void RenderingComponent::Render(GameObject* pGameObject)
{
	if(m_pShader != 0)
	{
		m_pShader->Bind();
		m_pShader->Update(pGameObject->GetTransform(), *m_pMaterial);
		m_pMesh->Draw();
	}
}
