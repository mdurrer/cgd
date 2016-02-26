{ $define ladim}

unit animace4;

interface

uses texts, midi01, vars, extended, crt, graph256;

procedure LoadAObjs(var infile: file);
procedure SaveAObjs(var outfile: file);

const
{$ifdef ladim}
  Lad: boolean= False;
{$endif}
  CompareMouseDelay= 3;

{ **************************************************************** }
{                          _ruzne_                                 }
{ **************************************************************** }


{ **************************************************************** }
{                          _myska_                                 }
{ **************************************************************** }


const AnimMouseSwitchedOn: boolean= False;
var AnimMouseOldKey: integer;
    UnderMouseUserProc: procedure;
    AnimMouseUnemployed: longint;

procedure AnimInitMouse;
procedure AnimMouseNewImage(HotX, HotY : integer; P : pointer);
procedure AnimMouseOn(HotX, HotY: integer; P : pointer);
procedure AnimMouseOff;
procedure AnimMouseSwitchOn;
procedure AnimMouseSwitchOff;
procedure AnimMouseEnableInt;
procedure AnimMouseDisableInt;
function  AnimMouseKey: integer;


{ **************************************************************** }
{                     _animace_, animacni objekty                  }
{ **************************************************************** }
type TAnimObject= (Image, Text);
  TAnimCommand= (AComNone, AComRepaint, AComVisible, AComUnvisible);

  PAObjTab= ^TAObjTab;
  TAObjTab= record
     TypeOfObj: TAnimObject; {typ animacniho objektu:
          .. d2 d1 d0   byte
                 0  0    0= obrazek
                 0  1    1= text
                       }
     Priority: byte;    {priorita objektu; je zde ulozena kvuli
                         proceduram Visible... a UnvisibleAObj,
                         Unvisible... zmeni hodnotu pririty primo
                               v tabulce vsech sprajtu na 0, a
                         Visible... nastavi opet prioritu do tabulky,
                               a to prave podle hodnoty Priority
                         (viz. AObjsPriorityTab)    }

     Lines: byte; {u Text: pocet radku}

     DisableErasing: byte;{cokoli   ruzne od 0   zamezi zbytecnemu
                           prekreslovani pozadi,
                           0   znamena, ze pozadi je pri zmene
                           sprajtu, pozice, atd. prekreslovano
                           (beznejsi varianta)  }

     Mirrored: byte;    {u Image: 0 znamena, ze se objekt kresli tak,
                         jak lezi a bezi, cokoli jineho znaci horizontalni
                         prehozeni sprajtu}

     FonColor: byte;    {u objektu typu Text je tady ulozena hodnota
                         FonColor1= vlastne barva cislo 254}

     AnimCommand: TAnimCommand; {specialni prikaz pro animaci- jeji
                                 kreslici proceduru ...PutAObjs.
                          AComNone   : nic
                          AComRepaint: znovuvykresli objekt na
                                       obrazovku (kdyz jsem mu
                                       napr. podstrcil novy sprajt)
                          AComVisible  : ucini objekt   VIDITELNYM
                          AComUnvisible: ucini objekt NEVIDITELNYM
                          }

     AComCounter: byte; {pomocne pocitadlo pro AnimCommand}

     NewX: integer;{souradnice objektu, na ktere se ma namalovat}
     NewY: integer;{do ActivePage }
     X   : integer;
     Y   : integer;{souradnice objektu ve VisiblePage}
     OldX: integer;
     OldY: integer;{stare souradnice objektu v ActivePage }

     NewWidth : integer;   {nova sirka aktualniho sprajtu}
                           {u textu: sirka textu}
     NewHeigth: integer;   {nova vyska aktualniho sprajtu}
                           {u textu: vyska textu}
     Width    : integer;   {sirka aktualniho sprajtu}
     Heigth   : integer;   {vyska aktualniho sprajtu}
     OldWidth : integer;   {stara sirka aktualniho sprajtu}
     OldHeigth: integer;   {stara vyska aktualniho sprajtu}

{Urceni oblasti, ktere se maji znovuvykreslovat:}
     AreaUnderX:integer;      {...Under... pro oblast, ktera je}
     AreaUnderY:integer;      {POD objektem}
     AreaUnderWidth:word;
     AreaUnderHeigth:word;

     AreaAboveX:integer;      {...Above... pro oblast, ktera je}
     AreaAboveY:integer;      {NAD objektem, vcetne objektu}
     AreaAboveWidth:word;
     AreaAboveHeigth:word;

     TextAddr: PString;   {u Text: adresa retezce}
     FontAddr: PFont;     {        adr. fontu}

     Sprite: pointer; {u Image: adresa obrazku}
  end;


