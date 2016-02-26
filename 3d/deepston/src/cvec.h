#ifndef CVEC_H_
#define CVEC_H_

#ifdef __cplusplus
extern "C" {
#endif

void *cvec_alloc(int cnt, int esz);
void cvec_free(void *cvec);

void *cvec_resize(void *cvec, int newsz);
void *cvec_append(void *cvec, void *data);

int cvec_size(void *cvec);

#ifdef __cplusplus
}
#endif

#endif	/* CVEC_H_ */
