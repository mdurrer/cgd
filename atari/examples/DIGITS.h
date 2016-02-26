
;73/74 cycle HMxx
LEFT73_15             = $70
LEFT73_14             = $60
LEFT73_13             = $50
LEFT73_12             = $40
LEFT73_11             = $30
LEFT73_10             = $20
LEFT73_9              = $10
LEFT73_8              = $00
LEFT73_7              = $F0
LEFT73_6              = $E0
LEFT73_5              = $D0
LEFT73_4              = $C0
LEFT73_3              = $B0
LEFT73_2              = $A0
LEFT73_1              = $90
NO_MO_73              = $80

DISABLE      = $00
ENABLE       = $02

MISSLE_1     = $03  ; 1 clk,  3 copies close
MISSLE_2     = $13  ; 2 clks, 3 copies close
MISSLE_4     = $23  ; 4 clks, 3 copies close
MISSLE_8     = $33  ; 8 clks, 3 copies close

BALL_1       = $05  ; 1 clk,  PF reflect & priority
BALL_2       = $15  ; 2 clks, PF reflect & priority
BALL_4       = $25  ; 4 clks, PF reflect & priority
BALL_8       = $35  ; 8 clks, PF reflect & priority



;     A        B        C        D        E
;----------------------------------------------
;|  XXXX  |  XXXX  | XXXXXX | XXXXXX | XXXXXX |
;| XX  XX | X    X | X    X | XX  XX | X    X |
;| XX  XX | X    X | X    X | XX  XX | X    X |
;| XX  XX | X    X | X    X | XX  XX | X    X |
;| XX  XX | X    X | X    X | XX  XX | X    X |
;| XX  XX | X    X | X  XXX | XX  XX | X    X |
;| XX  XX | X    X | X  XXX | XX  XX | X    X |
;|  XXXX  |  XXXX  | XXXXXX | XXXXXX | XXXXXX |
;
;     A        B        C        D        E        F        G
;----------------------------------------------------------------
;|    X   |    X   |    X   |    X   |     X  |    X   |   XX   |
;|  XXX   |  XXX   |   XX   |    X   |     X  |    X   |   XX   |
;|   XX   |   XX   |  XXX   |   XX   |    XX  |   XX   |   XX   |
;|   XX   |   XX   |   XX   |   XX   |    XX  |   XX   |   XX   |
;|   XX   |   XX   |   XX   |   XX   |    XX  |   XX   |   XX   |
;|   XX   |   XX   |   XX   |   XX   |    XX  |   XX   |   XX   |
;|   XX   |   XX   |   XX   |   XX   |    XX  |   XX   |   XX   |
;| XXXXXX |  XXXX  |  XXXX  |   XX   |  XXXXX |  XXXX  |   XX   |
;
;     A        B        C        D        E
;----------------------------------------------
;| XXXXX  |  XXXX  |  XXXX  |  XXXX  |  XXXX  |
;|      X | X   XX |      X |      X |      X |
;|      X |     XX |      X |      X |      X |
;|     XX |     XX |      X |      X |      X |
;|  XXX   |  XXXX  |  XXXX  |   XXX  |   XXX  |
;| XX     | XX     | X      |  X     |  XX    |
;| XX     | XX     | X      |  X     |  XX    |
;| XXXXXX | XXXXXX |  XXXXX |  XXXXX |  XXXXX |
;
;     A        B
;-------------------
;| XXXXX  |  XXXX  |
;|     XX | X   XX |
;|     XX |     XX |
;|   XXX  |    XX  |
;|   XXX  |    XX  |
;|     XX |     XX |
;|     XX | X   XX |
;| XXXXX  |  XXXX  |
;
;     A        B        C
;----------------------------
;| XX     | XX  X  |    XX  |
;| XX  X  | XX  X  |   XXX  |
;| XX  X  | XX  X  |  X XX  |
;| XX  X  | XX  X  | X  XX  |
;| XXXXXX | XXXXXX | XXXXXX |
;|    XX  |    XXX |    XX  |
;|    XX  |    XX  |    XX  |
;|    XX  |    XX  |    XX  |
;
;     A        B        C        D
;-------------------------------------
;| XXXXXX | XXXXX  | XXXXX  | XXXXX  |
;| XX     | X      | X      | X      |
;| XX     | X      | X      | X      |
;| XXXXX  | XXXXX  |  XXXX  | XXXXX  |
;|     XX |     XX |     XX |      X |
;|     XX |     XX |     XX |      X |
;|     XX |     XX |     XX |      X |
;| XXXXX  | XXXXX  | XXXXX  | XXXXX  |
;
;     A        B        C
;----------------------------
;|  XXXX  |  XXXX  |  XXXX  |
;| XX   X | X      | X      |
;| XX     | X      | X      |
;| XXXXX  | XXXXX  | X      |
;| XX  XX | X    X | XXXXX  |
;| XX  XX | X    X | X    X |
;| XX  XX | X    X | X    X |
;|  XXXX  |  XXXX  |  XXXX  |
;
;     A        B
;-------------------
;| XXXXXX | XXXXXX |
;|     XX | X   XX |
;|     XX |     XX |
;|    XX  |    XX  |
;|   XX   |   XX   |
;|   XX   |   XX   |
;|   XX   |   XX   |
;|   XX   |   XX   |
;
;     A        B        C        D        E
;----------------------------------------------
;|  XXXX  |  XXXX  |  XXXX  |  XXXX  |  XXXX  |
;| XX  XX | XX  XX |  X  X  | X    X | X    X |
;| XX  XX | XX  XX |  X  X  | X    X | X    X |
;|  XXXX  |  XXXX  | XXXXXX |  XXXX  |  XXXX  |
;|  XXXX  | XX  XX | XX  XX | X    X |  XXXX  |
;| XX  XX | XX  XX | XX  XX | X    X | X    X |
;| XX  XX | XX  XX | XX  XX | X    X | X    X |
;|  XXXX  |  XXXX  | XXXXXX |  XXXX  |  XXXX  |
;
;     A        B        C        D
;-------------------------------------
;|  XXXX  |  XXXX  |  XXXX  |  XXXX  |
;| XX  XX | XX  XX | XX  XX | XX  XX |
;| XX  XX | XX  XX | XX  XX | XX  XX |
;| XX  XX | XX  XX | XX  XX |  XXXXX |
;|  XXXXX |  XXXXX |  XXXX  |     XX |
;|     XX |     XX |     XX |     XX |
;| X   XX |     XX |     XX |     XX |
;|  XXXX  |     XX |  XXXX  |  XXXX  |
;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;      ZERO DIGITS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  MAC ZERO_GFX

    IF {1} = "A"
    .byte $3C ; |  XXXX  |
    .byte $66 ; | XX  XX |
    .byte $66 ; | XX  XX |
    .byte $66 ; | XX  XX |
    .byte $66 ; | XX  XX |
    .byte $66 ; | XX  XX |
    .byte $66 ; | XX  XX |
    .byte $3C ; |  XXXX  |
    ENDIF
    IF {1} = "B"
    .byte $3C ; |  XXXX  |
    .byte $42 ; | X    X |
    .byte $42 ; | X    X |
    .byte $42 ; | X    X |
    .byte $42 ; | X    X |
    .byte $42 ; | X    X |
    .byte $42 ; | X    X |
    .byte $3C ; |  XXXX  |
    ENDIF
    IF {1} = "C"
    .byte $7E ; | XXXXXX |
    .byte $4E ; | X  XXX |
    .byte $4E ; | X  XXX |
    .byte $42 ; | X    X |
    .byte $42 ; | X    X |
    .byte $42 ; | X    X |
    .byte $42 ; | X    X |
    .byte $7E ; | XXXXXX |
    ENDIF
    IF {1} = "D"
    .byte $7E ; | XXXXXX |
    .byte $66 ; | XX  XX |
    .byte $66 ; | XX  XX |
    .byte $66 ; | XX  XX |
    .byte $66 ; | XX  XX |
    .byte $66 ; | XX  XX |
    .byte $66 ; | XX  XX |
    .byte $7E ; | XXXXXX |
    ENDIF
    IF {1} = "E"
    .byte $7E ; | XXXXXX |
    .byte $42 ; | X    X |
    .byte $42 ; | X    X |
    .byte $42 ; | X    X |
    .byte $42 ; | X    X |
    .byte $42 ; | X    X |
    .byte $42 ; | X    X |
    .byte $7E ; | XXXXXX |
    ENDIF

  ENDM

;---------------------------------------

  MAC ZERO_MOVE

    IF {1} = "A"
    .byte   LEFT73_8 | ENABLE   ; |  XXXX  |     | Bx000  | M0
    .byte   LEFT73_5 | DISABLE  ; | XX  XX |     | 11  00 | M0
    .byte   LEFT73_5 | DISABLE  ; | XX  XX |     | 11  00 | M0
    .byte   LEFT73_5 | DISABLE  ; | XX  XX |     | 11  00 | M0
    .byte   LEFT73_5 | DISABLE  ; | XX  XX |     | 11  00 | M0
    .byte   LEFT73_5 | DISABLE  ; | XX  XX |     | 11  00 | M0
    .byte   LEFT73_5 | DISABLE  ; | XX  XX |     | 11  00 | M0
                                ; |  XXXX  |     | Bx000  | line 1
;line 1
    .byte   LEFT73_8 ; M0
    .byte  LEFT73_15 ; M1
    .byte   LEFT73_6 | ENABLE ; BL
    ENDIF
    IF {1} = "B"
    .byte   LEFT73_8 | ENABLE   ; |  XXXX  |     |  0000B | M0
    .byte   LEFT73_9 | DISABLE  ; | X    X |     | 0    1 | M0
    .byte   LEFT73_9 | DISABLE  ; | X    X |     | 0    1 | M0
    .byte   LEFT73_9 | DISABLE  ; | X    X |     | 0    1 | M0
    .byte   LEFT73_9 | DISABLE  ; | X    X |     | 0    1 | M0
    .byte   LEFT73_9 | DISABLE  ; | X    X |     | 0    1 | M0
    .byte   LEFT73_9 | DISABLE  ; | X    X |     | 0    1 | M0
                                ; |  XXXX  |     |  0000B | line 1
;line 1
    .byte   LEFT73_8 ; M0
    .byte  LEFT73_10 ; M1
    .byte   LEFT73_1 | ENABLE ; BL
    ENDIF
    IF {1} = "C"
    .byte   LEFT73_8 | ENABLE   ; | XXXXXX |     | 100000B| M0
    .byte   LEFT73_6 | ENABLE   ; | X  XXX |     | 1  000B| M0
    .byte   LEFT73_6 | ENABLE   ; | X  XXX |     | 1  000B| M0
    .byte   LEFT73_4 | DISABLE  ; | X    X |     | 1    0 | M0
    .byte   LEFT73_4 | DISABLE  ; | X    X |     | 1    0 | M0
    .byte   LEFT73_4 | DISABLE  ; | X    X |     | 1    0 | M0
    .byte   LEFT73_4 | DISABLE  ; | X    X |     | 1    0 | M0
                                ; | XXXXXX |     | 100000B| line 1
;line 1
    .byte   LEFT73_8 ; M0
    .byte  LEFT73_15 ; M1
    .byte   NO_MO_73 | ENABLE ; BL
    ENDIF
    IF {1} = "D"
    .byte   LEFT73_7 | DISABLE  ; | XXXXXX |     | 110000 | M0
    .byte   LEFT73_5 | DISABLE  ; | XX  XX |     | 11  00 | M0
    .byte   LEFT73_5 | DISABLE  ; | XX  XX |     | 11  00 | M0
    .byte   LEFT73_5 | DISABLE  ; | XX  XX |     | 11  00 | M0
    .byte   LEFT73_5 | DISABLE  ; | XX  XX |     | 11  00 | M0
    .byte   LEFT73_5 | DISABLE  ; | XX  XX |     | 11  00 | M0
    .byte   LEFT73_5 | DISABLE  ; | XX  XX |     | 11  00 | M0
                                ; | XXXXXX |     | 110000 | line 1
