{$A+,B-,D+,E+,F-,G+,I+,L+,N-,O-,P-,Q+,R-,S+,T-,V+,X+,Y+}
{$M 16384,0,655360}
unit soundpas;

interface

{$L sound_p.obj}

type

{ typ vycet pro nastaveni vystupniho zarizeni pro zvuky }
{ (pouze pro kraaaaasu....)                             }
 TOutDevice= (None, Speaker, DA, Blaster );

{ ruzne inicializacni hodnoty pro osmicku, prehravac samplu }
{ i prehravac hudby }
{ Kde neni, viz komentar v  *.asm  casti..., to plati i pro _chanels & spol. }
 TTime08= record
        TimerCitac: word;         {Neustale se zmensuje az do 1/100 sekundy}
        TimerCitacPocatecni: word;{Pocatecni nastaveni citace casu}
        TimerWord1   : word;  {Pocitadla casu v 1/100 sec.}
        TimerWord2   : word;
        TimerDW      : longint;
 end;

 TInitvalues=  record
        Speed08  : byte;  {Rychlost osmicky (delitel frekvence) }

{Pouze pro ladici ucely}
{        AlreadyIn: byte;}
{        PocitPodLo:word;
        PocitPodHi:word;
        PodTimLo : word;
        PodTimHi : word;
        ZdrzeniHi: word;
        ZdrzeniLo: word;
        AktPattern: byte;
}
{ -------------------- }

        OutDevice: byte;
        HowMuchCh: byte;
        LPT_Port  : word;
        BlasterPort:word;
        OldOfs08, OldSeg08 : word;

        Tempo:      word;{delitel frekvence osmicky, aby bylo dosazeno}
                         {pozadovaneho tempa v BPM}
        TempoCitac: word;{pokazde, kdyz se dopocita do nuly, prejde se}
                         {na dalsi notu a prenese se do nej znovu hodnota "Tempo"}

        ShallPlay: byte;  {pokud je zde nula, hudba je vypnuta}

        NotesInPattern:byte; {pocet not v patternu}
        {NumOfPatterns: byte; pocet patternu}
        AddrTabPatSeg: word; {segment adresy tabulky adres patternu}
        AddrTabPatOfs: word; {offset adresy tabulky adres patternu}

        PatternsSeg: word;   {segment adresy zacatku oblasti patternu}
        PatternsOfs: word;   {offset adresy zacatku oblasti patternu}
        AddrActPattern:  word; {relativni adresa v aktualnim patternu}

        RepeatItem: byte; {cislo polozky-1, od ktere se ma cela skladba opakovat}
        ActualOrderItem: byte; {aktualni plozka v tab. poradi hrani patternu}
        NumOfItemsOrder: byte; {pocet polozek v tabulce poradi hrani patternu}
        AddrTabOrderSeg: word; {segment adresy tabulky poradi hrani patternu}
        AddrTabOrderOfs: word; {offset adresy tabulky poradi hrani patternu}

        {tabulka pro hodnoty Krok a OvrLd}
        TabulkaTonu:  array[1..24*8]of byte;

end;  {of _initvalues}

 TOneChannel=  record
    ChSeg, ChOfs, SizeCh : word;
    ChVolume : byte;
    ChLoop, ChLenLp: word;

{               IndexTonu: byte;}
    Krok: word;
    OvrLd, OvrLd2 : byte;
    ChActPos: word;
    ChLooped: byte;
 end; {of TOneChannel}

 TChannels=  record
        i:array[0..4] of TOneChannel;
 end; {of TChannels}

 TSamples=  record
        i:array[1..15] of record
               SmpSeg, SmpOfs, SizeSmp : word;
               Volume : byte;
               SmpLoop, LengthLoop : word;
        end;
end; {of _samples}

var
    Time08: ^TTime08;
    Sound_InitValues: ^TInitvalues;
    Sound_Channels:   ^TChannels;
    Sound_Samples:    ^TSamples;
{ Ani za boha mi sem neslo dat, aby externi procedury byly soucasti }
{ interface, takze proto typ  "procedure", kteremu priradim skutecne}
{ externi procedury }
    SoundInitPlay: procedure;
    SoundDonePlay: procedure;

