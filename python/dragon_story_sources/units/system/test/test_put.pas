program TestPut;
uses crt,graph256;

procedure PutMaskImageMirrorZoomPart1(
  x,y:integer;
  obr:pbytearray;
  maska:integer;
  mirror:byte;
  zdx,zdy:integer;
  px1,py1,px2,py2:integer);
{úplná verze, ale POŘÁD s výpočtem offsetu}
var ox1,oy1,ox2,oy2:integer; {souřadnice v obrázku}
    predx,predy,preduchov:integer; {predikce}
    sx,sy:integer; {přidávané souřadnice}
    dx,dy:integer; {délka neZOOMovaného obrázku}
    ix,iy,ox,oy:integer; {indexové souřadnice IN,OUT}
    b:byte; {zpracovávaný pixel}
begin
  inc(px2,px1-1); {převod délek na souřadnice}
  inc(py2,py1-1);
  if px1<x then px1:=x; {1. oříznutí part souřadnic}
  if py1<y then py1:=y;
  if px2>x+zdx-1 then px2:=x+zdx-1;
  if py2>y+zdy-1 then py2:=y+zdy-1;
  if (px2<px1)or(py2<py1) then exit; {žádný obrázek}
  dx:=obr^[0]+obr^[1] shl 8; {nastav si délku obrázku}
  dy:=obr^[2]+obr^[3] shl 8;
  ox1:=(px1-x)*dx div zdx; {nastaví startovní souřadnice v obrázku}
  oy1:=(py1-y)*dy div zdy; {minimálně 0 (jako v C)}
  ox2:=(px2-x)*dx div zdx; {nastaví koncové souřadnice v obrázku}
  oy2:=(py2-y)*dy div zdy; {maximálně delka-1 (jako v C)}
  predx:=(px1-x)*dx mod zdx; {a startovní predikci}
  predy:=(py1-y)*dy mod zdy;
  if mirror and 1<>0 then begin {nastavení zrcadlení}
    sx:=-1;
    ox1:=dx-ox1-1;
    ox2:=dx-ox2-1;
  end else
    sx:=1;
  if mirror and 2<>0 then begin
    sy:=-1;
    oy1:=dy-oy1-1;
    oy2:=dy-oy2-1;
  end else
    sy:=1;

  preduchov:=predy; {predikce x je nastavena}
  ix:=ox1;
  ox:=px1;
  while ox<=px2 do begin
    predy:=preduchov;
    iy:=oy1;
    oy:=py1;
    while oy<=py2 do begin
      b:=obr^[4+ix*dy+iy];
      if (maska and $ff<>b)or(maska shr 8=0) then
        putpixel(ox,oy,b);
      inc(oy);
      inc(predy,dy); {zvýšíme predikci}
      while predy>=zdy do begin
        dec(predy,zdy);
        inc(iy,sy);
      end;
    end;
    inc(ox);
    inc(predx,dx); {zvýšíme predikci}
    while predx>=zdx do begin
      dec(predx,zdx);
      inc(ix,sx);
    end;
  end;
end;

procedure PutMaskImageMirrorZoomPart2(
  x,y:integer;
  obr:pbytearray;
  maska:integer;
  mirror:byte;
  zdx,zdy:integer;
  px1,py1,px2,py2:integer);
{úplná verze, offset v obrázku se zvyšuje, ale volá se pořád PutPixel}
var ox1,oy1,ox2,oy2:integer; {souřadnice v obrázku}
    predx,predy,preduchov:integer; {predikce}
    zpet,prechod,sy:integer; {přidávané souřadnice}
    dx,dy:integer; {délka neZOOMovaného obrázku}
    iofs,ox,oy:integer; {indexové souřadnice IN,OUT}
    b:byte; {zpracovávaný pixel}
