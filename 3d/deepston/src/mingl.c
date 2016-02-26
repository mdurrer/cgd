#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <limits.h>
#include <assert.h>
#include "vmath.h"
#include "mingl.h"
#include "mglimpl.h"


#define DOT(a, b)	((a).x * (b).x + (a).y * (b).y + (a).z * (b).z)

#define NORMALIZE(v)	\
	do { \
		float mag = sqrt(DOT(v, v)); \
		if(fabs(mag) > 1e-6) { \
			float invmag = 1.0 / mag; \
			(v).x *= invmag; \
			(v).y *= invmag; \
			(v).z *= invmag; \
		} \
	} while(0)

static void transform(vec4_t *res, vec4_t *v, float *mat);
static void transform3(vec3_t *res, vec3_t *v, float *mat);
static void vertex_proc_view(struct vertex *vert);
static int vertex_proc_proj(struct vertex *vert);
static int calc_shiftmask(int val, int *shiftp, unsigned int *maskp);

static struct state st;
static struct framebuffer fb;

int mgl_init(int width, int height)
{
	int i;

	st.flags = 0;
	st.mmode = 0;

	mgl_front_face(MGL_CCW);
	mgl_cull_face(MGL_BACK);

	st.curv.cidx = 0;
	st.curv.energy = 1.0;
	st.curv.norm.x = st.curv.norm.y = st.curv.norm.z = 0.0;

	if(!(fb.pixels = malloc(width * height))) {
		return -1;
	}
	fb.width = width;
	fb.height = height;
	fb.zbuf = 0;

	if(mgl_rast_init(&st, &fb) == -1) {
		free(fb.pixels);
		return -1;
	}

	st.mtop[0] = st.mtop[1] = 0;

	mgl_matrix_mode(MGL_MODELVIEW);
	mgl_load_identity();
	mgl_matrix_mode(MGL_PROJECTION);
	mgl_load_identity();

	/* initial viewport in the size of the framebuffer */
	st.vp[0] = st.vp[1] = 0;
	st.vp[2] = width;
	st.vp[3] = height;

	st.col_range = 256;
	for(i=0; i<MAX_LIGHTS; i++) {
		st.lpos[i].x = st.lpos[i].y = st.lpos[i].w = 0.0f;
		st.lpos[i].z = 1.0f;
		st.lint[i] = 0.0f;
	}

	st.ambient = 0.1;

	mgl_clip_init(&st);
	return 0;
}

void mgl_free(void)
{
	int i;

	mgl_rast_cleanup();
	free(fb.pixels);
	fb.pixels = 0;

	if(fb.zbuf) {
		for(i=0; i<fb.num_ztiles; i++) {
			free(fb.zbuf[i]);
		}
		free(fb.zbuf);
		fb.zbuf = 0;
	}
}

unsigned char *mgl_framebuffer(void)
{
	return fb.pixels;
}

void mgl_clear(int cidx)
{
	memset(fb.pixels, cidx, fb.width * fb.height);
}

void mgl_clear_depth(void)
{
	int i;

	if(!fb.zbuf) {
		long num_pixels = (long)fb.width * (long)fb.height;
		fb.num_ztiles = (num_pixels + ZTILE_SIZE - 1) / ZTILE_SIZE;

		if(!(fb.zbuf = malloc(fb.num_ztiles * sizeof *fb.zbuf))) {
			fprintf(stderr, "failed to allocate ztile array\n");
			abort();
		}

		for(i=0; i<fb.num_ztiles; i++) {
			if(!(fb.zbuf[i] = malloc(ZTILE_SIZE * 2))) {
				fprintf(stderr, "failed to allocate ztile %d\n", i);
				abort();
			}
			memset(fb.zbuf[i], 0xff, ZTILE_SIZE * 2);
		}
		return;
	}

	for(i=0; i<fb.num_ztiles; i++) {
		memset(fb.zbuf[i], 0xff, ZTILE_SIZE * 2);
	}
}

void mgl_enable(unsigned int what)
{
	st.flags |= (1 << what);
}

void mgl_disable(unsigned int what)
{
	st.flags &= ~(1 << what);
}

int mgl_isenabled(unsigned int what)
{
	return IS_ENABLED(st.flags, what);
}

void mgl_front_face(int ff)
{
	st.frontface = ff;
}

void mgl_cull_face(int cf)
{
	st.cullface = cf;
}

void mgl_set_ambient(float amb)
{
	st.ambient = amb;
}

float mgl_get_ambient(void)
{
	return st.ambient;
}

void mgl_color_range(int rng)
{
	st.col_range = rng;
}

