{ Bob's ARchiver V0.01

  format:
    <header>
    <file1>, <file2>, ...
    <footer>
  <header> is: 4B signature "BAR!"
               2B number of folders (= files)
               4B total length of all folders (i.e. position of the footer)
  <fileX> is: 2B compressed length
              2B original length
              1B compression type
              1B CRC
  <footer> is: an array of 4B indices of the individual folders
  <compression type> is: 0 none, 1 lzw, 2 huf, 3 lzw+huf
  <CRC> is: the XOR of all bytes of the original file

  Opening an archive:
  (a) for writing: if it exists, the footer is truncated, otherwise an empty
  header is created
  (b) for reading: the index of the footer is read
  After an archive is opened, it is registered in the internal list of opened
  archives, and its index is returned to the caller.

  Closing an archive:
  (a) for writing: add a new footer and update the header to point at it
  (b) for reading: nothing
  Then the archive is removed from the internal list.

  The caller can read any folder from an archive opened for reading and BAR
  automatically chooses the right decompression type.  If an archive is opened
  for writing, you can add a new folder at the end.  If you want to update an
  existing archive, open it for reading and another one for writing, and copy
  the folders one by one.}

unit barchiv;

interface
uses bar_tog;

const compression_type:byte=1;

type type_1_open_archive=record
       how:byte; {0 zavřeno, 1 čtení, 2 zápis;
                  při otevření 3 zápis s výmazem předchozího archívu}
       file_:file;
       num_folders:integer;
       end_:longint; {čtení-position patičky, zápis-position konce}
       file_path:string; {path k archívu}
     end;
     type_open_archives=record
       number:byte;
       a:array[1..max_num_open_archives]of type_1_open_archive;
     end;

     type_signature=array[1..4]of char;
     type_bar_header=packed record
       signature:type_signature;
       num_folders:word;
       end_:longint;
     end;
     type_bar_sub_header=record
       length_,decompressed_length:word;
       compr,crc:byte;
     end;

const signature:type_signature='BAR!';

function bar_open(path:string; type_:byte):word; {65535=on_error}
function bar_close(number_:byte):word; {65535=on_error}
function bar_num_folders(number_:byte):word; {65535=on_error}
function bar_seek(ar:byte; folder:word):word; {65535=on_error}
function bar_folder_length(ar:byte; folder:word):word; {65535=on_error}
function bar_read(
  ar:byte; folder:word;
  where_to:pointer):word; {65535=on_error}
function bar_alloc_and_read(
  ar:byte; folder:word;
  var where_to:pointer):word; {65535=on_error}
function bar_write(
  ar:byte;
  from:pointer; decompressed_length:word):word; {65535=on_error}
function bar_write_and_dealloc(
  ar:byte;
  var from:pointer; decompressed_length:word):word; {65535=on_error}
function bar_read_file(
  ar:byte;
  folder:word;
  file_:string):word; {65535=on_error}
function bar_write_file(
  ar:byte;
  file_:string):word; {65535=on_error}

implementation
uses bar_lzw,bar_huf,
     dos;

var bar:type_open_archives;

function bar_open(path:string; type_:byte):word; {65535=on_error}
label on_error,on_error_close,to_delete;
var num:byte;
    header:type_bar_header;
    x:word;
begin
  bar_open:=65535;
  if (type_<1)or(type_>3) then
    exit;
  path:=fexpand(path);
  num:=1; {není archív už jednou otevřený?}
  while (num<=bar.number)and((bar.a[num].file_path<>path)or(bar.a[num].how=0)) do
    inc(num);
  if num<=bar.number then begin {je!}
{    exit;} {končit nebudeme, radši ho zavřeme a otevřeme znovu}
    if bar.a[num].how=type_ then begin {typy se shodují ---> ani to nezavřeme}
       bar_open:=num;
       exit;
    end;
    if bar_close(num)=65535 then {nelze to zavřít?}
      exit;
  end else begin {jinak najdeme první volnou pozici}
    num:=1;
    while (num<=bar.number)and(bar.a[num].how<>0) do
      inc(num);
  end;

  if num>bar.number then {je nutno i v 1. případě, když to bylo na konci...}
    if bar.number=max_num_open_archives
      then exit
      else inc(bar.number);

  with bar.a[num] do begin
    file_path:=path; {zaznamenej si cestu}

    if path='' then goto on_error; {nedovolí psát na konzolu...}
    assign(file_,path);
    if type_=3 then begin {otevření pro zápis s výmazem předchozího obsahu}
      type_:=2;
      goto to_delete;
    end;
    {$i-} reset(file_,1); {$i+}
    if ioresult<>0 then {nexistuje file_path?}
      if type_=1 then begin {čtení ---> on_error}
