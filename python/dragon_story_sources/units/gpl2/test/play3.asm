;změny:
;1) opraveny příkazy o 0 parametrech
;2) playgpl3 si nenastavuje adresu proměnných
;3) vyhodnocovač mat. výrazů je zvlášť
;4) vyhodnocovač dělá stejně s čísly a proměnnými, ale funkce čte z tabulky
;   stejně jako příkazy a zavolá je a operátory čte rovněž z takové tabulky
;   a taky je zavolá
;5) jsou dobře implementovány logické operace, byly přidány aritmetické
;6) odladěno volání vypocetmatvyrazu vně i vevnitř stejně jako playgpl3

;todo: mat2bin musí dát na konec jednu 0, ne 2
;execinit ---> exec init
;možná udělat samomodifikující se kód (zrychlí se to...)
;používat es:di v playgpl3!

;důležité!
;indexy do kodu jsou integerove ---> zde odecist 1 a vynasobit 2
;relativni skoky v kodu jsou bajtove (od GPL) ---> pouze pricist
;čísla do proměnných jsou taky integer ---> odecist 1 a vynasobit 2
;paměť musí být nastavena takto, jinak to blbne
;nelze uvádět dataptr (to jsou 2b), ale word:2 (to jsou 4b)
;retf a retn jsou instrukce, ret je makro ---> s parametry používat jeho!
;nezapomenout na dec si, když to dám do play05.pas!
;+při volání mat. výrazu předat 1, ne 0

.286c

model small,pascal

public VypocetMatVyrazu                         ;vyvážíme tyto 2 FAR rutiny
public PlayGPL3

;RelativniGPLSkok asi nejde definovat zde a použít v Pascalu,
;jako zpětnou hodnotu funkce ho dělat nechci, takže bude definován mimo :-(
extrn RelativniGPLSkok

extrn _random                                   ;dovážené NEAR funkce

comment &
extrn C_Load                                    ;dovážené NEAR procedury
extrn C_Start
extrn C_StartPlay
extrn C_StayOn
extrn C_WalkOn
extrn C_WalkOnPlay
extrn C_ObjStat
extrn C_ObjStat_On
extrn C_NewRoom
extrn C_Talk
extrn C_Let
extrn C_ExecInit
extrn C_ExecLook
extrn C_ExecUse
extrn C_goto
extrn C_if
&

.code

VypocetMatVyrazu proc far
                 arg vyraz:word:2,index,promenne:word:2
                 local puvds

                 push es si di bx cx dx         ;zapíšeme si všechno
                 mov ss:word ptr puvds,ds       ;zapíšeme si ds pro volání fcí

                 mov si,ss:word ptr index       ;start je od 1, hlavička už není
;                 dec si                         ;index je zadán v integerech
                 shl si,1
                 add si,ss:word ptr vyraz       ;přidej offset čtení kódu
                 mov ds,ss:word ptr vyraz+2
                 mov di,ss:word ptr promenne    ;vezmeme adresu výrazu
                 mov es,ss:word ptr promenne+2
                 xor bx,bx                      ;délka Stacku je 0

dalsi_mat_objekt:
                 lodsw                          ;načteme další objekt mat. výrazu
                 or ax,ax                       ;konec?
                 jz konec_mat_vyrazu
                 cmp ax,1                       ;číslo?
                 je obj_cislo
                 cmp ax,2                       ;operátor?
                 je obj_oper
                 cmp ax,3                       ;funkce?
                 je obj_fce
                 cmp ax,4                       ;identifikátor proměnné?
                 je obj_prom
                 jmp obj_cislo
                 ;jinak je to identifikátor objektu, který se bere jako číslo

konec_mat_vyrazu:
                 mov ax,si                      ;kolik jsme přečetli bajtů?
                 sub ax,ss:word ptr vyraz
                 pop dx cx bx di si es          ;obnovíme všechno
                 mov ds,ss:word ptr puvds       ;vč. ds
                 add si,ax                      ;posuneme si o přečtený počet
                 mov ax,cs:word ptr poststack   ;vrátíme hodnotu
                 ret                            ;konec rutiny
                 ;0 na konci už se neodstraňuje

VypocetMatVyrazu endp

obj_cislo:                                      ;došlo nám číslo
                 lodsw                          ;vezmeme a PUSHneme hodnotu
                 mov cs:word ptr [poststack+bx],ax
                 add bx,2
                 jmp dalsi_mat_objekt

obj_prom:                                       ;proměnná
                 lodsw                          ;vzít číslo
                 dec ax                         ;převést na index
                 shl ax,1
                 add di,ax
                 mov dx,es:word ptr di          ;načíst hodnotu
                 sub di,ax
                 mov cs:word ptr [poststack+bx],dx ;uložit do stacku
                 add bx,2
                 jmp dalsi_mat_objekt

obj_fce:                                        ;volání funkce?
                 lodsw                          ;číslo funkce
                 push ds es si di bx cx dx      ;PUSHneme registry
                 dec ax                         ;převedeme na index
                 shl ax,1
                 push cs:word ptr [poststack+bx-2] ;uložíme předanou hdonotu

                 mov ds,ss:word ptr puvds       ;obnovíme ds
                 mov bx,ax                      ;zavoláme funkci
                 call cs:word ptr [volejfce+bx]

                 mov ds,ss:word ptr vyraz+2     ;obnovíme si ds
                 pop dx cx bx di si es ds       ;POPneme registry
                 mov cs:word ptr [poststack+bx-2],ax ;uložíme vrácenou hodnotu
                 jmp dalsi_mat_objekt

obj_oper:                                       ;volání operátoru?
                 lodsw                          ;načti číslo operátoru
                 push si
                 mov si,ax                      ;převedeme číslo na index
                 dec si
                 shl si,1
                 sub bx,2                       ;snížíme počítadlo postfixu
                 mov ax,cs:word ptr [poststack+bx-2] ;zapíšeme operandy
                 push bx
                 mov bx,cs:word ptr [poststack+bx]
                 call cs:word ptr [volejoper+si] ;zavoláme daný operátor
                 pop bx si
                 mov cs:word ptr [poststack+bx-2],ax ;zapíšeme výsledek
                 jmp dalsi_mat_objekt

;místo pro postfixový vyhodnocovač, 1 je zrovna proto :)))
poststack        dw 50 dup(1)

