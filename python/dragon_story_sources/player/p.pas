{$A+,B-,D-,E+,F-,G+,I-,L-,N-,O-,P-,Q-,R-,S-,T-,V-,X+,Y-}{$i-}
{$M 16384,0,655360}

program play05;

uses crt, vars, bardfw, graph256, midi01, animace4, anmplay4, rungpl2, dma, sblaster, texts;

procedure ProvisionalInit;
var i: byte;
begin
  if RegisterFont(G_SmallFont, SmallFontPath) then begin
    WriteLn(player_missing_small);
    Halt(1);
  end;
  if RegisterFont(G_BigFont, BigFontPath) then begin
    WriteLn(player_missing_big);
    Halt(1);
  end;

  if InitMouse=0 then begin
    WriteLn(player_missing_mouse);
    Halt(1)
  end;
  MouseOff;

  for i:= 1 to 8 do CLoadItem(AuxGamePath, G_Cursor[i], i);
  for i:= 1 to MagicMainMenuButtons do CLoadItem(AuxGamePath, G_MainMenuImage[i], 8+i);

  New(Palette);
  New(G_WorkPalette);
  New(G_PalDif);
  New(G_PalPred);

  { Inicializace grafiky:}
  InitGraph;

  BlackPalette(G_WorkPalette);
  SetPalette(G_WorkPalette);
  LastLine:= 200;
  ActivePage:= 0;
  SetVisualPage(1);
  SetActivePage(0);
  OverFontColor:=255;
  FonColor2:= 0;

  New(G_FoundWay);{ze by 4000 byte?}
  {ve FoundWay je nalezena cesta, bude potreba porad, misto pro ni
   vyhradime uplne na zacatku a nechame ho naporad}

  {pripravi animaci na zaregistrovani prvniho objektu:}
  PrepareAnimation;
  {nastavi barvu podkladu na 0:}
  AnimBackColor:= 0;
end;

procedure ProvisionalDone;
var
  i: byte;
begin
  for i:= 1 to 8 do DisposeImage(G_Cursor[i]);
  for i:= 1 to MagicMainMenuButtons do DisposeImage(G_MainMenuImage[i]);
  Dispose(G_FoundWay);

  Dispose(G_PalDif);
  Dispose(G_PalPred);
  Dispose(G_WorkPalette);
  Dispose(Palette);

  DisposeFont(G_BigFont);
  DisposeFont(G_SmallFont);
end;

procedure GameTitleBubbleInit;
var i: byte;
begin
  {Toto bude titulek u objektu, ma cislo jedna:}
  AddTextAObj(G_TitleAObj, G_SmallFont);
  StartPriorityAObj(G_TitleAObj, 253);
  StartDisableErasingAObj(G_TitleAObj, 0);
  StartPosAObj(G_TitleAObj, 0, 0);
  NewFonColorAObj(G_TitleAObj, 255);

  {Toto bude bublina(jako animacni objekt) na mluveni, ma cislo dva:}
  AddTextAObj(G_BubbleAObj, G_BigFont);
  StartPriorityAObj(G_BubbleAObj, 253);
  StartDisableErasingAObj(G_BubbleAObj, 0);
  StartPosAObj(G_BubbleAObj, 0, 0);
  NewFonColorAObj(G_BubbleAObj, 255);
  {Toto je pointer na text ty bubliny, tam se bude nacitat vzdy aktualni veta}
  New(G_Bubble);

  {4 radky rozhovoroveho menu:}
  for i:= 1 to 4 do begin
    AddTextAObj(G_DiagLineAObj, G_SmallFont);
    StartPriorityAObj(G_DiagLineAObj, 254);
    StartDisableErasingAObj(G_DiagLineAObj, 0);
    StartPosAObj(G_DiagLineAObj, 1, 200-i*HeigthOfFont(G_SmallFont));
    NewFonColorAObj(G_DiagLineAObj, D_LineUnactive);
    NewTextAObj(G_DiagLineAObj, @G_FreeString);
  end;
  G_DiagLineAObj:= LastAObj-3;

  {tlacitka hlavniho menu:}
  {hlavni menu by melo byt NADE vsim, i nad texty. Je tu ovsem problem:
   pokud se text pod obrazkem prekresli, napr. vinou nejake animace pod
   nim, prekresluje se cely a muze tak preplacnout i tlacitka menu nad
   nim.
   Vyresim to takto: pokud bude loop v hlavnim menu, dam v kazdem prubehu
   smyckou povel k prekresleni tlacitek menu...}
  for i:= 1 to MagicMainMenuButtons  do begin
    AddImageAObj(G_MainMenuAObj);
    AddSpriteToObj(G_MainMenuAObj, G_MainMenuImage[i]);{G_Cursor[i]);}
    StartPriorityAObj(G_MainMenuAObj, 254);
    StartDisableErasingAObj(G_MainMenuAObj, 0);
    StartPosAObj(G_MainMenuAObj, MagicButtonWidth div 2+(i-1)*MagicButtonWidth, MagicMainMenuY);
    NewZoomAObj(G_MainMenuAObj,
      PWordArray(G_MainMenuImage[i])^[0], PWordArray(G_MainMenuImage[i])^[1]);
  end;
  G_MainMenuAObj:= LastAObj-MagicMainMenuButtons+1;

