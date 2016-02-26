#include <math.h>
#include <assert.h>
#include "mingl.h"
#include "vmath.h"


void mgl_cube(float sz)
{
	float hsz = sz * 0.5;

	mgl_begin(MGL_QUADS);
	/* front */
	mgl_normal(0, 0, 1);
	mgl_texcoord2f(0, 0); mgl_vertex3f(-hsz, hsz, hsz);
	mgl_texcoord2f(0, 1); mgl_vertex3f(-hsz, -hsz, hsz);
	mgl_texcoord2f(1, 1); mgl_vertex3f(hsz, -hsz, hsz);
	mgl_texcoord2f(1, 0); mgl_vertex3f(hsz, hsz, hsz);
	/* back */
	mgl_normal(0, 0, -1);
	mgl_texcoord2f(0, 0); mgl_vertex3f(hsz, hsz, -hsz);
	mgl_texcoord2f(0, 1); mgl_vertex3f(hsz, -hsz, -hsz);
	mgl_texcoord2f(1, 1); mgl_vertex3f(-hsz, -hsz, -hsz);
	mgl_texcoord2f(1, 0); mgl_vertex3f(-hsz, hsz, -hsz);
	/* right */
	mgl_normal(1, 0, 0);
	mgl_texcoord2f(0, 0); mgl_vertex3f(hsz, hsz, hsz);
	mgl_texcoord2f(0, 1); mgl_vertex3f(hsz, -hsz, hsz);
	mgl_texcoord2f(1, 1); mgl_vertex3f(hsz, -hsz, -hsz);
	mgl_texcoord2f(1, 0); mgl_vertex3f(hsz, hsz, -hsz);
	/* left */
	mgl_normal(-1, 0, 0);
	mgl_texcoord2f(0, 0); mgl_vertex3f(-hsz, hsz, -hsz);
	mgl_texcoord2f(0, 1); mgl_vertex3f(-hsz, -hsz, -hsz);
	mgl_texcoord2f(1, 1); mgl_vertex3f(-hsz, -hsz, hsz);
	mgl_texcoord2f(1, 0); mgl_vertex3f(-hsz, hsz, hsz);
	/* top */
	mgl_normal(0, 1, 0);
	mgl_texcoord2f(0, 0); mgl_vertex3f(-hsz, hsz, -hsz);
	mgl_texcoord2f(0, 1); mgl_vertex3f(-hsz, hsz, hsz);
	mgl_texcoord2f(1, 1); mgl_vertex3f(hsz, hsz, hsz);
	mgl_texcoord2f(1, 0); mgl_vertex3f(hsz, hsz, -hsz);
	/* bottom */
	mgl_normal(0, -1, 0);
	mgl_texcoord2f(0, 0); mgl_vertex3f(hsz, -hsz, -hsz);
	mgl_texcoord2f(0, 1); mgl_vertex3f(hsz, -hsz, hsz);
	mgl_texcoord2f(1, 1); mgl_vertex3f(-hsz, -hsz, hsz);
	mgl_texcoord2f(1, 0); mgl_vertex3f(-hsz, -hsz, -hsz);
	mgl_end();
}

void mgl_sphere(float rad, int usub, int vsub)
{
	mgl_sphere_part(rad, usub, vsub, 1.0, 1.0);
}

#define sphere_vertex(u, v) \
	do { \
		float x, y, z, theta, phi; \
		float costheta, sinphi; \
		theta = (u) * 2.0 * M_PI; \
		phi = (v) * M_PI; \
		costheta = cos(theta); \
		sinphi = sin(phi); \
		x = costheta * sinphi; \
		y = cos(phi); \
		z = sin(theta) * sinphi; \
		mgl_normal(x, y, z); \
		mgl_texcoord2f(u, v); \
		mgl_vertex3f(rad * x, rad * y, rad * z); \
	} while(0)

void mgl_sphere_part(float rad, int usub, int vsub, float umax, float vmax)
{
	int i, j;
	float u, v, du, dv;

	assert(usub > 2);
	assert(vsub > 2);

	du = umax / (float)usub;
	dv = vmax / (float)vsub;

	mgl_begin(MGL_QUADS);

	u = 0.0;
	for(i=0; i<usub; i++) {
		v = 0.0;
		for(j=0; j<vsub; j++) {
			sphere_vertex(u, v);
			sphere_vertex(u + du, v);
			sphere_vertex(u + du, v + dv);
			sphere_vertex(u, v + dv);
			v += dv;
		}
		u += du;
	}
	mgl_end();
}

void mgl_torus(float inner, float outer, int usub, int vsub)
{
	mgl_torus_part(inner, outer, usub, vsub, 1.0, 0.0, 1.0);
}

#define torus_vertex(u, v) \
	do { \
		float rx, ry, rz, cx, cy, cz, theta, phi; \
		float costheta, sintheta, sinphi; \
		theta = (u) * 2.0 * M_PI; \
		phi = (v) * 2.0 * M_PI; \
		costheta = cos(theta); \
		sintheta = sin(theta); \
		sinphi = sin(phi); \
		cx = costheta * inner; \
		cy = 0.0f; \
		cz = sintheta * inner; \
		rx = costheta * sinphi; \
		ry = cos(phi); \
		rz = sintheta * sinphi; \
		mgl_normal(rx, ry, rz); \
		mgl_texcoord2f(u, v); \
		mgl_vertex3f(outer * rx + cx, outer * ry + cy, outer * rz + cz); \
	} while(0)

void mgl_torus_part(float inner, float outer, int usub, int vsub, float umax, float vmin, float vmax)
{
	int i, j;
	float u, v, du, dv;

	assert(usub > 2);
	assert(vsub > 2);

	du = umax / (float)usub;
	dv = (vmax - vmin) / (float)vsub;

	mgl_begin(MGL_QUADS);

	u = 0.0;
	for(i=0; i<usub; i++) {
		v = vmin;
		for(j=0; j<vsub; j++) {
			torus_vertex(u, v);
			torus_vertex(u + du, v);
			torus_vertex(u + du, v + dv);
			torus_vertex(u, v + dv);
			v += dv;
		}
		u += du;
	}
	mgl_end();
}
