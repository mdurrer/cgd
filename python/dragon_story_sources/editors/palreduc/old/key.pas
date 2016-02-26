uses crt;

var key : char;

begin
  repeat
    key:=readkey;
    writeln(byte(key));
  until key=#27;
end.