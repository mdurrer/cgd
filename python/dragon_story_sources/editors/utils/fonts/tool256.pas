
unit tool256;

interface

type
    _palettetype = array[0..767] of byte;
    _paletteptr = ^_palettetype;
    _bitmapa = array[0..63999] of byte;
    _bmptr = ^_bitmapa;

var
    paleta : _paletteptr;
    workfile : file;
    width, height : word;
    brush, RAM : _bmptr;


const
    cesta_pal= 'c:\user\paint\picture\paletka.pal';
    cesta_gcc= 'c:\user\paint\picture\';




procedure SetPalette(palette : _paletteptr);
procedure InitGraph;
procedure CloseGraph;
procedure ClearScr(color : byte);


{ --------------------------------------------------- }

{ Nasledujici procedury vyzaduji format grafiky "1" - }
{  [0] - bitmapa                                      }

procedure PutImage(sirka, vyska, x, y : word; source : _bmptr);
procedure PutImagePart(realwidth, sirka, vyska, x, y : word; source : _bmptr);
procedure PutMaskImage(sirka,vyska,x,y: word; source: _bmptr; paper: byte);
procedure TogetherMaskImage(sirka,vyska, x,y: word; image,back: _bmptr; paper :byte);

procedure PutImageRAM(sirka_i,vyska_i, x,y: word; source: _bmptr; sirka: word; dest: _bmptr);
procedure PutImagePartRAM(realwidth_i,sirka_i,vyska_i, x,y : word; source : _bmptr; sirka: word; dest: _bmptr);
procedure PutMaskImageRAM(sirka_i,vyska_i,x,y: word; source: _bmptr; paper: byte; sirka: word; dest: _bmptr);

procedure FillInImage(sirka, vyska, x, y : word; source : _bmptr);
procedure FillOutImage(sirka, vyska, x, y : word);

procedure GetImage(sirka, vyska, x, y : word; dest : _bmptr);
procedure GetImagePart(realwidth, sirka, vyska, x, y : word; dest : _bmptr);

procedure RollUpWindow(sirka, vyska, x, y, okolik : word);
procedure RollUpWindowRAM(sirka_w, vyska_w, x, y, okolik : word; sirka: word; dest: _bmptr);

procedure PutPixel(x,y,c:integer);
procedure Line(x1,y1,x2,y2,c:integer);

procedure Bar(sirka, vyska , x, y : word; color : byte);
procedure BarRAM(sirka_b, vyska_b , x, y : word; color : byte; sirka: word; dest: _bmptr);
procedure DarkBar(sirka, vyska , x, y : word; howmany : integer);
procedure ChangeColorBar(sirka, vyska , x, y : word; color,new : byte);


{ --------------------------------------------------- }

{ Nasledujici procedury vyzaduji format grafiky "2" - }
{  [0] - sirka, [2] - vyska, [4] - bitmapa            }

procedure FloodImage(sirka, vyska, x, y : word; source : _bmptr);
procedure FloodMaskImage(sirka, vyska, x, y : word; source : _bmptr; paper: byte);

procedure LoadImage(name : string; var dest : _bmptr );



implementation




procedure SetPalette(palette : _paletteptr);assembler;

{ Nastaveni palety }

asm
        push ds                 {pascal to potrebuje}
        lds si,palette          {ds=seg.paleta, si=ofs.paleta}
        mov dx,03c6h            {inicializace nastavovani ?}
        mov al,0ffh
        out dx,al
        mov bx,0                {cislo nastavovane barvy}
        cld                     {df=0 => lods.. pujde nahoru}
        mov al,2                {kvuli snezeni rozdelim inic. na 2 casti}

    @half:
        push ax

        mov dx,03dah            {cekam, az nastane zpetny beh paprsku}
    @snow:
        in al,dx
        test al,8
        jz @snow

        mov cx,80h              {najednou 128 barev...*2 = 256 }
    @nextcolor:
        mov dx,03c8h            {vyslu cislo nastavovane barvy}
        mov al,bl
        out dx,al
        inc bx                  {zvysim pro dalsi barvu}
        inc dx                  {port pro vyslani hodnot R,G,B}
        lodsb                   { al=[ds:si], si=si+1 }
        shr al,1
        shr al,1
        out dx,al               {vyslani hodnoty R}
        lodsb
        shr al,1
        shr al,1
        out dx,al               {vyslani hodnoty G}
        lodsb
        shr al,1
        shr al,1
        out dx,al               {vyslani hodnoty B}
        loop @nextcolor         {dalsi barva...}
        pop ax
        dec al
        jnz @half               {druha polovicka barev}

        pop ds                  {vyzvednu schovany DS }