var LastAObj: byte; {cislo posledniho zaregistrovaneho animacniho
                         objektu (jsou ocislovany 0-255)
                         POZOR! neni zadna moznost, aby nebyl zaregistrovany
                         ani jeden objekt (pro jeden objekt je tato hodnota
                         rovna prave 0 }
  AObjsAddressTab: array[0..255] of PAObjTab;
                        {tabulka adres informaci o jednotlivych objektech,
                         patri vzdy k sobe usporadana dvojice:
                         AObjsPriorityTab[i] a AObjsAddressTab[i],
                         plati to same jako vyse}
  AnimWhatObjectsMousePoints: TAnimObject; {zada se zde typ objektu, ktery
                           je testovan s mysi, zda na nej neukazuje.
                           Image= testuje jenom s obr., texty ignoruje
                           Text= testuje jen texty, obr. ignoruje}
  AnimOldObjectUnderMouse: byte;
  AnimObjectUnderMouse: byte; {cislo objektu, na ktery mys ukazuje.
                               255= zadny objekt (teoreticky tato
                               situace muze nastat), takze bohuzel
                               NESMI!!!! existovat objekt vetsi nez 254}
  AnimEnableClearScreen: byte;{0= obrazovka se nemaze,
                               cokoli jine= obrazovka se pred kazdym
                               vykreslovanim cela smaze a vsechny
                               objekty se vykresli uplne znovu}
  AnimBackColor: byte; {barva pozadi, kterou se maze obrazovka, kdyz se maze...}


procedure PrepareAnimation;
{nastavi vsechny interni promenne a pripravi system na zaregistrovani
 vsech objektu}

{ani jedna z nasledujicich CTYR procedur nic nekontroluje, vsechny
 predpokladaji SPRAVNE hodnoty, takze pozor na jejich pouzivani:}
procedure AddImageAObj(var ObjNum: byte);
{prida animacni objekt typu Image na konec tabulky, vyhradi v tabulce
 misto pro adresy jednotlivych sprajtu: (LastSprite+1)*4 byte }
{prida animacni objekt na konec tabulky, vyhradi v tabulce misto pro adresy
 jednotlivych sprajtu: (LastSprite+1)*4 byte }
{prioritu mu nastavi spravne do tabulky objektu, v tabulce priorit
 nastavi 0 (neviditelno), pred pouzitim objektu se musi dat Visible...}
procedure AddTextAObj(var ObjNum: byte; _Font: PFont);
{prida animacni objekt na konec tabulky, pocita s tim, ze jde o textovy
 objekt, zaznamena do tabulky adresy fontu a retezce, zaznamena barvu
 kterou se ma tisknout (FonColor1) }

procedure NewTextAObj(ObjNum: byte; _Text: PString);

procedure AddSpriteToObj(ObjNum: byte; SpriteAddress: pointer);
{prida adresu urceneho sprajtu do tabulky jednoho objektu cislo ObjNum}

function ReleaseLastAObj: pointer;
{uvolni posledni animacni objekt (ten, co je nejvic nahore) z tabulky-
 ciste jenom data objektu! Zadne sprajty to neuvolnuje! (Hura!)}

procedure BackToVirginAObj(ObjNum: byte);

procedure RepaintAObj(ObjNum: byte);
{preda prikaz animatoru, aby bylo image objektu znovu nakresleno}
{pouziti predevsim (a pravdepodobne i jedine) v pripade, ze objekt}
{ma v pameti vyhrazeno misto jenom pro adresu jedineho sprajtu}
{a prechod na jiny sprajt se resi zmenou pointru, ktery ukazuje}
{vzdy na aktualni sprajt}

function IsVisibleAObj(ObjNum: byte): boolean;

procedure VisibleAObj(ObjNum: byte);
{zviditelni objekt tak, ze mu do tabulky priority vsech objektu da
 skutecnou hodnotu priority ulozenou v tabulce toho jednoho objektu
 (predtim, kdyz byl neviditelny, zustala priorita v tabulce toho
 objektu stale puvodni, kdezto priorita v tabulce priorit vsech
 objektu se zmenila na 0 = neviditelny) }
procedure VisibleAObj1Bob(ObjNum: byte; _NewWidth,_NewHeigth:integer);

procedure UnvisibleAObj(ObjNum: byte);
{zneviditelni objekt tak, ze do tabulky priorit vsech objektu
 ulozi 0 = neviditelny. Priorita v tabulce toho urciteho objektu zustava
 ale beze zmeny, kvuli obnoveni procedurou VisibleAObj}

procedure NewPriorityAObj(ObjNum, NewPriority: byte);
{zmeni prioritu objektu}
procedure StartPriorityAObj(ObjNum, StartPriority: byte);

procedure NewPosAObj(ObjNum: byte; DefNewX, DefNewY: integer);
{priradi objektu nove souradnice}

procedure StartPosAObj(ObjNum: byte; StartX, StartY: integer);
{priradi objektu nove souradnice}

function GetNewXAObj(ObjNum: byte): integer;
function GetNewYAObj(ObjNum: byte): integer;
function GetNewWidthAObj(ObjNum: byte): integer;
function GetNewHeigthAObj(ObjNum: byte): integer;

procedure NewFonColorAObj(ObjNum, Color: byte);
{nastavi novou barvu pisma u objektu typu Text, pokud neni objekt typu
 Text, posere se to}

procedure NewMirrorAObj(ObjNum, DefMirror: byte);

procedure NewZoomAObj(ObjNum: byte; ZoomedWidth, ZoomedHeigth: integer);

procedure StartDisableErasingAObj(ObjNum, Setting: byte);

procedure CompareMouseWithObjects;

procedure SmartPutAObjs;
{vykresleni obrazovky}

procedure SwapAnimPages;
{zobrazi nakreslenou stranku a nastavi vse potrebne, aby se mohlo
 kreslit na tu druhou}

procedure CleanAObjsOrder;

implementation
{ **************************************************************** }
{                          _ruzne_                                 }
{ **************************************************************** }

procedure Control_Draw;
  procedure DrawControlBar(title: string; v: byte);
  begin
    PrintText((320-WidthOfText(G_SmallFont, title))div 2,
      MagicControlY-HeigthOfFont(G_SmallFont), title, G_SmallFont);
    Bar((320-MagicControlWidth)div 2, MagicControlY+1,
      MagicControlWidth, HeigthOfFont(G_SmallFont)div 2-2, MagicControlSolid);
    Rectangle((320-MagicControlWidth)div 2-1, MagicControlY,
      MagicControlWidth+2, HeigthOfFont(G_SmallFont)div 2, MagicControlOutline);
    Bar((320-MagicControlWidth)div 2+round((v/256)*MagicControlWidth),
      MagicControlY-2,
      2, HeigthOfFont(G_SmallFont)div 2+4,
      MagicControlSolid);
    Rectangle((320-MagicControlWidth)div 2+round((v/256)*MagicControlWidth)-1,
      MagicControlY-3,
      4, HeigthOfFont(G_SmallFont)div 2+6,
      MagicControlOutline);
  end;
begin
  FonColor1:= MagicControlFont;
  case Control_On of
    Control_TextSpeed: DrawControlBar(ctrl_textspeed, Control_Settings.TextSpeed);
    Control_MusicVolume: DrawControlBar(ctrl_musicvol, Control_Settings.MusicVolume);
    Control_VoiceVolume: DrawControlBar(ctrl_voicevol, Control_Settings.VoiceVolume);
  end;
end;

procedure Debug_PrintInfo;
var c: string[8];
  procedure MemoryInfo;
  begin
    PrintText(0, 0, 'volna pamet', G_SmallFont);
    with Debug_Info do begin
      Str(ProgMem:6, c);
      PrintText(0, 10, c, G_SmallFont);
      PrintText(70, 10, 'na zacatku programu', G_SmallFont);

      Str(InitGameMem:6, c);
      PrintText(0, 20, c, G_SmallFont);
      PrintText(70, 20, 'po initu hry', G_SmallFont);

      Str(InitRoomMem:6, c);
      PrintText(0, 30, c, G_SmallFont);
      PrintText(70, 30, 'po initu mistnosti', G_SmallFont);

      Str(ActRoomMem:6, c);
      PrintText(0, 40, c, G_SmallFont);
      PrintText(70, 40, 'nejmene v aktualni mistnosti', G_SmallFont);
      Str(G_Hd.ActRoom:2, c);
      PrintText(280, 40, c, G_SmallFont);

      Str(GlobalMaxMem:6, c);
      PrintText(0, 50, c, G_SmallFont);
      PrintText(70, 50, 'nejvice, v mistnosti', G_SmallFont);
      Str(GlobalMaxRoom:2, c);
      PrintText(200, 50, c, G_SmallFont);

      Str(GlobalMinMem:6, c);
      PrintText(0, 60, c, G_SmallFont);
      PrintText(70, 60, 'nejmene, v mistnosti', G_SmallFont);
      Str(GlobalMinRoom:2, c);
      PrintText(200, 60, c, G_SmallFont);
    end;
  end;
  procedure AnimInfo;
  begin
    PrintText(0, 0, 'anim. sekvence, animace', G_SmallFont);
    Str(A_LastAnmSeq:6, c);
    PrintText(0, 10, c, G_SmallFont);
    PrintText(70, 10, 'A_LastAnmSeq', G_SmallFont);
    Str(A_LastLoadedPicture:6, c);
    PrintText(0, 20, c, G_SmallFont);
    PrintText(70, 20, 'A_LastLoadedPicture', G_SmallFont);
    Str(A_LastLoadedSample:6, c);
    PrintText(0, 30, c, G_SmallFont);
    PrintText(70, 30, 'A_LastLoadedSample', G_SmallFont);
    Str(LastAObj:6, c);
    PrintText(0, 40, c, G_SmallFont);
    PrintText(70, 40, 'LastAObj', G_SmallFont);
    Str(Debug_OpenFiles:6, c);
    PrintText(0, 50, c, G_SmallFont);
    PrintText(70, 50, 'Debug_OpenFiles', G_SmallFont);
  end;
begin
  Debug_UpdateOpenFiles;
  FonColor1:= 255;
  case Debug_Chapter of
    Info_Basic: PrintText(0, 0, 'D', G_SmallFont);
    Info_Memory: MemoryInfo;
    Info_Anim: AnimInfo;
  end;
end;

procedure EnterPasswordReport;
var sl,st,ra: string[4];
begin
  FonColor1:= 255;
  Str(G_PaswWord, sl);
  Str(G_PaswLine, ra);
  Str(G_PaswPage, st);
  PrintText(160-WidthOfText(G_BigFont, ctrl_askpassw1)div 2, 65, ctrl_askpassw1, G_BigFont);
  PrintText(160-WidthOfText(G_BigFont, sl+ctrl_askpassw2+ra+ctrl_askpassw3+st)div 2, 80, 
   sl+ctrl_askpassw2+ra+ctrl_askpassw3+st, G_BigFont);

  PrintText(160-WidthOfText(G_BigFont, G_Cheat)div 2, 110, G_Cheat, G_BigFont);
end;


(*{$ifdef ladim}*)
procedure Vysoko;
begin
  Sound(400);
  Delay(50);
  NoSound;
end;
procedure Nizko;
begin
  Sound(500);
  Delay(30);
  NoSound;
end;
(*{$endif}*)


{ **************************************************************** }
{                          _myska_                                 }
{ **************************************************************** }
var
  VisAnimMouseX, VisAnimMouseY: integer;
  UnvAnimMouseX, UnvAnimMouseY: integer;
  HotAnimMouseX, HotAnimMouseY : integer;
  AnimMouseWidth, AnimMouseHeigth: integer;
  { VisAnimMouseX,VisAnimMouseY=stare souradnice mysi kdyz je rezidentni }
  { AnimMouseWidth, AnimMouseHeigth : rozmery obrazku mysi kduz je rezidentni   }
  VisAnimMouseBackgrnd: pointer;
  UnvAnimMouseBackgrnd: pointer;
  AnimMouseImage : pointer;
  AnimMouseEnabledInt: boolean;
  TlacitkoZpracovane: boolean;
const
  UnvActive: boolean= False;
  VisActive: boolean= True;
  CompareMouseCount: byte= 0;

{je nutne, aby byly zvlast tyhle Put...Mouse, protoze normalni rutiny
 pouzivaji interni promenne, ktere by jinak myska nevhodne mohla prepsat
 v prubehu kresleni}

procedure PutMousePart(X, Y, StartX, StartY, Sirka, Vyska : integer; P : Pointer); assembler;
{ Vukresli obr na akt. str. na souradnice X,Y ale jen v okne urcenem }
{ StartX,StartY,Sirka,Vyska                                          }
asm
  jmp      @Start

@Xobr:      dw    0
@Yobr:      dw    0
@SXobr:     dw    0
@SYobr:     dw    0
@SirkaObr:  dw    0
@VyskaObr:  dw    0

@WX:        dw    0
@WY:        dw    0
@AAP:       dw    0

@LastL:     dw    0

@Start:
  mov      ax, LastLine
  mov      word ptr cs:[@LastL], ax

  mov      ax, ActiveAddrPage
  mov      word ptr cs:[@AAP], ax
  mov      ax, X
  mov      word ptr cs:[@Xobr], ax
  mov      ax, Y
  mov      word ptr cs:[@Yobr], ax
  mov      ax, StartX
  mov      word ptr cs:[@SXobr], ax
  mov      ax, StartY
  mov      word ptr cs:[@SYobr], ax
  mov      ax, Sirka
  mov      word ptr cs:[@SirkaObr], ax
  mov      ax, Vyska
  mov      word ptr cs:[@VyskaObr], ax

  push     ds
  push     bp
  mov      ax, 0A000h
  mov      es, ax
  lds      si, P
  mov      bp, word ptr ds:[si+2]
  {Vypocet CX}
  mov      cx, word ptr cs:[@SirkaObr]       { do CX sirku OBR. }
  cmp      cx, word ptr ds:[si]              { je OKNO mensi nez OBR. }
  jna      @OK_CX1
  mov      cx, word ptr ds:[si]              { -ano CX:= OKNO }
@OK_CX1:
  mov      ax, word ptr cs:[@Xobr]           { do AX  souradnic X}
  or       ax, ax                            { je obrzek moc vlevo?}
  jns      @OK_CX6                           { ne = skok }
  add      ax, word ptr ds:[si]              { ano}
  or       ax, ax                            { AX:=sirka+X }
  js       @Konec                            { Neni videt= konec }
  mov      di, word ptr cs:[@SXobr]
  add      di, word ptr cs:[@SirkaObr]
  cmp      ax, di
  jna      @OK_CX7
  mov      cx, word ptr cs:[@SirkaObr]
  jmp      @OK_CX2
@OK_CX7:
  mov      ax, word ptr cs:[@Xobr]
  neg      ax
  add      ax, word ptr cs:[@SYobr]
    mov      cx, word ptr ds:[si]       { do CX sirku OBR. }
  sub      cx, ax
  or       cx, cx
  js       @Konec
  jz       @Konec
  jmp      @OK_CX2
@OK_CX6:
  cmp      ax, word ptr cs:[@SXobr]
  jae      @OK_CX3
  { -cx je vlevo}
  add      ax, word ptr ds:[si]
  sub      ax, word ptr cs:[@SXobr]
  or       ax, ax
  js       @Konec
  jz       @Konec
  mov      cx, ax
  jmp      @OK_CX4
@OK_CX3:
  { -cx je moc vpravo}
  mov      ax, word ptr cs:[@SXobr]
  add      ax, word ptr cs:[@SirkaObr]
  sub      ax, word ptr cs:[@Xobr]
  or       ax, ax
  js       @Konec
  jz       @Konec
  cmp      ax, cx
  jnb      @OK_CX4
  mov      cx, ax
  jmp      @OK_CX5
@OK_CX4:
  { - je ram menci nez cx? }
  mov      ax, word ptr cs:[@SirkaObr]
  cmp      ax, cx
  ja       @OK_CX5
  mov      cx, ax
@OK_CX5:
  mov      ax, cx
  add      ax, word ptr cs:[@Xobr]
  cmp      ax, 320
  jb       @OK_CX2
  mov      cx, 320
  sub      cx, word ptr cs:[@Xobr]
@OK_CX2:
  {Vypocet BX}
  mov      bx, word ptr cs:[@VyskaObr]
  cmp      bx, word ptr ds:[si+2]
  jna      @OK_BX1
  mov      bx, word ptr ds:[si+2]
@OK_BX1:
  mov      ax, word ptr cs:[@Yobr]
  or       ax, ax
  jns      @OK_BX6
  add      ax, bp
  or       ax, ax
  js       @Konec
  mov      di, word ptr cs:[@SYobr]
  add      di, word ptr cs:[@VyskaObr]
  cmp      ax, di
  jna      @OK_BX7
  mov      bx, word ptr cs:[@VyskaObr]
  jmp      @OK_BX2
@OK_BX7:
  mov      ax, word ptr cs:[@Yobr]
  neg      ax
  add      ax, word ptr cs:[@SYobr]
  mov      bx, word ptr ds:[si+2]
  sub      bx, ax
  or       bx, bx
  js       @Konec
  jz       @Konec
  jmp      @OK_BX2
@OK_BX6:
  cmp      ax, word ptr cs:[@SYobr]
  jae      @OK_BX3
  { - bp je nahore}
  add      ax, word ptr ds:[si+2]
  sub      ax, word ptr cs:[@SYobr]
  or       ax, ax
  js       @Konec
  jz       @Konec
  mov      bx, ax
  jmp      @OK_BX4
@OK_BX3:
  { -bx je moc dole}
  mov      ax, word ptr cs:[@SYobr]
  add      ax, word ptr cs:[@VyskaObr]
  sub      ax, word ptr cs:[@Yobr]
  or       ax, ax
  js       @Konec
  jz       @Konec
  cmp      ax, bx
  jnb      @OK_BX4
  mov      bx, ax
  jmp      @OK_BX5
@OK_BX4:
  { - je ram menci naz bx? }
  mov      ax, word ptr cs:[@VyskaObr]
  cmp      ax, bx
  ja       @OK_BX5
  mov      bx, ax
@OK_BX5:
  mov      ax, bx
  add      ax, word ptr cs:[@Yobr]
  cmp      ax, word ptr cs:[@LastL]
  jb       @OK_BX2
  mov      bx, word ptr cs:[@LastL]
  sub      bx, word ptr cs:[@Yobr]
@OK_BX2:
  {Vypocet SI, prom. pro DI}
  mov      ax, word ptr cs:[@Yobr]
  mov      dx, 0
  or       ax, ax
  jns      @OK_SI3
  { -Y je moc nahore}
  neg      ax
  mov      dx, ax
  add      dx, word ptr cs:[@SYObr]
  mov      ax, word ptr cs:[@SYObr]
  mov      word ptr cs:[@WY], ax
  jmp      @OK_SI1
@OK_SI3:
  mov      word ptr cs:[@WY], ax
  cmp      ax, word ptr cs:[@SYobr]
  ja       @OK_SI1
  mov      dx, word ptr cs:[@SYobr]
  mov      word ptr cs:[@WY], dx
  sub      dx, ax
@OK_SI1:
  add     dx, 4
  add     si, dx
  mov     ax, word ptr cs:[@Xobr]
  mov     dx, 0
  mov     word ptr cs:[@WX], ax
  or      ax, ax
  jns     @OK_SI4
  { - X je moc vlevo}
  neg     ax
  mov     dx, ax
  add     dx, word ptr cs:[@SXobr]
  mov     ax, word ptr cs:[@SXobr]
  mov     word ptr cs:[@WX], ax
  jmp     @OK_SI2
@OK_SI4:
  cmp     ax, word ptr cs:[@SXobr]
  ja      @OK_SI2
  mov     dx, word ptr cs:[@SXobr]
  mov      word ptr cs:[@WX], dx
  sub     dx, ax
@OK_SI2:
  mov     ax, bp
  mul     dx
  add     si, ax
  {Vypocet DI}
  push    cx
  mov     ax, 80
  mul     word ptr cs:[@WY]
  mov     di, ax
  mov     ax, word ptr cs:[@WX]
  mov     cx, ax
  shr     ax, 1
  shr     ax, 1
  add     di, ax
  add     di, word ptr cs:[@AAP]
  and     cl, 3
  mov     ah, 1
  shl     ah, cl
  pop     cx

@Lop_X:
  push     si
  push     di
  push     cx
    mov      cx, bx
    mov      dx, 3C4h
    mov      al, 2
    out      dx, al
    inc      dx
    mov      al, ah
    and      al, 0Fh
    out      dx, al
  @Lop_Y:
    lodsb
    mov       byte ptr es:[di], al
    add       di, 80
{    movsb
    mov      di, 79}
    Loop     @Lop_Y
  pop      cx
  pop      di
  pop      si
  add      si, bp
  shl      ah, 1
  cmp      ah, 10h
  jnz      @StejnaAdr
  mov      ah, 1
  inc      di
@StejnaAdr:
  loop     @Lop_X
@Konec:
  pop      bp
  pop      ds
end;

procedure PutMaskMousePart(X, Y, StartX, StartY, Sirka, Vyska : integer; P : Pointer); assembler;
{ Vukresli obr na akt. str. na souradnice X,Y ale jen v okne urcenem }
{ StartX,StartY,Sirka,Vyska                                          }
asm
  jmp      @Start

@Xobr:      dw    0
@Yobr:      dw    0
@SXobr:     dw    0
@SYobr:     dw    0
@SirkaObr:  dw    0
@VyskaObr:  dw    0

@WX:        dw    0
@WY:        dw    0
@AAP:       dw    0

@LastL:     dw    0

@Start:
  mov      ax, LastLine
  mov      word ptr [@LastL], ax

  mov      ax, ActiveAddrPage
  mov      word ptr cs:[@AAP], ax
  mov      ax, X
  mov      word ptr cs:[@Xobr], ax
  mov      ax, Y
  mov      word ptr cs:[@Yobr], ax
  mov      ax, StartX
  mov      word ptr cs:[@SXobr], ax
  mov      ax, StartY
  mov      word ptr cs:[@SYobr], ax
  mov      ax, Sirka
  mov      word ptr cs:[@SirkaObr], ax
  mov      ax, Vyska
  mov      word ptr cs:[@VyskaObr], ax

  push     ds
  push     bp
  mov      ax, 0A000h
  mov      es, ax
  lds      si, P
  mov      bp, word ptr ds:[si+2]
  {Vypocet CX}
  mov      cx, word ptr cs:[@SirkaObr]       { do CX sirku OBR. }
  cmp      cx, word ptr ds:[si]              { je OKNO mensi nez OBR. }
  jna      @OK_CX1
  mov      cx, word ptr ds:[si]              { -ano CX:= OKNO }
@OK_CX1:
  mov      ax, word ptr cs:[@Xobr]           { do AX  souradnic X}
  or       ax, ax                            { je obrzek moc vlevo?}
  jns      @OK_CX6                           { ne = skok }
  add      ax, word ptr ds:[si]              { ano}
  or       ax, ax                            { AX:=sirka+X }
  js       @Konec                            { Neni videt= konec }
  mov      di, word ptr cs:[@SXobr]
  add      di, word ptr cs:[@SirkaObr]
  cmp      ax, di
  jna      @OK_CX7
  mov      cx, word ptr cs:[@SirkaObr]
  jmp      @OK_CX2
@OK_CX7:
  mov      ax, word ptr cs:[@Xobr]
  neg      ax
  add      ax, word ptr cs:[@SYobr]
    mov      cx, word ptr ds:[si]       { do CX sirku OBR. }
  sub      cx, ax
  or       cx, cx
  js       @Konec
  jz       @Konec
  jmp      @OK_CX2
@OK_CX6:
  cmp      ax, word ptr cs:[@SXobr]
  jae      @OK_CX3
  { -cx je vlevo}
  add      ax, word ptr ds:[si]
  sub      ax, word ptr cs:[@SXobr]
  or       ax, ax
  js       @Konec
  jz       @Konec
  mov      cx, ax
  jmp      @OK_CX4
@OK_CX3:
  { -cx je moc vpravo}
  mov      ax, word ptr cs:[@SXobr]
  add      ax, word ptr cs:[@SirkaObr]
  sub      ax, word ptr cs:[@Xobr]
  or       ax, ax
  js       @Konec
  jz       @Konec
  cmp      ax, cx
  jnb      @OK_CX4
  mov      cx, ax
  jmp      @OK_CX5
@OK_CX4:
  { - je ram menci nez cx? }
  mov      ax, word ptr cs:[@SirkaObr]
  cmp      ax, cx
  ja       @OK_CX5
  mov      cx, ax
@OK_CX5:
  mov      ax, cx
  add      ax, word ptr cs:[@Xobr]
  cmp      ax, 320
  jb       @OK_CX2
  mov      cx, 320
  sub      cx, word ptr cs:[@Xobr]
@OK_CX2:
  {Vypocet BX}
  mov      bx, word ptr cs:[@VyskaObr]
  cmp      bx, word ptr ds:[si+2]
  jna      @OK_BX1
  mov      bx, word ptr ds:[si+2]
@OK_BX1:
  mov      ax, word ptr cs:[@Yobr]
  or       ax, ax
  jns      @OK_BX6
  add      ax, bp
  or       ax, ax
  js       @Konec
  mov      di, word ptr cs:[@SYobr]
  add      di, word ptr cs:[@VyskaObr]
  cmp      ax, di
  jna      @OK_BX7
  mov      bx, word ptr cs:[@VyskaObr]
  jmp      @OK_BX2
@OK_BX7:
  mov      ax, word ptr cs:[@Yobr]
  neg      ax
  add      ax, word ptr cs:[@SYobr]
  mov      bx, word ptr ds:[si+2]
  sub      bx, ax
  or       bx, bx
  js       @Konec
  jz       @Konec
  jmp      @OK_BX2
@OK_BX6:
  cmp      ax, word ptr cs:[@SYobr]
  jae      @OK_BX3
  { - bp je nahore}
  add      ax, word ptr ds:[si+2]
  sub      ax, word ptr cs:[@SYobr]
  or       ax, ax
  js       @Konec
  jz       @Konec
  mov      bx, ax
  jmp      @OK_BX4
@OK_BX3:
  { -bx je moc dole}
  mov      ax, word ptr cs:[@SYobr]
  add      ax, word ptr cs:[@VyskaObr]
  sub      ax, word ptr cs:[@Yobr]
  or       ax, ax
  js       @Konec
  jz       @Konec
  cmp      ax, bx
  jnb      @OK_BX4
  mov      bx, ax
  jmp      @OK_BX5
@OK_BX4:
  { - je ram menci naz bx? }
  mov      ax, word ptr cs:[@VyskaObr]
  cmp      ax, bx
  ja       @OK_BX5
  mov      bx, ax
@OK_BX5:
  mov      ax, bx
  add      ax, word ptr cs:[@Yobr]
  cmp      ax, word ptr cs:[@LastL]
  jb       @OK_BX2
  mov      bx, word ptr cs:[@LastL]
  sub      bx, word ptr cs:[@Yobr]
@OK_BX2:
  {Vypocet SI, prom. pro DI}
  mov      ax, word ptr cs:[@Yobr]
  mov      dx, 0
  or       ax, ax
  jns      @OK_SI3
  { -Y je moc nahore}
  neg      ax
  mov      dx, ax
  add      dx, word ptr cs:[@SYObr]
  mov      ax, word ptr cs:[@SYObr]
  mov      word ptr cs:[@WY], ax
  jmp      @OK_SI1
@OK_SI3:
  mov      word ptr cs:[@WY], ax
  cmp      ax, word ptr cs:[@SYobr]
  ja       @OK_SI1
  mov      dx, word ptr cs:[@SYobr]
  mov      word ptr cs:[@WY], dx
  sub      dx, ax
@OK_SI1:
  add     dx, 4
  add     si, dx
  mov     ax, word ptr cs:[@Xobr]
  mov     dx, 0
  mov     word ptr cs:[@WX], ax
  or      ax, ax
  jns     @OK_SI4
  { - X je moc vlevo}
  neg     ax
  mov     dx, ax
  add     dx, word ptr cs:[@SXobr]
  mov     ax, word ptr cs:[@SXobr]
  mov     word ptr cs:[@WX], ax
  jmp     @OK_SI2
@OK_SI4:
  cmp     ax, word ptr cs:[@SXobr]
  ja      @OK_SI2
  mov     dx, word ptr cs:[@SXobr]
  mov      word ptr cs:[@WX], dx
  sub     dx, ax
@OK_SI2:
  mov     ax, bp
  mul     dx
  add     si, ax
  {Vypocet DI}
  push    cx
  mov     ax, 80
  mul     word ptr cs:[@WY]
  mov     di, ax
  mov     ax, word ptr cs:[@WX]
  mov     cx, ax
  shr     ax, 1
  shr     ax, 1
  add     di, ax
  add     di, word ptr cs:[@AAP]
  and     cl, 3
  mov     ah, 1
  shl     ah, cl
  pop     cx

@Lop_X:
  push     si
  push     di
  push     cx
    mov      cx, bx
    mov      dx, 3C4h
    mov      al, 2
    out      dx, al
    inc      dx
    mov      al, ah
    and      al, 0Fh
    out      dx, al
  @Lop_Y:
    lodsb
    cmp       al, 255
    jz        @NeVidet
    mov       byte ptr es:[di], al
  @NeVidet:
    add       di, 80
    Loop     @Lop_Y
  pop      cx
  pop      di
  pop      si
  add      si, bp
  shl      ah, 1
  cmp      ah, 10h
  jnz      @StejnaAdr
  mov      ah, 1
  inc      di
@StejnaAdr:
  loop     @Lop_X
@Konec:
  pop      bp
  pop      ds
end;

function AnimMouseKey:integer;
begin
  if not TlacitkoZpracovane
    then AnimMouseKey:=AnimMouseOldKey
    else AnimMouseKey:=0;
  TlacitkoZpracovane:= True;
end;

procedure AnimInitMouse;
begin
  AnimMouseOldKey:= MouseKey;
  TlacitkoZpracovane:= True;
end;

procedure AnimMouseEnableInt;
begin
  AnimMouseEnabledInt:= True;
end;

procedure AnimMouseDisableInt;
begin
  AnimMouseEnabledInt:= False;
end;

procedure AnimIntMouse(bx,cx,dx : integer);
{rezidentni cast ovladace mysi}
var Sir: integer;
    bitrovina: byte;
begin
  {hned tedkonc vobslouzime tlacitka mysi}
  {cosi se stalo: zapiseme tedy dobu, kdy k akci mysi nastalo,
   kvuli testovani necinnosti mysky...}
  AnimMouseUnemployed:= TimerDW;
  if TlacitkoZpracovane and(bx<>AnimMouseOldKey) then begin
    AnimMouseOldKey:=bx;
    TlacitkoZpracovane:= False;
  end;
  if (not AnimMouseSwitchedOn)or
     (not AnimMouseEnabledInt)then exit;
  {vypadneme, pokud je myska vypnuta a ---je viditelna????---}
  {samozrejme vypadneme taky pokud je zakazano preruseni mysi}
  AnimMouseDisableInt;
  {Nepovolime preruseni mysky; mozna je to zbytecne; treba to za nas
   myska udela sama...}
    Inc(CompareMouseCount);
    asm
      mov      dx, 3C4h
      mov      al, 2
      out      dx, al
      inc      dx
      in       al, dx
      mov      bitrovina, al
    end;
    if CompareMouseCount=CompareMouseDelay then begin
      {protoze porovnavani mysi s objekty zabere neco casu, budeme
       to delat tak zhruba po dvou bodech (da se to nastavit v C..M..Delay)}
      CompareMouseCount:=0;
      CompareMouseWithObjects;
    end;
    if (VisAnimMouseX<> cx div 2)or(VisAnimMouseY<> dx) then begin
      SetActivePage(ActivePage XOR 1);
      if VisActive then PutMousePart(VisAnimMouseX-HotAnimMouseX, VisAnimMouseY-HotAnimMouseY,
        0,0,320,200, VisAnimMouseBackgrnd);
      VisAnimMouseX := cx div 2;
      VisAnimMouseY := dx;
      Sir:= VisAnimMouseX-HotAnimMouseX;
      if Sir< 0 then GetImage(320+Sir, VisAnimMouseY-HotAnimMouseY-1, AnimMouseWidth, AnimMouseHeigth, VisAnimMouseBackgrnd)
      else GetImage(Sir, VisAnimMouseY-HotAnimMouseY, AnimMouseWidth, AnimMouseHeigth, VisAnimMouseBackgrnd);
      PutMaskMousePart(Sir, VisAnimMouseY-HotAnimMouseY, 0, 0, 320, 200, AnimMouseImage);
      VisActive:= True;
      SetActivePage(ActivePage XOR 1);
    end;
    asm
      mov      dx, 3C4h
      mov      al, 2
      out      dx, al
      inc      dx
      mov      al, bitrovina
      out      dx, al
    end;
  AnimMouseEnableInt;
end;

procedure AnimMouseNewImage(HotX, HotY : integer; P : pointer);
{ Zmeni obrazek }
begin
  AnimMouseDisableInt;
  AnimMouseImage:= P;
  AnimMouseWidth:= PWordArray(P)^[0];
  AnimMouseHeigth:= PWordArray(P)^[1];
  HotAnimMouseX:= HotX;
  HotAnimMouseY:= HotY;
  AnimMouseEnableInt;
end;

procedure AnimMouseOn(HotX, HotY : integer; P : pointer);
{ Zapne rezidentni ovladac mysi s obrazkem v prom. P            }
begin
  AnimMouseDisableInt;
  AnimMouseImage:= P;
  AnimMouseWidth:= PWordArray(P)^[0];
  AnimMouseHeigth:= PWordArray(P)^[1];
  HotAnimMouseX:= HotX;
  HotAnimMouseY:= HotY;
  NewImage(AnimMouseWidth, AnimMouseHeigth, UnvAnimMouseBackgrnd);
  NewImage(AnimMouseWidth, AnimMouseHeigth, VisAnimMouseBackgrnd);
  asm
    mov  ax, 000ch
    mov  cx, 0ffffh
    mov  dx, offset @ZdeMys
    push cs
    pop  es
    int  33h
    mov  ax, ds
    mov  word ptr cs:[@DS], ax
    mov  ax, bp
    mov  word ptr cs:[@BP], ax
    jmp  @Konec
  @ZdeMys:
{pushnuti i popnuti registru by za nas mel udelat ovladac mysi}
    mov  ax, word ptr cs:[@DS]
    mov  ds, ax
    mov  ax, word ptr cs:[@BP]
    mov  bp, ax
    push bx
    push cx
    push dx
{hodili zme na zasobnik sourad. mysi, aby si je to vyzralo jako parametry}
    Call AnimIntMouse
    retf
  @DS:  dw 0
  @BP:  dw 0
  @Konec:
  end;
  AnimMouseSwitchOn;
end;

procedure AnimMouseOff;
{ Vypne rezidentni ovladac mysi                                 }
begin
  asm
    mov  ax, 000ch
    mov  cx, 0
    int  33h
  end;
  AnimMouseSwitchOff;
  DisposeImage(VisAnimMouseBackgrnd);
  DisposeImage(UnvAnimMouseBackgrnd);
end;

procedure AnimMousePaint;
var
  Sir: integer;
begin
  Sir:= VisAnimMouseX-HotAnimMouseX;
  if Sir< 0 then GetImage(320+Sir, VisAnimMouseY-HotAnimMouseY-1, AnimMouseWidth, AnimMouseHeigth, UnvAnimMouseBackgrnd)
  else GetImage(Sir, VisAnimMouseY-HotAnimMouseY, AnimMouseWidth, AnimMouseHeigth, UnvAnimMouseBackgrnd);
  PutMaskMousePart(VisAnimMouseX-HotAnimMouseX, VisAnimMouseY-HotAnimMouseY, 0,0,320,200, AnimMouseImage);
  UnvActive:= True;
end;

procedure AnimMouseErase;
begin
{$ifdef ladim}
  if Lad then begin
    Bar(UnvAnimMouseX-HotAnimMouseX, UnvAnimMouseY-HotAnimMouseY, AnimMouseWidth, AnimMouseHeigth, 0);
    Nizko;
    repeat until KeyPressed;
    ReadKey;
  end;
{$endif}
  PutMousePart(UnvAnimMouseX-HotAnimMouseX, UnvAnimMouseY-HotAnimMouseY, 0,0,320,200, UnvAnimMouseBackgrnd);
  UnvActive:= False;
{$ifdef ladim}
  Nizko;
{$endif}
end;

procedure AnimMouseSwitchOn;
var Sir : integer;
begin
  if not AnimMouseSwitchedOn then begin
    VisAnimMouseX:= MouseX;
    VisAnimMouseY:= MouseY;
    UnvAnimMouseX:= VisAnimMouseX;
    UnvAnimMouseY:= VisAnimMouseY;
    SetActivePage(ActivePage XOR 1);
    {prepnul jsem se do viditelne stranky}
    Sir:= VisAnimMouseX-HotAnimMouseX;
    if Sir< 0 then GetImage(320+Sir, VisAnimMouseY-HotAnimMouseY-1, AnimMouseWidth, AnimMouseHeigth, VisAnimMouseBackgrnd)
    else GetImage(Sir, VisAnimMouseY-HotAnimMouseY, AnimMouseWidth, AnimMouseHeigth, VisAnimMouseBackgrnd);
    {nabral jsem si z ni pozadi}
    PutMaskMousePart(VisAnimMouseX-HotAnimMouseX, VisAnimMouseY-HotAnimMouseY, 0,0,320,200, AnimMouseImage);
    VisActive:= True;
    {a placnul jsem do ni mys}
    SetActivePage(ActivePage XOR 1);
    {a este si naberu pozadi, co je v neviditelne strance:}
    if Sir< 0 then GetImage(320+Sir, VisAnimMouseY-HotAnimMouseY-1, AnimMouseWidth, AnimMouseHeigth, UnvAnimMouseBackgrnd)
    else GetImage(Sir, VisAnimMouseY-HotAnimMouseY, AnimMouseWidth, AnimMouseHeigth, UnvAnimMouseBackgrnd);
    UnvActive:= False;
  {  PutMaskMousePart(VisAnimMouseX-HotAnimMouseX, VisAnimMouseY-HotAnimMouseY, 0,0,320,200, AnimMouseImage);}
    AnimMouseEnableInt;
    AnimMouseSwitchedOn:= True;
  end;
end;

procedure AnimMouseSwitchOff;
begin
  AnimMouseDisableInt;
  if AnimMouseSwitchedOn then begin
    SetActivePage(ActivePage XOR 1);
    if VisActive then PutMousePart(VisAnimMouseX-HotAnimMouseX, VisAnimMouseY-HotAnimMouseY,
      0,0,320,200, VisAnimMouseBackgrnd);
    SetActivePage(ActivePage XOR 1);
    if UnvActive then PutMousePart(UnvAnimMouseX-HotAnimMouseX, UnvAnimMouseY-HotAnimMouseY,
      0,0,320,200, UnvAnimMouseBackgrnd);
  end;
  AnimMouseSwitchedOn:= False;
end;


{ **************************************************************** }
{                     _animace_, animacni objekty                  }
{ **************************************************************** }
const
  LengthOf_TAObjTab= 100;

var
  AObjsPriorityTab: array[0..255] of byte;
                        {tabulka hodnot priority jednotlivych objektu,
                         je alokovana pro vsech moznych 256 objektu,
                         ve skutecnosti obsahuje data pouze pro zaregistrovane
                         objekty, cili po polozku [LastAObj]
                         CO TIM CHCI RICT: vsechny objekty se tlaci
                         k zacatku tabulky, v tabulce nejsou zadne diry }
 {Priorita objektu: 0 - nejnizsi, objekt se vubec nezobrazuje
                    1 - nejnizsi mozna, pri ktere se objekt zobrazi,
                        je pak uplne dole }

  AObjsOrderTab: array[0..255] of byte;
                        {tabulka cisel objektu serazenych podle
                         vzestupne priority. Cislo objektu je
                         indexem do tabulky predchozi.
                         AObjsOrderTab se pouziva pri placani
                         objektu pres sebe, kdy se musi zacit
                         od tech s nejmensi prioritou. Proto se
                         vzdy pred tiskem cisla objektu seradi
                         do tehle tabulky podle priority}


procedure PrepareAnimation;
{nastavi vsechny interni promenne a pripravi system na zaregistrovani
 vsech objektu, nastavi jinou stranku viditelnou, nez aktivni}
begin
  LastAObj:= 255;
end;

procedure AddImageAObj(var ObjNum: byte);
{ DefPriority, DefLastSprite,
   DefDisableErasing: byte; StartX, StartY: integer);}
{obalove volani, prida animacni objekt typu Image na konec tabulky, vyhradi
 v tabulce misto pro adresy jednotlivych sprajtu: (LastSprite+1)*4 byte }
{prida animacni objekt na konec tabulky, vyhradi v tabulce misto pro adresy
 jednotlivych sprajtu: (LastSprite+1)*4 byte }
{prioritu mu nastavi spravne do tabulky objektu, v tabulce priorit
 nastavi 0 (neviditelno), pred pouzitim objektu se musi dat Visible...}
