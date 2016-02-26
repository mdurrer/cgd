{podpora huf compression pro BARchív}

unit bar_huf;
interface
uses bar_tog;

function compression_huf(
  from:pbytearray; decompressed_length:word;
  where_to:pbytearray; var compressed_length:word):word; {65535=on_error}
function decompression_huf(
  from:pbytearray; compressed_length:word;
  where_to:pbytearray; var decompressed_length:word):word; {65535=on_error}

implementation

type p_char=^t_znak;
     t_znak=record
       frequency:word;
       char_:integer; {-1 je vytvoreny char_}
       height:byte;
       left,right:p_char;
     end;

     t_frequency=array[byte]of word;

     t_sequence_of_bits=array[1..max_tree_depth]of byte;
     p_1_image=^t_1_image;
     t_1_image=record
       bits,bytes,depth:byte;
       b:t_sequence_of_bits;
     end;
     t_images=array[byte]of p_1_image;

procedure deallocate_tree(var tree:p_char);
begin
  if tree^.char_=-1 then begin
    deallocate_tree(tree^.left);
    deallocate_tree(tree^.right);
  end;
  dispose(tree);
end;

procedure deallocate_images(var img:t_images);
var i:byte;
begin
  for i:=0 to 255 do
    if img[i]<>nil then
      freemem(img[i],3+img[i]^.bytes);
end;

function compression_huf(
  from:pbytearray; decompressed_length:word;
  where_to:pbytearray; var compressed_length:word):word; {65535=on_error}
{komprimuje do naalokovaného výstupu, ale pokud se tam komprimát nevleze,
 ohlásí chybu, jinak vrátí zkomprimovanou délku}
