;ROL out

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
PF0     =  $0D
PF1     =  $0E
PF2     =  $0F
RESP0   =  $10
AUDC0   =  $15
AUDF0   =  $17
AUDV0   =  $19
GRP0    =  $1B
GRP1    =  $1C
ENAM0   =  $1D
ENAM1   =  $1E
ENABL   =  $1F
HMP0    =  $20
VDELBL  =  $27
HMOVE   =  $2A
HMCLR   =  $2B
CXCLR   =  $2C
CXP0FB  =  $32
CXP1FB  =  $33
CXM0FB  =  $34
CXM1FB  =  $35
CXBLPF  =  $36
INPT0   =  $38
SWCHA   =  $0280
SWCHB   =  $0282
INTIM   =  $0284
TIM64T  =  $0296

Count   =  $E2
Count2  =  $BF
Wall    =  $80
Upper   =  $BD

       ORG $F000

;must be located on a page break
Digits:
       .byte $E7 ; |XXX  XXX| $F000
       .byte $A5 ; |X X  X X| $F001
       .byte $A5 ; |X X  X X| $F002
       .byte $A5 ; |X X  X X| $F003
       .byte $E7 ; |XXX  XXX| $F004

       .byte $42 ; | X    X | $F005
       .byte $42 ; | X    X | $F006
       .byte $42 ; | X    X | $F007
       .byte $42 ; | X    X | $F008
       .byte $42 ; | X    X | $F009

       .byte $E7 ; |XXX  XXX| $F00A
       .byte $24 ; |  X  X  | $F00B
       .byte $E7 ; |XXX  XXX| $F00C
       .byte $81 ; |X      X| $F00D
       .byte $E7 ; |XXX  XXX| $F00E

       .byte $E7 ; |XXX  XXX| $F00F
       .byte $81 ; |X      X| $F010
       .byte $C3 ; |XX    XX| $F011
       .byte $81 ; |X      X| $F012
       .byte $E7 ; |XXX  XXX| $F013

       .byte $81 ; |X      X| $F014
       .byte $81 ; |X      X| $F015
       .byte $E7 ; |XXX  XXX| $F016
       .byte $A5 ; |X X  X X| $F017
       .byte $A5 ; |X X  X X| $F018

       .byte $E7 ; |XXX  XXX| $F019
       .byte $81 ; |X      X| $F01A
       .byte $E7 ; |XXX  XXX| $F01B
       .byte $24 ; |  X  X  | $F01C
       .byte $E7 ; |XXX  XXX| $F01D

       .byte $E7 ; |XXX  XXX| $F01E
       .byte $A5 ; |X X  X X| $F01F
       .byte $E7 ; |XXX  XXX| $F020
       .byte $24 ; |  X  X  | $F021
       .byte $24 ; |  X  X  | $F022

       .byte $81 ; |X      X| $F023
       .byte $81 ; |X      X| $F024
       .byte $81 ; |X      X| $F025
       .byte $81 ; |X      X| $F026
       .byte $E7 ; |XXX  XXX| $F027

       .byte $E7 ; |XXX  XXX| $F028
       .byte $A5 ; |X X  X X| $F029
       .byte $E7 ; |XXX  XXX| $F02A
       .byte $A5 ; |X X  X X| $F02B
       .byte $E7 ; |XXX  XXX| $F02C

       .byte $81 ; |X      X| $F02D
       .byte $81 ; |X      X| $F02E
       .byte $E7 ; |XXX  XXX| $F02F
       .byte $A5 ; |X X  X X| $F030
       .byte $E7 ; |XXX  XXX| $F031

       .byte $00 ; |        | $F032
       .byte $00 ; |        | $F033
       .byte $00 ; |        | $F034
       .byte $00 ; |        | $F035
       .byte $00 ; |        | $F036

       ORG $F037

LF133:
       TAX                           ;2
       LDY    $F7                    ;3
       LDA    LF7D0,Y                ;4
       STA    $BC                    ;3
       DEX                           ;2
       AND    #$0F                   ;2
       TAY                           ;2
       LDA    $80,X                  ;4
       ROL    $BC                    ;5
       BCC    LF14D                  ;2
       ASL                           ;2
       ADC    #$00                   ;2
       ASL                           ;2
       ADC    #$00                   ;2
       ASL                           ;2
       ADC    #$00                   ;2
       ASL                           ;2
       ADC    #$00                   ;2
;       JSR    Wait12                 ;6
LF14D:
       ROL    $BC                    ;5
       BCC    LF161                  ;2
LF151:
       ROL                           ;2
       STX    $BB                    ;3
       LDX    $CB                    ;3
       ROL    $A4,X                  ;6
       DEC    $CA                    ;5
       BNE    LF77E                  ;2
       INX                           ;2
       STX    $CB                    ;3
       LDX    #$08                   ;2
       STX    $CA                    ;3
LF77E:
       LDX    $BB                    ;3
;       JSR    Wait12                 ;6
       AND    #$FE                   ;2
       BCC    LF15B                  ;2
       ORA    #$01                   ;2
LF15B:
       ROL                           ;2
       DEY                           ;2
       BNE    LF151                  ;2
       BEQ    LF16F                  ;2
LF161:
       ROR                           ;2
       STX    $BB                    ;3
       LDX    $CB                    ;3
       ROL    $A4,X                  ;6
       DEC    $CA                    ;5
       BNE    LF77F                  ;2
       INX                           ;2
       STX    $CB                    ;3
       LDX    #$08                   ;2
       STX    $CA                    ;3
LF77F:
       LDX    $BB                    ;3
;       JSR    Wait12                 ;6
       AND    #$7F                   ;2
       BCC    LF16B                  ;2
       ORA    #$80                   ;2
LF16B:
       ROR                           ;2
       DEY                           ;2
       BNE    LF161                  ;2
LF16F:
       ROL    $BC                    ;5
       BCC    LF175                  ;2
       LSR                           ;2
       LSR                           ;2
LF175:
       ROL    $BC                    ;5
       BCC    LF17E                  ;2
       ROR                           ;2
       ROR                           ;2
       ROR                           ;2
       AND    #$C0                   ;2
LF17E:
       STA    $80,X                  ;4
       DEC    $C7                    ;5
       BNE    LF18A                  ;2
       LDA    #$06                   ;2
       STA    $C7                    ;3
       DEC    $F7                    ;5
LF18A:
       STX    $BC                    ;3
       LDA    $DE                    ;3
       AND    #$C0                   ;2
       ORA    $BC                    ;3
       STA    $DE                    ;3
       AND    #$3F                   ;2
       BNE    LF19C                  ;2
LF199:
       LDX    #$03                   ;2
LF19B:
       ROL    $B1                    ;5
       DEX                           ;2
       BPL    LF19B                  ;2
LF19C:
       JMP    LF1C0                  ;3

START:
       SEI                           ;2
       CLD                           ;2
       LDX    #$FF                   ;2
       TXS                           ;2
       INX                           ;2
       TXA                           ;2
LF23E:
       STA    $CC,X                  ;4
       INX                           ;2
       BNE    LF23E                  ;2
       LDX    #>Digits               ;2 <-digits
       STX    $D1                    ;3
       STX    $D7                    ;3
;       NOP                           ;2
       STX    Upper+1                ;3
       STX    $D3                    ;3
       STX    $D5                    ;3
       STX    $D9                    ;3
       LDA    #$C9                   ;2
       LDX    #$02                   ;2
       BRK                           ;7
       NOP                           ;2
       LDA    #$31                   ;2
       INX                           ;2
       BRK                           ;7
       NOP                           ;2
       LDA    #$01                   ;2
       STA    $B5                    ;3
       LDA    $B2                    ;3
       AND    #$03                   ;2
       STA    $BA                    ;3 player up
;new board
       LDX    #$05                   ;2
LF1BF11:
       LDA    #$3F                   ;2
       STA    Wall,X                 ;4
       LDA    #$FF                   ;2
       STA    Wall+24,X              ;4
       STA    Wall+18,X              ;4
       STA    Wall+6,X               ;4
       LDA    #$F0                   ;2
       STA    Wall+12,X              ;4
       LDA    #$C0                   ;2
       STA    Wall+30,X              ;4
       DEX                           ;2
       BPL    LF1BF11                ;2
       LDA    #$6C                   ;2
       STA    Count                  ;3
;       JSR    Wait12                 ;6
       LDA    #$E4                   ;2
       STA    $DE                    ;3
       LDX    #$01                   ;2
