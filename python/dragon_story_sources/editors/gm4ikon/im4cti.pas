{čtečka seznamu mistností z textového souboru --- seznamu}

unit im4cti;
interface

const maxpocetmistnosti=100;

type pmistnost=^tmistnost;
     tmistnost=record
       symb,jm:string;
       obr:string;
      _jm,_obr:boolean;
      {co bylo skutečně ve vstupním souboru obsaženo}
     end;

     tseznammistnosti=record
       pocet:byte;
       m:array[1..maxpocetmistnosti]of pmistnost;
     end;

function jinapripona(jmeno:string; adr,prip:string):string;
function ctiseznammistnosti(soubor:string; var m:tseznammistnosti):integer;
{vč. kontroly vstupního souboru}
procedure dealokujseznammistnosti(var m:tseznammistnosti);

function pridejdoseznamumistnosti(soubor:string; var m:tseznammistnosti;
                                  mist:tmistnost):integer;
function vymazzeseznamumistnosti(soubor,pomsoub:string;
                                 var m:tseznammistnosti;
                                 idx:integer):integer;
function zmenseznammistnosti(soubor,pomsoub:string;
                             var m:tseznammistnosti;
                             idx:integer; mist:tmistnost):integer;
{pracují jak s pamětí, tak s diskovými soubory}

implementation
uses dos,together,
     im4toget,
     graph256,dialog;

function jinapripona(jmeno:string; adr,prip:string):string;
var d:dirstr;
    n:namestr;
    e:extstr;
begin
  if jmeno='' then
    jinapripona:=''
  else begin
    fsplit(jmeno,d,n,e);
    if adr[length(adr)]<>'\' then
      adr:=adr+'\';
    jinapripona:=adr+n+prip;
  end;
end;

function ctiseznammistnosti(soubor:string; var m:tseznammistnosti):integer;
label konecschybou;
var fi:text;
    slov,ret:string;

procedure opravposlmistnost;
begin
  if m.pocet>0 then
    with m.m[m.pocet]^ do begin
      if not _jm then
        jm:=symb;
      if not _obr then
        obr:='';
    end;
end;

begin
  ctiseznammistnosti:=1;{chyba}
  m.pocet:=0;
  assign(fi,soubor);
  {$i-} reset(fi); 
  if ioresult<>0 then exit; {prázdný seznam místností, chyba bez close}
  {$i+}
  while not eof(fi) do begin
    readln(fi,ret);
    orizni(ret);
    slov:=slovo(ret);
    uppercase(slov);
    if slov='ICON' then begin
      if m.pocet<>0 then
        opravposlmistnost;
      inc(m.pocet);
      new(m.m[m.pocet]);
      fillchar(m.m[m.pocet]^,sizeof(tmistnost),0);
      m.m[m.pocet]^.symb:=ret;
    end else if slov='TITLE' then begin
      if m.pocet=0 then goto konecschybou;
      if m.m[m.pocet]^._jm then goto konecschybou;
      m.m[m.pocet]^._jm:=true;
      m.m[m.pocet]^.jm:=ret;
    end else if slov='PICTURE' then begin
      if m.pocet=0 then goto konecschybou;
      if m.m[m.pocet]^._obr then goto konecschybou;
      m.m[m.pocet]^._obr:=true;
      m.m[m.pocet]^.obr:=ret;
    end;
    {jinak řádek ignoruje}
  end;
  opravposlmistnost;
  ctiseznammistnosti:=0; {bez chyby}

konecschybou:
  close(fi);
end;

procedure dealokujseznammistnosti(var m:tseznammistnosti);
var x:byte;
begin
  for x:=1 to m.pocet do
    dispose(m.m[x]);
end;

function pridejdoseznamumistnosti(soubor:string; var m:tseznammistnosti;
                                  mist:tmistnost):integer;
{přidá jak do seznamu v paměti, tak do diskového souboru}
var fo:text;
begin
  pridejdoseznamumistnosti:=1;{chyba}
  inc(m.pocet);
  new(m.m[m.pocet]);
  m.m[m.pocet]^:=mist;
  assign(fo,soubor);
  {$i-} append(fo); {$i+}
  if ioresult<>0 then
    exit;

  writeln(fo,'ICON ',mist.symb);
  writeln(fo,'     TITLE ',mist.jm);
  writeln(fo,'     PICTURE ',mist.obr);
  writeln(fo);

  pridejdoseznamumistnosti:=0;{bez chyby}
  close(fo);
end;

