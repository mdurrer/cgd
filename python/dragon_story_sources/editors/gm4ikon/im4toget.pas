{cesty pro gm4}

unit im4toget;
interface
uses graph256;

const jmsoubmist:string='ikony.'; {standardně čte tento soubor v akt. adresáři}
      jmpomsoubmist:string='ikon.$$$';

      maska='*.gcf;*.bmp;*.pcx;*.lbm';
      adresarikon:string='';
      adresarobrazku:string='';

      dcolor:array[1..5]of byte=
        (15,7,12,10,8);
      {popr,poz,podtr,ram,okr}

var barvapozadi:byte;            {barva pozadí při výběru ikon}
    obrpal:ppalette;             {paleta pozadí}

function jencesta(ret:string):string;
function jenpripona(ret:string):string;

implementation
uses dos;

function jencesta(ret:string):string;
var d:dirstr;
    n:namestr;
    e:extstr;
begin
  fsplit(fexpand(ret),d,n,e);
  jencesta:=d;
end;

function jenpripona(ret:string):string;
var d:dirstr;
    n:namestr;
    e:extstr;
begin
  fsplit(fexpand(ret),d,n,e);
  jenpripona:=e;
end;

end.