end;

procedure GameTitleBubbleDone;
var i: byte;
begin
  {bublina&titulek}
  Dispose(G_Bubble);
  ReleaseLastAObj;
  ReleaseLastAObj;

  {Ctyri radky rozhovorveho menu:}
  ReleaseLastAObj;
  ReleaseLastAObj;
  ReleaseLastAObj;
  ReleaseLastAObj;

  {hlavni menu:}
  for i:= 1 to MagicMainMenuButtons do ReleaseLastAObj;
end;

procedure GameInit;
var i, j, aux: integer;
begin
  CLoadItem(IniGamePath, pointer(G_Persons), 6);
  CLoadItem(iniGamePath, pointer(G_DialogsBlocks), 5);
  CReadItem(IniGamePath, Addr(G_Hd), 4);
  CLoadItem(IniGamePath, pointer(G_Vars), 3);
  CLoadItem(IniGamePath, pointer(G_IcoStatus), 2);
  CLoadItem(IniGamePath, pointer(G_ObjStatus), 1);
  GetMem(G_ObjConvert, G_Hd.ObjNum*SizeOf(PObjHd));
  GetMem(G_IcoConv, MagicInventLin*MagicInventCol);

  FillChar(G_IcoConv^, SizeOf(byte)*MagicInventLin*MagicInventCol, 0);
  j:= 0;
  for i:= 1 to G_Hd.IcoNum do if(G_ActIco<>i)and(G_IcoStatus^[i]=1) then begin
    {ikonka je ON, bude v batohu zobrazena:}
    Inc(j); G_IcoConv^[j]:= i;
  end;

  {Udelam si misto na ikonku a zvyraznenou ikonku:}
  NewImage(G_Hd.MaxIcoWidth, G_Hd.MaxIcoHeigth, G_IcoImage[1]);
  NewImage(G_Hd.MaxIcoWidth, G_Hd.MaxIcoHeigth, G_IcoImage[2]);
  {bacha! Mys musim inicializovat! :}
  AnimInitMouse;
  {Pozor, nasledujici rutinka alokuje v pameti dve mista o velikosti mysi,
   ktere se korektne dealokuji pouzitim AnimMouseOff}
  {Mysku zapnu pro nejvetsi velikost ikony, pak ji musim stejne vypnout}
  AnimMouseOn(0, 0, G_IcoImage[1]);
  AnimMouseSwitchOff;
  AnimMouseNewImage(PWordArray(G_Cursor[1])^[0] div 2, PWordArray(G_Cursor[1])^[1] div 2, G_Cursor[1]);

  {spocitam pocet bloku dialogu v cele hre:}
  G_Hd.BlockNum:= 0;
  for i:= 1 to G_Hd.DiaNum do begin
    aux:= G_Hd.BlockNum;
    {zvysim globalni pocet bloku:}
    Inc(G_Hd.BlockNum, G_DialogsBlocks^[i]);
    {zaroven z toho ihned vyrobim index do tabulky G_BlockVars pro i-ty dialog:}
    G_DialogsBlocks^[i]:= aux;
  end;
  {pokud ex. aspon jeden blok dialogu, vyhradim misto pro promenne dialogu:}
  if G_Hd.BlockNum>0 then begin
    GetMem(G_BlockVars, G_Hd.BlockNum*SizeOf(integer));
    {inicializuju to nulou:}
    FillChar(G_BlockVars^, G_Hd.BlockNum*SizeOf(integer), 0);
  end;