end;


procedure InitGraph;assembler;

{ Inicializace graf.modu 013h }

asm
    mov ax,13H;
    int 10h;
end;

procedure CloseGraph;assembler;

{ (Zpetna) inicializace text.modu 03h }

asm
    mov ax,3;
    int 10h;
end;


procedure ClearScr(color : byte);assembler;

{ Mazani obrazovky }

asm
       mov ax,0a000h            {adr. segmentu videoram}
       mov es,ax
       mov di,0
       mov al,color
       mov cx,64000
       cld                      {stos.. bude zvysovat...}
       rep stosb                {plneni obrazovky nulami}
end;


procedure PutImage(sirka, vyska, x, y : word; source : _bmptr);

{ Nakresleni brushe }

var
   ofsadr : word;

begin
   ofsadr := y*320+x;           {radek*320+sloupec...}

   asm
       mov di,ofsadr            {ofs.adr. zacatku obr. ve VRAM}
       mov cx,vyska             {pocitadlo radku}
       mov dx,sirka             {sirka obrazku}

                           {vsechno toto MUSI byt hned tady - Pascal totiz
                                 pouziva pro adresovani promennych reg.DS,
                                       ve kterem mam tady adresu bitmapy }

       push ds                  {musi byt - pro Pascal}
       lds si,source            { ds=seg.bitmapa, si=ofs.bitmapa}
       mov ax,0a000h            {adr. segmentu videoram}
       mov es,ax
       cld                      {movs.. bude zvysovat...}
    @line:
       push cx
       push di
       mov cx,dx                {cx=sirka : presuneme jen sirku obrazku}
       rep movsb                {presun kresby}
       pop di
       add di,320               {posuv adresy na dalsi  radek}
       pop cx
       loop @line               {dalsi radek}
       pop ds                   {byl ulozeny...}
   end;
end;


procedure PutImagePart(realwidth, sirka, vyska, x, y : word; source : _bmptr);

{ Nakresleni brushe }

var
   ofsadr : word;

begin
   ofsadr := y*320+x;           {radek*320+sloupec...}

   asm
       mov di,ofsadr            {ofs.adr. zacatku obr. ve VRAM}
       mov cx,vyska             {pocitadlo radku}
       mov dx,sirka             {sirka obrazku}

       mov ax,0a000h            {adr. segmentu videoram}
       mov es,ax
       mov ax,realwidth

       push ds                  {musi byt - pro Pascal}
       lds si,source            { ds=seg.bitmapa, si=ofs.bitmapa}
       cld                      {movs.. bude zvysovat...}
    @line:
       push cx
       push di
       push si
       mov cx,dx                {cx=sirka : presuneme jen sirku obrazku}
       rep movsb                {presun kresby}
       pop si
       add si,ax
       pop di
       add di,320               {posuv adresy na dalsi  radek}
       pop cx
       loop @line               {dalsi radek}
       pop ds                   {byl ulozeny...}
   end;
end;


procedure PutMaskImagePart(realwidth, sirka, vyska, x, y : word; source : _bmptr; paper: byte);

{ Nakresleni brushe }

var
   ofsadr : word;

