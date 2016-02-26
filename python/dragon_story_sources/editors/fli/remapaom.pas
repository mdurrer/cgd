program remapaom;

uses dfw, dos, graph256;

const priponatemporary= '.$$$';
      priponyaom:array[1..4]of string[4]=
        ('.an0', {jména obrázků}
         '.an1', {obrázky}
         '.an4', {jména animací}
         '.an5');{animace}

var ratiostring, soubaom, soubtemp: string;
    oldc, newc: byte;
    oldcstr, newcstr: string;
    valcode: integer;
    width, height, i, j: word;
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

procedure zpracujparamstr(var soub1, soub2, oldc, newc:string);
var d:dirstr;
    n:namestr;
    e:extstr;
begin
  if (paramcount<>3) then
    chyba('remapaom <*.an1> <old color> <new color>');

  soub1:=fexpand(paramstr(1));
  fsplit(soub1,d,n,e);
  if e='' then e:=priponyaom[2];
  soub1:=d+n+e;
  soub2:=d+n+priponatemporary;

  oldc:= paramstr(2);
  newc:= paramstr(3);
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
begin
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
  zpracujparamstr(soubaom, soubtemp, oldcstr, newcstr);

  if not existfile(soubaom) then begin
    chyba('nelze otevrit soubor '+soubaom);
  end;
  val(oldcstr, oldc, valcode);
  if valcode<>0 then begin
    chyba('oldcolor musi byt 0-255');
  end;
  val(newcstr, newc, valcode);
  if valcode<>0 then begin
    chyba('newcolor musi byt 0-255');
  end;

  inicializujtempsoubor(soubtemp);

  initgraph;

  for i:=2 to getarchiveoccupy(soubaom) do begin
    clearscr(255);
    cloaditem(soubaom, image, i);
    width:= round(pwordarray(image)^[0]);
    height:= round(pwordarray(image)^[1]);
    for j:= 4 to width*height+4 do
      if pbytearray(image)^[j]=oldc then pbytearray(image)^[j]:=newc;

    caddfrommemory(soubtemp, image, width*height+4);
    disposeimage(image);
  end;

  closegraph;

 prohodaomtemp(soubaom, soubtemp);
end.
