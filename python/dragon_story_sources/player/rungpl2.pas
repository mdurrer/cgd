{$i-}
unit rungpl2;
interface {meziksicht}

uses texts, extended, crt, vars, bardfw, graform, graph256, midi01, animace4, anmplay4, sblaster, dma;

procedure FadeInPalette;
procedure FadeOutPalette;
procedure LoadBackgroundMusic(mus: byte);
procedure TakeIco(ico: byte);
procedure PutIco(ico, place: byte);
procedure NewIco;
procedure OrdinaryUpdateCursor;
procedure RoomTitleBubbleInit;
procedure UninstallRoom;
procedure MapDone;
procedure LoadGame;
{function LoadGameMenu: boolean;}
function SaveGameMenu: boolean;
procedure RunProg(what_code:pointer; idx:integer);
function Can(what_code:pointer; idx:integer): boolean;
procedure Loop;
procedure RoomMasksDone;
procedure RoomMasksInit;
procedure RoomInit; {Head, Title, programky, Map, Pal}
procedure RoomDone;
procedure ObjectInit(GameNum: integer; var ObjHd: TObjHd);
procedure ObjectDone(ObjHd: TObjHd);
procedure RoomObjectsInit;
procedure RoomObjectsDone;
procedure H_OnDeObal;

implementation

var relative_gpl_jump:integer;
    gpl_end_program:integer;
    savetimer: longint;
procedure InventoryDraw; forward;
procedure C_StartMusic; forward;
procedure C_StopMusic; forward;

procedure Debug_SaveScreenShot;
var num: string[3];
    wob: pointer;
begin
  AnimMouseSwitchOff;
  SetActivePage(ActivePage XOR 1);
  NewImage(320, 200, wob);
  GetImage(0, 0, 320, 200, wob);
  Str(Debug_ScrShot:3, num);
  if num[1]=' ' then num[1]:= '0';
  if num[2]=' ' then num[2]:= '0';
  SavePcx(wob, PPaletka(Palette), 'dh'+num+'.pcx');
  DisposeImage(wob);
  Inc(Debug_ScrShot);
  SetActivePage(ActivePage XOR 1);
  AnimMouseSwitchOn;
end;

procedure DelayTime(time: longint);
var fadetime: longint;
    aux: longint;
    i : integer;
begin
  fadetime:= TimerDW;
  aux:= 0;
  while (aux<time) do begin
    aux:= TimerDW;
    aux:= aux-fadetime;
  end;
end;

procedure FadeInPalette;
var i: byte;
    fadetime: longint;
begin
  {Predpokladam, ze v Palette je paleta mistnosti:}
  BlackPalette(G_WorkPalette);
  SetPalette(G_WorkPalette);
  init_palette_change(G_WorkPalette, Palette, G_PalDif, G_PalPred);
  for i:= 1 to 15 do begin
    fadetime:= TimerDW;
    repeat until (TimerDW-fadetime<2);
{    DelayTime(2);}
    palette_change(G_WorkPalette, 15, G_PalDif, G_PalPred);
    setpalette(G_WorkPalette);
  end;
end;

procedure FadeOutPalette;
var i: byte;
    fadetime: longint;
begin
  {V Palette je paleta obrazku}
  BlackPalette(G_WorkPalette);
  init_palette_change(Palette, G_WorkPalette, G_PalDif, G_PalPred);
  for i:= 1 to 15 do begin
    fadetime:= TimerDW;
    repeat until (TimerDW-fadetime<2);
{    DelayTime(2);}
    palette_change(Palette, 15, G_PalDif, G_PalPred);
    setpalette(Palette);
  end;
end;

procedure PrintInfo;
var i, ii, line : byte;
    addr : longint;
    x, y, adddr,mouseyy : word;
    oldpage: byte;
    pal : pointer;
    LineX, LineY: integer;
    LineFont: PFont;
begin
  FonColor1:= 255;
  x:=mousex; y:=mousey;
  getmem(pal,768);
  move(palette^,pal^,768);
  AnimMouseSwitchOff;
  FadeOutPalette;
  move(pal^,palette^,768);
  oldpage:= ActivePage;
  SetActivePage(1); ClearScr(0);
  SetActivePage(2); ClearScr(0);
  SetActivePage(3); ClearScr(0);
  SetActivePage(0); ClearScr(0);
  SetVisualPage(0);
  LineY:= 0;
  for i:=1 to maxaboutlines do with aboutlines[i] do begin
    if f=Big then LineFont:= G_BigFont else LineFont:= G_SmallFont;
    LineX:= integer(a<>Left)*(320-widthoftext(LineFont, aboutlines[i].l));
    if a=Center then LineX:= LineX div 2;
    PrintText(LineX, LineY, aboutlines[i].l, LineFont);
    Inc(LineY, HeigthOfFont(LineFont));
  end;
  FadeInPalette;
  NewMouseXY(0,100);
  mouseyy:=mousey;
  addr:=0;
  repeat
    if (mousey=0)or(mousey=199) then begin
      NewMouseXY(0,100);
      mouseyy:=100;
    end;
    if mouseyy<>mousey then addr:=addr-(longint(mouseyy)-mousey)*80;
    if addr<0 then addr:=0;
    if addr>600*80 then addr:=600*80;
    mouseyy:=mousey;
    {nutno dopsat cekani na paprsek}
    adddr:=addr;
    waitvretrace;
    asm
        mov dx,3d4h
        mov al,0ch
        out dx,al
        inc dx
        mov ax,adddr
        xchg ah,al
        out dx,al   {vyssi bajt adresy VRAM}
        dec dx
        mov al,0dh
        out dx,al
        inc dx
        mov al,ah
        out dx,al   {nizsi bajt adresy VRAM}
    end;
  until (AnimMouseKey<>0)or keypressed;
  if KeyPressed then ReadKey;
  newmousexy(x,y);
  FadeOutPalette;
  move(pal^,palette^,768);
  SetActivePage(oldpage);
  SetVisualPage(oldpage XOR 1);
  AnimMouseSwitchOn;
  AnimRepaintPage:= 2;
  Body;
  FadeInPalette;
  freemem(pal,768);
end;


{$f+}
procedure SwitchObjectOff;
begin
  UnvisibleAObj(A_SeqExtHead[A_ActSeq]^.AnimObj);
end;
{$f-}

procedure RoomTitleBubbleInit;
var i: byte;
begin
  NewTextAObj(G_TitleAObj, @G_FreeString);
  VisibleAObj(G_TitleAObj);
  NewTextAObj(G_BubbleAObj, @G_FreeString);
  VisibleAObj(G_BubbleAObj);
end;

procedure RoomTitleBubbleDone;
begin
  NewTextAObj(G_TitleAObj, @G_FreeString);
  BackToVirginAObj(G_TitleAObj);
  NewTextAObj(G_BubbleAObj, @G_FreeString);
  BackToVirginAObj(G_BubbleAObj);
end;

procedure ScreenDone;
{Po pouziti uvedeme objekt a animace draka do puvodniho stavu...}
var i: byte;
begin
  if R_Hd.MouseOn then  AnimMouseSwitchOff;
  {A tady probehne (musi probehnout) jedno male kouzlo...}
  BackToVirginAObj(G_ObjHero.AnimObj);
{  for i:= 0 to LastAObj do begin
    BackToVirginAObj(i);
  end;}
  {vratil jsem vsem (to pro jistotu, dulezite by to bylo jen u tech,
  ktere vzdy zustavaji do dalsi stranky) animacnim objektum jejich puvodni
  cistotu a neposkvrnenost}

  {Projedu vsechny sekvence a tem hlavniho hrdiny priradim prazdne
   volani a dam je, aby se neprovadely...}
  for i:= 1 to A_LastAnmSeq do begin
    if(A_SeqExtHead[i]^.MainHero> 0)then begin
      A_SeqExtHead[i]^.UserProc:= FreeUserProc;
      A_SeqExtHead[i]^.InProcess:=0;
    end;
  end;
end;

procedure UninstallRoom;
var i, j: integer;
begin
  with Debug_Info do begin
    if ActRoomMem>GlobalMaxMem then begin
      GlobalMaxMem:= ActRoomMem; GlobalMaxRoom:= G_Hd.ActRoom;
    end;
    if ActRoomMem<GlobalMinMem then begin
      GlobalMinMem:= ActRoomMem; GlobalMinRoom:= G_Hd.ActRoom;
    end;
  end;

  {odinstaluju vsechny sekvence nahrane behem provadeni mistnosti:}
  while(A_LastAnmSeq>R_UnLoadSeq)do ReleaseLastAnimationSeq;
  {a jeste namisto jejich cisel v SeqTab objektu dodam nuly:}
  for i:= 1 to G_Hd.ObjNum do
    if G_ObjConvert^[i]<>nil then with G_ObjConvert^[i]^ do
      for j:= 1 to NumSeq do
        if SeqTab^[j]>R_UnLoadSeq then SeqTab^[j]:= 0;

  ScreenDone;
  RoomObjectsDone;
  RoomMasksDone;
  RoomDone;
  RoomTitleBubbleDone;
end;


{**********************************************************************}
procedure LoadBackgroundMusic(mus: byte);
var Ext: string;
begin
  {loadneme jedine platnou hudbu, ktera v pameti zatim neni:}
  if(mus>0)and(mus<>G_ActMusic)then begin
    Str(mus, Ext);
    C_StopMusic;
    G_ActMusic:= mus;
    Debug_UpdateOpenFiles;
    LoadMidi('hudba'+Ext+'.mid');
    Debug_UpdateOpenFiles;
  end;
end;

procedure RoomInit; {Head, Title, programky, Map, Pal, Music}
begin
  G_Hd.ActRoom:= G_NewRoom;
  CReadItem(IniRoomPath, Addr(R_Hd), (G_NewRoom-1)*4+1);
    Debug_UpdateOpenFiles;
  CLoadItem(IniRoomPath, pointer(R_Hd.Title), (G_NewRoom-1)*4+2);
    Debug_UpdateOpenFiles;
  R_Hd.ProgLen:= CLoadItem(IniRoomPath, pointer(R_Hd.Prog), (G_NewRoom-1)*4+4);
    Debug_UpdateOpenFiles;
  if R_Hd.HeroOn then CLoadItem(MapPath, R_WalkMap, R_Hd.Map);
    Debug_UpdateOpenFiles;
  CReadItem(PalPath, pointer(Palette), R_Hd.Pal);
    Debug_UpdateOpenFiles;
end;

procedure RoomDone;
begin
  if R_Hd.HeroOn then DisposeMap(R_WalkMap);
  FreeMem(R_Hd.Prog, R_Hd.ProgLen);
  FreeMem(R_Hd.Title, Length(R_Hd.Title^)+1);
end;

procedure RoomMasksInit;
var PCO, i: byte;
    Aux: pointer;
begin
  R_BckgExist:= True;
  if R_Hd.NumMasks=0 then begin
    R_BckgExist:= False;
    Exit;
  end;
  CLoadItem(IniRoomPath, pointer(R_MaskIni), (G_NewRoom-1)*4
  +3);
  for i:= 1 to R_Hd.NumMasks do begin
    CloadItem(ImgMaskPath, Aux, R_MaskIni^[i].StoreNum);
    AddImageAObj(PCO);
    AddSpriteToObj(PCO, Aux);
    StartPriorityAObj(PCO, R_MaskIni^[i].Prior);
    StartDisableErasingAObj(PCO, 1);
    StartPosAObj(PCO, R_MaskIni^[i].X, R_MaskIni^[i].Y);
    NewZoomAObj(PCO, 0, 0);
    VisibleAObj(PCO);
  end;
end;

procedure RoomMasksDone;
var i: byte;
    Aux: pointer;
begin
  for i:= 1 to R_Hd.NumMasks do begin
    Aux:= ReleaseLastAObj;
    DisposeImage(Aux);
  end;
  FreeMem(R_MaskIni, R_Hd.NumMasks*SizeOf(TMaskHd));
end;

procedure ObjectInit(GameNum: integer; var ObjHd: TObjHd);
{inicializece objektu: nacte to do pripraveneho prostoru hlavicku,
 dimenzuje tabulku sekvenci, zaregistruje anim. objekt, nahraje
 Titulek a programky}
begin
  G_ObjConvert^[GameNum]:= @ObjHd;
  {nactu hlavicku:}
  CReadItem(ObjectsPath, Addr(ObjHd), (GameNum-1)*3+1);
  with ObjHd do begin
    AbsNum:= GameNum;
    {udelam tabulku pro anim. sekvence, inicializuju ji nulama:}
    GetMem(SeqTab, NumSeq*SizeOf(integer)); FillChar(SeqTab^, NumSeq*SizeOf(integer), 0);
    {zaregistruju animacni objekt:}
    AddImageAObj(AnimObj);
    StartPriorityAObj(AnimObj, Priority);
    {nahraju title}
    CLoadItem(ObjectsPath, pointer(Title), (GameNum-1)*3+2);
    {nahraju prog}
    ProgLen:= CLoadItem(ObjectsPath, pointer(Prog), (GameNum-1)*3+3);
  end;
end;

procedure ObjectDone(ObjHd: TObjHd);
begin
  with ObjHd do begin
    FreeMem(Prog, ProgLen);
    FreeMem(Title, Length(Title^)+1);
    ReleaseLastAObj;
    FreeMem(SeqTab, NumSeq*SizeOf(integer));
  end;
end;

procedure RoomObjectsInit;
var i, j: integer;
begin
  {Nejprve spocitam pocet objektu, ktere se prave ted v mistnosti budou nachazet:}
  R_ObjNum:= 0;
  {Pojedeme od 2, draka=1 ignorujeme}
  for i:= 2 to G_Hd.ObjNum do begin
    if(G_ObjStatus^[i] AND 127)=G_NewRoom then begin
      Inc(R_ObjNum);
    end;
  end;
  {Pro dany pocet vyhradim misto pro tabulku objektu dane mistnosti:}
  GetMem(R_Objects, SizeOf(TObjHd)*R_ObjNum);
  j:= 1;
  {Pojedeme od 2, draka=1 ignorujeme}
  for i:= 2 to G_Hd.ObjNum do if(G_ObjStatus^[i] AND 127)=G_NewRoom then begin
    {budto v mistonsti je, potom ho nahrajeme, vyplnime polozku v G_ObjConvert}
    ObjectInit(i, R_Objects^[j]);
    Inc(j);
  end else
    {nebo v mistnosti neni, pak do polozky v G_Objonvert uvedeme nil}
    G_ObjConvert^[i]:= nil;
end;

procedure RoomObjectsDone;
var i: byte;
begin
  for i:= 1 to R_ObjNum do ObjectDone(R_Objects^[i]);
  FreeMem(R_Objects, SizeOf(TObjHd)*R_ObjNum);
end;



{**********************************************************************}

function LoadGameStatus(var f: file; loadall: boolean): boolean;
var auxbyte: byte;
    i, j: integer;
    auxproc: TUserProc;
    auxghd: TGameHd;
    check: integer;
const mus: byte= 1;

  function HeadersAreEqual: boolean;
  begin
    with G_Hd do begin
      HeadersAreEqual:=
        (MapRoom=auxghd.MapRoom)and
        (ObjNum=auxghd.ObjNum)and
        (IcoNum=auxghd.IcoNum)and
        (VarNum=auxghd.VarNum)and
        (PerNum=auxghd.PerNum)and
        (DiaNum=auxghd.DiaNum)and
        (BlockNum=auxghd.BlockNum)and
        (crc[1]=auxghd.crc[1])and
        (crc[2]=auxghd.crc[2])and
        (crc[3]=auxghd.crc[3])and
        (crc[4]=auxghd.crc[4])
        ;
    end;
  end;

