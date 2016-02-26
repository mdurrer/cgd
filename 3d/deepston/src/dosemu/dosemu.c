/* This file implements all calls made to dos-specific code using SDL
 * Don't ask why ...
 */

#include <stdlib.h>
#include <assert.h>
#include <SDL.h>
#include "wvga.h"
#include "conio.h"
#include "mouse.h"
#include "keyb.h"
#include "timer.h"

static void proc_events(void);

static void init_sdl()
{
	const SDL_version *ver;

	if(!SDL_WasInit(SDL_INIT_EVERYTHING)) {
		SDL_Init(SDL_INIT_VIDEO | SDL_INIT_TIMER);

		if((ver = SDL_Linked_Version())) {
			printf("SDL %d.%d.%d initialized\n", ver->major, ver->minor, ver->patch);
		}
	}
}

/* ----- graphics (wvga.c implementation) ----- */
static SDL_Surface *fbsurf;
static int scale = 3;

int set_video_mode(int mode)
{
	int resx = 320, resy = 200;
	unsigned int sdl_flags = SDL_HWPALETTE;
	char *env;

	if(getenv("DOSEMU_DOUBLESIZE")) {
		scale = 2;
	}

	if((env = getenv("DOSEMU_SCALE"))) {
		int n = atoi(env);
		if(n > 0) {
			scale = n;
		}
	}
	resx *= scale;
	resy *= scale;

	if(getenv("DOSEMU_FULLSCREEN")) {
		sdl_flags |= SDL_FULLSCREEN;
	}

	init_sdl();

	switch(mode) {
	case 0x13:
		if(!(fbsurf = SDL_SetVideoMode(resx, resy, 8, sdl_flags))) {
			fprintf(stderr, "failed to set video mode\n");
			abort();
		}
		SDL_WM_SetCaption("Deepstone", 0);
		/*SDL_ShowCursor(0);*/
		/*SDL_EnableKeyRepeat(SDL_DEFAULT_REPEAT_DELAY, SDL_DEFAULT_REPEAT_INTERVAL);*/
		break;

	case 3:
		SDL_ShowCursor(1);
		SDL_EnableKeyRepeat(0, 0);
		SDL_Quit();
		break;

	default:
		break;
	}

	return 0;
}

void set_palette(int idx, int *col, int count)
{
	int i;

	for(i=0; i<count; i++) {
		set_pal_entry(idx + i, col[0], col[1], col[2]);
		col += 3;
	}
}

void set_pal_entry(int idx, int r, int g, int b)
{
	SDL_Color col;
	col.r = r;
	col.g = g;
	col.b = b;

	if(SDL_SetPalette(fbsurf, SDL_LOGPAL | SDL_PHYSPAL, &col, idx, 1) != 1) {
		fprintf(stderr, "set_palette failed to set the required color\n");
	}
}

void copy_frame(void *pixels)
{
	unsigned char *frame = (unsigned char*)pixels;

	if(SDL_MUSTLOCK(fbsurf)) {
		SDL_LockSurface(fbsurf);
	}

	if(scale > 1) {
		int i, j, xsz, ysz;
		unsigned char *dest = fbsurf->pixels;

		xsz = 320 * scale;
		ysz = 200 * scale;

		for(i=0; i<ysz; i++) {
			for(j=0; j<xsz; j++) {
				*dest++ = frame[(i / scale) * 320 + (j / scale)];
			}
		}
	} else {
		memcpy(fbsurf->pixels, frame, 64000);
	}

	if(SDL_MUSTLOCK(fbsurf)) {
		SDL_UnlockSurface(fbsurf);
	}
	SDL_Flip(fbsurf);


	/* also print fps every second ... */
	{
		static long prev_fps, num_frames;
		long msec, dt;

		msec = get_msec();
		dt = msec - prev_fps;
		if(dt >= 1000) {
			float fps = (float)num_frames / ((float)dt / 1000.0f);
			printf("framerate: %.1f      \r", fps);
			fflush(stdout);
			num_frames = 0;
			prev_fps = msec;
		} else {
			num_frames++;
		}
	}
}

