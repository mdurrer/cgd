{konvertor dfw fajlů do ems formátu}

unit k3ems;
interface

procedure konverzeemsdfwfajlu(cesta:string);
procedure konverzecd2sam(input_file, output_file:string);

implementation
uses k3togeth,
     bardfw;

procedure konverzeemsdfwfajlu(cesta:string);
type plongintarray=^tlongintarray;
     tlongintarray=array[1..1000]of longint;
     pbuffer=^tbuffer;
     tbuffer=array[1..65000]of byte;
var pocet:integer;
    i,j:word;
    indexy:plongintarray;
    buf:pbuffer; delkabuf:word;
    pom:pbuffer; zacatek,delka:word;
begin
  cesta:=fsplit2(cesta,3); {vezmeme všechno kromě přípony, která je DFW}

  pocet:=getarchiveoccupy(cesta+'.dfw'); {načtení délek všech složek}
  getmem(indexy,(pocet+1)*sizeof(longint));
  indexy^[1]:=0;
  for i:=1 to pocet do
    indexy^[i+1]:=indexy^[i]+unpackeditemsize(cesta+'.dfw',i);

  smazsoubor(cesta+'.ems');
  caddfrommemory(cesta+'.ems',indexy,(pocet+1)*sizeof(longint));
    {vytvoření nového archívu}
  delkabuf:=0;
  getmem(buf,deleniretezcunabloky);

  for i:=1 to pocet do begin {pro všechny složky}
    zacatek:=1;
    delka:=cloaditem(cesta+'.dfw',pointer(pom),i);
    while longint(delka-zacatek+1)+delkabuf>deleniretezcunabloky do begin
    {vyswapovat a připsat složku}
      for j:=delkabuf+1 to deleniretezcunabloky do
        buf^[j]:=pom^[j-delkabuf+zacatek-1];
      inc(zacatek,deleniretezcunabloky-delkabuf);
      delkabuf:=0;
      caddfrommemory(cesta+'.ems',buf,deleniretezcunabloky);
    end;
    {připsat zbytek do bufferu}
    for j:=zacatek to delka do
      buf^[delkabuf+j-zacatek+1]:=pom^[j];
    inc(delkabuf,delka-zacatek+1);
    {dealokovat načtenou subsložku}
    freemem(pom,delka);
  end;
  if delkabuf<>0 then {zapsat příp. zbytek}
    caddfrommemory(cesta+'.ems',buf,delkabuf);

{  smazsoubor(cesta+'.dfw');
  prejmenujsoubor(cesta+'.ems',cesta+'.dfw');}
{necha puvodni soubor a stejne tak da i novy do pripony ems}

  freemem(buf,deleniretezcunabloky);
  freemem(indexy,(pocet+1)*sizeof(longint));

  writeln('file ' + cesta + ' converted to the EMS format');
end;

procedure konverzecd2sam(input_file, output_file:string);
var f : file;
    pole : array[0..4000] of longint;
    p : pointer;
    i, ii{, iii} : longint;
begin
  writeln('Converting file ', input_file, ' into ', output_file);
  getmem(p,65000);
  ii:=sizeof(pole);
  assign(f,output_file);
  rewrite(f,1);
  if ioresult<>0 then exit;
  {iii:=GetArchiveOccupy(input_file);}
  if ioresult<>0 then exit;
  for i:=1 to {GetArchiveOccupy(input_file)}3999 do begin
    pole[i]:=ii;
    {if iii<=i then }ii:=ii+creaditem(input_file,p,i);
    if ioresult<>0 then exit;
  end;
  pole[i+1]:=ii;
  pole[0]:=ii;
  blockwrite(f,pole,sizeof(pole));
  for i:=1 to GetArchiveOccupy(input_file) do begin
    ii:=creaditem(input_file,p,i);
    blockwrite(f,p^,ii);
    if ioresult<>0 then exit;
  end;
  close(f);
  freemem(p,65000);
end;

end.
