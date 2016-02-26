; Disassembly of bankhest.bin
; Disassembled Tue Mar 30 13:25:19 2004
; Using DiStella v2.0
;
; Command Line: C:\BIN\DISTELLA.EXE -pafscbankhest.cfg bankhest.bin 
;
; bankhest.cfg contents:
;
;      ORG F000
;      CODE F000 FD2D
;      GFX FD2E FFFB

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
REFP0   =  $0B
REFP1   =  $0C
PF0     =  $0D
PF1     =  $0E
PF2     =  $0F
RESP0   =  $10
RESP1   =  $11
RESM0   =  $12
RESBL   =  $14
AUDC0   =  $15
AUDC1   =  $16
AUDF0   =  $17
AUDF1   =  $18
AUDV0   =  $19
AUDV1   =  $1A
GRP0    =  $1B
GRP1    =  $1C
ENAM0   =  $1D
ENABL   =  $1F
HMP0    =  $20
HMP1    =  $21
HMBL    =  $24
VDELP0  =  $25
VDEL01  =  $26
HMOVE   =  $2A
HMCLR   =  $2B
INPT4   =  $3C
SWCHA   =  $0280
SWCHB   =  $0282
INTIM   =  $0284
TIM64T  =  $0296

       ORG $F000

LFA52: SED                         ;2
       CLC                         ;2
       LDY    #$02                 ;2
LFA56: ADC.wy $00D8,Y              ;4
       STA.wy $00D8,Y              ;5
       LDA    #$00                 ;2
       DEY                         ;2
       BPL    LFA56                ;2
       CLD                         ;2
       RTS                         ;6

;keep at least a few bytes away from $F000
START:
       LDY    #$B5                 ;2
LF00E: LDA    #$00                 ;2
       TAX                         ;2
LF010: STA    VSYNC,X              ;4
       TXS                         ;2
       INX                         ;2
       BNE    LF010                ;2
       STY    $82                  ;3
       LDA    #$04                 ;2
       STA    $D5                  ;3
       LDA    #$01                 ;2
       STA    CTRLPF               ;3
       LDA    #$80                 ;2
       STA    PF0                  ;3
       LDA    #$FF                 ;2
       STA    PF1                  ;3
       STA    PF2                  ;3
       LDA    #$FE                 ;2
       STA    $C2                  ;3
       STA    $C4                  ;3
       LDX    #$03                 ;2
LF032: JSR    LFA75                ;6
       JSR    LFA63                ;6
       LDY    #$FF                 ;2
       STY    $A9,X                ;4
       DEX                         ;2
       BNE    LF032                ;2
       STY    $A9                  ;3
       LDA    #$FE                 ;2
       STA    $97                  ;3
       LDA    #$29                 ;2
       STA    $88                  ;3
       LDA    #$0C                 ;2
       STA    $9C                  ;3
       JMP    LFA4A                ;3
LF050: LDA    #$02                 ;2
       STA    VBLANK               ;3
       STA    WSYNC                ;3
       STA    VSYNC                ;3
       STA    WSYNC                ;3
       STA    WSYNC                ;3
       STA    WSYNC                ;3
       LDA    #$00                 ;2
       STA    VSYNC                ;3
       STA    WSYNC                ;3
       STA    HMCLR                ;3
       LDA    #$34                 ;2
       STA    TIM64T               ;4
       LDX    #$FF                 ;2
       LDA    SWCHB                ;4
       AND    #$08                 ;2
       BNE    LF076                ;2
       LDX    #$0F                 ;2
LF076: STX    $83                  ;3
       INC    $86                  ;5
       BNE    LF083                ;2
       INC    $87                  ;5
       BNE    LF083                ;2
       SEC                         ;2
       ROR    $87                  ;5
LF083: LDX    #$00                 ;2
       LDA    SWCHA                ;4
       EOR    #$FF                 ;2
       BEQ    LF08E                ;2
       STX    $87                  ;3
LF08E: STX    $84                  ;3
       LDA    $87                  ;3
       BPL    LF09C                ;2
       STA    $84                  ;3
       LDA    $83                  ;3
       AND    #$F7                 ;2
       STA    $83                  ;3
LF09C: LDA    SWCHB                ;4
       AND    #$02                 ;2
       BEQ    LF0AA                ;2
       LDA    #$00                 ;2
       STA    $85                  ;3
       JMP    LF0DA                ;3
LF0AA: LDA    $85                  ;3
       BEQ    LF0B4                ;2
       LDA    $86                  ;3
       AND    #$1F                 ;2
       BNE    LF0DA                ;2
LF0B4: LDA    #$FF                 ;2
       STA    $E0                  ;3
       STA    $85                  ;3
       LDA    #$00                 ;2
       STA    $A9                  ;3
       STA    $86                  ;3
       LDA    $81                  ;3
       CLC                         ;2
       ADC    #$04                 ;2
       AND    #$1C                 ;2
       STA    $81                  ;3
       STA    $80                  ;3
       LSR                         ;2
       LSR                         ;2
       CLC                         ;2
       ADC    #$E1                 ;2
       STA    $DA                  ;3
       LDA    #$AB                 ;2
       STA    $D8                  ;3
       LDA    #$CD                 ;2
       STA    $D9                  ;3
LF0DA: LDA    $A9                  ;3
       BNE    LF0F8                ;2
       LDA    $86                  ;3
       AND    #$80                 ;2
       BEQ    LF0F8                ;2
       LDA    #$AB                 ;2
       STA    $DB                  ;3
       LDA    #$CD                 ;2
       STA    $DC                  ;3
       LDA    $80                  ;3
       LSR                         ;2
       LSR                         ;2
       CLC                         ;2
       ADC    #$E1                 ;2
       STA    $DD                  ;3
       JMP    LF104                ;3
LF0F8: LDA    $D8                  ;3
       STA    $DB                  ;3
       LDA    $D9                  ;3
       STA    $DC                  ;3
       LDA    $DA                  ;3
       STA    $DD                  ;3
LF104: LDA    $9C                  ;3
       CMP    #$0C                 ;2
       BNE    LF158                ;2
       LDA    $88                  ;3
       CMP    #$29                 ;2
       BNE    LF158                ;2
       LDA    $A9                  ;3
       CMP    #$7F                 ;2
       BNE    LF158                ;2
       INC    $9C                  ;5
       LDA    $80                  ;3
       CMP    #$1F                 ;2
       BNE    LF122                ;2
       LDA    #$1A                 ;2
       STA    $80                  ;3
LF122: INC    $80                  ;5
       LDX    #$03                 ;2
LF126: JSR    LFA75                ;6
       LDA    #$00                 ;2
       STA    $C6,X                ;4
       STA    $CE,X                ;4
       DEX                         ;2
       BNE    LF126                ;2
       LDY    $D3                  ;3
       LDA    LFDD2,Y              ;4
       CMP    $D6                  ;3
       BPL    LF13D                ;2
       STA    $D6                  ;3
LF13D: LDA    LFDD2,Y              ;4
       BNE    LF154                ;2
       LDA    $D5                  ;3
       CMP    #$06                 ;2
       BEQ    LF14A                ;2
       INC    $D5                  ;5
LF14A: LDX    $80                  ;3
LF14C: LDA    #$93                 ;2
       JSR    LFA52                ;6
       DEX                         ;2
       BNE    LF14C                ;2
LF154: LDA    #$00                 ;2
       STA    $D3                  ;3
LF158: JSR    LFA63                ;6
       LDA    $80                  ;3
       AND    #$03                 ;2
       CLC                         ;2
       ADC    #$00                 ;2
       STA    $C1                  ;3
       ADC    #$04                 ;2
       STA    $C3                  ;3
       LDA    $80                  ;3
       AND    #$1F                 ;2
       LSR                         ;2
       TAY                         ;2
       LDA    LFE90,Y              ;4
       STA    $BA                  ;3
       INY                         ;2
       LDA    LFE90,Y              ;4
       STA    $B9                  ;3
       INY                         ;2
       LDA    LFE90,Y              ;4
       STA    $B8                  ;3
       INY                         ;2
       LDA    LFE90,Y              ;4
       STA    $B7                  ;3
       LDA    $86                  ;3
       AND    #$7F                 ;2
       CMP    #$00                 ;2
       BNE    LF1AB                ;2
       LDA    $A9                  ;3
       BEQ    LF1AB                ;2
       CMP    #$FF                 ;2
       BEQ    LF1AB                ;2
       LDA    $B7                  ;3
       SBC    #$30                 ;2
       ADC    $D7                  ;3
       STA    $D7                  ;3
       BCC    LF1AB                ;2
       INC    $D6                  ;5
       LDA    $D6                  ;3
       CMP    #$19                 ;2
       BNE    LF1AB                ;2
       LDA    #$C8                 ;2
       STA    $CE                  ;3
LF1AB: LDA    $BF                  ;3
       CMP    #$40                 ;2
       BNE    LF1E6                ;2
       LDX    #$04                 ;2
LF1B3: DEX                         ;2
       BMI    LF1E6                ;2
       LDA    #$FE                 ;2
       CMP    $97,X                ;4
       BNE    LF1B3                ;2
       LDA    $8C                  ;3
       SEC                         ;2
       ADC    #$01                 ;2
       SBC    $88,X                ;4
       BCC    LF1B3                ;2
       CMP    #$0A                 ;2
       BCS    LF1B3                ;2
       LDA    $A0                  ;3
       CLC                         ;2
       ADC    #$03                 ;2
       SEC                         ;2
       SBC    $9C,X                ;4
       BCC    LF1B3                ;2
       CMP    #$0B                 ;2
       BCS    LF1B3                ;2
       CPX    #$00                 ;2
       BNE    LF1E2                ;2
       LDA    #$C8                 ;2
       STA    $CE                  ;3
       JMP    LF1E6                ;3
LF1E2: LDA    #$FF                 ;2
       STA    $C6,X                ;4
LF1E6: LDX    #$04                 ;2
LF1E8: DEX                         ;2
       BMI    LF242                ;2
       LDA    $C6,X                ;4
       BEQ    LF1E8                ;2
       DEC    $C6,X                ;6
       BEQ    LF22A                ;2
       CMP    #$FF                 ;2
       BEQ    LF230                ;2
       CMP    #$D2                 ;2
       BNE    LF1E8                ;2
       LDA    #$FF                 ;2
       STA    $97,X                ;4
       LDA    #$00                 ;2
       STA    $AE                  ;3
       LDY    #$04                 ;2
LF205: DEY                         ;2
       BEQ    LF216                ;2
       LDA.wy $0097,Y              ;4
       CMP    #$FE                 ;2
       BNE    LF205                ;2
       INC    $AE                  ;5
       INC    $AE                  ;5
       JMP    LF205                ;3

LF216: LDA    $AE                  ;3
       TAY                         ;2
       LDA    LFEFF,Y              ;4
       SEC                         ;2
       SBC    $88,X                ;4
       STA    $93,X                ;4
       LDA    LFDC8,Y              ;4
       JSR    LFA52                ;6
       JMP    LF1E8                ;3

LF22A: JSR    LFA75                ;6
       JMP    LF1E8                ;3

LF230: LDA    #$FF                 ;2
       STA    $97,X                ;4
       LDA    #$83                 ;2
       SEC                         ;2
       SBC    $88,X                ;4
       STA    $93,X                ;4
       LDA    #$00                 ;2
       STA    $8F,X                ;4
       JMP    LF1E8                ;3

LF242: LDA    $80                  ;3
       LSR                         ;2
       TAY                         ;2
       LDA    #$FF                 ;2
       SEC                         ;2
       SBC    LFE90,Y              ;4
       STA    $AE                  ;3
       LDX    #$04                 ;2
LF250: DEX                         ;2
       BEQ    LF280                ;2
       LDA    #$FD                 ;2
       CMP    $97,X                ;4
       BNE    LF250                ;2
       LDA    $88                  ;3
       CLC                         ;2
       ADC    #$05                 ;2
       SEC                         ;2
       SBC    $88,X                ;4
       BCC    LF250                ;2
       CMP    #$0B                 ;2
       BCS    LF250                ;2
       LDA    $9C                  ;3
       CLC                         ;2
       ADC    #$04                 ;2
       SEC                         ;2
       SBC    $9C,X                ;4
       BCC    LF250                ;2
       CMP    #$0B                 ;2
       BCS    LF250                ;2
       LDA    $AE                  ;3
       STA    $CE,X                ;4
       LDA    #$1E                 ;2
       STA    $D2                  ;3
       JMP    LF250                ;3

