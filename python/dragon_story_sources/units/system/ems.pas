{$G+}
unit ems;

interface

function InitEMS : byte;
function VerEMS : byte;
function MemEMS : word;
function MaxEMS : word;
function GetMemEMS(size : word) : word;
function FreeMemEMS(handle : word) : byte;
function MoveEMS(handle : word;size,ofes:longint; p : pointer;co : boolean) : byte;
{rukojet, delka prenaseneho bl., ofset v EMS, pointer v konv pam.,
 true=read z ems/false=write do ems}

implementation

function InitEMS : byte; assembler;
asm
  push ds
  push cs
  pop  ds
  mov  ax,3567h
  int  21h
  mov  di,0aH
  mov  si,offset @emm
  mov  cx,8
  repe cmpsb
  jz   @Konec1
  mov  al,255
  jmp  @Konec
@EMM: db 'EMMXXXX0',0
@Konec1:
  mov ax,4000h
  int 67h
@Konec:
  pop  ds
end;

function VerEMS : byte; assembler;
asm
  mov ax,4600h
  int 67h
end;

function MemEMS : word; assembler;
asm
  mov ax,4200h
  int 67h
  mov ax,bx
end;

function MaxEMS : word; assembler;
asm
  mov ax,4200h
  int 67h
  mov ax,dx
end;

function GetMemEMS(size : word) : word; assembler; {size je o 16kB menci}
asm
  mov ax,4300h
  mov bx,size
  int 67h
  or ah,ah
  jnz @dal
  mov ax, dx
  jmp @dallll
@dal:
  xor ax,ax
@dallll:
end;

function FreeMemEMS(handle : word) : byte; assembler;
asm
  mov ax,4500h
  mov dx,handle
  int 67h
end;


function MoveEMS(handle : word;size, ofes:longint; p : pointer;co : boolean) : byte;
var inf : record
            siz : longint;
            od : byte;
            handleod,
            ofsod,
            segod : word;
            kam : byte;
            handlekam,
            ofskam,
            segkam : word;
          end;
    chyba : byte;
    pp : pointer;
    i:word;
begin
  pp:=@inf;
  with inf do begin
    siz:=size;
    if co then begin {Read}
      od:=1; {EMS}
      handleod:=handle;
      ofsod:=ofes mod 16384;
      segod:=ofes div 16384;
      kam:=0; {Konvencni pamet}
      handlekam:=0;
      segkam:=seg(p^); ofskam:=ofs(p^);
    end else begin {Write}
{      for i:=ofes div 16384 to (ofes+size-1) div 16384 do} asm
        mov ah,44h
        xor al,al
        mov bx,1
        mov dx,handle
        int 67h
        mov chyba,ah
      end;
      od:=0; {konvencni pamet}
      handleod:=0;
      segod:=seg(p^); ofsod:=ofs(p^);
      kam:=1;
      handlekam:=handle;
      ofskam:=ofes mod 16384;
      segkam:=ofes div 16384;
    end;
  end;
  asm
    push ds
    lds si, pp
    mov ax,5700h
    int 67h
    pop ds
    mov chyba,ah
  end;
  MoveEMS:=chyba;
end;

end.