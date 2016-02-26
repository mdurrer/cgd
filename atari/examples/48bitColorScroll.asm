;
;    *** 48 Bit Wide Scrolling Colors Demo ***
;
;    by Omegamatrix
;    based upon Eckhard Stolberg's 48 Bit Big Sprite Positioning Demo
;
;
;
;    INSTRUCTIONS
;
;    1. Use the joystick to move the big sprite around
;    2. Holding the firebutton while pressing a direction scrolls the text
;
;
;
;    FOREWARD
;
;    I started this demo to with no idea in mind except to see if I could make a 48 bit wide
;    sprite scroll some colors. I struggled with finding the cycles in the drawing loop for a
;    few days, initially I had hollow sprites that just let the changing background color through...
;
;    The other main trouble I had was understanding how to position the 48 bit sprite. It had been
;    done many times before by many people, but the timing that you entered one of these routines was
;    very specific. A cycle off and the whole thing was garbage on the screen.
;
;    In researching how it all worked I stumbled across Eckhard's demo. This was wonderful! I could
;    move the sprite anywhere across the screen. I could also look in Stella's debugger to find the
;    cycle and position it was set to when I found a spot on the screen I liked. This was not only
;    a demo but a useful tool.
;
;    I rewrote my drawing loop using Eckhard's idea of having no WSYNC, and found the extra time to
;    write to both players color registers. I changed my routine from masking the parts of the back-
;    ground to just coloring the letters themselves. This saved me the trouble of using the playfield
;    to cover the left/right sides, and allowed me more freedom.
;
;    After I got it working I really wanted to see if I could get it to move around like Eckhard did.
;    I used Eckhard's idea of doing an indirect jump into a delay table, using a top and bottom scanline
;    counter, and updating HMPx by left 1 or right 1 each frame the joystick is pressed (much quicker
;    than going through a reposition routine). I learned a lot from seeing how simple somethig could
;    be done.
;
;    Then I got the idea to do scrolling letters. I rewrote the draw loop again, and changed the
;    code to use gfx stored in ram. All the rotation code I wrote myself, and at first it was pretty
;    ugly with lots of huge data tables. Now it isn't so bad, and I really am happy I was
;    able to pull anything off on the 2600 at all. =)
;
;
;    Kudos to Eckhard Stolberg for his helpful demo,
;    I hope people can learn a few things from my bad code/good code as well. :P
;
;    Peace,
;    Omegamatrix
;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

      processor 6502

;vcs.h constants
VSYNC   =  $00
VBLANK  =  $01
WSYNC   =  $02
NUSIZ0  =  $04
NUSIZ1  =  $05
COLUP0  =  $06
COLUP1  =  $07
COLUBK  =  $09
CTRLPF  =  $0A
RESP0   =  $10
GRP0    =  $1B
GRP1    =  $1C
ENAM0   =  $1D
ENAM1   =  $1E
HMP0    =  $20
VDELP0  =  $25
VDELP1  =  $26
HMP0    =  $20
HMP1    =  $21
HMOVE   =  $2A
HMCLR   =  $2B
INPT4   =  $3C
SWCHA   =  $0280
INTIM   =  $0284
TIM64T  =  $0296

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;      RAM
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

        SEG.U variables

        ORG $80

framecounter          ds 1
scrollColor           ds 1
topLines              ds 1
bottomLines           ds 1
freeSpace             ds 60
ramGfx                ds 48
displayPtrs           ds 4
indirect              ds 2
xPosition             ds 1
smallMove             ds 1
largeDelay            ds 1
tempZero              ds 1
tempOne               ds 1
freespace2            ds 5


;"rg" is short for ram graphics
rgOne               =  ramGfx      ; $C0 - $C7
rgTwo               =  ramGfx+8    ; $C8 - $CF  sprites are 8 lines high,
rgThree             =  ramGfx+16   ; $D0 - $D7  bottom line is intially blank...
rgFour              =  ramGfx+24   ; $D8 - $DF
rgFive              =  ramGfx+32   ; $E0 - $E7
rgSix               =  ramGfx+40   ; $E8 - $EF