LF280: LDX    #$04                 ;2
LF282: DEX                         ;2
       BEQ    LF2B7                ;2
       LDA    $CE,X                ;4
       BEQ    LF282                ;2
       DEC    $CE,X                ;6
       BEQ    LF2B0                ;2
       CMP    $AE                  ;3
       BNE    LF282                ;2
       LDA    #$FF                 ;2
       STA    $97,X                ;4
       LDY    $D3                  ;3
       LDA    LFEFF,Y              ;4
       SEC                         ;2
       SBC    $88,X                ;4
       STA    $93,X                ;4
       LDA    LFDC8,Y              ;4
       JSR    LFA52                ;6
       LDY    $D3                  ;3
       CPY    #$09                 ;2
       BEQ    LF282                ;2
       INC    $D3                  ;5
       JMP    LF282                ;3
LF2B0: LDA    #$FE                 ;2
       STA    $97,X                ;4
       JMP    LF282                ;3

LF2B7: LDX    #$04                 ;2
       LDA    #$FE                 ;2
       CMP    $97                  ;3
       BNE    LF2E8                ;2
LF2BF: DEX                         ;2
       BEQ    LF2E8                ;2
       LDA    #$FE                 ;2
       CMP    $97,X                ;4
       BNE    LF2BF                ;2
       LDA    $88                  ;3
       CLC                         ;2
       ADC    #$04                 ;2
       SEC                         ;2
       SBC    $88,X                ;4
       BCC    LF2BF                ;2
       CMP    #$09                 ;2
       BCS    LF2BF                ;2
       LDA    $9C                  ;3
       CLC                         ;2
       ADC    #$04                 ;2
       SEC                         ;2
       SBC    $9C,X                ;4
       BCC    LF2BF                ;2
       CMP    #$09                 ;2
       BCS    LF2BF                ;2
       LDA    #$C8                 ;2
       STA    $CE                  ;3
LF2E8: LDA    $CE                  ;3
       BEQ    LF35F                ;2
       DEC    $CE                  ;5
       BEQ    LF332                ;2
       CMP    #$C8                 ;2
       BEQ    LF31C                ;2
       CMP    #$3C                 ;2
       BNE    LF35F                ;2
       LDX    #$03                 ;2
LF2FA: LDA    $97,X                ;4
       CMP    #$FE                 ;2
       BNE    LF30E                ;2
       LDA    #$00                 ;2
       STA    $B3,X                ;4
       STA    $8F,X                ;4
       LDA    #$4C                 ;2
       STA    $9C,X                ;4
       LDA    #$61                 ;2
       STA    $88,X                ;4
LF30E: DEX                         ;2
       BNE    LF2FA                ;2
       STX    $B3                  ;3
       STX    $8F                  ;3
       LDA    #$88                 ;2
       STA    $88                  ;3
       JMP    LF35F                ;3

LF31C: STA    $E0                  ;3
       LDA    #$FF                 ;2
       STA    $A9                  ;3
       LDA    #$FD                 ;2
       STA    $97                  ;3
       INC    $88                  ;5
       LDA    #$8E                 ;2
       SEC                         ;2
       SBC    $88                  ;3
       STA    $93                  ;3
       JMP    LF35F                ;3

LF332: LDA    #$00                 ;2
       STA    $C0                  ;3
       LDA    $D5                  ;3
       BEQ    LF359                ;2
       LDA    $A9                  ;3
       BEQ    LF35F                ;2
       LDA    #$FE                 ;2
       STA    $97                  ;3
       DEC    $D5                  ;5
       LDA    #$0C                 ;2
       STA    $9C                  ;3
       LDA    #$29                 ;2
       STA    $88                  ;3
       LDA    $D6                  ;3
       CMP    #$15                 ;2
       BMI    LF35B                ;2
       LDA    #$14                 ;2
       STA    $D6                  ;3
       JMP    LF35B                ;3

LF359: STA    $A9                  ;3
LF35B: LDA    #$00                 ;2
       STA    $E0                  ;3
LF35F: LDA    #$00                 ;2
       STA    AUDV0                ;3
       LDA    $BF                  ;3
       BEQ    LF3A3                ;2
       CMP    #$40                 ;2
       BCC    LF37C                ;2
       LDA    $82                  ;3
       AND    #$06                 ;2
       STA    AUDV0                ;3
       LDA    #$08                 ;2
       STA    AUDC0                ;3
       LDA    #$04                 ;2
       STA    AUDF0                ;3
       JMP    LF3DF                ;3

LF37C: LDA    #$1F                 ;2
       STA    AUDV0                ;3
       STA    AUDF0                ;3
       LDA    $BF                  ;3
       CMP    #$20                 ;2
       BCS    LF38B                ;2
       LSR                         ;2
       STA    AUDV0                ;3
LF38B: LDA    $BF                  ;3
       SEC                         ;2
       SBC    #$30                 ;2
       BCC    LF3DF                ;2
       ASL                         ;2
       STA    $AE                  ;3
       LDA    #$1E                 ;2
       SEC                         ;2
       SBC    $AE                  ;3
       STA    AUDF0                ;3
       LDA    #$00                 ;2
       STA    $D2                  ;3
       JMP    LF3DF                ;3

LF3A3: LDA    $D2                  ;3
       BEQ    LF3BD                ;2
       DEC    $D2                  ;5
       LDA    #$05                 ;2
       STA    AUDC0                ;3
       LDA    #$0A                 ;2
       STA    AUDV0                ;3
       LDA    $82                  ;3
       AND    #$07                 ;2
       CLC                         ;2
       ADC    #$03                 ;2
       STA    AUDF0                ;3
       JMP    LF3DF                ;3

LF3BD: LDA    $A9                  ;3
       BEQ    LF3DF                ;2
       CMP    #$FF                 ;2
       BEQ    LF3DF                ;2
       LDA    #$06                 ;2
       STA    AUDF0                ;3
       LDA    #$02                 ;2
       STA    AUDC0                ;3
       LDA    #$06                 ;2
       STA    AUDV0                ;3
       LDA    $D6                  ;3
       CMP    #$16                 ;2
       BMI    LF3DF                ;2
       LDA    $86                  ;3
       AND    #$03                 ;2
       BNE    LF3DF                ;2
       STA    AUDV0                ;3
LF3DF: LDA    $CE                  ;3
       SEC                         ;2
       SBC    #$A3                 ;2
       BCC    LF3FE                ;2
       STA    $AE                  ;3
       LDA    #$08                 ;2
       STA    AUDC1                ;3
       LDA    #$1F                 ;2
       STA    AUDV1                ;3
       STA    AUDF1                ;3
       LDA    $AE                  ;3
       CMP    #$20                 ;2
       BCS    LF438                ;2
       LSR                         ;2
       STA    AUDV1                ;3
       JMP    LF438                ;3

LF3FE: LDA    #$00                 ;2
       STA    $AE                  ;3
       LDA    $A9                  ;3
       BEQ    LF434                ;2
       CMP    #$FF                 ;2
       BEQ    LF434                ;2
       LDA    #$0C                 ;2
       STA    AUDC1                ;3
       LDA    $86                  ;3
       AND    #$10                 ;2
       BNE    LF41B                ;2
       LDA    #$0C                 ;2
       STA    AUDF1                ;3
       JMP    LF41F                ;3

LF41B: LDA    #$0A                 ;2
       STA    AUDF1                ;3
LF41F: LDX    #$04                 ;2
LF421: DEX                         ;2
       BEQ    LF434                ;2
       LDA    #$FE                 ;2
       CMP    $97,X                ;4
       BNE    LF421                ;2
       LDA    $AE                  ;3
       CLC                         ;2
       ADC    #$03                 ;2
       STA    $AE                  ;3
       JMP    LF421                ;3

LF434: LDA    $AE                  ;3
       STA    AUDV1                ;3
LF438: LDX    #$FF                 ;2
       STX    $FF                  ;3
       STX    $FE                  ;3
       LDX    #$03                 ;2
       STX    $FA                  ;3
       LDY    #$02                 ;2
       STY    $FB                  ;3
       LDA    $8A                  ;3
       CMP    $8B                  ;3
       BPL    LF450                ;2
       STX    $FB                  ;3
       STY    $FA                  ;3
LF450: LDX    $FB                  ;3
       LDY    #$01                 ;2
       STY    $FC                  ;3
       LDA    $89                  ;3
       CMP    $88,X                ;4
       BPL    LF460                ;2
       STX    $FC                  ;3
       STY    $FB                  ;3
LF460: LDX    $FC                  ;3
       LDY    #$00                 ;2
       STY    $FD                  ;3
       LDA    $88                  ;3
       CMP    $88,X                ;4
       BPL    LF470                ;2
       STX    $FD                  ;3
       STY    $FC                  ;3
LF470: LDX    $FA                  ;3
       LDY    $FB                  ;3
       LDA.wy $0088,Y              ;4
       CMP    $88,X                ;4
       BPL    LF47F                ;2
       STX    $FB                  ;3
       STY    $FA                  ;3
LF47F: LDX    $FB                  ;3
       LDY    $FC                  ;3
       LDA.wy $0088,Y              ;4
       CMP    $88,X                ;4
       BPL    LF48E                ;2
       STX    $FC                  ;3
       STY    $FB                  ;3
LF48E: LDX    $FA                  ;3
       LDY    $FB                  ;3
       LDA.wy $0088,Y              ;4
       CMP    $88,X                ;4
       BPL    LF49D                ;2
       STX    $FB                  ;3
       STY    $FA                  ;3
LF49D: LDX    #$F9                 ;2
       TXS                         ;2
       LDX    $FC                  ;3
       LDY    $FA                  ;3
       LDA    $88,X                ;4
       SEC                         ;2
       SBC.wy $0088,Y              ;4
       CMP    #$0F                 ;2
       BMI    LF4E0                ;2
       LDX    $FD                  ;3
       LDY    $FB                  ;3
       LDA    $88,X                ;4
       SEC                         ;2
       SBC.wy $0088,Y              ;4
       CMP    #$0E                 ;2
       BMI    LF4BF                ;2
       JMP    LF549                ;3

LF4BF: LDA    $FB                  ;3
       BEQ    LF4CA                ;2
       LDA    $FC                  ;3
       BEQ    LF4D7                ;2
       JMP    LF51C                ;3

LF4CA: LDA    $86                  ;3
       AND    #$01                 ;2
       BNE    LF522                ;2
LF4D0: LDA    #$FF                 ;2
       STA    $FD                  ;3
       JMP    LF549                ;3

LF4D7: LDA    $86                  ;3
       AND    #$01                 ;2
       BNE    LF52D                ;2
       JMP    LF4D0                ;3

LF4E0: LDX    $FD                  ;3
       LDY    $FB                  ;3
       LDA    $88,X                ;4
       SEC                         ;2
       SBC.wy $0088,Y              ;4
       CMP    #$0E                 ;2
       BMI    LF50E                ;2
       LDA    $FA                  ;3
       BEQ    LF51C                ;2
       LDA    $FB                  ;3
       BEQ    LF4FF                ;2
       LDA    $86                  ;3
       AND    #$01                 ;2
       BNE    LF52D                ;2
       JMP    LF508                ;3

LF4FF: LDA    $86                  ;3
       AND    #$01                 ;2
       BNE    LF508                ;2
       JMP    LF522                ;3
LF508: LDX    #$FA                 ;2
       TXS                         ;2
       JMP    LF549                ;3

LF50E: LDX    $FD                  ;3
       LDY    $FA                  ;3
       LDA    $88,X                ;4
       SEC                         ;2
       SBC.wy $0088,Y              ;4
       CMP    #$0F                 ;2
       BMI    LF537                ;2
LF51C: LDA    $86                  ;3
       AND    #$01                 ;2
       BNE    LF52D                ;2
LF522: LDA    $FD                  ;3
       STA    $FC                  ;3
       LDA    #$FF                 ;2
       STA    $FD                  ;3
       JMP    LF549                ;3

