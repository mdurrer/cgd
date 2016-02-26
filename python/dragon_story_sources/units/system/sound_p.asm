;********************************************************************
;      Prehravac samplu a hudby pod prerusenim 08
;********************************************************************

;tempo hudby je sladeno s rychlosti preruseni, pokud se nastavi jina
;frekvence osmicky nez 15909.09 Hz, tempo bude blbnout
;take frekvence tonu jsou spocitany pro frekvenci osmicky 15909.09,
;takze pri zmene frekvence Int08 je treba je prepocitat

;prehravac samplu neumi samply vetsi, nez 64K - pro hudbu by to ani
;nebylo ucelne, mame snahu, aby zabirala cela pokud mozno co nejmin
;(asi tak jeden segment...)
;pro zvukove efekty bude vhodne dodelat, aby to hralo samply libovolne
;dlouhe (jedna se pouze o kanal 0), asi tak, ze je to bude postupne
;nacitat do pameti - mel by se vyhradit buffer, podle rychlosti disku
;(ale nanejvys stejne 64K) to do nej vsechno postupne nacitat a z neho
;hrat- bude to docela fuska sladit to, aby to nebylo pomaly a zvuk
;nevynechaval... !!!na toto je vhodne pouzit EMS, jenze co kdyz ji
;neni dostatek!!!
;ANEBO?! ...se na to vyserem a delsi zvuky nez 64K vsechny rozsekame!
;potom by to mozna chtelo primo do hraci rutiny udelat funkci, aby to
;po dohrani jednoho samplu hned nastavilo hodnoty pro druhy sampl a
;zaclo ho rovnou hrat?


Code    Segment Byte Public
        public  InitPlay
        public  DonePlay
	public  Speed08
        public  Channels
        public  Samples

        assume cs:code,ds:code;
        org 100h
Speed08:   db  0                ;pokud je tady 75, znamena to 15909.09 Hz

; nasledujicich ...  je pouze pro ladici ucely
;AlreadyIn: db  0
;PocitPodLo:dw 0
;PocitPodHi:dw 0
;PodTimLo : dw 0
;PodTimHi : dw 0
;ZdrzeniHi:  dw  0
;ZdrzeniLo:  dw  0
;AktualniPattern: db 0

; konec ... pro ladici ucely

OutDevice:  db  0               ;vystupni zarizeni 1=speaker,2=DA,3=Blaster
HowMuchCh:  db  0               ;kolik kanalu, je to sice jako db, ale
                                ;pak sem dame asi primo 4
Port1:      dw  378h            ;adresa LPT1 (?)
                                ;BACHA! muze se lisit, mel by se dopsat
                                ;init, ktery by zjistil jak adresu LPT1,
                                ;tak port Blastru, ten mam taky psany
                                ;absolutne pro muj Blastr
BlasterPort: dw 220h

oldofs8: dw   0                 ;uschova stare adresy preruseni 08
oldseg8: dw   0

Tempo:      dw 0        ;delitel frekvence osmicky, aby bylo dosazeno
                        ;pozadovaneho tempa v BPM
TempoCitac: dw 0        ;pokazde, kdyz se dopocita do nuly, prejde se
                        ;na dalsi notu a prenese se do nej znovu hodnota "Tempo"

ShallPlay:     db 0     ;pokud je zde nulova hodnota, hudba se nehraje
                        ;(je vypnuta). Je vhodne sem zapsat nulu pred
                        ;inicializaci osmicky a hudby

NotesInPattern:db 0     ;pocet not v patternu
;NumOfPatterns: db 0     ;pocet patternu
AddrTabPatSeg: dw 0     ;segment adresy tabulky adres patternu
AddrTabPatOfs: dw 0     ;offset adresy tabulky adres patternu

PatternsSeg:   dw 0     ;segment adresy zacatku oblasti patternu
PatternsOfs:   dw 0     ;offset adresy zacatku oblasti patternu
AddrActPattern:  dw 0   ;relativni adresa v aktualnim patternu

