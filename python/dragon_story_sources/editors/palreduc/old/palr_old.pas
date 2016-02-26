(*
{$A+,B-,D-,E+,F-,G+,I-,L-,N-,O-,P-,Q-,R-,S-,T-,V+,X+,Y-}
{$M 16384,70000,655360}
*)

Program PaletteReduction;

 {   * * * ********************************************** * * *    }
 {   * * *          (m) NoSense 2.12.1994                 * * *    }
 {   * * * ********************************************** * * *    }

uses crt, graph256, graform, dfw, dialog, files, editor;

const
  JmenoTohotoProgramu= 'palreduc';
  JmenoPouzitehoFontu= 'stand2.fon';
  ProgVersion= 'V1.4 beta';
  WorkPath: string= '';
type
  TPalArray= array[0..255]of byte;
var
  MenuX, MenuY, MenuMisc: integer;
  PictPath: string;
  DColor1, DColor2, DColor3, DColor4, DColor5: byte;

  MirrorPal, Im, Pal: pointer;
  i, f, g: word;

  TagMirror, TagActual, CnvPal: TPalArray;
  ColorUse: array[0..255]of word;
  typobr : byte; {0 .. bmp / 1..pcx}

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

procedure InitPalReduc; { Inicializuje grafiku, font, mys, paletu ..., promene }
var f : file;
begin
  GetMem(MirrorPal, 768);
  DColor1:= 15;
  DColor2:= 7;
  DColor3:= 12;
  DColor4:= 2;
  DColor5:= 8;

  Assign(f,'PALREDUC.CFG');
  Reset(f,1);
  if ioresult=0 then begin
    BlockRead(f,WorkPath,SizeOf(WorkPath));
    Close(f);
  end;

  if RegisterFont(Font, JmenoPouzitehoFontu) then begin
    WriteLn('! Nemuzu najit '+JmenoPouzitehoFontu+' !');
    Halt(1);
  end;
  if not FileExist(JmenoTohotoProgramu+ '.DAT')then begin
    WriteLn('! Nemuzu najit '+JmenoTohotoProgramu+'.dat !');
    Halt(1);
  end;
  CLoadItem(JmenoTohotoProgramu+ '.DAT', MouseImage, 1);
  CLoadItem(JmenoTohotoProgramu+ '.DAT', pointer(Palette), 2);
  InitGraph;

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

procedure BeforeExitPalReduc;
begin
  MouseOff;
  FreeMem(Palette, 768);
  DisposeImage(MouseImage);
  FreeMem(Font, Font^[0]*Font^[1]*138+140);
  FreeMem(MirrorPal, 768);
end;

procedure SaveCFG;
var f : file;
begin
  Assign(f,'PALREDUC.CFG');
  ReWrite(f,1);
  BlockWrite(f,WorkPath,SizeOf(WorkPath));
  Close(f);
end;

procedure LoadPal;
var Name : string;
    f : file;
begin
  ChooseFile(Name, '.PAL');
  if Name[1]=#27 then exit;
  Assign(f,Name);
  Reset(f,1);
  if ioresult<>0 then exit;
  BlockRead(f, MirrorPal^,768);  {MirrorPal, Im, Pal}
  Close(f);
end;

procedure SavePal;
var Name : string;
    f : file;
begin
  Name:=ReadText(30, 30, 150, ' Zadej jméno souboru: ','');
  Name:=Name+'.Pal';
  Assign(f,WorkPath+Name);
  ReWrite(f,1);
  if ioresult<>0 then exit;
  BlockWrite(f, MirrorPal^, 768);  {MirrorPal, Im, Pal}
  Close(f);
end;

