uses crt,graph256,dfw;
const jmeno='obr_mas'; {vse je O.K.}
var  heap1, heap2: longint;
     p : pointer;
     key : char;
     x,y : word;
begin
  heap1:= MaxAvail;
{  if not sti('c:\pascal\animace\datas\mouse.gcf',
             'c:\pascal\animace\datas\stand2.pal',
             'c:\pascal\animace\datas\stand2.fon') then
    exit;
  SetPalette(Palette);
  initmouse;
  mouseon(3,0,mouseimage);}
  InitGraph;
  x:=0;
  y:=getarchiveoccupy(jmeno+'.dfw');
  repeat
    inc(x);
    if CLoadItem(jmeno+'.dfw',p,x)=0 then break;
    Bar(0,0,320,200,0);
    PutImage(0,0,p);
    key:=ReadKey;
    disposeimage(p);
  until (key=#27)or(x=y);
{  STE;}
  CloseGraph;
  heap2:= MaxAvail;
  WriteLn(#13#10, heap1, #13#10, heap2);
  if heap1<>heap2 then Write(#7);
end.