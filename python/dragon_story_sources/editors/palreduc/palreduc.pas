{$M 16384,80000,655360}

{$R+,I-}

Program PaletteReduction;

 {   * * * ********************************************** * * *    }
 {   * * *          (c) NoSense 1994, 1995                * * *    }
 {   * * * ********************************************** * * *    }

uses crt, graph256, graform, dfw, dialog, files, editor;

type
  TTagArray= array[0..255]of byte;
const
  ProgName= 'palreduc';
  FontName= 'stand2.fon';
  ProgVersion= 'V1.7 beta';
  WorkPath: string= '';

  DarkCol: byte= 0;
  MidCol: byte= 7;
  LightCol: byte= 255;
  TX: word= 10;
  TY: word= 10;
  TW: word= 10;
  TH: word= 5;
  TDx:word= 6;
  TDy:word= 1;

var
  ProgPath: string;
  MenuX, MenuY, MenuMisc: integer;
  PictPath: string;
  DColor1, DColor2, DColor3, DColor4, DColor5: byte;

  MirrorPal, ActualPal: PPalette;
  Im: pointer;
  i, f, g: word;

  TagMirror, TagActual, CnvPal: TTagArray;
  ColorUse, AktColor, NextUseColor: array[0..255]of word;
  TypObr: TGraphFile;
  pole : array[byte] of byte;


procedure SetColors(paletka: PPalette);
var i: integer;
    Value, Color: integer;
    OldDark, OldMid, OldLight: byte;
begin
  OldDark:= DarkCol;
  OldLight:= LightCol;
  OldMid:= MidCol;
  Value:= {maxint;}paletka^[DarkCol*3]+ paletka^[DarkCol*3+1]+ paletka^[DarkCol*3+2];
  for i:= 0 to 255 do begin
    if Value> (paletka^[i*3]+ paletka^[i*3+1]+ paletka^[i*3+2])then begin
      Value:= (paletka^[i*3]+ paletka^[i*3+1]+ paletka^[i*3+2]);
      DarkCol:= i;
    end;
  end;
  Value:= {-maxint;}paletka^[LightCol*3]+ paletka^[LightCol*3+1]+ paletka^[LightCol*3+2];
  for i:= 0 to 254 do begin
    if Value< (paletka^[i*3]+ paletka^[i*3+1]+ paletka^[i*3+2])then begin
      Value:= (paletka^[i*3]+ paletka^[i*3+1]+ paletka^[i*3+2]);
      LightCol:= i;
    end;
  end;
  Value:= {-maxint;}paletka^[MidCol*3]+ paletka^[MidCol*3+1]+ paletka^[MidCol*3+2];
  for i:= 0 to 254 do begin
    if (i<>LightCol)and(Value< (paletka^[i*3]+ paletka^[i*3+1]+ paletka^[i*3+2]))then begin
      Value:= (paletka^[i*3]+ paletka^[i*3+1]+ paletka^[i*3+2]);
      MidCol:= i;
    end;
  end;
{!!! Pridat test, kdy MidCol=LightCol!!!}
  for i:= 0 to (PWordArray(MouseImage)^[0]*PWordArray(MouseImage)^[1]) do begin
    if (PByteArray(MouseImage)^[4+i]= OldDark) then PByteArray(MouseImage)^[4+i]:= DarkCol else
    if (PByteArray(MouseImage)^[4+i]= OldMid) then PByteArray(MouseImage)^[4+i]:= MidCol;
  end;
end;


