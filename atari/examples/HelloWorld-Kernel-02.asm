;	Change color per line and within line (76 cylces)
;
;	@com.wudsn.ide.asm.hardware=ATARI2600
;	@com.wudsn.ide.asm.mainsourcefile=HelloWorld.asm

	ldx #0			;X=0
kernel	sta wsync		;Stop CPU for 1 scanline (wait sync)
	txa			;A=X
	and #1			;A=A & 1
	asl			;A=A *2
	stx colubk		;Set background color to x
;:16	nop			;Waste 32 cycles = 96 color clocks (pixel)
;	sta colubk		;Set background color to A
;	stx colubk		;Set background color to X
;	sta colubk		;Set background color to A
;	stx colubk		;Set background color to X
	inx			;X=X+1
	cpx #effect_lines	;Compare X with 192
	bne kernel		;Branch not equal
