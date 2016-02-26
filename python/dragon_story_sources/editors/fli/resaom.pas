program resaom;

uses dfw, dos, graph256;

const priponatemporary= '.$$$';
      priponyaom:array[1..4]of string[4]=
        ('.an0', {jména obrázků}
         '.an1', {obrázky}
         '.an4', {jména animací}
         '.an5');{animace}

var ratiostring, soubaom, soubtemp: string;
    ratio: real;
    valcode: integer;
    width, height, i: word;
    image: pointer;

procedure chyba(text:string);
begin
  closegraph;
  writeln(text,#7);
  halt(1);
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

procedure zpracujparamstr(var soub1, soub2, ratio:string);
var d:dirstr;
    n:namestr;
    e:extstr;
begin
  if (paramcount<>2) then
    chyba('resaom <*.an1> <resize ratio>');

  soub1:=fexpand(paramstr(1));
  fsplit(soub1,d,n,e);
  if e='' then e:=priponyaom[2];
  soub1:=d+n+e;
  soub2:=d+n+priponatemporary;

  ratio:= paramstr(2);
end;

procedure inicializujtempsoubor(soubtemp: string);
const
  hlavicky:array[1..4]of string[32]=
    ('<sklad jmen obrazku_-_-_-_-_-_->',
     '<obrazky-_-_-_-_-_-_-_-_-_-_-_->',
     '<sklad jmen animacnich sekvenci>',
     '<animacni sekvence-_-_-_-_-_-_->');
var exist:array[1..4]of boolean;
    i:byte;
    temp: file;
begin
  Assign(temp, soubtemp);
  {$i-}
  Erase(temp);
  {$i+}
  caddfrommemory(soubtemp,@hlavicky[1],length(hlavicky[1])+1);
end;

procedure prohodaomtemp(soubaom, soubtemp: string);
var aom, temp: file;
begin
  Assign(temp, soubtemp);
  Assign(aom, soubaom);
  Erase(aom);
  rename(temp, soubaom);
end;

begin
  zpracujparamstr(soubaom, soubtemp, ratiostring);

  if not existfile(soubaom) then begin
    chyba('nelze otevrit soubor '+soubaom);
  end;
  val(ratiostring, ratio, valcode);
  if valcode<>0 then begin
    chyba('ratio musi byt realne cislo!');
  end;

  inicializujtempsoubor(soubtemp);

  initgraph;

  for i:=2 to getarchiveoccupy(soubaom) do begin
    bar(0,0,320,200,255);
    cloaditem(soubaom, image, i);
    PutMaskImagePartZoom(0, 0, round(pwordarray(image)^[0]*ratio),
      round(pwordarray(image)^[1]*ratio), 0, 0, 320, 200, image);
    width:= round(pwordarray(image)^[0]*ratio);
    height:= round(pwordarray(image)^[1]*ratio);
    DisposeImage(image);
    NewImage(width, height, image);
    GetImage(0, 0, width, height, image);
    caddfrommemory(soubtemp, image, width*height+4);
    disposeimage(image);
  end;

  closegraph;

 prohodaomtemp(soubaom, soubtemp);
end.
