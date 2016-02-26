unit cg2_util;

interface

uses crt, prn256_3, tool256, mouse;

function CheckPath(var path : string; prip : string ):boolean;
function GrMenu(X1,Y1:Word;Vyber:String):Byte;
procedure Ramecek(X1,Y1,X2,Y2:Word;Color,Back:Byte);
procedure XorBar(X ,Y ,Sirka, Vyska : Word);
procedure WaitMouse;
procedure RectXor (X,Y,Sirka,Vyska:Word);
procedure InputRectXor(Var X,Y,sirka,vyska:Word);
procedure RepWindowed(report : string);
procedure WindowedInput(var text : string );
procedure WindowedAddInput(var text : string );

implementation
var
  Zaloha : _bmptr ;


function CheckPath(var path : string; prip : string ):boolean;

var
   tecka : byte;                { pozice tecky v path and file name }

begin
{ Nejdriv najdu, kde je pripona - hledam tecku='.' }
   tecka := Pos('.', path );

  { Jestlize pripona neexistuje, pridam  p r i p  }
   if(tecka=0) then begin
      path := path+ '.'+prip;
      tecka := Pos('.', path );
      end;

  { V pripade, ze je pripona delsi>3znaky, zkratim ji }
   if(tecka < byte(path[0])-3) then byte(path[0]) := tecka+3;

   CheckPath := (Copy(path, tecka+1, 3) = prip);
end;


procedure Ramecek(X1,Y1,X2,Y2:Word;Color,Back:Byte);

Var
  Cyklus,Cyklus1:Word;

Begin

  Bar(X2-X1,Y2-Y1,X1,Y1,Back);

  For Cyklus:=X1 To X2 Do
  Begin
    PutPixel(Cyklus,Y1,Color);
    PutPixel(Cyklus,Y2,Color);
  End;

  For Cyklus:=Y1 To Y2 Do
  Begin
    PutPixel(X1,Cyklus,Color);
    PutPixel(X2,Cyklus,Color);
  End;

End;


function GrMenu(X1,Y1:Word;Vyber:String):Byte;

Var Cyklus,Last,Y2,X2,Radek,Enter : Byte;
    XPos,YPos : Word;
    Key : Char;

Begin
  Radek:=1;
  Y2:=Y1+3;
  Last:=1;
  X2:=0;
  For Cyklus:=1 To Length(Vyber) Do
    If Vyber[Cyklus]=#124 Then
    Begin
      Y2:=Y2+FonHeight+1;
      If X2<WidthOfTextPart(Last,Cyklus,Vyber) Then
        X2:=WidthOfTextPart(Last,Cyklus,Vyber);
        Last:=Cyklus;
    End;
    X2:=X1+X2;
  GetMem(Zaloha,(X2-X1)*(Y2-Y1));
  MouseOff;
  GetImage(X2-X1+1,Y2-Y1+1,X1,Y1,Zaloha);
  Ramecek(X1,Y1,X2,Y2,25,31);
  Ramecek(X1+1,Y1+1,X2-1,Y1+12,25,31);
  PosX:=X1+2;
  PosY:=Y1+2;
  Last := 1;
  for Cyklus:=1 To Length(Vyber) do begin
    if Vyber[Cyklus]=#124 then begin
      Bar(X2-X1-3,FonHeight,X1+2, PosY, Font^[140]);
      PrintMaskTextPart(Last,Cyklus-1,Vyber);
      PosY:=PosY+FonHeight+1;
      if Last=1 then Inc(PosY);  {Pokud jde o nadpis, vynechame 2 radky}
      Last := Cyklus+1;
      PosX:=X1+2;
    end;
  end;
  DarkBar(X2-X1-3,FonHeight,X1+2,Y1+(FonHeight+1)*Radek+3,2);
  MouseOn;
  Repeat
    M_X:=MouseX;
    M_Y:=MouseY;
    If (M_x>X1) And (M_x<X2) And (M_y>Y1+11) And (M_y<Y2-3) And
       ((M_y<(Y1+(FonHeight+1)*Radek)) Or (M_y>(Y1+(FonHeight+1)*(Radek+1)))) Then
    Begin
      MouseOff;
      DarkBar(X2-X1-3,FonHeight,X1+2,Y1+(FonHeight+1)*Radek+3,-2);
      Radek:=(Mousey-Y1) div (FonHeight+1);
      DarkBar(X2-X1-3,FonHeight,X1+2,Y1+(FonHeight+1)*Radek+3,2);
      MouseOn;
    End;
  Until MouseKey=1;
  WaitMouse;
  GrMenu:=0;
  if InArea(X2-X1+1,Y2-Y1+1,X1,Y1)then GrMenu:=Radek;
  Delay(100);
  MouseOff;
  PutImage(X2-X1+1,Y2-Y1+1,X1,Y1,Zaloha);
  MouseOn;
  FreeMem(Zaloha,(X2-X1)*(Y2-Y1));;
End;

procedure XorBar(X ,Y ,Sirka, Vyska : Word);

var
   ofsadr : word;

begin

   if (x<0) or (y<0) or (sirka<1) or (vyska<1) then exit;

   ofsadr := y*320+x;           {radek*320+sloupec...}

   asm
       push ds
       push es
       push di
       push si
       mov di,ofsadr            {ofs.adr. zacatku baru ve VRAM}
       mov si,di
       mov cx,vyska             {pocitadlo radku baru}
       mov dx,sirka             {sirka baru}
       mov ax,0a000h            {adr. segmentu videoram}
       mov es,ax
       push es
       pop ds
       cld                      {movs.. bude zvysovat...}
    @line:
       push cx
       push di
       mov cx,dx                {cx=sirka : vyplnime sirku baru}
    @radek:
       lodsb
       xor al,255
       stosb                {presun vyplne}
       loop @radek

       pop di
       add di,320               {posuv adresy na dalsi  radek}
       mov si,di
       pop cx
       loop @line               {dalsi radek}

       pop si
       pop di
       pop es
       pop ds

   end;