LF74D1:
       LDY    $CC,X                  ;4
       LDA    $CE,X                  ;4
       STA    $CC,X                  ;4
       STY    $CE,X                  ;4
       DEX                           ;2
       BPL    LF74D1                 ;2
       LDY    Count                  ;3
       LDA    Count2                 ;3
       STA    Count                  ;3
       STY    Count2                 ;3
       LDA    $B5                    ;3
       EOR    #$01                   ;2
       STA    $B5                    ;3
       LDA    #$08                   ;2
       STA    $CA                    ;3
       LDX    #$06                   ;2
       STX    $C7                    ;3
       DEX                           ;2
       STX    $F7                    ;3
       LDY    #$00                   ;2
       STY    $CB                    ;3
LF25E:
       LDA    #$23                   ;2
       STA    WSYNC                  ;3
       STA    TIM64T                 ;4
       LDA    $EE                    ;3
       BMI    LF28A                  ;2
;display game selection...
       LDA    $B2                    ;3
       LSR                           ;2
       LSR                           ;2 get rid of number of players bits
       CLC                           ;2
       ADC    #$01                   ;2 bump up 1
       LDY    #$0A                   ;2
       STY    $BB                    ;3
       LDY    #$00                   ;2
       BEQ    LF0F9                  ;2
LF0F5:
       INY                           ;2
       SEC                           ;2
       SBC    $BB                    ;3
LF0F9:
       CMP    $BB                    ;3
       BPL    LF0F5                  ;2
;       JSR    Wait12                 ;6
       AND    #$0F                   ;2
       STA    $BB                    ;3
       ASL                           ;2
       ASL                           ;2
       ADC    $BB                    ;3
;       JSR    Wait12                 ;6
       STA    $D4                    ;3 <-
       TYA                           ;2
       AND    #$0F                   ;2
       STA    $BB                    ;3
       ASL                           ;2
       ASL                           ;2
       ADC    $BB                    ;3
;       JSR    Wait12                 ;6
       BNE    LF284                  ;2
       LDA    #$32                   ;2
LF284:
       STA    $D2                    ;3
       LDX    $BA                    ;3
       BPL    LF2A8                  ;2
LF28A:
       LDA    $CC                    ;3
       AND    #$0F                   ;2
       STA    $BB                    ;3
       ASL                           ;2
       ASL                           ;2
       ADC    $BB                    ;3
;       JSR    Wait12                 ;6
       STA    $D0                    ;3
       LDA    $CC                    ;3
       ASL                           ;2
       ADC    #$00                   ;2
       ASL                           ;2
       ADC    #$00                   ;2
       ASL                           ;2
       ADC    #$00                   ;2
       ASL                           ;2
       ADC    #$00                   ;2
;       JSR    Wait12                 ;6
       AND    #$0F                   ;2
       STA    $BB                    ;3
       ASL                           ;2
       ASL                           ;2
       ADC    $BB                    ;3
;       JSR    Wait12                 ;6
       STA    Upper                  ;3
       LDA    $CD                    ;3
       AND    #$0F                   ;2
       STA    $BB                    ;3
       ASL                           ;2
       ASL                           ;2
       ADC    $BB                    ;3
;       JSR    Wait12                 ;6
       STA    $D4                    ;3<-
       LDA    $CD                    ;3
       ASL                           ;2
       ADC    #$00                   ;2
       ASL                           ;2
       ADC    #$00                   ;2
       ASL                           ;2
       ADC    #$00                   ;2
       ASL                           ;2
       ADC    #$00                   ;2
;       JSR    Wait12                 ;6
       AND    #$0F                   ;2
       STA    $BB                    ;3
       ASL                           ;2
       ASL                           ;2
       ADC    $BB                    ;3
;       JSR    Wait12                 ;6
       STA    $D2                    ;3
       LDA    $B9                    ;3
       AND    #$0F                   ;2
       STA    $BB                    ;3
       ASL                           ;2
       ASL                           ;2
       ADC    $BB                    ;3
;       JSR    Wait12                 ;6
       STA    $D6                    ;3
       LDX    $B5                    ;3
LF2A8:
       INX                           ;2
       TXA                           ;2
       AND    #$0F                   ;2
       STA    $BB                    ;3
       ASL                           ;2
       ASL                           ;2
       ADC    $BB                    ;3
;       JSR    Wait12                 ;6
       STA    $D8                    ;3
       LDA    #$3F                   ;2
       LDY    #$00                   ;2
       BIT    $DF                    ;3
       BEQ    LF2CF                  ;2
       BMI    LF2C3                  ;2
       BVS    LF2BF                  ;2
       LDX    $E0                    ;3
       BPL    LF2CB                  ;2
LF2BF:
       LDX    #$04                   ;2
       BPL    LF2CB                  ;2
LF2C3:
       BVS    LF2C9                  ;2
       LDX    #$08                   ;2
       BPL    LF2CB                  ;2
LF2C9:
       LDX    #$02                   ;2
LF2CB:
       DEC    $DF                    ;5
       LDY    #$0F                   ;2
LF2CF:
       STY    AUDV0                  ;3
       STX    AUDF0                  ;3
       LDA    #$0C                   ;2
       STA    AUDC0                  ;3
       LDA    $DD                    ;3
       ASL                           ;2
       ADC    #$00                   ;2
       ASL                           ;2
       ADC    #$00                   ;2
       ASL                           ;2
       ADC    #$00                   ;2
       ASL                           ;2
       ADC    #$00                   ;2
;       JSR    Wait12                 ;6
       STA    $BB                    ;3
       LDY    #$09                   ;2
       LDX    #$FF                   ;2
       LDA    SWCHB                  ;4
       AND    #$08                   ;2
       BNE    LF2ED                  ;2
       LDY    #$13                   ;2
       LDX    #$0F                   ;2
LF2ED:
       TXA                           ;2
       BIT    $B4                    ;3
       BMI    LF2F4                  ;2
       AND    #$F7                   ;2
LF2F4:
       STA    $BC                    ;3
       LDX    #$09                   ;2
LF2F8:
       CPX    #$04                   ;2
       BMI    LF310                  ;2
LF310:
       CPX    #$00                   ;2
LF31F:
       LDA    LF7AA,Y                ;4
       DEY                           ;2
       DEX                           ;2
       BPL    LF2F8                  ;2
       STA    COLUPF                 ;3
       STA    COLUP0                 ;3
       STA    COLUP1                 ;3
       LDA    #$00                   ;2
       STA.w  COLUBK                 ;4
       STX    NUSIZ0                 ;3
       STX    NUSIZ1                 ;3
LF33A:
       LDA    INTIM                  ;4
       BNE    LF33A                  ;2
       STX    WSYNC                  ;3
       STX    VBLANK                 ;3
       STX    VSYNC                  ;3
       STA    WSYNC                  ;3
       STA    WSYNC                  ;3
       STA    WSYNC                  ;3
       STA    VSYNC                  ;3
       LDA    #$22                   ;2
       STA    TIM64T                 ;4
       INC    $DA                    ;5
       BNE    LF36B                  ;2
       INC    $DB                    ;5
       BNE    LF33B                  ;2
       JMP    LF3B4                  ;3
LF33B:
       INC    $DD                    ;5
       LDA    $B4                    ;3
       EOR    $EE                    ;3
       BEQ    LF36B                  ;2
       LDA    $BA                    ;3
       BEQ    LF36B                  ;2
       LDA    #$A4                   ;2
       STA    $DE                    ;3
       LDX    #$01                   ;2
LF74Da:
       LDY    $CC,X                  ;4
       LDA    $CE,X                  ;4
       STA    $CC,X                  ;4
       STY    $CE,X                  ;4
       DEX                           ;2
       BPL    LF74Da                 ;2
       LDY    Count                  ;3
       LDA    Count2                 ;3
       STA    Count                  ;3
       STY    Count2                 ;3
       LDA    $B5                    ;3
       EOR    #$01                   ;2
       STA    $B5                    ;3
       LDA    #$08                   ;2
       STA    $CA                    ;3
       LDX    #$06                   ;2
       STX    $C7                    ;3
       DEX                           ;2
       STX    $F7                    ;3
       LDY    #$00                   ;2
       STY    $CB                    ;3
LF36B:
       LDA    SWCHB                  ;4
       AND    $03                    ;3
       BNE    LF36C                  ;2 slow
       LDA    SWCHB                  ;4
       STA    $DC                    ;3
       JMP    LF3A4                  ;3 fast if both
