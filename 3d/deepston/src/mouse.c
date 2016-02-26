#include "mouse.h"
#include "inttypes.h"

#define INTR	0x33

#define QUERY	0
#define SHOW	1
#define HIDE	2
#define READ	3
#define WRITE	4

#define XLIM	7
#define YLIM	8

int have_mouse(void)
{
	int16_t res;
	__asm {
		mov ax, QUERY
		int INTR
		mov res, ax
	}
	return res;
}

void show_mouse(int show)
{
	int16_t cmd = show ? SHOW : HIDE;
	__asm {
		mov ax, cmd
		int INTR
	}
}

int read_mouse(int *xp, int *yp)
{
	int16_t x, y, bn;

	__asm {
		mov ax, READ
		int INTR
		mov bn, bx
		mov x, cx
		mov y, dx
		/* XXX some sort of div by 8 in the original code ? */
	}

	if(xp) *xp = x;
	if(yp) *yp = y;
	return bn;
}

void set_mouse(int x, int y)
{
	__asm {
		mov ax, WRITE
		mov ecx, x
		mov edx, y
		int INTR
	}
}

void set_mouse_limits(int xmin, int ymin, int xmax, int ymax)
{
	__asm {
		mov ax, XLIM
		mov ecx, xmin
		mov edx, xmax
		int INTR
		mov ax, YLIM
		mov ecx, ymin
		mov edx, ymax
		int INTR
	}
}