begin
   ofsadr := y*320+x;           {radek*320+sloupec...}

   asm
       jmp @after
    @realwidth: dw 0

    @after:
       mov ax,realwidth
       mov word ptr [@realwidth],ax

       mov di,ofsadr            {ofs.adr. zacatku obr. ve VRAM}
       mov cx,vyska             {pocitadlo radku}
       mov dx,sirka             {sirka obrazku}

       mov ax,0a000h            {adr. segmentu videoram}
       mov es,ax
       mov ah,paper
       push ds                  {musi byt - pro Pascal}
       lds si,source            { ds=seg.bitmapa, si=ofs.bitmapa}
       cld                      {movs.. bude zvysovat...}

    @line:
       push cx
       push di
       push si
       mov cx,dx                {cx=sirka : presuneme jen sirku obrazku}
    @pixel:
       lodsb
       cmp al,ah                {je to barva podkladu ?? }
       jnz @nomask
       mov al,es:[di]
    @nomask:
       stosb                    {nakresleni pixelu }
       loop @pixel
       pop si
       add si,word ptr [@realwidth]
       pop di
       add di,320               {posuv adresy na dalsi  radek}
       pop cx
       loop @line               {dalsi radek}

       pop ds                   {byl ulozeny...}
   end;
end;






procedure PutMaskImage(sirka, vyska, x, y : word; source : _bmptr; paper : byte);

{ Nakresleni brushe s pouzitim "masky" - nekresli se pixely zadane barvy}

var
   ofsadr : word;

begin
   ofsadr := y*320+x;           {radek*320+sloupec...}

   asm
       mov di,ofsadr            {ofs.adr. zacatku obr. ve VRAM}
       mov cx,vyska             {pocitadlo radku}
       mov dx,sirka             {sirka obrazku}
       mov ax,0a000h            {adr. segmentu videoram}
       mov es,ax
       mov ah,paper             {barva podkladu, ktera se neprenasi }

       push ds                  {musi byt - pro Pascal}
       lds si,source            { ds=seg.bitmapa, si=ofs.bitmapa}
       cld                      {movs.. bude zvysovat...}
    @line:
       push cx
       push di
       mov cx,dx                {cx=sirka : presuneme jen sirku obrazku}
    @pixel:
       lodsb
       cmp al,ah                {je to barva podkladu ?? }
       jnz @nomask
       mov al,es:[di]
    @nomask:
       stosb                    {nakresleni pixelu }
       loop @pixel
       pop di
       add di,320               {posuv adresy na dalsi  radek}
       pop cx
       loop @line               {dalsi radek}
       pop ds                   {byl ulozeny...}
   end;
end;




procedure TogetherMaskImage(sirka,vyska, x,y: word; image,back: _bmptr; paper :byte);

{ Nakresleni dvou brushu dohromady s pouzitim "masky" -
  kde jsou pixely zadane barvy, kresli se pozadi        }

var
   ofsadr : word;

begin
   ofsadr := y*320+x;           {radek*320+sloupec...}

   asm
       jmp @after
    @seg_back: dw 0
    @ofs_back: dw 0

    @after:
       les di,back              { es=seg.back, di=ofs.back}
       mov word ptr cs:[@seg_back],es
       mov word ptr cs:[@ofs_back],di

       mov di,ofsadr            {ofs.adr. zacatku obr. ve VRAM}
       mov cx,vyska             {pocitadlo radku}
       mov dx,sirka             {sirka obrazku}
       mov ax,0a000h            {adr. segmentu videoram}
       mov es,ax
       mov ah,paper             {barva podkladu, ktera se neprenasi }

                           {vsechno toto MUSI byt hned tady - Pascal totiz
                                 pouziva pro adresovani promennych reg.DS,
                                       ve kterem mam tady adresu bitmapy }

       push ds                  {musi byt - pro Pascal}
       lds si,image             { ds=seg.image, si=ofs.image}

       cld                      {movs.. bude zvysovat...}
    @line:
       push cx
       push di
       mov cx,dx                {cx=sirka : presuneme jen sirku obrazku}
    @pixel:
       lodsb
       cmp al,ah                {je to barva podkladu ?? }
       jnz @nomask
       push ds
       push si
       mov ds,word ptr cs:[@seg_back]
       mov si,word ptr cs:[@ofs_back]
       lodsb
       pop si
       pop ds
    @nomask:
       stosb                    {nakresleni pixelu }
       inc word ptr cs:[@ofs_back]
       loop @pixel
       pop di
       add di,320               {posuv adresy na dalsi  radek}
       pop cx
       loop @line               {dalsi radek}
       pop ds                   {byl ulozeny...}
   end;
end;





