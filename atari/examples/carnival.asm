;Carnival hack by Nukey Shay

MSG_TEST = 0
;note: scanline off by 1 when game select is used...corrected when duck flies down??

; Disassembly of Carnival.bin
; Disassembled Fri Jan 13 02:43:23 2006
; Using DiStella v2.0
; Command Line: C:\BIN\DISTELLA.EXE -pafscCarnival.cfg Carnival.bin 
; Carnival.cfg contents:
;      CODE F000 FAC5
;      GFX FAC6 FBBD
;      CODE FBBE FBD3
;      GFX FBD4 FCA6
;      CODE FCA7 FCFE
;      GFX FCFF FDD3
;      CODE FDD4 FDE1
;      GFX FDE2 FF53
;      CODE FF54 FF5C
;      GFX FF5D FFFF

      processor 6502

;hardware register equates...
VSYNC   =  $00 ;Vertical Sync Set-Clear
VBLANK  =  $01 ;Vertical Blank Set-Clear
WSYNC   =  $02 ;Wait for Horizontal Blank
RSYNC   =  $03 ;Reset Horizontal Sync Counter
NUSIZ0  =  $04 ;Number-Size player/missle 0
NUSIZ1  =  $05 ;Number-Size player/missle 1
COLUP0  =  $06 ;Color-Luminance Player 0
COLUP1  =  $07 ;Color-Luminance Player 1
COLUPF  =  $08 ;Color-Luminance Playfield
COLUBK  =  $09 ;Color-Luminance Background
CTRLPF  =  $0A ;Control Playfield, Ball, Collisions
REFP0   =  $0B ;Reflection Player 0
REFP1   =  $0C ;Reflection Player 1
PF0     =  $0D ;Playfield Register Byte 0 (upper nybble used only)
PF1     =  $0E ;Playfield Register Byte 1
PF2     =  $0F ;Playfield Register Byte 2
RESP0   =  $10 ;Reset Player 0
RESP1   =  $11 ;Reset Player 1
RESM0   =  $12 ;Reset Missle 0
RESM1   =  $13 ;Reset Missle 1
RESBL   =  $14 ;Reset Ball
;Audio registers...
AUDC0   =  $15 ;Audio Control - Voice 0 (distortion)
AUDC1   =  $16 ;Audio Control - Voice 1 (distortion)
AUDF0   =  $17 ;Audio Frequency - Voice 0
AUDF1   =  $18 ;Audio Frequency - Voice 1
AUDV0   =  $19 ;Audio Volume - Voice 0
AUDV1   =  $1A ;Audio Volume - Voice 1
;Sprite registers...
GRP0    =  $1B ;Graphics Register Player 0
GRP1    =  $1C ;Graphics Register Player 1
ENAM0   =  $1D ;Graphics Enable Missle 0
ENAM1   =  $1E ;Graphics Enable Missle 1
ENABL   =  $1F ;Graphics Enable Ball
HMP0    =  $20 ;Horizontal Motion Player 0
HMP1    =  $21 ;Horizontal Motion Player 1
HMM0    =  $22 ;Horizontal Motion Missle 0
HMM1    =  $23 ;Horizontal Motion Missle 1
HMBL    =  $24 ;Horizontal Motion Ball
VDELP0  =  $25 ;Vertical Delay Player 0
VDELP1  =  $26 ;Vertical Delay Player 1
VDELBL  =  $27 ;Vertical Delay Ball
RESMP0  =  $28 ;Reset Missle 0 to Player 0
RESMP1  =  $29 ;Reset Missle 1 to Player 1
HMOVE   =  $2A ;Apply Horizontal Motion
HMCLR   =  $2B ;Clear Horizontal Move Registers
CXCLR   =  $2C ;Clear Collision Latches
Waste1  =  $2D ;Unused
Waste2  =  $2E ;Unused
Waste3  =  $2F ;Unused
;collisions...                  (bit 7) (bit 6)
CXM0P   =  $30 ;Read Collision - M0-P1   M0-P0
CXM1P   =  $31 ;Read Collision - M1-P0   M1-P1
CXP0FB  =  $32 ;Read Collision - P0-PF   P0-BL
CXP1FB  =  $33 ;Read Collision - P1-PF   P1-BL
CXM0FB  =  $34 ;Read Collision - M0-PF   M0-BL
CXM1FB  =  $35 ;Read Collision - M1-PF   M1-BL
CXBLPF  =  $36 ;Read Collision - BL-PF   -----
CXPPMM  =  $37 ;Read Collision - P0-P1   M0-M1
INPT0   =  $38 ;Read Pot Port 0
INPT1   =  $39 ;Read Pot Port 1
INPT2   =  $3A ;Read Pot Port 2
INPT3   =  $3B ;Read Pot Port 3
INPT4   =  $3C ;Read Input - Trigger 0 (bit 7)
INPT5   =  $3D ;Read Input - Trigger 1 (bit 7)
;RIOT registers...
SWCHA  = $0280 ;Port A data register for joysticks (High nybble:player0,low nybble:player1)
SWACNT = $0281 ;Port A data direction register (DDR)
SWCHB  = $0282 ;Port B data (console switches) bit pattern LR--B-SR
SWBCNT = $0283 ;Port B data direction register (DDR)
INTIM  = $0284 ;Timer output
TIMINT = $0285 ;
WasteA = $0286 ;Unused/undefined
WasteB = $0287 ;Unused/undefined
WasteC = $0288 ;Unused/undefined
WasteD = $0289 ;Unused/undefined
WasteE = $028A ;Unused/undefined
WasteF = $028B ;Unused/undefined
WasteG = $028C ;Unused/undefined
WasteH = $028D ;Unused/undefined
WasteI = $028E ;Unused/undefined
WasteJ = $028F ;Unused/undefined
WasteK = $0290 ;Unused/undefined
WasteL = $0291 ;Unused/undefined
WasteM = $0292 ;Unused/undefined
WasteN = $0293 ;Unused/undefined
TIM1T  = $0294 ;set 1 clock interval
TIM8T  = $0295 ;set 8 clock interval
TIM64T = $0296 ;set 64 clock interval
T1024T = $0297 ;set 1024 clock interval

;ram assignments...
;the first 48 variables reset using a table...
r80                          = $80
r81                          = $81
r82                          = $82
r83                          = $83
r84                          = $84
r85                          = $85 ;pipe shots remaining
r86                          = $86 ;only used once

r87                          = $87 ;2 bytes +/- pointers
;r88                          = $88 never set?
r89                          = $89 ;2 bytes
;r8A                          = $8A never set?

r8B                          = $8B ;2 bytes...bullets remaining pointer
;r8C                          = $8C never set?

r8D                          = $8D ;2 bytes score color pointer?
;r8E                          = $8E never set?
r8F                          = $8F
r90                          = $90

r91                          = $91 ;table 7 bytes framecounter?
;r92                          = $92
;r93                          = $93
;r94                          = $94
;r95                          = $95
;r96                          = $96
;r97                          = $97

r98                          = $98 ;2 bytes...table-12 bytes line 3 pointers
;r99                          = $99 never set?
r9A                          = $9A ;2 bytes
;r9B                          = $9B never set?

r9C                          = $9C ;2 bytes...line 2 pointers
;r9D                          = $9D never set?
;r9E                          = $9E 2 bytes
;r9F                          = $9F never set?

;rA0                          = $A0 2 bytes...line 1 pointers
;rA1                          = $A1 never set?
;rA2                          = $A2 ;2 bytes
;rA3                          = $A3 never set?


rA4                          = $A4 ;table
;rA5                          = $A5
;rA6                          = $A6
;rA7                          = $A7
;rA8                          = $A8
;rA9                          = $A9

rAA                          = $AA ;value 0-3 level?
rAB                          = $AB
rAC                          = $AC ;player up?

rAD                          = $AD ;table
rAE                          = $AE
;rAF                          = $AF
;rB0                          = $B0

rB1                          = $B1 ;table...6 bytes?
;rB2                          = $B2
;rB3                          = $B3
;rB4                          = $B4
;rB5                          = $B5
;rB6                          = $B6

rB7                          = $B7
;end init table


rB8                          = $B8 ;value $20 or $00...show gun??

rB9                          = $B9 ;playfield gfx...6 bytes
;rBA                          = $BA
;rBB                          = $BB
;rBC                          = $BC
;rBD                          = $BD
;rBE                          = $BE

rBF                          = $BF ;score printing temps
;rC0                          = $C0
;rC1                          = $C1
;rC2                          = $C2
;rC3                          = $C3
;rC4                          = $C4
;rC5                          = $C5
;rC6                          = $C6
;rC7                          = $C7
;rC8                          = $C8 reused

rC9                          = $C9
rCA                          = $CA
rCB                          = $CB
rCC                          = $CC
rCD                          = $CD
rCE                          = $CE ;value 0 to 7





rCF                          = $CF
rD0                          = $D0
rD1                          = $D1
rD2                          = $D2
rD3                          = $D3
rD4                          = $D4
rD5                          = $D5
rD6                          = $D6
rD7                          = $D7
rD8                          = $D8
rD9                          = $D9
rDA                          = $DA
rDB                          = $DB
rDC                          = $DC
rDD                          = $DD
rDE                          = $DE
rDF                          = $DF
rE0                          = $E0
rE1                          = $E1
rE2                          = $E2
rE3                          = $E3

rE4                          = $E4 ;missile pointer
rE5                          = $E5

rE6                          = $E6
rE7                          = $E7
rE8                          = $E8
rE9                          = $E9
rEA                          = $EA
rEB                          = $EB
rEC                          = $EC
rED                          = $ED
rEE                          = $EE
rEF                          = $EF
rF0                          = $F0
rF1                          = $F1
rF2                          = $F2
rF3                          = $F3
rF4                          = $F4

rF5                          = $F5 ;flying duck pointers
rF6                          = $F6
rF7                          = $F7
rF8                          = $F8

rF9                          = $F9 ;pipe pointers
rFA                          = $FA
rFB                          = $FB
rFC                          = $FC

;rFD                          = $FD free

;$FE-$FF = stack



       ORG $1000
       RORG $D000

START1:
       sta    $FFF9                   ;4
       nop                            ;2
       nop                            ;2
       nop                            ;2
       nop                            ;2


Display_Done:
       sta    $FFF9                   ;4


       ldy    #>Bird_Page1            ;2
       lda    rCF                     ;3
       and    #$08                    ;2
       bne    No_Change0              ;2
       ldy    #>Bird_Page2            ;2
No_Change0:
       sty    rF5+1                   ;3
       sty    rF7+1                   ;3
       sty    r87+1                   ;3
       sty    r89+1                   ;3
       dey                            ;2
       dey                            ;2
       sty    r98+1                   ;3
       sty    r98+3                   ;3
       sty    r98+5                   ;3
       sty    r98+7                   ;3
       sty    r98+9                   ;3
       sty    r98+11                  ;3


Hold:
       LDX    INTIM                   ;4
       BNE    Hold                    ;2
       STX    WSYNC                   ;3
       STX    VBLANK                  ;3
       STX    REFP0                   ;3
       STX    REFP1                   ;3
       INX                            ;2
       STX    VDELP0                  ;3
       STX    VDELP1                  ;3
       LDX    #$03                    ;2
       STX    NUSIZ0                  ;3
       STX    NUSIZ1                  ;3
       STX    HMCLR                   ;3
       NOP                            ;2
       LDY    #$90                    ;2
       STY    HMP0                    ;3

;       LDY    #$07                    ;2 8 scanlines
       LDY    #$06                    ;2 7 scanlines

       STA    RESP0                   ;3
;       LDX    #$8A                    ;2 ??
       nop                            ;2

       STA    RESP1                   ;3
       STA    WSYNC                   ;3
       STA    HMOVE                   ;3
;do score
LF546:
       LDA    (r8D),Y                 ;5
       STA    COLUP1                  ;3
       STA    WSYNC                   ;3
       STA    COLUP0                  ;3
       LDA    (rBF+8),Y               ;5
       STA    GRP0                    ;3
       LDA    (rBF+6),Y               ;5
       STA    GRP1                    ;3
       LDA    (rBF+4),Y               ;5
       STA    GRP0                    ;3
       LDA    (rBF+2),Y               ;5
       TAX                            ;2
       LDA    (rBF),Y                 ;5
       STY    rD6                     ;3
       LDY    #$00                    ;2
       STX    GRP1                    ;3
       STA    GRP0                    ;3
       STY    GRP1                    ;3
       STY    GRP0                    ;3
       LDY    rD6                     ;3
       DEY                            ;2
       BPL    LF546                   ;2



;       STX    WSYNC                   ;3


;setup pipe color pointer
       lda    r91                     ;3 framecounter?
       lsr                            ;2
       lsr                            ;2
       lsr                            ;2
       lsr                            ;2
       and    #$03                    ;2

       STA    HMCLR                   ;3
       INY                            ;2
       STY    VDELP0                  ;3
       STY    VDELP1                  ;3
       STY    GRP0                    ;3
       STY    GRP1                    ;3
       tay                            ;2 give hue pointer to Y




;kernal branch here
;       jmp    Bear_Display            ;3



       LDX    #$04                    ;2
       LDA    r84                     ;3
;       JSR    LFBBE                   ;6
       brk                            ;7
       nop                            ;2

       INX                            ;2
       STX    NUSIZ1                  ;3
       STX    NUSIZ0                  ;3
       LDA    #$D0                    ;2
       STA    HMP0                    ;3

;       lda    rFD                     ;3
;       and    #$03                    ;2
;       tax                            ;2
;;       inc    Waste2                   ;5
;;       nop                             ;2

       lda    Pipe_Color_Tbl2,Y       ;4 pipe hue
       ldy    r85                     ;3 pipe shots left
       ora    Pipe_Color_Tbl-1,Y      ;4 pipe brightness
       STA    COLUP0                  ;3
       STA    COLUP1                  ;3
       STA    RESP0                   ;3
       LDY    #$0D                    ;2
       STA    RESP1                   ;3
       STA    WSYNC                   ;3
       STA    HMOVE                   ;3
       STA    WSYNC                   ;3
       JSR    LFCA7                   ;6 draw line
       LDA    #$EA                    ;2
       STA    COLUPF                  ;3
       STA    REFP1                   ;3
;draw flags
LF5AD:
       LDA    (rE4),Y                 ;5
       STA    WSYNC                   ;3
       STA    HMCLR                   ;3
       STA    ENABL                   ;3
       LDA    (rF9),Y                 ;5
       STA    GRP0                    ;3
       LDA    (rFB),Y                 ;5
       STA    GRP1                    ;3
       DEY                            ;2
       CPY    #$07                    ;2
       BNE    LF5AD                   ;2
       LDY    #$14                    ;2
       LDA    rE3                     ;3
       STA    rE4                     ;3
LF5C8:
       LDA    (rF9),Y                 ;5
       TAX                            ;2
       LDA    (rE4),Y                 ;5
       STA    WSYNC                   ;3
       STA    ENABL                   ;3
       STX    GRP0                    ;3
       LDA    (rFB),Y                 ;5
       STA    GRP1                    ;3
       DEY                            ;2
       CPY    #$0D                    ;2
       BNE    LF5C8                   ;2


       STA    RESP0                   ;3
       LDX    #$B0                    ;2
       STA    RESP1                   ;3
       LDA    #$A0                    ;2
       STA    HMP1                    ;3
       STX    HMP0                    ;3
       LDX    #$48                    ;2
       LDA    r90                     ;3
       CMP    #$14                    ;2
       BNE    LF5FA                   ;2
       LDX    #$38                    ;2
       LDA    rCF                     ;3
       AND    #$10                    ;2
       BEQ    LF5FA                   ;2
       LDX    #$00                    ;2
LF5FA:
       STX    COLUP0                  ;3
       STX    COLUP1                  ;3
       LDA    (rE4),Y                 ;5
       STA    WSYNC                   ;3
       STA    HMOVE                   ;3
       JSR    LFCCF                   ;6
       STX    REFP1                   ;3



       dey                            ;2
       dey                            ;2


;draw +/- stuff
LF609:
       LDA    (rE4),Y                 ;5
       STA    rBF+9                   ;3
       LDA    (r87),Y                 ;5
       LDX    #$00                    ;2
       STX    PF2                     ;3
       STX    PF0                     ;3
       TAX                            ;2
       LDA    (r89),Y                 ;5
       STA    WSYNC                   ;3
       STA    GRP1                    ;3
       LDA    rBF+9                   ;3
       STX    GRP0                    ;3
       STA    ENABL                   ;3
       DEY                            ;2
       LDA    #$C0                    ;2
       STA    PF2                     ;3
       NOP                            ;2
       NOP                            ;2
       LDX    #$FF                    ;2
       STX    PF0                     ;3
       CPY    #$03                    ;2
       BNE    LF609                   ;2
       INX                            ;2
       STX    PF0                     ;3
       STX    PF2                     ;3

       STA    WSYNC                   ;3
       LDA    (rE4),Y                 ;5
       JSR    LFCCF                   ;6
       STX    NUSIZ1                  ;3
       STX    NUSIZ0                  ;3
       LDA    #$02                    ;2
       STA    CTRLPF                  ;3
       LDA    #$08                    ;2
       STA    COLUP1                  ;3
       LDX    #$98                    ;2
       LDA    r90                     ;3
       CMP    #$14                    ;2
       BNE    LF653                   ;2
       LDX    #$38                    ;2
LF653:
       STX    COLUP0                  ;3
LF655:
       LDA    (rE4),Y                 ;5
       STA    WSYNC                   ;3
       STA    ENABL                   ;3
       LDX    #$00                    ;2
       LDA    rE6                     ;3
       BEQ    LF66B                   ;2
       STA    PF1                     ;3
       LDA    #$80                    ;2
       STA    PF0                     ;3
       STX    PF2                     ;3
       BNE    LF673                   ;2 always branch

LF66B:
       STA    PF0                     ;3
       STA    PF1                     ;3
       STA    PF2                     ;3
       NOP                            ;2
       NOP                            ;2
LF673:
       JSR    LFBD3                   ;6 waste 12 cycles
       LDA    (rE4),Y                 ;5
       STX    PF0                     ;3
       LDA    #$1F                    ;2
       STA    PF1                     ;3
       LDA    #$FF                    ;2
       STA    PF2                     ;3
       DEY                            ;2
       BNE    LF655                   ;2
       STA    WSYNC                   ;3
       LDA    (rE4),Y                 ;5
       STA    ENABL                   ;3
       STY    PF1                     ;3
       STY    PF2                     ;3
       LDY    #$0F                    ;2
       LDA    rE2                     ;3
       STA    rE4                     ;3
       LDA    r91+5                   ;3
;       JSR    LFBBE                   ;6
       brk                            ;7
       nop                            ;2

       INX                            ;2
       LDA    r91+6                   ;3
;       JSR    LFBBE                   ;6
       brk                            ;7
       nop                            ;2

       LDA    (r9C+4),Y               ;5
       STA    COLUP0                  ;3
       LDA    (r9C+6),Y               ;5
       STA    COLUP1                  ;3
       LDA    rA4+4                   ;3
       STA    NUSIZ0                  ;3
       LDA    rA4+5                   ;3
       JSR    LFCC1                   ;6

;first line
LF6B1:
       LDA    (rE4),Y                 ;5
       STA    rBF+9                   ;3
       LDA    (r9C+4),Y               ;5
       TAX                            ;2
       LDA    (r9C+6),Y               ;5
       JSR    LFCD9                   ;6
       BPL    LF6B1                   ;2

       LDY    #$10                    ;2
       LDA    rE1                     ;3
       STA    rE4                     ;3
       STA    WSYNC                   ;3
       LDA    (rE4),Y                 ;5
       JSR    LFCCF                   ;6
       LDA    r91+3                   ;3
;       JSR    LFBBE                   ;6
       brk                            ;7
       nop                            ;2

       INX                            ;2
       LDA    r91+4                   ;3
