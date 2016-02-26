unit texts;

interface

type TWhatFont= (Small, Big);
     TLineAttr= (Center, Left, Right);
const

{$ifdef CZECH}
  {$I recoded\texts-cz.pas}
{$else} {$ifdef GERMAN}
  {$I recoded\texts-de.pas}
{$else} {$ifdef POLISH}
  {$I recoded\texts-pl.pas}
{$else}
  {The default value}
  {$I recoded\texts-en.pas}
{$endif}
{$endif}
{$endif}

procedure ErrorMessage(s : word);

implementation

uses dos,crt;

procedure ErrorMessage(s : word);
var r : registers;
begin
  R.AX := LastMode;
  Intr($10, R);
  WriteLn(midi_errors[s]);
  readkey;
  halt(100);
end;

end.
