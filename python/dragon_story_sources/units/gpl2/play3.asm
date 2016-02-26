;indexes to the program code are 16-bit integers --> subtract 1 and multiply by 2
;relative jumps in the code are in bytes (in GPL) --> just add
;integer variables are 16-bit integers --> subtract 1 and multiply by 2
;
;cannot use dataptr (2 bytes), but have to use word:2 (4 bytes)
;use macro ret in procedures with parameters instead of direct instructions retf and retn
;
;don't forget to dec si, when run from play05.pas!
;when evaluating mathematical expression, use 1 instead of 0

.286c

model small,pascal

public evaluate_mathematical_expression                         ;2 exportet FAR routines
public PlayGPL3

extrn relative_gpl_jump
extrn gpl_end_program

extrn F_Random                                  ;imported NEAR functions
extrn F_IsIcoOn
extrn F_IsIcoAct
extrn F_IcoStat
extrn F_ActIco
extrn F_IsObjOn
extrn F_IsObjOff
extrn F_IsObjAway
extrn F_ObjStat
extrn F_LastBlock
extrn F_AtBegin
extrn F_BlockVar
extrn F_HasBeen
extrn F_MaxLine
extrn F_ActPhase
extrn F_Cheat

extrn C_Load                                    ;imported NEAR procedures
extrn C_Start
extrn C_StartPlay
extrn C_JustTalk
extrn C_JustStay
extrn C_StayOn
extrn C_WalkOn
extrn C_WalkOnPlay
extrn C_ObjStat
extrn C_ObjStat_On
extrn C_IcoStat
extrn C_RepaintInventory
extrn C_ExitInventory
extrn C_NewRoom
extrn C_Talk
extrn C_Let
extrn C_ExecInit
extrn C_ExecLook
extrn C_ExecUse
extrn C_goto
extrn C_if
extrn C_Dialogue
extrn C_ExitDialogue
extrn C_ResetDialogue
extrn C_ResetDialogueFrom
extrn C_ResetBlock
extrn C_ExitMap
extrn C_LoadPalette
extrn C_SetPalette
extrn C_BlackPalette
extrn C_FadePalette
extrn C_FadePalettePlay
extrn C_LoadMusic
extrn C_StartMusic
extrn C_StopMusic
extrn C_FadeOutMusic
extrn C_FadeInMusic
extrn C_Mark
extrn C_Release
extrn C_Play
extrn C_LoadMap
extrn C_RoomMap
extrn C_DisableQuickHero
extrn C_EnableQuickHero
extrn C_DisableSpeedText
extrn C_EnableSpeedText
extrn C_QuitGame
extrn C_PopNewRoom
extrn C_PushNewRoom
extrn C_ShowCheat
extrn C_HideCheat
extrn C_ClearCheat
extrn C_FeedPassword

.code

evaluate_mathematical_expression proc far
                 arg expression:word:2,index,variables:word:2
                 local original_ds

                 push es si di bx cx dx         ;zapíšeme si všechno
                 mov ss:word ptr original_ds,ds       ;zapíšeme si ds pro volání fcí

                 mov si,ss:word ptr index       ;start je od 1, hlavička už není
                 dec si                         ;index je zadán v integerech
                 shl si,1
                 add si,ss:word ptr expression       ;přidej offset čtení kódu
                 mov ds,ss:word ptr expression+2
                 mov di,ss:word ptr variables    ;vezmeme adresu výrazu
                 mov es,ss:word ptr variables+2
                 xor bx,bx                      ;délka Stacku je 0

next_mathematical_object:
                 lodsw                          ;načteme další objekt mat. výrazu
                 or ax,ax                       ;end_?
                 jz end_of_mathematical_expression
                 cmp ax,1                       ;číslo?
                 je got_a_number
                 cmp ax,2                       ;operátor?
                 je got_an_operator
                 cmp ax,3                       ;funkce?
                 je got_a_function_call
                 cmp ax,4                       ;identifikátor proměnné?
                 je got_a_variable
                 jmp got_a_number
                 ;jinak je to identifikátor objektu, který se bere jako číslo

end_of_mathematical_expression:
                 mov ax,si                      ;kolik jsme přečetli bajtů?
                 sub ax,ss:word ptr expression
                 pop dx cx bx di si es          ;obnovíme všechno
                 mov ds,ss:word ptr original_ds       ;vč. ds
                 add si,ax                      ;posuneme si o přečtený počet
                 mov ax,cs:word ptr postfix_evaluator_stack   ;vrátíme hodnotu
                 ret                            ;end_ rutiny
                 ;0 na konci už se neodstraňuje

