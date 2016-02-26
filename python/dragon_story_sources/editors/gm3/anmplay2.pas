{Bob: MUJ DEBILNI algoritmus na Go bych si vyprosil predelat, aby nepouzival
 to kravske pole `pole', jde to lepe, rychleji a s mensi pameti!!!!!}

{bacha! stale to u hrdiny nebere Prioritu podle Y souradnic !!!!!!}

{@@@@@@@@@@@}

unit anmplay2; {tato verze obsahuje i procedurky na chuzi z byvaleho unitu go}

interface

uses dfw, graph256, soundpas, comfreq2, animace3;

type
  TPohybyDraka= (Nedefinovano, Dolu, Nahoru, Vpravo, Vlevo,
                 PravoDolu, PravoHore, LevoDolu, LevoHore,
                 DolePravo, HorePravo, DoleLevo, HoreLevo,
                 MluvPravo, MluvLevo, StujPravo, StujLevo,
                 LevoPravo, PravoLevo, HoreStojLevo, HoreStojPravo);

  PAnimation= ^TAnimation;
  {takhle vypadajici animacni sekvence lezou z aomakera}
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
                                   pro neco shyba, neco pouziva...)}
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

  ppole=^tpole; {tenhle vserikajici a mnemotechnicky nazev patri k go}
  tpole=array[1..1000]of record
    x,y:integer
  end;

var
{S_ = screen, H_ = hero, I_ = init vseobecne,
 A_ = promenne tohoto unitu (anmplay), G_ = promenne byvaleho unitu go
 }
  I_SumLoopTimes, I_SumLoopPasses: longint;
  {pocitam tim, jak dlouho mi trva nakresleni jedne faze}
  I_SumDelays: byte;
  {Pokud je to pomalejsi, nez chci, nejprve to zvysim, az to bude
   pomalejsi po x-te, teprve potom snizuju frekvenci, atd...}

  I_FoundWay: ppole; {hledana cesta}

  S_WalkMap: pointer;
  S_Persp0, S_PerspStep: real;

  H_FeetX         : integer;   {souradnice nohou hl. hrdiny}
  H_FeetY         : integer;   { >prostredek spodni hrany< }
  H_SightOnMouse    : byte;      {kam se ma drak divat po dojiti na misto:
                                 0- neurceno: podle toho, odkud prisel
                                 1- na mysku: tam, kde puvodne klikla
                                 3- vpravo
                                 4- vlevo}

const

A_MaxSeq= 50; {max. pocet animacnich sekvenci, pro ktere je tabulka}
A_MaxSprites=150; {max. pocet sprajtu, pro ktery je tabulka}
A_MaxSamples= 50; {max. poc. samplu, pro ktery jsou tabulky}

LengthTAnmPhase= 17;          {delka zaznamu jedne animacni faze v bytes}
LengthTAnmHeader= 5;          {delka zaznamu hlavicky animace}
LengthTAnmExtHeader= 29;       {delka rozsireneho zaznamu hlavicky animace}

  A_LastLoadedPicture: byte= 0;
  A_LastLoadedSample:  byte= 0;  {posledni polozky v tabulkach}
  A_LastAnmSeq: byte= 0; {posledni animacni sekvence- cislo posledni polozky v
                             A_Sequences}
  A_NextPhaseNewSound: byte= 0; {priznak, jestli se v tomto prubehu animacni smyckou
                                 spousti sampl: 0- NE, 1- SPOUSTI SE}
  {inicializacni hodnoty prehravace sekvenci}


  I_Freq08InHz: word= 10000; {nastavena frekvence osmicky}
  I_SoundDevice: TOutDevice= Blaster;
  I_ShortestAnimDelay: word= 10; {doba mezi opetovnym prepnutim dvou}
                                 {animacnich stranek v setinach sekundy}


var
ANMPath, SamPath, PictPath: string;
{uplna cesta ke skladu obrazku - zatim kuli animacim  "memory/disk" }

  A_Sequences: array[1..A_MaxSeq] of PAnimation;
  {pole adres animacnich sekvenci}
  A_SeqExtHead: array[1..A_MaxSeq] of PExtHeader;
  {pole adres rozsirenych hlavicek animacnich sekvenci}

  procedure FreeUserProc; {prazdne uzivatelske volani}
  procedure InitFirstPhase(SeqNum: byte); {Init sekvence na zacatku screenu}
  procedure StartPhase(SeqNum: byte);  {Spusteni sekvence}
  procedure NextPhase(SeqNum: byte); {Prechod na dalsi fazi}
  procedure Body;
  procedure BodyWait;
  procedure LoadAnimationSeq(Item: word);
  procedure ReleaseLastAnimationSeq;

  procedure InitHero(HeroX, HeroY: integer);{inicializace hrdiny}
  procedure DisposeMap(var map : pointer);
  procedure InitWay(x1, y1, x2, y2: integer);
  procedure GoAfterCurve;
  procedure GoBeforeFinal;
  procedure GoByWay;

implementation
const
  A_HeroContinue: boolean= False; {takova pekna promenna. Pote, co se zavola
                     UserProc, testuje se tato promenna. Pokud True, nevyskoci
                     se z NextPhase a faze pokracuje. O nastaveni tehle promenne
                     se musi postarat prave UserProc. NextPhase si ji bezprostredne
                     po otestovani nastavi opet na False}
var
  H_MouseX        : integer;   {kde se kliklo mysi. To se porovna se sour.,}
                               {kam drak dosel a podle toho kouka danym smerem}
  H_BeforeWayX    : integer;

  H_LastHorMove   : TPohybyDraka; {jestli sel pri poslednim pohybu pravo-levem
                                   naposledy vlevo, nebo vpravo; na pocatku
                                   Nedefinovano}
  H_FinSight      : byte;

  H_StartX        : integer;   {startovni souradnice, odkud jde-}
  H_StartY        : integer;   {kvuli sikme chuzi}
  H_FinalX        : integer;   {finalni souradnice, kam ma dojit}
  H_FinalY        : integer;
  H_XOblStep      : real;      {velikost posunu v jedne souradnici ku te}
  H_YOblStep      : real;      {druhe souradnici; kvuli chozeni sikmo}
  H_XStrOblRatio  : real;      {pomer mezi delkou sikme cesty(uhloprickou)
                                a rovnou stranou. Kdyz jde sikmo, nasobi se
                                tim prirustek souradnice, aby pri sikme chuzi
                                udelal vic kroku nez kdyz jde rovne}
  H_YStrOblRatio  : real;
  H_WalkSide      : byte;      {na kterou stranu jde 0= nahoru, 1= dolu,
                                2=vpravo, 3=vlevo}
  H_AfterCurve    : byte;      {cislo animace, ktera se zacne provadet po
                                zatoceni}

{v nasledujich polich jsou ulozeny ty adresy, jak je nize popsano. Vicemene
 je to takhle reseno proto, aby v pameti nebylo nic zbytecnyho (samozrejme
 prave krome tech poli...)
 Jak to bude fungovat:
 Adresa kazdyho obrazku, samplu, co je natrvalo v pameti se ulozi do tohoto
 pole. Kdyz se budou nacitat dalsi natrvalo v pameti ulozene sekvence, pri
 nacitani se overi, jsetli uz obr. v pameti neni. Jestli ne, nahraje se;
 jestlize uz tam je, jenom se priradi adresa- vice viz. LoadAnimationSeq...}
  Sprites: array[1..A_MaxSprites] of pointer;
  {pole adres sprajtu pouzitych v sekvencich, co jsou cele psany nastalo pro pamet}
  StoreSprNum: array[1..A_MaxSprites] of word;
  {pole skladovych cisel sprajtu pouzitych v sekvencich, co jsou cele psany nastalo pro pamet}
  SpritesUses: array[1..A_MaxSprites] of byte;
  {ke kazdemu ulozenemu sprajtu je zde, kolikrat je pouzit. Pri odinstalovani se toto
   stale zmensuje, a az dojde k 0, teprve se odinstaluje}
  Samples: array[1..A_MaxSamples] of pointer;
  {pole adres samplu pouzitych v sekvencich, co jsou cele psany nastalo pro pamet}
  StoreSamNum: array[1..A_MaxSamples] of word;
  {pole sklad. cisel  samplu pouzitych v sekvencich, co jsou cele psany nastalo pro pamet}
  SamplesUses: array[1..A_MaxSprites] of byte;
  {ke kazdemu ulozenemu samplu je zde, kolikrat je pouzit. Pri odinstalovani se toto
   stale zmensuje, a az dojde k 0, teprve se odinstaluje}
  SamSizs: array[1..A_MaxSamples] of word;
  {pole delek samplu pouzitych v sekvencich, co jsou cele psany nastalo pro pamet}

  NextPhaseSound: TOneChannel;
  {hodnoty, ktere se zapisou do promennych 0-teho kanalu po prehozeni stranek}

procedure FreeUserProc;
begin
end;

procedure InitFirstPhase(SeqNum: byte);
{Na zacatku screebu se musi kazda sekvence nejdriv takto inicializovat}
begin
  with A_SeqExtHead[SeqNum]^ do begin
    if InProcess= 0 then Exit;
    {Pokud neni aktivni, samozrejme se neinicializuje}
    {Inicializovat se musi tesne pred tim, nez chceme, aby byla aktivni}
    CountDelay:= Time08^.TimerDW- 1000;
    ActPhase:= 0;
    with A_Sequences[SeqNum]^.Phase[1] do begin
      if Picture> 0 then begin
        {pokud je rozumne cislo obrazku, zmenim sprajt, a to nasledovne:}
        if A_Sequences[SeqNum]^.Header.MemoryLogic= 0 then begin
           {pokud je sekvence typu "pamet" jenom dam novou adresu}
           AddSpriteToObj(AnimObj, 0, Sprites[Picture]);
        end else begin
          {jinak nactu sprajt do vyhrazeneho mista}
          CReadItem(PictPath, BigPict, Picture);
        end;
        VisibleAObj(AnimObj);
      end;
      if A_Sequences[SeqNum]^.Header.Relative= 0 then begin
        NewPosAObj(AnimObj, X, Y);
      {Pokud ma objekt absolutni souradnice, placne to na ne}
      end else if MainHero> 0 then begin
        {Pokud jde o hrdinu, provede se takto:}
        NewPosAObj(AnimObj,
          H_FeetX-
          {H_FeetX je vprostred, takze od ni odecteme pulku aktualni sirky draka}
            round(
            (S_Persp0+ H_FeetY*S_PerspStep)*
            {toto je faktor zvetseni pro radek, kde drak stoji}
            (PWordArray(Sprites[Picture])^[0] / 2)
            {faktorem vynasobime originalni sirku sprajtu a dostaneme}
            {sirku draka na souradnicich, kde je}
            ),
          H_FeetY-
          {Protoze H_FeetY je spodek nohou, souradnice hlavy budou nad}
          {nim, cili odecitame - aktualni vysku draka- ale ted jak:}
            round(
            (S_Persp0+ H_FeetY*S_PerspStep)*
            {toto je faktor zvetseni pro radek, kde drak stoji}
            PWordArray(Sprites[Picture])^[1]
            {faktorem vynasobime originalni vysku sprajtu a dostaneme}
            {vysku draka na souradnicich, kde je}
            )
          );
       {Ted by mel stat tam, kde ma}
      {Pokud jsou souradnice jenom obycejne relativni, musi se uz predem
       zadat pomoci NewPos...}
      end;
      if MainHero> 0 then begin
        {Hrdina je velky podle perspektivy}
        ZoomX:= round(  (S_Persp0+ H_FeetY*S_PerspStep)*
          PWordArray(Sprites[Picture])^[0] );
        ZoomY:= round(  (S_Persp0+ H_FeetY*S_PerspStep)*
          PWordArray(Sprites[Picture])^[1] );
      end;
      NewZoomAObj(AnimObj, ZoomX, ZoomY);
      NewMirrorAObj(AnimObj, Mirror);
    end;
    SetDisableErasingAObj(AnimObj, A_Sequences[SeqNum]^.Header.DisableErasing);
  end; {with A_SeqExtHead[SeqNum] }
end;

procedure StartPhase(SeqNum: byte);
{Spusteni sekvence}
begin
  with A_SeqExtHead[SeqNum]^ do begin
    SetDisableErasingAObj(AnimObj, A_Sequences[SeqNum]^.Header.DisableErasing);
    {Do jednoho objektu se muze promitat stridave vic sekvenci, takze to nastavim
     u objektu znovu podle hlavicky sekvence}
    InProcess:= 1; {nyni je aktivni}
    CountDelay:= Time08^.TimerDW- 1000;
    ActPhase:= 0;
    {aby to hned pri prvnim volani NextPhase preslo na fazi 1}
  end;
end;

procedure NextPhase(SeqNum: byte);
var
  _FeetX, _FeetY: integer;
begin
  with A_SeqExtHead[SeqNum]^ do begin
    if InProcess= 0 then Exit;
    {Pokud animacni sekvence neni aktivni, nepracuje se s ni}
    {R-}
    if (Time08^.TimerDW- CountDelay)>= A_Sequences[SeqNum]^.Phase[ActPhase].Delay then begin
      {OK, uz muzeme prejit na dalsi fazi}
      CountDelay:= Time08^.TimerDW;
      {Nastavime cas, kdy jsme presli na dalsi fazi, kvuli testovani Delay}
      if(MainHero>0)and(A_Sequences[SeqNum]^.Header.Cyclic= 1)and
      {V pripade, ze jde o cyklickou animaci hlavniho hrdiny, overim,
      jestli se uz hrdina nenachazi v predepsanem miste}
      ( (H_WalkSide=0)and(H_FeetY< (H_FinalY+
         ( (S_Persp0+ H_FeetY*S_PerspStep)*2)    )
          )or
        (H_WalkSide=1)and(H_FeetY>(H_FinalY-
         ( (S_Persp0+ H_FeetY*S_PerspStep)*2) )
          )or
        (H_WalkSide=2)and(H_FeetX> (H_FinalX-
         ( (S_Persp0+ H_FeetY*S_PerspStep)*5) )
          )or
        (H_WalkSide=3)and(H_FeetX< (H_FinalX+
         ( (S_Persp0+ H_FeetY*S_PerspStep)*5) )
      ) )then begin
      {zjistili jsme, ze hrdina je tam, kde mel byt...}
      {ty cisla, ktere nasobim faktorem perspektivy, jsou
       o neco mensi nez prumerne X a Y relat. souradnice u animace draka}

  {          InProcess:= 0;}
  {Nebudu to vypinat, to si obslouzi procedurka nad nami...}
        H_FeetX:= H_FinalX;
        H_FeetY:= H_FinalY;
        UserProc;
        if not A_HeroContinue then Exit;
        {pokud nebyl vydan prikaz, aby i dale pokracovala, skoncili jsme}
        A_HeroContinue:= False;
        {Pristi animace zacina opet s timto indikatorem na False.
         Pokud chce byt True, cili pokud se chce, aby i po zavolani
         UserProc animace pokracovala, musi si tento indikator nastavit
         na True prave UserProc.}
      end;

      if ActPhase= A_Sequences[SeqNum]^.Header.NumOfPhases then begin
      {obslouzim, kdyz jsme na konci sekvence}
        if A_Sequences[SeqNum]^.Header.Cyclic= 1 then begin
          ActPhase:= 1;
          {pokud je cyklicka, zacnu znovu od zacatku}
        end else begin
          InProcess:= 0;
          {vypne se, aby sem porad zbytecne neskakala}
          UserProc;
          Exit;
          {pokud neni cyklicka, skoncili jsme}
        end;
      end else begin
        Inc(ActPhase);
        {pokud nejsme na konci, prejdu na dalsi fazi}
      end;

      with A_Sequences[SeqNum]^.Phase[ActPhase] do begin
        {pracuji se zaznamem aktualni faze}
        if Picture> 0 then begin
          {pokud je rozumne cislo obrazku, zmenim sprajt, a to nasledovne:}
          if A_Sequences[SeqNum]^.Header.MemoryLogic= 0 then begin
             AddSpriteToObj(AnimObj, 0, Sprites[Picture]);
             {Kdyz je typu "memory", jenom hodim z pamete adresu dalsiho sprajtu}
          end else begin
            {jinak ale obslouzim typ "memory/disk"}
            CReadItem(PictPath, BigPict, Picture);
            {nacetl jsem sprajt do vyhrazeneho mista}
          end;
          RepaintAObj(AnimObj);
          {zmenil se sprajt, vydam prikaz k prekresleni animacniho objektu}
        end;
        if Sample> 0 then begin
        {pokud je rozumne cislo samplu, nastavim ho, aby hral}
          if A_Sequences[SeqNum]^.Header.MemoryLogic= 0 then begin
            NextPhaseSound.SizeCh:= SamSizs[Sample];
            NextPhaseSound.ChOfs:= Ofs(Samples[Sample]^);
            NextPhaseSound.ChActPos:= Ofs(Samples[Sample]^);
            NextPhaseSound.ChSeg:= Seg(Samples[Sample]^);
            {Pri "memory" jenom nastavim adresy jiz nahraneho}
          end else begin
            CReadItem(SamPath, BigSam, Sample);
            {pri "mem./disk" jsem nacetl jsem sampl do vyhrazeneho mista}
            NextPhaseSound.SizeCh:= UnpackedItemSize(SamPath, Sample);
            NextPhaseSound.ChOfs:= Ofs(BigSam^);
            NextPhaseSound.ChActPos:= Ofs(BigSam^);
            NextPhaseSound.ChSeg:= Seg(BigSam^);
          end;
            NextPhaseSound.ChVolume:= 51;
            {standardni hlasitost}
            NextPhaseSound.ChLoop:= 0;
            NextPhaseSound.ChLooped:= 0;
            NextPhaseSound.ChLenLp:= 2;
            {takhle je to kvuli tomu, aby samply na konci nepraskaly}
            NextPhaseSound.Krok:=  Hi(word   (round  (256* (Frequency/I_Freq08InHz) )  )   );
            NextPhaseSound.OvrLd:= Lo(word   (round  (256* (Frequency/I_Freq08InHz) )  )   );
            {podle frekvence osmicky nastavim aji vysku samplu}
            A_NextPhaseNewSound:= 1;
            {nula tady nam rekne, ze pri prehazovani stranek mam predat tyto hodnoty
             do promennych hraci rutiny}
        end;
        if A_Sequences[SeqNum]^.Header.Relative= 0 then begin
          NewPosAObj(AnimObj, X, Y);
          {Pokud jsou absolutni souradnice, neci co resit,}
          {ale co kdyz jsou relativni: ?}
        end else if MainHero> 0 then begin
          {Pokud jsou relativni a jedna se o animaci hlavniho hrdiny,
           pracujeme s H_Feet.. , kde jsou ulozeny jeho souradnice}
          begin
            _FeetX:= round( (S_Persp0+ H_FeetY*S_PerspStep)*X*H_XStrOblRatio);
            {Ve _FeetX je velikost relat. kroku nasobena faktory perspektivy
             a zesikmeni}
            if(H_XOblStep=0)then H_FeetX:= H_FeetX+ _FeetX
            {Pokud je "hlavni smer" v ose X, jenom prictu relat. krok
             k dosavadni souradnici}
            else H_FeetX:= H_StartX+ _FeetX+ round(H_XOblStep*Abs(H_FeetY- H_StartY));
            {Jinak se podivam, kolik bodu jsme uz usli od zacatku tohoto useku
             a tuto delkou vynasobim poctem bodu v teto ose pripadajicim na jeden
             bod useku v "hlavnim smeru"}

            _FeetY:= round( (S_Persp0+ H_FeetY*S_PerspStep)*Y*H_YStrOblRatio);
            if(H_YOblStep=0)then H_FeetY:= H_FeetY+ _FeetY
            else H_FeetY:= H_StartY+ _FeetY+ round(H_YOblStep*Abs(H_FeetX- H_StartX));
            {tady jsme dostali nove souradnice nohou}
            {a zadame podle nich souradnice leveho horniho rohu draka}
            NewPosAObj(AnimObj,
              H_FeetX-
              {H_FeetX je vprostred, takze k ni pricteme pulku aktualni sirky draka}
                round(
                (S_Persp0+ H_FeetY*S_PerspStep)*
                {toto je faktor zvetseni pro radek, kde drak stoji}
                (PWordArray(Sprites[Picture])^[0] / 2)
                {faktorem vynasobime originalni vysku sprajtu a dostaneme}
                {vysku draka na souradnicich, kde je}
                ),
              H_FeetY-
              {Protoze H_FeetY je spodek nohou, souradnice hlavy budou nad}
              {nim, cili odecitame - aktualni vysku draka- ale ted jak:}
                round(
                (S_Persp0+ H_FeetY*S_PerspStep)*
                {toto je faktor zvetseni pro radek, kde drak stoji}
                PWordArray(Sprites[Picture])^[1]
                {faktorem vynasobime originalni vysku sprajtu a dostaneme}
                {vysku draka na souradnicich, kde je}
                )
              );
           {Ted by mel stat tam, kde ma}
          end;
        end else begin
          {A pokud jsou souradnice jenom obycejne relativni, jednoduse
           se prictou rozdily X, Y}
          NewPosAObj(AnimObj,
            X+GetNewXAObj(AnimObj),
            Y+GetNewYAObj(AnimObj));
        end;
        if MainHero> 0 then begin
          {Hlavni hrdina se zmensuje podle perspektivy}
          ZoomX:= round(  (S_Persp0+ H_FeetY*S_PerspStep)*
            PWordArray(Sprites[Picture])^[0] );
          ZoomY:= round(  (S_Persp0+ H_FeetY*S_PerspStep)*
            PWordArray(Sprites[Picture])^[1] );
        end;
        NewZoomAObj(AnimObj, ZoomX, ZoomY);
        NewMirrorAObj(AnimObj, Mirror);
      end;
    end;
  end; {with A_SeqExtHead[SeqNum]^}
end;

procedure Body;
{toto je jakesi "telo", ktere je volano vzdy po urcitem case(nyni 1/10 sec),
 a ktere samo vola vsechno, co je potreba k prechodu na dalsi fazi a
 prehozeni stranek}
var
  f: byte;
begin
  for f:= 1 to A_LastAnmSeq do begin
    NextPhase(f);
  end;
  {projel jsem vsechny sekvence}
  SmartPutAObjs;
  {placnu to do neviditelne stranky}
  WaitVRetrace;
  SwapAnimPages;
  {ted prepnu stranky}
  WaitDisplay;

  if(A_NextPhaseNewSound=1) then begin
    {pokud mam nastavit zvuk, nastavim ho}
    A_NextPhaseNewSound:= 0;
    Sound_Channels^.i[0].ChSeg:=   0;
    {behem nastavovani radeji vypneme kanal s efekty}
    Sound_Channels^.i[0].ChVolume:= NextPhaseSound.ChVolume;
    Sound_Channels^.i[0].SizeCh:= NextPhaseSound.SizeCh;
    Sound_Channels^.i[0].ChLoop:= NextPhaseSound.ChLoop;
    Sound_Channels^.i[0].ChLooped:= NextPhaseSound.ChLooped;
    Sound_Channels^.i[0].ChLenLp:= NextPhaseSound.ChLenLp;
    Sound_Channels^.i[0].Krok:=  NextPhaseSound.Krok;
    Sound_Channels^.i[0].OvrLd:= NextPhaseSound.OvrLd;
    Sound_Channels^.i[0].ChOfs:= NextPhaseSound.ChOfs;
    Sound_Channels^.i[0].ChActPos:= NextPhaseSound.ChActPos;
    Sound_Channels^.i[0].ChSeg:=   NextPhaseSound.ChSeg;
    {az teprve ted muzu naladovat hodnoty primo do promennych 0. kanalu,}
    {aby to zaclo hrat zaroven s prepnutim faze}
  end;
  I_SumLoopTimes:= I_SumLoopTimes+ Time08^.TimerWord1;
  Inc(I_SumLoopPasses);
  {Tady prubezne pocitam, jak dlouho mi trva nakresleni jedne faze}
end;

procedure BodyWait;
begin
 if (Time08^.TimerWord1 )<= I_ShortestAnimDelay then begin
   repeat until (Time08^.TimerWord1 = I_ShortestAnimDelay);
 end; { Pavle, proc to nemuze byt v proc. BODY?}
 {No to nevim. Pavel.}
 Time08^.TimerWord1:= 0;
end;

procedure LoadAnimationSeq(Item: word);
{natahne do pameti animacni sekvenci}
var
  f, g, h: byte;
  BiggestPict, BiggestSam: word;
  SeqNum: byte;
begin
  Inc(A_LastAnmSeq);
  SeqNum:= A_LastAnmSeq;
  CLoadItem(ANMPath, pointer(A_Sequences[SeqNum]), Item);
  GetMem(A_SeqExtHead[SeqNum], LengthTAnmExtHeader);
  A_SeqExtHead[SeqNum]^.InProcess:= 0;
  A_SeqExtHead[SeqNum]^.MainHero:= 0;

  if A_Sequences[SeqNum]^.Header.MemoryLogic=0 then begin
    {vsechny obrazky v pameti}
    for h:= 1 to A_Sequences[SeqNum]^.Header.NumOfPhases do with A_Sequences[SeqNum]^.Phase[h] do begin
      {projdu vsechny faze}
      if Picture>1 then begin
        {v uvahu beru jenom platne cislo obrazku, kdyz je neplatne, fazi ignoruji}
        g:= 1;
        while(Picture<> StoreSprNum[g])and(g<=A_LastLoadedPicture) do Inc(g);
        {proberu uz nactene obrazky, jestli mezi nimi tento neni}
        if(g> A_LastLoadedPicture)or(g= A_LastLoadedPicture)and(Picture<> StoreSprNum[g])then begin
          {nactu obrazek, jeste v pameti neni}
          Inc(A_LastLoadedPicture);
          CLoadItem(PictPath, Sprites[A_LastLoadedPicture], Picture);
          {nacetl jsem sprajt}
          StoreSprNum[A_LastLoadedPicture]:= Picture;
          Picture:= A_LastLoadedPicture;
          SpritesUses[A_LastLoadedPicture]:= 1;
          {pocet pouziti obrazku nastavim zatim na 1}
        end else begin
          Picture:= g;
          {obrazek uz v pameti je, jenom zapisu jeho cislo}
          Inc(SpritesUses[g]);
          {a zvysim pocet pouziti obrazku}
        end;

      end else Picture:= 0;
    end;
    for h:= 1 to A_Sequences[SeqNum]^.Header.NumOfPhases do with A_Sequences[SeqNum]^.Phase[h] do begin
      {projdu vsechny faze}
      if Sample>1 then begin

        g:= 1;
        while(Sample<> StoreSamNum[g])and(g<=A_LastLoadedSample) do Inc(g);
        {proberu uz nactene samply, jestli mezi nimi tento neni}
        if(g> A_LastLoadedSample)or(g= A_LastLoadedSample)and(Sample<> StoreSamNum[g])then begin

          {nactu sampl, jeste v pameti neni}
          Inc(A_LastLoadedSample);
          CLoadItem(SamPath, Samples[A_LastLoadedSample], Sample);
          {nacetl jsem sampl}
          SamSizs[A_LastLoadedSample]:= UnpackedItemSize(SamPath, Sample);
          StoreSamNum[A_LastLoadedSample]:= Sample;
          Sample:= A_LastLoadedSample;
          SamplesUses[A_LastLoadedSample]:= 1;
          {pocet pouziti samplu nastavim zatim na 1}
        end else begin
          Sample:= g;
          {sampl uz v pameti je, jenom zapisu jeho cislo}
          Inc(SamplesUses[g]);
          {a zvysim pocet pouziti samplu}
        end;
      end else begin
        Sample:= 0;
      end;
    end;

  end else begin
    {kdyz to pouze v pameti vyhradi misto a taha to do neho}
    BiggestPict:= 0;
    for f:= 1 to A_Sequences[SeqNum]^.Header.NumOfPhases do with A_Sequences[SeqNum]^.Phase[f] do begin
      if Picture>1 then begin
        g:= 0;
        repeat Inc(g) until Picture=A_Sequences[SeqNum]^.Phase[g].Picture;
        if g=f then if UnpackedItemSize(PictPath, Picture)>BiggestPict then
          BiggestPict:= Picture;
      end else Picture:= 0;
    end;
    A_SeqExtHead[SeqNum]^.BigPictSize:= UnpackedItemSize(PictPath, BiggestPict);
    GetMem(A_SeqExtHead[SeqNum]^.BigPict, A_SeqExtHead[SeqNum]^.BigPictSize);
    BiggestSam:= 0;
    for f:= 1 to A_Sequences[SeqNum]^.Header.NumOfPhases do with A_Sequences[SeqNum]^.Phase[f] do begin
      if Sample>1 then begin
        g:= 0;
        repeat Inc(g) until Sample=A_Sequences[SeqNum]^.Phase[g].Sample;
        if g=f then if UnpackedItemSize(SamPath, Sample)>BiggestSam then
          BiggestSam:= Sample;
      end else Sample:= 0;
    end;
    A_SeqExtHead[SeqNum]^.BigSamSize:= UnpackedItemSize(SamPath, BiggestSam);
    GetMem(A_SeqExtHead[SeqNum]^.BigSam, A_SeqExtHead[SeqNum]^.BigSamSize);
    {alokuju pamet pro nejvetsi ze vsech sprajtu}
    {nacetl jsem sprajt}
  end;
end;

procedure ReleaseLastAnimationSeq;
var
  f, g, h: byte;
  BiggestPict, BiggestSam: word;
begin
  if A_Sequences[A_LastAnmSeq]^.Header.MemoryLogic=0 then begin
    {vsechny obrazky v pameti}
    for h:= A_Sequences[A_LastAnmSeq]^.Header.NumOfPhases downto 1 do
    with A_Sequences[A_LastAnmSeq]^.Phase[h] do begin
      {projdu vsechny faze}
      if Picture>0 then begin
        {v uvahu beru jenom platne cislo obrazku, kdyz je neplatne, fazi ignoruji}
        Dec(SpritesUses[Picture]);
        if (SpritesUses[Picture])= 0 then begin
          StoreSprNum[Picture]:= 0;
          DisposeImage(Sprites[Picture]);
          Dec(A_LastLoadedPicture);
        end;
      end;
    end;
    for h:= 1 to A_Sequences[A_LastAnmSeq]^.Header.NumOfPhases do with A_Sequences[A_LastAnmSeq]^.Phase[h] do begin
      {projdu vsechny faze}
      if Sample>0 then begin
        Dec(SamplesUses[Sample]);
        if (SamplesUses[Sample])= 0 then begin
          StoreSamNum[Picture]:= 0;
          FreeMem(Samples[Sample], SamSizs[Sample]);
          Dec(A_LastLoadedSample);
        end;
      end;
    end;

  end else with A_SeqExtHead[A_LastAnmSeq]^ do begin
    {kdyz to pouze v pameti vyhradi misto a taha to do neho}
    FreeMem(BigPict, BigPictSize);
    {alokuju pamet pro nejvetsi ze vsech sprajtu}
    FreeMem(BigSam, BigSamSize);
    {alokuju pamet pro nejvetsi ze vsech sprajtu}
    {nacetl jsem sprajt}
  end;
  FreeMem(A_Sequences[A_LastAnmSeq],
   LengthTAnmPhase*A_Sequences[A_LastAnmSeq]^.Header.NumOfPhases+LengthTAnmHeader);
  FreeMem(A_SeqExtHead[A_LastAnmSeq], LengthTAnmExtHeader);
  Dec(A_LastAnmSeq);
end;



(*******************************************************************)

(*                       GO                                        *)

(*******************************************************************)

const
  delta= 4; {roztec mapy u chuze}
var
  pocet: integer; {pocet useku nalezene cesty}

procedure InitHero(HeroX, HeroY: integer);
{inicializuje vnitrni promenne hrdiny tak, aby stal na miste}
begin
  H_FeetX:= HeroX;
  H_FeetY:= HeroY;

  H_FinalX:= H_FeetX;
  H_FinalY:= H_FeetY;
  H_StartX:= H_FeetX;
  H_StartY:= H_FeetY;

  H_XOblStep:= 0;
  H_YOblStep:= 0;
  H_XStrOblRatio:= 1;
  H_YStrOblRatio:= 1;
  H_WalkSide:=255;
end;

procedure DisposeMap(var map : pointer);
{Uvolni mapu z pameti, NO COMMENT}
begin
  FreeMem(map,PWordArray(map)^[6]*PWordArray(map)^[5]+14)
end;

function  GetPixelMap(X,Y : word;map:pbytearray):boolean; assembler;
asm
  push ds                    {vypocet indexu map^}
  mov bx, word ptr map
  mov ds, word ptr map+2
  mov ax,ds:[bx+12]   {sirka 1 zaznamu}
  mul y               {vynasobit cislem radku, mame offset zacatku radku}
  add bx,14           {preskoceni hlavicky}
  add bx,ax           {presuneme se na tento zacatek radku}
  mov ax,x            {vezmeme pozici x}
  mov cl,al
  and cl,7            {vypocet x modulo 8 pro urceni cisla bitu}
  shr ax,3
  add bx,ax           {pricteme vyDIVenou 8 k offsetu}

  mov al,1
  shl al,cl

  and al,byte ptr ds:[bx]    {vyANDovani daneho bitu podle obsahu pameti}
  jz  @nulove                {0..nic se nedeje, konec, vysl je v al=0}
  mov al,1                   {else..konec, ve vysledku v al=1}
@nulove:
  pop ds                     {obnovime registry ds, konec}
end;

procedure PutPixelMap(X,Y:integer;co:boolean;map:pbytearray); assembler;
{predpokl. se x=<1..rx> stejne tak y a procedura si sama odecte 1}
asm
  push ds                    {vypocet indexu map^}
  mov bx, word ptr map
  mov ds, word ptr map+2

  mov ax,ds:[bx+12]   {sirka 1 zaznamu}
  mul y               {vynasobit cislem radku, mame offset zacatku radku}
  add bx,14           {preskoceni hlavicky}
  add bx,ax           {presuneme se na tento zacatek radku}
  mov ax,x            {vezmeme pozici x}
  mov cl,al
  and cl,7            {vypocet x modulo 8 pro urceni cisla bitu}
  shr ax,3
  add bx,ax           {pricteme vyDIVenou 8 k offsetu}

  mov al,1
  shl al,cl
  mov cl,byte ptr ds:[bx] {nacteni zadaneho bajtu}

  cmp co,0
  je  @nulovat
  or cl,al                   {nastavovani bitu}
  jmp @zapis
@nulovat:
  not al                     {nulovani bitu}
  and cl,al
@zapis:
  mov byte ptr ds:[bx],cl    {vraceni zpet}
@konec:
  pop ds
end;


procedure AdjustXYByCircle (var x_stred, y_stred: integer; barva:byte);
  var
    f: byte;
    polomer: word;
    predikce, dx, dy, x, y: integer;
    TestX, TestY: integer;

  function TestXYOnScr: boolean;
  begin
    TestXYOnScr:= false;
    if TestX> 319 then exit;
    if TestX< 0 then exit;
    if TestY> 199 then exit;
    if TestY< 0 then exit;
    TestXYOnScr:= true;
  end;

  procedure xoruj_symetricke_body;
    begin
      TestX:= x_stred + x;
      TestY:= y_stred + y;
{if TestXYOnScr then XorPixel (TestX, TestY, barva);}
      if TestXYOnScr and GetPixelMap(TestX div delta,TestY div delta,S_WalkMap) then exit;
      if x<>0 then begin
        TestX:= x_stred - x;
        TestY:= y_stred + y;
{if TestXYOnScr then XorPixel (TestX, TestY, barva);}
        if TestXYOnScr and GetPixelMap(TestX div delta,TestY div delta,S_WalkMap) then exit;
      end;
      if y<>0 then begin
        TestX:= x_stred + x;
        TestY:= y_stred - y;
{if TestXYOnScr then XorPixel (TestX, TestY, barva);}
        if TestXYOnScr and GetPixelMap(TestX div delta,TestY div delta,S_WalkMap) then exit;
        if x<>0 then begin
          TestX:= x_stred - x;
          TestY:= y_stred - y;
{if TestXYOnScr then XorPixel (TestX, TestY, barva);}
          if TestXYOnScr and GetPixelMap(TestX div delta,TestY div delta,S_WalkMap) then exit;
        end;
      end;
      if (x=y)then exit;
      TestX:= x_stred + y;
      TestY:= y_stred + x;
{if TestXYOnScr then XorPixel (TestX, TestY, barva);}
      if TestXYOnScr and GetPixelMap(TestX div delta,TestY div delta,S_WalkMap) then exit;
      if y<>0 then begin
        TestX:= x_stred - y;
        TestY:= y_stred + x;
{if TestXYOnScr then XorPixel (TestX, TestY, barva);}
        if TestXYOnScr and GetPixelMap(TestX div delta,TestY div delta,S_WalkMap) then exit;
      end;
      if x<>0 then begin
        TestX:= x_stred + y;
        TestY:= y_stred - x;
{if TestXYOnScr then XorPixel (TestX, TestY, barva);}
        if TestXYOnScr and GetPixelMap(TestX div delta,TestY div delta,S_WalkMap) then exit;
        if y<>0 then begin
          TestX:= x_stred - y;
          TestY:= y_stred - x;
{if TestXYOnScr then XorPixel (TestX, TestY, barva);}
          if TestXYOnScr and GetPixelMap(TestX div delta,TestY div delta,S_WalkMap) then exit;
        end;
      end;
      {aby se to 2* nexorovalo}
    end; {kresli_symetrické_body}

  begin {Kružnice}
    polomer:= 0;
    repeat
      Inc(polomer, delta);
      x := 0;
      y := polomer;
      predikce := 1 - polomer;
      dx := 3;
      dy := 2*polomer - 2;
      repeat
        xoruj_symetricke_body;
        if TestXYOnScr and GetPixelMap(TestX div delta,TestY div delta,S_WalkMap) then begin
          x_stred:= TestX;
          y_stred:= TestY;
          exit;
        end;

        if predikce >= 0
          then { pokles souřadnice y }
            begin
              predikce := predikce - dy;
              dy := dy - 2*delta;
              y := y - delta;
            end;
          predikce := predikce + dx;
          dx := dx + 2*delta;
          x := x + delta;
      until x > y;
    until False;
  end; {Kružnice}



procedure FindRoad(x1, y1, x2, y2 : integer; vysl: ppole);
type
  pbuf=^tbuf;
  tbuf=array[0..200*4-1]of record
    x,y:integer;
    smer:byte
    {dodelal jsem tam ten test smeru- Robertova poznamka, ja k tomu
     nemuzu nic dodat. Pavel}
   end;
   {nacpak asi muze byt tohle? no ano, je to preci buffer (jakysi)}
   PResult= ^TResult;
   TResult= array[1..10000] of record
     x,y,min:integer
   end;
   {do teto datove struktury to bude pro sebe ukladat cestu, kudy jit}

var
  BufferMap: pointer;
  {do tohlenctoho bafru si bude znacit prohledavani mapy- nepocmara si
   prece samotnou mapu!}
  Buf:pbuf;
  {kruhovy buffer o rozmeru 2*mensi z rozmeru mapy o slozkach 0..1
   jako pole rozmeru X a Y - todle semka napsal Lukas, zkusim mu verit}
  Result: PResult;
  Cist, Zapisovat: integer;
  {ukazatele v kruhovem bufferu}
  konec, akt, x, y: integer;
  {ukazatel konce a aktualniho prvku v poli a aktivni pmocne x a y bodu}
  sm, aktsm: shortint;
  {uchovani from-smeru pro zapis noveho bodu a aktivni smer, kdetym jsme
   dojeli na tento bod}

  function  NewMap(oldmap : pointer; var map : pointer) : word;
  {Do toho, jaky ma mapa format, nevidim, ovsem tadle procedurka
   by mela asi alokovat pamet pro mapu obrazovky  map  stejne velkou,
   jako je  oldmap.}
  var velikost : word;
  begin
    velikost:=PWordArray(oldmap)^[6]*PWordArray(oldmap)^[5]+14;
    GetMem(map,velikost);
    fillchar(map^,velikost,0);
    PWordArray(map)^[0]:=PWordArray(oldmap)^[0];
    PWordArray(map)^[1]:=PWordArray(oldmap)^[1];
    PWordArray(map)^[2]:=PWordArray(oldmap)^[2];
    PWordArray(map)^[3]:=PWordArray(oldmap)^[3];
    PWordArray(map)^[4]:=PWordArray(oldmap)^[4];
    PWordArray(map)^[5]:=PWordArray(oldmap)^[5];
    PWordArray(map)^[6]:=PWordArray(oldmap)^[6];
    NewMap:=Velikost
  end;


  procedure ZkusBod(nX,nY:integer);
  {cosi to ozkoosi}
  begin
{      if (nX>=1)and(nX<319) and
       (nY>=1)and(nY<199) and}
    if (nX>=0)and(nX<=319) and
       (nY>=0)and(nY<=199) and
{Tadyk se na to kouka, esli je to na obrazovce, akorat ty hodnoty trochu upravim...}
     ( not (not (getpixelmap(nx div delta,ny div delta,S_WalkMap))
     or(getpixelmap(nx div delta,ny div delta,BufferMap))) )
    then begin
      Buf^[Zapisovat].x:=nX;
      Buf^[Zapisovat].y:=nY;
      Buf^[Zapisovat].smer:=sm;
      Zapisovat:=succ(Zapisovat) mod (400*2);

SetActivePage(ActivePage xor 1);
PutPixel(nX,nY,20);
SetActivePage(ActivePage xor 1);

      PutPixelMap(nx div delta,ny div delta,true,BufferMap);
      Inc(konec);
      Result^[konec].x:=nx;
      Result^[konec].y:=ny;
      Result^[konec].min:=akt;
    end
  end;

{!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!}
{teprv tady nam zacina procedurka FindRoad}
{!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!}
begin
  if (x1=x2)and(y1=y2)then begin
   {odchytim situaci, ze vychozi bod je stejny jako cilovy}
    pocet:=1;
    vysl^[pocet].x:=x1;
    vysl^[pocet].y:=y1;
{    write(#7);}
    exit;
  end;
  NewMap(S_WalkMap, pointer(BufferMap));
{Tady se alokuje navic 8000 byte}
  New(Buf);
{tady 4000}
  New(Result);
{a tady 10000}
{tedy celkem dynamickych 22000 byte}
  Cist:=0;
  Zapisovat:=1;
  Buf^[0].x:=x1;
  Buf^[0].y:=y1;
  buf^[0].smer:=1;
  akt:=1;
  konec:=1;
  Result^[1].x:=x1;
  Result^[1].y:=x2;
  Result^[1].min:=0;
  PutPixelMap(x1,y1,true,BufferMap);
  {v bufferu je uveden seznam uz vyplnenych bodu, pri prochazeni uz se
   nezobrazuji, ale pouze se k nim vyhledaji sousede}

  while (Cist<>Zapisovat)and(not((Buf^[Cist].x=x2)and(Buf^[Cist].y=y2))) do begin
  {dokud nevyprazdnime buffer nebo nenajdeme cestu}
  {and(Cist<804)and(Zapisovat<803) }
    x:=Buf^[Cist].x;
    y:=Buf^[Cist].y;
    aktsm:=buf^[cist].smer;
    case aktsm of
      1{4}:begin
        sm:=1; ZkusBod(x,y-delta);    {horni bod}
        sm:=2; ZkusBod(x,y+delta);    {dolni bod}
        sm:=3; ZkusBod(x-delta,y);    {levy bod}
        sm:=4; ZkusBod(x+delta,y)     {pravy bod}
      end;
      2{1}:begin
        sm:=2; ZkusBod(x,y+delta);    {dolni bod}
        sm:=3; ZkusBod(x-delta,y);    {levy bod}
        sm:=4; ZkusBod(x+delta,y);    {pravy bod}
        sm:=1; ZkusBod(x,y-delta)     {horni bod}
      end;
      3{2}:begin
        sm:=3; ZkusBod(x-delta,y);    {levy bod}
        sm:=4; ZkusBod(x+delta,y);    {pravy bod}
        sm:=1; ZkusBod(x,y-delta);    {horni bod}
        sm:=2; ZkusBod(x,y+delta)     {dolni bod}
      end;
      4{3}:begin
        sm:=4; ZkusBod(x+delta,y);    {pravy bod}
        sm:=1; ZkusBod(x,y-delta);    {horni bod}
        sm:=2; ZkusBod(x,y+delta);    {dolni bod}
        sm:=3; ZkusBod(x-delta,y)     {levy bod}
      end
    end;
    Cist:=succ(Cist) mod (400*2);
    Inc(akt);
  end;
  if cist=zapisovat then begin
    pocet:=1;
    vysl^[pocet].x:=x1;
    vysl^[pocet].y:=y1;
{    write(#7);}
  {neexistuje cesta !!!!}
  end else begin
  {cesta existuje, vrat vhodne polozky z bufferu}
    pocet:=0;
    repeat
      inc(pocet);
      vysl^[pocet].x:=Result^[akt].x;
      vysl^[pocet].y:=Result^[akt].y;
      akt:=Result^[akt].min;
    until Result^[akt].min=0;
    inc(pocet);
    vysl^[pocet].x:=x1;
    vysl^[pocet].y:=y1;
    {no a zapisu jeste uplne posledni bod cesty- tedy vlastne ten,
     na kterem drak prave stoji}

{tak jsem uz na cosi prisel- pruser je, kdyz bod, kam se ma dojit je
shodny s bodem, ze ktereho se vychazi; zkusim to odchytit uz pred
volanim FindRoad.. alebo coho vlastne...}

{tady se mi jednou stalo, ze se to nekonecne zacyklilo- jak to je mozny??}
{teda spis preteklo!!!!}
{ve chvili, kdy to bylo nekonecne zacykleny se mi stalo, ze mys mela
najednou nejake divne MouseImage - velikej nahodnej obdelnik???!!!}

{podruhe se to zblblo- tentokrat pri tisku mysi. Zajimalo by me, jestli
to vsude dodrzuje rozmery tech poli, jestli treba nezapisuje nekam jinam}

{Ono- je fakt, ze to zacalo delat blbosti teprve potom, co jsem zacal
pouzivat AdjustXYOnMap- ale!!! tam nic nikam neukladam, takze to nemuzu
ulozit ani mimo!! Jediny, co AdjustXYOnMap dela je, ze upravi X,Y -
a podle toho by se snad toto uz melo umet zaridit?}
  end;
  Dispose(Result);
  Dispose(buf);
  DisposeMap(pointer(BufferMap));
end;

procedure ObliqueRoad;{=zkos, zesikmi cestu}
var
  KonvPole: ppole;
  konvpoc: word;
  i, i1: word;
  BetwOne, BetwTwo, BetwHelp: integer;
  StepX, StepY: real;
  FirstX, FirstY: integer;
begin
  New(KonvPole);
  {Nejdrive zjednodusime cestu tak, aby se v ni nachazely jenom "uzly",
   kde se meni smer}
  konvpoc:= 0;
  while pocet> 1 do begin
    i:=pocet;
    i1 := i;
    while (I_FoundWay^[i1].X=I_FoundWay^[i1-1].X)and(i1>1) do dec(i1);
    if i<>i1 then begin
      pocet:=i1;
      Inc(konvpoc);
      KonvPole^[konvpoc].x:= I_FoundWay^[i].X;
      KonvPole^[konvpoc].y:= I_FoundWay^[i].Y;
    end else begin
      i:=pocet;
      i1 := i;
      while (I_FoundWay^[i1].Y=I_FoundWay^[i1-1].Y)and(i1>1) do dec(i1);
      if i=i1 then Dec(i1);
      pocet:=i1;
      Inc(konvpoc);
      KonvPole^[konvpoc].x:= I_FoundWay^[i].X;
      KonvPole^[konvpoc].y:= I_FoundWay^[i].Y;
    end;
  end;
  Inc(konvpoc);
  KonvPole^[konvpoc].x:= I_FoundWay^[1].X;
  KonvPole^[konvpoc].y:= I_FoundWay^[1].Y;

  {Samotne zesikmeni se muze provest, pouze ma-li cesta alespon 3(tri) uzly:}
  {vezmeme delku mezi 1. a 2. uzlem a porovname ji s delkou mezi 2. a 3. uzlem;
   pote mensi delkou vydelime vetsi delku a zjistime, jestli se pro tento
   pomer (asi nanejvys 1:3) jeste muze zesikmovat.
   Pokud ano, zkusime vest z 1. do 3. uzlu primku a budeme zjistovat, jestli
   se pod primkou nachazi cesta.
   Pokud ano, vynechame 2. uzel a zkusime novou cestu z 1. do 3.
   Pokud ne, prejdeme na 2. a testujeme ho s 3. a 4.}
{LS}
  i:= 3;
  while i<= konvpoc do begin
    BetwOne:= (KonvPole^[i].x- KonvPole^[i-1].x)+( KonvPole^[i].y-  KonvPole^[i-1].y);
    BetwTwo:= (KonvPole^[i-1].x- KonvPole^[i-2].x)+( KonvPole^[i-1].y-  KonvPole^[i-2].y);
    if Abs(BetwTwo)> Abs(BetwOne) then begin
      BetwHelp:= BetwOne;
      BetwOne:= BetwTwo;
      BetwTwo:= BetwHelp;
    end;
    {Nyni je v BetwOne vetsi z delek, v BetwTwo mensi}
    if (Abs(BetwTwo / BetwOne)< (1/2))or(Abs(BetwOne)<= 3*delta)or(Abs(BetwTwo)<= 3*delta) then begin
      {Pokud je pomer spravne velky (nebo spis "maly"), muzeme pokracovat}
      StepX:= (KonvPole^[i].x- KonvPole^[i-2].x);
      {V StepX prozatim x-ova vzdalenost mezi 1. a 3. uzlem}
      if Abs(StepX)= Abs(BetwOne) then begin
        {pokud se x- ova vzdal. mezi 1. a 3. uzlem rovna vetsi z delek,
         znamena to, ze prave x-ova delka je ta delsi, to znamena, ze
         pojedme bod po bodu po x a k y budeme pricitat krok}
        StepY:= (KonvPole^[i].y- KonvPole^[i-2].y);
        StepY:= StepY/Abs(StepX);
        FirstY:= KonvPole^[i-2].y;
        FirstX:= KonvPole^[i-2].x;
        if KonvPole^[i].x< KonvPole^[i-2].x then begin
          StepX:= -1;
        end else begin
          StepX:= 1;
        end;
      end else begin
        {jinak to znamena, ze y-ova delka je delsi, to znamena, ze
         pojedme bod po bodu po y a k x budeme pricitat krok}
        StepX:= StepX/Abs( (KonvPole^[i].y- KonvPole^[i-2].y) );
        FirstX:= KonvPole^[i-2].x;
        FirstY:= KonvPole^[i-2].y;
        if KonvPole^[i].y< KonvPole^[i-2].y then begin
          StepY:= -1;
        end else begin
          StepY:= 1;
        end;
      end;
{SetActivePage(ActivePage xor 1);}
      for i1:= 1 to (Abs(BetwOne)-1)div delta do begin
{PutPixel(FirstX+trunc(i1*delta* StepX), FirstY+trunc(i1*delta* StepY), 5);
PutPixel(FirstX+trunc(i1*delta* StepX)+1, FirstY+trunc(i1*delta* StepY), 5);
PutPixel(FirstX+trunc(i1*delta* StepX)+2, FirstY+trunc(i1*delta* StepY), 5);}
        if not GetPixelMap((FirstX+trunc(i1*delta* StepX))div delta, (FirstY+trunc(i1*delta* StepY))div delta, S_WalkMap)
        then break;
        {Testuju, esli se vsude pod zesikmenou cestou da jit. Pokud objevim
         bod, kam se neda jit, hned z testovaciho cyklu vyskocim, jinak odtud
         vyskocim, az prohlednu celou cestu}
      end;
{SetActivePage(ActivePage xor 1);}
      if (GetPixelMap((FirstX+trunc(i1*delta* StepX))div delta, (FirstY+trunc(i1*delta* StepY))div delta, S_WalkMap))
         or( (Abs(BetwOne)div delta)< 4)
      then begin
        {Pokud se sikmo opravdu da jit, vynuluju uzel}
        KonvPole^[i-1].x:= 0;
        KonvPole^[i-1].y:= 0;
        for i1:= i to konvpoc do begin
          KonvPole^[i1-1].x:= KonvPole^[i1].x;
          KonvPole^[i1-1].y:= KonvPole^[i1].y;
        end;
        Dec(konvpoc);
        Dec(i);
        {a preskocim tento vynulovany uzel}
      end;
    end;
{repeat until KeyPressed;
readkey;}
    Inc(i);
  end;
{LS}
  {A nakonec ulozim prevedena data do pole, ze ktereho se budou cist}
  pocet:= 0;
  for i1:= konvpoc downto 1 do begin
    if not((KonvPole^[i1].x=0)and(KonvPole^[i1].y=0))then begin
      Inc(pocet);
      I_FoundWay^[pocet].X:= KonvPole^[i1].x;
      I_FoundWay^[pocet].Y:= KonvPole^[i1].y;
    end;
  end;

  Dispose(KonvPole);
end;


procedure InitWay(x1, y1, x2, y2 : integer);
var
  f, g: word;
begin
  if X1>319 then X1:= 319;
  if X1<0 then X1:= 0;
  if X2>319 then X2:= 319;
  if X2<0 then X2:= 0;
  if Y1>199 then Y1:= 199;
  if Y1<0 then Y1:= 0;
  if Y2>199 then Y2:= 199;
  if Y2<0 then Y2:= 0;
{Upravil jsem vsechny hodnoty tak, aby se nachazely na obrazovce}
  X1:= (X1 div delta)*delta;
  Y1:= (Y1 div delta)*delta;
  X2:= (X2 div delta)*delta;
  Y2:= (Y2 div delta)*delta;

  H_BeforeWayX:= X1;
  H_MouseX:= X2;
  H_LastHorMove:= Nedefinovano;

SetActivePage(ActivePage xor 1);
for f:= 0 to (319 div delta )do for g:= 0 to (199 div delta )do begin
  if GetPixelMap(f, g, S_WalkMap)then PutPixel(f*delta+1,g*delta+1,254);
end;

  if not GetPixelMap(X2 div delta,Y2 div delta,S_WalkMap) then AdjustXYByCircle(x2,y2,6);
  if not GetPixelMap(X1 div delta,Y1 div delta,S_WalkMap) then AdjustXYByCircle(x1,y1,6);

PutPixel(x2,y2,255);
PutPixel(x2+1,y2,255);
PutPixel(x1,y1,255);
PutPixel(x1+1,y1,255);
SetActivePage(ActivePage xor 1);

  FindRoad(x1, y1, x2 ,y2, I_FoundWay);

SetActivePage(ActivePage xor 1);
for f:=pocet downto 2 do line(I_FoundWay^[f-1].x,I_FoundWay^[f-1].y,I_FoundWay^[f].x,I_FoundWay^[f].y,128);
SetActivePage(ActivePage xor 1);

  ObliqueRoad;

SetActivePage(ActivePage xor 1);
for f:=pocet downto 2 do line(I_FoundWay^[f-1].x,I_FoundWay^[f-1].y,I_FoundWay^[f].x,I_FoundWay^[f].y,40);
SetActivePage(ActivePage xor 1);

end;

procedure GoAfterCurve;
begin
  H_FeetX:= H_StartX;
  H_FeetY:= H_StartY;
  with A_SeqExtHead[H_AfterCurve]^ do begin
    UserProc:= GoByWay;
  end;
{  H_WalkSide:= 0;}
  StartPhase(H_AfterCurve);
{  write(#7);}
end;

procedure GoBeforeFinal;
begin
  H_FeetX:= H_FinalX;
  H_FeetY:= H_FinalY;
  with A_SeqExtHead[Ord(H_FinSight)]^ do begin
    UserProc:= FreeUserProc;
  end;
  StartPhase(Ord(H_FinSight));
end;

procedure GoByWay;
var
  i: word;
  PrevAnim: byte; {cislo animace, ktera prave bezela}
begin
  for PrevAnim:= 1 to A_LastAnmSeq do begin
    if(A_SeqExtHead[PrevAnim]^.MainHero> 0)and(A_SeqExtHead[PrevAnim]^.InProcess=1)then break;
  end;
  {hledal jsem predchozi probihajici animaci hrdiny}
  H_StartX:= H_FeetX;
  H_StartY:= H_FeetY;

  if (PrevAnim= Ord(Vlevo))or(PrevAnim= Ord(Vpravo)) then H_LastHorMove:= TPohybyDraka(PrevAnim);
  {zaznamenavam, jakym horizontalnim smerem sel naposledy}

  if pocet> 1 then begin
    i:= pocet;
    Dec(pocet);
    A_HeroContinue:= True;
    H_YStrOblRatio:= Abs(sqr( (I_FoundWay^[i].Y-I_FoundWay^[pocet].Y) *1.2/delta) );
    H_YStrOblRatio:= H_YStrOblRatio+Abs(sqr( (I_FoundWay^[i].X-I_FoundWay^[pocet].X) /delta));
    H_YStrOblRatio:= sqrt(H_YStrOblRatio);
    {protoze je Pascal blbec, musim to pocitat prave takto...}
    {v H_YStrOblRatio je nyni delka uhlopricky}
    if round(Abs(I_FoundWay^[i].Y-I_FoundWay^[pocet].Y)*1.2)>=Abs(I_FoundWay^[i].X-I_FoundWay^[pocet].X) then begin
      {Testuju, jestli je vetsi vzadlenost ve smeru pravo-levem nebo hore-dolnim}
      H_XOblStep:= (I_FoundWay^[pocet].X-I_FoundWay^[i].X)/Abs(I_FoundWay^[pocet].Y-I_FoundWay^[i].Y);
      {V H_XOblStep je o kolik bodu v x se ma posunout za 1 bod v y}
      H_YOblStep:= 0;
      H_YStrOblRatio:= Abs(I_FoundWay^[pocet].Y-I_FoundWay^[i].Y)/ H_YStrOblRatio/ delta;
      H_XStrOblRatio:= 1;
      {H_YStrOblRatio je pomer mezi delkou y a sikmou delkou. Sikma delka je
       odmocnina z delky x na 2 plus delky y na 2 }
      if I_FoundWay^[i].Y>I_FoundWay^[pocet].Y then with A_SeqExtHead[Ord(Nahoru)]^ do begin
      {nahoru}
        H_FinalX:=I_FoundWay^[pocet].x;
        H_FinalY:=I_FoundWay^[pocet].y;
        if PrevAnim<> Ord(Nahoru) then begin
          A_SeqExtHead[PrevAnim]^.InProcess:=0;
          {zastavil jsem animaci hl. hrdiny, ktera prave doprobihala}
          H_AfterCurve:= Ord(Nahoru);
          H_WalkSide:= 0;
          A_HeroContinue:= False;
          if PrevAnim= Ord(Vlevo) then begin
            {byla levo, spustim levo-hore}
            StartPhase( Ord(LevoHore) );
            A_SeqExtHead[Ord(LevoHore) ]^.UserProc:= GoAfterCurve;
            exit;
          end;
          if PrevAnim= Ord(Vpravo) then begin
            StartPhase( Ord(PravoHore) );
            A_SeqExtHead[ Ord(PravoHore) ]^.UserProc:= GoAfterCurve;
            exit;
          end;
          StartPhase(Ord(Nahoru));
        end;
        UserProc:= GoByWay;
        exit;
      end else with A_SeqExtHead[ Ord(Dolu) ]^ do begin
      {dolu}
        H_FinalX:=I_FoundWay^[pocet].x;
        H_FinalY:=I_FoundWay^[pocet].y;
        if PrevAnim<>Ord(Dolu) then begin
          A_SeqExtHead[PrevAnim]^.InProcess:=0;
          H_AfterCurve:= Ord(Dolu);
          H_WalkSide:=1;
          A_HeroContinue:= False;
          if PrevAnim=Ord(Vlevo)  then begin
            StartPhase( Ord(LevoDolu) );
            A_SeqExtHead[ Ord(LevoDolu) ]^.UserProc:= GoAfterCurve;
            exit;
          end;
          if PrevAnim= Ord(Vpravo)  then begin
            StartPhase( Ord(PravoDolu) );
            A_SeqExtHead[ Ord(PravoDolu) ]^.UserProc:= GoAfterCurve;
            exit;
          end;
          StartPhase(Ord(Dolu));
        end;
        UserProc:= GoByWay;
        exit;
      end;
    end else begin
      H_YOblStep:= (I_FoundWay^[pocet].Y-I_FoundWay^[i].y)/Abs(I_FoundWay^[pocet].X-I_FoundWay^[i].x);
      {V H_YOblStep je o kolik bodu v y se ma posunout za 1 bod v x}
      H_XOblStep:= 0;
      H_XStrOblRatio:= Abs(I_FoundWay^[pocet].X-I_FoundWay^[i].X)/ H_YStrOblRatio/ delta;
      H_YStrOblRatio:= 1;
      if I_FoundWay^[i].X<I_FoundWay^[pocet].X then with A_SeqExtHead[Ord(Vpravo)]^ do begin
      {vpravo}
        H_FinalX:=I_FoundWay^[pocet].x;
        H_FinalY:=I_FoundWay^[pocet].y;
        if PrevAnim<>Ord(Vpravo) then begin
          A_SeqExtHead[PrevAnim]^.InProcess:=0;
          H_AfterCurve:= Ord(Vpravo);
          H_WalkSide:=2;
          A_HeroContinue:= False;
          if PrevAnim= Ord(Dolu) then begin
            StartPhase( Ord(DolePravo) );
            A_SeqExtHead[ Ord(DolePravo) ]^.UserProc:= GoAfterCurve;
            exit;
          end;
          if PrevAnim= Ord(Nahoru) then begin
            StartPhase( Ord(HorePravo) );
            A_SeqExtHead[ Ord(HorePravo) ]^.UserProc:= GoAfterCurve;
            exit;
          end;
          StartPhase(Ord(Vpravo));
        end;
        UserProc:= GoByWay;
        exit;
      end else with A_SeqExtHead[Ord(Vlevo)]^ do begin
      {vlevo}
        H_FinalX:=I_FoundWay^[pocet].x;
        H_FinalY:=I_FoundWay^[pocet].y;
        if PrevAnim<> Ord(Vlevo) then begin
          A_SeqExtHead[PrevAnim]^.InProcess:=0;
          H_AfterCurve:= Ord(Vlevo);
          H_WalkSide:=3;
          A_HeroContinue:= False;
          if PrevAnim= Ord(Dolu) then begin
            StartPhase( Ord(DoleLevo) );
            A_SeqExtHead[ Ord(DoleLevo) ]^.UserProc:= GoAfterCurve;
            exit;
          end;
          if PrevAnim= Ord(Nahoru) then begin
            StartPhase( Ord(HoreLevo) );
            A_SeqExtHead[ Ord(HoreLevo) ]^.UserProc:= GoAfterCurve;
            exit;
          end;
          StartPhase(Ord(Vlevo));
        end;
        UserProc:= GoByWay;
        exit;
      end;
    end;
  end;

{  InitHero(H_FeetX, H_FeetY);}
  H_XOblStep:= 0;
  H_YOblStep:= 0;
  H_XStrOblRatio:= 1;
  H_YStrOblRatio:= 1;
  H_WalkSide:=255;
  H_FeetX:= H_FinalX;
  H_FeetY:= H_FinalY;

(*  with A_SeqExtHead[Ord(StujPravo)]^ do begin
    UserProc:= FreeUserProc;
  end;
  if(PrevAnim<>Ord(StujPravo))then begin
    A_SeqExtHead[PrevAnim]^.InProcess:=0;
    StartPhase(Ord(StujPravo));
  end;
SetActivePage(ActivePage xor 1);
PutPixel(H_FeetX,H_FeetY, 13);
PutPixel(H_FeetX-1,H_FeetY, 13);
SetActivePage(ActivePage xor 1);
PutPixel(H_FeetX,H_FeetY, 13);
PutPixel(H_FeetX-1,H_FeetY, 13);
repeat until MouseKey=4;
*)
(*    H_SeeOnMouse    : byte;      {kam se ma drak divat po dojiti na misto:
                                 0- neurceno: podle toho, odkud prisel
                                 1- na mysku: tam, kde puvodne klikla
                                 3- vpravo
                                 4- vlevo}*)

  {tady vlastne urcim, kamze se to ma hrdina nyni koukat:}
  case H_SightOnMouse of
    1: begin
         if (H_FeetX>H_MouseX) then H_FinSight:= Ord(StujLevo) else H_FinSight:= Ord(StujPravo);
         {kouka se na mysku}
       end;
    3: begin
         H_FinSight:= Ord(StujPravo);
       end;
    4: begin
         H_FinSight:= Ord(StujLevo);
       end;
    else begin
      if H_LastHorMove=Vlevo then H_FinSight:= Ord(StujLevo)
      {posledni horiz. presun byl doleva}
      else if H_LastHorMove=Vpravo then H_FinSight:= Ord(StujPravo)
      {posledni horiz. presun byl doprava}
      else if(H_FeetX<H_BeforeWayX) then H_FinSight:= Ord(StujLevo) else H_FinSight:= Ord(StujPravo);
      {Nepohyboval se ani vpravo, ani vlevo}
    end;
  end;

  if (PrevAnim<>Ord(StujPravo))and(PrevAnim<>Ord(StujLevo)) then begin
  {pokracuji jenom v pripade, ze jsem opravdu odnekud dosel. Pokud uz stojim}
  {a koukam, nema cenu to koukani zapinat znovu, kdyz uz bezi}
    A_SeqExtHead[PrevAnim]^.InProcess:=0;
    {zastavim animaci, ktera probihala}
    {To, jaka se pripadne provede otocka, zavisi nejprve na tom, kam ta}
    {otocka vlastne bude}
    if H_FinSight= Ord(StujPravo)then begin
      {Otocka buda do praveho stoje..., ale odkud}
      if PrevAnim=Ord(Vlevo) then begin
        with A_SeqExtHead[Ord(LevoPravo)]^ do begin
          UserProc:= GoBeforeFinal;
        end;
        StartPhase(Ord(LevoPravo));
        exit;
      end;
      if PrevAnim=Ord(Nahoru) then begin
        with A_SeqExtHead[Ord(HoreStojPravo)]^ do begin
          UserProc:= GoBeforeFinal;
        end;
        StartPhase(Ord(HoreStojPravo));
        exit;
      end;
    end else begin
      if PrevAnim=Ord(Vpravo) then begin
        with A_SeqExtHead[Ord(PravoLevo)]^ do begin
          UserProc:= GoBeforeFinal;
        end;
        StartPhase(Ord(PravoLevo));
        exit;
      end;
      if PrevAnim=Ord(Nahoru) then begin
        with A_SeqExtHead[Ord(HoreStojLevo)]^ do begin
          UserProc:= GoBeforeFinal;
        end;
        StartPhase(Ord(HoreStojLevo));
        exit;
      end;
    end;
    H_FeetX:= H_FinalX;
    H_FeetY:= H_FinalY;
    with A_SeqExtHead[Ord(H_FinSight)]^ do begin
      UserProc:= FreeUserProc;
    end;
    StartPhase(Ord(H_FinSight));
  end;


end;

begin
end.
