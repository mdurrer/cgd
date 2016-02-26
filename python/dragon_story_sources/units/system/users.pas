{!!!spraveny palety tak, ze uz blbne jenom posledni barva; dodelat!!!
 spraveno uplne --- Bob}

{pridano uppercase()}

{mozna misto putxorbar dat xorrectangle a to do graph256

 asi je spatne input hwxorbar, protoze ti to zabira az od 2 bodu rozmeru
 (mozna je to schvalne, ale pak je to pekne blbe)

 proc jsi zrusil moznost nastavit si v readcolor velikost ramecku barvy ???}

{vylepsil jsem preskrtnuti barvy z vodorovneho na sikme (v poli barev
 i v informacnim poli vpravo)

 zmenil jsem komentar k nove readcolor (byly tam zavadejici informace)

 dal jsem push/pop-mouse do stare verze readcolor, ale ta uz tu neni (viz.
 zaloha.1)

 uplne jsem predelal inputhwxorbar, aby byl fajnovy

 putxorbar nenakresli spravne, kdyz je x-ovy nebo y-ovy rozmer <=1 !!!!!
 ten jsem opravil

 proceduru putxorbat jsem zmenil na xorrectangle a prenesl do graph256

 zda se mi : nevraci maxavil longint ????? pak bys to zblbl, protoze segment
 ma pouze 64kb}

unit users;

(*{$G+,R-,S-,V-,I-}*)
{$I-}
interface

uses graph256, crt, dos;

type TStencilColor= array[0..255] of byte;
Var FrC2,ToC2,FrC3,ToC3,FrC4,ToC4:Integer;

function  InBar(My_X, My_Y, X, Y, sirka, vyska : integer) : boolean;

Procedure SetRCLimits(FL2,TL2,FL3,TL3,FL4,TL4:Integer);
Function  ReadColor(SX,SY:Integer; FrC,ToC:Integer;Fram,SC,Tag,Tfc:Byte;WFont:PFont; Vzkaz:String) : Integer;

procedure PutXorBar(X, Y, Sirka, Vyska : integer; Color : byte);
procedure InputHWXorBar(X, Y : integer;var Sirka, Vyska : integer; Color : byte);
procedure InputXYXorBar(var X, Y : integer; Sirka, Vyska : integer; Color : byte);
procedure InputXorBar( var X, Y , sirka, vyska : integer; Color : byte);

procedure ChangePalete(par:byte;del:word;paleta:pointer);
procedure ChangeBlockPalete(odkud,kam,par:byte;del:word;paleta:pointer);

procedure DoneRotatePal;
procedure InitRotatePal(Od1,Do1:Integer; W1:Byte; Od2,Do2:Integer; W2:Byte;
                        Od3,Do3:Integer; W3:Byte; Od4,Do4:Integer; W4:Byte;
                        P : pointer);

function MaxByte(A1,A2:byte):byte;
function MaxInteger(A1,A2:integer):integer;
function MinByte(A1,A2:byte):byte;
function MinInteger(A1,A2:integer):integer;

function  CopyFile(Source, Destination : string) : boolean;
function  DeleteFile(Name : string) : boolean;
function  ExistFile(Name : string) : boolean;
function  GetSizeImage(p : pointer) : word;

function UpperCase(ret:string):string;

function Stencil(xx,yy : integer;var barvy : TStencilColor;c1,c2,c3,c4,c5 : byte) : boolean;
procedure RemapDColor(var c : byte; newpal, oldpal : pointer);

const
    RotatePalOn : boolean = false;
var
    OldRotateInt : Procedure;
    RotatePointer : Pointer;
    RotateProm : array[1..12] of byte;
    WaitPal1,WaitPal2, WaitPal3,WaitPal4 : byte;

implementation

function  InBar(My_X, My_Y, X, Y, sirka, vyska : integer) : boolean;
{ vraci TRUE kdyz je My_X a My_Y v okne X,Y,Sirka,Vyska jinek false }
begin
 if (My_X >= X) and (My_X <= X+Sirka-1) and
    (My_Y >= Y) and (My_Y <= Y+Vyska-1) then
      InBar:= True else InBar:= False;
end;

Procedure SetRCLimits(FL2,TL2,FL3,TL3,FL4,TL4:Integer);
begin
  FrC2:=FL2; ToC2:=TL2;
  FrC3:=FL3; ToC3:=TL3;
  FrC4:=FL4; ToC4:=TL4;
