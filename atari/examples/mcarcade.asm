;Hack: Missile Command Arcade...by Kurt (Nukey Shay) Howe, 6/24/2005
;    History (in order of appearence):
;
;        "Attract mode" color shift removed
;        Various superflous code removed
;        Level 13 "Easter Egg" removed
;        Playfield missile cache removed
;        Level-specific colors removed
;        B&W support removed
;        
;        Supercharger-compatability added
;        "THE END" text added
;        3-button control added
;        2 additional sprite missile caches added
;          (AI adjusted to also target the additional caches)
;        Playfield hilltops altered (fudged)
;        Flashing "PLAYER#" text added
;        7800 autodetect added
;        NTSC/PAL palette select added
;        "Ground zero" color shading added
;        End-of-level pause feature added
;        Fire-button pause routine added
;
;    Todo:
;        Correct score counting bugfixes -done
;        Fix pause routine
;        Adjust AI to target caches better
;        Fix side cache playfield GFX (cycle timing already maxed out) -done
;        Correct sprite skew (visible in left cache when holding 7+ missiles) -done
;        Add bombers/satellites (impossible?)
;
;
;
;
; Disassembly of MissComm.bin
; Disassembled Tue Apr 26 22:21:45 2005
; Using DiStella v2.0
; Command Line: C:\BIN\DISTELLA.EXE -pafscMissComm.cfg MissComm.bin 
; MissComm.cfg contents:
;      CODE F000 F596
;      GFX F597 F5A2
;      CODE F5A3 F689
;      GFX F68A F68E
;      CODE F68F FCAD
;      GFX FCAE FCAE
;      CODE FCAF FDDE
;      GFX FDDF FFFF

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


;changed $8B,$8C to $D5,$D6...used free ram to hold additional cache counts
;removed color register ram ($E2 to $E5)...used $E2-$E4 to hold missile origin

       ORG $F000

LF003:
       LDX    #$04                    ;2
LF005:
       LDA    #$02                    ;2
       CPX    #$02                    ;2
       BCS    LF015                   ;2
       LDA    #$01                    ;2
       LDY    $A1                     ;3
       CPY    #$F0                    ;2
       BNE    LF015                   ;2
       LDA    #$FC                    ;2
LF015:
       CLC                            ;2
       ADC    $86,X                   ;4
       LDY    #$02                    ;2
       SEC                            ;2
LF01B:
       INY                            ;2
       SBC    #$0F                    ;2
       BCS    LF01B                   ;2
       EOR    #$FF                    ;2
       SBC    #$06                    ;2
       ASL                            ;2
       ASL                            ;2
       ASL                            ;2
       ASL                            ;2
       STA    WSYNC                   ;3
LF02A:
       DEY                            ;2
       BPL    LF02A                   ;2
       STA    RESP0,X                 ;4
       STA    HMP0,X                  ;4
       LDA    $A1                     ;3
       BNE    LF038                   ;2
       DEX                            ;2
       BPL    LF005                   ;2
LF038:
       STA    WSYNC                   ;3
       STA    HMOVE                   ;3
       RTS                            ;6


START:
       SEI                            ;2
       CLD                            ;2

       lda    #$00                    ;2  clear A

;detect the console type
       tay                            ;2  Console type = 2600
       ldx    $D0                     ;3  Check $D0
       cpx    #$2C                    ;2  Does it contain value $2C?
       bne    Save_Console            ;2  If not, branch (keep 2600 mode)
       ldx    $D1                     ;3  Check $D1
       cpx    #$A9                    ;2  Does it contain value $A9?
       bne    Save_Console            ;2  If not, branch (keep 2600 mode)
       ldy    #$40                    ;2  set 7800 mode
;note: I used a low bit for this ($00 or $01)...but you could
;use a higher one by just LDY # instead of INY :)
Save_Console:
;now, clear out all ram
       tax                            ;2

LF03F:
       STX    SWACNT                  ;4
LF047:
       STA    VSYNC,X                 ;4
       INX                            ;2
       BNE    LF047                   ;2
       DEX                            ;2
       TXS                            ;2

       INY                            ;2 bugfix for 7800
       STY    $E6                     ;3

       LDY    #$87                    ;2
       STY    $DB                     ;3
       LDY    #$01                    ;2
       STY    $E9                     ;3
       INY                            ;2

;Y=2, A=0
LF056:
       STY    VBLANK                  ;3
       STY    VSYNC                   ;3
       STY    WSYNC                   ;3
       LDY    #$30                    ;2
       STY    WSYNC                   ;3
       STA    VSYNC                   ;3
       STY    TIM64T                  ;4
       TAY                            ;2 A/Y=0

       LDA    SWCHB                   ;4
       tax                            ;2  copy to X (to be used later)

       eor    $E5                     ;2  check previous switches
       beq    Switch_ending           ;2³ branch if the same (branch to end)

       bit    $E6                     ;3  first, load in the console type
       bvs    AA7800                  ;2³ Branch if so

       txa                            ;2
       and    #$08                    ;2
       lsr                            ;2
       lsr                            ;2
       lsr                            ;2
       sta    $E5                     ;3
       lda    $E6                     ;3
       and    #$FE                    ;2
       ora    $E5                     ;3
       sta    $E6                     ;3
       jmp    NoPauseChange           ;3

AA7800:
       and    #$08                    ;2
       beq    NoPauseChange           ;2³ branch if no change

       txa                            ;2  get back the full array for checking other switches
       and    #$08                    ;2  keep only Color/B&W
       bne    NoPauseChange           ;2³ Branch if on color selection (skip)
PauseChange:
       lda    $E6                     ;3  load a ram location used to hold
       eor    #$01                    ;2  the Pause mode, and flip it's status
       sta    $E6                     ;3  (bit 5 of "Level" is used here)
NoPauseChange:
       stx    $E5                     ;3  ...and save the new ones
Switch_ending:

;pause routine
       LDA    $E6                     ;3
       ASL                            ;2
       ROL    INPT4                   ;3
       ROR                            ;2
       BPL    Save                    ;2 skip if not changed (+current status in A)


       BIT    $E6                     ;3
       BMI    Skip                    ;2 skip if still pressed

       EOR    #$20                    ;2 flip modes

Skip:
Save:
       STA    $E6                     ;3
       AND    #$20                    ;2

       BNE    NotPaused               ;2

       LDA    $80                     ;3
       EOR    #$01                    ;2
       STA    $80                     ;3


       JMP    Pause                   ;3






NotPaused:
       INC    $80                     ;5
       BNE    LF07F                   ;2
       INC    $E8                     ;5
       LDA    $DB                     ;3
       BPL    LF07F                   ;2
       LDA    $F8                     ;3
       BPL    LF07F                   ;2
       LDA    $F5                     ;3
       EOR    #$01                    ;2
       STA    $F5                     ;3
LF07F:
       LDA    $DC                     ;3
       BEQ    LF08A                   ;2
       DEC    $DC                     ;5
       BNE    LF08A                   ;2
LF08A:
       BIT    $DB                     ;3
       BPL    LF092                   ;2 branch if missiles dropping
;clear silos
       STY    $8B                     ;3 Y=0
       STY    $8C                     ;3
       STY    $8D                     ;3
       DEY                            ;2 Y=FF
       STY    $DE                     ;3 set mode to inactive


LF092:
       LDA    $DE                     ;3
       CMP    #$E8                    ;2
       BNE    LF0C5                   ;2
       LDA    $E0                     ;3
       BNE    LF0B8                   ;2
       LDA    #$07                    ;2
       STA    $E0                     ;3 tic timer


;bugfix (works!??!)
       LDA    $8B                     ;3
       ORA    $8C                     ;3
       ORA    $8D                     ;3
       BNE    LF0AB                   ;2
LF0AB:
       JSR    LFCAF                   ;6
       BCS    AllMissilesCounted      ;2


       LDA    #$04                    ;2
       STA    $DF                     ;3


       LDA    #$05                    ;2
       LDY    #$00                    ;2
       JSR    LFCCB                   ;6

AllMissilesCounted:
LF0B8:
       JMP    LF132                   ;3




LF0C5:
       LDA    $DE                     ;3
       CMP    #$E0                    ;2
       BNE    LF10C                   ;2

       LDA    $80                     ;3
       AND    #$0F                    ;2
       BNE    LF132                   ;2
       LDX    $E0                     ;3
LF0D3:
       CPX    #$06                    ;2
       BEQ    LF0FAA                  ;2
       LDY    LFE18,X                 ;4
       LDA.wy $A9,Y                   ;4
       BEQ    LF0E4                   ;2 branch if a city
       INX                            ;2
       BNE    LF0D3                   ;2
LF0E4:
       LDA    #<RubbleGFX             ;2 load rubble
       STA.wy $A9,Y                   ;5 save to city
       INX                            ;2
       STX    $E0                     ;3

;bugfix
;       CPX    #$05                    ;2
;       BEQ    LF132                   ;2
;       BEQ    LF140                   ;2 always branch



       LDA    #$00                    ;2
       LDY    #$01                    ;2
       JSR    LFCCB                   ;6
       LDA    #$05                    ;2
       STA    $DF                     ;3
       BNE    LF132                   ;2 always branch

;bugfix
LF0FAA:
       LDA    #<RubbleGFX             ;2 load rubble
       STA    $AF                     ;3


LF0FA:
       LDA    #$A8                    ;2
       STA    $DE                     ;3
       LDA    #$04                    ;2
       STA    $E0                     ;3
       LDA    #$01                    ;2
       STA    $DF                     ;3
       JSR    LFD96                   ;6
       JMP    LF4D6                   ;3

LF10C:
       LDA    $DF                     ;3
       CMP    #$06                    ;2
       BEQ    LF132                   ;2
       BIT    $DE                     ;3
       BPL    LF132                   ;2
       LDA    $80                     ;3
       AND    #$03                    ;2
       BNE    LF132                   ;2
       DEC    $DE                     ;5
       BMI    LF123                   ;2
       JMP    LF1D8                   ;3

LF123:
       LDA    $DE                     ;3
       CMP    #$A0                    ;2
       BNE    LF132                   ;2



       LDA    #$32                    ;2
       STA    $90                     ;3
       STA    $8E                     ;3
       JSR    LFD16                   ;6
LF132:
       LDY    #$00                    ;2

       BIT    $DB                     ;3
       BVC    LF147                   ;2
       LDA    $E5                     ;3
       AND    #$03                    ;2
       BEQ    LF140                   ;2
       LSR                            ;2
       BCC    LF143                   ;2
LF140:
       JMP    LF210                   ;3


LF143:
       STY    $DB                     ;3
LF147:
       LDA    #$FF                    ;2
       LDX    #$0A                    ;2
LF14D:
       STY    $A9,X                   ;4
       STA    $AA,X                   ;4
       STA    $CC,X                   ;4
       DEX                            ;2
       DEX                            ;2
       BPL    LF14D                   ;2
       LDX    #$05                    ;2
LF15A:
       STY    $EF,X                   ;4
       DEX                            ;2
       BPL    LF15A                   ;2
       STY    $ED                     ;3
       STY    $F5                     ;3
       STY    $FB                     ;3
       STY    $F6                     ;3
       STY    $F7                     ;3
       LDY    $E9                     ;3
       LDA    LFE94,Y                 ;4
       LDX    #$3F                    ;2 reset all cities
       STX    $EC                     ;3
       CPY    #$18                    ;2
       BCC    LF188                   ;2
       TYA                            ;2
       SED                            ;2
       SEC                            ;2
       SBC    #$17                    ;2
       TAY                            ;2
       CLD                            ;2
       LDA    LFE94,Y                 ;4
       STX    $ED                     ;3 reset all cities (p2)
       ORA    #$80                    ;2
       LDX    #$01                    ;2
       STX    $F5                     ;3

;here
LF188:
       STA    $F8                     ;3
       CPY    #$17                    ;2
       BNE    LF192                   ;2
       LDY    #$40                    ;2
       STY    $FB                     ;3
LF192:
       AND    #$0E                    ;2
       TAX                            ;2
       DEX                            ;2
       STX    $E7                     ;3
       LDA    #$54                    ;2
       STA    $93                     ;3
       STA    $94                     ;3
       LDA    $DB                     ;3
       ORA    #$40                    ;2
       STA    $DB                     ;3
       BMI    LF1D5                   ;2
       LDA    #$32                    ;2
       STA    $8E                     ;3
       STA    $90                     ;3
       LDX    #$01                    ;2
       STX    $DF                     ;3
       LDX    #$04                    ;2
       STX    $E0                     ;3
       LDA    #$13                    ;2
       BIT    $FB                     ;3
       BVC    LF1BE                   ;2
       LDA    #$FB                    ;2
LF1BE:
       LDY    $E7                     ;3
       INY                            ;2
