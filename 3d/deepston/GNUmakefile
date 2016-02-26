obj = src/main.o \
	  src/mingl.o src/mglrast.o src/mglclip.o src/mglgen.o \
	  src/texture.o src/palman.o \
	  src/scene.o src/cvec.o src/fixedp.o \
	  src/dosemu/dosemu.o
dep = $(obj:.o=.d)
bin = deepstone

dbg = -g
#opt = -O3 -ffast-math

CC = gcc
CFLAGS = -pedantic -Wall $(dbg) $(opt) `pkg-config --cflags sdl` -Isrc -Isrc/dosemu $(add_cflags) -DRAST_FLOAT -DDBG_USE_FLOAT
LDFLAGS = `pkg-config --libs sdl` -lm
#LDFLAGS = -Llib64 -Wl,-rpath=./lib64 -lSDL -lm
#LDFLAGS = -m32 -Llib32 -Wl,-rpath=./lib32 -lSDL-1.2 -lm

ifeq ($(shell uname -s), Darwin)
	add_cflags = -Dmain=SDL_main
endif

$(bin): $(obj)
	$(CC) -o $@ $(obj) $(LDFLAGS)

-include $(dep)

%.d: %.c
	@$(CPP) $(CFLAGS) $< -MM -MT $(@:.d=.o) >$@

.PHONY: clean
clean:
	rm -f $(obj) $(bin)

.PHONY: cleandep
cleandep:
	rm -f $(dep)