end;

{Funkce se spousti s prarametry:
sX,sY - pozice leveho horniho rohu; od ktere barvy a do ktere barvy jsou barvy
zakazany(oboji vcetne); barva hlavniho ramecku; barva mrizky; barva textu;
barva pozadi; font+zprava
velikost ramecku barvy = vzdy 11
Leve tlacitko nebo ENTER potvrdi volbu, prave nebo ESC ulozi na vystup -1}
Function ReadColor(SX,SY:Integer; FrC,ToC:Integer;Fram,SC,Tag,Tfc:Byte;WFont:PFont; Vzkaz:String) : Integer;
Var Backup:Pointer;               {Pro ulozeni vyrezu, ktery bude preplacnut}
    LdX,LdY,Mskey:Byte;           {Cykly,tlacitko mysi}
    SpWidth,TanWidth:Byte;        {Sirka fontu, sirka textu}
    Color,OldColor:Integer;       {Barva a jeji zaloha}
    ColStr:String;                {Pro prevod na string a tisk}
    OutOk:Boolean;                {Propousteci promenna}
    Keyb:Char;                    {Tlacitka ESC a ENTER}
  {Smaze cislo, napsal jsem to jako proceduru - volam to nekolikrat}
  Procedure ClrNum; {SUBPROCEDURE of ReadColor}
  begin
    MouseSwitchOff;
    Bar(SX+150,SY+112,SpWidth,HeigthOfFont(WFont),Tag);{Smaze dolni cislo}
    OldColor:=Color;
  end;

  Function PermitColor:Boolean; {SUBPROCEDURE of ReadColor}
  begin
    PermitColor:=True;
    If (FrC=-1)or(ToC=-1) then begin Frc:=-1; ToC:=-1 end;
    If (FrC2=-1)or(ToC2=-1) then begin Frc2:=-1; ToC2:=-1 end;
    If (FrC3=-1)or(ToC3=-1) then begin Frc3:=-1; ToC3:=-1 end;
    If (FrC4=-1)or(ToC4=-1) then begin Frc4:=-1; ToC4:=-1 end;
    If ((Color>=FrC)and(Color<=ToC))or((Color>=FrC2)and(Color<=ToC2))
    or((Color>=FrC3)and(Color<=ToC3))or((Color>=FrC4)and(Color<=ToC4))
    then PermitColor:=False;
  end;

