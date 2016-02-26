program mergeaom;

uses dfw, dos;

const priponatemporary= '.$$$';
      priponyaom:array[1..4]of string[4]=
        ('.an0', {jména obrázků}
         '.an1', {obrázky}
         '.an4', {jména animací}
         '.an5');{animace}

var soubaom, soubsrc: string;
    valcode: integer;
    i, j, delka: word;
    item: pointer;

procedure chyba(text:string);
begin
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

procedure zpracujparamstr(var soub1, soub2:string);
var d:dirstr;
    n:namestr;
    e:extstr;
begin
  if (paramcount<>2) then
    chyba('resaom <*.an1> <resize ratio>');

  soub1:=fexpand(paramstr(1));
  fsplit(soub1,d,n,e);
  soub1:=d+n;

  soub2:=fexpand(paramstr(2));
  fsplit(soub2,d,n,e);
  soub2:=d+n;
end;

begin
  zpracujparamstr(soubaom, soubsrc);

  for j:= 1 to 4 do begin

    if not existfile(soubaom+priponyaom[j]) then begin
      chyba('nelze otevrit soubor '+soubaom+priponyaom[j]);
    end;
    if not existfile(soubsrc+priponyaom[j]) then begin
      chyba('nelze otevrit soubor '+soubsrc+priponyaom[j]);
    end;

    for i:=2 to getarchiveoccupy(soubsrc++priponyaom[j]) do begin
      delka:= cloaditem(soubsrc+priponyaom[j], item, i);
      caddfrommemory(soubaom+priponyaom[j], item, delka);
      FreeMem(item, delka);
    end;
  end;
end.
