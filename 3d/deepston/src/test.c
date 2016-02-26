#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <signal.h>
#include <conio.h>
#include "wvga.h"
#include "mingl.h"
#include "timer.h"
#include "mouse.h"
#include "palman.h"
#include "texture.h"

static int init(void);
static void shutdown(void);
static void redraw(void);
static void draw_cursor(unsigned char *fb, int xsz, int ysz, int mx, int my, int cidx);
static int keyb(char key);
static void mouse_button(int bn, int x, int y);
static void mouse_motion(int x, int y);
static void sighandler(int s);
static int parse_args(int argc, char **argv);
static void print_perf(void);

static unsigned char *fbuf;

static struct texture *tex;
static char *texfile;

static int white_base, red_base, green_base, blue_base;
static int grad_range;

static int use_vsync = 1;
static int under_windows = 0;
static unsigned long num_frm;

enum { CUBE, SPHERE, TORUS, NUM_PRIMS };
static int prim = SPHERE;
static int auto_rotate = 1;
static float cam_theta, cam_phi, cam_zoom = 4.0;

static int mx, my;

int main(int argc, char **argv)
{
	int mbn, prev_mx = -1, prev_my = -1, prev_mbn = 0;

	if(parse_args(argc, argv) == -1) {
		return 1;
	}

	if(init() == -1) {
		return 1;
	}

	reset_timer();

	for(;;) {
        if(kbhit()) {
			if(keyb(getch()) == 0) {
				break;
            }
        }

		mbn = read_mouse(&mx, &my);
		if(mbn != prev_mbn) {
			mouse_button(mbn, mx, my);
			prev_mbn = mbn;
		}
		if(mx != prev_mx || my != prev_my) {
			if(mbn) {
				mouse_motion(mx, my);
			}
			prev_mx = mx;
			prev_my = my;
		}

		redraw();
	}

	shutdown();
	print_perf();
	return 0;
}

static int init(void)
{
	int i;
	struct palm_color *pal;

	init_timer(under_windows ? 0 : 100);

	set_video_mode(0x13);

	signal(SIGINT, sighandler);
	signal(SIGSEGV, sighandler);
	signal(SIGFPE, sighandler);
	signal(SIGILL, sighandler);
	signal(SIGABRT, sighandler);

	have_mouse();


	if(mgl_init(320, 200) == -1) {
		fprintf(stderr, "mgl init failed\n");
		return -1;
	}
	fbuf = mgl_framebuffer();


	if(!texfile) {
		palm_add_color(255, 255, 255);
		palm_add_color(255, 0, 0);
		palm_add_color(0, 255, 0);
		palm_add_color(0, 0, 255);
		palm_build();

		white_base = palm_color_base(255, 255, 255);
		red_base = palm_color_base(255, 0, 0);
		green_base = palm_color_base(0, 255, 0);
		blue_base = palm_color_base(0, 0, 255);

		tex = tex_gen_checker(64, 64, 3, 3, red_base, blue_base);
	} else {
		if(!(tex = load_texture(texfile))) {
			return -1;
		}

		palm_build();
		get_texture_pixels(tex);

		mgl_enable(MGL_TEXTURE_2D);
	}

	grad_range = palm_color_range();

	pal = palm_palette();
	for(i=0; i<palm_palette_size(); i++) {
		set_pal_entry(i, pal[i].r, pal[i].g, pal[i].b);
	}

	mgl_enable(MGL_CULL_FACE);
	mgl_enable(MGL_DEPTH_TEST);
	mgl_enable(MGL_SMOOTH);
	mgl_color_range(grad_range - 1);	/* gradient range */

	mgl_enable(MGL_LIGHTING);
	mgl_light_intensity(0, 1.0);
	mgl_light_position(0, -0.5, 0.5, 1, 0);

	mgl_matrix_mode(MGL_PROJECTION);
	mgl_load_identity();
	mgl_perspective(45.0, 320.0 / 200.0, 0.5, 100.0);

	mgl_teximage(tex->width, tex->height, tex->pixels);

    return 0;
}

static void shutdown(void)
{
	mgl_free();
    set_video_mode(3);
}

static void redraw(void)
{
	float angle = get_msec() / 10.0;
	mgl_clear(0);
	mgl_clear_depth();

	mgl_matrix_mode(MGL_MODELVIEW);
	mgl_load_identity();
	mgl_translate(0, 0, -cam_zoom);
	if(auto_rotate) {
		mgl_rotate(angle * 0.5, 1, 0, 0);
		mgl_rotate(angle, 0, 0, 1);
	} else {
		mgl_rotate(cam_phi, 1, 0, 0);
		mgl_rotate(cam_theta, 0, 1, 0);
	}

	switch(prim) {
	case TORUS:
		mgl_index(green_base);
		mgl_torus(1.0, 0.25, 16, 8);
		break;
	case SPHERE:
		mgl_index(blue_base);
		mgl_sphere(1.0, 16, 8);
		break;
	case CUBE:
		mgl_index(red_base);
		mgl_cube(1.0);
	}

	if(!auto_rotate) {
		draw_cursor(fbuf, 320, 200, mx, my, white_base + grad_range - 1);
	}

    copy_frame(fbuf);
	if(use_vsync) {
		wait_vsync();
	}
	num_frm++;
}

