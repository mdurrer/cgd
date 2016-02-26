.286c

model large,pascal
;musí být model large a nesmí být uvedeno far
;v pascalu však far být uveden může i nemusí

codeseg

extrn ActiveAddrPage:word
public PutImageMaskMirrorZoomPart
public TestImageMaskMirrorZoom
public readsmallscreen
public remap_palette
public color2gray
public palette_change
       ;init a done se kvůli getmem a freemem musí dělat mimo

PutImageMaskMirrorZoomPart proc pascal
	;píča TASM! arg asi nesmí být na 2 řádky!
        arg x,y,img:word:2,mask_color:byte,is_mask:byte,mirror:byte, zdx,zdy, px1,py1,px2,py2
        ;vše je integer, vyjímečně byte!
        local ox1,oy1,oy2,predx,predy,izpet,iprechod,sy,ozpet,odx,ody,vbit:byte
;        local ox1,oy1,oy2               ;souřadnice začátku/konce v img.
;        local predx,predy               ;predikce x a uchování predikce y
;        local izpet,iprechod,sy,ozpet   ;diference při různých podmínkách
;        local odx,ody                   ;si bude ukazovat jinam...
;              ;iofs a oofs jsou si a di
;              ;ox a oy budou cx
;        local vbit:byte                 ;zpracovávaná videostránka
;              ;b pixel bude v al...
;              ;vram bude v es

        pusha            ;uložíme všechny registry
        push ds es

        mov ax,px1       ;šířka ---> souřadnice
        dec ax
        add px2,ax
        mov ax,py1
        dec ax
        add py2,ax

        mov ax,x         ;ořezání partu na přesný obrázek
        cmp px1,ax
        jnl _neorezvlevo
        mov px1,ax
_neorezvlevo:
        mov ax,y
        cmp py1,ax
        jnl _neoreznahore
        mov py1,ax
_neoreznahore:
        mov ax,x
        add ax,zdx
        dec ax
        cmp px2,ax
        jng _neorezvpravo
        mov px2,ax
_neorezvpravo:
        mov ax,y
        add ax,zdy
        dec ax
        cmp py2,ax
        jng _neorezdole
        mov py2,ax
_neorezdole:
        mov ax,px1              ;kontrola partu
        cmp px2,ax
        jnl _nekonec1
_konec1:
        jmp _konec
_nekonec1:
        mov ax,py1
        cmp py2,ax
        jl _konec1

        mov ax,0a000h           ;výstup do videoram
        mov es,ax
        mov di,ds:word ptr activeaddrpage
        mov ds,ss:word ptr img+2   ;vstup z obrázku
        mov si,ss:word ptr img  ;nastav délku a šířku obrázku
        lodsw
        mov odx,ax
        lodsw
        mov ody,ax              ;nyní je offset posunut o 4

        mov ax,px1              ;zjištění poč. souř. a predikce
        sub ax,x
        imul odx
        idiv zdx
        mov ox1,ax              ;poč. souř x
        mov predx,dx            ;predikce x
        mov ax,py1
        sub ax,y
        imul ody
        idiv zdy
        mov oy1,ax              ;poč. souř y
        mov predy,dx            ;predikce y
        mov ax,py2
        sub ax,y
        imul ody
        idiv zdy
        mov oy2,ax              ;konc. souř y

        mov ax,ody
        test mirror,1           ;zrcadlení podle osy x?
        jz _nezrcadlix
        neg ax                  ;nastaví iprechod
        mov iprechod,ax
        mov ax,ox1              ;převrátí začátek
        neg ax
        dec ax
        add ax,odx
        mov ox1,ax
        jmp short _ponezrcadlenix
_nezrcadlix:
        mov iprechod,ax
_ponezrcadlenix:
        test mirror,2           ;zrcadlení podle osy y?
        jz _nezrcadliy
        mov sy,-1
        mov ax,oy1              ;převrátí začátek
        neg ax
        dec ax
        add ax,ody
        mov oy1,ax
        mov ax,oy2              ;převrátí end_
        neg ax
        dec ax
        add ax,ody
        mov oy2,ax
        jmp short _ponezrcadleniy
_nezrcadliy:
        mov sy,1
_ponezrcadleniy:

        mov ax,px1              ;zpátky souřadnice na šířku
        dec ax
        sub px2,ax
        mov ax,py1
        dec ax
        sub py2,ax
        mov ax,oy1              ;nastaví čtecí index vracení se
        sub ax,oy2
        mov izpet,ax
        mov ax,80               ;nastaví zápisový index vracení se
        mov bx,py2
        neg bx
        inc bx
        mul bx
        mov ozpet,ax

        ;si a di je nastaveno na počátek struktur, nyní už je jenom posuneme
        mov ax,ox1              ;výpočet čtecí adresy
        mul ody
        add ax,oy1
        add si,ax
        mov ax,80               ;výpočet zápisové adresy
        mul py1
        mov bx,px1
        shr bx,2
        add ax,bx
        add di,ax

        mov ax,px1              ;nastavení bitové roviny
        and al,3
        mov vbit,al
        mov cx,px2              ;nastavení počítadla sloupců

        ;dáme tento loop, protože máme jistotu, že aspoň jednou proběhne
        ;u počítadla řádků je cyklus s podmínkou uprostřed
