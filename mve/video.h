#ifndef VIDEO_H
#define VIDEO_H
#include <iostream>
#include <SDL/SDL.h>
#include "common.h"
#include "stdtypes.h"
using namespace std;

class tVideo
{
	private:
	protected:
	public:
	SDL_Surface *screen;
	tVideo();
	~tVideo();
	UINT32 initVideo();
	UINT32 flipVideo();
	UINT32 drawPixel(UINT32 x, UINT32 y, UINT8 R, UINT8 G, UINT8 B);
	
};
#endif