procedure vymazsoubor(soubor:string);
var fo:file;
begin
  if soubor='' then
    exit;
  assign(fo,soubor);
  {$i-} reset(fo,1); {$i+}
  if ioresult=0 then begin {existuje-li daný soubor}
    close(fo);
    {$i-} erase(fo); {$i+}
    if ioresult<>0 then
      write(#7);
  end;
end;

procedure vymazstaremaskymapy(m:tseznammistnosti;
                              idx:integer;
                              mist:pmistnost);
begin
  setvisualpage(1);
  setactivepage(1);
  if (mist=nil)or(fexpand(m.m[idx]^.obr)<>fexpand(mist^.obr)) then
    if standardnidialog('Mám vymazat starý obrázek ikony?',
       dcolor[1],dcolor[2],dcolor[3],dcolor[4],dcolor[5],font,ano_ne)=1 then
    vymazsoubor(m.m[idx]^.obr);
end;

function vymazzeseznamumistnosti(soubor,pomsoub:string;
                                 var m:tseznammistnosti;
                                 idx:integer):integer;
{vymaže jak ze seznamu v paměti, tak z diskového souboru}
var fi,fo:text;
    i:integer;
    ret1,ret,slov:string;
    nekopirovat:boolean;
begin
  vymazstaremaskymapy(m,idx,nil);

  vymazzeseznamumistnosti:=1;{chyba}
  assign(fi,soubor);
  assign(fo,pomsoub);
  {$i-}
  reset(fi); if ioresult<>0 then exit;
  rewrite(fo); if ioresult<>0 then begin close(fi); exit; end;
  {$i+}

  nekopirovat:=false;
  while not eof(fi) do begin {dokud nebude konec vstupu}
    readln(fi,ret); {načti řádek}
    ret1:=ret;
    orizni(ret);
    slov:=slovo(ret);
    uppercase(slov);
    if slov='ICON' then {u každé kapitoly se rozhodne, zda se bude kopírovat}
      nekopirovat:=ret=m.m[idx]^.symb;
    if not nekopirovat then
      writeln(fo,ret1);
  end;

  close(fo);
  close(fi);
  {$i-}
  erase(fi);            if ioresult<>0 then exit;
  rename(fo,soubor);    if ioresult<>0 then exit;
  {$i+}

  dispose(m.m[idx]); {vymaže i z paměti}
  dec(m.pocet);
  for i:=idx to m.pocet do
    m.m[i]:=m.m[i+1];

  vymazzeseznamumistnosti:=0;{bez chyby}
end;

function zmenseznammistnosti(soubor,pomsoub:string;
                             var m:tseznammistnosti;
                             idx:integer; mist:tmistnost):integer;
{změní místnost jak v seznamu v paměti, tak v diskovém souboru}
var fi,fo:text;
    ret1,ret,slov:string;
    menit:boolean;

procedure pripistocotamnebylo;
begin
  with mist do begin
    writeln(fo,ret1);
    if not m.m[idx]^._jm then begin
      writeln(fo,'     TITLE ',jm);
      _jm:=true;
    end;
    if not m.m[idx]^._obr then begin
      writeln(fo,'     PICTURE ',obr);
      _obr:=true;
    end;
  end;
end;

begin
  vymazstaremaskymapy(m,idx,@mist);

  zmenseznammistnosti:=1;{chyba}
  assign(fi,soubor);
  assign(fo,pomsoub);
  {$i-}
  reset(fi); if ioresult<>0 then exit;
  rewrite(fo); if ioresult<>0 then begin close(fi); exit; end;
  {$i+}

  menit:=false;
  while not eof(fi) do begin {dokud nebude konec vstupu}
    readln(fi,ret); {načti řádek}
    ret1:=ret;
    orizni(ret);
    slov:=slovo(ret);
    uppercase(slov);
    if slov='ICON' then {u každé kapitoly se rozhodne, zda se bude kopírovat}
      menit:=ret=m.m[idx]^.symb;
    if not menit then
      writeln(fo,ret1)
    else begin {musíme připsat (nebyly-li tam) nebo změnit (naopak) dané
                řádky}
      if slov='ICON' then {na hlavičce místnosti doplníme chybějící položky
                           a označíme, že už nechybí}
        pripistocotamnebylo
      else if slov='TITLE' then {ostatní parametry změníme, až nám přijdou}
        writeln(fo,'     TITLE ',mist.jm)
      else if slov='PICTURE' then
        writeln(fo,'     PICTURE ',mist.obr)
      else
        writeln(fo,ret1);
    end;
  end;

  close(fo);
  close(fi);
  {$i-}
  erase(fi);            if ioresult<>0 then exit;
  rename(fo,soubor);    if ioresult<>0 then exit;
  {$i+}

  m.m[idx]^:=mist;

  zmenseznammistnosti:=0;{bez chyby}
end;

end.

{todo: nesmí se 2 místnosti jmenovat stejně, zblbne se na tom nejenom
       třeba kompilátor, ale i tyto rutiny
       možná udělat vlastnosti do pole a číst to přes index}
