program testgpl2;
uses txt2iden,txt2comm,gpl2,chyby;
var mem,max:longint;
    x:integer;

    fi:text;

    ident:pident;
    maxident:byte;
    prik,talk:pprikaz;

    kod:pkod;
    promenne:^integer;

    ret:pseznamretezcu;
    pomret:pseznampomretezcu;

procedure error(text:string);
begin
  writeln(text,#7);
  halt(1);
end;

{$f+}
procedure playgpl3(kod:pointer;odkud:integer;promenne:pointer);
  external;
function vypocetmatvyrazu(vyraz:pointer;odkud:integer;promenne:pointer):integer;
  external;
  {$l play3.obj}
{$f-}

var relativnigplskok:integer;

function _random(cis:integer):integer;
begin
  _random:=random(cis);
end;

procedure ahoj(cis:integer);
begin
  writeln('ahoj');
end;
procedure _goto(cis:integer);
begin
  relativnigplskok:=cis;
end;
procedure _if(podm,cis:integer);
begin
  if podm<>0 then
    relativnigplskok:=cis;
end;
procedure blb(cis,id:integer);
begin
  writeln('blb',cis,id);
end;
procedure _talk(obj,r:integer);
begin
  writeln(obj,' ',ret^.r[r]^);
end;

begin
  mem:=memavail;
  max:=maxavail;

  assign(fi,'pgm');
  {$i-} reset(fi); {$i+}
  if ioresult<>0 then
    error('nelze načíst program');

  x:=nactiidentifikatory('id',ident,maxident);
  if x<>0 then
    error(chybhlasky[x]);
  x:=nactiprikazy('jazyk',prik,talk, maxident);
  if x<>0 then
    error(chybhlasky[x]);

  getmem(promenne,2);
  promenne^:=3;

  getmem(kod,2+1000*sizeof(integer));
{  kod^.alok:=1000;}
  kod^.delka:=0;
  getmem(ret,2+100*sizeof(pstring));
{  ret^.alok:=100;}
  ret^.pocet:=0;
  getmem(pomret,2+100*(sizeof(pstring)+sizeof(integer)));
{  pomret^.alok:=100;}
  pomret^.pocet:=0;
  x:=gpl2kompiluj(fi,
               kod,
               ret,0,pomret,
               ident,maxident,
               prik,talk);
  if x<>0 then
    error(chybhlasky[x]);

  playgpl3(kod,1,promenne); {1 znamená začátek}
  randomize;
  writeln(vypocetmatvyrazu(kod,2,promenne));

  freemem(kod,2+1000*sizeof(integer));
  for x:=1 to ret^.pocet do
    freemem(ret^.r[x], length(ret^.r[x]^)+1);
  freemem(ret,2+100*sizeof(pstring));
  for x:=1 to pomret^.pocet do
    freemem(pomret^.r[x].r, length(pomret^.r[x].r^)+1);
  freemem(pomret,2+100*(sizeof(pstring)+sizeof(integer)));

  freemem(promenne,2);

  dealokujident_prik(ident,prik);
  close(fi);

  if (mem<>memavail)or(max<>maxavail) then
    write(#7);
end.