LF36C:
       LDA    SWCHB                  ;4
       CMP    $DC                    ;3
       BNE    LF36D                  ;2
       JMP    LF3BE                  ;2 branch if the same
LF36D:
       STA    $DC                    ;3
       LSR                           ;2
       BCC    LF36E                  ;2
       JMP    LF38F                  ;2
LF36E:
;reset pressed
       LDA    #$01                   ;2
       STA    $B5                    ;3
       LDA    $B2                    ;3
       AND    #$03                   ;2
       STA    $BA                    ;3 player up
;new board
       LDX    #$05                   ;2
LF1BF12:
       LDA    #$3F                   ;2
       STA    Wall,X                 ;4
       LDA    #$FF                   ;2
       STA    Wall+24,X              ;4
       STA    Wall+18,X              ;4
       STA    Wall+6,X               ;4
       LDA    #$F0                   ;2
       STA    Wall+12,X              ;4
       LDA    #$C0                   ;2
       STA    Wall+30,X              ;4
       DEX                           ;2
       BPL    LF1BF12                ;2
       LDA    #$6C                   ;2
       STA    Count                  ;3
;       JSR    Wait12                 ;6
       LDA    #$E4                   ;2
       STA    $DE                    ;3
       LDX    #$01                   ;2
LF74D2:
       LDY    $CC,X                  ;4
       LDA    $CE,X                  ;4
       STA    $CC,X                  ;4
       STY    $CE,X                  ;4
       DEX                           ;2
       BPL    LF74D2                 ;2
       LDY    Count                  ;3
       LDA    Count2                 ;3
       STA    Count                  ;3
       STY    Count2                 ;3
       LDA    $B5                    ;3
       EOR    #$01                   ;2
       STA    $B5                    ;3
       LDA    #$08                   ;2
       STA    $CA                    ;3
       LDX    #$06                   ;2
       STX    $C7                    ;3
       DEX                           ;2
       STX    $F7                    ;3
       LDY    #$00                   ;2
       STY    $CB                    ;3
       STX    $B9                    ;3
       DEY                           ;2
       STY    $B4                    ;3
       STY    $EE                    ;3
       INY                           ;2
       STY    $DD                    ;3
       LDX    #$03                   ;2
LF380:
       STY    $CC,X                  ;4 zero out the scores
       DEX                           ;2
       BPL    LF380                  ;2
       LDX    #$6C                   ;2 reset both brick counts
       STX    Count                  ;3
       STX    Count2                 ;3
LF385:
       STY    $DA                    ;3
       STY    $DB                    ;3
       LDX    #$00                   ;2
       STX    $E9                    ;3
       STX    $E7                    ;3
       STX    $EA                    ;3
       STX    $E8                    ;3
       STX    $E5                    ;3
       STX    $E1                    ;3
       STX    $EB                    ;3
;       JSR    Wait12                 ;6
       JMP    LF55F                  ;3
LF38F:
       LSR                           ;2 select?
       BCC    LF3A4                  ;2 branch if so
       JMP    LF3BE                  ;3
LF3A4:
       LDX    $B2                    ;3 increase game #
       INX                           ;2
       STX    $B2                    ;3
       LDA    #$01                   ;2
       STA    $B5                    ;3
       LDA    $B2                    ;3
       AND    #$03                   ;2
       STA    $BA                    ;3 player up
;new board
       LDX    #$05                   ;2
LF1BF1:
       LDA    #$3F                   ;2
       STA    Wall,X                 ;4
       LDA    #$FF                   ;2
       STA    Wall+24,X              ;4
       STA    Wall+18,X              ;4
       STA    Wall+6,X               ;4
       LDA    #$F0                   ;2
       STA    Wall+12,X              ;4
       LDA    #$C0                   ;2
       STA    Wall+30,X              ;4
       DEX                           ;2
       BPL    LF1BF1                 ;2
       LDA    #$6C                   ;2
       STA    Count                  ;3
;       JSR    Wait12                 ;6
       LDA    #$E4                   ;2
       STA    $DE                    ;3
       LDX    #$01                   ;2
LF74D:
       LDY    $CC,X                  ;4
       LDA    $CE,X                  ;4
       STA    $CC,X                  ;4
       STY    $CE,X                  ;4
       DEX                           ;2
       BPL    LF74D                  ;2
       LDY    Count                  ;3
       LDA    Count2                 ;3
       STA    Count                  ;3
       STY    Count2                 ;3
       LDA    $B5                    ;3
       EOR    #$01                   ;2
       STA    $B5                    ;3
       LDA    #$08                   ;2
       STA    $CA                    ;3
       LDX    #$06                   ;2
       STX    $C7                    ;3
       DEX                           ;2
       STX    $F7                    ;3
       LDY    #$00                   ;2
       STY    $CB                    ;3
LF3B4:
       LDY    #$00                   ;2
       STY    $EE                    ;3
LF3B8:
       LDY    #$00                   ;2
       STY    $B4                    ;3
       BNE    LF3BE                  ;2
       JMP    LF385                  ;3

LF3BE:
       LDA    $EE                    ;3
       AND    $B4                    ;3
       BMI    LF3BF                  ;2
       JMP    LF41E                  ;3

LF3BF:
       LDA    #$00                   ;2
       STA    $DD                    ;3
LF3D7:
       BIT    $B2                    ;3
       BVC    LF3D9                  ;2
       LDA    $DA                    ;3
       AND    #$0F                   ;2
       TAX                           ;2
       LDA    Rtbl,X                 ;4
       TAX                           ;2
;check wall
       LDA    Wall,X                 ;4
       ORA    Wall+6,X               ;4
       ORA    Wall+12,X              ;4
       ORA    Wall+18,X              ;4
       ORA    Wall+24,X              ;4
       ORA    Wall+30,X              ;4
       BNE    LF3D9                  ;2
;refill blocks
       LDA    #$3F                   ;2
       STA    Wall,X                 ;4
       LDA    #$C0                   ;2
       STA    Wall+30,X              ;4
       LDA    #$F0                   ;2
       STA    Wall+12,X              ;4
       LDA    #$FF                   ;2
       STA    Wall+6,X               ;4
       STA    Wall+18,X              ;4
       STA    Wall+24,X              ;4
       CLC                           ;2
       LDA    Count                  ;3
       ADC    #$12                   ;3
       STA    Count                  ;3
;       JSR    Wait12                 ;6
LF3D9:
       LDA    $E5                    ;3
       BEQ    LF3F5                  ;2
;ball missed
       CMP    #$D0                   ;2
       BCC    LF41E                  ;2
       LDX    #$00                   ;2
       STX    $E9                    ;3
       STX    $E7                    ;3
       STX    $EA                    ;3
       STX    $E8                    ;3
       STX    $E5                    ;3
       STX    $E1                    ;3
       STX    $EB                    ;3
;       JSR    Wait12                 ;6
       LDA    $BA                    ;3
       BEQ    LF3EF                  ;2
       LDA    #$A4                   ;2
       STA    $DE                    ;3
       LDX    #$01                   ;2
LF74Db:
       LDY    $CC,X                  ;4
       LDA    $CE,X                  ;4
       STA    $CC,X                  ;4
       STY    $CE,X                  ;4
       DEX                           ;2
       BPL    LF74Db                 ;2
       LDY    Count                  ;3
       LDA    Count2                 ;3
       STA    Count                  ;3
       STY    Count2                 ;3
       LDA    $B5                    ;3
       EOR    #$01                   ;2
       STA    $B5                    ;3
       LDA    #$08                   ;2
       STA    $CA                    ;3
       LDX    #$06                   ;2
       STX    $C7                    ;3
       DEX                           ;2
       STX    $F7                    ;3
       LDY    #$00                   ;2
       STY    $CB                    ;3
       LDA    $B5                    ;3
       BNE    LF41E                  ;2
LF3EF:
       DEC    $B9                    ;5
       BNE    LF41E                  ;2
       JMP    LF3B8                  ;3

LF3F5:
       LDA    SWCHA                  ;4
       EOR    #$FF                   ;2
       LDX    $B5                    ;3
       AND    LF0FE,X                ;4
       BEQ    LF41E                  ;2
       LDA    $DA                    ;3
       AND    #$03                   ;2
       TAX                           ;2
       LDA    LF788,X                ;4
       ASL                           ;2
       STA    $E3                    ;3
       LDA    #$01                   ;2
       STA    $E7                    ;3
       BCC    LF414                  ;2
       LDA    #$FF                   ;2
LF414:
       STA    $E9                    ;3
       LDA    #$70                   ;2
       STA    $E5                    ;3
       LDA    #$48                   ;2
       STA    $DF                    ;3