on_error:
        if num=bar.number then
          dec(bar.number);
        exit;
      end else begin {zápis ---> založení}
to_delete:
        header.signature:=signature;
        header.num_folders:=0;
        header.end_:=sizeof(type_bar_header);
        {$i-}
        rewrite(file_,1);
        {$i+}
        if ioresult<>0 then goto on_error;
        blockwrite(file_,header,sizeof(type_bar_header),x);
        if x<>sizeof(type_bar_header) then begin
on_error_close:
          close(file_);
          goto on_error;
        end;
      end
    else begin {O.K., načteme hlavičku}
      blockread(file_,header,sizeof(type_bar_header),x);
      if x<>sizeof(type_bar_header) then goto on_error_close;
    end;

    if header.signature<>signature then goto on_error_close;
    num_folders:=header.num_folders;
    end_:=header.end_;

    if type_=2 then begin {zápis? odsekni patičku!}
      {$i-}
      seek(file_,end_);
      if ioresult<>0 then goto on_error_close;
      truncate(file_);
      if ioresult<>0 then goto on_error_close;
      {$i+}
    end;

    how:=type_; {zapíšeme type_ otevření souboru}
  end;

  bar_open:=num;
end;

function bar_close(number_:byte):word; {65535=on_error}
label on_error;
var header:type_bar_header;
    len,x:word;
    start:plongintarray;
begin
  bar_close:=65535;
  if (number_>bar.number)or(bar.a[number_].how=0) then
    exit;
  with bar.a[number_] do begin
    if how=2 then begin {zápis? obnovit patičku!}
      header.signature:=signature;
      header.num_folders:=num_folders;
      header.end_:=end_;
      {$i-}
      seek(file_,0);
      if ioresult<>0 then goto on_error;
      blockwrite(file_,header,sizeof(type_bar_header),x);
      if x<>sizeof(type_bar_header) then goto on_error;
      {$i+}
      getmem(start,(num_folders+1)*sizeof(longint)); {zapiš patičku}
      start^[1]:=sizeof(type_bar_header);
      for x:=1 to num_folders do begin
{dodělat kontrolu chyb!}
        blockread(file_,len,sizeof(word));
        start^[x+1]:=start^[x]+len;
        seek(file_,start^[x+1]);
      end;
      blockwrite(file_,start^,(num_folders+1)*sizeof(longint));
      freemem(start,(num_folders+1)*sizeof(longint));
    end;
on_error:
    close(file_); {uzavřít file_path}
    bar.a[number_].how:=0; {odstranit ze seznamů v paměti}
    while (bar.number>0)and(bar.a[bar.number].how=0) do
      dec(bar.number);
  end;

  bar_close:=0;
end;

function bar_num_folders(number_:byte):word; {65535=on_error}
begin
  bar_num_folders:=65535;
  if (number_>bar.number)or(bar.a[number_].how=0) then
    exit;
  bar_num_folders:=bar.a[number_].num_folders;
end;

function bar_seek(ar:byte; folder:word):word; {65535=on_error}
{interní! netestuje správnost čisla archívu a otevření pro čtení}
var idx:longint;
    x:word;
begin
  bar_seek:=65535;
  with bar.a[ar] do begin
    {$i-} seek(file_,end_+(folder-1)*sizeof(longint)); {$i+}
    if ioresult<>0 then exit;
    blockread(file_,idx,sizeof(longint),x);
    if x<>sizeof(longint) then exit;
    {$i-} seek(file_,idx); {$i+}
    if ioresult<>0 then exit;
  end;
  bar_seek:=0;
end;

function bar_folder_length(ar:byte; folder:word):word; {65535=on_error}
var x:word;
    sub_header:type_bar_sub_header;
