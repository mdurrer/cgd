include "vcs.h"
include "macro.h"
processor 6502
;---BANK ONE---
Temp = $80
SprAct = $81
Pressed = $90
P0Pos = $96
CurrentLine = $97
   org $d000
   rorg $f000
b1:
jsr Part1
lda $fff9
jmp b2
Part1:
Reset:
StartFrame:
; Start vertical blank
lda #$00
sta VBLANK
lda #2
sta VSYNC
; Extra stuff for init
lda #$50
sta P0Pos
sta WSYNC
sta WSYNC
sta WSYNC
lda #$00
sta VSYNC

; End of Vertical Sync
ldx #37
vbloop:
sta WSYNC
dex
bne vbloop

;End of vertical blank

; Pre values for 192 scanlines
sta COLUPF
lda #%00000001
; 192 Scanlines of Visible Screen
lda #$01
sta NUSIZ0
lda #$01
sta CTRLPF
lda #$45
sta COLUPF

ldx #192
l1:
stx COLUBK
cpx #100
bcc jmpspr
lda #%01010101
sta GRP0

nop
sta RESP0

nop
nop
sta RESP0
nop 
nop
sta RESP0
nop
nop
sta RESP0
nop
nop
sta RESP0
nop
nop
sta RESP0
nop
nop
sta RESP0
nop
nop
sta RESP0
jmpspr:

sta WSYNC
dex
bne l1

;lda INPT4
;bmi NotPressed
;lda #$01
;sta Pressed
;NotPressed:
; End of Visible Screen
; Start of VBLANK / Overscan
lda #%01000010
ldx #30
sta VBLANK   
osloop:
sta WSYNC
dex
bne osloop
jsr PlayMusic
rts
ResetRAM:
lda #$00
ldx #$80
resetloop:
sta Temp,x
dex
bne resetloop
rts
PlayMusic:
rts
; Using the same amount of bytes as in b1/b2, so that the program counter (PC) jumps back at the right address when we switch banks
logoD:
.byte %11100111
.byte %10010100
.byte %10010100
.byte %10010111
.byte %10010111
.byte %10010100
.byte %10010100
.byte %11100111
logoE:
.byte %01000000
.byte %10100000
.byte %10100000
.byte %11100000
.byte %10100000
.byte %10100000
.byte %10100000
.byte %10100000
;---Graphics Data from PlayerPal 2600---

Frame0
        .byte #%00011000;$6A
        .byte #%00111100;$5C
        .byte #%01001110;$5A
        .byte #%01010110;$68
        .byte #%01010110;$76
        .byte #%01010110;$84
        .byte #%01001110;$92
        .byte #%00111100;$90
Frame1
        .byte #%00011000;$6A
        .byte #%00111100;$5C
        .byte #%01001100;$5A
        .byte #%01011110;$68
        .byte #%01001110;$76
        .byte #%01011110;$84
        .byte #%01001110;$92
        .byte #%00111100;$90
Frame2
        .byte #%00111100;$6A
        .byte #%01111110;$5C
        .byte #%01010110;$5A
        .byte #%01000110;$68
        .byte #%01010110;$76
        .byte #%01000110;$84
        .byte #%01101110;$92
        .byte #%00111100;$90
Frame3
        .byte #%00011000;$6A
        .byte #%00100100;$5C
        .byte #%01101110;$5A
        .byte #%01101110;$68
        .byte #%01101110;$76
        .byte #%01101110;$84
        .byte #%00111100;$92
        .byte #%00011000;$90
Frame4
        .byte #%00111100;$6A
        .byte #%01101110;$5C
        .byte #%01101110;$5A
        .byte #%01101110;$68
        .byte #%01111110;$76
        .byte #%01101110;$84
        .byte #%01111110;$92
        .byte #%00111100;$90
Frame5
        .byte #%00011000;$6A
        .byte #%00111100;$5C
        .byte #%01011010;$5A
        .byte #%01011010;$68
        .byte #%01010010;$76
        .byte #%01001010;$84
        .byte #%01011010;$92
        .byte #%00111100;$90
;---End Graphics Data---


;---Color Data from PlayerPal 2600---

ColorFrame0
        .byte #$6A;
        .byte #$5C;
        .byte #$5A;
        .byte #$68;
        .byte #$76;
        .byte #$84;
        .byte #$92;
        .byte #$90;
ColorFrame1
        .byte #$6A;
        .byte #$5C;
        .byte #$5A;
        .byte #$68;
        .byte #$76;
        .byte #$84;
        .byte #$92;
        .byte #$90;
ColorFrame2
        .byte #$6A;
        .byte #$5C;
        .byte #$5A;
        .byte #$68;
        .byte #$76;
        .byte #$84;
        .byte #$92;
        .byte #$90;
ColorFrame3
        .byte #$6A;
        .byte #$5C;
        .byte #$5A;
        .byte #$68;
        .byte #$76;
        .byte #$84;
        .byte #$92;
        .byte #$90;
ColorFrame4
        .byte #$6A;
        .byte #$5C;
        .byte #$5A;
        .byte #$68;
        .byte #$76;
        .byte #$84;
        .byte #$92;
        .byte #$90;
ColorFrame5
        .byte #$6A;
        .byte #$5C;
        .byte #$5A;
        .byte #$68;
        .byte #$76;
        .byte #$84;
        .byte #$92;
        .byte #$90;
;---End Color Data---
PlayField1:
.byte #%00000011
PlayField2:
.byte #%10000000

   org $DFFA
   rorg $FFFA
	.word b1
	.word b1
	.word b1
;--bank one vectors here.

;---BANK TWO

   org $e000
   rorg $f000
	b2:
	jsr Part2
	lda $fff8
	jmp b1
	Part2:
	lda INPT4
	bmi NotPressed
	inc $91
	inc $92
	inc $93
	inc $94
	inc $95
	inc $96
	NotPressed
	rts
;same as above

   org $EFFA
   rorg $FFFA
	.word b2
	.word b2
	.word b2