LF41E:
       BIT    $DE                    ;3
       BPL    LF428                  ;2
       LDA    $DE                    ;3
       AND    #$3F                   ;2
       BEQ    LF132                  ;2
       JMP    LF133                  ;2
LF132:
       LDX    $DE                    ;3
       STA    $DE                    ;3
       TXA                           ;2
       AND    #$40                   ;2
       BEQ    LF1C0                  ;2
;new board
LF1AB:
       LDX    #$05                   ;2
LF1BFF:
       LDA    #$3F                   ;2
       STA    Wall,X                 ;4
       LDA    #$FF                   ;2
       STA    Wall+24,X              ;4
       STA    Wall+18,X              ;4
       STA    Wall+6,X               ;4
       LDA    #$F0                   ;2
       STA    Wall+12,X              ;4
       LDA    #$C0                   ;2
       STA    Wall+30,X              ;4
       DEX                           ;2
       BPL    LF1BFF                 ;2
       LDA    #$6C                   ;2
       STA    Count                  ;3
LF1C0:
;       JSR    Wait12                 ;6
       JMP    LF55F                  ;3
LF428:
       LDA    $B2                    ;3
       AND    #$20                   ;2 bit 10=rotate
       BNE    LF429                  ;2
       JMP    LF430                  ;3
LF429:
       LDA    $DA                    ;3
       AND    #$0F                   ;2
       TAX                           ;2
       LDA    Rtbl,x                 ;4
       TAX                           ;2
       LDY    #01                    ;2
LLloop:
       TXA                           ;2
       AND    #$01                   ;2
       BEQ    Right                  ;2
;rotate left
       LDA    Wall+30,X              ;4
       AND    #$40                   ;2
       ORA    Wall,X                 ;4
       STA    Wall,X                 ;4
       CLC                           ;2
       ROR    Wall,X                 ;6
       ROL    Wall+6,X               ;6
       ROR    Wall+12,X              ;6
       CLC                           ;2
       LDA    Wall+12,X              ;4
       AND    #$08                   ;2
       BEQ    NoCtr3                 ;2
       SEC                           ;2
NoCtr3:
       ROR    Wall+18,X              ;6
       ROL    Wall+24,X              ;6
       ROR    Wall+30,X              ;6
       JMP    NoCtr2                 ;3
;rotate right
Right:
       CLC                           ;2
       ASL    Wall+30,X              ;6
       ROR    Wall+24,X              ;6
       ROL    Wall+18,X              ;6
       BCC    NoCtr                  ;2
       LDA    Wall+12,X              ;4
       ORA    #$08                   ;2
       STA    Wall+12,X              ;4
NoCtr:
       CLC                           ;2
       ROL    Wall+12,X              ;6
       ROR    Wall+6,X               ;6
       ROL    Wall,X                 ;6
       LDA    Wall,X                 ;4
       AND    #$40                   ;2
       BEQ    NoCtr2                 ;2
       LDA    Wall+30,X              ;4
       ORA    #$40                   ;2
       STA    Wall+30,X              ;4
NoCtr2:
       DEY                           ;2
       BPL    LLloop                 ;2
       BIT    $B2                    ;3 refill?
       BVC    LF430                  ;2
;RefillBand:
;check wall
       LDA    Wall,X                 ;4
       ORA    Wall+6,X               ;4
       ORA    Wall+12,X              ;4
       ORA    Wall+18,X              ;4
       ORA    Wall+24,X              ;4
       ORA    Wall+30,X              ;4
       BNE    LF430                  ;2
;refill blocks
       LDA    #$3F                   ;2
       STA    Wall,X                 ;4
       LDA    #$C0                   ;2
       STA    Wall+30,X              ;4
       LDA    #$F0                   ;2
       STA    Wall+12,X              ;4
       LDA    #$FF                   ;2
       STA    Wall+6,X               ;4
       STA    Wall+18,X              ;4
       STA    Wall+24,X              ;4
       CLC                           ;2
       LDA    Count                  ;3
       ADC    #$12                   ;3
       STA    Count                  ;3
LF430:
       LDA    $C8                    ;3
       BIT    CXP0FB                 ;3 p0 hit ball?
       BVS    LF434                  ;2
       LDA    $C9                    ;3
       BIT    CXP1FB                 ;3 p1 hit ball?
       BVC    LF435                  ;2

LF434:
       BIT    $EB                    ;3
       BVC    LF436                  ;2
LF435:
       JMP    LF4A4                  ;2
LF436:
       ADC    $EC                    ;3
       SEC                           ;2
       SBC    $E3                    ;3
       TAY                           ;2
       BNE    LF44F                  ;2
       LDA    #$04                   ;2
       BIT    $E9                    ;3
       BPL    LF448                  ;2
       LDA    #$FC                   ;2
LF448:
       CLC                           ;2
       ADC    $E3                    ;3
       STA    $E3                    ;3
       INY                           ;2
       TYA                           ;2
LF44F:
       EOR    $E9                    ;3
       BPL    LF456                  ;2
       LDX    #$EA                   ;2
       BNE    LF692a                 ;2
       LDX    #$E8                   ;2
LF692a:
       LDA    VSYNC,X                ;4
       EOR    #$FF                   ;2
       SEC                           ;2
       ADC    #$00                   ;2
;       JSR    Wait12                 ;6
       STA    VSYNC,X                ;4
       LDA    $FF,X                  ;4
       EOR    #$FF                   ;2
       ADC    #$00                   ;2
       STA    $FF,X                  ;4
;       JSR    Wait12                 ;6
LF456:
       TYA                           ;2
       BPL    LF45C                  ;2
       EOR    #$FF                   ;2
       SEC                           ;2
       ADC    #$00                   ;2
;       JSR    Wait12                 ;6
LF45C:
       CMP    #$09                   ;2
       BMI    LF462                  ;2
       LDA    #$08                   ;2
LF462:
       LDX    $EC                    ;3
       CPX    #$04                   ;2
       BNE    LF469                  ;2
       ASL                           ;2
LF469:
       CPX    #$06                   ;2
       BNE    LF473                  ;2
       CMP    #$04                   ;2
       BPL    LF473                  ;2
       ADC    #$00                   ;2
LF473:
       CLC                           ;2
       ADC    #$03                   ;2
       AND    #$04                   ;2
       LSR                           ;2
       STA    $ED                    ;3
       LDA    $EB                    ;3
       AND    #$3F                   ;2
       CMP    #$0C                   ;2
       BPL    LF485                  ;2
       ADC    #$01                   ;2
LF485:
       ORA    #$40                   ;2
       STA    $EB                    ;3
       LDA    $EB                    ;3
       AND    #$3C                   ;2
       CLC                           ;2
       ADC    $ED                    ;3
       TAY                           ;2
       LDA    $E9                    ;3
       PHP                           ;3
       LDA    $E7                    ;3
       PHP                           ;3
       LDX    #$02                   ;2
LF6B8:
       LDA    LF7DC,Y                ;4
       PHA                           ;3
       AND    #$03                   ;2
       STA    $E7,X                  ;4
       PLA                           ;4
       AND    #$FC                   ;2
       STA    $E8,X                  ;4
       INY                           ;2
       DEX                           ;2
       DEX                           ;2
       BPL    LF6B8                  ;2
       PLP                           ;4
       BMI    LF6D0                  ;2
       LDX    #$E8                   ;2
       LDA    VSYNC,X                ;4
       EOR    #$FF                   ;2
       SEC                           ;2
       ADC    #$00                   ;2
;       JSR    Wait12                 ;6
       STA    VSYNC,X                ;4
       LDA    $FF,X                  ;4
       EOR    #$FF                   ;2
       ADC    #$00                   ;2
       STA    $FF,X                  ;4
;       JSR    Wait12                 ;6
LF6D0:
       PLP                           ;4
       BPL    LF6D6                  ;2
       LDX    #$EA                   ;2
       BNE    LF692c                 ;2
       LDX    #$E8                   ;2
LF692c:
       LDA    VSYNC,X                ;4
       EOR    #$FF                   ;2
       SEC                           ;2
       ADC    #$00                   ;2
;       JSR    Wait12                 ;6
       STA    VSYNC,X                ;4
       LDA    $FF,X                  ;4
       EOR    #$FF                   ;2
       ADC    #$00                   ;2
       STA    $FF,X                  ;4
