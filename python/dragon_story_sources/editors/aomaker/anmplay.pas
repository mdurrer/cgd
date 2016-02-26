{v hlavicce animacni sekvence musi byt i: aktualni faze!}

{nemely by byt u relativni animace, (nebo aspon u hlavniho hrdiny)
 jeho souradnice? u hlav. hrdiny kazdopadne i souradnice, kam ma
 dojit}

{nezapomenout na uzivatelskou proceduru pri skonceni animacni sekvence;
 te procedure by se mohly standardne predavat zmenene X,Y ... anebo
 radeji udelat jen nejake obecne volani, at si to zjisti sama...}

{nejakej prepinac, at to bere prioritu z Y-ovych souradnic}

{taky prepinac na to, aby to bralo ZoomX a ZoomY odnekud zvnejska-
 treba tak, ze zadam adresy, kde budou wordy ZoomX a ZoomY pro
 ten objekt; jinak se vsechno bere z popisu sekvence}

{taky: aby to nasobilo relativni souradnice faktorem- bud si to bude
 zjistovat pomer mezi fyzickou velikosti obrazku a jeho Zoom a tim
 ty souradnice vynasobi, anebo to bude brat faktor odnekud zvenci...
 spis zjistovat a nasobit...}

{I kdyz- predevsim predchozi tri body jsou prakticky podstatne pouze
 pro relativni animaci zatim jenom hlavniho hrdiny- nebylo by lepsi
 vykaslat se na ty vsechny prepinace a moznosti u obecnych animaci
 a udelat to na fest pro obecne a pro hlavniho hrdinu zvlast?}

unit anmplay;

interface

uses dfw, graph256, soundpas, comfreq2, animace3;

var
  I_SumLoopTimes, I_SumLoopPasses: longint;
  {pocitam tim, jak dlouho mi trva nakresleni jedne faze}
  I_SumDelays: byte;
  {Pokud je to pomalejsi, nez chci, nejprve to zvysim, az to bude
   pomalejsi po x-te, teprve potom snizuju frekvenci, atd...}

  S_Persp0, S_PerspStep: real;
  VelDrakaX, VelDrakaY: word;
const
  I_Freq08InHz: word= 10000; {nastavena frekvence osmicky}
  I_SoundDevice: TOutDevice= Blaster;
  I_ShortestAnimDelay: word= 10; {doba mezi opetovnym prepnutim dvou}
                                 {animacnich stranek v setinach sekundy}

  MaxSeq= 50; {max. pocet animacnich sekvenci, pro ktere je tabulka}
  MaxAnmP_Sprites=150; {max. pocet sprajtu, pro ktery je tabulka}
  MaxAnmP_Samples= 50; {max. poc. samplu, pro ktery jsou tabulky}

  PictureStore= 'e:\aomaker\letadlo.an1';
  SampleStore= 'e:\aomaker\letadlo.an3';
  AnimStore= 'e:\aomaker\letadlo.an5';

  LengthTAnmPhase= 17;          {delka zaznamu jedne animacni faze v bytes}
  LengthTAnmHeader= 5;          {delka zaznamu hlavicky animace}
  LengthTAnmExtHeader= 24;       {delka rozsireneho zaznamu hlavicky animace}
type
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
  PAnimation= ^TAnimation;

  TAnmExtHeader= record  {rozsireni hlavicky animacni sekvence}
    InProcess      : byte;      {0 kdyz je v klidu, 1 kdyz uz bezi}
    AnimObj        : byte;      {k jakemu skutecnemu animacnimu objektu z animace
                                 patri tato sekvence}
    ActPhase       : byte;      {aktualni faze, ve ktere se sekvence nachazi}
    BigPict        : pointer;   {ukazatel na nejvetsi obrazek animace typu memory/disk}
    BigSam         : pointer;   {ukazatel na nejvetsi sampl animace typu memory/disk}
    UserProc       : procedure; {uzivatelske volani pote, co skonci sekvence}
    CountDelay     : longint;   {ulozi se sem hodnota TimerDW, jaka je, kdyz se faze
                                 prekresluje. Pro prechod na dalsi fazi se porovnava
                                 hodnota delay prave s (aktualni TimerDw- CountDelay)
                                 }

    MainHero       : byte;      {1= hlavni hrdina; ZoomX a ZoomY se budou brat
                                 podle perspektivy; pokud je animace cyklicka,
                                 ukonci se, az dojde to hodnot FinalX a FinalY}
    FinalX         : integer;   {souradnice, kam ma dojit cyklicka animace hl. hrdiny}
    FinalY         : integer;
  end;

  PExtHeader= ^TAnmExtHeader;


