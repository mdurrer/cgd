#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <errno.h>
#include <assert.h>
#include "scene.h"
#include "cvec.h"
#include "palman.h"

#ifdef USE_GL
#include <GL/gl.h>
#else
#include "mingl.h"
#endif


struct face {
	int v[3], n[3], t[3];
};

static int load_materials(struct scene *scn, const char *fname);
static int parse_face(struct face *face, char *buf);


/* --- scene --- */
int scn_init(struct scene *scn)
{
	memset(scn, 0, sizeof *scn);
	return 0;
}

void scn_destroy(struct scene *scn)
{
	while(scn->matlist) {
		struct material *tmp = scn->matlist;
		scn->matlist = scn->matlist->next;

		mtl_destroy(tmp);
		free(tmp);
	}
	while(scn->meshlist) {
		struct mesh *tmp = scn->meshlist;
		scn->meshlist = scn->meshlist->next;

		mesh_destroy(tmp);
		free(tmp);
	}
}


void scn_add_mesh(struct scene *scn, struct mesh *m)
{
	printf("adding mesh: %d faces\n", m->nface);
	m->next = scn->meshlist;
	scn->meshlist = m;
}

void scn_add_material(struct scene *scn, struct material *m)
{
	printf("adding material: %s\n", m->name);
	m->next = scn->matlist;
	scn->matlist = m;
}

struct material *scn_find_material(struct scene *scn, const char *name)
{
	struct material *mtl = scn->matlist;

	while(mtl) {
		if(strcmp(mtl->name, name) == 0) {
			break;
		}
		mtl = mtl->next;
	}
	return mtl;
}

#define SEP	" \t\n\r"
int scn_load(struct scene *scn, const char *fname)
{
	FILE *fp;
	char buf[256];
	struct mesh *m;
	vec3_t *varr, *vnarr;
	vec2_t *vtarr;

	if(!(fp = fopen(fname, "rb"))) {
		fprintf(stderr, "failed to open scene file: %s: %s\n", fname, strerror(errno));
		return -1;
	}

	varr = cvec_alloc(0, sizeof *varr);
	vnarr = cvec_alloc(0, sizeof *vnarr);
	vtarr = cvec_alloc(0, sizeof *vtarr);

	if(!(m = malloc(sizeof *m)) || mesh_init(m) == -1) {
		fprintf(stderr, "meshed up\n");
		fclose(fp);
		return -1;
	}

	while(fgets(buf, sizeof buf, fp)) {
		char *line = buf;
		char *tok, *rest, *tmp;

		while(*line && isspace(*line)) {
			line++;
		}
		if(*line == 0 || *line == '#') {
			continue;
		}

		if(!(tok = strtok(line, SEP))) {
			continue;
		}
		rest = tok + strlen(tok) + 1;

		if((tmp = strchr(rest, '\r')) || (tmp = strchr(rest, '\n'))) {
			*tmp = 0;
		}

		if(strcmp(tok, "mtllib") == 0) {
			if(!rest) {
				fprintf(stderr, "invalid mtllib directive\n");
				continue;
			}
			load_materials(scn, rest);

		} else if(strcmp(tok, "usemtl") == 0) {
			if(rest) {
				m->mtl = scn_find_material(scn, rest);
			}

		} else if(strcmp(tok, "o") == 0 || strcmp(tok, "g") == 0) {
			if(cvec_size(m->vert) > 0) {
				scn_add_mesh(scn, m);

				if(!(m = malloc(sizeof *m)) || mesh_init(m) == -1) {
					fprintf(stderr, "meshed up\n");
					fclose(fp);
					return -1;
				}
			}

		} else if(strcmp(tok, "v") == 0) {
			vec3_t v;

			if(!rest || sscanf(rest, "%f %f %f\n", &v.x, &v.y, &v.z) != 3) {
				continue;
			}
			varr = cvec_append(varr, &v);

		} else if(strcmp(tok, "vn") == 0) {
			vec3_t v;

			if(!rest || sscanf(rest, "%f %f %f\n", &v.x, &v.y, &v.z) != 3) {
				continue;
			}
			vnarr = cvec_append(vnarr, &v);

		} else if(strcmp(tok, "vt") == 0) {
			vec2_t v;

			if(!rest || sscanf(rest, "%f %f\n", &v.x, &v.y) != 2) {
				continue;
			}
			v.y = 1.0 - v.y;
			vtarr = cvec_append(vtarr, &v);

		} else if(strcmp(tok, "f") == 0) {
			int i;
			struct face face;

			if(!rest || parse_face(&face, rest) == -1) {
				continue;
			}

			for(i=0; i<3; i++) {
				int vidx = face.v[i];
				int nidx = face.n[i];
				int tidx = face.t[i];

				mesh_add_vertex(m, varr[vidx]);
				if(nidx >= 0) {
					mesh_add_normal(m, vnarr[nidx]);
				}
				if(tidx >= 0) {
					mesh_add_texcoord(m, vtarr[tidx]);
				}
				m->nface++;
			}
		}

	}
	fclose(fp);

	if(cvec_size(m->vert) > 0) {
		scn_add_mesh(scn, m);
	}

	cvec_free(varr);
	cvec_free(vnarr);
	cvec_free(vtarr);

	return 0;
}

