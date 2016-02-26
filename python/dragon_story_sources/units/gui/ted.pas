{damage !!!!!
  - nevim, zda textovy soubor konci na #13#10 nebo ne (bp7 to rytirsky
    zataji)
  ===> pri cteni doctu k poslednimu radku a ten nactu, pokud neni prazdny
       (za to muze bp7), jinak ho nenactu ===> at je na konci souboru prazdny
       radek nebo ne, ja ho nenactu
  ===> pri zapisu textu delam prazdne radky vsude (i za ten posledni), coz
       take neni (hlavne u prazdneho textu) prave idealni
  !!!!! dodelat !!!!!}

{!!!!! hrouti se mi to pri okamzitem sledu akci : zoom do velika a posun
 pozn. pri posunu a zoomu se testuje okamzity stav mysi a pokud se zmackne
       nejake tlacitko pri odmacknuti aktualniho stavu a hned se pusti
       (coz se urcite casto stane), on to nezaregistruje a proto se musi
       drzet tlacitko delsi dobu, aby si toho vsiml spon v mezere mezi
       jednotl. prekresl.}
{dodelat parametr vykresleni na pocatku/konci
 a povoleni/zakazani presouvani a zoomu editoru}

{textovy editor v okne}
unit Ted;

interface
uses graph256, DFW;

type pstring=^string;

     pted=^tted;
     tted=record
       px,py,rx,ry:integer;     {pozice okna}
       sirpos:integer;          {sirka posuvniku vpravo a dole}
       napis:string;
       ftext,fnadpis:pfont;
       bPopr,bPoz,bNadp,bKurs,bOkr,bPos:byte;
       {barva textu a celkoveho pozadi, nadpisu, kursoru a okraje okna}

       x,y,zx,zy:integer;       {pozice kursoru}
       pocrad:integer;
       obsah:array[1..1000]of pstring;
{narychlo udelane hloupe pole, mozna nejak vylepsit !!!!!}

       {lokalni promenne, pod trestem smrti do nich NESAHAT!!!!! :}
       puvpozadi:pointer;
       radku:byte
     end;

var _aktted:pted;               {ukazatel na editovany text nebo nil}
    {kvuli procedure zobrazeni textu, ktera je volana jako rolovaci
    procedura z radkoveho editoru a potrebuje znat, co je editovano
    a ona nesmi byt lokalni procedura editoru a jinak se to nedozvi, nez
    ze to bude nastaveno v lokalni promenne}

procedure EditujText(ted:pted);
procedure AlokujTedOkno(var ted:pted;_px,_py,_rx,_ry,_sirpos:integer;
                        _napis:string);
procedure NastavTedFontyBarvy(ted:pted; _ftext,_fnadpis:pfont;
            _bPopr,_bPoz,_bNadp,_bKurs,_bOkr,_bPos:byte);
procedure NastavTedKursor(ted:pted; _x,_y,_zx,_zy,_pocrad:integer);
procedure AlokujTedRadek(ted:pted; _cislo:integer; _obsah:string);
procedure DealokujTed(var ted:pted);

{vsechno vraci uspesnost}
function VelikostTed(ted : pted) : word;
function NactiTedTextovySoubor(ted:pted; jmeno:string):boolean;
function ZapisTedTextovySoubor(ted:pted; jmeno:string):boolean;
function NactiTedPamet(ted : PTed;p : PByteArray; Size : word):boolean;
function ZapisTedPamet(ted:pted; var p : PByteArray) : word;
function NactiTedDfw(ted:pted; jmeno:string;Item : word):boolean;
function ZapisTedDfw(ted:pted; jmeno:string):boolean;

implementation
uses users,editor;

procedure vykreslenitextuodradku(zacx,fromy:integer);
{prekresli cast okna timto stylem : zacx oznacuje pozici leveho okraje ve
 znacich vuci textu, ale fromy oznacuje cislo radku v textu, od ktereho se
 ma zacit prekreslovat, nikoliv pozici horniho okraje obrazovky vuci textu}
var i1,i2:byte;
    barva:byte;
    maxdelka,maxvpravo:integer;
    {maximalni delka textu celkem a smerem doprava}
    delprost,mis,del:longint;
