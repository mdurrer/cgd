{$I-}  {Kdo me to tady smaze je VULLLLL a zkopu ho do kulicky!  LukS/LS}
{Lukááááááši; sprav už konečně PutMaskImagePartZoomMirror!!!!!
bob: řádek 262}

{***************************************************************************}
{ ***        Zakladni unit pro praci  v rezimu 13h se 4 strankami       *** }
{ ***              ovladacem mysi a tiskem textu na obr.                *** }
{***************************************************************************}

{ Heigth = vyska (Y souradnice) }
{ Width  = sirka (X souradnice) }

unit Graph256;

interface

type
    PString = ^string;

    TWordArray = array[0..32000] of word;
    PWordArray = ^TWordArray;
    TByteArray = array[0..65534] of byte;
    PByteArray = ^TByteArray;

    TFont = array[0..32983] of byte;
    PFont = ^TFont;

    TPalette = array[0..767] of byte;
    PPalette = ^TPalette;

var
  ActivePage : byte;            { prom. akt. str. }
  LastLine   : word;            { prom. rozmeru Y }
  ActiveAddrPage : word;        { ukazatel na akt. str v obr. RAM (ofset) }
  EndActiveAddrPage : word;     { ukazatel na konecakt. str v obr. RAM    }

  Font : PFont;                 { standardni font         }
  FonWidth, FonHeigth : byte;   { delka a vyska st. fontu }
  OverFontColor : byte;         { cislo barvy, ktera je pruhledna }
  FonColor1, FonColor2,         { skutecna barva pro pseudo barvy 254, 253,}
  FonColor3, FonColor4 : byte;  { 252 a 251 (po rade) }

  Palette :  PPalette;          { promena pro standartni paletu }

  MouseImage : pointer;

function  STI(NameMouse, NamePalette, NameFont : string) : boolean;
procedure STE;
procedure InitGraph;
procedure CloseGraph;

procedure ClearScr(color : byte);
procedure SetActivePage(Page : byte);
procedure SetVisualPage(Page : byte);
procedure SetPalette(Paleta : PPalette);

procedure Bar(X, Y, sirka, vyska : integer; color : byte);
procedure SwapColor(X, Y, sirka, vyska : integer; Color1, Color2 : byte);
procedure ReplaceColor(X, Y, sirka, vyska : integer; Color1, Color2 : byte);

procedure PutMaskImage(X, Y : integer; P : pointer);
procedure PutImage(X, Y : integer; P : pointer);
procedure GetImage(X, Y, sirka, vyska : integer; P : pointer);
procedure NewImage(sirka, vyska : word; var P : pointer);
procedure DisposeImage(var P : Pointer);

procedure PutMaskImagePart(X, Y, StartX, StartY, Sirka, Vyska : integer; P : Pointer);
procedure PutMirrorMaskImagePart(X, Y, StartX, StartY, Sirka, Vyska : integer; P : Pointer);
procedure PutImagePart(X, Y, StartX, StartY, Sirka, Vyska : integer; P : Pointer);
(*procedure PutMaskImageZoom(X, Y, SX, SY : integer; P : Pointer);*)
procedure PutMaskImagePartZoom(x,y, zX, zY, PartX, PartY, sirkaP, vyskaP : integer; p : pointer);
{procedure PutMaskImagePartZoom(X, Y, SX, SY, StartX, StartY, KonecX, KonecY : integer; P : Pointer);}
procedure PutMirrorMaskImagePartZoom(x,y, zX, zY, PartX, PartY, sirkaP, vyskaP : integer; p : pointer);
{procedure PutMirrorMaskImagePartZoom(X, Y, SX, SY, StartX, StartY, KonecX, KonecY : integer; P : Pointer);}

procedure PutPixel(X, Y : integer; Color : byte);
function  GetPixel(X, Y : integer) : byte;

procedure LineX(X, Y, sirka : integer; Color : byte);
procedure LineY(X, Y, vyska : integer; Color : byte);
procedure XorLineX(X, Y, sirka : integer; Color : byte);
procedure XorLineY(X, Y, vyska : integer; Color : byte);

function  InitMouse : word;
procedure MouseOn(Sirka, Vyska : integer; P : pointer);
procedure MouseOff;
procedure MouseSwitchOn;
procedure MouseSwitchOff;
procedure PushMouse;
procedure PopMouse;
function  MouseX : word;
function  MouseY : word;
function  MouseKey : word;
procedure NewMouseXY(X, Y : word);
procedure NewMouseArea(X, Y, sirka, vyska : word);

function RegisterFont( var LoadFont : PFont; path : string ) : boolean;
procedure DisposeFont(Font: PFont);
procedure PrintChar(X, Y : integer; Znak : byte; font : PFont);
procedure PrintText(X, Y : integer;  Txt : string; font : PFont);

procedure Rectangle(X,Y,Width,Heigth:integer;Color:byte);

function WidthOfChar(_font:pfont; Znak:char):integer;
function WidthOfText(_font:pfont; Ret:string):integer;
function WidthOfTextPart(_font:pfont; Ret:string;_From,_Length:byte;
                         DoplnitMezery:Boolean):integer;

function WidthOfFont(Font:PFont):byte;
function HeigthOfFont(Font:PFont):byte;

function CharsToWidth(Font:PFont;Ret:String;From:byte;Width:integer;
                      DoplnitMezery:Boolean):byte;

procedure WaitVRetrace;
procedure WaitDisplay;

procedure XorRectangle(X, Y, Sirka, Vyska : integer; Color : byte);
procedure XorPixel(X, Y : integer; Color : byte);

procedure XorCircle (x_stred, y_stred, polomer: integer; barva:byte);
procedure Ellipse (x_stred, y_stred, a, b : integer; barva:byte);
procedure XorEllipse (x_stred, y_stred, a, b : integer; barva:byte);
procedure FloodFill(X,Y:integer; Cim:byte; Ohranici:Byte);
procedure Circle (x_stred, y_stred, polomer: integer; barva:byte);
procedure Line(x1,y1,x2,y2:integer;barva:byte);
procedure XorLine(x1,y1,x2,y2:integer;barva:byte);

implementation

uses dos;

type PMouseStack=^TMouseStack;
     TMouseStack=record
       Activated,NotVisible:Boolean;
       Image:pointer;
       HotX,HotY:integer;
       Next:PMouseStack
     end;
     {pro procedury PushMouse a PopMouse
       - pri PushMouse se vytvori novy zaznam, da se ukazatel na stary do Next
         a presmeruje MouseStack na novy zaznam (to je zasobnik)
       - pri PopMouse se zkontroluje, zda je co Popovat (neni v MouseStack
         nil) a obnovi se to ze zaznamu, zrusi se zaznam a skoci se na polozku
         Next}
var
      OldMode : Byte;   { Mod obrazovky ktery byl pred 13H }

{      OldMouseBackgrnd, OldMouseVisible : boolean;
      OldMouseImage : pointer;
      OldMouseWidth, OldMouseHeigth : integer;}
      MouseStack:PMouseStack;

      OldMouseX, OldMouseY, MouseWidth, MouseHeigth, HotMouseX, HotMouseY : integer;
      { OldMouseX,OldMouseY=stare souradnice mysi kdyz je rezidentni }
      { MouseWidth, MouseHeigth : rozmery obrazku mysi kduz je rezidentni   }
      MouseBackgrnd, RightMouseImage : pointer;
      { MouseBackgrnd : bitmapa ktera je pod obr. mysi kdyz je aktivni }
      { RightMouseImage     : bitmapa obrazku mysi                             }
      MouseActivated, MouseNotVisible : boolean;
      { MouseActivated := true kdyz je mys rezidentni, MouseNotVisible=true=rezident bezi }

function  STI(NameMouse, NamePalette, NameFont : string) : boolean;
{ Standartni inicializace grafiky (automaticke nastaveni vsech promenuch) }
{ Automaticke nahrani Standartniho obrazku mysi, palety a fontu }
{ Vraci : False pri chybe, jinak true                           }
var f : file;
begin
  STI:= false;
  if RegisterFont(Font, NameFont) then Exit;
  Assign(f, NameMouse);
  Reset(f, 1);
  if ioresult<>0 then Exit;
  GetMem(MouseImage,FileSize(f));
  BlockRead(f,MouseImage^,FileSize(f));
(*  MouseNotVisible:= True;
  MouseActivated:= False;
  {OldMouseHeigth := 0;
  OldMouseWidth  := 0;}
  MouseStack:=nil;
  RightMouseImage := MouseImage; *)
  Close(f);
  Assign(f, NamePalette);
  Reset(f, 1);
  if ioresult<>0 then Exit;
  GetMem(Palette,FileSize(f));
  BlockRead(f,Palette^,FileSize(f));
  Close(f);
  SetPalette(Palette);
  if InitMouse=0 then begin
    WriteLn('Chybny ovladac mysi!');
    Exit;
  end;
  STI:= True;
  InitGraph;
  LastLine := 200;
  ActivePage := 0;
{    MouseOn(0, 0, MouseImage);
    MouseOff;}
  SetActivePage(0);
  SetVisualPage(0);
  OverFontColor:=255;
  FonColor1:=7;
  FonColor2:=2;
  FonColor3:=3;
  FonColor4:=4;
end;

procedure STE;
{ Vypnuti mysi kdyz je aktivni a prepnuti do stareho modu }
begin
  if MouseActivated then MouseOff;
  FreeMem(Palette, 768);
  DisposeImage(MouseImage);
  FreeMem(Font, {FonWidth*FonHeigth*}WidthOfFont(Font)*HeigthOfFont(Font)*138+140);
  CloseGraph;
end;

procedure InitGraph;
{ Nastaveni Modu 13H s pouzitim 4 stranek a ulozeni stareho modu do       }
{ prom. OldMode                                                           }
  VAR R : Registers;
begin
  R.AX := $0F00;
  Intr($10,R);
  OldMode := R.AL;
  MouseActivated:= False;

  R.AX := $13;
  Intr($10, R);

asm
   mov dx,3ceh
   mov al,5
   out dx,al
   inc dx
   in al,dx
   and al,11101111b
   out dx,al

   dec dx
   mov al,6
   out dx,al
   inc dx
   in al,dx
   and al,11111101b
   out dx,al

   mov dx,3c4h
   mov al,4
   out dx,al
   inc dx
   in al,dx
   and al,11110111b
   or al,4
   out dx,al


   mov ax,0a000h
   mov es,ax
   xor di,di
   mov ax,di
   mov cx,8000h
   rep stosw
{proč to děláš? a když už, tak proč jen v 1 videostránce?????}

   mov dx,3d4h
   mov al,14h
   out dx,al
   inc dx
   in al,dx
   and al,10111111b
   out dx,al

   dec dx
   mov al,17h
   out dx,al
   inc dx
   in al,dx
   or al,01000000b
   out dx,al
 end;
(*
  Port[$3C4] := 4;
  Port[$3C5] := Port[$3C5] AND NOT $08;
  Port[$3D4] := $14;
  Port[$3D5] := Port[$3D5] AND NOT $40;
  Port[$3D4] := $17;
  Port[$3D5] := Port[$3D5] OR $40;
  FillChar(Mem[$A000:0], $FFFF, 0);
*)
end;

procedure CloseGraph; assembler;
{ Prepnuti do stareho modu }
asm
    xor     ax, ax
    mov     al, OldMode
    int     10h
end;

procedure ClearScr(Color : byte); Assembler;
{ Smaze aktualni stranku                                    }
asm
    mov     ax, 0A000h
    mov     es, ax
    mov     dx, 3C4h
    mov     al, 02
    out     dx, al
    inc     dx
    mov     al, 0Fh
    out     dx, al
    mov     al, Color
    mov     ah, al
    mov     di, ActiveAddrPage
    mov     cx, EndActiveAddrPage
    sub     cx, di
    shr     cx, 1
    rep     stosw
end;

procedure SetActivePage(Page : byte);
{ Nastaveni aktivni stranky                                         }
begin
  ActivePage := Page;
  ActiveAddrPage := LastLine * 80 * Page;
  EndActiveAddrPage:= ActiveAddrPage + LastLine * 80;
end;

procedure SetVisualPage(Page : byte);
var
  addr: word;
begin
  addr:= LastLine * 80 * Page;
  asm
      mov dx,3d4h
      mov al,0ch
      out dx,al
      inc dx
      mov ax,addr
      xchg ah,al
      out dx,al   {vyssi bajt adresy VRAM}
      dec dx
      mov al,0dh
      out dx,al
      inc dx
      mov al,ah
      out dx,al   {nizsi bajt adresy VRAM}
  end;
end;

procedure SetPalette(Paleta : PPalette); Assembler;
{ Nastaveni palety                                               }
asm
  push  ds
  lds   si, Paleta
  cli
  mov   dx, 03C8h
  xor   al, al
  out   dx, al
  inc   dx
  mov   cx,0300h
  cld
  rep   outsb
  sti
  pop   ds
end;

procedure Bar(X, Y, sirka, vyska : integer; color : byte); Assembler;
{ Vykresleni obdelniku na aktualni stranku                        }
asm
  push     ds
  push     bp
  mov      ax, 0A000h
  mov      es, ax
  {Vypocet DI}
  mov     ax, 80
  mul     Y
  mov     di, ax
  mov     ax, X
  mov     cx, ax
  shr     ax, 1
  shr     ax, 1
  add     di, ax
  add     di, ActiveAddrPage
  and     cl, 3
  mov     ah, 1
  shl     ah, cl

  mov     cx, Sirka
  or      cx, cx
  jz      @Konec
  mov     bl, Color
  mov     bp, Vyska
  or      bp, bp
  jz      @Konec

@Lop_X:
  push     di
  push     cx
    mov      cx, bp
    mov      dx, 3C4h
    mov      al, 2
    out      dx, al
    inc      dx
    mov      al, ah
    and      al, 0Fh
    out      dx, al
  @Lop_Y:
    mov       byte ptr es:[di], bl
    add       di, 80
    Loop     @Lop_Y
  pop      cx
  pop      di
  shl      ah, 1
  cmp      ah, 10h
  jnz      @StejnaAdr
  mov      ah, 1
  inc      di
@StejnaAdr:
  loop     @Lop_X
@Konec:
  pop      bp
  pop      ds
end;

procedure SwapColor(X, Y, sirka, vyska : integer; Color1, Color2 : byte);
  Assembler;
{ V obdelniku na akt. str. zadanem X,Y,Sirka,Vyska prehodi barvy Color1 }
{ a Color2                                                              }
asm
  push     ds
  push     bp
  mov      ax, 0A000h
  mov      es, ax
  {Vypocet DI}
  mov     ax, 80
  mul     Y
  mov     di, ax
  mov     ax, X
  mov     cx, ax
  shr     ax, 1
  shr     ax, 1
  add     di, ax
  add     di, ActiveAddrPage
  and     cl, 3
    mov     ah, cl

  mov     cx, Sirka
  mov     bl, Color1
  mov     bh, Color2
  mov     bp, Vyska