;       JSR    LFBBE                   ;6
       brk                            ;7
       nop                            ;2

       LDA    (r9C),Y                 ;5
       STA    COLUP0                  ;3
       LDA    (r9C+2),Y               ;5
       STA    COLUP1                  ;3
       LDA    rA4+2                   ;3
       STA    NUSIZ0                  ;3
       LDA    rA4+3                   ;3
       LDX    #$00                    ;2
       JSR    LFCC3                   ;6
;second line
LF6EA:
       LDA    (rE4),Y                 ;5
       STA    rBF+9                   ;3
       LDA    (r9C),Y                 ;5
       TAX                            ;2
       LDA    (r9C+2),Y               ;5
       JSR    LFCD9                   ;6
       BPL    LF6EA                   ;2

       LDY    #$10                    ;2
       LDA    rE0                     ;3
       STA    rE4                     ;3
       STA    WSYNC                   ;3
       LDA    (rE4),Y                 ;5
       JSR    LFCCF                   ;6
       LDA    r91+1                   ;3
;       JSR    LFBBE                   ;6
       brk                            ;7
       nop                            ;2

       INX                            ;2
       LDA    r91+2                   ;3
;       JSR    LFBBE                   ;6
       brk                            ;7
       nop                            ;2

       LDA    (r98),Y                 ;5
       STA    COLUP0                  ;3
       LDA    (r9A),Y                 ;5
       STA    COLUP1                  ;3
       LDA    rA4                     ;3
       STA    NUSIZ0                  ;3
       LDA    rA4+1                   ;3
       JSR    LFCC1                   ;6
;third line
LF721:
       LDA    (rE4),Y                 ;5
       STA    rBF+9                   ;3
       LDA    (r98),Y                 ;5
       TAX                            ;2
       LDA    (r9A),Y                 ;5
       JSR    LFCD9                   ;6
       BPL    LF721                   ;2

       INY                            ;2
       STA    WSYNC                   ;3
       LDA    (rE4),Y                 ;5
       JSR    LFCCF                   ;6
       STX    NUSIZ0                  ;3
       STX    NUSIZ1                  ;3
       LDA    rEF                     ;3
       BIT    rAB                     ;3
       BMI    LF744                   ;2
       CLC                            ;2
       ADC    #$08                    ;2
LF744:
       TAY                            ;2
;       JSR    LFBBE                   ;6
       brk                            ;7
       nop                            ;2

       INX                            ;2
       TYA                            ;2
       LDY    #$00                    ;2
       CLC                            ;2
       ADC    #$08                    ;2
       BIT    rAB                     ;3
       BMI    LF757                   ;2
       SBC    #$0F                    ;2
       LDY    #$08                    ;2
LF757:
;       JSR    LFBBE                   ;6
       brk                            ;7
       nop                            ;2

       STY    REFP0                   ;3
       STY    REFP1                   ;3
       STA    WSYNC                   ;3
       STA    HMOVE                   ;3
       LDX    #$03                    ;2 up to 3 flying ducks
       LDA    #$18                    ;2 yellow
       STA    COLUP0                  ;3
       STA    COLUP1                  ;3
LF76A:
       LDY    #$14                    ;2
       LDA    rDC,X                   ;4
       STA    rE4                     ;3
       LDA    rF2,X                   ;4
       STA    rF5                     ;3
       cmp    #<Blank_Duck_gfx        ;2
       BEQ    LF77B                   ;2
       CLC                            ;2
       ADC    #$23                    ;2
LF77B:
       STA    rF7                     ;3
;draw flying duck
LF77D:
       LDA    (rE4),Y                 ;5
       STA    WSYNC                   ;3
       STA    ENABL                   ;3
       LDA    (rF5),Y                 ;5
       STA    GRP0                    ;3
       LDA    (rF7),Y                 ;5
       STA    GRP1                    ;3
       DEY                            ;2
       BPL    LF77D                   ;2
       DEX                            ;2
       BNE    LF76A                   ;2

       LDY    #$14                    ;2
       LDA    rDC,X                   ;4
       STA    rE4                     ;3
       LDA    rF2,X                   ;4
       STA    rF5                     ;3
       CMP    #$8C                    ;2
       BEQ    LF7A2                   ;2
       CLC                            ;2
       ADC    #$23                    ;2
LF7A2:
       STA    rF7                     ;3
LF7A4:
       LDA    (rE4),Y                 ;5
       STA    WSYNC                   ;3
       STA    ENABL                   ;3
       LDA    (rF5),Y                 ;5
       STA    GRP0                    ;3
       LDA    (rF7),Y                 ;5
       STA    GRP1                    ;3
       DEY                            ;2
       CPY    #$0C                    ;2
       BNE    LF7A4                   ;2

       LDA    rED                     ;3
       INX                            ;2
;       JSR    LFBBE                   ;6
       brk                            ;7
       nop                            ;2


       DEX                            ;2
Draw_Gun:
       STX    ENABL                   ;3
       STX    CTRLPF                  ;3
       STX    NUSIZ0                  ;3
       STX    REFP0                   ;3
       STX    NUSIZ1                  ;3
       STX    GRP1                    ;3
       LDA    #$B7                    ;2
       STA    COLUP0                  ;3
       LDA    r82                     ;3
;       JSR    LFBBE                   ;6
       brk                            ;7
       nop                            ;2

       STA    WSYNC                   ;3
       STA    HMOVE                   ;3


       ldy    #Gun1-LFD5D             ;2
       lda    rAC                     ;3
       lsr                            ;2
       tax                            ;2
       lda    REFP1,X                 ;4 get trigger
       bmi    No_Trig                 ;2
       ldy    #Gun2-LFD5D             ;2
No_Trig:
       LDX    #$0D                    ;2

;draw gun
LF7D9:
       STA    WSYNC                   ;3
       lda    LFD5D,Y                 ;4
       STA    GRP0                    ;3
       dey                            ;2
       DEX                            ;2
       BPL    LF7D9                   ;2

       STA    WSYNC                   ;3
       LDA    rB8                     ;3 keep rB8 non-zero during bear sequence
       BEQ    LF7F2                   ;2
       LDX    #$0B                    ;2
LF7EB:
       STA    WSYNC                   ;3
       DEX                            ;2
       BNE    LF7EB                   ;2
       BEQ    LF83A                   ;2 always branch



LF7F2:
       JSR    LFCA7                   ;6 draw line
       LDY    #$06                    ;2
       LDX    rAA                     ;3
       LDA    LFDF5,X                 ;4
       STA    COLUPF                  ;3
       LDA    #$E8                    ;2
       STA    COLUP1                  ;3
;draw bullets remaining
LF802:
       LDA    (r8B),Y                 ;5
       STA    WSYNC                   ;3
       STA    GRP1                    ;3
       LDA    rB9+5                   ;3
       CPY    #$06                    ;2
       BEQ    LF826                   ;2
       STA    PF0                     ;3
       LDA    rB9+4                   ;3
       STA    PF1                     ;3
       LDA    rB9+3                   ;3
       STA    PF2                     ;3
       LDA    (r8B),Y                 ;5
       LDA    rB9+2                   ;3
       STA    PF0                     ;3
       LDA    rB9+1                   ;3
       STA    PF1                     ;3
       LDA    rB9                     ;3
       STA    PF2                     ;3
LF826:
       DEY                            ;2
       BNE    LF802                   ;2

       LDA    (r8B),Y                 ;5
       STA    WSYNC                   ;3
       STY    COLUPF                  ;3
       STA    GRP1                    ;3
       STA    WSYNC                   ;3
       STY    GRP1                    ;3
       STA    WSYNC                   ;3
       JSR    LFCA7                   ;6 draw line
LF83A:
       jmp    Display_Done            ;3





Bear_Display:
       ldx    #$00                    ;2
       jmp    Draw_Gun                ;3



























LFCA7:
       LDA    #$08                    ;2
       STA    COLUPF                  ;3
       LDA    #$F0                    ;2
       STA    PF0                     ;3
       LDX    #$FF                    ;2
       STX    PF1                     ;3
       STX    PF2                     ;3
       INX                            ;2
       STX    REFP1                   ;3
       STA    WSYNC                   ;3
       STX    PF0                     ;3
       STX    PF1                     ;3
       STX    PF2                     ;3
       RTS                            ;6




LFCC1:
       LDX    #$08                    ;2
LFCC3:
       STA    NUSIZ1                  ;3
       STX    REFP0                   ;3
       STX    REFP1                   ;3
       DEY                            ;2
       STA    WSYNC                   ;3
       STA    HMOVE                   ;3
       RTS                            ;6



LFCCF:
       LDX    #$00                    ;2
       STX    GRP1                    ;3
LFCD3:
       STX    GRP0                    ;3
       STA    ENABL                   ;3
       DEY                            ;2
LFBD3:
       RTS                            ;6

LFCD9:
       STA    HMCLR                   ;3
       STA    WSYNC                   ;3
       STA    HMOVE                   ;3
       STA    GRP1                    ;3
       LDA    rBF+9                   ;3
       JMP    LFCD3                   ;3




;22
;used 11 times...changed to be an interrupt instead
LFBBE:
       STA    WSYNC                   ;3
       SEC                            ;2
LFBC1:
       SBC    #$0F                    ;2
       BCS    LFBC1                   ;2
       EOR    #$0F                    ;2
       ASL                            ;2
       ASL                            ;2
       ASL                            ;2
       ASL                            ;2
       ADC    #$90                    ;2
       STA    RESP0,X                 ;4
       STA    WSYNC                   ;3
       STA    HMP0,X                  ;4
       rti                            ;6





;16
;     XXX..X XX XX
;    XXXX..XXXXXX
;   XX  X..XXX X X
;  XX XX ..XXXXXXX
; XX XXXX.. XXXXXXX
;XXX X  X.. XXXX XX
; XX X  X.. XXXXX
; XX XXXX.. XX
; XXX XX ..XX
;  XXX  X..XX
;  XXXXXX..XX
;   XXXXX..X
;  XXX  X..XX 
; XXX    ..XXX  
;XX XX  X..X XX
;XXX XX  ..XX XX




;Bear_Walk1l_gfx:
       .byte %11101100
       .byte %11011001
       .byte %01110000
       .byte %00111001
       .byte %00011111
       .byte %00111111
       .byte %00111001
       .byte %01110110
       .byte %01101111
       .byte %01101001
       .byte %11101001
       .byte %01101111
       .byte %00110110
       .byte %00011001
       .byte %00001111
       .byte %00000111

;Bear_Walk1r_gfx:
       .byte %11011000
       .byte %10110000
       .byte %11100000
       .byte %11000000
       .byte %10000000
       .byte %11000000
       .byte %11000000
       .byte %11000000
       .byte %01100000
       .byte %01111100
       .byte %01111011
       .byte %01111111
       .byte %11111110
       .byte %11101010
       .byte %11111100
       .byte %10110110


;16
;     XXX..X XX XX
;   XXXXX..XXXXXX
;  XXX  X..XXX X X
; XXX XX ..XXXXXXX
; XX XXXX.. XXXXXXX
;XXX X  X.. XXXX XX
; XX X  X.. XXXXX
; XX XXXX.. XX
; XXX XX ..XX
;  XXX  X..XX
;  XXXXXX..X
;  XXXXXX..X
;  XX   X..X
;  XX   X..X
;  XX   X..X
;  XXX  X..XX


;Bear_Walk2l_gfx:
       .byte %00111001
       .byte %00110001
       .byte %00110001
       .byte %00110001
       .byte %00111111
       .byte %00111111
       .byte %00111001
       .byte %01110110
       .byte %01101111
       .byte %01101001
       .byte %11101001
       .byte %01101111
       .byte %01110110
       .byte %00111001
       .byte %00011111
       .byte %00000111

;Bear_Walk2r_gfx:
       .byte %11000000
       .byte %10000000
       .byte %10000000
       .byte %10000000
       .byte %10000000
       .byte %10000000
       .byte %11000000
       .byte %11000000
       .byte %01100000
       .byte %01111100
       .byte %01111011
       .byte %01111111
       .byte %11111110
       .byte %11101010
       .byte %11111100
       .byte %10110110










;24
;X X  X  ..  X  X X
; XXX XXX..XXX XXX
;XXX  X X..X X  XXX
; XX  XXX..XXX  XX
; XXXX XX..XX XXXX
; XXXXX X..X XXXXX
;  XXXXX .. XXXXX
;  XXXXXX..XXXXXX
;  XXXXX .. XXXXX
;   XXX X..X XXX
;   XX XX..XX XX
;  XXX X .. X XXX
;  XXX X .. X XXX
;  XXX XX..XX XXX
;  XXXX X..X XXXX
;  XXXXX .. XXXXX
;  XXXXXX..XXXXXX
;   XXXXX..XXXXX
;    XXXX..XXXX
;    XXX .. XXX
;    XXX .. XXX
;    XXX .. XXX
;    XXX .. XXX
;   XXXX .. XXXX



;Bear_Hitl_gfx:
       .byte %00011110
       .byte %00001110
       .byte %00001110
       .byte %00001110
       .byte %00001110
       .byte %00001111
       .byte %00011111
       .byte %00111111
       .byte %00111110
       .byte %00111101
       .byte %00111011
       .byte %00111010
       .byte %00111010
       .byte %00011011
       .byte %00011101
       .byte %00111110
       .byte %00111111
       .byte %00111110
       .byte %01111101
       .byte %01111011
       .byte %01100111
       .byte %11100101
       .byte %01110111
       .byte %10100100

;Bear_Hitr_gfx:
       .byte %01111000
       .byte %01110000
       .byte %01110000
       .byte %01110000
       .byte %01110000
       .byte %11110000
       .byte %11111000
       .byte %11111100
       .byte %01111100
       .byte %10111100
       .byte %11011100
       .byte %01011100
       .byte %01011100
       .byte %11011000
       .byte %10111000
       .byte %01111100
       .byte %11111100
       .byte %01111100
       .byte %10111110
       .byte %11011110
       .byte %11100110
       .byte %10100111
       .byte %11101110
       .byte %00100101










       ORG $1A00
       RORG $DA00

Duck_gfx: ;bank1
       .byte $1C ; |   XXX  | $FE00
       .byte $04 ; |     X  | $FE01
       .byte $1C ; |   XXX  | $FE02
       .byte $3E ; |  XXXXX | $FE03
       .byte $63 ; | XX   XX| $FE04
       .byte $7B ; | XXXX XX| $FE05
       .byte $3F ; |  XXXXXX| $FE06
       .byte $3D ; |  XXXX X| $FE07
       .byte $18 ; |   XX   | $FE08
       .byte $1C ; |   XXX  | $FE09
       .byte $BE ; |X XXXXX | $FE0A
       .byte $7F ; | XXXXXXX| $FE0B
       .byte $37 ; |  XX XXX| $FE0C
       .byte $5E ; | X XXXX | $FE0D
       .byte $8C ; |X   XX  | $FE0E
       .byte $18 ; |   XX   | $FE0F color

Bunny_gfx: ;bank1
       .byte $FE ; |XXXXXXX | $FE10
       .byte $7F ; | XXXXXXX| $FE11
       .byte $0F ; |    XXXX| $FE12
       .byte $9E ; |X  XXXX | $FE13
       .byte $FE ; |XXXXXXX | $FE14
       .byte $7E ; | XXXXXX | $FE15
       .byte $3C ; |  XXXX  | $FE16
       .byte $78 ; | XXXX   | $FE17
       .byte $FC ; |XXXXXX  | $FE18
       .byte $6C ; | XX XX  | $FE19
       .byte $3C ; |  XXXX  | $FE1A
       .byte $0C ; |    XX  | $FE1B
       .byte $0C ; |    XX  | $FE1C
       .byte $1A ; |   XX X | $FE1D
       .byte $31 ; |  XX   X| $FE1E
       .byte $0A ; |    X X | $FE1F color

Owl_gfx: ;bank1
       .byte $66 ; | XX  XX | $FE20
       .byte $3C ; |  XXXX  | $FE21
       .byte $BD ; |X XXXX X| $FE22
       .byte $FF ; |XXXXXXXX| $FE23
       .byte $FF ; |XXXXXXXX| $FE24
       .byte $FF ; |XXXXXXXX| $FE25
       .byte $FF ; |XXXXXXXX| $FE26
       .byte $FF ; |XXXXXXXX| $FE27
       .byte $7E ; | XXXXXX | $FE28
       .byte $F7 ; |XXXX XXX| $FE29
       .byte $C9 ; |XX  X  X| $FE2A
       .byte $C9 ; |XX  X  X| $FE2B
       .byte $FF ; |XXXXXXXX| $FE2C
       .byte $7E ; | XXXXXX | $FE2D
       .byte $81 ; |X      X| $FE2E
       .byte $48 ; | X  X   | $FE2F color

Shot_gfx: ;bank1
       .byte $FF ; |XXXXXXXX| $FE30
       .byte $E7 ; |XXX  XXX| $FE31
       .byte $DB ; |XX XX XX| $FE32
       .byte $DB ; |XX XX XX| $FE33
       .byte $E7 ; |XXX  XXX| $FE34
       .byte $DB ; |XX XX XX| $FE35
       .byte $DB ; |XX XX XX| $FE36
       .byte $E7 ; |XXX  XXX| $FE37
       .byte $FF ; |XXXXXXXX| $FE38
       .byte $00 ; |        | $FE39
       .byte $00 ; |        | $FE3A
       .byte $00 ; |        | $FE3B
       .byte $00 ; |        | $FE3C
       .byte $00 ; |        | $FE3D
       .byte $00 ; |        | $FE3E
       .byte $0A ; |    X X | $FE3F color

       .byte $00 ; |        | $FE60
       .byte $00 ; |        | $FE61
       .byte $00 ; |        | $FE62
       .byte $00 ; |        | $FE63
       .byte $00 ; |        | $FE64
       .byte $00 ; |        | $FE65
       .byte $00 ; |        | $FE66
       .byte $00 ; |        | $FE67
       .byte $00 ; |        | $FE68
       .byte $00 ; |        | $FE69
       .byte $00 ; |        | $FE6A
       .byte $00 ; |        | $FE6B
       .byte $00 ; |        | $FE6C
       .byte $00 ; |        | $FE6D
       .byte $00 ; |        | $FE6E
       .byte $00 ; |        | $FE6F

       .byte $00 ; |        | $FE60
       .byte $00 ; |        | $FE61
       .byte $00 ; |        | $FE62
       .byte $00 ; |        | $FE63
       .byte $00 ; |        | $FE64
       .byte $00 ; |        | $FE65
       .byte $00 ; |        | $FE66
       .byte $00 ; |        | $FE67
       .byte $00 ; |        | $FE68
       .byte $00 ; |        | $FE69
       .byte $00 ; |        | $FE6A
       .byte $00 ; |        | $FE6B
       .byte $00 ; |        | $FE6C
       .byte $00 ; |        | $FE6D
       .byte $00 ; |        | $FE6E
       .byte $00 ; |        | $FE6F

       .byte $00 ; |        | $FE60
       .byte $00 ; |        | $FE61
       .byte $00 ; |        | $FE62
       .byte $00 ; |        | $FE63
       .byte $00 ; |        | $FE64
       .byte $00 ; |        | $FE65
       .byte $00 ; |        | $FE66
       .byte $00 ; |        | $FE67
       .byte $00 ; |        | $FE68
       .byte $00 ; |        | $FE69
       .byte $00 ; |        | $FE6A
       .byte $00 ; |        | $FE6B
       .byte $00 ; |        | $FE6C
       .byte $00 ; |        | $FE6D
       .byte $00 ; |        | $FE6E
       .byte $00 ; |        | $FE6F

Blank_Object_gfx:
       .byte $00 ; |        | $FE70
       .byte $00 ; |        | $FE71
       .byte $00 ; |        | $FE72
       .byte $00 ; |        | $FE73
       .byte $00 ; |        | $FE74
       .byte $00 ; |        | $FE75
       .byte $00 ; |        | $FE76
       .byte $00 ; |        | $FE77
       .byte $00 ; |        | $FE78
       .byte $00 ; |        | $FE79
       .byte $00 ; |        | $FE7A
       .byte $00 ; |        | $FE7B
       .byte $00 ; |        | $FE7C
       .byte $00 ; |        | $FE7D
       .byte $00 ; |        | $FE7E
       .byte $00 ; |        | $FE7F



       ORG $1B00
       RORG $DB00

