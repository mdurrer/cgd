#include "input.h"
#include "engine.h"

static const int NUM_KEYS = 512;
static const int NUM_MOUSE = 0x40;

static bool g_Inputs[NUM_KEYS];
static bool g_DownKeys[NUM_KEYS];
static bool g_UpKeys[NUM_KEYS];

static bool g_InputMouse[NUM_MOUSE];
static bool g_DownMouse[NUM_MOUSE];
static bool g_UpMouse[NUM_MOUSE];

static Vector2f g_MousePos;

//void Input::SetKeyDown(KEY key)
//{
//	g_DownKeys[(int)key] = true;
//	g_Inputs[(int)key] = true;
//}
//
//void Input::SetKeyUp(KEY key)
//{
//	g_UpKeys[(int)key] = true;
//	g_Inputs[(int)key] = false;
//}

//void Input::SetMousePos(int x, int y)
//{
//	g_MousePos = Vector2f((float)x, (float)y);
//}
//
//void Input::SetMouseDown(KEY key)
//{
//	g_DownMouse[(int)key] = true;
//	g_InputMouse[(int)key] = true;
//}
//
//void Input::SetMouseUp(KEY key)
//{
//	g_UpMouse[(int)key] = true;
//	g_InputMouse[(int)key] = false;
//}

void Input::Update()
{
    SDL_Event event;
	for(int i = 0; i < NUM_KEYS; i++)
	{
		g_DownKeys[i] = false;
		g_UpKeys[i] = false;
	}

	for(int i = 0; i < NUM_MOUSE; i++)
	{
		g_DownMouse[i] = false;
		g_UpMouse[i] = false;
	}
	
	while (SDL_PollEvent(&event))
    {
        switch (event.type)
        {
        case SDL_QUIT:
            Engine::Stop();
            break;
            
        case SDL_KEYDOWN:
            g_DownKeys[event.key.keysym.sym] = true;
            g_Inputs[event.key.keysym.sym] = true;
            break;
        case SDL_KEYUP:
            g_UpKeys[event.key.keysym.sym] = true;
            g_Inputs[event.key.keysym.sym] = false;
            break;
            
        case SDL_MOUSEBUTTONDOWN:
            g_DownMouse[event.button.button] = true;
            g_InputMouse[event.button.button] = true;
            break;
        case SDL_MOUSEBUTTONUP:
            g_UpMouse[event.button.button] = true;
            g_InputMouse[event.button.button] = false;
            break;
        case SDL_MOUSEMOTION:
            g_MousePos = Vector2f(event.motion.x, event.motion.y);
            break;
        } 
    }
}

bool Input::GetKeyDown(KEY key)
{
	return g_DownKeys[(int)key];
}

bool Input::GetKeyUp(KEY key)
{
	return g_UpKeys[(int)key];
}

bool Input::GetKey(KEY key)
{
	return g_Inputs[(int)key];
}

bool Input::GetMouseDown(KEY key)
{
	return g_DownMouse[(int)key];
}

bool Input::GetMouseUp(KEY key)
{
	return g_UpMouse[(int)key];
}

bool Input::GetMouse(KEY key)
{
	return g_InputMouse[(int)key];
}

Vector2f Input::GetMousePos()
{
	return g_MousePos;
}
