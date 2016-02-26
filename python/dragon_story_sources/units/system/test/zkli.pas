uses crt, graph256;
var
 PAL,OBR: pointer;
begin
 InitGraph;
 LastLine:= 200;
 LoadImage(obr, pal, 'e:\paint\picture\mesto.bmp');
 SetPalette(PPalette(Pal));
 PutImage(0, 0, obr);
 repeat until Keypressed;
end.