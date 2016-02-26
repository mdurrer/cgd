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


ldx #$25
sta WSYNC
dex
bne *-3








; 192 scanlines of picture...
lda $80
cmp #$01
beq cl1

ldy #0
ldx #0
cl1:
clc
colloop:
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
inx
stx COLUBK
stx COLUPF

nop
nop
nop
nop
iny
sty COLUBK
iny
sty COLUPF
sty COLUPF
nop
nop
nop
dey
sty COLUBK
iny
sta WSYNC

cpy #$c0
bne colloop
lda #$1
sta $80
lda #%01000010
sta VBLANK                     ; end of screen - enter blanking



; 30 scanlines of overscan...

ldx #$1e
sta WSYNC
dex
bne *-3



jmp StartOfFrame





ORG $FFFA



.word Reset          ; NMI

.word Reset          ; RESET

.word Reset          ; IRQ



END

