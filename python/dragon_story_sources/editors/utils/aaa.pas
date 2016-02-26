{$i-,r-,g+}

uses crt,dos;

var dmaplay:boolean;
    dma:byte; {0..3}
    irq:byte; {0..7,$10..??}
    olddmasize,base:word;
    dmabuffer:pointer;

const dmasize:word=65528;

var oldirq:procedure;
    curnote,cpos:byte;
    testflag:boolean;
    timeconst:byte;
    f:file;
    ch:char;

const baseadd:array[1..6] of word=($210,$220,$230,$240,$250,$260);
      irqadd:array[1..5] of byte=(2,3,5,7,10);

procedure ResetBlaster; Assembler;
Asm
         mov     cx,544             {Udajna adresa BLAST.}
         mov     dx,cx
         add     dx,06h                  {Index RESET registru}
         mov     al,1
         out     dx,al                   {Vyslu byte 1}
         xor     al,al                   {Zdrzeni o delce}
@First:  nop                             {65536 cyklu, aby}
         dec     al                      {to BLASTER stihnul}
         jnz     @First                  {nastavit}
         out     dx,al                   {Vyslu mu 0}
         mov     ax,2000h                {Zdrzeni o delce}
@Second: nop                             {8192 cyklu}
         dec     ax
         jnz     @Second
         mov     dx,cx                   {Znovu nactu BaseAdr}
         add     dx,0eh                  {Index stav. registru}
         in      al,dx                   {Nactu jeho hodnotu}
         test    al,80h                  {Nastaven bit 7 ?}
         jz      @Failed                 {Ne, neni blaster}
         mov     dx,cx                   {Kdyz ano,}
         add     dx,0ah                  {udelam jeste}
         in      al,dx                   {dalsi overovaci}
         cmp     al,0AAh                 {zkousku, zda je}
         jne     @Failed                 {BLASTER pritomen}
         mov     ax,1                    {Vyroba TRUE}
         jmp     @Ready
@Failed: xor     ax,ax                   {Vyroba FALSE}
@Ready:                 {RETURN}
end;

function ResetDSP:boolean; assembler;
asm
      mov        bl,1
      mov        dx,544
      add        dx,6
      mov        al,1         { write 1 to port 2x6 }
      out        dx,al
      in         al,dx
      in         al,dx
      in         al,dx
      in         al,dx
      xor        al,al
      out        dx,al        { after 3,3 μs write 0 to port 2x6 }

{ And now check the answer }
      add        dx,8
      mov        si,200