RepeatItem:      db 0   ;cislo polozky-1, od ktere se ma cela skladba opakovat
ActualOrderItem: db 0   ;aktualni polozka v tab. poradi hrani patternu
NumOfItemsOrder: db 0   ;pocet polozek v tabulce poradi hrani patternu
AddrTabOrderSeg: dw 0   ;segment adresy tabulky poradi hrani patternu
AddrTabOrderOfs: dw 0   ;offset adresy tabulky poradi hrani patternu


;tabulka pro hodnoty Krok a OvrLd
TabulkaTonu:
db 24*8 dup (?)

; tabulka vyhrazena pro kanaly
ChDelkaTab equ 15             ;delka tabulky pro jeden kanal v byte
Channels:
ChSeg:   dw   0               ;segment adresy samplu hraneho v danem kanalu
ChOfs:   dw   0               ;offset adresy samplu hraneho v danem kanalu
SizeCh:  dw   0               ;delka samplu hraneho v danem kanalu
ChVolume:db   255             ;hlasitost samplu v danem kanalu
ChLoop:  dw 0                 ;start. adresa opakovani samplu v kanalu
ChLenLp: dw 0                 ;delka opak. smycky, kdyz je 0, neopakuje se

;IndexTonu: db 0               ;index tonu v tabulce hodnot Krok a OvrLd
                              ;pouze pro informaci pro fce 1 a 2 (zmena
                              ;vysky tonu)
Krok:    dw   0               ;pouzito pro vysku tonu
OvrLd:   db   0               ;pouzito pro vysku tonu
OvrLd2:  db   0               ;pouzito pro vysku tonu
ChBufer: db   4*15 dup (?)    ;misto pro zbyvajici 3 kanaly
; konec tabulky pro kanaly


jump     dw   0


Samples:                       ;tady jsou ulozene informace o samplech
SmpSeg:    dw 0                ;segment adresy ulozeni samplu
SmpOfs:    dw 0                ;offset adresy ulozeni samplu
SizeSmp:   dw 0                ;delka samplu
Volume:    db 0                ;hlasitost samplu
SmpLoop:   dw 0                ;start. adresa opakovani samplu
LengthLoop:dw 0                ;delka opak. smycky, kdyz je 0, neopakuje se
SmpBuffer: db 14*11 dup (?)    ;buffer na dalsich 14 inf. o samplech,
                               ;tedy dohromady pro 15 samplu


;********************************************************************
;              M u s i c   p r o c   n e a r
;********************************************************************

;hudebni rutina vyuziva kanaly:  3 (1.hlas)
;                                2 (2.hlas)
;                                1 (3.hlas)
;kanal cislo 0 (cili v tabulce kanalu prvni kanal) je volny pro efekty

Music proc near                        ;ds = cs (bacha na to!)
    mov  al,byte ptr [ShallPlay]       ;pokud je v ShallPlay
    or   al,al                         ;nulova hodnota, hudba
    jnz HudbaHraje                     ;je docasne vypnuta a
    retn                               ;nehraje...
HudbaHraje:
    dec  word ptr [TempoCitac]         ;pokud se citac vynuluje, nastal cas
    jz OpetNoty                        ;pro prechod na dalsi notu
    retn                               ;jinak zatim navrat
OpetNoty:

    mov  al,byte ptr [NotesInPattern]  ;pokud je pocet not nulovy, osetrime
    or   al,al                         ;konec patternu
;    jnz Prozatim
;    retn

    jz KonecPatternu
;Prozatim:
    dec  byte ptr [NotesInPattern]     ;jinak snizime citac not a prejdeme
                                       ;na dalsi notu
    mov  ax,word ptr [Tempo]           ;v tom pripade nastavim
    mov  word ptr [TempoCitac],ax      ;opet citac tempa

    mov  ax,word ptr [PatternsSeg]
    mov  si,word ptr [AddrActPattern]
    mov  ds,ax                         ;na adrese (ds):[si] by mela
                                       ;byt dalsi nota
    mov  cx,4                          ;pocitadlo kanalu, zacneme od posledniho

