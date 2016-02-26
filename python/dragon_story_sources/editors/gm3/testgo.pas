unit TestGo;

interface

var JmenoHrdiny : string;
procedure TestWalk;

implementation

uses crt, graph256, soundpas, comfreq2, animace3, anmplay2, gmu3;

var
  palette2: pointer; {kdyz maji v mistnosti 2 obrazky ruznou paletu-
                      to je uvodni mistnost a je to tady takova anomalie;
                      v normalnim interpretu to nebude mozne...}
  back, brush1, brush2: pointer;
  PCO: byte; {= Pomocne Cislo Objektu}

  HotKey: char;

  S_BckgExist: boolean; {kvuli mistnostem v tomto demu- jestli je pozadi...}

  S_MouseOn: boolean; {Kdyz neni v mistnosti mys, je to 0, kdyz je, 1}

procedure InitProg; { Inicializuje grafiku, font, mys, paletu ..., promene }
{Krome prvnich tri radku ale nema s animaci nic spolecneho! je to jenom
 init programu}
begin
  ANMPath:= JmenoHrdiny+'.an5'; {V techhle souborech se budou hledat obrazky, animace...}
  PictPath:=JmenoHrdiny+'.an1';
  SamPath:= JmenoHrdiny+'.an3';

  SetVisualPage(0);
end;

procedure DemoInit;
var i1: byte;
begin
  New(I_FoundWay);
  {ve FoundWay je nalezena cesta, bude potreba porad, misto pro ni
   vyhradime uplne na zacatku a nechame ho naporad}

  PrepareAnimation;
  {pripravi animaci na zaregistrovani prvniho objektu}
  AnimBackColor:= 0;
  {nastavi barvu podkladu na 0}

  {Dracek je nulty animacni objekt}
  {Obalove volani pro zaregistrovani animacniho objektu typu Image:}
  AddImageAObj(PCO, {PCO je var, animace nam vrati cislo, ktere pridelila
                     objektu. Dracek je prvni, proto nam v PCO vrati nulu}
               20,  {priorita objektu}
               0,   {LastSprite=0, tzn. datova struktura v animaci bude
                     obsahovat jen jeden pointer. Vzhledem k praci s animaci
                     je nutne sem nastavit vzdy nulu}
               0,   {DisableErasing=0, tzn. objekt se bude vymazavat, pokud
                     se pohne nebo zmeni obrazek
                     kdyby bylo 1, nebude se animace starat, co je pod nim a
                     a ani se stary obrazek nevymaze, rovnou se pres to
                     placne novy}
               0, 0 {pocatecni souradnice X, Y}
               );

(*  ANMPath:= 'drek.an5'; {V techhle souborech se budou hledat obrazky, animace...}
  PictPath:= 'drek.an1';
  SamPath:= 'drek.an3';*)

  {Ted nahraju animacni sekvence, na prvni z nich v pameti se budu
   odkazovat cislem 1, na druhou 2, atd. Po nahrani nejsou sekvence
   spustene}
  for i1:=2 to 21 do LoadAnimationSeq(i1);
{  LoadAnimationSeq(10);
  for i1:=18 to 25 do LoadAnimationSeq(i1);}

  {Kazda sekvence ma v pameti jakousi datovou strukturu. Neco z toho
   musim ted inicializovat}
  for i1:=1 to 20 do with A_SeqExtHead[i1]^ do begin
    UserProc:= FreeUserProc;
    AnimObj:= PCO; {Napr. musi mit sekvence prirazen urcity animacni objekt}
    MainHero:= 1;  {Protoze prave nahrane sekvence patri hl. hrdinovi,
                    oznacime je taky tak}
    InProcess:= 0;
  end;

(*  ANMPath:= '00final.an5'; {V techhle souborech se budou hledat obrazky, animace...}
  PictPath:= '00final.an1';
  SamPath:= '00final.an3';*)

  {To je dulezite, tim dame vedet, ze se nema hrat sampl. Kdyby tam nula
   nebyla, mohlo by se hrani inicializovat s nahodnymi cisly a hralo by
   to blbosti}
  A_NextPhaseNewSound:= 0;

  {Pri animaci je vzdy viditelna opacna stranka, nez je aktivni.
   Animacni mys s timto pocita a proto se musi stranky definovat
   prave takto.}
  SetActivePage(0);
  SetVisualPage(1);

  AnimMouseOn(0, 0, MouseImage);
  {Pozor, tahle rutinka alokuje v pameti dve mista o velikosti mysi,
   ktere se korektne dealokuji pouzitim AnimMouseOff}
end;

{Proc a nac tyto dve inicializace casu? V kostce: Do animacni sekvence se
 vzdy zapise cas prechodu na dalsi fazi. Na nasledujici fazi se prejde, az
 uplyne urcita doba od tohoto casu. Aby se mohlo pri inicializaci mistnosti
 vykreslit vse, co ma, oblafnu to tak, ze nejdriv nastavim cas trosku mensi,
 vsechno inicializuju a pred zacatkem provadeni mistnosti cas primerene zvysim,
 takze si bude myslet, ze uz ubehlo dost casu pro prechod na (jakoby dalsi)
 startovni fazi sekvence.
 Kapisto?}
procedure TimeInit2;
begin
  Time08^.TimerDW:= 10000;
end;
procedure TimeInit1;
begin
  Time08^.TimerWord1:= 0;
  Time08^.TimerDW:= 5000;
end;


procedure DemoDone;
var
  i1: byte;
