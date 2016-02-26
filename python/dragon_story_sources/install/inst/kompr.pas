program kompresezdrojaku;
uses dos,barchiv;
const archiv='dh.';
      index='dhidx.bar';
      zdroj='c:\dh\';
      delbuf=64000;

procedure chyba(t:string);
begin
  writeln(t);
  halt(1);
end;

var fidx:text;
    fi:file;
    fo:word;
    s:searchrec;
    poccislo,cislo:integer;
    temp:pointer;
    cteno:word;
    celkdel,aktdel:longint;

begin
  typkomprese:=3;
  fo:=barotevri(archiv+'bar',3);
  if fo=65535 then chyba('nelze zalozit archiv');
  assign(fidx,index); rewrite(fidx);
  findfirst(zdroj+'*.*',anyfile,s);
  cislo:=0;
  getmem(temp,delbuf);
  while doserror=0 do begin
{s.name:='obr_an.dfw';}
    if (s.name<>'.')and(s.name<>'..') then begin
      write(fidx,s.name);
      assign(fi,zdroj+s.name); reset(fi,1);
      celkdel:=filesize(fi);
      aktdel:=0;
      while not eof(fi) do begin
        write(#13,s.name,': ',(aktdel/celkdel)*100:6:2);
        inc(cislo);
        blockread(fi,temp^,delbuf,cteno);
        if barzapis(fo,temp,cteno)<>cislo then chyba('spatny zapis');
        inc(aktdel,cteno);
      end;
      close(fi);
      writeln(fidx,' ',cislo);
      writeln(#13,s.name,': ',(aktdel/celkdel)*100:6:2);
    end;
{exit;}
    findnext(s);
  end;
  freemem(temp,delbuf);
  close(fidx);
  barzavri(fo);
end.
