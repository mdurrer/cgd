program fliviewer;
uses crt;

const mojemaxsnimku=300;
      jmenoflisouboru='io.fli';
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
function otevriflisoubor(jmeno:string):integer;
  external;
function vykresli1snimek(cislo:integer):integer;
  external;
function zavriflisoubor:integer;
  external;
  {$l fli1.obj}
{$f+}

label chyba;
var i:integer;
begin
  if otevriflisoubor(jmenoflisouboru)<>0 then halt(1);

  initgraph;
  for i:=1 to 10 do begin
    if vykresli1snimek(i)<>0 then goto chyba;
    readkey;
  end;

chyba:
  closegraph;
  zavriflisoubor;
end.

{todo: nedávat getmem(0), proč se to na tom ale nezblblo?}
