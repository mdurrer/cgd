Unit SBl_old;

INTERFACE

type ster=record
             l:0..15;
             r:0..15;
           end;
      TAudioControl=record
                     master:ster;
                     DSP:ster;
                     FM:ster;
                     CD:ster;
                     AUX:ster;
                     treble:ster;
                     bass:ster;
                     COVOX:0..15;
                     mic:0..7;
                     input:0..3;
                     ifb:0..11;
                     ofb:0..1;
                     stereo:0..1;
                     mix:0..1;
                   end;
 TInstrument = record
    SoundCharacteristic,
    Level,
    AttackDecay,
    SustainRelease,
    WaveSelect : array[0..1] of byte;
    Feedback : byte;
    filler : array[0..4] of byte;
  end;

var EndOfDMA:boolean;
    AudioCounter:longint;
    SpeechCounter:longint;
    UserInt:procedure;
    OldInt08 : pointer;
    SBType : word;
    DataBufferDMA : pointer;
    whatbufferdma : byte;
    fileofsample : file;

Const  BufferDMA    : word = 32000;
       RIGHT_FM_ADDRESS = $00;  {mozna naopak}
       LEFT_FM_ADDRESS  = $02;

       notes : array[1..12] of word =
       ($016B,$0181,$0198,$01B0,$01CA,$01E5,
        $0202,$0220,$0241,$0263,$0287,$02AE);

       BaseAddr     : Word = $220;
       VOICEVolume  : Byte = $04;
       MASTERVolume : Byte = $22;
       FMVolume     : Byte = $26;
       CDVolume     : Byte = $28;
       LINEVolume   : Byte = $2e;
       SBIRQ        : word = 5;
       SBDMA        : word = 1;


Function  ResetBlaster(TestAddr : Word) : Boolean;
function  ResetDSP:boolean;
Function  FindBlaster : Boolean;
Procedure UpdateBlasterMixer(MReg, Value : Byte);
Procedure SetMixerDefault;
Procedure WriteSb(Addr : Word; Value : Byte);
function  ReadDSP:byte;
Procedure WriteDSP(Value : Byte);
Function  ReadBlasterMixer(MReg : Byte) : Byte;

function  GetMemDMA(var p: pointer) : boolean;
procedure FreeMemDMA(var p: pointer);
procedure PlayDMAfromFile(size, samplereate : longint);
procedure StopDMA;

procedure VolumeDSP(volume : byte); {levy MOD / pravy DIV}
procedure SetAudioControl(x:TAudioControl);
procedure ReadAudioControl(var x:TAudioControl);
procedure SetSamplingRate(rate:word);
procedure SetHighSamplingRate(rate:word);
procedure playDMA(sound:pointer;start,size:word);
procedure playDMAHigh(sound:pointer;start,delka:word);
procedure speaker(f:boolean);
function  DMAposition:word;
procedure DMApause;
procedure DMAcont;
procedure StartAudioInt;
procedure StopAudioInt;

procedure WriteFM ( Chip , Addresse : word ; Data : byte );
procedure SbFMReset;
procedure SbFMSetStereo(ano: boolean);
procedure SbFMKeyOff(voice : integer);
procedure SbFMKeyOn(voice, freq, octave: integer);
procedure SbFMKeyOnMidi(voice : integer; freq : word);
procedure SetFMVoiceVolume(Voice, Volume: word );
procedure SbFMSetVoice(voice_num: integer; FM_Instrument: TInstrument; pan,volume : byte);


IMPLEMENTATION

uses dos;

type tbyte = array[0..65530] of byte;
     pbyte = ^tbyte;

Var OkReadDMA : word;
    SizeOfPlay : Longint;
    EndingDMA : boolean;
    DosFlagPtr : ^byte;
    OldHandle08event : procedure;
    ReadToBuffer,runmy08 : boolean;

