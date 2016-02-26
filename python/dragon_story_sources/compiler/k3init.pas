{inicializace (seznámení se se seznamy) kompilátoru her 3. verze}

unit k3init;
interface
uses k3togeth,
     txt2iden,txt2comm,chyby,gpl2,
     bardfw;

procedure seznamovacikancelar(
  var mist:pseznammistnosti;
  var obj:pseznamobjektu;
  var ikon:pseznamikon;
  var pov:pseznampovidacku;
  var init:pinithry;
  var ret,rozh,pal,hud,map:pseznamretezcu;
  var pricistret:integer;
  var pocitret:longint;
  var soubret1:tpracsoubret1;
  var soubret2:tpracsoubret2);
procedure dealokujseznamy(
  var mist:pseznammistnosti;
  var obj:pseznamobjektu;
  var ikon:pseznamikon;
  var pov:pseznampovidacku;
  var init:pinithry;
  var ret,rozh,pal,hud,map:pseznamretezcu);
procedure inicializujgpl2(
  var ident:pident;
  var maxident:byte;
  var prik,talk:pprikaz);
procedure dealokujgpl2(
  var ident:pident;
  var prik:pprikaz);
procedure nastavcesty;

implementation
uses together,
     dos;

procedure nactiinithry(
  obj:pseznamobjektu;
  mist:pseznammistnosti;
  var init:pinithry;
  var r:tseznamident);
var fi:text;
    slov,ret:string;
    promenne:boolean;
    cis:longint;
    ch:integer;
    h:tseznamhodnot;
    hra:record {čteno sem, než se naalokuje init}
      start,map,hero:byte;
      gatestart,gatemap:byte;
      imaxx,imaxy:integer;
      maxhud:word;
    end;
begin
  otevrisouborcteni(jmsoubinit,fi);
  r.pocet:=0;
  h.pocet:=0;
  hra.start:=255;
  hra.map:=255;
  hra.hero:=255;
  hra.gatestart:=255;
  hra.gatemap:=255;
  hra.imaxx:=-1;
  hra.imaxy:=-1;
  hra.maxhud:=0;
  promenne:=false;
  while not eof(fi) do begin {načte seznam místností}
    readln(fi,ret);
    orizni(ret);
    uppercase(ret); {nikde nejsou title, takže to můžu udělat}
    if (ret='')or(ret[1]='{') then continue;
    slov:=slovo(ret);
    if slov='VAR' then
      promenne:=true
    else if slov='HERO' then begin {zadání jména hrdiny}
      slov:=slovo(ret);
      if hra.hero<>255 then
        chyba('multiple hero specification in the game descriptor '+slov);
      cis:=1;
      while (cis<=obj^.pocet)and(slov<>obj^.o[cis]^.id) do
        inc(cis);
      if cis>obj^.pocet then
        chyba('invalid hero name specification '+slov);
      hra.hero:=cis;
      promenne:=false;
    end else if slov='STARTROOM' then begin {startovní místnost}
      slov:=slovo(ret);
      if hra.start<>255 then
        chyba('multiple starting location specification '+slov);
      cis:=1;
      while (cis<=mist^.pocet)and(slov<>mist^.m[cis].id) do
        inc(cis);
      if cis>mist^.pocet then
        chyba('invalid starting location specification '+slov);
      hra.start:=cis;
      val(ret,cis,ch); {načteme bránu startovní místnosti}
      if (ch<>0)or(cis<1)or(cis>maxgatesmistnosti) then
        chyba('invalid starting gate specification '+ret);
      hra.gatestart:=cis;
      promenne:=false;
    end else if slov='MAPROOM' then begin {místnost s mapou}
      slov:=slovo(ret);
      if hra.map<>255 then
        chyba('multiple map location specification '+slov);
      if slov='' then begin {zde jedině je povolena absence}
        hra.map:=0;
        hra.gatemap:=0;
      end else begin
        cis:=1;
        while (cis<=mist^.pocet)and(slov<>mist^.m[cis].id) do
          inc(cis);
        if cis>mist^.pocet then
          chyba('invalid map location specification '+slov);
        hra.map:=cis;
        val(ret,cis,ch); {načteme bránu místnosti s mapou}
        if (ch<>0)or(cis<1)or(cis>maxgatesmistnosti) then
          chyba('invalid map gate specification '+ret);
        hra.gatemap:=cis;
      end;
      promenne:=false;
    end else if promenne then begin {jinak to může být jen proměnná}
      if r.pocet=maxpocetident then
        chyba('too many variables in the game descriptor');
      inc(r.pocet);
      r.i[r.pocet]:=slov;
      inc(h.pocet);
      val(ret,cis,ch);
      if (ch<>0)or(cis<-maxint)or(cis>maxint) then
        chyba('invalid initialization of variable '+slov);
      h.h[r.pocet]:=cis;
    end else
      chyba('invalid property in the game descriptor '+slov);
  end;
  close(fi);

  getmem(init,sizeof(hra)+1+r.pocet*sizeof(integer)); {zařadí načtené proměnné}
  init^.prom.pocet:=h.pocet;
  for cis:=1 to h.pocet do
    init^.prom.h[cis]:=h.h[cis];
  init^.start:=hra.start;
  init^.map:=hra.map;
  init^.hero:=hra.hero;
  init^.gatestart:=hra.gatestart;
  init^.gatemap:=hra.gatemap;
  init^.imaxx:=hra.imaxx;
  init^.imaxy:=hra.imaxy;
  init^.maxhud:=hra.maxhud;
