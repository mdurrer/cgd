;Jr. PacMan - speed throttle hack by Kurt (Nukey Shay) Howe
;
;
;
; Disassembly of Jr.1
; Disassembled Mon Jul 18 04:42:49 2005
; Using DiStella v2.0
; Command Line: C:\BIN\DISTELLA.EXE -pafscJr1.cfg Jr.1 
; Jr1.cfg contents:
;      GFX 9000 90FF
;      CODE 9100 9229
;      GFX 922A 9237
;      CODE 9238 9254
;      GFX 9255 92A7
;      CODE 92A8 94F5
;      GFX 94F6 952F
;      CODE 9530 9543
;      GFX 9544 9588
;      CODE 9589 95FD
;      GFX 95FE 960D
;      CODE 960E 96CA
;      GFX 96CB 96D6
;      CODE 96D7 98DC
;      GFX 98DD 98E1
;      CODE 98E2 9A3C
;      GFX 9A3D 9A77
;      CODE 9A78 9AEF
;      GFX 9AF0 9AF3
;      CODE 9AF4 9B87
;      GFX 9B88 9B8B
;      CODE 9B8C 9CA5
;      GFX 9CA6 9CEB
;      CODE 9CEC 9DC5
;      GFX 9DC6 9DD4
;      CODE 9DD5 9E55
;      GFX 9E56 9E71
;      CODE 9E72 9F55
;      GFX 9F56 9FE0
;      CODE 9FE1 9FE3
;      GFX 9FE4 9FE6
;      CODE 9FE7 9FEC
;      GFX 9FED 9FEF
;      CODE 9FF0 9FF2
;      GFX 9FF3 9FFF
;
;
; Disassembly of Jr.2
; Disassembled Mon Jul 18 04:43:10 2005
; Using DiStella v2.0
; Command Line: C:\BIN\DISTELLA.EXE -pafscJr2.cfg Jr.2 
; Jr2.cfg contents:
;      GFX B000 B577
;      CODE B578 B5DD
;      GFX B5DE B5FF
;      CODE B600 B83B
;      GFX B83C B856
;      CODE B857 BA79
;      GFX BA7A BA90
;      CODE BA91 BD3B
;      GFX BD3C BDFF
;      CODE BE00 BEC0
;      GFX BEC1 BEFF
;      CODE BF00 BF83
;      GFX BF84 BFD9
;      CODE BFDA BFDC
;      GFX BFDD BFDD
;      CODE BFDE BFE5
;      GFX BFE6 BFEF
;      CODE BFF0 BFF5
;      GFX BFF6 BFFF
;
;
; Disassembly of Jr.3
; Disassembled Mon Jul 18 04:43:33 2005
; Using DiStella v2.0
; Command Line: C:\BIN\DISTELLA.EXE -pafscJr3.cfg Jr.3 
; Jr3.cfg contents:
;      GFX D000 D0FF
;      CODE D100 D564
;      GFX D565 D61A
;      CODE D61B D670
;      GFX D671 D6E6
;      CODE D6E7 D74A
;      GFX D74B D7F0
;      CODE D7F1 D824
;      GFX D825 D83B
;      CODE D83C D856
;      GFX D857 D857
;      CODE D858 D8F6
;      GFX D8F7 D9FF
;      CODE DA00 DA45
;      GFX DA46 DA78
;      CODE DA79 DA90
;      GFX DA91 DA92
;      CODE DA93 DAF6
;      GFX DAF7 DCF6
;      CODE DCF7 DD01
;      GFX DD02 DE01
;      CODE DE02 DE12
;      GFX DE13 DEED
;      CODE DEEE DF7C
;      GFX DF7D DFEF
;      CODE DFF0 DFF5
;      GFX DFF6 DFFF
;
;
; Disassembly of Jr.4
; Disassembled Mon Jul 18 04:43:52 2005
; Using DiStella v2.0
; Command Line: C:\BIN\DISTELLA.EXE -pafscJr4.cfg Jr.4 
; Jr4.cfg contents:
;      GFX F000 F0FF
;      CODE F100 F105
;      GFX F106 F15F
;      CODE F160 F1AC
;      GFX F1AD F1B3
;      CODE F1B4 F356
;      GFX F357 F366
;      CODE F367 F554
;      GFX F555 F570
;      CODE F571 F57A
;      GFX F57B F581
;      CODE F582 F5E0
;      GFX F5E1 F5F6
;      CODE F5F7 F771
;      GFX F772 F77D
;      CODE F77E F8D2
;      GFX F8D3 F8DE
;      CODE F8DF F909
;      GFX F90A F95E
;      CODE F95F FA9B
;      GFX FA9C FCF9
;      CODE FCFA FD3B
;      GFX FD3C FFDC
;      CODE FFDD FFF5
;      GFX FFF6 FFFF
;
;
;dasm JrPacMan.asm -f3 -oTest.bin
;DASM V2.20.10, Macro Assembler (C)1988-2004
;Complete.
;
;
;fc /b JrPacMan.bin Test.bin
;Comparing files JrPacMan.bin and Test.bin
;FC: no differences encountered



      processor 6502

;hardware register equates
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
;Audio registers
AUDC0   =  $15 ;Audio Control - Voice 0 (distortion)
AUDC1   =  $16 ;Audio Control - Voice 1 (distortion)
AUDF0   =  $17 ;Audio Frequency - Voice 0
AUDF1   =  $18 ;Audio Frequency - Voice 1
AUDV0   =  $19 ;Audio Volume - Voice 0
AUDV1   =  $1A ;Audio Volume - Voice 1
;Sprite registers
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
VDEL01  =  $26 ;Vertical Delay Player 1
VDELBL  =  $27 ;Vertical Delay Ball
RESMP0  =  $28 ;Reset Missle 0 to Player 0
RESMP1  =  $29 ;Reset Missle 1 to Player 1
HMOVE   =  $2A ;Apply Horizontal Motion
HMCLR   =  $2B ;Clear Horizontal Move Registers
CXCLR   =  $2C ;Clear Collision Latches
Waste1  =  $2D ;Unused
Waste2  =  $2E ;Unused
Waste3  =  $2F ;Unused
;collisions                     (bit 7) (bit 6)
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
;RIOT registers
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

LDAA9   =   $BAA9

       ORG $1000
       RORG $9000

L9000: .byte $FF ; |XXXXXXXX| $9000
       .byte $FF ; |XXXXXXXX| $9001
       .byte $FF ; |XXXXXXXX| $9002
       .byte $FF ; |XXXXXXXX| $9003
       .byte $FF ; |XXXXXXXX| $9004
       .byte $FF ; |XXXXXXXX| $9005
       .byte $FF ; |XXXXXXXX| $9006
       .byte $FF ; |XXXXXXXX| $9007
       .byte $FF ; |XXXXXXXX| $9008
       .byte $FF ; |XXXXXXXX| $9009
       .byte $FF ; |XXXXXXXX| $900A
       .byte $FF ; |XXXXXXXX| $900B
       .byte $FF ; |XXXXXXXX| $900C
       .byte $FF ; |XXXXXXXX| $900D
       .byte $FF ; |XXXXXXXX| $900E
       .byte $FF ; |XXXXXXXX| $900F
       .byte $FF ; |XXXXXXXX| $9010
       .byte $FF ; |XXXXXXXX| $9011
L9012: .byte $FF ; |XXXXXXXX| $9012
       .byte $FF ; |XXXXXXXX| $9013
       .byte $FF ; |XXXXXXXX| $9014
       .byte $FF ; |XXXXXXXX| $9015
       .byte $FF ; |XXXXXXXX| $9016
       .byte $FF ; |XXXXXXXX| $9017
       .byte $FF ; |XXXXXXXX| $9018
       .byte $FF ; |XXXXXXXX| $9019
       .byte $FF ; |XXXXXXXX| $901A
       .byte $FF ; |XXXXXXXX| $901B
       .byte $FF ; |XXXXXXXX| $901C
       .byte $FF ; |XXXXXXXX| $901D
       .byte $FF ; |XXXXXXXX| $901E
       .byte $FF ; |XXXXXXXX| $901F
       .byte $FF ; |XXXXXXXX| $9020
       .byte $FF ; |XXXXXXXX| $9021
       .byte $FF ; |XXXXXXXX| $9022
       .byte $FF ; |XXXXXXXX| $9023
L9024: .byte $FF ; |XXXXXXXX| $9024
       .byte $FF ; |XXXXXXXX| $9025
       .byte $FF ; |XXXXXXXX| $9026
       .byte $FF ; |XXXXXXXX| $9027
       .byte $FF ; |XXXXXXXX| $9028
       .byte $FF ; |XXXXXXXX| $9029
       .byte $FF ; |XXXXXXXX| $902A
       .byte $FF ; |XXXXXXXX| $902B
       .byte $FF ; |XXXXXXXX| $902C
       .byte $FF ; |XXXXXXXX| $902D
       .byte $FF ; |XXXXXXXX| $902E
       .byte $FF ; |XXXXXXXX| $902F
       .byte $FF ; |XXXXXXXX| $9030
       .byte $FF ; |XXXXXXXX| $9031
       .byte $FF ; |XXXXXXXX| $9032
       .byte $FF ; |XXXXXXXX| $9033
       .byte $FF ; |XXXXXXXX| $9034
       .byte $FF ; |XXXXXXXX| $9035
L9036: .byte $FF ; |XXXXXXXX| $9036
       .byte $FF ; |XXXXXXXX| $9037
       .byte $FF ; |XXXXXXXX| $9038
       .byte $FF ; |XXXXXXXX| $9039
       .byte $FF ; |XXXXXXXX| $903A
       .byte $FF ; |XXXXXXXX| $903B
       .byte $FF ; |XXXXXXXX| $903C
       .byte $FF ; |XXXXXXXX| $903D
       .byte $FF ; |XXXXXXXX| $903E
       .byte $FF ; |XXXXXXXX| $903F
       .byte $FF ; |XXXXXXXX| $9040
       .byte $FF ; |XXXXXXXX| $9041
       .byte $FF ; |XXXXXXXX| $9042
       .byte $FF ; |XXXXXXXX| $9043
       .byte $FF ; |XXXXXXXX| $9044
       .byte $FF ; |XXXXXXXX| $9045
       .byte $FF ; |XXXXXXXX| $9046
       .byte $FF ; |XXXXXXXX| $9047
L9048: .byte $FF ; |XXXXXXXX| $9048
       .byte $FF ; |XXXXXXXX| $9049
       .byte $FF ; |XXXXXXXX| $904A
       .byte $FF ; |XXXXXXXX| $904B
       .byte $FF ; |XXXXXXXX| $904C
       .byte $FF ; |XXXXXXXX| $904D
       .byte $FF ; |XXXXXXXX| $904E
       .byte $FF ; |XXXXXXXX| $904F
       .byte $FF ; |XXXXXXXX| $9050
       .byte $FF ; |XXXXXXXX| $9051
       .byte $FF ; |XXXXXXXX| $9052
       .byte $FF ; |XXXXXXXX| $9053
       .byte $FF ; |XXXXXXXX| $9054
       .byte $FF ; |XXXXXXXX| $9055
       .byte $FF ; |XXXXXXXX| $9056
       .byte $FF ; |XXXXXXXX| $9057
       .byte $FF ; |XXXXXXXX| $9058
       .byte $FF ; |XXXXXXXX| $9059
L905A: .byte $FF ; |XXXXXXXX| $905A
       .byte $FF ; |XXXXXXXX| $905B
       .byte $FF ; |XXXXXXXX| $905C
       .byte $FF ; |XXXXXXXX| $905D
       .byte $FF ; |XXXXXXXX| $905E
       .byte $FF ; |XXXXXXXX| $905F
       .byte $FF ; |XXXXXXXX| $9060
       .byte $FF ; |XXXXXXXX| $9061
       .byte $FF ; |XXXXXXXX| $9062
       .byte $FF ; |XXXXXXXX| $9063
       .byte $FF ; |XXXXXXXX| $9064
       .byte $FF ; |XXXXXXXX| $9065
       .byte $FF ; |XXXXXXXX| $9066
       .byte $FF ; |XXXXXXXX| $9067
       .byte $FF ; |XXXXXXXX| $9068
       .byte $FF ; |XXXXXXXX| $9069
       .byte $FF ; |XXXXXXXX| $906A
       .byte $FF ; |XXXXXXXX| $906B
L906C: .byte $FF ; |XXXXXXXX| $906C
       .byte $FF ; |XXXXXXXX| $906D
       .byte $FF ; |XXXXXXXX| $906E
       .byte $FF ; |XXXXXXXX| $906F
       .byte $FF ; |XXXXXXXX| $9070
       .byte $FF ; |XXXXXXXX| $9071
       .byte $FF ; |XXXXXXXX| $9072
       .byte $FF ; |XXXXXXXX| $9073
       .byte $FF ; |XXXXXXXX| $9074
       .byte $FF ; |XXXXXXXX| $9075
       .byte $FF ; |XXXXXXXX| $9076
       .byte $FF ; |XXXXXXXX| $9077
       .byte $FF ; |XXXXXXXX| $9078
       .byte $FF ; |XXXXXXXX| $9079
       .byte $FF ; |XXXXXXXX| $907A
       .byte $FF ; |XXXXXXXX| $907B
       .byte $FF ; |XXXXXXXX| $907C
       .byte $FF ; |XXXXXXXX| $907D
       .byte $FF ; |XXXXXXXX| $907E
L907F: .byte $FF ; |XXXXXXXX| $907F
L9080: .byte $FF ; |XXXXXXXX| $9080
       .byte $FF ; |XXXXXXXX| $9081
       .byte $FF ; |XXXXXXXX| $9082
       .byte $FF ; |XXXXXXXX| $9083
       .byte $FF ; |XXXXXXXX| $9084
       .byte $FF ; |XXXXXXXX| $9085
       .byte $FF ; |XXXXXXXX| $9086
       .byte $FF ; |XXXXXXXX| $9087
       .byte $FF ; |XXXXXXXX| $9088
       .byte $FF ; |XXXXXXXX| $9089
       .byte $FF ; |XXXXXXXX| $908A
       .byte $FF ; |XXXXXXXX| $908B
       .byte $FF ; |XXXXXXXX| $908C
       .byte $FF ; |XXXXXXXX| $908D
       .byte $FF ; |XXXXXXXX| $908E
       .byte $FF ; |XXXXXXXX| $908F
       .byte $FF ; |XXXXXXXX| $9090
       .byte $FF ; |XXXXXXXX| $9091
L9092: .byte $FF ; |XXXXXXXX| $9092
       .byte $FF ; |XXXXXXXX| $9093
       .byte $FF ; |XXXXXXXX| $9094
       .byte $FF ; |XXXXXXXX| $9095
       .byte $FF ; |XXXXXXXX| $9096
       .byte $FF ; |XXXXXXXX| $9097
       .byte $FF ; |XXXXXXXX| $9098
       .byte $FF ; |XXXXXXXX| $9099
       .byte $FF ; |XXXXXXXX| $909A
       .byte $FF ; |XXXXXXXX| $909B
       .byte $FF ; |XXXXXXXX| $909C
       .byte $FF ; |XXXXXXXX| $909D
       .byte $FF ; |XXXXXXXX| $909E
       .byte $FF ; |XXXXXXXX| $909F
       .byte $FF ; |XXXXXXXX| $90A0
       .byte $FF ; |XXXXXXXX| $90A1
       .byte $FF ; |XXXXXXXX| $90A2
       .byte $FF ; |XXXXXXXX| $90A3
L90A4: .byte $FF ; |XXXXXXXX| $90A4
       .byte $FF ; |XXXXXXXX| $90A5
       .byte $FF ; |XXXXXXXX| $90A6
       .byte $FF ; |XXXXXXXX| $90A7
       .byte $FF ; |XXXXXXXX| $90A8
       .byte $FF ; |XXXXXXXX| $90A9
       .byte $FF ; |XXXXXXXX| $90AA
       .byte $FF ; |XXXXXXXX| $90AB
       .byte $FF ; |XXXXXXXX| $90AC
       .byte $FF ; |XXXXXXXX| $90AD
       .byte $FF ; |XXXXXXXX| $90AE
       .byte $FF ; |XXXXXXXX| $90AF
       .byte $FF ; |XXXXXXXX| $90B0
       .byte $FF ; |XXXXXXXX| $90B1
       .byte $FF ; |XXXXXXXX| $90B2
       .byte $FF ; |XXXXXXXX| $90B3
       .byte $FF ; |XXXXXXXX| $90B4
       .byte $FF ; |XXXXXXXX| $90B5
L90B6: .byte $FF ; |XXXXXXXX| $90B6
       .byte $FF ; |XXXXXXXX| $90B7
       .byte $FF ; |XXXXXXXX| $90B8
       .byte $FF ; |XXXXXXXX| $90B9
       .byte $FF ; |XXXXXXXX| $90BA
       .byte $FF ; |XXXXXXXX| $90BB
       .byte $FF ; |XXXXXXXX| $90BC
       .byte $FF ; |XXXXXXXX| $90BD
       .byte $FF ; |XXXXXXXX| $90BE
       .byte $FF ; |XXXXXXXX| $90BF
       .byte $FF ; |XXXXXXXX| $90C0
       .byte $FF ; |XXXXXXXX| $90C1
       .byte $FF ; |XXXXXXXX| $90C2
       .byte $FF ; |XXXXXXXX| $90C3
       .byte $FF ; |XXXXXXXX| $90C4
       .byte $FF ; |XXXXXXXX| $90C5
       .byte $FF ; |XXXXXXXX| $90C6
       .byte $FF ; |XXXXXXXX| $90C7
L90C8: .byte $FF ; |XXXXXXXX| $90C8
       .byte $FF ; |XXXXXXXX| $90C9
       .byte $FF ; |XXXXXXXX| $90CA
       .byte $FF ; |XXXXXXXX| $90CB
       .byte $FF ; |XXXXXXXX| $90CC
       .byte $FF ; |XXXXXXXX| $90CD
       .byte $FF ; |XXXXXXXX| $90CE
       .byte $FF ; |XXXXXXXX| $90CF
       .byte $FF ; |XXXXXXXX| $90D0
       .byte $FF ; |XXXXXXXX| $90D1
       .byte $FF ; |XXXXXXXX| $90D2
       .byte $FF ; |XXXXXXXX| $90D3
       .byte $FF ; |XXXXXXXX| $90D4
       .byte $FF ; |XXXXXXXX| $90D5
       .byte $FF ; |XXXXXXXX| $90D6
       .byte $FF ; |XXXXXXXX| $90D7
       .byte $FF ; |XXXXXXXX| $90D8
       .byte $FF ; |XXXXXXXX| $90D9
L90DA: .byte $FF ; |XXXXXXXX| $90DA
       .byte $FF ; |XXXXXXXX| $90DB
       .byte $FF ; |XXXXXXXX| $90DC
       .byte $FF ; |XXXXXXXX| $90DD
       .byte $FF ; |XXXXXXXX| $90DE
       .byte $FF ; |XXXXXXXX| $90DF
       .byte $FF ; |XXXXXXXX| $90E0
       .byte $FF ; |XXXXXXXX| $90E1
       .byte $FF ; |XXXXXXXX| $90E2
       .byte $FF ; |XXXXXXXX| $90E3
       .byte $FF ; |XXXXXXXX| $90E4
       .byte $FF ; |XXXXXXXX| $90E5
       .byte $FF ; |XXXXXXXX| $90E6
       .byte $FF ; |XXXXXXXX| $90E7
       .byte $FF ; |XXXXXXXX| $90E8
       .byte $FF ; |XXXXXXXX| $90E9
       .byte $FF ; |XXXXXXXX| $90EA
       .byte $FF ; |XXXXXXXX| $90EB
L90EC: .byte $FF ; |XXXXXXXX| $90EC
       .byte $FF ; |XXXXXXXX| $90ED
       .byte $FF ; |XXXXXXXX| $90EE
       .byte $FF ; |XXXXXXXX| $90EF
       .byte $FF ; |XXXXXXXX| $90F0
       .byte $FF ; |XXXXXXXX| $90F1
       .byte $FF ; |XXXXXXXX| $90F2
       .byte $FF ; |XXXXXXXX| $90F3
       .byte $FF ; |XXXXXXXX| $90F4
       .byte $FF ; |XXXXXXXX| $90F5
       .byte $FF ; |XXXXXXXX| $90F6
       .byte $FF ; |XXXXXXXX| $90F7
       .byte $FF ; |XXXXXXXX| $90F8
       .byte $FF ; |XXXXXXXX| $90F9
       .byte $FF ; |XXXXXXXX| $90FA
       .byte $FF ; |XXXXXXXX| $90FB
       .byte $FF ; |XXXXXXXX| $90FC
       .byte $FF ; |XXXXXXXX| $90FD
L90FE: .byte $FF ; |XXXXXXXX| $90FE
L90FF: .byte $FF ; |XXXXXXXX| $90FF

STRT1: STA    BANK4                   ;4
L9103: LDX    #$33                    ;2
       STX    TIM64T                  ;4
       LDA    #$00                    ;2
       STA    VDELP0                  ;3
       STA    VDELP1                  ;3
       STA    NUSIZ0                  ;3
       STA    NUSIZ1                  ;3
       LDX    #$CF                    ;2
       TXS                            ;2
       LDA    $FC                     ;3
       BNE    L912E                   ;2
       LDX    $F0FF                   ;4
       BMI    L912E                   ;2
       INX                            ;2
       STX    $F07F                   ;4
       BPL    L912E                   ;2
       LDA    $F8                     ;3
       ORA    #$C0                    ;2
       STA    $F8                     ;3
       LDA    #$00                    ;2
       STA    $F5                     ;3
L912E: LDA    $E3                     ;3
       CMP    #$E0                    ;2
       BCS    L9144                   ;2
       AND    #$08                    ;2
       BEQ    L9144                   ;2
       LDA    $DC                     ;3
       AND    #$01                    ;2
       BNE    L9142                   ;2
       DEC    $E9                     ;5
       BCC    L9144                   ;2
L9142: DEC    $EF                     ;5
L9144: LDA    $F7                     ;3
       BEQ    L9195                   ;2
       LDX    #$09                    ;2
       ASL    $F7                     ;5
       BCC    L915A                   ;2
       LDY    $F6                     ;3
       LDA    L9FCB,Y                 ;4
       SEC                            ;2
       SBC    #$12                    ;2
       TAY                            ;2
       JSR    L9F43                   ;6
L915A: ASL    $F7                     ;5
       BCC    L916A                   ;2
       LDY    $F6                     ;3
       LDA    L9FC4,Y                 ;4
       SEC                            ;2
       SBC    #$12                    ;2
       TAY                            ;2
       JSR    L9F43                   ;6
L916A: LDY    #$01                    ;2
       LDA    $D0                     ;3
       CMP    #$28                    ;2
       BCC    L9174                   ;2
       LDY    #$10                    ;2
L9174: LDX    #$10                    ;2
       ASL    $F7                     ;5
       ASL    $F7                     ;5
       BCC    L917F                   ;2
       JSR    L9F43                   ;6
L917F: LDX    #$02                    ;2
       ASL    $F7                     ;5
       BCC    L9195                   ;2
       LDA    #$40                    ;2
       ORA    $F0A4,Y                 ;4
       STA    $F024,Y                 ;5
       LDA    $F0DA,Y                 ;4
       ORA    #$40                    ;2
       STA    $F05A,Y                 ;5
L9195: LDA    $F3                     ;3
       BNE    L91D4                   ;2
       JSR    L9B8C                   ;6
       LDA    $FC                     ;3
       AND    #$0F                    ;2
       ORA    $D2                     ;3
       BNE    L91D1                   ;2
       LDY    $D3                     ;3
       BPL    L91B2                   ;2
       LDA    $D7                     ;3
       AND    #$E3                    ;2
       ORA    #$04                    ;2
       STA    $D7                     ;3
       BNE    L91D1                   ;2
L91B2: INY                            ;2
       STY    $D3                     ;3
       CPY    #$16                    ;2
       BEQ    L91BD                   ;2
       CPY    #$4B                    ;2
       BNE    L91D1                   ;2
L91BD: LDY    #$03                    ;2
L91BF: LDA.wy $DD,Y                   ;4
       AND    #$C0                    ;2
       BNE    L91CE                   ;2
       LDA.wy $D7,Y                   ;4
       ORA    #$20                    ;2
       STA.wy $D7,Y                   ;5
L91CE: DEY                            ;2
       BPL    L91BF                   ;2
L91D1: JMP    L91E6                   ;3
L91D4: LDX    $D5                     ;3
       BEQ    L91E4                   ;2
       DEC    $D5                     ;5
       CMP    #$04                    ;2
       BNE    L91E1                   ;2
       JSR    L9CEC                   ;6
L91E1: JMP    L921B                   ;3
L91E4: STX    $F3                     ;3
L91E6: LDA    $FC                     ;3
       LSR                            ;2
       BCC    L91F1                   ;2
       LDY    $D1                     ;3
       BMI    L91F1                   ;2
       DEC    $D1                     ;5
L91F1: JSR    L9DD5                   ;6
       LDA    $FC                     ;3
       AND    #$0F                    ;2
       STA    $BD                     ;3
       LDY    #$00                    ;2
       JSR    L9238                   ;6
       LDA    $F3                     ;3
       BNE    L921B                   ;2
       LDA    INTIM                   ;4
       CMP    #$11                    ;2
       BCS    L920E                   ;2
       NOP                            ;2
       JMP    L921B                   ;3
L920E: LDA    $FC                     ;3
       AND    #$0F                    ;2
       ORA    #$10                    ;2
       STA    $BD                     ;3
       LDY    #$01                    ;2
       JSR    L9238                   ;6
L921B: NOP                            ;2
L921C: LDX    INTIM                   ;4
       BMI    L9226                   ;2
       BNE    L921C                   ;2
       JMP    L9FE1                   ;3
L9226: NOP                            ;2
       JMP    L9FE1                   ;3





L922A: .byte $A0 ; |X X     | $922A
       .byte $6E ; | XX XXX | $922B
       .byte $4F ; | X  XXXX| $922C
       .byte $3C ; |  XXXX  | $922D
       .byte $27 ; |  X  XXX| $922E
       .byte $17 ; |   X XXX| $922F
       .byte $0F ; |    XXXX| $9230
;Table: which object to move?
L9231: .byte $05 ; |     X X| $9231 fruit
       .byte $04 ; |     X  | $9232 jr.
       .byte $00 ; |        | $9233 monster0
       .byte $01 ; |       X| $9234 monster1
       .byte $02 ; |      X | $9235 monster2
       .byte $03 ; |      XX| $9236 monster3
;       .byte $FF ; |XXXXXXXX| $9237 done
       .byte $04 ; |     X  | $9232 jr. (double speed)
;29
L9238: STY    $F0                     ;3 STY $zp opcode = $84 (last byte of above table = neg.)
       LDX    L9231,Y                 ;4
L923D:
       LDA    INTIM                   ;4
       CMP    #$11                    ;2 <-here
       BCS    L9248                   ;2
       NOP                            ;2
       JMP    L9AF4                   ;3



L9248: CPX    #$04                    ;2
       BNE    L92A8                   ;2
       LDA    $D5                     ;3
       BEQ    L92A8                   ;2
       DEC    $D5                     ;5
       JMP    L9AE3                   ;3


L9255: .byte $00 ; |        | $9255
       .byte $80 ; |X       | $9256
       .byte $80 ; |X       | $9257
       .byte $80 ; |X       | $9258
       .byte $C1 ; |XX     X| $9259
       .byte $80 ; |X       | $925A
       .byte $80 ; |X       | $925B
       .byte $80 ; |X       | $925C
       .byte $01 ; |       X| $925D
       .byte $80 ; |X       | $925E
       .byte $80 ; |X       | $925F
       .byte $80 ; |X       | $9260
       .byte $C3 ; |XX    XX| $9261
       .byte $80 ; |X       | $9262
       .byte $80 ; |X       | $9263
       .byte $80 ; |X       | $9264
       .byte $02 ; |      X | $9265
       .byte $80 ; |X       | $9266
       .byte $80 ; |X       | $9267
       .byte $80 ; |X       | $9268
       .byte $C5 ; |XX   X X| $9269
       .byte $80 ; |X       | $926A
       .byte $80 ; |X       | $926B
       .byte $80 ; |X       | $926C
       .byte $03 ; |      XX| $926D
       .byte $80 ; |X       | $926E
       .byte $80 ; |X       | $926F
       .byte $80 ; |X       | $9270
       .byte $C7 ; |XX   XXX| $9271
       .byte $80 ; |X       | $9272
       .byte $80 ; |X       | $9273
       .byte $80 ; |X       | $9274
       .byte $04 ; |     X  | $9275
       .byte $80 ; |X       | $9276
       .byte $80 ; |X       | $9277
       .byte $80 ; |X       | $9278
       .byte $80 ; |X       | $9279
       .byte $05 ; |     X X| $927A
       .byte $80 ; |X       | $927B
       .byte $80 ; |X       | $927C
       .byte $80 ; |X       | $927D
       .byte $80 ; |X       | $927E
       .byte $06 ; |     XX | $927F
       .byte $80 ; |X       | $9280
       .byte $80 ; |X       | $9281
       .byte $80 ; |X       | $9282
       .byte $CB ; |XX  X XX| $9283
       .byte $80 ; |X       | $9284
       .byte $80 ; |X       | $9285
       .byte $80 ; |X       | $9286
       .byte $07 ; |     XXX| $9287
       .byte $80 ; |X       | $9288
       .byte $80 ; |X       | $9289
       .byte $80 ; |X       | $928A
       .byte $CD ; |XX  XX X| $928B
       .byte $80 ; |X       | $928C
       .byte $80 ; |X       | $928D
       .byte $80 ; |X       | $928E
       .byte $08 ; |    X   | $928F
       .byte $80 ; |X       | $9290
       .byte $80 ; |X       | $9291
       .byte $80 ; |X       | $9292
       .byte $CF ; |XX  XXXX| $9293
       .byte $80 ; |X       | $9294
       .byte $80 ; |X       | $9295
       .byte $80 ; |X       | $9296
       .byte $09 ; |    X  X| $9297
       .byte $80 ; |X       | $9298
       .byte $80 ; |X       | $9299
       .byte $80 ; |X       | $929A
       .byte $D1 ; |XX X   X| $929B
       .byte $80 ; |X       | $929C
       .byte $80 ; |X       | $929D
       .byte $80 ; |X       | $929E
       .byte $0A ; |    X X | $929F
       .byte $80 ; |X       | $92A0
       .byte $80 ; |X       | $92A1
       .byte $80 ; |X       | $92A2
       .byte $D3 ; |XX X  XX| $92A3
       .byte $80 ; |X       | $92A4
       .byte $80 ; |X       | $92A5
       .byte $80 ; |X       | $92A6
       .byte $0B ; |    X XX| $92A7
L92A8: LDA    $E4,X                   ;4
       LSR                            ;2
       BCS    L92C9                   ;2
       TAY                            ;2
       LDA    L9255,Y                 ;4
       BMI    L92C9                   ;2
       STA    $BE                     ;3
       LDA    $D7,X                   ;4
       ROL                            ;2
       LDA    $EA,X                   ;4
       ROR                            ;2
       BCS    L92C9                   ;2
       LSR                            ;2
       BCS    L92C9                   ;2
       TAY                            ;2
       LDA    L9F5A,Y                 ;4
       BMI    L92C9                   ;2
       JMP    L9FE7                   ;3
L92C9: LDA    $D7,X                   ;4
       AND    #$03                    ;2
       TAY                            ;2
       LDA    L9F56,Y                 ;4
       STA    $C1                     ;3
       LDA    L9CE6,X                 ;4
       EOR    #$FF                    ;2
       AND    $F5                     ;3
       STA    $F5                     ;3
       CPX    #$04                    ;2
       BEQ    L92E3                   ;2
       JMP    L9A2D                   ;3
L92E3: LDA    $E8                     ;3
       LSR                            ;2
       BCS    L9323                   ;2
       TAY                            ;2
       LDA    L9255,Y                 ;4
       BMI    L9323                   ;2
       LDA    $DB                     ;3
       AND    #$03                    ;2
       BNE    L92FD                   ;2
       LDA    $EE                     ;3
       SEC                            ;2
       SBC    #$06                    ;2
       BCC    L9309                   ;2
       BCS    L9304                   ;2
L92FD: LDA    $EE                     ;3
       CLC                            ;2
       ADC    #$06                    ;2
       BCS    L9309                   ;2
L9304: PHA                            ;3
       LDA    $DB                     ;3
       ROL                            ;2
       PLA                            ;4
L9309: ROR                            ;2
       BCS    L9320                   ;2
       LSR                            ;2
       BCS    L9320                   ;2
       TAY                            ;2
       LDA    L9F5A,Y                 ;4
       BMI    L9320                   ;2
       STA    $B2                     ;3
       LDA    $E8                     ;3
       LSR                            ;2
       JSR    L9530                   ;6
       JMP    L934C                   ;3
L9320: JMP    L93B8                   ;3
L9323: LDA    $DB                     ;3
       ROL                            ;2
       LDA    $EE                     ;3
       ROR                            ;2
       LSR                            ;2
       TAY                            ;2
       LDA    L9F5A,Y                 ;4
       STA    $B2                     ;3
       LDA    $DB                     ;3
       AND    #$02                    ;2
       LSR                            ;2
       TAX                            ;2
       LDA    $E8                     ;3
       CMP    #$05                    ;2
       BCC    L93AC                   ;2
       CMP    #$92                    ;2
       BCS    L93AC                   ;2
       CLC                            ;2
       ADC    L952E,X                 ;4
       LSR                            ;2
       BCS    L93AC                   ;2
       JSR    L9530                   ;6
       BCS    L93AC                   ;2
L934C: LDA    #$F0                    ;2
       STA    $B3                     ;3
       LDA    L9550,X                 ;4
       CLC                            ;2
       ADC    $B2                     ;3
       STA    $B2                     ;3
       LDY    #$80                    ;2
       LDA    ($B2),Y                 ;5
       AND    L9563,X                 ;4
       BEQ    L93AC                   ;2
       LDA    #$03                    ;2
       STA    $D5                     ;3
       LDA    #$00                    ;2
       STA    $BD                     ;3
       LDY    #$B6                    ;2
       LDA    ($B2),Y                 ;5
       AND    L9563,X                 ;4
       BEQ    L9386                   ;2
       LDA    ($B2),Y                 ;5
       AND    L9576,X                 ;4
       LDY    #$36                    ;2
       STA    ($B2),Y                 ;6
       JSR    L946E                   ;6
       LDA    #$06                    ;2
       STA    $D5                     ;3
       LDA    #$01                    ;2
       STA    $BD                     ;3
L9386: LDY    #$80                    ;2
       LDA    ($B2),Y                 ;5
       AND    L9576,X                 ;4
       LDY    #$00                    ;2
       STA    ($B2),Y                 ;6
L9391: ASL    $E1                     ;5
       SEC                            ;2
       ROR    $E1                     ;5
       INC    $F4                     ;5
       BNE    L93A0                   ;2
       LDA    $FF                     ;3
       ORA    #$08                    ;2
       STA    $FF                     ;3
L93A0: LDA    $BD                     ;3
       JSR    L9E07                   ;6
       JSR    L94D3                   ;6
       LDA    #$20                    ;2
       STA    $D1                     ;3
L93AC: LDX    #$04                    ;2
       LDA    $F8                     ;3
       BEQ    L93B5                   ;2
       JMP    L9A2D                   ;3
L93B5: JMP    L959D                   ;3
L93B8: LDA    $E8                     ;3
       CMP    #$30                    ;2
       BCC    L93C2                   ;2
       CMP    #$74                    ;2
       BCC    L93AC                   ;2
L93C2: LDA    $DB                     ;3
       AND    #$03                    ;2
       BNE    L93D1                   ;2
       LDA    $EE                     ;3
       CLC                            ;2
       ADC    #$04                    ;2
       BCS    L93DD                   ;2
       BCC    L93D8                   ;2
L93D1: LDA    $EE                     ;3
       CLC                            ;2
       ADC    #$10                    ;2
       BCS    L93DD                   ;2
L93D8: PHA                            ;3
       LDA    $DB                     ;3
       ROL                            ;2
       PLA                            ;4
L93DD: ROR                            ;2
       BCS    L93AC                   ;2
       LSR                            ;2
       BCS    L93AC                   ;2
       TAX                            ;2
       LDY    L9F5A,X                 ;4
       BMI    L93AC                   ;2
       LDA    $E8                     ;3
       LSR                            ;2
       TAX                            ;2
       LDA    L9255,X                 ;4
       TAX                            ;2
       LDA    L9517,X                 ;4
       BMI    L93AC                   ;2
       TAX                            ;2
       LDA    $F0EC,Y                 ;4
       AND    L9522,X                 ;4
       BEQ    L93AC                   ;2
       LDA    #$03                    ;2
       STA    $D5                     ;3
       LDA    #$00                    ;2
       STA    $BD                     ;3
       LDA    $F0EC,Y                 ;4
       AND    L9528,X                 ;4
       STA    $F06C,Y                 ;5
       TXA                            ;2
       CPX    #$03                    ;2
       BCS    L9440                   ;2
       ASL                            ;2
       ASL                            ;2
       ASL                            ;2
       STA    $BE                     ;3
       LDA    $F080,Y                 ;4
       AND    #$07                    ;2
       CLC                            ;2
       ADC    $BE                     ;3
       STY    $BE                     ;3
       TAY                            ;2
       LDA    L94FD,Y                 ;4
       BMI    L942D                   ;2
L942A: JMP    L9391                   ;3
L942D: LDY    $BE                     ;3
       AND    #$0F                    ;2
       STA    $BE                     ;3
       LDA    $F080,Y                 ;4
       AND    #$F0                    ;2
       ORA    $BE                     ;3
       STA    $F000,Y                 ;5
       JMP    L9465                   ;3
L9440: LDA    L9512,X                 ;4
       STA    $BE                     ;3
       LDA    $F0B6,Y                 ;4
       AND    #$07                    ;2
       CLC                            ;2
       ADC    $BE                     ;3
       STY    $BE                     ;3
       TAY                            ;2
       LDA    L94FD,Y                 ;4
       BPL    L942A                   ;2
       LDY    $BE                     ;3
       AND    #$0F                    ;2
       STA    $BE                     ;3
       LDA    $F0B6,Y                 ;4
       AND    #$F0                    ;2
       ORA    $BE                     ;3
       STA    $F036,Y                 ;5
L9465: LDA    #$06                    ;2
       STA    $D5                     ;3
       INC    $BD                     ;5
       JMP    L9391                   ;3
L946E: CPX    #$02                    ;2
       BEQ    L947C                   ;2
       CPX    #$10                    ;2
       BEQ    L947C                   ;2
       CPX    #$09                    ;2
       BNE    L94D2                   ;2
       BEQ    L948E                   ;2
L947C: LDA    $B2                     ;3
       CMP    #$25                    ;2
       BEQ    L948E                   ;2
       CMP    #$13                    ;2
       BEQ    L948E                   ;2
       CMP    #$34                    ;2
       BEQ    L948E                   ;2
       CMP    #$22                    ;2
       BNE    L94D2                   ;2
L948E: STY    $B6                     ;3
       LDA    #$6A                    ;2
       STA    $F2                     ;3
       LDY    $F6                     ;3
       BIT    $FF                     ;3
       BPL    L949C                   ;2
       LDY    #$06                    ;2
L949C: LDA    L922A,Y                 ;4
       STA    $D2                     ;3
       LDA    $F5                     ;3
       AND    #$FC                    ;2
       STA    $F5                     ;3
       LDY    #$03                    ;2
L94A9: LDA.wy $DD,Y                   ;4
       BMI    L94C7                   ;2
       LDA.wy $D7,Y                   ;4
       AND    #$E3                    ;2
       ORA    #$54                    ;2
       STA.wy $D7,Y                   ;5
       LDA.wy $DD,Y                   ;4
       AND    #$40                    ;2
       BNE    L94C7                   ;2
       LDA.wy $D7,Y                   ;4
       ORA    #$20                    ;2
       STA.wy $D7,Y                   ;5
L94C7: DEY                            ;2
       BPL    L94A9                   ;2
       LDY    $B6                     ;3
       LDA    $DB                     ;3
       AND    #$E3                    ;2
       STA    $DB                     ;3
L94D2: RTS                            ;6

L94D3: LDA    $FF                     ;3
       AND    #$08                    ;2
       BEQ    L94D2                   ;2
       LDX    $F6                     ;3
       LDA    $F4                     ;3
       CMP    L94F6,X                 ;4
       BNE    L94D2                   ;2
L94E2: LDA    #$06                    ;2
       STA    $F3                     ;3
       LDA    #$9F                    ;2
       STA    $D5                     ;3
       LDA    #$FF                    ;2
       STA    $F1                     ;3
       STA    $F2                     ;3
       LDX    #$CF                    ;2
       TXS                            ;2
       JMP    L921B                   ;3
L94F6: .byte $52 ; | X X  X | $94F6
       .byte $42 ; | X    X | $94F7
       .byte $42 ; | X    X | $94F8
       .byte $4E ; | X  XXX | $94F9
       .byte $68 ; | XX X   | $94FA
       .byte $50 ; | X X    | $94FB
       .byte $52 ; | X X  X | $94FC
L94FD: .byte $02 ; |      X | $94FD
       .byte $03 ; |      XX| $94FE
       .byte $80 ; |X       | $94FF
       .byte $81 ; |X      X| $9500
       .byte $06 ; |     XX | $9501
       .byte $07 ; |     XXX| $9502
       .byte $84 ; |X    X  | $9503
       .byte $85 ; |X    X X| $9504
       .byte $04 ; |     X  | $9505
       .byte $05 ; |     X X| $9506
       .byte $06 ; |     XX | $9507
       .byte $07 ; |     XXX| $9508
       .byte $80 ; |X       | $9509
       .byte $81 ; |X      X| $950A
       .byte $82 ; |X     X | $950B
       .byte $83 ; |X     XX| $950C
       .byte $01 ; |       X| $950D
       .byte $80 ; |X       | $950E
       .byte $03 ; |      XX| $950F
       .byte $82 ; |X     X | $9510
       .byte $05 ; |     X X| $9511
L9512: .byte $84 ; |X    X  | $9512
       .byte $07 ; |     XXX| $9513
       .byte $86 ; |X    XX | $9514
       .byte $10 ; |   X    | $9515
       .byte $08 ; |    X   | $9516
L9517: .byte $00 ; |        | $9517
       .byte $01 ; |       X| $9518
       .byte $02 ; |      X | $9519
       .byte $80 ; |X       | $951A
       .byte $80 ; |X       | $951B
       .byte $80 ; |X       | $951C
       .byte $80 ; |X       | $951D
       .byte $80 ; |X       | $951E
       .byte $03 ; |      XX| $951F
       .byte $04 ; |     X  | $9520
       .byte $05 ; |     X X| $9521
L9522: .byte $20 ; |  X     | $9522
       .byte $40 ; | X      | $9523
       .byte $04 ; |     X  | $9524
       .byte $01 ; |       X| $9525
       .byte $10 ; |   X    | $9526
       .byte $08 ; |    X   | $9527
L9528: .byte $DF ; |XX XXXXX| $9528
       .byte $BF ; |X XXXXXX| $9529
       .byte $FB ; |XXXXX XX| $952A
       .byte $FE ; |XXXXXXX | $952B
       .byte $EF ; |XXX XXXX| $952C
       .byte $F7 ; |XXXX XXX| $952D
L952E: .byte $03 ; |      XX| $952E
       .byte $FB ; |XXXXX XX| $952F
L9530: CLC                            ;2
       TAX                            ;2
       LDA    L9255,X                 ;4
       BMI    L953D                   ;2
       TAX                            ;2
       LDA    L9544,X                 ;4
       TAX                            ;2
       RTS                            ;6

L953D: AND    #$1F                    ;2
       TAX                            ;2
       BNE    L9543                   ;2
       SEC                            ;2
L9543: RTS                            ;6

L9544: .byte $00 ; |        | $9544
       .byte $02 ; |      X | $9545
       .byte $04 ; |     X  | $9546
       .byte $06 ; |     XX | $9547
       .byte $08 ; |    X   | $9548
       .byte $09 ; |    X  X| $9549
       .byte $0A ; |    X X | $954A
       .byte $0C ; |    XX  | $954B
       .byte $0E ; |    XXX | $954C
       .byte $10 ; |   X    | $954D
       .byte $12 ; |   X  X | $954E
       .byte $14 ; |   X X  | $954F
L9550: .byte $00 ; |        | $9550
       .byte $00 ; |        | $9551
       .byte $24 ; |  X  X  | $9552
       .byte $24 ; |  X  X  | $9553
       .byte $24 ; |  X  X  | $9554
       .byte $24 ; |  X  X  | $9555
       .byte $24 ; |  X  X  | $9556
       .byte $24 ; |  X  X  | $9557
       .byte $24 ; |  X  X  | $9558
       .byte $12 ; |   X  X | $9559
       .byte $12 ; |   X  X | $955A
       .byte $12 ; |   X  X | $955B
       .byte $12 ; |   X  X | $955C
       .byte $12 ; |   X  X | $955D
       .byte $12 ; |   X  X | $955E
       .byte $12 ; |   X  X | $955F
       .byte $12 ; |   X  X | $9560
       .byte $00 ; |        | $9561
       .byte $00 ; |        | $9562
L9563: .byte $20 ; |  X     | $9563
       .byte $80 ; |X       | $9564
       .byte $40 ; | X      | $9565
       .byte $10 ; |   X    | $9566
       .byte $04 ; |     X  | $9567
       .byte $01 ; |       X| $9568
       .byte $02 ; |      X | $9569
       .byte $08 ; |    X   | $956A
       .byte $20 ; |  X     | $956B
       .byte $80 ; |X       | $956C
       .byte $20 ; |  X     | $956D
       .byte $08 ; |    X   | $956E
       .byte $02 ; |      X | $956F
       .byte $01 ; |       X| $9570
       .byte $04 ; |     X  | $9571
       .byte $10 ; |   X    | $9572
       .byte $40 ; | X      | $9573
       .byte $40 ; | X      | $9574
       .byte $10 ; |   X    | $9575
L9576: .byte $DF ; |XX XXXXX| $9576
       .byte $7F ; | XXXXXXX| $9577
       .byte $BF ; |X XXXXXX| $9578
       .byte $EF ; |XXX XXXX| $9579
       .byte $FB ; |XXXXX XX| $957A
       .byte $FE ; |XXXXXXX | $957B
       .byte $FD ; |XXXXXX X| $957C
       .byte $F7 ; |XXXX XXX| $957D
       .byte $DF ; |XX XXXXX| $957E
       .byte $7F ; | XXXXXXX| $957F
       .byte $DF ; |XX XXXXX| $9580
       .byte $F7 ; |XXXX XXX| $9581
       .byte $FD ; |XXXXXX X| $9582
       .byte $FE ; |XXXXXXX | $9583
       .byte $FB ; |XXXXX XX| $9584
       .byte $EF ; |XXX XXXX| $9585
       .byte $BF ; |X XXXXXX| $9586
       .byte $BF ; |X XXXXXX| $9587
       .byte $EF ; |XXX XXXX| $9588
L9589: STA    $C1                     ;3
       BIT    $F8                     ;3
       BMI    L9593                   ;2
       CPX    #$04                    ;2
       BEQ    L959D                   ;2
L9593: LDA    L9CE6,X                 ;4
       BIT    $F5                     ;3
       BEQ    L959D                   ;2
       JMP    L9A2D                   ;3
L959D: LDA    L9CE6,X                 ;4
       ORA    $F5                     ;3
       STA    $F5                     ;3
       CPX    #$04                    ;2
       BCC    L95AB                   ;2
       JMP    L96B1                   ;3
L95AB: LDA    $D7,X                   ;4
       AND    #$20                    ;2
       BEQ    L95BC                   ;2
L95B1: LDA    $D7,X                   ;4
       EOR    #$02                    ;2
       AND    #$DF                    ;2
       STA    $D7,X                   ;4
       JMP    L9A2D                   ;3
L95BC: LDA    $DD,X                   ;4
       ASL                            ;2
       BCS    L960E                   ;2
       ASL                            ;2
       BCS    L95D8                   ;2
       LDA    $F0FE                   ;4
       AND    L9CE6,X                 ;4
       BEQ    L95CF                   ;2
       JMP    L989D                   ;3
L95CF: LDA    $D7,X                   ;4
       AND    #$40                    ;2
       BNE    L95DB                   ;2
       JMP    L96B1                   ;3
L95D8: JMP    L965D                   ;3
L95DB: JSR    L95EE                   ;6
       LDA    L95FE,Y                 ;4
       STA    $C3                     ;3
       JSR    L95EE                   ;6
       LDA    L9606,Y                 ;4
       STA    $C2                     ;3
       JMP    L9941                   ;3

;32
L95EE: LDA    $FC                     ;3
       ADC    $FD                     ;3
       ADC    $FE                     ;3
       LDY    $FD                     ;3
       STY    $FE                     ;3
       STA    $FD                     ;3
       AND    #$07                    ;2
       TAY                            ;2
       RTS                            ;6
L95FE: .byte $00 ; |        | $95FE
       .byte $08 ; |    X   | $95FF
       .byte $0C ; |    XX  | $9600
       .byte $10 ; |   X    | $9601
       .byte $14 ; |   X X  | $9602
       .byte $18 ; |   XX   | $9603
       .byte $1C ; |   XXX  | $9604
       .byte $24 ; |  X  X  | $9605
L9606: .byte $00 ; |        | $9606
       .byte $05 ; |     X X| $9607
       .byte $14 ; |   X X  | $9608
       .byte $1E ; |   XXXX | $9609
       .byte $28 ; |  X X   | $960A
       .byte $32 ; |  XX  X | $960B
       .byte $3C ; |  XXXX  | $960C
       .byte $55 ; | X X X X| $960D


L960E: LDA    $E4,X                   ;4
       CMP    #$4A                    ;2
       BNE    L9652                   ;2
       LDA    $EA,X                   ;4
       CMP    #$8C                    ;2
       BEQ    L9645                   ;2
       CMP    #$A0                    ;2
       BNE    L9652                   ;2
       LDA    $DD,X                   ;4
       AND    #$7F                    ;2
       ORA    #$40                    ;2
       STA    $DD,X                   ;4
       LDA    $D7,X                   ;4
       AND    #$A0                    ;2
       ORA    #$13                    ;2
       STA    $D7,X                   ;4
       LDA    $DD                     ;3
       ORA    $DE                     ;3
       ORA    $DF                     ;3
       ORA    $E0                     ;3
       AND    #$80                    ;2
       BNE    L965D                   ;2
       LDA    $D2                     ;3
       BEQ    L965D                   ;2
       LDA    #$6A                    ;2
       STA    $F2                     ;3
       JMP    L965D                   ;3
L9645: LDA    $D7,X                   ;4
       AND    #$FC                    ;2
       ORA    #$02                    ;2
       STA    $D7,X                   ;4
       INC    $EA,X                   ;6
       JMP    L9AE3                   ;3
L9652: LDA    #$14                    ;2
       STA    $C3                     ;3
       LDA    #$23                    ;2
       STA    $C2                     ;3
       JMP    L9941                   ;3
L965D: LDA    $EA,X                   ;4
       CMP    #$8C                    ;2
       BNE    L966C                   ;2
       LDA    $DD,X                   ;4
       AND    #$BF                    ;2
       STA    $DD,X                   ;4
       JMP    L96B1                   ;3
L966C: LDA    $E4,X                   ;4
       CMP    #$4A                    ;2
       BNE    L9682                   ;2
       LDA    $D1                     ;3
       BMI    L9685                   ;2
       LDA    $F4                     ;3
       SEC                            ;2
       SBC    $D4                     ;3
       CMP    #$05                    ;2
       BCS    L9685                   ;2
       JMP    L9A2D                   ;3
L9682: JMP    L95B1                   ;3
L9685: TXA                            ;2
       TAY                            ;2
       LDA    #$00                    ;2
L9689: DEY                            ;2
       BMI    L9692                   ;2
       ORA.wy $DD,Y                   ;4
       JMP    L9689                   ;3
L9692: AND    #$40                    ;2
       BEQ    L9699                   ;2
       JMP    L9A2D                   ;3
L9699: LDA    #$20                    ;2
       STA    $D1                     ;3
       LDA    $F4                     ;3
       STA    $D4                     ;3
       LDA    $EA,X                   ;4
       SEC                            ;2
       SBC    #$01                    ;2
       STA    $EA,X                   ;4
       LDA    $D7,X                   ;4
       AND    #$FC                    ;2
       STA    $D7,X                   ;4
       JMP    L9AE3                   ;3
L96B1: CPX    #$04                    ;2
       BPL    L96BE                   ;2
       LDA    $D3                     ;3
       CMP    #$1A                    ;2
       BCS    L96BE                   ;2
       JMP    L95DB                   ;3
L96BE: LDA    L96CB,X                 ;4
       STA    $B4                     ;3
       LDA    L96D1,X                 ;4
       STA    $B5                     ;3
       JMP.ind ($B4)                  ;5

L96CB: .byte <L989D ; |X  XXX X| $96CB
       .byte <L98AF ; |X X XXXX| $96CC
       .byte <L98E2 ; |XXX   X | $96CD
       .byte <L9867 ; | XX  XXX| $96CE
       .byte <L97AC ; |X X XX  | $96CF
       .byte <L96D7 ; |XX X XXX| $96D0
L96D1: .byte >L989D ; |X  XX   | $96D1
       .byte >L98AF ; |X  XX   | $96D2
       .byte >L98E2 ; |X  XX   | $96D3
       .byte >L9867 ; |X  XX   | $96D4
       .byte >L97AC ; |X  X XXX| $96D5
       .byte >L96D7 ; |X  X XX | $96D6

L96D7:
       BIT    $E3                     ;3
       BMI    L96DE                   ;2
       JMP    L9AE3                   ;3
L96DE: LDA    $E3                     ;3
       AND    #$60                    ;2
       BEQ    L96EB                   ;2
       CMP    #$20                    ;2
       BEQ    L971A                   ;2
       JMP    L973F                   ;3
L96EB: LDA    $E3                     ;3
       AND    #$03                    ;2
       TAY                            ;2
       LDA    $E9                     ;3
       LSR                            ;2
       LSR                            ;2
       SEC                            ;2
       SBC    L9DCD,Y                 ;4
       BPL    L96FE                   ;2
       EOR    #$FF                    ;2
       ADC    #$01                    ;2
L96FE: CMP    #$08                    ;2
       BCS    L9757                   ;2
       LDA    $DC                     ;3
       ROL                            ;2
       LDA    $EF                     ;3
       ROR                            ;2
       LSR                            ;2
       SEC                            ;2
       SBC    L9DD1,Y                 ;4
       BPL    L9713                   ;2
       EOR    #$FF                    ;2
       ADC    #$01                    ;2
L9713: CMP    #$08                    ;2
       BCS    L9757                   ;2
       JMP    L9762                   ;3
L971A: JSR    L977E                   ;6
       BCS    L9757                   ;2
       LDA    $E3                     ;3
       AND    #$60                    ;2
       BEQ    L9762                   ;2
       LDA    $E2                     ;3
       AND    #$40                    ;2
       BNE    L9750                   ;2
L972B: LDA    $E3                     ;3
       AND    #$9C                    ;2
       ORA    #$40                    ;2
       STA    $E3                     ;3
       LDA    $FD                     ;3
       AND    #$03                    ;2
       TAY                            ;2
       ORA    $E3                     ;3
       STA    $E3                     ;3
       JMP    L9941                   ;3
L973F: LDA    $E9                     ;3
       CMP    #$4A                    ;2
       BEQ    L974A                   ;2
       JSR    L977E                   ;6
       BCS    L9757                   ;2
L974A: LDA    $E2                     ;3
       AND    #$40                    ;2
       BEQ    L972B                   ;2
L9750: LDA    #$E0                    ;2
       STA    $E3                     ;3
       JMP    L9AE3                   ;3
L9757: LDA    $E3                     ;3
       AND    #$03                    ;2
       TAY                            ;2
       JSR    L9796                   ;6
       JMP    L9941                   ;3
L9762: LDA    $FD                     ;3
       AND    #$03                    ;2
       CLC                            ;2
       ADC    $E3                     ;3
       AND    #$03                    ;2
       STA    $B4                     ;3
       TAY                            ;2
       LDA    $E3                     ;3
       AND    #$9C                    ;2
       ORA    $B4                     ;3
       ORA    #$20                    ;2
       STA    $E3                     ;3
       JSR    L9796                   ;6
       JMP    L9941                   ;3
L977E: LDA    $E9                     ;3
       CMP    #$10                    ;2
       BEQ    L9788                   ;2
       CMP    #$84                    ;2
       BNE    L9794                   ;2
L9788: LDA    $EF                     ;3
       CMP    #$14                    ;2
       BEQ    L9792                   ;2
       CMP    #$40                    ;2
       BNE    L9794                   ;2
L9792: CLC                            ;2
       RTS                            ;6

L9794: SEC                            ;2
       RTS                            ;6

L9796: LDA    $FD                     ;3
       AND    #$1F                    ;2
       CMP    #$04                    ;2
       BCS    L97A1                   ;2
       AND    #$03                    ;2
       TAY                            ;2
L97A1: LDA    L9DCD,Y                 ;4
       STA    $C3                     ;3
       LDA    L9DD1,Y                 ;4
       STA    $C2                     ;3
       RTS                            ;6

L97AC:
       LDY    $F8                     ;3
       BEQ    L980C                   ;2
       LDA    $FE                     ;3
       AND    #$07                    ;2
       BNE    L97B9                   ;2
       JMP    L95DB                   ;3
L97B9: LDA    $D2                     ;3
       BNE    L97FA                   ;2
       LDA    $DB                     ;3
       ROL                            ;2
       LDA    $EE                     ;3
       ROR                            ;2
       LSR                            ;2
       STA    $C4                     ;3
       LDA    $E8                     ;3
       LSR                            ;2
       LSR                            ;2
       STA    $C5                     ;3
       LDA    $D8                     ;3
       ROL                            ;2
       LDA    $EB                     ;3
       ROR                            ;2
       LSR                            ;2
       SEC                            ;2
       SBC    $C4                     ;3
       STA    $C2                     ;3
       LDA    $E5                     ;3
       LSR                            ;2
       LSR                            ;2
       SEC                            ;2
       SBC    $C5                     ;3
       STA    $C3                     ;3
       LDA    $C4                     ;3
       SEC                            ;2
       SBC    $C2                     ;3
       BPL    L97EA                   ;2
       LDA    #$00                    ;2
L97EA: STA    $C2                     ;3
       LDA    $C5                     ;3
       SEC                            ;2
       SBC    $C3                     ;3
       BPL    L97F5                   ;2
       LDA    #$00                    ;2
L97F5: STA    $C3                     ;3
       JMP    L9941                   ;3
L97FA: LDA    $E5                     ;3
       LSR                            ;2
       LSR                            ;2
       STA    $C3                     ;3
       LDA    $D8                     ;3
       ROL                            ;2
       LDA    $EB                     ;3
       ROR                            ;2
       LSR                            ;2
       STA    $C2                     ;3
       JMP    L9941                   ;3
L980C: LDA    SWCHA                   ;4
       AND    #$F0                    ;2 superflous
       LSR                            ;2
       LSR                            ;2
       LSR                            ;2
       LSR                            ;2
       TAY                            ;2
       LDA    L9FB0,Y                 ;4
       BMI    L9864                   ;2
       TAY                            ;2
       LDA    #$00                    ;2
       STA    $F07F                   ;4
       LDA    L9FC0,Y                 ;4
       BIT    $C1                     ;3
       BEQ    L9864                   ;2
       STY    $BE                     ;3
       LDA    $D7,X                   ;4
       STA    $BF                     ;3
       AND    #$FC                    ;2
       ORA    $BE                     ;3
       STA    $D7,X                   ;4




;???---------
       EOR    $BF                     ;3
       AND    #$01                    ;2
       BEQ    L9864                   ;2
       LDA    $DB                     ;3
       AND    #$03                    ;2
       LSR                            ;2
       BCC    L9846                   ;2
       LSR                            ;2
       BCC    L9858                   ;2
       BCS    L9851                   ;2
L9846: LSR                            ;2
       BCC    L985E                   ;2
       INC    $EA,X                   ;6
       INC    $EA,X                   ;6
       INC    $EA,X                   ;6
       BNE    L9864                   ;2
L9851: DEC    $E4,X                   ;6
       DEC    $E4,X                   ;6
       JMP    L9864                   ;3
L9858: INC    $E4,X                   ;6
       INC    $E4,X                   ;6
       BNE    L9864                   ;2
L985E: DEC    $EA,X                   ;6
       DEC    $EA,X                   ;6
       DEC    $EA,X                   ;6
;------------





L9864: JMP    L9A2D                   ;3

L9867:
       LDA    $E8                     ;3
       SEC                            ;2
       SBC    $E4,X                   ;4
       BCS    L9872                   ;2
       EOR    #$FF                    ;2
       ADC    #$01                    ;2
L9872: CMP    #$27                    ;2
       BCS    L989D                   ;2
       LDA    $D7,X                   ;4
       ROL                            ;2
       LDA    $EA,X                   ;4
       ROR                            ;2
       LSR                            ;2
       STA    $BE                     ;3
       LDA    $DB                     ;3
       ROL                            ;2
       LDA    $EE                     ;3
       ROR                            ;2
       LSR                            ;2
       SEC                            ;2
       SBC    $BE                     ;3
       BCS    L988F                   ;2
       EOR    #$FF                    ;2
       ADC    #$01                    ;2
L988F: CMP    #$0C                    ;2
       BCS    L989D                   ;2
       LDA    #$00                    ;2
       STA    $C3                     ;3
       LDA    #$28                    ;2
       STA    $C2                     ;3
       BNE    L98AC                   ;2

L989D: LDA    $E8                     ;3
       LSR                            ;2
       LSR                            ;2
       STA    $C3                     ;3
       LDA    $DB                     ;3
       ROL                            ;2
       LDA    $EE                     ;3
       ROR                            ;2
       LSR                            ;2
       STA    $C2                     ;3
L98AC: JMP    L9941                   ;3

L98AF:
       LDA    $E8                     ;3
       LSR                            ;2
       LSR                            ;2
       STA    $C3                     ;3
       LDA    $DB                     ;3
       ROL                            ;2
       LDA    $EE                     ;3
       ROR                            ;2
       LSR                            ;2
       STA    $C2                     ;3
       LDA    $DB                     ;3
       AND    #$03                    ;2
       TAY                            ;2
       LDA    $C2                     ;3
       CLC                            ;2
       ADC    L98DD,Y                 ;4
       BPL    L98CD                   ;2
       LDA    #$00                    ;2
L98CD: STA    $C2                     ;3
       LDA    $C3                     ;3
       CLC                            ;2
       ADC    L98DE,Y                 ;4
       BPL    L98D9                   ;2
       LDA    #$00                    ;2
L98D9: STA    $C3                     ;3
       BPL    L98AC                   ;2
L98DD: .byte $FC ; |XXXXXX  | $98DD
L98DE: .byte $00 ; |        | $98DE
       .byte $04 ; |     X  | $98DF
       .byte $00 ; |        | $98E0
       .byte $FC ; |XXXXXX  | $98E1

L98E2:
       LDA    $DB                     ;3
       ROL                            ;2
       LDA    $EE                     ;3
       ROR                            ;2
       LSR                            ;2
       STA    $C4                     ;3
       LDA    $E8                     ;3
       LSR                            ;2
       LSR                            ;2
       STA    $C5                     ;3
       LDA    $DB                     ;3
       AND    #$03                    ;2
       TAY                            ;2
       LDA    $C4                     ;3
       CLC                            ;2
       ADC    L98DD,Y                 ;4
       BPL    L9900                   ;2
       LDA    #$00                    ;2
L9900: STA    $C4                     ;3
       LDA    $C5                     ;3
       CLC                            ;2
       ADC    L993D,Y                 ;4
       BPL    L990C                   ;2
       LDA    #$00                    ;2
L990C: STA    $C5                     ;3
       LDA    $D7                     ;3
       ROL                            ;2
       LDA    $EA                     ;3
       ROR                            ;2
       LSR                            ;2
       SEC                            ;2
       SBC    $C4                     ;3
       STA    $C2                     ;3
       LDA    $E4                     ;3
       LSR                            ;2
       LSR                            ;2
       SEC                            ;2
       SBC    $C5                     ;3
       STA    $C3                     ;3
       LDA    $C4                     ;3
       SEC                            ;2
       SBC    $C2                     ;3
       BPL    L992C                   ;2
       LDA    #$00                    ;2
L992C: STA    $C2                     ;3
       LDA    $C5                     ;3
       SEC                            ;2
       SBC    $C3                     ;3
       BPL    L9937                   ;2
       LDA    #$00                    ;2
L9937: STA    $C3                     ;3
       JMP    L9941                   ;3

       .byte $FE ; |XXXXXXX | $993C
L993D: .byte $00 ; |        | $993D
       .byte $02 ; |      X | $993E
       .byte $00 ; |        | $993F
       .byte $FE ; |XXXXXXX | $9940

L9941: STX    $BE                     ;3
       LDA    #$00                    ;2
       STA    $C8                     ;3
       LDA    $D7,X                   ;4
       ROL                            ;2
       LDA    $EA,X                   ;4
       ROR                            ;2
       LSR                            ;2
       STA    $BF                     ;3
       LDA    $E4,X                   ;4
       LSR                            ;2
       LSR                            ;2
       STA    $C0                     ;3
       LDA    $D7,X                   ;4
       AND    #$03                    ;2
       TAX                            ;2
       LDY    L9A44,X                 ;4
       LDA    L9FC0,Y                 ;4
       EOR    #$FF                    ;2
       AND    $C1                     ;3
       STA    $C1                     ;3
       LDA    $C2                     ;3
       SEC                            ;2
       SBC    $BF                     ;3
       STA    $C6                     ;3
       BNE    L9974                   ;2
       LDY    #$80                    ;2
       STY    $C8                     ;3
L9974: AND    #$80                    ;2
       PHA                            ;3
       LDA    $C3                     ;3
       SEC                            ;2
       SBC    $C0                     ;3
       STA    $C7                     ;3
       BNE    L9984                   ;2
       LDY    #$40                    ;2
       STY    $C8                     ;3
L9984: AND    #$80                    ;2
       CLC                            ;2
       ROL                            ;2
       PLA                            ;4
       ROL                            ;2
       ROL                            ;2
       TAY                            ;2
       LDX    L9A3D,Y                 ;4
       STX    $C4                     ;3
       BIT    $C8                     ;3
       BMI    L9999                   ;2
       BVS    L99BC                   ;2
       BVC    L99DF                   ;2
L9999: LDX    $C4                     ;3
       LDA    L9A48,X                 ;4
       TAX                            ;2
       LDA    $C1                     ;3
       CLC                            ;2
       ADC    L9A55,X                 ;4
       CMP    #$20                    ;2
       PHP                            ;3
       BCC    L99AC                   ;2
       SBC    #$20                    ;2
L99AC: TAX                            ;2
       LDA    L9A59,X                 ;4
       PLP                            ;4
       BCC    L99B7                   ;2
       LSR                            ;2
       LSR                            ;2
       LSR                            ;2
       LSR                            ;2
L99B7: AND    #$03                    ;2
       JMP    L9A21                   ;3
L99BC: LDX    $C4                     ;3
       LDA    L9A52,X                 ;4
       TAX                            ;2
       LDA    $C1                     ;3
       CLC                            ;2
       ADC    L9A55,X                 ;4
       CMP    #$20                    ;2
       PHP                            ;3
       BCC    L99CF                   ;2
       SBC    #$20                    ;2
L99CF: TAX                            ;2
       LDA    L9A59,X                 ;4
       PLP                            ;4
       BCC    L99DA                   ;2
       LSR                            ;2
       LSR                            ;2
       LSR                            ;2
       LSR                            ;2
L99DA: AND    #$03                    ;2
       JMP    L9A21                   ;3
L99DF: LDA    $C7                     ;3
       BPL    L99EA                   ;2
       EOR    #$FF                    ;2
       CLC                            ;2
       ADC    #$01                    ;2
       STA    $C7                     ;3
L99EA: LDA    $C6                     ;3
       BPL    L99F3                   ;2
       EOR    #$FF                    ;2
       CLC                            ;2
       ADC    #$01                    ;2
L99F3: CMP    $C7                     ;3
       BPL    L9A30                   ;2
       LDX    $C4                     ;3
       LDA    L9A4C,X                 ;4
       TAY                            ;2
       LDA    L9A48,X                 ;4
       TAX                            ;2
L9A01: LDA    $C1                     ;3
       CLC                            ;2
       ADC    L9A55,X                 ;4
       CMP    #$20                    ;2
       PHP                            ;3
       BCC    L9A0E                   ;2
       SBC    #$20                    ;2
L9A0E: TAX                            ;2
       LDA    L9A59,X                 ;4
       PLP                            ;4
       BCC    L9A19                   ;2
       LSR                            ;2
       LSR                            ;2
       LSR                            ;2
       LSR                            ;2
L9A19: CPY    #$01                    ;2
       BEQ    L9A1F                   ;2
       LSR                            ;2
       LSR                            ;2
L9A1F: AND    #$03                    ;2
L9A21: LDX    $BE                     ;3
       STA    $BE                     ;3
       LDA    $D7,X                   ;4
       AND    #$FC                    ;2
       ORA    $BE                     ;3
       STA    $D7,X                   ;4
L9A2D: JMP    L9A78                   ;3
L9A30: LDX    $C4                     ;3
       LDA    L9A4E,X                 ;4
       TAY                            ;2
       LDA    L9A52,X                 ;4
       TAX                            ;2
       JMP    L9A01                   ;3
L9A3D: .byte $00 ; |        | $9A3D
       .byte $01 ; |       X| $9A3E
       .byte $02 ; |      X | $9A3F
       .byte $03 ; |      XX| $9A40
       .byte $03 ; |      XX| $9A41
       .byte $00 ; |        | $9A42
       .byte $01 ; |       X| $9A43
L9A44: .byte $02 ; |      X | $9A44
       .byte $03 ; |      XX| $9A45
       .byte $00 ; |        | $9A46
       .byte $01 ; |       X| $9A47
L9A48: .byte $01 ; |       X| $9A48
       .byte $01 ; |       X| $9A49
       .byte $03 ; |      XX| $9A4A
       .byte $03 ; |      XX| $9A4B
L9A4C: .byte $00 ; |        | $9A4C
       .byte $01 ; |       X| $9A4D
L9A4E: .byte $01 ; |       X| $9A4E
       .byte $00 ; |        | $9A4F
       .byte $00 ; |        | $9A50
       .byte $01 ; |       X| $9A51
L9A52: .byte $02 ; |      X | $9A52
       .byte $00 ; |        | $9A53
       .byte $02 ; |      X | $9A54
L9A55: .byte $00 ; |        | $9A55
       .byte $10 ; |   X    | $9A56
       .byte $20 ; |  X     | $9A57
       .byte $30 ; |  XX    | $9A58
L9A59: .byte $00 ; |        | $9A59
       .byte $00 ; |        | $9A5A
       .byte $55 ; | X X X X| $9A5B
       .byte $50 ; | X X    | $9A5C
       .byte $AA ; |X X X X | $9A5D
       .byte $A0 ; |X X     | $9A5E
       .byte $A5 ; |X X  X X| $9A5F
       .byte $A0 ; |X X     | $9A60
       .byte $FF ; |XXXXXXXX| $9A61
       .byte $F0 ; |XXXX    | $9A62
       .byte $D7 ; |XX X XXX| $9A63
       .byte $D0 ; |XX X    | $9A64
       .byte $AF ; |X X XXXX| $9A65
       .byte $A0 ; |X X     | $9A66
       .byte $A7 ; |X X  XXX| $9A67
       .byte $00 ; |        | $9A68
       .byte $00 ; |        | $9A69
       .byte $00 ; |        | $9A6A
       .byte $55 ; | X X X X| $9A6B
       .byte $05 ; |     X X| $9A6C
       .byte $AA ; |X X X X | $9A6D
       .byte $28 ; |  X X   | $9A6E
       .byte $A5 ; |X X  X X| $9A6F
       .byte $25 ; |  X  X X| $9A70
       .byte $FF ; |XXXXXXXX| $9A71
       .byte $F0 ; |XXXX    | $9A72
       .byte $F5 ; |XXXX X X| $9A73
       .byte $F5 ; |XXXX X X| $9A74
       .byte $FA ; |XXXXX X | $9A75
       .byte $F8 ; |XXXXX   | $9A76
       .byte $F5 ; |XXXX X X| $9A77



;program changes begin here...

INDIRECTMOV:
L9AA3:
       AND    L9CC6,Y                 ;4
       BEQ    L9AE3                   ;2
       DEC    $E4,X                   ;6
       JMP    L9AE3                   ;3

L9AAD:
       AND    L9CC6,Y                 ;4
       BEQ    L9AE3                   ;2
       INC    $E4,X                   ;6
       JMP    L9AE3                   ;3



L9AB7:
       AND    L9CA6,Y                 ;4
       BEQ    L9AE3                   ;2
;move down
       LDA    $EA,X                   ;4
       CLC                            ;2
       ADC    #$01                    ;2
       STA    $EA,X                   ;4
       BCC    L9AE3                   ;2
       ASL    $D7,X                   ;6
       SEC                            ;2
;       ROR    $D7,X                   ;6
;       JMP    L9AE3                   ;3
       JMP    L9ADE                   ;3





L9A78: CPX    #$05                    ;2
;       BNE    L9A7F                   ;2
;       JMP    L9B05                   ;3
       BEQ    L9B05                   ;2 <-

L9A7F: LDA    $D7,X                   ;4
       AND    #$03                    ;2
       TAY                            ;2
       LDA    L9FC0,Y                 ;4
       BIT    $C1                     ;3
       BEQ    L9AE3                   ;2
       LDA    L9AF0,Y                 ;4
       STA    $B4                     ;3
       LDA    #>INDIRECTMOV           ;2 9A
       STA    $B5                     ;3
       LDA    $D7,X                   ;4
       AND    #$1C                    ;2
       LSR                            ;2
       LSR                            ;2
       TAY                            ;2
       LDA    L9CE6,Y                 ;4
       LDY    $BD                     ;3
       JMP.ind ($B4)                  ;5



L9ACD:
       AND    L9CA6,Y                 ;4
       BEQ    L9AE3                   ;2
;move up
       LDA    $EA,X                   ;4
       SEC                            ;2
       SBC    #$01                    ;2
       STA    $EA,X                   ;4
       BCS    L9AE3                   ;2
       ASL    $D7,X                   ;6
       CLC                            ;2

L9ADE:
       ROR    $D7,X                   ;6
       JMP    L9AE3                   ;3

L9AE3: INC    $F0                     ;5
;       INY                            ;2
;       STY    $F0                     ;3
       LDY    $F0                     ;3
       LDX    L9231,Y                 ;4
       BMI    L9AF4                   ;2

       CPY    #$06                    ;3 7th byte of "which object?" table?
       BNE    L9AED                   ;2 branch if not
       BIT    INPT4                   ;3 button pressed?
       BMI    L9AF4                   ;2 branch if so (double speed)
L9AED:


       JMP    L923D                   ;3
;L9AF0: .byte $CD ; |XX  XX X| $9AF0
;       .byte $AD ; |X X XX X| $9AF1
;       .byte $B7 ; |X XX XXX| $9AF2
;       .byte $A3 ; |X X   XX| $9AF3



L9AF4:
       LDA    $DB                     ;3
       LSR                            ;2
       BCS    L9B02                   ;2
       LSR                            ;2
       BCS    L9B00                   ;2



;added
       INC    $D6                     ;5 scroll screen up
       BIT    INPT4                   ;3 button pressed?
       BPL    L9B02                   ;2 branch if not
       INC    $D6                     ;5 scroll screen up (double speed)

       JMP    L9B02                   ;3

L9B00:
       DEC    $D6                     ;5 scroll screen down
       BIT    INPT4                   ;3 button pressed?
       BPL    L9B02                   ;2 branch if not
       DEC    $D6                     ;5 scroll screen down (double speed)




L9B02: JMP    L9CEC                   ;3
L9B05: LDA    $E3                     ;3
       BPL    L9B0D                   ;2
       CMP    #$E0                    ;2
       BCC    L9B10                   ;2
L9B0D: JMP    L9B85                   ;3
L9B10: LDA    $DC                     ;3
       AND    #$03                    ;2
       TAY                            ;2
       LDA    L9FC0,Y                 ;4
       BIT    $C1                     ;3




;       BNE    L9B1F                   ;2
;       JMP    L9B85                   ;3

;       BEQ    L9B85                   ;2
       BEQ    L9AF4                   ;2


L9B1F: LDA    L9B88,Y                 ;4
       STA    $B4                     ;3
       LDA    #>FRUITMOV              ;2 9B
       STA    $B5                     ;3
       LDA    #$01                    ;2
       LDY    $BD                     ;3
       JMP.ind ($B4)                  ;5


FRUITMOV:
L9B2F:
       AND    L9CC6,Y                 ;4
       BEQ    L9B85                   ;2
       DEC    $E9                     ;5
       JMP    L9B40                   ;3

L9B53:
       AND    L9CA6,Y                 ;4
       BEQ    L9B85                   ;2
       LDA    $EF                     ;3
       CLC                            ;2
       ADC    #$02                    ;2
       STA    $EF                     ;3
       BCC    L9B7D                   ;2
       LDA    #$80                    ;2
       ORA    $DC                     ;3
       STA    $DC                     ;3
       BNE    L9B7D                   ;2

L9B69:
       AND    L9CA6,Y                 ;4
       BEQ    L9B85                   ;2
       LDA    $EF                     ;3
       SEC                            ;2
       SBC    #$02                    ;2
       STA    $EF                     ;3
       BCS    L9B7D                   ;2
       LDA    $DC                     ;3
       AND    #$7F                    ;2
       STA    $DC                     ;3
L9B7D: JMP    L9B40                   ;3

L9B39:
       AND    L9CC6,Y                 ;4
       BEQ    L9B85                   ;2
       INC    $E9                     ;5
L9B40: LDA    #$08                    ;2
       EOR    $E3                     ;3
       STA    $E3                     ;3
       AND    #$08                    ;2
       BNE    L9B80                   ;2
       LDY    $F1                     ;3
       INY                            ;2
       BNE    L9B80                   ;2
       STY    $F1                     ;3
;       BEQ    L9B80                   ;2

L9B80: JSR    L9E72                   ;6
       LDX    #$05                    ;2
L9B85: JMP    L9AE3                   ;3

;L9B88: .byte $69 ; | XX X  X| $9B88
;       .byte $39 ; |  XXX  X| $9B89
;       .byte $53 ; | X X  XX| $9B8A
;       .byte $2F ; |  X XXXX| $9B8B

       ORG $1B8E
       RORG $1B8E

L9B8C: LDA    $E3                     ;3
       BMI    L9B93                   ;2
       JMP    L9C58                   ;3
L9B93: CMP    #$E0                    ;2
       BCS    L9B9A                   ;2
L9B97: JMP    L9CA0                   ;3
L9B9A: LDA    $E3                     ;3
       CMP    #$E0                    ;2
       BNE    L9C06                   ;2
       LDA    $E1                     ;3
       AND    #$40                    ;2
       BNE    L9B97                   ;2
       LDA    #$49                    ;2
       STA    $F2                     ;3
       INC    $E3                     ;5

;       INC    $F4                     ;5
;       BNE    L9BB6                   ;2
;       LDA    $FF                     ;3
;       ORA    #$08                    ;2
;       STA    $FF                     ;3
;L9BB6: LDA    $FF                     ;3

       LDA    $FF                     ;3
       INC    $F4                     ;5
       BNE    L9BB6                   ;2
       ORA    #$08                    ;2
L9BB6: STA    $FF                     ;3


       AND    #$08                    ;2
       BEQ    L9BC8                   ;2
       LDX    $F6                     ;3
       LDA    $F4                     ;3
       CMP    L94F6,X                 ;4
       BNE    L9BC8                   ;2
       JMP    L94E2                   ;3
L9BC8: LDX    #$02                    ;2
       LDA    #$24                    ;2
       STA    $B2                     ;3
       LDA    $E9                     ;3
       CMP    #$4A                    ;2
       BEQ    L9C09                   ;2
       BCC    L9BDC                   ;2
       LDX    #$10                    ;2
       LDA    #$12                    ;2
       STA    $B2                     ;3
L9BDC: LDY    #$01                    ;2
       LDA    $EF                     ;3
       CMP    #$14                    ;2
       BEQ    L9BE6                   ;2
       LDY    #$10                    ;2
L9BE6: TYA                            ;2
       CLC                            ;2
       ADC    $B2                     ;3
       STA    $B2                     ;3
L9BEC: LDA    #$F0                    ;2
       STA    $B3                     ;3
       LDY    #$80                    ;2
       LDA    ($B2),Y                 ;5
       AND    L9576,X                 ;4
       LDY    #$00                    ;2
       STA    ($B2),Y                 ;6
       LDY    #$B6                    ;2
       LDA    ($B2),Y                 ;5
       AND    L9576,X                 ;4
       LDY    #$36                    ;2
       STA    ($B2),Y                 ;6
L9C06: JMP    L9C21                   ;3
L9C09: LDX    $F6                     ;3
       LDY    L9FC4,X                 ;4
       LDA    $DC                     ;3
       ROL                            ;2
       LDA    $EF                     ;3
       LSR                            ;2
       CMP    #$5A                    ;2
       BCC    L9C1B                   ;2
       LDY    L9FCB,X                 ;4
L9C1B: LDX    #$09                    ;2
       STY    $B2                     ;3
       BNE    L9BEC                   ;2
L9C21: LDA    $F2                     ;3
       CMP    #$49                    ;2
       BCC    L9C2B                   ;2
       CMP    #$57                    ;2
       BCC    L9C2F                   ;2
L9C2B: LDA    #$49                    ;2
       STA    $F2                     ;3
L9C2F: LDA    $FC                     ;3
       PHA                            ;3
       AND    #$04                    ;2
       LSR                            ;2
       LSR                            ;2
       ADC    #$1A                    ;2
       STA    $B4                     ;3
       LDA    $E2                     ;3
       AND    #$C0                    ;2
       ORA    $B4                     ;3
       STA    $E2                     ;3
       PLA                            ;4
       AND    #$03                    ;2
       BNE    L9C55                   ;2
       INC    $E3                     ;5
       BNE    L9C55                   ;2
       LDA    #$00                    ;2
       LDY    $D2                     ;3
       BEQ    L9C53                   ;2
       LDA    #$09                    ;2
L9C53: STA    $F2                     ;3
L9C55: JMP    L9CA0                   ;3
L9C58: BIT    $E1                     ;3
       BPL    L9CA5                   ;2
       CLC                            ;2
       LDA    $FF                     ;3
       AND    #$08                    ;2
       BEQ    L9C64                   ;2
       SEC                            ;2
L9C64: LDA    $F4                     ;3
       ROR                            ;2
       BCS    L9CA0                   ;2
       CMP    #$23                    ;2
       BEQ    L9C79                   ;2
       CMP    #$46                    ;2
       BEQ    L9C79                   ;2
       CMP    #$69                    ;2
       BEQ    L9C79                   ;2
       CMP    #$8C                    ;2
       BNE    L9CA0                   ;2
L9C79: LDA    #$50                    ;2
       STA    $E9                     ;3
       LDA    #$8C                    ;2
       STA    $EF                     ;3
       LDA    $FC                     ;3
       AND    #$03                    ;2
       ORA    #$1D                    ;2
       STA    $DC                     ;3
       LDA    $F6                     ;3
       BIT    $FF                     ;3
       BPL    L9C91                   ;2
       LDA    #$06                    ;2
L9C91: CLC                            ;2
       ADC    #$0C                    ;2
       STA    $E2                     ;3
       LDA    $FC                     ;3
       AND    #$0C                    ;2
       LSR                            ;2
       LSR                            ;2
       ORA    #$80                    ;2
       STA    $E3                     ;3
L9CA0: ASL    $E1                     ;5
       CLC                            ;2
       ROR    $E1                     ;5
L9CA5: RTS                            ;6

L9CA6: .byte $FB ; |XXXXX XX| $9CA6
       .byte $FC ; |XXXXXX  | $9CA7
       .byte $F8 ; |XXXXX   | $9CA8
       .byte $FC ; |XXXXXX  | $9CA9
       .byte $FC ; |XXXXXX  | $9CAA
       .byte $F9 ; |XXXXX  X| $9CAB
       .byte $FC ; |XXXXXX  | $9CAC
       .byte $FC ; |XXXXXX  | $9CAD
       .byte $F8 ; |XXXXX   | $9CAE
       .byte $FC ; |XXXXXX  | $9CAF
       .byte $FD ; |XXXXXX X| $9CB0
       .byte $F8 ; |XXXXX   | $9CB1
       .byte $FC ; |XXXXXX  | $9CB2
       .byte $FC ; |XXXXXX  | $9CB3
       .byte $F8 ; |XXXXX   | $9CB4
       .byte $FC ; |XXXXXX  | $9CB5
       .byte $00 ; |        | $9CB6
       .byte $00 ; |        | $9CB7
       .byte $00 ; |        | $9CB8
       .byte $80 ; |X       | $9CB9
       .byte $00 ; |        | $9CBA
       .byte $40 ; | X      | $9CBB
       .byte $00 ; |        | $9CBC
       .byte $A0 ; |X X     | $9CBD
       .byte $00 ; |        | $9CBE
       .byte $00 ; |        | $9CBF
       .byte $40 ; | X      | $9CC0
       .byte $80 ; |X       | $9CC1
       .byte $00 ; |        | $9CC2
       .byte $00 ; |        | $9CC3
       .byte $00 ; |        | $9CC4
       .byte $B0 ; |X XX    | $9CC5
L9CC6: .byte $BF ; |X XXXXXX| $9CC6
       .byte $F8 ; |XXXXX   | $9CC7
       .byte $FC ; |XXXXXX  | $9CC8
       .byte $F8 ; |XXXXX   | $9CC9
       .byte $FC ; |XXXXXX  | $9CCA
       .byte $F1 ; |XXXX   X| $9CCB
       .byte $FC ; |XXXXXX  | $9CCC
       .byte $C8 ; |XX  X   | $9CCD
       .byte $FC ; |XXXXXX  | $9CCE
       .byte $F8 ; |XXXXX   | $9CCF
       .byte $FD ; |XXXXXX X| $9CD0
       .byte $F0 ; |XXXX    | $9CD1
       .byte $FC ; |XXXXXX  | $9CD2
       .byte $F8 ; |XXXXX   | $9CD3
       .byte $FC ; |XXXXXX  | $9CD4
       .byte $C8 ; |XX  X   | $9CD5
       .byte $00 ; |        | $9CD6
       .byte $00 ; |        | $9CD7
       .byte $00 ; |        | $9CD8
       .byte $00 ; |        | $9CD9
       .byte $00 ; |        | $9CDA
       .byte $00 ; |        | $9CDB
       .byte $00 ; |        | $9CDC
       .byte $00 ; |        | $9CDD
       .byte $00 ; |        | $9CDE
       .byte $00 ; |        | $9CDF
       .byte $00 ; |        | $9CE0
       .byte $00 ; |        | $9CE1
       .byte $00 ; |        | $9CE2
       .byte $00 ; |        | $9CE3
       .byte $00 ; |        | $9CE4
       .byte $00 ; |        | $9CE5
L9CE6: .byte $80 ; |X       | $9CE6
       .byte $40 ; | X      | $9CE7
       .byte $20 ; |  X     | $9CE8
       .byte $10 ; |   X    | $9CE9
       .byte $08 ; |    X   | $9CEA
       .byte $04 ; |     X  | $9CEB
L9CEC: LDY    #$00                    ;2
       LDA    $FF                     ;3
       AND    #$30                    ;2
       LSR                            ;2
       LSR                            ;2
       LSR                            ;2
       LSR                            ;2
       TAX                            ;2
L9CF7: JSR    L9D1C                   ;6
       INX                            ;2
       CPX    #$04                    ;2
       BNE    L9CF7                   ;2
       TYA                            ;2
       BNE    L9D08                   ;2
       LDA    #$03                    ;2
       STA    $A1                     ;3
       BNE    L9D0F                   ;2
L9D08: DEC    $A1                     ;5
       BPL    L9D0F                   ;2
       JMP    L9DA4                   ;3
L9D0F: LDA    $E3                     ;3
       BPL    L9D1B                   ;2
       CMP    #$E0                    ;2
       BCS    L9D1B                   ;2
       INX                            ;2
       JSR    L9D1C                   ;6
L9D1B: RTS                            ;6

L9D1C: LDA    $E4,X                   ;4
       SEC                            ;2
       SBC    $E8                     ;3
       BCS    L9D27                   ;2
       EOR    #$FF                    ;2
       ADC    #$01                    ;2
L9D27: CMP    #$04                    ;2
       BCS    L9D1B                   ;2
       LDA    $EA,X                   ;4
       SEC                            ;2
       SBC    $EE                     ;3
       BCS    L9D36                   ;2
       EOR    #$FF                    ;2
       ADC    #$01                    ;2
L9D36: CMP    #$07                    ;2
       BCS    L9D1B                   ;2
       LDA    $D7,X                   ;4
       EOR    $DB                     ;3
       AND    #$80                    ;2
       BNE    L9D1B                   ;2
       CPX    #$05                    ;2
       BEQ    L9DB3                   ;2
       LDA    $DD,X                   ;4
       AND    #$80                    ;2
       BNE    L9D1B                   ;2
       LDA    $D7,X                   ;4
       AND    #$40                    ;2
       BNE    L9D54                   ;2
       INY                            ;2
       RTS                            ;6

L9D54: LDA    $DD,X                   ;4
       ORA    #$80                    ;2
       STA    $DD,X                   ;4
       LDA    $D7,X                   ;4
       AND    #$A3                    ;2
       STA    $D7,X                   ;4
       LDA    $F5                     ;3
       AND    #$03                    ;2
       TAY                            ;2
       LDA    L9DA0,Y                 ;4
       STX    $B5                     ;3
       JSR    L9E07                   ;6
       LDX    $B5                     ;3
       LDA    #$57                    ;2
       STA    $F2                     ;3
       LDA    #$20                    ;2
       STA    $D5                     ;3
       LDA    #$04                    ;2
       STA    $F3                     ;3
       LDA    $F5                     ;3
       AND    #$03                    ;2
       CLC                            ;2
       ADC    #$01                    ;2
       STA    $B2                     ;3
       LDA    $FF                     ;3
       AND    #$30                    ;2
       LSR                            ;2
       LSR                            ;2
       LSR                            ;2
       LSR                            ;2
       ADC    $B2                     ;3
       CMP    #$04                    ;2
       BCS    L9D96                   ;2
       INC    $F5                     ;5
       BNE    L9D9A                   ;2
L9D96: LDA    #$01                    ;2
       STA    $D2                     ;3
L9D9A: LDX    #$CF                    ;2
       TXS                            ;2
       JMP    L921B                   ;3
L9DA0: ORA    COLUP0                  ;3
       ORA    #$0B                    ;2
L9DA4: LDA    #$05                    ;2
       STA    $F3                     ;3
       LDA    #$20                    ;2
       STA    $D5                     ;3
       LDA    #$FF                    ;2
       STA    $F1                     ;3
       STA    $F2                     ;3
       RTS                            ;6

L9DB3: LDA    #$00                    ;2
       STA    $E3                     ;3
       LDX    $F6                     ;3
       BIT    $FF                     ;3
       BPL    L9DBF                   ;2
       LDX    #$06                    ;2
L9DBF: LDA    L9DC6,X                 ;4
       JSR    L9E07                   ;6
       RTS                            ;6

L9DC6: .byte $03 ; |      XX| $9DC6
       .byte $04 ; |     X  | $9DC7
       .byte $07 ; |     XXX| $9DC8
       .byte $08 ; |    X   | $9DC9
       .byte $0A ; |    X X | $9DCA
       .byte $0C ; |    XX  | $9DCB
       .byte $0D ; |    XX X| $9DCC
L9DCD: .byte $04 ; |     X  | $9DCD
       .byte $04 ; |     X  | $9DCE
       .byte $21 ; |  X    X| $9DCF
       .byte $21 ; |  X    X| $9DD0
L9DD1: .byte $05 ; |     X X| $9DD1
       .byte $50 ; | X X    | $9DD2
       .byte $05 ; |     X X| $9DD3
       .byte $50 ; | X X    | $9DD4
L9DD5: LDY    $D2                     ;3
       BEQ    L9E06                   ;2
       LDA    $FC                     ;3
       LSR                            ;2
       BCC    L9E06                   ;2
       DEY                            ;2
       BEQ    L9DE5                   ;2
       STY    $D2                     ;3
       BNE    L9E06                   ;2
L9DE5: STY    $D2                     ;3
       STY    $F2                     ;3
       LDY    #$03                    ;2
L9DEB: LDA.wy $DD,Y                   ;4
       ASL                            ;2
       BCS    L9DFB                   ;2
       LDA.wy $D7,Y                   ;4
       AND    #$A3                    ;2
       ORA    #$10                    ;2
       STA.wy $D7,Y                   ;5
L9DFB: DEY                            ;2
       BPL    L9DEB                   ;2
       LDA    $DB                     ;3
       AND    #$E3                    ;2
       ORA    #$08                    ;2
       STA    $DB                     ;3
L9E06: RTS                            ;6

L9E07: BIT    $F8                     ;3
       BMI    L9E55                   ;2
       TAX                            ;2
       SED                            ;2
       CMP    #$03                    ;2
       CLC                            ;2
       BPL    L9E1D                   ;2
       LDA    $F9                     ;3
       ADC    L9E56,X                 ;4
       STA    $F9                     ;3
       LDA    #$00                    ;2
       BEQ    L9E20                   ;2
L9E1D: LDA    L9E56,X                 ;4
L9E20: ADC    $FA                     ;3
       STA    $FA                     ;3
       LDA    $FB                     ;3
       ADC    #$00                    ;2
       STA    $FB                     ;3
       CLD                            ;2
       LDA    $FB                     ;3
       AND    #$0F                    ;2
       BEQ    L9E47                   ;2
       LDA    $FA                     ;3
       CMP    #$50                    ;2
       BCC    L9E47                   ;2
       LDA    #$04                    ;2
       BIT    $FF                     ;3
       BNE    L9E47                   ;2
       INC    $FF                     ;5
       ORA    $FF                     ;3 superflous?
       STA    $FF                     ;3
       LDA    #$34                    ;2
       BNE    L9E53                   ;2
L9E47: LDA    L9E64,X                 ;4
       LDX    $F1                     ;3
       INX                            ;2
       BEQ    L9E53                   ;2
       CMP    $F1                     ;3
       BCC    L9E55                   ;2
L9E53: STA    $F1                     ;3
L9E55: RTS                            ;6

L9E56: .byte $10 ; |   X    | $9E56
       .byte $50 ; | X X    | $9E57
       .byte $50 ; | X X    | $9E58
       .byte $01 ; |       X| $9E59
       .byte $02 ; |      X | $9E5A
       .byte $02 ; |      X | $9E5B
       .byte $04 ; |     X  | $9E5C
       .byte $05 ; |     X X| $9E5D
       .byte $07 ; |     XXX| $9E5E
       .byte $08 ; |    X   | $9E5F
       .byte $10 ; |   X    | $9E60
       .byte $16 ; |   X XX | $9E61
       .byte $20 ; |  X     | $9E62
       .byte $50 ; | X X    | $9E63
L9E64: .byte $04 ; |     X  | $9E64
       .byte $08 ; |    X   | $9E65
       .byte $08 ; |    X   | $9E66
       .byte $0E ; |    XXX | $9E67
       .byte $0E ; |    XXX | $9E68
       .byte $1F ; |   XXXXX| $9E69
       .byte $1F ; |   XXXXX| $9E6A
       .byte $0E ; |    XXX | $9E6B
       .byte $0E ; |    XXX | $9E6C
       .byte $1F ; |   XXXXX| $9E6D
       .byte $0E ; |    XXX | $9E6E
       .byte $1F ; |   XXXXX| $9E6F
       .byte $0E ; |    XXX | $9E70
       .byte $0E ; |    XXX | $9E71
L9E72: LDA    $E2                     ;3
       AND    #$BF                    ;2
       STA    $E2                     ;3
       LDA    $E9                     ;3
       LSR                            ;2
       BCS    L9EBC                   ;2
       JSR    L9530                   ;6
       BCS    L9EBC                   ;2
       LDA    $DC                     ;3
       ROL                            ;2
       LDA    $EF                     ;3
       ROR                            ;2
       BCS    L9EBC                   ;2
       LSR                            ;2
       BCS    L9EBC                   ;2
       TAY                            ;2
       LDA    L9F5A,Y                 ;4
       BMI    L9EBC                   ;2
       STA    $B2                     ;3
       LDA    #$F0                    ;2
       STA    $B3                     ;3
       LDA    L9550,X                 ;4
       CLC                            ;2
       ADC    $B2                     ;3
       STA    $B2                     ;3
       LDY    #$80                    ;2
       LDA    ($B2),Y                 ;5
       AND    L9563,X                 ;4
       BEQ    L9EBC                   ;2
       LDY    #$B6                    ;2
       LDA    ($B2),Y                 ;5
       ORA    L9563,X                 ;4
       LDY    #$36                    ;2
       STA    ($B2),Y                 ;6
       LDA    $E2                     ;3
       ORA    #$40                    ;2
       STA    $E2                     ;3
       RTS                            ;6

L9EBC: LDA    $EF                     ;3
       CLC                            ;2
       ADC    #$0A                    ;2
       BCS    L9EC8                   ;2
       PHA                            ;3
       LDA    $DC                     ;3
       ROL                            ;2
       PLA                            ;4
L9EC8: ROR                            ;2
       BCS    L9F42                   ;2
       LSR                            ;2
       BCS    L9F42                   ;2
       TAY                            ;2
       LDA    L9F5A,Y                 ;4
       BMI    L9F42                   ;2
       TAY                            ;2
       CLC                            ;2
       LDA    $E9                     ;3
       ADC    #$01                    ;2
       AND    #$FC                    ;2
       LSR                            ;2
       TAX                            ;2
       LDA    L9255,X                 ;4
       BMI    L9F42                   ;2
       TAX                            ;2
       LDA    L9517,X                 ;4
       BMI    L9F42                   ;2
       TAX                            ;2
       LDA    $F0EC,Y                 ;4
       AND    L9522,X                 ;4
       BEQ    L9F42                   ;2
       TXA                            ;2
       CPX    #$03                    ;2
       BCS    L9F1D                   ;2
       ASL                            ;2
       ASL                            ;2
       ASL                            ;2
       STA    $BE                     ;3
       LDA    $F080,Y                 ;4
       AND    #$07                    ;2
       CLC                            ;2
       ADC    $BE                     ;3
       STY    $BE                     ;3
       TAY                            ;2
       LDA    L94FD,Y                 ;4
       BMI    L9F42                   ;2
       LDY    $BE                     ;3
       AND    #$0F                    ;2
       STA    $BE                     ;3
       LDA    $F080,Y                 ;4
       AND    #$F0                    ;2
       ORA    $BE                     ;3
       STA    $F000,Y                 ;5
       RTS                            ;6

L9F1D: LDA    L9512,X                 ;4
       STA    $BE                     ;3
       LDA    $F0B6,Y                 ;4
       AND    #$07                    ;2
       CLC                            ;2
       ADC    $BE                     ;3
       STY    $BE                     ;3
       TAY                            ;2
       LDA    L94FD,Y                 ;4
       BMI    L9F42                   ;2
       LDY    $BE                     ;3
       AND    #$0F                    ;2
       STA    $BE                     ;3
       LDA    $F0B6,Y                 ;4
       AND    #$F0                    ;2
       ORA    $BE                     ;3
       STA    $F036,Y                 ;5
L9F42: RTS                            ;6

L9F43: LDA    L9563,X                 ;4
       ORA    $F092,Y                 ;4
       STA    $F012,Y                 ;5
       LDA    $F0C8,Y                 ;4
       ORA    L9563,X                 ;4
       STA    $F048,Y                 ;5
       RTS                            ;6

L9F56: .byte $05 ; |     X X| $9F56
       .byte $0A ; |    X X | $9F57
       .byte $05 ; |     X X| $9F58
       .byte $0A ; |    X X | $9F59
L9F5A: .byte $00 ; |        | $9F5A
       .byte $80 ; |X       | $9F5B
       .byte $80 ; |X       | $9F5C
       .byte $80 ; |X       | $9F5D
       .byte $80 ; |X       | $9F5E
       .byte $01 ; |       X| $9F5F
       .byte $80 ; |X       | $9F60
       .byte $80 ; |X       | $9F61
       .byte $80 ; |X       | $9F62
       .byte $80 ; |X       | $9F63
       .byte $02 ; |      X | $9F64
       .byte $80 ; |X       | $9F65
       .byte $80 ; |X       | $9F66
       .byte $80 ; |X       | $9F67
       .byte $80 ; |X       | $9F68
       .byte $03 ; |      XX| $9F69
       .byte $80 ; |X       | $9F6A
       .byte $80 ; |X       | $9F6B
       .byte $80 ; |X       | $9F6C
       .byte $80 ; |X       | $9F6D
       .byte $04 ; |     X  | $9F6E
       .byte $80 ; |X       | $9F6F
       .byte $80 ; |X       | $9F70
       .byte $80 ; |X       | $9F71
       .byte $80 ; |X       | $9F72
       .byte $05 ; |     X X| $9F73
       .byte $80 ; |X       | $9F74
       .byte $80 ; |X       | $9F75
       .byte $80 ; |X       | $9F76
       .byte $80 ; |X       | $9F77
       .byte $06 ; |     XX | $9F78
       .byte $80 ; |X       | $9F79
       .byte $80 ; |X       | $9F7A
       .byte $80 ; |X       | $9F7B
       .byte $80 ; |X       | $9F7C
       .byte $07 ; |     XXX| $9F7D
       .byte $80 ; |X       | $9F7E
       .byte $80 ; |X       | $9F7F
       .byte $80 ; |X       | $9F80
       .byte $80 ; |X       | $9F81
       .byte $08 ; |    X   | $9F82
       .byte $80 ; |X       | $9F83
       .byte $80 ; |X       | $9F84
       .byte $80 ; |X       | $9F85
       .byte $80 ; |X       | $9F86
       .byte $09 ; |    X  X| $9F87
       .byte $80 ; |X       | $9F88
       .byte $80 ; |X       | $9F89
       .byte $80 ; |X       | $9F8A
       .byte $80 ; |X       | $9F8B
       .byte $0A ; |    X X | $9F8C
       .byte $80 ; |X       | $9F8D
       .byte $80 ; |X       | $9F8E
       .byte $80 ; |X       | $9F8F
       .byte $80 ; |X       | $9F90
       .byte $0B ; |    X XX| $9F91
       .byte $80 ; |X       | $9F92
       .byte $80 ; |X       | $9F93
       .byte $80 ; |X       | $9F94
       .byte $80 ; |X       | $9F95
       .byte $0C ; |    XX  | $9F96
       .byte $80 ; |X       | $9F97
       .byte $80 ; |X       | $9F98
       .byte $80 ; |X       | $9F99
       .byte $80 ; |X       | $9F9A
       .byte $0D ; |    XX X| $9F9B
       .byte $80 ; |X       | $9F9C
       .byte $80 ; |X       | $9F9D
       .byte $80 ; |X       | $9F9E
       .byte $80 ; |X       | $9F9F
       .byte $0E ; |    XXX | $9FA0
       .byte $80 ; |X       | $9FA1
       .byte $80 ; |X       | $9FA2
       .byte $80 ; |X       | $9FA3
       .byte $80 ; |X       | $9FA4
       .byte $0F ; |    XXXX| $9FA5
       .byte $80 ; |X       | $9FA6
       .byte $80 ; |X       | $9FA7
       .byte $80 ; |X       | $9FA8
       .byte $80 ; |X       | $9FA9
       .byte $10 ; |   X    | $9FAA
       .byte $80 ; |X       | $9FAB
       .byte $80 ; |X       | $9FAC
       .byte $80 ; |X       | $9FAD
       .byte $80 ; |X       | $9FAE
       .byte $11 ; |   X   X| $9FAF
L9FB0: .byte $80 ; |X       | $9FB0
       .byte $80 ; |X       | $9FB1
       .byte $80 ; |X       | $9FB2
       .byte $80 ; |X       | $9FB3
       .byte $80 ; |X       | $9FB4
       .byte $01 ; |       X| $9FB5
       .byte $00 ; |        | $9FB6
       .byte $01 ; |       X| $9FB7
       .byte $80 ; |X       | $9FB8
       .byte $02 ; |      X | $9FB9
       .byte $03 ; |      XX| $9FBA
       .byte $03 ; |      XX| $9FBB
       .byte $80 ; |X       | $9FBC
       .byte $02 ; |      X | $9FBD
       .byte $00 ; |        | $9FBE
       .byte $80 ; |X       | $9FBF
L9FC0: .byte $01 ; |       X| $9FC0
       .byte $02 ; |      X | $9FC1
       .byte $04 ; |     X  | $9FC2
       .byte $08 ; |    X   | $9FC3
L9FC4: .byte $17 ; |   X XXX| $9FC4
       .byte $16 ; |   X XX | $9FC5
       .byte $17 ; |   X XXX| $9FC6
       .byte $17 ; |   X XXX| $9FC7
       .byte $17 ; |   X XXX| $9FC8
       .byte $17 ; |   X XXX| $9FC9
       .byte $18 ; |   XX   | $9FCA
L9FCB: .byte $1D ; |   XXX X| $9FCB
       .byte $1D ; |   XXX X| $9FCC
       .byte $1D ; |   XXX X| $9FCD
       .byte $1E ; |   XXXX | $9FCE
       .byte $1D ; |   XXX X| $9FCF
       .byte $1C ; |   XXX  | $9FD0
       .byte $1C ; |   XXX  | $9FD1


;15 unused?
       .byte $FF ; |XXXXXXXX| $9FD2
       .byte $FF ; |XXXXXXXX| $9FD3
       .byte $FF ; |XXXXXXXX| $9FD4
       .byte $FF ; |XXXXXXXX| $9FD5
       .byte $FF ; |XXXXXXXX| $9FD6
       .byte $FF ; |XXXXXXXX| $9FD7
       .byte $FF ; |XXXXXXXX| $9FD8
;       .byte $FF ; |XXXXXXXX| $9FD9
;       .byte $FF ; |XXXXXXXX| $9FDA
;       .byte $FF ; |XXXXXXXX| $9FDB
;       .byte $FF ; |XXXXXXXX| $9FDC
;       .byte $FF ; |XXXXXXXX| $9FDD
;       .byte $FF ; |XXXXXXXX| $9FDE
;       .byte $FF ; |XXXXXXXX| $9FDF
;       .byte $FF ; |XXXXXXXX| $9FE0

L9B88: .byte <L9B69 ; | XX X  X| $9B88
       .byte <L9B39 ; |  XXX  X| $9B89
       .byte <L9B53 ; | X X  XX| $9B8A
       .byte <L9B2F ; |  X XXXX| $9B8B


L9AF0: .byte <L9ACD ; |XX  XX X| $9AF0
       .byte <L9AAD ; |X X XX X| $9AF1
       .byte <L9AB7 ; |X XX XXX| $9AF2
       .byte <L9AA3 ; |X X   XX| $9AF3



L9FE1: STA    BANK4                   ;4
       .byte $FF ; |XXXXXXXX| $9FE4
       .byte $FF ; |XXXXXXXX| $9FE5
       .byte $FF ; |XXXXXXXX| $9FE6
L9FE7: STA    BANK4                   ;4
       JMP    L9589                   ;3
       .byte $FF ; |XXXXXXXX| $9FED
       .byte $FF ; |XXXXXXXX| $9FEE
       .byte $FF ; |XXXXXXXX| $9FEF
       JMP    L9103                   ;3
       .byte $FF ; |XXXXXXXX| $9FF3
       .byte $FF ; |XXXXXXXX| $9FF4
       .byte $FF ; |XXXXXXXX| $9FF5

       ORG $1FF6
       RORG $9FF6
       .byte $FF ; |XXXXXXXX| $9FF6
       .byte $FF ; |XXXXXXXX| $9FF7
       .byte $FF ; |XXXXXXXX| $9FF8
       .byte $00 ; |        | $9FF9
       .byte $FF ; |XXXXXXXX| $9FFA
       .byte $FF ; |XXXXXXXX| $9FFB
       .word STRT1,STRT1





























       ORG $2000
       RORG $B000

       .byte $FF ; |XXXXXXXX| $B000
       .byte $FF ; |XXXXXXXX| $B001
       .byte $FF ; |XXXXXXXX| $B002
       .byte $FF ; |XXXXXXXX| $B003
       .byte $FF ; |XXXXXXXX| $B004
       .byte $FF ; |XXXXXXXX| $B005
       .byte $FF ; |XXXXXXXX| $B006
       .byte $FF ; |XXXXXXXX| $B007
       .byte $FF ; |XXXXXXXX| $B008
       .byte $FF ; |XXXXXXXX| $B009
       .byte $FF ; |XXXXXXXX| $B00A
       .byte $FF ; |XXXXXXXX| $B00B
       .byte $FF ; |XXXXXXXX| $B00C
       .byte $FF ; |XXXXXXXX| $B00D
       .byte $FF ; |XXXXXXXX| $B00E
       .byte $FF ; |XXXXXXXX| $B00F
       .byte $FF ; |XXXXXXXX| $B010
       .byte $FF ; |XXXXXXXX| $B011
       .byte $FF ; |XXXXXXXX| $B012
       .byte $FF ; |XXXXXXXX| $B013
       .byte $FF ; |XXXXXXXX| $B014
       .byte $FF ; |XXXXXXXX| $B015
       .byte $FF ; |XXXXXXXX| $B016
       .byte $FF ; |XXXXXXXX| $B017
       .byte $FF ; |XXXXXXXX| $B018
       .byte $FF ; |XXXXXXXX| $B019
       .byte $FF ; |XXXXXXXX| $B01A
       .byte $FF ; |XXXXXXXX| $B01B
       .byte $FF ; |XXXXXXXX| $B01C
       .byte $FF ; |XXXXXXXX| $B01D
       .byte $FF ; |XXXXXXXX| $B01E
       .byte $FF ; |XXXXXXXX| $B01F
       .byte $FF ; |XXXXXXXX| $B020
       .byte $FF ; |XXXXXXXX| $B021
       .byte $FF ; |XXXXXXXX| $B022
       .byte $FF ; |XXXXXXXX| $B023
       .byte $FF ; |XXXXXXXX| $B024
       .byte $FF ; |XXXXXXXX| $B025
       .byte $FF ; |XXXXXXXX| $B026
       .byte $FF ; |XXXXXXXX| $B027
       .byte $FF ; |XXXXXXXX| $B028
       .byte $FF ; |XXXXXXXX| $B029
       .byte $FF ; |XXXXXXXX| $B02A
       .byte $FF ; |XXXXXXXX| $B02B
       .byte $FF ; |XXXXXXXX| $B02C
       .byte $FF ; |XXXXXXXX| $B02D
       .byte $FF ; |XXXXXXXX| $B02E
       .byte $FF ; |XXXXXXXX| $B02F
       .byte $FF ; |XXXXXXXX| $B030
       .byte $FF ; |XXXXXXXX| $B031
       .byte $FF ; |XXXXXXXX| $B032
       .byte $FF ; |XXXXXXXX| $B033
       .byte $FF ; |XXXXXXXX| $B034
       .byte $FF ; |XXXXXXXX| $B035
       .byte $FF ; |XXXXXXXX| $B036
       .byte $FF ; |XXXXXXXX| $B037
       .byte $FF ; |XXXXXXXX| $B038
       .byte $FF ; |XXXXXXXX| $B039
       .byte $FF ; |XXXXXXXX| $B03A
       .byte $FF ; |XXXXXXXX| $B03B
       .byte $FF ; |XXXXXXXX| $B03C
       .byte $FF ; |XXXXXXXX| $B03D
       .byte $FF ; |XXXXXXXX| $B03E
       .byte $FF ; |XXXXXXXX| $B03F
       .byte $FF ; |XXXXXXXX| $B040
       .byte $FF ; |XXXXXXXX| $B041
       .byte $FF ; |XXXXXXXX| $B042
       .byte $FF ; |XXXXXXXX| $B043
       .byte $FF ; |XXXXXXXX| $B044
       .byte $FF ; |XXXXXXXX| $B045
       .byte $FF ; |XXXXXXXX| $B046
       .byte $FF ; |XXXXXXXX| $B047
       .byte $FF ; |XXXXXXXX| $B048
       .byte $FF ; |XXXXXXXX| $B049
       .byte $FF ; |XXXXXXXX| $B04A
       .byte $FF ; |XXXXXXXX| $B04B
       .byte $FF ; |XXXXXXXX| $B04C
       .byte $FF ; |XXXXXXXX| $B04D
       .byte $FF ; |XXXXXXXX| $B04E
       .byte $FF ; |XXXXXXXX| $B04F
       .byte $FF ; |XXXXXXXX| $B050
       .byte $FF ; |XXXXXXXX| $B051
       .byte $FF ; |XXXXXXXX| $B052
       .byte $FF ; |XXXXXXXX| $B053
       .byte $FF ; |XXXXXXXX| $B054
       .byte $FF ; |XXXXXXXX| $B055
       .byte $FF ; |XXXXXXXX| $B056
       .byte $FF ; |XXXXXXXX| $B057
       .byte $FF ; |XXXXXXXX| $B058
       .byte $FF ; |XXXXXXXX| $B059
       .byte $FF ; |XXXXXXXX| $B05A
       .byte $FF ; |XXXXXXXX| $B05B
       .byte $FF ; |XXXXXXXX| $B05C
       .byte $FF ; |XXXXXXXX| $B05D
       .byte $FF ; |XXXXXXXX| $B05E
       .byte $FF ; |XXXXXXXX| $B05F
       .byte $FF ; |XXXXXXXX| $B060
       .byte $FF ; |XXXXXXXX| $B061
       .byte $FF ; |XXXXXXXX| $B062
       .byte $FF ; |XXXXXXXX| $B063
       .byte $FF ; |XXXXXXXX| $B064
       .byte $FF ; |XXXXXXXX| $B065
       .byte $FF ; |XXXXXXXX| $B066
       .byte $FF ; |XXXXXXXX| $B067
       .byte $FF ; |XXXXXXXX| $B068
       .byte $FF ; |XXXXXXXX| $B069
       .byte $FF ; |XXXXXXXX| $B06A
       .byte $FF ; |XXXXXXXX| $B06B
       .byte $FF ; |XXXXXXXX| $B06C
       .byte $FF ; |XXXXXXXX| $B06D
       .byte $FF ; |XXXXXXXX| $B06E
       .byte $FF ; |XXXXXXXX| $B06F
       .byte $FF ; |XXXXXXXX| $B070
       .byte $FF ; |XXXXXXXX| $B071
       .byte $FF ; |XXXXXXXX| $B072
       .byte $FF ; |XXXXXXXX| $B073
       .byte $FF ; |XXXXXXXX| $B074
       .byte $FF ; |XXXXXXXX| $B075
       .byte $FF ; |XXXXXXXX| $B076
       .byte $FF ; |XXXXXXXX| $B077
       .byte $FF ; |XXXXXXXX| $B078
       .byte $FF ; |XXXXXXXX| $B079
       .byte $FF ; |XXXXXXXX| $B07A
       .byte $FF ; |XXXXXXXX| $B07B
       .byte $FF ; |XXXXXXXX| $B07C
       .byte $FF ; |XXXXXXXX| $B07D
       .byte $FF ; |XXXXXXXX| $B07E
       .byte $FF ; |XXXXXXXX| $B07F
LB080: .byte $FF ; |XXXXXXXX| $B080
       .byte $FF ; |XXXXXXXX| $B081
       .byte $FF ; |XXXXXXXX| $B082
       .byte $FF ; |XXXXXXXX| $B083
       .byte $FF ; |XXXXXXXX| $B084
       .byte $FF ; |XXXXXXXX| $B085
       .byte $FF ; |XXXXXXXX| $B086
       .byte $FF ; |XXXXXXXX| $B087
       .byte $FF ; |XXXXXXXX| $B088
       .byte $FF ; |XXXXXXXX| $B089
       .byte $FF ; |XXXXXXXX| $B08A
       .byte $FF ; |XXXXXXXX| $B08B
       .byte $FF ; |XXXXXXXX| $B08C
       .byte $FF ; |XXXXXXXX| $B08D
       .byte $FF ; |XXXXXXXX| $B08E
       .byte $FF ; |XXXXXXXX| $B08F
       .byte $FF ; |XXXXXXXX| $B090
LB091: .byte $FF ; |XXXXXXXX| $B091
LB092: .byte $FF ; |XXXXXXXX| $B092
       .byte $FF ; |XXXXXXXX| $B093
       .byte $FF ; |XXXXXXXX| $B094
       .byte $FF ; |XXXXXXXX| $B095
       .byte $FF ; |XXXXXXXX| $B096
       .byte $FF ; |XXXXXXXX| $B097
       .byte $FF ; |XXXXXXXX| $B098
       .byte $FF ; |XXXXXXXX| $B099
       .byte $FF ; |XXXXXXXX| $B09A
       .byte $FF ; |XXXXXXXX| $B09B
       .byte $FF ; |XXXXXXXX| $B09C
       .byte $FF ; |XXXXXXXX| $B09D
       .byte $FF ; |XXXXXXXX| $B09E
       .byte $FF ; |XXXXXXXX| $B09F
       .byte $FF ; |XXXXXXXX| $B0A0
       .byte $FF ; |XXXXXXXX| $B0A1
       .byte $FF ; |XXXXXXXX| $B0A2
LB0A3: .byte $FF ; |XXXXXXXX| $B0A3
LB0A4: .byte $FF ; |XXXXXXXX| $B0A4
       .byte $FF ; |XXXXXXXX| $B0A5
       .byte $FF ; |XXXXXXXX| $B0A6
       .byte $FF ; |XXXXXXXX| $B0A7
       .byte $FF ; |XXXXXXXX| $B0A8
       .byte $FF ; |XXXXXXXX| $B0A9
       .byte $FF ; |XXXXXXXX| $B0AA
       .byte $FF ; |XXXXXXXX| $B0AB
       .byte $FF ; |XXXXXXXX| $B0AC
       .byte $FF ; |XXXXXXXX| $B0AD
       .byte $FF ; |XXXXXXXX| $B0AE
       .byte $FF ; |XXXXXXXX| $B0AF
       .byte $FF ; |XXXXXXXX| $B0B0
       .byte $FF ; |XXXXXXXX| $B0B1
       .byte $FF ; |XXXXXXXX| $B0B2
       .byte $FF ; |XXXXXXXX| $B0B3
       .byte $FF ; |XXXXXXXX| $B0B4
       .byte $FF ; |XXXXXXXX| $B0B5
LB0B6: .byte $FF ; |XXXXXXXX| $B0B6
       .byte $FF ; |XXXXXXXX| $B0B7
       .byte $FF ; |XXXXXXXX| $B0B8
       .byte $FF ; |XXXXXXXX| $B0B9
       .byte $FF ; |XXXXXXXX| $B0BA
       .byte $FF ; |XXXXXXXX| $B0BB
       .byte $FF ; |XXXXXXXX| $B0BC
       .byte $FF ; |XXXXXXXX| $B0BD
       .byte $FF ; |XXXXXXXX| $B0BE
       .byte $FF ; |XXXXXXXX| $B0BF
       .byte $FF ; |XXXXXXXX| $B0C0
       .byte $FF ; |XXXXXXXX| $B0C1
       .byte $FF ; |XXXXXXXX| $B0C2
       .byte $FF ; |XXXXXXXX| $B0C3
       .byte $FF ; |XXXXXXXX| $B0C4
       .byte $FF ; |XXXXXXXX| $B0C5
       .byte $FF ; |XXXXXXXX| $B0C6
LB0C7: .byte $FF ; |XXXXXXXX| $B0C7
       .byte $FF ; |XXXXXXXX| $B0C8
       .byte $FF ; |XXXXXXXX| $B0C9
       .byte $FF ; |XXXXXXXX| $B0CA
       .byte $FF ; |XXXXXXXX| $B0CB
       .byte $FF ; |XXXXXXXX| $B0CC
       .byte $FF ; |XXXXXXXX| $B0CD
       .byte $FF ; |XXXXXXXX| $B0CE
       .byte $FF ; |XXXXXXXX| $B0CF
       .byte $FF ; |XXXXXXXX| $B0D0
       .byte $FF ; |XXXXXXXX| $B0D1
       .byte $FF ; |XXXXXXXX| $B0D2
       .byte $FF ; |XXXXXXXX| $B0D3
       .byte $FF ; |XXXXXXXX| $B0D4
       .byte $FF ; |XXXXXXXX| $B0D5
       .byte $FF ; |XXXXXXXX| $B0D6
       .byte $FF ; |XXXXXXXX| $B0D7
       .byte $FF ; |XXXXXXXX| $B0D8
LB0D9: .byte $FF ; |XXXXXXXX| $B0D9
LB0DA: .byte $FF ; |XXXXXXXX| $B0DA
       .byte $FF ; |XXXXXXXX| $B0DB
       .byte $FF ; |XXXXXXXX| $B0DC
       .byte $FF ; |XXXXXXXX| $B0DD
       .byte $FF ; |XXXXXXXX| $B0DE
       .byte $FF ; |XXXXXXXX| $B0DF
       .byte $FF ; |XXXXXXXX| $B0E0
       .byte $FF ; |XXXXXXXX| $B0E1
       .byte $FF ; |XXXXXXXX| $B0E2
       .byte $FF ; |XXXXXXXX| $B0E3
       .byte $FF ; |XXXXXXXX| $B0E4
       .byte $FF ; |XXXXXXXX| $B0E5
       .byte $FF ; |XXXXXXXX| $B0E6
       .byte $FF ; |XXXXXXXX| $B0E7
       .byte $FF ; |XXXXXXXX| $B0E8
       .byte $FF ; |XXXXXXXX| $B0E9
       .byte $FF ; |XXXXXXXX| $B0EA
       .byte $FF ; |XXXXXXXX| $B0EB
LB0EC: .byte $FF ; |XXXXXXXX| $B0EC
       .byte $FF ; |XXXXXXXX| $B0ED
       .byte $FF ; |XXXXXXXX| $B0EE
       .byte $FF ; |XXXXXXXX| $B0EF
       .byte $FF ; |XXXXXXXX| $B0F0
       .byte $FF ; |XXXXXXXX| $B0F1
       .byte $FF ; |XXXXXXXX| $B0F2
       .byte $FF ; |XXXXXXXX| $B0F3
       .byte $FF ; |XXXXXXXX| $B0F4
       .byte $FF ; |XXXXXXXX| $B0F5
       .byte $FF ; |XXXXXXXX| $B0F6
       .byte $FF ; |XXXXXXXX| $B0F7
       .byte $FF ; |XXXXXXXX| $B0F8
       .byte $FF ; |XXXXXXXX| $B0F9
       .byte $FF ; |XXXXXXXX| $B0FA
       .byte $FF ; |XXXXXXXX| $B0FB
       .byte $FF ; |XXXXXXXX| $B0FC
       .byte $FF ; |XXXXXXXX| $B0FD
       .byte $FF ; |XXXXXXXX| $B0FE
       .byte $FF ; |XXXXXXXX| $B0FF
INIT2: .byte $00 ; |        | $B100
       .byte $00 ; |        | $B101
       .byte $00 ; |        | $B102
       .byte $00 ; |        | $B103
       .byte $00 ; |        | $B104
       .byte $00 ; |        | $B105
       .byte $00 ; |        | $B106
       .byte $00 ; |        | $B107
       .byte $00 ; |        | $B108
       .byte $00 ; |        | $B109
       .byte $00 ; |        | $B10A
       .byte $00 ; |        | $B10B
       .byte $00 ; |        | $B10C
       .byte $00 ; |        | $B10D
       .byte $00 ; |        | $B10E
       .byte $00 ; |        | $B10F
       .byte $00 ; |        | $B110
       .byte $00 ; |        | $B111
       .byte $00 ; |        | $B112
       .byte $00 ; |        | $B113
       .byte $00 ; |        | $B114
       .byte $00 ; |        | $B115
       .byte $00 ; |        | $B116
       .byte $00 ; |        | $B117
       .byte $00 ; |        | $B118
       .byte $00 ; |        | $B119
       .byte $44 ; | X   X  | $B11A
       .byte $EE ; |XXX XXX | $B11B
       .byte $EE ; |XXX XXX | $B11C
       .byte $AA ; |X X X X | $B11D
       .byte $AA ; |X X X X | $B11E
       .byte $EE ; |XXX XXX | $B11F
       .byte $44 ; | X   X  | $B120
       .byte $00 ; |        | $B121
       .byte $00 ; |        | $B122
       .byte $00 ; |        | $B123
       .byte $00 ; |        | $B124
       .byte $00 ; |        | $B125
       .byte $00 ; |        | $B126
       .byte $00 ; |        | $B127
       .byte $00 ; |        | $B128
       .byte $00 ; |        | $B129
       .byte $00 ; |        | $B12A
       .byte $00 ; |        | $B12B
       .byte $00 ; |        | $B12C
       .byte $00 ; |        | $B12D
       .byte $00 ; |        | $B12E
       .byte $00 ; |        | $B12F
       .byte $00 ; |        | $B130
       .byte $5E ; | X XXXX | $B131
       .byte $B3 ; |X XX  XX| $B132
       .byte $A1 ; |X X    X| $B133
       .byte $AD ; |X X XX X| $B134
       .byte $69 ; | XX X  X| $B135
       .byte $29 ; |  X X  X| $B136
       .byte $1B ; |   XX XX| $B137
       .byte $2E ; |  X XXX | $B138
       .byte $74 ; | XXX X  | $B139
       .byte $04 ; |     X  | $B13A
       .byte $0E ; |    XXX | $B13B
       .byte $3B ; |  XXX XX| $B13C
       .byte $00 ; |        | $B13D
       .byte $00 ; |        | $B13E
       .byte $00 ; |        | $B13F
       .byte $00 ; |        | $B140
       .byte $00 ; |        | $B141
       .byte $00 ; |        | $B142
       .byte $00 ; |        | $B143
       .byte $00 ; |        | $B144
       .byte $00 ; |        | $B145
       .byte $00 ; |        | $B146
       .byte $00 ; |        | $B147
       .byte $00 ; |        | $B148
       .byte $00 ; |        | $B149
       .byte $00 ; |        | $B14A
       .byte $7C ; | XXXXX  | $B14B
       .byte $7C ; | XXXXX  | $B14C
       .byte $56 ; | X X XX | $B14D
       .byte $55 ; | X X X X| $B14E
       .byte $55 ; | X X X X| $B14F
       .byte $F5 ; |XXXX X X| $B150
       .byte $D5 ; |XX X X X| $B151
       .byte $75 ; | XXX X X| $B152
       .byte $F7 ; |XXXX XXX| $B153
       .byte $FC ; |XXXXXX  | $B154
       .byte $7C ; | XXXXX  | $B155
       .byte $78 ; | XXXX   | $B156
       .byte $00 ; |        | $B157
       .byte $00 ; |        | $B158
       .byte $00 ; |        | $B159
       .byte $00 ; |        | $B15A
       .byte $00 ; |        | $B15B
       .byte $00 ; |        | $B15C
       .byte $00 ; |        | $B15D
       .byte $00 ; |        | $B15E
       .byte $00 ; |        | $B15F
       .byte $00 ; |        | $B160
       .byte $00 ; |        | $B161
       .byte $00 ; |        | $B162
       .byte $00 ; |        | $B163
       .byte $00 ; |        | $B164
       .byte $C0 ; |XX      | $B165
       .byte $A4 ; |X X  X  | $B166
       .byte $9A ; |X  XX X | $B167
       .byte $C2 ; |XX    X | $B168
       .byte $E3 ; |XXX   XX| $B169
       .byte $F0 ; |XXXX    | $B16A
       .byte $F8 ; |XXXXX   | $B16B
       .byte $FC ; |XXXXXX  | $B16C
       .byte $FC ; |XXXXXX  | $B16D
       .byte $78 ; | XXXX   | $B16E
       .byte $30 ; |  XX    | $B16F
       .byte $10 ; |   X    | $B170
       .byte $00 ; |        | $B171
       .byte $00 ; |        | $B172
       .byte $00 ; |        | $B173
       .byte $00 ; |        | $B174
       .byte $00 ; |        | $B175
       .byte $00 ; |        | $B176
       .byte $00 ; |        | $B177
       .byte $00 ; |        | $B178
       .byte $00 ; |        | $B179
       .byte $00 ; |        | $B17A
       .byte $00 ; |        | $B17B
       .byte $00 ; |        | $B17C
       .byte $00 ; |        | $B17D
       .byte $00 ; |        | $B17E
       .byte $36 ; |  XX XX | $B17F
       .byte $DB ; |XX XX XX| $B180
       .byte $7E ; | XXXXXX | $B181
       .byte $FE ; |XXXXXXX | $B182
       .byte $FF ; |XXXXXXXX| $B183
       .byte $FE ; |XXXXXXX | $B184
       .byte $FE ; |XXXXXXX | $B185
       .byte $E6 ; |XXX  XX | $B186
       .byte $A6 ; |X X  XX | $B187
       .byte $AF ; |X X XXXX| $B188
       .byte $A6 ; |X X  XX | $B189
       .byte $F0 ; |XXXX    | $B18A
       .byte $00 ; |        | $B18B
       .byte $00 ; |        | $B18C
       .byte $00 ; |        | $B18D
       .byte $00 ; |        | $B18E
       .byte $00 ; |        | $B18F
       .byte $00 ; |        | $B190
       .byte $00 ; |        | $B191
       .byte $00 ; |        | $B192
       .byte $00 ; |        | $B193
       .byte $00 ; |        | $B194
       .byte $00 ; |        | $B195
       .byte $00 ; |        | $B196
       .byte $00 ; |        | $B197
       .byte $00 ; |        | $B198
       .byte $42 ; | X    X | $B199
       .byte $A0 ; |X X     | $B19A
       .byte $92 ; |X  X  X | $B19B
       .byte $8C ; |X   XX  | $B19C
       .byte $80 ; |X       | $B19D
       .byte $40 ; | X      | $B19E
       .byte $70 ; | XXX    | $B19F
       .byte $F8 ; |XXXXX   | $B1A0
       .byte $F8 ; |XXXXX   | $B1A1
       .byte $F8 ; |XXXXX   | $B1A2
       .byte $F8 ; |XXXXX   | $B1A3
       .byte $70 ; | XXX    | $B1A4
       .byte $00 ; |        | $B1A5
       .byte $00 ; |        | $B1A6
       .byte $00 ; |        | $B1A7
       .byte $00 ; |        | $B1A8
       .byte $00 ; |        | $B1A9
       .byte $00 ; |        | $B1AA
       .byte $00 ; |        | $B1AB
       .byte $00 ; |        | $B1AC
       .byte $00 ; |        | $B1AD
       .byte $00 ; |        | $B1AE
       .byte $00 ; |        | $B1AF
       .byte $00 ; |        | $B1B0
       .byte $00 ; |        | $B1B1
       .byte $00 ; |        | $B1B2
       .byte $CC ; |XX  XX  | $B1B3
       .byte $B3 ; |X XX  XX| $B1B4
       .byte $AA ; |X X X X | $B1B5
       .byte $BA ; |X XXX X | $B1B6
       .byte $FE ; |XXXXXXX | $B1B7
       .byte $FE ; |XXXXXXX | $B1B8
       .byte $FE ; |XXXXXXX | $B1B9
       .byte $CE ; |XX  XXX | $B1BA
       .byte $87 ; |X    XXX| $B1BB
       .byte $C7 ; |XX   XXX| $B1BC
       .byte $27 ; |  X  XXX| $B1BD
       .byte $25 ; |  X  X X| $B1BE
       .byte $00 ; |        | $B1BF
       .byte $00 ; |        | $B1C0
       .byte $00 ; |        | $B1C1
       .byte $00 ; |        | $B1C2
       .byte $00 ; |        | $B1C3
       .byte $00 ; |        | $B1C4
       .byte $00 ; |        | $B1C5
       .byte $00 ; |        | $B1C6
       .byte $00 ; |        | $B1C7
       .byte $00 ; |        | $B1C8
       .byte $00 ; |        | $B1C9
       .byte $00 ; |        | $B1CA
       .byte $00 ; |        | $B1CB
       .byte $00 ; |        | $B1CC
       .byte $7C ; | XXXXX  | $B1CD
       .byte $EE ; |XXX XXX | $B1CE
       .byte $AB ; |X X X XX| $B1CF
       .byte $AB ; |X X X XX| $B1D0
       .byte $AB ; |X X X XX| $B1D1
       .byte $AB ; |X X X XX| $B1D2
       .byte $BB ; |X XXX XX| $B1D3
       .byte $FF ; |XXXXXXXX| $B1D4
       .byte $D7 ; |XX X XXX| $B1D5
       .byte $BB ; |X XXX XX| $B1D6
       .byte $7C ; | XXXXX  | $B1D7
       .byte $81 ; |X      X| $B1D8
       .byte $00 ; |        | $B1D9
       .byte $00 ; |        | $B1DA
       .byte $00 ; |        | $B1DB
       .byte $00 ; |        | $B1DC
       .byte $00 ; |        | $B1DD
       .byte $00 ; |        | $B1DE
       .byte $00 ; |        | $B1DF
       .byte $00 ; |        | $B1E0
       .byte $00 ; |        | $B1E1
       .byte $00 ; |        | $B1E2
       .byte $00 ; |        | $B1E3
       .byte $00 ; |        | $B1E4
       .byte $00 ; |        | $B1E5
       .byte $00 ; |        | $B1E6
       .byte $00 ; |        | $B1E7
       .byte $00 ; |        | $B1E8
       .byte $00 ; |        | $B1E9
       .byte $44 ; | X   X  | $B1EA
       .byte $EE ; |XXX XXX | $B1EB
       .byte $AA ; |X X X X | $B1EC
       .byte $AA ; |X X X X | $B1ED
       .byte $EE ; |XXX XXX | $B1EE
       .byte $EE ; |XXX XXX | $B1EF
       .byte $44 ; | X   X  | $B1F0
       .byte $00 ; |        | $B1F1
       .byte $00 ; |        | $B1F2
       .byte $00 ; |        | $B1F3
       .byte $00 ; |        | $B1F4
       .byte $00 ; |        | $B1F5
       .byte $00 ; |        | $B1F6
       .byte $00 ; |        | $B1F7
       .byte $00 ; |        | $B1F8
       .byte $00 ; |        | $B1F9
       .byte $00 ; |        | $B1FA
       .byte $00 ; |        | $B1FB
       .byte $00 ; |        | $B1FC
       .byte $00 ; |        | $B1FD
       .byte $00 ; |        | $B1FE
       .byte $00 ; |        | $B1FF
       .byte $00 ; |        | $B200
       .byte $00 ; |        | $B201
       .byte $00 ; |        | $B202
       .byte $00 ; |        | $B203
       .byte $00 ; |        | $B204
       .byte $00 ; |        | $B205
       .byte $00 ; |        | $B206
       .byte $00 ; |        | $B207
       .byte $00 ; |        | $B208
       .byte $00 ; |        | $B209
       .byte $00 ; |        | $B20A
       .byte $00 ; |        | $B20B
       .byte $00 ; |        | $B20C
       .byte $00 ; |        | $B20D
       .byte $00 ; |        | $B20E
       .byte $00 ; |        | $B20F
       .byte $00 ; |        | $B210
       .byte $00 ; |        | $B211
       .byte $00 ; |        | $B212
       .byte $00 ; |        | $B213
       .byte $00 ; |        | $B214
       .byte $00 ; |        | $B215
       .byte $00 ; |        | $B216
       .byte $28 ; |  X X   | $B217
       .byte $5A ; | X XX X | $B218
       .byte $4F ; | X  XXXX| $B219
       .byte $3E ; |  XXXXX | $B21A
       .byte $27 ; |  X  XXX| $B21B
       .byte $7A ; | XXXX X | $B21C
       .byte $5E ; | X XXXX | $B21D
       .byte $69 ; | XX X  X| $B21E
       .byte $2E ; |  X XXX | $B21F
       .byte $1C ; |   XXX  | $B220
       .byte $00 ; |        | $B221
       .byte $00 ; |        | $B222
       .byte $00 ; |        | $B223
       .byte $00 ; |        | $B224
       .byte $00 ; |        | $B225
       .byte $00 ; |        | $B226
       .byte $00 ; |        | $B227
       .byte $00 ; |        | $B228
       .byte $00 ; |        | $B229
       .byte $00 ; |        | $B22A
       .byte $00 ; |        | $B22B
       .byte $00 ; |        | $B22C
       .byte $00 ; |        | $B22D
       .byte $00 ; |        | $B22E
       .byte $00 ; |        | $B22F
       .byte $10 ; |   X    | $B230
       .byte $10 ; |   X    | $B231
       .byte $10 ; |   X    | $B232
       .byte $92 ; |X  X  X | $B233
       .byte $44 ; | X   X  | $B234
       .byte $00 ; |        | $B235
       .byte $83 ; |X     XX| $B236
       .byte $7C ; | XXXXX  | $B237
       .byte $7C ; | XXXXX  | $B238
       .byte $38 ; |  XXX   | $B239
       .byte $10 ; |   X    | $B23A
       .byte $10 ; |   X    | $B23B
       .byte $EE ; |XXX XXX | $B23C
       .byte $44 ; | X   X  | $B23D
       .byte $00 ; |        | $B23E
       .byte $00 ; |        | $B23F
       .byte $00 ; |        | $B240
       .byte $00 ; |        | $B241
       .byte $00 ; |        | $B242
       .byte $00 ; |        | $B243
       .byte $00 ; |        | $B244
       .byte $00 ; |        | $B245
       .byte $00 ; |        | $B246
       .byte $00 ; |        | $B247
       .byte $00 ; |        | $B248
       .byte $00 ; |        | $B249
       .byte $00 ; |        | $B24A
       .byte $00 ; |        | $B24B
       .byte $00 ; |        | $B24C
       .byte $00 ; |        | $B24D
       .byte $04 ; |     X  | $B24E
       .byte $0C ; |    XX  | $B24F
       .byte $1C ; |   XXX  | $B250
       .byte $39 ; |  XXX  X| $B251
       .byte $7B ; | XXXX XX| $B252
       .byte $0F ; |    XXXX| $B253
       .byte $08 ; |    X   | $B254
       .byte $18 ; |   XX   | $B255
       .byte $38 ; |  XXX   | $B256
       .byte $00 ; |        | $B257
       .byte $00 ; |        | $B258
       .byte $00 ; |        | $B259
       .byte $00 ; |        | $B25A
       .byte $00 ; |        | $B25B
       .byte $00 ; |        | $B25C
       .byte $00 ; |        | $B25D
       .byte $00 ; |        | $B25E
       .byte $00 ; |        | $B25F
       .byte $00 ; |        | $B260
       .byte $00 ; |        | $B261
       .byte $00 ; |        | $B262
       .byte $00 ; |        | $B263
       .byte $34 ; |  XX X  | $B264
       .byte $7D ; | XXXXX X| $B265
       .byte $6F ; | XX XXXX| $B266
       .byte $42 ; | X    X | $B267
       .byte $C2 ; |XX    X | $B268
       .byte $81 ; |X      X| $B269
       .byte $49 ; | X  X  X| $B26A
       .byte $C3 ; |XX    XX| $B26B
       .byte $A3 ; |X X   XX| $B26C
       .byte $67 ; | XX  XXX| $B26D
       .byte $36 ; |  XX XX | $B26E
       .byte $6D ; | XX XX X| $B26F
       .byte $1A ; |   XX X | $B270
       .byte $00 ; |        | $B271
       .byte $00 ; |        | $B272
       .byte $00 ; |        | $B273
       .byte $00 ; |        | $B274
       .byte $00 ; |        | $B275
       .byte $00 ; |        | $B276
       .byte $00 ; |        | $B277
       .byte $00 ; |        | $B278
       .byte $00 ; |        | $B279
       .byte $00 ; |        | $B27A
       .byte $00 ; |        | $B27B
       .byte $00 ; |        | $B27C
       .byte $00 ; |        | $B27D
       .byte $3E ; |  XXXXX | $B27E
       .byte $3E ; |  XXXXX | $B27F
       .byte $1C ; |   XXX  | $B280
       .byte $08 ; |    X   | $B281
       .byte $08 ; |    X   | $B282
       .byte $77 ; | XXX XXX| $B283
       .byte $22 ; |  X   X | $B284
       .byte $00 ; |        | $B285
       .byte $00 ; |        | $B286
       .byte $00 ; |        | $B287
       .byte $00 ; |        | $B288
       .byte $00 ; |        | $B289
       .byte $00 ; |        | $B28A
       .byte $00 ; |        | $B28B
       .byte $00 ; |        | $B28C
       .byte $00 ; |        | $B28D
       .byte $00 ; |        | $B28E
       .byte $00 ; |        | $B28F
       .byte $00 ; |        | $B290
       .byte $00 ; |        | $B291
       .byte $00 ; |        | $B292
       .byte $00 ; |        | $B293
       .byte $00 ; |        | $B294
       .byte $00 ; |        | $B295
       .byte $00 ; |        | $B296
       .byte $00 ; |        | $B297
       .byte $1C ; |   XXX  | $B298
       .byte $38 ; |  XXX   | $B299
       .byte $30 ; |  XX    | $B29A
       .byte $30 ; |  XX    | $B29B
       .byte $38 ; |  XXX   | $B29C
       .byte $5C ; | X XXX  | $B29D
       .byte $6A ; | XX X X | $B29E
       .byte $36 ; |  XX XX | $B29F
       .byte $B8 ; |X XXX   | $B2A0
       .byte $FC ; |XXXXXX  | $B2A1
       .byte $E0 ; |XXX     | $B2A2
       .byte $30 ; |  XX    | $B2A3
       .byte $38 ; |  XXX   | $B2A4
       .byte $00 ; |        | $B2A5
       .byte $00 ; |        | $B2A6
       .byte $00 ; |        | $B2A7
       .byte $00 ; |        | $B2A8
       .byte $00 ; |        | $B2A9
       .byte $00 ; |        | $B2AA
       .byte $00 ; |        | $B2AB
       .byte $00 ; |        | $B2AC
       .byte $00 ; |        | $B2AD
       .byte $00 ; |        | $B2AE
       .byte $00 ; |        | $B2AF
       .byte $00 ; |        | $B2B0
       .byte $00 ; |        | $B2B1
       .byte $1C ; |   XXX  | $B2B2
       .byte $38 ; |  XXX   | $B2B3
       .byte $30 ; |  XX    | $B2B4
       .byte $30 ; |  XX    | $B2B5
       .byte $58 ; | X XX   | $B2B6
       .byte $64 ; | XX  X  | $B2B7
       .byte $34 ; |  XX X  | $B2B8
       .byte $B8 ; |X XXX   | $B2B9
       .byte $FC ; |XXXXXX  | $B2BA
       .byte $E0 ; |XXX     | $B2BB
       .byte $30 ; |  XX    | $B2BC
       .byte $38 ; |  XXX   | $B2BD
       .byte $00 ; |        | $B2BE
       .byte $00 ; |        | $B2BF
       .byte $00 ; |        | $B2C0
       .byte $00 ; |        | $B2C1
       .byte $00 ; |        | $B2C2
       .byte $00 ; |        | $B2C3
       .byte $00 ; |        | $B2C4
       .byte $00 ; |        | $B2C5
       .byte $00 ; |        | $B2C6
       .byte $00 ; |        | $B2C7
       .byte $00 ; |        | $B2C8
       .byte $00 ; |        | $B2C9
       .byte $00 ; |        | $B2CA
       .byte $00 ; |        | $B2CB
       .byte $1C ; |   XXX  | $B2CC
       .byte $3E ; |  XXXXX | $B2CD
       .byte $3F ; |  XXXXXX| $B2CE
       .byte $7F ; | XXXXXXX| $B2CF
       .byte $7F ; | XXXXXXX| $B2D0
       .byte $3F ; |  XXXXXX| $B2D1
       .byte $5B ; | X XX XX| $B2D2
       .byte $6B ; | XX X XX| $B2D3
       .byte $37 ; |  XX XXX| $B2D4
       .byte $3A ; |  XXX X | $B2D5
       .byte $3C ; |  XXXX  | $B2D6
       .byte $20 ; |  X     | $B2D7
       .byte $00 ; |        | $B2D8
       .byte $00 ; |        | $B2D9
       .byte $00 ; |        | $B2DA
       .byte $00 ; |        | $B2DB
       .byte $00 ; |        | $B2DC
       .byte $00 ; |        | $B2DD
       .byte $00 ; |        | $B2DE
       .byte $00 ; |        | $B2DF
       .byte $00 ; |        | $B2E0
       .byte $00 ; |        | $B2E1
       .byte $00 ; |        | $B2E2
       .byte $00 ; |        | $B2E3
       .byte $00 ; |        | $B2E4
       .byte $00 ; |        | $B2E5
       .byte $1E ; |   XXXX | $B2E6
       .byte $3E ; |  XXXXX | $B2E7
       .byte $3E ; |  XXXXX | $B2E8
       .byte $7C ; | XXXXX  | $B2E9
       .byte $70 ; | XXX    | $B2EA
       .byte $3C ; |  XXXX  | $B2EB
       .byte $5A ; | X XX X | $B2EC
       .byte $6B ; | XX X XX| $B2ED
       .byte $37 ; |  XX XXX| $B2EE
       .byte $3A ; |  XXX X | $B2EF
       .byte $7C ; | XXXXX  | $B2F0
       .byte $20 ; |  X     | $B2F1
       .byte $10 ; |   X    | $B2F2
       .byte $00 ; |        | $B2F3
       .byte $00 ; |        | $B2F4
       .byte $00 ; |        | $B2F5
       .byte $00 ; |        | $B2F6
       .byte $00 ; |        | $B2F7
       .byte $00 ; |        | $B2F8
       .byte $00 ; |        | $B2F9
       .byte $00 ; |        | $B2FA
       .byte $00 ; |        | $B2FB
       .byte $00 ; |        | $B2FC
       .byte $00 ; |        | $B2FD
       .byte $00 ; |        | $B2FE
       .byte $00 ; |        | $B2FF
       .byte $00 ; |        | $B300
       .byte $00 ; |        | $B301
       .byte $00 ; |        | $B302
       .byte $00 ; |        | $B303
       .byte $00 ; |        | $B304
       .byte $00 ; |        | $B305
       .byte $00 ; |        | $B306
       .byte $00 ; |        | $B307
       .byte $00 ; |        | $B308
       .byte $00 ; |        | $B309
       .byte $00 ; |        | $B30A
       .byte $00 ; |        | $B30B
       .byte $00 ; |        | $B30C
       .byte $00 ; |        | $B30D
       .byte $00 ; |        | $B30E
       .byte $00 ; |        | $B30F
       .byte $00 ; |        | $B310
       .byte $00 ; |        | $B311
       .byte $00 ; |        | $B312
       .byte $00 ; |        | $B313
       .byte $00 ; |        | $B314
       .byte $00 ; |        | $B315
       .byte $1E ; |   XXXX | $B316
       .byte $3C ; |  XXXX  | $B317
       .byte $38 ; |  XXX   | $B318
       .byte $70 ; | XXX    | $B319
       .byte $70 ; | XXX    | $B31A
       .byte $38 ; |  XXX   | $B31B
       .byte $5C ; | X XXX  | $B31C
       .byte $6A ; | XX X X | $B31D
       .byte $37 ; |  XX XXX| $B31E
       .byte $BA ; |X XXX X | $B31F
       .byte $FC ; |XXXXXX  | $B320
       .byte $20 ; |  X     | $B321
       .byte $10 ; |   X    | $B322
       .byte $18 ; |   XX   | $B323
       .byte $00 ; |        | $B324
       .byte $00 ; |        | $B325
       .byte $00 ; |        | $B326
       .byte $00 ; |        | $B327
       .byte $00 ; |        | $B328
       .byte $00 ; |        | $B329
       .byte $00 ; |        | $B32A
       .byte $00 ; |        | $B32B
       .byte $00 ; |        | $B32C
       .byte $00 ; |        | $B32D
       .byte $00 ; |        | $B32E
       .byte $00 ; |        | $B32F
       .byte $38 ; |  XXX   | $B330
       .byte $7C ; | XXXXX  | $B331
       .byte $FC ; |XXXXXX  | $B332
       .byte $FE ; |XXXXXXX | $B333
       .byte $FE ; |XXXXXXX | $B334
       .byte $FC ; |XXXXXX  | $B335
       .byte $DA ; |XX XX X | $B336
       .byte $D6 ; |XX X XX | $B337
       .byte $EC ; |XXX XX  | $B338
       .byte $5C ; | X XXX  | $B339
       .byte $3C ; |  XXXX  | $B33A
       .byte $04 ; |     X  | $B33B
       .byte $00 ; |        | $B33C
       .byte $00 ; |        | $B33D
       .byte $00 ; |        | $B33E
       .byte $00 ; |        | $B33F
       .byte $00 ; |        | $B340
       .byte $00 ; |        | $B341
       .byte $00 ; |        | $B342
       .byte $00 ; |        | $B343
       .byte $00 ; |        | $B344
       .byte $00 ; |        | $B345
       .byte $00 ; |        | $B346
       .byte $00 ; |        | $B347
       .byte $00 ; |        | $B348
       .byte $00 ; |        | $B349
       .byte $78 ; | XXXX   | $B34A
       .byte $FC ; |XXXXXX  | $B34B
       .byte $7C ; | XXXXX  | $B34C
       .byte $3E ; |  XXXXX | $B34D
       .byte $0E ; |    XXX | $B34E
       .byte $3C ; |  XXXX  | $B34F
       .byte $5A ; | X XX X | $B350
       .byte $D6 ; |XX X XX | $B351
       .byte $EC ; |XXX XX  | $B352
       .byte $5C ; | X XXX  | $B353
       .byte $3E ; |  XXXXX | $B354
       .byte $04 ; |     X  | $B355
       .byte $08 ; |    X   | $B356
       .byte $00 ; |        | $B357
       .byte $00 ; |        | $B358
       .byte $00 ; |        | $B359
       .byte $00 ; |        | $B35A
       .byte $00 ; |        | $B35B
       .byte $00 ; |        | $B35C
       .byte $00 ; |        | $B35D
       .byte $00 ; |        | $B35E
       .byte $00 ; |        | $B35F
       .byte $00 ; |        | $B360
       .byte $00 ; |        | $B361
       .byte $00 ; |        | $B362
       .byte $00 ; |        | $B363
       .byte $78 ; | XXXX   | $B364
       .byte $3C ; |  XXXX  | $B365
       .byte $1C ; |   XXX  | $B366
       .byte $0E ; |    XXX | $B367
       .byte $0E ; |    XXX | $B368
       .byte $1C ; |   XXX  | $B369
       .byte $3A ; |  XXX X | $B36A
       .byte $56 ; | X X XX | $B36B
       .byte $EC ; |XXX XX  | $B36C
       .byte $5D ; | X XXX X| $B36D
       .byte $3F ; |  XXXXXX| $B36E
       .byte $04 ; |     X  | $B36F
       .byte $08 ; |    X   | $B370
       .byte $18 ; |   XX   | $B371
       .byte $00 ; |        | $B372
       .byte $00 ; |        | $B373
       .byte $00 ; |        | $B374
       .byte $00 ; |        | $B375
       .byte $00 ; |        | $B376
       .byte $00 ; |        | $B377
       .byte $00 ; |        | $B378
       .byte $00 ; |        | $B379
       .byte $00 ; |        | $B37A
       .byte $00 ; |        | $B37B
       .byte $00 ; |        | $B37C
       .byte $00 ; |        | $B37D
       .byte $38 ; |  XXX   | $B37E
       .byte $7C ; | XXXXX  | $B37F
       .byte $7E ; | XXXXXX | $B380
       .byte $FE ; |XXXXXXX | $B381
       .byte $FA ; |XXXXX X | $B382
       .byte $FC ; |XXXXXX  | $B383
       .byte $FA ; |XXXXX X | $B384
       .byte $F6 ; |XXXX XX | $B385
       .byte $6C ; | XX XX  | $B386
       .byte $1D ; |   XXX X| $B387
       .byte $3F ; |  XXXXXX| $B388
       .byte $04 ; |     X  | $B389
       .byte $08 ; |    X   | $B38A
       .byte $18 ; |   XX   | $B38B
       .byte $00 ; |        | $B38C
       .byte $00 ; |        | $B38D
       .byte $00 ; |        | $B38E
       .byte $00 ; |        | $B38F
       .byte $00 ; |        | $B390
       .byte $00 ; |        | $B391
       .byte $00 ; |        | $B392
       .byte $00 ; |        | $B393
       .byte $00 ; |        | $B394
       .byte $00 ; |        | $B395
       .byte $00 ; |        | $B396
       .byte $00 ; |        | $B397
       .byte $00 ; |        | $B398
       .byte $44 ; | X   X  | $B399
       .byte $C4 ; |XX   X  | $B39A
       .byte $CE ; |XX  XXX | $B39B
       .byte $EA ; |XXX X X | $B39C
       .byte $EC ; |XXX XX  | $B39D
       .byte $FA ; |XXXXX X | $B39E
       .byte $F6 ; |XXXX XX | $B39F
       .byte $6C ; | XX XX  | $B3A0
       .byte $1C ; |   XXX  | $B3A1
       .byte $3E ; |  XXXXX | $B3A2
       .byte $04 ; |     X  | $B3A3
       .byte $08 ; |    X   | $B3A4
       .byte $00 ; |        | $B3A5
       .byte $00 ; |        | $B3A6
       .byte $00 ; |        | $B3A7
       .byte $00 ; |        | $B3A8
       .byte $00 ; |        | $B3A9
       .byte $00 ; |        | $B3AA
       .byte $00 ; |        | $B3AB
       .byte $00 ; |        | $B3AC
       .byte $00 ; |        | $B3AD
       .byte $00 ; |        | $B3AE
       .byte $00 ; |        | $B3AF
       .byte $00 ; |        | $B3B0
       .byte $00 ; |        | $B3B1
       .byte $00 ; |        | $B3B2
       .byte $00 ; |        | $B3B3
       .byte $82 ; |X     X | $B3B4
       .byte $86 ; |X    XX | $B3B5
       .byte $C2 ; |XX    X | $B3B6
       .byte $EC ; |XXX XX  | $B3B7
       .byte $FA ; |XXXXX X | $B3B8
       .byte $F6 ; |XXXX XX | $B3B9
       .byte $6C ; | XX XX  | $B3BA
       .byte $1C ; |   XXX  | $B3BB
       .byte $3C ; |  XXXX  | $B3BC
       .byte $04 ; |     X  | $B3BD
       .byte $00 ; |        | $B3BE
       .byte $00 ; |        | $B3BF
       .byte $00 ; |        | $B3C0
       .byte $00 ; |        | $B3C1
       .byte $00 ; |        | $B3C2
       .byte $00 ; |        | $B3C3
       .byte $00 ; |        | $B3C4
       .byte $00 ; |        | $B3C5
       .byte $00 ; |        | $B3C6
       .byte $00 ; |        | $B3C7
       .byte $00 ; |        | $B3C8
       .byte $00 ; |        | $B3C9
       .byte $00 ; |        | $B3CA
       .byte $00 ; |        | $B3CB
       .byte $18 ; |   XX   | $B3CC
       .byte $08 ; |    X   | $B3CD
       .byte $04 ; |     X  | $B3CE
       .byte $3F ; |  XXXXXX| $B3CF
       .byte $1D ; |   XXX X| $B3D0
       .byte $6C ; | XX XX  | $B3D1
       .byte $F6 ; |XXXX XX | $B3D2
       .byte $FA ; |XXXXX X | $B3D3
       .byte $FC ; |XXXXXX  | $B3D4
       .byte $FA ; |XXXXX X | $B3D5
       .byte $FE ; |XXXXXXX | $B3D6
       .byte $7E ; | XXXXXX | $B3D7
       .byte $7C ; | XXXXX  | $B3D8
       .byte $38 ; |  XXX   | $B3D9
       .byte $00 ; |        | $B3DA
       .byte $00 ; |        | $B3DB
       .byte $00 ; |        | $B3DC
       .byte $00 ; |        | $B3DD
       .byte $00 ; |        | $B3DE
       .byte $00 ; |        | $B3DF
       .byte $00 ; |        | $B3E0
       .byte $00 ; |        | $B3E1
       .byte $00 ; |        | $B3E2
       .byte $00 ; |        | $B3E3
       .byte $00 ; |        | $B3E4
       .byte $00 ; |        | $B3E5
       .byte $00 ; |        | $B3E6
       .byte $08 ; |    X   | $B3E7
       .byte $04 ; |     X  | $B3E8
       .byte $3E ; |  XXXXX | $B3E9
       .byte $1C ; |   XXX  | $B3EA
       .byte $6C ; | XX XX  | $B3EB
       .byte $F6 ; |XXXX XX | $B3EC
       .byte $FA ; |XXXXX X | $B3ED
       .byte $EC ; |XXX XX  | $B3EE
       .byte $EA ; |XXX X X | $B3EF
       .byte $CE ; |XX  XXX | $B3F0
       .byte $C4 ; |XX   X  | $B3F1
       .byte $44 ; | X   X  | $B3F2
       .byte $00 ; |        | $B3F3
       .byte $00 ; |        | $B3F4
       .byte $00 ; |        | $B3F5
       .byte $00 ; |        | $B3F6
       .byte $00 ; |        | $B3F7
       .byte $00 ; |        | $B3F8
       .byte $00 ; |        | $B3F9
       .byte $00 ; |        | $B3FA
       .byte $00 ; |        | $B3FB
       .byte $00 ; |        | $B3FC
       .byte $00 ; |        | $B3FD
       .byte $00 ; |        | $B3FE
       .byte $00 ; |        | $B3FF
       .byte $00 ; |        | $B400
       .byte $00 ; |        | $B401
       .byte $00 ; |        | $B402
       .byte $00 ; |        | $B403
       .byte $00 ; |        | $B404
       .byte $00 ; |        | $B405
       .byte $00 ; |        | $B406
       .byte $00 ; |        | $B407
       .byte $00 ; |        | $B408
       .byte $00 ; |        | $B409
       .byte $00 ; |        | $B40A
       .byte $00 ; |        | $B40B
       .byte $00 ; |        | $B40C
       .byte $00 ; |        | $B40D
       .byte $00 ; |        | $B40E
       .byte $00 ; |        | $B40F
       .byte $00 ; |        | $B410
       .byte $00 ; |        | $B411
       .byte $00 ; |        | $B412
       .byte $00 ; |        | $B413
       .byte $00 ; |        | $B414
       .byte $00 ; |        | $B415
       .byte $00 ; |        | $B416
       .byte $00 ; |        | $B417
       .byte $04 ; |     X  | $B418
       .byte $3C ; |  XXXX  | $B419
       .byte $1C ; |   XXX  | $B41A
       .byte $6C ; | XX XX  | $B41B
       .byte $F6 ; |XXXX XX | $B41C
       .byte $FA ; |XXXXX X | $B41D
       .byte $EC ; |XXX XX  | $B41E
       .byte $C2 ; |XX    X | $B41F
       .byte $86 ; |X    XX | $B420
       .byte $82 ; |X     X | $B421
       .byte $00 ; |        | $B422
       .byte $00 ; |        | $B423
       .byte $00 ; |        | $B424
       .byte $00 ; |        | $B425
       .byte $00 ; |        | $B426
       .byte $00 ; |        | $B427
       .byte $00 ; |        | $B428
       .byte $00 ; |        | $B429
       .byte $00 ; |        | $B42A
       .byte $00 ; |        | $B42B
       .byte $00 ; |        | $B42C
       .byte $00 ; |        | $B42D
       .byte $00 ; |        | $B42E
       .byte $00 ; |        | $B42F
       .byte $00 ; |        | $B430
       .byte $88 ; |X   X   | $B431
       .byte $DD ; |XX XXX X| $B432
       .byte $FF ; |XXXXXXXX| $B433
       .byte $FF ; |XXXXXXXX| $B434
       .byte $FF ; |XXXXXXXX| $B435
       .byte $FF ; |XXXXXXXX| $B436
       .byte $93 ; |X  X  XX| $B437
       .byte $DB ; |XX XX XX| $B438
       .byte $93 ; |X  X  XX| $B439
       .byte $FF ; |XXXXXXXX| $B43A
       .byte $7E ; | XXXXXX | $B43B
       .byte $3C ; |  XXXX  | $B43C
       .byte $00 ; |        | $B43D
       .byte $00 ; |        | $B43E
       .byte $00 ; |        | $B43F
       .byte $00 ; |        | $B440
       .byte $00 ; |        | $B441
       .byte $00 ; |        | $B442
       .byte $00 ; |        | $B443
       .byte $00 ; |        | $B444
       .byte $00 ; |        | $B445
       .byte $00 ; |        | $B446
       .byte $00 ; |        | $B447
       .byte $00 ; |        | $B448
       .byte $00 ; |        | $B449
       .byte $00 ; |        | $B44A
       .byte $11 ; |   X   X| $B44B
       .byte $BB ; |X XXX XX| $B44C
       .byte $FF ; |XXXXXXXX| $B44D
       .byte $FF ; |XXXXXXXX| $B44E
       .byte $FF ; |XXXXXXXX| $B44F
       .byte $FF ; |XXXXXXXX| $B450
       .byte $93 ; |X  X  XX| $B451
       .byte $DB ; |XX XX XX| $B452
       .byte $93 ; |X  X  XX| $B453
       .byte $FF ; |XXXXXXXX| $B454
       .byte $7E ; | XXXXXX | $B455
       .byte $3C ; |  XXXX  | $B456
       .byte $00 ; |        | $B457
       .byte $00 ; |        | $B458
       .byte $00 ; |        | $B459
       .byte $00 ; |        | $B45A
       .byte $00 ; |        | $B45B
       .byte $00 ; |        | $B45C
       .byte $00 ; |        | $B45D
       .byte $00 ; |        | $B45E
       .byte $00 ; |        | $B45F
       .byte $00 ; |        | $B460
       .byte $00 ; |        | $B461
       .byte $00 ; |        | $B462
       .byte $00 ; |        | $B463
       .byte $00 ; |        | $B464
       .byte $11 ; |   X   X| $B465
       .byte $BB ; |X XXX XX| $B466
       .byte $FF ; |XXXXXXXX| $B467
       .byte $FF ; |XXXXXXXX| $B468
       .byte $FF ; |XXXXXXXX| $B469
       .byte $FF ; |XXXXXXXX| $B46A
       .byte $C9 ; |XX  X  X| $B46B
       .byte $DB ; |XX XX XX| $B46C
       .byte $C9 ; |XX  X  X| $B46D
       .byte $FF ; |XXXXXXXX| $B46E
       .byte $7E ; | XXXXXX | $B46F
       .byte $3C ; |  XXXX  | $B470
       .byte $00 ; |        | $B471
       .byte $00 ; |        | $B472
       .byte $00 ; |        | $B473
       .byte $00 ; |        | $B474
       .byte $00 ; |        | $B475
       .byte $00 ; |        | $B476
       .byte $00 ; |        | $B477
       .byte $00 ; |        | $B478
       .byte $00 ; |        | $B479
       .byte $00 ; |        | $B47A
       .byte $00 ; |        | $B47B
       .byte $00 ; |        | $B47C
       .byte $00 ; |        | $B47D
       .byte $00 ; |        | $B47E
       .byte $88 ; |X   X   | $B47F
       .byte $DD ; |XX XXX X| $B480
       .byte $FF ; |XXXXXXXX| $B481
       .byte $FF ; |XXXXXXXX| $B482
       .byte $FF ; |XXXXXXXX| $B483
       .byte $FF ; |XXXXXXXX| $B484
       .byte $C9 ; |XX  X  X| $B485
       .byte $DB ; |XX XX XX| $B486
       .byte $C9 ; |XX  X  X| $B487
       .byte $FF ; |XXXXXXXX| $B488
       .byte $7E ; | XXXXXX | $B489
       .byte $3C ; |  XXXX  | $B48A
       .byte $00 ; |        | $B48B
       .byte $00 ; |        | $B48C
       .byte $00 ; |        | $B48D
       .byte $00 ; |        | $B48E
       .byte $00 ; |        | $B48F
       .byte $00 ; |        | $B490
       .byte $00 ; |        | $B491
       .byte $00 ; |        | $B492
       .byte $00 ; |        | $B493
       .byte $00 ; |        | $B494
       .byte $00 ; |        | $B495
       .byte $00 ; |        | $B496
       .byte $00 ; |        | $B497
       .byte $00 ; |        | $B498
       .byte $88 ; |X   X   | $B499
       .byte $DD ; |XX XXX X| $B49A
       .byte $FF ; |XXXXXXXX| $B49B
       .byte $FF ; |XXXXXXXX| $B49C
       .byte $FF ; |XXXXXXXX| $B49D
       .byte $FF ; |XXXXXXXX| $B49E
       .byte $99 ; |X  XX  X| $B49F
       .byte $99 ; |X  XX  X| $B4A0
       .byte $BD ; |X XXXX X| $B4A1
       .byte $DB ; |XX XX XX| $B4A2
       .byte $7E ; | XXXXXX | $B4A3
       .byte $3C ; |  XXXX  | $B4A4
       .byte $00 ; |        | $B4A5
       .byte $00 ; |        | $B4A6
       .byte $00 ; |        | $B4A7
       .byte $00 ; |        | $B4A8
       .byte $00 ; |        | $B4A9
       .byte $00 ; |        | $B4AA
       .byte $00 ; |        | $B4AB
       .byte $00 ; |        | $B4AC
       .byte $00 ; |        | $B4AD
       .byte $00 ; |        | $B4AE
       .byte $00 ; |        | $B4AF
       .byte $00 ; |        | $B4B0
       .byte $00 ; |        | $B4B1
       .byte $00 ; |        | $B4B2
       .byte $11 ; |   X   X| $B4B3
       .byte $BB ; |X XXX XX| $B4B4
       .byte $FF ; |XXXXXXXX| $B4B5
       .byte $FF ; |XXXXXXXX| $B4B6
       .byte $FF ; |XXXXXXXX| $B4B7
       .byte $FF ; |XXXXXXXX| $B4B8
       .byte $99 ; |X  XX  X| $B4B9
       .byte $99 ; |X  XX  X| $B4BA
       .byte $BD ; |X XXXX X| $B4BB
       .byte $DB ; |XX XX XX| $B4BC
       .byte $7E ; | XXXXXX | $B4BD
       .byte $3C ; |  XXXX  | $B4BE
       .byte $00 ; |        | $B4BF
       .byte $00 ; |        | $B4C0
       .byte $00 ; |        | $B4C1
       .byte $00 ; |        | $B4C2
       .byte $00 ; |        | $B4C3
       .byte $00 ; |        | $B4C4
       .byte $00 ; |        | $B4C5
       .byte $00 ; |        | $B4C6
       .byte $00 ; |        | $B4C7
       .byte $00 ; |        | $B4C8
       .byte $00 ; |        | $B4C9
       .byte $00 ; |        | $B4CA
       .byte $00 ; |        | $B4CB
       .byte $00 ; |        | $B4CC
       .byte $11 ; |   X   X| $B4CD
       .byte $BB ; |X XXX XX| $B4CE
       .byte $FF ; |XXXXXXXX| $B4CF
       .byte $FF ; |XXXXXXXX| $B4D0
       .byte $FF ; |XXXXXXXX| $B4D1
       .byte $DB ; |XX XX XX| $B4D2
       .byte $BD ; |X XXXX X| $B4D3
       .byte $99 ; |X  XX  X| $B4D4
       .byte $99 ; |X  XX  X| $B4D5
       .byte $FF ; |XXXXXXXX| $B4D6
       .byte $7E ; | XXXXXX | $B4D7
       .byte $3C ; |  XXXX  | $B4D8
       .byte $00 ; |        | $B4D9
       .byte $00 ; |        | $B4DA
       .byte $00 ; |        | $B4DB
       .byte $00 ; |        | $B4DC
       .byte $00 ; |        | $B4DD
       .byte $00 ; |        | $B4DE
       .byte $00 ; |        | $B4DF
       .byte $00 ; |        | $B4E0
       .byte $00 ; |        | $B4E1
       .byte $00 ; |        | $B4E2
       .byte $00 ; |        | $B4E3
       .byte $00 ; |        | $B4E4
       .byte $00 ; |        | $B4E5
       .byte $00 ; |        | $B4E6
       .byte $88 ; |X   X   | $B4E7
       .byte $DD ; |XX XXX X| $B4E8
       .byte $FF ; |XXXXXXXX| $B4E9
       .byte $FF ; |XXXXXXXX| $B4EA
       .byte $FF ; |XXXXXXXX| $B4EB
       .byte $DB ; |XX XX XX| $B4EC
       .byte $BD ; |X XXXX X| $B4ED
       .byte $99 ; |X  XX  X| $B4EE
       .byte $99 ; |X  XX  X| $B4EF
       .byte $FF ; |XXXXXXXX| $B4F0
       .byte $7E ; | XXXXXX | $B4F1
       .byte $3C ; |  XXXX  | $B4F2
       .byte $00 ; |        | $B4F3
       .byte $00 ; |        | $B4F4
       .byte $00 ; |        | $B4F5
       .byte $00 ; |        | $B4F6
       .byte $00 ; |        | $B4F7
       .byte $00 ; |        | $B4F8
       .byte $00 ; |        | $B4F9
       .byte $00 ; |        | $B4FA
       .byte $00 ; |        | $B4FB
       .byte $00 ; |        | $B4FC
       .byte $00 ; |        | $B4FD
       .byte $00 ; |        | $B4FE
       .byte $00 ; |        | $B4FF
       .byte $00 ; |        | $B500
       .byte $00 ; |        | $B501
       .byte $00 ; |        | $B502
       .byte $00 ; |        | $B503
       .byte $00 ; |        | $B504
       .byte $00 ; |        | $B505
       .byte $00 ; |        | $B506
       .byte $00 ; |        | $B507
       .byte $00 ; |        | $B508
       .byte $00 ; |        | $B509
       .byte $00 ; |        | $B50A
       .byte $00 ; |        | $B50B
       .byte $00 ; |        | $B50C
       .byte $00 ; |        | $B50D
       .byte $00 ; |        | $B50E
       .byte $00 ; |        | $B50F
       .byte $00 ; |        | $B510
       .byte $00 ; |        | $B511
       .byte $00 ; |        | $B512
       .byte $00 ; |        | $B513
       .byte $00 ; |        | $B514
       .byte $00 ; |        | $B515
       .byte $00 ; |        | $B516
       .byte $88 ; |X   X   | $B517
       .byte $DD ; |XX XXX X| $B518
       .byte $FF ; |XXXXXXXX| $B519
       .byte $FF ; |XXXXXXXX| $B51A
       .byte $A5 ; |X X  X X| $B51B
       .byte $DB ; |XX XX XX| $B51C
       .byte $FF ; |XXXXXXXX| $B51D
       .byte $FF ; |XXXXXXXX| $B51E
       .byte $99 ; |X  XX  X| $B51F
       .byte $FF ; |XXXXXXXX| $B520
       .byte $7E ; | XXXXXX | $B521
       .byte $3C ; |  XXXX  | $B522
       .byte $00 ; |        | $B523
       .byte $00 ; |        | $B524
       .byte $00 ; |        | $B525
       .byte $00 ; |        | $B526
       .byte $00 ; |        | $B527
       .byte $00 ; |        | $B528
       .byte $00 ; |        | $B529
       .byte $00 ; |        | $B52A
       .byte $00 ; |        | $B52B
       .byte $00 ; |        | $B52C
       .byte $00 ; |        | $B52D
       .byte $00 ; |        | $B52E
       .byte $00 ; |        | $B52F
       .byte $11 ; |   X   X| $B530
       .byte $BB ; |X XXX XX| $B531
       .byte $FF ; |XXXXXXXX| $B532
       .byte $FF ; |XXXXXXXX| $B533
       .byte $A5 ; |X X  X X| $B534
       .byte $DB ; |XX XX XX| $B535
       .byte $FF ; |XXXXXXXX| $B536
       .byte $FF ; |XXXXXXXX| $B537
       .byte $99 ; |X  XX  X| $B538
       .byte $FF ; |XXXXXXXX| $B539
       .byte $7E ; | XXXXXX | $B53A
       .byte $3C ; |  XXXX  | $B53B
       .byte $00 ; |        | $B53C
       .byte $00 ; |        | $B53D
       .byte $00 ; |        | $B53E
       .byte $00 ; |        | $B53F
       .byte $00 ; |        | $B540
       .byte $00 ; |        | $B541
       .byte $00 ; |        | $B542
       .byte $00 ; |        | $B543
       .byte $00 ; |        | $B544
       .byte $00 ; |        | $B545
       .byte $00 ; |        | $B546
       .byte $00 ; |        | $B547
       .byte $00 ; |        | $B548
       .byte $18 ; |   XX   | $B549
       .byte $30 ; |  XX    | $B54A
       .byte $50 ; | X X    | $B54B
       .byte $68 ; | XX X   | $B54C
       .byte $34 ; |  XX X  | $B54D
       .byte $B8 ; |X XXX   | $B54E
       .byte $FC ; |XXXXXX  | $B54F
       .byte $E0 ; |XXX     | $B550
       .byte $30 ; |  XX    | $B551
       .byte $38 ; |  XXX   | $B552
       .byte $00 ; |        | $B553
       .byte $00 ; |        | $B554
       .byte $00 ; |        | $B555
       .byte $00 ; |        | $B556
       .byte $00 ; |        | $B557
       .byte $00 ; |        | $B558
       .byte $00 ; |        | $B559
       .byte $00 ; |        | $B55A
       .byte $00 ; |        | $B55B
       .byte $00 ; |        | $B55C
       .byte $00 ; |        | $B55D
       .byte $00 ; |        | $B55E
       .byte $00 ; |        | $B55F
       .byte $00 ; |        | $B560
       .byte $00 ; |        | $B561
       .byte $04 ; |     X  | $B562
       .byte $0C ; |    XX  | $B563
       .byte $1C ; |   XXX  | $B564
       .byte $39 ; |  XXX  X| $B565
       .byte $7B ; | XXXX XX| $B566
       .byte $0F ; |    XXXX| $B567
       .byte $08 ; |    X   | $B568
       .byte $18 ; |   XX   | $B569
       .byte $38 ; |  XXX   | $B56A
       .byte $00 ; |        | $B56B
       .byte $00 ; |        | $B56C
       .byte $00 ; |        | $B56D
       .byte $00 ; |        | $B56E
       .byte $00 ; |        | $B56F
       .byte $00 ; |        | $B570
       .byte $00 ; |        | $B571
       .byte $00 ; |        | $B572
       .byte $00 ; |        | $B573
       .byte $00 ; |        | $B574
       .byte $00 ; |        | $B575
       .byte $00 ; |        | $B576
       .byte $00 ; |        | $B577
       LDA    ($A2),Y                 ;5
       JMP    LB8C2                   ;3
       LDA    ($A2),Y                 ;5
       JMP    LB904                   ;3
       LDA    ($A2),Y                 ;5
       JMP    LB930                   ;3
       NOP                            ;2
       NOP                            ;2
       JMP    LB964                   ;3
       LDA    ($A2),Y                 ;5
       JMP    LB996                   ;3
       LDA    ($A2),Y                 ;5
       JMP    LB9C3                   ;3
       LDA    ($A2),Y                 ;5
       JMP    LBA3E                   ;3
       STA    $CC                     ;3
       JMP    LBA72                   ;3
       LDA    ($A2),Y                 ;5
       NOP                            ;2
       JMP    LB610                   ;3
       LDA    ($A2),Y                 ;5
       STA    $CC                     ;3
       JMP    LB645                   ;3
       LDA    ($A2),Y                 ;5
       JMP    LB66F                   ;3
       LDA    ($A2),Y                 ;5
       JMP    LB6CF                   ;3
       NOP                            ;2
       NOP                            ;2
       JMP    LB705                   ;3
       JMP    LB732                   ;3
       NOP                            ;2
       JMP    LB763                   ;3
       LDA    ($A2),Y                 ;5
       JMP    LB794                   ;3
       LDA    ($A2),Y                 ;5
       JMP    LB80F                   ;3
       LDA    ($A2),Y                 ;5
       JMP    LB833                   ;3
       NOP                            ;2
       NOP                            ;2
       NOP                            ;2
       NOP                            ;2
       JMP    LB864                   ;3
       LDA    ($A2),Y                 ;5
       JMP    LB896                   ;3
       .byte $98 ; |X  XX   | $B5DE
       .byte $95 ; |X  X X X| $B5DF
       .byte $93 ; |X  X  XX| $B5E0
       .byte $92 ; |X  X  X | $B5E1
       .byte $8E ; |X   XXX | $B5E2
       .byte $98 ; |X  XX   | $B5E3
       .byte $93 ; |X  X  XX| $B5E4
       .byte $92 ; |X  X  X | $B5E5
       .byte $8E ; |X   XXX | $B5E6
       .byte $98 ; |X  XX   | $B5E7
       .byte $8E ; |X   XXX | $B5E8
       .byte $92 ; |X  X  X | $B5E9
       .byte $98 ; |X  XX   | $B5EA
       .byte $8E ; |X   XXX | $B5EB
       .byte $8F ; |X   XXXX| $B5EC
       .byte $90 ; |X  X    | $B5ED
       .byte $8D ; |X   XX X| $B5EE
       .byte $98 ; |X  XX   | $B5EF
       .byte $8D ; |X   XX X| $B5F0
       .byte $93 ; |X  X  XX| $B5F1
       .byte $8D ; |X   XX X| $B5F2
       .byte $98 ; |X  XX   | $B5F3
       .byte $93 ; |X  X  XX| $B5F4
       .byte $92 ; |X  X  X | $B5F5
       .byte $8E ; |X   XXX | $B5F6
       .byte $98 ; |X  XX   | $B5F7
       .byte $8E ; |X   XXX | $B5F8
       .byte $93 ; |X  X  XX| $B5F9
       .byte $89 ; |X   X  X| $B5FA
       .byte $93 ; |X  X  XX| $B5FB
       .byte $89 ; |X   X  X| $B5FC
       .byte $8E ; |X   XXX | $B5FD
       .byte $93 ; |X  X  XX| $B5FE
       .byte $9D ; |X  XXX X| $B5FF
LB600: LDA    $F080,X                 ;4
       AND    #$07                    ;2
       TAY                            ;2
       LDA    LB83C,Y                 ;4
       TAX                            ;2
       AND    #$20                    ;2
       ORA    $B2                     ;3
       STA    $B9                     ;3
LB610: LDY    #$02                    ;2
       LDA    ($A2),Y                 ;5
       STA    GRP0                    ;3
       LDA    ($A4),Y                 ;5
       STA    GRP1                    ;3
       TXA                            ;2
       AND    #$44                    ;2
       ORA    $B3                     ;3
       STA    $BA                     ;3
       TSX                            ;2
       LDA    $F0B6,X                 ;4
       AND    #$07                    ;2
       TAY                            ;2
       LDA    LB83C,Y                 ;4
       AND    #$20                    ;2
       ORA    $B2                     ;3
       STA    $BC                     ;3
       LDA    LB83C,Y                 ;4
       AND    #$44                    ;2
       ORA    $B3                     ;3
       STA    $BB                     ;3
       LDA    $F0EC,X                 ;4
       STA    $A0                     ;3
       AND    #$20                    ;2
       ORA    $B2                     ;3
       STA    $B5                     ;3
LB645: LDY    #$01                    ;2
       LDA    ($A2),Y                 ;5
       STA    GRP0                    ;3
       LDA    ($A4),Y                 ;5
       STA    GRP1                    ;3
       LDX    $B0                     ;3
       LDA    $A0                     ;3
       AND    #$44                    ;2
       ORA    $B3                     ;3
       STA    $B6                     ;3
       DEY                            ;2
       DEC    $9F                     ;5
       BMI    LB684                   ;2
       LDA    #$0A                    ;2
       CMP    $A4                     ;3
       BCC    LB666                   ;2
       STA    $A4                     ;3
LB666: SEC                            ;2
       LDA    $95,X                   ;4
       STA    $AD                     ;3
       LDA    ($A2),Y                 ;5
       STA    WSYNC                   ;3
LB66F: STA    GRP0                    ;3
       LDA    ($A4),Y                 ;5
       STA    GRP1                    ;3
       LDY    #$04                    ;2
       LDA    #$BE                    ;2
       STA    $AE                     ;3
       LDA    $A4                     ;3
       SBC    #$05                    ;2
       STA    $A4                     ;3
       JMP    LB6A9                   ;3
LB684: LDA    $97,X                   ;4
       STA    HMP1                    ;3
       AND    #$07                    ;2
       ORA    #$B0                    ;2
       STA    $A5                     ;3
       DEC    $B0                     ;5
       LDA    $99,X                   ;4
       STA    COLUP1                  ;3
       LDA    ($A2),Y                 ;5
       LDY    #$04                    ;2
       STA    GRP0                    ;3
       STY    $9F                     ;3
       LDA    $9B,X                   ;4
       STA    $A4                     ;3
       JMP.ind ($AD)                  ;5


       LDA    ($A2),Y                 ;5
       LDA    ($A2),Y                 ;5
       STA    RESP1                   ;3
LB6A9: LDA    $A2                     ;3
       SBC    #$05                    ;2
       STA    $A2                     ;3
       LDA    ($A2),Y                 ;5
       JMP    LB6CD                   ;3
       LDA    ($A2),Y                 ;5
       LDA    ($A2),Y                 ;5
       LDA    ($A2),Y                 ;5
       LDA    ($A2),Y                 ;5
       LDA    ($A2),Y                 ;5
       LDA    ($A2),Y                 ;5
       LDA    ($A2),Y                 ;5
       LDA    $A2                     ;3
       SBC    #$05                    ;2
       STA    $A2                     ;3
       LDA    ($A2),Y                 ;5
       NOP                            ;2
       STA    RESP1                   ;3
LB6CD: STA    WSYNC                   ;3
LB6CF: STA    HMOVE                   ;3
       STA    GRP0                    ;3
       LDA    ($A4),Y                 ;5
       STA    GRP1                    ;3
       LDA    $C6                     ;3
       STA    PF0                     ;3
       LDA    $C7                     ;3
       STA    PF1                     ;3
       LDA    $C8                     ;3
       STA    PF2                     ;3
       LDX    $AF                     ;3
       LDA    $91,X                   ;4
       LDX    $CA                     ;3
       LDY    $C9                     ;3
       STY    PF2                     ;3
       STX    PF1                     ;3
       LDY    $CB                     ;3
       STY    PF0                     ;3
       DEC    $94                     ;5
       BMI    LB6FD                   ;2
       NOP                            ;2
       NOP                            ;2
       NOP                            ;2
       JMP    LB703                   ;3
LB6FD: STA    $94                     ;3
       LDA    #$0A                    ;2
       STA    $A2                     ;3
LB703: LDY    #$03                    ;2
LB705: LDA    ($A2),Y                 ;5
       STA    GRP0                    ;3
       LDA    ($A4),Y                 ;5
       STA    GRP1                    ;3
       LDA    $C0                     ;3
       STA    PF0                     ;3
       LDA    $C1                     ;3
       STA    PF1                     ;3
       LDA    $C2                     ;3
       STA    PF2                     ;3
       LDA    $C4                     ;3
       STA    PF1                     ;3
       STA    HMCLR                   ;3
       LDA    $C3                     ;3
       STA    PF2                     ;3
       LDA    $C5                     ;3
       STA    PF0                     ;3
       LDA    $A0                     ;3
       ASL                            ;2
       ASL                            ;2
       TAX                            ;2
       AND    #$20                    ;2
       ORA    $B2                     ;3
       STA    $B8                     ;3
LB732: LDY    #$02                    ;2
       LDA    ($A2),Y                 ;5
       STA    GRP0                    ;3
       LDA    ($A4),Y                 ;5
       STA    GRP1                    ;3
       LDA    $C0                     ;3
       STA    PF0                     ;3
       LDA    $C1                     ;3
       STA    PF1                     ;3
       LDA    $C2                     ;3
       STA    PF2                     ;3
       LDA    $C5                     ;3
       STA    PF0                     ;3
       TXA                            ;2
       LDY    $C4                     ;3
       LDX    $C3                     ;3
       STX    PF2                     ;3
       STY    PF1                     ;3
       AND    #$44                    ;2
       ORA    $B3                     ;3
       STA    $B7                     ;3
       LDY    #$01                    ;2
       LDA    ($A2),Y                 ;5
       DEC    $94                     ;5
       BMI    LB7B7                   ;2
LB763: LDX    #$0A                    ;2
       STA    GRP0                    ;3
       LDA    ($A4),Y                 ;5
       STA    GRP1                    ;3
       LDA    $C6                     ;3
       STA    PF0                     ;3
       LDA    $C7                     ;3
       STA    PF1                     ;3
       LDA    $C8                     ;3
       STA    PF2                     ;3
       LDA    $CB                     ;3
       STA    PF0                     ;3
       LDA    $CA                     ;3
       STA    PF1                     ;3
       LDY    #$00                    ;2
       LDA    $C9                     ;3
       STA    PF2                     ;3
       CPX    $A2                     ;3
       BCC    LB78B                   ;2
       STX    $A2                     ;3
LB78B: SEC                            ;2
       LDA    #$BA                    ;2
       STA    $AC                     ;3
       LDA    ($A2),Y                 ;5
       STA    WSYNC                   ;3
LB794: STA    GRP0                    ;3
       LDA    ($A4),Y                 ;5
       STA    GRP1                    ;3
       LDA    $BD                     ;3
       STA    PF0                     ;3
       LDA    $BE                     ;3
       STA    PF1                     ;3
       LDA    $BF                     ;3
       STA    PF2                     ;3
       LDY    #$04                    ;2
       LDX    $AF                     ;3
       LDA    $80,X                   ;4
       STA    $AB                     ;3
       LDA    $A2                     ;3
       SBC    #$05                    ;2
       STA    $A2                     ;3
       JMP    LB805                   ;3
LB7B7: STA    GRP0                    ;3
       LDA    ($A4),Y                 ;5
       STA    GRP1                    ;3
       LDA    $C6                     ;3
       STA    PF0                     ;3
       LDA    $C7                     ;3
       STA    PF1                     ;3
       LDA    $C8                     ;3
       STA    PF2                     ;3
       LDX    $AF                     ;3
       LDA    $CB                     ;3
       STA    PF0                     ;3
       LDA    $CA                     ;3
       STA    PF1                     ;3
       LDA    $C9                     ;3
       STA    PF2                     ;3
       LDA    $84,X                   ;4
       STA    HMP0                    ;3
       AND    #$07                    ;2
       ORA    #$B0                    ;2
       STA    $A3                     ;3
       LDY    #$00                    ;2
       LDA    ($A4),Y                 ;5
       SEC                            ;2
       DEC    $AF                     ;5
       STA    GRP1                    ;3
       LDA    $BD                     ;3
       STA    PF0                     ;3
       LDA    $BE                     ;3
       STA    PF1                     ;3
       JMP.ind ($AB)                  ;5
LB7F5: LDA    $BF                     ;3
       STA    PF2                     ;3
       LDA    $8C,X                   ;4
LB7FB: STA    $A2                     ;3
       LDA    $88,X                   ;4
       STA    COLUP0                  ;3
LB801: LDY    #$04                    ;2
       STY    $94                     ;3
LB805: LDA    $A4                     ;3
       SBC    #$05                    ;2
LB809: STA    $A4                     ;3
       LDA    ($A2),Y                 ;5
LB80D: STA    WSYNC                   ;3
LB80F: STA    HMOVE                   ;3
       STA    GRP0                    ;3
       LDA    ($A4),Y                 ;5
       STA    GRP1                    ;3
       DEC    $9F                     ;5
       BPL    LB825                   ;2
       LDX    $B0                     ;3
       LDA    $9E,X                   ;4
       STA    $9F                     ;3
       LDA    #$0A                    ;2
       STA    $A4                     ;3
LB825: LDY    #$03                    ;2
       LDA    ($A2),Y                 ;5
       DEC    $A7                     ;5
       BPL    LB830                   ;2
       JMP    LBBF7                   ;3
LB830: TSX                            ;2
       STA    WSYNC                   ;3
LB833: STA    GRP0                    ;3
       LDA    ($A4),Y                 ;5
       STA    GRP1                    ;3
       STA    BANK3                   ;4
LB83C: .byte $00 ; |        | $B83C
       .byte $04 ; |     X  | $B83D
       .byte $20 ; |  X     | $B83E
       .byte $24 ; |  X  X  | $B83F
       .byte $40 ; | X      | $B840
       .byte $44 ; | X   X  | $B841
       .byte $60 ; | XX     | $B842
       .byte $64 ; | XX  X  | $B843
       .byte $94 ; |X  X X  | $B844
       .byte $92 ; |X  X  X | $B845
       .byte $90 ; |X  X    | $B846
       .byte $8F ; |X   XXXX| $B847
       .byte $8C ; |X   XX  | $B848
       .byte $92 ; |X  X  X | $B849
       .byte $8F ; |X   XXXX| $B84A
       .byte $97 ; |X  X XXX| $B84B
       .byte $92 ; |X  X  X | $B84C
       .byte $9F ; |X  XXXXX| $B84D
       .byte $8F ; |X   XXXX| $B84E
       .byte $34 ; |  XX X  | $B84F
       .byte $20 ; |  X     | $B850
       .byte $34 ; |  XX X  | $B851
       .byte $20 ; |  X     | $B852
       .byte $0F ; |    XXXX| $B853
       .byte $10 ; |   X    | $B854
       .byte $8F ; |X   XXXX| $B855
       .byte $3F ; |  XXXXXX| $B856
       ORA    $BD                     ;3
       STA    $C0                     ;3
       LDA    $F0B6,X                 ;4
       AND    #$A0                    ;2
       ORA    $BD                     ;3
       STA    $C6                     ;3
LB864: LDY    #$02                    ;2
       LDA    ($A2),Y                 ;5
       STA    GRP0                    ;3
       LDA    ($A4),Y                 ;5
       STA    GRP1                    ;3
       LDA    $F080,X                 ;4
       ASL                            ;2
       AND    #$A0                    ;2
       ORA    $BD                     ;3
       STA    $C5                     ;3
       LDA    $F0B6,X                 ;4
       ASL                            ;2
       AND    #$A0                    ;2
       ORA    $BD                     ;3
       STA    $CB                     ;3
       LDA    $F0A4,X                 ;4
       AND    #$55                    ;2
       ORA    $BE                     ;3
       STA    $C1                     ;3
       LDA    $F0DA,X                 ;4
       AND    #$55                    ;2
       ORA    $BE                     ;3
       STA    $C7                     ;3
       STA    WSYNC                   ;3
LB896: LDY    #$01                    ;2
       LDA    ($A2),Y                 ;5
       SEC                            ;2
       STA    GRP0                    ;3
       LDA    ($A4),Y                 ;5
       STA    GRP1                    ;3
       LDA    $F092,X                 ;4
       AND    #$55                    ;2
       ORA    $BE                     ;3
       STA    $C4                     ;3
       DEY                            ;2
       INX                            ;2
       TXS                            ;2
       LDX    $B0                     ;3
       STA    HMCLR                   ;3
       DEC    $9F                     ;5
       BMI    LB8E7                   ;2
       LDA    #$0A                    ;2
       CMP    $A4                     ;3
       BCC    LB8BD                   ;2
       STA    $A4                     ;3
LB8BD: SEC                            ;2
       LDA    ($A2),Y                 ;5
       STA    WSYNC                   ;3
LB8C2: STA    GRP0                    ;3
       LDA    ($A4),Y                 ;5
       STA    GRP1                    ;3
       LDA    $B2                     ;3
       STA    PF0                     ;3
       LDA    $B3                     ;3
       STA    PF1                     ;3
       LDA    $B4                     ;3
       STA    PF2                     ;3
       LDA    $95,X                   ;4
       STA    $AD                     ;3
       LDA    #$B6                    ;2
       STA    $AE                     ;3
       LDY    #$04                    ;2
       LDA    $A4                     ;3
       SBC    #$05                    ;2
       STA    $A4                     ;3
       JMP    LBEB6                   ;3
LB8E7: LDA    $97,X                   ;4
       STA    HMP1                    ;3
       AND    #$07                    ;2
       ORA    #$B0                    ;2
       STA    $A5                     ;3
       LDA    ($A2),Y                 ;5
       DEC    $B0                     ;5
       STA    GRP0                    ;3
       LDA    $B2                     ;3
       STA    PF0                     ;3
       LDA    $B3                     ;3
       STA    PF1                     ;3
       JMP.ind ($AD)                  ;5
LB902: STA    WSYNC                   ;3
LB904: STA    HMOVE                   ;3
       STA    GRP0                    ;3
       LDA    ($A4),Y                 ;5
       STA    GRP1                    ;3
       LDA    $B9                     ;3
       STA    PF0                     ;3
       LDA    $BA                     ;3
       STA    PF1                     ;3
       LDA    $BC                     ;3
       STA    PF0                     ;3
       LDA    $BB                     ;3
       STA    PF1                     ;3
       DEC    $94                     ;5
       BPL    LB92A                   ;2
       LDX    $AF                     ;3
       LDA    $91,X                   ;4
       STA    $94                     ;3
       LDA    #$0A                    ;2
       STA    $A2                     ;3
LB92A: LDY    #$03                    ;2
       LDA    ($A2),Y                 ;5
       STA    WSYNC                   ;3
LB930: STA    GRP0                    ;3
       LDA    ($A4),Y                 ;5
       STA    GRP1                    ;3
       LDA    $B5                     ;3
       STA    PF0                     ;3
       LDA    $B6                     ;3
       STA    PF1                     ;3
       LDY    #$02                    ;2
       TSX                            ;2
       LDA    $B8                     ;3
       STA    PF0                     ;3
       LDA    $B7                     ;3
       STA    PF1                     ;3
       LDA    $F0C7,X                 ;4
       AND    #$55                    ;2
       ORA    $BE                     ;3
       STA    $CA                     ;3
       LDA    $F0A3,X                 ;4
       AND    #$AA                    ;2
       ORA    $BF                     ;3
       STA    $C2                     ;3
       LDA    $F0D9,X                 ;4
       AND    #$AA                    ;2
       ORA    $BF                     ;3
       STA    $C8                     ;3
LB964: LDA    ($A2),Y                 ;5
       STA    GRP0                    ;3
       LDA    ($A4),Y                 ;5
       STA    GRP1                    ;3
       LDA    $B5                     ;3
       STA    PF0                     ;3
       LDA    $B6                     ;3
       STA    PF1                     ;3
       LDA    $B8                     ;3
       STA    PF0                     ;3
       LDA    $B7                     ;3
       STA    PF1                     ;3
       LDA    $F091,X                 ;4
       AND    #$AA                    ;2
       ORA    $BF                     ;3
       STA    $C3                     ;3
       LDA    $F0C7,X                 ;4
       AND    #$AA                    ;2
       ORA    $BF                     ;3
       STA    $C9                     ;3
       LDY    #$01                    ;2
       LDA    ($A2),Y                 ;5
       STA    HMCLR                   ;3
       LDX    $B9                     ;3
LB996: STA    GRP0                    ;3
       LDA    ($A4),Y                 ;5
       STA    GRP1                    ;3
       STX    PF0                     ;3
       LDA    $BA                     ;3
       STA    PF1                     ;3
       LDX    $AF                     ;3
       LDY    #$00                    ;2
       LDA    $BC                     ;3
       STA    PF0                     ;3
       DEC    $94                     ;5
       BMI    LB9E0                   ;2
       LDA    $BB                     ;3
       STA    PF1                     ;3
       LDA    #$0A                    ;2
       CMP    $A2                     ;3
       BCC    LB9BA                   ;2
       STA    $A2                     ;3
LB9BA: SEC                            ;2
       LDA    $80,X                   ;4
       STA    $AB                     ;3
       LDA    ($A2),Y                 ;5
       STA    WSYNC                   ;3
LB9C3: STA    GRP0                    ;3
       LDA    ($A4),Y                 ;5
       STA    GRP1                    ;3
       LDA    $B2                     ;3
       STA    PF0                     ;3
       LDA    $B3                     ;3
       STA    PF1                     ;3
       LDA    #$BF                    ;2
       STA    $AC                     ;3
       LDY    #$04                    ;2
       LDA    $A2                     ;3
       SBC    #$05                    ;2
       STA    $A2                     ;3
       JMP    LBA15                   ;3
LB9E0: LDA    $BB                     ;3
       STA    PF1                     ;3
       LDA    $84,X                   ;4
       STA    HMP0                    ;3
       AND    #$07                    ;2
       ORA    #$B0                    ;2
       STA    $A3                     ;3
       LDA    $88,X                   ;4
       STA    COLUP0                  ;3
       LDA    ($A4),Y                 ;5
       DEC    $AF                     ;5
       STA    GRP1                    ;3
       LDA    $B2                     ;3
       STA    PF0                     ;3
       LDA    $B3                     ;3
       STA    PF1                     ;3
       JMP.ind ($AB)                  ;5
       LDA    ($A2),Y                 ;5
       LDA    ($A2),Y                 ;5
       LDA    ($A2),Y                 ;5
       LDA    ($A2),Y                 ;5
       STA    RESP0                   ;3
       LDY    #$04                    ;2
       STY    $94                     ;3
       LDA    $8C,X                   ;4
       STA    $A2                     ;3
LBA15: LDA    $A4                     ;3
       SBC    #$05                    ;2
       STA    $A4                     ;3
       LDA    ($A2),Y                 ;5
       JMP    LBA3C                   ;3
       LDA    ($A2),Y                 ;5
       LDA    ($A2),Y                 ;5
       LDA    ($A2),Y                 ;5
       LDA    ($A2),Y                 ;5
       LDA    ($A2),Y                 ;5
       LDY    #$04                    ;2
       STY    $94                     ;3
       LDA    $8C,X                   ;4
       STA    $A2                     ;3
       LDA    $A4                     ;3
       SBC    #$05                    ;2
       STA    $A4                     ;3
       LDA    ($A2),Y                 ;5
       STA    RESP0                   ;3
LBA3C: STA    WSYNC                   ;3
LBA3E: STA    HMOVE                   ;3
       STA    GRP0                    ;3
       LDA    ($A4),Y                 ;5
       STA    GRP1                    ;3
       LDA    $BD                     ;3
       STA    PF0                     ;3
       LDA    $BE                     ;3
       STA    PF1                     ;3
       LDA    $BF                     ;3
       STA    PF2                     ;3
       LDX    $B0                     ;3
       DEC    $9F                     ;5
       BMI    LBA5F                   ;2
       LDA    ($A2),Y                 ;5
       LDA    ($A2),Y                 ;5
       JMP    LBA67                   ;3
LBA5F: LDA    $9E,X                   ;4
       STA    $9F                     ;3
       LDA    #$0A                    ;2
       STA    $A4                     ;3
LBA67: DEC    $A7                     ;5
       BMI    LBAA9                   ;2
       STA    HMCLR                   ;3
       TSX                            ;2
       LDY    #$03                    ;2
       LDA    ($A2),Y                 ;5
LBA72: STA    GRP0                    ;3
       LDA    ($A4),Y                 ;5
       STA    BANK3                   ;4
       RTS                            ;6

       .byte $20 ; |  X     | $BA7A
       .byte $12 ; |   X  X | $BA7B
       .byte $13 ; |   X  XX| $BA7C
       .byte $12 ; |   X  X | $BA7D
       .byte $2F ; |  X XXXX| $BA7E
       .byte $0D ; |    XX X| $BA7F
       .byte $8F ; |X   XXXX| $BA80
       .byte $17 ; |   X XXX| $BA81
       .byte $18 ; |   XX   | $BA82
       .byte $17 ; |   X XXX| $BA83
       .byte $32 ; |  XX  X | $BA84
       .byte $13 ; |   X  XX| $BA85
       .byte $92 ; |X  X  X | $BA86
       .byte $0F ; |    XXXX| $BA87
       .byte $11 ; |   X   X| $BA88
       .byte $14 ; |   X X  | $BA89
       .byte $38 ; |  XXX   | $BA8A
       .byte $1B ; |   XX XX| $BA8B
       .byte $98 ; |X  XX   | $BA8C
       .byte $57 ; | X X XXX| $BA8D
       .byte $40 ; | X      | $BA8E
       .byte $FF ; |XXXXXXXX| $BA8F
       .byte $FF ; |XXXXXXXX| $BA90
       JMP    LB600                   ;3
LBA94: STA    WSYNC                   ;3
       LDA    #$00                    ;2
       STA    ENABL                   ;3
       STA    COLUBK                  ;3
       STA    GRP0                    ;3
       STA    GRP1                    ;3
       STA    PF0                     ;3
       STA    PF1                     ;3
       STA    PF2                     ;3
       JMP    LBFF0                   ;3
LBAA9: DEC    $A6                     ;5
       BMI    LBA94                   ;2
LBAAD: STA    WSYNC                   ;3
       DEY                            ;2
       LDA    ($A2),Y                 ;5
       STA    GRP0                    ;3
       LDA    ($A4),Y                 ;5
       STA    GRP1                    ;3
       LDA    #$BB                    ;2
       STA    $AE                     ;3
       STA    HMCLR                   ;3
       DEC    $A6                     ;5
       BMI    LBAE5                   ;2
       CPY    #$02                    ;2
       BNE    LBAAD                   ;2
       STA    WSYNC                   ;3
       DEY                            ;2
       LDA    ($A2),Y                 ;5
       STA    GRP0                    ;3
       LDA    ($A4),Y                 ;5
       STA    GRP1                    ;3
       DEY                            ;2
       DEC    $9F                     ;5
       BMI    LBB05                   ;2
       LDA    #$0A                    ;2
       CMP    $A4                     ;3
       BCC    LBADE                   ;2
       STA    $A4                     ;3
LBADE: SEC                            ;2
       LDA    ($A2),Y                 ;5
       DEC    $A6                     ;5
       BPL    LBAE8                   ;2
LBAE5: JMP    LBA94                   ;3
LBAE8: STA    WSYNC                   ;3
       STA    GRP0                    ;3
       LDA    ($A4),Y                 ;5
       STA    GRP1                    ;3
       LDY    #$04                    ;2
       LDA    $A4                     ;3
       SBC    #$05                    ;2
       STA    $A4                     ;3
       LDA    $A2                     ;3
       SBC    #$05                    ;2
       STA    $A2                     ;3
       DEC    $A6                     ;5
       BMI    LBAE5                   ;2
       JMP    LBB35                   ;3
LBB05: LDA    $9B,X                   ;4
       STA    $A4                     ;3
       LDA    $99,X                   ;4
       STA    COLUP1                  ;3
       LDA    $97,X                   ;4
       STA    HMP1                    ;3
       AND    #$07                    ;2
       ORA    #$B0                    ;2
       STA    $A5                     ;3
       DEC    $A6                     ;5
       BMI    LBAE5                   ;2
       LDA    ($A2),Y                 ;5
       LDY    #$04                    ;2
       DEC    $A6                     ;5
       STA    GRP0                    ;3
       BMI    LBAE5                   ;2
       LDA    $A2                     ;3
       SBC    #$05                    ;2
       STA    $A2                     ;3
       NOP                            ;2
       JMP.ind ($AD)                  ;5
       LDA    ($A2),Y                 ;5
       LDA    ($A2),Y                 ;5
       STA    RESP1                   ;3
LBB35: LDA    ($A2),Y                 ;5
       TAX                            ;2
       LDA    ($A4),Y                 ;5
       JMP    LBB54                   ;3
       LDA    ($A2),Y                 ;5
       LDA    ($A2),Y                 ;5
       LDA    ($A2),Y                 ;5
       LDA    ($A2),Y                 ;5
       LDA    ($A2),Y                 ;5
       LDA    ($A2),Y                 ;5
       LDA    ($A2),Y                 ;5
       LDA    ($A2),Y                 ;5
       NOP                            ;2
       TAX                            ;2
       LDA    ($A4),Y                 ;5
       STA    $0111                   ;4
LBB54: STA    WSYNC                   ;3
       STA    HMOVE                   ;3
       STX    GRP0                    ;3
       STA    GRP1                    ;3
       LDA    $C6                     ;3
       STA    PF0                     ;3
       LDA    $C7                     ;3
       STA    PF1                     ;3
       LDA    $C8                     ;3
       STA    PF2                     ;3
       LDA    $CB                     ;3
       STA    PF0                     ;3
       LDA    $CA                     ;3
       STA    PF1                     ;3
       DEY                            ;2
       LDA    $C9                     ;3
       STA    $010F                   ;4
       DEC    $94                     ;5
       BPL    LBB7E                   ;2
       LDA    #$0A                    ;2
       STA    $A2                     ;3
LBB7E: DEC    $A6                     ;5
       BMI    LBBF4                   ;2
       LDA    ($A2),Y                 ;5
LBB84: STA    WSYNC                   ;3
       STA    GRP0                    ;3
       LDA    ($A4),Y                 ;5
       STA    GRP1                    ;3
       LDA    $C0                     ;3
       STA    PF0                     ;3
       LDA    $C1                     ;3
       STA    PF1                     ;3
       LDA    $C2                     ;3
       STA    PF2                     ;3
       LDA    $C5                     ;3
       STA    PF0                     ;3
       LDA    $C4                     ;3
       STA    PF1                     ;3
       LDA    $C3                     ;3
       STA    $010F                   ;4
       DEY                            ;2
       LDA    ($A2),Y                 ;5
       DEC    $A6                     ;5
       BMI    LBBF4                   ;2
       CPY    #$01                    ;2
       BNE    LBB84                   ;2
       STA    WSYNC                   ;3
       STA    GRP0                    ;3
       LDA    ($A4),Y                 ;5
       STA    GRP1                    ;3
       LDA    $C6                     ;3
       STA    PF0                     ;3
       LDA    $C7                     ;3
       STA    PF1                     ;3
       LDA    $C8                     ;3
       STA    PF2                     ;3
       LDA    $CB                     ;3
       STA    PF0                     ;3
       LDA    $CA                     ;3
       STA    PF1                     ;3
       LDA    $C9                     ;3
       STA    $010F                   ;4
       LDX    #$0A                    ;2
       CPX    $A2                     ;3
       BCC    LBBD9                   ;2
       STX    $A2                     ;3
LBBD9: DEC    $A6                     ;5
       BMI    LBBF4                   ;2
       DEY                            ;2
       LDA    ($A2),Y                 ;5
       STA    WSYNC                   ;3
       STA    GRP0                    ;3
       LDA    ($A4),Y                 ;5
       STA    GRP1                    ;3
       LDA    $BD                     ;3
       STA    PF0                     ;3
       LDA    $BE                     ;3
       STA    PF1                     ;3
       LDA    $BF                     ;3
       STA    PF2                     ;3
LBBF4: JMP    LBA94                   ;3
LBBF7: DEC    $A6                     ;5
       BMI    LBC20                   ;2
LBBFB: STA    WSYNC                   ;3
       STA    GRP0                    ;3
       LDA    ($A4),Y                 ;5
       STA    GRP1                    ;3
       LDA    #$BC                    ;2
       STA    $AE                     ;3
       STA    HMCLR                   ;3
       DEY                            ;2
       LDA    ($A2),Y                 ;5
       DEC    $A6                     ;5
       BMI    LBC20                   ;2
       CPY    #$01                    ;2
       BNE    LBBFB                   ;2
       STA    WSYNC                   ;3
       STA    GRP0                    ;3
       LDA    ($A4),Y                 ;5
       STA    GRP1                    ;3
       DEC    $A6                     ;5
       BPL    LBC23                   ;2
LBC20: JMP    LBA94                   ;3
LBC23: DEY                            ;2
       LDX    $B0                     ;3
       DEC    $9F                     ;5
       BMI    LBC54                   ;2
       LDA    #$0A                    ;2
       CMP    $A4                     ;3
       BCC    LBC32                   ;2
       STA    $A4                     ;3
LBC32: SEC                            ;2
       LDA    ($A2),Y                 ;5
       STA    WSYNC                   ;3
       STA    GRP0                    ;3
       LDA    ($A4),Y                 ;5
       STA    GRP1                    ;3
       LDA    $B2                     ;3
       STA    PF0                     ;3
       LDA    $B3                     ;3
       STA    PF1                     ;3
       LDA    $B4                     ;3
       STA    PF2                     ;3
       LDY    #$04                    ;2
       LDA    $A4                     ;3
       SBC    #$05                    ;2
       STA    $A4                     ;3
       JMP    LBC87                   ;3
LBC54: LDA    $97,X                   ;4
       STA    $0121                   ;4
       AND    #$07                    ;2
       ORA    #$B0                    ;2
       STA    $A5                     ;3
       LDA    $99,X                   ;4
       STA    COLUP1                  ;3
       LDA    $9B,X                   ;4
       STA    $A4                     ;3
       LDA    ($A2),Y                 ;5
       TAX                            ;2
       LDY    #$04                    ;2
       LDA    $B4                     ;3
       STA    PF2                     ;3
       STX    GRP0                    ;3
       LDA    $B2                     ;3
       STA    PF0                     ;3
       LDA    $B3                     ;3
       STA    PF1                     ;3
       JMP.ind ($AD)                  ;5
       LDA    ($A2),Y                 ;5
       LDA    ($A2),Y                 ;5
       LDA    ($A2),Y                 ;5
       LDA    ($A2),Y                 ;5
       STA    RESP1                   ;3
LBC87: DEC    $A6                     ;5
       BPL    LBC8E                   ;2
       JMP    LBA94                   ;3
LBC8E: LDA    $A2                     ;3
       SBC    #$05                    ;2
       STA    $A2                     ;3
       LDA    ($A2),Y                 ;5
       JMP    LBCB6                   ;3
       LDA    ($A2),Y                 ;5
       LDA    ($A2),Y                 ;5
       LDA    ($A2),Y                 ;5
       LDA    ($A2),Y                 ;5
       LDA    ($A2),Y                 ;5
       LDA    $A2                     ;3
       SBC    #$05                    ;2
       STA    $A2                     ;3
       NOP                            ;2
       NOP                            ;2
       LDA    ($A2),Y                 ;5
       DEC    $A6                     ;5
       BPL    LBCB4                   ;2
       JMP    LBA94                   ;3
LBCB4: STA    RESP1                   ;3
LBCB6: STA    WSYNC                   ;3
       STA    HMOVE                   ;3
       STA    GRP0                    ;3
       LDA    ($A4),Y                 ;5
       STA    GRP1                    ;3
       LDA    $B9                     ;3
       STA    PF0                     ;3
       LDA    $BA                     ;3
       STA    PF1                     ;3
       LDA    $BC                     ;3
       STA    PF0                     ;3
       LDA    $BB                     ;3
       STA    PF1                     ;3
       DEC    $94                     ;5
       BPL    LBCD8                   ;2
       LDA    #$0A                    ;2
       STA    $A2                     ;3
LBCD8: DEC    $A6                     ;5
       BMI    LBD39                   ;2
       DEY                            ;2
       LDA    ($A2),Y                 ;5
LBCDF: STA    WSYNC                   ;3
       STA    GRP0                    ;3
       LDA    ($A4),Y                 ;5
       STA    GRP1                    ;3
       LDA    $B5                     ;3
       STA    PF0                     ;3
       LDA    $B6                     ;3
       STA    PF1                     ;3
       DEY                            ;2
       LDA    ($A2),Y                 ;5
       LDX    $B8                     ;3
       STX    PF0                     ;3
       LDX    $B7                     ;3
       STX    PF1                     ;3
       DEC    $A6                     ;5
       BMI    LBD39                   ;2
       CPY    #$01                    ;2
       BNE    LBCDF                   ;2
       STA    WSYNC                   ;3
       STA    GRP0                    ;3
       LDA    ($A4),Y                 ;5
       STA    GRP1                    ;3
       LDA    $B9                     ;3
       STA    PF0                     ;3
       LDA    $BA                     ;3
       STA    PF1                     ;3
       DEY                            ;2
       LDA    #$0A                    ;2
       CMP    $A2                     ;3
       BCC    LBD1B                   ;2
       STA    $A2                     ;3
LBD1B: LDA    $BB                     ;3
       STA    PF1                     ;3
       LDA    $BC                     ;3
       STA    PF0                     ;3
       LDA    ($A4),Y                 ;5
       DEC    $A6                     ;5
       BMI    LBD39                   ;2
       STA    WSYNC                   ;3
       STA    GRP1                    ;3
       LDA    ($A2),Y                 ;5
       STA    GRP0                    ;3
       LDA    $B2                     ;3
       STA    PF0                     ;3
       LDA    $B3                     ;3
       STA    PF1                     ;3
LBD39: JMP    LBA94                   ;3
       .byte $37 ; |  XX XXX| $BD3C
       .byte $74 ; | XXX X  | $BD3D
       .byte $32 ; |  XX  X | $BD3E
       .byte $71 ; | XXX   X| $BD3F
       .byte $2D ; |  X XX X| $BD40
       .byte $77 ; | XXX XXX| $BD41
       .byte $2D ; |  X XX X| $BD42
       .byte $71 ; | XXX   X| $BD43
       .byte $2D ; |  X XX X| $BD44
       .byte $77 ; | XXX XXX| $BD45
       .byte $2D ; |  X XX X| $BD46
       .byte $6F ; | XX XXXX| $BD47
       .byte $2B ; |  X X XX| $BD48
       .byte $77 ; | XXX XXX| $BD49
       .byte $2B ; |  X X XX| $BD4A
       .byte $6F ; | XX XXXX| $BD4B
       .byte $2B ; |  X X XX| $BD4C
       .byte $77 ; | XXX XXX| $BD4D
       .byte $2B ; |  X X XX| $BD4E
       .byte $6F ; | XX XXXX| $BD4F
       .byte $2B ; |  X X XX| $BD50
       .byte $77 ; | XXX XXX| $BD51
       .byte $2B ; |  X X XX| $BD52
       .byte $CF ; |XX  XXXX| $BD53
       .byte $2B ; |  X X XX| $BD54
       .byte $77 ; | XXX XXX| $BD55
       .byte $2F ; |  X XXXX| $BD56
       .byte $71 ; | XXX   X| $BD57
       .byte $2D ; |  X XX X| $BD58
       .byte $77 ; | XXX XXX| $BD59
       .byte $2D ; |  X XX X| $BD5A
       .byte $72 ; | XXX  X | $BD5B
       .byte $37 ; |  XX XXX| $BD5C
       .byte $74 ; | XXX X  | $BD5D
       .byte $32 ; |  XX  X | $BD5E
       .byte $71 ; | XXX   X| $BD5F
       .byte $2D ; |  X XX X| $BD60
       .byte $77 ; | XXX XXX| $BD61
       .byte $2D ; |  X XX X| $BD62
       .byte $71 ; | XXX   X| $BD63
       .byte $2D ; |  X XX X| $BD64
       .byte $77 ; | XXX XXX| $BD65
       .byte $2D ; |  X XX X| $BD66
       .byte $72 ; | XXX  X | $BD67
       .byte $2E ; |  X XXX | $BD68
       .byte $78 ; | XXXX   | $BD69
       .byte $2E ; |  X XXX | $BD6A
       .byte $D2 ; |XX X  X | $BD6B
       .byte $32 ; |  XX  X | $BD6C
       .byte $70 ; | XXX    | $BD6D
       .byte $2E ; |  X XXX | $BD6E
       .byte $6D ; | XX XX X| $BD6F
       .byte $6D ; | XX XX X| $BD70
       .byte $8D ; |X   XX X| $BD71
       .byte $2D ; |  X XX X| $BD72
       .byte $72 ; | XXX  X | $BD73
       .byte $72 ; | XXX  X | $BD74
       .byte $92 ; |X  X  X | $BD75
       .byte $32 ; |  XX  X | $BD76
       .byte $6D ; | XX XX X| $BD77
       .byte $32 ; |  XX  X | $BD78
       .byte $77 ; | XXX XXX| $BD79
       .byte $32 ; |  XX  X | $BD7A
       .byte $6D ; | XX XX X| $BD7B
       .byte $60 ; | XX     | $BD7C
       .byte $20 ; |  X     | $BD7D
       .byte $15 ; |   X X X| $BD7E
       .byte $16 ; |   X XX | $BD7F
       .byte $15 ; |   X X X| $BD80
       .byte $14 ; |   X X  | $BD81
       .byte $12 ; |   X  X | $BD82
       .byte $14 ; |   X X  | $BD83
       .byte $15 ; |   X X X| $BD84
       .byte $18 ; |   XX   | $BD85
       .byte $15 ; |   X X X| $BD86
       .byte $16 ; |   X XX | $BD87
       .byte $15 ; |   X X X| $BD88
       .byte $3B ; |  XXX XX| $BD89
       .byte $1D ; |   XXX X| $BD8A
       .byte $1B ; |   XX XX| $BD8B
       .byte $18 ; |   XX   | $BD8C
       .byte $15 ; |   X X X| $BD8D
       .byte $16 ; |   X XX | $BD8E
       .byte $15 ; |   X X X| $BD8F
       .byte $14 ; |   X X  | $BD90
       .byte $12 ; |   X  X | $BD91
       .byte $0D ; |    XX X| $BD92
       .byte $0E ; |    XXX | $BD93
       .byte $10 ; |   X    | $BD94
       .byte $12 ; |   X  X | $BD95
       .byte $14 ; |   X X  | $BD96
       .byte $18 ; |   XX   | $BD97
       .byte $7D ; | XXXXX X| $BD98
       .byte $1D ; |   XXX X| $BD99
       .byte $12 ; |   X  X | $BD9A
       .byte $14 ; |   X X  | $BD9B
       .byte $18 ; |   XX   | $BD9C
       .byte $3D ; |  XXXX X| $BD9D
       .byte $1B ; |   XX XX| $BD9E
       .byte $18 ; |   XX   | $BD9F
       .byte $17 ; |   X XXX| $BDA0
       .byte $15 ; |   X X X| $BDA1
       .byte $14 ; |   X X  | $BDA2
       .byte $13 ; |   X  XX| $BDA3
       .byte $B2 ; |X XX  X | $BDA4
       .byte $8D ; |X   XX X| $BDA5
       .byte $0E ; |    XXX | $BDA6
       .byte $12 ; |   X  X | $BDA7
       .byte $15 ; |   X X X| $BDA8
       .byte $1B ; |   XX XX| $BDA9
       .byte $1D ; |   XXX X| $BDAA
       .byte $17 ; |   X XXX| $BDAB
       .byte $13 ; |   X  XX| $BDAC
       .byte $12 ; |   X  X | $BDAD
       .byte $75 ; | XXX X X| $BDAE
       .byte $35 ; |  XX X X| $BDAF
       .byte $FF ; |XXXXXXXX| $BDB0
       .byte $60 ; | XX     | $BDB1
       .byte $60 ; | XX     | $BDB2
       .byte $CB ; |XX  X XX| $BDB3
       .byte $94 ; |X  X X  | $BDB4
       .byte $34 ; |  XX X  | $BDB5
       .byte $35 ; |  XX X X| $BDB6
       .byte $34 ; |  XX X  | $BDB7
       .byte $7A ; | XXXX X | $BDB8
       .byte $3A ; |  XXX X | $BDB9
       .byte $71 ; | XXX   X| $BDBA
       .byte $31 ; |  XX   X| $BDBB
       .byte $73 ; | XXX  XX| $BDBC
       .byte $34 ; |  XX X  | $BDBD
       .byte $77 ; | XXX XXX| $BDBE
       .byte $34 ; |  XX X  | $BDBF
       .byte $73 ; | XXX  XX| $BDC0
       .byte $73 ; | XXX  XX| $BDC1
       .byte $33 ; |  XX  XX| $BDC2
       .byte $20 ; |  X     | $BDC3
       .byte $2F ; |  X XXXX| $BDC4
       .byte $30 ; |  XX    | $BDC5
       .byte $2F ; |  X XXXX| $BDC6
       .byte $33 ; |  XX  XX| $BDC7
       .byte $34 ; |  XX X  | $BDC8
       .byte $33 ; |  XX  XX| $BDC9
       .byte $77 ; | XXX XXX| $BDCA
       .byte $37 ; |  XX XXX| $BDCB
       .byte $71 ; | XXX   X| $BDCC
       .byte $31 ; |  XX   X| $BDCD
       .byte $74 ; | XXX X  | $BDCE
       .byte $35 ; |  XX X X| $BDCF
       .byte $74 ; | XXX X  | $BDD0
       .byte $33 ; |  XX  XX| $BDD1
       .byte $71 ; | XXX   X| $BDD2
       .byte $33 ; |  XX  XX| $BDD3
       .byte $74 ; | XXX X  | $BDD4
       .byte $37 ; |  XX XXX| $BDD5
       .byte $CB ; |XX  X XX| $BDD6
       .byte $94 ; |X  X X  | $BDD7
       .byte $34 ; |  XX X  | $BDD8
       .byte $35 ; |  XX X X| $BDD9
       .byte $34 ; |  XX X  | $BDDA
       .byte $71 ; | XXX   X| $BDDB
       .byte $31 ; |  XX   X| $BDDC
       .byte $74 ; | XXX X  | $BDDD
       .byte $34 ; |  XX X  | $BDDE
       .byte $D2 ; |XX X  X | $BDDF
       .byte $92 ; |X  X  X | $BDE0
       .byte $32 ; |  XX  X | $BDE1
       .byte $34 ; |  XX X  | $BDE2
       .byte $32 ; |  XX  X | $BDE3
       .byte $6F ; | XX XXXX| $BDE4
       .byte $6F ; | XX XXXX| $BDE5
       .byte $20 ; |  X     | $BDE6
       .byte $8F ; |X   XXXX| $BDE7
       .byte $31 ; |  XX   X| $BDE8
       .byte $32 ; |  XX  X | $BDE9
       .byte $34 ; |  XX X  | $BDEA
       .byte $2D ; |  X XX X| $BDEB
       .byte $20 ; |  X     | $BDEC
       .byte $34 ; |  XX X  | $BDED
       .byte $35 ; |  XX X X| $BDEE
       .byte $38 ; |  XXX   | $BDEF
       .byte $3B ; |  XXX XX| $BDF0
       .byte $32 ; |  XX  X | $BDF1
       .byte $20 ; |  X     | $BDF2
       .byte $31 ; |  XX   X| $BDF3
       .byte $74 ; | XXX X  | $BDF4
       .byte $74 ; | XXX X  | $BDF5
       .byte $74 ; | XXX X  | $BDF6
       .byte $60 ; | XX     | $BDF7
       .byte $FF ; |XXXXXXXX| $BDF8
       .byte $FF ; |XXXXXXXX| $BDF9
       .byte $FF ; |XXXXXXXX| $BDFA
       .byte $FF ; |XXXXXXXX| $BDFB
       .byte $FF ; |XXXXXXXX| $BDFC
       .byte $FF ; |XXXXXXXX| $BDFD
       .byte $FF ; |XXXXXXXX| $BDFE
       .byte $FF ; |XXXXXXXX| $BDFF
       LDA    $B4                     ;3
       STA    PF2                     ;3
       LDY    #$04                    ;2
       STY    $9F                     ;3
       LDA    $99,X                   ;4
       STA    COLUP1                  ;3
       LDA    $9B,X                   ;4
       STA    $A4                     ;3
       LDA    $A2                     ;3
       SBC    #$05                    ;2
       STA    $A2                     ;3
       LDA    ($A2),Y                 ;5
       LDA    ($A2),Y                 ;5
       LDA    ($A2),Y                 ;5
       NOP                            ;2
       STA    RESP1                   ;3
       JMP    LB904                   ;3
       LDA    ($A2),Y                 ;5
       LDA    $B4                     ;3
       STA    PF2                     ;3
       LDY    #$04                    ;2
       STY    $9F                     ;3
       LDA    $99,X                   ;4
       STA    COLUP1                  ;3
       LDA    $9B,X                   ;4
       STA    $A4                     ;3
       LDA    $A2                     ;3
       SBC    #$05                    ;2
       STA    $A2                     ;3
       LDA    ($A2),Y                 ;5
       NOP                            ;2
       STA    RESP1                   ;3
       JMP    LB902                   ;3
       LDA    ($A2),Y                 ;5
       LDA    $B4                     ;3
       STA    PF2                     ;3
       LDY    #$04                    ;2
       STY    $9F                     ;3
       LDA    $99,X                   ;4
       STA    COLUP1                  ;3
       LDA    $9B,X                   ;4
       STA    $A4                     ;3
       LDA    $A2                     ;3
       NOP                            ;2
       STA    RESP1                   ;3
       SBC    #$05                    ;2
       STA    $A2                     ;3
       LDA    ($A2),Y                 ;5
       JMP    LB902                   ;3
       LDA    ($A2),Y                 ;5
       LDA    $B4                     ;3
       STA    PF2                     ;3
       LDY    #$04                    ;2
       STY    $9F                     ;3
       LDA    $99,X                   ;4
       STA    COLUP1                  ;3
       NOP                            ;2
       STA    RESP1                   ;3
       LDA    $9B,X                   ;4
       STA    $A4                     ;3
       LDA    $A2                     ;3
       SBC    #$05                    ;2
       STA    $A2                     ;3
       LDA    ($A2),Y                 ;5
       JMP    LB902                   ;3
       LDA    ($A2),Y                 ;5
       LDA    $B4                     ;3
       STA    PF2                     ;3
       LDY    #$04                    ;2
       NOP                            ;2
       STA    RESP1                   ;3
       STY    $9F                     ;3
       LDA    $99,X                   ;4
       STA    COLUP1                  ;3
       LDA    $9B,X                   ;4
       STA    $A4                     ;3
       LDA    $A2                     ;3
       SBC    #$05                    ;2
       STA    $A2                     ;3
       LDA    ($A2),Y                 ;5
       JMP    LB902                   ;3
       LDA    ($A2),Y                 ;5
       STA    RESP1                   ;3
       LDA    $B4                     ;3
       STA    PF2                     ;3
       LDY    #$04                    ;2
       STY    $9F                     ;3
       LDA    $99,X                   ;4
       STA    COLUP1                  ;3
       LDA    $9B,X                   ;4
       STA    $A4                     ;3
LBEB6: LDA    $A2                     ;3
       SBC    #$05                    ;2
       STA    $A2                     ;3
       LDA    ($A2),Y                 ;5
       JMP    LB902                   ;3
       .byte $92 ; |X  X  X | $BEC1
       .byte $8F ; |X   XXXX| $BEC2
       .byte $98 ; |X  XX   | $BEC3
       .byte $8F ; |X   XXXX| $BEC4
       .byte $92 ; |X  X  X | $BEC5
       .byte $8F ; |X   XXXX| $BEC6
       .byte $98 ; |X  XX   | $BEC7
       .byte $8F ; |X   XXXX| $BEC8
       .byte $90 ; |X  X    | $BEC9
       .byte $8D ; |X   XX X| $BECA
       .byte $98 ; |X  XX   | $BECB
       .byte $8D ; |X   XX X| $BECC
       .byte $92 ; |X  X  X | $BECD
       .byte $8F ; |X   XXXX| $BECE
       .byte $98 ; |X  XX   | $BECF
       .byte $8F ; |X   XXXX| $BED0
       .byte $90 ; |X  X    | $BED1
       .byte $8D ; |X   XX X| $BED2
       .byte $98 ; |X  XX   | $BED3
       .byte $8D ; |X   XX X| $BED4
       .byte $93 ; |X  X  XX| $BED5
       .byte $8D ; |X   XX X| $BED6
       .byte $98 ; |X  XX   | $BED7
       .byte $8D ; |X   XX X| $BED8
       .byte $92 ; |X  X  X | $BED9
       .byte $8F ; |X   XXXX| $BEDA
       .byte $9B ; |X  XX XX| $BEDB
       .byte $8F ; |X   XXXX| $BEDC
       .byte $93 ; |X  X  XX| $BEDD
       .byte $98 ; |X  XX   | $BEDE
       .byte $96 ; |X  X XX | $BEDF
       .byte $93 ; |X  X  XX| $BEE0
       .byte $92 ; |X  X  X | $BEE1
       .byte $8F ; |X   XXXX| $BEE2
       .byte $98 ; |X  XX   | $BEE3
       .byte $8F ; |X   XXXX| $BEE4
       .byte $92 ; |X  X  X | $BEE5
       .byte $8F ; |X   XXXX| $BEE6
       .byte $98 ; |X  XX   | $BEE7
       .byte $8F ; |X   XXXX| $BEE8
       .byte $97 ; |X  X XXX| $BEE9
       .byte $8F ; |X   XXXX| $BEEA
       .byte $9F ; |X  XXXXX| $BEEB
       .byte $8F ; |X   XXXX| $BEEC
       .byte $97 ; |X  X XXX| $BEED
       .byte $8F ; |X   XXXX| $BEEE
       .byte $9F ; |X  XXXXX| $BEEF
       .byte $8F ; |X   XXXX| $BEF0
       .byte $8F ; |X   XXXX| $BEF1
       .byte $8F ; |X   XXXX| $BEF2
       .byte $94 ; |X  X X  | $BEF3
       .byte $8F ; |X   XXXX| $BEF4
       .byte $98 ; |X  XX   | $BEF5
       .byte $94 ; |X  X X  | $BEF6
       .byte $9F ; |X  XXXXX| $BEF7
       .byte $98 ; |X  XX   | $BEF8
       .byte $34 ; |  XX X  | $BEF9
       .byte $20 ; |  X     | $BEFA
       .byte $00 ; |        | $BEFB
       .byte $34 ; |  XX X  | $BEFC
       .byte $20 ; |  X     | $BEFD
       .byte $6F ; | XX XXXX| $BEFE
       .byte $2F ; |  X XXXX| $BEFF
       LDA    ($A2),Y                 ;5
       STA    RESP0                   ;3
       JMP    LB7F5                   ;3
       LDA    ($A2),Y                 ;5
       LDA    $BF                     ;3
       STA    PF2                     ;3
       LDA    $8C,X                   ;4
       STA    RESP0                   ;3
       JMP    LB7FB                   ;3
       LDA    ($A2),Y                 ;5
       LDA    $BF                     ;3
       STA    PF2                     ;3
       LDA    $8C,X                   ;4
       STA    $A2                     ;3
       LDA    $88,X                   ;4
       STA    COLUP0                  ;3
       STA    RESP0                   ;3
       JMP    LB801                   ;3
       LDA    ($A2),Y                 ;5
       LDA    $BF                     ;3
       STA    PF2                     ;3
       LDA    $8C,X                   ;4
       STA    $A2                     ;3
       LDA    $88,X                   ;4
       STA    COLUP0                  ;3
       LDY    #$04                    ;2
       STY    $94                     ;3
       LDA    $A4                     ;3
       SBC    #$05                    ;2
       STA    RESP0                   ;3
       JMP    LB809                   ;3
       LDA    ($A2),Y                 ;5
       LDA    $BF                     ;3
       STA    PF2                     ;3
       LDA    $8C,X                   ;4
       STA    $A2                     ;3
       LDA    $88,X                   ;4
       STA    COLUP0                  ;3
       LDY    #$04                    ;2
       STY    $94                     ;3
       LDA    $A4                     ;3
       SBC    #$05                    ;2
       STA    $A4                     ;3
       NOP                            ;2
       LDA    ($A2),Y                 ;5
       STA    RESP0                   ;3
       JMP    LB80D                   ;3
       LDA    $BF                     ;3
       STA    PF2                     ;3
       LDA    $8C,X                   ;4
       STA    $A2                     ;3
       LDA    $88,X                   ;4
       STA    COLUP0                  ;3
       LDY    #$04                    ;2
       STY    $94                     ;3
       LDA    $A4                     ;3
       SBC    #$05                    ;2
       STA    $A4                     ;3
       NOP                            ;2
       LDA    ($A2),Y                 ;5
       LDA    ($A2),Y                 ;5
       LDA    ($A2),Y                 ;5
       STA    RESP0                   ;3
       JMP    LB80F                   ;3
       .byte $0D ; |    XX X| $BF84
       .byte $0E ; |    XXX | $BF85
       .byte $8D ; |X   XX X| $BF86
       .byte $0D ; |    XX X| $BF87
       .byte $0E ; |    XXX | $BF88
       .byte $8D ; |X   XX X| $BF89
       .byte $0D ; |    XX X| $BF8A
       .byte $0E ; |    XXX | $BF8B
       .byte $0D ; |    XX X| $BF8C
       .byte $B2 ; |X XX  X | $BF8D
       .byte $32 ; |  XX  X | $BF8E
       .byte $11 ; |   X   X| $BF8F
       .byte $12 ; |   X  X | $BF90
       .byte $91 ; |X  X   X| $BF91
       .byte $0D ; |    XX X| $BF92
       .byte $0E ; |    XXX | $BF93
       .byte $8D ; |X   XX X| $BF94
       .byte $72 ; | XXX  X | $BF95
       .byte $32 ; |  XX  X | $BF96
       .byte $37 ; |  XX XXX| $BF97
       .byte $14 ; |   X X  | $BF98
       .byte $15 ; |   X X X| $BF99
       .byte $94 ; |X  X X  | $BF9A
       .byte $18 ; |   XX   | $BF9B
       .byte $19 ; |   XX  X| $BF9C
       .byte $98 ; |X  XX   | $BF9D
       .byte $11 ; |   X   X| $BF9E
       .byte $12 ; |   X  X | $BF9F
       .byte $11 ; |   X   X| $BFA0
       .byte $5D ; | X XXX X| $BFA1
       .byte $34 ; |  XX X  | $BFA2
       .byte $17 ; |   X XXX| $BFA3
       .byte $18 ; |   XX   | $BFA4
       .byte $97 ; |X  X XXX| $BFA5
       .byte $13 ; |   X  XX| $BFA6
       .byte $14 ; |   X X  | $BFA7
       .byte $93 ; |X  X  XX| $BFA8
       .byte $72 ; | XXX  X | $BFA9
       .byte $92 ; |X  X  X | $BFAA
       .byte $32 ; |  XX  X | $BFAB
       .byte $0D ; |    XX X| $BFAC
       .byte $0E ; |    XXX | $BFAD
       .byte $8D ; |X   XX X| $BFAE
       .byte $0D ; |    XX X| $BFAF
       .byte $0E ; |    XXX | $BFB0
       .byte $8D ; |X   XX X| $BFB1
       .byte $0D ; |    XX X| $BFB2
       .byte $0E ; |    XXX | $BFB3
       .byte $0D ; |    XX X| $BFB4
       .byte $52 ; | X X  X | $BFB5
       .byte $2F ; |  X XXXX| $BFB6
       .byte $11 ; |   X   X| $BFB7
       .byte $12 ; |   X  X | $BFB8
       .byte $91 ; |X  X   X| $BFB9
       .byte $17 ; |   X XXX| $BFBA
       .byte $18 ; |   XX   | $BFBB
       .byte $97 ; |X  X XXX| $BFBC
       .byte $71 ; | XXX   X| $BFBD
       .byte $31 ; |  XX   X| $BFBE
       .byte $30 ; |  XX    | $BFBF
       .byte $0F ; |    XXXX| $BFC0
       .byte $10 ; |   X    | $BFC1
       .byte $8F ; |X   XXXX| $BFC2
       .byte $12 ; |   X  X | $BFC3
       .byte $13 ; |   X  XX| $BFC4
       .byte $92 ; |X  X  X | $BFC5
       .byte $0F ; |    XXXX| $BFC6
       .byte $10 ; |   X    | $BFC7
       .byte $8F ; |X   XXXX| $BFC8
       .byte $0B ; |    X XX| $BFC9
       .byte $0C ; |    XX  | $BFCA
       .byte $8B ; |X   X XX| $BFCB
       .byte $1F ; |   XXXXX| $BFCC
       .byte $0A ; |    X X | $BFCD
       .byte $9F ; |X  XXXXX| $BFCE
       .byte $3F ; |  XXXXXX| $BFCF
       .byte $12 ; |   X  X | $BFD0
       .byte $34 ; |  XX X  | $BFD1
       .byte $77 ; | XXX XXX| $BFD2
       .byte $37 ; |  XX XXX| $BFD3
       .byte $FF ; |XXXXXXXX| $BFD4
       .byte $FF ; |XXXXXXXX| $BFD5
       .byte $FF ; |XXXXXXXX| $BFD6
       .byte $FF ; |XXXXXXXX| $BFD7
       .byte $FF ; |XXXXXXXX| $BFD8
       .byte $FF ; |XXXXXXXX| $BFD9
LBFDA: STA    BANK4                   ;4
       .byte $FF ; |XXXXXXXX| $BFDD

STRT2: STA    BANK4                   ;4
       LDA    ($A9),Y                 ;5
       JMP    LBFDA                   ;3
       .byte $FF ; |XXXXXXXX| $BFE6
       .byte $FF ; |XXXXXXXX| $BFE7
       .byte $FF ; |XXXXXXXX| $BFE8
       .byte $FF ; |XXXXXXXX| $BFE9
       .byte $FF ; |XXXXXXXX| $BFEA
       .byte $FF ; |XXXXXXXX| $BFEB
       .byte $FF ; |XXXXXXXX| $BFEC
       .byte $FF ; |XXXXXXXX| $BFED
       .byte $FF ; |XXXXXXXX| $BFEE
       .byte $FF ; |XXXXXXXX| $BFEF
LBFF0: STA    BANK4                   ;4
       JMP.ind ($CC)                  ;5

       ORG $2FF6
       RORG $BFF6
       .byte $FF ; |XXXXXXXX| $BFF6
       .byte $FF ; |XXXXXXXX| $BFF7
       .byte $FF ; |XXXXXXXX| $BFF8
       .byte $00 ; |        | $BFF9
       .byte $FF ; |XXXXXXXX| $BFFA
       .byte $FF ; |XXXXXXXX| $BFFB
       .word STRT2,INIT2





























       ORG $3000
       RORG $D000

       .byte $FF ; |XXXXXXXX| $D000
       .byte $FF ; |XXXXXXXX| $D001
       .byte $FF ; |XXXXXXXX| $D002
       .byte $FF ; |XXXXXXXX| $D003
       .byte $FF ; |XXXXXXXX| $D004
       .byte $FF ; |XXXXXXXX| $D005
       .byte $FF ; |XXXXXXXX| $D006
       .byte $FF ; |XXXXXXXX| $D007
       .byte $FF ; |XXXXXXXX| $D008
       .byte $FF ; |XXXXXXXX| $D009
       .byte $FF ; |XXXXXXXX| $D00A
       .byte $FF ; |XXXXXXXX| $D00B
       .byte $FF ; |XXXXXXXX| $D00C
       .byte $FF ; |XXXXXXXX| $D00D
       .byte $FF ; |XXXXXXXX| $D00E
       .byte $FF ; |XXXXXXXX| $D00F
       .byte $FF ; |XXXXXXXX| $D010
       .byte $FF ; |XXXXXXXX| $D011
LD012: .byte $FF ; |XXXXXXXX| $D012
       .byte $FF ; |XXXXXXXX| $D013
       .byte $FF ; |XXXXXXXX| $D014
       .byte $FF ; |XXXXXXXX| $D015
       .byte $FF ; |XXXXXXXX| $D016
       .byte $FF ; |XXXXXXXX| $D017
       .byte $FF ; |XXXXXXXX| $D018
       .byte $FF ; |XXXXXXXX| $D019
       .byte $FF ; |XXXXXXXX| $D01A
       .byte $FF ; |XXXXXXXX| $D01B
       .byte $FF ; |XXXXXXXX| $D01C
       .byte $FF ; |XXXXXXXX| $D01D
       .byte $FF ; |XXXXXXXX| $D01E
       .byte $FF ; |XXXXXXXX| $D01F
       .byte $FF ; |XXXXXXXX| $D020
       .byte $FF ; |XXXXXXXX| $D021
       .byte $FF ; |XXXXXXXX| $D022
       .byte $FF ; |XXXXXXXX| $D023
LD024: .byte $FF ; |XXXXXXXX| $D024
       .byte $FF ; |XXXXXXXX| $D025
       .byte $FF ; |XXXXXXXX| $D026
       .byte $FF ; |XXXXXXXX| $D027
       .byte $FF ; |XXXXXXXX| $D028
       .byte $FF ; |XXXXXXXX| $D029
       .byte $FF ; |XXXXXXXX| $D02A
       .byte $FF ; |XXXXXXXX| $D02B
       .byte $FF ; |XXXXXXXX| $D02C
       .byte $FF ; |XXXXXXXX| $D02D
       .byte $FF ; |XXXXXXXX| $D02E
       .byte $FF ; |XXXXXXXX| $D02F
       .byte $FF ; |XXXXXXXX| $D030
       .byte $FF ; |XXXXXXXX| $D031
       .byte $FF ; |XXXXXXXX| $D032
       .byte $FF ; |XXXXXXXX| $D033
       .byte $FF ; |XXXXXXXX| $D034
       .byte $FF ; |XXXXXXXX| $D035
       .byte $FF ; |XXXXXXXX| $D036
       .byte $FF ; |XXXXXXXX| $D037
       .byte $FF ; |XXXXXXXX| $D038
       .byte $FF ; |XXXXXXXX| $D039
       .byte $FF ; |XXXXXXXX| $D03A
       .byte $FF ; |XXXXXXXX| $D03B
       .byte $FF ; |XXXXXXXX| $D03C
       .byte $FF ; |XXXXXXXX| $D03D
       .byte $FF ; |XXXXXXXX| $D03E
       .byte $FF ; |XXXXXXXX| $D03F
       .byte $FF ; |XXXXXXXX| $D040
       .byte $FF ; |XXXXXXXX| $D041
       .byte $FF ; |XXXXXXXX| $D042
       .byte $FF ; |XXXXXXXX| $D043
       .byte $FF ; |XXXXXXXX| $D044
       .byte $FF ; |XXXXXXXX| $D045
       .byte $FF ; |XXXXXXXX| $D046
       .byte $FF ; |XXXXXXXX| $D047
LD048: .byte $FF ; |XXXXXXXX| $D048
       .byte $FF ; |XXXXXXXX| $D049
       .byte $FF ; |XXXXXXXX| $D04A
       .byte $FF ; |XXXXXXXX| $D04B
       .byte $FF ; |XXXXXXXX| $D04C
       .byte $FF ; |XXXXXXXX| $D04D
       .byte $FF ; |XXXXXXXX| $D04E
       .byte $FF ; |XXXXXXXX| $D04F
       .byte $FF ; |XXXXXXXX| $D050
       .byte $FF ; |XXXXXXXX| $D051
       .byte $FF ; |XXXXXXXX| $D052
       .byte $FF ; |XXXXXXXX| $D053
       .byte $FF ; |XXXXXXXX| $D054
       .byte $FF ; |XXXXXXXX| $D055
       .byte $FF ; |XXXXXXXX| $D056
       .byte $FF ; |XXXXXXXX| $D057
       .byte $FF ; |XXXXXXXX| $D058
       .byte $FF ; |XXXXXXXX| $D059
LD05A: .byte $FF ; |XXXXXXXX| $D05A
       .byte $FF ; |XXXXXXXX| $D05B
       .byte $FF ; |XXXXXXXX| $D05C
       .byte $FF ; |XXXXXXXX| $D05D
       .byte $FF ; |XXXXXXXX| $D05E
       .byte $FF ; |XXXXXXXX| $D05F
       .byte $FF ; |XXXXXXXX| $D060
       .byte $FF ; |XXXXXXXX| $D061
       .byte $FF ; |XXXXXXXX| $D062
       .byte $FF ; |XXXXXXXX| $D063
       .byte $FF ; |XXXXXXXX| $D064
       .byte $FF ; |XXXXXXXX| $D065
       .byte $FF ; |XXXXXXXX| $D066
       .byte $FF ; |XXXXXXXX| $D067
       .byte $FF ; |XXXXXXXX| $D068
       .byte $FF ; |XXXXXXXX| $D069
       .byte $FF ; |XXXXXXXX| $D06A
       .byte $FF ; |XXXXXXXX| $D06B
       .byte $FF ; |XXXXXXXX| $D06C
       .byte $FF ; |XXXXXXXX| $D06D
       .byte $FF ; |XXXXXXXX| $D06E
       .byte $FF ; |XXXXXXXX| $D06F
       .byte $FF ; |XXXXXXXX| $D070
       .byte $FF ; |XXXXXXXX| $D071
       .byte $FF ; |XXXXXXXX| $D072
       .byte $FF ; |XXXXXXXX| $D073
       .byte $FF ; |XXXXXXXX| $D074
       .byte $FF ; |XXXXXXXX| $D075
       .byte $FF ; |XXXXXXXX| $D076
       .byte $FF ; |XXXXXXXX| $D077
       .byte $FF ; |XXXXXXXX| $D078
       .byte $FF ; |XXXXXXXX| $D079
       .byte $FF ; |XXXXXXXX| $D07A
       .byte $FF ; |XXXXXXXX| $D07B
       .byte $FF ; |XXXXXXXX| $D07C
       .byte $FF ; |XXXXXXXX| $D07D
       .byte $FF ; |XXXXXXXX| $D07E
       .byte $FF ; |XXXXXXXX| $D07F
LD080: .byte $FF ; |XXXXXXXX| $D080
       .byte $FF ; |XXXXXXXX| $D081
       .byte $FF ; |XXXXXXXX| $D082
       .byte $FF ; |XXXXXXXX| $D083
       .byte $FF ; |XXXXXXXX| $D084
       .byte $FF ; |XXXXXXXX| $D085
       .byte $FF ; |XXXXXXXX| $D086
       .byte $FF ; |XXXXXXXX| $D087
       .byte $FF ; |XXXXXXXX| $D088
       .byte $FF ; |XXXXXXXX| $D089
       .byte $FF ; |XXXXXXXX| $D08A
       .byte $FF ; |XXXXXXXX| $D08B
       .byte $FF ; |XXXXXXXX| $D08C
       .byte $FF ; |XXXXXXXX| $D08D
       .byte $FF ; |XXXXXXXX| $D08E
       .byte $FF ; |XXXXXXXX| $D08F
       .byte $FF ; |XXXXXXXX| $D090
       .byte $FF ; |XXXXXXXX| $D091
LD092: .byte $FF ; |XXXXXXXX| $D092
       .byte $FF ; |XXXXXXXX| $D093
       .byte $FF ; |XXXXXXXX| $D094
       .byte $FF ; |XXXXXXXX| $D095
       .byte $FF ; |XXXXXXXX| $D096
       .byte $FF ; |XXXXXXXX| $D097
       .byte $FF ; |XXXXXXXX| $D098
       .byte $FF ; |XXXXXXXX| $D099
       .byte $FF ; |XXXXXXXX| $D09A
       .byte $FF ; |XXXXXXXX| $D09B
       .byte $FF ; |XXXXXXXX| $D09C
       .byte $FF ; |XXXXXXXX| $D09D
       .byte $FF ; |XXXXXXXX| $D09E
       .byte $FF ; |XXXXXXXX| $D09F
       .byte $FF ; |XXXXXXXX| $D0A0
       .byte $FF ; |XXXXXXXX| $D0A1
       .byte $FF ; |XXXXXXXX| $D0A2
       .byte $FF ; |XXXXXXXX| $D0A3
LD0A4: .byte $FF ; |XXXXXXXX| $D0A4
       .byte $FF ; |XXXXXXXX| $D0A5
       .byte $FF ; |XXXXXXXX| $D0A6
       .byte $FF ; |XXXXXXXX| $D0A7
       .byte $FF ; |XXXXXXXX| $D0A8
       .byte $FF ; |XXXXXXXX| $D0A9
       .byte $FF ; |XXXXXXXX| $D0AA
       .byte $FF ; |XXXXXXXX| $D0AB
       .byte $FF ; |XXXXXXXX| $D0AC
       .byte $FF ; |XXXXXXXX| $D0AD
       .byte $FF ; |XXXXXXXX| $D0AE
       .byte $FF ; |XXXXXXXX| $D0AF
       .byte $FF ; |XXXXXXXX| $D0B0
       .byte $FF ; |XXXXXXXX| $D0B1
       .byte $FF ; |XXXXXXXX| $D0B2
       .byte $FF ; |XXXXXXXX| $D0B3
       .byte $FF ; |XXXXXXXX| $D0B4
       .byte $FF ; |XXXXXXXX| $D0B5
LD0B6: .byte $FF ; |XXXXXXXX| $D0B6
       .byte $FF ; |XXXXXXXX| $D0B7
       .byte $FF ; |XXXXXXXX| $D0B8
       .byte $FF ; |XXXXXXXX| $D0B9
       .byte $FF ; |XXXXXXXX| $D0BA
       .byte $FF ; |XXXXXXXX| $D0BB
       .byte $FF ; |XXXXXXXX| $D0BC
       .byte $FF ; |XXXXXXXX| $D0BD
       .byte $FF ; |XXXXXXXX| $D0BE
       .byte $FF ; |XXXXXXXX| $D0BF
       .byte $FF ; |XXXXXXXX| $D0C0
       .byte $FF ; |XXXXXXXX| $D0C1
       .byte $FF ; |XXXXXXXX| $D0C2
       .byte $FF ; |XXXXXXXX| $D0C3
       .byte $FF ; |XXXXXXXX| $D0C4
       .byte $FF ; |XXXXXXXX| $D0C5
       .byte $FF ; |XXXXXXXX| $D0C6
       .byte $FF ; |XXXXXXXX| $D0C7
LD0C8: .byte $FF ; |XXXXXXXX| $D0C8
       .byte $FF ; |XXXXXXXX| $D0C9
       .byte $FF ; |XXXXXXXX| $D0CA
       .byte $FF ; |XXXXXXXX| $D0CB
       .byte $FF ; |XXXXXXXX| $D0CC
       .byte $FF ; |XXXXXXXX| $D0CD
       .byte $FF ; |XXXXXXXX| $D0CE
       .byte $FF ; |XXXXXXXX| $D0CF
       .byte $FF ; |XXXXXXXX| $D0D0
       .byte $FF ; |XXXXXXXX| $D0D1
       .byte $FF ; |XXXXXXXX| $D0D2
       .byte $FF ; |XXXXXXXX| $D0D3
       .byte $FF ; |XXXXXXXX| $D0D4
       .byte $FF ; |XXXXXXXX| $D0D5
       .byte $FF ; |XXXXXXXX| $D0D6
       .byte $FF ; |XXXXXXXX| $D0D7
       .byte $FF ; |XXXXXXXX| $D0D8
       .byte $FF ; |XXXXXXXX| $D0D9
LD0DA: .byte $FF ; |XXXXXXXX| $D0DA
       .byte $FF ; |XXXXXXXX| $D0DB
       .byte $FF ; |XXXXXXXX| $D0DC
       .byte $FF ; |XXXXXXXX| $D0DD
       .byte $FF ; |XXXXXXXX| $D0DE
       .byte $FF ; |XXXXXXXX| $D0DF
       .byte $FF ; |XXXXXXXX| $D0E0
       .byte $FF ; |XXXXXXXX| $D0E1
       .byte $FF ; |XXXXXXXX| $D0E2
       .byte $FF ; |XXXXXXXX| $D0E3
       .byte $FF ; |XXXXXXXX| $D0E4
       .byte $FF ; |XXXXXXXX| $D0E5
       .byte $FF ; |XXXXXXXX| $D0E6
       .byte $FF ; |XXXXXXXX| $D0E7
       .byte $FF ; |XXXXXXXX| $D0E8
       .byte $FF ; |XXXXXXXX| $D0E9
       .byte $FF ; |XXXXXXXX| $D0EA
       .byte $FF ; |XXXXXXXX| $D0EB
LD0EC: .byte $FF ; |XXXXXXXX| $D0EC
       .byte $FF ; |XXXXXXXX| $D0ED
       .byte $FF ; |XXXXXXXX| $D0EE
       .byte $FF ; |XXXXXXXX| $D0EF
       .byte $FF ; |XXXXXXXX| $D0F0
       .byte $FF ; |XXXXXXXX| $D0F1
       .byte $FF ; |XXXXXXXX| $D0F2
       .byte $FF ; |XXXXXXXX| $D0F3
       .byte $FF ; |XXXXXXXX| $D0F4
       .byte $FF ; |XXXXXXXX| $D0F5
       .byte $FF ; |XXXXXXXX| $D0F6
       .byte $FF ; |XXXXXXXX| $D0F7
       .byte $FF ; |XXXXXXXX| $D0F8
       .byte $FF ; |XXXXXXXX| $D0F9
       .byte $FF ; |XXXXXXXX| $D0FA
       .byte $FF ; |XXXXXXXX| $D0FB
       .byte $FF ; |XXXXXXXX| $D0FC
       .byte $FF ; |XXXXXXXX| $D0FD
       .byte $FF ; |XXXXXXXX| $D0FE
       .byte $FF ; |XXXXXXXX| $D0FF

STRT3: STA    BANK4                   ;4
LD103: STA    $B3                     ;3
       LDA    $DD,X                   ;4
       AND    #$C0                    ;2
       ORA    $B3                     ;3
       STA    $DD,X                   ;4
       LDX    $F6                     ;3
       LDA    LD565,X                 ;4
       STA    $A9                     ;3
       LDA    LDAF7,X                 ;4
       STA    $AA                     ;3
       LDY    LDA46,X                 ;4
       LDA    $F3                     ;3
       CMP    #$06                    ;2
       BNE    LD131                   ;2
       LDA    $D5                     ;3
       CMP    #$70                    ;2
       BCS    LD131                   ;2
       LDA    $D5                     ;3
       AND    #$10                    ;2
       BEQ    LD131                   ;2
       LDY    LDA4D,X                 ;4
LD131: STY    COLUPF                  ;3
       LDA    #$03                    ;2
       STA    $AF                     ;3
       LSR                            ;2
       STA    $B0                     ;3
       LDA    #$B1                    ;2
       STA    $A5                     ;3
       STA    $A3                     ;3
       LDA    #$0A                    ;2
       STA    $A4                     ;3
       STA    $A2                     ;3
       LDA    #$78                    ;2
       STA    $90                     ;3
       LSR                            ;2
       STA    $9E                     ;3
       STA    $93                     ;3
       LDA    #$64                    ;2
       STA    $91                     ;3
       LDA    #$50                    ;2
       STA    $9D                     ;3
       STA    $92                     ;3
       LSR                            ;2
       STA    $9F                     ;3
       STA    $94                     ;3
       LDY    $D0                     ;3
       LDA    LD900,Y                 ;4
       LSR                            ;2
       BCS    LD16C                   ;2
       TAX                            ;2
       LDA    LDB00,Y                 ;4
       BCC    LD172                   ;2
LD16C: TAX                            ;2
       LDA    LDB00,Y                 ;4
       ADC    #$09                    ;2
LD172: TAY                            ;2
       STX    $AB                     ;3
       STY    $AC                     ;3
       TXA                            ;2
       ASL                            ;2
       ASL                            ;2
       TAX                            ;2
       ADC    LD594,Y                 ;4
       STA    $B4                     ;3
       TXA                            ;2
       ADC    LD5B8,Y                 ;4
       STA    $B5                     ;3
       LDA    LD607,Y                 ;4
       STA    $B7                     ;3
       LDX    #$04                    ;2
       LDA    $BF                     ;3
       BMI    LD192                   ;2
       INX                            ;2
LD192: STX    $B2                     ;3
       LDA    $DD,X                   ;4
       AND    #$3F                    ;2
       TAY                            ;2
       LDA    LDA54,Y                 ;4
       STA    $9A                     ;3
       LDA    LDDE9,Y                 ;4
       STA    $9C                     ;3
       LDA    LDCDB,Y                 ;4
       STA    $98                     ;3
       JSR    LD641                   ;6
       ADC    $9C                     ;3
       STA    $9C                     ;3
       TXA                            ;2
       ASL                            ;2
       SEC                            ;2
       SBC    #$01                    ;2
       SEC                            ;2
       SBC    $B5                     ;3
       STA    $9F                     ;3
       LDY    $B2                     ;3
       LDA.wy $E4,Y                   ;4
       TAY                            ;2
       LDA    LD74B,Y                 ;4
       AND    #$F0                    ;2
       ORA    $98                     ;3
       STA    $98                     ;3
       LDA    LD74B,Y                 ;4
       AND    #$0F                    ;2
       STA    $B8                     ;3
       TAY                            ;2
       TXA                            ;2
       LDX    $9F                     ;3
       ROR                            ;2
       BCS    LD1E3                   ;2
       LDA    LD699,Y                 ;4
       CPX    $B7                     ;3
       BCC    LD1ED                   ;2
       LDA    LD6C5,Y                 ;4
       JMP    LD1ED                   ;3
LD1E3: LDA    LD6AF,Y                 ;4
       CPX    $B7                     ;3
       BCC    LD1ED                   ;2
       LDA    LD6D0,Y                 ;4
LD1ED: STA    $96                     ;3
       LDX    #$04                    ;2
       LDA    $BF                     ;3
       BPL    LD1FC                   ;2
       LDA    $BE                     ;3
       BMI    LD25B                   ;2
       INX                            ;2
       BPL    LD200                   ;2
LD1FC: LDA    $BD                     ;3
       BMI    LD25B                   ;2
LD200: STX    $B2                     ;3
       LDA    $DD,X                   ;4
       AND    #$3F                    ;2
       TAY                            ;2
       LDA    LDA54,Y                 ;4
       STA    $99                     ;3
       LDA    LDDE9,Y                 ;4
       STA    $9B                     ;3
       LDA    LDCDB,Y                 ;4
       STA    $97                     ;3
       JSR    LD641                   ;6
       ADC    $9B                     ;3
       STA    $9B                     ;3
       TXA                            ;2
       ASL                            ;2
       SEC                            ;2
       SBC    #$01                    ;2
       SEC                            ;2
       SBC    $B5                     ;3
       STA    $9E                     ;3
       LDY    $B2                     ;3
       LDA.wy $E4,Y                   ;4
       TAY                            ;2
       LDA    LD74B,Y                 ;4
       AND    #$F0                    ;2
       ORA    $97                     ;3
       STA    $97                     ;3
       LDA    LD74B,Y                 ;4
       AND    #$0F                    ;2
       TAY                            ;2
       TXA                            ;2
       LDX    $9E                     ;3
       ROR                            ;2
       BCS    LD24F                   ;2
       LDA    LD699,Y                 ;4
       CPX    $B7                     ;3
       BCC    LD259                   ;2
       LDA    LD6C5,Y                 ;4
       JMP    LD259                   ;3
LD24F: LDA    LD6AF,Y                 ;4
       CPX    $B7                     ;3
       BCC    LD259                   ;2
       LDA    LD6D0,Y                 ;4
LD259: STA    $95                     ;3
LD25B: LDY    $B6                     ;3
       BNE    LD266                   ;2
       LDA    $C1                     ;3
       BPL    LD266                   ;2
       JMP    LD3A8                   ;3
LD266: LDX    $C6,Y                   ;4
       JSR    LD61B                   ;6
       STA    $8B                     ;3
       LDA    LDDDD,Y                 ;4
       STA    $8F                     ;3
       LDA    LD6DB,Y                 ;4
       STA    $87                     ;3
       JSR    LD64D                   ;6
       ADC    $8F                     ;3
       STA    $8F                     ;3
       TXA                            ;2
       ASL                            ;2
       CLC                            ;2
       ADC    #$01                    ;2
       SEC                            ;2
       SBC    $B4                     ;3
       STA    $94                     ;3
       LDY    $B6                     ;3
       LDA.wy $C6,Y                   ;4
       TAY                            ;2
       LDA.wy $E4,Y                   ;4
       TAY                            ;2
       LDA    LD74B,Y                 ;4
       AND    #$F0                    ;2
       ORA    $87                     ;3
       STA    $87                     ;3
       LDA    LD74B,Y                 ;4
       AND    #$0F                    ;2
       STA    $B3                     ;3
       TAY                            ;2
       TXA                            ;2
       ROR                            ;2
       BCS    LD2AD                   ;2
       LDA    LD6A4,Y                 ;4
       JMP    LD2B0                   ;3
LD2AD: LDA    LD6BA,Y                 ;4
LD2B0: STA    $83                     ;3
       DEC    $B6                     ;5
       LDY    $B6                     ;3
       BPL    LD2BB                   ;2
       JMP    LD3A8                   ;3
LD2BB: LDX    $C6,Y                   ;4
       JSR    LD61B                   ;6
       STA    $8A                     ;3
       LDA    LDDDD,Y                 ;4
       STA    $8E                     ;3
       LDA    LD6DB,Y                 ;4
       STA    $86                     ;3
       JSR    LD64D                   ;6
       ADC    $8E                     ;3
       STA    $8E                     ;3
       TXA                            ;2
       ASL                            ;2
       CLC                            ;2
       ADC    #$01                    ;2
       SEC                            ;2
       SBC    $B4                     ;3
       STA    $93                     ;3
       LDY    $B6                     ;3
       LDA.wy $C6,Y                   ;4
       TAY                            ;2
       LDA.wy $E4,Y                   ;4
       TAY                            ;2
       LDA    LD74B,Y                 ;4
       AND    #$F0                    ;2
       ORA    $86                     ;3
       STA    $86                     ;3
       LDA    LD74B,Y                 ;4
       AND    #$0F                    ;2
       TAY                            ;2
       TXA                            ;2
       ROR                            ;2
       BCS    LD300                   ;2
       LDA    LD6A4,Y                 ;4
       JMP    LD303                   ;3
LD300: LDA    LD6BA,Y                 ;4
LD303: STA    $82                     ;3
       DEC    $B6                     ;5
       LDY    $B6                     ;3
       BPL    LD30E                   ;2
       JMP    LD3A8                   ;3
LD30E: LDX    $C6,Y                   ;4
       JSR    LD61B                   ;6
       STA    $89                     ;3
       LDA    LDDDD,Y                 ;4
       STA    $8D                     ;3
       LDA    LD6DB,Y                 ;4
       STA    $85                     ;3
       JSR    LD64D                   ;6
       ADC    $8D                     ;3
       STA    $8D                     ;3
       TXA                            ;2
       ASL                            ;2
       CLC                            ;2
       ADC    #$01                    ;2
       SEC                            ;2
       SBC    $B4                     ;3
       STA    $92                     ;3
       LDY    $B6                     ;3
       LDA.wy $C6,Y                   ;4
       TAY                            ;2
       LDA.wy $E4,Y                   ;4
       TAY                            ;2
       LDA    LD74B,Y                 ;4
       AND    #$F0                    ;2
       ORA    $85                     ;3
       STA    $85                     ;3
       LDA    LD74B,Y                 ;4
       AND    #$0F                    ;2
       TAY                            ;2
       TXA                            ;2
       ROR                            ;2
       BCS    LD353                   ;2
       LDA    LD6A4,Y                 ;4
       JMP    LD356                   ;3
LD353: LDA    LD6BA,Y                 ;4
LD356: STA    $81                     ;3
       DEC    $B6                     ;5
       LDY    $B6                     ;3
       BMI    LD3A8                   ;2
       LDX    $C6,Y                   ;4
       JSR    LD61B                   ;6
       STA    $88                     ;3
       LDA    LDDDD,Y                 ;4
       STA    $8C                     ;3
       LDA    LD6DB,Y                 ;4
       STA    $84                     ;3
       JSR    LD64D                   ;6
       ADC    $8C                     ;3
       STA    $8C                     ;3
       TXA                            ;2
       ASL                            ;2
       CLC                            ;2
       ADC    #$01                    ;2
       SEC                            ;2
       SBC    $B4                     ;3
       STA    $91                     ;3
       LDY    $B6                     ;3
       LDA.wy $C6,Y                   ;4
       TAY                            ;2
       LDA.wy $E4,Y                   ;4
       TAY                            ;2
       LDA    LD74B,Y                 ;4
       AND    #$F0                    ;2
       ORA    $84                     ;3
       STA    $84                     ;3
       LDA    LD74B,Y                 ;4
       AND    #$0F                    ;2
       TAY                            ;2
       TXA                            ;2
       ROR                            ;2
       BCS    LD3A3                   ;2
       LDA    LD6A4,Y                 ;4
       JMP    LD3A6                   ;3
LD3A3: LDA    LD6BA,Y                 ;4
LD3A6: STA    $80                     ;3
LD3A8: STA    HMCLR                   ;3
       LDY    $AC                     ;3
       LDA    $91                     ;3
       SEC                            ;2
       SBC    #$06                    ;2
       SBC    $92                     ;3
       STA    $91                     ;3
       LDA    $92                     ;3
       SEC                            ;2
       SBC    #$06                    ;2
       SBC    $93                     ;3
       STA    $92                     ;3
       LDA    $93                     ;3
       SEC                            ;2
       SBC    #$06                    ;2
       SEC                            ;2
       SBC    $94                     ;3
       STA    $93                     ;3
       LDA    $94                     ;3
       BMI    LD3DD                   ;2
       BNE    LD413                   ;2
       LDA    LD5CC,Y                 ;4
       BMI    LD413                   ;2
       CLC                            ;2
       ADC    $8F                     ;3
       STA    $A2                     ;3
       LDA    #$05                    ;2
       JMP    LD3F2                   ;3
LD3DD: EOR    #$FF                    ;2
       LSR                            ;2
       TAX                            ;2
       LDA    $8F                     ;3
       SEC                            ;2
       SBC    LD5A8,Y                 ;4
       SEC                            ;2
       SBC    LD5F0,X                 ;4
       STA    $A2                     ;3
       LDA    $94                     ;3
       CLC                            ;2
       ADC    #$05                    ;2
LD3F2: STA    $94                     ;3
       STA    WSYNC                   ;3
       NOP                            ;2
       NOP                            ;2
       NOP                            ;2
       LDA    $87                     ;3
       STA    HMP0                    ;3
       LDX    $01B3                   ;4
LD400: DEX                            ;2
       BPL    LD400                   ;2
       STA    RESP0                   ;3
       LDA    $8B                     ;3
       STA    COLUP0                  ;3
       DEC    $AF                     ;5
       LDA    $87                     ;3
       AND    #$0F                    ;2
       ORA    #$B0                    ;2
       STA    $A3                     ;3
LD413: LDY    $AC                     ;3
       LDA    $9E                     ;3
       SEC                            ;2
       SBC    #$06                    ;2
       SBC    $9F                     ;3
       STA    $9E                     ;3
       LDA    $9F                     ;3
       BMI    LD433                   ;2
       BNE    LD469                   ;2
       LDA    LD5DC,Y                 ;4
       BMI    LD469                   ;2
       CLC                            ;2
       ADC    $9C                     ;3
       STA    $A4                     ;3
       LDA    #$05                    ;2
       JMP    LD448                   ;3
LD433: EOR    #$FF                    ;2
       LSR                            ;2
       TAX                            ;2
       LDA    $9C                     ;3
       SEC                            ;2
       SBC    LD5F3,Y                 ;4
       SEC                            ;2
       SBC    LDA74,X                 ;4
       STA    $A4                     ;3
       LDA    $9F                     ;3
       CLC                            ;2
       ADC    #$05                    ;2
LD448: STA    $9F                     ;3
       STA    WSYNC                   ;3
       NOP                            ;2
       NOP                            ;2
       NOP                            ;2
       LDA    $98                     ;3
       STA    HMP1                    ;3
       LDX    $01B8                   ;4
LD456: DEX                            ;2
       BPL    LD456                   ;2
       STA    RESP1                   ;3
       LDA    $9A                     ;3
       STA    COLUP1                  ;3
       DEC    $B0                     ;5
       LDA    $98                     ;3
       AND    #$0F                    ;2
       ORA    #$B0                    ;2
       STA    $A5                     ;3
LD469: LDA    #$00                    ;2
       STA    $F7                     ;3
       LDA    INTIM                   ;4
       CMP    #$0D                    ;2
       BCS    LD477                   ;2
       NOP                            ;2
       BCC    LD47D                   ;2
LD477: LDA    $FC                     ;3
       AND    #$08                    ;2
       BNE    LD480                   ;2
LD47D: JMP    LD4EF                   ;3
LD480: LDY    #$01                    ;2
       LDA    $D0                     ;3
       CMP    #$28                    ;2
       BCC    LD48A                   ;2
       LDY    #$10                    ;2
LD48A: LDX    #$02                    ;2
       LDA    $F0A4,Y                 ;4
       AND    #$40                    ;2
       BEQ    LD4A3                   ;2
       STA    $F7                     ;3
       EOR    $F0A4,Y                 ;4
       STA    $F024,Y                 ;5
       LDA    $F0DA,Y                 ;4
       AND    #$BF                    ;2
       STA    $F05A,Y                 ;5
LD4A3: LSR    $F7                     ;5
       LDX    #$BF                    ;2
       LDA    $F092,Y                 ;4
       AND    #$40                    ;2
       BEQ    LD4B5                   ;2
       ORA    $F7                     ;3
       STA    $F7                     ;3
       JSR    LD4E0                   ;6
LD4B5: LSR    $F7                     ;5
       LDX    #$7F                    ;2
       LDY    $F6                     ;3
       LDA    LD7E3,Y                 ;4
LD4BE: SEC                            ;2
       SBC    #$12                    ;2
       TAY                            ;2
       LDA    $F092,Y                 ;4
       AND    #$80                    ;2
       PHP                            ;3
       ORA    $F7                     ;3
       STA    $F7                     ;3
       PLP                            ;4
       BEQ    LD4D2                   ;2
       JSR    LD4E0                   ;6
LD4D2: CPY    #$08                    ;2
       BCS    LD4EF                   ;2
       LSR    $F7                     ;5
       LDY    $F6                     ;3
       LDA    LD7EA,Y                 ;4
       JMP    LD4BE                   ;3
LD4E0: TXA                            ;2
       AND    $F092,Y                 ;4
       STA    $F012,Y                 ;5
       TXA                            ;2
       AND    $F0C8,Y                 ;4
       STA    $F048,Y                 ;5
       RTS                            ;6

LD4EF: LDX    $AB                     ;3
       LDY    $AC                     ;3
       STX    $A0                     ;3
       TXA                            ;2
       ASL                            ;2
       STA    $B1                     ;3
       ADC    $B1                     ;3
       ADC    $B1                     ;3
       STA    $B1                     ;3
       LDA    LD56C,Y                 ;4
       STA    $A6                     ;3
       LDA    LD580,Y                 ;4
       STA    $A7                     ;3
       LDX    $A0                     ;3
       CPY    #$08                    ;2
       BCS    LD519                   ;2
       JSR    LD6E7                   ;6
       JSR    LDEEE                   ;6
       INX                            ;2
       JMP    LD547                   ;3
LD519: LDA    $B1                     ;3
       CLC                            ;2
       ADC    #$03                    ;2
       STA    $B1                     ;3
       CPY    #$12                    ;2
       BCC    LD540                   ;2
       TAY                            ;2
       LDA    ($A9),Y                 ;5
       STA    PF0                     ;3
       INY                            ;2
       LDA    ($A9),Y                 ;5
       STA    PF1                     ;3
       INY                            ;2
       LDA    ($A9),Y                 ;5
       STA    PF2                     ;3
       INY                            ;2
       STY    $B1                     ;3
       INX                            ;2
       JSR    LD6E7                   ;6
       JSR    LDEEE                   ;6
       JMP    LD547                   ;3
LD540: JSR    LDEEE                   ;6
       INX                            ;2
       JSR    LD6E7                   ;6
LD547: TXS                            ;2
       LDY    $AC                     ;3
       STY    $CC                     ;3
       LDA    LD685,Y                 ;4
       STA    $CF                     ;3
       LDA    LD671,Y                 ;4
       STA    $CE                     ;3
       LDX    $AF                     ;3
       LDA    $80,X                   ;4
       STA    $AB                     ;3
       LDX    $B0                     ;3
       LDA    $95,X                   ;4
       STA    $AD                     ;3
       JMP.ind ($CE)                  ;5
LD565: .byte $00 ; |        | $D565
       .byte $6C ; | XX XX  | $D566
       .byte $02 ; |      X | $D567
       .byte $6E ; | XX XXX | $D568
       .byte $13 ; |   X  XX| $D569
       .byte $7F ; | XXXXXXX| $D56A
       .byte $7E ; | XXXXXX | $D56B
LD56C: .byte $09 ; |    X  X| $D56C
       .byte $00 ; |        | $D56D
       .byte $01 ; |       X| $D56E
       .byte $02 ; |      X | $D56F
       .byte $03 ; |      XX| $D570
       .byte $04 ; |     X  | $D571
       .byte $05 ; |     X X| $D572
       .byte $06 ; |     XX | $D573
       .byte $07 ; |     XXX| $D574
       .byte $08 ; |    X   | $D575
       .byte $09 ; |    X  X| $D576
       .byte $00 ; |        | $D577
       .byte $01 ; |       X| $D578
       .byte $02 ; |      X | $D579
       .byte $03 ; |      XX| $D57A
       .byte $04 ; |     X  | $D57B
       .byte $05 ; |     X X| $D57C
       .byte $06 ; |     XX | $D57D
       .byte $07 ; |     XXX| $D57E
       .byte $08 ; |    X   | $D57F
LD580: .byte $0D ; |    XX X| $D580
       .byte $0E ; |    XXX | $D581
       .byte $0E ; |    XXX | $D582
       .byte $0E ; |    XXX | $D583
       .byte $0E ; |    XXX | $D584
       .byte $0E ; |    XXX | $D585
       .byte $0E ; |    XXX | $D586
       .byte $0D ; |    XX X| $D587
       .byte $0D ; |    XX X| $D588
       .byte $0D ; |    XX X| $D589
       .byte $0D ; |    XX X| $D58A
       .byte $0E ; |    XXX | $D58B
       .byte $0E ; |    XXX | $D58C
       .byte $0E ; |    XXX | $D58D
       .byte $0E ; |    XXX | $D58E
       .byte $0E ; |    XXX | $D58F
       .byte $0E ; |    XXX | $D590
       .byte $0D ; |    XX X| $D591
       .byte $0D ; |    XX X| $D592
       .byte $0D ; |    XX X| $D593
LD594: .byte $00 ; |        | $D594
       .byte $00 ; |        | $D595
       .byte $01 ; |       X| $D596
       .byte $01 ; |       X| $D597
       .byte $01 ; |       X| $D598
       .byte $02 ; |      X | $D599
       .byte $02 ; |      X | $D59A
       .byte $02 ; |      X | $D59B
       .byte $02 ; |      X | $D59C
       .byte $02 ; |      X | $D59D
       .byte $02 ; |      X | $D59E
       .byte $02 ; |      X | $D59F
       .byte $03 ; |      XX| $D5A0
       .byte $03 ; |      XX| $D5A1
       .byte $04 ; |     X  | $D5A2
       .byte $04 ; |     X  | $D5A3
       .byte $04 ; |     X  | $D5A4
       .byte $04 ; |     X  | $D5A5
       .byte $04 ; |     X  | $D5A6
       .byte $04 ; |     X  | $D5A7
LD5A8: .byte $00 ; |        | $D5A8
       .byte $05 ; |     X X| $D5A9
       .byte $05 ; |     X X| $D5AA
       .byte $05 ; |     X X| $D5AB
       .byte $05 ; |     X X| $D5AC
       .byte $FB ; |XXXXX XX| $D5AD
       .byte $00 ; |        | $D5AE
       .byte $00 ; |        | $D5AF
       .byte $00 ; |        | $D5B0
       .byte $00 ; |        | $D5B1
       .byte $00 ; |        | $D5B2
       .byte $05 ; |     X X| $D5B3
       .byte $05 ; |     X X| $D5B4
       .byte $05 ; |     X X| $D5B5
       .byte $FB ; |XXXXX XX| $D5B6
       .byte $FB ; |XXXXX XX| $D5B7
LD5B8: .byte $00 ; |        | $D5B8
       .byte $00 ; |        | $D5B9
       .byte $00 ; |        | $D5BA
       .byte $00 ; |        | $D5BB
       .byte $00 ; |        | $D5BC
       .byte $00 ; |        | $D5BD
       .byte $00 ; |        | $D5BE
       .byte $01 ; |       X| $D5BF
       .byte $01 ; |       X| $D5C0
       .byte $01 ; |       X| $D5C1
       .byte $02 ; |      X | $D5C2
       .byte $02 ; |      X | $D5C3
       .byte $02 ; |      X | $D5C4
       .byte $02 ; |      X | $D5C5
       .byte $02 ; |      X | $D5C6
       .byte $02 ; |      X | $D5C7
       .byte $02 ; |      X | $D5C8
       .byte $03 ; |      XX| $D5C9
       .byte $03 ; |      XX| $D5CA
       .byte $03 ; |      XX| $D5CB
LD5CC: .byte $FF ; |XXXXXXXX| $D5CC
       .byte $FF ; |XXXXXXXX| $D5CD
       .byte $FF ; |XXXXXXXX| $D5CE
       .byte $FF ; |XXXXXXXX| $D5CF
       .byte $FF ; |XXXXXXXX| $D5D0
       .byte $05 ; |     X X| $D5D1
       .byte $FF ; |XXXXXXXX| $D5D2
       .byte $FF ; |XXXXXXXX| $D5D3
       .byte $FF ; |XXXXXXXX| $D5D4
       .byte $FF ; |XXXXXXXX| $D5D5
       .byte $FF ; |XXXXXXXX| $D5D6
       .byte $FF ; |XXXXXXXX| $D5D7
       .byte $FF ; |XXXXXXXX| $D5D8
       .byte $FF ; |XXXXXXXX| $D5D9
       .byte $05 ; |     X X| $D5DA
       .byte $05 ; |     X X| $D5DB
LD5DC: .byte $FF ; |XXXXXXXX| $D5DC
       .byte $FF ; |XXXXXXXX| $D5DD
       .byte $FF ; |XXXXXXXX| $D5DE
       .byte $FF ; |XXXXXXXX| $D5DF
       .byte $FF ; |XXXXXXXX| $D5E0
       .byte $FF ; |XXXXXXXX| $D5E1
       .byte $FF ; |XXXXXXXX| $D5E2
       .byte $FF ; |XXXXXXXX| $D5E3
       .byte $FF ; |XXXXXXXX| $D5E4
       .byte $05 ; |     X X| $D5E5
       .byte $FF ; |XXXXXXXX| $D5E6
       .byte $FF ; |XXXXXXXX| $D5E7
       .byte $FF ; |XXXXXXXX| $D5E8
       .byte $FF ; |XXXXXXXX| $D5E9
       .byte $FF ; |XXXXXXXX| $D5EA
       .byte $FF ; |XXXXXXXX| $D5EB
       .byte $FF ; |XXXXXXXX| $D5EC
       .byte $FF ; |XXXXXXXX| $D5ED
       .byte $FF ; |XXXXXXXX| $D5EE
       .byte $05 ; |     X X| $D5EF
LD5F0: .byte $00 ; |        | $D5F0
       .byte $0A ; |    X X | $D5F1
       .byte $14 ; |   X X  | $D5F2
LD5F3: .byte $00 ; |        | $D5F3
       .byte $05 ; |     X X| $D5F4
       .byte $05 ; |     X X| $D5F5
       .byte $05 ; |     X X| $D5F6
       .byte $05 ; |     X X| $D5F7
       .byte $05 ; |     X X| $D5F8
       .byte $0A ; |    X X | $D5F9
       .byte $0A ; |    X X | $D5FA
       .byte $0A ; |    X X | $D5FB
       .byte $0A ; |    X X | $D5FC
       .byte $00 ; |        | $D5FD
       .byte $05 ; |     X X| $D5FE
       .byte $05 ; |     X X| $D5FF
       .byte $05 ; |     X X| $D600
       .byte $05 ; |     X X| $D601
       .byte $05 ; |     X X| $D602
       .byte $0A ; |    X X | $D603
       .byte $0A ; |    X X | $D604
       .byte $0A ; |    X X | $D605
       .byte $0A ; |    X X | $D606
LD607: .byte $1B ; |   XX XX| $D607
       .byte $1F ; |   XXXXX| $D608
       .byte $1F ; |   XXXXX| $D609
       .byte $1F ; |   XXXXX| $D60A
       .byte $1D ; |   XXX X| $D60B
       .byte $1D ; |   XXX X| $D60C
       .byte $1D ; |   XXX X| $D60D
       .byte $1C ; |   XXX  | $D60E
       .byte $1C ; |   XXX  | $D60F
       .byte $1C ; |   XXX  | $D610
       .byte $1B ; |   XX XX| $D611
       .byte $1F ; |   XXXXX| $D612
       .byte $1F ; |   XXXXX| $D613
       .byte $1F ; |   XXXXX| $D614
       .byte $1F ; |   XXXXX| $D615
       .byte $1D ; |   XXX X| $D616
       .byte $1D ; |   XXX X| $D617
       .byte $1C ; |   XXX  | $D618
       .byte $1C ; |   XXX  | $D619
       .byte $1C ; |   XXX  | $D61A
LD61B: LDA    $DD,X                   ;4
       PHP                            ;3
       AND    #$3F                    ;2
       TAY                            ;2
       PLP                            ;4
       BMI    LD63E                   ;2
       LDA    $D7,X                   ;4
       AND    #$40                    ;2
       BEQ    LD63A                   ;2
       LDA    $D2                     ;3
       CMP    #$50                    ;2
       BCS    LD637                   ;2
       AND    #$08                    ;2
       BNE    LD637                   ;2
       LDA    #$8E                    ;2
       RTS                            ;6

LD637: LDA    #$84                    ;2
       RTS                            ;6

LD63A: LDA    LDA70,X                 ;4
       RTS                            ;6

LD63E: LDA    #$AE                    ;2
       RTS                            ;6

LD641: LDA    $EA,X                   ;4
       CLC                            ;2
       ADC    #$05                    ;2
       TAY                            ;2
       BCC    LD64F                   ;2
       LDA    #$80                    ;2
       BMI    LD651                   ;2
LD64D: LDY    $EA,X                   ;4
LD64F: LDA    $D7,X                   ;4
LD651: PHA                            ;3
       LDA    LD900,Y                 ;4
       STA    $A0                     ;3
       PLA                            ;4
       BPL    LD66B                   ;2
       LDA    LDB00,Y                 ;4
       TAY                            ;2
       LDA    LD906,Y                 ;4
       CLC                            ;2
       ADC    $A0                     ;3
       ADC    #$19                    ;2
       TAX                            ;2
       LDA    LDBF6,Y                 ;4
       RTS                            ;6

LD66B: LDX    $A0                     ;3
       LDA    LDB00,Y                 ;4
       RTS                            ;6

LD671: .byte $F7 ; |XXXX XXX| $D671
       .byte $58 ; | X XX   | $D672
       .byte $69 ; | XX X  X| $D673
       .byte $7A ; | XXXX X | $D674
       .byte $8C ; |X   XX  | $D675
       .byte $9F ; |X  XXXXX| $D676
       .byte $AC ; |X X XX  | $D677
       .byte $B9 ; |X XXX  X| $D678
       .byte $D3 ; |XX X  XX| $D679
       .byte $93 ; |X  X  XX| $D67A
       .byte $B2 ; |X XX  X | $D67B
       .byte $C3 ; |XX    XX| $D67C
       .byte $D6 ; |XX X XX | $D67D
       .byte $00 ; |        | $D67E
       .byte $14 ; |   X X  | $D67F
       .byte $1F ; |   XXXXX| $D680
       .byte $70 ; | XXX    | $D681
       .byte $2C ; |  X XX  | $D682
       .byte $05 ; |     X X| $D683
       .byte $E9 ; |XXX X  X| $D684
LD685: .byte $DC ; |XX XXX  | $D685
       .byte $D8 ; |XX XX   | $D686
       .byte $D8 ; |XX XX   | $D687
       .byte $D8 ; |XX XX   | $D688
       .byte $D8 ; |XX XX   | $D689
       .byte $D8 ; |XX XX   | $D68A
       .byte $D8 ; |XX XX   | $D68B
       .byte $D8 ; |XX XX   | $D68C
       .byte $D8 ; |XX XX   | $D68D
       .byte $DA ; |XX XX X | $D68E
       .byte $DA ; |XX XX X | $D68F
       .byte $DA ; |XX XX X | $D690
       .byte $DA ; |XX XX X | $D691
       .byte $DA ; |XX XX X | $D692
       .byte $DA ; |XX XX X | $D693
       .byte $DA ; |XX XX X | $D694
       .byte $DF ; |XX XXXXX| $D695
       .byte $DA ; |XX XX X | $D696
       .byte $DE ; |XX XXXX | $D697
       .byte $DA ; |XX XX X | $D698
LD699: .byte $A4 ; |X X  X  | $D699
       .byte $A2 ; |X X   X | $D69A
       .byte $84 ; |X    X  | $D69B
       .byte $82 ; |X     X | $D69C
       .byte $64 ; | XX  X  | $D69D
       .byte $62 ; | XX   X | $D69E
       .byte $44 ; | X   X  | $D69F
       .byte $42 ; | X    X | $D6A0
       .byte $24 ; |  X  X  | $D6A1
       .byte $22 ; |  X   X | $D6A2
       .byte $00 ; |        | $D6A3
LD6A4: .byte $0B ; |    X XX| $D6A4
       .byte $09 ; |    X  X| $D6A5
       .byte $07 ; |     XXX| $D6A6
       .byte $05 ; |     X X| $D6A7
       .byte $03 ; |      XX| $D6A8
       .byte $2A ; |  X X X | $D6A9
       .byte $28 ; |  X X   | $D6AA
       .byte $26 ; |  X  XX | $D6AB
       .byte $24 ; |  X  X  | $D6AC
       .byte $22 ; |  X   X | $D6AD
       .byte $20 ; |  X     | $D6AE
LD6AF: .byte $A7 ; |X X  XXX| $D6AF
       .byte $A5 ; |X X  X X| $D6B0
       .byte $A3 ; |X X   XX| $D6B1
       .byte $C2 ; |XX    X | $D6B2
       .byte $C0 ; |XX      | $D6B3
       .byte $BE ; |X XXXXX | $D6B4
       .byte $BC ; |X XXXX  | $D6B5
       .byte $BA ; |X XXX X | $D6B6
       .byte $B8 ; |X XXX   | $D6B7
       .byte $B6 ; |X XX XX | $D6B8
       .byte $B4 ; |X XX X  | $D6B9
LD6BA: .byte $02 ; |      X | $D6BA
       .byte $00 ; |        | $D6BB
       .byte $09 ; |    X  X| $D6BC
       .byte $07 ; |     XXX| $D6BD
       .byte $16 ; |   X XX | $D6BE
       .byte $14 ; |   X X  | $D6BF
       .byte $29 ; |  X X  X| $D6C0
       .byte $27 ; |  X  XXX| $D6C1
       .byte $44 ; | X   X  | $D6C2
       .byte $42 ; | X    X | $D6C3
       .byte $62 ; | XX   X | $D6C4
LD6C5: .byte $85 ; |X    X X| $D6C5
       .byte $83 ; |X     XX| $D6C6
       .byte $81 ; |X      X| $D6C7
       .byte $7F ; | XXXXXXX| $D6C8
       .byte $7D ; | XXXXX X| $D6C9
       .byte $A3 ; |X X   XX| $D6CA
       .byte $A1 ; |X X    X| $D6CB
       .byte $9F ; |X  XXXXX| $D6CC
       .byte $9D ; |X  XXX X| $D6CD
       .byte $9B ; |X  XX XX| $D6CE
       .byte $99 ; |X  XX  X| $D6CF
LD6D0: .byte $33 ; |  XX  XX| $D6D0
       .byte $31 ; |  XX   X| $D6D1
       .byte $2F ; |  X XXXX| $D6D2
       .byte $4B ; | X  X XX| $D6D3
       .byte $49 ; | X  X  X| $D6D4
       .byte $47 ; | X   XXX| $D6D5
       .byte $45 ; | X   X X| $D6D6
       .byte $43 ; | X    XX| $D6D7
       .byte $41 ; | X     X| $D6D8
       .byte $3F ; |  XXXXXX| $D6D9
       .byte $3D ; |  XXXX X| $D6DA
LD6DB: .byte $04 ; |     X  | $D6DB
       .byte $04 ; |     X  | $D6DC
       .byte $04 ; |     X  | $D6DD
       .byte $04 ; |     X  | $D6DE
       .byte $04 ; |     X  | $D6DF
       .byte $04 ; |     X  | $D6E0
       .byte $04 ; |     X  | $D6E1
       .byte $04 ; |     X  | $D6E2
       .byte $01 ; |       X| $D6E3
       .byte $01 ; |       X| $D6E4
       .byte $05 ; |     X X| $D6E5
       .byte $05 ; |     X X| $D6E6
LD6E7: LDY    $B1                     ;3
       LDA    ($A9),Y                 ;5
       STA    $B2                     ;3
       INY                            ;2
       LDA    ($A9),Y                 ;5
       STA    $B3                     ;3
       INY                            ;2
       LDA    ($A9),Y                 ;5
       STA    $B4                     ;3
       INY                            ;2
       STY    $B1                     ;3
       LDA    $F080,X                 ;4
       AND    #$07                    ;2
       TAY                            ;2
       LDA    LD8F7,Y                 ;4
       TAY                            ;2
       AND    #$20                    ;2
       ORA    $B2                     ;3
       STA    $B9                     ;3
       TYA                            ;2
       AND    #$44                    ;2
       ORA    $B3                     ;3
       STA    $BA                     ;3
       LDA    $F0B6,X                 ;4
       AND    #$07                    ;2
       TAY                            ;2
       LDA    LD8F7,Y                 ;4
       TAY                            ;2
       AND    #$20                    ;2
       ORA    $B2                     ;3
       STA    $BC                     ;3
       TYA                            ;2
       AND    #$44                    ;2
       ORA    $B3                     ;3
       STA    $BB                     ;3
       LDA    $F0EC,X                 ;4
       TAY                            ;2
       AND    #$20                    ;2
       ORA    $B2                     ;3
       STA    $B5                     ;3
       TYA                            ;2
       AND    #$44                    ;2
       ORA    $B3                     ;3
       STA    $B6                     ;3
       TYA                            ;2
       ASL                            ;2
       ASL                            ;2
       TAY                            ;2
       AND    #$20                    ;2
       ORA    $B2                     ;3
       STA    $B8                     ;3
       TYA                            ;2
       AND    #$44                    ;2
       ORA    $B3                     ;3
       STA    $B7                     ;3
       RTS                            ;6

LD74B: .byte $40 ; | X      | $D74B
       .byte $30 ; |  XX    | $D74C
       .byte $20 ; |  X     | $D74D
       .byte $10 ; |   X    | $D74E
       .byte $00 ; |        | $D74F
       .byte $F0 ; |XXXX    | $D750
       .byte $E0 ; |XXX     | $D751
       .byte $D0 ; |XX X    | $D752
       .byte $C0 ; |XX      | $D753
       .byte $B0 ; |X XX    | $D754
       .byte $A0 ; |X X     | $D755
       .byte $90 ; |X  X    | $D756
       .byte $80 ; |X       | $D757
       .byte $61 ; | XX    X| $D758
       .byte $51 ; | X X   X| $D759
       .byte $41 ; | X     X| $D75A
       .byte $31 ; |  XX   X| $D75B
       .byte $21 ; |  X    X| $D75C
       .byte $11 ; |   X   X| $D75D
       .byte $01 ; |       X| $D75E
       .byte $F1 ; |XXXX   X| $D75F
       .byte $E1 ; |XXX    X| $D760
       .byte $D1 ; |XX X   X| $D761
       .byte $C1 ; |XX     X| $D762
       .byte $B1 ; |X XX   X| $D763
       .byte $A1 ; |X X    X| $D764
       .byte $91 ; |X  X   X| $D765
       .byte $81 ; |X      X| $D766
       .byte $62 ; | XX   X | $D767
       .byte $52 ; | X X  X | $D768
       .byte $42 ; | X    X | $D769
       .byte $32 ; |  XX  X | $D76A
       .byte $22 ; |  X   X | $D76B
       .byte $12 ; |   X  X | $D76C
       .byte $02 ; |      X | $D76D
       .byte $F2 ; |XXXX  X | $D76E
       .byte $E2 ; |XXX   X | $D76F
       .byte $D2 ; |XX X  X | $D770
       .byte $C2 ; |XX    X | $D771
       .byte $B2 ; |X XX  X | $D772
       .byte $A2 ; |X X   X | $D773
       .byte $92 ; |X  X  X | $D774
       .byte $82 ; |X     X | $D775
       .byte $63 ; | XX   XX| $D776
       .byte $53 ; | X X  XX| $D777
       .byte $43 ; | X    XX| $D778
       .byte $33 ; |  XX  XX| $D779
       .byte $23 ; |  X   XX| $D77A
       .byte $13 ; |   X  XX| $D77B
       .byte $03 ; |      XX| $D77C
       .byte $F3 ; |XXXX  XX| $D77D
       .byte $E3 ; |XXX   XX| $D77E
       .byte $D3 ; |XX X  XX| $D77F
       .byte $C3 ; |XX    XX| $D780
       .byte $B3 ; |X XX  XX| $D781
       .byte $A3 ; |X X   XX| $D782
       .byte $93 ; |X  X  XX| $D783
       .byte $83 ; |X     XX| $D784
       .byte $64 ; | XX  X  | $D785
       .byte $54 ; | X X X  | $D786
       .byte $44 ; | X   X  | $D787
       .byte $34 ; |  XX X  | $D788
       .byte $24 ; |  X  X  | $D789
       .byte $14 ; |   X X  | $D78A
       .byte $04 ; |     X  | $D78B
       .byte $F4 ; |XXXX X  | $D78C
       .byte $E4 ; |XXX  X  | $D78D
       .byte $D4 ; |XX X X  | $D78E
       .byte $C4 ; |XX   X  | $D78F
       .byte $B4 ; |X XX X  | $D790
       .byte $A4 ; |X X  X  | $D791
       .byte $94 ; |X  X X  | $D792
       .byte $84 ; |X    X  | $D793
       .byte $65 ; | XX  X X| $D794
       .byte $55 ; | X X X X| $D795
       .byte $45 ; | X   X X| $D796
       .byte $35 ; |  XX X X| $D797
       .byte $25 ; |  X  X X| $D798
       .byte $15 ; |   X X X| $D799
       .byte $05 ; |     X X| $D79A
       .byte $F5 ; |XXXX X X| $D79B
       .byte $E5 ; |XXX  X X| $D79C
       .byte $D5 ; |XX X X X| $D79D
       .byte $C5 ; |XX   X X| $D79E
       .byte $B5 ; |X XX X X| $D79F
       .byte $A5 ; |X X  X X| $D7A0
       .byte $95 ; |X  X X X| $D7A1
       .byte $85 ; |X    X X| $D7A2
       .byte $66 ; | XX  XX | $D7A3
       .byte $56 ; | X X XX | $D7A4
       .byte $46 ; | X   XX | $D7A5
       .byte $36 ; |  XX XX | $D7A6
       .byte $26 ; |  X  XX | $D7A7
       .byte $16 ; |   X XX | $D7A8
       .byte $06 ; |     XX | $D7A9
       .byte $F6 ; |XXXX XX | $D7AA
       .byte $E6 ; |XXX  XX | $D7AB
       .byte $D6 ; |XX X XX | $D7AC
       .byte $C6 ; |XX   XX | $D7AD
       .byte $B6 ; |X XX XX | $D7AE
       .byte $A6 ; |X X  XX | $D7AF
       .byte $96 ; |X  X XX | $D7B0
       .byte $86 ; |X    XX | $D7B1
       .byte $67 ; | XX  XXX| $D7B2
       .byte $57 ; | X X XXX| $D7B3
       .byte $47 ; | X   XXX| $D7B4
       .byte $37 ; |  XX XXX| $D7B5
       .byte $27 ; |  X  XXX| $D7B6
       .byte $17 ; |   X XXX| $D7B7
       .byte $07 ; |     XXX| $D7B8
       .byte $F7 ; |XXXX XXX| $D7B9
       .byte $E7 ; |XXX  XXX| $D7BA
       .byte $D7 ; |XX X XXX| $D7BB
       .byte $C7 ; |XX   XXX| $D7BC
       .byte $B7 ; |X XX XXX| $D7BD
       .byte $A7 ; |X X  XXX| $D7BE
       .byte $97 ; |X  X XXX| $D7BF
       .byte $87 ; |X    XXX| $D7C0
       .byte $68 ; | XX X   | $D7C1
       .byte $58 ; | X XX   | $D7C2
       .byte $48 ; | X  X   | $D7C3
       .byte $38 ; |  XXX   | $D7C4
       .byte $28 ; |  X X   | $D7C5
       .byte $18 ; |   XX   | $D7C6
       .byte $08 ; |    X   | $D7C7
       .byte $F8 ; |XXXXX   | $D7C8
       .byte $E8 ; |XXX X   | $D7C9
       .byte $D8 ; |XX XX   | $D7CA
       .byte $C8 ; |XX  X   | $D7CB
       .byte $B8 ; |X XXX   | $D7CC
       .byte $A8 ; |X X X   | $D7CD
       .byte $98 ; |X  XX   | $D7CE
       .byte $88 ; |X   X   | $D7CF
       .byte $69 ; | XX X  X| $D7D0
       .byte $59 ; | X XX  X| $D7D1
       .byte $49 ; | X  X  X| $D7D2
       .byte $39 ; |  XXX  X| $D7D3
       .byte $29 ; |  X X  X| $D7D4
       .byte $19 ; |   XX  X| $D7D5
       .byte $09 ; |    X  X| $D7D6
       .byte $F9 ; |XXXXX  X| $D7D7
       .byte $E9 ; |XXX X  X| $D7D8
       .byte $D9 ; |XX XX  X| $D7D9
       .byte $C9 ; |XX  X  X| $D7DA
       .byte $B9 ; |X XXX  X| $D7DB
       .byte $A9 ; |X X X  X| $D7DC
       .byte $99 ; |X  XX  X| $D7DD
       .byte $89 ; |X   X  X| $D7DE
       .byte $6A ; | XX X X | $D7DF
       .byte $5A ; | X XX X | $D7E0
       .byte $4A ; | X  X X | $D7E1
       .byte $3A ; |  XXX X | $D7E2
LD7E3: .byte $17 ; |   X XXX| $D7E3
       .byte $16 ; |   X XX | $D7E4
       .byte $17 ; |   X XXX| $D7E5
       .byte $17 ; |   X XXX| $D7E6
       .byte $17 ; |   X XXX| $D7E7
       .byte $17 ; |   X XXX| $D7E8
       .byte $18 ; |   XX   | $D7E9
LD7EA: .byte $1D ; |   XXX X| $D7EA
       .byte $1D ; |   XXX X| $D7EB
       .byte $1D ; |   XXX X| $D7EC
       .byte $1E ; |   XXXX | $D7ED
       .byte $1D ; |   XXX X| $D7EE
       .byte $1C ; |   XXX  | $D7EF
       .byte $1C ; |   XXX  | $D7F0
LD7F1: NOP                            ;2
LD7F2: LDA    INTIM                   ;4
       BMI    LD7FC                   ;2
       BNE    LD7F2                   ;2
       JMP    LD7FD                   ;3
LD7FC: NOP                            ;2
LD7FD: STA    WSYNC                   ;3
       STA    HMOVE                   ;3
       STY    $CF                     ;3
       LDY    $CC                     ;3
       LDA    #$B5                    ;2
       STA    $CD                     ;3
       LDA    LD825,Y                 ;4
       STA    $CC                     ;3
       LDY    $CF                     ;3
       LDA    #$02                    ;2
       STA    ENABL                   ;3
       SEC                            ;2
       LDA    ($A2),Y                 ;5
       LDA    ($A2),Y                 ;5
       LDA    ($A2),Y                 ;5
       LDA    #$00                    ;2
       STA    HMCLR                   ;3
       NOP                            ;2
       STA    VBLANK                  ;3
       JMP    LDFF0                   ;3
LD825: .byte $78 ; | XXXX   | $D825
       .byte $7D ; | XXXXX X| $D826
       .byte $82 ; |X     X | $D827
       .byte $87 ; |X    XXX| $D828
       .byte $8C ; |X   XX  | $D829
       .byte $91 ; |X  X   X| $D82A
       .byte $96 ; |X  X XX | $D82B
       .byte $9B ; |X  XX XX| $D82C
       .byte $A0 ; |X X     | $D82D
       .byte $A6 ; |X X  XX | $D82E
       .byte $AD ; |X X XX X| $D82F
       .byte $B2 ; |X XX  X | $D830
       .byte $B7 ; |X XX XXX| $D831
       .byte $BC ; |X XXXX  | $D832
       .byte $BF ; |X XXXXXX| $D833
       .byte $C3 ; |XX    XX| $D834
       .byte $C8 ; |XX  X   | $D835
       .byte $CD ; |XX  XX X| $D836
       .byte $D2 ; |XX X  X | $D837
       .byte $D9 ; |XX XX  X| $D838
       .byte $FF ; |XXXXXXXX| $D839
       .byte $FF ; |XXXXXXXX| $D83A
       .byte $FF ; |XXXXXXXX| $D83B
       LDY    $B1                     ;3
       LDA    ($A9),Y                 ;5
       STA    $BD                     ;3
       INY                            ;2
       LDA    ($A9),Y                 ;5
       STA    $BE                     ;3
       INY                            ;2
       LDA    ($A9),Y                 ;5
       STA    $BF                     ;3
       INY                            ;2
       STY    $B1                     ;3
       LDA    $F080,X                 ;4
       AND    #$A0                    ;2
       STA    BANK2                   ;4
       .byte $FF ; |XXXXXXXX| $D857
       LDA    #$BA                    ;2
       STA    $AC                     ;3
       LDA    #$B6                    ;2
       STA    $AE                     ;3
       LDA    $B4                     ;3
       STA    PF2                     ;3
       LDY    #$04                    ;2
       JMP    LD7F1                   ;3
       LDA    #$BA                    ;2
       STA    $AC                     ;3
       LDA    #$B6                    ;2
       STA    $AE                     ;3
       LDA    $B4                     ;3
       STA    PF2                     ;3
       LDY    #$03                    ;2
       JMP    LD7F1                   ;3
       LDA    #$BA                    ;2
       STA    $AC                     ;3
       LDA    #$B6                    ;2
       STA    $AE                     ;3
       LDA    $B4                     ;3
       STA    PF2                     ;3
       TSX                            ;2
       LDY    #$02                    ;2
       JMP    LD7F1                   ;3
       LDA    #$BA                    ;2
       STA    $AC                     ;3
       LDA    #$B6                    ;2
       STA    $AE                     ;3
       LDA    $B4                     ;3
       STA    PF2                     ;3
       LDX    $B9                     ;3
       LDY    #$01                    ;2
       JMP    LD7F1                   ;3
       LDA    #$B6                    ;2
       STA    $AE                     ;3
       LDA    $B4                     ;3
       STA    PF2                     ;3
       LDY    #$00                    ;2
       JMP    LD7F1                   ;3
       LDA    #$BF                    ;2
       STA    $AC                     ;3
       LDA    #$B6                    ;2
       STA    $AE                     ;3
       LDY    #$04                    ;2
       JMP    LD7F1                   ;3
       LDA    #$BF                    ;2
       STA    $AC                     ;3
       LDA    #$B6                    ;2
       STA    $AE                     ;3
       LDA    $BD                     ;3
       STA    PF0                     ;3
       LDA    $BE                     ;3
       STA    PF1                     ;3
       LDA    $BF                     ;3
       STA    PF2                     ;3
       TSX                            ;2
       LDY    #$03                    ;2
       JMP    LD7F1                   ;3
       LDA    #$BF                    ;2
       STA    $AC                     ;3
       LDA    #$B6                    ;2
       STA    $AE                     ;3
       LDA    $BD                     ;3
       STA    PF0                     ;3
       LDA    $BE                     ;3
       STA    PF1                     ;3
       LDA    $BF                     ;3
       STA    PF2                     ;3
       TSX                            ;2
       LDA    $F080,X                 ;4
       AND    #$07                    ;2
       TAY                            ;2
       LDA    LD8F7,Y                 ;4
       TAX                            ;2
       LDY    #$02                    ;2
       JMP    LD7F1                   ;3
LD8F7: .byte $00 ; |        | $D8F7
       .byte $04 ; |     X  | $D8F8
       .byte $20 ; |  X     | $D8F9
       .byte $24 ; |  X  X  | $D8FA
       .byte $40 ; | X      | $D8FB
       .byte $44 ; | X   X  | $D8FC
       .byte $60 ; | XX     | $D8FD
       .byte $64 ; | XX  X  | $D8FE
       .byte $FF ; |XXXXXXXX| $D8FF
LD900: .byte $00 ; |        | $D900
       .byte $00 ; |        | $D901
       .byte $00 ; |        | $D902
       .byte $00 ; |        | $D903
       .byte $00 ; |        | $D904
       .byte $00 ; |        | $D905
LD906: .byte $00 ; |        | $D906
       .byte $00 ; |        | $D907
       .byte $00 ; |        | $D908
       .byte $00 ; |        | $D909
       .byte $01 ; |       X| $D90A
       .byte $01 ; |       X| $D90B
       .byte $01 ; |       X| $D90C
       .byte $01 ; |       X| $D90D
       .byte $01 ; |       X| $D90E
       .byte $01 ; |       X| $D90F
       .byte $01 ; |       X| $D910
       .byte $01 ; |       X| $D911
       .byte $01 ; |       X| $D912
       .byte $01 ; |       X| $D913
       .byte $02 ; |      X | $D914
       .byte $02 ; |      X | $D915
       .byte $02 ; |      X | $D916
       .byte $02 ; |      X | $D917
       .byte $02 ; |      X | $D918
       .byte $02 ; |      X | $D919
       .byte $02 ; |      X | $D91A
       .byte $02 ; |      X | $D91B
       .byte $02 ; |      X | $D91C
       .byte $02 ; |      X | $D91D
       .byte $03 ; |      XX| $D91E
       .byte $03 ; |      XX| $D91F
       .byte $03 ; |      XX| $D920
       .byte $03 ; |      XX| $D921
       .byte $03 ; |      XX| $D922
       .byte $03 ; |      XX| $D923
       .byte $03 ; |      XX| $D924
       .byte $03 ; |      XX| $D925
       .byte $03 ; |      XX| $D926
       .byte $03 ; |      XX| $D927
       .byte $04 ; |     X  | $D928
       .byte $04 ; |     X  | $D929
       .byte $04 ; |     X  | $D92A
       .byte $04 ; |     X  | $D92B
       .byte $04 ; |     X  | $D92C
       .byte $04 ; |     X  | $D92D
       .byte $04 ; |     X  | $D92E
       .byte $04 ; |     X  | $D92F
       .byte $04 ; |     X  | $D930
       .byte $04 ; |     X  | $D931
       .byte $05 ; |     X X| $D932
       .byte $05 ; |     X X| $D933
       .byte $05 ; |     X X| $D934
       .byte $05 ; |     X X| $D935
       .byte $05 ; |     X X| $D936
       .byte $05 ; |     X X| $D937
       .byte $05 ; |     X X| $D938
       .byte $05 ; |     X X| $D939
       .byte $05 ; |     X X| $D93A
       .byte $05 ; |     X X| $D93B
       .byte $06 ; |     XX | $D93C
       .byte $06 ; |     XX | $D93D
       .byte $06 ; |     XX | $D93E
       .byte $06 ; |     XX | $D93F
       .byte $06 ; |     XX | $D940
       .byte $06 ; |     XX | $D941
       .byte $06 ; |     XX | $D942
       .byte $06 ; |     XX | $D943
       .byte $06 ; |     XX | $D944
       .byte $06 ; |     XX | $D945
       .byte $07 ; |     XXX| $D946
       .byte $07 ; |     XXX| $D947
       .byte $07 ; |     XXX| $D948
       .byte $07 ; |     XXX| $D949
       .byte $07 ; |     XXX| $D94A
       .byte $07 ; |     XXX| $D94B
       .byte $07 ; |     XXX| $D94C
       .byte $07 ; |     XXX| $D94D
       .byte $07 ; |     XXX| $D94E
       .byte $07 ; |     XXX| $D94F
       .byte $08 ; |    X   | $D950
       .byte $08 ; |    X   | $D951
       .byte $08 ; |    X   | $D952
       .byte $08 ; |    X   | $D953
       .byte $08 ; |    X   | $D954
       .byte $08 ; |    X   | $D955
       .byte $08 ; |    X   | $D956
       .byte $08 ; |    X   | $D957
       .byte $08 ; |    X   | $D958
       .byte $08 ; |    X   | $D959
       .byte $09 ; |    X  X| $D95A
       .byte $09 ; |    X  X| $D95B
       .byte $09 ; |    X  X| $D95C
       .byte $09 ; |    X  X| $D95D
       .byte $09 ; |    X  X| $D95E
       .byte $09 ; |    X  X| $D95F
       .byte $09 ; |    X  X| $D960
       .byte $09 ; |    X  X| $D961
       .byte $09 ; |    X  X| $D962
       .byte $09 ; |    X  X| $D963
       .byte $0A ; |    X X | $D964
       .byte $0A ; |    X X | $D965
       .byte $0A ; |    X X | $D966
       .byte $0A ; |    X X | $D967
       .byte $0A ; |    X X | $D968
       .byte $0A ; |    X X | $D969
       .byte $0A ; |    X X | $D96A
       .byte $0A ; |    X X | $D96B
       .byte $0A ; |    X X | $D96C
       .byte $0A ; |    X X | $D96D
       .byte $0B ; |    X XX| $D96E
       .byte $0B ; |    X XX| $D96F
       .byte $0B ; |    X XX| $D970
       .byte $0B ; |    X XX| $D971
       .byte $0B ; |    X XX| $D972
       .byte $0B ; |    X XX| $D973
       .byte $0B ; |    X XX| $D974
       .byte $0B ; |    X XX| $D975
       .byte $0B ; |    X XX| $D976
       .byte $0B ; |    X XX| $D977
       .byte $0C ; |    XX  | $D978
       .byte $0C ; |    XX  | $D979
       .byte $0C ; |    XX  | $D97A
       .byte $0C ; |    XX  | $D97B
       .byte $0C ; |    XX  | $D97C
       .byte $0C ; |    XX  | $D97D
       .byte $0C ; |    XX  | $D97E
       .byte $0C ; |    XX  | $D97F
       .byte $0C ; |    XX  | $D980
       .byte $0C ; |    XX  | $D981
       .byte $0D ; |    XX X| $D982
       .byte $0D ; |    XX X| $D983
       .byte $0D ; |    XX X| $D984
       .byte $0D ; |    XX X| $D985
       .byte $0D ; |    XX X| $D986
       .byte $0D ; |    XX X| $D987
       .byte $0D ; |    XX X| $D988
       .byte $0D ; |    XX X| $D989
       .byte $0D ; |    XX X| $D98A
       .byte $0D ; |    XX X| $D98B
       .byte $0E ; |    XXX | $D98C
       .byte $0E ; |    XXX | $D98D
       .byte $0E ; |    XXX | $D98E
       .byte $0E ; |    XXX | $D98F
       .byte $0E ; |    XXX | $D990
       .byte $0E ; |    XXX | $D991
       .byte $0E ; |    XXX | $D992
       .byte $0E ; |    XXX | $D993
       .byte $0E ; |    XXX | $D994
       .byte $0E ; |    XXX | $D995
       .byte $0F ; |    XXXX| $D996
       .byte $0F ; |    XXXX| $D997
       .byte $0F ; |    XXXX| $D998
       .byte $0F ; |    XXXX| $D999
       .byte $0F ; |    XXXX| $D99A
       .byte $0F ; |    XXXX| $D99B
       .byte $0F ; |    XXXX| $D99C
       .byte $0F ; |    XXXX| $D99D
       .byte $0F ; |    XXXX| $D99E
       .byte $0F ; |    XXXX| $D99F
       .byte $10 ; |   X    | $D9A0
       .byte $10 ; |   X    | $D9A1
       .byte $10 ; |   X    | $D9A2
       .byte $10 ; |   X    | $D9A3
       .byte $10 ; |   X    | $D9A4
       .byte $10 ; |   X    | $D9A5
       .byte $10 ; |   X    | $D9A6
       .byte $10 ; |   X    | $D9A7
       .byte $10 ; |   X    | $D9A8
       .byte $10 ; |   X    | $D9A9
       .byte $11 ; |   X   X| $D9AA
       .byte $11 ; |   X   X| $D9AB
       .byte $11 ; |   X   X| $D9AC
       .byte $11 ; |   X   X| $D9AD
       .byte $11 ; |   X   X| $D9AE
       .byte $11 ; |   X   X| $D9AF
       .byte $11 ; |   X   X| $D9B0
       .byte $11 ; |   X   X| $D9B1
       .byte $11 ; |   X   X| $D9B2
       .byte $11 ; |   X   X| $D9B3
       .byte $12 ; |   X  X | $D9B4
       .byte $12 ; |   X  X | $D9B5
       .byte $12 ; |   X  X | $D9B6
       .byte $12 ; |   X  X | $D9B7
       .byte $12 ; |   X  X | $D9B8
       .byte $12 ; |   X  X | $D9B9
       .byte $12 ; |   X  X | $D9BA
       .byte $12 ; |   X  X | $D9BB
       .byte $12 ; |   X  X | $D9BC
       .byte $12 ; |   X  X | $D9BD
       .byte $13 ; |   X  XX| $D9BE
       .byte $13 ; |   X  XX| $D9BF
       .byte $13 ; |   X  XX| $D9C0
       .byte $13 ; |   X  XX| $D9C1
       .byte $13 ; |   X  XX| $D9C2
       .byte $13 ; |   X  XX| $D9C3
       .byte $13 ; |   X  XX| $D9C4
       .byte $13 ; |   X  XX| $D9C5
       .byte $13 ; |   X  XX| $D9C6
       .byte $13 ; |   X  XX| $D9C7
       .byte $14 ; |   X X  | $D9C8
       .byte $14 ; |   X X  | $D9C9
       .byte $14 ; |   X X  | $D9CA
       .byte $14 ; |   X X  | $D9CB
       .byte $14 ; |   X X  | $D9CC
       .byte $14 ; |   X X  | $D9CD
       .byte $14 ; |   X X  | $D9CE
       .byte $14 ; |   X X  | $D9CF
       .byte $14 ; |   X X  | $D9D0
       .byte $14 ; |   X X  | $D9D1
       .byte $15 ; |   X X X| $D9D2
       .byte $15 ; |   X X X| $D9D3
       .byte $15 ; |   X X X| $D9D4
       .byte $15 ; |   X X X| $D9D5
       .byte $15 ; |   X X X| $D9D6
       .byte $15 ; |   X X X| $D9D7
       .byte $15 ; |   X X X| $D9D8
       .byte $15 ; |   X X X| $D9D9
       .byte $15 ; |   X X X| $D9DA
       .byte $15 ; |   X X X| $D9DB
       .byte $16 ; |   X XX | $D9DC
       .byte $16 ; |   X XX | $D9DD
       .byte $16 ; |   X XX | $D9DE
       .byte $16 ; |   X XX | $D9DF
       .byte $16 ; |   X XX | $D9E0
       .byte $16 ; |   X XX | $D9E1
       .byte $16 ; |   X XX | $D9E2
       .byte $16 ; |   X XX | $D9E3
       .byte $16 ; |   X XX | $D9E4
       .byte $16 ; |   X XX | $D9E5
       .byte $17 ; |   X XXX| $D9E6
       .byte $17 ; |   X XXX| $D9E7
       .byte $17 ; |   X XXX| $D9E8
       .byte $17 ; |   X XXX| $D9E9
       .byte $17 ; |   X XXX| $D9EA
       .byte $17 ; |   X XXX| $D9EB
       .byte $17 ; |   X XXX| $D9EC
       .byte $17 ; |   X XXX| $D9ED
       .byte $17 ; |   X XXX| $D9EE
       .byte $17 ; |   X XXX| $D9EF
       .byte $18 ; |   XX   | $D9F0
       .byte $18 ; |   XX   | $D9F1
       .byte $18 ; |   XX   | $D9F2
       .byte $18 ; |   XX   | $D9F3
       .byte $18 ; |   XX   | $D9F4
       .byte $18 ; |   XX   | $D9F5
       .byte $18 ; |   XX   | $D9F6
       .byte $18 ; |   XX   | $D9F7
       .byte $18 ; |   XX   | $D9F8
       .byte $18 ; |   XX   | $D9F9
       .byte $19 ; |   XX  X| $D9FA
       .byte $19 ; |   XX  X| $D9FB
       .byte $19 ; |   XX  X| $D9FC
       .byte $19 ; |   XX  X| $D9FD
       .byte $19 ; |   XX  X| $D9FE
       .byte $19 ; |   XX  X| $D9FF
       LDA    #$BF                    ;2
       STA    $AC                     ;3
       LDA    #$BE                    ;2
       STA    $AE                     ;3
       TSX                            ;2
       LDA    $F0EC,X                 ;4
       ASL                            ;2
       ASL                            ;2
       TAX                            ;2
       LDY    #$02                    ;2
       JMP    LD7F1                   ;3
       LDA    #$BE                    ;2
       STA    $AE                     ;3
       LDX    #$0A                    ;2
       LDY    #$01                    ;2
       JMP    LD7F1                   ;3
       LDA    #$BA                    ;2
       STA    $AC                     ;3
       LDA    #$BE                    ;2
       STA    $AE                     ;3
       LDY    #$00                    ;2
       JMP    LD7F1                   ;3
       LDA    #$BA                    ;2
       STA    $AC                     ;3
       LDA    #$BE                    ;2
       STA    $AE                     ;3
       LDA    $BD                     ;3
       STA    PF0                     ;3
       LDA    $BE                     ;3
       STA    PF1                     ;3
       LDA    $BF                     ;3
       STA    PF2                     ;3
       TSX                            ;2
       LDY    #$03                    ;2
       JMP    LD7F1                   ;3
LDA46: .byte $F2 ; |XXXX  X | $DA46
       .byte $74 ; | XXX X  | $DA47
       .byte $54 ; | X X X  | $DA48
       .byte $14 ; |   X X  | $DA49
       .byte $44 ; | X   X  | $DA4A
       .byte $36 ; |  XX XX | $DA4B
       .byte $C2 ; |XX    X | $DA4C
LDA4D: .byte $F6 ; |XXXX XX | $DA4D
       .byte $78 ; | XXXX   | $DA4E
       .byte $58 ; | X XX   | $DA4F
       .byte $18 ; |   XX   | $DA50
       .byte $48 ; | X  X   | $DA51
       .byte $3A ; |  XXX X | $DA52
       .byte $C6 ; |XX   XX | $DA53
LDA54: .byte $1C ; |   XXX  | $DA54
       .byte $1C ; |   XXX  | $DA55
       .byte $1C ; |   XXX  | $DA56
       .byte $1C ; |   XXX  | $DA57
       .byte $1C ; |   XXX  | $DA58
       .byte $1C ; |   XXX  | $DA59
       .byte $1C ; |   XXX  | $DA5A
       .byte $1C ; |   XXX  | $DA5B
       .byte $1C ; |   XXX  | $DA5C
       .byte $1C ; |   XXX  | $DA5D
       .byte $1C ; |   XXX  | $DA5E
       .byte $1C ; |   XXX  | $DA5F
       .byte $16 ; |   X XX | $DA60
       .byte $C8 ; |XX  X   | $DA61
       .byte $26 ; |  X  XX | $DA62
       .byte $44 ; | X   X  | $DA63
       .byte $08 ; |    X   | $DA64
       .byte $DA ; |XX XX X | $DA65
       .byte $28 ; |  X X   | $DA66
       .byte $1C ; |   XXX  | $DA67
       .byte $1C ; |   XXX  | $DA68
       .byte $1C ; |   XXX  | $DA69
       .byte $1C ; |   XXX  | $DA6A
       .byte $1C ; |   XXX  | $DA6B
       .byte $1C ; |   XXX  | $DA6C
       .byte $1C ; |   XXX  | $DA6D
       .byte $30 ; |  XX    | $DA6E
       .byte $26 ; |  X  XX | $DA6F
LDA70: .byte $44 ; | X   X  | $DA70
       .byte $66 ; | XX  XX | $DA71
       .byte $C8 ; |XX  X   | $DA72
       .byte $28 ; |  X X   | $DA73
LDA74: .byte $FB ; |XXXXX XX| $DA74
       .byte $05 ; |     X X| $DA75
       .byte $0F ; |    XXXX| $DA76
       .byte $19 ; |   XX  X| $DA77
       .byte $FF ; |XXXXXXXX| $DA78
       STA    GRP1                    ;3
       LDY    $B1                     ;3
       LDA    ($A9),Y                 ;5
       STA    $B2                     ;3
       INY                            ;2
       LDA    ($A9),Y                 ;5
       STA    $B3                     ;3
       INY                            ;2
       LDA    ($A9),Y                 ;5
       STA    $B4                     ;3
       INY                            ;2
       STY    $B1                     ;3
       STA    BANK2                   ;4
       .byte $FF ; |XXXXXXXX| $DA91
       .byte $FF ; |XXXXXXXX| $DA92
       LDA    #$BF                    ;2
       STA    $AC                     ;3
       LDA    #$B6                    ;2
       STA    $AE                     ;3
       LDA    $BD                     ;3
       STA    PF0                     ;3
       LDA    $BE                     ;3
       STA    PF1                     ;3
       LDA    $BF                     ;3
       STA    PF2                     ;3
       TSX                            ;2
       LDA    $F0EC,X                 ;4
       STA    $A0                     ;3
       LDY    #$01                    ;2
       JMP    LD7F1                   ;3
       LDA    #$BF                    ;2
       STA    $AC                     ;3
       TSX                            ;2
       LDA    $F0EC,X                 ;4
       STA    $A0                     ;3
       LDX    $B0                     ;3
       LDY    #$00                    ;2
       JMP    LD7F1                   ;3
       LDA    #$BF                    ;2
       STA    $AC                     ;3
       LDA    #$BE                    ;2
       STA    $AE                     ;3
       TSX                            ;2
       LDA    $F0EC,X                 ;4
       STA    $A0                     ;3
       LDY    #$04                    ;2
       JMP    LD7F1                   ;3
       LDA    #$BF                    ;2
       STA    $AC                     ;3
       LDA    #$BE                    ;2
       STA    $AE                     ;3
       TSX                            ;2
       LDA    $F0EC,X                 ;4
       STA    $A0                     ;3
       LDY    #$03                    ;2
       JMP    LD7F1                   ;3
       LDA    #$BA                    ;2
       STA    $AC                     ;3
       LDA    #$BE                    ;2
       STA    $AE                     ;3
       TSX                            ;2
       LDY    #$01                    ;2
       JMP    LD7F1                   ;3
LDAF7: .byte $DC ; |XX XXX  | $DAF7
       .byte $DC ; |XX XXX  | $DAF8
       .byte $DD ; |XX XXX X| $DAF9
       .byte $DD ; |XX XXX X| $DAFA
       .byte $DE ; |XX XXXX | $DAFB
       .byte $DE ; |XX XXXX | $DAFC
       .byte $DF ; |XX XXXXX| $DAFD
       .byte $FF ; |XXXXXXXX| $DAFE
       .byte $FF ; |XXXXXXXX| $DAFF
LDB00: .byte $00 ; |        | $DB00
       .byte $01 ; |       X| $DB01
       .byte $02 ; |      X | $DB02
       .byte $03 ; |      XX| $DB03
       .byte $04 ; |     X  | $DB04
       .byte $05 ; |     X X| $DB05
       .byte $06 ; |     XX | $DB06
       .byte $07 ; |     XXX| $DB07
       .byte $08 ; |    X   | $DB08
       .byte $09 ; |    X  X| $DB09
       .byte $00 ; |        | $DB0A
       .byte $01 ; |       X| $DB0B
       .byte $02 ; |      X | $DB0C
       .byte $03 ; |      XX| $DB0D
       .byte $04 ; |     X  | $DB0E
       .byte $05 ; |     X X| $DB0F
       .byte $06 ; |     XX | $DB10
       .byte $07 ; |     XXX| $DB11
       .byte $08 ; |    X   | $DB12
       .byte $09 ; |    X  X| $DB13
       .byte $00 ; |        | $DB14
       .byte $01 ; |       X| $DB15
       .byte $02 ; |      X | $DB16
       .byte $03 ; |      XX| $DB17
       .byte $04 ; |     X  | $DB18
       .byte $05 ; |     X X| $DB19
       .byte $06 ; |     XX | $DB1A
       .byte $07 ; |     XXX| $DB1B
       .byte $08 ; |    X   | $DB1C
       .byte $09 ; |    X  X| $DB1D
       .byte $00 ; |        | $DB1E
       .byte $01 ; |       X| $DB1F
       .byte $02 ; |      X | $DB20
       .byte $03 ; |      XX| $DB21
       .byte $04 ; |     X  | $DB22
       .byte $05 ; |     X X| $DB23
       .byte $06 ; |     XX | $DB24
       .byte $07 ; |     XXX| $DB25
       .byte $08 ; |    X   | $DB26
       .byte $09 ; |    X  X| $DB27
       .byte $00 ; |        | $DB28
       .byte $01 ; |       X| $DB29
       .byte $02 ; |      X | $DB2A
       .byte $03 ; |      XX| $DB2B
       .byte $04 ; |     X  | $DB2C
       .byte $05 ; |     X X| $DB2D
       .byte $06 ; |     XX | $DB2E
       .byte $07 ; |     XXX| $DB2F
       .byte $08 ; |    X   | $DB30
       .byte $09 ; |    X  X| $DB31
       .byte $00 ; |        | $DB32
       .byte $01 ; |       X| $DB33
       .byte $02 ; |      X | $DB34
       .byte $03 ; |      XX| $DB35
       .byte $04 ; |     X  | $DB36
       .byte $05 ; |     X X| $DB37
       .byte $06 ; |     XX | $DB38
       .byte $07 ; |     XXX| $DB39
       .byte $08 ; |    X   | $DB3A
       .byte $09 ; |    X  X| $DB3B
       .byte $00 ; |        | $DB3C
       .byte $01 ; |       X| $DB3D
       .byte $02 ; |      X | $DB3E
       .byte $03 ; |      XX| $DB3F
       .byte $04 ; |     X  | $DB40
       .byte $05 ; |     X X| $DB41
       .byte $06 ; |     XX | $DB42
       .byte $07 ; |     XXX| $DB43
       .byte $08 ; |    X   | $DB44
       .byte $09 ; |    X  X| $DB45
       .byte $00 ; |        | $DB46
       .byte $01 ; |       X| $DB47
       .byte $02 ; |      X | $DB48
       .byte $03 ; |      XX| $DB49
       .byte $04 ; |     X  | $DB4A
       .byte $05 ; |     X X| $DB4B
       .byte $06 ; |     XX | $DB4C
       .byte $07 ; |     XXX| $DB4D
       .byte $08 ; |    X   | $DB4E
       .byte $09 ; |    X  X| $DB4F
       .byte $00 ; |        | $DB50
       .byte $01 ; |       X| $DB51
       .byte $02 ; |      X | $DB52
       .byte $03 ; |      XX| $DB53
       .byte $04 ; |     X  | $DB54
       .byte $05 ; |     X X| $DB55
       .byte $06 ; |     XX | $DB56
       .byte $07 ; |     XXX| $DB57
       .byte $08 ; |    X   | $DB58
       .byte $09 ; |    X  X| $DB59
       .byte $00 ; |        | $DB5A
       .byte $01 ; |       X| $DB5B
       .byte $02 ; |      X | $DB5C
       .byte $03 ; |      XX| $DB5D
       .byte $04 ; |     X  | $DB5E
       .byte $05 ; |     X X| $DB5F
       .byte $06 ; |     XX | $DB60
       .byte $07 ; |     XXX| $DB61
       .byte $08 ; |    X   | $DB62
       .byte $09 ; |    X  X| $DB63
       .byte $00 ; |        | $DB64
       .byte $01 ; |       X| $DB65
       .byte $02 ; |      X | $DB66
       .byte $03 ; |      XX| $DB67
       .byte $04 ; |     X  | $DB68
       .byte $05 ; |     X X| $DB69
       .byte $06 ; |     XX | $DB6A
       .byte $07 ; |     XXX| $DB6B
       .byte $08 ; |    X   | $DB6C
       .byte $09 ; |    X  X| $DB6D
       .byte $00 ; |        | $DB6E
       .byte $01 ; |       X| $DB6F
       .byte $02 ; |      X | $DB70
       .byte $03 ; |      XX| $DB71
       .byte $04 ; |     X  | $DB72
       .byte $05 ; |     X X| $DB73
       .byte $06 ; |     XX | $DB74
       .byte $07 ; |     XXX| $DB75
       .byte $08 ; |    X   | $DB76
       .byte $09 ; |    X  X| $DB77
       .byte $00 ; |        | $DB78
       .byte $01 ; |       X| $DB79
       .byte $02 ; |      X | $DB7A
       .byte $03 ; |      XX| $DB7B
       .byte $04 ; |     X  | $DB7C
       .byte $05 ; |     X X| $DB7D
       .byte $06 ; |     XX | $DB7E
       .byte $07 ; |     XXX| $DB7F
       .byte $08 ; |    X   | $DB80
       .byte $09 ; |    X  X| $DB81
       .byte $00 ; |        | $DB82
       .byte $01 ; |       X| $DB83
       .byte $02 ; |      X | $DB84
       .byte $03 ; |      XX| $DB85
       .byte $04 ; |     X  | $DB86
       .byte $05 ; |     X X| $DB87
       .byte $06 ; |     XX | $DB88
       .byte $07 ; |     XXX| $DB89
       .byte $08 ; |    X   | $DB8A
       .byte $09 ; |    X  X| $DB8B
       .byte $00 ; |        | $DB8C
       .byte $01 ; |       X| $DB8D
       .byte $02 ; |      X | $DB8E
       .byte $03 ; |      XX| $DB8F
       .byte $04 ; |     X  | $DB90
       .byte $05 ; |     X X| $DB91
       .byte $06 ; |     XX | $DB92
       .byte $07 ; |     XXX| $DB93
       .byte $08 ; |    X   | $DB94
       .byte $09 ; |    X  X| $DB95
       .byte $00 ; |        | $DB96
       .byte $01 ; |       X| $DB97
       .byte $02 ; |      X | $DB98
       .byte $03 ; |      XX| $DB99
       .byte $04 ; |     X  | $DB9A
       .byte $05 ; |     X X| $DB9B
       .byte $06 ; |     XX | $DB9C
       .byte $07 ; |     XXX| $DB9D
       .byte $08 ; |    X   | $DB9E
       .byte $09 ; |    X  X| $DB9F
       .byte $00 ; |        | $DBA0
       .byte $01 ; |       X| $DBA1
       .byte $02 ; |      X | $DBA2
       .byte $03 ; |      XX| $DBA3
       .byte $04 ; |     X  | $DBA4
       .byte $05 ; |     X X| $DBA5
       .byte $06 ; |     XX | $DBA6
       .byte $07 ; |     XXX| $DBA7
       .byte $08 ; |    X   | $DBA8
       .byte $09 ; |    X  X| $DBA9
       .byte $00 ; |        | $DBAA
       .byte $01 ; |       X| $DBAB
       .byte $02 ; |      X | $DBAC
       .byte $03 ; |      XX| $DBAD
       .byte $04 ; |     X  | $DBAE
       .byte $05 ; |     X X| $DBAF
       .byte $06 ; |     XX | $DBB0
       .byte $07 ; |     XXX| $DBB1
       .byte $08 ; |    X   | $DBB2
       .byte $09 ; |    X  X| $DBB3
       .byte $00 ; |        | $DBB4
       .byte $01 ; |       X| $DBB5
       .byte $02 ; |      X | $DBB6
       .byte $03 ; |      XX| $DBB7
       .byte $04 ; |     X  | $DBB8
       .byte $05 ; |     X X| $DBB9
       .byte $06 ; |     XX | $DBBA
       .byte $07 ; |     XXX| $DBBB
       .byte $08 ; |    X   | $DBBC
       .byte $09 ; |    X  X| $DBBD
       .byte $00 ; |        | $DBBE
       .byte $01 ; |       X| $DBBF
       .byte $02 ; |      X | $DBC0
       .byte $03 ; |      XX| $DBC1
       .byte $04 ; |     X  | $DBC2
       .byte $05 ; |     X X| $DBC3
       .byte $06 ; |     XX | $DBC4
       .byte $07 ; |     XXX| $DBC5
       .byte $08 ; |    X   | $DBC6
       .byte $09 ; |    X  X| $DBC7
       .byte $00 ; |        | $DBC8
       .byte $01 ; |       X| $DBC9
       .byte $02 ; |      X | $DBCA
       .byte $03 ; |      XX| $DBCB
       .byte $04 ; |     X  | $DBCC
       .byte $05 ; |     X X| $DBCD
       .byte $06 ; |     XX | $DBCE
       .byte $07 ; |     XXX| $DBCF
       .byte $08 ; |    X   | $DBD0
       .byte $09 ; |    X  X| $DBD1
       .byte $00 ; |        | $DBD2
       .byte $01 ; |       X| $DBD3
       .byte $02 ; |      X | $DBD4
       .byte $03 ; |      XX| $DBD5
       .byte $04 ; |     X  | $DBD6
       .byte $05 ; |     X X| $DBD7
       .byte $06 ; |     XX | $DBD8
       .byte $07 ; |     XXX| $DBD9
       .byte $08 ; |    X   | $DBDA
       .byte $09 ; |    X  X| $DBDB
       .byte $00 ; |        | $DBDC
       .byte $01 ; |       X| $DBDD
       .byte $02 ; |      X | $DBDE
       .byte $03 ; |      XX| $DBDF
       .byte $04 ; |     X  | $DBE0
       .byte $05 ; |     X X| $DBE1
       .byte $06 ; |     XX | $DBE2
       .byte $07 ; |     XXX| $DBE3
       .byte $08 ; |    X   | $DBE4
       .byte $09 ; |    X  X| $DBE5
       .byte $00 ; |        | $DBE6
       .byte $01 ; |       X| $DBE7
       .byte $02 ; |      X | $DBE8
       .byte $03 ; |      XX| $DBE9
       .byte $04 ; |     X  | $DBEA
       .byte $05 ; |     X X| $DBEB
       .byte $06 ; |     XX | $DBEC
       .byte $07 ; |     XXX| $DBED
       .byte $08 ; |    X   | $DBEE
       .byte $09 ; |    X  X| $DBEF
       .byte $00 ; |        | $DBF0
       .byte $01 ; |       X| $DBF1
       .byte $02 ; |      X | $DBF2
       .byte $03 ; |      XX| $DBF3
       .byte $04 ; |     X  | $DBF4
       .byte $05 ; |     X X| $DBF5
LDBF6: .byte $06 ; |     XX | $DBF6
       .byte $07 ; |     XXX| $DBF7
       .byte $08 ; |    X   | $DBF8
       .byte $09 ; |    X  X| $DBF9
       .byte $00 ; |        | $DBFA
       .byte $01 ; |       X| $DBFB
       .byte $02 ; |      X | $DBFC
       .byte $03 ; |      XX| $DBFD
       .byte $04 ; |     X  | $DBFE
       .byte $05 ; |     X X| $DBFF
       .byte $F0 ; |XXXX    | $DC00
       .byte $FF ; |XXXXXXXX| $DC01
       .byte $FF ; |XXXXXXXX| $DC02
       .byte $F0 ; |XXXX    | $DC03
       .byte $00 ; |        | $DC04
       .byte $80 ; |X       | $DC05
       .byte $F0 ; |XXXX    | $DC06
       .byte $11 ; |   X   X| $DC07
       .byte $8F ; |X   XXXX| $DC08
       .byte $00 ; |        | $DC09
       .byte $10 ; |   X    | $DC0A
       .byte $88 ; |X   X   | $DC0B
       .byte $80 ; |X       | $DC0C
       .byte $F1 ; |XXXX   X| $DC0D
       .byte $88 ; |X   X   | $DC0E
       .byte $80 ; |X       | $DC0F
       .byte $01 ; |       X| $DC10
       .byte $00 ; |        | $DC11
       .byte $80 ; |X       | $DC12
       .byte $1F ; |   XXXXX| $DC13
       .byte $F8 ; |XXXXX   | $DC14
       .byte $00 ; |        | $DC15
       .byte $00 ; |        | $DC16
       .byte $00 ; |        | $DC17
       .byte $F0 ; |XXXX    | $DC18
       .byte $11 ; |   X   X| $DC19
       .byte $FF ; |XXXXXXXX| $DC1A
       .byte $00 ; |        | $DC1B
       .byte $10 ; |   X    | $DC1C
       .byte $00 ; |        | $DC1D
       .byte $80 ; |X       | $DC1E
       .byte $11 ; |   X   X| $DC1F
       .byte $78 ; | XXXX   | $DC20
       .byte $80 ; |X       | $DC21
       .byte $01 ; |       X| $DC22
       .byte $08 ; |    X   | $DC23
       .byte $80 ; |X       | $DC24
       .byte $F1 ; |XXXX   X| $DC25
       .byte $88 ; |X   X   | $DC26
       .byte $80 ; |X       | $DC27
       .byte $00 ; |        | $DC28
       .byte $80 ; |X       | $DC29
       .byte $80 ; |X       | $DC2A
       .byte $11 ; |   X   X| $DC2B
       .byte $F8 ; |XXXXX   | $DC2C
       .byte $00 ; |        | $DC2D
       .byte $11 ; |   X   X| $DC2E
       .byte $00 ; |        | $DC2F
       .byte $F0 ; |XXXX    | $DC30
       .byte $11 ; |   X   X| $DC31
       .byte $F8 ; |XXXXX   | $DC32
       .byte $00 ; |        | $DC33
       .byte $10 ; |   X    | $DC34
       .byte $08 ; |    X   | $DC35
       .byte $80 ; |X       | $DC36
       .byte $F1 ; |XXXX   X| $DC37
       .byte $F8 ; |XXXXX   | $DC38
       .byte $00 ; |        | $DC39
       .byte $01 ; |       X| $DC3A
       .byte $00 ; |        | $DC3B
       .byte $80 ; |X       | $DC3C
       .byte $F1 ; |XXXX   X| $DC3D
       .byte $F8 ; |XXXXX   | $DC3E
       .byte $00 ; |        | $DC3F
       .byte $11 ; |   X   X| $DC40
       .byte $80 ; |X       | $DC41
       .byte $F0 ; |XXXX    | $DC42
       .byte $11 ; |   X   X| $DC43
       .byte $88 ; |X   X   | $DC44
       .byte $00 ; |        | $DC45
       .byte $00 ; |        | $DC46
       .byte $08 ; |    X   | $DC47
       .byte $80 ; |X       | $DC48
       .byte $11 ; |   X   X| $DC49
       .byte $8F ; |X   XXXX| $DC4A
       .byte $80 ; |X       | $DC4B
       .byte $10 ; |   X    | $DC4C
       .byte $80 ; |X       | $DC4D
       .byte $80 ; |X       | $DC4E
       .byte $11 ; |   X   X| $DC4F
       .byte $8F ; |X   XXXX| $DC50
       .byte $00 ; |        | $DC51
       .byte $10 ; |   X    | $DC52
       .byte $88 ; |X   X   | $DC53
       .byte $80 ; |X       | $DC54
       .byte $F1 ; |XXXX   X| $DC55
       .byte $88 ; |X   X   | $DC56
       .byte $00 ; |        | $DC57
       .byte $01 ; |       X| $DC58
       .byte $00 ; |        | $DC59
       .byte $80 ; |X       | $DC5A
       .byte $1F ; |   XXXXX| $DC5B
       .byte $F8 ; |XXXXX   | $DC5C
       .byte $80 ; |X       | $DC5D
       .byte $00 ; |        | $DC5E
       .byte $00 ; |        | $DC5F
       .byte $80 ; |X       | $DC60
       .byte $11 ; |   X   X| $DC61
       .byte $F8 ; |XXXXX   | $DC62
       .byte $00 ; |        | $DC63
       .byte $11 ; |   X   X| $DC64
       .byte $80 ; |X       | $DC65
       .byte $F0 ; |XXXX    | $DC66
       .byte $11 ; |   X   X| $DC67
       .byte $88 ; |X   X   | $DC68
       .byte $F0 ; |XXXX    | $DC69
       .byte $00 ; |        | $DC6A
       .byte $08 ; |    X   | $DC6B
       .byte $F0 ; |XXXX    | $DC6C
       .byte $FF ; |XXXXXXXX| $DC6D
       .byte $FF ; |XXXXXXXX| $DC6E
       .byte $F0 ; |XXXX    | $DC6F
       .byte $00 ; |        | $DC70
       .byte $80 ; |X       | $DC71
       .byte $F0 ; |XXXX    | $DC72
       .byte $11 ; |   X   X| $DC73
       .byte $8F ; |X   XXXX| $DC74
       .byte $00 ; |        | $DC75
       .byte $11 ; |   X   X| $DC76
       .byte $00 ; |        | $DC77
       .byte $80 ; |X       | $DC78
       .byte $11 ; |   X   X| $DC79
       .byte $78 ; | XXXX   | $DC7A
       .byte $80 ; |X       | $DC7B
       .byte $10 ; |   X    | $DC7C
       .byte $78 ; | XXXX   | $DC7D
       .byte $80 ; |X       | $DC7E
       .byte $1F ; |   XXXXX| $DC7F
       .byte $78 ; | XXXX   | $DC80
       .byte $00 ; |        | $DC81
       .byte $00 ; |        | $DC82
       .byte $78 ; | XXXX   | $DC83
       .byte $80 ; |X       | $DC84
       .byte $F1 ; |XXXX   X| $DC85
       .byte $78 ; | XXXX   | $DC86
       .byte $00 ; |        | $DC87
       .byte $11 ; |   X   X| $DC88
       .byte $00 ; |        | $DC89
       .byte $80 ; |X       | $DC8A
       .byte $11 ; |   X   X| $DC8B
       .byte $F8 ; |XXXXX   | $DC8C
       .byte $80 ; |X       | $DC8D
       .byte $11 ; |   X   X| $DC8E
       .byte $80 ; |X       | $DC8F
       .byte $80 ; |X       | $DC90
       .byte $11 ; |   X   X| $DC91
       .byte $8F ; |X   XXXX| $DC92
       .byte $00 ; |        | $DC93
       .byte $10 ; |   X    | $DC94
       .byte $00 ; |        | $DC95
       .byte $80 ; |X       | $DC96
       .byte $11 ; |   X   X| $DC97
       .byte $F8 ; |XXXXX   | $DC98
       .byte $80 ; |X       | $DC99
       .byte $01 ; |       X| $DC9A
       .byte $00 ; |        | $DC9B
       .byte $80 ; |X       | $DC9C
       .byte $FF ; |XXXXXXXX| $DC9D
       .byte $F8 ; |XXXXX   | $DC9E
       .byte $80 ; |X       | $DC9F
       .byte $01 ; |       X| $DCA0
       .byte $08 ; |    X   | $DCA1
       .byte $80 ; |X       | $DCA2
       .byte $11 ; |   X   X| $DCA3
       .byte $F8 ; |XXXXX   | $DCA4
       .byte $00 ; |        | $DCA5
       .byte $10 ; |   X    | $DCA6
       .byte $00 ; |        | $DCA7
       .byte $80 ; |X       | $DCA8
       .byte $11 ; |   X   X| $DCA9
       .byte $F8 ; |XXXXX   | $DCAA
       .byte $80 ; |X       | $DCAB
       .byte $11 ; |   X   X| $DCAC
       .byte $00 ; |        | $DCAD
       .byte $80 ; |X       | $DCAE
       .byte $11 ; |   X   X| $DCAF
       .byte $8F ; |X   XXXX| $DCB0
       .byte $00 ; |        | $DCB1
       .byte $11 ; |   X   X| $DCB2
       .byte $00 ; |        | $DCB3
       .byte $80 ; |X       | $DCB4
       .byte $F1 ; |XXXX   X| $DCB5
       .byte $F8 ; |XXXXX   | $DCB6
       .byte $00 ; |        | $DCB7
       .byte $01 ; |       X| $DCB8
       .byte $00 ; |        | $DCB9
       .byte $80 ; |X       | $DCBA
       .byte $1F ; |   XXXXX| $DCBB
       .byte $88 ; |X   X   | $DCBC
       .byte $80 ; |X       | $DCBD
       .byte $10 ; |   X    | $DCBE
       .byte $08 ; |    X   | $DCBF
       .byte $80 ; |X       | $DCC0
       .byte $11 ; |   X   X| $DCC1
       .byte $8F ; |X   XXXX| $DCC2
       .byte $80 ; |X       | $DCC3
       .byte $01 ; |       X| $DCC4
       .byte $80 ; |X       | $DCC5
       .byte $80 ; |X       | $DCC6
       .byte $1F ; |   XXXXX| $DCC7
       .byte $88 ; |X   X   | $DCC8
       .byte $00 ; |        | $DCC9
       .byte $10 ; |   X    | $DCCA
       .byte $08 ; |    X   | $DCCB
       .byte $80 ; |X       | $DCCC
       .byte $F1 ; |XXXX   X| $DCCD
       .byte $8F ; |X   XXXX| $DCCE
       .byte $00 ; |        | $DCCF
       .byte $01 ; |       X| $DCD0
       .byte $80 ; |X       | $DCD1
       .byte $F0 ; |XXXX    | $DCD2
       .byte $1F ; |   XXXXX| $DCD3
       .byte $88 ; |X   X   | $DCD4
       .byte $F0 ; |XXXX    | $DCD5
       .byte $00 ; |        | $DCD6
       .byte $08 ; |    X   | $DCD7
       .byte $F0 ; |XXXX    | $DCD8
       .byte $FF ; |XXXXXXXX| $DCD9
       .byte $FF ; |XXXXXXXX| $DCDA
LDCDB: .byte $03 ; |      XX| $DCDB
       .byte $03 ; |      XX| $DCDC
       .byte $04 ; |     X  | $DCDD
       .byte $02 ; |      X | $DCDE
       .byte $02 ; |      X | $DCDF
       .byte $03 ; |      XX| $DCE0
       .byte $03 ; |      XX| $DCE1
       .byte $03 ; |      XX| $DCE2
       .byte $03 ; |      XX| $DCE3
       .byte $03 ; |      XX| $DCE4
       .byte $03 ; |      XX| $DCE5
       .byte $03 ; |      XX| $DCE6
       .byte $01 ; |       X| $DCE7
       .byte $01 ; |       X| $DCE8
       .byte $01 ; |       X| $DCE9
       .byte $01 ; |       X| $DCEA
       .byte $01 ; |       X| $DCEB
       .byte $01 ; |       X| $DCEC
       .byte $01 ; |       X| $DCED
       .byte $02 ; |      X | $DCEE
       .byte $05 ; |     X X| $DCEF
       .byte $02 ; |      X | $DCF0
       .byte $02 ; |      X | $DCF1
       .byte $05 ; |     X X| $DCF2
       .byte $02 ; |      X | $DCF3
       .byte $02 ; |      X | $DCF4
       .byte $02 ; |      X | $DCF5
       .byte $02 ; |      X | $DCF6
       LDA    #$BA                    ;2
       STA    $AC                     ;3
       LDX    $B0                     ;3
       LDY    #$00                    ;2
       JMP    LD7F1                   ;3
       .byte $F0 ; |XXXX    | $DD02
       .byte $FF ; |XXXXXXXX| $DD03
       .byte $FF ; |XXXXXXXX| $DD04
       .byte $F0 ; |XXXX    | $DD05
       .byte $01 ; |       X| $DD06
       .byte $80 ; |X       | $DD07
       .byte $F0 ; |XXXX    | $DD08
       .byte $11 ; |   X   X| $DD09
       .byte $88 ; |X   X   | $DD0A
       .byte $00 ; |        | $DD0B
       .byte $10 ; |   X    | $DD0C
       .byte $08 ; |    X   | $DD0D
       .byte $80 ; |X       | $DD0E
       .byte $F1 ; |XXXX   X| $DD0F
       .byte $78 ; | XXXX   | $DD10
       .byte $00 ; |        | $DD11
       .byte $01 ; |       X| $DD12
       .byte $00 ; |        | $DD13
       .byte $80 ; |X       | $DD14
       .byte $1F ; |   XXXXX| $DD15
       .byte $8F ; |X   XXXX| $DD16
       .byte $80 ; |X       | $DD17
       .byte $00 ; |        | $DD18
       .byte $08 ; |    X   | $DD19
       .byte $80 ; |X       | $DD1A
       .byte $FF ; |XXXXXXXX| $DD1B
       .byte $88 ; |X   X   | $DD1C
       .byte $00 ; |        | $DD1D
       .byte $10 ; |   X    | $DD1E
       .byte $80 ; |X       | $DD1F
       .byte $F0 ; |XXXX    | $DD20
       .byte $11 ; |   X   X| $DD21
       .byte $F8 ; |XXXXX   | $DD22
       .byte $00 ; |        | $DD23
       .byte $01 ; |       X| $DD24
       .byte $00 ; |        | $DD25
       .byte $80 ; |X       | $DD26
       .byte $F1 ; |XXXX   X| $DD27
       .byte $7F ; | XXXXXXX| $DD28
       .byte $00 ; |        | $DD29
       .byte $10 ; |   X    | $DD2A
       .byte $08 ; |    X   | $DD2B
       .byte $F0 ; |XXXX    | $DD2C
       .byte $11 ; |   X   X| $DD2D
       .byte $88 ; |X   X   | $DD2E
       .byte $F0 ; |XXXX    | $DD2F
       .byte $01 ; |       X| $DD30
       .byte $00 ; |        | $DD31
       .byte $F0 ; |XXXX    | $DD32
       .byte $1F ; |   XXXXX| $DD33
       .byte $F8 ; |XXXXX   | $DD34
       .byte $00 ; |        | $DD35
       .byte $00 ; |        | $DD36
       .byte $08 ; |    X   | $DD37
       .byte $80 ; |X       | $DD38
       .byte $F1 ; |XXXX   X| $DD39
       .byte $F8 ; |XXXXX   | $DD3A
       .byte $00 ; |        | $DD3B
       .byte $01 ; |       X| $DD3C
       .byte $00 ; |        | $DD3D
       .byte $F0 ; |XXXX    | $DD3E
       .byte $1F ; |   XXXXX| $DD3F
       .byte $8F ; |X   XXXX| $DD40
       .byte $F0 ; |XXXX    | $DD41
       .byte $10 ; |   X    | $DD42
       .byte $80 ; |X       | $DD43
       .byte $F0 ; |XXXX    | $DD44
       .byte $11 ; |   X   X| $DD45
       .byte $88 ; |X   X   | $DD46
       .byte $00 ; |        | $DD47
       .byte $00 ; |        | $DD48
       .byte $08 ; |    X   | $DD49
       .byte $80 ; |X       | $DD4A
       .byte $F1 ; |XXXX   X| $DD4B
       .byte $7F ; | XXXXXXX| $DD4C
       .byte $00 ; |        | $DD4D
       .byte $10 ; |   X    | $DD4E
       .byte $08 ; |    X   | $DD4F
       .byte $F0 ; |XXXX    | $DD50
       .byte $1F ; |   XXXXX| $DD51
       .byte $88 ; |X   X   | $DD52
       .byte $00 ; |        | $DD53
       .byte $10 ; |   X    | $DD54
       .byte $80 ; |X       | $DD55
       .byte $80 ; |X       | $DD56
       .byte $11 ; |   X   X| $DD57
       .byte $F8 ; |XXXXX   | $DD58
       .byte $80 ; |X       | $DD59
       .byte $01 ; |       X| $DD5A
       .byte $80 ; |X       | $DD5B
       .byte $80 ; |X       | $DD5C
       .byte $FF ; |XXXXXXXX| $DD5D
       .byte $8F ; |X   XXXX| $DD5E
       .byte $00 ; |        | $DD5F
       .byte $00 ; |        | $DD60
       .byte $08 ; |    X   | $DD61
       .byte $80 ; |X       | $DD62
       .byte $F1 ; |XXXX   X| $DD63
       .byte $88 ; |X   X   | $DD64
       .byte $80 ; |X       | $DD65
       .byte $01 ; |       X| $DD66
       .byte $80 ; |X       | $DD67
       .byte $80 ; |X       | $DD68
       .byte $11 ; |   X   X| $DD69
       .byte $F8 ; |XXXXX   | $DD6A
       .byte $00 ; |        | $DD6B
       .byte $10 ; |   X    | $DD6C
       .byte $00 ; |        | $DD6D
       .byte $F0 ; |XXXX    | $DD6E
       .byte $FF ; |XXXXXXXX| $DD6F
       .byte $FF ; |XXXXXXXX| $DD70
       .byte $00 ; |        | $DD71
       .byte $00 ; |        | $DD72
       .byte $80 ; |X       | $DD73
       .byte $80 ; |X       | $DD74
       .byte $11 ; |   X   X| $DD75
       .byte $88 ; |X   X   | $DD76
       .byte $80 ; |X       | $DD77
       .byte $11 ; |   X   X| $DD78
       .byte $88 ; |X   X   | $DD79
       .byte $80 ; |X       | $DD7A
       .byte $11 ; |   X   X| $DD7B
       .byte $88 ; |X   X   | $DD7C
       .byte $00 ; |        | $DD7D
       .byte $00 ; |        | $DD7E
       .byte $00 ; |        | $DD7F
       .byte $F0 ; |XXXX    | $DD80
       .byte $F1 ; |XXXX   X| $DD81
       .byte $78 ; | XXXX   | $DD82
       .byte $00 ; |        | $DD83
       .byte $01 ; |       X| $DD84
       .byte $08 ; |    X   | $DD85
       .byte $80 ; |X       | $DD86
       .byte $FF ; |XXXXXXXX| $DD87
       .byte $88 ; |X   X   | $DD88
       .byte $00 ; |        | $DD89
       .byte $00 ; |        | $DD8A
       .byte $88 ; |X   X   | $DD8B
       .byte $80 ; |X       | $DD8C
       .byte $FF ; |XXXXXXXX| $DD8D
       .byte $8F ; |X   XXXX| $DD8E
       .byte $80 ; |X       | $DD8F
       .byte $00 ; |        | $DD90
       .byte $00 ; |        | $DD91
       .byte $80 ; |X       | $DD92
       .byte $1F ; |   XXXXX| $DD93
       .byte $F8 ; |XXXXX   | $DD94
       .byte $00 ; |        | $DD95
       .byte $10 ; |   X    | $DD96
       .byte $00 ; |        | $DD97
       .byte $F0 ; |XXXX    | $DD98
       .byte $11 ; |   X   X| $DD99
       .byte $8F ; |X   XXXX| $DD9A
       .byte $00 ; |        | $DD9B
       .byte $01 ; |       X| $DD9C
       .byte $00 ; |        | $DD9D
       .byte $80 ; |X       | $DD9E
       .byte $11 ; |   X   X| $DD9F
       .byte $F8 ; |XXXXX   | $DDA0
       .byte $80 ; |X       | $DDA1
       .byte $11 ; |   X   X| $DDA2
       .byte $08 ; |    X   | $DDA3
       .byte $80 ; |X       | $DDA4
       .byte $11 ; |   X   X| $DDA5
       .byte $F8 ; |XXXXX   | $DDA6
       .byte $80 ; |X       | $DDA7
       .byte $10 ; |   X    | $DDA8
       .byte $80 ; |X       | $DDA9
       .byte $80 ; |X       | $DDAA
       .byte $1F ; |   XXXXX| $DDAB
       .byte $88 ; |X   X   | $DDAC
       .byte $00 ; |        | $DDAD
       .byte $01 ; |       X| $DDAE
       .byte $08 ; |    X   | $DDAF
       .byte $80 ; |X       | $DDB0
       .byte $F1 ; |XXXX   X| $DDB1
       .byte $88 ; |X   X   | $DDB2
       .byte $00 ; |        | $DDB3
       .byte $10 ; |   X    | $DDB4
       .byte $80 ; |X       | $DDB5
       .byte $F0 ; |XXXX    | $DDB6
       .byte $11 ; |   X   X| $DDB7
       .byte $88 ; |X   X   | $DDB8
       .byte $00 ; |        | $DDB9
       .byte $01 ; |       X| $DDBA
       .byte $08 ; |    X   | $DDBB
       .byte $80 ; |X       | $DDBC
       .byte $11 ; |   X   X| $DDBD
       .byte $78 ; | XXXX   | $DDBE
       .byte $80 ; |X       | $DDBF
       .byte $11 ; |   X   X| $DDC0
       .byte $00 ; |        | $DDC1
       .byte $80 ; |X       | $DDC2
       .byte $11 ; |   X   X| $DDC3
       .byte $8F ; |X   XXXX| $DDC4
       .byte $00 ; |        | $DDC5
       .byte $10 ; |   X    | $DDC6
       .byte $88 ; |X   X   | $DDC7
       .byte $80 ; |X       | $DDC8
       .byte $FF ; |XXXXXXXX| $DDC9
       .byte $88 ; |X   X   | $DDCA
       .byte $00 ; |        | $DDCB
       .byte $01 ; |       X| $DDCC
       .byte $00 ; |        | $DDCD
       .byte $80 ; |X       | $DDCE
       .byte $11 ; |   X   X| $DDCF
       .byte $88 ; |X   X   | $DDD0
       .byte $80 ; |X       | $DDD1
       .byte $11 ; |   X   X| $DDD2
       .byte $88 ; |X   X   | $DDD3
       .byte $80 ; |X       | $DDD4
       .byte $11 ; |   X   X| $DDD5
       .byte $88 ; |X   X   | $DDD6
       .byte $00 ; |        | $DDD7
       .byte $00 ; |        | $DDD8
       .byte $80 ; |X       | $DDD9
       .byte $F0 ; |XXXX    | $DDDA
       .byte $FF ; |XXXXXXXX| $DDDB
       .byte $FF ; |XXXXXXXX| $DDDC
LDDDD: .byte $A1 ; |X X    X| $DDDD
       .byte $BB ; |X XXX XX| $DDDE
       .byte $6D ; | XX XX X| $DDDF
       .byte $87 ; |X    XXX| $DDE0
       .byte $D5 ; |XX X X X| $DDE1
       .byte $EF ; |XXX XXXX| $DDE2
       .byte $39 ; |  XXX  X| $DDE3
       .byte $53 ; | X X  XX| $DDE4
       .byte $1F ; |   XXXXX| $DDE5
       .byte $EF ; |XXX XXXX| $DDE6
       .byte $1F ; |   XXXXX| $DDE7
       .byte $38 ; |  XXX   | $DDE8
LDDE9: .byte $D5 ; |XX X X X| $DDE9
       .byte $EF ; |XXX XXXX| $DDEA
       .byte $1F ; |   XXXXX| $DDEB
       .byte $D5 ; |XX X X X| $DDEC
       .byte $EF ; |XXX XXXX| $DDED
       .byte $1F ; |   XXXXX| $DDEE
       .byte $87 ; |X    XXX| $DDEF
       .byte $A1 ; |X X    X| $DDF0
       .byte $BB ; |X XXX XX| $DDF1
       .byte $39 ; |  XXX  X| $DDF2
       .byte $53 ; | X X  XX| $DDF3
       .byte $6D ; | XX XX X| $DDF4
       .byte $39 ; |  XXX  X| $DDF5
       .byte $6D ; | XX XX X| $DDF6
       .byte $D5 ; |XX X X X| $DDF7
       .byte $A1 ; |X X    X| $DDF8
       .byte $87 ; |X    XXX| $DDF9
       .byte $BB ; |X XXX XX| $DDFA
       .byte $53 ; | X X  XX| $DDFB
       .byte $87 ; |X    XXX| $DDFC
       .byte $6A ; | XX X X | $DDFD
       .byte $53 ; | X X  XX| $DDFE
       .byte $39 ; |  XXX  X| $DDFF
       .byte $51 ; | X X   X| $DE00
       .byte $BB ; |X XXX XX| $DE01
       LDA    (ENABL,X)               ;6 $1F,X
       ADC    LDAA9                   ;4 wrong bank!
       STA    $AC                     ;3
       LDA    #$BE                    ;2
       STA    $AE                     ;3
       TSX                            ;2
       LDY    #$02                    ;2
       JMP    LD7F1                   ;3
       .byte $F0 ; |XXXX    | $DE13
       .byte $FF ; |XXXXXXXX| $DE14
       .byte $FF ; |XXXXXXXX| $DE15
       .byte $00 ; |        | $DE16
       .byte $01 ; |       X| $DE17
       .byte $00 ; |        | $DE18
       .byte $80 ; |X       | $DE19
       .byte $F1 ; |XXXX   X| $DE1A
       .byte $78 ; | XXXX   | $DE1B
       .byte $00 ; |        | $DE1C
       .byte $00 ; |        | $DE1D
       .byte $00 ; |        | $DE1E
       .byte $80 ; |X       | $DE1F
       .byte $1F ; |   XXXXX| $DE20
       .byte $F8 ; |XXXXX   | $DE21
       .byte $00 ; |        | $DE22
       .byte $00 ; |        | $DE23
       .byte $00 ; |        | $DE24
       .byte $80 ; |X       | $DE25
       .byte $F1 ; |XXXX   X| $DE26
       .byte $8F ; |X   XXXX| $DE27
       .byte $00 ; |        | $DE28
       .byte $00 ; |        | $DE29
       .byte $00 ; |        | $DE2A
       .byte $80 ; |X       | $DE2B
       .byte $F1 ; |XXXX   X| $DE2C
       .byte $8F ; |X   XXXX| $DE2D
       .byte $00 ; |        | $DE2E
       .byte $00 ; |        | $DE2F
       .byte $00 ; |        | $DE30
       .byte $80 ; |X       | $DE31
       .byte $F1 ; |XXXX   X| $DE32
       .byte $F8 ; |XXXXX   | $DE33
       .byte $00 ; |        | $DE34
       .byte $01 ; |       X| $DE35
       .byte $00 ; |        | $DE36
       .byte $80 ; |X       | $DE37
       .byte $1F ; |   XXXXX| $DE38
       .byte $78 ; | XXXX   | $DE39
       .byte $80 ; |X       | $DE3A
       .byte $00 ; |        | $DE3B
       .byte $00 ; |        | $DE3C
       .byte $80 ; |X       | $DE3D
       .byte $1F ; |   XXXXX| $DE3E
       .byte $F8 ; |XXXXX   | $DE3F
       .byte $00 ; |        | $DE40
       .byte $01 ; |       X| $DE41
       .byte $00 ; |        | $DE42
       .byte $F0 ; |XXXX    | $DE43
       .byte $F1 ; |XXXX   X| $DE44
       .byte $F8 ; |XXXXX   | $DE45
       .byte $00 ; |        | $DE46
       .byte $01 ; |       X| $DE47
       .byte $08 ; |    X   | $DE48
       .byte $80 ; |X       | $DE49
       .byte $1F ; |   XXXXX| $DE4A
       .byte $F8 ; |XXXXX   | $DE4B
       .byte $80 ; |X       | $DE4C
       .byte $00 ; |        | $DE4D
       .byte $00 ; |        | $DE4E
       .byte $80 ; |X       | $DE4F
       .byte $11 ; |   X   X| $DE50
       .byte $88 ; |X   X   | $DE51
       .byte $00 ; |        | $DE52
       .byte $11 ; |   X   X| $DE53
       .byte $80 ; |X       | $DE54
       .byte $80 ; |X       | $DE55
       .byte $11 ; |   X   X| $DE56
       .byte $88 ; |X   X   | $DE57
       .byte $80 ; |X       | $DE58
       .byte $00 ; |        | $DE59
       .byte $08 ; |    X   | $DE5A
       .byte $80 ; |X       | $DE5B
       .byte $1F ; |   XXXXX| $DE5C
       .byte $88 ; |X   X   | $DE5D
       .byte $00 ; |        | $DE5E
       .byte $00 ; |        | $DE5F
       .byte $00 ; |        | $DE60
       .byte $F0 ; |XXXX    | $DE61
       .byte $1F ; |   XXXXX| $DE62
       .byte $F8 ; |XXXXX   | $DE63
       .byte $00 ; |        | $DE64
       .byte $00 ; |        | $DE65
       .byte $00 ; |        | $DE66
       .byte $80 ; |X       | $DE67
       .byte $F1 ; |XXXX   X| $DE68
       .byte $8F ; |X   XXXX| $DE69
       .byte $80 ; |X       | $DE6A
       .byte $00 ; |        | $DE6B
       .byte $00 ; |        | $DE6C
       .byte $80 ; |X       | $DE6D
       .byte $1F ; |   XXXXX| $DE6E
       .byte $88 ; |X   X   | $DE6F
       .byte $00 ; |        | $DE70
       .byte $00 ; |        | $DE71
       .byte $88 ; |X   X   | $DE72
       .byte $F0 ; |XXXX    | $DE73
       .byte $1F ; |   XXXXX| $DE74
       .byte $88 ; |X   X   | $DE75
       .byte $00 ; |        | $DE76
       .byte $00 ; |        | $DE77
       .byte $00 ; |        | $DE78
       .byte $80 ; |X       | $DE79
       .byte $F1 ; |XXXX   X| $DE7A
       .byte $8F ; |X   XXXX| $DE7B
       .byte $00 ; |        | $DE7C
       .byte $00 ; |        | $DE7D
       .byte $80 ; |X       | $DE7E
       .byte $F0 ; |XXXX    | $DE7F
       .byte $FF ; |XXXXXXXX| $DE80
       .byte $FF ; |XXXXXXXX| $DE81
       .byte $00 ; |        | $DE82
       .byte $01 ; |       X| $DE83
       .byte $00 ; |        | $DE84
       .byte $80 ; |X       | $DE85
       .byte $11 ; |   X   X| $DE86
       .byte $88 ; |X   X   | $DE87
       .byte $80 ; |X       | $DE88
       .byte $10 ; |   X    | $DE89
       .byte $88 ; |X   X   | $DE8A
       .byte $80 ; |X       | $DE8B
       .byte $1F ; |   XXXXX| $DE8C
       .byte $8F ; |X   XXXX| $DE8D
       .byte $00 ; |        | $DE8E
       .byte $01 ; |       X| $DE8F
       .byte $00 ; |        | $DE90
       .byte $80 ; |X       | $DE91
       .byte $11 ; |   X   X| $DE92
       .byte $88 ; |X   X   | $DE93
       .byte $80 ; |X       | $DE94
       .byte $10 ; |   X    | $DE95
       .byte $08 ; |    X   | $DE96
       .byte $80 ; |X       | $DE97
       .byte $1F ; |   XXXXX| $DE98
       .byte $8F ; |X   XXXX| $DE99
       .byte $00 ; |        | $DE9A
       .byte $01 ; |       X| $DE9B
       .byte $80 ; |X       | $DE9C
       .byte $80 ; |X       | $DE9D
       .byte $F1 ; |XXXX   X| $DE9E
       .byte $F8 ; |XXXXX   | $DE9F
       .byte $80 ; |X       | $DEA0
       .byte $00 ; |        | $DEA1
       .byte $08 ; |    X   | $DEA2
       .byte $80 ; |X       | $DEA3
       .byte $11 ; |   X   X| $DEA4
       .byte $88 ; |X   X   | $DEA5
       .byte $00 ; |        | $DEA6
       .byte $11 ; |   X   X| $DEA7
       .byte $80 ; |X       | $DEA8
       .byte $80 ; |X       | $DEA9
       .byte $F1 ; |XXXX   X| $DEAA
       .byte $8F ; |X   XXXX| $DEAB
       .byte $00 ; |        | $DEAC
       .byte $01 ; |       X| $DEAD
       .byte $00 ; |        | $DEAE
       .byte $F0 ; |XXXX    | $DEAF
       .byte $11 ; |   X   X| $DEB0
       .byte $F8 ; |XXXXX   | $DEB1
       .byte $00 ; |        | $DEB2
       .byte $10 ; |   X    | $DEB3
       .byte $08 ; |    X   | $DEB4
       .byte $80 ; |X       | $DEB5
       .byte $1F ; |   XXXXX| $DEB6
       .byte $F8 ; |XXXXX   | $DEB7
       .byte $80 ; |X       | $DEB8
       .byte $00 ; |        | $DEB9
       .byte $00 ; |        | $DEBA
       .byte $80 ; |X       | $DEBB
       .byte $1F ; |   XXXXX| $DEBC
       .byte $F8 ; |XXXXX   | $DEBD
       .byte $00 ; |        | $DEBE
       .byte $00 ; |        | $DEBF
       .byte $08 ; |    X   | $DEC0
       .byte $80 ; |X       | $DEC1
       .byte $1F ; |   XXXXX| $DEC2
       .byte $88 ; |X   X   | $DEC3
       .byte $80 ; |X       | $DEC4
       .byte $01 ; |       X| $DEC5
       .byte $80 ; |X       | $DEC6
       .byte $80 ; |X       | $DEC7
       .byte $F1 ; |XXXX   X| $DEC8
       .byte $8F ; |X   XXXX| $DEC9
       .byte $80 ; |X       | $DECA
       .byte $01 ; |       X| $DECB
       .byte $80 ; |X       | $DECC
       .byte $80 ; |X       | $DECD
       .byte $1F ; |   XXXXX| $DECE
       .byte $88 ; |X   X   | $DECF
       .byte $00 ; |        | $DED0
       .byte $00 ; |        | $DED1
       .byte $08 ; |    X   | $DED2
       .byte $F0 ; |XXXX    | $DED3
       .byte $F1 ; |XXXX   X| $DED4
       .byte $F8 ; |XXXXX   | $DED5
       .byte $00 ; |        | $DED6
       .byte $01 ; |       X| $DED7
       .byte $80 ; |X       | $DED8
       .byte $80 ; |X       | $DED9
       .byte $F1 ; |XXXX   X| $DEDA
       .byte $88 ; |X   X   | $DEDB
       .byte $00 ; |        | $DEDC
       .byte $10 ; |   X    | $DEDD
       .byte $08 ; |    X   | $DEDE
       .byte $F0 ; |XXXX    | $DEDF
       .byte $1F ; |   XXXXX| $DEE0
       .byte $F8 ; |XXXXX   | $DEE1
       .byte $00 ; |        | $DEE2
       .byte $10 ; |   X    | $DEE3
       .byte $80 ; |X       | $DEE4
       .byte $80 ; |X       | $DEE5
       .byte $F1 ; |XXXX   X| $DEE6
       .byte $8F ; |X   XXXX| $DEE7
       .byte $00 ; |        | $DEE8
       .byte $00 ; |        | $DEE9
       .byte $00 ; |        | $DEEA
       .byte $F0 ; |XXXX    | $DEEB
       .byte $FF ; |XXXXXXXX| $DEEC
       .byte $FF ; |XXXXXXXX| $DEED
LDEEE: LDY    $B1                     ;3
       LDA    ($A9),Y                 ;5
       STA    $BD                     ;3
       INY                            ;2
       LDA    ($A9),Y                 ;5
       STA    $BE                     ;3
       INY                            ;2
       LDA    ($A9),Y                 ;5
       STA    $BF                     ;3
       INY                            ;2
       STY    $B1                     ;3
       LDA    $F080,X                 ;4
       AND    #$A0                    ;2
       ORA    $BD                     ;3
       STA    $C0                     ;3
       LDA    $F0B6,X                 ;4
       AND    #$A0                    ;2
       ORA    $BD                     ;3
       STA    $C6                     ;3
       LDA    $F080,X                 ;4
       ASL                            ;2
       AND    #$A0                    ;2
       ORA    $BD                     ;3
       STA    $C5                     ;3
       LDA    $F0B6,X                 ;4
       ASL                            ;2
       AND    #$A0                    ;2
       ORA    $BD                     ;3
       STA    $CB                     ;3
       LDA    $F0A4,X                 ;4
       AND    #$55                    ;2
       ORA    $BE                     ;3
       STA    $C1                     ;3
       LDA    $F0DA,X                 ;4
       AND    #$55                    ;2
       ORA    $BE                     ;3
       STA    $C7                     ;3
       LDA    $F092,X                 ;4
       AND    #$55                    ;2
       ORA    $BE                     ;3
       STA    $C4                     ;3
       LDA    $F0C8,X                 ;4
       AND    #$55                    ;2
       ORA    $BE                     ;3
       STA    $CA                     ;3
       LDA    $F0A4,X                 ;4
       AND    #$AA                    ;2
       ORA    $BF                     ;3
       STA    $C2                     ;3
       LDA    $F0DA,X                 ;4
       AND    #$AA                    ;2
       ORA    $BF                     ;3
       STA    $C8                     ;3
       LDA    $F092,X                 ;4
       AND    #$AA                    ;2
       ORA    $BF                     ;3
       STA    $C3                     ;3
       LDA    $F0C8,X                 ;4
       AND    #$AA                    ;2
       ORA    $BF                     ;3
       STA    $C9                     ;3
       RTS                            ;6

       LDA    #$BA                    ;2
       STA    $AC                     ;3
       LDA    #$BE                    ;2
       STA    $AE                     ;3
       LDY    #$04                    ;2
       JMP    LD7F1                   ;3
       .byte $FF ; |XXXXXXXX| $DF7D
       .byte $F0 ; |XXXX    | $DF7E
       .byte $FF ; |XXXXXXXX| $DF7F
       .byte $FF ; |XXXXXXXX| $DF80
       .byte $00 ; |        | $DF81
       .byte $00 ; |        | $DF82
       .byte $08 ; |    X   | $DF83
       .byte $80 ; |X       | $DF84
       .byte $FF ; |XXXXXXXX| $DF85
       .byte $88 ; |X   X   | $DF86
       .byte $80 ; |X       | $DF87
       .byte $01 ; |       X| $DF88
       .byte $80 ; |X       | $DF89
       .byte $80 ; |X       | $DF8A
       .byte $11 ; |   X   X| $DF8B
       .byte $88 ; |X   X   | $DF8C
       .byte $80 ; |X       | $DF8D
       .byte $00 ; |        | $DF8E
       .byte $08 ; |    X   | $DF8F
       .byte $80 ; |X       | $DF90
       .byte $F1 ; |XXXX   X| $DF91
       .byte $F8 ; |XXXXX   | $DF92
       .byte $00 ; |        | $DF93
       .byte $00 ; |        | $DF94
       .byte $00 ; |        | $DF95
       .byte $F0 ; |XXXX    | $DF96
       .byte $FF ; |XXXXXXXX| $DF97
       .byte $F8 ; |XXXXX   | $DF98
       .byte $00 ; |        | $DF99
       .byte $00 ; |        | $DF9A
       .byte $00 ; |        | $DF9B
       .byte $80 ; |X       | $DF9C
       .byte $F1 ; |XXXX   X| $DF9D
       .byte $8F ; |X   XXXX| $DF9E
       .byte $00 ; |        | $DF9F
       .byte $00 ; |        | $DFA0
       .byte $80 ; |X       | $DFA1
       .byte $80 ; |X       | $DFA2
       .byte $1F ; |   XXXXX| $DFA3
       .byte $8F ; |X   XXXX| $DFA4
       .byte $80 ; |X       | $DFA5
       .byte $10 ; |   X    | $DFA6
       .byte $08 ; |    X   | $DFA7
       .byte $80 ; |X       | $DFA8
       .byte $11 ; |   X   X| $DFA9
       .byte $88 ; |X   X   | $DFAA
       .byte $80 ; |X       | $DFAB
       .byte $01 ; |       X| $DFAC
       .byte $00 ; |        | $DFAD
       .byte $80 ; |X       | $DFAE
       .byte $F1 ; |XXXX   X| $DFAF
       .byte $F8 ; |XXXXX   | $DFB0
       .byte $00 ; |        | $DFB1
       .byte $00 ; |        | $DFB2
       .byte $08 ; |    X   | $DFB3
       .byte $80 ; |X       | $DFB4
       .byte $F1 ; |XXXX   X| $DFB5
       .byte $F8 ; |XXXXX   | $DFB6
       .byte $80 ; |X       | $DFB7
       .byte $01 ; |       X| $DFB8
       .byte $00 ; |        | $DFB9
       .byte $80 ; |X       | $DFBA
       .byte $11 ; |   X   X| $DFBB
       .byte $88 ; |X   X   | $DFBC
       .byte $80 ; |X       | $DFBD
       .byte $10 ; |   X    | $DFBE
       .byte $08 ; |    X   | $DFBF
       .byte $80 ; |X       | $DFC0
       .byte $1F ; |   XXXXX| $DFC1
       .byte $8F ; |X   XXXX| $DFC2
       .byte $00 ; |        | $DFC3
       .byte $00 ; |        | $DFC4
       .byte $80 ; |X       | $DFC5
       .byte $F0 ; |XXXX    | $DFC6
       .byte $1F ; |   XXXXX| $DFC7
       .byte $8F ; |X   XXXX| $DFC8
       .byte $00 ; |        | $DFC9
       .byte $01 ; |       X| $DFCA
       .byte $80 ; |X       | $DFCB
       .byte $80 ; |X       | $DFCC
       .byte $F1 ; |XXXX   X| $DFCD
       .byte $88 ; |X   X   | $DFCE
       .byte $00 ; |        | $DFCF
       .byte $00 ; |        | $DFD0
       .byte $00 ; |        | $DFD1
       .byte $F0 ; |XXXX    | $DFD2
       .byte $FF ; |XXXXXXXX| $DFD3
       .byte $F8 ; |XXXXX   | $DFD4
       .byte $00 ; |        | $DFD5
       .byte $00 ; |        | $DFD6
       .byte $00 ; |        | $DFD7
       .byte $80 ; |X       | $DFD8
       .byte $F1 ; |XXXX   X| $DFD9
       .byte $F8 ; |XXXXX   | $DFDA
       .byte $80 ; |X       | $DFDB
       .byte $00 ; |        | $DFDC
       .byte $08 ; |    X   | $DFDD
       .byte $80 ; |X       | $DFDE
       .byte $11 ; |   X   X| $DFDF
       .byte $88 ; |X   X   | $DFE0
       .byte $80 ; |X       | $DFE1
       .byte $01 ; |       X| $DFE2
       .byte $88 ; |X   X   | $DFE3
       .byte $80 ; |X       | $DFE4
       .byte $FF ; |XXXXXXXX| $DFE5
       .byte $88 ; |X   X   | $DFE6
       .byte $00 ; |        | $DFE7
       .byte $00 ; |        | $DFE8
       .byte $00 ; |        | $DFE9
       .byte $F0 ; |XXXX    | $DFEA
       .byte $FF ; |XXXXXXXX| $DFEB
       .byte $FF ; |XXXXXXXX| $DFEC
       .byte $FF ; |XXXXXXXX| $DFED
       .byte $FF ; |XXXXXXXX| $DFEE
       .byte $FF ; |XXXXXXXX| $DFEF
LDFF0: STA    BANK2                   ;4
       JMP    LD103                   ;3

       ORG $3FF6
       RORG $DFF6
       .byte $FF ; |XXXXXXXX| $DFF6
       .byte $FF ; |XXXXXXXX| $DFF7
       .byte $FF ; |XXXXXXXX| $DFF8
       .byte $00 ; |        | $DFF9
       .byte $FF ; |XXXXXXXX| $DFFA
       .byte $FF ; |XXXXXXXX| $DFFB
       .word STRT3,STRT3





























       ORG $4000
       RORG $F000

LF000: .byte $FF ; |XXXXXXXX| $F000
       .byte $FF ; |XXXXXXXX| $F001
       .byte $FF ; |XXXXXXXX| $F002
       .byte $FF ; |XXXXXXXX| $F003
       .byte $FF ; |XXXXXXXX| $F004
       .byte $FF ; |XXXXXXXX| $F005
       .byte $FF ; |XXXXXXXX| $F006
       .byte $FF ; |XXXXXXXX| $F007
       .byte $FF ; |XXXXXXXX| $F008
       .byte $FF ; |XXXXXXXX| $F009
       .byte $FF ; |XXXXXXXX| $F00A
       .byte $FF ; |XXXXXXXX| $F00B
       .byte $FF ; |XXXXXXXX| $F00C
       .byte $FF ; |XXXXXXXX| $F00D
       .byte $FF ; |XXXXXXXX| $F00E
       .byte $FF ; |XXXXXXXX| $F00F
       .byte $FF ; |XXXXXXXX| $F010
       .byte $FF ; |XXXXXXXX| $F011
LF012: .byte $FF ; |XXXXXXXX| $F012
       .byte $FF ; |XXXXXXXX| $F013
       .byte $FF ; |XXXXXXXX| $F014
       .byte $FF ; |XXXXXXXX| $F015
       .byte $FF ; |XXXXXXXX| $F016
       .byte $FF ; |XXXXXXXX| $F017
       .byte $FF ; |XXXXXXXX| $F018
LF019: .byte $FF ; |XXXXXXXX| $F019
LF01A: .byte $FF ; |XXXXXXXX| $F01A
       .byte $FF ; |XXXXXXXX| $F01B
       .byte $FF ; |XXXXXXXX| $F01C
       .byte $FF ; |XXXXXXXX| $F01D
       .byte $FF ; |XXXXXXXX| $F01E
       .byte $FF ; |XXXXXXXX| $F01F
       .byte $FF ; |XXXXXXXX| $F020
       .byte $FF ; |XXXXXXXX| $F021
       .byte $FF ; |XXXXXXXX| $F022
       .byte $FF ; |XXXXXXXX| $F023
LF024: .byte $FF ; |XXXXXXXX| $F024
       .byte $FF ; |XXXXXXXX| $F025
       .byte $FF ; |XXXXXXXX| $F026
       .byte $FF ; |XXXXXXXX| $F027
       .byte $FF ; |XXXXXXXX| $F028
       .byte $FF ; |XXXXXXXX| $F029
       .byte $FF ; |XXXXXXXX| $F02A
LF02B: .byte $FF ; |XXXXXXXX| $F02B
LF02C: .byte $FF ; |XXXXXXXX| $F02C
       .byte $FF ; |XXXXXXXX| $F02D
       .byte $FF ; |XXXXXXXX| $F02E
       .byte $FF ; |XXXXXXXX| $F02F
       .byte $FF ; |XXXXXXXX| $F030
       .byte $FF ; |XXXXXXXX| $F031
       .byte $FF ; |XXXXXXXX| $F032
       .byte $FF ; |XXXXXXXX| $F033
       .byte $FF ; |XXXXXXXX| $F034
       .byte $FF ; |XXXXXXXX| $F035
LF036: .byte $FF ; |XXXXXXXX| $F036
       .byte $FF ; |XXXXXXXX| $F037
       .byte $FF ; |XXXXXXXX| $F038
       .byte $FF ; |XXXXXXXX| $F039
       .byte $FF ; |XXXXXXXX| $F03A
       .byte $FF ; |XXXXXXXX| $F03B
       .byte $FF ; |XXXXXXXX| $F03C
       .byte $FF ; |XXXXXXXX| $F03D
       .byte $FF ; |XXXXXXXX| $F03E
       .byte $FF ; |XXXXXXXX| $F03F
       .byte $FF ; |XXXXXXXX| $F040
       .byte $FF ; |XXXXXXXX| $F041
       .byte $FF ; |XXXXXXXX| $F042
       .byte $FF ; |XXXXXXXX| $F043
       .byte $FF ; |XXXXXXXX| $F044
       .byte $FF ; |XXXXXXXX| $F045
       .byte $FF ; |XXXXXXXX| $F046
       .byte $FF ; |XXXXXXXX| $F047
LF048: .byte $FF ; |XXXXXXXX| $F048
       .byte $FF ; |XXXXXXXX| $F049
       .byte $FF ; |XXXXXXXX| $F04A
       .byte $FF ; |XXXXXXXX| $F04B
       .byte $FF ; |XXXXXXXX| $F04C
       .byte $FF ; |XXXXXXXX| $F04D
       .byte $FF ; |XXXXXXXX| $F04E
       .byte $FF ; |XXXXXXXX| $F04F
       .byte $FF ; |XXXXXXXX| $F050
       .byte $FF ; |XXXXXXXX| $F051
       .byte $FF ; |XXXXXXXX| $F052
       .byte $FF ; |XXXXXXXX| $F053
       .byte $FF ; |XXXXXXXX| $F054
       .byte $FF ; |XXXXXXXX| $F055
       .byte $FF ; |XXXXXXXX| $F056
       .byte $FF ; |XXXXXXXX| $F057
       .byte $FF ; |XXXXXXXX| $F058
       .byte $FF ; |XXXXXXXX| $F059
LF05A: .byte $FF ; |XXXXXXXX| $F05A
       .byte $FF ; |XXXXXXXX| $F05B
       .byte $FF ; |XXXXXXXX| $F05C
       .byte $FF ; |XXXXXXXX| $F05D
       .byte $FF ; |XXXXXXXX| $F05E
       .byte $FF ; |XXXXXXXX| $F05F
       .byte $FF ; |XXXXXXXX| $F060
       .byte $FF ; |XXXXXXXX| $F061
       .byte $FF ; |XXXXXXXX| $F062
       .byte $FF ; |XXXXXXXX| $F063
       .byte $FF ; |XXXXXXXX| $F064
       .byte $FF ; |XXXXXXXX| $F065
       .byte $FF ; |XXXXXXXX| $F066
       .byte $FF ; |XXXXXXXX| $F067
       .byte $FF ; |XXXXXXXX| $F068
       .byte $FF ; |XXXXXXXX| $F069
       .byte $FF ; |XXXXXXXX| $F06A
       .byte $FF ; |XXXXXXXX| $F06B
LF06C: .byte $FF ; |XXXXXXXX| $F06C
       .byte $FF ; |XXXXXXXX| $F06D
       .byte $FF ; |XXXXXXXX| $F06E
       .byte $FF ; |XXXXXXXX| $F06F
       .byte $FF ; |XXXXXXXX| $F070
       .byte $FF ; |XXXXXXXX| $F071
       .byte $FF ; |XXXXXXXX| $F072
       .byte $FF ; |XXXXXXXX| $F073
       .byte $FF ; |XXXXXXXX| $F074
       .byte $FF ; |XXXXXXXX| $F075
       .byte $FF ; |XXXXXXXX| $F076
       .byte $FF ; |XXXXXXXX| $F077
       .byte $FF ; |XXXXXXXX| $F078
       .byte $FF ; |XXXXXXXX| $F079
       .byte $FF ; |XXXXXXXX| $F07A
       .byte $FF ; |XXXXXXXX| $F07B
       .byte $FF ; |XXXXXXXX| $F07C
       .byte $FF ; |XXXXXXXX| $F07D
LF07E: .byte $FF ; |XXXXXXXX| $F07E
       .byte $FF ; |XXXXXXXX| $F07F
LF080: .byte $FF ; |XXXXXXXX| $F080
       .byte $FF ; |XXXXXXXX| $F081
       .byte $FF ; |XXXXXXXX| $F082
       .byte $FF ; |XXXXXXXX| $F083
       .byte $FF ; |XXXXXXXX| $F084
       .byte $FF ; |XXXXXXXX| $F085
       .byte $FF ; |XXXXXXXX| $F086
       .byte $FF ; |XXXXXXXX| $F087
       .byte $FF ; |XXXXXXXX| $F088
       .byte $FF ; |XXXXXXXX| $F089
       .byte $FF ; |XXXXXXXX| $F08A
       .byte $FF ; |XXXXXXXX| $F08B
       .byte $FF ; |XXXXXXXX| $F08C
       .byte $FF ; |XXXXXXXX| $F08D
       .byte $FF ; |XXXXXXXX| $F08E
       .byte $FF ; |XXXXXXXX| $F08F
       .byte $FF ; |XXXXXXXX| $F090
       .byte $FF ; |XXXXXXXX| $F091
LF092: .byte $FF ; |XXXXXXXX| $F092
       .byte $FF ; |XXXXXXXX| $F093
       .byte $FF ; |XXXXXXXX| $F094
       .byte $FF ; |XXXXXXXX| $F095
       .byte $FF ; |XXXXXXXX| $F096
       .byte $FF ; |XXXXXXXX| $F097
       .byte $FF ; |XXXXXXXX| $F098
LF099: .byte $FF ; |XXXXXXXX| $F099
LF09A: .byte $FF ; |XXXXXXXX| $F09A
       .byte $FF ; |XXXXXXXX| $F09B
       .byte $FF ; |XXXXXXXX| $F09C
       .byte $FF ; |XXXXXXXX| $F09D
       .byte $FF ; |XXXXXXXX| $F09E
       .byte $FF ; |XXXXXXXX| $F09F
       .byte $FF ; |XXXXXXXX| $F0A0
       .byte $FF ; |XXXXXXXX| $F0A1
       .byte $FF ; |XXXXXXXX| $F0A2
       .byte $FF ; |XXXXXXXX| $F0A3
LF0A4: .byte $FF ; |XXXXXXXX| $F0A4
       .byte $FF ; |XXXXXXXX| $F0A5
       .byte $FF ; |XXXXXXXX| $F0A6
       .byte $FF ; |XXXXXXXX| $F0A7
       .byte $FF ; |XXXXXXXX| $F0A8
       .byte $FF ; |XXXXXXXX| $F0A9
       .byte $FF ; |XXXXXXXX| $F0AA
LF0AB: .byte $FF ; |XXXXXXXX| $F0AB
LF0AC: .byte $FF ; |XXXXXXXX| $F0AC
       .byte $FF ; |XXXXXXXX| $F0AD
       .byte $FF ; |XXXXXXXX| $F0AE
       .byte $FF ; |XXXXXXXX| $F0AF
       .byte $FF ; |XXXXXXXX| $F0B0
       .byte $FF ; |XXXXXXXX| $F0B1
       .byte $FF ; |XXXXXXXX| $F0B2
       .byte $FF ; |XXXXXXXX| $F0B3
       .byte $FF ; |XXXXXXXX| $F0B4
       .byte $FF ; |XXXXXXXX| $F0B5
LF0B6: .byte $FF ; |XXXXXXXX| $F0B6
       .byte $FF ; |XXXXXXXX| $F0B7
       .byte $FF ; |XXXXXXXX| $F0B8
       .byte $FF ; |XXXXXXXX| $F0B9
       .byte $FF ; |XXXXXXXX| $F0BA
       .byte $FF ; |XXXXXXXX| $F0BB
       .byte $FF ; |XXXXXXXX| $F0BC
       .byte $FF ; |XXXXXXXX| $F0BD
       .byte $FF ; |XXXXXXXX| $F0BE
       .byte $FF ; |XXXXXXXX| $F0BF
       .byte $FF ; |XXXXXXXX| $F0C0
       .byte $FF ; |XXXXXXXX| $F0C1
       .byte $FF ; |XXXXXXXX| $F0C2
       .byte $FF ; |XXXXXXXX| $F0C3
       .byte $FF ; |XXXXXXXX| $F0C4
       .byte $FF ; |XXXXXXXX| $F0C5
       .byte $FF ; |XXXXXXXX| $F0C6
       .byte $FF ; |XXXXXXXX| $F0C7
LF0C8: .byte $FF ; |XXXXXXXX| $F0C8
       .byte $FF ; |XXXXXXXX| $F0C9
       .byte $FF ; |XXXXXXXX| $F0CA
       .byte $FF ; |XXXXXXXX| $F0CB
       .byte $FF ; |XXXXXXXX| $F0CC
       .byte $FF ; |XXXXXXXX| $F0CD
       .byte $FF ; |XXXXXXXX| $F0CE
       .byte $FF ; |XXXXXXXX| $F0CF
       .byte $FF ; |XXXXXXXX| $F0D0
       .byte $FF ; |XXXXXXXX| $F0D1
       .byte $FF ; |XXXXXXXX| $F0D2
       .byte $FF ; |XXXXXXXX| $F0D3
       .byte $FF ; |XXXXXXXX| $F0D4
       .byte $FF ; |XXXXXXXX| $F0D5
       .byte $FF ; |XXXXXXXX| $F0D6
       .byte $FF ; |XXXXXXXX| $F0D7
       .byte $FF ; |XXXXXXXX| $F0D8
       .byte $FF ; |XXXXXXXX| $F0D9
LF0DA: .byte $FF ; |XXXXXXXX| $F0DA
       .byte $FF ; |XXXXXXXX| $F0DB
       .byte $FF ; |XXXXXXXX| $F0DC
       .byte $FF ; |XXXXXXXX| $F0DD
       .byte $FF ; |XXXXXXXX| $F0DE
       .byte $FF ; |XXXXXXXX| $F0DF
       .byte $FF ; |XXXXXXXX| $F0E0
       .byte $FF ; |XXXXXXXX| $F0E1
       .byte $FF ; |XXXXXXXX| $F0E2
       .byte $FF ; |XXXXXXXX| $F0E3
       .byte $FF ; |XXXXXXXX| $F0E4
       .byte $FF ; |XXXXXXXX| $F0E5
       .byte $FF ; |XXXXXXXX| $F0E6
       .byte $FF ; |XXXXXXXX| $F0E7
       .byte $FF ; |XXXXXXXX| $F0E8
       .byte $FF ; |XXXXXXXX| $F0E9
       .byte $FF ; |XXXXXXXX| $F0EA
       .byte $FF ; |XXXXXXXX| $F0EB
LF0EC: .byte $FF ; |XXXXXXXX| $F0EC
       .byte $FF ; |XXXXXXXX| $F0ED
       .byte $FF ; |XXXXXXXX| $F0EE
       .byte $FF ; |XXXXXXXX| $F0EF
       .byte $FF ; |XXXXXXXX| $F0F0
       .byte $FF ; |XXXXXXXX| $F0F1
       .byte $FF ; |XXXXXXXX| $F0F2
       .byte $FF ; |XXXXXXXX| $F0F3
       .byte $FF ; |XXXXXXXX| $F0F4
       .byte $FF ; |XXXXXXXX| $F0F5
       .byte $FF ; |XXXXXXXX| $F0F6
       .byte $FF ; |XXXXXXXX| $F0F7
       .byte $FF ; |XXXXXXXX| $F0F8
       .byte $FF ; |XXXXXXXX| $F0F9
       .byte $FF ; |XXXXXXXX| $F0FA
       .byte $FF ; |XXXXXXXX| $F0FB
       .byte $FF ; |XXXXXXXX| $F0FC
       .byte $FF ; |XXXXXXXX| $F0FD
LF0FE: .byte $FF ; |XXXXXXXX| $F0FE
LF0FF: .byte $FF ; |XXXXXXXX| $F0FF

LF100: NOP                            ;2
       NOP                            ;2
       NOP                            ;2
STRT4: JMP    LF367                   ;3

LF106: .byte $1E ; |   XXXX | $F106
       .byte $3C ; |  XXXX  | $F107
       .byte $38 ; |  XXX   | $F108
       .byte $1C ; |   XXX  | $F109
       .byte $2A ; |  X X X | $F10A
       .byte $37 ; |  XX XXX| $F10B
       .byte $BA ; |X XXX X | $F10C
       .byte $FC ; |XXXXXX  | $F10D
       .byte $20 ; |  X     | $F10E
       .byte $30 ; |  XX    | $F10F
       .byte $4E ; | X  XXX | $F110
       .byte $AB ; |X X X XX| $F111
       .byte $F1 ; |XXXX   X| $F112
       .byte $B5 ; |X XX X X| $F113
       .byte $71 ; | XXX   X| $F114
       .byte $2B ; |  X X XX| $F115
       .byte $76 ; | XXX XX | $F116
       .byte $04 ; |     X  | $F117
       .byte $0E ; |    XXX | $F118
       .byte $3B ; |  XXX XX| $F119
       .byte $C0 ; |XX      | $F11A
       .byte $A4 ; |X X  X  | $F11B
       .byte $9A ; |X  XX X | $F11C
       .byte $C2 ; |XX    X | $F11D
       .byte $E6 ; |XXX  XX | $F11E
       .byte $F0 ; |XXXX    | $F11F
       .byte $F8 ; |XXXXX   | $F120
       .byte $78 ; | XXXX   | $F121
       .byte $30 ; |  XX    | $F122
       .byte $10 ; |   X    | $F123
       .byte $7C ; | XXXXX  | $F124
       .byte $EE ; |XXX XXX | $F125
       .byte $AB ; |X X X XX| $F126
       .byte $AB ; |X X X XX| $F127
       .byte $BB ; |X XXX XX| $F128
       .byte $FF ; |XXXXXXXX| $F129
       .byte $EF ; |XXX XXXX| $F12A
       .byte $DB ; |XX XX XX| $F12B
       .byte $3C ; |  XXXX  | $F12C
       .byte $41 ; | X     X| $F12D
       .byte $42 ; | X    X | $F12E
       .byte $A0 ; |X X     | $F12F
       .byte $92 ; |X  X  X | $F130
       .byte $8C ; |X   XX  | $F131
       .byte $C0 ; |XX      | $F132
       .byte $70 ; | XXX    | $F133
       .byte $F8 ; |XXXXX   | $F134
       .byte $F8 ; |XXXXX   | $F135
       .byte $F8 ; |XXXXX   | $F136
       .byte $70 ; | XXX    | $F137
       .byte $36 ; |  XX XX | $F138
       .byte $DB ; |XX XX XX| $F139
       .byte $7E ; | XXXXXX | $F13A
       .byte $FE ; |XXXXXXX | $F13B
       .byte $FF ; |XXXXXXXX| $F13C
       .byte $FE ; |XXXXXXX | $F13D
       .byte $A6 ; |X X  XX | $F13E
       .byte $AF ; |X X XXXX| $F13F
       .byte $A6 ; |X X  XX | $F140
       .byte $F0 ; |XXXX    | $F141
       .byte $AC ; |X X XX  | $F142
       .byte $4B ; | X  X XX| $F143
       .byte $DA ; |XX XX X | $F144
       .byte $FE ; |XXXXXXX | $F145
       .byte $FE ; |XXXXXXX | $F146
       .byte $7E ; | XXXXXX | $F147
       .byte $47 ; | X   XXX| $F148
       .byte $67 ; | XX  XXX| $F149
       .byte $A7 ; |X X  XXX| $F14A
       .byte $45 ; | X   X X| $F14B
       .byte $7C ; | XXXXX  | $F14C
       .byte $7C ; | XXXXX  | $F14D
       .byte $56 ; | X X XX | $F14E
       .byte $55 ; | X X X X| $F14F
       .byte $55 ; | X X X X| $F150
       .byte $F5 ; |XXXX X X| $F151
       .byte $D7 ; |XX X XXX| $F152
       .byte $FC ; |XXXXXX  | $F153
       .byte $7C ; | XXXXX  | $F154
       .byte $78 ; | XXXX   | $F155
       .byte $3C ; |  XXXX  | $F156
       .byte $7E ; | XXXXXX | $F157
       .byte $E7 ; |XXX  XXX| $F158
       .byte $E7 ; |XXX  XXX| $F159
       .byte $FF ; |XXXXXXXX| $F15A
       .byte $DB ; |XX XX XX| $F15B
       .byte $5A ; | X XX X | $F15C
       .byte $FF ; |XXXXXXXX| $F15D
       .byte $99 ; |X  XX  X| $F15E
       .byte $66 ; | XX  XX | $F15F
LF160: STA    HMCLR                   ;3
       LDA    #$FF                    ;2
       STA    $C0                     ;3
       STA    $C2                     ;3
       STA    $C4                     ;3
       STA    $C6                     ;3
       STA    $C8                     ;3
       BIT    $F8                     ;3
       BVC    LF1B4                   ;2
       STA    $BE                     ;3
       LDX    #$00                    ;2
       TXS                            ;2
       STX    GRP0                    ;3
       STY    WSYNC                   ;3
       LDX    #$01                    ;2
       LDA    #$03                    ;2
       STA    NUSIZ0                  ;3
       STA    NUSIZ1                  ;3
       NOP                            ;2
       STX    VDELP0                  ;3
       STX    VDELP1                  ;3
       NOP                            ;2
       LDA    #$F0                    ;2
       STA    $0120                   ;4
       NOP                            ;2
       NOP                            ;2
       NOP                            ;2
       LDA    #$28                    ;2
       NOP                            ;2
       STA    RESP0                   ;3
       STA    RESP1                   ;3
       LDX    LF0FF                   ;4
       BPL    LF1A0                   ;2
       LDA    $FC                     ;3
       LSR                            ;2
LF1A0: STA    COLUP0                  ;3
       STA    COLUP1                  ;3
       LDA    #$88                    ;2
       STA    WSYNC                   ;3
       STA    HMOVE                   ;3
       JMP    LF2C8                   ;3
LF1AD: .byte $00 ; |        | $F1AD
       .byte $03 ; |      XX| $F1AE
       .byte $01 ; |       X| $F1AF
LF1B0: .byte $00 ; |        | $F1B0
       .byte $00 ; |        | $F1B1
       .byte $01 ; |       X| $F1B2
       .byte $03 ; |      XX| $F1B3
LF1B4: LDA    $FF                     ;3
       AND    #$03                    ;2
       TAY                            ;2
       LDA    LF1B0,Y                 ;4
       STA    WSYNC                   ;3
       STA    $0104                   ;4
       LDA    LFD69,Y                 ;4
       STA    COLUP0                  ;3
       LDA    $FF                     ;3
       AND    #$30                    ;2
       LSR                            ;2
       LSR                            ;2
       LSR                            ;2
       STA    RESP0                   ;3
       LSR                            ;2
       TAY                            ;2
       LDA    LF1AD,Y                 ;4
       STA    NUSIZ1                  ;3
       LDA    #$F1                    ;2
       STA    $BE                     ;3
       LDX    $F6                     ;3
       CPY    #$00                    ;2
       BEQ    LF1E5                   ;2
       LDX    #$07                    ;2
       NOP                            ;2
       BNE    LF1EF                   ;2
LF1E5: BIT    $FF                     ;3
       BPL    LF1ED                   ;2
       LDX    #$06                    ;2
       BNE    LF1EF                   ;2
LF1ED: NOP                            ;2
       NOP                            ;2
LF1EF: LDY    #$09                    ;2
       STA    RESP1                   ;3
       LDA    LF357,X                 ;4
       STA    $BD                     ;3
       LDA    LF35F,X                 ;4
       STA    COLUP1                  ;3
       BNE    LF201                   ;2
LF1FF: STA    WSYNC                   ;3
LF201: LDA    LF106,Y                 ;4
       STA    GRP0                    ;3
       LDA    ($BD),Y                 ;5
       STA    GRP1                    ;3
       DEY                            ;2
       CPY    #$05                    ;2
       BNE    LF1FF                   ;2
       LDA    #$50                    ;2
       STA    $B2                     ;3
       LDX    #$0A                    ;2
LF215: STA    WSYNC                   ;3
       LDA    LF106,Y                 ;4
       STA    GRP0                    ;3
       LDA    ($BD),Y                 ;5
       STA    GRP1                    ;3
       STY    $B3                     ;3
       TYA                            ;2
       LSR                            ;2
       TAY                            ;2
       LDA.wy $F9,Y                   ;4
       AND    #$F0                    ;2
       LSR                            ;2
       BNE    LF234                   ;2
       ORA    $B2                     ;3
       STA    $BD,X                   ;4
       JMP    LF23A                   ;3
LF234: STA    $BD,X                   ;4
       LDA    #$00                    ;2
       STA    $B2                     ;3
LF23A: DEX                            ;2
       DEX                            ;2
       LDY    $B3                     ;3
       DEY                            ;2
       STA    WSYNC                   ;3
       LDA    LF106,Y                 ;4
       STA    GRP0                    ;3
       LDA    ($BD),Y                 ;5
       STA    GRP1                    ;3
       STY    $B3                     ;3
       TYA                            ;2
       LSR                            ;2
       TAY                            ;2
       LDA.wy $F9,Y                   ;4
       AND    #$0F                    ;2
       ASL                            ;2
       ASL                            ;2
       ASL                            ;2
       BNE    LF260                   ;2
       ORA    $B2                     ;3
       STA    $BD,X                   ;4
       JMP    LF266                   ;3
LF260: STA    $BD,X                   ;4
       LDA    #$00                    ;2
       STA    $B2                     ;3
LF266: DEX                            ;2
       DEX                            ;2
       LDY    $B3                     ;3
       DEY                            ;2
       BPL    LF215                   ;2
       LDX    #$00                    ;2
       STX    $BD                     ;3
       STX    GRP0                    ;3
       STA    WSYNC                   ;3
       STX    GRP1                    ;3
       STX    GRP0                    ;3
       STX    $BD                     ;3
       LDA    #$F0                    ;2
       STA    HMP0                    ;3
       STX    HMP1                    ;3
       INX                            ;2
       LDA    #$03                    ;2
       STA    NUSIZ0                  ;3
       STA    NUSIZ1                  ;3
       LDY    #$07                    ;2
       STX    VDELP0                  ;3
       STX    $0126                   ;4
       STA    RESP0                   ;3
       STA    RESP1                   ;3
       STY    $B4                     ;3
       LDA    #$FF                    ;2
       STA    $BE                     ;3
       LDY    $B4                     ;3
       LDX    #$80                    ;2
       TXS                            ;2
       LDA    #$28                    ;2
       LDX    LF0FF                   ;4
       STA    WSYNC                   ;3
       STA    HMOVE                   ;3
       BPL    LF2AC                   ;2
       LDA    $FC                     ;3
       LSR                            ;2
LF2AC: STA    COLUP0                  ;3
       STA    COLUP1                  ;3
       JMP    LF31B                   ;3
LF2B3: LDA    #$50                    ;2
       STA    $B2                     ;3
       LDA    #$00                    ;2
       STA    $BD                     ;3
       LDX    #$80                    ;2
       TXS                            ;2
       BIT    $FF                     ;3
       BVC    LF2E1                   ;2
       STA    WSYNC                   ;3
       STA    WSYNC                   ;3
       LDA    #$58                    ;2
LF2C8: STA    $C7                     ;3
       CLC                            ;2
       ADC    #$08                    ;2
       STA    $C5                     ;3
       ADC    #$08                    ;2
       STA    $C3                     ;3
       ADC    #$08                    ;2
       STA    $C1                     ;3
       ADC    #$08                    ;2
       STA    $BF                     ;3
       ADC    #$08                    ;2
       STA    $BD                     ;3
       BNE    LF31B                   ;2
LF2E1: LDY    #$02                    ;2
       LDX    #$0A                    ;2
LF2E5: LDA.wy $F9,Y                   ;4
       AND    #$F0                    ;2
       LSR                            ;2
       BNE    LF2F4                   ;2
       ORA    $B2                     ;3
       STA    $BD,X                   ;4
       JMP    LF2FA                   ;3
LF2F4: STA    $BD,X                   ;4
       LDA    #$00                    ;2
       STA    $B2                     ;3
LF2FA: DEX                            ;2
       DEX                            ;2
       TYA                            ;2
       BEQ    LF31B                   ;2
       LDA.wy $F9,Y                   ;4
       AND    #$0F                    ;2
       ASL                            ;2
       ASL                            ;2
       ASL                            ;2
       BNE    LF310                   ;2
       ORA    $B2                     ;3
       STA    $BD,X                   ;4
       JMP    LF316                   ;3
LF310: STA    $BD,X                   ;4
       LDA    #$00                    ;2
       STA    $B2                     ;3
LF316: DEX                            ;2
       DEX                            ;2
       DEY                            ;2
       BPL    LF2E5                   ;2
LF31B: LDY    #$07                    ;2
       STY    $B4                     ;3
LF31F: LDA    ($C7),Y                 ;5
       STA    GRP0                    ;3
       STA    WSYNC                   ;3
       LDA    ($C5),Y                 ;5
       STA    GRP1                    ;3
       LDA    ($C3),Y                 ;5
       STA    GRP0                    ;3
       LDA    ($C1),Y                 ;5
       STA    $B3                     ;3
       LDA    ($BF),Y                 ;5
       TAX                            ;2
       LDA    ($BD),Y                 ;5
       TAY                            ;2
       LDA    $B3                     ;3
       STA    GRP1                    ;3
       STX    GRP0                    ;3
       STY    GRP1                    ;3
       STA    GRP0                    ;3
       DEC    $B4                     ;5
       LDY    $B4                     ;3
       BPL    LF31F                   ;2
       INY                            ;2
       STY    GRP0                    ;3
       STY    GRP1                    ;3
       STY    GRP0                    ;3
       TSX                            ;2
       BMI    LF354                   ;2
       JMP    LF2B3                   ;3
LF354: JMP    LFFED                   ;3
LF357: .byte $10 ; |   X    | $F357
       .byte $1A ; |   XX X | $F358
       .byte $24 ; |  X  X  | $F359
       .byte $2E ; |  X XXX | $F35A
       .byte $38 ; |  XXX   | $F35B
       .byte $42 ; | X    X | $F35C
       .byte $4C ; | X  XX  | $F35D
       .byte $56 ; | X X XX | $F35E
LF35F: .byte $16 ; |   X XX | $F35F
       .byte $C8 ; |XX  X   | $F360
       .byte $26 ; |  X  XX | $F361
       .byte $44 ; | X   X  | $F362
       .byte $08 ; |    X   | $F363
       .byte $DA ; |XX XX X | $F364
       .byte $28 ; |  X X   | $F365
       .byte $34 ; |  XX X  | $F366
LF367: SEI                            ;2
       CLD                            ;2
       LDY    #$C0                    ;2
       LDA    #$40                    ;2
       STA    $FF                     ;3
       LDA    #$00                    ;2
       STA    $A8                     ;3
LF373: LDA    #$00                    ;2
       STA    VSYNC                   ;3
       LDX    #$FB                    ;2
LF379: CPX    #$A5                    ;2
       BEQ    LF37F                   ;2
       STA    RSYNC,X                 ;4
LF37F: DEX                            ;2
       BNE    LF379                   ;2
       LDX    #$FE                    ;2
LF384: STA    LF000,X                 ;5
       DEX                            ;2
       BNE    LF384                   ;2
       LDA    $A8                     ;3
       STA    $F6                     ;3
       STY    $F8                     ;3
       LDX    #$CF                    ;2
       TXS                            ;2
       STA    WSYNC                   ;3
       STA    RESBL                   ;3
       LDA    #$40                    ;2
       STA    HMBL                    ;3
       LDA    #$21                    ;2
       STA    CTRLPF                  ;3
       STA    WSYNC                   ;3
       STA    HMOVE                   ;3
       STA    WSYNC                   ;3
       STA    HMCLR                   ;3
       LDA    INTIM                   ;4
       STA    $FC                     ;3
LF3AC: LDX    #$11                    ;2
LF3AE: LDA    #$FF                    ;2
       STA    LF012,X                 ;5
       STA    LF024,X                 ;5
       STA    LF06C,X                 ;5
       AND    #$F0                    ;2
       STA    LF000,X                 ;5
       LDA    #$00                    ;2
       STA    LF036,X                 ;5
       STA    LF05A,X                 ;5
       STA    LF048,X                 ;5
       DEX                            ;2
       BPL    LF3AE                   ;2
       LDX    #$11                    ;2
LF3CE: LDA    LF0A4,X                 ;4
       AND    #$7F                    ;2
       STA    LF024,X                 ;5
       LDA    LF092,X                 ;4
       AND    #$7F                    ;2
       STA    LF012,X                 ;5
       DEX                            ;2
       BPL    LF3CE                   ;2
       LDY    $F6                     ;3
       LDA    LF5E9,Y                 ;4
       JSR    LF56E                   ;6
       LDA    LF5F0,Y                 ;4
       JSR    LF56E                   ;6
       LDA    LF0AC                   ;4
       AND    #$DF                    ;2
       STA    LF02C                   ;4
       LDA    LF09A                   ;4
       AND    #$DF                    ;2
       STA    LF01A                   ;4
       LDA    LF0AB                   ;4
       AND    #$D7                    ;2
       STA    LF02B                   ;4
       LDA    LF099                   ;4
       AND    #$D7                    ;2
       STA    LF019                   ;4
       LDA    #$00                    ;2
       STA    $F5                     ;3
       STA    $F4                     ;3
       LDA    $FF                     ;3
       AND    #$F7                    ;2
       STA    $FF                     ;3
LF41B: LDX    #$73                    ;2
       LDA    #$00                    ;2
LF41F: CPX    #$28                    ;2
       BEQ    LF425                   ;2
       STA    $80,X                   ;4
LF425: DEX                            ;2
       BPL    LF41F                   ;2
       SEC                            ;2
       ROR    $B6                     ;5
       JSR    LF599                   ;6
       LDX    #$11                    ;2
LF430: LDA    LF0B6,X                 ;4
       AND    #$F8                    ;2
       PHA                            ;3
       EOR    LF080,X                 ;4
       STA    LF000,X                 ;5
       LDA    LF0B6,X                 ;4
       AND    #$07                    ;2
       STA    LF036,X                 ;5
       PLA                            ;4
       JSR    LF582                   ;6
       LDA    LF0DA,X                 ;4
       PHA                            ;3
       EOR    LF0A4,X                 ;4
       STA    LF024,X                 ;5
       LDA    #$00                    ;2
       STA    LF05A,X                 ;5
       PLA                            ;4
       JSR    LF582                   ;6
       LDA    LF0C8,X                 ;4
       PHA                            ;3
       EOR    LF092,X                 ;4
       STA    LF012,X                 ;5
       LDA    #$00                    ;2
       STA    LF048,X                 ;5
       PLA                            ;4
       JSR    LF582                   ;6
       LDA    LF080,X                 ;4
       AND    #$07                    ;2
       PHA                            ;3
       TAY                            ;2
       LDA    LF0EC,X                 ;4
       EOR    LF55E,Y                 ;4
       STA    LF06C,X                 ;5
       LDA    LF080,X                 ;4
       AND    #$F8                    ;2
       STA    LF000,X                 ;5
       PLA                            ;4
       JSR    LF582                   ;6
       LDA    LF0B6,X                 ;4
       AND    #$07                    ;2
       PHA                            ;3
       TAY                            ;2
       LDA    LF0EC,X                 ;4
       EOR    LF566,Y                 ;4
       STA    LF06C,X                 ;5
       LDA    LF0B6,X                 ;4
       AND    #$F8                    ;2
       STA    LF036,X                 ;5
       PLA                            ;4
       JSR    LF582                   ;6
       DEX                            ;2
       BPL    LF430                   ;2
       LDY    $F6                     ;3
       LDA    LF57B,Y                 ;4
       CMP    $F4                     ;3
       BNE    LF4BB                   ;2
       LDA    $FF                     ;3
       AND    #$08                    ;2
       BEQ    LF4BB                   ;2
       JMP    LF73A                   ;3
LF4BB: LDA    #$00                    ;2
       STA    $B6                     ;3
       JSR    LF599                   ;6
       LDX    #$03                    ;2
LF4C4: LDA    #$50                    ;2
       STA    $E4,X                   ;4
       LDA    #$A0                    ;2
       STA    $EA,X                   ;4
       LDA    #$40                    ;2
       STA    $DD,X                   ;4
       LDA    #$13                    ;2
       STA    $D7,X                   ;4
       DEX                            ;2
       BNE    LF4C4                   ;2
       LDA    #$50                    ;2
       STA    $E4                     ;3
       LDA    #$8C                    ;2
       STA    $EA                     ;3
       LDA    #$13                    ;2
       STA    $D7                     ;3
       LDA    #$50                    ;2
       STA    $D0                     ;3
       LDA    #$4A                    ;2
       STA    $E8                     ;3
       LDA    #$B4                    ;2
       LDY    $F6                     ;3
       CPY    #$03                    ;2
       BNE    LF4F5                   ;2
       LDA    #$C8                    ;2
LF4F5: STA    $EE                     ;3
       LDA    #$0B                    ;2
       STA    $DB                     ;3
       LDA    #$10                    ;2
       STA    $D1                     ;3
       DEC    $F1                     ;5
       DEC    $F2                     ;5
       LDA    $FF                     ;3
       BPL    LF50B                   ;2
       INY                            ;2
       INY                            ;2
       BNE    LF511                   ;2
LF50B: LDX    #$00                    ;2
       CPY    $A8                     ;3
       BEQ    LF516                   ;2
LF511: LDX    LF555,Y                 ;4
       BMI    LF52A                   ;2
LF516: LDA    $FF                     ;3
       AND    #$08                    ;2
       ORA    $F4                     ;3
       BNE    LF52A                   ;2
       BIT    $F8                     ;3
       BMI    LF52A                   ;2
       STA    $F0                     ;3
       STX    $EF                     ;3
       LDA    #$01                    ;2
       BPL    LF52C                   ;2
LF52A: LDA    #$02                    ;2
LF52C: LDX    #$20                    ;2
       STA    $F3                     ;3
       STX    $D5                     ;3
       LDY    #$10                    ;2
LF534: LDA    #$02                    ;2
       STA    WSYNC                   ;3
       STA    VSYNC                   ;3
       STA    VBLANK                  ;3
       STA    WSYNC                   ;3
       STA    WSYNC                   ;3
       LDA    #$00                    ;2
       STA    WSYNC                   ;3
       STA    VSYNC                   ;3
       LDX    #$81                    ;2
LF548: STA    WSYNC                   ;3
       STA    WSYNC                   ;3
       DEX                            ;2
       BNE    LF548                   ;2
       DEY                            ;2
       BNE    LF534                   ;2
       JMP    LF5F7                   ;3
LF555: .byte $00 ; |        | $F555
       .byte $01 ; |       X| $F556
       .byte $FF ; |XXXXXXXX| $F557
       .byte $02 ; |      X | $F558
       .byte $FF ; |XXXXXXXX| $F559
       .byte $03 ; |      XX| $F55A
       .byte $FF ; |XXXXXXXX| $F55B
       .byte $03 ; |      XX| $F55C
       .byte $FF ; |XXXXXXXX| $F55D
LF55E: .byte $00 ; |        | $F55E
       .byte $04 ; |     X  | $F55F
       .byte $20 ; |  X     | $F560
       .byte $24 ; |  X  X  | $F561
       .byte $40 ; | X      | $F562
       .byte $44 ; | X   X  | $F563
       .byte $60 ; | XX     | $F564
       .byte $64 ; | XX  X  | $F565
LF566: .byte $00 ; |        | $F566
       .byte $01 ; |       X| $F567
       .byte $08 ; |    X   | $F568
       .byte $09 ; |    X  X| $F569
       .byte $10 ; |   X    | $F56A
       .byte $11 ; |   X   X| $F56B
       .byte $18 ; |   XX   | $F56C
       .byte $19 ; |   XX  X| $F56D
LF56E: .byte $38 ; |  XXX   | $F56E
       .byte $E9 ; |XXX X  X| $F56F
       .byte $12 ; |   X  X | $F570
       TAX                            ;2
       LDA    LF092,X                 ;4
       ORA    #$80                    ;2
       STA    LF012,X                 ;5
       RTS                            ;6

LF57B: .byte $52 ; | X X  X | $F57B
       .byte $42 ; | X    X | $F57C
       .byte $42 ; | X    X | $F57D
       .byte $4E ; | X  XXX | $F57E
       .byte $68 ; | XX X   | $F57F
       .byte $50 ; | X X    | $F580
       .byte $52 ; | X X  X | $F581
LF582: LDY    #$08                    ;2
LF584: LSR                            ;2
       BCC    LF595                   ;2
       INC    $F4                     ;5
       BNE    LF595                   ;2
       STA    $B2                     ;3
       LDA    $FF                     ;3
       ORA    #$08                    ;2
       STA    $FF                     ;3
       LDA    $B2                     ;3
LF595: DEY                            ;2
       BNE    LF584                   ;2
       RTS                            ;6

LF599: LDA    #$F0                    ;2
       STA    $B3                     ;3
       LDY    #$03                    ;2
LF59F: LDA    LF5E5,Y                 ;4
       STA    $B2                     ;3
       LDX    LF5E1,Y                 ;4
       STY    $B5                     ;3
       JSR    LF5C0                   ;6
       DEY                            ;2
       BPL    LF59F                   ;2
       LDX    #$09                    ;2
       LDY    $F6                     ;3
       LDA    LF5E9,Y                 ;4
       STA    $B2                     ;3
       JSR    LF5C0                   ;6
       LDA    LF5F0,Y                 ;4
       STA    $B2                     ;3
LF5C0: STY    $B5                     ;3
       LDY    #$80                    ;2
       LDA    LFFC0,X                 ;4
       AND    ($B2),Y                 ;5
       BEQ    LF5D7                   ;2
       LDY    #$B6                    ;2
       BIT    $B6                     ;3
       BMI    LF5DA                   ;2
       ORA    ($B2),Y                 ;5
LF5D3: LDY    #$36                    ;2
       STA    ($B2),Y                 ;6
LF5D7: LDY    $B5                     ;3
       RTS                            ;6

LF5DA: EOR    #$FF                    ;2
       AND    ($B2),Y                 ;5
       JMP    LF5D3                   ;3
LF5E1: .byte $02 ; |      X | $F5E1
       .byte $10 ; |   X    | $F5E2
       .byte $02 ; |      X | $F5E3
       .byte $10 ; |   X    | $F5E4
LF5E5: .byte $25 ; |  X  X X| $F5E5
       .byte $13 ; |   X  XX| $F5E6
       .byte $34 ; |  XX X  | $F5E7
       .byte $22 ; |  X   X | $F5E8
LF5E9: .byte $17 ; |   X XXX| $F5E9
       .byte $16 ; |   X XX | $F5EA
       .byte $17 ; |   X XXX| $F5EB
       .byte $17 ; |   X XXX| $F5EC
       .byte $17 ; |   X XXX| $F5ED
       .byte $17 ; |   X XXX| $F5EE
       .byte $18 ; |   XX   | $F5EF
LF5F0: .byte $1D ; |   XXX X| $F5F0
       .byte $1D ; |   XXX X| $F5F1
       .byte $1D ; |   XXX X| $F5F2
       .byte $1E ; |   XXXX | $F5F3
       .byte $1D ; |   XXX X| $F5F4
       .byte $1C ; |   XXX  | $F5F5
       .byte $1C ; |   XXX  | $F5F6
LF5F7: LDA    #$02                    ;2
       STA    WSYNC                   ;3
       STA    VSYNC                   ;3
       STA    VBLANK                  ;3
       INC    $FC                     ;5
       LDA    $FC                     ;3
       ADC    $FD                     ;3
       ADC    $FE                     ;3
       LDY    $FD                     ;3
       STY    $FE                     ;3
       STA    $FD                     ;3
       LDA    #$3B                    ;2
       STA    TIM64T                  ;4
       LDA    SWCHB                   ;4
       LSR                            ;2
       BCC    LF64E                   ;2
       LSR                            ;2
       BCC    LF624                   ;2
       LDA    $F8                     ;3
       AND    #$E0                    ;2
       STA    $F8                     ;3
       JMP    LF65B                   ;3
LF624: LDA    $F8                     ;3
       AND    #$1F                    ;2
       BEQ    LF62F                   ;2
       DEC    $F8                     ;5
       JMP    LF65B                   ;3
LF62F: LDA    $FF                     ;3
       AND    #$3C                    ;2
       SEC                            ;2
       SBC    #$10                    ;2
       AND    #$3C                    ;2
       STA    $FF                     ;3
       AND    #$30                    ;2
       BNE    LF64A                   ;2
       INC    $A8                     ;5
       LDA    $A8                     ;3
       CMP    #$07                    ;2
       BNE    LF64A                   ;2
       LDA    #$00                    ;2
       STA    $A8                     ;3
LF64A: LDY    #$9F                    ;2
       BNE    LF658                   ;2
LF64E: LDA    $FF                     ;3
       AND    #$30                    ;2
       ORA    #$02                    ;2
       STA    $FF                     ;3
       LDY    #$00                    ;2
LF658: JMP    LF373                   ;3
LF65B: BIT    $F8                     ;3
       BMI    LF661                   ;2
       BVC    LF665                   ;2
LF661: BIT    INPT4                   ;3
       BPL    LF64E                   ;2
LF665: STA    WSYNC                   ;3
       LDA    $E3                     ;3
       CMP    #$E0                    ;2
       BCS    LF67E                   ;2
       AND    #$08                    ;2
       BEQ    LF67E                   ;2
       LDA    $DC                     ;3
       AND    #$01                    ;2
       BNE    LF67C                   ;2
       INC    $E9                     ;5
       JMP    LF67E                   ;3
LF67C: INC    $EF                     ;5
LF67E: LDA    $F3                     ;3
       CMP    #$03                    ;2
       BNE    LF698                   ;2
       LDA    $D5                     ;3
       LSR                            ;2
       LSR                            ;2
       LSR                            ;2
       AND    #$07                    ;2
       TAY                            ;2
       LDA    $E1                     ;3
       AND    #$C0                    ;2
       ORA    LFFB8,Y                 ;4
       STA    $E1                     ;3
       JMP    LF6AE                   ;3
LF698: LDA    $DB                     ;3
       AND    #$03                    ;2
       TAX                            ;2
       LDA    $FC                     ;3
       AND    #$06                    ;2
       LSR                            ;2
       TAY                            ;2
       LDA    $E1                     ;3
       AND    #$C0                    ;2
       CLC                            ;2
       ADC    LF8D7,X                 ;4
       ADC    LF8D3,Y                 ;4
LF6AE: STA    $E1                     ;3
       LDY    $D6                     ;3
       STA    WSYNC                   ;3
       BMI    LF6DD                   ;2
       BEQ    LF705                   ;2
       LDA    $EE                     ;3
       SEC                            ;2
       SBC    $D0                     ;3
       TAX                            ;2
       LDA    $DB                     ;3
       PHP                            ;3
       ROL                            ;2
       ROL                            ;2
       AND    #$01                    ;2
       PLP                            ;4
       SBC    #$00                    ;2
       BNE    LF705                   ;2
       TXA                            ;2
       CMP    #$3C                    ;2
       BCS    LF705                   ;2
       LDX    $D0                     ;3
       BEQ    LF705                   ;2
       DEX                            ;2
       BEQ    LF703                   ;2
       DEY                            ;2
       BEQ    LF703                   ;2
       DEX                            ;2
       JMP    LF703                   ;3
LF6DD: LDA    $EE                     ;3
       SEC                            ;2
       SBC    $D0                     ;3
       TAX                            ;2
       LDA    $DB                     ;3
       PHP                            ;3
       ROL                            ;2
       ROL                            ;2
       AND    #$01                    ;2
       PLP                            ;4
       SBC    #$00                    ;2
       BNE    LF6F4                   ;2
       TXA                            ;2
       CMP    #$4C                    ;2
       BCC    LF705                   ;2
LF6F4: LDX    $D0                     ;3
       CPX    #$DC                    ;2
       BEQ    LF705                   ;2
       INX                            ;2
       DEY                            ;2
       BEQ    LF703                   ;2
       CPX    #$DC                    ;2
       BEQ    LF703                   ;2
       INX                            ;2
LF703: STX    $D0                     ;3
LF705: STA    WSYNC                   ;3
       LDA    #$00                    ;2
       STA    VSYNC                   ;3
       STA    $D6                     ;3
       LDX    $F3                     ;3
       BEQ    LF782                   ;2
       LDA    $D5                     ;3
       BNE    LF782                   ;2
       LDA    LF772-1,X               ;4
       STA    $B4                     ;3
       LDA    LF777,X                 ;4
       STA    $B5                     ;3
       JMP.ind ($B4)                  ;5
       LDX    #$03                    ;2
       STX    $F3                     ;3
       LDA    #$3F                    ;2
       STA    $D5                     ;3
       LDA    #$10                    ;2
       STA    $F2                     ;3
       LDA    #$00                    ;2
       STA    $E3                     ;3
       BEQ    LF782                   ;2
       LDA    #$00                    ;2
       STA    $F2                     ;3
       BEQ    LF782                   ;2
LF73A: INC    $F6                     ;5
       LDA    $F6                     ;3
       CMP    #$07                    ;2
       BNE    LF74B                   ;2
       LDA    #$03                    ;2
       STA    $F6                     ;3
       ASL    $FF                     ;5
       SEC                            ;2
       ROR    $FF                     ;5
LF74B: LDA    #$00                    ;2
       STA    $E3                     ;3
       BEQ    LF76F                   ;2
       BIT    $F8                     ;3
       BMI    LF760                   ;2
       LDA    $FF                     ;3
       AND    #$03                    ;2
       BEQ    LF760                   ;2
       DEC    $FF                     ;5
       JMP    LF41B                   ;3
LF760: LDY    #$C0                    ;2
       STY    $F8                     ;3
       LDX    $F6                     ;3
       INX                            ;2
       CPX    #$07                    ;2
       BCC    LF76D                   ;2
       LDX    #$00                    ;2
LF76D: STX    $F6                     ;3
LF76F: JMP    LF3AC                   ;3
LF772: .byte $7E ; | XXXXXX | $F772
       .byte $34 ; |  XX X  | $F773
       .byte $51 ; | X X   X| $F774
       .byte $7E ; | XXXXXX | $F775
       .byte $22 ; |  X   X | $F776
LF777: .byte $3A ; |  XXX X | $F777
       .byte $F7 ; |XXXX XXX| $F778
       .byte $F7 ; |XXXX XXX| $F779
       .byte $F7 ; |XXXX XXX| $F77A
       .byte $F7 ; |XXXX XXX| $F77B
       .byte $F7 ; |XXXX XXX| $F77C
       .byte $F7 ; |XXXX XXX| $F77D
       LDA    #$00                    ;2
       STA    $F3                     ;3
LF782: JSR    LFA2C                   ;6
       LDA    LF0FE                   ;4
       STA    $B4                     ;3
       LDA    #$00                    ;2
       STA    LF07E                   ;4
       STA    $B6                     ;3
       LDA    $F3                     ;3
       CMP    #$03                    ;2
       BEQ    LF7A1                   ;2
       CMP    #$06                    ;2
       BNE    LF7AD                   ;2
       LDA    $D5                     ;3
       CMP    #$70                    ;2
       BCS    LF7AD                   ;2
LF7A1: LDX    #$FF                    ;2
       STX    $C1                     ;3
       STX    $C2                     ;3
       INX                            ;2
       STX    $E3                     ;3
       JMP    LF85B                   ;3
LF7AD: LDA    $FF                     ;3
       AND    #$30                    ;2
       LSR                            ;2
       LSR                            ;2
       LSR                            ;2
       LSR                            ;2
       STA    $C1                     ;3
       LDX    #$03                    ;2
LF7B9: CPX    $C1                     ;3
       BCC    LF7CB                   ;2
       LDA    $D7,X                   ;4
       ROL                            ;2
       LDA    $EA,X                   ;4
       ROR                            ;2
       LSR                            ;2
       STA    $BD,X                   ;4
       JSR    LF8DF                   ;6
       BCC    LF7EB                   ;2
LF7CB: LDA    #$FF                    ;2
       STA    $BD,X                   ;4
       LDA    LF8DB,X                 ;4
       ORA    LF0FE                   ;4
       STA    LF07E                   ;4
       LDA    LF8DB,X                 ;4
       BIT    $B4                     ;3
       BNE    LF7EB                   ;2
       LDA    $DD,X                   ;4
       AND    #$C0                    ;2
       BNE    LF7EB                   ;2
       LDA    $D7,X                   ;4
       ORA    #$20                    ;2
       STA    $D7,X                   ;4
LF7EB: DEX                            ;2
       BPL    LF7B9                   ;2
       LDA    $FC                     ;3
       AND    #$03                    ;2
       ASL                            ;2
       ASL                            ;2
       STA    $B3                     ;3
       LDA    $FD                     ;3
       AND    #$03                    ;2
       ORA    $B3                     ;3
       ASL                            ;2
       ASL                            ;2
       TAY                            ;2
       LDA    LF90A,Y                 ;4
       AND    #$03                    ;2
       TAX                            ;2
       LDA    $BD,X                   ;4
       STA    $C1                     ;3
       STX    $C6                     ;3
       LDA    #$FF                    ;2
       STA    $C2                     ;3
       INY                            ;2
       LDX    LF90A,Y                 ;4
       STY    $B2                     ;3
LF815: LDY    #$00                    ;2
LF817: LDA    $BD,X                   ;4
       BMI    LF852                   ;2
       LDA.wy $C1,Y                   ;4
       BMI    LF830                   ;2
       SEC                            ;2
       SBC    $BD,X                   ;4
       BCS    LF829                   ;2
       EOR    #$FF                    ;2
       ADC    #$01                    ;2
LF829: CMP    #$09                    ;2
       BCC    LF852                   ;2
       INY                            ;2
       BNE    LF817                   ;2
LF830: STA.wy $C2,Y                   ;5
       TYA                            ;2
       STY    $B6                     ;3
       BEQ    LF84B                   ;2
LF838: LDA.wy $C0,Y                   ;4
       CMP    $BD,X                   ;4
       BCS    LF84B                   ;2
       STA.wy $C1,Y                   ;5
       LDA.wy $C5,Y                   ;4
       STA.wy $C6,Y                   ;5
       DEY                            ;2
       BNE    LF838                   ;2
LF84B: LDA    $BD,X                   ;4
       STA.wy $C1,Y                   ;5
       STX    $C6,Y                   ;4
LF852: INC    $B2                     ;5
       LDY    $B2                     ;3
       LDX    LF90A,Y                 ;4
       BPL    LF815                   ;2
LF85B: LDX    #$FF                    ;2
       STX    $BF                     ;3
       INX                            ;2
LF860: LDA    $DB,X                   ;4
       ROL                            ;2
       LDA    $EE,X                   ;4
       ROR                            ;2
       LSR                            ;2
       STA    $BD,X                   ;4
       INX                            ;2
       CPX    #$01                    ;2
       BEQ    LF860                   ;2
       LDA    $E1                     ;3
       AND    #$BF                    ;2
       STA    $E1                     ;3
       LDX    #$05                    ;2
       JSR    LF8DF                   ;6
       BCC    LF885                   ;2
       LDA    #$FF                    ;2
       STA    $BE                     ;3
       LDA    $E1                     ;3
       ORA    #$40                    ;2
       STA    $E1                     ;3
LF885: BIT    $E3                     ;3
       BMI    LF88D                   ;2
       LDA    #$FF                    ;2
       STA    $BE                     ;3
LF88D: LDA    $BD                     ;3
       SEC                            ;2
       SBC    $BE                     ;3
       BCS    LF898                   ;2
       EOR    #$FF                    ;2
       ADC    #$01                    ;2
LF898: CMP    #$09                    ;2
       BCS    LF8A5                   ;2
       LDA    $FC                     ;3
       AND    #$01                    ;2
       TAX                            ;2
       LDA    #$FF                    ;2
       STA    $BD,X                   ;4
LF8A5: LDA    $BE                     ;3
       CMP    $BD                     ;3
       ROR    $BF                     ;5
       LDA    $FC                     ;3
       AND    #$03                    ;2
       TAX                            ;2
       LDA    $FC                     ;3
       AND    #$04                    ;2
       LSR                            ;2
       LSR                            ;2
       STA    $B2                     ;3
       LDA    $DD,X                   ;4
       BMI    LF8C8                   ;2
       LDA    $D7,X                   ;4
       ASL                            ;2
       BMI    LF8CC                   ;2
       LDA    $D7,X                   ;4
       AND    #$03                    ;2
       ASL                            ;2
       BCC    LF8CE                   ;2
LF8C8: LDA    #$08                    ;2
       BNE    LF8CE                   ;2
LF8CC: LDA    #$0A                    ;2
LF8CE: ORA    $B2                     ;3
       JMP    LFFF0                   ;3
LF8D3: .byte $00 ; |        | $F8D3
       .byte $01 ; |       X| $F8D4
       .byte $02 ; |      X | $F8D5
       .byte $01 ; |       X| $F8D6
LF8D7: .byte $00 ; |        | $F8D7
       .byte $03 ; |      XX| $F8D8
       .byte $06 ; |     XX | $F8D9
       .byte $09 ; |    X  X| $F8DA
LF8DB: .byte $80 ; |X       | $F8DB
       .byte $40 ; | X      | $F8DC
       .byte $20 ; |  X     | $F8DD
       .byte $10 ; |   X    | $F8DE
LF8DF: LDA    $D7,X                   ;4
       ROL                            ;2
       ROL                            ;2
       AND    #$01                    ;2
       STA    $B3                     ;3
       LDA    $D0                     ;3
       SEC                            ;2
       SBC    $EA,X                   ;4
       STA    $B2                     ;3
       LDA    #$00                    ;2
       SBC    $B3                     ;3
       STA    $B3                     ;3
       BPL    LF902                   ;2
       CMP    #$FF                    ;2
       BNE    LF908                   ;2
       LDA    $B2                     ;3
       CMP    #$75                    ;2
       BCC    LF908                   ;2
       CLC                            ;2
LF901: RTS                            ;6

LF902: LDA    $B2                     ;3
       CMP    #$13                    ;2
       BCC    LF901                   ;2
LF908: SEC                            ;2
       RTS                            ;6

LF90A: .byte $80 ; |X       | $F90A
       .byte $01 ; |       X| $F90B
       .byte $03 ; |      XX| $F90C
       .byte $02 ; |      X | $F90D
       .byte $80 ; |X       | $F90E
       .byte $02 ; |      X | $F90F
       .byte $03 ; |      XX| $F910
       .byte $01 ; |       X| $F911
       .byte $80 ; |X       | $F912
       .byte $03 ; |      XX| $F913
       .byte $01 ; |       X| $F914
       .byte $02 ; |      X | $F915
       .byte $80 ; |X       | $F916
       .byte $03 ; |      XX| $F917
       .byte $02 ; |      X | $F918
       .byte $01 ; |       X| $F919
       .byte $81 ; |X      X| $F91A
       .byte $02 ; |      X | $F91B
       .byte $03 ; |      XX| $F91C
       .byte $00 ; |        | $F91D
       .byte $81 ; |X      X| $F91E
       .byte $02 ; |      X | $F91F
       .byte $00 ; |        | $F920
       .byte $03 ; |      XX| $F921
       .byte $81 ; |X      X| $F922
       .byte $03 ; |      XX| $F923
       .byte $00 ; |        | $F924
       .byte $02 ; |      X | $F925
       .byte $81 ; |X      X| $F926
       .byte $00 ; |        | $F927
       .byte $03 ; |      XX| $F928
       .byte $02 ; |      X | $F929
       .byte $82 ; |X     X | $F92A
       .byte $01 ; |       X| $F92B
       .byte $00 ; |        | $F92C
       .byte $03 ; |      XX| $F92D
       .byte $82 ; |X     X | $F92E
       .byte $03 ; |      XX| $F92F
       .byte $00 ; |        | $F930
       .byte $01 ; |       X| $F931
       .byte $82 ; |X     X | $F932
       .byte $00 ; |        | $F933
       .byte $01 ; |       X| $F934
       .byte $03 ; |      XX| $F935
       .byte $82 ; |X     X | $F936
       .byte $00 ; |        | $F937
       .byte $03 ; |      XX| $F938
       .byte $01 ; |       X| $F939
       .byte $83 ; |X     XX| $F93A
       .byte $00 ; |        | $F93B
       .byte $02 ; |      X | $F93C
       .byte $01 ; |       X| $F93D
       .byte $83 ; |X     XX| $F93E
       .byte $01 ; |       X| $F93F
       .byte $02 ; |      X | $F940
       .byte $00 ; |        | $F941
       .byte $83 ; |X     XX| $F942
       .byte $01 ; |       X| $F943
       .byte $00 ; |        | $F944
       .byte $02 ; |      X | $F945
       .byte $83 ; |X     XX| $F946
       .byte $02 ; |      X | $F947
       .byte $00 ; |        | $F948
       .byte $01 ; |       X| $F949
       .byte $80 ; |X       | $F94A
LF94B: .byte $79 ; | XXXX  X| $F94B
       .byte $7C ; | XXXXX  | $F94C
       .byte $B1 ; |X XX   X| $F94D
       .byte $84 ; |X    X  | $F94E
LF94F: .byte $BA ; |X XXX X | $F94F
       .byte $BD ; |X XXXX X| $F950
       .byte $BD ; |X XXXX X| $F951
       .byte $BF ; |X XXXXXX| $F952
LF953: .byte $44 ; | X   X  | $F953
       .byte $DE ; |XX XXXX | $F954
       .byte $3C ; |  XXXX  | $F955
       .byte $C1 ; |XX     X| $F956
LF957: .byte $B8 ; |X XXX   | $F957
       .byte $B5 ; |X XX X X| $F958
       .byte $BD ; |X XXXX X| $F959
       .byte $BE ; |X XXXXX | $F95A
LF95B: .byte $06 ; |     XX | $F95B
       .byte $06 ; |     XX | $F95C
       .byte $03 ; |      XX| $F95D
       .byte $05 ; |     X X| $F95E
LF95F: LDA    #$08                    ;2
       STA    AUDV0                   ;3
LF963: LDA    #$0D                    ;2
       BPL    LF9C1                   ;2
LF967: LDA    #$04                    ;2
       STA    AUDC0                   ;3
       LSR                            ;2
       BPL    LF9C6                   ;2
LF96E: LDX    $EF                     ;3
       LDA    LF94F,X                 ;4
       STA    $D5                     ;3
       STA    $AA                     ;3
       LDA    LF94B,X                 ;4
       STA    $A9                     ;3
       DEC    $F0                     ;5
       BPL    LF9FB                   ;2
       DEC    $F4                     ;5
       BPL    LF9C3                   ;2
       BIT    $E9                     ;3
       BPL    LF992                   ;2
       LDA    #$00                    ;2
       STA    $E9                     ;3
       STA    AUDV0                   ;3
       STA    $F4                     ;3
       BPL    LF9C3                   ;2
LF992: INC    $F1                     ;5
       LDY    $F1                     ;3
       JSR    LFFDE                   ;6
       CMP    #$FF                    ;2
       BEQ    LFA02                   ;2
       STA    $E9                     ;3
       STA    AUDF0                   ;3
       AND    #$60                    ;2
       ASL                            ;2
       ROL                            ;2
       ROL                            ;2
       ROL                            ;2
       STA    $F4                     ;3
       LDA    $E9                     ;3
       CMP    #$CB                    ;2
       BEQ    LF95F                   ;2
       CMP    #$9F                    ;2
       BEQ    LF967                   ;2
       CMP    #$0A                    ;2
       BEQ    LF963                   ;2
       AND    #$1F                    ;2
       BEQ    LF9BD                   ;2
       LDA    #$08                    ;2
LF9BD: STA    AUDV0                   ;3
       LDA    #$04                    ;2
LF9C1: STA    AUDC0                   ;3
LF9C3: LDA    LF95B,X                 ;4
LF9C6: STA    $F0                     ;3
       LDA    LF957,X                 ;4
       STA    $AA                     ;3
       LDA    LF953,X                 ;4
       STA    $A9                     ;3
       DEC    $F5                     ;5
       BPL    LF9FB                   ;2
       BIT    $D4                     ;3
       BMI    LFA22                   ;2
       INC    $F2                     ;5
       LDY    $F2                     ;3
       JSR    LFFDE                   ;6
       STA    $D4                     ;3
       STA    AUDF1                   ;3
       AND    #$60                    ;2
       ASL                            ;2
       ROL                            ;2
       ROL                            ;2
       ROL                            ;2
       STA    $F5                     ;3
       LDA    $D4                     ;3
       AND    #$1F                    ;2
       BEQ    LF9F5                   ;2
       LDA    #$06                    ;2
LF9F5: STA    AUDV1                   ;3
       LDA    #$0D                    ;2
       STA    AUDC1                   ;3
LF9FB: TXA                            ;2
       BEQ    LFA21                   ;2
       LDA    INPT4                   ;3
       BMI    LFA21                   ;2
LFA02: LDX    #$00                    ;2
       STX    AUDV0                   ;3
       STX    AUDV1                   ;3
       STX    $D5                     ;3
       STX    $D4                     ;3
       STX    $F4                     ;3
       STX    $F5                     ;3
       STX    $F0                     ;3
       STX    $F2                     ;3
       DEX                            ;2
       STX    $F1                     ;3
       LDA    $F8                     ;3
       BPL    LFA21                   ;2
       ORA    #$40                    ;2
       STA    $F8                     ;3
       STX    $F2                     ;3
LFA21: RTS                            ;6

LFA22: LDA    #$00                    ;2
       STA    $D4                     ;3
       STA    $F5                     ;3
       STA    AUDV1                   ;3
       BEQ    LF9FB                   ;2
LFA2C: LDX    $F3                     ;3
       DEX                            ;2
       BNE    LFA34                   ;2
       JMP    LF96E                   ;3
LFA34: LDA    $F8                     ;3
       BPL    LFA40                   ;2
       LDA    #$00                    ;2
       STA    AUDV0                   ;3
       STA    AUDV1                   ;3
       BEQ    LFA6E                   ;2
LFA40: LDX    $F1                     ;3
       CPX    #$FF                    ;2
       BEQ    LFA61                   ;2
       LDA    LFBCA,X                 ;4
       BMI    LFA5D                   ;2
       STA    AUDF0                   ;3
       LDA    LFA9C,X                 ;4
       STA    AUDC0                   ;3
       LSR                            ;2
       LSR                            ;2
       LSR                            ;2
       LSR                            ;2
       STA    AUDV0                   ;3
       INX                            ;2
       STX    $F1                     ;3
       BNE    LFA64                   ;2
LFA5D: LDX    #$FF                    ;2
       STX    $F1                     ;3
LFA61: INX                            ;2
       STX    AUDV0                   ;3
LFA64: LDA    $F3                     ;3
       CMP    #$04                    ;2
       BNE    LFA6F                   ;2
       LDA    #$00                    ;2
       STA    AUDV1                   ;3
LFA6E: RTS                            ;6

LFA6F: LDX    $F2                     ;3
       CPX    #$FF                    ;2
       BEQ    LFA98                   ;2
LFA75: LDA    LFC2F,X                 ;4
       BMI    LFA8B                   ;2
       STA    AUDF1                   ;3
       LDA    LFB00,X                 ;4
       STA    AUDC1                   ;3
       LSR                            ;2
       LSR                            ;2
       LSR                            ;2
       LSR                            ;2
       STA    AUDV1                   ;3
       INX                            ;2
       STX    $F2                     ;3
       RTS                            ;6

LFA8B: CMP    #$FF                    ;2
       BEQ    LFA94                   ;2
       AND    #$7F                    ;2
       TAX                            ;2
       BPL    LFA75                   ;2
LFA94: LDX    #$FF                    ;2
       STX    $F2                     ;3
LFA98: INX                            ;2
       STX    AUDV1                   ;3
       RTS                            ;6

LFA9C: .byte $F2 ; |XXXX  X | $FA9C
       .byte $F2 ; |XXXX  X | $FA9D
       .byte $F2 ; |XXXX  X | $FA9E
       .byte $FF ; |XXXXXXXX| $FA9F
       .byte $9D ; |X  XXX X| $FAA0
       .byte $9D ; |X  XXX X| $FAA1
       .byte $9D ; |X  XXX X| $FAA2
       .byte $FF ; |XXXXXXXX| $FAA3
       .byte $9D ; |X  XXX X| $FAA4
       .byte $9D ; |X  XXX X| $FAA5
       .byte $9D ; |X  XXX X| $FAA6
       .byte $9D ; |X  XXX X| $FAA7
       .byte $9D ; |X  XXX X| $FAA8
       .byte $FF ; |XXXXXXXX| $FAA9
       .byte $A4 ; |X X  X  | $FAAA
       .byte $A4 ; |X X  X  | $FAAB
       .byte $A4 ; |X X  X  | $FAAC
       .byte $A4 ; |X X  X  | $FAAD
       .byte $A4 ; |X X  X  | $FAAE
       .byte $A4 ; |X X  X  | $FAAF
       .byte $AD ; |X X XX X| $FAB0
       .byte $AD ; |X X XX X| $FAB1
       .byte $AD ; |X X XX X| $FAB2
       .byte $AD ; |X X XX X| $FAB3
       .byte $AD ; |X X XX X| $FAB4
       .byte $A4 ; |X X  X  | $FAB5
       .byte $A4 ; |X X  X  | $FAB6
       .byte $A4 ; |X X  X  | $FAB7
       .byte $A4 ; |X X  X  | $FAB8
       .byte $A4 ; |X X  X  | $FAB9
       .byte $FF ; |XXXXXXXX| $FABA
       .byte $AD ; |X X XX X| $FABB
       .byte $AD ; |X X XX X| $FABC
       .byte $AD ; |X X XX X| $FABD
       .byte $AD ; |X X XX X| $FABE
       .byte $AD ; |X X XX X| $FABF
       .byte $AD ; |X X XX X| $FAC0
       .byte $0D ; |    XX X| $FAC1
       .byte $AD ; |X X XX X| $FAC2
       .byte $AD ; |X X XX X| $FAC3
       .byte $AD ; |X X XX X| $FAC4
       .byte $AD ; |X X XX X| $FAC5
       .byte $AD ; |X X XX X| $FAC6
       .byte $AD ; |X X XX X| $FAC7
       .byte $0D ; |    XX X| $FAC8
       .byte $AD ; |X X XX X| $FAC9
       .byte $AD ; |X X XX X| $FACA
       .byte $AD ; |X X XX X| $FACB
       .byte $AD ; |X X XX X| $FACC
       .byte $AD ; |X X XX X| $FACD
       .byte $A4 ; |X X  X  | $FACE
       .byte $FF ; |XXXXXXXX| $FACF
       .byte $F4 ; |XXXX X  | $FAD0
       .byte $F4 ; |XXXX X  | $FAD1
       .byte $F4 ; |XXXX X  | $FAD2
       .byte $F4 ; |XXXX X  | $FAD3
       .byte $F4 ; |XXXX X  | $FAD4
       .byte $F4 ; |XXXX X  | $FAD5
       .byte $04 ; |     X  | $FAD6
       .byte $04 ; |     X  | $FAD7
       .byte $04 ; |     X  | $FAD8
       .byte $04 ; |     X  | $FAD9
       .byte $04 ; |     X  | $FADA
       .byte $04 ; |     X  | $FADB
       .byte $F4 ; |XXXX X  | $FADC
       .byte $F4 ; |XXXX X  | $FADD
       .byte $F4 ; |XXXX X  | $FADE
       .byte $F4 ; |XXXX X  | $FADF
       .byte $F4 ; |XXXX X  | $FAE0
       .byte $F4 ; |XXXX X  | $FAE1
       .byte $04 ; |     X  | $FAE2
       .byte $04 ; |     X  | $FAE3
       .byte $04 ; |     X  | $FAE4
       .byte $04 ; |     X  | $FAE5
       .byte $04 ; |     X  | $FAE6
       .byte $04 ; |     X  | $FAE7
       .byte $F4 ; |XXXX X  | $FAE8
       .byte $F4 ; |XXXX X  | $FAE9
       .byte $F4 ; |XXXX X  | $FAEA
       .byte $F4 ; |XXXX X  | $FAEB
       .byte $F4 ; |XXXX X  | $FAEC
       .byte $F4 ; |XXXX X  | $FAED
       .byte $04 ; |     X  | $FAEE
       .byte $04 ; |     X  | $FAEF
       .byte $04 ; |     X  | $FAF0
       .byte $04 ; |     X  | $FAF1
       .byte $04 ; |     X  | $FAF2
       .byte $04 ; |     X  | $FAF3
       .byte $F4 ; |XXXX X  | $FAF4
       .byte $F4 ; |XXXX X  | $FAF5
       .byte $F4 ; |XXXX X  | $FAF6
       .byte $F4 ; |XXXX X  | $FAF7
       .byte $F4 ; |XXXX X  | $FAF8
       .byte $F4 ; |XXXX X  | $FAF9
       .byte $04 ; |     X  | $FAFA
       .byte $04 ; |     X  | $FAFB
       .byte $04 ; |     X  | $FAFC
       .byte $04 ; |     X  | $FAFD
       .byte $04 ; |     X  | $FAFE
       .byte $04 ; |     X  | $FAFF
LFB00: .byte $3D ; |  XXXX X| $FB00
       .byte $34 ; |  XX X  | $FB01
       .byte $3D ; |  XXXX X| $FB02
       .byte $34 ; |  XX X  | $FB03
       .byte $3D ; |  XXXX X| $FB04
       .byte $34 ; |  XX X  | $FB05
       .byte $3D ; |  XXXX X| $FB06
       .byte $34 ; |  XX X  | $FB07
       .byte $80 ; |X       | $FB08
       .byte $34 ; |  XX X  | $FB09
       .byte $34 ; |  XX X  | $FB0A
       .byte $34 ; |  XX X  | $FB0B
       .byte $34 ; |  XX X  | $FB0C
       .byte $34 ; |  XX X  | $FB0D
       .byte $30 ; |  XX    | $FB0E
       .byte $89 ; |X   X  X| $FB0F
       .byte $94 ; |X  X X  | $FB10
       .byte $94 ; |X  X X  | $FB11
       .byte $94 ; |X  X X  | $FB12
       .byte $94 ; |X  X X  | $FB13
       .byte $94 ; |X  X X  | $FB14
       .byte $94 ; |X  X X  | $FB15
       .byte $94 ; |X  X X  | $FB16
       .byte $94 ; |X  X X  | $FB17
       .byte $94 ; |X  X X  | $FB18
       .byte $94 ; |X  X X  | $FB19
       .byte $9D ; |X  XXX X| $FB1A
       .byte $9D ; |X  XXX X| $FB1B
       .byte $9D ; |X  XXX X| $FB1C
       .byte $90 ; |X  X    | $FB1D
       .byte $94 ; |X  X X  | $FB1E
       .byte $94 ; |X  X X  | $FB1F
       .byte $94 ; |X  X X  | $FB20
       .byte $94 ; |X  X X  | $FB21
       .byte $94 ; |X  X X  | $FB22
       .byte $94 ; |X  X X  | $FB23
       .byte $94 ; |X  X X  | $FB24
       .byte $9D ; |X  XXX X| $FB25
       .byte $9D ; |X  XXX X| $FB26
       .byte $9D ; |X  XXX X| $FB27
       .byte $9D ; |X  XXX X| $FB28
       .byte $00 ; |        | $FB29
       .byte $94 ; |X  X X  | $FB2A
       .byte $94 ; |X  X X  | $FB2B
       .byte $94 ; |X  X X  | $FB2C
       .byte $94 ; |X  X X  | $FB2D
       .byte $94 ; |X  X X  | $FB2E
       .byte $94 ; |X  X X  | $FB2F
       .byte $9D ; |X  XXX X| $FB30
       .byte $9D ; |X  XXX X| $FB31
       .byte $9D ; |X  XXX X| $FB32
       .byte $00 ; |        | $FB33
       .byte $94 ; |X  X X  | $FB34
       .byte $94 ; |X  X X  | $FB35
       .byte $94 ; |X  X X  | $FB36
       .byte $94 ; |X  X X  | $FB37
       .byte $94 ; |X  X X  | $FB38
       .byte $94 ; |X  X X  | $FB39
       .byte $94 ; |X  X X  | $FB3A
       .byte $9D ; |X  XXX X| $FB3B
       .byte $9D ; |X  XXX X| $FB3C
       .byte $9D ; |X  XXX X| $FB3D
       .byte $9D ; |X  XXX X| $FB3E
       .byte $04 ; |     X  | $FB3F
       .byte $94 ; |X  X X  | $FB40
       .byte $94 ; |X  X X  | $FB41
       .byte $94 ; |X  X X  | $FB42
       .byte $9D ; |X  XXX X| $FB43
       .byte $9D ; |X  XXX X| $FB44
       .byte $9D ; |X  XXX X| $FB45
       .byte $9D ; |X  XXX X| $FB46
       .byte $0D ; |    XX X| $FB47
       .byte $FF ; |XXXXXXXX| $FB48
       .byte $A1 ; |X X    X| $FB49
       .byte $A1 ; |X X    X| $FB4A
       .byte $A1 ; |X X    X| $FB4B
       .byte $A1 ; |X X    X| $FB4C
       .byte $A1 ; |X X    X| $FB4D
       .byte $A1 ; |X X    X| $FB4E
       .byte $A1 ; |X X    X| $FB4F
       .byte $A1 ; |X X    X| $FB50
       .byte $A1 ; |X X    X| $FB51
       .byte $A1 ; |X X    X| $FB52
       .byte $A1 ; |X X    X| $FB53
       .byte $01 ; |       X| $FB54
       .byte $FF ; |XXXXXXXX| $FB55
       .byte $FF ; |XXXXXXXX| $FB56
       .byte $4D ; | X  XX X| $FB57
       .byte $44 ; | X   X  | $FB58
       .byte $44 ; | X   X  | $FB59
       .byte $44 ; | X   X  | $FB5A
       .byte $4D ; | X  XX X| $FB5B
       .byte $44 ; | X   X  | $FB5C
       .byte $4D ; | X  XX X| $FB5D
       .byte $44 ; | X   X  | $FB5E
       .byte $44 ; | X   X  | $FB5F
       .byte $44 ; | X   X  | $FB60
       .byte $4D ; | X  XX X| $FB61
       .byte $44 ; | X   X  | $FB62
       .byte $4D ; | X  XX X| $FB63
       .byte $44 ; | X   X  | $FB64
       .byte $44 ; | X   X  | $FB65
       .byte $44 ; | X   X  | $FB66
       .byte $4D ; | X  XX X| $FB67
       .byte $44 ; | X   X  | $FB68
       .byte $D7 ; |XX X XXX| $FB69
       .byte $9D ; |X  XXX X| $FB6A
       .byte $9D ; |X  XXX X| $FB6B
       .byte $9D ; |X  XXX X| $FB6C
       .byte $9D ; |X  XXX X| $FB6D
       .byte $9D ; |X  XXX X| $FB6E
       .byte $0D ; |    XX X| $FB6F
       .byte $9D ; |X  XXX X| $FB70
       .byte $9D ; |X  XXX X| $FB71
       .byte $9D ; |X  XXX X| $FB72
       .byte $9D ; |X  XXX X| $FB73
       .byte $9D ; |X  XXX X| $FB74
       .byte $0D ; |    XX X| $FB75
       .byte $9D ; |X  XXX X| $FB76
       .byte $9D ; |X  XXX X| $FB77
       .byte $9D ; |X  XXX X| $FB78
       .byte $9D ; |X  XXX X| $FB79
       .byte $9D ; |X  XXX X| $FB7A
       .byte $0D ; |    XX X| $FB7B
       .byte $9D ; |X  XXX X| $FB7C
       .byte $9D ; |X  XXX X| $FB7D
       .byte $9D ; |X  XXX X| $FB7E
       .byte $9D ; |X  XXX X| $FB7F
       .byte $9D ; |X  XXX X| $FB80
       .byte $0D ; |    XX X| $FB81
       .byte $9D ; |X  XXX X| $FB82
       .byte $9D ; |X  XXX X| $FB83
       .byte $9D ; |X  XXX X| $FB84
       .byte $9D ; |X  XXX X| $FB85
       .byte $9D ; |X  XXX X| $FB86
       .byte $0D ; |    XX X| $FB87
       .byte $9D ; |X  XXX X| $FB88
       .byte $9D ; |X  XXX X| $FB89
       .byte $9D ; |X  XXX X| $FB8A
       .byte $9D ; |X  XXX X| $FB8B
       .byte $9D ; |X  XXX X| $FB8C
       .byte $0D ; |    XX X| $FB8D
       .byte $9D ; |X  XXX X| $FB8E
       .byte $9D ; |X  XXX X| $FB8F
       .byte $9D ; |X  XXX X| $FB90
       .byte $9D ; |X  XXX X| $FB91
       .byte $9D ; |X  XXX X| $FB92
       .byte $0D ; |    XX X| $FB93
       .byte $9D ; |X  XXX X| $FB94
       .byte $9D ; |X  XXX X| $FB95
       .byte $9D ; |X  XXX X| $FB96
       .byte $9D ; |X  XXX X| $FB97
       .byte $9D ; |X  XXX X| $FB98
       .byte $0D ; |    XX X| $FB99
       .byte $9D ; |X  XXX X| $FB9A
       .byte $9D ; |X  XXX X| $FB9B
       .byte $9D ; |X  XXX X| $FB9C
       .byte $9D ; |X  XXX X| $FB9D
       .byte $9D ; |X  XXX X| $FB9E
       .byte $0D ; |    XX X| $FB9F
       .byte $94 ; |X  X X  | $FBA0
       .byte $94 ; |X  X X  | $FBA1
       .byte $94 ; |X  X X  | $FBA2
       .byte $94 ; |X  X X  | $FBA3
       .byte $94 ; |X  X X  | $FBA4
       .byte $04 ; |     X  | $FBA5
       .byte $94 ; |X  X X  | $FBA6
       .byte $94 ; |X  X X  | $FBA7
       .byte $94 ; |X  X X  | $FBA8
       .byte $94 ; |X  X X  | $FBA9
       .byte $94 ; |X  X X  | $FBAA
       .byte $0D ; |    XX X| $FBAB
       .byte $94 ; |X  X X  | $FBAC
       .byte $94 ; |X  X X  | $FBAD
       .byte $94 ; |X  X X  | $FBAE
       .byte $94 ; |X  X X  | $FBAF
       .byte $94 ; |X  X X  | $FBB0
       .byte $04 ; |     X  | $FBB1
       .byte $94 ; |X  X X  | $FBB2
       .byte $94 ; |X  X X  | $FBB3
       .byte $94 ; |X  X X  | $FBB4
       .byte $94 ; |X  X X  | $FBB5
       .byte $94 ; |X  X X  | $FBB6
       .byte $0D ; |    XX X| $FBB7
       .byte $94 ; |X  X X  | $FBB8
       .byte $94 ; |X  X X  | $FBB9
       .byte $94 ; |X  X X  | $FBBA
       .byte $94 ; |X  X X  | $FBBB
       .byte $94 ; |X  X X  | $FBBC
       .byte $04 ; |     X  | $FBBD
       .byte $94 ; |X  X X  | $FBBE
       .byte $94 ; |X  X X  | $FBBF
       .byte $94 ; |X  X X  | $FBC0
       .byte $94 ; |X  X X  | $FBC1
       .byte $94 ; |X  X X  | $FBC2
       .byte $0D ; |    XX X| $FBC3
       .byte $94 ; |X  X X  | $FBC4
       .byte $94 ; |X  X X  | $FBC5
       .byte $94 ; |X  X X  | $FBC6
       .byte $94 ; |X  X X  | $FBC7
       .byte $94 ; |X  X X  | $FBC8
       .byte $04 ; |     X  | $FBC9
LFBCA: .byte $0A ; |    X X | $FBCA
       .byte $0A ; |    X X | $FBCB
       .byte $0A ; |    X X | $FBCC
       .byte $FF ; |XXXXXXXX| $FBCD
       .byte $13 ; |   X  XX| $FBCE
       .byte $0E ; |    XXX | $FBCF
       .byte $0A ; |    X X | $FBD0
       .byte $FF ; |XXXXXXXX| $FBD1
       .byte $13 ; |   X  XX| $FBD2
       .byte $1F ; |   XXXXX| $FBD3
       .byte $13 ; |   X  XX| $FBD4
       .byte $11 ; |   X   X| $FBD5
       .byte $0C ; |    XX  | $FBD6
       .byte $FF ; |XXXXXXXX| $FBD7
       .byte $0F ; |    XXXX| $FBD8
       .byte $11 ; |   X   X| $FBD9
       .byte $13 ; |   X  XX| $FBDA
       .byte $16 ; |   X XX | $FBDB
       .byte $19 ; |   XX  X| $FBDC
       .byte $1F ; |   XXXXX| $FBDD
       .byte $0B ; |    X XX| $FBDE
       .byte $0D ; |    XX X| $FBDF
       .byte $10 ; |   X    | $FBE0
       .byte $0D ; |    XX X| $FBE1
       .byte $0B ; |    X XX| $FBE2
       .byte $1F ; |   XXXXX| $FBE3
       .byte $19 ; |   XX  X| $FBE4
       .byte $16 ; |   X XX | $FBE5
       .byte $13 ; |   X  XX| $FBE6
       .byte $11 ; |   X   X| $FBE7
       .byte $FF ; |XXXXXXXX| $FBE8
       .byte $18 ; |   XX   | $FBE9
       .byte $1F ; |   XXXXX| $FBEA
       .byte $18 ; |   XX   | $FBEB
       .byte $10 ; |   X    | $FBEC
       .byte $0E ; |    XXX | $FBED
       .byte $16 ; |   X XX | $FBEE
       .byte $00 ; |        | $FBEF
       .byte $13 ; |   X  XX| $FBF0
       .byte $10 ; |   X    | $FBF1
       .byte $0E ; |    XXX | $FBF2
       .byte $0D ; |    XX X| $FBF3
       .byte $0C ; |    XX  | $FBF4
       .byte $0B ; |    X XX| $FBF5
       .byte $00 ; |        | $FBF6
       .byte $10 ; |   X    | $FBF7
       .byte $0E ; |    XXX | $FBF8
       .byte $0D ; |    XX X| $FBF9
       .byte $0A ; |    X X | $FBFA
       .byte $09 ; |    X  X| $FBFB
       .byte $16 ; |   X XX | $FBFC
       .byte $FF ; |XXXXXXXX| $FBFD
       .byte $07 ; |     XXX| $FBFE
       .byte $07 ; |     XXX| $FBFF
       .byte $07 ; |     XXX| $FC00
       .byte $07 ; |     XXX| $FC01
       .byte $07 ; |     XXX| $FC02
       .byte $07 ; |     XXX| $FC03
       .byte $07 ; |     XXX| $FC04
       .byte $07 ; |     XXX| $FC05
       .byte $07 ; |     XXX| $FC06
       .byte $07 ; |     XXX| $FC07
       .byte $07 ; |     XXX| $FC08
       .byte $07 ; |     XXX| $FC09
       .byte $07 ; |     XXX| $FC0A
       .byte $07 ; |     XXX| $FC0B
       .byte $07 ; |     XXX| $FC0C
       .byte $07 ; |     XXX| $FC0D
       .byte $07 ; |     XXX| $FC0E
       .byte $07 ; |     XXX| $FC0F
       .byte $07 ; |     XXX| $FC10
       .byte $07 ; |     XXX| $FC11
       .byte $07 ; |     XXX| $FC12
       .byte $07 ; |     XXX| $FC13
       .byte $07 ; |     XXX| $FC14
       .byte $07 ; |     XXX| $FC15
       .byte $07 ; |     XXX| $FC16
       .byte $07 ; |     XXX| $FC17
       .byte $07 ; |     XXX| $FC18
       .byte $07 ; |     XXX| $FC19
       .byte $07 ; |     XXX| $FC1A
       .byte $07 ; |     XXX| $FC1B
       .byte $07 ; |     XXX| $FC1C
       .byte $07 ; |     XXX| $FC1D
       .byte $07 ; |     XXX| $FC1E
       .byte $07 ; |     XXX| $FC1F
       .byte $07 ; |     XXX| $FC20
       .byte $07 ; |     XXX| $FC21
       .byte $07 ; |     XXX| $FC22
       .byte $07 ; |     XXX| $FC23
       .byte $07 ; |     XXX| $FC24
       .byte $07 ; |     XXX| $FC25
       .byte $07 ; |     XXX| $FC26
       .byte $07 ; |     XXX| $FC27
       .byte $07 ; |     XXX| $FC28
       .byte $07 ; |     XXX| $FC29
       .byte $07 ; |     XXX| $FC2A
       .byte $07 ; |     XXX| $FC2B
       .byte $07 ; |     XXX| $FC2C
       .byte $07 ; |     XXX| $FC2D
       .byte $FF ; |XXXXXXXX| $FC2E
LFC2F: .byte $1A ; |   XX X | $FC2F
       .byte $16 ; |   X XX | $FC30
       .byte $16 ; |   X XX | $FC31
       .byte $14 ; |   X X  | $FC32
       .byte $13 ; |   X  XX| $FC33
       .byte $12 ; |   X  X | $FC34
       .byte $11 ; |   X   X| $FC35
       .byte $10 ; |   X    | $FC36
       .byte $80 ; |X       | $FC37
       .byte $0D ; |    XX X| $FC38
       .byte $0C ; |    XX  | $FC39
       .byte $0B ; |    X XX| $FC3A
       .byte $0A ; |    X X | $FC3B
       .byte $09 ; |    X  X| $FC3C
       .byte $00 ; |        | $FC3D
       .byte $89 ; |X   X  X| $FC3E
       .byte $0B ; |    X XX| $FC3F
       .byte $0C ; |    XX  | $FC40
       .byte $0E ; |    XXX | $FC41
       .byte $10 ; |   X    | $FC42
       .byte $10 ; |   X    | $FC43
       .byte $12 ; |   X  X | $FC44
       .byte $13 ; |   X  XX| $FC45
       .byte $17 ; |   X XXX| $FC46
       .byte $1B ; |   XX XX| $FC47
       .byte $1F ; |   XXXXX| $FC48
       .byte $0D ; |    XX X| $FC49
       .byte $12 ; |   X  X | $FC4A
       .byte $1B ; |   XX XX| $FC4B
       .byte $00 ; |        | $FC4C
       .byte $0E ; |    XXX | $FC4D
       .byte $10 ; |   X    | $FC4E
       .byte $12 ; |   X  X | $FC4F
       .byte $14 ; |   X X  | $FC50
       .byte $16 ; |   X XX | $FC51
       .byte $18 ; |   XX   | $FC52
       .byte $1D ; |   XXX X| $FC53
       .byte $0C ; |    XX  | $FC54
       .byte $0D ; |    XX X| $FC55
       .byte $12 ; |   X  X | $FC56
       .byte $1B ; |   XX XX| $FC57
       .byte $00 ; |        | $FC58
       .byte $10 ; |   X    | $FC59
       .byte $12 ; |   X  X | $FC5A
       .byte $14 ; |   X X  | $FC5B
       .byte $17 ; |   X XXX| $FC5C
       .byte $1B ; |   XX XX| $FC5D
       .byte $1F ; |   XXXXX| $FC5E
       .byte $0D ; |    XX X| $FC5F
       .byte $12 ; |   X  X | $FC60
       .byte $1B ; |   XX XX| $FC61
       .byte $00 ; |        | $FC62
       .byte $13 ; |   X  XX| $FC63
       .byte $13 ; |   X  XX| $FC64
       .byte $16 ; |   X XX | $FC65
       .byte $18 ; |   XX   | $FC66
       .byte $1B ; |   XX XX| $FC67
       .byte $1F ; |   XXXXX| $FC68
       .byte $1F ; |   XXXXX| $FC69
       .byte $0B ; |    X XX| $FC6A
       .byte $0D ; |    XX X| $FC6B
       .byte $12 ; |   X  X | $FC6C
       .byte $1B ; |   XX XX| $FC6D
       .byte $00 ; |        | $FC6E
       .byte $17 ; |   X XXX| $FC6F
       .byte $1B ; |   XX XX| $FC70
       .byte $1F ; |   XXXXX| $FC71
       .byte $0D ; |    XX X| $FC72
       .byte $12 ; |   X  X | $FC73
       .byte $15 ; |   X X X| $FC74
       .byte $1B ; |   XX XX| $FC75
       .byte $00 ; |        | $FC76
       .byte $FF ; |XXXXXXXX| $FC77
       .byte $0F ; |    XXXX| $FC78
       .byte $11 ; |   X   X| $FC79
       .byte $13 ; |   X  XX| $FC7A
       .byte $16 ; |   X XX | $FC7B
       .byte $19 ; |   XX  X| $FC7C
       .byte $1F ; |   XXXXX| $FC7D
       .byte $19 ; |   XX  X| $FC7E
       .byte $16 ; |   X XX | $FC7F
       .byte $13 ; |   X  XX| $FC80
       .byte $11 ; |   X   X| $FC81
       .byte $0F ; |    XXXX| $FC82
       .byte $00 ; |        | $FC83
       .byte $FF ; |XXXXXXXX| $FC84
       .byte $FF ; |XXXXXXXX| $FC85
       .byte $0C ; |    XX  | $FC86
       .byte $12 ; |   X  X | $FC87
       .byte $0A ; |    X X | $FC88
       .byte $1B ; |   XX XX| $FC89
       .byte $12 ; |   X  X | $FC8A
       .byte $0D ; |    XX X| $FC8B
       .byte $0D ; |    XX X| $FC8C
       .byte $13 ; |   X  XX| $FC8D
       .byte $0B ; |    X XX| $FC8E
       .byte $1C ; |   XXX  | $FC8F
       .byte $13 ; |   X  XX| $FC90
       .byte $0E ; |    XXX | $FC91
       .byte $0E ; |    XXX | $FC92
       .byte $14 ; |   X X  | $FC93
       .byte $0C ; |    XX  | $FC94
       .byte $1D ; |   XXX X| $FC95
       .byte $14 ; |   X X  | $FC96
       .byte $0F ; |    XXXX| $FC97
       .byte $D7 ; |XX X XXX| $FC98
       .byte $1F ; |   XXXXX| $FC99
       .byte $1A ; |   XX X | $FC9A
       .byte $17 ; |   X XXX| $FC9B
       .byte $16 ; |   X XX | $FC9C
       .byte $0D ; |    XX X| $FC9D
       .byte $00 ; |        | $FC9E
       .byte $1D ; |   XXX X| $FC9F
       .byte $1A ; |   XX X | $FCA0
       .byte $17 ; |   X XXX| $FCA1
       .byte $16 ; |   X XX | $FCA2
       .byte $0D ; |    XX X| $FCA3
       .byte $00 ; |        | $FCA4
       .byte $1A ; |   XX X | $FCA5
       .byte $17 ; |   X XXX| $FCA6
       .byte $15 ; |   X X X| $FCA7
       .byte $0D ; |    XX X| $FCA8
       .byte $0C ; |    XX  | $FCA9
       .byte $00 ; |        | $FCAA
       .byte $16 ; |   X XX | $FCAB
       .byte $0F ; |    XXXX| $FCAC
       .byte $0E ; |    XXX | $FCAD
       .byte $0D ; |    XX X| $FCAE
       .byte $0C ; |    XX  | $FCAF
       .byte $00 ; |        | $FCB0
       .byte $13 ; |   X  XX| $FCB1
       .byte $0E ; |    XXX | $FCB2
       .byte $0D ; |    XX X| $FCB3
       .byte $0C ; |    XX  | $FCB4
       .byte $0B ; |    X XX| $FCB5
       .byte $00 ; |        | $FCB6
       .byte $10 ; |   X    | $FCB7
       .byte $0D ; |    XX X| $FCB8
       .byte $0C ; |    XX  | $FCB9
       .byte $0B ; |    X XX| $FCBA
       .byte $0A ; |    X X | $FCBB
       .byte $00 ; |        | $FCBC
       .byte $0E ; |    XXX | $FCBD
       .byte $0C ; |    XX  | $FCBE
       .byte $0B ; |    X XX| $FCBF
       .byte $0A ; |    X X | $FCC0
       .byte $09 ; |    X  X| $FCC1
       .byte $00 ; |        | $FCC2
       .byte $0C ; |    XX  | $FCC3
       .byte $0B ; |    X XX| $FCC4
       .byte $0A ; |    X X | $FCC5
       .byte $09 ; |    X  X| $FCC6
       .byte $08 ; |    X   | $FCC7
       .byte $00 ; |        | $FCC8
       .byte $0B ; |    X XX| $FCC9
       .byte $0A ; |    X X | $FCCA
       .byte $09 ; |    X  X| $FCCB
       .byte $08 ; |    X   | $FCCC
       .byte $07 ; |     XXX| $FCCD
       .byte $00 ; |        | $FCCE
       .byte $1D ; |   XXX X| $FCCF
       .byte $1B ; |   XX XX| $FCD0
       .byte $19 ; |   XX  X| $FCD1
       .byte $17 ; |   X XXX| $FCD2
       .byte $16 ; |   X XX | $FCD3
       .byte $00 ; |        | $FCD4
       .byte $1A ; |   XX X | $FCD5
       .byte $18 ; |   XX   | $FCD6
       .byte $16 ; |   X XX | $FCD7
       .byte $14 ; |   X X  | $FCD8
       .byte $13 ; |   X  XX| $FCD9
       .byte $00 ; |        | $FCDA
       .byte $19 ; |   XX  X| $FCDB
       .byte $16 ; |   X XX | $FCDC
       .byte $14 ; |   X X  | $FCDD
       .byte $12 ; |   X  X | $FCDE
       .byte $10 ; |   X    | $FCDF
       .byte $00 ; |        | $FCE0
       .byte $17 ; |   X XXX| $FCE1
       .byte $15 ; |   X X X| $FCE2
       .byte $12 ; |   X  X | $FCE3
       .byte $10 ; |   X    | $FCE4
       .byte $0F ; |    XXXX| $FCE5
       .byte $00 ; |        | $FCE6
       .byte $15 ; |   X X X| $FCE7
       .byte $12 ; |   X  X | $FCE8
       .byte $10 ; |   X    | $FCE9
       .byte $0F ; |    XXXX| $FCEA
       .byte $0E ; |    XXX | $FCEB
       .byte $00 ; |        | $FCEC
       .byte $13 ; |   X  XX| $FCED
       .byte $10 ; |   X    | $FCEE
       .byte $0F ; |    XXXX| $FCEF
       .byte $0E ; |    XXX | $FCF0
       .byte $0D ; |    XX X| $FCF1
       .byte $00 ; |        | $FCF2
       .byte $10 ; |   X    | $FCF3
       .byte $0F ; |    XXXX| $FCF4
       .byte $0E ; |    XXX | $FCF5
       .byte $0D ; |    XX X| $FCF6
       .byte $0C ; |    XX  | $FCF7
       .byte $00 ; |        | $FCF8
       .byte $89 ; |X   X  X| $FCF9
LFCFA: STA    $C0                     ;3
       LDA    $BE                     ;3
       CMP    #$06                    ;2
       PHP                            ;3
       BCC    LFD09                   ;2
       TAY                            ;2
       LDA    LFD46,Y                 ;4
       STA    $BE                     ;3
LFD09: LDY    $F6                     ;3
       LDA    LFD62,Y                 ;4
       STA    $BF                     ;3
       LDA    LFFD3,Y                 ;4
       LDY    $C0                     ;3
       STA    $C0                     ;3
       LDA    $BE                     ;3
       LSR                            ;2
       PHP                            ;3
       CLC                            ;2
       ADC    LFD50,Y                 ;4
       TAY                            ;2
       LDA    ($BF),Y                 ;5
       PLP                            ;4
       BCS    LFD2E                   ;2
       LSR                            ;2
       LSR                            ;2
       LSR                            ;2
       LSR                            ;2
       PLP                            ;4
       BCS    LFD35                   ;2
       BCC    LFD39                   ;2
LFD2E: AND    #$0F                    ;2
       PLP                            ;4
       BCS    LFD35                   ;2
       BCC    LFD39                   ;2
LFD35: TAY                            ;2
       LDA    LFD3C,Y                 ;4
LFD39: JMP    LFFE7                   ;3
LFD3C: .byte $00 ; |        | $FD3C
       .byte $01 ; |       X| $FD3D
       .byte $08 ; |    X   | $FD3E
       .byte $09 ; |    X  X| $FD3F
       .byte $04 ; |     X  | $FD40
       .byte $05 ; |     X X| $FD41
       .byte $0C ; |    XX  | $FD42
       .byte $0D ; |    XX X| $FD43
       .byte $02 ; |      X | $FD44
       .byte $03 ; |      XX| $FD45
LFD46: .byte $0A ; |    X X | $FD46
       .byte $0B ; |    X XX| $FD47
       .byte $06 ; |     XX | $FD48
       .byte $07 ; |     XXX| $FD49
       .byte $0E ; |    XXX | $FD4A
       .byte $0F ; |    XXXX| $FD4B
       .byte $04 ; |     X  | $FD4C
       .byte $03 ; |      XX| $FD4D
       .byte $02 ; |      X | $FD4E
       .byte $01 ; |       X| $FD4F
LFD50: .byte $00 ; |        | $FD50
       .byte $03 ; |      XX| $FD51
       .byte $06 ; |     XX | $FD52
       .byte $09 ; |    X  X| $FD53
       .byte $0C ; |    XX  | $FD54
       .byte $0F ; |    XXXX| $FD55
       .byte $12 ; |   X  X | $FD56
       .byte $15 ; |   X X X| $FD57
       .byte $18 ; |   XX   | $FD58
       .byte $1B ; |   XX XX| $FD59
       .byte $1E ; |   XXXX | $FD5A
       .byte $21 ; |  X    X| $FD5B
       .byte $24 ; |  X  X  | $FD5C
       .byte $27 ; |  X  XXX| $FD5D
       .byte $2A ; |  X X X | $FD5E
       .byte $2D ; |  X XX X| $FD5F
       .byte $30 ; |  XX    | $FD60
       .byte $33 ; |  XX  XX| $FD61
LFD62: .byte $80 ; |X       | $FD62
       .byte $B6 ; |X XX XX | $FD63
       .byte $EC ; |XXX XX  | $FD64
       .byte $22 ; |  X   X | $FD65
       .byte $58 ; | X XX   | $FD66
       .byte $8E ; |X   XXX | $FD67
       .byte $C4 ; |XX   X  | $FD68
LFD69: .byte $00 ; |        | $FD69
       .byte $18 ; |   XX   | $FD6A
       .byte $18 ; |   XX   | $FD6B
       .byte $18 ; |   XX   | $FD6C
       .byte $DF ; |XX XXXXX| $FD6D
       .byte $7F ; | XXXXXXX| $FD6E
       .byte $BF ; |X XXXXXX| $FD6F
       .byte $EF ; |XXX XXXX| $FD70
       .byte $FB ; |XXXXX XX| $FD71
       .byte $FE ; |XXXXXXX | $FD72
       .byte $FD ; |XXXXXX X| $FD73
       .byte $F7 ; |XXXX XXX| $FD74
       .byte $DF ; |XX XXXXX| $FD75
       .byte $7F ; | XXXXXXX| $FD76
       .byte $DF ; |XX XXXXX| $FD77
       .byte $F7 ; |XXXX XXX| $FD78
       .byte $FD ; |XXXXXX X| $FD79
       .byte $FE ; |XXXXXXX | $FD7A
       .byte $FB ; |XXXXX XX| $FD7B
       .byte $EF ; |XXX XXXX| $FD7C
       .byte $BF ; |X XXXXXX| $FD7D
       .byte $BF ; |X XXXXXX| $FD7E
       .byte $EF ; |XXX XXXX| $FD7F
       .byte $06 ; |     XX | $FD80
       .byte $EA ; |XXX X X | $FD81
       .byte $C0 ; |XX      | $FD82
       .byte $69 ; | XX X  X| $FD83
       .byte $7C ; | XXXXX  | $FD84
       .byte $50 ; | X X    | $FD85
       .byte $56 ; | X X XX | $FD86
       .byte $97 ; |X  X XXX| $FD87
       .byte $BA ; |X XXX X | $FD88
       .byte $3F ; |  XXXXXX| $FD89
       .byte $EB ; |XXX X XX| $FD8A
       .byte $AA ; |X X X X | $FD8B
       .byte $6D ; | XX XX X| $FD8C
       .byte $7E ; | XXXXXX | $FD8D
       .byte $AE ; |X X XXX | $FD8E
       .byte $53 ; | X X  XX| $FD8F
       .byte $D5 ; |XX X X X| $FD90
       .byte $6B ; | XX X XX| $FD91
       .byte $56 ; | X X XX | $FD92
       .byte $FF ; |XXXXXXXX| $FD93
       .byte $90 ; |X  X    | $FD94
       .byte $3D ; |  XXXX X| $FD95
       .byte $57 ; | X X XXX| $FD96
       .byte $AA ; |X X X X | $FD97
       .byte $69 ; | XX X  X| $FD98
       .byte $7D ; | XXXXX X| $FD99
       .byte $2A ; |  X X X | $FD9A
       .byte $7A ; | XXXX X | $FD9B
       .byte $D7 ; |XX X XXX| $FD9C
       .byte $AA ; |X X X X | $FD9D
       .byte $3C ; |  XXXX  | $FD9E
       .byte $57 ; | X X XXX| $FD9F
       .byte $C0 ; |XX      | $FDA0
       .byte $6F ; | XX XXXX| $FDA1
       .byte $F9 ; |XXXXX  X| $FDA2
       .byte $7A ; | XXXX X | $FDA3
       .byte $55 ; | X X X X| $FDA4
       .byte $7A ; | XXXX X | $FDA5
       .byte $D0 ; |XX X    | $FDA6
       .byte $79 ; | XXXX  X| $FDA7
       .byte $7C ; | XXXXX  | $FDA8
       .byte $50 ; | X X    | $FDA9
       .byte $7E ; | XXXXXX | $FDAA
       .byte $97 ; |X  X XXX| $FDAB
       .byte $BA ; |X XXX X | $FDAC
       .byte $57 ; | X X XXX| $FDAD
       .byte $EF ; |XXX XXXX| $FDAE
       .byte $AA ; |X X X X | $FDAF
       .byte $3D ; |  XXXX X| $FDB0
       .byte $57 ; | X X XXX| $FDB1
       .byte $C0 ; |XX      | $FDB2
       .byte $03 ; |      XX| $FDB3
       .byte $B9 ; |X XXX  X| $FDB4
       .byte $3A ; |  XXX X | $FDB5
       .byte $06 ; |     XX | $FDB6
       .byte $EA ; |XXX X X | $FDB7
       .byte $C0 ; |XX      | $FDB8
       .byte $6D ; | XX XX X| $FDB9
       .byte $56 ; | X X XX | $FDBA
       .byte $BE ; |X XXXXX | $FDBB
       .byte $55 ; | X X X X| $FDBC
       .byte $3D ; |  XXXX X| $FDBD
       .byte $05 ; |     X X| $FDBE
       .byte $7B ; | XXXX XX| $FDBF
       .byte $ED ; |XXX XX X| $FDC0
       .byte $05 ; |     X X| $FDC1
       .byte $7C ; | XXXXX  | $FDC2
       .byte $57 ; | X X XXX| $FDC3
       .byte $AB ; |X X X XX| $FDC4
       .byte $55 ; | X X X X| $FDC5
       .byte $53 ; | X X  XX| $FDC6
       .byte $C0 ; |XX      | $FDC7
       .byte $7D ; | XXXXX X| $FDC8
       .byte $7E ; | XXXXXX | $FDC9
       .byte $BA ; |X XXX X | $FDCA
       .byte $53 ; | X X  XX| $FDCB
       .byte $97 ; |X  X XXX| $FDCC
       .byte $AA ; |X X X X | $FDCD
       .byte $56 ; | X X XX | $FDCE
       .byte $C5 ; |XX   X X| $FDCF
       .byte $2A ; |  X X X | $FDD0
       .byte $7D ; | XXXXX X| $FDD1
       .byte $7F ; | XXXXXXX| $FDD2
       .byte $AA ; |X X X X | $FDD3
       .byte $55 ; | X X X X| $FDD4
       .byte $53 ; | X X  XX| $FDD5
       .byte $EA ; |XXX X X | $FDD6
       .byte $79 ; | XXXX  X| $FDD7
       .byte $56 ; | X X XX | $FDD8
       .byte $BA ; |X XXX X | $FDD9
       .byte $7E ; | XXXXXX | $FDDA
       .byte $97 ; |X  X XXX| $FDDB
       .byte $EA ; |XXX X X | $FDDC
       .byte $55 ; | X X X X| $FDDD
       .byte $69 ; | XX X  X| $FDDE
       .byte $7A ; | XXXX X | $FDDF
       .byte $57 ; | X X XXX| $FDE0
       .byte $96 ; |X  X XX | $FDE1
       .byte $D0 ; |XX X    | $FDE2
       .byte $79 ; | XXXX  X| $FDE3
       .byte $69 ; | XX X  X| $FDE4
       .byte $7A ; | XXXX X | $FDE5
       .byte $3E ; |  XXXXX | $FDE6
       .byte $96 ; |X  X XX | $FDE7
       .byte $D0 ; |XX X    | $FDE8
       .byte $03 ; |      XX| $FDE9
       .byte $A9 ; |X X X  X| $FDEA
       .byte $3A ; |  XXX X | $FDEB
       .byte $06 ; |     XX | $FDEC
       .byte $C6 ; |XX   XX | $FDED
       .byte $C0 ; |XX      | $FDEE
       .byte $69 ; | XX X  X| $FDEF
       .byte $7D ; | XXXXX X| $FDF0
       .byte $3E ; |  XXXXX | $FDF1
       .byte $7E ; | XXXXXX | $FDF2
       .byte $93 ; |X  X  XX| $FDF3
       .byte $EB ; |XXX X XX| $FDF4
       .byte $53 ; | X X  XX| $FDF5
       .byte $AC ; |X X XX  | $FDF6
       .byte $7A ; | XXXX X | $FDF7
       .byte $3C ; |  XXXX  | $FDF8
       .byte $6F ; | XX XXXX| $FDF9
       .byte $90 ; |X  X    | $FDFA
       .byte $6B ; | XX X XX| $FDFB
       .byte $D3 ; |XX X  XX| $FDFC
       .byte $AE ; |X X XXX | $FDFD
       .byte $3C ; |  XXXX  | $FDFE
       .byte $7C ; | XXXXX  | $FDFF
       .byte $6B ; | XX X XX| $FE00
       .byte $07 ; |     XXX| $FE01
       .byte $97 ; |X  X XXX| $FE02
       .byte $BA ; |X XXX X | $FE03
       .byte $6B ; | XX X XX| $FE04
       .byte $ED ; |XXX XX X| $FE05
       .byte $2A ; |  X X X | $FE06
       .byte $3E ; |  XXXXX | $FE07
       .byte $93 ; |X  X  XX| $FE08
       .byte $EA ; |XXX X X | $FE09
       .byte $05 ; |     X X| $FE0A
       .byte $6E ; | XX XXX | $FE0B
       .byte $D0 ; |XX X    | $FE0C
       .byte $6B ; | XX X XX| $FE0D
       .byte $F9 ; |XXXXX  X| $FE0E
       .byte $3E ; |  XXXXX | $FE0F
       .byte $3C ; |  XXXX  | $FE10
       .byte $3C ; |  XXXX  | $FE11
       .byte $6B ; | XX X XX| $FE12
       .byte $6D ; | XX XX X| $FE13
       .byte $6F ; | XX XXXX| $FE14
       .byte $90 ; |X  X    | $FE15
       .byte $53 ; | X X  XX| $FE16
       .byte $93 ; |X  X  XX| $FE17
       .byte $C0 ; |XX      | $FE18
       .byte $7A ; | XXXX X | $FE19
       .byte $EC ; |XXX XX  | $FE1A
       .byte $7A ; | XXXX X | $FE1B
       .byte $56 ; | X X XX | $FE1C
       .byte $D7 ; |XX X XXX| $FE1D
       .byte $90 ; |X  X    | $FE1E
       .byte $39 ; |  XXX  X| $FE1F
       .byte $3B ; |  XXX XX| $FE20
       .byte $AA ; |X X X X | $FE21
       .byte $6E ; | XX XXX | $FE22
       .byte $EE ; |XXX XXX | $FE23
       .byte $C0 ; |XX      | $FE24
       .byte $55 ; | X X X X| $FE25
       .byte $55 ; | X X X X| $FE26
       .byte $50 ; | X X    | $FE27
       .byte $3B ; |  XXX XX| $FE28
       .byte $FF ; |XXXXXXXX| $FE29
       .byte $BE ; |X XXXXX | $FE2A
       .byte $6A ; | XX X X | $FE2B
       .byte $95 ; |X  X X X| $FE2C
       .byte $6B ; | XX X XX| $FE2D
       .byte $7A ; | XXXX X | $FE2E
       .byte $A9 ; |X X X  X| $FE2F
       .byte $50 ; | X X    | $FE30
       .byte $56 ; | X X XX | $FE31
       .byte $AE ; |X X XXX | $FE32
       .byte $BA ; |X XXX X | $FE33
       .byte $3D ; |  XXXX X| $FE34
       .byte $6B ; | XX X XX| $FE35
       .byte $EA ; |XXX X X | $FE36
       .byte $6F ; | XX XXXX| $FE37
       .byte $D6 ; |XX X XX | $FE38
       .byte $BA ; |X XXX X | $FE39
       .byte $55 ; | X X X X| $FE3A
       .byte $55 ; | X X X X| $FE3B
       .byte $2A ; |  X X X | $FE3C
       .byte $55 ; | X X X X| $FE3D
       .byte $3F ; |  XXXXXX| $FE3E
       .byte $C0 ; |XX      | $FE3F
       .byte $7B ; | XXXX XX| $FE40
       .byte $C5 ; |XX   X X| $FE41
       .byte $7A ; | XXXX X | $FE42
       .byte $3C ; |  XXXX  | $FE43
       .byte $7F ; | XXXXXXX| $FE44
       .byte $D0 ; |XX X    | $FE45
       .byte $6F ; | XX XXXX| $FE46
       .byte $D5 ; |XX X X X| $FE47
       .byte $3E ; |  XXXXX | $FE48
       .byte $55 ; | X X X X| $FE49
       .byte $53 ; | X X  XX| $FE4A
       .byte $EB ; |XXX X XX| $FE4B
       .byte $79 ; | XXXX  X| $FE4C
       .byte $3C ; |  XXXX  | $FE4D
       .byte $50 ; | X X    | $FE4E
       .byte $7E ; | XXXXXX | $FE4F
       .byte $C7 ; |XX   XXX| $FE50
       .byte $FA ; |XXXXX X | $FE51
       .byte $55 ; | X X X X| $FE52
       .byte $55 ; | X X X X| $FE53
       .byte $50 ; | X X    | $FE54
       .byte $3B ; |  XXX XX| $FE55
       .byte $BB ; |X XXX XX| $FE56
       .byte $90 ; |X  X    | $FE57
       .byte $6A ; | XX X X | $FE58
       .byte $C6 ; |XX   XX | $FE59
       .byte $AE ; |X X XXX | $FE5A
       .byte $7E ; | XXXXXX | $FE5B
       .byte $BF ; |X XXXXXX| $FE5C
       .byte $AB ; |X X X XX| $FE5D
       .byte $7B ; | XXXX XX| $FE5E
       .byte $EB ; |XXX X XX| $FE5F
       .byte $EA ; |XXX X X | $FE60
       .byte $7A ; | XXXX X | $FE61
       .byte $FA ; |XXXXX X | $FE62
       .byte $FA ; |XXXXX X | $FE63
       .byte $7A ; | XXXX X | $FE64
       .byte $FE ; |XXXXXXX | $FE65
       .byte $BA ; |X XXX X | $FE66
       .byte $7E ; | XXXXXX | $FE67
       .byte $97 ; |X  X XXX| $FE68
       .byte $AE ; |X X XXX | $FE69
       .byte $57 ; | X X XXX| $FE6A
       .byte $AF ; |X X XXXX| $FE6B
       .byte $AB ; |X X X XX| $FE6C
       .byte $3B ; |  XXX XX| $FE6D
       .byte $C7 ; |XX   XXX| $FE6E
       .byte $AA ; |X X X X | $FE6F
       .byte $6E ; | XX XXX | $FE70
       .byte $95 ; |X  X X X| $FE71
       .byte $2A ; |  X X X | $FE72
       .byte $57 ; | X X XXX| $FE73
       .byte $EF ; |XXX XXXX| $FE74
       .byte $EA ; |XXX X X | $FE75
       .byte $7D ; | XXXXX X| $FE76
       .byte $57 ; | X X XXX| $FE77
       .byte $D0 ; |XX X    | $FE78
       .byte $57 ; | X X XXX| $FE79
       .byte $BD ; |X XXXX X| $FE7A
       .byte $7A ; | XXXX X | $FE7B
       .byte $3F ; |  XXXXXX| $FE7C
       .byte $AF ; |X X XXXX| $FE7D
       .byte $BA ; |X XXX X | $FE7E
       .byte $6B ; | XX X XX| $FE7F
       .byte $EB ; |XXX X XX| $FE80
       .byte $EA ; |XXX X X | $FE81
       .byte $56 ; | X X XX | $FE82
       .byte $BE ; |X XXXXX | $FE83
       .byte $FA ; |XXXXX X | $FE84
       .byte $3F ; |  XXXXXX| $FE85
       .byte $AD ; |X X XX X| $FE86
       .byte $50 ; | X X    | $FE87
       .byte $6B ; | XX X XX| $FE88
       .byte $EB ; |XXX X XX| $FE89
       .byte $FA ; |XXXXX X | $FE8A
       .byte $3A ; |  XXX X | $FE8B
       .byte $BA ; |X XXX X | $FE8C
       .byte $90 ; |X  X    | $FE8D
       .byte $6E ; | XX XXX | $FE8E
       .byte $C6 ; |XX   XX | $FE8F
       .byte $EA ; |XXX X X | $FE90
       .byte $55 ; | X X X X| $FE91
       .byte $39 ; |  XXX  X| $FE92
       .byte $50 ; | X X    | $FE93
       .byte $7F ; | XXXXXXX| $FE94
       .byte $C6 ; |XX   XX | $FE95
       .byte $FA ; |XXXXX X | $FE96
       .byte $55 ; | X X X X| $FE97
       .byte $39 ; |  XXX  X| $FE98
       .byte $7A ; | XXXX X | $FE99
       .byte $7B ; | XXXX XX| $FE9A
       .byte $C6 ; |XX   XX | $FE9B
       .byte $90 ; |X  X    | $FE9C
       .byte $56 ; | X X XX | $FE9D
       .byte $FD ; |XXXXXX X| $FE9E
       .byte $6A ; | XX X X | $FE9F
       .byte $79 ; | XXXX  X| $FEA0
       .byte $53 ; | X X  XX| $FEA1
       .byte $D0 ; |XX X    | $FEA2
       .byte $3E ; |  XXXXX | $FEA3
       .byte $D6 ; |XX X XX | $FEA4
       .byte $BA ; |X XXX X | $FEA5
       .byte $6D ; | XX XX X| $FEA6
       .byte $3D ; |  XXXX X| $FEA7
       .byte $2A ; |  X X X | $FEA8
       .byte $57 ; | X X XXX| $FEA9
       .byte $AF ; |X X XXXX| $FEAA
       .byte $AA ; |X X X X | $FEAB
       .byte $7F ; | XXXXXXX| $FEAC
       .byte $AD ; |X X XX X| $FEAD
       .byte $6A ; | XX X X | $FEAE
       .byte $53 ; | X X  XX| $FEAF
       .byte $C3 ; |XX    XX| $FEB0
       .byte $D0 ; |XX X    | $FEB1
       .byte $56 ; | X X XX | $FEB2
       .byte $96 ; |X  X XX | $FEB3
       .byte $D0 ; |XX X    | $FEB4
       .byte $3B ; |  XXX XX| $FEB5
       .byte $ED ; |XXX XX X| $FEB6
       .byte $3A ; |  XXX X | $FEB7
       .byte $6A ; | XX X X | $FEB8
       .byte $D7 ; |XX X XXX| $FEB9
       .byte $C0 ; |XX      | $FEBA
       .byte $3C ; |  XXXX  | $FEBB
       .byte $3D ; |  XXXX X| $FEBC
       .byte $3A ; |  XXX X | $FEBD
       .byte $69 ; | XX X  X| $FEBE
       .byte $6B ; | XX X XX| $FEBF
       .byte $C0 ; |XX      | $FEC0
       .byte $3A ; |  XXX X | $FEC1
       .byte $BA ; |X XXX X | $FEC2
       .byte $BA ; |X XXX X | $FEC3
       .byte $6A ; | XX X X | $FEC4
       .byte $AC ; |X X XX  | $FEC5
       .byte $6A ; | XX X X | $FEC6
       .byte $56 ; | X X XX | $FEC7
       .byte $C7 ; |XX   XXX| $FEC8
       .byte $D0 ; |XX X    | $FEC9
       .byte $53 ; | X X  XX| $FECA
       .byte $FD ; |XXXXXX X| $FECB
       .byte $3A ; |  XXX X | $FECC
       .byte $3A ; |  XXX X | $FECD
       .byte $BF ; |X XXXXXX| $FECE
       .byte $AA ; |X X X X | $FECF
       .byte $6A ; | XX X X | $FED0
       .byte $EB ; |XXX X XX| $FED1
       .byte $EA ; |XXX X X | $FED2
       .byte $7E ; | XXXXXX | $FED3
       .byte $BA ; |X XXX X | $FED4
       .byte $D0 ; |XX X    | $FED5
       .byte $55 ; | X X X X| $FED6
       .byte $6C ; | XX XX  | $FED7
       .byte $7A ; | XXXX X | $FED8
       .byte $53 ; | X X  XX| $FED9
       .byte $D7 ; |XX X XXX| $FEDA
       .byte $BA ; |X XXX X | $FEDB
       .byte $7A ; | XXXX X | $FEDC
       .byte $FD ; |XXXXXX X| $FEDD
       .byte $2A ; |  X X X | $FEDE
       .byte $56 ; | X X XX | $FEDF
       .byte $D7 ; |XX X XXX| $FEE0
       .byte $EA ; |XXX X X | $FEE1
       .byte $55 ; | X X X X| $FEE2
       .byte $39 ; |  XXX  X| $FEE3
       .byte $7A ; | XXXX X | $FEE4
       .byte $3F ; |  XXXXXX| $FEE5
       .byte $AA ; |X X X X | $FEE6
       .byte $D0 ; |XX X    | $FEE7
       .byte $6B ; | XX X XX| $FEE8
       .byte $C6 ; |XX   XX | $FEE9
       .byte $D0 ; |XX X    | $FEEA
       .byte $3A ; |  XXX X | $FEEB
       .byte $BF ; |X XXXXXX| $FEEC
       .byte $BA ; |X XXX X | $FEED
       .byte $6A ; | XX X X | $FEEE
       .byte $EF ; |XXX XXXX| $FEEF
       .byte $AA ; |X X X X | $FEF0
       .byte $56 ; | X X XX | $FEF1
       .byte $FD ; |XXXXXX X| $FEF2
       .byte $6A ; | XX X X | $FEF3
       .byte $53 ; | X X  XX| $FEF4
       .byte $95 ; |X  X X X| $FEF5
       .byte $50 ; | X X    | $FEF6
       .byte $3A ; |  XXX X | $FEF7
       .byte $AB ; |X X X XX| $FEF8
       .byte $BA ; |X XXX X | $FEF9
       .byte $FF ; |XXXXXXXX| $FEFA
       .byte $FF ; |XXXXXXXX| $FEFB
       .byte $FF ; |XXXXXXXX| $FEFC
       .byte $FF ; |XXXXXXXX| $FEFD
       .byte $FF ; |XXXXXXXX| $FEFE
       .byte $FF ; |XXXXXXXX| $FEFF
       .byte $38 ; |  XXX   | $FF00
       .byte $6C ; | XX XX  | $FF01
       .byte $C6 ; |XX   XX | $FF02
       .byte $C6 ; |XX   XX | $FF03
       .byte $C6 ; |XX   XX | $FF04
       .byte $6C ; | XX XX  | $FF05
       .byte $38 ; |  XXX   | $FF06
       .byte $00 ; |        | $FF07
       .byte $7E ; | XXXXXX | $FF08
       .byte $18 ; |   XX   | $FF09
       .byte $18 ; |   XX   | $FF0A
       .byte $18 ; |   XX   | $FF0B
       .byte $18 ; |   XX   | $FF0C
       .byte $38 ; |  XXX   | $FF0D
       .byte $18 ; |   XX   | $FF0E
       .byte $00 ; |        | $FF0F
       .byte $FE ; |XXXXXXX | $FF10
       .byte $C0 ; |XX      | $FF11
       .byte $E0 ; |XXX     | $FF12
       .byte $3C ; |  XXXX  | $FF13
       .byte $06 ; |     XX | $FF14
       .byte $C6 ; |XX   XX | $FF15
       .byte $7C ; | XXXXX  | $FF16
       .byte $00 ; |        | $FF17
       .byte $FC ; |XXXXXX  | $FF18
       .byte $06 ; |     XX | $FF19
       .byte $06 ; |     XX | $FF1A
       .byte $7C ; | XXXXX  | $FF1B
       .byte $06 ; |     XX | $FF1C
       .byte $06 ; |     XX | $FF1D
       .byte $FC ; |XXXXXX  | $FF1E
       .byte $00 ; |        | $FF1F
       .byte $0C ; |    XX  | $FF20
       .byte $0C ; |    XX  | $FF21
       .byte $0C ; |    XX  | $FF22
       .byte $FE ; |XXXXXXX | $FF23
       .byte $CC ; |XX  XX  | $FF24
       .byte $CC ; |XX  XX  | $FF25
       .byte $CC ; |XX  XX  | $FF26
       .byte $00 ; |        | $FF27
       .byte $FC ; |XXXXXX  | $FF28
       .byte $06 ; |     XX | $FF29
       .byte $06 ; |     XX | $FF2A
       .byte $FC ; |XXXXXX  | $FF2B
       .byte $C0 ; |XX      | $FF2C
       .byte $C0 ; |XX      | $FF2D
       .byte $FC ; |XXXXXX  | $FF2E
       .byte $00 ; |        | $FF2F
       .byte $7C ; | XXXXX  | $FF30
       .byte $C6 ; |XX   XX | $FF31
       .byte $C6 ; |XX   XX | $FF32
       .byte $FC ; |XXXXXX  | $FF33
       .byte $C0 ; |XX      | $FF34
       .byte $C0 ; |XX      | $FF35
       .byte $7C ; | XXXXX  | $FF36
       .byte $00 ; |        | $FF37
       .byte $30 ; |  XX    | $FF38
       .byte $30 ; |  XX    | $FF39
       .byte $18 ; |   XX   | $FF3A
       .byte $18 ; |   XX   | $FF3B
       .byte $0C ; |    XX  | $FF3C
       .byte $06 ; |     XX | $FF3D
       .byte $FE ; |XXXXXXX | $FF3E
       .byte $00 ; |        | $FF3F
       .byte $7C ; | XXXXX  | $FF40
       .byte $C6 ; |XX   XX | $FF41
       .byte $C6 ; |XX   XX | $FF42
       .byte $7C ; | XXXXX  | $FF43
       .byte $C6 ; |XX   XX | $FF44
       .byte $C6 ; |XX   XX | $FF45
       .byte $7C ; | XXXXX  | $FF46
       .byte $00 ; |        | $FF47
       .byte $7C ; | XXXXX  | $FF48
       .byte $06 ; |     XX | $FF49
       .byte $06 ; |     XX | $FF4A
       .byte $7E ; | XXXXXX | $FF4B
       .byte $C6 ; |XX   XX | $FF4C
       .byte $C6 ; |XX   XX | $FF4D
       .byte $7C ; | XXXXX  | $FF4E
       .byte $00 ; |        | $FF4F
       .byte $00 ; |        | $FF50
       .byte $00 ; |        | $FF51
       .byte $00 ; |        | $FF52
       .byte $00 ; |        | $FF53
       .byte $00 ; |        | $FF54
       .byte $00 ; |        | $FF55
       .byte $00 ; |        | $FF56
       .byte $00 ; |        | $FF57

;       .byte $7C ; | XXXXX  | $FF58
;       .byte $C6 ; |XX   XX | $FF59
;       .byte $BA ; |X XXX X | $FF5A
;       .byte $B2 ; |X XX  X | $FF5B
;       .byte $BA ; |X XXX X | $FF5C
;       .byte $C6 ; |XX   XX | $FF5D
;       .byte $7C ; | XXXXX  | $FF5E
;       .byte $00 ; |        | $FF5F
;       .byte $1D ; |   XXX X| $FF60
;       .byte $08 ; |    X   | $FF61
;       .byte $08 ; |    X   | $FF62
;       .byte $09 ; |    X  X| $FF63
;       .byte $09 ; |    X  X| $FF64
;       .byte $19 ; |   XX  X| $FF65
;       .byte $09 ; |    X  X| $FF66
;       .byte $00 ; |        | $FF67
;       .byte $88 ; |X   X   | $FF68
;       .byte $54 ; | X X X  | $FF69
;       .byte $54 ; | X X X  | $FF6A
;       .byte $C9 ; |XX  X  X| $FF6B
;       .byte $55 ; | X X X X| $FF6C
;       .byte $55 ; | X X X X| $FF6D
;       .byte $89 ; |X   X  X| $FF6E
;       .byte $00 ; |        | $FF6F
;       .byte $42 ; | X    X | $FF70
;       .byte $42 ; | X    X | $FF71
;       .byte $42 ; | X    X | $FF72
;       .byte $C3 ; |XX    XX| $FF73
;       .byte $42 ; | X    X | $FF74
;       .byte $42 ; | X    X | $FF75
;       .byte $41 ; | X     X| $FF76
;       .byte $00 ; |        | $FF77
;       .byte $9B ; |X  XX XX| $FF78
;       .byte $96 ; |X  X XX | $FF79
;       .byte $93 ; |X  X  XX| $FF7A
;       .byte $90 ; |X  X    | $FF7B
;       .byte $BB ; |X XXX XX| $FF7C
;       .byte $90 ; |X  X    | $FF7D
;       .byte $10 ; |   X    | $FF7E
;       .byte $00 ; |        | $FF7F
;       .byte $E3 ; |XXX   XX| $FF80
;       .byte $A2 ; |X X   X | $FF81
;       .byte $A2 ; |X X   X | $FF82
;       .byte $A2 ; |X X   X | $FF83
;       .byte $3A ; |  XXX X | $FF84
;       .byte $00 ; |        | $FF85
;       .byte $02 ; |      X | $FF86
;       .byte $00 ; |        | $FF87






       .byte $55 ; | X X X X| $FF58
       .byte $55 ; | X X X X| $FF59
       .byte $55 ; | X X X X| $FF5A
       .byte $59 ; | X XX  X| $FF5B
       .byte $50 ; | X X    | $FF5C
       .byte $50 ; | X X    | $FF5D
       .byte $50 ; | X X    | $FF5E
       .byte $E0 ; |XXX     | $FF5F

       .byte $08 ; |    X   | $FF60
       .byte $15 ; |   X X X| $FF61
       .byte $15 ; |   X X X| $FF62
       .byte $55 ; | X X X X| $FF63
       .byte $89 ; |X   X  X| $FF64
       .byte $03 ; |      XX| $FF65
       .byte $01 ; |       X| $FF66
       .byte $00 ; |        | $FF67

       .byte $8A ; |X   X X | $FF68
       .byte $12 ; |   X  X | $FF69
       .byte $12 ; |   X  X | $FF6A
       .byte $12 ; |   X  X | $FF6B
       .byte $12 ; |   X  X | $FF6C
       .byte $BA ; |X XXX X | $FF6D
       .byte $12 ; |   X  X | $FF6E
       .byte $00 ; |        | $FF6F

       .byte $60 ; | XX     | $FF70
       .byte $80 ; |X       | $FF71
       .byte $C0 ; |XX      | $FF72
       .byte $A0 ; |X X     | $FF73
       .byte $40 ; | X      | $FF74
       .byte $00 ; |        | $FF75
       .byte $00 ; |        | $FF76
       .byte $00 ; |        | $FF77

       .byte $A6 ; |X X  XX | $FF78
       .byte $AA ; |X X X X | $FF79
       .byte $AA ; |X X X X | $FF7A
       .byte $CA ; |XX  X X | $FF7B
       .byte $86 ; |X    XX | $FF7C
       .byte $80 ; |X       | $FF7D
       .byte $80 ; |X       | $FF7E
       .byte $00 ; |        | $FF7F

       .byte $49 ; | X  X  X| $FF80
       .byte $A9 ; |X X X  X| $FF81
       .byte $8A ; |X   X X | $FF82
       .byte $AC ; |X X XX  | $FF83
       .byte $4A ; | X  X X | $FF84
       .byte $09 ; |    X  X| $FF85
       .byte $08 ; |    X   | $FF86
       .byte $00 ; |        | $FF87






       .byte $67 ; | XX  XXX| $FF88
       .byte $F7 ; |XXXX XXX| $FF89
       .byte $F7 ; |XXXX XXX| $FF8A
       .byte $B7 ; |X XX XXX| $FF8B
       .byte $37 ; |  XX XXX| $FF8C
       .byte $36 ; |  XX XX | $FF8D
       .byte $37 ; |  XX XXX| $FF8E
       .byte $37 ; |  XX XXX| $FF8F
       .byte $D6 ; |XX X XX | $FF90
       .byte $86 ; |X    XX | $FF91
       .byte $07 ; |     XXX| $FF92
       .byte $87 ; |X    XXX| $FF93
       .byte $C6 ; |XX   XX | $FF94
       .byte $C7 ; |XX   XXX| $FF95
       .byte $C7 ; |XX   XXX| $FF96
       .byte $80 ; |X       | $FF97
       .byte $3E ; |  XXXXX | $FF98
       .byte $3E ; |  XXXXX | $FF99
       .byte $94 ; |X  X X  | $FF9A
       .byte $DC ; |XX XXX  | $FF9B
       .byte $DC ; |XX XXX  | $FF9C
       .byte $C9 ; |XX  X  X| $FF9D
       .byte $88 ; |X   X   | $FF9E
       .byte $00 ; |        | $FF9F
       .byte $71 ; | XXX   X| $FFA0
       .byte $F9 ; |XXXXX  X| $FFA1
       .byte $F1 ; |XXXX   X| $FFA2
       .byte $E5 ; |XXX  X X| $FFA3
       .byte $D1 ; |XX X   X| $FFA4
       .byte $79 ; | XXXX  X| $FFA5
       .byte $B1 ; |X XX   X| $FFA6
       .byte $40 ; | X      | $FFA7
       .byte $F7 ; |XXXX XXX| $FFA8
       .byte $F7 ; |XXXX XXX| $FFA9
       .byte $F2 ; |XXXX  X | $FFAA
       .byte $F3 ; |XXXX  XX| $FFAB
       .byte $F3 ; |XXXX  XX| $FFAC
       .byte $B1 ; |X XX   X| $FFAD
       .byte $11 ; |   X   X| $FFAE
       .byte $00 ; |        | $FFAF
       .byte $DF ; |XX XXXXX| $FFB0
       .byte $DF ; |XX XXXXX| $FFB1
       .byte $9F ; |X  XXXXX| $FFB2
       .byte $9F ; |X  XXXXX| $FFB3
       .byte $1F ; |   XXXXX| $FFB4
       .byte $1B ; |   XX XX| $FFB5
       .byte $13 ; |   X  XX| $FFB6
       .byte $00 ; |        | $FFB7
LFFB8: .byte $13 ; |   X  XX| $FFB8
       .byte $13 ; |   X  XX| $FFB9
       .byte $14 ; |   X X  | $FFBA
       .byte $15 ; |   X X X| $FFBB
       .byte $16 ; |   X XX | $FFBC
       .byte $17 ; |   X XXX| $FFBD
       .byte $18 ; |   XX   | $FFBE
       .byte $19 ; |   XX  X| $FFBF
LFFC0: .byte $20 ; |  X     | $FFC0
       .byte $80 ; |X       | $FFC1
       .byte $40 ; | X      | $FFC2
       .byte $10 ; |   X    | $FFC3
       .byte $04 ; |     X  | $FFC4
       .byte $01 ; |       X| $FFC5
       .byte $02 ; |      X | $FFC6
       .byte $08 ; |    X   | $FFC7
       .byte $20 ; |  X     | $FFC8
       .byte $80 ; |X       | $FFC9
       .byte $20 ; |  X     | $FFCA
       .byte $08 ; |    X   | $FFCB
       .byte $02 ; |      X | $FFCC
       .byte $01 ; |       X| $FFCD
       .byte $04 ; |     X  | $FFCE
       .byte $10 ; |   X    | $FFCF
       .byte $40 ; | X      | $FFD0
       .byte $40 ; | X      | $FFD1
       .byte $10 ; |   X    | $FFD2
LFFD3: .byte $FD ; |XXXXXX X| $FFD3
       .byte $FD ; |XXXXXX X| $FFD4
       .byte $FD ; |XXXXXX X| $FFD5
       .byte $FE ; |XXXXXXX | $FFD6
       .byte $FE ; |XXXXXXX | $FFD7
       .byte $FE ; |XXXXXXX | $FFD8
       .byte $FE ; |XXXXXXX | $FFD9

;unused?
       .byte $FF ; |XXXXXXXX| $FFDA
       .byte $FF ; |XXXXXXXX| $FFDB
       .byte $FF ; |XXXXXXXX| $FFDC
       RTS                            ;6

LFFDE: STA    BANK2                   ;4
       JMP    LF100                   ;3
       JMP    LF5F7                   ;3
LFFE7: STA    BANK1                   ;4
       JMP    LFCFA                   ;3
LFFED: STA    BANK1                   ;4
LFFF0: STA    BANK3                   ;4
       JMP    LF160                   ;3

       ORG $4FF6
       RORG $FFF6
BANK1: .byte $FF ; |XXXXXXXX| $FFF6
BANK2: .byte $FF ; |XXXXXXXX| $FFF7
BANK3: .byte $FF ; |XXXXXXXX| $FFF8
BANK4: .byte $00 ; |        | $FFF9
       .byte $FF ; |XXXXXXXX| $FFFA
       .byte $FF ; |XXXXXXXX| $FFFB
       .word STRT4,STRT4