static void draw_cursor(unsigned char *fb, int xsz, int ysz, int mx, int my, int cidx)
{
	static char img[] =
		"oo........"
		"oxo......."
		"oxxo......"
		"oxxxo....."
		"oxxxxo...."
		"oxxxxxo..."
		"oxxxxxxo.."
		"oxxxxxxxo."
		"oxxxxxxxxo"
		"oxxxxxoooo"
		"oxxoxxo..."
		"oxo.oxxo.."
		"oo..oxxo.."
		".....oxxo."
		".....oxxo."
		"......oo..";
	int i, j, w = 10, h = 16;

	if(mx < 0 || my < 0) {
		return;
	}
	if(mx + w >= xsz) {
		w = xsz - mx;
	}
	if(my + h >= ysz) {
		h = ysz - my;
	}

	fb += my * xsz + mx;
	for(i=0; i<h; i++) {
		for(j=0; j<w; j++) {
			char c = img[(i << 3) + (i << 1) + j];
			if(c != '.') {
				fb[j] = c == 'x' ? 0 : cidx;
			}
		}
		fb += xsz;
	}
}

static int keyb(char key)
{
	switch(key) {
	case 'q':
	case 27:
		return 0;

	case 's':
		if(mgl_isenabled(MGL_SMOOTH)) {
			mgl_disable(MGL_SMOOTH);
		} else {
			mgl_enable(MGL_SMOOTH);
		}
		break;

	case 't':
		if(mgl_isenabled(MGL_TEXTURE_2D)) {
			mgl_disable(MGL_TEXTURE_2D);
		} else {
			mgl_enable(MGL_TEXTURE_2D);
		}
		break;

	case 'z':
		if(mgl_isenabled(MGL_DEPTH_TEST)) {
			mgl_disable(MGL_DEPTH_TEST);
		} else {
			mgl_enable(MGL_DEPTH_TEST);
		}
		break;

	case ' ':
		auto_rotate = !auto_rotate;
		break;

	case 'p':
		prim = (prim + 1) % NUM_PRIMS;
		break;

	case 'c':
		if(mgl_isenabled(MGL_CULL_FACE)) {
			mgl_disable(MGL_CULL_FACE);
		} else {
			mgl_enable(MGL_CULL_FACE);
		}
		break;

	default:
		break;
	}
	return 1;
}

static int bnstate;
static int prev_x, prev_y;

static void mouse_button(int bn, int x, int y)
{
	bnstate = bn;
	prev_x = x;
	prev_y = y;
}

static void mouse_motion(int x, int y)
{
	int dx, dy;

	dx = x - prev_x;
	dy = y - prev_y;
	prev_x = x;
	prev_y = y;

	if(bnstate & MOUSE_LEFT) {
		cam_theta += dx;
		cam_phi += dy;

		if(cam_phi > 90) cam_phi = 90;
		if(cam_phi < -90) cam_phi = -90;
	}
	if(bnstate & MOUSE_RIGHT) {
		cam_zoom += dy * 0.1;
		if(cam_zoom < 0.0) {
			cam_zoom = 0.0;
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

static int parse_args(int argc, char **argv)
{
	int i;

	for(i=1; i<argc; i++) {
		if(argv[i][0] == '-') {
			if(argv[i][2] != 0) {
				goto invalid;
			}
			switch(argv[i][1]) {
			case 'a':
				auto_rotate = !auto_rotate;
				break;

			case 't':
				texfile = argv[++i];
				break;

			case 'v':
				use_vsync = !use_vsync;
				break;

			case 'p':
				if(strcmp(argv[++i], "cube") == 0) {
					prim = CUBE;
				} else if(strcmp(argv[i], "sphere") == 0) {
					prim = SPHERE;
				} else if(strcmp(argv[i], "torus") == 0) {
					prim = TORUS;
				} else {
					goto invalid;
				}
				break;

			case 'w':
				under_windows = 1;
				break;

			case 'h':
				printf("Usage %s [options]\n", argv[0]);
				printf("options:\n");
				printf(" -p  select one of (cube|sphere|torus)\n");
				printf(" -v  use vsync\n");
				printf(" -w  run under windows\n");
				printf(" -h  print usage information and exit\n");
				exit(0);

			default:
				goto invalid;
			}
		} else {
			goto invalid;
		}
	}

	return 0;

invalid:
	fprintf(stderr, "invalid argument: %s\n", argv[i]);
	return -1;
}


static void print_perf(void)
{
	unsigned long msec, avg_frame_time;
	float sec, fps;

	msec = get_msec();
	if(!num_frm || msec < 1000) {
		printf("leaving so soon? (%lu ms)\n", msec);
		return;
	}

	sec = msec / 1000.0f;
	fps = (float)num_frm / sec;
	avg_frame_time = msec / num_frm;

	printf("%lu frames in %.2f seconds\n", num_frm, sec);
	printf("  avg. frame time: %lu ms\n", avg_frame_time);
	printf("  avg. framerate: %.2f fps\n", fps);
}
