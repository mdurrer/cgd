;  Seven Full Size digit display
;  By Omegamatrix
;
;  This program displays 7 full size digits with no flicker, and any background color.
;  There is a small selection of different digit fonts available. You can build more
;  with the excel sheet "DigitBuilder.xlsx"


      processor 6502
      include DIGITS.h

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
RESP1   =  $11
RESM0   =  $12
RESM1   =  $13
RESBL   =  $14
GRP0    =  $1B
GRP1    =  $1C
ENAM0   =  $1D
ENAM1   =  $1E
ENABL   =  $1F
HMP0    =  $20
HMP1    =  $21
HMM0    =  $22
HMM1    =  $23
HMBL    =  $24
VDELP0  =  $25
VDELP1  =  $26
HMOVE   =  $2A
HMCLR   =  $2B

INTIM   =  $0284
TIM1T   =  $0294
TIM64T  =  $0296


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;      USER CONSTANTS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;use letters to select different digit graphics
;browse what is available in DIGITS.h file

ZERO_PARAMETER   = "A"  ; A-E
ONE_PARAMETER    = "A"  ; A-G
TWO_PARAMETER    = "B"  ; A-E
THREE_PARAMETER  = "B"  ; A-B
FOUR_PARAMETER   = "C"  ; A-C
FIVE_PARAMETER   = "A"  ; A-D
SIX_PARAMETER    = "A"  ; A-C
SEVEN_PARAMETER  = "B"  ; A-B
EIGHT_PARAMETER  = "B"  ; A-E
NINE_PARAMETER   = "A"  ; A-D


COL_BACKGROUND  = $A0
COL_DIGITS      = $0E

SCROLL_DELAY    = $3F  ; AND value with frameCounter

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;      RAM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

       SEG.U Variables

       ORG $80

digitPtrs        ds   10
bcdScore         ds   4
frameCounter     ds   1

;---------------------------------------
; the fifth digit gfx locations can be re-used
; for addresses thrown on the stack

      ORG $F9

tempRam          ds   7
fifthDigitB      equ  tempRam    ; $F9
fifthDigitC      equ  tempRam+1  ; $FA
fifthDigitD      equ  tempRam+2  ; $FB
fifthDigitE      equ  tempRam+3  ; $FC
fifthDigitF      equ  tempRam+4  ; $FD
fifthDigitG      equ  tempRam+5  ; $FE
fifthDigitH      equ  tempRam+6  ; $FF


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;      MAIN PROGRAM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

       SEG CODE
       ORG $F000

START:
    cld
    ldx    #0
    txa
.loopClear:
    dex
    txs
    pha
    bne    .loopClear

;one time load of high pointers
    lda    #>NumberGfx
    ldx    #<digitPtrs+9
    ldy    #9
.loadHighPtrs:
    sta    0,X
    dex
    dey
    bne    .loadHighPtrs

;initial values
    lda    #$01
    sta    bcdScore
    lda    #$23
    sta    bcdScore+1
    lda    #$45
    sta    bcdScore+2
    lda    #$06
    sta    bcdScore+3    ; only the low nibble is used...


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; do Vsync
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

MainLoop:
    lda    #$0E
.loopVsync:
    sta    WSYNC
;---------------------------------------
    sta    VSYNC
    lsr
    bne    .loopVsync

    lda    #$31
    sta    TIM64T

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; load low pointers, digits 1-4, 6
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    lax    bcdScore
    and    #$F0
    lsr
    sta    digitPtrs      ;$80
    txa
    and    #$0F
    asl
    asl
    asl
    sta    digitPtrs+2    ;$82

    lax    bcdScore+1
    and    #$F0
    lsr
    sta    digitPtrs+4    ;$84
    txa
    and    #$0F
    asl
    asl
    asl
    sta    digitPtrs+6    ;$86

    lda    bcdScore+2
    and    #$0F
    asl
    asl
    asl
    sta    digitPtrs+8    ;$88

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; finish Vblank
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.waitVblank:
    lda    INTIM
    bne    .waitVblank
    sta    WSYNC