void wait_vsync(void)
{
}

/* ----- event handling (conio.h) ----- */
static SDL_Event *keybev;
static int mousex, mousey, bnmask;

static int keystate[256];
static int num_pressed;

int kbhit(void)
{
	if(!keybev) {
		proc_events();
	}
	return keybev != 0;
}

int getch(void)
{
	int res;

	while(!keybev) {
		SDL_Event ev;
		SDL_WaitEvent(&ev);
		SDL_PushEvent(&ev);
		proc_events();
	}
	res = keybev->key.keysym.sym;
	keybev = 0;
	return res;
}

/* ----- improved event handling (keyb.h) ---- */

int kb_init(int bufsz)
{
	init_sdl();

	return 0;
}

void kb_shutdown(void)
{
}

int kb_getkey(void)
{
	int res = -1;

	proc_events();
	if(keybev) {
		res = keybev->key.keysym.sym;
		keybev = 0;
	}
	return res;
}

int kb_isdown(int key)
{
	if(key == KB_ANY) {
		return num_pressed;
	}
	return keystate[key];
}

/* mouse handling (mouse.c implementation) */
static unsigned long last_mouse_hide_time;

int have_mouse(void)
{
	return 1;
}

void set_mouse(int x, int y)
{
	SDL_ShowCursor(0);
	last_mouse_hide_time = get_msec();

	SDL_WarpMouse(x * scale, y * scale);
	mousex = x;
	mousey = y;
}

int read_mouse(int *xp, int *yp)
{
	if(xp) *xp = mousex;
	if(yp) *yp = mousey;
	return bnmask;
}

static void proc_events(void)
{
	static SDL_Event ev;

	if(last_mouse_hide_time > 0 && get_msec() - last_mouse_hide_time > 3000) {
		last_mouse_hide_time = 0;
		SDL_ShowCursor(1);
	}

	while(SDL_PollEvent(&ev)) {
		switch(ev.type) {
		case SDL_KEYDOWN:
			{
				int key = ev.key.keysym.sym;

				if(!keybev) {
					keybev = &ev;
				}

				if(!keystate[key]) {
					keystate[key] = 1;
					num_pressed++;
				}
			}
			break;

		case SDL_KEYUP:
			{
				int key = ev.key.keysym.sym;

				if(keystate[key]) {
					keystate[key] = 0;
					if(--num_pressed < 0) {
						num_pressed = 0;
					}
				}
			}
			break;

		case SDL_MOUSEMOTION:
			mousex = ev.motion.x / scale;
			mousey = ev.motion.y / scale;
			break;

		case SDL_MOUSEBUTTONDOWN:
		case SDL_MOUSEBUTTONUP:
			{
				int mask = 0;
				switch(ev.button.button) {
				case SDL_BUTTON_LEFT:
					mask = MOUSE_LEFT;
					break;
				case SDL_BUTTON_MIDDLE:
					mask = MOUSE_MIDDLE;
					break;
				case SDL_BUTTON_RIGHT:
					mask = MOUSE_RIGHT;
				default:
					break;
				}
				if(!mask) {
					break;
				}

				if(ev.button.state == SDL_PRESSED) {
					bnmask |= mask;
				} else {
					bnmask &= ~mask;
				}
			}
			break;

		default:
			break;
		}
	}
}

/* ---- timer.c implementation ---- */
static Uint32 start_time;

void init_timer(int res_hz)
{
	init_sdl();
	reset_timer();
}

void reset_timer(void)
{
	start_time = SDL_GetTicks();
	printf("resetting timer: %u, %lu\n", start_time, get_msec());
}

unsigned long get_msec(void)
{
	Uint32 ticks = SDL_GetTicks();
	return (unsigned long)(ticks - start_time);
}
