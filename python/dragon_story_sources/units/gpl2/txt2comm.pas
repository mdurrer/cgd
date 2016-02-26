{načtení a kompilace seznamu příkazů pro GPL2

 ze zdrojového textového souboru udělá setříděný spojový seznam}

unit txt2comm;
interface

const maxparametru=26;
      maxdelprik=30;
      maxpocetprikazu=30;
      maxpocetpodprikazu=5;

type tjmprik=string[maxdelprik];

     pprikaz=^tprikaz;
     tprikaz=record
       dalsi:pprikaz;
       cis,podcis,pocpar:byte;
       par:array[1..maxparametru,1..2]of byte;
         {1: hlavní třída
           1=číslo
           2=řetězec
           3=identifikátor
           4=mat.výraz
          2: podčíslo
            ad 2) 1=ukládaný řetězec
                  2=pomocná cesta
            ad 3) 0=návěští
                  1..X=třída ident.}
       jm:tjmprik;
     end;

function nactiprikazy(soubor:string; var kam,talk:pprikaz; maxident:byte):integer;
procedure dealokujprikazy(var ktere:pprikaz);

implementation
uses together;

function nactiprikazy(soubor:string; var kam,talk:pprikaz; maxident:byte):integer;
var i,j:byte;
    fi:text;
    ret,slov:string;
    cis,ch:integer;
    pom,pom1:pprikaz;
    pouzito:array[0..maxpocetprikazu]of record
      maxpod:byte;
      pod:array[1..maxpocetpodprikazu]of boolean;
    end;
    maxpouzito:byte;
