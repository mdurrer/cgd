{gpl2 kompilátor, hlavní modul}

unit gpl2;





interface
uses txt2iden,txt2comm;

const maxdelkakodu=10000;
      maxretezcu=1000;

type pkod=^tkod;
     tkod=record
       {alok,}delka:integer;
       k:array[1..maxdelkakodu]of integer;
     end;

     pstring=^string;

     pseznamretezcu=^tseznamretezcu;
     tseznamretezcu=record
       {alok,}pocet:integer;
       r:array[1..maxretezcu]of pstring;
     end;

     pseznampomretezcu=^tseznampomretezcu;
     tseznampomretezcu=record
       {alok,}pocet:integer;
       r:array[1..maxretezcu]of record
         r:pstring;
         vyskyt:integer; {index, kde se to ve zdrojovém textu vyskytlo}
         cis,podcis,par:byte; {číslo, podčíslo a parametr daného příkazu}
       end;
     end;

function gpl2kompiluj(var fi:text;
                      var vyslkod:pkod;
                      var seznret:pseznamretezcu;
                      pricistret:integer;
                      var seznpomret:pseznampomretezcu;
                      ident:pident; maxident:byte;
                      prik,talk:pprikaz):integer;
{předpokládá otevřený textový soubor, ze kterého bude číst, dokud
 nenarazí na konec souboru nebo řádek začínající `endgpl' nebo `gplend'
 pricistret: zásobník řetězců se může třeba průběžně vybírat, takže i
             když se předá prázdný, bylo by vhodné nenarušit číslování}

function nactiident_prik(var ident:pident; var maxident:byte;
                         var prik,talk:pprikaz):integer;
procedure dealokujident_prik(var ident:pident; var prik:pprikaz);





implementation
uses together,mat2bin;

const maxnavesti=20;
      maxdelnavesti=maxdelident;

type tjmnavesti=string[maxdelnavesti];

     tnavesti=record
       cislo:integer; {poř. číslo příkazu, nebo 0=zatím nedefinováno}
       jm:tjmnavesti;
     end;

     tseznamnavesti=record
       pocet:byte;
       n:array[1..maxnavesti]of tnavesti;
     end;

     tseznamskutecnychparametru=record
       pocet:byte;
       p:array[1..maxparametru]of record
         typ, {1234}
         podtyp:byte; {u řetězce a identifikátoru; viz. txt2iden}
         hodn:integer; {přímo číslo, nebo hodnota identifikátoru nebo
                        index do tabulky řetězců a mat. výrazů}
       end;
     end;

     tseznammatvyrazu=record
       pocet:integer;
       m:array[1..2]of tpostfix;
       d:array[1..2]of integer;
     end;

     tseznampouzitychnavesti=record
       pocet:integer;
       n:array[1..100]of record
         kod:integer; {kde je umístěn odkaz}
         odkud,kam:integer; {z kterého příkazu na který (kvůli rel. skoku)}
       end;
     end;

     tseznamprogrradku=record
       pocet:integer;
       r:array[1..100]of integer; {kde začíná daný bin. řádek}
     end;

function gpl2kompiluj(var fi:text;
                      var vyslkod:pkod;
                      var seznret:pseznamretezcu;
                      pricistret:integer;
                      var seznpomret:pseznampomretezcu;
                      ident:pident; maxident:byte;
                      prik,talk:pprikaz):integer;
var nav:tseznamnavesti; {seznam všech návěští}
    par:tseznamskutecnychparametru; {seznam skutečně naspaných parametrů}
    mat:tseznammatvyrazu; {seznam mat. výrazů v parametrech}
    zpracret:pseznamretezcu; {seznam použitých řetězců v parametrech
                              (řetězce, identifikátory, návěští)}
    skok:tseznampouzitychnavesti;
    radky:tseznamprogrradku;

    ktery:pprikaz;
    ret:string;
    x:integer;
    chyba:integer;