DalsiKanal:
    mov  al,11
    mul  byte ptr [si]                 ;cislo nastroje vynasobim 11, v  ax
                                       ;je relat. adr. v tabulce samplu
    or   al,al                         ;al  testuju na nulu
    jnz OddilNota                      ;pokud  al  neni nula, je tam nastroj
    inc  si
    jmp  OddilFunkce
OddilNota:
    push ds                            ;uchovam  ds:si, coz je
    push si                            ;adresa noty v patternu

    mov  si,offset Samples-11
    add  si,ax
    mov  ax,cs                         ;v  ds:si  je adr. zacatku tabulky
    mov  ds,ax                         ;zpracovavaneho samplu

    mov  es,ax                         ;tabulky se nachazeji v segmnentu
                                       ;programu, es = ds = cs
    push cx                            ;ulozim pocitadlo kanalu
    mov  al,ChDelkaTab                 ;tabulka pro jeden kanal ma ChDelkaTab byte
    mul  cl
    mov  di,offset Channels
    add  di,ax                         ;v  es:di  adr. zacatku tabulky
                                       ;pouziteho kanalu

    mov  cx,11                         ;SmpSeg, SmpOfs, SizeSmp, Volume, SmpLoop, LengthLoop
    cld                                ;prenos smerem nahoru
    rep  movsb                         ;v tabulce pro prislusny kanal jsou
                                       ;data pro pozadovany sampl

;NASLEDUJICI KOMENTAR NEPLATI!         ; es:di  ukazuje na polozku "IndexTonu"
                                       ;v tabulce kanalu
;END...

    pop  cx
    pop  si                            ;obnovim  ds:si, coz je adresa
    pop  ds                            ;noty v patternu
    inc  si                            ;presun z cisla nastroje na index tonu
    mov  al,byte ptr [si]              ;v  al  index tonu
    sal  al,1                          ;vynasobim ho dvema
    push ds

;ZATIM NEPOUZIVAM
;    mov  byte ptr es:[di],al           ;index tonu prenesen do tabulky kanalu
;    inc di
                                       ; es:di  ukazuje na polozku "Krok"
                                       ;v tabulce kanalu
    call LoadKrokOvrLd                 ;nactu a ulozim hodnoty Krok a OvrLd

    pop  ds                            ;obnovim  ds  , ds:si je adresa
                                       ;noty v patternu


OddilFunkce:
    inc  si                            ;jsem na bajtu funkce(pouze horni polovina)
    mov  al,byte ptr [si+1]            ;v  al  cislo funkce
    and  al,0f0h
    jnz Function


NoFunction:
    inc  si
    inc  si                            ;prechod na dalsi notu


    dec  cx
    cmp  cx,1
    jne  DalsiKanal
ExitMusic:
    mov  word ptr cs:[AddrActPattern],si   ;po naladovani hodnot pro vsechny
    retn                                   ;kanaly se odtud z procedury Music
                                           ;vyskakuje

KonecPatternu:                             ;v pripade, ze se doslo na konec
                                           ;patternu, tady se rozhodne, co
                                           ;bude dal
    mov  ax,word ptr cs:[AddrTabOrderSeg]
    mov  ds,ax                             ;v  ds:si  bude adr. zacatku
    mov  si,word ptr cs:[AddrTabOrderOfs]  ;tabulky poradi hrani patternu
    mov  ax,word ptr cs:[ActualOrderItem]  ;v  al  je "ActualOrderItem"
                                           ;(cislo aktualni polozky v tab.)
                                           ;v  ah  je "NumOfItemsOrder"
                                           ;(pocet polozek v tabulce)
    cmp  al,ah                             ;pokud se rovnaji, jsme na konci
    jnz NeKonecSkladby                     ;skladby
    mov  al,byte ptr cs:[RepeatItem]       ;kdyz konec, prejdu na polozku,
                                           ;od ktere se ma opakovat

                                           ;al  se hned zvysi o 1, cili bude
                                           ;opravdu na 1. polozce tabulky