static int load_materials(struct scene *scn, const char *fname)
{
	FILE *fp;
	struct material *m = 0;
	char buf[256];

	if(!(fp = fopen(fname, "r"))) {
		fprintf(stderr, "failed to load material file: %s: %s\n", fname, strerror(errno));
		return -1;
	}

	while(fgets(buf, sizeof buf, fp)) {
		char *line = buf;
		char *tok, *rest, *tmp;

		while(*line && isspace(*line)) {
			line++;
		}
		if(*line == 0 || *line == '#') {
			continue;
		}

		if(!(tok = strtok(line, SEP))) {
			continue;
		}
		rest = tok + strlen(tok) + 1;

		if((tmp = strchr(rest, '\r')) || (tmp = strchr(rest, '\n'))) {
			*tmp = 0;
		}

		if(strcmp(tok, "newmtl") == 0) {
			if(m) {
				if(!m->tex) {
					palm_add_color(m->kd[0], m->kd[1], m->kd[2]);
				}
				scn_add_material(scn, m);
			}
			if(!(m = malloc(sizeof *m)) || mtl_init(m) == -1) {
				continue;
			}
			mtl_set_name(m, rest);

		} else if(strcmp(tok, "Kd") == 0) {
			float r, g, b;
			if(sscanf(rest, "%f %f %f", &r, &g, &b) != 3) {
				continue;
			}
			m->kd[0] = (int)(r * 255.0);
			m->kd[1] = (int)(g * 255.0);
			m->kd[2] = (int)(b * 255.0);

		} else if(strcmp(tok, "map_Kd") == 0) {
			if(!(m->tex = load_texture(rest))) {
				fprintf(stderr, "failed to load texture: `%s'\n", rest);
			}
		}
	}

	if(m) {
		if(!m->tex) {
			palm_add_color(m->kd[0], m->kd[1], m->kd[2]);
		}
		scn_add_material(scn, m);
	}

	fclose(fp);
	return 0;
}

static int parse_face(struct face *face, char *buf)
{
	int i, found;
	char *tok;

	for(i=0; i<3; i++) {
		tok = strtok(i > 0 ? 0 : buf, SEP);
		found = sscanf(tok, "%d/%d/%d", &face->v[i], &face->t[i], &face->n[i]);

		face->v[i]--;

		if(found > 1) {
			face->t[i]--;
		} else {
			face->t[i] = -1;
		}
		if(found > 2) {
			face->n[i]--;
		} else {
			face->n[i] = -1;
		}
	}
	return 0;
}

void scn_render(struct scene *scn)
{
	struct mesh *m;

	if(!scn->ready) {
		struct material *mtl = scn->matlist;
		while(mtl) {
			if(mtl->tex) {
				get_texture_pixels(mtl->tex);
#ifdef USE_GL
				{
					int i, npix = mtl->tex->width * mtl->tex->height;
					int range = palm_color_range();
					unsigned char *rgb = malloc(npix * 3);
					struct palm_color *pal = palm_palette();

					for(i=0; i<npix; i++) {
						int idx = mtl->tex->pixels[i] + range - 1;
						rgb[i * 3] = pal[idx].r;
						rgb[i * 3 + 1] = pal[idx].g;
						rgb[i * 3 + 2] = pal[idx].b;
					}
					free(mtl->tex->pixels);
					mtl->tex->pixels = rgb;
				}
#endif	/* USE_GL */
			} else {
				mtl->kd_base = palm_color_base(mtl->kd[0], mtl->kd[1], mtl->kd[2]);
			}
			mtl = mtl->next;
		}
		scn->ready = 1;
	}

	m = scn->meshlist;
	while(m) {
		mesh_draw(m);
		m = m->next;
	}

#if 0
	{
		int i;
		struct palm_color *pal = palm_palette();
		float dx = 1.8 / 256;
		struct material *mtl = scn->matlist;

		glMatrixMode(GL_MODELVIEW);
		glPushMatrix();
		glLoadIdentity();
		glMatrixMode(GL_PROJECTION);
		glPushMatrix();
		glLoadIdentity();

		glPushAttrib(GL_ENABLE_BIT);
		glDisable(GL_LIGHTING);
		glDisable(GL_DEPTH_TEST);

		glBegin(GL_QUADS);
		for(i=0; i<255; i++) {
			float x = i * dx - 0.9;
			glColor3ub(pal[i].r, pal[i].g, pal[i].b);
			glVertex2f(x, 0.98);
			glVertex2f(x, 0.9);
			glColor3ub(pal[i + 1].r, pal[i + 1].g, pal[i + 1].b);
			glVertex2f(x + dx, 0.9);
			glVertex2f(x + dx, 0.98);
		}
		glEnd();

		glPopAttrib();

		glMatrixMode(GL_PROJECTION);
		glPopMatrix();
		glMatrixMode(GL_MODELVIEW);
		glPopMatrix();
	}
#endif
}

