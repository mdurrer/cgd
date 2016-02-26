  {Toto bylo u procedure VyberNoveMasky ale me to tom prekazelo!!}
{    byaska je charakterizovana takto :
    255=neni tam zadna maska
    jinak oznacuje :
      1) id.c., podle ktereho se body masky sdruzuji do objektu
      2) index do tabulky barev masek
      3) dolni pozici objektu (je-li panacek vyse, vykresluje se driv on,
         jinak maska)
    ===> barvy masek nejsou rozdelovany spojite a pokud uzivatel klikne
         pri vyberu nove masky na stejny spodni bod, jako nekdy drive,
         je masce prirazeno take stejne cislo a je to tedy jedna jedina
         maska (ale to nevadi, je to logicke a vlastnost spodniho bodu neni
         porusena)}

{at makeobj vykresli na zacatku masku}

{vymyslet lepsi nazev pro "Zpet"}

{prave tlacitko pri vyberu barvy to zhrouti
 xxxxx dodelano, ale prozkouset}

{readcolor : kliknuti na ramecek at negenruje vyber barvy
 makeobj : at jsou standardizovany procedury novy filtr/stary filtr, jina
           barva atp... (na zpusob ovladani a cekani na klavesu)
 dialog : chytra prace s PPP, atp...}

{!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! dodelat !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 moznost fileni podle barvy (na zadane barve, krome barvy pozadi,
 bere/nebere v uvahu existujici filtry atp...), aby se mohlo EditMask
 pouzit i pro vyber oblasti v animacni rutine ===> dodelat i ramecek, ktery
 je presne tak velky, jak je potreba
 !!!!!!!!!!!!!!!!!!
 mozna udelat stetec kulaty
 a tak jak je ramecek, tak udelat i volbu vyplneny ramecek, ktera se chova
 uplne stejne jako normalni ramecek, jen je vyplneny jako u kresleni
 stetcem !!!!!!!!!!}

{!!!!!!!!!!!!!!!! funguje MouseInt i v pripade prestaveni setactivepage ?
 asi ne, protoze pouziva putimage a getimage
 ani nemuze, protoze visualpage se da jenom nastavit (nikoliv cist)
 a proto se musi obracet na activepage
 ALE mozna ze ano, presetrit !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!}

{dodelat polozku v menu TestChuze, kde si uzivatel zkusi hledat nejvhodnejsi
 drahy chuze (jen ukazkova serepeticka, s editaci nema nic spolecneho)
 dilema : kreslit mapu chuze, nebo animovat chuzi, nebo vybirat z obou
          moznosti ?????
 dodelat do editoru mapy zadani roztece !!!!! tj. moznost zmenit roztec
 z [2,2] na [3,3], pricemz se stara mapa nezmeni, ale prepocita lin. alg.

 dodelat, ze circle a ellipse nevystoupi z obrazku, protoze obrazek muze byt
 a) mensi nez obrazovka, pak se to musi oriznout nebo b) se to omylem
 dostane do dalsi videostranky ===> ZMENIT (!!!!!) i proc. circle a ellipse
 a putpixel, aby to orezaval !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

 je o.k. logika vyplnovaci rutiny ????? (ma se vyplnovat posle hranice
 vyplnovaci barvy nebo pouze tu barvu, na ktere se to odehrava ?????)

 proc je vsude misto [sirka,vyska] dano [320,vyska] ???????????????

 proc nedela PopMouse i NewMouseArea ?????!!!!!!!!!!!!!!!!!!!!!!!!?????
 myslim, ze to driver neumoznuje
 ale je to strasne potreba !!!!!!!!!!!!!!!!!!!!!!!!!!!!!

 nemel by byt stetec kulaty ?????

 at mys zajizdi jen tam, kam ma !!!!! (newmousexy)}

{DrawMask: mozna udelat, ze misto [di] a [si] se muze dat [di]
                a [di+48000] !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!}