;line 1
    .byte   LEFT73_7 ; M0
    .byte  LEFT73_15 ; M1
    .byte   NO_MO_73 | DISABLE ; BL
    ENDIF
    IF {1} = "E"
    .byte   LEFT73_8 | ENABLE   ; | XXXXXX |     | 100000B| M0
    .byte   LEFT73_4 | DISABLE  ; | X    X |     | 1    0 | M0
    .byte   LEFT73_4 | DISABLE  ; | X    X |     | 1    0 | M0
    .byte   LEFT73_4 | DISABLE  ; | X    X |     | 1    0 | M0
    .byte   LEFT73_4 | DISABLE  ; | X    X |     | 1    0 | M0
    .byte   LEFT73_4 | DISABLE  ; | X    X |     | 1    0 | M0
    .byte   LEFT73_4 | DISABLE  ; | X    X |     | 1    0 | M0
                                ; | XXXXXX |     | 100000B| line 1
;line 1
    .byte   LEFT73_8 ; M0
    .byte  LEFT73_15 ; M1
    .byte   NO_MO_73 | ENABLE ; BL
    ENDIF

  ENDM

;---------------------------------------

  MAC ZERO_SIZE

    IF {1} = "A"
    .byte  MISSLE_4 ; |  XXXX  |     | Bx000  | M0
    .byte  MISSLE_2 ; | XX  XX |     | 11  00 | M1
    .byte  MISSLE_2 ; | XX  XX |     | 11  00 | M0
    .byte  MISSLE_2 ; | XX  XX |     | 11  00 | M0
    .byte  MISSLE_2 ; | XX  XX |     | 11  00 | M0
    .byte    BALL_1 ; | XX  XX |     | 11  00 | BL
    .byte  MISSLE_2 ; | XX  XX |     | 11  00 | M0
                    ; |  XXXX  |     | Bx000  | line 1
;line 1
    .byte  MISSLE_4 ; M0
    .byte  MISSLE_2 ; M1
    .byte    BALL_1 ; BL
    ENDIF
    IF {1} = "B"
    .byte  MISSLE_4 ; |  XXXX  |     |  0000B | M0
    .byte  MISSLE_1 ; | X    X |     | 0    1 | M1
    .byte  MISSLE_1 ; | X    X |     | 0    1 | M0
    .byte  MISSLE_1 ; | X    X |     | 0    1 | M0
    .byte  MISSLE_1 ; | X    X |     | 0    1 | M0
    .byte    BALL_1 ; | X    X |     | 0    1 | BL
    .byte  MISSLE_1 ; | X    X |     | 0    1 | M0
                    ; |  XXXX  |     |  0000B | line 1
;line 1
    .byte  MISSLE_4 ; M0
    .byte  MISSLE_1 ; M1
    .byte    BALL_1 ; BL
    ENDIF
    IF {1} = "C"
    .byte  MISSLE_8 ; | XXXXXX |     | 100000B| M0
    .byte  MISSLE_1 ; | X  XXX |     | 1  000B| M1
    .byte  MISSLE_4 ; | X  XXX |     | 1  000B| M0
    .byte  MISSLE_1 ; | X    X |     | 1    0 | M0
    .byte  MISSLE_1 ; | X    X |     | 1    0 | M0
    .byte    BALL_1 ; | X    X |     | 1    0 | BL
    .byte  MISSLE_1 ; | X    X |     | 1    0 | M0
                    ; | XXXXXX |     | 100000B| line 1
;line 1
    .byte  MISSLE_8 ; M0
    .byte  MISSLE_1 ; M1
    .byte    BALL_1 ; BL
    ENDIF
    IF {1} = "D"
    .byte  MISSLE_4 ; | XXXXXX |     | 110000 | M0
    .byte  MISSLE_2 ; | XX  XX |     | 11  00 | M1
    .byte  MISSLE_2 ; | XX  XX |     | 11  00 | M0
    .byte  MISSLE_2 ; | XX  XX |     | 11  00 | M0
    .byte  MISSLE_2 ; | XX  XX |     | 11  00 | M0
    .byte    BALL_1 ; | XX  XX |     | 11  00 | BL
    .byte  MISSLE_2 ; | XX  XX |     | 11  00 | M0
                    ; | XXXXXX |     | 110000 | line 1
;line 1
    .byte  MISSLE_4 ; M0
    .byte  MISSLE_2 ; M1
    .byte    BALL_1 ; BL
    ENDIF
    IF {1} = "E"
    .byte  MISSLE_8 ; | XXXXXX |     | 100000B| M0
    .byte  MISSLE_1 ; | X    X |     | 1    0 | M1
    .byte  MISSLE_1 ; | X    X |     | 1    0 | M0
    .byte  MISSLE_1 ; | X    X |     | 1    0 | M0
    .byte  MISSLE_1 ; | X    X |     | 1    0 | M0
    .byte    BALL_1 ; | X    X |     | 1    0 | BL
    .byte  MISSLE_1 ; | X    X |     | 1    0 | M0
                    ; | XXXXXX |     | 100000B| line 1
;line 1
    .byte  MISSLE_8 ; M0
    .byte  MISSLE_1 ; M1
    .byte    BALL_1 ; BL
    ENDIF

  ENDM

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;      ONE DIGITS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  MAC ONE_GFX

    IF {1} = "A"
    .byte $7E ; | XXXXXX |
    .byte $18 ; |   XX   |
    .byte $18 ; |   XX   |
    .byte $18 ; |   XX   |
    .byte $18 ; |   XX   |
    .byte $18 ; |   XX   |
    .byte $38 ; |  XXX   |
    .byte $08 ; |    X   |
    ENDIF
    IF {1} = "B"
    .byte $3C ; |  XXXX  |
    .byte $18 ; |   XX   |
    .byte $18 ; |   XX   |
    .byte $18 ; |   XX   |
    .byte $18 ; |   XX   |
    .byte $18 ; |   XX   |
    .byte $38 ; |  XXX   |
    .byte $08 ; |    X   |
    ENDIF
    IF {1} = "C"
    .byte $3C ; |  XXXX  |
    .byte $18 ; |   XX   |
    .byte $18 ; |   XX   |
    .byte $18 ; |   XX   |
    .byte $18 ; |   XX   |
    .byte $38 ; |  XXX   |
    .byte $18 ; |   XX   |
    .byte $08 ; |    X   |
    ENDIF
    IF {1} = "D"
    .byte $18 ; |   XX   |
    .byte $18 ; |   XX   |
    .byte $18 ; |   XX   |
    .byte $18 ; |   XX   |
    .byte $18 ; |   XX   |
    .byte $18 ; |   XX   |
    .byte $08 ; |    X   |
    .byte $08 ; |    X   |
    ENDIF
    IF {1} = "E"
    .byte $3E ; |  XXXXX |
    .byte $0C ; |    XX  |
    .byte $0C ; |    XX  |
    .byte $0C ; |    XX  |
    .byte $0C ; |    XX  |
    .byte $0C ; |    XX  |
    .byte $04 ; |     X  |
    .byte $04 ; |     X  |
    ENDIF
    IF {1} = "F"
    .byte $3C ; |  XXXX  |
    .byte $18 ; |   XX   |
    .byte $18 ; |   XX   |
    .byte $18 ; |   XX   |
    .byte $18 ; |   XX   |
    .byte $18 ; |   XX   |
    .byte $08 ; |    X   |
    .byte $08 ; |    X   |
    ENDIF
    IF {1} = "G"
    .byte $18 ; |   XX   |
    .byte $18 ; |   XX   |
    .byte $18 ; |   XX   |
    .byte $18 ; |   XX   |
    .byte $18 ; |   XX   |
    .byte $18 ; |   XX   |
    .byte $18 ; |   XX   |
    .byte $18 ; |   XX   |
    ENDIF

  ENDM

;---------------------------------------

  MAC ONE_MOVE

    IF {1} = "A"
    .byte   LEFT73_9 | ENABLE   ; | XXXXXX |     | 000x00B| M0
    .byte   LEFT73_7 | DISABLE  ; |   XX   |     |   0x   | M0
    .byte   LEFT73_7 | DISABLE  ; |   XX   |     |   0x   | M0
    .byte   LEFT73_7 | DISABLE  ; |   XX   |     |   0x   | M0
    .byte   LEFT73_7 | DISABLE  ; |   XX   |     |   0x   | M0
    .byte   LEFT73_7 | DISABLE  ; |   XX   |     |   0x   | M0
    .byte   LEFT73_8 | DISABLE  ; |  XXX   |     |  001   | M0
                                ; |    X   |     |    x   | line 1
;line 1
    .byte   LEFT73_6 ; M0
    .byte  LEFT73_12 ; M1
    .byte   NO_MO_73 | DISABLE ; BL
    ENDIF
    IF {1} = "B"
    .byte   LEFT73_8 | DISABLE  ; |  XXXX  |     |  00x0  | M0
    .byte   LEFT73_7 | DISABLE  ; |   XX   |     |   0x   | M0
    .byte   LEFT73_7 | DISABLE  ; |   XX   |     |   0x   | M0
    .byte   LEFT73_7 | DISABLE  ; |   XX   |     |   0x   | M0
    .byte   LEFT73_7 | DISABLE  ; |   XX   |     |   0x   | M0
    .byte   LEFT73_7 | DISABLE  ; |   XX   |     |   0x   | M0
    .byte   LEFT73_8 | DISABLE  ; |  XXX   |     |  001   | M0
                                ; |    X   |     |    x   | line 1
;line 1
    .byte   LEFT73_6 ; M0
    .byte  LEFT73_12 ; M1
    .byte   NO_MO_73 | DISABLE ; BL
    ENDIF
    IF {1} = "C"
    .byte   LEFT73_8 | DISABLE  ; |  XXXX  |     |  00x0  | M0
    .byte   LEFT73_7 | DISABLE  ; |   XX   |     |   0x   | M0
    .byte   LEFT73_7 | DISABLE  ; |   XX   |     |   0x   | M0
    .byte   LEFT73_7 | DISABLE  ; |   XX   |     |   0x   | M0
    .byte   LEFT73_7 | DISABLE  ; |   XX   |     |   0x   | M0
    .byte   LEFT73_8 | DISABLE  ; |  XXX   |     |  001   | M0
    .byte   LEFT73_7 | DISABLE  ; |   XX   |     |   0x   | M0
                                ; |    X   |     |    x   | line 1
;line 1
    .byte   LEFT73_6 ; M0
    .byte  LEFT73_12 ; M1
    .byte   NO_MO_73 | DISABLE ; BL
    ENDIF
    IF {1} = "D"
    .byte   LEFT73_7 | DISABLE  ; |   XX   |     |   00   | M0
    .byte   LEFT73_7 | DISABLE  ; |   XX   |     |   00   | M0
    .byte   LEFT73_7 | DISABLE  ; |   XX   |     |   00   | M0
    .byte   LEFT73_7 | DISABLE  ; |   XX   |     |   00   | M0
    .byte   LEFT73_7 | DISABLE  ; |   XX   |     |   00   | M0
    .byte   LEFT73_7 | DISABLE  ; |   XX   |     |   00   | M0
    .byte   LEFT73_6 | ENABLE   ; |    X   |     |    0B  | M0
                                ; |    X   |     |    0   | line 1