function ReadText(X, Y : integer; Del:integer; Vyzva : string;
  Vstup:string) : string;
{pri enter vrati nacteni retezec, pri escape vrati retezec #27 (Cescape znak)}
var ed:peditor;
begin
  AlokujEditor(ed);
  NastavEdOkno(ed, {X,Y,Del}x,y,del, {Vyzva}Vyzva,
    {font nadpisu a textu}font,font, {okno}true);
  NastavEdBarvy(ed,{bpopr:=}DColor1,{bpoz:=}DColor2,{bnadp:=}DColor3,{bkurs:=}DColor5,
    {binv:=}DColor4,{bokr:=}DColor5,{bpos:=}DColor5);
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

procedure ChooseFile(var PrevPath: string;Mask: string);
var
  path: string;
begin
  path:=vybersouboru(MenuX, MenuY, MenuMisc,
    DColor1, DColor2, DColor3, DColor4, DColor5, Font,
    trid_jmena, WorkPath, Mask);
  if (path<>#27)and(path<>#0) then PrevPath:= path;
end;

procedure LoadCFG;
var f: file;
begin
  Assign(f, ProgPath+ProgName+'.CFG');
  Reset(f,1);
  if ioresult=0 then begin
    BlockRead(f,WorkPath,SizeOf(WorkPath));
    BlockRead(f, TX, 2);
    BlockRead(f, TY, 2);
    BlockRead(f, TW, 2);
    BlockRead(f, TH, 2);
    BlockRead(f, TDx, 2);
    BlockRead(f, TDy, 2);
    if ioresult=0 then Close(f);
  end;
end;

procedure SaveCFG;
var f : file;
begin
  Assign(f,ProgPath+ProgName+'.CFG');
  ReWrite(f,1);
  BlockWrite(f,WorkPath,SizeOf(WorkPath));
  BlockWrite(f, TX, 2);
  BlockWrite(f, TY, 2);
  BlockWrite(f, TW, 2);
  BlockWrite(f, TH, 2);
  BlockWrite(f, TDx, 2);
  BlockWrite(f, TDy, 2);
  Close(f);
end;

procedure InitProg; { Inicializuje grafiku, font, mys, paletu ..., promene }
var f : file;
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
  GetMem(MirrorPal, 768);
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
  CLoadItem(ProgPath+ProgName+'.DAT', MouseImage, 1);
  CLoadItem(ProgPath+ProgName+'.DAT', pointer(Palette), 2);

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
  SetVisualPage(0);
  MouseOn(0, 0, MouseImage);
end;

procedure CleaningProg;
begin
  MouseOff;
  FreeMem(Palette, 768);
  DisposeImage(MouseImage);
  FreeMem(Font, Font^[0]*Font^[1]*138+140);
  FreeMem(MirrorPal, 768);
end;


procedure LoadPal;
var Name : string;
    f : file;
begin
  ChooseFile(Name, '.pal');
  if (Name[1]=#27)or(Name='') then exit;
  Assign(f,Name);
  Reset(f,1);
  if ioresult<>0 then exit;
  BlockRead(f, MirrorPal^,768);  {MirrorPal, Im, ActualPal}
  Close(f);
end;

procedure SavePal;
var Name : string;
    f : file;
begin
  Name:=ReadText(30, 30, 150, ' Zadej jméno souboru: ','');
  Name:=Name+'.ActualPal';
  Assign(f,WorkPath+Name);
  ReWrite(f,1);
  if ioresult<>0 then exit;
  BlockWrite(f, MirrorPal^, 768);  {MirrorPal, Im, ActualPal}
  Close(f);
end;

procedure Show;
begin
  MenuX:= 70;
  MenuY:= 20;
  MenuMisc:= 15;
  ChooseFile(PictPath, '*.bmp;*.pcx;*.lbm');
  if UpCase(pictpath[length(pictpath)])='P' then TypObr:= BMP else TypObr:= PCX;
  if LoadImage(Im, pointer(ActualPal), PictPath)= 255 then begin
  {nacetl jsem do pameti pozadi}
    SetPalette(ActualPal);
    SetColors(ActualPal);
    MouseSwitchOff;
    PutImage(0, 0, Im);
    MouseSwitchOn;
    repeat until (MouseKey<>0)or(KeyPressed and (ReadKey<>#255));
    SetPalette(Palette);
    SetColors(Palette);
    DisposeImage(Im);
    FreeMem(ActualPal, 768);
  end;
end;


procedure SaveImageDialog(Image: pointer; ActualPal: PPalette; Name: string);

  function CheckPath(var path : string):boolean;
  var
     i : byte; { pozice tecky v path}
     konec : string;
  begin
    for i:= 1 to Length(path) do path[i]:= UpCase(path[i]);
    i := Pos('.', path );
    if(i=0) then begin
      if TypObr= BMP then path := path+ '.BMP'
                     else path := path+ '.PCX';
      i := Pos('.', path );
    end else begin
      i := Pos('.', path );
      Konec:=Copy(path,i+1,length(path)-i);
      if konec='PCX' then TypObr:= PCX else
      if konec='BMP' then TypObr:= BMP else begin
        delete(path,i,length(path)-i+1);
        if TypObr= BMP then path := path+ '.BMP'
                       else path := path+ '.PCX'
      end;
    end;
  end;

var  cesta: string;
begin
  cesta:= PictPath;
  while(Cesta[byte(Length(Cesta))]<> '\') do Cesta[0]:= Char(Length(Cesta)-1);
  SetPalette(Palette);
  case vybermoznost('Ulozit obrazek?','~Uloz|Uloz j~ako...|~Zrus',
       DColor1, DColor2, DColor3, DColor4, DColor5, font, 1, 3) of
    1: ;
    2: PictPath:= Cesta+ReadText(30, 30, 150, ' Zadej jméno souboru: ','');
    else exit;
  end;
  CheckPath(PictPath);
  SetPalette(ActualPal);
  if TypObr=BMP then SaveBMP(Image, PPaletka(ActualPal), PictPath)
                else SavePCX(Image, PPaletka(ActualPal), PictPath);
end;

procedure GetAktColor;
var i1, i2 : byte;
begin
  for f:=0 to 255 do AktColor[f]:=0;
  for f:= 4 to 64003 do Inc(AktColor[PByteArray(Im)^[f]]);
  for i1:=0 to 255 do begin
    NextUseColor[i1]:=AktColor[i1];
    pole[i1]:=i1;
  end;
  for i1:=0 to 254 do
    for i2:=0 to 254-i1 do if NextUseColor[i2]>NextUseColor[i2+1] then begin
      NextUseColor[i2]:=NextUseColor[i2] xor NextUseColor[i2+1];
      NextUseColor[i2+1]:=NextUseColor[i2] xor NextUseColor[i2+1];
      NextUseColor[i2]:=NextUseColor[i2+1] xor NextUseColor[i2];
      pole[i2]:=pole[i2] xor pole[i2+1];
      pole[i2+1]:=pole[i2] xor pole[i2+1];
      pole[i2]:=pole[i2+1] xor pole[i2];
    end;
end;

procedure TagAllUsed(var TagPal: TTagArray);
var
  f: word;
begin
  for f:=0 to 255 do ColorUse[f]:=0;
  for f:= 4 to 64003 do Inc(ColorUse[PByteArray(Im)^[f]]);
  for f:= 0 to 255 do if ColorUse[f]>0 then TagPal[f]:= 1;
end;

procedure ClearAll(var TagPal: TTagArray);
var f : byte;
begin
  for f:=0 to 255 do TagPal[f]:= 0;
end;

procedure InversAll(var TagPal: TTagArray);
var f : byte;
begin
  for f:=0 to 255 do if TagPal[f]<>0 then TagPal[f]:=0 else TagPal[f]:=1;
end;

procedure InsertTagBar(var TagPal: TTagArray; x,y : byte; jak : boolean);
const
    MaxC = 12;
var f : byte;
    R, G, B : integer; {nevim jestli je to spravne serazeno (RGB) }
begin
  R:=PPalette(ActualPal)^[(x+y)*3];
  G:=PPalette(ActualPal)^[(x+y)*3+1];
  B:=PPalette(ActualPal)^[(x+y)*3+2];
  for f:=x+y to {x+15}255 do begin
    if (abs(R-PPalette(ActualPal)^[f*3])<MaxC)and
       (abs(G-PPalette(ActualPal)^[f*3+1])<MaxC)and
       (abs(B-PPalette(ActualPal)^[f*3+2])<MaxC)
      then begin
        if jak then TagPal[f]:=1 else TagPal[f]:=0;
        R:=PPalette(ActualPal)^[f*3];
        G:=PPalette(ActualPal)^[f*3+1];
        B:=PPalette(ActualPal)^[f*3+2];
      end else Break;
  end;
  R:=PPalette(ActualPal)^[(x+y)*3];
  G:=PPalette(ActualPal)^[(x+y)*3+1];
  B:=PPalette(ActualPal)^[(x+y)*3+2];
  for f:=x+y downto {x}0 do begin
    if (abs(R-PPalette(ActualPal)^[f*3])<MaxC)and
       (abs(G-PPalette(ActualPal)^[f*3+1])<MaxC)and
       (abs(B-PPalette(ActualPal)^[f*3+2])<MaxC)
      then begin
        if jak then TagPal[f]:=1 else TagPal[f]:=0;
        R:=PPalette(ActualPal)^[f*3];
        G:=PPalette(ActualPal)^[f*3+1];
        B:=PPalette(ActualPal)^[f*3+2];
      end else Break;
  end;
end;

procedure ReverseFirstLast(TagPal: TTagArray; First, Last: byte);
var
  h: byte;
  f: word;
begin
  if First> Last then begin
    h:= Last;
    Last:= First;
    First:= h;
  end;

  for f:= 0 to 255 do CnvPal[f]:= f;

  for f:= 0 to ((Last-First)div 2) do begin
    CnvPal[First+f]:= Last-f;
    CnvPal[Last-f]:= First+f;
    h:= ActualPal^[(First+f)*3];
    ActualPal^[(First+f)*3]:= ActualPal^[(Last-f)*3];
    ActualPal^[(Last-f)*3]:= h;
    h:=ActualPal^[(First+f)*3+1];
    ActualPal^[(First+f)*3+1]:=ActualPal^[(Last-f)*3+1];
    ActualPal^[(Last-f)*3+1]:=h;
    h:=ActualPal^[(First+f)*3+2];
    ActualPal^[(First+f)*3+2]:=ActualPal^[(Last-f)*3+2];
    ActualPal^[(Last-f)*3+2]:=h;
  end;
  for f:= 4 to 64003 do
    PByteArray(Im)^[f]:= CnvPal[PByteArray(Im)^[f]];
end;

procedure ReverseColor(var TagPal: TTagArray;  X, Y, Width, Heigth, DistX, DistY : word);
var i1, i2 : byte;
begin
  SetPalette(Palette);
  standardnidialog('Klikni levym talcitkem mysi |na prvni barvu ...',
    DColor1, DColor2, DColor3, DColor4, DColor5, font, upozorneni);
  SetPalette(ActualPal);
  repeat until (MouseKey<>0)or(KeyPressed);
  repeat until (MouseKey=0)or(KeyPressed);
  if KeyPressed then exit;
  if not((mousey>Y)and(mousey<Y+16*Heigth+16*DistY)and
     (mousex>X)and(mousex<X+16*Width+16*DistX)) then exit;
  i1:=(MouseX-X-2)div(Width+DistX)*16+(MouseY-Y-1)div(Heigth+DistY);
  SetPalette(Palette);
  standardnidialog('Klikni levym talcitkem mysi |na posledni barvu ...',
    DColor1, DColor2, DColor3, DColor4, DColor5, font, upozorneni);
  SetPalette(ActualPal);
  repeat until (MouseKey<>0)or(KeyPressed);
  repeat until (MouseKey=0)or(KeyPressed);
  if KeyPressed then exit;
    if not((mousey>Y)and(mousey<Y+16*Heigth+16*DistY)and
     (mousex>X)and(mousex<X+16*Width+16*DistX)) then exit;
  i2:=(MouseX-X-2)div(Width+DistX)*16+(MouseY-Y-1)div(Heigth+DistY);
  ReverseFirstLast(TagPal, i1, i2);
  SetPalette(ActualPal);
  MouseSwitchOff;
  PutImage(0,0,Im);
  MouseSwitchOn;
end;

procedure SwapColor(var TagPal: TTagArray; First, Second : byte);
var i : byte;
    i1 : word;
begin
  i:=TagPal[First];
  TagPal[First]:=TagPal[Second];
  TagPal[Second]:=i;

  i:=ActualPal^[First*3];
  ActualPal^[First*3]:=ActualPal^[Second*3];
  ActualPal^[Second*3]:=i;

  i:=ActualPal^[First*3+1];
  ActualPal^[First*3+1]:=ActualPal^[Second*3+1];
  ActualPal^[Second*3+1]:=i;

  i:=ActualPal^[First*3+2];
  ActualPal^[First*3+2]:=ActualPal^[Second*3+2];
  ActualPal^[Second*3+2]:=i;
  for i1:=4 to 64004 do begin
    if (PByteArray(Im)^[i1]=First) then PByteArray(Im)^[i1]:=Second else
    if (PByteArray(Im)^[i1]=Second) then PByteArray(Im)^[i1]:=First;
  end;
end;

procedure SwapSomeColor(var TagPal: TTagArray;  X, Y, Width, Heigth, DistX, DistY : word);
var i1, i2 : byte;
begin
  SetPalette(Palette);
  standardnidialog('Klikni levym talcitkem mysi |na prvni barvu ...',
    DColor1, DColor2, DColor3, DColor4, DColor5, font, upozorneni);
  SetPalette(ActualPal);
  repeat until (MouseKey<>0)or(KeyPressed);
  repeat until (MouseKey=0)or(KeyPressed);
  if KeyPressed then exit;
  if not((mousey>Y)and(mousey<Y+16*Heigth+16*DistY)and
     (mousex>X)and(mousex<X+16*Width+16*DistX)) then exit;
  i1:=(MouseX-X-2)div(Width+DistX)*16+(MouseY-Y-1)div(Heigth+DistY);
  SetPalette(Palette);
  standardnidialog('Klikni levym talcitkem mysi |na druhou barvu ...',
    DColor1, DColor2, DColor3, DColor4, DColor5, font, upozorneni);
  SetPalette(ActualPal);
  repeat until (MouseKey<>0)or(KeyPressed);
  repeat until (MouseKey=0)or(KeyPressed);
  if KeyPressed then exit;
  if not((mousey>Y)and(mousey<Y+16*Heigth+16*DistY)and
     (mousex>X)and(mousex<X+16*Width+16*DistX)) then exit;
  i2:=(MouseX-X-2)div(Width+DistX)*16+(MouseY-Y-1)div(Heigth+DistY);
  SwapColor(TagPal, i1, i2);
  SetPalette(ActualPal);
  MouseSwitchOff;
  PutImage(0,0,Im);
  MouseSwitchOn;
end;

{procedure CompresTagColor(var TagPal: TTagArray;  X, Y, Width, Heigth, DistX, DistY : word; Smer : boolean);
var i1, i2, i3, i5 : byte;
    i4 : integer;
    pole : array[0..255] of byte;
    w : word;

  procedure SwapMyColor(var TagPal: TTagArray; First, Second : byte);
  begin
    i:=ActualPal^[First*3];
    ActualPal^[First*3]:=ActualPal^[Second*3];
    ActualPal^[Second*3]:=i;

    i:=ActualPal^[First*3+1];
    ActualPal^[First*3+1]:=ActualPal^[Second*3+1];
    ActualPal^[Second*3+1]:=i;

    i:=ActualPal^[First*3+2];
    ActualPal^[First*3+2]:=ActualPal^[Second*3+2];
    ActualPal^[Second*3+2]:=i;
    pole[first]:=pole[first] xor pole[second];
    pole[second]:=pole[first] xor pole[second];
    pole[first]:=pole[first] xor pole[second];
    TagPal[first]:=TagPal[first] xor TagPal[second];
    TagPal[second]:=TagPal[first] xor TagPal[second];
    TagPal[first]:=TagPal[first] xor TagPal[second];
  end;

begin
  for i1:=0 to 255 do pole[i1]:=i1;
  i4:=0;
  for i1:=0 to 255 do if TagPal[i1]<>0 then Inc(i4);
  if (i4=0)or(i4=256) then exit;
  SetPalette(Palette);
  standardnidialog('Klikni levym talcitkem mysi |na prvni barvu ...',
    DColor1, DColor2, DColor3, DColor4, DColor5, font, upozorneni);
  SetPalette(ActualPal);
  repeat until (MouseKey<>0)or(KeyPressed);
  repeat until (MouseKey=0)or(KeyPressed);
  if KeyPressed then exit;
  i1:=(MouseX-X-2)div(Width+DistX)*16+(MouseY-Y-1)div(Heigth+DistY);
  i2:=i1;
  i5:=1;
  while (TagPal[i2]<>0) do begin
    if smer then inc(i2) else Dec(i2);
    Inc(i5)
  end;
  i3:=i2;
  i1:=i4;
  for i4:=i5 to i1 do begin
    while (TagPal[i2]<>0) do begin
      if smer then inc(i2) else Dec(i2);
      inc(i4);
    end;
    if i4>i1 then Break;
    while (TagPal[i3]=0) do if smerthen inc(i3)else Dec(i3);
    SwapMyColor(TagPal, i2,i3);
    if smer then inc(i2)else Dec(i2);
    if smer then inc(i3) else Dec(i3);
    SetPalette(ActualPal);
  end;
  for w:=4 to 64004 do
    PByteArray(Im)^[w]:=pole[PByteArray(Im)^[w]];
  MouseSwitchOff;
  PutImage(0,0,Im);
  MouseSwitchOn;
end;}

procedure CompresTagColor(var TagPal: TTagArray;  X, Y, Width, Heigth, DistX, DistY : word; Smer : boolean);
var i1, i2, i3, i5 : byte;
    i4 : integer;
    pole : array[0..255] of byte;
    w : word;
    mypal : ppalette;

begin
  for i1:=0 to 255 do pole[i1]:=i1;
  i4:=0;
  for i1:=0 to 255 do if TagPal[i1]<>0 then Inc(i4);
  if (i4=0)or(i4=256) then exit;
  SetPalette(Palette);
  standardnidialog('Klikni levym talcitkem mysi |na prvni barvu ...',
    DColor1, DColor2, DColor3, DColor4, DColor5, font, upozorneni);
  SetPalette(ActualPal);
  repeat until (MouseKey<>0)or(KeyPressed);
  repeat until (MouseKey=0)or(KeyPressed);
  if KeyPressed then exit;
  if not((mousey>Y)and(mousey<Y+16*Heigth+16*DistY)and
     (mousex>X)and(mousex<X+16*Width+16*DistX)) then exit;
  i1:=(MouseX-X-2)div(Width+DistX)*16+(MouseY-Y-1)div(Heigth+DistY);
  i3:=i1; {i4 .. pocet barev/ i1 .. prvni barva / i2 tagovane b.
           i3 .. polozit barvu }
  getmem(mypal,768);
{  if smer then i2:=0 else i2:=255;
  repeat}
  for i2:=0 to 255 do
    if TagPal[i2]<>0 then begin {remap tag color}
      MyPal^[i3*3]:=ActualPal^[i2*3];
      MyPal^[i3*3+1]:=ActualPal^[i2*3+1];
      MyPal^[i3*3+2]:=ActualPal^[i2*3+2];
      pole[i2]:=i3;
      if smer
        then if i3<>255 then inc(i3) else i3:=0
        else if i3<>0 then dec(i3) else i3:=255;
    end;
{    if smer
      then if i2<>255 then inc(i2) else i2:=0
      else if i2<>0 then dec(i2) else i2:=255;
  until (smer and (i2=255))or ((not smer)and(i2=0));}
  i3:=0;
  for i2:=0 to 255 do if tagpal[i2]=0 then begin {ramap not tag color}
    if smer
      then if i3=i1 then inc(i3,i4) else
      else if i3=i1-i4+1 then inc(i3,i4);
    MyPal^[i3*3]:=ActualPal^[i2*3];
    MyPal^[i3*3+1]:=ActualPal^[i2*3+1];
    MyPal^[i3*3+2]:=ActualPal^[i2*3+2];
    pole[i2]:=i3;
    if i3<>255 then inc(i3) else i3:=0;
  end;

  move(mypal^,actualpal^,768);
  freemem(mypal,768);
  for w:=4 to 64004 do PByteArray(Im)^[w]:=pole[PByteArray(Im)^[w]];
  for i2:=0 to 255 do if smer
    then if (i2<i1)or(i2>i1+i4-1) then tagpal[i2]:=0 else tagpal[i2]:=1
    else if (i2<i1-i4+1)or(i2>i1) then tagpal[i2]:=0 else tagpal[i2]:=1;
  MouseSwitchOff;
  PutImage(0,0,Im);
  SetPalette(ActualPal);
  MouseSwitchOn;
end;

procedure MoveColor(var TagPal: TTagArray;  X, Y, Width, Heigth, DistX, DistY : word);
var i1, i2 : byte;
begin
  SetPalette(Palette);
  standardnidialog('Klikni levym talcitkem mysi |na prenasenou barvu ...',
    DColor1, DColor2, DColor3, DColor4, DColor5, font, upozorneni);
  SetPalette(ActualPal);
  repeat until (MouseKey<>0)or(KeyPressed);
  repeat until (MouseKey=0)or(KeyPressed);
  if KeyPressed then exit;
  if not((mousey>Y)and(mousey<Y+16*Heigth+16*DistY)and
     (mousex>X)and(mousex<X+16*Width+16*DistX)) then exit;
  i1:=(MouseX-X-2)div(Width+DistX)*16+(MouseY-Y-1)div(Heigth+DistY);
  SetPalette(Palette);
  standardnidialog('Klikni levym talcitkem mysi |na kterou barvu ji chces prenest ...',
    DColor1, DColor2, DColor3, DColor4, DColor5, font, upozorneni);
  SetPalette(ActualPal);
  repeat until (MouseKey<>0)or(KeyPressed);
  repeat until (MouseKey=0)or(KeyPressed);
  if KeyPressed then exit;
  if not((mousey>Y)and(mousey<Y+16*Heigth+16*DistY)and
     (mousex>X)and(mousex<X+16*Width+16*DistX)) then exit;
  i2:=(MouseX-X-2)div(Width+DistX)*16+(MouseY-Y-1)div(Heigth+DistY);
  ActualPal^[i2*3]:=ActualPal^[i1*3];
  ActualPal^[i2*3+1]:=ActualPal^[i1*3+1];
  ActualPal^[i2*3+2]:=ActualPal^[i1*3+2];

  SetPalette(ActualPal);
  MouseSwitchOff;
  PutImage(0,0,Im);
  MouseSwitchOn;
end;

procedure EditPalette(var TagPal: TTagArray);
  procedure Plus(jak : boolean);
  const Posun = 1;
  var i : byte;
  begin
    for i:=0 to 255 do if TagPal[i]<>0 then begin
      if jak then begin
        if ActualPal^[i*3]>Posun then Dec(ActualPal^[i*3],Posun)
        else ActualPal^[i*3]:=0;
        if ActualPal^[i*3+1]>Posun then Dec(ActualPal^[i*3+1],Posun)
        else ActualPal^[i*3+1]:=0;
        if ActualPal^[i*3+2]>Posun then Dec(ActualPal^[i*3+2],Posun)
        else ActualPal^[i*3+2]:=0;
      end else begin
        if ActualPal^[i*3]<63-Posun then Inc(ActualPal^[i*3],Posun)
        else ActualPal^[i*3]:=63;
        if ActualPal^[i*3+1]<63-Posun then Inc(ActualPal^[i*3+1],Posun)
        else ActualPal^[i*3+1]:=63;
        if ActualPal^[i*3+2]<63-Posun then Inc(ActualPal^[i*3+2],Posun)
        else ActualPal^[i*3+2]:=63;
      end;
    end;
  end;
  procedure Krat(jak : boolean);
  const Posun = 10;
  var i : byte;
  begin
    for i:=0 to 255 do if TagPal[i]<>0 then begin
      if jak then begin
          Inc(ActualPal^[i*3],ActualPal^[i*3] div Posun);
          Inc(ActualPal^[i*3+1],ActualPal^[i*3+1] div Posun);
          Inc(ActualPal^[i*3+2],ActualPal^[i*3+2] div Posun);
          if ActualPal^[i*3]>63 then ActualPal^[i*3]:=63;
          if ActualPal^[i*3+1]>63 then ActualPal^[i*3+1]:=63;
          if ActualPal^[i*3+2]>63 then ActualPal^[i*3+2]:=63;
      end else begin
          Dec(ActualPal^[i*3],ActualPal^[i*3] div Posun);
          Dec(ActualPal^[i*3+1],ActualPal^[i*3+1] div Posun);
          Dec(ActualPal^[i*3+2],ActualPal^[i*3+2] div Posun);
          if ActualPal^[i*3]>63 then ActualPal^[i*3]:=0;
          if ActualPal^[i*3+1]>63 then ActualPal^[i*3+1]:=0;
          if ActualPal^[i*3+2]>63 then ActualPal^[i*3+2]:=0;
      end;
    end;
  end;
var Key : char;
    Save : Pointer;
begin
  MouseSwitchOff;
  PutImage(0,0,Im);
  MouseSwitchOn;
  GetMem(Save,768);
  Move(ActualPal^,Save^,768);
  repeat
    if keypressed then Key:=ReadKey else Key:=#0;
    case UpCase(Key) of
      #80 : Plus(true);
      #72 : Plus(false);
      #77 : Krat(true);
      #75 : Krat(false);
      'B' : Move(Save^,ActualPal^,768);
    end;
    SetPalette(ActualPal);
  until (Key=#27)or(MouseKey=2);
  FreeMem(Save,768);
end;

procedure ShowPalette(X, Y, Width, Heigth, DistX, DistY: word);
var
  i, j: byte;

  procedure Window;
  begin
    Bar(X, Y, (Width+DistX)*16+DistX+2, (Heigth+DistY)*16+DistY+2, DarkCol);
    Bar(X+1, Y+1, (Width+DistX)*16+DistX, (Heigth+DistY)*16+DistY, LightCol);
  end;

begin
  Window;
  for j:= 0 to 15 do begin
    for i:= 0 to 15 do begin
      Bar(X+DistX+1+j*Width+j*DistX, Y+DistY+1+i*Heigth+i*DistY, Width, Heigth, j*16+i);
    end;
  end;
end;

procedure ShowTags(X, Y, Width, Heigth, DistX, DistY: word; TagPal: TTagArray);
var
  i, j: byte;
begin
  for j:= 0 to 15 do begin
    for i:= 0 to 15 do begin
      if TagPal[j*16+i]= 0 then begin
        LineY(X+DistX+1+j*Width+j*DistX+Width, Y+DistY+1+i*Heigth+i*DistY, Heigth, LightCol);
        LineY(X+DistX+1+j*Width+j*DistX+Width+1, Y+DistY+1+i*Heigth+i*DistY, Heigth, LightCol);
      end else begin
        LineY(X+DistX+1+j*Width+j*DistX+Width, Y+DistY+1+i*Heigth+i*DistY, Heigth, DarkCol);
        LineY(X+DistX+1+j*Width+j*DistX+Width+1, Y+DistY+1+i*Heigth+i*DistY, Heigth, DarkCol);
      end;
    end;
  end;
end;

procedure tagnextcolor(var TagPal: TTagArray);
var i1, i2 : byte;
begin
{  for i1:=0 to 255 do begin
    NextUseColor[i1]:=AktColor[i1];
    pole[i1]:=i1;
  end;
  for i1:=0 to 254 do
    for i2:=0 to 254-i1 do if NextUseColor[i2]>NextUseColor[i2+1] then begin
      NextUseColor[i2]:=NextUseColor[i2] xor NextUseColor[i2+1];
      NextUseColor[i2+1]:=NextUseColor[i2] xor NextUseColor[i2+1];
      NextUseColor[i2]:=NextUseColor[i2+1] xor NextUseColor[i2];
      pole[i2]:=pole[i2] xor pole[i2+1];
      pole[i2+1]:=pole[i2] xor pole[i2+1];
      pole[i2]:=pole[i2+1] xor pole[i2];
    end;}
  i1:=255;
  while (TagPal[pole[i1]]<>0)and(i1<>0) do
    dec(i1);
  if NextUseColor[i1]<>0 then tagpal[pole[i1]]:=1;
end;

procedure UntagLastColor(var tagpal : TTagArray);
var i1, i2 : byte;
begin
  i1:=0;
  while (TagPal[pole[i1]]=0)and(i1<>255) do
    inc(i1);
  tagpal[pole[i1]]:=0;
end;

function MyMenu : char;
const MenuX : integer = 50;
      MenuY : integer = 50;
var i : integer;
begin
  SetPalette(Palette);
  SetColors(Palette);
  i:=VytvorMenu('#Tool:|~Tag used|~Clear tags|~Invert tags|(~X) Swap colors|Re~verse block|'+
    '~Move color|~Read palette|'+
    '~Write pallette|~Palette|~> move tagged|~< move tagged|~Save|Cancel',
    DColor1, DColor2, DColor3, DColor4,DColor5, font, MenuX, MenuY, 1, 13);
  case i of
    1 : MyMenu:='T';
    2 : MyMenu:='C';
    3 : MyMenu:='I';
    4 : MyMenu:='X';
    5 : MyMenu:='V';
    6 : MyMenu:='M';
    7 : MyMenu:='R';
    8 : MyMenu:='W';
    9 : MyMenu:='P';
    10: MyMenu:='>';
    11 : MyMenu:='<';
    12 : MyMenu:='S';
    13 : MyMenu:=#0;
  end;
  SetPalette(ActualPal);
  SetColors(ActualPal);
  MouseSwitchOff;
  MouseSwitchOn;
end;

procedure TagByMouse(var X, Y, Width, Heigth, DistX, DistY: word; var TagPal: TTagArray);
{nejdulezitejsi rutinka, tady se vsechno "vari"..}
var
  HotKey: char;
  OldColor: integer;
  RunMenu, Quit : boolean;
  OldMX, OldMY: word;
  NewWidth, NewHeigth: integer;
  mousexx, mouseyy : integer;
  jak : byte;
  undo : record
           tags : TTagArray;
           pals : ppalette;
           X1, Y1, Width1, Heigth1, DistX1, DistY1 : word;
         end;
  tagssss : boolean;

procedure saveundo;
begin
  move(tagpal,undo.tags,sizeof(ttagarray));
  move(actualpal^,undo.pals^,768);
  with undo do begin
    x1:=x;
    y1:=y;
    Width1:=Width;
    Heigth1:=Heigth;
    DistX1:=DistX;
    DistY1:=DistY;
  end;
  mouseswitchoff;
  setactivepage(1);
  putimage(0,0,im);
  setactivepage(0);
  mouseswitchon;
end;
procedure MakeUndo;
begin
  move(undo.tags,tagpal,sizeof(tagpal));
  move(undo.pals^,actualpal^,768);
  with undo do begin
    x:=x1;
    y:=y1;
    Width:=Width1;
    Heigth:=Heigth1;
    DistX:=DistX1;
    DistY:=DistY1;
  end;
  mouseswitchoff;
  setactivepage(1);
  getimage(0,0,320,200,im);
  setactivepage(0);
  putimage(0,0,im);
  ShowPalette(X, Y, Width, Heigth, DistX, DistY);
  ShowTags(X, Y, Width, Heigth, DistX, DistY, TagPal);
  mouseswitchon;
  setpalette(actualpal);
end;

 procedure ChooseKey;
 begin
   if KeyPressed then HotKey:= ReadKey else HotKey:=#0;
   if (HotKey=#13)or(RunMenu) then begin
     repeat until MouseKey=0;
     HotKey:=MyMenu;
     RunMenu:=false;
   end;
   if MouseKey=2 then begin
     repeat
       if MouseKey=3 then RunMenu:=true;
     until (MouseKey=0)or(RunMenu);
     if not RunMenu then Quit:=true;
   end;
   repeat
    if MouseKey=2 then begin
      repeat
        if MouseKey=3 then RunMenu:=true;
      until (MouseKey=0)or(RunMenu);
      if not RunMenu then Quit:=true;
    end;
    if KeyPressed then HotKey:= ReadKey else HotKey:=#0;
    if (hotkey<>#0)and(UpCase(hotkey)<>'U')then saveundo;
    if (HotKey=#13)or(RunMenu) then begin
      repeat until MouseKey=0;
      HotKey:=MyMenu;
      RunMenu:=false;
    end;
    case UpCase(HotKey) of
      #59 : begin
              {HELP}
              SetPalette(Palette);
              SetColors(Palette);
              vybermoznost('|T: Oznaci akt. barvy|'+
                'C: Odoznaci|I: Zinvertuje|'+
                '+: Oznaci podobne|-: Odoznaci podobne|'+
                'X: Prehodi dve|V: Prehodi blok|M: Prenese b.|P: Prace s paletou|'+
                '>: Presune odprava|<: Presune odleva|'+
                'S: Ulozeni obr.|R/W: nacte/zapise paletu',
                '~Hm...', DColor1, DColor2, DColor3, DColor4, DColor5, font, 1,1);
              SetPalette(ActualPal);
              SetColors(ActualPal);
              MouseSwitchOff;
              MouseSwitchOn;
            end;
      'P' : begin
              EditPalette(TagPal);
              SetColors(ActualPal);
              MouseSwitchOff;
              GetAktColor;
              ShowPalette(X, Y, Width, Heigth, DistX, DistY);
              ShowTags(X, Y, Width, Heigth, DistX, DistY, TagPal);
              MouseSwitchOn;
            end;
      'S' : begin
              SaveImageDialog(Im, ActualPal, PictPath);
              SetPalette(ActualPal);
            end;
      'R' : begin
              LoadPal;
              SetPalette(ActualPal);
              SetColors(ActualPal);
            end;
      'W' : SavePal;
      'X' : begin
              SwapSomeColor(TagPal, X, Y, Width, Heigth, DistX, DistY);
              MouseSwitchOff;
              GetAktColor;
              SetColors(ActualPal);
              ShowPalette(X, Y, Width, Heigth, DistX, DistY);
              ShowTags(X, Y, Width, Heigth, DistX, DistY, TagPal);
              MouseSwitchOn;
            end;
      'V' : begin
              ReverseColor(TagPal, X, Y, Width, Heigth, DistX, DistY);
              MouseSwitchOff;
              GetAktColor;
              SetColors(ActualPal);
              ShowPalette(X, Y, Width, Heigth, DistX, DistY);
              ShowTags(X, Y, Width, Heigth, DistX, DistY, TagPal);
              MouseSwitchOn;
            end;
      '>' : begin
              CompresTagColor(TagPal, X, Y, Width, Heigth, DistX, DistY, true);
              MouseSwitchOff;
              GetAktColor;
              SetColors(ActualPal);
              ShowPalette(X, Y, Width, Heigth, DistX, DistY);
              ShowTags(X, Y, Width, Heigth, DistX, DistY, TagPal);
              MouseSwitchOn;
            end;
      '<' : begin
              CompresTagColor(TagPal, X, Y, Width, Heigth, DistX, DistY, false);
              MouseSwitchOff;
              GetAktColor;
              SetColors(ActualPal);
              ShowPalette(X, Y, Width, Heigth, DistX, DistY);
              ShowTags(X, Y, Width, Heigth, DistX, DistY, TagPal);
              MouseSwitchOn;
            end;
      'M' : begin
              MoveColor(TagPal, X, Y, Width, Heigth, DistX, DistY);
              MouseSwitchOff;
              SetColors(ActualPal);
              ShowPalette(X, Y, Width, Heigth, DistX, DistY);
              ShowTags(X, Y, Width, Heigth, DistX, DistY, TagPal);
              MouseSwitchOn;
            end;
      'T' : begin
              MouseSwitchOff;
              TagAllUsed(TagPal);
              ShowTags(X, Y, Width, Heigth, DistX, DistY, TagPal);
              MouseSwitchOn;
            end;
      'C' : begin
              MouseSwitchOff;
              ClearAll(TagPal);
              ShowTags(X, Y, Width, Heigth, DistX, DistY, TagPal);
              MouseSwitchOn;
           end;
      'I' : begin
              MouseSwitchOff;
              InversAll(TagPal);
              ShowTags(X, Y, Width, Heigth, DistX, DistY, TagPal);
              MouseSwitchOn;
           end;
      #43 : if (MouseY>=Y)and(MouseY<Y+16*Heigth+16*DistY)and
              (MouseX>=X)and(MouseX<X+16*Width+16*DistX)then begin
              MouseSwitchOff;
              InsertTagBar(TagPal,(MouseX-X)div(Width+DistX)*16,
                         (MouseY-Y)div(Heigth+DistY), true);
              ShowTags(X, Y, Width, Heigth, DistX, DistY, TagPal);
              MouseSwitchOn;
            end;
      #45 : if (MouseY>=Y)and(MouseY<Y+16*Heigth+16*DistY)and
              (MouseX>=X)and(MouseX<X+16*Width+16*DistX)then begin
              MouseSwitchOff;
              InsertTagBar(TagPal,(MouseX-X)div(Width+DistX)*16,
                         (MouseY-Y)div(Heigth+DistY), false);
              ShowTags(X, Y, Width, Heigth, DistX, DistY, TagPal);
              MouseSwitchOn;
            end;
       'U': MakeUndo;
       '[': begin
              TagNextColor(tagPal);
              MouseSwitchOff;
              ShowTags(X, Y, Width, Heigth, DistX, DistY, TagPal);
              MouseSwitchOn;
            end;
       ']': begin
              UntagLastColor(tagPal);
              MouseSwitchOff;
              ShowTags(X, Y, Width, Heigth, DistX, DistY, TagPal);
              MouseSwitchOn;
            end;
       #27: Quit:=true;
     end;
     if (hotkey<>#0)or ((tagssss)and(hotkey=#0)and(MouseKey=0)) then tagssss:=false;
     if MouseKey=0 then OldColor:=-1;
   until (MouseKey=1)or Quit;
   if not Tagssss then begin saveundo; tagssss:=true; end;
 end;
 procedure ReMoveWindow;
 begin
   newmousexy(x,y);
   {presun okna}
   MouseSwitchOff;
   XorRectangle(X, Y, (Width+DistX)*16+DistX+2, (Heigth+DistY)*16+DistY+2, 80);
   XorRectangle(X+1, Y+1, (Width+DistX)*16+DistX, (Heigth+DistY)*16+DistY, 2);
   OldMX:= mousexx;
   OldMY:= mouseyy;
   repeat
     mousexx:=mousex;
     mouseyy:=mousey;
     if (mousexx<>OldMX)or(mouseyy<>OldMY)then begin
       XorRectangle(X, Y, (Width+DistX)*16+DistX+2, (Heigth+DistY)*16+DistY+2, 80);
       XorRectangle(X+1, Y+1, (Width+DistX)*16+DistX, (Heigth+DistY)*16+DistY, 2);
{       if((X+mousexx-OldMX)>=0)and((X+mousexx-OldMX)<(320-(Width+DistX)*16-DistX-1))then X:= X+ mousexx- OldMX;
       if((Y+mouseyy-OldMY)>=0)and((Y+mouseyy-OldMY)<(200-(Heigth+DistY)*16-DistY-1))then Y:= Y+ mouseyy- OldMY;}
       if ((mousexx+(Width+DistX)*16+DistX+1)<320) then x:=mousexx;
       if ((mouseyy+(Heigth+DistY)*16+DistY+1)<200) then y:=mouseyy;
       XorRectangle(X, Y, (Width+DistX)*16+DistX+2, (Heigth+DistY)*16+DistY+2, 80);
       XorRectangle(X+1, Y+1, (Width+DistX)*16+DistX, (Heigth+DistY)*16+DistY, 2);
       OldMX:= mousexx;
       OldMY:= mouseyy;
     end;
   until MouseKey= 0;
   XorRectangle(X, Y, (Width+DistX)*16+DistX+2, (Heigth+DistY)*16+DistY+2, 80);
   XorRectangle(X+1, Y+1, (Width+DistX)*16+DistX, (Heigth+DistY)*16+DistY, 2);
   PutImage(0, 0, Im);
   ShowPalette(X, Y, Width, Heigth, DistX, DistY);
   ShowTags(X, Y, Width, Heigth, DistX, DistY, TagPal);
   MouseSwitchOn;
 end;
 procedure ReSizeWindow;
 begin
   {zmena velikosti okna}
   MouseSwitchOff;
   NewWidth:= (Width+DistX)*16+DistX;
   NewHeigth:= (Heigth+DistY)*16+DistY;
   XorRectangle(X, Y, NewWidth+2, NewHeigth+2, 80);
   XorRectangle(X+1, Y+1, NewWidth, NewHeigth, 2);
   OldMX:= mousexx;
   OldMY:= mouseyy;
   repeat
     mousexx:=mousex;
     mouseyy:=mousey;
     if (mousexx<>OldMX)or(mouseyy<>OldMY)then begin
       XorRectangle(X, Y, NewWidth+2, NewHeigth+2, 80);
       XorRectangle(X+1, Y+1, NewWidth, NewHeigth, 2);
       if((NewWidth+mousexx-OldMX)>4)and((X+mousexx-OldMX+NewWidth+2)<320)then
         NewWidth:= NewWidth+ mousexx- OldMX;
       if((NewHeigth+mouseyy-OldMY)>4)and((Y+mouseyy-OldMY+NewHeigth+2)<200)then
         NewHeigth:= NewHeigth+ mouseyy- OldMY;
       XorRectangle(X, Y, NewWidth+2, NewHeigth+2, 80);
       XorRectangle(X+1, Y+1, NewWidth, NewHeigth, 2);
       OldMX:= mousexx;
       OldMY:= mouseyy;
     end;
   until MouseKey= 0;
   XorRectangle(X, Y, NewWidth+2, NewHeigth+2, 80);
   XorRectangle(X+1, Y+1, NewWidth, NewHeigth, 2);

   Width:= trunc( ((NewWidth-2)/16)*(3/5) );
   if Width< 5 then Width:= 5;
   DistX:= trunc( (NewWidth-2)/16*1/4 );
   DistX:= DistX+ byte(DistX=0);
   Heigth:= trunc( (NewHeigth-2)/16*3/5 );
   if Heigth< 3 then Heigth:= 3;
   DistY:= trunc( (NewHeigth-2)/16*1/4 );
   DistY:= DistY+ byte(DistY=0);

   PutImage(0, 0, Im);
   ShowPalette(X, Y, Width, Heigth, DistX, DistY);
   ShowTags(X, Y, Width, Heigth, DistX, DistY, TagPal);
   MouseSwitchOn;
 end;
 procedure InBarKlick;
 begin
   if (mousexx-X-2)div(Width+DistX)*16+(mouseyy-Y-1)div(Heigth+DistY)<>OldColor then
   begin
     if oldcolor=-1 then jak:=TagPal[(mousexx-X-2)div(Width+DistX)*16+(mouseyy-Y-1)div(Heigth+DistY)];
     TagPal[(mousexx-X-2)div(Width+DistX)*16+(mouseyy-Y-1)div(Heigth+DistY)]:=jak xor 1;
     OldColor:=(mousexx-X-2)div(Width+DistX)*16+(mouseyy-Y-1)div(Heigth+DistY);
     MouseSwitchOff;
     ShowTags(X, Y, Width, Heigth, DistX, DistY, TagPal);
     MouseSwitchOn;
   end;
 end;
begin
  GetAktColor;
  getmem(undo.pals,768);
  saveundo;
  MouseSwitchoff;
  RunMenu:= False;
  Quit:= False;
  ShowPalette(X, Y, Width, Heigth, DistX, DistY);
  ShowTags(X, Y, Width, Heigth, DistX, DistY, TagPal);
  MouseSwitchOn;
  repeat
    ChooseKey;
    if Quit then begin
      freemem(undo.pals,768);
      Break;
    end;
    mouseXX:=mousex;
    mouseYY:=mousey;
    if ((mouseyy>= Y)and(mouseyy<= (Y+1)) )and
       ((mousexx>= X)and(mousexx<= ((Width+DistX)*16+X+DistX+1)))
       then begin saveundo; ReMoveWindow; end;{ presun okna }

    if (((mouseyy>=((Heigth+DistY)*16+Y+DistY)))and
       (mouseyy<= ((Heigth+DistY)*16+Y+DistY+1)))and
       ((mousexx>= ((Width+DistX)*16+X-Width))and
       (mousexx<= ((Width+DistX)*16+X+DistX+1)))
       then begin saveundo; ReSizeWindow; end;{Zmena velikonsti}

    if (mouseyy>Y)and(mouseyy<Y+16*Heigth+15*DistY)and
       (mousexx>X)and(mousexx<X+16*Width+15*DistX)
       then InBarKlick {!!!InBar!!!!}
       else begin
      if oldcolor<>PByteArray(Im)^[3+mousexx*PWordArray(Im)^[1]+mouseyy] then
      begin
        MouseSwitchOff;
        if oldcolor=-1 then jak:=TagPal[GetPixel(mousexx, mouseyy)];
        TagPal[GetPixel(mousexx, mouseyy)]:= jak XOR 1;
        ShowTags(X, Y, Width, Heigth, DistX, DistY, TagPal);
        MouseSwitchOn;
        OldColor:=PByteArray(Im)^[3+mousexx*PWordArray(Im)^[1]+mouseyy]; {zde je chyba LukS}
      end;
    end;

  until false; {Pavle co to pises?  ???True=False;???}
  MouseSwitchOff;
  PutImage(0,0,Im);
  MouseSwitchOn;
end;

procedure ProcessCompression(TagPal: TTagArray);
var
  i: byte;
  f: word;
begin
  i:= 0;
  for f:= 0 to 255 do begin
    if TagPal[f]<> 0 then begin
      CnvPal[f]:= i;
      PByteArray(ActualPal)^[i*3]:= PByteArray(ActualPal)^[f*3];
      PByteArray(ActualPal)^[i*3+1]:= PByteArray(ActualPal)^[f*3+1];
      PByteArray(ActualPal)^[i*3+2]:= PByteArray(ActualPal)^[f*3+2];
      Inc(i);
    end else CnvPal[f]:= 255;
  end;
  for f:= i to 255 do begin
    PByteArray(ActualPal)^[f*3]:=  255;
    PByteArray(ActualPal)^[f*3+1]:= 255;
    PByteArray(ActualPal)^[f*3+2]:= 255;
  end;

  for f:= 4 to 64003 do
    PByteArray(Im)^[f]:= CnvPal[PByteArray(Im)^[f]];
end;

procedure ProcessCombination;
var
  i: byte;
  f: word;
begin
  for f:= 0 to 255 do begin
    if TagMirror[f]>0 then begin
      PByteArray(ActualPal)^[(f)*3]:=   PByteArray(MirrorPal)^[f*3];
      PByteArray(ActualPal)^[(f)*3+1]:= PByteArray(MirrorPal)^[f*3+1];
      PByteArray(ActualPal)^[(f)*3+2]:= PByteArray(MirrorPal)^[f*3+2];
    end;
  end;
end;

procedure Reduce;
var OldPalette : pointer;
begin
  MenuX:= 70;
  MenuY:= 20;
  MenuMisc:= 15;
  ChooseFile(PictPath, '*.bmp;*.pcx');
  if UpCase(pictpath[length(pictpath)])= 'P' then TypObr:=BMP else TypObr:=PCX;
  if LoadImage(Im, pointer(ActualPal), PictPath)= 255 then begin
  {nacetl jsem do pameti pozadi}
    SetPalette(ActualPal);
    SetColors(ActualPal);

    MouseSwitchOff;
    PutImage(0, 0, Im);
    FillChar(TagActual, 256, 0);
    FillChar(ColorUse, 256, 0);
{    for f:= 0 to 255 do ColorUse[f]:= 0;
    for f:= 0 to 255 do TagActual[f]:= 0;}
    TagAllUsed(TagActual);
    {spocitam pocet pouziti barev}
{    TagByMouse(TX, TY, 10, 5, 6, 1, TagActual);}
    TagByMouse(TX, TY, TW, TH, TDx, TDy, TagActual);

    SetPalette(Palette);
    SetColors(Palette);
    if standardnidialog('Chceš barvy zredukovat na zacatek?',
    DColor1, DColor2, DColor3, DColor4, DColor5, font, Ano_Ne)= 1 then
      ProcessCompression(TagActual);
    SetPalette(ActualPal);
    ProcessCombination;

    MouseSwitchOff;
    PutImage(0,0,Im);
    SetPalette(ActualPal);
    SetColors(ActualPal);
{    for f:= 0 to 255 do ColorUse[f]:= 0;}
    FillChar(ColorUse, 256, 0);
    for f:= 4 to 64003 do Inc(ColorUse[PByteArray(Im)^[f]]);
    for f:= 0 to 255 do TagActual[f]:= byte(ColorUse[f]>0);
    {spocitam pocet pouziti barev}
    ShowPalette(TX, TY, TW, TH, TDx, TDy);
    ShowTags(TX, TY, TW, TH, TDx, TDy, TagActual);
    MouseSwitchOn;
    repeat until (MouseKey<>0)or(KeyPressed);
    if KeyPressed then ReadKey;
    SetPalette(Palette);
    SetColors(Palette);
    repeat until MouseKey=0;
    SaveImageDialog(Im, ActualPal, PictPath);
    MouseSwitchOff;
    PutImage(0, 0, Im);
    MouseSwitchOn;
    DisposeImage(Im);
    FreeMem(ActualPal, 768);
    SetPalette(Palette);
    SetColors(Palette);
  end;
  MenuMisc:= 2;
end;

procedure Mirror;
begin
  MenuX:= 70;
  MenuY:= 20;
  MenuMisc:= 15;
  ChooseFile(PictPath, '*.bmp;*.pcx');
  if UpCase(pictpath[length(pictpath)])='P' then TypObr:= BMP else TypObr:= PCX;
  if LoadImage(Im, pointer(ActualPal), PictPath)= 255 then begin
    SetPalette(ActualPal);
    SetColors(ActualPal);
    MouseSwitchOff;
    PutImage(0, 0, Im);
{    for f:= 0 to 767 do PByteArray(MirrorPal)^[f]:= PByteArray(ActualPal)^[f];}
    FillChar(TagMirror, 256, 0);
{    for f:= 0 to 255 do TagMirror[f]:= 0;}
    TagByMouse(TX, TY, TW, TH, TDx, TDy, TagMirror);
    Move(ActualPal^, MirrorPal^, 768);
    FreeMem(ActualPal, 768);
    DisposeImage(Im);
  end;
  SetPalette(Palette);
  SetColors(Palette);
  MenuMisc:= 1;
end;

procedure MainMenu;
  procedure Config;
  begin
    MenuMisc:= 1;
    repeat
      MenuX:= 50;
      MenuY:= 50;
      repeat until MouseKey=0;
      MenuMisc:=VytvorMenu('#  Změna konfigurace...|#|'+
        'Nastavit pracovní ~cestu|~Prázdná pracovní cesta|#|'+
        '~Load konfigurace|~Save konfigurace|#|~Zpět',
        DColor1, DColor2, DColor3, DColor4,DColor5, font, MenuX, MenuY,
        MenuMisc, 5);
      case MenuMisc of
        1 : begin
              MenuX:= 70;
              MenuY:= 20;
              MenuMisc:= 15;
              ChooseFile(WorkPath, '');
              MenuMisc:= 1;
            end;
        2 : WorkPath:='';
        3 : LoadCFG;
        4 : SaveCFG;
      end;
    until MenuMisc= 5;
  end;

  procedure About;
  var jmena : array[0..2] of string;
  const i1 : byte = 1;
        i2 : byte = 2;
        i3 : byte = 3;
  begin
{    jmena[1]:='Pavel Pospíšil';
    jmena[0]:='Lukáš Svoboda';
    jmena[2]:='Robert Špalek';
    i1:=random(3);
    repeat
      i3:=random(3);
    until i1<>i3;
    repeat
      i2:=random(3);
    until (i2<>i1)and(i3<>i2);}
    vybermoznost(
    'PALREDUCE '+ProgVersion+'|Redukce a kopírování palety,||'
    +' No Sense||Moveleft (c) 1994, 1995 AD|...no lefts reversed...',
    '~Hmm...',
    DColor1, DColor2, DColor3, DColor4, DColor5, font, 1,1);
  end;
begin
  SetColors(Palette);
  MenuMisc:= 1;
  repeat
    MenuX:= 50;
    MenuY:= 50;
    repeat until MouseKey=0;
    MenuMisc:=VytvorMenu('#  Nástroje pro práci s paletou|'+
      '#|~Načti a označ zrcadlo|~Redukuj a kombinuj se zrcadlem|'+
      'Ulož ~paletu|N~ačti paletu|#|'+
      'Změna kon~figurace|#|Ukaž o~brázek|~O programu|~Konec',
      DColor1, DColor2, DColor3, DColor4,DColor5, font, MenuX, MenuY,
      MenuMisc, 8);
    case MenuMisc of
      1 : Mirror;
      2 : Reduce;
      3 : SavePal;
      4 : LoadPal;
      5 : Config;
      6 : begin
            Show;
            MenuMisc:= 6;
          end;
      7 : About;
    end;
  until MenuMisc= 8;
end;

var StartMem: LongInt;

begin
  StartMem:=MemAvail;
  InitProg;
  repeat
    MainMenu;
  until ( standardnidialog('Chceš opravdu skončit?',
    DColor1, DColor2, DColor3, DColor4, DColor5, font, Ano_Ne) )=1;
  CleaningProg;
  CloseGraph;
  WriteLn('Palette Reduction '+ProgVersion+'                        (c) No Sense 1994, 1995');
  if StartMem<>MemAvail then begin
    Write(#7);
    Writeln(StartMem);
    Writeln(MemAvail);
  end;
end.
