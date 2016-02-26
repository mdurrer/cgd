.286c

screen_size          equ     200             ;y-ovy rozmer obrazovky
buffer_length        equ     screen_size*2*2*4    ;length_ bufferu

model large,pascal

codeseg

extrn ActiveAddrPage:word
public FloodFill
public Circle
public Line
public XorLine





;filling uzavrenych oblasti, pro buffer pouziva lokalni promennou v SS
FloodFill proc far
          arg X:word,Y:word,with_what:byte,border:byte
          uses ds,es,si,di,ax,bx,cx,dx
          ;algoritmus + cx a dx v procedure zapis (cx i v init tady)
          local addrpage:word,buf:word:buffer_length
          ;lokalni variables na zasobniku

          mov       ax,ds:[ActiveAddrPage]      ;kreslici stranka (pamatovat,
          mov       addrpage,ax                   ;nebudeme znat ds)

          push      ss                          ;ds,es:=ss pro retez.instr.
          pop       ds                            ;(buffer a addrpage jsou
          push      ss                            ;totiz lok. prom. a jsou
          pop       es                            ;tedy na zasobniku)

          mov       si,bp                       ;inicializuj cteci a zapiso-
          sub       si,buffer_length                   ;vaci hlavu na zacatek
          mov       di,si                         ;bufferu
          cld                                   ;retezce jdou dopredu

          mov       ax,x                        ;nacte si ty 2 body
          mov       bx,y

          call      flood_write
          ;zapise bod na x=ax a y=bx s tim, ze zkontroluje
          ;barvu with_what a border a zapise to do pole jako dalsiho souseda

filling:
          cmp       si,bp                       ;osetri preteceni bufferu
          jne       didnt_overflow
          sub       si,buffer_length                 ;pretekl-li, na zacatek
didnt_overflow:

          cmp       si,di                       ;otestuj prazdnost bufferu
          je        end_of_filling                   ;ano, end_

          ;nacti 1. bod z bufferu
          lodsw                                 ;nacti y do bx
          mov       bx,ax
          lodsw                                 ;nacti x do ax

          ;nyni projdi jeho sousedy
          dec       bx                          ;horni soused
          cmp       bx,0
          jl        fill_top_side
          call      flood_write
fill_top_side:
          add       bx,2                        ;dolni soused
          cmp       bx,199
          jg        fill_bottom_side
          call      flood_write
fill_bottom_side:
          dec       bx                          ;left soused
          dec       ax
          cmp       ax,0
          jl        fill_left_side
          call      flood_write
fill_left_side:
          add       ax,2                        ;right soused
          cmp       ax,319
          jg        fill_right_side
          call      flood_write
fill_right_side:                                        ;opakuj cyklus
          jmp       short filling

end_of_filling:
          ret                                   ;sem se skoci pro end_
FloodFill endp

flood_write proc near
      ;souradnice bodu jsou x=ax a y=bx
      ;zkontroluje, zda tam neni color vyplne nebo border a pokud ne,
      ;vyplni to barvou vyplne a zaradi na end_ bufferu
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

          mov       dx,cx                       ;pridej char_ k offsetu
          shr       dx,2
          add       si,dx

          and       cl,3                        ;vezmi number_ stranky

          ;cteni znaku podle nastavenych portu
          mov       ah,cl                       ;pozadavek prepnuti stranky
          mov       dx,3CEh                       ;pro cteni
          mov       al,4
          out       dx,al
          inc       dx                          ;kterou stranku
          mov       al,ah
          out       dx,al

          mov       al,byte ptr es:[si]         ;nacteni bodu

          cmp       al,with_what                      ;je-li shodny s barvou
          je        didnt_succeed                      ;vyplne nebo border,
          cmp       al,border                    ;end_
          je        didnt_succeed

          ;nyni musime vykreslit na obrazovku novy bod
          mov       ah,1                        ;pozadavek prepnuti stranky
          shl       ah,cl                         ;pro zapis
          mov       dx,3C4h
          mov       al,2
          out       dx,al

          inc       dx                          ;ktera stranka
          mov       al,ah
          out       dx,al

          mov       al,with_what                      ;vypis novy bod
          mov       byte ptr es:[si],al

          ;nyni pouze zkontrolujeme, zda uz posunuta zapisova hlava bufferu
          ;nepretekla pres end_
          cmp       di,bp                       ;osetri preteceni bufferu
          jne       end_of_writing
          sub       di,buffer_length                 ;pretekl-li, na zacatek
          jmp       short end_of_writing

didnt_succeed:                                       ;je-li didnt_succeed, nezapise se
          sub       di,4                          ;nic, vrat zapis. hlavu

end_of_writing:
          ret
flood_write endp





