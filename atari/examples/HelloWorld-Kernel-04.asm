;	Player graphics
;
;	@com.wudsn.ide.asm.hardware=ATARI2600
;	@com.wudsn.ide.asm.mainsourcefile=HelloWorld.asm

	mva cnt colup0		;Player 0 color flashing

	ldx #0			;X=0
:10	nop			;Wait 60 pixel
	sta resp0		;Position player 0

	lda xpos		;A=xpos
:3	lsr			;A=A/8
	sta nusiz0		;Store are to number & size 

kernel	sta wsync		;Stop CPU for 1 scanline (wait sync)
	lda game.graphics,x	;A=graphics[X]
	sta grp0		;Store A into player 0
	inx			;X=X+1
	cpx #effect_lines	;Compare X with 192
	bne kernel		;Branch not equal