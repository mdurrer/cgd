program remapovanipalety;
uses graph256,graform;
var obr,pal:pointer;
    i:byte;

(*
{$f+}
procedure barva2sed(
  obr,pal:pointer);
  external;
procedure remappal(
  pal:pointer);
  external;
  {$l remap.obj}
{čte je z graph256}
{$f-}
*)

begin
  initgraph;
  loadimage(obr,pal,'c:\pascal\animace\datas\sfoto.bmp');
  lastline:=200;
  setactivepage(0);
  setvisualpage(0);
  setpalette(pal);
  putimage(0,0,obr);
  barva2sed(obr,pal);          {převedení obrázku na 0..255 stupňů šedi}
  for i:=0 to 255 do begin      {nastavení standardní palety šedi}
    pbytearray(pal)^[i*3]:=i;
    pbytearray(pal)^[i*3+1]:=i;
    pbytearray(pal)^[i*3+2]:=i;
  end;
(*  remappal(pal); {remapování palety na Č&B}*)
  setactivepage(1);
  putimage(0,0,obr);
  readln;
  setpalette(pal);
  setvisualpage(1);
  readln;
  disposeimage(obr);
  freemem(pal,768);
  closegraph;
end.