var


  LastAnmSeq: byte; {posledni animacni sekvence- cislo posledni polozky v
                     AnmP_Sequences}
  AnmP_Sequences: array[1..MaxSeq] of PAnimation;
  {pole adres animacnich sekvenci}
  AnmP_SeqExtHead: array[1..MaxSeq] of PExtHeader;
  {pole adres rozsirenych hlavicek animacnich sekvenci}

{v nasledujich polich jsou ulozeny ty adresy, jak je nize popsano. Vicemene
 je to takhle reseno proto, aby v pameti nebylo nic zbytecnyho (samozrejme
 prave krome tech poli...)
 Jak to bude fungovat:
 Adresa kazdyho obrazku, samplu, co je natrvalo v pameti se ulozi do tohoto
 pole. Kdyz se budou nacitat dalsi natrvalo v pameti ulozene sekvence, pri
 nacitani... huh, uz me to vysvetlovani nebavi, uvidime, jak to vlastne bude}
  AnmP_Sprites: array[1..MaxAnmP_Sprites] of pointer;
  {pole adres sprajtu pouzitych v sekvencich, co jsou cele psany nastalo pro pamet}
  AnmP_StoreSprNum: array[1..MaxAnmP_Sprites] of word;
  {pole skladovych cisel sprajtu pouzitych v sekvencich, co jsou cele psany nastalo pro pamet}
  AnmP_SpritesUses: array[1..MaxAnmP_Sprites] of byte;
  {ke kazdemu ulozenemu sprajtu je zde, kolikrat je pouzit. Pri odinstalovani se toto
   stale zmensuje, a az dojde k 0, teprve se odinstaluje}
  AnmP_Samples: array[1..MaxAnmP_Samples] of pointer;
  {pole adres samplu pouzitych v sekvencich, co jsou cele psany nastalo pro pamet}
  AnmP_StoreSamNum: array[1..MaxAnmP_Samples] of word;
  {pole sklad. cisel  samplu pouzitych v sekvencich, co jsou cele psany nastalo pro pamet}
  AnmP_SamplesUses: array[1..MaxAnmP_Sprites] of byte;
  {ke kazdemu ulozenemu samplu je zde, kolikrat je pouzit. Pri odinstalovani se toto
   stale zmensuje, a az dojde k 0, teprve se odinstaluje}
  AnmP_SamSizs: array[1..MaxAnmP_Samples] of word;
  {pole delek samplu pouzitych v sekvencich, co jsou cele psany nastalo pro pamet}
  LastLoadedPicture, LastLoadedSample: byte;
  {posledni polozky v tabulkach}

  NextPhaseNewSound: word; {priznak, jestli se v teto fazi spousti sampl
                            0- NE, 1- SPOUSTI SE}

  ANMPath, SamPath, PictPath: string;
  {uplna cesta ke skladu obrazku - zatim kuli animacim  "memory/disk" }

  procedure FreeUserProc;
  procedure InitFirstPhase(SeqNum: byte);
  procedure NextPhase(SeqNum: byte);
  procedure Body;
  procedure LoadAnimationSeq(Item: word);

implementation
var
(*
  NextPhaseSoundFutureSeg: word; {priznak, jestli se v teto fazi spousti sampl
                            0- NE, 1- SPOUSTI SE}
*)
  NextPhaseSound: TOneChannel;
  {hodnoty, ktere se zapisou do promennych 0-teho kanalu po prehozeni stranek}


procedure FreeUserProc;
begin
end;

procedure InitFirstPhase(SeqNum: byte);
begin
  if AnmP_SeqExtHead[SeqNum]^.InProcess= 0 then Exit;
  {Pokud animacni sekvence neni aktivni, zatim se neinicializuje}
  {Inicializovat se musi tesne pred tim, nez zacne byt aktivni}
  AnmP_SeqExtHead[SeqNum]^.CountDelay:= Time08^.TimerDW-1000;
  AnmP_SeqExtHead[SeqNum]^.ActPhase:= 0;
  with AnmP_Sequences[SeqNum]^.Phase[1] do begin
    if Picture> 0 then begin
      {pokud je rozumne cislo obrazku, zmenim sprajt, a to nasledovne:}
      if AnmP_Sequences[SeqNum]^.Header.MemoryLogic= 0 then begin
   {take cislo skutecneho animacniho objektu, se kterym hybe tato sekvence,
    bych mel znat; ze bych to strcil do hlavicky!??!!}
         AddSpriteToObj(AnmP_SeqExtHead[SeqNum]^.AnimObj, 0, AnmP_Sprites[Picture]);
      end else begin
        CReadItem(PictPath, AnmP_SeqExtHead[SeqNum]^.BigPict, Picture);
        {nacetl jsem sprajt}
      end;
{      RepaintAObj(AnmP_SeqExtHead[SeqNum]^.AnimObj);}
      VisibleAObj(AnmP_SeqExtHead[SeqNum]^.AnimObj);
    end;
    if AnmP_Sequences[SeqNum]^.Header.Relative= 0 then begin
      NewPosAObj(AnmP_SeqExtHead[SeqNum]^.AnimObj, X, Y);
    {Pokud ma objekt absolutni souradnice, placne to na ne}
    end else begin
