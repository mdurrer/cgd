.286c

delkay          equ     400             ;y-ovy rozmer obrazovky
delkabuf        equ     delkay*2*2*2    ;delka bufferu

model small,pascal

codeseg

extrn ActiveAddrPage:word
public chuze

;vyplnovani uzavrenych oblasti, pro buffer pouziva lokalni promennou v SS
chuze proc
          arg X1:word,Y1:word,x2:word,y2:word;pocet:word ptr,pole:word ptr
          uses ds,es,si,di,ax,bx,cx,dx
          local addrpage:word,buf:word:delkabuf

          mov       ax,ds:[ActiveAddrPage]      ;kreslici stranka (pamatovat,
          mov       addrpage,ax                   ;nebudeme znat ds)

          push      ss                          ;ds,es:=ss pro retez.instr.
          pop       ds                            ;(buffer a addrpage jsou
          push      ss                            ;totiz lok. prom. a jsou
          pop       es                            ;tedy na zasobniku)

          mov       si,bp                       ;inicializuj cteci a zapiso-
          sub       si,delkabuf                   ;vaci hlavu na zacatek
          mov       di,si                         ;bufferu
          cld                                   ;retezce jdou dopredu

          mov       ax,x1                       ;nacte si ty 2 body
          mov       bx,y1

          call zapis
          ;zapise bod na x=ax a y=bx s tim, ze zkontroluje
          ;barvu cim a hranice a zapise to do pole jako dalsiho souseda

vyplnovani:
          cmp       si,di                       ;otestuj prazdnost bufferu
          je        konecvyplne                   ;ano, konec

          ;nacti 1. bod z bufferu
          cmp       si,bp                       ;osetri preteceni bufferu
          jne       nepretekl
          sub       si,delkabuf                 ;pretekl-li, na zacatek
nepretekl:
          lodsw                                 ;nacti y do bx
          mov       bx,ax
          lodsw                                 ;nacti x do ax

          ;nyni projdi jeho sousedy
          dec       bx                          ;horni soused
          cmp       bx,0
          jl        hornkon
          call      zapis
hornkon:
          add       bx,2                        ;dolni soused
          cmp       bx,199
          jg        dolnkon
          call      zapis
dolnkon:
          dec       bx                          ;levy soused
          dec       ax
          cmp       ax,0
          jl        levykon
          call      zapis
levykon:
          add       ax,2                        ;pravy soused
          cmp       ax,319
          jg        pravkon
          call      zapis
pravkon:                                        ;opakuj cyklus
          jmp       short vyplnovani

konecvyplne:
          ret                                   ;sem se skoci pro konec
chuze endp

zapis proc near
      ;souradnice bodu jsou x=ax a y=bx
      ;zkontroluje, zda tam neni brava vyplne nebo hranice a pokud ne,
      ;vyplni to barvou vyplne a zaradi na konec bufferu
          uses es,si,ax,bx
               ;es - segment retezce, zde adresara VideoRam
               ;si - cteci hlava bufferu, zde pro vypocet adresy

          stosw                                 ;ulozi x tam, kde ma byt y
          stosw                                 ;ulozi x spravne
          mov       es:[di-4],bx                ;ulozi y spravne
          ;predpokladam, ze se to podari a zapisu pozici do bufferu ihned,
          ;protoze se mi souradnice casem z registru ztrati

          mov       cx,ax                       ;uchovej pozici x
          mov       ax,0A000h                   ;segment VRAM
          mov       es,ax

          mov       si,addrpage                 ;dej offset VRAM

          mov       ax,80                       ;ktery radek
          mul       bx
          add       si,ax

          mov       dx,cx                       ;pridej znak k offsetu
          shr       dx,2
          add       si,dx

          and       cl,3                        ;vezmi cislo stranky

          ;cteni znaku podle nastavenych portu
          mov       ah,cl                       ;pozadavek prepnuti stranky
          mov       dx,3CEh                       ;pro cteni
          mov       al,4
          out       dx,al
          inc       dx                          ;kterou stranku
          mov       al,ah
          out       dx,al

          mov       al,byte ptr es:[si]         ;nacteni bodu

          cmp       al,3                        ;je-li shodny s barvou
          je        neuspech                      ;vyplne nebo hranice,
          cmp       al,7                        ;konec
          je        neuspech

          ;nyni musime vykreslit na obrazovku novy bod
          mov       ah,1                        ;pozadavek prepnuti stranky
          shl       ah,cl                         ;pro zapis
          mov       dx,3C4h
          mov       al,2
          out       dx,al

          inc       dx                          ;ktera stranka
          mov       al,ah
          out       dx,al

          mov       al,3                        ;vypis novy bod
          mov       byte ptr es:[si],al

          ;nyni pouze zkontrolujeme, zda uz posunuta zapisova hlava bufferu
          ;nepretekla pres konec
          cmp       di,bp                       ;osetri preteceni bufferu
          jne       koneczapisu
          sub       di,delkabuf                 ;pretekl-li, na zacatek
          jmp       short koneczapisu

neuspech:                                       ;je-li neuspech, nezapise se
          sub       di,4                          ;nic, vrat zapis. hlavu

koneczapisu:
          ret
zapis endp

end