procedure PutImageRAM(sirka_i,vyska_i, x,y: word; source: _bmptr; sirka: word; dest: _bmptr);
{ Ulozeni brushe "do jineho brushe v pameti" }

var
   ofsadr : word;

begin
   ofsadr := y*sirka+x;         {posun adresy v cilovem brushi...}

   asm
       jmp @after
    @width: dw 0                { sirka ciloveho brushe }

    @after:
       mov ax,sirka
       mov word ptr cs:[@width],ax
       les di,dest
       add di,ofsadr            {v es:di je adr., kam prijde image do
                                 ciloveho brushe}
       mov cx,vyska_i           {pocitadlo radku}
       mov dx,sirka_i           {sirka obrazku}
       push ds                  {musi byt - pro Pascal}
       lds si,source            { ds=seg.bitmapa, si=ofs.bitmapa}

       cld                      {movs.. bude zvysovat...}
    @line:
       push cx
       push di
       mov cx,dx                {cx=sirka : presuneme jen sirku obrazku}
       rep movsb                {presun kresby}
       pop di
       add di,word ptr [@width] {posuv adresy na dalsi  radek}
       pop cx
       loop @line               {dalsi radek}
       pop ds                   {byl ulozeny...}
   end;
end;


procedure PutImagePartRAM(realwidth_i,sirka_i,vyska_i, x,y : word; source : _bmptr; sirka: word; dest: _bmptr);

{ Ulozeni casti brushe "do jineho brushe v pameti" }

var
   ofsadr : word;

begin
   ofsadr := y*sirka+x;         {posun adresy v cilovem brushi...}

   asm
       jmp @after
    @width: dw 0                { sirka ciloveho brushe }

    @after:
       mov ax,sirka
       mov word ptr cs:[@width],ax
       mov ax,realwidth_i
       les di,dest
       add di,ofsadr            {v es:di je adr., kam prijde image do
                                 ciloveho brushe}
       mov cx,vyska_i           {pocitadlo radku}
       mov dx,sirka_i           {sirka obrazku}
       push ds                  {musi byt - pro Pascal}
       lds si,source            { ds=seg.bitmapa, si=ofs.bitmapa}

       cld                      {movs.. bude zvysovat...}
    @line:
       push cx
       push di
       push si
       mov cx,dx                {cx=sirka : presuneme jen sirku obrazku}
       rep movsb                {presun kresby}
       pop si
       add si,ax
       pop di
       add di,word ptr [@width] {posuv adresy na dalsi  radek}
       pop cx
       loop @line               {dalsi radek}
       pop ds                   {byl ulozeny...}
   end;
end;


procedure PutMaskImageRAM(sirka_i,vyska_i,x,y: word; source: _bmptr; paper: byte; sirka: word; dest: _bmptr);
{ Nakresleni brushe s pouzitim "masky" - nekresli se pixely zadane barvy}

var
   ofsadr : word;

begin
   ofsadr := y*sirka+x;         {adresa v cilovem brushi}

   asm
       jmp @after
    @width: dw 0

    @after:
       mov ax,sirka
       mov word ptr [@width],ax
       les di,dest
       add di,ofsadr

       mov cx,vyska_i           {pocitadlo radku}
       mov dx,sirka_i           {sirka obrazku}
       mov ah,paper

       push ds                  {musi byt - pro Pascal}
       lds si,source            { ds=seg.bitmapa, si=ofs.bitmapa}
       cld                      {movs.. bude zvysovat...}
    @line:
       push cx
       push di
       mov cx,dx                {cx=sirka : presuneme jen sirku obrazku}
    @pixel:
       lodsb
       cmp al,ah                {je to barva podkladu ?? }
       jnz @nomask
       mov al,es:[di]
    @nomask:
       stosb                    {nakresleni pixelu }
       loop @pixel
       pop di
       add di,word ptr [@width] {posuv adresy na dalsi  radek}
       pop cx
       loop @line               {dalsi radek}
       pop ds                   {byl ulozeny...}
   end;
end;






procedure FillInImage(sirka, vyska, x, y : word; source : _bmptr );

{Vyplneni brushe nahoru}

var
   ofsadr : word;