(*
      NewPosAObj(AnmP_SeqExtHead[SeqNum]^.AnimObj,
        GetNewXAObj(AnmP_SeqExtHead[SeqNum]^.AnimObj),
        GetNewYAObj(AnmP_SeqExtHead[SeqNum]^.AnimObj));
*)
    {Pokud jsou souradnice relativni, musi se uz predem zadat pomoci NewPos...}
    end;
    NewZoomAObj(AnmP_SeqExtHead[SeqNum]^.AnimObj, ZoomX, ZoomY);
    NewMirrorAObj(AnmP_SeqExtHead[SeqNum]^.AnimObj, Mirror);
  end;
end;


procedure NextPhase(SeqNum: byte);
begin
  if AnmP_SeqExtHead[SeqNum]^.InProcess= 0 then Exit;
  {Pokud animacni sekvence neni aktivni, nepracuje se s ni}
  if (Time08^.TimerDW- AnmP_SeqExtHead[SeqNum]^.CountDelay)>=
  AnmP_Sequences[SeqNum]^.Phase[AnmP_SeqExtHead[SeqNum]^.ActPhase].Delay then begin
    {OK, uz muzeme prejit na dalsi fazi}
    AnmP_SeqExtHead[SeqNum]^.CountDelay:= Time08^.TimerDW;
      if(AnmP_SeqExtHead[SeqNum]^.MainHero=1)and(AnmP_Sequences[SeqNum]^.Header.Cyclic= 1) then
      with AnmP_SeqExtHead[SeqNum]^ do begin
      {V pripade, ze jde o cyklickou animaci hlavniho hrdiny, overim,
      jestli se uz hrdina nenachazi v predepsanem miste}
        if (GetNewXAObj(AnimObj)>FinalX-20)and
        (GetNewXAObj(AnimObj)<FinalX+20)and
        (GetNewYAObj(AnimObj)>FinalY-20)and
        (GetNewYAObj(AnimObj)<FinalY+20)then begin
          {zjistili jsme, ze hrdina je tam, kde mel byt...}
          AnmP_SeqExtHead[SeqNum]^.InProcess:= 0;
          {      AnmP_SeqExtHead[SeqNum]^.UserProc;}
          Exit;
          {pokud neni cyklicka, skoncili jsme}
        end;
      end;


    if AnmP_SeqExtHead[SeqNum]^.ActPhase= AnmP_Sequences[SeqNum]^.Header.NumOfPhases then begin
    {obslouzim, kdyz jsme na konci sekvence}
      if AnmP_Sequences[SeqNum]^.Header.Cyclic= 1 then begin
        AnmP_SeqExtHead[SeqNum]^.ActPhase:= 1;
        {pokud je cyklicka, zacnu znovu od zacatku}
      end else begin
        AnmP_SeqExtHead[SeqNum]^.InProcess:= 0;
        {      AnmP_SeqExtHead[SeqNum]^.UserProc;}
        Exit;
        {pokud neni cyklicka, skoncili jsme}
  {pozor, dat sem nejakou odinstalaci animace... ci co...}
      end;
    end else begin
  {ActPhase musim strcit do hlavicky!!!}
      Inc(AnmP_SeqExtHead[SeqNum]^.ActPhase);
      {jinak prejdu na dalsi fazi}
    end;

    with AnmP_Sequences[SeqNum]^.Phase[AnmP_SeqExtHead[SeqNum]^.ActPhase] do begin
      if Picture> 0 then begin
        {pokud je rozumne cislo obrazku, zmenim sprajt, a to nasledovne:}
        if AnmP_Sequences[SeqNum]^.Header.MemoryLogic= 0 then begin
     {take cislo skutecneho animacniho objektu, se kterym hybe tato sekvence,
      bych mel znat; ze bych to strcil do hlavicky!??!!}
           AddSpriteToObj(AnmP_SeqExtHead[SeqNum]^.AnimObj, 0, AnmP_Sprites[Picture]);
     {Jak se tak divam, pouzivam tady jak blazen nektera data ze slozite struktury,
      na ktere navic jeste ukazuje ukazatel, takze to urcite janevimkolikrat
      preadresovava- ze bych si tady dal lokalni promennou, aspon ActPhase???}
        end else begin
          CReadItem(PictPath, AnmP_SeqExtHead[SeqNum]^.BigPict, Picture);
          {nacetl jsem sprajt}
        end;
        RepaintAObj(AnmP_SeqExtHead[SeqNum]^.AnimObj);
      end;
      if Sample> 0 then begin
      {pokud je rozumne cislo samplu, nastavim ho, aby hral}
        if AnmP_Sequences[SeqNum]^.Header.MemoryLogic= 0 then begin
          NextPhaseSound.SizeCh:= AnmP_SamSizs[Sample];
          NextPhaseSound.ChOfs:= Ofs(AnmP_Samples[Sample]^);
          NextPhaseSound.ChActPos:= Ofs(AnmP_Samples[Sample]^);
          NextPhaseSound.ChSeg:= Seg(AnmP_Samples[Sample]^);
  {        NextPhaseSoundFutureSeg:= Seg(AnmP_Samples[Sample]^);}
        end else begin
          CReadItem(SamPath, AnmP_SeqExtHead[SeqNum]^.BigSam, Sample);
          {nacetl jsem sampl}
          NextPhaseSound.SizeCh:= UnpackedItemSize(SamPath, Sample);
          NextPhaseSound.ChOfs:= Ofs(AnmP_SeqExtHead[SeqNum]^.BigSam^);
          NextPhaseSound.ChActPos:= Ofs(AnmP_SeqExtHead[SeqNum]^.BigSam^);
          NextPhaseSound.ChSeg:= Seg(AnmP_SeqExtHead[SeqNum]^.BigSam^);
  {        NextPhaseSoundFutureSeg:= Seg(AnmP_SeqExtHead[SeqNum]^.BigSam^);}
        end;
          NextPhaseSound.ChVolume:= 51;
          NextPhaseSound.ChLoop:= 0;
          NextPhaseSound.ChLooped:= 0;
          NextPhaseSound.ChLenLp:= 2;

          NextPhaseSound.Krok:=  Hi(word   (round  (256* (Frequency/I_Freq08InHz) )  )   );
          NextPhaseSound.OvrLd:= Lo(word   (round  (256* (Frequency/I_Freq08InHz) )  )   );

  {        NextPhaseSound.ChSeg:= 0;}
          NextPhaseNewSound:= 1;
          {nula tady nam rekne, ze pri prehazovani stranek sem mam zapsat hodnotu}
      end;
      if AnmP_Sequences[SeqNum]^.Header.Relative= 0 then begin
        NewPosAObj(AnmP_SeqExtHead[SeqNum]^.AnimObj, X, Y);
      end else if AnmP_SeqExtHead[SeqNum]^.MainHero= 1 then begin
        NewPosAObj(AnmP_SeqExtHead[SeqNum]^.AnimObj,
          round( (S_Persp0+ GetNewYAObj(AnmP_SeqExtHead[SeqNum]^.AnimObj)*S_PerspStep)*X)+
          +GetNewXAObj(AnmP_SeqExtHead[SeqNum]^.AnimObj),
          round( (S_Persp0+ GetNewYAObj(AnmP_SeqExtHead[SeqNum]^.AnimObj)*S_PerspStep)*Y)+
          +GetNewYAObj(AnmP_SeqExtHead[SeqNum]^.AnimObj));
      end else begin
        NewPosAObj(AnmP_SeqExtHead[SeqNum]^.AnimObj,
          X+GetNewXAObj(AnmP_SeqExtHead[SeqNum]^.AnimObj),
          Y+GetNewYAObj(AnmP_SeqExtHead[SeqNum]^.AnimObj));
      end;
      if AnmP_SeqExtHead[SeqNum]^.MainHero= 1 then begin
        ZoomX:= round( (S_Persp0+ GetNewYAObj(AnmP_SeqExtHead[SeqNum]^.AnimObj)*S_PerspStep)*
          PWordArray(AnmP_Sprites[Picture])^[0] );
        ZoomY:= round( (S_Persp0+ GetNewYAObj(AnmP_SeqExtHead[SeqNum]^.AnimObj)*S_PerspStep)*
          PWordArray(AnmP_Sprites[Picture])^[1] );
      end;
      NewZoomAObj(AnmP_SeqExtHead[SeqNum]^.AnimObj, ZoomX, ZoomY);
      NewMirrorAObj(AnmP_SeqExtHead[SeqNum]^.AnimObj, Mirror);
    end;
  end;