/* --- material --- */
int mtl_init(struct material *mtl)
{
	memset(mtl, 0, sizeof *mtl);
	return 0;
}

void mtl_destroy(struct material *mtl)
{
	free(mtl->name);

	if(mtl->tex) {
		free_texture(mtl->tex);
	}
}


int mtl_set_name(struct material *mtl, const char *name)
{
	char *tmp;
	int len = strlen(name);

	if(!(tmp = malloc(len + 1))) {
		perror("failed to allocate material name");
		return -1;
	}
	memcpy(tmp, name, len);
	tmp[len] = 0;

	free(mtl->name);
	mtl->name = tmp;
	return 0;
}


/* --- mesh --- */
int mesh_init(struct mesh *m)
{
	memset(m, 0, sizeof *m);

	m->vert = cvec_alloc(0, sizeof *m->vert);
	m->norm = cvec_alloc(0, sizeof *m->norm);
	m->texcoord = cvec_alloc(0, sizeof *m->texcoord);

	if(!m->vert || !m->norm || !m->texcoord) {
		return -1;
	}
	return 0;
}

void mesh_destroy(struct mesh *m)
{
	cvec_free(m->vert);
	cvec_free(m->norm);
	cvec_free(m->texcoord);
}

void mesh_add_vertex(struct mesh *m, vec3_t v)
{
	m->vert = cvec_append(m->vert, &v);
}

void mesh_add_normal(struct mesh *m, vec3_t n)
{
	m->norm = cvec_append(m->norm, &n);
}

void mesh_add_texcoord(struct mesh *m, vec2_t tc)
{
	m->texcoord = cvec_append(m->texcoord, &tc);
}

void mesh_draw(struct mesh *m)
{
	int i, numv;
	struct material *mtl = m->mtl;

	numv = cvec_size(m->vert);

#ifdef USE_GL
	if(mtl->tex) {
		assert(mtl->tex->pixels);
		glEnable(GL_TEXTURE_2D);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);

		glTexImage2D(GL_TEXTURE_2D, 0, 3, mtl->tex->width, mtl->tex->height, 0, GL_RGB, GL_UNSIGNED_BYTE, mtl->tex->pixels);
	}

	glBegin(GL_TRIANGLES);
	for(i=0; i<numv; i++) {
		glNormal3f(m->norm[i].x, m->norm[i].y, m->norm[i].z);
		glTexCoord2f(m->texcoord[i].x, m->texcoord[i].y);
		glVertex3f(m->vert[i].x, m->vert[i].y, m->vert[i].z);
	}
	glEnd();

	if(mtl->tex) {
		glDisable(GL_TEXTURE_2D);
	}
#else
	if(mtl->tex) {
		mgl_enable(MGL_TEXTURE_2D);
		mgl_teximage(mtl->tex->width, mtl->tex->height, mtl->tex->pixels);
	} else {
		mgl_index(mtl->kd_base);
	}

	mgl_begin(MGL_TRIANGLES);

	for(i=0; i<numv; i++) {
		mgl_normal(m->norm[i].x, m->norm[i].y, m->norm[i].z);
		mgl_texcoord2f(m->texcoord[i].x, m->texcoord[i].y);
		mgl_vertex3f(m->vert[i].x, m->vert[i].y, m->vert[i].z);
	}
	mgl_end();

	if(mtl->tex) {
		mgl_disable(MGL_TEXTURE_2D);
	}
#endif
}
