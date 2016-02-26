{!!!Bob: pridano dalsi menu, viz. gm3 44->45}

 {zde je SRAF ulozen logicky jako cislo, ale uzivateli by se mela dat moznost
 udelat vyber z nekolika slovy posapnych prip. nakreslenych moznosti !!!!!
 treba i za cenu dalsiho dialogu}

unit gmu3;

interface

uses Graph256, Graform, users, editor, dialog, files, dfw, TestGo;

type TIkony =  array[0..5] of record        { rozmisteni ikon }
                             X : word;
                             Y : word;
                             P : pointer;
                           end;


var DColor : Array[1..5] of byte;        { barvy }
    SaveC  : Array[1..10] of byte;

    Ikony, Ikony1 : TIkony;
    MouseImage1 : pointer;
const poccest=5;
      nap:array[1..poccest]of string[20]=
        ('~Fonty','~Obrazky','~Hudby','~Animace','Sys. fo~nt');
    NoRemapPicture : boolean = true;

      MaxPRI = 20;
      MaxOBJ = 50;
var
      MenuX : array[1..45] of integer;
      MenuY : array[1..45] of integer;
      MenuZ : array[1..45] of integer;

Type TRPal=array[1..4] of record
             f, t : Integer;
             w : byte;
           end;

     pkonf=^tkonf;
     tkonf=record
       cesty:array[1..poccest]of string;
       sraf,paleta:byte;
       krobrazky,krmasky,krmapy:boolean
     end;

     pnovahra=^tnovahra;
     tnovahra=record
       jmenohry,postava,prvamistnost:string[80];
       fonty : string;
       vyrez,roztecx,roztecy:byte;
       {roztece jsou prave nove}
       pocobr:string;
       AktRoom : string;

       Prog : pointer;
       ProgSize : word;
     end;

     pnovamist=^tnovamist;
     tnovamist=record
       jmeno,hudba:string;
       mys,postava,typobrazku:boolean;
       font:string;
       barva:byte;    {je-li 255, bere se ohled na pozadi}
       pozadi:string;
       paleta : string;
       Pal, Image, Filter, GoMap : pointer;
       BarvaMapyChuze : byte;
       ZpusobVykresleni : byte;
       Chuze : byte;
       PLin, PAbs : real;
       RotacePal : TRPal;
       PrikazyMysi : array[1..MaxPRI] of byte;
       Objekty : array[1..MaxObj] of record
         jmeno : string[8];
         Cis : byte;
         P : pointer;
       end;
     end;

     pnovyobjekt=^tnovyobjekt;
     tnovyobjekt=record
       X, Y : integer;    { umisteni objektu }
       Priorita : integer; { jek je obj vysoko poziti u napr. ptaka }
       NahratHned : byte; { 0.. ne   / 1.. ano}
       JeObrazek  : byte; { 0.. nein / 1.. je }
       JeIkona    : byte; { 0.. nein / 1.. je }
       Image, GoMap, Ikona, IntProg, InitProg : pointer;
       InitProgSize : word;
       IntProgSize : word;
       prikazy : array[1..MaxPRI] of record
         prog : pointer;
         size : word;
       end;
     end;

var konf : tkonf;
    game : pnovahra;
    cilovacesta : string;
    mist : pnovamist;
    obj  : pnovyobjekt;
    ReMapImages : boolean;
    MaxConvert : byte;
    convert : array[1..256] of record
      old, new : byte;
    end;

procedure MarkImage(var MinX, MinY, Sirka, Vyska :integer; UsePage, WithWhat:byte);
function  ChooseImage(var P : pointer; page1, page2 : byte) : boolean;
function  ReadText(var X, Y : integer; Del:integer; Vyzva : string;
  Vstup:string) : string;
function  ReadInteger(var X, Y : integer; Del:integer; Vyzva : string;
                      Min,Max,Vstup:longint) : longint;
procedure VyberSouborAdresar(var VA : string; s : string);
procedure nactivztah(Podkl:pointer;Barva:byte;var Lin,Abs:real);
  {vrati cleny linearni rovnice, aby se dostala opravdova velikost panacka}
