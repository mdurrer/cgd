{pridal jsem pomennou typu proc. "H_OnDestination" (=na cili),
 ktera je volana pote, co drak dojde na misto.
 Je volana pouze z proc. GoBeforeFinal, ktera spousti animaci
 stani na miste. Vyvola se po spusteni sekvence stani na miste.
 H_OnDestination je hned na zacatku bloku "var" interface tohoto unitu
 Pri provadeni programku pri prihlasovani unitu (begin end uplne
 na konci unitu) se priradi do H_OnDestination hodnota FreeUserProc}

{Pokud chces neco delat, prave, kdyz skonci urcita sekvence, neni
nic snazsiho, nez vyplnit polozku UserProc v Seq_ExtHead... te
sekvence. UserProc se vykona, prave kdyz se sekvence ukonci.
Cili je jasne, ze se to nejde pouzit u sekvence cyklicke, ktera se
nikdy neukonci...}

{ $define ladeni}
unit anmplay4; {tato verze obsahuje i procedurky na chuzi z byvaleho unitu go}

interface

uses dma, bardfw, vars, graph256, midi01, animace4;




  function  PhaseSeq(SeqNum: byte): byte;{sdeli nam v jake fazi je sekvence}
  function  IsSeqInProcess(SeqNum: byte): boolean;{sdeli nam, jestli sekvence probiha}
  procedure InitFirstPhase(SeqNum: byte); {Init sekvence na zacatku screenu}
  procedure StartPhase(SeqNum: byte);  {Spusteni sekvence}
  procedure NextPhase(SeqNum: byte); {Prechod na dalsi fazi}
  procedure UpdatePhase(SeqNum: byte);
  procedure Body;
  procedure BodyWait;
  function  LoadAnimationSeq(Item: word): word;
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


function PhaseSeq(SeqNum: byte): byte;
begin
   PhaseSeq:= A_SeqExtHead[SeqNum]^.ActPhase;
end;

function IsSeqInProcess(SeqNum: byte): boolean;
begin
   IsSeqInProcess:= (SeqNum>0)and(A_SeqExtHead[SeqNum]^.InProcess=1);
end;

procedure InitFirstPhase(SeqNum: byte);
{Na zacatku screebu se musi kazda sekvence nejdriv takto inicializovat}
{Hlavne: predpoklada, ze anim. objekt neni viditelny, tedy zviditelni ho}
{Nastavi to: obrazek, sampl, velikots, souradnice- aby se obrazovka
 mohla hned na zacatku vykreslit}
