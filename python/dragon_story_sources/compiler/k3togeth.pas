{společné definice v kompilátoru her 3. verze}

unit k3togeth;
interface
uses gpl2;

const jmsoubident1:string='ident';
      jmsoubprikgpl2:string='gpl2';

      jmsoubinit:string='init';
      jmsoubmist:string='mist';
      jmsoubobj:string='objekty';
      jmsoubikon:string='ikony';
      jmsoubmluveni:string='mluveni';

      jmvstupnicesty:string='';

      pracsoubident2:string='ident.$$$'; {vč. jmen místností apod...}
      pracsoubident3:string='ident.$$1'; {pro rozhovry, vč. jmen bloků}
      pracsoubret1:string='retezce.1';   {longintové indexy}
      pracsoubret2:string='retezce.2';   {samotné texty}
      pracprogramy:string='programy.$$$';

      vysoubretezcu:string='retezce.dfw';
      vysoubemsretezcu:string='retezce.ems';
      vysoubrozhovoru:string='rozh'; {přidají se přípony:}
      vysoubhudeb:string='hudba';
      vysoubmap:string='mapy.dfw';
      vysoubpalet:string='palety.dfw';
      vysoubmasek:string='obr_mas.dfw';

      vysoubinit:string='init.dfw';
      vysoubmist:string='mist.dfw';
      vysoubobj:string='objekty.dfw';
      vysoubikon:string='ikony.dfw';
{      vysoubmluveni:string='mluveni.dfw';}

      vysoubobrikon:string='obr_ik.dfw';
      vysoubobranim:string='obr_an.dfw';
      vysoubsamanim:string='sam_an.dfw';
      vysoubanim:string='anim.dfw';

      jmvystupnicesty:string='';

      {Free Pascal defines this.  One can also test its presence using FPC.}
      {$ifdef Unix}
      directory_separator = '/';
      {$else}
      directory_separator = '\';
      {$endif}

      maxdelkaident=30;
      maxpocetmistnosti=40;
      maxpocetobjektu=600;
      maxpocetikon=100;
      maxpocetpovidacku=40;
      maxpocetident=600;
      maxpocetanimaciobjektu=30;
      maxgatesmistnosti=10;
      maxobjdelkakodu=3000;
      maxrozhovoru=50;
      maxpalet=50;
      maxblokurozhovoru=30;
      maxpocetmasek=20;
      maxhudeb=20;
      maxmap=50;

      cervenabarva=254; {pro stin kolem ikonek}

      deleniretezcunabloky=30000;

type tident=string[maxdelkaident];
     pathstr=string[120];

     pmistnosti=^tmistnosti;
     pobjektu=^tobjektu;
     pikony=^tikony;
     ppovidacka=^tpovidacka;

     pseznammistnosti=^tseznammistnosti;
     pseznamobjektu=^tseznamobjektu;
     pseznamikon=^tseznamikon;
     pseznampovidacku=^tseznampovidacku;

     pseznamident=^tseznamident;
     pseznamhodnot=^tseznamhodnot;

     pinithry=^tinithry;

     tmistnosti=record
       id:tident;
       title:string[1];
       init,look,use,canuse:integer; {viz. ikony}
       iminit,imlook,imuse:byte;

       obr,mus,mask,map:pathstr;
       mouse,hero:byte; {0 nebo 1}
       persp0,perspstep:real;
       escroom:byte;
       gates:byte;
       gate:array[1..maxgatesmistnosti]of integer; {programy}

       kod:pkod;
     end;

     pomtobjektu=record
       id:tident;
       title:string[35];
       init,look,use,canuse:integer; {viz. ikony}
       iminit,imlook,imuse:byte;

       typ:byte; {nic, left, right...}
       status:byte; {0, 1 nebo 2}
       mistnost:byte;
       priorita:byte;
       cestaanim:pathstr;
       anim:pseznamretezcu;
       idxanim:integer; {kolikátá v dfw bude 1. animace}
       useanim:pseznamhodnot; {byla ta která animace použita?}

       xlook,ylook,xuse,yuse:integer;
       smerlook,smeruse:byte;

       kod:pkod;
     end;
     tobjektu=^pomtobjektu; {aby se to vešlo do paměti, dám tam ukazatele}

     tikony=record
       id:tident;
       title:string[30];
       init,look,use,canuse:integer;
       {jsou to indexy do kódu, kde to začíná, končí to příkazem 0 --- EXIT,
        kromě canuse, tam není příkaz, ale jenom matematický výraz (stejně
        jako by se předával jako parametr)}
       iminit,imlook,imuse:byte; {switche immidiately: 0 nebo 1}

       status:byte; {0 nebo 1}
       obr:pathstr;

       kod:pkod;
     end;

     tpovidacka=record {seznam povídacích postav}
       id:tident; {jméno}
       x,y:integer; {kde a jakou barvou mluví}
       barva:integer;
     end;


     tseznammistnosti=record
       pocet:integer;
       m:array[1..maxpocetmistnosti]of tmistnosti;
     end;

     tseznamobjektu=record
       pocet:integer;
       o:array[1..maxpocetobjektu]of tobjektu;
     end;

     tseznamikon=record
       pocet:integer;
       i:array[1..maxpocetikon]of tikony;
     end;

     tseznampovidacku=record
       pocet:integer;
       p:array[1..maxpocetpovidacku]of tpovidacka;
     end;

     tseznamident=record {než se naalokuje hlavní pole, zde se to střádá}
       pocet:integer;
       i:array[1..maxpocetident]of tident;
     end;

     tseznamhodnot=record
       pocet:integer;
       h:array[1..maxpocetident]of integer;
     end;

     {kod a seznamretezcu je dovezen z gpl2
      stejně jako maxdelkakodu a maxretezcu
      ale maxobjdelkakodu (pro 1 objekt) je definována zde}

     tinithry=record
       start,map,hero:byte;
       gatestart,gatemap:byte;
       imaxx,imaxy:integer;
       maxhud:word;
       prom:tseznamhodnot;
     end;

     tpracsoubret1=file; {longinty}
     tpracsoubret2=file; {řetězce}