begin
  inc(px2,px1-1); {převod délek na souřadnice}
  inc(py2,py1-1);
  if px1<x then px1:=x; {1. oříznutí part souřadnic}
  if py1<y then py1:=y;
  if px2>x+zdx-1 then px2:=x+zdx-1;
  if py2>y+zdy-1 then py2:=y+zdy-1;
  if (px2<px1)or(py2<py1) then exit; {žádný obrázek}
  dx:=obr^[0]+obr^[1] shl 8; {nastav si délku obrázku}
  dy:=obr^[2]+obr^[3] shl 8;
  ox1:=(px1-x)*dx div zdx; {nastaví startovní souřadnice v obrázku}
  oy1:=(py1-y)*dy div zdy; {minimálně 0 (jako v C)}
  ox2:=(px2-x)*dx div zdx; {nastaví koncové souřadnice v obrázku}
  oy2:=(py2-y)*dy div zdy; {maximálně delka-1 (jako v C)}
  predx:=(px1-x)*dx mod zdx; {a startovní predikci}
  predy:=(py1-y)*dy mod zdy;
  if mirror and 1<>0 then begin {nastavení zrcadlení}
    prechod:=-dy; {přechod na další sloupec}
    ox1:=dx-ox1-1;
    ox2:=dx-ox2-1;
  end else begin
    prechod:=dy;
  end;
  if mirror and 2<>0 then begin
    sy:=-1;
    oy1:=dy-oy1-1;
    oy2:=dy-oy2-1;
  end else begin
    sy:=1;
  end;
  zpet:=oy1-oy2; {vrácení se zpět na začátek sloupce}

  preduchov:=predy; {predikce x je nastavena}
  iofs:=4+ox1*dy+oy1;
  ox:=px1;
  while ox<=px2 do begin
    predy:=preduchov;
    oy:=py1;
    repeat
      b:=obr^[iofs];
      if (maska and $ff<>b)or(maska shr 8=0) then
        putpixel(ox,oy,b);
      inc(oy);
      if oy>py2 then break; {nutno zde, aby se příp. nezvýšil iofs}
      inc(predy,dy); {zvýšíme predikci}
      while predy>=zdy do begin
        dec(predy,zdy);
        inc(iofs,sy);
      end;
    until false;
    inc(iofs,zpet); {na začátek tohoto řádku}
    inc(ox);
    inc(predx,dx); {zvýšíme predikci}
    while predx>=zdx do begin
      dec(predx,zdx);
      inc(iofs,prechod); {přechod na další sloupec}
    end;
  end;
end;

procedure prepnibitmapu(cis:byte); assembler;
asm
  mov     cl, cis
  mov     ah, 1
  shl     ah, cl
  mov     dx, 3C4h
  mov     al, 2
  out     dx, al
  inc     dx
  mov     al, ah
  out     dx, al
end;

procedure PutMaskImageMirrorZoomPart3(
  x,y:integer;
  obr:pbytearray;
  maska:integer;
  mirror:byte;
  zdx,zdy:integer;
  px1,py1,px2,py2:integer);
{úplná verze, offset v obrázku se zvyšuje, přepínají se ručně bitové roviny
 a zapisuje se bod přímo}
var ox1,oy1,ox2,oy2:integer; {souřadnice v obrázku}
    predx,predy,preduchov:integer; {predikce}
    izpet,iprechod,sy,ozpet:integer; {přidávané souřadnice}
    dx,dy:integer; {délka neZOOMovaného obrázku}
    iofs,oofs,ox,oy:integer; {indexové souřadnice IN,OUT}
    vbit,b:byte; {číslo bitmapy, zpracovávaný pixel}
    vram:array[0..64000]of byte absolute $a000:0;
begin
  inc(px2,px1-1); {převod délek na souřadnice}
  inc(py2,py1-1);
  if px1<x then px1:=x; {1. oříznutí part souřadnic}
  if py1<y then py1:=y;
  if px2>x+zdx-1 then px2:=x+zdx-1;
  if py2>y+zdy-1 then py2:=y+zdy-1;
  if (px2<px1)or(py2<py1) then exit; {žádný obrázek}
  dx:=obr^[0]+obr^[1] shl 8; {nastav si délku obrázku}
  dy:=obr^[2]+obr^[3] shl 8;
  ox1:=(px1-x)*dx div zdx; {nastaví startovní souřadnice v obrázku}
  oy1:=(py1-y)*dy div zdy; {minimálně 0 (jako v C)}
  ox2:=(px2-x)*dx div zdx; {nastaví koncové souřadnice v obrázku}
  oy2:=(py2-y)*dy div zdy; {maximálně delka-1 (jako v C)}
  predx:=(px1-x)*dx mod zdx; {a startovní predikci}
  predy:=(py1-y)*dy mod zdy;
  if mirror and 1<>0 then begin {nastavení zrcadlení}
    iprechod:=-dy; {přechod na další sloupec}
    ox1:=dx-ox1-1;
    ox2:=dx-ox2-1;
  end else begin
    iprechod:=dy;
  end;
  if mirror and 2<>0 then begin
    sy:=-1;
    oy1:=dy-oy1-1;
    oy2:=dy-oy2-1;
  end else begin
    sy:=1;
  end;
  dec(px2,px1-1); {převod souřadnic zpátky na délky}
  dec(py2,py1-1);
  izpet:=oy1-oy2; {vrácení se zpět na začátek sloupce}
  ozpet:=(1-py2)*80; {vrácení se zpět ve videoram}

  preduchov:=predy; {predikce x je nastavena}
  iofs:=4+ox1*dy+oy1;
  oofs:=px1 shr 2+py1*80;
  vbit:=px1 and $3;
  ox:=0;
  while ox<px2 do begin
    prepnibitmapu(vbit);
    predy:=preduchov;
    oy:=0;
    repeat
      b:=obr^[iofs];
      if (maska and $ff<>b)or(maska shr 8=0) then
        vram[oofs]:=b;
      inc(oy);
      if oy>=py2 then break; {nutno zde, aby se příp. nezvýšil iofs}
      inc(oofs,80);
      inc(predy,dy); {zvýšíme predikci}
      while predy>=zdy do begin
        dec(predy,zdy);
        inc(iofs,sy);
      end;
    until false;
    inc(iofs,izpet); {na začátek tohoto řádku}
    inc(predx,dx); {zvýšíme predikci}
    while predx>=zdx do begin
      dec(predx,zdx);
      inc(iofs,iprechod); {přechod na další sloupec}
    end;
    inc(ox);
    inc(oofs,ozpet);
    inc(vbit);
    if vbit=4 then begin
      vbit:=0;
      inc(oofs);
    end;
  end;
