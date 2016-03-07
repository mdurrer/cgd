#ifndef GAME_H_INCLUDED
#define GAME_H_INCLUDED

#include "gameObject.h"
#include "renderingEngine.h"

class Game
{
public:
	Game(GameObject* pRootObject, RenderingEngine* pRenderingEngine);

	void Input();
	void Update();
	void Render();

	void AddGameObject(GameObject* gameObject);
	void RemoveGameObject(GameObject* gameObject);
	
	RenderingEngine* GetRenderingEngine();
	GameObject* GetRootObject();
protected:
private:
	GameObject* m_pRootObject;
	RenderingEngine* m_pRenderingEngine;
};

#endif