void mgl_light_intensity(int ltidx, float intens)
{
	assert(ltidx >= 0 && ltidx < MAX_LIGHTS);
	st.lint[ltidx] = intens;
}

void mgl_light_position(int ltidx, float x, float y, float z, float w)
{
	vec4_t pos;
	assert(ltidx >= 0 && ltidx < MAX_LIGHTS);

	pos.x = x;
	pos.y = y;
	pos.z = z;
	pos.w = w;
	transform(&st.lpos[ltidx], &pos, st.matrix[MGL_MODELVIEW][st.mtop[MGL_MODELVIEW]]);

	if(fabs(st.lpos[ltidx].w) < 1e-6) {
		NORMALIZE(st.lpos[ltidx]);
	} else {
		st.lpos[ltidx].x /= st.lpos[ltidx].w;
		st.lpos[ltidx].y /= st.lpos[ltidx].w;
		st.lpos[ltidx].z /= st.lpos[ltidx].w;
	}
}

void mgl_begin(int prim)
{
	st.prim = prim;
	st.vidx = 0;

	st.ord = st.frontface;
	if(st.cullface == MGL_FRONT) {
		st.ord = st.frontface == MGL_CCW ? MGL_CW : MGL_CCW;
	}

	/* select the correct rasterizer according to state */
	mgl_rast_prepare();
}

void mgl_end(void)
{
}

void mgl_vertex2f(float x, float y)
{
	mgl_vertex4f(x, y, 0.0f, 1.0f);
}

void mgl_vertex3f(float x, float y, float z)
{
	mgl_vertex4f(x, y, z, 1.0f);
}

void mgl_vertex4f(float x, float y, float z, float w)
{
	st.v[st.vidx].pos.x = x;
	st.v[st.vidx].pos.y = y;
	st.v[st.vidx].pos.z = z;
	st.v[st.vidx].pos.w = w;
	st.v[st.vidx].cidx = st.curv.cidx;
	st.v[st.vidx].energy = st.curv.energy;
	st.v[st.vidx].norm = st.curv.norm;
	st.v[st.vidx].tc = st.curv.tc;

	/* T&L up to view space, to perform user-clipping */
	vertex_proc_view(st.v + st.vidx);

	if(++st.vidx >= st.prim) {
		st.vidx = 0;

		switch(st.prim) {
		case MGL_POINTS:
			vertex_proc_proj(st.v);
			mgl_draw_point(st.v);
			break;
		case MGL_LINES:
			vertex_proc_proj(st.v);
			vertex_proc_proj(st.v + 1);
			mgl_draw_line(st.v, st.v + 1);
			break;
		case MGL_TRIANGLES:
		case MGL_QUADS:
			{
				int nverts = mgl_clip_poly(st.v, st.prim);
				if(nverts > 0) {
					int i;
					/* passed clipping, perform projection for all verts and draw */
					for(i=0; i<nverts; i++) {
						if(vertex_proc_proj(st.v + i) == -1) {
							printf("this shouldn't happen!\n");
							return;
						}
					}
					mgl_draw_poly(st.v, nverts);
				}
			}
			break;
		default:
			fprintf(stderr, "invalid primitive: %d\n", st.prim);
			abort();
		}
	}
}

void mgl_color1f(float energy)
{
	st.curv.energy = energy;
}

void mgl_index(int c)
{
	st.curv.cidx = c;
}

void mgl_normal(float x, float y, float z)
{
	st.curv.norm.x = x;
	st.curv.norm.y = y;
	st.curv.norm.z = z;
}

void mgl_texcoord2f(float x, float y)
{
	st.curv.tc.x = x;
	st.curv.tc.y = y;
}

static void transform(vec4_t *res, vec4_t *v, float *mat)
{
	res->x = mat[0] * v->x + mat[4] * v->y + mat[8] * v->z + mat[12] * v->w;
	res->y = mat[1] * v->x + mat[5] * v->y + mat[9] * v->z + mat[13] * v->w;
	res->z = mat[2] * v->x + mat[6] * v->y + mat[10] * v->z + mat[14] * v->w;
	res->w = mat[3] * v->x + mat[7] * v->y + mat[11] * v->z + mat[15] * v->w;
}

/* the matrix is 4x4 (16 floats), just ignoring anything out of the 3x3 */
static void transform3(vec3_t *res, vec3_t *v, float *mat)
{
	res->x = mat[0] * v->x + mat[4] * v->y + mat[8] * v->z;
	res->y = mat[1] * v->x + mat[5] * v->y + mat[9] * v->z;
	res->z = mat[2] * v->x + mat[6] * v->y + mat[10] * v->z;
}

