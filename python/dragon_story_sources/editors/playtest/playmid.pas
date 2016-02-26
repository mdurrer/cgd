{$M 8192, 68000, 68000}
uses midi01,sblaster,crt,dos;

var key : word;
    s : TAudioControl;
    ss : string;

    old09 : procedure;

{$F+}
procedure Keyclick; interrupt;
begin
  if (Port[$60] = 87)and(volumeall>0.01) then volumeall:=volumeall-0.01;
  if (Port[$60] = 88)and(volumeall<1) then volumeall:=volumeall+0.01;
  inline ($9C);
  old09;
end;
{$F-}

begin
  if FindBlaster and ResetDSP then writeln('else ErrorMessage(''Neni Blaster'');');
  writeln('Adresa: ',BaseAddr,'        IRQ: ',SbIRQ,'         DMA: ',SbDMA);
  GetIntVec($9,@old09);
  SetIntVec($9,@Keyclick);
  bufmidi:=64000;
  ss:=FExpand(paramstr(1));
  if pos('.',ss)=0 then ss:=ss+'.MID';
  VolumeAll:=0.02;
  InitMidi;
  LoadMidi(ss);
  ReadAudioControl(s);
  s.master.l:=10;
  s.master.r:=10;
  s.FM.l:=15;
  s.FM.r:=15;
  s.mic:=0;
  s.stereo:=1;
  SetAudioControl(s);
  PlayMidi;
  if paramcount=1 then
    repeat
      key:=0;
      gotoxy(1,wherey);
      write('Volume: ',(volumeall*100):3:1,'%   TimerDW:',TimerDW,'  ');
      if keypressed then key:=byte(readkey);
      if (key=0)and keypressed then key:=byte(readkey);
      if (key=45)and(volumeall>=0) then volumeall:=volumeall-0.01;
      if (key=43)and(volumeall<=1) then volumeall:=volumeall+0.01;
      if upcase(chr(key))='P' then PlayMidi;
      if upcase(chr(key))='S' then StopMidi;
    until (key=27)or(key=13)
  else key:=13;
  if key=13 then begin
    SwapVectors;
    Exec(GetEnv('COMSPEC'), '');
    SwapVectors;
  end;
  DoneMidi;
  SetIntVec($9,@old09);
end.
