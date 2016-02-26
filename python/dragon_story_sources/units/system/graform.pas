{$i-}
unit graform;
{"Graficke formaty"}
{Mozna by to chtelo napsat jeste nejake obecne obalove volani, ktere by
 zachovalo chybova hlaseni...
 Nekontroluje to dostatek pameti.
 GCC a GCF nactou jakoukoli velikost,
 PCX a BMP muzou pracovat jen s 320x200, pozdeji to ale muzeme
 uplne snadno rozsirit a zmenit}


interface

uses crt;

type
  TGraphFile= (BMP, PCX, LBM);
  {Define types comaptible with TPalette and PPalette from graph256.pas, which
  we don't want to import due to removing dependencies on it.}
  TPaletka = array[0..767] of byte;
  PPaletka = ^TPaletka;

{255= O.K.
 0= chybne otevreny soubor...
 1= je bitmapa, ale ne paleta (u GCC a GCF)
 2= spravny format, ale nepodporovana verze
 3= chyba behem cteni podporovaneho formatu a verze
 4= jiny (neznamy) format, nez jaky chceme cist
 }
function LoadGcf(var Image: pointer; var Paletka: PPaletka; Name: string): byte;
function LoadGcc(var Image: pointer; var Paletka: PPaletka; Name: string): byte;
function LoadBmp(var Image: pointer; var Paletka: PPaletka; Name: string): byte;
function LoadPcx(var Image: pointer; var Paletka: PPaletka; Name: string): byte;
function SaveBmp(Image: pointer; Paletka: PPaletka; Name: string): byte;
function SavePcx(Image: pointer; Paletka: PPaletka; Name: string): byte;
function LoadImage(var obr, pal : pointer; name : string) : byte;

implementation

const
  BufSize= 4096;
  {velikost dynamickeho bufferu u Load/SavePcx}
var
  GrFile: file;
  {obecne file pro vsechny formaty}
  Buffer: pointer;
  PosInBuf: word;
  {buffer a pozice v bufferu u Load/SavePcx}
  LineBuf: array[0..319]of byte;
  {buffer pro jeden radek u LoadGcc, Load/SaveBmp}
  LbmHeader: array[0..19]of byte;
  {hlavicka GrFile}

{The following 4 types and 1 procedure have been taken from graph256.pas to
remove the dependency of this module on it.}
  type
      TWordArray = array[0..32000] of word;
      PWordArray = ^TWordArray;
      TByteArray = array[0..65534] of byte;
      PByteArray = ^TByteArray;

  procedure NewImage(width, height : word; var P : pointer);
  { Vyhradi pamet pro obrazek }
  begin
    GetMem(P, width*height+4);
    PWordArray(P)^[0]:=width;
    PWordArray(P)^[1]:=height;
  end;

function ReadBuffered: byte;
begin
  if PosInBuf>= BufSize then begin
    PosInBuf:= 0;
    if (FilePos(GrFile)+BufSize< FileSize(GrFile) ) then
      BlockRead(GrFile, PByteArray(Buffer)^[0], BufSize)
    else BlockRead(GrFile, PByteArray(Buffer)^[0], FileSize(GrFile)-FilePos(GrFile));
    {Cte to vzdy jenom do konce souboru}
  end;
  ReadBuffered:= PByteArray(Buffer)^[PosInBuf];
  Inc(PosInBuf);
end;

procedure StoreBuffered(StByte: byte);
begin
  PByteArray(Buffer)^[PosInBuf]:= StByte;
  Inc(PosInBuf);
  if PosInBuf>= BufSize then begin
    PosInBuf:= 0;
    BlockWrite(GrFile, PByteArray(Buffer)^[0], BufSize);
  end;
end;

function LoadGcf(var Image: pointer; var Paletka: PPaletka; Name: string): byte;
var
  X, Y: word;
begin
  LoadGcf:= 0;
  Assign(GrFile, Name);
  Reset(GrFile, 1);
  if ioresult<>0 then Exit;
  BlockRead(GrFile, X, 2);
  if ioresult<>0 then begin
    Close(GrFile);
    Exit;
  end;
  BlockRead(GrFile, Y, 2);
  if ioresult<>0 then begin
    Close(GrFile);
    Exit;
  end;
  GetMem(Image, X*Y+4);
  PWordArray(Image)^[0]:= X;
  PWordArray(Image)^[1]:= Y;
  BlockRead(GrFile, PByteArray(Image)^[4], X*Y);
  if ioresult<>0 then begin
    Close(GrFile);
    Exit;
  end;
  Close(GrFile);
  { Nacitani palety }
  LoadGcf:= 1;
  Assign(GrFile, Copy(Name, 1, Length(Name)-3)+'pal');
  Reset(GrFile, 1);
  if ioresult<>0 then Exit;
  GetMem(Paletka, 768);
  BlockRead(GrFile, Paletka^, 768);
  if ioresult<>0 then begin
    Close(GrFile);
    Exit;
  end;
  LoadGcf:=255;
  Close(GrFile);
end;

function LoadGcc(var Image: pointer; var Paletka: PPaletka; Name: string): byte;
var
  i, j: word;
  X, Y: word;
begin
  LoadGcc:= 0;
  Assign(GrFile, Name);
  Reset(GrFile, 1);
  if ioresult<>0 then Exit;
  BlockRead(GrFile, X, 2);
  if ioresult<>0 then begin
    Close(GrFile);
    Exit;
  end;
  BlockRead(GrFile, Y, 2);
  if ioresult<>0 then begin
    Close(GrFile);
    Exit;
  end;
  GetMem(Image, X*Y+4);
  PWordArray(Image)^[0]:= X;
  PWordArray(Image)^[1]:= Y;
  for i:= 0 to Y-1 do begin
    BlockRead(GrFile, LineBuf[0], X);
    if ioresult<>0 then begin
      Close(GrFile);
      Exit;
    end;
    for j:= 0 to X-1 do
      PByteArray(Image)^[4+i+j*Y]:= LineBuf[j];
  end;
  Close(GrFile);
  { Nacitani palety }
  LoadGcc:= 1;
  Assign(GrFile, Copy(Name, 1, Length(Name)-3)+'pal');
  Reset(GrFile, 1);
  if ioresult<>0 then Exit;
  GetMem(Paletka, 768);
  BlockRead(GrFile, Paletka^, 768);
  if ioresult<>0 then begin
    Close(GrFile);
    Exit;
  end;
  LoadGcc:=255;
  Close(GrFile);
end;

function LoadBmp(var Image: pointer; var Paletka: PPaletka; Name: string): byte;
var
  i, j: word;
  Buf: byte;
  X, Y: word;
  Delka: word;
  Bit: byte;
const
  Header: string[2]= '..';
  {jako predem nastavena promenna proto, aby byla spravne nastavena delka=2}
begin
  LoadBmp:= 0;
  Assign(GrFile, Name);
  Reset(GrFile, 1);
  if ioresult<>0 then Exit;

  LoadBmp:= 4;
  BlockRead(GrFile, Header[1], 2);
  if Header<> 'BM' then Exit;
  {Overil jsem, jestli opravdu existuje hlavicka GrFile souboru}
  LoadBmp:= 2;
  BlockRead(GrFile, Delka, 2);
  if Delka<> $fe36 then Exit;
  {Pokud je jina delka, nez 65078 (256x320x200), nebudeme to cist}
  Seek(GrFile, $1c);
  BlockRead(GrFile, Bit, 1);
  if Bit<> 8 then Exit;
  {Musi byt presne 8 bits per pixel (tzn. 256 barev), jinak necteme}

  LoadBmp:= 3;
  GetMem(Paletka, 768);
  Seek(GrFile, 54);
  for i := 0 to 255 do begin
     BlockRead(GrFile, PByteArray(Paletka)^[i*3], 3);
     Seek(GrFile, FilePos(GrFile)+1);
  end;
  for i := 0 to 255 do begin
     Buf:= Paletka^[i*3];
     Paletka^[i*3]:= Paletka^[i*3+2];
     Paletka^[i*3+2]:= Buf;
  end;
  for i:=0 to 767 do Paletka^[i]:= Paletka^[i] shr 2;
  {nacteni a upraveni palety}

  Seek(GrFile, 18);
  BlockRead(GrFile, X, 2);
  if ioresult<> 0 then begin
    Close(GrFile);
    Exit;
  end;
  Seek(GrFile, 22);
  BlockRead(GrFile, Y, 2);
  if ioresult<> 0 then begin
    Close(GrFile);
    Exit;
  end;
  GetMem(Image, X*Y+4);
  PWordArray(Image)^[0]:= X;
  PWordArray(Image)^[1]:= Y;

  Seek(GrFile, 1078);
  for i:= Y-1 downto 0 do begin
    BlockRead(GrFile, LineBuf[0], X);
    for j:=0 to X-1 do PByteArray(Image)^[4+i+j*Y]:= LineBuf[j];
  end;

  LoadBmp:= 255;
  Close(GrFile);
end;

function SaveBmp(Image: pointer; Paletka: PPaletka; Name: string): byte;
const
  Header: string[2]= 'BM';
  Delka: word= $fe36;
  Start: word= $0436;
  X: word= $0140;
  Y: word= $00c8;
  Bit: byte= 8;
  Unknown: byte= $28;
  One: byte= 1;
var
  Buf: byte;
  i, j: word;
  AuxPtr: pointer;
begin
  SaveBmp:= 2;
  if (PWordArray(Image)^[0]<> 320)or(PWordArray(Image)^[1]<>200) then Exit;
  SaveBmp:= 0;
  Assign(GrFile, Name);
  Rewrite(GrFile, 1);
  if ioresult<>0 then Exit;

  Buf:= 0;
  for i:= 0 to 54 do BlockWrite(GrFile, Buf, 1);
  {nejdriv vyplnim zacatek nulami}

  {A pak do nej ulozim hlavicku:}
  Seek(GrFile, 0);
  BlockWrite(GrFile, Header[1], 2);
  BlockWrite(GrFile, Delka, 2);
  Seek(GrFile, 10);
  BlockWrite(GrFile, Start, 2);
  Seek(GrFile, 14);
  BlockWrite(GrFile, Unknown, 1);
  Seek(GrFile, $12);
  BlockWrite(GrFile, X, 2);
  Seek(GrFile, $16);
  BlockWrite(GrFile, Y, 2);
  Seek(GrFile, $1a);
  BlockWrite(GrFile, One, 1);
  Seek(GrFile, $1c);
  BlockWrite(GrFile, Bit, 1);

  GetMem(AuxPtr, 768);
  Move(Paletka^, AuxPtr^, 768);
  for i := 0 to 255 do begin
    Buf:= PByteArray(AuxPtr)^[i*3];
    PByteArray(AuxPtr)^[i*3] := PByteArray(AuxPtr)^[i*3+2];
    PByteArray(AuxPtr)^[i*3+2] :=Buf;
  end;
  for i:=0 to 767 do PByteArray(AuxPtr)^[i]:= Byte(PByteArray(AuxPtr)^[i] shl 2);
  Seek(GrFile, 54);
  for i := 0 to 255 do begin
    BlockWrite(GrFile, PByteArray(AuxPtr)^[i*3], 3);
    Seek(GrFile, FilePos(GrFile)+1);
  end;
  FreeMem(AuxPtr, 768);
  {ulozeni palety}

  Seek(GrFile, 1078);
  for j:=199 downto 0 do begin
    for i:=0 to 319 do LineBuf[i]:= PByteArray(Image)^[4+i*200+j];
    BlockWrite(GrFile, LineBuf[0], 320);
  end;
  {ulozeni bitmapy}

  SaveBmp:= 255;
  Close(GrFile);
end;

function LoadPcx(var Image: pointer; var Paletka: PPaletka; Name: string): byte;
var
  PCXSize: longint;
  i, j, counter: word;
  AuxByte: byte;
  AuxWord: word;
  X1, Y1, X2, Y2: word;

begin
  LoadPcx:= 0;
  Assign(GrFile, Name);
  Reset(GrFile, 1);
  if ioresult<>0 then Exit;
  {Chyba pri otvirani}

  PCXSize:= FileSize(GrFile);
  {A nyni obslouzime hlavicku:}
  LoadPcx:= 4;
  BlockRead(GrFile, AuxByte, 1);
  if AuxByte<> $0A then Exit;
  {Header obrazku GrFile musi byt byte $0A}
  BlockRead(GrFile, AuxByte, 1);
  LoadPcx:= 2;
  BlockRead(GrFile, AuxByte, 1);
  if AuxByte<> 1 then Exit;
  {1 je Run-Length komprese, jedine tu my zname}
  BlockRead(GrFile, AuxByte, 1);
  if AuxByte<> 8 then Exit;
  {my bereme jedine 8 bits per pixel}
  BlockRead(GrFile, X1, 2);
  if X1<> 0 then Exit;
  BlockRead(GrFile, Y1, 2);
  if Y1<> 0 then Exit;
  BlockRead(GrFile, X2, 2);
  if X2<> 319 then Exit;
  BlockRead(GrFile, Y2, 2);
  if Y2<> 199 then Exit;
  Seek(GrFile, $40);
  BlockRead(GrFile, AuxByte, 1);
  if AuxByte<> 0 then Exit;
  BlockRead(GrFile, AuxByte, 1);
  if AuxByte<> 1 then Exit;
  {pocet bitovych rovin(planes) bereme jedine 1}
  BlockRead(GrFile, AuxWord, 2);
  if AuxWord<> 320 then Exit;
  {jedine 320 bytes per line...}

  {Ted obrazova data:}
  GetMem(Image, (X2+1)*(Y2+1)+4);
  PWordArray(Image)^[0]:= X2+1;
  PWordArray(Image)^[1]:= Y2+1;
  GetMem(Buffer, BufSize);
  PosInBuf:= BufSize;
  Seek(GrFile, 128);
  for i:= 0 to 199 do begin
    j:= 0;
    while j< 320 do begin
      AuxByte:= ReadBuffered;
      if((AuxByte AND $C0)<> $C0) then begin
        PByteArray(Image)^[4+i+(j*200)]:= AuxByte;
        Inc(j);
      end else begin
        counter:= (AuxByte AND $3F);
        AuxByte:= ReadBuffered;
        while counter> 0 do begin
          PByteArray(Image)^[4+i+(j*200)]:= AuxByte;
          Inc(j);
          Dec(counter);
        end;
      end;
    end;
  end;
  FreeMem(Buffer, BufSize);

  GetMem(Paletka, 768);
  Seek(GrFile, PCXSize-768);
  BlockRead(GrFile, Paletka^[0], 768);
  for i:=0 to 767 do Paletka^[i]:= Paletka^[i] shr 2;
  {nacteni a upraveni palety}

  LoadPcx:= 255;
  Close(GrFile);
end;

function SavePcx(Image: pointer; Paletka: PPaletka; Name: string): byte;
const
  Header1: array[0..15]of byte= (
    $0A, {Header formatu PCX}
    $05, {Verze PCX}
    $01, {Run-Length komprese}
    $08, {8 bites per pixel}
    $00, $00, $00, $00, {levy horni roh vyrezu}
    $3F, $01, $C7, $00, {pravy dolni roh- 319, 199}
    $40, $01, $C8, $00  {rozliseni zarizeni: 320 x 200}
    );
  Header2: array[0..5]of byte= (
    $00, {?}
    $01, {jedna bitova rovina}
    $40, $01, {320 bytes per line}
    $00, $00  {jakesi "palette info" - byva i kombinace $01,$00 }
    );
var
  Buf: byte;
  i, j, counter: word;
  AuxPtr: pointer;
  AuxByte: byte;


begin
  SavePcx:= 2;
  if (PWordArray(Image)^[0]<> 320)or(PWordArray(Image)^[1]<>200) then Exit;
  SavePcx:= 0;
  Assign(GrFile, Name);
  Rewrite(GrFile, 1);
  if ioresult<>0 then Exit;

  BlockWrite(GrFile, Header1[0], 16);
  {zapisu prvni cast hlavicky}
  GetMem(AuxPtr, 768);
  Move(Paletka^, AuxPtr^, 768);
  for i:=0 to 767 do PByteArray(AuxPtr)^[i]:= (Byte(PByteArray(AuxPtr)^[i] shl 2))OR 3;
  {upravil jsem paletu}
  BlockWrite(GrFile, PByteArray(AuxPtr)^[0], 48);
  {ulozim prvnich 16 barev do hlavicky}
  BlockWrite(GrFile, Header2[0], 6);
  Buf:= 0;
  for i:= 0 to 57 do BlockWrite(GrFile, Buf, 1);
  {pak nasleduje 58 nul}

  GetMem(Buffer, BufSize);
  PosInBuf:= 0;
  for i:= 0 to 199 do begin
    j:= 0;
    while j< 320 do begin
      AuxByte:= PByteArray(Image)^[4+i+(j*200)];
      counter:= j;
      while (AuxByte= PByteArray(Image)^[4+i+(j*200)])
      and(j< 320)and((j-counter)<63) do Inc(j);
      counter:= (j-counter) OR $C0;
      if (counter= $C1)and((AuxByte AND $C0)<> $C0)then begin
        StoreBuffered(AuxByte);
      end else begin
        StoreBuffered(counter);
        StoreBuffered(AuxByte);
      end;
    end;
  end;
  BlockWrite(GrFile, PByteArray(Buffer)^[0], PosInBuf);
  {zapisu zbyla data z bufferu}
  FreeMem(Buffer, BufSize);
  {a uvolnim buffer}

  AuxByte:= $0C;
  BlockWrite(GrFile, AuxByte, 1);
  {Verze 5 PCX tady ma $0C oznamujici konec pakovane bitmapy}

  BlockWrite(GrFile, PByteArray(AuxPtr)^[0], 768);
  {ulozim celou paletu}
  FreeMem(AuxPtr, 768);
  {a uvolnim misto, kde pracovne byla paleta}

  SavePcx:= 255;
  Close(GrFile);
end;

function LoadLbm(var Image: pointer; var Paletka: PPaletka; Name: string): byte;
{Z hlavicky testuju informace, o kterych si myslim, ze jsou relevantni,
 ostatni ignoruju. To ale neznamena, ze v nich trebas neni neco duleziteho,
 co nevim...}
{Nekontroluje to taky IOResult kazde diskove operace, jen testuje spravne
 otevreni}
{GrFile je vpodstate krasny a srozumitelny format; kazda jeho cast je uvozena
 ctyrpismennym popisem (jakousi znackou, labelem), za kterym nasleduje
 longint v Amiga formatu s delkou te oblasti. Casti navazuji jedna na druhou.
 Uzasne!}
label closelbm;
const
  LbmStr: string[4]= 'FORM'; {"za mnou se nachazi soubor GrFile, veliky mimo mne..."}
  SubType: string[4]= 'PBM '; {derivat formatu, pouzivany DPIIe}
  BitHeader: string[4]= 'BMHD'; {"Bitmap header"}
  Labels: array[1..5]of string[4]=
    ( 'CMAP', {uvozuje paletu}
      'DPPS', {uvozuje kdovico...}
      'CRNG', {uvozuje kazdy ze 16 gradientu o delce 8}
      'TINY', {uvozuje zmenseny informacni obrazek- pakovany!}
      'BODY'  {uvozuje vlastni bitmapu});
var
  AuxString: string[4];
  X1, Y1, X2, Y2: word; {sirka vyska nacteneho obr.}
  i: byte;

  function AmigaLI: longint;
  var Buf: array[0..3]of byte;
  begin
    BlockRead(GrFile, Buf[0], 4);
    AmigaLI:= Buf[0]*65536*256+Buf[1]*65536+Buf[2]*256+Buf[3];
  end;

  function WhichBlock: byte;
  var i, j: byte;
{  label tenhlene;}
  begin
    AuxString[0]:= #4;
    BlockRead(GrFile, i, 1);
    if i= 0 then BlockRead(GrFile, AuxString[1], 4)
    {DPIIe si sem obcas ulozi nulu, pitomecek}
    else begin
      AuxString[1]:= char(i);
      BlockRead(GrFile, AuxString[2], 3);
    end;
(*
Oboje prelozil BP uplne stejne dlouhe, dam radeji ten strukturovanejsi}
    for i:= 1 to 5 do begin
      WhichBlock:= 0;
      for j:= 1 to 4 do if AuxString[j]<>Labels[j] then goto tenhlene;
      WhichBlock:= i;
      Break;
    tenhlene:
    end;
*)
    for i:= 1 to 5 do begin
      j:= 1;
      while AuxString[j]=Labels[i, j] do Inc(j);
      if j=5 then begin
        WhichBlock:= i;
        Exit;
      end;
    end;
    WhichBlock:= 0;
  end;

  procedure ReadCMAP;
  var i: integer;
  begin
    AmigaLI;
    {Jsou tady 4 byte s delkou palety v bytes}
    GetMem(Paletka, 768);
    BlockRead(GrFile, Paletka^[0], 768);
    for i:=0 to 767 do Paletka^[i]:= Paletka^[i] shr 2;
    {nacteni a upraveni palety}
  end;

  procedure ReadBODY;
  var Color, HowMany: byte;
      Stop, X, Y: word;
  begin
    AmigaLI;
    {preskocim delku body}
    X:= 0; Y:= 0;
    {Ted obrazova data:}
    NewImage(X2, Y2, Image);
    GetMem(Buffer, BufSize); PosInBuf:= BufSize;
    while (Y<Y2) do begin
      HowMany:= ReadBuffered;
      if(HowMany>= $80) then begin
        {nasleduje 256-AuxByte+1 komprimovanych pixelu}
        Color:= ReadBuffered;
        HowMany:= 257-HowMany; Stop:= X+HowMany;
        while X< Stop do begin
          PByteArray(Image)^[4+Y+(X*Y2)]:= Color; Inc(x);
        end;
        if X>=X1 then begin X:= 0; Inc(Y); end;
      end else begin
        {nasleduje AuxByte+1 nekomprimovanych pixelu}
        Stop:= X+HowMany+1;
        while X< Stop do begin
          PByteArray(Image)^[4+Y+(X*Y2)]:= ReadBuffered; Inc(x);
        end;
        if X>=X1 then begin X:= 0; Inc(Y); end;
      end;{else}
    end;{while Pels<64000}
    FreeMem(Buffer, BufSize);
  end;{ReadBODY}