NeKonecSkladby:
    inc  al
    mov  byte ptr cs:[ActualOrderItem],al
    xor  ah,ah
    add  si,ax                             ;v  ds:si adresa nove polozky
                                           ;v tabulce
    mov  bl,byte ptr [si]                  ;v  bl  cislo noveho patternu

;    mov  byte ptr cs:[AktualniPattern],bl
;pouze pro odladovani

    mov  ax,word ptr cs:[AddrTabPatSeg]
    mov  ds,ax
    mov  si,word ptr cs:[AddrTabPatOfs]    ; ds:si  ukazuje na tabulku
                                           ;relativnich adres patternu
                                           ;vzhledem k zacatku oblasti, kde jsou ulozeny
    sal  bl,1                              ;adresa ma 2 byty, cislo patternu
                                           ;vynasobim dvema
    xor  bh,bh
    add  si,bx                             ;ds:si ukazuje na adresu, kde
                                           ;je ulozena adresa noveho patternu
    mov  di,word ptr [si]                  ;v  di  relat. adresa patternu
    mov  ax,word ptr cs:[PatternsOfs]
    add  di,ax                             ;v  di  offset adresy patternu

    mov  ax,word ptr cs:[PatternsSeg]
    mov  ds,ax                             ;ds:di ukazuje na zac. patternu
    mov  al,byte ptr [di]                  ;al = pocet not v patternu
    mov  byte ptr cs:[NotesInPattern],al

    inc di                                 ; di  uz na datech not
    mov  word ptr cs:[AddrActPattern],di

    mov  word ptr cs:[TempoCitac],1        ;abychom se uz moc nezdrzovali,
                                           ;skutecne se novy pattern zacne
                                           ;hrat az pri dalsim pruchodu osmickou
    retn

Function:                                  ;tady se obsluhuji funkce
    cmp  al,0f0h
    jz F_Speed                             ;f= rychlost
    cmp  al,0c0h
    jz F_Volume                            ;c= hlasitost
    jnz NoFunction                         ;vic funkci prozatim neni
F_Volume:
    mov  ax,cs
    mov  es,ax                          ;es=cs
    mov  al,15
    mul  cl
    mov  di,ax                          ;v  di  je relat. adr. zacatku tabulky
                                        ;pouziteho kanalu od navesti Channels

    mov  al,byte ptr [si]               ;v  al  nova hlasitost
    mov  byte ptr es:[di+ChVolume],al
    jmp NoFunction
F_Speed:
;    mov  dx,000eh
;    mov  ax,90ach                       ;v  dx+ax  je 15909*60
;    mov  bx,word ptr [si]               ;v  bx  fcni hodnota
;    and  bh,0fh
;    div  bx

    mov  dx,0012h
    mov  ax,34deh                       ;v  dx:ax  je 1193182, pocet kmitu generatoru za sekundu
    mov  bl,byte ptr cs:[Speed08]       ;v bx je delitel frekvence generatoru
    mov  bh,0
    div  bx                             ;v  ax  je nyni frekvence osmicky v Hz
    mov  bx,60
    mul  bx                             ;v  dx:ax  je pocet kmitu za minutu

    mov  bx,word ptr [si]
    and  bh,0fh                         ;v  bx  fcni hodnota BPM
    div  bx

    mov  word ptr cs:[Tempo],ax         ;nastavim nove tempo
    mov  word ptr cs:[TempoCitac],ax    ;nastavim hned novy citac tempa
    jmp NoFunction

LoadKrokOvrLd:                         ;volam to jako proceduru, i kdyz je
                                       ;to zatim zbytecny...
    push ax                            ;v  al  je uplny index tonu v tabulce
                                       ;(uz vynasobeny dvema)

    mov  bx,cs
    mov  ds,bx
    mov  bx,offset TabulkaTonu         ;ds:bx je komplet.adr. tabulky tonu

    xlat                               ;v  al  bude hodnota "Krok"
    mov  byte ptr es:[di],al           ; ...prenesena do tabulky kanalu
    inc  di                            ;pro "Krok" jsou vyhrazeny 2 byty,
    inc  di                            ;ale zabira jen ten nizsi
    pop  ax

    inc  al                            ;hodnota OvrLd je jako druha
    xlat                               ;v  al  bude hodnota "OvrLd"
    mov  byte ptr es:[di],al           ; ...prenesena do tabulky kanalu
    retn