end;

procedure GameDone;
begin
  {pokud ex. aspon jeden blok dialogu, uvolnim misto pro promenne dialogu:}
  if G_Hd.BlockNum>0 then FreeMem(G_BlockVars, G_Hd.BlockNum*SizeOf(integer));
  {Nastavim nejvetsi velikost mysky:}
  AnimMouseSwitchOff;
  PWordArray(G_IcoImage[1])^[0]:= G_Hd.MaxIcoWidth;
  PWordArray(G_IcoImage[1])^[1]:= G_Hd.MaxIcoHeigth;
  PWordArray(G_IcoImage[2])^[0]:= G_Hd.MaxIcoWidth;
  PWordArray(G_IcoImage[2])^[1]:= G_Hd.MaxIcoHeigth;
  AnimMouseNewImage(0,0, G_IcoImage[1]);
  AnimMouseSwitchOn;
  {Vypnu animacni mysku, uvolnim po ni pamet}
  AnimMouseOff;

  {Uvolnim misto na ikonku a zvyraznenou ikonku}
  DisposeImage(G_IcoImage[2]);
  DisposeImage(G_IcoImage[1]);

  While A_LastAnmSeq>0 do ReleaseLastAnimationSeq;
  {odinstaluju vsecky sekvence, co byly jeste v pameti. Predevsim
   se to tyka sekvenci dracka}
  FreeMem(G_IcoConv, MagicInventLin*MagicInventCol);
  FreeMem(G_ObjConvert, G_Hd.ObjNum*SizeOf(PObjHd));
  FreeMem(G_ObjStatus, G_Hd.ObjNum);
  FreeMem(G_IcoStatus, G_Hd.IcoNum);
  FreeMem(G_Vars, G_Hd.VarNum*SizeOf(integer));
  FreeMem(G_DialogsBlocks, G_Hd.DiaNum*SizeOf(integer));
  FreeMem(G_Persons, G_Hd.PerNum*SizeOf(TPersonHd));
end;


{**********************************************************************}

procedure ScreenInit;
var i : byte;
begin
  AnimBackColor:= 0;
  {1, jestlize se ma obrazovka pokazde smazat (napr. neni pozadi), anebo nyni,
   kdy se inicializuje a musi se vykreslit komplet cela a ne jen to, co se
   zmenilo:}
  AnimEnableClearScreen:= 1;
  {nastavime normalni kriz, zadnou sipku:}
  if G_ActCursor>1 then begin
    G_ActCursor:= 1;
    if G_ActIco=0 then AnimMouseNewImage(PWordArray(G_Cursor[1])^[0] div 2,
    PWordArray(G_Cursor[1])^[1] div 2, G_Cursor[1])
    else AnimMouseNewImage(PWordArray(G_IcoImage[1])^[0] div 2,
    PWordArray(G_IcoImage[1])^[1] div 2, G_IcoImage[1]);
  end;

  if G_MainMenu then for i:= G_MainMenuAObj to G_MainMenuAObj+MagicMainMenuButtons-1 do UnvisibleAObj(i);

  SmartPutAObjs;
  SwapAnimPages;
  SmartPutAObjs;
  SwapAnimPages;
  {Inicializoval= potisknul jsem obe dve stranky}
  if R_BckgExist then AnimEnableClearScreen:= 0;
  {Pokud ma mistnost pozadi, je zbytecne, aby se screen pokazde mazal}
  AnimWhatObjectsMousePoints:= {Text}Image;
  {Myska nam ukazuje na objekty typu Image; viz. unit animace}
  {Inicializoval jsem obe dve stranky a nastavil jsem vse potrebne}
  AnimOldObjectUnderMouse:= 255;