label label_error;
var num_images,len_images:word; {indexy}
    on_error:word; {chybová proměnná}
    freq:t_frequency; {kompresní proměnné}
    tree:p_char;
    img:t_images;

 procedure load_frequency(var freq:t_frequency);
 {projde celý vstupní file_path a vypočítá četnost všech jeho znaků}
 var x:word;
 begin
   fillchar(freq,sizeof(freq),0);
   for x:=1 to decompressed_length do
     inc(freq[from^[x]]);
 end;

 procedure frequency2tree(
   var orig_freq:t_frequency; {vstup}
   var tree:p_char; {2 výstupy}
   var img:t_images);
 {postavi tree stylem 2 nejridsi znaky propoji a povazuje za castejsi char_
  pocita vysku stromu a savne to taky k cetnosti
  dále zapíše tento tree do hlavičky zkomprimovaného souboru
  a spočítá hloubku a bitové obrazy všech znaků}
 var depth_:byte; {depth_ stromu}
     bits_:t_sequence_of_bits; {jednotlivé bits_ znaků}
     byte_length,bit_index:byte; {počítadlo bitů}

  procedure write_number_of_bits(tree:p_char);
  {zapise rekurzivne hloubku a bitové obrazy vsech znaku
   průběžně to ukládá do hlavičky zkomprimovaného souboru}
  var i:byte; {pomocné počítadlo}
  begin
    if (num_images>compressed_length-1{2 znaky kontrola pro oba případy}) or
       (on_error<>0) then begin
      on_error:=65535;
      exit;
    end;

    if tree^.char_=-1 then begin {zapise rozvetveni}
      where_to^[num_images]:=0; {zapíšeme do výstupu rozvětvení}
      inc(num_images);
      inc(depth_); {zvětšíme hloubku stromu}
      inc(bit_index); {posuneme se na další bit}
      if bit_index=8 then begin
        inc(byte_length);
        bit_index:=0;
      end;

      {zavoláme rekurzivně sami sebe s 0. bitem (vlevo)}
      write_number_of_bits(tree^.left);
      bits_[byte_length]:=bits_[byte_length] xor (1 shl bit_index);
      {zavoláme rekurzivně sami sebe s 1. bitem (vpravo)}
      write_number_of_bits(tree^.right);

      {obnovíme bit, hloubku stromu a počítadlo bitů}
      bits_[byte_length]:=bits_[byte_length] xor (1 shl bit_index);
      dec(depth_);
      if bit_index=0 then begin
        dec(byte_length);
        bit_index:=7;
      end else
        dec(bit_index);
    end else begin {zapise char_}
      where_to^[num_images]:=1; {zapíše do hlavičky}
      inc(num_images);
      where_to^[num_images]:=tree^.char_;
      inc(num_images);

      getmem(img[byte(tree^.char_)],3+byte_length); {zapíše jeho bitový obraz}
      with img[byte(tree^.char_)]^ do begin
        bits:=bit_index+1;
        bytes:=byte_length;
        depth:=depth_;
        for i:=1 to byte_length do
          b[i]:=bits_[i];
      end;
    end;
  end;

 var freq:array[byte] of p_char; {pomocný tree}
     i,j,number:integer; {počítadla}
     tmp_1_char:p_char; {pomocná větev}
 begin
   if compressed_length<2 then begin
     on_error:=65535;
     exit;
   end;
   pwordarray(where_to)^[1]:=decompressed_length; {zapíšeme délku vstupního souboru}
   num_images:=3; {počítadlo zápisu do bufferu}

   number:=256;
   for i:=0 to number-1 do begin {alokuje listy stromu}
     new(freq[i]);
     freq[i]^.frequency:=orig_freq[i];
     freq[i]^.char_:=i;
     freq[i]^.height:=0;
     freq[i]^.left:=nil;
     freq[i]^.right:=nil;
   end;
   for i:=1 to number-1 do {setřídit tento seznam podle četnosti znaků}
     for j:=number-1 downto i do
       if freq[j]^.frequency<freq[j-1]^.frequency then begin
         tmp_1_char:=freq[j];
         freq[j]:=freq[j-1];
         freq[j-1]:=tmp_1_char;
       end;
   {pro menší tree ignorujeme znaky s výskytem 0
    a to i v případě, že by tree obsahoval pouze jediný char_}
   j:=0;
   while (j<number)and(freq[j]^.frequency=0) do
     inc(j);
   dec(number,j);
   if number=0 then inc(number); {pokud byl prázdný file_path, zanecháme jediný char_}
   if j<>0 then begin {dealokuje zbytečné uzly a přesune ostatní}
     for i:=0 to j-1 do
       dispose(freq[i]);
     for i:=0 to number-1 do
       freq[i]:=freq[i+j];
   end;
   {nyní budeme kombinovat tree, dokud nezůstane jediný vrchol}
   while number>1 do begin
     new(tmp_1_char); {vezmeme 2 nejridsi znaky, vytvorime z nich novy char_}
     tmp_1_char^.frequency:=freq[0]^.frequency+freq[1]^.frequency;
     tmp_1_char^.char_:=-1;
     if freq[0]^.height>freq[1]^.height {vezmeme vetsi vysku stromu}
       then tmp_1_char^.height:=freq[0]^.height+1
       else tmp_1_char^.height:=freq[1]^.height+1;
     tmp_1_char^.left:=freq[0];
     tmp_1_char^.right:=freq[1];
     i:=1; {vyhledame, ZA co to mame vlozit}
     while (i<number-1)and(freq[i+1]^.frequency<=tmp_1_char^.frequency) do
       inc(i);
     for j:=0 to i-2 do {posuneme ridsi znaky}
       freq[j]:=freq[j+2];
     freq[i-1]:=tmp_1_char; {vlozime char_}
     dec(number);
     for j:=i to number-1 do {posuneme hustejsi znaky}
       freq[j]:=freq[j+1];
   end;
   tree:=freq[0];

   depth_:=0; {zatím je nulová depth_}
   fillchar(img,sizeof(img),0); {nil ke všem zapisovaným znakům}
   fillchar(bits_,sizeof(bits_),0); {nulové bits_}
   byte_length:=0; {where_to se bude zapisovat}
   bit_index:=7;
   write_number_of_bits(tree); {vypočítáme hlavičku a vytvoříme obrazy}
   if on_error<>0 then
     exit;

   len_images:=0;
   for j:=0 to 255 do
     inc(len_images,orig_freq[j]*img[j]^.depth);
   len_images:=trunc(len_images/8+0.99);
{   writeln('nekomprimovano: ',decompressed_length:16,'b');
   writeln('hlavicka huffm: ',num_images+4:16,'b');
   writeln('huffmanuv  code: ',len_images:16,'b');
   writeln('uspora       o: ',(decompressed_length-len_images-(num_images+4))/decompressed_length*100:16:2,'%');}

   inc(len_images,num_images-1);
   if len_images>compressed_length then begin {nevleze-li se to do bufferu}
     on_error:=65535;
     exit;
   end;
 end;

 procedure compression(var img:t_images);
 var input_index:word; {index vstupu}
     stack:integer; {zde se budou provadet ty rotace}
     bits_in_stack,i:byte; {kolik je v zasobniku bits, temp}
 begin
   stack:=0; {inicializace zápisu}
   bits_in_stack:=0;
   if img[from^[1]]^.bytes=0 then begin
   {nějaký char_ má null_constant bajtů ---> všechno má null_constant bajtů
    nic se nezapisuje}
   end else
   {jinak všechno poctivě zapíšeme}
     for input_index:=1 to decompressed_length do {přečteme celý vstupní file_path}
       with img[from^[input_index]]^ do begin{zapiseme BITOVE jednotlivy char_}
         for i:=1 to bytes-1 do begin {vsechny PLNE bajty}
           stack:=stack or (b[i] shl bits_in_stack); {pridej 1. char_}
           where_to^[num_images]:=stack and $ff; {zapis ho a posun buffer}
           inc(num_images);
           stack:=stack shr 8;
         end;
         stack:=stack or (b[bytes] shl bits_in_stack); {pridej posledni char_}
         {za jeho koncem jsou jistě samé nuly}
         inc(bits_in_stack,bits);
         if bits_in_stack>=8 then begin
           where_to^[num_images]:=stack and $ff;
           inc(num_images);
           stack:=stack shr 8;
           dec(bits_in_stack,8);
         end;
       end;
     {kontrolu přetečení výstupu provádět nebudu, bylo by to pomalejší
      a už je to určitě (snad) odladěno :-) }
   if bits_in_stack<>0 then begin
     where_to^[num_images]:=stack and $ff;
     inc(num_images);
   end;
   if num_images-1<>len_images then begin {ale to by mělo souhlasit}
     on_error:=65535;
     exit;
   end;
 end;

