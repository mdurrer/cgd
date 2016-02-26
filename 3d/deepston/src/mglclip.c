#include <stdio.h>
#include <string.h>
#include <assert.h>
#include "mingl.h"
#include "mglimpl.h"

static struct state *st;

static float distance_signed(vec3_t p, const struct plane *plane);
static int intersect(const ray3_t *ray, const struct plane *plane, float *t);
static int clip_polygon(struct vertex *vout, int *voutnum, const struct vertex *vin, int vnum,
		const struct plane *plane);

#define ZNEAR	MAX_CLIP_PLANES

int mgl_clip_init(struct state *state)
{
	st = state;

	memset(st->clip_planes, 0, sizeof st->clip_planes);

	/* always setup a near clipping plane */
	st->clip_planes[ZNEAR].normal.x = st->clip_planes[ZNEAR].normal.y = 0;
	st->clip_planes[ZNEAR].normal.z = -1;
	st->clip_planes[ZNEAR].pt.x = st->clip_planes[ZNEAR].pt.y = 0;
	st->clip_planes[ZNEAR].pt.z = -0.5;

	return 0;
}

int mgl_clip_poly(struct vertex *v, int vnum)
{
	int i, res, clipped_vnum;
	struct vertex tmp[6];

	for(i=0; i<MAX_CLIP_PLANES + 1; i++) {
		if(i < ZNEAR && !mgl_isenabled(MGL_CLIP_PLANE0 + i)) {
			continue;
		}

		res = clip_polygon(tmp, &clipped_vnum, v, vnum, st->clip_planes + i);
		if(res == -1) {
			/* the polygon was completely outside */
			return 0;
		}
		if(res == 0) {
			/* the polygon was clipped, update v and vnum */
			vnum = clipped_vnum;
			memcpy(v, tmp, clipped_vnum * sizeof *v);
		}
		/* otherwise the polygon was completely inside, nothing to do... */
	}

	return vnum;
}

static float distance_signed(vec3_t p, const struct plane *plane)
{
	vec3_t ptdir;
	ptdir.x = p.x - plane->pt.x;
	ptdir.y = p.y - plane->pt.y;
	ptdir.z = p.z - plane->pt.z;

	return vec3_dot(ptdir, plane->normal);
}

static int intersect(const ray3_t *ray, const struct plane *plane, float *t)
{
	vec3_t orig_pt_dir;

	float ndotdir = vec3_dot(plane->normal, ray->dir);
	if(fabs(ndotdir) < 1e-4) {
		*t = 0.0f;
		return 0;
	}

	orig_pt_dir.x = plane->pt.x - ray->origin.x;
	orig_pt_dir.y = plane->pt.y - ray->origin.y;
	orig_pt_dir.z = plane->pt.z - ray->origin.z;

	*t = vec3_dot(plane->normal, orig_pt_dir) / ndotdir;
	return 1;
}

static int clip_edge(struct vertex *poly, int *vnum, const struct vertex *v0,
		const struct vertex *v1, const struct plane *plane);

/* returns:
 *  1 -> both inside
 *  0 -> straddling and clipped
 * -1 -> both outside
 *
 * the size of the vout polygon is returned throug voutnum
 */
static int clip_polygon(struct vertex *vout, int *voutnum, const struct vertex *vin, int vnum,
		const struct plane *plane)
{
	int i;
	int edges_clipped = 0;
	int out_vnum = 0;

	for(i=0; i<vnum; i++) {
		int res = clip_edge(vout, &out_vnum, vin + i, vin + (i + 1) % vnum, plane);
		if(res == 0) {
			edges_clipped++;
		}
	}

	if(out_vnum <= 0) {
		assert(edges_clipped == 0);
		return -1;
	}

	*voutnum = out_vnum;
	return edges_clipped > 0 ? 0 : 1;
}

/* returns:
 *  1 -> both inside
 *  0 -> straddling and clipped
 * -1 -> both outside
 *
 *  also returns the size of the polygon through vnumptr
 */
static int clip_edge(struct vertex *poly, int *vnumptr, const struct vertex *v0,
		const struct vertex *v1, const struct plane *plane)
{
	vec3_t pos0, pos1;
	float d0, d1, t;
	ray3_t ray;
	int vnum = *vnumptr;

	pos0.x = v0->pos.x; pos0.y = v0->pos.y; pos0.z = v0->pos.z;
	pos1.x = v1->pos.x; pos1.y = v1->pos.y; pos1.z = v1->pos.z;

	d0 = distance_signed(pos0, plane);
	d1 = distance_signed(pos1, plane);

	ray.origin = pos0;
	ray.dir.x = pos1.x - pos0.x;
	ray.dir.y = pos1.y - pos0.y;
	ray.dir.z = pos1.z - pos0.z;

	if(d0 >= 0.0) {
		/* start inside */
		if(d1 >= 0.0) {
			/* all inside */
			poly[vnum++] = *v1;	/* append v1 */
			*vnumptr = vnum;
			return 1;
		} else {
			/* going out */
			intersect(&ray, plane, &t);

			ray3_point(poly[vnum].pos, ray, t);
			poly[vnum].pos.w = 1.0;

			vec3_lerp(poly[vnum].norm, v0->norm, v1->norm, t);
			vec2_lerp(poly[vnum].tc, v0->tc, v1->tc, t);
			poly[vnum].energy = v0->energy + (v1->energy - v0->energy) * t;
			poly[vnum].cidx = v0->cidx;
			vnum++;	/* append new vertex on the intersection point */
		}
	} else {
		/* start outside */
		if(d1 >= 0) {
			/* going in */
			intersect(&ray, plane, &t);

			ray3_point(poly[vnum].pos, ray, t);
			poly[vnum].pos.w = 1.0;

			vec3_lerp(poly[vnum].norm, v0->norm, v1->norm, t);
			vec2_lerp(poly[vnum].tc, v0->tc, v1->tc, t);
			poly[vnum].energy = v0->energy + (v1->energy - v0->energy) * t;
			poly[vnum].cidx = v0->cidx;
			vnum++;	/* append new vertex on the intersection point */

			/* then append v1 ... */
			poly[vnum++] = *v1;
		} else {
			/* all outside */
			return -1;
		}
	}

	*vnumptr = vnum;
	return 0;
}
