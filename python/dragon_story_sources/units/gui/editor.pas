{pozn. !!!!! edmincislo a edmaxcislo jsou globalni promenne a proto
       se taky nemeni jejich hodnota, pokud o to uzivatel nepozada !!!!!}

{rozdelit boolean.parametr:ZobrazitOkno atp... na vice parametru
 parametr SmiSePresouvat okno je ted taky automaticky prisouzen parametru
 ZobrazitOkno (okno je vzdy presouvatelne a dialog ne; pro to okno bych ale
 asi mel pridat jeste 1 switch}

{a pridat 2 promenne urcujici, zda se to ma na zacatku a na konci
 vykreslit/smazat (stejne jako v dialogu) a dodelat do i do Files

 pridat lepsi formatovani textu

 obcas cekat na retrace, at mi furt tak (trochu) hnusne neblika mys atp...}

{zatim vsechny me knihovny (mimo editoru) porad nastavuji OverFontColor,
 protoze si nejsou jisty jeho aktualni hodnotou
 =====> at se to bud nastavi v Graph256 nebo na zacatku knihovny v me
        inicializacni procedure !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

 !!! mozna nastavit OverFontColor nikoliv na 255, ale na to, z ceho se
     sklada mezera, protoze mezery jsou (pokud vim) vzdy prazdne}

{chyby se jiz oznamuji vys, ale bacha, ze nemam treba kombinaci pro normalni
   smazani radku, pouze pro vyjmuti (Ctrl-Y) atp.
 u orezavacich promennych - mozna by slo zahrnout i kombinaci Orezavat+
   Neprekracovat a to tak, ze by se orezavalo maximalne pod kursor
 misto Ctrl-R vyrobit radsi funkci Undo/Redo
 mazani vpred a vzad - slova kontra oddelovace - definitivne vyresit}



{
 V tomto modulu je ulozen univerzalni radkovy editor. Lze jej
 pouzit jak v dialogovych boxech, tak i ve formularich a v
 textovem editoru.
 Parametry se predavaji v globalnim zaznamu. Je jich mnoho,
 proto je vhodne definovat dalsi jednoduzsi procedury (napr.
 konkretni editor cisel, jmen souboru atd...).
}

{
 mozna dat shirt:ctrl:alt-f5/f6
   pro smazani vpred/vzad : mazani i konce radku : mazani jenom slov
   ale to uz by si nikdo nezapamatoval
 mozna by si to nejaky rejpal jeste smlsl na tomto :
   pri mazani nejake casti slov se nedeje nic, kdyz je kursor za textem
   pri mazani do zacatku objektu se nic nedeje, pokud je kursor uz na
     zacatku tohoto objektu a tedy se treba ani nespojuji radky, pokud je
     kursor na pocatku radku na pocatku slova
   a mozna bych vymyslel jeste neco
   zrovna jsem si vzpomel - ^W tesne za koncem textu maze i posledni objekt
     na radku - to je zrovna vec, ktera je naopak - jednoduseji se progra-
     muje, vybocuje z logiky a je to jeden z "vylepseni" - ale je to nahoda
     (pricina : fce krajobjektu(-1) testuje na interval <1,length> uz
                s prictenim posunuti -1, tj. vybere true, i kdyz je to jeste
                tesne za textem)
     pozn. toto uz jsem opravil - ono to totiz blbne, protoze si to spatne
           spocitalo, zda ma hledat oddelovac nebo slovo (protoze to odvodil
           ze znaku za koncem textu, ktery uz ale neni definovan)
 obrana : logika pri praci se slovy a radky je tezka a dobre jsem ji
          rozvazil a naprogramoval tak, aby uzivatel tusil co "to" udela
   nektere tyto veci by mozna byly hezke a zpestrily by editor, ovsem
   na to se uz nazory rozchazeji, editor by nebyl jednoznacny podle
   jednoduche logiky a hure by se to programovalo

 Ovladani :
   - pohyby :
     Vlevo, Vpravo   : posun po znaku doleva, doprava
     ^Vlevo, ^Vpravo : posun po slovech doleva, doprava
     Home, End       : posun na zacatek, konec textu
     ^Home, ^End     : posun na zacatek, konec obrazu
     Tab, Shift-Tab  : posun po 8 znacich doleva, doprava
   - editace :
     BackSpace, Delete : vymaz znaku vlevo od kursoru, nad kursorem
     Insert            : prepinani vkladani/prepisovani
     ^F5, ^Y, ^F6      : mazat radek doleva, cely radek, radek doprava
     ~F5, ^W, ~F6      : mazat slovo doleva, cele slovo, slovo doprava
     ^R                : obnov puvodni stav radku (pred editaci)
}

unit Editor;



interface
uses graph256;
type TSetChar = set of char;
     TRolProc = procedure (Zac:integer);
     TOkFunkc = function (Ret:string):Boolean;

     PEditor=^Teditor;
     TEditor=record
     {promenne urcujici chovani editoru :}
       SX,SY,Del:integer;             {pozice a horizontalni delka vyrezu
       pro text (zadana v bodech), vertikalni delka se dopocita z velikosti
       jednoho ci dvou fontu (podle toho, zda se jedna o okno, nebo
       o editacni linku)}
       Vyzva:string[40];              {vyzva pri editaci}
       fText,fNadpis:PFont;           {fonty pro nadpis a samotny text}
       bPopr,bPoz,bNadp,bKurs,bInv,bOkr,bPos:byte;
       {barva popredi a pozadi textu, popredi nadpisu, kursoru, inverzniho
        textu, okraje okna a posuvniku}
       ZobrazeniOkna:Boolean;         {typ zobrazeni na obrazovce}
         {true  : - zobrazi se ramecek a vubec cele okno, ktere se na
                    zacatku vykresli a na konci po sobe zase uklidi
                  - okolo editoru se dela ramecek
                  - editor je nakreslen na 2 radcich - na 1. je VZDY vyzva
                    k editaci, na 2. je editacni radek s (pripadnymi)
                    posuvniky
                  - editor je sam ve svem okne a je sam panem na
                    obrazovce, rizeni tedy preda teprve po skonceni editace
          false : - pouze se zobrazuje editacni linka, zadne nadpisy ani
                    okna a na konci se obrazovka neobnovuje
                  - zadny ramecek se nedela, predpoklada se, ze radkovy
                    editor jakoby zapadne do pozadi (dialogovy panel,
                    opravdovy textovy editor...)
                  - editor se sklada pozue z 1 radku, na kterem je text
                    a mozna jeste posuvniky
                  - pokud se klikne mysi jinam, bere se to jako prikaz
                    pro zmenu zvyraznovaciho ramecku v dialogovem panelu
                    ===> preda se rizeni}
       PocatecniInverze:Boolean;      {bude se zpocatku text zvyraznovat ?}
       OriznoutMezery:Boolean;        {uriznout na konci koncove mezery ?}
       PrubezneOrezavat:Boolean;      {orezavat prubezne koncove mezery ?}
       MuzePresahovat:Boolean;        {muze jit kursor za konec textu ?}
         {jsou povoleny vsechny 4 kombinace predchozich 2 promennych}
       Posuvniky:Boolean;             {budou se zobrazovat posuvniky}
       Rolovani:TRolProc;
         {vyvola se pri rolovani textu, tim je mozno srolovat treba celou
          obrazovku v textovem editoru}
       MusiPlatit:TOkFunkc;
         {uzivatelska funkce vracejici, zda zadany retezec odpovida
          pozadavkum, textovy editor ji vyvola, pokud je zadan pozadavek na
          konec a v pripade, ze se jedna o Enter (ne o Escape) nebo o
          uzivatelskou klavesu, zkontroluje platnost retezce a pripadne
          uzivatele nepusti dal}
       EscN,EscR,EntN,EntR:TSetChar;  {mnozina ukoncovacich klaves}
       VracetPriChybe:Boolean;        {ma-li se vracet rizeni nastala-li
       chyba (vlastne jista situace pri editace textu) : Del na konci
       radku, BackSpace na zacatku radku atp...}
       FormatovatText:Boolean;        {ma-li se editor ukoncit, pokud text
       dojede ke svemu pravemu okraji - to dava moznost jednuduse formatovat
       text treba na sirku 60 znaku
       pokud toto neni zatrzeno, tak text pri dosahnuti sveho maxima zustane
       tak jak je a to, co se bude vkladat, bude vytlacovat konec textu}
{udelat i formatovani ve stylu AmiPro, ale to bude hodne tezke}
       Delka:integer;                 {maximalni delka textu, pokud je text
                         delsi, tak se natvrdo orezava, nic lepsiho neznam}
       PovZn:TSetChar;                {mnozina povolenych znaku v textu}
       Oddelovace:TSetChar;           {ktere znaky budou oddelovat slova}


     {vstupne/vystupni promenne :}
       EdText:string;                 {zadany a rovnez vysledny text}
       Sour,Zacina:integer;           {pozice kursoru a zacatek obrazu}
{mozna by si to chtelo pamatovat krome pocatecniho stavu vsechny pozice
 jeste dvakrat, kvuli hezkemu rolovani ve stylu Files
 !!!!! (prave naopak, zrusime to vsechno a dame jen 1 Sour a Zacina) !!!!!}

     {vystupni promenne :}
       UkAkce:byte;                   {jak to bylo ukonceno}
         {0:Escape klavesnici (neco z mnoziny Escape znaku)
          1:Enter klavesnici  (neco z mnoziny Enter znaku)
          2:Escape jinym tlacitkem mysi nez levym
          3:Enter kliknutim mysi ven
          4,5:konec pri chybe typu vyjeti kursoru (Ctrl-sipky,
              sipky, Tab, Shift-Tab, ^Home, ^End)
              (4=doleva nebo nahoru, 5=doprava nebo dolu)
              (volajici procedura se musi sama postarat o spravne
              posouzeni udalosti podle zmacknute klavesy)
          6,7,8:konec pri chybe typu mazani (BackSpace, Del, Ctrl-Y,
                Ctrl-W, ~F5|F6 (^ ne, to jen maze do zacatku/konce))
                (6=vlevo, 7=vpravo, 8=oboje (zde by ale mela volajici
                 procedura osetrit, ze ^Y je pouze smazani radku, kdezto
                 ^W je spojeni s predchozim i nasledujicim radkem))
          9:konec pri prekroceni textu pres jistou mez (vkladani znaku)
neni jeste vubec udelano
proboha NEPOUZIVAT !!!!! (nezapinat moznost formatovani)}
       Klav:word;                     {kterou klavesou to bylo ukonceno}
       MysX,MysY,MysKl:integer;       {popis mysi pri ukonceni procedury}

     {pomocne promenne (NEPOUZIVAT!!!) :}
       PuvObr:pointer;                {uchovani puvodniho obsahu (u okna)}
       _sx,_sy,_del:integer;          {souradnice editacniho okna}
       posledni:integer;              {posledni viditelny znak (kvuli
                                       proporcionalnim fontum}
{proc je integer ?}
     end;

const StandardniOddelovace:TSetChar=[' '];
      {standardni oddelovace slov, zde pouze mezera}
      StandardniPovZn:TSetChar=[#32..#255];
      {standardni povolene znaky, zde vsechny}

procedure ZadneRolovani(Zac:integer);
{standardni rolovaci procedura, nedela nic}

function MusiBytText(Ret:string):Boolean;
{standardni chybu kontrolujici funkce, vrati, ze retezec je vzdy platny}
function MusiBytCislo(Ret:string):Boolean;
{vraci, zda dany string oznacuje cislo jakehokoliv typu}
procedure NastavEdMezeCisel(Min,Max:longint);
{nastavi si do svych promennych minimalni a maximalni mez pri vstupu kvuli
 kontrole cisla funkci MusiBytInteger}

procedure InitEditor(edit:peditor);
{uchova podklad pod editor}
procedure DoneEditor(edit:peditor);
{obnovi podklad editoru}
procedure KresliObrysEditoru(edit:peditor;prvni:boolean);
{vykresli na obrazovku pozadi editoru a vypocita editacni souradnice}
procedure KresliObsahEditoru(edit:peditor;prvni:boolean;zobrazit:byte);
{procedura zobrazi na obrazovku viditelnou cast editovaneho textu}
procedure VykresleniEditoru(edit:peditor;prvni:boolean);
{vykresli na obrazovku obrys i obsah editoru}

procedure EditaceTextu(EdPar:PEditor);
{provede jednoradkovou editaci textu na obrazovce
 vstupni i vystupni parametry jsou ulozeny v ^zaznam, ktery je predan teto
 procedure jako parametr}

procedure AlokujEditor(var ed:peditor);
  {alokuje pamet pro editor}
procedure DeAlokujEditor(var ed:peditor);
  {dealokuje pamet pro editor}

{nasleduji nastavovaci procedury pro jednoduche nastaveni pozadvovanych
 parametru}
procedure NastavEdOkno(par:peditor;
                       _x,_y,_d:integer;
                       _vyzva:string;
                       _ftext,_fnadpis:pfont;
                       okno:boolean);
procedure NastavEdBarvy(par:peditor;
                        _bPopr,_bPoz,_bNadp,_bKurs,_bInv,_bOkr,_bPos:byte);
procedure NastavEdProstredi(par:peditor;
                            posuv:boolean;
                            rolov:TRolProc;
                            okfce:TOkFunkc;
                            _escn,_escr,_entn,_entr:TSetChar);
procedure NastavEdParametry(par:peditor;
                            PocInv,UrMez,PrubOr,MuzPres,
                            VracChyba,Format:Boolean;
                            MaxDel:byte;
                            Povol,Oddel:TSetChar);
procedure NastavEdObsah(par:peditor;
                        ret:string;
                        s,z:integer);



implementation
uses dos,       {gettime}
     crt,       {klavesnice}
     users;     {utils}

procedure ZadneRolovani(Zac:integer);
{standardni rolovaci procedura, nedela nic}
begin
  {procedura, ktera neprovadi vubec nic;
   pouziva se jako nejcastejsi parametr do editace textu pro rolovaci
   proceduru;
   rolovani radky si zajisti editor sam a tato procedura ma pouze zajistit
   vyrolovani ostatnich radek v pripade, ze se jedna o viceradkovy editor -
   - v tom pripade je obvykle procedura, ktera editaci textu vola, obalova
   procedura pro obecny textovy editor}
end;

function MusiBytText(Ret:string):Boolean;
{standardni chybu kontrolujici funkce, vrati, ze retezec je vzdy platny}
begin
  MusiBytText:=true
  {funkce, ktera vraci vzdy true;
   pouziva se pro kontrolu, zda je zadany retezec platny, tato vraci, ze je
   platny kazdy retezec, je vhodne pro zadani jakehokoliv retezce, pro
   zadani napr. cisla je nutno pouzit jinou funkci}

{dodelat na to kontrolni rutiny !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 udelat i jine funkce (na cisla atp...)}
end;

var EdMinCislo,EdMaxCislo:longint;
    {promenne, ktere nastavuje niz uvedena procedura}

function MusiBytCislo(Ret:string):Boolean;
{vraci, zda dany string oznacuje cislo jakehokoliv typu}
var Cis:longint;
    Chyba:integer;
begin
  Val(Ret,Cis,Chyba);
  {zkontroluj, zda je any retezec cislo}
{misto, aby vratil Chybu na 454646, udela Range Check error,
 to je ale pitomec !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 pozn. ten hajzl bp se na to nekrakne, pokud testuju longint - pak pri
       velkem cisle vrati BAD; ale pri integer to asi zkontroluje na
       longint, rekne si, ze je to O.K. a na mez pro integer to zapomene
       zkontrolovat a program se pote (myslim, ze jeste v procedure val)
       zhrouti na RangeChackError
 dekuji, ze se aspon tato chyba da eliminovat uvedenim LongIntu
 pozn. toto je genialni reseni, protoze uzivatel si ted muze zapsat
       pozadavek na jakykoliv ciselny typ uvedenim 1 funkce (tato) a
       1 procedury (NastavEdMezeCisel); podporovane typy tedy jsou :
       shortint, byt, integer, word a longint
 mozna, ze jeste nekdy neco udelam taky na real}
  if chyba=0 then
    if (Cis<EdMinCislo)or(Cis>EdMaxCislo) then
      chyba:=1;
  {zkontroluj jeste meze cisla}

  MusiBytCislo:=Chyba=0;
  {standardne si vsechno kontroluje na typ longint pro uspokojeni vsech
   pozadavku uzivatele na ciselne typy; protoze se ale cislo vraci z editoru
   zpatky v retezci, tak zadne pretypovani vadit nebude a preteceni hrozit
   nebude taky, protoze tady se u cisla krome LongInt-ovatosti zkontroluje
   i jeho minimalni a maximalni hodnota, kterou si muze uzivatel nastavit
   treba na Integer atp...}

  if chyba<>0 then
    write(#7)
    {to pipnuti uz je plne v moci dane procedury}
end;

procedure NastavEdMezeCisel(Min,Max:longint);
{nastavi si do svych promennych minimalni a maximalni mez pri vstupu kvuli
 kontrole cisla funkci MusiBytInteger}
begin
  EdMinCislo:=Min;
  EdMaxCislo:=Max
end;





procedure InitEditor(edit:peditor);
{uchova podklad pod editor}
begin
  with edit^ do
    if zobrazeniokna then begin
      NewImage(Del,HeigthOfFont(fnadpis)+HeigthOfFont(ftext)+3,PuvObr);
                                        {alokuj pamet}
      GetImage(SX,SY,                   {uloz puvodni obsah}
               Del,HeigthOfFont(fnadpis)+HeigthOfFont(ftext)+3,PuvObr);
    end
end;

procedure DoneEditor(edit:peditor);
{obnovi podklad editoru}
begin
  with edit^ do
    if zobrazeniokna then begin
      PutImage(SX,SY,PuvObr);         {obnov puvodni podklad okna}
      DisposeImage(PuvObr)            {uvolni alokovanou pamet}
    end
end;

procedure KresliObrysEditoru(edit:peditor;prvni:boolean);
{vykresli na obrazovku pozadi editoru a vypocita editacni souradnice}
var pomkonec:integer;
begin
  with edit^ do begin
    _sx:=sx;            {dej souradnice editacni oblasti}
    _sy:=sy;
    _del:=del;
    {nyni inicializuj obrazovku podle platnych pravidel}
    if ZobrazeniOkna then begin         {veci platne pro okno}
{mozna by mela byt velikost okna zadana nejak inteligentneji, vcetne
 vysky a lepsi sirky, ale to uz snad udela procedura pro editaci textu ve
 vice radcich}
      Rectangle(SX,SY,                  {nakresli ramecek barvou okraje}
                Del,HeigthOfFont(fnadpis)+HeigthOfFont(ftext)+3,bOkr);
      Bar(SX+1,SY+1,                    {vypln oblast barvou pozadi}
          Del-2,HeigthOfFont(fnadpis)+HeigthOfFont(ftext)+1,bPoz);
      LineX(SX,SY+HeigthOfFont(fnadpis)+1, {nakresli linku barvou okraje}
            Del,bOkr);

      FonColor1:=bNadp;                 {nastav aktualni barvu popredi}
      PrintText(SX+1,SY+1,Vyzva,fNadpis); {vypis nadpis k editaci}

      Inc(_SY,HeigthOfFont(fnadpis)+2); {proved standardni upravy}
      Inc(_SX);                         {souradnic a delky okna}
      Dec(_Del,2)
    end else                            {vec platna pro editacni linku}
      Bar(SX,SY,Del,HeigthOfFont(ftext),bPoz);
      {vyzva se nevypisuje, o to se stara vyolajici procedura ===> pouze
       vypln oblast barvou pozadi}

    {nyni se postrarame o pripadne posuvniky, jejichz osetreni je stejna
     v okne jako v editacni lince}
    if Posuvniky then begin
      {kreslit ted tyto posuvniky nepotrebuji, protoze je uz mam
       vyplneny pozadim a opravdovou barvou je uz vyplni zobrazovaci
       procedura}
      LineY(_SX+4,_SY,HeigthOfFont(ftext),bOkr);
      LineY(_SX+_Del-5,_SY,HeigthOfFont(ftext),bOkr);
      {pouze prikreslim 2 cary barvou okraje, ktere oddeluji posuvniky
       od textu}
      Inc(_SX,5);                       {pouze uprav na cas souradnice}
      Dec(_Del,10)                      {a urizli jsme cast mista pro text}
    end;

    {tvar kursoru ted nastavovat nemusim (jako v textovem rezimu), to si
     vybira primo az zobrazovaci procedura na kursor}
    if Prvni then begin                 {pocita se 1.klavesa jako mazaci ?}
      PomKonec:=MinInteger(WidthOfTextPart(ftext,EdText,Zacina,
        length(edtext)-zacina+1,false),_Del);
                                        {vypocitej rozsah zabarveneho textu}
      Bar(_SX,_SY,PomKonec,HeigthOfFont(ftext),bInv)
    end
  end
end;

procedure KresliObsahEditoru(edit:peditor;prvni:boolean;zobrazit:byte);
{procedura zobrazi na obrazovku viditelnou cast editovaneho textu

 provede to tak, ze po pozici, po kterou se text nezmenil, ponecha
 v puvodnim stavu i obrazovku, pretiskne pozadim zbytek a pripise tam
 zmeneny text
 neprekresluje se tedy znovu cele okno pri zmene 1 znaku nekde na konci
 ale pouze jeho cast
 procedura nezavadi prekreslovani stylem GetImage&posun&PutImage, protoze
 ten se vyplati pouze u presunu velkych bloku (u procedury Files), u pouze
 nekolika malo znacich se to nevyplati jak velkym spotrebovanym casem, tak
 i velkou slozitosti algoritmu}
var dosud:word;                  {pocitadlo sirky retezce}
    barva:byte;                  {barva ruznych objektu}
    pulvysky:byte;               {polovina vysky znaku zaokrouhlena dolu}
begin
  if zobrazit=0 then
    exit;
    {nenastala-li zadna zmena, konec}

  with edit^ do begin
    {promenna posledni se aktualizuje po kazdem nactenem znaku z klavesnice}
    dosud:=widthoftextpart(ftext,edtext,zacina,zobrazit-zacina,
      {mezery}true);
    {nastavit ukazatel tam, odkud se ma zobrazovat}

    if not Prvni then
      bar(_sx+dosud,_sy,_del-dosud,heigthoffont(ftext),bpoz);
      {poprve je dialog vyplnen zvyraznenou barvou - tu nesmime smazat
       jindy naopak premazeme puvodni obsah barvou pozadi}
                                 {priprav prazdne pozadi pro tisk textu}
    FonColor1:=bPopr;
      {text tiskneme barvou popredi}
    PrintText(_sx+dosud,_sy,copy(edtext,zobrazit,posledni-zobrazit+1),ftext);
      {vytiskneme tam vypocitanou oblast textu, pripadne doplnujici mezery
       se netisknou, nebot se narazi na konec retezce}

    {pokud je to povoleno, zobrazime jeste posuvniky k textu}
    if Posuvniky then begin
      if Zacina>1                          {pokracuje text doleva ?}
        then barva:=bPos                    {ano, barva posuvniku}
        else barva:=bPoz;                   {ne, barva pozadi}
      pulvysky:=heigthoffont(ftext) div 2;
      if zobrazit=zacina then              {1 posuvnik vlevo}
        {Bar(_SX-5,_SY,4,HeigthOfFont(ftext),barva);}
        begin
          line(_SX-2,_SY,
               _SX-5,_SY+pulvysky-1,barva);
          line(_SX-2,_SY+pulvysky*2-2,
               _SX-5,_SY+pulvysky-1,barva){;
          linex(_SX-5,_SY+pulvysky-1,4,barva)}
        end;
        {tento posuvnik muzeme zobrazit pouze, pokud se prekresluje cele
         okno, pokud se prekresluje pouze treba od poloviny, logicky
         pouze nastalo bud vkladani nebo mazani textu a to ovlivni pouze
         pravy posuvnik}

      if Length(EdText)>posledni            {pokracuje text doprava ?}
        then barva:=bPos
        else barva:=bPoz;                   {1 posuvnik vpravo}
      {Bar(_SX+_Del+1,_SY,4,HeigthOfFont(ftext),barva)}
      line(_SX+_Del+1,_SY,
           _SX+_Del+4,_SY+pulvysky-1,barva);
      line(_SX+_Del+1,_SY+pulvysky*2-2,
           _SX+_Del+4,_SY+pulvysky-1,barva){;
      linex(_SX+_Del+1,_SY+pulvysky-1,4,barva)}
        {pro tento posuvnik bohuzel zadny jednoduchy zpusob zjisteni zmeny
         neexistuje
         jedina moznost je evidovat zmeny promennych Sour a Zacina}
    end
  end
end;

procedure VykresleniEditoru(edit:peditor;prvni:boolean);
{vykresli na obrazovku obrys i obsah editoru}
begin
  KresliObrysEditoru(edit,prvni);
  with edit^ do
    posledni:=Zacina+charstowidth(ftext,edtext,zacina,_del,true)-1;
  KresliObsahEditoru(edit,prvni,edit^.zacina)
end;





procedure EditaceTextu(EdPar:PEditor);
{procedura, ktera provadi vlastni radkovou editaci,
 parametry editace jsou ulozeny v parametru EdPar^}
var Prvni:Boolean;                      {je-li dana klavesa zmackla jako 1.}
    Zobrazit:byte;                      {nastala zmena ? ===> zobrazit !}
      {0...nezobrazovat, nenastala zmena
       else oznacuje pozici (od Zacina vyse), od ktere se zmena udala (aby
            se nemuselo znovuprekreslovat cele okno)}
    CtenyZnak:integer;                  {precteny znak z klavesnice
                                         v rozsirenem kodu (0..511)}
{udelat stejne jako ve Files atp.. promennou Akce, nikoliv CtenyZnak
 (musim spoustu z techto promennych vyhodit a nahradit je 1 promennou
 a tou budepromenna Akce)}
    mkey,mx,my:integer;
    {posledni, pak pracovni a pak aktualni pozice a stav tlacitek mysi
     je to kvuli predavani posledni pozice mysi zpet, pouze se vyhradi
     UkAkce a stav mysi vyplni procedura Finalizace podle techto parametru
!!!!!!!!!!!!!!!!! take to bude pozdeji proto, ze se tam zapamatuje posledni
                  stav mysi a priste se novy stav s timto stavem porovna,
                  cimz bude mozno delat efekty typu D&D (PPP), 2klik, atp...}
    Vlajky:byte absolute $40:$17;       {zde je ulozen stav predradovacu
                                         klavesnice - testuji z neho Insert}
    StaryText:string;                   {puvodne zadane hodnoty pro editaci}
    StarySour,StaryZac:integer;           {(kvuli Restore klavesou Ctrl-R)}

procedure ZobrazText;
{obalova procedura pro zobrazeni textu v editacnim okne}
begin
  KresliObsahEditoru(edpar,prvni,zobrazit)
end;

function PoziceKursoru:integer;
{vraci pozici kursoru na obrazovce, ktera je vlastne shodna s opravdovou
 pozici kursoru az na 1 vyjimku, jestlize je kursor za maximalni delkou
 textu - pak se opravdu chova, jakoby byl za textem, ale zobrazuje se na
 poslednim znaku}
begin
  with EdPar^ do
    if Sour>Delka
      then PoziceKursoru:=Delka
      else PoziceKursoru:=Sour
  {pokud je text dlouhy presne tolik, kolik se vleze do limitu a kursor
   je na konci, pak je totiz definovana jeste 1 pozice kursoru -
    - za textem
   aby ale nebyl kursor zobrazen tam, kde uz nelze vypsat znak, zobrazi
   se stejne jako by byl na poslednim znaku, tj. tato 1 (opticka) pozice
   oznacuje 2 mozne pozice kursoru
   pri te prvni se jeste muze vlozit znak (vysune ten, co je tam ted),
   klavesy BackSpace a Delete provedou to, co se podle obrazovky
   provest ma a muzeme dat sipku doprava pro skok na nasledujici pozici,
   o kterem uz nic z tohoto neplati, muzeme dat pouze sipku doleva nebo
   jakykoliv jiny pohyb}
end;

function KrajObjektu(Smer:shortint):integer;
{funkce vrati pozici v editovanem radku, na ktere zacina nebo konci objekt,
 na kterem je kursor, vyuziva definovane mnoziny oddelovacu;
 stoji-li kursor na oddelovaci, vrati kraj oddelovacu,
 stoji-li na slove, vrati kraj slova;
 pozice je omezena delkou textu (vracena hodnota je 1..Length(EdText))}
var Pozice:integer;
    HledameOddelovac:Boolean;
begin
  with EdPar^ do begin
    Pozice:=Sour;                      {vezmi akutalni pozici}
    if (Pozice>=1)and(Pozice<=Length(EdText)) then begin
      HledameOddelovac:=not(EdText[Pozice] in Oddelovace);

      {je-li kursor mimo text, o okrajich slova ani neuvazujeme,
       jinak pokracujeme hledanim kraje}
      while (Pozice+Smer>=1)and(Pozice+Smer<=Length(EdText))and
            ((EdText[Pozice+Smer] in Oddelovace) xor HledameOddelovac) do
        Inc(Pozice,Smer);
      {Skoncime nalezenim jine kategorie znaku nez jsme zacali
       (oddelovace kontra slovo) ---> mame kraj dane oblasti,
       nebo pri prekroceni rozsahu editovaneho textu}
    end;
    {pokud je kursor nekde mimo text, nepokousejme se okraj slova ani
     hledat}
    KrajObjektu:=Pozice                 {vrat pozici kraje objektu}
  end
end;

procedure UriznoutKoncoveMezery(Ohled:Boolean);
{urizni koncove mezery, vola se jen pokud je orezavani uzivatelem povoleno
 Ohled znamena, zda se ma brat ohled na pozici kursoru - to je dulezite,
   pokud je zapnuta (sice malo prvadepodobna) volba PrubezneOrezavat
   a zaroven NesmiPresahovat - pak se koncove mezery delaji mezernikem
   a mazou se treba jenom tim, ze dam Home}
begin
  with EdPar^ do begin
    while (EdText[Length(EdText)]=' ')and
          (not Ohled or (Length(EdText)>=Sour)) do
          {pokud se nemusi brat ohled na kursor, jenom mazeme, pokud ano,
           zastavime se, pokud je delka textu uz mensi nez pozice kursoru}
      Dec(EdText[0]);
      {naraznik na podteceni delky textu delat nemusime, rozhodne se to
       nejpozdeji zarazi na nulovem textu podminkou EdText[0]=#32, coz bude
       false}
    if not Ohled and not MuzePresahovat and (Sour>Length(EdText)+1) then
      Sour:=Length(EdText)+1
      {nemame-li brat ohled, tj. jde o zaverecne odrezani mezer
       a kursor nesmi presahovat pres text,
       pak zkontroluj presahovani a pripadne ho vrat tesne za text
       (je to udelano kvuli neohlaseni udalosti cislo 5 - vyjeti za text)}
  end
end;

procedure KontrolaPreplneni;
{zkontroluj maximalni povolenou delku retezce, pripadne ho natvrdo orizni}
begin
  with EdPar^ do begin
    if Length(EdText)>=Delka then begin {je-li text delsi nebo stejne dlouhy}
      EdText[0]:=char(Delka);             {tak, jak je povoleno, orizni ho}
      if UkAkce=255 then                {pokud uz neni nejaka chyba nastavena,}
        UkAkce:=9                         {ohlas chybu preteceni textu}
{ono se totiz formatuje, ze je text za moznou delkou a zaroven je tam
 i kursor a zaroven se vlozil znak !!!!!

 je to dobra podminka ?????
 podivat se i jinam na podminky
 treba to udelat do procedury jako dejobr atp...}
    end;
    {pokud nemame prikazano formatovani textu, tak ho pouze orizneme,
     jinak take ohlasi chybu prekroceni kapacity textu a nadprocedura
     muze automaticky prejit na dalsi radek
     pri 2. pripade se nic neorizne proto, ze se tato procedura vyvola
     uz pri rovnosti delek, kdy se orizne 0 znaku, ale uz ted se ohlasi
     konec procedury; k dalsimu spusteni tedy v tomto pripade nedojde
     (v 1. pripade ano pri vlozeni dalsihoznaku)
     jedina moznost, kdy tato procedura text skutecne orizne, bude zacatek
     editace pri inicializacnim oriznuti pripadne dlouheho textu}
    if PrubezneOrezavat then
      UriznoutKoncoveMezery(not MuzePresahovat)
    {procedura jeste pripadne prubezne orizne pripadne koncove mezery}
  end
end;

{procedura aplikuje kontrolu rozsahu na pozici (kursoru) Index, pripadne
 tuto pozici co nejvhodneji zmeni}
procedure KontrolaPreteceni;
begin
  with EdPar^ do begin
    if Sour<1 then begin               {je-li pozice zaporna,}
      Sour:=1;                           {priradit pozici 1}
      if not MuzePresahovat then        {nesmi-li kursor pretect, ohlas}
        UkAkce:=4                         {chybu vyjeti vlevo}
    end;
    if not MuzePresahovat and (Sour>Length(EdText)+1) then begin
      {jestlize nesmi kursor presahovat text a presahuje, presun ho zpet}
      Sour:=Length(EdText)+1;
      UkAkce:=5
    end;
{je jeste moznost tam pripsat krasne mezery, ale to se mi nelibi, to at
 radsi kursor nesmi vyjet tak, jak vsude jinde (co kdyz neni mezera
 povolena atp... viz. take vkladani znaku)
 a taky bych to doplnoval spatne, pokud by to vyjelo pres pozici delka}
    if Sour>Delka+1 then               {prekrocila-li maximalni delku+1,}
      Sour:=Delka+1                      {prirad tuto delku}
      {kursor totiz muze presahovat pres delku, ale jenom na delka+1, ale
       zobrazuje se porad na pozici delka}
{nemam sem taky zapojit nejakou kontrolu ???}
  end
end;

procedure KontrolaScrollovani;
{procedura zkontroluje, zda je kursor ve viditelnem vyrezu, pripadne
 tento vyrez co nejvhodneji posune}
var PomZacatek:integer;
begin
  with EdPar^ do begin
    PomZacatek:=Zacina;                {zapamatuj si puvodni vyrez}

{pozn. scrolluji o 1/6 editacni radku, protoze znak po znaku by sice bylo
 efektnejsi, ale mohlo by to byt pomale, i kdyz ne zas tak moc jako u files
 mozna bych tam ale pro sjednoceni mohl dat 1/3}
    if PoziceKursoru<Zacina then       {je-li kursor pred vyrezem}
      Zacina:=PoziceKursoru-((Posledni-Zacina+1) div 6){+1};
{ta +1 tam nemuze byt stejne jako u Files, protoze to blbne v malym okne}
                                        {posun vyrez vice vlevo}
    if Zacina<1 then                   {je-li pocatek vyrezu zaporny}
      Zacina:=1;                       {prirad mu 1}

    posledni:=Zacina+charstowidth(ftext,edtext,zacina,_del,true)-1;
    {zjistime, kolik znaku se do daneho prostoru vejde vcetne
     doplnujicich mezer a priradime si to do promenne posledni;
     toto se musi aktualizovat po kazdem prectenem znaku, abychom meli
     vzdy pojem o rozmeru okna}

    if PoziceKursoru>Posledni then      {je-li kursor za vyrezem}
      Zacina:=PoziceKursoru-(((Posledni-Zacina+1)*5) div 6{-1});
{stejne tak tam nemuze byt ani -1, taky to blbne v malym okne, stejny duvod
 =====> jak tady, tak i ve Files to bude rolovat doprava (dolu) o min znaku
        nez doleva (nahoru)
 ted uz je to O.K.}
                                        {posun vyrez vice vpravo}
{pri proporcionalnim fontu, ale neni zajisteno, ze kursor bude ted po
 uprave viditelny !!!!!
 pozn. myslel jsem si, ze ta poznamka je jen tak, ale ona se opravdu
 projevuje !!!!!}
    if Zacina<>PomZacatek then begin   {zmenila-li se nejak pozice vyrezu,}
      Rolovani(Zacina);                  {vyvolej proceduru pro rolovani}
{mozna sem dat jako 2. parametr i puvodni pozici pred rolovanim}
      Zobrazit:=Zacina;                  {a nechej prekreslit cele okno}
      {zde nedavame funkci DejZobr, protoze by se pri rolovani vpravo
       nechala puvodni mensi hodnota a zacalo by se to prekreslovat
       od nesmyslne pozice}
      posledni:=Zacina+charstowidth(ftext,edtext,zacina,_del,true)-1
      {znovu zjistime, kolik znaku se do daneho prostoru vejde vcetne
       doplnujicich mezer a priradime si to do promenne posledni
       (musime to bohuzel zjistovat dvakrat, abychom meli v kazde chvili
       jistotu korektniho vysledku)}
    end
  end
end;

procedure Inicializace;
{procedura provede pripravne akce nutne ke spusteni editoru}
begin
  with EdPar^ do begin
    PushMouse;                          {nech zmizet mys}
    MouseSwitchOff;
    OverFontColor:=255;                 {nastav tuto barvu pro cely editor}
    InitEditor(edpar);                  {vykresli obrazovku editoru}
    KresliObrysEditoru(edpar,pocatecniinverze);

    StaryText:=EdText;                  {vstupni hodnota textu}
    StarySour:=Sour;                      {pocatecni pozice a zacatek}
    StaryZac:=Zacina;

    KontrolaPreplneni;                  {aplikuj vsechny tri kontroly}
    KontrolaPreteceni;
    KontrolaScrollovani;                {zde se nastavi promenna posledni}

    Prvni:=PocatecniInverze;            {bude to inverzne ?}
    UkAkce:=255;                        {zatim neni duvod k ukonceni editoru}

    Zobrazit:=Zacina;                   {zobrazit cele editacni okno}
    ZobrazText                          {zobrazime vyrobeny text}
  end
end;

procedure Finalizace;
{procedura zakonci uzivani editoru a uklidi po nem}
begin
  with EdPar^ do begin
    Klav:=CtenyZnak;
    MysX:=mx;
    MysY:=my;
    MysKl:=mkey;
    {pri ukonceni vratime, ktery znak byl stisknut naposledy vzdy, i kdyz
     to ma smysl pouze pri ukonceni klavesou
     stejne tak vratime i posledni stav mysi, i kdyz ten je aktualni pouze
     pri ukonceni mysi

     tim usetrime praci vykonne rutine, ktera nyni jen nastavi priznak
     ukonceni editoru a o zbytek se postarame my}

    if OriznoutMezery then begin
      UriznoutKoncoveMezery(false);     {pripadne uriznuti koncovych mezer}
{????? myslim, ze po orezani koncovych mezer je upraveni pozice kursoru
       podle stavu promenne MuzePresahovat opravnena vec, ale nevim ?????}
      KontrolaPreplneni;                {zn. jistota je jistota}
      KontrolaPreteceni;                {po uriznuti uprav pozici kursoru}
      KontrolaScrollovani
    end;

    {mazat kursor po sobe nemusime, protoze jsme ho jenom emulovali
     (ale i s blikanim !!!) behem editace}

    DoneEditor(edpar);                  {vymaz po editoru}
    PopMouse                            {obnoveni stavu mysi}
  end
end;

procedure CekejNaUdalost;
{procedura ceka na stisk klavesy nebo tlacitka mysi, analyzuje udalost
 a ulozi o tom zpravu do promenne Akce}
var vidit:boolean;                        {je kursor prave viditelny ?}
    pozkurs,vyskurs,sirkurs:integer;      {parametry kursoru}
    i,x:integer;


function MaBytKursor:Boolean;
{vrati, zda ma byt kursor v danem case viditelny}
var h,m,s,s100:word;
begin
  gettime(h,m,s,s100);
  mabytkursor:=s100>50
  {perioda = 1 sekunda
   kursor se lame v 1/2 teto periody, tj. kazdou 1/2s}
end;

procedure AktualizujKursor;
{procedura zobrazi nebo necha zmizet kursor v zavislosti na danem case
 vyvolani a na tom, jestli uz je resp. neni zobrazen}
var barva:byte;
begin
  if vidit=mabytkursor then
    exit;
    {jestlize ma kursor zustat tak, jak je, konec}
  vidit:=not vidit;                   {jinak zmen jeho priznak viditelnosti}

  with EdPar^ do
    if Prvni and (PoziceKursoru<=Length(EdText))        {pri praci s barvou}
      then barva:=bInv                              {pozadi se bere v uvahu}
      else barva:=bPoz;                          {i pocatecni inverze textu}

  mouseswitchoff;                             {musime na chvili vypnout mys}
  with edpar^ do
    if vidit then                    {ma-li byt kursor viditelny, pretiskni}
      replacecolor(pozkurs,_sy+heigthoffont(ftext)-vyskurs,   {barvu pozadi}
                   sirkurs,vyskurs,                         {barvou kursoru}
                   barva,bKurs)
    else begin                      {ma-li kursor zmizet, pretiskni policko}
      bar(pozkurs,_sy+heigthoffont(ftext)-vyskurs,           {barvou pozadi}
          sirkurs,vyskurs,
          barva);
      FonColor1:=bPopr;                                        {barva textu}
      if PoziceKursoru<=length(EdText) then             {a vypis znak znovu}
        printchar(pozkurs,_sy,byte(EdText[PoziceKursoru]),ftext)
    end;
  mouseswitchon                                           {opet zapneme mys}
end;

procedure VypniKursor;
{vymaze takto emulovany kursor z obrazovky}
begin
  MouseSwitchOff;                             {vypneme viditelnost mysi}

  with edpar^ do begin
    if vidit then begin                         {zmizet kursor}
      bar(pozkurs,_sy+heigthoffont(ftext)-vyskurs,           {barvou pozadi}
          sirkurs,vyskurs,
          bPoz);
      FonColor1:=bPopr;                                        {barva textu}
      if PoziceKursoru<=length(EdText) then             {a vypis znak znovu}
        printchar(pozkurs,_sy,byte(EdText[PoziceKursoru]),ftext)
    end;

    if prvni then begin                  {vymazeme i pripadny inverzni text}
      bar(_sx,_sy,_del,heigthoffont(ftext),bpoz);
      zobrazit:=Zacina;
      {vykresli se normalni pozadi a nastavi se, ze se ma prekreslit
       cely text znovu
       nastavovat prvni na false nebudeme, protoze to jeste potrebuje vedet
       procedura za nami a az ta to udela}
    {necha to tak ramecek, ale ten tam nezustane, protoze ve vyvolavanem
     cyklu se zavola i procedura pro zobrazeni textu, ktera hned pozadi
     pretiskne}
    end
  end
end;

procedure posuneditacnihookna;
{posune editacni oblast podle pohybu mysi}
var mys:pointer;
    i:byte;
begin
  with edpar^ do begin
    pushmouse;
    mouseswitchoff;
    newimage(del,heigthoffont(fnadpis)+heigthoffont(ftext)+3,mys);
    getimage(sx,sy,del,heigthoffont(fnadpis)+heigthoffont(ftext)+3,mys);
    putimage(sx,sy,puvobr);
    {obnovi pozadi a zapamatuje si dialog a mys}

    mouseon(mx-sx,my-sy,mys);
    newmousearea(mx-sx,my-sy,320-del,
      200-(heigthoffont(fnadpis)+heigthoffont(ftext)+3));
    repeat
    until mousekey<>0;
    {nyni dialogem pohybuje jako mysi}

    inc(sx,mousex-mx);
    inc(sy,mousey-my);
    inc(_sx,mousex-mx);
    inc(_sy,mousey-my);
    inc(pozkurs,mousex-mx);
    {docasna zmena souradnic}

    mouseswitchoff;
    getimage(sx,sy,del,heigthoffont(fnadpis)+heigthoffont(ftext)+3,puvobr);
    putimage(sx,sy,mys);
    disposeimage(mys);
    {obnovi na obrazovce dialog na novem miste vcetne zapamatovani
     noveho pozadi}

    repeat
    until mousekey=0;
    newmousearea(0,0,320,200);
    popmouse
    {obnovi stav mysi}
  end
end;

begin
  with edpar^ do begin
    pozkurs:=_sx+widthoftextpart(ftext,edtext,zacina,pozicekursoru-zacina,
      true);

    if PoziceKursoru<=length(EdText)
      then sirkurs:=widthofchar(ftext,EdText[PoziceKursoru])          {znak}
      else sirkurs:=widthofchar(ftext,' ');         {mezera za koncem textu}
      {spocitej sirku kursoru}

    if (Vlajky and $80)<>0
      then vyskurs:=heigthoffont(ftext) div 4                       {insert}
      else vyskurs:=heigthoffont(ftext);                         {overwrite}
      {spocita se velikost kursoru}

    vidit:=false;                             {na pocatku neni kursor videt}
    MouseSwitchOn;                                {zapneme viditelnost mysi}

    {starou pozici kursoru si v teto verzi jeste nepamatuji, ponevadz ji
     na nic nepotrebuji, vystacim si i bez ni}

{tady jsem skoncil s upravami do KRASNA !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!}
    zobrazit:=0;  {to priradime my, protoze sami muzeme nastavit 1, kdyz
                   zmackneme klavesu a text byl na pocatku inverzni}
    repeat
      while not keypressed do begin
        aktualizujkursor;
        if mousekey<>0 then begin
          mkey:=mousekey;               {vezmeme si tlacitka mysi}
          repeat
          until mousekey<>mkey;         {pockame, az uzivatel odmackne
                                tlacitko, nebo zmackne neco jineho atp.}
          mx:=mousex;          {nyni si vezmeme pozici mysi, abychom }
          my:=mousey;                       {odmackli to, kde skonci}

          if mkey<>1 then begin         {neni-li to leve tlacitko, Escape}
            ukakce:=2;                  {nastavim Escape, zbytek nastavi}
            vypnikursor;                  {finalizacni rutina, analogicky}
            exit                          {je to osetreno i o 20 radku dale}
          end;

          x:=byte(posuvniky)*5;
          if not InBar(mx,my,_SX-x,_SY,_Del+2*x,heigthoffont(ftext)) then
            {je-li mimo editacni oblast + posuvniky}
            if zobrazeniokna then begin
              {pri zobrazeni okna se pri kliku na nadpis presouva
               editacni oblast, jinak se nedeje nic}
              if inbar(mx,my,sx,sy,del,
                   HeigthOfFont(fnadpis)+HeigthOfFont(ftext)+1) then
{                posuneditacnihookna};
              continue
            end else
              {jinak se zkontroluje text, je-li spravny, odevzda se enter
               mysi, jinak se nic nedeje}
              if musiplatit(edtext) then begin
                ukakce:=3;
                vypnikursor;
                exit
              end else
                continue;

          if InBar(mx,my,_SX,_SY,_Del,heigthoffont(ftext)) then begin
            {je-li to v okne pro text (ne na posuvniku)}
            i:=zacina+CharsToWidth(ftext,edtext,zacina,mx-_sx,
              true{doplnit mezery});
            {najdi znak, kam to padlo}
            vypnikursor;
            Sour:=i;             {pouze to premistime a delame jakoby nic}
            ctenyznak:=0;
            exit
          end else
          {jinak je to na posuvniku}

          {jinak je to na oddelovaci}
          if mx<_sx-1 then
            ctenyznak:=15+256              {levy ===> shift-tab}
          else if mx>_sx+_del then
            ctenyznak:=9                   {pravy ===> tab}
          else
            continue;                      {jinak je to na delici care}

          vypnikursor;                     {konec po obslouzeni posuvniku}
          exit
        end
      end;

      {ted jsme konecne precetli znak
       (pokud jsme uz davno nevyskocili z procedury)}
      CtenyZnak:=byte(ReadKey);             {nacti klavesu}
      if (CtenyZnak=0) and KeyPressed       {je-li rozsirena}
        then CtenyZnak:=byte(ReadKey)+256      {nacti znovu}

    until true;                  {to je cyklus, aby to cekalo na
                                  DOBROU klavesu, ale to zde neni pouzito}
    vypnikursor
  end; {end of with}
end;

procedure dejzobr(x:integer);
{da, ze se ma zobrazit text, ale kontroluje, aby se zobrazily opravdu
 vsechny pozadavky}
begin
  if (x<zobrazit)or(zobrazit=0) then
    zobrazit:=x
end;

{procedura provede zmeny v textu podle zmackle klavesy
 ulozene v promenne Znak}
procedure ZpracujZnak;
var Levy,Pravy:integer;
begin
  with EdPar^ do begin
    if UkAkce=255 then
      {neukoncilo-li se mezitim uz mysi, podivame se na zmacknutou klavesu}
      if ctenyznak<256 then                 {testuj, zda se ma koncit}
        if char(CtenyZnak) in EscN
          then UkAkce:=0
          else if char(CtenyZnak) in EntN
                 then UkAkce:=1
                 else
      else
        if char(CtenyZnak) in EscR
          then UkAkce:=0
          else if char(CtenyZnak) in EntR
                 then UkAkce:=1
                 else;
        {nastav UkAkce, je-li Escape nebo Enter klavesa}
    {nyni je nastaven konec jak pri zmacknute Enter, tak i u Escape,
     prestoze u Enter neni dosud provedena kontrola; tim se zaruci, ze
     se nebude na tuto ukoncovaci klavesu prochazet normalni prikaz case}

    {jestlize nenastal nejak konec, podivej se, co bylo zmacknuto,
     protoze jinak by jeste mohla pripadna reakce na klavesu dany text
     jeste pokazit}
    if UkAkce=255 then begin

    if ctenyznak<256 then                  {zakladni klavesy}
      case byte(CtenyZnak) of
         8:if Sour>1 then begin            {BackSpace}
             Dec(Sour);
             Delete(EdText,Sour,1);
             dejzobr(Sour)                 {od ceho zobrazit}
           end else
             UkAkce:=6;
             {jsme-li na zacatku, muze to znamenat pozadavek na zruseni
              mezery mezi 2 radky, vrat chybu, klavesu nastavi dalsi rutina}
        25:begin                           {Ctrl-Y}
             EdText:='';
             Sour:=1;
             dejzobr(1);                   {od ceho zobrazit}
             UkAkce:=8
             {timto jsme radek nejenom vymazali, ale i vyjmuli
              a to muze byt potreba oznamit vys}
           end;
        23:begin                           {Ctrl-W}
             {najdi levy kraj slova nebo oddelovacu}
             Levy:=KrajObjektu(-1);
             {najdi pravy kraj slova nebo oddelovacu}
             Pravy:=KrajObjektu(1)+1;
             {jestlize jsme za slovem na oddelovaci, prejdi jeste
              na zacatek dalsiho slova - protoze pri mazani oddelovacu se
              vymazou pouze tyto, kdezto pri mazani slova se vymazou
              i nasledujici oddelovace}
             while (Pravy<=Length(EdText))and(EdText[Pravy] in Oddelovace) do
               Inc(Pravy);
             case byte((Levy=1)and(EdText[Levy] in Oddelovace))+
                  byte(Pravy>Length(EdText))*2 of
                {testuj, jestli jsme nekde nevymazali oddelovac 2 radku
                 - zleva se maze pouze pri smazani pocatecnich oddelovacu
                 - zprava se maze vzdy pri prekroceni hranice textu, protoze
                   pri mazani oddelovacu se smaze zaverecne enter a je to
                   spojeni a pri mazani slova se mazou i oddelovace za nim,
                   takze vysledek je stejny pro oba pripady}
               0:;                  {nesmazalo se nic}
               1:UkAkce:=6;         {mazani vlevo}
               2:UkAkce:=7;         {mazani vpravo}
               3:UkAkce:=8;         {mazani obou stran}
             end;

             Delete(EdText,Levy,Pravy-Levy);
             Sour:=Levy;
             dejzobr(Sour)
           end;
        18:begin                          {Ctrl-R}
             EdText:=StaryText;
             sour:=StarySour;
             zacina:=StaryZac;
             dejzobr(Zacina)
           end;
         9:Inc(Sour,8);                    {Tabulator}
           {preteceni za text zkontroluje jina procedura}
      end else                        {rozsirene klavesy}

      case byte(CtenyZnak-256) of
        98:begin                          {Ctrl-F5}
             Delete(EdText,1,Sour-1);     {pouze maze do zacatku radku,}
             Sour:=1;                       {nikdy radky nespojuje}
             dejzobr(1)
           end;
        99:begin                          {Ctrl-F6}
             if Sour<=Length(EdText) then {take pouze maze do konce radku}
               EdText[0]:=char(Sour-1);     {a radky nikdy nespojuje}
             dejzobr(Sour)
           end;
       108:begin                          {Alt-F5}
             {najdi levy okraj aktualniho objektu (slova nebo oddelovacu)}
             Levy:=KrajObjektu(-1);
             if (Levy=1)and(EdText[Levy] in Oddelovace) then
               UkAkce:=6;
               {spojeni s prechazejicim radkem; dokumentace u ^W}
             Delete(EdText,Levy,Sour-Levy);
             Sour:=Levy;
             dejzobr(Sour)
           end;
       109:begin                          {Alt-F6}
             {najdi pravy okraj aktualniho objektu (slova nebo oddelovacu)}
             Pravy:=KrajObjektu(1)+1;
             {jestlize jsme za slovem na oddelovaci, prejdi jeste na
              zacatek dalsiho slova}
             while (Pravy<=Length(EdText))and(EdText[Pravy] in Oddelovace) do
               Inc(Pravy);
             if Pravy>Length(EdText) then
               UkAkce:=7;
               {spojeni s nasledujicim radkem; dokumentace u ^}
             Delete(EdText,Sour,Pravy-Sour);
             dejzobr(Sour)
           end;
        83:if Sour>Length(EdText) then     {Delete}
             {je-li kursor na konci radku, vrat chybu}
             UkAkce:=7
           else begin
             {jinak smaz aktualni znak}
             Delete(EdText,Sour,1);
             dejzobr(Sour)
           end;
        {82:Insert meni tvar kursoru nezavislo, nemusime se o to starat}
        15:Dec(Sour,8);                    {Shift-Tabulator}
        75:Dec(Sour);                      {Vlevo}
        77:Inc(Sour);                      {Vpravo}
           {o vyjeti z textu se postara jina procedura (vc. ohlaseni chyby)}
        71:Sour:=1;                        {Home}
        79:
Sour:=Length(EdText)+1;         {End}
{neodstrihne mezery u prubezneorezavat+nemuzepresahovat}
       119:if VracetPriChybe               {Ctrl-Home}
             then UkAkce:=4                  {ma-li se vracet chyba, vrat ji}
                  {protoze v editoru je ^Home presun na vrch obrazovky}
             else Sour:=Zacina;              {jinak posun kursor}
       117:if VracetPriChybe               {Ctrl-End}
             then UkAkce:=5                  {ma-li se vracet chyba, vrat ji}
                  {protoze v editoru je ^End presun na spodek obrazovky}
             else Sour:=Posledni;            {jinak posun kursor}
       115:if Sour=1 then                  {Ctrl-Vlevo}
             UkAkce:=4
             {jsme-li na zacatku radku, je to automaticky chyba
              tato vyhybka je tu proto, aby se mohlo bezpecne dat Dec(Sour)}
           else begin
             if Sour>Length(EdText) then
               Sour:=Length(EdText);
               {kontrola, zda neni daleko za slovem}
             Dec(Sour);
             {jsi-li uz na kraji slova, dostanes se pred nej a bude
              automaticky hledat dalsi, jinak se pouze priblizis okraji
              slova ---> zadne komplikace, naopak zjednoduseni}
             Levy:=KrajObjektu(-1);
             {vyhledej kraj objektu, na kterem stojis}
             if (EdText[Levy] in Oddelovace)and(Levy<>1) then begin
               Sour:=Levy-1;
               Levy:=KrajObjektu(-1)
             end;
             {ted jsme bud na zacatku slova ---> nasli jsme to, co hledame,
              nebo na 1.oddelovaci mezi slovy ---> musime hledat dal (pouze
              pokud uz nejsme na zacatku radku)}
             if (Levy=1)and(EdText[Levy] in Oddelovace) then
               UkAkce:=4;
               {vyjeti z textu doleva - kursor skonci na prvnim
                oddelovaci na radku}
             Sour:=Levy
             {vrat nalezenou hodnotu}
           end;
       116:begin                           {Ctrl-Vpravo}
             Sour:=KrajObjektu(1)+1;
             {nalezni znak za pravym okrajem aktualniho objektu;
              kursor je ted bud na oddelovaci za aktualnim slovem,
              nebo na zacatku hledaneho slova;
              nebo je za koncem textu}
             if (Sour<=Length(EdText))and(EdText[Sour] in Oddelovace) then
               Sour:=KrajObjektu(1)+1;
             {jestlize jsme byli na oddelovaci a nebyli za koncem textu,
              najde to kraj dalsiho slova;
              nebo je za koncem textu}
             if Sour>Length(EdText) then
               UkAkce:=5
               {je-li za koncem textu, je to vyjeti z textu doprava;
                to plati v obou pripadech (jak v pripade, ze konci text
                slovem, tak i pri ukonceni oddelovacem)}
           end
      end;

    {jinak je asi pozadano o vkladani textu}
    if (CtenyZnak<256)and(char(CtenyZnak) in PovZn) {povoleny znak ?}
    then begin
      if Prvni then begin              {po 1.klavese se maze text i pozice}
        EdText:='';
        Sour:=1;
        Zacina:=1
      end;
{!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
tady jsem skoncil s revizi klaves pro ukonceni s chybou
.jedina nejasnost je v zapsani znaku z klavesnice do
textu, kde to jeste musim dodelat, ale to uz spada
do oblasti formatovani textu
===> konec editoru pri nalezeni chyby je dodelan
     precizne, lze ho uz pouzivat
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!}

{nema to prejit na dalsi radek ??????????????????????}
      {if sour<=delka then} begin
{je-li kursor za maximalni povolenou delkou, tak se nikdy nic
 nevklada, tam se ani nesmi nic dat}
        {je-li za koncem textu a chce vlozit znak, vkladaji se mezery;
         pokud ale nejsou v povolenych znacich, musime je ozelet}
        if not (' ' in PovZn)and(Sour>Length(EdText)+1) then
          Sour:=Length(EdText)+1;
{mozna dat moznost vkladani jinych znaku nez mezery (0 nebo . atp...)
 to je velice elegantni reseni !!!!!}
        while Sour>Length(EdText)+1 do  {pripojeni mezer na konec}
          EdText:=EdText+' ';
        Insert(char(CtenyZnak),EdText,Sour);
        dejzobr(Sour);
        Inc(Sour);                        {zvys polohu kursoru}
        if (Vlajky and $80)=0 then        {v pripade OverWrite vymaz}
          Delete(EdText,Sour,1)             {puvodni znak}
      end
    end

    end;        {konec prikazu if UkAkce=255}

    KontrolaPreplneni;                    {kontrola textu}
    KontrolaPreteceni;                    {kontrola kursoru}
    KontrolaScrollovani;                  {pripadne scrollovani textu}

    if (UkAkce=9)and(not FormatovatText) then
      UkAkce:=255;
      {pokud text presahl pravou hranici, ale my nemame text formatovat,
       neohlasuj chybu}
    if (UkAkce>=4)and(UkAkce<=8) then
      if (not VracetPriChybe)or(not MusiPlatit(EdText)) then
      {procedura MusiPlatit ma mezitim moznost krome odevzdani false
       i treba zapipat nebo vyhodit vystrazny ramecek}
        UkAkce:=255;
      {pokud se nemame vracet pri chybe nebo neni zadany text platny,
       neohlasuj chybu (pri vybehnuti ven nebo smazani casti textu)}
    if (UkAkce=1)or(UkAkce=3) then
      if not MusiPlatit(EdText) then
        UkAkce:=255;
        {bylo-li stisknuto Enter, ukonci se pouze pri platnem textu}

    if Prvni then begin
      Prvni:=false;
      {nyni po precteni 1. udalosti se jiz zvyrazneni zrusi}
      DejZobr(Zacina)
      {kvuli prekresleni celeho okna, aby zmizela inverze;
       mozna to neni treba (uz to mozna nekdo zajistil), ale "jistota"
       je jistota}
    end
  end
end;

begin
  Inicializace;                         {pripravne akce editoru}
  while EdPar^.UkAkce=255 do begin      {dokud nepozadano o konec editoru}
    CekejNaUdalost;                     {precti z klavesnice znak}
    ZpracujZnak;                        {proved podle toho zmeny}
    ZobrazText                          {zobraz novy tvar obrazovky}
  end;
  Finalizace                            {uklid po editoru}
end;





procedure AlokujEditor(var ed:peditor);
begin
  new(ed)
end;

procedure DeAlokujEditor(var ed:peditor);
begin
  dispose(ed)
end;





procedure NastavEdOkno(par:peditor;
                       _x,_y,_d:integer;
                       _vyzva:string;
                       _ftext,_fnadpis:pfont;
                       okno:boolean);
begin
  with par^ do begin
    sx:=_x;
    sy:=_y;
    del:=_d;

    vyzva:=_vyzva;

    fnadpis:=_fnadpis;
    ftext:=_ftext;

    zobrazeniokna:=okno
  end
end;

procedure NastavEdBarvy(par:peditor;
                        _bPopr,_bPoz,_bNadp,_bKurs,_bInv,_bOkr,_bPos:byte);
begin
  with par^ do begin
    bPopr:=_bPopr;
    bPoz:=_bPoz;
    bnadp:=_bNadp;
    bKurs:=_bKurs;
    bInv:=_bInv;
    bOkr:=_bOkr;
    bPos:=_bPos
  end
end;

procedure NastavEdParametry(par:peditor;
                            PocInv,UrMez,PrubOr,MuzPres,
                            VracChyba,Format:Boolean;
                            MaxDel:byte;
                            Povol,Oddel:TSetChar);
begin
  with par^ do begin
    PocatecniInverze:=PocInv;
    OriznoutMezery:=UrMez;
    PrubezneOrezavat:=PrubOr;
    MuzePresahovat:=MuzPres;
    VracetPriChybe:=VracChyba;
    FormatovatText:=Format;
    Delka:=MaxDel;
    PovZn:=Povol;
    Oddelovace:=Oddel
  end
end;

procedure NastavEdProstredi(par:peditor;
                            posuv:boolean;
                            rolov:TRolProc;
                            okfce:TOkFunkc;
                            _escn,_escr,_entn,_entr:TSetChar);
begin
  with par^ do begin
    Posuvniky:=posuv;
    Rolovani:=rolov;
    MusiPlatit:=okfce;
    EscN:=_escn;
    EscR:=_escr;
    EntN:=_entn;
    EntR:=_entr
  end
end;

procedure NastavEdObsah(par:peditor;
                        ret:string;
                        s,z:integer);
begin
  with par^ do begin
    EdText:=ret;
    Sour:=s;
    Zacina:=z
  end
end;



begin
  EdMinCislo:=-MaxLongInt;
  EdMaxCislo:=+MaxLongint
end.
