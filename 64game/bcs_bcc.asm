// Testing a switch to from Kernal to hardware vectors
.pc = $801
:BasicUpstart(start)
.pc = $1000
.var val = $42
start:
lda #$00
sta $d020
sta $d021
clc
sei
lda #$00
ldx #$15
sta $0314
stx $0315
lda #$01
sta $d01a
lda #$7f 
sta $dc0d
sta $dd0d
lda $d011
and #$7f
sta $d011
lda $dc0d
lda $dd0d
lda #$50
sta $d012
asl $d019
rts

.pc = $1600
irq:

jmp $ea81