;---------------------------------------
    sta    VBLANK

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; draw screen
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ldy    #90
.loopTop:
    sta    WSYNC
;---------------------------------------
    dey
    bne    .loopTop

    jmp    Draw7byte


DrawBlankBottom:
    ldy    #91
.loopBot:
    sta    WSYNC
;---------------------------------------
    dey
    bne    .loopBot

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  start Overscan
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    lda    #2
    sta    WSYNC
;---------------------------------------
    sta    VBLANK
    lda    #27
    sta    TIM64T

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  scroll digits
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    inc    frameCounter
    lda    frameCounter
    and    #SCROLL_DELAY
    bne    .skipDigitScroll

    sed
    ldy    #2
.loopUpdateScore:
    lda    bcdScore,Y
    tax
    and    #$F0
    clc
    adc    #$10
    sta    tempRam
    txa
    and    #$0F
    clc
    adc    #$01
    and    #$0F
    ora    tempRam
    sta    bcdScore,Y
    dey
    bpl    .loopUpdateScore

    lda    bcdScore+3
    clc
    adc    #$01
    and    #$0F
    sta    bcdScore+3
    cld
.skipDigitScroll:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  finish Overscan
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.waitOverscan:
    lda    INTIM
    bne    .waitOverscan
    sta    WSYNC
    jmp    MainLoop








       ORG $FC00

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;      7 DIGIT DISPLAY KERNEL
;
;
;   Three scanlines of prep are needed before the score can be drawn. During this time the ball,
;   players, and missiles are all positioned. The 5th digit's gfx is also stored in ram at this
;   point so all of the ram used by the 5th digit's gfx is free up until this point
;


Draw7byte:
    sta    WSYNC
;---------------------------------------
    lda    #COL_BACKGROUND       ;2  @2
    sta.w  COLUBK                ;4  @6     1 free cycle to load color from ram instead
    sta    COLUPF                ;3  @9
    sta    COLUP0                ;3  @12
    sta    COLUP1                ;3  @15
    ldx    #HMBL                 ;2  @17
    txs                          ;2  @19
    lda    bcdScore+3            ;3  @22
    and    #$0F                  ;2  @24
    tax                          ;2  @26    get 7th digit,
    ldy    DigitPtrTab,X         ;4  @30    which will be drawn by missles, ball covers missiles in priority mode
    lda    HmoveDigitTab+9,Y     ;4  @34
    pha                          ;3  @37    HMBL
    sta    ENABL                 ;3  @40    enable/disable ball, for line 1
    sta    RESP1                 ;3  @43
    lda    HmoveDigitTab+8,Y     ;4  @47
    pha                          ;3  @50    HMM1
    lda    HmoveDigitTab+7,Y     ;4  @54
    sta    RESBL                 ;3  @57
    sta    RESM1                 ;3  @60
    pha                          ;3  @63    HMM0
    lda    #LEFT73_6             ;2  @65
    pha                          ;3  @68    HMP1
    lda    #LEFT73_8             ;2  @70
    pha                          ;3  @73    HMP0
;---------------------------------------
    lda    NusizDigitTab+9,Y     ;4  @1
    sta    CTRLPF                ;3  @4     BL size, PF reflected & priority
    lda    NusizDigitTab+8,Y     ;4  @8
    sta    NUSIZ1                ;3  @11    M1 size, P1 3 copies close
    lda    NusizDigitTab+7,Y     ;4  @15
    sta    NUSIZ0                ;3  @18    M0 size, P0 3 copies close
    ldx    #fifthDigitH          ;2  @20
    txs                          ;2  @22
    lda    bcdScore+2            ;3  @25    load "fifth" digit directly into ram
    and    #$F0                  ;2  @27
    lsr                          ;2  @29
    tax                          ;2  @31
    lda    NumberGfx,X           ;4  @35
    pha                          ;3  @38    fifthDigitH
    sta    RESP0                 ;3  @41
    lda    NumberGfx+1,X         ;4  @45
    pha                          ;3  @48    fifthDigitG
    lda    NumberGfx+2,X         ;4  @52
    pha                          ;3  @55    fifthDigitF
    sta    RESM0                 ;3  @58
    lda    NumberGfx+3,X         ;4  @62
    pha                          ;3  @65    fifthDigitE

