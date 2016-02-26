{podpora lzw compression pro BARchív}

unit bar_lzw;
interface
uses bar_tog;

function compression_lzw(
  from:pbytearray; decompressed_length:word;
  where_to:pbytearray; var compressed_length:word):word; {65535=on_error}
function decompression_lzw(
  from:pbytearray; compressed_length:word;
  where_to:pbytearray; var decompressed_length:word):word; {65535=on_error}

implementation

const buffer_size = 4096;
      null_constant            = buffer_size;
      max_step_length   = 18;
      min_step_length   = 2;

type pbuffer=^tbuffer;
     tbuffer=array [0..buffer_size+max_step_length-1] of byte;
     p_left_son=^t_left_son;
     t_left_son=array [0..buffer_size] of word;
     p_right_son=^t_right_son;
     t_right_son=array [0..buffer_size+256] of word;

function compression_lzw(
  from:pbytearray; decompressed_length:word;
  where_to:pbytearray; var compressed_length:word):word; {65535=on_error}
{komprimuje do naalokovaného výstupu, ale pokud se tam komprimát nevleze,
 ohlásí chybu, jinak vrátí zkomprimovanou délku}
var input_index,num_images:word; {indexy komprimace}
    on_error:word;

    {celá tato compression je opsána z bytes:}
    buffer:pbuffer;
    position_in_the_step,step_length:word;
    left_son, father:p_left_son;
    right_son:p_right_son;

 procedure initialize_tree;
 var tmp:word;
 begin
   for tmp:=buffer_size+1 to buffer_size+256 do
     right_son^[tmp]:=null_constant;
   for tmp:=0 to buffer_size-1 do
     father^[tmp]:=null_constant
 end;

 procedure insert_pointer (R:word);
 label found_difference,very_long_match;
 var I,P:word;
     Cmp:integer;
     Key:byte;
 begin
   Cmp:=1;
   step_length:=0;
   Key:=buffer^[R];
   P:=buffer_size+Key+1;
   right_son^[R]:=null_constant;
   left_son^[R]:=null_constant;
   repeat
     if Cmp>=0 then
       if right_son^[P]<>null_constant then P:=right_son^[P]
                            else begin
                                   right_son^[P]:=R;
                                   father^[R]:=P;
                                   Exit
                                 end
       else if left_son^[P]<>null_constant then P:=left_son^[P]
                                else begin
                                       left_son^[P]:=R;
                                       father^[R]:=P;
                                       Exit
                                     end;
     I:=1;
     while I<max_step_length do
       begin
         Cmp:=buffer^[R+I]-buffer^[P+I];
         if Cmp<>0 then
           GoTo found_difference;
         Inc(I)
       end;
 found_difference:
     if I>step_length then
       begin
         position_in_the_step:=P;
         step_length:=I;
         if step_length>=max_step_length then
           GoTo very_long_match
       end
   until False;
 very_long_match:
   father^[R]:=father^[P];
   left_son^[R]:=left_son^[P];
   right_son^[R]:=right_son^[P];
   father^[left_son^[P]]:=R;
   father^[right_son^[P]]:=R;
   if right_son^[father^[P]]=P then right_son^[father^[P]]:=R
                          else left_son^[father^[P]]:=R;
   father^[P]:=null_constant
 end;

 procedure remove_pointer (P:word);
 var Q:word;
 begin
   if father^[P]=null_constant then
     Exit;
   if right_son^[P]=null_constant then
     Q:=left_son^[P]
   else if left_son^[P]=null_constant
     then Q:=right_son^[P]
     else begin
       Q:=left_son^[P];
       if right_son^[Q]<>null_constant then
         begin
           repeat
             Q:=right_son^[Q]
           until right_son^[Q]=null_constant;
           right_son^[father^[Q]]:=left_son^[Q];
           father^[left_son^[Q]]:=father^[Q];
           left_son^[Q]:=left_son^[P];
           father^[left_son^[P]]:=Q
         end;
       right_son^[Q]:=right_son^[P];
       father^[right_son^[P]]:=Q
     end;
   father^[Q]:=father^[P];
   if right_son^[father^[P]]=P then right_son^[father^[P]]:=Q
                          else left_son^[father^[P]]:=Q;
   father^[P]:=null_constant
 end;

 procedure perform_compression;
 var I,length_,R,S:word;
     C,last_step_length,code_pointer,mask:byte;
     code_buffer:array[0..16]of byte;
 begin
   initialize_tree;
   code_buffer[0]:=0;
   mask:=1;
   code_pointer:=1;
   S:=0;
   R:=buffer_size-max_step_length;
   for I:=S to R-1 do
     buffer^[I]:=$20;
   length_:=0;

   input_index:=1; {where_to zapisovat}
   num_images:=0; {index na end_ prozatímního zápisu}

   while (length_<max_step_length)and(input_index<=decompressed_length) do
     begin
       buffer^[R+length_]:=from^[input_index];
       inc(input_index);
       Inc(length_);
     end;
   if length_=0 then Exit;

   for I:=1 to max_step_length do
     insert_pointer(R-I);
   insert_pointer(R);

   repeat
     if step_length>length_ then
       step_length:=length_;
     if step_length<=min_step_length
       then begin
              step_length:=1;
              code_buffer[0]:=code_buffer[0] or mask;
              code_buffer[code_pointer]:=buffer^[R];
              Inc(code_pointer)
            end
       else begin
              code_buffer[code_pointer]:=Lo(position_in_the_step);
              Inc(code_pointer);
              code_buffer[code_pointer]:=(Hi(position_in_the_step) SHL 4) or
                                        (step_length-min_step_length-1);
              Inc(code_pointer)
            end;

     mask:=(mask SHL 1) and $FF;
     if mask=0 then
       begin
         if num_images>=compressed_length-(code_pointer-1) then begin
           on_error:=65535;
           exit;
         end;
         for I:=0 to code_pointer-1 do begin
           inc(num_images);
           where_to^[num_images]:=code_buffer[i];
         end;
         code_buffer[0]:=0;
         mask:=1;
         code_pointer:=1
       end;

     last_step_length:=step_length;
     I:=0;
     while (I<last_step_length) and (input_index<=decompressed_length) do
       begin
         C:=from^[input_index];
         inc(input_index);
         remove_pointer(S);
         buffer^[S]:=C;
         if S<max_step_length-1 then
           buffer^[S+buffer_size]:=C;
         S:=(S+1) and (buffer_size-1);
         R:=(R+1) and (buffer_size-1);
         insert_pointer(R);
         Inc(I)
       end;

     while I<last_step_length do
       begin
         Inc(I);
         remove_pointer(S);
         S:=(S+1) and (buffer_size-1);
         R:=(R+1) and (buffer_size-1);
         Dec(length_);
         if length_<>0 then insert_pointer(R)
       end;

   until length_<=0;

   if code_pointer>1 then
     begin
       if num_images>=compressed_length-(code_pointer-1) then begin {end_?}
         on_error:=65535;
         exit;
       end;
       for I:=0 to code_pointer-1 do begin
         inc(num_images);
         where_to^[num_images]:=code_buffer[I];
       end;
     end;
 end;

