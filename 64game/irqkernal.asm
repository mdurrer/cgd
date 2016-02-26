// Testing a switch to from Kernal to hardware vectors
.pc = $801
:BasicUpstart(start)
.pc = $1000
.var val = $42
start:

lda #$00
sta $d020
sta $d021
lda #$7f 
sta $dc0d
sta $dd0d
lda $dc0d
lda $dd0d
asl $d019
lda #$35
sta $01
lda $d011
and #$7f
sta $d011

lda #$50
sta $d012

lda #<irq
ldx #>irq
sta $fffe
stx $ffff
lda #$01
sta $d01a
jmp *

.pc = $1600
irq:
:SaveRegisters()
ldx #$ff
inc $d021
dex
bne *-4
lda #$50
sta $d012
lda #<irq
ldx #>irq
sta $fffe
stx $ffff
asl $d019
:RestoreRegisters()
rti
.macro SaveRegisters()
{
pha
txa
pha
tya
pha
}
.macro RestoreRegisters()
{
pla
tay
pla
tax
pla
}