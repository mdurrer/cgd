uses sblaster,crt,dos;

var key : word;
    s : TAudioControl;
    size : longint;
    mm : longint;
    voll,volr : byte;

procedure LoadandPlayDMA;
begin
  assign(fileofsample,'plexis.voc'{'vole1.sam'});
  reset(fileofsample,1);
  if ioresult<>0 then begin writeln('pico!'); exit; end;
  size:=filesize(fileofsample);
{  size:=5000;}
{  PlayDMAFromFile(size,22000);}
end;

FUNCTION WHATVOLUME : BYTE; ASSEMBLER;
ASM
  mov dx,BaseAddr
  add dx,0Ah
  in al,dx
END;

FUNCTION YES : BOOLEAN;
BEGIN
  YES:=FALSE;
  IF ENDOFDMA THEN BEGIN
    WRITEDSP($20);
    IF (WHATVOLUME<50) THEN YES:=TRUE;
    delay(10);
  END;
END;

begin
  voll:=7;
  volr:=7;
  mm:=memavail;
  if FindBlaster and ResetDSP then writeln('else ErrorMessage(''Neni Blaster'');');
  writeln('Adresa: ',BaseAddr,'        IRQ: ',SbIRQ,'         DMA: ',SbDMA);
  getmemdma(databufferdma);
  volumedsp(6+16*6);
  ReadAudioControl(s);
  s.master.l:=15;
  s.master.r:=15;
  s.FM.l:=15;
  s.FM.r:=15;
  s.mic:=0;
  s.stereo:=1;
  SetAudioControl(s);
  LoadandPlayDMA;
  repeat
    KEY:=0;
    gotoxy(1,wherey);
{    write(DMAposition,':',AudioCounter,'     ');}
    write('  volumeDSP l:',voll,'  r:',volr,'   ');
    if keypressed then key:=byte(readkey);
    if (key=0)and keypressed then key:=byte(readkey);
    if upcase(chr(key))='Q' then Dec(voll);
    if upcase(chr(key))='W' then Inc(voll);
    if upcase(chr(key))='Z' then Dec(volr);
    if upcase(chr(key))='X' then Inc(volr);
{    volumeDSP(voll+16*volr);}
    if (key=13)or (Yes) then begin
      StopDMA;
      seek(fileofsample,0);
      PlayDMAFromFile(size,22000);
    end;
    if (UpCase(chr(key))='S') then stopdma;
  until key=27;
  StopDMA;
  FreeMemDMA(DataBufferDMA);
  close(fileofsample);
  if mm<>memavail then
    writeln(#7,mm,'  ',memavail);
end.
