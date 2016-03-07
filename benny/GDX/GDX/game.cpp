#include "game.h"
#include <algorithm>

Game::Game(GameObject* pRootObject, RenderingEngine* pRenderingEngine)
{
	m_pRootObject = pRootObject;
	m_pRenderingEngine = pRenderingEngine;
}

void Game::Input()
{
	m_pRootObject->Input();
}

void Game::Update()
{
	m_pRootObject->Update();
}

void Game::Render()
{
	m_pRenderingEngine->Render(m_pRootObject);
}

void Game::AddGameObject(GameObject* gameObject)
{
	m_pRootObject->AddChild(gameObject);
}

void Game::RemoveGameObject(GameObject* gameObject)
{
	m_pRootObject->RemoveChild(gameObject);
}

RenderingEngine* Game::GetRenderingEngine()
{
	return m_pRenderingEngine;
}

GameObject* Game::GetRootObject()
{
	return m_pRootObject;
}