evaluate_mathematical_expression endp

got_a_number:                                      ;došlo nám číslo
                 lodsw                          ;vezmeme a PUSHneme hodnotu
                 mov cs:word ptr [postfix_evaluator_stack+bx],ax
                 add bx,2
                 jmp next_mathematical_object

got_a_variable:                                       ;proměnná
                 lodsw                          ;vzít číslo
                 dec ax                         ;převést na index
                 shl ax,1
                 add di,ax
                 mov dx,es:word ptr di          ;načíst hodnotu
                 sub di,ax
                 mov cs:word ptr [postfix_evaluator_stack+bx],dx ;uložit do stacku
                 add bx,2
                 jmp next_mathematical_object

got_a_function_call:                                        ;volání funkce?
                 lodsw                          ;číslo funkce
                 push ds es si di bx cx dx      ;PUSHneme registry
                 dec ax                         ;převedeme na index
                 shl ax,1
                 push cs:word ptr [postfix_evaluator_stack+bx-2] ;uložíme předanou hdonotu

                 mov ds,ss:word ptr original_ds       ;obnovíme ds
                 mov bx,ax                      ;zavoláme funkci
                 call cs:word ptr [function_callbacks+bx]

                 mov ds,ss:word ptr expression+2     ;obnovíme si ds
                 pop dx cx bx di si es ds       ;POPneme registry
                 mov cs:word ptr [postfix_evaluator_stack+bx-2],ax ;uložíme vrácenou hodnotu
                 jmp next_mathematical_object

got_an_operator:                                       ;volání operátoru?
                 lodsw                          ;načti číslo operátoru
                 push si
                 mov si,ax                      ;převedeme číslo na index
                 dec si
                 shl si,1
                 sub bx,2                       ;snížíme počítadlo postfixu
                 mov ax,cs:word ptr [postfix_evaluator_stack+bx-2] ;zapíšeme operandy
                 push bx
                 mov bx,cs:word ptr [postfix_evaluator_stack+bx]
                 call cs:word ptr [operator_callbacks+si] ;zavoláme daný operátor
                 pop bx si
                 mov cs:word ptr [postfix_evaluator_stack+bx-2],ax ;zapíšeme výsledek
                 jmp next_mathematical_object

;stack for the postfix evaluator of mathematical expression, 1 is chosen at random (could be anything)
postfix_evaluator_stack        dw 50 dup(1)

;addresses of function callbacks, pointing at the imported functions
function_callbacks         dw offset F_Not
                 dw offset F_Random
                 dw offset F_IsIcoOn
                 dw offset F_IsIcoAct
                 dw offset F_IcoStat
                 dw offset F_ActIco
                 dw offset F_IsObjOn
                 dw offset F_IsObjOff
                 dw offset F_IsObjAway
                 dw offset F_ObjStat
                 dw offset F_LastBlock
                 dw offset F_AtBegin
                 dw offset F_BlockVar
                 dw offset F_HasBeen
                 dw offset F_MaxLine
                 dw offset F_ActPhase
		 dw offset F_Cheat

;addresses of operator callbacks
operator_callbacks        dw offset oper_and
                 dw offset oper_or
                 dw offset oper_xor
                 dw offset oper_equals
                 dw offset oper_not_equal
                 dw offset oper_less_than
                 dw offset oper_greater_than
                 dw offset oper_less_or_equal
                 dw offset oper_greater_or_equal
                 dw offset oper_multiply
                 dw offset oper_divide
                 dw offset oper_remainder
                 dw offset oper_plus
                 dw offset oper_minus

F_Not proc near                       ;funkce vracející logický not
             arg number_                  ;nelze vyvolat instrukci not
             mov ax,number_
             or ax,ax
             jz not_nulove
             mov ax,1
not_nulove:
             xor ax,1
             ret
F_Not endp

function_logical_operator proc near           ;provede korekci obou cisel na bool
             or ax,ax                   ;0--->0, jine number_--->1
             jz log_nuloveax
             mov ax,1
log_nuloveax:
             or bx,bx                   ;tady bylo navic: xor ax,1 ...
             jz log_nulovebx
             mov bx,1
