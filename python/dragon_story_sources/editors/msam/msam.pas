{$i-}
program MSam;

uses use_ems1,sbl_old,dos,crt,dfw,printer;

const maxt = 4000;
      cesta : string = '.\buf';
      inputpath : string = '.\samply';
      pripona : string = '*.voc';
      freqofDMA = 22000;

var Dcolor : array[1..4] of byte;
 {1 .. ramecky
  2 .. pozadi
  3 .. text
  4 .. oznaceni v menu}
    textedit : string;
    maxrete, key : word;
    buffer : byte;
    there : word;
    notclose,possible : boolean;
    name : string;
    where, page : integer;

    tab : array[0..8000] of longint;

procedure Frame(x,y,x1,y1 : byte; smaz : boolean);
var i : byte;
begin
  textcolor(Dcolor[1]);
  textbackground(DColor[2]);
  for i:=x to x1 do begin
    gotoxy(i,y); write('═');
    gotoxy(i,y1); write('═');
  end;
  for i:=y+1 to y1-1 do if smaz then begin
    gotoxy(x,i); write('║',' ':x1-x-1,'║');
  end else begin
    gotoxy(x,i); write('║');
    gotoxy(x1,i); write('║');
  end;
  gotoxy(x,y); write('╔');
  gotoxy(x1,y); write('╗');
  gotoxy(x,y1); write('╚');
  gotoxy(x1,y1); write('╝');
end;

function ReadKeyy : word;
var i : word;
begin
  i:=word(readkey);
  if (i=0)and keypressed
    then i:=256+byte(readkey);
  ReadKeyy:=i;
end;

function ReadWord(x,y : byte; s : string) : word;
var i : word;
begin
  Frame(x-1,y-1,length(s)+5+x,y+1,true);
  gotoxy(x,y);
  write(s);
  readln(i);
  readword:=i;
end;

function FileExist(name : string) : boolean;
var f : file;
begin
  assign(f,name);
  reset(f,1);
  if ioresult<>0 then fileexist:=false else begin
    fileexist:=true;
    close(f);
  end;
end;

function LoadFile(x,y,z : byte; cesta,pripona : string) : string;
var inf : array[1..300] of SearchRec;
    name : searchrec;
    i : byte;
    key : word;
    where, page : word;

  procedure tisk(cele : boolean);
  var ii : byte;
  begin
    if cele then frame(x,y,x+16,y+z+2,true);
    gotoxy(x+5,y+z+2); write(pripona);
    for ii:=page to page+z do begin
      gotoxy(x+2,y+ii-page+1);
      if ii=where
        then textbackground(dcolor[4])
        else textbackground(dcolor[2]);
      if ii>i then write(' ':12) else begin
        write(inf[ii].name,
              ' ':13-length(inf[ii].name));
      end;
    end;
  end;
  procedure Up;
  begin
    if where>1 then dec(where);
    if where<page then dec(page);
  end;
  procedure Dn;
  begin
    if where<i then inc(where);
    if page+z<where then inc(page);
  end;
  procedure PgUp;
  begin
    if page>z then begin
      dec(page,z);
      dec(where,z);
    end else begin
      page:=1;
      where:=1;
    end;
  end;
  procedure PgDn;
  begin
    if page<i-z then begin
      inc(page,z);
      inc(where,z);
    end else begin
      page:=i-z;
      where:=i;
    end;
  end;
  procedure TUp;
  begin
    page:=1;
    where:=1;
  end;
  procedure TDn;
  begin
    page:=i-z;
    where:=i;
  end;