@Lop_X:
  push     di
  push     cx
  mov      dx, 3C4h
  mov      al, 2
  out      dx, al
  inc      dx
  mov     cx, ax
  mov     cl, ah
  mov     al, 1
  shl     al, cl
  and      al, 0Fh
  out      dx, al
  mov      dx, 3CEh
  mov      al, 4
  out      dx, al
  inc      dx
  mov      al, ah
  out      dx, al
  mov      cx, bp
  @Lop_Y:
    mov      al, byte ptr es:[di]
    cmp      al, bl
    jne      @NoColor1
    mov      byte ptr es:[di], bh
    jmp      @OK_color
  @NoColor1:
    cmp      al, bh
    jne       @OK_Color
    mov      byte ptr es:[di], bl
  @OK_Color:
    add      di, 80
    Loop     @Lop_Y
  pop      cx
  pop      di
  inc      ah
  cmp      ah, 04h
  jnz      @StejnaAdr
  mov      ah, 0
  inc      di
@StejnaAdr:
  loop     @Lop_X
@Konec:
  pop      bp
  pop      ds
end;

procedure ReplaceColor(X, Y, sirka, vyska : integer; Color1, Color2 : byte); Assembler;
asm
  push     ds
  push     bp
  mov      ax, 0A000h
  mov      es, ax
  {Vypocet DI}
  mov     ax, 80
  mul     Y
  mov     di, ax
  mov     ax, X
  mov     cx, ax
  shr     ax, 1
  shr     ax, 1
  add     di, ax
  add     di, ActiveAddrPage
  and     cl, 3
    mov     ah, cl

  mov     cx, Sirka
  mov     bl, Color1
  mov     bh, Color2
  mov     bp, Vyska

@Lop_X:
  push     di
  push     cx
  mov      dx, 3C4h
  mov      al, 2
  out      dx, al
  inc      dx
  mov     cx, ax
  mov     cl, ah
  mov     al, 1
  shl     al, cl
  and      al, 0Fh
  out      dx, al
  mov      dx, 3CEh
  mov      al, 4
  out      dx, al
  inc      dx
  mov      al, ah
  out      dx, al
  mov      cx, bp
  @Lop_Y:
    mov      al, byte ptr es:[di]
    cmp      al, bl
    jne      @Ok_Color
    mov      byte ptr es:[di], bh
    jmp      @OK_color
  @OK_Color:
    add      di, 80
    Loop     @Lop_Y
  pop      cx
  pop      di
  inc      ah
  cmp      ah, 04h
  jnz      @StejnaAdr
  mov      ah, 0
  inc      di
@StejnaAdr:
  loop     @Lop_X
@Konec:
  pop      bp
  pop      ds
end;

procedure PutMaskImage(X, Y : integer; P : pointer); Assembler;
{ Vytiskne obrazek na akt. str. !nelze zajizdet za okraje obr.! }
asm
  push    ds
  push    bp
  mov     ax, 0A000h
  mov     es, ax
  { Vypocet DI, AH }
  mov     ax, 80
  mul     Y
  mov     di, ax
  mov     ax,X
  mov     cx, ax
  shr     ax, 1
  shr     ax, 1
  add     di, ax
  add     di, ActiveAddrPage
  and     cl, 3
  mov     ah, 1
  shl     ah, cl
   { Vypocet SI, CX=X, BX=Y }
  lds     si, P
  mov     cx, word ptr ds:[si]
  mov     bx, word ptr ds:[si+2]
  add     si, 4

@Lop_X:
  push     di
  push     cx
    mov      cx, bx
    mov      dx, 3C4h
    mov      al, 2
    out      dx, al
    inc      dx
    mov      al, ah
    out      dx, al
  @Lop_Y:
    lodsb
    cmp       al, 255
    jz        @NeVidet
    mov       byte ptr es:[di], al
  @NeVidet:
    add       di, 80
    Loop     @Lop_Y
  pop      cx
  pop      di
  shl      ah, 1
  cmp      ah, 10h
  jnz      @StejnaAdr
  mov      ah, 1
  inc      di
@StejnaAdr:
  loop     @Lop_X
@Konec:
  pop      bp
  pop      ds
end;

procedure PutImage(X, Y : integer; P : pointer); Assembler;
{ Vytiskne obr. an akt. str. i s 255. bajtem                    }
{ ! nejde zajizdet za okraje obr. !                             }
asm
  push    ds
  push    bp
  mov     ax, 0A000h
  mov     es, ax
  { Vypocet DI, AH }
  mov     ax, 80
  mul     Y
  mov     di, ax
  mov     ax,X
  mov     cx, ax
  shr     ax, 1
  shr     ax, 1
  add     di, ax
  add     di, ActiveAddrPage
  and     cl, 3
  mov     ah, 1
  shl     ah, cl
   { Vypocet SI, CX=X, BX=Y }
  lds     si, P
  mov     cx, word ptr ds:[si]
  mov     bx, word ptr ds:[si+2]
  add     si, 4

@Lop_X:
  push     di
  push     cx
    mov      cx, bx
    mov      dx, 3C4h
    mov      al, 2
    out      dx, al
    inc      dx
    mov      al, ah
    out      dx, al
  @Lop_Y:
    movsb
    add       di, 79
    Loop     @Lop_Y
  pop      cx
  pop      di
  shl      ah, 1
  cmp      ah, 10h
  jnz      @StejnaAdr
  mov      ah, 1
  inc      di
@StejnaAdr:
  loop     @Lop_X
@Konec:
  pop      bp
  pop      ds
end;

procedure GetImage(X, Y, sirka, vyska : integer; P : pointer); Assembler;
{ Ulozi obr. z akt. str. }
asm
  push    ds
  push    bp
  { Vypocet SI, AH }
  mov     ax, 80
  mul     Y
  mov     si, ax
  mov     ax,X
  mov     cx, ax
  shr     ax, 1
  shr     ax, 1
  add     si, ax
  add     si, ActiveAddrPage
  and     cl, 3
  mov     ah, cl
   { Vypocet DI, CX=X, BX=Y }
  mov     cx, Sirka
  mov     bx, Vyska
  les     di, P
  mov     word ptr es:[di], cx
  mov     word ptr es:[di+2], bx
  add     di, 4
  push    0A000h
  pop     ds

@Lop_X:
  push     si
  push     cx
    mov      cx, bx
    mov      dx, 3CEh
    mov      al, 4
    out      dx, al
    inc      dx
    mov      al, ah
    out      dx, al
  @Lop_Y:
    movsb
    add       si, 79
    Loop     @Lop_Y
  pop      cx
  pop      si
  inc      ah
  cmp      ah, 04h
  jnz       @StejnaAdr
  mov      ah, 0
  inc      si
@StejnaAdr:
  loop     @Lop_X
@Konec:
  pop      bp
  pop      ds
end;

procedure NewImage(sirka, vyska : word; var P : pointer);
{ Vyhradi pamet pro obrazek }
begin
  GetMem(P, Sirka*Vyska+4);
  PWordArray(P)^[0]:=Sirka;
  PWordArray(P)^[1]:=Vyska;
end;

procedure DisposeImage(var P : Pointer);
{ Zrusi pamet alokovanou obrazkem }
begin
  FreeMem(P, PWordArray(P)^[0]*PWordArray(P)^[1]+4);
end;

Procedure PutMaskImagePart(X, Y, StartX, StartY, Sirka, Vyska : integer; P : Pointer); assembler;
{ Vukresli obr na akt. str. na souradnice X,Y ale jen v okne urcenem }
{ StartX,StartY,Sirka,Vyska                                          }
asm
  jmp      @Start

@Xobr:      dw    0
@Yobr:      dw    0
@SXobr:     dw    0
@SYobr:     dw    0
@SirkaObr:  dw    0
@VyskaObr:  dw    0

@WX:        dw    0
@WY:        dw    0
@AAP:       dw    0

@LastL:     dw    0

@Start:
  mov      ax, LastLine
  mov      word ptr [@LastL], ax

  mov      ax, ActiveAddrPage
  mov      word ptr cs:[@AAP], ax
  mov      ax, X
  mov      word ptr cs:[@Xobr], ax
  mov      ax, Y
  mov      word ptr cs:[@Yobr], ax
  mov      ax, StartX
  mov      word ptr cs:[@SXobr], ax
  mov      ax, StartY
  mov      word ptr cs:[@SYobr], ax
  mov      ax, Sirka
  mov      word ptr cs:[@SirkaObr], ax
  mov      ax, Vyska
  mov      word ptr cs:[@VyskaObr], ax

  push     ds
  push     bp
  mov      ax, 0A000h
  mov      es, ax
  lds      si, P
  mov      bp, word ptr ds:[si+2]
  {Vypocet CX}
  mov      cx, word ptr cs:[@SirkaObr]       { do CX sirku OBR. }
  cmp      cx, word ptr ds:[si]              { je OKNO mensi nez OBR. }
  jna      @OK_CX1
  mov      cx, word ptr ds:[si]              { -ano CX:= OKNO }
@OK_CX1:
  mov      ax, word ptr cs:[@Xobr]           { do AX  souradnic X}
  or       ax, ax                            { je obrzek moc vlevo?}
  jns      @OK_CX6                           { ne = skok }
  add      ax, word ptr ds:[si]              { ano}
  or       ax, ax                            { AX:=sirka+X }
  js       @Konec                            { Neni videt= konec }
  mov      di, word ptr cs:[@SXobr]
  add      di, word ptr cs:[@SirkaObr]
  cmp      ax, di
  jna      @OK_CX7
  mov      cx, word ptr cs:[@SirkaObr]
  jmp      @OK_CX2
@OK_CX7:
  mov      ax, word ptr cs:[@Xobr]
  neg      ax
  add      ax, word ptr cs:[@SYobr]
    mov      cx, word ptr ds:[si]       { do CX sirku OBR. }
  sub      cx, ax
  or       cx, cx
  js       @Konec
  jz       @Konec
  jmp      @OK_CX2
@OK_CX6:
  cmp      ax, word ptr cs:[@SXobr]
  jae      @OK_CX3
  { -cx je vlevo}
  add      ax, word ptr ds:[si]
  sub      ax, word ptr cs:[@SXobr]
  or       ax, ax
  js       @Konec
  jz       @Konec
  mov      cx, ax
  jmp      @OK_CX4
@OK_CX3:
  { -cx je moc vpravo}
  mov      ax, word ptr cs:[@SXobr]
  add      ax, word ptr cs:[@SirkaObr]
  sub      ax, word ptr cs:[@Xobr]
  or       ax, ax
  js       @Konec
  jz       @Konec
  cmp      ax, cx
  jnb      @OK_CX4
  mov      cx, ax
  jmp      @OK_CX5
@OK_CX4:
  { - je ram menci nez cx? }
  mov      ax, word ptr cs:[@SirkaObr]
  cmp      ax, cx
  ja       @OK_CX5
  mov      cx, ax
@OK_CX5:
  mov      ax, cx
  add      ax, word ptr cs:[@Xobr]
  cmp      ax, 320
  jb       @OK_CX2
  mov      cx, 320
  sub      cx, word ptr cs:[@Xobr]
@OK_CX2:
  {Vypocet BX}
  mov      bx, word ptr cs:[@VyskaObr]
  cmp      bx, word ptr ds:[si+2]
  jna      @OK_BX1
  mov      bx, word ptr ds:[si+2]
@OK_BX1:
  mov      ax, word ptr cs:[@Yobr]
  or       ax, ax
  jns      @OK_BX6
  add      ax, bp
  or       ax, ax
  js       @Konec
  mov      di, word ptr cs:[@SYobr]
  add      di, word ptr cs:[@VyskaObr]
  cmp      ax, di
  jna      @OK_BX7
  mov      bx, word ptr cs:[@VyskaObr]
  jmp      @OK_BX2
@OK_BX7:
  mov      ax, word ptr cs:[@Yobr]
  neg      ax
  add      ax, word ptr cs:[@SYobr]
  mov      bx, word ptr ds:[si+2]
  sub      bx, ax
  or       bx, bx
  js       @Konec
  jz       @Konec
  jmp      @OK_BX2
@OK_BX6:
  cmp      ax, word ptr cs:[@SYobr]
  jae      @OK_BX3
  { - bp je nahore}
  add      ax, word ptr ds:[si+2]
  sub      ax, word ptr cs:[@SYobr]
  or       ax, ax
  js       @Konec
  jz       @Konec
  mov      bx, ax
  jmp      @OK_BX4
@OK_BX3:
  { -bx je moc dole}
  mov      ax, word ptr cs:[@SYobr]
  add      ax, word ptr cs:[@VyskaObr]
  sub      ax, word ptr cs:[@Yobr]
  or       ax, ax
  js       @Konec
  jz       @Konec
  cmp      ax, bx
  jnb      @OK_BX4
  mov      bx, ax
  jmp      @OK_BX5
@OK_BX4:
  { - je ram menci naz bx? }
  mov      ax, word ptr cs:[@VyskaObr]
  cmp      ax, bx
  ja       @OK_BX5
  mov      bx, ax
@OK_BX5:
  mov      ax, bx
  add      ax, word ptr cs:[@Yobr]
  cmp      ax, word ptr cs:[@LastL]
  jb       @OK_BX2
  mov      bx, word ptr cs:[@LastL]
  sub      bx, word ptr cs:[@Yobr]
@OK_BX2:
  {Vypocet SI, prom. pro DI}
  mov      ax, word ptr cs:[@Yobr]
  mov      dx, 0
  or       ax, ax
  jns      @OK_SI3
  { -Y je moc nahore}
  neg      ax
  mov      dx, ax
  add      dx, word ptr cs:[@SYObr]
  mov      ax, word ptr cs:[@SYObr]
  mov      word ptr cs:[@WY], ax
  jmp      @OK_SI1
@OK_SI3:
  mov      word ptr cs:[@WY], ax
  cmp      ax, word ptr cs:[@SYobr]
  ja       @OK_SI1
  mov      dx, word ptr cs:[@SYobr]
  mov      word ptr cs:[@WY], dx
  sub      dx, ax
@OK_SI1:
  add     dx, 4
  add     si, dx
  mov     ax, word ptr cs:[@Xobr]
  mov     dx, 0
  mov     word ptr cs:[@WX], ax
  or      ax, ax
  jns     @OK_SI4
  { - X je moc vlevo}
  neg     ax
  mov     dx, ax
  add     dx, word ptr cs:[@SXobr]
  mov     ax, word ptr cs:[@SXobr]
  mov     word ptr cs:[@WX], ax
  jmp     @OK_SI2