;Duck_gfx: ;bank1
       .byte $1C ; |   XXX  | $FE00
       .byte $04 ; |     X  | $FE01
       .byte $1C ; |   XXX  | $FE02
       .byte $3E ; |  XXXXX | $FE03
       .byte $63 ; | XX   XX| $FE04
       .byte $7B ; | XXXX XX| $FE05
       .byte $3F ; |  XXXXXX| $FE06
       .byte $3D ; |  XXXX X| $FE07
       .byte $18 ; |   XX   | $FE08
       .byte $1C ; |   XXX  | $FE09
       .byte $3E ; |  XXXXX | $FE0A
       .byte $FF ; |XXXXXXXX| $FE0B
       .byte $F7 ; |XXXX XXX| $FE0C
       .byte $1E ; |   XXXX | $FE0D
       .byte $0C ; |    XX  | $FE0E
       .byte $18 ; |   XX   | $FE0F color

;Bunny_gfx: ;bank1
       .byte $FE ; |XXXXXXX | $FE10
       .byte $7F ; | XXXXXXX| $FE11
       .byte $9E ; |X  XXXX | $FE13
       .byte $FE ; |XXXXXXX | $FE14
       .byte $7E ; | XXXXXX | $FE15
       .byte $3C ; |  XXXX  | $FE16
       .byte $78 ; | XXXX   | $FE17
       .byte $FC ; |XXXXXX  | $FE18
       .byte $6C ; | XX XX  | $FE19
       .byte $3C ; |  XXXX  | $FE1A
       .byte $0C ; |    XX  | $FE1B
       .byte $0C ; |    XX  | $FE1C
       .byte $3B ; |  XXX XX| $FE1D
       .byte $00 ; |        | $FE1E
       .byte $00 ; |        | $FE1C
       .byte $0A ; |    X X | $FE1F color

;Owl_gfx: ;bank1
       .byte $66 ; | XX  XX | $FE20
       .byte $3C ; |  XXXX  | $FE21
       .byte $BD ; |X XXXX X| $FE22
       .byte $FF ; |XXXXXXXX| $FE23
       .byte $FF ; |XXXXXXXX| $FE24
       .byte $FF ; |XXXXXXXX| $FE25
       .byte $FF ; |XXXXXXXX| $FE26
       .byte $FF ; |XXXXXXXX| $FE27
       .byte $7E ; | XXXXXX | $FE28
       .byte $EF ; |XXX XXXX| $FE29
       .byte $93 ; |X  X  XX| $FE2A
       .byte $93 ; |X  X  XX| $FE2B
       .byte $FF ; |XXXXXXXX| $FE2C
       .byte $7E ; | XXXXXX | $FE2D
       .byte $81 ; |X      X| $FE2E
       .byte $48 ; | X  X   | $FE2F color

;Shot_gfx: ;bank1
       .byte $FF ; |XXXXXXXX| $FE30
       .byte $E7 ; |XXX  XXX| $FE31
       .byte $DB ; |XX XX XX| $FE32
       .byte $DB ; |XX XX XX| $FE33
       .byte $E7 ; |XXX  XXX| $FE34
       .byte $DB ; |XX XX XX| $FE35
       .byte $DB ; |XX XX XX| $FE36
       .byte $E7 ; |XXX  XXX| $FE37
       .byte $FF ; |XXXXXXXX| $FE38
       .byte $00 ; |        | $FE39
       .byte $00 ; |        | $FE3A
       .byte $00 ; |        | $FE3B
       .byte $00 ; |        | $FE3C
       .byte $00 ; |        | $FE3D
       .byte $00 ; |        | $FE3E
       .byte $1A ; |    X X | $FE3F color

       .byte $00 ; |        | $FE60
       .byte $00 ; |        | $FE61
       .byte $00 ; |        | $FE62
       .byte $00 ; |        | $FE63
       .byte $00 ; |        | $FE64
       .byte $00 ; |        | $FE65
       .byte $00 ; |        | $FE66
       .byte $00 ; |        | $FE67
       .byte $00 ; |        | $FE68
       .byte $00 ; |        | $FE69
       .byte $00 ; |        | $FE6A
       .byte $00 ; |        | $FE6B
       .byte $00 ; |        | $FE6C
       .byte $00 ; |        | $FE6D
       .byte $00 ; |        | $FE6E
       .byte $00 ; |        | $FE6F

       .byte $00 ; |        | $FE60
       .byte $00 ; |        | $FE61
       .byte $00 ; |        | $FE62
       .byte $00 ; |        | $FE63
       .byte $00 ; |        | $FE64
       .byte $00 ; |        | $FE65
       .byte $00 ; |        | $FE66
       .byte $00 ; |        | $FE67
       .byte $00 ; |        | $FE68
       .byte $00 ; |        | $FE69
       .byte $00 ; |        | $FE6A
       .byte $00 ; |        | $FE6B
       .byte $00 ; |        | $FE6C
       .byte $00 ; |        | $FE6D
       .byte $00 ; |        | $FE6E
       .byte $00 ; |        | $FE6F

       .byte $00 ; |        | $FE60
       .byte $00 ; |        | $FE61
       .byte $00 ; |        | $FE62
       .byte $00 ; |        | $FE63
       .byte $00 ; |        | $FE64
       .byte $00 ; |        | $FE65
       .byte $00 ; |        | $FE66
       .byte $00 ; |        | $FE67
       .byte $00 ; |        | $FE68
       .byte $00 ; |        | $FE69
       .byte $00 ; |        | $FE6A
       .byte $00 ; |        | $FE6B
       .byte $00 ; |        | $FE6C
       .byte $00 ; |        | $FE6D
       .byte $00 ; |        | $FE6E
       .byte $00 ; |        | $FE6F

;Blank_Object_gfx:
       .byte $00 ; |        | $FE70
       .byte $00 ; |        | $FE71
       .byte $00 ; |        | $FE72
       .byte $00 ; |        | $FE73
       .byte $00 ; |        | $FE74
       .byte $00 ; |        | $FE75
       .byte $00 ; |        | $FE76
       .byte $00 ; |        | $FE77
       .byte $00 ; |        | $FE78
       .byte $00 ; |        | $FE79
       .byte $00 ; |        | $FE7A
       .byte $00 ; |        | $FE7B
       .byte $00 ; |        | $FE7C
       .byte $00 ; |        | $FE7D
       .byte $00 ; |        | $FE7E
       .byte $00 ; |        | $FE7F



       ORG $1C00
       RORG $DC00

Bird_Page1:
;bank1
       .byte $00 ; |        | $FC00
       .byte $00 ; |        | $FC01
       .byte $00 ; |        | $FC02
       .byte $00 ; |        | $FC03
       .byte $00 ; |        | $FC04
       .byte $00 ; |        | $FC05
       .byte $00 ; |        | $FC06
       .byte $00 ; |        | $FC07
       .byte $00 ; |        | $FC08
       .byte $00 ; |        | $FC09
       .byte $00 ; |        | $FC0A
       .byte $00 ; |        | $FC0B
       .byte $00 ; |        | $FC0C
       .byte $00 ; |        | $FC0D
       .byte $00 ; |        | $FC0E
       .byte $00 ; |        | $FC0F
       .byte $00 ; |        | $FC10
       .byte $00 ; |        | $FC11
       .byte $00 ; |        | $FC12
       .byte $00 ; |        | $FC13
       .byte $03 ; |      XX| $FC14
       .byte $07 ; |     XXX| $FC15
       .byte $03 ; |      XX| $FC16
       .byte $01 ; |       X| $FC17
       .byte $03 ; |      XX| $FC18
       .byte $03 ; |      XX| $FC19
       .byte $07 ; |     XXX| $FC1A
       .byte $07 ; |     XXX| $FC1B
       .byte $0F ; |    XXXX| $FC1C
       .byte $1F ; |   XXXXX| $FC1D
       .byte $1E ; |   XXXX | $FC1E
       .byte $BF ; |X XXXXXX| $FC1F
       .byte $B1 ; |X XX   X| $FC20
       .byte $E0 ; |XXX     | $FC21
       .byte $C0 ; |XX      | $FC22

       .byte $00 ; |        | $FC23
       .byte $00 ; |        | $FC24
       .byte $00 ; |        | $FC25
       .byte $00 ; |        | $FC26
       .byte $00 ; |        | $FC27
       .byte $00 ; |        | $FC28
       .byte $00 ; |        | $FC29
       .byte $00 ; |        | $FC2A
       .byte $00 ; |        | $FC2B
       .byte $00 ; |        | $FC2C
       .byte $00 ; |        | $FC2D
       .byte $00 ; |        | $FC2E
       .byte $00 ; |        | $FC2F
       .byte $00 ; |        | $FC30
       .byte $00 ; |        | $FC31
       .byte $00 ; |        | $FC32
       .byte $00 ; |        | $FC33
       .byte $00 ; |        | $FC34
       .byte $00 ; |        | $FC35
       .byte $00 ; |        | $FC36
       .byte $C0 ; |XX      | $FC37
       .byte $E0 ; |XXX     | $FC38
       .byte $C0 ; |XX      | $FC39
       .byte $80 ; |X       | $FC3A
       .byte $C0 ; |XX      | $FC3B
       .byte $C0 ; |XX      | $FC3C
       .byte $E0 ; |XXX     | $FC3D
       .byte $E0 ; |XXX     | $FC3E
       .byte $70 ; | XXX    | $FC3F
       .byte $78 ; | XXXX   | $FC40
       .byte $B8 ; |X XXX   | $FC41
       .byte $FD ; |XXXXXX X| $FC42
       .byte $CD ; |XX  XX X| $FC43
       .byte $87 ; |X    XXX| $FC44
       .byte $03 ; |      XX| $FC45

       .byte $00 ; |        | $FC46
       .byte $00 ; |        | $FC47
       .byte $00 ; |        | $FC48
       .byte $00 ; |        | $FC49
       .byte $00 ; |        | $FC4A
       .byte $00 ; |        | $FC4B
       .byte $00 ; |        | $FC4C
       .byte $00 ; |        | $FC4D
       .byte $00 ; |        | $FC4E
       .byte $00 ; |        | $FC4F
       .byte $00 ; |        | $FC50
       .byte $00 ; |        | $FC51
       .byte $00 ; |        | $FC52
       .byte $00 ; |        | $FC53
       .byte $00 ; |        | $FC54
       .byte $00 ; |        | $FC55
       .byte $00 ; |        | $FC56
       .byte $00 ; |        | $FC57
       .byte $00 ; |        | $FC58
       .byte $00 ; |        | $FC59
       .byte $0C ; |    XX  | $FC5A
       .byte $1E ; |   XXXX | $FC5B
       .byte $3F ; |  XXXXXX| $FC5C
       .byte $3F ; |  XXXXXX| $FC5D
       .byte $7F ; | XXXXXXX| $FC5E
       .byte $77 ; | XXX XXX| $FC5F
       .byte $C7 ; |XX   XXX| $FC60
       .byte $CF ; |XX  XXXX| $FC61
       .byte $1F ; |   XXXXX| $FC62
       .byte $1F ; |   XXXXX| $FC63
       .byte $3E ; |  XXXXX | $FC64
       .byte $7B ; | XXXX XX| $FC65
       .byte $71 ; | XXX   X| $FC66
       .byte $E0 ; |XXX     | $FC67
       .byte $C0 ; |XX      | $FC68

       .byte $00 ; |        | $FC69
       .byte $00 ; |        | $FC6A
       .byte $00 ; |        | $FC6B
       .byte $00 ; |        | $FC6C
       .byte $00 ; |        | $FC6D
       .byte $00 ; |        | $FC6E
       .byte $00 ; |        | $FC6F
       .byte $00 ; |        | $FC70
       .byte $00 ; |        | $FC71
       .byte $00 ; |        | $FC72
       .byte $00 ; |        | $FC73
       .byte $00 ; |        | $FC74
       .byte $00 ; |        | $FC75
       .byte $00 ; |        | $FC76
       .byte $00 ; |        | $FC77
       .byte $00 ; |        | $FC78
       .byte $00 ; |        | $FC79
       .byte $00 ; |        | $FC7A
       .byte $00 ; |        | $FC7B
       .byte $00 ; |        | $FC7C
       .byte $00 ; |        | $FC7D
       .byte $00 ; |        | $FC7E
       .byte $00 ; |        | $FC7F
       .byte $80 ; |X       | $FC80
       .byte $80 ; |X       | $FC81
       .byte $C0 ; |XX      | $FC82
       .byte $E0 ; |XXX     | $FC83
       .byte $F0 ; |XXXX    | $FC84
       .byte $70 ; | XXX    | $FC85
       .byte $78 ; | XXXX   | $FC86
       .byte $BC ; |X XXXX  | $FC87
       .byte $FC ; |XXXXXX  | $FC88
       .byte $CE ; |XX  XXX | $FC89
       .byte $87 ; |X    XXX| $FC8A
       .byte $03 ; |      XX| $FC8B

;Blank_Duck_gfx:
       .byte $00 ; |        | $FC8C
       .byte $00 ; |        | $FC8D
       .byte $00 ; |        | $FC8E
       .byte $00 ; |        | $FC8F
       .byte $00 ; |        | $FC90
       .byte $00 ; |        | $FC91
       .byte $00 ; |        | $FC92
       .byte $00 ; |        | $FC93
       .byte $00 ; |        | $FC94
       .byte $00 ; |        | $FC95
       .byte $00 ; |        | $FC96
       .byte $00 ; |        | $FC97
       .byte $00 ; |        | $FC98
       .byte $00 ; |        | $FC99
       .byte $00 ; |        | $FC9A
       .byte $00 ; |        | $FC9B
       .byte $00 ; |        | $FC9C
       .byte $00 ; |        | $FC9D
       .byte $00 ; |        | $FC9E
       .byte $00 ; |        | $FC9F
;Extra_gfx: ;bank1
       .byte $00 ; |        | $FCA0 shared
       .byte $00 ; |        | $FCA1 shared
       .byte $00 ; |        | $FCA2 shared
       .byte $00 ; |        | $FCA3 shared
       .byte $00 ; |        | $FCA4 shared
       .byte $00 ; |        | $FCA5 shared
       .byte $00 ; |        | $FCA6 shared
;bank1
;Add_Bullet1_gfx:
       .byte $4A ; | X  X X | $FB22
       .byte $4A ; | X  X X | $FB23
       .byte $4A ; | X  X X | $FB24
       .byte $EA ; |XXX X X | $FB26
       .byte $40 ; | X      | $FB28
       .byte $40 ; | X      | $FB29
       .byte $40 ; | X      | $FB2A
;Add_Bullet2_gfx:
       .byte $AA ; |X X X X | $FB2F
       .byte $AA ; |X X X X | $FB30
       .byte $AA ; |X X X X | $FB31
       .byte $AA ; |X X X X | $FB32
       .byte $00 ; |        | $FB2C
       .byte $00 ; |        | $FB2D
       .byte $00 ; |        | $FB2E
;Add_Bullet3_gfx:
       .byte $A8 ; |X X X   | $FB38
       .byte $A8 ; |X X X   | $FB39
       .byte $A8 ; |X X X   | $FB3A
       .byte $A8 ; |X X X   | $FB3B
       .byte $00 ; |        | $FB2C
       .byte $00 ; |        | $FB2D
       .byte $00 ; |        | $FB2E
;Add_Bullet4_gfx:
       .byte $A0 ; |X X     | $FB41
       .byte $A0 ; |X X     | $FB42
       .byte $A0 ; |X X     | $FB43
       .byte $A0 ; |X X     | $FB44
       .byte $00 ; |        | $FB2C
       .byte $00 ; |        | $FB2D
       .byte $00 ; |        | $FB2E
;Add_Bullet5_gfx:
       .byte $80 ; |X       | $FB4A
       .byte $80 ; |X       | $FB4B
       .byte $80 ; |X       | $FB4C
       .byte $80 ; |X       | $FB4D
       .byte $00 ; |        | $FB50
       .byte $00 ; |        | $FB51
       .byte $00 ; |        | $FB52
;Double_Zero_gfx:
       .byte $22 ; |  X   X | $FB5C
       .byte $77 ; | XXX XXX| $FB5D
       .byte $55 ; | X X X X| $FB5E
       .byte $55 ; | X X X X| $FB5F
       .byte $55 ; | X X X X| $FB62
       .byte $77 ; | XXX XXX| $FB63
       .byte $22 ; |  X   X | $FB64
;Add_100_gfx:
       .byte $47 ; | X   XXX| $FB69
       .byte $42 ; | X    X | $FB6B
       .byte $42 ; | X    X | $FB6B
       .byte $E2 ; |XXX   X | $FB6D
       .byte $42 ; | X    X | $FB6F
       .byte $46 ; | X   XX | $FB70
       .byte $42 ; | X    X | $FB71
;Add_200_gfx:
       .byte $47 ; | X   XXX| $FB76
       .byte $44 ; | X   X  | $FB77
       .byte $42 ; | X    X | $FB78
       .byte $E1 ; |XXX    X| $FB7A
       .byte $45 ; | X   X X| $FB7C
       .byte $47 ; | X   XXX| $FB7D
;Add_300_gfx:
       .byte $42 ; | X    X | $FB83 shared
       .byte $47 ; | X   XXX| $FB84
       .byte $41 ; | X     X| $FB85
       .byte $E3 ; |XXX   XX| $FB87
       .byte $41 ; | X     X| $FB89
       .byte $47 ; | X   XXX| $FB8A
;Add_500_gfx:
       .byte $42 ; | X    X | $FB9D shared
       .byte $47 ; | X   XXX| $FB9E
       .byte $45 ; | X   X X| $FB9F
       .byte $E1 ; |XXX    X| $FBA1
       .byte $47 ; | X   XX | $FBA3
       .byte $44 ; | X   X  | $FBA4
       .byte $47 ; | X   XXX| $FBA5
;Add_400_gfx:
       .byte $41 ; | X     X| $FB90
       .byte $41 ; | X     X| $FB91
       .byte $41 ; | X     X| $FB92
       .byte $E7 ; |XXX  XXX| $FB94
       .byte $45 ; | X   X X| $FB96
       .byte $45 ; | X   X X| $FB97
       .byte $45 ; | X   X X| $FB98
;Subtract_Bullet_gfx:
       .byte $0A ; |    X X | $FBAA
       .byte $0A ; |    X X | $FBAB
       .byte $0A ; |    X X | $FBAC
       .byte $EA ; |XXX X X | $FBAD
       .byte $00 ; |        | $FBB0
       .byte $00 ; |        | $FB2B
       .byte $00 ; |        | $FB2C
;Subtract_500_gfx:
       .byte $02 ; |      X | $FBB5
       .byte $07 ; |     XXX| $FBB6
       .byte $05 ; |     X X| $FBB7
       .byte $E1 ; |XXX    X| $FBB9
       .byte $06 ; |     XX | $FBBB
       .byte $04 ; |     X  | $FBBC
       .byte $07 ; |     XXX| $FBBD


       ORG $1D00
       RORG $DD00

