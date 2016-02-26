;	WUDSN IDE example MADS source file for Atari 2600
;
;	@com.wudsn.ide.asm.hardware=ATARI2600

effect_lines = 192

	icl "VCS.asm"		;Include equate definitions

cnt	= $80			;First byte in RAM		
xpos	= $81			;Player X-Position

;===============================================================

	opt h-f+l+		;Create plain 4k ROM file

	org $f000		;Main part

	.proc cart
start
	cld			;Clear decimal flag
	lda #0
	tax
init	sta $00,x		;Clear TIA ($00-$3f) and 128 bytes of RAM ($80-$ff)
	inx
	bne init
	dex
	txs			;Set stack pointer to $ff

;===============================================================

	.proc main
frame_loop
	lda #$02
	sta wsync		;Hold CPU for 1 scanline
	sta vsync		;Set vertical sync for TV
	sta wsync		;Hold CPU for 3 scanlines
	sta wsync
	sta wsync
	lsr
	sta vsync		;Clear vertical sync for TV

;===============================================================

	.proc vblank_area	;Upper blank area
	lda #74			;Start vblank time counter 74*64 cycles
	sta tim64t
	lda #$34		;Background red
	sta colubk
loop	lda intim		;Sync with beam again
	bne loop
	sta wsync
	sta vblank		;Deactivate VBLANK bit 1
	.endp

;===============================================================

	.proc playfield_area	;Display playfield content line by line

	ldx #0			;X=0
kernel	sta wsync		;Stop CPU for 1 scanline (wait sync)
	lda #0			;A=0
	stx colubk		;Store A to background color
	inx			;X=X+1
	cpx #effect_lines	;Compare X with 192
	bne kernel		;Branch not equal

;	icl "HelloWorld-Kernel.asm"

	.endp			;End of playfield

;===============================================================

	.proc overscan_area	;Lower blank area
	lda #2
	sta vblank		;Activate VBLANK bit 1

	lda #65
	sta tim64t		;Start overscan time counter 65*64 cycles

	jsr game.read_joystick	;Execute game logic
	inc cnt			;Inrement frame counter

loop	lda intim		;Sync with beam again
	bne loop
	jmp frame_loop

	.endp			;End of overscan

	.endp			;End of main

;===============================================================

	.proc game
	
	.proc read_joystick
	lda swcha
	lsr			;Upper 4 bits are joystick 1
	lsr
	lsr
	lsr
	lsr			;Lower 4 bits are joystick 0
	lsr

	lsr			;Shift bit to carry flag
	bcs not_left		;Branch if carry set
	dec xpos		;XPOS=XPOS-1
not_left
	lsr			;Shift bit to carry flag
	bcs not_right		;Branch if carry set
	inc xpos		;XPOS=XPOS+1
not_right
	rts
	.endp

	.align $100

	.local graphics
	ins "gfx/Plugin.pic"
	.endl
	
	.endp			;End of game

;===============================================================

	.endp			;End of cart

	.print "End of code is ", *

	org $fffc		;Cartridge vectors
	.word cart.start	;Reset vector
	.word $ffff		;Free 