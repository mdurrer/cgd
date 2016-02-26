program fli2mask;
uses crt,dos,graform,graph256;

const priponaflisouboru='.fli';
      priponapcxsouboru='.pcx';
      mojemaxsnimku=200;

type pbytearray=^tbytearray;
     tbytearray=array[0..64015]of byte;

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

var delan:word;
    zmena:boolean;
    Mask: pointer;
    fli:thlavicka;
    fi:file;
    i:integer;
    soubfli,soubmask:string;

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

procedure chyba(text:string);
begin
  closegraph;
  writeln(text,#7);
  halt(1);
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
    if funkce^.typ=13 then begin
      fce_clear(hlav.width,hlav.heigth);
      zmena:=true;
    end else if funkce^.typ=11 then
      fce_palette(@data^[x+6])
    else if funkce^.typ=16 then begin
      fce_putimage(hlav.width,hlav.heigth,@data^[x+6]);
      zmena:=true;
    end else if funkce^.typ=15 then begin
      fce_putcompimage(hlav.width,hlav.heigth,@data^[x+6]);
      zmena:=true;
    end else if funkce^.typ=12 then begin
      fce_changeimage(hlav.width,hlav.heigth,@data^[x+6]);
      zmena:=true;
    end else
      goto chyba;
    inc(x,funkce^.size);
    {velikost je vč. hlavičky}
  end;
  viewfliframe:=0;
chyba:
  freemem(data,snimek.size-16);
end;

procedure zjistijmenasouboru(var soub1,soub2:string);
var d:dirstr;
    n:namestr;
    e:extstr;
begin
  if (paramcount<1)or(paramcount>2) then
    chyba('fli2pcx <*.fli> [<*.pcx>]');

  soub1:=fexpand(paramstr(1));
  fsplit(soub1,d,n,e);
  if e='' then e:=priponaflisouboru;
  soub1:=d+n+e;

  soub2:='';
  if paramcount>1 then begin
    soub2:=fexpand(paramstr(2));
    fsplit(soub2,d,n,e); {přípona se zanedbá}
    if e='' then e:=priponapcxsouboru;
    soub2:=d+n+e;
  end;
end;

procedure otevriflisoubor(var fi:file; soubfli:string);
begin
  assign(fi,soubfli);
  {$i-} reset(fi,1); {$i+}
  if ioresult<>0 then
    chyba('nelze otevřít vstupní soubor '+soubfli);
end;

procedure deletefile(soub:string);
var fo:file;
begin
  assign(fo,soub);
  {$i-} erase(fo); {$i+}
end;

function existfile(soub:string):boolean;
var fi:file;
begin
  assign(fi,soub);
  {$i-} reset(fi,1); {$i+}
  if ioresult=0 then begin
    existfile:=true;
    close(fi);
  end else
    existfile:=false;
end;

var cisloobr:integer;

procedure zapis1snimek(cis:integer; fli:thlavicka);
type pobr=^tobr;
     tobr=record
       w,h:integer;
       o:array[1..64000]of byte;
     end;
var obr:pobr;
    del,poci,poco:word;
    x,y:integer;
    cislo:string[3];
    i: word;
begin
  if not zmena then begin {nebyla žádná změna obrazovky?}
  end else begin
    {sejmu obrazek z obrazovky:}
    del:=fli.width*fli.heigth+4;
    getmem(obr,del);
    obr^.w:=fli.width;
    obr^.h:=fli.heigth;
    poci:=1;
    poco:=0;
    for x:=0 to fli.width-1 do begin
      for y:=0 to fli.heigth-1 do begin
        obr^.o[poci]:=mem[$a000:poco];
        inc(poci);
        inc(poco,320);
      end;
      dec(poco,fli.heigth*320-1);
    end;
    {pokud chceme maskovat, budeme:}
    if soubmask<>'' then
      for i:= 4 to 64003 do if PByteArray(Mask)^[i]=PByteArray(obr)^[i] then
        PByteArray(obr)^[i]:= 255;
    {vyrobim nazev obrazku:}
    str(cis:3,cislo);
    if cislo[1]=' ' then cislo[1]:='0';
    if cislo[2]=' ' then cislo[2]:='0';
    {ulozim obrazek:}
    SavePcx(obr, ppaletka(palette), 'o'+cislo+'.pcx');
    freemem(obr,del);
  end;
end;

begin
  zjistijmenasouboru(soubfli,soubmask);

  {pokud chceme maskovat, nacteme masku:}

  if soubmask<>'' then if LoadImage(Mask, pointer(Palette), soubmask)<>255 then begin
    writeln('nelze otevrit soubor s maskou '+soubmask); halt(1);
  end;

  otevriflisoubor(fi,soubfli);

  if nactiflihlavicku(fi,fli)<>0 then
    chyba('špatná hlavička FLI-souboru');
  initgraph;
  for i:=1 to fli.frames do begin
    zmena:=false;
    if viewfliframe(fi,fli,i)<>0 then
      chyba('špatný snímek ve FLI-souboru');
    zapis1snimek(i,fli);
  end;
  closegraph;

  close(fi);
end.
