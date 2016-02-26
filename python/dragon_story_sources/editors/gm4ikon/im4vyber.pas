{procedura vycházející z ListBoxu, která umožní listovat po seznamu
 místností a čekat na vyvolání některé akce

 je ve videostránce číslo 2 (tedy 3. v pořadí), na začátku se tedy vykreslí
 a pak už se beze škody jen edituje (příp. dialog o parametrech místnosti
 a viewování ikony bude ve videostránce číslo 1), výběr ikon ze souboru je
 ve videostránce číslo 0, ikona se načítá z disku}

unit im4vyber;
interface
uses im4cti,graph256;

procedure editujseznammistnosti(var m:tseznammistnosti);

implementation
uses crt,dialog,users,
     im4akce,im4toget;

type TOffsetu=array[1..3]of integer; {pozice jednotl. sloupců}
     {tak jako v listboxu, až na to, že se nevezmou podle záznamů, ale
      natvrdo a ve výpisu je kontrola na přesáhnutí}

const x:integer=0;
      y:integer=0;
      dx=310; {podle něj se vezmou sloupce; doladit!}
      pocet:integer=16; {dy se vypočítá normálně}
      hlavicka='Vyber si ikonu a provedenou akci';
      paticka='nápověda k akcím je dole';
      nap1='    Esc=konec; Ent=editace; Ins=nová; Del=smazání';
      nap2='        Tab=prohlédni ikonu; C=změň ikonu';
      {font=font; ale to není konstanta}
{      Popr=15;
      Poz=7;
      Podtr=12;
      Ram=10;
      Okr=8;}

