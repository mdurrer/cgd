/*
256-color 3D graphics hack for real-mode DOS.
Copyright (C) 2011  John Tsiombikas <nuclear@member.fsf.org>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#include <string.h>
#include "palman.h"

#define MAX_COLORS		256
static struct palm_color colors[MAX_COLORS];
static int base_index[MAX_COLORS];

static struct palm_color pal[MAX_COLORS];
static unsigned int ncol, pcol;
static int range;

void palm_clear(void)
{
	ncol = 0;
}

int palm_add_color(unsigned char r, unsigned char g, unsigned char b)
{
	if(ncol >= MAX_COLORS) {
		return -1;
	}
	colors[ncol].r = r;
	colors[ncol].g = g;
	colors[ncol].b = b;
	ncol++;
	return 0;
}

int palm_color_index(unsigned char r, unsigned char g, unsigned char b)
{
	int i;

	for(i=0; i<(int)ncol; i++) {
		if(colors[i].r == r && colors[i].g == g && colors[i].b == b) {
			return i;
		}
	}
	return -1;
}

/* TODO: build an octree */
int palm_build(void)
{
	int i, j;

	if(!ncol) {
		return -1;
	}

	/* gradient range for each color */
	range = MAX_COLORS / ncol;

	if(range <= 1) {
		memcpy(pal, colors, ncol * sizeof *pal);
		return 0;
	}
	pcol = 0;

	for(i=0; i<(int)ncol; i++) {
		unsigned short r, g, b, dr, dg, db;

		base_index[i] = pcol;

		dr = ((unsigned short)colors[i].r << 8) / (range - 1);
		dg = ((unsigned short)colors[i].g << 8) / (range - 1);
		db = ((unsigned short)colors[i].b << 8) / (range - 1);

		r = g = b = 0;
		for(j=0; j<range; j++) {
			pal[pcol].r = (unsigned char)(r >> 8);
			pal[pcol].g = (unsigned char)(g >> 8);
			pal[pcol].b = (unsigned char)(b >> 8);
			pcol++;
			r += dr;
			g += dg;
			b += db;
		}
	}
	return pcol;
}

struct palm_color *palm_palette(void)
{
	return pal;
}

int palm_palette_size(void)
{
	return pcol;
}


int palm_color_base(unsigned char r, unsigned char g, unsigned char b)
{
	int c;

	if((c = palm_color_index(r, g, b)) == -1) {
		return -1;
	}
	return base_index[c];
}

int palm_color_range(void)
{
	return range;
}
