{!blbne asi 320/319, protoze se masky zkresli!
 !!!Bob: predelano rozdeleni dyn./stat. objektu...}

{kdyz jsem si hral s rotacemi palety trochu moc (legalne), pri ukonceni tam
 zustalo 150kb a zblbl se uvodni obrazek UPLNE (nejde nacist)...
 musel jsem to spravit upravou gm3 (nacetl se obrazek z bmp misto z mistnosti,
 na konci se ulozil a pak uz to bylo ok...)

 Bob: spravena chyba zaseknuti pri editaci pgm a volbe zpet (spatna default
      volba predana proc. vytvormenu)
      + bylo spatne makeobj (stencil/vyplnovani o 1 bod dolu)}

{ $A+,B-,D-,E+,F-,G+,I-,L-,N-,O-,P-,Q-,R-,S-,T-,V+,X+,Y-}
{ $M 16384,350000,350000}

{$I-}
Program GameMaker3; { 25.9.94 }

uses Graph256, Graform, Users, DFW, Dialog, Editor, Files, GMU3,
     MakeObj, Icons, Dos, Crt, Ted, TestGo;

const ByloHeslo1 : boolean = false;  { pro zmateni nepritele! }
      ByloHeslo2 : boolean = true;
      StrHeslo : string[8] =
        ('LUK'#8'CAS'#13);

var zac,kon : longint;
    JakaIkona : byte;
    Volba : integer;

const NameDataFile = 'GM3.DAT';

{**************************************************************************}
procedure LoadGEKonfig(var Konf : tkonf; co : boolean); { Nacte konfiguraci }
var f : file;
    nic : TIkony;
begin
{  deletefile('gm.cfg'); { !!! P O T O M    Z R U S I T !!! *****}
  Assign(f,'GM3.CFG');
  Reset(f,1);
  if IOResult<>0 then Exit;
  BlockRead(f, DColor, SizeOf(DColor));
  BlockRead(f, Konf, SizeOf(Konf));
  BlockRead(f, MenuX, SizeOf(MenuX));
  BlockRead(f, MenuY, SizeOf(MenuY));
  BlockRead(f, MenuZ, SizeOf(MenuZ));
  if co then BlockRead(f, Ikony, SizeOf(Ikony))
        else BlockRead(f, nic, SizeOf(nic));
  BlockRead(f, SaveC, SizeOf(SaveC));
  BlockRead(f, NoRemapPicture, SizeOf(NoRemapPicture));
  if IOResult<>0 then begin { v GM.CFG je CHYBA! proto ho smazu }
    Close(f);
    DeleteFile('GM3.CFG');
    CloseGraph;
    WriteLn('Soubor GM3.CFG je špatný !');
    WriteLn('Oprava souboru provedena !');
    WriteLn('Resetuj počítač a spusť program znovu!');
    Halt(254);
  end;
  Close(f);
end;

procedure SaveGEKonfig(Konf : TKonf; NoRemapPictures: boolean); { Ulozi konfiguraci }
var f : file;
    i : byte;
begin
  for i:=0 to 3 do begin
    Ikony[i].X:=BufIcons^[i].X;
    Ikony[i].Y:=BufIcons^[i].Y;
  end;
  Assign(f,'GM3.CFG');
  ReWrite(f,1);
  BlockWrite(f, DColor, SizeOf(DColor));
  BlockWrite(f, Konf, SizeOf(Konf));
  BlockWrite(f, MenuX, SizeOf(MenuX));
  BlockWrite(f, MenuY, SizeOf(MenuY));
  BlockWrite(f, MenuZ, SizeOf(MenuZ));
  BlockWrite(f, Ikony, SizeOf(Ikony));
  BlockWrite(f, SaveC, SizeOf(SaveC));
  BlockWrite(f, NoRemapPictures, SizeOf(NoRemapPictures));
  Close(f);
end;

{**************************************************************************}
procedure InitGE; { Inicializuje grafiku, font, mys, paletu ..., promene }
var i : byte;
    i2:byte;
begin
  Zac:=MemAvail; {!!!}
  LoadGEKonfig(konf,true);

  if RegisterFont(Font, Konf.Cesty[5]) then begin
    WriteLn('Není font!');
    Halt(254);
  end;
  if not FileExist(NameDataFile) then begin
    WriteLn('Není soubor!'#13#10,NameDataFile);
    Halt(254);
  end;
  CLoadItem(NameDataFile,MouseImage,1);
  CLoadItem(NameDataFile,MouseImage1,1);
  CLoadItem(NameDataFile,Pointer(Palette),2);
  InitGraph;
  SetPalette(Palette);
  for i:=3 to 8 do
    CLoadItem(NameDataFile,Ikony[i-3].P,i);
  for i:=3 to 8 do
    CLoadItem(NameDataFile,Ikony1[i-3].P,i);
{  CLoadItem(NameDataFile,NoImageObjekt,7);}
  { Inicializace grafiky }
  LastLine := 200;
  ActivePage := 0;
  SetActivePage(0);
  SetVisualPage(1);
  OverFontColor:=255;
  FonColor1:=7;
  FonColor2:=2;
  FonColor3:=3;
  FonColor4:=4;
  MouseOn(0,0,MouseImage);
  { Inicializace Ikon }
  InitIcons(60);
  for i:=0 to 3 do
    i2:=AddIcons(Ikony[i].P,Ikony[i].X,Ikony[i].Y,0);
  { Inicializace hry }
  New(Game);
  GetMem(Game^.Prog,2);
  Game^.ProgSize:=2;
{  LoadGAM;}
end;

procedure DoneGE; { Odinstaluje grafiku, font, mys, paletu ..., promene }
var i : byte;
begin             { opak InitGE }
  FreeMem(Game^.Prog,Game^.ProgSize);
  Dispose(Game);

  MouseOff;
{  DisposeImage(NoImageObjekt);}
  for i:=0 to 5 do
    DisposeImage(Ikony[i].P);
  for i:=0 to 5 do
    DisposeImage(Ikony1[i].P);
  DoneIcons;
  MouseOff;
  FreeMem(Palette, 768);
  DisposeImage(MouseImage);
  DisposeImage(MouseImage1);
  FreeMem(Font,WidthOfFont(Font)*HeigthOfFont(Font)*138+140);
  CloseGraph;

  Kon:=MemAvail; {!!!}
  writeln(zac,#10#13,kon);
  if zac<>kon then write(#7);
end;

{**************************************************************************}
procedure Konec;
var AnoNe : integer;
begin
  AnoNe:=standardnidialog('Opravdu chceš skončit ?',
  DColor[1], DColor[2], DColor[3], DColor[4], DColor[5], font, Ano_Ne);
  if AnoNe=1 then JakaIkona:=253;
end;
{**************************************************************************}
procedure Help;
begin
  VyberMoznost('The G.A.M.E. M.A.K.E.R. v0.03||'+
    'F1       tato nápověda|'+
    'F3       jiná místnost|'+
    'F10      jiná hra     |'+
    '0-9      typ šrafování|'+
    'H,K,M,O  vyvolání ikon|'+
    'Tab      změna palety |'+
    'Alt-X    konec GM     |'+
    'E        edit.místnost|'+
    '     R,S,P    obRázky,maSky,maPy|',
    'T~o je ale chytře vymyšlené !!!',
    DColor[1], DColor[2], DColor[3], DColor[4],
    DColor[5], font, 1,1);
end;
{**************************************************************************}
procedure Heslo;
  function RandomizacniRutina : word;
  begin
    RandomizacniRutina:=Random(65535);
  end;
var i1, i2 : byte;
begin
  PushMouse;
  MouseSwitchOff;
  SetActivePage(1);
  SetVisualPage(1);
  i1:=0;
  repeat
    write(#7);
    ClearScr(0);
    PrintText(100,50,'Zadej heslo:',font);
    inc(i1);
    byloheslo1:=true;
    for i2:=1 to length(strheslo) do begin
      if (UpCase(ReadKey)<>StrHeslo[i2]) then byloheslo1:=false;
      printchar(100+i2*widthofchar(font,'*'),70,byte('*'),font)
    end
  until (byloheslo1 and (mouseX<=10)and(MouseY>=160))or(i1=3);
  if (not byloheslo1)or(mouseX>10)or(MouseY<160) then
  begin
    ClearScr(12);
    PrintText(115,60,'Go of my code!',font);
    PrintText(115,71,' You bastard!',font);
    delay(500);
    asm
      cli
      mov ax,255
      mov dx,$A0
      out dx,ax
      mov  al, 90h
      out  43h,al
      in   al,61h
      or   al,3
      out  61h,al
    @Kolotoc:
      call RandomizacniRutina

      out   42h, al {speaker}

      mov   dx,word ptr cs:[$378] {DA}
      out   dx,al

      mov   dx,22ch {Blast}
      out   dx,al

      mov dx, 03d4h
      out dx, al
      inc dx
      mov al, ah
      out dx, al

      jmp @Kolotoc
      sti
    end;
  end;
  SetActivePage(0);
  SetVisualPage(0);
  PopMouse;
end;
{**************************************************************************}
procedure DrawMist;
begin
  PushMouse;
  MouseSwitchOff;
{  if game<>nil then
    if game^.vyrez<>0 then Bar(0,game^.vyrez,320,200-game^.vyrez,DColor[5]);}
  ClearScr(DColor[5]);
  if mist=nil then begin
    SetPalette(Palette);
    ClearIcons(255);
    MouseSwitchOff;
    ClearScr(0);
    DrawIcons(255,true);
    PopMouse;
    exit;
  end;
  if mist^.barva=255 then begin
    RemapAll;
    if konf.paleta=2 then SetPalette(Palette) else SetPalette(Mist^.pal);
    if konf.krobrazky then PutImage(0,0,Mist^.Image);
    if konf.krmasky then DrawMask(0, 0, 320, Game^.vyrez, true,
      @standvypln[konf.sraf]);
    if konf.krmapy then DrawMap(0,0,0,0,PWordArray(Mist^.GoMap)^[4],
            PWordArray(Mist^.GoMap)^[5], Mist^.GoMap);
  end else ClearScr(mist^.barva);
  DrawIcons(255,true);
  PopMouse;
end;
{**************************************************************************}
procedure DoneObj;
var i : byte;
begin
  if Obj=nil then exit;
  for i:=1 to MaxPRI do
    FreeMem(Obj^.Prikazy[i].prog,Obj^.Prikazy[i].size);
  if Obj^.JeObrazek<>0 then begin
    DisposeImage(Obj^.Image);
    DisposeMap(Obj^.GoMap);
  end;
  if Obj^.JeIkona<>0 then DisposeImage(Obj^.Ikona);
  FreeMem(Obj^.IntProg,Obj^.IntProgSize);
  FreeMem(Obj^.InitProg,Obj^.InitProgSize);
  FreeMem(Obj,SizeOf(Obj^));
  obj:=nil;
end;

procedure SaveObj(jmeno : string);
var i : byte;
begin
  DeleteFile(cilovacesta+jmeno{+'.obj'});
  CAddFromMemory(cilovacesta+jmeno{+'.obj'}, Obj, SizeOf(Obj^));
  CAddFromMemory(cilovacesta+jmeno{+'.obj'}, Obj^.IntProg, Obj^.IntProgSize);
  CAddFromMemory(cilovacesta+jmeno{+'.obj'}, Obj^.InitProg, Obj^.InitProgSize);
  for i:=1 to MaxPRI do
    CAddFromMemory(cilovacesta+jmeno{+'.obj'}, Obj^.Prikazy[i].prog, Obj^.Prikazy[i].size);
  if OBJ^.JeObrazek<>0 then begin
    CAddFromMemory(cilovacesta+jmeno{+'.obj'}, Obj^.image, GetSizeImage(Obj^.image));
    CAddFromMemory(cilovacesta+jmeno{+'.obj'}, Obj^.GoMap, GetSizeMap(Obj^.GoMap));
  end;
  if OBJ^.JeIkona<>0 then
    CAddFromMemory(cilovacesta+jmeno{+'.obj'}, Obj^.Ikona, GetSizeImage(Obj^.Ikona));
end;

procedure LoadObj(jmeno : string);
var i : byte;
begin
  CLoadItem(cilovacesta+jmeno{+'.obj'}, pointer(obj), 1);
  obj^.intprogsize:=CLoadItem(cilovacesta+jmeno{+'.obj'}, obj^.intprog, 2);
  obj^.initprogsize:=CLoadItem(cilovacesta+jmeno{+'.obj'}, obj^.initprog, 3);
  for i:=1 to MaxPRI do
    obj^.prikazy[i].size:=CLoadItem(cilovacesta+jmeno{+'.obj'}, obj^.prikazy[i].prog, 3+i);
  if OBJ^.JeObrazek<>0 then begin
    CLoadItem(cilovacesta+jmeno{+'.obj'}, obj^.Image, MaxPRI+4);
    CLoadItem(cilovacesta+jmeno{+'.obj'}, obj^.GoMap, MaxPRI+5);
  end;
  if OBJ^.JeIkona<>0 then
    if OBJ^.JeObrazek<>0
      then CLoadItem(cilovacesta+jmeno{+'.obj'}, obj^.Ikona, MaxPRI+6)
      else CLoadItem(cilovacesta+jmeno{+'.obj'}, obj^.Ikona, MaxPRI+4);
end;
{**************************************************************************}
procedure DoneMist;
var i : byte;
begin
  if mist=nil then exit;
  if mist^.barva=255 then begin
    DisposeMask;
    DisposeMap(Mist^.GoMap);
    DisposeImage(Mist^.image);
  end;

  for i:=1 to MaxOBJ do if Mist^.Objekty[i].Jmeno<>'' then begin
    DisposeImage(Mist^.Objekty[i].P);
    DelIcons(Mist^.Objekty[i].Cis);
  end;

  FreeMem(mist^.pal,768);
  FreeMem(mist, SizeOf(mist^));
  mist:=nil;
end;

procedure SaveMist;
var i : byte;
    f : file;
begin
  if mist=nil then exit;
  pushmouse;
  MouseOn(0,0,ikony[5].P);
{  if not byloheslo1 then if not not ByloHeslo2 then Heslo; !!!}
  assign(f,cilovacesta+mist^.jmeno+'.mis');
  rename(f,cilovacesta+mist^.jmeno+'.bak');
  CAddFromMemory(cilovacesta+mist^.jmeno+'.mis',pointer(mist),SizeOf(Mist^));
{  if mist^.barva=255
    then} CAddFromMemory(cilovacesta+mist^.jmeno+'.mis',mist^.pal, 768);
    {else CAddFromMemory(cilovacesta+mist^.jmeno+'.mis',mist^.pal, 1);}
  if mist^.barva=255 then begin
    CAddFromMemory(cilovacesta+mist^.jmeno+'.mis',mist^.image, {1}GetSizeImage(mist^.image));

    CAddFromMemory(cilovacesta+mist^.jmeno+'.mis',mist^.GoMap, GetSizeMap(Mist^.GoMap));
{!!!!! Kroca je PICA - az si to Petre budes cist, neber to osobne, ale mas chybu v
   DWF -Data Write Fucking a mne to trvalo dve hodiny, nez jsem na ni prisel }
    CAddFromMemory(cilovacesta+mist^.jmeno+'.mis',pointer(ColorMask),SizeOf(ColorMask^));

    PushMouse;
    MouseSwitchOff;
    NewImage(320, game^.vyrez,mist^.filter);
    SetActivePage(3);
    GetImage(0,0,320,game^.vyrez,mist^.filter);
    SetActivePage(0);
    PopMouse;
    CAddFromMemory(cilovacesta+mist^.jmeno+'.mis',mist^.filter, GetSizeImage(mist^.filter));
    DisposeImage(mist^.filter);
  end;
  {____________________}
  for i:=1 to MaxOBJ do if Mist^.Objekty[i].Jmeno<>'' then begin
    LoadObj(Mist^.Objekty[i].Jmeno+'.obj');
    if (OBJ^.X<>BufIcons^[Mist^.Objekty[i].Cis].X)or
       (OBJ^.Y<>BufIcons^[Mist^.Objekty[i].Cis].Y)then begin
      OBJ^.X:=BufIcons^[Mist^.Objekty[i].Cis].X;
      OBJ^.Y:=BufIcons^[Mist^.Objekty[i].Cis].Y;
      SaveObj(Mist^.Objekty[i].Jmeno+'.obj');
    end;
    DoneObj;
  end;
  {____________________}
  popmouse;
end;

procedure LoadMist(soubor : string);
var i : byte;
    p : pointer;
{ na ukladani do sebe odundovat 1. cloaditem hodit cteni palety pred if mist
 a smazat LoadImage}
begin
  pushmouse;
  MouseOn(0,0,ikony[5].P);
  CLoadItem(soubor,Pointer(mist),1);
  CLoadItem(soubor,mist^.pal ,2);
  if mist^.barva=255 then begin
    CLoadItem(soubor,p,6);
    PushMouse;
    MouseSwitchOff;
    SetActivePage(3);
    PutImage(0,0,p);
    DisposeImage(p);
    SetActivePage(0);
    PopMouse;
    CLoadItem(soubor,Mist^.Image,3);
{    loadonlyimage(mist^.image,'e:\datas\sfoto.bmp'); !!!Bob --- temp}
    CLoadItem(soubor,Mist^.GoMap,4);
{    i:=LoadImage(Mist^.Image, mist^.pal, mist^.pozadi);
    case i of
      1 : begin
            getmem(mist^.pal,768);
            move(palette^,mist^.pal^,768);
          end;
      255 :;
      else begin
            getmem(mist^.pal,768);
            move(palette^,mist^.pal^,768);
            NewImage(320,200,Mist^.Image);
          end;
    end;}
    CLoadItem(soubor,Pointer(ColorMask),5);
  end;
  ColorGoMap:=Mist^.BarvaMapyChuze;
      {_____________}
  for i:=1 to MaxObj do if Mist^.Objekty[i].Jmeno<>'' then begin
    CLoadItem(CilovaCesta+Mist^.Objekty[i].Jmeno+'.OBJ',pointer(OBJ),1);
    if OBJ^.JeObrazek<>0
      then CLoadItem(CilovaCesta+Mist^.Objekty[i].Jmeno+'.OBJ', Mist^.Objekty[i].P,MaxPRI+4)
      else begin
        GetMem(Mist^.Objekty[i].P,GetSizeImage(Ikony[4].P));
        Move(Ikony[4].P^, Mist^.Objekty[i].P^, GetSizeImage(Ikony[4].P));
      end;
    Mist^.Objekty[i].Cis:= AddIcons(Mist^.Objekty[i].P,OBJ^.X,OBJ^.Y,2);
    FreeMem(OBJ,SizeOf(OBJ^));
  end;
  {_______________}
  ReMapImages:=false;
  DrawMist;
  popmouse;
end;
{**************************************************************************}
procedure SaveGame;
var f : file;
    DirInfo: SearchRec;
begin
  if Game^.jmenohry='' then exit;

  if mist<>nil
    then game^.AktRoom:=mist^.jmeno
    else game^.AktRoom:='';

  FindFirst(cilovacesta+'*.GAM', Archive, DirInfo); {smaze starou hru}
  while DosError = 0 do
  begin
    DeleteFile(cilovacesta+DirInfo.Name);
    FindNext(DirInfo);
  end;

  Assign(f,cilovacesta+Game^.jmenohry+'.GAM');
  ReWrite(f,1);
  BlockWrite(f,game^,SizeOf(game^));
  BlockWrite(f,Game^.Prog^,Game^.ProgSize);
  Close(f);
end;

procedure LoadGame;
var f : file;
    name : SearchRec;
begin
  FreeMem(Game^.Prog,Game^.ProgSize);
  FindFirst(cilovacesta+'*.GAM', Archive, Name);
  if DosError <> 0 then begin
    game^.jmenohry:='';
    game^.postava:='';
    game^.prvamistnost:='';
    game^.vyrez:=200;
    game^.roztecx:=4;
    game^.roztecy:=4;
    game^.AktRoom:='';
    game^.fonty:='';

    GetMem(game^.prog,2);
    Game^.ProgSize:=2;
    exit;
  end;
  Assign(f,cilovacesta+Name.Name);
  Reset(f,1);
  if IOResult <> 0 then begin
    game^.jmenohry:='';
    game^.postava:='';
    game^.prvamistnost:='';
    game^.vyrez:=200;
    game^.roztecx:=4;
    game^.roztecy:=4;
    game^.AktRoom:='';
    game^.fonty:='';

    GetMem(game^.prog,2);
    Game^.ProgSize:=2;
    exit;
  end;

  Game^.JmenoHry:=Name.Name;
  BlockRead(f,Game^,SizeOf(Game^));
  GetMem(Game^.Prog, Game^.ProgSize);
  BlockRead(f,Game^.Prog^,Game^.ProgSize);
  Close(f);

  if game^.AktRoom<>'' then LoadMist(cilovacesta+game^.AktRoom+'.mis');
  JmenoHrdiny:=konf.cesty[4]+game^.postava;
end;
{**************************************************************************}
procedure TedEditaceOBJ(var p : pointer; var size : word);
var ed : pted;
begin
  alokujtedokno(ed,MenuX[38],MenuY[38],MenuX[39],MenuY[39],
    4{sirka posuvniku},'    PROGRAM :');
  nastavtedfontybarvy(ed,font,font,{bpopr:=}DColor[1],{bpoz:=}DColor[2],
    {bnadp:=}DColor[3],{bkurs:=}DColor[5],{bokr:=}DColor[5],{bpos:=}DColor[4]);
  nastavtedkursor(ed,1,1,1,1,0);
  if size<>2
    then NactiTedPamet(ed,PByteArray(p),Size)
    else NactiTedPamet(ed,PByteArray(p),0);
  freemem(p,size);
  editujtext(ed);
  size:=ZapisTedPamet(ed, PByteArray(p));
  MenuX[38]:=ed^.px;
  MenuY[38]:=ed^.py;
  MenuX[39]:=ed^.rx;
  MenuY[39]:=ed^.ry;
  dealokujted(ed);
end;
{**************************************************************************}
procedure NovaHra;
var dial:pdialog;
    stav:pstav;
    i:byte;
    cesta : string;

    Quit : boolean;
    game2 : tnovahra;
    code, j : integer;
    vyrez : byte;
    st : string;
    Name : SearchRec;
  procedure ZmenaVelikostiObr;
  begin
    PushMouse;
    MouseSwitchOff;
    SetActivePage(1);
    SetVisualPage(1);
    NewMouseArea(0,0,320,201);
    NewMouseXY(10,Game2.Vyrez);
    repeat
      if MouseY<>0 then Bar(0,0,320,MouseY,DColor[1]);
      if MouseY<>200 then Bar(0,MouseY,320,200-MouseY,DColor[2]);
    until keypressed or (MouseKey<>0);
    if (MouseKey=1)or(KeyPressed and (ReadKey=#13)) then Game2.vyrez:=MouseY;
    SetActivePage(0);
    SetVisualPage(0);
    NewMouseArea(0,0,320,200); { !!! }
    PopMouse;
  end;

  procedure NovyPrikaz;
  var jmeno, s : string;
      p : array[1..3] of pointer;
      cis : ^integer;
      code : integer;
  begin
    jmeno:=ReadText(MenuX[8], MenuY[8], 180, 'Zadej jméno príkazu:','');
    if jmeno=#27 then exit;
    jmeno:=CilovaCesta+jmeno+'.pri';
    if ExistFile(jmeno) then begin
      standardnidialog('Príkaz s tímto jménem už existuje!',
        DColor[1], DColor[2], DColor[3], DColor[4], DColor[5], font,
        berunavedomi);
        exit;
    end;
    New(Cis);
    repeat
      s:=ReadText(MenuX[9], MenuY[9], 150, 'Zadej pořadové číslo:','');
      if s=#27 then begin
         Dispose(Cis);
         exit;
      end;
      val(s,cis^,code);
    until (Cis^>0)and(Cis^<MaxPRI+1);
    StandardniDialog('Nyní zadej|obrázek ikony|',
      DColor[1], DColor[2], DColor[3], DColor[4], DColor[5], font, upozorneni);
    if not ChooseImage(p[1],1,2) then begin
      Dispose(Cis);
      exit;
    end;
    StandardniDialog('Nyní zadej|obrázek myši, když nebude ativní|',
      DColor[1], DColor[2], DColor[3], DColor[4], DColor[5], font, upozorneni);
    if not ChooseImage(p[2],1,2) then begin
      Dispose(Cis);
      DisposeImage(p[1]);
      exit
    end;
    StandardniDialog('Nyní zadej|obrázek myši, když bude ativní|',
      DColor[1], DColor[2], DColor[3], DColor[4], DColor[5], font, upozorneni);
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

  procedure EditPrikaz;
  var jmeno : string;
      p : array[1..3] of pointer;
      cis : ^integer;
  begin
    jmeno:=vybersouboru(MenuX[10], MenuY[10], MenuZ[10],
      DColor[1], DColor[2], DColor[3], DColor[4], DColor[5], font,
      trid_pripony, CilovaCesta, '*.PRI');
    if jmeno[1]=#27 then exit;
    repeat
      Volba:=vytvormenu('#Oprava obrázu:|Editace ~Ikony příkazů|Editace ~normální myši|'
        +'Editace ~aktivní myši|~Zpet', DColor[1], DColor[2], DColor[3],
        DColor[4], DColor[5], font, MenuX[11], MenuY[11], Volba, 4);
      if Volba<4 then begin
        CLoadItem(jmeno,p[1],1);
        CLoadItem(jmeno,p[2],2);
        CLoadItem(jmeno,p[3],3);
        CLoadItem(jmeno,Pointer(Cis),4);
        DisposeImage(p[Volba]);
        if ChooseImage(p[Volba],1,2) then begin
          DeleteFile(jmeno);
          CAddFromMemory(jmeno,p[1],GetSizeImage(p[1]));
          CAddFromMemory(jmeno,p[2],GetSizeImage(p[2]));
          CAddFromMemory(jmeno,p[3],GetSizeImage(p[3]));
          CAddFromMemory(jmeno,cis,2);
        end else
          NewImage(2,3,p[Volba]);
        FreeMem(Cis,2);
        DisposeImage(p[3]);
        DisposeImage(p[2]);
        DisposeImage(p[1]);
      end;
    until Volba=4;
  end;

  procedure SmazPrikaz;
  var jmeno : string;
      P: PathStr;
      D: DirStr;
      N: NameStr;
      E: ExtStr;
  begin
    jmeno:=vybersouboru(MenuX[12], MenuY[12], MenuZ[12], DColor[1], DColor[2],
      DColor[3], DColor[4], DColor[5], font, trid_pripony, CilovaCesta,
      '*.PRI');
    if jmeno[1]=#27 then exit;
    FSplit(P, D, N, E);
    if standardnidialog('Jseš si opravdu jistý,| že chceš smazat tento '
      +'příkaz|'+N+' ?', DColor[1], DColor[2], DColor[3], DColor[4],
      DColor[5], font, ano_ne) <> 1 then Exit;
    DeleteFile(jmeno);
  end;

  procedure UkazPrikaz;
  var jmeno : string;
      p : array[1..3] of pointer;
      Cis : ^integer;
      s : string;
  begin
    MouseSwitchOff;
    jmeno:=vybersouboru(MenuX[13], MenuY[13], MenuZ[13], DColor[1], DColor[2], DColor[3],
      DColor[4], DColor[5], font, trid_pripony, CilovaCesta,
      '*.PRI');
    SetActivePage(1);
    SetVisualPage(1);
    if jmeno[1]=#27 then begin
      SetActivePage(0);
      SetVisualPage(0);
      MouseSwitchOn;
      exit;
    end;

    ClearScr(DColor[2]);

    CLoadItem(jmeno,p[1],1);
    CLoadItem(jmeno,p[2],2);
    CLoadItem(jmeno,p[3],3);
    CLoadItem(jmeno,Pointer(Cis),4);

    Str(cis^,s);
    PrintText(0,0,'Číslo předmětu:'+s,font);
    PrintText(0,48-HeigthOfFont(font),'Ikona',font);
    PrintText(106,48-HeigthOfFont(font),'Myš na ničem',font);
    PrintText(212,48-HeigthOfFont(font),'Myš na objektu',font);
    PutImagePart(0,50,0,0,320,200,p[1]);
    PutImagePart(106,50,0,0,320,200,p[2]);
    PutImagePart(212,50,0,0,320,200,p[3]);

    FreeMem(Cis,2);
    DisposeImage(p[3]);
    DisposeImage(p[2]);
    DisposeImage(p[1]);

    repeat until (MouseKey<>0)or KeyPressed;
    SetActivePage(0);
    SetVisualPage(0);
    MouseSwitchOn;
  end;
begin
  Quit:=false;
  move(game^,game2,sizeof(game2)); { jednou nefungovalo preneseni !!! }
  repeat
    alokujdialog(dial,MenuX[36],menuY[36],162,{118}129,
  {dodelat pozici v externi promenne}
                 DColor[2], DColor[4], DColor[5], {pozadi, ramecek, okraj}
                 {-1,                    {escape}
                 false,                 {escvenku}
                 true,                  {ramtlac}
                 true,                  {presouvat}
                 false,false);          {nekreslit/nemazat}
    alokujpredvoleny(stav,4,1,1);
    nastavpocty(dial,2,8{9},0,0,{6}7);

    alokujnapis(dial, 1, 55,5, DColor[1], font, 'Nová hra');

    alokujpocatecni_jednoduchyinput(dial,stav, 1, 83,20,70,
      'Jméno ~hry', DColor[1],DColor[3], font, musibyttext, game2.jmenohry);
    alokujpocatecni_jednoduchyinput(dial,stav, 2, 83,31,70,
      'Hl.~postava', DColor[1],DColor[3], font, musibyttext, game2.postava);
    alokujpocatecni_jednoduchyinput(dial,stav, 3, 83,42,70,
      'Start.~míst.', DColor[1],DColor[3], font, musibyttext, game2.prvamistnost);
    alokujpocatecni_jednoduchyinput(dial,stav, 4, 83,53,70,
      '~Fonty:', DColor[1],DColor[3], font, musibyttext, game2.fonty);

    nastavedmezecisel(0,255);

    str(game2.vyrez, st);
    alokujpocatecni_jednoduchyinput(dial,stav, 5, 83,{53}64,30,
      '~Výřez', DColor[1],DColor[3], font, musibytcislo, st);
    str(game2.roztecx,st);
    alokujpocatecni_jednoduchyinput(dial,stav, 6, 83,{64}75,30,
      'MapaRozteč~X', DColor[1],DColor[3], font, musibytcislo, st);
    str(game2.roztecy,st);
    alokujpocatecni_jednoduchyinput(dial,stav, 7, 83,{75}86,30,
      'MapaRozteč~Y', DColor[1],DColor[3], font, musibytcislo, st);
    alokujtlac(dial, 1, 125,{53}64, DColor[1],DColor[3], font, '~Myši');
    alokujnapis(dial,2, 117,{75}86, DColor[1], font, 'Prikazy');
    alokujtlac(dial, 2,  9,{88}99, DColor[1],DColor[3], font, '~Nový');
    alokujtlac(dial, 3, 49,{88}99, DColor[1],DColor[3], font, '~Edit');
    alokujtlac(dial, 4, 89,{88}99, DColor[1],DColor[3], font, '~Smaž');
    alokujtlac(dial, 5,129,{88}99, DColor[1],DColor[3], font, '~Ukaž');
    alokujtlac(dial, 6,  9,{104}115,DColor[1],DColor[3], font, '~Budiž');
    alokujtlac(dial, 7,117,{104}115,DColor[1],DColor[3], font, '~Zrušit');

    alokujtlac(dial, 8, 58,{104}115,DColor[1],DColor[3], font, '~Program');
{    alokujtlac(dial, 9, 13, 53,DColor[1],DColor[3], font, '~*'); }

    mouseswitchoff;                       {uklid mys pro vypis}
    nakreslidialog(dial,stav);
    vyberdialog(dial,stav);               {on po sobe mys taky uklidi}
  {sem}
    MenuX[36]:=dial^.X;
    MenuY[36]:=dial^.Y;

    game2.jmenohry:=stav^.input[1]^.edtext;
    game2.postava:=stav^.input[2]^.edtext;
    game2.prvamistnost:=stav^.input[3]^.edtext;
    game2.fonty:=stav^.input[4]^.edtext;

    FindFirst(cilovacesta+'*.MIS', Archive, Name);

    val(stav^.input[5]^.edtext,vyrez,code);
    if (DosError = 0)and(vyrez<>Game2.vyrez) then
      standardnidialog('Nemůžeš měnit výřez obrazky!|'
        +'(hodnotu nastavím zpět).', DColor[1], DColor[2], DColor[3],
        DColor[4], DColor[5], font,Berunavedomi) else Game2.vyrez:=vyrez;
    val(stav^.input[6]^.edtext,j,code);
    if (DosError = 0)and(j<>Game2.roztecx) then
      standardnidialog('Nemůžeš měnit RoztečX!|'
        +'(hodnotu nastavim zpet).', DColor[1], DColor[2], DColor[3],
        DColor[4], DColor[5], font,Berunavedomi) else game2.roztecx:=j;
    val(stav^.input[7]^.edtext,j,code);
    if (DosError = 0)and(j<>Game2.roztecy) then
      standardnidialog('Nemůžeš měnit RoztečY!|'
        +'(hodnotu nastavím zpět).', DColor[1], DColor[2], DColor[3],
        DColor[4], DColor[5], font,Berunavedomi) else game2.roztecy:=j;

    if (stav^.UkAkce=0)or(stav^.UkAkce=2) then
      case stav^.PredVObj of
        1 : if DosError <> 0 then ZmenaVelikostiObr else
              standardnidialog('Nemůžeš měnit výřez obrazky!|', DColor[1],
              DColor[2], DColor[3], DColor[4], DColor[5], font,Berunavedomi);
        2 : NovyPrikaz;
        3 : EditPrikaz;
        4 : SmazPrikaz;
        5 : UkazPrikaz;
        6 : begin
{              if game2.fonty[length(game2.fonty)]='\' then
                game2.fonty[0]:=char(byte(game2.fonty[0])-1);
              GetDir(0,cesta);
              ChDir(game2.fonty);
              if IOResult = 0 then begin !!!Bob - uz se zadava SEZNAM fontu,
                                                nikoliv cesta!!!!!}

                move(game2, game^,sizeof(game2));
                Quit:=true;
{              end else standardnidialog('Cesta k fontům neexistyje!',
                DColor[1], DColor[2], DColor[3], DColor[4], DColor[5],
                font, berunavedomi);
              ChDir(cesta);}
            end;
        7 : Quit:=true;
        8 : TedEditaceOBJ(Game2.Prog, Game2.ProgSize);
{        9 : begin
              if game2.fonty[length(game2.fonty)]<>'\' then game2.fonty:=game2.fonty+'\';
              VyberSouborAdresar(game2.fonty,'');
            end;}
      end;
    if (stav^.UkAkce=1)or(stav^.UkAkce=3) then Quit:=true;

    mouseswitchoff;                       {uklid mys pro vypis}
    smazdialog(dial);
    dealokujdialog(dial,stav);
  until Quit;
  mouseswitchon;
  SaveGame;
  JmenoHrdiny:=konf.cesty[4]+game^.postava;
end;

{**************************************************************************}
procedure VyberHry;
var path,p2 : string;
    i : byte;
begin
  path:=vybersouboru(MenuX[14],MenuY[14],MenuZ[14],DColor[1], DColor[2],
    DColor[3], DColor[4], DColor[5], Font, trid_pripony,cilovacesta,'');
  if path[1]<>#27 then begin
    SaveMist;
    DoneMist;
    cilovacesta:=path;
    LoadGame;
    DrawMist;
    if Game^.JmenoHry='' then NovaHra;
  end;
end;

procedure Kompilace(whatcall: byte);
var f : text;
begin
  SaveGame;
  SaveMist;
  DoneMist;
  DoneGe;
  Assign(f,'GM3.RUN');
  Rewrite(f);
  if cilovacesta[length(cilovacesta)-1]<>':' then Dec(Byte(cilovacesta[0]));
  WriteLn('Predavam kompilatoru hru: ',cilovacesta);
  WriteLn(f,cilovacesta);
  Close(f);
  Halt(whatcall);
end;
procedure Hra;
  procedure About;
  const i1 : byte = 1;
        i2 : byte = 2;
        i3 : byte = 3;
  var jmena : array[0..2] of string;
  begin
    jmena[0]:='Pavel Pospíšil|';
    jmena[1]:='Lukáš Svoboda|';
    jmena[2]:='Robert Špalek|';
    i1:=random(3);
    if random(4)=1 then i1:=1;
    repeat
      i3:=random(3);
    until i1<>i3;
    repeat
      i2:=random(3);
    until (i2<>i1)and(i3<>i2);
    vybermoznost('Game Editor d0.03 alfa||'+jmena[i1]+jmena[i2]+jmena[i3]
     +'Petr Kroča||MoveLeft (m) 1994AD|no lefts reversed',
    '~Klaním se před nimi',
    DColor[1], DColor[2], DColor[3], DColor[4], DColor[5], font, 1,1);
  end;
  procedure Rozhovory;
  var s : string;
      ted : pted;
      f : text;
  begin
    case vybermoznost('Chceš :',
        '~Vytvoři nový dialog|~Načíst starý',DColor[1], DColor[2], DColor[3],
        DColor[4], DColor[5], font,1,-1) of
      1 : begin
            s:=ReadText(MenuX[44],MenuY[44],150,' Zadej jméno dialogu:', '');
            Assign(f,cilovacesta+s);
            ReWrite(f);
            WriteLn(f,'');
            Close(f);
            s:=cilovacesta+s+'.roz';
          end;
      2 : begin
            s:=vybersouboru(MenuX[41], MenuY[41], MenuZ[41], DColor[1], DColor[2], DColor[3],
            DColor[4], DColor[5], font, trid_pripony, CilovaCesta,
            '*.ROZ');
            if s[1]=#27 then exit;
          end;
      -1 : exit;
    end;
    alokujtedokno(ted,MenuX[42],MenuY[42],MenuX[43],MenuY[43], 4
      {sirka posuvniku},'    DIALOG  :');
    nastavtedfontybarvy(ted,font,font,{bpopr:=}DColor[1],{bpoz:=}DColor[2],
      {bnadp:=}DColor[3],{bkurs:=}DColor[5],{bokr:=}DColor[5],{bpos:=}DColor[4]);
    nastavtedkursor(ted,1,1,1,1,0);
    NactiTedTextovySoubor(ted, s);
    editujtext(ted);
    ZapisTedTextovySoubor(ted, s);
    MenuX[42]:=ted^.px;
    MenuY[42]:=ted^.py;
    MenuX[43]:=ted^.rx;
    MenuY[43]:=ted^.ry;
    dealokujted(ted);
  end;
begin
  repeat
      Volba:=VytvorMenu('#HRA |~Výběr hry|~Inicializace Hry|~Rozhovory|~Nápověda|'
        +'~O Programu|Kompila~ce|~Play|#|~1..AOMaker|~2..PaleteReduc|~3..FontEdit|~4..Kresleni|~5..DOS shell|#|~Konec',
        DColor[1], DColor[2],DColor[3],DColor[4], DColor[5], font, MenuX[15], MenuY[15], 1, -1);
    case Volba of
      1 : VyberHry;
      2 : NovaHra;
      3 : Rozhovory;
      4 : Help;
      5 : About;
      6 : Kompilace(2);
      7 : Kompilace(3);
      8 : Kompilace(4);
      9 : Kompilace(5);
      10 : Kompilace(6);
      11 : Kompilace(7);
      11 : Kompilace(8);
      13 : Konec;
    end;
  until (Volba=-1)or(JakaIkona=253);
end;

{**************************************************************************}
procedure standart1;
begin
  DColor[1]:= 15;
  DColor[2]:= 7;
  DColor[3]:= 12;
  DColor[4]:= 10;
  DColor[5]:= 8;
end;

procedure standart2(co : integer);
begin
  if co<>1 then begin
    DColor[1]:= SaveC[1]; DColor[2]:= SaveC[2];
    DColor[3]:= SaveC[3]; DColor[4]:= SaveC[4];
    DColor[5]:= SaveC[5];
  end else begin
    SaveC[1]:=DColor[1];  SaveC[2]:=DColor[2];
    SaveC[3]:=DColor[3];  SaveC[4]:=DColor[4];
    SaveC[5]:=DColor[5];
  end
end;

procedure standart3(co : integer);
begin
  if co<>1 then begin
    DColor[1]:= SaveC[6]; DColor[2]:= SaveC[7];
    DColor[3]:= SaveC[8]; DColor[4]:= SaveC[9];
    DColor[5]:= SaveC[10];
  end else begin
    SaveC[6]:=DColor[1];  SaveC[7]:=DColor[2];
    SaveC[8]:=DColor[3];  SaveC[9]:=DColor[4];
    SaveC[10]:=DColor[5];
  end
end;

procedure konfigurace(konf:pkonf);
var edit:array[1..poccest] of peditor;
    dial:pdialog;
    stav:pstav;
    i:byte;
    ret:string[5];
    {JA}
    Quit : boolean;
    Konf2 : TKonf;
    NoRemapPicture2 : boolean;
    code : integer;
  procedure Barva;
  var jaka : integer;
  begin
    volba:=1;
    repeat
      repeat until MouseKey=0;
      Volba:=VytvorMenu(
        '#BARVA|~Popředí|Poza~dí|Pod~tržítko|~Rámeček|~Okraj|Stantart ~1|'+
        'Stantart ~2|Stantart ~3|~Zpět',
        DColor[1], DColor[2], DColor[3], DColor[4], DColor[5], font,
        MenuX[16], MenuY[16], Volba, 9);
      SetRCLimits(-1,-1,-1,-1,-1,-1);
      case Volba of
        1 : begin
              jaka:=ReadColor(MenuX[17],MenuY[17],255,255,DColor[5],DColor[3],DColor[2],DColor[1],
                font,'Zadej barvu písma:');
              if jaka<>-1 then DColor[1]:=Jaka;
            end;
        2 : begin
              Jaka:=ReadColor(MenuX[17],MenuY[17],255,255,DColor[5],DColor[3],DColor[2],DColor[1],
                font,'Zadej barvu pozadí:');
              if jaka<>-1 then DColor[2]:=Jaka;
            end;
        3 : begin
              Jaka:=ReadColor(MenuX[17],MenuY[17],255,255,DColor[5],DColor[3],DColor[2],DColor[1],
                font,'Zadej barvu rámečku:');
              if jaka<>-1 then DColor[3]:=Jaka;
            end;
        4 : begin
              Jaka:=ReadColor(MenuX[17],MenuY[17],255,255,DColor[5],DColor[3],DColor[2],DColor[1],
                font,'Zadej barvu podtržítka:');
              if jaka<>-1 then DColor[4]:=Jaka;
            end;
        5 : begin
              jaka:=ReadColor(MenuX[17],MenuY[17],255,255,DColor[5],DColor[3],DColor[2],DColor[1],
                font,'Zadej barvu okraje:');
              if jaka<>-1 then DColor[5]:=Jaka;
            end;
        6 : standart1;
        7 : standart2(vybermoznost('','Uložit|Načíst',DColor[1], DColor[2],
              DColor[3], DColor[4], DColor[5], font,2,2));
        8 : standart3(vybermoznost('','Uložit|Načíst',DColor[1], DColor[2],
              DColor[3], DColor[4], DColor[5], font,2,2));
      end;
    until  Volba=9;
  end;
begin
  Quit := false;
  konf2.cesty[1]:=konf^.cesty[1];
  konf2.cesty[2]:=konf^.cesty[2];
  konf2.cesty[3]:=konf^.cesty[3];
  konf2.cesty[4]:=konf^.cesty[4];
  konf2.cesty[5]:=konf^.cesty[5];
  konf2.sraf:=konf^.sraf;
  konf2.paleta:=konf^.paleta;
  konf2.krobrazky:=konf^.krobrazky;
  konf2.krmasky:=konf^.krmasky;
  konf2.krmapy:=konf^.krmapy;
  NoRemapPicture2:=not NoRemapPicture;

  repeat
    for i:=1 to poccest do begin
      AlokujEditor(edit[i]);
      NastavEdOkno(edit[i], 60,i*heigthoffont(font)+10,80, nap[i], font,font,
        false);
      NastavEdBarvy(edit[i],{bpopr:=}DColor[1],
  {bpoz:=}DColor[2]{0},
        {bnadp:=}DColor[3],
        {bkurs:=}DColor[5],{binv:=}DColor[4],{bokr:=}DColor[5],{bpos:=}DColor[5]);
      NastavEdProstredi(edit[i], true, zadnerolovani, musibyttext,
                        [],[],[],[]); {nastavi si editor sam}
      NastavEdParametry(edit[i], true,true,false,{muzpresah}false,false,false,
        128,StandardniPovZn,StandardniOddelovace);
      NastavEdObsah(edit[i], konf2.cesty[i], 1,1)
    end;

    alokujdialog(dial,menuX[37],menuY[37],202,142,
  {dodelat pozici v externi promenne}
                 DColor[2], DColor[4], DColor[5], {pozadi, ramecek, okraj}
                 {-1,                    {escape}
                 true,                  {escvenku}
                 true,                  {ramtlac}
                 true,                  {presouvat}
                 false,false);          {nekreslit/nemazat}
    alokujpredvoleny(stav,4,1,1);
    {nastav pocatecni hodnoty podle vlozenych dat}
    nastavpocty(dial,4,poccest+5,4,1,poccest+1);
    nastavpocetradio(dial,1,2);

    alokujnapis(dial, 1, 70,5, DColor[1], font, 'Konfigurace');

    for i:=1 to poccest do begin
      AlokujInput(dial,i, 5,i*heigthoffont(font)+10, DColor[3], edit[i]);
      AlokujTlac(dial,i, 150,i*heigthoffont(font)+10,
        DColor[1],DColor[3], font, '<Výběr>')
    end;
    {systemove barvy - tlacitko alokovane zde}
    AlokujTlac(dial,poccest+1, 20,(poccest+1)*heigthoffont(font)+12,
      DColor[1],DColor[3], font, '<Bar~vy editoru>');

    {co se ma zobrazovat - bylo drive radio-button}
    AlokujNapis(dial, 2,  5 ,85,  DColor[1],         font, 'Zobrazovat');
    AlokujCheck(dial, 1,  20,96,  DColor[1],DColor[3], font, 'Ob~rázky');
    AlokujCheck(dial, 2,  20,107, DColor[1],DColor[3], font, 'Ma~sky');
    AlokujCheck(dial, 3,  20,118, DColor[1],DColor[3], font, 'Ma~py');
    AlokujCheck(dial, 4,  88,118, DColor[1],DColor[3], font, 'Re~Map');

    {kterou plaetu pouzivat - zustava jako drive}
    AlokujNapis(dial, 3,   73,85,  DColor[1],         font, 'Paleta');
    AlokujRadio(dial, 1,1, 88,96,  DColor[1],DColor[3], font, 'Ob~rázku');
    AlokujRadio(dial, 1,2, 88,107, DColor[1],DColor[3], font, '~Editoru');

    AlokujNapis(dial, 4,       132,73, DColor[1],         font, 'Konfigurace');
    AlokujTlac(dial,poccest+2, 144,85, DColor[1],DColor[3], font, '~Budiž');
    AlokujTlac(dial,poccest+3, 144,95, DColor[1],DColor[3], font, '~Zrušit');
    AlokujTlac(dial,poccest+4, 144,105,DColor[1],DColor[3], font, '~Uložit');
    AlokujTlac(dial,poccest+5, 144,115,DColor[1],DColor[3], font, 'Ob~novit');

    NastavEdMezeCisel(0,12);
  {!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
   zde dej misto 12 opravdovy pocet typu srafovani
   !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!}
    str(konf2.sraf,ret);
  {mozna typ srafovani nejak posunout, aby byl krasne vedle odpovidajiciho
   radio-buttonu}
    AlokujPocatecni_JednoduchyInput(dial,stav, poccest+1, 95,129,30,
      '~Typ srafovani', DColor[1],DColor[3], font, musibytcislo, ret);

    with dial^ do begin
    {uprav vhodne velikosti objektu}
      check[2]^.dx:=check[1]^.dx;
      check[3]^.dx:=check[1]^.dx;
      radio[1].text[2]^.dx:=radio[1].text[1]^.dx;
      tlac[poccest+2]^.dx:=tlac[poccest+3]^.dx;
      tlac[poccest+4]^.dx:=tlac[poccest+5]^.dx
    end;

    pocatecnicheck(stav,1,konf2.krobrazky);
    pocatecnicheck(stav,2,konf2.krmasky);
    pocatecnicheck(stav,3,konf2.krmapy);
    pocatecnicheck(stav,4,NoRemapPicture2);
    pocatecniradio(stav,1,konf2.paleta);
    for i:=1 to poccest do
      pocatecniinput(dial, stav,i,edit[i]);

    mouseswitchoff;                       {uklid mys pro vypis}
    nakreslidialog(dial,stav);
    vyberdialog(dial,stav);               {on po sobe mys taky uklidi}
  {zde, Lukasi, zkopirovat vse zase zpet podle toho, co bylo zmacknuto atp...
   pripadne to udelat v cyklu atp... abys mohl mackat tlacitka vyber atp...
   ale tam se asi zapne prekreslovani (zac/kon), protoze se mozna budou menit
   texty}
    MenuX[37]:=dial^.X;
    MenuY[37]:=dial^.Y;

    for i:=1 to poccest do
      konf2.cesty[i]:=edit[i]^.edtext;
    val(stav^.input[poccest+1]^.edtext,konf2.sraf,code);
    konf2.paleta:=stav^.radio[1];
    if stav^.check[1]=1 then
      konf2.krobrazky:=true else konf2.krobrazky:=false;
    if stav^.check[2]=1 then
      konf2.krmasky:=true else konf2.krmasky:=false;
    if stav^.check[3]=1 then
      konf2.krmapy:=true else konf2.krmapy:=false;
    if stav^.check[4]=1 then
      NoRemapPicture2:=true else NoRemapPicture2:=false;
    if (stav^.UkAkce=0)or(stav^.UkAkce=2) then
      case stav^.PredVObj of
        1..poccest-1 : VyberSouborAdresar(konf2.cesty[stav^.PredVObj],'');
        poccest : VyberSouborAdresar(konf2.cesty[stav^.PredVObj],'*.fon');
        poccest+1 : Barva;
        poccest+2 : begin {budiz}
                      Quit := true;
                      konf^.cesty[1]:=konf2.cesty[1];
                      konf^.cesty[2]:=konf2.cesty[2];
                      konf^.cesty[3]:=konf2.cesty[3];
                      konf^.cesty[4]:=konf2.cesty[4];
                      konf^.cesty[5]:=konf2.cesty[5];
                      konf^.sraf:=konf2.sraf;
                      konf^.paleta:=konf2.paleta;
                      konf^.krobrazky:=konf2.krobrazky;
                      konf^.krmasky:=konf2.krmasky;
                      konf^.krmapy:=konf2.krmapy;
                      NoRemapPicture:=not NoRemapPicture2;
                    end;
        poccest+3 : Quit:=true;  {zrusit}
        poccest+4 : SaveGeKonfig(konf2,not NoRemapPicture2); {ulozit}
        poccest+5 : LoadGeKonfig(konf2,false);
      end;
    if (stav^.UkAkce=1)or(stav^.UkAkce=3)or(stav^.UkAkce=4) then Quit:=true;

    mouseswitchoff;                       {uklid mys pro vypis}
    smazdialog(dial);
    dealokujdialog(dial,stav)
  until Quit;
  DrawMist;
  MouseSwitchOn; { !!!! Roberte proc??? }
end;
{**************************************************************************}
procedure editovatmist(co : boolean);
var dial:pdialog;
    stav:pstav;
    i:byte;

    Quit : boolean;
    jmenomist, jmenoobr, st : string;
    code : integer;
    mist2 : tnovamist;
    p, p1 , VstupImage : pointer;
  procedure InputMouseMist;
  var dial:pdialog;
      vysl:pstav;
      DirInfo: SearchRec;
      Tabulka : array[1..MaxPRI] of record
        name : string[8];
        cis : integer;
      end;
      cis2 : ^integer;
      pocit, i : byte;
  begin
    pocit:=1;
    FindFirst(CilovaCesta+'*.PRI', Archive, DirInfo);
    while DosError = 0 do
    begin
      Tabulka[pocit].name:=copy(DirInfo.Name,1,length(DirInfo.Name)-4);
      CLoadItem(CilovaCesta+DirInfo.Name,Pointer(Cis2),4);
      Tabulka[pocit].Cis:=Cis2^;
      FreeMem(Cis2,2);
      FindNext(DirInfo);
      inc(pocit);
    end;
    alokujdialog(dial,MenuX[18],MenuY[18],130,152,
                 DColor[2], DColor[4], DColor[5], {pozadi, ramecek, okraj}
                 {-1,                    {escape}
                 false,                 {escvenku}
                 true,                  {ramtlac}
                 true,                  {presouvat}
                 false,false);          {nekreslit/nemazat - pro demonstraci
                                         to udelam sam}
    nastavpocty(dial,1,1,pocit-1,0,0);

    alokujnapis(dial, 1,  10,10, DColor[1], font, 'Vyber příkazy:');

    alokujtlac(dial, 1, 90 ,70, DColor[1], DColor[3],  font, '<Ok>');

    for i:=1 to pocit-1 do
      alokujcheck(dial, i, 20,25+(i-1)*12, DColor[1], DColor[3], font, Tabulka[i].name);

    alokujpredvoleny(vysl,1,1,1);
    for i:=1 to pocit-1 do
      if mist2.PrikazyMysi[tabulka[i].cis]=1
        then pocatecnicheck(vysl,i,true)
        else pocatecnicheck(vysl,i,false);

    mouseswitchoff;                       {uklid mys pro vypis}
    nakreslidialog(dial,vysl);
    vyberdialog(dial,vysl);               {on po sobe mys taky uklidi}

    for i:=1 to pocit-1 do
      Mist2.PrikazyMysi[tabulka[i].cis]:=vysl^.check[i];

    MenuX[18]:=dial^.X;
    MenuY[18]:=dial^.Y;

    smazdialog(dial);
    dealokujdialog(dial,vysl);
    MouseSwitchOn;
  end;
  function LoadPalette : boolean;
  var f : file;
  begin
    LoadPalette:=false;
    if mist2.paleta='' then exit;
    Assign(f,mist2.paleta);
    Reset(f,1);
    if ioresult<>0 then exit;
    BlockRead(f,mist2.pal^,768);
    if ioresult<>0 then LoadPalette:=false else LoadPalette:=true;
    Close(f);
  end;
begin
  Quit:=false;
  move(mist^,mist2,sizeof(mist^));
  jmenomist:=mist2.jmeno;
  jmenoobr:=mist2.pozadi;
  vstupimage:=mist2.image;
  repeat
    alokujdialog(dial,MenuX[19],MenuY[19],{294}206,{138}149,
  {dodelat pozici v externi promenne}
                 DColor[2], DColor[4], DColor[5], {pozadi, ramecek, okraj}
                 {-1,                    {escape}
                 false,                 {escvenku}
                 true,                  {ramtlac}
                 true,                  {presouvat}
                 false,false);          {nekreslit/nemazat}
    alokujpredvoleny(stav,4,1,1);
    nastavpocty(dial,1,10,2,1,{6}7);
    nastavpocetradio(dial,1,2);

    alokujnapis(dial, 1, 60,5, DColor[1], font, 'Nová místnost');

    alokujpocatecni_jednoduchyinput(dial,stav, 1, 70,20,70,
      '~Místnost', DColor[1],DColor[3], font, musibyttext, mist2.jmeno);
    alokujpocatecni_jednoduchyinput(dial,stav, 2, 70,31,70,
      '~Hudba', DColor[1],DColor[3], font, musibyttext, mist2.hudba);
    alokujtlac(dial,1, 155,31, DColor[1],DColor[3], font, '<Výběr>');
    alokujpocatecni_jednoduchyinput(dial,stav, 3, 70,42,70,
      '~Font', DColor[1],DColor[3], font, musibyttext, mist2.font);
    alokujtlac(dial,2, 155,42, DColor[1],DColor[3], font, '<Výběr>');
    alokujpocatecni_jednoduchyinput(dial,stav, 4, 70,65,70,
      '~Obrázek', DColor[1],DColor[3], font, musibyttext, mist2.pozadi);
    alokujtlac(dial,3, 155,64, DColor[1],DColor[3], font, '<Výběr>');
    nastavedmezecisel(0,255);
    str(mist2.barva,st);
    alokujpocatecni_jednoduchyinput(dial,stav, 5, 70,76,70,
      'B~arva', DColor[1],DColor[3], font, musibytcislo, st);
    alokujtlac(dial,4, 155,75, DColor[1],DColor[3], font, '<Výběr>');
    alokujpocatecni_jednoduchyinput(dial,stav, 6, 70,87,70,
      'Pa~leta', DColor[1],DColor[3], font,  musibyttext, mist2.paleta);
    alokujtlac(dial,10, 155,{75}86, DColor[1],DColor[3], font, '<Výběr>');

    str(mist2.Chuze,st);
    alokujpocatecni_jednoduchyinput(dial,stav, 7, 70,98,70,
      '~Chůze ', DColor[1],DColor[3], font,  musibytcislo, st);

    alokujradio(dial, 1,1, 30,53, DColor[1],DColor[3], font, '~pozadí');
    alokujradio(dial, 1,2,110,53, DColor[1],DColor[3], font, '~výplň');
    alokujcheck(dial, 1,   20,{89}111, DColor[1],DColor[3], font, 'jsou ~ikony povelu ?');
    alokujtlac(dial,  5,  155,{89}111, DColor[1],DColor[3], font, '<Výběr>');
  {rada pro Lukase : dej Default vybrane vsechny povely}
    alokujcheck(dial, 2,   20,{100}122,DColor[1],DColor[3], font, 'po~stavička hrdiny');

    alokujtlac(dial, 6, 10,{112}135,   DColor[1],DColor[3], font, '~Budiž');
    alokujtlac(dial, 7, 80,{112}135,   DColor[1],DColor[3], font, '~Zrušit');

    alokujtlac(dial, 8, 137,{101}123,   DColor[1],DColor[3], font, 'Výř~ez Obr.');
    alokujtlac(dial, 9, 137,{113}135,   DColor[1],DColor[3], font, 'Vy~kreslení');

    if mist2.barva<>255 then pocatecniradio(stav,1, 2) else pocatecniradio(stav,1, 1);
    pocatecnicheck(stav,1,mist2.mys);
    pocatecnicheck(stav,2,mist2.postava);

    for i:=2 to 5 do begin
      dial^.input[i]^.dx:=dial^.input[1]^.dx;
      dial^.input[i]^.rx:=dial^.input[1]^.rx
    end;

    mouseswitchoff;                       {uklid mys pro vypis}
    nakreslidialog(dial,stav);
    vyberdialog(dial,stav);               {on po sobe mys taky uklidi}

    MenuX[19]:=dial^.X;
    MenuY[19]:=dial^.Y;

    mist2.jmeno:=stav^.input[1]^.edtext;
    for i:=1 to length(mist2.jmeno) do
      mist2.jmeno[i]:=UpCase(mist2.jmeno[i]);
    mist2.hudba:=stav^.input[2]^.edtext;
    mist2.font:=stav^.input[3]^.edtext;
    mist2.pozadi:=stav^.input[4]^.edtext;
    val(stav^.input[5]^.edtext,mist2.barva,code);
    val(stav^.input[7]^.edtext,mist2.chuze,code);
    if mist2.chuze=0 then mist2.chuze:=1;
    if stav^.check[1]=1 then
      mist2.mys:=true else  mist2.mys:=false;
    if stav^.check[2]=1 then
      mist2.postava:=true else mist2.postava:=false;
    if stav^.radio[1]=1 then mist2.barva:=255 else
      if mist2.barva=255 then mist2.barva:=0;

    if (stav^.UkAkce=0)or(stav^.UkAkce=2) then
      case stav^.PredVObj of
        1 : begin
             if mist2.hudba='' then mist2.hudba:=konf.cesty[3];
             VyberSouborAdresar(mist2.hudba,'*.mus');
             if mist2.hudba=konf.cesty[3] then mist2.hudba:='';
            end;
        2 : begin
              if mist2.font='' then mist2.font:=konf.cesty[1];
              VyberSouborAdresar(mist2.font,'*.fon');
              if mist2.font=konf.cesty[1] then mist2.font:='';
            end;
        3 : begin
              if mist2.pozadi='' then mist2.pozadi:=konf.cesty[2];
              VyberSouborAdresar(mist2.pozadi,'*.pcx;*.bmp');
              if mist2.pozadi=konf.cesty[2] then mist2.pozadi:='';
            end;
        4 : begin
              code:=ReadColor(MenuX[20],MenuY[20],255,255,DColor[5],DColor[3],DColor[2],DColor[1],
                font,'Zadej barvu pozadí:');
              if code<>-1 then mist2.barva:=byte(code);
            end;
        5 : if mist2.mys then InputMouseMist else
              standardnidialog('K této volbě musí být|napřed myš v místnosti!',
                DColor[1], DColor[2], DColor[3], DColor[4], DColor[5], font,
                berunavedomi);
        6 : if mist2.jmeno='' then standardnidialog('Není vyplněna položka MISTNOST',
              DColor[1], DColor[2], DColor[3], DColor[4], DColor[5], font,
              berunavedomi)
            else begin
                st:='';
                if (mist2.pozadi='')and(mist2.barva=255) then St:=st+'Není vyplněa položka OBRAZEK!|';
                if not FileExist(mist2.font) then St:=St+'Zadaný font neexistuje!|';
                if not FileExist(mist2.hudba) then St:=St+'Tato hudba neexistuje!|';
                if ((mist2.barva=255)and((jmenoobr<>mist2.pozadi)or
                   (vstupimage=nil))){and not((jmenoobr='')and(vstupimage<>nil))}
                  then begin
                  if mist2.image<>nil then begin
                    DisposeImage(mist2.image);
                    DisposeMask;
                    DisposeMap(Mist^.GoMap);
                  end;
                  code:=LoadImage(mist2.image, p,mist2.pozadi);
                  case code of
                    0 : st:=st+'Soubor s obrázkem neexistuje!|';
                    1 : begin
                          st:=st+'Soubor s obrázkem nemá paletu!|';
                          disposeimage(mist2.image);
                          mist2.image:=nil;
                        end;
                    255 : begin
                            freemem(mist2.pal,768);
                            mist2.pal:= P;
                            SetActivePage(1);
                            PutImage(0,0,mist2.image);
                            DisposeImage(mist2.image);
                            NewImage(320,game^.vyrez,mist2.image);
                            GetImage(0,0,320,game^.vyrez,mist2.image);
                            SetActivePage(0);

                            NewMask(mist2.image);
                            NewMap(mist2.image,game^.roztecx,game^.roztecy,
                                   mist2.GoMap);
                          end;
                  end;
                end;
                if mist2.barva<>255 then if not LoadPalette
                  then st:='Nelze precist paleta!';
                if st<>'' then standardnidialog(st, DColor[1], DColor[2],
                  DColor[3], DColor[4], DColor[5], font, berunavedomi) else
                  begin
                    move(mist2,mist^,SizeOf(mist^));
                    Quit:=true;
                  end;
            end;
        7 : if co then begin
              Quit:=true;
              DoneMist;
            end else Quit:=true;
        8 : if mist2. barva<>255 then standardnidialog('Není zaškrtlé pozadí!',
              DColor[1], DColor[2], DColor[3], DColor[4], DColor[5], font,
              berunavedomi)
            else begin
              code:=LoadImage(p1, p ,mist2.pozadi);
              st:='';
              if code=1 then begin
                st:='Obrázek nelzae načíst - nemá paletu!';
                DisposeImage(p);
              end;
              if code=0 then st:= 'Nelze načíst obrázek|(špatné jméno)';
              if st<>'' then standardnidialog(st , DColor[1], DColor[2],
                DColor[3], DColor[4], DColor[5], font, berunavedomi)
              else begin
                SetActivePage(1);
                SetVisualPage(1);
                ClearScr(DColor[5]);
                ChooseImageSize(p1, 320, game^.Vyrez);
                jmenoobr:=mist2.pozadi;
                if vstupimage<>nil then begin
                  DisposeImage(mist2.image);
                  FreeMem(mist2.pal,768);
                  mist2.pal:=p;
                  mist2.image:=p1;
                end else begin
                  FreeMem(mist2.pal,768);
                  mist2.pal:=p;
                  mist2.image:=p1;
                  NewMask(mist2.image);
                  NewMap(mist2.image,game^.roztecx,game^.roztecy,
                         mist2.GoMap);
                  vstupimage:=mist2.image;
                end;
                mist^.image:=mist2.image;
                mist^.GoMap:=mist2.GoMap;
                DrawMist;
              end;
            end;
        9 : mist2.ZpusobVykresleni:=VytvorMenu('~1|~2|~3|~4|~5|~6|~7|~Zpet',
              DColor[1], DColor[2], DColor[3], DColor[4], DColor[5],
              font, MenuX[21], MenuY[21], mist2.ZpusobVykresleni,
              mist2.ZpusobVykresleni);
        10: begin
              if mist2.paleta='' then mist2.paleta:=konf.cesty[2];
              VyberSouborAdresar(mist2.paleta,'*.pal');
              if mist2.paleta=konf.cesty[2] then mist2.paleta:='';
            end;
      end;
    if (stav^.UkAkce=1)or(stav^.UkAkce=3)or(stav^.UkAkce=4) then
      if co then begin
        Quit:=true;
        DoneMist;
      end else Quit:=true;
    mouseswitchoff;                       {uklid mys pro vypis}
    smazdialog(dial);
    dealokujdialog(dial,stav)
  until Quit;
  if (jmenomist<>mist^.jmeno) then begin
    if FileExist(cilovacesta+mist^.jmeno+'.mis') then
      if vybermoznost('Toto jméno místnosti už exsistuje!',
        'Nechat staré jméno|Přepsat místnost',DColor[1], DColor[2], DColor[3],
        DColor[4], DColor[5], font,1,1)=1 then
        if jmenomist<>''
          then mist^.jmeno:=jmenomist
          else mist^.jmeno:='NoName';
    if (jmenomist<>'') then DeleteFile(cilovacesta+jmenomist+'.mis');
    SaveMist;
  end;
  if (mist^.barva<>255)and(vstupimage<>nil) then begin
    DisposeImage(mist2.image);
    DisposeMask;
    DisposeMap(Mist^.GoMap);
  end;
  if mist^.barva<>255 then mist^.image:=nil;
  DrawMist;
  MouseSwitchOn; { !!!! Roberte proc??? }
end;
{**************************************************************************}
procedure VybratMist;
var s : string;
begin
  s:=vybersouboru(MenuX[22], MenuY[22], MenuZ[22], DColor[1], DColor[2], DColor[3],
    DColor[4], DColor[5], font, trid_pripony, CilovaCesta, '*.MIS');
  if s=#27 then exit;
  SaveMist;
  DoneMist;
  LoadMist(s);
end;

procedure Mistnost;
  procedure NovaMist;
  var i : byte;
  begin
    SaveMist;
    DoneMist;

    GetMem(Mist, SizeOf(Mist^));
    GetMem(Mist^.pal, 768);
    move(palette^,mist^.pal^,768);

    Mist^.barva:=0;
    mist^.jmeno:='';
    mist^.hudba:='';
    mist^.mys:=true; { je mys }
    mist^.postava:=true;
    mist^.font:='';
    mist^.pozadi:='';
    mist^.paleta:='';
    mist^.GoMap:=nil;
    mist^.image:=nil;
    mist^.filter:=nil;
    mist^.plin:=0;
    mist^.pabs:=1;
    mist^.BarvaMapyChuze:=ColorGoMap;
    mist^.zpusobVykresleni:=1;
    mist^.Chuze:=6;
    for i:=1 to MaxPRI do
      mist^.prikazyMysi[i]:=1;
    NastavSRotaci(mist^.rotacepal);
    for i:=1 to MaxObj do begin
      mist^.Objekty[i].p:=nil;
      mist^.Objekty[i].jmeno:='';
      mist^.Objekty[i].Cis:=255;
    end;
    EditovatMist(true);
  end;
  procedure SmazMist;
  var s : string;
      P: PathStr;
      D: DirStr;
      N: NameStr;
      E: ExtStr;
  begin
    s:=vybersouboru(MenuX[23], MenuY[23], MenuZ[23], DColor[1], DColor[2], DColor[3],
      DColor[4], DColor[5], font, trid_pripony, CilovaCesta, '*.MIS');
    if s=#27 then exit;
    if standardnidialog('Jseš si jist ?', DColor[1], DColor[2], DColor[3],
      DColor[4], DColor[5], Font, Ano_Ne)=1 then begin
        FSplit(P, D, N, E);
        if (mist<>nil)and(copy(mist^.jmeno,1,8)=N)then begin
          DoneMist;
          DrawMist;
        end;
        DeleteFile(s);
      end;
  end;
var Mtext : string;
begin
  Volba:=1;
  repeat
    if mist=nil then Mtext:='#Místnost:|~Udělat místnost|~Vybrat místnost|'+
      '~Smazat místnost|~Zpět'
    else Mtext:='#Místnost:|~Udělat místnost|~Vybrat místnost|'
      +'~Smazat místnost|#|~Editovat místnost|Editovat ~masky|Editovat ~chůzi|'
      +'Editovat ~perspektívu|Editovat ~r. palety|#|~Zpět';
    Volba:=vytvormenu(Mtext , DColor[1], DColor[2], DColor[3], DColor[4],
      DColor[5], font, MenuX[24], MenuY[24], Volba, 20);
    if mist = nil then
      case Volba of
        1 : NovaMist;
        2 : VybratMist;
        3 : SmazMist;
      end else
      case Volba of
        1 : NovaMist;
        2 : VybratMist;
        3 : SmazMist;
        4 : EditovatMist(false);
        5 : if mist^.barva=255 then begin
              ClearIcons(255);
              EditMask(mist^.image);
              DrawMist;
            end else standardnidialog('Nemůzes editovat masku,|když není obrázek!',
                DColor[1], DColor[2], DColor[3], DColor[4], DColor[5], font,
                berunavedomi);
        6 : if mist^.barva=255 then begin
              ClearIcons(255);
              EditMap(0,0,mist^.image,mist^.GoMap);
              mist^.BarvaMapyChuze:=ColorGoMap;
              DrawMist;
            end else standardnidialog('Nemůžeš editovat mapu chuze,|když není obrázek!',
                DColor[1], DColor[2], DColor[3], DColor[4], DColor[5], font,
                berunavedomi);
        7 : begin
              ClearIcons(255);
              NactiVztah(mist^.Image{,Ikony[4].p},mist^.barva,mist^.PLin,mist^.PAbs);
              DrawIcons(255,false);
              DrawMist;
            end;
        8 : NactiRotaciPal(mist^.pal,mist^.rotacepal);
      end;
  until (Volba=20)or((Volba=4)and(mist=nil))or((Volba=9)and(mist<>nil));
end;
{**************************************************************************}
procedure PrikazoveProg;
var  DirInfo: SearchRec;
     Tabulka : array[1..MaxPRI] of record
       name : string[8];
       cis : integer;
     end;
     cis2 : ^integer;
     pocit, i : byte;
     S : string;
begin
  volba:=1;
  pocit:=1;
  FindFirst(CilovaCesta+'*.PRI', Archive, DirInfo);
  while DosError = 0 do
  begin
    Tabulka[pocit].name:=copy(DirInfo.Name,1,length(DirInfo.Name)-4);
    CLoadItem(CilovaCesta+DirInfo.Name,Pointer(Cis2),4);
    Tabulka[pocit].Cis:=Cis2^;
    FreeMem(Cis2,2);
    FindNext(DirInfo);
    inc(pocit);
  end;
  s:='#Příkazy hry:';
  for i:=1 to pocit-1 do s:=s+'|'+tabulka[i].name;
  s:=s+'|'+'~Zpet';
  repeat
    Volba:=VytvorMenu(s, DColor[1], DColor[2], DColor[3], DColor[4],
      DColor[5], font, MenuX[25], MenuY[25], Volba, Pocit);
    if Volba<>pocit then
      TedEditaceObj(Obj^.Prikazy[tabulka[Volba].Cis].prog,
                    Obj^.Prikazy[tabulka[Volba].Cis].size);
  until Volba=Pocit;
end;

procedure EditaceObj(cis : byte);
var i : byte;
    volba : integer;
  procedure ZmenaXY;
  var dial:pdialog;
      stav:pstav;
      code : integer;
      st : string;
      x, y : integer;
  begin
    X:=BufIcons^[cis].X;
    Y:=BufIcons^[cis].Y;
    alokujdialog(dial,MenuX[36],menuY[36],125,55,
  {dodelat pozici v externi promenne}
                 DColor[2], DColor[4], DColor[5], {pozadi, ramecek, okraj}
                 {-1,                    {escape}
                 false,                 {escvenku}
                 true,                  {ramtlac}
                 true,                  {presouvat}
                 false,false);          {nekreslit/nemazat}
    alokujpredvoleny(stav,{4}1,1,1);
    nastavpocty(dial,1,2,0,0,2);

    alokujnapis(dial, 1, 5,5, DColor[1], font, 'Nastaveni souradnic:');

    nastavedmezecisel(-100,400);

    str(x, st);
    alokujpocatecni_jednoduchyinput(dial,stav, 1, 83,{53}17,30,
      '~X souřanice', DColor[1],DColor[3], font, musibytcislo, st);
    str(y, st);
    alokujpocatecni_jednoduchyinput(dial,stav, 2, 83,{64}28,30,
      '~Y souřanice', DColor[1],DColor[3], font, musibytcislo, st);
    alokujtlac(dial, 1,15,39,DColor[1],DColor[3], font, '~Budiž');
    alokujtlac(dial, 2,67,39,DColor[1],DColor[3], font, '~Zrušit');

    mouseswitchoff;                       {uklid mys pro vypis}
    nakreslidialog(dial,stav);
    vyberdialog(dial,stav);               {on po sobe mys taky uklidi}
  {sem}
    MenuX[36]:=dial^.X;
    MenuY[36]:=dial^.Y;

    val(stav^.input[1]^.edtext,x,code);
    val(stav^.input[2]^.edtext,y,code);

    if (stav^.UkAkce=0)or(stav^.UkAkce=2) then
{      case stav^.PredVObj of
      end;}

    mouseswitchoff;                       {uklid mys pro vypis}
    smazdialog(dial);
    if ((stav^.UkAkce=0)or(stav^.UkAkce=2))and(stav^.PredVObj=1) then begin
      ClearIcons(255);
      BufIcons^[cis].X:=X;
      BufIcons^[cis].Y:=Y;
      Obj^.X:=X;
      Obj^.Y:=Y;
      DrawIcons(255,false);
    end;
    dealokujdialog(dial,stav);
    mouseswitchon;
  end;

  procedure ZmenaObrazku;
  var p : pointer;
  begin
    if standardnidialog('Má tento objekt obrázek ?',
      DColor[1], DColor[2], DColor[3], DColor[4], DColor[5], font, Ano_Ne)=2
      then if Obj^.JeObrazek<>0 then begin
        DisposeImage(Obj^.Image);
        DisposeMap(Obj^.GoMap);
        Obj^.JeObrazek:=0;
        Obj^.Image:=nil;
        Obj^.GoMap:=nil;
        DisposeImage(Mist^.Objekty[i].p);
        GetMem(Mist^.Objekty[i].P,GetSizeImage(Ikony[4].P));
        Move(Ikony[4].P^, Mist^.Objekty[i].P^, GetSizeImage(Ikony[4].P));
        DelIcons(cis);
        Mist^.Objekty[i].Cis:= AddIcons(Mist^.Objekty[i].p, OBJ^.X,OBJ^.Y,2);
      end else
      else if ChooseImage(p,1,2) then
        if Obj^.JeObrazek=0 then begin
          Obj^.JeObrazek:=1;
          DisposeImage(Mist^.Objekty[i].p);
          GetMem(Mist^.Objekty[i].p,GetSizeImage(p));
          Move(p^,Mist^.Objekty[i].p^,GetSizeImage(p));
          Obj^.Image:=P;
          NewMap(obj^.image, game^.roztecx, game^.roztecy, obj^.GoMap);
          DelIcons(cis);
          Mist^.Objekty[i].Cis:= AddIcons(Mist^.Objekty[i].p, OBJ^.X,OBJ^.Y,2);
        end else begin
          Obj^.JeObrazek:=1;
          DisposeMap(Obj^.GoMap);
          DisposeImage(Obj^.Image);
          DisposeImage(Mist^.Objekty[i].p);
          GetMem(Mist^.Objekty[i].p,GetSizeImage(p));
          Move(p^,Mist^.Objekty[i].p^,GetSizeImage(p));
          Obj^.Image:=P;
          NewMap({obj^.image}Mist^.Objekty[i].p, game^.roztecx, game^.roztecy, obj^.GoMap);
          DelIcons(cis);
          Mist^.Objekty[i].Cis:= AddIcons(Mist^.Objekty[i].p, OBJ^.X,OBJ^.Y,2);
        end;
  end;
  procedure ZmenaObrazkuInv;
  var p : pointer;
  begin
    if standardnidialog('Má tento objekt obrázek inventáře?',
      DColor[1], DColor[2], DColor[3], DColor[4], DColor[5], font, Ano_Ne)=2
      then if Obj^.JeIkona<>0 then begin
        DisposeImage(Obj^.Ikona);
        Obj^.JeIkona:=0;
        Obj^.Ikona:=nil;
      end else
      else if ChooseImage(p,1,2) then
        if Obj^.JeIkona=0 then begin
          Obj^.JeIkona:=1;
          Obj^.Ikona:=P;
        end else begin
          DisposeImage(Obj^.Ikona);
          Obj^.Ikona:=P;
        end;
  end;

  procedure UkazObjekt;
  var s : string;
  begin
    PushMouse;
    MouseSwitchOff;
    SetActivePage(1);
    SetVisualPage(1);
    ClearScr(DColor[5]);
    PrintText(0,0,'Objekt se jmenuje '+mist^.objekty[i].jmeno,font);
{    if obj^.NahratHned=0
      then s:='až je tato místnost aktuální.'
      else s:='při spuštení hry.'; !!!Bob}
    case obj^.NahratHned of
      1:s:='až je tato místnost aktuální.';
      2:s:='při spuštení hry. (je zde)';
      3:s:='při spuštení hry. (je v batohu)';
    end;
    PrintText(0,10,'Objekt se nahrává '+s,font);
    Line(0,20,319,20,DColor[1]);
    if Obj^.JeObrazek=0 then s:='nemá'else
    begin
      s:='má';
      PutImage(40,40,Obj^.Image);
      DrawMap(40,40,0,0,PWordArray(Obj^.GoMap)^[4],
        PWordArray(Obj^.GoMap)^[5], Obj^.GoMap);
    end;
    PrintText(0,30,'Objekt '+s+' obrázek.',font);

    if Obj^.JeIkona=0 then s:='nemá'else
    begin
      s:='má';
      PutImage(200,40,Obj^.Ikona);
    end;
    PrintText(160,30,'Objekt '+s+' ikonu.',font);

    repeat until (MouseKey<>0)or keypressed;
    if keypressed then readkey;

    SetActivePage(0);
    SetVisualPage(0);
    PopMouse;
  end;
begin
  Volba:=1;
  i:=1;
  while (cis<>mist^.Objekty[i].cis) do Inc(i);
  LoadObj(mist^.objekty[i].jmeno+'.obj');
  repeat
    OBJ^.X:=BufIcons^[Cis].X;
    OBJ^.Y:=BufIcons^[Cis].Y;
    repeat until MouseKey=0;
    Volba:=vytvormenu('#Editace objektu '+mist^.objekty[i].jmeno+' :|'+
      '~Typ objektu|Změna ~souřadnic|Změna priorit~y|Změna ~obrázku|'+
      'Změna obr i~nventáře|Změna ~mapy chůze|~Inicializační program|'+
      '~Rezidentní program|~Příkazové programy|~Ukázat objekt|~Zpět',
      DColor[1], DColor[2], DColor[3], DColor[4], DColor[5], font, MenuX[26],
      MenuY[27], Volba, 11);
    case volba of
      1 : {Obj^.NahratHned:=1-(standardnidialog('Má být objekt stále v paměti?|',
            DColor[1], DColor[2], DColor[3], DColor[4], DColor[5], font,
            Ano_Ne)-1);}
      begin
         if Obj^.NahratHned<1 then Obj^.NahratHned:=1;
         if Obj^.NahratHned>3 then Obj^.NahratHned:=3;
{korekce ze starych objektu}
         volba:=vytvormenu('#Jaký má být objekt|'+
           'Statický (nahrává se s místností)|'+
           'Dynamický (pořád v paměti, přenosný)|'+
           'Dynamický, na poč. je v batohu (ne zde)',
           DColor[1], DColor[2], DColor[3], DColor[4], DColor[5], font,
           menux[45],menuy[45],
           Obj^.NahratHned,-10);
         if volba<>-10 then
           Obj^.NahratHned:=volba;
         volba:=1;
      end;
      2 : ZmenaXY;
      3 : ChangeHigh(Obj^.X, Obj^.Y, Obj^.Priorita, DColor[2]);
      4 : ZmenaObrazku;
      5 : ZmenaObrazkuInv;
      6 : if Obj^.JeObrazek=0 then standardnidialog('Když není obrázek nemužeš|'
            +'ozančit výřez chůze', DColor[1], DColor[2], DColor[3], DColor[4], DColor[5], font,
            berunavedomi) else EditMap(Obj^.X, Obj^.Y, Obj^.Image, Obj^.GoMap);
      7 : TedEditaceOBJ(Obj^.InitProg, Obj^.InitProgSize);
      8 : TedEditaceOBJ(Obj^.IntProg, Obj^.IntProgSize);
      9 : PrikazoveProg;
      10 : Ukazobjekt;
    end;
  until Volba=11;
  SaveObj(mist^.objekty[i].jmeno+'.obj');
  DoneObj;
end;
{**************************************************************************}
procedure Objekt;
  procedure UdelatObj;
  var i, i1 : byte;
  begin
    i:=1;
    GetMem(Obj,SizeOf(Obj^));
    while (Mist^.Objekty[i].Jmeno<>'') do Inc(i);
    Mist^.Objekty[i].Jmeno:=ReadText(MenuX[28],MenuY[28],150,' Zadej jméno objektu:',
      '');
    if Mist^.Objekty[i].Jmeno[1]=#27 then begin
      Mist^.Objekty[i].Jmeno:='';
      FreeMem(Obj,SizeOf(Obj^));
      exit;
    end;
    if FileExist(cilovacesta+Mist^.Objekty[i].Jmeno+'.obj') then
      if vybermoznost('Tento objet už exsistuje!',
        'Zrušit|Přepsat',DColor[1], DColor[2], DColor[3],
        DColor[4], DColor[5], font,1,1)=1 then
      begin
        Mist^.Objekty[i].Jmeno:='';
        FreeMem(Obj,SizeOf(Obj^));
        exit;
    end;
    Obj^.X:=30;
    Obj^.Y:=160;
    Obj^.Priorita:=0;
    Obj^.Nahrathned:={0}1; {!!!Bob}
    Obj^.JeObrazek:=0;
    Obj^.JeIkona:=0;
    Obj^.Image:=nil;
    Obj^.GoMap:=nil;
    Obj^.Ikona:=nil;
    GetMem(Obj^.IntProg,2);
    GetMem(Obj^.InitProg,2);
    Obj^.IntProgSize:=2;
    Obj^.InitProgSize:=2;
    PWordArray(Obj^.IntProg)^[0]:=$1013;
    PWordArray(Obj^.InitProg)^[0]:=$1013;
    for i1:=1 to MaxPRI do begin
      GetMem(Obj^.Prikazy[i1].Prog,2);
      Obj^.Prikazy[i1].Size:=2;
      PWordArray(Obj^.Prikazy[i1].Prog)^[0]:=$1013;
    end;
    GetMem(Mist^.Objekty[i].P,GetSizeImage(Ikony[4].P));
    Move(Ikony[4].P^, Mist^.Objekty[i].P^, GetSizeImage(Ikony[4].P));
    Mist^.Objekty[i].Cis:= AddIcons(Mist^.Objekty[i].P,OBJ^.X,OBJ^.Y,2);
    SaveObj(Mist^.Objekty[i].Jmeno+'.obj');
    DoneObj;
    EditaceObj(Mist^.Objekty[i].Cis);
  end;

  procedure EditObj;
  var s1 : string;
      i, i1 : byte;
      pole : array[1..MaxObj] of byte;
      volba : integer;
  begin
    i1:=1;
    s1:='';
    for i:=1 to MaxObj do if mist^.objekty[i].jmeno<>'' then begin
      pole[i1]:=i;
      Inc(i1);
      s1:=s1+mist^.objekty[i].jmeno+'|';
    end;
    Volba:=vytvormenu('#Editace objektu:|'+s1+'~Zpět', DColor[1], DColor[2],
      DColor[3], DColor[4], DColor[5], font, MenuX[29], MenuY[29], 1, i1);
    if volba<>i1 then EditaceObj(mist^.objekty[pole[volba]].cis);
  end;

  procedure PrejmenovatObj;
  var i, i1 : byte;
      pole : array[1..MaxObj] of byte;
      s1 : string;
      volba : integer;
    procedure ReNameObj(i : byte);
    var f : file;
    begin
      s1:=ReadText(MenuX[30],MenuY[30],150,' Zadej jméno Objektu:',
        Mist^.Objekty[i].Jmeno);
      if s1=#27 then exit;
      if FileExist(cilovacesta+Mist^.Objekty[i].Jmeno+'.obj') then begin
        standardnidialog('Objekt s tímto jménem už existuje!|', DColor[1],
        DColor[2], DColor[3], DColor[4], DColor[5], font, berunavedomi);
        exit;
      end;
      Assign(f,cilovacesta+Mist^.Objekty[i].Jmeno+'.obj');
      ReName(f,cilovacesta+s1+'.obj');
      Mist^.Objekty[i].Jmeno:=s1;
    end;
  begin
    i1:=1;
    s1:='';
    for i:=1 to MaxObj do if mist^.objekty[i].jmeno<>'' then begin
      pole[i1]:=i;
      Inc(i1);
      s1:=s1+mist^.objekty[i].jmeno+'|';
    end;
    Volba:=vytvormenu('#Přejmenování objektu:|Ukázat myší|#|'+s1+'~Zpět', DColor[1], DColor[2],
      DColor[3], DColor[4], DColor[5], font, MenuX[31], MenuY[31], 1, i1+1);
    if (volba<>i1+1)and(volba<>1) then ReNameObj(volba-1);
    if volba=1 then begin
      standardnidialog('Klikni na objekt který chceš přejmenovat!', DColor[1],
        DColor[2], DColor[3], DColor[4], DColor[5], font, upozorneni);
      repeat until MouseKey<>0;
      i:=testIcons(255,255);
      i1:=1;
      while (i<>mist^.Objekty[i1].cis)and(i=255) do Inc(i1);
      if MouseKey<>1 then i1:=255;
      repeat until MouseKey=0;
      if (i>3)and(i<3+MaxObj)then ReNameObj(i1);
    end;
    repeat until MouseKey=0;
  end;

  procedure SmazatObj;
  var i, i1 : byte;
      pole : array[1..MaxObj] of byte;
      s1 : string;
      volba : integer;
  begin
    i1:=1;
    s1:='';
    for i:=1 to MaxObj do if mist^.objekty[i].jmeno<>'' then begin
      pole[i1]:=i;
      Inc(i1);
      s1:=s1+mist^.objekty[i].jmeno+'|';
    end;
    Volba:=vytvormenu('#Smazáni objektu:|Ukázat myší|#|'+s1+'~Zpět', DColor[1], DColor[2],
      DColor[3], DColor[4], DColor[5], font, MenuX[32], MenuY[32], 1, i1+1);
    if (volba<>i1+1)and(volba<>1)and(standardnidialog('Jseš si jistý se smazáním '+
         'objektu|'+Mist^.Objekty[pole[volba-1]].jmeno+'!', DColor[1], DColor[2],
         DColor[3], DColor[4], DColor[5], font, Ano_ne)=1) then begin
        DelIcons(Mist^.Objekty[pole[volba-1]].Cis);
        DeleteFile(cilovacesta+Mist^.Objekty[pole[volba-1]].jmeno+'.obj');
        Mist^.Objekty[pole[volba-1]].jmeno:='';
        Mist^.Objekty[pole[volba-1]].Cis:=255;
        DisposeImage(Mist^.Objekty[pole[volba-1]].P);
    end;
    if volba=1 then begin
      standardnidialog('Klikni na objekt který chceš smazat!', DColor[1],
        DColor[2], DColor[3], DColor[4], DColor[5], font, upozorneni);
      repeat until MouseKey<>0;
      i:=testIcons(255,255);
      i1:=1;
      while (i<>mist^.Objekty[i1].cis)and(i=255) do Inc(i1);
      if MouseKey<>1 then i1:=255;
      repeat until MouseKey=0;
      if (i>3)and(i<3+MaxObj)and(standardnidialog('Jseš si jistý se smazáním '+
         'objektu|'+Mist^.Objekty[i1].jmeno+'!', DColor[1], DColor[2],
         DColor[3], DColor[4], DColor[5], font, Ano_ne)=1) then begin
        DelIcons(i);
        DeleteFile(cilovacesta+Mist^.Objekty[i1].jmeno+'.obj');
        Mist^.Objekty[i1].jmeno:='';
        Mist^.Objekty[i1].Cis:=255;
        DisposeImage(Mist^.Objekty[i1].P);
      end;
    end;
    repeat until MouseKey=0;
  end;
begin
  if Game^.JmenoHry='' then begin
    StandardniDialog('Nejprve musíš vyplnit INICIALIZACI '
      +'HRY!|A potom musíš být v místnosti,|abys mohl vyvolat tuto volbu.',
      DColor[1], DColor[2], DColor[3], DColor[4], DColor[5], font,
      berunavedomi);
    Exit;
  end else if Mist=nil then begin
    StandardniDialog('Musí být otevřena nějaká místnost,|'
      +'abys mohl vyvolat tuto volbu.',DColor[1], DColor[2], DColor[3],
      DColor[4], DColor[5], font, berunavedomi);
    Exit;
  end;
  volba:=1;
  repeat
    volba:=vytvormenu('#Objekt:|~Udělat objekt|~Editovat objekt|'+
      '~Přejmenovat objekt|~Smazat objekt|#|~Zpět', DColor[1], DColor[2],
      DColor[3], DColor[4], DColor[5], font, MenuX[33], MenuY[33], Volba, 5);
    case volba of
      1 : UdelatObj;
      2 : EditObj;
      3 : PrejmenovatObj;
      4 : SmazatObj;
    end;
  until volba=5;
end;
{**************************************************************************}
procedure EditMaskObj(maska : byte);
var s : string;
    i1 : byte;
begin
  str(maska,s);
  if FileExist(cilovacesta+mist^.jmeno+'.'+s)
    then LoadObj(mist^.jmeno+'.'+s)
    else begin
    GetMem(Obj,SizeOf(Obj^));
    Obj^.Priorita:=0;
    Obj^.Nahrathned:={0!!!Bob}1;
    Obj^.JeObrazek:=0;
    Obj^.JeIkona:=0;
    Obj^.Image:=nil;
    Obj^.GoMap:=nil;
    Obj^.Ikona:=nil;
    GetMem(Obj^.IntProg,2);
    GetMem(Obj^.InitProg,2);
    Obj^.IntProgSize:=2;
    Obj^.InitProgSize:=2;
    PWordArray(Obj^.IntProg)^[0]:=$1013;
    PWordArray(Obj^.InitProg)^[0]:=$1013;
    for i1:=1 to MaxPRI do begin
      GetMem(Obj^.Prikazy[i1].Prog,2);
      Obj^.Prikazy[i1].Size:=2;
      PWordArray(Obj^.Prikazy[i1].Prog)^[0]:=$1013;
    end;
  end;
  repeat
    repeat until MouseKey=0;
    volba:=1;
    volba:=vytvormenu('#Objekt '+s+':|Změna ~priority|~Inicializační program|'
      +'~Rezidentní program|~Přikazové programy|~Zpět', DColor[1], DColor[2],
      DColor[3], DColor[4], DColor[5], font, MenuX[34], MenuY[34], Volba, 5);
    case volba of
      1 : ChangeHighMask(200, Obj^.Priorita, DColor[2]);
      2 : TedEditaceOBJ(Obj^.InitProg, Obj^.InitProgSize);
      3 : TedEditaceOBJ(Obj^.IntProg, Obj^.IntProgSize);
      4 : PrikazoveProg;
    end;
  until volba=5;
  SaveObj(mist^.jmeno+'.'+s);
  DoneObj;
end;
{**************************************************************************}
procedure EditMist;
  procedure OtestujChuzi;
  begin
    if FileExist(game^.postava+'.an1') then JmenoHrdiny:=game^.postava else
    if FileExist(konf.cesty[4]+game^.postava+'.an1') then JmenoHrdiny:=game^.postava
    else begin
      standardnidialog('Postavička s tímto jménem existuje!',
        DColor[1], DColor[2], DColor[3], DColor[4], DColor[5], font,
        berunavedomi);
      exit;
    end;

    TestWalk;
{    PushMouse;
    MouseSwitchOff;
    if mist=nil then begin
      ClearScr(0);
    end else
    if mist^.barva=255 then PutImage(0,0,Mist^.Image)
    else ClearScr(mist^.barva);
    PopMouse;
    DrawMap(0,0,0,0,PWordArray(Mist^.GoMap)^[4],
          PWordArray(Mist^.GoMap)^[5], Mist^.GoMap);}
    DrawMist;
  end;
begin
  Volba:=1;
  repeat
    Volba:=vytvormenu('#Editace místnosti '+mist^.jmeno+':|~Editovat místnost|'
      +'Editovat ~masky|Editovat ~chůzi|Editovat ~perspektivu|Editovat ~r.'
      +' palety|#|~Test chuze|#|~Zpět', DColor[1], DColor[2], DColor[3],
      DColor[4], DColor[5], font, MenuX[35], MenuY[35], Volba, 7);
    case Volba of
      1 : EditovatMist(false);
      2 : if mist^.barva=255 then begin
            ClearIcons(255);
            EditMask(mist^.image);
            DrawMist;
          end else standardnidialog('Nemůžeš editovat masku,|když není obrázek!',
              DColor[1], DColor[2], DColor[3], DColor[4], DColor[5], font,
              berunavedomi);
      3 : if mist^.barva=255 then begin
            ClearIcons(255);
            EditMap(0,0,mist^.image,mist^.GoMap);
            mist^.BarvaMapyChuze:=ColorGoMap;
            DrawMist;
          end else standardnidialog('Nemůzeš editovat mapu chůze,|když není obrázek!',
              DColor[1], DColor[2], DColor[3], DColor[4], DColor[5], font,
              berunavedomi);
      4 : begin
            ClearIcons(255);
            NactiVztah(mist^.Image{,Ikony[4].p},mist^.barva,mist^.PLin,mist^.PAbs);
            DrawIcons(255,false);
            DrawMist;
          end;
      5 : NactiRotaciPal(mist^.pal,mist^.rotacepal);
      6 : Otestujchuzi
    end;
  until volba=7;
end;
{**************************************************************************}
var maska : byte;
    key : char;
begin
  if ParamCount>0 then begin
    CilovaCesta:=ParamStr(1);
    if cilovacesta[2]<>':' then begin
      getdir(0,cilovacesta);
      if cilovacesta[length(cilovacesta)]<>'\' then cilovacesta:=cilovacesta+'\';
      cilovacesta:=cilovacesta+ParamStr(1);
    end;
    if cilovacesta[length(cilovacesta)]<>'\' then cilovacesta:=cilovacesta+'\';
  end;
  if (ParamCount=2)and(ParamStr(2)='BACK')then begin
    WriteLn(#13#10'Zmackni tlacitko ....');
    ReadKey;
  end;
  InitGE;
{  Heslo; !!!!!!!}
  LoadGame;
  SetVisualPage(0);
  repeat
    repeat until (MouseKey<>0)or KeyPressed;
    JakaIkona:=TestIcons(255,254);
    SetActivePage(3);
    Maska:=GetPixel(MouseX,MouseY);
    SetActivePage(0);
    if keypressed then key:=UpCase(ReadKey) else Key:=#1;
    case key of
        'H' : JakaIkona:=0;
        'K' : JakaIkona:=1;
        'M' : JakaIkona:=2;
        'O' : JakaIkona:=3;
        'E' : if mist<>nil then EditMist;
        #9  : begin
                konf.paleta:= (1-(konf.paleta-1))+1;
                ReMapImages:=false;
                DrawMist;
              end;
        '0'..'9' : begin
                konf.sraf:=byte(key)-48;
                DrawMist;
              end;
        'R' : begin
                konf.krobrazky:=not konf.krobrazky;
                DrawMist;
              end;
        'S' : begin
                konf.krmasky:=not konf.krmasky;
                DrawMist;
              end;
        'P' : begin
                konf.krmapy:=not konf.krmapy;
                DrawMist;
              end;
        'C' : begin
                if standardnidialog('Chceš spustit kompilaci?', DColor[1],
                DColor[2], DColor[3], DColor[4], DColor[5], font, Ano_Ne)=1
                then Kompilace(2);
              end;
        #0  : case ReadKey of
                #59 : Help;                 #68 : VyberHry;
                #61 : VybratMist;
                #45 : Konec;
              end;
        ',' : standart1;
        '.' : standart2(2);
        '/' : standart3(2);
      end;
    repeat until MouseKey=0;
    case JakaIkona of
      0 : Hra;
      1 : Konfigurace(@Konf);
      2 : if Game^.JmenoHry='' then StandardniDialog('Nejprve musíš vyplnit INICIALIZACI HRY!',
            DColor[1], DColor[2], DColor[3], DColor[4], DColor[5], font, berunavedomi)
          else Mistnost;
      3 : Objekt;
      4..252 : EditaceObj(JakaIkona);
      254 : if (maska<>255)and(Game^.JmenoHry<>'')and(Mist<>nil)and(Mist^.barva=255)
              then EditMaskObj(maska)
              else if mist<>nil then EditMist;
    end;
  until JakaIkona=253;
  SaveGame;
  SaveMist;
  DoneMist;
  DoneGe;
  Halt(65535);
end.