function chcekonec(ret:string):boolean;
var ret1:string;
begin
  ret1:=slovo(ret);
  uppercase(ret1);
  chcekonec:=(ret1='ENDGPL')or(ret1='GPLEND');
end;

function syntslovo(var ret:string; var pokracovani:boolean):string;
var i,j:byte;
begin
  pokracovani:=false;
  if ret='' then begin
    syntslovo:='';
    exit;
  end;
  i:=1;
  syntslovo:='';
  if ret[1] in (cisla+['-']) then begin {číslo}
    if ret[1]='-' then
      i:=2;
    while (i<=length(ret))and(ret[i]in cisla) do
      inc(i);
  end else if ret[1] in znaky then {identifikátor, vč. návěští}
    while (i<=length(ret))and(ret[i]in znaky) do
      inc(i)
  else if ret[1]='(' then begin {matematický výraz}
    j:=1;
    i:=2;
    while (i<=length(ret))and(j<>0) do begin
      if ret[i]='(' then inc(j) else
      if ret[i]=')' then dec(j);
      inc(i);
    end;
    if j<>0 then begin {neukončený matematický výraz}
      chyba:=29;
      exit;
    end;
  end else if ret[1]='"' then begin {řetězec}
    i:=2;
    while (i<=length(ret))and(ret[i]<>'"') do
      inc(i);
    inc(i); {až za "}
  end else if ret[1]='\' then begin {pokračovací znak}
    for i:=2 to length(ret) do {za tím musí být už pouze meezery}
      if ret[i]<>' ' then begin
        chyba:=30;
        exit;
      end;
    pokracovani:=true;
    exit;
  end else if ret[1]=':' then begin {: za jménem příkazu znamená TALK}
    i:=2;
  end else begin {jinak je to neznámý syntaktický objekt ---> chyba}
    chyba:=31;
    exit;
  end;

  syntslovo:=copy(ret,1,i-1); {překopírujeme nalezený objekt}
  delete(ret,1,i-1); {a vymažeme ho ze zdroje}
  oriznileve(ret); {opět uřízneme levé mezery}
end;

procedure prozkoumejparametry(ret:string; var par:tseznamskutecnychparametru);
var slov,ulozret{přidávaný řetězec}:string;
    retezec:integer; {0=žádný řetězec, jinak číslo do skladu}
    x:byte;
    ch:integer;
    cis:longint;
    pokracovani:boolean;
begin
  par.pocet:=0;
  retezec:=0; {aktuálně je otevřen řetězec}
  {počáteční řetězec byl předán}
  repeat

    repeat
      if retezec<>0 then begin {je-li rozpracován řetězec, hledáme "}
        x:=pos('"',ret);
        if x=0 then begin
          slov:=ret;
          ret:='';
        end else begin
          slov:=copy(ret,1,x); {vč. posledního "}
          delete(ret,1,x+1);
        end
      end else begin {jinak načte další objekt podle syntaktických pravidel}
        slov:=syntslovo(ret,pokracovani);
        if chyba<>0 then
          exit;
      end;

      if slov='' then begin {konec řádky}
        if (retezec=0)and not pokracovani then
        {není otevřen řetězec a nepokračuje řádek přes \ ---> konec příkazu}
          exit
        else {je otevřen řetězec}
          if not eof(fi) then begin {není-li konec vstupního souboru}
            readln(fi,ret); {načteme další řádek}
            oriznileve(ret);
{příp. příkaz na konec je teď parametr ---> ignoruje se a komentáře uvnitř
 příkazů ještě nejsou dořešeny}
          end else begin {jinak ohlásíme chybu}
            chyba:=32;
            exit;
          end;
      end else
        break; {jinak jsme načetli to, co cheme; O.K., done}
    until false;

    if (retezec=0)and(slov[1]='"') then begin {začátek nového řetězce}
      inc(zpracret^.pocet);
      retezec:=zpracret^.pocet;
      inc(par.pocet);
      if par.pocet>maxparametru then begin
        chyba:=51;
        exit;
      end;
      par.p[par.pocet].typ:=2;
      par.p[par.pocet].podtyp:=255; {zatím nevíme, zda je podtyp 1 nebo 2}
      par.p[par.pocet].hodn:=retezec;
      ulozret:='';
      delete(slov,1,1);
    end; {bude pokračovat dalším IFem}

    if retezec<>0 then begin {pokračování řetězce}
      ulozret:=ulozret+slov;
      if slov[byte(slov[0])]='"' then begin
        dec(ulozret[0]);
        getmem(zpracret^.r[retezec],length(ulozret)+1);
        zpracret^.r[retezec]^:=ulozret;
        retezec:=0;
      end else
        ulozret:=ulozret+#13;
    end else begin {jinak je to nové syntaktické slovo (ident, cis, mat)}
      uppercase(slov);
      inc(par.pocet);
      if par.pocet>maxparametru then begin
        chyba:=51;
        exit;
      end;
      if slov[1]in cisla+['-'] then begin {je-li to číslo}
        par.p[par.pocet].typ:=1;
        par.p[par.pocet].podtyp:=255;
        val(slov,cis,ch);
        if (ch<>0)or(cis<-maxint)or(cis>maxint) then begin
          chyba:=33;
          exit;
        end;
        par.p[par.pocet].hodn:=cis;
      end else if slov[1]in znaky then begin
      {identifikátor, ještě nebudeme hledat; je-li to jméno příkazu,
       zajistíme později; teď to bude jenom identifikátor}
        inc(zpracret^.pocet);
        retezec:=zpracret^.pocet;
        par.p[par.pocet].typ:=3;
        par.p[par.pocet].podtyp:=255;
        par.p[par.pocet].hodn:=retezec;
        getmem(zpracret^.r[retezec],length(slov)+1);
        zpracret^.r[retezec]^:=slov;
        retezec:=0;
        {uložíme ho do seznamu řetězců a zaznamenáme si, že to byl nějaký
         identifikátor}
      end else if slov[1]='(' then begin {matematický výraz}
        par.p[par.pocet].typ:=4;
        par.p[par.pocet].podtyp:=255;
        inc(mat.pocet);
        par.p[par.pocet].hodn:=mat.pocet;
        chyba:=mat2postfix(slov,ident,mat.m[mat.pocet],mat.d[mat.pocet]);
        if chyba<>0 then
          exit;
          {zkompiluje mat. výraz a nastane-li chyba, ohlásí to, jinak done}
      end else if slov[1]=':' then begin {: za jménem příkazu znamená TALK}
        if (par.pocet=2)and(par.p[1].typ=3) then begin
        {pokud je to ihned jako 2. parametr za identifikátorem,
         má to tento spec. význam; zatím ale nekontrolujeme žádné typy...}
          par.p[2]:=par.p[1]; {typ, podtyp, hodn}
          par.p[1].typ:=3; {zde dáme jméno příkazu TALK}
          par.p[1].podtyp:=255;
          inc(zpracret^.pocet);
          retezec:=zpracret^.pocet;
          par.p[1].hodn:=retezec;
          getmem(zpracret^.r[retezec],length(talk^.jm)+1);
          zpracret^.r[retezec]^:=talk^.jm;
          retezec:=0;
          {dále se pokračuje ve čtení dalších parametrů; chová se to, jako
           bychom napsali TALK <jméno> místo <jméno>:}
        end else begin {jinak je to chyba}
          chyba:=35;
          exit;
        end;
      end else begin {neznámý objekt, radši druhá kontrola}
        chyba:=36;
        exit;
      end;
    end;

  until false; {vyskočí se při nalezení konce řádku bez otevřeného řetězce}
end;

procedure vyjmijmenoprikazu(var jmeno:string; var par:tseznamskutecnychparametru);
var x:byte;
begin
  if par.p[1].typ<>3 then begin {1. parametr nebyl identifikátor příkazu}
    chyba:=37;
    exit;
  end else begin {byl ---> nastavíme toto jméno}
    jmeno:=zpracret^.r[par.p[1].hodn]^;
    dec(par.pocet); {vymažeme 1. parametr + posuneme ostatní parametry}
    for x:=1 to par.pocet do
      par.p[x]:=par.p[x+1];
  end;
end;

procedure osetriLABELS;
var x,y:byte;
    _ident:pident;
begin
  if radky.pocet<>1 then begin {příkaz je dovolen jen na počátku}
    chyba:=38;
    exit;
  end;
  for x:=1 to par.pocet do {zkontroluje všechny parametry}
    if par.p[x].typ<>3 then begin
      chyba:=39;
      exit;
    end else begin
      _ident:=ident^.dalsi;
      while (_ident<>nil)and(_ident^.txt<>zpracret^.r[ par.p[x].hodn ]^) do
        _ident:=_ident^.dalsi;
      if _ident<>nil then begin {existuje stejný identifikátor}
        writeln(_ident^.txt);
        chyba:=40;
        exit;
      end;
    end;
  nav.pocet:=par.pocet;
  for x:=1 to par.pocet do begin {deklaruje tedy všechna tato návěští}
    nav.n[x].cislo:=0;
    nav.n[x].jm:=zpracret^.r[ par.p[x].hodn ]^;
    for y:=1 to x-1 do
      if nav.n[x].jm=nav.n[y].jm then begin
        chyba:=41;
        exit;
      end;
  end;
  dec(radky.pocet); {toto nebyl příkaz, takže ho vymažeme}
end;

procedure osetriLABEL;
var x:byte;
begin
  if (par.pocet<>1)or(par.p[1].typ<>3) then begin {požaduje jediný parametr}
    chyba:=42;
    exit;
  end;
  x:=1;
  while (x<=nav.pocet)and(nav.n[x].jm<>zpracret^.r[ par.p[1].hodn ]^) do
    inc(x);
  if x>nav.pocet then begin {nenalezeno návěští}
    chyba:=43;
    exit;
  end;
  if nav.n[x].cislo<>0 then begin {už bylo definováno návěští}
    writeln(nav.n[x].jm);
    chyba:=44;
    exit;
  end;
  nav.n[x].cislo:=radky.pocet; {jinak zapíšeme číslo řádku}
  dec(radky.pocet);            {toto nebyl příkaz, takže ho vymažeme}
end;

function kteryprikaz(var jmeno:string; var par:tseznamskutecnychparametru):pprikaz;
var ktery:pprikaz;
    x:byte;
begin
  ktery:=prik^.dalsi;
  while ktery<>nil do begin
    if (ktery^.jm=jmeno)and(ktery^.pocpar=par.pocet) then begin
      x:=1;
      while (x<=par.pocet)and(par.p[x].typ=ktery^.par[x,1]) do
        inc(x);
      if x>par.pocet then begin {nalezen shodný příkaz}
        kteryprikaz:=ktery;
        exit;
      end;
    end;
    ktery:=ktery^.dalsi;
  end;
  kteryprikaz:=nil; {nenalezeno nic}
  chyba:=45;
end;

procedure pridejdokodu(_prik:pprikaz; var jmeno:string;
                       var par:tseznamskutecnychparametru);
var x,y:byte;
    _ident:pident;
begin
  inc(vyslkod^.delka); {zapíše se jméno příkazu}
  vyslkod^.k[vyslkod^.delka]:=_prik^.cis+_prik^.podcis shl 8;
  for x:=1 to par.pocet do
    if par.p[x].typ=1 then begin {číslo, pouze se přidá do kódu}
      inc(vyslkod^.delka);
      vyslkod^.k[vyslkod^.delka]:=par.p[x].hodn;
    end else if par.p[x].typ=2 then begin {řetězec, zařadí se do 1 ze seznamů}
      inc(vyslkod^.delka);
      if _prik^.par[x,2]=1 then begin {stálý řetězec, přidá se do seznamu}
        inc(seznret^.pocet);
        getmem(seznret^.r[seznret^.pocet],
          length(zpracret^.r[ par.p[x].hodn ]^)+1);
        seznret^.r[seznret^.pocet]^:=zpracret^.r[ par.p[x].hodn ]^;
        vyslkod^.k[vyslkod^.delka]:=seznret^.pocet+pricistret;
        {přičtení kvůli nenarušení číslování, viz. interface}
      end else begin {jinak pomocný řetězec, přidá se a zapíše odkaz sem}
        inc(seznpomret^.pocet);
        seznpomret^.r[seznpomret^.pocet].vyskyt:=vyslkod^.delka;
        seznpomret^.r[seznpomret^.pocet].cis:=_prik^.cis;
        seznpomret^.r[seznpomret^.pocet].podcis:=_prik^.podcis;
        seznpomret^.r[seznpomret^.pocet].par:=x;
        getmem(seznpomret^.r[seznpomret^.pocet].r,
          length(zpracret^.r[ par.p[x].hodn ]^)+1);
        seznpomret^.r[seznpomret^.pocet].r^:=zpracret^.r[ par.p[x].hodn ]^;
        vyslkod^.k[vyslkod^.delka]:=seznpomret^.pocet;
      end;
    end else if par.p[x].typ=3 then begin {identifikátor, kontrola (i návěští)}
      inc(vyslkod^.delka);
      _ident:=ident^.dalsi;
      while (_ident<>nil)and(_ident^.txt<>zpracret^.r[ par.p[x].hodn ]^) do
        _ident:=_ident^.dalsi;
      if _ident<>nil then begin {nalezen ---> identifikátor}
        if _ident^.trida<>_prik^.par[x,2] then begin {liší se typ ---> chyba}
          chyba:=46;
          exit;
        end;
        vyslkod^.k[vyslkod^.delka]:=_ident^.hodn;
        {jinak typ sedí ---> zapíšeme jeho hodnotu}
      end else begin
        y:=1;
        while (y<=nav.pocet)and(nav.n[y].jm<>zpracret^.r[ par.p[x].hodn ]^) do
          inc(y);
        if y>nav.pocet then begin {není ani návěští ---> neznámý identifikátor}
          chyba:=47;
          exit;
        end;
        if _prik^.par[x,2]<>0 then begin {příkaz nechce návěští ---> chyba}
          chyba:=48;
          exit;
        end;
        {jinak zapíšeme odkaz na nové návěští}
        vyslkod^.k[vyslkod^.delka]:=y; {číslo návěští}
        inc(skok.pocet);
        skok.n[skok.pocet].kod:=vyslkod^.delka;
        skok.n[skok.pocet].kam:=y; {zde je zatím jen číslo návěští}
        skok.n[skok.pocet].odkud:=radky.pocet;
      end;
    end else if par.p[x].typ=4 then begin {matematický výraz}
      inc(vyslkod^.delka);
      move(mat.m[par.p[x].hodn],vyslkod^.k[vyslkod^.delka],
        mat.d[par.p[x].hodn]*2*sizeof(integer)-2);
      inc(vyslkod^.delka,mat.d[par.p[x].hodn]*sizeof(integer)-1-1);
      {překopíruje matematický výraz do kódu
       poslední 2 bajty (dvě nuly jsou zbytečné a nesmí tam v play3.asm být)}
    end else begin {jinak je to nesmyslný typ parametru ---> chyba}
      chyba:=49;
      exit;
    end;

end;

begin
  nav.pocet:=0;
  skok.pocet:=0;
  radky.pocet:=0;
  getmem(zpracret,sizeof(integer)+maxparametru*sizeof(pstring));
{  zpracret^.alok:=maxparametru;}
  chyba:=0;

  while not eof(fi) do begin
    readln(fi,ret);
    oriznileve(ret);
    if (ret='')or(ret[1]='{') then continue;
    if chcekonec(ret) then break;
    {jinak je to legální příkaz}
    inc(radky.pocet);
    radky.r[radky.pocet]:=vyslkod^.delka+1; {kde začíná daný řádek}
    mat.pocet:=0;
    par.pocet:=0;
    zpracret^.pocet:=0;
    prozkoumejparametry(ret,par);
    if chyba<>0 then begin
      gpl2kompiluj:=chyba;
      exit;
    end;
    vyjmijmenoprikazu(ret,par);
    if chyba<>0 then begin
      gpl2kompiluj:=chyba;
      exit;
    end;
    {nyní je v ret jméno příkazu a v par seznam parametrů, u každého je
     uveden pouze přibližný typ (1234), nic víc!
     případný příkaz TALK ve dvojtečkové notaci už byl ošetřen}
    if ret='LABELS' then {deklaruje všechny návěští, lze pouze na začátku}
      osetriLABELS
    else if ret='LABEL' then {definuje další návěští}
      osetriLABEL
    else begin
      ktery:=kteryprikaz(ret,par);
      if chyba<>0 then begin
        gpl2kompiluj:=chyba;
        exit;
      end;
      pridejdokodu(ktery,ret,par); {přidá to do kódu a průběžně zkontroluje parametry}
      if chyba<>0 then begin
        gpl2kompiluj:=chyba;
        exit;
      end;
    end;
    if chyba<>0 then begin
      gpl2kompiluj:=chyba;
      exit;
    end;
    {par není třeba čistit}
    for x:=1 to zpracret^.pocet do {vyčistíme zpracret}
      freemem(zpracret^.r[x], length(zpracret^.r[x]^)+1);
  end;

  inc(radky.pocet); {zapíšeme konec posledního příkazu}
  inc(vyslkod^.delka); {a příkaz EXIT}
  vyslkod^.k[vyslkod^.delka]:=0;
  radky.r[radky.pocet]:=vyslkod^.delka;

  for x:=1 to nav.pocet do
    if nav.n[x].cislo=0 then begin {nedefinované návěští?}
      gpl2kompiluj:=50;
      exit;
    end;
  for x:=1 to skok.pocet do {přepíšeme návěští na skutečné rel. skoky}
    vyslkod^.k[ skok.n[x].kod ]:=
      (radky.r[nav.n[skok.n[x].kam].cislo]-radky.r[skok.n[x].odkud+1])*2;
      {protože kód je tvořen integery}

  freemem(zpracret,sizeof(integer)+maxparametru*sizeof(pstring));

  gpl2kompiluj:=0;
end;

function nactiident_prik(var ident:pident; var maxident:byte;
                         var prik,talk:pprikaz):integer;
var x:integer;
begin
  x:=nactiidentifikatory(jmsoubident,ident,maxident);
  if x<>0 then begin
    nactiident_prik:=x;
    exit;
  end;
  x:=nactiprikazy(jmsoubprik,prik,talk, maxident);
  if x<>0 then begin
    nactiident_prik:=x;
    exit;
  end;
  nactiident_prik:=0; {jinak všechno proběhlo bez chyby}
end;

procedure dealokujident_prik(var ident:pident; var prik:pprikaz);
begin
  dealokujprikazy(prik);
  prik:=nil;
  dealokujidentifikatory(ident);
  ident:=nil;
end;

end.

{todo: možná vynutit = v příkazu LET, teď to chodí neznámý syntaktický objekt!
       lepší rozpůlení řádku (i uprostřed mat. výrazu)
       zavést komentáře i uprostřed řádku (až do konce řádku)
       while(length(ret)) uložit si length!
       bacha na přetečení, že něčeho bylo předáno moc a my to furt ukládáme
       ignorovat levé a pravé mezery nejenom u parametrů, ale i uvnitř
       řetězce!
       ať chybové hlášky hlásí přesný popis jako v k3}
