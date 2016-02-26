unit together;
interface

const znaky:set of char=['a'..'z','A'..'Z','0'..'9','_'];
      cisla:set of char=['0'..'9'];

      jmsoubident='ident.';
      jmsoubprik='prik.';

procedure oriznileve(var ret:string);
procedure orizniprave(var ret:string);
procedure orizni(var ret:string);
procedure uppercase(var ret:string);
function slovo(var ret:string):string;

implementation

procedure oriznileve(var ret:string);
var i:byte;
begin
  i:=1;
  while (i<=length(ret))and(ret[i]=' ') do
    inc(i);
  delete(ret,1,i-1);
end;

procedure orizniprave(var ret:string);
begin
  while ret[byte(ret[0])]=' ' do
    dec(ret[0]);
end;

procedure orizni(var ret:string);
begin
  oriznileve(ret);
  orizniprave(ret);
end;

procedure uppercase(var ret:string);
var i:byte;
begin
  for i:=1 to length(ret) do
    ret[i]:=upcase(ret[i]);
end;

function slovo(var ret:string):string;
var i:byte;
begin
  i:=1;
  while (i<=length(ret))and(ret[i]<>' ')and(ret[i]<>#9) do
    inc(i);
  slovo:=copy(ret,1,i-1);
  while (i<=length(ret))and((ret[i]=' ')or(ret[i]=#9)) do
    inc(i);
  delete(ret,1,i-1);
end;

end.
