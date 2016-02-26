processor 6502
include "vcs.h"
include "macro.h"

SEG
ORG $F000

Reset
StartOfFrame

lda #0
sta VBLANK
lda #2
sta VSYNC

sta WSYNC
sta WSYNC
sta WSYNC
lda #0
sta VSYNC

REPEAT 50
	sta WSYNC
REPEND



lda #%01000010
sta VBLANK
lda #$0
REPEAT 30
sta WSYNC
REPEND
jmp StartOfFrame

ORG $FFFA
.word Reset
.word Reset
.word Reset
END