Bird_Page2:
;bank1
       .byte $00 ; |        | $FC00
       .byte $00 ; |        | $FC01
       .byte $00 ; |        | $FC02
       .byte $00 ; |        | $FC03
       .byte $00 ; |        | $FC04
       .byte $00 ; |        | $FC05
       .byte $00 ; |        | $FC06
       .byte $00 ; |        | $FC07
       .byte $00 ; |        | $FC08
       .byte $00 ; |        | $FC09
       .byte $00 ; |        | $FC0A
       .byte $00 ; |        | $FC0B
       .byte $00 ; |        | $FC0C
       .byte $00 ; |        | $FC0D
       .byte $00 ; |        | $FC0E
       .byte $00 ; |        | $FC0F
       .byte $00 ; |        | $FC10
       .byte $00 ; |        | $FC11
       .byte $00 ; |        | $FC12
       .byte $00 ; |        | $FC13
       .byte $03 ; |      XX| $FC14
       .byte $07 ; |     XXX| $FC15
       .byte $03 ; |      XX| $FC16
       .byte $01 ; |       X| $FC17
       .byte $03 ; |      XX| $FC18
       .byte $03 ; |      XX| $FC19
       .byte $07 ; |     XXX| $FC1A
       .byte $07 ; |     XXX| $FC1B
       .byte $0F ; |    XXXX| $FC1C
       .byte $9F ; |X  XXXXX| $FC1D
       .byte $DE ; |XX XXXX | $FC1E
       .byte $FF ; |XXXXXXXX| $FC1F
       .byte $71 ; | XXX   X| $FC20
       .byte $00 ; |        | $FC21
       .byte $00 ; |        | $FC22

       .byte $00 ; |        | $FC23
       .byte $00 ; |        | $FC24
       .byte $00 ; |        | $FC25
       .byte $00 ; |        | $FC26
       .byte $00 ; |        | $FC27
       .byte $00 ; |        | $FC28
       .byte $00 ; |        | $FC29
       .byte $00 ; |        | $FC2A
       .byte $00 ; |        | $FC2B
       .byte $00 ; |        | $FC2C
       .byte $00 ; |        | $FC2D
       .byte $00 ; |        | $FC2E
       .byte $00 ; |        | $FC2F
       .byte $00 ; |        | $FC30
       .byte $00 ; |        | $FC31
       .byte $00 ; |        | $FC32
       .byte $00 ; |        | $FC33
       .byte $00 ; |        | $FC34
       .byte $00 ; |        | $FC35
       .byte $00 ; |        | $FC36
       .byte $C0 ; |XX      | $FC37
       .byte $E0 ; |XXX     | $FC38
       .byte $C0 ; |XX      | $FC39
       .byte $80 ; |X       | $FC3A
       .byte $C0 ; |XX      | $FC3B
       .byte $C0 ; |XX      | $FC3C
       .byte $E0 ; |XXX     | $FC3D
       .byte $E0 ; |XXX     | $FC3E
       .byte $70 ; | XXX    | $FC3F
       .byte $79 ; | XXXX  X| $FC40
       .byte $BB ; |X XXX XX| $FC41
       .byte $FF ; |XXXXXXXX| $FC42
       .byte $CE ; |XX  XXX | $FC43
       .byte $80 ; |X       | $FC44
       .byte $00 ; |        | $FC45

       .byte $00 ; |        | $FC46
       .byte $00 ; |        | $FC47
       .byte $00 ; |        | $FC48
       .byte $00 ; |        | $FC49
       .byte $00 ; |        | $FC4A
       .byte $00 ; |        | $FC4B
       .byte $00 ; |        | $FC4C
       .byte $00 ; |        | $FC4D
       .byte $00 ; |        | $FC4E
       .byte $00 ; |        | $FC4F
       .byte $00 ; |        | $FC50
       .byte $00 ; |        | $FC51
       .byte $00 ; |        | $FC52
       .byte $00 ; |        | $FC53
       .byte $00 ; |        | $FC54
       .byte $00 ; |        | $FC55
       .byte $00 ; |        | $FC56
       .byte $00 ; |        | $FC57
       .byte $00 ; |        | $FC58
       .byte $00 ; |        | $FC59
       .byte $0C ; |    XX  | $FC5A
       .byte $1E ; |   XXXX | $FC5B
       .byte $3F ; |  XXXXXX| $FC5C
       .byte $3F ; |  XXXXXX| $FC5D
       .byte $7F ; | XXXXXXX| $FC5E
       .byte $F7 ; |XXXX XXX| $FC5F
       .byte $C7 ; |XX   XXX| $FC60
       .byte $0F ; |    XXXX| $FC61
       .byte $9F ; |X  XXXXX| $FC62
       .byte $DF ; |XX XXXXX| $FC63
       .byte $FE ; |XXXXXXX | $FC64
       .byte $7B ; | XXXX XX| $FC65
       .byte $01 ; |       X| $FC66
       .byte $00 ; |        | $FC67
       .byte $00 ; |        | $FC68

       .byte $00 ; |        | $FC69
       .byte $00 ; |        | $FC6A
       .byte $00 ; |        | $FC6B
       .byte $00 ; |        | $FC6C
       .byte $00 ; |        | $FC6D
       .byte $00 ; |        | $FC6E
       .byte $00 ; |        | $FC6F
       .byte $00 ; |        | $FC70
       .byte $00 ; |        | $FC71
       .byte $00 ; |        | $FC72
       .byte $00 ; |        | $FC73
       .byte $00 ; |        | $FC74
       .byte $00 ; |        | $FC75
       .byte $00 ; |        | $FC76
       .byte $00 ; |        | $FC77
       .byte $00 ; |        | $FC78
       .byte $00 ; |        | $FC79
       .byte $00 ; |        | $FC7A
       .byte $00 ; |        | $FC7B
       .byte $00 ; |        | $FC7C
       .byte $00 ; |        | $FC7D
       .byte $00 ; |        | $FC7E
       .byte $00 ; |        | $FC7F
       .byte $80 ; |X       | $FC80
       .byte $80 ; |X       | $FC81
       .byte $C0 ; |XX      | $FC82
       .byte $E0 ; |XXX     | $FC83
       .byte $F0 ; |XXXX    | $FC84
       .byte $71 ; | XXX   X| $FC85
       .byte $7B ; | XXXX XX| $FC86
       .byte $BF ; |X XXXXXX| $FC87
       .byte $FE ; |XXXXXXX | $FC88
       .byte $C0 ; |XX      | $FC89
       .byte $80 ; |X       | $FC8A
       .byte $00 ; |        | $FC8B

Blank_Duck_gfx:
       .byte $00 ; |        | $FC8C
       .byte $00 ; |        | $FC8D
       .byte $00 ; |        | $FC8E
       .byte $00 ; |        | $FC8F
       .byte $00 ; |        | $FC90
       .byte $00 ; |        | $FC91
       .byte $00 ; |        | $FC92
       .byte $00 ; |        | $FC93
       .byte $00 ; |        | $FC94
       .byte $00 ; |        | $FC95
       .byte $00 ; |        | $FC96
       .byte $00 ; |        | $FC97
       .byte $00 ; |        | $FC98
       .byte $00 ; |        | $FC99
       .byte $00 ; |        | $FC9A
       .byte $00 ; |        | $FC9B
       .byte $00 ; |        | $FC9C
       .byte $00 ; |        | $FC9D
       .byte $00 ; |        | $FC9E
       .byte $00 ; |        | $FC9F
Extra_gfx: ;bank1
       .byte $00 ; |        | $FCA0 shared
       .byte $00 ; |        | $FCA1 shared
       .byte $00 ; |        | $FCA2 shared
       .byte $00 ; |        | $FCA3 shared
       .byte $00 ; |        | $FCA4 shared
       .byte $00 ; |        | $FCA5 shared
       .byte $00 ; |        | $FCA6 shared
;bank1
Add_Bullet1_gfx:
       .byte $4A ; | X  X X | $FB22
       .byte $4A ; | X  X X | $FB23
       .byte $4A ; | X  X X | $FB24
       .byte $EA ; |XXX X X | $FB26
       .byte $40 ; | X      | $FB28
       .byte $40 ; | X      | $FB29
       .byte $40 ; | X      | $FB2A
Add_Bullet2_gfx:
       .byte $AA ; |X X X X | $FB2F
       .byte $AA ; |X X X X | $FB30
       .byte $AA ; |X X X X | $FB31
       .byte $AA ; |X X X X | $FB32
       .byte $00 ; |        | $FB2C
       .byte $00 ; |        | $FB2D
       .byte $00 ; |        | $FB2E
Add_Bullet3_gfx:
       .byte $A8 ; |X X X   | $FB38
       .byte $A8 ; |X X X   | $FB39
       .byte $A8 ; |X X X   | $FB3A
       .byte $A8 ; |X X X   | $FB3B
       .byte $00 ; |        | $FB2C
       .byte $00 ; |        | $FB2D
       .byte $00 ; |        | $FB2E
Add_Bullet4_gfx:
       .byte $A0 ; |X X     | $FB41
       .byte $A0 ; |X X     | $FB42
       .byte $A0 ; |X X     | $FB43
       .byte $A0 ; |X X     | $FB44
       .byte $00 ; |        | $FB2C
       .byte $00 ; |        | $FB2D
       .byte $00 ; |        | $FB2E
Add_Bullet5_gfx:
       .byte $80 ; |X       | $FB4A
       .byte $80 ; |X       | $FB4B
       .byte $80 ; |X       | $FB4C
       .byte $80 ; |X       | $FB4D
       .byte $00 ; |        | $FB50
       .byte $00 ; |        | $FB51
       .byte $00 ; |        | $FB52
Double_Zero_gfx:
       .byte $22 ; |  X   X | $FB5C
       .byte $77 ; | XXX XXX| $FB5D
       .byte $55 ; | X X X X| $FB5E
       .byte $55 ; | X X X X| $FB5F
       .byte $55 ; | X X X X| $FB62
       .byte $77 ; | XXX XXX| $FB63
       .byte $22 ; |  X   X | $FB64
Add_100_gfx:
       .byte $47 ; | X   XXX| $FB69
       .byte $42 ; | X    X | $FB6B
       .byte $42 ; | X    X | $FB6B
       .byte $E2 ; |XXX   X | $FB6D
       .byte $42 ; | X    X | $FB6F
       .byte $46 ; | X   XX | $FB70
       .byte $42 ; | X    X | $FB71
Add_200_gfx:
       .byte $47 ; | X   XXX| $FB76
       .byte $44 ; | X   X  | $FB77
       .byte $42 ; | X    X | $FB78
       .byte $E1 ; |XXX    X| $FB7A
       .byte $45 ; | X   X X| $FB7C
       .byte $47 ; | X   XXX| $FB7D
Add_300_gfx:
       .byte $42 ; | X    X | $FB83 shared
       .byte $47 ; | X   XXX| $FB84
       .byte $41 ; | X     X| $FB85
       .byte $E3 ; |XXX   XX| $FB87
       .byte $41 ; | X     X| $FB89
       .byte $47 ; | X   XXX| $FB8A
Add_500_gfx:
       .byte $42 ; | X    X | $FB9D shared
       .byte $47 ; | X   XXX| $FB9E
       .byte $45 ; | X   X X| $FB9F
       .byte $E1 ; |XXX    X| $FBA1
       .byte $47 ; | X   XX | $FBA3
       .byte $44 ; | X   X  | $FBA4
       .byte $47 ; | X   XXX| $FBA5
Add_400_gfx:
       .byte $41 ; | X     X| $FB90
       .byte $41 ; | X     X| $FB91
       .byte $41 ; | X     X| $FB92
       .byte $E7 ; |XXX  XXX| $FB94
       .byte $45 ; | X   X X| $FB96
       .byte $45 ; | X   X X| $FB97
       .byte $45 ; | X   X X| $FB98
Subtract_Bullet_gfx:
       .byte $0A ; |    X X | $FBAA
       .byte $0A ; |    X X | $FBAB
       .byte $0A ; |    X X | $FBAC
       .byte $EA ; |XXX X X | $FBAD
       .byte $00 ; |        | $FBB0
       .byte $00 ; |        | $FB2B
       .byte $00 ; |        | $FB2C
Subtract_500_gfx:
       .byte $02 ; |      X | $FBB5
       .byte $07 ; |     XXX| $FBB6
       .byte $05 ; |     X X| $FBB7
       .byte $E1 ; |XXX    X| $FBB9
       .byte $06 ; |     XX | $FBBB
       .byte $04 ; |     X  | $FBBC
       .byte $07 ; |     XXX| $FBBD


       ORG $1E00
       RORG $DE00

;missile length data (bit 1...shared w/other data)
;gun gfx
LFD5D: ;bank1
       .byte $00 ; |        | $FD5D shared
       .byte $5C ; | X XXX  | $FD5E shared
       .byte $5C ; | X XXX  | $FD5F shared
       .byte $3C ; |  XXXX  | $FD60 shared
       .byte $60 ; | XX     | $FD61 shared
       .byte $70 ; | XXX    | $FD62 shared
       .byte $50 ; | X X    | $FD63 shared
       .byte $40 ; | X      | $FD64 shared
       .byte $40 ; | X      | $FD65 shared
       .byte $40 ; | X      | $FD66 shared
       .byte $C0 ; |XX      | $FD67 shared
       .byte $C0 ; |XX      | $FD68 shared
       .byte $40 ; | X      | $FD69 shared
Gun1:
       .byte $40 ; | X      | $FD6A shared
       .byte $00 ; |X    X  | $FF0E
       .byte $00 ; |X    X  | $FF0F
       .byte $00 ; |X    X  | $FF10
       .byte $00 ; | XX  X  | $FF11
       .byte $00 ; |X       | $FF12
       .byte $00 ; |X X     | $FF13
       .byte $00 ; |XX      | $FF14
       .byte $00 ; |XX X    | $FF15
       .byte $00 ; |  X    X| $FF16
       .byte $02 ; |  X X X | $FF17
       .byte $02 ; |  X XXXX| $FF18
       .byte $02 ; |  XX  X | $FF19
       .byte $02 ; |XXXXXXXX| $FF1A
       .byte $02 ; |XXXXXXXX| $FF1B
       .byte $00 ; |     X  | $FF1E
       .byte $1C ; |   XXX  | $FD5E shared
       .byte $5C ; | X XXX  | $FD5F shared
       .byte $5C ; | XXXXX  | $FD60 shared
       .byte $60 ; | XX     | $FD61 shared
       .byte $70 ; | XXX    | $FD62 shared
       .byte $48 ; | X  X   | $FD63 shared
       .byte $40 ; | X      | $FD64 shared
       .byte $40 ; | X      | $FD65
       .byte $40 ; | X      | $FD66
       .byte $C0 ; |XX      | $FD67
       .byte $C0 ; |XX      | $FD68
       .byte $40 ; | X      | $FD69
Gun2:
P1_Color:
       .byte $40 ; |    X   | $FE86 2a
       .byte $40 ; |    X   | $FE86
       .byte $40 ; |    X   | $FE86
       .byte $40 ; |    X   | $FE86
       .byte $40 ; |    X   | $FE86
       .byte $40 ; |    X   | $FE86
       .byte $40 ; |    X   | $FE86
Eat_Bullet_Blank_gfx: ;bank1
       .byte $00 ; |XX    X | $FB03 31
       .byte $00 ; |        | $FF1C
       .byte $00 ; | X X    | $FF1D
Bullet_Init: ;bank1
Blank_Pipe_gfx: ;bank1
       .byte $00 ; |        | $FE63
       .byte $00 ; |        | $FE64
       .byte $00 ; |        | $FE65
       .byte $00 ; |        | $FE66
       .byte $00 ; |        | $FE67
Scorecolor_Init: ;bank1
       .byte $00 ; |        | $FE63 39
       .byte $00 ; |        | $FE64
       .byte $00 ; |        | $FE65
       .byte $00 ; |        | $FE66
       .byte $00 ; |        | $FE67
       .byte $00 ; |        | $FE68
       .byte $00 ; |        | $FE69
       .byte $00 ; |        | $FE6A
Logocolor: ;bank1
P2_Color:
       .byte $A6 ; |X X  XX | $FE6B
       .byte $A6 ; |X X  XX | $FE6C
       .byte $A6 ; |X X  XX | $FE6D
       .byte $A6 ; |X X  XX | $FE6E
       .byte $A6 ; |X X  XX | $FE6F
       .byte $A6 ; |X X  XX | $FE70
       .byte $A6 ; |X X  XX | $FE71
       .byte $A6 ; |X X  XX | $FE72
       .byte $00 ; |        | $FE73
       .byte $00 ; |        | $FE74
       .byte $00 ; |        | $FE75
       .byte $57 ; | X X XXX| $FE76
       .byte $57 ; | X X XXX| $FE77
       .byte $57 ; | X X XXX| $FE78
       .byte $1A ; |   XX X | $FE79
       .byte $1A ; |   XX X | $FE7A
       .byte $1A ; |   XX X | $FE7B
       .byte $1A ; |   XX X | $FE7C
       .byte $1A ; |   XX X | $FE7D
       .byte $00 ; |        | $FE7E
       .byte $00 ; |        | $FE7F
       .byte $00 ; |        | $FE80
       .byte $00 ; |        | $FE81
       .byte $00 ; |        | $FE82
       .byte $00 ; |        | $FE83
       .byte $00 ; |        | $FE84
       .byte $00 ; |        | $FE85

;scrolling copyright message..."carnival" & "(c)1982 coleco"
Scroll_Msg: ;bank1
       .byte $FD ; |XXXXXX X| $FD6B
       .byte $85 ; |X    X X| $FD6C
       .byte $B5 ; |X XX X X| $FD6D
       .byte $A5 ; |X X  X X| $FD6E
       .byte $B5 ; |X XX X X| $FD6F
       .byte $85 ; |X    X X| $FD70
       .byte $FD ; |XXXXXX X| $FD71
       .byte $00 ; |        | $FD72
       .byte $00 ; |        | $FD73
       .byte $00 ; |        | $FD74
       .byte $00 ; |        | $FD75
       .byte $0E ; |    XXX | $FD76
       .byte $12 ; |   X  X | $FD77
       .byte $10 ; |   X    | $FD78
       .byte $10 ; |   X    | $FD79
       .byte $12 ; |   X  X | $FD7A
       .byte $0E ; |    XXX | $FD7B
       .byte $00 ; |        | $FD7C
       .byte $00 ; |        | $FD7D

       .byte $77 ; | XXX XXX| $FD7E
       .byte $15 ; |   X X X| $FD7F
       .byte $15 ; |   X X X| $FD80
       .byte $77 ; | XXX XXX| $FD81
       .byte $55 ; | X X X X| $FD82
       .byte $55 ; | X X X X| $FD83
       .byte $77 ; | XXX XXX| $FD84
       .byte $00 ; |        | $FD85
       .byte $00 ; |        | $FD86
       .byte $00 ; |        | $FD87
       .byte $00 ; |        | $FD88
       .byte $6A ; | XX X X | $FD89
       .byte $FA ; |XXXXX X | $FD8A
       .byte $8A ; |X   X X | $FD8B
       .byte $8A ; |X   X X | $FD8C
       .byte $FB ; |XXXXX XX| $FD8D
       .byte $6A ; | XX X X | $FD8E
       .byte $00 ; |        | $FD8F
       .byte $00 ; |        | $FD90

       .byte $66 ; | XX  XX | $FD91
       .byte $44 ; | X   X  | $FD92
       .byte $44 ; | X   X  | $FD93
       .byte $64 ; | XX  X  | $FD94
       .byte $24 ; |  X  X  | $FD95
       .byte $24 ; |  X  X  | $FD96
       .byte $66 ; | XX  XX | $FD97
       .byte $00 ; |        | $FD98
       .byte $00 ; |        | $FD99
       .byte $00 ; |        | $FD9A
       .byte $00 ; |        | $FD9B
       .byte $12 ; |   X  X | $FD9C
       .byte $12 ; |   X  X | $FD9D
       .byte $52 ; | X X  X | $FD9E
       .byte $52 ; | X X  X | $FD9F
       .byte $DC ; |XX XXX  | $FDA0
       .byte $10 ; |   X    | $FDA1
       .byte $00 ; |        | $FDA2
       .byte $00 ; |        | $FDA3

       .byte $ED ; |XXX XX X| $FDA4
       .byte $A9 ; |X X X  X| $FDA5
       .byte $A9 ; |X X X  X| $FDA6
       .byte $A9 ; |X X X  X| $FDA7
       .byte $A9 ; |X X X  X| $FDA8
       .byte $A9 ; |X X X  X| $FDA9
       .byte $E9 ; |XXX X  X| $FDAA
       .byte $00 ; |        | $FDAB
       .byte $00 ; |        | $FDAC
       .byte $00 ; |        | $FDAD
       .byte $00 ; |        | $FDAE
       .byte $98 ; |X  XX   | $FDAF
       .byte $BD ; |X XXXX X| $FDB0
       .byte $A5 ; |X X  X X| $FDB1
       .byte $A5 ; |X X  X X| $FDB2
       .byte $A5 ; |X X  X X| $FDB3
       .byte $A4 ; |X X  X  | $FDB4
       .byte $00 ; |        | $FDB5
       .byte $80 ; |X       | $FDB6

       .byte $B7 ; |X XX XXX| $FDB7
       .byte $25 ; |  X  X X| $FDB8
       .byte $25 ; |  X  X X| $FDB9
       .byte $A5 ; |X X  X X| $FDBA
       .byte $25 ; |  X  X X| $FDBB
       .byte $25 ; |  X  X X| $FDBC
       .byte $B7 ; |X XX XXX| $FDBD
       .byte $00 ; |        | $FDBE
       .byte $00 ; |        | $FDBF
       .byte $00 ; |        | $FDC0
       .byte $00 ; |        | $FDC1
       .byte $D4 ; |XX X X  | $FDC2
       .byte $F4 ; |XXXX X  | $FDC3
       .byte $14 ; |   X X  | $FDC4
       .byte $14 ; |   X X  | $FDC5
       .byte $F4 ; |XXXX X  | $FDC6
       .byte $D4 ; |XX X X  | $FDC7
