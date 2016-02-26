{$A+,B-,D+,E+,F-,G-,I+,L+,N-,O-,P-,Q-,R-,S+,T-,V+,X+,Y+}
{$M 32767,0,655360}

program konv;
uses crt,sblaster;
const maxseku=1000;
      freqsampl=22000;
type tseky=record
       pocet:integer;
       kde:array[1..maxseku]of longint;
     end;
     tcisla=array[1..maxseku]of integer;
var soub:string;
    s:tseky;
    c:tcisla;
    z:integer;
    freq,del,poz:longint;
    pozice:integer;

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
  fillchar(c,sizeof(c),0);
  assign(samplefile,{soub+'.wav'}'cd.sam');
  {$i-} reset(samplefile,1); {$i+}
  if ioresult<>0 then chyba;
  del:=filesize(samplefile);
end;

procedure piscas(cas:integer);
var a:longint;
begin
  a:=cas div freqsampl;
  write(a div 60,':',a mod 60,'.',trunc(frac(cas/freqsampl)*100));
end;

var akt,zac:integer;
procedure kreslimenu;
var i:integer;
    a:longint;
begin
  textattr:=7;
  clrscr;
  for i:=1 to 25 do
    if i+zac-1<=s.pocet then begin
      if i+zac-1<s.pocet then a:=s.kde[i+zac]-s.kde[i+zac-1]
                         else a:=del-s.kde[i+zac-1];
      if i+zac-1=akt then textattr:=112 else textattr:=7;
      write(c[i+zac-1]:5,'        ');
      piscas(a);
      writeln;
    end;
  textattr:=7;
end;

procedure kontrola;
begin
  if akt>s.pocet then akt:=s.pocet;
  if akt<1 then akt:=1;
  if zac>akt then zac:=akt;
  if akt>zac+24 then zac:=akt-24;
  if zac<1 then zac:=1;
  kreslimenu;
end;

procedure uloz;
const delbuf=16000;
var fi,fo:file;
    i,j:integer;
    ret:string;
    p,d:longint;
    cteno:word;
    buf:array[1..delbuf]of byte;
begin
  assign(fi,soub+'.wav'); {$i-} reset(fi,1); {$i+}
  if ioresult<>0 then chyba;
  for i:=1 to s.pocet do
    if c[i]<>0 then begin
      p:=s.kde[i];
      if i<s.pocet then d:=s.kde[i+1]-s.kde[i]
                   else d:=del-s.kde[i];
      str(i,ret);
      assign(fo,ret); rewrite(fo,1);
      for j:=0 to d div delbuf do begin
        if j=d div delbuf then
          blockread(fi,buf,d mod delbuf,cteno)
        else
          blockread(fi,buf,delbuf,cteno);
        blockwrite(fo,buf,cteno);
      end;
      close(fo);
    end;
  close(fi);
  close(samplefile);
end;

begin
  writeln;
  write('ktery soubor: '); readln(soub);
  clrscr;
  nacti;
  getmemdma(dmabuffer);
  autoinitdmairq;
  playdmafile(del,freqsampl,true);
  if s.pocet=0 then halt(0);
  akt:=1;
  zac:=1;
  kreslimenu;
  repeat
    writeln(getpositiondma);
    z:=integer(readkey);
    if (z=0)and(keypressed) then
      z:=256+integer(readkey);
    if z=32 then begin {hrej}
    end else
    if z=27 then break else
    if z=83+256 then begin {del, maz}
      {if c[akt]<>0 then }begin
        c[akt]:=0;
        for pozice:=akt+1 to s.pocet do
          if c[pozice]<>0 then
            dec(c[pozice]);
      end;
      kreslimenu;
    end else
    if z=82+256 then begin {ins, maz}
      pozice:=akt;
      while (pozice>=1)and(c[pozice]=0) do
        dec(pozice);
      if pozice=0 then pozice:=1 else pozice:=c[pozice]+1;
      c[akt]:=pozice;
      for pozice:=akt+1 to s.pocet do
        if c[pozice]<>0 then
          inc(c[pozice]);
      kreslimenu;
    end else
    if z=80+256 then begin
      inc(akt);
     kontrola;
    end else
    if z=72+256 then begin
      dec(akt);
      kontrola;
    end else
  until false;
  stopdma;
  donedmairq;
  freememdma(dmabuffer);
  uloz;
end.