;       JSR    Wait12                 ;6
LF6D6:
       LDA    $EB                    ;3
       AND    #$3F                   ;2
       LDA    #$88                   ;2
       STA    $DF                    ;3
;...add new wall when hit
       LDA    Count                  ;3 check brick count
       BNE    LF4A4                  ;2 branch if anything left
       LDA    #$C0                   ;2
       STA    $DE                    ;3
LF4A4:
       BIT    CXBLPF                 ;3 ball hit playfield?
       BMI    LF4AB                  ;2
LF4A8:
       JMP    LF542                  ;3

LF4AB:
       LDA    $E5                    ;3
       CMP    #$28                   ;2
       BPL    LF4C4                  ;2
       LDA    #$80                   ;2
       STA    $E1                    ;3
       LDA    #$88                   ;2
       STA    $DF                    ;3
       LDX    #$E8                   ;2
       LDA    VSYNC,X                ;4
       EOR    #$FF                   ;2
       SEC                           ;2
       ADC    #$00                   ;2
;       JSR    Wait12                 ;6
       STA    VSYNC,X                ;4
       LDA    $FF,X                  ;4
       EOR    #$FF                   ;2
       ADC    #$00                   ;2
       STA    $FF,X                  ;4
;       JSR    Wait12                 ;6
       LDA    $EB                    ;3
       AND    #$3F                   ;2
       STA    $EB                    ;3
       BPL    LF4A8                  ;2
LF4C4:
       BIT    $EB                    ;3
       BMI    LF4A8                  ;2
       SBC    #$32                   ;2
       BCS    LF4CE                  ;2
       LDA    #$00                   ;2
LF4CE:
       LDX    #$06                   ;2
       STX    $BB                    ;3
       LDY    #$00                   ;2
       BEQ    LF0F8                  ;2
LF0F6:
       INY                           ;2
       SEC                           ;2
       SBC    $BB                    ;3
LF0F8:
       CMP    $BB                    ;3
       BPL    LF0F6                  ;2
;       JSR    Wait12                 ;6
       TYA                           ;2
       STA    $BB                    ;3
       EOR    #$FF                   ;2
       SEC                           ;2
       ADC    #$00                   ;2
;       JSR    Wait12                 ;6
       CLC                           ;2
       ADC    #$05                   ;2
       STA    $BC                    ;3
       LDA    $E3                    ;3
       SBC    #$39                   ;2 ??
       BCS    LF4E8                  ;2
       LDA    #$00                   ;2
LF4E8:
       LSR                           ;2
       LSR                           ;2
       LSR                           ;2
       CMP    #$12                   ;2
       BMI    LF4F1                  ;2
       LDA    #$11                   ;2
LF4F1:
       TAY                           ;2
       LDA    $BC                    ;3
       CLC                           ;2
       ADC    LF798,Y                ;4
       TAX                           ;2
       LDA    $80,X                  ;4
       AND    LF7BE,Y                ;4
       CMP    $80,X                  ;4
       BNE    ClearBrick             ;2
       JMP    LF542                  ;3

ClearBrick:
       STA    $80,X                  ;4 clear brick
       DEC    Count                  ;5
       LDX    $BB                    ;3
       LDA    LF792,X                ;4
       STA    $E0                    ;3
       LDA    #$06                   ;2
       STA    $DF                    ;3
       LDA    LF78C,X                ;4 get points
;score
       SED                           ;2
       CLC                           ;2
       ADC    $CD                    ;3
       STA    $CD                    ;3
       LDA    #$00                   ;2
       ADC    $CC                    ;3
       STA    $CC                    ;3
       CLD                           ;2
;       JSR    Wait12                 ;6
LF519:
       TXA                           ;2
       CMP    #$03                   ;2
       BPL    LF52A                  ;2
       LDA    #$00                   ;2
       STA    $ED                    ;3
       LDA    $EB                    ;3
       AND    #$C0                   ;2
       ORA    #$10                   ;2
       STA    $EB                    ;3
LF52A:
       LDA    $EB                    ;3
       AND    #$3C                   ;2
       CLC                           ;2
       ADC    $ED                    ;3
       TAY                           ;2
       LDA    $E9                    ;3
       PHP                           ;3
       LDA    $E7                    ;3
       PHP                           ;3
       LDX    #$02                   ;2
LF6B82:
       LDA    LF7DC,Y                ;4
       PHA                           ;3
       AND    #$03                   ;2
       STA    $E7,X                  ;4
       PLA                           ;4
       AND    #$FC                   ;2
       STA    $E8,X                  ;4
       INY                           ;2
       DEX                           ;2
       DEX                           ;2
       BPL    LF6B82                 ;2
       PLP                           ;4
       BMI    LF6D02                 ;2
       LDX    #$E8                   ;2
       LDA    VSYNC,X                ;4
       EOR    #$FF                   ;2
       SEC                           ;2
       ADC    #$00                   ;2
;       JSR    Wait12                 ;6
       STA    VSYNC,X                ;4
       LDA    $FF,X                  ;4
       EOR    #$FF                   ;2
       ADC    #$00                   ;2
       STA    $FF,X                  ;4
;       JSR    Wait12                 ;6
LF6D02:
       PLP                           ;4
       BPL    LF6D62                 ;2
       LDX    #$EA                   ;2
       BNE    LF692c2                ;2
       LDX    #$E8                   ;2
LF692c2:
       LDA    VSYNC,X                ;4
       EOR    #$FF                   ;2
       SEC                           ;2
       ADC    #$00                   ;2
;       JSR    Wait12                 ;6
       STA    VSYNC,X                ;4
       LDA    $FF,X                  ;4
       EOR    #$FF                   ;2
       ADC    #$00                   ;2
       STA    $FF,X                  ;4
;       JSR    Wait12                 ;6
LF6D62:
       LDA    $EB                    ;3
       AND    #$3F                   ;2
       STA    $BC                    ;3
       LDA    $B2                    ;3
       BPL    LF53C                  ;2 branch if not breakthru
       LDX    #$E8                   ;2
       LDA    VSYNC,X                ;4
       EOR    #$FF                   ;2
       SEC                           ;2
       ADC    #$00                   ;2
;       JSR    Wait12                 ;6
       STA    VSYNC,X                ;4
       LDA    $FF,X                  ;4
       EOR    #$FF                   ;2
       ADC    #$00                   ;2
       STA    $FF,X                  ;4
;       JSR    Wait12                 ;6
       LDA    #$00                   ;2
       BEQ    LF53E                  ;2
LF53C:
       LDA    #$80                   ;2
LF53E:
       ORA    $BC                    ;3
       STA    $EB                    ;3
LF542:
       LDA    CXM0FB                 ;3 missiles 0/1 hit ball?
       ORA    CXM1FB                 ;3
       AND    #$40                   ;2
       STA    $BC                    ;3
       BEQ    LF55F                  ;2
       LDA    $E3                    ;3
       EOR    $E9                    ;3
       BMI    LF55F                  ;2
       LDX    #$EA                   ;2
       BNE    LF692b                 ;2
       LDX    #$E8                   ;2
LF692b:
       LDA    VSYNC,X                ;4
       EOR    #$FF                   ;2
       SEC                           ;2
       ADC    #$00                   ;2
;       JSR    Wait12                 ;6
       STA    VSYNC,X                ;4
       LDA    $FF,X                  ;4
       EOR    #$FF                   ;2
       ADC    #$00                   ;2
       STA    $FF,X                  ;4
;       JSR    Wait12                 ;6
       LDA    $DF                    ;3
       AND    #$3F                   ;2
       BNE    LF55F                  ;2
       LDA    #$46                   ;2
       STA    $DF                    ;3
LF55F:
       LDX    #$00                   ;2
       LDA    SWCHB                  ;4
       ASL                           ;2
       LDY    $B5                    ;3
       BNE    LF56A                  ;2
       ASL                           ;2
LF56A:
       BCC    LF56D                  ;2
       INX                           ;2
LF56D:
       BIT    $E1                    ;3
       BPL    LF572                  ;2
       INX                           ;2
LF572:
       LDA    LF7D9,X                ;4
       STA    $EC                    ;3
       LDA    LF7D6,X                ;4
       STA    $B7                    ;3
       LDA    $BA                    ;3
       CMP    #$02                   ;2
       BMI    LF58B                  ;2
       ORA    $B5                    ;3
       ROR                           ;2
       BCC    LF58B                  ;2
       LDY    #$FF                   ;2
       BNE    LF58D                  ;2
LF58B:
       LDY    #$00                   ;2
LF58D:
       STY    $B8                    ;3
       BEQ    LF593                  ;2
       LDY    #$02                   ;2