;line 1
    .byte   LEFT73_6 ; M0
    .byte   NO_MO_73 ; M1
    .byte   LEFT73_2 | DISABLE ; BL
    ENDIF
    IF {1} = "E"
    .byte   LEFT73_8 | ENABLE   ; |  XXXXX |     |  000x0B| M0
    .byte   LEFT73_6 | DISABLE  ; |    XX  |     |    0x  | M0
    .byte   LEFT73_6 | DISABLE  ; |    XX  |     |    0x  | M0
    .byte   LEFT73_6 | DISABLE  ; |    XX  |     |    0x  | M0
    .byte   LEFT73_6 | DISABLE  ; |    XX  |     |    0x  | M0
    .byte   LEFT73_6 | DISABLE  ; |    XX  |     |    01  | M0
    .byte   LEFT73_5 | DISABLE  ; |     X  |     |     x  | M0
                                ; |     X  |     |     x  | line 1
;line 1
    .byte   LEFT73_5 ; M0
    .byte  LEFT73_11 ; M1
    .byte   NO_MO_73 | DISABLE ; BL
    ENDIF
    IF {1} = "F"
    .byte   LEFT73_8 | DISABLE  ; |  XXXX  |     |  0000  | M0
    .byte   LEFT73_7 | DISABLE  ; |   XX   |     |   00   | M0
    .byte   LEFT73_7 | DISABLE  ; |   XX   |     |   00   | M0
    .byte   LEFT73_7 | DISABLE  ; |   XX   |     |   00   | M0
    .byte   LEFT73_7 | DISABLE  ; |   XX   |     |   00   | M0
    .byte   LEFT73_7 | DISABLE  ; |   XX   |     |   00   | M0
    .byte   LEFT73_6 | ENABLE   ; |    X   |     |    0B  | M0
                                ; |    X   |     |    0   | line 1
;line 1
    .byte   LEFT73_6 ; M0
    .byte   NO_MO_73 ; M1
    .byte   LEFT73_2 | DISABLE ; BL
    ENDIF
    IF {1} = "G"
    .byte   LEFT73_7 | DISABLE  ; |   XX   |     |   00   | M0
    .byte   LEFT73_7 | DISABLE  ; |   XX   |     |   00   | M0
    .byte   LEFT73_7 | DISABLE  ; |   XX   |     |   00   | M0
    .byte   LEFT73_7 | DISABLE  ; |   XX   |     |   00   | M0
    .byte   LEFT73_7 | DISABLE  ; |   XX   |     |   00   | M0
    .byte   LEFT73_7 | DISABLE  ; |   XX   |     |   00   | M0
    .byte   LEFT73_7 | DISABLE  ; |   XX   |     |   00   | M0
                                ; |   XX   |     |   00   | line 1
;line 1
    .byte   LEFT73_7 ; M0
    .byte   NO_MO_73 ; M1
    .byte   NO_MO_73 | DISABLE ; BL
    ENDIF

  ENDM

;---------------------------------------

  MAC ONE_SIZE

    IF {1} = "A"
    .byte  MISSLE_8 ; | XXXXXX |     | 000x00B| M0
    .byte  MISSLE_1 ; |   XX   |     |   0x   | M1
    .byte  MISSLE_2 ; |   XX   |     |   0x   | M0
    .byte  MISSLE_2 ; |   XX   |     |   0x   | M0
    .byte  MISSLE_2 ; |   XX   |     |   0x   | M0
    .byte    BALL_1 ; |   XX   |     |   0x   | BL
    .byte  MISSLE_2 ; |  XXX   |     |  001   | M0
                    ; |    X   |     |    x   | line 1
;line 1
    .byte  MISSLE_1 ; M0
    .byte  MISSLE_1 ; M1
    .byte    BALL_1 ; BL
    ENDIF
    IF {1} = "B"
    .byte  MISSLE_4 ; |  XXXX  |     |  00x0  | M0
    .byte  MISSLE_1 ; |   XX   |     |   0x   | M1
    .byte  MISSLE_2 ; |   XX   |     |   0x   | M0
    .byte  MISSLE_2 ; |   XX   |     |   0x   | M0
    .byte  MISSLE_2 ; |   XX   |     |   0x   | M0
    .byte    BALL_1 ; |   XX   |     |   0x   | BL
    .byte  MISSLE_2 ; |  XXX   |     |  001   | M0
                    ; |    X   |     |    x   | line 1
;line 1
    .byte  MISSLE_1 ; M0
    .byte  MISSLE_1 ; M1
    .byte    BALL_1 ; BL
    ENDIF
    IF {1} = "C"
    .byte  MISSLE_4 ; |  XXXX  |     |  00x0  | M0
    .byte  MISSLE_1 ; |   XX   |     |   0x   | M1
    .byte  MISSLE_2 ; |   XX   |     |   0x   | M0
    .byte  MISSLE_2 ; |   XX   |     |   0x   | M0
    .byte  MISSLE_2 ; |   XX   |     |   0x   | M0
    .byte    BALL_1 ; |  XXX   |     |  001   | BL
    .byte  MISSLE_2 ; |   XX   |     |   0x   | M0
                    ; |    X   |     |    x   | line 1
;line 1
    .byte  MISSLE_1 ; M0
    .byte  MISSLE_1 ; M1
    .byte    BALL_1 ; BL
    ENDIF
    IF {1} = "D"
    .byte  MISSLE_2 ; |   XX   |     |   00   | M0
    .byte  MISSLE_1 ; |   XX   |     |   00   | M1
    .byte  MISSLE_2 ; |   XX   |     |   00   | M0
    .byte  MISSLE_2 ; |   XX   |     |   00   | M0
    .byte  MISSLE_2 ; |   XX   |     |   00   | M0
    .byte    BALL_1 ; |   XX   |     |   00   | BL
    .byte  MISSLE_2 ; |    X   |     |    0B  | M0
                    ; |    X   |     |    0   | line 1
;line 1
    .byte  MISSLE_1 ; M0
    .byte  MISSLE_1 ; M1
    .byte    BALL_1 ; BL
    ENDIF
    IF {1} = "E"
    .byte  MISSLE_8 ; |  XXXXX |     |  000x0B| M0
    .byte  MISSLE_1 ; |    XX  |     |    0x  | M1
    .byte  MISSLE_2 ; |    XX  |     |    0x  | M0
    .byte  MISSLE_2 ; |    XX  |     |    0x  | M0
    .byte  MISSLE_2 ; |    XX  |     |    0x  | M0
    .byte    BALL_1 ; |    XX  |     |    01  | BL
    .byte  MISSLE_1 ; |     X  |     |     x  | M0
                    ; |     X  |     |     x  | line 1
;line 1
    .byte  MISSLE_1 ; M0
    .byte  MISSLE_1 ; M1
    .byte    BALL_1 ; BL
    ENDIF
    IF {1} = "F"
    .byte  MISSLE_4 ; |  XXXX  |     |  0000  | M0
    .byte  MISSLE_1 ; |   XX   |     |   00   | M1
    .byte  MISSLE_2 ; |   XX   |     |   00   | M0
    .byte  MISSLE_2 ; |   XX   |     |   00   | M0
    .byte  MISSLE_2 ; |   XX   |     |   00   | M0
    .byte    BALL_1 ; |   XX   |     |   00   | BL
    .byte  MISSLE_2 ; |    X   |     |    0B  | M0
                    ; |    X   |     |    0   | line 1
;line 1
    .byte  MISSLE_1 ; M0
    .byte  MISSLE_1 ; M1
    .byte    BALL_1 ; BL
    ENDIF
    IF {1} = "G"
    .byte  MISSLE_2 ; |   XX   |     |   00   | M0
    .byte  MISSLE_1 ; |   XX   |     |   00   | M1
    .byte  MISSLE_2 ; |   XX   |     |   00   | M0
    .byte  MISSLE_2 ; |   XX   |     |   00   | M0
    .byte  MISSLE_2 ; |   XX   |     |   00   | M0
    .byte    BALL_1 ; |   XX   |     |   00   | BL
    .byte  MISSLE_2 ; |   XX   |     |   00   | M0
                    ; |   XX   |     |   00   | line 1
;line 1
    .byte  MISSLE_2 ; M0
    .byte  MISSLE_1 ; M1
    .byte    BALL_1 ; BL
    ENDIF

  ENDM

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;      TWO DIGITS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  MAC TWO_GFX

    IF {1} = "A"
    .byte $7E ; | XXXXXX |
    .byte $60 ; | XX     |
    .byte $60 ; | XX     |
    .byte $38 ; |  XXX   |
    .byte $06 ; |     XX |
    .byte $02 ; |      X |
    .byte $02 ; |      X |
    .byte $7C ; | XXXXX  |
    ENDIF
    IF {1} = "B"
    .byte $7E ; | XXXXXX |
    .byte $60 ; | XX     |
    .byte $60 ; | XX     |
    .byte $3C ; |  XXXX  |
    .byte $06 ; |     XX |
    .byte $06 ; |     XX |
    .byte $46 ; | X   XX |
    .byte $3C ; |  XXXX  |
    ENDIF
    IF {1} = "C"
    .byte $3E ; |  XXXXX |
    .byte $40 ; | X      |
    .byte $40 ; | X      |
    .byte $3C ; |  XXXX  |
    .byte $02 ; |      X |
    .byte $02 ; |      X |
    .byte $02 ; |      X |
    .byte $3C ; |  XXXX  |
    ENDIF
    IF {1} = "D"
    .byte $3E ; |  XXXXX |
    .byte $20 ; |  X     |
    .byte $20 ; |  X     |
    .byte $1C ; |   XXX  |
    .byte $02 ; |      X |
    .byte $02 ; |      X |
    .byte $02 ; |      X |
    .byte $3C ; |  XXXX  |
    ENDIF
    IF {1} = "E"
    .byte $3E ; |  XXXXX |
    .byte $30 ; |  XX    |
    .byte $30 ; |  XX    |
    .byte $1C ; |   XXX  |
    .byte $02 ; |      X |
    .byte $02 ; |      X |
    .byte $02 ; |      X |
    .byte $3C ; |  XXXX  |
    ENDIF

  ENDM

;---------------------------------------

  MAC TWO_MOVE

    IF {1} = "A"
    .byte   LEFT73_7 | DISABLE  ; | XXXXXX |     | 110000 | M0
    .byte   LEFT73_8 | DISABLE  ; | XX     |     | 1x     | M0
    .byte   LEFT73_8 | DISABLE  ; | XX     |     | 10     | M0
    .byte   LEFT73_9 | ENABLE   ; |  XXX   |     | B000   | M0
    .byte   LEFT73_5 | ENABLE   ; |     XX |     | B   00 | M0
    .byte   LEFT73_4 | ENABLE   ; |      X |     | B    0 | M0
    .byte   LEFT73_4 | ENABLE   ; |      X |     | B    0 | M0
                                ; | XXXXX  |     | 10000  | line 1
;line 1
    .byte   LEFT73_8 ; M0
    .byte  LEFT73_15 ; M1
    .byte   LEFT73_6 | DISABLE ; BL
    ENDIF
    IF {1} = "B"
    .byte   LEFT73_7 | DISABLE  ; | XXXXXX |     | 110000 | M0
    .byte   LEFT73_8 | DISABLE  ; | XX     |     | 1x     | M0
    .byte   LEFT73_8 | DISABLE  ; | XX     |     | 10     | M0
    .byte   LEFT73_8 | ENABLE   ; |  XXXX  |     | B0000  | M0
    .byte   LEFT73_5 | ENABLE   ; |     XX |     | B   00 | M0
    .byte   LEFT73_5 | ENABLE   ; |     XX |     | B   00 | M0
    .byte   LEFT73_5 | DISABLE  ; | X   XX |     | 1   00 | M0
                                ; |  XXXX  |     | B0000  | line 1
