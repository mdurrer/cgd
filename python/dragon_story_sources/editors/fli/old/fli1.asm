.286c

model small,pascal

public initgraph, closegraph
public fce_clear
public fce_putimage
public fce_putcompimage
public fce_changeimage
public fce_palette
public otevriflisoubor
public vykresli1snimek
public zavriflisoubor

;public flihlavicka

.code

initgraph proc far
          mov ax,0013h
          int 10h
          ret
initgraph endp

closegraph proc far
          mov ax,0003h
          int 10h
          ret
closegraph endp

fce_clear proc far
          arg s,v

          push es di ax cx dx

          mov ax,0a000h
          mov es,ax
          xor di,di
          cld

          mov cx,ss:word ptr v
clear1radek:
          mov dx,cx
          mov cx,ss:word ptr s
          rep stosb
          sub di,ss:word ptr s       ;posuň se na další řádek
          add di,320d
          mov cx,dx
          loop clear1radek

          pop dx cx ax di es

          ret
fce_clear endp

fce_putimage proc far
             arg s,v,obr:word:2

             push ds es si di ax cx dx

             mov si,ss:word ptr obr
             mov ds,ss:word ptr obr+2
             mov ax,0a000h
             mov es,ax
             xor di,di
             cld

             mov cx,ss:word ptr v
put1radek:
             mov dx,cx
             mov cx,ss:word ptr s
             rep movsb
             sub di,ss:word ptr s       ;posuň se na další řádek
             add di,320d
             mov cx,dx
             loop put1radek

             pop dx cx ax di si es ds

             ret
fce_putimage endp

fce_putcompimage proc far
             arg s,v,obr:word:2

             push ds es si di ax bx cx

             mov si,ss:word ptr obr
             mov ds,ss:word ptr obr+2
             mov ax,0a000h
             mov es,ax
             xor di,di
             cld

             mov bx,320d                ;nastaví parametry putování
             sub bx,ss:word ptr s
             mov cx,ss:word ptr v       ;řádky

             ;každý řádek je komprimován zvlášť!
             xor ah,ah
putc1radek:
             lodsb
             push cx                    ;ulož řádky, dej pakety
             mov cx,ax
putc1paket:
             push cx                    ;ulož pakety, dej body
             lodsb
             mov cx,ax
             test al,80h
             jz putc_opakovane
             mov ch,0ffh
             neg cx
;             and cl,7fh
             rep movsb                  ;ulož řetězec
             jmp short putc_popaketu
putc_opakovane:
             lodsb
             rep stosb                  ;ulož 1 hodnotu
putc_popaketu:
             pop cx                     ;obnov paket
             loop putc1paket
             pop cx                     ;obnov řádky
             add di,bx                  ;přesuň se na další řádek
             loop putc1radek

             pop cx bx ax di si es ds

             ret
fce_putcompimage endp

fce_changeimage proc far
                arg s,v,obr:word:2

                push ds es si di ax bx cx dx

                mov si,ss:word ptr obr
                mov ds,ss:word ptr obr+2
                mov ax,0a000h
                mov es,ax
                cld

                lodsw                           ;první řádek
                mov bx,320
                mul bx
                mov di,ax                       ;adresa začátku
                lodsw                           ;počet řádků
                mov cx,ax

                xor ah,ah
chg1radek:
                push di                         ;ulož začátek
                lodsb
                push cx                         ;ulož řádky, dej pakety
                mov cx,ax
chg1paket:
                or cx,cx                        ;může být i 0 paketů...
                jz chg_konecradku
                dec cx
                lodsb                           ;x-posunutí
                add di,ax
                push cx                         ;ulož pakety, dej body
                lodsb
                mov cx,ax
                test al,80h
                jnz chg_opakovane               ;zde je to opačně!
                rep movsb                       ;ulož řetězec
                jmp short chg_popaketu
chg_opakovane:
                mov ch,0ffh
                neg cx
;                and cl,7fh
                lodsb
                rep stosb                  ;ulož 1 hodnotu
chg_popaketu:
                pop cx                     ;obnov paket
                jmp short chg1paket
chg_konecradku:
                pop cx                     ;obnov řádky
                pop di                     ;posuň se na další řádek
                add di,320
                loop chg1radek

                pop dx cx bx ax di si es ds

                ret
fce_changeimage endp

fce_palette proc far                    ;nastaví paletu obrázku
            arg pal:word:2

            push ds si ax cx dx

            mov si,ss:word ptr pal
            mov ds,ss:word ptr pal+2
            cld

            xor ah,ah
            lodsb                       ;počet paketů
            mov cx,ax
pal1paket:
            push cx                     ;ulož paket, dej počet barev
            lodsb              ;začátek
            mov dx,3c8h        ;adresování data registru
            out dx,al
            inc dx
            lodsb
            mov cx,ax           ;počet bajtů
            add cx,ax
            add cx,ax
            or al,al            ;0?
            jnz pal_ne_256
            mov cx,3*256        ;256!
pal_ne_256:
            rep outsb           ;poslání všech dat
            pop cx
            loop pal1paket

            pop dx cx ax si ds

            ret
fce_palette endp

;************************************************************************