;       .byte $04 ; |     X  | $FDC8
;       .byte $04 ; |     X  | $FDC9
Pipe2_gfx: ;bank1
       .byte $04 ; |     X  | $FED9 shared
       .byte $04 ; |     X  | $FEDA shared
       .byte $02 ; |      X | $FEDB
       .byte $02 ; |      X | $FEDC
       .byte $C1 ; |XX     X| $FEDD
       .byte $C1 ; |XX     X| $FEDE
       .byte $30 ; |  XX    | $FEDF
       .byte $30 ; |  XX    | $FEE0
       .byte $30 ; |  XX    | $FEE1
       .byte $38 ; |  XXX   | $FEE2
       .byte $08 ; |    X   | $FEE3
       .byte $04 ; |     X  | $FEE4
       .byte $04 ; |     X  | $FEE5

Pipe1_gfx: ;bank1
       .byte $C2 ; |XX    X | $FECC
       .byte $C2 ; |XX    X | $FECD
       .byte $C1 ; |XX     X| $FECE
       .byte $C1 ; |XX     X| $FECF
       .byte $FF ; |XXXXXXXX| $FED0
       .byte $FF ; |XXXXXXXX| $FED1
       .byte $08 ; |    X   | $FED2
       .byte $02 ; |      X | $FED3
       .byte $02 ; |      X | $FED4
       .byte $02 ; |      X | $FED5
       .byte $02 ; |      X | $FED6
       .byte $02 ; |      X | $FED7
       .byte $02 ; |      X | $FED8

Pipe3_gfx: ;bank1
       .byte $08 ; |    X   | $FEE6
       .byte $04 ; |     X  | $FEE7
       .byte $04 ; |     X  | $FEE8
       .byte $02 ; |      X | $FEE9
       .byte $03 ; |      XX| $FEEA
       .byte $01 ; |       X| $FEEB
       .byte $00 ; |        | $FEEC
       .byte $60 ; | XX     | $FEED
       .byte $60 ; | XX     | $FEEE
       .byte $60 ; | XX     | $FEEF
       .byte $60 ; | XX     | $FEF0
       .byte $70 ; | XXX    | $FEF1
       .byte $78 ; | XXXX   | $FEF2

Pipe4_gfx: ;bank1
       .byte $C1 ; |XX     X| $FEF3
       .byte $E1 ; |XXX    X| $FEF4
       .byte $F9 ; |XXXXX  X| $FEF5
       .byte $1D ; |   XXX X| $FEF6
       .byte $07 ; |     XXX| $FEF7
       .byte $03 ; |      XX| $FEF8
       .byte $01 ; |       X| $FEF9
       .byte $01 ; |       X| $FEFA
       .byte $01 ; |       X| $FEFB
       .byte $01 ; |       X| $FEFC
       .byte $C1 ; |XX     X| $FEFD
       .byte $C1 ; |XX     X| $FEFE
Pipe_Color_Tbl2: ;pipe hue bank1
       .byte $C1 ; |XX     X| $FEFF shared
       .byte $90 ; |X  X X  | $FB0B
       .byte $60 ; | XX  X  | $FB0D
       .byte $20 ; |  X  X  | $FB0E


Eat_Bullet1_gfx: ;bank1
       .byte $0C ; |    XX  | $FEAE
       .byte $1E ; |   XXXX | $FEAF
       .byte $7E ; | XXXXXX | $FEB0
       .byte $76 ; | XXX XX | $FEB1
       .byte $16 ; |   X XX | $FEB2
       .byte $1E ; |   XXXX | $FEB3
       .byte $0C ; |    XX  | $FEB4
       .byte $00 ; |        | $FEB4

Eat_Bullet2_gfx: ;bank1
       .byte $0C ; |    XX  | $FEB5
       .byte $5E ; | X XXXX | $FEB6
       .byte $3E ; |  XXXXX | $FEB7
       .byte $16 ; |   X XX | $FEB8
       .byte $36 ; |  XX XX | $FEB9
       .byte $5E ; | X XXXX | $FEBA
       .byte $0C ; |    XX  | $FEBB
       .byte $00 ; |        | $FEB4

;1 free
       .byte $00

        ORG $1F00
        RORG $DF00

Digit_gfx: ;bank1
Digit0_gfx: ;bank1
       .byte $3C ; |  XXXX  | $FD00
       .byte $66 ; | XX  XX | $FD01
       .byte $66 ; | XX  XX | $FD02
       .byte $66 ; | XX  XX | $FD03
       .byte $66 ; | XX  XX | $FD04
       .byte $66 ; | XX  XX | $FD05
       .byte $3C ; |  XXXX  | $FD06
       .byte $00 ; |        | $FD07

       .byte $7E ; | XXXXXX | $FD08
       .byte $18 ; |   XX   | $FD09
       .byte $18 ; |   XX   | $FD0A
       .byte $18 ; |   XX   | $FD0B
       .byte $38 ; |  XXX   | $FD0C
       .byte $18 ; |   XX   | $FD0D
       .byte $08 ; |    X   | $FD0E
       .byte $00 ; |        | $FD0F

       .byte $7E ; | XXXXXX | $FD10
       .byte $62 ; | XX   X | $FD11
       .byte $60 ; | XX     | $FD12
       .byte $3C ; |  XXXX  | $FD13
       .byte $06 ; |     XX | $FD14
       .byte $46 ; | X   XX | $FD15
       .byte $3C ; |  XXXX  | $FD16
       .byte $00 ; |        | $FD17

       .byte $3C ; |  XXXX  | $FD18
       .byte $46 ; | X   XX | $FD19
       .byte $06 ; |     XX | $FD1A
       .byte $1C ; |   XXX  | $FD1B
       .byte $06 ; |     XX | $FD1C
       .byte $46 ; | X   XX | $FD1D
       .byte $3C ; |  XXXX  | $FD1E
       .byte $00 ; |        | $FD1F

       .byte $0C ; |    XX  | $FD20
       .byte $0C ; |    XX  | $FD21
       .byte $7E ; | XXXXXX | $FD22
       .byte $4C ; | X  XX  | $FD23
       .byte $2C ; |  X XX  | $FD24
       .byte $1C ; |   XXX  | $FD25
       .byte $0C ; |    XX  | $FD26
       .byte $00 ; |        | $FD27

       .byte $3C ; |  XXXX  | $FD28
       .byte $46 ; | X   XX | $FD29
       .byte $06 ; |     XX | $FD2A
       .byte $7C ; | XXXXX  | $FD2B
       .byte $60 ; | XX     | $FD2C
       .byte $60 ; | XX     | $FD2D
       .byte $7E ; | XXXXXX | $FD2E
       .byte $00 ; |        | $FD2F

       .byte $3C ; |  XXXX  | $FD30
       .byte $66 ; | XX  XX | $FD31
       .byte $66 ; | XX  XX | $FD32
       .byte $7C ; | XXXXX  | $FD33
       .byte $60 ; | XX     | $FD34
       .byte $62 ; | XX   X | $FD35
       .byte $3C ; |  XXXX  | $FD36
       .byte $00 ; |        | $FD37

       .byte $30 ; |  XX    | $FD38
       .byte $30 ; |  XX    | $FD39
       .byte $18 ; |   XX   | $FD3A
       .byte $0C ; |    XX  | $FD3B
       .byte $06 ; |     XX | $FD3C
       .byte $42 ; | X    X | $FD3D
       .byte $7E ; | XXXXXX | $FD3E
       .byte $00 ; |        | $FD3F

       .byte $3C ; |  XXXX  | $FD40
       .byte $66 ; | XX  XX | $FD41
       .byte $66 ; | XX  XX | $FD42
       .byte $3C ; |  XXXX  | $FD43
       .byte $66 ; | XX  XX | $FD44
       .byte $66 ; | XX  XX | $FD45
       .byte $3C ; |  XXXX  | $FD46
       .byte $00 ; |        | $FD47

       .byte $3C ; |  XXXX  | $FD48
       .byte $46 ; | X   XX | $FD49
       .byte $06 ; |     XX | $FD4A
       .byte $3E ; |  XXXXX | $FD4B
       .byte $66 ; | XX  XX | $FD4C
       .byte $66 ; | XX  XX | $FD4D
       .byte $3C ; |  XXXX  | $FD4E
       .byte $00 ; |        | $FD4F

Player_One_Up_gfx: ;"player one" bank1
Player_Up_1_gfx: ;bank1
       .byte $8E ; |X   XXX | $FF5D
       .byte $88 ; |X   X   | $FF5E
       .byte $88 ; |X   X   | $FF5F
       .byte $E8 ; |XXX X   | $FF60
       .byte $A8 ; |X X X   | $FF61
       .byte $A8 ; |X X X   | $FF62
       .byte $E8 ; |XXX X   | $FF63

Player_Up_2_gfx: ;bank1
       .byte $A4 ; |X X  X  | $FF65
       .byte $A4 ; |X X  X  | $FF66
       .byte $A4 ; |X X  X  | $FF67
       .byte $EE ; |XXX XXX | $FF68
       .byte $AA ; |X X X X | $FF69
       .byte $AA ; |X X X X | $FF6A
       .byte $EA ; |XXX X X | $FF6B

Player_Up_3_gfx: ;bank1
       .byte $EA ; |XXX X X | $FF6D
       .byte $8A ; |X   X X | $FF6E
       .byte $8A ; |X   X X | $FF6F
       .byte $CC ; |XX  XX  | $FF70
       .byte $8A ; |X   X X | $FF71
       .byte $8A ; |X   X X | $FF72
       .byte $EE ; |XXX XXX | $FF73

Player_Up_4_gfx: ;bank1
       .byte $0E ; |    XXX | $FF75
       .byte $0A ; |    X X | $FF76
       .byte $0A ; |    X X | $FF77
       .byte $0A ; |    X X | $FF78
       .byte $0A ; |    X X | $FF79
       .byte $0A ; |    X X | $FF7A
       .byte $0E ; |    XXX | $FF7B

Player_Up_5_gfx: ;bank1
       .byte $97 ; |X  X XXX| $FF7D
       .byte $94 ; |X  X X  | $FF7E
       .byte $94 ; |X  X X  | $FF7F
       .byte $B6 ; |X XX XX | $FF80
       .byte $D4 ; |XX X X  | $FF81
       .byte $94 ; |X  X X  | $FF82
       .byte $97 ; |X  X XXX| $FF83



;+$28 "S.Kitchen"
Programmer4_gfx: ;bank1
       .byte $F5 ; |XXXX X X| $FF85
       .byte $91 ; |X  X   X| $FF86
       .byte $11 ; |   X   X| $FF87
       .byte $21 ; |  X    X| $FF88
       .byte $41 ; | X     X| $FF89
       .byte $91 ; |X  X   X| $FF8B
       .byte $F1 ; |XXXX   X| $FF8C

Programmer3_gfx: ;bank1
       .byte $1F ; |   XXXXX| $FF8D
       .byte $20 ; |  X     | $FF8E
       .byte $44 ; | X   X  | $FF8F
       .byte $84 ; |X    X  | $FF90
       .byte $44 ; | X   X  | $FF92
       .byte $20 ; |  X     | $FF93
       .byte $15 ; |   X X X| $FF94

Programmer2_gfx: ;bank1
       .byte $FF ; |XXXXXXXX| $FF95
       .byte $00 ; |        | $FF96
       .byte $47 ; | X   XXX| $FF97
       .byte $44 ; | X   X  | $FF98
       .byte $44 ; | X   X  | $FF9A
       .byte $44 ; | X   X  | $FF9B
       .byte $F7 ; |XXXX XXX| $FF9C

Programmer1_gfx: ;bank1
       .byte $FF ; |XXXXXXXX| $FF9D
       .byte $00 ; |        | $FF9E
       .byte $4B ; | X  X XX| $FF9F
       .byte $4A ; | X  X X | $FFA0
       .byte $7B ; | XXXX XX| $FFA2
       .byte $4A ; | X  X X | $FFA3
       .byte $4B ; | X  X XX| $FFA4

Programmer0_gfx: ;bank1
       .byte $FF ; |XXXXXXXX| $FFA5
       .byte $00 ; |        | $FFA6
       .byte $D1 ; |XX X   X| $FFA7
       .byte $13 ; |   X  XX| $FFA9
       .byte $95 ; |X  X X X| $FFAA
       .byte $19 ; |   XX  X| $FFAB
       .byte $D1 ; |XX X   X| $FFAC

Player_Two_Up_gfx: ;bank1 ;"player two"
Player_Up_6_gfx: ;bank1
       .byte $08 ; |    X   | $FFC5
       .byte $09 ; |    X  X| $FFC6
       .byte $09 ; |    X  X| $FFC7
       .byte $09 ; |    X  X| $FFC8
       .byte $09 ; |    X  X| $FFC9
       .byte $09 ; |    X  X| $FFCA
       .byte $1D ; |   XXX X| $FFCB

Player_Up_7_gfx: ;bank1
       .byte $A7 ; |X X  XXX| $FFCD
       .byte $55 ; | X X X X| $FFCE
       .byte $55 ; | X X X X| $FFCF
       .byte $55 ; | X X X X| $FFD0
       .byte $55 ; | X X X X| $FFD1
       .byte $15 ; |   X X X| $FFD2
       .byte $17 ; |   X XXX| $FFD3



;+$28 "program by"
Programmer9_gfx: ;bank1
       .byte $8A ; |X   X X | $FFD5
       .byte $8A ; |X   X X | $FFD6
       .byte $8A ; |X   X X | $FFD7
       .byte $CC ; |XX  XX  | $FFD8
       .byte $AA ; |X X X X | $FFD9
       .byte $AA ; |X X X X | $FFDA
       .byte $CC ; |XX  XX  | $FFDB

Programmer8_gfx: ;bank1
       .byte $EE ; |XXX XXX | $FFDD
       .byte $AA ; |X X X X | $FFDE
       .byte $AA ; |X X X X | $FFDF
       .byte $AA ; |X X X X | $FFE0
       .byte $A8 ; |X X X   | $FFE1
       .byte $A8 ; |X X X   | $FFE2
       .byte $EE ; |XXX XXX | $FFE3

Programmer7_gfx: ;bank1
       .byte $AA ; |X X X X | $FFE5
       .byte $AA ; |X X X X | $FFE6
       .byte $AA ; |X X X X | $FFE7
       .byte $CE ; |XX  XXX | $FFE8
       .byte $AA ; |X X X X | $FFE9
       .byte $AA ; |X X X X | $FFEA
       .byte $C4 ; |XX   X  | $FFEB

Programmer6_gfx: ;bank1
       .byte $88 ; |X   X   | $FFED
       .byte $88 ; |X   X   | $FFEE
       .byte $88 ; |X   X   | $FFEF
       .byte $A8 ; |X X X   | $FFF0
       .byte $A8 ; |X X X   | $FFF1
       .byte $A8 ; |X X X   | $FFF2
       .byte $50 ; | X X    | $FFF3

Programmer5_gfx: ;bank1
       .byte $62 ; | XX   X | $FFF5
       .byte $52 ; | X X  X | $FFF6
       .byte $52 ; | X X  X | $FFF7
       .byte $67 ; | XX  XXX| $FFF8
       .byte $55 ; | X X X X| $FFF9
       .byte $55 ; | X X X X| $FFFA
       .byte $65 ; | XX  X X| $FFFB


LFDF5: ;bank1
       .byte $FF ; |XXXXXXXX| $FDF5
       .byte $92 ; |X  X  X | $FDF6
       .byte $C0 ; |XX      | $FDF7
       .byte $64 ; | XX  X  | $FDF8
       .byte $22 ; |  X   X | $FDF9
       .byte $22 ; |  X   X | $FDFA
       .byte $04 ; |     X  | $FDFB
       .byte $02 ; |      X | $FDFC
       .byte $FF ; |XXXXXXXX| $FDFD
       .byte $AC ; |X X XX  | $FDFE
       .byte $88 ; |X   X   | $FDFF

Pipe_Color_Tbl: ;pipe brightness bank1
       .byte $00 ; |XX    X | $FB03 1 shot left
       .byte $02 ; | XX  X  | $FB04 2 shots left
       .byte $04 ; |  X  X  | $FB05 3 shots left
       .byte $06 ; |XXX     | $FB06 4 shots left
       .byte $08 ; |X X  X  | $FB07 5 shots left
       .byte $0A ; | XX X   | $FB08 6 shots left
       .byte $0C ; | XX X   | $FB09 7 shots left
       .byte $0E ; | X  XXXX| $FB0A 8 shots left

;30 unused
       .byte "Hack by: Kurt(Nukey Shay)Howe-"

       ORG $1FF8
       RORG $DFF8
       .byte "2006"
       .word START1,LFBBE










































































       ORG $2000
       RORG $F000

START2:
       nop                            ;2
       nop                            ;2
       nop                            ;2
       nop                            ;2
       jmp    START                   ;3

New_Display:
       sta    $FFF8                   ;4


;       ldx    #$0A                    ;2
;Change_Pointer_Loop2:
;       lda    r98,X                   ;4
;       bmi    No_Change2              ;2
;       and    #$BF                    ;2
;       sta    r98,X                   ;4
;No_Change2:
;       dex                            ;2
;       dex                            ;2
;       bpl    Change_Pointer_Loop2    ;2
;       sta    WSYNC                   ;4


       LDX    #$B9                    ;2
       STX    TIM8T                   ;4
       LDA    r8F                     ;3
       CMP    #$FE                    ;2
       BNE    LF84C                   ;2
       LDX    #$00                    ;2
       STX    rEA                     ;3
       DEX                            ;2
       STX    r8F                     ;3
LF84C:
       LDA    r90                     ;3
       BEQ    LF883                   ;2
       STA    AUDC0                   ;3
       AND    #$F0                    ;2
       TAY                            ;2
       LSR                            ;2
       LSR                            ;2
       LSR                            ;2
       LSR                            ;2
       TAX                            ;2
       LDA    LFB11,X                 ;4
       INC    rEA                     ;5
       CMP    rEA                     ;3
       BNE    LF896                   ;2
       LDA    #$00                    ;2
       STA    rEA                     ;3
       INC    r8F                     ;5
       TYA                            ;2
       CLC                            ;2
       ADC    r8F                     ;3
       TAX                            ;2
       LDA    LFAC7,X                 ;4
       BEQ    LF883                   ;2
       STA    AUDF0                   ;3
       LSR                            ;2
       LSR                            ;2
       LSR                            ;2
       LSR                            ;2
       LDX    rCB                     ;3
       BNE    LF87E                   ;2
       TXA                            ;2
