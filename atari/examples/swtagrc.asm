    LIST OFF
    PROCESSOR 6502
    include vcs.h

; TIA EQUATES
HSYNC     =       WSYNC
VBLNK     =       VBLANK
P0SIZE    =       NUSIZ0
P1SIZE    =       NUSIZ1
P0CLR     =       COLUP0
P1CLR     =       COLUP1
PFCLR     =       COLUPF
BKCLR     =       COLUBK
PFCTRL    =       CTRLPF
P0REF     =       REFP0
P1REF     =       REFP1
P0RES     =       RESP0
P1RES     =       RESP1
M0RES     =       RESM0
M1RES     =       RESM1
SNDC0     =       AUDC0
SNDC1     =       AUDC1
SNDF0     =       AUDF0
SNDF1     =       AUDF1
SNDV0     =       AUDV0
SNDV1     =       AUDV1
P0GR      =       GRP0
P1GR      =       GRP1
M0GR      =       ENAM0
M1GR      =       ENAM1
BGR       =       ENABL
P0HM      =       HMP0
P1HM      =       HMP1
M0HM      =       HMM0
M1HM      =       HMM1
BHM       =       HMBL
P0VDEL    =       VDELP0
P1VDEL    =       VDELP1
HMOV      =       HMOVE
CLRHM     =       HMCLR

TRIG0     =       INPT4
PLRCTL    =       SWCHA
FPCTL     =       SWCHB


TIMOUT    =       TIMINT
TIMD64    =       TIM64T

   LIST ON

  MAC NOTE
          .byte      {1}*$80 + {2}*4 + {3}
  ENDM

  MAC BOUNDRY
    REPEAT 256
      IF  (<. % {1}) = 0
        MEXIT
      ENDIF
          .byte      0
    REPEND
  ENDM


;=======================================
;         PRINT   ALL
;
; VCS     SWARS
;
; NOVEMBER 1, 1983
;
;04/06    NTSC    RELEASE
;04/10    PAL
;
PAL       EQU     0
EPROM     EQU     1
RELEASE   EQU     1
TEST      EQU     0                      ;CONDITIONAL FOR B/W PAUSE
MIDY      EQU     116/2
MIDYA     EQU     (116/2)+ 8
MIDYB     EQU     (116/2)- 8
LEGUN     EQU     $18
RIGUN     EQU     159-$18
MAXDX     EQU     $0F                    ;MAX  DELTA X
MAXDY     EQU     $1F
MAXCHDX   EQU     $2F                    ;MAX CROSS HAIR DELTA X
MAXCHDY   EQU     $2F
MAXTOWDX  EQU     $08                    ;MAXIMUM TOWER DELTA X
;
MIDX      EQU     79
NUTOWERS  EQU     $10                    ;NUMBER OF TOWERS TO WITH CAPS
EXHAUST   EQU     $C4
STATIC    EQU     1                      ;IF SET, DONT MOVE CROSS DURING SHOT
;         PRINT ON
;
;         RAM ALLOCATION
;
;=======================================
          SEG.U variables
;=======================================
          ORG     $80
FRAME     DS      2                      ; 16 BIT FRAME COUNTER
SCREEN:   DS      1                      ;0=SPACE 1=TOWER 2=TRENCH D7=STICK BNC
DEBOUNCE: DS      1                      ;D7= BUTTON DEBOUNCE
SUPRESS: DS      1                      ;D6=ATTRACT D7=SUSPEND ACTION
SHADOW:   DS      1                      ;SHADOW GATE
WAVENO:   DS      1
RAND:     DS      1
RANDH:    DS      1
XWY:                                     ;XWING Y POSITION
STAR2MOV: DS      1
BLOCK:    DS      1                      ;POINT TO BLOCK OF PATTERNS
PNT:      DS      1                      ;POINT TO CURRENT PATTERN
;
; KERNEL RAM
;
P0Y       DS      1                      ;LINE NUMBER FOR PLAYER 0
P1Y       DS      1
SIZE0     DS      1                      ;HEIGHT OF PLAYER 0
SIZE1     DS      1                      ;HEIGHT OF PLAYER 1
P0GX      DS      2                      ;INDIR FOR P0
P1GX      DS      2                      ;INDIR FOR P1
M1Y       DS      1                      ;YPOS FOR MISSILE
BASE      DS      2                      ;POINTER TO PATTERN
ST1Y:     DS      1
ST2Y:     DS      1
;MAP THESE OVER STARS
EXIT      DS      1
T10:      DS      1
T11:      DS      1
;
; POSITIONS
;
CHAIRX:   DS      1                      ;CROSSHAIR X
ZSTART:                                  ;ZEROING POINTER
LAZAX:    DS      1                      ;LEFT LASER X POS
LAZBX:    DS      1                      ;RIGHT LASER
OBJAX:    DS      1                      ;PLAYER A
OBJBX:    DS      1                      ;B
OBJCX:    DS      1
ZEND:
OBJDX:    DS      1
T9:
STARAX:   DS      1                      ;STAR XPOS
XWX:                                     ;XWING POS
STARBX:   DS      1
TX:
STARCX:   DS      1
TY:
STARDX:   DS      1
TZ:
STAREX:   DS      1                      ;STAR XPOS
T12:
STARFX:   DS      1
VERTOFF:                                 ;X OFFSET OF TRENCH VERTICAL
STARGX:   DS      1
TFFA:
STARHX:   DS      1
;
CHAIRY:   DS      1                      ;CROSSHAIR Y POS
LAZY:     DS      1                      ;LASER Y
KILL      DS      1
OBJAY:    DS      1                      ;PLAYER A
OBJBY:    DS      1                      ;B
OBJCY:    DS      1
OBJDY:    DS      1
HMTAB:                                   ;POINTER TO HMOV  TABLE
STARAY:   DS      1                      ;STAR XPOS
STARBY:   DS      1
HMTAB1:                                  ;POINTER TO HMOV  TABLE
STARCY:   DS      1
STARDY:   DS      1
TUNPNT:                                  ;TOP INDEX OF HMOV
STAREY:   DS      1                      ;STAR XPOS
TUNPNT1:                                 ;INDEX TO HMOV
STARFY:   DS      1
TRIG:                                    ;TOP OF TRENCH VERICAL
STARGY:   DS      1
TRIGA:                                   ;BOTTOM OF TRENCH VERTICAL
STARHY:   DS      1
;
;DELTAS
;
CHAIRDX:  DS      1                      ;CROSSHAIR DX
LAZADX:   DS      1                      ;LEFT LASER
LAZBDX:   DS      1                      ;RIGHT LASER
OBJADX:   DS      1                      ;PLAYER A
OBJBDX:   DS      1                      ;B
OBJCDX:   DS      1
OBJDDX:   DS      1
;
CHAIRDY:  DS      1                      ;CROSS HAIR DY
LAZDY:    DS      1                      ;LASER DY
KILL1:    DS      1
OBJADY:   DS      1                      ;PLAYER A
OBJBDY:   DS      1                      ;B
OBJCDY:   DS      1
OBJDDY:   DS      1
;
; CATWALK OFFSETS
;
CATAX:    DS      1                      ;0-F LEGAL
CATBX:    DS      1
CATCX:    DS      1
CATDX:    DS      1
; ******** SOUND RAM *********
SCHAN1    DS      1                      ; POINTER TO SFX ROUTINE OR TUNE
SCHAN2    DS      1
STIM1     DS      1                      ; TIMER FOR EACH CHANNEL
STIM2     DS      1
;
; ID BYTES
;
;         CATWALK IDENTITIES
;         D0-D1   VERTICAL LANE          0-3
;         D2 = 1  FULL WIDTH
;         D3 = 1  RIGHT HALF
;         D4 = 1  2 HIGH
;
OBJAID:   DS      1
OBJBID:   DS      1
OBJCID:   DS      1
OBJDID:   DS      1
;
SCOREH:   DS      1                      ; HI SCORE
SCOREM:   DS      1
SCOREL:   DS      1
TOWSCH:                                  ; TOWER SCORE
ADDSCL:   DS      1
ADDSCM:
TOWSCL:   DS      1
TOWCNT:   DS      1                      ; TOWER COUNT
VEERDX:   DS      1
ZEND1:                                   ;GAME START ZEROING LIMIT
VEERDY:   DS      1
LAZHM:    DS      1                      ;LASER HMOVES
;
SCORE0    DS      2                      ;SIXVHAR INDIRECTION
SCORE1:   DS      2
SCORE2:   DS      2
SCORE3:   DS      2
SCORE4:   DS      2
SCORE5:   DS      2
TFF:      DS      1                      ;TEMPS
NOTE:                                    ;TEMP FOR SOUND ROUTINE
T0:       DS      1
T1:       DS      1
T2:       DS      1
T3:       DS      1
T4:       DS      1
T5:       DS      1
T6:       DS      1
T7:       DS      1
T8:       DS      1
COLORTIM: DS      1                      ;TIMER FOR SCREEN FLASH
SHIELDS:  DS      1                      ;NUMBER OF SHIELDS
DARTH:    DS      1                      ;DARTH ON = FF
TIME      DS      1
;LAZKILL:  DS      1                      ;YPOS FOR LAZER DEATH
THEFORCE: DS      1                      ;DONT USE THE FORCE; STACK!
                                         ;ALSO USED AS DEATH STAR TIMER
;
;
;=======================================
          SEG     CODE
;=======================================
          ORG     $1000
;
;         SYNCH FOR NEW FRAME
;
SCRNTOP
          LDX     #2                     ; VBLANK  ON (BIT 1)
          STX     VBLNK
          STX     HSYNC                  ; AND SYNCH FOR 3 LINES
          STX     VSYNC
          LDA     STIM1                  ;TURN OFF D7 OF SUPRESS IF SOUND OFF

          ORA     STIM1
          BNE     SK49
          ROL     SUPRESS
          CLC
          ROR     SUPRESS
SK49
          STX     HSYNC
          JSR     RANDOM
          STX     HSYNC
          LDA     #0
          STA     P0SIZE
          LDA     COLORTIM               ;DECREMENT FLASH TIMER
          BEQ     SK76
          DEC     COLORTIM
SK76      ASL
          ASL
          ASL
          ASL
          STA     BKCLR
          STX     HSYNC
          DEX                            ; OFF BIT 1 (THIS SAVES 1 BYTE)
          STX     VSYNC                  ; OFF GOES SYNC
          LDA     #$2C                   ; TIMER
          STA     TIMD64
;
; SOUND ROUTINES START HERE
;
; * INPUT: SOUND TO CALL IN ACC
; * FORMAT:
; * TO CALL ROBOT SOUND, DO:
; *       LDA     #<(ROBOT-1)
; *       JSR     SNDINI
; * TO START TUNE3B, DO:
; *       LDA     #<($80+TUNE3B-TUNE)
; *       JSR     SNDINI
; * PRIORITY IS INHERENT:  THE LOWER # SOUNDS HAVE HIGHER PRIORIY
; * WITH THE TUNES HAVING LOWER PRIORITY THAN SOUNDS.
; * RAM NEEDED:  4 BYTES CONSECUTIVE PERMANENT RAM
; *              1 BYTE  TEMP RAM
; * SNDMGR MUST BE CALLED EVERY FRAME TO EXECUTE SOUNDS
; *
;
SNDMGR
          LDX     #2
SOUND
          DEX                            ; TEST NEXT CHANNEL
          BMI     RETURN1                ; NO MORE CHANNELS
          LDY     SCHAN1,X               ; LOOK AT POINTER TO ROUTINE/TABLE
          BEQ     SOUND                  ; NO REQUEST IF 0
          BMI     PYTUNE                 ; BIT 7 --> PLAY TUNE
          DEC     STIM1,X                ; COUNT TIMER TICK
          LDY     STIM1,X                ; GET TIMER INTO Y
          BNE     SND1                   ; KEEP GOING IF NOT 0
SNDKILL   LDY     #0                     ; REDUNDANCY NEEDED FOR OTHER ENTRYPT
          STY     SCHAN1,X               ; ZAP SOUND REQUEST
          STY     SNDV0,X                ; ZAP VOLUME ON THIS CHANNEL
          BEQ     SOUND

SND1
          LDA     #>(SOUND)
          PHA
          LDA     SCHAN1,X               ; GET LOW BYTE
          PHA
          LDA     STIM1,X                ; SET UP ACC FOR HANDLER CALL
          RTS                            ; BRANCH TO HANDLER
ROBOT
          LSR
          LSR
          EOR     #6                     ; R2D2 SOUND
          LDY     #4
          BPL     SNDX
SHOT
          LSR
          LSR
          LDY     #8
          BPL     SNDX
EXPLO:
          TAY
          LSR
          STA     SNDV0,X
          TYA
          EOR     #$1F
          LDY     #$1
          BNE     SNDX
SSST:     TYA
          LSR
          LSR
          STA     SNDV0,X
          TYA
          LDY     #8
SNDX
          STA     SNDF0,X                ; STORE FREQUENCY
          STY     SNDC0,X                ; STORE SOUND CONTROL BYTE
          BPL     SOUND
PYTUNE
          DEC     STIM1,X                ; COUNT NEXT 1/60TH SEC
          BEQ     PT1                    ; TIMED OUT -- GRAB NEXT NOTE
          TXA
          BEQ     SOUND                  ; ONLY DO FOR CHAN. 2
          LDA     STIM1,X
          LSR
          LSR
          STA     SNDV0,X                ; SAVE TIMER AS ATTENUATION
          BPL     SOUND
PT1
; NOTES STORED THUSLY
;         C X X X X X D D
;         C = CONTROL BIT ($C OR $4)
;         X = FREQ
;         D = DURATION
;
          INC     SCHAN1,X               ; POINT TO NEXT NOTE!
          LDA     TUNE-$80,Y             ; GET NEXT NOTE OF TUNE
          STA     NOTE
          BEQ     SNDKILL                ; END OF TUNE
          AND     #3                     ; ISOLATE DURATION CODE
          TAY
          LDA     DUR,Y                  ; GET DURATION
          STA     STIM1,X                ; SAVE INTO TIMER RAM
          LDY     #4                     ; SOUND CONTROL 4
          LDA     NOTE                   ; GET NOTE
          BMI     PT3                    ; BIT 7 1 --> OK
          LDY     #$C                    ; BIT 7 0 --> SOUND CONTROL $C
PT3
          LSR
          LSR                      ; SHIFT INTO CORRECT SPACE
          BPL     SNDX                   ; EXIT
;
RETURN1:
          JMP     TOLASER                ;FIRE LASER ? (THROUGH BANK 7)
RETLASER:
;
; TIME DEATH STAR EXPLOSION
;
          LDA     THEFORCE
          BMI     OUT11
          BEQ     OUT11
          TAX
          DEX
          STX     THEFORCE
          CPX     #$48
          BNE     SK68
;START EXPLOSION

          LDA     #(EXP0 & $FF)/4
          STA     OBJAID
          STA     OBJBID
          STA     OBJCID
          STA     OBJDID
          LDA     #$-02
          STA     OBJADX
          STA     OBJCDY
          STA     OBJDDY
          STA     OBJCDX
          LDA     #$02
          STA     OBJBDY
          STA     OBJBDX
          STA     OBJDDX
          STA     OBJADY
          LDA     #<(SHOT-1)
          JSR     SNDINI
          JMP     OUT11
SK68:
          CPX     #$20
          BNE     SK69
          LDA     #($80+TUNE1A-TUNE)
          STA     SUPRESS
          JSR     SNDINI
          LDA     #($80+TUNE1B-TUNE)
          JSR     SNDINI
          JMP     OUT11
SK69:
          CPX     #$40
          BNE     OUT11
          STX     COLORTIM
          DEC     VEERDY
          LDA     #<(SHOT-1)
          JSR     SNDINI
OUT11:
;
; GAME START
;
          LDA     FPCTL                  ;DO SET = RELEASED
          AND     #$1
          BEQ     PRESSED
          STA     SHADOW
          BNE     SK51
PRESSED:  LDA     SHADOW
          AND     #$1
          BNE     GMSTART                ;WAS RELEASED
          STA     SHADOW                 ;STORE 0
          BEQ     SK51
GMSTART:
          LDX     #ZEND1-ZSTART
          LDA     #0
          STA     SHADOW
ZLOOP2:
          STA     ZSTART,X
          DEX
          BPL     ZLOOP2
          LDA     #($80+TUNE1A-TUNE)
          STA     SUPRESS               ;STOP LAUNCH TIL TUNE OVER
          JSR     SNDINI
          LDA     #($80+TUNE1B-TUNE)
          JSR     SNDINI
          LDA     #MIDY
          STA     CHAIRY
          LDA     #0
          STA     THEFORCE
          STA     FRAME
          STA     FRAME+1
          STA     SCREEN
          LDA     #$8
          STA     SHIELDS
          LDA     #$AA
          STA     TOWCNT
          STA     TOWSCL
          STA     TOWSCH
          LDY     #0
          BIT     FPCTL                  ;CHOOSE WAVE TO START ON
          BVC     SK67
          LDY     #2
SK67:     STY     WAVENO
SK51:
          JSR     STICK
;
; LAUNCH DEATHSTAR ON TIE SCREEN
;

          LDA     FRAME
          CMP     #$80
          BNE     OUT12
          LDA     FRAME+1
          EOR     #7                     ;FRAME+1 = 7
          ORA     SCREEN
          ORA     SUPRESS
          BNE     OUT12
;DO LAUNCH
          TAX                            ;A=0
          STX     OBJADY
          STX     VEERDY
          INX
          STX     VEERDX
          STX     OBJAX
          LDA     #(STAR0 & $FF)/4
          STA     OBJAID
          LDA     #MIDY
          STA     OBJAY
          LDA     #5
          STA     OBJADX
          INX                            ;X=2
          LDA     #$8
ACCLOOP:
          STA     OBJBDX,X
          DEX
          BPL     ACCLOOP