LF52D: LDA    $FA                  ;3
       STA    $FB                  ;3
       LDX    #$FA                 ;2
       TXS                         ;2
       JMP    LF549                ;3

LF537: LDA    $86                  ;3
       AND    #$01                 ;2
       BNE    LF546                ;2
       LDA    #$FF                 ;2
       STA    $FC                  ;3
       STA    $FD                  ;3
       JMP    LF549                ;3

LF546: LDX    #$FB                 ;2
       TXS                         ;2
LF549: LDA    #$00                 ;2
       STA    $AE                  ;3
       LDA    $86                  ;3
       AND    #$04                 ;2
       BNE    LF557                ;2
       LDA    #$18                 ;2
       STA    $AE                  ;3
LF557: LDX    #$03                 ;2
LF559: LDA    #>Cars               ;2
       CMP    $97,X                ;4
       BNE    LF56B                ;2
       LDA    #<Cars               ;2
       CLC                         ;2
       ADC    $B3,X                ;4
       ADC    $AE                  ;3
       SEC                         ;2
       SBC    $88,X                ;4
       STA    $93,X                ;4
LF56B: DEX                         ;2
       BPL    LF559                ;2
       LDX    #$03                 ;2
LF570: LDY    $9C,X                ;4
       JSR    LFBB5                ;6
       STY    $AE                  ;3
       EOR    #$07                 ;2
       ASL                         ;2
       ASL                         ;2
       ASL                         ;2
       ASL                         ;2
       CLC                         ;2
       ADC    $AE                  ;3
       STA    $A1,X                ;4
       DEX                         ;2
       BPL    LF570                ;2
       LDA    #$24                 ;2 <-Gold (Player car)
       EOR    $84                  ;3
       AND    $83                  ;3
       STA    $CA                  ;3
       STA    COLUP1               ;3
       LDA    $D6                  ;3
       CMP    #$15                 ;2
       BMI    LF5A1                ;2
       LDA    $86                  ;3
       AND    #$08                 ;2
       BNE    LF5A1                ;2
       LDA    #$40                 ;2
       AND    $83                  ;3
       STA    $CA                  ;3
LF5A1: LDX    #$03                 ;2
LF5A3: LDA    #$FE                 ;2
       CMP    $97,X                ;4
       BNE    LF5AE                ;2
       LDA    #$82                 ;2
       JMP    LF5B0                ;3

LF5AE: LDA    #$06                 ;2
LF5B0: EOR    $84                  ;3
       AND    $83                  ;3
       STA    $CA,X                ;4
       DEX                         ;2
       BNE    LF5A3                ;2
       LDA    $C5                  ;3 <-Background
       EOR    $84                  ;3
       AND    $83                  ;3
       STA    COLUBK               ;3
LF5C1: LDA    INTIM                ;4
       BNE    LF5C1                ;2
       STA    WSYNC                ;3
       LDY    #$00                 ;2
       STY    VBLANK               ;3
       LDA    #$80                 ;2 <-Blue sky?
       EOR    $84                  ;3
       AND    $83                  ;3
       STA    COLUPF               ;3
       LDA    #$42                 ;2 <-Red fuel pump?
       EOR    $84                  ;3
       AND    $83                  ;3
       STA    $AE                  ;3
       LDA    #$03                 ;2
       STA    $8D                  ;3
       STA    RESP0                ;3
       STA    RESM0                ;3
       LDX    $D3                  ;3
       LDA    LFDD2,X              ;4
       STA    $8E                  ;3
       STA    RESP1                ;3
       LDA    $D5                  ;3
       SEC                         ;2
       SBC    #$04                 ;2
LF5F2: BCS    LF5FB                ;2
       LDA    #$30                 ;2
       STA    $8D                  ;3
       JMP    LF608                ;3

LF5FB: CMP    #$02                 ;2
       BEQ    LF604                ;2
       STA    NUSIZ1               ;3
       JMP    LF608                ;3

LF604: LDA    #$03                 ;2
       STA    NUSIZ1               ;3
LF608: STA    WSYNC                ;3
       CPY    $D6                  ;3
       BNE    LF612                ;2
       LDA    $AE                  ;3 <-player?
       STA    COLUP0               ;3
LF612: LDA    LFEA3,Y              ;4
       STA    GRP0                 ;3
       CPY    $8E                  ;3
       BNE    LF61F                ;2
       LDA    #$FF                 ;2
       STA    ENAM0                ;3
LF61F: CPY    #$0E                 ;2
       BEQ    LF63B                ;2
       TYA                         ;2
       SEC                         ;2
       SBC    $8D                  ;3
       BMI    LF62F                ;2
       TAX                         ;2
       LDA    LFEBC,X              ;4
       STA    GRP1                 ;3
LF62F: INY                         ;2
       LDA    #$00                 ;2
       STA    ENAM0                ;3
       CPY    #$19                 ;2
       BNE    LF608                ;2
       NOP                         ;2


LF64C: LDA    $80                  ;3
       STA    WSYNC                ;3
       AND    #$03                 ;2
       TAX                         ;2
       LDA    $C5                  ;3
       ORA    LFDDC,X              ;4
       EOR    $84                  ;3
       AND    $83                  ;3
       STA    COLUPF               ;3
       LDY    #$00                 ;2
       STY    GRP0                 ;3
       STY    NUSIZ1               ;3
       LDA    #>LFEE6              ;2
       STA    $A6                  ;3
       STA    $A8                  ;3
       LDA    #<LFEE6              ;2
       STA    $A5                  ;3
       STA    $A7                  ;3
       STY    $8D                  ;3
       STY    $8E                  ;3
       INY                         ;2 y=1
       BPL    LF6BA                ;2 (always jump)


LF63B: INY                         ;2
       STY    $8D                  ;3
       LDA    $D5                  ;3
       CMP    #$03                 ;2
       BPL    LF604                ;2
       AND    #$03                 ;2
       SEC                         ;2
       SBC    #$01                 ;2
       JMP    LF5F2                ;3

LF678: LDA    LFF09,X              ;4
       STA    PF0                  ;3
       CPY    $8E                  ;3
       BCS    LF687                ;2
       NOP                         ;2
       NOP                         ;2
       NOP                         ;2
       JMP    LF68B                ;3

LF687: LDA    ($A7),Y              ;5
       STA    GRP1                 ;3
LF68B: LDA    ($C1),Y              ;5
       STA    PF1                  ;3
       LDA    ($C3),Y              ;5
       STA    PF2                  ;3
       INY                         ;2
       LDX    #$FE                 ;2
       STY    $AE                  ;3
       CPY    $8E                  ;3
       BCC    LF6AD                ;2
       LDA    ($A7),Y              ;5
       BNE    LF6AF                ;2
       LDA    #<LFEE6              ;2
       SBC    $AE                  ;3
       STA    $A7                  ;3
       STX    $A8                  ;3
       LDA    #$00                 ;2
       BEQ    LF6B8                ;2 (always jump)

LF6AD: PHA                         ;3
       PLA                         ;4
LF6AF: STA    $AE                  ;3
       NOP                         ;2
       CPY    $8E                  ;3
       BCC    LF6BA                ;2
       LDA    ($A7),Y              ;5
LF6B8: STA    GRP1                 ;3
LF6BA: STA    WSYNC                ;3
       CPY    $8D                  ;3
       BCC    LF721                ;2
       LDA    ($A5),Y              ;5
       STA    GRP0                 ;3
       BNE    LF721                ;2
       PLA                         ;4
       PHA                         ;3
       PLA                         ;4
       BMI    LF71F                ;2
       TAX                         ;2
       LDA    $8F,X                ;4
       STA    REFP0                ;3
       LDA    $CA,X                ;4
       STA    COLUP0               ;3
       LDA    $88,X                ;4
       STA    $8D                  ;3
       LDA    $97,X                ;4
       STA    $A6                  ;3
       LDA    $93,X                ;4
       STA    $A5                  ;3
       LDA    $A1,X                ;4
       INY                         ;2
       STA    HMP0                 ;3
       AND    #$0F                 ;2
       TAX                         ;2
       CPY    $8E                  ;3
       BCS    LF6F2                ;2
       NOP                         ;2
       NOP                         ;2
       NOP                         ;2
       JMP    LF6F6                ;3

LF6F2: LDA    ($A7),Y              ;5
       STA    GRP1                 ;3
LF6F6: DEX                         ;2
       BPL    LF6F6                ;2
       STA    RESP0                ;3
       INY                         ;2
       CPY    $8E                  ;3
       STA    WSYNC                ;3
       STA    HMOVE                ;3
       BCS    LF70A                ;2
       NOP                         ;2
       NOP                         ;2
       NOP                         ;2
       JMP    LF70E                ;3

LF70A: LDA    ($A7),Y              ;5
       STA    GRP1                 ;3
LF70E: CPY    $8D                  ;3
       BCS    LF718                ;2
       NOP                         ;2
       NOP                         ;2
       NOP                         ;2
       JMP    LF71C                ;3

LF718: LDA    ($A5),Y              ;5
       STA    GRP0                 ;3
LF71C: JMP    LF756                ;3
LF71F: STA    $8D                  ;3
LF721: INY                         ;2
       STA    WSYNC                ;3
       CPY    $8D                  ;3
       BCC    LF72C                ;2
       LDA    ($A5),Y              ;5
       STA    GRP0                 ;3
LF72C: CPY    $8E                  ;3
       BCC    LF734                ;2
       LDA    ($A7),Y              ;5
       STA    GRP1                 ;3
LF734: INY                         ;2
       CPY    $8D                  ;3
       STA    WSYNC                ;3
       BCS    LF741                ;2
       NOP                         ;2
       NOP                         ;2
       NOP                         ;2
       JMP    LF745                ;3

LF741: LDA    ($A5),Y              ;5
       STA    GRP0                 ;3
LF745: CPY    $8E                  ;3
       BCS    LF74F                ;2
       NOP                         ;2
       NOP                         ;2
       NOP                         ;2
       JMP    LF753                ;3

LF74F: LDA    ($A7),Y              ;5
       STA    GRP1                 ;3
LF753: NOP                         ;2
       NOP                         ;2
       NOP                         ;2
LF756: NOP                         ;2
       INY                         ;2
       JSR    LR20                 ;20
       STA    HMCLR                ;3
       CPY    $8D                  ;3
       BCS    LF76B                ;2
       NOP                         ;2
       NOP                         ;2
       NOP                         ;2
       JMP    LF76F                ;3

LF76B: LDA    ($A5),Y              ;5
       STA    GRP0                 ;3
LF76F: CPY    $8C                  ;3
       BEQ    LF779                ;2
       LDA    $CA                  ;3 waste

LF776: JMP    LF77D                ;3
LF779: LDA    #$FF                 ;2
       STA    ENABL                ;3
LF77D: CPY    $8E                  ;3
       BCC    LF7D8                ;2
       LDA    ($A7),Y              ;5
       STA    GRP1                 ;3
       BNE    LF7D8                ;2
       PLA                         ;4
       BMI    LF7D6                ;2
       TAX                         ;2
       LDA    $8F,X                ;4
       STA    REFP1                ;3
       LDA    $CA,X                ;4
       STA    COLUP1               ;3
       LDA    $88,X                ;4
       STA    $8E                  ;3
       LDA    $97,X                ;4
       STA    $A8                  ;3
       LDA    $93,X                ;4
       STA    $A7                  ;3
       LDA    $A1,X                ;4
       INY                         ;2
       STA    HMP1                 ;3
       AND    #$0F                 ;2
       TAX                         ;2
       CPY    $8D                  ;3
       BCS    LF7B1                ;2
       NOP                         ;2
       NOP                         ;2
       NOP                         ;2
       JMP    LF7B5                ;3

LF7B1: LDA    ($A5),Y              ;5
       STA    GRP0                 ;3
LF7B5: DEX                         ;2
       BPL    LF7B5                ;2
       STA    RESP1                ;3
       INY                         ;2
       CPY    $8D                  ;3
       STA    WSYNC                ;3
       STA    HMOVE                ;3
       BCC    LF7C7                ;2
       LDA    ($A5),Y              ;5
       STA    GRP0                 ;3
