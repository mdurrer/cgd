static void SCAN_EDGE(VERTEX *v0, VERTEX *v1)
{
	int i, start, end;
	fixed dx, dy, dfdx;
#ifdef INTERP_DEPTH
	fixed z, dz, dfdz;
#endif
#ifdef INTERP_ENERGY
	fixed e, de, dfde;
#endif
#ifdef INTERP_TEX
	fixed u, v, du, dv, dfdu, dfdv;
#endif
	fixed x;
	VERTEX *edge;

	dy = v1->pos.y - v0->pos.y;
	if(dy < FIXED_EPSILON && dy > -FIXED_EPSILON) {
		return;
	}

	dx = v1->pos.x - v0->pos.x;
	dfdx = fixed_div(dx, dy);

#ifdef INTERP_DEPTH
	dz = v1->pos.z - v0->pos.z;
	dfdz = fixed_div(dz, dy);
#endif
#ifdef INTERP_ENERGY
	de = v1->energy - v0->energy;
	dfde = fixed_div(de, dy);
#endif
#ifdef INTERP_TEX
	du = v1->tc.x - v0->tc.x;
	dv = v1->tc.y - v0->tc.y;
	dfdu = fixed_div(du, dy);
	dfdv = fixed_div(dv, dy);
#endif

	if(dy < 0) {
		VERTEX *tmp = v0;
		v0 = v1;
		v1 = tmp;
		edge = (st->ord == MGL_CCW) ? vright : vleft;
	} else {
		edge = (st->ord == MGL_CCW) ? vleft : vright;
	}

	start = (int)fixed_round(v0->pos.y);
	end = (int)fixed_round(v1->pos.y);

	if(start >= 0) {

		x = v0->pos.x;
#ifdef INTERP_DEPTH
		z = v0->pos.z;
#endif
#ifdef INTERP_ENERGY
		e = v0->energy;
#endif
#ifdef INTERP_TEX
		u = v0->tc.x;
		v = v0->tc.y;
#endif
	} else {
		fixed lines = -v0->pos.y;

		x = v0->pos.x + fixed_mul(dfdx, lines);
#ifdef INTERP_DEPTH
		z = v0->pos.z + fixed_mul(dfdz, lines);
#endif
#ifdef INTERP_ENERGY
		e = v0->energy + fixed_mul(dfde, lines);
#endif
#ifdef INTERP_TEX
		u = v0->tc.x + fixed_mul(dfdu, lines);
		v = v0->tc.y + fixed_mul(dfdv, lines);
#endif
		start = 0;
	}

	if(end >= fb->height) {
		end = fb->height - 1;
	}


	for(i=start; i<end; i++) {
		edge[i].pos.x = x;
		x += dfdx;

		edge[i].cidx = v0->cidx;
#ifdef INTERP_DEPTH
		edge[i].pos.z = z;
		z += dfdz;
#endif

#ifdef INTERP_ENERGY
		edge[i].energy = e;
		e += dfde;
#else
		edge[i].energy = v0->energy;
#endif

#ifdef INTERP_TEX
		edge[i].tc.x = u;
		edge[i].tc.y = v;
		u += dfdu;
		v += dfdv;
#endif
	}
}

