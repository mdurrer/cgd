unit vars;
{obsahuje definice datovych struktur, tj. typu, konstant, promennych...}
{R_ = screen, H_ = hero, G_ = init vseobecne,
 A_ = promenne unitu anmplay}

interface

uses graform, graph256;

type
{****************************************************************************}

    PString = ^string;

    PByteArray1 = ^TByteArray1;
    TByteArray1 = array[1..65534] of byte;

    PIntegerArray1= ^TIntegerArray1;
    TIntegerArray1= array[1..10000] of integer;

    PProgram= ^TProgram;
    TProgram= TByteArray1;

    PCondition= ^TCondition;
    TCondition= TByteArray1;

{****************************************************************************}

  {hlavicka cele hry, ktera se na zacatku nacte:}
  TGameHd= record
    ActRoom: byte;    {aktualni mistnost, na zacatku: startovni mistnost}
    MapRoom: byte;    {mistnost, ktera jest mapou}
    ObjNum: integer;     {pocet objektu v cele hre}
    IcoNum: integer;     {pocet ikonek - vyjma "ikonky" cislo 0= standardni
                       kurzor, ta se sem nepocita!!}
    VarNum: byte;     {pocet promennych}
    PerNum: byte;     {pocet postavicek}
    DiaNum: byte;     {pocet rozhovoru}
    MaxIcoWidth, MaxIcoHeigth: integer;
    MusicLength: word;
    crc: array[1..4] of word;
  {***}
    BlockNum: integer;{pocet bloku dialogu v cele hre globalne}
  end;

  {v kazde mistnosti nactu pole, ktere pro kazdou masku obsahuje tento zaznam:}
  TMaskHd= record
    StoreNum: word;
    X, Y: integer;
    Prior: byte;
  end;
  {a toto je to pole:}
  TMaskHdArray= array[1..1000]of TMaskHd;
  PMaskHdArray= ^TMaskHdArray;

  {kazda mistnost ma takovyto zaznam, ktery na zacatku vyplnim}
  {"zavadeci hlavicka" mistnosti}
  TRoomHd= record
    Prog: PProgram;           {vsecky ostatni programky}
    ProgLen: word;            {dylka pole programku}
    Title: PString;           {to, co se zatim nebude vypisovat}
    {***}

    Music, Map, Pal: byte;    {cislo palety, mapy ze skladu; cislo hudby}
    NumMasks: integer;        {pocet masek v mistnosti}
    Init, Look, Use, CanUse: integer; {index zacatku jednotlivych}
                                      {programku v poli programku}
    ImInit, ImLook, ImUse: boolean;   {esli to muzu vykonat immediately}
    MouseOn, HeroOn: boolean; {je/neni drak, mys}
    Persp0, PerspStep: real;  {pro perspektivu draka}
    EscRoom: byte;            {cislo mistnosti pro vypadnuti na ESC}
                              {pokud 0(nula), neda se vypadnout}
                              {padat se bude standardne branou 1(jedna)}
    NumGates: byte;
    Gate: array[1..255]of integer;
  end;

  {takovou hlavicku kazdeho objektu naloaduju do pomocneho mista v pameti
   a nastavim podle ni potrebne:}
  PObjHd= ^TObjHd;
  TObjHd= record
    Init, Look, Use, CanUse: integer; {index zacatku jednotlivych}
                                      {programku v poli programku}
    ImInit, ImLook, ImUse: boolean;   {esli to muzu vykonat immediately}
    WalkDir: byte;            {"walk direction" 1=nemeni ikonu, 2, 3, 4, 5- meni}
                              {ikonu na prislusny smer}
    Priority: byte;           {nacpak asi?}

    IdxSeq, NumSeq: integer;  {index prvni animace ve skladu animaci}
                              {pocet sekvenci, ktere objektu nalezeji,
                              {kvuli dimenzovani tabulky}


    LookX, LookY, UseX, UseY: integer;
    LookDir, UseDir: byte;

    {***}
    AbsNum: integer;          {abs. cislo objektu v cele hre}
    AnimObj: byte;            {cislo anim. objektu, kteremu nalezi}
    SeqTab: PIntegerArray1;      {prevodni tabulka nalezejicich anim. sekvenci-
                               cislo sekvence objektu>skutecne cislo sekvence}
    Prog: PProgram;           {vsecky programky}
    Title: PString;           {to, co se vypise, kdyz na to najedu mysi}
    ProgLen: word;            {delka pole programku kuli dealokaci pameti}
    {cislo titulku i programku odvodim z globalniho cisla objektu}
    {label a programky jsou ulozene v jednom bloku}
  end;

  TObjHdArray= array[1..1000] of TObjHd;
  PObjHdArray= ^TObjHdArray;

  TPObjHdArray= array[1..1000] of PObjHd;
  PPObjHdArray= ^TPObjHdArray;

  TIcoHd= record
    Init, Look, Use, CanUse: integer; {index zacatku jednotlivych}
                                      {programku v poli programku}
    ImInit, ImLook, ImUse: boolean;   {esli to muzu vykonat immediately}


    {***}
    Prog: PProgram;           {vsecky programky}
    ProgLen: word;
    Title: PString;           {to, co se vypise, kdyz na to najedu mysi}
    {cislo labelu i programku odvodim z globalniho cisla ikonky}
    {label a programky jsou ulozene v jednom bloku}
  end;

  TIcoHdArray= array[1..1000] of TIcoHd;
  PIcoHdArray= ^TIcoHdArray;

  {kazda kecajici postavicka ma v pameti po celou hru tento zaznam:}
  TPersonHd= record
    X, Y: integer;
    FonColor: byte;
  end;
  TPersonHdArray= array[1..1000] of TPersonHd;
  PPersonHdArray= ^TPersonHdArray;

  {rozhovory:}
  TDialBlock= record
    Title: PString;
    CanBlock: pointer;
    Prog: pointer;
    CanLen, ProgLen: word;
  end;
  TDialogue= array[1..1000] of TDialBlock;
  PDialogue= ^TDialogue;

{****************************************************************************}

  TDebugChapter= (Info_Basic, Info_Memory, Info_Anim, Info_SaveScr);

  TDebugInfo= record
    ProgMem, InitGameMem, InitRoomMem: longint;
      {volna pamet na zacatku hry, volna pamet na zacatku mistnosti}
    ActRoomMem: longint;
      {co nejmene volne pameti v aktualni mistnosti}
    GlobalMinMem, GlobalMaxMem: longint;
      {co nejmene/nejvice volne pameti v nejake mistnosti}
    GlobalMinRoom, GlobalMaxRoom: byte;
      {ta ktera mistnost}
  end;

  TControlFeature= (Control_Nothing, Control_MusicVolume,
                    Control_VoiceVolume, Control_TextSpeed);
  TControlSettings= record
    MusicVolume, VoiceVolume, TextSpeed: byte;
  end;

{****************************************************************************}

  {nasledujici typek musim definovat, abych mohl sejvnout u probuhajici
   animace draka jeji hodnotu UserProc:}
  TUserProc= (UP_GoAfterCurve, UP_GoBeforeFinal, UP_GoByWay, UP_FreeUserProc);

  {kdyz vyskakuju z Loop, dam najevo, co vlastne chci:}
  TQuitMessage= (Msg_NextRoom, Msg_QuitGame, Msg_InitMap, Msg_DoneMap,
                 Msg_LoadGame, Msg_SaveGame, Msg_None, Msg_ConfirmedQuitGame);

  TLoopStatus= (Gate, Ordinary, Inventory, Dialogue, Talk, Strange, Fade);{viz G_LoopStatus}

  {vyjmenovany typ, abych nemusel psat: StartPhase(1) a mohl hezky
   jasne StartPhase(Ord(DM_Down)) >>vzdy vim, co pisu...}
  TDragonMoves= (DM_Undefined, DM_Down, DM_Up, DM_Right, DM_Left,
                 DM_RightDown, DM_RightUp, DM_LeftDown, DM_LeftUp,
                 DM_DownRight, DM_UpRight, DM_DownLeft, DM_UpLeft,
                 DM_LeftRight, DM_RightLeft, DM_UpStopLeft, DM_UpStopRight,
                 DM_SpeakRight, DM_SpeakLeft, DM_StopRight, DM_StopLeft);

  {drive jsem vykonaval akci na "destinaci" pomoci proceduralniho typu,
   ten ale nesel sejvovat. Takze jsem zavedl jedinou akci na "rdestinaci",
   a ta rozhodne podle hodnoty promenne nasledujiciho typu, co delat:}
  TWhatToDoOnDest= (Do_Nothing, Do_RunProg, Do_QuitLoop);

{****************************************************************************}

  PAnimation= ^TAnimation;
  {popis animacnich sekvenci; pracuje s tim hlavne anmplay...}
  {takhle vypadajici animacni sekvence lezou z aomakera:}
  TAnmPhase= record
    Picture      : word;        {cislo obrazku ze skladu}
    X            : integer;     {souradnice x}
    Y            : integer;     {souradnice y}
    ZoomX        : word;        {zoom na ose x}
    ZoomY        : word;        {zoom na ose y}
    Mirror       : byte;        {0=normal, 1=zrcadlit obrazek}
    Sample       : word;        {cislo samplu ze skladu}
    Frequency    : word;        {frekvence samplu}
    Delay        : word;        {zdrzeni pred dalsi fazi}
  end;
  TAnmHeader= record
    NumOfPhases    : byte;      {pocet fazi animace}
    MemoryLogic    : byte;      {0=vsechny sprajty jsou v pameti (napr. chuze hlavniho hrdiny)
                                 1=v pameti vyhrazeno misto pro nejvetsi
                                   sprajt a vsechny sprajty se nacitaji
                                   prave do tohoto mista (napr. okno, ktere je nejdriv cele,
                                   pak se rozbiji a nakonec je rozbite)
                                 2=sprajty se pricitaji z disku (napr. jak se hl. hrdina
                                   pro neco shyba, neco pouziva...)
                                   NEIMPLEMENTOVANO!}
    DisableErasing : byte;      {0=maze se pod, 1=nemaze se}
    Cyclic         : byte;      {0=zacit a skoncit, 1=cyklicka furt dokola}
    Relative       : byte;      {0=absolutni souradnice, 1=relativni}
  end;
  TAnmPhasesArray= array[1..255] of TAnmPhase;
  TAnimation= record
    Header         : TAnmHeader;
    Phase          : TAnmPhasesArray;
  end;

  PExtHeader= ^TAnmExtHeader;
  {a tenhle record potrebuju ke kazde anim. sekvenci pro ulozeni nekolika
   dalsich potrebnych dat}
  TAnmExtHeader= record  {rozsireni hlavicky animacni sekvence}
    InProcess      : byte;      {0 kdyz je v klidu a nepracuje se s ni, 1 kdyz uz bezi}
    AnimObj        : byte;      {k jakemu skutecnemu animacnimu objektu z animace
                                 patri tato sekvence}
    ActPhase       : byte;      {aktualni faze, ve ktere se sekvence nachazi}
    BigPict        : pointer;   {ukazatel na nejvetsi obrazek animace typu memory/disk}
    BigPictSize    : word;
    BigSam         : pointer;   {ukazatel na nejvetsi sampl animace typu memory/disk}
    BigSamSize     : word;
    UserProc       : procedure; {uzivatelske volani pote, co skonci sekvence}
    CountDelay     : longint;   {ulozi se sem hodnota TimerDW, jaka je, kdyz se faze
                                 prekresluje. Pro prechod na dalsi fazi se porovnava
                                 hodnota delay prave s (aktualni TimerDw- CountDelay)}
    MainHero       : byte;      {1= hlavni hrdina; ZoomX a ZoomY se budou brat
                                 podle perspektivy; pokud je animace cyklicka,
                                 ukonci se, az dojde to hodnot H_FinalX a H_FinalY}
  end;

  THeroHd= record
    OnDest: TWhatToDoOnDest;   {jakou akci vykonat na miste urceni...}
    OnDeProg: byte;            {pokud mam po dojiti na misto vykonat nejaky
                                program, tak cislo objektu v mistnosti, jehoz
                                program mam vykonat, 0=prog. mistnosti}
    OnDeIdx: integer;          {index zacatku toho programu}
    FeetX         : integer;   {souradnice nohou hl. hrdiny}
    FeetY         : integer;   { >prostredek spodni hrany< }
    SightOnMouse  : byte;      {kam se ma drak divat po dojiti na misto:
                                   0- neurceno: podle toho, odkud prisel
                                   1- na mysku: tam, kde puvodne klikla
                                   3- vpravo
                                   4- vlevo
                                   5- radobyinteligentne:pokud se kliklo mimo
                                      cestu-na mysku, na ceste-odkud prisel}
    MouseX        : integer;   {kde se kliklo mysi. To se porovna se sour.,}
                               {kam drak dosel a podle toho se kouka danym smerem}
    LastHorMove: TDragonMoves; {jestli sel pri poslednim pohybu pravo-levem
                                naposledy DM_Left, nebo DM_Right; na pocatku
                                DM_Undefined}
    BeforeWayX    : integer;   {souradnice X pred vykonanim cesty. Bere se v
                                uvahu, pokud se nerozhodne podle H_LastHorMove}
    FinSight      : byte;      {kam se ma koukat nam uplnem konci, mam matny pocit,
                                ze to pouziva procedurka GoBeforeFinal...}
    StartX        : integer;   {startovni souradnice, odkud jde-}
    StartY        : integer;   { -kvuli sikme chuzi}
    FinalX        : integer;   {finalni souradnice, kam ma dojit}
    FinalY        : integer;
    XOblStep      : real;      {velikost posunu v jedne souradnici ku te}
    YOblStep      : real;      {druhe souradnici; kvuli chozeni sikmo}
    XStrOblRatio  : real;      {pomer mezi delkou sikme cesty(uhloprickou)
                                a rovnou stranou. Kdyz jde sikmo, nasobi se
                                tim prirustek souradnice, aby pri sikme chuzi
                                udelal vic kroku nez kdyz jde rovne}
    YStrOblRatio  : real;
    WalkSide      : byte;      {na kterou stranu jde 0= DM_Up, 1= DM_Down,
                                2=DM_Right, 3=DM_Left}
    AfterCurve    : byte;      {cislo animace, ktera se zacne provadet po
                                zatoceni}
  end;


{****************************************************************************}

  {nasledujici vserikajici a mnemotechnicky nazev patri k go}
  {je to vypocitana trasa chuze:}
  PComputedPath=^TComputedPath;
  TComputedPath=array[1..1000]of record
    x, y: integer
  end;

{****************************************************************************}

{****************************************************************************}

{****************************************************************************}


const
HotKey_CrossIco=  '/';
HotKey_IcoLeft=   ',';
HotKey_IcoRight=  '.';

HotKey_TextSlow=  '=';
HotKey_TextQuick= '-';
HotKey_MusicLow=  '[';
HotKey_MusicHigh= ']';
HotKey_VoiceLow=  ';';
HotKey_VoiceHigh= '''';
HotKey_TextSlowest=  '+';
HotKey_TextQuickest= '_';
HotKey_MusicLowest=  '{';
HotKey_MusicHighest= '}';
HotKey_VoiceLowest=  ':';
HotKey_VoiceHighest= '"';


  MagicFadeDelay=5; {v setinach sekundy cas, ktery minimalne cekame
                     pred prechodem k dalsi fazi zmeny palety}

  MagicButtonWidth= 58;
  MagicMainMenuY= 178;
  MagicMainMenuButtons= 5;

  {po jak dlouhou dobu ma vyt mys neaktivni, aby se vyvolal batuzek:}
  MagicUnemployed=20;

  MagicBubMul= 40; {nasobek}
  MagicBubConst= 20; {tento cas se ceka konstantne nehlede na delku textu}

  {nasledujici rozmery a souradnice kvuli vykrasleni batohu:}
  MagicIcoWidth= 25;
  MagicIcoHeigth= 25;
  MagicInventCol= 7;
  MagicInventLin= 5;
  MagicInventX= 70;
  MagicInventY= 30;

  {barvy radku v dialogovem menu:}
  D_LineUnactive= 255;
  D_LineActive= 254;

  MagicControlAdd= 10;
  MagicControlSolid= 230;
  MagicControlFont= 255;
  MagicControlOutline= 0;
  MagicControlWidth= 100;
  MagicControlY= 70;

  MagicLMBackground= 226;
  MagicLMPictureOutline= 228;
  MagicLMUnactive= 225;
  MagicLMActive= 228;

{****************************************************************************}
  BeforeMapStatusPath: string[12]= 'savegame.map';
  SaveGamePath: string[12]= 'savegame.';

  ANMPath: string[12]= 'anim.dfw'; {cesta k animacnim sekvencim}
  PictPath: string[12]= 'obr_an.dfw';{k obrazkum pouzitym v animacnich sekvencich}

  SmallFontPath: string[12]= 'small.fon'; {uplna cesta pro font}
  BigFontPath: string[12]= 'big.fon'; {uplna cesta pro font}
  MapPath: string[12]= 'mapy.dfw'; {cesta pro mapu mistnosti}
  PalPath: string[12]= 'palety.dfw'; {obsahuje vsecky palety}
  ImgMaskPath: string[12]= 'obr_mas.dfw';  {obsahuje vsecky obrazky rozkouskovanych masek}
  IniRoomPath: string[12]= 'mist.dfw';     {obsahuje: x+0 TRoomHd x-te mistnosti,
                                                  x+1 titulek
                                                  x+2 inicializacni pole pro masky,
                                                  x+3 programky, vse x-te mistnosti}
  IniGamePath: string[12]= 'init.dfw';     {obsahuje: 1= pole status objektu,
                                                  2= pole status ikonek
                                                  3= poc. hodnoty promennych
                                                  4= TGameHd
                                                  5= pocty bloku dialogu
                                                  6= pole kecajicich postavicek}
  AuxGamePath: string[12]= 'hra.dfw'; {obsahuje: 1= zakladni kurzor mysi
                                                  2,3,4,5: levo, pravo, dole, hore
                                                  6: kurzor pro dialogy
                                                  7: zvyrazneny zakladni kurzor
                                                  8: kurzor pro main menu
                                                  9... : ikonky main menu}

  ObjectsPath: string[12]= 'objekty.dfw';  {obsahuje: x+0 hlavicka x-teho objektu,
                                                  x+1 title x-teho
                                                  x+2 programky x-teho objektu}
  ImgIconPath: string[12]= 'obr_ik.dfw'; {obsahuje obrazky ikonek}
  IconsPath: string[12]= 'ikony.dfw';    {obsahuje label&programky ikonek}
  StringsPath: string[12]= 'retezce.dfw';
  DialoguePath: string[12]= 'rozh'; {a pripona jest cislo toho rozhovoru}

{****************************************************************************}

  AnimRepaintPage: byte= 0;    {>0 je to jedine v okamziku, kdy chci z obrazovky
                                smazat debugovaci info, pak to hned SmartPut...
                                snizi az na nulu (po dvou prubezich)}
  G_FreeString: string[1]= '|'; {Prazdny retezec pro animacni rutinu}
  G_Cheat: string[5]= '.....'; {Retezec pro cheat kod}

  Control_On: TControlFeature= Control_Nothing; {je zobrazeny "ovladac" (zvuk, hudba, rychlost)}

  Debug_On: boolean= False;        {zapnuty debugovaci mod}
  Debug_Chapter: TDebugChapter= Info_Basic; {"Kapitola" a "stranka" debugacnich informaci}
  Debug_Page: byte= 1;                 { kapitoly: mapr. pamet, promenne, mistnost; kapitola
                                        muze mit vic stranek}
  Debug_ScrShot: byte= 0;

  G_ActCursor: byte= 1;        {tvar kurzoru: 1=normal, 2..5= sipky, 6=vyber
                                v dialogovem menu}
  G_ActIco: byte= 0;           {pokud je tvar kurzoru=1=normal, cislo ikony}
                               {0=normalni kriz, 1..n=ikonky}
  G_OldActIco: byte= 0;
  G_ActDia: byte= 0;           {aktualni prave vykonavany dialog}
  G_QuickHero: boolean= False;  {esli se ma drak pohybovat rychle}
  G_EnableQuickHero: boolean= True;
  G_EnableSpeedText: boolean= True;

  G_MainMenu: boolean= False;
  G_ActMusic: byte= 0;         {hudba, co prave hraje}
  G_OldMusic: byte= 0;         {hudba, co se hrala naposled}
  G_MusicOn: boolean= False;   {esliva hudba hraje, nebo ne-e}
  D_ActBlock: byte= 0;         {aktualne zpracovavany blok dialogu}

  G_Bubbles: boolean= true{False SR-05-04-19};    {vypisovat bubliny?}
  G_ChangeBubbles: boolean= False;  {kdyz menim predchozi v prubehu mluveni}
  G_NextBubbles: boolean= False;    { -""- }

  G_PushedNewRoom: byte= 0; {kvuli prikazum PushNewRoom, PopNewRoom....}
  G_PushedNewGate: byte= 0;
  
  G_CheatVisible: boolean= False;



{****************************************************************************}

  G_ShortestAnimDelay: word= 10; {doba mezi opetovnym prepnutim dvou}
                                 {animacnich stranek v setinach sekundy}

  A_MaxSeq= 50; {max. pocet animacnich sekvenci, pro ktere je tabulka}
  A_MaxSprites=150; {max. pocet sprajtu, pro ktery je tabulka}
  A_MaxSamples= 50; {max. poc. samplu, pro ktery jsou tabulky}

  A_LastLoadedPicture: byte= 0;
  A_LastLoadedSample:  byte= 0;  {posledni polozky v tabulkach}
  A_LastAnmSeq: byte= 0; {posledni animacni sekvence- cislo posledni polozky v
                             A_Sequences}
  A_NextPhaseNewSound: byte= 0; {priznak, jestli se v tomto prubehu animacni smyckou
                                 spousti sampl: 0- NE, 1- SPOUSTI SE}
  {inicializacni hodnoty prehravace sekvenci}

{****************************************************************************}

{****************************************************************************}

{****************************************************************************}

var
{****************************************************************************}

  A_Sequences: array[1..A_MaxSeq] of PAnimation;
  {pole adres animacnich sekvenci}
  A_SeqExtHead: array[1..A_MaxSeq] of PExtHeader;
  {pole adres rozsirenych hlavicek animacnich sekvenci}
  A_ActSeq: byte; {protoze mame nadefinovanou UserProc bez parametru,
                   cislo sekvence predame takto...}

{****************************************************************************}


{****************************************************************************}


{****************************************************************************}
{***                                  hra                                 ***}
{****************************************************************************}

  G_PaswPage, G_PaswLine, G_PaswWord: integer;

  G_Mark: byte; {velice dulezita promenna, na zacatku kazdeho programku
                 se nuluje, jinak by byla NEBEZPECNA!
                 Mame prikazy C_Mark a C_Release, ktere delaji s animacnimi
                 sekvencemi podobne veci jako Mark a Release s hromadou v Pascalu}

{*** klavesy, tlacitka, objekty nafurt, palety, obrazky nafurt... ***}

  G_HotKey, G_HotKey1: char;    {klavesa, co se chyta}
  G_MouseKey: byte;             {tlacitko mysky, co se chyta}
  G_SmallFont, G_BigFont: PFont;{malym fontem titulky, dialog. menu, velkym kecani}
  G_WorkPalette: PPalette;      {pracovni paleta; ve hre mam dve palety:
                                 aktualni Palette a tuto}
  G_PalDif, G_PalPred: PIntegerArray; {PIntegerArray je ^ na 0..767 of integer,
                                       dovazim to z graph256 kvuli zmenam palety!}
  G_DiagLineAObj, G_TitleAObj, G_BubbleAObj: byte; {cislo anim. objektu titulku a bubliny,
                                                    prvni lajny animacniho menu}
  G_Bubble: PString; {text bubliny, kterou kecaji postavicky}
  G_BubTime: longint;{cas, ktery se zaznamena na zacatku objeveni bubliny}
  G_Cursor: array[1..8] of pointer;   {1 stand. kurzor, 2-5 sipky, 6 dialog kurzor,
                                       7 zvyrazneny stand. kurzor, 8 main menu kurzor}

  G_MainMenuImage: array [1..MagicMainMenuButtons] of pointer;
  G_MainMenuAObj: byte; {prvni anim. objekt vyhrazeny hlavnimu menu}

  G_IcoImage: array[1..2] of pointer; {misto, kde bude obrazek aktualni ikony}
                                      {1 normal, 2 zvyraznena cervene}

{*** rizeni smycky ***}

  G_QuitLoop: boolean; {kvuli vyskakovani ze smycky "...Loop", ktera vse provadi}
  G_QuitMessage: TQuitMessage; {kdyz vyskakuju, da mi to vedet, proc...}
  G_LoopStatus: TLoopStatus; {stav prehravaci smycky, tj. esli je to obyc.
                              chuze, nebo se ceka na skonceni animace...}
                             {Ordinary= prozkoumavani,
                              Inventory=inventorar,
                              Dialogue=rozhovor}
  G_LoopSubStatus: TLoopStatus;{stav prehravaci smycky, tj. esli je to obyc.
                                chuze, nebo se ceka na skonceni animace...}
                               {Ordinary= nic zvlastniho se nedeje,
                                Talk= ceka se na dokecnuyi...}
  G_NewRoom, G_NewGate: byte; {jakou mistnost s jakou branou mam nahrat}
                              {pred vstupem do hlavnismycky se nastavi na 0(nula)}
                              {a ceka se, az to neco prenastavi, v takovem}
                              {pripade (ruzne od nuly) se prejde do dalsi...}
  G_FadePhases, G_FadeCounter: integer; {pro fejdovani palety}
  G_FadeTime: longint;        {cas, kdy jsme naposled presli k dalsi fazi}

{*** systemove herni promenne (hlavicka hry, objekty, ikony, promenne...) ***}

{s}  G_Hd: TGameHd; {hlavicka cele hry}
{s}  G_ObjStatus: PByteArray1; {stav vsech objektu, bity 0-6 cislo mistnosti}
                     {0..nenahravat, AWAY
                      bit7=0..nahrat, ale nezobrazit, OFF
                      bit7=1..nahrat, zobrazit ON }
  G_ObjConvert: PPObjHdArray; {konverzni tabulka hlavicek objektu}
                     {na objekt se vzdy odkazuju jeho globalnim cislem,
                      v pameti jsou ale vzdy jenom objekty pro danou mistnost;
                      pri nahravani objektu do pameti se vzdy vyplni pro
                      prislusny objekt...}
  G_ObjHero: TObjHd; {objekt hrdiny nebudeme veset na 1.polozku pole
                      G_ObjConvert (coz by samozrejme take slo), zachovame
                      radeji postup jako pri registrovani objektu v mistnosti
                      a definujeme kvuli tomu tuto promennou}
{s}  G_IcoStatus: PByteArray1; {stav vsech ikonek, 0=OFF, 1=ON}
{s}  G_Vars: PIntegerArray1; {pole vsech promennych, cisluju je od jedna!}
  G_DialogsBlocks: PIntegerArray1; {pole, ktere ma tolik polozek, jako je dialogu,
                                 na zacatku: kazda jeho polozka udava pocet bloku
                                 toho ktereho dialogu;
                                 hned po dimenzovani tabulky G_BlockVars
                                 modifikuju: x-ta polozka udava index x-teho
                                 dialogu do tabulky G_BlockVars}
{s}  G_BlockVars: PIntegerArray1; {pro kazdy blok dialogu to na zacatku nastavim
                                na 0(nulu) a pokazde, kdyz je blok vyvolan,
                                inkrementuju}
{?s}  G_Persons: PPersonHdArray; {pole kecajicich postav: souradnice, barva fontu...}

{s}  G_FoundWay: PComputedPath;   {spocitana cesta chuze}
{s}  G_WaySteps: integer; {pocet zbyvajicich useku spocitane cesty}

{?s}  G_IcoConv: PByteArray1;
                          {ikonky v batohu jsou naskladane v radcich
                           a sloupcich....}

{****************************************************************************}
{***                             hrdina                                   ***}
{****************************************************************************}

{s}  H_: THeroHd;         {obsahuje vsechny promenne potrebne zejmena pro
                           chuzi draka}
  H_OnDestination: procedure; {na zacatku programu standardne nastavim na
                               H_OneDeObal. To, co se vykona, pak zalezi
                               na hodnote H_.OnDest)

{****************************************************************************}
{***                           mistnost                                   ***}
{****************************************************************************}

  R_Hd: TRoomHd;          {obsahuje napr. pocet masek, cislo palety, mapy...}
  R_ObjNum: byte;         {pocet objektu v mistnosti}
  R_Objects: PObjHdArray; {pole objektu v dane mistnosti}
  R_WalkMap: pointer;     {mapa chuze pro mistnost}
  R_BckgExist: boolean;   {jestli ma mistnost pozadi, nastavim to podle poctu
                           masek...}
  R_MaskIni: PMaskHdArray;{dimenzuju podle poctu masek, nactu do toho init
                           (x, y, priorita) pro kazdou masku}
  R_UnLoadSeq: byte;      {pri vstupu do mistnosti zaznamenam cislo posledni
                           nainstalovane animace a pri vystupu odinstaluju
                           vsechny animace, ktere jsou nad ni, tj. nahraly
                           se v prubehu mistnosti}


{****************************************************************************}
{***                      inventorar (batoh)                              ***}
{****************************************************************************}

  I_Icons: PIcoHdArray; {nahrava se akorat, kdyz je batoh}
  I_Exit: boolean;   {kvuli vyskoceni z batohu na zadost nektereho programku}
  I_OldActPage: byte; {aktualni stranka pred zapnutim batohu}
  I_IcoUnderMouse, I_OldIcoUnderMouse: byte;
  I_TalkLines: byte; {pokud neco reknu v batohu, kvuli smazani textu mi
                      to sem zaznamena pocet radku textu}


{****************************************************************************}
{***                            dialogy                                   ***}
{****************************************************************************}

  D: PDialogue;      {ukazatel na rozhovor (pole hlavicek bloku)}
  D_BlockNum: byte;  {pocet bloku v dialogu}
  D_BlockConv: array[1..4]of byte; {ktery radek menu je ktery blok}
  D_Exit: boolean;   {kvuli vyskoceni z dialogu na zadost blokoveho programku}
{?!s}  D_LastBlock: byte; {naposled vykonany blok v aktualnim dialogu. Pri skoku
                      dovnitr dialogu se vzdy nuluje. Pouziva ho funkce
                      F_LastBlock}
  D_Begin: boolean;  {kdyz skacu do dialogu, nastavim na True, hned po prvnim
                      odkecanem bloku nastavim na False. Kvuli tomu, ze nektere
                      kecaci bloky muzou byt jen na zacatku- trebas predstaveni se...
                      Pouziva ho funkce F_AtBegin}
  D_Lines: byte;     {aktualni pocet radku v aktualnim dialogu, na zacatku
                      sestavovani menu je 0, hned pri vyberu se prubezne zvysuje}

{****************************************************************************}
{***                            ruzne                                     ***}
{****************************************************************************}

  TimerBody: longint;

  Debug_Info: TDebugInfo;
  Debug_OpenFiles: word;

  Control_Feature: TControlFeature;
  Control_Settings: TControlSettings;
  Control_Time: longint;

  G_SumLoopTimes, G_SumLoopPasses: longint;
  {pocitam tim, jak dlouho mi trva nakresleni jedne faze}

{****************************************************************************}


procedure FreeUserProc;
procedure LoopSetQuitTrue;
procedure Debug_UpdateInfo;
procedure Debug_UpdateOpenFiles;

implementation

procedure FreeUserProc;
begin
end;

procedure LoopSetQuitTrue;
begin
  G_QuitLoop:= True;
end;

procedure Debug_UpdateInfo;
begin
  if MemAvail<Debug_Info.ActRoomMem then begin
    Debug_Info.ActRoomMem:= MemAvail;
    AnimRepaintPage:= 2;
  end;
end;

procedure Debug_UpdateOpenFiles;
begin
  {This code used to periodically open c:\autoexec.bat (later p.exe) by a
  direct MS-DOS interrupt and compare the file handle / error code with the
  previous stored value.  if it was different, the whole screen was repainted
  instead of using heuristics of only repainting the changes:

  if openfile<>Debug_OpenFiles then begin
    Debug_OpenFiles:= openfile;
    AnimRepaintPage:= 2;
  end;

  my guess is that this made it possible to force repainting the screen by
  accessing that file from another process (e.g., deleting it).  I have deleted
  this code completely, because it's junk.}
  Debug_OpenFiles := 0;
end;

end.