{ Nastaveni vystupniho zarizeni }
procedure SoundSetOutDevice(Device: TOutDevice );
{ Nahrani hudby }
procedure LoadMusic(MusicName: string);
{ Uvolneni hudby z pameti }
procedure ReleaseMusic;
{ Odstartovani hrani hudby od zacatku }
procedure StartMusic(BPM: word);
{ Zastaveni hudby }
procedure StopMusic;
{ Nastaveni rychlosti osmicky na prislusnou frekvenci}
procedure SetFrequency(Freq: real);


implementation

type
{ "pattern" je cast skladby (poucka z odborneho nazvoslovi). }
{ Je takhle definovany kvuli proceduram LoadMusic a ReleaseMusic, }
{ hraci program zajima pouze adresa...                            }
 TPatterns= array[0..1]of byte;
 PPatterns= ^TPatterns;

var
    Patterns: PPatterns;
    PocetPatternu: byte;
    SouborHodnot: file;

const
    NazevSouboruHod = 'e:\tp7\sound\hodnotyt.onu';  {Nazev souboru s hodnotami Krok a OvrLd }
                                       { pro jednotlive tony}

procedure InitPlay; far; external;
procedure DonePlay; far; external;
procedure TimerCitac;  far; external;
procedure Speed08;  far; external;
procedure Channels; far; external;
procedure Samples;  far; external;


(*

procedure SaveMusic;
var
MusicFile: file;
Position: longint;
CisloSamplu: byte;
PomocnyUkazatel: pointer;
const
NameOfFile: string[12]= 'zkusebni.mus';
ProvizorniNazevSamplu: string[12]= 'provizor.xxx';
PocetPatternu: byte= 2;
begin
Assign(MusicFile, NameOfFile);
Rewrite(MusicFile,1);

BlockWrite(MusicFile, NameOfFile[1], 12);
BlockWrite(MusicFile, s^.i[1], 15*11);

for CisloSamplu:= 1 to 15 do if s^.i[CisloSamplu].SmpSeg<>0 then begin
   Position:= FilePos(MusicFile);
   BlockWrite(MusicFile, ProvizorniNazevSamplu[1], 12);
   PomocnyUkazatel:=Ptr(s^.i[CisloSamplu].SmpSeg,s^.i[CisloSamplu].SmpOfs);
   BlockWrite(MusicFile, PomocnyUkazatel^, s^.i[CisloSamplu].SizeSmp);
   Seek(MusicFile, 1+CisloSamplu*11);
   BlockWrite(MusicFile, Position, 4);
   Seek(MusicFile, Position+s^.i[CisloSamplu].SizeSmp+12);
end;

BlockWrite(MusicFile, PocetPatternu, 1);
PomocnyUkazatel:=Ptr(i^.AddrTabPatSeg, i^.AddrTabPatOfs);
BlockWrite(MusicFile, PomocnyUkazatel^, PocetPatternu*2);
BlockWrite(MusicFile, pattern0[0], 362);

BlockWrite(MusicFile, i^.NumOfItemsOrder, 1);
PomocnyUkazatel:=Ptr(i^.AddrTabOrderSeg, i^.AddrTabOrderOfs);
BlockWrite(MusicFile, PomocnyUkazatel^, i^.NumOfItemsOrder+1);
BlockWrite(MusicFile, i^.RepeatItem, 1);

end;

*)

procedure SoundSetOutDevice(Device: TOutDevice );
const
  BlasterPorts :array[0..6]of word= ($200, $210, $220, $230, $240, $250, $260);
var
  f: byte;

  function TestPort(port: word): word;
  var
    vysledek: word;
  begin
    asm
      mov word ptr vysledek,0
      mov dx,port
      add dx,06h
      mov al,1
      out dx,al
      mov cx,100d
    @waitanswer:
      loop @waitanswer

      mov al,0
      out dx,al
      add dx,6
      mov cx,65535d
    @wait2:
      in al,dx
      rcl al,1
      jnc @blasteranswered
      loop @wait2
      jmp @errorblaster
    @blasteranswered:
      pop cx
      mov al,0d1h
      out dx,al
    @wait3:
      in al,dx
      rcl al,1
      jc @wait3
      sub dx,0ch
      mov word ptr vysledek,dx
    @errorblaster:
    end;
    TestPort:= vysledek;
  end;

begin
  Sound_InitValues^.OutDevice:=Ord(Device);
  if Device= Blaster then begin
    f:= 0;
    while(TestPort(BlasterPorts[f])<>BlasterPorts[f])and(f<7) do Inc(f);
    if f=7 then Sound_InitValues^.OutDevice:=Ord(None)
    else Sound_InitValues^.BlasterPort:=BlasterPorts[f];
  end;