;some playfield code is inserted here,
;to align HMOVE ending at 73 cycles...
    lda    #$FF                  ;2  @67
    sta    PF0                   ;3  @70    fill, hide copies of missiles
    sta    HMOVE                 ;3  @73
    sta    PF1                   ;3  @76
;---------------------------------------
    lda    #$01                  ;2  @2
    sta    PF2                   ;3  @5
    sta    VDELP0                ;3  @8     use delay
    sta    VDELP1                ;3  @11

;back to reloading the ram gfx
    lda    NumberGfx+4,X         ;4  @15
    pha                          ;3  @18    fifthDigitD
    lda    NumberGfx+5,X         ;4  @22
    pha                          ;3  @25    fifthDigitC
    lda    NumberGfx+6,X         ;4  @29
    pha                          ;3  @32    fifthDigitB

;here's a trick to save 1 byte of ram, use TIM1T instead
    lda    NumberGfx+7,X         ;4  @36
    adc    #75                   ;2  @38    carry is clear, add 75 (cycles) until usage
    sta    TIM1T                 ;4  @42    use timer 1 as a temp storage, as stack pointer is already taken
    tya                          ;2  @44
    tax                          ;2  @46
    txs                          ;2  @48    stack pointer holds the index for 7th digit,
    lda    #NO_MO_73 | ENABLE    ;2  @50
    sta    HMBL                  ;3  @53
    sta    HMM1                  ;3  @56
    sta    HMP1                  ;3  @59
    sta    HMP0                  ;3  @62
    sta    ENAM1                 ;3  @65
    sta    ENAM0                 ;3  @68
    lda    #COL_DIGITS           ;2  @70
    sta.w  COLUP0                ;4  @74    1 free cycle to load color from ram instead
;--------------------------------------
    sta    COLUP1                ;3  @1     line #1
    ldy    #7                    ;2  @3
    lda    (digitPtrs),Y         ;5  @8     1st
    sta    GRP0                  ;3  @11
    lda    (digitPtrs+2),Y       ;5  @16    2nd
    sta    GRP1                  ;3  @19
    lda    (digitPtrs+4),Y       ;5  @24    3rd
    sta    GRP0                  ;3  @27
    lax    (digitPtrs+8),Y       ;5  @32    6th
    lda    (digitPtrs+6),Y       ;5  @37    4th
    ldy    INTIM                 ;4  @41    5th   75 cycles has passed, timer now holds correct value
    sta    GRP1                  ;3  @44
    sty    GRP0                  ;3  @47
    stx    GRP1                  ;3  @50
    sta    GRP0                  ;3  @53
    tsx                          ;2  @55
    sta    RESM0                 ;3  @58
    lda    HmoveDigitTab+6,X     ;4  @62
    sta    HMM0                  ;3  @65
    sta    ENABL                 ;3  @68
    ldy    #6                    ;2  @70
    sta    HMOVE                 ;3  @73