log_nulovebx:
             ret                        ;tady xor bx,1 ...
function_logical_operator endp

oper_and proc near                      ;udělá logický and
              call function_logical_operator
              and ax,bx
              ret
oper_and endp

oper_or proc near                       ;udělá logický or
              call function_logical_operator
              or ax,bx
              ret
oper_or endp

oper_xor proc near                      ;udělá logický xor
              call function_logical_operator
              xor ax,bx
              ret
oper_xor endp

oper_constant_1:                         ;u komparace nastaví výsledek 1
              mov ax,1
              retn

oper_constant_0:                         ;u komparace nastaví výsledek 0
              xor ax,ax
              retn

oper_equals proc near
           cmp ax,bx
           je oper_constant_1
           jmp oper_constant_0
oper_equals endp

oper_not_equal proc near
           cmp ax,bx
           jne oper_constant_1
           jmp oper_constant_0
oper_not_equal endp

oper_less_than proc near
           cmp ax,bx
           jl oper_constant_1
           jmp oper_constant_0
oper_less_than endp

oper_greater_than proc near
           cmp ax,bx
           jg oper_constant_1
           jmp oper_constant_0
oper_greater_than endp

oper_less_or_equal proc near
           cmp ax,bx
           jle oper_constant_1
           jmp oper_constant_0
oper_less_or_equal endp

oper_greater_or_equal proc near
           cmp ax,bx
           jge oper_constant_1
           jmp oper_constant_0
oper_greater_or_equal endp

oper_multiply proc near
          imul bx                        ;dx se zanedba
          ret
oper_multiply endp

oper_divide proc near
          xor dx,dx
          idiv bx                        ;podíl je v ax
          ret
oper_divide endp

oper_remainder proc near
          xor dx,dx
          idiv bx                        ;zbytek je v dx
          mov ax,dx
          ret
oper_remainder endp

oper_plus proc near
          add ax,bx
          ret
oper_plus endp

oper_minus proc near
          sub ax,bx
          ret
oper_minus endp

;****************************************************************************

PlayGPL3 proc far
         arg code:word:2,start:word,variables:word:2      ;dataptr doesn't work
         local original_ds,original_si

         pusha                          ;uloží se všechno
         push es
         mov ss:word ptr original_ds,ds       ;uložíme si ještě ds

         mov si,ss:word ptr start       ;start je od 1, hlavička už není
         dec si                         ;index je zadán v integerech
         shl si,1
         add si,ss:word ptr code         ;přidej offset čtení kódu
         mov ds,ss:word ptr code+2
;es:di is free, because I don't need R/W of variables here
;ds:si (reading of the program and mathematical expressions)
;command patterns are read using cs:[bx+offset]
;expression evaluator also words using cs:[bx+offset], bx is pushed to the stack
;parameters are pushed on the stack after the register, and we can use the
;stack in the expression evaluator, since we pop it at the end

parse_gpl_command:
         lodsw                          ;načti číslo prováděného příkazu
         or al,al
         jnz ne_konec                   ;0=příkaz na end_
         jmp end_
ne_konec:
         mov dx,ax                      ;zaznamenej číslo příkazu
         xor bx,bx                      ;čteme nyní podporované příkazy
read_gpl_command_declaration:
         mov ax,word ptr cs:[gpl_command_declarations+bx]  ;načti číslo dalšího příkazu
         or ax,ax                       ;0=end_ seznamu
         jnz end_of_gpl_command_declaration
         jmp end_                      ;nenašli jsme ---> on_error!
end_of_gpl_command_declaration:
         mov cx,word ptr cs:[gpl_command_declarations+bx+2];načti počet parametrů příkazu
         add bx,2+2                     ;budeme možná číst parametry
         cmp ax,dx                      ;je to náš příkaz?
         je handle_gpl_command              ;ano ---> zpracujeme ho
         add bx,cx                      ;ne ---> přeskočíme parametry
         add bx,2                       ;a offset rutiny
         jmp short read_gpl_command_declaration       ;a zkusíme další příkaz

;cx denotes the number of parameters, bx denotes the 1st parameter of the routine
;push registers for a later call, and then parameters
handle_gpl_command:
         push ds bx cx dx

