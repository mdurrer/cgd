#include "video.h"
tVideo::tVideo()
{
	
}
tVideo::~tVideo()
{
	SDL_FreeSurface(screen);
}
UINT32 tVideo::initVideo()
{
	screen = SDL_SetVideoMode(XRES,YRES,0,SDL_DOUBLEBUF|SDL_HWSURFACE|SDL_HWPALETTE);
	return(0);
}
UINT32 tVideo::flipVideo()
{
	SDL_Flip(screen);
	return (0);
}

UINT32 tVideo::drawPixel(UINT32 x, UINT32 y, UINT8 R, UINT8 G, UINT8 B)
{
	UINT32 color = SDL_MapRGB(screen->format,R,G,B);
	 switch (screen->format->BytesPerPixel)
  {
    case 1: // Assuming 8-bpp
      {
        Uint8 *bufp;
        bufp = (Uint8 *)screen->pixels + y*screen->pitch + x;
        *bufp = color;
      }
      break;
    case 2: // Probably 15-bpp or 16-bpp
      {
        Uint16 *bufp;
        bufp = (Uint16 *)screen->pixels + y*screen->pitch/2 + x;
        *bufp = color;
      }
      break;
    case 3: // Slow 24-bpp mode, usually not used
      {
        Uint8 *bufp;
        bufp = (Uint8 *)screen->pixels + y*screen->pitch + x * 3;
        if(SDL_BYTEORDER == SDL_LIL_ENDIAN)
        {
          bufp[0] = color;
          bufp[1] = color >> 8;
          bufp[2] = color >> 16;
        } else {
          bufp[2] = color;
          bufp[1] = color >> 8;
          bufp[0] = color >> 16;
        }
      }
      break;
    case 4: // Probably 32-bpp
      {
        Uint32 *bufp;
        bufp = (Uint32 *)screen->pixels + y*screen->pitch/4 + x;
        *bufp = color;
      }
      break;
  }
  return(0);
}
