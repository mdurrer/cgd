uses midi01,dma,sblaster,crt,dos;

var key : word;
    ss : string;
    waitt,ww:word;
    fff : file;
    p : pointer;
    pocitadlo,poch : longint;

procedure readdd;
begin
          write('.');
          assign(fff,'playm.exe');
          reset(fff,1);
    if ioresult<>0 then write(' !!▓33chybaReset▓!! ');
          blockread(fff,p^,30000);
    if ioresult<>0 then write(' !!▓33chybaRead▓!! ');
          close(fff);
    if ioresult<>0 then write(' !!▓33chybaClose▓!! ');
  {        gotoxy(1,wherey);
          write('Volume: ',(volumeall*100):3:1,'%   TimerDW:',TimerDW,'  ');}
        end;

begin
  pocitadlo:=0;
  randomize;
  clrscr;
  getmem(p,65000);
  ww:=1;
  if FindBlaster and ResetDSP then writeln('else ErrorMessage(''Neni Blaster'');');
  writeln('Adresa: ',BaseAddr,'        IRQ: ',SbIRQ,'         DMA: ',SbDMA);
  SetSamplingRate(43000);
  autoinitdmairq;
  if not InitDMA('cd.sam','cd.sam') then exit;
  bufmidi:=64000;
  ss:=FExpand(paramstr(1));
  if pos('.',ss)=0 then ss:=ss+'.MID';
  VolumeAll:=0.95;
  InitMidi;
  LoadMidi(ss);
  writeln(timerdw);
  PlayMidi;
  if paramcount=1 then
  repeat
     write('.');
     poch:=timerdw;
     while waitt+poch>timerdw do begin
       if random(320)={52}2 then READDD;
     end;
     key:=0;
     if keypressed then key:=byte(readkey);
     if (key=0)and keypressed then key:=byte(readkey);
     if (key=45)and(volumeall>=0) then volumeall:=volumeall-0.01;
     if (key=43)and(volumeall<=1) then volumeall:=volumeall+0.01;
     if upcase(chr(key))='P' then PlayMidi;
     if upcase(chr(key))='S' then StopMidi;
     waitt:=random(300);
     ww:=random(16)+1;  {ww:=15;}
     if ww in [1,15] then inc(waitt,random(1000));
     inc(pocitadlo);
  {   writeln(ioresult,'Pocet testu: ',pocitadlo,' ,Delay: ',Waitt,' ,sampl: ',ww);}
     if ioresult<>0 then sound(10000);
     writeln(#13#10,pocitadlo,'Zacatek:');
     PlayDMAString(ww,13000+random(30998),false);
   until (key=27)or(key=13)
  else key:=13;
  StopDMA;
  DoneMidi;
  DoneDMA;
  donedmairq;
  freemem(p,65000);
end.