OUT12:
;
;         VBLANK LOGIC
;
          INC     FRAME                  ; LOW FRAME INC
          BNE     NOINC                  ; BRANCH IF NO HIGH INC
;
;
;         CHECK HI FRAME FOR SCREEN TIME LENGTH
;
          INC     FRAME+1                ; HIGH FRAME INC
          LDA     FRAME+1
          AND     #$7
          ORA     SCREEN
          ORA     SUPRESS               ;SUPRESS STOPS CHANGE
          BNE     NOCHECK
;CHANGE SPACE TO TOWERS
CHSPACE:  INC     SCREEN
          JSR     ZOBJECTS
          LDX     #7
LOOP1000: STA     STARAX,X
          DEX
          BPL     LOOP1000
          LDA     #NUTOWERS              ;GET NUMBER OF TOWERS
          STA     TOWCNT
          LDA     #$2
          STA     TOWSCH
          LDX     #0
          STX     DARTH                  ;!!! DIFFERENCE !!!
          STX     FRAME
          STX     FRAME+1
          STX     TOWSCL
          STX     BLOCK
          STX     PNT
          LDA     WAVENO
          ASL
          ASL
          EOR     BLOCK
          AND     #$FC
          EOR     BLOCK
          TAY
          LDA     BLOCKS,Y
          STA     BASE
NOCHECK:
NOINC:
;
; GAME END
;
          LDX     COLORTIM               ;FLASH TIMED OUT ?
          BNE     NOTEND
;
;
; TO STOP DEATH, INSERT TWO NOPS HERE
;
;
NODEATH:
          LDA     SHIELDS
          BPL     NOTEND
          LDA     #$C0
          STA     SUPRESS
          STX     VEERDX
          STX     SHIELDS
          STX     SCREEN
          STX     SCHAN1
          STX     SCHAN2
          JSR     ZOBJECTS
          LDX     #3
ZLOOPTOO: STA     CATAX,X
          STA     OBJAID,X
          DEX
          BPL     ZLOOPTOO
          LDA     #($80+TUNE2A-TUNE)
          JSR     SNDINI
          LDA     #($80+TUNE2B-TUNE)
          JSR     SNDINI
NOTEND:
          STA     CLRHM
;
; DO INTELLIGENCES
;
          LDY     SCREEN
          DEY
          BPL     NOTIEINT
          JSR     TIEINT
          JMP     OUT13
NOTIEINT: DEY
          BPL     NOTOWINT
          JMP     TOTOWINT                ;JSR THROUGH BANK 7 (3C00)
NOTOWINT: JMP     TOCATLCH               ;LAUNCH CATS ON BANK 3
OUT13:
;
; FORCE TIE IDS ACCORDING TO DELTAS
;
          LDX     #3
FORECLP:  LDA     OBJAID,X
          CMP     #(DARTHE & $FF)/4
          BCC     DOTIE
          CMP     #(FB0 & $FF)/4
          BCS     NOTEXPLO
          CMP     #(EXP0 & $FF)/4
          BCC     TONXTFOR
; ANIMATE EXPLOSION
          TAY
          LDA     FRAME
          AND     #$07
          BNE     NXTFORCE
          INY
          CPY     #(EXPE & $FF)/4        ;END OF SEQUENCE
          BCC     GOTPIC1                ;GO WITH IT
          BCS     KILLEXP                ;EXPLOSION OVER
NOTEXPLO: CMP     #(FBE & $FF)/4
          BCS     NXTFORCE
; MAKE FIREBALLS LARGER
DOFB:     TAY
          LDA     FRAME
          AND     #$3F
TONXTFOR: BNE     NXTFORCE
          INY                            ;BUMP ID
; CHANGE VERT POSITION TO KEEP FB CENTERED
          LDA     OBJAY,X
          SEC
          SBC     FBVERT-19,Y
          STA     OBJAY,X
          CPY     #(FBE & $FF)/4
          BCC     GOTPIC1
;KILL FIREBALL
          LDA     OBJAX,X
          SBC     #MIDX-$30
          CMP     #$60
          BCS     KILLEXP
          STX     T1
          JSR     TAKEHIT                ;REDUCE SHIELDS
          LDX     T1
KILLEXP:
          LDY     #0
          STY     OBJAX,X
          STY     OBJDX,X
          STY     OBJDY,X
          BEQ     GOTPIC1                ;STORE 0 TO ID
DOTIE:    LDY     #0                     ;FORCE PIC 0 IF DX=0
          LDA     OBJADX,X
          PHA
          CLC
          ADC     #4
          CMP     #4
          PLA
          BCC     GOTPIC
          BPL     NOEOR3
          EOR     #$FF
          ADC     #0
NOEOR3:   STA     T0                     ;ABS OF DX
          LDY     #3                     ;FORCE PIC 3 IF DY=0
          LDA     OBJADY,X
          PHA
          CLC
          ADC     #4
          CMP     #4
          PLA
          BCC     GOTPIC
          PHA
          BPL     NOEOR4
          EOR     #$FF
          ADC     #0
NOEOR4:   CMP     T0                     ;CHECK AGAINST DX MAGNATUDE
          PLA                            ;GET DY AGAIN
          ROL
          ROL                      ;D1=COMPARISON OF MAGNITUDE,D0=DY SIGN
          AND     #$3
          TAY
          LDA     TIEIDS,Y
          TAY
GOTPIC:   LDA     OBJAID,X
          CMP     #(TIEE & $FF)/4
          BCC     GOTPIC1
          TYA                            ;ID TO A
          CLC
          ADC     #6                     ;DARTH IDS ARE TIE +24
          TAY
GOTPIC1:  STY     OBJAID,X
NXTFORCE: DEX
          BMI     SK58
          JMP     FORECLP
SK58:
;
; DERIVE PLAYERS FROM ID BYTES
; OBJECTS A AND B ON EVEN FRAMES
;         T1 = POINT TO OBJECT
;         T2 = PLAYER 0 OR PLAYER 1
;         T3 = 0-3 POINT TO GRX INDIRECTION
;         T4 = DONT USE !!
;
          LDX     #0
          STX     T2                     ;POINTER TO PLAYER NO. (0 OR 1)
          STX     T3                     ;POINTER TO INDIR (0-3)
          LDA     FRAME
          AND     #1
          ASL
          TAX                            ;X=0 OR X=2
PLAYLOOP: STX     T1                     ;PLAYER TO DO THIS FRAME
          LDA     OBJAID,X
          BPL     SK34
          JMP     DOCATS
SK34:
          LDA     OBJADX,X               ;REFLECT FOR TIES IS DDELTA,X
          LSR
          LSR
          LSR
          LSR
          EOR     #$FF                   ;COMPLEMENT REFLECTION
          STA     T6
; DO SRC
          LDA     OBJAY,X
          LDY     T2                     ;GET PLAYER NO
          STA     P0Y,Y
          LDA     OBJAX,X                ;GET XPOS FOR LATER USE
          BNE     SK14
;IF XPOS = 0 THEN PUT OFF SCREEN
          PHA
          LDA     #$D0
          STA     P0Y,Y
          PLA
SK14:
          PHA
          LDA     OBJAID,X               ;GET ID BYTE
;DRIVE REFLECT FROM FRAME FOR FIREBALLS
          CMP     #(FB0 & $FF)/4
          BCC     NOTFB                  ;
          CMP     #((FBE & $FF)/4)
          BCS     NOTFB
          PHA
          LDA     FRAME
          ASL
          ASL
          STA     T6
          PLA
NOTFB:
          ASL
          ASL                      ;ID * 4 = GRX DATA POINTER
          TAY
          LDA     IDS,Y                  ;GET LO SRC ADDRESS
;DERIVE HEIGHT OF TOWERS
          PHA
          LDA     OBJAID,X
          STA     T8
          AND     #$FE
          CMP     #(TOW0 & $FF)/4
          BNE     NOTTOW
          LDA     #MIDY-$10
          CMP     OBJAY,X
          BCS     NOFUDGE
          STY     TY
          LDY     OBJAY,X                ;CHECK FOR MINUS
          BMI     NOFUDGE0
          LDY     T2                     ;GET INDEX
          STA     P0Y,Y                  ;FORCE HORIZON XPOS
NOFUDGE0: LDY     TY
NOFUDGE:  LDA     #MIDY
          SEC
          SBC     OBJAY,X
          LSR
          TAX
          LDA     TOWHGTS,X
SK21:
          STA     T0                     ;SAVE HEIGHT
          PLA                            ;GET LO SRC
          SEC
          SBC     T0
          PHA
NOTTOW:   PLA
;
          LDX     T3                     ;GET POINTER TO INDIR
          STA     P0GX,X
          LDA     IDS+1,Y                ;HI SRC
          STA     P0GX+1,X
          INX                            ;
          INX
          STX     T3                     ;SAVE POINTER TO INDIR
          LDX     T2                     ;GET 0 OR 1
          LDA     IDS+3,Y                ;DO COLORS
          STA     T10,X                  ;PUT IN T10 AND T11
          LDA     IDS+2,Y                ;GET  HEIGHT AND WIDTH
          AND     #$1F
;STORE TOWER HEIGHT
          PHA
          LDA     T8
          AND     #$FE
          CMP     #(TOW0 & $FF)/4
          BEQ     TOWHGT
          PLA
          JMP     NTOW
TOWHGT:   PLA
          LDA     T0                     ;GET TOWER HEIGHT
          STA     SIZE0,X
          LDY     #$10                   ;SINGLE WIDE
          CMP     #(TOWER0-TOWERB0)-$30
          PLA                            ;GET XPOS
          BCC     SK22
;FORCE TAAL TOWER TO DBLE WIDE
DBL:      LDY     #$15                   ;DBL WIDE
          SEC
          SBC     #1                     ;FUDGE X
SK22:     STY     T7,X
          PHA
          PLA
          JMP     SETHORIZ

NTOW:
          STA     SIZE0,X                ;STORE HEIGHT
          LDA     IDS+2,Y                ;GET SIZE AGAI
          LSR
          LSR
          LSR
          LSR
          AND     #$6                    ;GET WIDTH POINTER
          TAY
          LDA     HOFFS+1,Y
          EOR     T6
          AND     #$F7
          EOR     T6
          STA     T7,X                   ;T7,T8 HAVE HORIZ RESOLUTION
          PLA                            ;GET XPOS
          CLC
          ADC     HOFFS,Y
SETHORIZ:
          CMP     #159                   ;OUT OF RANGE ?
          BCC     OK12
          LDA     #0
          STA     SIZE0,X                ;MOAKE ZERO HIGH
OK12:     JSR     CHRST1                 ;CONVERT TO HM/DELAY
          STA     T5,X                   ;T5, T6 HAVE CORRECTED XPOS
          INX                            ;POINT TO NEXT PLAYER
          STX     T2
          CPX     #2
          BCS     OUT04                  ;LEAVE
          LDX     T1                     ;POINTER TO PLAYER (0-3)
          INX                            ;POINT TO NEXT PLAYER
          JMP     PLAYLOOP
OUT04:
          STA     HSYNC
VBOUT:    BIT     TIMOUT                 ; WAIT FOR VB OVER
          BPL     VBOUT
          LDA     #0
          STA     P0REF
          STA     P1REF
          LDA     SCREEN
          CMP     #2
          BNE     SK53
          LDA     #$76                   ;FORCE TRENCH COLORS
          STA     T10
          STA     T11
SK53:
          JMP     SWGRX
;
; RETURN FROM GRAPHICS BANK
;
OVSCAN:
          JSR     SETUPTR                ;SET UP TRENCH
          STA     HSYNC
          STA     HMOV
OVOUT:    BIT     TIMOUT                 ; OVERSCAN TIMOUT
          BPL     OVOUT
          JMP     SCRNTOP                ; NEW FRAME !
;
; SUBROUTINES
;
;
; TIE INTELLIGENCE
;
;CHECK FOR OPEN PLAYER SLOTS
;
TIEINT:
          LDA     FRAME+1
          CMP     #$7
          BCC     SK88
          RTS
SK88:     LDA     SUPRESS               ;OK TO RUN ?
          BNE     TOOUT10                ;NO
          LDX     #0
          STX     T1                     ;ZERO TIE OR TOWER COUNT
          DEX
          STX     T0                     ;SIGNIFY NO OPEN SLOT
          LDX     #3
SLOTLOOP: LDA     OBJAX,X
          BNE     FINLOOP
          STX     T0
          BEQ     SK15                   ;DEAD ACNT  BE TIE
FINLOOP:  LDA     OBJAID,X
          CMP     #(DARTHE & $FF)/4
          BCS     SK15
          INC     T1                     ;THATS TIE OR TOWER
SK15:     DEX
          BPL     SLOTLOOP
          LDA     FRAME
          AND     #$3
TOOUT10:  BNE     OUT10
          LDX     #3
INTELLP:  LDA     OBJAX,X
          BEQ     NXTINTEL
          LDA     OBJAID,X
          CMP     #(DARTHE & $FF)/4        ;MAKE SURE IT A TIE FIGHTER
          BCS     NXTINTEL
          LDA     OBJAX,X
          LDY     OBJADX,X
          CMP     #MIDX
          DEY
          BCS     DECIT0
          INY
          INY
DECIT0:   TYA
          BPL     NOEOR
          EOR     #$FF
          CLC
          ADC     #1
NOEOR:    CMP     #MAXDX
          BCS     NODWRITE
          STY     OBJADX,X
NODWRITE: LDA     OBJAY,X
          CMP     #MIDY
          LDY     OBJADY,X
          DEY
          BCS     DECIT1
          INY
          INY
DECIT1:
          TYA
          BPL     NOEORY
          EOR     #$FF
          CLC
          ADC     #1
NOEORY:
          CMP     #MAXDY
          BCS     NODWRITY
          STY     OBJADY,X
NODWRITY:
; LAUNCH FIREBALL?
          LDA     T0                     ;SLOT AVAILABLE?
          BMI     NXTINTEL               ;NO
          LDY     WAVENO
          JSR     RANDOM
          AND     LNCHTIME,Y             ;VARY FIRE RATE WITH WAVE
          BNE     NXTINTEL
          LDA     OBJAX,X                ;LOOK FOR LAUNCH WINDOW
          SBC     #MIDX-$20
          CMP     #$40
          BCS     NXTINTEL               ;GO IF OUTSIDE WINDOW (JTZ ';' was missing!)
; LAUNCH
          LDY     T0
          LDA     OBJAX,X                ;COPY POSITION TO FIREBALL
          STA     OBJAX,Y
          LDA     OBJAY,X
          STA     OBJAY,Y
          LDA     #(FB0 & $FF)/4
          STA     OBJAID,Y
          LDA     #0
          STA     OBJADX,Y
          STA     OBJADY,Y
          LDA     #$FF
          STA     T0
          LDA     #<(SSST-1)             ;LAUNCH SOUND
          JMP     SNDINI                 ;AND RET FROM THERE
NXTINTEL: DEX
          BPL     INTELLP
OUT10:
;
; LAUNCH TIE
;
          LDX     T0
          BMI     OUT06                  ;NO SLOTS
          LDA     T1                     ;CHECK NUMBER OF TIE
          BNE     SK56
          LDY     #$FF
          STY     VEERDX
          STY     VEERDY                 ;NO SHIPS, HAVE R2D2 VEER
SK56:
          LDY     WAVENO
          CMP     NOTIES,Y               ;CHECK AGAINST NUMBER FOR THIS WAVE
          BCS     OUT05
          LDA     FRAME
          AND     #$7F
          BNE     OUT05
;ÖAUNCH TIE FIGHTER
LTIE:     LDY     #140
          BIT     VEERDX
          BMI     SK19
          LDY     #1
SK19:
          STY     OBJAX,X
          LDA     RAND
          AND     #$3F
          ADC     #$20
          STA     OBJAY,X
          LDY     #0
          LDA     WAVENO
          CMP     #1                     ;CUTOFF WAVE FOR DARTH
          BCC     SK57
          LDA     RAND
          AND     #1
          BNE     SK57
          BIT     DARTH
          BMI     SK57
          LDY     #$FF
          STY     DARTH
          LDY     #6                     ;FORCE DARTH VADER
SK57:     STY     OBJAID,X
          LDA     #0
          STA     OBJADX,X
          STA     VEERDX
          STA     VEERDY
OUT05:
OUT06:    RTS
;
; MULTIPLY X BY SLOPE
; A = LO OFFSET*4     TX=TY= HI OFFSET * 4
;
XTSLOPE:  AND     #$07
          TAX                            ;POINT TO LIST OF SERVICES
          LDA     SLJMPS,X               ;GET LO SERVICE ADDRESS
          STA     TFF
          LDA     #>(SLSERVS)
          STA     T0
          LDA     #0
;*4
          STA     TX
          LDA     T8                     ;T8= *2
          ASL
          ROL     TX
          LDX     TX
          STX     TY
          JMP     (TFF)
RET0:     LDX     TX                     ;
          STX     TZ                     ;SAVE HI RESULT
          STA     TY                     ;SAVE LO RESULT
          LSR     TX                     ;/4
          ROR
          LSR     TX
          ROR
          RTS
;
; SERVICE JUMP TABLE
;
SLJMPS:   .byte      <X25,<X50,<X75,<X100,<X150,<X175,<X200,<X400
;
;
; VALUE ANDED WITH RAND FOR FIREBALL FIRE RATE
;
LNCHTIME: .byte      $1F,$0F,$07,$03,$01,$01,$01,$01
;
; DELTAS FOR MOVEMETN THROUGH TRENCH
;
DYES:     .byte      $FE,$02,$00,$FE
TIEIDS:   .byte      2,4,1,5
BIRTHS:   .byte      $14,$24,$34,$44,$54,$64,$74,$84
;
; HORIZONTAL OFFSETS AND SIZES FOR PLAYERS
;
HOFFS:    .byte      00,$10                 ;SINGLE WIDE
          .byte      -8,$15                  ;DOUBLE WIDE
          .byte      -12,$17                  ;QUAD WIDE