LF7C7: CPY    $8E                  ;3
       BCC    LF7CF                ;2
       LDA    ($A7),Y              ;5
       STA    GRP1                 ;3
LF7CF: LDA    #$00                 ;2
       STA    ENABL                ;3
       BEQ    LF802                ;2 (always jump)

LF7D6: STA    $8E                  ;3
LF7D8: INY                         ;2
       STA    WSYNC                ;3
       CPY    $8D                  ;3
       BCC    LF7E3                ;2
       LDA    ($A5),Y              ;5
       STA    GRP0                 ;3
LF7E3: CPY    $8E                  ;3
       BCC    LF7EB                ;2
       LDA    ($A7),Y              ;5
       STA    GRP1                 ;3
LF7EB: INY                         ;2
       CPY    $8D                  ;3
       STA    WSYNC                ;3
       BCC    LF7F6                ;2
       LDA    ($A5),Y              ;5
       STA    GRP0                 ;3
LF7F6: CPY    $8E                  ;3
       BCC    LF7FE                ;2
       LDA    ($A7),Y              ;5
       STA    GRP1                 ;3
LF7FE: LDA    #$00                 ;2
       STA    ENABL                ;3
LF802: CPY    $8D                  ;3
       BCC    LF816                ;2
       LDA    ($A5),Y              ;5
       BNE    LF816                ;2
       STY    $AE                  ;3
       LDA    #$E6                 ;2
       SBC    $AE                  ;3
       STA    $A5                  ;3
       LDA    #$FE                 ;2
       STA    $A6                  ;3
LF816: INY                         ;2
       STA    HMCLR                ;3
       CPY    $8D                  ;3
       STA    WSYNC                ;3
       BCS    LF825                ;2
       NOP                         ;2
       NOP                         ;2
       NOP                         ;2
       JMP    LF829                ;3
LF825: LDA    ($A5),Y              ;5
       STA    GRP0                 ;3
LF829: CPY    $8E                  ;3
       BCS    LF833                ;2
       NOP                         ;2
       NOP                         ;2
       NOP                         ;2
       JMP    LF837                ;3

LF833: LDA    ($A7),Y              ;5
       STA    GRP1                 ;3
LF837: CPY    #$87                 ;2
       BEQ    LF857                ;2
       INY                         ;2
       JSR    LR16                 ;16
       TYA                         ;2
       LSR                         ;2
       LSR                         ;2
       LSR                         ;2
       TAX                         ;2
       CPY    $8D                  ;3
       BCS    LF850                ;2
       NOP                         ;2
       NOP                         ;2
       NOP                         ;2
       JMP    LF854                ;3

LF850: LDA    ($A5),Y              ;5
       STA    GRP0                 ;3
LF854: JMP    LF678                ;3
LF857: STA    WSYNC                ;3
       LDA    #$00                 ;2
       STA    GRP0                 ;3
       STA    GRP1                 ;3
       LDA    #$FF                 ;2
       STA    PF2                  ;3
       STA    PF1                  ;3
       LDA    #$06                 ;2
       STA    TIM64T               ;4
       LDX    #$FF                 ;2
       TXS                         ;2
       LDX    #$02                 ;2
       LDA    #$10                 ;2
       STA    HMP1                 ;3
       NOP                         ;2
       NOP                         ;2
       STA    RESP0                ;3
       STA    RESP1                ;3
LF879: LDA    #>GFX                ;2
       PHA                         ;3
       LDA    $DB,X                ;4
       AND    #$0F                 ;2
       TAY                         ;2
       LDA    LFDB9,Y              ;4
       PHA                         ;3
       LDA    #>GFX                ;2
       PHA                         ;3
       LDA    $DB,X                ;4
       LSR                         ;2
       LSR                         ;2
       LSR                         ;2
       LSR                         ;2
       TAY                         ;2
       LDA    LFDB9,Y              ;4
       PHA                         ;3
       DEX                         ;2
       BPL    LF879                ;2
       LDX    #$06                 ;2
LF898: PLA                         ;4
       CMP    #<Digit0             ;2
       BNE    LF8A8                ;2
       DEX                         ;2
       BEQ    LF8B0                ;2
       LDA    #<DigitSpace         ;2
       PHA                         ;3
       PLA                         ;4
       PLA                         ;4
       BNE    LF898                ;2 (always jump)

LF8A8: CPX    #$06                 ;2
       BEQ    LF8B3                ;2
       TSX                         ;2
       DEX                         ;2
       DEX                         ;2
       TXS                         ;2
LF8B0: LDA    #<Digitx             ;2
       PHA                         ;3
LF8B3: LDA    INTIM                ;4
       BNE    LF8B3                ;2
       STY    WSYNC                ;3
       STA    HMOVE                ;3
       LDA    #$24                 ;2 <-orange playfield
       EOR    $84                  ;3
       AND    $83                  ;3
       STA    COLUPF               ;3
       LDA    #$00                 ;2
       STA    REFP0                ;3
       STA    REFP1                ;3
       STA    GRP0                 ;3
       STA    GRP1                 ;3
       LDA    #$00                 ;2
       EOR    $84                  ;3
       AND    $83                  ;3
       STA    COLUP1               ;3
       STA    COLUP0               ;3
       LDA    #$06                 ;2
       STA    $DF                  ;3
       LDA    #$03                 ;2
       STA    NUSIZ0               ;3
       STA    NUSIZ1               ;3
       STA    VDELP0               ;3
       STA    VDEL01               ;3
LF8E6: LDY    $DF                  ;3
       LDA    ($FE),Y              ;5
       STA    $DE                  ;3
       STA    WSYNC                ;3
       LDA    ($FC),Y              ;5
       TAX                         ;2
       LDA    ($F4),Y              ;5
       NOP                         ;2
       STA    GRP0                 ;3
       LDA    ($F6),Y              ;5
       STA    GRP1                 ;3
       LDA    ($F8),Y              ;5
       STA    GRP0                 ;3
       LDA    ($FA),Y              ;5
       LDY    $DE                  ;3
       STA    GRP1                 ;3
       STX    GRP0                 ;3
       STY    GRP1                 ;3
       STA    GRP0                 ;3
       DEC    $DF                  ;5
       BPL    LF8E6                ;2
       STA    WSYNC                ;3
       LDA    #$00                 ;2
       STA    GRP0                 ;3
       STA    GRP1                 ;3
       STA    VDELP0               ;3
       STA    VDEL01               ;3
       LDA    #$20                 ;2
       STA    NUSIZ0               ;3
       LDA    #$06                 ;2 <-Grey (extra lives?)
       EOR    $84                  ;3
       AND    $83                  ;3
       STA    COLUP0               ;3
       LDA    #$02                 ;2
       STA    WSYNC                ;3
       STA    VBLANK               ;3
       LDA    #$2D                 ;2
       STA    TIM64T               ;4
       LDA    $E0                  ;3
       BNE    LF966                ;2
       LDX    #$00                 ;2
       STX    $9B                  ;3
       LDA    #$FE                 ;2
       CMP    $97                  ;3
       BNE    LF952                ;2
       LDA    SWCHA                ;4
       STA    $AD                  ;3
       JSR    LFB94                ;6
       LDA    $9B                  ;3
       BNE    LF952                ;2
       LDA    $A9                  ;3
       STA    $AD                  ;3
       JSR    LFB94                ;6
LF952: LDA    $A9                  ;3
       CMP    #$FF                 ;2
       BEQ    LF966                ;2
       LDX    #$03                 ;2
LF95A: LDA    #$FE                 ;2
       CMP    $97,X                ;4
       BNE    LF963                ;2
       JSR    LFAB6                ;6
LF963: DEX                         ;2
       BNE    LF95A                ;2
LF966: LDA    $C0                  ;3
       BNE    LF9B5                ;2
       LDA    $BF                  ;3
       CMP    #$30                 ;2
       BMI    LF973                ;2
       BPL    LF97C                ;2 (always jump)

LF973: LDA    INPT4                ;3
       BPL    LF983                ;2
       LDA    $BF                  ;3
       BEQ    LF97E                ;2
LF97C:
       JMP    LFA0B                ;3

LF992: LDA    $B3                  ;3
       BNE    LF9B5                ;2
       LDA    $88                  ;3
       CLC                         ;2
       ADC    #$03                 ;2
       STA    $8C                  ;3
       LDA    #$55                 ;2
       STA    $BF                  ;3
       LDA    $8F                  ;3
       BEQ    LF9AD                ;2
       LDA    $9C                  ;3
       CLC                         ;2
       ADC    #$09                 ;2
       JMP    LF9E0                ;3

LF9AD: LDA    $9C                  ;3
       SEC                         ;2
       SBC    #$08                 ;2
       JMP    LF9E0                ;3

LF9B5: LDA    $88                  ;3
       STA    $C0                  ;3
       AND    #$07                 ;2
       CMP    #$01                 ;2
       BNE    LFA2C                ;2
       LDA    #$00                 ;2
       STA    $C0                  ;3
       LDA    #$55                 ;2
       STA    $BF                  ;3
       LDA    $A9                  ;3
       CMP    #$DF                 ;2
       BEQ    LF9D5                ;2
       LDA    $88                  ;3
       CLC                         ;2
       ADC    #$0B                 ;2
       BNE    LF9DA                ;2 (always jump)

LF97E: STA    $8C                  ;3
       JMP    LFA2C                ;3
LF983: LDA    $A9                  ;3
       BEQ    LF98B                ;2
       CMP    #$FF                 ;2
       BNE    LF992                ;2
LF98B: LDA    $BF                  ;3
       BNE    LFA0B                ;2
       BEQ    LFA2C                ;3 (always jump)

LF9D5: LDA    $88                  ;3
       SEC                         ;2
       SBC    #$05                 ;2
LF9DA: STA    $8C                  ;3
       LDY    $9C                  ;3
       INY                         ;2
       TYA                         ;2
LF9E0: TAY                         ;2
       STA    $A0                  ;3
       JSR    LFBB5                ;6
       STA    WSYNC                ;3
       STA    HMCLR                ;3
       EOR    #$07                 ;2
       ASL                         ;2
       ASL                         ;2
       ASL                         ;2
       ASL                         ;2
       STA    HMBL                 ;3
LF9F2: DEY                         ;2
       BPL    LF9F2                ;2
       STA    RESBL                ;3
       LDA    $D7                  ;3
       ADC    #$80                 ;2
       STA    $D7                  ;3
       BCC    LFA0B                ;2
       INC    $D6                  ;5
       LDA    $D6                  ;3
       CMP    #$19                 ;2
       BNE    LFA0B                ;2
       LDA    #$C8                 ;2
       STA    $CE                  ;3
LFA0B: DEC    $BF                  ;5
       LDA    $BF                  ;3
       CMP    #$40                 ;2
       BCS    LFA1F                ;2
       LSR                         ;2
       AND    #$07                 ;2
       STA    $C5                  ;3
       LDA    #$01                 ;2
       STA    CTRLPF               ;3
       BNE    LFA2C                ;2 (always jump)

LFA1F: AND    #$02                 ;2
       BEQ    LFA28                ;2
       LDA    #$21                 ;2
       BNE    LFA2A                ;2 (always jump)

LFA28: LDA    #$31                 ;2
LFA2A: STA    CTRLPF               ;3
LFA2C: STA    WSYNC                ;3
       STA    HMOVE                ;3
       LDA    $A9                  ;3
       BNE    LFA38                ;2
       LDA    INPT4                ;3
       BPL    LFA3F                ;2
LFA38: LDA    SWCHB                ;4
       AND    #$01                 ;2
       BNE    LFA4A                ;2
LFA3F: LDY    $82                  ;3
       LDX    #$84                 ;2
       LDA    $81                  ;3
       STA    $80                  ;3
       JMP    LF00E                ;3
LFA4A: LDA    INTIM                ;4
       BNE    LFA4A                ;2
       JMP    LF050                ;3

LFA75: LDA    #$00                 ;2
       STA    $8F,X                ;4
       LDA    SWCHB                ;4
       AND    #$80                 ;2
       BNE    LFA8D                ;2
       LDA    $D4                  ;3
       INC    $D4                  ;5
       AND    #$0F                 ;2
       TAY                         ;2
       LDA    LFDA9,Y              ;4
       BNE    LFAA3                ;2 (always jump)

