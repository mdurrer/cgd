#ifndef FIXED_POINT_H_
#define FIXED_POINT_H_

#include "inttypes.h"

#ifdef DBG_USE_FLOAT
typedef float fixed;
#else
typedef int32_t fixed;
#endif

/* valid choices for DECIMAL_BITS
 *      8: for fixed point 24:8
 *     16: for fixed point 16:16
 */
#define DECIMAL_BITS	16

#if DECIMAL_BITS == 8
#define FIXED_SHIFT		8
#define FLT_SCALE		256.0f
#define FRAC_MASK		0xff
#else	/* DECIMAL_BITS == 16 */
#define FIXED_SHIFT		16
#define FLT_SCALE		65536.0f
#define FRAC_MASK		0xffff
#endif	/* DECIMAL_BITS */

/*extern const fixed fixed_zero;
extern const fixed fixed_one;
extern const fixed fixed_half;
extern const fixed fixed_tenth;
extern const fixed fixed_255;*/

#ifdef DBG_USE_FLOAT
/* ------- debug mode, use floating point -------- */
#define FIXED_INT_PART(n)	((int)(n))
#define FIXED_FRAC_PART(n)	((n) > 0.0f ? (FIXED_INT_PART(n) - (n)) : (FIXED_INT_PART(n) + (n)))
#define FIXED_ROUND(n)		FIXED_INT_PART((n) >= 0.0 ? (n) + 0.5f : (n) - 0.5f)

#define FIXED_TO_FLOAT(n)	(n)
#define FLOAT_TO_FIXED(n)	(n)
#define INT_TO_FIXED(n)		((float)(n))

#define FIXED_EPSILON		(1e-6)

#else	/* ---- really fixed point ---- */

#define FIXED_INT_PART(n)	((n) >> FIXED_SHIFT)
#define FIXED_FRAC_PART(n)	((n) & FRAC_MASK)
#define FIXED_ROUND(n)		FIXED_INT_PART((n) >= 0 ? (n) + fixedf(0.5) : (n) - fixedf(0.5))
/*#define FIXED_ROUND(n)		FIXED_INT_PART(n)*/

#define FIXED_TO_FLOAT(n)	(float)((n) / FLT_SCALE)
#define FLOAT_TO_FIXED(n)	(fixed)((n) * FLT_SCALE)
#define INT_TO_FIXED(n)		(fixed)((n) << FIXED_SHIFT)

#define FIXED_EPSILON		(1)

#endif


#define fixed_int(n)		FIXED_INT_PART(n)
#define fixed_frac(n)		FIXED_FRAC_PART(n)
#define fixed_float(n)		FIXED_TO_FLOAT(n)
#define fixed_round(n)		FIXED_ROUND(n)

#define fixedf(n)			FLOAT_TO_FIXED(n)
#define fixedi(n)			INT_TO_FIXED(n)

#define fixed_add(n1, n2)	((n1) + (n2))
#define fixed_sub(n1, n2)	((n1) - (n2))



#ifdef DBG_USE_FLOAT

#define fixed_mul(n1, n2)	((n1) * (n2))
#define fixed_div(n1, n2)	((n1) / (n2))

#define fixed_sin(x)	(fixed)sin(x)
#define fixed_cos(x)	(fixed)cos(x)

#else

#if DECIMAL_BITS == 8
#define fixed_mul(n1, n2)	(fixed)((n1) * (n2) >> FIXED_SHIFT)
#define fixed_div(n1, n2)	(((n1) << FIXED_SHIFT) / (n2))
#else
#define fixed_div(n1, n2)	(((n2) >> 8) ? (((n1) << 8) / ((n2) >> 8)) : (n1))
#define fixed_mul(n1, n2)	(((n1) >> 8) * ((n2) >> 8))
#endif	/* DECIMAL_BITS */

#ifdef __cplusplus
extern "C" {
#endif

fixed fixed_sin(fixed angle);
fixed fixed_cos(fixed angle);

#ifdef __cplusplus
}
#endif

#endif

#endif	/* FIXED_POINT_H_ */
