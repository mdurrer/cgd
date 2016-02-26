#ifndef MOUSE_H_
#define MOUSE_H_

#define MOUSE_LEFT		1
#define MOUSE_RIGHT		2
#define MOUSE_MIDDLE	4

int have_mouse(void);
void show_mouse(int show);
int read_mouse(int *xp, int *yp);
void set_mouse(int x, int y);
void set_mouse_limits(int xmin, int ymin, int xmax, int ymax);

#endif	/* MOUSE_H_ */