begin
  Inc(LastAObj);
  ObjNum:= LastAObj;
  GetMem(AObjsAddressTab[LastAObj], LengthOf_TAObjTab);
  AObjsPriorityTab[LastAObj]:= 0;{DefPriority;}
  AObjsOrderTab[LastAObj]:= LastAObj;
  with AObjsAddressTab[LastAObj]^ do begin
    TypeOfObj:= Image;
    AnimCommand:= AComNone;
    Mirrored:= 0;
  end;
end;

procedure SetTextDimensions(ObjNum: byte; _Text: PString; _Font: PFont);
{Spocita rozmety textu podle toho, na kolik je clenen radku a jakym
 fontem ma byt tisteny}
{prechod na dalsi radek znaci znak '|' !!!! Retezec musi koncit znakem '|' !!!!! }
var
  TextFrom: byte;    {Posledni pozice v prohledavanem textu}
  PosInString: byte; {Pozice v prohledavanem stringu}
  TextWidth: integer;{Nejvetsi sirka textu - ja hlupak, rok jsem tady mel
                      byte a neprisel jsem na to!
                      Kdyz uz me napadlo, ze sirka textu nekde mylne
                      pocita s byte misto s integer, byla to otazka
                      nekolika sekund...
                      Po predchozim marnem patrani v rutinkach WidthOfText...}