{Vysledkem je, zda se reset DSP povedl nebo ne}
Function ResetBlaster; Assembler;
Asm
         mov     cx,TestAddr             {Udajna adresa BLAST.}
         mov     dx,cx
         add     dx,06h                  {Index RESET registru}
         mov     al,1
         out     dx,al                   {Vyslu byte 1}
         xor     al,al                   {Zdrzeni o delce}
@First:  nop                             {65536 cyklu, aby}
         dec     al                      {to BLASTER stihnul}
         jnz     @First                  {nastavit}
         out     dx,al                   {Vyslu mu 0}
         mov     ax,2000h                {Zdrzeni o delce}
@Second: nop                             {8192 cyklu}
         dec     ax
         jnz     @Second
         mov     dx,cx                   {Znovu nactu BaseAdr}
         add     dx,0eh                  {Index stav. registru}
         in      al,dx                   {Nactu jeho hodnotu}
         test    al,80h                  {Nastaven bit 7 ?}
         jz      @Failed                 {Ne, neni blaster}
         mov     dx,cx                   {Kdyz ano,}
         add     dx,0ah                  {udelam jeste}
         in      al,dx                   {dalsi overovaci}
         cmp     al,0AAh                 {zkousku, zda je}
         jne     @Failed                 {BLASTER pritomen}
         mov     ax,1                    {Vyroba TRUE}
         jmp     @Ready
@Failed: xor     ax,ax                   {Vyroba FALSE}
@Ready:                 {RETURN}
end;

function ResetDSP; assembler;
asm
       mov dx,BaseAddr
       add dx,6
       mov al,1
       out dx,al
       mov cx,20000
@opak: loop @opak
       mov al,0
       out dx,al
       mov cx,2000
@opak2: push cx
       mov cx,2000
       mov dx,BaseAddr
       add dx,$0e
@opak1: in al,dx
       and al,128
       loopz @opak1
       pop cx
       mov dx,BaseAddr
       add dx,$0a
       in al,dx
       cmp al,$aa
       loopnz @opak2
       cmp al,$aa
       jnz @neni
       mov al,1
       mov ax,0
       jmp @konec
@neni:  mov ax,0ffffh
@konec:
end;

Function FindBlaster;
{Sedm standartnich zakladnich portu, na kterych lze najit SOUND BLASTER}
{Jako prvni zacinam se standartnim portem}
Const BPorts : Array[1..8] of Word = ($220,$200,$210,$230,$240,$250,$260,$388);
  VarName = 'BLASTER';   { Name der zu suchenden Environmentvariablen }

