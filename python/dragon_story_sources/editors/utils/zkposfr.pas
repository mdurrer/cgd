program Zkouska;

uses crt, extended;

var
  retezec: string;
  posinstring, lines: byte;
begin
  clrscr;
  retezec:='123456|89|1234567|9';
{  retezec:='12345678901234567|9';}
  retezec:= 'Ahoj|blbecku, co|tak| cumis?';
  WriteLn( PosFrom(retezec, '|', 1 ) );

  PosInString:= 0;
  Lines:= 0;
  repeat begin
    PosInString:= PosFrom(retezec, '|', PosInString+1);
    Inc(Lines);
  end until PosInString=Length(retezec){0};
  {v  LastSprite  mame nyni pocet radek}
  WriteLn(Lines);


  readln;
end.