begin
  with A_SeqExtHead[SeqNum]^ do begin
    if InProcess= 0 then Exit;
    {Pokud neni aktivni, samozrejme se neinicializuje}
    {Inicializovat se musi tesne pred tim, nez chceme, aby byla aktivni}
    ActPhase:= 0{bob:1};
    with A_Sequences[SeqNum]^.Phase[1] do begin
      if Picture> 0 then begin
        {pokud je rozumne cislo obrazku, zmenim sprajt, a to nasledovne:}
        if A_Sequences[SeqNum]^.Header.MemoryLogic= 0 then begin
           {pokud je sekvence typu "pamet" jenom dam novou adresu}
           AddSpriteToObj(AnimObj, Sprites[Picture]);
        end else begin
          {jinak nactu sprajt do vyhrazeneho mista}
          CReadItem(PictPath, A_SeqExtHead[SeqNum]^.BigPict, Picture);
          AddSpriteToObj(AnimObj, A_SeqExtHead[SeqNum]^.BigPict);
        end;
        VisibleAObj(AnimObj);
        {predpoklada to, ze je neviditelny - prioritu u sebe ma jakoukoliv,
         prioritu v tabulce ma NULU}
      end;
      if A_Sequences[SeqNum]^.Header.Relative= 0 then begin
        StartPosAObj(AnimObj, X, Y);
      {Pokud ma objekt absolutni souradnice, placne to na ne}
      end else if MainHero> 0 then begin
        {Pokud jde o hrdinu, provede se takto:}
        StartPosAObj(AnimObj,
          H_.FeetX-
          {H_.FeetX je vprostred, takze od ni odecteme pulku aktualni sirky draka}
            round(
            (R_Hd.Persp0+ H_.FeetY*R_Hd.PerspStep)*
            {toto je faktor zvetseni pro radek, kde drak stoji}
            (PWordArray(Sprites[Picture])^[0] / 2)
            {faktorem vynasobime originalni sirku sprajtu a dostaneme}
            {sirku draka na souradnicich, kde je}
            ),
          H_.FeetY-
          {Protoze H_.FeetY je spodek nohou, souradnice hlavy budou nad}
          {nim, cili odecitame - aktualni vysku draka- ale ted jak:}
            round(
            (R_Hd.Persp0+ H_.FeetY*R_Hd.PerspStep)*
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
        NewPriorityAObj(AnimObj, H_.FeetY+1);
        {NewPriority nastavi jak prioritu u objektu, tak prioritu do
         tabulky, coz nyni muzu provest, protoze objekt uz byl zviditelneny}
        {Hrdina je velky podle perspektivy}
        ZoomX:= round(  (R_Hd.Persp0+ H_.FeetY*R_Hd.PerspStep)*
          PWordArray(Sprites[Picture])^[0] );
        ZoomY:= round(  (R_Hd.Persp0+ H_.FeetY*R_Hd.PerspStep)*
          PWordArray(Sprites[Picture])^[1] );
      end;
      NewZoomAObj(AnimObj, ZoomX, ZoomY);
      NewMirrorAObj(AnimObj, Mirror);
    end;
    StartDisableErasingAObj(AnimObj, A_Sequences[SeqNum]^.Header.DisableErasing);
  end; {with A_SeqExtHead[SeqNum] }
end;

procedure UpdatePhase(SeqNum: byte);
{volam zatim pouze pri loadu. Muze se stat, zejm. u draka (nikde jinde
 to neni prakticky mozne), ze prave menim smer chuze a menim ho prikazem
 StartPhase. Tento prikaz nastavi ActPhase na 0. Pokud jeste pri tomtez
 pruchodu Body nedojde k inicializovani ActPhase spustene sekvence z 0 na 1
 (k inicializovani nedojde tehdy, kdyz menim sekvenci s vyssim porad.
 cislem na sekvenci s nizsim porad. cislem), dojde k nemu az pri pruchodu
 dalsim. Mezi tim ale muze dojit k sejvnuti->sejvne se ActPhase:= 0.
 Aby pri loudnuti rutinka UpdatePhase nehodila nesmyslnou adresu obrazku
 otestuju to tak, jak to testuju...}
{potom tam ale muze byt mala esteticka nehoraznost: drak se neobjevi na
 obrazovce hned, ale az hned pri prvnim pruchodem Body. Cili prakticky
 hned, ale presto to bude trosku videt.
 NEBUDEME to povazovat za chybu, a vyfakujeme se ne to.}
begin
  {nejdrive upravim aktualni fazi- ono se totiz muze stat, ze je nastavena
   na 0 (kdyz animaci startuju), a pokud dam update sprite aktualni faze
   0, tak...}
  if A_SeqExtHead[SeqNum]^.ActPhase>0 then
  with A_Sequences[SeqNum]^.Phase[A_SeqExtHead[SeqNum]^.ActPhase] do begin
    {pracuji se zaznamem aktualni faze}
    if Picture> 0 then begin
      {pokud je rozumne cislo obrazku, zmenim sprajt, a to nasledovne:}
      if A_Sequences[SeqNum]^.Header.MemoryLogic= 0 then
        AddSpriteToObj(A_SeqExtHead[SeqNum]^.AnimObj, Sprites[Picture])
         {Kdyz je typu "memory", jenom hodim z pamete adresu dalsiho sprajtu}
      else begin{jinak ale obslouzim typ "memory/disk"}
        CReadItem(PictPath, A_SeqExtHead[SeqNum]^.BigPict, Picture);
        AddSpriteToObj(A_SeqExtHead[SeqNum]^.AnimObj, A_SeqExtHead[SeqNum]^.BigPict);
      end;
      VisibleAObj(A_SeqExtHead[SeqNum]^.AnimObj);
    end;

  end;
end;

procedure StartPhase(SeqNum: byte);
{Spusteni sekvence}
{Predpoklada, ze anim. objekt je jiz viditelny, nezviditelni ho}
{Pouze nastavi, ze bezime, nastavi spravne zdrzeni, spravnou fazi}
begin
  with A_SeqExtHead[SeqNum]^ do begin
    StartDisableErasingAObj(AnimObj, A_Sequences[SeqNum]^.Header.DisableErasing);
    {Do jednoho objektu se muze promitat stridave vic sekvenci, takze to nastavim
     u objektu znovu podle hlavicky sekvence}
    InProcess:= 1; {nyni je aktivni}
    CountDelay:= TimerBody- A_Sequences[SeqNum]^.Phase[1].Delay -1;
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
    if(ActPhase=0)or((TimerBody- CountDelay)>= A_Sequences[SeqNum]^.Phase[ActPhase].Delay)
    or((MainHero>0)and(G_EnableQuickHero)and(G_QuickHero)and(SeqNum<Ord(DM_SpeakRight)))
    then begin
      {OK, uz muzeme prejit na dalsi fazi}
      CountDelay:= TimerBody;
      {Nastavime cas, kdy jsme presli na dalsi fazi, kvuli testovani Delay}
      if(MainHero>0)and(A_Sequences[SeqNum]^.Header.Cyclic= 1)and
      {V pripade, ze jde o cyklickou animaci hlavniho hrdiny, overim,
      jestli se uz hrdina nenachazi v predepsanem miste}
      ( (H_.WalkSide=0)and(H_.FeetY< (H_.FinalY+
         ( (R_Hd.Persp0+ H_.FeetY*R_Hd.PerspStep)*2)    )
          )or
        (H_.WalkSide=1)and(H_.FeetY>(H_.FinalY-
         ( (R_Hd.Persp0+ H_.FeetY*R_Hd.PerspStep)*2) )
          )or
        (H_.WalkSide=2)and(H_.FeetX> (H_.FinalX-
         ( (R_Hd.Persp0+ H_.FeetY*R_Hd.PerspStep)*5) )
          )or
        (H_.WalkSide=3)and(H_.FeetX< (H_.FinalX+
         ( (R_Hd.Persp0+ H_.FeetY*R_Hd.PerspStep)*5) )
      ) )then begin
      {zjistili jsme, ze hrdina je tam, kde mel byt...}
      {ty cisla, ktere nasobim faktorem perspektivy, jsou
       o neco mensi nez prumerne X a Y relat. souradnice u animace draka}

  {          InProcess:= 0;}
  {Nebudu to vypinat, to si obslouzi procedurka nad nami...}
        H_.FeetX:= H_.FinalX;
        H_.FeetY:= H_.FinalY;
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
{          UnvisibleAObj(AnimObj);}
          A_ActSeq:= SeqNum;
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
             AddSpriteToObj(AnimObj, Sprites[Picture]);
             {Kdyz je typu "memory", jenom hodim z pamete adresu dalsiho sprajtu}
          end else begin
            {jinak ale obslouzim typ "memory/disk"}
            CReadItem(PictPath, BigPict, Picture);
            AddSpriteToObj(AnimObj, BigPict);
            {nacetl jsem sprajt do vyhrazeneho mista}
          end;
          RepaintAObj(AnimObj);
          {zmenil se sprajt, vydam prikaz k prekresleni animacniho objektu}
        end;
        if Sample> 0 then begin
         PlayDMAString(sample,13000,false);
        end;
        if A_Sequences[SeqNum]^.Header.Relative= 0 then begin
          NewPosAObj(AnimObj, X, Y);
          {Pokud jsou absolutni souradnice, neci co resit,}
          {ale co kdyz jsou relativni: ?}
        end else if MainHero> 0 then begin
          {Pokud jsou relativni a jedna se o animaci hlavniho hrdiny,
           pracujeme s H_.Feet.. , kde jsou ulozeny jeho souradnice}
          begin
            _FeetX:= round( (R_Hd.Persp0+ H_.FeetY*R_Hd.PerspStep)*X*H_.XStrOblRatio);
            {Ve _FeetX je velikost relat. kroku nasobena faktory perspektivy
             a zesikmeni}
            if(H_.XOblStep=0)then H_.FeetX:= H_.FeetX+ _FeetX
            {Pokud je "hlavni smer" v ose X, jenom prictu relat. krok
             k dosavadni souradnici}
            else H_.FeetX:= H_.StartX+ _FeetX+ round(H_.XOblStep*Abs(H_.FeetY- H_.StartY));
            {Jinak se podivam, kolik bodu jsme uz usli od zacatku tohoto useku
             a tuto delkou vynasobim poctem bodu v teto ose pripadajicim na jeden
             bod useku v "hlavnim smeru"}

            _FeetY:= round( (R_Hd.Persp0+ H_.FeetY*R_Hd.PerspStep)*Y*H_.YStrOblRatio);
            if(H_.YOblStep=0)then H_.FeetY:= H_.FeetY+ _FeetY
            else H_.FeetY:= H_.StartY+ _FeetY+ round(H_.YOblStep*Abs(H_.FeetX- H_.StartX));
            {tady jsme dostali nove souradnice nohou}
            {a zadame podle nich souradnice leveho horniho rohu draka}
            NewPosAObj(AnimObj,
              H_.FeetX-
              {H_.FeetX je vprostred, takze k ni pricteme pulku aktualni sirky draka}
                round(
                (R_Hd.Persp0+ H_.FeetY*R_Hd.PerspStep)*
                {toto je faktor zvetseni pro radek, kde drak stoji}
                (PWordArray(Sprites[Picture])^[0] / 2)
                {faktorem vynasobime originalni vysku sprajtu a dostaneme}
                {vysku draka na souradnicich, kde je}
                ),
              H_.FeetY-
              {Protoze H_.FeetY je spodek nohou, souradnice hlavy budou nad}
              {nim, cili odecitame - aktualni vysku draka- ale ted jak:}
                round(
                (R_Hd.Persp0+ H_.FeetY*R_Hd.PerspStep)*
                {toto je faktor zvetseni pro radek, kde drak stoji}
                PWordArray(Sprites[Picture])^[1]
                {faktorem vynasobime originalni vysku sprajtu a dostaneme}
                {vysku draka na souradnicich, kde je}
                )
              );
           {Ted by mel stat tam, kde ma}
          end;
          {A pokud jsou definovany kecajici postavicky, podle souradnic draka}
          {uoravim i souradnice jeho bubliny}
          if G_Hd.PerNum>0 then begin
            G_Persons^[1].X:= H_.FeetX;
            G_Persons^[1].Y:= H_.FeetY-round((R_Hd.Persp0+ H_.FeetY*R_Hd.PerspStep)*
                      PWordArray(Sprites[Picture])^[1]);
          end;
        end else begin
          {A pokud jsou souradnice jenom obycejne relativni, jednoduse
           se prictou rozdily X, Y}
          NewPosAObj(AnimObj,
            X+GetNewXAObj(AnimObj),
            Y+GetNewYAObj(AnimObj));
        end;
        if MainHero> 0 then begin
          NewPriorityAObj(AnimObj, H_.FeetY+1);
          {Hlavni hrdina se zmensuje podle perspektivy}
          ZoomX:= round(  (R_Hd.Persp0+ H_.FeetY*R_Hd.PerspStep)*
            PWordArray(Sprites[Picture])^[0] );
          ZoomY:= round(  (R_Hd.Persp0+ H_.FeetY*R_Hd.PerspStep)*
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
  TimerBody:= TimerDW;
  for f:= 1 to A_LastAnmSeq do begin
    NextPhase(f);
  end;
  {projel jsem vsechny sekvence}
{}  WaitDisplay; {není přehozena stránka}
  SmartPutAObjs;
  {placnu to do neviditelne stranky}
{readkey;}
  WaitVRetrace;
  SwapAnimPages;
  {ted prepnu stranky}
{}  WaitDisplay; {není přehozena stránka}
{readkey;}

  if(A_NextPhaseNewSound=1) then begin
    {pokud mam nastavit zvuk, nastavim ho}
    A_NextPhaseNewSound:= 0;
{old}
    {az teprve ted muzu naladovat hodnoty primo do promennych 0. kanalu,}
    {aby to zaclo hrat zaroven s prepnutim faze}
  end;
{old}
  Inc(G_SumLoopPasses);
  {Tady prubezne pocitam, jak dlouho mi trva nakresleni jedne faze}
end;

procedure BodyWait;
begin
end;

function LoadAnimationSeq(Item: word): word;
{natahne do pameti animacni sekvenci}
var
  f, g, h: byte;
  BigSize, ActSize: word;
  SeqNum: byte;
begin

  Inc(A_LastAnmSeq);
  SeqNum:= A_LastAnmSeq;
  CLoadItem(ANMPath, pointer(A_Sequences[SeqNum]), Item);
  GetMem(A_SeqExtHead[SeqNum], SizeOf(TAnmExtHeader));
  A_SeqExtHead[SeqNum]^.InProcess:= 0;
  A_SeqExtHead[SeqNum]^.MainHero:= 0;

  if A_Sequences[SeqNum]^.Header.MemoryLogic=0 then begin
    {vsechny obrazky v pameti}
    for h:= 1 to A_Sequences[SeqNum]^.Header.NumOfPhases do with A_Sequences[SeqNum]^.Phase[h] do begin
      {projdu vsechny faze}
      if Picture>0 then begin
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

  end else begin
    {kdyz to pouze v pameti vyhradi misto a taha to do neho}
    BigSize:= 0;
    for f:= 1 to A_Sequences[SeqNum]^.Header.NumOfPhases do with A_Sequences[SeqNum]^.Phase[f] do begin
      if Picture>0 then begin
        g:= 0;
        repeat Inc(g) until Picture=A_Sequences[SeqNum]^.Phase[g].Picture;
        if g=f then begin
          ActSize:= UnpackedItemSize(PictPath, Picture);
          if ActSize>BigSize then BigSize:= ActSize;
        end;
      end else Picture:= 0;
    end;
    A_SeqExtHead[SeqNum]^.BigPictSize:= BigSize;
    GetMem(A_SeqExtHead[SeqNum]^.BigPict, A_SeqExtHead[SeqNum]^.BigPictSize);
  end;
  LoadAnimationSeq:= A_LastAnmSeq;
end;

procedure ReleaseLastAnimationSeq;
var
  f, g, h: byte;
  BiggestPict, BiggestSam: word;
begin
{Zneviditelnim objekt- nemuzu tim nic pokazit, leda tak vylepsit...}
{Ale, ale- muzu pokazit, ovsem ted uz snad ne:}
  if A_SeqExtHead[A_LastAnmSeq]^.InProcess=1 then
    UnvisibleAObj(A_SeqExtHead[A_LastAnmSeq]^.AnimObj);

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

  end else with A_SeqExtHead[A_LastAnmSeq]^ do begin
    {kdyz to pouze v pameti vyhradi misto a taha to do neho}
    if BigPictSize>0 then FreeMem(BigPict, BigPictSize);
    {alokuju pamet pro nejvetsi ze vsech sprajtu}
    {alokuju pamet pro nejvetsi ze vsech sprajtu}
    {nacetl jsem sprajt}
  end;
  FreeMem(A_Sequences[A_LastAnmSeq],
    SizeOf(TAnmPhase)*A_Sequences[A_LastAnmSeq]^.Header.NumOfPhases+SizeOf(TAnmHeader));
  FreeMem(A_SeqExtHead[A_LastAnmSeq], SizeOf(TAnmExtHeader));
  Dec(A_LastAnmSeq);
end;



(*******************************************************************)

(*                       GO                                        *)

(*******************************************************************)

const
  delta= 4; {roztec mapy u chuze}

procedure InitHero(HeroX, HeroY: integer);
{inicializuje vnitrni promenne hrdiny tak, aby stal na miste}
begin
  H_.OnDest:= Do_Nothing;

  H_.FeetX:= HeroX;
  H_.FeetY:= HeroY;

  H_.FinalX:= H_.FeetX;
  H_.FinalY:= H_.FeetY;
  H_.StartX:= H_.FeetX;
  H_.StartY:= H_.FeetY;

  H_.XOblStep:= 0;
  H_.YOblStep:= 0;
  H_.XStrOblRatio:= 1;
  H_.YStrOblRatio:= 1;
  H_.WalkSide:=255;

  if G_Hd.PerNum>0 then begin
   G_Persons^[1].X:= H_.FeetX;
{!!! dana napevno sirka draka= 50!!}
   G_Persons^[1].Y:= H_.FeetY-round((R_Hd.Persp0+ H_.FeetY*R_Hd.PerspStep)*50);
  end;
end;

procedure DisposeMap(var map : pointer);
{Uvolni mapu z pameti, NO COMMENT}
begin
  FreeMem(map,PWordArray(map)^[6]*PWordArray(map)^[5]+14)
end;

function  GetPixelMap(X,Y : word;map:pbytearray):boolean; assembler;
{lezou do toho souradnice uz vydeleny deltou mapy}
asm
  push ds
  lds bx, map         {pavel: existuje takova hezka instrunkce na naladovani
                       ofsetu aji segmentu!}
  mov ax,ds:[bx+12]   {sirka 1 zaznamu}
  mul y               {vynasobit cislem radku, mame offset zacatku radku}
  add bx,14           {preskoceni hlavicky}
  add bx,ax           {najdeme pozici kliknuteho bodu}

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
  lds bx, map
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


procedure AdjustXYByCircle (var x_centre, y_centre: integer; color:byte);
  var
    f: byte;
    radius: word;
    prediction, dx, dy, x, y: integer;
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

  procedure xor_symmetric_points;
    begin
      TestX:= x_centre + x;
      TestY:= y_centre + y;
{if TestXYOnScr then XorPixel (TestX, TestY, color);}
      if TestXYOnScr and GetPixelMap(TestX div delta,TestY div delta,R_WalkMap) then exit;
      if x<>0 then begin
        TestX:= x_centre - x;
        TestY:= y_centre + y;
{if TestXYOnScr then XorPixel (TestX, TestY, color);}
        if TestXYOnScr and GetPixelMap(TestX div delta,TestY div delta,R_WalkMap) then exit;
      end;
      if y<>0 then begin
        TestX:= x_centre + x;
        TestY:= y_centre - y;
{if TestXYOnScr then XorPixel (TestX, TestY, color);}
        if TestXYOnScr and GetPixelMap(TestX div delta,TestY div delta,R_WalkMap) then exit;
        if x<>0 then begin
          TestX:= x_centre - x;
          TestY:= y_centre - y;
{if TestXYOnScr then XorPixel (TestX, TestY, color);}
          if TestXYOnScr and GetPixelMap(TestX div delta,TestY div delta,R_WalkMap) then exit;
        end;
      end;
      if (x=y)then exit;
      TestX:= x_centre + y;
      TestY:= y_centre + x;
{if TestXYOnScr then XorPixel (TestX, TestY, color);}
      if TestXYOnScr and GetPixelMap(TestX div delta,TestY div delta,R_WalkMap) then exit;
      if y<>0 then begin
        TestX:= x_centre - y;
        TestY:= y_centre + x;
{if TestXYOnScr then XorPixel (TestX, TestY, color);}
        if TestXYOnScr and GetPixelMap(TestX div delta,TestY div delta,R_WalkMap) then exit;
      end;
      if x<>0 then begin
        TestX:= x_centre + y;
        TestY:= y_centre - x;
{if TestXYOnScr then XorPixel (TestX, TestY, color);}
        if TestXYOnScr and GetPixelMap(TestX div delta,TestY div delta,R_WalkMap) then exit;
        if y<>0 then begin
          TestX:= x_centre - y;
          TestY:= y_centre - x;
{if TestXYOnScr then XorPixel (TestX, TestY, color);}
          if TestXYOnScr and GetPixelMap(TestX div delta,TestY div delta,R_WalkMap) then exit;
        end;
      end;
      {aby se to 2* nexorovalo}
    end; {kresli_symetrické_body}

  begin {Kružnice}
    radius:= 0;
    repeat
      Inc(radius, delta);
      x := 0;
      y := radius;
      prediction := 1 - radius;
      dx := 3;
      dy := 2*radius - 2;
      repeat
        xor_symmetric_points;
        if TestXYOnScr and GetPixelMap(TestX div delta,TestY div delta,R_WalkMap) then begin
          x_centre:= TestX;
          y_centre:= TestY;
          exit;
        end;

        if prediction >= 0
          then { pokles souřadnice y }
            begin
              prediction := prediction - dy;
              dy := dy - 2*delta;
              y := y - delta;
            end;
          prediction := prediction + dx;
          dx := dx + 2*delta;
          x := x + delta;
      until x > y;
    until False;
  end; {Kružnice}



procedure FindRoad(x1, y1, x2, y2 : integer; result_path: PComputedPath);
type
  pbuf=^tbuf;
  tbuf=array[0..200*4-1]of record
    x,y:integer;
    direction:byte
   end;
   {nacpak asi muze byt tohle? no ano, je to preci buffer (jakysi)}
   PResult= ^TResult;
   TResult= array[1..10000] of record
     x,y,prev_point:integer
   end;
   {do teto datove struktury to bude pro sebe ukladat cestu, kudy jit}

var
  BufferMap: pointer;
  {do tohlenctoho bafru si bude znacit prohledavani mapy- nepocmara si
   prece samotnou mapu!}
  Buf:pbuf;
  {kruhovy buffer o rozmeru 2*mensi z rozmeru mapy o slozkach 0..1
   jako pole rozmeru X a Y - todle semka napsal Lukas, zkusim mu verit}
  best_paths: PResult;
  to_read, to_write: integer;
  {ukazatele v kruhovem bufferu}
  best_paths_length, current, x, y: integer;
  {ukazatel konce a aktualniho prvku v poli a aktivni pmocne x a y bodu}
  dir, curr_dir: shortint;
  {uchovani from-smeru pro zapis noveho bodu a aktivni smer, kdetym jsme
   dojeli na tento bod}

  function  NewMap(oldmap : pointer; var map : pointer) : word;
  {Do toho, jaky ma mapa format, nevidim, ovsem tadle procedurka
   by mela asi alokovat pamet pro mapu obrazovky  map  stejne velkou,
   jako je  oldmap.}
  var size : word;
      f: file;
  begin
    size:=PWordArray(oldmap)^[6]*PWordArray(oldmap)^[5]+14;

    GetMem(map,size);
    fillchar(map^,size,0);
    PWordArray(map)^[0]:=PWordArray(oldmap)^[0];
    PWordArray(map)^[1]:=PWordArray(oldmap)^[1];
    PWordArray(map)^[2]:=PWordArray(oldmap)^[2];
    PWordArray(map)^[3]:=PWordArray(oldmap)^[3];
    PWordArray(map)^[4]:=PWordArray(oldmap)^[4];
    PWordArray(map)^[5]:=PWordArray(oldmap)^[5];
    PWordArray(map)^[6]:=PWordArray(oldmap)^[6];
    NewMap:=size
  end;


  procedure TryPixel(nX,nY:integer);
  {cosi to ozkoosi}
  begin
    if (nX>=0)and(nX<=319) and
       (nY>=0)and(nY<=199) and
{Tadyk se na to kouka, esli je to na obrazovce, akorat ty hodnoty trochu upravim...}
     ( not (not (getpixelmap(nx div delta,ny div delta,R_WalkMap))
     or(getpixelmap(nx div delta,ny div delta,BufferMap))) )
    then begin
      Buf^[to_write].x:=nX;
      Buf^[to_write].y:=nY;
      Buf^[to_write].direction:=dir;
      to_write:=succ(to_write) mod (400*2);

{$ifdef ladeni}
SetActivePage(ActivePage xor 1);
PutPixel(nX,nY,20);
SetActivePage(ActivePage xor 1);
{$endif}

      PutPixelMap(nx div delta,ny div delta,true,BufferMap);
      Inc(best_paths_length);
      best_paths^[best_paths_length].x:=nx;
      best_paths^[best_paths_length].y:=ny;
      best_paths^[best_paths_length].prev_point:=current;
    end
  end;

{!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!}
{teprv tady nam zacina procedurka FindRoad}
{!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!}
begin
  if (x2>(x1-delta))and(x2<(x1+delta))and(y2>(y1-delta))and(y2<(y1+delta))
  then begin
   {odchytim situaci, ze vychozi bod je stejny jako cilovy}
    G_WaySteps:=1;
    result_path^[G_WaySteps].x:=x1;
    result_path^[G_WaySteps].y:=y1;
    exit;
  end;
  NewMap(R_WalkMap, pointer(BufferMap));
{Tady se alokuje navic 8000 byte}
  New(Buf);
{tady 4000}
  New(best_paths);
{a tady 10000*6}
{tedy celkem dynamickych 72000 byte???}
  to_read:=0;
  to_write:=1;
  Buf^[0].x:=x1;
  Buf^[0].y:=y1;
  buf^[0].direction:=1;
  current:=1;
  best_paths_length:=1;
  best_paths^[1].x:=x1;
  best_paths^[1].y:=x2;
  best_paths^[1].prev_point:=0;
  PutPixelMap(x1,y1,true,BufferMap);
  {v bufferu je uveden seznam uz vyplnenych bodu, pri prochazeni uz se
   nezobrazuji, ale pouze se k nim vyhledaji sousede}

  while (to_read<>to_write)and(not((Buf^[to_read].x=x2)and(Buf^[to_read].y=y2))) do begin
  {dokud nevyprazdnime buffer nebo nenajdeme cestu}
  {and(to_read<804)and(to_write<803) }
    x:=Buf^[to_read].x;
    y:=Buf^[to_read].y;
    curr_dir:=buf^[to_read].direction;
    case curr_dir of
      1{4}:begin
        dir:=1; TryPixel(x,y-delta);    {horni bod}
        dir:=2; TryPixel(x,y+delta);    {dolni bod}
        dir:=3; TryPixel(x-delta,y);    {levy bod}
        dir:=4; TryPixel(x+delta,y)     {pravy bod}
      end;
      2{1}:begin
        dir:=2; TryPixel(x,y+delta);    {dolni bod}
        dir:=3; TryPixel(x-delta,y);    {levy bod}
        dir:=4; TryPixel(x+delta,y);    {pravy bod}
        dir:=1; TryPixel(x,y-delta)     {horni bod}
      end;
      3{2}:begin
        dir:=3; TryPixel(x-delta,y);    {levy bod}
        dir:=4; TryPixel(x+delta,y);    {pravy bod}
        dir:=1; TryPixel(x,y-delta);    {horni bod}
        dir:=2; TryPixel(x,y+delta)     {dolni bod}
      end;
      4{3}:begin
        dir:=4; TryPixel(x+delta,y);    {pravy bod}
        dir:=1; TryPixel(x,y-delta);    {horni bod}
        dir:=2; TryPixel(x,y+delta);    {dolni bod}
        dir:=3; TryPixel(x-delta,y)     {levy bod}
      end
    end;
    to_read:=succ(to_read) mod (400*2);
    Inc(current);
  end;
  if to_read=to_write then begin
    G_WaySteps:=1;
    result_path^[G_WaySteps].x:=x1;
    result_path^[G_WaySteps].y:=y1;
  {neexistuje cesta !!!!}
  end else begin
  {cesta existuje, vrat vhodne polozky z bufferu}
    G_WaySteps:=0;
    repeat
      inc(G_WaySteps);
      result_path^[G_WaySteps].x:=best_paths^[current].x;
      result_path^[G_WaySteps].y:=best_paths^[current].y;
      current:=best_paths^[current].prev_point;
    until best_paths^[current].prev_point=0;
    inc(G_WaySteps);
    result_path^[G_WaySteps].x:=x1;
    result_path^[G_WaySteps].y:=y1;
    {no a zapisu jeste uplne posledni bod cesty- tedy vlastne ten,
     na kterem drak prave stoji}

{tak jsem uz na cosi prisel- pruser je, kdyz bod, kam se ma dojit je
shodny s bodem, ze ktereho se vychazi; zkusim to odchytit uz pred
volanim FindRoad.. alebo coho vlastne...}

  end;
  Dispose(best_paths);
  Dispose(buf);
  DisposeMap(pointer(BufferMap));
end;

procedure ObliqueRoad;{=zkos, zesikmi cestu}
var
  KonvPole: PComputedPath;
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
  while G_WaySteps> 1 do begin
    i:=G_WaySteps;
    i1 := i;
    while (G_FoundWay^[i1].X=G_FoundWay^[i1-1].X)and(i1>1) do dec(i1);
    if i<>i1 then begin
      G_WaySteps:=i1;
      Inc(konvpoc);
      KonvPole^[konvpoc].x:= G_FoundWay^[i].X;
      KonvPole^[konvpoc].y:= G_FoundWay^[i].Y;
    end else begin
      i:=G_WaySteps;
      i1 := i;
      while (G_FoundWay^[i1].Y=G_FoundWay^[i1-1].Y)and(i1>1) do dec(i1);
      if i=i1 then Dec(i1);
      G_WaySteps:=i1;
      Inc(konvpoc);
      KonvPole^[konvpoc].x:= G_FoundWay^[i].X;
      KonvPole^[konvpoc].y:= G_FoundWay^[i].Y;
    end;
  end;
  Inc(konvpoc);
  KonvPole^[konvpoc].x:= G_FoundWay^[1].X;
  KonvPole^[konvpoc].y:= G_FoundWay^[1].Y;

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
    {if (Abs(BetwTwo / BetwOne)< (1/2))or(Abs(BetwOne)<= 3*delta)or(Abs(BetwTwo)<= 3*delta) then }begin
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
        StepX:= StepX/(Abs( (KonvPole^[i].y- KonvPole^[i-2].y) )+0.000001);
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
        if not GetPixelMap((FirstX+trunc(i1*delta* StepX))div delta, (FirstY+trunc(i1*delta* StepY))div delta, R_WalkMap)
        then break;
        {Testuju, esli se vsude pod zesikmenou cestou da jit. Pokud objevim
         bod, kam se neda jit, hned z testovaciho cyklu vyskocim, jinak odtud
         vyskocim, az prohlednu celou cestu}
      end;
{SetActivePage(ActivePage xor 1);}
      if (GetPixelMap((FirstX+trunc(i1*delta* StepX))div delta, (FirstY+trunc(i1*delta* StepY))div delta, R_WalkMap))
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
{readkey;}
    Inc(i);
  end;
{LS}
  {A nakonec ulozim prevedena data do pole, ze ktereho se budou cist}
  G_WaySteps:= 0;
  for i1:= konvpoc downto 1 do begin
    if not((KonvPole^[i1].x=0)and(KonvPole^[i1].y=0))then begin
      Inc(G_WaySteps);
      G_FoundWay^[G_WaySteps].X:= KonvPole^[i1].x;
      G_FoundWay^[G_WaySteps].Y:= KonvPole^[i1].y;
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

  H_.BeforeWayX:= X1;
  H_.MouseX:= X2;
  H_.LastHorMove:= DM_Undefined;

{$ifdef ladeni}
SetActivePage(ActivePage xor 1);
for f:= 0 to (319 div delta )do for g:= 0 to (199 div delta )do begin
  if GetPixelMap(f, g, R_WalkMap)then PutPixel(f*delta+1,g*delta+1,254);
end;
{$endif}

  {upravime souradnice KAM:}
  if not GetPixelMap(X2 div delta, Y2 div delta, R_WalkMap)then begin
    AdjustXYByCircle(x2,y2,6);
    {pokial zme klikoi mimo a je nastaven "inteligentni" pohled, tak..}
    if H_.SightOnMouse=5 then H_.SightOnMouse:= 1;
  end else if H_.SightOnMouse=5 then H_.SightOnMouse:= 0;
  if not GetPixelMap(X1 div delta, Y1 div delta, R_WalkMap)then AdjustXYByCircle(x1,y1,6);

{$ifdef ladeni}
PutPixel(x2,y2,255);
PutPixel(x2+1,y2,255);
PutPixel(x1,y1,255);
PutPixel(x1+1,y1,255);
SetActivePage(ActivePage xor 1);
{$endif}

  FindRoad(x1, y1, x2 ,y2, G_FoundWay);

{$ifdef ladeni}
SetActivePage(ActivePage xor 1);
for f:=G_WaySteps downto 2 do line(G_FoundWay^[f-1].x,G_FoundWay^[f-1].y,G_FoundWay^[f].x,G_FoundWay^[f].y,128);
SetActivePage(ActivePage xor 1);
{$endif}

  ObliqueRoad;

{$ifdef ladeni}
SetActivePage(ActivePage xor 1);
for f:=G_WaySteps downto 2 do line(G_FoundWay^[f-1].x,G_FoundWay^[f-1].y,G_FoundWay^[f].x,G_FoundWay^[f].y,40);
SetActivePage(ActivePage xor 1);
{$endif}
end;

procedure GoAfterCurve;
begin
  H_.FeetX:= H_.StartX;
  H_.FeetY:= H_.StartY;
  with A_SeqExtHead[H_.AfterCurve]^ do begin
    UserProc:= GoByWay;
  end;
  StartPhase(H_.AfterCurve);
end;

procedure GoBeforeFinal;
begin
  H_.FeetX:= H_.FinalX;
  H_.FeetY:= H_.FinalY;
  with A_SeqExtHead[Ord(H_.FinSight)]^ do begin
    UserProc:= FreeUserProc;
  end;
  StartPhase(Ord(H_.FinSight));

  H_OnDestination;
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
  H_.StartX:= H_.FeetX;
  H_.StartY:= H_.FeetY;

  if (PrevAnim= Ord(DM_Left))or(PrevAnim= Ord(DM_Right)) then H_.LastHorMove:= TDragonMoves(PrevAnim);
  {zaznamenavam, jakym horizontalnim smerem sel naposledy}

  if G_WaySteps>1 then begin
    i:= G_WaySteps;
    Dec(G_WaySteps);
    A_HeroContinue:= True;
    H_.YStrOblRatio:= Abs(sqr( (G_FoundWay^[i].Y-G_FoundWay^[G_WaySteps].Y) *1.2/delta) );
    H_.YStrOblRatio:= H_.YStrOblRatio+Abs(sqr( (G_FoundWay^[i].X-G_FoundWay^[G_WaySteps].X) /delta));
    H_.YStrOblRatio:= sqrt(H_.YStrOblRatio);
    {protoze je Pascal blbec, musim to pocitat prave takto...}
    {v H_.YStrOblRatio je nyni delka uhlopricky}
    if round(Abs(G_FoundWay^[i].Y-G_FoundWay^[G_WaySteps].Y)*1.2)>=Abs(G_FoundWay^[i].X-G_FoundWay^[G_WaySteps].X) then begin
      {Testuju, jestli je vetsi vzadlenost ve smeru pravo-levem nebo hore-dolnim}
      H_.XOblStep:= (G_FoundWay^[G_WaySteps].X-G_FoundWay^[i].X)/Abs(G_FoundWay^[G_WaySteps].Y-G_FoundWay^[i].Y);
      {V H_.XOblStep je o kolik bodu v x se ma posunout za 1 bod v y}
      H_.YOblStep:= 0;
      H_.YStrOblRatio:= Abs(G_FoundWay^[G_WaySteps].Y-G_FoundWay^[i].Y)/ H_.YStrOblRatio/ delta;
      H_.XStrOblRatio:= 1;
      {H_.YStrOblRatio je pomer mezi delkou y a sikmou delkou. Sikma delka je
       odmocnina z delky x na 2 plus delky y na 2 }
      if G_FoundWay^[i].Y>G_FoundWay^[G_WaySteps].Y then with A_SeqExtHead[Ord(DM_Up)]^ do begin
      {DM_Up}
        H_.FinalX:=G_FoundWay^[G_WaySteps].x;
        H_.FinalY:=G_FoundWay^[G_WaySteps].y;
        if PrevAnim<> Ord(DM_Up) then begin
          A_SeqExtHead[PrevAnim]^.InProcess:=0;
          {zastavil jsem animaci hl. hrdiny, ktera prave doprobihala}
          H_.AfterCurve:= Ord(DM_Up);
          H_.WalkSide:= 0;
          A_HeroContinue:= False;
          if (PrevAnim= Ord(DM_Left))or(PrevAnim= Ord(DM_StopLeft))  then begin
            {byla levo, spustim levo-hore}
            StartPhase( Ord(DM_LeftUp) );
            A_SeqExtHead[Ord(DM_LeftUp) ]^.UserProc:= GoAfterCurve;
            exit;
          end;
          if (PrevAnim= Ord(DM_Right))or(PrevAnim= Ord(DM_StopRight))  then begin
            StartPhase( Ord(DM_RightUp) );
            A_SeqExtHead[ Ord(DM_RightUp) ]^.UserProc:= GoAfterCurve;
            exit;
          end;
          StartPhase(Ord(DM_Up));
        end;
        UserProc:= GoByWay;
        exit;
      end else with A_SeqExtHead[ Ord(DM_Down) ]^ do begin
      {DM_Down}
        H_.FinalX:=G_FoundWay^[G_WaySteps].x;
        H_.FinalY:=G_FoundWay^[G_WaySteps].y;
        if PrevAnim<>Ord(DM_Down) then begin
          A_SeqExtHead[PrevAnim]^.InProcess:=0;
          H_.AfterCurve:= Ord(DM_Down);
          H_.WalkSide:=1;
          A_HeroContinue:= False;
          if (PrevAnim= Ord(DM_Left))or(PrevAnim= Ord(DM_StopLeft))  then begin
            StartPhase( Ord(DM_LeftDown) );
            A_SeqExtHead[ Ord(DM_LeftDown) ]^.UserProc:= GoAfterCurve;
            exit;
          end;
          if (PrevAnim= Ord(DM_Right))or(PrevAnim= Ord(DM_StopRight)) then begin
            StartPhase( Ord(DM_RightDown) );
            A_SeqExtHead[ Ord(DM_RightDown) ]^.UserProc:= GoAfterCurve;
            exit;
          end;
          StartPhase(Ord(DM_Down));
        end;
        UserProc:= GoByWay;
        exit;
      end;
    end else begin
      H_.YOblStep:= (G_FoundWay^[G_WaySteps].Y-G_FoundWay^[i].y)/Abs(G_FoundWay^[G_WaySteps].X-G_FoundWay^[i].x);
      {V H_.YOblStep je o kolik bodu v y se ma posunout za 1 bod v x}
      H_.XOblStep:= 0;
      H_.XStrOblRatio:= Abs(G_FoundWay^[G_WaySteps].X-G_FoundWay^[i].X)/ H_.YStrOblRatio/ delta;
      H_.YStrOblRatio:= 1;
      if G_FoundWay^[i].X<G_FoundWay^[G_WaySteps].X then with A_SeqExtHead[Ord(DM_Right)]^ do begin
      {DM_Right}
        H_.FinalX:=G_FoundWay^[G_WaySteps].x;
        H_.FinalY:=G_FoundWay^[G_WaySteps].y;
        if PrevAnim<>Ord(DM_Right) then begin
          A_SeqExtHead[PrevAnim]^.InProcess:=0;
          H_.AfterCurve:= Ord(DM_Right);
          H_.WalkSide:=2;
          A_HeroContinue:= False;
          if PrevAnim= Ord(DM_Down) then begin
            StartPhase( Ord(DM_DownRight) );
            A_SeqExtHead[ Ord(DM_DownRight) ]^.UserProc:= GoAfterCurve;
            exit;
          end;
          if PrevAnim= Ord(DM_Up) then begin
            StartPhase( Ord(DM_UpRight) );
            A_SeqExtHead[ Ord(DM_UpRight) ]^.UserProc:= GoAfterCurve;
            exit;
          end;
          if PrevAnim= Ord(DM_StopLeft)  then begin
            StartPhase( Ord(DM_LeftRight) );
            A_SeqExtHead[ Ord(DM_LeftRight) ]^.UserProc:= GoAfterCurve;
            exit;
          end;
          StartPhase(Ord(DM_Right));
        end;
        UserProc:= GoByWay;
        exit;
      end else with A_SeqExtHead[Ord(DM_Left)]^ do begin
      {DM_Left}
        H_.FinalX:=G_FoundWay^[G_WaySteps].x;
        H_.FinalY:=G_FoundWay^[G_WaySteps].y;
        if PrevAnim<> Ord(DM_Left) then begin
          A_SeqExtHead[PrevAnim]^.InProcess:=0;
          H_.AfterCurve:= Ord(DM_Left);
          H_.WalkSide:=3;
          A_HeroContinue:= False;
          if PrevAnim= Ord(DM_Down) then begin
            StartPhase( Ord(DM_DownLeft) );
            A_SeqExtHead[ Ord(DM_DownLeft) ]^.UserProc:= GoAfterCurve;
            exit;
          end;
          if PrevAnim= Ord(DM_Up) then begin
            StartPhase( Ord(DM_UpLeft) );
            A_SeqExtHead[ Ord(DM_UpLeft) ]^.UserProc:= GoAfterCurve;
            exit;
          end;
          if PrevAnim= Ord(DM_StopRight)  then begin
            StartPhase( Ord(DM_RightLeft) );
            A_SeqExtHead[ Ord(DM_RightLeft) ]^.UserProc:= GoAfterCurve;
            exit;
          end;
          StartPhase(Ord(DM_Left));
        end;
        UserProc:= GoByWay;
        exit;
      end;
    end;
  end;

  H_.XOblStep:= 0;
  H_.YOblStep:= 0;
  H_.XStrOblRatio:= 1;
  H_.YStrOblRatio:= 1;
  H_.WalkSide:=255;
  H_.FeetX:= H_.FinalX;
  H_.FeetY:= H_.FinalY;

  {tady vlastne urcim, kamze se to ma hrdina nyni koukat:}
  case H_.SightOnMouse of
    1: begin
         if (H_.FeetX>H_.MouseX) then H_.FinSight:= Ord(DM_StopLeft) else H_.FinSight:= Ord(DM_StopRight);
         {kouka se na mysku}
       end;
    3: begin
         H_.FinSight:= Ord(DM_StopRight);
       end;
    4: begin
         H_.FinSight:= Ord(DM_StopLeft);
       end;
    else begin
      if H_.LastHorMove=DM_Left then H_.FinSight:= Ord(DM_StopLeft)
      {posledni horiz. presun byl doleva}
      else if H_.LastHorMove=DM_Right then H_.FinSight:= Ord(DM_StopRight)
      {posledni horiz. presun byl doprava}
      else if(H_.FeetX<H_.BeforeWayX) then H_.FinSight:= Ord(DM_StopLeft) else H_.FinSight:= Ord(DM_StopRight);
      {Nepohyboval se ani DM_Right, ani DM_Left}
    end;
  end;

  if (PrevAnim<>Ord(DM_StopRight))and(PrevAnim<>Ord(DM_StopLeft)) then begin
  {pokracuji jenom v pripade, ze jsem opravdu odnekud dosel. Pokud uz stojim}
  {a koukam, nema cenu to koukani zapinat znovu, kdyz uz bezi}
    A_SeqExtHead[PrevAnim]^.InProcess:=0;
    {zastavim animaci, ktera probihala}
    {To, jaka se pripadne provede otocka, zavisi nejprve na tom, kam ta}
    {otocka vlastne bude}
    if H_.FinSight= Ord(DM_StopRight)then begin
      {Otocka buda do praveho stoje..., ale odkud}
      if PrevAnim=Ord(DM_Left) then begin
        with A_SeqExtHead[Ord(DM_LeftRight)]^ do begin
          UserProc:= GoBeforeFinal;
        end;
        StartPhase(Ord(DM_LeftRight));
        exit;
      end;
      if PrevAnim=Ord(DM_Up) then begin
        with A_SeqExtHead[Ord(DM_UpStopRight)]^ do begin
          UserProc:= GoBeforeFinal;
        end;
        StartPhase(Ord(DM_UpStopRight));
        exit;
      end;
    end else begin
      if PrevAnim=Ord(DM_Right) then begin
        with A_SeqExtHead[Ord(DM_RightLeft)]^ do begin
          UserProc:= GoBeforeFinal;
        end;
        StartPhase(Ord(DM_RightLeft));
        exit;
      end;
      if PrevAnim=Ord(DM_Up) then begin
        with A_SeqExtHead[Ord(DM_UpStopLeft)]^ do begin
          UserProc:= GoBeforeFinal;
        end;
        StartPhase(Ord(DM_UpStopLeft));
        exit;
      end;
    end;
    GoBeforeFinal;
  end else H_OnDestination;
end;

begin
  H_OnDestination:= FreeUserProc;
end.

{Notes on the walking code:

- flag immediately controls when to run the GPL2 program (immediately after
  clicking on the object without walking at all / after reaching the
  destination)
- quickhero controls whether to wait for the timer when switching walking
  animation phases (otherwise it's 1 phase per redraw)
- commands WalkOn/WalkOnPlay walk on the background / in an inner loop waiting
  till the end.  StayOn just teleports (initializes) the hero to the given
  coordinate

AdjustXYByCircle = finds the nearest walkable point
InitWay = adjusts both starting and final point, finds shortest path, and
  obliques it
GoByWay = called at the beginning of each line segment.  If the hero is turned
  well, starts walking animation directly (with GoBayWay callback), otherwise
  starts turning animation (with GoAfterCurve callback).  At the final point,
  starts turning animation (with GoBeforeFinal callback).  All callbacks
  mentioned above are stores in UserProc field of the animation and are called
  by the animation library.
GoAfterCurve = called after the turning animation is done.  Retrieves
  previously stored folling animation ID and starts it with callback GoByWay.
GoBeforeFinal = called at the final point.  starts stop animation and calls the
  callback H_OnDestination, which always points to H_OnDeObal.
H_OnDeObal = called when walking is done.  Either calls a GPL2 program or sets
  the exit loop flag.

The actual walking is handled by the animation library in procedure NextPhase.
If the object being animated is the hero, it reads deltaX, deltaY, moves the
hero, and calls the callback after the last frame (if the animation isn't
cyclic) or when the hero has reached the destination point (in either case).
The flag A_HeroContinue denotes whether walking continues after calling
UserProc.  If UserProc was GoByWay (middle turning point), it is set to true.
}