static void vertex_proc_view(struct vertex *vert)
{
	vec4_t pview;

	float *mvmat = st.matrix[MGL_MODELVIEW][st.mtop[MGL_MODELVIEW]];

	/* modelview transformation */
	transform(&pview, &vert->pos, mvmat);

	if(mgl_isenabled(MGL_LIGHTING)) {
		if(mgl_isenabled(MGL_SMOOTH) || st.vidx == 0) {
			int i;
			vec3_t norm;
			float irrad = st.ambient;

			transform3(&norm, &vert->norm, mvmat);

			for(i=0; i<MAX_LIGHTS; i++) {
				if(st.lint[i] > 1e-6f) {
					float ndotl;
					vec3_t ldir;

					if(st.lpos[i].w == 0.0) {
						ldir.x = st.lpos[i].x;
						ldir.y = st.lpos[i].y;
						ldir.z = st.lpos[i].z;
					} else {
						ldir.x = st.lpos[i].x - pview.x;
						ldir.y = st.lpos[i].y - pview.y;
						ldir.z = st.lpos[i].z - pview.z;

						NORMALIZE(ldir);
					}

					ndotl = DOT(norm, ldir);
					if(ndotl < 0.0) {
						ndotl = 0.0;
					}
					irrad += ndotl * st.lint[i];
				}
			}
			vert->energy = irrad > 1.0 ? 1.0 : irrad;
		} else {
			vert->energy = st.v[0].energy;
		}
	}

	vert->pos = pview;
}

static int vertex_proc_proj(struct vertex *vert)
{
	vec4_t pclip;

	float *pmat = st.matrix[MGL_PROJECTION][st.mtop[MGL_PROJECTION]];

	transform(&pclip, &vert->pos, pmat);
	/* TODO clipping in homogenous clip space */

	if(pclip.w < 1e-6) {
		vert->pos.x = vert->pos.y = vert->pos.z = vert->pos.w = 0.0f;
		return -1;
	}

	/* perspective division */
	vert->pos.x = pclip.x / pclip.w;
	vert->pos.y = pclip.y / pclip.w;
	vert->pos.z = pclip.z / pclip.w;
	vert->pos.w = pclip.w;

	/* viewport transformation */
	vert->pos.x = st.vp[0] + st.vp[2] * (vert->pos.x * 0.5 + 0.5);
	vert->pos.y = st.vp[1] + st.vp[3] * (-vert->pos.y * 0.5 + 0.5);

	return 0;
}

void mgl_viewport(int x, int y, int width, int height)
{
	st.vp[0] = x;
	st.vp[1] = y;
	st.vp[2] = width;
	st.vp[3] = height;
}

void mgl_matrix_mode(int mmode)
{
	st.mmode = mmode;
}

void mgl_push_matrix(void)
{
	float *topmat;
	if(st.mtop[st.mmode] >= MATRIX_STACK_SIZE - 1) {
		fprintf(stderr, "mgl_push_matrix: stack overflow\n");
		abort();
	}

	topmat = st.matrix[st.mmode][st.mtop[st.mmode]];
	memcpy(topmat + 16, topmat, 16 * sizeof *topmat);
	st.mmode++;
}

void mgl_pop_matrix(void)
{
	if(st.mtop[st.mmode] <= 0) {
		fprintf(stderr, "mgl_pop_matrix: stack underflow\n");
		abort();
	}
	st.mtop[st.mmode]--;
}

void mgl_load_matrix(float *mat)
{
	float *dest = st.matrix[st.mmode][st.mtop[st.mmode]];
	memcpy(dest, mat, 16 * sizeof *dest);
}

#define M(i,j)	(((i) << 2) + (j))
void mgl_mult_matrix(float *m2)
{
	int i, j;
	float m1[16];
	float *dest = st.matrix[st.mmode][st.mtop[st.mmode]];

	memcpy(m1, dest, sizeof m1);

	for(i=0; i<4; i++) {
		for(j=0; j<4; j++) {
			dest[M(i,j)] = m1[M(0,j)] * m2[M(i,0)] +
				m1[M(1,j)] * m2[M(i,1)] +
				m1[M(2,j)] * m2[M(i,2)] +
				m1[M(3,j)] * m2[M(i,3)];
		}
	}
}

void mgl_load_identity(void)
{
	static float id[] = {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1};
	mgl_load_matrix((float*)id);
}

void mgl_translate(float x, float y, float z)
{
	float xform[] = {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1};
	xform[12] = x;
	xform[13] = y;
	xform[14] = z;
	mgl_mult_matrix(xform);
}

