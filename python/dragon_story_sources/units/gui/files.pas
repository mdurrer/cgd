{oproti standardni knihovne je to ochuzeno o vypisy datumu a casu (kvuli
 uspore mista) a o 2 dolni tlacitka (taky kvuli tomu a krome toho jsou tam
 vubec na hovno)

 pri nastavovani adresare: pokud se zada mechanika A: a neni tam disketa,
 zobrazi se seznam mechanik i polozka Nastavit.!!!, coz je v poradku
 pokud se ale skoci na nesmyslnou cestu (treba :\\:), tak take vypise
 seznam mechanik, ale Nastavit.!!! je tam taky, coz by nemelo, ale zatim
 nevim, jak zjistit smysluplnost cesty
 u nastavovani jmena souboru tento problem uz z principu nastav nemuze -
 - kdyz to je nesmysl nebo neni v mechanice disketa nebo tam neni zadny
 soubor : zobrazi se pouze seznam mechanik a uzivatel ma pouze 2 moznosti -
 - dat Escape nebo se prepnout na jinou mechaniku}

{bere mi tu mys jenom jednoduchym klikem, o 2kliku by se mu mohlo jenom zdat}

{nemam vypilovanou tu 1/3 vysky okna, o kterou se obsah posune, pokud vyjedu
 s kursorem ven (pri vysce okna = 5 souboru mi to zajizdelo pouze o 1 soubor
 a bylo z toho hnusne plynule rolovani
 !!!!! ja jsem dal natvrdo do procedury kontrolujmeze pri rolovani vyraz
 xxx+1, ale ta +1 tam nesmi byt, protoze mi to u 5 radkoveho sloupce dela
 trochu mimo a u 1 radkoveho to udela primo pruser - narusi celou obrazovku
 !!!!!
====> toto uz taky zatim provizorne odstraneno

{udelat mozna pri nalezu chyby ne upozorneni, ale otazku, zda opakovat atp.

 nekontroluje chybu s disketovou mechanikou a blbne s prehozenim A: a B: u
 1 mechanikoveho pocitace !!!!! ted uz jsem to spravil, ale zatim nevim ???}

{muj UNIT bere vsude fce HeigthOfFont atp... ===> nerozhaze ho ani prirazeni
 FonHeigth:=0 atp... (odzkouseno) !!!!!}

unit Files;

interface
uses dos,graph256;
type ttrideni=(trid_jmena,trid_pripony,trid_delky);

const MaxSouboru=500;                    {maximalni pocet nactenych souboru}
{davam sem natvrdo 500, ale kazdy to muze zmenit
 i tak ale osetruji preteceni pri mnoha souborech
 toto zabere v pameti asi 20KB, doufam jen, ze ta pamet bude volna,
   nekontroluji to totiz !!!!!
 pozn. muj adresar \WINDOWS\SYSTEM ma asi kolem 500 souboru a je tak uplne
   na mezi, ale bohuzel na druhe strane, tj. uz se tam ty soubory nevlezou,
   ale stejne je to dimenzovano dostatecne, protoze to je hodne velky
   adresar (vleze se to tam az asi kolem konstanty 520)}

type PSouboru=^Tsouboru;
     TSouboru=
       record
         Jmeno:NameStr;
         Prip:ExtStr;
         PraveJmeno:string[12];
         Delka:string[9];
       end;

     PAdresare=^TAdresare;
     TAdresare=record
       Pocet:integer;
       Obsah:array[1..MaxSouboru]of TSouboru;
     end;

     PSeznamMasek=^TSeznamMasek;
     TSeznamMasek=record
       Pocet:byte;
       Jmena:array[1..10]of namestr;
       Pripony:array[1..10]of extstr
     end;

(*
     TSeznamCest=record
       Pocet:byte;
       Cesty:array[1..10]of PathStr;
       {seznam cest, ktere jsme zmenili, abychom nemuseli nechtene menit
        aktualni adresare}
     end;
     {ne, ne, ne; cesty se nikdy menit ani pamatovat nebudou, nikdo to tak
      nedela (Windows, VP, BP, ...) a je to stejne nesmysl, snad to udelam
      priste, ale v mnohem dokonalejsi verzi !!!!!}
*)

function VyberSouboru(var X,Y,Pocet:integer;
                      Popr,Poz,Podtr,Ram,Okr:byte;
                      _font:PFont;
                      Trideni:TTrideni;
                      Cesta,Maska:string):string;
{provede pomoci klavesnice nebo mysi vyber souboru nebo adresare ze vsech
 disku podle jednoduche nebo slozene masky (oddeleny strednikama) a vrati
 cele jmeno vybraneho souboru/adresare pripadne #27 (Escape) nebo #0 (chyba)}

implementation

uses crt,users,dialog;



function VyberSouboru(var X,Y,Pocet:integer;
                      Popr,Poz,Podtr,Ram,Okr:byte;
                      _font:PFont;
                      Trideni:TTrideni;
                      Cesta,Maska:string):string;
  {pozice X a Y, Pocet souboru, ktere maji byt vertikalne v 1 okne,
   barva tohoto vlastne dialogoveho panelu,
   font, kterym se to ma psat
   styl trideni souboru v adresarich
   a pocatecni cesta a maska pro vyber (pokud je maska prazdna, provede se
     podobna akce jako je VyberSouboru - VyberAdresaru

   vraci :
     #27 - je-li Escape
     #0  - je-li chyba
     else - kompletni cesta k souboru}
var Adresar:PAdresare;            {obsah prohlizeneho adresare}
    seznmasek:TSeznamMasek;       {seznam vsech predanych masek}
    NaKteremAdresari:string[12];  {z ktereho adresare jsme sem prisli, kvuli
                                   prvotnimu nastaveni ramecku}
    uchovpozadi:pointer;          {puvodni pozadi pod dialogem}
    akce:byte;                   {pozadovana akce podle mysi nebo klavesnice}
      {0=Escape
       1=Enter, kliknuti mysi
           kam, to se nastavi do Akt1 a Zac1
       2=pouze pohyb zvyrazneni,
           kam, to se take nastavi do Akt1 a Zac1}
    Zac,Akt,Zac1,Akt1:integer;    {stara a nova pozice ramecku}

(*
    chyba:boolean;                {nastala-li pri cteni adresare chyba}
    {tato promenna uz neni potreba, protoze v pripade vyskytu chyby se
     chyba osetri a misto nacteni seznamu souboru se pouze nactou jmena
     diskovych mechanik a nabidne se tedy bud Escape nebo prechod na jinou
     nechaniku
     tato promenna je jeste pozustatek z dob, kdy jsem nastavoval prubezne
     cesty tak, jak uzivatel chodil po adresarich}
*)

procedure vypistext(idx:integer);
{vypise na obrazovku zadany radek od vrchu obrazovky}
var py:integer;
begin
{predpokladam, ze mam poradny font, ktery respektuje pozadi (barvou 255)
a pro popredi se diva do FonColor1 a zbytek si doplnuje sam ze standardni
palety a do FonColor2-4 se uz nediva !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

tento font se pak pretiskne pres puvodni pozadi a procedura pouze vytiskne
pismena s pomoci indexove tabulky, netiskne uz nove pozadi}
  FonColor1:=Popr;                       {vypis zadanou barvou}
  OverFontColor:=255;                    {barva pozadi je 255}

  py:=y+idx*heigthoffont(_font)+1;
  if (Zac+Idx-1)<=Adresar^.pocet then
    with Adresar^.Obsah[Zac+Idx-1] do begin
      printtext(x+1,py,Jmeno,_font);
      printtext(X+9*widthoffont(_font)+1,py,Prip,_font);
      printtext(X+13*widthoffont(_font)+1,py,Delka,_font)
    end
end;

procedure zvyraznitext(idx:integer);
{zyrazni dany radek prebarvenim pozadi na jinou barvu}
begin
  replacecolor(x+1,y+idx*heigthoffont(_font)+1,
               23*widthoffont(_font),heigthoffont(_font),
               Poz,Ram)
  {zmeni barvu pozadi na barvu zvyrazneni}
end;

procedure zruszvyrazneni(idx:integer);
{pretiskne dany radek barvou pozadi}
begin
  bar(x+1,y+idx*heigthoffont(_font)+1,
      23*widthoffont(_font),heigthoffont(_font),
      Poz)
  {vyplni barvou pozadi}
end;

procedure posuvnik(vidit:boolean);
{vypise/smaze vpravo od seznamu souboru posuvnik relativni pozice obrazovky}
var del,             {relativni velikost posuvniku k celku}
    mis,             {relativni pocatek posuvniku k celku}
    pom:longint;     {udavaji velikost celeho sloupku v bodech}
      {je to LongInt proto, ze vyraz pom*(zac-1) div adresar^.pocet
       prekracuje v mem adresari Windows velikost integer a nevim, zda by se
       vlezl do Wordu
       proto musim jeste predtim nez to poDIVuji to prevest na LongInt
       a touto definici se vyhnu nespolehlivemu (v BP) pretypovani
       poDIVovat to driv (jine poradi operaci) to nechci kvuli pripadne
       ztrate presnosti}
    barva:byte;      {barva vypisovaneho posuvniku}
begin
  pom:=pocet*heigthoffont(_font);
  if Adresar^.pocet-Zac+1<=Pocet then begin
    del:=pom* (adresar^.pocet-Zac+1) div adresar^.pocet;
    mis:=pom- del
  end else begin
    del:=pom* pocet div adresar^.pocet;
    mis:=pom* (zac-1) div adresar^.pocet
  end;
  {vypiplane 2 varianty pro nezaplneny a zaplneny panel, myslim, ze je to
   dokonale a ukazuje to vzdy presne}
  if vidit
    then barva:=popr
    else barva:=poz;
  if del<>0 then
    bar(x+23*widthoffont(_font)+2,
        y+heigthoffont(_font)+mis,
        widthoffont(_font)-3,
        del,
        barva)
  else
    linex(x+23*widthoffont(_font)+2,
          y+heigthoffont(_font)+mis,
          widthoffont(_font)-3,
          barva)
  {ten if tam musim dat proto, ze procedura Bar pri vysce 0 udela
   obdelnik o sirce 0 - tedy zadny a ja to musim videt}
end;

procedure kontrolujmeze(var akt,zac:integer);
{zkoriguje 2 parametry tak, aby to byly spravne udeje o pozici}
begin
  if akt<1 then                    {podteceni Akt}
    akt:=1;
  if akt>adresar^.pocet then       {preteceni Akt}
    akt:=adresar^.pocet;

  if akt<zac then                  {rolovani nahoru}
    zac:=akt-pocet div 3{+1};
{!!!!! ta +1 tam nesmi byt, viz. nahore !!!!!}
  if akt>zac+pocet-1 then          {rolovani dolu}
    zac:=akt-2*pocet div 3;
  {tento zpusob rolovani v pripade vyjeti posune okraj tak, aby byl ramecek
   prave v 1/3 okna
   mozna ze to nevypada ta efektne, ale je to pri drzeni sipky nahoru nebo
   dolu to nejrychlejsi}

(*  if akt<zac then                  {rolovani nahoru}
    zac:=akt;
  if akt>zac+pocet-1 then          {rolovani dolu}
    zac:=akt-pocet+1;
  {tento zpusob rolovani roloje radek po radku, tzn. pri vyjeti se posune
   cele okno, aby byl ramecek nakraji
   tento zpusob rolovani je strasne efektni a pekny, je to "skutecne"
   rolovani, ale je strasne pomaly a hrozne blika mys, proto ho
   nepouzivam}*)

  if zac>adresar^.pocet-pocet+1 then {preteceni Zac}
    zac:=adresar^.pocet-pocet+1;
  if zac<1 then                    {podteceni Zac}
    zac:=1
end;

procedure KresliPanel;
  forward;
procedure SmazPanel;
  forward;
procedure VypisSeznam(i1,i2:integer);
  forward;
procedure nadpis_mistoproposuvnik;
  forward;

procedure cekejnaudalost;
{ceka na udalost z klavesnice a mysi, analyzuje ji a preda ji dal}
label PageUp,PageDown;
var j,mkey,mx,my:integer;
    znak:char;

procedure posundialogu;
{posouva panel Files po obrazovce}
var mys:pointer;
    i:byte;
begin
  pushmouse;
  mouseswitchoff;
  newimage(24*widthoffont(_font),(pocet+2)*heigthoffont(_font),mys);
  getimage(x,y,24*widthoffont(_font),(pocet+2)*heigthoffont(_font),mys);
  putimage(x,y,uchovpozadi);
  {obnovi pozadi a zapamatuje si dialog a mys}

  mouseon(mx-x,my-y,mys);
  newmousearea(mx-x,my-y,320-24*widthoffont(_font),
    200-(pocet+2)*heigthoffont(_font));
  repeat
  until mousekey<>0;
  {nyni dialogem pohybuje jako mysi}

  inc(x,mousex-mx);
  inc(y,mousey-my);
  {zmeni souradnice dialogu}

  mouseswitchoff;
  getimage(x,y,24*widthoffont(_font),(pocet+2)*heigthoffont(_font),uchovpozadi);
  putimage(x,y,mys);
  disposeimage(mys);
  {obnovi na obrazovce dialog na novem miste vcetne zapamatovani
   noveho pozadi}

  repeat
  until mousekey=0;
  newmousearea(0,0,320,200);
  popmouse
  {obnovi stav mysi}
end;

procedure zoomdialogu;
{zoomuje panel Files}
var novypocet:integer;
begin
  pushmouse;
  repeat
    novypocet:=maxinteger((mousey-y{-1}) div heigthoffont(_font)-2,1);
    {zoomuj podle mysi, ale musi byt na panelu aspon 1 radek}
{myslim, ze podle logiky by tam to -1 melo byt, ale podle zkousenosti ne
 a bez nej mohu stand2 nazoomovat na 20 radku, tj. 18 radku pro soubory}
    if novypocet<>pocet then begin
      mouseswitchoff;
      smazpanel;
      pocet:=novypocet;
      kreslipanel;
      kontrolujmeze(akt,zac);
      vypisseznam(1,pocet);
      zvyraznitext(akt-zac+1);
      akt1:=akt;
      zac1:=zac;
      nadpis_mistoproposuvnik;
      posuvnik(true);
      mouseswitchon
    end
  until mousekey<>0;
  repeat
  until mousekey=0;
  popmouse
end;

begin
  {vypne a zapne mys na zacatku a na konci procedura, ktera nas vola}
  zac1:=zac;
  akt1:=akt;
    {nastav nejpravdepodobnejsi zvyrazneni po cekani na udalost}
  repeat
    while not keypressed do       {cekej na stisk klavesy nebo mysi}
      if mousekey<>0 then begin
        mkey:=mousekey;
        {vezmeme si tlacitka mysi}
        repeat
        until mousekey<>mkey;
        {pockame, az uzivatel odmackne tlacitko, nebo zmackne neco
         jineho atp.}
        mx:=mousex;
        my:=mousey;
        {nyni si vezmeme pozici mysi, abychom odmackli to, kde skonci}
        if mkey<>$01 then begin       {jine nez leve tlacitko ===> Escape}
          akce:=0;
          exit

        end else                      {jinak je to leve tlacitko :}

        if not inbar(mx,my,x+1,y,     {uplne mimo dialogovy panel ===> nic}
                 24*widthoffont(_font)-1, {orezavam vlevo o 1 bod}
                 (pocet+2)*heigthoffont(_font)) then
          continue

        else begin
          j:=(my-y-1) div heigthoffont(_font); {podivame se, kam padl}

          if inbar(mx,my,x+1,y+1,  {je v prostoru pro soubory ?}
                   23*widthoffont(_font),
                   (pocet+2)*heigthoffont(_font)-2) then
{udelat, at to nebere klik, pokud se klikne presne mezi radky !!!!!}
            {zde to mame krasne jednoznacne, protoze se mi nic neprekryva}
            if j=0 then begin         {nahore=posun dialogu}
              posundialogu;
              continue
            end else if j>pocet then begin {dole=zoom dialogu}
              zoomdialogu;
              continue
            end else begin            {jinak je to skok na nejaky soubor}
              if j+zac1-1>adresar^.pocet then
                Continue;
                {pokud jsme se trefili sice do dialogoveho a panelu a do
                 prostoru pro soubory, ale souboru je malo a zbyva tam
                 volne misto, pak jsme se nikam netrefili a testujeme udalost
                 znovu, jako by se nic nestalo}
              akt1:=j+zac1-1;
              akce:=1;
              exit
            end

          else                {jinak je to v prostoru pro posuvnik}
            if j=0 then               {nahore=pageup}
              goto PageUp
            else if j>pocet then      {dole=pagedown}
              goto pagedown
            else begin                {jinak je to klik do posuvniku}
              {presun na novy soubor}
              akt1:=integer( {pretypovani je nutne (viz. \windows\system)}
                longint((my-y-heigthoffont(_font)-1))
                        *adresar^.pocet
                        div (pocet*heigthoffont(_font)));
              kontrolujmeze(akt1,zac1);
              akce:=2;
              exit
            end
        end
      end;

    znak:=readkey;
    if znak=#27 then begin     {Esc, predame Esc}
      akce:=0;
      exit
    end else

    if znak=#13 then begin     {Enter, predame rizeni aktualnimu objektu}
      akce:=1;
      exit
    end else

    if znak in [#32..#255] then begin
      inc(akt1);
      znak:=upcase(znak);
      while (akt1<=adresar^.pocet)and(adresar^.obsah[akt1].jmeno[1]<>znak) do
        inc(akt1);
      if akt1>adresar^.pocet then
        akt1:=akt;
      kontrolujmeze(akt1,zac1);
      akce:=2;
      exit;
    end else

    if (znak=#0)and(KeyPressed) then begin {#0, cteme dalsi klavesu}
      znak:=readkey;
      case znak of
        #72:begin              {sipka nahoru, pouze posun}
          dec(akt1);
          kontrolujmeze(akt1,zac1);
          akce:=2;
          exit
        end;
        #80:begin              {sipka dolu, pouze posun}
          inc(akt1);
          kontrolujmeze(akt1,zac1);
          akce:=2;
          exit
        end;
        #73:PageUp:begin       {PageUp skoci o stranku nahoru}
              Dec(akt1,Pocet);
              kontrolujmeze(akt1,zac1);
              akce:=2;
              exit
            end;
        #81:PageDown:begin     {PageDown skoci o stranku dolu}
              Inc(akt1,Pocet);
              kontrolujmeze(akt1,zac1);
              akce:=2;
              exit
            end;
        #71:begin              {Home skoci na zacatek seznamu}
              Akt1:=1;
              Zac1:=1;
              {kontrolujmeze(akt1,zac1); {neni potreba}
              akce:=2;
              exit
            end;
        #79:begin              {End skoci na konec seznamu}
              Akt1:=Adresar^.pocet;
              Zac1:=Akt1;
              kontrolujmeze(akt1,zac1);
              akce:=2;
              exit
            end;
      end
    end else                   {jina klavesa, pokusime se zjisit, kam ukazuje}
      {tady se (priste) pokusime najit soubor podle jeho pocatecniho pismena}

    {jestlize se udalost nikde "nezachyti" testujeme znovu}
  until false
  {nekonecny cyklus, vyskakuje se z nej pri nalezeni vhodne udalosti
   prikazem Exit
   procedura vzdy vrati, co bylo zmacknuto, pripadne to zmacknuti trochu
   osidi (emulace pri udalosti mysi), tim je predano rizeni nekteremu
   objektu a my muzeme pokracovat dal}
end;

function Odpovida(Jmeno,Maska:string):boolean;
{vrati, zda soubor odpovida zadane masce}
var i:byte;
begin
  odpovida:=true;
  for i:=1 to length(maska) do
    if (maska[i]<>'?')and((length(jmeno)<i)or(jmeno[i]<>maska[i])) then begin
      odpovida:=false;
      exit
    end;
  if length(jmeno)>length(maska) then
    odpovida:=false
    {jestlize az dosud vse padlo, ale jmeno je kratsi nez maska, je to
     spatne a neodpovida to}
end;

function typdisku(disk:char):byte;
{vraci typ daneho disku : 0-neexistuje, 1-FDD, 2-HDD, 3-Net}
var r:registers;
begin
  typdisku:=0;
  disk:=upcase(disk);

  r.bl:=byte(disk)-$40; {dotaz se, zda je disk vzdaleny (po siti)}
  r.ax:=$4409;
  msdos(r);

  if(r.flags and fcarry)=fcarry then
    exit;        {neexistuje disk}

  if (r.dh and $10)=$10
    then typdisku:=3    {sitovy disk}
    else begin          {"tady" disk}
           r.ax:=$4408;
           msdos(r);
           if r.al<>$0f then begin {neni-li chyba}
             typdisku:=r.al+1;

             r.ax:=$440e;         {zeptej se, co je prirazeno jako}
             r.bl:=1;               {2. mechanika k A:}
             msdos(r);

             if (r.al<>0)and(r.al=byte(disk)-$40) then
               typdisku:=0
               {jestlize je to asociovano i k druhe mechanice a my se na ni
                zrovna ptame, prirad, ze neexistuje}
           end
         end
end;

{!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!}

procedure KresliPanel;
var ret:string;
begin
  newimage(24*widthoffont(_font),(pocet+2)*heigthoffont(_font),uchovpozadi);
  getimage(X,Y,24*widthoffont(_font),(pocet+2)*heigthoffont(_font),uchovpozadi);
  Rectangle(X,Y,24*widthoffont(_font),(pocet+2)*heigthoffont(_font),okr);
  Bar(X+1,Y+1,24*widthoffont(_font)-2,(pocet+2)*heigthoffont(_font)-2,poz);
  {pripravi obrazovku a mys k vyberu souboru,
   misto 23*... je tam 24*..., protoze jsem pridal vpravo posuvnik o sirce
   1 znaku}
  Bar(x+23*widthoffont(_font)+2,y+1,
      widthoffont(_font)-3,
      heigthoffont(_font)-1,
      podtr);
  Bar(x+23*widthoffont(_font)+2,y+(pocet+1)*heigthoffont(_font),
      widthoffont(_font)-3,
      heigthoffont(_font)-1,
      podtr);
  LineY(x+23*widthoffont(_font)+1,y,
      (pocet+2)*heigthoffont(_font),
      okr);
  {udela nahore a dolu u posuvniku 2 male znacky - vyplnene ctverecky}

  Ret:=Maska;
  if Ret='' then
    Ret:='Výběr adresáře';
  if widthoftext(_font,Ret)>23*widthoffont(_font) then begin
    Insert('...',Ret,1);
    {hloupe naprogramovano, ale chodi to jednoduse a dobre}
    while widthoftext(_font,Ret)>23*widthoffont(_font) do
      Delete(Ret,4,1)
  end;
  FonColor1:=Podtr;                      {nastav tyto nutne konstanty}
  OverFontColor:=255;
  Printtext(X+(23*widthoffont(_font)-widthoftext(_font,Ret)) div 2+1,
              Y+(pocet+1)*heigthoffont(_font),Ret,_font)
  {vypise na dolni radek dialogu masky, ktere hledame}
{mam dojem, ze dolni radek masky (Vypis adresare) zasahuje skarede do
 ohranicujici linky}
end;

procedure SmazPanel;
begin
  putimage(X,Y,uchovpozadi);
  disposeimage(uchovpozadi)
end;

procedure Inicializace;
var i,j:byte;
    ret:string;
    jm:namestr;
    prip:extstr;
begin
  getdir(0,ret);         {cti aktualni disk (i s adresarem)}

  Cesta:=FExpand(cesta); {FExpand rozepise cestu a vzdy bude na konci \}
  NaKteremAdresari:=upcase(ret[1])+':';
  {ma hledat na pocatku aktualni disk pro pojizdny ramecek}
{mozna tam nemusi byt upcase ?!?!?}

  seznmasek.pocet:=0;
  i:=1;
  if maska<>'' then
    repeat
      j:=i;
      while (i<=length(maska))and(maska[i]<>';') do
        inc(i);
      ret:=copy(maska,j,i-j);

      j:=pos('.',ret);
      if j=0 then begin
        jm:=ret;                  {pouze soubory bez pripony}
        prip:=''
      end else begin
        jm:=copy(ret,1,j-1);      {ostatni masky s teckou}
        prip:=copy(ret,j+1,length(ret)-j)
      end;

      if jm='' then               {bez jmeno ===> dopln na *.pripona}
        jm:='*';                  {bez pripony znamena proste bez pripony}

      j:=1;
      while (j<=length(jm))and(jm[j]<>'*') do
        inc(j);
      if j<=length(jm) then begin {najdeme-li hvezdicku, vyotaznikujeme zbytek}
        for j:=j to 8 do
          jm[j]:='?';
        jm[0]:=#8
      end;
      for j:=1 to 8 do
        jm[j]:=upcase(jm[j]);

      j:=1;
      while (j<=length(prip))and(prip[j]<>'*') do
        inc(j);
      if j<=length(prip) then begin {najdeme-li hvezdicku, vyotaznikujeme zbytek}
        for j:=j to 3 do
          prip[j]:='?';
        prip[0]:=#3
      end;
      for j:=1 to 3 do
        prip[j]:=upcase(prip[j]);

      inc(seznmasek.pocet);
      seznmasek.jmena[seznmasek.pocet]:=jm;
      seznmasek.pripony[seznmasek.pocet]:=prip;
      inc(i)
    until i>length(maska);
    {probere vsechny masky}

  pushmouse;
  mouseswitchoff;
  KresliPanel;
  New(Adresar);
end;

procedure Finalizace;
begin
  Dispose(Adresar);
  SmazPanel;
  popmouse
  {vrati vse do puvodniho stavu}
end;

procedure nadpis_mistoproposuvnik;
var pomcesta:string;
begin
  Bar(X+1,Y+1,23*widthoffont(_font),heigthoffont(_font),poz);
  PomCesta:=Cesta;
  if widthoftext(_font,PomCesta)>23*widthoffont(_font) then begin
    Insert('...',PomCesta,3);
    {hloupe naprogramovano, ale chodi to jednoduse}
    while widthoftext(_font,PomCesta)>23*widthoffont(_font) do
      Delete(PomCesta,6,1)
  end;
  FonColor1:=Podtr;                      {nastav tyto nutne konstanty}
  OverFontColor:=255;
  Printtext(X+(23*widthoffont(_font)-widthoftext(_font,PomCesta)) div 2+1,
              Y+1,pomcesta,_font);
  {vypis nove jmeno adresare}

  Bar(x+23*widthoffont(_font)+2,y+heigthoffont(_font),
      widthoffont(_font)-3,pocet*heigthoffont(_font),
      poz)
  {vykresli pozadi pro posuvnik, aby tam nebyly zadne rusive zbytky z minula}
end;

procedure NactiAdresar;
{naplni pole souboru obsahem prohlizeneho adresare, vhodne ho setridi
 a nastavi vsechny potrebne parametry}
var Idx:integer;

  procedure ZapisDoSeznamu;
  {zapise do pole souboru vsechny podadresare a soubory (pripadne hlasku
   Nastvit) z prohlizeneho adresare}
  var Soubor:SearchRec;
      i:byte;
      ok:boolean;
  begin
    Adresar^.Pocet:=0;                          {vynuluj pocitadlo souboru}

    if cesta[length(cesta)]<>'\' then
      cesta:=cesta+'\';

    FindFirst(Cesta+'*.*',AnyFile,Soubor);      {prohledej cely adresar}
    while DosError=0 do begin
      if adresar^.pocet=MaxSouboru-30 then begin
        StandardniDialog('Příliš mnoho souborů v adresáři,|'+
          'nenačtené soubory usekávám',
          Popr,Poz,Podtr,Ram,Okr,
          _font,
          upozorneni);
        break
        {kontroluje preteceni pri mnoha souborech a adresarich, ma tam
         jeste naraznik 30 souboru, aby se mu tam na 100% vlezly vsechny
         diskove jednotky (26) a 1 hlaska Nastavit.!!! pri vyberu adresare}
      end;

      Inc(adresar^.pocet);                      {dejme tomu, ze ho vezmeme}
      adresar^.obsah[adresar^.pocet].PraveJmeno:=Soubor.Name;

      if (Soubor.Attr and Directory)=Directory then {je to adresar ?}
        with Adresar^.obsah[adresar^.pocet] do
          if PraveJmeno='.' then                {nezarazujeme .}
            Dec(adresar^.pocet)

          else if PraveJmeno='..' then begin    {nadadresar ..}
             Jmeno:='..';
             Prip:='';
             Delka:='<NAD-ADR>'

          end else begin                        {adresare bez pripony}
            i:=pos('.',pravejmeno);
            if i=0 then begin
              jmeno:=pravejmeno;
              prip:=''
            end else begin                      {adresare s priponou}
              jmeno:=copy(pravejmeno,1,i-1);
              prip:=copy(pravejmeno,i+1,length(pravejmeno)-i)
            end;
            Delka:='<POD-ADR>'
          end

      else                                      {jinak je to soubor}
        with Adresar^.obsah[adresar^.pocet] do begin

          i:=pos('.',pravejmeno);
          if i=0 then begin                     {soubory bez pripony}
            jmeno:=pravejmeno;
            prip:=''
          end else begin                        {soubory s priponou}
            jmeno:=copy(pravejmeno,1,i-1);
            prip:=copy(pravejmeno,i+1,length(pravejmeno)-i);
          end;

          Str(Soubor.Size,Delka);

          ok:=false;                            {prover, zda to zapada do}
          for i:=1 to seznmasek.pocet do          {nektere masky}
            if Odpovida(jmeno,seznmasek.jmena[i]) and
               Odpovida(prip,seznmasek.pripony[i]) then
              ok:=true;

          if not ok then                        {neodpovida-li to nicemu,}
            dec(adresar^.pocet)     {tj. je-li to mimo masku nebo se jedna}
        end;                        {o vyber adresare, nezarad ho}

      FindNext(Soubor)              {pocivej se na dalsi soubor}
    end;

    if (DosError<>18)and(DosError<>0) then
      StandardniDialog('Chyba při čtení adresáře|'+
        '(jednotka není připravena,|málo paměti atp...)',
        Popr,Poz,Podtr,Ram,Okr,
        _font,
        upozorneni);
      {skoncilo-li cteni adresare jinou chybou new NoMoreFiles nebo
       VsechnoOk, dej o tom vedet upozornujicim rameckem

       VsechnoOk je tam kvuli tomu, ze se cyklus muze ukoncit uprostred
       cteni pri zaplneni pametove kapacity a to je jeste DosError=0}

    if seznmasek.pocet=0 then begin             {jedna-li se o vyber adresare}
      inc(adresar^.pocet);
      with adresar^.obsah[adresar^.pocet] do begin
        jmeno:='Nastavit';
        prip:='!!!';
        pravejmeno:='';
        delka:='<ADRESÁŘ>'
      end
      {pripojime pak misto jakehokoliv souboru pouze hlasku Nastavit, na
       kterou kdyz se najede a zmackne (jako by se vybral soubor), ten se
       nastavi aktualni adresar na tento prohlizeny adresar}
    end
  end;

  function Mensi(var A1,A2:TSouboru):Boolean;
  {vrati, zda je zadany soubor "mensi" nez ten druhy, pouzito pro setrideni
   adresare
   ridi se podle 2 zasad : nejprve se daji vsechny adresare a teprve pak
   vsechny soubory a pokud probiha vyber adresare, tak se hlaska Nastavit
   da na konec adresaru (mezi adresare a disky)
   obe dve skupiny se jakoby kazda zvlast setridi podle zadaneho kriteria,
   pokud toto kriterium neni jednoznacne (stejne pripony), tridi dale podle
   kriteria, na nez se nejvic "citi" - to je v "tabulce algoritmu"}
  var adr1,adr2,
      nas1,nas2:boolean;
      trid:byte;
      cis1,cis2:longint;
      chyba:integer;
  begin
    trid:=byte(trideni);        {prirad zpusob trideni}
    adr1:=a1.delka[1]='<';      {prirad, zda je zadany soubor adresarem}
    adr2:=a2.delka[1]='<';
    if adr1 xor adr2 then begin {adresare jsou vzdy na zacatku}
      mensi:=adr1;              {prohod/neprohod je, aby byly ve spravnem}
      exit                        {poradi}
    end;

    nas1:=a1.jmeno='Nastavit';  {prirad si, zda je nektery "soubor" vlastne}
    nas2:=a2.jmeno='Nastavit';    {hlaskou}
    if nas1 xor nas2 then begin {je prave 1 z nich hlaskou ?}
      mensi:=nas2;              {prohod/neprohod je, aby byly ve spravnem}
      exit                        {poradi}
    end;
    {hlaska je osetrena a uz se o ni nemusim vice starat}

    if trid=2 then              {trideni podle delky}
      if adr1                   {jsou-li oba adresare, serad je podle pripony}
        then trid:=1
        else begin
          val(a1.delka,cis1,chyba);
          val(a2.delka,cis2,chyba);
          mensi:=cis1<cis2;exit
        end;
    if trid=1 then              {trideni podle pripony}
      if a1.prip=a2.prip        {shodne pripony serad podle jmena}
        then trid:=0
        else begin
          mensi:=a1.prip<a2.prip;
          exit
        end;
    if trid=0 then              {trideni podle jmena}
      if a1.jmeno=a2.jmeno      {jsou-li shodna jmena, obrat se jeste na priponu}
        then mensi:=a1.prip<a2.prip
        else if a1.jmeno='..'          {.. musi byt vzdy na zacatku}
               then mensi:=true
               else if a2.jmeno='..'
                      then mensi:=false
                      else mensi:=a1.jmeno<a2.jmeno
  end;

  procedure SetridSoubory(l,r:integer);
  {setridi soubory v poli adresare metodou QuickSort podle parametrem
   zadaneho klice, vyuziva funkci Mensi, viz. vyse}
  var i,j:integer;
      x,y:TSouboru;
  begin
    i := l;
    j := r;
    x := adresar^.obsah[(l+r) DIV 2];
    repeat
      while mensi(adresar^.obsah[i],x) do
        inc(i);
      while mensi(x,adresar^.obsah[j]) do
        dec(j);
      if i<=j then begin
        y:=adresar^.obsah[i];
        adresar^.obsah[i]:=adresar^.obsah[j];
        adresar^.obsah[j]:=y;
        inc(i);
        dec(j)
      end
    until i>j;
    if l<j then
      SetridSoubory(l,j);
    if i<r then
      SetridSoubory(i,r);
  end;

  procedure PripisDisky;
  {procedura pripise na konec pole adresare seznam vsech dostupnych diskovych
   jenotek a napise take jejich strucnou charakteristiku}
  var zn:char;
      typ:byte;
  begin
    for zn:='A' to 'Z' do begin
      typ:=typdisku(zn);
      if typ=0 then             {neexistuje-li}
        continue;
      inc(adresar^.pocet);
      with adresar^.obsah[adresar^.pocet] do begin
        pravejmeno:=zn+':';
        jmeno:=pravejmeno;
        prip:='';
        case typ of
          1:delka:='[FDD]';
          2:delka:='[HDD]';
          3:delka:='[Net]'
        end
      end
    end
  end;

var r:registers;
begin
  r.ax:=$440f;                      {sdel, ze chces pracovat s touto}
  r.bl:=byte(upcase(cesta[1]))-$40; {mechanikou (kvuli prohozeni A: s B:)}
  msdos(r);

(*
  chyba:=true;
  {$i-}
  chdir(cesta[1]+':');          {zmen aktualni disk na zadany}
  if ioresult<>0 then             {nastala-li chyba, konec}
    exit;
  if length(cesta)<=3             {zmen aktualni adresar na zadany}
    then chdir(cesta)
    else chdir(copy(cesta,1,length(cesta)-1));
  if ioresult<>0 then             {nastala-li chyba, konec}
    exit;
  {$i+}
  chyba:=false;
  {toto je jeste stara kontrolovaci rutina, ktera nastavovala aktualni
   adresar, coz uz ted nechci}
*)

  ZapisDoSeznamu;                 {zapise do seznamu nactene soubory}
  if adresar^.pocet<>0 then       {pokud neco nacetl, spusti se tridici}
    SetridSoubory(1,adresar^.pocet); {algoritmus}
  PripisDisky;                    {pripise na konec seznam disk. jednotek}

  {osetreni proti chybam je takove :
    - pokud je mnoho souboru v adresari, oriznou se zbyvajici a program
      o tom da vedet v upozornujicim ramecku
    - pokud nastane chyba pri cteni adresare, program nic nenacte a nactou
      se pouze jmena diskovych jednotek
    - nenacteni zadneho souboru a chybu pri cteni z jednotky program
      rozlisi pripadnym chybovym upozornenim (zjistuje to podle toho, zda
      je v DosError NoMoreFiles nebo neco jineho}

  {nyni nastavime pocatecni pozici zvyraznovaciho ramecku podle toho, odkud
   jsme do tohoto adresare prilezli}

  Zac:=1;
  if NaKteremAdresari='..' then
    {byl-li prechod o adresar dale, dej ramecek na 1. soubor, tj. na ..}
    Akt:=1
  else

  if (NaKteremAdresari[0]=#2)and(NaKteremAdresari[2]=':') then
    {byla-li zmena disku, to je i na zacatku procedury}
    for Idx:=1 to adresar^.pocet do begin
      with Adresar^.obsah[Idx] do
        if (Delka[1]='[')and(PraveJmeno[1]=NaKteremAdresari[1]) then
{chyba : musim brat v uvahu i prohozeni mechanik A: s B:, jeste o tom musim
         zapremyslet}
          Akt:=Idx
    end
{!!!!!!!!!!!!!!!!!!!!! chyba zkurveneho Pascalu, zkus si to dat bez
                       BEGINu a ENDU, to uz je skoro jako to preteceni,
                       ktere je tam ale asi schvalne !!!!!!!!!!!!!!!!!!!}
  else
  {jinak je to skok z adresare zpet ke korenovemu adresari}

    for Idx:=1 to adresar^.pocet do
      with Adresar^.obsah[Idx] do
        if (Delka[1]='<')and(PraveJmeno=NaKteremAdresari) then
          Akt:=Idx;

  kontrolujmeze(akt,zac);
  {nastav Zac podle Akt (kvuli nejednoznacne pozici zvyraznovaciho ramecku)}
  nadpis_mistoproposuvnik
  {vypis novy nadpis a vycisti pozadi pro posuvnik}
end;

procedure VypisSeznam(i1,i2:integer);
{vypise natvrdo seznam souboru v okne od pozice i1 do pozice i2}
var Idx:integer;
begin
  bar(x+1,y+i1*heigthoffont(_font)+1,
      23*widthoffont(_font),(i2-i1+1)*heigthoffont(_font),
      poz);
  {nejprve smazeme obdelnik, ktery budeme prekreslovat
   je to rychlejsi a elegantnejsi nez to delat po radcich a zvlast}

  for Idx:=i1 to i2 do
    vypistext(idx)
  {nyni do toho pouze vepiseme samotne texty}
end;

procedure Rolovani;
{pokud se zmenil pocatek vykreslovani seznamu souboru, pokusi se tato
 procedura prekreslit obrazovku tak sikovne, aby se nemusel moc vypisovat
 seznam textu (pouzije k tomu efekt rolovani, kterym posune ty soubory,
 ktere se na obrazovce pouze posunou a zbyle soubory uz bohuzel musi
 natvrdo vypsat)}
var Buf:pointer;
    Del:integer;
begin
  if Zac1=Zac then                      {pokud nemusim rolovat, neroluji}
    Exit;

  Posuvnik(false);                      {nejprve smazeme posuvnik}

  if Abs(Zac1-Zac)>=Pocet then begin    {pokud to nelze jen odrolovat (je to}
    Zac:=Zac1;                            {prilis daleko), uprav zacatek}
    VypisSeznam(1,Pocet)                  {a prekresli to rovnou}
  end else begin                        {pokud se to pouze posunulo, muzeme}
    Del:=Pocet-Abs(Zac1-Zac);             {vyuzit vyhod rolovani :}
    {kolik radku se bude rolovat}
    NewImage(23*widthoffont(_font),Del*heigthoffont(_font),Buf);
    {vytvorime si pro to prostor}

    if Zac1<Zac then begin              {odrolovalo-li to dolu}
      GetImage(X+1,Y+heigthoffont(_font)+1,
               23*widthoffont(_font),Del*heigthoffont(_font),Buf);
      PutImage(X+1,Y+(Zac-Zac1+1)*heigthoffont(_font)+1,Buf);
      {posun obraz}

      Zac:=Zac1;
      {posuneme zacatek na spravne misto}
      VypisSeznam(1,Pocet-Del)
      {dopis rucne text}
    end else

    begin                               {odrolovalo-li to nahoru}
      GetImage(X+1,Y+(zac1-zac+1)*heigthoffont(_font)+1,
               23*widthoffont(_font),Del*heigthoffont(_font),Buf);
      PutImage(X+1,Y+heigthoffont(_font)+1,Buf);
      {posun obraz}

      Zac:=Zac1;
      {posuneme zacatek na spravne misto}
      VypisSeznam(Del+1,Pocet)
      {dopis rucne text}
    end;

    DisposeImage(Buf)
    {zrusime si prenosny buffer a to je vse}
  end;

  Posuvnik(true)
  {na konci patricne opet vykrelsime posuvnik}
end;

procedure ListujAdresar;
begin
  VypisSeznam(1,Pocet);
  Posuvnik(true);
  {na pocatku vypiseme vsechny soubory a vykreslime posuvnik}
  repeat
    zvyraznitext(akt-zac+1);
    {zvyrazni aktualni objekt}

    mouseswitchon;
    repeat
      cekejnaudalost;
    until (akce<>2)or(akt<>akt1);
    mouseswitchoff;
    {cekej na udalost tak dlouho, dokud se neco nestane
     pokud se pouze dostane prikaz na pohyb na sebe samotneho, tak testujeme
     znovu, abychom zbytecne nehybali rameckem}

    zruszvyrazneni(akt-zac+1);
    vypistext(akt-zac+1);
    {vratime aktualni objekt do puvodniho stavu,
     cimz mame seznam souboru opet cely "cisty"}

    rolovani;
    {vyvolame specialni rolovaci proceduru, ktera v pripade nutnosti
     odroluje obrazovku s pouzitim co nejmensiho poctu ukonu}

    akt:=akt1
    {upravime si aktualni pozici}

  until akce<>2
  {nyni opustime cyklus a tim i proceduru, jestlize byla zadana
   akce 0 (Escape) nebo akce 1 (Enter); rizeni prevezme dalsi procedura,
   ktera tuto udalost zpracuje
   pokud ale byla zadana akce 2 (pouhy pohyb), vyvolame cyklus znovu
   a delame to tak dlouho, dokud nebude zadana jedna z vyse uvedenych akci}

  {vedlejsim efektem tohoto poradi akci je, ze i pri ukonceni klavesou Enter
   nebo Escape se mi aktualizuje seznam souboru na obrazovce, takze je tam
   videt pouze seznam souboru v okamziku opusteni bez nejakeho rusiveho
   zvyraznovaiho ramecku atp...}
end;

function ChceKonec:Boolean;
var Idx:byte;
    soub:searchrec;
begin
  with Adresar^.Obsah[Akt] do
    if akce=0 then begin              {Escape ?}
      VyberSouboru:=#27;
      ChceKonec:=true
    end else                          {jinak Enter}

    if Delka[1]='<' then              {do nejakeho adresare ?}
      case Delka[2] of                {podivej se, co je to za typ adresare}
        'A':begin                     {<ADRESAR> pouze pri vyberu adresare}
              vybersouboru:=cesta;    {vrat vybranou cestu}
              chcekonec:=true
            end;
        'N':begin                     {<NAD-ADR> nadadresar}
              Idx:=Length(Cesta);     {najdeme jmeno posledniho adresare}
              repeat
                Dec(Idx)
              until Cesta[Idx]='\';
              NaKteremAdresari:=Copy(Cesta,Idx+1,
                (Length(Cesta)-1)-(Idx+1)+1);
              Cesta[0]:=char(Idx);    {nove jmeno adresare}
              ChceKonec:=false
            end;
        else begin                    {<POD-ADR> jinak je to podadresar}
               Cesta:=Cesta+PraveJmeno+'\';    {pripis to k ceste}
               NaKteremAdresari:='..';
               ChceKonec:=false
             end
      end
    else

    if Delka[1]='[' then begin        {do nejakeho disku ?}
      nakteremadresari:=cesta[1]+':'; {zapis si aktualni disk}
      cesta:=fexpand(pravejmeno[1]+':'); {nove cesta}
      ChceKonec:=false
      {bez jakekoliv kontroly skocim na novy disk,
       kontrolu je zbytecne delat na 2 mistech a pokud si mam misto vybrat,
       tak je to nacitaci rutina, protoze ta je volana uplne na zacatku
       a kdyby byla kontrola tady, tak by se to tam zhroutilo
       takto je to zajisteno proti vsem chybam}
    end

    else begin                        {jinak vyber souboru}
      VyberSouboru:=Cesta+PraveJmeno;
      ChceKonec:=true
    end
end;

begin
  Inicializace;
  {inicializuje pamet a obrazovku a doplni cestu na kompletni cestu
   s lomitkem na konci}
  repeat
    NactiAdresar;
    {pozaduje zadanou kompletni cestu s lomitkem na konci a masku}
(*
    if chyba then begin
      vybersouboru:=#0;
      break
    end;
    {rovnez pozustatek z minula, kdy jsem jeste nedokazal osetrit chyby
     ted uz si to procedurka osetri sama a hlavni proceduru uz do toho
     nezatahuje}
*)
    ListujAdresar
    {projizdi nactenym adresarem, dokud se nezmackne Escape nebo Enter}
  until ChceKonec;
  {je-li zmacknuto Escape nebo Enter na souboru, vrati true, je-li zmacknuto
   Enter na adresari nebo na disku, zmeni se promenna Cesta a vrati se false}
  Finalizace
  {uklidi pamet a obrazovku}
end;



end.