end;

procedure nacti1jmenaanimaci(
  soub:string;
  var obj:tobjektu);
var x:word;
begin
  obj^.cestaanim:=soub;
  soub:=soub+'.an4';
  x:=getarchiveoccupy(soub);
  if x<>0 then {x=0 ---> chyba v archívu ---> ponechá se 0 animací}
    dec(x); {jinak se sníží počet}
  getmem(obj^.anim,2+x*sizeof(pstring));
  getmem(obj^.useanim,2+x*sizeof(integer));
  {1. složka je nějaké smetí}
  obj^.anim^.pocet:=x;
  obj^.useanim^.pocet:=x;
  for x:=1 to x do begin {načte do paměti všechna jména}
    cloaditem(soub,pointer(obj^.anim^.r[x]),x+1);
    obj^.useanim^.h[x]:=0;
    uppercase(obj^.anim^.r[x]^);
  end;
{!bacha při dealokaci, že to vždy zabere 13 znaků!
 odebrat původní příponu!}
end;

procedure nactijmenaanimaci(
  soub:string;
  obj:pseznamobjektu);
var fi:text;
    cis:integer;
    ret,slov:string;
begin
  otevrisouborcteni(soub,fi);
  cis:=0;
  while not eof(fi) do begin {načte seznam místností}
    readln(fi,ret);
    orizni(ret);
    uppercase(ret); {jak label, tak i samotný identifikátor to vyžaduje}
    if (ret='')or(ret[1]='{') then continue;
    slov:=slovo(ret);
    if slov='OBJECT' then begin
      {zda měl nebo neměl poslední objekt animace, se předsvědčíme až na
       konci hromadně, zatím jen zvýšíme číslo}
      inc(cis);
      obj^.o[cis]^.anim:=nil;
      obj^.o[cis]^.useanim:=nil;
    end else if slov='SEQ' then begin
      if cis=0 then
        chyba('definition of SEQ '+ret+' before defining an object');
      if obj^.o[cis]^.anim<>nil then
        chyba('multiple SEQ '+ret)
      else
        nacti1jmenaanimaci(fsplit2(inputpath(ret),3),obj^.o[cis]);
    end;
  end;
  if cis<>obj^.pocet then {hrdina byl taky v tomto souboru}
    chyba('(internal) mismatched number of objects after reading animation sequences');
  for cis:=1 to obj^.pocet do begin
    if obj^.o[cis]^.anim=nil then begin {objekt neměl animace:}
      getmem(obj^.o[cis]^.anim,1);
      obj^.o[cis]^.anim^.pocet:=0;
    end;
    if obj^.o[cis]^.useanim=nil then begin {pro jistotu další if}
      getmem(obj^.o[cis]^.useanim,1);
      obj^.o[cis]^.useanim^.pocet:=0;
    end;
    if cis=1 then {zapíšeme si index animací}
      obj^.o[cis]^.idxanim:=0
    else
      obj^.o[cis]^.idxanim:=obj^.o[cis-1]^.idxanim+obj^.o[cis-1]^.anim^.pocet;
  end;

  close(fi);
