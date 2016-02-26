{$M 16384,0,655360}

uses dos,crt;

type
    tbytearray= array[0..60000] of byte;
    pbytearray= ^tbytearray;
var 
    inpbuf, outbuf: pbytearray;
    xtimes: real;
    inp, out: file;
    inpname, outname: string;
    i: integer;
    DirInfo: SearchRec;
    eof: boolean;
    bufuse: integer;

const
    bufsize=10000;
         
function ReadBuffer: boolean;
begin
  ReadBuffer:= False;
  if(filesize(inp)-10000)<filepos(inp) then begin
  {nenaplnimne uz cely buffer:}
    bufuse:= filesize(inp)-filepos(inp);
    blockread(inp, inpbuf^, filesize(inp)-filepos(inp));
    ReadBuffer:= True;
  end else begin
    blockread(inp, inpbuf^, 10000);
    bufuse:= 10000;
  end;
end;

begin
  write('kolika nasobek puvodni velikosti: ');
  readln(xtimes);
  getmem(inpbuf, bufsize);
  getmem(outbuf, round(xtimes*bufsize)+1000);

  Findfirst('*.buf', $3f, DirInfo); { All files with extendion *.buf }
  while DosError=0 do begin
    inpname:=dirinfo.name;
    outname:=copy(inpname,1,length(inpname)-4)+'.!!!';
    assign(inp,inpname);
    reset(inp,1); if ioresult<>0 then begin
      writeln('Vstupni soubor neexitstuje!');
      exit;
    end;
    seek(inp,16*5);
    assign(out,outname);
    rewrite(out,1); if ioresult<>0 then begin
      writeln('nelze otevrit takovy vystupni soubor!');
      exit;
    end;
    {preskocime pochybnou hlavicku:}
    seek(inp,16*5);
    repeat
      eof:= ReadBuffer;
      for i:= 0 to round(bufuse*xtimes)-1 do outbuf^[i]:= inpbuf^[round(i/xtimes)]; 
      blockwrite(out, outbuf^, round(bufuse*xtimes));
    until eof;
    close(inp);
    close(out);
    writeln(#13#10,inpname,'->',outname);
    FindNext(DirInfo);
  end;
  freemem(inpbuf, bufsize);
  freemem(outbuf, round(xtimes*bufsize)+1000);
  writeln('Vsecko v oukeju...');
end.