@OK_SI4:
  cmp     ax, word ptr cs:[@SXobr]
  ja      @OK_SI2
  mov     dx, word ptr cs:[@SXobr]
  mov      word ptr cs:[@WX], dx
  sub     dx, ax
@OK_SI2:
  mov     ax, bp
  mul     dx
  add     si, ax
  {Vypocet DI}
  push    cx
  mov     ax, 80
  mul     word ptr cs:[@WY]
  mov     di, ax
  mov     ax, word ptr cs:[@WX]
  mov     cx, ax
  shr     ax, 1
  shr     ax, 1
  add     di, ax
  add     di, word ptr cs:[@AAP]
  and     cl, 3
  mov     ah, 1
  shl     ah, cl
  pop     cx

@Lop_X:
  push     si
  push     di
  push     cx
    mov      cx, bx
    mov      dx, 3C4h
    mov      al, 2
    out      dx, al
    inc      dx
    mov      al, ah
    and      al, 0Fh
    out      dx, al
  @Lop_Y:
    lodsb
    cmp       al, 255
    jz        @NeVidet
    mov       byte ptr es:[di], al
  @NeVidet:
    add       di, 80
    Loop     @Lop_Y
  pop      cx
  pop      di
  pop      si
  add      si, bp
  shl      ah, 1
  cmp      ah, 10h
  jnz      @StejnaAdr
  mov      ah, 1
  inc      di
@StejnaAdr:
  loop     @Lop_X
@Konec:
  pop      bp
  pop      ds
end;

procedure PutMirrorMaskImagePart(X, Y, StartX, StartY, Sirka, Vyska : integer; P : Pointer); Assembler;
{ Vukresli obr na akt. str. na souradnice X,Y ale jen v okne urcenem }
{ StartX,StartY,Sirka,Vyska                                          }
asm
  jmp      @Start

@Xobr:      dw    0
@Yobr:      dw    0
@SXobr:     dw    0
@SYobr:     dw    0
@SirkaObr:  dw    0
@VyskaObr:  dw    0

@WX:        dw    0
@WY:        dw    0
@AAP:       dw    0
@SirkaImag: dw    0

@LastL:     dw    0

@Start:
  mov      ax, LastLine
  mov      word ptr [@LastL], ax

  mov      ax, ActiveAddrPage
  mov      word ptr cs:[@AAP], ax
  mov      ax, X
  mov      word ptr cs:[@Xobr], ax
  mov      ax, Y
  mov      word ptr cs:[@Yobr], ax
  mov      ax, StartX
  mov      word ptr cs:[@SXobr], ax
  mov      ax, StartY
  mov      word ptr cs:[@SYobr], ax
  mov      ax, Sirka
  mov      word ptr cs:[@SirkaObr], ax
  mov      ax, Vyska
  mov      word ptr cs:[@VyskaObr], ax

  push     ds
  push     bp
  mov      ax, 0A000h
  mov      es, ax
  lds      si, P
  mov      bp, word ptr ds:[si+2]
    mov      ax, word ptr ds:[si]
    mov      word ptr cs:[@SirkaImag], ax
  {Vypocet CX       | cx=sirka }
  mov      cx, word ptr cs:[@SirkaObr]       { do CX sirku OBR. }
  cmp      cx, word ptr ds:[si]              { je OKNO mensi nez OBR. }
  jna      @OK_CX1
  mov      cx, word ptr ds:[si]              { -ano CX:= OKNO }
@OK_CX1:
  mov      ax, word ptr cs:[@Xobr]           { do AX  souradnic X}
  or       ax, ax                            { je obrzek moc vlevo?}
  jns      @OK_CX6                           { ne = skok }
  add      ax, word ptr ds:[si]              { ano}
  or       ax, ax                            { AX:=sirka+X }
  js       @Konec                            { Neni videt= konec }
  mov      di, word ptr cs:[@SXobr]
  add      di, word ptr cs:[@SirkaObr]
  cmp      ax, di
  jna      @OK_CX7
  mov      cx, word ptr cs:[@SirkaObr]
  jmp      @OK_CX2
@OK_CX7:
  mov      ax, word ptr cs:[@Xobr]
  neg      ax
  add      ax, word ptr cs:[@SYobr]
    mov      cx, word ptr ds:[si]       { do CX sirku OBR. }
  sub      cx, ax
  or       cx, cx
  js       @Konec
  jz       @Konec
  jmp      @OK_CX2
@OK_CX6:
  cmp      ax, word ptr cs:[@SXobr]
  jae      @OK_CX3
  { -cx je vlevo}
  add      ax, word ptr ds:[si]
  sub      ax, word ptr cs:[@SXobr]
  or       ax, ax
  js       @Konec
  jz       @Konec
  mov      cx, ax
  jmp      @OK_CX4
@OK_CX3:
  { -cx je moc vpravo}
  mov      ax, word ptr cs:[@SXobr]
  add      ax, word ptr cs:[@SirkaObr]
  sub      ax, word ptr cs:[@Xobr]
  or       ax, ax
  js       @Konec
  jz       @Konec
  cmp      ax, cx
  jnb      @OK_CX4
  mov      cx, ax
  jmp      @OK_CX5
@OK_CX4:
  { - je ram menci nez cx? }
  mov      ax, word ptr cs:[@SirkaObr]
  cmp      ax, cx
  ja       @OK_CX5
  mov      cx, ax
@OK_CX5:
  mov      ax, cx
  add      ax, word ptr cs:[@Xobr]
  cmp      ax, 320
  jb       @OK_CX2
  mov      cx, 320
  sub      cx, word ptr cs:[@Xobr]
@OK_CX2:
  {Vypocet BX}
  mov      bx, word ptr cs:[@VyskaObr]
  cmp      bx, word ptr ds:[si+2]
  jna      @OK_BX1
  mov      bx, word ptr ds:[si+2]
@OK_BX1:
  mov      ax, word ptr cs:[@Yobr]
  or       ax, ax
  jns      @OK_BX6
  add      ax, bp
  or       ax, ax
  js       @Konec
  mov      di, word ptr cs:[@SYobr]
  add      di, word ptr cs:[@VyskaObr]
  cmp      ax, di
  jna      @OK_BX7
  mov      bx, word ptr cs:[@VyskaObr]
  jmp      @OK_BX2
@OK_BX7:
  mov      ax, word ptr cs:[@Yobr]
  neg      ax
  add      ax, word ptr cs:[@SYobr]
  mov      bx, word ptr ds:[si+2]
  sub      bx, ax
  or       bx, bx
  js       @Konec
  jz       @Konec
  jmp      @OK_BX2
@OK_BX6:
  cmp      ax, word ptr cs:[@SYobr]
  jae      @OK_BX3
  { - bp je nahore}
  add      ax, word ptr ds:[si+2]
  sub      ax, word ptr cs:[@SYobr]
  or       ax, ax
  js       @Konec
  jz       @Konec
  mov      bx, ax
  jmp      @OK_BX4
@OK_BX3:
  { -bx je moc dole}
  mov      ax, word ptr cs:[@SYobr]
  add      ax, word ptr cs:[@VyskaObr]
  sub      ax, word ptr cs:[@Yobr]
  or       ax, ax
  js       @Konec
  jz       @Konec
  cmp      ax, bx
  jnb      @OK_BX4
  mov      bx, ax
  jmp      @OK_BX5
@OK_BX4:
  { - je ram menci naz bx? }
  mov      ax, word ptr cs:[@VyskaObr]
  cmp      ax, bx
  ja       @OK_BX5
  mov      bx, ax
@OK_BX5:
  mov      ax, bx
  add      ax, word ptr cs:[@Yobr]
  cmp      ax, word ptr cs:[@LastL]
  jb       @OK_BX2
  mov      bx, word ptr cs:[@LastL]
  sub      bx, word ptr cs:[@Yobr]
@OK_BX2:
  {Vypocet SI, prom. pro DI}
  mov      ax, word ptr cs:[@Yobr]
  mov      dx, 0
  or       ax, ax
  jns      @OK_SI3
  { -Y je moc nahore}
  neg      ax
  mov      dx, ax
  add      dx, word ptr cs:[@SYObr]
  mov      ax, word ptr cs:[@SYObr]
  mov      word ptr cs:[@WY], ax
  jmp      @OK_SI1
@OK_SI3:
  mov      word ptr cs:[@WY], ax
  cmp      ax, word ptr cs:[@SYobr]
  ja       @OK_SI1
  mov      dx, word ptr cs:[@SYobr]
  mov      word ptr cs:[@WY], dx
  sub      dx, ax
@OK_SI1:
  add     dx, 4
  add     si, dx
  mov     ax, word ptr cs:[@Xobr]
  mov     dx, 0
  mov     word ptr cs:[@WX], ax

  or      ax, ax
  jns     @OK_SI4
  { - X je moc vlevo}
  neg     ax
  mov     dx, ax
  add     dx, word ptr cs:[@SXobr]
  mov     ax, word ptr cs:[@SXobr]
  mov     word ptr cs:[@WX], ax
  jmp     @OK_SI2
@OK_SI4:
  cmp     ax, word ptr cs:[@SXobr]
  ja      @OK_SI2
  mov     dx, word ptr cs:[@SXobr]
  mov      word ptr cs:[@WX], dx
  sub     dx, ax
@OK_SI2:
  mov     ax, bp
  mul     dx
  sub     si, ax  {add}
     push    ax
     push    dx
     mov     ax, word ptr cs:[@SirkaImag]{ word ptr ds:[si]   |   cx}
     dec     ax
     mul     bp {bx}
     add     si, ax
     pop     dx
     pop     ax
  {Vypocet DI}
  push    cx
  mov     ax, 80
  mul     word ptr cs:[@WY]
  mov     di, ax
  mov     ax, word ptr cs:[@WX]
  mov     cx, ax
  shr     ax, 1
  shr     ax, 1
  add     di, ax
  add     di, word ptr cs:[@AAP]
  and     cl, 3
  mov     ah, 1
  shl     ah, cl
  pop     cx

@Lop_X:
  push     si
  push     di
  push     cx
    mov      cx, bx
    mov      dx, 3C4h
    mov      al, 2
    out      dx, al
    inc      dx
    mov      al, ah
    and      al, 0Fh
    out      dx, al
  @Lop_Y:
    lodsb
    cmp       al, 255
    jz        @NeVidet
    mov       byte ptr es:[di], al
  @NeVidet:
    add       di, 80
    Loop     @Lop_Y
  pop      cx
  pop      di
  pop      si
  sub      si, bp  {Add}
  shl      ah, 1
  cmp      ah, 10h
  jnz      @StejnaAdr
  mov      ah, 1
  inc      di
@StejnaAdr:
  loop     @Lop_X
@Konec:
  pop      bp
  pop      ds
end;

Procedure PutImagePart(X, Y, StartX, StartY, Sirka, Vyska : integer; P : Pointer); assembler;
{ Vukresli obr na akt. str. na souradnice X,Y ale jen v okne urcenem }
{ StartX,StartY,Sirka,Vyska                                          }
asm
  jmp      @Start

@Xobr:      dw    0
@Yobr:      dw    0
@SXobr:     dw    0
@SYobr:     dw    0
@SirkaObr:  dw    0
@VyskaObr:  dw    0

@WX:        dw    0
@WY:        dw    0
@AAP:       dw    0

@LastL:     dw    0

@Start:
  mov      ax, LastLine
  mov      word ptr cs:[@LastL], ax

  mov      ax, ActiveAddrPage
  mov      word ptr cs:[@AAP], ax
  mov      ax, X
  mov      word ptr cs:[@Xobr], ax
  mov      ax, Y
  mov      word ptr cs:[@Yobr], ax
  mov      ax, StartX
  mov      word ptr cs:[@SXobr], ax
  mov      ax, StartY
  mov      word ptr cs:[@SYobr], ax
  mov      ax, Sirka
  mov      word ptr cs:[@SirkaObr], ax
  mov      ax, Vyska
  mov      word ptr cs:[@VyskaObr], ax

  push     ds
  push     bp
  mov      ax, 0A000h
  mov      es, ax
  lds      si, P
  mov      bp, word ptr ds:[si+2]
  {Vypocet CX}
  mov      cx, word ptr cs:[@SirkaObr]       { do CX sirku OBR. }
  cmp      cx, word ptr ds:[si]              { je OKNO mensi nez OBR. }
  jna      @OK_CX1
  mov      cx, word ptr ds:[si]              { -ano CX:= OKNO }
@OK_CX1:
  mov      ax, word ptr cs:[@Xobr]           { do AX  souradnic X}
  or       ax, ax                            { je obrzek moc vlevo?}
  jns      @OK_CX6                           { ne = skok }
  add      ax, word ptr ds:[si]              { ano}
  or       ax, ax                            { AX:=sirka+X }
  js       @Konec                            { Neni videt= konec }
  mov      di, word ptr cs:[@SXobr]
  add      di, word ptr cs:[@SirkaObr]
  cmp      ax, di
  jna      @OK_CX7
  mov      cx, word ptr cs:[@SirkaObr]
  jmp      @OK_CX2
@OK_CX7:
  mov      ax, word ptr cs:[@Xobr]
  neg      ax
  add      ax, word ptr cs:[@SYobr]
    mov      cx, word ptr ds:[si]       { do CX sirku OBR. }
  sub      cx, ax
  or       cx, cx
  js       @Konec
  jz       @Konec
  jmp      @OK_CX2
@OK_CX6:
  cmp      ax, word ptr cs:[@SXobr]
  jae      @OK_CX3
  { -cx je vlevo}
  add      ax, word ptr ds:[si]
  sub      ax, word ptr cs:[@SXobr]
  or       ax, ax
  js       @Konec
  jz       @Konec
  mov      cx, ax
  jmp      @OK_CX4
@OK_CX3:
  { -cx je moc vpravo}
  mov      ax, word ptr cs:[@SXobr]
  add      ax, word ptr cs:[@SirkaObr]
  sub      ax, word ptr cs:[@Xobr]
  or       ax, ax
  js       @Konec
  jz       @Konec
  cmp      ax, cx
  jnb      @OK_CX4
  mov      cx, ax
  jmp      @OK_CX5
@OK_CX4:
  { - je ram menci nez cx? }
  mov      ax, word ptr cs:[@SirkaObr]
  cmp      ax, cx
  ja       @OK_CX5
  mov      cx, ax
@OK_CX5:
  mov      ax, cx
  add      ax, word ptr cs:[@Xobr]
  cmp      ax, 320
  jb       @OK_CX2
  mov      cx, 320
  sub      cx, word ptr cs:[@Xobr]
