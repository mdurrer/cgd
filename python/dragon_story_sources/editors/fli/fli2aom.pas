program fliviewer;
uses crt,dos,graform,graph256,
     dfw;

const priponaflisouboru='.fli';
      priponapcxsouboru='.pcx';
      priponyaom:array[1..4]of string[4]=
        ('.an0', {jména obrázků}
         '.an1', {obrázky}
         '.an4', {jména animací}
         '.an5');{animace}
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

     taomjmeno=string[12];

     panimation=^tanimation;
     TAnmPhase= record
       Picture      : word;        {cislo obrazku ze skladu}
       X            : integer;     {souradnice x}
       Y            : integer;     {souradnice y}
       ZoomX        : word;        {zoom na ose x}
       ZoomY        : word;        {zoom na ose y}
       Mirror       : byte;        {0=normal, 1=zrcadlit obrazek}
       Sample       : word;        {cislo samplu ze skladu}
       Frequency    : word;        {frekvence samplu}
       Delay        : word;        {zdrzeni pred dalsi fazi}
     end;
     TAnmHeader= record
       NumOfPhases    : byte;      {pocet fazi animace}
       MemoryLogic    : byte;      {0=vsechny sprajty jsou v pameti (napr. chuze hlavniho hrdiny)
                                    1=v pameti vyhrazeno misto pro nejvetsi
                                      sprajt a vsechny sprajty se nacitaji
                                      prave do tohoto mista (napr. okno, ktere je nejdriv cele,
                                      pak se rozbiji a nakonec je rozbite)
                                    2=sprajty se pricitaji z disku (napr. jak se hl. hrdina
                                      pro neco shyba, neco pouziva...)}
       DisableErasing : byte;      {0=maze se pod, 1=nemaze se}
       Cyclic         : byte;      {0=zacit a skoncit, 1=cyklicka furt dokola}
       Relative       : byte;      {0=absolutni souradnice, 1=relativni}
     end;
     TAnmPhasesArray= array[1..255] of TAnmPhase;
     TAnimation= record
       Header         : TAnmHeader;
       Phase          : TAnmPhasesArray;
     end;

const jmenoanim:taomjmeno='FLI-animace'; {průběžný zápis animace}
var an:panimation;
    delan:word;
    zmena:boolean;
    fli:thlavicka;
    fi:file;
    i:integer;
    soubmask,soubfli,soubaom:string;
    Background_Name: string[8];
    Mask: pointer;

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

procedure zjistijmenasouboru(var soub1,soub2,soub3:string);
var d:dirstr;
    n:namestr;
    e:extstr;
begin
  if (paramcount<1)or(paramcount>2) then
    chyba('fliconv <*.fli> [<*.pcx>]');

  soub1:=fexpand(paramstr(1));
  fsplit(soub1,d,n,e);
  if e='' then e:=priponaflisouboru;
  soub1:=d+n+e;
  soub3:=d+n;

  soub2:='';
  Background_Name:='';
  if paramcount>1 then begin
    soub2:=fexpand(paramstr(2));
    fsplit(soub2,d,n,e); {přípona se zanedbá}
    if e='' then e:=priponapcxsouboru;
    soub2:=d+n+e;
    Background_Name:=n;
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

procedure inicializujaomsoubory(soubaom:string);
const
  hlavicky:array[1..4]of string[32]=
    ('<sklad jmen obrazku_-_-_-_-_-_->',
     '<obrazky-_-_-_-_-_-_-_-_-_-_-_->',
     '<sklad jmen animacnich sekvenci>',
     '<animacni sekvence-_-_-_-_-_-_->');
  Music_Name:string [8]='';
var exist:array[1..4]of boolean;
    i:byte;

begin
  for i:=1 to 4 do
    exist[i]:=existfile(soubaom+priponyaom[i]);
  if exist[1]xor exist[2] then {nemůže 1 existovat a druhý ne!}
    chyba('nekorektní dfw-soubory s obrázky');
  if exist[3]xor exist[4] then
    chyba('nekorektní dfw-soubory s animacemi');
  if exist[2] then {existují obrázky?}
    cisloobr:=getarchiveoccupy(soubaom+priponyaom[2])+1 {číslováno od 2!}
  else begin
    cisloobr:=2; {vytvořím AOM-soubory}
    caddfrommemory(soubaom+priponyaom[1],@hlavicky[1],length(hlavicky[1])+1);
    caddfrommemory(soubaom+priponyaom[2],@hlavicky[2],length(hlavicky[2])+1);
  end;
  if not exist[3] then begin {neexistují animace?}
    caddfrommemory(soubaom+priponyaom[3],@hlavicky[3],length(hlavicky[3])+1);
    caddfrommemory(soubaom+priponyaom[4],@hlavicky[4],length(hlavicky[4])+1);
  end;
  if not existfile(soubaom+'.an6') then begin {neexistuje přídavný soubor?}
    caddfrommemory(soubaom+'.an6',@hlavicky[4],length(hlavicky[4])+1);
    caddfrommemory(soubaom+'.an6',@background_name,9);
    caddfrommemory(soubaom+'.an6',@music_name,9);
  end;
end;