;circle celociselnym algoritmem Martina Marese (opsano z knizky od Grady :
;Grafika - principy a algoritmy z jejich doprovodne diskety)
Circle proc far
     arg X:word,Y:word,R:word, color:byte
          uses ax,bx,cx,dx,si,es

          mov       ax,0A000h           ;es=segment VRAM
          mov       es,ax

          mov       ax,0
          mov       bx,r
          mov       si,1
          sub       si,bx
          mov       cx,3
          mov       dx,bx
          shl       dx,1
          sub       dx,2
_repeat:
          call      circle_draw_symmetric_points
          cmp       si,0
          jl        y_didnt_decrease
          sub       si,dx
          sub       dx,2
          dec       bx
y_didnt_decrease:
          add       si,cx
          add       cx,2
          inc       ax

          cmp       ax,bx
          jle       _repeat

          ret
Circle endp

circle_draw_symmetric_points proc near
;          uses cx,dx
          push cx
          push dx
          mov       cx,x
          mov       dx,y

          add       cx,ax
          add       dx,bx
          call      circle_draw_point

          sub       cx,ax
          sub       cx,ax
          call      circle_draw_point
          add       cx,ax
          add       cx,ax
          sub       dx,bx
          sub       dx,bx
          call      circle_draw_point
          sub       cx,ax
          sub       cx,ax
          call      circle_draw_point

          add       cx,ax
          add       dx,bx

          add       cx,bx
          add       dx,ax
          call      circle_draw_point

          sub       cx,bx
          sub       cx,bx
          call      circle_draw_point
          add       cx,bx
          add       cx,bx
          sub       dx,ax
          sub       dx,ax
          call      circle_draw_point
          sub       cx,bx
          sub       cx,bx
          call      circle_draw_point

          pop dx
          pop cx
          retn
circle_draw_symmetric_points endp

circle_draw_point proc near
         ;souradnice v cx a dx
          uses ax,bx,cx,dx,si

          ;nezmenena rutina z line (ona to taky bere z cx,dx a nici a-dx+si)
          mov       si,ds:ActiveAddrPage;dej offset VRAM

          mov       ax,80               ;ktery radek
          mul       dx
          add       si,ax
          mov       dx,cx               ;zachovej sloupec
          shr       dx,2
          add       si,dx               ;pridej sloupec k offsetu

          and       cl,3                ;vezmi number_ stranky ze sloupce
          mov       ah,1                ;pozadavek prepnuti stranky
          shl       ah,cl                 ;pro zapis
          mov       dx,3C4h
          mov       al,2
          out       dx,al
          inc       dx                  ;ktera stranka
          mov       al,ah
          out       dx,al

          mov       al,color            ;vypis konecne bod cary
          mov       es:[si],al

          ret
circle_draw_point endp





;kresleni usecky mnou vylepsenym algoritmem, ktery skoro bez IFu zvladne
;pomoci 1 slozeneho cyklu vsechny kvadranty pro uhly <,=,>45 stupnu
;je to linearni celociselny vzorkovaci algoritmus
Line proc far
     arg X1:word,Y1:word,X2:word,Y2:word, color:byte
          uses ax,bx,cx,dx,si,di,es

          mov       ax,0A000h           ;es=segment VRAM
          mov       es,ax

          mov       ax,x2               ;ax=abs(x2-x1) a dl=smerx
          sub       ax,x1
          jge       vetsi1
          mov       dl,0
          neg       ax
          jmp       short _1
vetsi1:
          mov       dl,1
_1:

          mov       bx,y2               ;bx=abs(y2-y1) a dh=smery
          sub       bx,y1
          jge       vetsi2
          mov       dh,0
          neg       bx
          jmp       short _2
vetsi2:
          mov       dh,1
_2:

          xor       si,si               ;pocitadlo position x=si=i a y=di=j
          xor       di,di

          xor       cx,cx               ;cx=pocitadlo preteceni

cyklus:                                 ;for j:=0 to y
          add       cx,ax               ;inc(poc,x)
          call      line_draw_point        ;putpixel(x1+i*smerx,y1+j*smery,color)
          cmp       cx,bx               ;if poc>=y
          jl        dalsi               ;ne - nic
                                        ;ano - pokracuj
          sub       cx,bx               ;dec(poc,y)
          inc       si                  ;inc(i)
_while:                                 ;while (poc>=y)and(i<=x)
          cmp       cx,bx               ;poc<y ===> end_
          jl        dalsi
          cmp       si,ax               ;i>x   ===> end_
          jg        dalsi
          call      line_draw_point        ;putpixel(x1+i*smerx,y1+j*smery,color)
          sub       cx,bx               ;dec(poc,y)
          inc       si                  ;inc(i)
          jmp       short _while        ;===> while

dalsi:
          inc       di                  ;for : zvys j
          cmp       di,bx               ;for : otestuj horni mez
          jle       cyklus              ;ano, jeste jednou

          ret                           ;jinak end_
Line endp

line_draw_point proc near
          ;putpixel(x1+i*smerx,y1+j*smery,color)
          uses ax,bx,cx,dx,si

          cmp       dl,1                ;smerx=1 ?
          je        _sx1
          mov       cx,si               ;-1 ===> odecist
          neg       cx
          jmp short _sx
