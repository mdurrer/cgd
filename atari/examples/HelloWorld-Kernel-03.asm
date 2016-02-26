;	Playfield graphics (21 bits / 40 pixel)
;
;	@com.wudsn.ide.asm.hardware=ATARI2600
;	@com.wudsn.ide.asm.mainsourcefile=HelloWorld.asm

	mva #14 colupf		;Playfield color = white
	mva #0 ctrlpf		;Playfield repeat (0)/mirror (1)	
	ldx #0			;X=0
kernel	sta wsync		;Stop CPU for 1 scanline (wait sync)
	txa			;A=X
	lsr			;A=A/2
	lsr			;A=A/2
	tay			;Y=A
	lda game.graphics+8,y	;A=graphics[8+Y]
	sta pf1			;Store A into playfield 1
	inx			;X=X+1
	cpx #effect_lines	;Compare X with 192
	bne kernel		;Branch not equal