begin
  MouseSwitchOff;
  MouseOff;
  SpWidth:=WidthOfText(WFont,'000')+3; {Zjisti sirku pro mazani cisla}
  TanWidth:=WidthOfText(WFont,Vzkaz);  {Sirka pro pripad, ze text je dlouhy}
  {Pokud je text sirsi nez okno+cislo, sirka se bude odvijet od textu}
  If SpWidth+154<TanWidth then SpWidth:=TanWidth-150;
  NewImage(155+SpWidth,150+HeigthOfFont(WFont),Backup); {Alokace pameti}
  GetImage(SX,SY,155+SpWidth,150+HeigthOfFont(WFont),Backup); {Vyriznuti}
  Inc(SX,2);                            {Pak se nemusi moc pricitat}
  Inc(SY,12);
  NewMouseArea(SX,SY+1,141,141);        {Nastavi se promenne pro mys}
  {KOMPATIBILITA HRANIC}
  If (FrC2)or(ToC2)=-1 then begin FrC2:=FrC; ToC2:=ToC; end;
  If (FrC3)or(ToC3)=-1 then begin FrC3:=FrC; ToC3:=ToC; end;
  If (FrC4)or(ToC4)=-1 then begin FrC4:=FrC; ToC4:=ToC; end;
  {VYKRESLENI BAREVNYCH CTVERECKU A DALSIHO}
  RecTangle(SX-2,SY-HeigthOfFont(WFont)-2,154+SpWidth,149+HeigthOfFont(WFont),Fram); {Hlavni ramecek}
  Bar(SX-1,SY-HeigthOfFont(WFont)-1,152+SpWidth,147+HeigthOfFont(WFont),Tag);
  Color:=0;                             {Pocatecni barva}
  For LdX:=1 to 16 do
  begin
    LineX(SX,(LdX*9)+SY-10,143,SC);   {Prvni Xova carka mrizky}
    LineX(SX,(LdX*9)+SY-9,143,SC);    {Druha Xova carka mrizky}
    For LdY:=1 to 16 do
    begin
      LineY((LdX*9)+SX-9,SY,143,SC);  {Prvni Yova carka mrizky}
      LineY((LdX*9)+SX-10,SY,143,SC); {Druha Yova carka mrizky}
      If Not PermitColor then
      begin
        Bar((LdX*9)+SX-8,(LdY*9)+SY-8,7,7,Tag); {Zakazany ctverecek}
        {LineX((LdX*9)+SX-8,(LdY*9)+SY-5,7,Tfc);
        LineY((LdX*9)+SX-5,(LdY*9)+SY-8,7,Tfc);}
        Line((LdX*9)+SX-8,(LdY*9)+SY-8,(LdX*9)+SX-2,(LdY*9)+SY-2,Tfc);
        Line((LdX*9)+SX-2,(LdY*9)+SY-8,(LdX*9)+SX-8,(LdY*9)+SY-2,Tfc)
      end else
        Bar((LdX*9)+SX-8,(LdY*9)+SY-8,7,7,Color); {Ctverecek jiste barvy}
        Inc(Color);                     {Dalsi barva}
    end;
  end;
  RecTangle(SX-1,SY-1,146,146,SC); {Prvni ramecek}
  RecTangle(SX,SY,144,144,SC);     {Druhy ramecek}
  RecTangle(SX+152,SY+90,13,13,Fram);{Ramecek pro barvu}
  RecTangle(SX-2,SY-HeigthOfFont(WFont)-2,154+SpWidth,149+HeigthOfFont(WFont),Fram); {Celkovy ramecek}
  FonColor1:=Tfc; {Inicializace barvy fontu}
  PrintText(SX,SY-HeigthOfFont(WFont)-1,Vzkaz,WFont); {Vytisknuti zpravy}
  {KONEC CASTI VYKRESLUJICI OBRAZOVKU}
  MouseSwitchOn;                        {Obnovi mysku}
  Color:=1;
  Repeat
   OutOk:=False;                        {Znemozni chybny vystup}
   Repeat
   If InBar(MouseX,MouseY,SX,SY,143,143)and(OldColor<>Color)and
   (PermitColor) then
   begin
     Str(Color,ColStr);          {Prevod cisla na retezec}
     ClrNum;                     {Vymaze cislo}
     Bar(SX+153,SY+91,11,11,Color);                  {Zobrazi 2. barvu}
     PrintText(SX+150,SY+112,ColStr,WFont);           {Vytiskne dolni cislo}
     MouseSwitchOn;                                  {Zapne mys}
   end else
   If OldColor<>Color then
   begin
     ClrNum;
     PrintText(SX+150,SY+112,'No!',WFont);           {Vytiskne dolni nic}
     Bar(SX+153,SY+91,11,11,Tag);                   {Proskrtly ctverec}
     {LineY(SX+158,SY+91,11,Tfc);
     LineX(SX+153,SY+96,11,Tfc);}
     Line(SX+153,SY+91,SX+163,SY+101,Tfc);
     Line(SX+163,SY+91,SX+153,SY+101,Tfc);
     MouseSwitchOn;
   end;
   Color:=((MouseX-SX) div 9)*16+((MouseY-SY) div 9);
   MsKey:=MouseKey;                                 {Zjisti tlacitko}
   {Pokud je zmacknuta klavesnice, prevede se to na mys}
   If KeyPressed then
   begin
     Keyb:=ReadKey;
     If Keyb=#13 then MsKey:=1;
     If Keyb=#27 then MsKey:=2;
   end;
   Until MsKey<>0; {Opakovani, dokud se nestiskne tlacitko}
   If (MsKey=1)and(Not PermitColor) then
   begin
     Sound(100); {Pokud je oznacena barva nepouzitelna,}
     Delay(100);  {vybirani se opakuje}
     Nosound;
   end else OutOk:=True; {jinak konec}
   If MsKey=2 then begin OutOk:=True; Color:=-1; end; {umely konec}
  Until OutOk=True;
  MouseSwitchOff;             {Mys musi zapomenout svuj obrazek}
  PutImage(SX-2,SY-12,Backup);{Obnoveni poruseneho obrazku}
  NewMouseArea(0,0,319,199);  {Vraceni puvodnich hodnot mysi}
  MouseSwitchOn;              {Zapnuti}
  DisposeImage(Backup);       {Uvolneni pameti po vyrezu}
  ReadColor:=Color;           {Vystup funkce}
