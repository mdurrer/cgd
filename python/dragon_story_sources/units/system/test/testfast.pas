program mericcasu;
uses graph256,graform,
     dos;
const pocettestu=100;
var h,m,sec,sec100,_h,_m,_sec,_sec100:word;
    cis1,cis2,poc:longint;
    obr,pal:pointer;

procedure startcas;
begin
  gettime(_h,_m,_sec,_sec100);
end;

procedure stopcas(var cas:longint);
var dh,dm,dsec,dsec100:integer;
begin
  gettime(h,m,sec,sec100);
  dh:=integer(h)-_h;
  dm:=integer(m)-_m;
  dsec:=integer(sec)-_sec;
  dsec100:=integer(sec100)-_sec100;
  cas:=dh*360000+dm*6000+dsec*100+dsec100;
end;

begin
  initgraph;
  lastline:=200;
  setactivepage(0);
  loadimage(obr,pal,'c:\pascal\animace\datas\sfoto.bmp');
  setpalette(pal);
  freemem(pal,768);
  startcas;
  for poc:=1 to pocettestu do
    putmaskimagepartzoom(0,0,100,100,50,50,220,100,obr);
  stopcas(cis1);
  startcas;
  for poc:=1 to pocettestu do
    putimagemaskmirrorzoompart(
      0,0,obr,255,false,0,100,100,50,50,220,100);
  stopcas(cis2);
  disposeimage(obr);
  closegraph;
  writeln('L:',cis1,' R:',cis2);
end.

{
 putimage (320x200)                    : 308, 593
 putmaskimage (320x200)                : 351, 555
 putmaskimagepart (320x200)            : 346, 549
 putmirrormaskimagepart (320x200)      : 346, 587
 putmaskimagepart (220x100)            : 126, 192
 putmirrormaskimagepart (220x100)      : 127, 208
 putimagepart (220x100)                : 99,  209
 putmaskimagepartzoom(1000x1000->220x100)               : 137, 137
 putmirrormaskimagepartzoom(1000x1000->220x100)         : 126, 143
 putmaskimagepartzoom(100x100->220x100)                 : 33,  27
 putmirrormaskimagepartzoom(100x100->220x100)           : 27,  33
  \- projevila se Lukasova chyba
 !ale nějak blbne měření, to předposl. bylo 33/27 i když jsem dal obě rutiny
 moje, i když byla 1 z nich Lukášova, a to pořád!

---> Lukášovy jednoduché rutiny jsou až 2x rychlejší a to počítám jenom
     velké obrázky; malé obrázky budou ještě mnohem více rychlejší, protože
     já mám moc velkej init
     Lukášovy nejsložítější rutiny jsou stejně rychlé, zato však chybné
 }