_dalsisloupec:                  ;zde začíná vnější cyklus podle X
        push cx                 ;ulož si počítadlo sloupců

        mov cl,vbit             ;nastavení dané bitové roviny
        mov ah,1
        shl ah,cl
        mov dx,3c4h
        mov al,2
        out dx,al
        inc dx
        mov al,ah
        out dx,al

        mov bx,predy            ;nastavení staré predikce
        mov cx,py2              ;nastavení počítadla řádků

_dalsiradek:                    ;zde začíná vnitřní cyklus podle y
        mov al,byte ptr ds:[si] ;načtení bodu
        cmp al,byte ptr mask_color   ;porovnat barvy
        jne _zapisbodu
        mov al,byte ptr is_mask ;stejné ---> zjistit, zda se má brát mask_color
        or al,al
        jnz _nezapisbodu
_zapisbodu:
        mov byte ptr es:[di],al ;zápis do videoram
_nezapisbodu:

        dec cx                  ;zapsali jsme již celý sloupec?
        jz _konecsloupce
        add di,80d              ;přidej řádek do videoram

        add bx,ody              ;provedeme lineární algoritmus
_preskocdalsiradek:
        cmp bx,zdy              ;dá se ještě přeskočit?
        jl _dalsiradek          ;ne ---> provedeme další průchod cyklem
        sub bx,zdy              ;ano ---> odečti a zkus znovu
        add si,sy
        jmp short _preskocdalsiradek

_konecsloupce:
        add si,izpet            ;zpátky na začátek sloupce
        mov ax,predx            ;provedeme lineární algoritmus
        add ax,odx
_preskocdalsisloupec:
        cmp ax,zdx              ;dá se ještě přeskočit?
        jl _nepreskocdalsisloupec
        sub ax,zdx
        add si,iprechod
        jmp short _preskocdalsisloupec

_nepreskocdalsisloupec:
        mov predx,ax            ;zaznamenáme zpět predikci
        add di,ozpet            ;skočíme ve videoram zpět po sloupci
        inc vbit
        cmp vbit,4              ;podívej se na bitové roviny
        jne _nerolujbitplan
        mov vbit,0
        inc di
_nerolujbitplan:
        pop cx                  ;obnovíme staré počítadlo
        loop _dalsisloupec      ;možná skoč na další sloupec

_konec:
        ;se zásobníkem se pracuje jen v 1 místě na uchování počítadla x
        ;jinak jsme celkem nic neprovedli, klidně se můžeme ukončit
        pop es ds
        popa
        ret

PutImageMaskMirrorZoomPart endp

TestImageMaskMirrorZoom proc pascal
        arg x,y,img:word:2,mask_color:byte,mirror:byte, zdx,zdy, px,py

        push ds si bx cx dx

        mov si,ss:word ptr img
        mov ds,ss:word ptr img+2

        xor al,al                     ;není tam obrázek
        mov bx,x                      ;kontrola výřezu x
        cmp px,bx
        jl konec_testu
        add bx,zdx
        cmp px,bx
        jge konec_testu
        mov bx,y                      ;kontrola výřezu y
        cmp py,bx
        jl konec_testu
        add bx,zdy
        cmp py,bx
        jge konec_testu

        mov ax,py                     ;výpočet souřadnice v obrázku (Y)
        sub ax,y
        imul word ptr ds:[si+2]
        idiv zdy
        mov cx,ax                     ;uložit
        mov ax,px                     ;výpočet souřadnice v obrázku (X)
        sub ax,x
        imul word ptr ds:[si]
        idiv zdx

        test mirror,1                 ;převrátit, je-li zrcadlo X
        jz nezrcadli_testx
        neg ax
        add ax,word ptr ds:[si]
        dec ax
nezrcadli_testx:
        test mirror,2                 ;převrátit, je-li zrcadlo Y
        jz nezrcadli_testy
        neg cx
        add cx,word ptr ds:[si+2]
        dec cx
nezrcadli_testy:

        mul word ptr ds:[si+2]        ;výpočet offsetu
        add ax,cx
        add ax,4
        mov bx,ax

        xor al,al
        mov ah,byte ptr ds:[si+bx]    ;porovnáme část obrázku
        cmp ah,mask_color
        je konec_testu
        mov al,1

konec_testu:
        pop dx cx bx si ds
        ret
TestImageMaskMirrorZoom endp