LF1C1:
       CLC                            ;2
       ADC    #$0D                    ;2
       DEY                            ;2
       BPL    LF1C1                   ;2
       STA    $9B                     ;3
       LDA    #$B0                    ;2
       STA    $DE                     ;3
       LDA    $80                     ;3
       ORA    #$02                    ;2
       STA    $D8                     ;3
       STA    $D9                     ;3
LF1D5:
       JMP    LF210                   ;3


LF1D8:
       LDY    #$0F                    ;2
       LDA    $E7                     ;3
       CMP    #$10                    ;2
       BCS    LF1E1                   ;2
       TAY                            ;2
LF1E1:
       LDA    LFE6C,Y                 ;4
       BIT    $FB                     ;3
       BVC    LF1E9                   ;2
       LSR                            ;2
LF1E9:
       STA    $DE                     ;3
       LDA    LFE7E,Y                 ;4
       STA    $EB                     ;3

       LDA    #$0A                    ;2 10 missiles each cache
       STA    $8C                     ;3
       STA    $8B                     ;3
       STA    $8D                     ;3

       LDY    #$01                    ;2
       LDX    #$02                    ;2
LF1FA:
       STY    $C7,X                   ;4
       STY    $B5,X                   ;4
       DEC    $B5,X                   ;6
       DEX                            ;2
       BPL    LF1FA                   ;2
       STX    $91                     ;3
       STX    $92                     ;3
       INX                            ;2
       STX    $DF                     ;3
       LDA    #$40                    ;2
       STA    $DB                     ;3
LF210:
       LDY    #$1F                    ;2
       LDA    $E5                     ;3
       AND    #$03                    ;2
       BNE    LF21B                   ;2
       LDY    #$07                    ;2
LF21B:
       STY    $DA                     ;3
       LDA    $E5                     ;3
       LSR                            ;2
       LSR                            ;2
       LDA    #$FF                    ;2
       BCC    LF22A                   ;2
       STA    $EA                     ;3
       BNE    LF257                   ;2
LF22A:
       STA    $DB                     ;3
       LDA    $EA                     ;3
       BMI    LF236                   ;2
       EOR    $80                     ;3
       AND    $DA                     ;3
       BNE    LF257                   ;2
LF236:
       LDA    $80                     ;3
       AND    $DA                     ;3
       STA    $EA                     ;3
       SED                            ;2
       CLC                            ;2
       LDA    $E9                     ;3
       ADC    #$01                    ;2
       CMP    #$35                    ;2
       BNE    LF248                   ;2
       LDA    #$01                    ;2
LF248:
       STA    $E9                     ;3
       CLD                            ;2
       LDA    #$00                    ;2
       STA    $DF                     ;3
       STA    $E8                     ;3
       STA    $E7                     ;3
       STA    $8E                     ;3
       STA    $90                     ;3
LF257:
       BIT    $FB                     ;3
       BPL    LF25E                   ;2
       JMP    LF4D6                   ;3
LF25E:
       JSR    LFC92                   ;6


;trigger
;edited to use stick2 instead of trigger
       LDA    SWCHA                   ;4
       LSR                            ;2
       AND    #$07                    ;2
       EOR    #$07                    ;2
       BNE    LF270                   ;2

;clear button press flag
       LDA    $A2                     ;3
       AND    #$F7                    ;2
       STA    $A2                     ;3

LF2EDJ:
       JMP    LF2ED                   ;3

;check button press flag
LF270:
       LDY    #$02                    ;2
       LSR                            ;2 SWCHA bits 1-3 (reversed) still in A
       BCS    LF2AA                   ;2
       DEY                            ;2
       LSR                            ;2
       BCS    LF2AA                   ;2
       DEY                            ;2
LF2AA:
       LDA    $A2                     ;3
       AND    #$08                    ;2
       BNE    LF2EDJ                  ;2 quit if already pressed before

;check for free slots
       LDX    #$02                    ;2
LF278:
       LDA    $B5,X                   ;4
       BPL    LF28F                   ;2 slot free, branch ahead
       DEX                            ;2
       BPL    LF278                   ;2

;no slots free
LF27F:
       LDA    $DF                     ;3
       AND    #$0F                    ;2
       BNE    LF2ED                   ;2 <- watch out for out of range errors
       STA    $E0                     ;3
       LDA    $DF                     ;3
       ORA    #$02                    ;2
       STA    $DF                     ;3
       BNE    LF2ED                   ;2 <- " "

;slots free
LF28F:
       LDA    #$08                    ;2
       ORA    $A2                     ;3
       STA    $A2                     ;3
       LDA    $DE                     ;3
       BMI    LF2ED                   ;2 <- " "

       LDA.wy $8B,Y                   ;4
       BEQ    LF27F                   ;2
       SEC                            ;2
       SBC    #$01                    ;2
       STA.wy $8B,Y                   ;6
;save missile origin
       LDA    StartTbl,Y              ;4
       STA    $E2,X                   ;4 save start location (used for compares)
       STA    $C4,X                   ;4 save current missile X location

LF2A4:
       LDA    $DF                     ;3
       CMP    #$20                    ;2
       BCS    LF2B4                   ;2
       AND    #$0F                    ;2
       ORA    #$10                    ;2
       STA    $DF                     ;3
       LDA    #$0A                    ;2
       STA    $E1                     ;3
LF2B4:
       LDA    $E2,X                   ;4 new missile origin

       SEC                            ;2
       SBC    $90                     ;3
       BCS    LF2C1                   ;2
       INC    $C4,X                   ;6
       EOR    #$FF                    ;2
       ADC    #$01                    ;2
LF2C1:
       STA    $82                     ;3
       LDA    $8E                     ;3
       SEC                            ;2
       SBC    #$01                    ;2
       CMP    $82                     ;3
       BCC    LF2D5                   ;2
       STA    $83                     ;3
       LDA    #$C0                    ;2 starting Y
       STA    $B5,X                   ;4
       BNE    LF2DF                   ;3 always branch

LF2D5:
       LDY    $82                     ;3
       STA    $82                     ;3
       STY    $83                     ;3
       LDA    #$80                    ;2
       STA    $B5,X                   ;4
LF2DF:
       LDA    $83                     ;3
       STA    $B8,X                   ;4
       STA    $BB,X                   ;4
       LDA    $82                     ;3
       STA    $BE,X                   ;4
       LDA    #$00                    ;2
       STA    $C1,X                   ;4
LF2ED:
       LDA    $E5                     ;3
       ASL                            ;2
       LDX    $F5                     ;3
       BNE    LF2F6                   ;2
       ASL                            ;2
LF2F6:
       LDY    #$02                    ;2
       BCC    LF2FB                   ;2
       DEY                            ;2
LF2FB:
       STY    $DA                     ;3


       LDX    #$02                    ;2 3 active player missiles (max)
MoveMissileLoop:
       LDA    $B5,X                   ;4
       BMI    LF306                   ;2
LF303:
       JMP    NextMissile             ;3


LF306:
       AND    #$20                    ;2
       BNE    LF303                   ;2
       LDA    $C1,X                   ;4
       CLC                            ;2
       ADC    $BE,X                   ;4
       STA    $C1,X                   ;4
       CMP    $BB,X                   ;4
       BCC    LF340                   ;2
       SBC    $BB,X                   ;4
       STA    $C1,X                   ;4
       LDA    $B5,X                   ;4
       AND    #$40                    ;2
       BNE    LF329                   ;2
       LDA    $C7,X                   ;4
       CLC                            ;2
       ADC    $DA                     ;3
       STA    $C7,X                   ;4
       JMP    LF340                   ;3

;add/subtract missile trajectory
LF329:
       LDA    $E2,X                   ;4 new missile origin
       CMP    $C4,X                   ;4 check against current missile X
       BCS    LF339                   ;2
       LDA    $C4,X                   ;4
       CLC                            ;2
       ADC    $DA                     ;3
       STA    $C4,X                   ;4
       JMP    LF340                   ;3


LF339:
       LDA    $C4,X                   ;4
       SEC                            ;2
       SBC    $DA                     ;3
       STA    $C4,X                   ;4
LF340:
       LDA    $B5,X                   ;4
       AND    #$40                    ;2
       BEQ    LF350                   ;2
       LDA    $C7,X                   ;4
       CLC                            ;2
       ADC    $DA                     ;3
       STA    $C7,X                   ;4
       JMP    LF367                   ;3


LF350:
       LDA    $E2,X                   ;4 new missile origin
       CMP    $C4,X                   ;4
       BCS    LF360                   ;2
       LDA    $C4,X                   ;4
       CLC                            ;2
       ADC    $DA                     ;3
       STA    $C4,X                   ;4
       JMP    LF367                   ;3


LF360:
       LDA    $C4,X                   ;4
       SEC                            ;2
       SBC    $DA                     ;3
       STA    $C4,X                   ;4
LF367:
       LDA    $B8,X                   ;4
       SEC                            ;2
       SBC    $DA                     ;3
       STA    $B8,X                   ;4
       BCC    LF372                   ;2
       BNE    NextMissile             ;2
LF372:
       LDA    #$20                    ;2
       ORA    $B5,X                   ;4
       STA    $B5,X                   ;4
       LDY    #$00                    ;2
       STY    $9E,X                   ;4
       LDA    $C4,X                   ;4
       SEC                            ;2
       SBC    #$04                    ;2
       STA    $A6,X                   ;4
       LDA    $C7,X                   ;4
       SBC    #$04                    ;2
       STA    $A3,X                   ;4
NextMissile:
       DEX                            ;2
       BMI    LF38F                   ;2
       JMP    MoveMissileLoop         ;3


LF38F:
       LDX    $CA                     ;3
       LDY    #$54                    ;2
       LDA    $C4,X                   ;4 ??
       STA    $89                     ;3 ?? fired missile destination X
       LDA    $B5,X                   ;4
       AND    #$20                    ;2
       BNE    LF39F                   ;2
       LDY    $C7,X                   ;4
LF39F:
       STY    $84                     ;3
       LDA    $DE                     ;3
       BPL    LF3AC                   ;2
       CMP    #$A0                    ;2
       BCC    LF3AC                   ;2
       JMP    LF431                   ;3
LF3AC:
       LDA    SWCHA                   ;4


       LDY    $F5                     ;3
;jstick...these lines needed
       BEQ    LF3B8                   ;2 branch if player 1
       DEY                            ;2 player 2...adjust Y

LF3B8:
       STA    $DA                     ;3
       BIT    $FB                     ;3
       BVC    LF3C2                   ;2
       LDY    #$04                    ;2
       BNE    LF3C9                   ;2
LF3C2:
       LDA    $F8                     ;3
       LSR                            ;2
       BCC    LF3C9                   ;2
       LDY    #$02                    ;2
LF3C9:
       LDA    $8F                     ;3
       ROL    $DA                     ;5
       BCS    LF3DB                   ;2
       ADC    LFEAB,Y                 ;4
       STA    $8F                     ;3
       LDA    $90                     ;3
       ADC    LFEAC,Y                 ;4
       STA    $90                     ;3
LF3DB:
       ROL    $DA                     ;5
       BCS    LF3EE                   ;2
       SEC                            ;2
       LDA    $8F                     ;3
       SBC    LFEAB,Y                 ;4
       STA    $8F                     ;3
       LDA    $90                     ;3
       SBC    LFEAC,Y                 ;4
       STA    $90                     ;3
LF3EE:
       LDA    $DD                     ;3
       ROL    $DA                     ;5
       BCS    LF401                   ;2
       SEC                            ;2
       SBC    LFEAB,Y                 ;4
       STA    $DD                     ;3
       LDA    $8E                     ;3
       SBC    LFEAC,Y                 ;4
       STA    $8E                     ;3
LF401:
       ROL    $DA                     ;5
       BCS    LF411                   ;2
       ADC    LFEAB,Y                 ;4
       STA    $DD                     ;3
       LDA    $8E                     ;3
       ADC    LFEAC,Y                 ;4
       STA    $8E                     ;3
LF411:
       LDY    #$97                    ;2
       CPY    $90                     ;3
       BCS    LF419                   ;2
       STY    $90                     ;3
LF419:
       LDY    #$09                    ;2
       CPY    $90                     ;3
       BCC    LF421                   ;2
       STY    $90                     ;3
LF421:
       LDY    #$0A                    ;2
       CPY    $8E                     ;3
       BCC    LF429                   ;2
       STY    $8E                     ;3
LF429:
       LDY    #$53                    ;2
       CPY    $8E                     ;3
       BCS    LF431                   ;2
       STY    $8E                     ;3
