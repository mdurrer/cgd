; Disassembly of dragrace.bin
; Disassembled Thu Apr 03 09:16:03 2003
; Using DiStella v2.0
;
; Command Line: D:\PERSONAL\ATARI2~1\TOOLS\DISTELLA\DISTELLA.EXE -pafs dragrace.bin 
;
;  Colors:
;     02 is dark blue
;     07 is light grey
;     12 is bright blue.
;     99 is dirt colored tan.
;     22 is an aqua blue.
;     33 is light green.
;     44 is light grey.
;     55 is dark gold/tanish color.
;     61 is burnt sienna.
;     77 is a reddish/orange.	
;     5A is yellow
;     6A is orange
;     7c is bright aauq
;     5F is bright yellow

      processor 6502
VSYNC   =  $00
VBLANK  =  $01
WSYNC   =  $02
NUSIZ0  =  $04
NUSIZ1  =  $05
COLUP0  =  $06
COLUP1  =  $07
COLUPF  =  $08
COLUBK  =  $09
CTRLPF  =  $0A
REFP1   =  $0C
PF0     =  $0D
PF1     =  $0E
PF2     =  $0F
RESP0   =  $10
AUDC0   =  $15
AUDF0   =  $17
AUDV0   =  $19
GRP0    =  $1B
GRP1    =  $1C
ENABL   =  $1F
HMP0    =  $20
VDELP0  =  $25
HMOVE   =  $2A
HMCLR   =  $2B
SWCHA   =  $0280
SWCHB   =  $0282
INTIM   =  $0284
TIM64T  =  $0296
LF6F2   =   $F6F2

       ORG $F000

START:
       SEI            ;2
       CLD            ;2
       LDX    #$00    ;2
LF004: LDA    #$00    ;2
LF006: STA    VSYNC,X ;4
       TXS            ;2
       INX            ;2
       BNE    LF006   ;2
       LDA    $82     ;3
       BNE    LF013   ;2
       JMP    LF2FD   ;3
LF013: JSR    LF6D3   ;6
LF016: LDX    #$06    ;2
LF018: LDA    LF6CA,X ;4
       EOR    $84     ;3
       AND    $85     ;3
       STA    $86,X   ;4
       DEX            ;2
       BPL    LF018   ;2
       NOP            ;2
       NOP            ;2
       NOP            ;2
       NOP            ;2
       NOP            ;2
       LDX    $8F     ;3
       SEC            ;2
       LDY    #$00    ;2
       LDA    $BA,X   ;4
LF030: INY            ;2
       SBC    #$03    ;2
       BPL    LF030   ;2
       DEY            ;2
       SEC            ;2
       TYA            ;2
       LDY    #$00    ;2
LF03A: INY            ;2
       SBC    #$05    ;2
       BPL    LF03A   ;2
       DEY            ;2
       STY    $BC,X   ;4
       ADC    #$05    ;2
       STA    $BE,X   ;4
LF046: LDA    INTIM   ;4
       BNE    LF046   ;2
       STA    WSYNC   ;3
       STA    VBLANK  ;3
       STA    $AA     ;3
LF051: LDX    $AA     ;3
       LDA    $BA,X   ;4
       JSR    LF4E5   ;6
       LDX    $AA     ;3
       LDA    #$03    ;2
       STA    NUSIZ0  ;3
       STA    NUSIZ1  ;3
       LDY    $C4,X   ;4
       LDA    LF6C0,Y ;4
       STA    WSYNC   ;3
       STA    PF0     ;3
       STA    PF2     ;3
       LDA    LF6C4,Y ;4
       STA    PF1     ;3
       JSR    LF7D0   ;6
       LDY    #$05    ;2
LF075: STA    WSYNC   ;3
       DEY            ;2
       BPL    LF075   ;2
       LDX    $AA     ;3
       LDY    $BC,X   ;4
LF07E: DEY            ;2
       BPL    LF07E   ;2
       LDY    $BE,X   ;4
       CPY    #$04    ;2
       BEQ    LF095   ;2
       CPY    #$03    ;2
       BEQ    LF098   ;2
       CPY    #$02    ;2
       BEQ    LF09B   ;2
       CPY    #$01    ;2
       BEQ    LF09E   ;2
       BNE    LF0A0   ;2