end;

procedure seznamovacikancelar(
  var mist:pseznammistnosti;
  var obj:pseznamobjektu;
  var ikon:pseznamikon;
  var pov:pseznampovidacku;
  var init:pinithry;
  var ret,rozh,pal,hud,map:pseznamretezcu;
  var pricistret:integer;
  var pocitret:longint;
  var soubret1:tpracsoubret1;
  var soubret2:tpracsoubret2);
var r:tseznamident;
    x:integer;

  procedure vyrobsouboridentifikatoru(var prom:tseznamident);
  var fi,fo:text;
      ret:string;
      x:integer;
  begin
    otevrisouborcteni(jmsoubident1,fi);
    otevrisouborzapis(pracsoubident2,fo);
    while not eof(fi) do begin {překopíruje původní obsah}
      readln(fi,ret);
      writeln(fo,ret);
    end;
    close(fi);

    writeln(fo);
    writeln(fo,'class 4'); {místnosti}
    for x:=1 to mist^.pocet do
      writeln(fo,mist^.m[x].id,' ',x);

    writeln(fo);
    writeln(fo,'class 2'); {objekty}
    for x:=1 to obj^.pocet do
      writeln(fo,obj^.o[x]^.id,' ',x);

    writeln(fo);
    writeln(fo,'class 3'); {ikony}
    for x:=1 to ikon^.pocet do
      writeln(fo,ikon^.i[x].id,' ',x);

    writeln(fo);
    writeln(fo,'class 8'); {mluvící postavy}
    for x:=1 to pov^.pocet do
      writeln(fo,pov^.p[x].id,' ',x);

    writeln(fo);
    writeln(fo,'class 1'); {proměnné}
    for x:=1 to r.pocet do
      writeln(fo,r.i[x],' ',x);

    writeln(fo);
    writeln(fo,'class 9'); {bloky rozhovoru}
    close(fo);
  end;

begin
  nactiseznam(jmsoubmist,r,maxpocetmistnosti, 'ROOM','locations');
  getmem(mist,2+r.pocet*sizeof(tmistnosti));
  mist^.pocet:=r.pocet;
  for x:=1 to r.pocet do
    mist^.m[x].id:=r.i[x];
  write('read names of locations, ');

  nactiseznam(jmsoubobj,r,maxpocetobjektu, 'OBJECT','objects');
  getmem(obj,2+r.pocet*sizeof(tobjektu)); {hrdina je zahrnut v tom}
  obj^.pocet:=r.pocet;
  for x:=1 to r.pocet do begin
    new(obj^.o[x]);
    obj^.o[x]^.id:=r.i[x];
  end;
  write('objects, ');

  nactiseznam(jmsoubikon,r,maxpocetikon, 'ICON','items');
  getmem(ikon,2+r.pocet*sizeof(tikony));
  ikon^.pocet:=r.pocet;
  for x:=1 to r.pocet do
    ikon^.i[x].id:=r.i[x];
  write('items, ');

  nactiseznam(jmsoubmluveni,r,maxpocetpovidacku, 'PERSON','persons');
  getmem(pov,2+r.pocet*sizeof(tpovidacka));
  pov^.pocet:=r.pocet;
  for x:=1 to r.pocet do
    pov^.p[x].id:=r.i[x];
  writeln('persons');
  {nyní se seznámil s místnostmi, objekty, ikonami a mluvícími postavami}

  nactiinithry(obj,mist, init,r);
  writeln('read game descriptor and initialized variables');
  {nyní načetl seznam všech proměnných s jejich inicializačními hodnotami
   jména proměnných jsou uložena v poli r, hodnoty v init^
   rovněž byly načteny ostatní položky initu hry}

  vyrobsouboridentifikatoru(r);
  {teď vyrobil správný soubor jmsoubident2,
   jména promněnných nejsou uložena natrvalo, takže jsou v prac. poli r!}
  writeln('created file of identifiers');

  nactijmenaanimaci(jmsoubobj,obj);
  {nyní jsme načetl, které animace má který objekt}
  writeln('read names of object animations');

  getmem(ret,2+maxretezcu*sizeof(pstring)); {alokuj 1000 pozic pro řetězce}
  ret^.pocet:=0; {vyrovnávací pamět, viz. k3}
  pricistret:=0; {skutečné počítadlo indexů}
  pocitret:=0;   {skutečné počítadlo pozic}

  otevrifilesouborzapis(pracsoubret1,soubret1); {otevře 2 pracovní soubory}
  otevrifilesouborzapis(pracsoubret2,soubret2);
  smazsoubor(vysoubretezcu); {smaže výstupní dfw soubor}

  getmem(rozh,2+maxrozhovoru*sizeof(pstring)); {rozhovory}
  rozh^.pocet:=0;

  getmem(pal,2+maxpalet*sizeof(pstring)); {palety}
  pal^.pocet:=0;

  getmem(hud,2+maxhudeb*sizeof(pstring)); {hudby}
  hud^.pocet:=0;

  getmem(map,2+maxmap*sizeof(pstring)); {mapy}
  map^.pocet:=0;

  smazsoubor(pracprogramy);
  writeln('allocated strings, dialogs, and palettes');