LF431:
       LDA    $90                     ;3 ??
       STA    $8A                     ;3 ?? player's X

       LDA    $8E                     ;3
       STA    $85                     ;3
       LDY    $92                     ;3


       LDA    $98                     ;3
       AND    #$02                    ;2
       BEQ    LF445                   ;2
       TYA                            ;2
       ORA    #$10                    ;2
       TAY                            ;2
LF445:
       LDA    $91                     ;3
       STY    $91                     ;3
       STA    $92                     ;3

       LDA    $93                     ;3
       LDY    $94                     ;3
       STY    $93                     ;3
       STA    $94                     ;3

       LDA    $97                     ;3
       LDY    $98                     ;3
       STY    $97                     ;3
       STA    $98                     ;3

       LDA    $95                     ;3
       LDY    $96                     ;3
       STY    $95                     ;3
       STA    $96                     ;3

       LDA    $9A                     ;3
       STA    $88                     ;3
       LDY    $99                     ;3
       STY    $9A                     ;3

       STA    $99                     ;3















       LDA    $91                     ;3
       CMP    #$FF                    ;2
       BNE    LF4A4                   ;2
       LDX    #$0A                    ;2
LF475:
       LDA    $A9,X                   ;4
       BEQ    LF486                   ;2 branch if a city
       DEX                            ;2
       DEX                            ;2
       BPL    LF475                   ;2
       LDA    $D8                     ;3
       AND    #$07                    ;2
       BPL    LF4A2                   ;3 always branch

LF486:
       LDA    $D8                     ;3
       AND    #$07                    ;2
       CMP    #$06                    ;2
       BCS    LF4A2                   ;2
       ASL                            ;2
       TAX                            ;2
LF490:
       LDA    $A9,X                   ;4
       BEQ    LF4A0                   ;2 branch if a city
       INX                            ;2
       INX                            ;2
       CPX    #$0C                    ;2
       BNE    LF490                   ;2
       LDX    #$00                    ;2
       BEQ    LF490                   ;2 always branch

LF4A0:
       TXA                            ;2
       LSR                            ;2
LF4A2:
       STA    $95                     ;3

LF4A4:
       LDA    $80                     ;3
       AND    #$01                    ;2
       TAX                            ;2
       LDA    $9C,X                   ;4
       CLC                            ;2
       ADC    $9B                     ;3
       STA    $9C,X                   ;4
       BCC    LF4D6                   ;2
       LDA    $93                     ;3
       CMP    #$54                    ;2
       BEQ    LF4D6                   ;2
       LDA    $97                     ;3
       AND    #$02                    ;2
       BEQ    LF4D4                   ;2
       BIT    $F8                     ;3
       BVC    LF4D4                   ;2
       LDA    $80                     ;3
       AND    #$01                    ;2
       TAX                            ;2
       LDA    $F9,X                   ;4
       BEQ    LF4D4                   ;2
       INC    $93                     ;5
       INC    $93                     ;5
       DEC    $F9,X                   ;6
       .byte $2C                      ;4 skip 2 bytes
LF4D4:
       DEC    $93                     ;5
LF4D6:
;;Pause: ;still messed up here
       LDX    $CA                     ;3
       DEX                            ;2
       BPL    LF4DD                   ;2
       LDX    #$02                    ;2
LF4DD:
       STX    $CA                     ;3
       LDA    $80                     ;3
       AND    #$0F                    ;2
       STA    $DA                     ;3
       ASL                            ;2
       ASL                            ;2
       ASL                            ;2
       ASL                            ;2
       ORA    $DA                     ;3
       STA    $D7                     ;3

       LDA    $A2                     ;3
       AND    #$7F                    ;2
       STA    $A2                     ;3
       LDY    #$10                    ;2
       LDA    #$F8                    ;2
       CPX    #$04                    ;2
       BCC    LF51D                   ;2
       CPX    #$0C                    ;2
       BCS    LF51D                   ;2
       LDA    $A2                     ;3
       ORA    #$80                    ;2
       STA    $A2                     ;3
       LDA    #$F0                    ;2
       LDY    #$15                    ;2
LF51D:
       STA    $A1                     ;3
       STY    $EE                     ;3
       LDX    $CA                     ;3
       LDA    $A3,X                   ;4
       BIT    $A2                     ;3
       BPL    LF52C                   ;2
       CLC                            ;2
       ADC    #$FC                    ;2
LF52C:
       STA    $83                     ;3










       LDA    $80                     ;3
       AND    #$07                    ;2
       BNE    CheckNukedCities        ;2
       LDX    #$02                    ;2
LF536:
       INC    $9E,X                   ;6
       LDA    $9E,X                   ;4
       CMP    #$10                    ;2
       BNE    LF54A                   ;2
       LDA    #$00                    ;2
       STA    $B5,X                   ;4
       LDA    $E2,X                   ;4 new missile origin
       STA    $C4,X                   ;4
       LDA    #$01                    ;2
       STA    $C7,X                   ;4
LF54A:
       DEX                            ;2
       BPL    LF536                   ;2

CheckNukedCities:
       LDX    #$0A                    ;2 for all cities...
NukeAnimationLoop:
       LDA    $A9,X                   ;4
       BEQ    NextCity                ;2 branch if a city
       CMP    #<RubbleGFX-1           ;2 is it lower than rubble?
       BCS    NextCity                ;2 branch if higher (already or not being nuked)

;city currently being nuked...adjust animation frame
       LDA    $80                     ;3
       AND    #$0F                    ;2
       BNE    NextCity                ;2 every 16th frame go up a frame (city destroyed)
       LDA    $A9,X                   ;4
       CLC                            ;2
       ADC    #$0C                    ;2
       STA    $A9,X                   ;4
NextCity:
       DEX                            ;2
       DEX                            ;2
       BPL    NukeAnimationLoop       ;2

;good
Pause:



       LDA    #$38                    ;2
       STA    $86                     ;3
       LDA    #$40                    ;2
       STA    $87                     ;3
       LDA    $A1                     ;3
       STA    $DA                     ;3
       LDA    #$00                    ;2
       STA    $A1                     ;3
       JSR    LF003                   ;6
       LDA    $DA                     ;3
       STA    $A1                     ;3
       LDX    #$00                    ;2
       LDA    $DF                     ;3
       AND    #$0F                    ;2
       ASL                            ;2
       TAY                            ;2
       LDA    LF598,Y                 ;4
       PHA                            ;3
       LDA    LF597,Y                 ;4
       PHA                            ;3
       RTS                            ;6


LF5A7:
       LDA    $E0                     ;3
       AND    #$03                    ;2
       BNE    LF5B3                   ;2
       LDA    $D8                     ;3
       AND    #$07                    ;2
       STA    $E1                     ;3
LF5B3:
       LDY    #$0C                    ;2
       LDX    #$08                    ;2
       LDA    $E1                     ;3
       DEC    $E0                     ;5
       BNE    LF614                   ;2
       LDA    #$01                    ;2
       STA    $DF                     ;3
       LDA    #$04                    ;2
       STA    $E0                     ;3
       BNE    LF614                   ;2
LF5C7:
       DEC    $E0                     ;5
       LDA    $E0                     ;3
       JMP    LF5D8                   ;3
LF5CE:
       LDA    $80                     ;3
       AND    #$0F                    ;2
       CMP    #$03                    ;2
       BCS    LF614                   ;2
       EOR    #$07                    ;2
LF5D8:
       ASL                            ;2
       TAX                            ;2
       LDY    #$08                    ;2
       LDA    #$18                    ;2
       BNE    LF614                   ;2
LF5E0:
       LDA    $80                     ;3
       LDX    $E0                     ;3
       AND    #$1F                    ;2
       BNE    LF5EE                   ;2
       CPX    #$0E                    ;2
       BEQ    LF5EE                   ;2
       INC    $E0                     ;5
LF5EE:
       LDA    $80                     ;3
       AND    #$03                    ;2
       ORA    #$08                    ;2
       LDY    #$05                    ;2
       BNE    LF655                   ;2
LF5F8:
       LDY    $E0                     ;3
       LDA    LFE51,Y                 ;4
       LDX    #$08                    ;2
       INY                            ;2
       STY    $E0                     ;3
       CPY    #$08                    ;2
       BEQ    LF60A                   ;2
       LDY    #$05                    ;2
       BNE    LF614                   ;2
LF60A:
       LDA    $DF                     ;3
       AND    #$F0                    ;2
       STA    $DF                     ;3
       LDX    #$00                    ;2
       STX    $E0                     ;3
LF614:
       JMP    LF655                   ;3

;end of game sound?

LF617:
       LDY    #$08                    ;2
       STY    AUDC0                   ;3
       LDA    $80                     ;3
       AND    #$0F                    ;2
       BNE    LF633                   ;2
       INC    $E0                     ;5
       LDA    $E0                     ;3
       CMP    #$10                    ;2 did it reach 16 clicks?
       BNE    LF633                   ;2 do rising sound?
       LDA    #$30                    ;2
       STA    $DF                     ;3
       LDX    #$50                    ;2
       STX    $E1                     ;3
;       BEQ    LF655                   ;2 never taken??
       BNE    LF655                   ;2 correction

LF633:
       LDX    $E0                     ;3
       STX    AUDV0                   ;3
       TXA                            ;2
       STA    AUDF0                   ;3
       EOR    #$FF                    ;2
       JMP    LF6D0                   ;3


LF63F:
       LDA    $DE                     ;3
       CMP    #$A0                    ;2
       BCS    LF655                   ;2
       LDX    $E0                     ;3
       TXA                            ;2
       INX                            ;2
       CPX    #$14                    ;2
       BNE    LF64F                   ;2
       LDX    #$04                    ;2
LF64F:
       STX    $E0                     ;3
       LDY    #$0C                    ;2
       LDX    #$08                    ;2

LF655:
       STX    AUDV0                   ;3
       STY    AUDC0                   ;3
       STA    AUDF0                   ;3
       LDX    #$00                    ;2
       LDA    $DF                     ;3
       AND    #$F0                    ;2
       CMP    #$10                    ;2
       BEQ    LF68F                   ;2
       CMP    #$20                    ;2
       BEQ    LF6BA                   ;2
       CMP    #$30                    ;2
       BCC    LF6D0                   ;2

LF670:
       DEC    $E1                     ;5
       BEQ    LF6A1                   ;2
       LDA    $E1                     ;3
       AND    #$70                    ;2
       LSR                            ;2
       LSR                            ;2
       LSR                            ;2
       LSR                            ;2
       TAY                            ;2
       LDX    LF68A,Y                 ;4
       LDY    #$08                    ;2
       LDA    $E1                     ;3
       AND    #$0F                    ;2
       ORA    #$10                    ;2
       BNE    LF6D0                   ;2 always branch

LF68F:
       LDY    #$08                    ;2
       LDX    #$06                    ;2
       LDA    $80                     ;3
       AND    #$03                    ;2
       BNE    LF69D                   ;2
       DEC    $E1                     ;5
       BEQ    LF6A1                   ;2
LF69D:
       LDA    $E1                     ;3
       BNE    LF6D0                   ;2

LF6A1:
       LDA    $DF                     ;3
       AND    #$0F                    ;2
       STA    $DF                     ;3
       BIT    $FB                     ;3
       BPL    LF6B7                   ;2
       LDA    #$C3                    ;2
       STA    $DB                     ;3
       LDA    #$00                    ;2
       STA    $FB                     ;3
       STA    $E7                     ;3
       STA    $E8                     ;3
LF6B7:
       JMP    LF6D0                   ;3
LF6BA:
       LDY    $E1                     ;3
       LDX    LFE59,Y                 ;4
       LDA    $80                     ;3
       AND    #$07                    ;2
       BNE    LF6CC                   ;2
       INY                            ;2
       STY    $E1                     ;3
       CPY    #$10                    ;2
       BEQ    LF6A1                   ;2
LF6CC:
       LDA    #$1F                    ;2
       LDY    #$08                    ;2


LF6D0:

       STX    AUDV1                   ;3
       STY    AUDC1                   ;3
       STA    AUDF1                   ;3

;removed B&W code


;removed level colors

       LDX    $F5                     ;3
       LDA    $DB                     ;3
       AND    #$04                    ;2
       BEQ    LF748                   ;2
       LDA    $E9                     ;3
       STA    $F3,X                   ;4
       LDY    #$00                    ;2
       STY    $F1,X                   ;4
       INY                            ;2
       CMP    #$18                    ;2
       BCC    LF746                   ;2
       INY                            ;2
LF746:
       STY    $EF,X                   ;4
LF748:
;Score offsets: 0, 2, and 4
       INX                            ;2
       INX                            ;2
       INX                            ;2
       INX                            ;2
       LDY    #$0C                    ;2