;---------------------------------------
    lda    NusizDigitTab+6,X     ;4  @1     line #2
    sta    NUSIZ0                ;3  @4
    lda    (digitPtrs),Y         ;5  @9
    sta    GRP0                  ;3  @12
    lda    (digitPtrs+2),Y       ;5  @17
    sta    GRP1                  ;3  @20
    lda    (digitPtrs+4),Y       ;5  @25
    sta    GRP0                  ;3  @28
    lax    (digitPtrs+8),Y       ;5  @33
    lda    (digitPtrs+6),Y       ;5  @38
    ldy    fifthDigitB           ;3  @41
    sta    GRP1                  ;3  @44
    sty    GRP0                  ;3  @47
    stx    GRP1                  ;3  @50
    sta    GRP0                  ;3  @53
    tsx                          ;2  @55
    sta    RESM0                 ;3  @58
    lda    HmoveDigitTab+5,X     ;4  @62
    sta    HMM0                  ;3  @65
    sta    ENABL                 ;3  @68
    ldy    #5                    ;2  @70
    sta    HMOVE                 ;3  @73
;---------------------------------------
    lda    NusizDigitTab+5,X     ;4  @1     line #3
    sta    CTRLPF                ;3  @4     resize ball, only used by digit 7b
    lda    (digitPtrs),Y         ;5  @9
    sta    GRP0                  ;3  @12
    lda    (digitPtrs+2),Y       ;5  @17
    sta    GRP1                  ;3  @20
    lda    (digitPtrs+4),Y       ;5  @25
    sta    GRP0                  ;3  @28
    lax    (digitPtrs+8),Y       ;5  @33
    lda    (digitPtrs+6),Y       ;5  @38
    ldy    fifthDigitC           ;3  @41
    sta    GRP1                  ;3  @44
    sty    GRP0                  ;3  @47
    stx    GRP1                  ;3  @50
    sta    GRP0                  ;3  @53
    tsx                          ;2  @55
    sta    RESM0                 ;3  @58
    lda    HmoveDigitTab+4,X     ;4  @62
    sta    HMM0                  ;3  @65
    sta    ENABL                 ;3  @68
    ldy    #4                    ;2  @70
    sta    HMOVE                 ;3  @73
;---------------------------------------
    lda    NusizDigitTab+4,X     ;4  @1     line #4
    sta    NUSIZ0                ;3  @4
    lda    (digitPtrs),Y         ;5  @9
    sta    GRP0                  ;3  @12
    lda    (digitPtrs+2),Y       ;5  @17
    sta    GRP1                  ;3  @20
    lda    (digitPtrs+4),Y       ;5  @25
    sta    GRP0                  ;3  @28
    lax    (digitPtrs+8),Y       ;5  @33
    lda    (digitPtrs+6),Y       ;5  @38
    ldy    fifthDigitD           ;3  @41
    sta    GRP1                  ;3  @44
    sty    GRP0                  ;3  @47
    stx    GRP1                  ;3  @50
    sta    GRP0                  ;3  @53
    tsx                          ;2  @55
    sta    RESM0                 ;3  @58
    lda    HmoveDigitTab+3,X     ;4  @62
    sta    HMM0                  ;3  @65
    sta    ENABL                 ;3  @68
    ldy    #3                    ;2  @70
    sta    HMOVE                 ;3  @73
;---------------------------------------
    lda    NusizDigitTab+3,X     ;4  @1     line #5
    sta    NUSIZ0                ;3  @4
    lda    (digitPtrs),Y         ;5  @9
    sta    GRP0                  ;3  @12
    lda    (digitPtrs+2),Y       ;5  @17
    sta    GRP1                  ;3  @20
    lda    (digitPtrs+4),Y       ;5  @25
    sta    GRP0                  ;3  @28
    lax    (digitPtrs+8),Y       ;5  @33
    lda    (digitPtrs+6),Y       ;5  @38
    ldy    fifthDigitE           ;3  @41
    sta    GRP1                  ;3  @44
    sty    GRP0                  ;3  @47
    stx    GRP1                  ;3  @50
    sta    GRP0                  ;3  @53
    tsx                          ;2  @55
    sta    RESM0                 ;3  @58
    lda    HmoveDigitTab+2,X     ;4  @62
    sta    HMM0                  ;3  @65
    sta    ENABL                 ;3  @68
    ldy    #2                    ;2  @70
    sta    HMOVE                 ;3  @73
