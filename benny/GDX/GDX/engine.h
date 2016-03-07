#ifndef ENGINE_H_INCLUDED
#define ENGINE_H_INCLUDED

#include "game.h"
#include "renderer.h"
#include "display.h"

class CoreEngine
{
public:
    CoreEngine();
    virtual void Start();
    virtual void Stop();
    virtual void SetGame(Game& game);
    virtual Game* GetGame();
protected:
private:
    bool m_IsRunning;
    Game* m_pGame;
};

namespace Engine
{
    void SetGame(Game& game);
	void Start();
	void Stop();
	void DeleteAllResources();
	
	Game* GetGame();
	RenderingEngine* GetRenderingEngine();
	Renderer* GetRenderer();
	Display* GetDisplay();
	
	void SetCoreEngine(CoreEngine& coreEngine);
	void SetRenderer(Renderer& renderer);
	void SetDisplay(Display& display);
};

#endif // ENGINE_H_INCLUDED