;
;         BOB'S HORIZONTAL RESET LOOP
;            A HAS HORIZONTAL POSITION
;            X POINTS TO OBJECT
;
CHRST:
          STA     T0                     ; SAVE HP
          INC     T0                     ; FUDGE
          CPX     #2
          BCC     NOMORE                 ; DON'T FUDGE AGAIN
          INC     T0
NOMORE:
          LDA     T0
          PHA                            ; SAVE HP
          LSR
          LSR
          LSR
          LSR                      ; DIVIDE BY 16
          STA     T0                     ; AND SAVE ...
          TAY                            ; LOOP COUNT
          PLA                            ; RESTORE HP
          AND     #$0F
          CLC
          ADC     T0                     ; GET ERROR COUNT
          CMP     #$F                    ; E IS MAX
          BCC     OKO
          SBC     #$F
          INY                            ; CORRECTION
OKO:      SEC
          SBC     #$08                   ; CONVERT INTO HMOVE FORMAT
          EOR     #$FF                   ; INVERT
          STA     HSYNC
          ASL
          ASL
          ASL
          ASL
          STA     P0HM,X                 ; HMOVE VALUE
RSTLP:
          DEY
          BPL     RSTLP
          STA     T0                     ; 3 CYCLE KILL
          STA     P0RES,X                ; RESET
          RTS
;

;
; TOWER PATTERNS
;
T00:      .byte      $37,$BF,$26,$00,$20,$60,$E0,$A0
T01:      .byte      $F0,$30,$70,$B0,$20,$60,$E0,$A0
T02:      .byte      $3F,$00,$7B,$2A,$00,$7F,$A0,$30
T03:      .byte      $30,$70,$B0,$F0,$00,$00,$00,$00
TR00:     .byte      $00,$00,$C2,$00,$00,$00,$00,$00
          .byte      $00,$00,$00,$00,$C3,$CA,$00,$00
TR01:     .byte      $81,$89,$80,$88,$00,$00,$00,$00
          .byte      $81,$89,$00,$00,$83,$8B,$00,$00
TR02:     .byte      $80,$88,$83,$8B,$80,$88,$83,$8B
          .byte      $82,$8A,$81,$89,$80,$88,$C1,$C9
TR03:     .byte      $90,$98,$92,$9A,$90,$98,$92,$9A
          .byte      $C0,$C9,$83,$8B,$C0,$C8,$83,$8B
TR04:     .byte      $90,$9A,$92,$C8,$80,$88,$88,$C3
          .byte      $C0,$C8,$98,$9A,$C0,$C9,$91,$99
TR05:     .byte      $92,$9A,$80,$88,$C2,$CA,$81,$89
          .byte      $C0,$C8,$82,$8A,$80,$88,$C1,$C9
TR06:     .byte      $90,$92,$98,$9A,$90,$92,$98,$9A
          .byte      $90,$9A,$92,$98,$C0,$C9,$C2,$CA
TR0E:     .byte      $00,$00,$00,$C2,$00,$00,$00,$00
          .byte      $C2,$CA,$C1,$C9,$C4,$CB,$94,$96
;
; SET UP TRENCH STARS
;
SETUPTR:
          LDX     SCREEN
          DEX
          BEQ     SKLGHT
          JMP     SK09
SKLGHT:
;
; MOVE AND BIRTH TOWER LIGHTS
;
          LDX     #7
LGHTLOOP:
          LDA     STARAY,X
          LSR
          LSR
          LSR
          LSR
          TAY
          LDA     FRAME
          AND     LGHTMASK,Y
          BNE     NOMOVE
          DEC     STARAY,X
NOMOVE:   BPL     NONEW
;BIRTH LIGHT
DEAD:     JSR     DEAD0
NONEW:    LDY     STARAX,X
          TYA
          SEC
          SBC     #MIDX-$10              ;FIND CENTRAL WINDOW
          CMP     #$20
          LDA     FRAME
          AND     #$1F
          BCC     SK23
          AND     #$7
SK23:     BNE     NODX
          INY
          CPY     #MIDX
          BCS     MRIGHT
          DEY
          DEY
;ADD IN VEER
MRIGHT:
NODX:     LDA     STARAY,X
          CMP     #$18                   ;LIMIT FOR DOBLE SPEED
          LDA     FRAME
          AND     #$1F
          BCC     SK24
          AND     #$0F
SK24:
          BNE     NODX1
          LDA     VEERDX
          BEQ     NODX1
          DEY
          BMI     SK25
          INY
          INY
NODX1:
SK25:     CPY     #150
          BCS     DEAD                   ;BIRTH ANEW

          STY     STARAX,X
NEXTLGHT: DEX
          BPL     LGHTLOOP
;
; MOVE DOWNSCREEN
;
          LDA     STAR2MOV
          AND     #$F
          TAX
          DEC     STARAY,X
          BPL     OK07                   ;STILL IN RANGE
;DEATH
          JSR     DEAD0
          INX
          TXA
          EOR     STAR2MOV
          AND     #$3
          EOR     STAR2MOV
          STA     STAR2MOV
OK07:     LDA     STAR2MOV
          LSR
          LSR
          LSR
          LSR
          LSR
          LSR
          ORA     #$04
          TAX
          DEC     STARAY,X
          BPL     OK11
;DEATH
          JSR     DEAD0
          LDA     STAR2MOV
          CLC
          ADC     #$40
          STA     STAR2MOV
OK11:
          JMP     OUT03
SK09:     DEX
          BNE     MSTARS
          JMP     ITTRENCH
;
; MOVE STARS
;
MSTARS:
          LDX     #0
          LDA     VEERDY
          ORA     VEERDX
          BNE     DOVEER
          LDX     #$80
DOVEER:   STX     T4                     ;D7 RESET=VEER, SET=OUTWARD MOTION
          LDX     #7
          LDA     FRAME
          ROR
          ROR
          STA     T3
STARLP:   LDA     STARAX,X               ;DO DELTA X
          BIT     T4
          BPL     DOVEER1
          CMP     #MIDX                  ;LEFT OR RIGHT HALF ?
          TAY
          INY
          TYA
          BCS     RNGCK                  ;KILLL?
          DEY
          DEY
          TYA
          BCC     RNGCK
DOVEER1:  CLC
          ADC     VEERDX                 ;ADD X VEER
RNGCK:    CMP     #$9F                   ;WARP?
          BCC     OK08
;KILL STAR
          NOP
          LDA     #0
OK08:     STA     STARAX,X               ;DO DELTA Y
          LDA     STARAY,X
          BIT     T4
          BPL     DOVEER2
          CMP     #MIDY
          TAY
          INY
          TYA
          BCS     RNGCK1                 ;KILLL?
          DEY
          DEY
          TYA
          BCC     RNGCK1
DOVEER2:
          CLC
          ADC     VEERDY
RNGCK1:
          CMP     #113
          BCC     OK09
          NOP
          LDA     #0
          STA     STARAX,X
OK09:     STA     STARAY,X
; BIRTH NEW STAR ACCORDING TO DELATS
          LDA     STARAX,X
          BNE     NXT00                  ;DO NEXT DELTA AND BIRTH
          JSR     RANDOM
          STA     T2
          STA     T0                     ;RAND D7 PICKS X OR RAND Y POS
          BIT     T4
          BPL     VEERBRTH
;CENTRAL BIRTH
          AND     #$3F
          ADC     #MIDX-32
          STA     STARAX,X
          LDA     RANDH
          AND     #$3F
          ADC     #MIDY-32
          STA     STARAY,X
          JMP     NXT00
VEERBRTH:
          LDY     #113
          BIT     VEERDY
SK06:     BMI     NEGDY
          LDY     #0
NEGDY:    STY     T1                     ;SAVE Y ORIGIN
          LDY     #159
          BIT     VEERDX
          BMI     NEGDX
          LDY     #1
NEGDX:    LDA     T2
          AND     #$7F                   ;GET RAND FOR X OR Y POS
          BIT     T0                     ;REPLACE X OR WITH RANDOM
          BMI     SK05
          TAY                            ;MOVE RAND TO X
          LDA     T1                     ;GET Y POS
SK05:     STY     STARAX,X
          STA     STARAY,X
NXT00:
          BIT     T3
          BPL     NXT01
          CPX     #4
          BCC     OUT03
NXT01:    DEX
          BMI     OUT03
          JMP     STARLP
OUT03:
;
; SET UP STARS
;
          LDA     FRAME
          ASL                      ;START WITH THIS NUMBER STAR
          AND     #$6
          TAX
          STX     T2
          LDA     STARAX,X
          LDX     #3
          JSR     CHRST
          LDX     T2
          LDA     STARAY,X
          AND     #$FE                   ;FORCE EVEN
          STA     ST1Y                   ;STAR 1 YPOS
          INX
          STX     T2
          LDA     STARAX,X
          LDX     #2
          JSR     CHRST
          LDX     T2
          LDA     STARAY,X
          AND     #$FE
          STA     ST2Y                   ;STAR 1 YPOS
;
          JMP     DOHAIR                 ;NOW DO CROSSHAIR


;
; SET UP TRENCH SCREEN
;
ITTRENCH:
;  MOVE VERTICAL LINES ON TRENCH SCREEN
;
          LDX     VERTOFF
          LDA     FRAME
          AND     #$3
          BNE     OKXX
          INX
          CPX     #16
          BCC     OKXX
          LDX     #0
OKXX:     STX     VERTOFF
;
; CONTROL POSITION IN TRENCH ;control2
;
          LDA     CHAIRY
          SBC     #MIDY-$20
          CMP     #$40
          LDA     FRAME
          AND     #$F
          BCC     SK20
          AND     #$7
SK20:
          BNE     OUT98                  ;DONT DO
          LDA     CHAIRY
          LDY     #0
          CMP     #MIDY-12
          BCS     NOMOVE0
          DEY
NOMOVE0:  CMP     #MIDY+4
          BCC     NOMOVE1
          INY
NOMOVE1:  TYA
          CLC
          ADC     XWY
          BPL     SK16
          LDA     #0
SK16:     CMP     #6                     ;AT TOP OF TRNCH?
          BCC     SK17
          LDA     #5
SK17:     STA     XWY
OUT98:
          LDA     CHAIRX
          SBC     #MIDX-$20
          CMP     #$40
          LDA     FRAME
          AND     #$F
          BCC     SK46
          AND     #$7
SK46:
          BNE     OUT97                  ;DONT DO
          LDA     CHAIRX
          LDY     #0
          CMP     #MIDX-12
          BCS     NOMOVE2
          DEY
NOMOVE2:  CMP     #MIDX+4
          BCC     NOMOVE3
          INY
NOMOVE3:  TYA
          CLC
          ADC     XWX
          BPL     SK26
          LDA     #0
SK26:     CMP     #5                     ;AT TOP OF TRNCH?
          BCC     SK27
          LDA     #4
SK27:     STA     XWX
OUT97:
;
; SET UP TRENCH WALLS
;
          LDA     XWX
          ASL
          ASL
          ASL                      ;*8
          ORA     XWY
          ASL                      ;TABLE TWO BYTES / ENTRY
          TAX
          STX     T9                     ;SAVE FOR CATWALK ROUTINES
;
; HAVE POINTS TO WALLS
;
          LDY     #0
          LDA     FRAME
          LSR
          BCC     SKIP01                 ;EVEN FRAME USES LO NYBBLE, RGHT SIDE
;
          LDY     #2                     ;FORCE LEFT SIDES
          INX
; DO BOTTM
SKIP01:   LDA     TRPOINT,X              ;GET LEFT OR RIGHT POINTER
          STA     T4                     ;PUT TRENCH IDS INTO T4
          ROL     T4                     ;PUT ODD/EVEN BIT INTO D0
          STA     T0
          AND     #$7
          ASL
          DEY
          BPL     SKIP02
          ADC     #$10                   ;INDEX INTO RIGHTS
SKIP02:
          TAX
          LDA     BLTR,X
          STA     HMTAB1                 ;HM INDIRECTION
          LDA     BLTR+1,X
          STA     HMTAB1+1
;DO TOP OF TRENCH
          LDA     T0
          LSR
          LSR
          LSR
          LSR
          STA     T0
          ASL
          ADC     T0                     ;*3
          DEY
          BPL     SKIP03
          CLC
          ADC     #24
SKIP03:
          TAX
          LDA     TLTR,X
          STA     HMTAB
          LDA     TLTR+1,X
;
; SET HORIZONTAL POSITION OF TRENCH WALL
;
          STA     HMTAB+1
          LDA     TLTR+2,X
          STA     HSYNC

          STA     M1HM
          AND     #$0F
          TAY
          LDA     T0
          NOP
          NOP
          NOP                            ;WASTE 2
RESPL0:   DEY
          BPL     RESPL0
          STA     M1RES
;
; SET UP TRENCH VERTICAL
;
          LDA     T4                     ;TRENCH IDS AND ODD/EVEN ON D0
          LSR
          TAX                            ;SAVE TRENCH POINTER
          LDA     XWX
          BCS     SK45
          LDA     #$04
          SEC
          SBC     XWX                    ;INVERT FOR RIGHT SIDE
SK45:
          ASL
          ASL
          ASL
          ASL
          CLC
          ADC     VERTOFF                ;SLOPE # * 15 + X OFFSET
          TAY
          LDA     CATXS,Y
BREAK0:   STA     T8
          TXA
          CLC
          JSR     XTSLOPE
          LDX     TX
          BNE     FORCE1
          CMP     #0
          BNE     SK42
          LDA     #2
SK42:
          STA     T0
          LDA     #MIDYB                 ;CENTER SCREEN
          SEC
          SBC     T0                     ;ADD CENTER TO X * SKOPE
          BPL     SK01                   ;DONT UNDERFLOW
FORCE1:   LDA     #1
SK01:
          AND     #$FE                   ;MAKE EVEN
          STA     TRIGA                  ;KERNEL TURN OFF
; DO TOP
          LDA     T4
          LSR
          LSR
          LSR
          LSR
          LSR
          JSR     XTSLOPE
          LDX     TX
          BNE     FORCE114
          CLC
          ADC     #MIDYA
          CMP     #113                   ;DONT OVERFLOW
          BCC     SK03
FORCE114: LDA     #113                   ;FORCE TOP OF SCREÉN
SK03:
          ORA     #$01                   ;MAKE ODD
          STA     TRIG
; SET UP X POSITION
          LSR     T8                     ;CORRECT DOUBLE OFFSET
          LDA     #MIDX
          ROR     T4                     ;ODD OR EVEN FRAME
          BCC     EVENFR
          SBC     #4
          SEC
          SBC     T8                     ;VERTICAL X OFFSET
          JMP     OUT00
EVENFR:   ADC     #3
          CLC
          ADC     T8
OUT00:    LDX     #2
          JSR     CHRST
;
; SET UP CROSHAIR OR LASER SHOTS
;
DOHAIR:   LDA     LAZY                   ;KILL LAZER SHOT?
          CMP     #$F0
          BCS     OK06
          CMP     CHAIRY
          BCC     OK06
          LDA     #0
          STA     LAZY
          STA     LAZAX
          STA     LAZBX
          STA     LAZDY
          STA     LAZADX
          STA     LAZBDX
          JMP     CXDETECT               ;SWITCH IN CX ROUTINES

OK06:
          LDA     LAZDY                  ;SEE IF LASER ACTIVE
          BEQ     NOLASER
;
; SET UP LASER
;
          LDA     FRAME
          AND     #$1
          EOR     #$1
          TAX
          LDA     LAZAX,X
          STA     T4                     ;PUT XPOS IN T4
;
; SET UP SLOPE FOR LASER FIRE
;
          LDA     LAZY
          STA     T3                     ;SAVE YPOS
          LDA     LAZHM                  ;GET CURRENT HMOVE VALUE
          CPX     #0                     ;ODD OR EVEN FRAME
          BEQ     SK18
          ASL
          ASL
          ASL
          ASL
SK18:     AND     #$F0
          TAY
          BNE     SKLENTER
          LDA     T4
          JMP     OUT01
;
; SET UP CROSSHAIR
;
NOLASER:
          LDY     #$10                   ;SET UP 45 ANGLE
          LDA     CHAIRY
          STA     T3
          LDA     CHAIRX
          STA     T4
SKLENTER: LDA     #$6B                   ;HEIGHT OF SCREEN
          SEC
          SBC     T3                     ;YPOS
          CPY     #$20                   ;CHECK FOR 1/2 SLOPE
          BNE     SK04                   ;NO
          ASL                      ;MULTIPLY BY TWO
SK04:
          STA     T0                     ;0=TOP OF SCREEN
          CLC
          ADC     #8                     ;FOR LEFT SLOPE
          STA     T1
;
          LDA     FRAME
          LSR
          LDA     T4                     ;START WITH CROSSHAIR XPOS
          BCS     CFRGHT
;COME FROM LEFT ON EVEN FRAMES
          SEC
          SBC     T0
          BCS     OK01
          CLC
          ADC     #160                   ;WRAP
OK01:
          JMP     OUT01
CFRGHT:   CLC
          ADC     T1
          BCC     OK02
          SEC
          SBC     #160
OK02:     CMP     #160
          BCC     OK03
          SEC
          SBC     #160
OK03:
OUT01:    STY     T4                     ;HOLD BALL HMOVE FOR KERNELS
          PHA
          LDA     T3
          AND     #$FE
          STA     M1Y
          PLA
          LDX     #4
          JMP     CHRST                  ;RETURN FROM THERE
;
;  STICK 
;
;  SWTAG-RC Hack - Reverse the DEY and INY's below to reverse the control scheme.
;             
STICK:
          LDA     PLRCTL
          LDX     CHAIRDX
          LDY     CHAIRDY
          ASL
          BCS     SK10
          INX
          INX
