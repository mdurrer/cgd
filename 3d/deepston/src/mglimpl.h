#ifndef MGL_IMPL_H_
#define MGL_IMPL_H_

#include "vmath.h"

#define MATRIX_STACK_SIZE	8
#define MAX_LIGHTS			4
#define MAX_CLIP_PLANES		6

#define ZTILE_SIZE			16384
#define ZTILE_SHIFT			14
#define ZTILE_MASK			0x3fff

#define ZTILE(x)			(((x) & ~ZTILE_MASK) >> ZTILE_SHIFT)
#define ZTILE_OFFS(x)		((x) & ZTILE_MASK)

#define ROUND(x)	((x) >= 0.0 ? (x) + 0.5 : (x) - 0.5)


typedef float mat4_t[16];

struct vertex {
	vec4_t pos;
	vec3_t norm;
	vec2_t tc;
	float energy;
	int cidx;
};

struct fixed_vertex {
	vec4x_t pos;
	vec4x_t norm;
	vec2x_t tc;
	fixed energy;
	int cidx;
};

struct plane {
	vec3_t pt;
	vec3_t normal;
};

struct texture {
	int width, height;
	int xshift, yshift;
	unsigned int xmask, ymask;
	unsigned char *pixels;
};

struct state {
	unsigned int flags;
	int ord, frontface, cullface;
	int mmode, mtop[2];
	mat4_t matrix[2][MATRIX_STACK_SIZE];
	int prim;
	struct vertex curv, v[6];
	int vidx;
	int vp[4];	/* viewport */
	int col_range;	/* color interpolation range */
	vec4_t lpos[MAX_LIGHTS];
	float lint[MAX_LIGHTS];
	float ambient;

	struct plane clip_planes[MAX_CLIP_PLANES + 1];

	struct texture tex;
};

struct framebuffer {
	int width, height;
	unsigned char *pixels;
	unsigned short **zbuf;	/* zbuffer broken in ZTILE_SIZE tiles */
	int num_ztiles;
};

#define IS_ENABLED(f, x)	((f) & (1 << (x)))

#define vertex_to_fixedvertex(v, vx) \
	do { \
		vec4_to_fixed4((v).pos, (vx).pos); \
		vec3_to_fixed3((v).norm, (vx).norm); \
		vec2_to_fixed2((v).tc, (vx).tc); \
		(vx).energy = fixedf((v).energy); \
		(vx).cidx = (v).cidx; \
	} while(0)

#define fixedvertex_to_vertex(vx, v) \
	do { \
		fixed4_to_vec4((vx).pos, (v).pos); \
		fixed3_to_vec3((vx).norm, (v).norm); \
		fixed2_to_vec2((vx).tc, (v).tc); \
		(v).energy = fixed_float((vx).energy); \
		(v).cidx = (vx).cidx; \
	} while(0)


int mgl_rast_init(struct state *state, struct framebuffer *fbuf);
void mgl_rast_cleanup(void);
void mgl_rast_prepare(void);
void mgl_draw_point(struct vertex *v);
void mgl_draw_line(struct vertex *v0, struct vertex *v1);
void mgl_draw_poly(struct vertex *v, int numv);

int mgl_clip_init(struct state *state);
int mgl_clip_poly(struct vertex *v, int vnum);

#endif	/* MGL_IMPL_H_ */
