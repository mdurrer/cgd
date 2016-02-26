
unit mouse;

interface

uses dos;

var
   M_X, M_Y : word;

procedure InstallGrMouse;
procedure MouseArea(min_x, max_x, min_y, max_y : word );
procedure MouseOn;
procedure MouseOff;
procedure SetMouseXY(x, y : word );
function InArea(width,height, x,y : word) : boolean;
function MouseX : word;
function MouseY : word;
function MouseKey : word;

implementation

var
     register:registers;


procedure MouseArea(min_x, max_x, min_y, max_y : word );assembler;

asm
      mov cx,min_x          {min. x}
      mov ax,max_x          {max. x =>sirka}
      mov dx,2
      mul dx
      mov dx,ax
      mov ax,7
      int 33h               {nastaveni min. a max. x}
      mov ax,8
      mov cx,min_y          {min. y}
      mov dx,max_y          {max. y => vyska}
      int 33h               {nastaveni min. a max. y}
end;


procedure SetMouseXY(x, y : word );assembler;

asm
      mov ax,x
      mov cx,2
      mul cx
      mov cx,ax
      mov ax,4
      mov dx,y
      int 33h               {nastaveni kurzoru mysi na x,y }
end;


procedure MouseOn;assembler;

asm
      mov ax,1
      int 33h               {zapnuti kurzoru mysi}
end;


procedure MouseOff;assembler;

asm
      mov ax,2
      int 33h               {vypnuti kurzoru mysi}

end;

procedure InstallGrMouse;

begin

   asm
      mov ax,0
      int 33h               {inicializace mysi}
   end;

end;

function MouseX;

begin
    register.ax:=3;
    intr($33,register);
    MouseX:=register.cx div 2;
end;


function MouseY;

begin
    register.ax:=3;
    intr($33,register);
    MouseY:=register.dx;
end;


function MouseKey;

begin
    register.ax:=3;
    intr($33,register);
    MouseKey:=register.bx;
end;


function InArea(width,height, x,y : word ) : boolean;

begin
  InArea := (M_X>=x)and(M_Y>=y)and(M_X<x+width)and(M_Y<y+height);
end;


begin
end.