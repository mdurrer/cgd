program correctwidth;  {upravuje sirku radku....}

uses dos, graph256;

const MaxWidth=300;
var inp, out: text; {puvodni, nove}
    DirInfo: SearchRec;
    s, name: string;
    i : byte;
    Big, Small: PFont;
    InExt, OutExt: string;

    {najdu uvozovku - k ni bud musi dvojtyecka (pred ni), nebo nic}
    {procedury- 1. nacti radek, je to zacatek? ne, znovu dle bodu 1.
        tiskni stary a nacti novy- je to konec? ne, dle bodu 2.
        jo, znovu dle bodu 1. az do konce vstupniho souboru}

function IsTitle(s: string): byte;
var ss : string;
    i : byte;
begin
  IsTitle:= 0;
  ss:=s;
  i:=1;
  if s[i]='{' then exit; {poznamku ignorujeme}
  for i:=1 to length(s) do ss[i]:=upcase(s[i]);
  if pos('TITLE ', ss)>0 then IsTitle:= pos('TITLE ', ss)+6;
end;

{vrati, kde zacina opravdicky text:}
function IsBegin(s: string): byte;
var i: byte;
    pos1, pos2: byte;
begin
  IsBegin:= 0;
  {pokud to byla poznamka, budeme ji ignorovat:}
  if s[i]='{' then exit;    {na poznamku vraci 0}
(*  {nejdriv, jestli nejde o titulek:}
  i:= IsTitle(s);
  if(i<>0)then begin
    IsBegin:= i;
    exit;
  end;*)
  {odrusime mezery, atd:}
  i:=1;
  while (s[i]=' ')or(s[i]=#9)or(s[i]=#13) do inc(i);
  {musi tam byt uvozovky a pred nimi dvojtecka:}
  pos2:= pos('"', s);
  pos1:= pos(':', s);
  if(pos1<>0)and(pos2<>0)and(pos1<pos2) then begin
    {hura, byly tam!}
    {mezi dvojteckou a uvozovkama muze byt jedine volne misto:}
    for i:= pos1+1 to pos2-1 do if not((s[i]=' ')or(s[i]=#9)or(s[i]=#13)) then exit;
    IsBegin:= pos2+1;
  end;
end;

function IsEnd(s: string; var ends_string: boolean): byte;
var i: byte;
begin
  i:= Length(s);
  while (s[i]=' ')or(s[i]=#9)or(s[i]=#13) do dec(i);
  ends_string := s[i] = '"';
  Dec(i, byte(ends_string)); {kdyby tim koncil retezec, este tu zavorku ubereme...}
  IsEnd:= i;
end;

{rozdelime radek na pripadne dva radky:}
function AdjustWidth(var s: string; first, last: byte; font: PFont): byte;
var ss: string;
    j: byte;
begin
  j:= last;
  AdjustWidth:= j; {to vracime kvuli titulku}
  {jedeme od zadu, najdeme, co se jeste vleze:}
  while(WidthOfTextPart(font, s, first, j, false)>MaxWidth)and(j>first) do dec(j);
  if j=last then exit; {vleze se to}
  while(s[j]<>' ')and(j>first) do dec(j); {najdeme prvni mezeru}
  if s[j]=' ' then s[j]:= '|'; {dame tam nase 'CR', ktery to rozpuli }
  AdjustWidth:= j; {to vracime kvuli titulku}
end;

procedure Process;
var command_mode: boolean;
    tmp: byte;
begin
  assign(inp, name);
  reset(inp);
  name[Length(name)]:= OutExt[3];
  name[Length(name)-1]:= OutExt[2];
  name[Length(name)-2]:= OutExt[1];
  assign(out, name);
  rewrite(out);
  command_mode := true;
  repeat
    readln(inp,s);
    if not command_mode then begin
      {this and the related code added by Robert Spalek on 2010-06-21.}
      tmp := 1;
      while (tmp <= length(s)) and (s[tmp] in [' ', #9]) do
        inc(tmp);
      AdjustWidth(s, tmp, IsEnd(s, command_mode), Big);
    end else if IsTitle(s)>0 then begin
      i:= AdjustWidth(s, IsTitle(s), IsEnd(s, command_mode), Small); {az pokud se titulek vejde}
      if i<IsEnd(s, command_mode) then begin
        writeln(s);
        s[0]:= char(i+2); s[i]:= '.'; s[i+1]:= '.';  s[i+2]:= '.';  {ukoncime trema teckama...}
        writeln(s);
      end;
      command_mode := true;
    end else begin
      if IsBegin(s)>0 then AdjustWidth(s, IsBegin(s), IsEnd(s, command_mode), Big);
    end;
    {poznamku nechame netknutou:}
    writeln(out, s);
  until eof(inp);
  close(inp);
  close(out);
end;

begin
  InExt:= ParamStr(1);
  OutExt:= ParamStr(2);
  if(ParamCount<>2)or(Length(InExt)<>3)or(Length(OutExt)<>3) then begin
    writeln('Uprava sirky radku. Parametry: <3 zn. pripona vstup> <3 zn. pripona vystup>');
    halt;
  end;
  RegisterFont(Big, 'big.fon');
  RegisterFont(Small, 'small.fon');
  FindFirst('*.'+InExt, AnyFile, DirInfo); { Same as DIR *.PAS }
  while DosError=0 do begin
    Writeln(DirInfo.Name);
    name:= DirInfo.Name;
    Process;
    FindNext(DirInfo);
  end;
  DisposeFont(Big);
  DisposeFont(Small);

  writeln('Vsechno je v oukeju.');
end.