;registers $C0,$C8,$D0,$D8,$E0, and $E8 are the bottoms for sprites, and intentionally blank.
;they are used when the sprites rotate up/down, as it looks better to have a gap.



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;      MAIN PROGRAM
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

        SEG code

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
    jsr   Initialization            ; one time only


MainLoop:

    lda    #$0E
.doVsync:
    sta    WSYNC                    ; three scanlines for Vsync
;---------------------------------------
    sta    VSYNC
    lsr
    bne    .doVsync

    lda    #44                      ; time for Vblank period
    sta    TIM64T

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;      SCROLL COLOR
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;update the scroll color
    inc    framecounter
    lda    framecounter
    and    #$07                     ; change color every 8 frames, 60/8 = 7.5 times a second (NTSC)
    bne    .testFireButton
    ldx    scrollColor
    dex                             ; color = color -1
    cpx    #$0F                     ; skip black and dark grey colors, the darkest it gets is $06 (briefly)
    bne    .colorIsSelected
    tsx                             ; X=$FF
.colorIsSelected
    stx    scrollColor              ; color is ready to be used
.testFireButton:
    lda    INPT4                    ; hold the firebutton, and press a direction to rotate block
    bpl    .checkRotationWay        ; firebutton pressed
    jmp    .checkBlockMove          ; firebutton not pressed


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;      ROTATIONS
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.checkRotationWay:
    ldx    #8-1                     ; sprite height = amount of rows to be rotated
    lda    SWCHA
    bpl    .loopRightRotate
    asl
    bpl    .loopLeftRotate
    lda    framecounter             ; slow the up/down direction by half speed,
    lsr                             ; to make it more visible
    bcc    .gotoVblankEnd
    lda    SWCHA
    asl
    asl
    bpl    .doBottomRotate
    asl
    bmi    .gotoVblankEnd

;do top rotate
    ldx   #rgSix+7                  ; align stack pointer to very last register
    txs
.loopTopRotate:
    lda   0,X
    tay                             ; temporary save the current top byte
    lda   0-1,X
    pha                             ; move every other byte up by one row
    lda   0-2,X
    pha
    lda   0-3,X
    pha
    lda   0-4,X
    pha
    lda   0-5,X
    pha
    lda   0-6,X
    pha
    lda   0-7,X
    pha
    tya
    pha                             ; now the old top byte moves into the bottom byte
    tsx                             ; stack pointer decrements with PHA, it resets X correctly for next digit
    cpx   #rgOne-1
    bne   .loopTopRotate
.fixStackPointer:
    ldx   #$FF
    txs
    bne   .gotoVblankEnd            ; always branch
.gotoVblankEnd:
    jmp    .waitVblank              ; exit from rotation routine

.doBottomRotate:
    ldx   #rgOne-1
    txs
.loopBottomRotate:
    pla                             ; stack point increments with PLA
    tay
    pla
    sta   0+1,X
    pla
    sta   0+2,X
    pla
    sta   0+3,X
    pla
    sta   0+4,X
    pla
    sta   0+5,X
    pla
    sta   0+6,X
    pla
    sta   0+7,X
    tya
    sta   0+8,X
    tsx
    cpx   #rgSix+7
    bne   .loopBottomRotate
    beq   .fixStackPointer          ; always branch

.loopLeftRotate:
    lda   rgOne,X                   ; make sure the carry is set/clear,
    asl                             ; before rotating the row...
    rol   rgSix,X
    rol   rgFive,X                  ; rotate the six bytes in the row
    rol   rgFour,X
    rol   rgThree,X
    rol   rgTwo,X
    rol   rgOne,X
    dex                              ; loop until all 7 rows are done
    bpl   .loopLeftRotate
    bmi   .gotoVblankEnd             ; always branch

.loopRightRotate:
    lda   rgSix,X
    lsr
    ror   rgOne,X
    ror   rgTwo,X
    ror   rgThree,X
    ror   rgFour,X
    ror   rgFive,X
    ror   rgSix,X
    dex
    bpl   .loopRightRotate
    bmi   .gotoVblankEnd            ; always branch

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;      BLOCK MOVEMENT
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.checkBlockMove:
    lda    SWCHA
    bpl    .moveRight
    asl
    bpl    .moveLeft
    asl
    bpl    .moveDown
    asl
    bmi    .waitVblank              ; no direction pressed

