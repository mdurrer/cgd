;	Sound effects
;
;	@com.wudsn.ide.asm.hardware=ATARI2600
;	@com.wudsn.ide.asm.mainsourcefile=HelloWorld.asm

	mva xpos audc0		;Divider control
	mva cnt audf0		;Frequency 0..31

	lda #0			;A=0
	bit inpt4		;Test fire button
	bmi not_pressed		;Branch
	lda #12			;A=12
not_pressed
	sta audv0		;Volume 0..15