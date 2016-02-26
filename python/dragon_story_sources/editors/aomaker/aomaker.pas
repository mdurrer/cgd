{$A+,B-,D-,E+,F-,G+,I-,L-,N-,O-,P-,Q-,R-,S-,T-,V-,X+}
{$M 16384,300000,655360}

program aomaker;

uses
  crt, dialog, editor, files, gmu, dfw,
  graform, graph256, animace3, anmplay, soundpas, comfreq2;

const
  _MaxPhases= 254;
  _msDelayUnit= 1;
  {Kolik setin sekundy je jedna jednotka Delay}
  ProgName= 'aomaker';
  FontName= 'stand2.fon';
  ProgVersion= 'v1.3 beta';
var
  ProgPath: string;

  EdAnim: PAnimation;
  Ptr_Name: PString;
  ActualSequenceNumber: word;
  Seq_Name: string[12];

  Path: string;         {pracovni cesta pro ruzne vybery souboru...}
  ReportANM_Name: string[8];

  AN0_ImageName,
  AN1_Image,
  AN2_SampleName,
  AN3_Sample,
  AN4_SequenceName,
  AN5_Sequence,
  AN6_Misc: file;

const
  TooLate: word= 0;
  AO_SoundDevice: TOutDevice= None;
  AO_Freq08: integer= 5000;
  Background_Name:string [8]= '';
  Music_Name:string [8]='';
  ANM_Name: string [8]='';

  Picture_Path   : string= '';
  Sample_Path    : string= '';
  Background_Path: string= '';
  Music_Path     : string= '';
  ANM_Path       : string= '';

  ImageNameHead   :string[32]= '<sklad jmen obrazku_-_-_-_-_-_->';
  ImageHead       :string[32]= '<obrazky-_-_-_-_-_-_-_-_-_-_-_->';
  SampleNameHead  :string[32]= '<sklad jmen samplu-_-_-_-_-_-_->';
  SampleHead      :string[32]= '<samply_-_-_-_-_-_-_-_-_-_-_-_->';
  SequenceNameHead:string[32]= '<sklad jmen animacnich sekvenci>';
  SequenceHead    :string[32]= '<animacni sekvence-_-_-_-_-_-_->';
  MiscHead        :string[32]= '<ruzne-nazvy pozadi a hudby_-_->';


procedure SestavDatovyFajlProgramu;
begin
  SetArchiveCapacity(2);

  CAddFromFile(ProgPath+ProgName+'.DAT', 'e:\paint\picture\sipka.gcf');
  CAddFromFile(ProgPath+ProgName+'.DAT', 'e:\paint\picture\mesto.pal');
end;

function ReadRealInDialog(x, y: integer; vstup: real): real;
var ed: peditor;
    cislo: real;
    chyba: integer;