end;

procedure Body;
var
  f: byte;
begin
  for f:= 1 to LastAnmSeq do begin
    NextPhase(f);
  end;
  {projel jsem vsechny sekvence}
  SmartPutAObjs;
  {placnu to do neviditelne stranky}
  WaitVRetrace;
  SwapAnimPages;
  {ted prepnu stranky}

{  if(NextPhaseSound.ChSeg=0) then begin
    NextPhaseSound.ChSeg:= NextPhaseSoundFutureSeg;
}
  if(NextPhaseNewSound=1) then begin
    NextPhaseNewSound:= 0;
    Sound_Channels^.i[0].ChSeg:=   NextPhaseSound.ChSeg;
{    Sound_Channels^.i[0].ChSeg:=   NextPhaseSoundFutureSeg;}
    Sound_Channels^.i[0].ChVolume:= NextPhaseSound.ChVolume;
    Sound_Channels^.i[0].SizeCh:= NextPhaseSound.SizeCh;
    Sound_Channels^.i[0].ChLoop:= NextPhaseSound.ChLoop;
    Sound_Channels^.i[0].ChLooped:= NextPhaseSound.ChLooped;
    Sound_Channels^.i[0].ChLenLp:= NextPhaseSound.ChLenLp;
    Sound_Channels^.i[0].Krok:=  NextPhaseSound.Krok;
    Sound_Channels^.i[0].OvrLd:= NextPhaseSound.OvrLd;
    Sound_Channels^.i[0].ChOfs:= NextPhaseSound.ChOfs;
    Sound_Channels^.i[0].ChActPos:= NextPhaseSound.ChActPos;
    {az teprve ted muzu naladovat hodnoty primo do promennych 0. kanalu,}
    {aby to zaclo hrat zaroven s prepnutim faze}
  end;
  I_SumLoopTimes:= I_SumLoopTimes+ Time08^.TimerWord1;
  Inc(I_SumLoopPasses);
  {Tady prubezne pocitam, jak dlouho mi trva nakresleni jedne faze}
