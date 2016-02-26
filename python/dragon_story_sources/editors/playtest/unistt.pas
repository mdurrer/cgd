program nic;

uses graph256,texts,crt;

var font : pointer;

procedure TiskInfo(smallfont, bigfont : pointer);
var i, ii, line : byte;
    addr : longint;
    adddr,mouseyy : word;
begin
  SetActivePage(1); ClearScr(0);
  SetActivePage(2); ClearScr(0);
  SetActivePage(3); ClearScr(0);
  SetActivePage(0); ClearScr(0);
  for i:=1 to maxtextsmall do case textsmall[i].x of
    -1 : printtext((320-widthoftext(smallfont,textsmall[i].s))div 2,textsmall[i].y,textsmall[i].s,smallfont);
    -2 : printtext(320-widthoftext(smallfont,textsmall[i].s),textsmall[i].y,textsmall[i].s,smallfont);
    else
      printtext(textsmall[i].x,textsmall[i].y,textsmall[i].s,smallfont);
  end;
  for i:=1 to maxtextsbig do case textsbig[i].x of
    -1 : printtext((320-widthoftext(bigfont,textsbig[i].s))div 2,textsbig[i].y,textsbig[i].s,bigfont);
    -2 : printtext(320-widthoftext(bigfont,textsbig[i].s),textsbig[i].y,textsbig[i].s,bigfont);
    else
      printtext(textsbig[i].x,textsbig[i].y,textsbig[i].s,bigfont);
  end;
  repeat until mousekey=0;
  NewMouseXY(0,100);
  mouseyy:=mousey;
  addr:=0;
  repeat
    if (mousey=0)or(mousey=199) then begin
      NewMouseXY(0,100);
      mouseyy:=100;
    end;
    if mouseyy<>mousey then addr:=addr-(longint(mouseyy)-mousey)*80;
    if addr<0 then addr:=0;
    if addr>600*80 then addr:=600*80;
    mouseyy:=mousey;
    {nutno dopsat cekani na paprsek}
    adddr:=addr;
    asm
        mov dx,3d4h
        mov al,0ch
        out dx,al
        inc dx
        mov ax,adddr
        xchg ah,al
        out dx,al   {vyssi bajt adresy VRAM}
        dec dx
        mov al,0dh
        out dx,al
        inc dx
        mov al,ah
        out dx,al   {nizsi bajt adresy VRAM}
    end;
  until (mousekey<>0)or keypressed;
end;