@OK_CX2:
  {Vypocet BX}
  mov      bx, word ptr cs:[@VyskaObr]
  cmp      bx, word ptr ds:[si+2]
  jna      @OK_BX1
  mov      bx, word ptr ds:[si+2]
@OK_BX1:
  mov      ax, word ptr cs:[@Yobr]
  or       ax, ax
  jns      @OK_BX6
  add      ax, bp
  or       ax, ax
  js       @Konec
  mov      di, word ptr cs:[@SYobr]
  add      di, word ptr cs:[@VyskaObr]
  cmp      ax, di
  jna      @OK_BX7
  mov      bx, word ptr cs:[@VyskaObr]
  jmp      @OK_BX2
@OK_BX7:
  mov      ax, word ptr cs:[@Yobr]
  neg      ax
  add      ax, word ptr cs:[@SYobr]
  mov      bx, word ptr ds:[si+2]
  sub      bx, ax
  or       bx, bx
  js       @Konec
  jz       @Konec
  jmp      @OK_BX2
@OK_BX6:
  cmp      ax, word ptr cs:[@SYobr]
  jae      @OK_BX3
  { - bp je nahore}
  add      ax, word ptr ds:[si+2]
  sub      ax, word ptr cs:[@SYobr]
  or       ax, ax
  js       @Konec
  jz       @Konec
  mov      bx, ax
  jmp      @OK_BX4
@OK_BX3:
  { -bx je moc dole}
  mov      ax, word ptr cs:[@SYobr]
  add      ax, word ptr cs:[@VyskaObr]
  sub      ax, word ptr cs:[@Yobr]
  or       ax, ax
  js       @Konec
  jz       @Konec
  cmp      ax, bx
  jnb      @OK_BX4
  mov      bx, ax
  jmp      @OK_BX5
@OK_BX4:
  { - je ram menci naz bx? }
  mov      ax, word ptr cs:[@VyskaObr]
  cmp      ax, bx
  ja       @OK_BX5
  mov      bx, ax
@OK_BX5:
  mov      ax, bx
  add      ax, word ptr cs:[@Yobr]
  cmp      ax, word ptr cs:[@LastL]
  jb       @OK_BX2
  mov      bx, word ptr cs:[@LastL]
  sub      bx, word ptr cs:[@Yobr]
@OK_BX2:
  {Vypocet SI, prom. pro DI}
  mov      ax, word ptr cs:[@Yobr]
  mov      dx, 0
  or       ax, ax
  jns      @OK_SI3
  { -Y je moc nahore}
  neg      ax
  mov      dx, ax
  add      dx, word ptr cs:[@SYObr]
  mov      ax, word ptr cs:[@SYObr]
  mov      word ptr cs:[@WY], ax
  jmp      @OK_SI1
@OK_SI3:
  mov      word ptr cs:[@WY], ax
  cmp      ax, word ptr cs:[@SYobr]
  ja       @OK_SI1
  mov      dx, word ptr cs:[@SYobr]
  mov      word ptr cs:[@WY], dx
  sub      dx, ax
@OK_SI1:
  add     dx, 4
  add     si, dx
  mov     ax, word ptr cs:[@Xobr]
  mov     dx, 0
  mov     word ptr cs:[@WX], ax
  or      ax, ax
  jns     @OK_SI4
  { - X je moc vlevo}
  neg     ax
  mov     dx, ax
  add     dx, word ptr cs:[@SXobr]
  mov     ax, word ptr cs:[@SXobr]
  mov     word ptr cs:[@WX], ax
  jmp     @OK_SI2
@OK_SI4:
  cmp     ax, word ptr cs:[@SXobr]
  ja      @OK_SI2
  mov     dx, word ptr cs:[@SXobr]
  mov      word ptr cs:[@WX], dx
  sub     dx, ax
@OK_SI2:
  mov     ax, bp
  mul     dx
  add     si, ax
  {Vypocet DI}
  push    cx
  mov     ax, 80
  mul     word ptr cs:[@WY]
  mov     di, ax
  mov     ax, word ptr cs:[@WX]
  mov     cx, ax
  shr     ax, 1
  shr     ax, 1
  add     di, ax
  add     di, word ptr cs:[@AAP]
  and     cl, 3
  mov     ah, 1
  shl     ah, cl
  pop     cx

@Lop_X:
  push     si
  push     di
  push     cx
    mov      cx, bx
    mov      dx, 3C4h
    mov      al, 2
    out      dx, al
    inc      dx
    mov      al, ah
    and      al, 0Fh
    out      dx, al
  @Lop_Y:
    lodsb
    mov       byte ptr es:[di], al
    add       di, 80
{    movsb
    mov      di, 79}
    Loop     @Lop_Y
  pop      cx
  pop      di
  pop      si
  add      si, bp
  shl      ah, 1
  cmp      ah, 10h
  jnz      @StejnaAdr
  mov      ah, 1
  inc      di
@StejnaAdr:
  loop     @Lop_X
@Konec:
  pop      bp
  pop      ds
end;

(*Procedure PutMaskImagePartZoom(X, Y, SX, SY, StartX, StartY, KonecX, KonecY : integer; P : Pointer); {Assembler;}
{ vykresli obr. na akt. str. se zvetsenim (zmensenim) SX,SY }
{ ale jen v okne StartX,StartY a s delikosti KonecX,KonecY  }
begin
  Inc(X);
  Dec(sY);
  Dec(sX);
  sX:=(PWordArray(P)^[0] div SX)*256+
       PWordArray(P)^[0] mod sx*256 div sx;
  sY:=(PWordArray(P)^[1] div SY)*256+
       PWordArray(P)^[1] mod sY*256 div sY;
  asm
    jmp       @Start
  @KrokYD:     db    0
  @KrokYC:     dw    0
  @PushYD:     db    0

  @KrokXD:     db    0
  @KrokXC:     dw    0
  @PushXD:     db    0

  @StX:        dw    0
  @EnX:        dw    0
  @StY:        dw    0
  @EnY:        dw    0
  @PocX:       dw    0

  @Start:
    push      ds
    push      bp

    mov       ax, 0A000h
    mov       es, ax

    mov       ax, 80
    mul       StartY
    mov       word ptr cs:[@StY], ax
    mov       ax, ActiveAddrPage
    add       word ptr cs:[@StY], ax
    mov       ax, 80
    mov       bx, StartY
    add       bx, KonecY
    mul       bx
    mov       word ptr cs:[@EnY], ax
    mov       ax, ActiveAddrPage
    add       word ptr cs:[@EnY], ax

    mov       ax, StartX
    mov       word ptr cs:[@StX], ax
    add       ax, KonecX
    mov       word ptr cs:[@EnX], ax
    mov       ax, X
    mov       word ptr cs:[@PocX], ax

    mov       ax, 80              { Vypocet DI }
    mul       Y
    mov       cx, X               { test je-li obr. moc vlevo }
    dec       cx
    or        cx, cx
    jns       @Dal6               { neni skok }
    neg       cx
    dec       cx
    mov       di, cx
    shr       di, 1
    shr       di, 1
    sub       di, ax
    not       di
    not       cx
    jmp       @Dal9
  @Dal6:                            { vypocet DI }
    mov       di, cx
    shr       di, 1
    shr       di, 1
    add       di, ax                { V di je Adresa na obr. }
  @Dal9:
    add       di, ActiveAddrPage
    and       cx, 3
    mov       ah, 1
    shl       ah, cl
                                   { V bl je rovina, bh konec }
    push      ax
    mov       ax, SY
    mov       dx, SX
    lds       si, P
    mov       cx, word ptr ds:[si]
    mov       bp, word ptr ds:[si+2]

    mov       byte ptr cs:[@PushYD], 0
    mov       byte ptr cs:[@KrokYD], al
    mov       al, 0
    xchg      al, ah
    mov       word ptr cs:[@KrokYC], ax
    mov       byte ptr cs:[@PushXD], 0
    mov       byte ptr cs:[@KrokXD], dl
    xchg      dl, dh
    mov       ax, bp                         { v BP je Y IMAGE }
    mul       dl                             { v AX  je Y*Zmenseni }
    mov       word ptr cs:[@KrokXC], ax
    mov       ax, bp
    mul       cx                             { CX je Y*X }
    mov       cx, ax
    mov       bx, bp                         { BP je Y IMAGE }
    add       si, 4

    pop       ax
    add       cx, si                         { CX = adr konce obr. v RAM }
  { CX= ofset adresa konce IMAGE v pameti = pouizvano pro KONEC sirky Image}
  { BX= je Sirka IMAGE }
  { BP= je Vyska IMAGE }
  { @STARTXC= kolik radku ma probehnout bez vykresleni na obr.(kdyz je Image moc vlevo) }
              { pouzivano pro zacatek kresleni Image }
  { @KONECXC= adresa konec(zacatku dalsiho) readku na souradnici X (pouzivano kduz je Image moc vpravo) }
              { pouzivano pro konec kresleni Image }

  @Lop_X:
    push      si
    push      di
    push      cx
  mov       cx, word ptr cs:[@PocX]
  cmp       cx, word ptr cs:[@StX]
  jna       @KonecY
  cmp       cx, word ptr cs:[@EnX]
  ja        @KonecY
        mov       cx, bp
        add       cx, si
        mov	dx,3C4h
        mov	al,2
        out	dx,al
        inc	dx
        mov	al,ah
        and	al,0Fh
        out	dx,al
      @Lop_Y:
          or        di, di
          js        @Dal2
          cmp       di, word ptr cs:[@StY]
          jna       @Dal2
          cmp       di, word ptr cs:[@EnY]
          ja        @KonecY
        mov       al, byte ptr ds:[si]
        cmp       al, 255
        jz        @Dal2
        mov       byte ptr es:[di], al
      @Dal2:
        mov       dl, byte ptr cs:[@KrokYD]
        add       byte ptr cs:[@pushYD], dl
        adc       si, word ptr cs:[@KrokYC]
        Add       di, 80
        cmp       cx, si                  { test konce Y Image }
        ja        @Lop_Y
  @KonecY:
    pop       cx
    pop       di
    pop       si
    mov       byte ptr cs:[@PushYD], 0
    mov       al, byte ptr cs:[@KrokXD]
    add       byte ptr cs:[@PushXD], al
    jnc       @Daal
    add       si, bx
  @Daal:
    add       si, word ptr cs:[@KrokXC]
    shl       ah, 1
    cmp       ah, 10h
    jnz       @Dal1
    mov       ah, 1
    inc       di
  @Dal1:
    inc       word ptr cs:[@PocX]
    cmp       cx, si                         { test konec X IMAGE }
    ja        @Lop_X
    pop       bp
    pop       ds
  end
end;
*)
procedure PutMaskImagePartZoom(x,y, zX, zY, PartX, PartY, sirkaP, vyskaP : integer; p : pointer); assembler;
asm
  jmp  @Start

@zXobr  : dw  0; {velikost}
@zYobr  : dw  0;
@Xobr   : dw  0; {X,Y obrazku}
@Yobr   : dw  0;
@SPartX : dw  0; {Zacatek partu}
@SPartY : dw  0;
@VysP   : dw  0; {rozmery partu }
@SirP   : dw  0;
@VysP1  : dw  0; {rozmery partu }
@SirP1  : dw  0;
@rZoom  : dw  0;
@No     : db  0;
@SizeY  : dw  0;
@PosunX : dw  0;
@PosunY : dw  0;

