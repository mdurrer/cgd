(*{$A+,B-,D+,E+,F+,G+,I-,L+,N-,O-,P-,Q-,R-,S+,T-,V+,X+}*)
{$M 46384,185000,185000}
uses midi01,sblaster,crt,dos;

var key : word;
    s : TAudioControl;
    size : longint;
    sizee : word;
    p : pointer;
    mm : longint;
    voll,volr : byte;

procedure LoadandPlayDMA;
begin
  assign(fileofsample,'plexis.voc'{'vole1.sam'});
  {$i-}reset(fileofsample,1);{$i+}
  if ioresult<>0 then begin writeln('pico!'); exit; end;
  size:=filesize(fileofsample);
{  size:=5000;}
  PlayDMAFromFile(size,22000);
end;

begin
  voll:=7;
  volr:=7;
  mm:=memavail;
  if FindBlaster and ResetDSP then writeln('else ErrorMessage(''Neni Blaster'');');
  writeln('Adresa: ',BaseAddr,'        IRQ: ',SbIRQ,'         DMA: ',SbDMA);
  getmemdma(databufferdma);
  VolumeAll:=0.05;
  volumedsp(0);
  InitMidi;
  ReadAudioControl(s);
  s.master.l:=15;
  s.master.r:=15;
  s.FM.l:=15;
  s.FM.r:=15;
  s.mic:=0;
  s.stereo:=1;
  SetAudioControl(s);
  LoadandPlayDMA;
  LoadMidi(ParamStr(1){'music2.mid'});
  PlayMidi;
  repeat
    gotoxy(1,wherey);
{    write(DMAposition,':',AudioCounter,'     ');}
    write('Volume: ',(volumeall*100):3:1,'%   volumeDSP l:',voll,'  r:',volr,'   ');
{    if keypressed then }key:=byte(readkey);
    if (key=0)and keypressed then key:=byte(readkey);
    if (key=45)and(volumeall>=0) then volumeall:=volumeall-0.01;
    if (key=43)and(volumeall<=1) then volumeall:=volumeall+0.01;
    if upcase(chr(key))='P' then PlayMidi;
    if upcase(chr(key))='S' then StopMidi;
    if upcase(chr(key))='Q' then Dec(voll);
    if upcase(chr(key))='W' then Inc(voll);
    if upcase(chr(key))='Z' then Dec(volr);
    if upcase(chr(key))='X' then Inc(volr);
    volumeDSP(voll+16*volr);
    if key=13 then begin
{      EndOfDMA:=true;
      speaker(false);
{      StopAudioInt;}
  StopDMA;
      seek(fileofsample,0);
      PlayDMAFromFile(size,22000);
    end;
{    SwapVectors;
    Exec(GetEnv('COMSPEC'),'');
    SwapVectors;}
  until key=27;
  FreeMemDMA(DataBufferDMA);
  close(fileofsample);
  DoneMidi;
  if mm<>memavail then
    writeln(#7,mm,'  ',memavail);
end.