begin
   ofsadr := y*320+x+vyska*320-320;
                        {zacatek posledniho radku na obr.,kde ma byt brush}

   asm
       mov di,ofsadr            {ofs.adr. zacatku obr. ve VRAM}
       mov cx,vyska             {pocitadlo radku}
       mov dx,sirka             {sirka obrazku}

                           {vsechno toto MUSI byt hned tady - Pascal totiz
                                 pouziva pro adresovani promennych reg.DS,
                                       ve kterem mam tady adresu bitmapy }

       push ds                  {musi byt - pro Pascal}
       lds si,source            { ds=seg.bitmapa, si=ofs.bitmapa}
       mov ax,0a000h            
       mov es,ax                {es = segment videoram}
       cld                      {movs.. bude zvysovat...}
    @line:
       push cx
       push di
    @fillup:
       push cx
       mov cx,500               {zdrzeni pro effect}
    @delay:
       loop @delay
       push di
       mov cx,dx                {cx=sirka : presuneme jen sirku obrazku}
       push si
       rep movsb                {presun kresby}
       pop si                   {obnovim adresu radku brushe}
       pop di
       sub di,320               {posuv adresy o radek nahoru}
       pop cx
       loop @fillup             {dokud radek brushe "nevytahnu" az nahoru}
       pop di
       add si,dx                {adr. dalsiho radku brushe}
       pop cx
       loop @line               {dalsi radek...}
       pop ds                   { DS byl ulozeny...}
   end;
end;


procedure FillOutImage(sirka, vyska, x, y : word);

{"Vyliti" brushe pryc nahoru}

var
   ofsadr : word;

begin
   ofsadr := y*320+x;           {adr. na obrazovce, kde ma byt brush}

   asm
       mov di,ofsadr            {ofs.adr. zacatku obr. ve VRAM}
       mov cx,vyska             {pocitadlo radku}
       mov dx,sirka             {sirka obrazku}

       push ds                  {musi byt - pro Pascal}
       mov ax,0a000h            {adr. segmentu videoram}
       mov ds,ax
       mov es,ax
       mov si,di
       mov bx,cx                {do BX vyska brushe}
       cld                      {movs.. bude zvysovat...}
    @line:
       push cx
       push di
       mov ax,bx                {do CX dam, o kolik budu radek }
       sub ax,cx                {na obrazovce "vytahovat" }
       mov cx,ax
       inc cx                   {CX=vyska-aktualni radek+1}
    @fillup:
       push cx
       mov cx,1               {zdrzeni pro effect}
    @delay:
       loop @delay
       push di
       mov cx,dx                {cx=sirka : presuneme jen sirku obrazku}
       push si
       rep movsb                {presun kresby}
       pop si
       pop di
       add di,320               {posuv adresy na dalsi  radek}
       pop cx
       loop @fillup
       pop di
       add si,320               {vytahujeme dalsi radek...}
       pop cx
       loop @line               {dalsi radek}
       pop ds                   {byl ulozeny...}
   end;
end;



procedure GetImage(sirka, vyska, x, y : word; dest : _bmptr);

{ Vzeti brushe }

var
   ofsadr : word;

begin
   ofsadr := y*320+x;           {radek*320+sloupec...}

   asm
       mov si,ofsadr            {ofs.adr. zacatku obr. ve VRAM}
       mov cx,vyska             {pocitadlo radku}
       mov dx,sirka             {sirka obrazku}

                           {vsechno toto MUSI byt hned tady - Pascal totiz
                                 pouziva pro adresovani promennych reg.DS,
                                       ve kterem mam tady adresu bitmapy }

       push ds                  {musi byt - pro Pascal}
       les di,dest              { es=seg.bitmapa, di=ofs.bitmapa}
       mov ax,0a000h            {adr. segmentu videoram}
       mov ds,ax
       cld                      {movs.. bude zvysovat...}
    @line:
       push cx
       push si
       mov cx,dx                {cx=sirka : presuneme jen sirku obrazku}
       rep movsb                {presun kresby}
       pop si
       add si,320               {posuv adresy na dalsi  radek}
       pop cx
       loop @line               {dalsi radek}
       pop ds                   {byl ulozeny...}
   end;
