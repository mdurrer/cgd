// common.h
#ifndef COMMON_H
#define COMMON_H
#include "stdtypes.h"
#define BIG_END 1
typedef union 
{
	UINT16 w;
	struct
	{
		#if BIG_END==1
		UINT8 h,l;
		#else
		UINT8 l,h;
		#endif
	}b;
}Z80Reg;

#define MAX_FRAMES 60
#define FRAME_MS 166
#define XRES 160*2
#define YRES 144*2
#define Z_FLAG 0x80
#define N_FLAG 0x40
#define H_FLAG 0x20
#define C_FLAG 0x10



#endif