procedure chyba(text:string);
procedure otevrisouborcteni(jm:string;var fi:text);
procedure otevrisouborzapis(jm:string;var fi:text);
procedure otevrifilesouborcteni(jm:string;var fi:file);
procedure otevrifilesouborzapis(jm:string;var fi:file);
function inputpath(ret:string):string;
function fsplit2(ret:string;typ:byte):string;
procedure smazsoubor(soubor:string);
function existujesoubor(soubor:string):boolean;
procedure nactiseznam(
  jmsoub:string;
  var r:tseznamident;
  maxpocet:integer;
  lab,nazev:string);
procedure kopirujsoubor(r1,r2:string);
procedure prejmenujsoubor(r1,r2:string);
function najdivseznamuretezcu(kde:pseznamretezcu; pridat:boolean; ret:string):byte;

implementation
uses dos,
     crt,
     together;

procedure pip;
begin
  sound(880);
  delay(10);
  nosound;
end;

procedure chyba(text:string);
begin
  if ioresult<>0 then;
  writeln(text);
  pip;
  halt(1);
end;

procedure otevrisouborcteni(jm:string;var fi:text);
begin
  assign(fi,jm);
  {$i-} reset(fi); {$i+}
  if ioresult<>0 then
    chyba('cannot open file ' + jm + ' for reading');
end;

procedure otevrisouborzapis(jm:string;var fi:text);
begin
  assign(fi,jm);
  {$i-} rewrite(fi); {$i+}
  if ioresult<>0 then
    chyba('cannot open file ' + jm + ' for writing');
end;

procedure otevrifilesouborcteni(jm:string;var fi:file);
begin
  assign(fi,jm);
  {$i-} reset(fi,1); {$i+}
  if ioresult<>0 then
    chyba('cannot open binary file ' + jm + ' for reading');
end;

procedure otevrifilesouborzapis(jm:string;var fi:file);
begin
  assign(fi,jm);
  {$i-} rewrite(fi,1); {$i+}
  if ioresult<>0 then
    chyba('cannot open binary file ' + jm + ' for writing');
end;

{var mem,max:longint;
    oldexitproc:pointer;

$f+
procedure kontrolapameti; far;
begin
  exitproc:=oldexitproc;
  if (mem<>memavail)or(max<>maxavail) then begin
    writeln('original mem: ',mem:10,    ' original max: ',max:10);
    writeln('current mem: ',memavail:10,' current max: ',maxavail:10);
    chyba('memory size mismatch at the end of the program');
  end;
end;
$f-}