begin
  with _aktted^ do begin
    {nejdriv zobrazime samotny text}
    dec(fromy,_aktted^.zy);
    {od ktereho radku to chce prekreslit ? da hodnotu 0..radku-1}
    foncolor1:=bPopr;
    {barva popredi}

    bar(px,py+heigthoffont(ftext)*fromy,
      rx,ry-heigthoffont(ftext)*fromy,bPoz);
    {smaz puvodni edittext od daneho radku}
    for i1:=fromy to radku-1 do
    {vypis vsechny texty od daneho radku}
      if i1+zy<=pocrad then
      {neni-li to za koncem textu}
        printtext(px,py+i1*heigthoffont(ftext),
          copy(_aktted^.obsah[i1+zy]^,zacx,
            charstowidth(ftext,_aktted^.obsah[i1+zy]^,zacx,rx,false)),
          ftext);
        {vypis tolik textu, kolik se ho tam vejde}

    {nyni vypocitej maximalni delky textu kvuli posuvnikum}
    maxdelka:=0;
    maxvpravo:=0;
    for i1:=0 to radku-1 do
    {projdi vsechny radky na obrazovce}
      if i1+zy<=pocrad then begin
      {neni-li to za koncem textu}
        maxdelka:=maxinteger(maxdelka,
          widthoftext(ftext,_aktted^.obsah[i1+zy]^));
        if length(_aktted^.obsah[i1+zy]^)>=zacx then
        {je-li videt aspon kousek textu zleva (dosahne-li dany text aspon
         po levy okraj)}
          maxvpravo:=maxinteger(maxvpravo,
            widthoftextpart(ftext,_aktted^.obsah[i1+zy]^,zacx,
            length(_aktted^.obsah[i1+zy]^)-zacx+1,false))
        {priradime si maximalni dosazenou delku textu a maximalni
         dosazenou delku textu "vpravo"}
      end;
{funkci CharsToWidth jsem si strasne zjednodusil hrozny vypocet, ktery jsem
 provadel v starsi verzi procedury
 tento vypocet vsak budu muset jeste rozsirit, nebot i zacatek textu je
 s proporcionalnim fontem relativni zalezitost}

    {pak jeste zobrazime ukazatele smeru}
    if zy=1                              {pageup}
      then barva:=bPoz
      else barva:=bPos;
    bar(px+rx+1,py,SirPos,SirPos,barva);
    if pocrad<=zy+radku-1                {pagedown}
      then barva:=bPoz
      else barva:=bPos;
    bar(px+rx+1,py+ry-SirPos,SirPos,SirPos,barva);
    if zacx=1                            {pageleft}
      then barva:=bPoz
      else barva:=bPos;
    bar(px,py+ry+1,SirPos,SirPos,barva);
    if maxvpravo<=rx                     {pageright}
      then barva:=bPoz
      else barva:=bPos;
    bar(px+rx-SirPos,py+ry+1,SirPos,SirPos,barva);

    {jeste musime nakreslit samotne posuvniky}
    delprost:=rx-2*SirPos-2;             {horizontalni posuvnik}
    if maxdelka=0 then begin             {prazdny atp... text}
      del:=delprost;
      mis:=0
    end else if maxvpravo<=rx then begin {pravy vyrez neprazdneho textu}
      del:=delprost* maxvpravo div maxdelka;
      mis:=delprost- del
{bacha na to, ze uplne za textem to pak udela caru presne na rozhrani
 se znamenkem PageRight (a mozna to ani neudela !!!!!);
 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 bacha na to, ze pokud smazu klavesou ctrl-f6 zbytek textu, ktery precuhuje
 vpravo, tak se mi (zatim) posuvnik neprekresli;
 to plati ale i o nenapadnem pripsani znaku za pravym okrajem a tlacitku
 Home (pak se sice tato procedura zavola, ale nedozvi se o pripsanem znaku,
 ktery je soukromym vlastnictvim radkoveho editoru a uzivatel se dozvi
 zkreslene informace
 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
===> aby se osetrilo toto a taky moznost vypisovani treba x a y pozice
     v textu, mela by se udelat funkce, ktera se vyvola po kazde zmacknute
     klavese v textu
taky by se mela vylepsit funkce musibytcislo, aby meze nebyly v globalnich
promennych
taky by se nemusel prekreslovat radek pri znovuvyvolani editoru pri
zmacknuti sipky nahoru na 1. radku textu (mam v editoru procedury
vykreslieditor a smazeditor a tedy dat jako parametr, zda je ma editor
zavolat)
taky pouzivat 2 videostranky, aby to porad tak odporne neblikalo
a mely by se zavest horke klavesy (f5, find/replace, bloky atp...)
pri scrollovani dat ve files, radk. ed. a taky 1 hodnotu (ne jak ted je tady
1/3 a v ed. 1/6 a ve files nevim)}
    end else begin                       {vnitrni vyrez neprazdneho textu}
      del:=delprost* rx div maxdelka;
      mis:=delprost* (maxdelka-maxvpravo) div maxdelka
    end;
    bar(px+SirPos+1,py+ry+1,delprost,SirPos,bPoz);
    {vymaz prostor pro posuvnik}
    if del<>0
      then bar(px+SirPos+1+mis,py+ry+1,del,SirPos,bPos) {udelej obdelnik}
      else liney(px+SirPos+1+mis,py+ry+1,SirPos,bPos);  {jinak svislou caru}

    delprost:=ry-2*SirPos-2;             {vertikalni posuvnik}
    {tady nemusime osetrovat prazdny text (pocrad=0); je osetreno, ze vzdy
     je aspon 1 (treba i prazdny) radek}
    if pocrad-zy+1<=radku then begin     {dolni vyrez neprazdneho textu}
      del:=delprost* (pocrad-zy+1) div pocrad;
      mis:=delprost- del
    end else begin                       {vnitrni vyrez neprazdneho textu}
      del:=delprost* radku div pocrad;
      mis:=delprost* (zy-1) div pocrad
    end;
    bar(px+rx+1,py+SirPos+1,SirPos,ry-2*SirPos-2,bPoz);
    {vymaz prostor pro posuvnik}
    if del<>0
      then bar(px+rx+1,py+SirPos+1+mis,SirPos,del,bPos) {udelej obdelnik}
      else linex(px+rx+1,py+SirPos+1+mis,SirPos,bPos)   {jinak vodor. caru}
  end
end;

{$f+}
procedure vykreslenitextu(zac:integer);
{procedura pro znovuvykresleni celeho textu, je definovana kvuli tomu, aby
 se predala jako parametr editacni procedure}
begin
  vykreslenitextuodradku(zac,_aktted^.zy)
end;
{$f-}

procedure EditujText(ted:pted);
var edit:peditor;
    body:integer;              {pozice kursoru v bodech}

  procedure VytvorTed;
  begin
    with ted^ do begin
      newimage(rx+2+(SirPos+1),ry+heigthoffont(fnadpis)+3+(SirPos+1),
        puvpozadi);
      getimage(px-1,py-heigthoffont(fnadpis)-2,
        rx+2+(SirPos+1),ry+heigthoffont(fnadpis)+3+(SirPos+1),puvpozadi);
      bar(px-1,py-heigthoffont(fnadpis)-2,
        rx+2+(SirPos+1),ry+heigthoffont(fnadpis)+3+(SirPos+1),bPoz);
      rectangle(px-1,py-heigthoffont(fnadpis)-2,
        rx+2+(SirPos+1),ry+heigthoffont(fnadpis)+3+(SirPos+1),bOkr);
      linex(px,py-1,rx+(SirPos+1),bOkr);   {oddeleni nadpisu}
      liney(px+rx,py,ry+(SirPos+1),bOkr);  {oddeleni prostoru pro posuvnik}
      linex(px,py+ry,rx+(SirPos+1),bOkr);
      linex(px+rx+1,py+SirPos,SirPos,bOkr);      {pageup}
      linex(px+rx+1,py+ry-SirPos-1,SirPos,bOkr); {pagedown}
      liney(px+SirPos,py+ry+1,SirPos,bOkr);      {pageleft}
      liney(px+rx-SirPos-1,py+ry+1,SirPos,bOkr); {pageright}
      foncolor1:=bNadp; {nadpis}
      printtext(px,py-heigthoffont(fnadpis)-1,napis,fnadpis);
      {vytvori vhodne pozadi pro edittext}
      radku:=ry div heigthoffont(ftext)
      {vypocita, kolik se tam vejde radku}
    end
  end;

  procedure SmazTed;
  begin
    with ted^ do begin
      putimage(px-1,py-heigthoffont(fnadpis)-2,puvpozadi);
      disposeimage(puvpozadi)
    end
  end;

  procedure posunkursor(smer:integer);
    forward;

  procedure presuneditoru(mx,my:integer);
  var mys:pointer;
      i:byte;
  begin
    with ted^ do begin
      pushmouse;
      mouseswitchoff;
      newimage(rx+2+(SirPos+1),ry+heigthoffont(fnadpis)+3+(SirPos+1),mys);
      getimage(px-1,py-heigthoffont(fnadpis)-2,
        rx+2+(SirPos+1),ry+heigthoffont(fnadpis)+3+(SirPos+1),mys);
      putimage(px-1,py-heigthoffont(fnadpis)-2,puvpozadi);
      {obnovi pozadi a zapamatuje si dialog a mys}

      mouseon(mx-(px-1),my-(py-heigthoffont(fnadpis)-2),mys);
      newmousearea(mx-(px-1),my-(py-heigthoffont(fnadpis)-2),
        320-(rx+2+(SirPos+1)),
        200-(ry+heigthoffont(fnadpis)+3+(SirPos+1)));
      repeat
      until mousekey<>0;
      {nyni dialogem pohybuje jako mysi}

      inc(px,mousex-mx);
      inc(py,mousey-my);
      inc(edit^.sx,mousex-mx);
      {zmeni souradnice dialogu}

      mouseswitchoff;
      getimage(px-1,py-heigthoffont(fnadpis)-2,
        rx+2+(SirPos+1),ry+heigthoffont(fnadpis)+3+(SirPos+1),puvpozadi);
      putimage(px-1,py-heigthoffont(fnadpis)-2,mys);
      disposeimage(mys);
      {obnovi na obrazovce dialog na novem miste vcetne zapamatovani
       noveho pozadi}

      repeat
      until mousekey=0;
      newmousearea(0,0,320,200);
      popmouse
      {obnovi stav mysi}
    end
{pri celoobraozkovem editoru se obcas mouseoff zhrouti na arithmetic
 overflow !!!!!}
  end;

  procedure zoomeditoru;
{pri zoomu se nedava pozor na vyjeti nadpisu vpravo z textu a tim i k jeho
 vykresleni bez ulozeni pozadi
 ted uz ano, ale ne pri inicializaci !!!!!, mozna by se tam melo dat tech
 par radek ze zoomu, ktere upravuji souradnice - a nejen tady, ale VSUDE,
 protoze NIKDE nedavam pozor na korektnost zadanych parametru !!!!!}
  var _rx,_ry:integer;
  begin
    pushmouse;
    with ted^ do
      repeat
        _rx:=maxinteger(mousex-px-(sirpos+2),widthoffont(ftext)+1);
        _ry:=maxinteger(mousey-py-(sirpos+2),heigthoffont(ftext)+1);
        {podle mysi, ale aby se tam vesly posuvniky prilepene k textu
         a taky aby se tam vesel aspon 1 sloupec a 1 radek textu}
        _rx:=maxinteger(_rx,widthoftext(fnadpis,napis)+2-(sirpos+2));
        {aby se tam vesel i nadpis, ale ten zasahuje "zhora" i do posuvniku,
         musime to vzit v uvahu}
        _rx:=maxinteger(_rx,3*sirpos+2);
        _ry:=maxinteger(_ry,3*sirpos+2);
        {musi se tam taky vlezt posuvniky, ktere pri prilepeni zboku
         obsahuji ikony pro strankovy posun, 2 delici caru a taky nejakou
         oblast pro samotny posuvnik}
{pozn. to je uz hezky osetreny, ale editor sam, pokud mu to dovolim a zmensim
       ho na 1*1 znak, se zasekne pri vykreslovani posuvniku na asi deleni
       nulou nebo rangecheckerror nebo spis arithmeticoverflow, ja nevim;
 ale proste editor 1*1 znak to nezvlada !!!!!}
        if (rx<>_rx)or(ry<>_ry) then begin
          mouseswitchoff;
          smazted;
          rx:=_rx;
          ry:=_ry;
          vytvorted;
          edit^.del:=_rx;
          posunkursor(0);
{jeste osetrit vyjeti kursoru v horizontalnim smeru !!!!!
 ale nastesti to pak osetri aspon radkova editace

 asi kvuli push/pop-mouse za sebou zanechava mys obcas stopu v textu pri
 zoomovani}
          vykreslenitextu(zx);
          mouseswitchon
        end
      until mousekey<>0;
{jakto, ze poloha mysi casto nekoresponduje s polohou zoomvaci oblasti ???}
    repeat
    until mousekey=0;
    popmouse
  end;

  procedure nastavpodlemysi;
  begin
    with edit^,ted^ do
      if inbar(mysx,mysy,px,py,rx,ry) then begin
      {padla-li mys do dialogu, vypocitej novou pozici}
        y:=zy+(mysy-py) div heigthoffont(ftext);
        {nastav dany radek}
        if y>pocrad then
          y:=pocrad;
        {kontrola preteceni}
        x:=zx+charstowidth(ftext,obsah[y]^,zx,mysx-px,true)
        {vypocitej pozici x}
      end else if not inbar(mysx,mysy,
        px-1,py-heigthoffont(fnadpis)-2,
        rx+2+(SirPos+1),ry+heigthoffont(fnadpis)+3+(SirPos+1)) then
        {je to uplne mimo editor}
        write(#7)
{zatim tam mame jenom pipani !!!!!
 co takhle vyskocit z editoru ?????}
      else if mysy<py then      {kliknuti na nadpis : presunuti editoru}
        presuneditoru(mysx,mysy)
      else if mysy>=py+ry then  {kliknuti pod textem}
        if mysx>px+rx then      {zoomovaci ikona vpravo dole : zoom editoru}
          if mysy=py+ry           {pokud se klikne na rozdelovaci caru,}
            then posunkursor(radku) {to jeste do oblasti dolniho posuvniku}
            else zoomeditoru
        else if mysx<=px+SirPos then {levy posuvnik ===> PageLeft}
{udelat pageleft !!!!!}
        else if mysx>=px+rx-sirpos-1 then {pravy posuvnik ===> PageRight}
{udelat pageright !!!!!}
        else                    {jinak je to klik na presne misto}
{udelat presun na toto misto !!!!!}
      else
        if mysy<=py+SirPos then {horni posuvnik ===> PageUp}
          posunkursor(-radku)
        else if mysy>=py+ry-sirpos-1 then {dolni posuvnik ===> PageDown}
          posunkursor(radku)
        else begin              {jinak je to klik na presne misto}
        {vertikalni presun na nove misto}
          x:=1;
          y:=integer(longint(pocrad)*
            (mysy-py-sirpos-1) div (ry-2*SirPos-2))+1;
          {vypocitej novou vertikalni pozici; pretypovani je nutne}
          {if y<1 then y:=1;}           {neni potreba}
          {if y>pocrad then y:=pocrad;} {take neni potreba}
          if zy>y then begin
            zy:=y-radku div 3;
            if zy<1 then
              zy:=1;
            vykreslenitextuodradku(zx,zy)
          end;
          if zy+radku-1<y then begin
            zy:=y-radku+1+radku div 3;
            vykreslenitextuodradku(zx,zy)
          end
          {pripadne odroluj text}
        end
  end;

  procedure klavesaenter;
  var idx:integer;
  begin
    with ted^ do begin
      inc(y);
      inc(pocrad);
      new(obsah[pocrad]);
      for idx:=pocrad downto y+1 do
        obsah[idx]^:=obsah[idx-1]^;
      obsah[y]^:=copy(obsah[y-1]^,x,length(obsah[y-1]^)-x+1);
      obsah[y-1]^[0]:=char(x-1);
      x:=1;
      if zy+radku-1<y then begin
        zy:=y-radku+1+radku div 3;
        vykreslenitextuodradku(zx,zy)
      end else
        vykreslenitextuodradku(zx,y-1);
    end
  end;

  procedure vlozradek;
  var idx:integer;
  begin
    with ted^ do begin
      {odvozeno z Enteru, pouze se nemeni X ani Y}
      inc(pocrad);
      new(obsah[pocrad]);
      for idx:=pocrad downto y+2 do
        obsah[idx]^:=obsah[idx-1]^;
      obsah[y+1]^:=copy(obsah[y]^,x,length(obsah[y-1]^)-x+1);
      obsah[y]^[0]:=char(x-1);
      vykreslenitextuodradku(zx,y)
    end
  end;

  procedure rolujtext(smer:integer);
  begin
    with ted^ do begin
      inc(zy,smer);

      if zy<1 then
        zy:=1;
      if zy>pocrad then
        zy:=pocrad;

      if y>zy+radku-1 then
        y:=zy+radku-1;
      if y<zy then
        y:=zy;

      vykreslenitextuodradku(zx,zy);
      x:=zx+charstowidth(ftext,obsah[y]^,zx,body,true)
      {vypocitej pozici x}
    end
  end;

  procedure posunkursor(smer:integer);
  begin
    with ted^ do begin
      inc(y,smer);
      if y<1 then
        y:=1;
      if y>pocrad then
        y:=pocrad;
      x:=zx+charstowidth(ftext,obsah[y]^,zx,body,true);
      {vypocitej pozici x}
      if zy>y then begin
        zy:=y-radku div 3;
        if zy<1 then
          zy:=1;
        vykreslenitextuodradku(zx,zy)
      end;
      if zy+radku-1<y then begin
        zy:=y-radku+1+radku div 3;
        vykreslenitextuodradku(zx,zy)
      end
      {pripadne odroluj text}
    end
  end;

  procedure skoknazacatek;
  begin
    with ted^ do begin
      y:=1;
      x:=1;
      if zy>y then begin
        zy:=y-radku div 3;
        if zy<1 then
          zy:=1;
        vykreslenitextuodradku(zx,zy)
      end
    end
  end;

  procedure skoknakonec;
  begin
    with ted^ do begin
      y:=pocrad;
      x:=length(obsah[y]^)+1;
      if zy+radku-1<y then begin
        zy:=y-radku+1+radku div 3;
        vykreslenitextuodradku(zx,zy)
      end
    end
  end;

  procedure ctrlsipka(smer:integer);
  begin
    with ted^ do begin
      posunkursor(smer);
      {posuneme kursor o radek tim smerem}
      if smer=-1
        then x:=length(obsah[y]^)+1
        else x:=1
  {zatim to provizorne dame bez ctrl-sipky, pouze presun}
    end
  end;

  procedure spojradky(smer:integer);
  var idx:integer;
  begin
    with ted^ do begin
      if smer=-1 then
        dec(y);
        {jedna-li se o backspace na zacatku radku, osetrime to jako delete na
         radku predchozim}
      if y<1 then begin
      {kontrola preteceni pri backspace na 1. radku}
        y:=1;
        exit
      end;
      if y=pocrad then
{na poslednim radku asi taky radsi nic delat nebudu, i kdyz to by se
 zhroutit nemuselo}
        exit;
      x:=length(obsah[y]^)+1;
      obsah[y]^:=obsah[y]^+obsah[y+1]^;
{dodelat kontrolu preteceni, ted to jen hnusne osekava radky !!!!!
 dodelat, ze se radky spoji podle pozice kursoru, ne podle delky textu,
 protoze se na konci orezavaji mezery a to mi pak placne text vzdycky
 tesne za text, ne na kursor, kdyz je za textem
 a naopak : dam-li enter mezi 2 slovy, neoreze se rozdeleny radek o mezery,
            protoze v dobe opeusteni editoru jsou mezery jeste uvnitr textu
            ===> zustanou tam na konci trapne mezery}
      dec(pocrad);
      for idx:=y+1 to pocrad do
        obsah[idx]^:=obsah[idx+1]^;
      dispose(obsah[pocrad+1]);
      if y>pocrad then
        y:=pocrad;
{klavesa Delete mi obcas nejak blbne, na konci textu scrolluje edittext !}
      if zy>y then begin
        zy:=y-radku div 3;
        if zy<1 then
          zy:=1;
        vykreslenitextuodradku(zx,zy)
      end else
        vykreslenitextuodradku(zx,y)
    end
  end;

  procedure vymazradku;
  var idx:integer;
  begin
    with ted^ do begin
      if (pocrad=1)or(y=pocrad) then
      {vyjimka, aby nebylo 0 radku ===> kraklo by se to jinak
       a taky, aby pouze vymazal radek, kdyz se da na konci textu ^Y}
        obsah[pocrad]^:=''
      else begin
        dec(pocrad);
        for idx:=y to pocrad do
          obsah[idx]^:=obsah[idx+1]^;
        dispose(obsah[pocrad+1])
      end;
      x:=1;
      if y>pocrad then
        y:=pocrad;
      if zy>y then begin
        zy:=y-radku div 3;
        if zy<1 then
          zy:=1;
        vykreslenitextuodradku(zx,zy)
      end else
        vykreslenitextuodradku(zx,y)
    end
  end;

begin
  pushmouse;
{ted se uz myslim muze dat 2nasobne push/pop-mouse
 uchovat a obnovit pozadi uz taky asi jde az do 64kb}
{bacha na to, ze je vse dynamicky alokovany !!!!!}
  mouseswitchoff;
  {neni treba videt ji, stara se o ni jen procedura pro editaci radku}
  overfontcolor:=255;

  with ted^ do begin
    _aktted:=ted;
    VytvorTed;

    alokujeditor(edit);
    nastavedokno(edit, px,0{zada se},rx, '', ftext,fnadpis, false);
    nastavedbarvy(edit, bPopr,bPoz,bNadp,bKurs,0{inverzni neni},bOkr,0{posuvnik neni});
    nastavedparametry(edit, false,true,true,true, true,false, 254,
      [#32..#170]{povolene znaky az po konec fontu (nevim jiste)},
      [' ']{zatim oddelovac pouze mezera});
    nastavedprostredi(edit, false,vykreslenitextu,musibyttext,
      [#27],[],{escape znaky}
      [#13,#23,#26,#14],
      {Enter a Escape,
       Ctrl-W a Ctrl-Z (pro scrollovani),
       Ctrl-N (vlozeni radku)}
      [#72,#80,#73,#81,#132,#118]);
      {sipky nahoru, dolu,
       PageUp a PageDown,
       Ctrl-PageUp a Ctrl-PageDown}
    {Sour a Zacina se zada}
    {edtext se zada}
    {Ukakce, klav, mysx, mysy a myskl se naopak ziska}

    vykreslenitextu(zx);
    repeat
      edit^.sy:=py+(y-zy)*heigthoffont(ftext);
      nastavedobsah(edit,obsah[y]^,x,zx);

      editacetextu(edit);

      obsah[y]^:=edit^.edtext;
      {zada mu retezec, vyedituje ho a prevezme a zapise si vysledek}
      x:=edit^.sour;
      zx:=edit^.zacina;
      {prevezmi si novou pozici kursoru}
      body:=widthoftextpart(ftext,edit^.edtext,zx,x-zx,true);
      {vypocitej pozici v bodech}

      with edit^ do
        case ukakce of
          0,2:break;                   {escape=konec}
          3:nastavpodlemysi;           {kliknuti na jiny radek nebo uplne ven}
          1:if klav<256 then
              case byte(klav) of
                13:klavesaenter;       {enter vlozi radek + presune na nej}
                14:vlozradek;          {ctrl-n vklada radek}
                23:rolujtext(-1);      {ctrl-w roluje nahoru}
                26:rolujtext(1)        {ctrl-z roluje dolu}
              end
            else
              case byte(klav-256) of
                72:posunkursor(-1);    {nahoru}
                80:posunkursor(1);     {dolu}
                73:posunkursor(-radku);{pageup}
                81:posunkursor(radku); {pagedown}
                132:skoknazacatek;     {ctrl-pageup}
                118:skoknakonec        {ctrl-pagedown}
              end;
          4:if (klav=75+256)or(klav=15+256) then begin
              posunkursor(-1);         {vlevo a shift-tab}
              x:=length(obsah[y]^)
            end else if klav=115+256 then
              ctrlsipka(-1)            {ctrl-vlevo}
            else
              y:=zy;                   {jinak ctrl-home na zacatek obrazovky}
{funguje, ze se editor ukonci na ctrl-sipky, ale ne na sipky a tabulator ???}
          5:if (klav=77+256)or(klav=9) then begin
              posunkursor(1);          {vpravo a tab}
              x:=1
            end else if klav=116+256 then
              ctrlsipka(1)             {ctrl-vpravo}
            else begin
              y:=zy+radku-1;           {jinak ctrl-end na konec obrazovky}
              if y>pocrad then
                y:=pocrad
            end;
          6:spojradky(-1);             {backspace a alt-f5}
          7:spojradky(1);              {delete a alt-f6}
          8:if klav=25 then            {ctrl-y vymaze radek}
              vymazradku
            else begin                 {ctrl-w da pouze prazdny radek a ten se}
              spojradky(-1);             {vymaze a spoji jak s predchozim, tak}
              spojradky(1)               {s nasledujicim radkem}
            end;
          9:{tato moznost nastane pouze pri formatovani a to tady nezavadime}
        end;

{radek-to-radel reseni s proporcionalnimi fonty je dost provizorni,
 ale lepsi reseni se mi zatim delat nechce

 krom toho je to napsane spatne (ZATIM), je tam chyba !!!!!!!!!!!!!!!!!!!!!!
 nepocita se s mezerami za koncem textu (o neco vyse ano, tam je to
 jednoduche, ale tady ne)}

 {Ctrl-sipky dodelat a mazaci klavesy doladit i pro vice radku
  Tab a Shift-Tab dodelat podle predch. radku, stejne tak i BackSpace
  dodelat tzv. chytre veci, ktere delaji editor editorem - Find, Block, atp.
  Kdyz dam Enter za mezerou, tak se ta mezera neodrizne, ale zustane tam
    a kdyz dam Del na konci radku, tak je to taky haklive na mezery
  Obcas to premaze nadpis !!!!!!!!!!}

{!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 dodelat, ze kazdy pocita pocet zobrazenenho pisma po svem (moje zobrazovaci
 rutina a textovy editor = ruzny algoritmu) i kdyz davaji stejne vysledky
 (nekdy jsou ale i ruzne)
 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!}
{      if y<1 then
        y:=1;
      if y>pocrad then
        y:=pocrad;}
{      if zy>y then begin
        zy:=y;
        vykreslenitextuodradku(zx,zy)
      end;
      if zy+radku-1<y then begin
        zy:=y-radku+1;
        if zy<1 then
          zy:=1;
        vykreslenitextuodradku(zx,zy)
      end;}
    until false;
    {nekonecny cyklus, konec prikazem Break pri udalosti Escape}
    dealokujeditor(edit);

    SmazTed;
    popmouse
  end;
end;

procedure AlokujTedOkno(var ted:pted;_px,_py,_rx,_ry,_sirpos:integer;
                        _napis:string);
begin
  new(ted);
  with ted^ do begin
    px:=_px;
    py:=_py;
    rx:=_rx;
    ry:=_ry;
    sirpos:=_sirpos;
    napis:=_napis;
  end
end;

procedure NastavTedFontyBarvy(ted:pted; _ftext,_fnadpis:pfont;
            _bPopr,_bPoz,_bNadp,_bKurs,_bOkr,_bPos:byte);
begin
  with ted^ do begin
    ftext:=_ftext;
    fnadpis:=_fnadpis;
    bPopr:=_bPopr;
    bPoz:=_bPoz;
    bNadp:=_bNadp;
    bKurs:=_bKurs;
    bOkr:=_bOkr;
    bPos:=_bPos
  end
end;

procedure NastavTedKursor(ted:pted; _x,_y,_zx,_zy,_pocrad:integer);
begin
  with ted^ do begin
    x:=_x;
    y:=_y;
    zx:=_zx;
    zy:=_zy;
    pocrad:=_pocrad
  end
end;

procedure AlokujTedRadek(ted:pted; _cislo:integer; _obsah:string);
begin
  with ted^ do begin
    new(obsah[_cislo]);
    obsah[_cislo]^:=_obsah
  end
end;

procedure DealokujTed(var ted:pted);
var i:integer;
begin
  with ted^ do
    for i:=1 to pocrad do
      dispose(obsah[i]);
  dispose(ted)
end;





function VelikostTed(ted : pted) : word;
{vrati velikost textu prepocitanou na textovy soubor (kazdy radek je
 zakoncen #13#10)}
var vel, i : word;
begin
  vel:=0;
  for i:=1 to ted^.pocrad do
    Inc(vel,Length(ted^.obsah[i]^)+2);
{bacha na to, ze v textovem souboru nemusi posledni radek koncit na #13#10 !}
  VelikostTed:=vel
end;

function NactiTedTextovySoubor(ted:pted; jmeno:string):boolean;
{nacte textovy soubor do pameti, pokud neexistuje, vrati chybu a alokuje
 prazdny text}
var soubor:text;
    ret:string;
begin
  nactitedtextovysoubor:=false;
  with ted^ do begin
    pocrad:=0;
    assign(soubor,jmeno);
    {$i-} reset(soubor); {$i+}
    if ioresult<>0 then begin
      pocrad:=1;
      alokujtedradek(ted,1,'');
      exit
    end;
    while not eof(soubor) do begin
      inc(pocrad);
      readln(soubor,ret);
      alokujtedradek(ted,pocrad,ret)
    end;
    close(soubor)
  end;
  nactitedtextovysoubor:=true;
end;

function ZapisTedTextovySoubor(ted:pted; jmeno:string):boolean;
{zapise pamet do textoveho souboru, kazdy (i posledni) radek je ukoncen
 #13#10; vrati uspesnost provedene operace}
var soubor:text;
    i:integer;
begin
  zapistedtextovysoubor:=false;
  with ted^ do begin
    assign(soubor,jmeno);
    {$i-} rewrite(soubor); {$i+}
    if ioresult<>0 then
      exit;
    for i:=1 to pocrad do
      writeln(soubor,obsah[i]^);
    close(soubor)
  end;
{mozna by se toto mohlo zkombinovat pomoci ZapisTedPointer a BlockWrite
 a bylo by to (mnohem) rychlejsi !!!!!}
  zapistedtextovysoubor:=true
end;

function NactiTedPamet(ted : PTed; p : PByteArray; Size : word):boolean;
{nacte text z oblasti pameti, ve ktere je ulozen stejne jako v textovem
 souboru (kazdy radek je ukoncen #13#10, ale posledni nemusi byt)
 funkce to je jen tak ze zvyku, aby to bylo jednotne, je logicke, ze z pameti
 to vzdy bude bud O.K., nebo se zhrouti pocitac}
var poc : word;
    ret : string;
begin
  poc:=0;
  ted^.pocrad:=0;
  {pocatecni hodnoty}
  repeat
    ret:='';
    if Poc<Size then
    {vyhybka kvuli prazdnemu textu (pouze na zacatku)}
      repeat
        ret:=ret+char(p^[poc]);
        Inc(Poc)
      until (Poc>=Size)or((p^[Poc]=10)and(p^[Poc-1]=13));
      {je-li za koncem textu (neni na konci oddelovac), je v textu to, co tam
       ma byt
       jinak je tam ulozen navic jeste znak #13, pricemz znak #10 byl
       zachycen ted pri cteni ===> musi se odriznout}
    if Poc<Size then begin
      inc(poc);
      dec(ret[0])
    end;
    {zkoriguj konec textu s oddelovacem v textu}
    inc(ted^.pocrad);
    alokujtedradek(ted,ted^.pocrad,ret);
  until Poc>=Size;
  NactiTedPamet:=true
  {vraceni uspesnosti operaco (vzdy)}
end;

function ZapisTedPamet(ted:pted; var p : PByteArray) : word;
{zapise editovany text do pameti (pamet sam naalokuje)}
var i, rad, zn : word;
begin
  i:=VelikostTed(ted);
  GetMem(p,i);
  ZapisTedPamet:=i;
  {naalokuj pamet a zjisti velikost}

  i:=0;
  for rad:=1 to ted^.pocrad do begin
    for zn:=1 to length(ted^.obsah[rad]^) do begin
      p^[i]:=byte(ted^.obsah[rad]^[zn]);
      inc(i)
    end;
    p^[i]:=13;
    p^[i+1]:=10;
    inc(i,2)
  end
  {nyni postupne zapis vsechny radky do pameti}
end;

function NactiTedDfw(ted:pted; jmeno:string; Item : word):boolean;
{nacte textovy soubor z archivu Dfw}
var buf : pointer;
    i : word;
begin
  i:=CLoadItem(jmeno,buf,Item);
  NactiTedDfw:=i<>0;
  {vrati, zda se to nacetlo
   !!!!! bohuzel dfw vraci pri chybe 0 a to se asi plete s nulovou delkou
   souboru; nebo ze by se dfw zhroutil na prazdnem souboru (komfortni program
   pro archivaci dat !!!!!)}
  NactiTedPamet(ted,buf,i);
  {i pri nulovem textu se text spravne naalokuje}
  FreeMem(buf,i)
  {tady uz spravnost predpokladame}
end;

function ZapisTedDfw(ted:pted; jmeno:string):boolean;
{zapise textovy soubor do archivu Dfw}
var buf : PByteArray;     {pomocny buffer}
    i : word;             {delka textu v bajtech}
begin
  i:=ZapisTedPamet(ted,buf);                    {nacte do bufferu}
  ZapisTedDfw:=CAddFromMemory(jmeno,buf,i)<>0;  {zapise do dfw}
  FreeMem(buf,i)                                {dealokuje pamet}
end;

end.