otevriflisoubor proc far
                arg jmeno:byte:256
                uses ax, bx, cx, dx, si

                xor bh,bh                       ;ukonči řetězec nulou
                mov bl,byte ptr ss:jmeno
                mov si,bx
                mov byte ptr ss:[jmeno+si+1],bh

                push ds
                mov ax,3d00h                    ;otevři handle
                push ss
                pop ds
                mov dx,offset jmeno+1
                int 21h
                pop ds
                jc chybaprifliotevreni          ;v ax je chyba

                mov word ptr cs:flisoubor,ax    ;handle, jsme na začátku

                mov bx,ax
                mov ah,3fh                      ;načteme hlavičku
                mov cx,128d
                mov dx,offset flihlavicka
                int 21h
                jc chybapriflicteni
                cmp ax,128
                jne chybapriflicteni

                cmp ds:flihlavicka.magic,0af11h ;kontrola hlavičky
                jne chybapriflicteni
                cmp byte ptr ds:flihlavicka.depth,8
                jne chybapriflicteni
                cmp ds:flihlavicka.fwidth,320
                ja chybapriflicteni
                cmp ds:flihlavicka.fheigth,200
                ja chybapriflicteni
                mov cx,ds:flihlavicka.frames
                cmp cx,mojemaxsnimku
                jng flictiindexy
chybapriflicteni:
                mov ah,3eh                      ;zavři soubor
                int 21h
                mov ax,1                        ;obecně chyba
chybaprifliotevreni:
                ret                             ;ax už je nastaveno

flictiindexy:
                mov word ptr ds:flihlavicka.index,128   ;1. snímek má pozici 128
                mov word ptr ds:flihlavicka.index+2,0
                mov si,offset flihlavicka.index+4       ;budeme číst do této struktury
flipozice1snimku:
                push cx
                push dx
                mov ah,3fh                      ;načti další snímek
                ;bx, ds jsou nastaveny
                mov dx,si
                mov cx,4
                int 21h
                jc chybapriflicteni
                cmp ax,4
                jne chybapriflicteni

                lodsw                           ;co jsme to načetli?
                mov dx,ax
                lodsw
                mov cx,ax
                add dx, word ptr ds:[si-8]      ;přičteme minulou pozici
                adc cx, word ptr ds:[si-6]
                mov word ptr ds:[si-4],dx       ;zapíšeme na místo
                mov word ptr ds:[si-2],cx

                mov ax,4200h                    ;seek na danou pozici
                int 21h
                jc chybapriflicteni
                pop dx
                pop cx
                loop flipozice1snimku           ;přečti další snímek

                xor ax,ax                       ;bez chyby
                jmp short chybaprifliotevreni
otevriflisoubor endp

vykresli1snimek proc far
                arg cislo
                uses ax, bx, cx, dx, si, di, es

                mov ax,cislo                    ;index tohoto snímku
                dec ax
                shl ax,2
                mov si,offset flihlavicka.index
                add si,ax
                mov ax,4200h                    ;seek na daný snímek
                mov bx,word ptr ds:flisoubor
                lodsw
                mov dx,ax
                lodsw
                mov cx,ax
                int 21h
                jc chybaprisnimku

                mov ah,3fh                      ;načti tento snímek
                mov dx,offset flisnimek
                mov cx,16d
                int 21h
                jc chybaprisnimku
                cmp ax,16d
                jc chybaprisnimku

                cmp ds:flisnimek.magic,0f1fah   ;kontrola snímku
                jne chybaprisnimku
                cmp word ptr ds:flisnimek.ssize,64016d
                ja chybaprisnimku
                cmp word ptr ds:flisnimek.ssize+2,0
                ja chybaprisnimku

                mov ah,48h                      ;alokace paměti
                mov bx,word ptr ds:flisnimek.ssize
                shr bx,2
                dec bx
                mov cx,bx
                int 21h
                jc chybaprisnimku
                mov es,ax                       ;žádaná paměť

                push ds
                mov ds,ax
                xor dx,dx
                mov ah,3fh                      ;načteme data snímku
                mov bx,ds:word ptr flisoubor
                int 21h
                pop ds
                jc chybapoalokaci
                cmp ax,cx
                jne chybapoalokaci

                mov cx,flisnimek.chunks         ;zobrazíme všechny `chunky'
                xor di,di
zobraz1chunk:
                mov bx,word ptr es:[di+4]       ;cislo funkce
                sub bx,11
                shl bx,1
                push cs                         ;far volání
                call word ptr ds:[fce_chunk+bx]
                add di,word ptr es:[di]
                loop zobraz1chunk               ;další chunk

                mov ah,49h                      ;O.K., uvolnit paměť
                int 21h
                xor ax,ax
                jmp short oksnimek
chybapoalokaci:
                mov ah,49h                      ;uvolnit paměť
                int 21h
chybaprisnimku:
                mov ax,1
oksnimek:
                ret
vykresli1snimek endp

zavriflisoubor proc far
               mov ah,3eh
               mov bx,ds:word ptr flisoubor
               int 21h
               jnc koneczavrenifli
               xor ax,ax                        ;bez chyby
koneczavrenifli:
               ret
zavriflisoubor endp

.data

fce_chunk         dw offset fce_palette         ;vyvolávané funkce
                  dw offset fce_changeimage
                  dw offset fce_clear
                  dw ?
                  dw offset fce_putcompimage
                  dw offset fce_putimage

flisoubor         dw ?

mojemaxsnimku equ 300
flihlavicka struc
  fsize           dd ?
  magic           dw ?
  frames          dw ?
  fwidth          dw ?
  fheigth         dw ?
  depth           dd ?
  speed           dw ?
  next            dw ?
  frit            dw ?
  fnothing        db 102 dup (?)
  index           dd mojemaxsnimku dup (?)
flihlavicka ends

flisnimek struc
  ssize           dd ?
  magic           dw ?
  chunks          dw ?
  snothing        db 8 dup (?)
flisnimek ends

;flifunkce struc
;  fsize           dd ?
;  typ             dw ?
;flifunkce ends

end