;move up
    lda    topLines
    cmp    #1
    beq    .waitVblank
    dec    topLines
    inc    bottomLines
    bne    .waitVblank              ; always branch

.moveDown:
    lda    bottomLines
    cmp    #1
    beq    .waitVblank
    dec    bottomLines
    inc    topLines
    bne    .waitVblank              ; always branch

.moveRight:
    lda    xPosition
    cmp    #115                     ; right border  (160 pixels, -48 pixels for sprite, -3 color pixels delay?)
    beq    .waitVblank
    inc    xPosition
    inc    smallMove                ; every +3 color pixels = delay +1 machine cycle more
    lda    smallMove
    cmp    #3+1                     ; have we done 3 pixels?
    bne    .stepRight
    lda    #1                       ; yes, reset pixel count
    sta    smallMove
    dec    indirect                 ; this pointer jumps into the fine delay
    lda    indirect
    cmp    #<FineAdjustCycles       ; after the fine delay delay reaches it's limit,
    bne    .stepRight               ; adjust the delay loop for one more loop, and
    inc    largeDelay               ; then reset the fine delay to it's low position
    lda    #<FineAdjustCycles+5
    sta    indirect
.stepRight:
    lda    #$F0                     ; move right one pixel
    sta    HMP0
    sta    HMP1
    bne    .doHmove                 ; always branch

.moveLeft:
    lda    xPosition
    cmp    #3                       ; left border  (3 pixels delay)
    beq    .waitVblank
    dec    xPosition
    dec    smallMove
    bne    .stepLeft
    lda    #3
    sta    smallMove
    inc    indirect
    lda    indirect
    cmp    #<FineAdjustCycles+6     ; lower limit -1
    bne    .stepLeft
    dec    largeDelay
    lda    #<FineAdjustCycles+1
    sta    indirect
.stepLeft:
    lda    #$10                     ; move left one pixel
    sta    HMP0
    sta    HMP1

.doHmove:
    sta    WSYNC
;---------------------------------------
    sta    HMOVE

.waitVblank:
    lda    INTIM
    bne    .waitVblank              ; finish off Vblank period
    sta    VBLANK
    jmp    DoTopScanlines


        ORG $F200                   ; keep kernel from crossing a page boundary

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;      KERNEL
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


DoTopScanlines
    ldy    #8-1                     ; loop count for drawing loop
    ldx    topLines                 ; amount of blank scanlines, from top of screen to gfx
.loopTopLines:
    sta    WSYNC
;---------------------------------------
    dex                         ;2  @2
    bne    .loopTopLines        ;2³ @4/5
    sty    tempZero             ;3  @7
    ldx    scrollColor          ;3  @10
    txs                         ;2  @12
    jmp    (indirect)           ;6  @18    jump into fine adjust cycle table below



; opcode $A9   lda immediate  - takes 2 bytes, 2 cycles
; opcode $AD   lda absolute   - takes 3 bytes, 4 cycles
; opcode $A5   lda zero page  - takes 2 bytes, 3 cycles
; opcode $98   tya            - takes 1 byte,  2 cycles

; keep adding $A9 to the top of this table, and you'll increase by one cycle each time =)

FineAdjustCycles:
    .byte $A9   ; 7 cycles   lda #$A9, lda #$AD, lda $98
    .byte $A9   ; 6 cycles   lda #$A9, lda $98A5
    .byte $A9   ; 5 cycles   lda #$AD, lda $98
    .byte $AD   ; 4 cycles   lda $98A5
    .byte $A5   ; 3 cycles   lda $98
    .byte $98   ; 2 cycles   tya

    sec                         ;2
    lda    largeDelay           ;3
.loopDelayCycles:
    sbc    #1                   ;2
    bcs    .loopDelayCycles     ;2³


;each loop takes one scanline, but the exact cycle the
;loop starts on varies with the sprite positioning...