LF87E:
       STA    AUDV0                   ;3
       JMP    LF896                   ;3

LF883:
       LDX    #$00                    ;2
       LDA    r90                     ;3
       CMP    #$14                    ;2
       BNE    LF88F                   ;2
       STX    rE6                     ;3
       STX    rE8                     ;3
LF88F:
       STX    AUDV0                   ;3
       STX    r90                     ;3
       DEX                            ;2
       STX    r8F                     ;3
LF896:

;bear deal...
;       jmp    Bear_Stuff              ;3



       LDX    #$00                    ;2
       LDA    rEE                     ;3
       BEQ    LF8D0                   ;2
       CMP    #$0B                    ;2
       BNE    LF8AC                   ;2
       STX    rCF                     ;3
       LDA    r83                     ;3
       ASL                            ;2
       ASL                            ;2
       SBC    #$00                    ;2
       STA    rED                     ;3
       BNE    LF8B8                   ;2
LF8AC:
       LDA    rCF                     ;3
       CMP    #$0A                    ;2
       BEQ    LF8C0                   ;2
       CMP    #$14                    ;2
       BNE    LF8D4                   ;2
       STX    rCF                     ;3
LF8B8:
       DEC    rEE                     ;5
       BEQ    LF8D0                   ;2
       DEC    r83                     ;5
       BEQ    LF8D0                   ;2
LF8C0:
       LDA    r8B                     ;3
       LDX    #<Eat_Bullet1_gfx       ;2
       CMP    #<Eat_Bullet1_gfx       ;2
       BNE    LF8CA                   ;2
       LDX    #<Eat_Bullet2_gfx       ;2
LF8CA:
       DEC    rED                     ;5
       DEC    rED                     ;5
       BNE    LF8D2                   ;2
LF8D0:
       LDX    #<Eat_Bullet_Blank_gfx  ;2
LF8D2:
       STX    r8B                     ;3

LF8D4:
       LDX    #$03                    ;2
       LDA    r81                     ;3
LF8DA:
       SEC                            ;2
       SBC    #$15                    ;2
       STA    rBF+9                   ;3
       BPL    LF8EE                   ;2
       CMP    #$DD                    ;2
       BCC    LF8EE                   ;2



       ADC    #$22                    ;2
       CLC                            ;2
       ADC    rF1                     ;3
       BVC    LF8F0                   ;2
LF8EE:
       LDA    #<Blank_Duck_gfx        ;2 blank duck
LF8F0:
       STA    rF2,X                   ;4
       lda    rBF+9                   ;3
       DEX                            ;2
       BPL    LF8DA                   ;2
       LDA    #$FC                    ;2
       STA    rF6                     ;3
       STA    rF8                     ;3
       LDA    r83                     ;3
       BEQ    LF903                   ;2
       LDA    rD1                     ;3
       BEQ    LF906                   ;2
LF903:
       JMP    LFA54                   ;3
LF906:
       LDA    r81                     ;3
       CMP    #$4F                    ;2
       BEQ    LF941                   ;2
       LDA    rAB                     ;3
       AND    #$0F                    ;2
       CLC                            ;2
       ADC    r81                     ;3
       STA    r81                     ;3
       CMP    #$37                    ;2
       BNE    LF923                   ;2
       LDA    #$4F                    ;2
       STA    r81                     ;3
       LDA    #$0B                    ;2
       STA    rEE                     ;3
       BNE    LF941                   ;2 always branch

LF923:
       BIT    rAB                     ;3
       BMI    LF92D                   ;2
       BVC    LF96B                   ;2
       INC    rEF                     ;5
       BNE    LF92F                   ;2
LF92D:
       DEC    rEF                     ;5
LF92F:
       LDA    rEF                     ;3
       CMP    #$10                    ;2
       BCC    LF939                   ;2
       CMP    #$90                    ;2
       BCC    LF96B                   ;2
LF939:
       LDA    rAB                     ;3
       EOR    #$E0                    ;2
       STA    rAB                     ;3
       BNE    LF96B                   ;2
LF941:
       LDX    rEE                     ;3
       BNE    LF9A9                   ;2
       LDA    rCC                     ;3
       CMP    #$D0                    ;2
       BCC    LF981                   ;2
       LDA    r98                     ;3
       BEQ    LF954                   ;2
       INX                            ;2
       LDA    r9A                     ;3
       BNE    LF981                   ;2
LF954:
       LDA    r91+1,X                 ;4
       CMP    #$28                    ;2
       BCC    LF981                   ;2
       CMP    #$78                    ;2
       BCS    LF981                   ;2
       STA    rEF                     ;3
       TXA                            ;2
       ASL                            ;2
       TAX                            ;2
;       LDA    #$5C                    ;2
       lda    #<Blank_Object_gfx      ;2
       STA    r98,X                   ;4
       LDA    #$00                    ;2
       STA    r81                     ;3
LF96B:
       LDA    rCC                     ;3
       CMP    #$09                    ;2
       BCS    LF981                   ;2
       LDX    rCE                     ;3
       LDA    LFEBC,X                 ;4
       STA    rAB                     ;3
       LDA    LFEC4,X                 ;4
       STA    rF1                     ;3
       LDA    #$B0                    ;2
       STA    rCC                     ;3
LF981:
       LDX    #$0A                    ;2
       LDY    #$06                    ;2
LF985:
;check for remaining targets
       LDA    r98,X                   ;4
;       CMP    #$5C                    ;2
       cmp    #<Blank_Object_gfx      ;2
       BEQ    LF991                   ;2

LF98B:
       DEX                            ;2
       DEX                            ;2
       BPL    LF985                   ;2
       BMI    LF9EE                   ;2 always branch

LF991:
       DEY                            ;2
       BNE    LF9AB                   ;2
       LDA    r81                     ;3
       CMP    #$4F                    ;2
       BNE    LF9AB                   ;2
       LDA    r85                     ;3
       BNE    LF9AB                   ;2
       STY    rCB                     ;3
       LDA    rEC                     ;3
       BNE    LFA1B                   ;2
       DEY                            ;2
       STY    rEC                     ;3
       STY    rDA                     ;3
LF9A9:
       BNE    LFA1B                   ;2
LF9AB:
       STX    rBF+9                   ;3
       TXA                            ;2
       LSR                            ;2
       TAX                            ;2
       LDA    r91+1,X                 ;4
       LDX    rBF+9                   ;3
       CMP    #$04                    ;2
       BNE    LF98B                   ;2
       LDX    rAA                     ;3
       LDA    LFF11,X                 ;4
       LDX    rBF+9                   ;3
       CMP    rCC                     ;3
       BCC    LF98B                   ;2
       LDA    rCF                     ;3
       EOR    rCE                     ;3
       STA    rD6                     ;3
       LDA    r80                     ;3
       BEQ    LF9CF                   ;2
       DEC    r80                     ;5
LF9CF:
       AND    #$37                    ;2
       AND    rD6                     ;3
       TAY                            ;2
       CPX    #$03                    ;2
       BCS    LF9E1                   ;2
       TXA                            ;2
       BEQ    LF9E0                   ;2
       TYA                            ;2
       AND    #$30                    ;2
       BNE    LF9E1                   ;2
LF9E0:
       TAY                            ;2
LF9E1:
       TYA                            ;2
       AND    #$30                    ;2
       STA    r98,X                   ;4
       TXA                            ;2
       LSR                            ;2
       TAX                            ;2
       TYA                            ;2
       AND    #$07                    ;2
       STA    rB1,X                   ;4
LF9EE:
       LDX    #$06                    ;2
LF9F0:
       DEX                            ;2
       BMI    LFA1B                   ;2
       LDA    rB1,X                   ;4
       BEQ    LF9F0                   ;2
       TAY                            ;2
       TXA                            ;2
       AND    #$02                    ;2
       BEQ    LFA06                   ;2
       LDA    r91+1,X                 ;4
       CMP    LFF08,Y                 ;4
       BNE    LF9F0                   ;2
       BEQ    LFA11                   ;2 always branch

LFA06:
       LDA    r91+1,X                 ;4
       CMP    LFF00-1,Y               ;4
       BNE    LF9F0                   ;2
       LDA    #$04                    ;2
       STA    r91+1,X                 ;4
LFA11:
       LDA    LFDCA,Y                 ;4
       STA    rA4,X                   ;4
       LDA    LFF22,Y                 ;4
       STA    rB1,X                   ;4
LFA1B:
       LDX    #$02                    ;2
;       LDA    r91                     ;3
;       LSR                            ;2
;       LSR                            ;2
;       LSR                            ;2
;       LSR                            ;2
;       AND    #$03                    ;2
;       STA    rFD                     ;3
LFA27:
       LDA    r85                     ;3
       BNE    LFA2F                   ;2
LFA2B:
;       LDA    #$54                    ;2
       lda    #<Blank_Pipe_gfx - 8    ;2
       BNE    LFA4A                   ;2 always branch

;here
LFA2F:
       LDA    r90                     ;3
       CMP    #$48                    ;2
       BEQ    LFA2B                   ;2
       LDA    r91                     ;3
       AND    #$0C                    ;2
       LSR                            ;2
       LSR                            ;2
       CPX    #$02                    ;2
       BNE    LFA41                   ;2
       EOR    #$03                    ;2
LFA41:
       TAY                            ;2
;       LDA    #$B7                    ;2
;LFA44:
;       CLC                            ;2
;       ADC    #$0D                    ;2
;       DEY                            ;2
;       BPL    LFA44                   ;2
       lda    Pipe_Tbl,Y               ;4

;store pipe gfx pointers
LFA4A:
       STA    rF9,X                   ;4
       lda    #>Pipe1_gfx             ;2
       STA    rFA,X                   ;4
       DEX                            ;2
       DEX                            ;2
       BPL    LFA27                   ;2
LFA54:
       LDA    rC9                     ;3
       BEQ    LFAA8                   ;2
       LDA    rEC                     ;3
       CMP    #$E0                    ;2
       BCC    LFA90                   ;2
       LDA    #$05                    ;2
       LDX    rDA                     ;3
       CPX    #$08                    ;2
       BNE    LFAA8                   ;2
       STA    rDA                     ;3
       DEC    r83                     ;5
       BPL    LFA7A                   ;2
       JSR    LFCE6                   ;6
       LDX    rD5                     ;3
       BNE    LFA76                   ;2
       INX                            ;2
       STX    rEC                     ;3
LFA76:
       LDA    #$00                    ;2
       STA    r83                     ;3
LFA7A:
       STA    rD0                     ;3
       STA    AUDV1                   ;3
       LDA    r83                     ;3
       AND    #$01                    ;2
       BEQ    LFAA8                   ;2
       DEC    rEC                     ;5
       LDA    rEC                     ;3
       STA    AUDF1                   ;3
       LDA    #$0C                    ;2
       STA    AUDC1                   ;3
       BNE    LFAA8                   ;2 always branch

LFA90:
       LDX    #$00                    ;2
       LDA    rCB                     ;3
       BEQ    LFAA4                   ;2
       LDA    r81                     ;3
       CMP    #$4F                    ;2
       BEQ    LFAA4                   ;2
       LDA    r91                     ;3
       AND    #$07                    ;2
       STA    AUDF1                   ;3
       LDX    #$05                    ;2
LFAA4:
       STX    AUDV1                   ;3
       STX    AUDC1                   ;3
LFAA8:
       LDX    INTIM                   ;4
       BNE    LFAA8                   ;2
       lda    #$02                    ;2
       sta    WSYNC                   ;3
       sta    VBLANK                  ;3
;;       sta    WSYNC                   ;3
;;       sta    WSYNC                   ;3
       sta    VSYNC                   ;3
       sta    WSYNC                   ;3
;;       sta    WSYNC                   ;3
;       LDX    #$00                    ;2
       sta    WSYNC                   ;3
       stx    VSYNC                   ;3
;       JMP    LF011                   ;3
LF011:
       LDA    #$E8                    ;2
       STA    TIM8T                   ;4
       LDA    REFP1                   ;3
       AND    #$80                    ;2
       BNE    LF034                   ;2
       CPX    #$00                    ;2
       BEQ    LF028                   ;2
       STA    rA4+5                   ;3
       LDX    #$7E                    ;2
       STX    r9C+6                   ;3
       BNE    LF08E                   ;2 always branch

LF028:
       LDX    rC9                     ;3
       BEQ    LF07F                   ;2
       LDX    #$00                    ;2
       LDA    r83                     ;3
       CMP    #$7A                    ;2
       BEQ    LF07F                   ;2
LF034:
       INC    rCC                     ;5
       DEC    rCD                     ;5
       BPL    LF040                   ;2
       LDA    #$0C                    ;2
       STA    rCD                     ;3
       BNE    LF034                   ;2 always branch

LF040:
       DEC    rCE                     ;5
       BPL    LF04A                   ;2
       LDA    #$07                    ;2
       STA    rCE                     ;3
       BNE    LF034                   ;2 always branch

LF04A:
       INC    rCF                     ;5
       LDA    rCF                     ;3
       AND    #$0F                    ;2
       CMP    #$0F                    ;2
       BNE    LF074                   ;2
       LDA    rD9                     ;3
       BEQ    LF05C                   ;2
       DEC    rD9                     ;5
       BNE    LF074                   ;2
LF05C:
       DEC    rD8                     ;5
       BPL    LF064                   ;2
       LDA    #$1B                    ;2
       STA    rD8                     ;3
LF064:
       LDX    #$0A                    ;2
       LDA    rD8                     ;3
       CMP    #$13                    ;2
       BEQ    LF072                   ;2
       CMP    #$08                    ;2
       BNE    LF074                   ;2
       LDX    #$06                    ;2
LF072:
       STX    rD9                     ;3
LF074:
       LDA    SWCHB                   ;4
       AND    #$01                    ;2
       BNE    LF0A3                   ;2
       LDX    rD3                     ;3
       BNE    LF0C6                   ;2
LF07F:
       STX    rD4                     ;3
       LDA    rD5                     ;3
       STA    rF0                     ;3
       LDX    #$37                    ;2
       STX    rD2                     ;3
LF089:
       JSR    LFF54                   ;6
       STX    rD3                     ;3
LF08E:
       STX    rC9                     ;3
LF090:
       STX    rCB                     ;3
       LDX    #$00                    ;2
       STX    rEC                     ;3
       STX    rDB                     ;3
       STX    rEB                     ;3
       STX    rE8                     ;3
       STX    rE6                     ;3
       STX    rEE                     ;3
       JMP    LF44C                   ;3

LF0A3:
       LDA    SWCHB                   ;4
       AND    #$02                    ;2
       BNE    LF0C2                   ;2
       LDX    rD3                     ;3
       BNE    LF0C6                   ;2
       INX                            ;2
       STX    r85                     ;3
       LDA    #$7A                    ;2
       STA    r83                     ;3
       STA    rD3                     ;3
       STA    rC9                     ;3
       LDA    rD5                     ;3
       EOR    #$02                    ;2
       STA    rD5                     ;3
       CLC                            ;2
       BPL    LF0F0                   ;2
LF0C2:
       LDA    #$00                    ;2
       STA    rD3                     ;3
LF0C6:
       LDX    #$00                    ;2
       INC    rDA                     ;5
       BNE    LF113                   ;2
       LDA    rEB                     ;3
       BEQ    LF0D6                   ;2
       LDA    rD5                     ;3
       EOR    #$02                    ;2
       STA    rD5                     ;3
LF0D6:
       LDA    rEC                     ;3
       BEQ    LF100                   ;2
       CMP    #$E0                    ;2
       BCS    LF100                   ;2
       DEC    rEC                     ;5
       LDA    rEC                     ;3
       BNE    LF0E8                   ;2
       LDX    #$29                    ;2
       BNE    LF089                   ;2 always branch

LF0E8:
       CMP    #$DE                    ;2
       BNE    LF100                   ;2
       LDX    #$01                    ;2
       STX    rEC                     ;3
LF0F0:
;       LDA    #$5C                    ;2
       lda    #<Blank_Object_gfx      ;2
       LDX    #$0C                    ;2
LF0F4:
       STA    r98-2,X                 ;4
       DEX                            ;2
       DEX                            ;2
       BNE    LF0F4                   ;2
       LDA    #$47                    ;2
       STA    r81                     ;3
       BCC    LF090                   ;2 always branch?

LF100:
       INC    rDB                     ;5
       LDA    rDB                     ;3
       CMP    #$2D                    ;2
       BNE    LF113                   ;2
       STX    rEB                     ;3
       LDX    #$37                    ;2
       JSR    LFF54                   ;6
       INX                            ;2
       JMP    LF08E                   ;3

LF113:
       BIT    COLUP0                  ;3
       BPL    LF134                   ;2
       LDA    r84                     ;3
       CMP    #$3F                    ;2
       BCS    LF132                   ;2
       LDA    rB7                     ;3
       CMP    #$10                    ;2
       BCC    LF132                   ;2
       LDA    r90                     ;3
       CMP    #$14                    ;2
       BEQ    LF132                   ;2
       LDA    rE9                     ;3
       STA    rD0                     ;3
       LDA    #$14                    ;2
;       JSR    LFDD4                   ;6
       brk                            ;7
       nop                            ;2

LF132:
       STX    rB7                     ;3
LF134:
       BIT    WSYNC                   ;3
       BVS    LF13D                   ;2
       INX                            ;2
       BIT    RSYNC                   ;3
       BVC    LF1AD                   ;2
LF13D:
       STX    rBF+9                   ;3
       LDA    #$04                    ;2
;       JSR    LFDD4                   ;6
       brk                            ;7
       nop                            ;2

       LDX    #$00                    ;2
       LDA    rB7                     ;3
       STX    rB7                     ;3
       CMP    #$68                    ;2
       BCC    LF154                   ;2
       LDA    #$4F                    ;2
       STA    r81                     ;3
       BNE    LF1AD                   ;2 always branch

LF154:
       LDX    #$01                    ;2
       CMP    #$54                    ;2
       BCS    LF17E                   ;2
       INX                            ;2
       CMP    #$3F                    ;2
       BCS    LF17E                   ;2
       INX                            ;2
       CMP    #$17                    ;2
       BCS    LF17E                   ;2
       LDX    #$20                    ;2
       LDY    #$48                    ;2
;       LDA    rFD                     ;3

       lda    r91                     ;3
       lsr                            ;2
       lsr                            ;2
       lsr                            ;2
       lsr                            ;2
       and    #$03                    ;2

       CMP    r86                     ;3
       BNE    LF172                   ;2
;       LDY    #$5C                    ;2
       ldy    #<Blank_Object_gfx      ;2

       LDX    #$80                    ;2
LF172:
       STX    rD0                     ;3
       STA    r86                     ;3
       DEC    r85                     ;5
       TYA                            ;2
;       JSR    LFDD4                   ;6
       brk                            ;7
       nop                            ;2

       BVS    LF1AD                   ;2
LF17E:
       STX    rD0                     ;3
       ASL    rD0                     ;5
       LDA    rD0                     ;3
       SBC    #$01                    ;2
       CLC                            ;2
       ADC    rBF+9                   ;3
       STA    rBF+9                   ;3
       ASL                            ;2
       TAX                            ;2
       LDA    r98,X                   ;4

       CMP    #$7E                    ;2
       BNE    LF19F                   ;2
       LDY    #$00                    ;2
       STY    rCB                     ;3
;here
       LDA    #$28                    ;2
       STA    rDB                     ;3
       STA    rEB                     ;3
       BNE    LF1A5                   ;2 always branch

LF19F:
       LDY    #$F8                    ;2
       CMP    #$30                    ;2
       BNE    LF1B0                   ;2
LF1A5:
       STY    rD0                     ;3
       BEQ    LF1B0                   ;2
;       LDA    #$5C                    ;2
       lda    #<Blank_Object_gfx      ;2

       STA    r98,X                   ;4
