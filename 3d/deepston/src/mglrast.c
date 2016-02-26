#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <limits.h>
#include <assert.h>
#include "mingl.h"
#include "mglimpl.h"


#ifdef RAST_FLOAT
typedef struct vertex VERTEX;
#else
typedef struct fixed_vertex VERTEX;
#endif

static VERTEX *vleft, *vright;
static struct framebuffer *fb;
static struct state *st;


#define SCAN_EDGE scan_edge_flat
#define SCAN_LINE scan_line_flat
#undef INTERP_DEPTH
#undef INTERP_ENERGY
#undef INTERP_TEX
#include "scantmpl.h"
#undef SCAN_EDGE
#undef SCAN_LINE

#define SCAN_EDGE scan_edge_z
#define SCAN_LINE scan_line_z
#define INTERP_DEPTH
#undef INTERP_ENERGY
#undef INTERP_TEX
#include "scantmpl.h"
#undef SCAN_EDGE
#undef SCAN_LINE

#define SCAN_EDGE scan_edge_e
#define SCAN_LINE scan_line_e
#undef INTERP_DEPTH
#define INTERP_ENERGY
#undef INTERP_TEX
#include "scantmpl.h"
#undef SCAN_EDGE
#undef SCAN_LINE

#define SCAN_EDGE scan_edge_ze
#define SCAN_LINE scan_line_ze
#define INTERP_DEPTH
#define INTERP_ENERGY
#undef INTERP_TEX
#include "scantmpl.h"
#undef SCAN_EDGE
#undef SCAN_LINE

#define SCAN_EDGE scan_edge_t
#define SCAN_LINE scan_line_t
#undef INTERP_DEPTH
#undef INTERP_ENERGY
#define INTERP_TEX
#include "scantmpl.h"
#undef SCAN_EDGE
#undef SCAN_LINE

#define SCAN_EDGE scan_edge_zt
#define SCAN_LINE scan_line_zt
#define INTERP_DEPTH
#undef INTERP_ENERGY
#define INTERP_TEX
#include "scantmpl.h"
#undef SCAN_EDGE
#undef SCAN_LINE

#define SCAN_EDGE scan_edge_et
#define SCAN_LINE scan_line_et
#undef INTERP_DEPTH
#define INTERP_ENERGY
#define INTERP_TEX
#include "scantmpl.h"
#undef SCAN_EDGE
#undef SCAN_LINE

#define SCAN_EDGE scan_edge_zet
#define SCAN_LINE scan_line_zet
#define INTERP_DEPTH
#define INTERP_ENERGY
#define INTERP_TEX
#include "scantmpl.h"
#undef SCAN_EDGE
#undef SCAN_LINE


static void (*scan_edge)(VERTEX*, VERTEX*);
static void (*scan_line)(int, unsigned char*);


int mgl_rast_init(struct state *state, struct framebuffer *fbuf)
{
	fb = fbuf;
	st = state;

	if(!(vleft = malloc(fb->height * sizeof *vleft))) {
		return -1;
	}
	if(!(vright = malloc(fb->height * sizeof *vright))) {
		free(vleft);
		return -1;
	}

	scan_edge = scan_edge_flat;
	scan_line = scan_line_flat;

	return 0;
}

void mgl_rast_cleanup(void)
{
	free(vleft);
	free(vright);
}

void mgl_rast_prepare(void)
{
	static void (*sedge[])(VERTEX*, VERTEX*) = {
							/* tez */
		scan_edge_flat,		/* 000 */
		scan_edge_z,		/* 001 */
		scan_edge_e,		/* 010 */
		scan_edge_ze,		/* 011 */
		scan_edge_t,		/* 100 */
		scan_edge_zt,		/* 101 */
		scan_edge_et,		/* 110 */
		scan_edge_zet		/* 111 */
	};
	static void (*sline[])(int, unsigned char*) = {
							/* tez */
		scan_line_flat,		/* 000 */
		scan_line_z,		/* 001 */
		scan_line_e,		/* 010 */
		scan_line_ze,		/* 011 */
		scan_line_t,		/* 100 */
		scan_line_zt,		/* 101 */
		scan_line_et,		/* 110 */
		scan_line_zet		/* 111 */
	};
	int bits = 0;

	if(IS_ENABLED(st->flags, MGL_TEXTURE_2D) && st->tex.pixels) {
		bits |= 4;
	}
	if(IS_ENABLED(st->flags, MGL_SMOOTH)) {
		bits |= 2;
	}
	if(IS_ENABLED(st->flags, MGL_DEPTH_TEST) && fb->zbuf) {
		bits |= 1;
	}

	scan_edge = sedge[bits];
	scan_line = sline[bits];
}

void mgl_draw_point(struct vertex *v)
{
	int x = (int)ROUND(v->pos.x);
	int y = (int)ROUND(v->pos.y);

	if(x >= 0 && x < fb->width && y >= 0 && y < fb->height) {
		int cidx = v->cidx + v->energy * st->col_range;
		fb->pixels[y * fb->width + x] = cidx;
	}
}

void mgl_draw_line(struct vertex *v0, struct vertex *v1)
{
	/* TODO */
	fprintf(stderr, "draw_line unimplemented\n");
	abort();
}

void mgl_draw_poly(struct vertex *v, int numv)
{
#ifdef RAST_FLOAT
	int ybeg, yend, i;
	unsigned char *sline;

	ybeg = fb->height;
	yend = 0;

	for(i=0; i<numv; i++) {
		struct vertex *v0 = v + i;
		struct vertex *v1 = v + (i + 1) % numv;
		int y = (int)ROUND(v0->pos.y);

		scan_edge(v0, v1);

		if(y > yend) yend = y;
		if(y < ybeg) ybeg = y;
	}

	if(ybeg < 0) ybeg = 0;
	if(yend >= fb->height) yend = fb->height - 1;

	sline = fb->pixels + ybeg * fb->width;
	for(i=ybeg; i<yend; i++) {
		scan_line(i, sline);
		sline += fb->width;
	}
#else
	int ybeg, yend, i;
	unsigned char *sline;

	ybeg = fb->height;
	yend = 0;

	for(i=0; i<numv; i++) {
		int y;
		struct vertex *v0 = v + i;
		struct vertex *v1 = v + (i + 1) % numv;
		struct fixed_vertex vx0, vx1;

		vertex_to_fixedvertex(*v0, vx0);
		vertex_to_fixedvertex(*v1, vx1);

		y = fixed_round(vx0.pos.y);

		scan_edge(&vx0, &vx1);

		if(y > yend) yend = y;
		if(y < ybeg) ybeg = y;
	}

	if(ybeg < 0) ybeg = 0;
	if(yend >= fb->height) yend = fb->height - 1;

	sline = fb->pixels + ybeg * fb->width;
	for(i=ybeg; i<yend; i++) {
		scan_line(i, sline);
		sline += fb->width;
	}
#endif
}
