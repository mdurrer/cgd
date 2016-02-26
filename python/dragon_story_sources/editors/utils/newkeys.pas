unit newkeys;

interface

procedure InitStopPause;
procedure DoneStopPause;

implementation

uses dos;

var oldkey : procedure;

{$F+}
procedure TestNewKey; interrupt;
begin
 {!!!! nekde se uvadi ze se ma cist z oprtu $61 ale dokonce nekteri kamaradi
  mirikali ze jim to nefunguje ani na jednom !!!}
  if port[$60]=29 then begin
    {zde je potreba vyslat bajt(y) prijmuti }
  end else
  if port[$60]=57 then begin
    {zde je potreba naprogramovat cekani}
  end else begin
    inline ($9C);
    OldKey;
  end;
end;
{$F-}

procedure InitStopPause;
begin
  GetIntVec($09,@OldKey);
  SetIntVec($09,@TestNewKey);
end;

procedure DoneStopPause;
begin
  SetIntVec($09,@OldKey);
end;

end.  