procedure editujseznammistnosti(var m:tseznammistnosti);
var {Obsah:PObsahu;                {obsah prohlíženého adresáře}
    {PocetPol:integer;             {počet položek}
    Offsety:TOffsetu;             {kde začínají jednotl. položky}
    {uchovpozadi:pointer;          {původní pozadí pod dialogem}
    akce:byte;                    {požadovaná akce podle myši nebo klávesnice}
      {0=Escape
       1=Enter, kliknutí myší
           kam, to se nastaví do Akt1 a Zac1
       2=pouze pohyb zvýraznění,
           kam, to se také nastaví do Akt1 a Zac1

       3=insert;
       4=delete;
       5=editace (výběr z pozadí)
       7=view}
    Zac,Akt,Zac1,Akt1:integer;    {stará a nová pozice rámečku}

procedure vypistext(idx:integer);
{vypíše na obrazovku zadaný řádek od vrchu obrazovky}
var py,i:integer;
    ret:string;
begin
  FonColor1:=dcolor[1];                       {vypis zadanou barvou}
  OverFontColor:=255;                    {barva pozadi je 255}

  py:=y+idx*heigthoffont(font)+1;
  if (Zac+Idx-1)<=m.pocet then begin         {vypíše všechny položky}
(*    for i:=1 to pocetpol do
      if obsah^[zac+idx-1]^[i]<>'' then begin
        ret:=copy(obsah^[Zac+Idx-1]^[i],1,
          charstowidth(font,obsah^[Zac+Idx-1]^[i],1,offsety[i+1]-offsety[i],
          false)); {aby to nepřesáhlo rámeček}
        printtext(x+1+offsety[i],py,ret,font);
      end; *)
    if m.m[zac+idx-1]^.symb<>'' then begin
      ret:=copy(m.m[Zac+Idx-1]^.symb,1,
        charstowidth(font,m.m[Zac+Idx-1]^.symb,1,offsety[2]-offsety[1],
        false)); {aby to nepřesáhlo rámeček}
      printtext(x+1+offsety[1],py,ret,font);
    end;
    if m.m[zac+idx-1]^.jm<>'' then begin
      ret:=copy(m.m[Zac+Idx-1]^.jm,1,
        charstowidth(font,m.m[Zac+Idx-1]^.jm,1,offsety[3]-offsety[2],
        false)); {aby to nepřesáhlo rámeček}
      printtext(x+1+offsety[2],py,ret,font);
    end;
  end;
  {bez ifu --- bude to i na neexistujících položkách --- oddělovací čáry}
{  for i:=2 to pocetpol do
    liney(x-1+offsety[i],py,heigthoffont(font),okr);}
  liney(x-1+offsety[2],py,heigthoffont(font),dcolor[5]);
end;

procedure zvyraznitext(idx:integer);
{zvýrazní daný řádek přebarvením pozadí na jinou barvu}
begin
  replacecolor(x+1,y+idx*heigthoffont(font)+1,
               offsety[3],heigthoffont(font),
               dcolor[2],dcolor[4])
  {změní barvu pozadí na barvu zvýraznění}
end;

procedure zruszvyrazneni(idx:integer);
{přetiskne daný řádek barvou pozadí}
begin
  bar(x+1,y+idx*heigthoffont(font)+1,
      offsety[3],heigthoffont(font),
      dcolor[2])
  {vyplní barvou pozadí}
end;

procedure posuvnik(vidit:boolean);
{vypíše/smaže vpravo od seznamu souborů posuvník relativní pozice obrazovky}
var del,             {relativní velikost posuvníku k celku}
    mis,             {relativní počátek posuvníku k celku}
    pom:longint;     {udávají velikost celého sloupku v bodech}
      {je to LongInt proto, že výraz pom*(zac-1) div adresar^.pocet
       překračuje v mém adresáři Windows velikost integer a nevím, zda by se
       vlezl do Wordu
       proto musím ještě předtím než to poDIVuji to převést na LongInt
       a touto definicí se vyhnu nespolehlivému (v BP) přetypováni
       poDIVovat to dřív (jiné pořadí operací) to nechci kvůli případné
       ztrátě přesnosti}
    barva:byte;      {barva vypisovaného posuvníku}
begin
  if m.pocet=0 then {nebude se dělat posuvník}
    exit;
  pom:=pocet*heigthoffont(font);
  if m.pocet-Zac+1<=Pocet then begin
    del:=pom* (m.pocet-Zac+1) div m.pocet;
    mis:=pom- del
  end else begin
    del:=pom* pocet div m.pocet;
    mis:=pom* (zac-1) div m.pocet
  end;
  {vypiplané 2 varianty pro nezaplněný a zaplněný panel, myslím, že je to
   dokonalé a ukazuje to vždy přesně}
  if vidit
    then barva:=dcolor[1]
    else barva:=dcolor[2];
  if del<>0 then
    bar(x+offsety[3]+2,
        y+heigthoffont(font)+mis,
        widthoffont(font),
        del,
        barva)
  else
    linex(x+offsety[3]+2,
          y+heigthoffont(font)+mis,
          widthoffont(font),
          barva)
  {ten if tam musím dát proto, že procedura Bar při výšce 0 udělá
   obdélník o šířce 0 - tedy žádný a já to musím vidět}
end;

procedure kontrolujmeze(var akt,zac:integer);
{zkoriguje 2 parametry tak, aby to byly správné údaje o pozici}
begin
  if akt>m.pocet then             {přetečení Akt}
    akt:=m.pocet;
  if akt<1 then                    {podtečení Akt}
    akt:=1;

  if akt<zac then                  {rolování nahoru}
    zac:=akt-pocet div 3{+1};
{!!!!! ta +1 tam nesmi byt, viz. nahore !!!!!}
  if akt>zac+pocet-1 then          {rolování dolu}
    zac:=akt-2*pocet div 3;
  {tento způsob rolování v případě vyjetí posune okraj tak, aby byl rámeček
   právě v 1/3 okna
   možná, že to nevypadá ta efektně, ale je to při držení šipky nahoru nebo
   dolů to nejrychlejší}

  if zac>m.pocet-pocet+1 then     {přetečení Zac}
    zac:=m.pocet-pocet+1;
  if zac<1 then                    {podtečení Zac}
    zac:=1
end;

procedure KresliPanel;
  forward;
procedure SmazPanel;
  forward;
procedure VypisSeznam(i1,i2:integer);
  forward;
procedure mistoproposuvnik;
  forward;

procedure cekejnaudalost;
{čeká na událost z klávesnice a myši, analyzuje ji a předá ji dál}
label PageUp,PageDown;
var j,mkey,mx,my:integer;
    znak:char;

(*
procedure posundialogu;
{posouvá panel ListBoxu po obrazovce}
var mys:pointer;
    i:byte;
begin
  pushmouse;
  mouseswitchoff;
  newimage(offsety[3]+widthoffont(font)+3,
    (pocet+2)*heigthoffont(font),mys);
  getimage(x,y,offsety[3]+widthoffont(font)+3,
    (pocet+2)*heigthoffont(font),mys);
  putimage(x,y,uchovpozadi);
  {obnoví pozadí a zapamatuje si dialog a myš}

  mouseon(mx-x,my-y,mys);
  newmousearea(mx-x,my-y,320-(offsety[3]+widthoffont(font)+3),
    200-(pocet+2)*heigthoffont(font));
  repeat
  until mousekey<>0;
  {nyní dialogem pohybuje jako myší}

  inc(x,mousex-mx);
  inc(y,mousey-my);
  {změní souřadnice dialogu}

  mouseswitchoff;
  getimage(x,y,offsety[3]+widthoffont(font)+3,
    (pocet+2)*heigthoffont(font),uchovpozadi);
  putimage(x,y,mys);
  disposeimage(mys);
  {obnoví na obrazovce dialog na novém místě včetně zapamatování
   nového pozadí}

  repeat
  until mousekey=0;
  newmousearea(0,0,320,200);
  popmouse
  {obnoví stav myši}
end;

procedure zoomdialogu;
{zoomuje panel ListBoxu}
var novypocet:integer;
begin
  pushmouse;
  repeat
    novypocet:=maxinteger((mousey-y{-1}) div heigthoffont(font)-2,1);
    {zoomuj podle myši, ale musí být na panelu aspoň 1 řádek}
{myslim, že podle logiky by tam to -1 mělo byt, ale podle zkušeností ne
 a bez něj mohu stand2 nazoomovat na 20 radku, tj. 18 řádků pro soubory}
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
      mistoproposuvnik;
      posuvnik(true);
      mouseswitchon
    end
  until mousekey<>0;
  repeat
  until mousekey=0;
  popmouse
end;
*)

begin
  {vypne a zapne myš na začátku a na konci procedura, která nás volá}
  zac1:=zac;
  akt1:=akt;
    {nastav nejpravděpodobnější zvýraznění po čekani na událost}
  repeat
    while not keypressed do       {čekej na stisk klávesy nebo myši}
      if mousekey<>0 then begin
        mkey:=mousekey;
        {vezmeme si tlačítka myši}
        repeat
        until mousekey<>mkey;
        {počkáme, až uživatel odmáčkne tlačítko, nebo zmáčkne něco
         jiného atp.}
        mx:=mousex;
        my:=mousey;
        {nyní si vezmeme pozici myši, abychom odmáčkli to, kde skončí}
        if mkey<>$01 then begin       {jiné než levé tlačítko ===> Escape}
          akce:=0;
          exit

        end else                      {jinak je to levé tlačítko :}

        if not inbar(mx,my,x+1,y,     {úplně mimo dialogový panel ===> nic}
                 offsety[3]+widthoffont(font)+1, {ořezávám vlevo o 1 bod}
                 (pocet+2)*heigthoffont(font)) then
          continue

        else begin
          j:=(my-y-1) div heigthoffont(font); {podíváme se, kam padl}

          if inbar(mx,my,x+1,y+1,  {je v prostoru pro soubory ?}
                   offsety[3],
                   (pocet+2)*heigthoffont(font)-2) then
{udělat, ať to nebere klik, pokud se klikne přesně mezi řádky !!!!!}
            {zde to máme krásně jednoznačně, protože se mi nic nepřekrývá}
            if j=0 then begin         {nahoře=posun dialogu}
              {posundialogu;}
              continue
            end else if j>pocet then begin {dole=zoom dialogu}
              {zoomdialogu;}
              continue
            end else begin            {jinak je to skok na nějaký soubor}
              if j+zac1-1>m.pocet then
                Continue;
                {pokud jsme se trefili sice do dialogového a panelu a do
                 prostoru pro soubory, ale souborů je málo a zbývá tam
                 volné místo, pak jsme se nikam netrefili a testujeme událost
                 znovu, jako by se nic nestalo}
              akt1:=j+zac1-1;
              akce:=1;
              exit
            end

          else                {jinak je to v prostoru pro posuvník}
            if j=0 then               {nahoře=pageup}
              goto PageUp
            else if j>pocet then      {dole=pagedown}
              goto pagedown
            else begin                {jinak je to klik do posuvníku}
              {přesun na nový soubor}
              akt1:=integer( {přetypováni je nutné (viz. \windows\system)}
                longint((my-y-heigthoffont(font)-1))
                        *(m.pocet+1) {ať to může i na ten poslední...}
                        div (pocet*heigthoffont(font)));
{myslím, že na první to skáče po dost dlouhé dráze (2* víc než ostatní)!}
              kontrolujmeze(akt1,zac1);
              akce:=2;
              exit
            end
        end
      end;

    {jinak nastalo zmáčknutí klávesy}
    znak:=readkey;
    if znak=#27 then begin     {Esc, předáme Esc}
      akce:=0;
      exit
    end else

    if znak=#13 then begin     {Enter, předáme řízení aktuálnímu objektu}
      akce:=1;
      exit
    end else

    if znak=#9 then begin {tab, view}
      akce:=7;
      exit;
    end else

    if (znak='c')or(znak='C') then begin {změň ikonu}
      akce:=5;
      exit;
    end else

    if (znak=#0)and(KeyPressed) then begin {#0, čteme další klávesu}
      znak:=readkey;
      case znak of
        #72:begin              {šipka nahoru, pouze posun}
          dec(akt1);
          kontrolujmeze(akt1,zac1);
          akce:=2;
          exit
        end;
        #80:begin              {šipka dolů, pouze posun}
          inc(akt1);
          kontrolujmeze(akt1,zac1);
          akce:=2;
          exit
        end;
        #73:PageUp:begin       {PageUp skočí o stránku nahoru}
              Dec(akt1,Pocet);
              kontrolujmeze(akt1,zac1);
              akce:=2;
              exit
            end;
        #81:PageDown:begin     {PageDown skočí o stránku dolů}
              Inc(akt1,Pocet);
              kontrolujmeze(akt1,zac1);
              akce:=2;
              exit
            end;
        #71:begin              {Home skočí na začátek seznamu}
              Akt1:=1;
              Zac1:=1;
              akce:=2;
              exit
            end;
        #79:begin              {End skočí na konec seznamu}
              Akt1:=m.pocet;
              Zac1:=Akt1;
              kontrolujmeze(akt1,zac1);
              akce:=2;
              exit
            end;
        #82:begin {insert}
          akce:=3;
          exit;
        end;
        #83:begin {delete}
          akce:=4;
          exit;
        end;
      end
    end else                   {jiná klávesa, pokusíme se zjisit, kam ukazuje}
      {tady možná udělat zvýrazněné klávesy, možná to zavést už sem}

    {jestliže se událost nikde "nezachytí", testujeme znovu}
  until false;
  {nekonečný cyklus, vyskakuje se z něj při nalezení vhodné události
   příkazem Exit
   procedura vždy vrátí, co bylo zmáčknuto, případně to zmáčknutí trochu
   ošidí (emulace při události myši), tím je přadáno řízení některému
   objektu a my můžeme pokračovat dál}
end;

{!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!}

procedure KresliPanel;
var ret:string;
begin
{nebude se nic měnit, když to je podle dx, protože podle toho dám i offsety
 neuchovává se pozadí!}
  rectangle(X,Y,offsety[3]+widthoffont(font)+3,
    (pocet+2)*heigthoffont(font),dcolor[5]);
  bar(X+1,Y+1,offsety[3]+widthoffont(font)+1,
    (pocet+2)*heigthoffont(font)-2,dcolor[2]);
  {připraví obrazovku a myš k výběru záznamu}
  Bar(x+offsety[3]+2,y+1,
      widthoffont(font),
      heigthoffont(font)-1,
      dcolor[3]);
  Bar(x+offsety[3]+2,y+(pocet+1)*heigthoffont(font),
      widthoffont(font),
      heigthoffont(font)-1,
      dcolor[3]);
  LineY(x+offsety[3]+1,y,
      (pocet+2)*heigthoffont(font),
      dcolor[5]);
  {udělá nahoře a dole u posuvníku 2 malé značky - vyplněné čtverečky}

  Ret:=Hlavicka;
  while widthoftext(font,Ret)>offsety[3] do
    dec(ret[0]);
  FonColor1:=dcolor[3];
  OverFontColor:=255;
  if ret<>'' then
    Printtext(X+(offsety[3]-widthoftext(font,Ret)) div 2+1,
              Y+1,Ret,font);
  {vypíše na horní řádek dialogu hlavičku}

  Ret:=Paticka;
  while widthoftext(font,Ret)>offsety[3] do
    dec(ret[0]);
  if ret<>'' then
    Printtext(X+(offsety[3]-widthoftext(font,Ret)) div 2+1,
              Y+(pocet+1)*heigthoffont(font),Ret,font);
  {vypíše na dolní řádek dialogu patičku}

  foncolor1:=dcolor[1];
  PrintText(0,200-2*heigthoffont(font),nap1,font);
  PrintText(0,200-heigthoffont(font),nap2,font);
end;

procedure SmazPanel;
begin
{  putimage(X,Y,uchovpozadi);
  disposeimage(uchovpozadi)}
end;

procedure mistoproposuvnik;
begin
  Bar(x+offsety[3]+2,y+heigthoffont(font),
      widthoffont(font)-3,pocet*heigthoffont(font),
      dcolor[2])
  {vykreslí pozadí pro posuvník, aby tam nebyly žádné rušivé zbytky z minula
   (při zoomu)}
end;

procedure Inicializace;
var i,j,k:integer;
    ret,subret:string;
begin
  offsety[1]:=0;
  offsety[2]:=dx div 3;
  offsety[3]:=dx;

  zac:=1;
  akt:=1;

  pushmouse;
  mouseswitchoff;
  setactivepage(2);
  setvisualpage(2);
  KresliPanel;
end;

procedure Finalizace;
var i:integer;
begin
  SmazPanel;
  popmouse;
  {vrátí vše do původního stavu}
end;

procedure VypisSeznam(i1,i2:integer);
{vypíše natvrdo seznam záznamů v okně od pozice i1 do pozice i2}
var Idx:integer;
begin
  bar(x+1,y+i1*heigthoffont(font)+1,
      offsety[3],(i2-i1+1)*heigthoffont(font),
      dcolor[2]);
  {nejprve smažeme obdélník, který budeme překreslovat
   je to rychlejší a elegantnější než to dělat po řádcích a zvlášť}

  for Idx:=i1 to i2 do
    vypistext(idx);
  {nyní do toho pouze vepíšeme samotné texty}
end;

procedure Rolovani;
{pokud se změnil počátek vykreslováni seznamu souborů, pokusí se tato
 procedura překreslit obrazovku tak šikovně, aby se nemusel moc vypisovat
 seznam textů (použije k tomu efekt rolování, kterým posune ty záznamy,
 které se na obrazovce pouze posunou a zbylé záznamy už bohuzel musí
 natvrdo vypsat)}
var Buf:pointer;
    Del:integer;
begin
  if Zac1=Zac then                      {pokud nemusím rolovat, neroluji}
    Exit;

  Posuvnik(false);                      {nejprve smažeme posuvník}

  if Abs(Zac1-Zac)>=Pocet then begin    {pokud to nelze jen odrolovat (je to}
    Zac:=Zac1;                            {příliš daleko), uprav začátek}
    VypisSeznam(1,Pocet)                  {a překresli to rovnou}
  end else begin                        {pokud se to pouze posunulo, můžeme}
    Del:=Pocet-Abs(Zac1-Zac);             {využít výhod rolování :}
    {kolik řádků se bude rolovat}
    NewImage(offsety[3],Del*heigthoffont(font),Buf);
    {vytvoříme si pro to prostor}

    if Zac1<Zac then begin              {odrolovalo-li to dolů}
      GetImage(X+1,Y+heigthoffont(font)+1,
               offsety[3],Del*heigthoffont(font),Buf);
      PutImage(X+1,Y+(Zac-Zac1+1)*heigthoffont(font)+1,Buf);
      {posuň obraz}

      Zac:=Zac1;
      {posuneme začátek na správné místo}
      VypisSeznam(1,Pocet-Del)
      {dopiš ručně text}
    end else begin                      {odrolovalo-li to nahoru}
      GetImage(X+1,Y+(zac1-zac+1)*heigthoffont(font)+1,
               offsety[3],Del*heigthoffont(font),Buf);
      PutImage(X+1,Y+heigthoffont(font)+1,Buf);
      {posuň obraz}

      Zac:=Zac1;
      {posuneme začátek na správné místo}
      VypisSeznam(Del+1,Pocet)
      {dopiš ručně text}
    end;

    DisposeImage(Buf)
    {zrušíme si přenosný buffer a to je vše}
  end;

  Posuvnik(true)
  {na konci patřičně opět vykreslíme posuvník}
end;

begin
  Inicializace;
  {inicializuje pamět a obrazovku}
  VypisSeznam(1,Pocet);
  Posuvnik(true);
  {na počátku vypiseme všechny položky a vykreslíme posuvník}
  repeat
    zvyraznitext(akt-zac+1);
    {zvýrazní aktuální objekt}

    mouseswitchon;
    repeat
      cekejnaudalost;
    until (akce<>2)or(akt<>akt1);
    mouseswitchoff;
    {čekej na událost tak dlouho, dokud se něco nestane
     pokud se pouze dostane příkaz na pohyb na sebe samotného, tak testujeme
     znovu, abychom zbytečně nehýbali rámečkem}

    zruszvyrazneni(akt-zac+1);
    vypistext(akt-zac+1);
    {vrátíme aktuální objekt do původního stavu,
     čímž máme seznam souborů opět celý "čistý"}

    rolovani;
    {vyvoláme speciální rolovací proceduru, která v případě nutnosti
     odroluje obrazovku s použitím co nejmenšího počtu úkonů}

    akt:=akt1;
    {upravíme si aktuální pozici}

    case akce of
      1:if akt<=m.pocet then if editujmistnost(m,akt) then begin
        zruszvyrazneni(akt-zac+1);
        vypistext(akt-zac+1);
      end;
      3:if pridejmistnost(m) then begin
        vypisseznam(1,pocet);
      end;
      4:if akt<=m.pocet then if smazmistnost(m,akt) then begin
        vypisseznam(1,pocet);
        kontrolujmeze(akt,zac);
      end;
      5:if akt<=m.pocet then editujikonu(m,akt);
      7:if akt<=m.pocet then viewmistnost(m,akt);
    end;

  until (akce=0)and(standardnidialog('Chceš opravdu skončit?',
    dcolor[1],dcolor[2],dcolor[3],dcolor[4],dcolor[5],font,ano_ne)=1);
  {konec na escape}

  Finalizace;
  {uklidí pamět a obrazovku}
end;

end.