LF593:
       LDX    #$00                   ;2
       TXA                           ;2
       ASL                           ;2
       EOR    $B6                    ;3
       AND    #$02                   ;2
       BEQ    LF6E9                  ;2
       INY                           ;2
       INY                           ;2
       STY    $BB                    ;3
       BNE    LF72D                  ;2
LF6E9:
       LDA    $C6                    ;3
       ADC    #$14                   ;2
       EOR    #$FF                   ;2
       ADC    $C8,X                  ;4
       ROR                           ;2
       CMP    LF782,Y                ;4
       BCS    LF6FA                  ;2
       LDA    LF782,Y                ;4
LF6FA:
       INY                           ;2
       CMP    LF782,Y                ;4
       BCC    LF703                  ;2
       LDA    LF782,Y                ;4
LF703:
       INY                           ;2
       STY    $BB                    ;3
       STA    $C8,X                  ;4
       BIT    $E7                    ;3
       BPL    LF72D                  ;2
       LDA    #$10                   ;2
       LDA    $B2                    ;3
       AND    #$04                   ;2
       BEQ    LF72D                  ;2 branch if not steer
       BIT    $BC                    ;3
       BVS    LF72D                  ;2
       SEC                           ;2
       LDY    $C8,X                  ;4
       LDA    $F5,X                  ;4
       STY    $F5,X                  ;4
       SBC    $C8,X                  ;4
       BEQ    LF72D                  ;2
       BPL    LF729                  ;2
       INC    $E3                    ;5
       INC    $E3                    ;5
       BNE    LF72D                  ;2
LF729:
       DEC    $E3                    ;5
       DEC    $E3                    ;5
LF72D:
       LDA    $C8,X                  ;4
       LDX    #$00                   ;2
       BRK                           ;7
       NOP                           ;2
       LDX    #$01                   ;2
       LDY    $BB                    ;3
       TXA                           ;2
       ASL                           ;2
       EOR    $B6                    ;3
       AND    #$02                   ;2
       BEQ    LF6E92                 ;2
       INY                           ;2
       INY                           ;2
       STY    $BB                    ;3
       BNE    LF72D2                 ;2
LF6E92:
       LDA    $C6                    ;3
       ADC    #$14                   ;2
       EOR    #$FF                   ;2
       ADC    $C8,X                  ;4
       ROR                           ;2
       CMP    LF782,Y                ;4
       BCS    LF6FA2                 ;2
       LDA    LF782,Y                ;4
LF6FA2:
       INY                           ;2
       CMP    LF782,Y                ;4
       BCC    LF7032                 ;2
       LDA    LF782,Y                ;4
LF7032:
       INY                           ;2
       STY    $BB                    ;3
       STA    $C8,X                  ;4
       BIT    $E7                    ;3
       BPL    LF72D2                 ;2
       LDA    #$10                   ;2
       LDA    $B2                    ;3
       AND    #$04                   ;2
       BEQ    LF72D2                 ;2 branch if not steer
       BIT    $BC                    ;3
       BVS    LF72D2                 ;2
       SEC                           ;2
       LDY    $C8,X                  ;4
       LDA    $F5,X                  ;4
       STY    $F5,X                  ;4
       SBC    $C8,X                  ;4
       BEQ    LF72D2                 ;2
       BPL    LF7292                 ;2
       INC    $E3                    ;5
       INC    $E3                    ;5
       BNE    LF72D2                 ;2
LF7292:
       DEC    $E3                    ;5
       DEC    $E3                    ;5
LF72D2:
       LDA    $C8,X                  ;4
       LDX    #$01                   ;2
       BRK                           ;7
       NOP                           ;2
       LDA    $B2                    ;3
       AND    #$08                   ;2
       BEQ    LF5C1                  ;2 branch if not catch
       LDA    SWCHA                  ;4
       LDX    $B5                    ;3
       AND    LF0FE,X                ;4
       LDY    $C8                    ;3
       BIT    CXP0FB                 ;3 p0 hit ball?
       BVS    LF5E8                  ;2
       LDY    $C9                    ;3
       BIT    CXP1FB                 ;3 p1 hit ball?
       BVS    LF5E2                  ;2
LF5C1:
       CLC                           ;2
       LDA    $E8                    ;3
       ADC    $E6                    ;3
       STA    $E6                    ;3
       LDA    $E7                    ;3
       ADC    $E5                    ;3
       STA    $E5                    ;3
       EOR    #$01                   ;2
       STA    VDELBL                 ;3
       SEC                           ;2
       LDA    $E4                    ;3
       SBC    $EA                    ;3
       STA    $E4                    ;3
       LDA    $E3                    ;3
       SBC    $E9                    ;3
       STA    $E3                    ;3
       JMP    LF5F6                  ;3
LF5E2:
       AND    #$0C                   ;2
       BNE    LF5C1                  ;2
       BMI    LF5EC                  ;2
LF5E8:
       AND    #$C0                   ;2
       BNE    LF5C1                  ;2
LF5EC:
       LDA    #$B2                   ;2
       STA    $E5                    ;3
       TYA                           ;2
       CLC                           ;2
       ADC    #$04                   ;2
       STA    $E3                    ;3
LF5F6:
       LDX    #$04                   ;2
       BRK                           ;7
       NOP                           ;2
       LDA    $B5                    ;3
       BIT    $B8                    ;3
       BPL    LF606                  ;2
       LDA    $DA                    ;3
       AND    #$02                   ;2
       ORA    $B5                    ;3
LF606:
       STA    $B6                    ;3
       LDX    #$05                   ;2
       LDA    #$02                   ;2
LF60C:
       STA    $EF,X                  ;4 ??
       DEX                           ;2
       BPL    LF60C                  ;2
LF611:
       LDA    INTIM                  ;4
       BNE    LF611                  ;2
       STA    CXCLR                  ;3
       STA    WSYNC                  ;3
       STA    HMOVE                  ;3
       STA    VBLANK                 ;3
       LDX    #$09                   ;2
LF664b:
       LDA    #$00                   ;2
       STA    PF0                    ;3
       STA    PF1                    ;3
       STA    PF2                    ;3
       INY                           ;2
       STY    WSYNC                  ;3
       DEX                           ;2
       BNE    LF664b                 ;2
;       JSR    Wait12                 ;6
       STA    HMCLR                  ;3
       STA    $C6                    ;3
       TAX                           ;2
       LDY    #$04                   ;2
LF005:
       STY    WSYNC                  ;3
       LDA    #$1A                   ;2
       STA    COLUPF                 ;3
       LDA    (Upper),Y              ;5 1st...needs to be upper digit
       AND    $EE                    ;3
       STA    PF0                    ;3
       LDA    #$00                   ;2
       STA    PF1                    ;3 2/3 clear
       LDA    ($D4),Y                ;5
       LSR                           ;2
       LSR                           ;2
       LSR                           ;2
       LSR                           ;2
       STA    PF2                    ;3 4th
       LDA    #$00                   ;2
       STA    PF0                    ;3
       LDA    #$38                   ;2
       STA    COLUPF                 ;3
       INX                           ;2
       INX                           ;2
       LDA    ($D8),Y                ;5
       AND    #$F0                   ;2
       STA    PF2                    ;3
       LDA    ($D2),Y                ;5
       AND    #$0F                   ;2
       STA    $BB                    ;3
       LDA    ($D0),Y                ;5
       ASL                           ;2
       ASL                           ;2
       ASL                           ;2
       ASL                           ;2
       AND    $EE                    ;3
       ORA    $BB                    ;3
       STA    PF1                    ;3
       LDA    #$1A                   ;2
       STA    COLUPF                 ;3
       LDA    #$00                   ;2
       STA    PF0                    ;3
       STA    PF2                    ;3
;       NOP                           ;2
       LDA    ($D6),Y                ;5
       AND    #$0F                   ;2
       AND    $EE                    ;3
       STA    PF1                    ;3
       LDA    #$86                   ;2
       STA    COLUPF                 ;3
       DEY                           ;2
       BPL    LF005                  ;2
       STY    $BB                    ;3
       TXA                           ;2
       TAY                           ;2
       LDX    $BB                    ;3
       LDX    $BB                    ;3
       LDX    #$02                   ;2
LF664a:
       LDA    #$00                   ;2
       STA    PF0                    ;3
       STA    PF1                    ;3
       STA    PF2                    ;3
       INY                           ;2
       STY    WSYNC                  ;3
       DEX                           ;2
       BNE    LF664a                 ;2