_sx1:
          mov       cx,si               ;1  ===> pricist
_sx:
          add       cx,x1               ;pridat x1

          cmp       dh,1                ;smerx=1 ?
          je        _sy1
          mov       dx,di               ;-1 ===> odecist
          neg       dx
          jmp short _sy
_sy1:
          mov       dx,di               ;1  ===> pricist
_sy:
          add       dx,y1               ;pridat y1

          mov       si,ds:ActiveAddrPage;dej offset VRAM

          mov       ax,80               ;ktery radek
          mul       dx
          add       si,ax
          mov       dx,cx               ;zachovej sloupec
          shr       dx,2
          add       si,dx               ;pridej sloupec k offsetu

          and       cl,3                ;vezmi number_ stranky ze sloupce
          mov       ah,1                ;pozadavek prepnuti stranky
          shl       ah,cl                 ;pro zapis
          mov       dx,3C4h
          mov       al,2
          out       dx,al
          inc       dx                  ;ktera stranka
          mov       al,ah
          out       dx,al
;tady to dela na obrazovce v bp pri debugovani zahadne krasne veci !!!!!
          mov       al,color            ;vypis konecne bod cary
          mov       byte ptr es:[si],al

          ret                           ;vse zmenene se POPne
line_draw_point endp





;naprosto stejna procedura, lisi se pouze vystup bodu a v teto procedure
;volani jine procedury (onen vystup bodu) + odstraneny prazdne radky atp...
XorLine proc far
     arg X1:word,Y1:word,X2:word,Y2:word, color:byte
          uses ax,bx,cx,dx,si,di,es
          mov       ax,0A000h           ;es=segment VRAM
          mov       es,ax
          mov       ax,x2               ;ax=abs(x2-x1) a dl=smerx
          sub       ax,x1
          jge       v1
          mov       dl,0
          neg       ax
          jmp       short __1
v1:
          mov       dl,1
__1:
          mov       bx,y2               ;bx=abs(y2-y1) a dh=smery
          sub       bx,y1
          jge       v2
          mov       dh,0
          neg       bx
          jmp       short __2
v2:
          mov       dh,1
__2:
          xor       si,si               ;pocitadlo position x=si=i a y=di=j
          xor       di,di
          xor       cx,cx               ;cx=pocitadlo preteceni
cykl:                                   ;for j:=0 to y
          add       cx,ax               ;inc(poc,x)
          call      xorline_draw_point     ;putpixel(x1+i*smerx,y1+j*smery,color)
          cmp       cx,bx               ;if poc>=y
          jl        dal                 ;ne - nic, ano - pokracuj
          sub       cx,bx               ;dec(poc,y)
          inc       si                  ;inc(i)
__while:                                ;while (poc>=y)and(i<=x)
          cmp       cx,bx               ;poc<y ===> end_
          jl        dal
          cmp       si,ax               ;i>x   ===> end_
          jg        dal
          call      xorline_draw_point     ;putpixel(x1+i*smerx,y1+j*smery,color)
          sub       cx,bx               ;dec(poc,y)
          inc       si                  ;inc(i)
          jmp       short __while       ;===> while
dal:
          inc       di                  ;for : zvys j
          cmp       di,bx               ;for : otestuj horni mez
          jle       cykl                ;ano, jeste jednou
          ret                           ;jinak end_
XorLine endp

xorline_draw_point proc near
          uses ax,bx,cx,dx,si
          cmp       dl,1                ;smerx=1 ?
          je        __sx1
          mov       cx,si               ;-1 ===> odecist
          neg       cx
          jmp short __sx
__sx1:
          mov       cx,si               ;1  ===> pricist
__sx:
          add       cx,x1               ;pridat x1
          cmp       dh,1                ;smerx=1 ?
          je        __sy1
          mov       dx,di               ;-1 ===> odecist
          neg       dx
          jmp short __sy
__sy1:
          mov       dx,di               ;1  ===> pricist
__sy:
          add       dx,y1               ;pridat y1

          mov       si,ds:ActiveAddrPage;dej offset VRAM
          mov       ax,80               ;ktery radek
          mul       dx
          add       si,ax
          mov       dx,cx               ;zachovej sloupec
          shr       dx,2
          add       si,dx               ;pridej sloupec k offsetu

          and       cl,3                ;vezmi number_ stranky ze sloupce
          mov       ah,1                ;pozadavek prepnuti stranky
          shl       ah,cl                 ;pro zapis
          mov       dx,3C4h
          mov       al,2
          out       dx,al
          inc       dx                  ;ktera stranka
          mov       al,ah
          out       dx,al
          mov       dx,3CEh
          mov       al,4
          out       dx,ax
          inc       dx
          mov       al,cl
          out       dx,al

          mov       al, byte ptr es:[si] ;vyxoruj bod
          xor       al, color
          mov       byte ptr es:[si], al

          ret
xorline_draw_point endp





end