;line 1
    .byte   LEFT73_8 ; M0
    .byte  LEFT73_15 ; M1
    .byte   LEFT73_6 | ENABLE ; BL
    ENDIF
    IF {1} = "C"
    .byte   LEFT73_8 | ENABLE   ; |  XXXXX |     |  00000B| M0
    .byte   LEFT73_9 | DISABLE  ; | X      |     | 0      | M0
    .byte   LEFT73_9 | DISABLE  ; | X      |     | 0      | M0
    .byte   LEFT73_8 | DISABLE  ; |  XXXX  |     |  0000  | M0
    .byte   LEFT73_4 | DISABLE  ; |      X |     |      0 | M0
    .byte   LEFT73_4 | DISABLE  ; |      X |     |      0 | M0
    .byte   LEFT73_4 | DISABLE  ; |      X |     |      0 | M0
                                ; |  XXXX  |     |  0000  | line 1
;line 1
    .byte   LEFT73_8 ; M0
    .byte   NO_MO_73 ; M1
    .byte   NO_MO_73 | DISABLE ; BL
    ENDIF
    IF {1} = "D"
    .byte   LEFT73_7 | DISABLE  ; |  XXXXX |     |  10000 | M0
    .byte   LEFT73_8 | DISABLE  ; |  X     |     |  x     | M0
    .byte   LEFT73_8 | DISABLE  ; |  X     |     |  x     | M0
    .byte   LEFT73_8 | ENABLE   ; |   XXX  |     |  B000  | M0
    .byte   LEFT73_4 | ENABLE   ; |      X |     |  B   0 | M0
    .byte   LEFT73_4 | ENABLE   ; |      X |     |  B   0 | M0
    .byte   LEFT73_4 | ENABLE   ; |      X |     |  B   0 | M0
                                ; |  XXXX  |     |  x000  | line 1
;line 1
    .byte   LEFT73_8 ; M0
    .byte  LEFT73_14 ; M1
    .byte   LEFT73_5 | DISABLE ; BL
    ENDIF
    IF {1} = "E"
    .byte   LEFT73_7 | DISABLE  ; |  XXXXX |     |  10000 | M0
    .byte   LEFT73_8 | DISABLE  ; |  XX    |     |  x0    | M0
    .byte   LEFT73_8 | DISABLE  ; |  XX    |     |  x0    | M0
    .byte   LEFT73_8 | ENABLE   ; |   XXX  |     |  B000  | M0
    .byte   LEFT73_4 | ENABLE   ; |      X |     |  B   0 | M0
    .byte   LEFT73_4 | ENABLE   ; |      X |     |  B   0 | M0
    .byte   LEFT73_4 | ENABLE   ; |      X |     |  B   0 | M0
                                ; |  XXXX  |     |  x000  | line 1
;line 1
    .byte   LEFT73_8 ; M0
    .byte  LEFT73_14 ; M1
    .byte   LEFT73_5 | DISABLE ; BL
    ENDIF

  ENDM

;---------------------------------------

  MAC TWO_SIZE

    IF {1} = "A"
    .byte  MISSLE_4 ; | XXXXXX |     | 110000 | M0
    .byte  MISSLE_2 ; | XX     |     | 1x     | M1
    .byte  MISSLE_1 ; | XX     |     | 10     | M0
    .byte  MISSLE_4 ; |  XXX   |     | B000   | M0
    .byte  MISSLE_2 ; |     XX |     | B   00 | M0
    .byte    BALL_1 ; |      X |     | B    0 | BL
    .byte  MISSLE_1 ; |      X |     | B    0 | M0
                    ; | XXXXX  |     | 10000  | line 1
;line 1
    .byte  MISSLE_4 ; M0
    .byte  MISSLE_1 ; M1
    .byte    BALL_1 ; BL
    ENDIF
    IF {1} = "B"
    .byte  MISSLE_4 ; | XXXXXX |     | 110000 | M0
    .byte  MISSLE_2 ; | XX     |     | 1x     | M1
    .byte  MISSLE_1 ; | XX     |     | 10     | M0
    .byte  MISSLE_4 ; |  XXXX  |     | B0000  | M0
    .byte  MISSLE_2 ; |     XX |     | B   00 | M0
    .byte    BALL_1 ; |     XX |     | B   00 | BL
    .byte  MISSLE_2 ; | X   XX |     | 1   00 | M0
                    ; |  XXXX  |     | B0000  | line 1
;line 1
    .byte  MISSLE_4 ; M0
    .byte  MISSLE_1 ; M1
    .byte    BALL_1 ; BL
    ENDIF
    IF {1} = "C"
    .byte  MISSLE_8 ; |  XXXXX |     |  00000B| M0
    .byte  MISSLE_1 ; | X      |     | 0      | M1
    .byte  MISSLE_1 ; | X      |     | 0      | M0
    .byte  MISSLE_4 ; |  XXXX  |     |  0000  | M0
    .byte  MISSLE_1 ; |      X |     |      0 | M0
    .byte    BALL_1 ; |      X |     |      0 | BL
    .byte  MISSLE_1 ; |      X |     |      0 | M0
                    ; |  XXXX  |     |  0000  | line 1
;line 1
    .byte  MISSLE_4 ; M0
    .byte  MISSLE_1 ; M1
    .byte    BALL_1 ; BL
    ENDIF
    IF {1} = "D"
    .byte  MISSLE_4 ; |  XXXXX |     |  10000 | M0
    .byte  MISSLE_1 ; |  X     |     |  x     | M1
    .byte  MISSLE_1 ; |  X     |     |  x     | M0
    .byte  MISSLE_4 ; |   XXX  |     |  B000  | M0
    .byte  MISSLE_1 ; |      X |     |  B   0 | M0
    .byte    BALL_1 ; |      X |     |  B   0 | BL
    .byte  MISSLE_1 ; |      X |     |  B   0 | M0
                    ; |  XXXX  |     |  x000  | line 1
;line 1
    .byte  MISSLE_4 ; M0
    .byte  MISSLE_1 ; M1
    .byte    BALL_1 ; BL
    ENDIF
    IF {1} = "E"
    .byte  MISSLE_4 ; |  XXXXX |     |  10000 | M0
    .byte  MISSLE_1 ; |  XX    |     |  x0    | M1
    .byte  MISSLE_2 ; |  XX    |     |  x0    | M0
    .byte  MISSLE_4 ; |   XXX  |     |  B000  | M0
    .byte  MISSLE_1 ; |      X |     |  B   0 | M0
    .byte    BALL_1 ; |      X |     |  B   0 | BL
    .byte  MISSLE_1 ; |      X |     |  B   0 | M0
                    ; |  XXXX  |     |  x000  | line 1
;line 1
    .byte  MISSLE_4 ; M0
    .byte  MISSLE_1 ; M1
    .byte    BALL_1 ; BL
    ENDIF

  ENDM

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;      THREE DIGITS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  MAC THREE_GFX

    IF {1} = "A"
    .byte $7C ; | XXXXX  |
    .byte $06 ; |     XX |
    .byte $06 ; |     XX |
    .byte $1C ; |   XXX  |
    .byte $1C ; |   XXX  |
    .byte $06 ; |     XX |
    .byte $06 ; |     XX |
    .byte $7C ; | XXXXX  |
    ENDIF
    IF {1} = "B"
    .byte $3C ; |  XXXX  |
    .byte $46 ; | X   XX |
    .byte $06 ; |     XX |
    .byte $0C ; |    XX  |
    .byte $0C ; |    XX  |
    .byte $06 ; |     XX |
    .byte $46 ; | X   XX |
    .byte $3C ; |  XXXX  |
    ENDIF

  ENDM

;---------------------------------------

  MAC THREE_MOVE

    IF {1} = "A"
    .byte   LEFT73_9 | DISABLE  ; | XXXXX  |     | 00001  | M0
    .byte   LEFT73_4 | DISABLE  ; |     XX |     |     10 | M0
    .byte   LEFT73_4 | DISABLE  ; |     XX |     |     10 | M0
    .byte   LEFT73_7 | DISABLE  ; |   XXX  |     |   001  | M0
    .byte   LEFT73_7 | DISABLE  ; |   XXX  |     |   001  | M0
    .byte   LEFT73_4 | DISABLE  ; |     XX |     |     10 | M0
    .byte   LEFT73_4 | DISABLE  ; |     XX |     |     10 | M0
                                ; | XXXXX  |     | 00001  | line 1
;line 1
    .byte   LEFT73_9 ; M0
    .byte  LEFT73_11 ; M1
    .byte   NO_MO_73 | DISABLE ; BL
    ENDIF
    IF {1} = "B"
    .byte   LEFT73_8 | ENABLE   ; |  XXXX  |     | B0000  | M0
    .byte   LEFT73_5 | DISABLE  ; | X   XX |     | 1   00 | M0
    .byte   LEFT73_5 | ENABLE   ; |     XX |     | B   00 | M0
    .byte   LEFT73_6 | ENABLE   ; |    XX  |     | B  00  | M0
    .byte   LEFT73_6 | ENABLE   ; |    XX  |     | B  00  | M0
    .byte   LEFT73_5 | ENABLE   ; |     XX |     | B   00 | M0
    .byte   LEFT73_5 | DISABLE  ; | X   XX |     | 1   00 | M0
                                ; |  XXXX  |     | B0000  | line 1
;line 1
    .byte   LEFT73_8 ; M0
    .byte  LEFT73_15 ; M1
    .byte   LEFT73_6 | ENABLE ; BL
    ENDIF

  ENDM

;---------------------------------------

  MAC THREE_SIZE

    IF {1} = "A"
    .byte  MISSLE_4 ; | XXXXX  |     | 00001  | M0
    .byte  MISSLE_1 ; |     XX |     |     10 | M1
    .byte  MISSLE_1 ; |     XX |     |     10 | M0
    .byte  MISSLE_2 ; |   XXX  |     |   001  | M0
    .byte  MISSLE_2 ; |   XXX  |     |   001  | M0
    .byte    BALL_1 ; |     XX |     |     10 | BL
    .byte  MISSLE_1 ; |     XX |     |     10 | M0
                    ; | XXXXX  |     | 00001  | line 1
;line 1
    .byte  MISSLE_4 ; M0
    .byte  MISSLE_1 ; M1
    .byte    BALL_1 ; BL
    ENDIF
    IF {1} = "B"
    .byte  MISSLE_4 ; |  XXXX  |     | B0000  | M0
    .byte  MISSLE_1 ; | X   XX |     | 1   00 | M1
    .byte  MISSLE_2 ; |     XX |     | B   00 | M0
    .byte  MISSLE_2 ; |    XX  |     | B  00  | M0
    .byte  MISSLE_2 ; |    XX  |     | B  00  | M0
    .byte    BALL_1 ; |     XX |     | B   00 | BL
    .byte  MISSLE_2 ; | X   XX |     | 1   00 | M0
                    ; |  XXXX  |     | B0000  | line 1