LFA8D: INC    $82                  ;5
       LDA    $82                  ;3
       AND    #$0F                 ;2
       TAY                         ;2
       LDA    LFDA9,Y              ;4
       CMP    $9D                  ;3
       BEQ    LFA8D                ;2
       CMP    $9E                  ;3
       BEQ    LFA8D                ;2
       CMP    $9F                  ;3
       BEQ    LFA8D                ;2
LFAA3: STA    $9C,X                ;4
       LDA    LFD99,Y              ;4
       STA    $88,X                ;4
       LDA    #>Target             ;2
       STA    $97,X                ;4
       LDA    #<Target             ;2
       SEC                         ;2
       SBC    $88,X                ;4
       STA    $93,X                ;4
LFB19: RTS                         ;6

LFAB6: LDA    $A9,X                ;4
       STA    $AE                  ;3
       ORA    #$AF                 ;2
       EOR    #$FF                 ;2
       BEQ    LFAC5                ;2
       ASL    $AE                  ;5
       JMP    LFAC8                ;3
LFAC5: SEC                         ;2
       ROR    $AE                  ;5
LFAC8: LDA    #$00                 ;2
       STA    $9B                  ;3
       LDA    $88,X                ;4
       CMP    $88                  ;3
       BCS    LFAD9                ;2
       LDA    #$DF                 ;2
       STA    $AD                  ;3
       BNE    LFADD                ;2 (always jump)

LFAD9: LDA    #$EF                 ;2
       STA    $AD                  ;3
LFADD: LDA    $9C,X                ;4
       CMP    $9C                  ;3
       BCC    LFAEA                ;2
       LDA    #$BF                 ;2
       AND    $AD                  ;3
       BCC    LFAEE                ;2 (always jump)

LFAEA: LDA    #$7F                 ;2
       AND    $AD                  ;3
LFAEE: STA    $AF                  ;3
       EOR    #$FF                 ;2
       AND    $AE                  ;3
       EOR    #$FF                 ;2
       STA    $AD                  ;3
       JSR    LFB1A                ;6
       LDA    $9B                  ;3
       BNE    LFB19                ;2
       LDA    $AF                  ;3
       EOR    #$F0                 ;2
       EOR    #$FF                 ;2
       AND    $AE                  ;3
       EOR    #$FF                 ;2
       STA    $AD                  ;3
       JSR    LFB1A                ;6
       LDA    $9B                  ;3
       BNE    LFB19                ;2
       LDA    $AE                  ;3
       STA    $AD                  ;3
       JMP    LFB94                ;3

LFB1A: LDA    SWCHB                ;4
       AND    #$40                 ;2
       BEQ    LFB30                ;2
       JSR    LFA63                ;6
       AND    #$01                 ;2
       BNE    LFB2C                ;2
       BEQ    LFB42                ;2 (always jump)

LFB2C: JMP    LFB6B                ;3

LFB30: CPX    #$02                 ;2
       BNE    LFB38                ;2
       BEQ    LFB6B                ;2 (always jump)

LFB38: BMI    LFB3E                ;2
       BPL    LFB42                ;2 (always jump)

LFB3E: JMP    LFB94                ;3

LFB42: LDA    $AD                  ;3
       ROL                         ;2
       BMI    LFB51                ;2
       JSR    LFC12                ;6
       LDA    $9B                  ;3
       BNE    LFB93                ;2
       BEQ    LFB5A                ;2 (always jump)

LFB51: BCS    LFB5A                ;2
       JSR    LFBCC                ;6
       LDA    $9B                  ;3
       BNE    LFB93                ;2

LFB5A: LDA    $AD                  ;3
       ROL                         ;2
       ROL                         ;2
       ROL                         ;2
       BPL    LFBB1                ;2
       BCS    LFB93                ;2
       JMP    LFC9D                ;3

LFB6B: LDA    $AD                  ;3
       ROL                         ;2
       ROL                         ;2
       ROL                         ;2
       BPL    LFB7E                ;2
       BCS    LFB85                ;2
       JSR    LFC9D                ;6
       LDA    $9B                  ;3
       BEQ    LFB85                ;2
LFB93: RTS                         ;6

LFB94: LDA    $AD                  ;3
       ROL                         ;2
       BMI    LFB9F                ;2
       JSR    LFC12                ;6
       JMP    LFBA4                ;3

LFB9F: BCS    LFBA4                ;2
       JSR    LFBCC                ;6
LFBA4: LDA    $AD                  ;3
       ROL                         ;2
       ROL                         ;2
       ROL                         ;2
       BPL    LFBB1                ;2
       BCS    LFB93                ;2
       JMP    LFC9D                ;3

LFB7E: JSR    LFC55                ;6
       LDA    $9B                  ;3
       BNE    LFB93                ;2
LFB85: LDA    $AD                  ;3
       ROL                         ;2
       BMI    LFB8E                ;2
       BPL    LFC12                ;2 (always jump)

LFB8E: BCS    LFB93                ;2
       BCC    LFBCC                ;2 (always jump)

LFBB1: JSR    LFC55                ;3

LFBB5: INY                         ;2
       TYA                         ;2
       AND    #$0F                 ;2
       STA    $AE                  ;3
       TYA                         ;2
       LSR                         ;2
       LSR                         ;2
       LSR                         ;2
       LSR                         ;2
       TAY                         ;2
       CLC                         ;2
       ADC    $AE                  ;3
       CMP    #$0F                 ;2
       BCC    LFBCB                ;2
       SBC    #$0F                 ;2
       INY                         ;2
LFBCB: RTS                         ;6

LFBCC: LDA    $9C,X                ;4
       AND    #$03                 ;2
       BNE    LFBE8                ;2
       LDA    $88,X                ;4
       AND    #$07                 ;2
       CMP    #$01                 ;2
       BNE    LFC11                ;2
       LDA    $9C,X                ;4
       LSR                         ;2
       LSR                         ;2
       ADC    #$03                 ;2
       LDY    $88,X                ;4
       DEY                         ;2
       JSR    LFCE5                ;6
       BCS    LFC11                ;2
LFBE8: LDA    #$FF                 ;2
       STA    $9B                  ;3
       LDA    #$00                 ;2
       STA    $8F,X                ;4
       LDA    $B3,X                ;4
       BNE    LFBFD                ;2
       LDA    $B7,X                ;4
       CLC                         ;2
       ADC    $BB,X                ;4
       STA    $BB,X                ;4
       BCC    LFC11                ;2
LFBFD: LDA    #$00                 ;2
       STA    $B3,X                ;4
       LDA    #$7F                 ;2
       STA    $A9,X                ;4
       INC    $9C,X                ;6
       LDA    $9C,X                ;4
       CMP    #$8D                 ;2
       BCC    LFC11                ;2
       LDA    #$0C                 ;2
       STA    $9C,X                ;4
LFC11: RTS                         ;6

LFC12: LDA    $9C,X                ;4
       AND    #$03                 ;2
       BNE    LFC2D                ;2
       LDA    $88,X                ;4
       AND    #$07                 ;2
       CMP    #$01                 ;2
       BNE    LFC54                ;2 (return)

LFC21: LDA    $9C,X                ;4
       LSR                         ;2
       LSR                         ;2
       LDY    $88,X                ;4
       DEY                         ;2
       JSR    LFCE5                ;6
       BCS    LFC54                ;2
LFC2D: LDA    #$FF                 ;2
       STA    $8F,X                ;4
       STA    $9B                  ;3
       LDA    $B3,X                ;4
       BNE    LFC40                ;2
       LDA    $B7,X                ;4
       CLC                         ;2
       ADC    $BB,X                ;4
       STA    $BB,X                ;4
       BCC    LFC54                ;2
LFC40: LDA    #$00                 ;2
       STA    $B3,X                ;4
       LDA    #$BF                 ;2
       STA    $A9,X                ;4
       DEC    $9C,X                ;6
       LDA    $9C,X                ;4
       CMP    #$0B                 ;2
       BCS    LFC54                ;2
       LDA    #$8C                 ;2
       STA    $9C,X                ;4
LFC54: RTS                         ;6

LFC55: LDA    $9C,X                ;4
       AND    #$03                 ;2
       BNE    LFC54                ;2 (return)

LFC5C: LDA    $88,X                ;4
       AND    #$07                 ;2
       CMP    #$01                 ;2
       BNE    LFC81                ;2
       LDA    $88,X                ;4
       SEC                         ;2
       SBC    #$08                 ;2
       TAY                         ;2
       DEY                         ;2
       LDA    $9C,X                ;4
       LSR                         ;2
       LSR                         ;2
       ADC    #$01                 ;2
       STA    $B0                  ;3
       JSR    LFCE5                ;6
       BCS    LFC9C                ;2
       INC    $B0                  ;5
       LDA    $B0                  ;3
       JSR    LFCE5                ;6
       BCS    LFC9C                ;2
LFC81: LDA    #$0C                 ;2
       STA    $B3,X                ;4
       LDA    $9B                  ;3
       BNE    LFC96                ;2
       LDA    #$FF                 ;2
       STA    $9B                  ;3
       LDA    $B7,X                ;4
       CLC                         ;2
       ADC    $BB,X                ;4
       STA    $BB,X                ;4
       BCC    LFC9C                ;2
LFC96: LDA    #$EF                 ;2
       STA    $A9,X                ;4
       DEC    $88,X                ;6
LFC9C: RTS                         ;6

LFC9D: LDA    $9C,X                ;4
       AND    #$03                 ;2
       BNE    LFC54                ;2 (return)

LFCA4: LDA    $88,X                ;4
       AND    #$07                 ;2
       CMP    #$01                 ;2
       BNE    LFCC9                ;2
       LDA    $88,X                ;4
       CLC                         ;2
       ADC    #$08                 ;2
       TAY                         ;2
       DEY                         ;2
       LDA    $9C,X                ;4
       LSR                         ;2
       LSR                         ;2
       ADC    #$01                 ;2
       STA    $B0                  ;3
       JSR    LFCE5                ;6
       BCS    LFCE4                ;2
       INC    $B0                  ;5
       LDA    $B0                  ;3
       JSR    LFCE5                ;6
       BCS    LFCE4                ;2
LFCC9: LDA    #$0C                 ;2
       STA    $B3,X                ;4
       LDA    $9B                  ;3
       BNE    LFCDE                ;2
       LDA    #$FF                 ;2
       STA    $9B                  ;3
       LDA    $B7,X                ;4
       CLC                         ;2
       ADC    $BB,X                ;4
       STA    $BB,X                ;4
       BCC    LFCE4                ;2
LFCDE: LDA    #$DF                 ;2
       STA    $A9,X                ;4
       INC    $88,X                ;6
LFCE4: RTS                         ;6

LFCE5: CMP    #$15                 ;2
       BMI    LFCF0                ;2
       STA    $B1                  ;3
       LDA    #$29                 ;2
       SEC                         ;2
       SBC    $B1                  ;3
LFCF0: STX    $B1                  ;3
       CMP    #$05                 ;2
       BMI    LFCFD                ;2
       CMP    #$0D                 ;2
       BPL    LFD21                ;2
       JMP    LFD14                ;3

LFCFD: STA    $B2                  ;3
       TYA                         ;2
       LSR                         ;2
       LSR                         ;2
       LSR                         ;2
       TAY                         ;2
       LDA    #$05                 ;2
       SEC                         ;2
       SBC    $B2                  ;3
       TAX                         ;2
       LDA    LFF09,Y              ;4
LFD0D: ASL                         ;2
       DEX                         ;2
       BNE    LFD0D                ;2
       LDX    $B1                  ;3
       RTS                         ;6

LFD21: SEC                         ;2
       SBC    #$0C                 ;2
       TAX                         ;2
       LDA    ($C3),Y              ;5
LFD27: LSR                         ;2
       DEX                         ;2
       BNE    LFD27                ;2
       LDX    $B1                  ;3
LR20:  NOP                         ;2
LR18:  NOP                         ;2
LR16:  NOP                         ;2
LR14:  NOP                         ;2
LR12:  RTS                         ;6

;85 bytes free
;       .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
;       .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
;       .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
;       .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
;       .byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
;       .byte $00,$00,$00,$00,$00
















