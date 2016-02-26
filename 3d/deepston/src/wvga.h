#ifndef WVGA_H_
#define WVGA_H_


int set_video_mode(int mode);
void set_palette(int idx, int *col, int count);
void set_pal_entry(int idx, int r, int g, int b);
void copy_frame(void *pixels);

void wait_vsync(void);

#endif	/* WVGA_H_ */