end;

{**********************************************************************}

procedure GateRunProg(prog: pointer; idx: integer);
{obalove volani pro spousteni programku brany}
var i, j, UnLoadSeq: integer;
begin
  H_.OnDest:= Do_Nothing;
  {zapamatuju si posledni nahranou anim. sekvenci:}
  UnLoadSeq:= A_LastAnmSeq;
  RunProg(prog, idx);
  {odinstaluju vsechny sekvence nahrane behem provadeni programu:}
  while(A_LastAnmSeq>UnLoadSeq)do ReleaseLastAnimationSeq;
  {a jeste namisto jejich cisel v SeqTab objektu dodam nuly:}
  for i:= 1 to G_Hd.ObjNum do
    if G_ObjConvert^[i]<>nil then with G_ObjConvert^[i]^ do
      for j:= 1 to NumSeq do if SeqTab^[j]>UnLoadSeq then SeqTab^[j]:= 0;

  G_QuitLoop:= False;
  AnimOldObjectUnderMouse:= 255;
end;

{**********************************************************************}

label loading_game, saving_game;
var i, j: integer;
    ph: longint;
    path_to_cd_sam: string[80];

    cdfile:file;
    cdpointer1,cdpointer2,cdpointer3:pointer;

const
    RequestedMemory: longint= 410000;

begin
  FileMode:=0;
{otestujeme volnou pamet:}
  if MemAvail<RequestedMemory then begin
    writeln(player_no_memory_1, RequestedMemory-MemAvail, player_no_memory_2);
    halt(1);
  end;

{nacteme cestu k souboru cd.sam:}
  path_to_cd_sam:= ParamStr(1);
  if path_to_cd_sam='' then path_to_cd_sam:='.\cd.sam';

  Debug_UpdateOpenFiles;
  with Debug_Info do begin
    ProgMem:= MemAvail;
    GlobalMaxMem:= 0;
    GlobalMinMem:= MaxLongInt;
  end;

  ProvisionalInit;
  Debug_UpdateOpenFiles;
  MouseOff;

  GameInit;
  Debug_UpdateOpenFiles;
  G_NewRoom:= G_Hd.ActRoom;
  G_NewGate:= 1;
  {Prvni vobjekt bude titulek, druhy bublina, treti az 6 rozhovorove menu:}
  GameTitleBubbleInit;
  Debug_UpdateOpenFiles;
  {Nulty vobjekt bude drak:}
  ObjectInit(1, G_ObjHero);
  Debug_UpdateOpenFiles;
  RunProg(G_ObjHero.Prog, G_ObjHero.Init);
  Debug_UpdateOpenFiles;

  Debug_Info.InitGameMem:= MemAvail;
{  G_QuickHero:= False;}
  G_QuitMessage:= Msg_NextRoom;
  R_UnLoadSeq:= A_LastAnmSeq;
  H_OnDestination:= H_OnDeObal;

  LoadConfig('midi.cfg');
  Debug_UpdateOpenFiles;
  InitMidi;
  AutoInitDMAIRQ;

  assign(cdfile,path_to_cd_sam);
  initDMA(path_to_cd_sam, 'cd2.sam');

  with Control_Settings do begin
    TextSpeed:= 128;
    MusicVolume:= 138;
    VoiceVolume:= 180;
    VolumeAll:= MusicVolume/255;
    SetVolume(15);
    if sbno<>255 then VolumeDSP(VoiceVolume div 16);
  end;
  repeat
    TimerBody:= TimerDW;
    { 1.promenna- rezervovana pro hru !!}
    {!!! prvni promenna vzdy bude implicitne obsahovat cislo brany,
     kterou lezeme dovnitr!!!}
    G_Vars^[1]:= G_NewGate;
    G_Vars^[2]:= G_NewRoom;
    {na mape keca drak nahore:}
    if G_NewRoom=G_Hd.MapRoom then begin
      G_Persons^[1].X:= 160; G_Persons^[1].Y:= 0;
    end;

    G_LoopSubStatus:= Ordinary;
    RoomTitleBubbleInit;
    Debug_UpdateOpenFiles;
    RoomInit;
    {kdyby jsme...}
    if G_NewGate>R_Hd.NumGates then G_NewGate:= 1;

    LoadBackgroundMusic(R_Hd.Music);
    Debug_UpdateOpenFiles;
    RoomMasksInit;
    Debug_UpdateOpenFiles;
    RoomObjectsInit;
    Debug_UpdateOpenFiles;
    {programky init objektu:}
    for i:= 1 to R_ObjNum do RunProg(R_Objects^[i].Prog, R_Objects^[i].Init);
    Debug_UpdateOpenFiles;
    {programek init mistnosti:}
    RunProg(R_Hd.Prog, R_Hd.Init);
    Debug_UpdateOpenFiles;