begin
  bar_folder_length:=65535;
  if (ar>bar.number)or(bar.a[ar].how<>1)or(folder>bar.a[ar].num_folders) then
    exit;
  if bar_seek(ar,folder)<>0 then exit;
  with bar.a[ar] do begin
    blockread(file_,sub_header,sizeof(type_bar_sub_header),x);
    if x<>sizeof(type_bar_sub_header) then exit;
{    dec(sub_header.length_,sizeof(type_bar_sub_header));
    if sub_header.length_>max_folder_length then exit;
    bar_folder_length:=sub_header.length_;}
    bar_folder_length:=sub_header.decompressed_length;
  end;
end;

function decompression(
  compr:byte;
  var from:pointer; length_:word;
  where_to:pointer; var decompressed_length:word):word; {65535=on_error}
{dealokuje vstup a předá do výstupu}
label on_error;
var x:word;
    tmp:pointer;
    tmp_length:word;
begin
  decompression:=65535;
  if where_to=nil then exit; {kontrola}

  if compr=0 then begin {pouze zkopíruje data}
    if decompressed_length<>length_ then
      exit;
    for x:=1 to length_ do
      pbytearray(where_to)^[x]:=pbytearray(from)^[x];
  end else if compr=1 then begin {decompression lzw}
    x:=decompression_lzw(from,length_,where_to,
      decompressed_length {zde už byla předána očekávaná délka, pokud se neshodují,
                   generuje se on_error});
    if x=65535 then exit;
  end else if compr=2 then begin {decompression huf}
    x:=decompression_huf(from,length_,where_to,decompressed_length);
    if x=65535 then exit;
  end else if compr=3 then begin
    {v prvních 2b je zapsána délka dekomprimátu, zde pouze dočasného}
    tmp_length:=pwordarray(from)^[1];
    getmem(tmp,tmp_length); {pomocná struktura}
    if tmp=nil then exit;
    x:=decompression_huf(from,length_,tmp,tmp_length);
    if x=65535 then begin
on_error:
      freemem(tmp,tmp_length);
      exit;
    end;
    x:=decompression_lzw(tmp,tmp_length,where_to,decompressed_length);
    if x=65535 then goto on_error;
    freemem(tmp,tmp_length);
  end else {nedovolený type_ decompression}
    exit;

  freemem(from,length_); {dealokace vstupu}
  from:=nil;
  decompression:=0;
end;

function compression(
  var compr:byte;
  from:pointer; decompressed_length:word;
  var where_to:pointer; var allocated_length,length_:word):word; {65535=on_error}
{převezme ze vstupu a naalokuje výstup (na velikost příp. mezikomprimátu)
 zajistí, že se komprimát do oblasti !VLEZE! za cenu toho, že se oželí
 compression}
var {x:word;
    last,now:byte;}
    tmp:pointer;
    tmp_length:word;
type tbytearray=array[1..65535]of byte;
     pbytearray=^tbytearray;
begin
  compression:=65535;
  if compr and $fc<>0 then {nedovolený type_ compression}
    exit;

{  for x:=2 to decompressed_length do begin
    now:=pbytearray(from)^[x]-last;
    last:=pbytearray(from)^[x];
    pbytearray(from)^[x]:=now;
  end;
}
  tmp_length:=decompressed_length; {bude v obou případech (kvůli 4. par. u compression)}
  allocated_length:=tmp_length;
  if compr and 1<>0 then begin {má se to zkomprimovat lzw}
    getmem(tmp,tmp_length); {naalokuje pomocné pole}
    if compression_lzw(from,decompressed_length,tmp,tmp_length)=65535 then begin
    {nelze alokovat do stejného místa, komprimát je delší
     komprimuje do naalokovaného místa, vrací délku, pokud přeteče,
     tak chybu}
      compr:=compr and $fe;
      freemem(tmp,tmp_length); {dealokuje ho zpět}
    end;
  end;
  if compr and 1=0 then begin {1. fáze je bez compression lzw}
    tmp:=from; {pak dáme pomocnou strukturu ukazovat na vstup}
  end;
  length_:=tmp_length;
  if compr and 2<>0 then begin {má se to zkomprimovat huf}
    allocated_length:=tmp_length; {i v 2. stupni MUSÍ dojít ke kompresi}
    getmem(where_to,allocated_length);
    if compression_huf(tmp,tmp_length,where_to,length_)=65535 then begin
      compr:=compr and $fd;
      freemem(where_to,allocated_length);
      allocated_length:=decompressed_length;
    end;
  end;
  if compr and 2=0 then begin {bez huf v 2. fázi}
    if compr and 1=0 then begin {není vytvořena kopie}
      {getmem(where_to,allocated_length);
      for x:=1 to length_ do
        pbytearray(where_to)^[x]:=pbytearray(tmp)^[x];}
      where_to := tmp; {SR: 2005-03-09}
    end else begin {je už kopie, tak tu dáme na výstup}
      where_to:=tmp;
    end;
  end;

  if compr=3 then {dealokuje příp. pomocnou strukturu}
    freemem(tmp,tmp_length);
  {vstup se nechá a výstup už je hotový}

  compression:=0;