;NEW
;added...flash text
       LDA    $DB                     ;3
       AND    #$04                    ;2
       BNE    SetScorePointersLoop    ;2 branch if game inactive


       LDA    $E6                     ;3
       AND    #$20                    ;2
       BEQ    PrintPlayer             ;2



       LDA    $DE                     ;3
       BPL    SetScorePointersLoop    ;2
       CMP    #$E0                    ;2
       BEQ    SetScorePointersLoop    ;2
       LDA    $80                     ;3
       AND    #$30                    ;2
       BNE    SetScorePointersLoop    ;2

PrintPlayer:
       LDX    #$0A                    ;2
PlayerStartLoop:
       LDA    PlayerUpTxtTbl,X        ;4
       STA    $CC,X                   ;3
       DEX                            ;2
       BPL    PlayerStartLoop         ;2
       LDX    $F5                     ;3
       LDA    Digit+1,X               ;4
       STA    $CB                     ;3
       BNE    NotGameSelect           ;2 always branch


SetScorePointersLoop:
       LDA    $EF,X                   ;4
       STA    $CB                     ;3
       LSR                            ;2
       LSR                            ;2
       LSR                            ;2
       LSR                            ;2
       STX    $CC                     ;3
       JSR    GetDigit                ;6
       LDA    $CB                     ;3
       AND    #$0F                    ;2
       JSR    GetDigit                ;6
       DEX                            ;2
       DEX                            ;2
       BPL    SetScorePointersLoop    ;2

;clear leading zeros for first 5 digits only
       LDX    #$08                    ;2
       LDY    #<Blank                 ;2
LF78B:
       LDA    $CD,X                   ;4
       CMP    #<Zero                  ;2
       BNE    CheckGameSelect         ;2
       STY    $CD,X                   ;4 save blank space
       DEX                            ;2
       DEX                            ;2
       BPL    LF78B                   ;2

;clear digits not used in game selection mode
CheckGameSelect:
       LDA    $DB                     ;3
       AND    #$04                    ;2
       BEQ    NotGameSelect           ;2
       STY    $CD                     ;3
       STY    $CF                     ;3
       STY    $D1                     ;3

NotGameSelect:
       LDA    $D7                     ;3
       AND    $86                     ;3
       STA    $D7                     ;3
       LDA    $E6                     ;3
       AND    #$01                    ;2
       STA    COLUBK                  ;3
       ASL                            ;2
       ORA    $F5                     ;3
       TAX                            ;2
;color for the background of the score
       LDA    #$03                    ;2
       STA    NUSIZ1                  ;3
       STA    VDELP0                  ;3
       STA    VDELP1                  ;3
;color for the score digits
       LDY    ScoreColor,X            ;4 load custom score color
       STY    COLUP0                  ;3



DisplayStartWait:
       LDA    INTIM                   ;4
       BNE    DisplayStartWait        ;2
       STA    WSYNC                   ;3
       STA    VBLANK                  ;3
       STA    $81                     ;3
       STA    HMM0                    ;3
       STA    HMM1                    ;3
       STA    HMBL                    ;3
       STY    COLUP1                  ;3

       LDY    #$06                    ;2
DrawScoreLoop:
       STY    $DA                     ;3
       LDA    ($D5),Y                 ;5
       STA    GRP0                    ;3
       STA    WSYNC                   ;3
       LDA    ($D3),Y                 ;5
       STA    GRP1                    ;3
       LDA    ($D1),Y                 ;5
       STA    GRP0                    ;3
       LDA    ($CF),Y                 ;5
       STA    $82                     ;3
       LDA    ($CD),Y                 ;5
       TAX                            ;2
       LDA    ($CB),Y                 ;5
       TAY                            ;2
       LDA    $82                     ;3
       STA    GRP1                    ;3
       STX    GRP0                    ;3
       STY    GRP1                    ;3
       STY    GRP0                    ;3
       LDY    $DA                     ;3
       DEY                            ;2
       BPL    DrawScoreLoop           ;2
       STA    WSYNC                   ;3
       INY                            ;2 Y now = $00

       STY    VDELP0                  ;3
       STY    VDELP1                  ;3
       STY    GRP0                    ;3
       STY    GRP1                    ;3
;keep Y's value of $00 by using A instead here
       LDA    #$21                    ;2
       STA    CTRLPF                  ;3

       LDA    $80                     ;3
       AND    #$0F                    ;2
       STA    COLUPF                  ;3
       STY    COLUBK                  ;3 Y = 00 from above (black)

       LDX    $CA                     ;3
       LDY    #<Blank                 ;2
       LDA    $B5,X                   ;4
       AND    #$20                    ;2
       BEQ    LF4FB                   ;2
       LDA    $9E,X                   ;4
       TAX                            ;2
       LDY    ExplosionAnim,X         ;4
LF4FB:


       STA    WSYNC                   ;3

       STY    $D5                     ;3 save current frame of explosion
       LDA    #>Explosion1            ;2
       STA    $D6                     ;3 high byte of all explosion gfx

       LDA    $E6                     ;3
       AND    #$01                    ;2
       TAY                            ;2
       LDA    TrailColor,Y            ;4
       STA    COLUP0                  ;3
       LDA    #$28                    ;2 edit explosion color here (Light brown)
       STA    COLUP1                  ;3

       LDY    $80                     ;3
       LDA    $97                     ;3
       AND    #$02                    ;2
       BNE    LF843                   ;2
       TAY                            ;2
       LDA    $80                     ;3
       AND    #$08                    ;2
       BNE    LF843                   ;2
       LDY    #$0F                    ;2
LF843:
       TYA                            ;2
       AND    $86                     ;3
       STA    $D7                     ;3
       LDX    $CA                     ;3
       LDA    $A6,X                   ;4
       STA    $87                     ;3
       LDA    $91                     ;3
       STA    NUSIZ0                  ;3
       LDA    $EE                     ;3
       STA    NUSIZ1                  ;3
       LDX    #$01                    ;2
       LDA    #$36                    ;2
       STA    TIM8T                   ;4
       JSR    LF005                   ;6
       LDA    #$00                    ;2
       STA    HMP1                    ;3

LF864:
       LDA    INTIM                   ;4
       BNE    LF864                   ;2
       LDX    #$53                    ;2
LF86B:
       STA    WSYNC                   ;3
       STA    HMOVE                   ;3
       LDA    #$02                    ;2
       CPX    $93                     ;3
       BNE    LF87B                   ;2
       LDY    $80                     ;3 flashing missile heads
       STY    COLUP0                  ;3
       JMP    LF883                   ;2

LF87B:
       BIT    $97                     ;3
       BNE    LF881                   ;2
       BCS    LF883                   ;2
LF881:
       LDA    #$00                    ;2




LF883:
       STA    ENAM0                   ;3
       LDA    $81                     ;3
       CLC                            ;2
       ADC    $95                     ;3
       STA    $81                     ;3
       LDY    #$00                    ;2
       BCC    LF892                   ;2
       LDY    $97                     ;3
LF892:
       STY    HMM0                    ;3
       STA    WSYNC                   ;3
       LDA    #$00                    ;2
       CPX    $85                     ;3
       BNE    LF89E                   ;2
       LDA    #$02                    ;2
LF89E:
       STA    ENABL                   ;3
       TXA                            ;2
       SEC                            ;2
       SBC    $83                     ;3
       TAY                            ;2
       BIT    $A2                     ;3
       BPL    LF8AC                   ;2
       LSR                            ;2
       TAY                            ;2
       ASL                            ;2
LF8AC:
       AND    $A1                     ;3
       BNE    LF8B5                   ;2
       LDA    ($D5),Y                 ;5 XX
       .byte $2C                      ;4 skip next 2 (watch out)
LF8B5:
       LDA    #$00                    ;2
LF8B7:
       STA    GRP1                    ;3
       LDA    #$00                    ;2
       CPX    $84                     ;3
       BNE    LF8C1                   ;2
       LDA    #$02                    ;2
LF8C1:
       STA    ENAM1                   ;3
       DEX                            ;2
       BNE    LF86B                   ;2
       STA    WSYNC                   ;3

       LDY    #$02                    ;2
       LDA    $84                     ;3
       CMP    #$01                    ;2
       BEQ    LF8D5                   ;2
       LDY    #$00                    ;2
       BEQ    LF8D7                   ;3 always branch

LF8D5:
       NOP                            ;2
       NOP                            ;2
LF8D7:
       STY    ENAM1                   ;3

       LDA    #$01                    ;2
       STX    ENAM0                   ;3
       STX    ENAM0                   ;3
       STX    RESP0                   ;3
;cities color
       AND    $E6                     ;3
       TAY                            ;2
       LDX    CityColor,Y             ;4
       STX    COLUP0                  ;3

       LDA    CacheColor,Y            ;4
       STA    $FE                     ;3
       LDY    #$08                    ;2

       STY    ENAM1                   ;3
       STA    RESP1                   ;3

       STX    COLUP1                  ;3
       LDX    #$23                    ;3 brown (shared for sprite size)

       STX    COLUPF                  ;3
       STX    NUSIZ0                  ;3
       STX    NUSIZ1                  ;3

DrawCitiesLoop:
       LDA    HillGFX,Y               ;4 get hill gfx
       STA    WSYNC                   ;3
       STA    PF2                     ;3

       SBC    #$70                    ;2 try to correct side hill gfx
       STA.w  PF0                     ;4 1 extra cycle

       LDA    ($A9),Y                 ;5
       STA    GRP0                    ;3
       LDA    ($AD),Y                 ;5
       TAX                            ;2
       LDA    ($AB),Y                 ;5
       STA    GRP0                    ;3
       LDA    RESP0                   ;3
       STX    GRP0                    ;3
       LDA    ($B3),Y                 ;5
       TAX                            ;2
       LDA    ($AF),Y                 ;5
       STA    GRP1                    ;3
       LDA    ($B1),Y                 ;5
       STA    GRP1                    ;3
       DEY                            ;2
       STX    GRP1                    ;3
       BPL    DrawCitiesLoop          ;2

       LDA    #$22                    ;2 load the brown color instead
       STY    $CC                     ;3
       STA    WSYNC                   ;3
       STY    $CE                     ;3
       STA    RESP0                   ;3 (reset for left silo)
       STA    COLUBK                  ;3
       INY                            ;2

;reset the sprite sizes (large single)
       LDX    #$05                    ;2
       STX    NUSIZ0                  ;3
       STX    NUSIZ1                  ;3

;top section of land (below the hill)...clear playfield and sprites
       STY    PF2                     ;3
       STY    PF0                     ;3
       STY    GRP0                    ;3
       STY    GRP1                    ;3

       LDA    $80                     ;3 framecounter used ahead
;missiles, cache color
       LDY    $FE                     ;3

       STY    COLUP0                  ;3
       AND    #$01                    ;2 keep only low bit of frame counter

       STA    RESP1                   ;3 reset for center cache

       STY    COLUP1                  ;3
       LDX    $8D                     ;3 get center silo count
       LDY    CacheGFX,X              ;4 load count gfx pointer for center silo
       STY    $CD                     ;3

       EOR    #$01                    ;2 bugfix
       TAX                            ;2 give to index register
       bne    LF954                   ;2³
       STA    RESP0                   ;3 (reset for right silo)
LF954:
       LDY    $8B,X                   ;4 (determined by low bit of frame counter)
       LDA    CacheGFX,Y              ;4 load count gfx pointer for left/right silo
       STA    $CB                     ;3

       LDX    #$22                    ;2
       LDY    #$03                    ;2
DrawCacheLoop:
       INX                            ;2 color shading for ground zero
       INX                            ;2

       STA    WSYNC                   ;3
       STX    COLUBK                  ;3
       lda    ($CD),y                 ;5  
       sta    GRP1                    ;3  
       lda    ($CB),y                 ;5  
       sta    GRP0                    ;3  
       DEY                            ;2  
       bpl    DrawCacheLoop           ;2³ loop until all lines done

;NEW
       LDX    #$2A                    ;3
       LDA    $DF                     ;3
       CMP    #$30                    ;2
       BCC    LF730                   ;2
       LDX    $80                     ;3
LF730:


       STA    WSYNC                   ;3
;reset the sprite sizes (small triple)
       LDA    #$03                    ;3
       STA    NUSIZ0                  ;3
       STA    NUSIZ1                  ;3
;color for the remaining part of land
       STX    COLUBK                  ;3

       LDA    #$1A                    ;2
       STA    TIM64T                  ;4
       INY                            ;2

       STY    GRP0                    ;3
       STY    GRP1                    ;3

       LDA    $91                     ;3
       CMP    #$FF                    ;2
       BNE    LF991                   ;2
       BIT    $DE                     ;3
       BMI    LF991                   ;2
       JSR    LFA81                   ;6
       BCC    LF98E                   ;2
       LDA    $94                     ;3
       CMP    #$54                    ;2
       BNE    LF98E                   ;2
       JSR    LFCF4                   ;6