;----------------- do not move anything beyond this point -------------
       ORG $FD2E

       .byte $C1 ; |XX     X| $FD2E
       .byte $E1 ; |XXX    X| $FD2F
       .byte $CD ; |XX  XX X| $FD30
       .byte $12 ; |   X  X | $FD31
       .byte $06 ; |     XX | $FD32
       .byte $DD ; |XX XXX X| $FD33
       .byte $E1 ; |XXX    X| $FD34
       .byte $FD ; |XXXXXX X| $FD35
       .byte $E1 ; |XXX    X| $FD36
       .byte $DD ; |XX XXX X| $FD37
       .byte $36 ; |  XX XX | $FD38
       .byte $00 ; |        | $FD39
       .byte $0C ; |    XX  | $FD3A
       .byte $DD ; |XX XXX X| $FD3B
       .byte $46 ; | X   XX | $FD3C
       .byte $0A ; |    X X | $FD3D
       .byte $DD ; |XX XXX X| $FD3E
       .byte $77 ; | XXX XXX| $FD3F
       .byte $0A ; |    X X | $FD40
       .byte $DD ; |XX XXX X| $FD41
       .byte $70 ; | XXX    | $FD42
       .byte $0B ; |    X XX| $FD43
       .byte $DD ; |XX XXX X| $FD44
       .byte $7E ; | XXXXXX | $FD45
       .byte $07 ; |     XXX| $FD46
       .byte $DD ; |XX XXX X| $FD47
       .byte $77 ; | XXX XXX| $FD48
       .byte $06 ; |     XX | $FD49
       .byte $3A ; |  XXX X | $FD4A
       .byte $86 ; |X    XX | $FD4B
       .byte $B6 ; |X XX XX | $FD4C
       .byte $DD ; |XX XXX X| $FD4D
       .byte $77 ; | XXX XXX| $FD4E
       .byte $07 ; |     XXX| $FD4F
       .byte $DD ; |XX XXX X| $FD50
       .byte $36 ; |  XX XX | $FD51
       .byte $08 ; |    X   | $FD52
       .byte $07 ; |     XXX| $FD53
       .byte $DD ; |XX XXX X| $FD54
       .byte $E5 ; |XXX  X X| $FD55
       .byte $E1 ; |XXX    X| $FD56
       .byte $FD ; |XXXXXX X| $FD57
       .byte $46 ; | X   XX | $FD58
       .byte $04 ; |     X  | $FD59
       .byte $0E ; |    XXX | $FD5A
       .byte $06 ; |     XX | $FD5B
       .byte $CD ; |XX  XX X| $FD5C
       .byte $5B ; | X XX XX| $FD5D
       .byte $02 ; |      X | $FD5E
       .byte $C3 ; |XX    XX| $FD5F
       .byte $6F ; | XX XXXX| $FD60
       .byte $1B ; |   XX XX| $FD61
       .byte $DD ; |XX XXX X| $FD62
       .byte $56 ; | X X XX | $FD63
       .byte $07 ; |     XXX| $FD64
       .byte $DD ; |XX XXX X| $FD65
       .byte $5E ; | X XXXX | $FD66
       .byte $0A ; |    X X | $FD67
       .byte $21 ; |  X    X| $FD68
       .byte $40 ; | X      | $FD69
       .byte $B6 ; |X XX XX | $FD6A
       .byte $06 ; |     XX | $FD6B
       .byte $20 ; |  X     | $FD6C
       .byte $4E ; | X  XXX | $FD6D
       .byte $23 ; |  X   XX| $FD6E
       .byte $7E ; | XXXXXX | $FD6F
       .byte $23 ; |  X   XX| $FD70
       .byte $BA ; |X XXX X | $FD71
       .byte $20 ; |  X     | $FD72
       .byte $04 ; |     X  | $FD73
       .byte $79 ; | XXXX  X| $FD74
       .byte $BB ; |X XXX XX| $FD75
       .byte $28 ; |  X X   | $FD76
       .byte $3D ; |  XXXX X| $FD77
       .byte $10 ; |   X    | $FD78
       .byte $F3 ; |XXXX  XX| $FD79
       .byte $21 ; |  X    X| $FD7A
       .byte $97 ; |X  X XXX| $FD7B
       .byte $B6 ; |X XX XX | $FD7C
       .byte $CD ; |XX  XX X| $FD7D
       .byte $88 ; |X   X   | $FD7E
       .byte $05 ; |     X X| $FD7F
       .byte $D5 ; |XX X X X| $FD80
       .byte $21 ; |  X    X| $FD81

Target:
       .byte $3C ; |  XXXX  | $FD82
       .byte $7E ; | XXXXXX | $FD83
       .byte $5A ; | X XX X | $FD84
       .byte $5A ; | X XX X | $FD85
       .byte $5A ; | X XX X | $FD86
       .byte $5A ; | X XX X | $FD87
       .byte $FF ; |XXXXXXXX| $FD88
       .byte $00 ; |        | $FD89
       .byte $00 ; |        | $FD8A
       .byte $00 ; |        | $FD8B
       .byte $00 ; |        | $FD8C
       .byte $00 ; |        | $FD8D
       .byte $79 ; | XXXX  X| $FD8E
       .byte $76 ; | XXX XX | $FD8F
       .byte $FC ; |XXXXXX  | $FD90
       .byte $FF ; |XXXXXXXX| $FD91
       .byte $5A ; | X XX X | $FD92
       .byte $BD ; |X XXXX X| $FD93
       .byte $00 ; |        | $FD94
       .byte $00 ; |        | $FD95
       .byte $00 ; |        | $FD96
       .byte $00 ; |        | $FD97
       .byte $00 ; |        | $FD98
LFD99: .byte $81 ; |X      X| $FD99
       .byte $61 ; | XX    X| $FD9A
       .byte $39 ; |  XXX  X| $FD9B
       .byte $09 ; |    X  X| $FD9C
       .byte $19 ; |   XX  X| $FD9D
       .byte $41 ; | X     X| $FD9E
       .byte $09 ; |    X  X| $FD9F
       .byte $81 ; |X      X| $FDA0
       .byte $29 ; |  X X  X| $FDA1
       .byte $59 ; | X XX  X| $FDA2
       .byte $11 ; |   X   X| $FDA3
       .byte $69 ; | XX X  X| $FDA4
       .byte $49 ; | X  X  X| $FDA5
       .byte $31 ; |  XX   X| $FDA6
       .byte $61 ; | XX    X| $FDA7
       .byte $21 ; |  X    X| $FDA8
LFDA9: .byte $54 ; | X X X  | $FDA9
       .byte $4C ; | X  XX  | $FDAA
       .byte $44 ; | X   X  | $FDAB
       .byte $54 ; | X X X  | $FDAC
       .byte $74 ; | XXX X  | $FDAD
       .byte $10 ; |   X    | $FDAE
       .byte $20 ; |  X     | $FDAF
       .byte $10 ; |   X    | $FDB0
       .byte $88 ; |X   X   | $FDB1
       .byte $24 ; |  X  X  | $FDB2
       .byte $88 ; |X   X   | $FDB3
       .byte $38 ; |  XXX   | $FDB4
       .byte $54 ; | X X X  | $FDB5
       .byte $80 ; |X       | $FDB6
       .byte $88 ; |X   X   | $FDB7
       .byte $30 ; |  XX    | $FDB8


;Digit lookup table
LFDB9: .byte <Digit0 ; $FDB9
       .byte <Digit1 ; $FDBA
       .byte <Digit2 ; $FDBB
       .byte <Digit3 ; $FDBC
       .byte <Digit4 ; $FDBD
       .byte <Digit5 ; $FDBE
       .byte <Digit6 ; $FDBF
       .byte <Digit7 ; $FDC0
       .byte <Digit8 ; $FDC1
       .byte <Digit9 ; $FDC2
       .byte <Logo1  ; $FDC3
       .byte <Logo2  ; $FDC4
       .byte <Logo3  ; $FDC5
       .byte <Logo4  ; $FDC6
       .byte <Logo5  ; $FDC7

;bonus points
LFDC8: .byte $10 ; |   X    | $FDC8
       .byte $20 ; |  X     | $FDC9
       .byte $30 ; |  XX    | $FDCA
       .byte $40 ; | X      | $FDCB
       .byte $50 ; | X X    | $FDCC
       .byte $60 ; | XX     | $FDCD
       .byte $70 ; | XXX    | $FDCE
       .byte $80 ; |X       | $FDCF
       .byte $90 ; |X  X    | $FDD0
       .byte $90 ; |X  X    | $FDD1

LFDD2: .byte $19 ; |   XX  X| $FDD2
       .byte $18 ; |   XX   | $FDD3
       .byte $17 ; |   X XXX| $FDD4
       .byte $15 ; |   X X X| $FDD5
       .byte $13 ; |   X  XX| $FDD6
       .byte $10 ; |   X    | $FDD7
       .byte $0D ; |    XX X| $FDD8
       .byte $09 ; |    X  X| $FDD9
       .byte $07 ; |     XXX| $FDDA
       .byte $00 ; |        | $FDDB

;playfield colors
LFDDC: .byte $16 ; |   X XX | $FDDC yellow
       .byte $B6 ; |X XX XX | $FDDD green
       .byte $2A ; |  X X X | $FDDE gold
       .byte $76 ; | XXX XX | $FDDF blue
       .byte $AF ; |X X XXXX| $FDE0
       .byte $FD ; |XXXXXX X| $FDE1
       .byte $77 ; | XXX XXX| $FDE2
       .byte $14 ; |   X X  | $FDE3
       .byte $FD ; |XXXXXX X| $FDE4
       .byte $77 ; | XXX XXX| $FDE5
       .byte $15 ; |   X X X| $FDE6
       .byte $DD ; |XX XXX X| $FDE7
       .byte $36 ; |  XX XX | $FDE8
       .byte $0A ; |    X X | $FDE9
       .byte $FF ; |XXXXXXXX| $FDEA
       .byte $DD ; |XX XXX X| $FDEB
       .byte $36 ; |  XX XX | $FDEC
       .byte $0B ; |    X XX| $FDED
       .byte $FF ; |XXXXXXXX| $FDEE
       .byte $01 ; |       X| $FDEF
       .byte $00 ; |        | $FDF0
       .byte $01 ; |       X| $FDF1
       .byte $CD ; |XX  XX X| $FDF2
       .byte $9A ; |X  XX X | $FDF3
       .byte $09 ; |    X  X| $FDF4
       .byte $28 ; |  X X   | $FDF5
       .byte $02 ; |      X | $FDF6
       .byte $F7 ; |XXXX XXX| $FDF7
       .byte $02 ; |      X | $FDF8
       .byte $FD ; |XXXXXX X| $FDF9
       .byte $75 ; | XXX X X| $FDFA
       .byte $10 ; |   X    | $FDFB
       .byte $FD ; |XXXXXX X| $FDFC
       .byte $74 ; | XXX X  | $FDFD
       .byte $11 ; |   X   X| $FDFE
       .byte $36 ; |  XX XX | $FDFF