SK10:     ASL
          BCS     SK11
          DEX
          DEX
SK11:     ASL
          BCS     SK12
          DEY			; Changed from original - was INY
          DEY			; Changed from original - was INY
SK12:     ASL
          BCS     SK13
          INY			; Changed from original - was DEY
          INY			; Changed from original - was DEY
SK13:     LDA     LAZDY                  ;DONT MOVE CROSS HAIR IF LASER ON
          BNE     OUT99
;LIMIT CHECKS FOR DELTAS
          TYA                            ;GET NEW DY
          BPL     SK28
          EOR     #$FF
          CLC
          ADC     #1
SK28:     CMP     #MAXCHDY
          BCS     NODYWR
          STY     CHAIRDY
NODYWR:   CMP     #1                     ;CHECK FOR 2
          BNE     SK80
          ASL     CHAIRDY
SK80:     TXA
          BPL     SK29
          EOR     #$FF
          CLC
          ADC     #1
SK29:     CMP     #MAXCHDX
          BCS     NODXWR
          STX     CHAIRDX
NODXWR:
          CMP     #1                     ;CHECK FOR 1
          BNE     SK81
          ASL     CHAIRDX
          ASL     CHAIRDX
SK81:
;
; DECAY CROSS HAIR DELTA X               ;control
;
          LDA     PLRCTL                 ;LOAD JOYSTICK
          AND     #$C0
          EOR     #$C0
          BNE     SK54
          STA     CHAIRDX
SK54:
          LDA     PLRCTL                 ;LOAD JOYSTICK
          AND     #$30
          EOR     #$30
          BNE     SK55
          STA     CHAIRDY
SK55:
;
; KEEP CROSSHAIR IN BOUNDS
;
          LDA     #$1C                   ;MAX LEFT
          CMP     CHAIRX                 ;MAX LEFT
          BCC     NOWR2
          STA     CHAIRX
NOWR2:
          LDA     #$7E                   ;MAX RIGHT
          CMP     CHAIRX
          BCS     NOWR3
          STA     CHAIRX
NOWR3:
          LDA     #9
          CMP     CHAIRY
          BCC     NOWR4
          STA     CHAIRY
NOWR4:
          LDA     CHAIRY
          CMP     #102
          BCC     NOWR5
          LDA     #101
NOWR5:    AND     #$FE
          STA     CHAIRY
OUT99:
;
; READ CROSS HAIR DELTA X AND ACCELERATE OBJECTS
;
          LDY     SCREEN
          CPY     #1
          BNE     RETURN
          LDA     CHAIRX
          SEC
          SBC     #MIDX-$10
          BMI     USE1
          DEY
          CMP     #$20
          BCC     USE1                   ;USE 0
          DEY
USE1:     STY     T0                     ;SAVE DDX
;GOT DELTA
          LDX     #3
DDXLP:    LDA     OBJAY,X
          CMP     #$20
          LDA     FRAME
          AND     #$1F
          BCS     SK32
          AND     #$0F
SK32:     BNE     NXTDDX
          LDA     OBJADX,X
          CLC
          ADC     T0
; DO LIMIT CHECK
          BMI     SK79                   ;NEG DELTA
          CMP     #MAXTOWDX
          BCS     NXTDDX
          BCC     DODX
SK79:     CMP     #-MAXTOWDX
          BCC     NXTDDX
DODX:     STA     OBJADX,X
NXTDDX:   DEX
          BPL     DDXLP
RETURN:   RTS
;
;
;
;
;
; DATA AREA
;
;
; TRENCH MOTION MASKS
;
;MOVEMSK:  DB      3,7
;
;
; TABLES OF HMOVES FOR CROSS HAIR SLOPE
;


BHMS:     .byte      $10,$F0

; MASKS FOR TOWER LIGHT MOVMENT
;
LGHTMASK: .byte      $3F,$3F,$3F,$3F,$3F,$3F,$3F
;
; TRENCH DATA
;
;
; TRENCH POINTERS
;  BYTE 1 = RIGHT TOP/RIGHT BOT  ..BYTE 2 = LEFT TOP/LEFT BOTTOM
;
;                 ;0,0 - 0,7
TRPOINT:
          .byte      $30,$62,$20,$63,$21,$55,$12,$55,$02,$36,$03,$26,$00,$00
          .byte      $00,$00
          ;1.0 - 1,7
          .byte      $40,$61,$30,$51,$21,$44,$12,$44,$03,$15,$04,$16,$00,$00
          .byte      $00,$00
          ;2.0 - 2,7
          .byte      $50,$50,$41,$41,$32,$32,$23,$23,$14,$14,$05,$05,$00,$00
          .byte      $00,$00
          ;3.0 - 3,7
          .byte      $61,$40,$51,$30,$44,$21,$44,$12,$15,$03,$16,$04,$00,$00
          .byte      $00,$00
          ;4.0 - 4,7
          .byte      $62,$30,$63,$20,$55,$21,$55,$12,$36,$02,$26,$03,$00,$00
          .byte      $00,$00
;
BLTR:     .word      L0BOT,L1BOT,L2,L3,L4,L5,L6,L7
BRTR:     .word      R0BOT,R1BOT,R2,R3,R4,R5,R6,R7
TLTR:     .word      R0
          .byte      $F0
          .word      R1
          .byte      $30
          .word      R2
          .byte      $A0
          .word      R3
          .byte      $91
          .word      R4
          .byte      $D2
          .word      R5
          .byte      $43
          .word      R6
          .byte      $03
          .word      R7
          .byte      $34
TRTR:     .word      L0
          .byte      $00
          .word      L1
          .byte      $00
          .word      L2
          .byte      $A9
          .word      L3
          .byte      $BB
          .word      L4
          .byte      $68
          .word      L5
          .byte      $F7
          .word      L6
          .byte      $37
          .word      L7
          .byte      $06
;
;  DIVIDE A BY .25,.5,.75,1,1.5,2,4
; TX=TY= HI OFFSET *4    A= LO OFFSET *4
;
SLSERVS:
X25:      LSR     TX
          ROR
X50:      LSR     TX
          ROR
          CLC
          JMP     RET0
X75:      LSR     TX
          ROR
          STA     T0
          LSR     TY
          LSR     TX
          ROR
          CLC
          ADC     T0
          PHA
          LDA     TY
          ADC     TX
          STA     TX
          PLA
X100:     CLC                          ;NO ERRORS
          JMP     RET0
X150:     STA     T0
          LSR     TX
          ROR
          CLC
          ADC     T0
          PHA
          LDA     TY
          ADC     TX
          STA     TX
          PLA
          JMP     RET0
X400:     ASL
          ROL     TX
X200:     ASL
          ROL     TX
          JMP     RET0
X175:     STA     TZ
          LSR     TY
          ROR
          PHA
          CLC
          ADC     TZ
          STA     TZ
          LDA     TX
          ADC     TY
          STA     TX
          PLA
          LSR     TY
          ROR
          CLC
          ADC     TZ
          STA     TZ
          LDA     TX
          ADC     TY
          STA     TX
          LDA     TZ
          JMP     RET0
; ****** TABLES ******
DUR:
          .byte      8,16,24,48           ;VARIOUS DURATIONS

TUNE
TUNE1A
          NOTE    0,$F,2
          NOTE    0,$B,3
          NOTE    1,$17,3
          NOTE    1,$1A,0
          NOTE    1,$1B,0
          NOTE    1,$1F,0
          NOTE    1,$11,3
          NOTE    1,$17,2
          NOTE    1,$1A,0
          NOTE    1,$1B,0
          NOTE    1,$1F,0
          NOTE    1,$11,3
          NOTE    1,$17,2
          NOTE    1,$1A,0
          NOTE    1,$1B,0
          NOTE    1,$1A,0
          NOTE    1,$1F,3
          NOTE    1,$1F,2
          .byte      0
TUNE1B
          NOTE    0,$1F,2
          NOTE    0,$17,2
          NOTE    0,$18,2
          NOTE    0,$1B,2
          NOTE    0,$1F,2
          NOTE    0,$11,2
          NOTE    0,$12,2
          NOTE    0,$14,2
          NOTE    0,$17,2
          NOTE    0,$11,2
          NOTE    0,$12,2
          NOTE    0,$14,2
          NOTE    0,$17,2
          NOTE    0,$1A,2
          NOTE    0,$1F,2
          NOTE    0,$1F,2
          NOTE    0,$1F,2
          .byte      0
TUNE2A
          NOTE    1,$13,2
          NOTE    1,$17,2
          NOTE    1,$13,2
          NOTE    1,$17,2
          NOTE    1,$10,2
          NOTE    1,$11,0
          NOTE    1,$10,0
          NOTE    1,$11,0
          NOTE    1,$13,2
          NOTE    1,$17,2
          NOTE    0,0,0
TUNE2B
          NOTE    0,$0F,2
          NOTE    0,$12,2
          NOTE    0,$0F,2
          NOTE    0,$12,2
          NOTE    0,$0F,2
          NOTE    0,$0F,2
          NOTE    0,$0F,2
          NOTE    0,$12,2
          .byte      0
EOF
;
; POINTERS TO PLAYER GRAPHICS
;  LO SRC, HI SRC, D0-D4 HEIGHT D5-D7 HORIZ SIZE
;  0=SINGLE 5=DBL 7=QUAD
          BOUNDRY 0
IDS:
TIE0:     .word      TF0
          .byte      $10,$0A
TIE1:     .word      TF1
          .byte      $10,$0A
TIE2:     .word      TF2
          .byte      $10,$0A
TIE3:     .word      TF3
          .byte      $10,$0A
TIE4:     .word      TF4
          .byte      $10,$0A
TIE5:     .word      TF5
          .byte      $10,$0A
TIEE:
DARTH0:   .word      DA0
          .byte      $10,$88
DARTH1:   .word      DA1
          .byte      $10,$88
DARTH2:   .word      DA2
          .byte      $10,$88
DARTH3:   .word      DA3
          .byte      $10,$88
DARTH4:   .word      DA4
          .byte      $10,$88
DARTH5:   .word      DA5
          .byte      $10,$88
DARTHE:
TOW0:     .word      TOWER0
          .byte      $10,$0F
TOW1:     .word      TOWER1
          .byte      $10,$0A
STAR0:    .word      DSTAR
          .byte      $10,$54
EXP0:     .word      EX0
          .byte      $10,$44
EXP1:     .word      EX1
          .byte      $10,$46
EXP2:     .word      EX2
          .byte      $10,$48
EXP3:     .word      EX3
          .byte      $10,$46
EXPE:
FB0:      .word      FBA
          .byte      $10,$44
FB00:     .word      FBA
          .byte      $10,$46
FB1:      .word      FBB
          .byte      $10,$48

FB2:      .word      FBC
          .byte      $B1,$4A
FB3:      .word      FBD
          .byte      $B1,$4C
FBE:                                   ;END OF FIREBALLS
DARTHX:   .word      DA0
          .byte      $10,$0F
;
; FIREBALL VERT OFFSETS FOR DIFFERENT SIZE FIREBALLS
FBVERT:
          .byte      0,00,0,0,1,1
;
; CATWALK WIDTHS
;
CATWIDTH: .byte      $10,$15,$17
CATGRX:   .word      F0S,F8S,FCS,FES,FFS
;
; CATWALK X OFFSETS
;
CATXS:
;
;
SLOPE0:   .byte      $04,$04,$07,$09,$0B,$0D,$0E,$14
          .byte      $1A,$1C,$1E,$20,$26,$2E,$34,$3C
SLOPE1:   .byte      $04,$06,$09,$0B,$0E,$0F,$10,$17
          .byte      $1F,$21,$23,$25,$2D,$34,$3E,$42
SLOPE2:   .byte      $04,$06,$0A,$0E,$12,$16,$1A,$22
          .byte      $28,$2E,$34,$38,$44,$4E,$5A,$68
SLOPE3:   .byte      $05,$07,$0B,$0F,$12,$19,$1A,$23
          .byte      $2C,$32,$36,$3C,$4A,$52,$60,$6C
SLOPE4:   .byte      $06,$08,$0E,$13,$18,$1C,$20,$2E
          .byte      $3A,$40,$44,$48,$58,$68,$78,$80
TRHEIGHT: .byte      $13,$15,$18,$1E,$21,$25,$29,$31
          .byte      $37,$3C,$43,$47,$52,$5C,$67,$76
TRWIDTH:  .byte      $0B,$0E,$12,$16,$1A,$1C,$20,$28
          .byte      $30,$34,$3C,$40,$4C,$58,$64,$70
CTHEIGHT: .byte      $05,$06,$07,$08,$09,$0B,$0B,$0E
          .byte      $0F,$10,$12,$13,$15,$18,$1A,$1E

; <<<<<<<<<<<<<<<<<<< LOOK HERE---NOT IN SOURCE
;    .BYTE $4E ; | X  XXX | $1BF7
;    .BYTE $4D ; | X  XX X| $1BF8
;    .BYTE $63 ; | XX   XX| $1BF9
;    .BYTE $4B ; | X  X XX| $1BFA
;    .BYTE $65 ; | XX  X X| $1BFB
;    .BYTE $6E ; | XX XXX | $1BFC
;    .BYTE $7A ; | XXXX X | $1BFD
;    .BYTE $69 ; | XX X  X| $1BFE
;    .BYTE $65 ; | XX  X X| $1BFF
; <<<<<<<<<<<<<<<<<<<<

;
; BANK 3
;
   org $1C00
   rorg $5800
;          ORG     $5800
;
; LASER SHOT COLLISION DETECT
;   CALLED AS SHOT IS KILLED
;
CHAIRCX:  LDY     #0
;CHECK IN X
          LDX     #3
CXLOOP:   LDA     CHAIRX               ;LOAD CROSSHAIR X
          SEC
          SBC     #8
          CMP     OBJAX,X
          BCS     TONOCXX
          ADC     #16
          CMP     OBJAX,X
          BCC     TONOCXX
;COLLISION IN X
          LDA     OBJAID,X             ;SEE IF TOWER
          ASL
          ASL
          LDA     OBJAID,X
          BCS     FBPORTCX
          BMI     TONOCXX                ;DONT HIT CATWALK
FBPORTCX: AND     #$FE
          CMP     #(TOW0 & $FF)/4
          BNE     DOCXYS               ;NOT TOWER
;TOWER, FUDGE YPOS TO TOP
          LDA     OBJAY,X
          BMI     NOFUDGE1             ;SPECIAL CASE MINUS
          CMP     #MIDY-$10
          BCC     NOFUDGE1
          LDA     #MIDY-$10
NOFUDGE1: STA     T1                   ;STORE SCREEN Y
          LDA     #MIDY                ;DERIVE HEIGHT
          SBC     OBJAY,X
          LSR
          TAY
          LDA     TOWHGTS,Y
          SBC     #16
          CLC
          ADC     T1                   ;ADD TO YPOS OR MIDY-$10
          JMP     DOCXYS1
TONOCXX:  JMP     NOCXX
TONOCXY:  JMP     NOCXY
;CHECK IN Y
DOCXYS:   LDA     OBJAY,X
DOCXYS1:  SEC
          SBC     #8
          BMI     SK41                 ;SKIP IF UNDERFLOW
          CMP     CHAIRY
          BCS     TONOCXY
SK41:     ADC     #16
          CMP     CHAIRY
          BCC     TONOCXY
; COLLISION !!!
          LDA     OBJAID,X
          AND     #$FE
          CMP     #(TOW0 & $FF)/4    ;TOWER ?
          BNE     CXELSE
;TOWER TOP CX
          LDA     OBJAID,X
          CMP     #(TOW0 & $FF)/4
          BNE     TONOCXX              ;TOWER TOP GONE
          LDA     #(TOW1 & $FF)/4
          STA     OBJAID,X
;
; SCORE TOWER TOPS
;
          LDA     TOWCNT
          BEQ     GETOUT
          SED
          SEC
          SBC     #1
          STA     TOWCNT
          BNE     SK62
          LDA     #$50
          JSR     ADDM                 ;GOT ALL TOWERS
SK62:
          LDA     TOWSCH               ;LOAD HI TOWER SCORE
          STA     T0
          LDA     TOWSCL
          LSR     T0
          ROR
          LSR     T0
          ROR
          LSR     T0
          ROR
          LSR     T0
          ROR
          CLC
          SED
          JSR     SCOREA
          LDA     T0
          CLC
          SED
          JSR     ADDM

; INCREASE TOWER SCORE
          SED
          LDA     #$2
          CLC
          ADC     TOWSCH
          STA     TOWSCH
          CLD
          LDA     #<(SHOT-1)
          JSR     SNDINI
GETOUT:   JMP     RETURN0              ;DO NEXT
CXELSE:   LDA     OBJAID,X
          CMP     #(DARTHE & $FF)/4
          BCC     DARTHCX              ;DARTH OR TIE
          CMP     #(EXPE & $FF)/4
          BCS     FBCX                 ;FIREBALL OF EXHAUST PORT
          BCC     TONOCXX              ;DEATH STAR OR EXPLOSION
;DARTH OR TIE?
DARTHCX:  CMP     #(TIEE & $FF)/4
          BCC     TIEDEATH
;VADER DEATH
          LDA     #0
          STA     DARTH                ;ALLOW ANOTHER DARTH
          LDA     #(DARTHX & $FF)/4
          STA     OBJAID,X
          LDY     #-$1F
          LDA     OBJAX,X
          CMP     #MIDX
          BCC     SK59
          LDY     #$1F
SK59:     STY     OBJADX,X
          LDY     #-$1F
          LDA     OBJAY,X
          CMP     #MIDY
          BCC     SK60
          LDY     #$1F
SK60:     STY     OBJADY,X
          LDY     #4
          JMP     TIECX