end;      



procedure WaitMouse;

Var Key : Char;

Begin
  While Keypressed Do Key:=ReadKey;
  Repeat Until (MouseKey=1) Or KeyPressed;
  If MouseKey=1 Then Repeat Until (MouseKey=0);
End;

procedure RectXor (X,Y,Sirka,Vyska:Word);

Begin
  XorBar(X,Y,Sirka,1);
  XorBar(X,Y+Vyska,Sirka,1);
  XorBar(X,Y+1,1,Vyska-1);
  XorBar(X+Sirka,Y,1,Vyska+1);
End;

procedure InputRectXor(Var X,Y,sirka,vyska:Word);

Var Lastx,Lasty : Word;

Begin
  MouseOn;
  Repeat
    X:=MouseX;
    Y:=MouseY;
  Until MouseKey=1;
  WaitMouse;
  Lastx:=X;
  Lasty:=Y;
  mouseoff;
  mousearea(x*2,318,y,198);
  delay(100);
  RectXor(x,y,1,1);
  Repeat
    sirka:=MouseX;
    vyska:=MouseY;
    if ((lastx<>sirka) or (lasty<>vyska)) and
       (sirka>=x) and (vyska>=y) and (vyska<200) and (sirka<320) then
    begin
      RectXor(x,y,lastx-x+1,lasty-y+1);
      RectXor(x,y,sirka-x+1,vyska-y+1);
      lastx:=sirka;
      lasty:=vyska;
    End;
  Until MouseKey=1;
  WaitMouse;
  RectXor(x,y,lastx-x+1,lasty-y+1);
  mousearea(0,319,0, 198);
  MouseOn;
  sirka:=sirka+2-X;
  vyska:=vyska+2-Y;
End;


procedure RepWindowed(report : string);
var
  w_wid, w_hig : word;          {sirka a vyska edit. okna}
  win_x : word;                 { x-ova souradnice okna }
  savedscr : _bmptr;            { uschovana obrazovka  }
const
  win_y : word = 50;                   { y-ova sourad. okna }

begin
  MouseOff;
  w_wid := WidthOfText(report)+2*byte(Font^[0]);
  w_hig := FonHeight+8;
  win_x := (320-w_wid) div 2;
  GetMem(savedscr, w_wid*w_hig);
  GetImage(w_wid, w_hig, win_x, win_y, savedscr );

  Bar(w_wid, w_hig, win_x, win_y, 25 );
  Bar(w_wid-4, w_hig-4, win_x+2, win_y+2, 30 );
  Bar(w_wid-6, w_hig-6, win_x+3, win_y+3, Font^[140] );

  SetXY(win_x+5, win_y+5 );
  PrintText(report);
  MouseOn;
  repeat until KeyPressed or(MouseKey=1);
  MouseOff;

  PutImage(w_wid, w_hig, win_x, win_y, savedscr );
  FreeMem(savedscr, w_wid*w_hig);
  MouseOn;
end;


procedure WindowedInput(var text : string );
var
  w_wid, w_hig : word;          {sirka a vyska edit. okna}
  win_x : word;                 { x-ova souradnice okna }
  savedscr : _bmptr;            { uschovana obrazovka  }
const
  win_y : word = 50;            { y-ova sourad. okna }

begin
  MouseOff;
  byte(text[0]):=30;
  w_wid := FonWidth*(byte(text[0])+1)+8;
  w_hig := FonHeight+8;
  win_x := (320-w_wid) div 2;
  GetMem(savedscr, w_wid*w_hig);
  GetImage(w_wid, w_hig, win_x, win_y, savedscr );

  Bar(w_wid, w_hig, win_x, win_y, 25 );
  Bar(w_wid-4, w_hig-4, win_x+2, win_y+2, 30 );
  Bar(w_wid-6, w_hig-6, win_x+3, win_y+3, Font^[140] );

  SetXY(win_x+5, win_y+5 );
  InputText(text);

  PutImage(w_wid, w_hig, win_x, win_y, savedscr );
  FreeMem(savedscr, w_wid*w_hig);
  MouseOn;

end;




procedure WindowedAddInput(var text : string );
var
  w_wid, w_hig : word;          {sirka a vyska edit. okna}
  win_x : word;                 { x-ova souradnice okna }
  savedscr : _bmptr;            { uschovana obrazovka  }
const
  win_y : word = 50;            { y-ova sourad. okna }

begin
  MouseOff;
  w_wid := FonWidth*35+8;
  w_hig := FonHeight+8;
  win_x := (320-w_wid) div 2;
  GetMem(savedscr, w_wid*w_hig);
  GetImage(w_wid, w_hig, win_x, win_y, savedscr );

  Bar(w_wid, w_hig, win_x, win_y, 25 );
  Bar(w_wid-4, w_hig-4, win_x+2, win_y+2, 30 );
  Bar(w_wid-6, w_hig-6, win_x+3, win_y+3, Font^[140] );

  SetXY(win_x+5, win_y+5 );
  AddInputText(text, 40);

  PutImage(w_wid, w_hig, win_x, win_y, savedscr );
  FreeMem(savedscr, w_wid*w_hig);
  MouseOn;

end;


begin
end.