end;

procedure dealokujseznamy(
  var mist:pseznammistnosti;
  var obj:pseznamobjektu;
  var ikon:pseznamikon;
  var pov:pseznampovidacku;
  var init:pinithry;
  var ret,rozh,pal,hud,map:pseznamretezcu);
var x,y:integer;
begin
{  for x:=1 to mist^.pocet do
    freemem(mist^.m[x].kod,2+maxobjdelkakodu*sizeof(integer));}
  freemem(mist,2+mist^.pocet*sizeof(tmistnosti));
  for x:=1 to obj^.pocet do begin {výmaz odkazů na animace u objektů}
    for y:=1 to obj^.o[x]^.anim^.pocet do
      freemem(obj^.o[x]^.anim^.r[y],13);
    freemem(obj^.o[x]^.anim,2+obj^.o[x]^.anim^.pocet*sizeof(pstring));
    freemem(obj^.o[x]^.useanim,2+obj^.o[x]^.useanim^.pocet*sizeof(integer));
{    freemem(obj^.o[x].kod,2+maxobjdelkakodu*sizeof(integer));}
    dispose(obj^.o[x]);
  end;
  freemem(obj,2+obj^.pocet*sizeof(tobjektu));
{  for x:=1 to ikon^.pocet do
    freemem(ikon^.i[x].kod,2+maxobjdelkakodu*sizeof(integer));}
  freemem(ikon,2+ikon^.pocet*sizeof(tikony));
  freemem(pov,2+pov^.pocet*sizeof(tpovidacka));
  freemem(init,12+init^.prom.pocet*sizeof(integer));

  for x:=1 to ret^.pocet do
    freemem(ret^.r[x],length(ret^.r[x]^)+1);
  freemem(ret,2+maxretezcu*sizeof(pstring));

  for x:=1 to rozh^.pocet do
    freemem(rozh^.r[x],length(rozh^.r[x]^)+1);
  freemem(rozh,2+maxrozhovoru*sizeof(pstring));

  for x:=1 to pal^.pocet do
    freemem(pal^.r[x],length(pal^.r[x]^)+1);
  freemem(pal,2+maxpalet*sizeof(pstring));

  for x:=1 to hud^.pocet do
    freemem(hud^.r[x],length(hud^.r[x]^)+1);
  freemem(hud,2+maxhudeb*sizeof(pstring));

  for x:=1 to map^.pocet do
    freemem(map^.r[x],length(map^.r[x]^)+1);
  freemem(map,2+maxmap*sizeof(pstring));
  writeln('deallocated all property lists');
end;

procedure inicializujgpl2(
  var ident:pident;
  var maxident:byte;
  var prik,talk:pprikaz);
var x:byte;
begin
  x:=nactiidentifikatory(pracsoubident2,ident,maxident);
  if x<>0 then chyba(chybhlasky[x]);
  x:=nactiprikazy(jmsoubprikgpl2,prik,talk,maxident);
  if x<>0 then chyba(chybhlasky[x]);
  writeln('read list of identifiers and gpl2 commands');
