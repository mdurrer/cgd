{dodelat parametr zakazujici/povolujici presouvani/zoom panelu files

 tak mam nejak dojem, ze se mysi nedostanu na bod 0,0, ale jen kolem nej
 ????? co je to za zahada ????? ????????????????????????????????????????}

{!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     dodelat zapamatovani vsech cest a jejich opetovne obnoveni
     (nebo spis je ani nemenit a pamatovat si je vnitrne sam)
     NEBO SE NA NE UPLNE VYKASLAT, KDYZ TO TAK DELA KAZDEJ
 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     at neblbne pri 1 mechanikovem pocitaci, kdyz se chci dostat
     jak na A:, tak i na b:
 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     udelat zrychlene vyhledavani pomoci pocatecnich pismenek
     jako Alt+pismena v NC, VC a DOSM
 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     udelat kliknuti na posuvnik tak jak je v TV2 apod...
 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!}

{stand2.fon je spatne navrhnuty, na miste '~' ma ' ' a ja jsem to zrovna
 v dialogu i ve files testoval (*.~* - jako BAK soubory)}

{ani 4DOS nema doresenu sipku nahoru v menu na zacatku a strasne mu to blika,
 ja to doreseno mam (ve vyberu souboru ano, v zoomu atp... ne)}

{ani VC, NC, DOSM a 4DOS nema, ze kdyz zmenim jednotku a ona neni pripravena,
 aby te to vratilo tam, odkuds prisel - oni se te na to zeptaji
 !!!!! tak to mam udelano i ja !!!!!}

uses graph256,files;
const pozx:integer=5;
      pozy:integer=5;
      pocet:integer=17;
var vybral:string;
begin
  if not sti('d:\pascal\animace\units\mouse.gcf','d:\pascal\animace\units\test.pal','d:\pascal\animace\units\stand2.fon') then
    exit;
  mouseon(3,0,mouseimage);

  vybral:=vybersouboru(pozx,pozy,pocet,
    7,35,15,48,96, font, trid_pripony,'d:',
    {'*.bak;*.tmp;*.~*;*.$$$;*.pas;*.sha'}{''}'*.*');

  ste;
  writeln('vybral ',vybral)
end.
