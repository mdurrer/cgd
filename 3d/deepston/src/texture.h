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
#ifndef TEXTURE_H_
#define TEXTURE_H_

struct texture {
	int width, height;
	unsigned char *pixels;

	struct {
		unsigned char r, g, b;
	} *palette;
	int num_colors;

	FILE *file;
};

struct texture *load_texture(const char *fname);
void free_texture(struct texture *tex);

unsigned char *get_texture_pixels(struct texture *tex);
int find_texture_color(struct texture *tex, int r, int g, int b);

struct texture *tex_gen_checker(int xsz, int ysz, int usub, int vsub, int c1, int c2);

#endif	/* TEXTURE_H_ */