readsmallscreen proc
                arg img:dataptr

                push ds es si di ax bx cx dx

                mov di,ss:word ptr img
                mov es,ss:word ptr img+2
                mov ax,80                       ;savne souřadnice obrázku
                stosw
                mov ax,50
                stosw

                mov ax,0a000h
                mov ds,ax
                xor si,si

                mov ax,4                ;přepne do 0. bitové roviny
                mov dx,3ceh
                out dx,al
                inc dx
                mov al,ah
                out dx,al

                mov cx,80d              ;počet sloupců
readsmall_sloupec:
                mov dx,cx
                mov cx,50d              ;počet řádků
readsmall_znak:
                movsb
                add si,4*80-1
                loop readsmall_znak     ;zkopíruj všechno
                mov cx,dx
                add si,-200*80+1        ;další sloupec
                loop readsmall_sloupec

                pop dx cx bx ax di si es ds

                ret
readsmallscreen endp

R db 102                        ;empirické násobné hodnoty
G db 90                         ;načíst z literatury!!!!!
B db 63
Delit db 255                    ;ne 256, aby tam bylo 0..255 <===> 0..1

Conv db 256 dup (1)             ;-)

remap_palette  proc
          arg pal:dataptr

          push es ds si di ax cx dx

          mov si,ss:word ptr pal
          mov ds,ss:word ptr pal+2
          mov di,si
          push ds
          pop es
          mov cx,256
remap1barvy:
          lodsb                         ;R
          mul cs:byte ptr R
          div cs:byte ptr Delit
          mov dl,al
          lodsb                         ;G
          mul cs:byte ptr G
          div cs:byte ptr Delit
          add dl,al
          lodsb                         ;B
          mul cs:byte ptr B
          div cs:byte ptr Delit
          add al,dl

          stosb                         ;ulož odstín 0..255
          stosb
          stosb
          loop remap1barvy

          pop dx cx ax di si ds es

          ret
remap_palette endp

color2gray proc
          arg img:dataptr, pal:dataptr

          push ds es si di ax bx cx dx

          mov si,ss:word ptr pal
          mov ds,ss:word ptr pal+2
          mov di,offset Conv
          push cs
          pop es
          mov cx,256
konv1barvy:
          lodsb                         ;R
          mul cs:byte ptr R
          div cs:byte ptr Delit
          mov dl,al
          lodsb                         ;G
          mul cs:byte ptr G
          div cs:byte ptr Delit
          add dl,al
          lodsb                         ;B
          mul cs:byte ptr B
          div cs:byte ptr Delit
          add al,dl

          stosb                         ;ulož si odstín 0..255
          loop konv1barvy
          mov di,offset conv

          mov si,ss:word ptr img
          mov ds,ss:word ptr img+2
          lodsw                         ;výpočet, kolik je to bytes
          mov bx,ax
          lodsw
          mul bx
          mov cx,ax

          xor bh,bh
dalsibod:
          lodsb                 ;čti barvu
          mov bl,al             ;převeď na index odstínu šedi
          mov al,byte ptr es:[di+bx]    ;převeď na odstín
          mov byte ptr ds:[si-1],al     ;savni
          loop dalsibod

          pop dx cx bx ax di si es ds

          ret
color2gray endp

palette_change proc
                arg pal:dataptr,num_phases,dif:dataptr,pred:dataptr
                ;pal1/2 je ukazatel na pole bytes
                ;dif/pred je ukazatel na pole integeru

                push ds es si di ax bx cx dx

                mov si,ss:word ptr dif
                mov ds,ss:word ptr dif+2
                mov di,ss:word ptr pred
                mov es,ss:word ptr pred+2

                mov cx,768
                xor bx,bx
zmena1slozky:
                mov dx,word ptr ds:[si+bx]    ;vezmi diferenci
                mov ax,word ptr es:[di+bx]    ;vezmi predikci
                push es di                    ;vezmi paletu
                mov di,ss:word ptr pal
                mov es,ss:word ptr pal+2
                shr bx,1
                add di,bx
                shl bx,1
                cmp dx,0
                js zaporna_diference

                add ax,dx                     ;přičti diferenci
posunslozkynahoru:
                cmp ax,ss:word ptr num_phases
                jl konecposunu
                inc byte ptr es:[di]
                sub ax,ss:word ptr num_phases
                jmp posunslozkynahoru

zaporna_diference:
                sub ax,dx                     ;odečti diferenci
posunslozkydolu:
                cmp ax,ss:word ptr num_phases
                jl konecposunu
                dec byte ptr es:[di]
                sub ax,ss:word ptr num_phases
                jmp posunslozkydolu

konecposunu:
                pop di es                     ;obnov predikci
                mov es:word ptr [di+bx],ax    ;ulož její novou hodnotu
                add bx,2
                loop zmena1slozky

                pop dx cx bx ax di si es ds

                ret
palette_change endp

end
