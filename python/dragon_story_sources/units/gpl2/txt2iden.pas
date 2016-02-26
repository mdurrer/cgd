{načtení a kompilace seznamu identifikátorů pro GPL2

 ze zdrojového textového souboru udělá setříděný spojový seznam}

unit txt2iden;
interface

const maxpocettrid=20;
      maxdelident=30;

type tjmident=string[maxdelident];

     pident=^tident;
     tident=record
       dalsi:pident;
       trida:byte;
       hodn:integer;
       txt:tjmident;
     end;

function nactiidentifikatory(soubor:string; var kam:pident; var maxpouzito:byte):integer;
procedure dealokujidentifikatory(var ktere:pident);

implementation
uses together;

function nactiidentifikatory(soubor:string; var kam:pident; var maxpouzito:byte):integer;
var i,akttrida:byte;
    fi:text;
    ret,slov:string;
    ch:integer;
    cis:longint;
    pom,pom1:pident;
    pouzito:array[1..maxpocettrid]of word;
begin
  getmem(kam,sizeof(tident)-sizeof(tjmident)+1);
  kam^.dalsi:=nil;
  kam^.trida:=0;
  kam^.txt:='';

  assign(fi,soubor);
  {$i-} reset(fi); {$i+}
  if ioresult<>0 then begin
    nactiidentifikatory:=1;
    exit;
  end;
  akttrida:=0;
  maxpouzito:=0;
  fillchar(pouzito,sizeof(pouzito),0);

  while not eof(fi) do begin
    readln(fi,ret);
    orizni(ret);
    uppercase(ret);
    if (ret='')or(ret[1]='{') then continue;
    slov:=slovo(ret);

    if slov='CLASS' then begin {nová třída}
      val(ret,cis,ch);
      if (ch<>0)or(cis<1)or(cis>maxpocettrid) then begin
        nactiidentifikatory:=2;
        close(fi);
        exit;
      end;
      akttrida:=cis;
      if akttrida>maxpouzito then
        maxpouzito:=akttrida;
      pouzito[akttrida]:=1;             {definovana trida}
      continue;
    end;

    {jinak je to nový identifikátor}
    if akttrida=0 then begin {kontrola, zda byla definována třída}
      nactiidentifikatory:=3;
      close(fi);
      exit;
    end;

    pom1:=kam; {kontrola duplicit}
    while pom1<>nil do begin
      if pom1^.txt=slov then begin
{PP: to jsem semka dopsal ja a zase zaremoval}
        writeln; writeln(pom1^.txt);
        nactiidentifikatory:=4;
        close(fi);
        exit;
      end;
      pom1:=pom1^.dalsi;
    end;

    if length(slov)>maxdelident then begin {kontrola správného tvaru}
      nactiidentifikatory:=5;
      close(fi);
      exit;
    end;
    for i:=1 to length(slov) do
      if not(slov[i]in znaky) then begin
        nactiidentifikatory:=6;
        close(fi);
        exit;
      end;

    {vyhledá se, kam se má zatřídit}
    pom1:=kam;
    while (pom1^.dalsi<>nil)and(pom1^.dalsi^.txt<slov) do
      pom1:=pom1^.dalsi;

    {vloží se do seznamu}
    getmem(pom,sizeof(tident)-sizeof(tjmident)+length(slov)+1);
    inc(pouzito[akttrida]);
    pom^.dalsi:=pom1^.dalsi;
    pom^.txt:=slov;
    pom^.trida:=akttrida;
    {pom^.hodn:=pouzito[akttrida] to dávalo poř. číslo};
    pom1^.dalsi:=pom;

    {nyní ještě vyplníme pom^.hodn}
    if ret='' then begin {je potřeba ještě číslo}
      nactiidentifikatory:=7;
      close(fi);
      exit;
    end;
    val(ret,cis,ch);
    if (ch<>0)or(cis<-maxint)or(cis>maxint) then begin
    {na cis nejsou kladeny žádné další požadavky}
      nactiidentifikatory:=8;
      close(fi);
      exit;
    end else
      pom^.hodn:=cis;
  end;

  for i:=1 to maxpouzito do
    if pouzito[i]=0 then begin {1=definovana CLASS, ale zadny identifikator}
      nactiidentifikatory:=9;
      close(fi);
      exit;
    end;

  close(fi);
  nactiidentifikatory:=0;
end;

procedure dealokujidentifikatory(var ktere:pident);
var pom:pident;
begin
  pom:=ktere;
  while pom<>nil do begin
    ktere:=pom^.dalsi;
    freemem(pom,sizeof(tident)-sizeof(tjmident)+length(pom^.txt)+1);
    pom:=ktere;
  end;
  ktere:=nil;
end;

end.