end;


procedure PutXorBar(X, Y, Sirka, Vyska : integer; Color : byte);
{ Nakresli xorovany (barvou Color) obdelnik X,Y,Sirka,Vyska }
begin
  if (Sirka = 0)or(Vyska = 0) then Exit;
  XorLineX(X, Y, Sirka, Color);
  XorLineX(X, Y+Vyska-1, Sirka, Color);
  if Vyska<=2 then Exit;
  XorLineY(X, Y+1, Vyska-2, Color);
  XorLineY(X+Sirka-1, Y+1, Vyska-2, Color);
end;

procedure InputHWXorBar(X, Y : integer;var Sirka, Vyska : integer; Color : byte);
{ Zada Sirku,Vysku ve Xorovanem obdelniku                          }
var oX, oY : integer;
    Key : char;
begin
  Repeat Until MouseKey=1;
  MouseSwitchOff;
  NewMouseArea(X+2, Y+1, 318-X, 198-Y);
  PutXorBar(X, Y, Sirka, Vyska, Color);
  repeat
    oX:= Sirka;
    oY:= Vyska;
    Sirka:= MouseX-X;
    Vyska:= MouseY-Y;
    if (oX<>Sirka)or(oY<>Vyska) then begin
      PutXorBar(X, Y, oX, oY, Color);
      PutXorBar(X, Y, Sirka, Vyska, Color);
    end;
    if KeyPressed then Key:=ReadKey;
  until (MouseKey=0)or(Key=#13);
  repeat until MouseKey=0;
  PutXorBar(X, Y, Sirka, Vyska, Color);
  NewMouseArea(0,0,319,199);
{  PopMouse;}
end;

procedure InputXYXorBar(var X, Y : integer; Sirka, Vyska : integer; Color : byte);
{ Zada X,Y ve XORovanem obdelniku                                     }
var oX, oY : integer;
    MouseWasOn : boolean;
    Key : char;
begin
{  PushMouse;
  MouseOff;}
  MouseSwitchOff;
  NewMouseArea(0, 0, 320-Sirka, 200-Vyska);
  PutXorBar(X, Y, Sirka, Vyska, Color);
  repeat
    oX:= X;
    oY:= Y;
    X:= MouseX;
    Y:= MouseY;
    if (oX<>X)or(oY<>Y) then begin
      PutXorBar(oX, oY, Sirka, Vyska, Color);
      PutXorBar(X, Y, Sirka, Vyska, Color);
    end;
    if KeyPressed then Key:=ReadKey;
  until (MouseKey=1)or(Key=#13);
{  repeat until MouseKey=0;}
  PutXorBar(X, Y, Sirka, Vyska, Color);
  NewMouseArea(0,0,319,199);
{  PopMouse;}
end;

procedure InputXorBar( var X, Y , sirka, vyska : integer; Color : byte);
{ Zada obdelnik a misto na obr.                                }
begin
  Sirka:=2;
  Vyska:=2;
  repeat until MouseKey=0;
  InputXYXorBar(X, Y, Sirka, Vyska, Color);
  InputHWXorBar(X, Y, Sirka, Vyska, Color);
end;

procedure RotatePal(Odkud, Dokud : byte; P : pointer); assembler;
{ Rotuje kus palety                                              }
asm
(*  push  ds
  xor   ch, ch
  mov   cl, Dokud
  mov   ax, cx
  sub   cl, Odkud
  or    cl, cl
  jz    @Konec
{    dec   cl
  inc   ax}
  mov   bx, ax
  shl   ax, 1
  add   ax, bx
{    dec  ax}
  lds   si, P
  add   si, ax
  mov   di, si
  sub   si, 3
  mov   ax, ds
  mov   es, ax
  mov   ax, cx
  shl   cx, 1
  add   cx, ax
{    dec cx}
  mov   bl, byte ptr es:[si]
  mov   ax, word ptr es:[si+1]
  std
  rep   movsb
  mov   byte ptr es:[di], bl
  mov   word ptr es:[di+1], ax
@Konec:
  pop   ds *)
  push  ds
  push  es
  mov   ds,word ptr ss:p+2
  mov   si,word ptr ss:p
  xor   ch,ch
  mov   cl,dokud
  sub   cl,odkud
  mov   ax,cx
  add   ax,ax
  add   cx,ax
  xor   ah,ah
  mov   al,odkud
  add   ax,ax
  add   al,odkud
  add   si,ax
  mov   di,si
  add   si,3
  mov   ax,ds
  mov   es,ax
  mov   ax,word ptr es:di               {sem se bude zapisovat}
  mov   bl,byte ptr es:di+2
  cld
  rep   movsb
  mov   word ptr ds:di,ax               {ponevadz se za posl. krokem provedl}
  mov   byte ptr ds:di+2,bl             {presun, je to ted cil a sem dame 1.}
  pop   es
  pop   ds
{!!!Bob konecne spraveno}
end;

procedure IntRotatePalRes; Interrupt;
{ rezidentni cast rotace palety                                 }
begin
  InLine($9C);
  OldRotateInt;
  Inc(WaitPal1);
  Inc(WaitPal2);
  Inc(WaitPal3);
  Inc(WaitPal4);
  if WaitPal1 = RotateProm[3] then begin
    RotatePal(RotateProm[1], RotateProm[2], RotatePointer);
    WaitPal1:= 0;
  end;
  if WaitPal2 = RotateProm[6] then begin
    RotatePal(RotateProm[4], RotateProm[5], RotatePointer);
    WaitPal2:= 0;
  end;
  if WaitPal3 = RotateProm[9] then begin
    RotatePal(RotateProm[7], RotateProm[8], RotatePointer);
    WaitPal3:= 0;
  end;
  if WaitPal4 = RotateProm[12] then begin
    RotatePal(RotateProm[10], RotateProm[11], RotatePointer);
    WaitPal4:= 0;
  end;
  SetPalette(RotatePointer);
end;

procedure DoneRotatePal;
{ Odstrani rezidentni rotaci palety                                }
begin
  if not RotatePalOn then Exit;
  SetIntVec($1C, @OldRotateInt);
  RotatePalOn := false;
end;

procedure InitRotatePal(Od1,Do1:Integer; W1:Byte; Od2,Do2:Integer; W2:Byte;
                        Od3,Do3:Integer; W3:Byte; Od4,Do4:Integer; W4:Byte;
                        P : pointer);
{ Inicilaizuje rezidentin rotaci palety                               }
begin
{Musel jsem to sem pro jednoduchou a bezchybnou praci dodat !}
  If (Od1=-1)or(Do1=-1) then begin Od1:=0; Do1:=0; end;
  If (Od2=-1)or(Do2=-1) then begin Od2:=0; Do2:=0; end;
  If (Od3=-1)or(Do3=-1) then begin Od3:=0; Do3:=0; end;
  If (Od4=-1)or(Do4=-1) then begin Od4:=0; Do4:=0; end;
  {$R-} {Tohle uz je posledni mozne reseni, jak to zprovoznit-jestli se
         to nekomu nelibi, tak ma smulu. Direktiva nicemu neskodi !}
  if RotatePalOn then DoneRotatePal;
  RotatePalOn := true;
  RotateProm[1]:=Od1;
  RotateProm[2]:=Do1;
  RotateProm[3]:=W1;
  RotateProm[4]:=Od2;
  RotateProm[5]:=Do2;
  RotateProm[6]:=W2;
  RotateProm[7]:=Od3;
  RotateProm[8]:=Do3;
  RotateProm[9]:=W3;
  RotateProm[10]:=Od4;
  RotateProm[11]:=Do4;
  RotateProm[12]:=W4;
  WaitPal1:= 0;
  WaitPal2:= 0;
  WaitPal3:= 0;
  WaitPal4:= 0;
  {$R+}
  RotatePointer:= P;
  GetIntVec($1C, @OldRotateInt);
  SetIntVec($1C, @IntRotatePalRes);
end;

procedure ChangePalete; assembler;
{ Stmavi( nebo sesvetli) paletu                                 }
asm
        mov  ax,del
        mov  word ptr cs:[@delka],ax
        push ds
        cmp  par,0
        jz   @on
@off:   mov  par, 255
        mov  byte ptr cs:[@inc_dec],-1
        mov  byte ptr cs:[@comp],-1
        jmp  @loop
@on:    mov  byte ptr cs:[@inc_dec],1
        mov  byte ptr cs:[@comp], 255
@loop:  mov  bl,par
        mov  bh, 255
        lds si,paleta
        mov  word ptr cs:[@pal],si
@set:   mov  si,word ptr cs:[@pal]
        xor  cx,cx
@do:    mov  dx,03c8h
        mov  ax,cx
        out  dx,al
        inc  dx
        lodsb
        mul  bl
        div  bh
        out  dx,al
        lodsb
        mul  bl
        div  bh
        out  dx,al
        lodsb
        mul  bl
        div  bh
        out  dx,al
        inc  cx
        cmp cx, 256
        jnz @do
        mov  cx,word ptr cs:[@delka]
@q:     push cx
        mov cx,03fh
@q1:    loop @q1
        pop  cx
        loop @q
        add  bl,byte ptr cs:[@inc_dec]
        cmp  bl,byte ptr cs:[@comp]
        jnz @set
        jmp @konec
@comp:    db 0
@inc_dec: db 0
@pal:     dw 0
@delka:   dw 1
@konec:   pop ds
end;

procedure ChangeBlockPalete(odkud,kam,par:byte;del:word;paleta:pointer); assembler;
{ Stmavi( nebo sesvetli) cast palety                                 }
asm
        mov  al,kam
        mov  byte ptr cs:[@kamm],al
        mov  al,odkud
        mov  byte ptr cs:[@odkudd],al
        mov  ax,del
        mov  word ptr cs:[@delka],ax
        push ds
        cmp  par,0
        jz   @on
@off:   mov  par,255
        mov  byte ptr cs:[@inc_dec],-1
        mov  byte ptr cs:[@comp],-1
        jmp  @loop

@on:    mov  byte ptr cs:[@inc_dec],1
        mov  byte ptr cs:[@comp],255

@loop:  mov  bl,par
        mov  bh,255
        lds  si,paleta
        xor  ax,ax
        mov  al,byte ptr cs:[@odkudd]
        add  si,ax
        add  si,ax
        add  si,ax
        mov  word ptr cs:[@pal],si

@set:   mov  si,word ptr cs:[@pal]
        xor  cx,cx
        mov  cl,byte ptr cs:[@odkudd]
@do:    mov  dx,03c8h
        mov  ax,cx
        out  dx,al
        inc  dx
        lodsb
        mul  bl
        div  bh
        out  dx,al
        lodsb
        mul  bl
        div  bh
        out  dx,al
        lodsb
        mul  bl
        div  bh
        out  dx,al
        inc  cx
        cmp cl,byte ptr cs:[@kamm]
        jnz @do
        mov  cx,word ptr cs:[@delka]
@q:     push cx
        mov cx,03fh
@q1:    loop @q1
        pop  cx
        loop @q
        add  bl,byte ptr cs:[@inc_dec]
        cmp  bl,byte ptr cs:[@comp]
        jnz @set
        jmp @konec
@comp:    db 0
@inc_dec: db 0
@pal:     dw 0
@delka:   dw 1
@odkudd:  db 0
@kamm:    db 0
@konec:   pop ds
end;

function MaxByte(A1,A2:byte):byte;
{vraci vetsi ze 2 cisel}
begin
  if A1>A2
    then MaxByte:=A1
    else MaxByte:=A2
end;

function MaxInteger(A1,A2:integer):integer;
{vraci vetsi ze 2 cisel}
begin
  if A1>A2
    then MaxInteger:=A1
    else MaxInteger:=A2
end;

function MinByte(A1,A2:byte):byte;
{vraci mensi ze 2 cisel}
begin
  if A1<A2
    then MinByte:=A1
    else MinByte:=A2
end;

function MinInteger(A1,A2:integer):integer;
{vraci mensi ze 2 cisel}
begin
  if A1<A2
    then MinInteger:=A1
    else MinInteger:=A2
end;

function CopyFile(Source, Destination : string) : boolean;
var f1, f2 : file;
    Size1, Size2 : word;
    Block : pointer;
begin
  CopyFile:= false;
  Size1:= 32000;
  Assign(f1,Source);
  ReSet(f1,1);
  if ioresult<>0 then exit;
  Assign(f2,Destination);
  ReWrite(f2,1);
  if IOResult<>0 then exit;
  GetMem(Block,Size1);
  repeat
    BlockRead(f1, Block^, Size1, Size2);
    BlockWrite(f2, Block^, Size2);
  until Size1<>Size2;
  FreeMem(Block,Size1);
  Close(f2);
  Close(f1);
  CopyFile:=true;
end;

function DeleteFile(Name : string) : boolean;
var f : file;
begin
 Assign(F, Name);
 Reset(F);
 if IOResult <> 0
 then DeleteFile:= False
 else begin
   Close(F);
   Erase(F);
   DeleteFile:= True;
 end;
end;

function  ExistFile(Name : string) : boolean;
var f : file;
begin
  Assign(f, Name);
  Reset(f);
  if IOResult<>0 then ExistFile:= false
  else begin
    ExistFile:= true;
    Close(f);
  end
end;

function  GetSizeImage(p : pointer) : word;
begin
  GetSizeImage:=(PWordArray(p)^[0]*PWordArray(p)^[1]+4);
end;

function UpperCase(ret:string):string;
var i:byte;
begin
  for i:=1 to length(ret) do
    ret[i]:=upcase(ret[i]);
  uppercase:=ret
end;

function Stencil(xx,yy : integer;var barvy : TStencilColor;c1,c2,c3,c4,c5 : byte) : boolean;
const sirkaxxx : byte = 9; {13=(SirkaXXX+4)}
      vyskayyy : byte = 8; {11=vyskaxxx+3}

var key : char;
    i, f : integer;
    obr : pointer;
    new, closee : boolean;

 procedure ShowBorder;
 var x,y : byte;
 begin
   MouseSwitchOff;
   bar(xx,yy,(SirkaXXX+4)*16+8,(VyskaYYY+3)*16+8,{0}c3);
   bar(xx+2,yy+2,(SirkaXXX+4)*16+2,(VyskaYYY+3)*16+2,{15}c4);
   for x:=0 to 15 do for y:=0 to 15 do
     bar(xx+4+x*(SirkaXXX+4),yy+4+y*(VyskaYYY+3),SirkaXXX,VyskaYYY,y+x*16);
   MouseSwitchOn;
 end;
 procedure ShowTag;
 var x,y : byte;
 begin
   MouseSwitchOff;
   for x:=0 to 15 do for y:=0 to 15 do
     if barvy[y+x*16]=0
       then bar(xx+3+x*(SirkaXXX+4),yy+4+y*(VyskaYYY+3),2,VyskaYYY,{15}c2)
       else bar(xx+3+x*(SirkaXXX+4),yy+4+y*(VyskaYYY+3),2,VyskaYYY,{0}c1);
   MouseSwitchOn;
   New:=false;
 end;
 procedure InsertTagBar(kde : integer;jak : boolean);
 const
     MaxC = 15;
 var f : byte;
     R, G, B : integer; {nevim jestli je to spravne serazeno (RGB) }
 begin
   R:=PPalette(Palette)^[kde*3];
   G:=PPalette(Palette)^[kde*3+1];
   B:=PPalette(Palette)^[kde*3+2];
   for f:=kde to {x+15}255 do begin
     if (abs(R-PPalette(Palette)^[f*3])<MaxC)and
        (abs(G-PPalette(Palette)^[f*3+1])<MaxC)and
        (abs(B-PPalette(Palette)^[f*3+2])<MaxC)
       then begin
         if jak then barvy[f]:=1 else barvy[f]:=0;
         R:=PPalette(Palette)^[f*3];
         G:=PPalette(Palette)^[f*3+1];
         B:=PPalette(Palette)^[f*3+2];
       end else Break;
   end;
   R:=PPalette(Palette)^[kde*3];
   G:=PPalette(Palette)^[kde*3+1];
   B:=PPalette(Palette)^[kde*3+2];
   for f:=kde downto {x}0 do begin
     if (abs(R-PPalette(Palette)^[f*3])<MaxC)and
        (abs(G-PPalette(Palette)^[f*3+1])<MaxC)and
        (abs(B-PPalette(Palette)^[f*3+2])<MaxC)
       then begin
         if jak then barvy[f]:=1 else barvy[f]:=0;
         R:=PPalette(Palette)^[f*3];
         G:=PPalette(Palette)^[f*3+1];
         B:=PPalette(Palette)^[f*3+2];
       end else Break;
   end;
 end;
var mmx,mmy : integer;
begin
  for mmx:=0 to 767 do
    palette^[mmx]:=palette^[mmx] and $3f;
  setpalette(palette);
  MouseSwitchOff;
  NewImage(16*(SirkaXXX+4)+8,16*(VyskaYYY+3)+8,obr);
  GetImage(xx,yy,16*(SirkaXXX+4)+8,16*(VyskaYYY+3)+8,obr);
  ShowBorder;
  ShowTag;
  Closee:=true;
  repeat
    mmy:=mousey;
    mmx:=mousex;
    if keypressed then begin Key:=ReadKey; new:=true end else Key:=#0;
    case UpCase(key) of
      'I' : for f:=0 to 255 do if barvy[f]<>0
              then barvy[f]:=0
              else barvy[f]:=1;
      'C' : for f:=0 to 255 do barvy[f]:=0;
      'T' : for f:=0 to 255 do barvy[f]:=1;
      '+' : inserttagbar(i,true);
      '-' : inserttagbar(i,false);
      '/' : if vyskaYYY<>1 then begin
              MouseSwitchOff;
              PutImage(xx,yy,obr);
              disposeImage(obr);
              dec(vyskaYYY);
              dec(sirkaXXX);
              NewImage(16*(SirkaXXX+4)+8,16*(VyskaYYY+3)+8,obr);
              GetImage(xx,yy,16*(SirkaXXX+4)+8,16*(VyskaYYY+3)+8,obr);
              ShowBorder;
              ShowTag;
              MouseSwitchOn;
            end;
      '*' : if vyskaYYY<>8 then begin
              MouseSwitchOff;
              PutImage(xx,yy,obr);
              disposeImage(obr);
              inc(vyskaYYY);
              inc(sirkaXXX);
              NewImage(16*(SirkaXXX+4)+8,16*(VyskaYYY+3)+8,obr);
              GetImage(xx,yy,16*(SirkaXXX+4)+8,16*(VyskaYYY+3)+8,obr);
              ShowBorder;
              ShowTag;
              MouseSwitchOn;
            end;
      #59 : begin key:=#27; closee:=false; end;
    end;
    if not InBar(mmx,mmy,xx+4,yy+4,16*(SirkaXXX+4),16*(VyskaYYY+3))
      then i:=getpixel(mmx,mmy)
      else i:=((mmy-4-yy) div (VyskaYYY+3))+((mmx-4-xx) div (SirkaXXX+4))*16;
    if (InBar(mmx,mmy,xx,yy,16*(SirkaXXX+4)+8,3))and(MouseKey=1) then begin
      repeat until MouseKey=0;
      MouseSwitchOff;
      PutImage(xx,yy,obr);
      InputXYXorBar(XX, YY, 16*(SirkaXXX+4)+8,16*(VyskaYYY+3)+8, 45);
      GetImage(xx,yy,16*(SirkaXXX+4)+8,16*(VyskaYYY+3)+8,obr);
      ShowBorder;
      ShowTag;
      MouseSwitchOn;
    end;
    if InBar(mmx,mmy,xx+4,yy+4,16*(SirkaXXX+4),16*(VyskaYYY+3))
      then if mousekey<>0 then begin
        MouseSwitchOff;
        i:=getpixel(mmx,mmy);
        MouseSwitchOn;
      end else i:=((mmy-4-yy) div (VyskaYYY+3))+((mmx-4-xx) div (SirkaXXX+4))*16;
    case MouseKey of
      1 : if (i>=0)and(barvy[i]<>1) then begin barvy[i]:=1; new:=true; end;
      2 : if (i>=0)and(barvy[i]<>0) then begin barvy[i]:=0; new:=true; end;
      3,4 : Key:=#27;
    end;

    if new then ShowTag;
  until key=#27;
  MouseSwitchOff;
  PutImage(xx,yy,obr);
  DisposeImage(obr);
  MouseSwitchOn;
  repeat until MouseKey=0;
  Stencil:=closee;
end;

procedure RemapDColor(var c:byte; newpal, oldpal : pointer);
type tbyte = array[0..767] of byte;
     pb = ^tbyte;
var i, color : integer;
    min, rozdil, r1, r2, r3 : longint;
begin
  min:=maxlongint;
  color:=c;
  for i:=0 to 255 do begin
    r1:=longint((pb(newpal)^[i*3])and $3f)-(pb(oldpal)^[color*3]and $3f);
    r2:=longint((pb(newpal)^[i*3+1])and $3f)-(pb(oldpal)^[color*3+1]and $3f);
    r3:=longint((pb(newpal)^[i*3+2])and $3f)-(pb(oldpal)^[color*3+2]and $3f);
    rozdil:=sqr(r1)+sqr(r2)+sqr(r3);

    if rozdil<min then begin
      c:=i;
      min:=rozdil;
    end;
  end;
end;

end.