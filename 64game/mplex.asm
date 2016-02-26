.const KOALA_TEMPLATE = "C64FILE, Bitmap=$0000, ScreenRam=$1f40, ColorRam=$2328,BackgroundColor = $2710"
.var tilesetA = LoadBinary("new_tiles.kla",KOALA_TEMPLATE)

.var NUMSPR = 24
.var MAXSPR = 24

.var MINSPRY = 30
.var MAXSPRY = 250
.var IRQ1LINE = $10
.var fpl = $02
.var s  = $03
.var ph = $04

.var temp4 = $08
.var spry = $40
.var sprorder = $40 + MAXSPR + 1
.var screen1 = $0c00
.var tiles = LoadBinary("tiles.kla",KOALA_TEMPLATE) 
.pc = $8000 "Cursor Sprites"
cursors: 
.import c64 "cursors.bin"


// Maps coordinates (column, row) to chars. $ff finishes the tile reading process
alphatilemap:
flatasphalt:
.byte $00,$00,$00,$01,$01,$00,$01,$01,$ff
risingasphalt:
.byte $02,$00,$03,$00,$02,$01,$03,$01,$ff
descendingasphalt: 
.byte $04,$00,$05,$00,$04,$01,$05,$01,$ff 
asphaltpuddle:
.byte $11,$00,$12,$00,$13,$00,$14,$00,$15,$01,$07,$01,$08,$01,$09,$01,$ff
bush:
.byte $06,$00,$07,$00,$08,$00,$09,$00,$06,$01,$07,$01,$08,$01,$09,$01,$ff
grass:
.byte $0a,$00,$0b,$00,$0a,$01,$0b,$01,$ff
waterfalltop:
.byte $0e,$00,$0f,$00,$10,$00,$0e,$01,$0f,$01,$10,$01,$ff
waterfalla:
.byte $0e,$02,$0f,$02,$10,$02,$0e,$03,$0f,$03,$10,$03,$ff
waterfallb:
.byte $0e,$04,$0f,$04,$10,$04,$0e,$05,$0f,$05,$10,$05,$ff
cloud:
.byte $15,$00,$16,$00,$17,$00,$18,$00,$19,$00,$1a,$00,$1a,$00,$1b,$00,$1c,$00,$1d,$00,$1e,$00,$ff
.byte $15,$01,$16,$01,$17,$01,$18,$01,$19,$01,$1a,$01,$1a,$01,$1b,$01,$1c,$01,$1d,$01,$1e,$01,$ff
.byte $15,$02,$16,$02,$17,$02,$18,$02,$19,$02,$1a,$02,$1a,$02,$1b,$02,$1c,$02,$1d,$02,$1e,$02,$ff
.byte $15,$03,$16,$03,$17,$03,$18,$03,$19,$03,$1a,$03,$1a,$03,$1b,$03,$1c,$03,$1d,$03,$1e,$03,$ff

sprcursor:
cursorx: .byte $64
cursory: .byte $64
cursormsb: .byte $00
cursorcol: .byte $00
cursorframe: .byte $18
betatilemap:
.pc = $0801 "Basic upstart"
:BasicUpstart(start)

.pc = $0c00 "Screen RAM"
screenRam:
.fill tilesetA.getScreenRamSize(),tilesetA.getScreenRam(i)
.pc = $1c00 "Color RAM"
colorRam:
.fill tilesetA.getColorRamSize(),tilesetA.getColorRam(i)
.pc = $2000 "Bitmap RAM"
bitMap:
.fill tilesetA.getBitmapSize(),tilesetA.getBitmap(i)
.pc = $0600 "Main Cursor" 
.import c64 "maincursor.bin"
.pc = $1040 "Main Code"

start:
		lda #$35
		sta $01 
		jsr initraster                  //Init raster interrupts

		/* Fix Raster first for Kernal-less mode!*/
		// Load graphic mode for tiles
		lda #$38
		sta $d018
		lda #$d8
		sta $d016
		lda #$3b
		sta $d011
		lda #$00
		sta $d020
		lda #tilesetA.getBackgroundColor()
		sta $d021
		ldx #$0
!loop:
		.for (var i=0; i<4; i++) {
				lda colorRam+i*$100,x
				sta $d800+i*$100,x
				}
		inx
		bne !loop-
		

		
jsr drawcursor
afterexample:
				
		jsr handlecursor                 //Sort sprites, build sprite IRQ lists and set the update flag
		jmp *               //Back to loop				
drawcursor:				
				
		lda #$50
		sta $d000
		sta $d001
		lda #$0
		sta $d010
		lda #$01
		sta $d027
		lda #$db
		sta $37f8
		rts				
handlecursor:		
		ldx #$00
		lda $dc00		
		tay		
		and #$10	
		beq button_pressed	
		tya
		and #$08
		beq right_pressed
		tya
		and #$04
		beq left_pressed
		tya
		and #$02
		beq down_pressed
		tya 
		and #$01
		beq up_pressed
		jmp endhandle	
right_pressed:	
		inc $d000
		jmp endhandle	
left_pressed:	
		dec $d000
		jmp endhandle	
down_pressed:	
		inc $d001
		jmp endhandle	
up_pressed:	
		dec $d001
		jmp endhandle	
button_pressed:	
		inc $d027
endhandle:
		rts		
		
		// Routine to init the raster interrupt system
		
		initraster:     
		
		lda #<irqnoway
		sta $fffe
		lda #>irqnoway
		sta $ffff
		lda #$7f                    //CIA interrupt off
		sta $dc0d
		sta $dc0d
		lda $dc0d
		lda $dd0d
		lda $d011
		and #$7f                   //High bit of interrupt position = 0
		sta $d011
		lda #IRQ1LINE               //Line where next IRQ happens
		sta $d012
		lda #$01                    //Raster interrupt on
		sta $d01a
		rts
		
		
		// IRQ code
		// IRQ at the top of the screen. Take sprite update from the main program and
		// start showing the sprites
		irqnoway:
		:SaveAXY()
		asl $d019
		inc $d020
		inc $d021
		lda #<irqnoway
		ldx #>irqnoway
		sta $fffe
		stx $ffff
		dec $d020
		dec $d021
		:RestoreAXY()
		rti

multiply:

   lda #0

// alternate entry point: P = FPL * S + accumulator
   ldx  #8
   lsr fpl
l1: 
   bcc l2
   clc
   adc s
l2: 
   ror
   ror fpl
   dex
   bne l1
   sta ph 
   rts 
.macro CopyTileTo(tile,destadr)
{	
	.var tempx = $10
	.var tempy = $11
	ldx #$00
	lda flatasphalt,x
	inx
	sta fpl
	ldy #40
	sty s
	jsr multiply
	lda ph
	sta tempy
	lda fpl
	sta tempx
	lda flatasphalt,x
	inx
	clc
	adc tempx
	
	
}
	                       //All spriteIRQ's done, return to the top of screen IRQ
.macro SaveAXY()
{
	pha
	txa
	pha
	tya
	pha
}

.macro RestoreAXY()
{
	pla
	tay
	pla
	tax
	pla
}