begin
  with AObjsAddressTab[ObjNum]^ do begin
    PosInString:= 0;
    TextFrom:= 1;
    Lines:= 255;
    TextWidth:= 0;
    repeat begin
      PosInString:= PosFrom(_Text^, '|', PosInString+1);
      if TextWidth < RealWidthOfTextPart(_Font, _Text^, TextFrom, PosInString-TextFrom, False)
      then TextWidth:= RealWidthOfTextPart(_Font, _Text^, TextFrom, PosInString-TextFrom, False);
      {Ze vsech radku beru sirku toho nejsirsiho jako sirku celeho textu}
      TextFrom:= PosInString+1;
      Inc(Lines);         {zvetsil jsem pocet radku}
    end until PosInString= Length(_Text^);
    {v  LastSprite  mame nyni pocet radek-1}
    NewWidth:= TextWidth;
    {V NewWidth je u textu vzdy sirka textu}
    NewHeigth:= (Lines+1)*HeigthOfFont(_Font);
    {V NewHeigth je u textu vzdy vyska celeho textu}
  end;
end;

procedure AddTextAObj(var ObjNum: byte; _Font: PFont);
{prida animacni objekt na konec tabulky, pocita s tim, ze jde o textovy
 objekt, zaznamena do tabulky adresy fontu a retezce, zaznamena barvu
 kterou se ma tisknout (FonColor1) }
{text muze byt dokonce clenen na radky, prechod na dalsi radek znaci
 znak '|' !!!! Retezec musi koncit znakem '|' !!!!! }