@Start:
  mov     ax, zX
  mov     word ptr cs:[@zXobr], ax
  mov     ax, zY
  mov     word ptr cs:[@zYobr], ax
  mov     ax, X
  mov     word ptr cs:[@Xobr], ax
  mov     ax, Y
  mov     word ptr cs:[@Yobr], ax
  mov     ax, SirkaP
  mov     word ptr cs:[@SirP], ax
  mov     word ptr cs:[@SirP1], ax
  mov     ax, VyskaP
  mov     word ptr cs:[@VysP], ax
  mov     word ptr cs:[@VysP1], ax
  mov     ax, PartX
  mov     word ptr cs:[@SPartX], ax
  mov     ax, PartY
  mov     word ptr cs:[@SPartY], ax
  mov     ax, 0
  mov     byte ptr cs:[@No], al
  { X souradnice test zapornych hodnot }
    mov     ax, word ptr cs:[@Xobr]
    or      ax, ax
    jns     @OK_MinusX
    neg     ax
    mov     word ptr cs:[@PosunX], ax
    mov     ax, 0
    mov     word ptr cs:[@Xobr], ax
    jmp     @Dal_MinX
  @OK_MinusX:
    mov     ax, 0
    mov     word ptr cs:[@PosunX], ax
  @Dal_MinX:
  { X konec testu zapornych hodnot }
  { Y souradnice test zapornych hodnot }
    mov     ax, word ptr cs:[@Yobr]
    or      ax, ax
    jns     @OK_MinusY
    neg     ax
    mov     word ptr cs:[@PosunY], ax
    mov     ax, 0
    mov     word ptr cs:[@Yobr], ax
    jmp     @Dal_MinY
  @OK_MinusY:
    mov      ax, 0
    mov      word ptr cs:[@PosunY], ax
  @Dal_MinY:
  { Y konec testu zapornych hodnot }
  { X test k zacatku Partu }
    mov      ax, word ptr cs:[@Xobr]
    mov      cx, PartX
    cmp      ax, cx
    ja       @OK_PartX
    sub      cx, ax
    add      word ptr cs:[@PosunX], cx
    sub      word ptr cs:[@SirP], cx
    mov      ax, PartX
    mov      word ptr cs:[@XObr], ax
  @OK_PartX:
  { Konec X testu Partu}
  { Y test k zacatku Partu }
    mov      ax, word ptr cs:[@Yobr]
    mov      cx, PartY
    cmp      ax, cx
    ja       @OK_PartY
    sub      cx, ax
    add      word ptr cs:[@PosunY], cx
    sub      word ptr cs:[@VysP], cx
    mov      ax, PartY
    mov      word ptr cs:[@YObr], ax
  @OK_PartY:
  { Konec Y testu Partu}
  push    ds
  push    bp
  mov     ax, 0A000h
  mov     es, ax
  { Vypocet DI, AH }
  mov     ax, 80
  mul     word ptr cs:[@Yobr]
  mov     di, ax
  mov     ax, word ptr cs:[@Xobr]
  mov     cx, ax
  shr     ax, 1
  shr     ax, 1
  add     di, ax
  add     di, ActiveAddrPage
  and     cl, 3
  mov     ah, 1
  shl     ah, cl
   { Vypocet SI, CX=X, BX=Y }
  push    ax
  lds     si, P
  mov     bp, si
  { Vypocet zacatku obrazku (SI) volne reg. AX, CX, DX }
   {X souradnice}
    mov     ax, word ptr ds:[bp]
    mul     word ptr cs:[@PosunX]
    div     word ptr cs:[@zXobr]
    mov     cx, word ptr ds:[bp+2]
    mul     cx
    add     si, ax
   {Y souradnice}
    mov     ax, word ptr ds:[bp+2]
    mul     word ptr cs:[@PosunY]
    div     word ptr cs:[@zYObr]
    add     si, ax
  { Konec vypoctu SI }
  { X - souradnice pravy okraj}
    mov     cx, word ptr cs:[@Xobr]   {casem zmanit}
    mov     ax, word ptr cs:[@SPartX]
    add     ax, word ptr cs:[@SirP1]
    add     cx, word ptr cs:[@zXobr]
    sub     cx, word ptr cs:[@PosunX] {!!!}
    cmp     cx, ax
    jna     @Lop_Sirka

    mov     cx, word ptr cs:[@Xobr]   {casem zmanit}
    sub     cx, word ptr cs:[@PosunX]
    cmp     cx, word ptr cs:[@SPartX]
    ja      @Lop_DAAALX
    mov     cx, word ptr cs:[@SirP1]
    jmp     @OK_X
  @Lop_DAAALX:

    sub     ax, word ptr cs:[@Xobr]
    js      @Pop_K {Pokus}
    mov     cx, ax
    mov     ax, word ptr cs:[@zXobr]
    sub     ax, word ptr cs:[@PosunX] {!!!!}
    jz      @Ok_X
    jnc     @Ok_X
    pop     ax
    jmp     @Konec
    jmp     @OK_X
  @Lop_Sirka:
    mov     ax, word ptr cs:[@zXobr]
    mov     cx, ax
    sub     cx, word ptr cs:[@PosunX] {!!!!}
    jz      @Pop_K
    jnc     @Ok_X
  @Pop_K:
    pop     ax
    jmp     @Konec
  @OK_X:
  { Konec zjistovani praveho okraje X }
  { Y souradnice - zjistovani konce DX }
    mov     dx, word ptr cs:[@Yobr]   {casem zmanit}
    add     dx, word ptr cs:[@zYobr]
    mov     ax, word ptr cs:[@SPartY]
    add     ax, word ptr cs:[@VysP1]
    sub     dx, word ptr cs:[@PosunY]
    cmp     dx, ax
    jna     @Lop_Vyska

    mov     dx, word ptr cs:[@Yobr]
    sub     dx, word ptr cs:[@PosunY]
    cmp     dx, word ptr cs:[@SPartY]
    ja      @Lop_DAAALY
    mov     dx, word ptr cs:[@VysP1]
    jmp     @OK_Y
  @Lop_DAAALY:

    sub     ax, word ptr cs:[@Yobr]
    js      @Pop_K {Pokus}
    mov     dx, ax
    jmp     @OK_Y
  @Lop_Vyska:
     mov     ax, word ptr cs:[@zYobr]
     mov     dx, ax
     sub     dx, word ptr cs:[@PosunY]{!!!}
     jz      @Pop_K
     jnc     @OK_Y
     pop     ax
     jmp     @Konec
  @OK_Y:
   or      dx,dx
   jz      @Pop_K              {!!!!!!!!!!!!!!!}
   mov     word ptr cs:[@SizeY], dx
   mov     dx, word ptr cs:[@zYobr]
  { Konec zjistovani spodku okraje Y }
  add     si, 4
  mov     ax,0
  mov     word ptr cs:[@rZoom],ax
  pop     ax
  or      cx,cx
  jz      @Konec
  or      dx,dx
  jz      @Konec

  { BP . . . ukazatel na skutecnou velikost }
  { BX . . . reg. zvetseni (pozadovane velikosti) }
  { DX . . . pozadovana velikost Y }
  { CX . . . pozadovana velikost X }