;line 1
    .byte  MISSLE_4 ; M0
    .byte  MISSLE_1 ; M1
    .byte    BALL_1 ; BL
    ENDIF

  ENDM

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;      FOUR DIGITS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  MAC FOUR_GFX

    IF {1} = "A"
    .byte $0C ; |    XX  |
    .byte $0C ; |    XX  |
    .byte $0C ; |    XX  |
    .byte $7E ; | XXXXXX |
    .byte $64 ; | XX  X  |
    .byte $64 ; | XX  X  |
    .byte $64 ; | XX  X  |
    .byte $60 ; | XX     |
    ENDIF
    IF {1} = "B"
    .byte $0C ; |    XX  |
    .byte $0C ; |    XX  |
    .byte $0E ; |    XXX |
    .byte $7E ; | XXXXXX |
    .byte $64 ; | XX  X  |
    .byte $64 ; | XX  X  |
    .byte $64 ; | XX  X  |
    .byte $64 ; | XX  X  |
    ENDIF
    IF {1} = "C"
    .byte $0C ; |    XX  |
    .byte $0C ; |    XX  |
    .byte $0C ; |    XX  |
    .byte $7E ; | XXXXXX |
    .byte $4C ; | X  XX  |
    .byte $2C ; |  X XX  |
    .byte $1C ; |   XXX  |
    .byte $0C ; |    XX  |
    ENDIF

  ENDM

;---------------------------------------

  MAC FOUR_MOVE

    IF {1} = "A"
    .byte   LEFT73_6 | ENABLE   ; |    XX  |     |BBBB00  | M0
    .byte   LEFT73_6 | ENABLE   ; |    XX  |     |BBBB00  | M0
    .byte   LEFT73_6 | ENABLE   ; |    XX  |     |BBBB00  | M0
    .byte   LEFT73_7 | DISABLE  ; | XXXXXX |     | 110000 | M0
    .byte   LEFT73_5 | DISABLE  ; | XX  X  |     | 11  0  | M0
    .byte   LEFT73_5 | DISABLE  ; | XX  X  |     | 11  0  | M0
    .byte   LEFT73_5 | DISABLE  ; | XX  X  |     | 11  0  | M0
                                ; | XX     |     | 1x     | line 1
;line 1
    .byte   LEFT73_8 ; M0
    .byte  LEFT73_15 ; M1
    .byte   LEFT73_7 | DISABLE ; BL
    ENDIF
    IF {1} = "B"
    .byte   LEFT73_6 | ENABLE   ; |    XX  |     |BBBB00  | M0
    .byte   LEFT73_8 | ENABLE   ; |    XX  |     |BBBB00  | M0
    .byte   LEFT73_7 | ENABLE   ; |    XXX |     |BBBB000 | M0
    .byte   LEFT73_7 | DISABLE  ; | XXXXXX |     | 110000 | M0
    .byte   LEFT73_5 | DISABLE  ; | XX  X  |     | 11  0  | M0
    .byte   LEFT73_5 | DISABLE  ; | XX  X  |     | 11  0  | M0
    .byte   LEFT73_5 | DISABLE  ; | XX  X  |     | 11  0  | M0
                                ; | XX  X  |     | 11  0  | line 1
;line 1
    .byte   LEFT73_5 ; M0
    .byte  LEFT73_15 ; M1
    .byte   LEFT73_7 | DISABLE ; BL
    ENDIF
    IF {1} = "C"
    .byte   NO_MO_73 | DISABLE  ; |    XX  |     |    11  | M0
    .byte   NO_MO_73 | DISABLE  ; |    XX  |     |    11  | M0
    .byte   LEFT73_6 | DISABLE  ; |    XX  |     |    x1  | M0
    .byte   LEFT73_9 | ENABLE   ; | XXXXXX |     | 000xx0B| M0
    .byte   LEFT73_9 | DISABLE  ; | X  XX  |     | 0  11  | M0
    .byte   LEFT73_8 | DISABLE  ; |  X XX  |     |  0 11  | M0
    .byte   LEFT73_7 | DISABLE  ; |   XXX  |     |   011  | M0
                                ; |    XX  |     |    x1  | line 1
;line 1
    .byte   LEFT73_6 ; M0
    .byte  LEFT73_12 ; M1
    .byte   NO_MO_73 | DISABLE ; BL
    ENDIF

  ENDM

;---------------------------------------

  MAC FOUR_SIZE

    IF {1} = "A"
    .byte  MISSLE_2 ; |    XX  |     |BBBB00  | M0
    .byte  MISSLE_2 ; |    XX  |     |BBBB00  | M1
    .byte  MISSLE_2 ; |    XX  |     |BBBB00  | M0
    .byte  MISSLE_4 ; | XXXXXX |     | 110000 | M0
    .byte  MISSLE_1 ; | XX  X  |     | 11  0  | M0
    .byte    BALL_4 ; | XX  X  |     | 11  0  | BL
    .byte  MISSLE_1 ; | XX  X  |     | 11  0  | M0
                    ; | XX     |     | 1x     | line 1
;line 1
    .byte  MISSLE_1 ; M0
    .byte  MISSLE_2 ; M1
    .byte    BALL_4 ; BL
    ENDIF
    IF {1} = "B"
    .byte  MISSLE_2 ; |    XX  |     |BBBB00  | M0
    .byte  MISSLE_2 ; |    XX  |     |BBBB00  | M1
    .byte  MISSLE_4 ; |    XXX |     |BBBB000 | M0
    .byte  MISSLE_4 ; | XXXXXX |     | 110000 | M0
    .byte  MISSLE_1 ; | XX  X  |     | 11  0  | M0
    .byte    BALL_4 ; | XX  X  |     | 11  0  | BL
    .byte  MISSLE_1 ; | XX  X  |     | 11  0  | M0
                    ; | XX  X  |     | 11  0  | line 1
;line 1
    .byte  MISSLE_1 ; M0
    .byte  MISSLE_2 ; M1
    .byte    BALL_4 ; BL
    ENDIF
    IF {1} = "C"
    .byte  MISSLE_1 ; |    XX  |     |    11  | M0
    .byte  MISSLE_2 ; |    XX  |     |    11  | M1
    .byte  MISSLE_1 ; |    XX  |     |    x1  | M0
    .byte  MISSLE_8 ; | XXXXXX |     | 000xx0B| M0
    .byte  MISSLE_1 ; | X  XX  |     | 0  11  | M0
    .byte    BALL_2 ; |  X XX  |     |  0 11  | BL
    .byte  MISSLE_1 ; |   XXX  |     |   011  | M0
                    ; |    XX  |     |    x1  | line 1
;line 1
    .byte  MISSLE_1 ; M0
    .byte  MISSLE_2 ; M1
    .byte    BALL_2 ; BL
    ENDIF

  ENDM

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;      FIVE DIGITS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  MAC FIVE_GFX

    IF {1} = "A"
    .byte $7C ; | XXXXX  |
    .byte $06 ; |     XX |
    .byte $06 ; |     XX |
    .byte $06 ; |     XX |
    .byte $7C ; | XXXXX  |
    .byte $60 ; | XX     |
    .byte $60 ; | XX     |
    .byte $7E ; | XXXXXX |
    ENDIF
    IF {1} = "B"
    .byte $7C ; | XXXXX  |
    .byte $06 ; |     XX |
    .byte $06 ; |     XX |
    .byte $06 ; |     XX |
    .byte $7C ; | XXXXX  |
    .byte $40 ; | X      |
    .byte $40 ; | X      |
    .byte $7C ; | XXXXX  |
    ENDIF
    IF {1} = "C"
    .byte $7C ; | XXXXX  |
    .byte $06 ; |     XX |
    .byte $06 ; |     XX |
    .byte $06 ; |     XX |
    .byte $3C ; |  XXXX  |
    .byte $40 ; | X      |
    .byte $40 ; | X      |
    .byte $7C ; | XXXXX  |
    ENDIF
    IF {1} = "D"
    .byte $7C ; | XXXXX  |
    .byte $02 ; |      X |
    .byte $02 ; |      X |
    .byte $02 ; |      X |
    .byte $7C ; | XXXXX  |
    .byte $40 ; | X      |
    .byte $40 ; | X      |
    .byte $7C ; | XXXXX  |
    ENDIF

  ENDM

;---------------------------------------

  MAC FIVE_MOVE

    IF {1} = "A"
    .byte   LEFT73_8 | DISABLE  ; | XXXXX  |     | 1x000  | M0
    .byte   LEFT73_5 | ENABLE   ; |     XX |     | BB  00 | M0
    .byte   LEFT73_5 | ENABLE   ; |     XX |     | BB  00 | M0
    .byte   LEFT73_5 | ENABLE   ; |     XX |     | BB  00 | M0
    .byte   LEFT73_8 | DISABLE  ; | XXXXX  |     | 1x000  | M0
    .byte   LEFT73_9 | DISABLE  ; | XX     |     | xx     | M0
    .byte   LEFT73_9 | DISABLE  ; | XX     |     | xx     | M0
                                ; | XXXXXX |     | 110000 | line 1
;line 1
    .byte   LEFT73_7 ; M0
    .byte  LEFT73_15 ; M1
    .byte   LEFT73_6 | DISABLE ; BL
    ENDIF
    IF {1} = "B"
    .byte   LEFT73_8 | DISABLE  ; | XXXXX  |     | 10000  | M0
    .byte   LEFT73_5 | ENABLE   ; |     XX |     |BB   00 | M0
    .byte   LEFT73_5 | ENABLE   ; |     XX |     |BB   00 | M0
    .byte   LEFT73_5 | ENABLE   ; |     XX |     |BB   00 | M0
    .byte   LEFT73_8 | DISABLE  ; | XXXXX  |     | 10000  | M0
    .byte   LEFT73_9 | DISABLE  ; | X      |     | x      | M0
    .byte   LEFT73_9 | DISABLE  ; | X      |     | x      | M0
                                ; | XXXXX  |     | 10000  | line 1
;line 1
    .byte   LEFT73_8 ; M0
    .byte  LEFT73_15 ; M1
    .byte   LEFT73_7 | DISABLE ; BL
    ENDIF
    IF {1} = "C"
    .byte   LEFT73_9 | ENABLE   ; | XXXXX  |     | 00000BB| M0
    .byte   LEFT73_5 | DISABLE  ; |     XX |     |     00 | M0
    .byte   LEFT73_5 | DISABLE  ; |     XX |     |     00 | M0
    .byte   LEFT73_5 | DISABLE  ; |     XX |     |     00 | M0
    .byte   LEFT73_8 | ENABLE   ; |  XXXX  |     |  0000BB| M0
    .byte   LEFT73_9 | DISABLE  ; | X      |     | 0      | M0
    .byte   LEFT73_9 | DISABLE  ; | X      |     | 0      | M0
                                ; | XXXXX  |     | 00000BB| line 1
;line 1
    .byte   LEFT73_9 ; M0
    .byte   NO_MO_73 ; M1
    .byte   LEFT73_1 | ENABLE ; BL
    ENDIF
    IF {1} = "D"
    .byte   LEFT73_9 | ENABLE   ; | XXXXX  |     | 00000BB| M0
    .byte   LEFT73_4 | DISABLE  ; |      X |     |      0 | M0
    .byte   LEFT73_4 | DISABLE  ; |      X |     |      0 | M0
    .byte   LEFT73_4 | DISABLE  ; |      X |     |      0 | M0
    .byte   LEFT73_9 | ENABLE   ; | XXXXX  |     | 00000BB| M0
    .byte   LEFT73_9 | DISABLE  ; | X      |     | 0      | M0
    .byte   LEFT73_9 | DISABLE  ; | X      |     | 0      | M0
                                ; | XXXXX  |     | 00000BB| line 1
;line 1
    .byte   LEFT73_9 ; M0
    .byte   NO_MO_73 ; M1
    .byte   LEFT73_1 | ENABLE ; BL
    ENDIF

  ENDM

