unit gmu;

interface

Uses graform, Graph256, Dialog, Editor, Files, Users, Dfw, Dos;

const MaxPrikaz = 10; { Maximalni pocet prikazu }

Type TRPal=array[1..4] of record
             f, t : Integer;
             w : byte;
           end;

var DColor1, DColor2, DColor3, DColor4, DColor5 : byte;

    InfMenu : array[byte] of record { prom. potrebne pro zobrazeni dialogu }
                X, Y, Pocet, Volba : integer;
              end;

    Ikony : array[0..4] of record        { rozmisteni ikon }
                             X : word;
                             Y : word;
                             P : pointer;
                           end;

    ZdrojovaCesta : string; { cesta odkud se nahravaji data }
    CilovaCesta   : string; { cesta kam se nahrava naeditovana hra(*.mis,...)}
    NameFont      : string;
    Quit : boolean;          { Kdyz true je pozadavek o skonceni programu }
    AutoSave      : boolean; { automaticke ukladani          }
    KteraPaleta   : byte;    { moje/obrazku viz. konfig menu }
    ZpusobKresleni : byte;   { zpusob kresleni stranky z konfigu }
    NameGAM : SearchRec;        { Jmeno teto hry Name.Name }
    NameMIS : SearchRec;        { Jmeno otevrene mistnosti }

procedure MarkImage(var MinX, MinY, Sirka, Vyska :integer; UsePage, WithWhat:byte);
procedure ChangeHigh(X,Y : integer; var Long : integer; Color : byte);
function  ChooseImage(var P : pointer; page1, page2 : byte) : boolean;
procedure SetGamePart(var X,Y, Long : integer;var p : pointer);
function  ReadText(var X, Y : integer; Del:integer; Vyzva : string;
  Vstup:string) : string;
function  ReadInteger(var X, Y : integer; Del:integer; Vyzva : string;
                      Min,Max,Vstup:longint) : longint;
procedure SetMouseKurzor;
procedure nactivztah(Podkl,Obr:pointer;var Lin,Abs:real);
procedure NastavSRotaci(var rotace : TRPal);
procedure NactiRotaciPal(AktPal : pointer; var rotace : TRPal);

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

procedure ChangeHigh(X,Y : integer; var Long : integer; Color : byte);
var OldY : integer;
begin
  MouseSwitchOff;
  NewMouseXY(MouseX,Long+Y);
  repeat
    XorLineY(X, Y, MouseY-Y, Color);
    XorLineY(X+1, Y, MouseY-Y, Color);
    XorLineY(X+2, Y, MouseY-Y, Color);
    OldY:= MouseY;
    repeat until (MouseY<>OldY)or(MouseKey<>0);
    XorLineY(X, Y, OldY-Y, Color);
    XorLineY(X+1, Y, OldY-Y, Color);
    XorLineY(X+2, Y, OldY-Y, Color);
  Until MouseKey<>0;
  if MouseKey = 1 then Long:= MouseY-Y;
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
  vybral:=vybersouboru(InfMenu[1].X,InfMenu[1].Y,InfMenu[1].Pocet,
    DColor1, DColor2, DColor3, DColor4, DColor5, font, trid_pripony,
    ZdrojovaCesta,'*.bmp;*.gcf;*.gcc');
  MouseSwitchOff;
  if Vybral[1]=#27 then begin
    SetVisualPage(OldPage);
    SetActivePage(OldPage);
    MouseSwitchOn;
    exit;
  end;
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

procedure SetGamePart(var X,Y, Long : integer;var p : pointer);
var LongStr : string;
begin
  X:=-32767;
  MouseSwitchOff;
  SetActivePage(1);
  SetVisualPage(1);
  NewMouseXY(MouseY,Long);
  repeat
    Str(Long,LongStr);
    Long:=MouseY;
    if Long<>0 then Bar(0,0,320,Long,1);
    PrintText(10,180,'Vyska: '+LongStr,font);
    if 199-Long<>0 then Bar(0,Long,320,199-Long,2);
    PrintText(10,180,'Vyska: '+LongStr,font);
  until MouseKey<>0;
  NewMouseXY(MouseX,MouseY);
  Inc(Long);
  if Long=200 then begin
    if not ChooseImage(p,1,2) then begin
      MouseSwitchOff;
      SetActivePage(0);
      SetVisualPage(0);
      MouseSwitchOn;
      exit;
    end;
    MouseSwitchOff;
    ClearScr(1);
    PushMouse;
    MouseOn(0,0,p);
    repeat until MouseKey<>0;
    if MouseKey<>1 then PopMouse
    else begin
      X:=MouseX;
      Y:=MouseY;
      PopMouse;
    end;
  end;
  SetActivePage(0);
  SetVisualPage(0);
  MouseSwitchOn;
  NewMouseXY(MouseX,MouseY);