function ChooseFile(JakJeSave : boolean; var popis : string; font:pointer) : integer;
const maxs = 15;
      maxx = 180;
      xxx = 10;
      yyy = 10;
 function readlntext(x,y,len : word) : string;
 var i : byte;
     s : string;
     key : char;
 begin
   i:=0;
   s:='';
   bar(x,y,len,heigthoffont(font),0);
   bar(x+WidthOfText(font,s),y+heigthoffont(font)-2,5,2,5);
   repeat
     repeat
       key:=readkey;
       if key=#0 then begin key:=readkey; key:=#1; end;
     until ((key>#31)and(key<#173))or(key=#8)or(key=#13)or(key=#27);
     if key<>#13 then
       if (key=#8)and(s<>'')
         then s[0]:=chr(byte(s[0])-1)
         else s:=s+key;
     bar(x,y,len,heigthoffont(font),0);
     printtext(x,y,s,font);
     bar(x+WidthOfText(font,s),y+heigthoffont(font)-2,5,2,4);
   until (key=#13)or(key=#27);
   if key=#27 then s:=#27;
   readlntext:=s;
 end;
var  f : file;
     sejvy : array[1..maxS] of string;
     i : byte;
     s : string;
     key : char;
     p,pal : pointer;
 procedure FindOutSejvy;
 var i : byte;
 begin
   for i:=1 to maxS do begin
     str(i,s);
     assign(f,'save'+s+'.sav');
     reset(f,1);
     if ioresult<>0 then sejvy[i]:=#27
     else begin
       blockread(f,sejvy[i],sizeof(sejvy[i]));
       close(f);
     end;
   end;
 end;
 procedure ViewAll;
 var i : byte;
 begin
   clearscr(0);
   bar(xxx,yyy,maxx+90+widthoftext(font,'88:'),maxs*(2+heigthoffont(font))+3,0);
   bar(xxx+maxx+widthoftext(font,'88:'),yyy+((2+heigthoffont(font))*maxs-56) div 2,86,56,7);
   for i:=1 to maxs do begin
     str(i,s); s:=s+'.';
     bar(xxx+4+widthoftext(font,'88:'),1+(2+heigthoffont(font))*(i-1)+yyy,maxx-8,heigthoffont(font),0);
     rectangle(xxx+3+widthoftext(font,'88:'),1+(2+heigthoffont(font))*(i-1)+yyy,maxx-6,heigthoffont(font)+1,2);
     printtext(xxx+24-widthoftext(font,s),2+(2+heigthoffont(font))*(i-1)+yyy,s,font);
     if sejvy[1]<>#27 then printtext(xxx+6+widthoftext(font,'  '),2+(2+heigthoffont(font))*(i-1)+yyy,s+sejvy[i],font);
   end;
 end;
 procedure ReWrite(ii : byte);
 var i : byte;
 begin
   for i:=1 to maxs do begin
     if i=ii
       then {bar(xxx+4+widthoftext(font,'88:'),2+(1+heigthoffont(font))*(i-1)+yyy,maxx-8,heigthoffont(font),4)}
          rectangle(xxx+3+widthoftext(font,'88:'),1+(2+heigthoffont(font))*(i-1)+yyy,maxx-6,heigthoffont(font)+1,4)
       else {bar(xxx+4+widthoftext(font,'88:'),2+(1+heigthoffont(font))*(i-1)+yyy,maxx-8,heigthoffont(font),2);}
         rectangle(xxx+3+widthoftext(font,'88:'),1+(2+heigthoffont(font))*(i-1)+yyy,maxx-6,heigthoffont(font)+1,2);
     if sejvy[i]<>#27 then
       printtext(xxx+10+widthoftext(font,'  '),2+(2+heigthoffont(font))*(i-1)+yyy,sejvy[i],font);
   end;
   str(ii,s);
   assign(f,'save'+s+'.sav');
   reset(f,1);
   if ioresult=0 then begin
     seek(f,sizeof(sejvy[i]));
     blockread(f,p^,80*50+4);
     blockread(f,pal,768);
     setpalette(pal);
     putimage(xxx+maxx+3+widthoftext(font,'88:'),yyy+((2+heigthoffont(font))*maxs-50) div 2, p);
     close(f);
   end else
     bar(xxx+maxx+3+widthoftext(font,'88:'),yyy+((2+heigthoffont(font))*maxs-50) div 2,80,50,0);
 end;
 var ss : string;
begin
  getmem(p,80*50+4);
  getmem(pal,768);
  FindOutSejvy;
  Viewall;
  i:=1;
  repeat
    rewrite(i);
    key:=#0;
    repeat
      if keypressed then key:=readkey;
      Case MouseKey of
        1 : if (MouseX>xxx+10+widthoftext(font,'  '))and
               (MouseX<xxx+10+widthoftext(font,'  ')+maxx-8)and
               (MouseY>2+yyy)and
               (MouseY<2+(2+heigthoffont(font))*MaxS+yyy+heigthoffont(font))then
            begin
              i:=(MouseY-2-yyy)div(2+heigthoffont(font))+1;
              key:=#13;
            end;
        2 : key:=#27;
      end;
    until key<>#0;
    if (key=#80)and(i<>maxs) then inc(i);
    if (key=#72)and(i<>1) then dec(i);
    if (key=#13)and (JakjeSave) then begin
      ss:=sejvy[i];
      sejvy[i]:=readlntext(xxx+10+widthoftext(font,'  '),2+(2+heigthoffont(font))*(i-1)+yyy,maxx-8);
      if sejvy[i]=#27 then begin sejvy[i]:=ss; key:=#0; end;
    end;
  until (key=#13)or(key=#27);
  if key=#13
    then ChooseFile:=i
    else ChooseFile:=-1;
  if jakjesave then popis:=sejvy[i];
  freemem(pal,768);
  freemem(p,80*50+4);
end;


procedure SaveGame;
var i : integer;
    f : file;
    s,popis : string;
begin
  i:=ChooseFile(true,popis,font);
  if i>0 then begin
    str(i,s);
    s:='save'+s+'.sav';
    assign(f,s);
    rewrite(f,1);
    blockwrite(f,popis,sizeof(string));
    {sejvnout obr}
    blockwrite(f,palette^,768);
    {Skok na pospec save}
    close(f);
  end;
end;

procedure LoadGame;
var f : file;
    i : integer;
    s, popis : string;
begin
  i:=ChooseFile(true,popis,font);
  if i<1 then exit;
  str(i,s);
  s:='save'+s+'.sav';
  assign(f,s);
  reset(f,1);
  if ioresult<>0 then exit;
  seek(f,sizeof(string)+50*80+4+768);{popis+obrazek+paleta}
  {Pospec Load}
  close(f);
end;

var f: file;

begin
  lastline:=200;
  initgraph;
  foncolor1:=7;
  foncolor2:=2;
  foncolor3:=3;
  foncolor4:=4;
  overfontcolor:=255;
  Assign(f, '..\vyuk\mouse.gcf');
  Reset(f, 1);
  if ioresult<>0 then Exit;
  GetMem(MouseImage,FileSize(f));
  BlockRead(f,MouseImage^,FileSize(f));
  Close(f);
  InitMouse;
  MouseOn(0,0,mouseimage);
{  bar(0,0,320,200,100);
  bar(10,10,39,19,10);

  bar(100,50,19,99,30);
  bar(10,100,39,19,40);
}
  registerfont(pfont(font),'..\vyuk\stand2.fon');

{  tiskinfo(font,font);}
  SaveGame;

  FreeMem(MouseImage,FileSize(f));
  closegraph;
end.
