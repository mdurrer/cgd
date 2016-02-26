program SETUP;

uses sblaster, texts;

var f : text;

procedure error(b : byte);
begin
  writeln(setup_err[b]);
end;

procedure vpis;
begin
    assign(f,'midi.cfg');
    rewrite(f);
    if ioresult<>0 then error(1);
    writeln(f,baseaddr);
    if ioresult<>0 then error(2);
    writeln(f,SBIRQ);
    if ioresult<>0 then error(2);
    writeln(f,sbdma);
    if ioresult<>0 then error(2);
    writeln(f,8);
    if ioresult<>0 then error(2);
    writeln(f,1);
    if ioresult<>0 then error(2);
    writeln(f,SbNo);
    if ioresult<>0 then error(2);
    close(f);
    if ioresult<>0 then error(3);
end;

begin
  FindBlaster;
  if (ResetBlaster(baseaddr) and ResetDSP)or
     (ResetBlaster(baseaddr) and ResetDSP)then begin
    writeln(setup_log_success);
    vpis;
  end else begin
    writeln(setup_log_failure);
    baseaddr:=0;
    sbirq:=5;
    sbdma:=1;
    sbno:=1;
    vpis;
  end;
  Writeln('   NoSense 1995, LukS');
end.