@Lop_X:
  push     si
  push     di
  push     cx
    mov      cx, word ptr cs:[@SizeY]
    mov      bx, 0{word ptr ds:[bp+2] { - v komentari je PICOVINA}

    push     dx
    mov      dx, 3C4h
    mov      al, 2
    out      dx, al
    inc      dx
    mov      al, ah
    out      dx, al
    pop      dx

    cmp      bx, dx {Test zda jde o zvetseni nebo zmenseni obrazku}
    jna       @Lop_Plus {Kdyz zvetseni skok }
  @Lop_Y:
    mov      al, byte ptr ds:[si]
    cmp      al, 255
    je       @Mask1
{    stosb}
    mov      byte ptr es:[di], al
  @Mask1:
    add      di, 80
@S: sub      bx, dx
    jc       @Z
    inc      si
    jmp      @S
@Z: add      bx, word ptr ds:[bp+2]
    jnc      @Z
    inc      si
    Loop     @Lop_Y
    jmp      @EndY

@Lop_Plus:
@Sp: sub     bx, dx
    jc       @Zp
    inc      si
    jmp      @Sp
@Zp:
    mov      al, byte ptr ds:[si]
    cmp      al, 255
    je       @Mask2
    mov      byte ptr es:[di], al
  @Mask2:
{    stosb}
    add      di, 80
    dec      cx
    or       cx,cx
    jz       @EndY
    add      bx, word ptr ds:[bp+2]
    jnc      @Zp
    inc      si
    inc      cx
    Loop     @Lop_Plus
@EndY:

  pop      cx
  pop      di
  pop      si

  shl      ah,1
  cmp      ah, 10h
  jnz      @StejnaAdr
  mov      ah, 1
  inc      di
@StejnaAdr:
{  add      si,word ptr ds:[bp+2] { !!!! sem dopsat program !!!!}
  push     ax
  mov      ax, word ptr cs:[@zXobr]
  cmp      ax, word ptr ds:[bp]
  ja      @Plu2

@Again:
  sub      word ptr cs:[@rZoom], ax
  jc      @Dal_1
  add      si, word ptr ds:[bp+2]
  jmp      @Again
@Dal_1:
  mov      ax, word ptr ds:[bp]
  Add      word ptr cs:[@rZoom], ax
  add      si, word ptr ds:[bp+2]
  jmp      @daaal

@Plu2:
  cmp      byte ptr cs:[@No],0
  jne      @W
  sub      word ptr cs:[@rZoom], ax
@W:
  mov      byte ptr cs:[@No],1
  mov      ax, word ptr ds:[bp]
  Add      word ptr cs:[@rZoom], ax
  jnc       @Daaal
  add      si, word ptr ds:[bp+2]
  mov      ax,0
  mov      byte ptr cs:[@No],al
@daaal:
  pop      ax


{  loop     @Lop_X -instrukcni soubor INTELU nestaci ani na vytreni zatku!}
  dec      cx
  jz       @Konec
  jmp      @Lop_X

@Konec:
  pop      bp
  pop      ds
end;

(*
procedure PutMirrorMaskImagePartZoom(X, Y, SX, SY, StartX, StartY, KonecX, KonecY : integer; P : Pointer); {Assembler;}
{ vykresli obr. na akt. str. se zvetsenim (zmensenim) SX,SY }
{ ale jen v okne StartX,StartY a s delikosti KonecX,KonecY  }
begin
  dec(sY); { Musi byt , ted se mi to nechce opravovat }
  sX:=(PWordArray(P)^[0] div SX)*256+
       PWordArray(P)^[0] mod sx*256 div sx;
  sY:=(PWordArray(P)^[1] div SY)*256+
       PWordArray(P)^[1] mod sY*256 div sY;
  asm
    jmp       @Start
  @KrokYD:     db    0
  @KrokYC:     dw    0
  @PushYD:     db    0

  @KrokXD:     db    0
  @KrokXC:     dw    0
  @PushXD:     db    0

  @StX:        dw    0
  @EnX:        dw    0
  @StY:        dw    0
  @EnY:        dw    0
  @PocX:       dw    0

  @Start:
    push      ds
    push      bp

    mov       ax, 0A000h
    mov       es, ax

    mov       ax, 80
    mul       StartY
{    sub       ax, 4                     {nevim proc ale musy byt}
    mov       word ptr cs:[@StY], ax
    mov       ax, ActiveAddrPage
    mov       word ptr cs:[@StY], ax
    mov       ax, 80
    mov       bx, StartY
    add       bx, KonecY
    mul       bx
    mov       word ptr cs:[@EnY], ax
    mov       ax, ActiveAddrPage
    add       word ptr cs:[@EnY], ax

    mov       ax, StartX
    mov       word ptr cs:[@StX], ax
    add       ax, KonecX
    mov       word ptr cs:[@EnX], ax
    mov       ax, X
    mov       word ptr cs:[@PocX], ax

    mov       ax, 80              { Vypocet DI }
    mul       Y
    mov       cx, X               { test je-li obr. moc vlevo }
    or        cx, cx
    jns       @Dal6               { neni skok }
    neg       cx
    dec       cx
    mov       di, cx
    shr       di, 1
    shr       di, 1
    sub       di, ax
    not       di
    not       cx
    jmp       @Dal9
  @Dal6:                            { vypocet DI }
    mov       di, cx
    shr       di, 1
    shr       di, 1
    add       di, ax                { V di je Adresa na obr. }
  @Dal9:
    add       di, ActiveAddrPage
    and       cx, 3
    mov       ah, 1
    shl       ah, cl
                                   { V bl je rovina, bh konec }
    push      ax
    mov       ax, SY
    mov       dx, SX
    lds       si, P
    mov       cx, word ptr ds:[si]
    mov       bp, word ptr ds:[si+2]

    mov       byte ptr cs:[@PushYD], 0
    mov       byte ptr cs:[@KrokYD], al
    mov       al, 0
    xchg      al, ah
    mov       word ptr cs:[@KrokYC], ax
    mov       byte ptr cs:[@PushXD], 0
    mov       byte ptr cs:[@KrokXD], dl
    xchg      dl, dh
    mov       ax, bp                         { v BP je Y IMAGE }
    mul       dl                             { v AX  je Y*Zmenseni }
    mov       word ptr cs:[@KrokXC], ax
    mov       ax, bp
    mul       cx                             { CX je Y*X }
    mov       cx, ax
    mov       bx, bp                         { BP je Y IMAGE }

    mov        cx,si
    add        cx, 4
    pop       ax

          push    ax
          push    dx
          mov     ax, word ptr ds:[si]
          dec     ax
          mul     bp
          add     si, ax
          pop     dx
          pop     ax
    add       si, 4
  {  add       cx, si                         { CX = adr konce obr. v RAM }

  { CX= ofset adresa konce IMAGE v pameti = pouizvano pro KONEC sirky Image}
  { BX= je Sirka IMAGE }
  { BP= je Vyska IMAGE }
  { @STARTXC= kolik radku ma probehnout bez vykresleni na obr.(kdyz je Image moc vlevo) }
              { pouzivano pro zacatek kresleni Image }
  { @KONECXC= adresa konec(zacatku dalsiho) readku na souradnici X (pouzivano kduz je Image moc vpravo) }
              { pouzivano pro konec kresleni Image }

  @Lop_X:
    push      si
    push      di
    push      cx
  mov       cx, word ptr cs:[@PocX]
  cmp       cx, word ptr cs:[@StX]
  jb       @KonecY
  cmp       cx, word ptr cs:[@EnX]
  jae        @KonecY
        mov       cx, bp
        add       cx, si
        mov	dx,3C4h
        mov	al,2
        out	dx,al
        inc	dx
        mov	al,ah
        and	al,0Fh
        out	dx,al
      @Lop_Y:
          or        di, di
          js        @Dal2
          cmp       di, word ptr cs:[@StY]
          jb       @Dal2
          cmp       di, word ptr cs:[@EnY]
          ja        @KonecY
        mov       al, byte ptr ds:[si]
        cmp       al, 255
        jz        @Dal2
        mov       byte ptr es:[di], al
      @Dal2:
        mov       dl, byte ptr cs:[@KrokYD]
        add       byte ptr cs:[@pushYD], dl
        adc       si, word ptr cs:[@KrokYC]
        Add       di, 80
        cmp       cx, si                  { test konce Y Image }
        ja        @Lop_Y
  @KonecY:
    pop       cx
    pop       di
    pop       si
    mov       byte ptr cs:[@PushYD], 0
    mov       al, byte ptr cs:[@KrokXD]
    add       byte ptr cs:[@PushXD], al
    jnc       @Daal
    sub       si, bx      {Add}
  @Daal:
    sub       si, word ptr cs:[@KrokXC] {add}
    shl       ah, 1
    cmp       ah, 10h
    jnz       @Dal1
    mov       ah, 1
    inc       di
  @Dal1:
    inc       word ptr cs:[@PocX]
    cmp       cx, si                         { test konec X IMAGE }
  {  ja}jb        @Lop_X
    pop       bp
    pop       ds
  end
end;
*)
procedure PutMirrorMaskImagePartZoom(x,y, zX, zY, PartX, PartY, sirkaP, vyskaP : integer; p : pointer); assembler;
asm
  jmp  @Start

@zXobr  : dw  0;
@zYobr  : dw  0;
@Xobr   : dw  0;
@Yobr   : dw  0;
@SPartX : dw  0;
@SPartY : dw  0;
@VysP   : dw  0;
@SirP   : dw  0;
@VysP1  : dw  0;
@SirP1  : dw  0;
@rZoom  : dw  0;
@No     : db  0;
@SizeY  : dw  0;
@PosunX : dw  0;
@PosunY : dw  0;

@Start:
  mov     ax, zX
  mov     word ptr cs:[@zXobr], ax
  mov     ax, zY
  mov     word ptr cs:[@zYobr], ax
  mov     ax, X
  mov     word ptr cs:[@Xobr], ax
  mov     ax, Y
  mov     word ptr cs:[@Yobr], ax
  mov     ax, SirkaP
  mov     word ptr cs:[@SirP], ax
  mov     word ptr cs:[@SirP1], ax
  mov     ax, VyskaP
  mov     word ptr cs:[@VysP], ax
  mov     word ptr cs:[@VysP1], ax
  mov     ax, PartX
  mov     word ptr cs:[@SPartX], ax
  mov     ax, PartY
  mov     word ptr cs:[@SPartY], ax
  mov     ax, 0
  mov     byte ptr cs:[@No], al
  { X souradnice test zapornych hodnot }
    mov     ax, word ptr cs:[@Xobr]
    or      ax, ax
    jns     @OK_MinusX
    neg     ax
    mov     word ptr cs:[@PosunX], ax
    mov     ax, 0
    mov     word ptr cs:[@Xobr], ax
    jmp     @Dal_MinX
  @OK_MinusX:
    mov     ax, 0
    mov     word ptr cs:[@PosunX], ax
  @Dal_MinX:
  { X konec testu zapornych hodnot }
  { Y souradnice test zapornych hodnot }
    mov     ax, word ptr cs:[@Yobr]
    or      ax, ax
    jns     @OK_MinusY
    neg     ax
    mov     word ptr cs:[@PosunY], ax
    mov     ax, 0
    mov     word ptr cs:[@Yobr], ax
    jmp     @Dal_MinY
  @OK_MinusY:
    mov      ax, 0
    mov      word ptr cs:[@PosunY], ax
  @Dal_MinY:
  { Y konec testu zapornych hodnot }
  { X test k zacatku Partu }
    mov      ax, word ptr cs:[@Xobr]
    mov      cx, PartX
    cmp      ax, cx
    ja       @OK_PartX
    sub      cx, ax
    add      word ptr cs:[@PosunX], cx
    sub      word ptr cs:[@SirP], cx
    mov      ax, PartX
    mov      word ptr cs:[@XObr], ax
  @OK_PartX:
  { Konec X testu Partu}
  { Y test k zacatku Partu }
    mov      ax, word ptr cs:[@Yobr]
    mov      cx, PartY
    cmp      ax, cx
    ja       @OK_PartY
    sub      cx, ax
    add      word ptr cs:[@PosunY], cx
    sub      word ptr cs:[@VysP], cx
    mov      ax, PartY
    mov      word ptr cs:[@YObr], ax
  @OK_PartY:
  { Konec Y testu Partu}
  push    ds
  push    bp
  mov     ax, 0A000h
  mov     es, ax
  { Vypocet DI, AH }
  mov     ax, 80
  mul     word ptr cs:[@Yobr]
  mov     di, ax
  mov     ax, word ptr cs:[@Xobr]
  mov     cx, ax
  shr     ax, 1
  shr     ax, 1
  add     di, ax
  add     di, ActiveAddrPage
  and     cl, 3
  mov     ah, 1
  shl     ah, cl
   { Vypocet SI, CX=X, BX=Y }
  push    ax
  lds     si, P
  mov     bp, si
  { Mirror }
  push    ax
  mov     dx,0
  mov     ax, word ptr ds:[bp]
  dec     ax
  mul     word ptr ds:[bp+2]
  add     si, ax
  pop     ax
  { Vypocet zacatku obrazku (SI) volne reg. AX, CX, DX }
   {X souradnice}
    mov     ax, word ptr ds:[bp]
    mov     cx, word ptr ds:[bp+2]
    mul     word ptr cs:[@PosunX]
    div     word ptr cs:[@zXobr]
    mul     cx
    {add} sub     si, ax
   {Y souradnice}
{    mov     ax, word ptr ds:[bp+2]
    mul     word ptr cs:[@PosunY]
    div     word ptr cs:[@zYObr]
    add     si, ax}
    mov     ax, word ptr cs:[@PosunY]
    mul     word ptr ds:[bp+2]
    div     word ptr cs:[@zYObr]
    add     si, ax
  { Konec vypoctu SI }
  { X - souradnice pravy okraj}
    mov     cx, word ptr cs:[@Xobr]   {casem zmanit}
    mov     ax, word ptr cs:[@SPartX]
    add     ax, word ptr cs:[@SirP1]
    add     cx, word ptr cs:[@zXobr]
    sub     cx, word ptr cs:[@PosunX] {!!!}
    cmp     cx, ax
    jna     @Lop_Sirka
    sub     ax, word ptr cs:[@Xobr]
    mov     cx, ax
    mov     ax, word ptr cs:[@zXobr]
    sub     ax, word ptr cs:[@PosunX] {!!!!}
    js      @Pop_K {Pokus}
    jz      @Ok_X
    jnc     @Ok_X
    pop     ax
    jmp     @Konec
    jmp     @OK_X
  @Lop_Sirka:
    mov     ax, word ptr cs:[@zXobr]
    mov     cx, ax
    sub     cx, word ptr cs:[@PosunX] {!!!!}
    jz      @Pop_K
    jnc     @Ok_X
  @Pop_K:
    pop     ax
    jmp     @Konec
  @OK_X:
  { Konec zjistovani praveho okraje X }
  { Y souradnice - zjistovani konce DX }
    mov     dx, word ptr cs:[@Yobr]   {casem zmanit}
    mov     ax, word ptr cs:[@SPartY]
    add     ax, word ptr cs:[@VysP1]
    add     dx, word ptr cs:[@zYobr]
    sub     dx, word ptr cs:[@PosunY]
    cmp     dx, ax
    jna     @Lop_Vyska
    sub     ax, word ptr cs:[@Yobr]
    js      @Pop_K {Pokus}
    mov     dx, ax
    jmp     @OK_Y
  @Lop_Vyska:
     mov     ax, word ptr cs:[@zYobr]
     mov     dx, ax
     sub     dx, word ptr cs:[@PosunY]{!!!}
     jz      @Pop_K
     jnc     @OK_Y
     pop     ax
     jmp     @Konec
  @OK_Y:
   or      dx,dx
   jz      @Pop_K
   mov     word ptr cs:[@SizeY], dx
   mov     dx, word ptr cs:[@zYobr]
  { Konec zjistovani spodku okraje Y }
  add     si, 4
  mov     ax,0
  mov     word ptr cs:[@rZoom],ax
  pop     ax
  or      cx, cx
  js      @Konec
  jz      @Konec
  or      dx,dx
  jz      @Konec

  { BP . . . ukazatel na skutecnou velikost }
  { BX . . . reg. zvetseni (pozadovane velikosti) }
  { DX . . . pozadovana velikost Y }
  { CX . . . pozadovana velikost X }

@Lop_X:
  push     si
  push     di
  push     cx
    mov      cx, word ptr cs:[@SizeY]
    mov      bx, 0{word ptr ds:[bp+2] { - v komentari je PICOVINA}

    push     dx
    mov      dx, 3C4h
    mov      al, 2
    out      dx, al
    inc      dx
    mov      al, ah
    out      dx, al
    pop      dx

    cmp      bx, dx {Test zda jde o zvetseni nebo zmenseni obrazku}
    jna       @Lop_Plus {Kdyz zvetseni skok }
  @Lop_Y:
    mov      al, byte ptr ds:[si]
    cmp      al, 255
    je       @Mask1
{    stosb}
    mov      byte ptr es:[di], al
  @Mask1:
    add      di, 80
@S: sub      bx, dx
    jc       @Z
    inc      si
    jmp      @S
@Z: add      bx, word ptr ds:[bp+2]
    jnc      @Z
    inc      si
    Loop     @Lop_Y
    jmp      @EndY

@Lop_Plus:
@Sp: sub     bx, dx
    jc       @Zp
    inc      si
    jmp      @Sp
@Zp:
    mov      al, byte ptr ds:[si]
    cmp      al, 255
    je       @Mask2
{    stosb}
    mov      byte ptr es:[di], al
  @Mask2:
    add      di, 80
    dec      cx
    or       cx,cx
    jz       @EndY
    add      bx, word ptr ds:[bp+2]
    jnc      @Zp
    inc      si
    inc      cx
    Loop     @Lop_Plus
@EndY:

  pop      cx
  pop      di
  pop      si

  shl      ah,1
  cmp      ah, 10h
  jnz      @StejnaAdr
  mov      ah, 1
  inc      di
@StejnaAdr:
{  add      si,word ptr ds:[bp+2] { !!!! sem dopsat program !!!!}
  push     ax
  mov      ax, word ptr cs:[@zXobr]
  cmp      ax, word ptr ds:[bp]
  ja      @Plu2

@Again:
  sub      word ptr cs:[@rZoom], ax
  jc      @Dal_1
  {add}sub      si, word ptr ds:[bp+2]
  jmp      @Again
@Dal_1:
  mov      ax, word ptr ds:[bp]
  Add      word ptr cs:[@rZoom], ax
  {add}sub      si, word ptr ds:[bp+2]
  jmp      @daaal

@Plu2:
  cmp      byte ptr cs:[@No],0
  jne      @W
  sub      word ptr cs:[@rZoom], ax
@W:
  mov      byte ptr cs:[@No],1
  mov      ax, word ptr ds:[bp]
  Add      word ptr cs:[@rZoom], ax
  jnc       @Daaal
  {add}sub      si, word ptr ds:[bp+2]
  mov      ax,0
  mov      byte ptr cs:[@No],al
@daaal:
  pop      ax


{  loop     @Lop_X -instrukcni soubor INTELU nestaci ani na vytreni zatku!}
  dec      cx
  jz       @Konec
  jmp      @Lop_X

@Konec:
  pop      bp
  pop      ds
end;


procedure PutPixel(X, Y : integer; Color : byte); Assembler;
{ Nakresli bod                                                  }
asm
  mov      ax, 0A000h
  mov      es, ax
  {Vypocet DI}
  mov     ax, 80
  mul     Y
  mov     di, ax
  mov     ax, X
  mov     cx, ax
  shr     ax, 1
  shr     ax, 1
  add     di, ax
  add     di, ActiveAddrPage
  and     cl, 3
  mov     ah, 1
  shl     ah, cl
  mov     dx, 3C4h
  mov     al, 2
  out     dx, al
  inc     dx
  mov     al, ah
  out     dx, al
  mov     al, Color
  mov     byte ptr es:[di], al
end;

function  GetPixel(X, Y : integer) : byte; Assembler;
{ Precte bod                                                    }
asm
  mov      ax, 0A000h
  mov      es, ax
  {Vypocet DI}
  mov     ax, 80
  mul     Y
  mov     di, ax
  mov     ax, X
  mov     cx, ax
  shr     ax, 1
  shr     ax, 1
  add     di, ax
  add     di, ActiveAddrPage
  and     cl, 3
  mov     ah, cl
  mov     dx, 3CEh
  mov     al, 4
  out     dx, al
  inc     dx
  mov     al, ah
  out     dx, al
  mov     al,byte ptr es:[di]
end;


procedure LineX(X, Y, sirka : integer; Color : byte); Assembler;
{ Nakresli horizontalni linku                                }
asm
  mov      ax, 0A000h
  mov      es, ax
  {Vypocet DI}
  mov     ax, 80
  mul     Y
  mov     di, ax
  mov     ax, X
  mov     cx, ax
  shr     ax, 1
  shr     ax, 1
  add     di, ax
  add     di, ActiveAddrPage
  and     cl, 3
  mov     ah, 1
  shl     ah, cl
  mov     cx, Sirka
@X_Lop:
    mov     dx, 3C4h
    mov     al, 2
    out     dx, al
    inc     dx
    mov     al, ah
    out     dx, al
    mov     al, Color
    mov     byte ptr es:[di], al
    shl      ah, 1
    cmp      ah, 10h
    jnz      @StejnaAdr
    mov      ah, 1
    inc      di
@StejnaAdr:
  Loop    @X_Lop
end;


procedure LineY(X, Y, vyska : integer; Color : byte); Assembler;
{ Nakresli vertikalni linku                                     }
asm
  mov      ax, 0A000h
  mov      es, ax
  {Vypocet DI}
  mov     ax, 80
  mul     Y
  mov     di, ax
  mov     ax, X
  mov     cx, ax
  shr     ax, 1
  shr     ax, 1
  add     di, ax
  add     di, ActiveAddrPage
  and     cl, 3
  mov     ah, 1
  shl     ah, cl
  mov     dx, 3C4h
  mov     al, 2
  out     dx, al
  inc     dx
  mov     al, ah
  out     dx, al
  mov     cx, Vyska
  mov     al, Color
@X_Lop:
    mov     byte ptr es:[di], al
    add     di, 80
  Loop    @X_Lop
end;

procedure XorLineX(X, Y, sirka : integer; Color : byte); Assembler;
{ Nakresli horizontalni xorovanou linku                         }
asm
(*  mov      ax, 0A000h
  mov      es, ax
  {Vypocet DI}
  mov     ax, 80
  mul     Y
  mov     di, ax
  mov     ax, X
  mov     cx, ax
  shr     ax, 1
  shr     ax, 1
  add     di, ax
  add     di, ActiveAddrPage
  and     cl, 3
  mov     ah, 1
  shl     ah, cl
  mov     bl, cl
  mov     cx, Sirka
  mov     ah, 0
  or      cx, cx
  jns     @Dal
  neg     cx
  mov     ah,1
  {proc radsi nedas ah=1 nebo -1 a bude se to jenom pricitat ?}
@Dal:
@X_Lop:
    mov     dx, 3C4h
    mov     al, 2
    out     dx, al
    inc     dx
    mov     al, ah
    out     dx, al
    mov     dx, 3CEh
    mov     al, 4
    out     dx, al
    inc     dx
    mov     al, bl
    out     dx, al
    mov     al, byte ptr es:[di]
    xor     al, Color
    mov     byte ptr es:[di], al

    or     ah,ah
    jnz    @kleane
    dec    bl
    jmp    @dal2
@kleane:
    inc     bl
@dal2:
    shl     ah, 1
    cmp     ah, 10h
    jnz     @StejnaAdr
    mov     ah, 1
    inc     di
    mov     bl,0
@StejnaAdr:
  Loop    @X_Lop *)

  mov      ax, 0A000h
  mov      es, ax
  mov     ax, 80
  mul     Y
  mov     di, ax
  mov     ax, X
  mov     cx, ax
  shr     ax, 2
  add     di, ax
  add     di, ActiveAddrPage

  and     cl, 3
  mov     ah, 1
  shl     ah, cl
  mov     bl, cl

  mov     cx, Sirka
@Dal:
    mov     dx, 3C4h
    mov     al, 2
    out     dx, al
    inc     dx
    mov     al, ah
    out     dx, al
    mov     dx, 3CEh
    mov     al, 4
    out     dx, al
    inc     dx
    mov     al, bl
    out     dx, al

    mov     al, byte ptr es:[di]
    xor     al, Color
    mov     byte ptr es:[di], al

    inc     bl
    shl     ah, 1
    cmp     ah, 10h
    jnz     @StejnaAdr
    mov     ah, 1
    mov     bl,0
    inc     di
@StejnaAdr:
  Loop    @Dal
  {tak jsem to uz opravil, facha to, ani nevim, kdes mel chybu; ale myslim,
   zes ses zamotal do toho, zes chtel mit usecku obema smery, coz je
   blbost, staci, kdyz uz je to v obecne lajne}
end;


procedure XorLineY(X, Y, vyska : integer; Color : byte); Assembler;
{ Nakresli vertikalni xorovanou linku                          }
asm
  mov      ax, 0A000h
  mov      es, ax
  {Vypocet DI}
  mov     ax, 80
  mul     Y
  mov     di, ax
  mov     ax, X
  mov     cx, ax
  shr     ax, 1
  shr     ax, 1
  add     di, ax
  add     di, ActiveAddrPage
  and     cl, 3
  mov     ah, 1
  shl     ah, cl
  mov     dx, 3C4h
  mov     al, 2
  out     dx, al
  inc     dx
  mov     al, ah
  out     dx, al
  mov     dx, 3CEh
  mov     al, 4
  out     dx, ax
  inc     dx
  mov     al, cl
  out     dx, al
  mov     cx, Vyska
  mov     al, Color
  xor     ah, ah
  or      cx,cx
  jns     @dal
  neg     cx
  mov     ah, 1
@dal:
  or      cx,cx
  jz      @dal3
@X_Lop:
    mov     al, byte ptr es:[di]
    xor     al, Color
    mov     byte ptr es:[di], al
    or      ah,ah
    jz      @scit
    sub     di, 80
    jmp     @dal2
@scit:
    add     di, 80
@Dal2:
  Loop    @X_Lop
@Dal3:
end;

procedure IntMouse;
{ rezidenitni cast ovladace mysi                                }
  var Sir : integer;
begin
  if MouseNotVisible then exit;
{  MouseNotVisible:= true;}
  if (OldMouseX <> MouseX) or (OldMouseY <> MouseY) then
  begin
    PutImagePart(OldMouseX-HotMouseX, OldMouseY-HotMouseY, 0,0,320,200, MouseBackgrnd);
    OldMouseX := MouseX;
    OldMouseY := MouseY;
    Sir := OldMouseX-HotMouseX;
    if  Sir < 0
      then GetImage(320+Sir, OldMouseY-HotMouseY-1, MouseWidth, MouseHeigth, MouseBackgrnd)
      else GetImage(Sir, OldMouseY-HotMouseY, MouseWidth, MouseHeigth, MouseBackgrnd);
    PutMaskImagePart(Sir, OldMouseY-HotMouseY, 0, 0, 320, 200, RightMouseImage);
  end
{  MouseNotVisible:= false;}
end;

function InitMouse : word;
{ Inicializace mysi, vraci hodnou uspechu                       }
var navic : word;
begin
  asm
{    mov ax, 13h
    int 10h}
    xor ax,ax
    int 33h
    mov navic, ax
  end;
  InitMouse:=navic;
end;

procedure MouseOn(Sirka, Vyska : integer; P : pointer);
{ Zapne rezidentni ovladac mysi s obrazkem v prom. P            }
var
     Sir : integer;
begin
  if MouseActivated then MouseOff;
  MouseActivated:= True;
  RightMouseImage:= P;
  GetMem(MouseBackgrnd, PWordArray(P)^[0]*PWordArray(P)^[1]+4);
  {tady Lukas udelal CRAZY chybicku, ktera nam strasne zavarila na nakou
   1/2 hodinu WORKu (to co je v zavorce)}
  OldMouseX := MouseX;
  OldMouseY := MouseY;
  MouseWidth := {M^[1]}PWordArray(P)^[0];
  MouseHeigth := {M^[2]}PWordArray(P)^[1];
  HotMouseX := Sirka;
  HotMouseY := Vyska;
(*  GetImage(OldMouseX-HotMouseX, OldMouseY-HotMouseY, {M^[1]}MouseWidth, {M^[2]}MouseHeigth, MouseBackgrnd);*)
  Sir := OldMouseX-HotMouseX;
  if  Sir < 0
    then GetImage(320+Sir, OldMouseY-HotMouseY-1, MouseWidth, MouseHeigth, MouseBackgrnd)
    else GetImage(Sir, OldMouseY-HotMouseY, MouseWidth, MouseHeigth, MouseBackgrnd);
  PutMaskImagePart(OldMouseX-HotMouseX, OldMouseY-HotMouseY, 0,0,320,200, P{RightMouseImage});
  MouseNotVisible:= False;
  asm
    mov  ax, 000ch
    mov  cx, 1
    mov  dx, offset @ZdeMys
    push cs
    pop  es
    int  33h
    mov  ax, ds
    mov  word ptr cs:[@DS], ax
    mov  ax, bp
    mov  word ptr cs:[@BP], ax
    jmp  @Konec
  @ZdeMys:
    push ds
    push es
    push bp
    push si
    push di
    push ax
    push bx
    push cx
    push dx
    mov  ax, word ptr cs:[@DS]
    mov  ds, ax
    mov  ax, word ptr cs:[@BP]
    mov  bp, ax
    Call IntMouse
    pop  dx
    pop  cx
    pop  bx
    pop  ax
    pop  di
    pop  si
    pop  bp
    pop  es
    pop  ds
    retf
  @DS:  dw 0
  @BP:  dw 0
  @Konec:
  end;
end;

procedure MouseOff;
{ Vypne rezidentni ovladac mysi                                 }
begin
  if not MouseActivated then Exit;
  asm
    mov  ax, 000ch
    mov  cx, 0
    int  33h
  end;
  MouseActivated:= False;
{  MouseNotVisible:= True;}
  if not MouseNotVisible then
  PutImagePart(OldMouseX-HotMouseX, OldMouseY-HotMouseY, 0,0,320,200, MouseBackgrnd);
  FreeMem(MouseBackgrnd, word(word(MouseWidth)*word(MouseHeigth))+4);
end;

procedure MouseSwitchOn;
var Sir : integer;
begin
  if (not MouseActivated) then MouseOn(HotMouseX, HotMouseY, RightMouseImage);
  if (not MouseNotVisible) then Exit;
{  GetImage(OldMouseX-HotMouseX, OldMouseY-HotMouseY, MouseWidth, MouseHeigth, MouseBackgrnd);}
OldMouseX:=MouseX;
OldMouseY:=MouseY;
  Sir := OldMouseX-HotMouseX;
  if  Sir < 0
    then GetImage(320+Sir, OldMouseY-HotMouseY-1, MouseWidth, MouseHeigth, MouseBackgrnd)
    else GetImage(Sir, OldMouseY-HotMouseY, MouseWidth, MouseHeigth, MouseBackgrnd);
  PutMaskImagePart(OldMouseX-HotMouseX, OldMouseY-HotMouseY, 0,0,320,200, RightMouseImage);
  MouseNotVisible:= False;
end;

procedure MouseSwitchOff;
begin
  if MouseNotVisible then Exit;
  if not MouseActivated then Exit;
  MouseNotVisible:= True;
  PutImagePart(OldMouseX-HotMouseX, OldMouseY-HotMouseY, 0,0,320,200, MouseBackgrnd);
end;

procedure PushMouse;
var Temp:PMouseStack;
begin
  New(Temp);
  with Temp^ do begin
    Activated:=MouseActivated;
    NotVisible:=MouseNotVisible;
    Image:=RightMouseImage;
    HotX:=HotMouseX;
    HotY:=HotMouseY;
    Next:=MouseStack
  end;
  MouseStack:=Temp
{  OldMouseBackgrnd := MouseActivated;
  OldMouseVisible := MouseNotVisible;
  OldMouseImage := RightMouseImage;
  OldMouseWidth := HotMouseX;
  OldMouseHeigth := HotMouseY;}
end;

procedure PopMouse;
var Temp:PMouseStack;
begin
  if MouseStack<>nil then begin
    with MouseStack^ do begin
      MouseOn(HotX,HotY,Image);
      if not Activated then
        MouseOff;
      if NotVisible
        then MouseSwitchOff
        else MouseSwitchOn;
      Temp:=Next
    end;
    Dispose(MouseStack);
    MouseStack:=Temp
  end
{  MouseOn(OldMouseWidth, OldMouseHeigth, OldMouseImage);
  if not OldMouseBackgrnd then MouseOff;
  if not OldMouseVisible then MouseSwitchOn else MouseSwitchOff;}
end;

function  MouseX : word; Assembler;
{ vraci X souradnici mysi                                       }
asm
  mov ax,3
  int 33h
  mov ax,cx
  shr ax,1
end;

function  MouseY : word; Assembler;
{ vraci Y souradnici mysi                                       }
asm
  mov ax,3
  int 33h
  mov ax,dx
end;

function MouseKey : word; assembler;
{ vraci stav tlacitek mysi                                      }
asm
  mov ax,3
  int 33h
  mov ax,bx
end;

procedure NewMouseXY(X, Y : word); Assembler;
{ Nastavi pozice mysi                                        }
asm
  mov   ax, 0004h
  mov   cx, X
  shl   cx, 1
  mov   dx, Y
  int   33h
end;

procedure NewMouseArea(X, Y, sirka, vyska : word); Assembler;
{ Zada okno v kterem se muze pohybovat mys                   }
asm
  mov   ax, 0007h
  mov   cx, X           {leva=x}
  mov   dx, cx          {prava=x+sirka-1}
  add   dx, sirka
  dec   dx
  cmp   dx,cx           {kontrola prava<leva}
  jge   @okx
  mov   dx,cx
@okx:
  shl   cx, 1           {uprava na 2-nasobek kvuli Lukasovi a spol.}
  shl   dx, 1
  int   33h

  mov   ax, 0008h
  mov   cx, Y           {horni=y}
  mov   dx, cx          {dolni=y+vyska-1}
  add   dx, vyska
  dec   dx
  cmp   dx,cx           {kontrola dolni<horni}
  jge   @oky
  mov   dx,cx
@oky:
  int   33h
end;

function RegisterFont( var LoadFont : PFont; path : string ) : boolean;
{ Nacte font.                                                    }
var
   fontfile : file;
begin
   RegisterFont:= false;
   Assign(fontfile, path);
   Reset(fontfile, 1);
   if (ioresult=0)and(path<>'') then begin
     BlockRead(fontfile, FonWidth, 1);
     BlockRead(fontfile, FonHeigth, 1);
     GetMem(LoadFont, FonWidth*FonHeigth*138+140 );
     BlockRead(fontfile, LoadFont^[2], FonWidth*FonHeigth*138+138);
     Close(fontfile);
     LoadFont^[0] := FonWidth;
     LoadFont^[1] := FonHeigth;
   end else RegisterFont:= true;
{   Font := Addr(font^[0]);  Pavle ! K cemu to tady je?}
end;

procedure DisposeFont(Font: PFont);
begin
  FreeMem(Font, Font^[0]*Font^[1]*138+140 );
end;

procedure PrintChar(X, Y : integer; Znak : byte; font : PFont); Assembler;
{ tiskne proporcionalni znak na souradnice X,Y                  }
asm
  {tiskne cely znak, i kdyz je proporcionalni}
  push      ds
  push      bp

jmp @start
@_znak: db 0
@OWERC: db 0
@FonC1: db 0
@FonC2: db 0
@FonC3: db 0
@FonC4: db 0
@start:
  mov al,znak
  mov byte ptr cs:[@_znak],al
  mov al, OverFontColor
  mov byte ptr cs:[@OWERC], al
  mov al, FonColor1
  mov byte ptr cs:[@FonC1], al
  mov al, FonColor2
  mov byte ptr cs:[@FonC2], al
  mov al, FonColor3
  mov byte ptr cs:[@FonC3], al
  mov al, FonColor4
  mov byte ptr cs:[@FonC4], al
  {on se meni behem programu bp a ja nemam pristup k promennym}

  mov       ax, 0A000h
  mov       es, ax
  mov       ax, 80
  mul       Y
  mov       cx, X
  mov       di, cx
  shr       di, 1
  shr       di, 1
  add       di, ax      { V di je Adresa }
  add       di, ActiveAddrPage
  and       cx, 3
  mov       ah, 1
  shl       ah, cl

  mov       dl, Znak
  lds       si, Font
  xor       cx, cx
  xor       bx, bx
  mov       bl, byte ptr ds:[si+1] {Fy}
  mov       cl, byte ptr ds:[si]   {Fx}
  mov       bp, cx
              { Addr(font^[(FonWidth*FonHeigth*(65-32)+140)])}
  push      ax
  xor       ax, ax
  mov       al, cl
  mul       bl
  sub       dl, 32
  mul       dl

push bp
push ax
mov ah,0
mov al,byte ptr cs:[@_znak]
mov bp,ax
mov ch,0
mov cl,byte ptr ds:[si+bp-32+2]
pop ax
pop bp
{tohle vsechno kvuli ziskani praveho rozmeru znaku cislo Znak}

  add       ax, 140
  add       si, ax
  pop       ax
@Lop_2:
  Push      cx
  push      si
  push      di
  mov       cx, bx
  mov       dx,3C4h
  mov       al,2
  out       dx,al
  inc       dx
  mov       al,ah
  and       al,0Fh
  out       dx,al
  @Lop_1:
    mov       al, byte ptr ds:[si]
    cmp       al, byte ptr cs:[@OWERC]    {barva 255=ponechat puvodni pozadi}
    je        @Dal_1
    cmp       al, 254
    jne       @OK_C1
    mov       al, byte ptr cs:[@FonC1]
    jmp       @OK_C4
  @OK_C1:
    cmp       al, 253
    jne       @OK_C2
    mov       al, byte ptr cs:[@FonC2]
    jmp       @OK_C4
  @OK_C2:
    cmp       al, 252
    jne       @OK_C3
    mov       al, byte ptr cs:[@FonC3]
    jmp       @OK_C4
  @OK_C3:
    cmp       al, 251
    jne       @OK_C4
    mov       al, byte ptr cs:[@FonC4]
  @OK_C4:
    mov       byte ptr es:[di], al
  @Dal_1:
    add       di, 80
    add       si, bp
    loop      @Lop_1
  pop       di
  pop       si
  pop       cx
  inc       si
  shl       ah, 1
  cmp       ah, 10h
  jnz       @Dal_2
  mov       ah, 1
  inc       di
@Dal_2:
  Loop      @Lop_2

  pop       bp
  pop       ds
end;

procedure PrintText(X, Y : integer; txt : string; font : PFont);
{ Tiskne txt na souradnice X,Y                                  }
var Text1 : ^String;
begin
  Text1 := @txt;
  asm
    jmp       @Start
  @PushSI:    dw     0
  @DSSEGM:    dw     0
  @SISEGM:    dw     0
  @OWERC: db 0
  @FonC1: db 0
  @FonC2: db 0
  @FonC3: db 0
  @FonC4: db 0
  @Start:
    mov al, OverFontColor
    mov byte ptr cs:[@OWERC], al
    mov al, FonColor1
    mov byte ptr cs:[@FonC1], al
    mov al, FonColor2
    mov byte ptr cs:[@FonC2], al
    mov al, FonColor3
    mov byte ptr cs:[@FonC3], al
    mov al, FonColor4
    mov byte ptr cs:[@FonC4], al

    push      ds
    push      bp

    mov       ax, 0A000h
    mov       es, ax
    mov       ax, 80
    mul       Y
    mov       cx, X
    mov       di, cx
    shr       di, 1
    shr       di, 1
    add       di, ax      { V di je Adresa }
    add       di, ActiveAddrPage
    and       cx, 3
    mov       ah, 1
    shl       ah, cl
    lds       si, Font {V DS:SI adr fontu}
  mov       word ptr cs:[@PushSi], si
    push      si
    push      ds
    lds       si, Text1
    xor       cx, cx
    mov       cl, byte ptr ds:[si]
    inc       si
    mov       word ptr cs:[@DSSEGM], ds
    mov       word ptr cs:[@SISEGM], si
    pop       ds
    pop       si
    or        cx,cx
    jz        @AllEnd
  @Lop_3:
    push      cx
       push      si
       push      ds
       mov       ds, word ptr cs:[@DSSEGM]
       mov       si, word ptr cs:[@SISEGM]
       mov       dl, byte ptr ds:[si]
       add       word ptr cs:[@SISEGM], 1
       pop       ds
       pop       si
       mov       si, word ptr cs:[@PushSI]
       xor       cx, cx
       xor       bx, bx
       mov       bl, byte ptr ds:[si+1] {Fy}
       mov       cl, byte ptr ds:[si]   {Fx}
       mov       bp, cx
                   { Addr(font^[(FonWidth*FonHeigth*(65-32)+140)])}
       push      ax
       xor       ax, ax
       mov       al, cl
       mul       bl
       sub       dl, 32
       push      si
         mov       dh, 0
         add       si, dx
         add       si, 2
         mov       cl, byte ptr ds:[si]
       pop       si
       mul       dl
       add       ax, 140
       add       si, ax
       pop       ax
     @Lop_2:
       Push      cx
       push      si
       push      di
       mov       cx, bx
       mov       dx,3C4h
       mov       al,2
       out       dx,al
       inc       dx
       mov       al,ah
       and       al,0Fh
       out       dx,al
       @Lop_1:
         mov       al, byte ptr ds:[si]
         cmp       al, byte ptr cs:[@OWERC]    {barva 255=ponechat puvodni pozadi}
         je        @Dal_1
         cmp       al, 254
         jne       @OK_C1
         mov       al, byte ptr cs:[@FonC1]
         jmp       @OK_C4
       @OK_C1:
         cmp       al, 253
         jne       @OK_C2
         mov       al, byte ptr cs:[@FonC2]
         jmp       @OK_C4
       @OK_C2:
         cmp       al, 252
         jne       @OK_C3
         mov       al, byte ptr cs:[@FonC3]
         jmp       @OK_C4
       @OK_C3:
         cmp       al, 251
         jne       @OK_C4
         mov       al, byte ptr cs:[@FonC4]
       @OK_C4:
         mov       byte ptr es:[di], al
       @Dal_1:
         add       di, 80
         add       si, bp
         loop      @Lop_1
       pop       di
       pop       si
       pop       cx
       inc       si
       shl       ah, 1
       cmp       ah, 10h
       jnz       @Dal_2
       mov       ah, 1
       inc       di
     @Dal_2:
       Loop      @Lop_2
    pop       cx
    dec       cx
    jz        @AllEnd
    jmp       @Lop_3
{    Loop      @Lop_3}
@AllEnd:
    pop       bp
    pop       ds
  end;
end;

procedure Rectangle(X,Y,Width,Heigth:integer;Color:byte);
{nakresli obdelnik zadanou barvou na zadanem miste}
begin
  LineX(X,Y,Width,Color);
  LineY(X,Y,Heigth,Color);
  LineX(X,Y+Heigth-1,Width,Color);
  LineY(X+Width-1,Y,Heigth,Color)
end;

function WidthOfChar(_font:pfont; Znak:char):integer;
{vraci sirku zadaneho znaku}
begin
  WidthOfChar:=_Font^[2+byte(Znak)-32]
end;

function WidthOfText(_font:pfont; Ret:string):integer;
{vraci sirku celeho textu}
var Idx:byte;
    Width:integer;
begin
  Width:=0;
  for Idx:=1 to Length(Ret) do
    Inc(Width,WidthOfChar(_font,Ret[Idx]));
  WidthOfText:=Width
end;

function WidthOfTextPart(_font:pfont; Ret:string;_From,_Length:byte;
                         DoplnitMezery:Boolean):integer;
{vraci sirku zadane oblasti v textu}
var Idx:byte;
    Width:integer;
begin
  Width:=0;
  for Idx:=_From to _From+_Length-1 do
    if Idx<=Length(Ret)
      then Inc(Width,WidthOfChar(_font,Ret[Idx]))
      else if DoplnitMezery then
        Inc(Width,WidthOfChar(_font,' '));
  {pridal jsem kontrolu konce retezce a moznost pripocitani mezer za
   koncem retezce podle stavu prepinace}
  WidthOfTextPart:=Width
end;

function WidthOfFont(Font:PFont):byte;
{vraci sirku zadaneho fontu}
begin
  WidthOfFont:=Font^[0]
end;

function HeigthOfFont(Font:PFont):byte;
{vraci vysku zadaneho fontu}
begin
  HeigthOfFont:=Font^[1]
end;

function CharsToWidth(Font:PFont;Ret:String;From:byte;Width:integer;
                      DoplnitMezery:Boolean):byte;
var i:byte;
begin
  i:=From;
  while (WidthOfChar(Font,Ret[i])<=Width)and(i<=length(ret)) do begin
    dec(Width,WidthOfChar(Font,Ret[i]));
    inc(i)
  end;
  {pridal jsem podminku na testovani konce retezce}
  if DoplnitMezery and (i>length(ret)) then
    inc(i,width div widthofchar(font,' '));
  {pridal jsem pripadne doplneni mezerami}
  CharsToWidth:=i-From
end;

VAR CRTC: Word ABSOLUTE $0000:$0463;
      (* BIOS: Portadresse des CRTC-Indexregisters *)
PROCEDURE WaitVRetrace;
(* ------------------------------------------------------------- *)
(* Wartet auf den Beginn der nächsten vertikalen Retrace-Periode *)
(* ------------------------------------------------------------- *)
BEGIN
  (* Falls nötig auf Beginn der Display-Periode warten *)
  REPEAT UNTIL (Port[CRTC+6] AND $08) = 0;
  (* Auf Beginn der nächsten Retrace-Periode warten *)
  REPEAT UNTIL (Port[CRTC+6] AND $08) > 0;
END;

PROCEDURE WaitDisplay;
(* -------------------------------------------------- *)
(* Wartet auf den Beginn der nächsten Display-Periode *)
(* -------------------------------------------------- *)
BEGIN
  (* Falls nötig auf Beginn der Retrace-Periode warten *)
  REPEAT UNTIL (Port[CRTC+6] AND $08) > 0;
  (* Auf Beginn der nächsten Display-Periode warten *)
  REPEAT UNTIL (Port[CRTC+6] AND $08) = 0;
END;

procedure XorRectangle(X, Y, Sirka, Vyska : integer; Color : byte);
{ Nakresli xorovany (barvou Color) obdelnik X,Y,Sirka,Vyska }
begin
  if (Sirka <= 0)or(Vyska <= 0) then Exit;
  XorLineX(X, Y, Sirka, Color);
  if Vyska=1 then exit;
  XorLineX(X, Y+Vyska-1, Sirka, Color);
  if Vyska=2 then Exit;
  XorLineY(X, Y+1, Vyska-2, Color);
  if Sirka=1 then exit;
  XorLineY(X+Sirka-1, Y+1, Vyska-2, Color);
end;

procedure XorPixel(X, Y : integer; Color : byte); Assembler;
{ vyXORuje bod                                                  }
asm
  mov      ax, 0A000h
  mov      es, ax
  {Vypocet DI}
  mov     ax, 80
  mul     Y
  mov     di, ax
  mov     ax, X
  mov     cx, ax
  shr     ax, 1
  shr     ax, 1
  add     di, ax
  add     di, ActiveAddrPage
  and     cl, 3
  mov     ah, 1
  shl     ah, cl
  mov     dx, 3C4h
  mov     al, 2
  out     dx, al
  inc     dx
  mov     al, ah
  out     dx, al
  mov     dx, 3CEh
  mov     al, 4
  out     dx, ax
  inc     dx
  mov     al, cl
  out     dx, al

  mov     al, byte ptr es:[di]
  xor     al, Color
  mov     byte ptr es:[di], al
end;

procedure XorCircle (x_stred, y_stred, polomer: integer; barva:byte);
  var   predikce, dx, dy, x, y: integer;

  procedure xoruj_symetricke_body;
    begin
      XorPixel (x_stred + x, y_stred + y, barva);
      if x<>0 then
        XorPixel (x_stred - x, y_stred + y, barva);
      if y<>0 then begin
        XorPixel (x_stred + x, y_stred - y, barva);
        if x<>0 then
          XorPixel (x_stred - x, y_stred - y, barva);
      end;
      if (x=y){or(x=0)or(y=0)} then
        exit;
      XorPixel (x_stred + y, y_stred + x, barva);
      if y<>0 then
        XorPixel (x_stred - y, y_stred + x, barva);
      if x<>0 then begin
        XorPixel (x_stred + y, y_stred - x, barva);
        if y<>0 then
          XorPixel (x_stred - y, y_stred - x, barva)
      end
      {aby se to 2* nexorovalo}
    end; {kresli_symetrické_body}

  begin {Kružnice}
    x := 0;
    y := polomer;
    predikce := 1 - polomer;
    dx := 3;
    dy := 2*polomer - 2;
    repeat
      xoruj_symetricke_body;

      if predikce >= 0
        then { pokles souřadnice y }
          begin
            predikce := predikce - dy;
            dy := dy - 2;
            y := y - 1;
          end;
        predikce := predikce + dx;
        dx := dx + 2;
        x := x + 1;
    until x > y;
  end; {Kružnice}

procedure Ellipse (x_stred, y_stred, a, b : integer; barva:byte);
  var x, y : integer;
      A_kvadrat, Dve_A_kvadrat, B_kvadrat, Dve_B_kvadrat : longint;
      predikce, dx, dy : longint;

  procedure kresli_symetricke_body;
    begin
      Putpixel (x_stred + x, y_stred + y, barva);
      Putpixel (x_stred - x, y_stred + y, barva);
      Putpixel (x_stred + x, y_stred - y, barva);
      Putpixel (x_stred - x, y_stred - y, barva)
    end; {kresli_symetrické_body}

  begin {Elipsa}
    x := 0;
    y := b;
    A_kvadrat := longint(a) * a;
    B_kvadrat := longint(b) * b;
    Dve_A_kvadrat := 2 * A_kvadrat;
    Dve_B_kvadrat := 2 * B_kvadrat;
    predikce := B_kvadrat - A_kvadrat*b + A_kvadrat div 4;
    dx := 0;
    dy := Dve_A_kvadrat * b;

    while (dx < dy) do {řídicí osa x}
      begin
        kresli_symetricke_body;

        if (predikce >= 0) then
          begin
            y := y - 1;
            dy := dy - Dve_A_kvadrat;
            predikce := predikce - dy;
          end;
        x := x + 1;
        dx := dx + Dve_B_kvadrat;
        predikce := predikce + B_kvadrat + dx;
      end; {while dx < dy}

    predikce := predikce + (3*(A_kvadrat-B_kvadrat) div 2 - (dx+dy)) div 2;
    while (y >= 0) do {řídicí osa y}
      begin
        kresli_symetricke_body;

        if (predikce <= 0) then {vzrůst souřadnice x}
          begin
            x := x +1;
            dx := dx + Dve_B_kvadrat;
            predikce := predikce + dx;
          end;
        y := y - 1;
        dy := dy - Dve_A_kvadrat;
        predikce := predikce + A_kvadrat - dy;
      end; {while y >= 0}
  end; {Elipsa}

procedure XorEllipse (x_stred, y_stred, a, b : integer; barva:byte);
  var x, y : integer;
      A_kvadrat, Dve_A_kvadrat, B_kvadrat, Dve_B_kvadrat : longint;
      predikce, dx, dy : longint;

  procedure xoruj_symetricke_body;
    begin
      XorPixel (x_stred + x, y_stred + y, barva);
      if x<>0 then
        XorPixel (x_stred - x, y_stred + y, barva);
      if y<>0 then begin
        XorPixel (x_stred + x, y_stred - y, barva);
        if x<>0 then
          XorPixel (x_stred - x, y_stred - y, barva)
      end
      {aby se to 2* nexorovalo}
    end; {kresli_symetrické_body}

  begin {Elipsa}
    x := 0;
    y := b;
    A_kvadrat := longint(a) * a;
    B_kvadrat := longint(b) * b;
    Dve_A_kvadrat := 2 * A_kvadrat;
    Dve_B_kvadrat := 2 * B_kvadrat;
    predikce := B_kvadrat - A_kvadrat*b + A_kvadrat div 4;
    dx := 0;
    dy := Dve_A_kvadrat * b;

    while (dx < dy) do {řídicí osa x}
      begin
        xoruj_symetricke_body;

        if (predikce >= 0) then
          begin
            y := y - 1;
            dy := dy - Dve_A_kvadrat;
            predikce := predikce - dy;
          end;
        x := x + 1;
        dx := dx + Dve_B_kvadrat;
        predikce := predikce + B_kvadrat + dx;
      end; {while dx < dy}

    predikce := predikce + (3*(A_kvadrat-B_kvadrat) div 2 - (dx+dy)) div 2;
    while (y >= 0) do {řídicí osa y}
      begin
        xoruj_symetricke_body;

        if (predikce <= 0) then {vzrůst souřadnice x}
          begin
            x := x +1;
            dx := dx + Dve_B_kvadrat;
            predikce := predikce + dx;
          end;
        y := y - 1;
        dy := dy - Dve_A_kvadrat;
        predikce := predikce + A_kvadrat - dy;
      end; {while y >= 0}
  end; {Elipsa}

{$f+}
procedure FloodFill(X,Y:integer; Cim:byte; Ohranici:Byte);
  external;
procedure Circle (x_stred, y_stred, polomer: integer; barva:byte);
  external;
procedure Line(x1,y1,x2,y2:integer;barva:byte);
  external;
procedure XorLine(x1,y1,x2,y2:integer;barva:byte);
  external;
  {$l graphasm.obj}
{$f-}





begin
  MouseNotVisible:= True;
  MouseActivated:= False;
  {OldMouseHeigth := 0;
  OldMouseWidth  := 0;}
  MouseStack:=nil;
  RightMouseImage := MouseImage;
end.
