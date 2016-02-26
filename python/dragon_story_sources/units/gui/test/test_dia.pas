uses crt,graph256,dialog,editor;
var  heap1, heap2: longint;
var dial:pdialog;
    vysl:pstav;
    ed1,ed2:peditor;
    vybral,v1:integer;
    newfont:pfont;

procedure dialog1;
begin
  AlokujEditor(ed1);
  AlokujEditor(ed2);
  NastavEdOkno(ed1, 10,20,100, 'Editacni ~linka 1 :', font,font, false);
  NastavEdBarvy(ed1,7,35,15,15,48,96,15);
  nastavedmezecisel(-maxint,maxint);
  NastavEdProstredi(ed1, true, zadnerolovani, musibytcislo,
                    [],[],[],[]); {nastavi si editor sam}
  NastavEdParametry(ed1, true,true,false,{muzpresah}false,false,false,200,
                    StandardniPovZn,StandardniOddelovace);
  NastavEdObsah(ed1, '256', 5,2);
  ed2^:=ed1^;
  with ed2^ do begin
    sy:=40;
    vyzva:='Editacni l~inka 2 :';
    musiplatit:=musibyttext;
    muzepresahovat:=true;
    posuvniky:=false;
    edtext:='Dobrou noc';
    sour:=1;
    zacina:=1
  end;

  {tady laboruji s novym fontem :}
  if registerfont(newfont,'d:\pascal\animace\units\fe.fon') then
    exit;
  alokujdialog(dial,10,50,230,140,
               35,48,96,              {pozadi, ramecek, okraj}
               {-1,                    {escape}
               false,                 {escvenku}
               true,                  {ramtlac}
               true,                  {smi se presouvat}
               false,false);

{nekreslit/nemazat - !PRO! demonstraci to udelam sam !!!!!}

  nastavpocty(dial,2,2,2,2,2);
  nastavpocetradio(dial,1,2);
  nastavpocetradio(dial,2,3);

  alokujnapis(dial, 1,  80,15,  7, newfont, 'Ahoj, toto je můj 3.');
  alokujnapis(dial, 2,  50,35,  7, newfont, 'zkušební dialogový panel');

  alokujtlac(dial, 1,  40,110, 7,15, font, '<Ok>');
  alokujtlac(dial, 2, 100,120, 7,15, font, '<Vy~prdnout>');

  alokujcheck(dial, 1, 100,50,  7,15, font, 'Ček~1');
  alokujcheck(dial, 2, 100,62,  7,15, font, 'Check~2');

  alokujradio(dial, 1,1,  30,70,  7,15, font, '~Rádio');
  alokujradio(dial, 1,2,  30,82,  7,15, font, 'Gug~u');

  alokujradio(dial, 2,1, 100,80,  7,15, font, 'R~ejdijou');
  alokujradio(dial, 2,2, 100,92,  7,15, font, 'Gaga');
  alokujradio(dial, 2,3, 100,104, 7,15, font, '!!!!!!~!');

  alokujinput(dial, 1, 10,10, 15, ed1);
  alokujinput(dial, 2, 10,30, 15, ed2);

  with dial^ do begin
    {tady, pokud to chci lepe, musim rucne nastavit sirky ramecku, aby to,
     co je pod sebou, melo i shodny ramecek}
    check[1]^.dx:=check[2]^.dx;
    radio[1].text[2]^.dx:=radio[1].text[1]^.dx;
    radio[2].text[2]^.dx:=radio[2].text[1]^.dx;
    radio[2].text[3]^.dx:=radio[2].text[1]^.dx
  end;

  alokujpredvoleny(vysl,1,1,1);
  pocatecnicheck(vysl,1,false);
  pocatecnicheck(vysl,2,true);
  pocatecniradio(vysl,1,2);
  pocatecniradio(vysl,2,2);
  pocatecniinput(dial, vysl,1,ed1);
  pocatecniinput(dial, vysl,2,ed2);

{pipa to pri kliku na posuvnik u editacni linky v dialogu !!!!!!!!!!!!
 vubec to tam blbne !!!!!!!!!!!!!!
 xxxxx musim dodelat specialni pripad - klik na posuvnik

 spatne blika kursor !!!!!
 ????? nevim co

 nechce mi to zobrazovat text, kdyz na nem nejsem (myslim, ze tam je spatny
 CharsToWidth)
 xxxxx dodelano}

  mouseswitchoff;                       {uklid mys pro vypis}
  nakreslidialog(dial,vysl);
  vyberdialog(dial,vysl);               {on po sobe mys taky uklidi}
  smazdialog(dial);

  {dialog dealokuji az na konci pro zachovani hodnot}
  {tady take laboruji s novym fontem :}
  FreeMem(NewFont, NewFont^[0]*NewFont^[1]*138+140 );
  fonwidth:=font^[0];
  fonheigth:=font^[1]
  {pokud bych toto zapomel, cekalo by me prekvapeni pri spatne dealokaci
   fontu, spatnem vypoctu mezer, ale pri vypisu ne, protoze procedura
   PrintText a PrintChar si to nastesti prebira z fontu, nikoliv z techto
   pripitomelych promennych}
end;

procedure dialog2;
var dial:pdialog;
    stav:pstav;
begin
  alokujdialog(dial,40,50,240,100, 35,48,96, {2,}
    false,true,false{bez presouvani}, true,true);
  nastavpocty(dial,0,2,0,0,1);
  alokujpredvoleny(stav,4,1,1);

  alokujtlac(dial, 1, 30,80,  7,15, font, 'O~k');
  alokujtlac(dial, 2, 100,80, 7,15, font, 'Z~rušit');
  alokujpocatecni_jednoduchyinput(dial,stav, 1, 120,30,110,
    'Hledaný ~text : ', 7,15, font, musibyttext, 'Robert');

  vyberdialog(dial,stav);

  dealokujdialog(dial,stav)
end;

const menux:integer=50;
      menuy:integer=50;
      menu1x:integer=50;
      menu1y:integer=50;
begin
  heap1:= MaxAvail;
  if not sti('d:\pascal\animace\units\mouse.gcf','d:\pascal\animace\units\test.pal','d:\pascal\animace\units\stand2.fon') then
    exit;
  initmouse;
  mouseon(3,0,mouseimage);

  standardnidialog('Za chvíli bude|textový režim ~!!!~||by BBS (c) 1994',
    7,35,15,48,96, font, berunavedomi);
  vybral:=standardnidialog('Ahoj!|Ahojte!|tady Bob',
    7,35,15,48,96, font, ano_ne_zrusit);
  vybral:=vybermoznost('Ahoj!|Dobrý den!','Ok|Zrušit|~ano|n~e|~budiž',
    7,35,15,48,96, font, 3,-1);
  v1:=vytvormenu('#Vyber si :|~Soubor|~Editace|#|~Konec',
    7,35,15,48,96, font, menux,menuy,1,3);
  dialog1;
  dialog2;
  standardnidialog('prazdny|dialogovy|panel',
    7,35,15,48,96, font, upozorneni);
  vytvormenu('#Toto je|#prazdne|#menu',
    7,35,15,48,96, font, menu1x,menu1y,1,3);

  ste;
  writeln('v menu vybral polozku ',v1);
  writeln('nova pozice menu je [',menux,',',menuy,']');
  writeln;
  with vysl^ do begin
    writeln('v dialogu vybral akci ',ukakce);
    if ukakce<2
      then writeln('klavesa : ',klav)
      else writeln('mys : [',mysx,',',mysy,'] tlacitka : ',myskl);
    writeln('nova pozice dialogu je [',dial^.x,',',dial^.y,']')
  end;
  with vysl^ do
    writeln('oznaceno ',predvskup,':',predvobj,':',predvsubobj);
  write('vysledky :');

  write(#13#10'Check-boxy : ');
  for vybral:=1 to dial^.poccheck do
    write(vysl^.check[vybral],',');

  write(#13#10'Radio-boxy : ');
  for vybral:=1 to dial^.pocradio do
    write(vysl^.radio[vybral],',');

  write(#13#10'Input-boxy : ');
  for vybral:=1 to dial^.pocinput do
    write(vysl^.input[vybral]^.edtext,',');

  dealokujdialog(dial,vysl); {musim az zde, protoze z neho pisu vysledky}

  heap2:= MaxAvail;
  WriteLn(#13#10, heap1, #13#10, heap2)
end.
