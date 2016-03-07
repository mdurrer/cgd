#include "gameObject.h"
#include <algorithm>

RenderingComponent GameObject::DefaultRenderingComponent = RenderingComponent();
GameComponent GameObject::DefaultGameComponent = GameComponent();

GameObject::GameObject(const Transform& transform, RenderingComponent* pRenderingComponent, GameComponent* pGameComponent)
{
	m_Transform = transform;
	m_pRenderingComponent = pRenderingComponent;
	m_pGameComponent = pGameComponent;
	m_ChildObjects = std::vector<GameObject*>();
}

void GameObject::Input()
{
    m_pGameComponent->Input(this);
	m_pRenderingComponent->Input(this);

	for(std::vector<GameObject*>::iterator it = m_ChildObjects.begin(); it != m_ChildObjects.end(); ++it)
		(*it)->Input();
}

void GameObject::Update()
{
	m_pRenderingComponent->Update(this);
	m_pGameComponent->Update(this);

	for(std::vector<GameObject*>::iterator it = m_ChildObjects.begin(); it != m_ChildObjects.end(); ++it)
		(*it)->Update();
}

void GameObject::Render()
{
	m_pRenderingComponent->Render(this);
	m_pGameComponent->Render(this);
}

void GameObject::AddChild(GameObject* gameObject)
{
	m_ChildObjects.push_back(gameObject);
}

void GameObject::RemoveChild(GameObject* gameObject)
{
	m_ChildObjects.erase(std::remove(m_ChildObjects.begin(), m_ChildObjects.end(), gameObject), m_ChildObjects.end());
}

void GameObject::RemoveChild(int index)
{
	m_ChildObjects.erase(m_ChildObjects.begin() + index);
}

int GameObject::GetNumberOfChildren()
{
    return m_ChildObjects.size();
}

GameObject* GameObject::GetChild(int index)
{
    return m_ChildObjects.at(index);
}

Transform& GameObject::GetTransform()
{
	return m_Transform;
}

RenderingComponent* GameObject::GetRenderingComponent() const
{
	return m_pRenderingComponent;
}

GameComponent* GameObject::GetGameComponent()
{
    return m_pGameComponent;
}

void GameObject::SetTransform(const Transform& transform)
{
	m_Transform = transform;
}

void GameObject::SetRenderingComponent(RenderingComponent* pRenderingComponent)
{
    m_pRenderingComponent = pRenderingComponent;
}

void GameObject::SetGameComponent(GameComponent* pGameComponent)
{
    m_pGameComponent = pGameComponent;
}
