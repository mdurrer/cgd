{game maker4 --- pouze editor místností}
program GameMaker4;
uses graph256,
     mm4toget,mm4cti,mm4vyber,
     dos;

var mem,max:longint;
    x:integer;

    idx,akce:integer;
    mist:tseznammistnosti;

procedure chyba(text:string);
begin
  writeln(text,#7);
  halt(1);
end;

procedure initgrafiky;
var ret:string;
    fi:text;
begin
  ret:=jencesta(fexpand(paramstr(0)));

  assign(fi,{ret+}'mm4.cfg');
  {$i-} reset(fi); {$i+}
  if ioresult=0 then begin
    readln(fi,maskamasek);
    readln(fi,maskamap);
    readln(fi,adresarmasek);
    readln(fi,adresarmap);
    readln(fi,adresarobrazku);
    readln(fi,adresaranimaci);
    readln(fi,cestakobjektum);
    adresarmasek:=fexpand(adresarmasek);
    adresarmap:=fexpand(adresarmap);
    adresarobrazku:=fexpand(adresarobrazku);
    adresaranimaci:=fexpand(adresaranimaci);
    if (adresaranimaci<>'')and(adresaranimaci[length(adresaranimaci)]<>'\') then
      adresaranimaci:=adresaranimaci+'\';
    cestakobjektum:=fexpand(cestakobjektum);
    close(fi);
  end; {jinak se nechá default hodnota}

  if not sti(ret+'mouse.gcf',
             ret+'stand2.pal',
             ret+'stand2.fon') then
    chyba('nelze inicializovat grafiku');
  mouseon(0,0,mouseimage);
end;

procedure help;
begin
  writeln('syntax: gm4 [<soubor_s_místnostmi>, jinak `mist.''] nebo /?');
  writeln;
  writeln('Soubory s grafikou hledá v adresáři, kde je gm4');
  writeln('Soubor s místností hledá v akt. adresáři, není-li zadán');
  writeln('Soubor s konfigurací (cesty masek...) hledá v akt. adresáři');
  halt(0);
end;

begin
  mem:=memavail;
  max:=maxavail;

  if paramcount>1 then
    chyba('syntax: gm4 [<soubor_s_místnostmi>, jinak `mist.''] nebo /?');
  if paramcount=1 then
    if paramstr(1)='/?' then
      help
    else begin
      jmsoubmist:=fexpand(paramstr(1));
      jmpomsoubmist:=jencesta(jmsoubmist)+jmpomsoubmist;
    end;
  x:=ctiseznammistnosti(jmsoubmist,mist);
  if x<>0 then
    chyba('chyba v souboru se seznamem místností');

  initgrafiky;

  editujseznammistnosti(mist);

  {masky a mapy se SAVují průběžně
   a změny do datových struktur místností taky}

  dealokujseznammistnosti(mist);

  ste;

  if (mem<>memavail)or(max<>maxavail) then
    write(#7);
end.