.loopDrawGfx
    tsx                         ;2  @2
    dex                         ;2  @4     stack pointer holds the line color
    txs                         ;2  @6
    ldy    tempZero             ;3  @9
    lda    rgSix,Y              ;4  @13    6th byte
    sta    tempOne              ;3  @16
    lda    rgOne,Y              ;4  @20    1st byte
    sta    GRP0                 ;3  @23
    lda    (displayPtrs),Y      ;5  @28    2nd byte
    sta    GRP1                 ;3  @31
    lda    (displayPtrs+2),Y    ;5  @36    3rd byte
    sta    GRP0                 ;3  @39
    stx    COLUP0               ;3  @42
    stx    COLUP1               ;3  @45
    lda    rgFour,Y             ;4  @49    4th byte
    ldx    rgFive,Y             ;4  @53    5th byte
    ldy    tempOne              ;3  @56
    sta    GRP1                 ;3  @59
    stx    GRP0                 ;3  @62
    sty    GRP1                 ;3  @65
    sta    GRP0                 ;3  @68
    dec    tempZero             ;5  @73
    bpl    .loopDrawGfx         ;2³ @75/76

;one final blank scanline to clean Vdelay well,
;this is necessary as the blank bottom line used
;in the rom gfx gets destroyed when the sprites
;are rotating up/down

    ldx    #$FF                 ;2  @1
    txs                         ;2  @3     reset stack pointer
    inx                         ;2  @5     X=0
    jsr    WasteTimeOne+10      ;15 @20
    sta    GRP0                 ;3  @23
    txa                         ;2  @25    A=0
    nop    #$EA                 ;3  @28    illegal opcode $80 (double NOP)
    sta    GRP1                 ;3  @31
    tay                         ;2  @33    Y=0
    nop    #$EA                 ;3  @36    illegal opcode $80 (double NOP)
    sta    GRP0                 ;3  @39
    jsr    WasteTimeOne+9       ;17 @56
    sta    GRP1                 ;3  @59
    stx    GRP0                 ;3  @62
    sty    GRP1                 ;3  @65
    sta    GRP0                 ;3  @68

    ldy    bottomLines
.drawBottomLines
    sta    WSYNC
;---------------------------------------
    dey
    bne    .drawBottomLines


    lda    #36
    sta    VBLANK                   ; 0011 0110, turn electron beam off
    sta    TIM64T                   ; reuse value for overscan time

.waitOverscan:
    lda    INTIM
    bne    .waitOverscan
    jmp    MainLoop


        ORG $FE00

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;      SUBROUTINES
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

HorizPositioning SUBROUTINE
    sec
    sta    WSYNC
;---------------------------------------
.loopDivideBy15:
    sbc    #15                   ; 2
    bcs    .loopDivideBy15       ; 2³
    eor    #$07                  ; 2
    asl                          ; 2
    asl                          ; 2
    asl                          ; 2
    asl                          ; 2
    sta    HMP0,X                ; 4
    sta    RESP0,X               ; 4
    rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;uses illegal opcode $80 (double NOP),
;NOP's preserve all flags

WasteTimeOne SUBROUTINE
     .byte $80    ; +0,   30
     .byte $80    ; +1,   29
     .byte $80    ; +2,   27
     .byte $80    ; +3,   26
     .byte $80    ; +4,   24
     .byte $80    ; +5,   23
     .byte $80    ; +6,   21
     .byte $80    ; +7,   20
     .byte $80    ; +8,   18
     .byte $80    ; +9,   17
     .byte $80    ; +10,  15
     nop          ; +11,  14
     rts          ; +12,  12 cycles

WasteTimeTwo SUBROUTINE
     .byte $80    ; +0,   28
     nop          ; +1,   27
     .byte $80    ; +2,   25
     nop          ; +3,   24
     .byte $80    ; +4,   22
     nop          ; +5,   21
     .byte $80    ; +6,   19
     nop          ; +7,   18
     nop          ; +8,   16
     nop          ; +9,   14
     rts          ; +10,  12  cycles

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Initialization SUBROUTINE

;position text at center of screen
    lda    #59
    sta    xPosition
    jsr    HorizPositioning         ; X=0, position P0
    inx                             ; X=1
    lda    #67
    jsr    HorizPositioning         ; position P1
    stx    CTRLPF                   ; reflect playfield
    stx    smallMove                ; counts 3 pixels before increasing a cycle
    inx
    inx                             ; X=3
    stx    VDELP0                   ; delay
    stx    VDELP1
    stx    NUSIZ0                   ; three copies (close)
    stx    NUSIZ1
    sta    WSYNC