begin
  Inc(LastAObj);
  ObjNum:= LastAObj;
  GetMem(AObjsAddressTab[LastAObj], LengthOf_TAObjTab);
  AObjsPriorityTab[LastAObj]:= {DefPriority}0;
  AObjsOrderTab[LastAObj]:= LastAObj;
  with AObjsAddressTab[LastAObj]^ do begin
    TypeOfObj:= Text;
    AnimCommand:= AComNone;

    FontAddr:= _Font;
  end;
end;

procedure NewTextAObj(ObjNum: byte; _Text: PString);
begin
  with AObjsAddressTab[ObjNum]^ do begin
    TextAddr:= _Text;
    SetTextDimensions(ObjNum, TextAddr, FontAddr);
  end;
end;

procedure AddSpriteToObj(ObjNum: byte; SpriteAddress: pointer);
{zapise adresu urceneho sprajtu do tabulky jednoho objektu cislo ObjNum}
begin
  with AObjsAddressTab[ObjNum]^ do begin
    Sprite:= SpriteAddress;
  end;
end;

function ReleaseLastAObj: pointer;
{uvolni posledni animacni objekt (ten, co je nejvic nahore) z tabulky-
 ciste jenom data objektu! Zadne sprajty to neuvolnuje! (Hura!)}
begin
  ReleaseLastAObj:= AObjsAddressTab[LastAObj]^.Sprite;
  FreeMem(AObjsAddressTab[LastAObj], LengthOf_TAObjTab);
  Dec(LastAObj);
end;

procedure BackToVirginAObj(ObjNum: byte);
{Nastavi to vsechny potrebny hodnoty pro objekt pred opetovnym
 pouzitim napr. v dalsi mistnosti}
begin
  AObjsPriorityTab[ObjNum]:= 0;
cleanaobjsorder;
  AObjsOrderTab[ObjNum]:= ObjNum;
  with AObjsAddressTab[ObjNum]^ do begin
    AnimCommand:= AComNone;
    AComCounter:=0;
  end;
end;

