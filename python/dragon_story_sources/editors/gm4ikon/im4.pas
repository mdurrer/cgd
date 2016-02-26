{game maker4 --- pouze editor místností}
program GameMaker4;
uses graph256,
     im4toget,im4cti,im4vyber,
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
var
    ret:string;
    fi:text;
begin
  ret:=jencesta(fexpand(paramstr(0)));

  assign(fi,{ret+}'im4.cfg');
  {$i-} reset(fi); {$i+}
  if ioresult=0 then begin
    readln(fi,adresarikon);
    readln(fi,adresarobrazku);
    adresarikon:=fexpand(adresarikon);
    adresarobrazku:=fexpand(adresarobrazku);
    close(fi);
  end; {jinak se nechá default hodnota}


  if not sti(ret+'mouse.gcf',
             ret+'stand2.pal',
             ret+'stand2.fon') then
    chyba('nelze inicializovat grafiku');
  mouseon(0,0,mouseimage);

  mouseswitchoff;
  setactivepage(0);
  barvapozadi:=255;
  clearscr(barvapozadi);
  obrpal:=nil;
end;

procedure help;
begin
  writeln('syntax: im4 [<soubor_s_ikonami>, jinak `ikon.''] nebo /?');
  writeln;
  writeln('Soubory s grafikou hledá v adresáři, kde je im4');
  writeln('Soubor s místností hledá v akt. adresáři, není-li zadán');
  writeln('Soubor s konfigurací (cesty ikon...) hledá v akt. adresáři');
  halt(0);
end;

begin
  mem:=memavail;
  max:=maxavail;

  if paramcount>1 then
    chyba('syntax: im4 [<soubor_s_ikonami>, jinak `mist.''] nebo /?');
  if paramcount=1 then
    if paramstr(1)='/?' then
      help
    else begin
      jmsoubmist:=fexpand(paramstr(1));
      jmpomsoubmist:=jencesta(jmsoubmist)+jmpomsoubmist;
    end;

  x:=ctiseznammistnosti(jmsoubmist,mist);
  if x<>0 then
    chyba('chyba v souboru se seznamem ikon');

  initgrafiky;

  editujseznammistnosti(mist);

  {obrázky se SAVují průběžně}

  dealokujseznammistnosti(mist);

  ste;
  if obrpal<>nil then
    freemem(obrpal,768);

  if (mem<>memavail)or(max<>maxavail) then
    write(#7);
end.
