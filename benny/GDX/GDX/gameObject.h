#ifndef GAME_OBJECT_H
#define GAME_OBJECT_H

#include "transform.h"
#include "component.h"
#include <vector>

class GameObject
{
public:
    static RenderingComponent DefaultRenderingComponent;
    static GameComponent DefaultGameComponent;

	GameObject(const Transform& transform = Transform(), 
               RenderingComponent* pRenderingComponent = &DefaultRenderingComponent, 
               GameComponent* pGameComponent = &DefaultGameComponent);

	void Input();
	void Update();
	void Render();

	void AddChild(GameObject* gameObject);
	void RemoveChild(GameObject* gameObject);
	void RemoveChild(int index);
	
	int GetNumberOfChildren();
	GameObject* GetChild(int index);

	Transform& GetTransform();
	RenderingComponent* GetRenderingComponent() const;
	GameComponent* GetGameComponent();

	void SetTransform(const Transform& transform);
	void SetRenderingComponent(RenderingComponent* pRenderingComponent);
	void SetGameComponent(GameComponent* pGameComponent);
protected:
private:
	std::vector<GameObject*> m_ChildObjects;
	Transform m_Transform;
	RenderingComponent* m_pRenderingComponent;
	GameComponent* m_pGameComponent;
};

#endif
