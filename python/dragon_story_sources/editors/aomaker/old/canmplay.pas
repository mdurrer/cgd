unit canmplay;

interface

uses animace, soundpas, dfw;

const
  AnimItem= 2;
  PictureStore= 'e:\aomaker\letadlo.an1';
  SampleStore= 'e:\aomaker\letadlo.an3';
  AnimStore= 'e:\aomaker\letadlo.an5';
  AnimPopisStore= 'e:\aomaker\letadlo.an4';

  OldLengthTAnmPhase= 16;          {delka zaznamu jedne animacni faze v bytes}
  OldLengthTAnmHeader= 5;          {delka zaznamu hlavicky animace}
  LengthTAnmPhase= 17;          {delka zaznamu jedne animacni faze v bytes}
  LengthTAnmHeader= 5;          {delka zaznamu hlavicky animace}
type

  OldTAnmPhase= record
    OPicture      : word;        {cislo obrazku ze skladu}
    OX            : integer;     {souradnice x}
    OY            : integer;     {souradnice y}
    OZoomX        : word;        {zoom na ose x}
    OZoomY        : word;        {zoom na ose y}
    OMirror       : byte;        {0=normal, 1=zrcadlit obrazek}
    OSample       : word;        {cislo samplu ze skladu}
    OFrequency    : word;        {frekvence samplu}
    ODelay        : byte;        {zdrzeni pred dalsi fazi}
  end;
  OldTAnmHeader= record
    ONumOfPhases    : byte;      {pocet fazi animace}
    OMemoryLogic    : byte;      {0=vsechny sprajty jsou v pameti (napr. chuze hlavniho hrdiny)
                                 1=v pameti vyhrazeno misto pro nejvetsi
                                   sprajt a vsechny sprajty se nacitaji
                                   prave do tohoto mista (napr. okno, ktere je nejdriv cele,
                                   pak se rozbiji a nakonec je rozbite)
                                 2=sprajty se pricitaji z disku (napr. jak se hl. hrdina
                                   pro neco shyba, neco pouziva...)}
    ODisableErasing : byte;      {0=maze se pod, 1=nemaze se}
    OCyclic         : byte;      {0=zacit a skoncit, 1=cyklicka furt dokola}
    ORelative       : byte;      {0=absolutni souradnice, 1=relativni}
  end;
  OldTAnmPhasesArray= array[1..255] of OldTAnmPhase;
  OldTAnimation= record
    OHeader         : OldTAnmHeader;
    OPhase          : OldTAnmPhasesArray;
  end;

  OldPAnimation= ^OldTAnimation;

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

procedure ZkonvertujAnimaciDelay(Anm_Name: string);

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

procedure ZkonvertujAnimaciDelay(Anm_Name: string);
var
  OldAnim: OldPAnimation;
  ConvAnim: PAnimation;
  i: byte;
  polozka: word;

  procedure ReadSequenceFromStore(What: byte);
  var
    f: byte;
    hw: word;
    hb: byte;
  begin
    CLoadItem(ANM_Name+'.AN5', pointer(OldAnim), What );
    with ConvAnim^.Header do begin
      NumOfPhases:= OldAnim^.OHeader.ONumOfPhases;
      MemoryLogic:= OldAnim^.OHeader.OMemoryLogic;
      DisableErasing:= OldAnim^.OHeader.ODisableErasing;
      Cyclic:= OldAnim^.OHeader.OCyclic;
      Relative:= OldAnim^.OHeader.ORelative;
    end;
    for f:= 1 to ConvAnim^.Header.NumOfPhases do begin
      with ConvAnim^.Phase[f] do begin
        hw := OldAnim^.OPhase[f].OPicture;
        Picture:= hw;
        hw:= OldAnim^.OPhase[f].OX;
        X := hw;
        hw     := OldAnim^.OPhase[f].OY;
        Y :=hw;
        hw      := OldAnim^.OPhase[f].OZoomX;
        ZoomX:= hw;
        hw     := OldAnim^.OPhase[f].OZoomY;
        ZoomY:= hw;
        hb    := OldAnim^.OPhase[f].OMirror;
        Mirror:= hb;
        hw  := OldAnim^.OPhase[f].OSample;
        Sample:= hw;
        hw  := OldAnim^.OPhase[f].OFrequency;
        Frequency:= hw;
        hw      := OldAnim^.OPhase[f].ODelay;
        Delay:= hw;
        Delay        := Delay AND $00ff;
      end;
    end;
    FreeMem(OldAnim, OldLengthTAnmPhase*OldAnim^.OHeader.ONumOfPhases +OldLengthTAnmHeader);
  end;

{  procedure ReadSeqNameFromStore(What: byte);
  begin
    CLoadItem(ANM_Name+'.AN4', pointer(Ptr_Name), What);
    Seq_Name:= Ptr_Name^;
    FreeMem(Ptr_Name, 13);
  end;
}
  procedure EraseReadedSequenceFromStore(What: byte);
  begin
    CEraseItem(ANM_Name+'.AN5', What);
  end;

  procedure WriteSequenceToStore;
  begin
    CAddFromMemory(ANM_Name+'.AN5', ConvAnim, LengthTAnmPhase*ConvAnim^.Header.NumOfPhases+LengthTAnmHeader);
  end;