procedure zapisanimaci(fli:thlavicka; soubaom:string);
var i:byte;
begin
  delan:=sizeof(tanmheader)+fli.frames*sizeof(tanmphase);
  getmem(an,delan);
  with an^.header do begin
    numofphases:=fli.frames;
    memorylogic:=2;
    disableerasing:=0;
    cyclic:=0;
    relative:=0;
  end;
  for i:=1 to fli.frames do
    with an^.phase[i] do begin
      picture:=cisloobr+i-1;
      x:=0;
      y:=0;
      sample:=0;
      zoomx:=fli.width;
      zoomy:=fli.heigth;
      mirror:=0;
      frequency:=0;
      delay:=fli.speed{*20};
{???}
    end;
{  caddfrommemory(soubaom+priponyaom[3],@jmenoanim,sizeof(taomjmeno));
  caddfrommemory(soubaom+priponyaom[4],an,delan);
  freemem(an,delan);}
end;

procedure zapis1snimek(cis:integer; fli:thlavicka; soubaom:string);
type pobr=^tobr;
     tobr=record
       w,h:integer;
       o:array[0..63999]of byte;
     end;
var obr:pobr;
    del,poci,poco:word;
    x,y:integer;
    jmenoobr:taomjmeno;
    i: word;
    sx,sy,fx,fy: integer;
    red: pointer;

  procedure GetRealSize(var sx,sy,fx,fy: integer);
    function EmptyLine(v: integer): boolean;
    var i: integer;
    begin
      EmptyLine:= True;
      for i:=0 to 319 do begin
        if obr^.o[v+i*200]<>255 then begin
          EmptyLine:= False;
          Exit;
        end;
      end;
    end;
    function EmptyColumn(c: integer): boolean;
    var i: integer;
    begin
      EmptyColumn:= True;
      for i:=0 to 199 do if obr^.o[c*200+i]<>255 then begin
        EmptyColumn:= False;
        Exit;
      end;
    end;
  begin
    sx:= 0;
    while EmptyColumn(sx) do Inc(sx);
    fx:= 319;
    while EmptyColumn(fx) do Dec(fx);
    {zjistime v ktere vysce zaciname a koncime:}
    {budeme prijizdet radek po radku v kazde vysce a uvidime:}
    sy:= 0;
    while EmptyLine(sy) do Inc(sy);
    fy:= 199;
    while EmptyLine(fy) do Dec(fy);
  end;

begin
  if not zmena then begin {nebyla žádná změna obrazovky?}
    if cis=1 then {zápis dalšího obrázku}
      an^.phase[1].picture:=0
    else
      an^.phase[cis].picture:=an^.phase[cis-1].picture;
  end else begin
    del:=fli.width*fli.heigth+4;
    getmem(obr,del);
    obr^.w:=fli.width;
    obr^.h:=fli.heigth;
    poci:=0;
    poco:=0;
    for x:=0 to fli.width-1 do begin
      for y:=0 to fli.heigth-1 do begin
        obr^.o[poci]:=mem[$a000:poco];
        inc(poci);
        inc(poco,320);
      end;
      dec(poco,fli.heigth*320-1);
    end;

    str(cisloobr,jmenoobr);
    jmenoobr:='FLI-obr:'+jmenoobr;
    caddfrommemory(soubaom+priponyaom[1],@jmenoobr,sizeof(taomjmeno));

    {pokud chceme maskovat, budeme:}
    if soubmask<>'' then begin
      for i:= 4 to 64003 do if PByteArray(Mask)^[i]=PByteArray(obr)^[i] then
        PByteArray(obr)^[i]:= 255;
      {zjistime rozmery:}
      GetRealSize(sx,sy,fx,fy);
{      PutImage(0,0,obr);}
      NewImage(fx-sx+1,fy-sy+1,red);
{      GetImage(sx,sy,fx-sx+1,fy-sy+1,red);}
      for x:=sx to fx do begin
        for y:=sy to fy do begin
          pbytearray(red)^[4+(x-sx)*(fy-sy+1)+(y-sy)]:= obr^.o[x*200+y];
        end;
      end;
      caddfrommemory(soubaom+priponyaom[2],red,(fx-sx+1)*(fy-sy+1)+4);
      DisposeImage(red);
      an^.phase[cis].zoomx:= fx-sx+1;
      an^.phase[cis].zoomy:= fy-sy+1;
      an^.phase[cis].x:=sx;
      an^.phase[cis].y:=sy;
    end else caddfrommemory(soubaom+priponyaom[2],obr,del);

    freemem(obr,del);
    an^.phase[cis].picture:=cisloobr;
    inc(cisloobr);
  end;
end;

begin
  zjistijmenasouboru(soubfli,soubmask,soubaom);

  {pokud chceme maskovat, nacteme masku:}

  if soubmask<>'' then if LoadImage(Mask, pointer(Palette), soubmask)<>255 then begin
    writeln('nelze otevrit soubor s maskou '+soubmask); halt(1);
  end;

  otevriflisoubor(fi,soubfli);
  inicializujaomsoubory(soubaom);

  if nactiflihlavicku(fi,fli)<>0 then
    chyba('špatná hlavička FLI-souboru');
  zapisanimaci(fli,soubaom);
  initgraph;
  for i:=1 to fli.frames do begin
    zmena:=false;
    if viewfliframe(fi,fli,i)<>0 then
      chyba('špatný snímek ve FLI-souboru');
    zapis1snimek(i,fli,soubaom);
  end;
  closegraph;
  caddfrommemory(soubaom+priponyaom[3],@jmenoanim,sizeof(taomjmeno));
  caddfrommemory(soubaom+priponyaom[4],an,delan);
  freemem(an,delan); {zapíšeme i animaci}

  close(fi);
end.

{todo: nedávat getmem(0), proč se to na tom ale nezblblo?

       nemění-li se obrazovka, dát tam žádnou změnu nebo větší delay!
       udělat ANO-disableerasing a využit měnící se část
         - ale to už je frajeřinka...}