LF98E:
       JMP    LFA6F                   ;3
LF991:
       LDY    $93                     ;3
       BNE    LF99B                   ;2
       JSR    LFBB2                   ;6
       JMP    LFA6F                   ;3


LF99B:
       AND    #$07                    ;2
       TAX                            ;2
       LDA    LFDEE,X                 ;4
       STA    $88                     ;3
       LDY    LFDF6,X                 ;4
       LDA    LFE1E,Y                 ;4
       STA    $D5                     ;3
       LDA    LFE1F,Y                 ;4
       STA    $D6                     ;3
       LDA    #$53                    ;2
       SEC                            ;2
       SBC    $93                     ;3
       STA    $81                     ;3
       LDA    $95                     ;3
       STA    $DA                     ;3
       JSR    LFC78                   ;6
LF9BE:
       LDY    $88                     ;3
       LDA    $99                     ;3
       CLC                            ;2
       ADC    ($D5),Y                 ;5
       LDY    $93                     ;3
       STY    $83                     ;3
       LDY    $97                     ;3
       CPY    #$F0                    ;2
       BCC    LF9D5                   ;2
       CLC                            ;2
       ADC    $87                     ;3
       JMP    LF9D8                   ;3
LF9D5:
       SEC                            ;2
       SBC    $87                     ;3
LF9D8:
       STA    $82                     ;3
       LDX    $CA                     ;3
       LDA    $B5,X                   ;4
       AND    #$20                    ;2
       BEQ    LFA1B                   ;2
       LDY    $C7,X                   ;4
       LDA    $C4,X                   ;4
       TAX                            ;2
       JSR    LFC4C                   ;6
       STA    $82                     ;3
       LDX    $CA                     ;3
       LDY    $9E,X                   ;4
       LDA    $97                     ;3
       AND    #$02                    ;2
       BEQ    LFA14                   ;2
       BIT    $F8                     ;3
       BVC    LFA14                   ;2
       LDA    LFDDF,Y                 ;4
       CMP    $82                     ;3
       BCC    LFA1B                   ;2
       LDA    $82                     ;3
       CMP    #$03                    ;2
       BCC    LFA1E                   ;2
       LDA    $80                     ;3
       AND    #$01                    ;2
       TAX                            ;2
       LDA    #$02                    ;2
       STA    $F9,X                   ;4
       BNE    LFA1B                   ;2
       BCC    LFA1B                   ;2
LFA14:
       LDA    LFDDF,Y                 ;4
       CMP    $82                     ;3
       BCS    LFA1E                   ;2
LFA1B:
       JMP    LFA68                   ;3
LFA1E:
       LDY    #$00                    ;2
       LDA    $97                     ;3
       AND    #$02                    ;2
       BEQ    LFA27                   ;2
       INY                            ;2
LFA27:
       LDA    #$25                    ;2
       JSR    LFCCB                   ;6
       LDA    $DF                     ;3
       CMP    #$30                    ;2
       BCS    LFA3C                   ;2
       AND    #$0F                    ;2
       ORA    #$20                    ;2
       STA    $DF                     ;3
       LDA    #$00                    ;2
       STA    $E1                     ;3
LFA3C:
       LDA    $D5                     ;3
       CLC                            ;2
       ADC    #$0D                    ;2
       STA    $D5                     ;3
       LDY    $88                     ;3
       LDA    ($D5),Y                 ;5
       STA    $91                     ;3
       CMP    #$FF                    ;2
       BNE    LFA53                   ;2
       LDA    #$55                    ;2
       STA    $93                     ;3
       BNE    LFA6F                   ;2
LFA53:
       LDA    $D5                     ;3
       CLC                            ;2
       ADC    #$0D                    ;2
       STA    $D5                     ;3
       LDA    $99                     ;3
       CLC                            ;2
       ADC    ($D5),Y                 ;5
       STA    $99                     ;3
       LDA    $D5                     ;3
       SEC                            ;2
       SBC    #$1A                    ;2
       STA    $D5                     ;3
LFA68:
       DEC    $88                     ;5
       BMI    LFA6F                   ;2
       JMP    LF9BE                   ;3


LFA6F:
       LDA    INTIM                   ;4
       BNE    LFA6F                   ;2
       LDY    #$02                    ;2
       STY    WSYNC                   ;3
       STY    VBLANK                  ;3
       STA    COLUBK                  ;3 A=0 from above
       JMP    LF056                   ;3
LFA81:
       LDY    #$00                    ;2
       LDA    $97                     ;3
       AND    #$02                    ;2
       BEQ    LFA95                   ;2
       LDA    $98                     ;3
       AND    #$02                    ;2
       BNE    LFA95                   ;2
       LDA    $DF                     ;3
       AND    #$F0                    ;2
       STA    $DF                     ;3
LFA95:
       STY    $97                     ;3
       BIT    $DE                     ;3
       BMI    LFAA3                   ;2
       LDA    $DE                     ;3
       BNE    LFAC5                   ;2
       LDA    $EB                     ;3
       BNE    LFAA9                   ;2
LFAA3:
       LDA    #$54                    ;2
       STA    $93                     ;3
R14:
       SEC                            ;2
R12:
       RTS                            ;6

LFAA9:
       LDY    #$02                    ;2
       STY    $E0                     ;3
       LDY    #$FF                    ;2
       STY    $97                     ;3
       LDA    $80                     ;3
       AND    #$01                    ;2
       TAX                            ;2
       INY                            ;2
       STY    $F9,X                   ;4
       DEC    $EB                     ;5
       LDA    $DF                     ;3
       AND    #$F0                    ;2
       ORA    #$03                    ;2
       STA    $DF                     ;3
       BNE    LFACF                   ;2
LFAC5:
       LDA    $D8                     ;3
       AND    #$18                    ;2
       BNE    LFACF                   ;2
       LDA    $EB                     ;3
       BNE    LFAA9                   ;2
LFACF:
       LDY    $95                     ;3
       LDA    TargetTbl,Y             ;4
       STA    $82                     ;3
       BIT    $97                     ;3
       BMI    LFAEB                   ;2
       LDA    $DE                     ;3
       CMP    #$04                    ;2
       BCS    LFAE7                   ;2
       TAY                            ;2
       LDA    LFE15,Y                 ;4
       BPL    LFAFA                   ;2 always branch

LFAE7:
       CPY    #$06                    ;2
       BCC    LFAEF                   ;2
LFAEB:
       LDA    #$00                    ;2
       BEQ    LFAFA                   ;2
LFAEF:
       LDA    $D8                     ;3
       LSR                            ;2
       LSR                            ;2
       LSR                            ;2
       AND    #$07                    ;2
       TAY                            ;2
       LDA    LFE0D,Y                 ;4
LFAFA:
       TAY                            ;2
       STA    $91                     ;3
       LDA    LFDFD,Y                 ;4
       STA    $83                     ;3
       LDA    $D8                     ;3
       CMP    #$A0                    ;2
       BCC    LFB09                   ;2
       LSR                            ;2
LFB09:
       CLC                            ;2
       ADC    $83                     ;3
       CMP    #$A0                    ;2
       BCC    LFB11                   ;2
       LSR                            ;2
LFB11:
       SEC                            ;2
       SBC    $83                     ;3
       STA    $99                     ;3
       CMP    $82                     ;3
       BCS    LFB4E                   ;2
       CLC                            ;2
       ADC    $83                     ;3
       CMP    $82                     ;3
       BCC    LFB4A                   ;2
       LDA    $82                     ;3
       CLC                            ;2
       ADC    $83                     ;3
       CMP    #$A0                    ;2
       BCS    LFB34                   ;2
       LDA    $83                     ;3
       LSR                            ;2
       CLC                            ;2
       ADC    $99                     ;3
       CMP    $82                     ;3
       BCS    LFB43                   ;2
LFB34:
       LDA    $82                     ;3
       CMP    $83                     ;3
       BCC    LFB43                   ;2
       LDX    #$10                    ;2
LFB3C:
       LDA    $83                     ;3
       CLC                            ;2
       ADC    $99                     ;3
       BNE    LFB52                   ;2
LFB43:
       LDA    $99                     ;3
       LDX    #$F0                    ;2
       BNE    LFB52                   ;2 always branch

LFB4A:
       LDX    #$F0                    ;2
       BNE    LFB3C                   ;2
LFB4E:
       LDX    #$10                    ;2
       LDA    $99                     ;3
LFB52:
       STX    $DA                     ;3
       TAX                            ;2
       LDA    $97                     ;3
       AND    #$02                    ;2
       ORA    $DA                     ;3
       STA    $97                     ;3
       TXA                            ;2
       LDY    #$53                    ;2
       STY    $93                     ;3
       SEC                            ;2
       SBC    $82                     ;3
       BCS    LFB6B                   ;2
       EOR    #$FF                    ;2
       ADC    #$01                    ;2
LFB6B:
       STY    $81                     ;3
       JSR    LFB7E                   ;6
       STX    $87                     ;3
       LDX    #$00                    ;2
       STA    $DA                     ;3
       JSR    LFB82                   ;6
       STX    $86                     ;3
       JMP    LFB9C                   ;3
LFB7E:
       STA    $DA                     ;3
       LDA    #$00                    ;2
LFB82:
       LDY    #$07                    ;2 ???
LFB84:
       ROL    $DA                     ;5
       ROL                            ;2
       BCS    LFB97                   ;2
       CMP    $81                     ;3
       BCC    LFB8F                   ;2
       SBC    $81                     ;3
LFB8F:
       DEY                            ;2
       BPL    LFB84                   ;2
       ROL    $DA                     ;5
       LDX    $DA                     ;3
       RTS                            ;6

LFB97:
       SBC    $81                     ;3
       SEC                            ;2
       BCS    LFB8F                   ;2
LFB9C:
       LDA    $86                     ;3
       STA    $95                     ;3
       LDA    $97                     ;3
       AND    #$02                    ;2
       BNE    LFBB0                   ;2
       LDY    $91                     ;3
       LDA    $DE                     ;3
       CLC                            ;2
       SBC    LFDEE,Y                 ;4
       STA    $DE                     ;3
LFBB0:
       CLC                            ;2
       RTS                            ;6

LFBB2:
       LDA    $91                     ;3
       AND    #$07                    ;2
       TAY                            ;2
       LDA    LFDEE,Y                 ;4
       STA    $82                     ;3
       LDA    LFDF6,Y                 ;4
       TAY                            ;2
       LDA    LFE1E,Y                 ;4
       STA    $D5                     ;3
       LDA    LFE1F,Y                 ;4
       STA    $D6                     ;3
       LDA    #$53                    ;2
       STA    $81                     ;3
       LDA    $95                     ;3
       STA    $DA                     ;3
       JSR    LFC78                   ;6
LFBD5:
       LDY    $82                     ;3
       LDA    $99                     ;3
       CLC                            ;2
       ADC    ($D5),Y                 ;5
       LDX    $97                     ;3
       CPX    #$F0                    ;2
       BCS    LFBE8                   ;2
       SEC                            ;2
       SBC    $87                     ;3
       JMP    LFBEB                   ;3
LFBE8:
       CLC                            ;2
       ADC    $87                     ;3
LFBEB:
       STA    $81                     ;3
       LDY    #$08                    ;2

CheckHitLoop:
       LDA    TargetTbl,Y             ;4
       SEC                            ;2
       SBC    #$04                    ;2
       CMP    $81                     ;3
       BCS    NothingHit              ;2
       ADC    #$08                    ;2
       CMP    $81                     ;3
       BCS    CheckRightSilo          ;2
NothingHit:
       DEY                            ;2
       BPL    CheckHitLoop            ;2
       BMI    LFC3F                   ;2 always branch

NoSilosHit:
       TYA                            ;2
       ASL                            ;2
       TAX                            ;2
       LDY    #<Nuke                  ;2
       LDA    $A9,X                   ;4
       CMP    #<RubbleGFX             ;2 is it already rubble?
       BEQ    LFC3D                   ;2 branch if so
       LDA    $DF                     ;3 otherwise, nuke the city
       AND    #$0F                    ;2
       ORA    #$40                    ;2
       STA    $DF                     ;3
       LDA    #$50                    ;2
       STA    $E1                     ;3
LFC3D:
       STY    $A9,X                   ;4
LFC3F:
       DEC    $82                     ;5
       BPL    LFBD5                   ;2 <-
       LDA    #$FF                    ;2
       STA    $91                     ;3
       LDA    #$55                    ;2
       STA    $93                     ;3
       RTS                            ;6

;new silos
CheckRightSilo:
       LDA    #$00                    ;2
       CPY    #$06                    ;2
       BNE    CheckCenterSilo         ;2
       LDY    $8B                     ;3
       STA    $8B                     ;3
       BPL    AllSilos                ;2 always branch