handle_gpl_parameter:
         or cx,cx                       ;kolik zbývá parametrů?
         jz run_the_gpl_command                ;0 ---> spustíme příkaz
         dec cx                         ;dekrementace počítadla
         mov al,byte ptr cs:[gpl_command_declarations+bx]  ;vezmeme type_ parametru
         inc bx
         cmp al,4                       ;je to matematický výraz?
         jne parameter_is_a_number
         push ds                        ;předáme adresu výrazu
         push si
         push 1                         ;0 je přičítaný index
         push ss:word ptr variables+2    ;adresa proměnných
         push ss:word ptr variables
         mov ds,ss:word ptr original_ds       ;obnovíme rutině ds
         call evaluate_mathematical_expression          ;FAR volání
	   ;this routine picks these 3 parameters from the stack
	   ;and returns the result in ax, all registers are intact (since it's a function)
	   ;si points behind the mathematical expression
         mov ds,ss:word ptr code+2       ;obnovíme si ds
         push ax                        ;uložíme vrácenou hodnotu
         jmp short handle_gpl_parameter     ;a skočíme na další parametr
parameter_is_a_number:
         lodsw                          ;jinak načteme hodnotu
         push ax                        ;uložíme do zásobníku
         jmp short handle_gpl_parameter     ;a skočíme na další parametr

;now all registers are pushed and parameters sent as integers
;bx points at the offset of the routine
run_the_gpl_command:
         mov ds,ss:word ptr original_ds       ;obnovíme pro zavolání DS
         mov ds:word ptr relative_gpl_jump,0      ;vynulujeme počítadlo skoků
         mov ds:word ptr gpl_end_program,0     ;program běží dál
         mov ss:word ptr original_si,si     ;uložíme sobě ještě si
         call cs:word ptr [gpl_command_declarations+bx]         ;zavoláme danou rutinu
         mov ax,ds:word ptr relative_gpl_jump     ;načte počítadlo skoků
         mov si,ss:word ptr original_si     ;obnoví ještě si
         add si,ax                      ;skočí daný skok
         mov ax,ds:word ptr gpl_end_program
         pop dx cx bx ds                ;obnoví všechny registry
         or ax,ax                       ;nemá se ukončit provádění příkazu?
         jnz end_
         jmp parse_gpl_command              ;přečte další příkaz

;end on command 0 or on an unknown command:
end_:
         mov ds,ss:word ptr original_ds       ;obnovíme si ds
         pop es                         ;obnoví se všechno
         popa
         ret                            ;end_ rutiny

PlayGPL3 endp

;data are in the code segment due to easier addressing:

;function pattern format:
;offset 0       16-bit integer --- number (AL, lower byte) and sub-number (AH,
;		higher byte) of the command
;               AX=0 denotes the end of the list
;offset 2       16-bit integer --- number of parameters of the function
;offsets 4--number_of_parameters+3 --- parameter types (from range [1234])
;               [123]=a 16-bit integer number
;               4=evaluate a mathematical expression until 0 is encountered
;                 identifiers are taken as numbers, variables are evaluated, functions called
;offset number_of_parameters+4     16-bit integer --- NEAR pointer to the procedure

gpl_command_declarations  db 5,1       ;command number 4-1
       dw 2         ;number of parameters, DW!!!
       db 3,2       ;list of parameter types
       dw offset C_Load

       db 4,1       ;command number 5-1
       dw 2         ;number of parameters, DW!!!
       db 3,2       ;list of parameter types
       dw offset C_Start

       db 5,2       ;command number 5-2
       dw 2         ;number of parameters, DW!!!
       db 3,2       ;list of parameter types
       dw offset C_StartPlay

       db 5,3
       dw 0
       dw offset C_JustTalk

       db 5,4
       dw 0
       dw offset C_JustStay

       db 10,2      ;command number 10-2
       dw 3         ;number of parameters, DW!!!
       db 1,1,3     ;list of parameter types
       dw offset C_StayOn

       db 10,1      ;command number 10-1
       dw 3         ;number of parameters, DW!!!
       db 1,1,3     ;list of parameter types
       dw offset C_WalkOn

       db 10,3      ;command number 10-3
       dw 3         ;number of parameters, DW!!!
       db 1,1,3     ;list of parameter types
       dw offset C_WalkOnPlay


       db 7,1       ;command number 7-1
       dw 2         ;number of parameters, DW!!!
       db 3,3       ;list of parameter types
       dw offset C_ObjStat

       db 7,2       ;command number 7-2
       dw 2         ;number of parameters, DW!!!
       db 3,3       ;list of parameter types
       dw offset C_ObjStat_On

       db 8,1       ;command number 8-1
       dw 2         ;number of parameters, DW!!!
       db 3,3       ;list of parameter types
       dw offset C_IcoStat

       db 14,1      ;command number 14-1
       dw 2         ;number of parameters, DW!!!
       db 3,1       ;list of parameter types
       dw offset C_NewRoom

       db 6,1       ;command number 6-1
       dw 2         ;number of parameters, DW!!!
       db 3,2       ;list of parameter types
       dw offset C_Talk

       db 2,1       ;command number 2-1
       dw 2         ;number of parameters, DW!!!
       db 3,4       ;list of parameter types
       dw offset C_Let

       db 15,1      ;command number 15-1
       dw 1         ;number of parameters, DW!!!
       db 3         ;list of parameter types
       dw offset C_ExecInit

       db 15,2      ;command number 15-2
       dw 1         ;number of parameters, DW!!!
       db 3         ;list of parameter types
       dw offset C_ExecLook

       db 15,3      ;command number 15-2
       dw 1         ;number of parameters, DW!!!
       db 3         ;list of parameter types
       dw offset C_ExecUse

       db 16,1      ;command number 16-1
       dw 0         ;number of parameters, DW!!!
       dw offset C_RepaintInventory

       db 16,2      ;command number 16-2
       dw 0         ;number of parameters, DW!!!
       dw offset C_ExitInventory

       db 1,1
       dw 1
       db 3
       dw offset C_goto

       db 3,1
       dw 2
       db 4,3
       dw offset C_if

       db 9,1       ;command number 9-1
       dw 1         ;number of parameters, DW!!!
       db 2         ;list of parameter types
       dw offset C_Dialogue

       db 9,2       ;command number 9-2
       dw 0         ;number of parameters, DW!!!
       dw offset C_ExitDialogue

       db 9,3       ;command number 9-3
       dw 0         ;number of parameters, DW!!!
       dw offset C_ResetDialogue

       db 9,4       ;command number 9-4
       dw 0         ;number of parameters, DW!!!
       dw offset C_ResetDialogueFrom

       db 9,5
       dw 1
       db 3
       dw offset C_ResetBlock

       db 11,1
       dw 1
       db 2
       dw offset C_LoadPalette

       db 12,1
       dw 0
       dw offset C_SetPalette

       db 12,2
       dw 0
       dw offset C_BlackPalette

       db 13,1
       dw 3
       db 1,1,1
       dw offset C_FadePalette

       db 13,2
       dw 3
       db 1,1,1
       dw offset C_FadePalettePlay

       db 17,1      ;command number 17-1
       dw 0         ;number of parameters, DW!!!
       dw offset C_ExitMap

       db 18,1
       dw 1
       db 2
       dw offset C_LoadMusic

       db 18,2
       dw 0
       dw offset C_StartMusic

       db 18,3
       dw 0
       dw offset C_StopMusic

       db 18,4
       dw 1
       db 1
       dw offset C_FadeOutMusic

       db 18,5
       dw 1
       db 1
       dw offset C_FadeInMusic

       db 19,1
       dw 0
       dw offset C_Mark

       db 19,2
       dw 0
       dw offset C_Release

       db 20,1
       dw 0
       dw offset C_Play

       db 21,1
       dw 1
       db 2
       dw offset C_LoadMap

       db 21,2
       dw 0
       dw offset C_RoomMap

       db 22,1
       dw 0
       dw offset C_DisableQuickHero

       db 22,2
       dw 0
       dw offset C_EnableQuickHero

       db 23,1
       dw 0
       dw offset C_DisableSpeedText

       db 23,2
       dw 0
       dw offset C_EnableSpeedText

       db 24,1
       dw 0
       dw offset C_QuitGame

       db 25,1
       dw 0
       dw offset C_PushNewRoom

       db 25,2
       dw 0
       dw offset C_PopNewRoom

       db 26,1
       dw 0
       dw offset C_ShowCheat

       db 26,2
       dw 0
       dw offset C_HideCheat

       db 26,3
       dw 1
       db 1
       dw offset C_ClearCheat

       db 27,1
       dw 3
       db 1,1,1
       dw offset C_FeedPassword

       dw 0         ;end of the function pattern list

end
