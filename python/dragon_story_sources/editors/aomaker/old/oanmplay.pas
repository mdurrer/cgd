unit oanmplay;

interface

uses animace, soundpas, dfw;

const
  AnimItem= 2;
  PictureStore= 'e:\aomaker\letadlo.an1';
  SampleStore= 'e:\aomaker\letadlo.an3';
  AnimStore= 'e:\aomaker\letadlo.an5';
  AnimPopisStore= 'e:\aomaker\letadlo.an4';

  LengthTAnmPhase= 16;          {delka zaznamu jedne animacni faze v bytes}
  LengthTAnmHeader= 5;          {delka zaznamu hlavicky animace}
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
    Delay        : byte;        {zdrzeni pred dalsi fazi}
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


implementation

procedure VyrobZkusebniAnimaci;
var
  ZkAnim: PAnimation;
  i: byte;
  polozka: word;
  NazevZk: string[12];
begin
  GetMem(ZkAnim, LengthTAnmHeader+LengthTAnmPhase*6);
  with ZkAnim^.Header do begin
    NumOfPhases:= 6;
    MemoryLogic:= 0;
    DisableErasing:= 0;
    Cyclic:= 0;
    Relative:= 0;
  end;
  for i:= 1 to 6 do begin
    with ZkAnim^.Phase[i] do begin
      Picture      :=i+1;
      X            :=300-i*20;
      Y            :=150-i*10;
      ZoomX        :=0;
      ZoomY        :=0;
      Mirror       :=0;
      Sample       :=0;
      Frequency    :=0;
      Delay        :=2;
    end;
  end;
  polozka:= CAddFromMemory(AnimStore, ZkAnim, LengthTAnmHeader+LengthTAnmPhase*6);
  WriteLn(polozka);
  NazevZk:= 'let_letadylk';
  polozka:= CAddFromMemory(AnimPopisStore, @NazevZk, 13);
  WriteLn(polozka);

end;




begin
end.
