#ifndef SCENE_H_
#define SCENE_H_

#include "vmath.h"
#include "texture.h"


struct material {
	char *name;
	int kd[3];
	int kd_base;
	struct texture *tex;

	struct material *next;
};

struct mesh {
	int nface;
	vec3_t *vert;
	vec3_t *norm;
	vec2_t *texcoord;
	struct material *mtl;

	struct mesh *next;
};

struct scene {
	int ready;
	struct material *matlist;
	struct mesh *meshlist;
};

#ifdef __cplusplus
extern "C" {
#endif

/* --- scene --- */
int scn_init(struct scene *scn);
void scn_destroy(struct scene *scn);

void scn_add_mesh(struct scene *scn, struct mesh *m);
void scn_add_material(struct scene *scn, struct material *m);

struct material *scn_find_material(struct scene *scn, const char *name);

int scn_load(struct scene *scn, const char *fname);

void scn_render(struct scene *scn);

/* --- material --- */
int mtl_init(struct material *mtl);
void mtl_destroy(struct material *mtl);

int mtl_set_name(struct material *mtl, const char *name);

/* --- mesh --- */
int mesh_init(struct mesh *m);
void mesh_destroy(struct mesh *m);

void mesh_add_vertex(struct mesh *m, vec3_t v);
void mesh_add_normal(struct mesh *m, vec3_t n);
void mesh_add_texcoord(struct mesh *m, vec2_t tc);

void mesh_draw(struct mesh *m);

#ifdef __cplusplus
}
#endif

#endif	/* SCENE_H_ */