end;


procedure GetImagePart(realwidth, sirka, vyska, x, y : word; dest : _bmptr);

{ Vzeti casti brushe }

var
   ofsadr : word;

begin
   ofsadr := y*320+x;           {radek*320+sloupec...}

   asm
       mov si,ofsadr            {ofs.adr. zacatku obr. ve VRAM}
       mov cx,vyska             {pocitadlo radku}
       mov dx,sirka             {sirka obrazku}

                           {vsechno toto MUSI byt hned tady - Pascal totiz
                                 pouziva pro adresovani promennych reg.DS,
                                       ve kterem mam tady adresu bitmapy }

       push ds                  {musi byt - pro Pascal}
       les di,dest              { es=seg.bitmapa, di=ofs.bitmapa}
       mov ax,0a000h            {adr. segmentu videoram}
       mov ds,ax
       mov ax,realwidth
       cld                      {movs.. bude zvysovat...}
    @line:
       push cx
       push si
       push di
       mov cx,dx                {cx=sirka : presuneme jen sirku obrazku}
       rep movsb                {presun kresby}
       pop di
       add di,ax                {posun na dalsi radek v brushi}
       pop si
       add si,320               {posuv adresy ve VRAM na dalsi radek}
       pop cx
       loop @line               {dalsi radek}
       pop ds                   {byl ulozeny...}
   end;
end;




procedure RollUpWindow(sirka, vyska, x, y, okolik : word);

{ Scroll okna pryc nahoru}

var
   ofsadr : word;

begin
   ofsadr := y*320+x;           {adr. zacatku okna na obrazovce}

   asm
       mov di,ofsadr            {ofs.adr. zacatku obr. ve VRAM}
       mov cx,vyska             {pocitadlo radku}
       sub cx,okolik
       mov dx,okolik
       mov si,di                {na radek..}
       mov ax,320
       mul dx
       add si,ax                {...z radku o ..kolik..  dolu}
       mov dx,sirka             {sirka okna}
       push ds                  {musi byt - pro Pascal}
       mov ax,0a000h            {adr. segmentu videoram}
       mov ds,ax
       mov es,ax
       cld                      {movs.. bude zvysovat...}
    @line:
       push cx
       push di
       push si
       mov cx,dx                {cx=sirka : presuneme jen sirku obrazku}
       rep movsb                {presun kresby}
       pop si
       pop di
       add si,320               {vytahujeme dalsi radek...}
       add di,320               {posuv adresy na dalsi  radek}
       pop cx
       loop @line               {dalsi radek}
       pop ds                   {byl posunuty...}
   end;
end;


procedure RollUpWindowRAM(sirka_w, vyska_w, x, y, okolik : word; sirka: word; dest: _bmptr);
{ Scroll okna v RAM pryc nahoru}

var
   ofsadr : word;

begin
   ofsadr := y*sirka+x;         {posun adresy v cilovem brushi...}

   asm
       jmp @after
    @width: dw 0                { sirka ciloveho brushe }

    @after:
       mov ax,sirka
       mov word ptr cs:[@width],ax
       les di,dest
       add di,ofsadr            {v es:di je adr., kam prijde image do
                                 ciloveho brushe}
       mov cx,vyska_w           {pocitadlo radku}
       sub cx,okolik
       mov dx,okolik
       mov si,di                {na radek..}
       mov ax,sirka             {sirka brushe, ve kterem roluji}
       mul dx
       add si,ax                {...z radku o ..kolik..  dolu}
       mov dx,sirka_w           {sirka okna}
       push ds                  {musi byt - pro Pascal}
       push es
       pop ds                   {do  ds  stejny segment jako v  es }
       cld                      {movs.. bude zvysovat...}
    @line:
       push cx
       push di
       push si
       mov cx,dx                {cx=sirka : presuneme jen sirku obrazku}
       rep movsb                {presun kresby}
       pop si
       pop di
       add si,word ptr [@width]         {vytahujeme dalsi radek...}
       add di,word ptr [@width]         {posuv adresy na dalsi  radek}
       pop cx
       loop @line               {dalsi radek}
       pop ds                   {byl posunuty...}
   end;
