
unit prn256_3;

interface

uses dos,tool256;

type
    _TextArray = array[0..2000] of char;

    _font = array[0..32983] of byte;
    _fontptr = ^_font;

var
     TextNT : _TextArray;

     reg : registers;
     Font : _fontptr;
     FonWidth, FonHeight : byte;
     PosX, PosY : word;

function PressedKey : byte;
function WaitKey : byte;


{ jestlize je v nazvu procedury  "NT", jedna se o proceduru,
  operujici s daty typu _TextArray...   NT = null terminated  }


function LengthOfNT(text : _TextArray ) : word;
procedure AddTextToNT(src_text : string; var dst_text : _TextArray );
procedure PutTextToNT(src_text : string; var dst_text : _TextArray );
procedure AddNTString(first,last: word; src_text : _TextArray; var dst_text : string );
procedure PutNTString(first,last: word; src_text : _TextArray; var dst_text : string );

function WidthOfText(text : string) : word;
function WidthOfTextPart(first,last : byte; text : string) : word;
function WidthOfTextNTPart(first,last : word; text : _TextArray) : word;

procedure PrintChar(x, y : word; znak : byte );
procedure PrintMaskChar(x, y : word; znak : byte );
procedure PrintCharRAM(x, y : word; znak : byte; sirka: word; dest: _bmptr );
procedure PrintMaskCharRAM(x, y : word; znak : byte; sirka: word; dest: _bmptr );

procedure PrintText(text : string );
procedure PrintMaskText(text : string );
procedure PrintTextRAM(text : string; sirka: word; dest: _bmptr );
procedure PrintMaskTextRAM(text : string; sirka: word; dest: _bmptr );

procedure PrintTextPart(first,last : byte; text : string );
procedure PrintMaskTextPart(first,last : byte; text : string );
procedure PrintTextPartRAM(first,last : byte; text : string; sirka: word; dest: _bmptr );
procedure PrintMaskTextPartRAM(first,last : byte; text : string; sirka: word; dest: _bmptr );
procedure PrintMaskTextNTPartRAM(first,last : word; text : _TextArray; sirka: word; dest: _bmptr );

procedure InputText(var text : string );
procedure AddInputText(var text : string; delka : byte );
procedure RegisterFont( var fontik : _fontptr; path : string );
procedure ChooseFont(var fontik : _fontptr );
procedure SetXY(x, y : word);


implementation


function PressedKey : byte;

begin
      reg.ah:=8;
      intr($21, reg );
      PressedKey := reg.al;
end;


function WaitKey : byte;

begin
      reg.ax:=$0c08;
      intr($21, reg );
      WaitKey := reg.al;
end;


function LengthOfNT(text : _TextArray ) : word;
var
   f : word;