LF095: NOP            ;2
       LDA    $D8     ;3
LF098: NOP            ;2
       LDA    $D8     ;3
LF09B: NOP            ;2
       LDA    $D8     ;3
LF09E: LDA    $D8     ;3
LF0A0: NOP            ;2
       NOP            ;2
       LDA    #$16    ;2
       STA    $8E     ;3
       CLC            ;2
LF0A7: LDY    $8E     ;3
       LDA    ($90),Y ;5
       STA    GRP0    ;3
       LDA    ($92),Y ;5
       STA    GRP1    ;3
       LDA    ($94),Y ;5
       STA    GRP0    ;3
       LDA    ($9A),Y ;5
       STA    $D8     ;3
       LDA    ($98),Y ;5
       TAX            ;2
       LDA    ($96),Y ;5
       LDY    $D8     ;3
       STA    GRP1    ;3
       STX    GRP0    ;3
       STY    GRP1    ;3
       STA    GRP0    ;3
       LDA    $D8     ;3
       NOP            ;2
       LDA    $8E     ;3
       LSR            ;2
       LSR            ;2
       LSR            ;2
       TAY            ;2
       LDA    LF6D0,Y ;4
       STA    PF0     ;3
       STA    PF1     ;3
       STA    PF2     ;3
       LDY    $8E     ;3
       LDA    ($90),Y ;5
       STA    GRP0    ;3
       LDA    ($92),Y ;5
       STA    GRP1    ;3
       LDA    ($94),Y ;5
       STA    GRP0    ;3
       LDA    ($96),Y ;5
       LDY    $D8     ;3
       STA    GRP1    ;3
       STX    GRP0    ;3
       STY    GRP1    ;3
       STA    GRP0    ;3
       NOP            ;2
       NOP            ;2
       NOP            ;2
       DEC    $8E     ;5
       BPL    LF0A7   ;2
       LDX    #$01    ;2
LF0FD: LDY    #$00    ;2
       STY    GRP0    ;3
       STY    GRP1    ;3
       DEX            ;2
       BPL    LF0FD   ;2
       STX    WSYNC   ;3
       LDA    $99     ;3; Strip of color below the car
       STA    COLUBK  ;3
       LDX    #$09    ;2
LF10E: STA    WSYNC   ;3
       LDA    #$F7    ;2
       STA    $90,X   ;4
       DEX            ;2
       DEX            ;2
       BPL    LF10E   ;2
       LDA    $22     ;3; Color behind tachometer. was 89.
       STA    COLUBK  ;3
       LDA    #$02    ;2
       STA    CTRLPF  ;3
       LDA    $87     ;3; 8A to 87 Color.  First part of tachometer.
       STA    COLUP0  ;3
       LDA    $78     ;3; 8A to 78 Color.  Red part of Tachometer.
       STA    COLUP1  ;3
       LDX    $AA     ;3
       LDY    #$07    ;2
LF12C: STA    WSYNC   ;3
       LDA    $9C,X   ;4
       STA    PF0     ;3
       LDA    $9E,X   ;4
       STA    PF1     ;3
       LDA    $A0,X   ;4
       STA    PF2     ;3
       LDA    $D8     ;3
       LDA    $A2,X   ;4
       STA    PF0     ;3
       LDA    $D8     ;3
       LDA    $A4,X   ;4
       STA    PF1     ;3
       LDA    $D8     ;3
       LDA    $A6,X   ;4
       STA    PF2     ;3
       DEY            ;2
       BPL    LF12C   ;2
       STA    WSYNC   ;3
       INY            ;2
       STY    PF0     ;3
       STY    PF1     ;3
       STY    PF2     ;3
       LDA    #$10    ;2
       STA    CTRLPF  ;3
       LDA    $96     ;3; Was 86.  Color of the Car, numbers.
       STA    COLUP0  ;3
       STA    COLUP1  ;3
       LDA    #$0F    ;2
       JSR    LF4E5   ;6
       LDA    #$06    ;2;  Colors:
       STA    NUSIZ0  ;3;     12 is bright blue.
       LDA    #$01    ;2;     99 is dirt colored tan.
       STA    NUSIZ1  ;3;     22 is an aqua blue.
       LDX    $AA     ;3;     33 is light green.
       LDY    $D4,X   ;4;     44 is light grey.
       STA    WSYNC   ;3;     55 is dark gold/tanish color.
       BEQ    LF181   ;2;     77 is a reddish/orange.	
       JSR    LF53B   ;6
       STA    WSYNC   ;3
       STA    WSYNC   ;3
       JMP    LF209   ;3
