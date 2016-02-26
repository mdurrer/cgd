{!!!!ááááááááá: doprčic, zhroutí se to někde v Compress při ukládání animace,
                když se to správně zakomprimuje (zde pravděp. nebezpečí
                nehrozí), ale size už se přiřazuje někam jinam!!!!!
 bob 14.3.95: u (de)compress target->_target; ale to nebylo k ničemu...
 už vím: to bylo pouze tím, že po zavolání new to vrátilo něco kolem
 9999:9999 a to je ROM a tam ač jsem zapisoval, stále bylo ffh; ale nevrá-
 tilo mi to náhodou EMS? a proč se tak vůbec stalo?????
hroutí se při ladění tohoto i BP při ^F4 a MemAvail!!!!!


 bob 6.3.95ad: ty h..zl., co si to o sobě myslíš? řádek číslo 485 a 532!
 bob 22.11.94: vylepsena cloaditem, at se pri chybe cteni nepokousi zavirat
               soubor
 kroco : jak muzes napsat kvalitni (je to sileny ksindl), rychly (tak
         debilne pomaly) a s velkou kapacitou (do 64kb) archiv?????
         + s omezenim na max. pocet souboru v archivu + nemuzes soubory
         mazat a presto mas vepredu tabulku pozic, jakoby tam byly diry!
       tys ani nikdy nevidel pkzip!!!!!
 grrrrrrrrrr}
{pridana funkce CReadItem - velice nutna, comment primo u ni}

{Takze opet pouzivam svuj opraveny DFW. Lukas mi nahraval svuj opraveny
 a ja jsem to vzal tak, ze je to nejnovejsi OK verze a ona to vpodstate
 byla nejsrtarsi KO.
 Dodelal jsem semka Lukasuv fix chyby, ze to nekontroluje misto, vyhrazene
 pro kompresi a muze se stat, ze to bude komprimovat i jinam a poskodi
 to tak jina data.
 Takze jsem k GetMemu v CAddFromMemory a este kdesi(kde, sakra?!) pridal
 navic 200 byte... prozatim}

