{$A+,B-,D+,E+,F-,G+,I+,L+,N-,O-,P-,Q-,R-,S+,T-,V+,X+,Y+}
{$M 16384,0,655360}

program sekatko;
uses crt,sblaster;
const maxseku=1000;
      freqsampl=22000;
type tseky=record
       pocet:integer;
       kde:array[1..maxseku]of longint;
     end;
var soub:string;
    s:tseky;
    z:integer;
    freq,del,poz:longint;
    pozice:integer;
    hraje:boolean;

procedure chyba;
begin
  write(#7);
  halt(1);
end;

procedure nacti;
var fi:file;
begin
  assign(fi,soub+'.sek'); {$i-} reset(fi,1); {$i+}
  if ioresult<>0 then
    s.pocet:=0
  else begin
    blockread(fi,s,sizeof(s));
    close(fi);
  end;
  assign(samplefile,{soub+'.wav'}'cd.sam');
  {$i-} reset(samplefile,1); {$i+}
  if ioresult<>0 then chyba;
  del:=filesize(samplefile);
end;

procedure zapis;
var fo:file;
begin
  assign(fo,soub+'.sek'); {$i-} rewrite(fo,1); {$i+}
  if ioresult<>0 then
    chyba
  else begin
    blockwrite(fo,s,sizeof(s));
    close(fo);
  end;
  close(samplefile);
end;

procedure hledej;
var x,y,a,b,i:integer;
begin
  x:=1; y:=s.pocet;
  while x<y do begin
    a:=(x+y)div 2;
    if poz=s.kde[a] then begin
      x:=a; y:=a;
    end else if poz<s.kde[a] then
      y:=a-1
    else
      x:=a+1;
  end;
  while (x<s.pocet)and(s.kde[x+1]=s.kde[x]) do
    inc(x);
  if poz>s.kde[x] then inc(x);
  pozice:=x;
end;

procedure piscas(cas:longint);
var a:longint;
begin
  a:=cas div freqsampl;
  write(a div 60,':',a mod 60,'.',trunc(frac(cas/freqsampl)*100));
end;

procedure piszarazky;
var x,y,a,b,i:integer;
begin
  if s.pocet=0 then begin
    window(1,1,39,25); clrscr;
    window(1,1,80,25);
    exit;
  end;
  x:=pozice;
  hledej;
  if x=pozice then exit;
  x:=pozice;
  if x-1>10 then a:=10 else a:=x-1;
  if s.pocet-x>10 then b:=10 else b:=s.pocet-x;
  window(1,1,59,25); clrscr;
  for i:=x-a to x+b do begin
    gotoxy(1,12-x+i);
    if -x+i=0 then textattr:=15 else textattr:=7;
    write(s.kde[i]); clreol;
  end;
  window(1,1,80,25);
end;

procedure obrazovka;
begin
  textattr:=7;
  gotoxy(40,1); write('bajty: ',poz,'/',del); clreol;
  gotoxy(40,2); write('cas:   ');
  piscas(poz); write('/'); piscas(del); clreol;
  gotoxy(40,3); write('%:     ',round(poz/del*100),'%'); clreol;
  gotoxy(40,4); write('freq:  ',freq); clreol;
  piszarazky;
end;

procedure inssek;
var x,i:integer;
begin
  x:=pozice;
  for i:=s.pocet downto x do
    s.kde[i+1]:=s.kde[i];
  inc(s.pocet);
  s.kde[x]:=poz;
  pozice:=-1;
  piszarazky;
end;

procedure delsek;
var x,i:integer;
begin
  if s.pocet=0 then exit;
  x:=pozice;
  dec(s.pocet);
  for i:=x to s.pocet do
    s.kde[i]:=s.kde[i+1];
  pozice:=-1;
  piszarazky;
end;

begin
  writeln;
  write('ktery soubor: '); readln(soub);
  clrscr;
  nacti;
  del:=filesize(samplefile);
  poz:=0;
  pozice:=0;
  {nastavit del, hudbu} freq:=freqsampl;
  getmemdma(dmabuffer);
  autoinitdmairq;
  playdmafile(del,freq,true);
  pausedma;
  hraje:=false;
  obrazovka;
  repeat
    repeat
      poz:=getpositiondma;
      obrazovka;
    until keypressed;
    z:=integer(readkey);
    if (z=0)and(keypressed) then
      z:=256+integer(readkey);
    if z=27 then break else
    if z=82+256{ins} then inssek else
    if z=83+256{del} then delsek else
    if z=byte('+') then begin
      inc(freq,1000);
      if freq>40000 then freq:=40000;
      obrazovka;
    end else
    if z=byte('-') then begin
      dec(freq,1000);
      if freq<1000 then freq:=1000;
      obrazovka;
    end else
    if z=72+256 then begin
      dec(poz,freq);
      if poz<0 then poz:=0;
      obrazovka;
      stopdma;
      seek(samplefile,poz);
      playdmafile(del-poz,freq,true);
    end else
    if z=80+256 then begin
      inc(poz,freq);
      if poz>del then poz:=del;
      obrazovka;
      stopdma;
      seek(samplefile,poz);
      playdmafile(del-poz,freq,true);
    end else
    if z=73+256 then begin {pageup}
      if pozice>1 then begin
        poz:=s.kde[pozice-1];
        obrazovka;
      end;
      stopdma;
      seek(samplefile,poz);
      playdmafile(del-poz,freq,true);
    end else
    if z=81+256 then begin {pagedown}
      if pozice<=s.pocet then begin
        poz:=s.kde[pozice];
        obrazovka;
      end;
      stopdma;
      seek(samplefile,poz);
      playdmafile(del-poz,freq,true);
    end else
    if z=32 then begin {mezera dela start/stop hudby}
      if hraje then
        pausedma
      else
        continuedma;
      hraje:=not hraje;
    end else
  until false;
  stopdma;
  donedmairq;
  freememdma(dmabuffer);
  zapis;
  clrscr;
  writeln;
  writeln('sekatko verze -\infty, naprosty zakaz pouzivani krome mne! Bob');
end.