procedure RepaintAObj(ObjNum: byte);
{preda prikaz animatoru, aby bylo image objektu znovu nakresleno}
{pouziti predevsim (a pravdepodopbne i jedine) v pripade, ze objekt}
{ma v pameti vyhrazeno misto jenom pro adresu jedineho sprajtu}
{a prechod na jiny sprajt se resi zmenou pointru, ktery ukazuje}
{vzdy na aktualni sprajt}
begin
  with AObjsAddressTab[ObjNum]^ do begin
    AnimCommand:= AComRepaint;
    AComCounter:= 2; {repaintuju do 2 stranek...}
    {zaznamenam jeho vysku i sirku:}
  end;
end;


function IsVisibleAObj(ObjNum: byte): boolean;
begin
  IsVisibleAObj:= (AObjsPriorityTab[ObjNum]<>0);
end;

procedure VisibleAObj(ObjNum: byte);
{zviditelni objekt tak, ze mu do tabulky priority vsech objektu da
 skutecnou hodnotu priority ulozenou v tabulce toho jednoho objektu
 (predtim, kdyz byl neviditelny, zustala priorita v tabulce toho
 objektu stale puvodni, kdezto priorita v tabulce priorit vsech
 objektu se zmenila na 0 = neviditelny) }
begin
  with AObjsAddressTab[ObjNum]^ do begin
    if (AnimCommand= AComNone)and(AObjsPriorityTab[ObjNum]= 0) then begin
      AObjsPriorityTab[ObjNum]:= Priority;
      AnimCommand:= AComVisible;
      AComCounter:= 2;
      {Pokud zviditelnuju objekt, mel bych obnovit i vysku a sirku objektu}
    end;
  end;
end;

procedure VisibleAObj1Bob(ObjNum: byte; _NewWidth,_NewHeigth:integer);
begin
  with AObjsAddressTab[ObjNum]^ do
    if (AnimCommand= AComNone)and(AObjsPriorityTab[ObjNum]= 0) then begin
      AObjsPriorityTab[ObjNum]:= Priority;
      AnimCommand:= AComVisible;
      AComCounter:= 2;
      NewWidth:=_NewWidth;
      NewHeigth:=_NewHeigth;
    end;
end;

procedure UnvisibleAObj(ObjNum: byte);
{pripravi objekt na zneviditelni tak, ze kreslici procedure preda prikaz pro}
{jeho zneviditelneni; ostatni uz vykona prave kreslici procedura}
begin
  with AObjsAddressTab[ObjNum]^ do begin
    AnimCommand:= AComUnvisible;
    AComCounter:= 2;
  end;
end;

procedure NewPriorityAObj(ObjNum, NewPriority: byte);
{zmeni prioritu objektu}
begin
  AObjsPriorityTab[ObjNum]:= NewPriority;
  AObjsAddressTab[ObjNum]^.Priority:= NewPriority;
end;

procedure StartPriorityAObj(ObjNum, StartPriority: byte);
{zmeni prioritu objektu}
begin
  AObjsAddressTab[ObjNum]^.Priority:= StartPriority;
end;

procedure NewPosAObj(ObjNum: byte; DefNewX, DefNewY: integer);
{priradi objektu nove souradnice}
begin
  AObjsAddressTab[ObjNum]^.NewX:= DefNewX;
  AObjsAddressTab[ObjNum]^.NewY:= DefNewY;
end;

procedure StartPosAObj(ObjNum: byte; StartX, StartY: integer);
{priradi objektu nove souradnice}
begin
  with AObjsAddressTab[ObjNum]^ do begin
    NewX:= StartX;
    NewY:= StartY;
    X:= StartX;
    Y:= StartY;
    OldX:= StartX;
    OldY:= StartY;
  end;
end;

function GetNewXAObj(ObjNum: byte): integer;
begin
  GetNewXAObj:= AObjsAddressTab[ObjNum]^.NewX;
end;

function GetNewYAObj(ObjNum: byte): integer;
begin
  GetNewYAObj:= AObjsAddressTab[ObjNum]^.NewY;
end;

function GetNewWidthAObj(ObjNum: byte): integer;
begin
  GetNewWidthAObj:= AObjsAddressTab[ObjNum]^.NewWidth;
end;

function GetNewHeigthAObj(ObjNum: byte): integer;
begin
  GetNewHeigthAObj:= AObjsAddressTab[ObjNum]^.NewHeigth;
end;

procedure NewFonColorAObj(ObjNum, Color: byte);
{nastavi novou barvu pisma u objektu typu Text, pokud neni objekt typu
 Text, posere se to}
begin
  AObjsAddressTab[ObjNum]^.FonColor:= Color;
end;

procedure NewMirrorAObj(ObjNum, DefMirror: byte);
{vypne objekt typu Image ze zrcadloveho do normalniho zobrazovani}
begin
  AObjsAddressTab[ObjNum]^.Mirrored:= DefMirror;
end;

procedure NewZoomAObj(ObjNum: byte; ZoomedWidth, ZoomedHeigth: integer);
{zapise to zoomovane rozmery sprajtu do tabulky objektu. Pokud je zoomovany
 rozmer zadany jako 0 anebo je-li shodny s originalnim rozmerem image, nezmeni
 to rozmery, v opacnem pripade zapise zoomovane rozmery do tabulky jako
 rozmer sprajtu- sprajt je pak kreslen presne v techto rozmerech...}
begin
  with AObjsAddressTab[ObjNum]^ do begin
    if (ZoomedWidth<>0)and(ZoomedWidth<>PWordArray(Sprite)^[0])
    then NewWidth:= ZoomedWidth
    else NewWidth:= PWordArray(Sprite)^[0];
    if (ZoomedHeigth<>0)and(ZoomedHeigth<>PWordArray(Sprite)^[1])
    then NewHeigth:= ZoomedHeigth
    else NewHeigth:=  PWordArray(Sprite)^[1];
  end;
end;

procedure StartDisableErasingAObj(ObjNum, Setting: byte);
{nastavi zpusob prekreslovani sprajtu - maze se/nemaze se}
begin
  AObjsAddressTab[ObjNum]^.DisableErasing:= Setting;
end;

procedure CleanAObjsOrder;
var i:byte;
begin
  for i:=0 to lastaobj do
    aobjsordertab[i]:=i;
end;

procedure SortAObjsOrder;
{setridi cisla objektu podle jejich priority; pouze INTERNI}
var
  WithoutChange: boolean;
  SortedObj: byte;
  HelpOrder: byte;
begin
  if LastAObj>0 then repeat
    WithoutChange:= True;
    for SortedObj:= 0 to LastAObj-1 do begin
      if AObjsPriorityTab[ AObjsOrderTab[SortedObj] ] > AObjsPriorityTab[ AObjsOrderTab[SortedObj+1] ]then begin
        begin
          WithoutChange:= False;
        end;
        begin
          HelpOrder:= AObjsOrderTab[SortedObj+1];
        end;
        begin
          AObjsOrderTab[SortedObj+1]:= AObjsOrderTab[SortedObj];
        end;
        begin
          AObjsOrderTab[SortedObj]:= HelpOrder;
        end;
      end;
    end;
  until WithoutChange;
end;

procedure CompareMouseWithObjects;
{Problemy se vyskytnou, chceme-li porovnavat s obrazkem,
 ktery ma jine rozmery, nez originalni a/nebo ktery je zrcadleny!
 V takovem pripade to nebude fungovat, porovnava to totiz vzdy
 jenom s originalem!}
{!!!!!!!!!!!!!!}
{ POZOR!!!! animacni objekty musi byt setridene podle priority!!}
var
  OrderCompObj, ComparedObj: byte;
  WhereMouseX, WhereMouseY: word; {soucet Mouse.. a HotMouse..}
begin
  WhereMouseX:= MouseX{+HotAnimMouseX}; {LS&Bob: pry uz je odecteno pri PUTnuti}
  WhereMouseY:= MouseY{+HotAnimMouseY};
  AnimObjectUnderMouse:= 255;
  for OrderCompObj:= 0 to LastAObj do begin
    ComparedObj:= AObjsOrderTab[OrderCompObj];
    if ComparedObj=G_BubbleAObj then continue;

    with AObjsAddressTab[ComparedObj]^ do begin
      if (AObjsPriorityTab[ComparedObj]> 0)and(AnimCommand<AComUnvisible)
      and(TypeOfObj= AnimWhatObjectsMousePoints)then
        {Pokud je objekt viditelny, a pokud je typu, se kterym se ma mys porovnavat...}
        if(WhereMouseX>=NewX)and(WhereMouseX<NewX+NewWidth)and(WhereMouseY>=NewY)and(WhereMouseY<NewY+NewHeigth)then
          {otestuji nejdrive, jestli se mys nachazi na "uzemi" tohoo objektu...}
          if(TypeOfObj= Text) then AnimObjectUnderMouse:= ComparedObj
          {u Text staci jenom, kdyz je mys v prislusnych souradnicich}
          else begin
 if TestImageMaskMirrorZoom(
   Newx,Newy,
   Sprite,
   255,         {maskovaci barva}
   mirrored,    {zrcadlit Ano/Ne True/False}
   NewWidth,NewHeigth, {velikost zoomovana}
   WhereMouseX,WhereMouseY)
            {Kdezto u Image je to slozitejsi...}
            then AnimObjectUnderMouse:= ComparedObj;
            {Image testuju na barvu 255, pokud je pod mysi, jako by na
             objekt nys neukazovala}
          end;
    end;
  end;
end;