{Opravil jsem CEraseItem, sezralo mi to tak 1,5 hodiny zbytecny prace, kdyz
 pripocitam i to, ze mi program blbnul a nevedel jsem, proc!}
{Vzhledem k tomu, ze tato knihovna, troufam si tvrdit, bude mit jeste
 spoustu nedostatku, o kterych zatim nevime, vime jenom, ze budou, a az
 se je dozvime, budeme zase o neco vic nasrani, doporucuju prozatim
 nemenit hlavicku programu, ktera je nize, a kterou jsem byl z duvodu
 cisteho svedomi nucen trosku upravit.}
{****************************************************************************}
{**                        DFW  -  DATA FILE WORK                          **}
{**                   chybny kod :    by PETR                              **}
{**               spravny kod(moc ho neni) : vsichni ostatni               **}
{**    copyright radeji neuveden, lepsi je se k tomu nehlasit...           **}
{**                        Leta Pane 1994 VERZE  miiinus 7.2               **}
{** NEKVALITNI A RADOBYRYCHLY ARCHIV S VELMI POCHYBNOU KAPACITOU - TO JE : **}
{**                                                                        **}
{**                      ###     ######## #       #                        **}
{**                      #  #    #        #       #                        **}
{**                      #   #   #####    #  ###  #                        **}
{**                      #   #   #        # #   # #                        **}
{**                      #  #    #        ##     ##                        **}
{**                      ###     #        #       #                        **}
{**                                                                        **}
{****************************************************************************}
{$R-,S-,V-,I-,A+}
{U vsech vysledku logickych funkci: False znamena neuspech !}

Unit Dfw;

INTERFACE

Type MyP1=Array[0..2] of Byte;
     MyPointer=^MyP1;

{PROCEDURY PRO KOMPRIMACI A DEKOMPRIMACI DAT}
Procedure Compress(Source, _Target : MyPointer; Size : Word);
Procedure DeCompress(Source, _Target : MyPointer);
Function  CompSize(Source : MyPointer) : Word;
{PROCEDURY PRO PRACI SE SOUBORY}
Function SaveData(FName : String; Source : Pointer; Size : Word) : Boolean;
Function LoadData(FName : String; Var Target : Pointer) : Word;
Function ODataSize(FName : String) : Word; {Rekne delku originalu - musi byt zabaleno SaveDatem}
{PROCEDURY PRO VYTVARENI ARCHIVU}
Function FileExist(FName : String) : Boolean; {Zjisti jestli soubor existuje}
{ARCHIVACE BEZ KOMPRESE}
Function AddFromFile(Archiv, Supplement : String) : Word; {Pridava ze souboru do archivu}
Function AddFromMemory(Archiv : String; Supplement : Pointer; SuppSize : Word) : Word; {Pridava z pameti do archivu}
Function LoadItem(Archiv : String; Var Destination : Pointer; Which : Word) : Word; {Nahraje soubor do pameti}
Function ItemSize(Archiv : String; Which : Word) : Word; {Zjisti delku souboru}
{ARCHIVACE S KOMPRESI}
Function CAddFromFile(Archiv : String; Supplement : String) : Word;
Function CAddFromMemory(Archiv : String; Supplement : Pointer; SuppSize : Word) : Word;
Function CLoadItem(Archiv : String; Var Destination : Pointer; Which : Word) : Word; {Nahraje soubor do pameti}
Function CReadItem(Archiv :  String; Destination : Pointer; Which : Word) : Word;
   {Predpoklada, ze na Dest je uz predem vyhrazene misto!!}
Function UnpackedItemSize(Archiv : String; Which : Word) : Word; {Zjisti delku souboru}
Function PackedItemSize(Archiv : String; Which : Word) : Word; {Zjisti delku souboru}
Function GetArchiveAvail(Archiv : String) : Word; {Vysledkem je pocet volnych pozic}
Function GetArchiveOccupy(Archiv : String) : Word; {Vysledkem je pocet obsazenych pozic}
Function SetArchiveCapacity(Cpct : Word) : Boolean; {Pred zakladanim}
{PRO CRC ARCHIVU}
Function SetArchiveCRC(Archiv : String) : Boolean; {Nastavi CRC archivu, vystup - uspesnost}
Function TestArchiveCRC(Archiv : String) : Boolean; {Testuje CRC}
{OSTATNI}
Function ExtractItem(ArchivF, OutFile : String; WhichI : Word) : Boolean;
Function CExtractItem(ArchivF, OutFile : String; WhichI : Word) : Boolean;
Function EraseItem(Archiv : String; Which : Word) : Boolean;
Function CEraseItem(Archiv : String; Which : Word) : Boolean;
Function ExpandArchive(Archiv : String; KMuch : Word) : Boolean;
Function CExpandArchive(Archiv : String; KMuch : Word) : Boolean;

IMPLEMENTATION

Const FileHead:Array[1..2] of Char=('B','S'); {Hlavicka v souboru}

Var F,F1:File;                   {Soubory}
    SizeTable:Word;              {Delka itemu v archivu}
    PostTable:LongInt;           {Pozice itemu v archivu}
    Buffer,Target:MyPointer;     {Pro komprimaci}
    Stopper:Byte;                {Pro komprimaci}
    Table:Array [0..255] of Word;{Pro komprimaci - na hodnoceni ascii}
    Rept,ToNow,Size,Pos:Word;    {Pro komprimaci}
    Ld : Word;                   {Pro cyklus}
    CtrlSize,CRC:LongInt;        {Pro kontrolu korektnosti archivu}
    NewPosition : LongInt;       {Pro mazani Itemu z archivu}
    RError, RErrors:Boolean;     {I/O chyba pri zapisu/cteni archivu}
    Files:Word;                  {Pocet itemu v archivu}
    Kapacita,StKapacita:Word;    {Maximalni kapacita archivu}
    CSize:Word;                  {Delka souboru v archivu}
    SuppSize:Word;               {Delka dodavaneho itemu}
    NRead:Word;                  {Vyjadruje, kolik bytes bylo precteno pri BLOCKREADu}
    ExDest:Pointer;              {Buffer pro extrakci do externiho souboru}

{PROCEDURY PRO KOMPRIMACI A DEKOMPRIMACI DAT}

{Zkomprimuje pointer Source do pointeru Target}
Procedure Compress(Source, _target : MyPointer; Size : Word);
Var Much:Word;
begin
  Dec(Size);
  For Rept:=0 to 255 do
    Table[Rept]:=0;
  For Rept:=0 to Size do
    Inc(Table[Byte(Source^[Rept])]);
  Stopper:=0;
  For Rept:=1 to 255 do
    If Table[Rept]<Table[Stopper] then Stopper:=Rept;
  Much:=0;
  ToNow:=3;
  Byte(_target^[2]):=Byte(Stopper);
  For Rept:=0 to Size do
  begin
    If Byte(Source^[Rept])=Stopper then
    begin
      Byte(_target^[ToNow]):=Stopper;
      Inc(ToNow);
      Byte(_target^[ToNow]):=0;
      Inc(ToNow);
    end else
    begin
      If (Byte(Source^[Rept])=Byte(Source^[Rept+1]))and(Much<253)and(Rept<Size) then
      begin
        If Much=0 then
        begin
          If (Byte(Source^[Rept+1])=Byte(Source^[Rept+2]))
          and(Byte(Source^[Rept+2])=Byte(Source^[Rept+3])) then
          begin
            Inc(Much)
          end else
          begin
            Byte(_target^[ToNow]):=Byte(Source^[Rept]);
            Inc(ToNow);
          end;
        end else
          Inc(Much);
      end else
      begin
        If Much>0 then
        begin
          Byte(_target^[ToNow]):=Stopper;
          Inc(ToNow);
          Byte(_target^[ToNow]):=Much+1;
          Inc(ToNow);
          Byte(_target^[ToNow]):=Byte(Source^[Rept]);
          Inc(ToNow);
          Much:=0;
        end else
        begin
          Byte(_target^[ToNow]):=Byte(Source^[Rept]);
          Inc(ToNow);
        end;
      end;
    end;
  end;
  Byte(_target^[0]):=Byte((ToNow) mod 256);
  Byte(_target^[1]):=Byte((ToNow) div 256);
end;

{Dekomprimuje pointer Source do pointeru _target}
Procedure DeCompress(Source, _target : MyPointer);
begin
  Size:=Byte(Source^[1])*256+Byte(Source^[0]);
  Stopper:=Byte(Source^[2]);
  Pos:=0;
  Rept:=3;
  While Rept<Size do
  begin
    If (Byte(Source^[Rept])=Stopper) and (Byte(Source^[Rept+1])<>0) then
    begin
      For Pos:=Pos to Pos+Byte(Source^[Rept+1])-1 do
        Byte(_target^[Pos]):=Byte(Source^[Rept+2]);
      Inc(Pos);
      Inc(Rept,2);
    end else
    begin
      _target^[Pos]:=Byte(Source^[Rept]);
      If (Byte(Source^[Rept])=Stopper) and (Byte(Source^[Rept+1])=0) then Inc(Rept);
      Inc(Pos);
    end;
    Inc(Rept);
  end;
end;

{Vysledkem je delka zkomprimovaneho pointeru Source}
Function CompSize(Source:MyPointer):Word;
begin
  CompSize:=Byte(Source^[1])*256+Byte(Source^[0]);
end;



{********* PROCEDURY PRO PRACI S KOMPRIMOVANYMI SOUBORY *********}



{Cesta,Pointer,Velikost nekomprimovaneho(Kvuli auto. mem. rezervaci)}
Function SaveData(FName: String; Source : Pointer; Size : Word) : Boolean;
Var BSize:Word;
begin
  SaveData:=True; {Nastavi na dobry vysledek operace}
  BSize:=Size+3+(Size Div 256); {Vypocet pro rezervaci operacni pameti}
  If MaxAvail<BSize then begin SaveData:=False; Exit; end; {Nedostatek mista v pameti}
  GetMem(Buffer,BSize); {Rezervace operacni pameti prikazu}
  Assign(F,FName); {Soubor}
  Rewrite(F,1);
  If IOResult<>0 then SaveData:=False;
  BlockWrite(F,Size,2); {Zapsani delky rozpakovaneho souboru}
  If IOResult<>0 then SaveData:=False;
  Compress(Source,Buffer,Size); {Vlastni komprimace}
  BlockWrite(F,Buffer^,CompSize(Buffer)); {Zapsani komprimatu do souboru}
  If IOResult<>0 then SaveData:=False;
  Close(F); {Uzavreni souboru}
  FreeMem(Buffer,BSize); {Uvolneni operacni pameti..}
end;

Function LoadData(FName: String; Var Target : Pointer) : Word;
Var UnCoSize:Word;
begin
  RError:=True; {Nastavi na dobry vysledek}
  Assign(F,FName); {Soubor}
  Reset(F,1);
  If IOResult<>0 then RError:=False;
  BlockRead(F,UnCoSize,2); {Nacteni puvodni delky pro rezervaci pameti}
  If IOResult<>0 then RError:=False;
  BlockRead(F,Size,2); {Nacteni delky komprimatu}
  If IOResult<>0 then RError:=False;
  Seek(F,FilePos(F)-2); {Nastaveni zpet pro rozpakovani}
  If MaxAvail<UnCoSize then begin LoadData:=0; Exit; end; {Nedostatek pameti}
  GetMem(Target,UnCoSize); {Rezervace pameti pro rozpakovana data}
  GetMem(Buffer,Size); {Rezervace operacni pameti pro komprimat}
  BlockRead(F,Buffer^,Size); {Nacteni komprimatu}
  If IOResult<>0 then RError:=False;
  Close(F); {Uzavreni souboru}
  DeCompress(Buffer,Target); {Dekomprese do zvoloneho pointeru}
  FreeMem(Buffer,Size); {Uvolneni operacni pameti po komprimatu}
  If Not RError then LoadData:=0 else LoadData:=UnCoSize;
end;

{Vrati originalni delku souboru, ktery byl zkomprimovan pomoci savedata}
Function ODataSize(FName : String) : Word;
begin
  RError:=True; {Nastavi na bezchybovost}
  Assign(F,FName);
  Reset(F,1); {Otevreni souboru}
  BlockRead(F,Size,2); {Nacteni delky ze souboru}
  If IOResult<>0 then RError:=False; {Pokud chyba}
  Close(F); {Uzavre soubor}
  {Pokud byla chyba, vysledek funkce je 0}
  If Not RError then ODataSize:=0 else ODataSize:=Size;
end;



{*******  POMOCNE PROCEDURY PRO VYTVARENI ARCHIVU (KOMP. i NEKOMP.)  *******}
{*******  UZIVATELI KNIHOVNY BEZ PREPROGRAMOVANI NEDOSTUPNE !!!!!!!  *******}



{Zjistuje, jestli je soubor na disku}
Function  FileExist(FName : String) : Boolean;
Var ExF:File;
begin
  Assign(ExF,FName);
  Reset(ExF,1); {Otevre soubor}
  If IOResult=0 then begin FileExist:=True; Close(Exf);
  end else FileExist:=False; {Vysledek ......}
end;

{Ulozi hlavicku do archivu}
Procedure SaveHead(WhichF : Word);
begin
  Seek(F,6*WhichF);
  {Nastavi se do tabulky na misto, ktere patri itemu WhichF}
  BlockWrite(F,SizeTable,2);
  {Zapise, kolik mista zabira item se vsemi jeho daty}
  BlockWrite(F,PostTable,4);
  {Zapise pocatecni pozici itemu v archivu}
end;

{Precte hlavicku z archivu}
Procedure LoadHead(WhichF : Word);
begin
  Seek(F,6*WhichF); {Nastavi se na misto, kde je tabulka}
  BlockRead(F,SizeTable,2);  {Nacte tabulku delek}
  BlockRead(F,PostTable,4);  {Nacte tabulku pozic}
end;

{Vytvori 255 volnych pozic pro tabulky - jen pro zakladani archivu}
Procedure MakeHead;
begin
  SizeTable:=0; {Vynuluje tyto promenne,}
  PostTable:=0; {aby v archivu nebyly nesmysly = ciste tabulky}
  Seek(F,6);    {Nastavi se na misto prvni tabulky}
  For Ld:=1 to StKapacita do {Vytvori misto pro 255 tabulek}
  begin
    BlockWrite(F,SizeTable,2); {Zapise delku (0)}
    BlockWrite(F,PostTable,4); {Zapise pozici(0)}
  end;
end;


{************* ARCHIVACE BEZ KOMPRESE *************}



{Pridava soubor Supplement do archivu, pri uspechu je vysledkem cislo souboru
v archivu}
Function AddFromFile(Archiv, Supplement : String) : Word;
begin
  RError:=True; {Nastavi na nechybovost}
  Assign(F,Archiv);
  Assign(F1,Supplement);
  Reset(F1,1); {Otevre dodavany soubor}
  If IOResult<>0 then begin AddFromFile:=0; Exit; end;
  {Pokud je delka souboru vetsi nez 1 pointer, archivace se neprovede}
  CtrlSize:=FileSize(F1);
  If CtrlSize>65535 then begin Close(F1); WriteLn('Error: #File is too long for archive !'); Exit; end;
  SuppSize:=CtrlSize; {Zjisti jeho delku}
  {Pokud je soubor delsi, nez je mozne, vynada ti to}
  If Not FileExist(Archiv) then {Pokud soubor neexistuje}
  begin
    Files:=1; {Nastaveni poctu souboru v archivu na jeden}
    Rewrite(F,1);
    If IOResult<>0 then RError:=False;
    BlockWrite(F,Files,2); {Zapsani poctu souboru do archivu}
    BlockWrite(F,StKapacita,2);
    If IOResult<>0 then RError:=False;
    BlockWrite(F,FileHead,2); {Zapsani napisu LIST}
    If IOResult<>0 then RError:=False;
    MakeHead;
    PostTable:=FilePos(F); {Zapsani pozice prvniho s. do tabulky}
    SizeTable:=SuppSize; {Zapsani delky prvniho s. do tabulky}
    SaveHead(Files);
    Seek(F,PostTable); {Zpetne nastaveni se na pozici prvniho souboru}
  end else
  begin
    Reset(F,1);
    BlockRead(F,Files,2); {Nacteni poctu souboru v archivu}
    BlockRead(F,Kapacita,2); {Nacte do Kapacity, aby neprepsal StKapacitu}
    If IOResult<>0 then RError:=False;
    If Files=Kapacita then
    begin
      Close(F); Close(F1); AddFromFile:=0;
      WriteLn('Error: #There is no space in archive !'); Exit;
    end;
    Inc(Files); {Zvetseni poctu souboru o jednu}
    Seek(F,0); {Nastaveni na indikator poctu souboru = zacatek archivu}
    BlockWrite(F,Files,2); {Zapsani poctu souboru v archivu}
    If IOResult<>0 then RError:=False;
    PostTable:=FileSize(F);
    SizeTable:=SuppSize;
    SaveHead(Files);
    Seek(F,PostTable); {Nastaveni na konec souboru = pozice noveho souboru}
  end;
  {Zkopirovani externiho souboru do archivu}
  GetMem(Buffer,5000); {Bere si 5 kilo, to snad neni tak moc ......}
  Repeat
    BlockRead(F1,Buffer^,5000,NRead); {Nacteni z externiho souboru}
    If IOResult<>0 then RError:=False;
    BlockWrite(F,Buffer^,NRead); {Dodani do archivu}
    If IOResult<>0 then RError:=False;
  Until Eof(F1)or(NRead=0); {Podminky konce cteni}
  FreeMem(Buffer,5000);
  Close(F1); {Uzavreni externiho souboru}
  Close(F); {Uzavreni archivu}
  If Not RError then AddFromFile:=0 else AddFromFile:=Files;
end;

{Jmeno archivu, pointer, ze ktereho se dodava, velikost pointeru << 65535}
Function AddFromMemory(Archiv : String; Supplement : Pointer; SuppSize : Word) : Word;
begin
  RError:=True;
  Assign(F,Archiv);
  If Not FileExist(Archiv) then {Pokud soubor neexistuje}
  begin
    Files:=1; {Nastaveni poctu souboru v archivu na jeden}
    Rewrite(F,1);
    If IOResult<>0 then RError:=False;
    BlockWrite(F,Files,2); {Zapsani poctu souboru do archivu}
    BlockWrite(F,StKapacita,2);
    If IOResult<>0 then RError:=False;
    BlockWrite(F,FileHead,2); {Zapsani napisu LIST}
    If IOResult<>0 then RError:=False;
    MakeHead;
    PostTable:=FilePos(F); {Zapsani pozice prvniho s. do tabulky}
    SizeTable:=SuppSize; {Zapsani delky prvniho s. do tabulky}
    SaveHead(Files);
    Seek(F,PostTable); {Zpetne nastaveni se na pozici prvniho souboru}
  end else
  begin
    Reset(F,1);
    BlockRead(F,Files,2); {Nacteni poctu souboru v archivu}
    BlockRead(F,Kapacita,2); {Podiva se kolik je maximalne mozno ulozit soub.}
    If IOResult<>0 then RError:=False;
    If Files=Kapacita then
    begin
      Close(F); Close(F1); AddFromMemory:=0;
      WriteLn('Error: #There is no space in archive !'); Exit;
    end;
    Inc(Files); {Zvetseni poctu souboru o jednu}
    Seek(F,0); {Nastaveni na indikator poctu souboru = zacatek archivu}
    BlockWrite(F,Files,2); {Zapsani poctu souboru v archivu}
    If IOResult<>0 then RError:=False;
    PostTable:=FileSize(F);
    SizeTable:=SuppSize;
    SaveHead(Files);
    Seek(F,PostTable); {Nastaveni na konec souboru = pozice noveho souboru}
  end;
  {Zkopirovani obsahu pameti do archivu}
  BlockWrite(F,Supplement^,SuppSize); {Dodani do archivu}
  If IOResult<>0 then RError:=False;
  Close(F); {Uzavreni archivu}
  AddFromMemory:=Files; {Rukojet pridaneho souboru}
  If Not RError then AddFromMemory:=0;
end;

{Nazev archivu, pointer, cislo souboru (1-255)}
Function LoadItem(Archiv : String; Var Destination : Pointer; Which : Word) : Word;
begin
  RError:=True;
  Assign(F,Archiv);
  Reset(F,1);
  If IOResult<>0 then RError:=False;
  LoadHead(Which);
  Seek(F,PostTable); {Nastavi se na pozici souboru v archivu}
  GetMem(Destination,SizeTable);
  BlockRead(F,Destination^,SizeTable); {Precte obsah souboru z archivu}
  If IOResult<>0 then RError:=False;
  Close(F); {Uzavre archiv}
  If Not RError then LoadItem:=0 else LoadItem:=SizeTable;
end;

{Vysledkem je delka souboru Which v archivu pri neuspechu 0}
Function ItemSize(Archiv : String; Which : Word) : Word;
begin
  RError:=True;
  Assign(F,Archiv);
  Reset(F,1);
  If IOResult<>0 then RError:=False;
  LoadHead(Which);
  Close(F);
  If Not RError then ItemSize:=0 else ItemSize:=SizeTable;
end;



{************* ARCHIVACE S KOMPRESI *************}



{Zkomprimuje externi soubor Supplement do archivu, vysledek cislo souboru}
Function CAddFromFile(Archiv : String; Supplement : String) : Word;
Var Dest:Pointer;
begin
  RError:=True;
  Assign(F,Archiv); {Soubory}
  Assign(F1,Supplement);
  Reset(F1,1);
  If IOResult<>0 then begin CAddFromFile:=0; Exit; end;
  If IOResult<>0 then RError:=False;
  CtrlSize:=FileSize(F1);
  If CtrlSize>65535 then begin Close(F1); WriteLn('Error: #File is too long for archive !'); Exit; end;
  SuppSize:=CtrlSize; {Zjisti jeho delku}
  {}
  GetMem(Buffer,SuppSize); {Zabere zdrojovou operacni pamet}
  GetMem(Dest,SuppSize+500);   {Zabere cilovou operacni pamet}
  BlockRead(F1,Buffer^,SuppSize); {Nacte do zdrojove}
  If IOResult<>0 then RError:=False;
  Compress(Buffer,Dest,SuppSize); {Zkomprimuje}
  CSize:=CompSize(Dest); {Zjisti delku komprimatu}
  {}
  If Not FileExist(Archiv) then {Pokud soubor neexistuje}
  begin
    Files:=1; {Nastaveni poctu souboru v archivu na jeden}
    Rewrite(F,1);
    BlockWrite(F,Files,2); {Zapsani poctu souboru do archivu}
    BlockWrite(F,StKapacita,2); {Zapise max pocet souboru}
    If IOResult<>0 then RError:=False;
    BlockWrite(F,FileHead,2); {Zapsani napisu LIST:}
    If IOResult<>0 then RError:=False;
    MakeHead; {Zapise tabulky, pak lze zjistit pozici prvniho souboru}
    PostTable:=FilePos(F); {Zapsani pozice prvniho s. do tabulky}
    SizeTable:=CSize; {Zapsani delky prvniho komp. s. do tabulky}
    SaveHead(Files); {Zapise tabulky}
    Seek(F,PostTable); {Zpetne nastaveni se na pozici prvniho souboru}
  end else
  begin
    Reset(F,1);
    BlockRead(F,Files,2); {Nacteni poctu souboru v archivu}
    BlockRead(F,Kapacita,2); {Nacteni maximalni kapacity}
    If IOResult<>0 then RError:=False;
    If Files=Kapacita then
    begin
      Close(F); Close(F1); CAddFromFile:=0;
      WriteLn('Error: #There is no space in archive !'); Exit;
    end;
    Inc(Files); {Zvetseni poctu souboru o jednu}
    Seek(F,0); {Nastaveni na indikator poctu souboru = zacatek archivu}
    BlockWrite(F,Files,2); {Zapsani poctu souboru v archivu}
    If IOResult<>0 then RError:=False;
    PostTable:=FileSize(F); {Delka F=pozice na konci souboru}
    SizeTable:=CSize; {Zapise delku komprimatu do tabulky}
    SaveHead(Files); {Ulozi tabulku}
    Seek(F,PostTable); {Nastaveni na konec souboru = pozice noveho souboru}
  end;
  {Zkopirovani externiho souboru do archivu}
  BlockWrite(F,SuppSize,2); {Zapise delku rozpakovaneho}
  If IOResult<>0 then RError:=False;
  BlockWrite(F,Dest^,CSize); {Zapise komprimat}
  If IOResult<>0 then RError:=False;
  Close(F); {Uzavreni archivu}
  FreeMem(Buffer,SuppSize); {Uvolni pamet}
  FreeMem(Dest,SuppSize+500);
  If Not RError then CAddFromFile:=0 else CAddFromFile:=Files;
end;

{Doda do archivu z pameti a komprimuje}
Function CAddFromMemory(Archiv : String; Supplement : Pointer; SuppSize : Word) : Word;
Var Dest:Pointer;
begin
  RError:=True;
  Assign(F,Archiv); {Soubory}
  {}
  GetMem(Dest,SuppSize+ 200);   {Zabere cilovou operacni pamet}
{pridano navic 200 byte}
  Compress(Supplement,Dest,SuppSize); {Zkomprimuje}
  CSize:=CompSize(Dest); {Zjisti delku komprimatu}
  {}
  If Not FileExist(Archiv) then {Pokud soubor neexistuje}
  begin
    Files:=1; {Nastaveni poctu souboru v archivu na jeden}
    Rewrite(F,1);
    BlockWrite(F,Files,2);
    {Zapsani poctu souboru,ktere archiv aktualne obsahuje}
    BlockWrite(F,StKapacita,2);
    {Zapsani max. kapacity, tj. vlastne velikosti vytvorene tabulky}
    If IOResult<>0 then RError:=False;
    BlockWrite(F,FileHead,2); {Zapsani napisu BS}
    If IOResult<>0 then RError:=False;
    MakeHead;
    {Vytvori zatim prazdnou tabulku pro pocet souboru StKapacita}
    PostTable:=FilePos(F);
    {Zapamatuju si pozici, kam prijde "telo" itemu s jeho daty}
    SizeTable:=CSize;
    {SizeTAble je delka komprimovanych dat (delka itemu v archivu)}
    SaveHead(Files);
    {Zapise do tabulky delku kompr. itemu a jeho pozici od zacatku archivu}
    Seek(F,PostTable);
    {Nastavim se na pozici, kam prijdou data}
  end else
  begin
    Reset(F,1);
    BlockRead(F,Files,2); {Nacteni poctu souboru v archivu}
    BlockRead(F,Kapacita,2);
    If IOResult<>0 then RError:=False;
    If Files=Kapacita then
    begin
      Close(F); Close(F1); CAddFromMemory:=0;
      WriteLn('Error: #There is no space in archive !'); Exit;
    end;
    Inc(Files); {Zvetseni poctu souboru o jednu}
    Seek(F,0); {Nastaveni na indikator poctu souboru = zacatek archivu}
    BlockWrite(F,Files,2);
    {Aktualizuji pocet souboru v archivu, zapisuji novou hodnotu}
    If IOResult<>0 then RError:=False;
    PostTable:=FileSize(F);
    {v PostTable je pozice dat; prijdou na konec archivu, takze vezmu rovnou}
    {jeho delku}
    SizeTable:=CSize;
    {SizeTable je delka komprimovanych dat (delka itemu v archivu)}
    SaveHead(Files);
    {Zapise do tabulky delku kompr. itemu a jeho pozici od zacatku archivu}
    Seek(F,PostTable);
    {Nastavim se na pozici, kam prijdou data}
  end;

{ Tady zacina ukladani "tela" komprimatu }

  BlockWrite(F,SuppSize,2);
  {2 byte : delka rozpakovaneho}
  If IOResult<>0 then RError:=False;
  BlockWrite(F,Dest^,CSize);
  {Zapise komprimat}
  If IOResult<>0 then RError:=False;
  Close(F); {Uzavreni archivu}
  FreeMem(Dest,SuppSize+ 200); {Uvolni pamet}
{pridano 200 byte, ktere se taky uvolnuji}
  If Not RError then CAddFromMemory:=0 else CAddFromMemory:=Files;
end;

{Dekomprimuje soubor Which z archivu do pointeru Destination}
Function CLoadItem(Archiv :  String; Var Destination : Pointer; Which : Word) : Word;
Var UnCSize : Word; {Budouci delka dekomprim. souboru << 65536}
label chyba;
begin
  RError:=True;
  Assign(F,Archiv);
  Reset(F,1);
  If IOResult<>0 then begin RError:=False; goto chyba end;
  LoadHead(Which);
  Seek(F,PostTable); {Nastavi se na pozici souboru v archivu}
  BlockRead(F,UnCSize,2); {Nacte delku rozpakovaneho souboru, kvuli pameti}
  GetMem(Destination,UnCSize); {Rezervace pameti pro rozpakovany soubor}
  GetMem(Buffer,SizeTable+200); {Rezervace pameti pro komprimat}
  BlockRead(F,Buffer^,SizeTable); {Precte komprimat z archivu}
  DeCompress(Buffer,Destination);
  If IOResult<>0 then RError:=False;
  Close(F); {Uzavre archiv}
  FreeMem(Buffer,SizeTable+200);
chyba:
  If Not RError then CLoadItem:=0 else CLoadItem:=UnCSize;
end;

{Dekomprimuje soubor Which z archivu do pointeru Destination}
{Predpoklada, ze na Dest je uz predem vyhrazene misto}
Function CReadItem(Archiv :  String; Destination : Pointer; Which : Word) : Word;
Var UnCSize : Word; {Budouci delka dekomprim. souboru << 65536}
begin
  RError:=True;
  Assign(F,Archiv);
  Reset(F,1);
  If IOResult<>0 then RError:=False;
  LoadHead(Which);
  Seek(F,PostTable); {Nastavi se na pozici souboru v archivu}
  BlockRead(F,UnCSize,2); {Nacte delku rozpakovaneho souboru, kvuli pameti}
(*  GetMem(Destination,UnCSize); {Rezervace pameti pro rozpakovany soubor}*)
  GetMem(Buffer,SizeTable+200); {Rezervace pameti pro komprimat}
  BlockRead(F,Buffer^,SizeTable); {Precte komprimat z archivu}
  DeCompress(Buffer,Destination);
  If IOResult<>0 then RError:=False;
  Close(F); {Uzavre archiv}
  If Not RError then CReadItem:=0 else CReadItem:=UnCSize;
  FreeMem(Buffer,SizeTable+200);
end;

{Pri uspechu je vysledkem delka ROZBALENEHO souboru v komprimovanem archivu}
Function UnpackedItemSize(Archiv : String; Which : Word) : Word;
begin
  RError:=True;
  Assign(F,Archiv);
  Reset(F,1);
  If IOResult<>0 then RError:=False;
  LoadHead(Which);
  Seek(F,PostTable);
  BlockRead(F,Size,2);
  If IOResult<>0 then RError:=False;
  Close(F);
  If Not RError then UnpackedItemSize:=0 else UnpackedItemSize:=Size;
end;

Function PackedItemSize(Archiv : String; Which : Word) : Word; {Delka komprimovaneho souboru}
begin
  RError:=True;
  Assign(F,Archiv);
  Reset(F,1);
  If IOResult<>0 then RError:=False;
  LoadHead(Which);
  Close(F);
  If Not RError then PackedItemSize:=0 else PackedItemSize:=SizeTable;
end;

{Vrati, kolik je jeste v archivu volnych pozic, coz je vhodne napriklad pro
rozhodnuti, jestli ma program zalozit archiv novy}
Function GetArchiveAvail(Archiv : String) : Word;
Var Avl : Byte;
begin
  RError:=True;
  Assign(F,Archiv);
  Reset(F,1);
  If IOResult<>0 then RError:=False;
  BlockRead(F,Avl,2);
  BlockRead(F,Kapacita,2);
  If IOResult<>0 then RError:=False;
  Close(F);
  If Not RError then GetArchiveAvail:=0 else GetArchiveAvail:=Kapacita-Avl;
end;

Function GetArchiveOccupy(Archiv : String) : Word; {Vysledkem je pocet obsazenych pozic}
label navesti;
Var Avl : Byte;
begin
  RError:=True;
  Assign(F,Archiv);
  Reset(F,1);
  If IOResult<>0 then begin RError:=False; goto navesti; end;
  BlockRead(F,Avl,2);
  If IOResult<>0 then RError:=False;
  Close(F);
navesti:
  If Not RError then GetArchiveOccupy:=0 else GetArchiveOccupy:=Avl;
end;

{Pouziva se pred zalozenim archivu, nastavi kapacitu budouciho archivu,
maximalne 65535. Standartne nastaveno na 255.}
Function SetArchiveCapacity(Cpct : Word) : Boolean;
begin
  If Cpct>65535 then SetArchiveCapacity:=False else
  begin StKapacita:=Cpct; SetArchiveCapacity:=True; end;
end;

{PROCEDURY PRO PRACI S CRC SOUBORU}

Function SetArchiveCRC(Archiv : String) : Boolean;
Var FLength,RDB:LongInt; {Delka archivu v originale}
begin
  RError:=True; {Nastavi IO chybu na dobry vysledek}
  SetArchiveCRC:=True; {Nastavi vysledek funkce na dobry}
  CRC:=0; {Vynuluje CRC}
  FLength:=0; {Vynuluje delku}
  Assign(F,Archiv); {Otevre archiv}
  Reset(F,1);
  If IOResult<>0 then RError:=False;
  FLength:=FileSize(F)+24; {Zjisti delku archivu a pricte k nemu delku ochranneho kodu}
  GetMem(Buffer,10000);
  Repeat
    BlockRead(F,Buffer^,10000,NRead);
    If IOResult<>0 then RError:=False;
    Dec(NRead);   {!!!! KVULI POLI, KTERE JE OD NULY !!!!}
    For Ld:=0 to NRead do
    begin
      Inc(CRC,Buffer^[Ld]); {Pricte hodnotu bajtu k CRC}
    end;
  Until (Eof(F))or(NRead=0); {Podminky konce cteni}
  FreeMem(Buffer,10000);
  Randomize; {Inicializuje generator nahodnych cisel}
  RDB:=Random(65535)*Random(32700); {Zapise 8 bytes nahodnych cisel}
  BlockWrite(F,RDB,4);
  If IOResult<>0 then RError:=False;
  RDB:=Random(65535)*Random(32700);
  BlockWrite(F,RDB,4);
  If IOResult<>0 then RError:=False;
  BlockWrite(F,Flength,4); {Zapise delku archivu}
  If IOResult<>0 then RError:=False;
  BlockWrite(F,CRC,4);     {Zapise hodnotu CRC}
  If IOResult<>0 then RError:=False;
  RDB:=Random(65535)*Random(32700); {Zapise 8 bytes nahodnych cisel}
  BlockWrite(F,RDB,4);
  If IOResult<>0 then RError:=False;
  RDB:=Random(65535)*Random(32700);
  BlockWrite(F,RDB,4);
  If IOResult<>0 then RError:=False;
  Close(F); {Uzavre soubor}
  If Not RError then SetArchiveCRC:=False;
end;

Function TestArchiveCRC(Archiv : String) : Boolean;
Var RLength,FLength,RDB,RCRC:LongInt; {Delka archivu v originale}
begin
  RError:=True;
  TestArchiveCRC:=True;
  CRC:=0;
  FLength:=0;
  Assign(F,Archiv);
  Reset(F,1);
  If IOResult<>0 then RError:=False;
  FLength:=FileSize(F); {Zjisti delku archivu}
  GetMem(Buffer,10000);
  Repeat
    BlockRead(F,Buffer^,10000,NRead);
    If IOResult<>0 then RError:=False;
    Dec(NRead);
    For Ld:=0 to NRead do {Pricita hodnoty bytes k CRC kodu}
    begin
      Inc(CRC,Buffer^[Ld]);
    end;
  Until (Eof(F))or(NRead=0);
  Seek(F,FLength-16);
  If IOResult<>0 then RError:=False;
  BlockRead(F,RLength,4); {Nacte delku archivu}
  If IOResult<>0 then RError:=False;
  BlockRead(F,RCRC,4);     {Nacte hodnotu CRC}
  If IOResult<>0 then RError:=False;
  Close(F); {Uzavre soubor}
  {Odecteni ochranneho kodu od CRC}
  For Ld:=NRead-23 to NRead do
  begin
    Dec(CRC,Buffer^[Ld]);
  end;
  FreeMem(Buffer,10000);
  If (CRC<>RCRC)or(RLength<>FLength) then TestArchiveCRC:=False;
  If Not RError then TestArchiveCRC:=False;
end;

{OSTATNI}

Function ExtractItem(ArchivF, OutFile : String; WhichI : Word) : Boolean;
begin
  RErrors:=True;
  CSize:=LoadItem(ArchivF,ExDest,WhichI);       {Nacteni z archivu}
  Assign(F1,OutFile);
  Rewrite(F1,1);
  If IOResult<>0 then RErrors:=False;
  BlockWrite(F1,ExDest^,CSize);
  If IOResult<>0 then RErrors:=False;
  Close(F1);
  FreeMem(ExDest,CSize);
  If Not RErrors then ExtractItem:=False else ExtractItem:=True;
end;

Function CExtractItem(ArchivF, OutFile : String; WhichI : Word) : Boolean;
begin
  RErrors:=True;
  CSize:=CLoadItem(ArchivF,ExDest,WhichI);       {Nacteni z archivu}
  Assign(F1,OutFile);
  Rewrite(F1,1);
  If IOResult<>0 then RErrors:=False;
  BlockWrite(F1,ExDest^,CSize);
  If IOResult<>0 then RErrors:=False;
  Close(F1);
  FreeMem(ExDest,CSize);
  If Not RErrors then CExtractItem:=False else CExtractItem:=True;
end;

Function EraseItem(Archiv : String; Which : Word) : Boolean;
begin
  RError:=True;
  Assign(F,Archiv);
  Reset(F,1);
  If IOResult<>0 then RError:=False;
  BlockRead(F,Files,2);
  If IOResult<>0 then RError:=False;
  LoadHead(Which);   {Precte pozici Itemu v archivu.....}
  {Tady je mazani posledniho itemu v souboru}
  If Files=Which then Seek(F,PostTable) else
  begin {Tady je mazani Itemu, ktery ma za sebou jeste dalsi Item(y)}
    NewPosition:=PostTable; {Pozice smazaneho itemu}
    For Ld:=Which+1 to Files do {kopirovani souboru}
    begin
      LoadHead(Ld);
      GetMem(Buffer,SizeTable);
      Seek(F,PostTable);
      BlockRead(F,Buffer^,SizeTable);
      If IOResult<>0 then RError:=False;
      Seek(F,NewPosition);
      BlockWrite(F,Buffer^,SizeTable);
      If IOResult<>0 then RError:=False;
      FreeMem(Buffer,SizeTable);
      PostTable:=NewPosition;
      NewPosition:=PostTable+SizeTable;
      SaveHead(Ld-1);
    end;
    Seek(F,NewPosition);
  end;
  Truncate(F);
  Seek(F,0);
  Dec(Files);
  BlockWrite(F,Files,2);
  If IOResult<>0 then RError:=False;
  Close(F);
  If Not RError then EraseItem:=False else EraseItem:=True;
end;

Function CEraseItem(Archiv : String; Which : Word) : Boolean;
begin
  RError:=True;
  Assign(F,Archiv);
  Reset(F,1);
  If IOResult<>0 then RError:=False;
  BlockRead(F,Files,2);
  {Je nastaveny na zacatek archivu, precte pocet obsazenych mist v archivu}
  If IOResult<>0 then RError:=False;
  LoadHead(Which);
  {Nacte si z tabulky delku itemua jeho pozici od zacatku archivu.....}

  {Tady je mazani posledniho itemu v souboru}
  If Files=Which then Seek(F,PostTable) else
  begin {Tady je mazani Itemu, ktery ma za sebou jeste dalsi Item(y)}
    NewPosition:=PostTable; {Pozice smazaneho itemu}
    For Ld:=Which+1 to Files do {kopirovani souboru}
    begin
      LoadHead(Ld);
      GetMem(Buffer,SizeTable);
      Seek(F,PostTable);
      BlockRead(F,Rept,2);
      BlockRead(F,Buffer^,SizeTable);
      If IOResult<>0 then RError:=False;
      Seek(F,NewPosition);
      BlockWrite(F,Rept,2);
      BlockWrite(F,Buffer^,SizeTable);
      If IOResult<>0 then RError:=False;
      FreeMem(Buffer,SizeTable);
      PostTable:=NewPosition;
      NewPosition:=PostTable+SizeTable+2;
{Hola hola, zapomnel jsi "prodlouzit" item o 2 byty, ktere}
{obsahuji jeho rozpakovanou delku!}
      SaveHead(Ld-1);
    end;
    Seek(F,NewPosition);
  end;
  Truncate(F);
{  BlockWrite(F,SizeTable,2);}
{ a toto BlockWrite taky nevim, nac tady bylo. Teda vlastne vim, na hovno}
{ a na nasrani, kdyz se to pak kuli tomu sralo! Ale jaktoze to nevedel}
{ autor tohoto radoby programu?!?}
  Seek(F,0);
  Dec(Files);
  BlockWrite(F,Files,2);
  If IOResult<>0 then RError:=False;
  Close(F);
  If Not RError then CEraseItem:=False else CEraseItem:=True;
end;

{Rozsiruje kapacitu nekomprimovaneho archivu}
Function ExpandArchive(Archiv : String; KMuch : Word) : Boolean;
Var Souboru:Word;
begin
  RError:=True;
  Assign(F,Archiv);
  Reset(F,1);
  If IOResult<>0 then RError:=False;
  BlockRead(F,Files,2);                 {Nacte pocet souboru}
  BlockRead(F,Kapacita,2);              {Nacte aktualni kapacitu}
  If IOResult<>0 then RError:=False;
  Souboru:=Files;                       {Uschova pocet pro vlast. potrebu}
  If KMuch+Kapacita>65535 then          {Ukonceni}
  begin Close(F); Exit; ExpandArchive:=True; end;
  Repeat
    LoadHead(Souboru);                  {Nacte hlavicku}
    NewPosition:=PostTable+(KMuch*6);   {Spocita novou pozici pro Item}
    Seek(F,PostTable);                  {Nastavi se na puvodni pozici}
    GetMem(Buffer,SizeTable);           {Alokuje potrebnou pamet}
    BlockRead(F,Buffer^,SizeTable);     {Nacte data}
    If IOResult<>0 then RError:=False;
    Seek(F,NewPosition);                {Nastavi se na novou pozici}
    BlockWrite(F,Buffer^,SizeTable);    {Ulozi data}
    If IOResult<>0 then RError:=False;
    FreeMem(Buffer,SizeTable);          {Disalokuje pamet}
    PostTable:=NewPosition;             {Aktualizuje...}
    SaveHead(Souboru);                  {...pozicni tabulku}
    Dec(Souboru);                       {Snizi pocitadlo ke konci}
  Until Souboru=0;
  Inc(Kapacita,KMuch);                  {Zvysi informaci o kapacite}
  Seek(F,2);
  BlockWrite(F,Kapacita,2);             {A ulozi ji do archivu}
  If IOResult<>0 then RError:=False;
  Seek(F,(Files+1)*6);                  {Prvni pozice za posledni}
  For Ld:=1 to KMuch do                 {Vytvori mistecko}
  begin
    BlockWrite(F,FileHead,2);
    BlockWrite(F,NewPosition,4);
  end;
  If IOResult<>0 then RError:=False;
  Close(F);                             {Zavre soubor}
  If Not RError then ExpandArchive:=False else ExpandArchive:=True;
end;

{Rozsiruje kapacitu komprimovaneho archivu}
Function CExpandArchive(Archiv : String; KMuch : Word) : Boolean;
Var Souboru:Word;
begin
  Assign(F,Archiv);
  Reset(F,1);
  If IOResult<>0 then RError:=False;
  BlockRead(F,Files,2);                 {Nacte pocet souboru}
  BlockRead(F,Kapacita,2);              {Aktualni kapacita archivu}
  If IOResult<>0 then RError:=False;
  Souboru:=Files;                       {Zalohuje si pocet souboru}
  If KMuch+Kapacita>65535 then
  begin Close(F); Exit; CExpandArchive:=True; end; {KONEC}
  Repeat
    LoadHead(Souboru);                  {Natahne hlavicku}
    NewPosition:=PostTable+(KMuch*6);   {Spocita novou pozici}
    Seek(F,PostTable);                  {Postavi se na starou}
    GetMem(Buffer,SizeTable);           {Alokace pameti}
    BlockRead(F,Ld,2);                  {Nacte delku dekomprim. Itemu}
    BlockRead(F,Buffer^,SizeTable);     {Nacitani dat}
    If IOResult<>0 then RError:=False;
    Seek(F,NewPosition);                {Postavi se na novou pozici}
    BlockWrite(F,Ld,2);                 {Zapise delku}
    BlockWrite(F,Buffer^,SizeTable);    {Zapise data}
    If IOResult<>0 then RError:=False;
    FreeMem(Buffer,SizeTable);          {Disalokuje pamet}
    PostTable:=NewPosition;             {Aktualizuje pozicni tabulku}
    SaveHead(Souboru);                  {Ulozi hlavicku nahoru do archivu}
    Dec(Souboru);                       {Snizi pocitadlo souboru}
  Until Souboru=0;
  Inc(Kapacita,KMuch);                  {Zvysi kapacitu archivu}
  Seek(F,2);
  BlockWrite(F,Kapacita,2);             {Ulozi o tom informace}
  Seek(F,(Files+1)*6);                  {Vytvori dodatecny....}
  For Ld:=1 to KMuch do
  begin
    BlockWrite(F,FileHead,2);           {...pocet mist v tabulce}
    BlockWrite(F,NewPosition,4);
  end;
  If IOResult<>0 then RError:=False;
  Close(F);                             {Uzavre soubor}
  If Not RError then CExpandArchive:=False else CExpandArchive:=True;
end;

begin
  StKapacita:=255;              {Nastaveni standartni kapacity}
end.



{Poznamky:}
{Zrusyl jsem chibi, ktere nasel Pavel. To znamena vistupi nekterich funkcy.
Vznyklo to tym, jak jsem unyt pomocy replace predelaval z TRUE NA FALSE a
naopak. Pred visledki techto funkcy se tym padem nezaradylo Not a chibycka
bila na sfjete. Takze uz bi to mnelo chodyt v poradku.}