end;



procedure PutPixel;

{var
   cc : char;
}
var xx:word;
begin
{  cc:=chr(c);
  move(cc,mem[$a000:0000+x+y*320],1);}
  {ten !!!!!!!!!!!!!!!!!!!!!!ZKURVENEJ!!!!!!!!!!!!!!!!!!! Turbo Poscal -7.0
   ten hajzl jeden zasranej mi snad pri kazdym projektu zkurvi nejakou
   hodinu tim, ze zkoumam, proc je preteceni
   a on si ten imbecilni debil neumi pri prirazeni word:=byte*konst(word)
   vysledek prevest na word a poblije se z toho
   a ja to musim obchazet takovyma hnusnyma vyrazama jako je ten
   nasledujici
   kez by to nejaka direktiva umela potlacit aniz bych prisel o nejakou
   jinou (treba uzitecnou) kontrolu, modlim se za to, abych to slo
   a ja abych mu nadaval zbytecne}
  xx:=y;
  xx:=xx*320+x;
  mem[$a000:xx]:=c
end;


procedure Line;

var
    i,j : integer;
    pomy : real;

begin
  if x1>x2 then begin
    i:=x1; x1:=x2; x2:=i; i:=y1; y1:=y2 ;y2:=i;
  end;
  if y1<=y2 then begin
    if abs(x1-x2)>= abs(y1-y2) then begin
      pomy:=y1;
      for i:=x1 to x2 do begin
        putpixel(i,trunc(pomy),c);
        pomy:=pomy+abs(y1-y2)/abs(x1-x2);
        end;
      end
    else  begin
      pomy:=x1;
    for i:= y1 to y2 do begin
      putpixel(trunc(pomy),i,c);
      end;
    end;
  end;
  if y1>y2 then begin
    if abs(x1-x2)>= abs(y1-y2) then begin
      pomy:=y1;
      for i:=x1 to x2 do begin
        putpixel(i,trunc(pomy),c);
        pomy:=pomy-abs(y1-y2)/abs(x1-x2);
      end;
    end else
    begin
      pomy:=x1;
      for i:=y1 downto y2 do begin
        putpixel(trunc(pomy),i,c);
        pomy:=pomy+abs(x1-x2)/abs(y1-y2);
      end;
    end;
  end;
end;


procedure Bar(sirka, vyska , x, y : word; color : byte);

var
   ofsadr : word;

begin
   ofsadr := y*320+x;           {radek*320+sloupec...}

   asm
       mov di,ofsadr            {ofs.adr. zacatku baru ve VRAM}
       mov cx,vyska             {pocitadlo radku baru}
       mov dx,sirka             {sirka baru}
       mov ax,0a000h            {adr. segmentu videoram}
       mov es,ax
       mov al,color             {barva vyplne}
       cld                      {movs.. bude zvysovat...}
    @line:
       push cx
       push di
       mov cx,dx                {cx=sirka : vyplnime sirku baru}
       rep stosb                {presun vyplne}
       pop di
       add di,320               {posuv adresy na dalsi  radek}
       pop cx
       loop @line               {dalsi radek}
   end;
end;


procedure BarRAM(sirka_b, vyska_b , x, y : word; color : byte; sirka: word; dest: _bmptr);
var
   ofsadr : word;

begin
   ofsadr := y*sirka+x;         {adresa baru v cilovem brushi...}

   asm
       jmp @after
    @width: dw 0                { sirka ciloveho brushe}

    @after:
       mov ax,sirka
       mov word ptr [@width],ax
       mov cx,vyska_b           {pocitadlo radku baru}
       mov dx,sirka_b           {sirka baru}
       les di,dest
       add di,ofsadr            { es:di ... adresa v cilovem brushi }
       mov al,color             {barva vyplne}
       cld                      {movs.. bude zvysovat...}
    @line:
       push cx
       push di
       mov cx,dx                {cx=sirka : vyplnime jen sirku baru}
       rep stosb                {presun vyplne}
       pop di
       add di,word ptr[@width]  {posuv adresy na dalsi  radek}
       pop cx
       loop @line               {dalsi radek}
   end;
end;