procedure SmartPutAObjs;
{nakresli vsechny objekty na obrazovku tak, jak maji byt}
var
  ActualObj: byte; {cislo aktualniho objektu}
  OrderPaintObj: byte;{ poradi v tabulce AObjsOrderTab, ktera
                        obsahuje cisla objektu}
  OrderCompObj: byte;{ poradi v tabulce AObjsOrderTab, ktera
                        obsahuje cisla objektu}
  PaintedObj: byte; {cislo prave vykreslovaneho objektu}
  ComparedObj: byte; {cislo objektu, se kterym je prave}
                     {vykreslovany objekt "porovnavan" vlastne tak,}
                     {ze se z neho berou souradnice oblasti, kde se}
                     {ma kreslit}
  AreaX:integer;    {souradnice, atd. pro oblast, ktera je}
  AreaY:integer;    {prave vykreslovana}
  AreaWidth:word;
  AreaHeigth:word;
  TextFrom, TextTo, TextLine: byte;
  PrintedText: string;

  procedure MarkAreas;
  var ActualObj: byte; {cislo aktualniho objektu}
  begin
    {A pristoupim k tomu, ze si kazdy oznaci oblasti, ktere budou muset}
    {byt kvuli nemu znovu vykresleny:}
    for ActualObj:= 0 to LastAObj do begin

      if AObjsPriorityTab[ActualObj]>0 then begin {Pokud je obj. viditelny,
                                                   budu overovat dal...}
        with AObjsAddressTab[ActualObj]^ do begin
          AreaUnderWidth:= 0; {Na zacatek dam do rozmeru prekreslovane oblasti}
          AreaAboveWidth:= 0; {jak POD, tak NAD, NULU, ktera znamena, ze se nic}
          AreaUnderHeigth:= 0;
          AreaAboveHeigth:= 0;
                              {kvuli tomuto objektu znovuvykreslovat nebude}
          if(AnimCommand<>AComNone){Kdyz se jedna o objekt, se kterym ma byt}
                                   { neco provedeno...}
          then begin {potom tedy zaznamename plochu, ktera se bude prekreslovat}
            {nejdrive POD:}
            if (DisableErasing=0)and(AnimCommand<>AComVisible) then begin
            {-je samozrejme zbytecne definovat plochu pod, jestlize se jedna}
            {o objekt, ktery ma dano, ze se pod sebou nema smazavat, anebo}
            {jde-li o objekt, ktery se prave stava viditelnym, tudiz pod nim}
            {zatim stejne nic nebylo, co by se melo znova vykreslit}
               AreaUnderX:= OldX;
               AreaUnderY:= OldY;
               AreaUnderWidth:= OldWidth;
               AreaUnderHeigth:= OldHeigth;
               if ( (AreaUnderX+AreaUnderWidth)<=0 )or( (AreaUnderY+AreaUnderHeigth)<=0 )
                 or(AreaUnderX>319)or(AreaUnderY>199)
               then begin
                 AreaUnderWidth:= 0; {V pripade, ze plocha vubec nezasahuje}
                         {do obrazovky, poznacim, ze se nic kvuli tomuto}
                         {objektu prekreslovat nebude a "slozite"(?) vypocty}
                         {prekreslovane oblasti preskocim}
               end else begin
                 if AreaUnderX<0 then begin
                   AreaUnderWidth:=AreaUnderWidth+AreaUnderX;
                   AreaUnderX:=0;
                 end;
                 if AreaUnderY<0 then begin
                   AreaUnderHeigth:=AreaUnderHeigth+AreaUnderY;
                   AreaUnderY:=0;
                 end;
                 if AreaUnderX+AreaUnderWidth>320 then AreaUnderWidth:=320-AreaUnderX;
                 if AreaUnderY+AreaUnderHeigth>200 then AreaUnderHeigth:=200-AreaUnderY;
                   {upravil jsem rozmery oblasti v pripade, ze presahovaly obrazovku}
               end;
            end;

            {a nyni i NAD:}
            if NewWidth>= OldWidth then AreaAboveWidth:= NewWidth
            else  AreaAboveWidth:= OldWidth;
            if NewHeigth>= OldHeigth then AreaAboveHeigth:= NewHeigth
            else  AreaAboveHeigth:= OldHeigth;
            if (AnimCommand< AComVisible) then begin
              AreaAboveWidth:= AreaAboveWidth+Abs(OldX-NewX);
              AreaAboveHeigth:=AreaAboveHeigth+Abs(OldY-NewY);
            end;
            {vzal jsem celou sirku znovuprekreslovane oblasti, ktera}
            {zahrnuje jak stary, tak novy sprajt(pozici)- ovsem pouze v pripade,}
            {ze neni aplikovan zadny z animacnich prikazu; pokud je, staci}
            {mi pouze sirka a vyska samotneho sprajtu}
            if (AnimCommand> AComVisible) then AreaAboveX:= OldX
              {..pokud to je Unvisible...}
            else if (AnimCommand= AComVisible) then AreaAboveX:= NewX
            else if (OldX<NewX) then AreaAboveX:= OldX
            else AreaAboveX:= NewX;
            if (AnimCommand> AComVisible) then AreaAboveY:= OldY
            else if (AnimCommand= AComVisible) then AreaAboveY:= NewY
            else if (OldY<NewY) then AreaAboveY:= OldY
            else AreaAboveY:= NewY;
            {beru ten roh, ktery je vic vlevo/nahore, aby oblast}
            {byla opravdu cela, ale jen kdyz neni uplatnen nejaky z animacnich}
            {prikazu, v takovem pripade beru vzdy souradnice Old..}
            if ( (AreaAboveX+AreaAboveWidth)<=0 )or( (AreaAboveY+AreaAboveHeigth)<=0 )
              or(AreaAboveX>319)or(AreaAboveY>199)
            then begin
              AreaAboveWidth:= 0; {V pripade, ze plocha vubec nezasahuje}
                      {do obrazovky, poznacim, ze se nic kvuli tomuto}
                      {objektu prekreslovat nebude a "slozite"(?) vypocty}
                      {prekreslovane oblasti preskocim}
            end else begin
              if AreaAboveX<0 then begin
                AreaAboveWidth:=AreaAboveWidth+AreaAboveX;
                AreaAboveX:=0;
              end;
              if AreaAboveY<0 then begin
                AreaAboveHeigth:=AreaAboveHeigth+AreaAboveY;
                AreaAboveY:=0;
              end;
              if AreaAboveX+AreaAboveWidth>320 then AreaAboveWidth:=320-AreaAboveX;
              if AreaAboveY+AreaAboveHeigth>200 then AreaAboveHeigth:=200-AreaAboveY;
                {upravil jsem rozmery oblasti v pripade, ze presahovaly obrazovku}
            end;

          end else begin
            {nic se neprekresluje- neni dynamicky a ani nic na sobe nezmenil}
          end;
        end; {with}

      end;{if AObjsPriorityTab[ActualObj]>0..}
    end;{for}
  end;

begin
  {Setridim vsechny objekty podle vzestupne priority:}
  SortAObjsOrder;

  if(AnimRepaintPage=0)and(AnimEnableClearScreen=0)then begin
  {Pokud zrovna vypinam debugovaci info, nebo:...}
                             {pokud neni nastavene mazani}
                             {obrazovky, naplacam tam ty objekty chytre}
                             {="smart", jenom to, co je potreba}
                             {V opacnem pripade...}

    MarkAreas;
    {oznacim oblasti}

{a nyni vsechny objekty nakreslim}
{nejdriv ovsem vymazu starou mys}
{$ifdef ladim}
    if Lad then SetVisualPage(ActivePage);
{$endif}
    if AnimMouseSwitchedOn then begin
      AnimMouseDisableInt;
{$ifdef ladim}
      if Lad then begin
        repeat until KeyPressed;
        ReadKey;
        Nizko;
        Vysoko;
        Nizko;
      end;
{$endif}
      AnimMouseErase;
      AnimMouseEnableInt;
    end;