;TIE DEATH
TIEDEATH: LDA     #(EXP0 & $FF)/4
          STA     OBJAID,X
          LDY     #2                   ;POINT TO TIE SCORE
          BNE     TIECX
;FIREBALL DEATH   (AND TRENCH OBJECTS)
FBCX:     ASL
          BPL     FBALLCX
;TRENCH COLLISIONS
          AND     #$8
          BEQ     NOTPORT1
;HIT EXHAUST PORT !!!
          LDY     SHIELDS
          LDA     SHBONUS,Y
          INY                          ;ADD THREE SHIELDS
          INY
          INY
SK64:     CPY     #9
          BCC     SK65
          LDY     #8
SK65:     STY     SHIELDS
          CLC
          SED
          JSR     ADDM                 ;SCORE SHIELDS
;SCORE FORE THE FORCE
          LDA     THEFORCE
          BNE     SK70                 ;NO
          LDY     WAVENO
          LDA     FORBONUS,Y
          SED
          CLC
          JSR     ADDM
SK70:     STX     T1
          JSR     ZOBJECTS
          JMP     MOPORT               ;DO STUFF ELSEWHERE TO EASE BRANCH
PORTRET:
          LDA     #$7F                 ;SET EXPLOSION TIMER
          STA     THEFORCE
          LDA     #$C0
          STA     SUPRESS
          LDA     #0
          STA     FRAME
          STA     FRAME+1
          STA     SCREEN
          LDA     WAVENO               ;ADD ONE TO WAVE NUMBER
          TAY
          INY
          CPY     #8
          BCC     SK66
          LDY     #7
SK66:     STY     WAVENO
          ASL
          CLC
          ADC     #6                   ;FORM SCORE
          TAY
          LDA     #0
          LDX     T1
          JMP     SCOREB               ;WITHOUT SOUND
NOTPORT1: DEC     THEFORCE
          STA     CATAX,X              ;KILL FIREBALL ON TRENCH
          STA     OBJAID,X
FBALLCX:  LDA     #0
          STA     OBJAX,X
TIECX:    JSR     SCORE
          JMP     RETURN0
NOCXX:
NOCXY:    DEX
          BMI     RETURN0
          JMP     CXLOOP
RETURN0:  RTS
;
; MORE EXHAUST PORT STUFF
;
MOPORT:   LDX     #7
          LDA     #MIDX
          LDY     #MIDY
BLOWLOOP: STA     OBJAX,X
          STY     OBJAY,X
          DEX
          BPL     BLOWLOOP
          LDA     #(STAR0 & $FF)/4
          STA     OBJAID
          STA     OBJBID
          STA     OBJCID
          STA     OBJDID
          JMP     PORTRET
;
; SCORE
;
SCORE:    LDA     #<(SHOT-1)
          STY     T1
          JSR     SNDINI
          LDY     T1
SCOREB:   SED
          LDA     SCORTAB+1,Y
          STA     T0                   ;ADD TO LO, MID OR HI BYTE
          LDA     SCORTAB,Y
          CLC
          BIT     T0
          BMI     ADDH
          BVS     ADDM
;ADD TO LO BYTE OF SCORE
SCOREA:   ADC     SCOREL
          STA     SCOREL
          LDA     #0
ADDM:     ADC     SCOREM
          STA     SCOREM
          LDA     #0
ADDH:     ADC     SCOREH
          STA     SCOREH
          CLD
          RTS
;
; SCORE TABLE     BYTE 0 = VALUE       D7= ADD H, D6 = ADD M

SCORTAB:  .byte      3,$00                ;FIREBALL
          .byte      1,$40                ;TIE
          .byte      2,$40                ;DARTH
;DEATH STAR BY WAVE
          .byte      $10,$40
          .byte      $10,$40
          .byte      $65,$40
          .byte      $01,$80
          .byte      $01,$80
          .byte      $01,$80
          .byte      $01,$80
          .byte      $01,$80
;
;SHIELD BONUS TABLE
;
SHBONUS:  .byte      $05,$10,$15,$20,$25,$30,$35,$40
;
; THE FORCE BONUS TABLE
;
FORBONUS: .byte      $05,$10,$15,$25,$50,$95,$95,$95
;
; TOWER INTELLIGENCE
;
TOOUT08:  JMP     OUT08
TOWINT:
          LDA     FRAME
          AND     #$3F
          BNE     TOOUT08              ;NO LAUNCH
;INCREASE TOWER DELTAS
          LDX     #3
DXLP:     LDA     OBJAID,X
          AND     #$FE
          CMP     #(TOW0 & $FF)/4
          BNE     NXTTINT              ;NOT TOWER
;ALTER DX
          DEC     OBJADY,X
          LDA     OBJAX,X              ;LEFT OR RIGHT SCREEN?
          CMP     #MIDX
          INC     OBJADX,X
          BCS     SK30
          DEC     OBJADX,X
          DEC     OBJADX,X
SK30:
NXTTINT:  DEX
          BPL     DXLP
;FIND SLOT
          LDX     #3
LP0:      LDA     OBJAX,X
          BEQ     GOTONE0
          DEX
          BPL     LP0
;NO SLOT
          LDA     #0
          BEQ     NOSLOT
;LAUNCH TOWERS
GOTONE0:
          LDY     PNT
          LDA     (BASE),Y
NOSLOT:   PHA
;DO FIRST
          AND     #$0F                 ;LO IDS
          BEQ     NOLNCH0
          JSR     DOIDS                ;SET UP OBJECT
NOLNCH0:
          LDX     #3                   ;FIRST
LP1:      LDA     OBJAX,X
          BEQ     GOTONE1
          DEX
          BPL     LP1
          PLA
          LDA     #0
          PHA
GOTONE1:  PLA
          LSR
          LSR
          LSR
          LSR
          BEQ     OUT07
          JSR     DOIDS
OUT07:
;
          INC     PNT
          LDA     PNT
          CMP     #$08
          BCC     OUT08                ;STILL IN RANGE
          LDA     #0
          STA     PNT
          LDX     BLOCK
          INX
          CPX     #4
          BCC     OK14
;TURN ON TRENCH SCREEN
          JSR     ZOBJECTS
          INC     SCREEN
          LDA     #$AA
          STA     TOWSCL
          STA     TOWSCH
          STA     TOWCNT
          LDX     #$01
          STX     TIME
          DEX
          STX     THEFORCE
          STX     CATAX
          STX     CATBX
          STX     CATCX
          STX     CATDX
          STX     VERTOFF
          STX     FRAME+1
          STX     BLOCK
          LDA     WAVENO
          ASL
          ASL
          EOR     BLOCK
          AND     #$FC
          EOR     BLOCK
          TAY
          LDA     TRBLOCKS,Y
          STA     BASE
          JMP     OUT08
OK14:     STX     BLOCK
          LDA     WAVENO
          ASL
          ASL
          EOR     BLOCK
          AND     #$FC
          EOR     BLOCK
          TAY
          LDA     BLOCKS,Y
          STA     BASE
OUT08:    RTS
;
; SET UP TOWER SCREEN OBJECTS
;
DOIDS:
          PHA
          AND     #3
          TAY
          LDA     TOWIDS,Y
          PHA                          ;;WHAT TO BIRTH ?
          STY     T0
          CPY     #2                   ;IF 2 THEN IT'S FIREBALL
          BEQ     SK43
          LDA     TOWCNT               ;IF NO TOWERS HIT, THEN FORCE ALL CAPS
          BEQ     SK43                 ;FORCE NO CAP
          CMP     #4
          BCS     FORCECAP
          ROR     RAND
          BCC     SK43
FORCECAP: PLA                          ;GET ID
          AND     #$FE                 ;LAUNCH TOP
          BNE     SK44
SK43:     PLA
SK44:
          STA     OBJAID,X
          PLA
          LSR
          LSR
          TAY
          LDA     TOWXS,Y
          CLC
          ADC     #0                   ;CORRECTED X LAUNCH
;SET UP DX AND DY FOR OBJECTS
          CMP     #160                 ;OUT OF RANGE ?
          BCC     OK13
          SEC
          SBC     #160
OK13:     STA     OBJAX,X
          LDY     T0
          CPY     #2                   ;CHECK ID
          PHP
          LDY     #$-1
          CMP     #MIDX
          BCC     SK31
          LDY     #$1
SK31:     TYA                          ;GET DELTA DELTA
          PLP                          ;FIRE BALL OR TOWER
          BNE     ITTOWER
          EOR     #$FF
          CLC
          ADC     #1
          ASL
          ASL                    ;* 2
          ROL     RANDH                ;ZER DX FOR SOME FIREBALLS
          BCS     SK61
ITTOWER:  LDA     #0
SK61:
          STA     OBJADX,X
          LDA     #MIDY
          STA     OBJAY,X
          LDA     #$-1
          STA     OBJADY,X
          LDY     T0                   ;SEE IF FB
          CPY     #2
          BNE     SK78
          LDA     #<(SSST-1)
          JMP     SNDINI               ;RET FROM THERE
SK78:
          RTS
;
; LAUNCH CATWALKS
;
CATLNCH:
          DEC     TIME
          LDA     TIME
          BNE     OUT18                ;NO LAUNCH
;SET UP TIMER
          LDY     WAVENO
          LDA     CATIMES,Y
          STA     TIME
;FIND SLOT
          LDX     #$03
LP3:      LDA     CATAX,X
          BEQ     GOTONE2
          DEX
          BPL     LP3
;NO SLOT
          BMI     NOLNCH2
;LAUNCH CATWALKS
GOTONE2:
          LDY     PNT
          LDA     (BASE),Y
;DO FIRST
          JSR     TRDOIDS                ;SET UP OBJECT
NOLNCH2:
          LDX     #3                   ;FIRST
LP4:      LDA     CATAX,X
          BEQ     GOTONE3
          DEX
          BPL     LP4
          BMI     SK40                 ;NO SLOTS
GOTONE3:  INC     PNT
          LDY     PNT
          LDA     (BASE),Y
          JSR     TRDOIDS
SK40:
          INC     PNT
          LDA     PNT
          CMP     #16
          BCC     OUT18                ;STILL IN RANGE
          LDA     #0
          STA     PNT
          LDX     BLOCK
          INX
          CPX     #4
          BCC     OK114
;TURN ON SPACE SCREEN
          LDX     #0
          BEQ     OK114
          JSR     ZOBJECTS
          LDA     #$00
          LDX     #3
ZLOOP1:   STA     OBJAID,X
          STA     OBJAX,X
          DEX
          BPL     ZLOOP1
          INX
          STX     SCREEN
OK114:    STX     BLOCK
          LDA     WAVENO
          ASL
          ASL
          EOR     BLOCK
          AND     #$FC
          EOR     BLOCK
          TAY
          LDA     TRBLOCKS,Y
          STA     BASE
OUT18:    RTS
;
; SET UP ONE CATWALK
;
TRDOIDS:
          BEQ     OUT14                ;NO LAUNCH
          STA     OBJAID,X
          PHA
          LDA     #01
          STA     CATAX,X
          LDA     #0
          STA     OBJADX,X
          STA     OBJADY,X
          PLA
          ASL
          BPL     OUT14                ;NOT PORT OR FIREBALL
          DEC     OBJADY,X             ;START MOVING DOWNSCREEN
          CMP     #(EXHAUST << 1) & $FF
          BEQ     DOPORT
;LAUNCH FIREBALL SOUND
          LDA     #<(SSST-1)
          JMP     SNDINI               ;RETURN FROM SND INIT
DOPORT:
          LDA     #MIDY-$10
          STA     OBJAY,X
SK71:
OUT14:    RTS
;
; CATWALK COLLISIONS
;
CATCOL:   LDA     OBJAID,X             ;GET POINTER
          AND     #$1F
          TAY
          LDA     TRBITS,Y
          PHA
          LDA     XWY
          STA     T0
          LDA     XWX
          ASL
          ASL
          ASL
          EOR     T0
          AND     #$F8
          EOR     T0
          TAY
          PLA
          AND     XWCX,Y
          BEQ     NOCATCX
;COLLISION
          JSR     TAKEHIT
NOCATCX:  RTS
;
; TRENCH BIT PATTERNS FOR COLLISION
;
;         D6  D7
;         D4  D5
;         D2  D3
;         D0  D1
;
TRBITS:   .byte      $01,$04,$10,$40
          .byte      $03,$0C,$30,$C0
          .byte      $02,$08,$20,$80
          .byte      0,0,0,0              ;ILLEGAL CATWALKS
          .byte      $05,$14,$50,$00
          .byte      $0F,$3C,$F0,$00
          .byte      $0A,$28,$A0,$00
; MASK FOR CAT COLLISION
XWCX:     .byte      $01,$05,$04,$10,$50,$40,$00,$00
          .byte      $01,$05,$04,$10,$50,$40,$00,$00
          .byte      $03,$0F,$0C,$30,$F0,$C0,$00,$00
          .byte      $02,$0A,$08,$20,$A0,$80,$00,$00
          .byte      $02,$0A,$08,$20,$A0,$80,$00,$00
          BOUNDRY $20
          .byte      "BobSmithWAguilarMBeckerNMcKenzie"
;
; BANK 4
;
   org $2000
   rorg $3000;          ORG     $3000
;
KERNELS:
;
; SET UP SHIELD KERNEL
;
          LDA     SHIELDS
          BPL     SK50
          LDA     #0
SK50:
          STA     HSYNC
          LDY     #0
          STY     VBLNK                ;ENABLE BEAM
          LDY     #8
          STY     T0
          TAY
          ASL
          ASL
          ASL
          CLC
          ADC     #8
          TAX                          ;NUMBER POINT
          LDA     SHIELDPT,Y
          TAY                          ;POINT TO SHIELD GRX
          NOP
          LDA     #$F0
          STA     P0HM
          STA     P0HM
          STA     P0HM
          STA     P0RES
;
; SHIELD KERNEL
;
SHKER:    STA     HSYNC
          STA     HMOV
          LDA     NUMBERS,X
          STA     P0GR
          STY     PF2
          DEX
          DEC     T0
          STA     CLRHM
          BPL     SHKER
          LDX     #$7
          TYA
          LDY     #$7F
          STY     T0
TAPERLP:  STA     HSYNC
          AND     T0
          STA     PF2
          LSR     T0
          DEX
          BPL     TAPERLP
          LDX     #2
          JSR     SETUP
          JSR     SIXCHAR
          LDX     #5
          JSR     SETUP
          LDA     #<(BLANK)
          STA     SCORE3
          JSR     SIXCHAR1
          STY     P0VDEL
          STY     P1VDEL
;
; SET PLAYERS HORIZONTAL POSITIONS
;
          LDA     T7                   ;SIZES
          STA     P0REF
          STA     P0SIZE
          LDA     T10
          STA     P0CLR
          LDA     T8                   ;SIZES
          STA     P1REF
          STA     P1SIZE
          LDA     T11
          STA     P1CLR
          STA     HSYNC
          LDA     T5
          STA     P0HM
          AND     #$F
          TAY
;         NOP
          NOP
LOOP1:    DEY
          BPL     LOOP1
          NOP
          NOP
          STA     P0RES
          STA     HSYNC
          LDA     T6
          STA     P1HM
          AND     #$F
          TAY
;         NOP
          NOP
LOOP2:    DEY
          BPL     LOOP2
          NOP
          NOP
          STA     P1RES
;
; KERNEL SETUPS
;
          STA     HSYNC
          STA     HMOV
          LDA     #0
          STA     T2
          STA     T3                   ;KERNELS EXPECT T3 ZEROED
          STA     T0
          STA     T5
          LDA     FRAME
          LSR
          LDA     T4                   ;GET BALL HM
          BCC     SKIP06
          EOR     #$F0
          CLC
          ADC     #$10
SKIP06:   STA     CLRHM
          STA     BHM
;
; SELECT SCREEN
;
          STA     HSYNC
          LDX     #BGR
          TXS
          LDX     #115
          LDA     SCREEN
          CMP     #2
          BCS     DOTRENCH
          JMP     SPACEKER
DOTRENCH:
;
; GET IN SYNC FOR TRENCH SCREEN
;
          STA     HSYNC
          NOP
          NOP
          NOP
          NOP
          LDY     #24
          STY     TUNPNT
          STY     TUNPNT1
          LDA     (HMTAB1),Y           ;PRELOAD FOR KERNEL
          STA     T4
          LDA     #2
          STA     M1GR
          JMP     KENTRY               ;MC 32

          BOUNDRY 245;11

EG00:     CLC                          ;OFF PAGE
          LDA     T0
          BCC     NO00
EG01:     CLC                          ;OFF PAGE
          LDA     T0
          BCC     NO01
SK00:     BNE     RET00                ;FIRST BYTE OFF PAGE
EG02:     CLC
          NOP
          BCC     NO02
EG03:     CLC
          NOP
          BCC     NO03
EG04:     CLC
          NOP
          BCC     NO04
;
;         TRENCH KERNEL    LINE 1
;
KENTRY:   LDY     TUNPNT               ;35 MC
          DEC     TUNPNT               ;40 MC
KERNEL:
          LDA     (HMTAB),Y            ;45 MC
          STA     M1HM                 ;48 MC
          STA     T1                   ;51 MC
          TXA                          ;53 MC
          CLC                          ;55 MC
          SBC     P0Y                  ;58 MC
;
          CMP     SIZE0                ;61 MC  SIZE OF P0
          TAY                          ;63 MC
          BCS     EG00                 ;65/66 MC
          STY     T2                   ;68 MC
          LDA     (P0GX),Y             ;73 MC
          STA     P0GR                 ;76 MC
NO00:
;
          STA     HMOV                 ;3 MC
;
          DEX                          ;5 MC
          TXA                          ;7 MC
          SBC     P1Y                  ;10 MC
          TAY                          ;12 MC
          CMP     SIZE1                ;15 MC
          BCS     EG01                 ;17/18 MC
          STY     T3                   ;20 MC
          LDA     (P1GX),Y             ;25 MC
          STA     P1GR                 ;28 MC
