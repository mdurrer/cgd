#ifndef DISPLAY_H
#define DISPLAY_H

#include <SDL2/SDL.h>
#include <string>
#include "math3d.h"

class Display
{
public:
	Display(int width, int height, float scale, const std::string& title);
	
	void DrawPixel(int x, int y, const Vector3f& color);
	void Update(Vector3f* cameraPos, float delta); //NOTE: This paramater is temporary
	bool IsClosed();
	
	virtual ~Display();
protected:
private:
	Display(const Display& other) {}
	void operator=(const Display& other) {}
	
	SDL_Window* m_window;
	SDL_Texture* m_image;
	SDL_Renderer* m_renderer;
	bool m_isClosed;
	
	int* m_pixels;
	unsigned int m_width;
	unsigned int m_height;
};

#endif // DISPLAY_H