LF181: LDA    $89     ;3; Was 86, changed to 89. No Discernable effect.
       STA    COLUPF  ;3 
       LDX    $AA     ;3
       LDY    #$68    ;2
       LDA    $B3,X   ;4
       BEQ    LF195   ;2
       LDY    #$50    ;2
       AND    #$F0    ;2
       BEQ    LF195   ;2
       LSR            ;2
       TAY            ;2
LF195: STA    WSYNC   ;3
       TYA            ;2
       STA    $90     ;3
       LDA    $B3,X   ;4
       AND    #$0F    ;2
       ASL            ;2
       ASL            ;2
       ASL            ;2
       STA    $92     ;3
       LDA    $B5,X   ;4
       AND    #$F0    ;2
       LSR            ;2
       STA    $96     ;3
       LDA    $8D     ;3
       BEQ    LF1B6   ;2
       AND    #$F0    ;2
       LSR            ;2
       ADC    #$08    ;2
       JMP    LF1BD   ;3
LF1B6: LDA    $B5,X   ;4
       AND    #$0F    ;2
       ASL            ;2
       ASL            ;2
       ASL            ;2
LF1BD: STA    $94     ;3
       LDA    #$0C    ;2
       LDY    $CC,X   ;4
       BMI    LF1CA   ;2
       TYA            ;2
       BNE    LF1CA   ;2
       LDA    #$0B    ;2
LF1CA: ASL            ;2
       ASL            ;2
       ASL            ;2
       STA    $98     ;3
       LDA    #$07    ;2
       LDY    $B5,X   ;4
       CPY    #$AA    ;2
       BNE    LF1D9   ;2
       LDA    #$0A    ;2
LF1D9: TAX            ;2
       LDY    #$07    ;2
LF1DC: STA    WSYNC   ;3
       NOP            ;2
       LDA    ($92),Y ;5
       STA    GRP1    ;3
       LDA    ($90),Y ;5
       STA    GRP0    ;3
       LDA    ($96),Y ;5
       STA    GRP1    ;3
       LDA    ($94),Y ;5
       STA    GRP0    ;3
       STA    GRP1    ;3
       LDA    ($98),Y ;5
       STA    GRP0    ;3
       STA    GRP1    ;3
       LDA    LF56A,X ;4
       STA    ENABL   ;3
       DEX            ;2
       DEY            ;2
       BPL    LF1DC   ;2
       INY            ;2
       STY    GRP0    ;3
       STY    GRP1    ;3
       STY    GRP0    ;3
       STY    ENABL   ;3
LF209: LDA    $12     ;3; Was 88. This is the Grandstand color.
       STA    COLUPF  ;3
       INC    $AA     ;5
       LDA    $AA     ;3
       LSR            ;2
       BCC    LF217   ;2
       JMP    LF051   ;3
LF217: LDA    #$0F    ;2
       JSR    LF4E5   ;6
       LDY    #$39    ;2
       JSR    LF53B   ;6
       LDA    #$21    ;2
       STA    TIM64T  ;4
       LDA    $81     ;3
       AND    #$01    ;2
       TAX            ;2
       STX    $8F     ;3
       LDY    #$00    ;2
       LDA    $B9     ;3
       BMI    LF27F   ;2
       LDA    $D2,X   ;4
       BNE    LF27F   ;2
       LDA    $D0,X   ;4
       BEQ    LF242   ;2
       LDY    #$08    ;2
       DEC    $D0,X   ;6
       JMP    LF24E   ;3
LF242: LDA    $8D     ;3
       BEQ    LF257   ;2
       AND    #$0F    ;2
       BNE    LF257   ;2
       LDY    #$0C    ;2
       LDA    #$18    ;2