;---------------------------------------

  MAC FIVE_SIZE

    IF {1} = "A"
    .byte  MISSLE_4 ; | XXXXX  |     | 1x000  | M0
    .byte  MISSLE_2 ; |     XX |     | BB  00 | M1
    .byte  MISSLE_2 ; |     XX |     | BB  00 | M0
    .byte  MISSLE_2 ; |     XX |     | BB  00 | M0
    .byte  MISSLE_4 ; | XXXXX  |     | 1x000  | M0
    .byte    BALL_2 ; | XX     |     | xx     | BL
    .byte  MISSLE_2 ; | XX     |     | xx     | M0
                    ; | XXXXXX |     | 110000 | line 1
;line 1
    .byte  MISSLE_4 ; M0
    .byte  MISSLE_2 ; M1
    .byte    BALL_2 ; BL
    ENDIF
    IF {1} = "B"
    .byte  MISSLE_4 ; | XXXXX  |     | 10000  | M0
    .byte  MISSLE_1 ; |     XX |     |BB   00 | M1
    .byte  MISSLE_2 ; |     XX |     |BB   00 | M0
    .byte  MISSLE_2 ; |     XX |     |BB   00 | M0
    .byte  MISSLE_4 ; | XXXXX  |     | 10000  | M0
    .byte    BALL_2 ; | X      |     | x      | BL
    .byte  MISSLE_1 ; | X      |     | x      | M0
                    ; | XXXXX  |     | 10000  | line 1
;line 1
    .byte  MISSLE_4 ; M0
    .byte  MISSLE_1 ; M1
    .byte    BALL_2 ; BL
    ENDIF
    IF {1} = "C"
    .byte  MISSLE_8 ; | XXXXX  |     | 00000BB| M0
    .byte  MISSLE_1 ; |     XX |     |     00 | M1
    .byte  MISSLE_2 ; |     XX |     |     00 | M0
    .byte  MISSLE_2 ; |     XX |     |     00 | M0
    .byte  MISSLE_4 ; |  XXXX  |     |  0000BB| M0
    .byte    BALL_2 ; | X      |     | 0      | BL
    .byte  MISSLE_1 ; | X      |     | 0      | M0
                    ; | XXXXX  |     | 00000BB| line 1
;line 1
    .byte  MISSLE_8 ; M0
    .byte  MISSLE_1 ; M1
    .byte    BALL_2 ; BL
    ENDIF
    IF {1} = "D"
    .byte  MISSLE_8 ; | XXXXX  |     | 00000BB| M0
    .byte  MISSLE_1 ; |      X |     |      0 | M1
    .byte  MISSLE_1 ; |      X |     |      0 | M0
    .byte  MISSLE_1 ; |      X |     |      0 | M0
    .byte  MISSLE_8 ; | XXXXX  |     | 00000BB| M0
    .byte    BALL_2 ; | X      |     | 0      | BL
    .byte  MISSLE_1 ; | X      |     | 0      | M0
                    ; | XXXXX  |     | 00000BB| line 1
;line 1
    .byte  MISSLE_8 ; M0
    .byte  MISSLE_1 ; M1
    .byte    BALL_2 ; BL
    ENDIF

  ENDM

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;      SIX DIGITS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  MAC SIX_GFX

    IF {1} = "A"
    .byte $3C ; |  XXXX  |
    .byte $66 ; | XX  XX |
    .byte $66 ; | XX  XX |
    .byte $66 ; | XX  XX |
    .byte $7C ; | XXXXX  |
    .byte $60 ; | XX     |
    .byte $62 ; | XX   X |
    .byte $3C ; |  XXXX  |
    ENDIF
    IF {1} = "B"
    .byte $3C ; |  XXXX  |
    .byte $42 ; | X    X |
    .byte $42 ; | X    X |
    .byte $42 ; | X    X |
    .byte $7C ; | XXXXX  |
    .byte $40 ; | X      |
    .byte $40 ; | X      |
    .byte $3C ; |  XXXX  |
    ENDIF
    IF {1} = "C"
    .byte $3C ; |  XXXX  |
    .byte $42 ; | X    X |
    .byte $42 ; | X    X |
    .byte $7C ; | XXXXX  |
    .byte $40 ; | X      |
    .byte $40 ; | X      |
    .byte $40 ; | X      |
    .byte $3C ; |  XXXX  |
    ENDIF

  ENDM

;---------------------------------------

  MAC SIX_MOVE

    IF {1} = "A"
    .byte   LEFT73_8 | ENABLE   ; |  XXXX  |     | Bx000  | M0
    .byte   LEFT73_5 | DISABLE  ; | XX  XX |     | 11  00 | M0
    .byte   LEFT73_5 | DISABLE  ; | XX  XX |     | 11  00 | M0
    .byte   LEFT73_5 | DISABLE  ; | XX  XX |     | 11  00 | M0
    .byte   LEFT73_8 | DISABLE  ; | XXXXX  |     | 1x000  | M0
    .byte   LEFT73_8 | DISABLE  ; | XX     |     | 1x     | M0
    .byte   LEFT73_4 | DISABLE  ; | XX   X |     | 11   0 | M0
                                ; |  XXXX  |     | Bx000  | line 1
;line 1
    .byte   LEFT73_8 ; M0
    .byte  LEFT73_15 ; M1
    .byte   LEFT73_6 | ENABLE ; BL
    ENDIF
    IF {1} = "B"
    .byte   LEFT73_8 | ENABLE   ; |  XXXX  |     | B0000  | M0
    .byte   LEFT73_4 | DISABLE  ; | X    X |     | 1    0 | M0
    .byte   LEFT73_4 | DISABLE  ; | X    X |     | 1    0 | M0
    .byte   LEFT73_4 | DISABLE  ; | X    X |     | 1    0 | M0
    .byte   LEFT73_8 | DISABLE  ; | XXXXX  |     | 10000  | M0
    .byte   LEFT73_9 | DISABLE  ; | X      |     | x      | M0
    .byte   LEFT73_9 | DISABLE  ; | X      |     | x      | M0
                                ; |  XXXX  |     | B0000  | line 1
;line 1
    .byte   LEFT73_8 ; M0
    .byte  LEFT73_15 ; M1
    .byte   LEFT73_6 | ENABLE ; BL
    ENDIF
    IF {1} = "C"
    .byte   LEFT73_8 | ENABLE   ; |  XXXX  |     | B0000  | M0
    .byte   LEFT73_4 | DISABLE  ; | X    X |     | 1    0 | M0
    .byte   LEFT73_4 | DISABLE  ; | X    X |     | 1    0 | M0
    .byte   LEFT73_8 | DISABLE  ; | XXXXX  |     | 10000  | M0
    .byte   LEFT73_9 | DISABLE  ; | X      |     | x      | M0
    .byte   LEFT73_9 | DISABLE  ; | X      |     | x      | M0
    .byte   LEFT73_9 | DISABLE  ; | X      |     | x      | M0
                                ; |  XXXX  |     | B0000  | line 1
;line 1
    .byte   LEFT73_8 ; M0
    .byte  LEFT73_15 ; M1
    .byte   LEFT73_6 | ENABLE ; BL
    ENDIF

  ENDM

;---------------------------------------

  MAC SIX_SIZE

    IF {1} = "A"
    .byte  MISSLE_4 ; |  XXXX  |     | Bx000  | M0
    .byte  MISSLE_2 ; | XX  XX |     | 11  00 | M1
    .byte  MISSLE_2 ; | XX  XX |     | 11  00 | M0
    .byte  MISSLE_2 ; | XX  XX |     | 11  00 | M0
    .byte  MISSLE_4 ; | XXXXX  |     | 1x000  | M0
    .byte    BALL_1 ; | XX     |     | 1x     | BL
    .byte  MISSLE_1 ; | XX   X |     | 11   0 | M0
                    ; |  XXXX  |     | Bx000  | line 1
;line 1
    .byte  MISSLE_4 ; M0
    .byte  MISSLE_2 ; M1
    .byte    BALL_1 ; BL
    ENDIF
    IF {1} = "B"
    .byte  MISSLE_4 ; |  XXXX  |     | B0000  | M0
    .byte  MISSLE_1 ; | X    X |     | 1    0 | M1
    .byte  MISSLE_1 ; | X    X |     | 1    0 | M0
    .byte  MISSLE_1 ; | X    X |     | 1    0 | M0
    .byte  MISSLE_4 ; | XXXXX  |     | 10000  | M0
    .byte    BALL_1 ; | X      |     | x      | BL
    .byte  MISSLE_1 ; | X      |     | x      | M0
                    ; |  XXXX  |     | B0000  | line 1
;line 1
    .byte  MISSLE_4 ; M0
    .byte  MISSLE_1 ; M1
    .byte    BALL_1 ; BL
    ENDIF
    IF {1} = "C"
    .byte  MISSLE_4 ; |  XXXX  |     | B0000  | M0
    .byte  MISSLE_1 ; | X    X |     | 1    0 | M1
    .byte  MISSLE_1 ; | X    X |     | 1    0 | M0
    .byte  MISSLE_4 ; | XXXXX  |     | 10000  | M0
    .byte  MISSLE_1 ; | X      |     | x      | M0
    .byte    BALL_1 ; | X      |     | x      | BL
    .byte  MISSLE_1 ; | X      |     | x      | M0
                    ; |  XXXX  |     | B0000  | line 1
;line 1
    .byte  MISSLE_4 ; M0
    .byte  MISSLE_1 ; M1
    .byte    BALL_1 ; BL
    ENDIF

  ENDM

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;      SEVEN DIGITS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  MAC SEVEN_GFX

    IF {1} = "A"
    .byte $18 ; |   XX   |
    .byte $18 ; |   XX   |
    .byte $18 ; |   XX   |
    .byte $18 ; |   XX   |
    .byte $0C ; |    XX  |
    .byte $06 ; |     XX |
    .byte $06 ; |     XX |
    .byte $7E ; | XXXXXX |
    ENDIF
    IF {1} = "B"
    .byte $18 ; |   XX   |
    .byte $18 ; |   XX   |
    .byte $18 ; |   XX   |
    .byte $18 ; |   XX   |
    .byte $0C ; |    XX  |
    .byte $06 ; |     XX |
    .byte $46 ; | X   XX |
    .byte $7E ; | XXXXXX |
    ENDIF

  ENDM

;---------------------------------------

  MAC SEVEN_MOVE

    IF {1} = "A"
    .byte   LEFT73_7 | DISABLE  ; |   XX   |     |   00   | M0
    .byte   LEFT73_7 | DISABLE  ; |   XX   |     |   00   | M0
    .byte   LEFT73_7 | DISABLE  ; |   XX   |     |   00   | M0
    .byte   LEFT73_7 | DISABLE  ; |   XX   |     |   00   | M0
    .byte   LEFT73_6 | DISABLE  ; |    XX  |     |    00  | M0
    .byte   LEFT73_5 | DISABLE  ; |     XX |     |     00 | M0
    .byte   LEFT73_5 | DISABLE  ; |     XX |     |     00 | M0
                                ; | XXXXXX |    B|B000000 | line 1
;line 1
    .byte  LEFT73_11 ; M0
    .byte   NO_MO_73 ; M1
    .byte   LEFT73_8 | ENABLE ; BL
    ENDIF
    IF {1} = "B"
    .byte   LEFT73_7 | ENABLE   ; |   XX   |    B|BBB00   | M0
    .byte   LEFT73_7 | ENABLE   ; |   XX   |    B|BBB00   | M0
    .byte   LEFT73_7 | ENABLE   ; |   XX   |    B|BBB00   | M0
    .byte   LEFT73_7 | ENABLE   ; |   XX   |    B|BBB00   | M0
    .byte   LEFT73_6 | ENABLE   ; |    XX  |    B|BBB 00  | M0
    .byte   LEFT73_5 | ENABLE   ; |     XX |    B|BBB  00 | M0
    .byte   LEFT73_5 | ENABLE   ; | X   XX |    B|B1   00 | M0
                                ; | XXXXXX |    B|Bx00000 | line 1