;maze data (read every 4th byte)
       .byte $FF ; |XXXXXXXX| $FE00
       .byte $FF ; |XXXXXXXX| $FE01
       .byte $FF ; |XXXXXXXX| $FE02
       .byte $FF ; |XXXXXXXX| $FE03
       .byte $FF ; |XXXXXXXX| $FE04
       .byte $FF ; |XXXXXXXX| $FE05
       .byte $FF ; |XXXXXXXX| $FE06
       .byte $FF ; |XXXXXXXX| $FE07

       .byte $00 ; |        | $FE08
       .byte $00 ; |        | $FE09
       .byte $00 ; |        | $FE0A
       .byte $00 ; |        | $FE0B
       .byte $00 ; |        | $FE0C
       .byte $80 ; |X       | $FE0D
       .byte $01 ; |       X| $FE0E
       .byte $10 ; |   X    | $FE0F

       .byte $39 ; |  XXX  X| $FE10
       .byte $39 ; |  XXX  X| $FE11
       .byte $3C ; |  XXXX  | $FE12
       .byte $3F ; |  XXXXXX| $FE13
       .byte $7C ; | XXXXX  | $FE14
       .byte $9F ; |X  XXXXX| $FE15
       .byte $F9 ; |XXXXX  X| $FE16
       .byte $73 ; | XXX  XX| $FE17

       .byte $01 ; |       X| $FE18
       .byte $09 ; |    X  X| $FE19
       .byte $00 ; |        | $FE1A
       .byte $01 ; |       X| $FE1B
       .byte $00 ; |        | $FE1C
       .byte $00 ; |        | $FE1D
       .byte $80 ; |X       | $FE1E
       .byte $03 ; |      XX| $FE1F

       .byte $CF ; |XX  XXXX| $FE20
       .byte $C9 ; |XX  X  X| $FE21
       .byte $CF ; |XX  XXXX| $FE22
       .byte $C8 ; |XX  X   | $FE23
       .byte $E4 ; |XXX  X  | $FE24
       .byte $7C ; | XXXXX  | $FE25
       .byte $1C ; |   XXX  | $FE26
       .byte $F0 ; |XXXX    | $FE27

       .byte $00 ; |        | $FE28
       .byte $09 ; |    X  X| $FE29
       .byte $08 ; |    X   | $FE2A
       .byte $0E ; |    XXX | $FE2B
       .byte $04 ; |     X  | $FE2C
       .byte $00 ; |        | $FE2D
       .byte $80 ; |X       | $FE2E
       .byte $02 ; |      X | $FE2F

       .byte $CC ; |XX  XX  | $FE30
       .byte $C0 ; |XX      | $FE31
       .byte $C9 ; |XX  X  X| $FE32
       .byte $C0 ; |XX      | $FE33
       .byte $9F ; |X  XXXXX| $FE34
       .byte $FC ; |XXXXXX  | $FE35
       .byte $FC ; |XXXXXX  | $FE36
       .byte $7E ; | XXXXXX | $FE37

       .byte $0C ; |    XX  | $FE38
       .byte $0F ; |    XXXX| $FE39
       .byte $01 ; |       X| $FE3A
       .byte $0E ; |    XXX | $FE3B
       .byte $80 ; |X       | $FE3C
       .byte $00 ; |        | $FE3D
       .byte $00 ; |        | $FE3E
       .byte $00 ; |        | $FE3F

       .byte $3C ; |  XXXX  | $FE40
       .byte $38 ; |  XXX   | $FE41
       .byte $39 ; |  XXX  X| $FE42
       .byte $38 ; |  XXX   | $FE43
       .byte $1F ; |   XXXXX| $FE44
       .byte $CC ; |XX  XX  | $FE45
       .byte $F3 ; |XXXX  XX| $FE46
       .byte $CE ; |XX  XXX | $FE47

       .byte $00 ; |        | $FE48
       .byte $01 ; |       X| $FE49
       .byte $20 ; |  X     | $FE4A
       .byte $01 ; |       X| $FE4B
       .byte $80 ; |X       | $FE4C
       .byte $0F ; |    XXXX| $FE4D
       .byte $10 ; |   X    | $FE4E
       .byte $03 ; |      XX| $FE4F

       .byte $3F ; |  XXXXXX| $FE50
       .byte $38 ; |  XXX   | $FE51
       .byte $27 ; |  X  XXX| $FE52
       .byte $F9 ; |XXXXX  X| $FE53
       .byte $E7 ; |XXX  XXX| $FE54
       .byte $C0 ; |XX      | $FE55
       .byte $93 ; |X  X  XX| $FE56
       .byte $73 ; | XXX  XX| $FE57

       .byte $20 ; |  X     | $FE58
       .byte $21 ; |  X    X| $FE59
       .byte $20 ; |  X     | $FE5A
       .byte $00 ; |        | $FE5B
       .byte $00 ; |        | $FE5C
       .byte $09 ; |    X  X| $FE5D
       .byte $80 ; |X       | $FE5E
       .byte $70 ; | XXX    | $FE5F

       .byte $06 ; |     XX | $FE60
       .byte $27 ; |  X  XXX| $FE61
       .byte $04 ; |     X  | $FE62
       .byte $3E ; |  XXXXX | $FE63
       .byte $7E ; | XXXXXX | $FE64
       .byte $79 ; | XXXX  X| $FE65
       .byte $13 ; |   X  XX| $FE66
       .byte $02 ; |      X | $FE67

       .byte $E6 ; |XXX  XX | $FE68
       .byte $01 ; |       X| $FE69
       .byte $E4 ; |XXX  X  | $FE6A
       .byte $00 ; |        | $FE6B
       .byte $02 ; |      X | $FE6C
       .byte $01 ; |       X| $FE6D
       .byte $F3 ; |XXXX  XX| $FE6E
       .byte $72 ; | XXX  X | $FE6F

       .byte $06 ; |     XX | $FE70
       .byte $38 ; |  XXX   | $FE71
       .byte $04 ; |     X  | $FE72
       .byte $CF ; |XX  XXXX| $FE73
       .byte $72 ; | XXX  X | $FE74
       .byte $98 ; |X  XX   | $FE75
       .byte $00 ; |        | $FE76
       .byte $13 ; |   X  XX| $FE77

       .byte $3E ; |  XXXXX | $FE78
       .byte $3E ; |  XXXXX | $FE79
       .byte $3C ; |  XXXX  | $FE7A
       .byte $03 ; |      XX| $FE7B
       .byte $12 ; |   X  X | $FE7C
       .byte $9E ; |X  XXXX | $FE7D
       .byte $73 ; | XXX  XX| $FE7E
       .byte $80 ; |X       | $FE7F

       .byte $00 ; |        | $FE80
       .byte $00 ; |        | $FE81
       .byte $00 ; |        | $FE82
       .byte $30 ; |  XX    | $FE83
       .byte $80 ; |X       | $FE84
       .byte $00 ; |        | $FE85
       .byte $03 ; |      XX| $FE86
       .byte $1C ; |   XXX  | $FE87

       .byte $FF ; |XXXXXXXX| $FE88
       .byte $FF ; |XXXXXXXX| $FE89
       .byte $FF ; |XXXXXXXX| $FE8A
       .byte $FF ; |XXXXXXXX| $FE8B
       .byte $FF ; |XXXXXXXX| $FE8C
       .byte $FF ; |XXXXXXXX| $FE8D
       .byte $FF ; |XXXXXXXX| $FE8E
       .byte $FF ; |XXXXXXXX| $FE8F

LFE90: .byte $60 ; | XX     | $FE90
       .byte $68 ; | XX X   | $FE91
       .byte $70 ; | XXX    | $FE92
       .byte $80 ; |X       | $FE93
       .byte $88 ; |X   X   | $FE94
       .byte $90 ; |X  X    | $FE95
       .byte $98 ; |X  XX   | $FE96
       .byte $A0 ; |X X     | $FE97
       .byte $A8 ; |X X X   | $FE98
       .byte $B0 ; |X XX    | $FE99
       .byte $B8 ; |X XXX   | $FE9A
       .byte $C0 ; |XX      | $FE9B
       .byte $D0 ; |XX X    | $FE9C
       .byte $D8 ; |XX XX   | $FE9D
       .byte $E0 ; |XXX     | $FE9E
       .byte $F0 ; |XXXX    | $FE9F
       .byte $F8 ; |XXXXX   | $FEA0
       .byte $FF ; |XXXXXXXX| $FEA1
       .byte $F0 ; |XXXX    | $FEA2

;gas pump
LFEA3: .byte $1E ; |   XXXX | $FEA3
       .byte $33 ; |  XX  XX| $FEA4
       .byte $2D ; |  X XX X| $FEA5
       .byte $6F ; | XX XXXX| $FEA6
       .byte $A9 ; |X X X  X| $FEA7
       .byte $AD ; |X X XX X| $FEA8
       .byte $ED ; |XXX XX X| $FEA9
       .byte $B3 ; |X XX  XX| $FEAA
       .byte $BF ; |X XXXXXX| $FEAB
       .byte $B3 ; |X XX  XX| $FEAC
       .byte $AD ; |X X XX X| $FEAD
       .byte $AD ; |X X XX X| $FEAE
       .byte $A1 ; |X X    X| $FEAF
       .byte $AD ; |X X XX X| $FEB0
       .byte $AD ; |X X XX X| $FEB1
       .byte $AD ; |X X XX X| $FEB2
       .byte $BF ; |X XXXXXX| $FEB3
       .byte $73 ; | XXX  XX| $FEB4
       .byte $2D ; |  X XX X| $FEB5
       .byte $2F ; |  X XXXX| $FEB6
       .byte $33 ; |  XX  XX| $FEB7
       .byte $3D ; |  XXXX X| $FEB8
       .byte $2D ; |  X XX X| $FEB9
       .byte $33 ; |  XX  XX| $FEBA
       .byte $3F ; |  XXXXXX| $FEBB


Cars:
LFEBC: .byte $78 ; | XXXX   | $FEBC
       .byte $74 ; | XXX X  | $FEBD
       .byte $FF ; |XXXXXXXX| $FEBE
       .byte $FF ; |XXXXXXXX| $FEBF
       .byte $BD ; |X XXXX X| $FEC0
       .byte $5A ; | X XX X | $FEC1
       .byte $A5 ; |X X  X X| $FEC2
       .byte $00 ; |        | $FEC3
       .byte $00 ; |        | $FEC4
       .byte $00 ; |        | $FEC5
       .byte $00 ; |        | $FEC6
       .byte $00 ; |        | $FEC7
       .byte $3C ; |  XXXX  | $FEC8
       .byte $24 ; |  X  X  | $FEC9
       .byte $3C ; |  XXXX  | $FECA
       .byte $5A ; | X XX X | $FECB
       .byte $7E ; | XXXXXX | $FECC
       .byte $3C ; |  XXXX  | $FECD
       .byte $42 ; | X    X | $FECE
       .byte $00 ; |        | $FECF
       .byte $00 ; |        | $FED0
       .byte $00 ; |        | $FED1
       .byte $00 ; |        | $FED2
       .byte $00 ; |        | $FED3
       .byte $78 ; | XXXX   | $FED4
       .byte $74 ; | XXX X  | $FED5
       .byte $FF ; |XXXXXXXX| $FED6
       .byte $FF ; |XXXXXXXX| $FED7
       .byte $5A ; | X XX X | $FED8
       .byte $BD ; |X XXXX X| $FED9
       .byte $42 ; | X    X | $FEDA
       .byte $00 ; |        | $FEDB
       .byte $00 ; |        | $FEDC
       .byte $00 ; |        | $FEDD
       .byte $00 ; |        | $FEDE
       .byte $00 ; |        | $FEDF
       .byte $3C ; |  XXXX  | $FEE0
       .byte $24 ; |  X  X  | $FEE1
       .byte $3C ; |  XXXX  | $FEE2
       .byte $5A ; | X XX X | $FEE3
       .byte $3C ; |  XXXX  | $FEE4
       .byte $7E ; | XXXXXX | $FEE5

LFEE6:
       .byte $00 ; |        | $FEE6
       .byte $00 ; |        | $FEE7
       .byte $00 ; |        | $FEE8
       .byte $00 ; |        | $FEE9
       .byte $00 ; |        | $FEEA
       .byte $88 ; |X   X   | $FEEB
       .byte $1F ; |   XXXXX| $FEEC
       .byte $6F ; | XX XXXX| $FEED
       .byte $29 ; |  X X  X| $FEEE
       .byte $11 ; |   X   X| $FEEF
       .byte $40 ; | X      | $FEF0
       .byte $B6 ; |X XX XX | $FEF1
       .byte $19 ; |   XX  X| $FEF2
       .byte $DD ; |XX XXX X| $FEF3
       .byte $7E ; | XXXXXX | $FEF4
       .byte $0A ; |    X X | $FEF5
       .byte $E6 ; |XXX  XX | $FEF6
       .byte $80 ; |X       | $FEF7
       .byte $B6 ; |X XX XX | $FEF8
       .byte $47 ; | X   XXX| $FEF9
       .byte $C5 ; |XX   X X| $FEFA
       .byte $E5 ; |XXX  X X| $FEFB
       .byte $DD ; |XX XXX X| $FEFC
       .byte $7E ; | XXXXXX | $FEFD
       .byte $03 ; |      XX| $FEFE

       ORG $FEFF

