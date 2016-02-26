procedure PlayEditedAnimation;
var
  LoadedBackground: pointer;
  LoadedPalette: {PPalette}pointer;
  BckgExist: boolean;
  SpriteAddresses: array[1..255] of pointer; {pole adres sprajtu jednotlivych animacnich fazi}
  PCO: byte;
  h, g: byte;

  ActPhase: byte;
  ActualDelay: byte;

  Ph1, Ph2: longint;

  procedure NextPhase;
  var
    CompX, CompY: integer;
  begin
    Inc(ActPhase);
    {prejdu na dalsi fazi}
    if ActPhase> EdAnim^.Header.NumOfPhases then ActPhase:= 1;
    {pokud jsem na konci, zacyklim se znova od zacatku}
    with EdAnim^.Phase[ActPhase] do begin
      if Picture> 1 then begin
      {pokud je rozumne cislo obrazku, zmenim sprajt, a to nasledovne:}
        AddSpriteToObj(PCO, 0, SpriteAddresses[ActPhase]);
        RepaintAObj(PCO);
      end;
      if EdAnim^.Header.Relative= 0 then begin
        NewPosAObj(PCO, X, Y);
      end else begin
        CompX:= X+GetNewXAObj(PCO);
        CompY:= Y+GetNewYAObj(PCO);
        if CompY> 199 then CompY:= 0- ZoomY;

{??????!!!!!!!!????????? To by me zajimalo, proc to TAKHLE jde, a jinak NE}
{        if (CompY< (0) )then CompY:= 199;
        if (CompX< (0) )then CompX:= 319;
}
{???????????!!!!!!!!!!!???????????????????????}

        if CompX> 319 then CompX:= 0-ZoomX;
        NewPosAObj(PCO, CompX, CompY );
      end;
      NewZoomAObj(PCO, ZoomX, ZoomY);
      NewMirrorAObj(PCO, Mirror);
    end;
  end;

begin
{  MouseOff;}
  Ph1:= MaxAvail;

(*
  PrepareAnimation;

  if FileExist(Background_Path+ Background_Name+ '.BMP')then begin
    {zjistim, jestli je zadane pozadi}
    if LoadImage(LoadedBackground, LoadedPalette, Background_Path+ Background_Name+ '.BMP')= 0 then begin
      standardnidialog('Chyba při čtení pozadi:|'+Background_Path+ Background_Name+ '.BMP',
      DColor1, DColor2, DColor3, DColor4, DColor5, font, BeruNaVedomi);
      exit;
    end;
    {nacetl jsem do pameti pozadi}
    SetPalette(LoadedPalette);
    {nastavim paletu pozadi}
{    AddImageAObj(PCO, 1, 0, 1, 0, 0);
    AddSpriteToLastObj(0, LoadedBackground);
 }   {nainstaluju pozadi jako jeden z animacnich objektu}
    BckgExist:= True;
  end else begin
    BckgExist:= False;
    {pokud pozadi neni zadano, nebo je zadano chybne, bude podklad cerny}
  end;

  AnimBackColor:= 0;
*)

  for h:= 1 to EdAnim^.Header.NumOfPhases do with EdAnim^.Phase[h] do begin
    {projdu vsechny faze}
    if Picture>1 then begin
      {v uvahu beru jenom platne cislo obrazku, kdyz je neplatne, fazi ignoruji}

      g:= 0;
      repeat Inc(g) until Picture=EdAnim^.Phase[g].Picture;
      {cyklus jede tak dlouho, dokud nenajde nekde v predchozich fazich shodne}
      {cislo obrazku}
      if g=h then begin
      {pokud se shoduje obrazek az ve fazi, ktera je jeho (=sam se sebou),}
      {znamena to, ze se jeste nenahral, takze udelam vsechno pro to...}

        CLoadItem(ANM_Path+ANM_Name+'.AN1', SpriteAddresses[h], Picture);
        {nacetl jsem sprajt}
      end else begin
        {jinak priradim adresu jiz nahraneho sprajtu}
        SpriteAddresses[h]:=SpriteAddresses[g];
      end;
    end;
  end;

{  AddImageAObj(PCO, 2, 0, 0, 0, 0);
  AddSpriteToLastObj(0, SpriteAddresses[1]);
}
  {zaregistroval jsem i editovany animacni objekt}
(*
  PushMouse;
  SetActivePage(1);
  SetVisualPage(0);
  AnimMouseOn(0, 0, MouseImage);


  if BckgExist then VisibleAObj(0);
  {Pokud pozadi existuje, zviditelnim ho}
  if EdAnim^.Phase[1].Picture> 1 then VisibleAObj(PCO);
  {Pokud ma faze nejaky realny obrazek, zviditelnim ho}

  ActPhase:= 0;
  NewPosAObj(PCO, 100, 100);
  NextPhase;
*)

(*
  AnimBackColor:= 0;
  AnimEnableClearScreen:= 1;
  AnimMouseSwitchOff;
  SmartPutAObjs;
  AnimMouseSwitchOn;
  SwapAnimPages;
  SmartPutAObjs;
  SwapAnimPages;
  AnimEnableClearScreen:= byte(BckgExist= False);
  AnimWhatObjectsMousePoints:= {Text}Image;
  {Inicializoval jsem obe dve stranky a nastavil jsem vse potrebne}

  ActPhase:= 0;

  repeat {---------- hlavni smycka -------------}

       NextPhase;
       SmartPutAObjs;
       WaitVRetrace;
       SwapAnimPages;
       Delay(100);

  until (KeyPressed)or(MouseKey<>0);

  {----------------------------------------------}
*)

(*
  AnimMouseOff;
  SetActivePage(0);
  SetVisualPage(0);
  ClearScr(0);
  PopMouse;
*)
{  ReleaseLastAObj;
 }
  {a nyni nasleduje odinstalovani grafiky}
  for h:= 1 to EdAnim^.Header.NumOfPhases do with EdAnim^.Phase[h] do begin
    {projdu vsechny faze}
    if Picture>1 then begin
      {v uvahu beru jenom platne cislo obrazku, kdyz je neplatne, fazi ignoruji}
      g:= 0;
      repeat Inc(g) until Picture=EdAnim^.Phase[g].Picture;
      {cyklus jede tak dlouho, dokud nenajde nekde v predchozich fazich shodne}
      {cislo obrazku}
      if g=h then begin
      {pokud se shoduje obrazek az ve fazi, ktera je jeho (=sam se sebou),}
      {znamena to, ze se muze odinstalovat, protoze jsem na nej narazil teprve poprve}
    {    DisposeImage(SpriteAddresses[h]);}

        FreeMem(SpriteAddresses[h], PWordArray(SpriteAddresses[h])^[0]*PWordArray(SpriteAddresses[h])^[1]+4);
      end;
    end;
  end;

(*
  if BckgExist then begin
{    ReleaseLastAObj;}
{    DisposeImage(LoadedBackground);}
    FreeMem(LoadedBackground, PWordArray(LoadedBackground)^[0]*PWordArray(LoadedBackground)^[1]+4);
    FreeMem(LoadedPalette, 768);
    {...paletu muzu odinstalovat z pameti}
  end;
*)

{  MouseOn(0, 0, MouseImage);}
  Ph2:= MaxAvail;
  if Ph1<>Ph2 then Write(#7#7#7#7);

end;