LF24E: STA    AUDV0,X ;4
       STY    AUDF0,X ;4
       STY    AUDC0,X ;4
       JMP    LF285   ;3
LF257: LDA    $CE,X   ;4
       BNE    LF27F   ;2
       LDA    $81     ;3
       AND    #$02    ;2
       BEQ    LF271   ;2
       LDY    #$09    ;2
       LDA    #$01    ;2
       STA    AUDF0,X ;4
       LDA    $C0,X   ;4
       BEQ    LF271   ;2
       LDA    $C8,X   ;4
       ORA    $CA,X   ;4
       BNE    LF27F   ;2
LF271: LDA    $A8,X   ;4
       CMP    #$20    ;2
       BCC    LF279   ;2
       LDA    #$1F    ;2
LF279: EOR    #$1F    ;2
       STA    AUDF0,X ;4
       LDY    #$03    ;2
LF27F: STY    AUDC0,X ;4
       LDA    $B1,X   ;4
       STA    AUDV0,X ;4
LF285: LDA    INTIM   ;4
       BNE    LF285   ;2
       LDY    #$82    ;2
       STY    WSYNC   ;3
       STY    VBLANK  ;3
       STY    VSYNC   ;3
       STY    WSYNC   ;3
       STY    WSYNC   ;3
       STY    WSYNC   ;3
       STA    VSYNC   ;3
       INC    $81     ;5
       BNE    LF2A5   ;2
       INC    $B9     ;5
       BNE    LF2A5   ;2
       SEC            ;2
       ROR    $B9     ;5
LF2A5: LDY    #$FF    ;2
       LDA    SWCHB   ;4
       AND    #$08    ;2
       BNE    LF2B0   ;2
       LDY    #$0F    ;2
LF2B0: LDA    #$00    ;2
       BIT    $B9     ;3
       BPL    LF2BD   ;2
       TYA            ;2
       AND    #$F7    ;2
       TAY            ;2
       LDA    $B9     ;3
       ASL            ;2
LF2BD: STA    $84     ;3
       STY    $85     ;3
       LDA    #$19    ;2
       STA    WSYNC   ;3
       STA    TIM64T  ;4
       LDA    SWCHA   ;4
       TAY            ;2
       AND    #$0F    ;2
       STA    $AE     ;3
       TYA            ;2
       LSR            ;2
       LSR            ;2
       LSR            ;2
       LSR            ;2
       STA    $AD     ;3
       LDA    $A8     ;3
       ORA    $A9     ;3
       BNE    LF2E3   ;2
       LDA    $AD,X   ;4
       CMP    #$07    ;2
       BEQ    LF2E9   ;2
LF2E3: LDA    SWCHB   ;4
       LSR            ;2
       BCS    LF2EE   ;2
LF2E9: LDX    #$B9    ;2
       JMP    LF004   ;3
LF2EE: LDY    #$00    ;2
       LSR            ;2
       BCS    LF31C   ;2
       LDA    $B0     ;3
       BEQ    LF2FB   ;2
       DEC    $B0     ;5
       BPL    LF31E   ;2
LF2FB: INC    $80     ;5
LF2FD: LDA    $80     ;3
       AND    #$01    ;2
       STA    $80     ;3
       STA    $B9     ;3
       TAY            ;2
       INY            ;2
       STY    $CC     ;3
       JSR    LF6D3   ;6
       LDA    #$0A    ;2
       STA    $CD     ;3
       LDA    #$00    ;2
       STA    $8D     ;3
       STA    $D4     ;3
       LDY    #$1E    ;2
       STY    $D2     ;3
       STY    $D3     ;3
LF31C: STY    $B0     ;3
LF31E: LDA    $8D     ;3
       BEQ    LF32E   ;2
       DEC    $8D     ;5
       BNE    LF32E   ;2
       LDX    #$05    ;2
       LSR            ;2
LF329: STA    $B3,X   ;4
       DEX            ;2
       BPL    LF329   ;2
LF32E: LDX    $8F     ;3
       LDA    $B9     ;3
       BMI    LF341   ;2
       LDA    $D2,X   ;4
       BEQ    LF344   ;2
