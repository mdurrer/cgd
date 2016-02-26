#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <signal.h>
#include <conio.h>
#include "wvga.h"
#include "mingl.h"
#include "timer.h"
#include "keyb.h"
#include "mouse.h"
#include "texture.h"
#include "palman.h"
#include "scene.h"

#define DEG2RAD(x)	(M_PI * (x) / 180.0)

static int init(void);
static void shutdown(void);
static void update(unsigned long dtmsec);
static void redraw(void);
static int proc_events(void);
static void mouse_button(int bn, int x, int y);
static void mouse_motion(int x, int y);
static void sighandler(int s);


static float cam_x, cam_y, cam_z;
static float cam_theta, cam_phi;

static float walk_speed = 6.0;
static float look_speed = 1.0;

static int mouse_look = 1;

static void *fbuf;
static struct scene scn;


int main(void)
{
	unsigned long prev_msec = 0;

	if(init() == -1) {
		return 1;
	}

	for(;;) {
		unsigned long msec = get_msec();
		unsigned long dt = msec - prev_msec;
		prev_msec = msec;

		if(!proc_events()) {
			break;
		}

		update(dt);
		redraw();
	}

	shutdown();
	return 0;
}


static int init(void)
{
	float vfov, aspect;

	aspect = 320.0 / 200.0;
	vfov = 60.0;

	init_timer(100);
	kb_init(16); /* 16 characters input buffer */

	set_video_mode(0x13);

	signal(SIGINT, sighandler);
	signal(SIGSEGV, sighandler);
	signal(SIGFPE, sighandler);
	signal(SIGILL, sighandler);
	signal(SIGABRT, sighandler);

	if(mgl_init(320, 200) == -1) {
		fprintf(stderr, "mgl init failed\n");
		return -1;
	}
	fbuf = mgl_framebuffer();

	mgl_enable(MGL_CULL_FACE);
	mgl_enable(MGL_SMOOTH);
	mgl_enable(MGL_LIGHTING);
	mgl_enable(MGL_DEPTH_TEST);

	mgl_matrix_mode(MGL_PROJECTION);
	mgl_load_identity();
	mgl_perspective(vfov, aspect, 0.5, 200.0);

#if 0
	mgl_enable(MGL_CLIP_PLANE0);
	mgl_enable(MGL_CLIP_PLANE1);
	mgl_enable(MGL_CLIP_PLANE2);
	mgl_enable(MGL_CLIP_PLANE3);
	mgl_clip_plane(MGL_CLIP_PLANE0, -1, 0, -1, 0);	/* positive X */
	mgl_clip_plane(MGL_CLIP_PLANE1, 1, 0, -1, 0);	/* negative X */
	mgl_clip_plane(MGL_CLIP_PLANE2, 0, -1, -0.5, 0);	/* positive Y */
	mgl_clip_plane(MGL_CLIP_PLANE3, 0, 1, -0.5, 0);	/* negative Y */
#endif

	/* setup palette */
	palm_add_color(255, 255, 255);

	scn_init(&scn);
	if(scn_load(&scn, "data/hall.obj") == -1) {
		return -1;
	}

	palm_build();
	{
		int i, palsz = palm_palette_size();
		struct palm_color *pal = palm_palette();

		for(i=0; i<palsz; i++) {
			set_pal_entry(i, pal[i].r, pal[i].g, pal[i].b);
		}
	}

	mgl_color_range(palm_color_range() - 1);
	return 0;
}

static void shutdown(void)
{
	mgl_free();
	set_video_mode(3);
	kb_shutdown();
}


#define DEG_TO_RAD(x)	(M_PI * (x) / 180.0)
void cam_move(float dx, float dy)
{
	float angle = DEG_TO_RAD(cam_theta);
	cam_x += cos(angle) * dx + sin(angle) * dy;
	cam_z -= -sin(angle) * dx + cos(angle) * dy;
}

static void update(unsigned long dtmsec)
{
	float dt = (float)dtmsec / 1000.0f;
	float offs = walk_speed * dt;

	if(kb_isdown('w') || kb_isdown('W'))
		cam_move(0, offs);

	if(kb_isdown('s') || kb_isdown('S'))
		cam_move(0, -offs);

	if(kb_isdown('a') || kb_isdown('A'))
		cam_move(-offs, 0);

	if(kb_isdown('d') || kb_isdown('D'))
		cam_move(offs, 0);
}

static void redraw(void)
{
	mgl_clear(0);
	mgl_clear_depth();

	mgl_matrix_mode(MGL_MODELVIEW);
	mgl_load_identity();
	mgl_rotate(cam_phi, 1, 0, 0);
	mgl_rotate(cam_theta, 0, 1, 0);
	mgl_translate(-cam_x, -cam_y, -cam_z);
	mgl_translate(0, -2.0, 0);

	mgl_light_intensity(0, 1.0);
	mgl_light_position(0, 0, 5, 0, 1);

	/*mgl_torus(0.75, 0.25, 16, 8);*/
	scn_render(&scn);

	copy_frame(fbuf);
}

static int proc_events(void)
{
	static int prev_mx, prev_my, prev_bnmask;
	int mx, my, bnmask;

	int key;
	while((key = kb_getkey()) != -1) {
		switch(key) {
		case 27:
			return 0;

		case '`':
			mouse_look = !mouse_look;
			break;

		default:
			break;
		}
	}

	bnmask = read_mouse(&mx, &my);
	if(bnmask != prev_bnmask) {
		mouse_button(bnmask, mx, my);
		prev_bnmask = bnmask;
	}
	if(mx != prev_mx || my != prev_my) {
		mouse_motion(mx, my);
		prev_mx = mx;
		prev_my = my;
	}
	return 1;
}

static int bnstate;
static void mouse_button(int bn, int x, int y)
{
	bnstate = bn;
}

static void mouse_motion(int x, int y)
{
	static int prev_x = -1, prev_y;
	int dx = x - prev_x;
	int dy = y - prev_y;

	if(mouse_look) {
		if(prev_x == -1) {
			dx = dy = 0;
		}

		set_mouse(160, 100);
		prev_x = 160;
		prev_y = 100;
	} else {
		prev_x = x;
		prev_y = y;
	}

	if(mouse_look || bnstate) {
		cam_theta += dx * look_speed;
		cam_phi += dy * look_speed;

		if(cam_phi < -90) {
			cam_phi = -90;
		}
		if(cam_phi > 90) {
			cam_phi = 90;
		}
	}
}

static void sighandler(int s)
{
	set_video_mode(3);

	switch(s) {
	case SIGABRT:
		fprintf(stderr, "abort\n");
		break;

	case SIGILL:
		fprintf(stderr, "illegal operation\n");
		break;

	case SIGSEGV:
		fprintf(stderr, "segmentation fault\n");
		break;

	case SIGINT:
		fprintf(stderr, "interrupted\n");
		break;

	case SIGFPE:
		fprintf(stderr, "floating point exception\n");
		break;

	default:
		fprintf(stderr, "unexpected signal\n");
	}

	exit(1);
}
