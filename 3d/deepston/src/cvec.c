#include <stdlib.h>
#include <string.h>
#include <stddef.h>
#include "cvec.h"

struct vector {
	int elem_sz;
	int size, used;
	char data[1];
};

#define HDRSZ		offsetof(struct vector, data)
#define VECTOR(p)	((struct vector*)((char*)(p) - HDRSZ))

void *cvec_alloc(int cnt, int esz)
{
	struct vector *vec;

	if(!(vec = malloc(HDRSZ + esz * cnt))) {
		return 0;
	}
	vec->elem_sz = esz;
	vec->size = cnt;
	vec->used = cnt;
	return vec->data;
}

void cvec_free(void *cvec)
{
	free(VECTOR(cvec));
}

void *cvec_resize(void *cvec, int newsz)
{
	struct vector *newvec, *vec = VECTOR(cvec);

	if(!(newvec = realloc(vec, newsz * vec->elem_sz + HDRSZ))) {
		return 0;
	}
	newvec->size = newvec->used = newsz;
	return newvec->data;
}

void *cvec_append(void *cvec, void *data)
{
	struct vector *vec = VECTOR(cvec);

	if(vec->used >= vec->size) {
		int used = vec->used;
		void *tmp;

		if(!(tmp = cvec_resize(cvec, vec->size ? vec->size * 2 : 1))) {
			return cvec;
		}
		cvec = tmp;
		vec = VECTOR(tmp);
		vec->used = used;
	}

	memcpy(vec->data + vec->used * vec->elem_sz, data, vec->elem_sz);
	vec->used++;
	return cvec;
}

int cvec_size(void *cvec)
{
	return VECTOR(cvec)->used;
}