;       JSR    Wait12                 ;6
       LDA    #$06                   ;2
       STA    COLUPF                 ;3
       LDA    #$FF                   ;2
       STA    PF0                    ;3
       STA    PF1                    ;3
       STA    PF2                    ;3
       STA    ENAM0                  ;3
       STA    ENAM1                  ;3
       LDX    #$10                   ;2
       STX    CTRLPF                 ;3
       LDX    #$06                   ;2
;       NOP                           ;2
;       NOP                           ;2
;       NOP                           ;2
       STX    $BB                    ;3
       LDX    #$1F                   ;2
       TXS                           ;2
       LDX    $BB                    ;3
LF0B11:
       STA    WSYNC                  ;3
LF0B31:
       TYA                           ;2
       SEC                           ;2
       SBC    $E5                    ;3
       AND    #$FC                   ;2
       PHP                           ;3
       PLA                           ;4
       STX    $BB                    ;3
       LDX    $B6                    ;3
       LDA    INPT0,X                ;4
       BMI    LF0C51                 ;2
       STY    $C6                    ;3
LF0C51:
       LDX    $BB                    ;3
       TYA                           ;2
       AND    #$FC                   ;2
       CMP    #$B4                   ;2
       BEQ    LF0D61                 ;2
       CMP    #$94                   ;2
       BNE    NoTopPaddle1           ;2
       LDA    $B2                    ;3
       AND    #$10                   ;2 double paddle?
       BNE    LF0D61                 ;2
NoTopPaddle1:
       LDA    #$06                   ;2
       STA    WSYNC                  ;3
       STA    COLUP0                 ;3
       STA    COLUP1                 ;3
       LDA    #$00                   ;2
       STA    GRP0                   ;3
       BEQ    LF0E61                 ;2 always
;display paddle
LF0D61:
       LDA    #$36                   ;2
       STA    WSYNC                  ;3
       STA    COLUP0                 ;3
       LDA    #$A6                   ;2
       STA    COLUP1                 ;3
       LDA    $B7                    ;3
       STA    GRP0                   ;3
       AND    $B8                    ;3
LF0E61:
       STA    GRP1                   ;3
       INY                           ;2
       INY                           ;2
       DEX                           ;2
       BPL    LF0B11                 ;2
       LDX    #$FD                   ;2
       TXS                           ;2
;       NOP                           ;2
;       NOP                           ;2
;       NOP                           ;2
       LDA    #$00                   ;2
       STA    WSYNC                  ;3
       STA    PF0                    ;3
       STA    PF1                    ;3
       STA    PF2                    ;3
       LDX    #$0B                   ;2
;       NOP                           ;2
;       NOP                           ;2
;       NOP                           ;2
       STX    $BB                    ;3
       LDX    #$1F                   ;2
       TXS                           ;2
       LDX    $BB                    ;3
LF0B12:
       STA    WSYNC                  ;3
LF0B32:
       TYA                           ;2
       SEC                           ;2
       SBC    $E5                    ;3
       AND    #$FC                   ;2
       PHP                           ;3
       PLA                           ;4
       STX    $BB                    ;3
       LDX    $B6                    ;3
       LDA    INPT0,X                ;4
       BMI    LF0C52                 ;2
       STY    $C6                    ;3
LF0C52:
       LDX    $BB                    ;3
       TYA                           ;2
       AND    #$FC                   ;2
       CMP    #$B4                   ;2
       BEQ    LF0D62                 ;2
       CMP    #$94                   ;2
       BNE    NoTopPaddle2           ;2
       LDA    $B2                    ;3
       AND    #$10                   ;2 double paddle?
       BNE    LF0D62                 ;2
NoTopPaddle2:
       LDA    #$06                   ;2
       STA    WSYNC                  ;3
       STA    COLUP0                 ;3
       STA    COLUP1                 ;3
       LDA    #$00                   ;2
       STA    GRP0                   ;3
       BEQ    LF0E62                 ;2 always
;display paddle
LF0D62:
       LDA    #$36                   ;2
       STA    WSYNC                  ;3
       STA    COLUP0                 ;3
       LDA    #$A6                   ;2
       STA    COLUP1                 ;3
       LDA    $B7                    ;3
       STA    GRP0                   ;3
       AND    $B8                    ;3
LF0E62:
       STA    GRP1                   ;3
       INY                           ;2
       INY                           ;2
       DEX                           ;2
       BPL    LF0B12                 ;2
       LDX    #$FD                   ;2
       TXS                           ;2
;       NOP                           ;2
;       NOP                           ;2
;       NOP                           ;2
;       NOP                           ;2
;       NOP                           ;2
;       NOP                           ;2
LF03B3:
       LDX    #$1F                   ;2
       TXS                           ;2
       LDX    #$05                   ;2
LF0403:
       SEC                           ;2
       TYA                           ;2
       SBC    $E5                    ;3
       AND    #$FC                   ;2
       STA    WSYNC                  ;3
       PHP                           ;3
       LDA    Colors,X               ;4
       STA    COLUPF                 ;3
       LDA    $9E,X                  ;4
       STA    PF0                    ;3
       LDA    $98,X                  ;4
       STA    PF1                    ;3
       LDA    $92,X                  ;4
       STA    PF2                    ;3
       LDA    $8C,X                  ;4
       STA    PF0                    ;3
       LDA    $86,X                  ;4
       STA    PF1                    ;3
       LDA    $80,X                  ;4
       STA    PF2                    ;3
       LDA    $9E,X                  ;4
       STA    PF0                    ;3
       LDA    $98,X                  ;4
       STA    PF1                    ;3
       STX    $BB                    ;3
       LDX    $B6                    ;3
       LDA    INPT0,X                ;4
       BPL    LF0783                 ;2
       NOP                           ;2 do not remove (zipper)
       BMI    LF07A3                 ;2
LF0783:
       STY    $C6                    ;3
LF07A3:
       LDX    $BB                    ;3
       LDA    #$00                   ;2
       STA    GRP1                   ;3
       LDA    $92,X                  ;4
       STA    PF2                    ;3
       PLA                           ;4
       INY                           ;2
       INY                           ;2
       LDA    $8C,X                  ;4
       STA    PF0                    ;3
       LDA    $86,X                  ;4
       STA    PF1                    ;3
       LDA    $80,X                  ;4
       STA    PF2                    ;3
       DEC    $EF,X                  ;6
       BPL    LF0403                 ;2
       DEX                           ;2
       BPL    LF0403                 ;2
       LDX    #$32                   ;2
       LDA    #$00                   ;2
       STA    PF0                    ;3
       STA    PF1                    ;3
       STA    PF2                    ;3
       LDA    #$0C                   ;2
       STA.w  COLUPF                 ;4
LF0AA3:
       STX    $BB                    ;3
       LDX    #$1F                   ;2
       TXS                           ;2
       LDX    $BB                    ;3
LF0B13:
       STA    WSYNC                  ;3
LF0B33:
       TYA                           ;2
       SEC                           ;2
       SBC    $E5                    ;3
       AND    #$FC                   ;2
       PHP                           ;3
       PLA                           ;4
       STX    $BB                    ;3
       LDX    $B6                    ;3
       LDA    INPT0,X                ;4
       BMI    LF0C53                 ;2
       STY    $C6                    ;3
LF0C53:
       LDX    $BB                    ;3
       TYA                           ;2
       AND    #$FC                   ;2
       CMP    #$B4                   ;2
       BEQ    LF0D63                 ;2
       CMP    #$94                   ;2
       BNE    NoTopPaddle3           ;2
       LDA    $B2                    ;3
       AND    #$10                   ;2 double paddle?
       BNE    LF0D63                 ;2
NoTopPaddle3:
       LDA    #$06                   ;2
       STA    WSYNC                  ;3
       STA    COLUP0                 ;3
       STA    COLUP1                 ;3
       LDA    #$00                   ;2
       STA    GRP0                   ;3
       BEQ    LF0E63                 ;2 always
;display paddle
LF0D63:
       LDA    #$36                   ;2
       STA    WSYNC                  ;3
       STA    COLUP0                 ;3
       LDA    #$A6                   ;2
       STA    COLUP1                 ;3
       LDA    $B7                    ;3
       STA    GRP0                   ;3
       AND    $B8                    ;3
LF0E63:
       STA    GRP1                   ;3
       INY                           ;2
       INY                           ;2
       DEX                           ;2
       BPL    LF0B13                 ;2
       LDX    #$FD                   ;2
       TXS                           ;2