end;

(*
  if (Time08^.TimerWord1 div DefShortsAnimDelay)< AnmP_Sequences[SeqNum]^.Phase[ActPhase].Delay then
    repeat until (AnmP_Sequences[SeqNum]^.Phase[ActPhase].Delay= (Time08^.TimerWord1 div DefShortsAnimDelay) );
  Time08^.TimerWord1:= 0;

  until ((KeyPressed)and(ReadKey=#27));
  {jedu az do stisteni  Escape}
*)

procedure LoadAnimationSeq(Item: word);
var
  f, g, h: byte;
  BiggestPict, BiggestSam: word;
  SeqNum: byte;
begin
  Inc(LastAnmSeq);
  SeqNum:= LastAnmSeq;
  CLoadItem(ANMPath, pointer(AnmP_Sequences[SeqNum]), Item);
  GetMem(AnmP_SeqExtHead[SeqNum], LengthTAnmExtHeader);
  AnmP_SeqExtHead[SeqNum]^.InProcess:= 0;

  if AnmP_Sequences[SeqNum]^.Header.MemoryLogic=0 then begin
    {vsechny obrazky v pameti}
    for h:= 1 to AnmP_Sequences[SeqNum]^.Header.NumOfPhases do with AnmP_Sequences[SeqNum]^.Phase[h] do begin
      {projdu vsechny faze}
      if Picture>1 then begin
        {v uvahu beru jenom platne cislo obrazku, kdyz je neplatne, fazi ignoruji}
        g:= 1;
        while(Picture<> AnmP_StoreSprNum[g])and(g<=LastLoadedPicture) do Inc(g);
        {proberu uz nactene obrazky, jestli mezi nimi tento neni}
        if(g> LastLoadedPicture)or(g= LastLoadedPicture)and(Picture<> AnmP_StoreSprNum[g])then begin
          {nactu obrazek, jeste v pameti neni}
          Inc(LastLoadedPicture);
          CLoadItem(PictPath, AnmP_Sprites[LastLoadedPicture], Picture);
          {nacetl jsem sprajt}
          AnmP_StoreSprNum[LastLoadedPicture]:= Picture;
          Picture:= LastLoadedPicture;
          AnmP_SpritesUses[LastLoadedPicture]:= 1;
          {pocet pouziti obrazku nastavim zatim na 1}
        end else begin
          Picture:= g;
          {obrazek uz v pameti je, jenom zapisu jeho cislo}
          Inc(AnmP_SpritesUses[g]);
          {a zvysim pocet pouziti obrazku}
        end;

      end else Picture:= 0;
    end;
    for h:= 1 to AnmP_Sequences[SeqNum]^.Header.NumOfPhases do with AnmP_Sequences[SeqNum]^.Phase[h] do begin
      {projdu vsechny faze}
      if Sample>1 then begin

        g:= 1;
        while(Sample<> AnmP_StoreSamNum[g])and(g<=LastLoadedSample) do Inc(g);
        {proberu uz nactene samply, jestli mezi nimi tento neni}
        if(g> LastLoadedSample)or(g= LastLoadedSample)and(Sample<> AnmP_StoreSamNum[g])then begin

          {nactu sampl, jeste v pameti neni}
          Inc(LastLoadedSample);
          CLoadItem(SamPath, AnmP_Samples[LastLoadedSample], Sample);
          {nacetl jsem sampl}
          AnmP_SamSizs[LastLoadedSample]:= UnpackedItemSize(SamPath, Sample);
          AnmP_StoreSamNum[LastLoadedSample]:= Sample;
          Sample:= LastLoadedSample;
          AnmP_SamplesUses[LastLoadedSample]:= 1;
          {pocet pouziti samplu nastavim zatim na 1}

        end else begin
          Sample:= g;
          {sampl uz v pameti je, jenom zapisu jeho cislo}
          Inc(AnmP_SamplesUses[g]);
          {a zvysim pocet pouziti samplu}
        end;

(*          Inc(LastLoadedSample);
          CLoadItem(SamPath, AnmP_Samples[LastLoadedSample], Sample);
          AnmP_SamSizs[LastLoadedSample]:= UnpackedItemSize(SamPath, Sample);
          Sample:= LastLoadedSample;
          {nacetl jsem sprajt}
*)
      end else begin
        Sample:= 0;
      end;
    end;

  end else begin
    {kdyz to pouze v pameti vyhradi misto a taha to do neho}
{    Inc(LastLoadedPicture);}
    BiggestPict:= 0;
    for f:= 1 to AnmP_Sequences[SeqNum]^.Header.NumOfPhases do with AnmP_Sequences[SeqNum]^.Phase[f] do begin
      if Picture>1 then begin
        g:= 0;
        repeat Inc(g) until Picture=AnmP_Sequences[SeqNum]^.Phase[g].Picture;
        if g=f then if UnpackedItemSize(PictPath, Picture)>BiggestPict then
          BiggestPict:= Picture;
      end else Picture:= 0;
    end;
    GetMem(AnmP_SeqExtHead[SeqNum]^.BigPict, UnpackedItemSize(PictPath, BiggestPict) );
    {alokuju pamet pro nejvetsi ze vsech sprajtu}
{    CReadItem(PictPath, AnmP_SeqExtHead[SeqNum]^.BigPict, AnmP_Sequences[SeqNum]^.Phase[1].Picture);}
    {nacetl jsem sprajt}
{tady zatim kaslu na samply!!}
    BiggestSam:= 0;
    for f:= 1 to AnmP_Sequences[SeqNum]^.Header.NumOfPhases do with AnmP_Sequences[SeqNum]^.Phase[f] do begin
      if Sample>1 then begin
        g:= 0;
        repeat Inc(g) until Sample=AnmP_Sequences[SeqNum]^.Phase[g].Sample;
        if g=f then if UnpackedItemSize(SamPath, Sample)>BiggestSam then
          BiggestSam:= Sample;
      end else Sample:= 0;
    end;
    GetMem(AnmP_SeqExtHead[SeqNum]^.BigSam, UnpackedItemSize(SamPath, BiggestSam) );
    {alokuju pamet pro nejvetsi ze vsech sprajtu}
{    CReadItem(SamPath, AnmP_SeqExtHead[SeqNum]^.BigSam, AnmP_Sequences[SeqNum]^.Phase[1].Sample);}
    {nacetl jsem sprajt}
  end;
end;




begin
{  NextPhaseNewSound:= 0;}
end.
