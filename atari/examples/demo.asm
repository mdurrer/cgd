processor 6502
include "vcs.h"
include "macro.h"

seg
org $f000

Temp = $80
PatternCounter = $81
jsr ResetRAM
Reset:
StartFrame:

; Start vertical blank
lda #$00
sta VBLANK
lda #2
sta VSYNC
repeat 3
	sta WSYNC
repend
lda #$00
sta VSYNC
; End of Vertical Sync
ldx #37
vbloop:
sta WSYNC
dex
bne vbloop
;End of vertical blank
inc PatternCounter
lda PatternCounter
cmp #2
bne notyet
lda #$00
sta PatternCounter
inc Temp
notyet:
lda Temp
sta PF0
sta PF1
sta PF2
; 192 Scanlines of Visible Screen
ldx #192
vscreen:
stx COLUBK
lda #$58
sta COLUPF
lda #%00000001
sta CTRLPF
sta WSYNC
dex
bne vscreen
; End of Visible Screen
; Start of VBLANK / Overscan
lda #%01000010
sta VBLANK   
ldx #30
osloop:
sta WSYNC
dex
bne osloop

jmp StartFrame
ResetRAM:
lda #$00
ldx #$7f
iresetloop:
resetloop:
sta Temp,x
dex
bne resetloop
rts
org $fffa
.word Reset 
.word Reset
.word Reset
end