end;

function bar_read(
  ar:byte; folder:word;
  where_to:pointer):word; {65535=on_error}
{čte do vyhrazeného místa, přesto vrací decompressed_length}
label on_error;
var sub_header:type_bar_sub_header;
    x:word;
    tmp:pointer;
begin
  bar_read:=65535;
  if (ar>bar.number)or(bar.a[ar].how<>1)or(folder>bar.a[ar].num_folders) then
    exit;
  if bar_seek(ar,folder)=65535 then exit; {kontrola vůbec seeku na složku}

  with bar.a[ar] do begin
    blockread(file_,sub_header,sizeof(type_bar_sub_header),x); {kontrola hlavičky}
    if x<>sizeof(type_bar_sub_header) then exit;
    if sub_header.decompressed_length>max_folder_length then exit;
    dec(sub_header.length_,sizeof(type_bar_sub_header));

    if sub_header.length_=0 then begin {složka nulové délky}
      bar_read:=0;
      exit;
    end;

    getmem(tmp,sub_header.length_); {načteme si zkomprimovanou složku}
    if tmp=nil then exit;
    blockread(file_,tmp^,sub_header.length_,x);
    if x<>sub_header.length_ then begin
on_error:
      freemem(tmp,sub_header.length_);
      exit;
    end;

    x:=sub_header.decompressed_length; {očekávaná výstupní velikost}
    if decompression(sub_header.compr,tmp,sub_header.length_,where_to,x)=65535 then goto on_error;
    if x<>sub_header.decompressed_length then goto on_error;

    for x:=1 to sub_header.decompressed_length do {zkontrolujeme crc}
      sub_header.crc:=sub_header.crc xor pbytearray(where_to)^[x];
    if sub_header.crc<>0 then goto on_error;

    {pomocná struktura už je dealokována v proceduře decompression}
  end;
  bar_read:=sub_header.decompressed_length;
end;

function bar_alloc_and_read(
  ar:byte; folder:word;
  var where_to:pointer):word; {65535=on_error}
{vyhradí místo, vrací decompressed_length}
var length_:word;
begin
  bar_alloc_and_read:=65535;

  length_:=bar_folder_length(ar,folder); {alokace místa}
  if length_=65535 then exit;
  if length_=0 then begin {nulová složka}
    where_to:=nil;
    bar_alloc_and_read:=0;
    exit;
  end;
  getmem(where_to,length_);
  if where_to=nil then exit;

  if bar_read(ar,folder,where_to)<>length_ then begin {načtení}
    freemem(where_to,length_);
    exit;
  end;

  bar_alloc_and_read:=length_;
end;

function bar_write(
  ar:byte;
  from:pointer; decompressed_length:word):word; {65535=on_error}
{pouze zapíše bez dealokace, jinak vrací číslo složky}
label on_error;
var sub_header:type_bar_sub_header;
    allocated_length,x:word;
    tmp:pointer;
begin
  bar_write:=65535;
  if (ar>bar.number)or(bar.a[ar].how<>2) then {kontrola správnosti archivu}
    exit;
  with bar.a[ar] do begin
    if num_folders>=max_folders_in_archive then exit;

    {$i-} seek(file_,filesize(file_)); {$i+}
    if ioresult<>0 then exit;
    sub_header.decompressed_length:=decompressed_length;
    sub_header.compr:=compression_type;
    sub_header.crc:=0; {výpočet crc}
    for x:=1 to decompressed_length do
      sub_header.crc:=sub_header.crc xor pbytearray(from)^[x];

    if compression(sub_header.compr,from,decompressed_length,tmp,allocated_length,sub_header.length_)=65535 then
      exit; {příp. upraví type_ compression}
    {file_path s nulovou délkou se nějak zapakuje... (je-li pakování, tak
     bude nenulový, není-li bude nulový, ale na tom se getmem/fremem ani
     nic jiného nezblbne)}

    inc(sub_header.length_,sizeof(type_bar_sub_header));
    blockwrite(file_,sub_header,sizeof(sub_header),x); {kontrola hlavičky}
    dec(sub_header.length_,sizeof(type_bar_sub_header));
    if x<>sizeof(sub_header) then begin
