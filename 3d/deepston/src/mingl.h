#ifndef MINGL_H_
#define MINGL_H_

/* enable bitflags */
#define MGL_CULL_FACE	0
#define MGL_DEPTH_TEST	1
#define MGL_SMOOTH		2
#define MGL_LIGHTING	3
#define MGL_TEXTURE_2D	4
#define MGL_CLIP_PLANE0	5
#define MGL_CLIP_PLANE1	6
#define MGL_CLIP_PLANE2	7
#define MGL_CLIP_PLANE3 8
#define MGL_CLIP_PLANE4	9
#define MGL_CLIP_PLANE5	10

/* primitives */
#define MGL_POINTS		1
#define MGL_LINES		2
#define MGL_TRIANGLES	3
#define MGL_QUADS		4

/* matrices */
#define MGL_MODELVIEW	0
#define MGL_PROJECTION	1
#define MGL_TEXTURE		2

#define MGL_FRONT		0
#define MGL_BACK		1

#define MGL_CCW			0
#define MGL_CW			1

int mgl_init(int width, int height);
void mgl_free(void);

unsigned char *mgl_framebuffer(void);

void mgl_clear(int cidx);
void mgl_clear_depth(void);

void mgl_enable(unsigned int bit);
void mgl_disable(unsigned int bit);
int mgl_isenabled(unsigned int bit);

void mgl_front_face(int ff);
void mgl_cull_face(int cf);

void mgl_set_ambient(float amb);
float mgl_get_ambient(void);

void mgl_color_range(int rng);
void mgl_light_intensity(int ltidx, float intens);
void mgl_light_position(int ltidx, float x, float y, float z, float w);

void mgl_begin(int prim);
void mgl_end(void);

void mgl_vertex2f(float x, float y);
void mgl_vertex3f(float x, float y, float z);
void mgl_vertex4f(float x, float y, float z, float w);
void mgl_color1f(float energy);
void mgl_index(int cidx);
void mgl_normal(float x, float y, float z);
void mgl_texcoord2f(float x, float y);

void mgl_viewport(int x, int y, int width, int height);

void mgl_matrix_mode(int mmode);
void mgl_push_matrix(void);
void mgl_pop_matrix(void);
void mgl_load_matrix(float *mat);
void mgl_mult_matrix(float *mat);
void mgl_load_identity(void);

void mgl_translate(float x, float y, float z);
void mgl_rotate(float angle, float x, float y, float z);
void mgl_scale(float x, float y, float z);

void mgl_ortho(float left, float right, float bottom, float top, float nr, float fr);
void mgl_frustum(float left, float right, float bottom, float top, float nr, float fr);
void mgl_perspective(float vfov, float aspect, float nr, float fr);

void mgl_teximage(int width, int height, unsigned char *pixels);

void mgl_clip_plane(int id, float nx, float ny, float nz, float dist);

void mgl_cube(float sz);
void mgl_sphere(float rad, int usub, int vsub);
void mgl_sphere_part(float rad, int usub, int vsub, float umax, float vmax);
void mgl_torus(float inner, float outer, int usub, int vsub);
void mgl_torus_part(float inner, float outer, int usub, int vsub, float umax, float vmin, float vmax);

#endif	/* MINGL_H_ */