begin
  LoadLBM:= 0;
  Assign(GrFile, Name);
  Reset(GrFile, 1);
  if ioresult<>0 then Exit;
  {Chyba pri otvirani}
  LoadLBM:= 4;
  BlockRead(GrFile, AuxString[1], 4);
  for i:= 1 to 4 do if AuxString[i]<>LbmStr[i] then goto closelbm;
  {LbmHeader obrazku GrFile musi byt 'FORM'}
  if AmigaLI<>(FileSize(GrFile)-8) then {goto closelbm};
  {Dalsi ctyri bajty od pozice 4 obsahuji delku filu od pozice 8,
   (v Amiga formatu HI(Hi,Lo),LO(Hi,Lo)...) }
  {U nekterych fajlu to nesouhlasi, nevim proc. Asi si to DPIIe
   uklada jak chce...}
  LoadLBM:= 2;
  BlockRead(GrFile, AuxString[1], 4);
  for i:= 1 to 4 do if AuxString[i]<>SubType[i] then goto closelbm;
  {Existuji dva podtypy GrFile: 1) ILBM - prevzaty z Amigy  2) PBM podporovany
   DPIIe na PC. PBM ma zprav. ucinnejsi kompresi. My cteme PBM}
  BlockRead(GrFile, AuxString[1], 4);
  for i:= 1 to 4 do if AuxString[i]<>BitHeader[i] then goto closelbm;
  {Hlavicka, ktera uvozuje dalsi hlavicku... uh...}
  if AmigaLI<>$14 then goto closelbm;;
  { $14(=20d) delka hlavicky, co tam dava DPI, DPIIe, camera i GWS...}
  BlockRead(GrFile, LbmHeader[0], 20);
  if LbmHeader[8]<>$08 then goto closelbm;;
  {My cteme pouze 256 barevny obr, tj. 8 bites per pixel...}
  if LbmHeader[10]<>$01 then goto closelbm;;
  {Nevim proc, 1 tam dava DPI, DPIIe, camera i GWS...}
  X2:= LbmHeader[0]*256+LbmHeader[1];
  Y2:= LbmHeader[2]*256+LbmHeader[3];
  {rozmery obrazku}
  X1:= LbmHeader[16]*256+LbmHeader[17];
  Y1:= LbmHeader[18]*256+LbmHeader[19];
  {velikost rozliseni}
  if (LbmHeader[0]*256+LbmHeader[1])<>320 then goto closelbm;
  if (LbmHeader[2]*256+LbmHeader[3])<>200 then goto closelbm;
  if (LbmHeader[16]*256+LbmHeader[17])<>320 then goto closelbm;
  if (LbmHeader[18]*256+LbmHeader[19])<>200 then goto closelbm;
  {Ctu (zatim) jenom 320x200}
  {-->LBM je format z Amigy a ta uklada ve formatu Hi, Lo !!}