LF338: LDY    #$01    ;2
       STY    $D2,X   ;4
       DEY            ;2
       STY    $A8,X   ;4
       STY    $C8,X   ;4
LF341: JMP    LF4A4   ;3
LF344: LDA    $8D     ;3
       BNE    LF367   ;2
       SED            ;2
       CLC            ;2
       LDA    $B7,X   ;4
       ADC    #$34    ;2
       STA    $B7,X   ;4
       LDA    $B5,X   ;4
       ADC    #$03    ;2
       STA    $B5,X   ;4
       LDA    $B3,X   ;4
       ADC    #$00    ;2
       STA    $B3,X   ;4
       CLD            ;2
       BCC    LF367   ;2
       LDA    #$99    ;2
       STA    $B3,X   ;4
       STA    $B5,X   ;4
LF365: BNE    LF338   ;2
LF367: LDA    $C0,X   ;4
       BEQ    LF3A0   ;2
       CLC            ;2
       ADC    $C2,X   ;4
       STA    $C2,X   ;4
       BCC    LF374   ;2
       INC    $BA,X   ;6
LF374: LDA    $C0,X   ;4
       ROL            ;2
       ROL            ;2
       ROL            ;2
       AND    #$03    ;2
       TAY            ;2
       LDA    LF6C8,Y ;4
       AND    $81     ;3
       BNE    LF392   ;2
       INC    $C4,X   ;6
       CLC            ;2
       LDA    $C6,X   ;4
       ADC    #$17    ;2
       CMP    #$2F    ;2
       BCC    LF390   ;2
       LDA    #$00    ;2
LF390: STA    $C6,X   ;4
LF392: LDA    $C4,X   ;4
       AND    #$03    ;2
       STA    $C4,X   ;4
       LDA    $BA,X   ;4
       CMP    #$60    ;2
       BCC    LF3A0   ;2
       BNE    LF365   ;2
LF3A0: LDA    $CE,X   ;4
       BNE    LF3CF   ;2
       LDA    $81     ;3
       LDY    $CC,X   ;4
       BPL    LF3AC   ;2
       LDY    #$00    ;2
LF3AC: AND    LF6F6,Y ;4
       BNE    LF401   ;2
       LDA    REFP1,X ;4
       BMI    LF3D1   ;2
       LDA    $CA,X   ;4
       BEQ    LF3BF   ;2
       LDA    $81     ;3
       AND    #$02    ;2
       BEQ    LF3D1   ;2
LF3BF: CLC            ;2
       LDA    $A8,X   ;4
       ADC    LF6FB,Y ;4
       STA    $A8,X   ;4
       LDA    #$0C    ;2
       STA    $B1,X   ;4
       STA    $B9     ;3
       BNE    LF3E3   ;2
LF3CF: BNE    LF43B   ;2
LF3D1: SEC            ;2
       LDA    $A8,X   ;4
       SBC    LF6FB,Y ;4
       STA    $A8,X   ;4
       DEC    $B1,X   ;6
       LDA    #$04    ;2
       CMP    $B1,X   ;4
       BCC    LF3E3   ;2
       STA    $B1,X   ;4
LF3E3: LDA    $A8,X   ;4
       BPL    LF3E9   ;2
       LDA    #$00    ;2
LF3E9: CMP    #$20    ;2
       BCC    LF3FF   ;2
       LDA    #$0F    ;2
       STA    $D0,X   ;4
       LDA    #$01    ;2
       STA    $D4,X   ;4
       LDA    #$04    ;2
       STA    $AB,X   ;4
       LDA    #$1A    ;2
       STA    $CE,X   ;4
       LDA    #$00    ;2
LF3FF: STA    $A8,X   ;4
LF401: LDA    #$00    ;2
       STA    $C8,X   ;4
       TYA            ;2
       BEQ    LF43B   ;2
       LDA    $A8,X   ;4
       CMP    #$14    ;2
LF40C: DEY            ;2
       BEQ    LF413   ;2
       ROL            ;2
       JMP    LF40C   ;3
LF413: STA    $D8     ;3
       CMP    $C0,X   ;4
       BEQ    LF43B   ;2
       BCS    LF424   ;2
       LDA    $C0,X   ;4
       BEQ    LF43B   ;2
       DEC    $C0,X   ;6
       JMP    LF43B   ;3
