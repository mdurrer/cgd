program JakNaTenDialog;

uses dialog, editor, graph256, gmu;

const
    Seq_Name : string[12] = '0123456789012';
var
  Heap1, Heap2: longint;


function ReadIntegerInDialog(x, y, min, max, vstup: integer): integer;
var ed:peditor;
    cislo:integer;
    chyba:integer;
begin
  x:= x+ InfMenu[60].X;

  AlokujEditor(ed);
  NastavEdOkno(ed, {X,Y,Del}x,y, 30, {Vyzva}'',
    {font nadpisu a textu}font,font, {okno}false);
  NastavEdBarvy(ed,{bpopr:=}DColor1,{bpoz:=}DColor2,{bnadp:=}DColor3,{bkurs:=}DColor5,
    {binv:=}DColor4,{bokr:=}DColor5,{bpos:=}DColor4);
(*  NastavEdBarvy(ed,{bpopr:=}7,{bpoz:=}35,{bnadp:=}15,{bkurs:=}15,
    {binv:=}48,{bokr:=}96,{bpos:=}15); *)
{nastavit lepsi barvy, prip. to dat do globalni promenne, at se nemusi porad
 opisovat a at se mohou globalne zmenit zmenou jednoho pole a nebo to
 udelat tak, jak to maji v tv2}
  nastavedmezecisel(min,max);
  NastavEdProstredi(ed, {posuvniky}false, zadnerolovani, musibytcislo,
    {EscN:=}[#27],{EscR:=}[], {EntbN:=}[#13],{EntR:=}[]);
  NastavEdParametry(ed, {pocinv}true,{urmez}true,{prubor}false,
    {muzpres}false,{vracchyb}false,{format}false,{delka}5,
    StandardniPovZn,StandardniOddelovace);
  NastavEdObsah(ed, {edtext - viz. dale}'', {sour}1,{zacina}1);
  Str(Vstup,ed^.edtext);

  EditaceTextu(ed);
  if ed^.ukakce in [1,3] then begin     {enter znak}
    val(ed^.edtext,cislo,chyba);
    {chybu vystupniho cisla nemusime kontrolovat, to editor udela za nas}
    ReadIntegerInDialog:=cislo
  end else                              {escape znak}
    ReadIntegerInDialog:=vstup;
    {pri zmacknuti escape se vrati standardni predvolene cislo}
  DeAlokujEditor(ed)
end;

function ReadLnInDialog(x, y: integer; vstup: string): string;
var ed:peditor;
begin
  x:= x+ InfMenu[60].X;

  AlokujEditor(ed);
  NastavEdOkno(ed, {X,Y,Del}x,y, 72, {Vyzva}'',
    {font nadpisu a textu}font,font, {okno}false);
  NastavEdBarvy(ed,{bpopr:=}DColor1,{bpoz:=}DColor2,{bnadp:=}DColor3,{bkurs:=}DColor5,
    {binv:=}DColor4,{bokr:=}DColor5,{bpos:=}DColor4);
{nastavit lepsi barvy, prip. to dat do globalni promenne, at se nemusi porad
 opisovat a at se mohou globalne zmenit zmenou jednoho pole a nebo to
 udelat tak, jak to maji v tv2}
  NastavEdProstredi(ed, {posuvniky}false, zadnerolovani, musibyttext,
    {EscN:=}[#27],{EscR:=}[], {EntN:=}[#13],{EntR:=}[]);
  NastavEdParametry(ed, {pocinv}true,{urmez}true,{prubor}false,
    {muzpres}false,{vracchyb}false,{format}false,{delka}12,
    StandardniPovZn,StandardniOddelovace);
  NastavEdObsah(ed, vstup, {sour}1,{zacina}1);

  EditaceTextu(ed);
  if ed^.ukakce in [1,3] then begin     {enter znak}
    ReadLnInDialog:= ed^.edtext;
  end else                              {escape znak}
    ReadLnInDialog:= vstup;
    {pri zmacknuti escape se vrati standardni predvolene cislo}
  DeAlokujEditor(ed)
end;

procedure dialog1;
var
  dial:pdialog;
  vysl:pstav;
  ExitCode, Button: byte;
  ActPhase_s, SumPhase_s: string[2];
  Pict_s, X_s, Y_s, ZoomX_s, ZoomY_s, Sam_s, Freq_s, Delay_s: string[5];
    cisloobr: word;
begin
repeat

  alokujdialog(dial,InfMenu[60].X, InfMenu[60].Y, 150, 200,
                 DColor2, DColor4, DColor5, {pozadi, ramecek, okraj}
                 false,                 {escvenku}
                 true,                  {ramtlac}
                 false,                 {NEpresouvatelny}
                 false, false);   {nekreslit/nemazat - pro demonstraci
                                         to udelam sam}


  nastavpocty(dial,13,18,4,1,0);
{  nastavpocty(dial,0,18,0,0,0);}
{            _nap,_tlac,_check,_radio,_input }
  {pouze nastavi pocty do alokovaneho dialogu}
  nastavpocetradio(dial,1,3);
{  nastavpocetradio(dial,0,0);}

  alokujnapis(dial, 1,  6*7, 2, DColor4, font, Seq_Name);
  alokujnapis(dial, 2,  6*11, 53, DColor4, font, '00000');
  alokujnapis(dial, 3,  6*10, 65, DColor4, font, '-00000');
  alokujnapis(dial, 4,  6*10, 77, DColor4, font, '-00000');
  alokujnapis(dial, 5,  6*11, 89, DColor4, font, '00000');
  alokujnapis(dial, 6,  6*11, 101,DColor4, font, '00000');
  alokujnapis(dial, 7,  6*11, 113, DColor4, font, '00000');
  alokujnapis(dial, 8,  6*11, 125, DColor4, font, '00000');
  alokujnapis(dial, 9,  6*11, 137, DColor4, font, '00000');
  alokujnapis(dial,10,  0,46,  DColor3,  font,'-------------------------');
  alokujnapis(dial,11,  0,168, DColor3,  font,'-------------------------');
  alokujnapis(dial,12,  108, 175, DColor4, font, '00');
  alokujnapis(dial,13,  126, 175, DColor2, font, '00');

  alokujtlac(dial, 1,  8,2,   DColor1, DColor3,  font,'~Anim:');
  alokujtlac(dial, 2,  8,53,  DColor1, DColor3,  font,'~Obrázek:');
  alokujtlac(dial, 3,  8,65,  DColor1, DColor3,  font,'~X     :');
  alokujtlac(dial, 4,  8,77,  DColor1, DColor3,  font,'~Y     :');
  alokujtlac(dial, 5,  8,89,  DColor1, DColor3,  font,'ZoomX :');
  alokujtlac(dial, 6,  8,101, DColor1, DColor3,  font,'ZoomY :');
  alokujtlac(dial, 7,  8,113, DColor1, DColor3,  font,'~Sampl :');
  alokujtlac(dial, 8,  8,125, DColor1, DColor3,  font,'~Frekv.:');
  alokujtlac(dial, 9,  8,137, DColor1, DColor3,  font,'~Zdržení:');
  alokujtlac(dial,10,  8,160, DColor1, DColor3, font, ' souřad. ~myší ');
  alokujtlac(dial,11,  8,175, DColor1, DColor3, font, '<<');
  alokujtlac(dial,12,  36,175, DColor1, DColor3, font, '~<');
  alokujtlac(dial,13,  58,175, DColor1, DColor3, font, '~>');
  alokujtlac(dial,14,  80,175, DColor1, DColor3, font, '>>');
  alokujtlac(dial,15,  8,187, DColor1, DColor3, font, '~Přidej');
  alokujtlac(dial,16,  58,187, DColor1, DColor3, font, '~Vymaž');
  alokujtlac(dial,17,  129,2, DColor1, DColor3, font, 'OK');
  alokujtlac(dial,18,  108,187, DColor1, DColor3, font, ' ~Run ');
{X a Y}
{ZoomX a ZoomY}
{Sampl a frekvence}
{Zdrzeni}
{Tlacitko s nazvem animacni sekvence}
{cislo obrazku}

  alokujcheck(dial, 1, 20,14,  DColor1, DColor3, font, 'nemazat');
  alokujcheck(dial, 2, 20,26,  DColor1, DColor3, font, 'cyklická');
  alokujcheck(dial, 3, 20,38,  DColor1, DColor3, font, 'relativní');

  alokujcheck(dial, 4, 20,149, DColor1, DColor3, font, '    zrcadlit');

  alokujradio(dial, 1,1,  6*10+38,14,  DColor1, DColor3, font, 'v paměti');
  alokujradio(dial, 1,2,  6*10+38,26,  DColor1, DColor3, font, 'pam/disk');
  alokujradio(dial, 1,3,  6*10+38,38,  DColor1, DColor3, font, 'z disku');


  with dial^ do begin
    {tady, pokud to chci lepe, musim rucne nastavit sirky ramecku, aby to,
     co je pod sebou, melo i shodny ramecek}
    check[1]^.dx:=check[3]^.dx;
    check[2]^.dx:=check[3]^.dx;
    check[4]^.dy:=check[4]^.dy-1;
    radio[1].text[1]^.dx:=radio[1].text[1]^.dx-5;
    radio[1].text[2]^.dx:=radio[1].text[1]^.dx;
    radio[1].text[3]^.dx:=radio[1].text[1]^.dx;
    tlac[1]^.dx:= 36;
    tlac[15]^.dx:= 46;
    tlac[16]^.dx:= 46;
  end;

  alokujpredvoleny(vysl,1,1,1);

  pocatecnicheck(vysl,1,false);
  pocatecnicheck(vysl,2,false);
  pocatecnicheck(vysl,3,false);

  pocatecnicheck(vysl,4,false);

  pocatecniradio(vysl,1,1);


  mouseswitchoff;                       {uklid mys pro vypis}
  nakreslidialog(dial,vysl);
  vyberdialog(dial,vysl);               {on po sobe mys taky uklidi}

  with vysl^ do begin
     ExitCode:=UkAkce;
     Button:= PredvObj;
    if (UkAkce=0)or(UkAkce=2) then begin
      case PredvObj of
        1: begin
             Seq_Name:= ReadLnInDialog(42, 2, Seq_Name);
           end;
        {nazev animacni sekvence}
        2: begin
             cisloobr:= ReadIntegerInDialog(66, 53, 0, maxint, cisloobr);
           end;
           {cislo obrazku ve storu}
        3: {x};
        4: {y};
        5: {zoom x};
        6: {zoom y};
        7: {cislo samplu};
        8: {frekvence samplu};
        9: {zdrzeni};
       10: {zadani souradnic sprajtu mysi};
       11: {na zacatek sekvence};
       12: {o jednu fazi zpet};
       13: {o jednu fazi vpred};
       14: {na konec sekvence};
       15: {pridani sekvence};
       16: {vymazani sekvence};
       17: {ukonceni editace, save, navrat do menu nahoru};
       18: {spusteni sekvence};
      end;
    end;
  end;




  smazdialog(dial);

  dealokujdialog(dial, vysl);
  {dialog dealokuji az na konci pro zachovani hodnot}
until ( (ExitCode=0)or(ExitCode=2) )and(Button=17);

end;


begin

  InfMenu[60].X:=170;  { aomaker; ReadLnSeqName}
  InfMenu[60].Y:=0;
  InfMenu[60].Volba:=1;

  if not sti('e:\paint\picture\sipka.gcf','e:\paint\picture\mesto.pal','e:\user\fe\stand2.fon') then
    exit;
  initmouse;
  mouseon(3,0,mouseimage);

  Heap1:= MaxAvail;
  dialog1;
  Heap2:= MaxAvail;

  ste;

  writeln('pred:', Heap1);
  writeln('po  :', Heap2);

end.
