unit use_ems1;

interface

var handleEMS : array[1..2,1..15] of word;
    sizeEMS   : array[1..15] of word;
 {zde nastav konstantu kolik  ^^  handlu }

procedure LoadEMS(which : byte; name : string);
function GetTextEMS(which : byte; number_ : word) : string;
function GetDataEMS(which : byte; var p : pointer; number_ : word; alokmem : boolean):word;
procedure DoneEMS(which : byte);

implementation

uses texts,ems,bardfw;

procedure LoadEMS(which : byte; name : string);
var p : pointer;
    ofss : longint;
    size, i : word;
    sizee : ^longint;
begin
  if InitEMS<>0 then ErrorMessage(11);
  size:=CLoadItem(name,p,2);
  if size=0 then ErrorMessage(12);
  handleEMS[1,which]:=GetMemEMS(size div 16384+1);
  if handleEMS[1,which]=0 then ErrorMessage(13);
  if MoveEMS(handleEMS[1,which],size,0,p,false)<>0
    then ErrorMessage(14);
  freemem(p,size);
  sizeEMS[which]:=size div 4;
  i:=2;
  ofss:=0;
  CLoadItem(name,pointer(sizee),1);
  if size=0 then ErrorMessage(12);
  handleEMS[2,which]:=GetMemEMS(sizee^ div 16384+1);
  if handleEMS[2,which]=0 then ErrorMessage(13);
  while ofss<>sizee^ do begin
    inc(i);
    size:=Cloaditem(name,p,i);
    if size=0 then ErrorMessage(12{'nelze nacist file_path: '+name+' /use_ems'});
    if moveEMS(handleEMS[2,which],size,ofss,p,false)<>0
      then ErrorMessage(13);
    inc(ofss,size);
    freemem(p,size);
  end;
  freemem(sizee,sizeof(sizee^));
end;

function gettextems(which : byte; number_ : word) : string;
type tbyte = array[0..255] of byte;
     pbyte = ^tbyte;
var size1, size2 : ^longint;
    txt1 : pbyte;
begin
  new(txt1);
  new(size1);
  new(size2);
  if moveems(handleEMS[1,which],4,(number_-1)*4,size1,true)<>0
    then ErrorMessage(15);
  if moveems(handleEMS[1,which],4,number_*4,size2,true)<>0
    then ErrorMessage(16);
  if moveems(handleEMS[2,which],size2^-size1^,size1^,@txt1^[1],true)<>0
    then ErrorMessage(17);
  txt1^[0]:=size2^-size1^;
  gettextems:=string(txt1^);
  dispose(size2);
  dispose(size1);
  dispose(txt1);
end;

function GetDataEMS(which : byte; var p : pointer; number_ : word; alokmem : boolean) : word;
var size1, size2 : ^longint;
begin
  new(size1);
  new(size2);
  if moveems(handleEMS[1,which],4,(number_-1)*4,size1,true)<>0
    then ErrorMessage(15);
  if moveems(handleEMS[1,which],4,number_*4,size2,true)<>0
    then ErrorMessage(16);
  if not alokmem then GetMem(p,size2^-size1^);
  if moveems(handleEMS[2,which],size2^-size1^,size1^,p,true)<>0
    then ErrorMessage(17);
  dispose(size2);
  dispose(size1);
  GetDataEMS:=size2^-size1^;
end;


procedure doneems(which : byte);
begin
  freememems(handleems[1,which]);
  freememems(handleems[2,which]);
end;

end.