void mgl_rotate(float deg, float x, float y, float z)
{
	float xform[] = {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1};

	float angle = M_PI * deg / 180.0f;
	float sina = sin(angle);
	float cosa = cos(angle);
	float one_minus_cosa = 1.0f - cosa;
	float nxsq = x * x;
	float nysq = y * y;
	float nzsq = z * z;

	xform[0] = nxsq + (1.0f - nxsq) * cosa;
	xform[4] = x * y * one_minus_cosa - z * sina;
	xform[8] = x * z * one_minus_cosa + y * sina;
	xform[1] = x * y * one_minus_cosa + z * sina;
	xform[5] = nysq + (1.0 - nysq) * cosa;
	xform[9] = y * z * one_minus_cosa - x * sina;
	xform[2] = x * z * one_minus_cosa - y * sina;
	xform[6] = y * z * one_minus_cosa + x * sina;
	xform[10] = nzsq + (1.0 - nzsq) * cosa;

	mgl_mult_matrix(xform);
}

void mgl_scale(float x, float y, float z)
{
	float xform[] = {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1};
	xform[0] = x;
	xform[5] = y;
	xform[10] = z;
	mgl_mult_matrix(xform);
}

void gl_ortho(float left, float right, float bottom, float top, float nr, float fr)
{
	float xform[] = {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1};

	float dx = right - left;
	float dy = top - bottom;
	float dz = fr - nr;

	float tx = -(right + left) / dx;
	float ty = -(top + bottom) / dy;
	float tz = -(fr + nr) / dz;

	float sx = 2.0 / dx;
	float sy = 2.0 / dy;
	float sz = -2.0 / dz;

	xform[0] = sx;
	xform[5] = sy;
	xform[10] = sz;
	xform[12] = tx;
	xform[13] = ty;
	xform[14] = tz;

	mgl_mult_matrix(xform);
}

void mgl_frustum(float left, float right, float bottom, float top, float nr, float fr)
{
	float xform[] = {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1};

	float dx = right - left;
	float dy = top - bottom;
	float dz = fr - nr;

	float a = (right + left) / dx;
	float b = (top + bottom) / dy;
	float c = -(fr + nr) / dz;
	float d = -2.0 * fr * nr / dz;

	xform[0] = 2.0 * nr / dx;
	xform[5] = 2.0 * nr / dy;
	xform[8] = a;
	xform[9] = b;
	xform[10] = c;
	xform[11] = -1.0f;
	xform[14] = d;

	mgl_mult_matrix(xform);
}

void mgl_perspective(float vfov, float aspect, float nr, float fr)
{
	float vfov_rad = M_PI * vfov / 180.0;
	float x = nr * tan(vfov_rad / 2.0);
	mgl_frustum(-aspect * x, aspect * x, -x, x, nr, fr);
}

void mgl_teximage(int width, int height, unsigned char *pixels)
{
	st.tex.width = width;
	st.tex.height = height;
	st.tex.pixels = pixels;

	if(calc_shiftmask(width, &st.tex.xshift, &st.tex.xmask) == -1 ||
			calc_shiftmask(height, &st.tex.yshift, &st.tex.ymask) == -1) {
		st.tex.pixels = 0;
	}
}

void mgl_clip_plane(int id, float nx, float ny, float nz, float dist)
{
	id -= MGL_CLIP_PLANE0;

	if(id < 0 || id > MAX_CLIP_PLANES) {
		return;
	}

	st.clip_planes[id].normal.x = nx;
	st.clip_planes[id].normal.y = ny;
	st.clip_planes[id].normal.z = nz;
	NORMALIZE(st.clip_planes[id].normal);

	st.clip_planes[id].pt.x = st.clip_planes[id].normal.x * dist;
	st.clip_planes[id].pt.y = st.clip_planes[id].normal.y * dist;
	st.clip_planes[id].pt.z = st.clip_planes[id].normal.z * dist;

	printf("set clip plane %d -> n[%f %f %f]  p[%f %f %f]\n", id,
			st.clip_planes[id].normal.x, st.clip_planes[id].normal.y, st.clip_planes[id].normal.z,
			st.clip_planes[id].pt.x, st.clip_planes[id].pt.y, st.clip_planes[id].pt.z);

}

#define MAX_SHIFT	12
static int calc_shiftmask(int val, int *shiftp, unsigned int *maskp)
{
	int i;

	for(i=0; i<MAX_SHIFT; i++) {
		if((val >> i) == 1) {
			*shiftp = i;
			*maskp = ~(UINT_MAX << i);
			return 0;
		}
	}
	return -1;
}
