uses crt, graph256;

var
  Pal1, Pal2: pointer;
  f, g: word;
  PalFile: file;

procedure Kombinuj(NazPal1, NazPal2: string);
begin
  Assign(PalFile, NazPal1+'.pal');
  Reset(PalFile, 1);
  GetMem(Pal1, 768);
  BlockRead(PalFile, PByteArray(Pal1)^[0], 768);
  Close(PalFile);

  Assign(PalFile, NazPal2+'.pal');
  Reset(PalFile, 1);
  GetMem(Pal2, 768);
  BlockRead(PalFile, PByteArray(Pal2)^[0], 768);
  Close(PalFile);

  for g:= 224 to 255 do begin
    PByteArray(Pal1)^[(g)*3]:= PByteArray(Pal2)^[g*3];
    PByteArray(Pal1)^[(g)*3+1]:= PByteArray(Pal2)^[g*3+1];
    PByteArray(Pal1)^[(g)*3+2]:= PByteArray(Pal2)^[g*3+2];
  end;

  Assign(PalFile, NazPal1+'.pal');
  Rewrite(PalFile, 1);
  BlockWrite(PalFile, PByteArray(Pal1)^[0], 768);
  Close(PalFile);
end;

begin
  Kombinuj('e:\paint\final\x0pergam', 'e:\paint\final\x0madr00' );
end.


