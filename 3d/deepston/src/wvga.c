#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "wvga.h"
#include "dpmi.h"

/* VGA DAC registers used for palette setting in 8bpp modes */
#define VGA_DAC_STATE		0x3c7
#define VGA_DAC_ADDR_RD		0x3c7
#define VGA_DAC_ADDR_WR		0x3c8
#define VGA_DAC_DATA		0x3c9

static void *framebuffer;

int set_video_mode(int mode)
{
	struct dpmi_real_regs regs;

	memset(&regs, 0, sizeof regs);
	regs.eax = mode;
	dpmi_real_int(0x10, &regs);

	if(regs.eax == 0x100) {
		return -1;
	}

	if(mode != 3) {
		framebuffer = dpmi_mmap(0xa0000, 64000);
	} else {
		dpmi_munmap((void*)0xa0000);
	}
	return 0;
}

void set_palette(int idx, int *col, int count)
{
	int i;

	__asm {
		mov dx, VGA_DAC_ADDR_WR
		mov eax, idx
		out dx, al
	}

	for(i=0; i<count; i++) {
		unsigned char r = *col++ >> 2;
		unsigned char g = *col++ >> 2;
		unsigned char b = *col++ >> 2;

		__asm {
			mov dx, VGA_DAC_DATA
			mov al, r
			out dx, al
			mov al, g
			out dx, al
			mov al, b
			out dx, al
		}
	}
}

void set_pal_entry(int idx, int r, int g, int b)
{
	int color[3];
	color[0] = r;
	color[1] = g;
	color[2] = b;

	set_palette(idx, color, 1);
}

void copy_frame(void *pixels)
{
	memcpy(framebuffer, pixels, 64000);
}


void wait_vsync(void)
{
	__asm {
		mov dx, 0x3da
	l1:
		in al, dx
		and al, 0x8
		jnz l1
	l2:
		in al, dx
		and al, 0x8
		jz l2
	}
}