;---------------------------------------
    lda    NusizDigitTab+2,X     ;4  @1     line #6
    sta    NUSIZ0                ;3  @4
    lda    (digitPtrs),Y         ;5  @9
    sta    GRP0                  ;3  @12
    lda    (digitPtrs+2),Y       ;5  @17
    sta    GRP1                  ;3  @20
    lda    (digitPtrs+4),Y       ;5  @25
    sta    GRP0                  ;3  @28
    lax    (digitPtrs+8),Y       ;5  @33
    lda    (digitPtrs+6),Y       ;5  @38
    ldy    fifthDigitF           ;3  @41
    sta    GRP1                  ;3  @44
    sty    GRP0                  ;3  @47
    stx    GRP1                  ;3  @50
    sta    GRP0                  ;3  @53
    tsx                          ;2  @55
    sta    RESM0                 ;3  @58
    lda    HmoveDigitTab+1,X     ;4  @62
    sta    HMM0                  ;3  @65
    sta    ENABL                 ;3  @68
    ldy    #1                    ;2  @70
    sta    HMOVE                 ;3  @73
;---------------------------------------
    lda    NusizDigitTab+1,X     ;4  @1     line #7
    sta    NUSIZ1                ;3  @4     resize M1, only used by digits 2a, 2b
    lda    (digitPtrs),Y         ;5  @9
    sta    GRP0                  ;3  @12
    lda    (digitPtrs+2),Y       ;5  @17
    sta    GRP1                  ;3  @20
    lda    (digitPtrs+4),Y       ;5  @25
    sta    GRP0                  ;3  @28
    lax    (digitPtrs+8),Y       ;5  @33
    lda    (digitPtrs+6),Y       ;5  @38
    ldy    fifthDigitG           ;3  @41
    sta    GRP1                  ;3  @44
    sty    GRP0                  ;3  @47
    stx    GRP1                  ;3  @50
    sta    GRP0                  ;3  @53
    tsx                          ;2  @55
    sta    RESM0                 ;3  @58
    lda    HmoveDigitTab,X       ;4  @62
    sta    HMM0                  ;3  @65
    sta    ENABL                 ;3  @68
    ldy    #0                    ;2  @70
    sta    HMOVE                 ;3  @73
;---------------------------------------
    lda    NusizDigitTab,X       ;4  @1     line #8
    sta    NUSIZ0                ;3  @4
    lda    (digitPtrs),Y         ;5  @9
    sta    GRP0                  ;3  @12
    lda    (digitPtrs+2),Y       ;5  @17
    sta    GRP1                  ;3  @20
    lda    (digitPtrs+4),Y       ;5  @25
    sta    GRP0                  ;3  @28
    lax    (digitPtrs+8),Y       ;5  @33
    lda    (digitPtrs+6),Y       ;5  @38
    ldy    fifthDigitH           ;3  @41
    sta    GRP1                  ;3  @44
    sty    GRP0                  ;3  @47
    stx    GRP1                  ;3  @50
    sta    GRP0                  ;3  @53

    ldx    #$FF                  ;2  @55
    txs                          ;2  @57
    inx                          ;2  @59    X=0
    stx    ENAM0                 ;3  @62    clear all...
    stx    ENAM1                 ;3  @65
    stx    ENABL                 ;3  @68
    stx    GRP1                  ;3  @71
    stx    GRP0                  ;3  @74
;---------------------------------------
    stx    GRP1                  ;3  @1
    stx    GRP0                  ;3  @4
    stx    PF0                   ;3  @7
    stx    PF1                   ;3  @10
    stx    PF2                   ;3  @13
    stx    VDELP0                ;3  @16
    stx    VDELP1                ;3  @19
    stx    HMCLR                 ;3  @22

    jmp    DrawBlankBottom

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;   Starting positions for M0, M1, and the ball,
;   M0 is repositioned at 110 each line afterward...
;
;       sixth digit (GRP1)          seventh digit (M0,M1,ball)
;  +                           +                                   +
;  +                           +                                   + <-- playfield starts
;  +                           +                                   +
;  +                           +                            Ball   +         M0                      M1
;  +                           +                               |   +          |                       |
;  +  92 93 94 95 96 97 98 99  +  100 101 102 103 104 105 106 107  + 108 109 110 111 112 113 114 115 116
;  +                           +       |                           +
;  +                           +       |                           +
;  +                           +   maximum M1 can reach            +
;


