{!!!!! udelat proceduru printtextpart !!!!!}

{prubezneorezavat + nesmipresahovat dela krpy end, kdyz je kursor na konci
 vsech mezer (na uplnem konci textu)}

{!!!!!!!!!!!!!!!! asi je rozdil v PrintText a PrintChar, protoze PrintText
 pri nenastavenem nic vypsal cele pismo cerne a PrintChar to naopak docela
 pekne vystinoval !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!}

{dodelat : residentni kursor, bloky, find/replace, podpora textoveho editoru
  (spojovani radku pres BackSpace apod., vyuziti mysi}

{tento editor v dobre vire ocekava, ze nahranej font neobsahuje barvu 255
 (coz je ponechani pozadi), ale je kompletne "namalovan", protoze pred
 tiskem znaku se TED jeste nemaze pozadi

 !!!!! blbost, to uz neplati !!!!!}

{rutina pro osetreni HW kursoru v grafickem rezimu :
  Zavesi se na INT8 (55ms-18*za sekundu) a bude pocitat, dokud nedojde
  k nejakemu cislu (neprimo umerne rychlosti blikani kursoru). Pote provede
  jistou akci (zobrazeni nebo zmizeni kursoru).
  Vnitrni promenne :
    zapnuto/vypnuto - pokud se to vypne, zajisti se jeste smazani kursoru
    viditelnost kursoru - zde oznacuje, zda je prave kursor ve stavu bliknuti
      nebo ve stavu zmizeni
    pozice x a y    - uzivatel bude menit pouze jejich kopie, podle kterych
      se bude tato turina ridit, protoze jinak by kursor za sebou zanechaval
      stopu
    delka x a y     - jaky obdelnik ma kursor vytnout
  Akce rutiny pri odpocitani casoveho intervalu :
    - pokud kursor je ve stavu vypnuti, aktualizuji se souradnice podle
      uzivatelem zadanych cisel, GetImagne se podklad a ulozi se tam obdelnik
      a zmeni se viditelnost kursoru
    - pokud je kursor zapnut, PutImagne se podklad a rovnez se zmeni
      viditelnost kursoru
  Zmeny pro proceduru PutPixel a ji podobne procedury :
    - pokud je kursor vypnut nebo neni viditelny, nic se nedeje
    - pokud viditelny je, tak se nic nezobrazuje na obrazovku, ale naopak se
      aktualizuje podklad ulozeny v blikaci rutine
}

program testeditoru;
uses graph256,editor;
var Edpar:PEditor;
    newfont:pfont;
begin
  if not sti('d:\pascal\animace\units\mouse.gcf','d:\pascal\animace\units\test.pal','d:\pascal\animace\units\stand2.fon') then
    exit;
  initmouse;
  mouseon(3,0,mouseimage);

  {tady laboruji s novym fontem :}
  if registerfont(newfont,'d:\pascal\animace\units\if.fon') then
    exit;

{je to vyborne, nezhrouti se to ani pri malem rozmeru presne pro 1 znak,
 zhrouti se to pouze, kdyz mu dam tak malo prostoru, ze se tam nevleze nic,
 ale to je naprosto logicke, HURA !!!!!}
  alokujeditor(edpar);
  NastavEdOkno(edpar, {X,Y,Del}50,50,192,
                        {-2 pro okraje -10 pro posuvniky =180=6bodu*30znaku}
                      {Vyzva}'Ahoj',
                      {font nadpisu a textu}font,newfont, {okno}true);
  NastavEdBarvy(edpar,{bpopr:=}7,{bpoz:=}35,{bnadp:=}15,{bkurs:=}15,
                      {binv:=}48,{bokr:=}96,{bpos:=}15);
  NastavEdMezeCisel(-maxint,maxint);
  NastavEdProstredi(edpar, {posuvniky}true, zadnerolovani, musibytcislo,
                           {EscN:=}[#27],{EscR:=}[],
                           {EntN:=}[#13],{EntR:=}[]);
  NastavEdParametry(edpar, {pocinv}true,{urmez}true,{prubor}false,
                           {muzpres}false,{vracchyb}false,{format}false,
                           {delka}30,
                             {30 znaku, abych videl, zda to nebude rolovat}
                           StandardniPovZn,StandardniOddelovace);
{zatim to tozi trochu blbne s tim kursorem na poslednim znaku, ale doopravdy
 uz za koncem povolene delky, protoze to roluje a nezobrazuji se na nem
 znaky, ale prazdny text, teprve kursor to odblika do O.K.}
  NastavEdObsah(edpar, {edtext}'Dobrý den !!!', {sour}1,{zacina}1);

  editacetextu(edpar);
{  vykreslenieditoru(edpar,edpar^.pocatecniinverze);
  readln;}

  {tady take laboruji s novym fontem :}
  FreeMem(NewFont, NewFont^[0]*NewFont^[1]*138+140 );
  fonwidth:=font^[0];
  fonheigth:=font^[1];

  ste;
  with edpar^ do begin
    writeln('napsal ',edtext);
    writeln('pozice [zac:',zacina,',sour:',sour,']');
    writeln('ukoncujici akce ',ukakce);
    if ((ukakce and $02)=0) or (ukakce>=4) {chyba se udela jenom klavesou}
      then writeln('klavesou ',klav)                            {klavesnice}
      else writeln('mysi [',mysx,',',mysy,',',myskl,']')        {mys}
  end;
  dealokujeditor(edpar)
end.