Music endp


;********************************************************************
;                   Inicializacni  a cast
;********************************************************************

;nastavi to novou osmicku a inicializuje to prehravac samplu
;prehravac hudby timto inicializovan NENI!
;inicializace hudby se (zatim?) musi provest mimo, a to takto:
; do ShallPlay zapsat 0 (nehraje se), nacist hudbu, nastavit
; vse, co je potreba, a do ShallPlay zapsat cokoli <> 0 a hudba
; se zacne hrat


InitPlay proc far                               ;inicializace hracich rutin
	mov  word ptr cs:[jump],offset Speak    ;zjisteni, na jakem
        cmp  byte ptr cs:[OutDevice],1          ;vystupnim zarizeni
  	je  SetIntr                             ;se ma hrat
	mov  word ptr cs:[jump],offset DAmono
        cmp  byte ptr cs:[OutDevice],2
	je  SetIntr
	mov  word ptr cs:[jump],offset Blast
        cmp  byte ptr cs:[OutDevice],3          ;pokud jde o Blaster,
        je InitBlaster                          ;musi se inicializovat
	ret                                     ;chybne zadane zarizeni
InitBlaster:
        mov  dx,word ptr cs:[BlasterPort]
        add  dx,0ch

;	mov  dx,22ch

	mov  al,0d1h
	out  dx,al                              ;init DA prevod. na Blastru
SetIntr:
        push ds
        mov  ax, 3508h
        int  21h
        mov  word ptr cs:[oldseg8], es          ;ulozim adresu puvodniho
        mov  word ptr cs:[oldofs8], bx          ;preruseni 08h
        call SpeakerOn                          ;zapnu DA mod na PC speakru
        mov  ax, 2508h
        mov  dx, offset New08
        push cs
        pop  ds
        int  21h                                ;nova adresa preruseni 08h

        mov  ah, byte ptr cs:Speed08            ;v  ah  delenec frekvence
        call SpeedUp                            ;nastaveni frekvence osmicky
        pop  ds
        retf
InitPlay  endp                                  ;konec inicializace

SpeakerOn proc near                             ;zapnuti DA modu PC speakru
        mov  al, 90h
        out  43h,al
        in   al,61h
        or   al,3
        out  61h,al
        retn
SpeakerOn endp

SpeakerOff proc near                            ;nastaveni PC speakru
        in  al,61h                              ;do normalniho modu
        and al, 0fch
        out 61h, al
        retn
SpeakerOff endp

SpeedUp proc near                               ;nastaveni frekvence
                                                ;vykonavani preruseni 08h
        cli                                     ;zakaz preruseni
        mov  al, 34h
        out  43h, al
        db   2eh                                ;prefix  cs:
        mov  al ,ah                             ;vyssi bajt delitele frek.
        out  40h, al
        db   2eh                                ;prefix  cs:
        mov  al, 0                              ;nizsi bajt delitele frek.
        out  40h, al
        sti                                     ;opetne povoleni preruseni
        retn
SpeedUp endp

;********************************************************************
;                   Odinstalovani osmicky
;********************************************************************

DonePlay proc far                               ;odinstalovani hrajicich rutin
        push ds
        xor  ah,ah                              ;nastavim obvyklou rychlost
        call SpeedUp                            ;preruseni 08h
        cli                                     ;zakazu znovu preruseni
        mov  ax,word ptr cs:[oldseg8]           ;nastavim puvodni adresu osmicky
        mov  dx,word ptr cs:[oldofs8]
        mov  ds, ax
        mov  ax, 2508h
        int  21h
        call SpeakerOff                         ;nastavim standartni mod speakru

        mov ah,2
        int 1ah                                 ;nactu skutecny cas z CMOS
        mov al,dh                               ;je v BCD forme, prevedu
        call BcdToHex                           ;ho na hexadecimalni cisla
        mov dh,al
        mov al,cl
        call BcdToHex
        mov cl,al
        mov al,ch
        call BcdToHex
        mov ch,al
        mov ah,2dh
        int 21h                                 ;nastavim skutecny cas v DOSu

        sti                                     ;povolim preruseni
        pop  ds
	retf
