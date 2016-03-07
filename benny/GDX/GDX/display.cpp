#include "display.h"
#include "engine.h"

#include <SDL/SDL.h>
#include <iostream>

static SDL_Surface* g_pScreen = NULL;
static int g_Width;
static int g_Height;

bool Display::Init(int width, int height, const std::string& title)
{
    //TODO: Make this account for resizing!
    
    g_Width = width;
    g_Height = height;
    
    if ( SDL_Init( SDL_INIT_VIDEO ) < 0 )
    {
        printf( "Unable to init SDL: %s\n", SDL_GetError() );
        return false;
    }
    
    SDL_GL_SetAttribute( SDL_GL_RED_SIZE, 5 );
    SDL_GL_SetAttribute( SDL_GL_GREEN_SIZE, 5 );
    SDL_GL_SetAttribute( SDL_GL_BLUE_SIZE, 5 );
    SDL_GL_SetAttribute( SDL_GL_DEPTH_SIZE, 16 );
    SDL_GL_SetAttribute( SDL_GL_DOUBLEBUFFER, 1 );
    g_pScreen = SDL_SetVideoMode(width, height, 32, SDL_OPENGL);
    SetTitle(title);
    
    if ( !g_pScreen )
    {
        printf("Unable to set 640x480 video: %s\n", SDL_GetError());
        return false;
    }
    
    Engine::GetRenderer()->Init();
    
    return true;
}

void Display::Destroy()
{
    SDL_Quit();
}

void Display::SetTitle(const std::string& title)
{
    SDL_WM_SetCaption(title.c_str(), title.c_str());
}

void Display::ShowMouse(bool show)
{
    if(show)
        SDL_ShowCursor(SDL_ENABLE);
    else
        SDL_ShowCursor(SDL_DISABLE);
}

void Display::SwapBuffers()
{
    SDL_GL_SwapBuffers();
}

void Display::Error(const std::string& message)
{
    std::cout << "Error: " << message << std::endl;
    Engine::Stop();
}

void Display::SetMousePos(const Vector2f& pos)
{
	SDL_WarpMouse((Uint16)pos.GetX(), (Uint16)pos.GetY());
}

float Display::GetAspect()
{
    return (float)g_Width/(float)g_Height;
}

Vector2f Display::GetSize()
{
    return Vector2f((float)g_Width, (float)g_Height);
}

Vector2f Display::GetCenter()
{
    return Vector2f((float)g_Width / 2, (float)g_Height / 2);
}