{  procedure EraseReadedSeqNameFromStore(What: byte);
  begin
    CEraseItem(ANM_Name+'.AN4', What);
  end;
}
{  procedure WriteSeqNameToStore;
  begin
    CAddFromMemory(ANM_Name+'.AN4', @Seq_Name, 13);
  end;
}
  procedure AdjustSequences;
  var
    ActSequence: byte;
    f: byte;
  begin
    if GetArchiveOccupy(ANM_Name+'.AN5')< 2 then exit;
    for ActSequence:= 2 to GetArchiveOccupy(ANM_Name+'.AN5') do begin
      {ReadSeqNameFromStore(2);}
      ReadSequenceFromStore(2);
      {EraseReadedSeqNameFromStore(2);}
      EraseReadedSequenceFromStore(2);
      {WriteSeqNameToStore;}
      WriteSequenceToStore;
    end;
  end;

begin
  GetMem(ConvAnim, LengthTAnmHeader+LengthTAnmPhase*255);
  AdjustSequences;
  FreeMem(ConvAnim, LengthTAnmHeader+LengthTAnmPhase*255);
end;
(*
procedure ZkonvertujAnimaciDelayOK(Anm_Name: string);
var
  OldAnim: OldPAnimation;
  ConvAnim: PAnimation;
  i: byte;
  polozka: word;

  procedure ReadSequenceFromStore(What: byte);
  var
    f: byte;
  begin
    CLoadItem(ANM_Name+'.AN5', pointer(OldAnim), What );
    with ConvAnim^.Header do begin
      NumOfPhases:= OldAnim^.Header.NumOfPhases;
      MemoryLogic:= OldAnim^.Header.MemoryLogic;
      DisableErasing:= OldAnim^.Header.DisableErasing;
      Cyclic:= OldAnim^.Header.Cyclic;
      Relative:= OldAnim^.Header.Relative;
    end;
    for f:= 1 to ConvAnim^.Header.NumOfPhases do begin
      with ConvAnim^.Phase[f] do begin
        Picture      := OldAnim^.Phase[f].Picture;
        X            := OldAnim^.Phase[f].X;
        Y            := OldAnim^.Phase[f].Y;
        ZoomX        := OldAnim^.Phase[f].ZoomX;
        ZoomY        := OldAnim^.Phase[f].ZoomY;
        Mirror       := OldAnim^.Phase[f].Mirror;
        Sample       := OldAnim^.Phase[f].Sample;
        Frequency    := OldAnim^.Phase[f].Frequency;
        Delay        := (OldAnim^.Phase[f].Delay);
      end;
    end;
    FreeMem(OldAnim, OldLengthTAnmPhase*OldAnim^.Header.NumOfPhases +OldLengthTAnmHeader);
  end;

{  procedure ReadSeqNameFromStore(What: byte);
  begin
    CLoadItem(ANM_Name+'.AN4', pointer(Ptr_Name), What);
    Seq_Name:= Ptr_Name^;
    FreeMem(Ptr_Name, 13);
  end;
}
  procedure EraseReadedSequenceFromStore(What: byte);
  begin
    CEraseItem(ANM_Name+'.AN5', What);
  end;

{  procedure WriteSequenceToStore;
  begin
    CAddFromMemory(ANM_Name+'.AN5', ConvAnim, LengthTAnmPhase*ConvAnim^.Header.NumOfPhases+LengthTAnmHeader);
  end;
}
  procedure WriteSequenceToStore;
  begin
    CAddFromMemory(ANM_Name+'.AN5', ConvAnim, OldLengthTAnmPhase*ConvAnim^.Header.NumOfPhases+OldLengthTAnmHeader);
  end;

{  procedure EraseReadedSeqNameFromStore(What: byte);
  begin
    CEraseItem(ANM_Name+'.AN4', What);
  end;
}
{  procedure WriteSeqNameToStore;
  begin
    CAddFromMemory(ANM_Name+'.AN4', @Seq_Name, 13);
  end;
}
  procedure AdjustSequences;
  var
    ActSequence: byte;
    f: byte;
  begin
    if GetArchiveOccupy(ANM_Name+'.AN5')< 2 then exit;
    for ActSequence:= 2 to GetArchiveOccupy(ANM_Name+'.AN5') do begin
      {ReadSeqNameFromStore(2);}
      ReadSequenceFromStore(2);
      {EraseReadedSeqNameFromStore(2);}
      EraseReadedSequenceFromStore(2);
      {WriteSeqNameToStore;}
      WriteSequenceToStore;
    end;
  end;


begin
  GetMem(ConvAnim, LengthTAnmHeader+LengthTAnmPhase*256);
  AdjustSequences;
  FreeMem(ConvAnim, LengthTAnmHeader+LengthTAnmPhase*256);
end;

*)

begin
end.