CheckCenterSilo:
       CPY    #$07                    ;2
       BNE    CheckLeftSilo           ;2
       LDY    $8D                     ;3
       STA    $8D                     ;3
       BPL    AllSilos                ;2 always branch
CheckLeftSilo:
       CPY    #$08                    ;2
       BNE    NoSilosHit              ;2
       LDY    $8C                     ;3
       STA    $8C                     ;3
AllSilos:
       LDA    #$20                    ;2
       STA    $DC                     ;3

       TYA                            ;2
       BEQ    NoExplosionSound        ;2
;set explosion sound
       LDA    $DF                     ;3
       AND    #$0F                    ;2
       ORA    #$30                    ;2
       STA    $DF                     ;3
NoExplosionSound:
       LDA    #$50                    ;2
       STA    $E1                     ;3
       BNE    LFC3F                   ;2 always branch

LFC4C:
       TXA                            ;2
       SEC                            ;2
       SBC    $82                     ;3
       BCS    LFC56                   ;2
       EOR    #$FF                    ;2
       ADC    #$01                    ;2
LFC56:
       STA    $82                     ;3
       TYA                            ;2
       SEC                            ;2
       SBC    $83                     ;3
       BCS    LFC62                   ;2
       EOR    #$FF                    ;2
       ADC    #$01                    ;2
LFC62:
       CMP    $82                     ;3
       BCC    LFC6B                   ;2
       LDX    $82                     ;3
       STA    $82                     ;3
       TXA                            ;2
LFC6B:
       LSR                            ;2
       LSR                            ;2
       STA    $83                     ;3
       ASL                            ;2
       CLC                            ;2
       ADC    $83                     ;3
       LSR                            ;2
       CLC                            ;2
       ADC    $82                     ;3
       RTS                            ;6

LFC78:
       LDA    #$00                    ;2
       STA    $87                     ;3
       LDX    #$08                    ;2
LFC7E:
       ASL                            ;2
       ROL    $87                     ;5
       ASL    $81                     ;5
       BCC    LFC8C                   ;2
       CLC                            ;2
       ADC    $DA                     ;3
       BCC    LFC8C                   ;2
       INC    $87                     ;5
LFC8C:
       DEX                            ;2
       BNE    LFC7E                   ;2
       STA    $86                     ;3
       RTS                            ;6

LFC92:
       ASL    $D8                     ;5
       ROL    $D9                     ;5
       BPL    LFC9A                   ;2
       INC    $D8                     ;5
LFC9A:
       LDA    $D8                     ;3

       EOR    #$01                    ;2
       STA    $D8                     ;3
LFCA5:
       ORA    $D9                     ;3
       BNE    LFCAB                   ;2
       INC    $D8                     ;5
LFCAB:
       LDA    $D8                     ;3
       RTS                            ;6




;23
LFCAF:
;subtract missiles
       LDX    #$03                    ;2
LFCCX:
       LDA    $8A,X                   ;4
       BEQ    LFCCY                   ;2
       DEC    $8A,X                   ;6
       CLC                            ;2
       RTS                            ;2
LFCCY:
       DEX                            ;2
       BNE    LFCCX                   ;2
       LDA    #$E0                    ;2
       STA    $DE                     ;3
       STX    $DF                     ;3
       STX    $E0                     ;3
       SEC                            ;2
       RTS                            ;2













LFCCB:
       STA    $DA                     ;3
       LDX    #$05                    ;2
       LDA    $E7                     ;3
       CMP    #$0C                    ;2
       BCS    LFCD7                   ;2
       LSR                            ;2
       TAX                            ;2
LFCD7:
       STX    $82                     ;3
LFCD9:
       LDX    $F5                     ;3
       LDA    $DA                     ;3
       SED                            ;2
       CLC                            ;2
       ADC    $EF,X                   ;4
       STA    $EF,X                   ;4
       TYA                            ;2
       ADC    $F1,X                   ;4
       STA    $F1,X                   ;4
       LDA    #$00                    ;2
       ADC    $F3,X                   ;4
       STA    $F3,X                   ;4
       CLD                            ;2
       DEC    $82                     ;5
       BPL    LFCD9                   ;2
       RTS                            ;6

LFCF4:
       LDX    #$00                    ;2
       TXA                            ;2
LFCF7:
       LDY    $A9,X                   ;4
       SEC                            ;2
       CPY    #<CityGFX               ;2
       BEQ    LFCFF                   ;2
       CLC                            ;2
LFCFF:
       ROL                            ;2
       INX                            ;2
       INX                            ;2
       CPX    #$0C                    ;2
       BNE    LFCF7                   ;2
       LDX    $F5                     ;3
       STA    $EC,X                   ;4
LFD0A:
       LDX    #$FF                    ;2
       STX    $DE                     ;3
       INX                            ;2
       STX    $90                     ;3
       STX    $8E                     ;3
       STX    $E0                     ;3
       RTS                            ;6

LFD16:
       BIT    $F8                     ;3
       BMI    LFD3A                   ;2
       LDA    $EC                     ;3
       BNE    LFD63                   ;2
LFD1E:
       LDA    #$07                    ;2
       STA    $DF                     ;3
       LDX    #$FF                    ;2
       STX    $FB                     ;3

       LDX    #$0B                    ;2
TxtLoop:
       LDA    TxtTbl,X                ;4
       STA    $A9,X                   ;4
       DEX                            ;2
       BPL    TxtLoop                 ;2
       BMI    LFD0A                   ;2 always branch

LFD3A:
       LDX    $F5                     ;3
       LDA    $EC,X                   ;4
       BNE    LFD4D                   ;2
       TXA                            ;2
       EOR    #$01                    ;2
       TAX                            ;2
       LDA    $EC,X                   ;4
       BEQ    LFD1E                   ;2
       STX    $F5                     ;3
       BNE    LFD63                   ;2 always branch

LFD4D:
       TXA                            ;2
       EOR    #$01                    ;2
       TAX                            ;2
       LDA    $EC,X                   ;4
       BEQ    LFD5A                   ;2
       STX    $F5                     ;3
       BNE    LFD63                   ;2 always branch

;swap players
LFD5A:
       TXA                            ;2
       EOR    #$01                    ;2
       STA    $F5                     ;3
       TAX                            ;2
       BPL    LFD67                   ;2 always branch

LFD63:
       LDX    $F5                     ;3
       BNE    LFD7C                   ;2
LFD67:
       INC    $E7                     ;5
       LDA    $E7                     ;3
       CMP    #$10                    ;2
       BCS    LFD7C                   ;2
       LDA    $9B                     ;3
       CLC                            ;2
       ADC    #$08                    ;2
       BIT    $FB                     ;3
       BVS    LFD7A                   ;2
       ADC    #$05                    ;2
LFD7A:
       STA    $9B                     ;3
LFD7C:
       LDA    $EC,X                   ;4 EC/ED = bitpattern of each player's intact cities
       LDX    #$0A                    ;2
LFD80:
       LSR                            ;2
       LDY    #<CityGFX               ;2
       BCS    LFD88                   ;2
       LDY    #<RubbleGFX             ;2 load rubble


LFD88:
       STY    $A9,X                   ;4
       DEX                            ;2
       DEX                            ;2
       BPL    LFD80                   ;2
       RTS                            ;6





LFD96:
       LDX    $F5                     ;3
       LDA    $F3,X                   ;4
       CMP    $F6,X                   ;4
       BEQ    LFDDE                   ;2
       LDA    $EC,X                   ;4
       CMP    #$3F                    ;2
       BEQ    LFDDE                   ;2
       LDA    #$06                    ;2
       STA    $DF                     ;3
       LDA    #$A0                    ;2
       STA    $E0                     ;3
       LDA    $D8                     ;3
       AND    #$07                    ;2
       CMP    #$06                    ;2
       BCC    LFDB6                   ;2
       SBC    #$04                    ;2
LFDB6:
       TAY                            ;2
       LDA    LFE8E,Y                 ;4
       STA    $DA                     ;3
LFDBC:
       LDA    $DA                     ;3
       AND    $EC,X                   ;4
       BEQ    LFDCC                   ;2
       LSR    $DA                     ;5
       BCC    LFDBC                   ;2
       LDA    #$20                    ;2
       STA    $DA                     ;3
       BNE    LFDBC                   ;2
LFDCC:
       LDA    $EC,X                   ;4
       ORA    $DA                     ;3
       STA    $EC,X                   ;4
       LDA    $F6,X                   ;4
       SED                            ;2
       CLC                            ;2
       ADC    #$01                    ;2
       CLD                            ;2
       STA    $F6,X                   ;4
       JMP    LFD96                   ;3
LFDDE:
       RTS                            ;6



;17
GetDigit:
       TAX                            ;2
       LDA    Digit,X                 ;4
       STA.wy $C9,Y                   ;4
       LDX    $CC                     ;3
       LDA    #$FF                    ;2
       STA.wy $CA,Y                   ;4
       DEY                            ;2
       DEY                            ;2
TrailColor:
CacheColor:
       .byte $60 ; |        | $FEC6 shared (RTS)
       .byte $30 ; |        | $FEC6





       ORG $FDD8



LFDEE:
       .byte $00 ; |        | $FDEE
       .byte $01 ; |       X| $FDEF
       .byte $01 ; |       X| $FDF0
       .byte $02 ; |      X | $FDF1
       .byte $01 ; |       X| $FDF2
       .byte $00 ; |        | $FDF3
       .byte $02 ; |      X | $FDF4
       .byte $01 ; |       X| $FDF5
LFE7E: ;16
       .byte $00 ; |        | $FE7E shared
       .byte $00 ; |        | $FE7F
       .byte $00 ; |        | $FE80
       .byte $00 ; |        | $FE81
       .byte $00 ; |        | $FE82
       .byte $01 ; |       X| $FE83
       .byte $01 ; |       X| $FE84
       .byte $02 ; |      X | $FE85
       .byte $03 ; |      XX| $FE86
       .byte $04 ; |     X  | $FE87
       .byte $04 ; |     X  | $FE88
       .byte $05 ; |     X X| $FE89
       .byte $05 ; |     X X| $FE8A
       .byte $06 ; |     XX | $FE8B
       .byte $06 ; |     XX | $FE8C
       .byte $07 ; |     XXX| $FE8D



;explosion table
ExplosionAnim: ;16
       .byte <Explosion1 ; $FF00
       .byte <Explosion2 ; $FF01
       .byte <Explosion3 ; $FF02
       .byte <Explosion4 ; $FF03
       .byte <Explosion1 ; $FF04
       .byte <Explosion2 ; $FF05
       .byte <Explosion3 ; $FF06
       .byte <Explosion4 ; $FF07
       .byte <Explosion4 ; $FF08
       .byte <Explosion3 ; $FF09
       .byte <Explosion2 ; $FF0A
       .byte <Explosion1 ; $FF0B
       .byte <Explosion4 ; $FF0C
       .byte <Explosion3 ; $FF0D
       .byte <Explosion2 ; $FF0E
       .byte <Explosion1 ; $FF0F



       ORG $FE00


PlayerUp1:
       .byte %11000001 ; |XX     X| $FFB1
       .byte %11000001 ; |XX     X| $FF90
       .byte %11000001 ; |XX     X| $FF91
       .byte %11111001 ; |XXXXX  X| $FF92
       .byte %11001101 ; |XX  XX X| $FF93
       .byte %11001101 ; |XX  XX X| $FF94
       .byte %11111001 ; |XXXXX  X| $FF93

PlayerUp2:
       .byte %11110110 ; |XXXX XX | $FFB1
       .byte %10000110 ; |X    XX | $FF90
       .byte %10000111 ; |X    XXX| $FF91
       .byte %10000110 ; |X    XX | $FF92
       .byte %10000110 ; |X    XX | $FF93
       .byte %10000011 ; |X     XX| $FF94
       .byte %10000001 ; |X      X| $FF93

PlayerUp3:
       .byte %01100011 ; | XX   XX| $FFB1
       .byte %01100011 ; | XX   XX| $FF90
       .byte %11100011 ; |XXX   XX| $FF91
       .byte %01100111 ; | XX  XXX| $FF92
       .byte %01101100 ; | XX XX  | $FF93
       .byte %11001100 ; |XX  XX  | $FF94
       .byte %10001100 ; |X   XX  | $FF93



PlayerUp5:
       .byte %10110011 ; |X XX  XX| $FFB1
       .byte %00110011 ; |  XX  XX| $FF90
       .byte %00110011 ; |  XX  XX| $FF91
       .byte %00111110 ; |  XXXXX | $FF92
       .byte %00110011 ; |  XX  XX| $FF93
       .byte %00110011 ; |  XX  XX| $FF94
       .byte %10111110 ; |X XXXXX | $FF93




