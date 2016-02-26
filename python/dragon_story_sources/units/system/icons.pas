unit icons;

interface

type  Icons1 = record
                X, Y : integer;
                Sirka, Vyska  : word;
                Inf  : byte;
                P    : pointer;
                OldP : pointer;
                WhatObj : integer;
              end;
      Icons2 = array[0..255] of Icons1;
var BufIcons : ^Icons2;

procedure InitIcons(Max : byte);
procedure DoneIcons;

function  AddIcons(P : pointer; X, Y : integer; Inf : byte) : byte;
procedure DelIcons(What : byte);

function  TestIcons(NoClick, NeniNaIkone : byte) : byte;

procedure ClearIcons(Bez : byte);
procedure DrawIcons(Bez : byte; Save : boolean);

implementation

uses Graph256,users;

var MaxIcons : byte;


function NajdiNejmensi(var min : integer) : integer;
var M : integer;
    i, NoObj : byte;
begin
  m := 32767;
  NoObj:=MaxIcons;
  for i:=0 to MaxIcons-1 do
    if (BufIcons^[i].WhatObj>min)and(BufIcons^[i].WhatObj<m)then begin
      m:=BufIcons^[i].WhatObj;
      NoObj:=i;
    end;
  min:=m;
  NajdiNejmensi:=NoObj;
end;

function NajdiNejvetsi(var max : integer) : integer;
var M : integer;
    i, NoObj : byte;
begin
  m := -1;
  NoObj:=MaxIcons;
  for i:=0 to MaxIcons-1 do
    if (BufIcons^[i].WhatObj<max)and(BufIcons^[i].WhatObj>m)then begin
      m:=BufIcons^[i].WhatObj;
      NoObj:=i;
    end;
  max:=m;
  NajdiNejvetsi:=NoObj;
end;

procedure SeradIcons;
var i, Obj : byte;
    j, minimum : integer;
    MakeObj : boolean;
begin
   j:=0;
   minimum:= -1;
   MakeObj:= false;
   for i:=0 to MaxIcons-1 do begin
     Obj:= NajdiNejmensi(minimum);
     if (Minimum>5000)and(not MakeObj)and(Obj<>32767)and(Obj<MaxIcons) then begin
       j:=5001;
       MakeObj:=True;
     end;
     if (Obj<>32767)and(Obj<MaxIcons) then BufIcons^[Obj].WhatObj:=j;
     Inc(j);
   end;
end;

procedure ClearIcons(Bez : byte);
var i : byte;
begin
  MouseSwitchOff;
  for i:=MaxIcons-1 downto 0 do if (BufIcons^[i].WhatObj<>32767)and(i<>Bez) then
    PutImagePart(BufIcons^[i].X,BufIcons^[i].Y, 0,0,320,200, BufIcons^[i].OldP);
  MouseSwitchOn;
end;

procedure DrawIcons(Bez : byte; Save : boolean);
var i, Obj : byte;
    Minimum : integer;
begin
  Minimum:=-1;
  MouseSwitchOff;
  if Save then
    for i:=0 to MaxIcons-1 do if (BufIcons^[i].WhatObj<>32767)and(Bez<>i) then
      if  BufIcons^[i].X < 0
        then GetImage(320+BufIcons^[i].X, BufIcons^[i].Y-1, BufIcons^[i].Sirka, BufIcons^[i].Vyska, BufIcons^[i].OldP)
        else GetImage(BufIcons^[i].X, BufIcons^[i].Y, BufIcons^[i].Sirka, BufIcons^[i].Vyska, BufIcons^[i].OldP);

  for i:=0 to MaxIcons-1 do begin
    Obj:= NajdiNejmensi(Minimum);
    if ((BufIcons^[Obj].WhatObj<>32767)and(Obj<MaxIcons))and(Bez<>Obj) then
      PutMaskImagePart(BufIcons^[Obj].X,BufIcons^[Obj].Y, 0,0,320,200, BufIcons^[Obj].P);
  end;
  MouseSwitchOn;
end;

procedure InitIcons(Max : byte);
var i : byte;
begin
  MaxIcons:= Max;
  GetMem(BufIcons,SizeOf(Icons1)*MaxIcons);
  for i:=0 to MaxIcons-1 do BufIcons^[i].WhatObj:=32767;
end;

procedure DoneIcons;
var i : byte;
begin
  ClearIcons(255);
  for i:= MaxIcons-1 downto 0 do begin
    if BufIcons^[i].WhatObj <> 32767 then
    FreeMem(BufIcons^[i].OldP,BufIcons^[i].Sirka*BufIcons^[i].Vyska+4);
  end;
  FreeMem(BufIcons,SizeOf(Icons1)*MaxIcons);