LF1AD:
       JMP    LF225                   ;3

LF1B0:
       STX    rD7                     ;3
       LDY    rBF+9                   ;3
       LDX    rA4,Y                   ;4
       LDA    LFD56,X                 ;4
       STA    rD6                     ;3
       LDA.wy r91+1,Y                 ;4
       LDY    #$00                    ;2
       CLC                            ;2
       ADC    #$0A                    ;2
LF1C3:
       CMP    r84                     ;3
       BCS    LF1D7                   ;2
LF1C7:
       CLC                            ;2
       ADC    rD6                     ;3
       CMP    #$A1                    ;2
       BCC    LF1D0                   ;2
       SBC    #$A0                    ;2
LF1D0:
       INY                            ;2
       CPY    #$03                    ;2
       BEQ    LF1AD                   ;2
       BNE    LF1C3                   ;2 always branch

LF1D7:
       SBC    #$10                    ;2
       CMP    r84                     ;3
       BCC    LF1E2                   ;2
       ADC    #$0F                    ;2
       JMP    LF1C7                   ;3

LF1E2:
       TXA                            ;2
       ASL                            ;2
       ASL                            ;2
       STY    rD6                     ;3
       ADC    rD6                     ;3
       TAX                            ;2
       LDY    LFDE2,X                 ;4
       CPY    #$FF                    ;2
       BCC    LF20D                   ;2
;       LDA    #$5C                    ;2
       lda    #<Blank_Object_gfx      ;2

       LDX    rD7                     ;3
       STA    r98,X                   ;4
       LDX    rBF+9                   ;3
       LDA    r91                     ;3
       CPX    #$02                    ;2
       BEQ    LF203                   ;2
       CPX    #$03                    ;2
       BNE    LF207                   ;2
LF203:
       EOR    #$FF                    ;2
       SBC    #$5F                    ;2
LF207:
       ADC    LFF1C,X                 ;4
       JMP    LF219                   ;3

LF20D:
       LDX    rBF+9                   ;3
       TYA                            ;2
       AND    #$0F                    ;2
       STA    rA4,X                   ;4
       TYA                            ;2
       AND    #$F0                    ;2
       ADC    r91+1,X                 ;4
LF219:
       CMP    #$A1                    ;2
       BCC    LF21F                   ;2
       SBC    #$A0                    ;2
LF21F:
       STA    r91+1,X                 ;4
       LDA    #$00                    ;2
       STA    rB1,X                   ;4
LF225:
       STA    CXCLR                   ;3
       LDA    rD0                     ;3
       BEQ    LF299                   ;2
       LDX    rAC                     ;3
       LDY    #$00                    ;2
       CMP    #$0F                    ;2
       BCC    LF27F                   ;2
       CMP    #$90                    ;2
       BCC    LF284                   ;2
       CMP    #$F0                    ;2
       BCS    LF257                   ;2
       AND    #$70                    ;2
       SED                            ;2
       SEC                            ;2
       STA    rD0                     ;3
       LDA    rAE,X                   ;4
       SBC    rD0                     ;3
       STA    rAE,X                   ;4
       STY    rD0                     ;3
       LDA    rAD,X                   ;4
       SBC    rD0                     ;3
       STA    rAD,X                   ;4
       BCS    LF296                   ;2
       STY    rAE,X                   ;4
       STY    rAD,X                   ;4
       BCC    LF296                   ;2
LF257:
       AND    #$0F                    ;2
       CMP    #$0A                    ;2
       BCC    LF26D                   ;2
       AND    #$07                    ;2
       STA    rD0                     ;3
       LDA    r83                     ;3
       SBC    rD0                     ;3
       STA    r83                     ;3
       BCS    LF296                   ;2
       STY    r83                     ;3
       BCC    LF296                   ;2
LF26D:
       ADC    r83                     ;3
       CMP    #$28                    ;2
       BCC    LF275                   ;2
       LDA    #$28                    ;2
LF275:
       STA    r83                     ;3
       LDX    rC9                     ;3
       BEQ    LF296                   ;2
       STX    rCB                     ;3
       BNE    LF296                   ;2 always branch

LF27F:
       SBC    #$00                    ;2
       CLC                            ;2
       ADC    rAA                     ;3
LF284:
       SED                            ;2
       ADC    rAE,X                   ;4
       STA    rAE,X                   ;4
       TYA                            ;2
       ADC    rAD,X                   ;4
  IF MSG_TEST = 0
       BCC    LF290                   ;2
  ENDIF
;score rollover unlocks programmer message
       LDY    #$28                    ;2
LF290:
       STY    rEB                     ;3
       STA    rAD,X                   ;4
       LDY    #$00                    ;2
LF296:
       STY    rD0                     ;3
       CLD                            ;2
LF299:
       LDX    #$05                    ;2
LF29B:
       LDY    #$00                    ;2
       STY    rB9,X                   ;4
       DEX                            ;2
       BPL    LF29B                   ;2
       LDA    r83                     ;3
       BNE    LF2C6                   ;2
       STA    rEE                     ;3
       LDX    rD4                     ;3
       BNE    LF2C6                   ;2
       STA    rCB                     ;3
       LDX    rEC                     ;3
       BNE    LF2C6                   ;2
       LDX    rF0                     ;3
       BEQ    LF2BE                   ;2
       JSR    LFCE6                   ;6
       STA    rDA                     ;3
       TYA                            ;2
       STA    rF0                     ;3
LF2BE:
       LDX    rC9                     ;3
       BNE    LF2C6                   ;2
       LDX    #$2C                    ;2
       STX    rDB                     ;3
LF2C6:
       DEY                            ;2
       LDX    #$05                    ;2
LF2C9:
       CMP    LFD50,X                 ;4
       BCC    LF2D3                   ;2
       STY    rB9,X                   ;4
       DEX                            ;2
       BNE    LF2C9                   ;2
LF2D3:
       STX    rBF+9                   ;3

;added...
       cmp    #$15                    ;2
       bcc    No_Subt                 ;2
       sec                            ;2
       sbc    #$14                    ;2
No_Subt:


       TAX                            ;2
       LDA    LFF2B,X                 ;4
       LDX    rBF+9                   ;3
       STA    rB9,X                   ;4
       LDA    rCB                     ;3
       BNE    LF2E9                   ;2
       LDA    r83                     ;3
       BNE    LF2E9                   ;2
       LDA    rD4                     ;3
       BEQ    LF347                   ;2
LF2E9:
       LDA    r90                     ;3
       CMP    #$14                    ;2
       BEQ    LF34F                   ;2
       LDA    rE6                     ;3
       BNE    LF318                   ;2
       LDA    rCD                     ;3
       CMP    #$06                    ;2
       BNE    LF349                   ;2
       LDY    #$FE                    ;2
       LDX    rCC                     ;3
       CPX    #$04                    ;2
       BCS    LF349                   ;2
       STY    rE6                     ;3
       LDA    LFB0D,X                 ;4
       STA    rE9                     ;3
       STX    rE7                     ;3
       LDA    LFE58,X                 ;4
       STA    r87                     ;3
       LDA    LFAFF,X                 ;4
       STA    r89                     ;3
       ASL    rE7                     ;5
       ASL    rE7                     ;5
LF318:
       INC    rE8                     ;5
       LDA    rE8                     ;3
       BEQ    LF347                   ;2
       LDX    #$00                    ;2
       CMP    #$30                    ;2
       BEQ    LF333                   ;2
       INX                            ;2
       CMP    #$60                    ;2
       BEQ    LF333                   ;2
       INX                            ;2
       CMP    #$90                    ;2
       BEQ    LF333                   ;2
       INX                            ;2
       CMP    #$C0                    ;2
       BNE    LF34F                   ;2
LF333:
       TXA                            ;2
       CLC                            ;2
       ADC    rE7                     ;3
       TAX                            ;2
       LDA    LFE40,X                 ;4
       STA    rE9                     ;3
       LDA    LFE8E,X                 ;4
       STA    r87                     ;3
       LDA    LFE9E,X                 ;4
       BNE    LF34D                   ;2 always branch

LF347:
       STA    rE6                     ;3
LF349:
       LDA    #<Extra_gfx-4           ;2 blank
       STA    r87                     ;3
LF34D:
       STA    r89                     ;3
LF34F:
       LDA    rEE                     ;3
       BEQ    LF355                   ;2
       BNE    LF387                   ;2 always branch

LF355:
       LDA    rC9                     ;3
       BNE    LF37F                   ;2
       LDX    #$96                    ;2
       LDA    rCA                     ;3
       BNE    LF361                   ;2
       LDX    #$0C                    ;2
LF361:
       CPX    r82                     ;3
       BNE    LF367                   ;2
       EOR    #$01                    ;2
LF367:
       STA    rCA                     ;3


;<Eat_Bullet1_gfx?
       LDA    #$AE                    ;2
       STA    rD4                     ;3
       LDX    rB7                     ;3
       BNE    LF379                   ;2
       STA    rB7                     ;3
       LDA    r82                     ;3
       ADC    #$02                    ;2
       STA    r84                     ;3
LF379:
       LDA    rCA                     ;3
       BEQ    LF39F                   ;2
       BNE    LF3AB                   ;2 always branch

LF37F:
       LDA    rCB                     ;3
       BNE    LF38A                   ;2
       LDA    rD4                     ;3
       BNE    LF38A                   ;2
LF387:
       JMP    LF448                   ;3
LF38A:
       LDA    SWCHA                   ;4
       LDX    rAC                     ;3
       BEQ    LF395                   ;2
       ASL                            ;2
       ASL                            ;2
       ASL                            ;2
       ASL                            ;2
LF395:
       AND    #$F0                    ;2
       CMP    #$D0                    ;2
       BCS    LF3B3                   ;2
       AND    #$80                    ;2
       BEQ    LF3AB                   ;2
LF39F:
       LDA    r82                     ;3
       DEC    r82                     ;5
       CMP    #$0C                    ;2
       BNE    LF3B3                   ;2
LF3A7:
       STA    r82                     ;3
       BCS    LF3B3                   ;2
LF3AB:
       LDA    r82                     ;3
       INC    r82                     ;5
       CMP    #$96                    ;2
       BEQ    LF3A7                   ;2
LF3B3:
       LDY    #$01                    ;2
       LDX    rAA                     ;3
       LDA    r80                     ;3
       CMP    LFF15,X                 ;4
       BCS    LF3C0                   ;2
       DEC    rD1                     ;5
LF3C0:
       DEC    rD1                     ;5
       BPL    LF3F6                   ;2
       LDA    #$02                    ;2
       STA    rD1                     ;3
       LDX    #$06                    ;2
LF3CA:
       INC    r91,X                   ;6
       LDA    r91,X                   ;4
       CMP    #$A1                    ;2
       BNE    LF3DE                   ;2
       STY    r91,X                   ;4
       LDA    r9C,X                   ;4
       CMP    #$7E                    ;2
       BNE    LF3DE                   ;2
       LDA    #$00                    ;2
       STA    r9C+6                   ;3
LF3DE:
       DEX                            ;2
       BMI    LF3E9                   ;2
       CPX    #$04                    ;2
       BNE    LF3CA                   ;2
       LDX    #$02                    ;2
       BNE    LF3CA                   ;2 always branch

LF3E9:
       LDY    #$A0                    ;2
       LDX    #$01                    ;2
LF3ED:
       DEC    r91+3,X                 ;6
       BNE    LF3F3                   ;2
       STY    r91+3,X                 ;4
LF3F3:
       DEX                            ;2
       BPL    LF3ED                   ;2
LF3F6:
       LDA    rD4                     ;3
       BEQ    LF409                   ;2
       LDA    rB7                     ;3
       SEC                            ;2
       SBC    #$05                    ;2
       STA    rB7                     ;3
       BCS    LF409                   ;2
       LDA    #$00                    ;2
       STA    rD4                     ;3
       STA    rB7                     ;3
LF409:
       LDA    rAC                     ;3
       LSR                            ;2
       TAX                            ;2
       LDA    REFP1,X                 ;4 get trigger
;       AND    #$80                    ;2

       bmi    LF438                   ;2

       LDA    rD2                     ;3
       BNE    LF43C                   ;2
       DEC    rD2                     ;5
       LDA    rD4                     ;3
       BNE    LF43C                   ;2
       STA    rDB                     ;3
       DEC    rD4                     ;5
       LDA    r82                     ;3
       ADC    #$02                    ;2
       STA    r84                     ;3
       LDA    #$A9                    ;2
       STA    rB7                     ;3
       LDA    #$38                    ;2
;       JSR    LFDD4                   ;6
       brk                            ;7
       nop                            ;2

       DEC    r83                     ;5
       BPL    LF438                   ;2
       LDA    #$00                    ;2
       STA    r83                     ;3
LF438:
       LDA    #$00                    ;2
       STA    rD2                     ;3
LF43C:
       LDA    r83                     ;3
       CMP    #$0B                    ;2
       BCS    LF448                   ;2
       LDA    rCF                     ;3
       AND    #$20                    ;2
       BNE    LF44A                   ;2
LF448:
       LDA    #$00                    ;2
LF44A:
       STA    rB8                     ;3
LF44C:
       LDX    #$08                    ;2
       LDA    rB7                     ;3
       STA    rBF+9                   ;3
LF452:
       LDA    rBF+9                   ;3
       SEC                            ;2
       SBC    #$15                    ;2
       STA    rBF+9                   ;3
       BPL    LF461                   ;2
       ADC    #$1D                    ;2
       CMP    #$3A                    ;2
       BCC    LF463                   ;2
;here
LF461:
       LDA    #$1C                    ;2
LF463:
       STA    rDC,X                   ;4
       DEX                            ;2
       BPL    LF452                   ;2
       LDA    #>Bullet_Data           ;2
       STA    rE5                     ;3
       LDX    #$06                    ;2
;       LDA    rEB                     ;3
;       BNE    LF488                   ;2 branch if printing programmer message
       LDA    rC9                     ;3
       BEQ    LF4D7                   ;2 branch to setup scrolling message
       LDA    rCB                     ;3
       BNE    LF4A0                   ;2
       LDA    rEC                     ;3
       BEQ    LF484                   ;2
       CMP    #$DF                    ;2
       BEQ    LF4EE                   ;2
       BNE    LF4A0                   ;2 always branch

LF484:
       LDA    r83                     ;3
       BEQ    LF48E                   ;2

LF488:
       LDA    rEE                     ;3
       BEQ    LF4FC                   ;2
       BNE    LF4A0                   ;2 always branch

LF48E:
       LDA    rD5                     ;3
       BEQ    LF4A0                   ;2
       LDA    #$7F                    ;2
       BIT    rDA                     ;3
       BNE    LF49E                   ;2
       LDA    rAC                     ;3
       EOR    #$02                    ;2
       STA    rAC                     ;3
LF49E:
       BVC    LF4F8                   ;2

;convert score to pointers
LF4A0:
       LDY    rAC                     ;3 load score offset
LF4A2:
       LDA.wy rAD,Y                   ;4
       AND    #$F0                    ;2
       lsr                            ;2

       STA    rBF+2,X                 ;4
       LDA.wy rAD,Y                   ;4
       AND    #$0F                    ;2
       asl                            ;2
       asl                            ;2
       asl                            ;2

       sta    rBF,X                   ;4
       LDA    #>Digit_gfx             ;2
       sta    rBF+1,X                 ;4
       sta    rBF+3,X                 ;4
       INY                            ;2
       dex                            ;2
       dex                            ;2
       DEX                            ;2
       DEX                            ;2
       BPL    LF4A2                   ;2
;last digit always zero when displaying score...
       LDA    #<Digit0_gfx            ;2
       STA    rBF                     ;3
       LDA    #>Digit0_gfx            ;2
       STA    rBF+1                   ;3

;hhere
;       LDX    #$50                    ;2 p1 color pointer
       ldx    #<P1_Color              ;2 p1 color pointer
       LDA    rAC                     ;3
       BEQ    LF4D3                   ;2
;       LDX    #$A6                    ;2 p2 color pointer
       ldx    #<P2_Color              ;2 p2 color pointer
LF4D3:
       STX    r8D                     ;3
       BCC    LF51B                   ;2 branch if OK to display score

;do scrolling message
LF4D7:

       lda    #<Scorecolor_Init       ;2
       clc                            ;2
       adc    rD8                     ;3
       sta    r8D                     ;3

       LDA    #<Scroll_Msg - 8        ;2
       CLC                            ;2
       ADC    rD8                     ;3
       LDY    #>Scroll_Msg            ;2
       LDX    #$08                    ;2
LF4E2:
       STA    rBF,X                   ;4
       STY    rBF+1,X                 ;4
       ADC    #$13                    ;2 19 bytes between characters
       DEX                            ;2
       DEX                            ;2
       BPL    LF4E2                   ;2
       BMI    LF51B                   ;2 always branch




LF4EE:
       LDA    rDA                     ;3
       AND    #$20                    ;2
       BEQ    LF4F8                   ;2
       LDA    #<Scorecolor_Init       ;2
       BNE    LF500                   ;2 always branch

LF4F8:
       LDX    rAC                     ;3
       BPL    LF4FE                   ;2


LF4FC:
       LDX    rD5                     ;3
LF4FE:
       LDA    #<Logocolor             ;2

;note...some memory should be reclaimed by removing redundant characters...
LF500:
       STA    r8D                     ;3
;       LDA    #<Player_Two_Up_gfx     ;2
;       CPX    #$02                    ;2
;       BEQ    LF50A                   ;2 branch if 2 player
;       LDA    #<Player_One_Up_gfx     ;2
;LF50A:
;       CLC                            ;2
;       ADC    rEB                     ;3
;       LDY    #>Player_One_Up_gfx     ;2
;       LDX    #$08                    ;2
;LF511:
;       STA    rBF,X                   ;4
;       STY    rBF+1,X                 ;4
;       ADC    #$08                    ;2
;       DEX                            ;2
;       DEX                            ;2
;       BPL    LF511                   ;2

       ldy    #$09                     ;2 player 2 pointers
       CPX    #$02                    ;2
       BEQ    LF50A                   ;2 branch if 2 player
       ldy    #$04                     ;2 player 1 pointers
LF50A:
       LDX    #$08                    ;2
       lda    rEB                     ;3
       beq    LF511                   ;2 branch if not printing programmer message
       tya                            ;2
       clc                            ;2
       adc    #$0A                    ;2
       tay                            ;2
LF511:
       lda    Player_Up_Tbl,Y         ;4
       sta    rBF,X                   ;4
       lda    #>Player_Up_1_gfx       ;2
       sta    rBF+1,X                 ;4
       dey                            ;2
       dex                            ;2
       dex                            ;2
       BPL    LF511                   ;2


LF51B:
       jmp    New_Display             ;4








Bear_Stuff:
LFAA8b:
       LDX    INTIM                   ;4
       BNE    LFAA8b                  ;2
       lda    #$02                    ;2
       sta    WSYNC                   ;3
       sta    VBLANK                  ;3
;;       sta    WSYNC                   ;3
;;       sta    WSYNC                   ;3
       sta    VSYNC                   ;3
       sta    WSYNC                   ;3
;;       sta    WSYNC                   ;3
;       LDX    #$00                    ;2
       sta    WSYNC                   ;3
       stx    VSYNC                   ;3
;       JMP    LF011                   ;3
;LF011:
       LDA    #$E8                    ;2
       STA    TIM8T                   ;4
;       LDA    REFP1                   ;3
;       AND    #$80                    ;2
;       BNE    LF034                   ;2
;       CPX    #$00                    ;2
;       BEQ    LF028                   ;2
;       STA    rA4+5                   ;3
;       LDX    #$7E                    ;2
;       STX    r9C+6                   ;3
;       BNE    LF08E                   ;2 always branch

       jmp    LF38A                   ;3












;9
LFF54:
       LDA    LFBD4,X                 ;4
       STA    r80,X                   ;4
       DEX                            ;2
       BPL    LFF54                   ;2
       RTS                            ;6








