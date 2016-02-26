{2005-03-10}
program extract;
var fi, fo: file;
    s: string;
    nr, i: integer;
    start, stop: longint;
    buf: array[1..30000] of byte;
begin
  assign(fi, 'c:\games\dh\cd.sam');
  reset(fi, 1);
  s := paramstr(1);
  val(s, nr, i);
  assign(fo, s + '.buf');
  rewrite(fo, 1);
  seek(fi, nr * 4);
  blockread(fi, start, 4);
  blockread(fi, stop, 4);
  writeln('Sampl ', nr, ' je ulozen na [', start, ', ', stop, ']');
  seek(fi, start);
  dec(stop, start);
  writeln('Extrahuji ', stop, 'b');
  seek(fo, $50);
  repeat
    if stop > 30000 then
      i := 30000
    else
      i := stop;
    blockread(fi, buf, i, i);
    blockwrite(fo, buf, i);
    dec(stop, i);
  until stop = 0;
  close(fo);
  close(fi);
end.