;adresa volaných funkcí, zatím je tam pouze not a random
volejfce         dw offset fce_not
                 dw offset _random

;adresa volaných operátorů
volejoper        dw offset oper_and
                 dw offset oper_or
                 dw offset oper_xor
                 dw offset oper_rovno
                 dw offset oper_ruzno
                 dw offset oper_mensi
                 dw offset oper_vetsi
                 dw offset oper_mensirovno
                 dw offset oper_vetsirovno
                 dw offset oper_krat
                 dw offset oper_deleno
                 dw offset oper_zbytek
                 dw offset oper_plus
                 dw offset oper_minus

fce_not proc near                       ;funkce vracející logický not
             arg cislo                  ;nelze vyvolat instrukci not
             mov ax,cislo
             or ax,ax
             jz not_nulove
             mov ax,1
not_nulove:
             xor ax,1
             ret
fce_not endp

fce_logickyoperator proc near           ;provede korekci obou cisel na bool
             or ax,ax                   ;0--->0, jine cislo--->1
             jz log_nuloveax
             mov ax,1
log_nuloveax:
             xor ax,1
             or bx,bx
             jz log_nulovebx
             mov bx,1
log_nulovebx:
             xor bx,1
fce_logickyoperator endp

oper_and proc near                      ;udělá logický and
              call fce_logickyoperator
              and ax,bx
              ret
oper_and endp

oper_or proc near                       ;udělá logický or
              call fce_logickyoperator
              or ax,bx
              ret
oper_or endp

oper_xor proc near                      ;udělá logický xor
              call fce_logickyoperator
              xor ax,bx
              ret
oper_xor endp

oper_vysledek1:                         ;u komparace nastaví výsledek 1
              mov ax,1
              retn

oper_vysledek0:                         ;u komparace nastaví výsledek 0
              xor ax,ax
              retn

oper_rovno proc near
           cmp ax,bx
           je oper_vysledek1
           jmp oper_vysledek0
oper_rovno endp

oper_ruzno proc near
           cmp ax,bx
           jne oper_vysledek1
           jmp oper_vysledek0
oper_ruzno endp

oper_mensi proc near
           cmp ax,bx
           jl oper_vysledek1
           jmp oper_vysledek0
oper_mensi endp

oper_vetsi proc near
           cmp ax,bx
           jg oper_vysledek1
           jmp oper_vysledek0
oper_vetsi endp

