obj = main.obj &
	  wvga.obj dpmi.obj timer.obj mouse.obj keyb.obj &
	  mingl.obj mglrast.obj mglclip.obj mglgen.obj &
	  texture.obj palman.obj scene.obj cvec.obj &
	  fixedp.obj
bin = deepston.exe

CC = wcc386
CFLAGS = -5 -fp5 -otexan -zq -bt=dos -DRAST_FLOAT -DDBG_USE_FLOAT
LD = wlink

$(bin): $(obj)
	%write objects.lnk file { $(obj) }
	$(LD) name $@ @objects $(LDFLAGS)

.c: src\

.c.obj: .autodepend
	$(CC) $(CFLAGS) $[*

clean: .symbolic
	del *.obj
	del $(bin)
