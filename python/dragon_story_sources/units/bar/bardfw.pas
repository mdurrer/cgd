{A library emulating the old DFW interface, however using BAR as the back-end.

The main difference between the two *interfaces* of these two libraries is
that BAR first opens an archive and then all functions expect the index of an
opened archive, whereas DFW just expects a string path to the archive at each
call.  To avoid re-opening the files all the time, I cache a list of opened
BAR archives, and then close them later.  The game player still uses the old
interface (that's why this library exists), but it actually only uses the new
BAR archiver.  When reimplementing the game, it's best to avoid this emulation
layer and call BAR directly.

This library is also capable of calling the original DFW library (passing the
calls through), but this possibility is never used.  It's best to completely
remove linking these two codes together.}
unit bardfw;
interface
uses bar_tog;

const max_num_emulations=(max_num_open_archives-1)div 3+1;

type t_1_emulated_folder=record
       path:string;
       number_:byte;
       {0=puvodni dfw}
     end;
     t_emulated_folders=record
       number:byte;
       s:array[1..max_num_emulations]of t_1_emulated_folder;
     end;

function CCloseArchive(Archiv:string):word; {moje, přidáno pro efektivitu}
Function CAddFromFile(Archiv : String; Supplement : String) : Word;
Function CAddFromMemory(Archiv : String; Supplement : Pointer; SuppSize : Word) : Word;
Function CLoadItem(Archiv : String; Var Destination : Pointer; Which : Word) : Word; {Nahraje file_path do pameti}
Function CReadItem(Archiv :  String; Destination : Pointer; Which : Word) : Word;
Function UnpackedItemSize(Archiv : String; Which : Word) : Word; {Zjisti delku souboru}
Function GetArchiveAvail(Archiv : String) : Word; {Vysledkem je number volnych pozic}
Function GetArchiveOccupy(Archiv : String) : Word; {Vysledkem je number obsazenych pozic}

implementation
uses barchiv,dfw,dos;

var emul:t_emulated_folders;

function return_bar_number(path:string;how:byte):byte;
{prohledá emulační záznamy, jestli to není už otevřeno
 255=nastala on_error pri otevreni
 0=volat puvodni dfw
 jinak number_ BARu}
var i:byte;
    j:word;
begin
  return_bar_number:=255; {on_error};
  path:=fexpand(path);
  for i:=1 to emul.number do
    if emul.s[i].path=path then begin
    {už tam existuje}
      if emul.s[i].number_=0 then begin {puvodni dfw}
        return_bar_number:=0;
        exit;
      end;
      j:=bar_open(emul.s[i].path,how);
      if j=emul.s[i].number_ then
      {reotevřeme ho, pokud je to pod stejným módem, nic se nestane}
        return_bar_number:=emul.s[i].number_ {o.k.}
      else if j=65535 then
        {return_bar_number:=0} {nepovedlo se}
      else begin {nic jiného to vrátit nemůže!}
        writeln('interní on_error emulátoru dfw');
        halt(100);
      end;
      exit;
      {vrátíme obvyklé číslo}
    end;
  {jinak dosud v emulačním seznamu není}
  while emul.number>=max_num_emulations do begin {aby se nám to vešlo do pole}
    if emul.s[1].number_<>0 then {neni to dfw}
      if bar_close(emul.s[1].number_)=65535 then {on_error}
        exit;
    dec(emul.number); {uzavřeme nejstarší složku}
    for i:=1 to emul.number do
      emul.s[i]:=emul.s[i+1];
  end;

  j:=bar_open(path,how); {přiotevřeme}
  if j<>65535 then begin {bez chyby}
    inc(emul.number);
    emul.s[emul.number].path:=path;
    emul.s[emul.number].number_:=j;
    return_bar_number:=j;
    exit;
  end else begin {nepodařilo se otevřít}
    inc(emul.number);
    emul.s[emul.number].path:=path;
    emul.s[emul.number].number_:=0;
    return_bar_number:=0; {nechame to na bedrech dfw}
    exit;
  end;
{můžeme taky pořád jenom otvírat a zavírat soubory, ale já to chci udělat
 takhle šikovněji!}
end;

function CCloseArchive(Archiv:string):word;
var i,j:byte;
begin
  CCloseArchive:=0; {on_error}
  archiv:=fexpand(archiv);
  for i:=1 to emul.number do
    if (emul.s[i].path=archiv)and(emul.s[i].number_<>0) then begin
      if bar_close(emul.s[i].number_)=65535 then {zkusíme zavřít}
        exit;
      dec(emul.number); {odstraníme ze seznamů}
      for j:=i to emul.number do
        emul.s[j]:=emul.s[j+1];
      cclosearchive:=1;
      exit;
    end;
end;

Function CAddFromFile(Archiv : String; Supplement : String) : Word;
var bar_number:byte;
    x:word;
begin
  caddfromfile:=0;
  bar_number:=return_bar_number(archiv,2); {připsání}
  if bar_number=255 then exit;
  if bar_number=0 then
    x:=dfw.caddfromfile(archiv,supplement)
  else begin
    x:=bar_write_file(bar_number,supplement);
    if x=65535 then exit;
  end;
  caddfromfile:=x;
end;

Function CAddFromMemory(Archiv : String; Supplement : Pointer; SuppSize : Word) : Word;
var bar_number:byte;
    x:word;
begin
  caddfrommemory:=0;
  bar_number:=return_bar_number(archiv,2); {připsání}
  if bar_number=255 then exit;
  if bar_number=0 then
    x:=dfw.caddfrommemory(archiv,supplement,suppsize)
  else begin
    x:=bar_write(bar_number,supplement,suppsize);
    if x=65535 then exit;
  end;
  caddfrommemory:=x;
end;

Function CLoadItem(Archiv : String; Var Destination : Pointer; Which : Word) : Word; {Nahraje file_path do pameti}
var bar_number:byte;
    x:word;
begin
  cloaditem:=0;
  bar_number:=return_bar_number(archiv,1); {čtení}
  if bar_number=255 then exit;
  if bar_number=0 then
    x:=dfw.cloaditem(archiv,destination,which)
  else begin
    x:=bar_alloc_and_read(bar_number,which,destination);
    if x=65535 then exit;
  end;
  cloaditem:=x;
end;

Function CReadItem(Archiv :  String; Destination : Pointer; Which : Word) : Word;
var bar_number:byte;
    x:word;
begin
  creaditem:=0;
  bar_number:=return_bar_number(archiv,1); {čtení}
  if bar_number=255 then exit;
  if bar_number=0 then
    x:=dfw.creaditem(archiv,destination,which)
  else begin
    x:=bar_read(bar_number,which,destination);
    if x=65535 then exit;
  end;
  creaditem:=x;
end;

Function UnpackedItemSize(Archiv : String; Which : Word) : Word; {Zjisti delku souboru}
var bar_number:byte;
    x:word;
begin
  unpackeditemsize:=0;
  bar_number:=return_bar_number(archiv,1); {čtení}
  if bar_number=255 then exit;
  if bar_number=0 then
    x:=dfw.unpackeditemsize(archiv,which)
  else begin
    x:=bar_folder_length(bar_number,which);
    if x=65535 then exit;
  end;
  unpackeditemsize:=x;
end;

Function GetArchiveAvail(Archiv : String) : Word; {Vysledkem je number volnych pozic}
var bar_number:byte;
begin
  getarchiveavail:=0;
  bar_number:=return_bar_number(archiv,1);
  if bar_number=255 then exit;
  if bar_number=0 then
    getarchiveavail:=dfw.getarchiveavail(archiv)
  else
    getarchiveavail:=max_folders_in_archive;
end;

Function GetArchiveOccupy(Archiv : String) : Word; {Vysledkem je number obsazenych pozic}
var bar_number:byte;
    x:word;
begin
  getarchiveoccupy:=0;
  bar_number:=return_bar_number(archiv,1); {čtení}
  if bar_number=255 then exit;
  if bar_number=0 then
    x:=dfw.getarchiveoccupy(archiv)
  else begin
    x:=bar_num_folders(bar_number);
    if x=65535 then exit;
  end;
  getarchiveoccupy:=x;
end;

begin
  emul.number:=0;
  compression_type:=0; {nekompimuje}
end.