on_error:
      if sub_header.compr <> 0 then {SR}
        freemem(tmp,sub_header.length_);
      exit;
    end;

    blockwrite(file_,tmp^,sub_header.length_,x); {zápis kódu}
    if x<>sub_header.length_ then goto on_error;

    if sub_header.compr <> 0 then {SR}
      freemem(tmp,allocated_length); {dealokace pomocných struktur}

    inc(num_folders); {aktualizace hlavičky}
    inc(end_,sub_header.length_+sizeof(sub_header));

    bar_write:=num_folders;
  end;
end;

function bar_write_and_dealloc(
  ar:byte;
  var from:pointer; decompressed_length:word):word; {65535=on_error}
{po úspěšném zapsání dealokuje, jinak vrací číslo složky}
var folder:word;
begin
  bar_write_and_dealloc:=65535;

  folder:=bar_write(ar,from,decompressed_length);
  if folder=65535 then exit;
  freemem(from,decompressed_length);
  from:=nil;

  bar_write_and_dealloc:=folder;
end;

function bar_read_file(
  ar:byte;
  folder:word;
  file_:string):word; {65535=on_error}
{zkopíruje obsah složky archívu do souboru, vrací délku souboru}
label on_error,on_error_1;
var tmp:pointer;
    len,x:word;
    fo:file;
begin
  bar_read_file:=65535;

  len:=bar_alloc_and_read(ar,folder,tmp); {načíst obsah dané složky}
  if len=65535 then exit;

  if file_='' then goto on_error;
  assign(fo,file_); {zapsat to do souboru}
  {$i-} rewrite(fo,1); {$i+}
  if ioresult<>0 then goto on_error;
  blockwrite(fo,tmp^,len,x);
  if x<>len then goto on_error_1;

  bar_read_file:=len;
on_error_1:
  close(fo);
on_error:
  freemem(tmp,len);
end;

function bar_write_file(
  ar:byte;
  file_:string):word; {65535=on_error}
{překopíruje obsah souboru do archívu, vrací číslo složky}
label on_error,on_error_1;
var tmp:pointer;
    x:word;
    len:longint;
    fi:file;
begin
  bar_write_file:=65535;

  if file_='' then exit;
  assign(fi,file_); {pokusí se načíst file_path}
  {$i-} reset(fi,1); {$i+}
  if ioresult<>0 then exit;
  len:=filesize(fi);
  if (ioresult<>0)or(len>max_folder_length) then goto on_error;
  getmem(tmp,len);
  if tmp=nil then goto on_error;
  blockread(fi,tmp^,len,x);
  if x<>len then goto on_error_1;

  x:=bar_write(ar,tmp,len); {pokusí se to zapsat do archívu}
  if x=65535 then goto on_error_1;

  bar_write_file:=x; {jinak to proběhlo úspěšně}
on_error_1:
  freemem(tmp,len);
on_error:
  close(fi);
end;

var oldexitproc:pointer;

{$f+}
procedure donebarchiv;
var x:byte;
begin
  for x:=1 to bar.number do
    if bar.a[x].how<>0 then
      bar_close(x);
  bar.number:=0;
  exitproc:=oldexitproc;
end;
{$f-}

begin
  bar.number:=0; {není otevřen žádný archív}
  oldexitproc:=exitproc;
  exitproc:=@donebarchiv;
end.

{dodělat ochranu proti chybám u: bar_close (io), compression (mem)
 možná by se mělo bar_write_and_dealloc přepsat, aby to dealokoval vhodně rychle
 na správném místě (kvůli nedostatku paměti)

 lzw+huf mov nefachá ---> nahradit huf+lzw, které docela fachá!
 at savuje type_ chyby
 reotevření archívu --- DONE}