begin
   f := 0;
   while(text[f]<>#0) do Inc(f);
   LengthOfNT := f;
end;



procedure AddTextToNT(src_text : string; var dst_text : _TextArray );

{ Prida text ze stringu na konec _TextArray (pripoji za nulu) }

var
   f : word;            {pozice v cilovem retezci}
   g : word;            {pocitadlo prenasenych znaku}
begin
   f:= 0;
   while(dst_text[f]<>#0) do Inc(f);
   for g:= 1 to Length(src_text) do
      dst_text[f+g-1] := src_text[g];
   dst_text[f+g]:=#0;
end;




procedure PutTextToNT(src_text : string; var dst_text : _TextArray );

{ Prenese text ze stringu na zacatek _TextArray }

var
   g : byte;            {pocitadlo prenasenych znaku}
begin
   for g:= 0 to Length(src_text) do
      dst_text[g] := src_text[g+1];
   dst_text[g]:=#0;
end;


procedure AddNTString(first,last: word; src_text : _TextArray; var dst_text : string );
{ Prida cast textu z  _TextArray na konec stringu }

var
   f : word;            {pozice v cilovem retezci}
begin
   for f:= first to last do
      dst_text[f-first+Length(dst_text)+1] := src_text[f];
   byte(dst_text[0]):= Length(dst_text)+byte(last-first)+1;
end;


procedure PutNTString(first,last: word; src_text : _TextArray; var dst_text : string );
{ Prenese cast textu z _TextArray do stringu }

var
   f : word;                   {pozice ve zdroj. retezci}
begin
   for f:= first to last do
      dst_text[f-first+1] := src_text[f];
   byte(dst_text[0]):= byte(last-first)+1;
end;


function WidthOfText(text : string) : word;
var
   f : byte;
   sum : word;
begin
   sum := 0;
   for f := 1 to byte(text[0]) do sum := sum+Font^[byte(text[f])-30];
   WidthOfText := sum;
end;


function WidthOfTextPart(first,last : byte; text : string) : word;
var
   f : byte;
   sum : word;
begin
   sum := 0;
   for f := first to last do begin
     sum := sum+Font^[byte(text[f])-30];
   end;
   WidthOfTextPart := sum;
end;


function WidthOfTextNTPart(first,last : word; text : _TextArray) : word;
var
   f, sum : word;
begin
   sum := 0;
   for f := first to last do sum := sum+Font^[byte(text[f])-30];
   WidthOfTextNTPart := sum;
end;



procedure PrintChar(x, y : word; znak : byte );

begin
  PutImage(FonWidth,FonHeight,x,y,Addr(font^[(FonWidth*FonHeight*(znak-32)+140)]));
end;


procedure PrintMaskChar(x, y : word; znak : byte );

begin
  PutMaskImage(FonWidth,FonHeight,x,y,Addr(font^[(FonWidth*FonHeight*(znak-32)+140)]),Font^[140]);
end;


procedure PrintCharRAM(x, y : word; znak : byte; sirka: word; dest: _bmptr );

begin
  PutImageRAM(FonWidth,FonHeight,x,y,Addr(Font^[(FonWidth*FonHeight*(znak-32)+140)]), sirka, dest);
end;


procedure PrintMaskCharRAM(x, y : word; znak : byte; sirka: word; dest: _bmptr );

begin
  PutMaskImageRAM(FonWidth,FonHeight,x,y,Addr(font^[(FonWidth*FonHeight*(znak-32)+140)]),Font^[140], sirka, dest);
end;


procedure PrintText(text : string );

var
   f : byte;
begin
  for f := 1 to byte(text[0]) do begin
      PrintChar(PosX, PosY, byte(text[f]));
      PosX := PosX+word(Font^[byte(text[f])-30]);
  end;
end;


procedure PrintMaskText(text : string );

var
   f : byte;

begin
  for f := 1 to byte(text[0]) do begin
      PrintMaskChar(PosX, PosY, byte(text[f]));
      PosX := PosX+word(Font^[byte(text[f])-30]);
  end;
end;



procedure PrintTextRAM(text : string; sirka: word; dest: _bmptr );

var
   f : byte;
begin
  for f := 1 to byte(text[0]) do begin
      PrintCharRAM(PosX, PosY, byte(text[f]), sirka, dest);
      PosX := PosX+word(Font^[byte(text[f])-30]);
  end;
end;


procedure PrintMaskTextRAM(text : string; sirka: word; dest: _bmptr );

var
   f : byte;
begin
  for f := 1 to byte(text[0]) do begin
      PrintMaskCharRAM(PosX, PosY, byte(text[f]), sirka, dest);
      PosX := PosX+word(Font^[byte(text[f])-30]);
  end;
end;


procedure PrintTextPart(first,last : byte; text : string );

var
   f : byte;
begin
  for f := first to last do begin
      PrintChar(PosX, PosY, byte(text[f]));
      PosX := PosX+word(Font^[byte(text[f])-30]);
  end;
end;


procedure PrintMaskTextPart(first,last : byte; text : string );

var
   f : byte;

begin
  for f := first to last do begin
      PrintMaskChar(PosX, PosY, byte(text[f]));
      PosX := PosX+word(Font^[byte(text[f])-30]);
  end;
end;



procedure PrintTextPartRAM(first,last : byte; text : string; sirka: word; dest: _bmptr );

var
   f : byte;
begin
  for f := first to last do begin
      PrintCharRAM(PosX, PosY, byte(text[f]), sirka, dest);
      PosX := PosX+word(Font^[byte(text[f])-30]);
  end;
end;


procedure PrintMaskTextPartRAM(first,last : byte; text : string; sirka: word; dest: _bmptr );

var
   f : byte;
begin
  for f := first to last do begin
      PrintMaskCharRAM(PosX, PosY, byte(text[f]), sirka, dest);
      PosX := PosX+word(Font^[byte(text[f])-30]);
  end;
end;


procedure PrintMaskTextNTPartRAM(first,last : word; text : _TextArray; sirka: word; dest: _bmptr );

var
   f : word;
begin
  for f := first to last do begin
      PrintMaskCharRAM(PosX, PosY, byte(text[f]), sirka, dest);
      PosX := PosX+word(Font^[byte(text[f])-30]);
  end;
end;



procedure InputText(var text : string );

var
   f : byte;

begin

  f := 1;
  PrintChar(PosX, PosY, 127);

{ Vytisteni kurzoru na zacatek input-radku }

  byte(text[f]) := WaitKey;
{ Nactu prvni vstupni znak }

  while ( (byte(text[f])<>13) ) do begin
      if(byte(text[f])=8) then begin
         if(f>1) then begin
           PrintChar(PosX, PosY, 32);
         { Vymazu kurzor !!! - posledni znak se prepise novym kurzorem ! }

           f := f-1;
           PosX := PosX-word(Font^[byte(text[f])-30]);
           end;
      end else begin
       if not( (byte(text[f])<32) or (byte(text[f])>169) ) then begin
         if not(f>byte(text[0]))then begin
         PrintChar(PosX, PosY, byte(text[f]));
         PosX := PosX+word(Font^[byte(text[f])-30]);

        { Vytisteni znaku misto stareho kurzoru }

         f := f+1;end;
       end;
      end;
      PrintChar(PosX, PosY, 127);

     { Vytisteni noveho kurzoru }


      byte(text[f]) := WaitKey;

  end;
  text[0] := char(f-1);
end;


procedure AddInputText(var text : string; delka : byte );

var
  pos : byte;

begin

  PrintText(text);
  pos := Length(text)+1;
  PrintChar(PosX, PosY, 127);

{ Vytisteni kurzoru na zacatek input-radku }

  byte(text[pos]) := WaitKey;
{ Nactu prvni vstupni znak }

  while ( (byte(text[pos])<>13) ) do begin
      if(byte(text[pos])=8) then begin
         if(pos>1) then begin
           PrintChar(PosX, PosY, 32);
         { Vymazu kurzor !!! - posledni znak se prepise novym kurzorem ! }

           Dec(pos);
           PosX := PosX-word(Font^[byte(text[pos])-30]);
           end;
      end else begin
       if (byte(text[pos])>31)and(byte(text[pos])<170) then begin
         if (pos<=delka)then begin
         PrintChar(PosX, PosY, byte(text[pos]));
         PosX := PosX+word(Font^[byte(text[pos])-30]);

        { Vytisteni znaku misto stareho kurzoru }

         Inc(pos);end;
       end;
      end;
      PrintChar(PosX, PosY, 127);

     { Vytisteni noveho kurzoru }


      byte(text[pos]) := WaitKey;

  end;
  text[0] := char(pos-1);
end;



procedure RegisterFont( var fontik : _fontptr; path : string );

{ Nacteni a zaregistrovani dosud nenacteneho fontu }

var
   fontfile : file;

begin
   Assign(fontfile, path);
   Reset(fontfile, 1);
   BlockRead(fontfile, FonWidth, 1);
   BlockRead(fontfile, FonHeight, 1);
   GetMem(fontik, FonWidth*FonHeight*138+140 );
   BlockRead(fontfile, fontik^[2], FonWidth*FonHeight*138+138);
   Close(fontfile);
   fontik^[0] := FonWidth;
   fontik^[1] := FonHeight;
   Font := Addr(fontik^[0]);       { aktualni font je prave nacteny }
end;

procedure ChooseFont(var fontik : _fontptr );

begin
   Font := Addr(fontik^[0]);       { zmenim ukazatel aktualniho fontu }
   FonWidth := fontik^[0];
   FonHeight := fontik^[1];
end;

procedure SetXY(x, y : word);

begin
    PosX := x;
    PosY := y;
end;


begin
end.