@@readloop:
      mov        cx,0ffffh      { SB2.0/1.0 are that slow :( }
@@testl:                          { check for data available }
      in         al,dx
      dec        cx
      jz         @@not
      or         al,al
      jns        @@testl

      sub        dx,4
      in         al,dx        { read data comming through }
      cmp        al,0aah
      je         @@aSB
      add        dx,4
      dec        si
      jnz        @@readloop
@@not:  mov        bl,0         { it's not a SB :( }
@@aSB:  xor        ah,ah
      mov        al,bl
end;

procedure writedsp(dat:byte);
var mybase:word;
begin
{$i-}
mybase:=base;
asm
xor cx,cx
@rep: mov dx,word ptr [mybase]
add dx,$c
in al,dx
and al,$80
jz @okaw
loop @rep
@okaw:
mov al,[dat]
out dx,al
mov cx,100
@@1:
in al,dx
loop @@1
end;
end;

procedure dmahalt;
begin
{  EndingPlay:=true;}
{  SampleType:=0;}
  { for 16bit modes : }
  writedsp($d0);
  writedsp($d9);
  writedsp($d0);
{   mov   al,0d0h   call  wr_dsp
    mov   al,0d9h   call  wr_dsp
    mov   al,0d0h   call  wr_dsp }
  { for 8bit modes : }
  writedsp($d0);
  writedsp($da);
  writedsp($d0);
{   mov   al,0d0h    call  wr_dsp
    mov   al,0dah    call  wr_dsp
    mov   al,0d0h    call  wr_dsp }
  resetblaster;
  asm
    mov   bx,1 {dma_channel}
    mov   al,bl
    out   0ah,al
  end;
end;

function readdsp:byte;
var mybase:word;
    inp:byte;
begin
{$i-}
readdsp:=0;
mybase:=base;
asm
xor cx,cx
@rep: mov dx,word ptr [mybase]
add dx,$e
in al,dx
and al,$80
jnz @okar
loop @rep
@okar:
sub dx,4
in al,dx
mov [inp],al
end;
readdsp:=inp;
end;

procedure calcrate(srate:word);
begin
{$i-}
timeconst:=256-(1000000 div srate);
end;

procedure initdma;
const dmapage:array[0..3] of byte=($87,$83,$81,$82);

begin
{$i-}
port[$a]:=4+dma;
port[$c]:=0;
port[$b]:=$48+dma;
port[dma shl 1]:=0;
port[dma shl 1]:=0;
port[(dma shl 1)+1]:=lo(dmasize-1);
port[(dma shl 1)+1]:=hi(dmasize-1);
port[dmapage[dma]]:=seg(dmabuffer^) shr 12;
port[$a]:=dma;
port[$8]:=$10;
end;

procedure restoreirq(_irq:byte);
begin
{$i-}
if _irq<8 then
begin
setintvec(_irq+8,addr(oldirq));
port[$21]:=port[$21] or (1 shl _irq);
end
else begin
setintvec(_irq+$68,addr(oldirq));
port[$a1]:=port[$a1] or (1 shl (_irq-8));
end;
end;

{$f+}

procedure myintproc;interrupt;
var s:byte;
begin
{$i-}
s:=port[base+$e];
{Prehrát dalsi!}
writedsp($d3);
writedsp($d0);
dmaplay:=false;
restoreirq(irq);
port[$20]:=$20;
port[$a0]:=$20;
end;

{$f-}

{$f+}
procedure testirq;interrupt;
var s:byte;
begin
{$i-}
s:=port[base+$e];
testflag:=true;
port[$20]:=$20;
port[$a0]:=$20;
end;
{$f-}

procedure setirq(_irq:byte;bmp:pointer);
begin
{$i-}
if _irq<8 then
begin
getintvec(_irq+8,@oldirq);
setintvec(_irq+8,bmp);
port[$21]:=port[$21] and not(1 shl _irq);
end
else begin
getintvec(_irq+$68,@oldirq);
setintvec(_irq+$68,bmp);
port[$a1]:=port[$a1] and not(1 shl (_irq-8));
end;
end;

function sbtest(var sbbase:word):boolean;
var resinit:byte;
    mybase:word;

begin
{$i-}
sbtest:=false;
mybase:=sbbase;
asm
mov cx,$100
mov dx,word ptr [mybase]
add dx,$6
mov al,1
out dx,al
@@1: nop
loop @@1
xor al,al
out dx,al
mov cx,$2000
@@2: nop
loop @@2
mov dx,word ptr [mybase]
add dx,$e
in al,dx
test al,$80
jz @retfalse
mov dx,word ptr [mybase]
add dx,$a
in al,dx
cmp al,$aa
jne @retfalse
mov byte ptr [resinit],1
jmp @absret
@retfalse:
mov byte ptr [resinit],0
@absret:
end;
if resinit=1 then sbtest:=true
else sbbase:=$ffff;
end;

function sbirq(var sirq:byte):boolean;
var howmtest:byte;
begin
{$i-}
sbirq:=false;
testflag:=false;
setirq(sirq,addr(testirq));
{Call int (5 times!):}
writedsp($d3);
writedsp($d0);
for howmtest:=1 to 5 do begin
writedsp($24);
writedsp(0);
writedsp(0);
end;

restoreirq(sirq);
if testflag then sbirq:=true
else sirq:=$ff;
end;

function getdmabuffer(memsize:word):pointer;

type tptr=record
case integer of
0: (p:pointer);
1: (ofs_,seg_:word);
end;

var dummy,result:tptr;
    a,d:longint;

begin
{$i-}
getdmabuffer:=nil;
result.p:=nil;
if maxavail<memsize then exit; 
getmem(dummy.p,memsize);
if (dummy.Ofs_<>0) or ((dummy.seg_ and $0fff)<>0) then
begin
result.seg_:=(dummy.seg_ and $8000)+$1000; 
result.ofs_:=0;
a:=16*longint(dummy.seg_)+dummy.ofs_;      
d:=16*longint(result.seg_)-a;              
freemem(dummy.p,memsize);
if maxavail<word(d) then exit;
getmem(dummy.p,word(d));
if maxavail<memsize then exit;
getmem(result.p,memsize);                  
freemem(dummy.p,word(d));                  
end else result.p:=dummy.p;
if ((result.seg_ and $0fff)<>0) or (result.ofs_<>0) then result.p:=nil;
getdmabuffer:=result.p;
end;

procedure speakeron;
begin
writedsp($d1);
end;

procedure speakeroff;
begin
writedsp($d3);
end;

procedure stopdma;
begin
{$i-}
if dmabuffer=nil then exit;
dmahalt;
dmaplay:=false;
(*writedsp($d0);*)
restoreirq(irq);
end;

procedure startdmaplaying;
begin
{$i-}
speakeroff;
stopdma;
if dmabuffer=nil then exit;
dmaplay:=true;
speakeron;
writedsp($40);
writedsp(timeconst);
initdma;
setirq(irq,addr(myintproc));
writedsp($14);
writedsp(lo(dmasize-1));
writedsp(hi(dmasize-1));
end;

procedure donedmaplaying;
begin
{$i-}
if dmabuffer=nil then exit;
freemem(dmabuffer,olddmasize);
dmaplay:=false;
speakeroff;
writedsp($d0);
restoreirq(irq);
end;

procedure restartdma;
begin
{$i-}
if dmabuffer=nil then exit;
dmaplay:=true;
writedsp($d4);
end;

procedure installdma;
begin
{$i-}
dmaplay:=false;
dmabuffer:=getdmabuffer(dmasize);
if dmabuffer=nil then exit;
olddmasize:=dmasize;
end;

procedure detectblaster;
begin
dma:=1;
cpos:=1;
repeat
base:=baseadd[cpos];
inc(cpos,1);
until (sbtest(base)) or (cpos>6);
if base=$ffff then begin
exit;
end;
cpos:=1;
repeat
irq:=irqadd[cpos];
inc(cpos,1);
until (sbirq(irq)) or (cpos>5);
writedsp($d3);
writedsp($d0);
if irq=$ff then begin
exit;
end;
end;

var px:word;

begin
  DmaBuffer:=GetDMABuffer(65530);
  assign(f,'acco.voc');
  reset(f,1);
  seek(f,0);
  dmasize:=filesize(f);
  blockread(f,dmabuffer^,filesize(f));
  close(f);
  base:=$220;irq:=5;dma:=1;
  dmahalt;
{  Detectblaster;}
  InstallDma;
  CalcRate(6000);
  StartDmaPlaying;
  repeat write('*');until dmaplay=false;
  DoneDmaPlaying;
end.