procedure NastavSRotaci(var rotace : TRPal);
procedure NactiRotaciPal(AktPal : pointer; var rotace : TRPal);
procedure ChangeHigh(X,Y : integer; var Long : integer; Color : byte);
procedure ChangeHighMask(Y : integer; var Long : integer; Color : byte);
function  FindNearestColor(color : byte;pal1, pal2 : PPalette) : byte;
procedure RemapPicture(picture, p : PByteArray; InPal, ItsPal : PPalette);
procedure RemapAll;


implementation


procedure MarkImage(var MinX, MinY, Sirka, Vyska :integer; UsePage, WithWhat:byte);
Var CirBuf : Array[0..200*2-1,0..1] of Integer;
    PRead,PWrite:integer;
    Trans : Pointer;
    IPart, OldPage : Byte;
    XPos, YPos : Integer;
  procedure TestPixel(XPos,YPos:integer);
  begin
    {Otestuje hranice, podle nich meni promenne}
    If (XPos>=0)and(XPos<320) and
       (YPos>=0)and(YPos<200) and
       (GetPixel(XPos,YPos)<>WithWhat)then
       begin
         CirBuf[PWrite][0]:=XPos;
         CirBuf[PWrite][1]:=YPos;
         PWrite:=succ(PWrite) mod (200*2);
         PutPixel(XPos,YPos,WithWhat);
         If XPos<MinX then MinX:=XPos;
         If XPos>Sirka then Sirka:=XPos;
         If YPos<MinY then MinY:=YPos;
         If YPos>Vyska then Vyska:=YPos;
       end;
  end;