NO01:
          TXA                          ;30 MC
          SBC     M1Y                  ;33 MC
          AND     #$F8                 ;35 MC
          PHP
          PLA                          ;42 MC
;
          LDA     T1                   ;45 MC
          ASL
          ASL
          ASL
          ASL                    ;53 MC
          STA     M1HM                 ;56 MC
;
; LINE TWO
;
;
          DEX                          ;58 MC
          LDY     T2                   ;61 MC
          DEY                          ;63 MC
          BMI     EG02                 ;65/66 MC
          LDA     (P0GX),Y             ;70 MC
          STA     P0GR                 ;73 MC
NO02:
          STA     HSYNC                ;76 MC
          STA     HMOV                 ;3 MC
;          .byte      $AC
;          .word      T3                   ;7 MC
         LDY.W T3
          DEY                          ;9 MC
          BMI     EG03                 ;11/12 MC
          LDA     (P1GX),Y             ;16 MC
          STA     P1GR                 ;19 MC
NO03:
          CPX     TRIG                 ;22 MC
          BNE     SK00                 ;24/25 MC
          LDA     #2                   ;26 MC
          STA     M0GR                 ;29 MC
RET00:
;
          DEC     TUNPNT               ;34 MC
          LDY     TUNPNT               ;37 MC
          BPL     KERNEL               ;39/40 MC
;
; MIDDLE SCREEN KERNEL
;
          NOP                          ;41 MC
          NOP                          ;43 MC
TOP:      TXA                          ;45 MC
          CLC                          ;47 MC
          NOP                          ;49 MC
          SBC     P0Y                  ;52 MC
;
          CMP     SIZE0                ;55 MC SIZE OF P0
          TAY                          ;57 MC
          BCS     EG04                 ;59/60 MC
          LDA     (P0GX),Y             ;64 MC
          STA     P0GR                 ;67 MC
NO04:
          DEX                          ;69 MC
          TXA                          ;71 MC
          SBC     P1Y                  ;74 MC
          TAY                          ;76 MC
          STA     HMOV                 ;3 MC
;
          CMP     SIZE1                ;6 MC
          BCS     EG05                 ;8/9 MC
          LDA     (P1GX),Y             ;13 MC
          STA     P1GR                 ;16 MC
NO05:
          TXA                          ;18 MC
          SBC     M1Y                  ;21 MC
          AND     #$F8                 ;23 MC
          PHP
          PLA                          ;30 MC
;
          LDA     PFTABLE-49,X         ;34 MC
          STA     PF2                  ;37 MC
          CPX     EXIT                 ;40 MC
          BCS     TOP                  ;42/43 MC
          LDA     T4                   ;45 MC  HMOV EVALUE
          JMP     BOTENTRY             ;48 MC
;
;
;
; BOTTOM SCREEN KERNELS
; ODD LINES
KERNEL1:
          LDA     (HMTAB1),Y
          STA     T4
BOTENTRY: STA     M1HM                 ;51 MC
          TXA                          ;53 MC
          CLC
          SBC     P0Y
;
          TAY
          CMP     SIZE0                ;SIZE OF P0
          BCS     EG06
          STY     T0
          LDA     (P0GX),Y
          STA     P0GR
NO06:
          STA     HMOV
;
          DEX
          TXA
          SBC     P1Y
          TAY
          CMP     SIZE1
          BCS     EG07
          STY     T5
          LDA     (P1GX),Y
          STA     P1GR
NO07:
          TXA
          SBC     M1Y
          AND     #$F8
          PHP
          PLA
;
          LDA     T4
          ASL
          ASL
          ASL
          ASL
          STA     M1HM
;
; LINE TWO
;         EVEN LINES
;
          DEX
          LDY     T0
          DEY
          BMI     NO08
          LDA     (P0GX),Y
          STA     P0GR
NO08:
          STA     HSYNC
          STA     HMOV
          LDY.W   T5
;          .byte      $AC                  ;ABS LDY
;          .word      T5
;
          DEY
          BMI     EG09
          LDA     (P1GX),Y
          STA     P1GR
NO09:
          CPX     TRIGA
          BNE     SK02
          LDA     #0
          STA     M0GR
RET02:
;
          DEC     TUNPNT1
          LDY     TUNPNT1
          BPL     KERNEL1
          BMI     XWSETUP
          BOUNDRY 255;1
SK02:     BNE     RET02                ;START ON PAGE
EG05:     CLC
          BCC     NO05
EG06:     CLC                          ;OFF PAGE
          LDA     T0
          BCC     NO06
EG07:     CLC                          ;OFF PAGE
          LDA     T0
          BCC     NO07
EG09:     CLC
          BCC     NO09
XWSETUP:
;
; SET UP FOR X-WING KERNEL
;
          STA     HSYNC
          LDA     #0
          STA     P0GR
          STA     P1GR
          STA     M0GR
          STA     M1GR
          STA     BGR
          STA     P1REF
          STA     P0RES
          NOP
          LDY     #8
          STY     P0REF                ;REFLECT P1
          LDA     #$80
          STA     M0HM
          LDA     #$10
          STA     M1HM
          LDA     #$15                 ;TWO CLOCK PLAYER AND BALL
          STA     M0RES
          STA     M1RES
          STA     P0SIZE
          STA     P1SIZE
XWH:      EQU     *+1
          LDY     #24                  ;LINE COUNT FOR X-WING
          LDA     #$88
          STA     P0CLR
          STA     P1CLR
          STA     P1RES
;
;         X-WING KERNEL
;
FUSEKER:  STA     HSYNC
          STA     HMOV
          LDA     GUNS,Y
          STA     P0GR
          STA     P1GR
          LDA     FUSE,Y
          STA     PF2
          CPY     #25
          BCS     SKIP04
          LDA     #2
          STA     M1GR
          STA     M0GR
SKIP04:   STA     CLRHM                ;STOP HMOVES
          LDA     FUSEHM0,Y
          STA     M0HM
          LDA     FUSEHM1,Y
          STA     M1HM
          DEY
          BPL     FUSEKER
;
; END OF KERNELS
;
          LDX     #$FF
          TXS
          INX
          STX     M0GR
          STX     M1GR
          JMP     OSCAN
EGBB:     LDA     #0
          STA     P0GR
          BCS     NOBB
EGA:      CLC
          NOP
          BCC     NOA
EGAA:     LDA     #0
          STA     P1GR
          BCS     NOAA
;
; SPACE TOWER KERNEL
;
SPACEKER:
SPLOOP:   LDA     #0
          STA     M0GR
          STA     M1GR
          TXA
          CLC
          SBC     P0Y
          TAY
          CMP     SIZE0
          BCS     EGBB
          LDA     (P0GX),Y
          .byte      $8D,P0GR,$00
;         STA     P0GR
NOBB:
          STA     HSYNC
          STA     HMOV                 ;3 MC
          TXA                          ;5 MC
          CLC                          ;7 MC
          SBC     P1Y                  ;10 MC
          TAY                          ;12 MC
          CMP     SIZE1                ;15 MC
          BCS     EGA                  ;17 MC
          LDA     (P1GX),Y             ;22 MC
          STA     P1GR                 ;25 MC
NOA:
; CROSS HAIRS/STARS
          DEX                          ;27 MC
          TXA                          ;29 MC
          CLC                          ;31 MC
          SBC     M1Y                  ;34 MC
          AND     #$F8                 ;36 MC
          PHP                          ;39 MC
          CPX     ST1Y                 ;42 MC
          PHP                          ;45 MC
          CPX     ST2Y                 ;48 MC
          PHP                          ;51 MC
          TXA                          ;53 MC
          CLC                          ;55 MC
          SBC     P0Y                  ;58 MC
          TAY                          ;60 MC
          CMP     SIZE0                ;63 MC
          BCS     NOB0                 ;65 MC
          LDA     (P0GX),Y             ;70 MC
          STA     P0GR                 ;73 MC
NOB0:
          STA     HSYNC                ;76 MC
          STA     HMOV                 ;3 MC
          TXA                          ;5 MC
          CLC                          ;7 MC
          SBC     P1Y                  ;10 MC
          TAY                          ;12 MC
          CMP     SIZE1                ;15 MC
          BCS     EGAA                 ;17 MC
          LDA     (P1GX),Y             ;22 MC
          .byte      $8D,P1GR,$00
;         STA     P1GR                 ;25 MC
NOAA:
          TXA                          ;27 MC
          LDX     #BGR                 ;29 MC
          TXS                          ;31 MC
          TAX                          ;33 MC
          DEX                          ;35 MC
          BPL     SPLOOP               ;38 MC
          JMP     XWSETUP              ;DO XWING
;
; LAUNCH MISSILES
;
LALASER:  BIT     TRIG0
          BPL     TRIGS1               ;TRIGGER PRESSED
          ASL     DEBOUNCE
          CLC
          ROR     DEBOUNCE               ;RESET D7 TO SHOW STICK OFF
          JMP     NOTRIG
TRIGS1:   LDA     LAZDY                ;IN FLIGHT?
          BNE     NOTRIG
          BIT     DEBOUNCE               ;CHECK DEBOUNCE BIT
          BMI     NOTRIG
          LDA     SUPRESS
          BNE     NOTRIG
;FIRE AWAY
          LDA     #<(EXPLO-1)            ;START SOUND
          JSR     SNDINI
          ASL     DEBOUNCE
          SEC
          ROR     DEBOUNCE
          LDA     #$F8
          STA     LAZY
          LDA     #LEGUN               ;LEFT GUN XPOS
          STA     LAZAX
          LDA     CHAIRY
          CLC
          ADC     #8
          STA     LAZDY
          LDA     CHAIRX
          SEC
          SBC     #LEGUN-4
          STA     LAZADX
;TEMP DELTAS SET UP, DERIVE SLOPE AND FUDGE XPOS
          JSR     FINDSL               ;DO IT
          STY     LAZHM                ;HOLD LASER HMOVE VALUE
          JMP     SKIP07               ;NOT VERTICAL
          LDA     LAZADX               ;FUDGE XPOS
          SEC
          SBC     #8
          STA     LAZADX
          LDA     LAZAX
          SEC
          SBC     #8
          STA     LAZAX
SKIP07:
;DO RIGHT GUN
          LDA     #RIGUN-4
          STA     LAZBX
          SEC
          SBC     CHAIRX
          STA     T1
          JSR     FINDSL
          TYA
          LSR
          LSR
          LSR
          LSR
          ORA     LAZHM
          STA     LAZHM                ;HOLD LASER HMOVE
          LDX     #0
          CPY     #$10
          BNE     SKIP08               ;NOT 45
          LDX     #$8
SKIP08:   CPY     #$20
          BNE     SKIP09               ;NOT 30
          LDX     #$10
SKIP09:
          LDA     T1                   ;GET IITIAL DELTA X
          STX     T1
          SEC
          SBC     T1
          EOR     #$FF                 ;MAKE DELTA NEGATIVE
          CLC
          ADC     #1
          STA     LAZBDX
          LDA     LAZBX
          SEC
          SBC     T1
          STA     LAZBX
          LDA     #0
          STA     CHAIRDX
          STA     CHAIRDY
NOTRIG:
          RTS
;
; FIND SLOPE OF LASER SHOTS
; A ENTERS WITH DELTA X FOR SHOT
;
FINDSL:
          ASL
          CMP     LAZDY
          BCS     SLANT
; MUST BE VERTICAL
          LDY     #0                   ;SET UP HMOVE VALUE
          BCC     OUT02                ;FINISHED
SLANT:    LSR
          LSR
          CMP     LAZDY
          BCC     FORTYFV              ;45 DEGREE
;30 DEGREE ANGLE
          LDY     #$20                 ;HMOVE FOR SLOPE OF 1/2
          BCS     OUT02
;45 DEGREE ANGLE
FORTYFV:  LDY     #$10
OUT02:    TYA                          ;SET FLAGS
          RTS
;
;         OVERSCAN
;
OSCAN:
          LDA     #$26                 ; TIMER
          STA     TIMD64
;
; PHI ROUTINE
;
CALCVEL:
          LDA     FRAME
          AND     #7
          TAY
          LDA     PHI,Y
          STA     T0                   ;HOLD COPY OF THIS FRAMES PHI
;
          LDX     #6
DELTLOOP: LDA     CHAIRX,X
          BEQ     TONEXT
          LDA     CHAIRDX,X
          CLC
          ADC     T0
          LSR
          LSR
          LSR
          EOR     #$10
          SEC
          SBC     #$10
          CLC
          ADC     CHAIRX,X
          CMP     #148
          BCC     OK04
KILLKILL:
;OUT OF RANGE, KILL
          LDA     #0
          STA     CHAIRDX,X
          STA     CHAIRDY,X
OK04:     STA     CHAIRX,X
          LDA     CHAIRDY,X
          CLC
          ADC     T0
          LSR
          LSR
          LSR
          EOR     #$10
          SEC
          SBC     #$10
          CLC
          ADC     CHAIRY,X
          CMP     #$F0
          BCS     OK05
          CMP     #115
          BCC     OK05
;OUT OF RANGE, KILL
;CHECK FOR SHIP HIT BY TOWER
          LDA     OBJAID-3,X           ;GET ID
          STX     T1
          CMP     #EXHAUST             ;PORT ?
          BNE     SK75
;PORT HS SCROLLED OFF, STAY IN TRENCH
          LDA     #0
          STA     OBJAID-3,X
          STA     CATAX-3,X
          LDA     #<(ROBOT-1)
          JSR     SNDINI
          LDX     #0
          STX     PNT                  ;START PATTERN OVER
          STX     BLOCK
          LDA     WAVENO
          ASL
          ASL
          EOR     BLOCK
          AND     #$FC
          EOR     BLOCK
          TAY
          LDA     TRBLOCKS,Y
          STA     BASE
          LDX     T1
TONEXT:   JMP     NXTDELT              ;DO NEXT DELTA
SK75:     AND     #$FE
          CMP     #(TOW0 & $FF)/4    ;SEE IF TOWER
          BNE     NOTDEAD0
          LDA     OBJAX-3,X
          SEC
          SBC     #MIDX-$10
          CMP     #$20
          BCS     NOTDEAD0
;TOWER HIT SHIP
          STX     T1
          JSR     TAKEHIT
          LDX     T1
NOTDEAD0:
          LDA     #0
          STA     CHAIRX,X
          STA     CHAIRDX,X
          STA     CHAIRDY,X
OK05:     STA     CHAIRY,X
NXTDELT:  DEX
          BMI     NODELTLP
          JMP     DELTLOOP
NODELTLP:
          JMP     SWLOGIC
PHI:      .byte      5,2,7,4,1,6,3,0
FUSEHM0:  .byte      $00,$00,$00,$10,$00,$00,$10,$00
          .byte      $00,$10,$00,$00,$10,$00,$00,$10
          .byte      $00,$10,$00,$10,$10,$10,$10,$10
          .byte      $10
FUSEHM1:  .byte      $00,$00,$00,$F0,$00,$00,$F0,$00
          .byte      $00,$F0,$00,$00,$F0,$00,$00,$F0
          .byte      $00,$F0,$00,$F0,$F0,$F0,$F0,$F0
          .byte      $F0
VENTA:    .byte      $00,$00,$00,$00,$00,$7E,$42,$42
          .byte      $24,$18,$00,$00,$00,$00,$00,$00
VENTB:    .byte      $00,$00,$00,$00,$FF,$81,$81,$42
          .byte      $42,$3C,$00,$00,$00,$00,$00,$00
VENTC:    .byte      $00,$00,$00,$7E,$42,$42,$42,$24
          .byte      $24,$24,$24,$18,$00,$00,$00,$00
VENTD:    .byte      $00,$00,$FF,$81,$81,$81,$81,$42
          .byte      $42,$42,$42,$24,$24,$3C,$00,$00
;
; DARTH VADER'S SHIP
;
DA0:      .byte      $00,$00,$00,$00,$00,$66,$C3,$DB
          .byte      $FF,$DB,$C3,$66,$00,$00,$00,$00
DA1:      .byte      $00,$00,$00,$00,$00,$1C,$20,$58
          .byte      $5A,$66,$0E,$1C,$00,$00,$00,$00
DA2:      .byte      $00,$00,$00,$00,$0C,$3C,$20,$18
          .byte      $12,$0E,$7C,$38,$00,$00,$00,$00
DA3:      .byte      $00,$00,$00,$00,$00,$3E,$7F,$49
          .byte      $1C,$49,$7F,$3E,$00,$00,$00,$00
DA4:      .byte      $00,$00,$00,$00,$30,$3C,$06,$18
          .byte      $48,$70,$3E,$1C,$00,$00,$00,$00
FUSE:
          .byte      $00,$00,$00,$20,$40,$80
          .byte      $00,$00,$00,$00,$40,$80,$00,$00
          .byte      $40,$80,$00,$00,$00,$80,$00,$00
          .byte      $00,$00
DA5:      .byte      $00,$00,$00,$00,$00,$38,$04,$1A
          .byte      $5A,$66,$70,$38,$00,$00,$00,$00
EX0:      .byte      $00,$00,$00,$00,$30,$40,$70,$24
          .byte      $10,$46,$12,$3C,$08,$00,$00,$00
EX1:      .byte      $00,$08,$18,$30,$80,$00,$1A,$00
          .byte      $04,$64,$60,$05,$2E,$0C,$10,$00
EX2:      .byte      $00,$0C,$AA,$28,$00,$12,$40,$00
          .byte      $02,$C1,$40,$0A,$40,$04,$26,$00
EX3:      .byte      $CC,$40,$0A,$00,$42,$00,$00,$00
          .byte      $80,$81,$00,$00,$01,$80,$56,$46
;
;        MAIN PROGRAM
;
START:    SEI
          CLD                          ; NO DECIMAL
          LDX     #$00
          TXA                          ; CLEAR STELLA AND RAM
