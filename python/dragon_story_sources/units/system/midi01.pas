{$G+,I-}
unit midi01;

interface

procedure InitMidi;
procedure DoneMidi;
procedure LoadMidi(name : string);
procedure PlayMidi;
procedure StopMidi;
procedure LoadConfig(name : string);

const StopOnEnd : boolean = false;
      bufmidi : word = 35000;
      playmidiflag : boolean = false;
      DrumData:array[1..20] of byte=(12,12,1,8,1,8,12,1,12,1,4,1,4,4,2,4,2,1,1,4);
      {udaje pro bici}

var
    CopyOfssMidi, OfssMidi : array[0..32] of word; { =$ffff vypnuto}
    OldProcMidi : procedure;
    VolumeAll : real;
    TimerDW : longint;
    DrumInfo : byte; {Dodelavka}
    StartChanDrum : byte;

implementation

uses dos,sblaster,texts;

type tbyte = array[0..65530] of byte;
     pbyte = ^tbyte;
     tinstruments = array[0..127] of TInstrument;

const maxchanel : byte = 8;
      pann : array[0..32] of byte =
        (3,3,3,1,2,1,2,1,2,3,1,2,1,2,1,3,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1);  {2=levy;1=pravy;3=oba}

var midi : pbyte;
    delaymidi : array[0..32] of word;
    cbyte, oldcbyte : array[0..32] of byte;
    b1midi, b2midi, b3midi : byte;
    instrummidi : array[0..32,0..32] of byte; {1=v jedne stope/2 stopa}
    sblastermidi : array[0..32] of record
      chanel, note : byte;                             { $ff= nepouzity}
    end;
    instrument : ^tinstruments;
    _notfrq:array[1..96] of word;
    timebase,uz_org,pocitadlo : word;
    stopamidi, maxstopamidi : byte;
    uz_timer,pocitadlotimer : real;
    typeofpalymidi : byte;

procedure LoadDrums;
begin
  WriteFM(0,$a8,$57);
  WriteFM(0,$b8,$09);

  WriteFM(0,$a7,$03);
  WriteFM(0,$b7,$0a);
  WriteFM(0,$54,$00);
  WriteFM(0,$34,$0c);
  WriteFM(0,$74,$f8);
  WriteFM(0,$94,$b5);
  WriteFM(0,$f4,$00);

  WriteFM(0,$52,$00);
  WriteFM(0,$32,$04);
  WriteFM(0,$72,$f7);
  WriteFM(0,$92,$b5);
  WriteFM(0,$f2,$00);

  WriteFM(0,$51,$00);
  WriteFM(0,$31,$01);
  WriteFM(0,$71,$f7);
  WriteFM(0,$91,$b5);
  WriteFM(0,$f1,$00);

  WriteFM(0,$55,$00);
  WriteFM(0,$35,$11);
  WriteFM(0,$75,$d2);
  WriteFM(0,$95,$74);
  WriteFM(0,$f5,$00);

  WriteFM(0,$50,$40);
  WriteFM(0,$30,$90);
  WriteFM(0,$70,$d3);
  WriteFM(0,$90,$01);
  WriteFM(0,$f0,$00);

  WriteFM(0,$53,$00);
  WriteFM(0,$33,$c0);
  WriteFM(0,$73,$ca);
  WriteFM(0,$93,$9a);
  WriteFM(0,$f3,$00);

  WriteFM(0,$a6,$0);
  WriteFM(0,$b6,2);

  WriteFM(0,$c6,$00 or (3 shl 4));
  WriteFM(0,$c7,$00 or (3 shl 4));
  WriteFM(0,$c8,$00 or (3 shl 4));
  {Vzdy pro STEREO-REZIM!}
end;

procedure DrumInit(BaseAdr:word);
var DrumTemp:byte;
begin
  DrumInfo:=0;
  WriteFM(0,$BD,$20);    {Vypnout bici}
  for DrumTemp:={6}StartChanDrum to {8}StartChanDrum+2 do begin  {Vypina kanaly 6-8}
    WriteFM(0,$A0+DrumTemp,0);
    WriteFM(0,$B0+DrumTemp,0);
    WriteFM(1,$A0+DrumTemp,0);
    WriteFM(1,$B0+DrumTemp,0);
  end;
  LoadDrums;                     {Nahraje nastroje}
