{mozna by se mohla udelat procedura VystraznyZvuk, at se nemusi volat
 write(#7) a at se to da snadno zmenit treba na sampl !!!!!}

{dodelat pohyb po objektech !!!!!
  - nekdy mi to da prednost vzdalenejsimu objektu, pricemz ten blizsi se
    uhlem od kolmice lisi minimalne
  - nekdy naopak to dal prednost blizsimu, ktery ale neni vubec danym smerem
===> bud dat zpet omezeni na 45 stupnu a dat prioritu uhlu (horsi reseni)
     nebo dodelat kontrolu na to, ze objekty nejsou hmotne body, ale maji take
       nejakou sirku a vysku
 lepsi pohyb po tlacitkach, nejen vlevo, vpravo, nahoru a dolu (analyzovat
 pozici tech tlacitek)}

{lepe zpracovat mys (stylem D&D aneb PPP a tlacitka se budou mackat
 a pri pohybu se zmacknutym tlacitkem i premackavat)}

{udelat odolne proti chybam (spatne nastaveny pocatecni objekt atp...)}
{dodelat Ctrl-enter jako implicitni tlacitko}
{pouzivat vsude CharsToWidth}
{overfontcolor nastavit jen 1krat a to na zacatku !!!!!}
{kazda procedura na nastaveni, co zacina na Alokuj..., to alokuje bez ohledu
 na to, zda se nechce jenom prepsat ===> udelat automaticke prepinani mezi
 alokaci/pozmenenim}





unit dialog;

interface
uses graph256, editor;

type tpopistext=string[40];

     ppsoucast=^psoucast;
     psoucast=^tsoucast;
     tsoucast=record
       x,y,             {pozice napisu}
       rx,ry,           {pozice oznacovaciho ramecku}
       dx,dy:           {delka oznacovaciho ramecku}
         integer;       {znamena to oblast, ktera je citliva na kliknuti mysi
                         pro zvyrazneni daneho objektu - tato oblast se pak
                         oramuje}
       text:tpopistext; {text identifikujici objekt}
       pis:byte;        {podtrhnute pismeno pro rychle oznaceni, 0=nic}
       font:pfont;      {kterym fontem se to ma kreslit}
       popr,podtr:byte; {barva popredi a podtrhnuti tohoto objektu}
     end;
     {kazda soucast dialogoveho boxu je identifikovana temito parametry,
      jsou to : Tlacitko (vypise se jen tak)
                CheckBox, 1 RadioButton (pre tyto se jeste kresli znacka)
                InputLine (pak se text pise do oznacovaciho ramecku a nadpis
                           k danemu objektu je obvykle vedle a text se
                           edituje podle zaznamu v pstav)
                Napis (ten ma ale vyuzity pouze polozky X, Y a Text)}

     pdialog=^tdialog;
     tdialog=record
       x,y,dx,dy:integer;         {umisteni dialogoveho boxu}

       pocnap:byte;               {staticke napisy, pouze informativni}
       nap:array[1..30]of psoucast;

       poctlac:byte;              {tlacitka, ukoncuji dialogovy box}
       tlac:array[1..30]of psoucast;

       poccheck:byte;             {zaskrtavaci boxy (Ano/Ne)}
       check:array[1..20]of psoucast;

       pocradio:byte;             {prepinaci boxy, (1 z vice moznosti)}
       radio:array[1..10]of record
         pocstav:byte;
         text:array[1..10]of psoucast; {seznam vsech jejich stavu}
       end;

       pocinput:byte;             {vstupni radky, plni se retezci}
       input:array[1..15]of psoucast;

       udalvenku,        {ma se generovat udalost pri zmacknuti mysi venku ?}
       ramtlac,           {maji se delat ramecky kolem tlacitek ?}
       presouvat:boolean; {smi se dialog presouvat mysi ?}

       poz,ram,okr:byte;  {barva okraje, pozadi a zvyraznovaciho ramecku
                           dialogoveho panelu}
       ZacObr,KonObr:boolean;
       {ma-li se na pocatku vykreslit a na konci smazat dialogovy panel -
        je to kvuli menu, ktere treba pri vyberu polozku vyvolaji dalsi
        menu atp... (panel se pak muze individualne vykreslit a smazat
        procedurami VykresliPanel a SmazPanel)
        uchovane pozadi je pak ulozeno v dialogu jako soucast tohoto zaznamu}
       uchovpozadi:pointer;
       {uchovani pozadi pro dialogovy panel, uzivatelem NEPOUZIVAT !!!}
     end;

     pstav=^tstav;
     tstav=record
     {zacatek, stav i vysledek dialogoveho boxu}
       PredvSkup,                 {kde je prave ukazatel}
       PredvObj,                  {cislo skupiny, objektu a subobjektu}
       PredvSubObj:byte;
         {toto se predava tam jako pocatecni ukazatel a zpatky jako misto,
          kde byla skoncena editace (pri Escape tam, odkud bylo Escape
          vyvolano, pri ukonceni jinym tlacitkem se to nastavi na toto
          tlacitko, prestoze se to uz jednou predava jako vysledek funkce}
         {predpoklada se, ze jak skup, tak i obj a subobj jsou v povolenych
          mezich}
       check:array[1..10]of byte; {vysledky dialogoveho boxu}
         {Check muze nabyvat pouze 0 nebo 1}
       radio:array[1..10]of byte;
         {Radio muze nabyvat pouze 1..pocetvesubskupine(i1,i2)}
       input:array[1..10]of peditor;
         {Input bude obsahovat pouze text se spravnou syntaxi}

       ukakce:byte;
         {0:enter na klavesnici (jakekoliv tlacitko)
          1:escape klavesnici (klavesa Escape)
          2:enter mysi (jakekoliv tlacitko)
          3:escape (prava klavesa)
          4:akce mysi (kliknuti mysi ven, je-li to povoleno)
          10:pomocny stav - pouze pohyb ramecku}
       klav:word;
         {ukoncujici klavesa, bylo-li to ukonceno klavesou}
       mysx,mysy:integer;
       myskl:byte
         {parametry mysi, bylo-li to ukonceno mysi}
     end;

     tstanddial=(Upozorneni,
                 BeruNavedomi,Ok,Budiz,
                 ano_ne,ano_ne_zrusit,budiz_zrusit);

const standdial:array [tstanddial] of record
        tlac:string;
        predv:byte;
        esc:integer
      end =
        ((tlac:'';                 predv:1; esc:1),
         (tlac:'~Beru na vědomí';  predv:1; esc:1),
         (tlac:'O~K';              predv:1; esc:1),
         (tlac:'~Budiž';           predv:1; esc:1),
         (tlac:'~Ano|~Ne';         predv:1; esc:2),
         (tlac:'~Ano|~Ne|~Zrušit'; predv:1; esc:3),
         (tlac:'~Budiž|~Zrušit';   predv:1; esc:2));

procedure NakresliDialog(dial:pdialog;stav:pstav);
{vykresli na obrazovku dany dialogovy panel a alokuje a nacte do nej pozadi}
procedure SmazDialog(dial:pdialog);
{smaze z obrazovky dany dialogovy panel a obnovi a dealokuje po nem pozadi}

procedure VyberDialog(dialog:pdialog;stav:pstav);
  {naprosto obecny dialogovy panel, vraci cislo stisknuteho tlacitka
   a jako parametr vraci novy stav dialogoveho boxu
   nealokuje ani nedealokuje nic}

function VyberMoznost(Napisy,Volby:string;
                      _Popr,_Poz,_Podtr,_Ram,_Okr:byte;
                      _Font:PFont;
                      _Predvol:byte;_Escape:integer):integer;
  {obal pro jednoduche volani s retezcem hodnot, jsou zadany texty nadpisu
   stejne tak jako texty tlacitek, vraci se take cislo stisknuteho tlacitka
   alokuje dialog a stejne tak po sobe uklidi}
function StandardniDialog(Text:string;
                          _Popr,_Poz,_Podtr,_Ram,_Okr:byte;
                          _Font:PFont;
                          typ:tstanddial):integer;
  {vytvori 1 z standardnich nejcasteji pouzivanych dialogu a rovnez vraci
   cislo tlacitka, ktere si uzivatel vybral
   alokuje dialog a stejne tak po sobe uklidi}
function VytvorMenu(TextMenu:string;
                    _Popr,_Poz,_Podtr,_Ram,_Okr:byte;
                    _Font:PFont;
                    var X,Y:integer;
                    Predv,Esc:integer):integer;
  {vytvori vertikalni menu, je zadano retezcem s oddelovaci |, mohou v nem
   byt jak polozky, tak napisy (treba i uprostred), vyvola dialogovou
   proceduru a vrati, co si uzivatel vybral, pripadne Escape
   alokuje dialog a stejne tak po sobe uklidi}

{nasleduji nastavovaci procedury pro vyplnovani dialogovych boxu}
procedure AlokujDialog(var dial:pdialog;
                       _x,_y,_dx,_dy:integer;
                       _Poz,_Ram,_Okr:byte;
                       {_Escape:integer;}
                       _Escvenku,_RamTlac,_Presouvat:Boolean;
                       _ZacObr,_KonObr:Boolean);
  {naalokuje dialog a nastavi do nej jednotlive hodnoty}
procedure NastavPocty(dial:pdialog;
                      _nap,_tlac,_check,_radio,_input:byte);
  {pouze nastavi pocty do alokovaneho dialogu}
procedure NastavPocetRadio(dial:pdialog; obj,pocet:byte);
  {pouze nastavi pocet jednotlivych Radio-buttonu}

procedure AlokujSoucast(dial:pdialog;
                        skup,obj,subobj:byte;
                        _x,_y:integer;
                        _Popr,_Podtr:byte;
                        _font:pfont;
                        _text:string);
procedure AlokujNapis(dial:pdialog;
                     obj:byte;
                     _x,_y:integer;
                     _Popr:byte;
                     _font:pfont;
                     _text:string);
procedure AlokujTlac(dial:pdialog;
                     obj:byte;
                     _x,_y:integer;
                     _Popr,_Podtr:byte;
                     _font:pfont;
                     _text:string);
procedure AlokujCheck(dial:pdialog;
                      obj:byte;
                      _x,_y:integer;
                      _Popr,_Podtr:byte;
                      _font:pfont;
                      _text:string);
procedure AlokujRadio(dial:pdialog;
                      obj,subobj:byte;
                      _x,_y:integer;
                      _Popr,_Podtr:byte;
                      _font:pfont;
                      _text:string);
procedure AlokujInput(dial:pdialog;
                      obj:byte;
                      _x,_y:integer;
                      _Podtr:byte;
                      edit:peditor);
procedure AlokujPocatecni_JednoduchyInput(dial:pdialog;stav:pstav;
            obj:byte;
            x,y,del:integer;
            text:tpopistext; {vypise se pred edit. linku}
            bpopr,bpodtr:byte;
            _font:pfont;
            kontr:tokfunkc;
            poc:string);
  {tyto procedury krome nastaveni parametru jednotlive polozky take alokuji}

procedure AlokujPredvoleny(var stav:pstav;
                           skup,obj,subobj:byte);
  {alokuje zaznam stavu a nastavi zvyraznovaci ramecek}
procedure PocatecniCheck(stav:pstav;obj:byte;Ano:Boolean);
procedure PocatecniRadio(stav:pstav;obj,subobj:byte);
  {pouze nastavi jednotlive parametry}
procedure PocatecniInput(dial:pdialog; stav:pstav;obj:byte;par:peditor);
  {preda alokovane parametry editoru do zaznemu}

procedure DealokujDialog(var dial:pdialog;var stav:pstav);
  {dealokuje dialog a vsechny jeho soucasti}

implementation
uses crt,users;



{******************** pomocne procedury **********************************}

function VratUkNaUkNaSoucast(dialog:pdialog;typ,cis,cis1:byte):ppsoucast;
{vrati ukazatel na ukazatel na soucast dialogoveho panelu,
 (soucast je zadana cislem skupiny (tlacitka, Check-boxy atp...),
 samotstatnym cislem v dane skupine a pripadnym druhym cislem
 pro identifikaci Radio-boxu)}
begin
  with dialog^ do
    case typ of
      0:VratUkNaUkNaSoucast:=@nap[cis];                {vypis napis}
      1:VratUkNaUkNaSoucast:=@tlac[cis];               {vypis tlacitko}
      2:VratUkNaUkNaSoucast:=@check[cis];              {vypis Check-boxu}
      3:VratUkNaUkNaSoucast:=@radio[cis].text[cis1];   {vypis Radio-boxu}
      4:VratUkNaUkNaSoucast:=@input[cis];              {vypis Input-boxu}
    end
end;

function VratUkNaSoucast(dialog:pdialog;typ,cis,cis1:byte):psoucast;
{vrati ukazatel na soucast dialogoveho panelu, ktera je zadana cislem
 skupiny (tlacitka, Check-boxy atp...), samotstatnym cislem v dane
 skupine a pripadnym druhym cislem pro identifikaci Radio-boxu}
begin
  VratUkNaSoucast:=VratUkNaUkNaSoucast(dialog,typ,cis,cis1)^
end;

function PocetVeSkupine(dialog:pdialog;typ:byte):byte;
{vraci pocet objektu v dane skupine}
begin
  with dialog^ do
    case typ of
      0:pocetveskupine:=pocnap;
      1:pocetveskupine:=poctlac;
      2:pocetveskupine:=poccheck;
      3:pocetveskupine:=pocradio;
      4:pocetveskupine:=pocinput
    end
end;

function PocetVeSubSkupine(dialog:pdialog;typ,cis:byte):byte;
  {vraci pocet subobjektu v dane skupine}
begin
  with dialog^ do
    if typ=3
      then pocetvesubskupine:=radio[cis].pocstav
      else pocetvesubskupine:=1
end;

procedure vypistext(dialog:pdialog;typ,cis,cis1:byte);
  {vypise na obrazovku text daneho objektu}
var obj:psoucast;
begin
{predpokladam, ze mam poradny font, ktery respektuje pozadi (barvou 255)
a pro popredi se diva do FonColor1 a zbytek si doplnuje sam ze standardni
palety a do FonColor2-4 se uz nediva !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

tento font se pak pretiskne pres puvodni pozadi a procedura pouze vytiskne
pismena s pomoci indexove tabulky, netiskne uz nove pozadi}
  obj:=vratuknasoucast(dialog,typ,cis,cis1);
  FonColor1:=obj^.popr;                  {vypis zadanou barvou}
  OverFontColor:=255;                    {barva pozadi je}
  with dialog^ do
    printtext(x+obj^.x,y+obj^.y,obj^.text,obj^.font)
end;

procedure podtrhnipismeno(dialog:pdialog;typ,cis,cis1:byte);
  {podtrhne pismeno v textu daneho objektu

   s procedurou vypistext to nesjednotim proto, ze u nadpisu se nesmi
   nic podtrhavat a uzivatel by musel vzdy vyplnit pis=0}
var obj:psoucast;
begin
  obj:=vratuknasoucast(dialog,typ,cis,cis1);
  FonColor1:=obj^.podtr;
  OverFontColor:=255;
  with dialog^ do
    if obj^.pis<>0 then                  {ma-li se neco podtrhavat}
      PrintChar(
        x+obj^.x+widthoftextpart(obj^.font,obj^.text,1,obj^.pis-1,
          {mezery}false),
        y+obj^.y,
        byte(obj^.text[obj^.pis]),
        obj^.font)
end;

procedure vypisznacku(dialog:pdialog;stav:pstav;typ,cis,cis1:byte);
{vypise u tlacitka, Check-boxu, Radio-boxu a Input-boxu
 potrebne nalezitosti}
var obj:psoucast;
    px,py,d:integer;
begin
  obj:=vratuknasoucast(dialog,typ,cis,cis1);
  px:=dialog^.x+obj^.x-widthoffont(obj^.font)-heigthoffont(obj^.font);
  py:=dialog^.y+obj^.y;
  d:=heigthoffont(obj^.font);
  with dialog^ do
    case typ of
      0:;                     {napis nema zadne znameni}
      1:if ramtlac then       {maji-li se kolem tlacitek delat ramecky,}
          rectangle(x+obj^.rx,y+obj^.ry, {udelej ho}
                    obj^.dx,obj^.dy,obj^.popr);
      2:begin                 {pred Check-boxem je vyplnovaci ctverecek}
          bar(px,py,d,d,poz);
            {nejprve odstranime puvodni znacku}
          rectangle(px,py,d,d,obj^.popr);
            {ramecek kolem cele znacky}
          if stav^.check[cis]=1 then begin
            line(px,py,px+d-1,py+d-1,obj^.popr);
            line(px+d-1,py,px,py+d-1,obj^.popr)
            {pokud je Check-box zaaskrtnut, preskrtneme ho}
          end
        end;
      3:begin                 {pred Radio-boxem je znackovaci ctverecek}
          bar(px,py,d,d,poz);
            {nejprve odstranime puvodni znacku}
          circle(px+d div 2,py+d div 2,d div 2,obj^.popr);
            {kolecko kolem cele znacky}
          if stav^.radio[cis]=cis1 then
            circle(px+d div 2,py+d div 2,d div 4,obj^.popr)
            {pri oznaceni jeste 1 kolecko uvnitr}
        end;
      4:vykreslenieditoru(stav^.input[cis],false)
    end
end;

procedure zvyraznitext(dialog:pdialog;typ,cis,cis1:byte);
{zyrazni dany objekt prebarvenim pozadi na jinou barvu}
var obj:psoucast;
begin
  obj:=vratuknasoucast(dialog,typ,cis,cis1);
  with dialog^ do
    replacecolor(
      x+obj^.rx,
      y+obj^.ry,
      obj^.dx,
      obj^.dy,
      poz,
      ram)
    {zmeni barvu pozadi na barvu zvyrazneni}
end;

procedure zruszvyrazneni(dialog:pdialog;typ,cis,cis1:byte);
{pretiskne dany objekt barvou pozadi}
var obj:psoucast;
begin
  obj:=vratuknasoucast(dialog,typ,cis,cis1);
  with dialog^ do
    bar(
      x+obj^.rx,
      y+obj^.ry,
      obj^.dx,
      obj^.dy,
      poz)
    {vyplni barvou pozadi}
end;



{******************** kresleni/mazani dialogoveho panelu *****************}

procedure NakresliDialog(dial:pdialog;stav:pstav);
{vykresli na obrazovku dany dialogovy panel a alokuje a nacte do nej pozadi}
var i1,i2,i3:byte;
begin
  with dial^ do begin
    {uloz pozadi}
    newimage(dx,dy,uchovpozadi);
    getimage(x,y,dx,dy,uchovpozadi);
    rectangle(x,y,dx,dy,okr);
    bar(x+1,y+1,dx-2,dy-2,poz);

    {vykresli a zaregistruj vsechny objekty}
    for i1:=0 to 4 do
      for i2:=1 to pocetveskupine(dial,i1) do
        case i1 of
          0:vypistext(dial,i1,i2,0);      {napis}
          1,2,3,4:for i3:=1 to pocetvesubskupine(dial,i1,i2) do begin
                                          {tlacitko, Check, Radio, Input}
            vypistext(dial,i1,i2,i3);
            podtrhnipismeno(dial,i1,i2,i3);
            vypisznacku(dial,stav,i1,i2,i3)
          end
        end
  end
end;

procedure SmazDialog(dial:pdialog);
{smaze z obrazovky dany dialogovy panel a obnovi a dealokuje po nem pozadi}
begin
  with dial^ do begin
    putimage(x,y,uchovpozadi);
    disposeimage(uchovpozadi);
    uchovpozadi:=nil
  end
end;



{******************** spusteni dialogoveho panelu ************************}

procedure VyberDialog(dialog:pdialog;stav:pstav);
var i1,i2,i3:byte;       {indexy pro pocitani skupin, objektu a subobjektu}

procedure cekejnaudalost;
{zatim !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!}
var j1,j2,j3:byte;
    mkey,mx,my:integer;
    obj:psoucast;
    znak:char;

procedure posundialogu;
{posouva dialogovy panel po obrazovce}
var mys:pointer;
    i:byte;
begin
  with dialog^ do begin
    if not Presouvat then begin
      write(#7);
      exit
    end;
    {pokud se dialogovy panel nesmi presouvat, vystrazne pipni a nepovol to}
    pushmouse;
    mouseswitchoff;
    newimage(dx,dy,mys);
    getimage(x,y,dx,dy,mys);
    putimage(x,y,dialog^.uchovpozadi);
    {obnovi pozadi a zapamatuje si dialog a mys}

    mouseon(mx-x,my-y,mys);
    newmousearea(mx-x,my-y,320-dx,200-dy);
    repeat
    until mousekey<>0;
    {nyni dialogem pohybuje jako mysi}

    for i:=1 to pocetveskupine(dialog,4) do begin
      inc(stav^.input[i]^.sx,mousex-mx);
      inc(stav^.input[i]^.sy,mousey-my);
      inc(stav^.input[i]^._sx,mousex-mx);
      inc(stav^.input[i]^._sy,mousey-my)
    end;
    inc(dialog^.x,mousex-mx);
    inc(dialog^.y,mousey-my);
    {zmeni souradnice dialogu}

    mouseswitchoff;
    getimage(x,y,dx,dy,dialog^.uchovpozadi);
    putimage(x,y,mys);
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

function zpracujmys:boolean;
{procedura, ktera provede posouzeni prikazu od mysi a vrati, zda se ma
 provest exit cekaci procedury (true) nebo se ma pokracovat - continue
 (false)}
var j1,j2,j3:byte;
begin
{chyba Pascalu = priradi spatne to bez predpony stav^. promennou ukakce
 atp.., protoze je definovana ve 2 zaznamech a na obou je nastaven with
 takto :
   1) je nastaven na 1. zaznam (editor)
   2) skocim prikazem goto (ted uz ne) do jineho prikazu with na 2. zaznam
      (stav)
   3) tady to pouziju, schramstne to, ale nepriradi to ani do 1 z nich,
      buh vi, kam to da

mozna bych tyto mohl prejmenovat (predpona ed a di) !!!!!
nebo vynechat ten debilni prikaz goto - to jsem udelal}

  zpracujmys:=true;             {standardni volba je exit}

  with dialog^,stav^ do begin
    if mkey<>1 then begin         {escape jinym tlacitkem mysi}
      ukakce:=3;
      mysx:=mx;
      mysy:=my;
      myskl:=mkey;
      exit
    end;

    {nyni si vezmeme pozici mysi, abychom odmackli to, kde skonci}
    for j1:=1 to 4 do           {prozkoumej vsechny skupiny objektu}
      for j2:=1 to pocetveskupine(dialog,j1) do {prozkoumej vsechny objekty}
        for j3:=1 to pocetvesubskupine(dialog,j1,j2) do begin {prozkoumej vsechny subobjekty}
          obj:=vratuknasoucast(dialog,j1,j2,j3);
          if inbar(mx,my,x+obj^.rx,y+obj^.ry, {padne-li tam mys}
               obj^.dx,obj^.dy) then begin
{doresit trochu lepe, co kdyz se objekty prekryvaji !!!!!!!!!!!!!!!!!!!!!!!}
            ukakce:=2;                        {predame objektu rizeni}
            i1:=j1;
            i2:=j2;
            i3:=j3;
            mysx:=mx;               {zaznamename pozici pro pripad, ze by}
            mysy:=my;                  {to byla ukoncujici klavesa nebo}
            myskl:=mkey;               {se kliklo na Input-box}
            exit
          end
        end;
    {pokud jsme nalezli objekt, na ktery to kliklo, procedura uz
     skoncila
     jestlize procesor dosel az sem, netrefili jsme se do zadneho
     objektu}

    if inbar(mx,my,x,y,dx,dy) then begin {kliknuti na pozadi = posun}
      posundialogu;
      zpracujmys:=false;        {provest continue}
      exit
    end else
      if udalvenku then begin   {jinak jsme klikli mimo panel}
        ukakce:=4;              {mame-li se ukoncit, ukonceme se}
        mysx:=mx;
        mysy:=my;
        myskl:=mkey;
        exit
      end else begin            {mame-li pokracovat, cekame znovu}
        zpracujmys:=false;
        exit                    {provest continue}
      end
  end
end;

procedure predchoziobjekt;
begin
  dec(i3);                      {sipka nahoru a vlevo, pouze posun}
  if i3=0 then begin
    dec(i2);
    if i2=0 then begin
      repeat
        dec(i1);
        if i1=0 then
          i1:=4
      until pocetveskupine(dialog,i1)<>0;
      {snizujeme pocitadlo skupin, dokud nenalezneme tu pravou}
      i2:=pocetveskupine(dialog,i1)
    end;
    i3:=pocetvesubskupine(dialog,i1,i2)
  end;
  stav^.ukakce:=10
end;

procedure nasledujiciobjekt;
begin
  inc(i3);                      {sipka dolu a vpravo, pouze posun}
  if i3>pocetvesubskupine(dialog,i1,i2) then begin
    inc(i2);
    if i2>pocetveskupine(dialog,i1) then begin
      repeat
        inc(i1);
        if i1=5 then
          i1:=1
      until pocetveskupine(dialog,i1)<>0;
      {zvysujeme pocitadlo skupin, dokud nenalezneme tu pravou}
      i2:=1
    end;
    i3:=1
  end;
  stav^.ukakce:=10
end;

procedure PosunRamecekSmerem(smer:byte);
{posunuti ramecku danym smerem na jiny objekt
 smery : 1..4 (sever,jih,zapad,vychod)}
var zkus1,zkus2,zkus3,best1,best2,best3:byte;
    aktobj,best,zkus:tsoucast;

procedure upravnasmer(var souc:tsoucast; smer:byte);
{vzorky se budou porovnavat jenom na smer doprava, ostatni smery se tam
 musi pretransformovat (otocenim o x*90 stupnu)
 vysledek : v x a y budou relativni posuny smerem doprava a nahoru nebo dolu
            od aktualniho objektu (smer y je v absolutni hodnote)}
var pom:integer;
begin
  with souc do begin
    x:=rx+dx div 2; {standardne se bere prostredek ramecku jako aktivni bod}
    y:=ry+dy div 2;
    case smer of
      0:;{pouze uprava souradnic na stred - pouzito pro vychozi objekt
          ===> nic uz nedelej}
      1:begin               {sever}
          pom:=aktobj.y-y;    {sour.x doprava bude jako sour.y nahoru}
          y:=abs(x-aktobj.x); {sour.y dolu bude jako sour.x doleva}
          x:=pom
        end;
      2:begin               {jih}
          pom:=y-aktobj.y;
          y:=abs(aktobj.x-x);
          x:=pom
        end;
      3:begin               {zapad}
          y:=abs(aktobj.y-y);
          x:=aktobj.x-x
        end;
      4:begin               {vychod}
          y:=abs(y-aktobj.y);
          x:=x-aktobj.x
        end
    end
  end
end;

function jelepsi:boolean;

function uhel(souc:psoucast):real;
{vraci uhel ve stupnich}
var pom:real;
begin
  pom:=abs(souc^.y/souc^.x);
  pom:=arctan(pom);
  uhel:=pom/pi*180
  {nemusime kontrolovat x<>0, protoze objekt tohoto typu uz je vyfiltrovan
   podminkou x<=0 znamena exit}
end;

function vzdalenost(souc:psoucast):real;
{vraci vzdalenost v bodech}
var pom:real;
begin
  pom:=sqr(souc^.x);
  pom:=pom+sqr(souc^.y);
  pom:=abs(pom);
  vzdalenost:=sqrt(pom)

  {!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
   musime delat tuto svinarnu proto, ze BP7 ma spatny kompilator mat.
   vyrazu (horsi nez muj Math a dava to pro Sqrt zaporny parametr (scitam-li
   2 Sqr !!!!!) + ma uplne zmrseny Undo/Redo; Borlandi, fuj !!!!!
   pozn. radsi jsem to dal i do fce uhel; chyba se projevila zatim asi pouze
         u Pospeca na 386sx bez mat. kopro.
   !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!}
end;

begin
  jelepsi:=false; {dejme tomu, ze lepsi neni}
  zkus:=vratuknasoucast(dialog,zkus1,zkus2,zkus3)^;
  upravnasmer(zkus, smer);
  if (zkus.x<=0){or(zkus.y>zkus.x)} then
  {neni-li objekt ve spravnem kvadrantu (tj. neni-li x kladne nebo
   je y vetsi nez x (tj. odchylka > 45 stupnu)), neni to vhodny objekt
   pozn. timto vyfiltruje objekt i sam sebe}
    exit;
  if best1=0 then begin
  {jestlize je ve vhodnem smeru (viz. predch. podm.) a neni jeste nastaven
   zadny objekt, tak nastav 1. nalezeny objekt}
    jelepsi:=true;
    exit
  end;
  {jinak musime porovnat s dosud nejlepsim objektem}

  jelepsi:=(uhel(@zkus)-uhel(@best))+
           (vzdalenost(@zkus)-vzdalenost(@best))
           <0
  {pozn. :
     aby byl objekt zvolen, musi mit zaroven co nejmensi uhel k danemu
     smeru sipky i co nejmensi vzdalenost
   vzal jsem kompromis a to, ze se sectou rozdily uhlu a vzdalenosti, pricemz
   uhly jsou ve stupnich (tady 0..45) a vzdalenost v bodech a myslim ze
   ciselne si obe tyto jednotky priblizne odpovidaji, pokud bych nekdy
   zjistil, ze ne, tak tam nekde dam konstantu, aby se to vyrovnalo
   nyni vznikne : pokud je u zkouseneho objektu mensi uhel, je prvni scitanec
     zaporny; stejne tak u vzdalenosti; vysledek je, ze pokud je soucet
     zaporny, je lepsi prave zkouseny objekt, pri nule je to nerozhodne a pri
     kladnem vysledku je lepsi doposud nalezeny objekt
   to, ze se to scita, umoznuje doladit, ze treba se zvoli objekt s vetsim
     uhlem, ktery je ale bliz a naopak, pro uplnou presnost se musi zkousenim
     doladit konstanta, aby to bylo presne tak, jak to uzivatel ocekava}

{tady jsem mel problem, porad jsem ladil konstantu a on pokracoval, pak jsem
 zjistil, ze konstanta 1 (tedy zadna) je asi idealni, protoze s ni bezi
 vsechno a ten problem byl zpusoben pouze tim, ze byl neviditelne kousicek
 za 45 stupni
 ===> zakomentaroval jsem ochranu na 45 stupnu, zkusime, co to udela
 super, uz to skace i tam, kde to predtim nebralo a myslim si, ze to je
 idealni, protoze to asi lepe splnuje pozadavky

 !!!!! jeste je tu jedna strasna krpa !!!!!
   ja beru jako aktivni bod to, co je uprostred obrazovky, ale ja neskacu
   pro "hmotnych bodech" ale po telesech, co maji nejaky rozmer !!!!!
 ====> to, kam se skoci, nekdy neodpovida tomu, kde by to visualne melo byt,
       protoze stred je visualnu zakryt !!!!!}

{doladit konstantu !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 co kdyz kamosi nemaji koprocesor ?????????????????
 dokumantace je v me hlava a na papirku !!!!!!!!!!!
 cely to prozkouset !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!}
end;

begin
  aktobj:=vratuknasoucast(dialog,i1,i2,i3)^;
  upravnasmer(aktobj,0);
  best1:=0;
  for zkus1:=1 to 4 do
    for zkus2:=1 to pocetveskupine(dialog,zkus1) do
      for zkus3:=1 to pocetvesubskupine(dialog,zkus1,zkus2) do
        if jelepsi then begin
          best1:=zkus1;
          best2:=zkus2;
          best3:=zkus3;
          best:=zkus
        end;
  if best1<>0 then begin {je-li neco nalezeno}
    i1:=best1;
    i2:=best2;
    i3:=best3
  end;
  stav^.ukakce:=10
  {pozadovana akce je presun objektu, do IFu to nedavam, protoze se stejne
   testuje "opravdovy" posun a my musime stejne neco priradit do UkAkce
   (mozna ze ne, ale takhle je to jednodussi)}
end;

begin
  {vypne a zapne mys na zacatku a na konci procedura, ktera nas vola}
  i1:=stav^.predvskup;
  i2:=stav^.predvobj;
  i3:=stav^.predvsubobj;
    {nastav nejpravdepodobnejsi zvyrazneni po cekani na udalost}

{dodelat Ctrl-Enter jako standardni tlacitko a poradnou mys :
 tazeni-pusteni, dvojklik atp...}
  while i1=4 do
    with stav^.input[i2]^ do begin
      {je-li to Input-box, tak ho spustime a pockame na exit-code
       jinak se nic nedeje a dany objekt zustane zvyraznen}
      pocatecniinverze:=stav^.ukakce<>2;
        {text bude inverzni pouze pri pohybu ramecku klavesnici nebo pri
         zmacknuti zvyrazneneho pismenka, pokud tam klikneme mysi, uz to
         bude normalni neinverzni text}
      editacetextu(stav^.input[i2]);
      {vyvola vyplneny editor - jsou uz vyplneny jak parametry editoru, tak
       i retezec EdText a pozice kursoru, ktere se pak na konci ulozi zpet
       ponevadz jsou nastaveny switche, tak jako vystupni kod pripada
       v uvahu pouze 0..3}
      case ukakce of
        0:begin                       {escape klavesnice}
            stav^.ukakce:=1;
{tady se mi bohuzel rozchazi cislovani udalosti enter a escape
 u dialogu kontra editoru}
            stav^.klav:=27;
            exit
          end;
        1:begin
            znak:=char(klav);         {priradi se 0..255 i pro >=256}
            if (klav=13)or(klav=9) then
              nasledujiciobjekt        {enter na nasledujici objekt}
            else if klav=80+256 then
              posunrameceksmerem(2)  {dolu na dolni objekt}
            else if klav=72+256 then
              posunrameceksmerem(1) {nahoru na horni objekt}
            else if klav=15+256 then
              predchoziobjekt;
            exit
          end;
        2,3:begin                       {enter i escape na mysi}
            mx:=mysx;
            my:=mysy;
            mkey:=myskl;
            if zpracujmys               {je-li to dobry klik, konec}
              then exit                 {jinak opakujeme pokus}
              else begin
                stav^.ukakce:=2;        {dame to jako zvolene mysi, aby}
                continue                  {rozhodne nebyla inverze}
              end
          end
      end
      {nyni jsme provedli akci podle toho, jak byl editor ukoncen}
    end;
  {jestlize nejsme na editacnim boxu, dostaneme se sem}

  with dialog^,stav^ do
    repeat
      repeat                            {cekej na stisk klavesy nebo mysi}
      until keypressed or (mousekey<>0);

      if mousekey<>0 then begin         {byla-li to udalost mysi}
        mkey:=mousekey;
        {vezmeme si tlacitka mysi}
        repeat
        until mousekey<>mkey;
        {pockame, az uzivatel odmackne tlacitko, nebo zmackne neco
         jineho atp.}
        mx:=mousex;
        my:=mousey;
        {prevezmeme si souradnice}

        if zpracujmys
          then exit
          else continue
          {zpracujeme udalost a podle ni bud ukoncime cekani nebo
           testujeme znovu}
      end;
      {jestlize procesor dosel az sem, neudala se zadna udalost mysi drive,
       nez byla stisknuta nejaka klavesa}

      znak:=upcase(readkey);          {nacteme danou klavesu}
      if znak=#27 then begin     {Esc, predame Esc}
        ukakce:=1;
        klav:=27;
        exit
      end else

      if znak=#13 then begin     {Enter, predame rizeni aktualnimu objektu}
        ukakce:=0;
        klav:=13;
        exit
      end else

      if znak=#9 then begin      {Tabulator, dalsi objekt}
        nasledujiciobjekt;
        exit
      end else

      if (znak=#0)and(KeyPressed) then begin {#0, cteme dalsi klavesu}
        znak:=readkey;
        case znak of
          #15:begin              {Shift Tab, predchazejici objekt}
            predchoziobjekt;
            exit
          end;
          #72:begin              {nahoru, posun na horni objekt}
            posunrameceksmerem(1);
            exit
          end;
          #80:begin              {dolu, posun na dolni objekt}
            posunrameceksmerem(2);
            exit
          end;
          #75:begin              {doleva, posun na levy objekt}
            posunrameceksmerem(3);
            exit
          end;
          #77:begin              {doprava, posun na pravy objekt}
            posunrameceksmerem(4);
            exit
          end;
          #73:begin              {PageUp skoci na zacatek aktualni (sub)skupiny}
                if i1=3          {jsme-li na Radio-boxu}
                  then i3:=1     {skoc na zacatek subskupiny}
                  else i2:=1;    {jinak skoc na zacatek skupiny}
                ukakce:=10;
                exit
              end;
          #81:begin              {PageDown skoci na konec aktualni (sub)skupiny}
                if i1=3          {jsme-li na Radio-boxu}
                  then i3:=pocetvesubskupine(dialog,i1,i2) {skoc na konec subskupiny}
                  else i2:=pocetveskupine(dialog,i1);      {jinak skoc na konec skupiny}
                ukakce:=10;
                exit
              end;
          #71:begin              {Home skoci na zacatek dialogu}
                i2:=1;
                i3:=1;
                i1:=1;
                while pocetveskupine(dialog,i1)=0 do
                  inc(i1);
{v pripade ze neexistuje zadne tlacitko (pak by se ale
                   dal dialog ukoncit pouze klavesou Escape !!!!!!!!!!!),
                   najdi nejblizdi existujici objekt
                   pokud uz zadny nenalezne, zbouchne to na preteceni}
                ukakce:=10;
                exit
              end;
          #79:begin              {End skoci na konec dialogu}
                i1:=4;
                while pocetveskupine(dialog,i1)=0 do
                  dec(i1);
                  {obdobne, ale hleda od konce}
                i2:=pocetveskupine(dialog,i1);
                i3:=pocetvesubskupine(dialog,i1,i2);
                ukakce:=10;
                exit
              end;
        end
      end else                   {jina klavesa, pokusime se zjisit, kam ukazuje}

      for j1:=1 to 4 do          {projdi vsechny objekty}
        for j2:=1 to pocetveskupine(dialog,j1) do
          for j3:=1 to pocetvesubskupine(dialog,j1,j2) do begin
            obj:=vratuknasoucast(dialog,j1,j2,j3);
            if upcase(obj^.text[obj^.pis])=znak then begin
              i1:=j1;            {shoduje-li se pismeno, predej mu rizeni}
              i2:=j2;
              i3:=j3;
              ukakce:=0;
              klav:=word(znak);
              exit
            end
          end
{predpokladam, ze kazdy znak je v menu zastoupen nejvyse jednou}

    until false
    {nekonecny cyklus cekani na udalost, vyskakuje se z nej pri nalezeni
     vhodne udalosti prikazem Exit
     procedura vzdy vrati, co bylo zmacknuto, pripadne to zmacknuti trochu
     nasimuluje (pri udalosti mysi)
     tim je predano rizeni nekteremu objektu a my muzeme pokracovat dal}
end;

procedure PrazdnyDialog;
{procedura pro osetreni ceklu cekani na udalost pro dialogovy panel, na
 kterem nejsou umisteny zadne objekty krome pripadnych napisu}
var klav:word;
begin
  mouseswitchon;
  with dialog^,stav^ do
    repeat
      if keypressed then begin        {je-li stisknuta klavesa}
        klav:=word(readkey);
        if (klav=0)and keypressed then
          klav:=word(readkey)+256;
        while keypressed do
          readkey;
        if klav=27
          then ukakce:=1
          else ukakce:=0;
        break
      end;
      if mousekey<>0 then begin       {je-li stisknuta mys}
        mysx:=mousex;
        mysy:=mousey;
        myskl:=mousekey;
        repeat
        until mousekey=0;
        if myskl<>0
          then ukakce:=3
          else if inbar(mysx,mysy,x,y,dx,dy)
            then ukakce:=2
            else ukakce:=4;
        break
      end
    until false;
    {nekonecny cyklus, dokud nenastane nejaka akce}
  mouseswitchoff
end;

procedure PlnyDialog;
{procedura pro osetreni ceklu cekani na udalost pro dialogovy panel, na
 kterem jsou umisteny i jine objekty nez pripadne napisy}
begin
  with dialog^,stav^ do
    repeat
      zvyraznitext(dialog,predvskup,predvobj,predvsubobj);
        {zvyrazni zatim zvoleny objekt}

      mouseswitchon;
      repeat
        cekejnaudalost;
        {pockej na to, co se ma delat}
      until (ukakce<>10)or
            (i1<>stav^.predvskup)or
            (i2<>stav^.predvobj)or
            (i3<>stav^.predvsubobj);
        {pokud nahodou dostaneme jako prikaz skok na sebe sameho, cekame
         znovu, at zbytecne nehybeme rameckem}
      mouseswitchoff;

      if ukakce in [1,3,4] then            {je-li Escape nebo kliknuti ven}
        break;                             {vse je uz nastaveno, konec}

      zruszvyrazneni(dialog,predvskup,predvobj,predvsubobj);
      vypistext(dialog,predvskup,predvobj,predvsubobj);
      podtrhnipismeno(dialog,predvskup,predvobj,predvsubobj);
      vypisznacku(dialog,stav,predvskup,predvobj,predvsubobj);
        {zrusime zvyrazneni aktualniho objektu}
      predvskup:=i1;
      predvobj:=i2;
      predvsubobj:=i3;
        {zmenime ukazatel zvyrazneni na novou polozku}
      if ukakce=10 then
        continue;
        {mame-li jen posunout zvyrazneni, preskocime nasledujici prikazy}
      {jinak provedeme Enter se zvyraznenym objektem}
      case predvskup of
        1:break;                        {Enter na tlacitku znamena konec}
                                          {vse je uz nastaveno}
        2:begin                         {u Check-boxu zmenime znamenko}
            check[predvobj]:=1-check[predvobj];
            vypisznacku(dialog,stav,predvskup,predvobj,1) {zmenime jeho znacku}
          end;
        3:begin                         {u Radio-boxu prehodime "tecku"}
            i3:=radio[predvobj];        {zjistime stary zaskrtnuty objekt}
            radio[predvobj]:=predvsubobj; {zmenime priznak zaskrtnuti}

            vypisznacku(dialog,stav,predvskup,predvobj,i3); {ten stary odsktrneme}
            i3:=predvsubobj;
            vypisznacku(dialog,stav,predvskup,predvobj,i3)  {ten novy zaskrtneme}
          end;
        4:begin
            {u Input-boxu je zde po vyfiltrovani mozna jedina udalost - 2
             (kliknuti mysi do textu), protoze escape udalosti se zachyti,
             pri pouhem presunu ramecku se toto preskoci a udalost cislo 0
             (enter na objektu) je zde nemozna, nebot tato pouze posouva
             ramecek dopredu
             ===> musime nastavit kursor podle toho, kam klikla mys}
             with stav^.input[predvobj]^ do
               sour:=zacina+
                 charstowidth(ftext,edtext,zacina,stav^.mysx-_sx,true)
          end
      end
    until false;
    {nekonecny cyklus, vyskakuje sam, kdyz je potreba}
end;

begin
  with dialog^,stav^ do begin
    PushMouse;
    mouseswitchoff;
    {uchovame stav mysi a zneviditelnime ji}

    if ZacObr then                      {ma-li se nakreslit dial. panel}
      NakresliDialog(dialog,stav);

    if (poctlac=0)and(poccheck=0)and(pocradio=0)and(pocinput=0)
      then PrazdnyDialog
           {neni-li v dialogovem boxu nic krome (pripadneho) napisu, vyvolej
            specialni proceduru}
      else PlnyDialog;
           {jinak zaciname od zadane polozky v menu - ta je nastavena
            uzivatelem a volame proeduru pro plny dialog}

    if KonObr then
      SmazDialog(dialog);
      {ma-li se dialogovy panel smazat, smaz ho}

    {obnovit viditelnost mysi}
    PopMouse
  end
  {mys je uklizena uz v procedure CekejUdalost, klavesnici odklizet
   nebudeme; co je v klavesnicovem bufferu, to tam i zustane}
end;



{******************** obal pro jednoduchy dial. panel ********************}

function VyberMoznost(Napisy,Volby:string;
                      _Popr,_Poz,_Podtr,_Ram,_Okr:byte;
                      _Font:PFont;
                      _Predvol:byte;_Escape:integer):integer;
var dial:pdialog;
    stav:pstav;
    j:byte;
    max,deltlac:integer;
begin
  alokujdialog(dial,
    0,0,0,0,
    _Poz,_Ram,_Okr,
    {_escape,}
    false,true,true,
    true,true);
  alokujpredvoleny(stav,1,_predvol,1);
  nastavpocty(dial,0,0,0,0,0);

  with dial^,stav^ do begin
    max:=0;

    while Napisy<>'' do begin
    {zapsat vsechny retezce napisu a pocitat maximum}
      inc(pocnap);
      j:=1;
      while (Napisy[j]<>'|')and(j<=length(napisy)) do
        inc(j);
        {vyhledej neblizsi | nebo konec retezce
         ===> | na konci byt muze nebo nemusi, i kdyz tam bude, neda se na
              konec prazdna volba, protoze vystupni podminka nynejsiho
              NADcyklu je prazdny retezec, nikoliv preteceni}

      alokujnapis(dial,pocnap,
        0,pocnap*heigthoffont(_font),
        _Popr,
        font,
        copy(Napisy,1,j-1));
      if widthoftext(_font,nap[pocnap]^.text)>max then {prip. zvys maximum}
        max:=widthoftext(_font,nap[pocnap]^.text);
      delete(Napisy,1,j)                    {vymaz text z retezce}
    end;

    deltlac:=0;
    while Volby<>'' do begin
    {zapsat vsechny retezce tlacitek a pocitat maximum}
      inc(poctlac);
      j:=1;
      while (Volby[j]<>'|')and(j<=length(volby)) do
        inc(j);
        {vyhledej neblizsi | nebo konec retezce
         ===> | na konci byt muze nebo nemusi, i kdyz tam bude, neda se na
              konec prazdna volba, protoze vystupni podminka nynejsiho
              NADcyklu je prazdny retezec, nikoliv preteceni}

        {diky 2 bodove mezere oznacovaciho ramecku se to uz nezblbne ani
         pri tlacitku, ktere ma prazdny nazev}

      alokujtlac(dial,poctlac,
        0,(pocnap+2)*heigthoffont(_font),
        _Popr,_Podtr,
        font,
        copy(Volby,1,j-1));
      if pocnap=0 then begin
        dec(dial^.tlac[poctlac]^.y,heigthoffont(_font));
        dec(dial^.tlac[poctlac]^.ry,heigthoffont(_font))
      end;
      {pokud neni zadny napis, posun tlacitko o radek nahoru}
      delete(Volby,1,j);                     {vymaz text z retezce}

      inc(deltlac,tlac[poctlac]^.dx)         {zvys pocitadlo delky tlacitek}
    end;

    if poctlac<>0 then
    {existuje-li nejake tlacitko, pricte 4-bodove mezery mezi nimi}
      inc(deltlac,(poctlac-1)*4);
    if deltlac>max then
    {a rovnez vypocitej maximum}
      max:=deltlac;
    inc(max,2*widthoffont(_font));
    {zvys max, aby byl okraj 1 znak kolem nejsirsiho objektu}

    if poctlac<>0 then begin
    {existuje-li nejake tlacitko}
      tlac[1]^.rx:=(max-deltlac) div 2;
      tlac[1]^.x:=tlac[1]^.rx+widthoffont(_font);
      for j:=2 to poctlac do begin
        tlac[j]^.x:=tlac[j-1]^.x+
                    widthoftext(_font,tlac[j-1]^.text)+
                    widthoffont(_font)*2+4;
        tlac[j]^.rx:=tlac[j]^.x-widthoffont(_font)
        {udej i pozici oznacovaciho ramecku}
      end;

      dy:=tlac[1]^.y+2*heigthoffont(_font)
      {vypocitej y-ovy rozmer dialogoveho panelu}
    end else
    {neni-li zadne tlacitko}
      if pocnap<>0
      {vypocitej dolni okraj podle toho,
       zda uz je na obrazovce nejaky napis}
        then dy:=(pocnap+2)*heigthoffont(_font)
        else dy:=heigthoffont(_font);

    for j:=1 to pocnap do
    {zapis podle maxima ziskane X-ove hodnoty napisu,
     aby to bylo vycentrovane}
      nap[j]^.x:=(max-widthoftext(_font,nap[j]^.text)) div 2;

    dx:=max;
    {zapis i x-ovy rozmer dialogoveho panelu}

    x:=(320-dx) div 2;
    y:=(200-dy) div 2;
    {vypocitej i umisteni dialogoveho panelu, aby byl vycentrovany}

    vyberdialog(dial,stav);
    with stav^ do
      if ukakce in [1,3,4]
        then vybermoznost:=_escape
        else vybermoznost:=predvobj
  end;

  dealokujdialog(dial,stav)
end;



{******************** obal pro standardni dial. panel ********************}

function StandardniDialog(Text:string;
                          _Popr,_Poz,_Podtr,_Ram,_Okr:byte;
                          _Font:PFont;
                          typ:tstanddial):integer;
begin
  with standdial[typ] do
    standardnidialog:=vybermoznost(text,tlac,
                                   _Popr,_Poz,_Podtr,_Ram,_Okr,
                                   _Font,
                                   predv,esc)
end;



{******************** obal pro menu **************************************}

function VytvorMenu(TextMenu:string;
                    _Popr,_Poz,_Podtr,_Ram,_Okr:byte;
                    _Font:PFont;
                    var X,Y:integer;
                    Predv,Esc:integer):integer;
  {TextMenu :
    - radky se oddeluji znaky | a na konci oddelovac byt muze, ale nemusi
    - pokud radek zacina znakem #, je to nadpis menu (klidne uprostred)
    - pokud radek zacinajici znakem # je prazdny, bere se to jako svisla
      cara, kterou tam nageneruje tato procedura
    - ostatni radky jsou polozky menu a uprostred nich se muze, ale
      nemusi vyskytnou znak ~, ktery uvozuje podtrzeny znak}
var Dial:pdialog;
    stav:pstav;
    radek,i:byte;
    ret:string;
    max:integer;
begin
  alokujdialog(dial,
    x,y,0,0,
    _Poz,_Ram,_Okr,
    {esc,}
    true,false,true,
    true,true);
  alokujpredvoleny(stav,1,predv,1);
  nastavpocty(dial,0,0,0,0,0);

  with dial^,stav^ do begin
    radek:=0;                           {jsme na 0. retezci}
    max:=0;                             {maximalni delka byla zatim 0}

    while TextMenu<>'' do begin
    {prochazej text a zapisuj si polozky a texty}
      inc(radek);                       {zvys pocitadlo radku}
      i:=1;                             {najdi dalsi radek}
      while (TextMenu[i]<>'|')and(i<=length(TextMenu)) do
        inc(i);

      ret:=copy(textMenu,1,i-1);        {vyjmi radek z retezce}
      delete(TextMenu,1,i);

      if ret[1]='#' then begin          {je-li to radka nadpisu}
        inc(pocnap);                    {zapis to do seznamu}
        delete(ret,1,1);
        alokujnapis(dial,pocnap,
          2,heigthoffont(_font)*(radek-1)+2,
          _Popr,
          _font,
          ret);
        if widthoftext(_font,ret)>max then
          max:=widthoftext(_font,ret)   {zapis si maximum}
        {je-li '' za # (===> bude tam linka),
         zkontrolujeme pri druhem pruchodu}
      end else begin                    {jinak je to polozka menu}
        inc(poctlac);                   {zapis to do seznamu}
        alokujtlac(dial,poctlac,
          widthoffont(_font)+2,heigthoffont(_font)*(radek-1)+2,
          _Popr,_Podtr,
          _font,
          ret);

        tlac[poctlac]^.rx:=1;
        if widthoftext(_font,ret)+widthoffont(_font)>max then
          max:=widthoftext(_font,ret)+widthoffont(_font)
          {zapis si maximum; ...+widthoffont(_font) je tam kvuli vetsimu
          odsazeni polozky nez nadpisu}
      end
    end;
    {nyni jsme prosli a analyzovali cely text menu, musime praci jeste
     dokoncit}

    inc(max,4);
      {udelej malicke okraje zleva a zprava}

    dx:=max;
    dy:=radek*heigthoffont(_font)+4;
      {umisteno menu uz je, rozmery jsou "usity" tak, aby presne ramovaly
       cele menu s malickym okrajem - 2 body po kazde ze ctyr stran}

    {nyni jeste projdeme vsechny napisy a zaplnime vodorovne cary}
    for radek:=1 to pocnap do
      if nap[radek]^.text='' then
        for i:=1 to ((max-4) div widthofchar(_font,'-')) do
          nap[radek]^.text:=nap[radek]^.text+'-';
    {nyni jeste u kazdeho tlacitka uvedeme zvyraznovaci ramecek}
    for radek:=1 to poctlac do
      tlac[radek]^.dx:=max-2;

    vyberdialog(dial,stav);
    with stav^ do
      if ukakce in [1,3,4]
        then vytvormenu:=esc
        else vytvormenu:=predvobj
  end;
  x:=dial^.x;
  y:=dial^.y;
  {vrati nazpet prip. zmenene souradnice menu}

  dealokujdialog(dial,stav)
end;



{******************** nastavovani parametru dial. panelu *****************}

procedure AlokujDialog(var dial:pdialog;
                       _x,_y,_dx,_dy:integer;
                       _Poz,_Ram,_Okr:byte;
                       {_Escape:integer;}
                       _Escvenku,_RamTlac,_Presouvat:Boolean;
                       _ZacObr,_KonObr:Boolean);
begin
  new(dial);
  with dial^ do begin
    x:=_x;
    y:=_y;
    dx:=_dx;
    dy:=_dy;
    poz:=_Poz;
    ram:=_Ram;
    okr:=_Okr;
    {Escape:=_Escape;}
    UdalVenku:=_EscVenku;
    RamTlac:=_RamTlac;
    Presouvat:=_Presouvat;
    ZacObr:=_ZacObr;
    KonObr:=_KonObr;
    UchovPozadi:=nil
  end;
  {tim jsme nastavili vsechny potrebne veci a muzeme skoncit}
end;

procedure NastavPocty(dial:pdialog;
                      _nap,_tlac,_check,_radio,_input:byte);
  {pouze nastavi pocty do alokovaneho dialogu}
begin
  with dial^ do begin
    pocnap:=_nap;
    poctlac:=_tlac;
    poccheck:=_check;
    pocradio:=_radio;
    pocinput:=_input
  end
end;

procedure NastavPocetRadio(dial:pdialog; obj,pocet:byte);
  {pouze nastavi pocet jednotlivych Radio-buttonu}
begin
  dial^.radio[obj].pocstav:=pocet
end;

procedure AlokujSoucast(dial:pdialog;
                        skup,obj,subobj:byte;
                        _x,_y:integer;
                        _Popr,_Podtr:byte;
                        _font:pfont;
                        _text:string);
{obecne nastaveni soucasti dialogu pro vsechny typy soucasti krome textu}
var Idx:byte;
    Ob:psoucast;
begin
  new(vratuknauknasoucast(dial,skup,obj,subobj)^);
    {alokuje ukazatel v zaznamu}
  Ob:=vratuknasoucast(dial,skup,obj,subobj);
    {nyni ho budeme nastavovat}

  with Ob^ do begin
    x:=_x;
    y:=_y;

    popr:=_Popr;                {nastav barvy}
    podtr:=_Podtr;

    font:=_font;                {nastav font}

    text:=_text;
    if skup=0 then              {pro napis to uz staci}
      exit;

    pis:=pos('~',text);         {text je zadan i s ~}
    if pis<>0 then
      delete(text,pis,1);

{mozna dat ry=y-1; a dy++;, podle toho, jak huste budou texty u sebe
 (myslim to podle osy Y)

 nevim, jestli tam nema byt dy=_font^[1] - protoze mi to vychazi pro kazdy
 font jinak !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!}

    ry:=y;
    dy:=HeigthOfFont(_font)+1;  {tesne kolem textu po obou stranach}
    case skup of                {podle skupiny urcime ramecek atp...}
      1:rx:=x-WidthOfFont(_font);
                                {tlacitko : o jednu sirku doleva}
      2,3:rx:=x-WidthOfFont(_font)-HeigthOfFont(_font)-2
        {Check, Radio : o jednu sirku doleva a jeste o 1 vysku kvuli doleva
         ctvercove znacce a jeste 2 body doleva kvuli prostoru pred znackou}
    end;
    dx:=widthoftext(_font,text)+WidthOfFont(_font)+(x-rx);
      {delka ramecku je delka textu + 1 znak vpravo + uz vytyceny okraj
       vlevo (to ale jen pro 1, 2 a 3, 4 je nadefinovano v jine procedure)}
  end
  {tim jsme nastavili vsechny potrebne veci a muzeme skoncit}
end;



{******************** obaly pro nastavovani parametru dial. panelu *******}

procedure AlokujNapis(dial:pdialog;
                     obj:byte;
                     _x,_y:integer;
                     _Popr:byte;
                     _font:pfont;
                     _text:string);
begin
  AlokujSoucast(dial,
                0,obj,1,
                _x,_y,
                _Popr,0,
                _font,
                _text)
end;

procedure AlokujTlac(dial:pdialog;
                     obj:byte;
                     _x,_y:integer;
                     _Popr,_Podtr:byte;
                     _font:pfont;
                     _text:string);
begin
  AlokujSoucast(dial,
                1,obj,1,
                _x,_y,
                _Popr,_Podtr,
                _font,
                _text)
end;

procedure AlokujCheck(dial:pdialog;
                      obj:byte;
                      _x,_y:integer;
                      _Popr,_Podtr:byte;
                      _font:pfont;
                      _text:string);
begin
  AlokujSoucast(dial,
                2,obj,1,
                _x,_y,
                _Popr,_Podtr,
                _font,
                _text)
end;

procedure AlokujRadio(dial:pdialog;
                      obj,subobj:byte;
                      _x,_y:integer;
                      _Popr,_Podtr:byte;
                      _font:pfont;
                      _text:string);
begin
  AlokujSoucast(dial,
                3,obj,subobj,
                _x,_y,
                _Popr,_Podtr,
                _font,
                _text)
end;

procedure AlokujInput(dial:pdialog;
                      obj:byte;
                      _x,_y:integer; {napis}
                      _Podtr:byte;   {podtrzeni napisu}
                      edit:peditor);
var Ob:psoucast;
begin
  new(vratuknauknasoucast(dial,4,obj,1)^);
  Ob:=vratuknasoucast(dial,4,obj,1);
  with Ob^,edit^ do begin
    x:=_x;
    y:=_y;

    popr:=bPopr;                {nastav barvy}
    podtr:=_Podtr;

    font:=fNadpis;              {nastav font}

    text:=vyzva;                {nastav text, ktery}
    pis:=pos('~',text);         {je zadan i s pripadnou ~}
    if pis<>0 then
      delete(text,pis,1);

    if sx<_x                    {levy rozmer vezmi ten levejsi}
      then rx:=sx
      else rx:=_x;
    if sy<_y                    {... hornejsi}
      then ry:=sy
      else ry:=_y;
    if sx+del>_x+widthoftext(fnadpis,vyzva) {... pravejsi}
      then dx:=(sx+del-1)-rx+1
      else dx:=(_x+widthoftext(fnadpis,vyzva)-1)-rx+1;
    if sy+heigthoffont(ftext)>_y+heigthoffont(fnadpis) {... dolnejsi}
      then dy:=(sy+heigthoffont(ftext)-1)-ry+1
      else dy:=(_y+heigthoffont(fnadpis)-1)-ry+1;

    dec(rx,2);                  {dej prostor 2 body zleva a zprava}
    inc(dx,4);
    dec(ry);                    {dej prostor 1 body zhora a zdola}
    inc(dy,2)

    {ted jsme jen nastavili tyto parametry :
       1) umisteni, font a barvu napisu
       2) okno, do ktereho se muze klikat pro zvyrazneni Input-boxu
          a ktere se taky zvyrazmnovat bude
     ostatni parametry - presny popis prikazove radky se jiz zadaji
     v poli stav, nikoliv zde}
  end
end;

procedure AlokujPocatecni_JednoduchyInput(dial:pdialog;stav:pstav;
            obj:byte;
            x,y,del:integer;
            text:tpopistext; {vypise se pred edit. linku}
            bpopr,bpodtr:byte;
            _font:pfont;
            kontr:tokfunkc;
            poc:string);
var ed:peditor;
begin
  AlokujEditor(ed);
  NastavEdOkno(ed, x,y,del, text,  _font,_font, false);
  NastavEdBarvy(ed, bPopr,0,0,dial^.ram,dial^.poz,dial^.okr,dial^.okr);
  NastavEdProstredi(ed, true,zadnerolovani,kontr, [],[],[],[]);
  NastavEdParametry(ed, true,true,false,false,false,false, 255,
    standardnipovzn,standardnioddelovace);
  NastavEdObsah(ed, poc,1,1);

  alokujinput(dial,obj,x-widthoftext(_font,text+' '),y,bpodtr,ed);
  pocatecniinput(dial,stav,obj,ed)
end;



{******************** nastavovani stavu dialogoveho panelu ***************}

procedure AlokujPredvoleny(var stav:pstav;
                           skup,obj,subobj:byte);
begin
  new(stav);
  with stav^ do begin
    PredvSkup:=skup;
    PredvObj:=obj;
    PredvSubObj:=subobj;
  end;
  {tim jsme nastavili vsechny potrebne veci a muzeme skoncit}
end;

procedure PocatecniCheck(stav:pstav;obj:byte;Ano:Boolean);
begin
  stav^.check[obj]:=byte(ano)
end;

procedure PocatecniRadio(stav:pstav;obj,subobj:byte);
begin
  stav^.radio[obj]:=subobj
end;

procedure PocatecniInput(dial:pdialog; stav:pstav;obj:byte;par:peditor);
{zaplni Input-box tak, aby fungoval}
begin
  stav^.input[obj]:=par;                {prevezmi ukazatel na parametry}
  with stav^.input[obj]^ do begin
    {nyni nektere parametry trochu zmenime}
    inc(sx,dial^.x);
    inc(sy,dial^.y);
    {del - predpokladam spravne vyplnene}
    vyzva:='';
    {fnadpis - neni treba,ftext - predpokladam spravne}
    {jednotlive barvy - predpokladam spravne vyplnene}
    zobrazeniokna:=false;
    pocatecniinverze:=true;
    {uriznoutmezery, prubezneorezavat, muzepresahovat, posuvniky
     - necham na uzivateli}
    rolovani:=zadnerolovani;
    {musiplatit - at vyplni uzivatel}
    EscN:=[#27];  EscR:=[];  {escape znak je jenom 1 - Escape}
    EntN:=[#13,#9];        {posun vpred je Enter (Tab je editacni klavesa)}
    EntR:=[#15,#72,#80];   {posun zpet je sipka nahoru (Shift-Tab -"-),
                              posun vpred je sipka dolu}
    vracetprichybe:=false;
    formatovattext:=false;
    {delka - at si vyplni uzivatel sam}
    {povzn a oddelovace - taky}

    {edtext, sour a zacina - to uz je na uzivateli}
  end
end;

{******************** zruseni stavu dialogoveho panelu *******************}

procedure DealokujDialog(var dial:pdialog;var stav:pstav);
  {dealokuje dialog a vsechny jeho soucasti}
var i,j,k:byte;
begin
  for i:=1 to pocetveskupine(dial,4) do
    dealokujeditor(stav^.input[i]);
{byly 2 problemy :
  - zde jsem misto indexu i dal 1
  - pocital jsem na papiru a nevychazelo mi to, az jsem si uvedomil,
    ze zde dealokuji i texty, ktere se alokuji na zacatku programu
  ===> vse s alokaci je zatim v poradku}
  dispose(stav);

  for i:=0 to 4 do
    for j:=1 to pocetveskupine(dial,i) do
      for k:=1 to pocetvesubskupine(dial,i,j) do
        dispose(vratuknauknasoucast(dial,i,j,k)^);
  if dial^.uchovpozadi<>nil then
    disposeIMAGE(dial^.uchovpozadi);
{pokud to nebylo alokovano, ani se to nedealokuje, BP ma docela chytry
 manazer pameti; ale dela to mouchy (bez IFu) ===>
 !!!!! pro jistotu je to udelano i s IFem !!!!!}
  dispose(dial)
end;



end.
