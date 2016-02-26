#include <math.h>
#include "fixedp.h"

const fixed fixed_zero = 0;
const fixed fixed_one = fixedi(1);
const fixed fixed_half = fixedf(0.5);
const fixed fixed_tenth = fixedf(0.1);
const fixed fixed_255 = fixedi(255);

#ifndef DBG_USE_FLOAT

#define PI			3.1415927
#define TWO_PI		6.2831853

#define LUT_SIZE	256

static fixed sin_lut[LUT_SIZE], cos_lut[LUT_SIZE];
static int initialized;

static void precalc_lut(void)
{
	int i;

	for(i=0; i<LUT_SIZE; i++) {
		float angle = TWO_PI * (float)i / (float)LUT_SIZE;

		sin_lut[i] = FLOAT_TO_FIXED(sin(angle));
		cos_lut[i] = FLOAT_TO_FIXED(cos(angle));
	}

	initialized = 1;
}

static const fixed fix_two_pi = FLOAT_TO_FIXED(TWO_PI);

fixed fixed_sin(fixed angle) {
	int a;

	if(!initialized) precalc_lut();
	a = FIXED_INT_PART(fixed_div(angle, fix_two_pi) * 255) % 256;
	return a >= 0 ? sin_lut[a] : -sin_lut[-a];
}

fixed fixed_cos(fixed angle) {
	int a;

	if(!initialized) precalc_lut();
	a = FIXED_INT_PART(fixed_div(angle, fix_two_pi) * 255) % 256;
	return a >= 0 ? cos_lut[a] : cos_lut[-a];
}

#endif