procedure Show;
begin
  MenuX:= 70;
  MenuY:= 20;
  MenuMisc:= 15;
  ChooseFile(PictPath, '*.bmp;*.pcx');
  if UpCase(pictpath[length(pictpath)])='P' then typobr:=0 else typobr:=1;
  if LoadImage(Im, Pal, PictPath)= 255 then begin
  {nacetl jsem do pameti pozadi}
    SetPalette(Pal);
    MouseSwitchOff;
    PutImage(0, 0, Im);
    MouseSwitchOn;
    repeat until (MouseKey<>0)or(KeyPressed and (ReadKey<>#255));
    SetPalette(Palette);
    DisposeImage(Im);
    FreeMem(pal, 768);
  end;
  MenuMisc:= 6;
end;


procedure SaveImageDialog(Image: pointer; Pal: PPalette; Name: string);

  function CheckPath(var path : string):boolean;
  var
     i : byte; { pozice tecky v path}
     konec : string;
  begin
    for i:= 1 to Length(path) do path[i]:= UpCase(path[i]);
    i := Pos('.', path );
    if(i=0) then begin
      if typobr=0 then path := path+ '.BMP'
                  else path := path+ '.PCX';
      i := Pos('.', path );
    end else begin
      i := Pos('.', path );
      Konec:=Copy(path,i+1,length(path)-i);
      if konec='PCX' then TypObr:=1 else
      if konec='BMP' then TypObr:=0 else begin
        delete(path,i,length(path)-i+1);
        if typobr=0 then path := path+ '.BMP'
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
       DColor1, DColor2, DColor3, DColor4, DColor5, font, 1,1) of
    2: PictPath:= Cesta+ReadText(30, 30, 150, ' Zadej jméno souboru: ','');
    3: exit;
  end;
  CheckPath(PictPath);
  SetPalette(Pal);
  if typobr=0 then SaveBMP(Image, Pal, PictPath)
              else SavePCX(Image, Pal, PictPath);
end;

procedure TagAllUsed(var TagPal: TPalArray);
var
  f: word;
begin
  for f:=0 to 255 do ColorUse[f]:=0;
  for f:= 4 to 64003 do Inc(ColorUse[PByteArray(Im)^[f]]);
  for f:= 0 to 255 do if ColorUse[f]>0 then TagPal[f]:= 1;
end;

procedure ClearAll(var TagPal: TPalArray);
var f : byte;
begin
  for f:=0 to 255 do TagPal[f]:= 0;
end;

procedure InversAll(var TagPal: TPalArray);
var f : byte;
begin
  for f:=0 to 255 do if TagPal[f]<>0 then TagPal[f]:=0 else TagPal[f]:=1;
end;

procedure InsertTagBar(var TagPal: TPalArray; x,y : byte; jak : boolean);
const
    MaxC = 12;
var f : byte;
    R, G, B : integer; {nevim jestli je to spravne serazeno (RGB) }
begin
  R:=PPalette(MirrorPal)^[(x+y)*3];
  G:=PPalette(MirrorPal)^[(x+y)*3+1];
  B:=PPalette(MirrorPal)^[(x+y)*3+2];
  for f:=x+y to {x+15}255 do begin
    if (abs(R-PPalette(MirrorPal)^[f*3])<MaxC)and
       (abs(G-PPalette(MirrorPal)^[f*3+1])<MaxC)and
       (abs(B-PPalette(MirrorPal)^[f*3+2])<MaxC)
      then begin
        if jak then TagPal[f]:=1 else TagPal[f]:=0;
        R:=PPalette(MirrorPal)^[f*3];
        G:=PPalette(MirrorPal)^[f*3+1];
        B:=PPalette(MirrorPal)^[f*3+2];
      end else Break;
  end;
  R:=PPalette(MirrorPal)^[(x+y)*3];
  G:=PPalette(MirrorPal)^[(x+y)*3+1];
  B:=PPalette(MirrorPal)^[(x+y)*3+2];
  for f:=x+y downto {x}0 do begin
    if (abs(R-PPalette(MirrorPal)^[f*3])<MaxC)and
       (abs(G-PPalette(MirrorPal)^[f*3+1])<MaxC)and
       (abs(B-PPalette(MirrorPal)^[f*3+2])<MaxC)
      then begin
        if jak then TagPal[f]:=1 else TagPal[f]:=0;
        R:=PPalette(MirrorPal)^[f*3];
        G:=PPalette(MirrorPal)^[f*3+1];
        B:=PPalette(MirrorPal)^[f*3+2];
      end else Break;
  end;
end;

procedure SwapColor(var TagPal: TPalArray; First, Second : byte);
var i : byte;
    i1 : word;
begin
  i:=TagPal[First];
  TagPal[First]:=TagPal[Second];
  TagPal[Second]:=i;

  i:=PPalette(MirrorPal)^[First*3];
  PPalette(MirrorPal)^[First*3]:=PPalette(MirrorPal)^[Second*3];
  PPalette(MirrorPal)^[Second*3]:=i;

  i:=PPalette(MirrorPal)^[First*3+1];
  PPalette(MirrorPal)^[First*3+1]:=PPalette(MirrorPal)^[Second*3+1];
  PPalette(MirrorPal)^[Second*3+1]:=i;

  i:=PPalette(MirrorPal)^[First*3+2];
  PPalette(MirrorPal)^[First*3+2]:=PPalette(MirrorPal)^[Second*3+2];
  PPalette(MirrorPal)^[Second*3+2]:=i;
  for i1:=4 to 64004 do begin
    if (PByteArray(Im)^[i1]=First) then PByteArray(Im)^[i1]:=Second else
    if (PByteArray(Im)^[i1]=Second) then PByteArray(Im)^[i1]:=First;
  end;
end;

procedure SwapSomeColor(var TagPal: TPalArray;  X, Y, Width, Heigth, DistX, DistY : word);
var i1, i2 : byte;
begin
  SetPalette(Palette);
  standardnidialog('Klikni levym talcitkem mysi |na prvni barvu ...',
    DColor1, DColor2, DColor3, DColor4, DColor5, font, upozorneni);
  SetPalette(MirrorPal);
  repeat until (MouseKey<>0)or(KeyPressed);
  repeat until (MouseKey=0)or(KeyPressed);
  if KeyPressed then exit;
  i1:=(MouseX-X)div(Width+DistX)*16+(MouseY-Y)div(Heigth+DistY);
  Write(#7);
  SetPalette(Palette);
  standardnidialog('Klikni levym talcitkem mysi |na druhou barvu ...',
    DColor1, DColor2, DColor3, DColor4, DColor5, font, upozorneni);
  SetPalette(MirrorPal);
  repeat until (MouseKey<>0)or(KeyPressed);
  repeat until (MouseKey=0)or(KeyPressed);
  if KeyPressed then exit;
  i2:=(MouseX-X)div(Width+DistX)*16+(MouseY-Y)div(Heigth+DistY);
  Write(#7);
  SwapColor(TagPal, i1, i2);
  SetPalette(MirrorPal);
  MouseSwitchOff;
  PutImage(0,0,Im);
  MouseSwitchOn;
end;

procedure CompresTagColor(var TagPal: TPalArray;  X, Y, Width, Heigth, DistX, DistY : word; Smer : boolean);
var i1, i2, i3, i5 : byte;
    i4 : integer;
    pole : array[0..255] of byte;
    w : word;

  procedure SwapMyColor(var TagPal: TPalArray; First, Second : byte);
  begin
    i:=PPalette(MirrorPal)^[First*3];
    PPalette(MirrorPal)^[First*3]:=PPalette(MirrorPal)^[Second*3];
    PPalette(MirrorPal)^[Second*3]:=i;

    i:=PPalette(MirrorPal)^[First*3+1];
    PPalette(MirrorPal)^[First*3+1]:=PPalette(MirrorPal)^[Second*3+1];
    PPalette(MirrorPal)^[Second*3+1]:=i;

    i:=PPalette(MirrorPal)^[First*3+2];
    PPalette(MirrorPal)^[First*3+2]:=PPalette(MirrorPal)^[Second*3+2];
    PPalette(MirrorPal)^[Second*3+2]:=i;
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
  SetPalette(MirrorPal);
  repeat until (MouseKey<>0)or(KeyPressed);
  repeat until (MouseKey=0)or(KeyPressed);
  if KeyPressed then exit;
  i1:=(MouseX-X)div(Width+DistX)*16+(MouseY-Y)div(Heigth+DistY);
  Write(#7);
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
    while (TagPal[i3]=0) do if smer then inc(i3) else Dec(i3);
    SwapMyColor(TagPal, i2,i3);
    if smer then inc(i2) else Dec(i2);
    if smer then inc(i3) else Dec(i3);
    SetPalette(MirrorPal);
  end;
  for w:=4 to 64004 do
    PByteArray(Im)^[w]:=pole[PByteArray(Im)^[w]];
  MouseSwitchOff;
  PutImage(0,0,Im);
  MouseSwitchOn;
end;


procedure MoveColor(var TagPal: TPalArray;  X, Y, Width, Heigth, DistX, DistY : word);
var i1, i2 : byte;
begin
  SetPalette(Palette);
  standardnidialog('Klikni levym talcitkem mysi |na prenasenou barvu ...',
    DColor1, DColor2, DColor3, DColor4, DColor5, font, upozorneni);
  SetPalette(MirrorPal);
  repeat until (MouseKey<>0)or(KeyPressed);
  repeat until (MouseKey=0)or(KeyPressed);
  if KeyPressed then exit;
  i1:=(MouseX-X)div(Width+DistX)*16+(MouseY-Y)div(Heigth+DistY);
  Write(#7);
  SetPalette(Palette);
  standardnidialog('Klikni levym talcitkem mysi |na kterou barvu ji chces prenest ...',
    DColor1, DColor2, DColor3, DColor4, DColor5, font, upozorneni);
  SetPalette(MirrorPal);
  repeat until (MouseKey<>0)or(KeyPressed);
  repeat until (MouseKey=0)or(KeyPressed);
  if KeyPressed then exit;
  i2:=(MouseX-X)div(Width+DistX)*16+(MouseY-Y)div(Heigth+DistY);
  Write(#7);
  PPalette(MirrorPal)^[i2*3]:=PPalette(MirrorPal)^[i1*3];
  PPalette(MirrorPal)^[i2*3+1]:=PPalette(MirrorPal)^[i1*3+1];
  PPalette(MirrorPal)^[i2*3+2]:=PPalette(MirrorPal)^[i1*3+2];

  SetPalette(MirrorPal);
  MouseSwitchOff;
  PutImage(0,0,Im);
  MouseSwitchOn;
end;

procedure EditPalette(var TagPal: TPalArray);
  procedure Plus(jak : boolean);
  const Posun = 1;
  var i : byte;
  begin
    for i:=0 to 255 do if TagPal[i]<>0 then begin
      if jak then begin
        if PPalette(MirrorPal)^[i*3]>Posun then Dec(PPalette(MirrorPal)^[i*3],Posun)
        else PPalette(MirrorPal)^[i*3]:=0;
        if PPalette(MirrorPal)^[i*3+1]>Posun then Dec(PPalette(MirrorPal)^[i*3+1],Posun)
        else PPalette(MirrorPal)^[i*3+1]:=0;
        if PPalette(MirrorPal)^[i*3+2]>Posun then Dec(PPalette(MirrorPal)^[i*3+2],Posun)
        else PPalette(MirrorPal)^[i*3+2]:=0;
      end else begin
        if PPalette(MirrorPal)^[i*3]<63-Posun then Inc(PPalette(MirrorPal)^[i*3],Posun)
        else PPalette(MirrorPal)^[i*3]:=63;
        if PPalette(MirrorPal)^[i*3+1]<63-Posun then Inc(PPalette(MirrorPal)^[i*3+1],Posun)
        else PPalette(MirrorPal)^[i*3+1]:=63;
        if PPalette(MirrorPal)^[i*3+2]<63-Posun then Inc(PPalette(MirrorPal)^[i*3+2],Posun)
        else PPalette(MirrorPal)^[i*3+2]:=63;
      end;
    end;
  end;
  procedure Krat(jak : boolean);
  const Posun = 10;
  var i : byte;
  begin
    for i:=0 to 255 do if TagPal[i]<>0 then begin
      if jak then begin
          Inc(PPalette(MirrorPal)^[i*3],PPalette(MirrorPal)^[i*3] div Posun);
          Inc(PPalette(MirrorPal)^[i*3+1],PPalette(MirrorPal)^[i*3+1] div Posun);
          Inc(PPalette(MirrorPal)^[i*3+2],PPalette(MirrorPal)^[i*3+2] div Posun);
          if PPalette(MirrorPal)^[i*3]>63 then PPalette(MirrorPal)^[i*3]:=63;
          if PPalette(MirrorPal)^[i*3+1]>63 then PPalette(MirrorPal)^[i*3+1]:=63;
          if PPalette(MirrorPal)^[i*3+2]>63 then PPalette(MirrorPal)^[i*3+2]:=63;
      end else begin
          Dec(PPalette(MirrorPal)^[i*3],PPalette(MirrorPal)^[i*3] div Posun);
          Dec(PPalette(MirrorPal)^[i*3+1],PPalette(MirrorPal)^[i*3+1] div Posun);
          Dec(PPalette(MirrorPal)^[i*3+2],PPalette(MirrorPal)^[i*3+2] div Posun);
          if PPalette(MirrorPal)^[i*3]>63 then PPalette(MirrorPal)^[i*3]:=0;
          if PPalette(MirrorPal)^[i*3+1]>63 then PPalette(MirrorPal)^[i*3+1]:=0;
          if PPalette(MirrorPal)^[i*3+2]>63 then PPalette(MirrorPal)^[i*3+2]:=0;
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
  Move(MirrorPal^,Save^,768);
  repeat
    if keypressed then Key:=ReadKey else Key:=#0;
    case UpCase(Key) of
      #80 : Plus(true);
      #72 : Plus(false);
      #77 : Krat(true);
      #75 : Krat(false);
      'B' : Move(Save^,MirrorPal^,768);
    end;
    SetPalette(MirrorPal);
  until (Key=#27)or(MouseKey=2);
  FreeMem(Save,768);
end;

procedure ShowPalette(X, Y, Width, Heigth, DistX, DistY: word);
var
  i, j: byte;

  procedure Window;
  begin
    Bar(X-DistX-1, Y-DistY-1, (Width+DistX)*16+DistX+2, (Heigth+DistY)*16+DistY+2, 0);
    Bar(X-DistX, Y-DistY, (Width+DistX)*16+DistX, (Heigth+DistY)*16+DistY, 255);
  end;

begin
  Window;
  for j:= 0 to 15 do begin
    for i:= 0 to 15 do begin
      Bar(X+j*Width+j*DistX, Y+i*Heigth+i*DistY, Width, Heigth, j*16+i);
    end;
  end;
end;

procedure ShowTags(X, Y, Width, Heigth, DistX, DistY: word; TagPal: TPalArray);
var
  i, j: byte;
begin
  for j:= 0 to 15 do begin
    for i:= 0 to 15 do begin
      LineY(X+j*Width+j*DistX+Width, Y+i*Heigth+i*DistY, Heigth, (TagPal[j*16+i] XOR 1)*255);
      LineY(X+j*Width+j*DistX+Width+1, Y+i*Heigth+i*DistY, Heigth, (TagPal[j*16+i] XOR 1)*255);
    end;
  end;
end;

function MyMenu : char;
const MenuX : integer = 50;
      MenuY : integer = 50;
var i : integer;
begin
  SetPalette(Palette);
  i:=VytvorMenu('#Tool:|~Tag|~Clear|~Inverse|(~X) Replace|~Move|~Read Pal|'+
    '~Write Pal|~Palette|~> reduction|~< reduction|~Save|Cancel',
    DColor1, DColor2, DColor3, DColor4,DColor5, font, MenuX, MenuY, 1, 12);
  case i of
    1 : MyMenu:='T';
    2 : MyMenu:='C';
    3 : MyMenu:='I';
    4 : MyMenu:='X';
    5 : MyMenu:='M';
    6 : MyMenu:='R';
    7 : MyMenu:='W';
    8 : MyMenu:='P';
    9 : MyMenu:='>';
    10 : MyMenu:='<';
    11 : MyMenu:='S';
    12 : MyMenu:=#0;
  end;
  SetPalette(MirrorPal);
end;

procedure TagByMouse(X, Y, Width, Heigth, DistX, DistY: word;var TagPal: TPalArray);
var
  HotKey: char;
  OldColor : integer;
  RunMenu, Quit : boolean;
begin
  RunMenu:=False;
  Quit:=false;
  ShowPalette(10, 10, 10, 5, 6, 1);
  ShowTags(10, 10, 10, 5, 6, 1, TagActual);
  MouseSwitchOn;
  repeat
    repeat
      if MouseKey=2 then begin
        repeat
          if MouseKey=3 then RunMenu:=true;
        until (MouseKey=0)or(RunMenu);
        if not RunMenu then Quit:=true;
      end;
      if KeyPressed then HotKey:= ReadKey else HotKey:=#0;
      if (HotKey=#13)or(RunMenu) then begin
        repeat until MouseKey=0;
        HotKey:=MyMenu;
        RunMenu:=false;
      end;
      case UpCase(HotKey) of
        #59 : begin
                {HELP}
                SetPalette(Palette);
                vybermoznost('PALREDUCE '+ProgVersion+'||T ... Oznaci akt. barvy|'+
                  'C ... Odoznaci|I ... Zinverzuje |'+
                  '+ ... Ozanci podobne |  - ... Odoznaci podobne |'+
                  'X ... Prehodi|M ... Prenese b.|P ... Prace s paletou|'+
                  '> ... Zredukuje doprava|< ... Zredukuje doleva |'+
                  'S ... Ulozeni obr.|R/W nacte/zapise paletu',
                  '~Ajóóó!!!!', DColor1, DColor2, DColor3, DColor4, DColor5, font, 1,1);
                SetPalette(MirrorPal);
              end;
        'P' : begin
                EditPalette(TagPal);
                MouseSwitchOff;
                ShowPalette(10, 10, 10, 5, 6, 1);
                ShowTags(X, Y, Width, Heigth, DistX, DistY, TagPal);
                MouseSwitchOn;
              end;
        'S' : begin
                SaveImageDialog(Im, MirrorPal, PictPath);
                SetPalette(MirrorPal);
              end;
        'R' : begin
                LoadPal;
                SetPalette(MirrorPal);
              end;
        'W' : SavePal;
        'X' : begin
                SwapSomeColor(TagPal, X, Y, Width, Heigth, DistX, DistY);
                MouseSwitchOff;
                ShowPalette(10, 10, 10, 5, 6, 1);
                ShowTags(X, Y, Width, Heigth, DistX, DistY, TagPal);
                MouseSwitchOn;
              end;
        '>' : begin
                CompresTagColor(TagPal, X, Y, Width, Heigth, DistX, DistY, true);
                MouseSwitchOff;
                ShowPalette(10, 10, 10, 5, 6, 1);
                ShowTags(X, Y, Width, Heigth, DistX, DistY, TagPal);
                MouseSwitchOn;
              end;
        '<' : begin
                CompresTagColor(TagPal, X, Y, Width, Heigth, DistX, DistY, false);
                MouseSwitchOff;
                ShowPalette(10, 10, 10, 5, 6, 1);
                ShowTags(X, Y, Width, Heigth, DistX, DistY, TagPal);
                MouseSwitchOn;
              end;
        'M' : begin
                MoveColor(TagPal, X, Y, Width, Heigth, DistX, DistY);
                MouseSwitchOff;
                ShowPalette(10, 10, 10, 5, 6, 1);
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
        #43 : if (MouseY>=Y)and(MouseY<Y+16*Heigth+15*DistY)and
                (MouseX>=X)and(MouseX<X+16*Width+15*DistX)then begin
                MouseSwitchOff;
                InsertTagBar(TagPal,(MouseX-X)div(Width+DistX)*16,
                           (MouseY-Y)div(Heigth+DistY), true);
                ShowTags(X, Y, Width, Heigth, DistX, DistY, TagPal);
                MouseSwitchOn;
              end;
        #45 : if (MouseY>=Y)and(MouseY<Y+16*Heigth+15*DistY)and
                (MouseX>=X)and(MouseX<X+16*Width+15*DistX)then begin
                MouseSwitchOff;
                InsertTagBar(TagPal,(MouseX-X)div(Width+DistX)*16,
                           (MouseY-Y)div(Heigth+DistY), false);
                ShowTags(X, Y, Width, Heigth, DistX, DistY, TagPal);
                MouseSwitchOn;
              end;
        #27: Quit:=true;
      end;
    if MouseKey=0 then OldColor:=-1;
    until (MouseKey=1)or Quit;
      if Quit then Break; {LS -Pospec tam mel 4 ???}
      if (MouseX-X)div(Width+DistX)*16+(MouseY-Y)div(Heigth+DistY)<>OldColor then begin
        if (MouseY>=Y)and(MouseY<Y+16*Heigth+15*DistY)and
        (MouseX>=X)and(MouseX<X+16*Width+15*DistX)then begin
            TagPal[(MouseX-X)div(Width+DistX)*16+(MouseY-Y)div(Heigth+DistY)]:=
              TagPal[(MouseX-X)div(Width+DistX)*16+(MouseY-Y)div(Heigth+DistY)] XOR 1;
            OldColor:=(MouseX-X)div(Width+DistX)*16+(MouseY-Y)div(Heigth+DistY);
          end else begin
            MouseSwitchOff;
            TagPal[GetPixel(MouseX, MouseY)]:= TagPal[GetPixel(MouseX, MouseY)] XOR 1;
            ShowTags(X, Y, Width, Heigth, DistX, DistY, TagPal);
            MouseSwitchOn;
            OldColor:=(MouseX-X)div(Width+DistX)*16+(MouseY-Y)div(Heigth+DistY);
          end;
          MouseSwitchOff;
          ShowTags(X, Y, Width, Heigth, DistX, DistY, TagPal);
          MouseSwitchOn;
        end;
  until True=False;
  MouseSwitchOff;
  PutImage(0,0,Im);
  MouseSwitchOn;
end;

procedure ProcessCompression(TagPal: TPalArray);
var
  i: byte;
  f: word;
begin
  i:= 0;
  for f:= 0 to 255 do begin
    if TagPal[f]<> 0 then begin
      CnvPal[f]:= i;
      PByteArray(Pal)^[i*3]:= PByteArray(Pal)^[f*3];
      PByteArray(Pal)^[i*3+1]:= PByteArray(Pal)^[f*3+1];
      PByteArray(Pal)^[i*3+2]:= PByteArray(Pal)^[f*3+2];
      Inc(i);
    end else CnvPal[f]:= 255;
  end;
  for f:= i to 255 do begin
    PByteArray(Pal)^[f*3]:=  255;
    PByteArray(Pal)^[f*3+1]:= 255;
    PByteArray(Pal)^[f*3+2]:= 255;
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
      PByteArray(Pal)^[(f)*3]:=   PByteArray(MirrorPal)^[f*3];
      PByteArray(Pal)^[(f)*3+1]:= PByteArray(MirrorPal)^[f*3+1];
      PByteArray(Pal)^[(f)*3+2]:= PByteArray(MirrorPal)^[f*3+2];
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
  if UpCase(pictpath[length(pictpath)])='P' then typobr:=0 else typobr:=1;
  if LoadImage(Im, Pal, PictPath)= 255 then begin
  {nacetl jsem do pameti pozadi}
    SetPalette(Pal);
    MouseSwitchOff;
    PutImage(0, 0, Im);

    for f:= 0 to 255 do ColorUse[f]:= 0;
    for f:= 0 to 255 do TagActual[f]:= 0;
    TagAllUsed(TagActual);
    {spocitam pocet pouziti barev}
    OldPalette:=MirrorPal;
    MirrorPal:=Pal;
    TagByMouse(10, 10, 10, 5, 6, 1, TagActual);
    MirrorPal:=OldPalette;

    SetPalette(Palette);
    if standardnidialog('Chceš barvy zredukovat na zacatek?',
    DColor1, DColor2, DColor3, DColor4, DColor5, font, Ano_Ne) =1 then
      ProcessCompression(TagActual);
    SetPalette(Pal);
    ProcessCombination;

    MouseSwitchOff;
    PutImage(0,0,Im);
    SetPalette(Pal);
    for f:= 0 to 255 do ColorUse[f]:= 0;
    for f:= 4 to 64003 do Inc(ColorUse[PByteArray(Im)^[f]]);
    for f:= 0 to 255 do TagActual[f]:= byte(ColorUse[f]>0);
    {spocitam pocet pouziti barev}
    ShowPalette(10, 10, 10, 5, 6, 1);
    ShowTags(10, 10, 10, 5, 6, 1, TagActual);
    MouseSwitchOn;
{    TagByMouse(10, 10, 10, 5, 6, 1, TagActual);}

    repeat until (MouseKey<>0)or(KeyPressed);
    if KeyPressed then ReadKey;
    SetPalette(Palette);
    repeat until MouseKey=0;
    SaveImageDialog(Im, {Mirror}Pal, PictPath);
    MouseSwitchOff;
    PutImage(0,0,Im);
    MouseSwitchOn;
    DisposeImage(Im);
    FreeMem(pal, 768);
    SetPalette(Palette);
  end;
  MenuMisc:= 2;
end;

procedure Mirror;
begin
  MenuX:= 70;
  MenuY:= 20;
  MenuMisc:= 15;
  ChooseFile(PictPath, '*.bmp;*.pcx');
  if UpCase(pictpath[length(pictpath)])='P' then typobr:=0 else typobr:=1;
  if LoadImage(Im, Pal, PictPath)= 255 then begin
    SetPalette(Pal);
    MouseSwitchOff;
    PutImage(0, 0, Im);
    for f:= 0 to 767 do PByteArray(MirrorPal)^[f]:= PByteArray(Pal)^[f];
    for f:= 0 to 255 do TagMirror[f]:= 0;
    TagByMouse(10, 10, 10, 5, 6, 1, TagMirror);
    FreeMem(Pal, 768);
    DisposeImage(Im);
  end;
  SetPalette(Palette);
  MenuMisc:= 1;
end;

procedure MainMenu;
  procedure About;
  var jmena : array[0..2] of string;
  const i1 : byte = 1;
        i2 : byte = 2;
        i3 : byte = 3;
  begin
    jmena[1]:='Pavel Pospíšil';
    jmena[0]:='Lukáš Svoboda';
    jmena[2]:='Robert Špalek';
    i1:=random(3);
    repeat
      i3:=random(3);
    until i1<>i3;
    repeat
      i2:=random(3);
    until (i2<>i1)and(i3<>i2);
    vybermoznost(
    'PALREDUCE '+ProgVersion+'|Redukce a kopírování palety|u obrázků BMP|Naprogramovali '
    +jmena[i1]+'| '+jmena[i2]+' ,'+jmena[i3]+
    ', No Sense|MoveLeft (m) 1994AD|no lefts reversed',
    '~Hmm...',
    DColor1, DColor2, DColor3, DColor4, DColor5, font, 1,1);
  end;
begin
  repeat
    MenuX:= 50;
    MenuY:= 50;
    MenuMisc:= 1;
    repeat until MouseKey=0;
    MenuMisc:=VytvorMenu('#    Palette reduce & combine|'+
      '#|~Načti a označ zrcadlo|~Redukuj a kombinuj se zrcadlem|'+
      'Ulož ~paletu|N~ačti paletu|#|Nastav si pracovní ~cestu|'+
      '~Ulož si pracovní cestu|#|Ukaž o~brázek|~O programu|~Konec',
      DColor1, DColor2, DColor3, DColor4,DColor5, font, MenuX, MenuY,
      MenuMisc, 9);
    case MenuMisc of
      1 : Mirror;
      2 : Reduce;
      3 : SavePal;
      4 : LoadPal;
      5 : begin
            MenuX:= 70;
            MenuY:= 20;
            MenuMisc:= 15;
            ChooseFile(WorkPath, '');
{            WorkPath:= vybersouboru(MenuX, MenuY, MenuMisc,
              DColor1, DColor2, DColor3, DColor4, DColor5, Font,
              trid_jmena, WorkPath, '');}
            MenuMisc:= 3;
          end;
      6 : SaveCFG;
      7 : Show;
      8 : About;
    end;
  until MenuMisc= 9;
end;

var StartMem : LongInt;

begin
  StartMem:=MemAvail;
  InitPalReduc;
  repeat
    MainMenu;
  until ( standardnidialog('Chceš opravdu skončit?',
    DColor1, DColor2, DColor3, DColor4, DColor5, font, Ano_Ne) )=1;
  BeforeExitPalReduc;
  CloseGraph;
  WriteLn('Palette Reduction '+ProgVersion+'                      (c) No Sense 1994, 1995');
  if StartMem<>MemAvail then Write(#7);
end.