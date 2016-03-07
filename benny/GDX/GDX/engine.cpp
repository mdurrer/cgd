#include "engine.h"
#include "timing.h"
#include "input.h"
#include "shader.h"
#include "mesh.h"

#include <sstream>
#include <SDL/SDL.h>

static CoreEngine g_DefaultEngine;
static Renderer g_DefaultRenderer;
static Display g_Display;
static CoreEngine* g_pCoreEngine = &g_DefaultEngine;
static Renderer* g_pRenderer = &g_DefaultRenderer;
static Display* g_pDisplay = &g_Display;

void Engine::Start()
{
	g_pCoreEngine->Start();
}

void Engine::Stop()
{
	g_pCoreEngine->Stop();
}

void Engine::DeleteAllResources()
{
	Shader::DeleteAll();
	Mesh::DeleteAll();
	Texture::DeleteAll();
	Material::DeleteAll();
	RenderingComponent::DeleteAll();
}

void Engine::SetGame(Game& game)
{
    g_pCoreEngine->SetGame(game);
}

void Engine::SetCoreEngine(CoreEngine& coreEngine)
{
    g_pCoreEngine = &coreEngine;
}

void Engine::SetRenderer(Renderer& renderer)
{
    g_pRenderer = &renderer;
}

void Engine::SetDisplay(Display& display)
{
	g_pDisplay = &display;
}

RenderingEngine* Engine::GetRenderingEngine()
{
	return Engine::GetGame()->GetRenderingEngine();
}

Game* Engine::GetGame()
{
    return g_pCoreEngine->GetGame();
}

Renderer* Engine::GetRenderer()
{
    return g_pRenderer;
}

Display* Engine::GetDisplay()
{
	return g_pDisplay;
}

////--------------------------------------------------------------------------------------
//// Core Engine
////--------------------------------------------------------------------------------------
static const int FRAME_CAP = 5000;

#include "mouseLook.h"

CoreEngine::CoreEngine()
{
    static RenderingEngine defaultRenderingEngine;
	static GameObject defaultRootObject;
	static Game defaultGame = Game(&defaultRootObject, &defaultRenderingEngine);
	static MouseLook defaultComponent;
	defaultGame.GetRootObject()->SetGameComponent(&defaultComponent);
    m_IsRunning = false;
    m_pGame = &defaultGame;
}

void CoreEngine::Start()
{
    m_IsRunning = true;

	Time::Init();

	const double frameLimit = 1.0/FRAME_CAP;
    int frameCount = 0;
    double frameTimeCount = 0.0;
    double timeCount = 0.0;
	double lastTime = Time::GetTime();
    bool drawFrame = false;

	while(m_IsRunning)
	{
        double currentTime = Time::GetTime();
        double passedTime = currentTime - lastTime;
        frameTimeCount += passedTime;
        timeCount += passedTime;
        lastTime = currentTime;
        drawFrame = false;

        if(frameTimeCount >= 1.0)
        {
            std::stringstream  convert;
				
            convert << frameCount << ": " << 1000.0/((double)frameCount) << "ms";

            Engine::GetDisplay()->SetTitle(convert.str());
            frameCount = 0;
            frameTimeCount = 0;
        }
            
        while(timeCount >= frameLimit)
        {
            Time::Update(frameLimit);
            drawFrame = true;
            Input::Update();
            m_pGame->Input();
            m_pGame->Update();
				
            timeCount = timeCount - frameLimit;
        }
            
        if(drawFrame)
        {
            Engine::GetRenderer()->ClearScreenAndDepth();
   
            m_pGame->Render();

            Engine::GetDisplay()->SwapBuffers();
            frameCount++;
        }
        else
        {
            SDL_Delay(1);
        }
	}
	
	Engine::DeleteAllResources();
}

void CoreEngine::Stop()
{
    m_IsRunning = false;
}

void CoreEngine::SetGame(Game& game)
{
    m_pGame = &game;
}

Game* CoreEngine::GetGame()
{
    return m_pGame;
}
