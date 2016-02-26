.const KOALA_TEMPLATE = "C64FILE, Bitmap=$0000, ScreenRam=$1f40, ColorRam=$2328,BackgroundColor = $2710"

.var screen1 = $0400
.var tiles = LoadBinary("tiles.kla",KOALA_TEMPLATE) 
.var sealevel = 100
.pc = $0801 "Basic upstart"
:BasicUpstart(start)

.pc = $0c00	.fill tiles.getScreenRamSize(),tiles.getScreenRam(i)
.pc = $1c00 colorRam:  .fill tiles.getColorRamSize(), tiles.getColorRam(i)
.pc = $2000            .fill tiles.getBitmapSize(), tiles.getBitmap(i)
start:                           
jsr initraster                  

mainloop:

jmp mainloop                   
/*
start:
jsr initsprites
ldx #numspr-1
initloop:
lda $e000,x
sta sprxl,x
lda $e018,x
and #$01
sta sprxh,x
lda $e030,x
sta spry,x
lda #$3f
sta sprf,x
txa
and #$0f
cmp #$06
bne colorok
lda #$05
colorok:
sta sprc,x
dex
bpl initloop
*/
/*
sei	
lda #$35
sta $01
lda #$7f
sta $dc0d
sta $dd0d
lda $dc0d
lda $dd0d
lda $d011
and #$7f
sta $d011
lda #<irq1
ldx #>irq1
sta $fffe
stx $ffff
lda #$34
sta $d012
lda #$01
sta $d01a
// set up Multicolor bitmap mode and load the default tiles set
lda #$38
sta $d018
lda #$d8
sta $d016
lda #$3b
sta $d011
lda #$00
sta $d020
lda #tiles.getBackgroundColor()
sta $d021	
ldx #$00

cli

// This loop has to be after the CLI, otherwise the raster interrupt will reach the position
// before the program's ready
!loop:
	.for (var i = 0;i<4;i++)
	{
		lda colorRam+i*$100,x
		sta $d800+i*100,x
	}
	inx
	bne !loop-
*/
/*
main:
ldx #numspr -1
moveloop:
lda $e048,x
and #$03
sec 
adc sprxl,x
sta sprxl,x
lda sprxh,x
adc #$00
and #$01
sta sprxh,x
beq moveloop_xnotover
lda sprxl,x
bpl moveloop_xnotover
sec
sbc #$80
sta sprxl,x
dec sprxh,x
moveloop_xnotover:
lda $e060,x
and #$01
sec
adc spry,x
sta spry,x
dex
bpl moveloop
jsr sortsprites
jmp main*/


initraster:     sei
                lda #<irq1
                sta $fffe
                lda #>irq1
                sta $ffff
                lda #$7f                   
                sta $dc0d
                lda #$01                   
                sta $d01a
                lda #27                    
                sta $d011
                lda #sealevel           
                sta $d012
                lda $dc0d                  
                cli
                rts

irq1:
pha
txa
pha
tya
pha
pla
tay
pla
tax
pla
rti


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
    tsx
    cli
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
WedgeIRQ:
    
    txs
    ldx #$08  
    dex       
    bne *-1    
    bit $00    
    lda $d012
    cmp $d012

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