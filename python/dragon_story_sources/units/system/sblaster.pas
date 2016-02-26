Unit SBlaster;

INTERFACE

type
 TInstrument = record
    SoundCharacteristic,
    Level,
    AttackDecay,
    SustainRelease,
    WaveSelect : array[0..1] of byte;
    Feedback : byte;
    filler : array[0..4] of byte;
  end;

var   SbNo : byte;
      olddmairq : pointer;
      SampleType : byte;

Const  RIGHT_FM_ADDRESS = $00;
       LEFT_FM_ADDRESS  = $02;
       BufferDMA = 16000;
       BaseAddr     : Word = $220;
       SBIRQ        : word = 5;
       SBDMA        : word = 1;


Function  ResetBlaster(TestAddr : Word) : Boolean;
function  ResetDSP:boolean;
Function  FindBlaster : Boolean;
Procedure WriteSb(Addr : Word; Value : Byte);
function  ReadDSP:byte;
Procedure WriteDSP(ii : Byte);
procedure wr_mixerreg(reg,wert:byte);
function  rd_mixerreg(reg:byte):byte;

function  GetMemDMA(var p: pointer) : boolean;
procedure FreeMemDMA(var p: pointer);

procedure SetVolume(vol:byte);
procedure VolumeDSP(vol:byte);
procedure SetSamplingRate(rate:word);
procedure SetHighSamplingRate(rate:word);

procedure InitDMAirq(p : pointer);
procedure PlayDMAfile(size : longint; samplereate : word;from_dubbing_file : boolean);
procedure autoinitdmairq;
procedure doneDMAirq;
procedure playDMA(sound:pointer;start,size:word);

procedure speaker(f:boolean);
function  DMAposition:word;
procedure PauseDMA;
procedure ContinueDMA;
procedure StopDMA;

procedure WriteFM ( Chip , Addresse : word ; Data : byte );
procedure SbFMReset;
procedure SbFMSetStereo(ano: boolean);
procedure SbFMKeyOff(voice : integer);
procedure SbFMKeyOn(voice, freq, octave: integer);
procedure SbFMKeyOnMidi(voice : integer; freq : word);
procedure SetFMVoiceVolume(Voice, Volume: word );
procedure SbFMSetVoice(voice_num: integer; FM_Instrument: TInstrument; pan,volume : byte);

var  Samplefile : file;
     DMABuffer  : pointer;

IMPLEMENTATION

uses dos,crt;

type tbyte = array[0..65530] of byte;
     pbyte = ^tbyte;

Var   DosFlagPtr : ^byte;
      resttoplay : longint;
      loadedtoplay : word;
      Endingplay : boolean;
      KteryBufr : byte;
      oldevent08 : procedure;
      int08event : boolean;


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

function ResetDSP:boolean; assembler;
asm
      mov        bl,1
      mov        dx,baseaddr
      add        dx,6
      mov        al,1         { write 1 to port 2x6 }
      out        dx,al
 mov cx, 0ffffh
 @111:
      in         al,dx
 loop @111
      in         al,dx
      xor        al,al
      out        dx,al        { after 3,3 μs write 0 to port 2x6 }

{ And now check the answer }
      add        dx,8
      mov        si,200
