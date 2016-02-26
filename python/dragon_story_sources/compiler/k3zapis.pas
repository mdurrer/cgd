{zápis zkompilovaných částí hry na disk

 kromě rozhovorů a průběžných řetězců}

unit k3zapis;
interface
uses k3togeth,
     gpl2,
     bardfw;

procedure zapisikony(
  ikon:pseznamikon;
  init:pinithry);
procedure xxzapisobjekty(
  ikon:pseznamikon;
  obj:pseznamobjektu);
procedure zapismistnosti(
  ikon:pseznamikon;
  obj:pseznamobjektu;
  mist:pseznammistnosti;
  init:pinithry;
  seznpal,seznhud,seznmap:pseznamretezcu);
procedure zapispovidacky(
  pov:pseznampovidacku);
procedure zapisinit(
  init:pinithry;
  obj:pseznamobjektu;
  ikon:pseznamikon;
  mist:pseznammistnosti;
  pov:pseznampovidacku;
  rozh:pseznamretezcu);
procedure zapisretezce(
  var pricistret:integer;
  var pocitret:longint;
  var soubret1:tpracsoubret1;
  var soubret2:tpracsoubret2);

implementation
uses k3vystup,
     graform,
     dos;

{The following 4 types and 2 procedures have been taken from graph256.pas to
remove the dependency of this module on it.}
  type
      TWordArray = array[0..32000] of word;
      PWordArray = ^TWordArray;
      TByteArray = array[0..65534] of byte;
      PByteArray = ^TByteArray;

  procedure NewImage(width, height : word; var P : pointer);
  { Vyhradi pamet pro obrazek }
  begin
    GetMem(P, width*height+4);
    PWordArray(P)^[0]:=width;
    PWordArray(P)^[1]:=height;
  end;

  procedure DisposeImage(var P : Pointer);
  { Zrusi pamet alokovanou obrazkem }
  begin
    FreeMem(P, PWordArray(P)^[0]*PWordArray(P)^[1]+4);
  end;

procedure loadonlygcfimage(var p:pwordarray; soub:string);
var fi:file;
    rozm:array[0..1]of integer;
    del:word;
begin
  otevrifilesouborcteni(soub,fi);
  blockread(fi,rozm,4);{načte x a y}
  del:=word(rozm[0])*rozm[1];
  getmem(p,del+4);
  p^[0]:=rozm[0];
  p^[1]:=rozm[1];
  blockread(fi,p^[2],del);
  close(fi);
end;

procedure zapisikony(
  ikon:pseznamikon;
  init:pinithry);
var x:integer;
    del:integer;
    ik:tvystikony;

 procedure pridejcervenou(soub,soubobr:string);
 var cerv,obr:pwordarray;
     x,y,dx,dy:integer;
 begin
   loadonlygcfimage(obr,soubobr);
   newimage(obr^[0]+2,obr^[1]+2,pointer(cerv));
   fillchar(cerv^[2],cerv^[0]*cerv^[1],255);
   for x:=0 to obr^[0]-1 do
     for y:=0 to obr^[1]-1 do
       if pbytearray(obr)^[x*obr^[1]+y+4]<>255 then
         for dx:=x to x+2 do
           for dy:=y to y+2 do
             pbytearray(cerv)^[dx*cerv^[1]+dy+4]:=cervenabarva;
   for x:=0 to obr^[0]-1 do
     for y:=0 to obr^[1]-1 do
       if pbytearray(obr)^[x*obr^[1]+y+4]<>255 then
         pbytearray(cerv)^[(x+1)*cerv^[1]+y+1+4]:=
           pbytearray(obr)^[x*obr^[1]+y+4];
   caddfrommemory(soub,obr,obr^[0]*obr^[1]+4);
   caddfrommemory(soub,cerv,(obr^[0]+2)*(obr^[1]+2)+4);
   if cerv^[0]>init^.imaxx then {zapise rozmery nejdelsi ikony}
     init^.imaxx:=cerv^[0];
   if cerv^[1]>init^.imaxy then
     init^.imaxy:=cerv^[1];
   disposeimage(pointer(obr));
   disposeimage(pointer(cerv));
 end;