procedure DarkBar(sirka, vyska , x, y : word; howmany : integer);

var
   ofsadr : word;

begin
   ofsadr := y*320+x;           {radek*320+sloupec...}

   asm
       mov di,ofsadr            {ofs.adr. zacatku obr. ve VRAM}
       mov cx,vyska             {pocitadlo radku baru}
       mov dx,sirka             {sirka baru}
       mov ax,0a000h            {adr. segmentu videoram}
       mov es,ax
       mov ax,howmany           {o kolik ztmavime}
       mov ah,al
       cld                      {movs.. bude zvysovat...}
    @line:
       push cx
       push di
       mov cx,dx                {cx=sirka : ztmavime jen sirku baru}
    @pixel:
       mov al,byte ptr es:[di]
       push ax
       and al,0fh
       add al,ah
       and al,0f0h
       pop ax
       jnz @nonedark
       add al,ah
    @nonedark:
       stosb                    {ztmavovani kresby}
       loop @pixel
       pop di
       add di,320               {posuv adresy na dalsi  radek}
       pop cx
       loop @line               {dalsi radek}
   end;
end;


procedure ChangeColorBar(sirka, vyska , x, y : word; color,new : byte);
var
   ofsadr : word;

begin
   ofsadr := y*320+x;           {radek*320+sloupec...}

   asm
       push ds
       mov si,ofsadr            {ofs.adr. zacatku obr. ve VRAM}
       mov cx,vyska             {pocitadlo radku}
       mov dx,sirka             {sirka obrazku}
       mov ax,0a000h            {adr. segmentu videoram}
       mov ds,ax
       mov bh,color             {barva vyplne}
       mov bl,new
       cld                      {movs.. bude zvysovat...}
    @line:
       push cx
       push si
       mov cx,dx                {cx=sirka : presuneme jen sirku obrazku}
    @pixel:
       lodsb
       cmp al,bh
       jnz @nochange
       mov byte ptr ds:[si-1],bl
    @nochange:
       loop @pixel
       pop si
       add si,320               {posuv adresy na dalsi  radek}
       pop cx
       loop @line               {dalsi radek}
       pop ds
   end;
end;

procedure FloodImage(sirka, vyska, x, y : word; source : _bmptr);
var
   w_im, h_im : word;
   rd, sl : word;
   put_w, put_h : word;

begin
   w_im := source^[0];
   h_im := source^[2];
   put_h := h_im;
   for rd := 0 to (vyska-1) div h_im  do begin
      if(h_im*(rd+1)>vyska)then put_h := vyska-h_im*(rd);
      put_w := w_im;
      for sl := 0 to (sirka-1) div w_im  do begin
        if(w_im*(sl+1)>sirka)then put_w := sirka-w_im*(sl);
        PutImagePart(w_im, put_w, put_h, x+sl*w_im, y+rd*h_im, @source^[4]);
      end;
   end;

end;

procedure FloodMaskImage(sirka, vyska, x, y : word; source : _bmptr; paper: byte);
var
   w_im, h_im : word;
   rd, sl : word;
   put_w, put_h : word;

begin
   w_im := source^[0];
   h_im := source^[2];
   put_h := h_im;
   for rd := 0 to (vyska-1) div h_im  do begin
      if(h_im*(rd+1)>vyska)then put_h := vyska-h_im*(rd);
      put_w := w_im;
      for sl := 0 to (sirka-1) div w_im  do begin
        if(w_im*(sl+1)>sirka)then put_w := sirka-w_im*(sl);
        PutMaskImagePart(w_im, put_w, put_h, x+sl*w_im, y+rd*h_im, @source^[4], paper);
      end;
   end;

end;


procedure LoadImage(name : string; var dest : _bmptr );

{Load image do formatu "2" - sirka,vyska,bitmapa}

begin

   Assign(workfile, cesta_gcc+name+'.gcc');
   Reset(workfile, 1);
   BlockRead(workfile, width, 2);
   BlockRead(workfile, height, 2);
   GetMem(dest,(width*height)+4 );

   BlockRead(workfile, dest^[4], (width*height));
   dest^[0] := width;
   dest^[2] := height;
   Close(workfile);
end;


begin
end.