;28
PlayerUp4:
       .byte %00011111 ; |   XXXXX| $FFB1
       .byte %00011000 ; |   XX   | $FF90
       .byte %00011000 ; |   XX   | $FF91
       .byte %10011110 ; |X  XXXX | $FF92
       .byte %11011000 ; |XX XX   | $FF93
       .byte %11011000 ; |XX XX   | $FF94
TxtTbl:
       .byte <Txt1 ;shared %11011111 ; |XX XXXXX| $FF93
       .byte >Txt1
       .byte <Txt2
       .byte >Txt2
       .byte <Txt3
       .byte >Txt3
       .byte <Txt3
       .byte >Txt3
       .byte <Txt4
       .byte >Txt4
       .byte <Txt5
PlayerUpTxtTbl:
       .byte >Txt5 ;shared
       .byte <PlayerUp5
       .byte >PlayerUp5
       .byte <PlayerUp4
       .byte >PlayerUp4
       .byte <PlayerUp3
       .byte >PlayerUp3
       .byte <PlayerUp2
       .byte >PlayerUp2
       .byte <PlayerUp1
       .byte >PlayerUp1





LFE1E:
LFE1F = LFE1E+1
       .word LFE2A,LFE2B,LFE2D,LFE30,LFE32,LFE35




LFE59:
       .byte $0F ; |    XXXX| $FE59
       .byte $0C ; |    XX  | $FE5A
       .byte $0A ; |    X X | $FE5B
       .byte $08 ; |    X   | $FE5C
       .byte $0A ; |    X X | $FE5D
       .byte $08 ; |    X   | $FE5E
       .byte $08 ; |    X   | $FE5F
       .byte $06 ; |     XX | $FE60
       .byte $04 ; |     X  | $FE61
       .byte $04 ; |     X  | $FE62
       .byte $08 ; |    X   | $FE63
       .byte $08 ; |    X   | $FE64
       .byte $06 ; |     XX | $FE65
       .byte $04 ; |     X  | $FE66
       .byte $02 ; |      X | $FE67
       .byte $13 ; |   X  XX| $FE68
       .byte $14 ; |   X X  | $FE69
       .byte $15 ; |   X X X| $FE6A
       .byte $16 ; |   X XX | $FE6B


LFE6C: ;16
       .byte $0C ; |    XX  | $FE6C
       .byte $0F ; |    XXXX| $FE6D
       .byte $12 ; |   X  X | $FE6E
       .byte $0C ; |    XX  | $FE6F
       .byte $10 ; |   X    | $FE70
       .byte $0E ; |    XXX | $FE71
       .byte $11 ; |   X   X| $FE72
       .byte $0A ; |    X X | $FE73
       .byte $0D ; |    XX X| $FE74
       .byte $10 ; |   X    | $FE75
       .byte $13 ; |   X  XX| $FE76
       .byte $0C ; |    XX  | $FE77
       .byte $0E ; |    XXX | $FE78
       .byte $10 ; |   X    | $FE79
       .byte $12 ; |   X  X | $FE7A
       .byte $14 ; |   X X  | $FE7B



;41
LFE51: ;8
       .byte $0C ; |    XX  | $FE51
       .byte $0A ; |    X X | $FE52
       .byte $08 ; |    X   | $FE53
       .byte $06 ; |     XX | $FE54
       .byte $04 ; |     X  | $FE55
       .byte $02 ; |      X | $FE56
LFE94: ;24
       .byte $00 ; |        | $FE94 shared
       .byte $00 ; |        | $FE95 shared
       .byte $01 ; |       X| $FE96
       .byte $40 ; | X      | $FE97
       .byte $41 ; | X     X| $FE98
       .byte $06 ; |     XX | $FE99
       .byte $07 ; |     XXX| $FE9A
       .byte $46 ; | X   XX | $FE9B
       .byte $47 ; | X   XXX| $FE9C
       .byte $0A ; |    X X | $FE9D
       .byte $00 ; |        | $FE9E
       .byte $00 ; |        | $FE9F
       .byte $00 ; |        | $FEA0
       .byte $00 ; |        | $FEA1
       .byte $00 ; |        | $FEA2
       .byte $00 ; |        | $FEA3
       .byte $0B ; |    X XX| $FEA4
       .byte $4A ; | X  X X | $FEA5
       .byte $4B ; | X  X XX| $FEA6
       .byte $0E ; |    XXX | $FEA7
       .byte $0F ; |    XXXX| $FEA8
       .byte $4E ; | X  XXX | $FEA9
       .byte $4F ; | X  XXXX| $FEAA
LFEAB: ;5
       .byte $00 ; |        | $FEAB shared
LFEAC: ;5
       .byte $01 ; |       X| $FEAC shared
       .byte $80 ; |X       | $FEAD shared
       .byte $01 ; |       X| $FEAE shared
       .byte $80 ; |X       | $FEAF shared
LFDFD: ;7
       .byte $00 ; |        | $FDFD shared
       .byte $10 ; |   X    | $FDFE
       .byte $20 ; |  X     | $FDFF
       .byte $20 ; |  X     | $FE00
       .byte $40 ; | X      | $FE01
       .byte $00 ; |        | $FE02
       .byte $40 ; | X      | $FE03







LFE2A: ;28
       .byte $00 ; |        | $FE2A
LFE2B: ;28
       .byte $00 ; |        | $FE2B shared
       .byte $10 ; |   X    | $FE2C shared
LFE2D: ;28
       .byte $00 ; |        | $FE2D shared
       .byte $10 ; |   X    | $FE2E
       .byte $20 ; |  X     | $FE2F
LFE30: ;28
       .byte $00 ; |        | $FE30
       .byte $20 ; |  X     | $FE31
LFE32: ;28
       .byte $00 ; |        | $FE32 shared
       .byte $20 ; |  X     | $FE33
       .byte $40 ; | X      | $FE34
LFE35: ;28
       .byte $00 ; |        | $FE35
       .byte $40 ; | X      | $FE36
       .byte $FF ; |XXXXXXXX| $FE37
       .byte $00 ; |        | $FE38
       .byte $00 ; |        | $FE39
       .byte $01 ; |       X| $FE3A
       .byte $02 ; |      X | $FE3B
       .byte $01 ; |       X| $FE3C
       .byte $00 ; |        | $FE3D
       .byte $00 ; |        | $FE3E
       .byte $02 ; |      X | $FE3F
       .byte $04 ; |     X  | $FE40
       .byte $02 ; |      X | $FE41
       .byte $00 ; |        | $FE42
       .byte $00 ; |        | $FE43
       .byte $00 ; |        | $FE44
       .byte $10 ; |   X    | $FE45
       .byte $00 ; |        | $FE46
       .byte $10 ; |   X    | $FE47
       .byte $00 ; |        | $FE48
       .byte $00 ; |        | $FE49
       .byte $20 ; |  X     | $FE4A
       .byte $00 ; |        | $FE4B
       .byte $20 ; |  X     | $FE4C
       .byte $00 ; |        | $FE4D
       .byte $00 ; |        | $FE4E
       .byte $40 ; | X      | $FE4F
LFE15:
       .byte $00 ; |        | $FE15 shared
       .byte $00 ; |        | $FE16
       .byte $02 ; |      X | $FE17
LFE18: ;6
       .byte $06 ; |     XX | $FE18 shared
       .byte $08 ; |    X   | $FE19
       .byte $04 ; |     X  | $FE1A
       .byte $00 ; |        | $FE1B
       .byte $02 ; |      X | $FE1C
       .byte $0A ; |    X X | $FE1D







LFDDF: ;16
       .byte $01 ; |       X| $FDDF
       .byte $02 ; |      X | $FDE0
       .byte $03 ; |      XX| $FDE1
       .byte $04 ; |     X  | $FDE2
       .byte $02 ; |      X | $FDE3
       .byte $04 ; |     X  | $FDE4
       .byte $06 ; |     XX | $FDE5
       .byte $08 ; |    X   | $FDE6
       .byte $06 ; |     XX | $FDE7
       .byte $04 ; |     X  | $FDE8
       .byte $02 ; |      X | $FDE9
       .byte $04 ; |     X  | $FDEA
       .byte $03 ; |      XX| $FDEB
       .byte $02 ; |      X | $FDEC
       .byte $01 ; |       X| $FDED
LFE0D: ;8
       .byte $00 ; |        | $FE0D shared
       .byte $01 ; |       X| $FE0E
       .byte $02 ; |      X | $FE0F
       .byte $03 ; |      XX| $FE10
       .byte $04 ; |     X  | $FE11
       .byte $00 ; |        | $FE12
       .byte $06 ; |     XX | $FE13
       .byte $04 ; |     X  | $FE14
















LFDF6: ;7
       .byte $00 ; |        | $FDF6
       .byte $02 ; |      X | $FDF7
       .byte $06 ; |     XX | $FDF8
       .byte $04 ; |     X  | $FDF9
       .byte $0A ; |    X X | $FDFA
       .byte $00 ; |        | $FDFB
       .byte $08 ; |    X   | $FDFC



;19
;hill gfx
HillGFX:
       .byte %11100000 ; |XXX     | $FF7F
       .byte %11100000 ; |XXX     | $FF80
       .byte %11100000 ; |XXX     | $FF81
       .byte %11000000 ; |XX      | $FF82
       .byte %11000000 ; |XX      | $FF83
       .byte %11000000 ; |XX      | $FF84
       .byte %10000000 ; |X       | $FF85
       .byte %10000000 ; |X       | $FF86
;Cache GFX pointers (in page $FFxx)
CacheGFX:
       .byte <Count0  ; $FEE2 shared
       .byte <Count1  ; $FEE3
       .byte <Count2  ; $FEE4
       .byte <Count3  ; $FEE5
       .byte <Count4  ; $FEE6
       .byte <Count5  ; $FEE7
       .byte <Count6  ; $FEE8
       .byte <Count7  ; $FEE9
       .byte <Count8  ; $FEEA
       .byte <Count9  ; $FEEB
       .byte <Count10 ; $FEEC





;indirect jump point table
LF597:
LF598 = LF597+1
       .word LF655-1,LF63F-1,LF5F8-1,LF5E0-1,LF5C7-1,LF5CE-1,LF5A7-1,LF617-1




       ORG $FF00

CityGFX: ;must be @ $FF00
       .byte %11111111 ; |XXXXXXXX| $FF38
       .byte %11111111 ; |XXXXXXXX| $FF39
       .byte %11111111 ; |XXXXXXXX| $FF3A
       .byte %01111110 ; | XXXXXX | $FF3B
       .byte %01111110 ; | XXXXXX | $FF3C
       .byte %01110110 ; | XXX XX | $FF3D
       .byte %00110110 ; |  XX XX | $FF3E
       .byte %00100110 ; |  X  XX | $FF3F
       .byte %00100010 ; |  X   X | $FF40

Four:
       .byte %00000110 ; |     XX | $FFA4
       .byte %00000110 ; |     XX | $FFA5
       .byte %01111111 ; | XXXXXXX| $FFA6
       .byte %01100110 ; | XX  XX | $FFA7
       .byte %00110110 ; |  XX XX | $FFA8
       .byte %00011110 ; |   XXXX | $FFA9
       .byte %00001110 ; |    XXX | $FFAA

Zero: ;must be $FF10
       .byte %00111110 ; |  XXXXX | $FF88
       .byte %01100011 ; | XX   XX| $FF89
       .byte %01110011 ; | XXX  XX| $FF8A
       .byte %01101011 ; | XX X XX| $FF8B
       .byte %01100111 ; | XX  XXX| $FF8C
       .byte %01100011 ; | XX   XX| $FF8D
Eight:
       .byte %00111110 ; |  XXXXX | $FFC0 shared
       .byte %01100011 ; | XX   XX| $FFC1
       .byte %01100011 ; | XX   XX| $FFC2
       .byte %00111110 ; |  XXXXX | $FFC3
       .byte %01100011 ; | XX   XX| $FFC4
       .byte %01100011 ; | XX   XX| $FFC5
Six:
       .byte %00111110 ; |  XXXXX | $FFB2 shared
       .byte %01100011 ; | XX   XX| $FFB3
       .byte %01100011 ; | XX   XX| $FFB4
       .byte %01111110 ; | XXXXXX | $FFB5
       .byte %01100000 ; | XX     | $FFB6
       .byte %00110000 ; |  XX    | $FFC4
Nine:
       .byte %00011100 ; |   XXX  | $FFC7 shared
       .byte %00000110 ; |     XX | $FF9E
       .byte %00000011 ; |      XX| $FFC9
       .byte %00111111 ; |  XXXXXX| $FFCA
       .byte %01100011 ; | XX   XX| $FFCB
       .byte %01100011 ; | XX   XX| $FFCC
