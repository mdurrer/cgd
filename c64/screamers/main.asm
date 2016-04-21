// Screamers example
.pc = $0801 "Basic Upstart"
:BasicUpstart2(start)
.pc = $8000
start:
jsr $ff81
sei
lda #$7f
sta $dc0d
sta $dd0d
lda $dc0d
lda $dd0d
lda #$01
sta $d01a
lda #$71
sta $d012
lda #$1b
sta $d011
lda #$35
sta $01
lda #<mainirq
ldx #>mainirq
sta $fffe
stx $ffff


cli

jmp *

mainirq:
pha
txa
pha
tya
pha
inc $d021
nop
nop
nop
dec $d021
lda #<mainirq
ldx #>mainirq
sta $fffe
stx $ffff

lda #$71
sta $d012
lda #$01
sta $d019
pla
tay
pla
tax
pla
rti