START:
       SEI                            ;2
       CLD                            ;2
       LDX    #$FF                    ;2
       TXS                            ;2
       INX                            ;2
       TXA                            ;2
LF007:
       STA    VSYNC,X                 ;4
       INX                            ;2
       BNE    LF007                   ;2
       LDX    #$37                    ;2
       JSR    LFF54                   ;6
       jmp    LF011                   ;3







LFCE6:
       LDA    rAC                     ;3
       EOR    rF0                     ;3
       STA    rAC                     ;3
       BEQ    LFCF2                   ;2
       LDA    rF0                     ;3
       BNE    LFCFA                   ;2
LFCF2:
       LDA    rAA                     ;3
       CMP    #$04                    ;2
       BEQ    LFCFA                   ;2
       INC    rAA                     ;5
LFCFA:
       LDX    #$DF                    ;2
       STX    rEC                     ;3
       RTS                            ;6




LFDD4:
       LDY    r90                     ;3
       CPY    #$14                    ;2
       BNE    LFDDB                   ;2
       rti                            ;6
LFDDB:
       STA    r90                     ;3
       LDA    #$FE                    ;2
       STA    r8F                     ;3
       rti                            ;6










       ORG $2E00
       RORG $FE00

Bullet_Data: ;bullet enable data only uses bit 1...shared w/other tables...

LFF00: ;bank2
       .byte $14 ; |   X X  | $FF00
       .byte $24 ; |  X  X  | $FF01
       .byte $14 ; |   X X  | $FF02
       .byte $44 ; | X   X  | $FF03
       .byte $14 ; |   X X  | $FF04
       .byte $24 ; |  X  X  | $FF05
       .byte $24 ; |  X  X  | $FF06
       .byte $14 ; |   X X  | $FF07
LFF08: ;bank2
       .byte $24 ; |  X  X  | $FF08
       .byte $94 ; |X  X X  | $FF09
       .byte $84 ; |X    X  | $FF0A
       .byte $94 ; |X  X X  | $FF0B
       .byte $64 ; | XX  X  | $FF0C
       .byte $94 ; |X  X X  | $FF0D
       .byte $84 ; |X    X  | $FF0E
       .byte $84 ; |X    X  | $FF0F
       .byte $84 ; |X    X  | $FF10
LFF11: ;bank2
       .byte $64 ; | XX  X  | $FF11
       .byte $80 ; |X       | $FF12
       .byte $A0 ; |X X     | $FF13
       .byte $C0 ; |XX      | $FF14
LFF15: ;bank2
       .byte $D0 ; |XX X    | $FF15
       .byte $21 ; |  X    X| $FF16
       .byte $2A ; |  X X X | $FF17 \
       .byte $2F ; |  X XXXX| $FF18  \
       .byte $32 ; |  XX  X | $FF19   > only these lines enable bullets (bit 1 set)
       .byte $FF ; |XXXXXXXX| $FF1A  /
       .byte $FF ; |XXXXXXXX| $FF1B /
LFF1C: ;bank2
       .byte $00 ; |        | $FF1C
       .byte $50 ; | X X    | $FF1D
       .byte $04 ; |     X  | $FF1E
       .byte $54 ; | X X X  | $FF1F
       .byte $08 ; |    X   | $FF20
       .byte $58 ; | X XX   | $FF21
LFF22: ;bank2
       .byte $00 ; |        | $FF22
       .byte $00 ; |        | $FF23
       .byte $00 ; |        | $FF24
       .byte $08 ; |    X   | $FF25
       .byte $00 ; |        | $FF26
       .byte $08 ; |    X   | $FF27
       .byte $09 ; |    X  X| $FF28
       .byte $00 ; |        | $FF29
LFF2B: ;bank2...bullet gfx
       .byte $00 ; |        | $FF2B
       .byte $10 ; |   X    | $FF2C -$14
       .byte $30 ; |  XX    | $FF2D
       .byte $70 ; | XXX    | $FF2E
       .byte $F0 ; |XXXX    | $FF2F ;bullet enable data ends here

       .byte $80 ; |X       | $FF30
       .byte $C0 ; |XX      | $FF31
       .byte $E0 ; |XXX     | $FF32
       .byte $F0 ; |XXXX    | $FF33
       .byte $F8 ; |XXXXX   | $FF34
       .byte $FC ; |XXXXXX  | $FF35
       .byte $FE ; |XXXXXXX | $FF36
       .byte $FF ; |XXXXXXXX| $FF37

       .byte $01 ; |       X| $FF38
       .byte $03 ; |      XX| $FF39
       .byte $07 ; |     XXX| $FF3A
       .byte $0F ; |    XXXX| $FF3B
       .byte $1F ; |   XXXXX| $FF3C
       .byte $3F ; |  XXXXXX| $FF3D
       .byte $7F ; | XXXXXXX| $FF3E
       .byte $FF ; |XXXXXXXX| $FF3F $14


;28
LFE40: ;bank2
       .byte $F5 ; |XXXX X X| $FE40
       .byte $F4 ; |XXXX X  | $FE41
       .byte $F3 ; |XXXX  XX| $FE42
       .byte $F2 ; |XXXX  X | $FE43
       .byte $FE ; |XXXXXXX | $FE44
       .byte $FE ; |XXXXXXX | $FE45
       .byte $FE ; |XXXXXXX | $FE46
       .byte $FE ; |XXXXXXX | $FE47
       .byte $40 ; | X      | $FE48
       .byte $30 ; |  XX    | $FE49
       .byte $20 ; |  X     | $FE4A
       .byte $10 ; |   X    | $FE4B
       .byte $D0 ; |XX X    | $FE4C
       .byte $D0 ; |XX X    | $FE4D
       .byte $D0 ; |XX X    | $FE4E
       .byte $D0 ; |XX X    | $FE4F
       .byte $E8 ; |XXX X   | $FE50
       .byte $E8 ; |XXX X   | $FE51
       .byte $E8 ; |XXX X   | $FE52
       .byte $E8 ; |XXX X   | $FE53
       .byte $E8 ; |XXX X   | $FE54
       .byte $E8 ; |XXX X   | $FE55
       .byte $E8 ; |XXX X   | $FE56
       .byte $E8 ; |XXX X   | $FE57
LFE58: ;bank2
       .byte <Add_Bullet1_gfx-4     ; $FE58
       .byte <Subtract_Bullet_gfx-4 ; $FE59
       .byte <Add_500_gfx-4         ; $FE5A
       .byte <Subtract_500_gfx-4    ; $FE5B

;4
LFB0D: ;bank2
       .byte $F6 ; |XXXX XX | $FB0D
       .byte $FE ; |XXXXXXX | $FB0E
       .byte $50 ; | X X    | $FB0F
       .byte $D0 ; |XX X    | $FB10



;       ORG $2E63
;       RORG $FE63
;       .byte $00







       ORG $2F00
       RORG $FF00

;56
;ram init table
LFBD4: ;bank2
       .byte $3F ; |  XXXXXX| $FBD4 $80
       .byte $4F ; | X  XXXX| $FBD5 $81
       .byte $54 ; | X X X  | $FBD6 $82
       .byte $28 ; |  X X   | $FBD7 $83
       .byte $51 ; | X X   X| $FBD8 $84
       .byte $08 ; |    X   | $FBD9 $85
       .byte $0F ; |    XXXX| $FBDA $86

       .word Extra_gfx-4     ; $FBDB $87/8
       .word Extra_gfx-4     ; $FBDD $89/a
       .word Bullet_Init     ; $FBDF $8b/c
       .word Scorecolor_Init ; $FBE1 $8d/e

       .byte $FE ; |XXXXXXX | $FBE3 $8f
       .byte $5C ; | X XXX  | $FBE4 $90
       .byte $00 ; |        | $FBE5 $91
       .byte $00 ; |        | $FBE6 $92
       .byte $20 ; |  X     | $FBE7 $93
       .byte $04 ; |     X  | $FBE8 $94
       .byte $54 ; | X X X  | $FBE9 $95
       .byte $68 ; | XX X   | $FBEA $96
       .byte $19 ; |   XX  X| $FBEB $97

       .word Duck_gfx  ; $FBEC $98/9
       .word Bunny_gfx ; $FBEE $9a/b
       .word Duck_gfx  ; $FBF0 $9c/d
       .word Shot_gfx  ; $FBF2 $9e/f
       .word Bunny_gfx ; $FBF4 $a0/1
       .word Owl_gfx   ; $FBF6 $a2/3

       .byte $00 ; |        | $FBF8 $a4
       .byte $03 ; |      XX| $FBF9 $a5
       .byte $06 ; |     XX | $FBFA $a6
       .byte $04 ; |     X  | $FBFB $a7
       .byte $06 ; |     XX | $FBFC $a8
       .byte $06 ; |     XX | $FBFD $a9
       .byte $01 ; |       X| $FBFE $aa
       .byte $91 ; |X  X   X| $FBFF $ab
       .byte $00 ; |        | $FC0C
       .byte $00 ; |        | $FC0D
       .byte $00 ; |        | $FC0E
       .byte $00 ; |        | $FC0F
       .byte $00 ; |        | $FC10
       .byte $00 ; |        | $FC11
       .byte $00 ; |        | $FC0C
       .byte $00 ; |        | $FC0D
       .byte $00 ; |        | $FC0E
       .byte $00 ; |        | $FC0F
       .byte $00 ; |        | $FC10
       .byte $00 ; |        | $FC11

;20
Player_Up_Tbl: ;bank2
        .byte <Player_Up_5_gfx
        .byte <Player_Up_4_gfx
        .byte <Player_Up_3_gfx
        .byte <Player_Up_2_gfx
        .byte <Player_Up_1_gfx
        .byte <Player_Up_7_gfx
        .byte <Player_Up_6_gfx
        .byte <Player_Up_3_gfx
        .byte <Player_Up_2_gfx
        .byte <Player_Up_1_gfx
        .byte <Programmer0_gfx
        .byte <Programmer1_gfx
        .byte <Programmer2_gfx
        .byte <Programmer3_gfx
        .byte <Programmer4_gfx
        .byte <Programmer5_gfx
        .byte <Programmer6_gfx
        .byte <Programmer7_gfx
        .byte <Programmer8_gfx
        .byte <Programmer9_gfx


;13
LFB11: ;bank2
       .byte $02 ; |      X | $FB11
       .byte $03 ; |      XX| $FB12
       .byte $03 ; |      XX| $FB13
       .byte $02 ; |      X | $FB14
       .byte $01 ; |       X| $FB15
       .byte $06 ; |     XX | $FB16
       .byte $ED ; |XXX XX X| $FB17
       .byte $CB ; |XX  X XX| $FB18
       .byte $A9 ; |X X X  X| $FB19
       .byte $87 ; |X    XXX| $FB1A
       .byte $65 ; | XX  X X| $FB1B
       .byte $43 ; | X    XX| $FB1C
       .byte $6F ; | XX XXXX| $FB1D

;56
LFAC7: ;bank2
       .byte $F3 ; |XXXX  XX| $FAC7
       .byte $DF ; |XX XXXXX| $FAC8
       .byte $B3 ; |X XX  XX| $FAC9
       .byte $93 ; |X  X  XX| $FACA
       .byte $73 ; | XXX  XX| $FACB
       .byte $53 ; | X X  XX| $FACC
       .byte $53 ; | X X  XX| $FACD
       .byte $53 ; | X X  XX| $FACE
       .byte $33 ; |  XX  XX| $FACF
       .byte $33 ; |  XX  XX| $FAD0
       .byte $33 ; |  XX  XX| $FAD1
       .byte $33 ; |  XX  XX| $FAD2
       .byte $33 ; |  XX  XX| $FAD3
       .byte $33 ; |  XX  XX| $FAD4
       .byte $00 ; |        | $FAD5
       .byte $00 ; |        | $FAD6
       .byte $CE ; |XX  XXX | $FAD7
       .byte $EE ; |XXX XXX | $FAD8
       .byte $CE ; |XX  XXX | $FAD9
       .byte $AE ; |X X XXX | $FADA
       .byte $8E ; |X   XXX | $FADB
       .byte $AE ; |X X XXX | $FADC
       .byte $CE ; |XX  XXX | $FADD
       .byte $AE ; |X X XXX | $FADE
       .byte $8E ; |X   XXX | $FADF
       .byte $6E ; | XX XXX | $FAE0
       .byte $8E ; |X   XXX | $FAE1
       .byte $AE ; |X X XXX | $FAE2
       .byte $8E ; |X   XXX | $FAE3
       .byte $6E ; | XX XXX | $FAE4
       .byte $4E ; | X  XXX | $FAE5
       .byte $6E ; | XX XXX | $FAE6
       .byte $8E ; |X   XXX | $FAE7
       .byte $6E ; | XX XXX | $FAE8
       .byte $4E ; | X  XXX | $FAE9
       .byte $2E ; |  X XXX | $FAEA
       .byte $4E ; | X  XXX | $FAEB
       .byte $6E ; | XX XXX | $FAEC
       .byte $4E ; | X  XXX | $FAED
       .byte $2E ; |  X XXX | $FAEE
       .byte $4E ; | X  XXX | $FAEF
       .byte $6E ; | XX XXX | $FAF0
       .byte $4E ; | X  XXX | $FAF1
       .byte $2E ; |  X XXX | $FAF2
       .byte $2E ; |  X XXX | $FAF3
       .byte $2E ; |  X XXX | $FAF4
       .byte $2E ; |  X XXX | $FAF5
       .byte $00 ; |        | $FAF6
       .byte $A6 ; |X X  XX | $FAF7
       .byte $C6 ; |XX   XX | $FAF8
       .byte $E6 ; |XXX  XX | $FAF9
       .byte $86 ; |X    XX | $FAFA
       .byte $66 ; | XX  XX | $FAFB
       .byte $46 ; | X   XX | $FAFC
       .byte $26 ; |  X  XX | $FAFD
LFD50: ;bank2
       .byte $00 ; |        | $FD50 shared
       .byte $21 ; |  X    X| $FD51
       .byte $19 ; |   XX  X| $FD52
       .byte $15 ; |   X X X| $FD53
       .byte $0D ; |    XX X| $FD54
       .byte $05 ; |     X X| $FD55
LFD56: ;bank2
       .byte $00 ; |        | $FD56
       .byte $10 ; |   X    | $FD57
       .byte $20 ; |  X     | $FD58
       .byte $10 ; |   X    | $FD59
       .byte $40 ; | X      | $FD5A
       .byte $00 ; |        | $FD5B
       .byte $20 ; |  X     | $FD5C


;30
LFDE2: ;bank2
       .byte $FF ; |XXXXXXXX| $FDE2
       .byte $FF ; |XXXXXXXX| $FDE3
       .byte $FF ; |XXXXXXXX| $FDE4
       .byte $FF ; |XXXXXXXX| $FDE5
       .byte $10 ; |   X    | $FDE6
       .byte $00 ; |        | $FDE7
       .byte $FF ; |XXXXXXXX| $FDE8
       .byte $FF ; |XXXXXXXX| $FDE9
       .byte $20 ; |  X     | $FDEA
       .byte $00 ; |        | $FDEB
       .byte $FF ; |XXXXXXXX| $FDEC
       .byte $FF ; |XXXXXXXX| $FDED
       .byte $11 ; |   X   X| $FDEE
       .byte $02 ; |      X | $FDEF
       .byte $01 ; |       X| $FDF0
       .byte $FF ; |XXXXXXXX| $FDF1
       .byte $40 ; | X      | $FDF2
       .byte $00 ; |        | $FDF3
       .byte $FF ; |XXXXXXXX| $FDF4
       .byte $FF ; |XXXXXXXX| $FDF5
       .byte $92 ; |X  X  X | $FDF6
       .byte $C0 ; |XX      | $FDF7
       .byte $64 ; | XX  X  | $FDF8
       .byte $22 ; |  X   X | $FDF9
       .byte $22 ; |  X   X | $FDFA
       .byte $04 ; |     X  | $FDFB
       .byte $02 ; |      X | $FDFC
       .byte $FF ; |XXXXXXXX| $FDFD
       .byte $AC ; |X X XX  | $FDFE
       .byte $88 ; |X   X   | $FDFF


LFE8E: ;bank2
       .byte <Add_Bullet1_gfx-4     ; $FE8E
       .byte <Add_Bullet1_gfx-4     ; $FE8F
       .byte <Add_Bullet1_gfx-4     ; $FE90
       .byte <Add_Bullet1_gfx-4     ; $FE91
       .byte <Subtract_Bullet_gfx-4 ; $FE92
       .byte <Subtract_Bullet_gfx-4 ; $FE93
       .byte <Subtract_Bullet_gfx-4 ; $FE94
       .byte <Subtract_Bullet_gfx-4 ; $FE95
       .byte <Add_400_gfx-4         ; $FE96
       .byte <Add_300_gfx-4         ; $FE97
       .byte <Add_200_gfx-4         ; $FE98
       .byte <Add_100_gfx-4         ; $FE99
       .byte <Subtract_500_gfx-4    ; $FE9A
       .byte <Subtract_500_gfx-4    ; $FE9B
       .byte <Subtract_500_gfx-4    ; $FE9C
       .byte <Subtract_500_gfx-4    ; $FE9D

LFE9E: ;bank2
       .byte <Add_Bullet3_gfx-4     ; $FE9E
       .byte <Add_Bullet4_gfx-4     ; $FE9F
       .byte <Add_Bullet5_gfx-4     ; $FEA0
       .byte <Extra_gfx-4           ; $FEA1
       .byte <Add_Bullet2_gfx-4     ; $FEA2
       .byte <Add_Bullet2_gfx-4     ; $FEA3
LFAFF: ;bank2 4 bytes
       .byte <Add_Bullet2_gfx-4     ; $FEA4 shared
       .byte <Add_Bullet2_gfx-4     ; $FEA5 shared
       .byte <Double_Zero_gfx-4     ; $FEA6 shared
       .byte <Double_Zero_gfx-4     ; $FEA7 shared
       .byte <Double_Zero_gfx-4     ; $FEA8
       .byte <Double_Zero_gfx-4     ; $FEA9
       .byte <Double_Zero_gfx-4     ; $FEAA
       .byte <Double_Zero_gfx-4     ; $FEAB
       .byte <Double_Zero_gfx-4     ; $FEAC
       .byte <Double_Zero_gfx-4     ; $FEAD

;25
LFEBC: ;bank2
       .byte $91 ; |X  X   X| $FEBC
       .byte $90 ; |X  X    | $FEBD
       .byte $01 ; |       X| $FEBE
       .byte $91 ; |X  X   X| $FEBF
       .byte $71 ; | XXX   X| $FEC0
       .byte $01 ; |       X| $FEC1
       .byte $71 ; | XXX   X| $FEC2
       .byte $70 ; | XXX    | $FEC3
LFEC4: ;bank2
       .byte $46 ; | X   XX | $FEC4
       .byte $00 ; |        | $FEC5
       .byte $00 ; |        | $FEC6
       .byte $46 ; | X   XX | $FEC7
       .byte $46 ; | X   XX | $FEC8
       .byte $00 ; |        | $FEC9
       .byte $46 ; | X   XX | $FECA
LFDCA: ;bank2
       .byte $00 ; |        | $FDCA shared
       .byte $01 ; |       X| $FDCB
       .byte $02 ; |      X | $FDCC
       .byte $01 ; |       X| $FDCD
       .byte $04 ; |     X  | $FDCE
       .byte $01 ; |       X| $FDCF
       .byte $02 ; |      X | $FDD0
       .byte $02 ; |      X | $FDD1
       .byte $03 ; |      XX| $FDD2
       .byte $06 ; |     XX | $FDD3


Pipe_Tbl: ;bank2
       .byte <Pipe1_gfx - 8
       .byte <Pipe2_gfx - 8
       .byte <Pipe3_gfx - 8
       .byte <Pipe4_gfx - 8


       ORG $2FF8
       RORG $FFF8
       .byte "2006"
       .word START2,LFDD4