DonePlay endp

BcdToHex proc near                              ;prevod cisla v BCD forme
        push cx                                 ;na hexadecimalni cislo
        mov ah,al
        and ax,0ff0h
        mov cl,4
        rol al,cl
        mov cl,ah
        mov ah,0ah
        mul ah
        add al,cl
        pop cx
        retn
BcdToHex endp

;********************************************************************
;            N e w 0 8   p r o c   f a r
;********************************************************************

;nova osmicka, odtud se vsechno vola

New08 proc far                                  ;prehravac samplu
        push  ax                                ;v preruseni 08h
        push  bx
	push  cx                                ;na pocatku ulozim
	push  dx                                ;vsechny registry
        push  si
	push  di
        push  bp
        push  ds
        push  es

;TOTO JSEM ZATIM NEPOUZIL...

;        cmp   byte ptr cs:[AlreadyIn],0
;        jne JeToVTom
;        push  cs
;        push  ofs ZkusebniVolani

;        mov   al, 20h                          ;dam vedet, ze osmicka
;        out   20h, al                          ;byla vykonana

;        iret                                   ;navrat z preruseni
;JeToVTom:


;        mov   ax,word ptr [PocitPodLo]
;        mov   word ptr [PodTimLo],ax
;        mov   word ptr [PocitPodLo],0
;        mov   ax,word ptr [PocitPodHi]
;        mov   word ptr [PodTimHi],ax
;        mov   word ptr [PocitPodHi],0

        mov   ax,cs                             ;data segment bude stejny
        mov   ds,ax                             ;jako code segment
        call Music

        mov   ax,cs                             ;data segment bude stejny
        mov   ds,ax                             ;jako code segment
        call Player                             ;volam prehravac samplu

        pop    es                               ;vyzvednu registry
        pop    ds
        pop    bp
	pop    di
        pop    si
	pop    dx
	pop    cx
        pop    bx



        sti
        mov    al, 20h                          ;dam vedet, ze osmicka
        out    0a0h, al
        out    20h, al                          ;byla vykonana

        pop    ax
        iret                                    ;navrat z preruseni
New08 endp

;ZkusebniVolani proc far
;        mov   byte ptr cs:[AlreadyIn],1


;        pop    es                               ;i ostatni registry
;        pop    ds
;        pop    bp
;	pop    di
;        pop    si
;	pop    dx
;	pop    cx
;        pop    bx

;        mov   byte ptr cs:[AlreadyIn],0
;        retf
;ZkusebniVolani endp



;********************************************************************
;           P l a y e r   p r o c   n e a r
;********************************************************************

;rutina, ktera obsluhuje kanaly zvuku (4 kanaly: 0,1,2,3)

Player proc near                                ;prehravac samplu
	mov   cl,byte ptr HowMuchCh             ;cx=pocet kanalu
	mov   ch,0
	xor   dx,dx                             ;v  dl  michana hodnota vystupu
	mov   di,0			        ;index adresy v tabulce kanalu

