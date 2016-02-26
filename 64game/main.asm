//.var music = LoadSid("Calypso.sid") 
.const KOALA_TEMPLATE = "C64FILE, Bitmap=$0000, ScreenRam=$1f40, ColorRam=$2328,BackgroundColor = $2710"
.var maxspr = $1f  // 32 sprites
.var timer = $03
.var sort = $02
.var tiles = LoadBinary("tiles.kla",KOALA_TEMPLATE) 
 
//.pc = music.location
//.fill music.size, music.getData(i)

.pc = $0801 "Basic upstart"
:BasicUpstart(start)
.pc = $1000
start: 

// . Startvariable
//  Switching off Kernal + BASIC ROM to release the RAM laying below
lda #$35
sta $01
// save registers
lda #$00
tax
tay
sei
// deactivate CIA-I  & CIA-II. The LDAs are for acknowledging the last possible CIA interrupts.
lda #$7f
sta $dc0d
sta $dd0d
lda $dc0d
lda $dd0d

dec $d019 // Ack last IRQ (read / write!)
// deactivate 9. bit of $d012 = bit 8 in $d011 (rasters can go beyond 255, even though we might not see them
lda $d011
and #$7f
sta $d011
// set up Syncing IRQ
lda #<sortalgo
ldx #>sortalgo
sta $fffe
stx $ffff

lda #$34 // Set Raster-IRQ start pos
sta $d012
// Set raster-bit
lda #$00
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
!loop:
	.for (var i = 0;i<4;i++)
	{
		lda colorRam+i*$100,x
		sta $d800+i*100,x
	}
	inx
	bne !loop-

// Set up Multiplexer sort table and other mpx related stuff

// The initl-loop sets values 0-1f into the sort table, so the sort table is properly defined.
// Now comes setting up some buffers!
.var ypos = $c000    //prite y position frame buffer
.var ybuf = $22      //sprite y position raster buffer
.var xpos = $c020    //sprite x position frame buffer
.var xbuf = $42      //sprite x position raster buffer
.var xmsb = $c040    //sprite x msb frame buffer
.var mbuf = $62      //sprite x msb raster buffer
.var sprc = $c060    //sprite color frame buffer
.var cbuf = $82      //sprite color raster buffer
.var sprp = $c080    //sprite pointer frame buffer
.var pbuf = $a2      //sprite pointer raster buffer
	// Precalc some sprites and values to avoid bugs
jsr movesprites
jsr animatesprites
jsr animatecolors
ldx #$00
stx timer
// Init Sort order with numbers sequentially 0-1F
initl:
txa
sta sort,x
inx 
cpx maxspr+1
bne initl

// This blook until sta $d02a is just for seeing, if the code is executed (sprites are displayed) 
ldy #$ff
lda #$ff
wrbip:
sta $2000,y 
dey 
bne wrbip  // this previous block with $2000 is just to see visually, if the code is working or not after a certain command
lda #$ff
sta $d015
lda #$00
sta $d010
lda #$60
sta $d000 
sta $d001 
adc #$20 
sta $d002 
sta $d003 
adc #$20 
sta $d004 
sta $d005 
adc #$20
sta $d006
sta $d007
ldx #$01
stx $d027
inx
stx $d028
inx
stx $d029
inx
sta $d02a
inc $d01a
cli
jmp *
// Mainloop, to be determined
main:
lda timer
sta mloop+1
mloop:
lda *+1
beq main
jsr movesprites
jsr animatesprites
jsr animatecolors
rts
cont:
jmp main
movesprites:
rts
animatecolors:
rts
animatesprites:
rts

sortalgo:
:SaveAXY()
//:StableIRQ()
lda #<sortalgo
sta $fffe
lda #>sortalgo
sta $ffff
asl $d019
inc $d027
inc $d028
lda #$34
sta $d012
:RestoreAXY()
rti

.pc = $0c00	.fill tiles.getScreenRamSize(),tiles.getScreenRam(i)
.pc = $1c00 colorRam:  .fill tiles.getColorRamSize(), tiles.getColorRam(i)
.pc = $2000            .fill tiles.getBitmapSize(), tiles.getBitmap(i)

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

		pla
		tay
		pla
		tax                                         
		pla
{
}