CLP:      STA     $0,X
          TXS                          ; THANK YOU DAVE C.
          INX
          BNE     CLP
;
; INITS
;
          LDA     #MIDX-4
          STA     CHAIRX
          LDA     #MIDY
          STA     CHAIRY
          LDA     #$33
          STA     EXIT
;SET UP HI NUMBER INDIRECTION
          LDA     #>(NUMBERS)
          LDX     #11
INITLOOP: STA     SCORE0,X
          DEX
          DEX
          BPL     INITLOOP
          LDX     #$11
          STX     PFCTRL
          LDA     #$AB
          STA     RAND
          STA     SCOREH
          LDA     #$CD
          STA     RANDH
          STA     SCOREM
          LDA     #$EF
          STA     SCOREL
          LDA     #$44
          STA     PFCLR
          LDA     #>(TR00)
          STA     BASE+1
          LDA     #$AA
          STA     TOWSCL
          STA     TOWSCH
          STA     TOWCNT
          LDA     #($80+TUNE1A-TUNE)
          JSR     SNDINI
          LDA     #($80+TUNE1B-TUNE)
          JSR     SNDINI
          LDA     #8
          STA     SHIELDS
          LDA     #$C0
          STA     SUPRESS
          JMP     TOSTART              ;GO BACK TO BANK 7
          BOUNDRY 0
;
; NUMBER SET      0-9  FIRST BYTE IS BOTTOM
;  6 PIXEL WIDE MAXIMUM
;
NUMBERS   EQU     *
          .byte      $00
          .byte      $FE,$86,$86,$82,$82,$82,$FE
          .byte      $00
          .byte      $18,$18,$18,$18,$08,$08,$08
          .byte      $00
          .byte      $FE,$C0,$C0,$FE,$02,$82,$FE
          .byte      $00
          .byte      $FE,$86,$06,$7E,$04,$84,$FC
          .byte      $00
          .byte      $0C,$0C,$7E,$44,$44,$44,$40
          .byte      $00
          .byte      $FE,$86,$06,$FE,$80,$80,$FE
          .byte      $00
          .byte      $FE,$86,$86,$FE,$80,$82,$FE
          .byte      $00
          .byte      $0C,$0C,$0C,$0C,$04,$04,$7C
          .byte      $00
          .byte      $FE,$86,$86,$FE,$44,$44,$7C
          .byte      $00
          .byte      $06,$06,$06,$FE,$82,$82,$FE
;
BLANK     .byte      0,0,0,0,0,0,0,0
;
; COPYRIGHT MESSAGE
;
COPY1:    .byte      $00,$3C,$42,$99,$91,$99,$42,$3C
COPY2:    .byte      $00,$00,$68,$48,$4C,$48,$4E,$00
COPY3:    .byte      $00,$00,$C1,$89,$9D,$89,$80,$00
COPY4:    .byte      $00,$00,$49,$C9,$49,$49,$9C,$00
COPY5:    .byte      $00,$00,$55,$D5,$59,$55,$99,$00
;
; tie fighters
;
TF0:      .byte      $00,$00,$00,$00,$00,$81,$C3,$DB
          .byte      $FF,$DB,$C3,$81,$00,$00,$00,$00
TF1:      .byte      $00,$00,$00,$00,$08,$1C,$20,$58
          .byte      $DA,$67,$0E,$1C,$08,$00,$00,$00
TF2:      .byte      $00,$00,$00,$00,$0E,$3C,$60,$18
          .byte      $13,$0E,$3C,$70,$00,$00,$00,$00
TF3:      .byte      $00,$00,$00,$00,$7F,$3E,$08,$1C
          .byte      $1C,$08,$3E,$7F,$00,$00,$00,$00
TF4:      .byte      $00,$00,$00,$00,$70,$3C,$06,$18
          .byte      $C8,$70,$3C,$0E,$00,$00,$00,$00
TF5:      .byte      $00,$00,$00,$00,$10,$38,$04,$1A
          .byte      $5B,$E6,$70,$38,$10,$00,$00,$00
FBA:      .byte      $00,$00,$00,$10,$04,$54,$08,$22
          .byte      $0C,$0A,$20,$08,$00,$00,$00,$00
          BOUNDRY 0
SHIELDPT: .byte      $00,$80,$C0,$E0,$F0,$F8,$FC,$FE,$FF
;
; TRENCH HMOVE TABLES
;
L0BOT:    .byte      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
L0:       .byte      $40,$44,$44,$44,$44,$44,$44,$44
          .byte      $44,$44,$04,$00,$00,$00,$00,$00
          .byte      $00,$00
L1BOT:    .byte      0,0,0,0,0,0
L1:       .byte      $20,$22,$22,$22,$22,$22,$22,$22
          .byte      $22,$22,$22,$22,$22,$22,$22,$22
          .byte      $22,$22,$22,$22,$20,$00,$00,$00
L2:       .byte      $20,$11,$12,$21,$11,$12,$21,$11
          .byte      $12,$21,$11,$12,$21,$11,$12,$21
          .byte      $11,$12,$21,$11,$12,$21,$11,$12
          .byte      $21
L3:       .byte      $10
          .byte      $11
          .byte      $11
          .byte      $11
          .byte      $11
          .byte      $11
          .byte      $11
          .byte      $11
          .byte      $11
          .byte      $11
          .byte      $11
          .byte      $11
          .byte      $11
          .byte      $11
          .byte      $11
          .byte      $11
          .byte      $11
          .byte      $11
          .byte      $11
          .byte      $11
          .byte      $11
          .byte      $11
          .byte      $11
          .byte      $11
          .byte      $11
L4:       .byte      $10,$01,$11,$01,$11,$01,$11,$01
          .byte      $11,$01,$11,$01,$11,$01,$11,$01
          .byte      $11,$01,$11,$01,$11,$01,$11,$01
          .byte      $11
L5        .byte      $10,$10,$10,$01,$01,$11,$10,$10
          .byte      $01,$01,$11,$10,$10,$01,$01,$11
          .byte      $10,$10,$01,$01,$11,$10,$10,$01
L6:       .byte      $10
          .byte      $10
          .byte      $10
          .byte      $10
          .byte      $10
          .byte      $10
          .byte      $10
          .byte      $10
          .byte      $10
          .byte      $10
          .byte      $10
          .byte      $10
          .byte      $10
          .byte      $10
          .byte      $10
          .byte      $10
          .byte      $10
          .byte      $10
          .byte      $10
          .byte      $10
          .byte      $10
          .byte      $10
          .byte      $10
          .byte      $10
          .byte      $10
L7:       .byte      $10
          .byte      $10,$00
          .byte      $10,$00
          .byte      $10,$00
          .byte      $10,$00
          .byte      $10,$00
          .byte      $10,$00
          .byte      $10,$00
          .byte      $10,$00
          .byte      $10,$00
          .byte      $10,$00
          .byte      $10,$00
          .byte      $10,$00
PFTABLE:  .byte      0,$00,$80,0,0,0,0,0,0,0,0,$0,0,0,0,0,0,0,0,0,0
          BOUNDRY 0
R0BOT:    .byte      0,0,0,0,0,0,0,0,0,0,0,0,0,0,$C0,$CC
R0:       .byte      $C0,$CC,$CC,$CC,$CC,$CC,$CC,$CC
          .byte      $CC,$00,$00,$00,$00,$00,$00,$00
          .byte      $00,$00,$00,$00,$00,$00,$00,$00
R1BOT:    .byte      0,0,0,0,$EE,$EE,$EE
R1:       .byte      $E0,$EE,$EE,$EE,$EE,$EE,$EE,$EE
          .byte      $EE,$EE,$EE,$EE,$EE,$EE,$EE,$EE
          .byte      $EE,$EE,$00,$00,$00,$00,$00,$00
R2:       .byte      $E0,$FF,$FE,$EF,$FF,$FE,$EF,$FF
          .byte      $FE,$EF,$FF,$FE,$EF,$FF,$FE,$EF
          .byte      $FF,$FE,$EF,$FF,$FE,$EF,$FF,$FE
          .byte      $EF
R3:       .byte      $F0
          .byte      $FF
          .byte      $FF
          .byte      $FF
          .byte      $FF
          .byte      $FF
          .byte      $FF
          .byte      $FF
          .byte      $FF
          .byte      $FF
          .byte      $FF
          .byte      $FF
          .byte      $FF
          .byte      $FF
          .byte      $FF
          .byte      $FF
          .byte      $FF
          .byte      $FF
          .byte      $FF
          .byte      $FF
          .byte      $FF
          .byte      $FF
          .byte      $FF
          .byte      $FF
          .byte      $FF
R4:       .byte      $F0,$F0,$FF,$F0,$FF,$F0,$FF,$F0
          .byte      $FF,$F0,$FF,$F0,$FF,$F0,$FF,$F0
          .byte      $FF,$F0,$FF,$F0,$FF,$F0,$FF,$F0
          .byte      $FF
R5:       .byte      $F0,$F0,$F0,$0F,$0F,$FF,$F0,$F0
          .byte      $0F,$0F,$FF,$F0,$F0,$0F,$0F,$FF
          .byte      $F0,$F0,$0F,$0F,$FF,$F0,$F0,$0F
R6:       .byte      $F0
          .byte      $F0
          .byte      $F0
          .byte      $F0
          .byte      $F0
          .byte      $F0
          .byte      $F0
          .byte      $F0
          .byte      $F0
          .byte      $F0
          .byte      $F0
          .byte      $F0
          .byte      $F0
          .byte      $F0
          .byte      $F0
          .byte      $F0
          .byte      $F0
          .byte      $F0
          .byte      $F0
          .byte      $F0
          .byte      $F0
          .byte      $F0
          .byte      $F0
          .byte      $F0
          .byte      $F0
R7:       .byte      $F0
          .byte      $F0,$00
          .byte      $F0,$00
          .byte      $F0,$00
          .byte      $F0,$00
          .byte      $F0,$00
          .byte      $F0,$00
          .byte      $F0,$00
          .byte      $F0,$00
          .byte      $F0,$00
          .byte      $F0,$00
          .byte      $F0,$00
          .byte      $F0,$00
;
GUNS:     .byte      0,0
          .byte      $02,$02,$64,$D5,$D5,$CA,$AA,$2C
          .byte      $16,$1A,$1D,$35,$35,$35,$30,$67
          .byte      $6E,$60,$C0,$C0,$80,$00,$00
;
          BOUNDRY 0
TOWERB0:
          .byte      $92
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $44,$54,$7C,$7C,$7C,$7C,$38,$10
TOWER0:   .byte      $00
TOWERB1:
          .byte      $92
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $54
          .byte      $44,$04,$00,$00,$00,$00,$00,$00
TOWER1:   .byte      $00
;
; CATWALK GRAPHICS
;
FES:
          .byte      $00,$FE,$00,$00
          .byte      $00,$FE,$00,$00
          .byte      $00,$FE,$00,$00
          .byte      $00,$FE,$00,$00
          .byte      $00,$FE,$00,$00
          .byte      $00,$FE,$00,$00
          .byte      $00,$FE,$00,$00
          .byte      $00,$FE,$00,$00
          .byte      $00,$FE,$00,$00
          .byte      $00,$FE,$00,$00
          .byte      $00,$FE,$00,$00
          .byte      $00,$FE,$00,$00
          .byte      $00,$FE,$00,$00
          .byte      $00,$FE,$00,$00
FFS:
          .byte      $00,$FF,$00,$00
          .byte      $00,$FF,$00,$00
          .byte      $00,$FF,$00,$00
          .byte      $00,$FF,$00,$00
          .byte      $00,$FF,$00,$00
          .byte      $00,$FF,$00,$00
          .byte      $00,$FF,$00,$00
          .byte      $00,$FF,$00,$00
          .byte      $00,$FF,$00,$00
          .byte      $00,$FF,$00,$00
          .byte      $00,$FF,$00,$00
          .byte      $00,$FF,$00,$00
          .byte      $00,$FF,$00,$00
          .byte      $00,$FF,$00,$00
F0S:
          .byte      $00,$F0,$00,$00
          .byte      $00,$F0,$00,$00
          .byte      $00,$F0,$00,$00
          .byte      $00,$F0,$00,$00
          .byte      $00,$F0,$00,$00
          .byte      $00,$F0,$00,$00
          .byte      $00,$F0,$00,$00
          .byte      $00,$F0,$00,$00
          .byte      $00,$F0,$00,$00
          .byte      $00,$F0,$00,$00
          .byte      $00,$F0,$00,$00
          .byte      $00,$F0,$00,$00
          .byte      $00,$F0,$00,$00
          .byte      $00,$F0,$00,$00
;
; DEATH STAR GRAPHICS
;
FBB:      .byte      $00,$10,$20,$12,$44,$15,$8A,$21
          .byte      $8C,$0A,$20,$48,$04,$08,$00,$00
FBC:      .byte      $00,$10,$08,$20,$08,$50,$04,$48
          .byte      $12,$28,$04,$08,$20,$08,$10,$00,$00
FBD:      .byte      $00,$10,$20,$0A,$04,$08,$12,$05
          .byte      $48,$04,$A8,$40,$08,$20,$48,$04,$10
;
; SET UP INDIRECTION FOR SIXCHAR
; X POINTS TO THREE BYT VALUE
SETUP:    LDY     #10                  ;POINT TO INDIRECTION
SETLOOP:  LDA     SCOREH,X
          PHA
          ASL
          ASL
          ASL
          AND     #$78
          STA     SCORE0,Y
          DEY
          DEY
          PLA
          LSR
          AND     #$78
          STA     SCORE0,Y
          DEX
          DEY
          DEY
          BPL     SETLOOP
          RTS
          BOUNDRY 0
F8S:
          .byte      $00,$F8,$00,$00
          .byte      $00,$F8,$00,$00
          .byte      $00,$F8,$00,$00
          .byte      $00,$F8,$00,$00
          .byte      $00,$F8,$00,$00
          .byte      $00,$F8,$00,$00
          .byte      $00,$F8,$00,$00
          .byte      $00,$F8,$00,$00
          .byte      $00,$F8,$00,$00
          .byte      $00,$F8,$00,$00
          .byte      $00,$F8,$00,$00
          .byte      $00,$F8,$00,$00
          .byte      $00,$F8,$00,$00
          .byte      $00,$F8,$00,$00
FCS:
          .byte      $00,$FC,$00,$00
          .byte      $00,$FC,$00,$00
          .byte      $00,$FC,$00,$00
          .byte      $00,$FC,$00,$00
          .byte      $00,$FC,$00,$00
          .byte      $00,$FC,$00,$00
          .byte      $00,$FC,$00,$00
          .byte      $00,$FC,$00,$00
          .byte      $00,$FC,$00,$00
          .byte      $00,$FC,$00,$00
          .byte      $00,$FC,$00,$00
          .byte      $00,$FC,$00,$00
          .byte      $00,$FC,$00,$00
          .byte      $00,$FC,$00,$00
DSTAR:    .byte      $00,$00,$00,$3C,$66,$D3,$A9,$FF
          .byte      $87,$CB,$6E,$3E,$00,$00,$00,$00
;
; SIX CHARACTER ROUTINE
;
SIXCHAR:
          STA     HSYNC
          LDY     #1
          NOP
          NOP
          NOP
          NOP
          LDA     #$D8
          STA     P0CLR
          STA     P1CLR
          LDA     #0
          STA     P1REF
          STA     P0REF
          LDA     #3                   ; DO SCORE RESET
          STA     P1SIZE               ; TRIPLE COPIES CLOSE
          STA     P0SIZE
          LDA     #$F0
          STA     P1RES                ;39 MC
          STA     P0RES
          STA     P1HM
          STA     HSYNC                ;FOR HMOVE
          STA     HMOV
          STY     P1VDEL
          STY     P0VDEL
          LDA     #0
          STA     P0GR
          STA     P1GR
          STA     P0GR
SIXCHAR1: LDY     #7
;
;
; SIX CHARACTER ROUTINE
;
SCKRNL:   STY     T1
          LDA     (SCORE0),Y
          STA     P1GR
          STA     HSYNC
          LDA     (SCORE1),Y
          STA     P0GR
          LDA     (SCORE2),Y
          STA     P1GR
          LDA     (SCORE3),Y
          STA     T2
          LDA     (SCORE4),Y
          TAX
          LDA     (SCORE5),Y
          TAY
          LDA     T2
          STA     P0GR
          STX     P1GR
          STY     P0GR
          STY     P1GR
          LDY     T1
          DEY
          BPL     SCKRNL
          INY
          STY     P1GR
          STY     P0GR
          STY     P1GR
          STY     P0GR
          RTS
;
; BANK 7
;
   org $2C00
   rorg $3C00
;          ORG     $3C00
;
POWERUP:  STA     $1FED                ;3400 -> B1
          JMP     START
TOSTART:
          STA     $1FE0                ;1000 -> B0
          STA     $1FE9                ;1400 -> B1
          STA     $1FF2                ;1800 -> B2
          JMP     SCRNTOP