;line 1
    .byte  LEFT73_11 ; M0
    .byte  LEFT73_15 ; M1
    .byte   LEFT73_8 | ENABLE ; BL
    ENDIF

  ENDM

;---------------------------------------

  MAC SEVEN_SIZE

    IF {1} = "A"
    .byte  MISSLE_2 ; |   XX   |     |   00   | M0
    .byte  MISSLE_1 ; |   XX   |     |   00   | M1
    .byte  MISSLE_2 ; |   XX   |     |   00   | M0
    .byte  MISSLE_2 ; |   XX   |     |   00   | M0
    .byte  MISSLE_2 ; |    XX  |     |    00  | M0
    .byte    BALL_2 ; |     XX |     |     00 | BL
    .byte  MISSLE_2 ; |     XX |     |     00 | M0
                    ; | XXXXXX |    B|B000000 | line 1
;line 1
    .byte  MISSLE_8 ; M0
    .byte  MISSLE_1 ; M1
    .byte    BALL_2 ; BL
    ENDIF
    IF {1} = "B"
    .byte  MISSLE_2 ; |   XX   |    B|BBB00   | M0
    .byte  MISSLE_1 ; |   XX   |    B|BBB00   | M1
    .byte  MISSLE_2 ; |   XX   |    B|BBB00   | M0
    .byte  MISSLE_2 ; |   XX   |    B|BBB00   | M0
    .byte  MISSLE_2 ; |    XX  |    B|BBB 00  | M0
    .byte    BALL_4 ; |     XX |    B|BBB  00 | BL
    .byte  MISSLE_2 ; | X   XX |    B|B1   00 | M0
                    ; | XXXXXX |    B|Bx00000 | line 1
;line 1
    .byte  MISSLE_8 ; M0
    .byte  MISSLE_1 ; M1
    .byte    BALL_2 ; BL
    ENDIF

  ENDM

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;      EIGHT DIGITS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  MAC EIGHT_GFX

    IF {1} = "A"
    .byte $3C ; |  XXXX  |
    .byte $66 ; | XX  XX |
    .byte $66 ; | XX  XX |
    .byte $3C ; |  XXXX  |
    .byte $3C ; |  XXXX  |
    .byte $66 ; | XX  XX |
    .byte $66 ; | XX  XX |
    .byte $3C ; |  XXXX  |
    ENDIF
    IF {1} = "B"
    .byte $3C ; |  XXXX  |
    .byte $66 ; | XX  XX |
    .byte $66 ; | XX  XX |
    .byte $66 ; | XX  XX |
    .byte $3C ; |  XXXX  |
    .byte $66 ; | XX  XX |
    .byte $66 ; | XX  XX |
    .byte $3C ; |  XXXX  |
    ENDIF
    IF {1} = "C"
    .byte $7E ; | XXXXXX |
    .byte $66 ; | XX  XX |
    .byte $66 ; | XX  XX |
    .byte $66 ; | XX  XX |
    .byte $7E ; | XXXXXX |
    .byte $24 ; |  X  X  |
    .byte $24 ; |  X  X  |
    .byte $3C ; |  XXXX  |
    ENDIF
    IF {1} = "D"
    .byte $3C ; |  XXXX  |
    .byte $42 ; | X    X |
    .byte $42 ; | X    X |
    .byte $42 ; | X    X |
    .byte $3C ; |  XXXX  |
    .byte $42 ; | X    X |
    .byte $42 ; | X    X |
    .byte $3C ; |  XXXX  |
    ENDIF
    IF {1} = "E"
    .byte $3C ; |  XXXX  |
    .byte $42 ; | X    X |
    .byte $42 ; | X    X |
    .byte $3C ; |  XXXX  |
    .byte $3C ; |  XXXX  |
    .byte $42 ; | X    X |
    .byte $42 ; | X    X |
    .byte $3C ; |  XXXX  |
    ENDIF

  ENDM

;---------------------------------------

  MAC EIGHT_MOVE

    IF {1} = "A"
    .byte   LEFT73_8 | ENABLE   ; |  XXXX  |     | Bx000  | M0
    .byte   LEFT73_5 | DISABLE  ; | XX  XX |     | 11  00 | M0
    .byte   LEFT73_5 | DISABLE  ; | XX  XX |     | 11  00 | M0
    .byte   LEFT73_8 | ENABLE   ; |  XXXX  |     | Bx000  | M0
    .byte   LEFT73_8 | ENABLE   ; |  XXXX  |     | Bx000  | M0
    .byte   LEFT73_5 | DISABLE  ; | XX  XX |     | 11  00 | M0
    .byte   LEFT73_5 | DISABLE  ; | XX  XX |     | 11  00 | M0
                                ; |  XXXX  |     | Bx000  | line 1
;line 1
    .byte   LEFT73_8 ; M0
    .byte  LEFT73_15 ; M1
    .byte   LEFT73_6 | ENABLE ; BL
    ENDIF
    IF {1} = "B"
    .byte   LEFT73_8 | ENABLE   ; |  XXXX  |     | Bx000  | M0
    .byte   LEFT73_5 | DISABLE  ; | XX  XX |     | 11  00 | M0
    .byte   LEFT73_5 | DISABLE  ; | XX  XX |     | 11  00 | M0
    .byte   LEFT73_5 | DISABLE  ; | XX  XX |     | 11  00 | M0
    .byte   LEFT73_8 | ENABLE   ; |  XXXX  |     | Bx000  | M0
    .byte   LEFT73_5 | DISABLE  ; | XX  XX |     | 11  00 | M0
    .byte   LEFT73_5 | DISABLE  ; | XX  XX |     | 11  00 | M0
                                ; |  XXXX  |     | Bx000  | line 1
;line 1
    .byte   LEFT73_8 ; M0
    .byte  LEFT73_15 ; M1
    .byte   LEFT73_6 | ENABLE ; BL
    ENDIF
    IF {1} = "C"
    .byte   LEFT73_9 | DISABLE  ; | XXXXXX |     | 000011 | M0
    .byte   LEFT73_9 | DISABLE  ; | XX  XX |     | 00  11 | M0
    .byte   LEFT73_9 | DISABLE  ; | XX  XX |     | 00  11 | M0
    .byte   LEFT73_9 | DISABLE  ; | XX  XX |     | 00  11 | M0
    .byte   LEFT73_9 | DISABLE  ; | XXXXXX |     | 000011 | M0
    .byte   LEFT73_8 | ENABLE   ; |  X  X  |     |  0  1B | M0
    .byte   LEFT73_8 | ENABLE   ; |  X  X  |     |  0  1B | M0
                                ; |  XXXX  |     |  000xB | line 1
;line 1
    .byte   LEFT73_8 ; M0
    .byte  LEFT73_11 ; M1
    .byte   LEFT73_1 | ENABLE ; BL
    ENDIF
    IF {1} = "D"
    .byte   LEFT73_8 | ENABLE   ; |  XXXX  |     |  0000B | M0
    .byte   LEFT73_9 | DISABLE  ; | X    X |     | 0    1 | M0
    .byte   LEFT73_9 | DISABLE  ; | X    X |     | 0    1 | M0
    .byte   LEFT73_9 | DISABLE  ; | X    X |     | 0    1 | M0
    .byte   LEFT73_8 | ENABLE   ; |  XXXX  |     |  0000B | M0
    .byte   LEFT73_9 | DISABLE  ; | X    X |     | 0    1 | M0
    .byte   LEFT73_9 | DISABLE  ; | X    X |     | 0    1 | M0
                                ; |  XXXX  |     |  0000B | line 1
;line 1
    .byte   LEFT73_8 ; M0
    .byte  LEFT73_10 ; M1
    .byte   LEFT73_1 | ENABLE ; BL
    ENDIF
    IF {1} = "E"
    .byte   LEFT73_8 | ENABLE   ; |  XXXX  |     |  0000B | M0
    .byte   LEFT73_9 | DISABLE  ; | X    X |     | 0    1 | M0
    .byte   LEFT73_9 | DISABLE  ; | X    X |     | 0    1 | M0
    .byte   LEFT73_8 | ENABLE   ; |  XXXX  |     |  0000B | M0
    .byte   LEFT73_8 | ENABLE   ; |  XXXX  |     |  0000B | M0
    .byte   LEFT73_9 | DISABLE  ; | X    X |     | 0    1 | M0
    .byte   LEFT73_9 | DISABLE  ; | X    X |     | 0    1 | M0
                                ; |  XXXX  |     |  0000B | line 1
;line 1
    .byte   LEFT73_8 ; M0
    .byte  LEFT73_10 ; M1
    .byte   LEFT73_1 | ENABLE ; BL
    ENDIF

  ENDM

;---------------------------------------

  MAC EIGHT_SIZE

    IF {1} = "A"
    .byte  MISSLE_4 ; |  XXXX  |     | Bx000  | M0
    .byte  MISSLE_2 ; | XX  XX |     | 11  00 | M1
    .byte  MISSLE_2 ; | XX  XX |     | 11  00 | M0
    .byte  MISSLE_4 ; |  XXXX  |     | Bx000  | M0
    .byte  MISSLE_4 ; |  XXXX  |     | Bx000  | M0
    .byte    BALL_1 ; | XX  XX |     | 11  00 | BL
    .byte  MISSLE_2 ; | XX  XX |     | 11  00 | M0
                    ; |  XXXX  |     | Bx000  | line 1
;line 1
    .byte  MISSLE_4 ; M0
    .byte  MISSLE_2 ; M1
    .byte    BALL_1 ; BL
    ENDIF
    IF {1} = "B"
    .byte  MISSLE_4 ; |  XXXX  |     | Bx000  | M0
    .byte  MISSLE_2 ; | XX  XX |     | 11  00 | M1
    .byte  MISSLE_2 ; | XX  XX |     | 11  00 | M0
    .byte  MISSLE_2 ; | XX  XX |     | 11  00 | M0
    .byte  MISSLE_4 ; |  XXXX  |     | Bx000  | M0
    .byte    BALL_1 ; | XX  XX |     | 11  00 | BL
    .byte  MISSLE_2 ; | XX  XX |     | 11  00 | M0
                    ; |  XXXX  |     | Bx000  | line 1
;line 1
    .byte  MISSLE_4 ; M0
    .byte  MISSLE_2 ; M1
    .byte    BALL_1 ; BL
    ENDIF
    IF {1} = "C"
    .byte  MISSLE_4 ; | XXXXXX |     | 000011 | M0
    .byte  MISSLE_2 ; | XX  XX |     | 00  11 | M1
    .byte  MISSLE_2 ; | XX  XX |     | 00  11 | M0
    .byte  MISSLE_2 ; | XX  XX |     | 00  11 | M0
    .byte  MISSLE_4 ; | XXXXXX |     | 000011 | M0
    .byte    BALL_1 ; |  X  X  |     |  0  1B | BL
    .byte  MISSLE_1 ; |  X  X  |     |  0  1B | M0
                    ; |  XXXX  |     |  000xB | line 1
;line 1
    .byte  MISSLE_4 ; M0
    .byte  MISSLE_2 ; M1
    .byte    BALL_1 ; BL
    ENDIF
    IF {1} = "D"
    .byte  MISSLE_4 ; |  XXXX  |     |  0000B | M0
    .byte  MISSLE_1 ; | X    X |     | 0    1 | M1
    .byte  MISSLE_1 ; | X    X |     | 0    1 | M0
    .byte  MISSLE_1 ; | X    X |     | 0    1 | M0
    .byte  MISSLE_4 ; |  XXXX  |     |  0000B | M0
    .byte    BALL_1 ; | X    X |     | 0    1 | BL
    .byte  MISSLE_1 ; | X    X |     | 0    1 | M0
                    ; |  XXXX  |     |  0000B | line 1
