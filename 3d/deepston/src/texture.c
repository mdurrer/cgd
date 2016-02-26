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

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "texture.h"
#include "palman.h"

struct texture *load_texture(const char *fname)
{
	int i, num_pixels, hdrline = 0;
	struct texture *tex;
	long fpos;

	if(!(tex = malloc(sizeof *tex))) {
		return 0;
	}
	memset(tex, 0, sizeof *tex);

	if(!(tex->file = fopen(fname, "rb"))) {
		fprintf(stderr, "failed to open texture: %s\n", fname);
		free_texture(tex);
		return 0;
	}

	while(hdrline < 3) {
		char buf[64];
		if(!fgets(buf, sizeof buf, tex->file)) {
			fprintf(stderr, "invalid pixmap: %s\n", fname);
			free_texture(tex);
			return 0;
		}

		if(buf[0] == '#') {
			continue;
		}

		switch(hdrline) {
		case 0:
			if(buf[0] != 'P' || buf[1] != '6') {
				fprintf(stderr, "invalid pixmap: %s\n", fname);
				free_texture(tex);
				return 0;
			}
			break;

		case 1:
			if(sscanf(buf, "%d %d", &tex->width, &tex->height) != 2) {
				fprintf(stderr, "invalid pixmap: %s\n", fname);
				free_texture(tex);
				return 0;
			}
			break;

		case 2:
			if(atoi(buf) != 255) {
				fprintf(stderr, "invalid pixmap: %s\n", fname);
				free_texture(tex);
				return 0;
			}
			break;
		}
		hdrline++;
	}
	fpos = ftell(tex->file);

	num_pixels = tex->width * tex->height;
	for(i=0; i<num_pixels; i++) {
		int r, g, b;

		r = fgetc(tex->file);
		g = fgetc(tex->file);
		b = fgetc(tex->file);

		if(feof(tex->file)) {
			fprintf(stderr, "unexpected EOF while reading: %s\n", fname);
			free_texture(tex);
			return 0;
		}

		if(palm_color_index(r, g, b) == -1) {
			palm_add_color(r, g, b);
		}
	}
	fseek(tex->file, fpos, SEEK_SET);
	return tex;
}

void free_texture(struct texture *tex)
{
	if(tex) {
		if(tex->file) {
			fclose(tex->file);
		}
		free(tex->pixels);
		free(tex);
	}
}

unsigned char *get_texture_pixels(struct texture *tex)
{
	if(!tex->pixels && tex->file) {
		int i, num_pixels = tex->width * tex->height;

		if(!(tex->pixels = malloc(num_pixels))) {
			return 0;
		}

		for(i=0; i<num_pixels; i++) {
			int r, g, b, base;

			r = fgetc(tex->file);
			g = fgetc(tex->file);
			b = fgetc(tex->file);

			if((base = palm_color_base(r, g, b)) == -1) {
				base = 0;
			}
			tex->pixels[i] = base;
		}

		fclose(tex->file);
		tex->file = 0;
	}

	return tex->pixels;
}

struct texture *tex_gen_checker(int xsz, int ysz, int ush, int vsh, int c1, int c2)
{
	int i, j;
	struct texture *tex;
	unsigned char *pptr;

	if(!(tex = malloc(sizeof *tex))) {
		return 0;
	}
	memset(tex, 0, sizeof *tex);

	if(!(tex->pixels = malloc(xsz * ysz))) {
		free(tex);
		return 0;
	}
	tex->width = xsz;
	tex->height = ysz;

	pptr = tex->pixels;
	for(i=0; i<ysz; i++) {
		for(j=0; j<xsz; j++) {
			int c = ((i >> vsh) & 1) == ((j >> ush) & 1) ? c1 : c2;
			*pptr++ = c;
		}
	}
	return tex;
}
