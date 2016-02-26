program saman2cd2;

uses bardfw,dos;

const sfile = 'SAM_AN.DFW';

var f : file;
    pole : array[0..4000] of longint;
    p : pointer;

    i , ii ,iii : longint;


begin
  writeln('Kompiluji soubor ',sfile,' na CD2.SAM');
  getmem(p,65000);
  ii:=sizeof(pole);
  assign(f,'cd2.sam');
  rewrite(f,1);
  if ioresult<>0 then exit;
  iii:=GetArchiveOccupy(sfile);
  if ioresult<>0 then exit;
  for i:=1 to {GetArchiveOccupy(sfile)}3999 do begin
    pole[i]:=ii;
    {if iii<=i then }ii:=ii+creaditem(sfile,p,i);
    if ioresult<>0 then exit;
  end;
  pole[i+1]:=ii;
  pole[0]:=ii;
  blockwrite(f,pole,sizeof(pole));
  for i:=1 to GetArchiveOccupy(sfile) do begin
    ii:=creaditem(sfile,p,i);
    blockwrite(f,p^,ii);
    if ioresult<>0 then exit;
  end;
  close(f);
  freemem(p,65000);
end.