end;

function  AddIcons(P : pointer; X, Y : integer; Inf : byte) : byte;
type _M = array[1..2] of word;
     _ptrM = ^_M;
var i : byte;
    obr1, obr2 : _ptrM;
begin
  i:=0;
{!!!!!!!! Neni kontrola proti preteceni !!!!!!!!!!!!}
  while (BufIcons^[i].WhatObj<>32767) do Inc(i);
  ClearIcons(255);
{  BufIcons^[i].WhatObj:= i;}
  if (BufIcons^[i].Inf and $02)=2
    then BufIcons^[i].WhatObj:= 4999
    else BufIcons^[i].WhatObj:= 10000;

  BufIcons^[i].X:= X;
  BufIcons^[i].Y:= Y;
  BufIcons^[i].Inf:= Inf;
  BufIcons^[i].P:= P;
  obr1:=P;
  GetMem(BufIcons^[i].OldP,obr1^[1]*obr1^[2]+4);
  obr2:=BufIcons^[i].OldP;
  obr2^[1]:= obr1^[1];
  BufIcons^[i].Sirka:= obr1^[1];
  obr2^[2]:= obr1^[2];
  BufIcons^[i].Vyska:= obr1^[2];
  SeradIcons;
  DrawIcons(255,true);
  AddIcons:= i;
end;

procedure DelIcons(What : byte);
begin
  if (BufIcons^[What].WhatObj = 32767)or(What>=MaxIcons) then exit;
  ClearIcons(255);
  BufIcons^[What].WhatObj := 32767;
  FreeMem(BufIcons^[What].OldP,BufIcons^[What].Sirka*BufIcons^[What].Vyska+4);
  SeradIcons;
  DrawIcons(255,true);
end;

function  TestIcons(NoClick, NeniNaIkone : byte) : byte;
var i, j1, j2 : Integer;
    dx,dy:integer;
begin
  if (MouseKey=0)or(MouseKey=3) then begin
    TestIcons:=NoClick;
    exit;
  end;
  { zisti na ktere ikonce je zmackla mys }
  i:=MaxIcons;
  j1:=32767;
{  repeat
    Dec(i)
  until (i<0) or
        (InBar(MouseX, MouseY, BufIcons^[i].X, BufIcons^[i].Y, BufIcons^[i].Sirka, BufIcons^[i].Vyska)
         and (BufIcons^[i].WhatObj<>32767));}
  repeat
    j2:= NajdiNejvetsi(j1);
  until (j1<=0) or
        (InBar(MouseX, MouseY, BufIcons^[j2].X-1, BufIcons^[j2].Y-1, BufIcons^[j2].Sirka+1, BufIcons^[j2].Vyska+1)
         and (BufIcons^[j2].WhatObj<>32767));
  if (j1 <= 0)and
     (not InBar(MouseX, MouseY, BufIcons^[j2].X, BufIcons^[j2].Y, BufIcons^[j2].Sirka, BufIcons^[j2].Vyska))
     then begin
    TestIcons:= {NoClick}NeniNaIkone;
    Exit;
  end;
  i:=j2;
  case MouseKey of
    1 : begin
          TestIcons:= i;
          Exit;
        end;
    2 : begin
          if BufIcons^[i].Inf and $01 <> 0 then begin
            TestIcons:= NoClick;
            Exit;
          end;
          PushMouse;
          ClearIcons(255);
          MouseOff;
          DrawIcons(i,false);

          dx:=mousex-buficons^[i].x;
          dy:=mousey-buficons^[i].y;
          MouseOn(dx,dy, BufIcons^[i].P);
          repeat
          until MouseKey=0;
          BufIcons^[i].X:= MouseX-dx;
          BufIcons^[i].Y:= MouseY-dy;
          MouseOff;

          ClearIcons(i);
          if  BufIcons^[i].X < 0
            then GetImage(320+BufIcons^[i].X, BufIcons^[i].Y-1, BufIcons^[i].Sirka, BufIcons^[i].Vyska, BufIcons^[i].OldP)
            else GetImage(BufIcons^[i].X, BufIcons^[i].Y, BufIcons^[i].Sirka, BufIcons^[i].Vyska, BufIcons^[i].OldP);

          if (BufIcons^[i].Inf and $02)=2
            then BufIcons^[i].WhatObj:= 4999
            else BufIcons^[i].WhatObj:= 10000;
          SeradIcons;

          DrawIcons(255,true);
          PopMouse;

        end
    end;
  TestIcons:= NoClick
end;

end.