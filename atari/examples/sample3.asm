processor 6502

include "vcs.h"

include "macro.h"



SEG

ORG $F000



Reset

StartOfFrame



; Start of vertical blank processing



lda #0

sta VBLANK



lda #2

sta VSYNC



; 3 scanlines of VSYNCH signal...



sta WSYNC

sta WSYNC

sta WSYNC



lda #0

sta VSYNC           



; 37 scanlines of vertical blank...
lda #$45
REPEAT 37
sta WSYNC
REPEND







; 48 scanlines of picture...
lda #48
sta COLUBK
REPEAT 30
sta WSYNC
REPEND
; Balken oben
sta COLUBK

ldx #39
bo:
lda #$0e
REPEAT 7
nop
bit $cc
REPEND


sta COLUBK
REPEAT 4
nop
REPEND
lda #48
sta COLUBK
sta WSYNC
dex
bne bo
;balken mitte
REPEAT 40
	REPEAT 15
		nop
	REPEND
		lda #$0e
		sta COLUBK
	REPEAT 15
		nop
	REPEND
lda #48
sta COLUBK
sta WSYNC
REPEND
;Balken Unten
REPEAT 40
REPEAT 20
nop
REPEND
lda #$0e
sta COLUBK
REPEAT 4
nop
REPEND
lda #48
sta COLUBK
sta WSYNC
REPEND
ldx #$20
bu:
sta WSYNC
dex
bne bu
lda #%01000010
sta VBLANK                     ; end of screen - enter blanking



; 30 scanlines of overscan...

ldx #$1e
REPEAT 30
sta WSYNC
REPEND




jmp StartOfFrame





ORG $FFFA



.word Reset          ; NMI

.word Reset          ; RESET

.word Reset          ; IRQ



END