end;

function ReadText(var X, Y : integer; Del:integer; Vyzva : string;
  Vstup:string) : string;
{pri enter vrati nacteni retezec, pri escape vrati retezec #27 (Cescape znak)}
var ed:peditor;
begin
  AlokujEditor(ed);
  NastavEdOkno(ed, {X,Y,Del}x,y,del, {Vyzva}Vyzva,
    {font nadpisu a textu}font,font, {okno}true);
  NastavEdBarvy(ed,{bpopr:=}DColor1,{bpoz:=}DColor2,{bnadp:=}DColor3,{bkurs:=}DColor5,
    {binv:=}DColor4,{bokr:=}DColor5,{bpos:=}DColor4);
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
  NastavEdBarvy(ed,{bpopr:=}DColor1,{bpoz:=}DColor2,{bnadp:=}DColor3,{bkurs:=}DColor5,
    {binv:=}DColor4,{bokr:=}DColor5,{bpos:=}DColor4);
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

procedure SetMouseKurzor;
  procedure EditovatPrikaz;
  var jmeno : string;
      p : array[1..3] of pointer;
      cis : ^integer;
  begin
    jmeno:=vybersouboru(InfMenu[3].X,InfMenu[3].Y,InfMenu[3].Pocet,
      DColor1, DColor2, DColor3, DColor4, DColor5, font, trid_pripony, CilovaCesta,
      '*.PRI');
    if jmeno[1]=#27 then exit;
    repeat
      InfMenu[6].Volba:=vytvormenu('#Prikazy ovladani:|Editace ~Ikony prikzu|Editace ~normalni mysi|Editace ~aktivni mysi|'
        +'~Zpet',DColor1, DColor2, DColor3, DColor4, DColor5, font, InfMenu[6].X, InfMenu[6].Y, InfMenu[6].Volba, 4);
      if InfMenu[6].Volba<4 then begin
        CLoadItem(jmeno,p[1],1);
        CLoadItem(jmeno,p[2],2);
        CLoadItem(jmeno,p[3],3);
        CLoadItem(jmeno,Pointer(Cis),4);
        DisposeImage(p[InfMenu[6].Volba]);
        if ChooseImage(p[InfMenu[6].Volba],1,2) then begin
          DeleteFile(jmeno);
          CAddFromMemory(jmeno,p[1],GetSizeImage(p[1]));
          CAddFromMemory(jmeno,p[2],GetSizeImage(p[2]));
          CAddFromMemory(jmeno,p[3],GetSizeImage(p[3]));
          CAddFromMemory(jmeno,cis,2);
        end else GetImage(0,0,1,1,p[InfMenu[6].Volba]);
        FreeMem(Cis,2);
        DisposeImage(p[3]);
        DisposeImage(p[2]);
        DisposeImage(p[1]);
      end;
    until InfMenu[6].Volba=4;
  end;
  procedure VytvoritPrikaz;
  var jmeno, s : string;
      p : array[1..3] of pointer;
      cis : ^integer;
      code : integer;
  begin
    jmeno:=ReadText(InfMenu[4].X, InfMenu[4].Y, 180, 'Zadej jmeno prikazu:','');
    if jmeno=#27 then exit;
    jmeno:=CilovaCesta+jmeno+'.pri';
    if ExistFile(jmeno) then begin
      standardnidialog('Prikaz s timto jmenem uz existuje!',
        DColor1, DColor2, DColor3, DColor4, DColor5, font, berunavedomi);
        exit;
    end;
    New(Cis);
    repeat
      s:=ReadText(InfMenu[8].X, InfMenu[8].Y, 150, 'Zadej poradove cislo:','');
      if s=#27 then begin
         Dispose(Cis);
         exit;
      end;
      val(s,cis^,code);
    until (Cis^>0)and(Cis^<MaxPrikaz+1);
    if not ChooseImage(p[1],1,2) then begin
      Dispose(Cis);
      exit;
    end;
    if not ChooseImage(p[2],1,2) then begin
      Dispose(Cis);
      DisposeImage(p[1]);
      exit
    end;
    if not ChooseImage(p[3],1,2) then begin
      Dispose(Cis);
      DisposeImage(p[2]);
      DisposeImage(p[1]);
      exit
    end;
    CAddFromMemory(jmeno,p[1],GetSizeImage(p[1]));
    CAddFromMemory(jmeno,p[2],GetSizeImage(p[2]));
    CAddFromMemory(jmeno,p[3],GetSizeImage(p[3]));
    CAddFromMemory(jmeno,cis,2);
    Dispose(Cis);
    DisposeImage(p[3]);
    DisposeImage(p[2]);
    DisposeImage(p[1]);
  end;
  procedure SmazatPrikaz;
  var jmeno : string;
  begin
    jmeno:=vybersouboru(InfMenu[5].X,InfMenu[5].Y,InfMenu[5].Pocet,
      DColor1, DColor2, DColor3, DColor4, DColor5, font, trid_pripony, CilovaCesta,
      '*.PRI');
    if jmeno[1]=#27 then exit;
    if standardnidialog('Jses si opravdu jisty s prikazem|'+Jmeno,
    DColor1, DColor2, DColor3, DColor4, DColor5, font, ano_ne) <> 1 then Exit;
    DeleteFile(jmeno);
  end;
  procedure UkazkaObrazku;
  var jmeno : string;
      p : array[1..3] of pointer;
      Cis : ^integer;
      s : string;
  begin
    MouseSwitchOff;
    SetActivePage(1);
    SetVisualPage(1);
    ClearScr(50);
    jmeno:=vybersouboru(InfMenu[7].X,InfMenu[7].Y,InfMenu[7].Pocet,
      DColor1, DColor2, DColor3, DColor4, DColor5, font, trid_pripony, CilovaCesta,
      '*.PRI');
    MouseSwitchOff;
    if jmeno[1]=#27 then begin
      SetActivePage(0);
      SetVisualPage(0);
      MouseSwitchOn;
      exit;
    end;

    CLoadItem(jmeno,p[1],1);
    CLoadItem(jmeno,p[2],2);
    CLoadItem(jmeno,p[3],3);
    CLoadItem(jmeno,Pointer(Cis),4);

    Str(cis^,s);
    PrintText(0,0,'Cislo predmetu:'+s,font);
    PrintText(0,48-HeigthOfFont(font),'Ikona',font);
    PrintText(106,48-HeigthOfFont(font),'Mys na nicem',font);
    PrintText(212,48-HeigthOfFont(font),'Mys na objektu',font);
    PutImagePart(0,50,0,0,320,200,p[1]);
    PutImagePart(106,50,0,0,320,200,p[2]);
    PutImagePart(212,50,0,0,320,200,p[3]);

    {Dispose(Cis);                              {!!!!!!!!!!!!!!!!!!!!!!!!}
    FreeMem(Cis,2);
    DisposeImage(p[3]);
    DisposeImage(p[2]);
    DisposeImage(p[1]);

    repeat until MouseKey<>0;
    SetActivePage(0);
    SetVisualPage(0);
    MouseSwitchOn;
  end;
begin
  repeat
    repeat until MouseKey=0;
    InfMenu[2].Volba:=vytvormenu('#Prikazy ovladani:|~Editace prikzu|Zadat ~novy prikaz|~Smazat prikaz|~Ukazka obrazku|~Zpet',
      DColor1, DColor2, DColor3, DColor4, DColor5, font, InfMenu[2].X, InfMenu[2].Y, InfMenu[2].Volba, 5);
    case InfMenu[2].Volba of
      1 : EditovatPrikaz;
      2 : VytvoritPrikaz;
      3 : SmazatPrikaz;
      4 : UkazkaObrazku
    end
  until InfMenu[2].Volba=5;
end;

procedure nactivztah(Podkl,Obr:pointer;var Lin,Abs:real);
  {vrati cleny linearni rovnice, aby se dostala opravdova velikost panacka}
var i:byte;
    v:array[1..2]of record p,v:integer end;
    x,y,_x,_y,y1:integer;
begin
  PushMouse;
  MouseSwitchOff;
  StandardniDialog('Nyni potrebuji vedet,|kde a jak bude hlavni|'
    + 'hrdina vysoky',
    7,35,15,48,96, font, upozorneni);
  for i:=1 to 2 do begin
    StandardniDialog('Klikni nekam a roztahni|na tom miste ramecek|'+
      'podle toho, jak|velky tam bude hlavni|hrdina',
      7,35,15,48,96, font, upozorneni);
    {sam si mys zapne}
    PushMouse;
    NewMouseArea(0,0,320-pwordarray(obr)^[0],200-pwordarray(obr)^[1]);
    MouseOn(0,0,Obr);
    repeat until MouseKey<>0;
    PopMouse;
    {obnovi MouseSwitchOff}
    x:=mousex; y:=mousey;
    newmousearea(x+2,y+2,320-x,200-y);
{je asi potreba 2 misto 1 pro spatnou zoom-proceduru
 (kvuli tobe, Lukasi), ale myslim, ze to jelo i s 1}
    newmousexy(x,y+pwordarray(obr)^[1]-1);
    repeat
      _y:=MouseY-Y+1;
      _x:=PWordArray(Obr)^[0] * _y div PWordArray(Obr)^[1];
      PutMaskImagePartZoom(X, Y, _x, _y, X,Y, _x,_y, Obr);
      {putni panacka}
{neslo by to bez toho masku ?????
 ale toto je mozna lespi a efektnejsi !!!!!!!!!!!!!!!!!!!!!!
 ale stejne se to o bod pretiskne (!!!), takze se to bude muset predelat}
      y1:=mousey;
      repeat
      until (mousekey<>0)or(mousey<>y1);
      PutImagePart(0,0, X,Y,_x,_y, Podkl)
      {obnov podklad}
    until MouseKey=0;
    v[i].p:=y;
    v[i].v:=mousey-y+1;
    newmousearea(0,0,320,200);
    repeat until MouseKey=0
  end;
  Lin:=(v[1].v-v[2].v)/(v[1].p-v[2].p);
  Abs:=v[1].v-v[1].p*(v[1].v-v[2].v)/(v[1].p-v[2].p);
                   {\=== to je Lin}
{osetrit deleni 0 !!!!!}
  PopMouse
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
    f:=ReadColor(InfMenu[39].X, InfMenu[39].Y, rotace[4].f, rotace[4].t,
      DColor5,DColor3,DColor1,DColor2, font, 'Dolní hranice '+s+' rotace:');
    if f=-1 then exit;
    SetRCLimits(rotace[1].f, rotace[1].t, rotace[2].f, rotace[2].t,
      rotace[3].f, rotace[3].t);
    t:=ReadColor(InfMenu[39].X, InfMenu[39].Y, rotace[4].f, rotace[4].t,
      DColor5,DColor3,DColor1,DColor2, font, 'Horní hranice '+s+' rotace:');
    if t=-1 then exit;
    w:=ReadInteger(InfMenu[40].X, InfMenu[40].Y, 150, 'Zadej prodlevu:', 1,100,0);
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
  repeat
    repeat until MouseKey=0;
     InfMenu[38].Volba:= VytvorMenu('#ROTACE PALETY|Nastavit ~1. rotaci|'
       +'Nastavit ~2. rotaci|Nastavit ~3. rotaci|Nastavit ~4. rotaci|'
       +'~Nastavit všechny rotace|#|~Test rotací ZAP./VYP.|~Zpět',
       DColor1, DColor2, DColor3, DColor4, DColor5, font,
       InfMenu[38].X, InfMenu[38].Y,
       InfMenu[38].Volba, 7);

    case InfMenu[38].Volba of
      1..4 : SetRotate(InfMenu[38].Volba);
      5 : for i:=1 to 4 do if not SetRotate(i) then i:=4;
      6 : begin
            if Rotuje then begin
              DoneRotatePal;
              SetPalette(Pal);
            end else InitRotatePal(
              rotace[1].f, rotace[1].t, rotace[1].w,
              rotace[2].f, rotace[2].t, rotace[2].w,
              rotace[3].f, rotace[3].t, rotace[3].w,
              rotace[4].f, rotace[4].t, rotace[4].w,palette);
            Rotuje := not Rotuje;
          end;
    end;
  until InfMenu[38].Volba = 7;
  DoneRotatePal;
  Move(pal^, Palette^, 768);
  SetPalette(Pal);
  FreeMem(pal,768);
end;

begin
  DColor1:= 15;
  DColor2:= 7;
  DColor3:= 12;
  DColor4:= 10;
  DColor5:= 8;

  Quit := false;
  AutoSave := true;
  KteraPaleta := 2;
  ZpusobKresleni := 4;
  NameFont:='stand2.fon';
  NameGAM.Name[1]:=#27;
  NameMIS.Name[1]:=#27;
  { * * * IKONY * * *}
  Ikony[0].X := 265;
  Ikony[0].Y := 23;
  Ikony[1].X := 240;
  Ikony[1].Y := 46;
  Ikony[2].X := 250;
  Ikony[2].Y := 69;
  Ikony[3].X := 254;
  Ikony[3].Y := 92;

  { * * * MENU * * *}
  InfMenu[1].X:=20;  { GMU; proc. ChooseImage Files}
  InfMenu[1].Y:=20;
  InfMenu[1].Pocet:=15;

  InfMenu[2].X:=50;  { GMU; proc. SetMouseKurzor  Menu}
  InfMenu[2].Y:=50;
  InfMenu[2].Volba:=1;

  InfMenu[3].X:=20;  { GMU; proc. SetMouseKurzor  Files/EditovatPrikaz}
  InfMenu[3].Y:=10;
  InfMenu[3].Pocet:=15;

  InfMenu[4].X:=10;  { GMU; proc. SetMouseKurzor  ReadText/VytvorPrikaz}
  InfMenu[4].Y:=10;
  InfMenu[4].Volba:=1;

  InfMenu[5].X:=50;  { GMU; proc. SetMouseKurzor  Files/SmazatPrikaz}
  InfMenu[5].Y:=10;
  InfMenu[5].Pocet:=13;

  InfMenu[6].X:=10;  { GMU; proc. SetMouseKurzor  Menu/EditvoatPrikaz}
  InfMenu[6].Y:=10;
  InfMenu[6].Volba:=1;

  InfMenu[7].X:=10;  { GMU; proc. SetMouseKurzor  Files/UkazkaObrazku}
  InfMenu[7].Y:=10;
  InfMenu[7].Pocet:=15;

  InfMenu[8].X:=10;  { GMU; proc. SetMouseKurzor  ReadText/VytvorPrikaz}
  InfMenu[8].Y:=10;

  InfMenu[9].X:=50;  { MakeOBJ; proc. EditovatFilter Menu EditovatFilter}
  InfMenu[9].Y:=50;
  InfMenu[9].Volba:=1;

  InfMenu[10].X:=100;  { MakeOBJ; proc. EditovatFilter Menu}
  InfMenu[10].Y:=50;
  InfMenu[10].Volba:=1;

  InfMenu[11].X:=100;  { MakeOBJ; proc. EditovatMap Menu}
  InfMenu[11].Y:=50;
  InfMenu[11].Volba:=1;

  InfMenu[12].X:=100;  { GM; proc. InicializaceHry  Menu}
  InfMenu[12].Y:=50;
  InfMenu[12].Volba:=1;

  InfMenu[13].X:=20;  { GM; proc. Konfig Dialog}
  InfMenu[13].Y:=20;
  InfMenu[13].Volba:=1;

  InfMenu[14].X:=20;  { GM; proc. Konfig Dialog Barva}
  InfMenu[14].Y:=20;
  InfMenu[14].Volba:=1;

  InfMenu[15].X:=30;  { GM; proc. Konfig Dialog ZadaniZdrojCesty}
  InfMenu[15].Y:=20;
  InfMenu[15].Pocet:=15;

  InfMenu[16].X:=40;  { GM; proc. Konfig Dialog ZadaniCilCesty}
  InfMenu[16].Y:=20;
  InfMenu[16].Pocet:=15;

  InfMenu[17].X:=50;  { GM; proc. Konfig Dialog ZadaniFontu}
  InfMenu[17].Y:=20;
  InfMenu[17].Pocet:=15;

  InfMenu[18].X:=50;  { GM; proc. InicializaceHry Menu}
  InfMenu[18].Y:=20;
  InfMenu[18].Volba:=1;

  InfMenu[19].X:=50;  { GM; proc. InicializaceHry ReadText ZadaniPostavicky}
  InfMenu[19].Y:=20;

  InfMenu[20].X:=10;  { GM; proc. InicializaceHry ReadText StartObr}
  InfMenu[20].Y:=40;

  InfMenu[21].X:=10;  { GM; proc. InicializaceHry Files/ZadaniFontu}
  InfMenu[21].Y:=10;
  InfMenu[21].Pocet:=15;

  InfMenu[22].X:=10;  { GM; proc. InputNameMIS ReadText}
  InfMenu[22].Y:=10;
  InfMenu[22].Pocet:=15;

  InfMenu[23].X:=10;  { GM; proc. InputSoundMIS Files}
  InfMenu[23].Y:=10;
  InfMenu[23].Pocet:=15;

  InfMenu[24].X:=10;  { GM; proc. InputFontMIS Files}
  InfMenu[24].Y:=10;
  InfMenu[24].Pocet:=15;

  InfMenu[25].X:=50;  { GM; proc. Mistnost Menu}
  InfMenu[25].Y:=20;
  InfMenu[25].Volba:=1;

  InfMenu[26].X:=50;  { GM; proc. Mistnost Files}
  InfMenu[26].Y:=20;
  InfMenu[26].Pocet:=15;

  InfMenu[27].X:=50;  { GM; proc. Mistnost Files}
  InfMenu[27].Y:=20;
  InfMenu[27].Pocet:=15;

  InfMenu[28].X:=50;  { GM; proc. Mistnost Files}
  InfMenu[28].Y:=20;
  InfMenu[28].Pocet:=15;

  InfMenu[29].X:=50;  { GM; proc. Mistnost ReadText prejmenovatmistnost}
  InfMenu[29].Y:=20;

  InfMenu[30].X:=50;  { GM; proc. EditaceMistnosti Menu }
  InfMenu[30].Y:=20;
  InfMenu[30].Volba:=1;

  InfMenu[31].X:=150;  { GM; proc. Objekt Menu }
  InfMenu[31].Y:=50;
  InfMenu[31].Volba:=1;

  InfMenu[32].X:=50;  { GM; proc. Objekt Files DeleteObjekt}
  InfMenu[32].Y:=20;
  InfMenu[32].Pocet:=15;

  InfMenu[33].X:=50;  { GM; proc. Objekt ReadText ReNameObjekt}
  InfMenu[33].Y:=20;

  InfMenu[34].X:=150;  { GM; proc. EditaceObjektu Menu }
  InfMenu[34].Y:=50;
  InfMenu[34].Volba:=1;

  InfMenu[35].X:=150;  { GM; proc. EditaceObjektu Menu PrikazyMysi}
  InfMenu[35].Y:=50;
  InfMenu[35].Volba:=1;

  InfMenu[36].X:=150;  { GM; proc. InputWayOfDraw Menu}
  InfMenu[36].Y:=50;
  InfMenu[36].Volba:=1;

  InfMenu[37].X:=50;  { GM; proc. InputMis Dialog}
  InfMenu[37].Y:=50;

  InfMenu[38].X:=10;  { GMU; proc. NactiRotaciPal  Menu}
  InfMenu[38].Y:=10;
  InfMenu[38].Volba:=1;

  InfMenu[39].X:=50;  { GM; proc. NactiRotaciPal  readcolor SetRotate}
  InfMenu[39].Y:=10;

  InfMenu[40].X:=50;  { GM; proc. NactiRotaciPal  readinteger SetRotate}
  InfMenu[40].Y:=50;
end.