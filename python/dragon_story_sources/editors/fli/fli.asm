.286c

model small,pascal

public initgraph, closegraph
public fce_clear
public fce_putimage
public fce_putcompimage
public fce_changeimage
public fce_palette

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

end