LF424: LDA    $D8     ;3
       SEC            ;2
       SBC    $C0,X   ;4
       INC    $C0,X   ;6
       INC    $C0,X   ;6
       CMP    #$10    ;2
       BCC    LF43B   ;2
       LDA    $CE,X   ;4
       BNE    LF43B   ;2
       LDA    #$17    ;2
       STA    $C8,X   ;4
       DEC    $A8,X   ;6
LF43B: LDA    $AD,X   ;4
       AND    #$04    ;2
       CMP    $D6,X   ;4
       STA    $D6,X   ;4
       BEQ    LF466   ;2
       CMP    #$00    ;2
       BNE    LF450   ;2
       ASL    $CC,X   ;6
       SEC            ;2
       ROR    $CC,X   ;6
       BMI    LF466   ;2
LF450: LDA    $8D     ;3
       BEQ    LF458   ;2
       LDA    #$1D    ;2
       STA    $D4,X   ;4
LF458: INC    $CC,X   ;6
       LDA    $CC,X   ;4
       AND    #$7F    ;2
       CMP    #$04    ;2
       BCC    LF464   ;2
       LDA    #$04    ;2
LF464: STA    $CC,X   ;4
LF466: LDA    $80     ;3
       LSR            ;2
       BCC    LF4A4   ;2
       LDA    $CE,X   ;4
       BNE    LF4A4   ;2
       LDA    $C0,X   ;4
       BEQ    LF4A4   ;2
       LDA    $81     ;3
       AND    #$06    ;2
       BNE    LF4A4   ;2
       LDA    $AD,X   ;4
       LSR            ;2
       BCS    LF480   ;2
       DEC    $AB,X   ;6
LF480: LSR            ;2
       BCS    LF485   ;2
       INC    $AB,X   ;6
LF485: LDA    $82     ;3
       BPL    LF48D   ;2
       INC    $AB,X   ;6
       INC    $AB,X   ;6
LF48D: DEC    $AB,X   ;6
       LDA    #$00    ;2
       STA    $CA,X   ;4
       LDY    $AB,X   ;4
       BPL    LF49A   ;2
       TAY            ;2
       INC    $CA,X   ;6
LF49A: CPY    #$08    ;2
       BCC    LF4A2   ;2
       LDY    #$08    ;2
       INC    $CA,X   ;6
LF4A2: STY    $AB,X   ;4
LF4A4: LDA    $82     ;3
       ASL            ;2
       ASL            ;2
       ASL            ;2
       EOR    $82     ;3
       ASL            ;2
       ROL    $82     ;5
       TXA            ;2
       ORA    #$0A    ;2
       TAY            ;2
       LDA    #$00    ;2
LF4B4: STA.wy $009C,Y ;5
       DEY            ;2
       DEY            ;2
       BPL    LF4B4   ;2
       LDY    $A8,X   ;4
       CPY    #$13    ;2
       BCC    LF4D1   ;2
       TYA            ;2
       SBC    #$13    ;2
       TAY            ;2
       LDA    #$FF    ;2
       STA    $9C,X   ;4
       STA    $9E,X   ;4
       STA    $A0,X   ;4
       TXA            ;2
       ORA    #$06    ;2
       TAX            ;2
LF4D1: DEY            ;2
       BMI    LF4E2   ;2
       LDA    $9C,X   ;4
       ORA    #$08    ;2
       ASL            ;2
       STA    $9C,X   ;4
       ROR    $9E,X   ;6
       ROL    $A0,X   ;6
       JMP    LF4D1   ;3
LF4E2: JMP    LF016   ;3
LF4E5: STA    $D9     ;3
       LDX    #$00    ;2
LF4E9: STA    HMCLR   ;3
LF4EB: LDY    $8C     ;3; Black Bars surrounding elapsed time.
       STY    WSYNC   ;3
       STY    COLUBK  ;3
       CLC            ;2
       ADC    #$2E    ;2
       TAY            ;2
       AND    #$0F    ;2
       STA    $D8     ;3
       TYA            ;2
       LSR            ;2
       LSR            ;2
       LSR            ;2
       LSR            ;2
       TAY            ;2
       CLC            ;2
       ADC    $D8     ;3
       CMP    #$0F    ;2
       BCC    LF509   ;2
       SBC    #$0F    ;2
       INY            ;2
