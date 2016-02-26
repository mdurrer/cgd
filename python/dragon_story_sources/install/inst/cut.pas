program cutter;
const vstup='dh.dwc';
      vystup='dh.';
      delbuf=64000;
      cutdelka:array[1..4]of longint=
        (1200000,1440000,1440000,10000000);

procedure chyba(t:string);
begin
  writeln(t);
  halt(1);
end;

var fi,fo:file;
    cteno,psano:word;
    poc:byte;
    temp:pointer;
    aktdel,celkdel:longint;
    ret:string;
begin
  assign(fi,vstup); reset(fi,1);
  celkdel:=filesize(fi);
  poc:=0;
  getmem(temp,delbuf);
  repeat
    inc(poc);
    str(poc,ret);
    assign(fo,vystup+ret); rewrite(fo,1);
    aktdel:=0;
    repeat
      if aktdel+delbuf<=cutdelka[poc] then
        blockread(fi,temp^,delbuf,cteno)
      else
        blockread(fi,temp^,cutdelka[poc]-aktdel,cteno);
      blockwrite(fo,temp^,cteno,psano);
      if cteno<>psano then chyba('pri zapisu');
      inc(aktdel,cteno);
    until (aktdel>=cutdelka[poc])or(cteno<delbuf);
    close(fo);
  until eof(fi);
  close(fi);
  freemem(temp,delbuf);
end.