loading_game:
    G_NewRoom:= G_Hd.ActRoom;
    Debug_Info.InitRoomMem:= MemAvail;
    Debug_Info.ActRoomMem:= MemAvail;
    if G_Hd.ActRoom=G_Hd.MapRoom then begin
      {v mape povolime pouze kriz, zapneme ho:}
      PutIco(G_ActIco, 1);
      G_ActIco:= 0; {ikona->kriz}
      NewIco;
      {nastavime rozumne souradnice draka:}
      G_Persons^[1].X:= 160;
      G_Persons^[1].Y:= 0;
    end;
    ScreenInit;
    Debug_UpdateOpenFiles;
    {nastavim newroom na nulu, protoze OrdinaryLoop to testuje, zda}
    {mame vypadnout z mistnosti}
    G_NewRoom:= 0;
    G_HotKey:= #13;
    G_QuitLoop:= False;
    FadeInPalette;
    G_FadeCounter:= 0;
    {programek gate #}
    if not(G_QuitMessage=Msg_LoadGame)and not(G_QuitMessage=Msg_DoneMap)then begin
      G_LoopStatus:= Gate;
      G_QuitMessage:= Msg_NextRoom;
      GateRunProg(R_Hd.Prog, R_Hd.Gate[G_NewGate]);
    end else G_QuitMessage:= Msg_NextRoom;
    G_QuitLoop:= false;
    {mysku zapneme teprve po provedeni gejtu:}
    if R_Hd.MouseOn then begin
      AnimMouseSwitchOn;
    end;
    G_LoopStatus:= Ordinary;
saving_game:
    if G_MainMenu then for i:= G_MainMenuAObj to G_MainMenuAObj+MagicMainMenuButtons-1 do VisibleAObj(i);
    Loop;

    if G_QuitMessage=Msg_NextRoom then RunProg(G_ObjHero.Prog, G_ObjHero.Look);

    if G_QuitMessage=Msg_SaveGame then begin
      SaveGameMenu;
      G_QuitLoop:= False;
      {pokud jsme sejvovali z mapy, je priznak NewRoom...}
      if G_QuitMessage=Msg_SaveGame then begin
        FadeInPalette;
 	goto saving_game;
      end;
    end else FadeOutPalette;

    AnimMouseSwitchOff;
    UninstallRoom;

    if G_QuitMessage=Msg_LoadGame then begin
      RoomTitleBubbleInit;
      LoadGame;
      if G_QuitMessage=Msg_LoadGame then goto loading_game;
    end;

    {overime, jestli nahodou neskaceme z mapy:}
    if G_QuitMessage=Msg_DoneMap then begin
      RoomTitleBubbleInit;
      MapDone;
      goto loading_game;
    end;

  until G_QuitMessage=Msg_ConfirmedQuitGame;
  StopMidi;
  DoneDMA;
  DoneDMAIRQ;
  DoneMidi;


  ObjectDone(G_ObjHero);
  GameTitleBubbleDone;
  GameDone;

  ProvisionalDone;
  CloseGraph;
  if(Debug_Info.ProgMem<>MemAvail)and(Debug_On) then begin
    Writeln(Debug_Info.ProgMem); Writeln(MemAvail); WriteLn(#7);
  end;
end.
