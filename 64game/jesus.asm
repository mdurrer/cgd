// Lttle Jesus Demo
.pc = $0801	"Basic Upstart"
:BasicUpstart(start)
.pc= $0900 "Raster Bar Sets"
raster:
.import c64  "images/raster.bar"
.pc = $1000 "Main Code"
.var val = $42
delays:
.byte 5,4,3,2,1

start:
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
:Delay(200) 
inc $d020 
jmp *

.macro Delay(timerdelay) 
{ 
!initloop: ldy #timerdelay 
ldx #$ff 
!loop: 
dex
bne !loop-
dey
ldx #$ff
bne *-4
}
.pc = $1600
irq:
:SaveRegisters()
ldx #$06
!loop:
dex 
bne !loop-
lda #raster
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
.macro StableIRQ()
{
//«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»
// Raster Stabilizing Code
//«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»«»

    lda #<WedgeIRQ
    sta $fffe
    lda #>WedgeIRQ
    sta $ffff

    inc $d012
    lda #$01
    sta $d019

    // Store current Stack Pointer (will be messed up when the next IRQ occurs)
    tsx

    // Allow IRQ to happen (Remeber the Interupt flag is set by the Interrupt Handler).
    cli

    // Execute NOPs untill the raster line changes and the Raster IRQ triggers
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    // Add one extra nop for 65 cycle NTSC machines

    // CYCLECOUNT: [64 -> 71]

WedgeIRQ:
    // At this point the next Raster Compare IRQ has triggered and the jitter is max 1 cycle.
    // CYCLECOUNT: [7 -> 8] (7 cycles for the interrupt handler + [0 -> 1] cycle Jitter for the NOP)

    // Restore previous Stack Pointer (ignore the last Stack Manipulation by the IRQ)
    txs

    // PAL-63  // NTSC-64    // NTSC-65
    //---------//------------//-----------
    ldx #$08   // ldx #$08   // ldx #$09
    dex        // dex        // dex
    bne *-1    // bne *-1    // bne *-1
    bit $00    // nop
               // nop

    // Check if $d012 is incremented and rectify with an aditional cycle if neccessary
    lda $d012
    cmp $d012  // <- critical instruction (ZERO-Flag will indicate if Jitter = 0 or 1)

    // CYCLECOUNT: [61 -> 62] <- Will not work if this timing is wrong

    // cmp $d012 is originally a 5 cycle instruction but due to piplining tech. the
    // 5th cycle responsible for calculating the result is executed simultaniously
    // with the next OP fetch cycle (first cycle of beq *+2).

    // Add one cycle if $d012 wasn't incremented (Jitter / ZERO-Flag = 0)
    beq *+2

    // Stable code    
}
.macro SaveAXY()
{
		pha // 3
		txa // 2
		pha // 3
		tya // 2
		pha // 3
}
.macro RestoreAXY()
{
		pla
		tay
		pla
		tax                                         
		pla

}