static void SCAN_LINE(int y, unsigned char *sline)
{
	int x0, x1, len, tmp, cidx;
#if defined(INTERP_DEPTH) || defined(INTERP_ENERGY) || defined(INTERP_TEX)
	int i;
	fixed x, dx;
#endif
#ifdef INTERP_DEPTH
	fixed z, dz, dfdz;
#endif
#ifdef INTERP_ENERGY
	fixed e, de, dfde;
#endif
#ifdef INTERP_TEX
	unsigned int tx, ty;
	fixed u, v, du, dv, dfdu, dfdv;
#endif
	VERTEX *left, *right;

	x0 = (int)fixed_round(vleft[y].pos.x);
	x1 = (int)fixed_round(vright[y].pos.x);

	if(x1 < x0) {
		if(IS_ENABLED(st->flags, MGL_CULL_FACE)) {
			return;
		}
		tmp = x0;
		x0 = x1;
		x1 = tmp;

		left = vright;
		right = vleft;
	} else {
		left = vleft;
		right = vright;
	}

	if(x1 >= fb->width) {
		x1 = fb->width - 1;
	}

	cidx = left[y].cidx;
#if !defined(INTERP_DEPTH) && !defined(INTERP_ENERGY) && !defined(INTERP_TEX)
	if(x0 < 0) x0 = 0;
	len = x1 - x0;
	assert(len >= 0);
	/* no interpolation at all, just memset the whole scanline */
	memset(sline + x0, cidx + fixed_int(fixed_mul(left[y].energy, fixedi(st->col_range))), len);
#else
	/* otherwise do a loop and interpolate whatever needs interpolating */
	x = left[y].pos.x;
	dx = right[y].pos.x - x;

	if(dx < fixedf(0.5) && dx > -fixedf(0.5)) {
		return;
	}

	if(x0 >= 0) {
#ifdef INTERP_DEPTH
		z = left[y].pos.z;
		dz = right[y].pos.z - z;
		dfdz = fixed_div(dz, dx);
#endif
#ifdef INTERP_ENERGY
		e = left[y].energy;
		de = right[y].energy - e;
		dfde = fixed_div(de, dx);
#endif
#ifdef INTERP_TEX
		u = left[y].tc.x;
		v = left[y].tc.y;
		du = right[y].tc.x - u;
		dv = right[y].tc.y - v;
		dfdu = fixed_div(du, dx);
		dfdv = fixed_div(dv, dx);
#endif
	} else {
		fixed dist = -left[y].pos.x;

#ifdef INTERP_DEPTH
		dz = right[y].pos.z - left[y].pos.z;
		dfdz = fixed_div(dz, dx);
		z = left[y].pos.z + fixed_mul(dfdz, dist);
#endif
#ifdef INTERP_ENERGY
		de = right[y].energy - left[y].energy;
		dfde = fixed_div(de, dx);
		e = left[y].energy + fixed_mul(dfde, dist);
#endif
#ifdef INTERP_TEX
		du = right[y].tc.x - left[y].tc.x;
		dv = right[y].tc.y - left[y].tc.y;
		dfdu = fixed_div(du, dx);
		dfdv = fixed_div(dv, dx);
		u = left[y].tc.x + fixed_mul(dfdu, dist);
		v = left[y].tc.y + fixed_mul(dfdv, dist);
#endif
		x0 = 0;
	}

	len = x1 - x0;

	for(i=0; i<len; i++) {
		int c = cidx;

#ifdef INTERP_DEPTH
		long pix = (sline + x0 + i) - fb->pixels;
#ifdef RAST_FLOAT
		unsigned short zval = (unsigned short)(z * USHRT_MAX);
#else
		unsigned short zval = (unsigned short)((z >> 1) & 0xffff);
#endif
		unsigned short *zptr = fb->zbuf[ZTILE(pix)] + ZTILE_OFFS(pix);

		if(z < 0 || z >= fixedi(1) || zval > *zptr) {
# ifdef INTERP_TEX
			u += dfdu;
			v += dfdv;
# endif
# ifdef INTERP_ENERGY
			e += dfde;
# endif
			z += dfdz;
			continue;
		}

		*zptr = zval;
		z += dfdz;
#endif
#ifdef INTERP_TEX
		tx = (unsigned int)fixed_int(fixed_mul(u, fixedi(st->tex.width))) & st->tex.xmask;
		ty = (unsigned int)fixed_int(fixed_mul(v, fixedi(st->tex.height))) & st->tex.ymask;
		c = st->tex.pixels[(ty << st->tex.xshift) + tx];

		u += dfdu;
		v += dfdv;
#endif
#ifdef INTERP_ENERGY
		c += fixed_int(fixed_mul(e, fixedi(st->col_range)));
		e += dfde;
#else
		c += fixed_int(fixed_mul(left[y].energy, fixedi(st->col_range)));
#endif
		sline[x0 + i] = c;
	}
#endif	/* flat */
}