begin
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
  NastavEdProstredi(ed, {posuvniky}false, zadnerolovani, musibyttext,
    {EscN:=}[#27],{EscR:=}[], {EntbN:=}[#13],{EntR:=}[]);
  NastavEdParametry(ed, {pocinv}true,{urmez}true,{prubor}false,
    {muzpres}false,{vracchyb}false,{format}false,{delka}5,
    StandardniPovZn,StandardniOddelovace);
  NastavEdObsah(ed, {edtext - viz. dale}'', {sour}1,{zacina}1);
  Str(Vstup:5:2,ed^.edtext);

  EditaceTextu(ed);
  if ed^.ukakce in [1,3] then begin     {enter znak}
    val(ed^.edtext,cislo,chyba);
    {chybu vystupniho cisla nemusime kontrolovat, to editor udela za nas}
    ReadRealInDialog:=cislo
  end else                              {escape znak}
    ReadRealInDialog:=vstup;
    {pri zmacknuti escape se vrati standardni predvolene cislo}
  DeAlokujEditor(ed)
end;

function ReadIntegerInDialog(x, y, min, max, vstup: integer): integer;
var ed: peditor;
    cislo:integer;
    chyba:integer;
begin
{  x:= x+ InfMenu[60].X;}

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

function ReadIntegerInDialog2(x, y, min, max, vstup: integer): integer;
var ed: peditor;
    cislo:integer;
    chyba:integer;
begin
{  x:= x+ InfMenu[60].X;}

  AlokujEditor(ed);
  NastavEdOkno(ed, {X,Y,Del}x,y, 12, {Vyzva}'',
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
    {muzpres}false,{vracchyb}false,{format}false,{delka}2,
    StandardniPovZn,StandardniOddelovace);
  NastavEdObsah(ed, {edtext - viz. dale}'', {sour}1,{zacina}1);
  Str(Vstup,ed^.edtext);

  EditaceTextu(ed);
  if ed^.ukakce in [1,3] then begin     {enter znak}
    val(ed^.edtext,cislo,chyba);
    {chybu vystupniho cisla nemusime kontrolovat, to editor udela za nas}
    ReadIntegerInDialog2:=cislo
  end else                              {escape znak}
    ReadIntegerInDialog2:=vstup;
    {pri zmacknuti escape se vrati standardni predvolene cislo}
  DeAlokujEditor(ed)
end;

function ReadLnInDialog(x, y: integer; vstup: string): string;
var ed:peditor;
begin
{  x:= x+ InfMenu[60].X;}

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
  DealokujEditor(ed)
end;

procedure ConfigSoundDialog;
var
  dial:pdialog;
  vysl:pstav;
  ExitCode, Button: byte;
  s_Freq08: string[5];
begin
  Button:= 1;
repeat
  mouseswitchoff;                       {uklid mys pro vypis}
  Str(AO_Freq08:5, s_Freq08);

  alokujdialog(dial,InfMenu[64].X, InfMenu[64].Y, 112, 88,
                 DColor2, DColor4, DColor5, {pozadi, ramecek, okraj}
                 true,                  {escvenku}
                 true,                  {ramtlac}
                 true,                  {presouvatelny}
                 false, false);         {NEkreslit/NEmazat}


  nastavpocty(dial,1,2,0,1,0);
{            _nap,_tlac,_check,_radio,_input }
  {pouze nastavi pocty do alokovaneho dialogu}
  nastavpocetradio(dial,1,4);

  alokujnapis(dial, 1, 78, 2, DColor4, font, s_Freq08);

  alokujtlac(dial, 1,  8,2,   DColor1, DColor3,  font,'~Frekvence:');
  alokujtlac(dial, 2,  50,74,   DColor1, DColor3,  font,'O~K');

  alokujradio(dial, 1,1,  20,14,  DColor1, DColor3, font, '~0   žádný zvuk');
  alokujradio(dial, 1,2,  20,26,  DColor1, DColor3, font, '~1   PC speaker');
  alokujradio(dial, 1,3,  20,38,  DColor1, DColor3, font, '~2 DA převodník');
  alokujradio(dial, 1,4,  20,50,  DColor1, DColor3, font, '~3 SoundBlaster');

  with dial^ do begin
    {tady, pokud to chci lepe, musim rucne nastavit sirky ramecku, aby to,
     co je pod sebou, melo i shodny ramecek}
    radio[1].text[1]^.dx:=radio[1].text[3]^.dx;
    radio[1].text[2]^.dx:=radio[1].text[3]^.dx;
{    tlac[1]^.dx:= tlac[1]^.dx-6;}
  end;

  alokujpredvoleny(vysl,1,Button,1);

  with EdAnim^.Header do begin
    pocatecniradio(vysl, 1, Ord(AO_SoundDevice)+1);
  end;

  nakreslidialog(dial,vysl);

  vyberdialog(dial,vysl);               {on po sobe mys taky uklidi}

  with EdAnim^.Header do begin
    AO_SoundDevice:= TOutDevice(vysl^.radio[1]-1);
  end;

  ExitCode:=Vysl^.UkAkce;
  Button:= Vysl^.PredvObj;

  if ExitCode in [1,3,4] then begin
    ExitCode:= 0;
    Button:= 2;
  end;
  {kdyz je Escape, jako kdyby bylo OK, ukoncime}
  if (ExitCode=0)or(ExitCode=2) then begin
    case Button of
      1: begin
           AO_Freq08:= ReadIntegerInDialog(78{-InfMenu[60].X}+dial^.x, 2+dial^.y, 4680, maxint, AO_Freq08);
         end;
         {zadani prehravaci frekvence}
      2: {ukonceni nastavovani zvuku};
    end;
  end;
  InfMenu[64].X:= dial^.x;
  InfMenu[64].Y:= dial^.y;
  {aktualizuju prip. zmenene souradnice menu}
  smazdialog(dial);
  {kvuli zadavani hodnoty, aby pod tim nebylo "prazdno", mazu dialog teprv ted}
  dealokujdialog(dial, vysl);
  {cca to same, kvuli promennym dial^.x a dial^.y}

until ( (ExitCode=0)or(ExitCode=2) )and(Button=2);

end;


procedure ChooseFile(JakTridit: ttrideni; PreviousPath, Extension: string);
begin
  Path:= vybersouboru(InfMenu[52].X,InfMenu[52].Y,InfMenu[52].Pocet,
    DColor1, DColor2, DColor3, DColor4, DColor5, Font,
    JakTridit, PreviousPath, Extension);
end;

function CutNameFromPath(InputPath: string): string;
var
  i, i1: byte;
begin
  i:= Length(InputPath);
  if i>0 then begin
    while (InputPath[i]<> '.')and(i>1 ) do Dec(i);
    i1:= i;
    while (InputPath[i]<> '\')and(i>1 ) do Dec(i);
    CutNameFromPath:= Copy(InputPath, i+1, i1-i-1);
  end else begin
    CutNameFromPath:= '';
  end;
end;

procedure AdjustANMName;
begin
  if ANM_Name='' then ReportANM_Name:=' <žádný>' else ReportANM_Name:= ANM_Name;
end;

procedure SaveCFG;
var f: file;
begin
  Assign(f, {ProgPath+ }ProgName+ '.CFG');
  Rewrite(f, 1);
  BlockWrite(f, Picture_Path, 256);
  BlockWrite(f, Sample_Path, 256);
  BlockWrite(f, Background_Path, 256);
  BlockWrite(f, Music_Path, 256);
  BlockWrite(f, ANM_Path, 256);
  BlockWrite(f, AO_SoundDevice, 1);
  BlockWrite(f, AO_Freq08, 2);
  Close(f);
end;

procedure LoadCFG;
var f: file;
begin
  Assign(f, {ProgPath+ }ProgName+ '.CFG');
  Reset(f, 1);
  if IOResult= 0 then begin
    BlockRead(f, Picture_Path, 256);
    BlockRead(f, Sample_Path, 256);
    BlockRead(f, Background_Path, 256);
    BlockRead(f, Music_Path, 256);
    BlockRead(f, ANM_Path, 256);
    BlockRead(f, AO_SoundDevice, 1);
    BlockRead(f, AO_Freq08, 2);
    Close(f);
  end else begin
{    StandardniDialog('V cestě programu nastavené na|'+Program_Path+'|nemohu nalézt konfigurační soubor!',
    DColor1, DColor2, DColor3, DColor4, DColor5, font, BeruNaVedomi);
 } end;

end;

procedure AssignAllArchives;
begin
  Assign(AN0_ImageName,    ANM_Path+ANM_Name+'.AN0');
  Assign(AN1_Image,        ANM_Path+ANM_Name+'.AN1');
  Assign(AN2_SampleName,   ANM_Path+ANM_Name+'.AN2');
  Assign(AN3_Sample,       ANM_Path+ANM_Name+'.AN3');
  Assign(AN4_SequenceName, ANM_Path+ANM_Name+'.AN4');
  Assign(AN5_Sequence,     ANM_Path+ANM_Name+'.AN5');
  Assign(AN6_Misc,         ANM_Path+ANM_Name+'.AN6');
end;

procedure EraseAllArchives;
begin
  AssignAllArchives;
  Erase(AN0_ImageName);
  Erase(AN1_Image);
  Erase(AN2_SampleName);
  Erase(AN3_Sample);
  Erase(AN4_SequenceName);
  Erase(AN5_Sequence);
  Erase(AN6_Misc);
end;

procedure RewriteAllArchives;
begin
{  SetArchiveCapacity(255);}

  CAddFromMemory(ANM_Path+ANM_Name+'.AN0', @ImageNameHead,    Length(ImageHead)+1 );
  CAddFromMemory(ANM_Path+ANM_Name+'.AN1', @ImageHead,        Length(ImageHead)+1 );
  CAddFromMemory(ANM_Path+ANM_Name+'.AN2', @SampleNameHead,   Length(ImageHead)+1 );
  CAddFromMemory(ANM_Path+ANM_Name+'.AN3', @SampleHead,       Length(ImageHead)+1 );
  CAddFromMemory(ANM_Path+ANM_Name+'.AN4', @SequenceNameHead, Length(ImageHead)+1 );
  CAddFromMemory(ANM_Path+ANM_Name+'.AN5', @SequenceHead,     Length(ImageHead)+1 );
  CAddFromMemory(ANM_Path+ANM_Name+'.AN6', @MiscHead,         Length(ImageHead)+1 );

  CAddFromMemory(ANM_Path+ANM_Name+'.AN6', @Background_Name, 9);
  CAddFromMemory(ANM_Path+ANM_Name+'.AN6', @Music_Name, 9);

end;

procedure InitProg; { Inicializuje grafiku, font, mys, paletu ..., promene }
  function PurePath(FullPath: string): string;
  var
    i, i1: byte;
  begin
    i:= Length(FullPath);
    while (FullPath[i]<> '\')and(FullPath[i]<> ':')and(i> 0) do Dec(i);
    PurePath:= Copy(FullPath, 1, i);
  end;

begin
  ProgPath:= PurePath(ParamStr(0));

  GetMem(EdAnim, LengthTAnmPhase*_MaxPhases+LengthTAnmHeader);

  DColor1:= 15;
  DColor2:= 7;
  DColor3:= 12;
  DColor4:= 2;
  DColor5:= 8;

  LoadCFG;

  if RegisterFont(Font, ProgPath+FontName) then begin
    WriteLn('! Nemuzu najit '+FontName+' !');
    Halt(1);
  end;
  if not FileExist(ProgPath+ProgName+ '.DAT')then begin
    WriteLn('! Nemuzu najit '+ProgName+'.dat !');
    Halt(1);
  end;
  CLoadItem(ProgPath+ ProgName+ '.DAT', MouseImage, 1);
  CLoadItem(ProgPath+ ProgName+ '.DAT', pointer(Palette), 2);
  InitGraph;
  InitMouse;

  { Inicializace grafiky }
  SetPalette(Palette);
  LastLine := 200;
  ActivePage := 0;
  SetVisualPage(1);
  SetActivePage(0);
  OverFontColor:=255;
  FonColor1:=7;
  FonColor2:=2;
  FonColor3:=3;
  FonColor4:=4;
  MouseOn(0, 0, MouseImage);
  SetVisualPage(0);
end;

procedure DoneProg;
begin
  MouseOff;
  FreeMem(Palette, 768);
  DisposeImage(MouseImage);
{  FreeMem(MouseImage, PWordArray(MouseImage)^[0]*PWordArray(MouseImage)^[1]+4);}
  FreeMem(Font, Font^[0]*Font^[1]*138+140);
  FreeMem(EdAnim, LengthTAnmPhase*_MaxPhases+LengthTAnmHeader);
end;


function PlayEditedAnimation(ActPhase, FromPhase: byte): byte;
var
  Key: char;
  OldActPhase: byte;
  LoadedBackground: pointer;
  LoadedPalette: {PPalette}pointer;
  BckgExist: boolean;
  SpriteAddresses: array[1..255] of pointer; {pole adres sprajtu jednotlivych animacnich fazi}
  SampleAddresses: array[1..255] of pointer; {pole adres samplu jednotlivych animacnich fazi}
  SampleSizes:     array[1..255] of word; {pole delek samplu}
  PCO: byte;
  h, g: byte;
  SlowDown: integer;
  ActualDelay: word;
  NextPhaseSound: TOneChannel;
  Ph1, Ph2: longint; {na odladovaci pocitani velikosti hromady}
  SumDelay_TooL, LoopPasses_TooL: longint;

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
      if Sample> 1 then begin
      {pokud je rozumne cislo samplu, nastavim ho, aby hral}
        NextPhaseSound.ChVolume:= 51;
        NextPhaseSound.SizeCh:= SampleSizes[ActPhase];
        NextPhaseSound.ChLoop:= 0;
        NextPhaseSound.ChLooped:= 0;
        NextPhaseSound.ChLenLp:= 2;

        NextPhaseSound.Krok:=  Hi(word   (round  (256* (Frequency/AO_Freq08) )  )   );
        NextPhaseSound.OvrLd:= Lo(word   (round  (256* (Frequency/AO_Freq08) )  )   );

        NextPhaseSound.ChOfs:= Ofs(SampleAddresses[ActPhase]^);
        NextPhaseSound.ChActPos:= Ofs(SampleAddresses[ActPhase]^);
        NextPhaseSound.ChSeg:= 0;
        {nula tady nam rekne, ze pri prehazovani stranek sem mam zapsat hodnotu}
      end;
      if EdAnim^.Header.Relative= 0 then begin
        NewPosAObj(PCO, X, Y);
      end else begin
        CompX:= X+GetNewXAObj(PCO);
        CompY:= Y+GetNewYAObj(PCO);
        if CompY> 199 then CompY:= - ZoomY;

{??????!!!!!!!!????????? To by me zajimalo, proc to TAKHLE jde, a jinak NE}
        if (CompY< ((-1)*ZoomY) )then CompY:= 199;
        if (CompX< ((-1)*ZoomX) )then CompX:= 319;
{Puvodne tady bylo (-ZoomY) a fungovalo to, pak to ale zniceho nic zacalo}
{prekladat blbe; no vazne, nic jsem v Options nemenil...}
{???????????!!!!!!!!!!!???????????????????????}

        if CompX> 319 then CompX:= - ZoomX;
        NewPosAObj(PCO, CompX, CompY );
      end;
      NewZoomAObj(PCO, ZoomX, ZoomY);
      NewMirrorAObj(PCO, Mirror);
    end;
  end;

begin
  Ph1:= MaxAvail;
  SlowDown:= 1;

{ Nastavim vystupni zarizeni }
  SoundSetOutDevice(AO_SoundDevice);
{ Inicializuju osmicku s prehravacem samplu a hudby }
  ComputeFrequency(AO_Freq08);
  SetFrequency(AO_Freq08);

  if FileExist(Music_Path+ Music_Name+ '.MUS')then begin
  { Nactu hudbu do pameti }
    LoadMusic(Music_Path+ Music_Name+ '.MUS');
    StartMusic(550);
  end;

  PrepareAnimation;

  if FileExist(Background_Path+ Background_Name+ '.pcx')then begin
    {zjistim, jestli je zadane pozadi}
    if LoadImage(LoadedBackground, LoadedPalette, Background_Path+ Background_Name+ '.pcx')= 0 then begin
      standardnidialog('Chyba při čtení pozadi:|'+Background_Path+ Background_Name+ '.PCX',
      DColor1, DColor2, DColor3, DColor4, DColor5, font, BeruNaVedomi);
      exit;
    end;
    {nacetl jsem do pameti pozadi}
    SetPalette(LoadedPalette);
    {nastavim paletu pozadi}
    AddImageAObj(PCO, 1, 0, 1, 0, 0);
    AddSpriteToLastObj(0, LoadedBackground);
    {nainstaluju pozadi jako jeden z animacnich objektu}
    BckgExist:= True;
  end else begin
    BckgExist:= False;
    {pokud pozadi neni zadano, nebo je zadano chybne, bude podklad cerny}
  end;
  AnimBackColor:= 0;

  for h:= 1 to EdAnim^.Header.NumOfPhases do with EdAnim^.Phase[h] do begin
    {projdu vsechny faze}
    if Picture>1 then begin
      {v uvahu beru jenom platne cislo obrazku, kdyz je neplatne, fazi ignoruji}
      g:= 0;
      repeat Inc(g) until Picture=EdAnim^.Phase[g].Picture;
      {cyklus jede tak dlouho, dokud nenajde nekde v predchozich fazich shodne}
      {cislo obrazku}
      if g=h then CLoadItem(ANM_Path+ANM_Name+'.AN1', SpriteAddresses[h], Picture)
      {pokud se shoduje obrazek az ve fazi, ktera je jeho (=sam se sebou),}
      {znamena to, ze se jeste nenahral, takze udelam vsechno pro to...}
      {nacetl jsem sprajt}
      else SpriteAddresses[h]:=SpriteAddresses[g];
      {jinak priradim adresu jiz nahraneho sprajtu}
    end;
  end;
  for h:= 1 to EdAnim^.Header.NumOfPhases do with EdAnim^.Phase[h] do begin
    {projdu vsechny faze}
    if Sample>1 then begin
      {v uvahu beru jenom platne cislo obrazku, kdyz je neplatne, fazi ignoruji}
      g:= 0;
      repeat Inc(g) until Sample=EdAnim^.Phase[g].Sample;
      {cyklus jede tak dlouho, dokud nenajde nekde v predchozich fazich shodne}
      {cislo obrazku}
      if g=h then begin
      {pokud se shoduje obrazek az ve fazi, ktera je jeho (=sam se sebou),}
      {znamena to, ze se jeste nenahral, takze udelam vsechno pro to...}
        CLoadItem(ANM_Path+ANM_Name+'.AN3', SampleAddresses[h], Sample);
        SampleSizes[h]:= UnpackedItemSize(ANM_Path+ANM_Name+'.AN3', Sample);
        {nacetl jsem sprajt}
      end else begin
        {jinak priradim adresu jiz nahraneho sprajtu}
        SampleAddresses[h]:=SampleAddresses[g];
        SampleSizes[h]:= SampleSizes[g];
      end;
    end;
  end;

  AddImageAObj(PCO, 2, 0, 0, 0, 0);
  AddSpriteToLastObj(0, SpriteAddresses[1]);
  {zaregistroval jsem i editovany animacni objekt}

  PushMouse;
  SetActivePage(1);
  SetVisualPage(0);
  AnimMouseOn(0, 0, MouseImage);

  OldActPhase:= ActPhase;
  ActPhase:= FromPhase;
  Dec(ActPhase);
{  ActPhase:= 0;
  if MouseKey=1 then begin
    repeat until MouseKey=0;
    ActPhase:= OldActPhase-1;
  end;}
  {Pokud je stistene leve mysitko, zacnu prehravat od aktualni faze, jinak
   od zacatku}

  if BckgExist then VisibleAObj(0);
  {Pokud pozadi existuje, zviditelnim ho}
  if EdAnim^.Phase[ActPhase+1].Picture> 1 then VisibleAObj(PCO);
  {Pokud ma faze nejaky realny obrazek, zviditelnim ho}

  NewPosAObj(PCO, 100, 100);
  NextPhaseSound.ChSeg:= 1;
  {nula tady nam rekne, ze pri prehazovani stranek sem mam zapsat hodnotu}
  {je 1, tedy - prozatim predpokladame, ze se nic hrat nebude, protoze}
  {jinak by tady zustala drivejsi hodnota, no a v pripade, ze by to byla}
  {nula, delalo by zmatky}

  NextPhase;

  AnimBackColor:= 0;
  AnimEnableClearScreen:= 1;
  AnimMouseSwitchOff;
  SmartPutAObjs;
  AnimMouseSwitchOn;
  SwapAnimPages;
  SmartPutAObjs;
  SwapAnimPages;
  AnimEnableClearScreen:= byte(BckgExist= False);
  AnimWhatObjectsMousePoints:= Image;
  {Inicializoval jsem obe dve stranky a nastavil jsem vse potrebne}

  TooLate:= 0;
  SumDelay_TooL:= 0;
  LoopPasses_TooL:= 0;
  Time08^.TimerWord1:= 0;
  Dec(ActPhase);
  SoundInitPlay;
  repeat {---------- hlavni smycka -------------}

       NextPhase;
       SmartPutAObjs;
       WaitVRetrace;
       SwapAnimPages;
       WaitDisplay;
       if(NextPhaseSound.ChSeg=0) then begin
         NextPhaseSound.ChSeg:= Seg(SampleAddresses[ActPhase]^);
         Sound_Channels^.i[0].ChSeg:= NextPhaseSound.ChSeg;
         Sound_Channels^.i[0].ChVolume:= NextPhaseSound.ChVolume;
         Sound_Channels^.i[0].SizeCh:= NextPhaseSound.SizeCh;
         Sound_Channels^.i[0].ChLoop:= NextPhaseSound.ChLoop;
         Sound_Channels^.i[0].ChLooped:= NextPhaseSound.ChLooped;
         Sound_Channels^.i[0].ChLenLp:= NextPhaseSound.ChLenLp;

         Sound_Channels^.i[0].Krok:=  NextPhaseSound.Krok;
         Sound_Channels^.i[0].OvrLd:= NextPhaseSound.OvrLd;

         Sound_Channels^.i[0].ChOfs:= NextPhaseSound.ChOfs;
         Sound_Channels^.i[0].ChActPos:= NextPhaseSound.ChActPos;
         {az teprve ted muzu naladovat hodnoty primo do promennych 0. kanalu,}
         {aby to zaclo hrat zaroven s prepnutim faze}
       end;
       SumDelay_TooL:= SumDelay_TooL+ Time08^.TimerWord1;
       Inc(LoopPasses_TooL);
       if SlowDown=0 then begin
         repeat until (KeyPressed)or(MouseKey<>0);
         Time08^.TimerWord1:= 0;
         if KeyPressed then Key:= ReadKey;
         if Key in ['0'..'9'] then SlowDown:= Abs(48-integer(Key));
         if Key=#0 then begin
           Key:= ReadKey;
           if Key=#75 then if ActPhase=1 then ActPhase:= EdAnim^.Header.NumOfPhases-1
           else Dec(ActPhase, 2); {prejdu o fazi vzad}
         end;
       end else begin
         if (Time08^.TimerWord1 div _msDelayUnit)< (EdAnim^.Phase[ActPhase].Delay*SlowDown) then
           repeat until ((EdAnim^.Phase[ActPhase].Delay*SlowDown)= (Time08^.TimerWord1 div _msDelayUnit) )
           or(KeyPressed)or(MouseKey<>0);
         Time08^.TimerWord1:= 0;
         if KeyPressed then Key:= ReadKey;
         if Key in ['0'..'9'] then SlowDown:= Abs(48-integer(Key));
       end;

  until (Key in [#27, #13])or(MouseKey in [1, 2]);

  {----------------------------------------------}

  if (MouseKey=1)or(Key=#13)then PlayEditedAnimation:= ActPhase else PlayEditedAnimation:= OldActPhase;
  {Pokud vyskakuju na pravy mysitko, predam cislo faze, kde k vyskocemi doslo,
   jinak predavam cislo faze, jaka byla aktualni pred zavolanim PlayEdi...}

  TooLate:= SumDelay_TooL div LoopPasses_TooL;
  if KeyPressed then ReadKey;
  {v pripade, ze bylo ukonceno klavesou, odstrani klavesu z bufferu klavesnice}
  Sound_Channels^.i[0].ChSeg:= 0;
  {pro jistotu vynuluju efekt, at to nedela zadne zmatky}
  SoundDonePlay;

  AnimMouseOff;
  SetActivePage(0);
  SetVisualPage(0);
  ClearScr(0);
  PopMouse;

  ReleaseLastAObj;

  {nyni nasleduje odinstalovani samplu}
  for h:= 1 to EdAnim^.Header.NumOfPhases do with EdAnim^.Phase[h] do begin
    {projdu vsechny faze}
    if Sample>1 then begin
      {v uvahu beru jenom platne cislo samplu, kdyz je neplatne, fazi ignoruji}
      g:= 0;
      repeat Inc(g) until Sample=EdAnim^.Phase[g].Sample;
      {cyklus jede tak dlouho, dokud nenajde nekde v predchozich fazich shodne}
      {cislo samplu}
      if g=h then begin
      {pokud se shoduje sampl az ve fazi, ktera je jeho (=sam se sebou),}
      {znamena to, ze se muze odinstalovat, protoze jsem na nej narazil teprve poprve}
        FreeMem(SampleAddresses[h], SampleSizes[h]);
      end;
    end;
  end;

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
        DisposeImage(SpriteAddresses[h]);
      end;
    end;
  end;


  if BckgExist then begin
    ReleaseLastAObj;
{    DisposeImage(LoadedBackground);}
    FreeMem(LoadedBackground, PWordArray(LoadedBackground)^[0]*PWordArray(LoadedBackground)^[1]+4);
    FreeMem(LoadedPalette, 768);
    {...paletu muzu odinstalovat z pameti}
  end;

  if FileExist(Music_Path+ Music_Name+ '.MUS')then begin
  { Uvolnim hudbu z pameti }
    StopMusic;
    ReleaseMusic;
  end;

  SetPalette(Palette);

{  MouseOn(0, 0, MouseImage);}
  Ph2:= MaxAvail;
  if Ph1<>Ph2 then Write(#7#7);

end;




procedure EraseReadedSequenceFromStore(What: byte);
begin
  CEraseItem(ANM_Path+ANM_Name+'.AN5', What);
end;

procedure WriteSequenceToStore;
begin
  ActualSequenceNumber:= CAddFromMemory(ANM_Path+ANM_Name+'.AN5', EdAnim,
    LengthTAnmPhase*EdAnim^.Header.NumOfPhases+LengthTAnmHeader);
end;

procedure EraseReadedSeqNameFromStore(What: byte);
begin
  CEraseItem(ANM_Path+ANM_Name+'.AN4', What);
end;

procedure WriteSeqNameToStore;
begin
  CAddFromMemory(ANM_Path+ANM_Name+'.AN4', {@byte(}@Seq_Name{[0])}, 13);
end;


procedure EditSequenceDialog;
var
  dial:pdialog;
  vysl:pstav;
  ExitCode, Button: byte;

  ActPhase_s, NumOfPhases_s,
  Pict_s, X_s, Y_s, ZoomX_s,
  ZoomY_s, Sam_s, Freq_s, Delay_s: string[5];

  cisloobr: word;
  ActPhase: byte;

  ActPhaseImage: pointer;
  APBarX, APBarY: word;

  f: byte;
  WriteSeq: boolean; {pouziti pri save sekvence}

  procedure SetXYByMouse;
  var
    LoadedScreen: pointer;
    LoadedPalette: {PPalette}pointer;

    f: byte;
    XDiff, YDiff: integer;
    OrigWidth, OrigHeigth: word;
  begin
    if EdAnim^.Phase[ActPhase].Picture>1 then begin
      if FileExist(Background_Path+ Background_Name+ '.pcx')then begin
        if LoadImage(LoadedScreen, LoadedPalette, Background_Path+ Background_Name+ '.pcx')= 0 then begin
          standardnidialog('Chyba při čtení pozadi:|'+Background_Path+ Background_Name+ '.PCX',
          DColor1, DColor2, DColor3, DColor4, DColor5, font, BeruNaVedomi);
          exit;
        end;
        PutImage(0, 0, LoadedScreen);
        SetPalette(LoadedPalette);
        {pozadi vytisknu}
        DisposeImage(LoadedScreen);
        FreeMem(LoadedPalette, 768);
        {...a rovnou ho muzu odinstalovat z pameti}
      end else begin
        ClearScr(8);
        {pokud pozadi neni zadano, nebo je zadano chybne, vycistim obrazovku}
      end;

      if ActPhase>1 then with EdAnim^.Phase[ActPhase-1] do begin
      {Pokud je aktualne zadavana faze vetsi nez jedna, znamena to, ze existuje}
      { aspon jedna faze pred ni, kterou vytisknu na jeji misto}
        if Picture>1 then begin
          XDiff:= 0;
          YDiff:= 0;
          if EdAnim^.Header.Relative= 1 then for f:= 1 to ActPhase-1 do begin
            XDiff:= XDiff+ EdAnim^.Phase[f].X;
            YDiff:= YDiff+ EdAnim^.Phase[f].Y;
          end else begin
            XDiff:= X;
            YDiff:= Y;
          end;

          CLoadItem(ANM_Path+ANM_Name+'.AN1', LoadedScreen, Picture);

          if ZoomX= 0 then ZoomX:= PWordArray(LoadedScreen)^[0];
          if ZoomY= 0 then ZoomY:= PWordArray(LoadedScreen)^[1];
          {Pokud by se stalo, ze predchozi obr. ma nastavene rozmery na nulu,
           dam mu originalni rozmery. Muze se to stat, kdyz zavolam SetXYByMouse
           tesne po blokovych operacich, kterymi jsem Zoom nastavil na 0}
          if Mirror=0 then PutMaskImagePartZoom(XDiff, YDiff, ZoomX, ZoomY, 0, 0, 320, 200, LoadedScreen)
          else PutMirrorMaskImagePartZoom(XDiff, YDiff, ZoomX, ZoomY, 0, 0, 320, 200, LoadedScreen);
          DisposeImage(LoadedScreen);
        end;
      end;

      with EdAnim^.Phase[ActPhase] do begin
        if Picture>1 then begin
          CLoadItem(ANM_Path+ANM_Name+'.AN1', LoadedScreen, Picture);
          PushMouse;
          SetActivePage(ActivePage XOR 1);
          ClearScr(255);
          if Mirror= 1 then begin
            PutMirrorMaskImagePartZoom(0, 0, ZoomX, ZoomY, 0, 0, 320, 200, LoadedScreen);
          end else begin
            PutMaskImagePartZoom(0, 0, ZoomX, ZoomY, 0, 0, 320, 200, LoadedScreen);
          end;
          OrigWidth:= PWordArray(LoadedScreen)^[0];
          OrigHeigth:= PWordArray(LoadedScreen)^[1];
          DisposeImage(LoadedScreen);
          if (ZoomX<320)and(ZoomY<200)then begin
            NewImage(ZoomX, ZoomY, LoadedScreen);
            GetImage(0, 0, ZoomX, ZoomY, LoadedScreen);
          end else begin
            NewImage(OrigWidth, OrigHeigth, LoadedScreen);
            GetImage(0, 0, OrigWidth, OrigHeigth, LoadedScreen);
          end;
          SetActivePage(ActivePage XOR 1);
{          if Mirror= 1 then begin
            SetActivePage(ActivePage XOR 1);
            ClearScr(255);
            PutMirrorMaskImagePart(0, 0, 0, 0, 320, 200, LoadedScreen);
            GetImage(0, 0, PWordArray(LoadedScreen)^[0], PWordArray(LoadedScreen)^[1], LoadedScreen);
            SetActivePage(ActivePage XOR 1);
          end;
 }
          MouseOn(PWordArray(LoadedScreen)^[0]-1, PWordArray(LoadedScreen)^[1]-1, LoadedScreen);
          NewMouseArea(0, 0, 318+PWordArray(LoadedScreen)^[0], 198+PWordArray(LoadedScreen)^[1]);
          repeat until((KeyPressed)and(ReadKey=#27))or(MouseKey in [1, 2]);
          if MouseKey=1 then begin
            X:= MouseX-PWordArray(LoadedScreen)^[0]+1;
            Y:= MouseY-PWordArray(LoadedScreen)^[1]+1;
            if (EdAnim^.Header.Relative=1)and(ActPhase>1) then begin
              X:= X- XDiff;
              Y:= Y- YDiff;
            end;
          end;
          MouseOff;
          PopMouse;
          DisposeImage(LoadedScreen);
        end;
      end;

      NewMouseArea(0, 0, 319, 199);
      SetPalette(Palette);
      {Nastavim zpet paletu programu}
    end;

  end;{of proc}


  procedure ComputeMemoryRequirements;
  var
    f, g: byte;
    BiggestPict, SumPict, CSumPict: longint;
    BiggestSam,  SumSam,  CSumSam : longint;
    SumDelay: word;
    SumAnmRecord: word;
    BP, SP, CSP, BS, SS, CSS, SD, SAR: string[7];

    TooLate_s: string[4];

  begin
    BiggestPict:= 0;
    BiggestSam:= 0;
    SumPict:= 0;
    CSumPict:=0;
    SumSam:=0;
    CSumSam:=0;
    SumDelay:=0;
    for f:= 1 to EdAnim^.Header.NumOfPhases do with EdAnim^.Phase[f] do begin
      if Picture>1 then begin
        g:= 0;
        repeat Inc(g) until Picture=EdAnim^.Phase[g].Picture;
        if g=f then begin
          SumPict:= SumPict+ UnpackedItemSize(ANM_Path+ANM_Name+'.AN1', Picture);
          CSumPict:= CSumPict+ PackedItemSize(ANM_Path+ANM_Name+'.AN1', Picture);
          if UnpackedItemSize(ANM_Path+ANM_Name+'.AN1', Picture)>BiggestPict then
            BiggestPict:= UnpackedItemSize(ANM_Path+ANM_Name+'.AN1', Picture);
        end;
      end;
      if Sample>1 then begin
        g:= 0;
        repeat Inc(g) until Sample=EdAnim^.Phase[g].Sample;
        if g=f then begin
          SumSam:= SumSam+ UnpackedItemSize(ANM_Path+ANM_Name+'.AN3', Sample);
          CSumSam:= CSumSam+ PackedItemSize(ANM_Path+ANM_Name+'.AN3', Sample);
          if UnpackedItemSize(ANM_Path+ANM_Name+'.AN3', Sample)>BiggestSam then
            BiggestSam:= UnpackedItemSize(ANM_Path+ANM_Name+'.AN3', Sample);
        end;
      end;
      Inc(SumDelay, Delay * _msDelayUnit);
      {spocitam zdrzeni podle nastaveneho nejmensiho mozneho zdrzeni}
    end;
    SumAnmRecord:= LengthTAnmPhase*EdAnim^.Header.NumOfPhases +LengthTAnmHeader;

    Str(BiggestPict:7, BP);
    Str(SumPict:7,  SP);
    Str(CSumPict:7,  CSP);
    Str(BiggestSam:7,  BS);
    Str(SumSam:7,  SS);
    Str(CSumSam:7,  CSS);
    Str(SumDelay:7,  SD);
    Str(SumAnmRecord:7,  SAR);
    Str(TooLate:4, TooLate_s );
    standardnidialog('Jméno animace: '+Seq_Name+
    +'|Popis zabírá:'+SAR+' byte'+
    +'|Doba provádění:'+SD+' sľ'+
    +'|- OBRÁZKY -|celkem:'+SP+'  zpakované:'+CSP+
    +'|největší:'+BP+
    +'|- SAMPLY -|celkem:'+SS+'  zpakované:'+CSS+
    +'|největší:'+BS+
    +'|- - -|Ľ doba kreslení 1 fáze:'+ TooLate_s+' sľ',
    DColor1, DColor2, DColor3, DColor4, DColor5, font, Upozorneni{BeruNaVedomi});

  end;

  procedure DeletePhase;
  var
    f: byte;
  begin
    if EdAnim^.Header.NumOfPhases>1 then begin
      for f:= ActPhase+1 to EdAnim^.Header.NumOfPhases do with EdAnim^.Phase[f] do begin
          EdAnim^.Phase[f-1].Picture      := Picture;
          EdAnim^.Phase[f-1].X            := X;
          EdAnim^.Phase[f-1].Y            := Y;
          EdAnim^.Phase[f-1].ZoomX        := ZoomX;
          EdAnim^.Phase[f-1].ZoomY        := ZoomY;
          EdAnim^.Phase[f-1].Mirror       := Mirror;
          EdAnim^.Phase[f-1].Sample       := Sample;
          EdAnim^.Phase[f-1].Frequency    := Frequency;
          EdAnim^.Phase[f-1].Delay        := Delay;
      end;
      Dec(EdAnim^.Header.NumOfPhases);
      if ActPhase>EdAnim^.Header.NumOfPhases then Dec(ActPhase);
    end;
  end;

  procedure AddPhase;
  var
    f: byte;
  begin
    if EdAnim^.Header.NumOfPhases< _MaxPhases then begin
      InfMenu[61].Volba:= 1;
      InfMenu[61].Volba:= VytvorMenu('~Před|~Za',
        DColor1, DColor2, DColor3, DColor4,DColor5, font, InfMenu[61].X, InfMenu[61].Y,
        InfMenu[61].Volba, -1);
      if InfMenu[61].Volba<>-1 then begin
        for f:= EdAnim^.Header.NumOfPhases+1 downto ActPhase+1 do with EdAnim^.Phase[f-1] do begin
            EdAnim^.Phase[f].Picture      := Picture;
            EdAnim^.Phase[f].X            := X;
            EdAnim^.Phase[f].Y            := Y;
            EdAnim^.Phase[f].ZoomX        := ZoomX;
            EdAnim^.Phase[f].ZoomY        := ZoomY;
            EdAnim^.Phase[f].Mirror       := Mirror;
            EdAnim^.Phase[f].Sample       := Sample;
            EdAnim^.Phase[f].Frequency    := Frequency;
            EdAnim^.Phase[f].Delay        := Delay;
        end;
        Inc(EdAnim^.Header.NumOfPhases);

        if InfMenu[61].Volba= 2 then Inc(ActPhase);
        with EdAnim^.Phase[ActPhase] do begin
          Picture      := 0;
          ZoomX        := 0;
          ZoomY        := 0;
          Mirror       := 0;
          Sample       := 0;
          Frequency    := 0;
        end;

      end;
    end;
  end;

  procedure CopyPhase;
  begin
    if EdAnim^.Header.NumOfPhases< _MaxPhases then begin
      Inc(EdAnim^.Header.NumOfPhases);
      with EdAnim^.Phase[ActPhase] do begin
          EdAnim^.Phase[EdAnim^.Header.NumOfPhases].Picture      := Picture;
          EdAnim^.Phase[EdAnim^.Header.NumOfPhases].X            := X;
          EdAnim^.Phase[EdAnim^.Header.NumOfPhases].Y            := Y;
          EdAnim^.Phase[EdAnim^.Header.NumOfPhases].ZoomX        := ZoomX;
          EdAnim^.Phase[EdAnim^.Header.NumOfPhases].ZoomY        := ZoomY;
          EdAnim^.Phase[EdAnim^.Header.NumOfPhases].Mirror       := Mirror;
          EdAnim^.Phase[EdAnim^.Header.NumOfPhases].Sample       := Sample;
          EdAnim^.Phase[EdAnim^.Header.NumOfPhases].Frequency    := Frequency;
          EdAnim^.Phase[EdAnim^.Header.NumOfPhases].Delay        := Delay;
      end;
      Inc(ActPhase);
    end;
  end;

  procedure BlockOperations;
  const
    FirstVal:integer= 0;
    LastVal: integer= 0;
    FirstMul: real= 1;
    LastMul:  real= 1;
  var
    dial:pdialog;
    vysl:pstav;
    ExitCode, Button, Item, Action: byte;
    st5: string[5];
    st10: string[10];
    LastPhase, FirstPhase: word;
    Step: real;

    procedure RelativizeCoords;
    var f: integer;
    begin
      if standardnidialog('Opravdu mám v označených fázích|zrelativizovat souřadnice?',
      DColor1, DColor2, DColor3, DColor4, DColor5, font, Ano_Ne)=1 then begin
        for f:= LastPhase downto FirstPhase+1 do with EdAnim^.Phase[f] do begin
          X:= X- EdAnim^.Phase[f-1].X;
          Y:= Y- EdAnim^.Phase[f-1].Y;
        end;
      end;
    end;

    procedure AbsolutizeCoords;
    var f: integer;
    begin
      if standardnidialog('Opravdu mám v označených fázích|zabsolutizovat souřadnice?',
      DColor1, DColor2, DColor3, DColor4, DColor5, font, Ano_Ne)=1 then begin
        for f:= FirstPhase+1 to LastPhase do with EdAnim^.Phase[f] do begin
          X:= X+ EdAnim^.Phase[f-1].X;
          Y:= Y+ EdAnim^.Phase[f-1].Y;
        end;
      end;
    end;

    procedure DoBlockOperation;
    var
      f: byte;
      OldActPhase: word;
    begin
      case Action of
      1: begin
        {naplnim hodnotami}
        if ( (Item= 1)or(Item=6) )and( (FirstVal<2)or(LastVal<2) ) then begin
         standardnidialog('Zapisovaná hodnota|je povolena pouze v rozsahu|2 a výše!||*Akce neprovedena*',
           DColor1, DColor2, DColor3, DColor4, DColor5, font, BeruNaVedomi);
        {odchyceni cisel mensich jak 2 u picture a sample}
        end else begin
        if ( (Item<2)or(Item>3) )and( (FirstVal<0)or(LastVal<0) ) then begin
         standardnidialog('Zapisovaná hodnota|nemůže být záporná!||*Akce neprovedena*',
           DColor1, DColor2, DColor3, DColor4, DColor5, font, BeruNaVedomi);
        {odchyceni cisel mensich jak 0 vsude s vyjimkou souradnic X a Y}
        end else begin
        if (Item= 1)and
        (
        ( (FirstVal>= LastVal)and(FirstVal> GetArchiveOccupy(ANM_Path+ANM_Name+'.AN1') ))
        or
        ( (FirstVal< LastVal)and(LastVal> GetArchiveOccupy(ANM_Path+ANM_Name+'.AN1') ))
        )then begin
         standardnidialog('Chceš zapsat číslo obrázku,|které je větší, než počet položek skladu!||*Akce neprovedena*',
           DColor1, DColor2, DColor3, DColor4, DColor5, font, BeruNaVedomi);
        {odchyceni cisel obrazku, ktere archiv neobsahuje}
        end else begin
        if (Item= 6)and
        (
        ( (FirstVal>= LastVal)and(FirstVal> GetArchiveOccupy(ANM_Path+ANM_Name+'.AN3') ))
        or
        ( (FirstVal< LastVal)and(LastVal> GetArchiveOccupy(ANM_Path+ANM_Name+'.AN3') ))
        )
        then begin
         standardnidialog('Chceš zapsat číslo samplu,|které je větší, než počet položek skladu!||*Akce neprovedena*',
           DColor1, DColor2, DColor3, DColor4, DColor5, font, BeruNaVedomi);
        {odchyceni cisel obrazku, ktere archiv neobsahuje}
        end else begin
          if (LastPhase- FirstPhase)<>0 then
            Step:= (LastVal- FirstVal)/(LastPhase- FirstPhase)
          else Step:= 0;
          for f:= FirstPhase to LastPhase do begin
            with EdAnim^.Phase[f] do begin
              case Item of
                1: Picture:= round( Step*(f- FirstPhase)+ FirstVal );
                2: X      := round( Step*(f- FirstPhase)+ FirstVal );
                3: Y      := round( Step*(f- FirstPhase)+ FirstVal );
                4: begin
                     ZoomX  := round( Step*(f- FirstPhase)+ FirstVal );
                   end;
                5: begin
                     ZoomY  := round( Step*(f- FirstPhase)+ FirstVal );
                   end;
                6: Sample := round( Step*(f- FirstPhase)+ FirstVal );
                7: Delay  := round( Step*(f- FirstPhase)+ FirstVal );
              end;
            end;
          end;
        end;
        end;
        end;
        end;
      end;
      2: begin
        {modifikuju nasobenim}
        if Item in [2, 3, 4, 5, 7] then begin
          Step:= FirstMul;
          for f:= FirstPhase to LastPhase do begin
            with EdAnim^.Phase[f] do begin
              case Item of
                2: X      := round( Step*X );
                3: Y      := round( Step*Y );
                4: begin
                     ZoomX  := round( Step*ZoomX );
                   end;
                5: begin
                     ZoomY  := round( Step*ZoomY );
                   end;
                7: Delay  := round( Step*Delay );
              end; {of case}
            end; {of with}
            if (LastMul- FirstMul)<>0 then Step:= Step+ (LastMul- FirstMul)/(LastPhase- FirstPhase);
            {modifikuju stavajici hodnoty}
          end;{of for f:=}
        end else begin
          standardnidialog('*     U této položky    *|*nelze tuto akci provést*',
            DColor1, DColor2, DColor3, DColor4, DColor5, font, BeruNaVedomi);
        end;
      end;
      3: begin
        {pricitam konstantu}
        if Item in [1, 2, 3, 6] then begin
          for f:= FirstPhase to LastPhase do begin
            with EdAnim^.Phase[f] do begin
              case Item of
                1: if( (Picture+ FirstVal)<= GetArchiveOccupy(ANM_Path+ANM_Name+'.AN1') )then Picture:= Picture+ FirstVal;
                2: X:= X+ FirstVal;
                3: Y:= Y+ FirstVal;
                6: if( (Sample+ FirstVal)<= GetArchiveOccupy(ANM_Path+ANM_Name+'.AN3') )then Sample:= Sample+ FirstVal;
              end; {of case}
            end; {of with}
          end;{of for f:=}
        end else begin
          standardnidialog('* Pricteni konstanty k teto polozce neni mozne! *',
            DColor1, DColor2, DColor3, DColor4, DColor5, font, BeruNaVedomi);
        end;
      end;
      4: if standardnidialog('Opravdu chceš označené fáze vymazat?',
         DColor1, DColor2, DColor3, DColor4, DColor5, font, Ano_Ne)=1 then begin
           OldActPhase:= ActPhase;
           ActPhase:= FirstPhase;
           for f:= FirstPhase to LastPhase do DeletePhase;
           if OldActPhase<= EdAnim^.Header.NumOfPhases then ActPhase:= OldActPhase;
      end;
      5: for f:= FirstPhase to LastPhase do CopyPhase;
      6: for f:= 1 to FirstPhase do begin CopyPhase; Dec(ActPhase); end;
      7: RelativizeCoords;
      8: AbsolutizeCoords;
      end;
    end;

  begin
    FirstPhase:= ActPhase;
    LastPhase:= EdAnim^.Header.NumOfPhases;
    Button:= 1;
    Item:= 1;
    Action:= 1;
  repeat
    mouseswitchoff;                       {uklid mys pro vypis}

    alokujdialog(dial,InfMenu[65].X, InfMenu[65].Y, 132, 194,
                   DColor2, DColor4, DColor5, {pozadi, ramecek, okraj}
                   true,                  {escvenku}
                   true,                  {ramtlac}
                   false,                 {NEpresouvatelny}
                   false, false);         {NEkreslit/NEmazat}

    nastavpocty(dial,6,8,0,2,0);
  {            _nap,_tlac,_check,_radio,_input }
    nastavpocetradio(dial,1,7);
    nastavpocetradio(dial,2,8);

    Str(FirstPhase:5, st5);
    alokujnapis(dial, 1, 100, 2, DColor4, font, st5);
    Str(LastPhase:5, st5);
    alokujnapis(dial, 2, 100, 14, DColor4, font, st5);
    Str(FirstVal:5, st5);
    alokujnapis(dial, 3, 100, 26, DColor4, font, st5);
    Str(LastVal:5, st5);
    alokujnapis(dial, 4, 100, 38, DColor4, font, st5);
    Str(FirstMul:5:2, st5);
    alokujnapis(dial, 5, 100, 50, DColor4, font, st5);
    Str(LastMul:5:2, st5);
    alokujnapis(dial, 6, 100, 62, DColor4, font, st5);
(*    alokujnapis(dial, 7,   0, 86, DColor3, font, '----------------------');
    alokujnapis(dial, 8,   2, 78, DColor3, font, 's čím:');
    alokujnapis(dial, 9,  64, 78, DColor3, font, 'jakou akci:');*)

    alokujtlac(dial, 1,  8,2,   DColor1, DColor3,  font, '(~1)Poč. fáze:');
    alokujtlac(dial, 2,  8,14,   DColor1, DColor3,  font,'(~2)Kon. fáze:');
    alokujtlac(dial, 3,  8,26,   DColor1, DColor3,  font,'(~3)Poč. hod.:');
    alokujtlac(dial, 4,  8,38,   DColor1, DColor3,  font,'(~4)Kon. hod.:');
    alokujtlac(dial, 5,  8,50,   DColor1, DColor3,  font,'(~5)Poč. nás.:');
    alokujtlac(dial, 6,  8,62,   DColor1, DColor3,  font,'(~6)Kon. nás.:');
    alokujtlac(dial, 7,  8,181,   DColor1, DColor3,  font,'~Proveď');
    alokujtlac(dial, 8,  100,181,   DColor1, DColor3,  font,'Zruš');

    alokujradio(dial, 1,1,  20,82,  DColor1, DColor3, font, '~Obrázek');
    alokujradio(dial, 1,2,  20,94,  DColor1, DColor3, font, '~X');
    alokujradio(dial, 1,3,  20,106,  DColor1, DColor3, font, '~Y');
    alokujradio(dial, 1,4,  20,118,  DColor1, DColor3, font, 'ZoomX(~g)');
    alokujradio(dial, 1,5,  20,130,  DColor1, DColor3, font, 'ZoomY(~h)');
    alokujradio(dial, 1,6,  20,142,  DColor1, DColor3, font, '~Sampl');
    alokujradio(dial, 1,7,  20,154,  DColor1, DColor3, font, '~Zdržení');
(*    alokujradio(dial, 2,1,  20,76,  DColor1, DColor3, font, '~load');
    alokujradio(dial, 2,2,  70,76,  DColor1, DColor3, font, '~mul');
    alokujradio(dial, 2,3,  111,76,  DColor1, DColor3, font, '~add');*)
    alokujradio(dial, 2,1,  88,82,  DColor1, DColor3, font, '~load  ');
    alokujradio(dial, 2,2,  88,94,  DColor1, DColor3, font, '~mul   ');
    alokujradio(dial, 2,3,  88,106,  DColor1, DColor3, font, '~add   ');
    alokujradio(dial, 2,4,  88,118,  DColor1, DColor3, font, '~vymaž ');
    alokujradio(dial, 2,5,  88,130,  DColor1, DColor3, font, '~kopie ');
    alokujradio(dial, 2,6,  88,142,  DColor1, DColor3, font, 'k.~fáze');
    alokujradio(dial, 2,7,  88,154,  DColor1, DColor3, font, '~relat.');
    alokujradio(dial, 2,8,  88,166,  DColor1, DColor3, font, 'a~bsol.');

    with dial^ do begin
      {tady, pokud to chci lepe, musim rucne nastavit sirky ramecku, aby to,
       co je pod sebou, melo i shodny ramecek}
      radio[1].text[2]^.dx:=radio[1].text[1]^.dx;
      radio[1].text[3]^.dx:=radio[1].text[1]^.dx;
      radio[1].text[4]^.dx:=radio[1].text[1]^.dx;
      radio[1].text[5]^.dx:=radio[1].text[1]^.dx;
      radio[1].text[6]^.dx:=radio[1].text[1]^.dx;
      radio[1].text[7]^.dx:=radio[1].text[1]^.dx;
      radio[2].text[1]^.dx:=radio[2].text[1]^.dx-3;
(*      radio[2].text[2]^.dx:=radio[2].text[2]^.dx-6;
      radio[2].text[3]^.dx:=radio[2].text[3]^.dx-4;*)
    end;

    alokujpredvoleny(vysl,1,Button,1);
    pocatecniradio(vysl, 1, Item);
    pocatecniradio(vysl, 2, Action);

    nakreslidialog(dial,vysl);
    vyberdialog(dial,vysl);               {on po sobe mys taky uklidi}

    Item:= vysl^.radio[1];
    Action:= vysl^.radio[2];
    ExitCode:=Vysl^.UkAkce;
    Button:= Vysl^.PredvObj;

    if ExitCode =1 then begin
      ExitCode:= 0;
      Button:= 8;
    end;
    {kdyz je Escape, jako kdyby bylo OK, ukoncime}
    if (ExitCode=0)or(ExitCode=2) then begin
      case Button of
        1: begin
             FirstPhase:= ReadIntegerInDialog(100+dial^.x, 2+dial^.y, 1, EdAnim^.Header.NumOfPhases, FirstPhase);
           end;
           {prvni faze bloku (vcetne)}
        2: begin
             LastPhase:= ReadIntegerInDialog(100+dial^.x, 14+dial^.y, 1, EdAnim^.Header.NumOfPhases, LastPhase);
           end;
           {posledni faze bloku (vcetne)}
        3: begin
             FirstVal:= ReadIntegerInDialog(100+dial^.x, 26+dial^.y, -maxint, maxint, FirstVal);
           end;
           {prvni vyplnovana hodnota}
        4: begin
             LastVal:= ReadIntegerInDialog(100+dial^.x, 38+dial^.y, -maxint, maxint, LastVal);
           end;
           {posledni vyplnovana hodnota}
        5: begin
             FirstMul:= ReadRealInDialog(100+dial^.x, 50+dial^.y, FirstMul);
           end;
           {prvni hodnota nasobiciho faktoru}
        6: begin
             LastMul:= ReadRealInDialog(100+dial^.x, 62+dial^.y, LastMul);
           end;
           {posledni hodnota nasobiciho faktoru}
        7: begin
             DoBlockOperation;
           end;
           {proved blokovou operaci}
        8: begin
           end;
           {vyskoc z blokovych operaci}
      end;
    end;
    smazdialog(dial);
    {kvuli zadavani hodnoty, aby pod tim nebylo "prazdno", mazu dialog teprv ted}
    dealokujdialog(dial, vysl);
    {cca to same, kvuli promennym dial^.x a dial^.y}

  until ( (ExitCode=0)or(ExitCode=2) )and(Button=8);

  end;

var
 edh1, edh2: longint;
begin
  edh1:= MaxAvail;
  ActPhase:= 1;
  Button:= 1;
repeat
  if KeyPressed then ReadKey;
  {v pripade, ze byla uz drive stistena klavesa, odstrani klavesu z bufferu klavesnice}
  mouseswitchoff;                       {uklid mys pro vypis}
  Bar(0, 0, InfMenu[60].X, 200, DColor5);
  with EdAnim^.Phase[ActPhase] do begin
    if Picture>1 then begin
      CLoadItem(ANM_Path+ANM_Name+'.AN1', ActPhaseImage, Picture);
      if ZoomX= 0 then ZoomX:= PWordArray(ActPhaseImage)^[0];
      if ZoomY= 0 then ZoomY:= PWordArray(ActPhaseImage)^[1];
      APBarX:= ZoomX;
      APBarY:= ZoomY;
      if APBarX>InfMenu[60].X then APBarX:= InfMenu[60].X;
      if APBarY>200 then APBarY:= 200;
      Bar(0, 0, APBarX, APBarY, 255);
      {Protoze musim pouzivat putovaci rutiny s maskovanim, vytiskl jsem si nejdriv}
      {bar pod obrazek, aby byla zretelna velikost obrazku}
      if Mirror= 0 then PutMaskImagePartZoom(0, 0, ZoomX, ZoomY, 0, 0, InfMenu[60].X, 200, ActPhaseImage)
      else PutMirrorMaskImagePartZoom(0, 0, ZoomX, ZoomY, 0, 0, InfMenu[60].X, 200, ActPhaseImage);
      DisposeImage(ActPhaseImage);
    end;
    Str(Picture: 5, Pict_s);
    Str(X: 5, X_s);
    Str(Y: 5, Y_s);
    Str(ZoomX: 5, ZoomX_s);
    Str(ZoomY: 5, ZoomY_s);
    Str(Sample: 5, Sam_s);
    Str(Frequency: 5, Freq_s);
    Str(Delay: 5, Delay_s);
  end;
  Str(ActPhase: 5, ActPhase_s);
  Str(EdAnim^.Header.NumOfPhases: 5, NumOfPhases_s);

  alokujdialog(dial,InfMenu[60].X, InfMenu[60].Y, 150, 200,
                 DColor2, DColor4, DColor5, {pozadi, ramecek, okraj}
                 true,                  {escvenku}
                 true,                  {ramtlac}
                 false,                 {NEpresouvatelny}
                 true, false);          {kreslit/nemazat}

  nastavpocty(dial,14,26,4,1,0);
{            _nap,_tlac,_check,_radio,_input }
  nastavpocetradio(dial,1,3);

  alokujnapis(dial, 1,  68, 2, DColor4, font, Seq_Name);
  alokujnapis(dial, 2,  6*11, 53, DColor4, font, Pict_s);
  alokujnapis(dial, 3,  6*11, 65, DColor4, font, X_s);
  alokujnapis(dial, 4,  6*11, 77, DColor4, font, Y_s);
  alokujnapis(dial, 5,  6*11, 89, DColor4, font, ZoomX_s);
  alokujnapis(dial, 6,  6*11, 101,DColor4, font, ZoomY_s);
  alokujnapis(dial, 7,  6*11, 113, DColor4, font, Sam_s);
  alokujnapis(dial, 8,  6*11, 125, DColor4, font, Freq_s);
  alokujnapis(dial, 9,  6*11, 137, DColor4, font, Delay_s);
  alokujnapis(dial,10,  0,46,  DColor3,  font,'-------------------------');
  alokujnapis(dial,11,  0,168, DColor3,  font,'-------------------------');
  alokujnapis(dial,12,  114, 161, DColor2, font, NumOfPhases_s);
  alokujnapis(dial,13,  102,53, DColor3, font, 'Animace:');
  alokujnapis(dial,14,  102,137, DColor3, font, '--------');

  alokujtlac(dial, 1,  8,2,   DColor1, DColor3,  font,'~Animace:');
  alokujtlac(dial, 2,  8,53,  DColor1, DColor3,  font,'~Obrázek:');
  alokujtlac(dial, 3,  8,65,  DColor1, DColor3,  font,'~X      :');
  alokujtlac(dial, 4,  8,77,  DColor1, DColor3,  font,'~Y      :');
  alokujtlac(dial, 5,  8,89,  DColor1, DColor3,  font,'ZoomX(~g):');
  alokujtlac(dial, 6,  8,101, DColor1, DColor3,  font,'ZoomY(~h):');
  alokujtlac(dial, 7,  8,113, DColor1, DColor3,  font,'~Sampl  :');
  alokujtlac(dial, 8,  8,125, DColor1, DColor3,  font,'~Frekv. :');
  alokujtlac(dial, 9,  8,137, DColor1, DColor3,  font,'~Zdržení:');
  alokujtlac(dial,10,  8,160, DColor1, DColor3, font, ' souřad. ~myší ');
  alokujtlac(dial,11,  8,175, DColor1, DColor3, font, '~<<');
  alokujtlac(dial,12,  34,175, DColor1, DColor3, font, '<~,');
  alokujtlac(dial,13,  58,175, DColor1, DColor3, font, '~.>');
  alokujtlac(dial,14,  80,175, DColor1, DColor3, font, '>~>');
  alokujtlac(dial,15,  8,187, DColor1, DColor3, font, '~Přidej');
  alokujtlac(dial,16,  58,187, DColor1, DColor3, font, '~Vymaž');
  alokujtlac(dial,17,  108,113, DColor1, DColor3, font, '~R u');
  alokujtlac(dial,18,  108,65, DColor1, DColor3, font, 'Sav~e');
  alokujtlac(dial,19,  108,77, DColor1, DColor3, font, '~*Erase');
  alokujtlac(dial,20,  108,101, DColor1, DColor3, font, 'Cancel');
  alokujtlac(dial,21,  108,89, DColor1, DColor3, font, 'Repor~t');
  alokujtlac(dial,22,  108,187, DColor1, DColor3, font, '~Kopie');
  alokujtlac(dial,23,  108,149, DColor1, DColor3, font, 'Zv~uk..');
  alokujtlac(dial,24,  108,175, DColor1, DColor3, font, '~@'+ActPhase_s);
  alokujtlac(dial,25,  108,125, DColor1, DColor3, font, '~Blok..');
  alokujtlac(dial,26,  138,113, DColor1, DColor3, font, '~n');

  alokujcheck(dial, 1, 20,14,  DColor1, DColor3, font, 'nemazat');
  alokujcheck(dial, 2, 20,26,  DColor1, DColor3, font, 'cyklická');
  alokujcheck(dial, 3, 20,38,  DColor1, DColor3, font, 'relativní');
  alokujcheck(dial, 4, 20,149, DColor1, DColor3, font, '    zrca~dlit');

  alokujradio(dial, 1,1,  6*10+38,14,  DColor1, DColor3, font, 'v paměti');
  alokujradio(dial, 1,2,  6*10+38,26,  DColor1, DColor3, font, 'pam/disk');
  alokujradio(dial, 1,3,  6*10+38,38,  DColor1, DColor3, font, 'z disku');

  with dial^ do begin
    check[1]^.dx:=check[3]^.dx;
    check[2]^.dx:=check[3]^.dx;
    check[4]^.dy:=check[4]^.dy-1;
    radio[1].text[1]^.dx:=radio[1].text[1]^.dx-5;
    radio[1].text[2]^.dx:=radio[1].text[1]^.dx;
    radio[1].text[3]^.dx:=radio[1].text[1]^.dx;
    tlac[5]^.dx:= tlac[4]^.dx;
    tlac[6]^.dx:= tlac[4]^.dx;
    tlac[15]^.dx:= 46;
    tlac[16]^.dx:= 46;
    tlac[12]^.dx:= tlac[12]^.dx-4;
    tlac[13]^.dx:= tlac[13]^.dx-4;
    tlac[21]^.dx:= tlac[21]^.dx-2;
    tlac[17]^.dx:= tlac[21]^.dx-18;
    tlac[22]^.dx:= tlac[21]^.dx;
    tlac[23]^.dx:= tlac[21]^.dx;
    tlac[24]^.dx:= tlac[21]^.dx;
    tlac[25]^.dx:= tlac[21]^.dx;
    tlac[18]^.dx:= tlac[21]^.dx;
    tlac[19]^.dx:= tlac[21]^.dx;
    tlac[20]^.dx:= tlac[21]^.dx;
    tlac[26]^.dx:= tlac[26]^.dx-2;
  end;

  alokujpredvoleny(vysl,1,Button,1);

  with EdAnim^.Header do begin
    pocatecnicheck(vysl, 1, DisableErasing=1);
    pocatecnicheck(vysl, 2, Cyclic=1);
    pocatecnicheck(vysl, 3, Relative=1);
    pocatecniradio(vysl, 1, MemoryLogic+1);
  end;

  pocatecnicheck(vysl, 4, EdAnim^.Phase[ActPhase].Mirror=1 );

  vyberdialog(dial,vysl);               {nakresli se sam, mys po sobe taky uklidi}

  with EdAnim^.Header do begin
    DisableErasing:= byte(vysl^.check[1]);
    Cyclic:= byte(vysl^.check[2]);
    Relative:= byte(vysl^.check[3]);
    MemoryLogic:= vysl^.radio[1]-1;
  end;
  EdAnim^.Phase[ActPhase].Mirror:= byte(vysl^.check[4]);

  ExitCode:=Vysl^.UkAkce;
  Button:= Vysl^.PredvObj;

  if ExitCode= 1 then begin
    Dec(ExitCode);
    Button:= 20;
  end;
  {pokud bylo Escape, upravim ExitCode na OK ukonceni a dam Button= Cancel}

  with EdAnim^.Phase[ActPhase] do begin
    if (ExitCode=0)or(ExitCode=2) then begin
      case Button of
        1: begin
             Seq_Name:= ReadLnInDialog(68+dial^.x, 2, Seq_Name);
           end;
           {nazev animacni sekvence}
        2: begin
             Picture:= ReadIntegerInDialog(66+dial^.x, 53, 0, GetArchiveOccupy(ANM_Path+ANM_Name+'.AN1'), Picture);
             if Picture=1 then Dec(Picture);
           end;
           {cislo obrazku ve storu}
        3: begin
             X:= ReadIntegerInDialog(66+dial^.x, 65, -9999, maxint, X);
           end;
           {x}
        4: begin
             Y:= ReadIntegerInDialog(66+dial^.x, 77, -9999, maxint, Y);
           end;
           {y}
        5: begin
             ZoomX:= ReadIntegerInDialog(66+dial^.x, 89, 0, maxint, ZoomX);
           end;
           {zoom x}
        6: begin
             ZoomY:= ReadIntegerInDialog(66+dial^.x, 101, 0, maxint, ZoomY);
           end;
           {zoom y}
        7: begin
             Sample:= ReadIntegerInDialog(66+dial^.x, 113, 0, GetArchiveOccupy(ANM_Path+ANM_Name+'.AN3'), Sample);
             if Sample=1 then Dec(Sample);
           end;
           {cislo samplu}
        8: begin
             Frequency:= ReadIntegerInDialog(66+dial^.x, 125, 0, maxint, Frequency);
           end;
           {frekvence samplu}
        9: begin
             Delay:= ReadIntegerInDialog(66+dial^.x, 137, 0, maxint, Delay);
           end;
           {zdrzeni}
       10: SetXYByMouse{zadani souradnic sprajtu mysi};
       11: ActPhase:=1{na zacatek sekvence};
       12: if ActPhase>1 then Dec(ActPhase){o jednu fazi zpet};
       13: if ActPhase<EdAnim^.Header.NumOfPhases then Inc(ActPhase){o jednu fazi vpred};
       14: ActPhase:= EdAnim^.Header.NumOfPhases{na konec sekvence};
       15: AddPhase;{pridani faze}
       16: if standardnidialog('Mám tuto fazi vymazat?',
                DColor1, DColor2, DColor3, DColor4, DColor5, font, Ano_Ne)=1 then DeletePhase;
           {vymazani faze}
       17: ActPhase:= PlayEditedAnimation(ActPhase, 1);{spusteni sekvence od zacatku}
       18: begin
             WriteSeq:= true;
             for f:= 1 to GetArchiveOccupy(ANM_Path+ANM_Name+'.AN4')-1 do begin
               CLoadItem(ANM_Path+ANM_Name+'.AN4', pointer(Ptr_Name), f+1);
               if Seq_Name= Ptr_Name^ then begin
                 if standardnidialog('Animace s tímto názvem|již existuje!|'+
                 +'Mám ji přepsat?',
                 DColor1, DColor2, DColor3, DColor4, DColor5, font, Ano_Ne)=1 then begin
                   EraseReadedSeqNameFromStore(f+1);
                   EraseReadedSequenceFromStore(f+1);
                   f:= GetArchiveOccupy(ANM_Path+ANM_Name+'.AN4');
                 end else WriteSeq:= false;
               end;
               FreeMem(Ptr_Name, 13);
               {jmeno sekvence je vzdy 13 byte dlouhe:1 byte delka, 12 byte text}
             end;
             if WriteSeq then begin
               WriteSeqNameToStore;
               WriteSequenceToStore;
             end;
           end;
           {save sekvence}
       19: begin
             if standardnidialog('Opravdu chceš vymazat|(i z disku!)|aktuální animaci?',
             DColor1, DColor2, DColor3, DColor4, DColor5, font, Ano_Ne)=1 then begin
               for f:= 1 to GetArchiveOccupy(ANM_Path+ANM_Name+'.AN4')-1 do begin
                 CLoadItem(ANM_Path+ANM_Name+'.AN4', pointer(Ptr_Name), f+1);
                 if (Seq_Name= Ptr_Name^)and(ActualSequenceNumber=f+1) then begin
                     EraseReadedSeqNameFromStore(f+1);
                     EraseReadedSequenceFromStore(f+1);
                     f:= GetArchiveOccupy(ANM_Path+ANM_Name+'.AN4');
                 end;
                 FreeMem(Ptr_Name, 13);
               end;
                 {jmeno sekvence je vzdy 13 byte dlouhe:1 byte delka, 12 byte text}
             end else Button:= 18;
           end;
           {vymazani editovane sekvence}
       20: begin
             if standardnidialog('Opravdu mám zrušit|editaci aktuální animace?',
             DColor1, DColor2, DColor3, DColor4, DColor5, font, Ano_Ne)=2 then Button:= 18;
           end;
          {zruseni editace}
       21: ComputeMemoryRequirements;
       22: CopyPhase;
           {zvyseni poctu fazi o jednu, kopie aktualni do posledni, posun}
           {aktualni o jednu dopredu}
       23: ConfigSoundDialog;
       24: begin
             ActPhase:= ReadIntegerInDialog(114+dial^.x, 175, 1, EdAnim^.Header.NumOfPhases, ActPhase);
           end;
           {zadani cisla aktualni faze rucne}
       25: BlockOperations;
       26: ActPhase:= PlayEditedAnimation(ActPhase, ActPhase);{spusteni sekvence od akt, faze}
      end;
    end;
  end;

  dealokujdialog(dial, vysl);
  {kvuli zadavanim hodnot teprv ted dealokuju}

until ( (ExitCode=0)or(ExitCode=2) )and(Button>18)and(Button<21);

  ClearScr(0);

  edh2:= MaxAvail;
  if edh1<>edh2 then Write(#7#7);
end;


procedure ReadSequenceFromStore(What: byte);
var
  LoadedAnim: PAnimation;
  f: byte;
begin
  CLoadItem(ANM_Path+ANM_Name+'.AN5', pointer(LoadedAnim), What );
  with EdAnim^.Header do begin
    NumOfPhases:= LoadedAnim^.Header.NumOfPhases;
    MemoryLogic:= LoadedAnim^.Header.MemoryLogic;
    DisableErasing:= LoadedAnim^.Header.DisableErasing;
    Cyclic:= LoadedAnim^.Header.Cyclic;
    Relative:= LoadedAnim^.Header.Relative;
  end;
  for f:= 1 to EdAnim^.Header.NumOfPhases do begin
    with EdAnim^.Phase[f] do begin
      Picture      := LoadedAnim^.Phase[f].Picture;
      X            := LoadedAnim^.Phase[f].X;
      Y            := LoadedAnim^.Phase[f].Y;
      ZoomX        := LoadedAnim^.Phase[f].ZoomX;
      ZoomY        := LoadedAnim^.Phase[f].ZoomY;
      Mirror       := LoadedAnim^.Phase[f].Mirror;
      Sample       := LoadedAnim^.Phase[f].Sample;
      Frequency    := LoadedAnim^.Phase[f].Frequency;
      Delay        := LoadedAnim^.Phase[f].Delay;
    end;
  end;
  FreeMem(LoadedAnim, LengthTAnmPhase*LoadedAnim^.Header.NumOfPhases +LengthTAnmHeader);
end;

procedure NewSequence;
begin
  with EdAnim^.Header do begin
    NumOfPhases:= 1;
    MemoryLogic:= 0;
    DisableErasing:= 0;
    Cyclic:= 0;
    Relative:= 0;
  end;
  with EdAnim^.Phase[1] do begin
    Picture      := 0;
    X            := 0;
    Y            := 0;
    ZoomX        := 0;
    ZoomY        := 0;
    Mirror       := 0;
    Sample       := 0;
    Frequency    := 0;
    Delay        := 0;
  end;
end;

procedure ReadSeqNameFromStore(What: byte);
begin
  CLoadItem(ANM_Path+ANM_Name+'.AN4', pointer(Ptr_Name), What);
  Seq_Name:= Ptr_Name^;
  FreeMem(Ptr_Name, 13);
end;

procedure AnimationMenu;
var
  menutext: string;
  number_of_anm: byte;
  first_anm_in_menu: byte;
  max_anm_lines: byte;
  PgDn, PgUp: boolean;

(*
  procedure SetMenuText;
  var
    f: byte;
  begin
    menutext:= '';
    number_of_anm:= GetArchiveOccupy(ANM_Path+ANM_Name+'.AN4')-1;
    if number_of_anm>0 then begin
      if number_of_anm>13 then number_of_anm:= 13;
      {zredukuju pocet zobrazitelnych animaci v menu na 13}
      for f:= 1 to number_of_anm do begin
        CLoadItem(ANM_Path+ANM_Name+'.AN4', pointer(Ptr_Name), f+1);
        menutext:= menutext+ Ptr_Name^ +'|';
        FreeMem(Ptr_Name, 13);
        {jmeno sekvence je vzdy 13 byte dlouhe:1 byte delka, 12 byte text}
      end;
    end;
    if menutext<> '' then menutext:= menutext+'#-------------------|';
    menutext:= '#     Animace|#-------------------|'+menutext+'~Přidání animace|#-------------------|~Zpět';
{    menutext:= '#     Animace|#-------------------|'+menutext;}
  end;
*)
  procedure SetMenuText;
  var
    f: byte;
  begin
    menutext:= '';
    number_of_anm:= GetArchiveOccupy(ANM_Path+ANM_Name+'.AN4')-1;
    if (number_of_anm-first_anm_in_menu)<8 then max_anm_lines:= (number_of_anm-first_anm_in_menu+1)
    else max_anm_lines:= 8;
    if number_of_anm>0 then begin
      f:= first_anm_in_menu;
      while(f<first_anm_in_menu+8)and(f<=number_of_anm) do begin
        CLoadItem(ANM_Path+ANM_Name+'.AN4', pointer(Ptr_Name), f+1);
        menutext:= menutext+ '~'+Char(f-first_anm_in_menu+65)+' '+Ptr_Name^ +'|';
        FreeMem(Ptr_Name, 13);
        Inc(f);
        {jmeno sekvence je vzdy 13 byte dlouhe:1 byte delka, 12 byte text}
      end;
    end;
    if menutext<> '' then begin
      PgDn:= False;
      PgUp:= False;
      if f<= number_of_anm then begin
        PgDn:= True;
        menutext:= menutext+'> PgDn ~>|';
      end;
      if first_anm_in_menu> 1 then begin
        PgUp:= True;
        menutext:= '~< Pg Up <|'+ menutext;
      end;
      menutext:= menutext+'#-----------------|';
    end;
    menutext:= '#     Animace|#-----------------|'+menutext+'~Přidání animace|#-----------------|~Zpět';
  end;

var
  ah1, ah2: longint;
begin
  PgDn:= false;
  PgUp:= false;
  first_anm_in_menu:= 1;
  max_anm_lines:= 8;
  repeat
    repeat until MouseKey=0;
    SetMenuText;
    InfMenu[58].Volba:= 1;
    InfMenu[58].Volba:=VytvorMenu(menutext,
      DColor1, DColor2, DColor3, DColor4,DColor5, font, InfMenu[58].X, InfMenu[58].Y,
      InfMenu[58].Volba, -1);
      if InfMenu[58].Volba>0 then begin
        if (InfMenu[58].Volba=1)and(PgUp) then Dec(first_anm_in_menu, 8)
          else if (InfMenu[58].Volba=9+byte(PgUp) )and(PgDn) then Inc(first_anm_in_menu, 8)
            else if InfMenu[58].Volba= (max_anm_lines+1+byte(PgUp)+byte(PgDn)) then begin
              Seq_Name:= '<bezejmenná>';
              NewSequence;
              EditSequenceDialog;
              ActualSequenceNumber:= 0;
            end else if (number_of_anm <> 0)and(InfMenu[58].Volba<= (max_anm_lines+byte(PgUp)+byte(PgDn)) )then begin
              ActualSequenceNumber:=first_anm_in_menu+InfMenu[58].Volba-byte(PgUp);
              ReadSeqNameFromStore(first_anm_in_menu+InfMenu[58].Volba-byte(PgUp));
              ReadSequenceFromStore(first_anm_in_menu+InfMenu[58].Volba-byte(PgUp));
              EditSequenceDialog;
              if(first_anm_in_menu>1)and(first_anm_in_menu>GetArchiveOccupy(ANM_Path+ANM_Name+'.AN4')-1) then
                Dec(first_anm_in_menu);
            end;
      end;
    if (InfMenu[58].Volba=-1)then InfMenu[58].Volba:= 2+max_anm_lines+byte(PgUp)+byte(PgDn);
  until (InfMenu[58].Volba= (2+max_anm_lines+byte(PgUp)+byte(PgDn) ) );

end;


procedure WriteMisc;
begin
  CEraseItem(ANM_Path+ANM_Name+'.AN6', 3);
  CEraseItem(ANM_Path+ANM_Name+'.AN6', 2);
  CAddFromMemory(ANM_Path+ANM_Name+'.AN6', @Background_Name, 9);
  CAddFromMemory(ANM_Path+ANM_Name+'.AN6', @Music_Name, 9);
end;

procedure SetBackground;
begin
  ChooseFile(trid_jmena, Background_Path, '*.pcx' );
  if (path<>#27)and(path<>#0)then begin
    Background_Name:= CutNameFromPath(path);
    standardnidialog('Vybráno pozadí|'+Background_Name,
    DColor1, DColor2, DColor3, DColor4, DColor5, font, BeruNaVedomi);
  end;
  WriteMisc;
end;

procedure SetMusic;
begin
  ChooseFile(trid_jmena, Music_Path, '*.mus' );
  if (path<>#27)and(path<>#0)then begin
    Music_Name:= CutNameFromPath(path);
    standardnidialog('Vybrána hudba|'+Music_Name,
    DColor1, DColor2, DColor3, DColor4, DColor5, font, BeruNaVedomi);

  end;
  WriteMisc;

end;



procedure AddPicturesToStore;
var
  hp1, hp2 : longint;
  LoadedPalette: pointer;
  LoadedScreen: pointer;
  ChoosenImage: pointer;
  ax, ay, awidth, aheigth: integer;
  acolor: byte;
  sx,sy,sw,sh,sc: string[3];
  Number: byte;
  NumStr: string[3];
  PictureName: string[12];
  name: string;
  Ext: string[3];

{  PalFile: file;}

  procedure Cleaning;
  begin
    DisposeImage(LoadedScreen);
    FreeMem(LoadedPalette, 768);
    SetPalette(Palette);
  end;

begin
  ChooseFile(trid_jmena, Picture_Path, '*.lbm;*.pcx;*.bmp' );
  if (path=#27)or(path=#0)then exit;
  if LoadImage(LoadedScreen, LoadedPalette, path)= 0 then begin
    standardnidialog('Chyba při čtení souboru:|'+path,
    DColor1, DColor2, DColor3, DColor4, DColor5, font, BeruNaVedomi);
    exit;
  end;

  Number:= 0; {cislo prave prenaseneho obrazku}
  repeat
    hp1:= MaxAvail;
    MouseSwitchOff;
    PutImage(0, 0, LoadedScreen);
    MouseSwitchOn;
    standardnidialog('Klikni mimo obrázek',
    DColor1, DColor2, DColor3, DColor4, DColor5, font, BeruNaVedomi);
    SetPalette(LoadedPalette);


    repeat until MouseKey=1;
    ax:= MouseX;
    ay:= MouseY;
    MouseSwitchOff;
    acolor:= GetPixel(ax, ay);
    MouseSwitchOn;

    repeat until MouseKey=0;
    SetPalette(Palette);
    standardnidialog('Klikni dovnitř obrázku',
    DColor1, DColor2, DColor3, DColor4, DColor5, font, BeruNaVedomi);
    SetPalette(LoadedPalette);
    repeat until MouseKey=1;
    ax:= MouseX;
    ay:= MouseY;
    repeat until MouseKey=0;
    MarkImage(ax, ay, awidth, aheigth, ActivePage, acolor);
    Str(ax:3, sx);
    Str(ay:3, sy);
    Str(awidth:3, sw);
    Str(aheigth:3, sh);
    Str(acolor:3, sc);
    MouseSwitchOff;
    PutImage(0, 0, LoadedScreen);
    SetPalette(Palette);
    MouseSwitchOn;
    if standardnidialog('x:'+sx+'|y:'+sy+'|šířka:'+sw+'|výška:'+sh+'|barva kolem:'+sc+
      +'|Vybrat?', DColor1, DColor2, DColor3, DColor4, DColor5, font, Ano_Ne)= 1 then begin

      if (awidth=0)or(aheigth=0)then begin
        standardnidialog('Výběr proběhl neúspěšně!|Buď je nulová výška nebo šířka!',
        DColor1, DColor2, DColor3, DColor4, DColor5, font, BeruNaVedomi);
      end else begin
        if Number=0 then begin
          name:= ReadText(InfMenu[57].X, InfMenu[57].Y, 200, 'Jméno prvního z obrázků:','');
          if name[1]= #27 then begin
            Cleaning;
            Exit;
          end;
          if Length(name)>10 then byte(name[0]):= 10;
        end;
        Str(Number: 2, NumStr);
        PictureName:= name+ '.'+ NumStr;
        CAddFromMemory(ANM_Path+ANM_Name+'.AN0', @PictureName, 13);

        MouseSwitchOff;

        NewImage(awidth, aheigth, ChoosenImage);
        GetImage(ax, ay, awidth, aheigth, ChoosenImage);
        CAddFromMemory(ANM_Path+ANM_Name+'.AN1', ChoosenImage, awidth*aheigth+4 );
        DisposeImage(ChoosenImage);

        Inc(Number);
      end;
    end;
    if hp1<>MaxAvail then write(#7);
  until standardnidialog('Vybrat další?',
  DColor1, DColor2, DColor3, DColor4, DColor5, font, Ano_Ne)= 2;

  MouseSwitchOn;
  Cleaning;

end;

procedure AddSamplesToStore;
var
  SampleName: string[12];
  StoreNumber: string[5];
  SampleData: pointer;
  SampleSize: word;
  SampleFile: file;
  Header: array[0..3]of char;
  procedure ModSample;
  var
    f: word;
  begin
  {jinak budu povazovat sampl za znamenkove rozsireny sampl z MODU}
    SampleSize:= word(FileSize(SampleFile));
    GetMem(SampleData, SampleSize);
    Seek(SampleFile, 0);
    BlockRead(SampleFile, SampleData^, SampleSize);
    for f := 0 to SampleSize-1 do begin
       PByteArray(SampleData)^[f] := ( PByteArray(SampleData)^[f] XOR 128);
    end;
  end;
begin
  ChooseFile(trid_jmena, Sample_Path, '*.sam;*.wav;*.naw;*.   ' );
  if (path=#27)or(path=#0)then exit;
  SampleName:= CutNameFromPath(path);
  CAddFromMemory(ANM_Path+ANM_Name+'.AN2', @SampleName, 13);

  Assign(SampleFile, path);
  Reset(SampleFile, 1);
  if FileSize(SampleFile)> 44 then begin
    {pokud je delka fajlu aspon takova, muzu overit, esli se nejedna o WAV }
    Seek(SampleFile, 8);
    BlockRead(SampleFile, Header[0], 4);
    if (Header[0]='W')and(Header[1]='A')and(Header[2]='V')and(Header[3]='E')then begin
      {pokud je hlavicka od 8. pozice "WAVE", jde o WAV}
      SampleSize:= word(FileSize(SampleFile) - 44);
      GetMem(SampleData, SampleSize);
      Seek(SampleFile, 44);
      BlockRead(SampleFile, SampleData^, SampleSize);
    end else if FileSize(SampleFile)> 80 then begin
      {pokud je delka fajlu aspon takova, muzu overit, esli se nejedna o DigiPlay }
      Seek(SampleFile, $4c);
      BlockRead(SampleFile, Header[0], 4);
      if (Header[0]='S')and(Header[1]='C')and(Header[2]='R')and(Header[3]='S')then begin
        {pokud je hlavicka od 8. pozice "SCRS", jde o DigiPlay}
        SampleSize:= word(FileSize(SampleFile) - 80);
        GetMem(SampleData, SampleSize);
        Seek(SampleFile, 80);
        BlockRead(SampleFile, SampleData^, SampleSize);
      end else
        {jinak budu povazovat sampl za znamenkove rozsireny sampl z MODU}
        ModSample

    end else
     {jinak budu povazovat sampl za znamenkove rozsireny sampl z MODU}
     ModSample

  end else begin
   {jinak budu povazovat sampl za znamenkove rozsireny sampl z MODU}
   ModSample;
  end;
  Close(SampleFile);

  CAddFromMemory(ANM_Path+ANM_Name+'.AN3', SampleData, SampleSize);
  FreeMem(SampleData, SampleSize);

{  Str(GetArchiveOccupy(ANM_Path+ANM_Name+'.AN3'):5, StoreNumber);
  standardnidialog('Byl vybran sampl:|'+SampleName+'|a pod cislem '+
   +StoreNumber+'|byl ulozen do skladu samplu.',
  DColor1, DColor2, DColor3, DColor4, DColor5, font, BeruNaVedomi);}

end;

procedure LookPicturesDialog;
var
  hp1, hp2: longint;
  dial:pdialog;
  vysl:pstav;
  ExitCode, Button: byte;

  Picture_Name: string[12];
  PackedLength_s, Length_s, ActPicture_s, NumOfPictures_s: string[5];

  ActPicture: byte;

  ActPictureImage: pointer;
  APBarX, APBarY: word;

  procedure DeleteActPicture;

    procedure AdjustSequences;
    var
      ActSequence: byte;
      f: byte;
    begin
      if GetArchiveOccupy(ANM_Path+ANM_Name+'.AN5')< 2 then exit;
      for ActSequence:= 2 to GetArchiveOccupy(ANM_Path+ANM_Name+'.AN5') do begin
        ReadSeqNameFromStore(2);
        ReadSequenceFromStore(2);
        for f:= 1 to EdAnim^.Header.NumOfPhases do with EdAnim^.Phase[f] do begin
          if EdAnim^.Phase[f].Picture= ActPicture then EdAnim^.Phase[f].Picture:= 0;
          if EdAnim^.Phase[f].Picture> ActPicture then Dec(EdAnim^.Phase[f].Picture);
        end;

        EraseReadedSeqNameFromStore(2);
        EraseReadedSequenceFromStore(2);
        WriteSeqNameToStore;
        WriteSequenceToStore;
      end;
    end;

  begin
    CEraseItem(ANM_Path+ANM_Name+'.AN1', ActPicture);
    CEraseItem(ANM_Path+ANM_Name+'.AN0', ActPicture);
    AdjustSequences;
    if ActPicture> GetArchiveOccupy(ANM_Path+ANM_Name+'.AN1')then ActPicture:= GetArchiveOccupy(ANM_Path+ANM_Name+'.AN1');
  end;


begin
  ActPicture:= 2;
  Button:= 1;
repeat
  hp1:= MaxAvail;

  mouseswitchoff;                       {uklid mys pro vypis}
  ClearScr(0);
  if GetArchiveOccupy(ANM_Path+ANM_Name+'.AN1')< 2 then exit;

  CLoadItem(ANM_Path+ANM_Name+'.AN1', ActPictureImage, ActPicture);

  APBarX:= PWordArray(ActPictureImage)^[0];
  APBarY:= PWordArray(ActPictureImage)^[1];
  if APBarX>320 then APBarX:= 320;
  if APBarY>200 then APBarY:= 200;
  Bar(0, 0, APBarX, APBarY, 255);
{Protoze musim pouzivat putovaci rutiny s maskovanim, vytiskl jsem si nejdriv}
{bar pod obrazek, aby byla zretelna velikost obrazku}
  PutMaskImagePart(0, 0, 0, 0, 320, 200, ActPictureImage);
  DisposeImage(ActPictureImage);

  Str(GetArchiveOccupy(ANM_Path+ANM_Name+'.AN1'): 5, NumOfPictures_s);
  Str(UnpackedItemSize(ANM_Path+ANM_Name+'.AN1', ActPicture): 5, Length_s);
  Str(PackedItemSize(ANM_Path+ANM_Name+'.AN1', ActPicture): 5, PackedLength_s);
  Str(ActPicture: 5, ActPicture_s);

  CLoadItem(ANM_Path+ANM_Name+'.AN0', pointer(Ptr_Name), ActPicture);
  Picture_Name:= Ptr_Name^;
  FreeMem(Ptr_Name, 13);

{  Picture_Name:='xx';}

  hp2:= MaxAvail;

  alokujdialog(dial, InfMenu[62].X, InfMenu[62].Y , 112, 76,
                 DColor2, DColor4, DColor5, {pozadi, ramecek, okraj}
                 false,                 {escvenku}
                 true,                  {ramtlac}
                 true,                 {presouvatelny}
                 true, false);          {kreslit/nemazat}


  nastavpocty(dial,8,6,0,0,0);
{            _nap,_tlac,_check,_radio,_input }
  {pouze nastavi pocty do alokovaneho dialogu}

  alokujpredvoleny(vysl,1,Button,1);

  alokujnapis(dial, 1,  2, 2, DColor1, font, 'Jméno:');
  alokujnapis(dial, 2, 38, 2, DColor4, font, Picture_Name);
  alokujnapis(dial, 3,  2, 14, DColor4, font, ActPicture_s);
  alokujnapis(dial, 4,  2, 26, DColor2, font, NumOfPictures_s);
  alokujnapis(dial, 5,  2, 50, DColor2, font, 'Délka    :');
  alokujnapis(dial, 6,  68, 50, DColor1, font, Length_s);
  alokujnapis(dial, 7,  2, 62, DColor2, font, 'Zpakované:');
  alokujnapis(dial, 8,  68, 62, DColor1, font, PackedLength_s);

  alokujtlac(dial, 1,  8, 38, DColor1, DColor3, font, '~<<');
  alokujtlac(dial, 2,  40,38, DColor1, DColor3, font, '<~,');
  alokujtlac(dial, 3,  66,38, DColor1, DColor3, font, '~.>');
  alokujtlac(dial, 4,  92,38, DColor1, DColor3, font, '>~>');
  alokujtlac(dial, 5,  74,26, DColor1, DColor3, font, '~Vymaž');
  alokujtlac(dial, 6,  74,14, DColor1, DColor3, font, '~Zpět ');

  with dial^ do begin
    {tady, pokud to chci lepe, musim rucne nastavit sirky ramecku, aby to,
     co je pod sebou, melo i shodny ramecek}
  end;


  vyberdialog(dial,vysl);               {on po sobe mys taky uklidi}

  InfMenu[62].X:= Dial^.X;
  InfMenu[62].Y:= Dial^.Y;

  ExitCode:=Vysl^.UkAkce;
  Button:= Vysl^.PredvObj;

  if ExitCode=1 then begin
    Dec(ExitCode);
    Button:= 6;
  end;
  {upravim hodnoty v pripade Escape}

  dealokujdialog(dial, vysl);
  if hp2<>MaxAvail then write(#7);

  if (ExitCode=0)or(ExitCode=2) then begin
    case Button of
     1: ActPicture:= 2{na zacatek skladu obrazku};
     2: if ActPicture> 2 then Dec(ActPicture){o jeden obr. zpet};
     3: if ActPicture< GetArchiveOccupy(ANM_Path+ANM_Name+'.AN1') then Inc(ActPicture){o jeden obr. vpred};
     4: ActPicture:= GetArchiveOccupy(ANM_Path+ANM_Name+'.AN1'){posledni obrazek ve skladu};
     5: if standardnidialog('Mám tento obrázek vymazat?',
        DColor1, DColor2, DColor3, DColor4, DColor5, font, Ano_Ne)=1 then DeleteActPicture;
        {vymazani aktualniho obr. ze skladu, prekopani sekvenci}
     6: {ukonceni prohlizeni skladu, navrat do menu nahoru};
    end;
  end;

{  smazdialog(dial);}

  if hp1<>MaxAvail then write(#7);
until ( (ExitCode=0)or(ExitCode=2) )and(Button=6);

  ClearScr(0);
end;


procedure PicturesMenu;
begin
  InfMenu[54].Volba:= 1;
  repeat
    repeat until MouseKey=0;

    InfMenu[54].Volba:=VytvorMenu('#     Obrázky|#-------------------'+
      +'|~Přidání do skladu|Prohlížení ~skladu|#-------------------'+
      +'|~Zpět',
      DColor1, DColor2, DColor3, DColor4,DColor5, font, InfMenu[54].X, InfMenu[54].Y,
      InfMenu[54].Volba, -1);
    case InfMenu[54].Volba of
      1 : AddPicturesToStore;
      2 : LookPicturesDialog;
    end;
    if (InfMenu[54].Volba=-1)then InfMenu[54].Volba:= 3;
  until (InfMenu[54].Volba= 3);
end;

procedure LookSamplesDialog;
var
  dial:pdialog;
  vysl:pstav;
  ExitCode, Button: byte;

  Sample_Name: string[12];
  SamFreq_s, PackedLength_s, Length_s, ActSample_s, NumOfSamples_s: string[5];

  SamFreq: integer;
  ActSample: byte;

  ActSampleData: pointer;
  APBarX, APBarY: word;

  procedure DeleteActSample;

    procedure AdjustSequences;
    var
      ActSequence: byte;
      f: byte;
    begin
      if GetArchiveOccupy(ANM_Path+ANM_Name+'.AN5')< 2 then exit;
      for ActSequence:= 2 to GetArchiveOccupy(ANM_Path+ANM_Name+'.AN5') do begin
        ReadSeqNameFromStore(2);
        ReadSequenceFromStore(2);
        for f:= 1 to EdAnim^.Header.NumOfPhases do with EdAnim^.Phase[f] do begin
          if EdAnim^.Phase[f].Sample= ActSample then EdAnim^.Phase[f].Sample:= 0;
          if EdAnim^.Phase[f].Sample> ActSample then Dec(EdAnim^.Phase[f].Sample);
        end;

        EraseReadedSeqNameFromStore(2);
        EraseReadedSequenceFromStore(2);
        WriteSeqNameToStore;
        WriteSequenceToStore;
      end;
    end;

  begin
    CEraseItem(ANM_Path+ANM_Name+'.AN3', ActSample);
    CEraseItem(ANM_Path+ANM_Name+'.AN2', ActSample);
    AdjustSequences;
    if ActSample> GetArchiveOccupy(ANM_Path+ANM_Name+'.AN3')then ActSample:= GetArchiveOccupy(ANM_Path+ANM_Name+'.AN3');
  end;


begin
  SamFreq:= 8000;
  ActSample:= 2;
  Button:= 1;
  ClearScr(0);
repeat
  mouseswitchoff;                       {uklid mys pro vypis}
  if GetArchiveOccupy(ANM_Path+ANM_Name+'.AN3')< 2 then exit;

  Str(GetArchiveOccupy(ANM_Path+ANM_Name+'.AN3'): 5, NumOfSamples_s);
  Str(UnpackedItemSize(ANM_Path+ANM_Name+'.AN3', ActSample): 5, Length_s);
  Str(PackedItemSize(ANM_Path+ANM_Name+'.AN3', ActSample): 5, PackedLength_s);
  Str(ActSample: 5, ActSample_s);
  Str(SamFreq: 5, SamFreq_s);
  CLoadItem(ANM_Path+ANM_Name+'.AN2', pointer(Ptr_Name), ActSample);
  Sample_Name:= Ptr_Name^;
  FreeMem(Ptr_Name, 13);

  alokujdialog(dial, InfMenu[63].X, InfMenu[63].Y , 112, 100,
                 DColor2, DColor4, DColor5, {pozadi, ramecek, okraj}
                 false,                 {escvenku}
                 true,                  {ramtlac}
                 false,                 {NEpresouvatelny}
                 true, false);         {kreslit/nemazat}


  nastavpocty(dial,9,8,0,0,0);
{            _nap,_tlac,_check,_radio,_input }
  {pouze nastavi pocty do alokovaneho dialogu}

  alokujnapis(dial, 1,  2, 2, DColor1, font, 'Jméno:');
  alokujnapis(dial, 2, 38, 2, DColor4, font, Sample_Name);
  alokujnapis(dial, 3,  2, 14, DColor4, font, ActSample_s);
  alokujnapis(dial, 4,  2, 26, DColor2, font, NumOfSamples_s);
  alokujnapis(dial, 5,  2, 50, DColor2, font, 'Délka    :');
  alokujnapis(dial, 6,  68, 50, DColor1, font, Length_s);
  alokujnapis(dial, 7,  2, 62, DColor2, font, 'Zpakované:');
  alokujnapis(dial, 8,  68, 62, DColor1, font, PackedLength_s);
  alokujnapis(dial, 9,  78, 86, DColor1, font, SamFreq_s);

  alokujtlac(dial, 1,  8, 38, DColor1, DColor3, font, '~<<');
  alokujtlac(dial, 2,  40,38, DColor1, DColor3, font, '<~,');
  alokujtlac(dial, 3,  66,38, DColor1, DColor3, font, '~.>');
  alokujtlac(dial, 4,  92,38, DColor1, DColor3, font, '>~>');
  alokujtlac(dial, 5,  74,26, DColor1, DColor3, font, '~Vymaž');
  alokujtlac(dial, 6,  74,14, DColor1, DColor3, font, '~Zpět ');
  alokujtlac(dial, 7,  8, 86, DColor1, DColor3, font, '~Frekvence:');
  alokujtlac(dial, 8,  8, 74, DColor1, DColor3, font, '~Play!');

  with dial^ do begin
    {tady, pokud to chci lepe, musim rucne nastavit sirky ramecku, aby to,
     co je pod sebou, melo i shodny ramecek}
  end;

  alokujpredvoleny(vysl,1,Button,1);

  vyberdialog(dial,vysl);               {on po sobe mys taky uklidi}

  ExitCode:=Vysl^.UkAkce;
  Button:= Vysl^.PredvObj;

  if ExitCode=1 then begin
    Dec(ExitCode);
    Button:= 6;
  end;
  {upravim hodnoty v pripade Escape}

  if (ExitCode=0)or(ExitCode=2) then begin
    case Button of
     1: ActSample:= 2{na zacatek skladu samplu};
     2: if ActSample> 2 then Dec(ActSample){o jeden sampl. zpet};
     3: if ActSample< GetArchiveOccupy(ANM_Path+ANM_Name+'.AN3') then Inc(ActSample){o jeden sampl vpred};
     4: ActSample:= GetArchiveOccupy(ANM_Path+ANM_Name+'.AN3'){posledni sampl ve skladu};
     5: if standardnidialog('Mám tento obrázek vymazat?',
        DColor1, DColor2, DColor3, DColor4, DColor5, font, Ano_Ne)=1 then DeleteActSample;
        {vymazani aktualniho samplu ze skladu, prekopani sekvenci}
     6: {ukonceni prohlizeni skladu, navrat do menu nahoru};
     7: begin
          SamFreq:= ReadIntegerInDialog(78+dial^.x, 86+dial^.y, 1, maxint, SamFreq);
        end;
        {nastaveni frekvence, jakou ma mit sampl pri prehravani}
     8: begin
          CLoadItem(ANM_Path+ANM_Name+'.AN3', ActSampleData, ActSample);
          SoundSetOutDevice(AO_SoundDevice);
        { Nastavim vystupni zarizeni }
          ComputeFrequency(AO_Freq08);
          SetFrequency(AO_Freq08);
          SoundSetOutDevice(AO_SoundDevice);
        { Nastavim vystupni zarizeni }
        { Inicializuju osmicku s prehravacem samplu a hudby }
          SoundInitPlay;
          Sound_Channels^.i[0].ChVolume:= 51;
          Sound_Channels^.i[0].SizeCh:= UnpackedItemSize(ANM_Path+ANM_Name+'.AN3', ActSample);
          Sound_Channels^.i[0].ChLoop:= 0;
          Sound_Channels^.i[0].ChLooped:= 0;
          Sound_Channels^.i[0].ChLenLp:= 0;

          Sound_Channels^.i[0].Krok:=  Hi(word   (round  (256* (SamFreq/AO_Freq08) )  )   );
          Sound_Channels^.i[0].OvrLd:= Lo(word   (round  (256* (SamFreq/AO_Freq08) )  )   );

          Sound_Channels^.i[0].ChOfs:= Ofs(ActSampleData^);
          Sound_Channels^.i[0].ChActPos:= Ofs(ActSampleData^);
          Sound_Channels^.i[0].ChSeg:= Seg(ActSampleData^);

          MouseSwitchOn;
          repeat until (Sound_Channels^.i[0].ChSeg=0)or(MouseKey<>0);
          MouseSwitchOff;
          SoundDonePlay;
          FreeMem(ActSampleData, UnpackedItemSize(ANM_Path+ANM_Name+'.AN3', ActSample) );
        end;

    end;
  end;

{  smazdialog(dial);}
  dealokujdialog(dial, vysl);

until ( (ExitCode=0)or(ExitCode=2) )and(Button=6);

  ClearScr(0);
end;

procedure SamplesMenu;
begin
  repeat
    repeat until MouseKey=0;
    InfMenu[56].Volba:=VytvorMenu('#     Samply|#-------------------'+
      +'|~Přidání do skladu|Prohlížení ~skladu|#-------------------'+
      +'|~Zpět',
      DColor1, DColor2, DColor3, DColor4,DColor5, font, InfMenu[56].X, InfMenu[56].Y,
      InfMenu[56].Volba, -1);
    case InfMenu[56].Volba of
      1 : AddSamplesToStore;
      2 : LookSamplesDialog;
    end;
    if (InfMenu[56].Volba=-1)then InfMenu[56].Volba:= 3;
  until (InfMenu[56].Volba= 3);
end;




procedure EditObjectMenu;
begin
  repeat
    repeat until MouseKey=0;
    AdjustANMName;
    InfMenu[55].Volba:=VytvorMenu('#Editace animačního|#objektu : '+
      +ReportANM_Name+ '|#------------------|'+
      +'~Obrázky|~Samply|~Pozadí: '+Background_Name+'|~Hudba : '+Music_Name+
      +'|Vymaž pozadí|Vymaž hudbu|#------------------|'+
      +'~Animace...|#------------------|~Zpět',
      DColor1, DColor2, DColor3, DColor4,DColor5, font, InfMenu[55].X, InfMenu[55].Y,
      InfMenu[55].Volba, -1);
    case InfMenu[55].Volba of
      1 : PicturesMenu;
      2 : SamplesMenu;
      3 : SetBackground;
      4 : SetMusic;
      5 : begin
            Background_Name:= '';
            WriteMisc;
          end;
      6 : begin
            Music_Name:= '';
            WriteMisc;
          end;
      7 : AnimationMenu;
    end;
{    if (InfMenu[50].Volba= 8)then Konec;
}    if (InfMenu[55].Volba=-1)then InfMenu[55].Volba:= 8;
  until (InfMenu[55].Volba= 8);
end;


procedure EraseObjectDialog;
begin
  if FileExist(ANM_Path+ANM_Name+'.AN0')then begin
    if( standardnidialog('Opravdu mám soubory|s aktuálním animačním objektem|'+ANM_Name+'|smazat z disku?!?',
    DColor1, DColor2, DColor3, DColor4, DColor5, font, Ano_Ne) )=2 then exit;
    EraseAllArchives;
  end else begin
    AdjustANMName;
    standardnidialog('Aktuální animační objekt|'+ReportANM_Name+'|na disku zatím uložen není,|'+
     +'takže ho z disku nemůžu ani vymazat!',
    DColor1, DColor2, DColor3, DColor4, DColor5, font, BeruNaVedomi);
  end;
  ANM_Name:='';
end;

function RewriteObjectDialog: boolean;
var
  name: string;
  AnoNe : integer;
begin
  RewriteObjectDialog:= True;
  repeat
    name:= ANM_Name;
    repeat
      name:= ReadText(InfMenu[53].X, InfMenu[53].Y, 200, 'Zadej jméno animačního objektu:',ANM_Name);
      if name[1]=#27 then begin
          RewriteObjectDialog:= False;
          Exit;
      end;
    until (name<>'')and(Length(name)<=8);

    if FileExist(ANM_Path+name+'.AN0')then begin
      if( standardnidialog('Soubor již existuje|Mám ho přepsat?',
      DColor1, DColor2, DColor3, DColor4, DColor5, font, Ano_Ne) )=1 then begin
        ANM_Name:= name;
        EraseAllArchives;
        RewriteAllArchives;
        Exit;
      end;
    end else begin
      ANM_Name:= name;
      RewriteAllArchives;
      Exit;
    end;
  until False;
end;


procedure ConfigMenu;
  procedure ChoosePath(PreviousPath: string);
  begin
    Path:=vybersouboru(InfMenu[52].X,InfMenu[52].Y,InfMenu[52].Pocet,
      DColor1, DColor2, DColor3, DColor4, DColor5, Font,
      trid_jmena,PreviousPath,'');
  end;

begin
  InfMenu[51].Volba:= 1;
  repeat
    repeat until MouseKey=0;
    InfMenu[51].Volba:=VytvorMenu('#   Konfigurace   |#------------------|'+
      +'Cesta ~obrázků|Cesta sa~mplů|Cesta ~ANM|Cesta ~pozadí|Cesta ~hudby|'+
      +'Nastavení zv~uku|#------------------|'+
      +'~Load konfigurace|~Save konfigurace|#------------------|~Zpět',
      DColor1, DColor2, DColor3, DColor4,DColor5, font, InfMenu[51].X, InfMenu[51].Y,
      InfMenu[51].Volba, -1);
    case InfMenu[51].Volba of
      1 : begin
            ChoosePath(Picture_Path);
            if (path<>#27)and(path<>#0) then Picture_Path:= path;
          end;
      2 : begin
            ChoosePath(Sample_Path);
            if (path<>#27)and(path<>#0) then Sample_Path:= path;
          end;
      3 : begin
            ChoosePath(ANM_Path);
            if (path<>#27)and(path<>#0) then ANM_Path:= path;
          end;
      4 : begin
            ChoosePath(Background_Path);
            if (path<>#27)and(path<>#0) then Background_Path:= path;
          end;
      5 : begin
            ChoosePath(Music_Path);
            if (path<>#27)and(path<>#0) then Music_Path:= path;
          end;
      6 : ConfigSoundDialog;
      7 : LoadCFG;
      8 : SaveCFG;
    end;
    if(InfMenu[51].Volba= -1) then InfMenu[51].Volba:= 9;
  until (InfMenu[51].Volba= 9);

end;


function LoadObjectListing: boolean;
begin
  LoadObjectListing:= False;
  ChooseFile(trid_jmena, ANM_Path, '*.an0');
  if path= #27 then exit;
  if path= #0 then begin
    standardnidialog('Chyba #0 generovaná funkcí|VyberSouboru',
       DColor1, DColor2, DColor3, DColor4, DColor5, font, BeruNaVedomi);
       Exit;
  end;
(*  standardnidialog('Vybralo|'+path+'|jmeno:'+CutNameFromPath(path),
       DColor1, DColor2, DColor3, DColor4, DColor5, font, BeruNaVedomi);
*)
  ANM_Name:= CutNameFromPath(path);
  AssignAllArchives;
  CLoadItem(ANM_Path+ANM_Name+'.AN6', pointer(Ptr_Name), 2);
  Background_Name:= Ptr_Name^;
  FreeMem(Ptr_Name, 9);
  CLoadItem(ANM_Path+ANM_Name+'.AN6', pointer(Ptr_Name), 3);
  Music_Name:= Ptr_Name^;
  FreeMem(Ptr_Name, 9);
  LoadObjectListing:= True;
end;

procedure MainMenu;
var
  Quit: boolean;

  function Autori:string;
  {vraci seznam jmen autoru usporadany nahodne s pravdepodobnosti podle jejich
   zasluh (misto vepredu je prestiznejsi) takto :
     'Robert Spalek|Lukas Svoboda|Pavel Pospisil|Petr Kroca'}
    const
      zasluhy: array[1..4] of real= {R,L,Pa,Pe}
          (0.22,0.22,0.50,0.06);
      {timto se rozdeli interval <0,1) na 4 casti :
       bude se generovat nahodne cislo <0,1) s rovnomernym rozdelenim
       a pocitat, kam to 'cislo' spadne; udela se to postupne od nejpres-
       riznejsiho mista po nejmene prestizni misto s tim, ze to,
       'co uz slo', se nebude opakovat dvakrat (v tom pripade se opakuje
       pokus)}
      jmena: array[1..4]of string[20] =
            ('Robert Špalek','Lukáš Svoboda','Pavel Pospíšil','Petr Kroča');
    var
      pole: array[1..4,1..4]of integer;
      {1..4 lide; 1..4 pocet umisteni na x-tem miste
       pro kontrolu rozdeleni}
      x, y: byte;

      cislo: real;
      i, j: byte;
      ret: string[80];
      slo: array[1..4]of boolean;
  begin
    randomize;
  {ne, to se pak spatne generuje, chyba bp7 (nevim proc)}
    fillchar(slo,4,0);
    ret:='';
    for i:=1 to 4 do begin
      repeat
        cislo:=random;
        j:=1;
        while (j<5)and(cislo>=zasluhy[j]) do begin
          cislo:=cislo-zasluhy[j];
          inc(j)
        end
      until (j<>5)and(not slo[j]);
      {j<>5 je jiste, ale co kdyby, pro ladeni tam muze byt}
      slo[j]:=true;
      ret:=ret+jmena[j]+'|';
      inc(pole[j,i])
      {zvysi pocet umisteni v poli umisteni pro daneho autora}
    end;
    dec(ret[0]);
    autori:=ret
  end;

  procedure About;
  begin
    vybermoznost(
    'AOMAKER '+ProgVersion+'|Editor animačních objektů|naprogramovali:|'+Autori+
    '|(c) NoSense 1994, 1995 AD|...no lefts reversed...',
    '~Klaním se před nimi',
    DColor1, DColor2, DColor3, DColor4, DColor5, font, 1,1);
(*    vybermoznost(
    'AOMAKER V0.8 beta|Editor animačních objektů|*** Autor ***|Pavel Pospíšil||**   Spoluautoři   **|** (podle abecedy) **|'+
    'Petr Kroča|Lukáš Svoboda|Robert Špalek||MoveLeft (m) 1994AD|no lefts reversed',
    '~Klaním se před nimi',
    DColor1, DColor2, DColor3, DColor4, DColor5, font, 1,1);
*)
  end;

  procedure Konec;
  var AnoNe : integer;
  begin
    AnoNe:=standardnidialog('Opravdu chceš skončit?',
    DColor1, DColor2, DColor3, DColor4, DColor5, font, Ano_Ne);
    if AnoNe=1 then Quit:=true else Quit:=false;
  end;
begin
  Quit:= false;
  repeat
    repeat until MouseKey=0;
    AdjustANMName;
    InfMenu[50].Volba:=VytvorMenu('#AOMAKER - sestavovač|# animačních objektů |'+
      +'#--------------------|~Aktuální: '+ReportANM_Name+ '|#--------------------|'+
      +'~Založ objekt|~Načti objekt|~Vymaž z disku|#--------------------|'+
      +'Kon~figurace|#--------------------|~O programu|~Konec',
      DColor1, DColor2, DColor3, DColor4,DColor5, font, InfMenu[50].X, InfMenu[50].Y,
      InfMenu[50].Volba, -1);
    case InfMenu[50].Volba of
      1 : if ANM_Name<> '' then EditObjectMenu else if LoadObjectListing then EditObjectMenu;
      2 : if RewriteObjectDialog then EditObjectMenu;
      3 : if LoadObjectListing then EditObjectMenu;
      4 : EraseObjectDialog;
      5 : ConfigMenu;
      6 : About;
      7 : Konec;
    end;
    if (InfMenu[50].Volba=-1)then InfMenu[50].Volba:= 7;
  until {True}Quit;
end;

var StartMem: LongInt;

begin
  InfMenu[50].X:=50;  { aomaker; MainMenu}
  InfMenu[50].Y:=20;
  InfMenu[50].Volba:=1;
  InfMenu[51].X:=50;  { aomaker; ConfigMenu}
  InfMenu[51].Y:=20;
  InfMenu[51].Volba:=1;
  InfMenu[52].X:=30;  { aomaker; ConfigMenu, ChoosePath; ChooseFile }
  InfMenu[52].Y:=20;
  InfMenu[52].Pocet:=15;
  InfMenu[53].X:=10;  { aomaker; RewriteObjectDialog }
  InfMenu[53].Y:=20;
  InfMenu[53].Volba:=1;
  InfMenu[54].X:=50;  { aomaker; EditObjectMenu, PicturesMenu}
  InfMenu[54].Y:=20;
  InfMenu[54].Volba:=1;
  InfMenu[55].X:=50;  { aomaker; EditObjectMenu}
  InfMenu[55].Y:=20;
  InfMenu[55].Volba:=1;
  InfMenu[56].X:=50;  { aomaker; EditObjectMenu, SamplesMenu}
  InfMenu[56].Y:=20;
  InfMenu[56].Volba:=1;
  InfMenu[57].X:=10;  { aomaker; AddPicturesToStore}
  InfMenu[57].Y:=20;
  InfMenu[57].Volba:=1;
  InfMenu[58].X:=20;   { aomaker; AnimationMenu}
  InfMenu[58].Y:=0;
  InfMenu[58].Volba:=1;
  InfMenu[59].X:=10;  { aomaker; ReadLnSeqName}
  InfMenu[59].Y:=20;
  InfMenu[59].Volba:=1;
  InfMenu[60].X:=170; { aomaker; EditSequenceDialog}
  InfMenu[60].Y:=0;
  InfMenu[60].Volba:=1;
  InfMenu[61].X:=170+20; { aomaker; EditSequenceDialog, AddPhase}
  InfMenu[61].Y:=165;
  InfMenu[61].Volba:=1;
  InfMenu[62].X:=100;  { aomaker; LookPicturesDialog}
  InfMenu[62].Y:=100;
  InfMenu[62].Volba:=1;
  InfMenu[63].X:=100;  { aomaker; LookSamplesDialog}
  InfMenu[63].Y:=70;
  InfMenu[63].Volba:=1;
  InfMenu[64].X:=90;   { aomaker; ConfigSoundDialog}
  InfMenu[64].Y:=50;
  InfMenu[64].Volba:=1;
  InfMenu[65].X:=44; { aomaker; EditSequenceDialog, BlockOperations}
  InfMenu[65].Y:=3;
  InfMenu[65].Volba:=1;

{  SestavDatovyFajlProgramu;}

  StartMem:= MaxAvail;
  InitProg;
  MainMenu;
  DoneProg;
  CloseGraph;
  WriteLn('Animation Objects Maker '+ProgVersion+'              (c) No Sense 1994, 1995');
  if StartMem<>MemAvail then begin
    Write(#7);
    Writeln(StartMem);
    Writeln(MemAvail);
  end;
end.