begin
  on_error:=0;
  compression_huf:=65535;

  load_frequency(freq); {výpočet compression}
  if on_error<>0 then exit;
  frequency2tree(freq,tree,img);
  if on_error<>0 then goto label_error;
  {i v případě chyby se to správně odalokuje}

  compression(img);
  if on_error<>0 then goto label_error;

  compression_huf:=0;
  compressed_length:=len_images;
label_error:
  deallocate_tree(tree);
  deallocate_images(img);
end;

function decompression_huf(
  from:pbytearray; compressed_length:word;
  where_to:pbytearray; var decompressed_length:word):word; {65535=on_error}
{komprimuje do naalokovaného výstupu, pokud nejsou výsledné délky shodné,
 ohlásí chybu, jinak vrátí zkomprimovanou délku (tzn. nic navíc se nestane)}
label label_error;
var input_index:word; {index komprimace}
    on_error:word; {chybová proměnná}
    tree:p_char; {kompresní proměnné}

 {The parameter nothing is allow us to get a value by calling
 load_header(...) recursively.  BP7 doesn't allow us to call just load_header()
 and with just load_header Free Pascal thinks I'm reading the uninitialized
 (yet) return value.}
 function load_header(nothing:integer):p_char;
 var tree:p_char;
     i:byte;
 begin
   if input_index>compressed_length-1 then begin
   {v obou případech jsou z bufferu požadovány aspoň 2b}
     on_error:=65535;
     exit;
   end;
   new(tree);
   tree^.frequency:=0;
   tree^.height:=0;
   tree^.char_:=0; {horni bit}
   i:=from^[input_index];
   inc(input_index);
   if i=1 then begin {char_}
     tree^.char_:=from^[input_index];
     inc(input_index);
     tree^.left:=nil;
     tree^.right:=nil;
   end else begin {rozvetveni}
     tree^.char_:=-1;
     tree^.left:=load_header(nothing);
     tree^.right:=load_header(nothing);
   end;
   load_header:=tree;
 end;

 procedure decompression(tree:p_char);
 var current_bit:byte;
     num_images:word;
     test:p_char;
 begin
   current_bit:=1; {nutnost načíst 1. blok}
   {input_index už je nastaveno}
   for num_images:=1 to decompressed_length do begin {zapíšeme všechny výstupní znaky}
     test:=tree; {hledáme od kořenu stromu}
     while test^.char_=-1 do begin {dokud nenalezneme list}
       if from^[input_index] and current_bit=0 {hledáme ve stromu}
         then test:=test^.left
         else test:=test^.right;
       {$r-}
       current_bit:=current_bit shl 1; {najedeme na další bit}
       {$r+}
       if current_bit=0 then begin {end_ bytes?}
         inc(input_index);
         current_bit:=1;
       end;
     end;
     where_to^[num_images]:=test^.char_;
   end;
   if current_bit=1 then
     dec(input_index);
   if input_index<>compressed_length then begin {kontrola přečtení celého vstupního fajlu}
     on_error:=65535;
     exit;
   end;
end;

begin
  on_error:=0;
  decompression_huf:=65535;

  if pwordarray(from)^[1]<>decompressed_length then exit; {špatná délka}
  input_index:=3; {čtení z bufferu}
  tree:=load_header(0); {načteme hlavičku komprimátu}
  if on_error<>0 then goto label_error;

  decompression(tree);
  if on_error<>0 then goto label_error;

  decompression_huf:=0;
label_error:
  deallocate_tree(tree);
end;

end.