{sortaobjsorder;}
    for OrderPaintObj:= 0 to LastAObj do begin
{$ifdef ladim}
      if Lad then begin
        repeat until KeyPressed;
        ReadKey;
        Vysoko;
      end;
{$endif}
      PaintedObj:= AObjsOrderTab[OrderPaintObj];
      if AObjsPriorityTab[PaintedObj]>0 then begin {objekt je viditelny, musime}
                                                   {ho nechat projit kreslici smyckou}
        with AObjsAddressTab[PaintedObj]^ do begin
          if(AnimCommand<>AComUnvisible)then begin
            if TypeOfObj= Image then begin {pokud se jedna o obrazek, budeme}
                                               {ho kreslit jenom potrebne casti,}
                                               {ale text... viz  end else...}
               if(AreaAboveWidth<>0)then begin
                 {pokud objekt kresli sama sebe, nakresli se rovnou cely,}
                 {a pozadavky ostatnich objektu o nakresleni casti budou}
                 {ignorovany}
                 {POkud se jedna o image mysi, bude vzdy vykresleno, protoze
                  by melo byt vzdy nahore. (Kvuli textum, protoze ty se
                  tisknou pokazde, a mys ma byt nad nimi}
                 {Kreslime ho cely; i kdyz na zaporne souradnice, orizne se
                  do obrazovky}
                 if (NewWidth=PWordArray(Sprite)^[0])
                 and (NewHeigth=PWordArray(Sprite)^[1])
                 then begin
                   {tisknu nezoomovane}
                   if Mirrored=0 then begin
                     PutMaskImagePart(NewX, NewY, 0, 0, 320, 200, Sprite);
                   end else begin
                     PutMirrorMaskImagePart(NewX, NewY, 0, 0, 320, 200, Sprite);
                   end;{if Mirrored=..}
                 end else begin
                   {tisknu zoomovane}
                   if Mirrored=0 then begin
                     PutMaskImagePartZoom(NewX, NewY, NewWidth, NewHeigth,
                      0, 0, 320, 200, Sprite);
                   end else begin
                     PutMirrorMaskImagePartZoom(NewX, NewY, NewWidth, NewHeigth, 0, 0, 320, 200, Sprite);
                   end;{if Mirrored=..}
                 end;
               end else begin
                 {k provereni, jake casti se maji nakreslit, pristoupime teprve}
                 {tehdy, kdyz se objekt neprekresloval sam od sebe}
                 if OrderPaintObj>0 then for OrderCompObj:=0 to OrderPaintObj-1 do begin
                   {nejdriv projedu ty objekty, ktery jsou pod, takze z nich budu}
                   {"porovnavat" se souradnicema ...Above...}
                   ComparedObj:= AObjsOrderTab[OrderCompObj];
                   AreaWidth:=AObjsAddressTab[ComparedObj]^.AreaAboveWidth;
                   AreaHeigth:=AObjsAddressTab[ComparedObj]^.AreaAboveHeigth;
                   if (AObjsPriorityTab[ComparedObj]>0)and(AreaWidth<>0)and(AreaHeigth<>0)then begin
                     AreaX:= AObjsAddressTab[ComparedObj]^.AreaAboveX;
                     AreaY:= AObjsAddressTab[ComparedObj]^.AreaAboveY;
                     {a nyni probehne jiz skutecne vykresleni:}
		     begin
                       {tisknu zoomovane}
                       if Mirrored=0 then begin
                         PutMaskImagePartZoom(NewX, NewY, NewWidth, NewHeigth,
                           AreaX, AreaY, AreaWidth, AreaHeigth, Sprite);
                       end else begin
                         PutMirrorMaskImagePartZoom(NewX, NewY, NewWidth, NewHeigth,
                           AreaX, AreaY, AreaWidth, AreaHeigth, Sprite);
                       end;{if Mirrored=..}
                     end;
                   end;
                 end;
                 if (OrderPaintObj<LastAObj) then for OrderCompObj:=OrderPaintObj+1 to LastAObj do begin
                   {a pak i ty objekty, ktery jsou nad, takze z nich budu}
                   {"porovnavat" se souradnicema ...Under...}
                   ComparedObj:= AObjsOrderTab[OrderCompObj];
                   AreaWidth:=AObjsAddressTab[ComparedObj]^.AreaUnderWidth;
                   AreaHeigth:=AObjsAddressTab[ComparedObj]^.AreaUnderHeigth;
                   if (AObjsPriorityTab[ComparedObj]>0)and(AreaWidth<>0)and(AreaHeigth<>0)then begin
                     AreaX:= AObjsAddressTab[ComparedObj]^.AreaUnderX;
                     AreaY:= AObjsAddressTab[ComparedObj]^.AreaUnderY;
                     {a nyni probehne jiz skutecne vykresleni:}
		     begin
                       {tisknu zoomovane}
                       if Mirrored=0 then begin
                         PutMaskImagePartZoom(NewX, NewY, NewWidth, NewHeigth,
                          AreaX, AreaY, AreaWidth, AreaHeigth, Sprite);
                       end else begin
                         PutMirrorMaskImagePartZoom(NewX, NewY, NewWidth, NewHeigth,
                          AreaX, AreaY, AreaWidth, AreaHeigth, Sprite);
                       end;{if Mirrored=..}
                     end;
                   end;
                 end;
               end;

            end else begin {...ale text vzdy budeme pretiskovat cely}
              FonColor1:= FonColor;
              TextFrom:= 1;
              TextTo:= 0;
              for TextLine:= 0 to Lines do begin
                TextTo:= PosFrom(TextAddr^, '|', TextTo+1);
                PrintedText:= Copy(TextAddr^, TextFrom, TextTo-TextFrom);
                PrintText(NewX+( (NewWidth-RealWidthOfText(FontAddr, PrintedText)) div 2),
                  NewY+TextLine*HeigthOfFont(FontAddr) , PrintedText, FontAddr);
                TextFrom:= TextTo+1;
              end;
            end;{if (TypeOfObject...}
          end;
        end; {with}
      end;
    end;{for}

{$ifdef ladim}
    if Lad then SetVisualPage(ActivePage XOR 1);
{$endif}

  end else begin
    if AnimRepaintPage>0 then Dec(AnimRepaintPage);

  {V pripade, ze je AnimEnableClearScreen<>0, smazu obrazovku a placnu}
  {tam znovu vsechny objekty.}
    ClearScr(AnimBackColor);
    for OrderPaintObj:= 0 to LastAObj do begin
      ActualObj:= AObjsOrderTab[OrderPaintObj];

      if AObjsPriorityTab[ActualObj]>0 then begin
        if(AObjsAddressTab[ActualObj]^.AnimCommand<>AComUnvisible)then
        with AObjsAddressTab[ActualObj]^ do begin
          if TypeOfObj= Image then begin
            if (NewWidth=PWordArray(Sprite)^[0])
            and (NewHeigth=PWordArray(Sprite)^[1])
            then begin
              {tisknu nezoomovane}
              if Mirrored=0 then begin
                PutMaskImagePart(NewX, NewY, 0, 0, 320, 200, Sprite);
              end else begin
                PutMirrorMaskImagePart(NewX, NewY, 0, 0, 320, 200, Sprite);
              end;{if Mirrored=..}
            end else begin
              {tisknu zoomovane}
              if Mirrored=0 then begin
                PutMaskImagePartZoom(NewX, NewY, NewWidth, NewHeigth, 0, 0, 320, 200, Sprite);
              end else begin
                PutMirrorMaskImagePartZoom(NewX, NewY, NewWidth, NewHeigth, 0, 0, 320, 200, Sprite);
              end;{if Mirrored=..}
            end;
          end else begin
            FonColor1:= FonColor;
            TextFrom:= 1;
            TextTo:= 0;
            for TextLine:= 0 to Lines do begin
              TextTo:= PosFrom(TextAddr^, '|', TextTo+1);
              PrintedText:= Copy(TextAddr^, TextFrom, TextTo-TextFrom);
              PrintText(NewX+( (NewWidth-RealWidthOfText(FontAddr, PrintedText)) div 2),
                  NewY+TextLine*HeigthOfFont(FontAddr) , PrintedText, FontAddr);
              TextFrom:= TextTo+1;
            end;

          end;
        end; {with}
      end;

    end;{for}
  end;

  for ActualObj:= 0 to LastAObj do begin
    with AObjsAddressTab[ActualObj]^ do begin
      if AnimCommand<>AComNone then begin
        Dec(AComCounter);
        if AComCounter=0 then begin
          if(AnimCommand=AComUnvisible)then AObjsPriorityTab[ActualObj]:= 0;
          {zneviditelni objekt tak, ze do tabulky priorit vsech objektu ulozi}
          {0 = neviditelny. Priorita v tabulce toho urciteho objektu zustava}
          {ale beze zmeny, kvuli obnoveni procedurou VisibleAObj}
          AnimCommand:=AComNone;
        end;
      end;
    end;
  end;

  if Control_On<>Control_Nothing then Control_Draw;
  if Debug_On then Debug_PrintInfo;
  if G_CheatVisible then EnterPasswordReport;

  CompareMouseWithObjects;
end;

{$ifdef ladim}
var
  Key: char;
  Page: byte;
{$endif}


procedure SwapAnimPages;
{zobrazi nakreslenou stranku a nastavi vse potrebne, aby se mohlo
 kreslit na tu druhou}
var
  ActualObj: byte; {cislo objektu, kteremu jsou prave
                    aktualizovany souradnice}
  HelpPointer: pointer;
begin
  if AnimMouseSwitchedOn then begin
{$ifdef ladim}
  PutMaskImagePart(0, 0, 0,0,320,200, UnvAnimMouseBackgrnd);
  PutMaskImagePart(30, 0, 0,0,320,200, VisAnimMouseBackgrnd);
{$endif}
    AnimMouseDisableInt;
{$ifdef ladim}
    if Lad then SetVisualPage(ActivePage);
    if Lad then begin
      repeat until KeyPressed;
      ReadKey;
      Vysoko;
      Nizko;
      Vysoko;
    end;
{$endif}
    AnimMousePaint;
{$ifdef ladim}
    if Lad then begin
      repeat until KeyPressed;
      ReadKey;
      Vysoko;
    end;
    if Lad then SetVisualPage(ActivePage XOR 1);
{$endif}
    {Na zatim neviditelnou, aktualni stranku placnu mysku na
     souradnice jako ve viditelne strance a vezmu pozadi Unv... }
  end;

{$ifdef ladim}
  Key:= #0;
  if Lad then begin
    Page:= ActivePage;
    while Key<>#13 do begin
      repeat until KeyPressed;
      Key:= ReadKey;
      if Key= #32 then begin
        Lad:= not Lad;
        Vysoko;
        Delay(100);
      end;
      if Key= 'a' then begin
        SetVisualPage(ActivePage);
        SetActivePage(ActivePage XOR 1);
        Delay(100);
      end;
    end;
  SetActivePage(Page);
  SetVisualPage(ActivePage XOR 1);
  end;
  if (KeyPressed)and(ReadKey=#32) then begin
    Lad:= not Lad;
      Vysoko;
      Delay(100);
  end;
{$endif}

  SetVisualPage(ActivePage);
  SetActivePage(ActivePage XOR 1);
{!v tomto playeru nejde, protože se ještě bude dělat třepání!!!!!
  {Prehodil jsem stranky, takze prave placnuta myska je viditelna
!uděláno totéž jinak...}

  {Myska, co byla az dosud videt, je v neviditelne strance}
  {Obe mysky maji souradnice Vis...}

  HelpPointer:= UnvAnimMouseBackgrnd;
  UnvAnimMouseBackgrnd:= VisAnimMouseBackgrnd;
  VisAnimMouseBackgrnd:= HelpPointer;
  {Nyni viditelna myska ma prozatim pozadi v Unv, nyni neviditelna
   ma pozadi ve Vis, uvedu to na pravou miru- viditelna ve Vis,
   neviditelna v Unv}
  UnvAnimMouseX:= VisAnimMouseX;
  UnvAnimMouseY:= VisAnimMouseY;
  {v neviditelne strance ma mys souradnice jako prave ted ve viditelne}
  {Prozatim obrazek mysi v neviditelne strance zustane, prekresli
   se pozadim Unv az pri provadeni SmartPutAObjs}
  if AnimMouseSwitchedOn then begin
    AnimMouseEnableInt;
  end;

  for ActualObj:= 0 to LastAObj do begin
{jina stranka, jine souradnice... kvuli stridani dvou
 stranek se deji tyhlencty cachry}
    with AObjsAddressTab[ActualObj]^ do begin
     OldX:= X;
     OldY:= Y;
     X:= NewX;
     Y:= NewY;

     OldWidth:= Width;
     OldHeigth:= Heigth;
     Width   := NewWidth;
     Heigth   := NewHeigth;
    end;
  end;
end;


procedure SaveAObjs(var outfile: file);
var i: byte;
begin
  for i:= 0 to LastAObj do BlockWrite(outfile, AObjsAddressTab[i]^, SizeOf(TAObjTab));
end;

procedure LoadAObjs(var infile: file);
var i: byte;
begin
  for i:= 0 to LastAObj do BlockRead(infile, AObjsAddressTab[i]^, SizeOf(TAObjTab));
end;


begin
  UnderMouseUserProc:= FreeUserProc;
end.