end;

procedure PlayDrum(DrumNote:byte;DrumVolume:byte);
begin
  if DrumNote in [35..54]
    then DrumInfo:=DrumInfo or DrumData[DrumNote-34]
    else EXIT;
  WriteFM(0,$BD,$20+DrumInfo);
  WriteFM(0,$43+10+{6}StartChanDrum,DrumVolume);
  WriteFM(0,$40+10+{6}StartChanDrum,DrumVolume);
  WriteFM(0,$43+10+{7}StartChanDrum+1,DrumVolume);
  WriteFM(0,$43+10+{8}StartChanDrum+2,DrumVolume);
  WriteFM(0,$40+10+{7}StartChanDrum+1,DrumVolume);
  WriteFM(0,$40+10+{8}StartChanDrum+2,DrumVolume);
end;

procedure StopDrum(DrumNote:byte);
begin
  if DrumNote in [35..54]
    then DrumInfo:=DrumInfo and (NOT DrumData[DrumNote-34])
    else EXIT;
  WriteFM(0,$BD,$20+DrumInfo);
end;

procedure PlayNote(instr,chan, midinote, volume : byte);
var i : byte;
    v : real;
begin
  if (chan=9)or(chan=15) then begin
    v:=63-VolumeAll*(Volume div 2);  {nevim, ktera rovnice je lepsi}
    PlayDrum(midinote,round(v));
    exit;
  end;
  i:=0;
  while ((sblastermidi[i].chanel<>$ff)or (i in [{6}StartChanDrum..{8}StartChanDrum+2]))and(i<=maxchanel) do inc(i);
  sblastermidi[i].note:=midinote;
  sblastermidi[i].chanel:=chan;
  if i>maxchanel then i:=1;
  v:=63-VolumeAll*(Volume div 2);  {nevim, ktera rovnice je lepsi}
  SbFMSetVoice(i, instrument^[instrummidi[instr,stopamidi]],pann[instr],round(v));
  SetFMVoiceVolume(i,round(v));    {!!! zde je chyba !!! LukS Luk ### }
  SbFMKeyOnMidi(i, _notfrq[midinote-11]);
end;

procedure StopNote(chan, freq : byte);
var i : byte;
begin
  if (chan=9)or(chan=15) then begin
    StopDrum(freq);
    exit;
  end;
  i:=0;
  while (not((sblastermidi[i].chanel=chan)and(sblastermidi[i].note=freq)))
    and(i<=maxchanel) do inc(i);
  if i>maxchanel then exit; {stane se kdyz je malo kanalu}
  SbFMKeyOff(i);
  sblastermidi[i].chanel:=$ff;
end;

procedure SetTimerMidi(BPM : word); assembler;
asm
  cli
  mov   al,36h
  out   43h,al
  mov   bx,BPM
  mov   ax,34dch
  mov   dx,12h
  div   bx
  push  ax
  out   40h,al
  mov   al,ah
  out   40h,al
  pop   bx
  sti
  xor   ax,ax
  mov   dx,1
  div   bx
  mov   UZ_ORG,ax
  mov   Pocitadlo,0
end;

function rekalk(l : longint) : longint; {rekompilace na intel}
type ta = array[1..4] of byte;
var a : ^ta;
begin
  a:=@l;
  a^[1]:=a^[4] xor a^[1];
  a^[4]:=a^[1] xor a^[4];
  a^[1]:=a^[4] xor a^[1];

  a^[2]:=a^[3] xor a^[2];
  a^[3]:=a^[2] xor a^[3];
  a^[2]:=a^[3] xor a^[2];
  rekalk:=l;
end;

function readdelay : word;
var b1, b2 : byte;
    delaymidi : word;
begin
  delaymidi:=0;
  repeat
    delaymidi:=delaymidi shl 7;
    delaymidi:=delaymidi + (midi^[ofssMidi[stopamidi]] and $7f);
    inc(ofssMidi[stopamidi]);
  until midi^[ofssMidi[stopamidi]-1]<128;
  readdelay:=delaymidi;
end;

{$F+}
procedure newint08; interrupt;
label exitttAll;
begin
  if not playmidiflag then goto exitttAll;
  for stopamidi:=0 to maxstopamidi do begin
    if delaymidi[stopamidi]<>0 then dec(delaymidi[stopamidi]);
    if (delaymidi[stopamidi]<>0)or(ofssMidi[stopamidi]=$ffff) then continue{goto exittt};
    repeat
      if midi^[ofssMidi[stopamidi]]>127 then begin
        cbyte[stopamidi]:=midi^[ofssMidi[stopamidi]]; inc(ofssMidi[stopamidi]);
        oldcbyte[stopamidi]:=cbyte[stopamidi];
      end else cbyte[stopamidi]:=oldcbyte[stopamidi];
      case cbyte[stopamidi] and $f0 of
        $80 : begin
              StopNote(cbyte[stopamidi] and $f,midi^[ofssMidi[stopamidi]]);
              inc(ofssMidi[stopamidi],2); {pust klavesu}
            end;
        $90 : begin
              if midi^[ofssMidi[stopamidi]+1]=0 {stiskni klavesu}
                then StopNote(cbyte[stopamidi] and $f,midi^[ofssMidi[stopamidi]])
                else PlayNote(cbyte[stopamidi] and $f,cbyte[stopamidi] and $f,
                     midi^[ofssMidi[stopamidi]],midi^[ofssMidi[stopamidi]+1]);
              inc(ofssMidi[stopamidi],2);
            end;
        $a0 : inc(ofssMidi[stopamidi],2);
        $b0 : inc(ofssMidi[stopamidi],2);
        $c0 : begin
               { nastav nastroj }
               instrummidi[cbyte[stopamidi] and $f,stopamidi]:=
                 midi^[ofssMidi[stopamidi]];
               inc(ofssMidi[stopamidi]);
             end;
        $d0 : inc(ofssMidi[stopamidi]);
        $e0 : inc(ofssMidi[stopamidi],2);
        $f0 : if cbyte[stopamidi]=$ff then
               case midi^[ofssMidi[stopamidi]] of
                 $51 : {ord('Q')} begin  {zmen tempo}
                     b1midi:=midi^[ofssMidi[stopamidi]+2];
                     b2midi:=midi^[ofssMidi[stopamidi]+3];
                     b3midi:=midi^[ofssMidi[stopamidi]+4];
                     inc(ofssMidi[stopamidi],5);
                     uz_timer:=1/(((longint(b1midi*65536)+
                       word(b2midi*256)+byte(b3midi)) div timebase)
                       /1000000);
                     SetTimerMidi(round(uz_timer));
                     uz_timer:=uz_timer/100;
                   end;
                 $2F : begin {konec stopy}
                     ofssMidi[stopamidi]:={23}$ffff;
                     delaymidi[stopamidi]:=1;
                     if not StopOnEnd then PlayMidi;
                     continue;
                   end;
                 else inc(ofssMidi[stopamidi],midi^[ofssMidi[stopamidi]+1]+2);
               end else if cbyte[stopamidi]=$f0
                 then inc(ofssMidi[stopamidi],readdelay);
      end;
      delaymidi[stopamidi]:=readdelay;
    until delaymidi[stopamidi]<>0;
  end;
exitttall:
  inc(pocitadlo);
  pocitadlotimer:=pocitadlotimer+1;
  if pocitadlotimer>=uz_timer then begin
    Inc(TimerDW);
    pocitadlotimer:=pocitadlotimer-uz_timer;
  end;
  if pocitadlo>=uz_org then begin
    pocitadlo:=0;
    inline ($9C);
    OldProcMidi;
  end else   { uprava dle GPL }
  asm
    mov al,$20
    out $20,al
  end;
end;
{$F-}

procedure InitMidi;
const toness:array[1..12] of word=(0,20,42,65,89,115,142,171,201,234,268,304);
var f : file;
    i : word;
begin
  playmidiflag:=false;
  if BaseAddr<>0 then begin
    ResetBlaster(BaseAddr);
    if SbNo<>255 then ResetDSP;
    setvolume(15);
    if SbNo<>255 then volumedsp(15);
    SbFMReset;
    writefm(0,$01,32);
    writefm(0,$BD,00);
    if SbNo<>255 then writesb($0C,$D1);
    SbFMSetStereo(typeofpalymidi=0);
  end;
  StartChanDrum:=6;
  DrumInit(BaseAddr);
  getmem(instrument,sizeof(tinstruments));
  assign(f,'cmf.ins');
  reset(f,1);
  if ioresult<>0 then ErrorMessage(1);
  blockread(f,instrument^,sizeof(tinstruments));
  if ioresult<>0 then errormessage(2);
  close(f);
  for i:=1 to 96 do _notfrq[i]:=$100+(((i-1) div 12)*$400)+$57+toness[((i-1) mod 12)+1];
  Uz_Org:=1;
  Uz_Timer:=5;
  Pocitadlo:=0;
  PocitadloTimer:=0;
  GetMem(midi,bufmidi);
  GetIntVec($08,@OldProcMidi);
  SetIntVec($08,@NewInt08);
  SetTimerMidi(120);
  uz_timer:=120/100;
  timerdw:=0;
end;

procedure DoneMidi;
begin
  asm
    cli
    mov al,$36
    mov dx,$43
    out dx,al
    mov al, 0
    mov dx,$40
    out dx,al
    mov al,0
    out dx,al
    sti
  end;
  SetIntVec($08,@oldprocmidi);
  FreeMem(midi,bufmidi);
  FreeMem(instrument,sizeof(tinstruments));
  if baseaddr<>0 then SbFMReset;
end;

procedure LoadMidi(name : string);
var f : file;
    x,xx,xxx : word;
begin
  if baseaddr=0 then exit;
  assign(f,name);
  reset(f,1);
  if ioresult<>0 then ErrorMessage(3);
  if bufmidi<filesize(f) then ErrorMessage(4);
  blockread(f,midi^,filesize(f),x);
  if x<>filesize(f) then ErrorMessage(5);
  if (midi^[0]<>$4d)or(midi^[1]<>$54)or(midi^[2]<>$68)or(midi^[3]<>$64)
    then ErrorMessage(6);
  if midi^[8]*256+midi^[9]>$1
    then  ErrorMessage(7);
  maxstopamidi:=midi^[10]*256+midi^[11]-1;
  if (midi^[14]<>$4d)or(midi^[15]<>$54)or(midi^[16]<>$72)or(midi^[17]<>$6B)
    then ErrorMessage(8);
  timebase:=midi^[12]*256+midi^[13];
  for x:=0 to 32 do begin
    sblastermidi[x].chanel:=255;
    ofssMidi[x]:=$ffff;
    delaymidi[x]:=0;
  end;
  xx:=14;
  for x:=0 to maxstopamidi do begin
    ofssMidi[x]:=xx+9;
    copyofssMidi[x]:=xx+9;
    xx:=xx+midi^[xx+6]*256+midi^[xx+7]+8;
  end;
  close(f);
end;

procedure PlayMidi;
var i : byte;
begin
  if baseaddr=0 then exit;
  for i:=0 to maxstopamidi do if ofssmidi[i]<>$ffff then break;
  if (i=maxstopamidi)and(ofssmidi[i]=$ffff) then begin
    move(copyofssmidi,ofssmidi,sizeof(ofssmidi));
    SetTimerMidi(120);
    uz_timer:=120/100;
    for i:=0 to 32 do begin
      sblastermidi[i].chanel:=255;
      delaymidi[i]:=0;
    end;
  end;
  playmidiflag:=true;
end;

procedure StopMidi;
var i : byte;
begin
  if baseaddr=0 then exit;
  SbFMReset;
  playmidiflag:=false;
end;

procedure LoadConfig(name : string);
var f : text;
    b : byte;
begin
  assign(f,name);
  reset(f);
  if ioresult<>0 then begin
    FindBlaster;
    if (ResetBlaster(baseaddr) and ResetDSP)or
       (ResetBlaster(baseaddr) and ResetDSP)then begin
      writeln('Found and configured sound card.');
      exit;
    end;
    ErrorMessage(10);
  end;
  readln(f,baseaddr);
  if ioresult<>0 then ErrorMessage(9);
  readln(f,sbirq);
  if ioresult<>0 then ErrorMessage(9);
  readln(f,sbdma);
  if ioresult<>0 then ErrorMessage(9);
  readln(f,maxchanel);
  if ioresult<>0 then ErrorMessage(9);
  readln(f,b);
  if ioresult<>0 then ErrorMessage(9);
  readln(f,sbno);
  if ioresult<>0 then ErrorMessage(9);
  close(f);
end;

end.