oper_mensirovno proc near
           cmp ax,bx
           jle oper_vysledek1
           jmp oper_vysledek0
oper_mensirovno endp

oper_vetsirovno proc near
           cmp ax,bx
           jge oper_vysledek1
           jmp oper_vysledek0
oper_vetsirovno endp

oper_krat proc near
          imul bx                        ;dx se zanedba
          ret
oper_krat endp

oper_deleno proc near
          xor dx,dx
          idiv bx                        ;podíl je v ax
          ret
oper_deleno endp

oper_zbytek proc near
          xor dx,dx
          idiv bx                        ;zbytek je v dx
          mov ax,dx
          ret
oper_zbytek endp

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
         arg kod:word:2,start:word,promenne:word:2      ;dataptr nějak nefachá
         local puvds,uchovsi

         pusha                          ;uloží se všechno
         push es
         mov ss:word ptr puvds,ds       ;uložíme si ještě ds

         mov si,ss:word ptr start       ;start je od 1, hlavička už není
;         dec si                         ;index je zadán v integerech
         shl si,1
         add si,ss:word ptr kod         ;přidej offset čtení kódu
         mov ds,ss:word ptr kod+2
;es:di je volno, protože R/W proměnných zde nepotřebuji
;ds:si (čtení programu a mat. výrazu)
;čtení masek příkazů je adresováno přes cs:[bx+offset]
;vyhodnocovač postfixů pracuje také přes cs:[bx+offset], bx se PUSHne
;do zásobníku se po registrech postupně ukládají parametry, ale v postfixu
;mohu PUSHovat, neboť se to pak na jeho konci zase obnoví...

cteni_prikazu:
         lodsw                          ;načti číslo prováděného příkazu
         or al,al
         jnz ne_konec                   ;0=příkaz na konec
         jmp konec
ne_konec:
         mov dx,ax                      ;zaznamenej číslo příkazu
         xor bx,bx                      ;čteme nyní podporované příkazy
cteni_predlohy:
         mov ax,word ptr cs:[volejproc+bx]  ;načti číslo dalšího příkazu
         or ax,ax                       ;0=konec seznamu
         jnz ne_konec_predlohy
         jmp konec                      ;nenašli jsme ---> chyba!
ne_konec_predlohy:
         mov cx,word ptr cs:[volejproc+bx+2];načti počet parametrů příkazu
         add bx,2+2                     ;budeme možná číst parametry
         cmp ax,dx                      ;je to náš příkaz?
         je zpracuj_prikaz              ;ano ---> zpracujeme ho
         add bx,cx                      ;ne ---> přeskočíme parametry
         add bx,2                       ;a offset rutiny
         jmp short cteni_predlohy       ;a zkusíme další příkaz

;v cx je počet parametrů, bx je na 1. parametru rutiny
;pro pozdější zavolání si teď PUSHneme registry, pak přijdou na řadu parametry
zpracuj_prikaz:
         push ds bx cx dx

zpracuj_parametr:
         or cx,cx                       ;kolik zbývá parametrů?
         jz spust_prikaz                ;0 ---> spustíme příkaz
         dec cx                         ;dekrementace počítadla
         mov al,byte ptr cs:[volejproc+bx]  ;vezmeme typ parametru
         inc bx
         cmp al,4                       ;je to matematický výraz?
         jne parametr_cislo
         push ds                        ;předáme adresu výrazu
         push si
         push 0                         ;0 je přičítaný index
         push ss:word ptr promenne+2    ;adresa proměnných
         push ss:word ptr promenne
         mov ds,ss:word ptr puvds       ;obnovíme rutině ds
         call VypocetMatVyrazu          ;FAR volání
           ;a zavoláme na to rutinu: tyto 3 parametry vybere ze záboníku,
           ;výsledek vrátí v ax, všechny registry nechá netknuty (je to fce)
           ;si posune za konec mat. výrazu
         mov ds,ss:word ptr kod+2       ;obnovíme si ds
         push ax                        ;uložíme vrácenou hodnotu
         jmp short zpracuj_parametr     ;a skočíme na další parametr
parametr_cislo:
         lodsw                          ;jinak načteme hodnotu
         push ax                        ;uložíme do zásobníku
         jmp short zpracuj_parametr     ;a skočíme na další parametr