StartLoop:
        mov   ax,word ptr [di+ChSeg]            ;segment adresy samplu v prislusnem
        or    ax,ax                             ;kanalu- pokud je nulovy, kanal
        jz    NextChannel                       ;zrovna nic nehraje
        mov   es,ax                             ;es  je segmentem adresy samplu
        mov   bx,word ptr [di+ChOfs]            ;bx  je offsetem adr. samplu
        mov   al,byte ptr [di+OvrLd]
        add   byte ptr [di+OvrLd2], al
        adc   bx,word ptr [di+Krok]
        cmp   bx,word ptr [di+SizeCh]           ;pokud je offset vetsi nez delka
        ja    SampleEnd                         ;samplu, znamena to konec samplu
        mov   word ptr [di+ChOfs], bx           ;ulozime novou adresu dalsi vysilane
        mov   al, es:[bx]                       ;hodnoty a dame ji rovnou do  al
        mul   byte ptr [di+ChVolume]            ;fikanym zpusobem "vydelime" vysilanou
        add   dl,ah                             ;hodnotu na pozadovanou hlasitost
	jmp   NextChannel                       ;pricteme ji k mixovanemu vystupu
                                                ;a prejdeme na dalsi kanal
SampleEnd:                                      ;konec samplu v jednom kanalu
        mov   word ptr [di+ChSeg], 0            ;vypneme hrani v prislusnem kanalu
NextChannel:
	add   di,ChDelkaTab                     ;prechod na dalsi kanal
 	loop  StartLoop
	cmp   dl,0                              ;v  dl  je vysilana hodnota
	je    PlayerExit                        ;pokud je nulova, znamena to,
                                                ;ze vsechny kanaly mlci
	mov   ah,dl                             ;jinak ji vysleme a zahrajeme
	mov   al,ah
	mov   bx,word ptr cs:[jump]             ;skok na pozadovane vystupni
	jmp   bx                                ;zarizeni
Speak:
        mov   bx, offset tabul
        xlat
        out   42h, al
	jmp   PlayerExit

DAmono:
	mov   dx,word ptr cs:[port1]
	out   dx,al
	jmp   PlayerExit

Blast:
        mov   dx,word ptr cs:[BlasterPort]
        add   dx,0ch
	mov   al,10h                            ;oznamime Blastrovi, ze

;	mov   dx,22ch                           ;bude vyslana hodnota

	out   dx,al                             ;na DA prevodnik
;        xor cx,cx
;        mov word ptr cs:[ZdrzeniHi],cx          ;hodnoty Zdrzeni jsou
BlasterWait:
        in    al, dx                            ;pro ladeni, pocitaji mi,
;        inc cx                                  ;jak dlouho ceka Blastr
;        jnz ladeni_dal                          ;na odpoved
;        inc word ptr cs:[ZdrzeniHi]
;ladeni_dal:
	rcl   al, 1
	jc    BlasterWait
;        mov word ptr cs:[ZdrzeniLo],cx
	mov   al, ah
	out   dx,al
PlayerExit:
        retn

tabul:  db 64,64,64,64,64,64,64,64,64,64
         db 63,63,63,63,63,63,63,63,63,63,63,63
         db 62,62,62,62,62,62,62,62,62,62
         db 61,61,61,61,61,61,61,61,61
         db 60,60,60,60,60,60,60,60,60,60
         db 59,59,59,59,59,59,59,59,59,59
         db 58,58,58,58,58,58,58,58,58,58
         db 57,57,57,57,57,57,57,57,57,57
         db 56,56,56,56,56,56,56,56
         db 55,55,55,55,55,54,54,54,54
         db 53,53,53,53
         db 52,52,52,51,51,50,50,49
         db 49,48,48,47,46,45,44,43
         db 42,41,40,39,38,37,36,35
         db 34,33
tabul2:   db 32,31,30,29,28,27,26,25
         db 24,23,22,21,20,19,18,17
         db 17,16,16,15,15,14,14
         db 13,13,13,12,12,12,12,11,11,11,11,10,10,10,10,10,9,9,9,9
         db 9,9,9,9,9,8,8,8,8,8,8,8,8,8,8,8,8,7,7,7,7,7,7,7,6,6,6,6,6,6,6,6
         db 6,6,6,5,5,5,5,5,5,5,5,5,5,4,4,4,4,4,4,4,4,4,4,3,3,3,3,3,3,3,3,3
         db 3,2,2,2,2,2,2,2,2,2,1,1,1,1,1,1,1,1,1,1,1
Player endp

code    ends
        end