{$M $800,0,0 }
uses Crt, Dos;

const max = 20;
      maxmouse = 4;
      now : boolean = false;
var  KbdIntVec : Procedure;
     x, y, poc, pocmouse : word;
     oldmouse : procedure;
{$F+}
procedure Keyclick; interrupt;
begin
  if poc= max then begin
    x:=random(631)+8;
    y:=random(198)+1;
    asm
      mov   ax, 0004h
      mov   cx, X
      shl   cx, 1
      mov   dx, Y
      int   33h
    end;
    poc:=0;
  end;
  inc(poc);
  inline ($9C);
  KbdIntVec;
end;

procedure NewMOuseee(xFlags, xCS, xIP, xAX, xBX, xCX, xDX, xSI, xDI, xDS, xES, xBP: Word); interrupt;
begin
  if xAX=3 then begin
    if not now then
      if pocmouse= maxmouse then begin
        pocmouse:=0;
        xBX:=random(3);
        now:=not now;
      end
    else
      if pocmouse<> maxmouse then xBX:=random(3)
      else begin
        pocmouse:=0;
        now:=not now;
      end;
    inc(pocmouse);
  end  else begin
{    inline ($9C);}
    asm
      pushf
      mov ax, xax
      mov bx, xbx
      mov cx, xcx
      mov dx, xdx
      mov si, xsi
      mov di, xdi
      call dword ptr ds:oldmouse
      mov xax, ax
      mov xbx, bx
      mov xcx, cx
      mov xdx, dx
      mov xsi, si
      mov xdi, di
    end;
{    oldmouse;}
  end;
end;
{$F-}
begin
  randomize;
  poc:=0; pocmouse:=0;
  GetIntVec($1c,@KbdIntVec);
  SetIntVec($1c,Addr(Keyclick));
  GetIntVec($33,@oldmouse);
  SetIntVec($33,Addr(NewMOuseee));
  Keep(0);
end.