begin
  i:=1;
  dec(z);
  where:=1; page:=1;
  FindFirst(cesta+'\'+pripona, $3F, name);
  while DosError = 0 do
  begin
    inf[i]:=name;
    inc(i);
    FindNext(name);
  end;
  dec(i);
  tisk(true);
  repeat
    key:=ReadKeyy;
    case key of
      256+72 : Up;
      256+80 : Dn;
      256+73 : PgUp;
      256+81 : PgDn;
      256+132 : TUp;
      256+118 : TDn;
    end;
    tisk(false);
  until (key=27)or(key=13);
  if key=13
    then LoadFile:=inputpath+inf[where].name
    else LoadFile:=#27;
end;


function DEdit(x,y,z,xx : byte; i : integer) : word;
const s : string =
'                                                                           ';
var quit : boolean;
    xxx : byte;
    ss : string;

  procedure tisk(cele : boolean);
  var ii : word;
  begin
    if cele
      then frame(x,y,x+xx,y+z+2,true)
      else frame(x,y,x+xx,y+z+2,false);
    gotoxy(x+4,y+z+2); write(where,':',xxx);
    textcolor(dcolor[3]);
    if page<>1 then begin gotoxy(x+xx div 2,y); write(#30); end;
    if page+z<i then begin gotoxy(x+xx div 2,y+z+2); write(#31); end;
    for ii:=page to page+z do begin
      gotoxy(x+2,y+ii-page+1);
      if ii=where
        then textbackground(dcolor[4])
        else textbackground(dcolor[2]);
      if ii>i then write(' ':xx-2)
      else begin
        s[0]:=#255;
        str(ii,ss);
        ss:=ss+copy(s,1,3-length(ss));
        ss:=ss+copy({textedit[ii]}GetTextEMS(1,ii),xxx,73);
        s[0]:=chr(78-length(ss)-1);
        write(ss+s);
      end;
    end;
    gotoxy(1,21);
    write(GetTextEMS(1,where),' ':255-(length(GetTextEMS(1,where))));
    gotoxy(75,24);
    str(where,name); name:=cesta+name+'.buf';
    if not keypressed and FileExist(name) then write('Ano') else write('Ne ');
  end;
  procedure Up;
  begin
    if where>1 then dec(where);
    if where<page then dec(page);
  end;
  procedure Dn;
  begin
    if where<i then inc(where);
    if page+z<where then inc(page);
  end;
  procedure PgUp;
  begin
    if page>z then begin
      dec(page,z);
      dec(where,z);
    end else begin
      page:=1;
      where:=1;
    end;
  end;
  procedure PgDn;
  begin
    if page<i-z then begin
      inc(page,z);
      inc(where,z);
    end else begin
      if i-z>0 then page:=i-z else page:=1;
      where:=i;
    end;
  end;
  procedure TUp;
  begin
    page:=1;
    where:=1;
  end;
  procedure TDn;
  begin
    if i-z>0 then page:=i-z else page:=1;
    where:=i;
  end;
  procedure GoNumber;
  var ii : word;
  begin
    ii:=ReadWord(10,10,'Enter new line number: ');
    if ii<=i then where:=ii else write(#7);
  end;
begin
  dec(z);
  quit:=false;
  xxx:=1;
  tisk(true);
  repeat
    tisk(false);
    repeat
      if keypressed then key:=ReadKeyy else key:=0;
      gotoxy(x+45,y+z+2); if endofdma
        then write('STOP')
        else write('PLAY : ', ((AudioCounter*bufferdma div 2+bufferdma/2-DMAposition)/freqofdma):3:3);
    until key<>0;
    case key of
      103,71 : GoNumber;
      256+72 : Up;
      256+80 : Dn;
      256+77 : inc(xxx);
      256+75 : if xxx<>1 then dec(xxx);
      256+71 : xxx:=1;
      256+79 : xxx:=48;
      256+73 : PgUp;
      256+81 : PgDn;
      256+132 : TUp;
      256+118 : TDn;
      else quit:=true;
    end;
  until quit;
  dedit:=where;
end;

procedure PrintAt(x,y : byte; s : string);
var i : byte;
begin
  gotoxy(x,y);
  i:=1;
  while i<=length(s) do begin
    if s[i]='~' then begin
      textcolor(dcolor[1]);
      write(s[i+1]);
      inc(i);
    end else begin
      textcolor(dcolor[3]);
      write(s[i]);
    end;
    inc(i);
  end;
end;

procedure LoadData;
var ii,iii, doo : word;
    s, ss : string;
    a : pointer;
begin
  iii:=1;
  a:=@s;
  LoadEMS(1,'retezce.ems');
{  buffer:=buf;}
  maxrete:=sizeems[1]-1;
end;

function Ask(x,y : byte; s : string) : boolean;
var key : char;
begin
  Frame(x-1,y-1,length(s)+x,y+1,true);
  gotoxy(x,y);
  write(s);
  repeat
    key:=upcase(readkey);
  until (key='A')or(key='N')or(key=#27);
  if key='A'
    then ask:=true
    else ask:=false;
end;

function ReadString(x,y : byte; s : string) : string;
var ss : string;
begin
  Frame(x-1,y-1,length(s)+x+12,y+1,true);
  gotoxy(x,y);
  write(s);
  readln(ss);
  if ss='' then ss:=#27;
  readstring:=ss;
end;

function Find(s : string; w : word) : boolean;
var s2 : string;
    i1,i2 : byte;
    vysl : boolean;
begin
  vysl:=false;
  s2:=gettextems(1,w);
  for i1:=1 to length(s2)-length(s) do begin
    for i2:=1 to length(s) do
      if s2[i1+i2-1]<>s[i2] then break;
    if (i2=length(s))and(s2[i1+i2-1]=s[i2]) then begin
      vysl:=true;
      break;
    end;
  end;
  find:=vysl;
end;

function IsSAME(w1,w2 : word) : boolean;
var s1, s2 : string;
    i1 : byte;
begin
  IsSame:=false;
  s1:=gettextems(1,w1);
  s2:=gettextems(2,w2);
  for i1:=1 to length(s1) do
    if s2[i1]<>s1[i1] then break;
  if (i1=length(s1))and(s2[i1]=s1[i1]) then IsSame:=true;
end;


procedure Findtext;
var i : word;
    s : string;
begin
  gotoxy(1,1);
  s:=readstring(15,10,'Zadej hledany retezec: ');
  if s[1]=#27 then exit;
  for i:=there+1 to maxrete do if find(s,i) then begin where:=i; break end;
end;

procedure Play;
var s : longint;
begin
  StopDMA;
  if not endofdma then exit;
  if notclose then close(fileofsample);
  assign(fileofsample,name);
  reset(fileofsample,1);
  if ioresult<>0 then exit;
  s:=filesize(fileofsample);
  seek(fileofsample,$50); s:=s-$50;
  if ioresult<>0 then exit else begin
    PlayDMAFromFile(s,freqofDMA);
    notclose:=true;
  end;
end;

procedure Load;
var namee : string;
    s1,s2 : word;
    f1,f2 : file;
    buf : pointer;
begin
  namee:=loadfile(10,5,10,inputpath,pripona);
  if namee[1]=#27 then exit;
  assign(f1,namee);
  reset(f1,1);
  if ioresult<>0 then exit;
  assign(f2,name);
  rewrite(f2,1);
  if ioresult<>0 then exit;
  getmem(buf,65000);
  repeat
    blockread(f1,buf^,65000,s1);
    blockwrite(f2,buf^,s1,s2);
    writeln(filepos(f1));
  until (65000<>s2)or(s1<>65000);
  freemem(buf,65000);
  close(f2);
  close(f1);
end;

procedure Move;
var namee : string;
    s1,s2 : word;
    f1,f2 : file;
    buf : pointer;
begin
  namee:=loadfile(10,5,10,inputpath,pripona);
  if namee[1]=#27 then exit;
  assign(f1,namee);
  reset(f1,1);
  if ioresult<>0 then exit;
  assign(f2,name);
  rewrite(f2,1);
  if ioresult<>0 then exit;
  getmem(buf,65000);
  repeat
    blockread(f1,buf^,65000,s1);
    blockwrite(f2,buf^,s1,s2);
  until 65000<>s2;
  freemem(buf,65000);
  close(f2);
  erase(f1);
end;

procedure Kompilace;
var w : word;
    sizeall : longint;
    uk : longint;
    s : string;
    f, ff : file;
    pp : pointer;
    s1,s2, www : word;
    rrr : longint;
    now : word;
begin
  if not Ask(15,10,'Opravdu chces PROVEST KOMPILACI DAT? (A/N)') then exit;
  clrscr;
  getmem(pp,65000);
  uk:=0;
  sizeall:=0;
  assign(f,'cd.sam');
  rewrite(f,1);
  seek(f,sizeof(tab));
  for w:=1 to maxrete{300} do begin
    write(w,':');
    str(w,s);
    tab[w]:=uk+sizeof(tab);
    assign(ff,cesta+s+'.buf');
    reset(ff,1);
    if ioresult=0 then begin
      seek(ff,$50);
      rrr:=filesize(ff)-$50;
      inc(uk,rrr);
      inc(sizeall,rrr);
      repeat
        blockread(ff,pp^,65000,s1);
        blockwrite(f,pp^,s1,s2);
      until 65000<>s2;
      close(ff);
    end else write(#8#8'  '#13#10,w,'XXX');
  end;
  tab[w+1]:=uk+sizeof(tab);	{SR: 2006-06-18}
  for w:=w+2 to 8000 do tab[w]:=0;
  tab[0]:=sizeall;
  seek(f,0);
  blockwrite(f,tab,sizeof(tab));
  close(f);
  freemem(pp,65000);
  writeln(#13#10'Kompilace provedena!');
  readkey;
end;

procedure Tisk;
var w : word;
    s : string;
    f : text;
    tiskarna : boolean;
begin
  gotoxy(1,21); write(' ':399);
  PrintAt(1,25,'  ~Tiskarna  |  ~Soubor');
  repeat
    key:=readkeyy;
    case upcase(chr(key)) of
      'T' : begin
              tiskarna:=true;
              key:=1;
            end;
      'S' : begin
              tiskarna:=false;
              key:=1;
            end;
    end;
  until (key=27)or(key=1);
  if key=27 then exit;
  if not tiskarna then begin
    s:=readstring(15,10,'Zadej jmeno suboru do ktereho ma smerovat tisk: ');
    if s[1]=#27 then exit;
    assign(f,s);
    rewrite(f);
  end;
  for w:=1 to maxrete do begin
    str(w,s);
    s:=s+': '+gettextems(1,w);
    if tiskarna
      then writeln(lst,s)
      else writeln(f,s);
  end;
  if not tiskarna then close(f);
end;

procedure Insertt;
var w : word;
    s1,s2 : string;
    f : file;
begin
  if not Ask(15,10,'Opravdu chces posunout samply? (A/N)') then exit;
  for w:=maxrete downto there do begin
    str(w,s1);
    str(w+1,s2);
    s1:=cesta+s1+'.buf';
    s2:=cesta+s2+'.buf';
    assign(f,s1);
    rename(f,s2);
    if ioresult<>0 then continue; { nevim jestli je nutne, asi ne}
  end;
end;

procedure Deletee;
var w : word;
    f : file;
    s1, s2 : string;
begin
  if not Ask(15,10,'Opravdu chces posunout samply? (A/N)') then exit;
  for w:=there to maxrete do begin
    str(w+1,s1);
    str(w,s2);
    s1:=cesta+s1+'.buf';
    s2:=cesta+s2+'.buf';
    assign(f,s1);
    rename(f,s2);
    if ioresult<>0 then continue; { nevim jestli je nutne, asi ne}
  end;
end;

procedure Test;
var namee : string;
    i1, i2 : word;
  procedure savetest(i1,i2 : word);
  begin
  end;
begin
  namee:=readstring(5,10,'Zadej cestu a jmeno stareho souboru: ');
  if namee[1]=#27 then exit;
  LoadEMS(2,namee);
  for i1:=1 to maxrete do
    for i2:=i2 to sizeems[2]-1 do
      if issame(i1,i2) then SaveTest(i1,i2);
  DoneEMS(2);
end;

procedure LoadCFG;
var f : text;
begin
  dcolor[1]:=red;
  dcolor[2]:=white;
  dcolor[3]:=0;
  dcolor[4]:=green;
  assign(f,'msam.cfg');
  reset(f);
  readln(f,cesta);
  readln(f,inputpath);
  close(f);
end;

procedure SaveCFG;
var f : text;
begin
  assign(f,'msam.cfg');
  rewrite(f);
  writeln(f,cesta);
  writeln(f,inputpath);
  close(f);
end;

procedure MenuCFG;
begin
  repeat
    gotoxy(1,21); write(' ':399);
    PrintAt(1,25,'  ~Input path  |  ~Output path');
    key:=readkeyy;
    case UpCase(chr(byte(key))) of
      'I' : begin
              gotoxy(1,24); write(' ':79); gotoxy(1,24);
              write('Zadej vstupni cestu: ');
              readln(InputPath);
            end;
      'O' : begin
              gotoxy(1,24); write(' ':79); gotoxy(1,24);
              write('Zadej vystupni cestu: ');
              readln(cesta);
            end;
    end;
  until (key=27)or(key=13)or(key=256+45);
  SaveCFG;
end;

var Quitt : boolean;
    volume : byte;

begin
  if FindBlaster and ResetDSP then writeln('else ErrorMessage(''Neni Blaster'');');
  writeln('Adresa: ',BaseAddr,'        IRQ: ',SbIRQ,'         DMA: ',SbDMA);
  volumedsp(8*16+8);
  volume:=8;
  LoadCFG;
  textbackground(dcolor[2]);
  getmemdma(databufferdma);
  clrscr;
  key:=0;
  where:=1; page:=1;
  notclose:=false;
  Quitt:=false;
  LoadData;
  repeat
    PrintAt(1,25,' ~Load  ~Move  ~Play  ~Stop  ~Find  ~Go to l.  ~Config  Kompilace (~F~9)  ~Tisk  ~Konec');
    dcolor[3]:=blue;
    there:=Dedit(1,1,18,79,maxrete);
    case upcase(chr(lo(key))) of
      'P',' ' : Play;
      'L' : Load;
      'M' : Move;
      'F' : FindText;
      'K' : Quitt:=Ask(10,10,'Opravdu chces skoncit? (A/N)');
      'T' : Tisk;
      else begin
        if key=256+061 then Load else
        if key=256+067 then Kompilace else
        if key=256+82 then Insertt else
        if key=256+83 then Deletee else
        if (key=45)and(volume>0) then begin dec(volume); volumedsp(volume*16+volume); end else
        if (key=43)and(volume<15) then begin inc(volume); volumedsp(volume*16+volume); end else
        if (UpCase(chr(key))='C') then MenuCFG else
        if (chr(key)='S')or(chr(key)='s') then StopDMA else
        if (key=256+45)or(key=27) then Quitt:=Ask(10,10,'Opravdu chces skoncit? (A/N)') else
        writeln(#7);
      end;
    end;
  until Quitt;
  StopDMA;
  if notclose then close(fileofsample);
  FreeMemDMA(DataBufferDMA);
  DoneEMS(1);
end.