begin
  getmem(kam,sizeof(tprikaz)-sizeof(tjmprik)+1);
  kam^.dalsi:=nil;
  kam^.cis:=0;
  kam^.podcis:=0;
  kam^.pocpar:=0;
  kam^.jm:='';
  talk:=nil;
  fillchar(pouzito,sizeof(pouzito),0);
  maxpouzito:=0;

  assign(fi,soubor);
  {$i-} reset(fi); {$i+}
  if ioresult<>0 then begin
    nactiprikazy:=10;
    exit;
  end;

  while not eof(fi) do begin
    readln(fi,ret);
    orizni(ret);
    if (ret='')or(ret[1]='{') then continue;
    {je to nový příkaz}

    slov:=slovo(ret);
    uppercase(slov);
    if length(slov)>maxdelprik then begin {kontrola správného tvaru}
      nactiprikazy:=11;
      close(fi);
      exit;
    end;
    for i:=1 to length(slov) do
      if not(slov[i]in znaky) then begin
        nactiprikazy:=12;
        close(fi);
        exit;
      end;

    {jméno příkazu}
    getmem(pom,sizeof(tprikaz)-sizeof(tjmprik)+length(slov)+1);
    pom^.jm:=slov;

    slov:=slovo(ret);
    uppercase(slov);
    if slov='TALK' then {případný TALK flag}
      if talk=nil then begin
        talk:=pom;
        slov:=slovo(ret);
      end else begin {2 příkazy z flagem TALK}
        nactiprikazy:=13;
        close(fi);
        exit;
      end;

    if slov='' then begin {očekává se číslo}
      nactiprikazy:=14;
      close(fi);
      exit;
    end;
    val(slov,cis,ch);
    if (ch<>0)or(cis<0)or(cis>maxpocetprikazu) then begin
      nactiprikazy:=15;
      close(fi);
      exit;
    end;
    pom^.cis:=cis;

    slov:=slovo(ret);
    if slov='' then begin {očekává se posčíslo}
      nactiprikazy:=16;
      close(fi);
      exit;
    end;
    val(slov,cis,ch);
    if (ch<>0)or(cis<1)or(cis>maxpocetpodprikazu) then begin
      nactiprikazy:=17;
      close(fi);
      exit;
    end;
    pom^.podcis:=cis;

    pom^.pocpar:=0; {počet parametrů je zatím 0}
    while ret<>'' do begin
      inc(pom^.pocpar);
      if pom^.pocpar>maxparametru then begin
        nactiprikazy:=18;
        close(fi);
        exit;
      end;
      slov:=slovo(ret);
      if (length(slov)>1)and(slov[2]='-') then begin {identifikátor, řetězec}
        if not ((byte(slov[1])-byte('0')) in [2,3]) then begin {špatná předpona}
          nactiprikazy:=19;
          close(fi);
          exit;
        end;
        val(copy(slov,3,255),cis,ch);
        if (ch<>0) or
           (slov[1]='2')and((cis<1)or(cis>2)) or
           (slov[1]='3')and((cis<0)or(cis>maxident)) then begin
          nactiprikazy:=20;
          close(fi);
          exit;
        end;
        pom^.par[pom^.pocpar,1]:=byte(slov[1])-byte('0');
        pom^.par[pom^.pocpar,2]:=cis;
      end else begin {číslo, mat. výraz}
        val(slov,cis,ch);
        if (ch<>0)or((cis<>1)and(cis<>4)) then begin
          nactiprikazy:=21;
          close(fi);
          exit;
        end;
        pom^.par[pom^.pocpar,1]:=cis;
        pom^.par[pom^.pocpar,2]:=0;
      end;
    end;

    {je-li to TALK, zkontrolujeme ještě parametry}
    if talk=pom then begin
      j:=0;
      if pom^.pocpar<>2 then {špatný počet parametrů}
        j:=1
      else
        if (pom^.par[1,1]<>3)or(pom^.par[2,1]<>2)or
           (pom^.par[2,2]<>1) then {špatný typ parametrů}
          j:=1; {zde bere libovolný identifikátor, ale pak kompilátor
                 zkontroluje, zda daný identifikátor opravdu odpovídá
                 tomu zde uvedenému; řetězec musí být ukládaný}
      if j<>0 then begin
        nactiprikazy:=22;
        close(fi);
        exit;
      end;
    end;

    {nyní víme přesně, co to je za příkaz}
    {vyhledá se, kam se má zatřídit}
    pom1:=kam;
    while (pom1^.dalsi<>nil)and(pom1^.dalsi^.jm<pom^.jm) do
      pom1:=pom1^.dalsi;

    {vloží se do seznamu}
    pom^.dalsi:=pom1^.dalsi;
    pom1^.dalsi:=pom;
    pouzito[pom^.cis].pod[pom^.podcis]:=true;
    if pom^.cis>maxpouzito then
      maxpouzito:=pom^.cis;
    if pom^.podcis>pouzito[pom^.cis].maxpod then
      pouzito[pom^.cis].maxpod:=pom^.podcis;

    pom1:=pom^.dalsi;
    {nyní vyhledáme duplicity}
    while (pom1<>nil)and(pom1^.dalsi<>nil)and(pom1^.dalsi^.jm=pom^.jm) do begin
      pom1:=pom1^.dalsi;
      if pom1^.pocpar=pom^.pocpar then begin
        i:=1;
        while (i<=pom1^.pocpar)and(pom1^.par[i,1]=pom^.par[i,1]) do
          inc(i);
          {sice v kompilátoru nejsou zaměnitelné identifikátory s návěštími,
           ale pro absolutní jednoznačnost bez znalosti prostředí pouze
           podle typu parametru se považují identifikátoru a návěští za
           shodné; tedy [..,2] se neporovnává}
        if i>pom1^.pocpar then begin {duplicita}
          nactiprikazy:=23;
          close(fi);
          exit;
        end;
      end;
    end;

    {nyní vyhledáme, zda existuje příkaz o stejným číslu, u něj
     zkontrolujeme parametry}
    pom1:=kam^.dalsi;
    while pom1<>nil do begin
      if (pom<>pom1)and(pom1^.cis=pom^.cis)and(pom1^.podcis=pom^.podcis) then begin
        j:=0;
        if pom1^.pocpar<>pom^.pocpar then
          j:=1
        else begin
          i:=1;
          while (i<=pom1^.pocpar)and(pom1^.par[i,1]=pom^.par[i,1])and
                (pom1^.par[i,2]=pom^.par[i,2]) do
            inc(i);
            {zde musí být absolutní shodnost všech parametrů}
          if i<=pom^.pocpar then
            j:=1;
        end;
        if j<>0 then begin {jiné parametry}
          nactiprikazy:=24;
          close(fi);
          exit;
        end;
      end;
      pom1:=pom1^.dalsi;
    end;
    {jinak byl zařazen na své místo a to bez duplicit, takže je to O.K.}
  end;

  for i:=1 to maxpouzito do begin {kontrola, zda jsou (pod)příkazy 1..N}
    if pouzito[i].maxpod=0 then begin
      nactiprikazy:=25;
      close(fi);
      exit;
    end;
    for j:=1 to pouzito[i].maxpod do
      if not pouzito[i].pod[j] then begin
        nactiprikazy:=26;
        close(fi);
        exit;
      end;
  end;
  {příkaz EXIT není poviný, takže ani nekontroluji jeho přítomnost}

  if talk=nil then begin
    nactiprikazy:=27;
    close(fi);
    exit;
  end;

  close(fi);
  nactiprikazy:=0;
end;

procedure dealokujprikazy(var ktere:pprikaz);
var pom:pprikaz;
begin
  pom:=ktere;
  while pom<>nil do begin
    ktere:=pom^.dalsi;
    freemem(pom,sizeof(tprikaz)-sizeof(tjmprik)+length(pom^.jm)+1);
    pom:=ktere;
  end;
  ktere:=nil;
end;

end.