@@readloop:
      mov        cx,0ffffh      { SB2.0/1.0 are that slow :( }
@@testl:                          { check for data available }
      in         al,dx
      dec        cx
      jz         @@not
      or         al,al
      jns        @@testl

      sub        dx,4
      in         al,dx        { read data comming through }
      cmp        al,0aah
      je         @@aSB
      add        dx,4
      dec        si
      jnz        @@readloop
@@not:  mov        bl,0         { it's not a SB :( }
@@aSB:  xor        ah,ah
      mov        al,bl
end;

Function FindBlaster;
Const BPorts : Array[1..8] of Word = ($220,$200,$210,$230,$240,$250,$260,$388);
  VarName = 'BLASTER';

var
  Params  : string;
  Result  : boolean;
  Wbc : Word;
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
    begin
      GetParamValue:=true;
      ss:=copy(ParamLine,p+1,5);
      p:=Pos(#$20,ss);
      if p>0 then ss[0]:=chr(p-1);
      if IsHex then
      begin
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
      else val(ss,v,e);
      if e=0 then Value:=v
             else GetParamValue:=false;
    end
    else GetParamValue:=false;
  end;

var sbtyp : word;
begin
  FindBlaster:=False;
  Params:=GetEnv(VarName);
  Result:=GetParamValue(Params,'A',BaseAddr,true);
  Result:=Result and GetParamValue(Params,'I',SbIRQ,false);
  Result:=Result and GetParamValue(Params,'D',SbDMA,false);
  Result:=Result and GetParamValue(Params,'T',SbTyp,false);
  sbno:=byte(sbtyp);
  if not Result then exit;
  For Wbc:=1 to 7 do                                    {Prohlidni 7 portu}
  If ResetBlaster(BPorts[Wbc]) then                     {Pokud BLASTER odpovi}
  begin
    BaseAddr:=BPorts[Wbc]; FindBlaster:=True; Exit;     {Nastavim BaseAddr}
  end;
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
Procedure WriteDSP(ii : byte); Assembler;
asm
      push      bx
      push      cx
      mov       dx,baseaddr
      add       dx,0ch
      mov       cx,0ffffh        { ya know, slow SBs }
      { Wait for writing : }
@@litl: in        al,dx
      dec       cx
      jz        @@ende
      or        al,al
      js        @@litl  { check bit 7 if we can write to port 2xC }
      mov       al,ii
      out       dx,al   { write it }
@@ende: pop       cx
      pop       bx
end;

procedure wr_mixerreg(reg,wert:byte); assembler;
{ this routine may not work for all registers because of different timings.}
asm
  cmp       [SBNo],1
  je        @@nomixer                   { SB 1.0/1.5 has no mixer ! }
  cmp       SBNo,3
  je        @@nomixer                   { SB 2.0/2.5 has no mixer ! }
  mov       al,reg
  mov       dx,baseaddr
  add       dx,4
  out       dx,al
  inc       dx
  in        al,dx
  mov       al,wert
  out       dx,al
@@nomixer:
end;

function rd_mixerreg(reg:byte):byte; assembler;
asm
  cmp       [SBNo],1
  je        @@nomixer                   { SB 1.0/1.5 has no mixer ! }
  cmp       SBNo,3
  je        @@nomixer                   { SB 2.0/2.5 has no mixer ! }
  mov     dx,baseaddr
  add     dx,4
  mov     al,reg
  out     dx,al
  inc     dx
  in      al,dx
  xor     ah,ah
@@nomixer:
end;


function ReadDSP:byte; assembler;
asm
      mov       dx,baseaddr
      add       dx,0eh
      mov       cx,0ffffh    { ya know - slow SBs. You can believe me ! }
      { check for data available : }
@@litl: in        al,dx
      dec       cx
      jz        @@ende
      or        al,al
      jns       @@litl   { bit 7 set ? if not then wait }
      sub       dx,0eh-0ah
      in        al,dx    { write data }
      xor       ah,ah
@@ende:
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

procedure setvolume(vol:byte);
var b:byte;
begin
      if vol>=15 then vol:=15;
      b:=vol;
      b:=b shl 4;        { the other side }
      vol:=b+vol;
      wr_mixerreg($22,vol);
      wr_mixerreg($04,vol);
end;

procedure VolumeDSP(vol:byte);
var b : byte;
begin
  if sbno<>255 then     
    begin
      if vol>=15 then vol:=15;
      b:=vol;
      b:=b shl 4;        { the other side }
      vol:=b+vol;
      wr_mixerreg($04,vol);
    end
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

PROCEDURE initdmairq(p:pointer);
var b:byte;
begin
  getintvec(SBIRQ+$08,olddmairq);
  setintvec(SBIRQ+$08,p);
  b:=1 shl sbirq;
  b:=b or 04; { no changes for IRQ2 }
  port[$21]:=port[$21] and not b; { masking ... }
  SampleType:=0;
end;

{$F+}
procedure EventDMA08; interrupt;
begin
  inline ($9C);
  oldevent08;
  if (int08event)and(DosFlagPtr^=0) then begin
    int08event:=false;
    BlockRead(samplefile,pbyte(dmabuffer)^[(bufferdma div 2)*kterybufr-kterybufr],bufferdma div 2,loadedtoplay);
    if ioresult<>0 then sound(1000);
    if loadedtoplay=0 then EndingPlay:=true;
    if resttoplay>loadedtoplay then dec(resttoplay,loadedtoplay) else begin
      loadedtoplay:=resttoplay;
      resttoplay:=0;
    end;
  end;
end;

procedure EventDMA; interrupt;
var a : byte;
begin
  port[$20]:=$20;
  a:=port[baseaddr+$0e];

  if (not endingplay)and(loadedtoplay<>0) then begin
    PlayDMA(dmabuffer,bufferdma div 2*kterybufr-kterybufr,loadedtoplay);
    kterybufr:=1-kterybufr;
    if resttoplay=0 then endingplay:=true else
      if DosFlagPtr^=0 then begin
        BlockRead(samplefile,pbyte(dmabuffer)^[(bufferdma div 2)*kterybufr-kterybufr],bufferdma div 2,loadedtoplay);
        if ioresult<>0 then sound(1000);
        if loadedtoplay=0 then EndingPlay:=true;
        if resttoplay>loadedtoplay then dec(resttoplay,loadedtoplay) else begin
          loadedtoplay:=resttoplay;
          resttoplay:=0;
        end;
      end else int08event:=true;
  end else SampleType:=0;
end;
{$F-}

procedure PlayDMAfile(size : longint; samplereate : word;from_dubbing_file : boolean);
begin
  resttoplay:=size;
  EndingPlay:=false;
  KteryBufr:=1;
  int08event:=false;
  stopdma;
  SetSamplingRate(samplereate);
  BlockRead(samplefile,pbyte(dmabuffer)^[0],bufferdma div 2,loadedtoplay);
  if ioresult<>0 then begin
    sound(1000);
    exit;
  end;
  if resttoplay>loadedtoplay then dec(resttoplay,loadedtoplay) else begin
    loadedtoplay:=resttoplay;
    resttoplay:=0;
  end;
  if loadedtoplay<>0
    then PlayDMA(dmabuffer,0,loadedtoplay)
    else exit;
  if resttoplay=0 then EndingPlay:=true else begin
    BlockRead(samplefile,pbyte(dmabuffer)^[bufferdma div 2-1],bufferdma div 2,loadedtoplay);
    if loadedtoplay=0 then EndingPlay:=true;
    if resttoplay>loadedtoplay then dec(resttoplay,loadedtoplay) else begin
      loadedtoplay:=resttoplay;
      resttoplay:=0;
    end;
  end;
end;

PROCEDURE autoinitdmairq;
var b:byte;
begin
  getintvec($08, @oldevent08);
  setintvec($08, @eventDMA08);
  getintvec(SBIRQ+$08,olddmairq);
  setintvec(SBIRQ+$08,@EventDMA);
  b:=1 shl sbirq;
  b:=b or 04; { no changes for IRQ2 }
  port[$21]:=port[$21] and not b; { masking ... }
  SampleType:=0;
end;

PROCEDURE donedmairq;
var b:byte;
begin
  b:=1 shl sbirq;
  b:=b and not 4; { no mask for IRQ2 }
  port[$21]:=port[$21] or b;
  setintvec($08, @oldevent08);
  setintvec(SBIRQ+$08,olddmairq);
end;

procedure speaker(f:boolean);
begin
  if f then begin
    writedsp($d1);
    delay(110)
  end else begin
    writedsp($d3);
    delay(220)
  end;
end;

procedure PauseDMA;
begin
  writedsp($d0);
end;

procedure ContinueDMA;
begin
  writedsp($d4);
end;

procedure StopDMA;
begin
  if (baseaddr=0)or(SbNo=255) then exit;
  nosound; {Nema to tady co delat LukS je to kvuli Soundv proc EventDMA}
  { for 16bit modes : }
  writedsp($d0);
  writedsp($d9);
  writedsp($d0);
  { for 8bit modes : }
  writedsp($d0);
  writedsp($da);
  writedsp($d0);
  resetblaster(baseaddr);
  asm
    mov   bx,sbdma {dma_channel}
    mov   al,bl
    out   0ah,al
  end;
end;


function DMAposition:word; assembler;
asm
  mov dx,$0c
  xor al,al
  out dx,al
  mov dx,3
  in al,dx
  mov bl,al
  in al,dx
  mov ah,al
  mov al,bl
end;


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

  mov cx, 25
@pausee:
  IN   AL,DX
  loop @pausee


  INC  DX
  MOV  AL,DATA
  OUT  DX,AL
  DEC  DX

  mov cx, 25
@pauseee:
  IN   AL,DX
  loop @pauseee
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
end.