;       NOP                           ;2
;       NOP                           ;2
;       NOP                           ;2
       LDX    #$00                   ;2
       STX    ENAM0                  ;3
       STX    ENAM1                  ;3
       STX    ENABL                  ;3
       STX    GRP1                   ;3
       JMP    LF25E                  ;3



;       ORG $FAFC



;1106 bytes free



       ORG $FF4E



;paddle interrupt routine
INTER:
       SEC                           ;2
       SBC    #$2F                   ;2
       LDY    #$02                   ;2
LF1CB: INY                           ;2
       SBC    #$0F                   ;2
       BCS    LF1CB                  ;2
       EOR    #$FF                   ;2
       SBC    #$06                   ;2
       ASL                           ;2
       ADC    #$00                   ;2
       ASL                           ;2
       ADC    #$00                   ;2
       ASL                           ;2
       ADC    #$00                   ;2
       ASL                           ;2
       ADC    #$00                   ;2
       STY    WSYNC                  ;3
LF1D9: DEY                           ;2
       BPL    LF1D9                  ;2
       STA    RESP0,X                ;4
       STA    HMP0,X                 ;4
       RTI                           ;6

;wall speed...f=fast, m=medium, s=slow
Rtbl:
       .byte $02 ; |      X | $FF72 m1
       .byte $00 ; |        | $FF73 f1
       .byte $03 ; |      XX| $FF74 m2
       .byte $01 ; |       X| $FF75 f2
       .byte $02 ; |      X | $FF76 m1
       .byte $00 ; |        | $FF77 f1
       .byte $05 ; |     X X| $FF78 s2
       .byte $01 ; |       X| $FF79 f2
       .byte $04 ; |     X  | $FF7A s1
       .byte $00 ; |        | $FF7B f1
       .byte $03 ; |      XX| $FF7C m2
       .byte $01 ; |       X| $FF7D f2
       .byte $02 ; |      X | $FF7E m1
       .byte $00 ; |        | $FF7F f1
       .byte $03 ; |      XX| $FF80 m2
       .byte $01 ; |       X| $FF81 f2
LF782:
       .byte $37 ; |  XX XXX| $FF82
       .byte $BF ; |X XXXXXX| $FF83
       .byte $37 ; |  XX XXX| $FF84
       .byte $7E ; | XXXXXX | $FF85
       .byte $80 ; |X       | $FF86
       .byte $BF ; |X XXXXXX| $FF87
LF788:
       .byte $A0 ; |X X     | $FF88
       .byte $40 ; | X      | $FF89
       .byte $C0 ; |XX      | $FF8A
       .byte $60 ; | XX     | $FF8B
;points
LF78C:
       .byte $07 ; |     XXX| $FF8C
       .byte $07 ; |     XXX| $FF8D
       .byte $04 ; |     X  | $FF8E
       .byte $04 ; |     X  | $FF8F
       .byte $01 ; |       X| $FF90
       .byte $01 ; |       X| $FF91
LF792:
       .byte $0A ; |    X X | $FF92
       .byte $0C ; |    XX  | $FF93
       .byte $10 ; |   X    | $FF94
       .byte $12 ; |   X  X | $FF95
       .byte $16 ; |   X XX | $FF96
       .byte $1C ; |   XXX  | $FF97
LF798:
       .byte $1E ; |   XXXX | $FF98
       .byte $18 ; |   XX   | $FF99
       .byte $18 ; |   XX   | $FF9A
       .byte $18 ; |   XX   | $FF9B
       .byte $18 ; |   XX   | $FF9C
       .byte $12 ; |   X  X | $FF9D
       .byte $12 ; |   X  X | $FF9E
       .byte $12 ; |   X  X | $FF9F
       .byte $12 ; |   X  X | $FFA0
       .byte $0C ; |    XX  | $FFA1
       .byte $0C ; |    XX  | $FFA2
       .byte $06 ; |     XX | $FFA3
       .byte $06 ; |     XX | $FFA4
       .byte $06 ; |     XX | $FFA5
       .byte $06 ; |     XX | $FFA6
       .byte $00 ; |        | $FFA7
       .byte $00 ; |        | $FFA8
       .byte $00 ; |        | $FFA9
LF7AA:
       .byte $06 ; |     XX | $FFAA
       .byte $00 ; |        | $FFAB
       .byte $46 ; | X   XX | $FFAC
       .byte $B6 ; |X XX XX | $FFAD
       .byte $86 ; |X    XX | $FFAE
       .byte $C6 ; |XX   XX | $FFAF
       .byte $16 ; |   X XX | $FFB0
       .byte $26 ; |  X  XX | $FFB1
       .byte $36 ; |  XX XX | $FFB2
       .byte $46 ; | X   XX | $FFB3
       .byte $06 ; |     XX | $FFB4
       .byte $00 ; |        | $FFB5
       .byte $0C ; |    XX  | $FFB6
       .byte $0A ; |    X X | $FFB7
       .byte $08 ; |    X   | $FFB8
       .byte $06 ; |     XX | $FFB9
       .byte $04 ; |     X  | $FFBA
       .byte $08 ; |    X   | $FFBB
       .byte $06 ; |     XX | $FFBC
       .byte $04 ; |     X  | $FFBD
LF7BE:
       .byte $3F ; |  XXXXXX| $FFBE
       .byte $3F ; |  XXXXXX| $FFBF
       .byte $CF ; |XX  XXXX| $FFC0
       .byte $F3 ; |XXXX  XX| $FFC1
       .byte $FC ; |XXXXXX  | $FFC2
       .byte $FC ; |XXXXXX  | $FFC3
       .byte $F3 ; |XXXX  XX| $FFC4
       .byte $CF ; |XX  XXXX| $FFC5
       .byte $3F ; |  XXXXXX| $FFC6
       .byte $CF ; |XX  XXXX| $FFC7
       .byte $3F ; |  XXXXXX| $FFC8
       .byte $3F ; |  XXXXXX| $FFC9
       .byte $CF ; |XX  XXXX| $FFCA
       .byte $F3 ; |XXXX  XX| $FFCB
       .byte $FC ; |XXXXXX  | $FFCC
       .byte $FC ; |XXXXXX  | $FFCD
       .byte $F3 ; |XXXX  XX| $FFCE
       .byte $CF ; |XX  XXXX| $FFCF
LF7D0:
       .byte $23 ; |  X   XX| $FFD0
       .byte $44 ; | X   X  | $FFD1
       .byte $82 ; |X     X | $FFD2
       .byte $04 ; |     X  | $FFD3
       .byte $44 ; | X   X  | $FFD4
       .byte $51 ; | X X   X| $FFD5
LF7D6:
       .byte $F0 ; |XXXX    | $FFD6
       .byte $E0 ; |XXX     | $FFD7
       .byte $C0 ; |XX      | $FFD8
LF7D9:
       .byte $08 ; |    X   | $FFD9
       .byte $06 ; |     XX | $FFDA
       .byte $04 ; |     X  | $FFDB
LF7DC:
       .byte $81 ; |X      X| $FFDC
       .byte $01 ; |       X| $FFDD
       .byte $01 ; |       X| $FFDE
       .byte $81 ; |X      X| $FFDF
       .byte $81 ; |X      X| $FFE0
       .byte $02 ; |      X | $FFE1
       .byte $80 ; |X       | $FFE2
       .byte $02 ; |      X | $FFE3
       .byte $02 ; |      X | $FFE4
       .byte $01 ; |       X| $FFE5
       .byte $02 ; |      X | $FFE6
       .byte $01 ; |       X| $FFE7
       .byte $02 ; |      X | $FFE8
       .byte $02 ; |      X | $FFE9
       .byte $02 ; |      X | $FFEA
       .byte $02 ; |      X | $FFEB
       .byte $02 ; |      X | $FFEC
       .byte $63 ; | XX   XX| $FFED
       .byte $02 ; |      X | $FFEE
       .byte $63 ; | XX   XX| $FFEF
LF0FE:
       .byte $88 ; |X   X   | $FFF0
       .byte $44 ; | X   X  | $FFF1
Colors:
       .byte $36 ; |  XX XX | $FFF2 red
       .byte $26 ; |  X  XX | $FFF3 orange
       .byte $16 ; |   X XX | $FFF4 yellow
       .byte $D6 ; |XX X XX | $FFF5 green
       .byte $B6 ; |X XX XX | $FFF6 cyan
       .byte $86 ; |X    XX | $FFF7 blue

       ORG $FFF8

       .word 0,0,START,INTER