{Returns fully specified path, expanded with respect to jmvstupnicesty.}
function inputpath(ret:string):string;
var i:byte;
begin
  for i:=1 to length(ret) do
    if ret[i] in ['A'..'Z'] then
      inc(ret[i], ord('a') - ord('A'));
  if (length(ret) >= 2) and (ret[2] = ':') then
    inputpath := ret
  else if (ret <> '') and (ret[1] = '\') then
    inputpath := jmvstupnicesty[1] + ':' + ret
  else
    inputpath := fexpand(jmvstupnicesty + ret);
end;

function fsplit2(ret:string;typ:byte):string;
var d:dirstr;
    n:namestr;
    e:extstr;
begin
  fsplit(fexpand(ret),d,n,e);
  ret:='';
  if typ and 1<>0 then
    ret:=d;
  if typ and 2<>0 then
    ret:=ret+n;
  if typ and 4<>0 then
    ret:=ret+e;
  fsplit2:=ret;
end;

procedure smazsoubor(soubor:string);
var fo:file;
begin
  assign(fo,soubor);
  {$i-} reset(fo,1); {$i+}
  if ioresult=0 then begin {existuje-li daný soubor}
    close(fo);
    {$i-} erase(fo); {$i+}
    if ioresult<>0 then
      chyba('cannot remove file '+soubor);
  end;
end;

function existujesoubor(soubor:string):boolean;
var fi:file;
begin
  assign(fi,soubor);
  {$i-} reset(fi); {$i+}
  if ioresult=0 then begin
    close(fi);
    existujesoubor:=true;
  end else
    existujesoubor:=false;
end;

procedure nactiseznam(
  jmsoub:string;
  var r:tseznamident;
  maxpocet:integer;
  lab,nazev:string);
var fi:text;
    slov,ret:string;
begin
  otevrisouborcteni(jmsoub,fi);
  r.pocet:=0;
  while not eof(fi) do begin {načte seznam řetězců}
    readln(fi,ret);
    orizni(ret);
    uppercase(ret); {jak label, tak i samotný identifikátor to vyžaduje}
    if (ret='')or(ret[1]='{') then continue;
    slov:=slovo(ret);
    if slov=lab then begin
      if r.pocet=maxpocet then
        chyba('too many '+nazev);
      inc(r.pocet);
      r.i[r.pocet]:=slovo(ret); {jen 1. slovo --- třeba `object a left'!}
    end;
  end;
  close(fi);
end;

procedure kopirujsoubor(r1,r2:string);
var fi,fo:file;
    p:pointer;
    del:word;
begin
  otevrifilesouborcteni(r1,fi);
  otevrifilesouborzapis(r2,fo);
  getmem(p,60000);
  while not eof(fi) do begin
    blockread(fi,p^,60000,del);
    blockwrite(fo,p^,del);
  end;
  freemem(p,60000);
  close(fi);
  close(fo);
end;

procedure prejmenujsoubor(r1,r2:string);
var fi:file;
begin
  assign(fi,r1);
  {$i-} rename(fi,r2); {$i+}
  if ioresult<>0 then chyba('cannot rename file '+r1+'--->'+r2);
end;

function najdivseznamuretezcu(kde:pseznamretezcu; pridat:boolean; ret:string):byte;
var x:byte;
begin
  x:=1;
  while (x<=kde^.pocet)and(ret<>kde^.r[x]^) do
    inc(x); {vyhledá v seznamu použitých řetězců}
  if x>kde^.pocet then {nenalezena animace?}
    if pridat then begin {přidá další řetězec}
      inc(kde^.pocet);
      getmem(kde^.r[kde^.pocet],length(ret)+1);
      kde^.r[kde^.pocet]^:=ret;
    end else
      x:=0;
  najdivseznamuretezcu:=x;
end;

begin
  {mem:=memavail;
  max:=maxavail;
  oldexitproc:=exitproc;
  exitproc:=@kontrolapameti;}
end.

{todo: pamatovat si immidiately!
 předělat všechno na integery!
  tedy tam, kde se dává +1 místo teď +2!!!!!
:předělal jsem objekty na pole ukazatelů a fachá to stejně, ale je to pole
 max 255 objektů; když dám beze změny integer, zkurví se to a to je dobře,
 protože musí --- špatně se naalokuje paměť
 nyní jsem všude předělal správnou alokaci paměti na +2
 a indexy předělal z bytu na integer
 nezbývá než to u Pavla pořádně vyzkoušet
!pozor na to, že ve výstupní init-hlavičce je počet objektů typu integer!}