begin
  smazsoubor(vysoubikon);
  smazsoubor(vysoubobrikon);
  write('items:');
  for x:=1 to ikon^.pocet do
    with ikon^.i[x] do begin
      ik.init:=init;
      ik.look:=look;
      ik.use:=use;
      ik.canuse:=canuse;
      ik.iminit:=iminit;
      ik.imlook:=imlook;
      ik.imuse:=imuse;
{      ik.status:=status;
      ik.obr:=x;}
      caddfrommemory(vysoubikon,@ik,sizeof(ik));
      caddfrommemory(vysoubikon,@title,length(title)+1);
      del:=cloaditem(pracprogramy,pointer(kod),x);
      if kod^.delka<>0
        then caddfrommemory(vysoubikon,@kod^.k[1],kod^.delka*sizeof(integer))
        else caddfrommemory(vysoubikon,@kod^.delka,1);
      freemem(kod,del);
      write('I');
      pridejcervenou(vysoubobrikon,obr);
      write('i');
    end;
  writeln;
  writeln('written all compiled items including their icons');
end;

procedure xxzapisobjekty(
  ikon:pseznamikon;
  obj:pseznamobjektu);
var x:integer;
    del:integer;
    ob:tvystobjektu;
    celkanim,celkobr,celksam:integer;

 procedure pridejanimace(cesta:string; obj:pomtobjektu);
 {an: 0-jména obrázků, 1-obrázky
      2,3-samply
      4,5-sekvence
      6-různé (název pozadí..)
  všechny použité sekvence překopíruje, jinde dá prázdnou sekvenci
  zapisuje si použité obrázky a samply
  a opět všechny použité zkopíruje a jinde dá 5 bajtů prázdného obrázku}
 const prazdnaanim:tanmheader=
         (NumOfPhases:0;
          MemoryLogic:0;
          DisableErasing:0;
          Cyclic:0;
          Relative:0);
 var useobr,usesam:pseznamhodnot; {čísla ve skutečných dfw-fajlech}
     del,x:word;
     tedobr,tedsam:integer;
     y:integer;
     an:panimation;
     p:pointer;
 begin
   x:=getarchiveoccupy(cesta+'.an0'); {vynulovat počítadla obrázků}
   if x<>0 then dec(x);
   getmem(useobr,2+x*sizeof(integer));
   fillchar(useobr^,2+x*sizeof(integer),0);
   useobr^.pocet:=x;
   tedobr:=0;

   x:=getarchiveoccupy(cesta+'.an2'); {a samplů}
   if x<>0 then dec(x);
   getmem(usesam,2+x*sizeof(integer));
   fillchar(usesam^,2+x*sizeof(integer),0);
   usesam^.pocet:=x;
   tedsam:=0;

   x:=getarchiveoccupy(cesta+'.an4'); {zapíšeme všechny použité anim. sekvence}
   if x<>0 then dec(x);
   for x:=1 to x do
     if obj.useanim^.h[x]=0 then begin {nebyla použita animace?}
       if caddfrommemory(vysoubanim,@prazdnaanim,sizeof(prazdnaanim))<>
          celkanim+x then
         chyba('(internal) mismatched empty animation number '+
           obj.anim^.r[x]^+' of object '+obj.id);
     end else begin {animace použita byla!}
       del:=cloaditem(cesta+'.an5',pointer(an),x+1);
{test na cyklickou animaci z disku:}
         if(an^.header.MemoryLogic>0)and(an^.header.cyclic=1) then begin
           an^.header.MemoryLogic:= 0;
           writeln(#7);
           writeln(cesta);
         end;
       for y:=1 to an^.header.numofphases do begin
         if an^.phase[y].picture<>0 then
           if useobr^.h[an^.phase[y].picture-1]=0 then begin
             inc(tedobr);
             useobr^.h[an^.phase[y].picture-1]:=celkobr+tedobr;
             an^.phase[y].picture:=celkobr+tedobr;
           end else
             an^.phase[y].picture:=useobr^.h[an^.phase[y].picture-1];
             {komprimuje do sebe a přečíslovává odkazy}
         if an^.phase[y].sample<>0 then
           if usesam^.h[an^.phase[y].sample-1]=0 then begin
             inc(tedsam);
             usesam^.h[an^.phase[y].sample-1]:=celksam+tedsam;
             an^.phase[y].sample:=celksam+tedsam;
           end else
             an^.phase[y].sample:=usesam^.h[an^.phase[y].sample-1];
       end;
       if caddfrommemory(vysoubanim,an,del)<>celkanim+x then
         chyba('(internal) mismatched written animation number '+
           obj.anim^.r[x]^+' of object '+obj.id);
       freemem(an,del);
     end;
   inc(celkanim,x); {zvýšíme počítadlo všech animací}
   write('a');

   for y:=celkobr+1 to celkobr+tedobr do begin {pro všechny uložené obr.}
     x:=1;
     while (x<=useobr^.pocet)and(useobr^.h[x]<>y) do
       inc(x);
     if x>useobr^.pocet then
       chyba('(internal) when renumbering animation sprites');
     del:=cloaditem(cesta+'.an1',p,x+1);
     if caddfrommemory(vysoubobranim,p,del)<>
        y then
       chyba('(internal) mismatched number of sprite of object '
         +obj.id);
     freemem(p,del);
   end;
   inc(celkobr,tedobr);
   write('o');

   for y:=celksam+1 to celksam+tedsam do begin {pro všechny uložené sam.}
     x:=1;
     while (x<=usesam^.pocet)and(usesam^.h[x]<>y) do
       inc(x);
     if x>usesam^.pocet then
       chyba('(internal) when renumbering animation samples');
     del:=cloaditem(cesta+'.an3',p,x+1);
     if caddfrommemory(vysoubsamanim,p,del)<>
        y then
       chyba('(internal) mismatched number of sample of object '
         +obj.id);
     freemem(p,del);
   end;
   inc(celksam,tedsam);
   write('s');

   freemem(useobr,2+useobr^.pocet*sizeof(integer));
   freemem(usesam,2+usesam^.pocet*sizeof(integer));
 end;

begin
  smazsoubor(vysoubobj);
  smazsoubor(vysoubobranim);
  smazsoubor(vysoubsamanim);
  smazsoubor(vysoubanim);
  celkanim:=0; {pro kontrolu}
  celkobr:=0;
  celksam:=0;
  write('objects:');
  for x:=1 to obj^.pocet do
    with obj^.o[x]^ do begin
      ob.init:=init;
      ob.look:=look;
      ob.use:=use;
      ob.canuse:=canuse;
      ob.iminit:=iminit;
      ob.imlook:=imlook;
      ob.imuse:=imuse;
      ob.typ:=typ;
{      ob.status:=status;
      ob.mistnost:=mistnost;}
      ob.priorita:=priorita;
      ob.idxanim:=idxanim;
      ob.pocanim:=anim^.pocet;
      ob.xlook:=xlook;
      ob.ylook:=ylook;
      ob.smerlook:=smerlook;
      ob.xuse:=xuse;
      ob.yuse:=yuse;
      ob.smeruse:=smeruse;
      caddfrommemory(vysoubobj,@ob,sizeof(ob));
      caddfrommemory(vysoubobj,@title,length(title)+1);
      del:=cloaditem(pracprogramy,pointer(kod),x+ikon^.pocet);
      if kod^.delka<>0
        then caddfrommemory(vysoubobj,@kod^.k[1],kod^.delka*sizeof(integer))
        else caddfrommemory(vysoubobj,@kod^.delka,1);
      freemem(kod,del);
      write('O');
      pridejanimace(cestaanim,obj^.o[x]^);
    end;
  writeln;
  writeln('written all compiled objects including their animations');
end;

procedure zapismistnosti(
  ikon:pseznamikon;
  obj:pseznamobjektu;
  mist:pseznammistnosti;
  init:pinithry;
  seznpal,seznhud,seznmap:pseznamretezcu);
type t1masky=packed record
       cis:integer;
       x,y:integer;
       prior:byte;
     end;
var x,y:integer;
    del:integer;
    mi:tvystmistnosti;
    celkmap,celkmasek,celkpalet:integer;
    ret:string;
    delhud:word;
    fi:file;
    masky:array[1..255]of t1masky;

 procedure kompilujpozadi(
   cismist:byte;
   obrcesta,mascesta:string;
   var poc:integer;
   var cispal:byte);
 var obr,pal:pointer;
     mas:pwordarray;
     akt:pbytearray;
     i:integer;
     x,y:integer;
     pocit,pocit1:word;
     b:array[byte]of record
       minx,miny,maxx,maxy:integer;
     end;
 begin
   i:=loadimage(obr,pal,obrcesta); {vždy načte pozadí}
   if i<>255 then
     chyba('missing palette or background of location '+mist^.m[cismist].id);

   inc(celkpalet); {vždy uloží paletu}
   cispal:=celkpalet;
   if caddfrommemory(vysoubpalet,pal,768)<>celkpalet then
     chyba('(internal) mismatched number of palettes when saving location '
       +mist^.m[cismist].id);
   freemem(pal,768);
   write('p');

   poc:=0; {zatím}
   if mascesta=#0 then begin {žádné masky ---> vezmeme pouze paletu}
     disposeimage(obr);
   end else begin {s maskou ---> rozsekat}
     loadonlygcfimage(mas,mascesta);
     if (mas^[0]<>pwordarray(obr)^[0])or(mas^[1]<>pwordarray(obr)^[1]) then
       chyba('image with masks does not match the background of location '+mist^.m[cismist].id);
     {nyní máme obr a mas}
     for i:=0 to 255 do
       with b[i] do begin
         minx:=1000;
         miny:=1000;
         maxx:=-1000;
         maxy:=-1000;
       end;
     pocit:=4;
     for x:=0 to mas^[0]-1 do {výpočet rozkládajících se masek}
       for y:=0 to mas^[1]-1 do begin
         with b[ pbytearray(mas)^[pocit] ] do
           if minx=1000 then begin
             minx:=x;
             miny:=y;
             maxx:=x;
             maxy:=y;
           end else begin
             {minx zůstane}
             maxx:=x;
             if y<miny then miny:=y;
             if y>maxy then maxy:=y;
           end;
         inc(pocit);
       end;
     write('s');

     for i:=0 to 254 do {masku číslo 255 ignoruje, tedy ani prioritu nemusí nastavovat zvlášť}
       if b[i].minx<>1000 then begin {je to maska?}
         newimage(b[i].maxx-b[i].minx+1, b[i].maxy-b[i].miny+1, pointer(akt));
         pocit:=4;
         for x:=b[i].minx to b[i].maxx do begin {projdi ji celou}
           pocit1:=4+b[i].miny+word(x)*200;
           for y:=b[i].miny to b[i].maxy do begin
             if pbytearray(mas)^[pocit1]=i then {tam, kde je maska, dej obrázek}
               akt^[pocit]:=pbytearray(obr)^[pocit1]
             else
               akt^[pocit]:=255;
             inc(pocit);
             inc(pocit1);
           end;
         end;
         inc(poc); {přidáme ji do dfw-fajlu}
         if caddfrommemory(vysoubmasek,akt,pocit)<>celkmasek+poc then
           chyba('(internal) mismatched number of masks of location '+mist^.m[cismist].id);
         disposeimage(pointer(akt));
         with masky[poc] do begin
           cis:=celkmasek+poc;
           x:=b[i].minx;
           y:=b[i].miny;
           prior:=i;
         end;
         write('.');
       end;

     disposeimage(obr);
     disposeimage(pointer(mas));
   end;

   inc(celkmasek,poc); {zapiš si počet nových masek}
 end;

 procedure ulozpaletu(dfw,pal:string;x:byte);
 label navchyba;
 var o,p:pointer;
     ch:byte;
 begin
   if fsplit2(pal,4)='.PAL' then begin {paleta}
    if caddfromfile(dfw,pal)<>x then
navchyba:
      chyba('cannot save palettes used in programs '+seznpal^.r[x]^);
   end else begin {obrazek}
     ch:=loadimage(o,p,pal);
     if ch<>255 then goto navchyba;
     disposeimage(o);
     if caddfrommemory(dfw,p,768)<>x then goto navchyba;
     freemem(p,768);
   end;
 end;

{Unfortunately this serialization is not exactly equal to the one from BP7,
according to the bitstream, but the hero looks OK.}
procedure EightToSix(const Q : double ; var R : TReal48) ;
type T8 = array [1..8] of byte ;
type T4 = array [1..4] of word ;
var X : T8 ; E : word ;
const K = 1023-129 ;
begin double(X) := Q ;
  FillChar(R, SizeOf(R), 0) ;
  if Q=0 then EXIT ;
  E := (T4(Q)[4] shr 4 and $7FF) ;
  if E<K then EXIT { Underflow } ;
  if E>K+$FF then RunError(234) { Overflow } ;
  R[0] := E - K ;
  for E := 6 downto 2 do
    R[E-1] := ((X[E+1] shl 3) and $F8) or ((X[E] shr 5) and $07) ;
  if Q<0.0 then R[5] := (R[5] or $80) else R[5] := (R[5] and not $80) ;
  end {EightToSix} ;

begin
  smazsoubor(vysoubmist);
  smazsoubor(vysoubmap);
  smazsoubor(vysoubpalet);
  smazsoubor(vysoubmasek);
  for x:=1 to seznpal^.pocet do
{    if caddfromfile(vysoubpalet,seznpal^.r[x]^)<>x then
       chyba('error when saving palettes using in programs '+seznpal^.r[x]^);}
    ulozpaletu(vysoubpalet,seznpal^.r[x]^,x);
      {zde 0=nenačten soubor}
  {u palet duplicitu netestuji}
  celkmasek:=0; {počítadla}
  celkmap:=0; {kontrola}
  celkpalet:=seznpal^.pocet;
  write('locations:');
  for x:=1 to mist^.pocet do
    with mist^.m[x] do begin
      mi.prog:=nil;
      mi.proglen:=0;
      mi.title:=nil;
      mi.init:=init;
      mi.look:=look;
      mi.use:=use;
      mi.canuse:=canuse;
      mi.iminit:=iminit;
      mi.imlook:=imlook;
      mi.imuse:=imuse;
      mi.mouse:=mouse;
      mi.hero:=hero;
      EightToSix(persp0, mi.persp0);
      EightToSix(perspstep, mi.perspstep);
      mi.escroom:=escroom;
      mi.gates:=gates;
      for y:=1 to mi.gates do
        mi.gate[y]:=gate[y];
      {omitted in the original game ==> rubbish written and this rubbish is different in BP7 and FP}
      for y:=mi.gates+1 to maxgatesmistnosti do
        mi.gate[y]:=0;
      write('M');
      if mus<>#0 then begin {existuje-li hudba, zaradi si ji do seznamu}
        mi.mus:=najdivseznamuretezcu(seznhud,true,fexpand(mus));
        {vc. testovani duplicit;
         hudby se ulozi na konci}
      end else
        mi.mus:=0;
(*      if map<>#0 then begin {existuje-li mapa, přidá ji do dfw}
        inc(celkmap);
        mi.map:=celkmap;
        if caddfromfile(vysoubmap,map)<>celkmap then
          chyba('(internal) mismatched number of maps of location '+mist^.m[x].id);
      end else
        mi.map:=0; *)
      if map<>#0 then begin {existuje-li mapa, zaradi si ji do seznamu}
        mi.map:=najdivseznamuretezcu(seznmap,true,fexpand(map));
        {vc. testovani duplicit;
         hudby se ulozi na konci}
      end else
        mi.map:=0;
      write('m');
      kompilujpozadi(x,obr,mask, mi.pocmasek,mi.pal);
      {tím zapsal paletu a rozsekal příp. pozadí}

      caddfrommemory(vysoubmist,@mi,sizeof(mi));
      caddfrommemory(vysoubmist,@title,length(title)+1);
      if mi.pocmasek<>0
        then caddfrommemory(vysoubmist,@masky[1],mi.pocmasek*sizeof(t1masky))
        else caddfrommemory(vysoubmist,@mi.pocmasek,1);
      del:=cloaditem(pracprogramy,pointer(kod),x+ikon^.pocet+obj^.pocet);
      if kod^.delka<>0
        then caddfrommemory(vysoubmist,@kod^.k[1],kod^.delka*sizeof(integer))
        else caddfrommemory(vysoubmist,@kod^.delka,1);
      freemem(kod,del);
    end;
  writeln;
  writeln('written all compiled locations including maps, palettes, and masks');
  write('music:');
  for x:=1 to seznhud^.pocet do begin
    str(x,ret);
    kopirujsoubor(seznhud^.r[x]^,vysoubhudeb+ret+'.mid');
    assign(fi,seznhud^.r[x]^); {$i-} reset(fi,1); {$i+}
    delhud:=filesize(fi); close(fi);
    if delhud>init^.maxhud then
      init^.maxhud:=delhud;
      {zapis delky nejdelsi hudby}
    write('.');
  end;
  for x:=1 to seznmap^.pocet do
    if caddfromfile(vysoubmap,seznmap^.r[x]^)<>x then
      chyba('(internal) mismatched map number '+seznmap^.r[x]^);
  writeln;
  writeln('all music files have been copied');
end;

procedure zapisinit(
  init:pinithry;
  obj:pseznamobjektu;
  ikon:pseznamikon;
  mist:pseznammistnosti;
  pov:pseznampovidacku;
  rozh:pseznamretezcu);
var i:tvystinithry;
    h:array[0..1000{byte}]of byte;
    g:array[0..1000{byte}]of integer;
    x:integer;
begin
  smazsoubor(vysoubinit);
  with init^ do begin
    i.map:=map;
    i.pocetprom:=prom.pocet;
    i.pocetobj:=obj^.pocet;
    i.pocetikon:=ikon^.pocet;
{    i.pocetmist:=mist^.pocet;}
    i.actualroom:=start;
    i.pocetpostav:=pov^.pocet;
    i.pocetrozh:=rozh^.pocet;
    i.imaxx:=imaxx;
    i.imaxy:=imaxy;
    i.maxhud:=maxhud;
    randomize;
    for x:=1 to 4 do {pro rozliseni jednotlivych her}
      i.crc[x]:=random(65535);
  end;
  for x:=1 to obj^.pocet do
    case obj^.o[x]^.status of
      2:{away}h[x]:=0;
      1:{off}h[x]:=obj^.o[x]^.mistnost;
      0:{on}h[x]:=obj^.o[x]^.mistnost or $80;
    end;
  if obj^.pocet<>0
    then caddfrommemory(vysoubinit,@h[1],obj^.pocet*sizeof(byte))
    else caddfrommemory(vysoubinit,@obj^.pocet,1);
  for x:=1 to ikon^.pocet do
    h[x]:=ikon^.i[x].status;
  if ikon^.pocet<>0
    then caddfrommemory(vysoubinit,@h[1],ikon^.pocet*sizeof(byte))
    else caddfrommemory(vysoubinit,@ikon^.pocet,1);
  if init^.prom.pocet<>0
    then caddfrommemory(vysoubinit,@init^.prom.h[1],init^.prom.pocet*sizeof(integer))
    else caddfrommemory(vysoubinit,@init^.prom.pocet,1);
  caddfrommemory(vysoubinit,@i,sizeof(tvystinithry));
  for x:=1 to rozh^.pocet do
    g[x]:=integer(rozh^.r[x]^[1]);
  if rozh^.pocet<>0
    then caddfrommemory(vysoubinit,@g[1],rozh^.pocet*sizeof(integer))
    else caddfrommemory(vysoubinit,@rozh^.pocet,1);
{bacha na násobení nulou! opravit to radši univerzálně v dfw!}
  writeln('written the game descriptor');
end;

procedure zapispovidacky(
  pov:pseznampovidacku);
var x:integer;
    po:array[1..maxpocetpovidacku]of tvystpovidacka;
begin
{  smazsoubor(vysoubmluveni);}
  for x:=1 to pov^.pocet do begin
    po[x].x:=pov^.p[x].x;
    po[x].y:=pov^.p[x].y;
    po[x].barva:=pov^.p[x].barva;
  end;
  if pov^.pocet<>0
    then caddfrommemory({vysoubmluveni}vysoubinit,@po[1],
           pov^.pocet*sizeof(tvystpovidacka))
    else caddfrommemory({vysoubmluveni}vysoubinit,@pov^.pocet,1);
  writeln('written all persons');
end;

procedure zapisretezce(
  var pricistret:integer;
  var pocitret:longint;
  var soubret1:tpracsoubret1;
  var soubret2:tpracsoubret2);
{uzavře oba pracovní soubory a překonvertuje řetězce do dfw-fajlu}
var bitmap:pbytearray;
    nacteno:word;
begin
  blockwrite(soubret1,pocitret,sizeof(pocitret)); {předá koncový index}
  close(soubret1);
  close(soubret2);

  otevrifilesouborcteni(pracsoubret1,soubret1); {otevře 2 pracovní soubory}
  otevrifilesouborcteni(pracsoubret2,soubret2);
  smazsoubor(vysoubemsretezcu); {smaže příp. výstupní dfw soubor}

  caddfrommemory(vysoubemsretezcu,@pocitret,sizeof(pocitret)); {délka}

  getmem(bitmap,(pricistret+1)*sizeof(longint)); {pozice}
  blockread(soubret1,bitmap^,(pricistret+1)*sizeof(longint));
  close(soubret1);
  caddfrommemory(vysoubemsretezcu,bitmap,(pricistret+1)*sizeof(longint));
  freemem(bitmap,(pricistret+1)*sizeof(longint));

  getmem(bitmap,deleniretezcunabloky); {řetězce}
  while not eof(soubret2) do begin
    blockread(soubret2,bitmap^,deleniretezcunabloky,nacteno);
    caddfrommemory(vysoubemsretezcu,bitmap,nacteno);
  end;
  close(soubret2);
  freemem(bitmap,deleniretezcunabloky);

  smazsoubor(pracsoubret1);
  smazsoubor(pracsoubret2);

  writeln('written all strings to disk');
end;

end.

{todo: psát průběžně bitmapové operace a možná je dělat až po uložení
       dat!?!

!dat bacha na nasobeni 0 pri zapisu initu!
!to je možná příčina těch hnusných záhadných občas-zhroucení!
setarchivecapacity už dávat (ASI) nemusím, protože jediné nebezpečí ze
strany řetězců už bylo eliminováno

pozn. malá změna v souborech postavy a objekty

?nesavují se inicializace proměnných nějak divně?
nemají vlastní složku v dfw?}