begin
(*  {$i-}*)
  {nacteme hlavicku hry, z ni se da dozvedet, v ktere mistnosti jsme:}
  BlockRead(f, auxghd, SizeOf(auxghd));
  {otestujeme, jestli se jedna o stejnou verzi hry:}
  G_Hd:= auxghd;
  if loadall then begin

    BlockRead(f, G_IcoStatus^, G_Hd.IcoNum*SizeOf(Byte));
    BlockRead(f, G_Vars^, G_Hd.VarNum*SizeOf(Integer));
    BlockRead(f, G_BlockVars^, G_Hd.BlockNum*SizeOf(Integer));
  {  BlockRead(f, D_LastBlock, SizeOf(byte));}
    BlockRead(f, G_IcoConv^, MagicInventCol*MagicInventLin);
  end;
  BlockRead(f, mus, SizeOf(mus));
  BlockRead(f, auxbyte, SizeOf(G_ActIco));
  if loadall then
    G_ActIco := auxbyte;
  {otherwise don't do anything when returning from the map (on ESCAPE).  the
  object was dropped into the backpack and the hands were cleared.  we do NOT
  load the contents of the backpack and therefore we must not load the item in
  the hands either, otherwise it will get duplicated.}

BlockRead(f, check, SizeOf(check));
if check<>-11111 then halt;

  NewIco;
  {kvuli initu objektu:}
  G_NewRoom:= G_Hd.ActRoom;
  RoomInit;
  if mus<>0 then begin
    LoadBackgroundMusic(mus);
    C_StartMusic;
  end else C_StopMusic;

  RoomMasksInit;

  {nactu status objektu:}
  if loadall then BlockRead(f, G_ObjStatus^, G_Hd.ObjNum*SizeOf(byte));

BlockRead(f, check, SizeOf(check));
if check<>-11111 then halt;

  {provedu standardni init objektu v mistnosti, ten zavola init pro kazdy
   objekt zvlast, v initu objektu se napr.: dimenzuje tabulka sekvenci,
   pridava animacni objekt...:}
  RoomObjectsInit;
  {pro kazdy objekt v mistnosti nactu jeho tabulku sekvenci:}
  for i:= 1 to R_ObjNum do
    BlockRead(f, R_Objects^[i].SeqTab^, R_Objects^[i].NumSeq*SizeOf(integer));

BlockRead(f, check, SizeOf(check));
if check<>-11111 then halt;

  {podle tabulky sekvenci kazdeho objektu nataham do pameti spravne animacni sekvence:}
  for i:= 1 to R_ObjNum do with R_Objects^[i] do begin
    for j:= 1 to NumSeq do if SeqTab^[j]<>0 then begin
      SeqTab^[j]:= LoadAnimationSeq(IdxSeq+j);
      {rovnou nactu i hlavicku kazde ze sekvenci do prave vyhrazeneho
       a inicializovaneho mista (udelala to LoadAnimationSeq):}
      BlockRead(f, A_SeqExtHead[SeqTab^[j]]^, SizeOf(TAnmExtHeader));
      A_SeqExtHead[SeqTab^[j]]^.AnimObj:= R_Objects^[i].AnimObj;
    end;
  end;

BlockRead(f, check, SizeOf(check));
if check<>-11111 then halt;

  {ke kazdemu hernimu objektu nactu info o jeho objektu animacnim:}
  for i:= 1 to R_ObjNum do with R_Objects^[i] do begin
    BlockRead(f, AObjsAddressTab[AnimObj]^, SizeOf(TAObjTab));
    {animacni prikaz muzu byt v zasade libovolny, to ovesem neni
     pro nas chodne: v pripade, ze je napr. AComRepaint, pozdejsi
     VisibleAObj (viz. par radku dolu) by nefungovalo:}
    AObjsAddressTab[AnimObj]^.AnimCommand:= AComNone;
  end;

BlockRead(f, check, SizeOf(check));
if check<>-11111 then halt;

  {zapnu animace, ktere bezely:}
  for i:= 1 to R_ObjNum do with R_Objects^[i] do begin
    for j:= 1 to NumSeq do
      if(SeqTab^[j]<>0)and(A_SeqExtHead[SeqTab^[j]]^.InProcess>0)then begin
        {pokud animace bezela, budu chtit, aby byla videt:}
        UpdatePhase(SeqTab^[j]);
        {tuto UserProc standardne nastavuju prikazem C_Start, neudelam
         skodu, pokud to taky nastavim: v pripade NEcyklicke animace
         zajisti, ze se po dojeti na konec zastavi a objekt zmizi.
         V pripade cyklicke to nebude mit zadny vliv:}
        A_SeqExtHead[SeqTab^[j]]^.UserProc:= SwitchObjectOff;
      end;
  end;

  {obdobne veci naloadujeme i drakovi:}
  with G_ObjConvert^[1]^ do begin
    {tabulku jeho sekvenci:}
    BlockRead(f, SeqTab^, NumSeq*SizeOf(integer));
    {pro kazdou sekvenci, ktera je v pameti ...}
    for j:= 1 to NumSeq do if SeqTab^[j]<>0 then begin
      {pokud je to sekvence, ktera se nahrala teprve v mistnosti,
       znovu ji nahraju, jinak predpokladam, ze v pameti uz je
       (sekvence od zacatku hry):}
      if SeqTab^[j]>R_UnLoadSeq then SeqTab^[j]:= LoadAnimationSeq(IdxSeq+j);
      {rovnou nactu i hlavicku:}
      BlockRead(f, A_SeqExtHead[SeqTab^[j]]^, SizeOf(TAnmExtHeader));
      A_SeqExtHead[SeqTab^[j]]^.AnimObj:= AnimObj;
    end;
    BlockRead(f, AObjsAddressTab[AnimObj]^, SizeOf(TAObjTab));
    AObjsAddressTab[AnimObj]^.AnimCommand:= AComNone;
    for j:= 1 to NumSeq do
      if(SeqTab^[j]<>0)and(A_SeqExtHead[SeqTab^[j]]^.InProcess>0)then begin
        UpdatePhase(SeqTab^[j]);
        A_SeqExtHead[SeqTab^[j]]^.UserProc:= SwitchObjectOff;
      end;
  end;

  {kvuli pokracovani chuze obnovim nasledujici:}
  BlockRead(f, auxbyte, SizeOf(auxbyte));
  BlockRead(f, auxproc, SizeOf(TUserProc));
  with A_SeqExtHead[G_ObjConvert^[1]^.SeqTab^[auxbyte]]^ do begin
    case auxproc of
      UP_FreeUserProc  : UserProc:= FreeUserProc;
      UP_GoAfterCurve  : UserProc:= GoAfterCurve;
      UP_GoBeforeFinal : UserProc:= GoBeforeFinal;
      UP_GoByWay       : UserProc:= GoByWay;
    end;
  end;

BlockRead(f, check, SizeOf(check));
if check<>-11111 then halt;

  {a nactu vypocitanou cestu, pocet uzlu te cesty a ruzne dulezitosti
   od draka skovane v H_ :}
  BlockRead(f, G_FoundWay^, SizeOf(G_FoundWay^));
  BlockRead(f, G_WaySteps, SizeOf(integer));
  BlockRead(f, H_, SizeOf(THeroHd));

  {uplne nakonec updatneme cas:}
  BlockRead(f, TimerDw, SizeOf(TimerDW));
  LoadGameStatus:= True;
(*  {$i+}*)
end;

function SaveGameStatus(var f: file; saveall: boolean): boolean;
const check: integer= -11111;
var auxbyte: byte;
    i, j: integer;
    auxproc: TUserProc;
begin
(*  {$i-}*)
  {ulozime hlavicku hry, z ni se da dozvedet, v ktere mistnosti jsme:}
  BlockWrite(f, G_Hd, SizeOf(G_Hd));
  if saveall then begin

    BlockWrite(f, G_IcoStatus^, G_Hd.IcoNum*SizeOf(Byte));
    BlockWrite(f, G_Vars^, G_Hd.VarNum*SizeOf(Integer));
    BlockWrite(f, G_BlockVars^, G_Hd.BlockNum*SizeOf(Integer));
    BlockWrite(f, G_IcoConv^, MagicInventCol*MagicInventLin);
  {  BlockWrite(f, D_LastBlock, SizeOf(byte));}
  end;
  BlockWrite(f, G_ActMusic, SizeOf(G_ActMusic));
  BlockWrite(f, G_ActIco, SizeOf(G_ActIco));

BlockWrite(f, check, SizeOf(check));

  {ulozim status objektu:}
  if saveall then BlockWrite(f, G_ObjStatus^, G_Hd.ObjNum*SizeOf(byte));
  {hlavicky neni nutne ukladat, ale potrebuji vedet, jake sekvence jsou
   pro dany objekt v pameti, ulozim tedy tabulku sekvenci pro kazdy objekt:}
BlockWrite(f, check, SizeOf(check));
  for i:= 1 to R_ObjNum do if(G_ObjStatus^[R_Objects^[i].AbsNum]>0) then
    BlockWrite(f, R_Objects^[i].SeqTab^, R_Objects^[i].NumSeq*SizeOf(integer));

BlockWrite(f, check, SizeOf(check));
  {ke kazde sekvenci kazdeho objektu v mistnosti ulozim jeji rozsirenou hlavicku:}
  for i:= 1 to R_ObjNum do if(G_ObjStatus^[R_Objects^[i].AbsNum]>0)then with R_Objects^[i] do begin
    for j:= 1 to NumSeq do if SeqTab^[j]<>0 then
      {kazde sekvenci v pameti ulozim onu hlavicku:}
      BlockWrite(f, A_SeqExtHead[SeqTab^[j]]^, SizeOf(TAnmExtHeader));
  end;

BlockWrite(f, check, SizeOf(check));
  {ke kazdemu hernimu objektu ulozim info o jeho objektu animacnim:}
  for i:= 1 to R_ObjNum do if(G_ObjStatus^[R_Objects^[i].AbsNum]>0)then with R_Objects^[i] do
    BlockWrite(f, AObjsAddressTab[AnimObj]^, SizeOf(TAObjTab));
BlockWrite(f, check, SizeOf(check));

  {vse, co jsem ukladal pro objekty v mistnosti, ulozim i pro draka:}
  with G_ObjConvert^[1]^ do begin
    {jeho tabulku sekvenci:}
    BlockWrite(f, SeqTab^, NumSeq*SizeOf(integer));

    {hlavicky sekvenci, co jsou v pameti:}
    for j:= 1 to NumSeq do if SeqTab^[j]<>0 then begin
      BlockWrite(f, A_SeqExtHead[SeqTab^[j]]^, SizeOf(TAnmExtHeader));
      {poznacim si sekvenci, ktera bezela. Budu celkem spravne predpokladat,
       ze je jedina...:}
      if A_SeqExtHead[SeqTab^[j]]^.InProcess=1 then auxbyte:= j;
    end;

    {info o animacnim objektu:}
    BlockWrite(f, AObjsAddressTab[AnimObj]^, SizeOf(TAObjTab));
  end;

  {ted zapisu, ktera animace draka bezela:}
  BlockWrite(f, auxbyte, SizeOf(auxbyte));
  {a kapanek neobratne take zapisu, ktera UserProc je nastavena
   v prave bezici animaci (abychom mohli spravne pokracovat v chuzi):}
  with A_SeqExtHead[G_ObjConvert^[1]^.SeqTab^[auxbyte]]^ do begin
    if @UserProc=@FreeUserProc then auxproc:= UP_FreeUserProc;
    if @UserProc=@GoAfterCurve then auxproc:= UP_GoAfterCurve;
    if @UserProc=@GoBeforeFinal then auxproc:= UP_GoBeforeFinal;
    if @UserProc=@GoByWay then auxproc:= UP_GoByWay;
  end;
  BlockWrite(f, auxproc, SizeOf(TUserProc));
BlockWrite(f, check, SizeOf(check));

  {ulozim spocitanou cestu, pocet zbyvajicich kroku cesty a souradnice
   a vsechno dulezite od hrdiny...}
  BlockWrite(f, G_FoundWay^, SizeOf(G_FoundWay^));
  BlockWrite(f, G_WaySteps, SizeOf(integer));
  BlockWrite(f, H_, SizeOf(THeroHd));

  BlockWrite(f, savetimer, SizeOf(TimerDW));
  SaveGameStatus:= True;
(*  {$i+}*)
end;

procedure MapInit;
var f: file;
begin
(*  {$i-}*)
  {hned na zacatku ulozime cas:}
  savetimer:= TimerDW;
  Assign(f, BeforeMapStatusPath);
  Rewrite(f, 1);
  if SaveGameStatus(f, False) then;
  Close(f);
(*  {$i+}*)
end;

procedure MapDone;
var f: file;
begin
(*  {$i-}*)
  Assign(f, BeforeMapStatusPath);
  Reset(f, 1);
  if LoadGameStatus(f, False) then;
  Close(f);
(*  {$i+}*)
end;

procedure LoadGame;
var IsOnMap: boolean;
    f: file;
begin
(*  {$i-}*)
  Assign(f, SaveGamePath);
  Reset(f, 1);
  Seek(f, 50*80+4+768+SizeOf(string));

  if LoadGameStatus(f, True) then begin
    BlockRead(f, IsOnMap, SizeOf(IsOnMap));
    if IsOnMap{G_Hd.HotMap }then begin
      {jsme v mape, bude to trosku specialni:}
      MapInit;
      UninstallRoom;
      G_NewRoom:= G_Hd.MapRoom;
      G_NewGate:= 1;
  {    G_QuitLoop:= True;}
      G_QuitMessage:= Msg_NextRoom;
    end else begin
      {nejsme v mape:}
    end;
  end;

  Close(f);
(*  {$i+}*)
end;

{!!!procedurky QuickSave, QuickLoad prepsat z nasledujicicich dvou,
 NIKOLIV z predchozich!!!!}
procedure SaveGame(var f : file);
var IsOnMap: boolean;
begin
(*  {$i-}*)
  {hned na zacatku ulozime cas:}
  savetimer:= TimerDW;

  IsOnMap:= G_Hd.ActRoom=G_Hd.MapRoom;
  if {G_Hd.HotMap}IsOnMap then begin
    {jsme v mape, bude to trosku specialni:}
    UninstallRoom;
    MapDone;
    {sejvneme stav bez mapy:}
    if SaveGameStatus(f, True) then;
  end else begin
    {nejsme v mape:}
    if SaveGameStatus(f, True) then;
  end;
  BlockWrite(f, IsOnMap, SizeOf(IsOnMap));
  if {G_Hd.HotMap}IsOnMap then begin
    MapInit;
    G_NewRoom:= G_Hd.MapRoom;
    G_NewGate:= 1;
    G_QuitMessage:= Msg_NextRoom;
  end;

(*  {$i+}*)
end;
(*{$I-}*)
function ChooseFile(whether_to_save : boolean; var description : string; font:pointer; title: string) : integer;
const maxs = 12;
      maxx = 184;
      xxx = 10;
      yyy = 20;
