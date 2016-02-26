{test na scannutí zmenšeného obrazovky v poměru 1/4
 tedy scanne 80x50 a to tak, že nemusí přepínat bitové roviny!}

program get4;
uses graph256,graform;
var obr,pal:pointer;
    i:byte;

(*
{$f+}
procedure readsmallscreen( {je to read ---> nealokuje nic}
  obr:pointer);
  external;
  {$l get4.obj}
{čte z graph256}
{$f-}
*)

begin
  initgraph;
  loadimage(obr,pal,'c:\pascal\animace\datas\sfoto.bmp');
  setpalette(pal);
  putimage(0,0,obr);
  disposeimage(obr);
  getmem(obr,80*50+4);
  for i:=1 to 4 do begin
    readsmallscreen(obr);
    readln;
    putimage(0,0,obr);
  end;
  readln;
  disposeimage(obr);
  freemem(pal,768);
  closegraph;
end.
