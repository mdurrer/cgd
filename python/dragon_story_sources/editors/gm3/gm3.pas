{$A+,B-,D+,E+,F-,G+,I-,L+,N-,O-,P-,Q-,R-,S+,T-,V+,X+,Y+}
{$M $4000,0,0 }

program GM3;

uses Dos,crt;

const MaxC = 7;

var  ProgramName, CmdLine : string;
     exitcode, runerror:word;
     cesta : array[1..MaxC] of string;


procedure LoadCesty;
var f   : text;
    i,j : byte;
begin
    cesta[i]:='';
    Assign(f,'GM3.INI');
    if ioresult<>0 then exit;
    Reset(f);
  for i:=1 to MaxC do begin
    ReadLn(f,cesta[i]);
    j:=1;
    while((cesta[i,j]<>';')and(cesta[i,j]<>' '))and(Length(cesta[i])<>j) do inc(j);
    cesta[i,0]:=chr(j-1);
  end;
  Close(f);
end;

procedure NastavCestu(var s : string);
var ss : string;
    f : text;
begin
  if (ExitCode>=1)and(ExitCode<=MAxC) then begin
    if ExitCode=0 then ExitCode:=1;
    ss:=cesta[Exitcode];
    if ss[length(ss)]='\' then ss[0]:=chr(byte(ss[0])-1);
    if ss[length(ss)]=':' then ss:=ss+'\';
    ChDir(ss);
  end else begin
    WriteLn('Chyba v komunikaci mezi procesy ....');
    halt;
  end;

  s:='';
  Assign(f,'GM3.RUN');
  if ioresult<>0 then exit;
  Reset(f);
  ReadLn(f,s);
  Close(f);
end;


begin
  ExitCode:=1;
  LoadCesty;
  NastavCestu(CmdLine);
  ProgramName:='GM3MAIN.EXE';
  repeat

    SwapVectors;   { spousteni GM3MAIN.EXE }
    Exec(ProgramName, CmdLine);
    SwapVectors;
    runerror:=doserror;
    exitcode:=DosExitCode;
    if (runerror<>0)or(exitcode=255) then begin
      case runerror of
        2 : Writeln('Nebyl nalezen soubor ',ProgramName,'!');
        3 : Writeln('Spatna cesta k souboru');
        8 : Writeln('Nedostatek pameti');
      end;
      if exitcode=255 then writeln('CUL8R');
      Break;
    end;
    NastavCestu(CmdLine); { nastavi adresar a  Precte predavanou vetu}
    case exitcode of
      2 : ProgramName:='KOMP.EXE';
      3 : ProgramName:='PLAY.EXE';
      4 : ProgramName:='AOMAKER.EXE';
      5 : ProgramName:='PALREDUC.EXE';
      6 : ProgramName:='FONTEDIT.EXE';
      7 : ProgramName:='DP.EXE';
      8 : ProgramName:='COMMAND.COM';
      65535 : Break;
    end;
    SwapVectors;
    Exec(ProgramName, CmdLine);
    SwapVectors;
    runerror:=doserror;
    if runerror<>0 then case runerror of
      2 : Writeln('Nebyl nalezen soubor ',ProgramName,'!');
      3 : Writeln('Spatna cesta k souboru');
      8 : Writeln('Nedostatek pameti');
    end;

    ProgramName:='GM3MAIN.EXE';
    ExitCode:=1; NastavCestu(CmdLine);
    if (exitcode=1)or(exitcode=0) then begin
      if CmdLine='' then GetDir(0,CmdLine);
      CmdLine:=CmdLine+' BACK';
    end;
  until false;
end.