var
  Params  : string;
  Result  : boolean;
  Wbc : Word;         {Word base counter}
  function GetParamValue(var ParamLine : string; ParamCode : char;
                         var Value : word; IsHex : boolean) : boolean;
  var
    p  : byte;
    ss : string[5];
    v  : word;
    e  : integer;
  begin
    p:=Pos(ParamCode,ParamLine);
    if p>0 then
    begin   { gewünschter Parameter gefunden }
      GetParamValue:=true;
      ss:=copy(ParamLine,p+1,5);   { Ziffernstring extrahieren }
      p:=Pos(#$20,ss);
      if p>0 then ss[0]:=chr(p-1);
      if IsHex then
      begin   { Parameter ist als Hexzahl aufzufassen }
        if length(ss)>0 then
        begin
          v:=0;
          e:=0;
          for p:=1 to length(ss) do
          begin
            v:=v shl 4;
            if (ss[p]>='0') and (ss[p]<='9') then v:=v+ord(ss[p])-48
            else
            if (ss[p]>='A') and (ss[p]<='F') then v:=v+ord(ss[p])-55
            else inc(e);
          end;
        end
        else GetParamValue:=false;
      end
      else val(ss,v,e);   { Parameter ist als Dezimalzahl aufzufassen }
      if e=0 then Value:=v
             else GetParamValue:=false;
    end
    else GetParamValue:=false;
  end { GetParamValue };


begin
  FindBlaster:=False;
  Params:=GetEnv(VarName);
  Result:=GetParamValue(Params,'A',BaseAddr,true);
  Result:=Result and GetParamValue(Params,'I',SbIRQ,false);
  Result:=Result and GetParamValue(Params,'D',SbDMA,false);
  Result:=Result and GetParamValue(Params,'T',SbType,false);
  if not Result then exit;
  For Wbc:=1 to 7 do                                    {Prohlidni 7 portu}
  If ResetBlaster(BPorts[Wbc]) then                     {Pokud BLASTER odpovi}
  begin
    BaseAddr:=BPorts[Wbc]; FindBlaster:=True; Exit;     {Nastavim BaseAddr}
  end;
end;

Procedure UpdateBlasterMixer; Assembler;
Asm
  mov     dx,BaseAddr             {Zakladni adresa}
  mov     al,MReg                 {Nastavim cislo}
  add     dx,04h                  {pozadovaneho registru}
  out     dx,al
  mov     al,Value                {Vyslu hodnotu do}
  inc     dx                      {BLASTERu}
  out     dx,al
end;

Procedure SetMixerDefault;
begin
  UpdateBlasterMixer($0,$0);
end;

Function ReadBlasterMixer; Assembler;
Asm
  mov     dx,BaseAddr             {Zakladni adresa}
  mov     al,MReg                 {Nastavim cislo}
  add     dx,04h                  {pozadovaneho registru}
  out     dx,al
  inc     dx                      {BLASTERu}
  in      al,dx                   {Prectu si to}
end;

{Univerzalni procedura na zapis do kterehokoliv mista BLASTRu}
Procedure WriteSb(Addr : Word; Value : Byte); Assembler;
Asm
  mov     dx,BaseAddr             {Zakladni adresa}
  mov     al,Value                {hodnota do AL,}
  add     dx,Addr                 {kterou vyslu do}
  out     dx,al                   {BLASTRu}
end;

{Specialni procedura na zapis instrukci pro DSP}
Procedure WriteDSP; Assembler;
Asm
  mov     dx,BaseAddr             {Zakladni adresa}
  add     dx,0Ch                  {Pridam k ni adr. DSP}
@Again: in      al,dx                   {Je DSP pripraven ?}
  and     al,80h
  jnz     @Again                  {Ne, cekej az bude}
  mov     al,Value                {Pak mu vysli}
  out     dx,al                   {instrukci}
end;

function ReadDSP:byte; assembler;
asm
  mov dx,BaseAddr
  add dx,0Ah
@opak: in al,dx
  and al,128
  jz @opak
  mov dx, BaseAddr
  add dx, 20h
  in al,dx
  mov ah,al
end;

function GetMemDMA(var p: pointer) : boolean;
var test : ^byte;
    so, oo, aa : LongInt;
    get : boolean;
begin
  getmemdma:=false;
  new(test);
  so:=seg(test^);
  oo:=ofs(test^);
  dispose(test);
  aa:=so*16+oo;
  so:=65535-aa mod 65536;
  if so<bufferDMA then begin
    if memavail<so+bufferdma then exit;
    getmem(test,so+1);
    get:=true;
  end else get:=false;
  if memavail<bufferdma then begin
    if get then freemem(test,so+1);
    exit;
  end;
  getmem(p,bufferdma);
  if get then freemem(test,so+1);
  getmemdma:=true;
end;

procedure FreeMemDMA(var p: pointer);
begin
  freemem(p,bufferdma);
end;

{$F+}
procedure Handle08Event; interrupt;
begin
{  write('Now!');}
  inline ($9C);
  oldhandle08event;
  asm cli end;
  if (dosflagptr^=0)and(readtobuffer)and(not runmy08) then begin
    runmy08:=true;
    readtobuffer:=false;
{    write('Yeeh');}
    if (sizeofplay<>0) then begin
      Blockread(fileofsample,pbyte(Databufferdma)^[WhatBufferDMA*bufferdma div 2],bufferdma div 2,OkreadDMA);
      if sizeofplay>=okreaddma then dec(SizeofPlay,okreaddma)
      else begin
        okreaddma:=sizeofplay;
        sizeofplay:=0;
      end;
    end else EndingDMA:=true;
    runmy08:=false;
  end;
  asm sti end;
end;

procedure HandleDMAEvent; interrupt;
begin
  asm cli end;
  if EndingDMA then begin
    runmy08:=false;
    ReadToBuffer:=false;
    DMApause;
    EndOfDMA:=true;
    EndingDMA:=true;
    speaker(false);
    StopAudioInt;
  end else begin
{    write(whatbufferdma,' ');}
    if okreaddma>5 then
      PlayDMA(Databufferdma,WhatBufferDMA*bufferdma div 2,okreaddma-5);
    WhatBufferdma:=1-WhatBufferdma;
    if (dosflagptr^=0) then
      if (sizeofplay<>0) then begin
        Blockread(fileofsample,pbyte(Databufferdma)^[WhatBufferDMA*bufferdma div 2],bufferdma div 2,OkreadDMA);
        if sizeofplay>=okreaddma then dec(SizeofPlay,okreaddma)
        else begin
          okreaddma:=sizeofplay;
          sizeofplay:=0;
       end;
      end else EndingDMA:=true
    else begin
      ReadToBuffer:=true;
{      write('Tet');}
    end;
    AudioCounter:=AudioCounter+1;
    SpeechCounter:=SpeechCounter+1;
  end;
  asm sti; end;
  port[$20]:=$20;
  port[$A0]:=$20;
end;
{$F-}

procedure PlayDMAfromFile(size, samplereate : longint);
begin
  if not endofdma then StopDMA;
  speaker(true);
  EndingDMA:=false;
  runmy08:=false;
  SizeOfPlay:=size;
  WhatBufferdma:=1;
  EndOfDMA:=false;
  SetSamplingRate(samplereate);
  @UserInt:=@HandleDMAEvent;
  SpeechCounter:=0;
  StartAudioInt;
  blockread(fileofsample,databufferdma^,bufferdma div 2, okreaddma);
  if sizeofplay>=okreaddma then dec(SizeofPlay,okreaddma)
  else begin
    okreaddma:=sizeofplay;
    sizeofplay:=0;
    Endingdma:=true;
  end;
  if okreaddma=0 then begin
    runmy08:=false;
    ReadToBuffer:=false;
    EndOfDMA:=true;
    EndingDMA:=true;
    DMApause;
    speaker(false);
    StopAudioInt;
  end else playDMA(databufferdma,0,okreaddma-5);
  blockread(fileofsample,pbyte(databufferdma)^[bufferdma div 2],bufferdma div 2, okreaddma);
  if sizeofplay>=okreaddma then dec(SizeofPlay,okreaddma)
  else begin
    okreaddma:=sizeofplay;
    sizeofplay:=0;
  end;
end;

procedure StopDMA;
begin
  if endofdma then exit;
  runmy08:=false;
  ReadToBuffer:=false;
  DMApause;
  EndOfDMA:=true;
  EndingDMA:=true;
  speaker(false);
  if EndOfDMA then StopAudioInt;
end;

procedure VolumeDSP(volume : byte); assembler;{levy MOD / pravy DIV}
asm
  mov dx,baseaddr
  add dx,4
  mov al,4
  out dx,al
  inc dx
  mov al,volume
  out dx,al
end;

procedure SetAudioControl(x:TAudioControl);
 procedure wr(reg,data:byte);
 var regadr:word;
 begin
  regadr:=Baseaddr+$04;
  asm
    mov dx,regadr
    mov al,reg
    out dx,al
    inc dx
    mov al,data
    out dx,al
  end;
 end;
begin
 with x do begin
  wr($04,dsp.l*16+dsp.r);
  wr($22,master.l*16+master.r);
  wr($26,fm.l*16+fm.r);
  wr($28,cd.l*16+cd.r);
  wr($2e,aux.l*16+aux.r);
  wr($44,treble.l*16+treble.r);
  wr($46,bass.l*16+bass.r);
  wr($0a,mic);
  wr($0c,32*ifb+2*input);
  wr($0e,32*ofb+2*stereo);
  wr($42,covox);
  wr($48,16*mix);
 end;
end;

procedure ReadAudioControl(var x:TAudioControl);
var i:byte;
 function r(reg:byte):byte;
 var regadr:word;
     value:byte;
 begin
  regadr:=BaseAddr+$04;
  asm
    mov dx,regadr
    mov al,reg
    out dx,al
    inc dx
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    in al,dx
    mov value,al
  end;
  r:=value;
 end;

begin
 with x do begin
  i:=r($04);
  dsp.l:=i div 16;dsp.r:=i mod 16;
  i:=r($22);
  master.l:=i div 16;master.r:=i mod 16;
  i:=r($26);
  fm.l:=i div 16;fm.r:=i mod 16;
  i:=r($28);
  cd.l:=i div 16;cd.r:=i mod 16;
  i:=r($2e);
  aux.l:=i div 16;aux.r:=i mod 16;
  i:=r($44);
  treble.l:=i div 16;treble.r:=i mod 16;
  i:=r($46);
  bass.l:=i div 16;bass.r:=i mod 16;
{  mic:=r($0a);
  i:=r($0c);
  ifb:=i div 32;input:=(i mod 32) div 2;
  i:=r($0e);
  ofb:=i div 32;stereo:=(i mod 32) div 2;}
  covox:=r($42);
  mix:=r($48) div 16;
 end;
end;

procedure SetSamplingRate(rate:word);
begin
  writedsp($40);
  writedsp(256-1000000 div rate);
end;

procedure SetHighSamplingRate(rate:word);
var time:word;
begin
  time:=(65535-256000000 div rate);
  writedsp($40);
  writedsp(hi(time));
end;


procedure playDMA(sound:pointer;start,size:word);
var page, offset, x : word;
begin
  size := size - 1;
  { Set up the DMA chip }
  offset := Seg(sound^) Shl 4 + Ofs(sound^)+start;
  page := (Seg(sound^) + (Ofs(sound^)+start) shr 4) shr 12;
  Port[$0A] := 04+SbDMA;
  Port[$0C] := 00;
  Port[$0B] := $48+SbDMA;
  Port[SbDMA shl 1] := Lo(offset);
  Port[SbDMA shl 1] := Hi(offset);
  Port[(SbDMA shl 1)+1] := Lo(size);
  Port[(SbDMA shl 1)+1] := Hi(size);
  case SbDMA of
    0 : x:=$81;
    1 : x:=$83;
    2 : x:=$81;
    3 : x:=$82;
  end;
  Port[x]:=Page;
  Port[$0A]:=SbDMA;
  Port[$08]:=$10;
  { Set the playback type (8-bit) }
  WriteDSP($14);
  WriteDSP(Lo(size));
  WriteDSP(Hi(size));
end;

procedure playDMAHigh(sound:pointer;start,delka:word);
var absadr:longint;
    bit1619:byte;
    bit0015:word;
    ss,so:longint;
    x:word;
begin
  ss:=seg(sound^);
  so:=ofs(sound^);
  absadr:=ss*16+so+start;
  bit1619:=absadr div 65536;
  bit0015:=absadr mod 65536;
  Port[$0A]:=$04+SbDMA;
  case SbDMA of
    0 : x:=$87;
    1 : x:=$83;
    2 : x:=$81;
    3 : x:=$82;
  end;
  asm
{}  mov dx,x
    mov al,bit1619
    out dx,al            {bity 16-19 do DMA 1}
{}  mov dx,$0c
    xor al,al
    out dx,al            {reset flip-flop pro zápis adresy}
{}  mov dx,2
    mov ax,bit0015
    out dx,al
    mov al,ah
    out dx,al            {zápis adresy}
{}  inc dx
    mov ax,delka
    out dx,al
    mov al,ah
    out dx,al            {zápis délky}
{}  mov dx,$0b
    mov al,1+8+64        {pro DMA 1: čtení, jednoduchý režim}
    out dx,al            {zápis módu}
{}  dec dx
    mov al,1
    out dx,al            {povolit DMA 1}
  end;
  {pro sampl.frek. 22050-44100 (resp. 11025-22050 stereo)}
  x:=port[BaseAddr+$0e];
  writedsp($48);
  writedsp(delka mod 256);
  writedsp(delka div 256);
  writedsp($91);
end;


procedure speaker(f:boolean);
begin
  if f then writedsp($d1) else writedsp($d3);
end;

procedure DMApause;
begin
  writedsp($d0);
end;

procedure DMAcont;
begin
  writedsp($d4);
end;

function DMAposition:word; assembler;
asm
  mov dx,$0c
  xor al,al
  out dx,al         {reset flip-flop}
  mov dx,3
  in al,dx
  mov bl,al
  in al,dx
  mov ah,al
  mov al,bl
end;

{$F+}
procedure DefaultInt; interrupt;
begin
  EndOfDMA:=true;
  SpeechCounter:=SpeechCounter+1;
  port[$20]:=$20;
end;
{$F-}

procedure StartAudioInt;
begin
  ReadToBuffer:=false;
  GetIntVec(SBIRQ+$08,OldInt08);
  SetIntVec(SBIRQ+$08,@UserInt);
  getintvec(08,@OldHandle08event);
  setintvec(08,@Handle08Event);
  Port[$21]:=port[$21] and not (1 shl SBIRQ);
end;

procedure StopAudioInt;
begin
  AudioCounter:=0;
  SpeechCounter:=0;
  ReadToBuffer:=false;
  SetIntVec(08,@OldHandle08event);
  SetIntVec(SBIRQ+$08,OldInt08);
  Port[$21]:=port[$21] or (1 shl SBIRQ);
end;

{procedure WriteFm(chip,addr : integer; data : byte);
var ChipAddr : integer;
    b : byte;
begin
  if chip=0
    then ChipAddr:=BaseAddr+RIGHT_FM_ADDRESS
    else ChipAddr:=BaseAddr+LEFT_FM_ADDRESS;
  Port[ChipAddr]:=addr;
  b:=Port[ChipAddr];

  Port[ChipAddr+1]:=data;
  b:=Port[ChipAddr];
  b:=Port[ChipAddr];
  b:=Port[ChipAddr];
  b:=Port[ChipAddr];
end;}
procedure WriteFM ( Chip , Addresse : word ; Data : byte ); assembler;
asm
  MOV  DX,baseaddr
  MOV  AX,CHIP
  OR   AX,AX
  JNZ  @NOZERO
  ADD  DX,RIGHT_FM_ADDRESS
  JMP  @ZERO
@NOZERO:
  ADD  DX,LEFT_FM_ADDRESS
@ZERO:
  MOV  AX,ADDRESSE
  OUT  DX,AL
  IN   AL,DX
  INC  DX
  MOV  AL,DATA
  OUT  DX,AL
  DEC  DX
  IN   AL,DX
  IN   AL,DX
  IN   AL,DX
  IN   AL,DX
end;


procedure SbFMReset;
var i : byte;
begin
  WriteFM(0,1,0); {Reset pravych kanalu}
  WriteFM(1,1,0); {Reset levych kanalu}
  for i:=0 to 15 do begin
    writefm(0,$a0+i,0);
    writefm(0,$b0+i,0);
    writefm(1,$a0+i,0);
    writefm(1,$b0+i,0);
  end;
end;

procedure SbFMSetStereo(ano: boolean);
begin
  if ano then WriteFM(1, 5, 1) else WriteFM(1, 5, 0) {mozna spatne}
end;

procedure SbFMKeyOff(voice : integer);
var reg_num, chip : integer;
begin
  chip:= voice div 11;
  reg_num:=$B0 + voice mod 11; {%}
  WriteFM(chip, reg_num, 0);
end;

procedure SbFMKeyOnMidi(voice : integer; freq : word);
var reg_num, chip : integer;
begin
  chip:= voice div 11;
  reg_num:=$A0+voice mod 11;
  WriteFM(chip, reg_num, lo(freq));

  reg_num:= $B0+voice mod 11;
  WriteFM(chip, reg_num, hi(freq)+32);
end;

procedure SbFMKeyOn(voice, freq, octave : integer);
var reg_num, tmp, chip : integer;
begin
  chip:= voice div 11;
  reg_num:=$A0+voice mod 11;   {%}
  WriteFM(chip, reg_num, lo(freq));

  reg_num:= $B0+voice mod 11;
  tmp:=(freq shr 8) or (octave shl 2) or $20;
  WriteFM(chip, reg_num, byte(tmp));
end;

procedure SetFMVoiceVolume(Voice, Volume : word);
var Op_Cell_Num : byte;
    Cell_Offset , Chip : word;
begin
  Chip:= Voice div 11;
  Voice:= Voice mod 11;
  Cell_Offset:= Voice mod 3+((Voice div 3)shl 3);
  Op_Cell_Num:= $43+byte(Cell_Offset);
  WriteFM(Chip, Op_Cell_Num, Volume);
end;

procedure SbFMSetVoice(voice_num : integer; FM_Instrument : TInstrument;pan,volume : byte);
var cell_offset, i, chip : integer;
    op_cell_num : byte;
begin
  chip:= voice_num div 11;
  i   := voice_num div 11;
  voice_num:=voice_num mod 11;

  cell_offset:= voice_num mod 3 + ((voice_num div 3) shl 3);

op_cell_num:= $C0+voice_num;
  FM_Instrument.Feedback := FM_Instrument.Feedback and 15 + 4 shl 4;
  WriteFM(chip, op_cell_num, FM_Instrument.Feedback);

  op_cell_num:= $20 + cell_offset; {nastav zvukovou charakteristiku}
  WriteFM(chip, op_cell_num, FM_Instrument.SoundCharacteristic[0]);
  op_cell_num:=op_cell_num+3;
  WriteFM(chip, op_cell_num, FM_Instrument.SoundCharacteristic[1]);
  {nastav uroven vystupu}
  op_cell_num:= $40+cell_offset;
  WriteFM(chip, op_cell_num, FM_Instrument.Level[0]);
  op_cell_num:=op_cell_num+3;
  WriteFM(chip, op_cell_num, FM_Instrument.Level[1] and $F0 or volume);
  {nastav Attac/Decay}
  op_cell_num:= $60+cell_offset;
  WriteFM(chip, op_cell_num, FM_Instrument.AttackDecay[0]);
  op_cell_num:=op_cell_num+3;
  WriteFM(chip, op_cell_num, FM_Instrument.AttackDecay[1]);
  {nastav Sustain/Release}
  op_cell_num:= $80+cell_offset;
  WriteFM(chip, op_cell_num, FM_Instrument.SustainRelease[0]);
  op_cell_num:=op_cell_num+3;
  WriteFM(chip, op_cell_num, FM_Instrument.SustainRelease[1]);
  {nastav vlnitelny faktor}
  op_cell_num:= $E0+cell_offset;
  WriteFM(chip, op_cell_num, FM_Instrument.WaveSelect[0]);
  op_cell_num:=op_cell_num+3;
  WriteFM(chip, op_cell_num, FM_Instrument.WaveSelect[1]);
  {nastav }
  op_cell_num:= $C0+voice_num;
  FM_Instrument.Feedback := FM_Instrument.Feedback and 15 + Pan shl 4;
  WriteFM(chip, op_cell_num, FM_Instrument.Feedback);
end;

var rg : registers;
begin
  Rg.ah := $34;
  MsDos(Rg);
  DosFlagPtr := Ptr(Rg.es, Rg.bx);
  ReadToBuffer:=false;
  runmy08:=false;
  @UserInt:=@DefaultInt;
  SpeechCounter:=0;
  EndOfDMA:=true;
end.
