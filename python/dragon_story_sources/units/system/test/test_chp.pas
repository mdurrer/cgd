{průběžné prolnutí 2 palet na N fází}
program testzmenypalety;
uses crt,graph256,graform;

{type pintegerarray=^tintegerarray;
     tintegerarray=array[0..767]of integer;}

const pocetfazi=32;

(*
procedure zmenapalety(
  pal:ppalette;
  N:integer;
  dif,pred:pintegerarray);
var i:integer;
begin
  for i:=0 to 767 do
    if dif^[i]>0 then begin {kladná změna}
      inc(pred^[i],dif^[i]);
      while pred^[i]>=N do begin
        inc(pal^[i]);
        dec(pred^[i],N);
      end;
    end else begin
      dec(pred^[i],dif^[i]);
      while pred^[i]>=N do begin
        dec(pal^[i]);
        dec(pred^[i],N);
      end;
    end;
end;
*)

(*
{$f+}
procedure zmenapalety(
  pal:ppalette;
  N:integer;
  dif,pred:pintegerarray);
  external;
  {$l chpal.obj}

procedure remappal(
  pal:pointer);
  external;
  {$l remap.obj}
{čte je z graph256, vč. initu a done}
{$f-}
*)


var obr,pal1:pointer;
    pal2,pompal:ppalette;
    i:integer;
    fi:file;
    dif,pred:pintegerarray;
begin
  initgraph;
  lastline:=200;
  setactivepage(0);

  loadimage(obr,pal1,'e:\oneweek\bobr26.lbm');
  setpalette(pal1);
  putimage(0,0,obr);

  getmem(pal2,768);
  getmem(pompal,768);
{  assign(fi,'c:\pascal\animace\datas\stand2.pal');
  reset(fi,1);
  blockread(fi,pal2^,768);
  close(fi);}
{  for i:=0 to 767 do
    if i>=384 then
      pal2^[i]:=ppalette(pal1)^[i]
    else
      pal2^[i]:=i div 3;}
{  for i:=0 to 767 do
    pal2^[i]:=0;}
(*  for i:=0 to 767 do begin {pozvolný přechod k šedé}
    pal2^[i]:=ppalette(pal1)^[i];
    pompal^[i]:=pal2^[i]; {musí být na poč. stejná jako pal1!}
  end;
  remappal(pal2);*)
  for i:=0 to 767 do begin
    pal2^[i]:= 63;
    pompal^[i]:=ppalette(pal1)^[i]; {musí být na poč. stejná jako pal1!}
  end;
{pal1 - vychozi, pal2 - konecny stav}
{pompal - na pocatku jako vychozi. Nemuzu pracovat rovnou s pal1, protoze ji
 to znici}

  repeat
    initzmenapalety(pal1,pal2,dif,pred); {C->M}
    for i:=1 to pocetfazi do begin
      zmenapalety(pompal,pocetfazi,dif,pred);
      setpalette(pompal);
    end;
    donezmenapalety(dif,pred);
    delay(1000);

    initzmenapalety(pal2,pal1,dif,pred); {M->C}
    {pal1 a pal2 uz nebudou potreba
     pompal^ MUSIS nastavit na pal1^ a pak uz volas jen toto
     dif a pred jsou JEHO pomocna pole, ktera se init/donem inicializuji}
    for i:=1 to pocetfazi do begin
      zmenapalety(pompal,pocetfazi,dif,pred);
      setpalette(pompal);
    end;
    donezmenapalety(dif,pred);
    delay(1000);
  until keypressed;
  readkey;

  freemem(pompal,768);
  freemem(pal1,768);
  freemem(pal2,768);
  disposeimage(obr);

  closegraph;
end.

{v podstatě fachalo v Pascalu na 1. pokus, ale při testování se stand.pal
 jsem tomu nechtěl věřit. Opravdu, ani při 10.000(!) fázích to nepůsobí
 plynule. Sice se každá barva plynule opravdu mění, ale to často jenom
 o predikci a když nastane skoková změna, je to u každé barvy v jinou chvíli
 a působí to rozhrkaně. Ale postupné to opravdu je.

 přechod do náhodné ČB je dobrý, ale přechod do odpovídající ČB paletě
 je geniálně efektní!}