var  f : file;
     save_games : array[1..maxS] of string;
     i : byte;
     s : string;
     key : char;
     p,pal : pointer;
     act,olddd : byte;
     xx,yy,mxx,myy : word;
     mk: integer;
 function readlntext(x,y,len : word) : string;
 var i : byte;
     s : string;
     key : char;
 begin
   i:=0;
   s:='';
   bar(x,y,len,heigthoffont(font),0);
   bar(x+WidthOfText(font,s),y+heigthoffont(font)-2,5,2,MagicLMBackground);
   repeat
     repeat
       key:=readkey;
       if key=#0 then begin key:=readkey; key:=#1; end;
     until ((key>#31)and(key<#173))or(key=#8)or(key=#13)or(key=#27);
     if (key<>#8)and(key<>#13)and(key<>#27)and(len>WidthOfText(font,s+key)) then
       s:=s+key;
     if (key=#8)and(s<>'') then s[0]:=chr(byte(s[0])-1);
     bar(x,y,len,heigthoffont(font),0);
     printtext(x,y,s,font);
     bar(x+WidthOfText(font,s),y+heigthoffont(font)-2,5,2,MagicLMBackground);
   until (key=#13)or(key=#27);
   if key=#27 then s:=#27;
   readlntext:=s;
 end;
 procedure FindSaveGames;
 var i : byte;
 begin
(*  {$i-}*)
   filemode:= 2;
   for i:=1 to maxS do begin
     str(i,s);
     assign(f,'save'+s+'.sav');
     reset(f,1);
     if ioresult<>0 then save_games[i]:=#27
     else begin
       blockread(f,save_games[i],sizeof(save_games[i]));
       close(f);
     end;
   end;
   filemode:= 0;
(*  {$i+}*)
 end;
 procedure ViewAll;
 var i : byte;
 begin
   setactivepage(act);
   animmouseswitchoff;
   clearscr(0);
   bar(xxx-2,yyy,maxx+90+widthoftext(font,'88:'),maxs*(2+heigthoffont(font))+3,MagicLMBackground);
   bar(xxx+maxx+widthoftext(font,'88:'),yyy+((2+heigthoffont(font))*maxs-56) div 2,86,56,MagicLMPictureOutline);
   for i:=1 to maxs do begin
     str(i,s); s:=s+'.';
     rectangle(xxx+3+widthoftext(font,'88:'),1+(2+heigthoffont(font))*(i-1)+yyy,maxx-6,heigthoffont(font)+1,MagicLMUnactive);
     printtext(xxx+widthoftext(font,'88:')-widthoftext(font,s),2+(2+heigthoffont(font))*(i-1)+yyy,s,font);
   end;
   setactivepage(act xor 1);
   animmouseswitchon;
 end;
 procedure ReWrite(ii,old : byte; all : boolean; title: string);
 var iii : byte;
 begin
   animmouseswitchoff;
   setactivepage(act);
   if all then begin
     printtext((320-widthoftext(font,title))div 2, 0, title, font);
     for iii:=1 to maxs do begin
       if iii=ii
         then begin
            if all then
              bar(xxx+4+widthoftext(font,'88:'),2+(2+heigthoffont(font))*(iii-1)+yyy,
                maxx-8,heigthoffont(font),MagicLMBackground);
              rectangle(xxx+3+widthoftext(font,'88:'),
                1+(2+heigthoffont(font))*(iii-1)+yyy,maxx-6,heigthoffont(font)+1,MagicLMActive)
         end else begin
           rectangle(xxx+3+widthoftext(font,'88:'),
             1+(2+heigthoffont(font))*(iii-1)+yyy,maxx-6,heigthoffont(font)+1,MagicLMUnactive);
         end;
       if (save_games[iii]<>#27)and(all) then
         printtext(xxx+13+widthoftext(font,'  '),2+(2+heigthoffont(font))*(iii-1)+yyy,save_games[iii],font);
     end
  end else if ii<>olddd then begin
    bar(xxx+4+widthoftext(font,'88:'),2+(2+heigthoffont(font))*(ii-1)+yyy,maxx-8,heigthoffont(font),MagicLMBackground);
    rectangle(xxx+3+widthoftext(font,'88:'),
      1+(2+heigthoffont(font))*(ii-1)+yyy,maxx-6,heigthoffont(font)+1,MagicLMActive);
    bar(xxx+4+widthoftext(font,'88:'),2+(2+heigthoffont(font))*(old-1)+yyy,maxx-8,heigthoffont(font),MagicLMBackground);
        {ma byt jina barva}
    rectangle(xxx+3+widthoftext(font,'88:'),
      1+(2+heigthoffont(font))*(olddd-1)+yyy,maxx-6,heigthoffont(font)+1,MagicLMUnactive);
    if (save_games[ii]<>#27) then
      printtext(xxx+13+widthoftext(font,'  '),2+(2+heigthoffont(font))*(ii-1)+yyy,save_games[ii],font);
    if (save_games[old]<>#27) then
      printtext(xxx+13+widthoftext(font,'  '),2+(2+heigthoffont(font))*(old-1)+yyy,save_games[old],font);
  end;
   bar(xxx+maxx+3+widthoftext(font,'88:'),yyy+((2+heigthoffont(font))*maxs-50) div 2,80,50,0);
   str(ii,s);
   assign(f,'save'+s+'.sav');
   reset(f,1);
   if ioresult=0 then begin
     seek(f,sizeof(string));
     blockread(f,p^,80*50+4);
     blockread(f,palette^,768);
     if not all then begin
       setpalette(palette);
     end;
     putimage(xxx+maxx+3+widthoftext(font,'88:'),yyy+((2+heigthoffont(font))*maxs-50) div 2, p);
     close(f);
   end else begin
     line(xxx+maxx+3+widthoftext(font,'88:'),yyy+((2+heigthoffont(font))*maxs-50) div 2,
          xxx+maxx+3+widthoftext(font,'88:')+79,yyy+((2+heigthoffont(font))*maxs-50) div 2+49,MagicLMBackground);
     line(xxx+maxx+3+widthoftext(font,'88:')+79,yyy+((2+heigthoffont(font))*maxs-50) div 2,
          xxx+maxx+3+widthoftext(font,'88:')+1,yyy+((2+heigthoffont(font))*maxs-50) div 2+49,MagicLMBackground);
   end;
   setactivepage(act xor 1);
   animmouseswitchon;
 end;
 var ss : string;
begin
  FonColor1:= 255;
  BlackPalette(G_WorkPalette);
  SetPalette(G_WorkPalette);
  act:=activepage;
  getmem(p,80*50+4);
  getmem(pal,768);
  move(palette^,pal^,768);
  FindSaveGames;
  i:=1;
  olddd:=i;
  xx:=mousex; yy:=mousey;
  Viewall;
  rewrite(i,0,true,title);
  setvisualpage(act);
  FadeInPalette;
  repeat
    if i<>olddd then begin
      rewrite(i,olddd,false,'');
      olddd:=i;
    end;
    key:=#0;
    repeat
      mxx:=mousex; myy:=mousey;
      if ((mxx<>xx)or(myy<>yy))and
         (mxx>xxx+10+widthoftext(font,'  '))and
         (mxx<xxx+10+widthoftext(font,'  ')+maxx-8)and
         (myy>2+yyy)and
         (myy<2+(2+heigthoffont(font))*MaxS+yyy)and
         (i<>(myy-2-yyy)div(2+heigthoffont(font))+1)
      then begin
        xx:=mxx; yy:=myy;
        i:=(myy-2-yyy)div(2+heigthoffont(font))+1;
        key:=#1;
      end;
      if keypressed then key:=readkey;
      mk:= AnimMouseKey;
      if (mk<>0)and
         (mxx>xxx+10+widthoftext(font,'  '))and
         (mxx<xxx+10+widthoftext(font,'  ')+maxx-8)and
         (myy>2+yyy)and
         (myy<2+(2+heigthoffont(font))*MaxS+yyy)then
            begin
              i:=(myy-2-yyy)div(2+heigthoffont(font))+1;
              key:=#13;
            end;
      if (mk<>0)and(
       (mxx<xxx-2)or(myy<yyy)or
       (mxx>xxx-2+maxx+90+widthoftext(font,'88:'))or
       (myy>yyy+maxs*(2+heigthoffont(font))+3)) then key:=#27;
    until key<>#0;
    if (key=#80)and(i<>maxs) then inc(i);
    if (key=#72)and(i<>1) then dec(i);
    if (key=#13)and (whether_to_save) then begin
      animmouseswitchoff;
      setactivepage(act);
      ss:=save_games[i];
      save_games[i]:=readlntext(xxx+12+widthoftext(font,'  '),2+(2+heigthoffont(font))*(i-1)+yyy,maxx-8);
      if (save_games[i]=#27)or(save_games[i]='') then begin
        if i=5 then olddd:=4 else olddd:=5; {jednoduse I se nesmi rovnat Olddd}
        save_games[i]:=ss;
        key:=#0;
      end;
      setactivepage(act xor 1);
      animmouseswitchon;
    end;
  until ((key=#13)and(save_games[i]<>#27))or(key=#27);
  if key=#13
    then ChooseFile:=i
    else ChooseFile:=-1;
  if whether_to_save then description:=save_games[i];
  move(pal^,palette^,768);
  freemem(pal,768);
  freemem(p,80*50+4);
  BlackPalette(G_WorkPalette);
  SetPalette(G_WorkPalette);
  AnimMouseSwitchOff;
  setactivepage(act);
  setvisualpage(act xor 1);
  animrepaintpage:=2;
  AnimMouseSwitchOn;
end;

function SaveGameMenu: boolean;
var i : integer;
    f : file;
    s,description : string;
    img : pointer;
begin
  SaveGameMenu:= False;
  getmem(img,80*50+4);
  for i:= G_MainMenuAObj to G_MainMenuAObj+MagicMainMenuButtons-1 do UnVisibleAObj(i);

  {kuliva tomu, aby na obrazovce nezustaly takove kraviny, jako napr. dolni menu:}
  WaitDisplay;
  SmartPutAObjs;
  WaitVRetrace;
  SwapAnimPages;
  WaitDisplay;
  SmartPutAObjs;
  WaitDisplay;

  readsmallscreen(img);
  i:=ChooseFile(true,description,G_smallfont,ctrl_savegame);
  if i>0 then begin
    str(i,s);
    s:='save'+s+'.sav';
    assign(f,s);
    rewrite(f,1);
    blockwrite(f,description,sizeof(string));
    blockwrite(f,img^,80*50+4);
    blockwrite(f,palette^,768);
    SaveGame(f);
    close(f);
    SaveGameMenu:= True;
  end;
  freemem(img,80*50+4);
end;

function LoadGameMenu : boolean;
var f : file;
    i : integer;
    s, description : string;
begin
  LoadGameMenu:= False;
  i:=ChooseFile(false,description,G_smallfont, ctrl_loadgame);
  if i<1 then exit;
  str(i,s);
  s:='save'+s+'.sav';
  assign(f, s);
  reset(f, 1);
  if ioresult<>0 then exit;
  close(f);
  SaveGamePath:= s;
  LoadGameMenu:= True;
end;


(*{$I+} {chce to Pospec}*)

{**********************************************************************}

function PlaceXOnScr(X, DifX: integer): integer;
var NewX: integer;
begin
  NewX:= X-DifX;
  if (X-DifX)<0 then NewX:= 0;
  if (X+DifX)>318 then NewX:= 319-DifX*2; {zorro mstitel}
  PlaceXOnScr:= NewX;
end;

function PlaceYOnScr(Y, DifY: integer): integer;
var NewY: integer;
begin
  NewY:= Y-DifY;
  if (Y-DifY)<0 then NewY:= 0;
  if (Y+DifY)>198 then NewY:= 199-DifY*2;
  PlaceYOnScr:= NewY;
end;

procedure InventoryUpdateCursor(TitleYes: boolean);
var i: byte;
begin
  {zmenil se objekt pod mysi}
  {nekde musim prepocitavat souradnice okynek s ikonkami, podle
   toho budu menit I_IcoUnderMouse!!}
  if TitleYes then begin
    SetActivePage(ActivePage XOR 1);
    CopyPage(ActivePage XOR 1, ActivePage,
      MagicInventY+(I_OldIcoUnderMouse-1)div MagicInventCol*MagicIcoHeigth,
      MagicInventY+(I_OldIcoUnderMouse-1)div MagicInventCol*MagicIcoHeigth+MagicIcoHeigth);
  end;
  if G_ActIco=0 then AnimMouseNewImage(PWordArray(G_Cursor[1])^[0] div 2,
    PWordArray(G_Cursor[1])^[1] div 2, G_Cursor[1])
  else AnimMouseNewImage(PWordArray(G_IcoImage[1])^[0] div 2,
    PWordArray(G_IcoImage[1])^[1] div 2, G_IcoImage[1]);
  if(I_IcoUnderMouse<>0)and(G_IcoConv^[I_IcoUnderMouse]<>0)then begin
    if TitleYes then begin
      FonColor1:= 255;
      PrintText(
        PlaceXOnScr(MagicInventX+((I_IcoUnderMouse-1)mod MagicInventCol)*MagicIcoWidth+MagicIcoWidth div 2,
          RealWidthOfText(G_SmallFont, I_Icons^[ G_IcoConv^[I_IcoUnderMouse] ].Title^)div 2),
        PlaceYOnScr(MagicInventY+((I_IcoUnderMouse-1)div MagicInventCol)*MagicIcoHeigth+(MagicIcoHeigth shl 1)div 3,
          HeigthOfFont(G_SmallFont) div 2),
        I_Icons^[ G_IcoConv^[I_IcoUnderMouse] ].Title^, G_SmallFont);
    end;
    if Can(I_Icons^[ G_IcoConv^[I_IcoUnderMouse] ].Prog, I_Icons^[ G_IcoConv^[I_IcoUnderMouse] ].CanUse) then
      if G_ActIco=0 then AnimMouseNewImage(PWordArray(G_Cursor[7])^[0] div 2,
      PWordArray(G_Cursor[7])^[1] div 2, G_Cursor[7])
      else AnimMouseNewImage(PWordArray(G_IcoImage[2])^[0] div 2,
      PWordArray(G_IcoImage[2])^[1] div 2, G_IcoImage[2]);
  end;

  if TitleYes then begin
    SetActivePage(ActivePage XOR 1);
  end;
  I_OldIcoUnderMouse:= I_IcoUnderMouse;
end;

procedure OrdinaryUpdateCursor;
var i: integer;
begin
  {projedu vsechny herni objekty, zjistim, ktery se mapuje
   do toho nynejsiho animacniho:}
  NewTextAObj(G_TitleAObj, @G_FreeString);
  {bud tam dam obycejny kriz, nebo obr. ikonky:}
  if G_ActIco=0 then AnimMouseNewImage(PWordArray(G_Cursor[1])^[0] div 2,
  PWordArray(G_Cursor[1])^[1] div 2, G_Cursor[1])
  else AnimMouseNewImage(PWordArray(G_IcoImage[1])^[0] div 2,
  PWordArray(G_IcoImage[1])^[1] div 2, G_IcoImage[1]);
  G_ActCursor:= 1;
  {pokud je stav MainMenu, nejdrive otestuju MainMenu:}
  if G_MainMenu
  and(AnimObjectUnderMouse in [G_MainMenuAObj..G_MainMenuAObj+MagicMainMenuButtons-1])then begin
    {jsme na tlacitlku hlavniho menu:}
    G_ActCursor:= 8;
    AnimMouseNewImage(PWordArray(G_Cursor[8])^[0] div 2,
    PWordArray(G_Cursor[8])^[1] div 2, G_Cursor[8])
  end else begin
    {projedu vsecky objekty v mistnosti:}
    i:= 1;
    while(i<=R_ObjNum)and(R_Objects^[i].AnimObj<>AnimObjectUnderMouse)do Inc(i);
    if i>R_ObjNum then begin
      {nejsme na objektu, vyzkousime tedy CanUse mistnosti:}
      if Can(R_Hd.Prog, R_Hd.CanUse) then begin
        if G_ActIco=0 then AnimMouseNewImage(PWordArray(G_Cursor[7])^[0] div 2,
        PWordArray(G_Cursor[7])^[1] div 2, G_Cursor[7])
        else AnimMouseNewImage(PWordArray(G_IcoImage[2])^[0] div 2,
        PWordArray(G_IcoImage[2])^[1] div 2, G_IcoImage[2]);
      end;
    end else with R_Objects^[i] do begin
      {az ten herni objekt najdu, nastavim podle neho titulek:}
      NewTextAObj(G_TitleAObj, PString(Title));
      NewPosAObj(G_TitleAObj,
        PlaceXOnScr(MouseX, GetNewWidthAObj(G_TitleAObj) div 2),
        PlaceYOnScr(MouseY-HeigthOfFont(G_SmallFont)div 2, GetNewHeigthAObj(G_TitleAObj)));
      {pokud ma byt sipka, prekreslime, jinak...:}
      G_ActCursor:= WalkDir;
      if WalkDir>1 then begin
        AnimMouseNewImage(PWordArray(G_Cursor[WalkDir])^[0] div 2,
        PWordArray(G_Cursor[WalkDir])^[1] div 2, G_Cursor[WalkDir])
      end else begin
      {jinak osetrime CanUse:}
        if Can(R_Objects^[i].Prog, R_Objects^[i].CanUse) then begin
          if G_ActIco=0 then AnimMouseNewImage(PWordArray(G_Cursor[7])^[0] div 2,
          PWordArray(G_Cursor[7])^[1] div 2, G_Cursor[7])
          else AnimMouseNewImage(PWordArray(G_IcoImage[2])^[0] div 2,
          PWordArray(G_IcoImage[2])^[1] div 2, G_IcoImage[2]);
        end;
      end;
    end;{with...}
    {titulek je obj. 1:}
  end;
  {titulek jde ruku v ruce s myskou, pokud neni myska, neni potreba,
   aby byl nejaky titulek... napr. v Gate, kde neni myska...}
  if IsVisibleAObj(G_TitleAObj) then RepaintAObj(G_TitleAObj) else VisibleAObj(G_TitleAObj);
end;

procedure TakeIco(ico: byte);
var i: byte;
begin
  {na nulu da zase nulu, takze to nemusim osetrovat}
  {apdejtneme pole G_IcoConv:}
  i:= 1;
  while(i<=MagicInventLin*MagicInventCol)and(G_IcoConv^[i]<>ico)do Inc(i);
  if i<=MagicInventLin*MagicInventCol then begin
    {stara ikonka byla v batohu, smazeme ji:}
    G_IcoConv^[i]:= 0;
  end;
end;

procedure PutIco(ico, place: byte);
var i: byte;
begin
  if(place>0)and(place<=MagicInventLin*MagicInventCol)and(G_IcoConv^[place]=0)then begin
    G_IcoConv^[place]:= ico;
  end else begin
    i:= 1;
    while(i<=MagicInventLin*MagicInventCol)and(G_IcoConv^[i]<>0)do Inc(i);
    if i<=MagicInventLin*MagicInventCol then begin
      {nasli jsme volne misto:}
      G_IcoConv^[i]:= ico;
    end;
  end;
end;

procedure NewIco;
{volane predevsim pri listovani ikonkama}
var i: byte;
begin
  if G_ActIco=0 then begin
    {zapneme kriz}
    AnimMouseNewImage(PWordArray(G_Cursor[1])^[0] div 2,
    PWordArray(G_Cursor[1])^[1] div 2, G_Cursor[1]);
  end else begin
    {zapneme ikonku}
    CReadItem(ImgIconPath, G_IcoImage[1], (G_ActIco-1)*2+1);
    CReadItem(ImgIconPath, G_IcoImage[2], (G_ActIco-1)*2+2);
    AnimMouseNewImage(PWordArray(G_IcoImage[1])^[0] div 2,
    PWordArray(G_IcoImage[1])^[1] div 2,
    G_IcoImage[1]);
  end;

  if G_LoopStatus=Inventory then begin
    InventoryDraw;
    WaitVRetrace;
    SetVisualPage(ActivePage);
    SetActivePage(ActivePage XOR 1);
    CopyPage(ActivePage XOR 1, ActivePage, 0, 200);
    WaitDisplay;
    I_OldIcoUnderMouse:= 0;
  end;
end;

{**********************************************************************}

procedure IconInit(Num: byte; var IcoHd: TIcoHd);
{inicializece ikony: nacte to do pripraveneho prostoru hlavicku,
 zaregistruje anim. objekt, nahraje
 Titulek a programky}
begin
  {nactu hlavicku:}
  CReadItem(IconsPath, Addr(IcoHd), (Num-1)*3+1);
  with IcoHd do begin
    {nahraju title}
    CLoadItem(IconsPath, pointer(Title), (Num-1)*3+2);
    {odstranim rouru z konce titulku u ikonky, budu predpokladat jen
     jednoradkove titulky:}
    {!bacha pri odinstalovani!}
    byte(Title^[0]):= Length(Title^)-1;
    {nahraju prog}
    ProgLen:= CLoadItem(IconsPath, pointer(Prog), (Num-1)*3+3);
  end;
end;

procedure IconDone(IcoHd: TIcoHd);
begin
  with IcoHd do begin
    FreeMem(Prog, ProgLen);
    {bacha na to, ikonce jsem naschval nastvil delku o jedna mensi!}
    FreeMem(Title, Length(Title^)+2);
  end;
end;

procedure InventoryIconsInit;
var i: byte;
begin
  {Pro dany pocet vyhradim misto pro tabulku hlavicek ikonek:}
  GetMem(I_Icons, SizeOf(TIcoHd)*G_Hd.IcoNum);
  {Nactu programky i titulky uplne vsech ikonek}
  for i:= 1 to G_Hd.IcoNum do IconInit(i, I_Icons^[i]);
end;

procedure InventoryIconsDone;
var i: byte;
begin
  for i:= 1 to G_Hd.IcoNum do IconDone(I_Icons^[i]);
  FreeMem(I_Icons, SizeOf(TIcoHd)*G_Hd.IcoNum);
end;

procedure InventoryDraw;
var i, j: byte;
    icon: pointer;
begin
  CLoadItem(AuxGamePath, icon, 8+MagicMainMenuButtons+1);
  PutMaskImage((320-PWordArray(icon)^[0])div 2, (200-PWordArray(icon)^[1])div 2, icon);
  DisposeImage(icon);

  NewImage(G_Hd.MaxIcoWidth, G_Hd.MaxIcoHeigth, icon);
  for i:= 1 to MagicInventLin do for j:= 1 to MagicInventCol do begin
    if G_IcoConv^[(i-1)*MagicInventCol+j]<>0 then begin
    {nactu ikonku, prdnu ji na souradnice}
      CReadItem(ImgIconPath, icon, (G_IcoConv^[(i-1)*MagicInventCol+j]-1)*2+1);
      PutMaskImage(
        MagicInventX+j*MagicIcoWidth-MagicIcoWidth div 2-PWordArray(icon)^[0] div 2,
        MagicInventY+i*MagicIcoHeigth-MagicIcoHeigth div 2-PWordArray(icon)^[1] div 2,
        icon);
    end;
  end;
  FreeMem(icon, G_Hd.MaxIcoWidth*G_Hd.MaxIcoHeigth+4);
end;

procedure InventoryInit;
var i: byte;
begin
  {aby to bylo pekne, smazu titulek:}
  NewTextAObj(G_TitleAObj, @G_FreeString);
  RepaintAObj(G_TitleAObj);
  {vypnu i hlavni menu:}
  if G_MainMenu then for i:= G_MainMenuAObj to G_MainMenuAObj+MagicMainMenuButtons-1 do UnVisibleAObj(i);
  Body;

  InventoryIconsInit;
  {teprve ted staci vynout mysku:}
  AnimMouseSwitchOff;
  {pokud tam byla sipka, vypnu ji:}
  if G_ActCursor>1 then begin
    G_ActCursor:= 1;
    NewIco;
  end;
  InventoryUpdateCursor(True);
  I_OldActPage:= ActivePage;
  {podklad batohu vezmem z viditelne stranky:}
  CopyPage(ActivePage XOR 1, 2, 0, 200);
  SetActivePage(2);
  InventoryDraw;
  WaitVRetrace;
  SetVisualPage(2);
  SetActivePage(3);
  WaitDisplay;
  CopyPage(2, 3, 0, 200);
  AnimMouseSwitchOn;
  G_LoopStatus:= Inventory;
  {aby se nam hnedka spravne apdejtnul napis u ikonky:}
  I_OldIcoUnderMouse:= 0;
  I_Exit:= False; {vypadnuti na zadost programku vypneme}
  Debug_UpdateInfo;
end;

procedure InventoryDone;
var i: byte;
begin
  AnimMouseSwitchOff;
  ActivePage:= I_OldActPage;
  SetVisualPage(ActivePage XOR 1);
  SetActivePage(ActivePage);
  AnimMouseSwitchOn;
  G_LoopStatus:= Ordinary;
  InventoryIconsDone;
  {aby se nam hnedka apdejtnul kurzor i titulek:}
  AnimOldObjectUnderMouse:= 255;
  if G_MainMenu then begin
    {pred inventory jsme dali na objekty hl. menu Unvisible a to se musi dopocitat
     dvou prubehu:}
    Body;
    for i:= G_MainMenuAObj to G_MainMenuAObj+MagicMainMenuButtons-1 do VisibleAObj(i);
  end;
  AnimRepaintPage:= 2;
end;

{**********************************************************************}

procedure DialRunProg(prog: pointer; idx: integer);
{obalove volani pro spousteni programku bloku rozhovoru}
{pro komentar viz. H_.OnDeObal}
var i, j, UnLoadSeq: integer;
begin
  {zapamatuju si posledni nahranou anim. sekvenci:}
  UnLoadSeq:= A_LastAnmSeq;
  RunProg(prog, idx);
  {odinstaluju vsechny sekvence nahrane behem provadeni programu:}
  while(A_LastAnmSeq>UnLoadSeq)do ReleaseLastAnimationSeq;
  {a jeste namisto jejich cisel v SeqTab objektu dodam nuly:}
  for i:= 1 to G_Hd.ObjNum do
    if G_ObjConvert^[i]<>nil then with G_ObjConvert^[i]^ do
      for j:= 1 to NumSeq do if SeqTab^[j]>UnLoadSeq then SeqTab^[j]:= 0;
end;

procedure DialogInit(dial: integer);
var i: byte;
    Ext: string;
begin
  {je vubec nasledujici radek nutny?}
  G_ActCursor:=6;
  {zapneme dialogovy kriz:}
  AnimMouseNewImage(PWordArray(G_Cursor[6])^[0] div 2,
    PWordArray(G_Cursor[6])^[1] div 2, G_Cursor[6]);

  {zjistim pocet bloku rozhovoru, dimezuju pole bloku:}
  Str(dial, Ext);
  D_BlockNum:= GetArchiveOccupy(DialoguePath+Ext+'.dfw') div 3;
  GetMem(D, D_BlockNum*SizeOf(TDialBlock));
  {nactu polozky do pole:}
  for i:= 1 to D_BlockNum do with D^[i] do begin
    CanLen:= CLoadItem(DialoguePath+Ext+'.dfw', CanBlock, (i-1)*3+1);
    CLoadItem(DialoguePath+Ext+'.dfw', pointer(Title), (i-1)*3+2);
    ProgLen:= CLoadItem(DialoguePath+Ext+'.dfw', Prog, (i-1)*3+3);
  end;
  {zviditelnim radky rozhovoroveho menu, na konci dialogu opac. procedura...}
  for i:= G_DiagLineAObj to G_DiagLineAObj+3 do VisibleAObj(i);
  G_LoopStatus:= Dialogue;
  AnimWhatObjectsMousePoints:= Text;
  D_LastBlock:= 0;
  D_Begin:= True;
  Debug_UpdateInfo;
end;

function DialogDraw: byte;
{vrati na ktere lajne menu jsme stiskli mys}
var i: byte;
begin
  D_Lines:= 0; i:= 1;
  while(D_Lines<4)and(i<=D_BlockNum)do with D^[i] do begin
    {projedu vsechny bloky a ty, ktere muzou byt, zaregistruju-
     -nejvice vsak prvni ctyri!}
    if Can(CanBlock, 1) then begin
      NewTextAObj(G_DiagLineAObj+D_Lines, PString(Title));
      NewFonColorAObj(G_DiagLineAObj+D_Lines, D_LineUnactive);
      Inc(D_Lines);
      D_BlockConv[D_Lines]:= i;
    end;
    Inc(i);
  end;
  for i:= D_Lines to 3 do begin
    D_BlockConv[i+1]:= 0;
    NewTextAObj(G_DiagLineAObj+i, @G_FreeString);
  end;
  AnimOldObjectUnderMouse:= 255;
  CompareMouseWithObjects;
  if D_Lines>1 then begin
    {nula radku se nedeje nic,
    jedna radku: vynechame "vyber" jednineho radku a spustime rovnou
     ten programek}
    AnimMouseSwitchOn;
    G_QuitLoop:= False;
    Loop;
    AnimMouseSwitchOff;
    {opravim tady divnou logiku cislovani animacnich rutinek:
     (no povazte, ony cisluji vsecko od nuly! To jest skandalni.)}
    if AnimObjectUnderMouse=255 then DialogDraw:= 0 else DialogDraw:= AnimObjectUnderMouse-G_DiagLineAObj+1;
  end else DialogDraw:= D_Lines;
  for i:= G_DiagLineAObj to G_DiagLineAObj+3 do begin
    NewTextAObj(i, @G_FreeString);
    RepaintAObj(i);
  end;
  {projelo to aspon jednou smyckou, bude to tedy nastavene spravne:}
end;

procedure DialogDone;
var i: byte;
begin
  for i:= G_DiagLineAObj to G_DiagLineAObj+3 do UnVisibleAObj(i);
  for i:= 1 to D_BlockNum do with D^[i] do begin
    FreeMem(Prog, ProgLen);
    FreeMem(Title, Length(Title^)+1);
    FreeMem(CanBlock, CanLen);
  end;
  FreeMem(D, D_BlockNum*SizeOf(TDialBlock));
  AnimWhatObjectsMousePoints:= Image;
  G_LoopStatus:= Ordinary;
  G_ActCursor:= 1;
  {protoze z dialogu, pokud je volany pres H_OnDestination vyskocime
   do Loop po vykonani Body a G_MouseKey se nastavuje predtim, vynulujeme
   G_MouseKey, aby nam to po kliknuti mimo dialog (tim padem jeho zruseni)
   nechodilo, ale sta;lo na miste!}
{mysku nyni nulujeme primo v H_OnDeObal}
{  G_MouseKey:= 0;}
end;

procedure DialogMenu(dial: integer);
var OldLines, Hit: byte;
begin
  G_ActDia:= dial; {aby funkce vedely, s cim maji pracovat}
  {Lines odstartujeme s 255, aby je to testovalo az to minimalne 1 projede}
  OldLines:= 255;
  DialogInit(dial);
  repeat
    D_Exit:= False; {vyskoceni z dialogu na programkovou zadost vypneme}
    Hit:= DialogDraw;
    {bud pro vybranoy platnou polozku nebo pro jediny radek (pro jediny
     radek jsme vynechali vyber) spustime programek:}
    if not(D_Exit)and(Hit<>0)and(D_BlockConv[Hit]<>0)then begin
      if(OldLines=1)and(D_Lines=1)and(D_BlockConv[Hit]=D_LastBlock)then break;
      {promennou D_ActBlock pouziva jediny prikaz: ResetDialogueFrom}
      D_ActBlock:= D_BlockConv[Hit];
      DialRunProg(D^[D_BlockConv[Hit]].Prog, 1);
    end else break;
    D_LastBlock:= D_BlockConv[Hit];{prave vykonany blok dialogu}
    {zvysim pocitadlo, kolikrat byl ktery blok vyvolany:}
    Inc(G_BlockVars^[G_DialogsBlocks^[dial]+D_LastBlock]);
    D_Begin:= False; {pokud byl zacatek dialogu, tak jsme ho prave projeli}
    OldLines:= D_Lines;
  until(D_Exit);
  DialogDone;
  G_ActDia:= 0;
end;



{**********************************************************************}

{**********************************************************************}

procedure WalkOn(x, y: integer; sight: byte);
begin
  if R_Hd.HeroOn then begin
    H_.SightOnMouse:= sight;
    InitWay(H_.FeetX, H_.FeetY, x, y);
    GoByWay;
  end else H_OnDestination;
end;

{$F+}
procedure H_OnDeObal;
{obalove volani pro spousteni nejen programku zpusobenych klikem mysi}
{je to od zacatku prirazeno obecne procedure H_OnDestination,
 teprve podle hodnoty H_.OnDest vykonam akci...}
var i, j, UnLoadSeq: integer;
begin
  if H_.OnDest= Do_RunProg then begin
    {bacha na to: driv jsem nasledujici switch nastavil az pote, co programek
     dobehl. Pak tu ale bylo VELIKE nebezpeci!!!
     Mohlo se stat, ze se programek vykonal, a hrdina by teprve v jeho
     prubehu dosel na "destinaci", na ktere by se jeste jednou vykonal
     ten samy prikaz... Dost hloupa "rekurze", zvlast u rozhovoru.
     V normalni hre bych ale asi na tuto chybu vubec neprisel, nebot
     se muze projevit pouze u programku oznacenych Immediately a takovy
     programek bude mit v praxi hned na prvnim miste prikaz "WalkOnPlay"...}
    H_.OnDest:= Do_Nothing;
    AnimMouseSwitchOff;
    NewTextAObj(G_TitleAObj, @G_FreeString);
    for i:= G_MainMenuAObj to G_MainMenuAObj+MagicMainMenuButtons-1 do UnVisibleAObj(i);
    UnvisibleAObj(G_TitleAObj);

    {zapamatuju si posledni nahranou anim. sekvenci:}
    UnLoadSeq:= A_LastAnmSeq;
    if H_.OnDeProg>0 then RunProg(R_Objects^[H_.OnDeProg].Prog, H_.OnDeIdx)
    else RunProg(R_Hd.Prog, H_.OnDeIdx);
    {odinstaluju vsechny sekvence nahrane behem provadeni programu:}
    while(A_LastAnmSeq>UnLoadSeq)do ReleaseLastAnimationSeq;
    {a jeste namisto jejich cisel v SeqTab objektu dodam nuly:}
    for i:= 1 to G_Hd.ObjNum do
      if G_ObjConvert^[i]<>nil then with G_ObjConvert^[i]^ do
        for j:= 1 to NumSeq do if SeqTab^[j]>UnLoadSeq then SeqTab^[j]:= 0;
  {Jeden objekt ma jediny anim. objekt, tedy staci pouze zjistit,
   jestli jede krome te vypinane jeste nejaka jina animace. Pokud jede,
   nevypinat, pokud nejede, dat UnvisibleAObj...}
  {U vsech animaci daneho objektu zjistit, jestli jsou v pameti a pokud
   ano, zjistit, zda jsou InProcess. Spocitam InProcess a pokud je vic
   jak jednou (prakticky prichazi v uvahu jen dvakrat), nebudu vypinat}

  {Nova a srozumitelna logika: pokud nejaka animace dojede, objekt,
   kteremu nalezi, se zneviditelni. Tedy budu prozatim ignorovat to,
   co jsem dal do komentare.}

  {S jedinou pochybnosti: co kdyz se v prubehu programku spusti animace
   naloadovana take v jeho prubehu prikazem START, tedy nebudeme cekat
   na jeji konec, vyskocime ven do smycky, ktera ji ma provadet,
   POZOR! predtim ji odinstalujeme, ale co jeji animacni objekt???
  >>> Nemeli bychom dat do ReleaseLastAnimSeq, aby to vyplo prislusny
   animacni objekt????? ...zatim vyckame.... I kdyz: nic tim nemuzeme pokazit
  >>> tedy: pridano! }

  {Jeste novejsi logika: zneviditelneni objektu musi zajistit UserProc,
   a tu musim nastavit (pokud chci obj. zneviditelnit), kdyz provadim
   jeden z prikazu C_Start...}

  {Trosku prasarna: necham STARTPLAY nejake animace, pak START jine na
   temze objektu a vyskocim z programu. Animaci, ktera hrala jako prvni,
   odinstaluju a jeji objekt zneviditelnim. Da se ACom=Unvisible, teoreticky
   by tedy mel objekt zmizet, ale nezmizi, protoze animace v poradi jako
   druha zpravidla hbed prenastavi ACom=Repaint a objekt se tedy NEzneviditelni.
   ??> co kdyz ale Repaint nenastavi??? ->zdroj moznych chyb!
   nenastavi ho v pripade: pouze zmena souradnic, zoomu, zrcadleni
   nastavi ho v pripade: zmena sprajtu.
   -ale: zmena sprajtu by teoreticky mela nastat pokazde, i kdyz obrazek
         zustal trebas stejny, pokazde to hloupoucce hodi tu samou adresu
         vobrazku a da AComRepaint!!}


    if G_MainMenu then for i:= G_MainMenuAObj to G_MainMenuAObj+MagicMainMenuButtons-1 do VisibleAObj(i);
    VisibleAObj(G_TitleAObj);
    G_QuitLoop:= False;
    AnimMouseSwitchOn;
    AnimOldObjectUnderMouse:= 255;
    {musime vynulovat mysku!!!}
    G_MouseKey:= 0;
  end else if H_.OnDest= Do_QuitLoop then LoopSetQuitTrue;
end;
{$F-}

procedure IcoRunProg(prog: pointer; idx: integer);
{obalove volani pro spousteni programku ikonek uvnitr batuzku}
begin
  AnimMouseSwitchOff;
  SetActivePage(ActivePage XOR 1);
  CopyPage(ActivePage XOR 1, ActivePage,
    MagicInventY+(I_OldIcoUnderMouse-1)div MagicInventCol*MagicIcoHeigth,
    MagicInventY+(I_OldIcoUnderMouse-1)div MagicInventCol*MagicIcoHeigth+MagicIcoHeigth);
  SetActivePage(ActivePage XOR 1);
  AnimMouseSwitchOn;

  RunProg(prog, idx);

  AnimMouseSwitchOff;
  NewIco;
  InventoryUpdateCursor(True);
  AnimMouseSwitchOn;

  G_QuitLoop:= False;
  I_IcoUnderMouse:= 0;
end;

{**********************************************************************}

{**********************************************************************}

procedure Loop;
{obycejny, nejzakladnejsi Loop- chozeni, ukazovani mysi}
{Odtud se vola Body, odtud se volaji akce mysi (nejen chuze, ale
 pravdepodobne i programky)}

  procedure IcoListLeft;
  begin
    repeat
      Dec(G_ActIco);
      if G_ActIco=255 then G_ActIco:= G_Hd.IcoNum; {pretekli jsme}
    until(G_ActIco=0)or(G_IcoStatus^[G_ActIco]=1);
  end;

  procedure IcoListRight;
  begin
    repeat
      Inc(G_ActIco);
      if G_ActIco>G_Hd.IcoNum then G_ActIco:= 0; {pretekli jsme}
    until(G_ActIco=0)or(G_IcoStatus^[G_ActIco]=1);
  end;

  function IsOutFromInventory(MX, MY: integer): boolean;
  begin
    IsOutFromInventory:=(MX<=MagicInventX)or(MY<=MagicInventY)
    or(MX>=MagicInventX+MagicIcoWidth*MagicInventCol-1)
    or(MY>=MagicInventY+MagicIcoHeigth*MagicInventLin-1);
  end;

  procedure UpdateIcoUnderMouse;
  {nastavi to spravne promennou I_IcoUnderMouse}
  var MX, MY: integer;
  begin
    Mx:= MouseX; My:= MouseY;
    if IsOutFromInventory(MX, MY) then begin
      I_IcoUnderMouse:= 0;
      Exit;
    end;
    I_IcoUnderMouse:= 1+(MX-MagicInventX)div MagicIcoWidth+
      ((MY-MagicInventY) div MagicIcoHeigth)*MagicInventCol;
  end;

{najedu na neco s krizem: -nic se nedeje
                          -cervene se oramuje
                          -zmeni se v sipku
 najedu na neco ikonou:   -nic se nedeje
                          -cervene se oramuje
                          -zmeni se v sipku
 }
 {Tedy vlastne: ActCursor= typ kurzoru,
  tj: normalni, bud ikona, nebo kriz
      sipka}


var i: byte;
begin
{  SoundInitPlay;}
  repeat {---------- hlavni smycka -------------}

    G_MouseKey:= AnimMouseKey;

    if(G_FadeCounter>0)and(TimerDW-G_FadeTime>MagicFadeDelay)then begin
      G_FadeTime:= TimerDW;
      palette_change(Palette, G_FadePhases, G_PalDif, G_PalPred);
      setpalette(Palette);
      Dec(G_FadeCounter);
      G_QuitLoop:= (G_LoopSubStatus=Fade)and(G_FadeCounter=0);
    end;

    {osetrime vyber v dialogovem menu:}
    if(G_LoopStatus=Dialogue)and(G_LoopSubStatus=Ordinary) then begin
      if(AnimObjectUnderMouse<>AnimOldObjectUnderMouse)then begin
        {zmenil se text pod mysi}
        if AnimOldObjectUnderMouse<>255 then begin
          NewFonColorAObj(AnimOldObjectUnderMouse, D_LineUnactive);
          RepaintAObj(AnimOldObjectUnderMouse);
        end;
        AnimOldObjectUnderMouse:= AnimObjectUnderMouse;
        if AnimObjectUnderMouse<>255 then begin
          NewFonColorAObj(AnimObjectUnderMouse, D_LineActive);
          RepaintAObj(AnimObjectUnderMouse);
        end;
        {projedu vsechny radky menu, zjistim, ktery se mapuje
         do toho nynejsiho animacniho:}
      end;
      G_QuitLoop:= (G_MouseKey<>0);
    end;

    {zmizeni hlavniho menu:}
    if(G_MainMenu)and(G_LoopStatus=Ordinary)and(G_LoopSubStatus=Ordinary)
    and(MouseY<MagicMainMenuY-5)then begin
      for i:= G_MainMenuAObj to G_MainMenuAObj+MagicMainMenuButtons-1 do UnVisibleAObj(i);
      G_MainMenu:= False;
    end;
    {Kvuli tomu, aby tlacitka hlavniho menu byla VZDY NAD texty, musi probehnout
     nasledujici maly trik:}
    if(G_MainMenu)and(G_LoopStatus=Ordinary)and(G_LoopSubStatus=Ordinary)then
      for i:= G_MainMenuAObj to G_MainMenuAObj+MagicMainMenuButtons-1 do RepaintAObj(i);

    if G_LoopStatus=Ordinary then begin
      NewPosAObj(G_TitleAObj,
        PlaceXOnScr(MouseX, GetNewWidthAObj(G_TitleAObj) div 2),
        PlaceYOnScr(MouseY-HeigthOfFont(G_SmallFont)div 2, GetNewHeigthAObj(G_TitleAObj)));
      RepaintAObj(G_TitleAObj);
    end;
    {nechame nakreslit vsude, kde animujeme. V batohu NEanimujeme:}
    if G_LoopStatus<>Inventory then Body;

    {osetrime mluveni:}
    if G_LoopSubStatus=Talk then begin
      if G_EnableSpeedText then begin
        G_QuitLoop:= (Control_Settings.TextSpeed=255)
         or((Control_Settings.TextSpeed>0)and(SampleType=0)
          and((TimerDW- G_BubTime)>=(MagicBubConst+Length(G_Bubble^))*MagicBubMul div (Control_Settings.TextSpeed div 16+1)));
        G_QuitLoop:= (G_QuitLoop)or(G_MouseKey<>0);
      end else begin
        G_QuitLoop:= (SampleType=0)and
          ((TimerDW- G_BubTime)>=(MagicBubConst+Length(G_Bubble^))*MagicBubMul div (128 div 16+1));
      end;
    end;

    {nasledujicich milion funkci je moznych pouze v pripade, ze se v mistnosti
     nachazi mys:}
    if R_Hd.MouseOn then begin
      {osetrime nezamestnanost mysky:}
      if((TimerDW-AnimMouseUnemployed)>MagicUnemployed)and(R_Hd.EscRoom=0)then begin
        {vyvolani/vyskoceni z inventorare; nejde vyvolat (v zasade) z mistnosti intra}
        if(G_Hd.ActRoom<>G_Hd.MapRoom)then
        if(G_LoopStatus=Inventory)and(G_LoopSubStatus=Ordinary)and(MouseY<>0)
        and IsOutFromInventory(MouseX, MouseY)then begin
          {vypneme batoh}
          InventoryDone;
          AnimMouseUnemployed:= TimerDW;
        end else if(G_LoopStatus=Ordinary)and(G_LoopSubStatus=Ordinary)and(MouseY=0)then begin
          {zapneme batoh}
          InventoryInit;
          AnimMouseUnemployed:= TimerDW;
        end;
        {zapnuti hlavniho menu:}
        if (G_LoopStatus=Ordinary)and(G_LoopSubStatus=Ordinary)
        and((MouseX>50)and(MouseX<269))and(MouseY=199)and(R_Hd.EscRoom=0)then begin
          for i:= G_MainMenuAObj to G_MainMenuAObj+MagicMainMenuButtons-1 do VisibleAObj(i);
          G_MainMenu:= True;
        end;
      end;

      {V normalnim rezimu - alebo v main menu:}
      if(G_LoopStatus=Ordinary)and(G_LoopSubStatus=Ordinary)then begin
        {Meneni kurzoru mysi, titulky u objektu:}
        if AnimObjectUnderMouse<>AnimOldObjectUnderMouse then begin
          {zmenil se objekt pod mysi}
          AnimOldObjectUnderMouse:= AnimObjectUnderMouse;
          AnimMouseSwitchOff;
          OrdinaryUpdateCursor;
          AnimMouseSwitchOn;
        end;
        {Nejdriv overime, zdali jsme nestiskli v menu:}
        if(G_MouseKey<>0)and(G_MainMenu)
        and(AnimObjectUnderMouse in [G_MainMenuAObj..G_MainMenuAObj+MagicMainMenuButtons-1])then begin
          {pokud jsme stiskli v menu, obslouzime tlacitka menu:}
          case AnimObjectUnderMouse-G_MainMenuAObj of
            0: begin {mapa}
                 if(G_Hd.ActRoom<>G_Hd.MapRoom)then begin
                   G_QuitMessage:= Msg_InitMap;
                 end else begin
                   G_QuitMessage:= Msg_DoneMap;
                 end;
               end;
            1: begin {save}
                 G_QuitLoop:= True;
                 G_QuitMessage:= Msg_SaveGame;
               end;
            2: if LoadGameMenu then begin {load}
                 G_QuitLoop:= True;
                 G_QuitMessage:= Msg_LoadGame;
               end else FadeInPalette;
            3: begin {quitgame}
                 G_QuitMessage:= Msg_QuitGame;
               end;
            4: begin {about}
                 PrintInfo;
               end;
          end;
        end else begin
          {LOOK-leve:}
          if G_MouseKey=1 then if(G_ActCursor=1)and(G_ActIco>0)then begin
            {odhozeni te ikonky do batohu:}
            PutIco(G_ActIco, 1);
            G_OldActIco:= G_ActIco;
            G_ActIco:= 0;
            AnimMouseSwitchOff;
            NewIco;
            OrdinaryUpdateCursor;
            AnimMouseSwitchOn;
          end else begin
            {projedu vsecky objekty, zjistim, na kterem jsme klikli:}
            i:= 1;
            while(i<=R_ObjNum)and(R_Objects^[i].AnimObj<>AnimObjectUnderMouse)do Inc(i);
            if i>R_ObjNum then begin
              H_.OnDest:= Do_Nothing;
              {to, ze se nikam nema chodit, kdyz v mistnosti neni drak, si
               osetruje primo rutinka WalkOn!}
              WalkOn(MouseX, MouseY, 0)
            end else with R_Objects^[i] do begin
              {az ten herni objekt najdu, budu s nim pracovat:}
              H_.OnDeProg:= i;
              H_.OnDeIdx:= Look;
              H_.OnDest:= Do_RunProg;
              if ImLook then H_OnDestination else
     	 	if LookDir=0 then WalkOn(MouseX, MouseY, 0) else WalkOn(LookX, LookY, LookDir);
            end;
          end;
          {USE-prave:}
          if G_MouseKey=2 then begin
            {projedu vsecky objekty, zjistim, na kterem jsme klikli:}
            i:= 1;
            while(i<=R_ObjNum)and(R_Objects^[i].AnimObj<>AnimObjectUnderMouse)do Inc(i);
            if i>R_ObjNum then begin
              {neklikli jsme na objekt, vyzkousime tedy program mistnosti:}
              if Can(R_Hd.Prog, R_Hd.CanUse) then begin
                {NEBUDEME psat specialni obal:}
                H_.OnDeProg:= 0;
                H_.OnDeIdx:= R_Hd.Use;
                H_.OnDest:= Do_RunProg;
                H_OnDestination;
              end else begin
                {use mistnosti nebylo uspesne, jenom nekam dojdeme}
                H_.OnDest:= Do_Nothing;
                WalkOn(MouseX, MouseY, 0);
              end;
            end else with R_Objects^[i] do begin
              {az ten herni objekt najdu, budu s nim pracovat:}
              if Can(Prog, CanUse) then begin
                {pokud ho muzu pouzit, pouziju ho:}
                H_.OnDeProg:= i;
                H_.OnDeIdx:= Use;
                H_.OnDest:= Do_RunProg;
                if ImUse then H_OnDestination else
       	 	  if UseDir=0 then WalkOn(MouseX, MouseY, 0) else WalkOn(UseX, UseY, UseDir);
              end else begin
                {use obkjektu nebylo uspesne, jenom nekam dojdeme}
                H_.OnDest:= Do_Nothing;
                WalkOn(MouseX, MouseY, 0);
              end;
            end;
          end;
        end;
      end;

      {Titulky&myska v batohu:}
      if(G_LoopStatus=Inventory)and(G_LoopSubStatus=Ordinary)then begin
        if I_Exit then InventoryDone; {vypadnuti na zadost programku}
        UpdateIcoUnderMouse;
        if I_IcoUnderMouse<>I_OldIcoUnderMouse then begin
          {zmenil se objekt pod mysi}
          AnimMouseSwitchOff;
          InventoryUpdateCursor(True);
          AnimMouseSwitchOn;
        end;
        {leve:}
        if G_MouseKey=1 then begin
          {na kterem policku batohu vim diky I_IcoUnderMouse}
          if G_ActIco=0 then begin
            {LOOK te ikonky}
            if(I_IcoUnderMouse<>0)and(I_IcoUnderMouse<=MagicInventLin*MagicInventCol)and(G_IcoConv^[I_IcoUnderMouse]<>0)then
            with I_Icons^[G_IcoConv^[I_IcoUnderMouse]] do IcoRunProg(Prog, Look);
            {opravdu pod tim nejaka ikona jest, muzu ji prozkoumat}
          end else begin
            {odhozeni te ikonky do batohu}
            PutIco(G_ActIco, I_IcoUnderMouse);
            G_OldActIco:= G_ActIco;
            G_ActIco:= 0;
            AnimMouseSwitchOff;
            NewIco;
            InventoryUpdateCursor(True);
            AnimMouseSwitchOn;
          end;
        end;
        {prave:}
        if G_MouseKey=2 then begin
          {na kterem policku batohu vim diky I_IcoUnderMouse}
          if IsOutFromInventory(MouseX, MouseY) then InventoryDone
            {pokud jsem kliknul "pouzij" mimo batoh, ihned batoh zabalim}
          else if(I_IcoUnderMouse<>0)and(I_IcoUnderMouse<=MagicInventLin*MagicInventCol)
          and(G_IcoConv^[I_IcoUnderMouse]<>0)then begin
            {opravdu pod tim nejaka ikona jest, muzu ji ...}
            if G_ActIco=0 then begin
              {vzeti ikonky z batohu}
              G_ActIco:= G_IcoConv^[I_IcoUnderMouse];
              TakeIco(G_ActIco);
              {USE te ikonky}
            end else with I_Icons^[G_IcoConv^[I_IcoUnderMouse]] do begin
              {az ten herni objekt najdu, budu s nim pracovat:}
              if Can(Prog, CanUse) then IcoRunProg(Prog, Use);
                {pokud ji muzu pouzit, pouziju ji:}
            end;
            AnimMouseSwitchOff;
            NewIco;
            InventoryUpdateCursor(True);
            G_OldActIco:= G_ActIco;
            AnimMouseSwitchOn;
          end;
        end;
      end;
    end;{if R_Hd.MouseOn ...}

{    BodyWait;}

    {Nacteni klavesy:}
    if KeyPressed then begin
      G_HotKey:= UpCase(ReadKey);
      if G_HotKey=#0 then G_HotKey1:= ReadKey;
      MemW[0:$041C]:=Mem[0:$041A];        { Nulovani bufru klavesnice   }

      {rychly/pomaly hrdina:}
      if G_HotKey='Q' then G_QuickHero:= not G_QuickHero;
      {bubliny jo/ne:}
      if G_HotKey='T' then if G_LoopSubStatus<>Talk then
        G_Bubbles:= not G_Bubbles
      else begin G_ChangeBubbles:=True; G_NextBubbles:= not G_Bubbles; end;

      {vyskoceni z programu:}
      if(G_HotKey=#0)and(G_HotKey1=#68)then begin
        G_QuitMessage:= Msg_QuitGame;
      end;

      {zavolani/zruseni mapy:}
      if(R_Hd.EscRoom=0)and(G_HotKey='M')and(G_LoopStatus=Ordinary)and(G_Hd.MapRoom>0)then
        if(G_Hd.ActRoom<>G_Hd.MapRoom)then begin
          G_QuitMessage:= Msg_InitMap;
        end else begin
          G_QuitMessage:= Msg_DoneMap;
        end;

      {Odchyceni ESC, ECS muze byt vpodstate v kterekoli mistnosti,
       zejmena vsak v intru:}
      if(G_HotKey=#27)then begin
        if(R_Hd.EscRoom>0)then begin
          {pokud muzu padat na ESC, dam priznak nove mistnosti:}
          {na ESC nemuzu padat v zasade ani v batohu, ani v dialogu}
          gpl_end_program:= 1;
          G_NewRoom:= R_Hd.EscRoom;
          G_NewGate:= 1;
          G_QuitMessage:= Msg_NextRoom;
          G_QuitLoop:= true;
        end;
        {Na ESC taky vyskakuju z mapy zpet:}
        if(G_Hd.ActRoom=G_Hd.MapRoom)then begin
          G_QuitMessage:= Msg_DoneMap;
        end;
      end;

      {nadchazejicich o neco mene nez milion funkci je moznych pouze, kdyz
       je v mistnosti myska a NEjedna se o mapu:}
      if(R_Hd.MouseOn)and(G_Hd.ActRoom<>G_Hd.MapRoom)then begin
        if(R_Hd.EscRoom=0)and(G_HotKey='I')then begin
          {vyvolani inventorare; nejde vyvolat (v zasade) z mistnosti intra
           (v intru zpravidla nebude myska, jinde jo)}
          if(G_LoopStatus=Inventory)and(G_LoopSubStatus=Ordinary)then begin
            {vypneme batoh}
            InventoryDone;
          end else if(G_LoopStatus=Ordinary)and(G_LoopSubStatus=Ordinary) then begin
            {zapneme batoh}
            InventoryInit;
          end;
        end;
        {listovani ikonkama, za predpokladu ze je nastaveny normalni
         kurzor (ne sipky):}
        if((G_LoopStatus=Ordinary)or(G_LoopStatus=Inventory))
        and(G_LoopSubStatus=Ordinary)
        and(G_ActCursor=1)then begin
          if G_HotKey= HotKey_CrossIco then begin
            {prepinani kriz/posledni pouzita ikona}
            if G_ActIco=0 then begin
              G_ActIco:= G_OldActIco;  {kriz->ikona}
              TakeIco(G_ActIco);
            end else begin
              PutIco(G_ActIco, I_IcoUnderMouse);
              G_ActIco:= 0; {ikona->kriz}
            end;
{            IcoListLeft;}
            AnimMouseSwitchOff;
            NewIco;
            if G_LoopStatus=Ordinary then OrdinaryUpdateCursor
            else InventoryUpdateCursor(True);
            AnimMouseSwitchOn;
          end;
          if G_HotKey=HotKey_IcoLeft then begin
            {left}
            PutIco(G_ActIco, I_IcoUnderMouse);
            IcoListLeft;
            TakeIco(G_ActIco);
            G_OldActIco:= G_ActIco;
            AnimMouseSwitchOff;
            NewIco;
            if G_LoopStatus=Ordinary then OrdinaryUpdateCursor
            else InventoryUpdateCursor(True);
            AnimMouseSwitchOn;
          end;
          if G_HotKey=HotKey_IcoRight then begin
            {right}
            PutIco(G_ActIco, I_IcoUnderMouse);
            IcoListRight;
            TakeIco(G_ActIco);
            G_OldActIco:= G_ActIco;
            AnimMouseSwitchOff;
            NewIco;
            if G_LoopStatus=Ordinary then OrdinaryUpdateCursor
            else InventoryUpdateCursor(True);
            AnimMouseSwitchOn;
          end;
        end;{listovani ikonkama}
      end;{if R_Hd.MouseOn ...}

      {osetreni controls:}
      if G_HotKey in[HotKey_TextSlow, HotKey_TextQuick,
                     HotKey_TextSlowest, HotKey_TextQuickest,
                     HotKey_MusicLow, HotKey_MusicHigh,
                     HotKey_MusicLowest, HotKey_MusicHighest,
                     HotKey_VoiceLow, HotKey_VoiceHigh,
                     HotKey_VoiceLowest, HotKey_VoiceHighest]then begin
        with Control_Settings do begin
          {obnoveni stareho}
          case G_HotKey of
            HotKey_TextSlow, HotKey_TextQuick,
              HotKey_TextSlowest, HotKey_TextQuickest: Control_On:= Control_TextSpeed;
            HotKey_MusicLow, HotKey_MusicHigh,
              HotKey_MusicLowest, HotKey_MusicHighest: Control_On:= Control_MusicVolume;
            HotKey_VoiceLow, HotKey_VoiceHigh,
              HotKey_VoiceLowest, HotKey_VoiceHighest: Control_On:= Control_VoiceVolume;
          end;
          case G_HotKey of
            HotKey_TextSlow: begin
                   Inc(TextSpeed, MagicControlAdd);
                   if TextSpeed<MagicControlAdd then TextSpeed:= 255;
                 end;
            HotKey_TextQuick: begin
                   Dec(TextSpeed, MagicControlAdd);
                   if TextSpeed>255-MagicControlAdd then TextSpeed:= 0;
                 end;
            HotKey_MusicHigh: begin
                   Inc(MusicVolume, MagicControlAdd);
                   if MusicVolume<MagicControlAdd then MusicVolume:= 255;
                   VolumeAll:= MusicVolume/255;
                 end;
            HotKey_MusicLow: begin
                   Dec(MusicVolume, MagicControlAdd);
                   if MusicVolume>255-MagicControlAdd then MusicVolume:= 0;
                   VolumeAll:= MusicVolume/255;
                 end;
            HotKey_VoiceHigh: begin
                   Inc(VoiceVolume, MagicControlAdd);
                   if VoiceVolume<MagicControlAdd then VoiceVolume:= 255;
                   {VolumeDSP((VoiceVolume div 16)*16+(VoiceVolume div 16));}
                   VolumeDSP(VoiceVolume div 16);
                 end;
            HotKey_VoiceLow: begin
                   Dec(VoiceVolume, MagicControlAdd);
                   if VoiceVolume>255-MagicControlAdd then VoiceVolume:= 0;
                   VolumeDSP(VoiceVolume div 16);
                 end;
            HotKey_TextSlowest: begin
                   TextSpeed:= 255;
                 end;
            HotKey_TextQuickest: begin
                   TextSpeed:= 0;
                 end;
            HotKey_MusicHighest: begin
                   MusicVolume:= 255;
                   VolumeAll:= MusicVolume/255;
                 end;
            HotKey_MusicLowest: begin
                   MusicVolume:= 0;
                   VolumeAll:= MusicVolume/255;
                 end;
            HotKey_VoiceHighest: begin
                   VoiceVolume:= 255;
                   VolumeDSP(VoiceVolume div 16);
                 end;
            HotKey_VoiceLowest: begin
                   VoiceVolume:= 0;
                   VolumeDSP(VoiceVolume div 16);
                 end;
          end;
        end;
        AnimRepaintPage:= 2;
        Control_Time:= TimerDW;
      end;
      if G_HotKey in ['A'..'Z'] then begin
        {Zapamatovani si klavesy pro cheat kod:}
        for i:= 1 to 4 do G_Cheat[i]:= G_Cheat[i+1];
        G_Cheat[5]:= G_HotKey;
        if G_CheatVisible then AnimRepaintPage:= 2;
        {Spousteni a zapinani debug modu:}
        if (not G_CheatVisible)and(G_Cheat='DEBUG') then begin
          if Debug_On then AnimRepaintPage:= 2;
          Debug_On:= not(Debug_On);
        end;
      end;
      {Listovani debug modem:}
      if(Debug_On)and(G_HotKey=#0) then begin
        {sejmuti obrazovky...}
        if G_HotKey1=#63{F5}then Debug_SaveScreenShot else begin
          {nebo prepnuti kapitol:}
          Debug_Chapter:= TDebugChapter(Ord(G_HotKey1)-59);
          AnimRepaintPage:= 2;
        end;
      end;
    end {if KeyPressed ...}
    else
    {zmizeni controls:}
    if(Control_On<>Control_Nothing)and(TimerDW-Control_Time>MagicUnemployed*2)then begin
      Control_On:= Control_Nothing;
      AnimRepaintPage:= 2;
    end;

    {G_LoopStatus nabyva hodnot: Ordinary - klikame mysi
                                 Inventory - batoh
                                 Dialogue - rozhovor}
    {G_LoopSubStatus nabyva hodnot: Ordinary - nic se nedeje
                                    Strange - ceka se na skonceni nejake
                                              akce vyvolane z programku
                                    Talk - mluvime, cekame na domluveni}

    {kdybych snad nahodou inicializoval mapu trebas prikazem programkovaciho jazyka:}
    if(G_QuitMessage=Msg_InitMap)and(G_LoopStatus=Ordinary)and(G_Hd.MapRoom>0)then begin
      MapInit;
      G_NewRoom:= G_Hd.MapRoom;
      G_NewGate:= 1;
    end;
    {zeptame se: opravdu chces koncit?:}
    if(G_QuitMessage=Msg_QuitGame)then begin
      FonColor1:= 254;
      SetActivePage(ActivePage XOR 1);
      PrintText((320-WidthOfText(G_SmallFont, ctrl_askquit1))div 2,
        MagicControlY-HeigthOfFont(G_SmallFont), ctrl_askquit1, G_SmallFont);
      PrintText((320-WidthOfText(G_SmallFont, ctrl_askquit2))div 2,
        MagicControlY+HeigthOfFont(G_SmallFont), ctrl_askquit2, G_SmallFont);
      SetActivePage(ActivePage XOR 1);
      MemW[0:$041C]:=Mem[0:$041A];        { Nulovani bufru klavesnice   }
      repeat until KeyPressed;
      G_HotKey:= UpCase(ReadKey);
      if G_HotKey=#0 then G_HotKey1:= ReadKey;
      MemW[0:$041C]:=Mem[0:$041A];        { Nulovani bufru klavesnice   }
      if G_HotKey<>confirm_yes then G_QuitMessage:= Msg_None
      else begin
        G_QuitMessage:= Msg_ConfirmedQuitGame;
        gpl_end_program:= 1;
        if(G_LoopStatus=Inventory)then InventoryDone;
        {kdybych snad nahodou chtel ukoncit program uprostred rozhovoru:}
        D_Exit:= G_LoopStatus=Dialogue;
      end;
      AnimRepaintPage:= 2;
    end;
    {Odchyceni situace, ze mam jit do jine mistnosti:}
    G_QuitLoop:= (G_QuitLoop)or(G_QuitMessage=Msg_DoneMap)or(G_QuitMessage=Msg_ConfirmedQuitGame)
      or((G_NewRoom<>0)and((G_LoopStatus=Ordinary)or(G_LoopStatus=Gate)));

    {nafurt: nemuzeme vyskocit aniz bychom odinstalovali batoh, nebo dialog}

  until G_QuitLoop;
{  SoundDonePlay;}
end;

{**********************************************************************}


function F_Random(num: integer): integer;
begin
  F_Random:=random(num);
end;

function F_IsIcoOn(ico: integer): integer;
begin
  F_IsIcoOn:= integer(G_IcoStatus^[ico]=1);
end;

function F_IsIcoAct(ico: integer): integer;
begin
  F_IsIcoAct:= integer(ico=G_ActIco);
end;

function F_IcoStat(ico: integer): integer;
{dle souboru ident. : on=1, off=2}
begin
  if(G_IcoStatus^[ico]=1)then F_IcoStat:= 1 else F_IcoStat:= 2;
end;

function F_ActIco(ico: integer): integer;
begin
  F_ActIco:= G_ActIco;
end;

function F_IsObjOn(obj: integer): integer;
begin
  F_IsObjOn:= integer((G_ObjStatus^[obj] AND $80)=$80);
end;

function F_IsObjOff(obj: integer): integer;
begin
  F_IsObjOff:= integer(((G_ObjStatus^[obj] AND $80)=0)and(G_ObjStatus^[obj]<>0));
end;

function F_IsObjAway(obj: integer): integer;
begin
  F_IsObjAway:= integer(G_ObjStatus^[obj]=0);
end;

function F_ObjStat(obj: integer): integer;
{dle souboru ident. : on=1, off=2, away=3}
begin
  if((G_ObjStatus^[obj] AND $7F)=G_Hd.ActRoom)then begin
    {je to on nebo off}
    if((G_ObjStatus^[obj] AND $80)=$80)then F_ObjStat:= 1 else F_ObjStat:= 2
  end else F_ObjStat:= 3;
    {je to away}
    {pokud je to on v mistnosti 0 (nikdy nelze) trosku problemy, budeme ignorovat}
end;

function F_LastBlock(block: integer): integer;
{vraci 1, pokud se zadane cislo bloku shoduje s poslednim vykonanym
 blokem rozhovoru}
begin
  F_LastBlock:= integer(block=D_LastBlock);
end;

function F_AtBegin(yesno: integer): integer;
{jako paremetr 0, kdyz NEMA byt na zacatku , 1 kdyz MA byt}
{vraci 0-nemuze byt nyni, 1- muze byt nyni}
begin
  F_AtBegin:= integer(D_Begin=boolean(yesno));
end;

function F_BlockVar(block: integer): integer;
{vraci hodnotu interni promenne zadaneho bloku aktualniho dialogu}
begin
  F_BlockVar:= G_BlockVars^[G_DialogsBlocks^[G_ActDia]+block];
end;

function F_HasBeen(block: integer): integer;
{vraci 0, pokud zadany blok aktualniho dialogu jeste nebyl vykonan,
 1 pokud jiz vykonan byl}
begin
  {pokud je pocitadlo, kolikrat byl ktery blok vyvolany, vetsi nez...:}
  F_HasBeen:= integer(G_BlockVars^[G_DialogsBlocks^[G_ActDia]+block]>0);
end;

function F_MaxLine(lines: integer): integer;
{vraci true, pokud aktualni pocet radku dialog. menu je mensi
 nez pocet zadany}
begin
  F_MaxLine:= integer(D_Lines<lines);
end;

function F_ActPhase(obj: integer): integer;
{zjisti nam akyualni fazi probihajici animace u objektu...}
{nula= zadna animace prave ted neprobiha, tj. napr. take v jine mistnosti}
var i: integer;
begin
  F_ActPhase:= 0;
  if G_LoopStatus=Inventory then Exit;
  if(((obj=1)or((G_ObjStatus^[obj] AND $80)=$80)and((G_ObjStatus^[obj] AND $7F)=G_Hd.ActRoom)
  and(G_ObjConvert^[obj]<>nil)))then begin
    {jsme v mistnosti, ted zjistime, ktera faze nam bezi:}
    for i:= 1 to G_ObjConvert^[obj]^.NumSeq do
      if (G_ObjConvert^[obj]^.SeqTab^[i]<>0) then begin
      F_ActPhase:=PhaseSeq(G_ObjConvert^[obj]^.SeqTab^[i]);
      break;
    end;
  end;
end;

function F_Cheat(pos: integer): integer;
{vraci x-te pismeno cheatu}
begin
  F_Cheat:= integer(G_Cheat[pos]);
end;


{$f+}
function evaluate_mathematical_expression(expression:pointer;from_where:integer;variables:pointer):integer;
  external;
procedure playgpl3(kod:pointer;from_where:integer;variables:pointer);
  external;
  {$l play3.obj}
{$f-}

{**********************************************************************}


procedure C_Load(obj, anim: integer); {nema smysl, aby bezelo v batohu}
{dostanu vedet absolutni cislo objektu a absolutni cislo animace pro dany objekt}
{chci znat cislo animace u daneho objektu: anim-IdxSeq!!}
{!!pokud se jedna o obj. cislo 1=hrdina, nastavim rovnou MainHero:=1}
begin
  if G_LoopStatus=Inventory then Exit;
  G_ObjConvert^[obj]^.SeqTab^[anim-G_ObjConvert^[obj]^.IdxSeq]:= LoadAnimationSeq(anim);
  with A_SeqExtHead[A_LastAnmSeq]^ do begin
    UserProc:=FreeUserProc;
    AnimObj:= G_ObjConvert^[obj]^.AnimObj;
    InProcess:= 0;
    if obj=1 then MainHero:= 1 else MainHero:= 0;
  end;
  Debug_UpdateInfo;
end;

procedure C_Start(obj, anim: integer); {nema smysl, aby bezelo v batohu}
{dostanu vedet absolutni cislo objektu a cislo animace pro dany objekt}
{primo do tabulky SeqTab...}
{Muzu odstartovat pouze animaci na objektu, ktery:
 -je ON v aktualni mistnosti
 -ma polozku v G_ObjConvert<>nil
 -ktera je opravdu v pameti--???jak to resit???, tj. ma polozku
}
{Bacha na to: pokud startuju nejakou animaci na objektu, musim nejprve zjistit,
 jestli na tom objektu uz nejede nejaka jina animace a pokud jede, musim
 ji vypnout!!!}
var i: integer;
begin
  if G_LoopStatus=Inventory then Exit;
  if(((obj=1)or((G_ObjStatus^[obj] AND $80)=$80)and((G_ObjStatus^[obj] AND $7F)=G_Hd.ActRoom)
  and(G_ObjConvert^[obj]<>nil)))
  and(G_ObjConvert^[obj]^.SeqTab^[anim-G_ObjConvert^[obj]^.IdxSeq]<>0)then begin
    {nejdriv vypnu vsechny pripadne probuhajici animace na tomto objektu:}

    for i:= 1 to A_LastAnmSeq do
    if(A_SeqExtHead[i]^.AnimObj=G_ObjConvert^[obj]^.AnimObj)then
    A_SeqExtHead[i]^.InProcess:= 0;

    StartPhase(G_ObjConvert^[obj]^.SeqTab^[anim-G_ObjConvert^[obj]^.IdxSeq]);
    if not IsVisibleAObj(G_ObjConvert^[obj]^.AnimObj)then
    InitFirstPhase(G_ObjConvert^[obj]^.SeqTab^[anim-G_ObjConvert^[obj]^.IdxSeq]);
    with A_SeqExtHead[G_ObjConvert^[obj]^.SeqTab^[anim-G_ObjConvert^[obj]^.IdxSeq]]^ do begin
      UserProc:= SwitchObjectOff;
    end;
  end;
end;

procedure C_StartPlay(obj, anim: integer); {nema smysl, aby bezelo v batohu}
{Plati o tom to same, jako o C_Start, krome toho:}
var i: integer;
begin
  if G_LoopStatus=Inventory then Exit;
  if(((obj=1)or((G_ObjStatus^[obj] AND $80)=$80)and((G_ObjStatus^[obj] AND $7F)=G_Hd.ActRoom)
  and(G_ObjConvert^[obj]<>nil)))
  and(G_ObjConvert^[obj]^.SeqTab^[anim-G_ObjConvert^[obj]^.IdxSeq]<>0)then begin

    for i:= 1 to A_LastAnmSeq do
    if(A_SeqExtHead[i]^.AnimObj=G_ObjConvert^[obj]^.AnimObj)then
    A_SeqExtHead[i]^.InProcess:= 0;

    StartPhase(G_ObjConvert^[obj]^.SeqTab^[anim-G_ObjConvert^[obj]^.IdxSeq]);
    if not IsVisibleAObj(G_ObjConvert^[obj]^.AnimObj)then
    InitFirstPhase(G_ObjConvert^[obj]^.SeqTab^[anim-G_ObjConvert^[obj]^.IdxSeq]);
    with A_SeqExtHead[G_ObjConvert^[obj]^.SeqTab^[anim-G_ObjConvert^[obj]^.IdxSeq]]^ do begin
      UserProc:= LoopSetQuitTrue;
    end;
    G_LoopSubStatus:= Strange;
    Loop;
    G_QuitLoop:= False;
    UnvisibleAObj(G_ObjConvert^[obj]^.AnimObj);
    G_LoopSubStatus:= Ordinary;

    {???to nasledujici tady snad nemusi byt:???}
    with A_SeqExtHead[G_ObjConvert^[obj]^.SeqTab^[anim-G_ObjConvert^[obj]^.IdxSeq]]^ do begin
      UserProc:= FreeUserProc;
    end;
  end;
end;

procedure C_Play;
begin
  if G_LoopStatus=Inventory then Exit;
  G_LoopSubStatus:= Strange;
  G_QuitLoop:= True;
  Loop;
  G_QuitLoop:= False;
  G_LoopSubStatus:= Ordinary;
end;

procedure C_JustTalk;
var i: TDragonMoves;
begin
  {najdeme animaci draka, ktera probihala:}
  i:= DM_Down;
  while(i<=DM_StopLeft)and not((A_SeqExtHead[Ord(i)]^.MainHero>0)and(A_SeqExtHead[Ord(i)]^.InProcess=1))do Inc(i);
  {pokud opravdu nejaka probihala, vypnu ji:}
  if i<=DM_StopLeft then A_SeqExtHead[Ord(i)]^.InProcess:= 0;
  {nastavim spravny smer kecani:}
  if(i=DM_SpeakRight)or(i=DM_StopRight)then i:= DM_SpeakRight else i:= DM_SpeakLeft;
  {a zapnu jeho animaci:}
  StartPhase(Ord(i));
  if not IsVisibleAObj(G_ObjConvert^[1]^.AnimObj)then InitFirstPhase(Ord(i));
end;

procedure C_JustStay;
var i: TDragonMoves;
begin
  {najdeme animaci draka, ktera probihala:}
  i:= DM_Down;
  while(i<=DM_StopLeft)and not((A_SeqExtHead[Ord(i)]^.MainHero>0)and(A_SeqExtHead[Ord(i)]^.InProcess=1))do Inc(i);
  {pokud opravdu nejaka probihala, vypnu ji:}
  if i<=DM_StopLeft then A_SeqExtHead[Ord(i)]^.InProcess:= 0;
  {nastavim spravny smer flakani se:}
  if(i=DM_SpeakRight)or(i=DM_StopRight)then i:= DM_StopRight else i:= DM_StopLeft;
  {a zapnu jeho animaci:}
  StartPhase(Ord(i));
  if not IsVisibleAObj(G_ObjConvert^[1]^.AnimObj)then InitFirstPhase(Ord(i));
end;

procedure C_StayOn(x, y, sight: integer); {nema smysl, aby bezelo v batohu}
var i: TDragonMoves;
begin
  if G_LoopStatus=Inventory then Exit;
  InitHero(x, y);
  {najdeme animaci draka, ktera probihala:}
  i:= DM_Down;
  while(i<=DM_StopLeft)and not((A_SeqExtHead[Ord(i)]^.MainHero>0)and(A_SeqExtHead[Ord(i)]^.InProcess=1))do Inc(i);
  {pokud opravdu nejaka probihala, vypnu ji:}
  if i<=DM_StopLeft then A_SeqExtHead[Ord(i)]^.InProcess:= 0;
  if sight=3 then begin
    StartPhase(Ord(DM_StopRight));
    InitFirstPhase(Ord(DM_StopRight));
  end else begin
    StartPhase(Ord(DM_StopLeft));
    InitFirstPhase(Ord(DM_StopLeft));
  end;
end;

procedure C_WalkOn(x, y, sight: integer); {nema smysl, aby bezelo v batohu}
begin
  if G_LoopStatus=Inventory then Exit;
  WalkOn(x, y, sight);
end;

procedure C_WalkOnPlay(x, y, sight: integer); {nema smysl, aby bezelo v batohu}
begin
  if G_LoopStatus=Inventory then Exit;
  H_.OnDest:= Do_QuitLoop;
  WalkOn(x, y, sight);
  G_LoopSubStatus:= Strange;
  Loop;
  G_QuitLoop:= False;
  G_LoopSubStatus:= Ordinary;
end;

procedure C_ObjStat_On(obj, room: integer);
{parametrem cislo objektu a mistnost, kde se ma zjevit}
{zapise to pouze do tabulky G_ObjStatus}
{Pokud C_Start ma odstartovat nejakou animaci, koukne se,}
{jestli je objekt ON a jen v takovem pripade ji odstartuje}
{Pokud byl pred tim OFF, no problem, animace by mely byt v pameti}
{Pokud byl AWAY a necham ho zjevit v jine mistnosti, bude to OK,}
{pri nahravani te mistnosti to normalne standardne nainicializuje}
{Pokud bych ho vsak nechal zjevit v aktualni mistnosti a pak}
{odstartoval na nem nejakou animaci dojde k problemum: on totiz do}
{aktualni mistnosti nebyl nahrany!!!}
{-->>reseni: inicializovat pole G_ObjConv s hodnotami nil, ktere}
{take uvadet u vsech objektu, ktere nejsou v mistnosti=AWAY (delat}
{to v InitRoomObjects). Jakykoli odkaz na objekt pres G_ObjConv}
{nejdriv testovat na hodnotu nil a v takovem pripade nic nedelat}
begin
  G_ObjStatus^[obj]:= byte(room) OR $80;
end;

procedure C_ObjStat(stat, obj: integer);
{1=ON, 2=OFF, 3=AWAY}
{Je to pouze k vypinani objektu, cili ON budu ignorovat}
{!!Bacha na to: kdyz je AWAY a dame OFF, zustane AWAY}
var i: byte;
begin
  if stat=1 then Exit else
  if stat=2 then G_ObjStatus^[obj]:= G_ObjStatus^[obj] AND $7F else
  G_ObjStatus^[obj]:= 0;
{pokud objekt vypnem, musi zmizet. Bacha na to! Nestaci ho pouze zneviditelnit,
 musime tez zastavit na nem probihajici animace!!}
  for i:= 1 to A_LastAnmSeq do
  if(A_SeqExtHead[i]^.AnimObj=G_ObjConvert^[obj]^.AnimObj)then
  A_SeqExtHead[i]^.InProcess:= 0;
  if IsVisibleAObj(G_ObjConvert^[obj]^.AnimObj)then UnvisibleAObj(G_ObjConvert^[obj]^.AnimObj);
end;

procedure C_IcoStat(stat, ico: integer);
{1=ON, 2=OFF}
begin
  G_IcoStatus^[ico]:= byte(stat=1);
  if(G_IcoStatus^[ico]=0)then begin
    {vypnuti ikonky, pokud byla ikonka aktualni, dam tam kriz:}
    TakeIco(ico);
    if(G_ActIco=ico)then begin
      G_ActIco:= 0;
      G_OldActIco:= 0;
      if G_ActCursor=1 then begin
        if G_LoopStatus=Inventory then AnimMouseSwitchOff;
        AnimMouseNewImage(PWordArray(G_Cursor[1])^[0] div 2,
          PWordArray(G_Cursor[1])^[1] div 2, G_Cursor[1]);
        if G_LoopStatus=Inventory then AnimMouseSwitchOff;
      end;
    end;
  end;
  {zapnuti ikonky:}
  if G_IcoStatus^[ico]=1 then begin
    G_ActIco:= ico;
    G_OldActIco:= ico;
    CReadItem(ImgIconPath, G_IcoImage[1], (G_ActIco-1)*2+1);
    CReadItem(ImgIconPath, G_IcoImage[2], (G_ActIco-1)*2+2);
    if G_LoopStatus=Inventory then AnimMouseSwitchOff;
    AnimMouseNewImage(PWordArray(G_IcoImage[1])^[0] div 2,
      PWordArray(G_IcoImage[1])^[1] div 2, G_IcoImage[1]);
    if G_LoopStatus=Inventory then AnimMouseSwitchOn;
  end;
end;

procedure C_RepaintInventory;
begin
  if G_LoopStatus=Inventory then begin
    AnimMouseSwitchOff;
    NewIco;
    AnimMouseSwitchOn;
  end;
end;

procedure C_ExitInventory;
begin
  I_Exit:= True;
end;

procedure C_NewRoom(room, gate: integer); {nema smysl, aby bezelo v batohu}
{Pokud je cislo brany spravne (existuje takova brana), nastavi to}
{priznaky skoku do dalsi mistnosti}
begin
  if G_LoopStatus=Inventory then Exit;
  G_NewRoom:= room; G_NewGate:= gate;
  if G_NewRoom=G_Hd.MapRoom then G_QuitMessage:= Msg_InitMap
  else G_QuitMessage:= Msg_NextRoom;
end;

procedure C_PushNewRoom; {nema smysl, aby bezelo v batohu}
{Pokud je cislo brany spravne (existuje takova brana), nastavi to}
{priznaky skoku do dalsi mistnosti}
begin
  G_PushedNewRoom:= G_NewRoom;
  G_PushedNewGate:= G_NewGate;
end;

procedure C_PopNewRoom; {nema smysl, aby bezelo v batohu}
{Pokud je cislo brany spravne (existuje takova brana), nastavi to}
{priznaky skoku do dalsi mistnosti}
begin
  if G_LoopStatus=Inventory then Exit;
  if G_PushedNewRoom=0 then Exit;
  G_NewRoom:= G_PushedNewRoom; G_NewGate:= G_PushedNewGate;
  G_PushedNewRoom:= 0; G_PushedNewGate:= 0;
  if G_NewRoom=G_Hd.MapRoom then G_QuitMessage:= Msg_InitMap
  else G_QuitMessage:= Msg_NextRoom;
end;

procedure C_Talk(per, sentence: integer);
{nacte to vetu s cislem "sentence", zobrazi ji na souradnice prislusne}
{postavicky spravnou barvou}
{Pro kazdou bublinu souradnice upravi tak, aby byly na obrazovce}
var speech: boolean;
  procedure PlaceBubbleOnScr(X, Y: integer);
  var NewX, NewY: integer;
      DifX, DifY: integer;
  begin
    DifX:= GetNewWidthAObj(G_BubbleAObj) div 2;
    DifY:= GetNewHeigthAObj(G_BubbleAObj);
    NewX:= X-DifX;
    NewY:= Y-DifY;
    if (X-DifX)<0 then NewX:= 0;
    if (X+DifX)>318 then NewX:= 319-DifX*2; {zorro mstitel}
    if (Y-DifY)<0 then NewY:= 0;
    if (Y+DifY)>198 then NewY:= 199-DifY*2;
    NewPosAObj(G_BubbleAObj, NewX, NewY);
  end;

  procedure PrintTopMiddle;
  var TextLine, TextFrom, TextTo: byte;
      PrintedText: string;
  begin
    SetActivePage(ActivePage XOR 1);
    TextFrom:= 1; TextTo:= 0; TextLine:= 0;
    while(TextFrom<Length(G_Bubble^))do begin
      TextTo:= PosFrom(G_Bubble^, '|', TextTo+1);
      PrintedText:= Copy(G_Bubble^, TextFrom, TextTo-TextFrom);
      PrintText(160-RealWidthOfText(G_BigFont, PrintedText)div 2,
          1+TextLine*HeigthOfFont(G_BigFont) , PrintedText, G_BigFont);
      TextFrom:= TextTo+1;
      Inc(TextLine);
    end;
    I_TalkLines:= TextLine;
    SetActivePage(ActivePage XOR 1);
  end;

begin
  CReadItem(StringsPath, pointer(G_Bubble), sentence);
  speech:= PlayDMAString(sentence,22000,true);
  G_LoopSubStatus:= Talk;
  G_BubTime:= TimerDW;
  if G_LoopStatus=Inventory then begin
    FonColor1:= G_Persons^[per].FonColor;
    if G_Bubbles or not speech then begin
      AnimMouseSwitchOff;
      PrintTopMiddle;
    end;
    Loop;
    {smazeme kecnuty text}
    if G_Bubbles or not speech then begin
      CopyPage(ActivePage, ActivePage XOR 1, 1, I_TalkLines*HeigthOfFont(G_BigFont));
      AnimMouseSwitchOn;
    end;
  end else begin
    if G_Bubbles or not speech then begin
      NewTextAObj(G_BubbleAObj, PString(G_Bubble));
      PlaceBubbleOnScr(G_Persons^[per].X, G_Persons^[per].Y);
      NewFonColorAObj(G_BubbleAObj, G_Persons^[per].FonColor);
      RepaintAObj(G_BubbleAObj);
    end;
    Loop;
    if G_Bubbles or not speech then begin
      NewTextAObj(G_BubbleAObj, @G_FreeString);
      RepaintAObj(G_BubbleAObj);
    end;
  end;
  StopDMA;
  SampleType:=0;
  G_LoopSubStatus:= Ordinary;
  G_QuitLoop:= False;
  if G_ChangeBubbles then begin
    G_ChangeBubbles:= False; G_Bubbles:= G_NextBubbles;
  end;
end;

procedure C_Let(prom, hod: integer);
begin
  G_Vars^[prom]:= hod;
end;

procedure C_ExecInit(obj: integer); {nema smysl, aby bezelo v batohu}
{Muzu odstartovat pouze program objektu, ktery:
 -ma polozku v G_ObjConvert<>nil}
begin
  if G_LoopStatus=Inventory then Exit;
  if(G_ObjConvert^[obj]<>nil)then RunProg(G_ObjConvert^[obj]^.Prog, G_ObjConvert^[obj]^.Init);
end;

procedure C_ExecLook(obj: integer); {nema smysl, aby bezelo v batohu}
begin
  if G_LoopStatus=Inventory then Exit;
  if(G_ObjConvert^[obj]<>nil)then RunProg(G_ObjConvert^[obj]^.Prog, G_ObjConvert^[obj]^.Look);
end;

procedure C_ExecUse(obj: integer); {nema smysl, aby bezelo v batohu}
begin
  if G_LoopStatus=Inventory then Exit;
  if(G_ObjConvert^[obj]<>nil)then RunProg(G_ObjConvert^[obj]^.Prog, G_ObjConvert^[obj]^.Use);
end;

procedure C_goto(rel:integer);
begin
  relative_gpl_jump:=rel;
end;

procedure C_if(expression,rel:integer);
begin
  if expression<>0 then
    relative_gpl_jump:=rel;
end;

procedure C_Dialogue(dial: integer);
begin
  DialogMenu(dial);
end;

procedure C_ExitDialogue;
begin
  D_Exit:= True;
end;

procedure C_ResetDialogue;
{vraci hodnotu interni promenne zadaneho bloku aktualniho dialogu}
var i: integer;
begin
  for i:= 1 to D_BlockNum do G_BlockVars^[G_DialogsBlocks^[G_ActDia]+i]:= 0;
end;

procedure C_ResetDialogueFrom;
{vraci hodnotu interni promenne zadaneho bloku aktualniho dialogu}
var i: integer;
begin
  for i:= D_ActBlock+1 to D_BlockNum do G_BlockVars^[G_DialogsBlocks^[G_ActDia]+i]:= 0;
end;

procedure C_ResetBlock(block: integer);
begin
  G_BlockVars^[G_DialogsBlocks^[G_ActDia]+block]:= 0;
end;

procedure C_ExitMap;
begin
  if G_Hd.ActRoom=G_Hd.MapRoom then begin
    G_QuitMessage:= Msg_DoneMap;
  end;
end;

procedure C_LoadPalette(pal: integer);
begin
  CReadItem(PalPath, pointer(G_WorkPalette), pal);
end;

procedure C_SetPalette;
begin
  SetPalette(G_WorkPalette);
end;

procedure C_BlackPalette;
begin
  BlackPalette(G_WorkPalette);
end;

procedure C_FadePalettePlay(first, last, phases: integer);
begin
  init_palette_change(Palette, G_WorkPalette, G_PalDif, G_PalPred);
  G_FadePhases:= phases;
  G_FadeCounter:= phases;
  G_LoopSubStatus:= Fade;
  G_FadeTime:= TimerDW;
  Loop;
  G_QuitLoop:= False;
  G_LoopSubStatus:= Ordinary;
end;

procedure C_FadePalette(first, last, phases: integer);
begin
  init_palette_change(Palette, G_WorkPalette, G_PalDif, G_PalPred);
  G_FadePhases:= phases;
  G_FadeCounter:= phases;
  G_FadeTime:= TimerDW;
end;

procedure C_LoadMusic(mus: integer);
begin
  LoadBackgroundMusic(mus);
end;

procedure C_StartMusic;
begin
  if(G_ActMusic>0)and not G_MusicOn then begin
    G_MusicOn:= True;
    PlayMidi;
  end;
end;

procedure C_StopMusic;
begin
  G_MusicOn:= False;
  G_ActMusic:= 0;
  StopMidi;
end;

procedure C_FadeOutMusic(sec: integer);
begin
end;

procedure C_FadeInMusic(sec: integer);
begin
end;

procedure C_Mark;
begin
  G_Mark:= A_LastAnmSeq;
end;

procedure C_Release;
var i, j: integer;
begin
  {odinstaluju vsechny sekvence nahrane behem provadeni programu:}
  while(A_LastAnmSeq>G_Mark)do ReleaseLastAnimationSeq;
  {a jeste namisto jejich cisel v SeqTab objektu dodam nuly:}
  for i:= 1 to G_Hd.ObjNum do
    if G_ObjConvert^[i]<>nil then with G_ObjConvert^[i]^ do
      for j:= 1 to NumSeq do if SeqTab^[j]>G_Mark then SeqTab^[j]:= 0;
end;

procedure C_LoadMap(mapa: integer);
begin
  if R_Hd.HeroOn then CReadItem(MapPath, R_WalkMap, mapa);
end;

procedure C_RoomMap;
begin
  if R_Hd.HeroOn then CReadItem(MapPath, R_WalkMap, R_Hd.Map);
end;

procedure C_DisableQuickHero;
begin
  G_EnableQuickHero:= False;
end;

procedure C_EnableQuickHero;
begin
  G_EnableQuickHero:= True;
end;

procedure C_DisableSpeedText;
begin
  G_EnableSpeedText:= False;
end;

procedure C_EnableSpeedText;
begin
  G_EnableSpeedText:= True;
end;

procedure C_QuitGame;
begin
  G_QuitMessage:= Msg_ConfirmedQuitGame;
end;

procedure C_ShowCheat;
begin
  G_CheatVisible:= True;
  AnimRepaintPage:= 2;
end;

procedure C_HideCheat;
begin
  G_CheatVisible:= False;
  AnimRepaintPage:= 2;
end;

procedure C_ClearCheat(kolik: integer);
var i: integer;
begin
  if kolik<=5 then for i:= 1 to kolik do G_Cheat[i]:= ' ';
end;

procedure C_FeedPassword(page, line, word: integer);
begin
  G_PaswPage:= page;
  G_PaswLine:= line;
  G_PaswWord:= word;
end;

procedure RunProg(what_code:pointer; idx:integer);
var rel_jump:integer;
begin
  rel_jump:=relative_gpl_jump;
{Pro jistotu tady- protoze jinak na kolika dalsich mistech-
 to by zkratka neslo osetrit, na neco bychom urcite zapomneli...
 spravne nastavim G_Mark !!!}
{Takze pokud snad nekde uvedu C_Release, proste se odinstaluji
 nainstalovane sekvence-....a nemelo by se to zblbnout!}
  G_Mark:= A_LastAnmSeq;
  playgpl3(what_code,idx,g_vars);
{pokud jsme v programcich neco zakazali, opet to povolime:}
  G_EnableQuickHero:= True;
  G_EnableSpeedText:= True;
  relative_gpl_jump:=rel_jump;
end;

function Can(what_code:pointer; idx:integer): boolean;
begin
  Can:= evaluate_mathematical_expression(what_code,idx,g_vars)<>0;
end;

end.
