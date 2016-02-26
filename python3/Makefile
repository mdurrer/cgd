SHEDSKIN_LIBDIR=/usr/lib/python2.7/site-packages/shedskin/lib
CC=g++
CCFLAGS=-O2 -march=native -Wno-deprecated $(CPPFLAGS) -I. -I${SHEDSKIN_LIBDIR}
LFLAGS=-lgc -lpcre $(LDFLAGS) -lutil

CPPFILES=/home/michael/code/mve/python3/example1.cpp \
	${SHEDSKIN_LIBDIR}/sys.cpp \
	${SHEDSKIN_LIBDIR}/stat.cpp \
	${SHEDSKIN_LIBDIR}/re.cpp \
	${SHEDSKIN_LIBDIR}/os/path.cpp \
	${SHEDSKIN_LIBDIR}/os/__init__.cpp \
	${SHEDSKIN_LIBDIR}/builtin.cpp

HPPFILES=/home/michael/code/mve/python3/example1.hpp \
	${SHEDSKIN_LIBDIR}/sys.hpp \
	${SHEDSKIN_LIBDIR}/stat.hpp \
	${SHEDSKIN_LIBDIR}/re.hpp \
	${SHEDSKIN_LIBDIR}/os/path.hpp \
	${SHEDSKIN_LIBDIR}/os/__init__.hpp \
	${SHEDSKIN_LIBDIR}/builtin.hpp

all:	example1

example1:	$(CPPFILES) $(HPPFILES)
	$(CC)  $(CCFLAGS) $(CPPFILES) $(LFLAGS) -o example1

example1_prof:	$(CPPFILES) $(HPPFILES)
	$(CC) -pg -ggdb $(CCFLAGS) $(CPPFILES) $(LFLAGS) -o example1_prof

example1_debug:	$(CPPFILES) $(HPPFILES)
	$(CC) -g -ggdb $(CCFLAGS) $(CPPFILES) $(LFLAGS) -o example1_debug

clean:
	rm -f example1 example1_prof example1_debug

.PHONY: all clean

