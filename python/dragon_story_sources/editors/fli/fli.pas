program fliviewer;
uses crt;

type pbytearray=^tbytearray;
     tbytearray=array[0..64015]of byte;

const mojemaxsnimku=300;
      jmenoflisouboru='e:\gfx\sipek\spivitr.fli';

type thlavicka=record
       size:longint;
       magic:word;
       frames:word;
       width:word;
       heigth:word;
       depth:longint;
       speed:word;
       next,frit:longint;
       nothing:array[1..102]of byte;

       index:array[1..mojemaxsnimku]of longint;
     end;

     tsnimek=record
       size:longint;
       magic:word;
       chunks:word;
       nothing:array[1..8]of byte;
     end;

     pfunkce=^tfunkce;
     tfunkce=record
       size:longint;
       typ:word;
     end;

function nactiflihlavicku(var fi:file; var hlav:thlavicka):integer;
var i,x:word;
    idx:longint;
begin
  nactiflihlavicku:=1;
  blockread(fi,hlav,128,x);
  if x<>128 then exit;
  if hlav.magic<>$af11 then exit;
  if hlav.depth and $ff<>8 then exit;
  if (hlav.width>320)or(hlav.heigth>200) then exit;
  if hlav.frames>mojemaxsnimku then exit;

  hlav.index[1]:=128; {načte indexy snímků}
  for i:=2 to hlav.frames do begin
    seek(fi,hlav.index[i-1]);
    blockread(fi,hlav.index[i],4,x);
    inc(hlav.index[i],hlav.index[i-1]);
    {velikost je vč. hlavičky}
    if x<>4 then exit;
  end;
  nactiflihlavicku:=0;
end;

{$f+}
procedure initgraph;
  external;
procedure closegraph;
  external;
procedure fce_clear(s,v:word);
  external;
procedure fce_palette(pal:pointer);
  external;
procedure fce_putcompimage(s,v:word; obr:pointer);
  external;
procedure fce_putimage(s,v:word; obr:pointer);
  external;
procedure fce_changeimage(s,v:word; obr:pointer);
  external;
  {$l fli.obj}
{$f+}

function viewfliframe(var fi:file; hlav:thlavicka; cislo:integer):integer;
label chyba;
var i,x:word;
    snimek:tsnimek;
    data:pbytearray;
    funkce:pfunkce;
begin
  viewfliframe:=1;
  {$i-} seek(fi,hlav.index[cislo]); {$i+}
  if ioresult<>0 then exit;
  blockread(fi,snimek,16,x);
  if x<>16 then exit;
  if snimek.magic<>$f1fa then exit;
  if snimek.size>64016 then exit;
  {velikost je vč. hlavičky}
  getmem(data,snimek.size-16);
  blockread(fi,data^,snimek.size-16,x);
  if x<>snimek.size-16 then goto chyba;
  x:=0;
  for i:=1 to snimek.chunks do begin
    funkce:=@data^[x];
    if funkce^.typ=13 then
      fce_clear(hlav.width,hlav.heigth)
    else if funkce^.typ=11 then
      fce_palette(@data^[x+6])
    else if funkce^.typ=16 then
      fce_putimage(hlav.width,hlav.heigth,@data^[x+6])
    else if funkce^.typ=15 then
      fce_putcompimage(hlav.width,hlav.heigth,@data^[x+6])
    else if funkce^.typ=12 then
      fce_changeimage(hlav.width,hlav.heigth,@data^[x+6])
    else
      goto chyba;
    inc(x,funkce^.size);
    {velikost je vč. hlavičky}
  end;
  viewfliframe:=0;
chyba:
  freemem(data,snimek.size-16);
end;

label chyba;
var fli:thlavicka;
    fi:file;
    i:integer;
begin
  assign(fi,jmenoflisouboru);
  {$i-} reset(fi,1); {$i+}
  if ioresult<>0 then halt(1);

  initgraph;
  if nactiflihlavicku(fi,fli)<>0 then goto chyba;
  for i:=1 to fli.frames do begin
    if viewfliframe(fi,fli,i)<>0 then goto chyba;
    delay(fli.speed*20);
{???}
  end;

  closegraph;
  halt(0);
chyba:
  closegraph;
  close(fi);
  write(#7);
  halt(1);
end.

{todo: nedávat getmem(0), proč se to na tom ale nezblblo?}