begin
  on_error:=0;
  compression_lzw:=65535;

  new(buffer);
  new(father);
  new(left_son);
  new(right_son);
  perform_compression; {provede onu záhadnou kompresi}
  dispose(buffer);
  dispose(father);
  dispose(left_son);
  dispose(right_son);
  if on_error=65535 then exit;

  compression_lzw:=0;
  compressed_length:=num_images;
end;

function decompression_lzw(
  from:pbytearray; compressed_length:word;
  where_to:pbytearray; var decompressed_length:word):word; {65535=on_error}
{komprimuje do naalokovaného výstupu, pokud nejsou výsledné délky shodné,
 ohlásí chybu, jinak vrátí zkomprimovanou délku (tzn. nic navíc se nestane)}
var input_index,num_images:word; {kompresní indexy}
    on_error:word;

    buffer:pbuffer;

 procedure perform_decompression;
 var I,C,length_:byte;
     K,R,position,flag:word;
 begin
   for K:=0 to buffer_size-max_step_length-1 do
     buffer^[K]:=$20;
   R:=buffer_size-max_step_length;
   flag:=0;

   input_index:=1; {where_to zapisovat}
   num_images:=0; {index na end_ prozatímního zápisu}

   repeat
     flag:=flag shr 1;
     if (flag and $100)=0 then
       begin
         if input_index>compressed_length then
           Break;
         C:=from^[input_index];
         inc(input_index);
         flag:=C or $FF00
       end;

     if (flag and $01)=0
       then begin
              if input_index>compressed_length-1 then
                Break;
              I:=from^[input_index];
              length_:=from^[input_index+1];
              inc(input_index,2);
              position:=I or ((length_ and $F0) shl 4);
              length_:=(length_ and $0F)+min_step_length;
              if num_images>=decompressed_length-length_ then begin
                on_error:=65535;
                exit;
              end;
              for K:=0 to length_ do
                begin
                  C:=buffer^[(position+K) and (buffer_size-1)];
                  inc(num_images);
                  where_to^[num_images]:=c;
                  buffer^[R]:=C;
                  R:=(R+1) and (buffer_size-1)
                end
            end
       else begin
              if input_index>compressed_length then
                Break;
              if num_images>=decompressed_length then begin
                on_error:=65535;
                exit;
              end;
              inc(num_images);
              c:=from^[input_index];
              where_to^[num_images]:=c;
              inc(input_index);
              buffer^[R]:=C;
              R:=(R+1) and (buffer_size-1)
            end
   until False;
 end;

begin
  on_error:=0;
  decompression_lzw:=65535;

  new(buffer);
  perform_decompression;
  dispose(buffer);
  if on_error=65535 then exit;
  if num_images<>decompressed_length then exit;

  decompression_lzw:=0;
end;

end.