LF509: EOR    #$07    ;2
       ASL            ;2
       ASL            ;2
       ASL            ;2
       ASL            ;2
       STA    HMP0,X  ;4
       STA    WSYNC   ;3
LF513: DEY            ;2
       BPL    LF513   ;2
       STA    RESP0,X ;4
       LDA    $D9     ;3
       CLC            ;2
       ADC    #$08    ;2
       INX            ;2
       CPX    #$02    ;2
       BCC    LF4EB   ;2
       STA    WSYNC   ;3
       STA    HMOVE   ;3
       LDA    $0A     ;3; Background Color. Can't be black. Changed from 89. (0A is white)
       STA    WSYNC   ;3
       STA    COLUBK  ;3
       RTS            ;6

LF52D: LDA    LF7C5,Y ;4
       STA.wy $0091,Y ;5
       DEY            ;2
       DEY            ;2
       BMI    LF53A   ;2
       JMP    LF7D2   ;3
LF53A: RTS            ;6

LF53B: LDA    #$01    ;2
       STA    NUSIZ0  ;3
       STA    WSYNC   ;3
       LDX    #$06    ;2
LF543: STA    WSYNC   ;3
       INY            ;2
       LDA    LF76E,Y ;4
       STA    GRP0    ;3
       LDA    LF775,Y ;4
       STA    GRP1    ;3
       LDA    LF77C,Y ;4
       STA    GRP0    ;3
       LDA    LF783,Y ;4
       NOP            ;2
       STA    GRP1    ;3
       STA    GRP0    ;3
       DEX            ;2
       BPL    LF543   ;2
       INX            ;2
       STX    GRP0    ;3
       STX    GRP1    ;3
       STX    GRP0    ;3
       STA    WSYNC   ;3
       RTS            ;6

LF56A: .byte $02,$02,$02,$02,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$1F
       .byte $62,$83,$81,$80,$80,$7F,$30,$F8,$C0,$00,$00,$00,$00,$00,$00,$00
       .byte $00,$00,$00,$00,$00,$01,$1F,$63,$83,$81,$80,$80,$7F,$30,$F8,$C0
       .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$1F,$62,$83
       .byte $81,$80,$80,$7F,$30,$F8,$C0,$00,$00,$00,$00,$00,$00,$00,$00,$00
       .byte $00,$70,$F8,$BD,$A6,$FA,$2E,$EC,$F8,$73,$04,$C2,$31,$0C,$03,$00
       .byte $00,$00,$00,$00,$00,$00,$00,$00,$70,$F8,$75,$AE,$FE,$AE,$74,$F8
       .byte $73,$04,$C2,$31,$0C,$03,$00,$00,$00,$00,$00,$00,$00,$00,$00,$70
       .byte $D8,$DD,$FE,$72,$FE,$DC,$D8,$73,$04,$C2,$31,$0C,$03,$00,$00,$00
       .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
       .byte $FF,$00,$0E,$0A,$0E,$00,$FF,$80,$40,$20,$FF,$00,$FF,$00,$00,$00
       .byte $00,$00,$00,$00,$00,$00,$00,$80,$60,$18,$07,$00,$18,$14,$8C,$60
       .byte $58,$C7,$00,$E0,$1C,$03,$00,$00,$00,$00,$00,$00,$00,$00,$FF,$00
       .byte $E0,$40,$C2,$01,$FC,$05,$0A,$14,$E8,$10,$E0,$00,$00,$00,$00,$00
       .byte $00,$00,$00,$00,$00,$00,$00,$00,$C0,$38,$07,$80,$80,$00,$00,$C0
       .byte $38,$17,$20,$C0,$00,$00,$00,$00,$00,$00,$00,$0F,$FF,$1F,$1F,$0F
       .byte $A7,$50,$A8,$FF,$7C,$7E,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
       .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$F3,$0F,$07,$47,$A3,$50,$F0
       .byte $7F,$78,$1C,$00,$00,$00,$00,$00,$00,$80,$F0,$C8,$C4,$82,$02,$0C
       .byte $70,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
       .byte $00,$00,$00,$00,$00,$00,$00,$80,$E0,$D8,$C4,$82,$02,$0C,$F0,$00
       .byte $00,$00,$00,$00,$00,$00