begin
  While A_LastAnmSeq>0 do ReleaseLastAnimationSeq;
  {odinstaluju vsecky sekvence, co byly jeste v pameti. V tomto pripade
   se to ale tyka jen sekvenci dracka}

  ReleaseLastAObj;
  {Uvolnim anim. objekt draka, pres ktery byly animovany vsechny sekvence draka}

  AnimMouseOff;
  {Vypnu animacni mysku, uvolnim po ni pamet}
{  DisposeImage(MouseImage);}
  Dispose(I_FoundWay);
  {Viz DemoInit}
end;

procedure InitScreen;
var i1 : byte;
begin
  SetPalette(Palette);
  {Predpokladam, ze v Palette je paleta mistnosti}

  {A tady probehne (musi probehnout) jedno male kouzlo...}
  BackToVirginAObj(0);
{  for i1:= 0 to LastAObj do begin
    BackToVirginAObj(i1);
  end;}
  {vratil jsem vsem (to pro jistotu, dulezite by to bylo jen u tech,
  ktere vzdy zustavaji do dalsi stranky) animacnim objektum jejich puvodni
  cistotu a neposkvrnenost}

  InitHero(110,100);{X a Y}

  {Projedu vsechny sekvence a tem hlavniho hrdiny priradim prazdne
   volani a dam je, aby se neprovadely...}
  for i1:= 1 to A_LastAnmSeq do begin
    if(A_SeqExtHead[i1]^.MainHero> 0)then begin
      A_SeqExtHead[i1]^.UserProc:= FreeUserProc;
      if(A_SeqExtHead[i1]^.InProcess=1)then A_SeqExtHead[i1]^.InProcess:=0;
    end;
  end;
  {...protoze tady zapnu tu, ktera se provadet bude. Tady to je "kecani"}
  with A_SeqExtHead[ Ord(StujPravo) ]^ do begin
    InProcess:= 1;
  end;

{  VisibleAObj(1);}
  {Jedna je tady standardne pozadi; zviditelnim ho}

  {InitFir... udela to, ze pokud je sekvence InProcess=1, tak ji nastavi
   tak, aby byla vykreslena na obrazovku. InitFirstPhase se pouziva jedine
   tady!, pred prvnim vykreslenim screenu!
   (Pozn.: existuje taky StartPhase(SeqNum), ktera se pouziva k odstartovani
   sekvence kdykoli v prubehu programu. Ta je trochu odlisna, NASTAVI! rovnou
   InProcess na 1 a zaridi, aby se sekvence animovala hned pri pristim
   pruchodem NextPhase)}
  for i1:= 1 to A_LastAnmSeq do InitFirstPhase(i1);
  {projel jsem vsechny sekvence, cili vsechny co jsou InProcess=1, budou
   za chvili vykresleny}

  AnimBackColor:= 8;
  AnimEnableClearScreen:= 1;
  {1, jestlize se ma obrazovka pokazde smazat (napr. neni pozadi), anebo nyni,
   kdy se inicializuje a musi se vykreslit komplet cela a ne jen to, co se
   zmenilo}
  if S_MouseOn then  AnimMouseSwitchOff;
  {Pokud je v mistnosti myska, predpokladam, ze je zapnuta, takze ji vypnu}
  SmartPutAObjs;
  SwapAnimPages;
  SmartPutAObjs;
  {Inicializoval= potisknul jsem obe dve stranky}
  if S_MouseOn then  AnimMouseSwitchOn;
  {Znovu zapnu mysku}
  if S_BckgExist then AnimEnableClearScreen:= 0;
  {Pokud ma mistnost pozadi, je zbytecne, aby se screen pokazde mazal}
  AnimWhatObjectsMousePoints:= {Text}Image;
  {Myska nam ukazuje na objekty typu Image; viz. unit animace}
  {Inicializoval jsem obe dve stranky a nastavil jsem vse potrebne}
end;


procedure WalkOnMouse;
begin
  H_SightOnMouse:= 3;
  InitWay(H_FeetX, H_FeetY, MouseX, MouseY);
  GoByWay;
end;

procedure LoopScreen;
begin
  HotKey:= #13;
  InitScreen;
{  SoundInitPlay;}
  repeat {---------- hlavni smycka -------------}

    Inc(Time08^.TimerDW, 4);
    Body;
    if MouseKey=1 then begin
      WalkOnMouse;
    end;
{    BodyWait; }
    if(KeyPressed)then HotKey:=ReadKey;

  until (HotKey=#27)or(MouseKey=2);
{  SoundDonePlay;}
end;

{**********************************************************************}

{**********************************************************************}

procedure InitKnajpa;
begin
  S_BckgExist:= True{False;};
  S_MouseOn:= True;
  S_Persp0:=mist^.PAbs;
  S_PerspStep:=mist^.PLin;

  S_WalkMap:=Mist^.GoMap;
  Back:=Mist^.Image;
  AddImageAObj(PCO, 1, 0, 1, 0, 0);
  AddSpriteToObj(PCO, 0, Back);
  VisibleAObj(PCO);
 {pozadi}

end;

procedure DoneKnajpa;
begin
  ClearScr(0);
  SetActivePage(ActivePage XOR 1);
  ClearScr(0);

  Sound_Channels^.i[0].ChSeg:=0;
  StopMusic;
  ReleaseLastAObj;
end;

procedure TestWalk;
begin
  InitProg;
  ComputeFrequency(I_Freq08InHz);
  SetFrequency(I_Freq08InHz);

  MouseOff;
  DemoInit;

  TimeInit1;
  InitKnajpa;
  TimeInit2;
  LoopScreen;
  DoneKnajpa;

  DemoDone;
end;

begin
end.