end;

procedure LoadMusic(MusicName: string);
var
MusicFile: file;
Position: longint;
CisloPatternu, CisloSamplu: byte;
PomocnyUkazatel: pointer;
DelkaPatternu: byte;
DelkaPatCelkem: word;
begin
Assign(MusicFile, MusicName);
Reset(MusicFile,1);

{ Na zacatku *.mus fajlu je ulozeno jmeno tohoto souboru, sam uz }
{ vlastne nevim, proc... tak ho preskocim }
Seek(MusicFile, 12);
{ Nactu tabulku samplu }
BlockRead(MusicFile, Sound_Samples^.i[1], 15*11);

for CisloSamplu:= 1 to 15 do if Sound_Samples^.i[CisloSamplu].SizeSmp<>0 then begin
{ V SmpSeg a SmpOfs je prozatim ulozena relativni adresa ulozeni samplu }
{ od zacatku souboru *.mus. Pokud je nulova, sampl neni pouzit, pokud tam }
{ nejaka adresa je uvedena, vyhleda si zacatek samplu (- to vlastne nemusi,}
{ protoze samply jsou ulozeny kontinualne, pozn.) a preskoci prvnich }
{ 12 byte, kde je ulozen nazev samplu }
   Seek(MusicFile, FilePos(MusicFile)+12);
{ Vyhradi pro sampl misto v pameti }
   GetMem(PomocnyUkazatel, Sound_Samples^.i[CisloSamplu].SizeSmp);
{ A nacte ho do pameti }
   BlockRead(MusicFile, PomocnyUkazatel^, Sound_Samples^.i[CisloSamplu].SizeSmp);
{ Ted uz do tabulky samplu muzeme ulozit skutecnou adresu samplu }
{ v pameti, na kterou byl nacteny }
   Sound_Samples^.i[CisloSamplu].SmpSeg:= Seg(PomocnyUkazatel^);
   Sound_Samples^.i[CisloSamplu].SmpOfs:= Ofs(PomocnyUkazatel^);
end;

{ Nactu pocet patternu, abych vedel, kolik mista mam vyhradit pro }
{ tabulku adres patternu }
BlockRead(MusicFile, PocetPatternu, 1);
GetMem(PomocnyUkazatel, PocetPatternu*2);
{ Nactu tabulku adres patternu, jedna se o relativni adresy, ktere }
{ se pri hrani prictou k adrese zacatku oblasti ulozeni patternu }
BlockRead(MusicFile, PomocnyUkazatel^, PocetPatternu*2);
Sound_InitValues^.AddrTabPatSeg:= Seg(PomocnyUkazatel^);
Sound_InitValues^.AddrTabPatOfs:= Ofs(PomocnyUkazatel^);

{ Tady se ukladaji do pameti vsechny patterny... }
{ Protoze muzou mit variabilni delku, musim nejdriv zjistit, jak }
{ je cela oblast ulozeni patternu vlastne dlouha }
Position:= FilePos(MusicFile);
DelkaPatCelkem:=PocetPatternu;    {Pocet patternu*1= 1 byte pocet not na zac. kazdeho patternu}
for CisloPatternu:= 1 to PocetPatternu do begin
  BlockRead(MusicFile, DelkaPatternu, 1);
  DelkaPatCelkem:=DelkaPatCelkem+(DelkaPatternu* 16);
  Seek(MusicFile, FilePos(MusicFile)+DelkaPatternu* 16);
end;
{ A tady se uz skutecne nactou }
Seek(MusicFile, Position);
GetMem(Patterns, DelkaPatCelkem);
BlockRead(MusicFile, Patterns^[0], DelkaPatCelkem);
Sound_InitValues^.PatternsSeg:= Seg(Patterns^[0]);
Sound_InitValues^.PatternsOfs:= Ofs(Patterns^[0]);

{ Jeste vyridit nalezitosti kolem tabulky poradi hrani patternu... }
BlockRead(MusicFile, Sound_InitValues^.NumOfItemsOrder, 1);
GetMem(PomocnyUkazatel, Sound_InitValues^.NumOfItemsOrder+1);
Sound_InitValues^.AddrTabOrderSeg:= Seg(PomocnyUkazatel^);
Sound_InitValues^.AddrTabOrderOfs:= Ofs(PomocnyUkazatel^);
BlockRead(MusicFile, PomocnyUkazatel^, Sound_InitValues^.NumOfItemsOrder+1);
{ A uplne na konci souboru je ulozen byte, ve kterem je cislo }
{ polozky v tabulce hrani patternu, od ktere se ma skladba opakovat }
BlockRead(MusicFile, Sound_InitValues^.RepeatItem, 1);