;
; SWITCH IN GRAPHICS KERNEL BANKS (3000-
;
SWGRX:    STA     $1FE4                ;3000 -> B0
          STA     $1FED                ;3400 -> B1
          STA     $1FF6                ;3800 -> B2
          JMP     KERNELS
;
; SWITCH IN LOGIC BANKS (1000 -
;
SWLOGIC:  STA     $1FE0                ;1000 -> B0
          STA     $1FE9                ;1400 -> B1
          STA     $1FF2                ;1800 -> B2
          JMP     OVSCAN
;
; JUMP TO COLLISION DETECT
;
CXDETECT: STA     $1FF3                ;5800 -> B2
          JSR     CHAIRCX
          STA     $1FF2                ;1800 -> B2
          JMP     OK06
;
; GO TO LAUNCH LASER ROUTINE
;
TOLASER:  STA     $1FE4                ;3000 -> B0
          JSR     LALASER
          STA     $1FE0                ;1000 -> B0
          JMP     RETLASER
;
; JUMP TO TOWER INTELLIGENCE
;
TOTOWINT: STA     $1FF3
          JSR     TOWINT
          STA     $1FF2
          JMP     OUT13
TOCATCX:  STA     $1FF3
          JSR     CATCOL
          STA     $1FF2
          JMP     CXRET
TOCATLCH: STA     $1FF3
          JSR     CATLNCH
          STA     $1FF2
          JMP     OUT13
; **** CALL SNDINI WITH A = SOUND ID ****
SNDINI:
          LDX     #0
          LDY     SCHAN1
          BEQ     SI1                  ; IF 0, USE CHANNEL
          INX
          LDY     SCHAN2
          BEQ     SI1                  ; IF 0, STEP ON CHANNEL IMMEDIATELY
          CMP     SCHAN2
          BCC     SI1                  ; IF NEW SOUND IS LOWER #, REPLACE
          DEX                          ; X = 0
          CMP     SCHAN1               ; TRY OTHER CHANNEL
          BCS     SIX                  ; NEW SOUND IS NOT HIGH ENOUGH PRIO
SI1:
          LDY     #$1F
          STY     SNDV0,X              ; HIT MAX VOL. REGISTER
          STA     SCHAN1,X             ; SAVE A INTO SOUND RAM
          ROL                    ; ROLL 2 BIT INTO C
          BCC     SI2                  ; NOT A TUNE
          LDY     #1                   ; TUNE: GRAB ON NEXT FRAME
SI2:
          STY     STIM1,X
SIX:
          RTS
;
; SET UP CATWALKS
;         TFF-T0  JMP INDIRECT FOR XTSLOPE
;         T1 =    0-3 POINT TO OBJECT
;         T2 =    0-1 PLAYER NUMBER
;         T3 =    0-3 POINT TO GRX INDIRECTION
;         T4 =    DONT USE !
;         T5-T6   XPOS IN HM/DELAY FORMAT
;         T7-T8   WIDTH
;
DOCATS:
;
; ADJUST FOR HORIZONTAL POSITION
;
          LDY     CATAX,X              ;GET XPOS FOR OTION
          LDA     FRAME
SPEED:    AND     #$2
          BNE     SK37
          INY
NOINY:    CPY     #16
          BCC     SK37
          LDA     OBJAID,X
          CMP     #EXHAUST
          BEQ     SK72
          JMP     TOCATCX              ;COLLISION WITH DYING CATWALK
CXRET:
          LDY     #0
          STY     T12
          LDX     T1                  ;GET X BACK
          STY     OBJAID,X
          STY     OBJAX,X
          STY     CATAX,X
          JMP     DEADCAT
SK37:     STY     CATAX,X
SK72:
; DRIVE X POSITION
          LDA     XWX
          ASL
          ASL
          ASL
          ASL
          CLC
          ADC     CATAX,X
          TAY                          ;ADD SLOPE*16 TO XPOS
          LDA     CATXS,Y              ;GET X OFFSET FOR TOP LEFT SLOPE
          STA     T8                   ;STORE *2
          LSR                    ;/2
          STA     TFF                  ;SAVE *1
;TURN T8 INTO ABS POSITION
          LDA     #MIDX-4
          SEC
          SBC     TFF                  ;SUBTRACT OFFSET
          STA     T12
          LDX     T9                   ;POINT TO TRENCH SLOPES
          INX
          LDA     TRPOINT,X
          LSR
          LSR
          LSR
          LSR
          JSR     XTSLOPE              ;FIND Y
          CLC
          ADC     #MIDYA
          STA     TFF                  ;TOP Y
          LDA     #0
          ADC     TX
          STA     TFFA
          LDX     T1
          LDY     CATAX,X              ;GET INDEX TO HEIGHTS
          LDA     CTHEIGHT,Y           ;GET HEIGHT
          PHA                          ;SAVE COPY OF HEIGHT OF RECTANGLE
          LDA     TRHEIGHT,Y
          STA     T0                   ;SAVE HEIGHT
          STA     TX                   ;ALSO COPY IN TX TY
          LDA     OBJAID,X             ;GET VERTICAL LANE (0-3)
          AND     #3
          TAY
          BEQ     DOSUBTR              ;SUBTRACT FULL RECTANGLE
          LSR     T0
          CPY     #2
          BEQ     DOSUBTR              ;WITH 1/2 HEIGHT
          LDA     T0                   ;LOAD 1/2
          LSR     T0                   ;HEIGHT/2/2
          CPY     #3
          BEQ     DOSUBTR
          CLC
          CLC
          ADC     T0
          STA     T0                   ;SUBTRACT .75 HEIGHT
DOSUBTR:  LDA     TFF
          SEC
          SBC     T0                   ;SUBTRACT HEIGHT
          BCS     OK10
          DEC     TFFA                 ;DEC HI BYTE
OK10:
          STA     TFF
;A HAS VERTICAL POSITION
          PLA                          ;GET HEIGHT
          STA     T0
          LDY     T2
          LDA     OBJAID,X
          AND     #$10                 ;CHECK VERT HEIGHT
          BEQ     SK33
          ASL     T0                   ;TWO HIGH
SK33:
          LDA     TFFA
          BPL     NOTNEG               ;POSITION NOT NEGATIVE
;OFF BOTTOM OF SCREEN
          LDA     TFF
          CLC
          ADC     T0
          BCS     STILLPOS
DEADCAT:  LDA     #0
STILLPOS: STA     T0                   ;CHANGE HEIGHT
          LDA     #0
          BEQ     CONT00
NOTNEG:   BNE     TOOHIGH              ;OVER TOP OF SCREEN
          LDA     TFF
          CMP     #120
          BCC     CONT00               ;ON SCREEN
;TOO HIGH
TOOHIGH:  LDA     #0
          STA     T0
          STA     P0Y,Y
          STA     SIZE0,Y
          STA     T12
          LDX     T2
          JMP     FBCONT
CONT00:   PHA
          LDA     OBJAID,X
          CMP     #EXHAUST             ;ANOTHER FUCKING SPECIAL CASE
          BNE     SK73                 ;NOT EXHAUST PORT
          PLA
          LDA     OBJAY,X
          PHA
SK73:     PLA
          STA     P0Y,Y
          STA     OBJAY,X              ;HOLD FOR CX
          LDA     T0
          STA     SIZE0,Y
          LDA     T2                   ;FUDGE YPOS ON PLAYER NUMBER
          LSR
          BCC     SK47
          LDX     T2
          DEC     P0Y,X
          LDX     T1
SK47:
;
; FUDGE X AND WIDTH ACCORDING TO SIZE AND FLOAT
;
          LDY     CATAX,X              ;GET INDEX TO WIDTHS
          LDA     TRWIDTH,Y            ;GET WIDTH
          STA     T0                   ;STORE WIDTH
          LDA     OBJAID,X             ;CHECK FOR HALF CATWALK
          AND     #$04
          BNE     SK35                 ;FULL WIDTH CATWALK
;HALF CATWALK
          LSR     T0                   ;CUT WIDTH IN HALF
;RIGHT CAT?
          LDA     OBJAID,X
          AND     #8
          BEQ     SK35                 ;NO
;RIGHT CAT
          LDA     T12                  ;GET LEFT X
          CLC
          ADC     T0                   ;ADD HALF OF WIDTH
          STA     T12
SK35:
;
; SPECIAL CASE FIREBALLS
;
          LDA     OBJAID,X
          ASL
          BMI     DOXPOS
          JMP     NOTFIRE              ;NOT A FIREBALL
;SET UP XPOS FOR FIREBALLS AND EXHAUST
DOXPOS:   CMP     #(EXHAUST << 1) & $FF
          BNE     NOTPORTX             ;NOT EXHAUST
;SET UP PORT XPOS
          LDA     #MIDY-$10
          SEC
          SBC     OBJAY,X              ;GET VERT OFFSET
          LDY     XWX                  ;SET UP SKEW
          BEQ     ADDHALF
          DEY
          BEQ     ADDQUAR
          DEY
          BEQ     ADDNIL               ;ADD NOTHING
          DEY
          BEQ     SUBQUAR
          BNE     SUBHALF
ADDNIL:   LDA     #0
ADDQUAR:  LSR
ADDHALF:  LSR
          CLC
          ADC     #MIDX
          BNE     WREXX                ;WRITE EXHAUST XPOS
SUBQUAR:  LSR
SUBHALF:  LSR
          STA     T12
          LDA     #MIDX
          SEC
          SBC     T12
          BNE     WREXX
NOTPORTX: LDA     T0
          LSR
          ADC     T12
WREXX:    SEC
          SBC     #4
          STA     T12
          STA     OBJAX,X              ;HOLD FOR COLLISION DETECT
;
          LDA     CATAX,X              ;GET X
          AND     #$FC
          TAY
          LDA     OBJAID,X
          AND     #$4                  ;IS IT EXHAUST PORT ?
          BEQ     NOTPORT              ;NO
;EXHAUST PORT
          LDA     FRAME
          AND     #$E
          BNE     SK74
          DEC     OBJADY,X
SK74:
          TYA
          CLC
          ADC     #$10                 ;POINT TO PORT TABLE
          CLC
          TAY
NOTPORT:  LDA     TRFB+3,Y             ;ADJUST XPOS FOR PLAYER WIDTH
          AND     #7
          STA     TFF
          LDA     T12
          SEC
          SBC     TFF
          STA     T12
          LDA     TRFB,Y               ;LOOK UP LO GRX INDIRECTION
          LDX     T3
          STA     P0GX,X
          LDA     TRFB+1,Y
          STA     P0GX+1,X
          LDA     TRFB+2,Y             ;GET HEIGHT
          LDX     T2
          STA     SIZE0,X
;DRIVE REFLECT FOR ANIMATION
          LDA     #0
          BCC     SK48                 ;CARRY CLEAR FOR EXHAUST PORT
          LDA     FRAME
          ASL
          ASL
SK48:     EOR     TRFB+3,Y
          AND     #$8
          EOR     TRFB+3,Y
          JMP     FBCONT               ;GET BACK TO IT

;CHECK FOR OUT OF RANGE FOR SCREEN
NOTFIRE:  LDA     T12
          CMP     #200
          BCC     NOTNEG1
;TOO FAR LEFT
          CLC
          ADC     T0
          LDA     #0
          STA     T12
NOTNEG1:
; SELECT PLAYER SIZE AND GRAPHICS
          LDA     T0                   ;WIDTH
          CMP     #33
          BCC     NOFLOAT
;15 HZ FLICKER
          CMP     #65                  ;NEED TO FLICKER ?
          BCS     NFLICK
;32 > WIDTH < 64
          TAX
          LDA     FRAME
          AND     #$02
          BNE     SK38
;DO LEFT PICTURE ON 15 HZ
          LDA     #32
          BNE     NOFLOAT
SK38:                                  ;RIGHT PICTURE
          TXA
          SEC
          SBC     #32
          CLC
          ADC     T12
          STA     T12
          LDA     #32
          BNE     NOFLOAT
;WIDTH > 64
NFLICK:   SEC
          SBC     #64
          LSR
          CLC
          ADC     T12
          STA     T12
          LDA     FRAME
          AND     #$02
          BNE     SK39
          LDA     #31
          CLC
          ADC     T12
          STA     T12
SK39:     LDA     #32
NOFLOAT:
          PHA                          ;SAVE WIDTH
          LDA     T12
          CMP     #160
          BCC     OK97                 ;IN RANGE
          LDA     #0
          STA     T12
          STA     SIZE0,Y
          STA     P0Y,Y
OK97:     PLA
          PHA
          CLC
          ADC     T12                  ;LOOK FOR RIGHT WRAP
          SEC
          SBC     #159
          BCC     OK98
;WRAP
          STA     T0
          PLA
          SBC     T0
          JMP     SK900
OK98:     PLA
SK900:
;SELECT WIDTH OF PLAYERS
          LDY     #0                   ;Y INDICATES S,DBL,QUAD
          CMP     #9                   ;
          BCS     NOTSING
;SINGLE WIDE
          SEC
          SBC     #4
          JMP     GOTWIDTH
NOTSING:  INY
          CMP     #17
          BCS     NOTDBL
;DOUBLE WIDE
          LSR
          SEC
          SBC     #4
          JMP     GOTWIDTH
NOTDBL:   INY
          LSR
          LSR
          SEC
          SBC     #4
GOTWIDTH: ASL
          TAX
          LDA     CATGRX,X
          PHA
          LDA     CATGRX+1,X
          PHA
          LDX     T3
          PLA
          STA     P0GX+1,X
          PLA
          STA     P0GX,X
          LDX     T2
          LDA     CATWIDTH,Y
FBCONT:   STA     T7,X
          LDA     T12
          INC     T3                   ;MOVE INDIRECTION POINTER
          INC     T3
          JMP     OK12                 ;BACK TO MAIN ROUTINE
;
; TRENCH FIREBALL DATA
;
TRFB:     .word      FBA
          .byte      $10,$10
          .word      FBB
          .byte      $10,$10
          .word      FBC
          .byte      $11,$15
          .word      FBD
          .byte      $11,$15
          .word      VENTA
          .byte      $10,$10
          .word      VENTB
          .byte      $10,$10
          .word      VENTC
          .byte      $10,$15
          .word      VENTD
          .byte      $10,$15
;
; LIST OF BLOCKS
;
BLOCKS:   .byte      <T00,<T01,<T02,<T03,<T00,<T00,<T00,<T00
          .byte      <T00,<T01,<T02,<T03,<T00,<T00,<T00,<T00
          .byte      <T00,<T01,<T02,<T03,<T00,<T00,<T00,<T00
          .byte      <T00,<T01,<T02,<T03,<T00,<T00,<T00,<T00
TRBLOCKS: .byte <TR00,<TR00,<TR00,<TR0E,<TR01,<TR02,<TR01,<TR0E
          .byte <TR02,<TR01,<TR02,<TR0E,<TR03,<TR02,<TR04,<TR0E
          .byte <TR02,<TR03,<TR02,<TR0E,<TR03,<TR06,<TR05,<TR0E
          .byte <TR03,<TR04,<TR05,<TR0E,<TR06,<TR05,<TR04,<TR0E
;
; ZERO ALL PLAYERS
;
ZOBJECTS: LDA     #0                   ;ZERO XPOS YPOS DX DY
          LDX     #ZEND-ZSTART
ZLOOP:    STA     LAZAX,X
          STA     LAZY,X
          STA     LAZADX,X
          STA     LAZDY,X
          DEX
          BPL     ZLOOP
          RTS
;
; TAKE A SHIELD HIT
;
TAKEHIT:
          DEC     SHIELDS
          LDA     #4
          STA     BKCLR
          LDA     #$0F
          STA     COLORTIM
          LDA     #<(SHOT-1)
          JMP     SNDINI               ;RETURN FROM THERE
;
; RANDOM NUMBER GENERATOR
;
RANDOM:   LDA     RAND
          ROR
          ROR
          ROR
          EOR     RANDH
          ASL
          ASL
          ROL     RAND
          ROL     RANDH
          LDA     RAND
          RTS
;
; BIRTH NEW STAR
;
DEAD0:    LDA     BIRTHS,X
          STA     STARAX,X
          LDA     #MIDY-$10
          STA     STARAY,X
          RTS
;
; NUMBER OF TIES ON SCREEN BY WAVE
;
NOTIES:   .byte      3,3,2,2,2,1,1,1
;
;         CONVERT XPOS TO HM/DELAY FORMAT
;            A HAS HORIZONTAL POSITION
;            X POINTS TO OBJECT
;
CHRST1:   STA     T0                   ; SAVE HP
          CLC                          ; FUDGE
          ADC     #1
          PHA                          ; SAVE HP
          LSR
          LSR
          LSR
          LSR                    ; DIVIDE BY 16
          STA     T0                   ; AND SAVE ...
          TAY                          ; LOOP COUNT
          PLA                          ; RESTORE HP
          AND     #$0F
          CLC
          ADC     T0                   ; GET ERROR COUNT
          CMP     #$F                  ; E IS MAX
          BCC     OK1
          SBC     #$F
          INY                          ; CORRECTION
OK1:      SEC
          SBC     #$08                 ; CONVERT TO HMOVE FORMAT
          EOR     #$FF                 ; INVERT
          ASL
          ASL
          ASL
          ASL
          STY     T0
          ORA     T0                   ;COMBINE
          RTS
;
; TABLE OF TOWER HEIGHTS
; INDEX = (MIDY=YPOS)/2
;
TOWHGTS:
          .byte      $08,$0C,$10,$14,$18,$1C
          .byte      $20,$24,$28,$2C,$30,$34,$38,$3C
          .byte      $40,$44,$48,$4C,$50,$54,$58,$5C
          .byte      $60,$64,$68,$6C,$70,$74,$78,$78
          .byte      $78,$78,$78,$78,$78,$78,$78,$78
          .byte      $78,$78
CATIMES:  .byte      $38,$38,$38,$34,$30,$28,$28,$28
;
; MASKS FOR TOWER LAUNCH
;
LCNHMSK   .byte      $07,$03,$01,$01,$01,$01,$01,$00
;
; TOWER LAUCH TABLES
;
TOWXS:    .byte      $48,$50,$58,$60
TOWIDS:   .byte      0                    ;NULL ID
          .byte      (TOW1 & $FF)/4
          .byte      (FB0 & $FF)/4
          .byte      (TOW1 & $FF)/4
          BOUNDRY 32
;   org $2FE0
;   rorg $3FE0;org $3FE0
;
; VECTORS
;
          .byte      "(C)84LucasfilmLtd.andATARI"
VECTORS:  .word POWERUP
          .word POWERUP
          .word POWERUP
          END     POWERUP