;---------------------------------------
    sta    HMOVE

;load gfx pointers, high nibble is already zero
    lda    #<rgTwo
    sta    displayPtrs
    lda    #<rgThree
    sta    displayPtrs+2

;load pointer for indirect jump
    lda    #<FineAdjustCycles+1
    sta    indirect
    lda    #>FineAdjustCycles
    sta    indirect+1

;load actual gfx into ram
    ldx    #48-1
.loopInitalRamGfx:
    lda    ColorsGfxOne,X
    sta    ramGfx,X
    dex
    bpl   .loopInitalRamGfx

;some more inital settings
    lda    #89
    sta    topLines
    lda    #95
    sta    bottomLines
    lda    #6
    sta    largeDelay
    rts

        ORG $FF00

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;      GRAPHICS
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


ColorsGfxOne:
    .byte $00 ; |        | $FF00
    .byte $00 ; |        | $FF01
    .byte $00 ; |        | $FF02
    .byte $F0 ; |XXXX    | $FF03
    .byte $F0 ; |XXXX    | $FF04
    .byte $F0 ; |XXXX    | $FF05
    .byte $00 ; |        | $FF06
    .byte $00 ; |        | $FF07
ColorsGfxTwo:
    .byte $00 ; |        | $FF08
    .byte $73 ; | XXX  XX| $FF09
    .byte $F7 ; |XXXX XXX| $FF0A
    .byte $C6 ; |XX   XX | $FF0B
    .byte $C6 ; |XX   XX | $FF0C
    .byte $C6 ; |XX   XX | $FF0D
    .byte $F7 ; |XXXX XXX| $FF0E
    .byte $73 ; | XXX  XX| $FF0F
ColorsGfxThree:
    .byte $00 ; |        | $FF10
    .byte $9E ; |X  XXXX | $FF11
    .byte $DE ; |XX XXXX | $FF12
    .byte $D8 ; |XX XX   | $FF13
    .byte $D8 ; |XX XX   | $FF14
    .byte $D8 ; |XX XX   | $FF15
    .byte $D8 ; |XX XX   | $FF16
    .byte $98 ; |X  XX   | $FF17
ColorsGfxFour:
    .byte $00 ; |        | $FF18
    .byte $73 ; | XXX  XX| $FF19
    .byte $FB ; |XXXXX XX| $FF1A
    .byte $DB ; |XX XX XX| $FF1B
    .byte $DB ; |XX XX XX| $FF1C
    .byte $DB ; |XX XX XX| $FF1D
    .byte $FB ; |XXXXX XX| $FF1E
    .byte $73 ; | XXX  XX| $FF1F
ColorsGfxFive:
    .byte $00 ; |        | $FF20
    .byte $6E ; | XX XXX | $FF21
    .byte $6F ; | XX XXXX| $FF22
    .byte $C3 ; |XX    XX| $FF23
    .byte $66 ; | XX  XX | $FF24
    .byte $6C ; | XX XX  | $FF25
    .byte $EF ; |XXX XXXX| $FF26
    .byte $C7 ; |XX   XXX| $FF27
ColorsGfxSix:
    .byte $00 ; |        | $FF28
    .byte $00 ; |        | $FF29
    .byte $00 ; |        | $FF2A
    .byte $0F ; |    XXXX| $FF2B
    .byte $0F ; |    XXXX| $FF2C
    .byte $0F ; |    XXXX| $FF2D
    .byte $00 ; |        | $FF2E
    .byte $00 ; |        | $FF2F


ColorsGfxPtrTab:
    .word  rgOne      ; ColorsGfxOne
    .word  rgTwo      ; ColorsGfxTwo
    .word  rgThree    ; ColorsGfxThree
    .word  rgFour     ; ColorsGfxFour
    .word  rgFive     ; ColorsGfxFive
    .word  rgSix      ; ColorsGfxSix


        ORG $FFFA

    .word START,START,START