{  if LbmHeader[17]<>$FF then goto closelbm;;}
  {Nesmysl, byva tady dost ruzne cislo...}
  {Nevim proc, $FF tam dava DPI, DPIIe, camera i GWS...}

  {Bacha, cosi je jeste na 18,19 - $05 $06 od DPI, DPIIe
                                   $10 $0A od GWS
   ...zrejme to nezavisi na pouzite kompresi...(??!)}

{Za hlavickou jsou uz jednotlive bloky informaci; pro pripad, ze
 jsou za sebou poskladane ruzne, mam tento cyklus:}

  while not Eof(GrFile) do begin
    case WhichBlock of
      1: ReadCMAP;
  {    2: ReadDPPS;
      3: ReadCRNG;
      4: ReadTINY;}
      5: begin
      ReadBODY;
      end;
    else
      Seek(GrFile, FilePos(GrFile)+AmigaLI);
    end;
  end;
  LoadLBM:= 255;
closelbm:
  Close(GrFile);
end;

function LoadImage(var obr, pal : pointer; name : string) : byte;
var i : byte;
    konec : string;
begin
  for i:=1 to length(name) do name[i]:=UpCase(name[i]);
  while (i<>0)and(name[i]<>'.')do dec(i);
  Konec:=Copy(name,i+1,length(name)-i);
  if konec = 'GCF' then LoadImage:= LoadGCF(obr, PPaletka(pal), name);
  if konec = 'GCC' then LoadImage:= LoadGCC(obr, PPaletka(pal), name);
  if konec = 'BMP' then LoadImage:= LoadBMP(obr, PPaletka(pal), name);
  if konec = 'PCX' then LoadImage:= LoadPCX(obr, PPaletka(pal), name);
  if konec = 'LBM' then LoadImage:= LoadLBM(obr, PPaletka(pal), name);
end;


end.
