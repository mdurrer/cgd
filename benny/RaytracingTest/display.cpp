#include "display.h"
#include <iostream>

Display::Display(int width, int height, float scale, const std::string& title)
{
	SDL_Init(SDL_INIT_EVERYTHING);

	m_window = SDL_CreateWindow(title.c_str(), SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, (int)(width*scale), (int)(height*scale), 0);
	m_renderer = SDL_CreateRenderer(m_window, -1, SDL_RENDERER_ACCELERATED);
	m_image = SDL_CreateTexture(m_renderer, SDL_PIXELFORMAT_ARGB8888, SDL_TEXTUREACCESS_STREAMING, width, height);
	
	m_isClosed = false;
	m_pixels = new int[width * height];
	m_width = width;
	m_height = height;
}

Display::~Display()
{
	SDL_DestroyWindow(m_window);
	SDL_DestroyRenderer(m_renderer);
	SDL_Quit();
	if(m_pixels) delete m_pixels;
}

void Display::DrawPixel(int x, int y, const Vector3f& color)
{
	Vector3f trueColor = color * 255;
	
	int r = ((int)trueColor.GetX()) & 0xFF;
	int g = ((int)trueColor.GetY()) & 0xFF;
	int b = ((int)trueColor.GetZ()) & 0xFF;
	
	unsigned int index = x + m_width * y;
	
	m_pixels[index] = (r << 16) | (g << 8) | b;
}

bool Display::IsClosed()
{
	return m_isClosed;
}

static bool g_DownKeys[512];

void Display::Update(Vector3f* cameraPos, float delta)
{
	SDL_Event e;
	
	while(SDL_PollEvent(&e))
	{
		if(e.type == SDL_QUIT)
			m_isClosed = true;
			
		switch( e.type ){
			case SDL_KEYDOWN:
				g_DownKeys[e.key.keysym.scancode] = true;
				break;

			case SDL_KEYUP:
				g_DownKeys[e.key.keysym.scancode] = false;
				break;

			default:
				break;
		}
	}
	
	static float MOVE_SPEED = 2.0f;
	
	if(g_DownKeys[82])
		cameraPos->SetZ(cameraPos->GetZ() + MOVE_SPEED * delta);
	if(g_DownKeys[81])
		cameraPos->SetZ(cameraPos->GetZ() - MOVE_SPEED * delta);
//	if(g_DownKeys[80])
//		cameraPos->SetX(cameraPos->GetX() - MOVE_SPEED * delta);
//	if(g_DownKeys[79])
//		cameraPos->SetX(cameraPos->GetX() + MOVE_SPEED * delta);
	
	SDL_UpdateTexture(m_image, NULL, m_pixels, m_width * sizeof(int));
	SDL_RenderCopy(m_renderer, m_image, NULL, NULL);
	SDL_RenderPresent(m_renderer);
}