LF6C0: .byte $77,$BB,$DD,$EE
LF6C4: .byte $EE,$DD,$BB,$77
LF6C8: .byte $06,$02
LF6CA: .byte $00,$00,$88,$CC,$D8,$46
LF6D0: .byte $00,$00,$FF
LF6D3: LDA    #$9F    ;2
       STA    $8D     ;3
       LDX    #$01    ;2
LF6D9: LDA    #$01    ;2
       STA    VDELP0,X;4
       STA    $82     ;3
       LDA    #$AA    ;2
       STA    $B3,X   ;4
       STA    $B5,X   ;4
       LDA    #$04    ;2
       STA    $AB,X   ;4
       STA    $D6,X   ;4
       STA    $B1,X   ;4
       DEX            ;2
       BPL    LF6D9   ;2
       TAX            ;2
       LDA    #$23    ;2
       JMP    LF4E9   ;3
LF6F6: .byte $00,$00,$02,$06,$0E
LF6FB: .byte $03,$01,$01,$01,$01,$3C,$66,$66,$66,$66,$66,$66,$3C,$7E,$18,$18
       .byte $18,$18,$78,$38,$18,$7E,$60,$60,$3C,$06,$06,$46,$3C,$3C,$46,$06
       .byte $0C,$0C,$06,$46,$3C,$0C,$0C,$0C,$7E,$4C,$2C,$1C,$0C,$7C,$46,$06
       .byte $06,$7C,$60,$60,$7E,$3C,$66,$66,$66,$7C,$60,$62,$3C,$18,$18,$18
       .byte $18,$0C,$06,$42,$7E,$3C,$66,$66,$3C,$3C,$66,$66,$3C,$3C,$46,$06
       .byte $3E,$66,$66,$66,$3C,$00,$00,$00,$00,$00,$00,$00,$00,$C3,$C7,$CF
       .byte $DF,$FB,$F3,$E3,$C3,$7E,$C3,$C0,$C0,$C0,$C0,$C3,$7E,$7E,$C3,$C3
       .byte $CF,$C0,$C0
LF76E: .byte $C3,$7E,$F2,$4A,$4A,$72,$4A
LF775: .byte $4A,$F3,$0E,$11,$11,$11,$11
LF77C: .byte $11,$CE,$45,$45,$45,$45,$55
LF783: .byte $6D,$45,$10,$90,$50,$30,$10,$10,$10,$F8,$81,$82,$E2,$83,$82,$FA
       .byte $8F,$48,$28,$2F,$EA,$29,$28,$21,$A1,$A0,$20,$20,$20,$BE,$10,$10
       .byte $A0,$40,$40,$40,$40,$E7,$94,$94,$97,$95,$E4,$00,$BB,$AA,$BA,$2A
       .byte $2B,$80,$7F,$BD,$25,$BD,$A9,$A5,$00,$FF,$DB,$52,$D3,$52,$5B,$00
       .byte $FF
LF7C4: .byte $6E
LF7C5: .byte $F5,$B3,$F5,$00,$F6,$2E,$F6,$5C,$F6,$8A,$F6
LF7D0: LDY    #$0A    ;2
LF7D2: LDA    LF7C4,Y ;4
       CLC            ;2
       ADC    $AB,X   ;4
       CPY    #$04    ;2
       BCC    LF7F1   ;2
       CLC            ;2
       ADC    $C8,X   ;4
       CPY    #$08    ;2
       BCS    LF7F4   ;2
       STA    $D8     ;3
       LDA    $CE,X   ;4
       BEQ    LF7EC   ;2
       ADC    LF6F2,Y ;4
LF7EC: ADC    $D8     ;3
       JMP    LF7F4   ;3
LF7F1: CLC            ;2
       ADC    $C6,X   ;4
LF7F4: STA.wy $0090,Y ;5
       JMP    LF52D   ;3
LF7FA: .byte $00,$00,$00,$F0,$00,$00
