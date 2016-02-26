{cesty pro gm4}

unit mm4toget;
interface

const jmsoubmist:string='mist.'; {standardně čte tento soubor v akt. adresáři}
      jmpomsoubmist:string='mist.$$$';

      maskamasek:string='.msk';
      maskamap:string='.map';
      adresarmasek:string='';
      adresarmap:string='';
      adresarobrazku:string='';
      adresaranimaci:string='';
      cestakobjektum:string='objekty.';

      roztecx=4;
      roztecy=4;

type tdcolor=array[1..5]of byte;

const dcolor:tdcolor=
        (15,7,12,10,8);

function jencesta(ret:string):string;
function fsplit2(ret:string;typ:byte):string;

implementation
uses dos;

function jencesta(ret:string):string;
var d:dirstr;
    n:namestr;
    e:extstr;
begin
  fsplit(ret,d,n,e);
  jencesta:=d;
end;

function fsplit2(ret:string;typ:byte):string;
var d:dirstr;
    n:namestr;
    e:extstr;
begin
  fsplit(fexpand(ret),d,n,e);
  ret:='';
  if typ and 1<>0 then
    ret:=d;
  if typ and 2<>0 then
    ret:=ret+n;
  if typ and 4<>0 then
    ret:=ret+e;
  fsplit2:=ret;
end;

end.