end;

procedure loadonlygcfimage(var p:pwordarray; soub:string);
var fi:file;
    rozm:array[0..1]of integer;
    del:word;
begin
  assign(fi,soub); reset(fi,1);
  blockread(fi,rozm,4);{načte x a y}
  del:=word(rozm[0])*rozm[1];
  getmem(p,del+4);
  p^[0]:=rozm[0];
  p^[1]:=rozm[1];
  blockread(fi,p^[2],del);
  close(fi);
end;

(*
{$f+}
procedure PutImageMaskMirrorZoomPart(
  x,y:integer;
  obr:pbytearray;
  maska:byte;
  jemaska:boolean;
  mirror:byte;
  zdx,zdy:integer;
  px1,py1,px2,py2:integer);
  external;
function TestImageMaskMirrorZoom(
  x,y:integer;
  obr:pbytearray;
  mask:byte;
  mirror:byte;
  zdx,zdy:integer;
  px,py:integer):boolean;
  external;
  {$l put.obj}
{čte z graph256}
{$f-}
*)

function TestMaskImageMirrorZoom1(
  x,y:integer;
  obr:pbytearray;
  mask:byte;
  mirror:byte;
  zdx,zdy:integer;
  px,py:integer):boolean;
{vrátí, zda je na daném místě maska}
var ox,oy:integer; {souřadnice v obrázku}
    dx,dy:integer; {délka neZOOMovaného obrázku}
begin
  TestMaskImageMirrorZoom1:=false;
  if (px<x)or(py<y)or(px>=x+zdx)or(py>=y+zdy) then exit;
  dx:=obr^[0]+obr^[1] shl 8; {nastav si délku obrázku}
  dy:=obr^[2]+obr^[3] shl 8;
  ox:=(px-x)*dx div zdx; {nastaví startovní souřadnice v obrázku}
  oy:=(py-y)*dy div zdy; {minimálně 0 (jako v C)}
  if mirror and 1<>0 then {nastavení zrcadlení}
    ox:=dx-ox-1;
  if mirror and 2<>0 then
    oy:=dy-oy-1;
  TestMaskImageMirrorZoom1:=obr^[4+ox*dy+oy]<>mask;
end;

var obr:pbytearray;
    x,y:integer;
begin
{  initgraph;
  activeaddrpage:=0;
  loadonlygcfimage(pwordarray(obr),'c:\pascal\animace\datas\mouse.gcf');}
  if not sti(
    'c:\pascal\animace\datas\mouse.gcf',
    'c:\pascal\animace\datas\stand2.pal',
    'c:\pascal\animace\datas\stand2.fon') then
    halt(1);
  mouseon(0,0,mouseimage);
  mouseswitchoff;
  obr:=mouseimage;
(*  putimage(100,100,obr);
  for x:=0 to 100 do
    for y:=0 to 100 do begin
      putmaskimagemirrorzoompart(
        0,0,
        obr,
        255,
        false,
        3,
        60,64,
        x,y,20,3);
{      readkey;}
    end;
  readkey;
  putmaskimagemirrorzoompart(
    0,0,
    obr,
    255,
    true,
    0,
    60,64,
    0,0,320,200); {O.K.!}
  readkey;*)
  repeat
    putimagemaskmirrorzoompart( {myšička postupně odkryje celý obraz}
      0,0,
      obr,
      255,
      true,
      2,
      320,200,
      mousex,mousey,100,10);
  until keypressed;
  readkey;
  for y:=0 to 199 do
    for x:=0 to 319 do
      if TestImageMaskMirrorZoom(
        50,50,
        obr,
        255,
        0,
        120,100,
        x,y) then
          putpixel(x,y,7);
  readkey;

{  closegraph;}
  ste;
end.

{log: napsáno a drobná chyba v přehození 1 souřadnice a nekontrolování
      přetečení a fachá na 1. pokus ve všech případech! (vč. zoomu&partu,
      masek, mirroru...)
      pak chybička při výpočtu indexu do obrázků (občas přeteklo)
      pak chybička ---"--- do videram (jedničkový problém)
        !done!}