HmoveDigitTab:

ZeroDigit:
  ZERO_MOVE  ZERO_PARAMETER
OneDigit:
    ONE_MOVE  ONE_PARAMETER
TwoDigit:
  TWO_MOVE  TWO_PARAMETER
ThreeDigit:
  THREE_MOVE  THREE_PARAMETER
FourDigit:
  FOUR_MOVE  FOUR_PARAMETER
FiveDigit:
  FIVE_MOVE  FIVE_PARAMETER
SixDigit:
  SIX_MOVE  SIX_PARAMETER
SevenDigit:
  SEVEN_MOVE  SEVEN_PARAMETER
EightDigit:
  EIGHT_MOVE  EIGHT_PARAMETER
NineDigit:
  NINE_MOVE  NINE_PARAMETER
BlankDigit:
  BLANK_MOVE


DigitPtrTab:
    .byte  #(ZeroDigit - HmoveDigitTab)
    .byte  #(OneDigit - HmoveDigitTab)
    .byte  #(TwoDigit - HmoveDigitTab)
    .byte  #(ThreeDigit - HmoveDigitTab)
    .byte  #(FourDigit - HmoveDigitTab)
    .byte  #(FiveDigit - HmoveDigitTab)
    .byte  #(SixDigit - HmoveDigitTab)
    .byte  #(SevenDigit - HmoveDigitTab)
    .byte  #(EightDigit - HmoveDigitTab)
    .byte  #(NineDigit - HmoveDigitTab)
    .byte  #(BlankDigit - HmoveDigitTab)


NusizDigitTab:

ZeroSize:
  ZERO_SIZE  ZERO_PARAMETER
OneSize:
  ONE_SIZE  ONE_PARAMETER
TwoSize:
  TWO_SIZE  TWO_PARAMETER
ThreeSize:
  THREE_SIZE  THREE_PARAMETER
FourSize:
  FOUR_SIZE  FOUR_PARAMETER
FiveSize:
  FIVE_SIZE  FIVE_PARAMETER
SixSize:
  SIX_SIZE  SIX_PARAMETER
SevenSize:
  SEVEN_SIZE  SEVEN_PARAMETER
EightSize:
  EIGHT_SIZE  EIGHT_PARAMETER
NineSize:
  NINE_SIZE  NINE_PARAMETER
BlankSize:
  BLANK_SIZE

  IF SHOW_BYTES_REMAINING
      ECHO ([$FF00-*]d), "bytes free,",*,"to $feff"
  ENDIF

       ORG $FF00

NumberGfx:

Zero:
  ZERO_GFX  ZERO_PARAMETER
One:
  ONE_GFX  ONE_PARAMETER
Two:
  TWO_GFX  TWO_PARAMETER
Three:
  THREE_GFX  THREE_PARAMETER
Four:
  FOUR_GFX  FOUR_PARAMETER
Five:
  FIVE_GFX  FIVE_PARAMETER
Six:
  SIX_GFX  SIX_PARAMETER
Seven:
  SEVEN_GFX  SEVEN_PARAMETER
Eight:
  EIGHT_GFX  EIGHT_PARAMETER
Nine:
  NINE_GFX  NINE_PARAMETER
BlankSpace:
  BLANK_GFX

  IF SHOW_BYTES_REMAINING
      ECHO ([$FFFC-*]d), "bytes free,",*,"to $fffb"
  ENDIF

       ORG $FFFC

    .word START
    .word START


SHOW_BYTES_REMAINING = 1
