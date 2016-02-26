#ifndef VMATH_H_
#define VMATH_H_

#include <math.h>
#include "fixedp.h"

#ifndef M_PI
#define M_PI	3.1415926536
#endif

typedef struct {
	float x, y, z, w;
} vec4_t;

typedef struct {
	float x, y, z;
} vec3_t;

typedef struct {
	float x, y;
} vec2_t;

typedef struct {
	fixed x, y, z, w;
} vec4x_t;

typedef struct {
	fixed x, y, z;
} vec3x_t;

typedef struct {
	fixed x, y;
} vec2x_t;

typedef struct {
	vec3_t origin, dir;
} ray3_t;

#define vec3_dot(a, b)	((a).x * (b).x + (a).y * (b).y + (a).z * (b).z)

#define vec2_lerp(res, a, b, t) \
	do { \
		(res).x = (a).x + ((b).x - (a).x) * (t); \
		(res).y = (a).y + ((b).y - (a).y) * (t); \
	} while(0)

#define vec3_lerp(res, a, b, t) \
	do { \
		(res).x = (a).x + ((b).x - (a).x) * (t); \
		(res).y = (a).y + ((b).y - (a).y) * (t); \
		(res).z = (a).z + ((b).z - (a).z) * (t); \
	} while(0)

#define ray3_point(res, ray, t) \
	do { \
		(res).x = (ray).origin.x + (ray).dir.x * (t); \
		(res).y = (ray).origin.y + (ray).dir.y * (t); \
		(res).z = (ray).origin.z + (ray).dir.z * (t); \
	} while(0)

#define vec2_to_fixed2(v, f) \
	do { \
		(f).x = fixedf((v).x); \
		(f).y = fixedf((v).y); \
	} while(0)

#define vec3_to_fixed3(v, f) \
	do { \
		(f).x = fixedf((v).x); \
		(f).y = fixedf((v).y); \
		(f).z = fixedf((v).z); \
	} while(0)

#define vec4_to_fixed4(v, f) \
	do { \
		(f).x = fixedf((v).x); \
		(f).y = fixedf((v).y); \
		(f).z = fixedf((v).z); \
		(f).w = fixedf((v).w); \
	} while(0)


#define fixed2_to_vec2(f, v) \
	do { \
		(v).x = fixed_float((f).x); \
		(v).y = fixed_float((f).y); \
	} while(0)

#define fixed3_to_vec3(f, v) \
	do { \
		(v).x = fixed_float((f).x); \
		(v).y = fixed_float((f).y); \
		(v).z = fixed_float((f).z); \
	} while(0)

#define fixed4_to_vec4(f, v) \
	do { \
		(v).x = fixed_float((f).x); \
		(v).y = fixed_float((f).y); \
		(v).z = fixed_float((f).z); \
		(v).w = fixed_float((f).w); \
	} while(0)


#endif	/* VMATH_H_ */