Close(MusicFile);

end;


procedure ReleaseMusic;
var
CisloPatternu, CisloSamplu: byte;
PomocnyUkazatel: pointer;
DelkaPatCelkem: word;
begin

for CisloSamplu:= 1 to 15 do if Sound_Samples^.i[CisloSamplu].SmpSeg<>0 then begin
   PomocnyUkazatel:=Ptr(Sound_Samples^.i[CisloSamplu].SmpSeg,Sound_Samples^.i[CisloSamplu].SmpOfs);
   FreeMem(PomocnyUkazatel, Sound_Samples^.i[CisloSamplu].SizeSmp);
end;

PomocnyUkazatel:=Ptr(Sound_InitValues^.AddrTabPatSeg, Sound_InitValues^.AddrTabPatOfs);
FreeMem(PomocnyUkazatel, PocetPatternu*2);

DelkaPatCelkem:=0;
for CisloPatternu:= 1 to PocetPatternu do begin
  DelkaPatCelkem:=DelkaPatCelkem+(Patterns^[DelkaPatCelkem]*16)+1;
end;
FreeMem(Patterns, DelkaPatCelkem);

PomocnyUkazatel:=Ptr(Sound_InitValues^.AddrTabOrderSeg, Sound_InitValues^.AddrTabOrderOfs);
FreeMem(PomocnyUkazatel, Sound_InitValues^.NumOfItemsOrder+1);

end;

procedure StartMusic(BPM: word);
begin
{ Nastavi pozici na zacatek cele hudby }
  Sound_InitValues^.ActualOrderItem:= 255;
  Sound_InitValues^.NotesInPattern:=0;
{ Pri f.osmicky 15909.09 se nastavi tempo 550 BPM (zakl. tempo v ModEditu) }
  Sound_InitValues^.Tempo:=( (1193182 div Sound_InitValues^.Speed08)*60)div BPM;
{ Aby se to hned napoprve snizilo na nulu a zaclo hrat, da to tam 1 }
  Sound_InitValues^.TempoCitac:=1;
{...a povoli hrani }
  Sound_InitValues^.ShallPlay:=1;
end;

procedure StopMusic;
begin
{ Zakaze hrani hudby }
  Sound_InitValues^.ShallPlay:=0;
{ A zaroven "vycisti" kanaly, ve kterych se hudba hrala. }
{ Kdyby se kanaly nevycistily, hudba by postupne doznivala, }
{ tak, jak by jednotlive samply koncily }
  Sound_Channels^.i[1].ChSeg:=0;
  Sound_Channels^.i[2].ChSeg:=0;
  Sound_Channels^.i[3].ChSeg:=0;
  Sound_Channels^.i[4].ChSeg:=0;
end;

procedure SetFrequency(Freq: real);
begin
  Sound_InitValues^.Speed08:= byte(round(1193182 / Freq));
  Time08^.TimerCitacPocatecni:= word(round(Freq /100));
  Time08^.TimerCitac:= 1;

end;


begin
{ Nastavim vsechny zakladni dulezite adresy }
  Sound_InitValues:=@Speed08;
  Sound_Channels:=@Channels;
  Sound_Samples:= @Samples;
  Time08:= @TimerCitac;

{ Nejak mi to neslo udelat jinak, nez takhle, pres promenou typu "procedure" }
  SoundInitPlay:= InitPlay;
  SoundDonePlay:= DonePlay;

{ Nastavim rychlost osmicky na 15909.09 Hz }
  Sound_InitValues^.Speed08:=255;{75;}

{ dam standardni pocet kanalu, 4 }
  Sound_InitValues^.HowMuchCh:=5;

{ pro zacatek zakaze hrani, to je radno povolit az pote, co je }
{ hudba v pameti, ...a radeji ji spoustet pres StartMusic (kdyz uz jsem to napsal...) }
  Sound_InitValues^.ShallPlay:=0;

(*
{ Nactu hodnoty Krok a OvrLd pro vsechny tony }
  Assign(SouborHodnot, NazevSouboruHod);
  Reset(SouborHodnot, 1);
  BlockRead(SouborHodnot, Sound_InitValues^.TabulkaTonu, 216);
  Close(SouborHodnot);
*)

end.