LFEFF: .byte <Bonus10 ; $FEFF
       .byte <Bonus20 ; $FF00
       .byte <Bonus30 ; $FF01
       .byte <Bonus40 ; $FF02
       .byte <Bonus50 ; $FF03
       .byte <Bonus60 ; $FF04
       .byte <Bonus70 ; $FF05
       .byte <Bonus80 ; $FF06
       .byte <Bonus90 ; $FF07
       .byte <Bonus90 ; $FF08

;maze edge
LFF09: .byte $80 ; |X       | $FF09
       .byte $80 ; |X       | $FF0A
       .byte $80 ; |X       | $FF0B
       .byte $80 ; |X       | $FF0C
       .byte $80 ; |X       | $FF0D
       .byte $00 ; |        | $FF0E
       .byte $80 ; |X       | $FF0F
       .byte $80 ; |X       | $FF10
       .byte $80 ; |X       | $FF11
       .byte $00 ; |        | $FF12
       .byte $80 ; |X       | $FF13
       .byte $80 ; |X       | $FF14
       .byte $80 ; |X       | $FF15
       .byte $80 ; |X       | $FF16
       .byte $80 ; |X       | $FF17
       .byte $80 ; |X       | $FF18
       .byte $80 ; |X       | $FF19
GFX:
Digit1:
       .byte $06 ; |     XX | $FF1A
Digit7:
       .byte $06 ; |     XX | $FF1B
       .byte $06 ; |     XX | $FF1C
Digit4:
       .byte $06 ; |     XX | $FF1D
Digit9:
       .byte $06 ; |     XX | $FF1E
       .byte $06 ; |     XX | $FF1F
       .byte $06 ; |     XX | $FF20
Digit8:
       .byte $FE ; |XXXXXXX | $FF21
       .byte $C6 ; |XX   XX | $FF22
       .byte $C6 ; |XX   XX | $FF23
Digit6:
       .byte $FE ; |XXXXXXX | $FF24
       .byte $C6 ; |XX   XX | $FF25
       .byte $C6 ; |XX   XX | $FF26
Digit2:
       .byte $FE ; |XXXXXXX | $FF27
       .byte $C0 ; |XX      | $FF28
       .byte $C0 ; |XX      | $FF29
Digit3:
       .byte $FE ; |XXXXXXX | $FF2A
       .byte $06 ; |     XX | $FF2B
       .byte $06 ; |     XX | $FF2C
Digit5:
       .byte $FE ; |XXXXXXX | $FF2D
       .byte $06 ; |     XX | $FF2E
       .byte $06 ; |     XX | $FF2F
       .byte $FE ; |XXXXXXX | $FF30
       .byte $C0 ; |XX      | $FF31
       .byte $C0 ; |XX      | $FF32
Digit0:
       .byte $FE ; |XXXXXXX | $FF33
       .byte $C6 ; |XX   XX | $FF34
       .byte $C6 ; |XX   XX | $FF35
       .byte $C6 ; |XX   XX | $FF36
       .byte $C6 ; |XX   XX | $FF37
       .byte $C6 ; |XX   XX | $FF38
       .byte $FE ; |XXXXXXX | $FF39

Digitx:
       .byte $38 ; |  XXX   | $FF3A
       .byte $54 ; | X X X  | $FF3B
       .byte $14 ; |   X X  | $FF3C
       .byte $38 ; |  XXX   | $FF3D
       .byte $50 ; | X X    | $FF3E
       .byte $54 ; | X X X  | $FF3F
       .byte $38 ; |  XXX   | $FF40

;18
LFA63:
       LDA    $82                  ;3
       ASL                         ;2
       EOR    $82                  ;3
       ASL                         ;2
       EOR    $82                  ;3
       ASL                         ;2
       ASL                         ;2
       EOR    $82                  ;3
       ASL                         ;2
       ROL    $82                  ;5
       LDA    $82                  ;3
       RTS                         ;6


;13
LFD14: SEC                         ;2
       SBC    #$04                 ;2
       TAX                         ;2
       LDA    ($C1),Y              ;5
LFD1A: ASL                         ;2
       DEX                         ;2
       BNE    LFD1A                ;2
       LDX    $B1                  ;3
       RTS                         ;6



Logo1:
       .byte $86 ; |X    XX | $FF60
       .byte $89 ; |X   X  X| $FF61
       .byte $89 ; |X   X  X| $FF62
       .byte $E9 ; |XXX X  X| $FF63
       .byte $86 ; |X    XX | $FF64
       .byte $80 ; |X       | $FF65
       .byte $F0 ; |XXXX    | $FF66

Logo2:
       .byte $48 ; | X  X   | $FF67
       .byte $49 ; | X  X  X| $FF68
       .byte $31 ; |  XX   X| $FF69
       .byte $49 ; | X  X  X| $FF6A
       .byte $49 ; | X  X  X| $FF6B
       .byte $01 ; |       X| $FF6C
       .byte $00 ; |        | $FF6D

Logo3:
       .byte $C7 ; |XX   XXX| $FF6E
       .byte $29 ; |  X X  X| $FF6F
       .byte $27 ; |  X  XXX| $FF70
       .byte $61 ; | XX    X| $FF71
       .byte $06 ; |     XX | $FF72
       .byte $20 ; |  X     | $FF73
       .byte $C0 ; |XX      | $FF74

Logo4:
       .byte $54 ; | X X X  | $FF75
       .byte $55 ; | X X X X| $FF76
       .byte $55 ; | X X X X| $FF77
       .byte $55 ; | X X X X| $FF78
       .byte $28 ; |  X X   | $FF79
       .byte $00 ; |        | $FF7A
       .byte $00 ; |        | $FF7B

Logo5:
       .byte $EE ; |XXX XXX | $FF7C
       .byte $02 ; |      X | $FF7D
       .byte $EE ; |XXX XXX | $FF7E
       .byte $28 ; |  X X   | $FF7F
       .byte $CE ; |XX  XXX | $FF80
       .byte $00 ; |        | $FF81
       .byte $00 ; |        | $FF82

       ORG $FF83

       .byte $84 ; |X    X  | $FF83
       .byte $29 ; |  X X  X| $FF84
       .byte $04 ; |     X  | $FF85
       .byte $A2 ; |X X   X | $FF86
       .byte $09 ; |    X  X| $FF87
       .byte $41 ; | X     X| $FF88
       .byte $14 ; |   X X  | $FF89
       .byte $00 ; |        | $FF8A

Bonus10:
       .byte $44 ; | X   X  | $FF8B
       .byte $CA ; |XX  X X | $FF8C
       .byte $4A ; | X  X X | $FF8D
       .byte $4A ; | X  X X | $FF8E
       .byte $4A ; | X  X X | $FF8F
       .byte $4A ; | X  X X | $FF90
       .byte $E4 ; |XXX  X  | $FF91

DigitSpace:
       .byte $00 ; |        | $FF92
       .byte $00 ; |        | $FF93
       .byte $00 ; |        | $FF94
       .byte $00 ; |        | $FF95
       .byte $00 ; |        | $FF96
       .byte $00 ; |        | $FF97
       .byte $00 ; |        | $FF98

Bonus20:
       .byte $C4 ; |XX   X  | $FF99
       .byte $2A ; |  X X X | $FF9A
       .byte $2A ; |  X X X | $FF9B
       .byte $4A ; | X  X X | $FF9C
       .byte $8A ; |X   X X | $FF9D
       .byte $8A ; |X   X X | $FF9E
       .byte $E4 ; |XXX  X  | $FF9F
       .byte $00 ; |        | $FFA0
       .byte $00 ; |        | $FFA1
       .byte $00 ; |        | $FFA2
       .byte $00 ; |        | $FFA3
       .byte $00 ; |        | $FFA4

Bonus30:
       .byte $C4 ; |XX   X  | $FFA5
       .byte $2A ; |  X X X | $FFA6
       .byte $2A ; |  X X X | $FFA7
       .byte $CA ; |XX  X X | $FFA8
       .byte $2A ; |  X X X | $FFA9
       .byte $2A ; |  X X X | $FFAA
       .byte $C4 ; |XX   X  | $FFAB
       .byte $00 ; |        | $FFAC
       .byte $00 ; |        | $FFAD
       .byte $00 ; |        | $FFAE
       .byte $00 ; |        | $FFAF
       .byte $00 ; |        | $FFB0

Bonus40:
       .byte $A4 ; |X X  X  | $FFB1
       .byte $AA ; |X X X X | $FFB2
       .byte $AA ; |X X X X | $FFB3
       .byte $EA ; |XXX X X | $FFB4
       .byte $2A ; |  X X X | $FFB5
       .byte $2A ; |  X X X | $FFB6
       .byte $24 ; |  X  X  | $FFB7
       .byte $00 ; |        | $FFB8
       .byte $00 ; |        | $FFB9
       .byte $00 ; |        | $FFBA
       .byte $00 ; |        | $FFBB
       .byte $00 ; |        | $FFBC

Bonus50:
       .byte $E4 ; |XXX  X  | $FFBD
       .byte $8A ; |X   X X | $FFBE
       .byte $CA ; |XX  X X | $FFBF
       .byte $2A ; |  X X X | $FFC0
       .byte $2A ; |  X X X | $FFC1
       .byte $2A ; |  X X X | $FFC2
       .byte $C4 ; |XX   X  | $FFC3
       .byte $00 ; |        | $FFC4
       .byte $00 ; |        | $FFC5
       .byte $00 ; |        | $FFC6
       .byte $00 ; |        | $FFC7
       .byte $00 ; |        | $FFC8

Bonus60:
       .byte $64 ; | XX  X  | $FFC9
       .byte $8A ; |X   X X | $FFCA
       .byte $8A ; |X   X X | $FFCB
       .byte $CA ; |XX  X X | $FFCC
       .byte $AA ; |X X X X | $FFCD
       .byte $AA ; |X X X X | $FFCE
       .byte $44 ; | X   X  | $FFCF
       .byte $00 ; |        | $FFD0
       .byte $00 ; |        | $FFD1
       .byte $00 ; |        | $FFD2
       .byte $00 ; |        | $FFD3
       .byte $00 ; |        | $FFD4

Bonus70:
       .byte $E4 ; |XXX  X  | $FFD5
       .byte $2A ; |  X X X | $FFD6
       .byte $2A ; |  X X X | $FFD7
       .byte $4A ; | X  X X | $FFD8
       .byte $8A ; |X   X X | $FFD9
       .byte $8A ; |X   X X | $FFDA
       .byte $84 ; |X    X  | $FFDB
       .byte $00 ; |        | $FFDC
       .byte $00 ; |        | $FFDD
       .byte $00 ; |        | $FFDE
       .byte $00 ; |        | $FFDF
       .byte $00 ; |        | $FFE0

Bonus80:
       .byte $44 ; | X   X  | $FFE1
       .byte $AA ; |X X X X | $FFE2
       .byte $AA ; |X X X X | $FFE3
       .byte $4A ; | X  X X | $FFE4
       .byte $AA ; |X X X X | $FFE5
       .byte $AA ; |X X X X | $FFE6
       .byte $44 ; | X   X  | $FFE7
       .byte $00 ; |        | $FFE8
       .byte $00 ; |        | $FFE9
       .byte $00 ; |        | $FFEA
       .byte $00 ; |        | $FFEB
       .byte $00 ; |        | $FFEC

Bonus90:
       .byte $44 ; | X   X  | $FFED
       .byte $AA ; |X X X X | $FFEE
       .byte $AA ; |X X X X | $FFEF
       .byte $6A ; | XX X X | $FFF0
       .byte $2A ; |  X X X | $FFF1
       .byte $AA ; |X X X X | $FFF2
       .byte $44 ; | X   X  | $FFF3
       .byte $00 ; |        | $FFF4
       .byte $00 ; |        | $FFF5
       .byte $00 ; |        | $FFF6
       .byte $00 ; |        | $FFF7

;Supercharger
       .byte $00 ; |        | $FFF8
       .byte $00 ; |        | $FFF9
       .byte $00 ; |        | $FFFA
       .byte $00 ; |        | $FFFB

       ORG $FFFC

       .word START
       .byte $00,$73