begin
  OldPage:= ActivePage;
  MouseSwitchOff;
  IPart:=0; {Nastavi cast obrazku, ktera se ma brat}
  NewImage(320,10,Trans); {Potrebuje to jen asi 3,3 kilecka}
  Repeat
    GetImage(0,IPart,320,10,Trans); {Vezme cast obr. z pracovni stranky}
    SetActivePage(UsePage); {Prepne si to do svoji stranky}
    PutImage(0,IPart,Trans); {Vyplivne kousek obrazku}
    Inc(IPart,10); {Zvysi ukazatel pozice Y}
    If IPart<>200 then SetActivePage(OldPage); {Test, ma-li prepnout stranku}
  Until IPart=200; {Podminka konce}
  DisposeImage(Trans); {Uvolni pamet po mezibufferu}
  XPos:= MinX;
  YPos:= MinY;
  Sirka:= XPos; {Nastavi pozice}
  Vyska:= YPos;
  PRead:=0;
  PWrite:=1;
  CirBuf[0][0]:=XPos;
  CirBuf[0][1]:=YPos;
  PutPixel(XPos,YPos,WithWhat);
  while PRead<>PWrite do begin {dokud nevyprazdnime buffer}
    TestPixel(CirBuf[PRead][0],CirBuf[PRead][1]-1);    {horni bod}
    TestPixel(CirBuf[PRead][0],CirBuf[PRead][1]+1);    {dolni bod}
    TestPixel(CirBuf[PRead][0]-1,CirBuf[PRead][1]);    {levy bod}
    TestPixel(CirBuf[PRead][0]+1,CirBuf[PRead][1]);    {pravy bod}
    PRead:=Succ(PRead) mod (200*2)
  end;
  SetActivePage(OldPage);
  Dec(Sirka, MinX-1);
  Dec(Vyska, MinY-1);
{  RecTangle(MinX-1,MinY-1,Sirka+3,Vyska+3,12); {Vykresli hranice barvou 12}
  MouseSwitchOn;
end;

function  ChooseImage(var P : pointer; page1, page2 : byte) : boolean;
var vybral : string;
    pal : pointer;
    code : byte;
    X, Y, Sirka, Vyska : integer;
    OldPage : byte;
begin
  OldPage:= ActivePage;
  MouseSwitchOff;
  SetActivePage(page1);
  SetVisualPage(page1);
  ClearScr(255);
  ChooseImage:=false;
  vybral:=vybersouboru(MenuX[1], MenuY[1], MenuZ[1],
    DColor[1], DColor[2], DColor[3], DColor[4], DColor[5], font,
    trid_pripony, Konf.Cesty[2],'*.pcx;*.bmp;*.gcf;*.gcc');
  MouseSwitchOff;
  if Vybral[1]=#27 then begin
    SetVisualPage(OldPage);
    SetActivePage(OldPage);
    MouseSwitchOn;
    exit;
  end;
  p:=nil;
  code:=LoadImage(p,pal,vybral);
  case code of
    0 : begin
          SetVisualPage(OldPage);
          SetActivePage(OldPage);
          MouseSwitchOn;
          exit;
        end;
    255 : FreeMem(Pal,768);
  end;

  PutImagePart(0,0,0,0,320,200,p);
  MouseSwitchOn;
  repeat until MouseKey<>0;
  if MouseKey<>1 then begin
    DisposeImage(P);
    MouseSwitchOff;
    SetVisualPage(OldPage);
    SetActivePage(OldPage);
    MouseSwitchOn;
    exit;
  end;
  X:=MouseX;
  Y:=MouseY;
  MarkImage(X,Y,sirka,Vyska,page2,255);
  if (sirka=1)or(Vyska=1) then begin
    DisposeImage(P);
    MouseSwitchOff;
    SetVisualPage(OldPage);
    SetActivePage(OldPage);
    MouseSwitchOn;
    exit;
  end;
  MouseSwitchOff;
  DisposeImage(P);
  NewImage(Sirka,Vyska,P);
  GetImage(X,Y,Sirka,Vyska,P);
  ChooseImage:=true;
  MouseSwitchOff;
  SetVisualPage(OldPage);
  SetActivePage(OldPage);
  MouseSwitchOn;
end;

function ReadText(var X, Y : integer; Del:integer; Vyzva : string;
  Vstup:string) : string;
{pri enter vrati nacteni retezec, pri escape vrati retezec #27 (Cescape znak)}
var ed:peditor;
begin
  AlokujEditor(ed);
  NastavEdOkno(ed, {X,Y,Del}x,y,del, {Vyzva}Vyzva,
    {font nadpisu a textu}font,font, {okno}true);
  NastavEdBarvy(ed,{bpopr:=}DColor[1],{bpoz:=}DColor[2],{bnadp:=}DColor[3],{bkurs:=}DColor[5],
    {binv:=}DColor[4],{bokr:=}DColor[5],{bpos:=}DColor[5]);
{nastavit lepsi barvy, prip. to dat do globalni promenne, at se nemusi porad
 opisovat a at se mohou globalne zmenit zmenou jednoho pole a nebo to
 udelat tak, jak to maji v tv2}
  NastavEdProstredi(ed, {posuvniky}true, zadnerolovani, musibyttext,
    {EscN:=}[#27],{EscR:=}[], {EntN:=}[#13],{EntR:=}[]);
  NastavEdParametry(ed, {pocinv}true,{urmez}true,{prubor}false,
    {muzpres}false,{vracchyb}false,{format}false,{delka}254,
    StandardniPovZn,StandardniOddelovace);
  NastavEdObsah(ed, {edtext}Vstup, {sour}1,{zacina}1);

  EditaceTextu(ed);
  x:=ed^.sx;
  y:=ed^.sy;
  if ed^.ukakce in [1,3] then           {enter znak}
    ReadText:=ed^.edtext
    {pri enter vrati napsany retezec}
  else                                  {escape znak}
    ReadText:=#27;
    {pri escape vrati #27 (znak escape)
     pozn. nehrozi konflikt s jinym moznym napsanym retezcem, nebot znak
           #27 neni ve fontech, neni ani obvekle povolen, uzivatel ho
           nemuze zadat (stejne je mu na nic), takze tento vysledek
           jednoznacne udava, ze bylo zmacknuto escape}
  DeAlokujEditor(ed)
end;

function ReadInteger(var X, Y : integer; Del:integer; Vyzva : string;
                     Min,Max,Vstup:longint) : longint;
{vraci pri zmacknuti enter zadane cislo, pri zmacknuti escape vrati
 standardni predvolene cislo
 vraci typ longint, ale taky ma parametry pro minimalni a maximalni hodnotu
 ===> muze se pouzit i pro cteni byte, integer atp...}
var ed:peditor;
    cislo:longint;
    chyba:integer;
begin
  AlokujEditor(ed);
  NastavEdOkno(ed, {X,Y,Del}x,y,del, {Vyzva}Vyzva,
    {font nadpisu a textu}font,font, {okno}true);
  NastavEdBarvy(ed,{bpopr:=}DColor[1],{bpoz:=}DColor[2],{bnadp:=}DColor[3],{bkurs:=}DColor[5],
    {binv:=}DColor[4],{bokr:=}DColor[5],{bpos:=}DColor[5]);
(*  NastavEdBarvy(ed,{bpopr:=}7,{bpoz:=}35,{bnadp:=}15,{bkurs:=}15,
    {binv:=}48,{bokr:=}96,{bpos:=}15); *)
{nastavit lepsi barvy, prip. to dat do globalni promenne, at se nemusi porad
 opisovat a at se mohou globalne zmenit zmenou jednoho pole a nebo to
 udelat tak, jak to maji v tv2}
  nastavedmezecisel(min,max);
  NastavEdProstredi(ed, {posuvniky}true, zadnerolovani, musibytcislo,
    {EscN:=}[#27],{EscR:=}[], {EntN:=}[#13],{EntR:=}[]);
  NastavEdParametry(ed, {pocinv}true,{urmez}true,{prubor}false,
    {muzpres}false,{vracchyb}false,{format}false,{delka}254,
    StandardniPovZn,StandardniOddelovace);
  NastavEdObsah(ed, {edtext - viz. dale}'', {sour}1,{zacina}1);
  Str(Vstup,ed^.edtext);

  EditaceTextu(ed);
  x:=ed^.sx;
  y:=ed^.sy;
  if ed^.ukakce in [1,3] then begin     {enter znak}
    val(ed^.edtext,cislo,chyba);
    {chybu vystupniho cisla nemusime kontrolovat, to editor udela za nas}
    readinteger:=cislo
  end else                              {escape znak}
    readinteger:=vstup;
    {pri zmacknuti escape se vrati standardni predvolene cislo}
  DeAlokujEditor(ed)
end;

procedure VyberSouborAdresar(var VA : string; s : string);
var path,p2 : string;
    i : byte;
begin
  p2:=va;
  i:=length(p2);
  while (p2[i]<>'.')and(i<>0) do dec(i);
  if i<>0 then begin
    i:=length(p2);
    while (p2[i]<>'\')and(i<>0) do dec(i);
    p2[0]:=char(i);
  end;
  path:=vybersouboru(MenuX[2], MenuY[2], MenuZ[2], DColor[1], DColor[2],
    DColor[3], DColor[4], DColor[5], Font, trid_pripony,p2,s);
  if path[1]<>#27 then VA:=path;
end;

procedure nactivztah(Podkl:pointer;Barva:byte;var Lin,Abs:real);
  {vrati cleny linearni rovnice, aby se dostala opravdova velikost panacka}
var i:byte;
    v:array[1..2]of record p,v:integer end;
    x,y,_x,_y,y1:integer;
    Obr : pointer;
begin
  if CLoadItem(JmenoHrdiny+'.an1',Obr,2) = 0 then begin
    StandardniDialog('Neni animace draka!|(oprav v INICIALIZACE HRY)',
      DColor[1], DColor[2], DColor[3], DColor[4],
      DColor[5], font, upozorneni);
    GetMem(obr,GetSizeImage(Ikony[4].P));
    move(Ikony[4].P,obr^,GetSizeImage(Ikony[4].P));
  end;
  PushMouse;
  MouseSwitchOff;
{  StandardniDialog('Nyni potrebuji vedet,|kde a jak bude hlavni|'
    + 'hrdina vysoky', DColor[1], DColor[2], DColor[3], DColor[4],
      DColor[5], font, upozorneni);}
  if Barva=255 then PutImage(0, 0, PodKl);
  for i:=1 to 2 do begin
    StandardniDialog('Klikni nekam a roztahni|na tom miste ramecek|'+
      'podle toho, jak|velky tam bude hlavni|hrdina', DColor[1], DColor[2],
      DColor[3], DColor[4], DColor[5], font, upozorneni);
    {sam si mys zapne}
    PushMouse;
    NewMouseArea(0,0,320-pwordarray(obr)^[0]+1,game^.vyrez-pwordarray(obr)^[1]+1);
    MouseOn(0,0,Obr);
    repeat until MouseKey<>0;
    PopMouse;
    {obnovi MouseSwitchOff}
    x:=mousex; y:=mousey;
    newmousearea(x+2,y+2,320-x-2,game^.vyrez-y-2);
{je asi potreba 2 misto 1 pro spatnou zoom-proceduru
 (kvuli tobe, Lukasi), ale myslim, ze to jelo i s 1}
    newmousexy(x,y+pwordarray(obr)^[1]-1);
    repeat
      _y:=MouseY-Y+1;
      _x:=PWordArray(Obr)^[0] * _y div PWordArray(Obr)^[1];
      PutMaskImagePartZoom(X, Y, _x, _y, 0, 0, 320, 200, Obr);
      {putni panacka}
{neslo by to bez toho masku ?????
 ale toto je mozna lespi a efektnejsi !!!!!!!!!!!!!!!!!!!!!!
 ale stejne se to o bod pretiskne (!!!), takze se to bude muset predelat}
      y1:=mousey;
      repeat
      until (mousekey=0)or(mousey<>y1);
      if Barva=255
        then PutImagePart(0,0, X,Y,_x+3,_y+3, Podkl)
        else Bar(X,Y,_x,_y,Barva);
      {obnov podklad}
    until MouseKey=0;
    v[i].p:=mousey;
    v[i].v:=mousey-y+1;
    newmousearea(0,0,320,200);
    repeat until MouseKey=0
  end;
  Lin:=((v[1].v-v[2].v)/(v[1].p-v[2].p))/pwordarray(obr)^[1];
  Abs:=(v[1].v-v[1].p*(v[1].v-v[2].v)/(v[1].p-v[2].p))/pwordarray(obr)^[1];
                   {\=== to je Lin}
{osetrit deleni 0 !!!!! tj. oba dva snimky na stejnem radku (na stejne ci
 ruzne velikosti pak uz nezalezi)}
  PopMouse;
  DisposeImage(Obr);
end;

procedure NastavSRotaci(var rotace : TRPal);
begin
  rotace[1].f:=-1;
  rotace[2].f:=-1;
  rotace[3].f:=-1;
  rotace[4].f:=-1;
end;

procedure NactiRotaciPal(AktPal : pointer;var rotace : TRPal);
var i : byte;
    Rotuje : boolean;
    pal : pointer;
    volba1:integer;
  function SetRotate(i : byte) : boolean;
  var f, t, w : integer;
      s : string;
  begin
    SetRotate:=false;
    rotace[i].f:=-1;
    rotace[i].t:=-1;
    Str(i,s);
    SetRCLimits(rotace[1].f, rotace[1].t, rotace[2].f, rotace[2].t,
      rotace[3].f, rotace[3].t);
    f:=ReadColor(MenuX[3], MenuY[3], rotace[4].f, rotace[4].t,
      DColor[5],DColor[3],DColor[1],DColor[2], font, 'Dolní hranice '+s+' rotace:');
    if f=-1 then exit;
    SetRCLimits(rotace[1].f, rotace[1].t, rotace[2].f, rotace[2].t,
      rotace[3].f, rotace[3].t);
    t:=ReadColor(MenuX[3], MenuY[3], rotace[4].f, rotace[4].t,
      DColor[5],DColor[3],DColor[1],DColor[2], font, 'Horní hranice '+s+' rotace:');
    if t=-1 then exit;
    w:=ReadInteger(MenuX[3], MenuY[3], 150, 'Zadej prodlevu:', 1,100,0);
    if w=-1 then exit;
    rotace[i].f:=f;
    rotace[i].t:=t;
    rotace[i].w:=w;
    SetRotate:=true;
    if rotuje then begin
      DoneRotatePal;
      InitRotatePal(
        rotace[1].f, rotace[1].t, rotace[1].w,
        rotace[2].f, rotace[2].t, rotace[2].w,
        rotace[3].f, rotace[3].t, rotace[3].w,
        rotace[4].f, rotace[4].t, rotace[4].w,palette);
    end;
  end;
begin
  GetMem(pal,768);
  Move(AktPal^ ,pal^, 768);
  Rotuje:=false;
  volba1:=1;
  repeat
    repeat until MouseKey=0;
      Volba1:= VytvorMenu('#ROTACE PALETY|Nastavit ~1. rotaci|'
        +'Nastavit ~2. rotaci|Nastavit ~3. rotaci|Nastavit ~4. rotaci|'
        +'~Nastavit všechny rotace|#|~Test rotací ZAP./VYP.|~Zpět',
        DColor[1], DColor[2], DColor[3], DColor[4], DColor[5], font,
        MenuX[4], MenuY[4], Volba1, 7);

    case Volba1 of
      1..4 : begin
               Move(Pal^ ,Aktpal^, 768); {Zde Nutno Dodelat  !!!!!!}
               SetPalette(Pal);
               SetRotate(Volba1);
               Move(Pal^ ,Aktpal^, 768);
             end;
      5 : for i:=1 to 4 do if not SetRotate(i) then i:=4;
      6 : begin
            if Rotuje then begin
              DoneRotatePal;
              Move(Pal^ ,Aktpal^, 768);
              SetPalette(Pal);
            end else InitRotatePal(
              rotace[1].f, rotace[1].t, rotace[1].w,
              rotace[2].f, rotace[2].t, rotace[2].w,
              rotace[3].f, rotace[3].t, rotace[3].w,
              rotace[4].f, rotace[4].t, rotace[4].w,AktPal);
            Rotuje := not Rotuje;
          end;
    end;
  until Volba1 = 7;
  DoneRotatePal;
  Move(pal^, AktPal^, 768);
  SetPalette(AktPal);
  FreeMem(pal,768);
end;

procedure ChangeHigh(X,Y : integer; var Long : integer; Color : byte);
var OldY : integer;
begin
  MouseSwitchOff;
  NewMouseXY(MouseX,Long+Y);
  repeat
    XorLineY(X, Y, MouseY-Y, Color);
    XorLineY(X+1, Y, MouseY-Y, Color);
    XorLineY(X+2, Y, MouseY-Y, Color);
    XorLineX(0, MouseY, 319, Color);
    OldY:= MouseY;
    repeat until (MouseY<>OldY)or(MouseKey<>0);
    XorLineY(X, Y, OldY-Y, Color);
    XorLineY(X+1, Y, OldY-Y, Color);
    XorLineY(X+2, Y, OldY-Y, Color);
    XorLineX(0, OLdY, 319, Color);
  Until MouseKey<>0;
  if MouseKey = 1 then Long:= MouseY-Y;
  MouseSwitchOn;
end;

procedure ChangeHighMask(Y : integer; var Long : integer; Color : byte);
var OldX, OldY : integer;
begin
  MouseSwitchOff;
  NewMouseXY(MouseX,Long+Y);
  repeat
    XorLineY(MouseX, Y, MouseY-Y, Color);
    XorLineY(MouseX+1, Y, MouseY-Y, Color);
    XorLineY(MouseX+2, Y, MouseY-Y, Color);
    XorLineX(0, MouseY, 319, Color);
    OldY:= MouseY;
    OldX:= MOuseX;
    repeat until (MouseX<>OldX)or(MouseY<>OldY)or(MouseKey<>0);
    XorLineY(OldX, Y, OldY-Y, Color);
    XorLineY(OldX+1, Y, OldY-Y, Color);
    XorLineY(OldX+2, Y, OldY-Y, Color);
    XorLineX(0, OLdY, 319, Color);
  Until MouseKey<>0;
  if MouseKey = 1 then Long:= MouseY-Y;
  MouseSwitchOn;
end;

function  FindNearestColor(color : byte;pal1, pal2 : PPalette) : byte;
var Col, i1,r,g,b : byte;
    Block : integer;
begin
  r:=pal1^[color*3];
  g:=pal1^[color*3+1];
  b:=pal1^[color*3+2];
  Block:=255;
  i1:=0;
  while (i1<>255)and(Block<>0)do begin
    if Abs(R-pal2^[i1*3])+abs(G-pal2^[i1*3+1])+abs(B-pal2^[i1*3+2]) < Block then begin
      FindNearestColor:=i1;
      Block:=Abs(R-pal2^[i1*3])+abs(G-pal2^[i1*3+1])+abs(B-pal2^[i1*3+2]);
    end;
    inc(i1);
  end;
end;


procedure RemapPicture(picture, p : PByteArray; InPal, ItsPal : PPalette);
var size : integer;
    i : byte;
    ii : word;
begin
  size:=GetSizeImage(picture);
{  MaxConvert:=0;}
  i:=0;
  for ii:=4 to size-1 do begin
    for i:=1 to MaxConvert do if convert[i].old=picture^[ii] then break;
    if (i<=MaxConvert)and(convert[i].old<>p^[ii]) then begin
      i:=FindNearestColor(p^[ii],ItsPal,InPal);
      Inc(MaxConvert);
      convert[MaxConvert].old:=picture^[ii];
      convert[MaxConvert].new:=i;
    end else i:=convert[i].new;
    if p^[ii]<>255 then picture^[ii]:=i;
  end;
end;

procedure RemapAll;
var i : byte;
begin
  if ReMapImages or NoRemapPicture then exit;
  MaxConvert:=0;
  if konf.paleta=2 then begin
    for i:=0 to 5 do RemapPicture(ikony[i].P,ikony1[i].P,Palette,Palette);
    RemapPicture(MouseImage,MouseImage1,Palette,Palette)
  end else begin
    for i:=0 to 5 do RemapPicture(ikony[i].P,ikony1[i].P,Mist^.pal,Palette);
    RemapPicture(MouseImage,MouseImage1,Mist^.pal,Palette);
  end;
  ReMapImages:=true;
end;

var i : byte;

begin
  DColor[1]:= 15;
  DColor[2]:= 7;
  DColor[3]:= 12;
  DColor[4]:= 10;
  DColor[5]:= 8;
  SaveC[1]:=15;
  savec[2]:= 7;
  savec[3]:= 12;
  savec[4]:= 10;
  savec[5]:= 8;
  SaveC[6]:=15;
  savec[7]:= 7;
  savec[8]:= 12;
  savec[9]:= 10;
  savec[10]:= 8;
  { * * * IKONY * * *}
  Ikony[0].X := 265;
  Ikony[0].Y := 23;
  Ikony[1].X := 240;
  Ikony[1].Y := 46;
  Ikony[2].X := 250;
  Ikony[2].Y := 69;
  Ikony[3].X := 254;
  Ikony[3].Y := 92;
  { * * * Konf * * * }
  konf.cesty[1]:='C:\';
  konf.cesty[2]:='C:\';
  konf.cesty[3]:='C:\';
  konf.cesty[4]:='C:\';
  konf.cesty[5]:='stand2.fon';
  konf.sraf:=5;
  konf.paleta:=2;
  konf.krobrazky:=true;
  konf.krmasky:=false;
  konf.krmapy:=false;
  { cilovacesta }
  GetDir(0,cilovacesta);
  cilovacesta:=cilovacesta+'\';

  mist:= nil;
  obj:=nil;

  for i:=1 to 45 do begin
    MenuX[i]:=30+Random(40);
    MenuY[i]:=20+Random(20);
    MenuZ[i]:=13;
  end;
  MenuX[39]:=100;
  MenuY[39]:=100;
  MenuX[43]:=100;
  MenuY[43]:=100;
  MenuX[45]:=0;
  MenuY[45]:=0;
  ReMapImages:=false;
end.
