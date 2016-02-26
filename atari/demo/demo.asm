processor 6502
include "vcs.h"
include "macro.h"

seg
org $e000
rorg $f000
lda Temp
cmp #$02
beq Bank1
jmp StartFrame
Bank1:
lda $fff8
inc $82
seg
org $f000
rorg $f000
Temp = $80
;PatternCounter = $81
;ScrollCounter = $82
;FrameCounter = $83
;Change = $84
;jsr ResetRAM
;lda #%10110000
;sta Temp
Reset:
StartFrame:
lda Temp
cmp #$02
beq Bank2
Bank2:
lda $fff9
jmp Bank1
; Start vertical blank
lda #$00
sta VBLANK
lda #2
sta VSYNC
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

ldx #192
l1:
stx COLUBK
sta WSYNC
dex
bne l1
; End of Visible Screen
; Start of VBLANK / Overscan
lda #%01000010
ldx #30
sta VBLANK   
osloop:
sta WSYNC
dex
bne osloop
lda #$02
sta Temp
jmp StartFrame
ResetRAM:
lda #$00
ldx #$80
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