;line 1
    .byte  MISSLE_4 ; M0
    .byte  MISSLE_1 ; M1
    .byte    BALL_1 ; BL
    ENDIF
    IF {1} = "E"
    .byte  MISSLE_4 ; |  XXXX  |     |  0000B | M0
    .byte  MISSLE_1 ; | X    X |     | 0    1 | M1
    .byte  MISSLE_1 ; | X    X |     | 0    1 | M0
    .byte  MISSLE_4 ; |  XXXX  |     |  0000B | M0
    .byte  MISSLE_4 ; |  XXXX  |     |  0000B | M0
    .byte    BALL_1 ; | X    X |     | 0    1 | BL
    .byte  MISSLE_1 ; | X    X |     | 0    1 | M0
                    ; |  XXXX  |     |  0000B | line 1
;line 1
    .byte  MISSLE_4 ; M0
    .byte  MISSLE_1 ; M1
    .byte    BALL_1 ; BL
    ENDIF

  ENDM

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;      NINE DIGITS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  MAC NINE_GFX

    IF {1} = "A"
    .byte $3C ; |  XXXX  |
    .byte $46 ; | X   XX |
    .byte $06 ; |     XX |
    .byte $3E ; |  XXXXX |
    .byte $66 ; | XX  XX |
    .byte $66 ; | XX  XX |
    .byte $66 ; | XX  XX |
    .byte $3C ; |  XXXX  |
    ENDIF
    IF {1} = "B"
    .byte $06 ; |     XX |
    .byte $06 ; |     XX |
    .byte $06 ; |     XX |
    .byte $3E ; |  XXXXX |
    .byte $66 ; | XX  XX |
    .byte $66 ; | XX  XX |
    .byte $66 ; | XX  XX |
    .byte $3C ; |  XXXX  |
    ENDIF
    IF {1} = "C"
    .byte $3C ; |  XXXX  |
    .byte $06 ; |     XX |
    .byte $06 ; |     XX |
    .byte $3C ; |  XXXX  |
    .byte $66 ; | XX  XX |
    .byte $66 ; | XX  XX |
    .byte $66 ; | XX  XX |
    .byte $3C ; |  XXXX  |
    ENDIF
    IF {1} = "D"
    .byte $3C ; |  XXXX  |
    .byte $06 ; |     XX |
    .byte $06 ; |     XX |
    .byte $06 ; |     XX |
    .byte $3E ; |  XXXXX |
    .byte $66 ; | XX  XX |
    .byte $66 ; | XX  XX |
    .byte $3C ; |  XXXX  |
    ENDIF

  ENDM

;---------------------------------------

  MAC NINE_MOVE

    IF {1} = "A"
    .byte   LEFT73_8 | ENABLE   ; |  XXXX  |     |  000xB | M0
    .byte   LEFT73_9 | DISABLE  ; | X   XX |     | 0   11 | M0
    .byte   LEFT73_5 | DISABLE  ; |     XX |     |     x1 | M0
    .byte   LEFT73_8 | DISABLE  ; |  XXXXX |     |  000x1 | M0
    .byte   LEFT73_9 | DISABLE  ; | XX  XX |     | 00  11 | M0
    .byte   LEFT73_9 | DISABLE  ; | XX  XX |     | 00  11 | M0
    .byte   LEFT73_9 | DISABLE  ; | XX  XX |     | 00  11 | M0
                                ; |  XXXX  |     |  000xB | line 1
;line 1
    .byte   LEFT73_8 ; M0
    .byte  LEFT73_11 ; M1
    .byte   LEFT73_1 | ENABLE ; BL
    ENDIF
    IF {1} = "B"
    .byte   LEFT73_5 | DISABLE  ; |     XX |     |     x1 | M0
    .byte   LEFT73_5 | DISABLE  ; |     XX |     |     x1 | M0
    .byte   LEFT73_5 | DISABLE  ; |     XX |     |     x1 | M0
    .byte   LEFT73_8 | DISABLE  ; |  XXXXX |     |  000x1 | M0
    .byte   LEFT73_9 | DISABLE  ; | XX  XX |     | 00  11 | M0
    .byte   LEFT73_9 | DISABLE  ; | XX  XX |     | 00  11 | M0
    .byte   LEFT73_9 | DISABLE  ; | XX  XX |     | 00  11 | M0
                                ; |  XXXX  |     |  000xB | line 1
;line 1
    .byte   LEFT73_8 ; M0
    .byte  LEFT73_11 ; M1
    .byte   LEFT73_1 | ENABLE ; BL
    ENDIF
    IF {1} = "C"
    .byte   LEFT73_8 | ENABLE   ; |  XXXX  |     |  000xBB| M0
    .byte   LEFT73_5 | DISABLE  ; |     XX |     |     x1 | M0
    .byte   LEFT73_5 | DISABLE  ; |     XX |     |     x1 | M0
    .byte   LEFT73_8 | ENABLE   ; |  XXXX  |     |  000xBB| M0
    .byte   LEFT73_9 | DISABLE  ; | XX  XX |     | 00  11 | M0
    .byte   LEFT73_9 | DISABLE  ; | XX  XX |     | 00  11 | M0
    .byte   LEFT73_9 | DISABLE  ; | XX  XX |     | 00  11 | M0
                                ; |  XXXX  |     |  000xBB| line 1
;line 1
    .byte   LEFT73_8 ; M0
    .byte  LEFT73_11 ; M1
    .byte   LEFT73_1 | ENABLE ; BL
    ENDIF
    IF {1} = "D"
    .byte   LEFT73_8 | ENABLE   ; |  XXXX  |     |  000xB | M0
    .byte   LEFT73_5 | DISABLE  ; |     XX |     |     xx | M0
    .byte   LEFT73_5 | DISABLE  ; |     XX |     |     xx | M0
    .byte   LEFT73_5 | DISABLE  ; |     XX |     |     xx | M0
    .byte   LEFT73_8 | DISABLE  ; |  XXXXX |     |  000x1 | M0
    .byte   LEFT73_9 | DISABLE  ; | XX  XX |     | 00  11 | M0
    .byte   LEFT73_9 | DISABLE  ; | XX  XX |     | 00  11 | M0
                                ; |  XXXX  |     |  000xB | line 1
;line 1
    .byte   LEFT73_8 ; M0
    .byte  LEFT73_11 ; M1
    .byte   LEFT73_1 | ENABLE ; BL
    ENDIF


  ENDM

;---------------------------------------

  MAC NINE_SIZE

    IF {1} = "A"
    .byte  MISSLE_4 ; |  XXXX  |     |  000xB | M0
    .byte  MISSLE_2 ; | X   XX |     | 0   11 | M1
    .byte  MISSLE_1 ; |     XX |     |     x1 | M0
    .byte  MISSLE_4 ; |  XXXXX |     |  000x1 | M0
    .byte  MISSLE_2 ; | XX  XX |     | 00  11 | M0
    .byte    BALL_1 ; | XX  XX |     | 00  11 | BL
    .byte  MISSLE_2 ; | XX  XX |     | 00  11 | M0
                    ; |  XXXX  |     |  000xB | line 1
;line 1
    .byte  MISSLE_4 ; M0
    .byte  MISSLE_2 ; M1
    .byte    BALL_1 ; BL
    ENDIF
    IF {1} = "B"
    .byte  MISSLE_1 ; |     XX |     |     x1 | M0
    .byte  MISSLE_2 ; |     XX |     |     x1 | M1
    .byte  MISSLE_1 ; |     XX |     |     x1 | M0
    .byte  MISSLE_4 ; |  XXXXX |     |  000x1 | M0
    .byte  MISSLE_2 ; | XX  XX |     | 00  11 | M0
    .byte    BALL_1 ; | XX  XX |     | 00  11 | BL
    .byte  MISSLE_2 ; | XX  XX |     | 00  11 | M0
                    ; |  XXXX  |     |  000xB | line 1
;line 1
    .byte  MISSLE_4 ; M0
    .byte  MISSLE_2 ; M1
    .byte    BALL_1 ; BL
    ENDIF
    IF {1} = "C"
    .byte  MISSLE_4 ; |  XXXX  |     |  000xBB| M0
    .byte  MISSLE_2 ; |     XX |     |     x1 | M1
    .byte  MISSLE_1 ; |     XX |     |     x1 | M0
    .byte  MISSLE_4 ; |  XXXX  |     |  000xBB| M0
    .byte  MISSLE_2 ; | XX  XX |     | 00  11 | M0
    .byte    BALL_2 ; | XX  XX |     | 00  11 | BL
    .byte  MISSLE_2 ; | XX  XX |     | 00  11 | M0
                    ; |  XXXX  |     |  000xBB| line 1
;line 1
    .byte  MISSLE_4 ; M0
    .byte  MISSLE_2 ; M1
    .byte    BALL_2 ; BL
    ENDIF
    IF {1} = "D"
    .byte  MISSLE_4 ; |  XXXX  |     |  000xB | M0
    .byte  MISSLE_2 ; |     XX |     |     xx | M1
    .byte  MISSLE_2 ; |     XX |     |     xx | M0
    .byte  MISSLE_2 ; |     XX |     |     xx | M0
    .byte  MISSLE_4 ; |  XXXXX |     |  000x1 | M0
    .byte    BALL_1 ; | XX  XX |     | 00  11 | BL
    .byte  MISSLE_2 ; | XX  XX |     | 00  11 | M0
                    ; |  XXXX  |     |  000xB | line 1
;line 1
    .byte  MISSLE_4 ; M0
    .byte  MISSLE_2 ; M1
    .byte    BALL_1 ; BL
    ENDIF

  ENDM

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;      BLANK DIGIT
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  MAC BLANK_GFX

    .byte $00 ; |        |
    .byte $00 ; |        |
    .byte $00 ; |        |
    .byte $00 ; |        |
    .byte $00 ; |        |
    .byte $00 ; |        |
    .byte $00 ; |        |
    .byte $00 ; |        |

  ENDM

;---------------------------------------

  MAC BLANK_MOVE

    .byte   NO_MO_73 | DISABLE  ; |        |     |        | M0
    .byte   NO_MO_73 | DISABLE  ; |        |     |        | M0
    .byte   NO_MO_73 | DISABLE  ; |        |     |        | M0
    .byte   NO_MO_73 | DISABLE  ; |        |     |        | M0
    .byte   NO_MO_73 | DISABLE  ; |        |     |        | M0
    .byte   NO_MO_73 | DISABLE  ; |        |     |        | M0
    .byte   NO_MO_73 | DISABLE  ; |        |     |        | M0
                                ; |        |     |        | line 1
;line 1
    .byte   NO_MO_73 ; M0
    .byte   NO_MO_73 ; M1
    .byte   NO_MO_73 | DISABLE ; BL

  ENDM

;---------------------------------------

  MAC BLANK_SIZE

    .byte  MISSLE_1 ; |        |     |        | M0
    .byte  MISSLE_1 ; |        |     |        | M1
    .byte  MISSLE_1 ; |        |     |        | M0
    .byte  MISSLE_1 ; |        |     |        | M0
    .byte  MISSLE_1 ; |        |     |        | M0
    .byte    BALL_1 ; |        |     |        | BL
    .byte  MISSLE_1 ; |        |     |        | M0
                    ; |        |     |        | line 1
;line 1
    .byte  MISSLE_1 ; M0
    .byte  MISSLE_1 ; M1
    .byte    BALL_1 ; BL

  ENDM