;nyní jsou všechny registry PUSHnuty a parametry předány jako integer
;bx nám ukazuje na offset rutiny
spust_prikaz:
         mov ds,ss:word ptr puvds       ;obnovíme pro zavolání DS
         mov ds:word ptr RelativniGPLSkok,0      ;vynulujeme počítadlo skoků
         mov ss:word ptr uchovsi,si     ;uložíme sobě ještě si
         call cs:word ptr [volejproc+bx]         ;zavoláme danou rutinu
         mov ax,ds:word ptr RelativniGPLSkok     ;načte počítadlo skoků
         pop dx cx bx ds                ;obnoví všechny registry
         mov si,ss:word ptr uchovsi     ;obnoví ještě si
         add si,ax                      ;skočí daný skok
         jmp cteni_prikazu              ;přečte další příkaz

;konec při příkazu 0 nebo neznámém příkazu:
konec:
         mov ds,ss:word ptr puvds       ;obnovíme si ds
         pop es                         ;obnoví se všechno
         popa
         ret                            ;konec rutiny

PlayGPL3 endp

;data jsou v code segmentu kvůli snažšímu odkazování se:

;uložení volání procedur:
;0              integer --- číslo (AL) a podčíslo (AH) příkazu
;               AX=0 je konec
;2              integer --- počet parametrů, int kvůli lehkému čtení
;4.--PočetPar+3 byte --- parametry (oznamuje se typ 1234)
;               123=předá se integer číslo
;               4=vyhodnotí se matematický výraz, dokud se nenarazí na 0
;                 ten identifikátoru bere jako čísla, pouze proměnné
;                 vyhodnotí, funkce zavolá
;PočetPar+4     integer --- NEAR ukazatel na proceduru

comment &
VolejProc  db 4,1       ;prikaz cislo 4-1
       dw 2         ;pocet parametru, DW!!!
       db 3,2       ;seznamy parametru
       dw offset C_Load

       db 5,1       ;prikaz cislo 5-1
       dw 2         ;pocet parametru, DW!!!
       db 3,2       ;seznamy parametru
       dw offset C_Start

       db 5,2       ;prikaz cislo 5-2
       dw 2         ;pocet parametru, DW!!!
       db 3,2       ;seznamy parametru
       dw offset C_StartPlay

       db 10,2      ;prikaz cislo 10-2
       dw 3         ;pocet parametru, DW!!!
       db 1,1,3     ;seznamy parametru
       dw offset C_StayOn

       db 10,1      ;prikaz cislo 10-2
       dw 3         ;pocet parametru, DW!!!
       db 1,1,3     ;seznamy parametru
       dw offset C_WalkOn

       db 10,3      ;prikaz cislo 10-3
       dw 3         ;pocet parametru, DW!!!
       db 1,1,3     ;seznamy parametru
       dw offset C_WalkOnPlay


       db 7,1       ;prikaz cislo 7-1
       dw 2         ;pocet parametru, DW!!!
       db 3,3       ;seznamy parametru
       dw offset C_ObjStat

       db 7,2       ;prikaz cislo 7-2
       dw 2         ;pocet parametru, DW!!!
       db 3,3       ;seznamy parametru
       dw offset C_ObjStat_On

       db 14,1      ;prikaz cislo 14-1
       dw 2         ;pocet parametru, DW!!!
       db 3,1       ;seznamy parametru
       dw offset C_NewRoom

       db 6,1       ;prikaz cislo 6-1
       dw 2         ;pocet parametru, DW!!!
       db 3,2       ;seznamy parametru
       dw offset C_Talk

       db 2,1       ;prikaz cislo 2-1
       dw 2         ;pocet parametru, DW!!!
       db 3,4       ;seznamy parametru
       dw offset C_Let

       db 15,1      ;prikaz cislo 15-1
       dw 1         ;pocet parametru, DW!!!
       db 3         ;seznamy parametru
       dw offset C_ExecInit

       db 15,2      ;prikaz cislo 15-2
       dw 1         ;pocet parametru, DW!!!
       db 3         ;seznamy parametru
       dw offset C_ExecLook

       db 15,3      ;prikaz cislo 15-2
       dw 1         ;pocet parametru, DW!!!
       db 3         ;seznamy parametru
       dw offset C_ExecUse

       db 1,1
       dw 1
       db 3
       dw offset C_goto

       db 3,1
       dw 2
       db 4,3
       dw offset C_if

       dw 0         ;konec těchto dat
&
volejproc dw 0

end
