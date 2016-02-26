program TestGetImage;

uses crt, graph256;

var
  Obr0, obr1, obr2, obr3: pointer;

begin
  LastLine:= 200;
  InitGraph;
  LoadOnlyPalette(Palette, 'e:\paint\picture\mesto.pal'{'..\units\test.pal'});
  SetPalette(Palette);

  LoadOnlyImage(obr0, 'e:\paint\picture\mesto.gcf');

  SetActivePage(0);
  ClearScr(0);
  SetActivePage(1);
  ClearScr(0);
  SetActivePage(0);
  SetVisualPage(0);

  PutImage(0,0, obr0);
  readln;
  SetVisualPage(1);

  NewImage(50,50,obr1);
  GetImage(0,0,50,50,obr1);
  SetVisualPage(0);

  SetActivePage(1);
  SetVisualPage(1);

  PutImage(0,0, obr1);
  readln;


end.