Five:
       .byte %00111110 ; |  XXXXX | $FFAB shared
       .byte %01100011 ; | XX   XX| $FFAC
       .byte %00000011 ; |      XX| $FFAD
       .byte %00000011 ; |      XX| $FFAE
       .byte %01111110 ; | XXXXXX | $FFAF
       .byte %01100000 ; | XX     | $FFB0
One:  
       .byte %01111110 ; | XXXXXX | $FFB1 shared
       .byte %00011000 ; |   XX   | $FF90
       .byte %00011000 ; |   XX   | $FF91
       .byte %00011000 ; |   XX   | $FF92
       .byte %00011000 ; |   XX   | $FF93
       .byte %00111000 ; |  XXX   | $FF94
Seven:
       .byte %00011000 ; |   XX   | $FFB9 shared
       .byte %00011000 ; |   XX   | $FFBA
       .byte %00011000 ; |   XX   | $FFBB
       .byte %00001100 ; |    XX  | $FFBC
       .byte %00000110 ; |     XX | $FFBD
       .byte %01100011 ; | XX   XX| $FFBE
Two:
       .byte %01111111 ; | XXXXXXX| $FF96 shared
       .byte %01110000 ; | XXX    | $FF97
       .byte %00111100 ; |  XXXX  | $FF98
       .byte %00011110 ; |   XXXX | $FF99
       .byte %00000111 ; |     XXX| $FF9A
       .byte %01100011 ; | XX   XX| $FF9B
Three:
       .byte %00111110 ; |  XXXXX | $FF9D shared
       .byte %01100011 ; | XX   XX| $FF9E
       .byte %00000011 ; |      XX| $FF9F
       .byte %00011110 ; |   XXXX | $FFA0
       .byte %00001100 ; |    XX  | $FFA1
       .byte %00000110 ; |     XX | $FFA2
       .byte %00111111 ; |  XXXXXX| $FF96


;COLOR:
Count10:
       .byte %10101010 ; |X X X X | $FFCE
       .byte %01010100 ; | X X X  | $FFCF
       .byte %00101000 ; |  X X   | $FFD0
       .byte %00010000 ; |   X    | $FFD1


;each bitmap must be 9 bytes spaced evenly
Nuke:
       .byte %11111111 ; |XXXXXXXX| $FF4C
       .byte %11111111 ; |XXXXXXXX| $FF4D
       .byte %11111111 ; |XXXXXXXX| $FF4E
       .byte %01111110 ; | XXXXXX | $FF4F
       .byte %11111111 ; |XXXXXXXX| $FF50
       .byte %11111111 ; |XXXXXXXX| $FF51
       .byte %01111110 ; | XXXXXX | $FF52
       .byte %01111110 ; | XXXXXX | $FF53
Count6:
       .byte %00000000 ; |        | $FFDE shared
       .byte %01010100 ; | X X X  | $FFDF
       .byte %00101000 ; |  X X   | $FFE0
       .byte %00010000 ; |   X    | $FFE1


       .byte %11111111 ; |XXXXXXXX| $FF55
       .byte %11111111 ; |XXXXXXXX| $FF56
       .byte %00111100 ; |  XXXX  | $FF57
       .byte %00111100 ; |  XXXX  | $FF58
       .byte %11111111 ; |XXXXXXXX| $FF59
       .byte %11111111 ; |XXXXXXXX| $FF5A
       .byte %01111110 ; | XXXXXX | $FF5B
       .byte %00000000 ; |        | $FF5C
Count5:
       .byte %00000000 ; |        | $FFE2 shared
       .byte %01010000 ; | X X    | $FFE3
       .byte %00101000 ; |  X X   | $FFE4
       .byte %00010000 ; |   X    | $FFE5


       .byte %11111111 ; |XXXXXXXX| $FF5E
       .byte %00011000 ; |   XX   | $FF5F
       .byte %00011000 ; |   XX   | $FF60
       .byte %00011000 ; |   XX   | $FF61
       .byte %11011011 ; |XX XX XX| $FF62
       .byte %11111111 ; |XXXXXXXX| $FF63
       .byte %11111111 ; |XXXXXXXX| $FF64
       .byte %01111110 ; | XXXXXX | $FF65
Count4:
       .byte %00000000 ; |        | $FFE6 shared
       .byte %01000000 ; | X      | $FFE7
       .byte %00101000 ; |  X X   | $FFE8
       .byte %00010000 ; |   X    | $FFE9


       .byte %11111111 ; |XXXXXXXX| $FF67
       .byte %00011000 ; |   XX   | $FF68
       .byte %00011000 ; |   XX   | $FF69
       .byte %00011000 ; |   XX   | $FF6A
       .byte %00011000 ; |   XX   | $FF6B
       .byte %00000000 ; |        | $FF6C
       .byte %10000001 ; |X      X| $FF6D
       .byte %11000011 ; |XX    XX| $FF6E
       .byte %01111110 ; | XXXXXX | $FF6F


StartTbl: ;3
       .byte $99 ; | X X    | $FE0B silo
       .byte $05 ; |     XX | $FE18 shared
       .byte $4F ; | X X    | $FE0C silo


RubbleGFX:
       .byte %11111111 ; |XXXXXXXX| $FF70
       .byte %01101101 ; | XX XX X| $FF71
Blank:
       .byte %00000000 ; |        | $FF30 shared
       .byte %00000000 ; |        | $FF31 shared
       .byte %00000000 ; |        | $FF32 shared
       ORG $FF80
Count0: ;must be @$FF80
       .byte %00000000 ; |        | $FF33 shared x2
       .byte %00000000 ; |        | $FF34 shared x2
Explosion1:
       .byte %00000000 ; |        | $FF10 shared x3
       .byte %00000000 ; |        | $FF11 shared x3
       .byte %00000000 ; |        | $FF12 shared x2
       .byte %00011000 ; |   XX   | $FF13
       .byte %00011000 ; |   XX   | $FF14
Count1:
       .byte %00000000 ; |        | $FFF2 shared
       .byte %00000000 ; |        | $FFF3 shared
       .byte %00000000 ; |        | $FFF4 shared
;digit GFX pointers (in page $FFxx)
Digit:
       .byte <Zero  ; $FEED shared (Tag <Zero = %00010000)
       .byte <One   ; $FEEE
       .byte <Two   ; $FEEF
       .byte <Three ; $FEF0
       .byte <Four  ; $FEF1
       .byte <Five  ; $FEF2
       .byte <Six   ; $FEF3
       .byte <Seven ; $FEF4
       .byte <Eight ; $FEF5
       .byte <Nine  ; $FEF6





Explosion4:
       .byte %00011000 ; |   XX   | $FF28
       .byte %00111100 ; |  XXXX  | $FF29
       .byte %01111110 ; | XXXXXX | $FF2A
       .byte %11111111 ; |XXXXXXXX| $FF2B
       .byte %11111111 ; |XXXXXXXX| $FF2C
       .byte %01111110 ; | XXXXXX | $FF2D
       .byte %00111100 ; |  XXXX  | $FF2E
;missile targets
TargetTbl:
       .byte $18 ; |   XX   | $FE05 city1 shared
       .byte $28 ; |  X X   | $FE06 city2
       .byte $38 ; |  XXX   | $FE07 city3
       .byte $6A ; | XX X X | $FE08 city4
       .byte $7A ; | XXXX X | $FE09 city5
       .byte $8A ; |X   X X | $FE0A city6
       .byte $9A ; | X X    | $FE0B silo
       .byte $50 ; | X X    | $FE0C silo
Count7:
       .byte %00001000 ; |  X     | $FFDA shared
       .byte %01010100 ; | X X X  | $FFDB
       .byte %00101000 ; |  X X   | $FFDC
       .byte %00010000 ; |   X    | $FFDD



Count8:
       .byte %00101000 ; |  X X   | $FFD6
       .byte %01010100 ; | X X X  | $FFD7
       .byte %00101000 ; |  X X   | $FFD8
       .byte %00010000 ; |   X    | $FFD9



Count9:
       .byte %10101000 ; |X X X   | $FFD2
       .byte %01010100 ; | X X X  | $FFD3
       .byte %00101000 ; |  X X   | $FFD4
       .byte %00010000 ; |   X    | $FFD5




Explosion2:
       .byte %00000000 ; |        | $FF18
       .byte %00000000 ; |        | $FF19
       .byte %00011000 ; |   XX   | $FF1A
       .byte %00111100 ; |  XXXX  | $FF1B
       .byte %00111100 ; |  XXXX  | $FF1C
       .byte %00011000 ; |   XX   | $FF1D
Count2:
       .byte %00000000 ; |        | $FFEE shared
       .byte %00000000 ; |        | $FFEF shared
LFE8E:
       .byte %00100000 ; |  X     | $FE8E shared
       .byte %00010000 ; |   X    | $FE8F shared
       .byte $08 ; |    X   | $FE90
       .byte $04 ; |     X  | $FE91
LF68A:
       .byte $02 ; |      X | $F68A shared
       .byte $04 ; |     X  | $F68B
       .byte $06 ; |     XX | $F68C
       .byte $08 ; |    X   | $F68D
       .byte $0E ; |    XXX | $F68E



Txt3:
       .byte %00000000 ; |        | $FEFD
       .byte %01111110 ; | XXXXXX | $FEFC
       .byte %01100000 ; | XX     | $FEFC
       .byte %01100000 ; | XX     | $FEFC
       .byte %01111000 ; | XXXX   | $FEFC
       .byte %01100000 ; | XX     | $FEFC
       .byte %01100000 ; | XX     | $FEFC
       .byte %01111110 ; | XXXXXX | $FEFC
Txt2:
       .byte %00000000 ; |        | $FEFD shared
       .byte %01100110 ; | XX  XX | $FEFE
       .byte %01100110 ; | XX  XX | $FEFE
       .byte %01100110 ; | XX  XX | $FEFE
       .byte %01111110 ; | XXXXXX | $FEFF
       .byte %01100110 ; | XX  XX | $FEFE
       .byte %01100110 ; | XX  XX | $FEFE
       .byte %01100110 ; | XX  XX | $FEFA
Txt4:
       .byte %00000000 ; |        | $FEFD shared
       .byte %01100110 ; | XX  XX | $FEFC
       .byte %01100110 ; | XX  XX | $FEFC
       .byte %01100110 ; | XX  XX | $FEFC
       .byte %01101110 ; | XX XXX | $FEFC
       .byte %01111110 ; | XXXXXX | $FEFC
       .byte %01110110 ; | XXX XX | $FEFC
       .byte %01100110 ; | XX  XX | $FEFC
Explosion3:
       .byte %00000000 ; |        | $FF20 shared
       .byte %00011000 ; |   XX   | $FF21
       .byte %00111100 ; |  XXXX  | $FF22
       .byte %01111110 ; | XXXXXX | $FF23
       .byte %01111110 ; | XXXXXX | $FF24
       .byte %00111100 ; |  XXXX  | $FF25
       .byte %00011000 ; |   XX   | $FF26
       ORG $FFDF
Txt1: ;must be @$FFDF
       .byte %00000000 ; |        | $FE57 shared
       .byte %00011000 ; |   XX   | $FEFD
       .byte %00011000 ; |   XX   | $FEFD
       .byte %00011000 ; |   XX   | $FEFD
       .byte %00011000 ; |   XX   | $FEFD
       .byte %00011000 ; |   XX   | $FEFD
       .byte %00011000 ; |   XX   | $FEFD
       .byte %01111110 ; | XXXXXX | $FEFE
Txt5:
       .byte %00000000 ; |        | $FEFD shared
       .byte %01111100 ; | XXXXX  | $FEFC
       .byte %01100110 ; | XX  XX | $FEFC
       .byte %01100110 ; | XX  XX | $FEFC
       .byte %01100110 ; | XX  XX | $FEFC
       .byte %01100110 ; | XX  XX | $FEFC
       .byte %01100110 ; | XX  XX | $FEFC
       .byte %01111100 ; | XXXXX  | $FEFC
Count3:
       .byte %00000000 ; |        | $FFEA shared
       .byte %00000000 ; |        | $FFEB
       .byte %00101000 ; |  X X   | $FFEC
       .byte %00010000 ; |   X    | $FFED



ScoreColor:
       .byte $D0 ; |        | $FEC6
       .byte $30 ; |        | $FEC6
       .byte $80 ; |        | $FEC6
CityColor:
       .byte $D0 ; |        | $FEC6 shared
       .byte $80 ; |        | $FEC6


;free (supercharger)
       .byte $06
       .byte $24

;system vectors
       ORG $FFFA
       .word 0,START,0