end;

procedure dealokujgpl2(
  var ident:pident;
  var prik:pprikaz);
begin
  dealokujidentifikatory(ident);
  dealokujprikazy(prik);
  writeln('deallocated list of identifiers and gpl2 commands');
end;

procedure nastavcesty;
begin
  if paramcount > 2 then begin
    writeln('usage: k3 [<input directory>] [<output directory>]');
    writeln;
    writeln('both parameter are optional, defaulting to the current directory');
    writeln('when only 1 parameter is present, it denotes the input');
    writeln('if you need to specify just the output, use `k3 . output''');
    halt(0);
  end;

 {vstupní adresář vč. / na konci}
  if paramcount >= 1 then
    jmvstupnicesty:=paramstr(1)
  else
    jmvstupnicesty:='.';
  if jmvstupnicesty[length(jmvstupnicesty)]<>directory_separator then
    jmvstupnicesty:=jmvstupnicesty+directory_separator;
  jmvstupnicesty:=fexpand(jmvstupnicesty);

  jmsoubident1:=jmvstupnicesty+jmsoubident1;
  jmsoubprikgpl2:=jmvstupnicesty+jmsoubprikgpl2;

  jmsoubinit:=jmvstupnicesty+jmsoubinit;
  jmsoubmist:=jmvstupnicesty+jmsoubmist;
  jmsoubobj:=jmvstupnicesty+jmsoubobj;
  jmsoubikon:=jmvstupnicesty+jmsoubikon;
  jmsoubmluveni:=jmvstupnicesty+jmsoubmluveni;

  {vystupní adresář vč. / na konci}
  if paramcount >= 2 then
    jmvystupnicesty:=paramstr(2)
  else
    jmvystupnicesty:='.';
  if jmvystupnicesty[length(jmvystupnicesty)]<>directory_separator then
    jmvystupnicesty:=jmvystupnicesty+directory_separator;
  jmvystupnicesty:=fexpand(jmvystupnicesty);

  vysoubretezcu:=jmvystupnicesty+vysoubretezcu;
  vysoubemsretezcu:=jmvystupnicesty+vysoubemsretezcu;
  vysoubrozhovoru:=jmvystupnicesty+vysoubrozhovoru;
  vysoubhudeb:=jmvystupnicesty+vysoubhudeb;
  vysoubmap:=jmvystupnicesty+vysoubmap;
  vysoubpalet:=jmvystupnicesty+vysoubpalet;
  vysoubmasek:=jmvystupnicesty+vysoubmasek;

  vysoubinit:=jmvystupnicesty+vysoubinit;
  vysoubmist:=jmvystupnicesty+vysoubmist;
  vysoubobj:=jmvystupnicesty+vysoubobj;
  vysoubikon:=jmvystupnicesty+vysoubikon;

  vysoubobrikon:=jmvystupnicesty+vysoubobrikon;
  vysoubobranim:=jmvystupnicesty+vysoubobranim;
  vysoubsamanim:=jmvystupnicesty+vysoubsamanim;
  vysoubanim:=jmvystupnicesty+vysoubanim;

  pracsoubident2:=jmvystupnicesty+pracsoubident2;
  pracsoubident3:=jmvystupnicesty+pracsoubident3;
  pracsoubret1:=jmvystupnicesty+pracsoubret1;
  pracsoubret2:=jmvystupnicesty+pracsoubret2;
  pracprogramy:=jmvystupnicesty+pracprogramy;

  writeln('input path: ', jmvstupnicesty);
  writeln('output path: ', jmvystupnicesty);
end;

end.

{todo: nebylo by lepší hrdinu z initu přenést mezi objekty a v initu
       pouze uvést, který to je? bylo! done!
       184. řádek (nacti1jmenaanimaci)
       ošetřit třeba případ 0 proměnných (ať se nevolá getmem)}
{!spravit dfw, aby nedělalo špatně se soubory, protože při zápisu do
 neexistujícího adresáře to pak nevypíše ani chybovou hlášku, jak se
 to zblbne!}
