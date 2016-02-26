{$A+,B-,D+,E+,F-,G+,I-,L+,N-,O-,P-,Q-,R-,S-,T-,V+,X+,Y+}
{$M 16384,0,200000}

program instaluj;
uses graph256,graform,editor,dialog,dos,crt;
const jmenopozadi='instback.pcx';
      configsoubor='dh.bat';
      lukasuvhnusnejprogram='setup.exe';
      jmenokomprpgm='dwc.___';
      jmenokomprsoub='dh.dwc';
      pozadovanovolno=17000000;
      delkakompr={4060633}3945234;
      pocetdisket=3;
      dcolor:array[1..5]of byte=
        (255{popr},227{poz},254{podtr?},249{ram?},229{okr});
      kolikuz:longint=0;
      signatura='dh.';
      delkacopybufferu=60000;
var poz,pal:pointer;
    vstcesta,vystcesta,cdsamcesta:string;
    ktera:integer;
    kamhru:string;
    spoj:file;

procedure chyba(text:string);
begin
  closegraph;
  textmode(co80);
  writeln('chyba: ',text,#7);
  halt(1);
end;

procedure chybaLukS(text:string);
begin
  writeln(text);
  halt(1);
end;

procedure pip;
begin
  sound(440);
  delay(50);
  sound(880);
  delay(50);
  nosound;
end;

procedure init;
begin
  if paramcount>0 then
    kamhru:=paramstr(1)
  else
    kamhru:='';
  if not sti('inst.gcf','inst.pal','inst.fon') then
    chybaLukS('nelze spustit instal. program');
  initmouse;
{  initgraph;
  lastline:=200;
  ActivePage := 0;
  setvisualpage(0);
  setactivepage(0);
  OverFontColor:=255;
  FonColor1:=7;
  FonColor2:=2;
  FonColor3:=3;
  FonColor4:=4;
  if registerfont(font,'stand2.fon') then
    chyba('nelze načíst font stand2.fon');}
  if loadimage(poz,pal,jmenopozadi)<>255 then
    chyba('nelze načíst pozadí pro instalaci');
  setpalette(pal);
  putimage(0,0,poz);
  mouseon(1,1,mouseimage);
{  mouseswitchoff; {LukS}
end;

procedure done;
var fo:text;
    kam: string;
begin
  close(spoj); {spojen zkomprimovany soubor}

  assign(fo,vystcesta+configsoubor);
  rewrite(fo);
  if ioresult<>0 then begin
    standardnidialog('Chyba při zápisu na disk',
      dcolor[1],dcolor[2],dcolor[3],dcolor[4],dcolor[5],
      font,upozorneni);
  end else begin
    writeln(fo,'@echo off');
    writeln(fo,'rem Startovaci davka na hru Draci Historie');
    writeln(fo,vystcesta,'p.exe '{,vystcesta,'cd2.sam'});
    close(fo);
  end;
  freemem(pal,768);
  disposeimage(poz);
  closegraph;

  kam:= copy(vystcesta, 1, Length(vystcesta)-1);
  {kterej DEBIL to sem napsal? kam:=vystcesta; dec(kam[0]) tam byti ma}
  chdir(kam);

  SwapVectors;
  exec(vystcesta+jmenokomprpgm,'xw dh.dwc');
  SwapVectors;
  assign(fo,vystcesta+jmenokomprpgm); erase(fo);
  if ioresult<>0 then chyba('nelze smazat kompresní program');
  assign(fo,vystcesta+jmenokomprsoub); erase(fo);
  if ioresult<>0 then chyba('nelze smazat komprimovaný soubor');

  SwapVectors;
  exec(vystcesta+lukasuvhnusnejprogram,'');
  SwapVectors;

  writeln('Instalace: Bob, NoSense');
  writeln;
  writeln('Hru spustite v jejim adresari prikazem DH.BAT');
  writeln('V tom samem adresari naleznete soubor README.TXT, doporucujeme si ho precist!');
end;

function okadr(co,zpet:string):boolean;
var x:byte;
begin
  if (length(co)>3)and(co[length(co)]='\') then
    dec(co[0]);
  chdir(co);
  x:=ioresult;
  okadr:=x=0;
  chdir(zpet);
end;

function vytvorvystupnicestu:boolean;
var i,j:byte;
    disk:byte;
    nynicesta,tamcesta:string;
begin
  vytvorvystupnicestu:=false;
  if (length(vystcesta)<3)or(vystcesta[2]<>':')or(vystcesta[3]<>'\') then begin
    standardnidialog('Špatné zadání adresáře',
      dcolor[1],dcolor[2],dcolor[3],dcolor[4],dcolor[5],
      font,upozorneni);
    exit;
  end;
  if not(vystcesta[1]in['C'..'Z']) then begin
    standardnidialog('Instalace je povolena|jen na hard-disk',
      dcolor[1],dcolor[2],dcolor[3],dcolor[4],dcolor[5],
      font,upozorneni);
    exit;
  end;
  getdir(0,nynicesta);
  disk:=byte(vystcesta[1])-byte('A')+1;
  getdir(disk,tamcesta);
  i:=length(vystcesta); {zkoušíme cestu odzadu}
  repeat
    if okadr(copy(vystcesta,1,i),tamcesta) then
      break {už je cesta dobrá ---> konec}
    else begin {špatná cesta ---> zkusíme oddělat poslední adresář}
      repeat
        dec(i);
      until (i<=0)or(vystcesta[i]='\');
      if i<3 then exit;
    end;
  until false;
  chdir(nynicesta[1]+':');
  chdir(nynicesta);
  {nyní musíme až do konce cestu vytvořit}
  while i<length(vystcesta) do begin
    j:=i+1;
    while (j<length(vystcesta))and(vystcesta[j]<>'\') do
      inc(j);
    mkdir(copy(vystcesta,1,j-1));
    if ioresult<>0 then begin
      standardnidialog('Nelze vytvořit požadovanou cestu',
        dcolor[1],dcolor[2],dcolor[3],dcolor[4],dcolor[5],
        font,upozorneni);
      exit;
    end;
    i:=j;
  end;
  {kontrola volného místa}
  if diskfree(disk)<pozadovanovolno{+1200000} then begin
    standardnidialog('Na disku není potřebné|volné místo',
      dcolor[1],dcolor[2],dcolor[3],dcolor[4],dcolor[5],
      font,upozorneni);
    exit;
  end;
  assign(spoj,vystcesta+jmenokomprsoub);
  rewrite(spoj,1);
  if ioresult<>0 then begin
    standardnidialog('Nelze vytvořit|komprimovaný soubor',
      dcolor[1],dcolor[2],dcolor[3],dcolor[4],dcolor[5],
      font,upozorneni);
    exit;
  end;

  vytvorvystupnicestu:=true;
end;

procedure nactivystupnicestu;
var ed:peditor;
    d:dirstr;
    n:namestr;
    e:extstr;
    ok:boolean;
begin
  alokujeditor(ed);
  nastavedokno(ed,50,50,220,'Kam chceš nakopírovat hru?',font,font,true);
  nastavedbarvy(ed,dcolor[1],dcolor[2],dcolor[3],dcolor[5],dcolor[4],
    dcolor[5],dcolor[4]);
  nastavedparametry(ed,true,true,false,false,false,false,254,
    [' '..#127],[' ','\','/']);
  nastavedprostredi(ed,true,zadnerolovani,musibyttext,[#27],[],[#13],[]);
  if kamhru='' then
    nastavedobsah(ed,{fexpand('c:')}'c:\dh',1,1)
  else
    nastavedobsah(ed,kamhru,1,1);
  repeat
    editacetextu(ed);
    if ed^.ukakce<>1 then begin {escape}
      dealokujeditor(ed);
      closegraph;
      writeln('ukončení instalace');
      halt(0);
    end;
    vystcesta:=fexpand(ed^.edtext);
    if vystcesta[length(vystcesta)]<>'\' then
      vystcesta:=vystcesta+'\';
    ok:=vytvorvystupnicestu;
    if not ok then pip;
  until ok;

  dealokujeditor(ed);

  {getdir(0,vstcesta);}
  vstcesta:=fexpand(paramstr(0));
  fsplit(vstcesta,d,n,e);
  vstcesta:=d;
  if vstcesta[length(vstcesta)]<>'\' then
    vstcesta:=vstcesta+'\';
  vstcesta:=vstcesta;
end;

procedure vykreslibar;
begin
  mouseswitchoff;
  bar(10,160,300,30,dcolor[2]); {pozadí pro kreslení barů}
  rectangle(10,160,300,30,dcolor[5]);
  bar(10,150-heigthoffont(font),300,heigthoffont(font),dcolor[2]); {soubor}
{  mouseswitchon;{ LukS}
end;

function overdisketu(cis:byte):boolean;
var ret:string;
    s:searchrec;
begin
  str(cis,ret);
  findfirst(vstcesta+signatura+ret,anyfile,s);
  overdisketu:=doserror=0;
end;

procedure nactivstupnicestu(cis:byte);
var ed:peditor;
    ret:string[3];
    ok:boolean;
begin
  str(cis,ret);
  alokujeditor(ed);
(*
  nastavedokno(ed,50,50,220,{'Adresář diskety číslo '+ret+':'}
    'Odkud instalovat?',font,font,true); *)
  if cis=1 then
    nastavedokno(ed,50,50,220,{'Adresář diskety číslo '+ret+':'}
      'Odkud instalovat?',font,font,true)
  else
    nastavedokno(ed,50,50,220,{'Adresář diskety číslo '+ret+':'}
      'Vlož disk č.'+ret{Zmáčkni Enter...'},font,font,true);
  nastavedbarvy(ed,dcolor[1],dcolor[2],dcolor[3],dcolor[5],dcolor[4],
    dcolor[5],dcolor[4]);
  nastavedparametry(ed,true,true,false,false,false,false,254,
    [' '..#127],[' ','\','/']);
  nastavedprostredi(ed,true,zadnerolovani,musibyttext,[#27],[],[#13],[]);
  nastavedobsah(ed,vstcesta,1,1);
  repeat
    editacetextu(ed);
    if ed^.ukakce<>1 then begin
      closegraph;
      writeln('ukončení instalace');
      close(spoj);
      halt(0);
    end;
    vstcesta:=fexpand(ed^.edtext);
    if vstcesta[length(vstcesta)]<>'\' then
      vstcesta:=vstcesta+'\';
    ok:=overdisketu(cis);
    if not ok then begin
      standardnidialog('V daném adresáři se nenachází|instalační soubory',
        dcolor[1],dcolor[2],dcolor[3],dcolor[4],dcolor[5],
        font,upozorneni);
    end;
  until ok;

  dealokujeditor(ed);
end;

procedure kopirujdisketu(cis:byte);
var ret:string;
    s:searchrec;
    fi,fo:file;
    pom:pointer; del,del1:word;
begin
  mouseoff;
  getmem(pom,delkacopybufferu);

  if cis=1 then begin
    assign(fi,vstcesta+jmenokomprpgm);
    reset(fi,1);
    if ioresult<>0 then begin
      standardnidialog('Chyba při čtení|dekompresního programu|dwc.exe',
        dcolor[1],dcolor[2],dcolor[3],dcolor[4],dcolor[5],
        font,upozorneni);
      chyba('při čtení '+s.name);
    end;
    assign(fo,vystcesta+jmenokomprpgm);
    rewrite(fo,1);
    if ioresult<>0 then begin
      standardnidialog('Chyba při zápisu|dekompresního programu|dwc.exe',
        dcolor[1],dcolor[2],dcolor[3],dcolor[4],dcolor[5],
        font,upozorneni);
      chyba('při zápisu '+s.name);
    end;
    repeat
      blockread(fi,pom^,delkacopybufferu,del);
      blockwrite(fo,pom^,del,del1);
      if del1<>del then
        chyba('při zápisu '+s.name);
    until del1<>delkacopybufferu;
    close(fi);
    close(fo);
  end;


  str(cis,ret);
{  findfirst(vstcesta+'*.*',anyfile,s);}
{  while doserror=0 do begin
    if (s.name<>signatura+ret)and(s.name<>'.')and(s.name<>'..') then begin}
  s.name:=signatura+ret;
      mouseswitchoff;
      bar(10,150-heigthoffont(font),300,heigthoffont(font),dcolor[2]); {soubor}
      printtext(10,150-heigthoffont(font),
        copy(vstcesta+s.name,1,charstowidth(font,vstcesta+s.name,1,300,false)),
        font);
{      mouseswitchon;{ LukS}
      assign(fi,vstcesta+s.name);
      reset(fi,1);
      if ioresult<>0 then begin
        standardnidialog('Chyba při čtení souboru|'+s.name,
          dcolor[1],dcolor[2],dcolor[3],dcolor[4],dcolor[5],
          font,upozorneni);
        chyba('při čtení '+s.name);
      end;
      repeat
        blockread(fi,pom^,delkacopybufferu,del);
        blockwrite(spoj,pom^,del,del1);
        if del1<>del then
          chyba('při zápisu '+s.name);
        mouseswitchoff;
        bar(11+trunc(kolikuz/delkakompr*298),161,
            trunc((kolikuz+del1)/delkakompr*298)-
            trunc(kolikuz/delkakompr*298),28,dcolor[1]);
{        mouseswitchon;{ LukS}
        inc(kolikuz,del1);
        if kolikuz>delkakompr then begin
{          standardnidialog('Chyba při kopírování na disk',
            dcolor[1],dcolor[2],dcolor[3],dcolor[4],dcolor[5],
            font,upozorneni);
          chyba('Chyba při kopírování na disk');}
        end;
        while keypressed do
          case readkey of
            #27:begin
              closegraph;
              writeln('ukončení instalace');
              halt(0);
            end;
            #0:readkey;
          end;
      until del1<>delkacopybufferu;
      close(fi);
{    end;
    findnext(s);
  end;}

  freemem(pom,delkacopybufferu);
end;

procedure LukS;
var mcesta:string;
    i : byte;
begin
  mcesta:=paramstr(0);
  mcesta:=fexpand(mcesta);
  i:=length(mcesta)-1;
  while mcesta[i]<>'\' do dec(i);
  mcesta[0]:=chr(i-1);
  chdir(mcesta);
end;

begin
  filemode:= 0;

  LukS;

  init;
  nactivystupnicestu;
{  vytvorvystupnicestu;}
  vykreslibar;
  for ktera:=1 to pocetdisket do begin
{    repeat}
      nactivstupnicestu(ktera);
{    until overdisketu(ktera);}
    kopirujdisketu(ktera);
  end;
  if kolikuz div 1000000<>delkakompr div 1000000 then begin
    standardnidialog('Varování:|Hra nemusí být korektně|nainstalována',
      dcolor[1],dcolor[2],dcolor[3],dcolor[4],dcolor[5],
      font,upozorneni);
  end;
  done;
end.

{konec s ptaním!
 potom spustit program setup na zvukovou kartu!}