{pozn. ukoncovaci akce jsou velmi rozmanite (prav+leve, prostredni, prave
       atp..., podle toho, jak se mi to hodi ===> je to velmi nejednoznacne;
       ale obecny recept je vzdy asi takovyto : pustit vsechny klavesy mysi
       a zmacknout prave a pak leve nebo zmacknout jen prostredni
 VYLEPSIT !!!!!!!!!!!!!!!
 hotovo !!!!!!!!!!!!!!!!!!!!!!!! (je to vzdy prostredni a prave+leve, pouze
   v line jsou nejak problemy}

(*      InputHWXorBar(X,Y,DX,DY,255{ColorMask^[AktBarva]}); *)
{je absolutne nepouzitelny, misto nej davam cyklus - on totiz nemuze
 vedet, v jakem pracuji prostredi (co je na zacatku zmacknuto, ma-li se
 koncit pri pusteni tlacitek ci rpi jejich zmacknuti atp...)}

{!!!!!!!! nemela by anim. rut. pocitat s ruznou velik. a pozici pozadi ?
 takto predpokl. [0,0,320,200] a obr. se musi zariznout !!!!!
 na disku to sice nevadi (je tam archivni komprese) ale v pameti to zabere
 pri malem pozadi o dost vice a to je dulezitejsi !!!!!}

{animacni rutina spolupracuje s mysi (aby ji nemusela vypinat); co takhle
 to dodelat i do vsech ostatnich rutin (jako vylitelny par. kvuli zpomaleni)
 - line, putpixel, putimage atp...
 co takhle dodelat i residentni kursor a s nim by spolupracovaly taky ?????}

{nejak sdelovat, co se aktualne kresli (na pocatku je gumovani, jindy to
 muze byt kresleni masky cislo XY.... (ve verzi 2 uz budou masky snad
 i pojmenovany)}

unit MakeObj;



interface
uses GMU3; {kvuli promennym barev (z CFG filu, nebo standardni atp...)}

type TColorMask = array[byte] of byte;

     pvypln=^tvypln;
     tvypln=array[0..3,0..3]of byte;

const standvypln : array[0..12] of tvypln=
     (((1,1,1,1),(1,1,1,1),(1,1,1,1),(1,1,1,1)),
      ((1,1,1,1),(1,0,0,0),(1,0,0,0),(1,0,0,0)),
      ((0,1,0,0),(1,0,0,0),(0,0,0,1),(0,0,1,0)),
      ((0,0,1,0),(0,0,0,1),(1,0,0,0),(0,1,0,0)),
      ((0,0,1,0),(0,1,0,1),(1,0,0,0),(0,1,0,1)),
      ((1,0,1,0),(0,1,0,1),(1,0,1,0),(0,1,0,1)),
      ((1,1,1,1),(1,0,1,0),(1,1,1,1),(1,0,1,0)),
      ((1,1,0,0),(1,1,0,0),(0,0,0,0),(0,0,0,0)),
      ((1,0,1,0),(1,0,1,0),(1,0,1,0),(1,0,1,0)),
      ((1,1,0,0),(1,1,0,0),(1,1,0,0),(1,1,0,0)),
      ((1,1,1,0),(1,1,1,0),(1,1,1,0),(1,1,1,0)),
      ((1,0,0,0),(1,0,0,0),(1,0,0,0),(1,0,0,0)),
      ((1,1,1,1),(1,1,1,1),(1,1,1,1),(1,1,1,0)));
      {+ dodelat jejich vodorovne ekvivalenty}

var ColorMask : ^TColorMask;     {barvy masek ruznych objektu}
    ColorGoMap : byte;           {barva mapy pozadi}
    {globalni promenne <=== pouziti v GM}
    {samotna maska je ulozen v 3. brovine a mapa v dyn. promenne}

procedure ChooseImageSize(var obr:pointer; Sirka,Vyska:integer);
{zarovna obrazek na velikost [sirka,vyska]}

{zpracovani masky zacina vzdy od 0 - rozhodujici je pouze rozmer x a y}
procedure NewMask(Obr:pointer);
  {alokace pole colorMask a vycisteni 3. vstranky barvou 255
   obrazek zacina od [0,0] a je nastavitelne dlouhy}
procedure DisposeMask;
  {dealokace pole colorMask}
procedure DrawMask(_px,_py,_dx,_dy:integer; vzorek:boolean; vypln:pvypln);
  {vykresleni masky z 3. do 0. vstranky (respektuje barvy)
   od [px,py], delka [x,y], vzorek (ano/ne) a jeho tvar}
procedure EditMask(Obr:pointer);
  {edituje masku v 3. vstrance
   obr. zac. od [0,0] a je nastavitelne dlouhy}

function NewMap(obr:pointer; roztecx,roztecy:integer; var map:pointer):word;
  {alokace mapy chuze pro dany obrazek s rozteci bodu roztec(x/y)}
function GetSizeMap(map : pointer) : word;
  {varati velikost pameti predelene prom. MAP }
procedure DisposeMap(var map : pointer);
  {dealokace dane mapy chuze}
procedure DrawMap(_px,_py,_x,_y,_dx,_dy:integer;map:pointer);
  {vykresleni dane mapy chuze
   repektuje roztece a barvy, kresli od [_x,_y], delka [_dx,_dy]
   cely obrazek se posune o [_px,_py] (objekty v GM)}
procedure EditMap(_px,_py:integer; obr : pointer; var map : pointer);
  {editace dane mapy chuze k danemu obrazku
  obr. zac. od [_px,_py] a je rovnez nastavitelne dlouhy}



implementation
uses graph256,dialog,users{,TestGo};



procedure ChooseImageSize(var obr:pointer; Sirka,Vyska:integer);
{pouziva se pro zarovnani obrazku na pozadi obrazovky hry : obrazek totiz
 musi mit sirku 320 (ja davam radsi Sirka) a vysku NewDelka
 sirku i vysku procedura umozni nastavit takto :
   - pokud je dany rozmer nizsi, umozni pojizdet od jednoho okraje obrazovky
     k druhemu okraji
   - pokud je rozmer vyssi, uzivatel naopak pojizdi vyrezem od jednoho
     okraje obrazku k druhemu
 oriznuty obrazek procedura vrati zpet do (vstupne/vystupniho) ukazatele
   (realokuje se a obsah se upravi na vybrany vyrez obrazku)
 + procedura PUTne upraveny obrazek na obrazovku}
var X,Y,XMax,YMax,XPut,YPut : integer;
begin
  XMax:=Sirka-pwordarray(obr)^[0];
  YMax:=Vyska-pwordarray(obr)^[1];
  X:=0;
  Y:=0;
  if (XMax=0)and(YMax=0) then begin
    SetActivePage(0);
    SetVisualPage(0);
    PopMouse;
    Exit;
  end;
    {obrazek o presne velikosti ===> neni co nastavovat}
  PushMouse;
  MouseSwitchOff;
  SetActivePage(1);
  SetVisualPage(1);
  NewMouseArea(0,0,Abs(XMax)+1,Abs(YMax)+1);
  NewMouseXY(0,0);
  repeat until MouseKey=0;

  repeat
    if (XMax>0)or(YMax>0) then
      Bar(0,0,Sirka,Vyska,0);
{mozna dodelat nemazani cele obrazovky !!!!!}
      {stoji-li za to mazat pozadi (nektery z rozmeru obrazku je mensi nez
       odpovidajici rozmer obrazovky, smaz obrazovku
       ===> posunovani (blikani) je postrehnutelne pouze pri umistovani
            nekterym rozmerem mensiho obrazku
       mazu celou obrazovku, protoze kdybych se obracel na velikosti obrazku,
       bylo by to rychlejsi napr. mouse.gcf, ale pri v 1 rozmeru vetsim
       obrazku by to mazalo i mimo obrazovku a musela by tam byt vyhybka;
       nehlede an to, ze stara pozice obrazku uz se prepsalo pozici novou}
    if XMax>0
      then XPut:=X
      else XPut:=-X;
    if YMax>0
      then YPut:=Y
      else YPut:=-Y;
    {uprava typu pohybu podle toho, zda v danem smeru je obrazek kratsi nebo
     delsi nez obrazovka (zda pojizdi obrazek po obrazovce nebo obrazovka po
     obrazku)}
    PutImagePart(XPut,YPut,0,0,Sirka,Vyska,obr);
    {vykresleni posunovaneho obrazku}
    repeat until (MouseX<>X)or(MouseY<>Y)or(MouseKey<>0);
    X:=MouseX;
    Y:=MouseY
  until MouseKey<>0;
  {konec pri stisknute nejake klavese mysi}
  repeat until MouseKey=0;

  DisposeImage(obr);
  NewImage(Sirka,Vyska,Obr);
  GetImage(0,0,Sirka,Vyska,Obr);
  NewMouseArea(0,0,320,200);
  {realokace obrazku}
  SetActivePage(0);
  SetVisualPage(0);
  PopMouse
end;



procedure NewMask(Obr:pointer);
{pouze inicializuje "paletu" pro barvy, doopravdy je maska ulozen ve
 3. videostrance - ten vycisti barvou 255
 255 je tam proto, ze takova y-pozice nikdy v obrazovce nebude (max. je
 200 prip. 240); proto tam neni 0}
var i : byte;
begin
  SetActivePage(3);
  Bar(0,0,pwordarray(obr)^[0],pwordarray(obr)^[1],255);
  SetActivePage(0);
  {cistka}
  GetMem(ColorMask,SizeOf(ColorMask^));
  for i:=0 to 255 do
    ColorMask^[i]:=i
    {vyplni poc. barvy jednotl. masek podle jejich zacatecni pozice}

{Lukas tady mel pro 255: 1 a pro 0:255
 nevim proc, smysl vidim jen v tom, ze pri mazani gumou (255) ma ramecek
 jistou barvu, ale tu 0 nechapu opravdu
 ???????????????????????????????????????????????????????????????????????}

end;

procedure DisposeMask;
{opak NewMask, viz. v nem}
begin
  FreeMem(ColorMask,SizeOf(ColorMask^))
end;

procedure DrawMask(_px,_py,_dx,_dy:integer; vzorek:boolean;
                          vypln:pvypln); assembler;
{vykresleni masky}
var fromx,tox,zacx,delx,pocx,pocy:integer;
asm
  {!!!!! setactivepage nemenim, zajistuji si to sam
       a setvisualpage taky ne, protoze to neni potreba;
   je uzivatelova vec, na co si to prepne, me to nezajima !!!!!}
  push ax
  push bx
  push cx
  push dx
  push si
  push di
  push ds
  push es

  cmp      _px, 0
  jl       @konec
  cmp      _py, 0
  jl       @konec
  cmp      _dx, 0
  jle      @konec
  cmp      _dy, 0
  jle      @konec
  {program predpoklada kladna cisla, aby na to mohl spolehat
   mohl bych sice chybne souradnice opravit, ale skoda casu, neni
   to k nicemu, opravi to programator}
{mozna to udelat !!!!!}

  mov      ax,_px
  and      ax,3
  mov      fromx,ax
  mov      bx,_dx
  and      bx,3
  add      bx,ax
  dec      bx
  and      bx, 3
  mov      tox,bx

  mov      cx, _px      {zacatek vykreslovani, zaokrouhleno dolu}
  shr      cx, 2
  mov      zacx, cx
  mov      dx, _dx      {delka prostredku vykreslovani krome 1.
                         a posledniho bajtu v bitovych rovinach}
  sub      dx, 4
  add      dx, fromx
  sub      dx, tox
  cmp      dx, 0        {osetri zaporna cisla}
  jl       @zaporne
  shr      dx, 2        {normalni delka}
  jmp      @nastavvram
@zaporne:
  mov      dx,-1        {zaporna delka nastane pouze pri obrazku x<4, ktery
                         se vleze do 1 bajtu (kvuli bitovym rovinam)}
@nastavvram:
  mov      delx, dx     {zapamatuj si delku}

  mov      ax, 0A000h {vram}
  mov      es, ax
  {ds musime bohuzel ponechat kvuli colorMask - nemuzeme ho obetovat pro
   lodsb a stosb z vram do vram - pak bychom to meli elegantnejsi}
  mov      bx, word ptr colorMask
  mov      ds, word ptr colorMask+2

  xor      cx, cx {0. bitova rovina}
@dalsi_rovina:
  mov     ah, 1   {nastav vstranku}
  shl     ah, cl
  mov     dx, 3C4h
  mov     al, 2
  out     dx, al
  inc     dx
  mov     al, ah
  out     dx, al
  mov     dx, 3CEh
  mov     al, 4
  out     dx, ax
  inc     dx
  mov     al, cl
  out     dx, al

  push    cx            {uchovej cislo roviny}
  mov     ax, _py       {vypocitej si pocatecni pozici (Y modulo 4)*4}
  mov     pocy, ax
  and     pocy, 3
  shl     pocy, 2
  mov     pocx, cx      {dej do pocatecni pozice X cislo roviny}
  mov     ax, 80        {do 0. vstranky, vypocitej pocatecni radek}
  mul     _py
  mov     di, ax        {pocatecni sloupec}
  mov     ax, zacx
  mov     dx, delx
  cmp     cx, fromx     {pocatecni bitova rovina}
  jge     @neposouvat
  inc     ax
  dec     dx
@neposouvat:
  inc     dx
  add     di, ax
  cmp     cx, tox       {koncova bitova rovina}
  jg      @nenatahovat
  inc     dx
@nenatahovat:

  mov     si, di        {z  3. vstranky}
  add     si, 16000*3
  mov     cx, _dy    {kolik radku}
@sloupec:
  cmp     cx, 0      {uz 0 radku ? ===> konec}
  jle     @konecsloupcu
  push    cx         {uchovej si cislo radku, ukazatel na nej a radek%4}
  push    di
  push    pocy
  mov     cx, dx     {vezmi si pocet sloupcu}
@bod:
  cmp     cx, 0      {uz 0 bodu ? ===> konec}
  jle     @konecbodu
  push    ds         {uchovej}
  push    bx
  mov     al,es:[si] {nacist, bozuzel lodsb nejde ted pouzit (malo seg.reg.)}
  cmp     al, 255    {barva ?}
  je      @nemenit
  xlat               {zamenit - ds a bx se zatim nezmenilo}
  cmp     vzorek,0   {nema se kreslit vzorek ale vypln ?}
  je      @kreslit
  mov     bx, word ptr vypln   {mrkni se na vzorek}
  mov     ds, word ptr vypln+2
  add     bx, pocy
  add     bx, pocx
  cmp     byte ptr ds:[bx],0   {ne, nekreslit}
  je      @nemenit
@kreslit:
  mov     es:[di],al {zapsat, stosb posouva di a to nechci}
@nemenit:
  pop     bx         {obnov}
  pop     ds
  {pocitadlo x se nezvetsuje, zavisi pouze na cisle roviny}
  inc     si         {zvys ukazatele do vram}
  inc     di
  dec     cx         {sniz pocet bodu}
  jmp     @bod       {a skoc na dalsi bod}
@konecbodu:
  pop     ax         {obnov pocatecni sloupec}
  add     ax, 4      {zvys pocitadlo radku o 1 modulo 4 *4}
  and     ax, 12
  mov     pocy, ax
  pop     di         {dej dalsi radek}
  add     di, 80
  mov     si,di      {presun i 2. ukazatel}
  add     si,16000*3
  pop     cx         {vem cislo sloupce}
  dec     cx         {sniz ho o 1}
  jmp     @sloupec   {a skoc na dalsi sloupec}

@konecsloupcu:
  pop     cx         {vem cislo roviny}
  inc     cx
  cmp     cx,4       {posledni ?}
  jne     @dalsi_rovina

  {nyni jsme premistili veskerou masku}
@konec:
  pop es             {ok, konec}
  pop ds
  pop di
  pop si
  pop dx
  pop cx
  pop bx
  pop ax
end;

procedure EditMask(Obr : pointer);
{editace mesky}
var AktBarva:byte;           {kreslici barva}
    Vyber:integer;           {vybrana polozka v menu}
    Sirka, Vyska : word;     {sirka a vyska edit. obr.}
    VelX, VelY : integer;    {sirka a vyska kresliciho sloupce}
    UchovPoz:pointer;        {puvodni pozadi pod editorem}
    Barvyyyy:TStencilColor;

  procedure VykresliMasku(X,Y,Sirka,Vyska:integer);
  {vykresli masku v zadanem rozmezi}
  begin
    DrawMask(x,y,sirka,vyska,false,nil)
  end;

  {nasleduji kreslici procedury, ktere predpokladaji toto :
    - predpokladaji viditelnou mys, ale nevraceji ji
    - NewMouseArea nastaveno na velikost obrazku, ale nevraceji ho
    - predpokladaji uvolnene klavesy mysi, ale po sobe na uvolneni
      vsech klaves necekaji
    - ocekavaji konzistentni obsah 0. a 3. videostranky, provedou
      editacni zmeny a zarucuji, ze obsah zustane konzistentni i nadale}

  procedure KresliStetcem;
  var MysX, MysY, MysK : integer;

  procedure BarMask(X,Y,Sirka1,Vyska1:integer);
  {udela stetcem vyplneny obdelnik do masky}
  var i1,i2 : word;
      co : byte;
  begin
    setactivepage(3);
    {bar(x,y,sirka,vyska,AktBarva);}
    for i1:=x to sirka1+x-1 do for i2:=y to vyska1+y-1 do begin
      co:=PByteArray(obr)^[3+i1*Vyska+i2+1];
      if (barvyyyy[co]=0) then PutPixel(i1,i2,aktbarva);
    end;
    setactivepage(0)
  end;
  procedure MyRutine(X,Y,Sirka1,Vyska1:integer;colorrrr:byte);
  {udela stetcem vyplneny obdelnik do masky}
  var i1,i2 : word;
      co : byte;
  begin
    for i1:=x to sirka1+x-1 do for i2:=y to vyska1+y-1 do begin
      co:=PByteArray(obr)^[3+i1*Vyska+i2+1];
      if (barvyyyy[co]=0) then PutPixel(i1,i2,colorrrr);
    end;
  end;
  begin
    MouseSwitchOff;
    NewMouseArea(0,0,Sirka-VelX+1,Vyska-VelY+1);
    {priprav mys}
    repeat
    {cyklus porad presouva obdelnik, dokud neni nic zmacknuto;
     az se neco zmackne, vyvola se cyklus, ktery to osetri a pri
     pusteni klavesy se opet navrati rizeni tomuto cyklu}
      MysX:=MouseX;
      MysY:=MouseY;
      Bar(MysX,MysY,VelX,VelY,ColorMask^[AktBarva]);
      {vykresli obdelnik}
      repeat
      until (MouseX<>MysX)or(MouseY<>MysY)or(MouseKey<>0);
      {pocka na udalost}
      PutImagePart(0,0,MysX,MysY,VelX,VelY,obr);
      VykresliMasku(MysX,MysY,VelX,VelY);
      {obdelnik smaze}
      MysX:=MouseX;
      MysY:=MouseY;
      MysK:=MouseKey;
      {nastavi nove souradnice}
      if MysK=0 then
        continue;
        {pouze pohyb, nic}
      if MysK=1 then begin
      {levy = pridavani/mazani masky}
        repeat
          {Bar(MysX,MysY,VelX,VelY,ColorMask^[AktBarva]);}
          MyRutine(MysX,MysY,VelX,VelY,ColorMask^[AktBarva]);
          {nakresli ramecek}
          repeat
          until (MouseX<>MysX)or(MouseY<>MysY)or(MouseKey<>1);
          {cekej na udalost a to, co je PUTle, nech tam}
          BarMask(MysX,MysY,VelX,VelY);
          {dej novou masku}
          if AktBarva=255then
            PutImagePart(0,0,MysX,MysY,VelX,VelY,obr);
            {pri mazani gumou se jeste musi obnovit podklad}
          MysX:=MouseX;
          MysY:=MouseY;
          MysK:=MouseKey
          {zmen souradnice mysi}
        until MysK<>1;
        {dokud se nezmeni stav tlacitek mysi}
        if MysK=0 then
          continue;
          {pusteni tlacitka ===> pokracujeme}
        break
        {jinak se zmackne do toho dalsi tlacitko, treba prave ===> konec}
      end;
      if MysK<>2 then
        Break;
        {prostredni tlacitko ===> konec}
      {jinak je to prave tlacitko a to znamena presouvani praveho dolniho
       rohu (zoom stetce)}
      NewMouseArea(MysX,MysY,Sirka-MysX,Vyska-MysY);
      NewMouseXY(MysX+VelX-1,MysY+VelY-1);
      repeat
        Bar(MysX,MysY,VelX,VelY,ColorMask^[AktBarva]);
        {zobraz novou velikost obdelniku}
        repeat
        until (MouseX<>MysX+VelX-1)or(MouseY<>MysY+VelY-1)or(MouseKey<>MysK);
        {cekej na udalost}
        PutImagePart(0,0,MysX,MysY,VelX,VelY,obr);
        VykresliMasku(MysX,MysY,VelX,VelY);
        {obnov podklad}
        VelX:=MouseX-MysX+1;
        VelY:=MouseY-MysY+1
        {nastav novou velikost obdelniku}
      until MouseKey<>MysK;
      {az do zmeny stavu tlacitek}
      NewMouseXY(MysX,MysY);
      NewMouseArea(0,0,Sirka-VelX+1,Vyska-VelY+1);
      {nastav puvodni stav mysi}
      if MouseKey=0 then
        continue;
        {pusteni tlacitka ===> pokracujeme}
      break
      {jinak se zmackne do toho dalsi tlacitko, treba leve ===> konec}
    until false
    {vyskoci se prikazem Break pri stisku praveho a potom (pritom) i leveho
     nebo prostredniho tlacitka nebo naopak}
  end;

  procedure KresliObdelniky;
  var X,Y,DX,DY:integer;

  procedure RectangleMask(X,Y,Sirka,Vyska:integer);
  {udela stetcem nevyplneny obdelnik do masky}
  begin
    setactivepage(3);
    rectangle(x,y,sirka,vyska,AktBarva);
    setactivepage(0)
  end;

  begin
    repeat
      NewMouseArea(0,0,Sirka,Vyska);
      MouseSwitchOn;
      repeat
      until MouseKey<>0;
      MouseSwitchOff;
      if MouseKey<>1 then
        break;
      X:=MouseX;
      Y:=MouseY;
      NewMouseArea(X,Y,Sirka-X,Vyska-Y);
      repeat
        DX:=MouseX-X+1;
        DY:=MouseY-Y+1;
        XorRectangle(X, Y, DX, DY, 255);
        MouseSwitchOn;
        repeat
        until (MouseX-X+1<>DX)or(MouseY-Y+1<>DY)or(MouseKey<>1);
        MouseSwitchOff;
        XorRectangle(X, Y, DX, DY, 255)
      until MouseKey<>1;
      if MouseKey<>0 then
        Break;
      rectangleMask(x,y,dx,dy);
      if AktBarva=255 then begin {guma}
        putimagepart(0,0,x,y,dx,dy,obr);
        vykreslimasku(x,y,dx,dy)
      end else                   {stetec}
        rectangle(x,y,dx,dy,colorMask^[AktBarva])
    until false
  end;

  procedure KresliUsecky;
  var PoslX1,PoslY1,PoslX2,PoslY2:integer;

  procedure DrawLine(x1,y1,x2,y2:integer);
  {vykresli usecku do masky}
  var pom:integer;
  begin
    setactivepage(3);
    line(x1,y1,x2,y2,AktBarva);
    setactivepage(0);
    if AktBarva=255 then begin
      if x2<x1 then begin pom:=x2; x2:=x1; x1:=pom end;
      if y2<y1 then begin pom:=y2; y2:=y1; y1:=pom end;
      {abychom usporadali souradnice, usecka muze na rozdil od obdelniku
       atp... jit v kteremkoliv kvadrantu v jakemkoliv uhlu}
      putimagepart(0,0,x1,y1,x2-x1+1,y2-y1+1,obr);
      vykreslimasku(x1,y1,x2-x1+1,y2-y1+1)
    end else
      line(x1,y1,x2,y2,colorMask^[AktBarva]);
  end;

  begin
    repeat
      MouseSwitchOn;
      repeat until MouseKey<>0;
      if not(MouseKey in [1,2]) then
        break;
      if MouseKey=1 then begin
      {pri zmacknuti leveho tlacitka se taha gumova cara}
        PoslX1:=MouseX;
        PoslY1:=MouseY;
        PoslX2:=MouseX;
        PoslY2:=MouseY;
        MouseSwitchOff;
        repeat
          XorLine(PoslX1,PoslY1,PoslX2,PoslY2,255);
          MouseSwitchOn;
          repeat
          until (MouseX<>PoslX2)or(MouseY<>PoslY2)or(MouseKey<>1);
          MouseSwitchOff;
          XorLine(PoslX1,PoslY1,PoslX2,PoslY2,255);
          PoslX2:=MouseX;
          PoslY2:=MouseY
        until MouseKey<>1;
        if MouseKey<>0 then
          break;
        DrawLine(PoslX1,PoslY1,PoslX2,PoslY2);
        continue
      end;
      {jinak je zmacknuto prave tlacitko, taha se polygon, dokud se
       nezmackne jine tlacitko nez prave}
      repeat
      until MouseKey<>2;
      {ceka na odmacknuti tlacitka}
      if MouseKey<>0 then
        break;
        {konec kresleni usecek/car pri jinem tlacitku}
      repeat
        PoslX1:=MouseX;
        PoslY1:=MouseY;
        PoslX2:=MouseX;
        PoslY2:=MouseY;
        MouseSwitchOff;
        repeat
          XorLine(PoslX1,PoslY1,PoslX2,PoslY2,255);
          MouseSwitchOn;
          repeat
          until (MouseX<>PoslX2)or(MouseY<>PoslY2)or(MouseKey<>0);
          MouseSwitchOff;
          XorLine(PoslX1,PoslY1,PoslX2,PoslY2,255);
          PoslX2:=MouseX;
          PoslY2:=MouseY
        until MouseKey<>0;
        if MouseKey=2 then begin
{tady to mozna nechce nakreslit caru pri R a pak L, ale co na tom; pokud to
 prehodim s cekanim na dalsi akci mysi, tak po dobu drzeni tlacitka vsechno
 zmizi a je to hnusny; tato akce ma vyhodu aspon v tom, ze se vyskoci
 z procedury
 kombinace L a pak R sice nic nenakresli, ale z procedury to nevyskoci
 ===> v obou 2 kombinacich jsou jeste mouchy}
          DrawLine(PoslX1,PoslY1,PoslX2,PoslY2);
          {dobra klavesa, nakresli caru}
          repeat
          until MouseKey<>2;
          {pockat na odmacknuti}
          if MouseKey<>0 then
            break;
            {neni-li pustena klavesa, konec; bude to dvojity break,
             protoze 2 tl. na mysi detekuje i dalsi if}
          NewMouseXY(PoslX2,PoslY2)
          {vrat mys, aby se napojila na polygon}
        end else begin
          repeat
          until MouseKey=0;
          {pockat na odmacknuti mysi}
{bacha, co kdyz tady zmacknou 2 tlacitka !!!!! viz. vyse}
          break
        end
      until false;
      {konec pri zmacknuti jineho tlacitka, nadcyklus pak opet pokracuje}
      if MouseKey<>0 then
        Break;
        {pri zmacknuti vice tlacitek je konec procedury}
    until false
  end;

  procedure KresliElipsy;
  var X,Y,DX,DY:integer;

  procedure makeell(x_stred,y_stred,a,b:integer);
  var pomx, pomy : integer;
      A_kvadrat, Dve_A_kvadrat, B_kvadrat, Dve_B_kvadrat : longint;
      predikce, pomdx, pomdy : longint;
      ox1,oy1,ox2,oy2:integer;

  procedure VypisBod(_x,_y:integer);
  {vykresli 1 z bodu elipsy/kruznice s kontrolou preteceni}
  begin
    if (_x>=ox1)and(_y>=oy1)and(_x<=ox2)and(_y<=oy2) then
      Putpixel(_x,_y,AktBarva);
  end;

  procedure kresli_symetricke_body;
    begin
      VypisBod(x_stred+pomx,y_stred+pomy);
      VypisBod(x_stred-pomx,y_stred+pomy);
      VypisBod(x_stred+pomx,y_stred-pomy);
      VypisBod(x_stred-pomx,y_stred-pomy)
    end; {kresli_symetrické_body}

  begin {Elipsa}
    {predpokl., ze a,b jsou kladna, coz je !ZDE! vzdy splneno (je tam Abs())}
    ox1:=maxinteger(x_stred-a,0);
    oy1:=maxinteger(y_stred-b,0);
    ox2:=mininteger(x_stred+a,sirka-1);
    oy2:=mininteger(y_stred+b,vyska-1);
    {orezeme elipsu, aby se vesla do vyrezu
     u masky (zde) bych toto mohl pro kontrolu preteceni vynechat, nebot je
     vzdy [0,0,Sirka,Vyska], ale je to vhodne pro nasledne zobrazeni zmen
     (aby se nemuselo prekreslovat cele okno, ale jen zmenena cast)}

    setactivepage(3);

    pomx := 0;
    pomy := b;
    A_kvadrat := longint(a) * a;
    B_kvadrat := longint(b) * b;
    Dve_A_kvadrat := 2 * A_kvadrat;
    Dve_B_kvadrat := 2 * B_kvadrat;
    predikce := B_kvadrat - A_kvadrat*b + A_kvadrat div 4;
    pomdx := 0;
    pomdy := Dve_A_kvadrat * b;

    while (pomdx < pomdy) do {řídicí osa x}
      begin
        kresli_symetricke_body;
        if (predikce >= 0) then
          begin
            pomy := pomy - 1;
            pomdy := pomdy - Dve_A_kvadrat;
            predikce := predikce - pomdy;
          end;
        pomx := pomx + 1;
        pomdx := pomdx + Dve_B_kvadrat;
        predikce := predikce + B_kvadrat + pomdx;
      end; {while pomdx < pomdy}

    predikce := predikce + (3*(A_kvadrat-B_kvadrat) div 2 - (pomdx+pomdy)) div 2;
    while (pomy >= 0) do {řídicí osa y}
      begin
        kresli_symetricke_body;
        if (predikce <= 0) then {vzrůst souřadnice x}
          begin
            pomx := pomx +1;
            pomdx := pomdx + Dve_B_kvadrat;
            predikce := predikce + pomdx;
          end;
        pomy := pomy - 1;
        pomdy := pomdy - Dve_A_kvadrat;
        predikce := predikce + A_kvadrat - pomdy;
      end; {while pomy >= 0}

    setactivepage(0);

    if AktBarva=255 then {guma}
      putimagepart(0,0,ox1,oy1,ox2-ox1+1,oy2-oy1+1,obr);
    VykresliMasku(ox1,oy1,ox2-ox1+1,oy2-oy1+1) {guma i stetec}
    {vykresleni modifikovane mapy v oblasti, ktera byla "zasazena"}
  end; {Elipsa}

  begin
    repeat
      MouseSwitchOn;
      repeat
      until MouseKey<>0;
      MouseSwitchOff;
      if not(MouseKey in [1,2]) then
        break;
      if MouseKey=1 then begin
      {elipsa}
        X:=MouseX;
        Y:=MouseY;
        repeat
          DX:=Abs(MouseX-X);
          DY:=Abs(MouseY-Y);
          XorEllipse(X, Y, DX, DY, 255);
          MouseSwitchOn;
{mam zobrazovat pri pohybu mys ?????}
          repeat
          until (Abs(MouseX-X)<>DX)or(Abs(MouseY-Y)<>DY)or(MouseKey<>1);
          MouseSwitchOff;
          XorEllipse(X, Y, DX, DY, 255)
{dodelat orezavani na velikost obrazku !!!!!}
        until MouseKey<>1;
        if MouseKey<>0 then
          break;
        makeell(x,y,dx,dy);
        {tato procedura  vykresli elipsu do masky a rovnez se postara
         o jeji zobrazeni na obrazovce}
        continue
      end;
      {jinak je to kruznice}
      if MouseKey<>2 then
        break;
      X:=MouseX;
      Y:=MouseY;
      repeat
        DX:=Round(Sqrt(Sqr(MouseX-X)+Sqr(MouseY-Y)));
        XorCircle(X, Y, DX, 255);
        MouseSwitchOn;
        repeat
        until (Round(Sqrt(Sqr(MouseX-X)+Sqr(MouseY-Y)))<>DX)or(MouseKey<>2);
        MouseSwitchOff;
        XorCircle(X, Y, DX, 255)
      until MouseKey<>2;
      if MouseKey<>0 then
        break;
      makeell(x,y,dx,dx)
      {tato procedura  vykresli kruznici do masky a rovnez se postara
       o jeji zobrazeni na obrazovce}
    until false
  end;

  procedure KresliVypln;

    procedure VyplnOblast(fromx,fromy:integer);
    {vyplni oblast aktualni maskou pocinaje od bodu [fromx,fromy]
     plni na pozadi, na ktere byla barva ukapnuta (siri se po masce dane
     barvy, pokud se kliklo na nej; nebo po nevyplnenych oblastech, bylo-li
     kliknuto naopak na nej);
     vse zalezi jeste na tom, zda se plni barvou, nebo se gumuje - fileni
     se preskoci, pokud byla barva ukapnuta na stejnou barvu (prip. guma
     na prazdny podklad)}
    var Buf:array[0..200*4-1,0..1]of integer;
        Cist,Zapisovat:integer;
        PuvodniBod:byte;

    procedure ZkusBod(X,Y:integer);
    var i:integer;
    begin
      if (X>=0)and(X<Sirka) and
         (Y>=0)and(Y<Vyska) and
         (GetPixel(X,Y)=PuvodniBod)and
         (barvyyyy[PByteArray(obr)^[3+x*Vyska+y+1]]=0)
      then begin
        Buf[Zapisovat][0]:=X;
        Buf[Zapisovat][1]:=Y;
        Zapisovat:=succ(Zapisovat) mod (200*4);
        PutPixel(X,Y,AktBarva);
      end
    end;

    begin
      setactivepage(3);

      PuvodniBod:=getpixel(fromx,fromy);
      if (PuvodniBod=AktBarva)and
         (barvyyyy[PByteArray(obr)^[3+fromx*Vyska+fromy]]<>0) then begin
      {neni co vyplnovat}
        setactivepage(0);
        exit
      end;

      Cist:=0;
      Zapisovat:=1;
      Buf[0][0]:=fromx;
      Buf[0][1]:=fromy;
      PutPixel(fromx,fromy,AktBarva);
      while Cist<>Zapisovat do begin           {dokud nevyprazdnime buffer}
        ZkusBod(Buf[Cist][0],Buf[Cist][1]-1);    {horni bod}
        ZkusBod(Buf[Cist][0],Buf[Cist][1]+1);    {dolni bod}
        ZkusBod(Buf[Cist][0]-1,Buf[Cist][1]);    {levy bod}
        ZkusBod(Buf[Cist][0]+1,Buf[Cist][1]);    {pravy bod}
        Cist:=succ(Cist) mod (200*4)
      end;

      setactivepage(0);

      if AktBarva=255 then
        putimage(0,0,obr);
        {pri gumovani masky nejprve obnovime podklad}
      vykreslimasku(0,0,Sirka,Vyska)
      {jinak se maska pouze pridava prip. prepisuje}
    end;

  begin
    repeat
      repeat until MouseKey<>0;       {cekej na zmacknuti tlacitka mysi}
      if MouseKey=1 then begin        {leve ===> vypln}
        MouseSwitchOff;
        VyplnOblast(MouseX,MouseY);
        MouseSwitchOn;
        repeat
        until MouseKey<>1
        {pockej na uvolneni tlacitka
         nebude-li zmacknuto nic, bude se priste cekat na novou udalost
         bude-li zmacknuto neco jineho, tak tato udalost projde pristim
           cyklem cekani na udalost a zachyti se na prikazu Break}
      end else                        {jinak konec}
        break
    until false
  end;

  procedure VyberNoveMasky;
  var NovaBarva:byte;
      Pole : array[0..255] of byte;
      x,y : word;
      i : byte;
  begin
    MouseSwitchOff;
    PutImage(0,0,obr);
    SetActivePage(3);
    for i:=0 to 255 do Pole[i]:=0;
    for x:=0 to 319 do
      for y:=0 to 199 do Pole[GetPixel(x,y)]:=1;
    SetActivePage(0);

    i:=0;
    while Pole[i]<>0 do Inc(i);

    MouseSwitchOn;
    Vyber:=ReadColor(10,10,255,255,
      DColor[5],DColor[3],DColor[1],DColor[2],font,'Zadej barvu masky :');
    if Vyber<>-1 then begin
      AktBarva:=i;
      ColorMask^[AktBarva]:=Vyber
    end;
    MouseSwitchOff;
    VykresliMasku(0,0,Sirka,Vyska)
  end;

  procedure VyberStareMasky;
  {nasaje nektery uz existujici masku z obrazku; pokud se nasaje misto
   bez masky, pokus se opakuje
   skonci se pri uspesnem pokusu (nastavi se barva), nebo pri zmakcnuti
   jineho nez leveho tlacitka mysi (ponecha se stara barva)}
  var Barva:byte;
  begin
    Barva:=255;
    repeat
      MouseSwitchOn;
      {zapni mys}
      repeat until MouseKey<>0;
      {cekani na udalost}
      if MouseKey<>1 then
        break;
        {jine tlacitko nez leve ===> konec bez nastaveni}
      repeat until MouseKey<>1;
      if MouseKey<>0 then
        Break;
      MouseSwitchOff;
      {jinak vypni mys kvuli prepnuti stranek}

      setactivepage(3);
      Barva:=GetPixel(MouseX,MouseY);
      setactivepage(0);
      {prepni stranky, nasaj barvu a vrat stranky}
    until Barva<>255;
    {konec spatnym tlacitkem (break) nebo pri nasati vhodne barvu (until)}

    if Barva<>255 then begin
      AktBarva:=Barva;
{      Konec:=true}
    end
    {byla-li vybrana nejaka barva, nastav ji}
  end;

  procedure NastavMazani;
  {nastavi mazani gumou}
  begin
    AktBarva:=255;
{    Konec:=true}
  end;

  procedure ZmenaBarvyMasky;
  {zmeni barvu aktualni masky}
  begin
    if AktBarva=255 then begin
      standardnidialog('Nemáš označenou žádnou masku!',
        DColor[1], DColor[2], DColor[3], DColor[4], DColor[5], font,
        berunavedomi);
      exit;
    end;
      {pri gumovani se nema co menit}
    NewMouseArea(0,0,320,200);
    Vyber:=ReadColor(10,10,255,255,
      DColor[5],DColor[3],DColor[1],DColor[2],font,'Zadej novou barvu masky:');
    if Vyber<>-1 then
    {je-li vybrana nejaka barva, zmen ji}
      ColorMask^[AktBarva]:=Vyber;
{    Konec:=true;}
    MouseSwitchOff;
    VykresliMasku(0,0,Sirka,Vyska)
  end;

  procedure Clearstencil;
  var i:byte;
  begin
    for i:=0 to 255 do barvyyyy[i]:=0;
  end;

 procedure HelpStencil;
 begin
   VyberMoznost('Edit Stencil||'+
     'F1       tato nápověda |'+
     'I        insert barev  |'+
     'C        clear barev   |'+
     'T        tag vsech b.  |'+
     '+        označení bl.  |'+
     '-        odoznačení bl.|',
     'Tak si to vychutnej!!!',
     DColor[1], DColor[2], DColor[3], DColor[4],
     DColor[5], font, 1,1);
 end;

begin
  for AktBarva:=0 to 255 do Barvyyyy[AktBarva]:=0;
  Sirka:=PWordArray(Obr)^[0];
  Vyska:=PWordArray(obr)^[1];
  VelX:=5;
  VelY:=5;
  AktBarva:=255;
  SetRCLimits(-1,-1,-1,-1,-1,-1);

  pushmouse;
  mouseswitchoff;
  {vypneme mys pro nacteni pozadi a vykresleni obrazku}

  NewImage(Sirka,Vyska,UchovPoz);
  GetImage(0,0,Sirka,Vyska,UchovPoz);
  PutImage(0,0,obr);
  DrawMask(0,0,Sirka,Vyska,false,nil);
  {pozadi se ulozilo a obrazek se vykresli v pro nej vyhrazene oblasti +
   + vykresli se pres nej doposud naeditovana maska}
  {ZmenaParametruMasek;}

  repeat
    NewMouseArea(0,0,320,200);
    Repeat Until MouseKey=0;
    {pockej na uvolneni tlacitek, nastav celou obrazovku pro pohyb,
     viditelnost ted neni dulezita}
    Vyber:=VytvorMenu('#Vyber si nastroj|Š~tětec|~Obdélníky|'+
      '~Usečky/Polygony|~Elipsy/Kružnice|~Vyplnování|#|'+
      '~Nová maska|~Stará maska|~Gumování masek|'+
        'Zmena ~barvy masky|#|Stencil|Smazat oznaceni|~Zpět',
      DColor[1], DColor[2], DColor[3], DColor[4], DColor[5],
      {    7,25,15,48,96,} font, MenuX[6], MenuY[6], 1,12);
    NewMouseArea(0,0,Sirka,Vyska);
    MouseSwitchOn;
    {nastav vyrez obrazku pro pohyb a zapni mys, na uvolneni tlacitek
     pocka dialog sam}
{DOUFAM !!!!!!!!!!!!!!!!!}
    case Vyber of
      1 : KresliStetcem;
      2 : KresliObdelniky;
      3 : KresliUsecky;
      4 : KresliElipsy;
      5 : KresliVypln;
      6 : VyberNoveMasky;      {nova maska}
      7 : VyberStareMasky;     {uz existujici maska}
      8 : NastavMazani;        {mazani gumou}
      9 : ZmenaBarvyMasky;     {zmena pouzite barvy}
      10 : begin
             while not(Stencil(10,10,barvyyyy,Dcolor[3],Dcolor[4],
                   Dcolor[1],Dcolor[2],Dcolor[5])) do HelpStencil;
           end;
      11 : ClearStencil;
    end
  until Vyber=12;
  {editor masek skonci vyvolanim jiste polozky v menu}

  NewMouseArea(0,0,320,200);
  repeat until MouseKey=0;
  MouseSwitchOff;
  PutImage(0,0,UchovPoz);
  DisposeImage(UchovPoz);

  popmouse
  {nastavi se cela obrazovka pro pohyb, pocka se na uvolneni tlacitek,
   obnovi se pozadi a viditelnost mysi se nastavi na puvodni hodnotu}
end;




function  NewMap(obr : pointer; roztecx,roztecy:integer;
  var map : pointer) : word;
{vytvori dyn. prom. pro ulozeni mapy prislusne k danemu obrazku}
var Sirka,Vyska,Velikost,Sir : integer;
begin
  Sirka:=PWordArray(Obr)^[0];
  Vyska:=PWordArray(Obr)^[1];
  Sir:=(Sirka-1) div roztecx +1;
  if (Sir mod 8)=0
    then Sir:=Sir div 8
    else Sir:=(Sir div 8)+1;
  Velikost:=Sir*((Vyska-1) div roztecy +1)+14;
  GetMem(map,velikost);
  fillchar(map^,velikost,0);
  PWordArray(map)^[0]:=Sirka;
  PWordArray(map)^[1]:=Vyska;
  PWordArray(map)^[2]:=roztecx;
  PWordArray(map)^[3]:=roztecy;
  PWordArray(map)^[4]:=(Sirka-1) div roztecx +1;
  PWordArray(map)^[5]:=(Vyska-1) div roztecy +1;
  PWordArray(map)^[6]:=Sir;
{!!!!!!!!!!!!!!!!!!!!!! mam tady sice uvedeno u rozteci integer a vsude se
  to taky jako integer uklada, ale v registrech to bohuzel je ulozeno
  v 8-bitovych atp... ===> lze pouze do rozumnych mezi (ale kdo by daval
  mez X>255)
 !!!!!!!!!!!!!!! ale ona se nezobrazi ani mez treba x=200 a nevim proc, ale
  zatim to doufam neni dulezite !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!}
  NewMap:=Velikost
end;

function GetSizeMap(map : pointer) : word;
begin
  GetSizeMap:=PWordArray(map)^[6]*PWordArray(map)^[5]+14;
end;

procedure DisposeMap(var map : pointer);
{dealokuje dyn. prom. obsahujici mapu}
begin
  FreeMem(map,PWordArray(map)^[6]*PWordArray(map)^[5]+14)
  {opak getmem, viz. NewMap}
end;

procedure DrawMap(_px,_py,_x,_y,_dx,_dy:integer;map:pointer); assembler;
{tisk mapy : vyzaduje pozici zacatku tisknuti v bodech a pozici vyrezu
 zadanou v "deravich sloupcich", ne v bodech}
var Barva:byte;    {pomocna, pouze pro ulozeni na zacatku, protoze menim ds}
asm
  call pushmouse
  call mouseswitchoff
  push ds
  push es
  push si
  push di

  cmp _px,0
  jl @konec
  cmp _py,0
  jl @konec
  cmp _x,0
  jl @konec
  cmp _y,0
  jl @konec
  cmp _dx,0             {osetreni 0}
  jle @konec
  cmp _dy,0
  jle @konec
{kontrola podteceni, mozna ze to bude postacovat (?????) (ze to nebudu
 v pripade chyby opravovat, proste odmitnu)
 mozna je to tady uplne zbytecne !!!!!!!!!!}

  mov ax,0a000h                {zacatek VRAM}
  mov es,ax
  mov al,ColorGoMap            {ztrati se nam DS a bude to nepristupne}
  mov Barva,al
  mov bx, word ptr map         {zacatek dat}
  mov ds, word ptr map+2
  {vyplnen ukazatel na data a na vram}

  mov si, bx                   {presun ukazatel na data}
  add si, 14
  xor di,di                    {ukazatel do vram}
  {vyplnen pocatecni ukazatel na zdroj a cil}

  mov ax,_x                    {vezmi pocatecni sloupec}
  mov cx,ds:[bx+4]
  mul cx                       {vetsi cast vysl. (dx) velkodusne zapomeneme}
  add ax,_px                   {pridame poc. poz. v bodech}
  mov cl,4                     {vydelime poctem bitovych rovin}
  div cl                       {v ah je nyni zbytek - cislo bit. roviny}
  mov cl,al                    {pricti pozici k vram}
  xor ch,ch
  add di,cx
  mov al,1                     {v al je nyni posunuta 1 oznacujici cislo}
  mov cl,ah                      {vstranky}
  shl al,cl
  push ax
  {vyplnil jsem pocatecni al a ah; di}

  mov ax,_x                   {l.poz. vydelime 8 pro ziskani pozice dat}
  mov cl,8
  div cl                       {al=offset data; ah=pozice bitu}
  mov dl,1                     {dl:=posunuta 1 podle pozice bitu}
  mov cl,ah
  shl dl,cl
  mov dh,Barva                {kreslici barva}
  push dx                      {zapamatuj si oboje dulezita data}
  xor ah,ah                    {pridej k offsetu pozici daneho bodu}
  add si,ax
  {vyplnil jsem pocatecni dl a dh, si}

  mov ax,_y              {offset v datech - si}
  mov cx,ds:[bx+12]      {nasobime pametovym rozmerem radku}
  mul cx
  add si,ax              {opet zapomeneme vetsi cast (dx)}

  mov ax,_y              {offset ve vram - di}
  mov cx,ds:[bx+6]       {nasobime rozteci radku}
  mul cx
  add ax,_py             {pridame pocatecni tiskovy radek}
  mov cx,80              {nasobime 80 - rozmerem vradku}
  mul cx
  add di,ax              {opet zapomeneme vetsi cast (dx)}
  {dopocitan offset di a si pro y-ovy rozmer}

  pop dx                      {obnov vypocitane hodnoty}
  pop ax

  mov cx, _dx                 {vezmi pozadovany pocet sloupcu}

@sloupec:
  push cx

  push dx                      {zapamatuj si cislo roviny (ordinalni)}
  push ax
  mov cx,ax
  {v ah je cislo roviny (posunuta 1 na urcite misto)}
  mov     dx, 3C4h               {nastav vstranku}
  mov     al, 2
  out     dx, al
  inc     dx
  mov     al, cl
  out     dx, al
  mov     dx, 3CEh
  mov     al, 4
  out     dx, ax
  inc     dx
  mov     al, ch
  out     dx, al
  pop ax                       {vyzvedni si cislo vroviny}
  pop dx                       {vyzvedni si cislo bitu v datech a barvu}
  push di
  push si

  mov cx, _dy                  {pozadovana vyska}

  {cyklus :
    al=posunuta 1 podle al; al=cislo vstranky
    dl=cislo bitu v datech; dh=barva nakresleneho bodu}
@bod:
  push cx
  {lodsb do dl, ale bez posunu registru}
  mov cl,ds:[si]              {nacti bod z masky a zjisti jeho stav}
  test cl,dl
  jz @nevypisovat
  {stosb z dl, ale bez posunu registru}
  mov es:[di],dh              {pripadne zapis bod z masky}
{musim putnout barvu, ne nacteny bajt !!!!!!!!!!!!!!!!!!}
@nevypisovat:
  {pop cx
  push cx}
  mov cx, ds:[bx+6]              {roztecy}
@zvyscil:
  add di,80
  loop @zvyscil
  add si,ds:[bx+12]              {preskoc radek ve zdrojove mape}
  pop cx
  loop @bod                   {a na dalsi bod}

  pop si
  pop di

  push ax
  mov ax, ds:[bx+4]              {vezmi roztecx}
  mov cl, 4
  div cl
  mov cl,ah
  xor ah,ah
  add di, ax                    {pridej do ukazatele roztec}
  pop ax

  rol al,cl                     {cislo vstranky}
  add ah,cl
  cmp ah,3                  {preteceni ?}
  jle @nedalsirovina
  ror al,4
  sub ah,4
  add di, 1               {pridej jeste 1 sloupec}
@nedalsirovina:

  shl dl,1                      {cislo bitu}
  cmp dl,0              {preteceni ?}
  jnz @nedalsibajt
  mov dl,01h
  inc si
@nedalsibajt:

  pop cx
  loop @sloupec            {dalsi sloupec}

@konec:
  pop di
  pop si
  pop es
  pop ds
  call popmouse
end;

procedure EditMap(_px,_py:integer; obr : pointer; var map : pointer);
{editace mapy chuze podle obrazku, zacina se od [_px,_py]}
var Kresleni:boolean;        {kreslici/gumovani}
    Vyber:integer;           {vybrana polozka v menu}
    Sirka, Vyska : word;     {sirka a vyska edit. obr.}
    VelX, VelY : integer;    {sirka a vyska kresliciho sloupce}
    UchovPoz:pointer;        {puvodni pozadi pod editorem}

  procedure PutPixelMap(X,Y:integer;co:boolean;map:pbytearray); assembler;
  {predpokl. se x=<1..rx> stejne tak y a procedura si sama odecte 1}
  asm
    push ds                    {vypocet indexu map^}
    mov bx, word ptr map
    mov ds, word ptr map+2
    {tady byla krpa, ze pred uvedenim jako parametru se to bralo z lokalni
     promenne nadprocedury a tam to BP nemohl prepocitat na ss:sp nebo bp,
     protoze nevedel, kolikrat jsem dal push na zacatku (ja dvakrat) !!!!!
     ===> musi to byt parametr}
{    mov ax,x
    mov cx,y
    cmp ax,0
    jl @konec
    cmp cx,0
    jl @konec
    cmp ax,ds:[bx+8]
    jge @konec
    cmp cx,ds:[bx+10]
    jge @konec
{kontrola souradnic kvuli orezavani kruznic a elips; mozna to ale udelat
 do elipsy !!!!!}

    mov ax,ds:[bx+12]   {sirka 1 zaznamu}
    mul y               {vynasobit cislem radku, mame offset zacatku radku}
    add bx,14           {preskoceni hlavicky}
    add bx,ax           {presuneme se na tento zacatek radku}
    mov ax,x            {vezmeme pozici x}
    mov cl,al
    and cl,7            {vypocet x modulo 8 pro urceni cisla bitu}
    shr ax,3
    add bx,ax           {pricteme vyDIVenou 8 k offsetu}

    mov al,1
    shl al,cl
    mov cl,byte ptr ds:[bx] {nacteni zadaneho bajtu}

    cmp co,0
    je  @nulovat
    or cl,al                   {nastavovani bitu}
    jmp @zapis
  @nulovat:
    not al                     {nulovani bitu}
    and cl,al
  @zapis:
    mov byte ptr ds:[bx],cl    {vraceni zpet}
  @konec:
    pop ds
  end;

  function  GetPixelMap(X,Y : word;map:pbytearray):boolean; assembler;
  asm
    push ds                    {vypocet indexu map^}
    mov bx, word ptr map
    mov ds, word ptr map+2
    {tady byla krpa, ze pred uvedenim jako parametru se to bralo z lokalni
     promenne nadprocedury a tam to BP nemohl prepocitat na ss:sp nebo bp,
     protoze nevedel, kolikrat jsem dal push na zacatku (ja dvakrat) !!!!!
     ===> musi to byt parametr}
{tady myslim kontrola neni potreba}
    mov ax,ds:[bx+12]   {sirka 1 zaznamu}
    mul y               {vynasobit cislem radku, mame offset zacatku radku}
    add bx,14           {preskoceni hlavicky}
    add bx,ax           {presuneme se na tento zacatek radku}
    mov ax,x            {vezmeme pozici x}
    mov cl,al
    and cl,7            {vypocet x modulo 8 pro urceni cisla bitu}
    shr ax,3
    add bx,ax           {pricteme vyDIVenou 8 k offsetu}

    mov al,1
    shl al,cl

    and al,byte ptr ds:[bx]    {vyANDovani daneho bitu podle obsahu pameti}
    jz  @nulove                {0..nic se nedeje, konec, vysl je v al=0}
    mov al,1                   {else..konec, ve vysledku v al=1}
  @nulove:
    pop ds                     {obnovime registry ds, konec}
  end;

  procedure Pozice2Index(var x,y,dx,dy:integer);
  {prevede pozici v bodech na pozici v "derovanych sloupcich/radcich"
   (zaokrouhli to dolu, nepadne-li to na nejaky bod)}
  var fx,fy,tx,ty:integer;
  begin
    fx:=(x-_px) div pwordarray(map)^[2];      {poDIVuj rozteci LH. roh}
    fy:=(y-_py) div pwordarray(map)^[3];
    tx:=(x-_px+dx-1) div pwordarray(map)^[2]; {poDIVuj rozteci PD. roh}
    ty:=(y-_py+dy-1) div pwordarray(map)^[3];
    x:=fx;                                {vrat LH. roh}
    y:=fy;
    dx:=tx-fx+1;                          {vrat XY. rozmer}
    dy:=ty-fy+1
  end;

  procedure ZaokrouhliPozice(var x,y,dx,dy:integer);
  {zaokrouhleni obobne jako prevedeni na indexy, ale jednotka zustava stejna
   - body}
  begin
    Pozice2Index(x,y,dx,dy);
    x:=_px+x*pwordarray(map)^[2];
    y:=_py+y*pwordarray(map)^[2];
    dx:=dx*pwordarray(map)^[2];
    dy:=dy*pwordarray(map)^[2]
  end;

  procedure VykresliMapu(X,Y,Sirka,Vyska:integer);
  {vykresli danou cast mapy na obrazovce}
  begin
    Pozice2Index(X,Y,Sirka,Vyska);
    DrawMap(_px,_py,x,y,sirka,vyska,map);
  end;

  {nasleduji kreslici procedury, ktere predpokladaji toto :
    - predpokladaji viditelnou mys, ale nevraceji ji
    - NewMouseArea nastaveno na velikost obrazku, ale nevraceji ho
    - predpokladaji uvolnene klavesy mysi, ale po sobe na uvolneni
      vsech klaves necekaji
    - ocekavaji konzistentni obsah 0. videostranky a mapy, provedou
      editacni zmeny a zarucuji, ze obsah zustane konzistentni i nadale}

  procedure KresliStetcem;
  var MysX, MysY, MysK : integer;

  procedure BarMap(X,Y,Sirka,Vyska:integer);
  {vykresleni vyplneneho obdelniku do mapy}
  var i1, i2 : integer;
  begin
    Pozice2Index(X,Y,Sirka,Vyska);
    {tady se problemy s podtecenim PD. rohu vyresi samy strukturou cyklu
     for v bp}
    for i2 := y to y+vyska-1 do
      for i1 := x to x+sirka-1 do
        PutPixelMap(i1,i2,Kresleni,map)
{tady myslim ani nestoji za to to delat jinak (ze se vnitrni bity nastavi
 primo na 0 nebo FF atp...), skoda casu (meho) to osetrovat}
  end;

  begin
    MouseSwitchOff;
    NewMouseArea(_px,_py,Sirka-VelX+1,Vyska-VelY+1);
    {priprav mys}
    repeat
    {cyklus porad presouva obdelnik, dokud neni nic zmacknuto;
     az se neco zmackne, vyvola se cyklus, ktery to osetri a pri
     pusteni klavesy se opet navrati rizeni tomuto cyklu}
      MysX:=MouseX;
      MysY:=MouseY;
      Bar(MysX,MysY,VelX,VelY,ColorGoMap);

{nemela by se guma zobrazovat jinou barvou ????????????

 mozna bych mohl vsechno zobrazovat uz tak, jak to bude vypadat (tj.
 obdelnik posouvat po schodcich, cary, kruznice atp... kreslit hrbolate
 atp...}

      {vykresli obdelnik}
      repeat
      until (MouseX<>MysX)or(MouseY<>MysY)or(MouseKey<>0);
      {pocka na udalost}
      PutImagePart(_px,_py,MysX,MysY,VelX,VelY,obr);
      VykresliMapu(MysX,MysY,VelX,VelY);
      {obdelnik smaze}
      MysX:=MouseX;
      MysY:=MouseY;
      MysK:=MouseKey;
      {nastavi nove souradnice}
      if MysK=0 then
        continue;
        {pouze pohyb, nic}
      if MysK=1 then begin
      {levy = pridavani/mazani masky}
        repeat
          Bar(MysX,MysY,VelX,VelY,ColorGoMap);
          {nakresli ramecek}
          repeat
          until (MouseX<>MysX)or(MouseY<>MysY)or(MouseKey<>1);
          {cekej na udalost a to, co je PUTle, nech tam}
          BarMap(MysX,MysY,VelX,VelY);
          {dej novou masku}
          PutImagePart(_px,_py,MysX,MysY,VelX,VelY,obr);
{tady se mi myslim osvedcuje tvuj zpusob zadavani "Part"; ale ten muj
 (a Vlckuv) je taky k necemu dobry}
          VykresliMapu(MysX,MysY,VelX,VelY);
          {ukaz masku na obrazovce
           zobrazene to je i pri mazani gumou}
          MysX:=MouseX;
          MysY:=MouseY;
          MysK:=MouseKey
          {zmen souradnice mysi}
        until MysK<>1;
        {dokud se nezmeni stav tlacitek mysi}
        if MysK=0 then
          continue;
          {pusteni tlacitka ===> pokracujeme}
        break
        {jinak se zmackne do toho dalsi tlacitko, treba prave ===> konec}
      end;
      if MysK<>2 then
        Break;
        {prostredni tlacitko ===> konec}
      {jinak je to prave tlacitko a to znamena presouvani praveho dolniho
       rohu (zoom stetce)}
      NewMouseArea(MysX,MysY,Sirka-(MysX-_px),Vyska-(MysY-_py));
      NewMouseXY(MysX+VelX-1,MysY+VelY-1);
      repeat
        Bar(MysX,MysY,VelX,VelY,ColorGoMap);
        {zobraz novou velikost obdelniku}
        repeat
        until (MouseX<>MysX+VelX-1)or(MouseY<>MysY+VelY-1)or(MouseKey<>MysK);
        {cekej na udalost}
        PutImagePart(_px,_py,MysX,MysY,VelX,VelY,obr);
        VykresliMapu(MysX,MysY,VelX,VelY);
        {obnov podklad}
        VelX:=MouseX-MysX+1;
        VelY:=MouseY-MysY+1
        {nastav novou velikost obdelniku}
      until MouseKey<>MysK;
      {az do zmeny stavu tlacitek}
      NewMouseXY(MysX,MysY);
      NewMouseArea(_px,_py,Sirka-VelX+1,Vyska-VelY+1);
      {nastav puvodni stav mysi}
      if MouseKey=0 then
        continue;
        {pusteni tlacitka ===> pokracujeme}
      break
      {jinak se zmackne do toho dalsi tlacitko, treba leve ===> konec}
    until false
    {vyskoci se prikazem Break pri stisku praveho a potom (pritom) i leveho
     nebo prostredniho tlacitka nebo naopak}
  end;

  procedure KresliObdelniky;
  var X,Y,DX,DY:integer;

  procedure RectangleMap(X,Y,Sirka,Vyska:integer);
  {vykresleni nevyplneneho obdelniku do mapy}
  var i:integer;
  begin
    Pozice2Index(X,Y,Sirka,Vyska);
{predpokl., ze sirka a vyska jsou vhodne, protoze to pouzivam jenom tady}
    for i:=x to x+sirka-1 do begin
      putpixelmap(i,y,Kresleni,map);
      putpixelmap(i,y+vyska-1,Kresleni,map)
    end;
    for i:=y+1 to y+vyska-1-1 do begin
      putpixelmap(x,i,Kresleni,map);
      putpixelmap(x+sirka-1,i,Kresleni,map)
    end;
{obdobna poznamka jako u BarMap}
  end;

  begin
    repeat
      NewMouseArea(_px,_py,Sirka,Vyska);
      MouseSwitchOn;
      repeat
      until MouseKey<>0;
      MouseSwitchOff;
      if MouseKey<>1 then
        break;
      X:=MouseX;
      Y:=MouseY;
      NewMouseArea(X,Y,Sirka-(X-_px),Vyska-(Y-_py));
      repeat
        DX:=MouseX-X+1;
        DY:=MouseY-Y+1;
        XorRectangle(X, Y, DX, DY, 255);
        MouseSwitchOn;
        repeat
        until (MouseX-X+1<>DX)or(MouseY-Y+1<>DY)or(MouseKey<>1);
        MouseSwitchOff;
        XorRectangle(X, Y, DX, DY, 255)
      until MouseKey<>1;
      if MouseKey<>0 then
        Break;
      rectanglemap(x,y,dx,dy);
      putimagepart(_px,_py,x,y,dx,dy,obr);
      vykreslimapu(x,y,dx,dy)
      {guma i stetec}
    until false
  end;

  procedure KresliUsecky;
  var PoslX1,PoslY1,PoslX2,PoslY2:integer;

  procedure DrawLine(x1,y1,x2,y2:integer);
  var pom:integer;
  var x,y:integer;
      poc,i,j:integer;
      smerx,smery:integer;
      _x1,_y1,_x2,_y2:integer;
  begin
    _x1:=(x1-_px) div pwordarray(map)^[2];       {poDIVuj rozteci}
    _y1:=(y1-_py) div pwordarray(map)^[3];
    _x2:=(x2-_px) div pwordarray(map)^[2];
    _y2:=(y2-_py) div pwordarray(map)^[3];

    x:=abs(_x2-_x1);
    y:=abs(_y2-_y1);
    if _x2>=_x1
      then smerx:=1
      else smerx:=-1;
    if _y2>=_y1
      then smery:=1
      else smery:=-1;
    poc:=0;
    i:=0;
    for j:=0 to y do begin
      inc(poc,x);
      putpixelmap(_x1+i*smerx,_y1+j*smery,kresleni,map);
      if poc>=y then begin
        dec(poc,y);
        inc(i);
        while (poc>=y)and(i<=x) do begin
          putpixelmap(_x1+i*smerx,_y1+j*smery,kresleni,map);
          dec(poc,y);
          inc(i)
        end
      end
    end;

    if x2<x1 then begin
      pom:=x2;
      x2:=x1;
      x1:=pom
    end;
    if y2<y1 then begin
      pom:=y2;
      y2:=y1;
      y1:=pom
    end;
    if not kresleni then
      putimagepart(_px,_py,x1,y1,x2-x1+1,y2-y1+1,obr);
    VykresliMapu(x1,y1,x2-x1+1,y2-y1+1)
  end;

  begin
    repeat
      MouseSwitchOn;
      repeat until MouseKey<>0;
      if not(MouseKey in [1,2]) then
        break;
      if MouseKey=1 then begin
      {pri zmacknuti leveho tlacitka se taha gumova cara}
        PoslX1:=MouseX;
        PoslY1:=MouseY;
        PoslX2:=MouseX;
        PoslY2:=MouseY;
        MouseSwitchOff;
        repeat
          XorLine(PoslX1,PoslY1,PoslX2,PoslY2,255);
          MouseSwitchOn;
          repeat
          until (MouseX<>PoslX2)or(MouseY<>PoslY2)or(MouseKey<>1);
          MouseSwitchOff;
          XorLine(PoslX1,PoslY1,PoslX2,PoslY2,255);
          PoslX2:=MouseX;
          PoslY2:=MouseY
        until MouseKey<>1;
        if MouseKey<>0 then
          break;
        DrawLine(PoslX1,PoslY1,PoslX2,PoslY2);
        continue
      end;
      {jinak je zmacknuto prave tlacitko, taha se polygon, dokud se
       nezmackne jine tlacitko nez prave}
      repeat
      until MouseKey<>2;
      {ceka na odmacknuti tlacitka}
      if MouseKey<>0 then
        break;
        {konec kresleni usecek/car pri jinem tlacitku}
      repeat
        PoslX1:=MouseX;
        PoslY1:=MouseY;
        PoslX2:=MouseX;
        PoslY2:=MouseY;
        MouseSwitchOff;
        repeat
          XorLine(PoslX1,PoslY1,PoslX2,PoslY2,255);
          MouseSwitchOn;
          repeat
          until (MouseX<>PoslX2)or(MouseY<>PoslY2)or(MouseKey<>0);
          MouseSwitchOff;
          XorLine(PoslX1,PoslY1,PoslX2,PoslY2,255);
          PoslX2:=MouseX;
          PoslY2:=MouseY
        until MouseKey<>0;
        if MouseKey=2 then begin
{tady to mozna nechce nakreslit caru pri R a pak L, ale co na tom; pokud to
 prehodim s cekanim na dalsi akci mysi, tak po dobu drzeni tlacitka vsechno
 zmizi a je to hnusny; tato akce ma vyhodu aspon v tom, ze se vyskoci
 z procedury
 kombinace L a pak R sice nic nenakresli, ale z procedury to nevyskoci
 ===> v obou 2 kombinacich jsou jeste mouchy}
          DrawLine(PoslX1,PoslY1,PoslX2,PoslY2);
          {dobra klavesa, nakresli caru}
          repeat
          until MouseKey<>2;
          {pockat na odmacknuti}
          if MouseKey<>0 then
            break;
            {neni-li pustena klavesa, konec; bude to dvojity break,
             protoze 2 tl. na mysi detekuje i dalsi if}
          NewMouseXY(PoslX2,PoslY2)
          {vrat mys, aby se napojila na polygon}
        end else begin
          repeat
          until MouseKey=0;
          {pockat na odmacknuti mysi}
{bacha, co kdyz tady zmacknou 2 tlacitka !!!!! viz. vyse}
          break
        end
      until false;
      {konec pri zmacknuti jineho tlacitka, nadcyklus pak opet pokracuje}
      if MouseKey<>0 then
        Break;
        {pri zmacknuti vice tlacitek je konec procedury}
    until false
  end;

  procedure KresliElipsy;
  var X,Y,DX,DY:integer;

  procedure makeell(x_stred,y_stred,a,b:integer);
  var pomx, pomy : integer;
      A_kvadrat, Dve_A_kvadrat, B_kvadrat, Dve_B_kvadrat : longint;
      predikce, pomdx, pomdy : longint;
      ox1,oy1,ox2,oy2,mx1,my1,mx2,my2:integer;

  procedure VypisBod(_x,_y:integer);
  {vykresli 1 z bodu elipsy/kruznice s kontrolou preteceni}
  begin
    if (_x>=mx1)and(_y>=my1)and(_x<=mx2)and(_y<=my2) then
      Putpixelmap(_x,_y,kresleni,map);
  end;

  procedure kresli_symetricke_body;
    begin
      VypisBod(x_stred+pomx,y_stred+pomy);
      VypisBod(x_stred-pomx,y_stred+pomy);
      VypisBod(x_stred+pomx,y_stred-pomy);
      VypisBod(x_stred-pomx,y_stred-pomy)
    end; {kresli_symetrické_body}

  begin {Elipsa}
    {predpokl., ze a,b jsou kladna, coz je !ZDE! vzdy splneno (je tam Abs())}
    ox1:=maxinteger(x_stred-a,_px);
    oy1:=maxinteger(y_stred-b,_py);
    ox2:=mininteger(x_stred+a,_px+sirka-1);
    oy2:=mininteger(y_stred+b,_py+vyska-1);
    {orezeme elipsu, aby se vesla do vyrezu}
    mx1:=(ox1-_px) div pwordarray(map)^[2];
    my1:=(oy1-_py) div pwordarray(map)^[3];
    mx2:=(ox2-_px) div pwordarray(map)^[2];
    my2:=(oy2-_py) div pwordarray(map)^[3];
    {prevedeme take na jednotky "derave sloupce/radky"}

    x_stred:=(x_stred-_px) div pwordarray(map)^[2];       {poDIVuj rozteci}
    y_stred:=(y_stred-_py) div pwordarray(map)^[3];
    a:=a div pwordarray(map)^[2];
    b:=b div pwordarray(map)^[3];

    pomx := 0;
    pomy := b;
    A_kvadrat := longint(a) * a;
    B_kvadrat := longint(b) * b;
    Dve_A_kvadrat := 2 * A_kvadrat;
    Dve_B_kvadrat := 2 * B_kvadrat;
    predikce := B_kvadrat - A_kvadrat*b + A_kvadrat div 4;
    pomdx := 0;
    pomdy := Dve_A_kvadrat * b;

    while (pomdx < pomdy) do {řídicí osa x}
      begin
        kresli_symetricke_body;
        if (predikce >= 0) then
          begin
            pomy := pomy - 1;
            pomdy := pomdy - Dve_A_kvadrat;
            predikce := predikce - pomdy;
          end;
        pomx := pomx + 1;
        pomdx := pomdx + Dve_B_kvadrat;
        predikce := predikce + B_kvadrat + pomdx;
      end; {while pomdx < pomdy}

    predikce := predikce + (3*(A_kvadrat-B_kvadrat) div 2 - (pomdx+pomdy)) div 2;
    while (pomy >= 0) do {řídicí osa y}
      begin
        kresli_symetricke_body;
        if (predikce <= 0) then {vzrůst souřadnice x}
          begin
            pomx := pomx +1;
            pomdx := pomdx + Dve_B_kvadrat;
            predikce := predikce + pomdx;
          end;
        pomy := pomy - 1;
        pomdy := pomdy - Dve_A_kvadrat;
        predikce := predikce + A_kvadrat - pomdy;
      end; {while pomy >= 0}

    if not kresleni then {guma}
      putimagepart(_px,_py,ox1,oy1,ox2-ox1+1,oy2-oy1+1,obr);
    VykresliMapu(ox1,oy1,ox2-ox1+1,oy2-oy1+1) {guma i stetec}
    {vykresleni modifikovane mapy v oblasti, ktera byla "zasazena"}
  end; {Elipsa}

  begin
    repeat
      MouseSwitchOn;
      repeat
      until MouseKey<>0;
      MouseSwitchOff;
      if not(MouseKey in [1,2]) then
        break;
      if MouseKey=1 then begin
      {elipsa}
        X:=MouseX;
        Y:=MouseY;
        repeat
          DX:=Abs(MouseX-X);
          DY:=Abs(MouseY-Y);
{tady mam elipsu neomezenou ANTI obdelnik je omezeny !!!!!}
          XorEllipse(X, Y, DX, DY, 255);
          MouseSwitchOn;
{mam zobrazovat pri pohybu mys ?????}
          repeat
          until (Abs(MouseX-X)<>DX)or(Abs(MouseY-Y)<>DY)or(MouseKey<>1);
          MouseSwitchOff;
          XorEllipse(X, Y, DX, DY, 255)
        until MouseKey<>1;
        if MouseKey<>0 then
          break;
        makeell(x,y,dx,dy);
        {tato procedura  vykresli elipsu do mapy a rovnez se postara
         o jeji zobrazeni na obrazovce}
        continue
      end;
      {jinak je to kruznice}
      if MouseKey<>2 then
        break;
      X:=MouseX;
      Y:=MouseY;
      repeat
        DX:=Round(Sqrt(Sqr(MouseX-X)+Sqr(MouseY-Y)));
        XorCircle(X, Y, DX, 255);
        MouseSwitchOn;
        repeat
        until (Round(Sqrt(Sqr(MouseX-X)+Sqr(MouseY-Y)))<>DX)or(MouseKey<>2);
        MouseSwitchOff;
        XorCircle(X, Y, DX, 255)
      until MouseKey<>2;
      if MouseKey<>0 then
        break;
      makeell(x,y,dx,dx)
      {tato procedura  vykresli elipsu do mapy a rovnez se postara
       o jeji zobrazeni na obrazovce}
    until false;
  end;

  procedure KresliVypln;

    procedure VyplnOblast(fromx,fromy:integer);
    {vyplni oblast v mape : pokud je cil fileni stejny jako podlozi, kam byl
     ukapnut, nedeje se nic, jinak se toto podlozi fili danym stylem
     (styl je 2-stavovy ano/ne, takze to je bez problemu)}
    var Buf:array[0..200*4-1,0..1]of integer;
        Cist,Zapisovat:integer;

    procedure ZkusBod(X,Y:integer);
    var i:integer;
    begin
      if (X>=0)and(X<PWordArray(Map)^[4]) and
         (Y>=0)and(Y<PWordArray(Map)^[5]) and
         (getpixelmap(x,y,map)<>kresleni)
      then begin
        Buf[Zapisovat][0]:=X;
        Buf[Zapisovat][1]:=Y;
        Zapisovat:=succ(Zapisovat) mod (200*4);
        PutPixelmap(X,Y,kresleni,map);
      end
    end;

    begin
      fromx:=(fromx-_px) div pwordarray(map)^[2];       {poDIVuj rozteci}
      fromy:=(fromy-_py) div pwordarray(map)^[3];

      if getpixelmap(fromx,fromy,map)=kresleni then
      {neni co vyplnovat}
        exit;

      Cist:=0;
      Zapisovat:=1;
      Buf[0][0]:=fromx;
      Buf[0][1]:=fromy;
      PutPixelmap(fromx,fromy,kresleni,map);
      {v bufferu je uveden seznam uz vyplnenych bodu, pri prochazeni uz se
       nezobrazuji, ale pouze se k nim vyhledaji sousede}
      while Cist<>Zapisovat do begin {dokud nevyprazdnime buffer}
        ZkusBod(Buf[Cist][0],Buf[Cist][1]-1);    {horni bod}
        ZkusBod(Buf[Cist][0],Buf[Cist][1]+1);    {dolni bod}
        ZkusBod(Buf[Cist][0]-1,Buf[Cist][1]);    {levy bod}
        ZkusBod(Buf[Cist][0]+1,Buf[Cist][1]);    {pravy bod}
        Cist:=succ(Cist) mod (200*4)
      end;

      if not kresleni then {pri gumovani masky nejprve obnovime podklad}
        putimage(_px,_py,obr);
        {jinak se maska pouze pridava prip. prepisuje}
      VykresliMapu(_px,_py,Sirka,Vyska)
    end;

  begin
    repeat
      repeat until MouseKey<>0;       {cekej na zmacknuti tlacitka mysi}
      if MouseKey=1 then begin        {leve ===> vypln}
        MouseSwitchOff;
        VyplnOblast(MouseX,MouseY);
        MouseSwitchOn;
        repeat
        until MouseKey<>1
        {pockej na uvolneni tlacitka
         nebude-li zmacknuto nic, bude se priste cekat na novou udalost
         bude-li zmacknuto neco jineho, tak tato udalost projde pristim
           cyklem cekani na udalost a zachyti se na prikazu Break}
      end else                        {jinak konec}
        break
    until false
  end;

  procedure ZmenaBarvyMasky;
  {zmeni barvu aktualni masky}
  begin
    {dovoli zmenit barvu mapy tentokrat i pri gumovani}
    NewMouseArea(0,0,320,200);
    Vyber:=ReadColor(10,10,255,255,
      DColor[5],DColor[3],DColor[1],DColor[2],font,'Zadej barvu mapy :');
    if Vyber<>-1 then
    {je-li vybrana barva, zmen barvu masky}
      ColorGoMap:=Vyber;
    MouseSwitchOff;
    VykresliMapu(_px,_py,Sirka,Vyska)
  end;

const NazevStylu:array[boolean]of string[20] =
        ('guma => ~Kreslení','kreslení => ~Guma');
{mozna mu dat vedet, co PRAVE dela !!!!!!!!!!!!!!!
 to, ze vidi Gumovat, uzivatele subjektivne plete, i kdyz vi, ze to je
 opak toho, co prave dela !!!!!!!!!!!!!!!!!!!!!!}

begin
  Sirka:=PWordArray(Obr)^[0];
  Vyska:=PWordArray(obr)^[1];
  VelX:=5;
  VelY:=5;
{  ColorGoMap:=3;}
  SetRCLimits(-1,-1,-1,-1,-1,-1);

  pushmouse;
  mouseswitchoff;
  {vypneme mys pro nacteni pozadi a vykresleni obrazku}

  NewImage(Sirka,Vyska,UchovPoz);
  GetImage(_px,_py,Sirka,Vyska,UchovPoz);
  PutImage(_px,_py,obr);
  DrawMap(_px,_py,0,0,pwordarray(Map)^[4],pwordarray(Map)^[5],Map);
  {pozadi se ulozilo a obrazek se vykresli v pro nej vyhrazene oblasti +
   + vykresli se pres nej doposud naeditovana mapa}
  Kresleni:=true;

  repeat
    NewMouseArea(0,0,320,200);
    Repeat Until MouseKey=0;
    {pockej na uvolneni tlacitek, nastav celou obrazovku pro pohyb,
     viditelnost ted neni dulezita}
    Vyber:=VytvorMenu('#Vyber si nastroj|Š~tětec|~Obdélníky|'+
      '~Usečky/Polygony|~Elipsy/Kružnice|~Vyplnování|#|'+
      '~Barva mapy|'+NazevStylu[Kresleni]+'|~Zpět',
      DColor[1], DColor[2], DColor[3], DColor[4], DColor[5],
      {    7,25,15,48,96,} font, MenuX[7], MenuY[7], 1,{10}9);
    NewMouseArea(_px,_py,Sirka,Vyska);
    MouseSwitchOn;
    {nastav vyrez obrazku pro pohyb a zapni mys, na uvolneni tlacitek
     pocka dialog sam}
{DOUFAM !!!!!!!!!!!!!!!!!}
    case Vyber of
      1 : KresliStetcem;
      2 : KresliObdelniky;
      3 : KresliUsecky;
      4 : KresliElipsy;
      5 : KresliVypln;
      6 : ZmenaBarvyMasky;
      7 : Kresleni := not Kresleni;
{      9 : OtestujChuzi}
    end
  until Vyber={10}8;
  {editor map skonci vyvolanim jiste polozky v menu}

  NewMouseArea(0,0,320,200);
  repeat until MouseKey=0;
  MouseSwitchOff;
  PutImage(_px,_py,UchovPoz);
  DisposeImage(UchovPoz);

  popmouse
  {nastavi se cela obrazovka pro pohyb, pocka se na uvolneni tlacitek,
   obnovi se pozadi a viditelnost mysi se nastavi na puvodni hodnotu}
end;





end.
