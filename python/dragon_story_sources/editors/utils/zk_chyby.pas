program Zkouska_chyby_Pascalu;

uses crt;

type
  TWordArray = array[0..32000] of word;
  PWordArray = ^TWordArray;
  TZkusRecord= record
    Blbost: byte;
    JinaBlbost: word;
    PolePointeru: array[0..255] of pointer;
  end;
  PZkusRecord= ^TZkusRecord;
var
  PoleZaznamu: array[0..255]of PZkusRecord;
  ZkusebniPointer: pointer;

begin
  ClrScr;
  GetMem(PoleZaznamu[0], 7);

  GetMem(ZkusebniPointer, 4);

  PWordArray(ZkusebniPointer)^[0]:=1;
  PWordArray(ZkusebniPointer)^[1]:=256;

  WriteLn('PWordArray(ZkusebniPointer)^[0]=', PWordArray(ZkusebniPointer)^[0]);
  WriteLn('PWordArray(ZkusebniPointer)^[1]=', PWordArray(ZkusebniPointer)^[1]);

  PoleZaznamu[0]^.PolePointeru[0]:=ZkusebniPointer;

  WriteLn('PoleZaznamu[0]^.PolePointeru[0]:=ZkusebniPointer');

  WriteLn('PWordArray(ZkusebniPointer)^[0]=', PWordArray(ZkusebniPointer)^[0]);
  WriteLn('PWordArray(ZkusebniPointer)^[1]=', PWordArray(ZkusebniPointer)^[1]);
  WriteLn('PWordArray(PoleZaznamu[0]^.PolePointeru[0])^[0]=', PWordArray(PoleZaznamu[0]^.PolePointeru[0])^[0]);
  WriteLn('PWordArray(PoleZaznamu[0]^.PolePointeru[0])^[1]=', PWordArray(PoleZaznamu[0]^.PolePointeru[0])^[1]);
  ReadLn;
end.
