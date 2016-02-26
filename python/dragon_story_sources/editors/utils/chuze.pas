{dodelat :
 1) pri schodovite ceste zadat koeficient velikosti schodu
 2) nedivat se do smeru, ze ktereho jsme prisli
 3) kdyz se tam neda dojit, tak se analyzuje, ktery to je objekt a podle nej
    se zaridi na bud ze dojde po usecce k nemu (viz. zdi), nebo pujde
    danym smerem, dokud nenarazi na to, kam se da dojit (u domecku se pujde
    dolu a panacek tedy dojde vzdy pred domecek - to jen v pripade, ze nejde
    jit dovnitr; pokud jde, vleze tam);
    pozn. pokud tam nebude zadny objekt, tj. bude to na obrazku pozadi mimo
          masku podorysu, tak se podiva na tu stejnou moznost, ale ulozenou
          nikoliv v objektu, ale v pozadi}

{zvladnuto za 1/2 hodiny (nejprve asi 5minutovy pokus v assembleru, pak jsem
 si po 1. resetu rekl, ze to napisu v BP a pozdeji snad prepisu
 pak jsem jeste asi uhrnem 1/2-1 hodinu dodelaval, at je tam podle prani
   bud co nejmin, nebo co nejvic zatacek na trase panacka}
{pozn. vidite, ze je to O.K. a s tema 4 bodama ma lukas pravdu, vyhledavaci
       rychlost se ze4nasobi}

{there's a mistake : because the filling rountine is looking to its
 neigthbours in order north, sounth, west, ost, tak se pri fileni v sikmem
 potrubi sikmo doprva nahoru z bodu zleva dole naleneno na dolni stenu
 potrubi doprava nahoru nalepene take na dolni stenu potrubi pujde nahoru
 a potom doprava v 1 pravem uhlu, kdezto v opacnem smeru to pujde porad po
 hrbolate ceste tesne kolem dolni steny potrubi

 mozne reseni : podle toho, cemu dame prednost, prohazovat vychozi a cilovy
   bod, ale nejsou jen 2 smery, ale cele 4 kvadranty a krome toho to mozna
   zalezi na charakteru mistnosti !!!!!
 ale toto zase zklame v potrubi zatocenem do U, protoze v kazde jeho casti
   je to podle vyse uvedeneho bodu treba filit nejak jinak

 nebo !!!!! udelat fileni do 8 smeru !!!!! to jsem tam zrovna ted
   doprogramoval, ale o tom nemam zatim zadnou poznamku, ktera by toto
   vyvracela (ani potrvzovala); uz ji mam : nastane stejna chyba jako u vyse
   zmyneneho potrubi, pouze ale, kdyz je asi na 20 stupnu (polovina 45);
   ===> 8 smeru nic neresi !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 pozn. toto fileni umozni, ze pokud se muze panacek pohyboval 8 smery, tak
  se tak taky pohybovat bude (ve vhodnych pripadech) !!!!! fuj., viz. vyse

 ===> je potreba nejak upravit filici rutinu, aby filila nezubate (treba
   davat poradi jednotlivych smeru (sjzv vszj atp...) podle toho, odkud jsme
   se na ten bod dostali (dostali-li jsme se na nej zleva, pokracuje se
   nejprve doprava
 pozn. udelal jsem to a zda se, ze je to idealni reseni a funguje vsude !!!
 !!!!! HURRRAAA, ono se fakt zda, ze to funguje vsude !!!!!}
program testChuze;
uses crt,graph256;

const delta=4;
      rozmobd=5;

type SetByte=set of byte;
     {pword=^word;}
     ppole=^tpole;
     tpole=array[1..1000]of record
       x,y:integer
     end;

(*procedure chuze(x1,y1,x2,y2:integer; pocet:pword;pole:ppole);
  external;
  {$l chuze}*)

procedure chuze(X1,Y1,x2,y2:integer;
                var vyslpocet:integer;
                vysl:ppole);
type pbuf=^tbuf;
     tbuf=array[0..200*4-1]of record
       x,y:integer;
       smer:byte
{dodelal jsem tam ten test smeru}
     end;
                  {misto *2 je 2nasobek *4, protoze martin mares rikal, ze
                   staci y*2, ale to zjevne nestaci a zkusmo jsem urcil y*4;
                   nevim, zda je to obecne malo, nebo je to prehanane moc}
     pvysl=^tvysl;
     tvysl=array[1..10000] of record
       x,y,min:integer
     end;

var Buf:pbuf;
    {kruhovy buffer o rozmeru 2*mensi z rozmeru obrazovky o slozkach 0..1
     jako pole rozmeru X a Y}
    pole:pvysl;
    Cist,Zapisovat:integer;
    {ukazatele v kruhovem bufferu}
    konec,akt,x,y:integer;
    {ukazatel konce a aktualniho prvku v poli a aktivni x a y bodu}
    sm,aktsm:shortint;
    {uchovani from-smeru pro zapis noveho bodu a aktivni smer, kdetym jsme
     dojeli na tento bod}
    po2:boolean;
    {jedeme podruhe cyklus pro testovani sousedu ? kvuli tomu, ze je kruhovy
     s dynamickym pocatkem}

procedure ZkusBod(nX,nY:integer);
{zkusi, zda bod patri do vyplnovane oblasti a paklize ano, tak ho
 zaradi do bufferu}
var i:integer;
    b:byte;
begin
  b:=getpixel(nx,ny);
  if (nX>=0)and(nX<320) and
     (nY>=0)and(nY<200) and
     (b<>7)and(b<>20)
  then begin
  {zarad bod do seznamu pokracovacich bodu <===> je v obrazovce a neni uz
   vyplnen a neni to ani hranicni cara}
    Buf^[Zapisovat].x:=nX;
    Buf^[Zapisovat].y:=nY;
    Buf^[Zapisovat].smer:=sm;
    Zapisovat:=succ(Zapisovat) mod (400*2);
    {PutPixel(nX,nY,20);}
    line(x,y,nx,ny,20);
    {zapiseme dany bod taky do bufferu projitych bodu}
    inc(konec);
    pole^[konec].x:=nx;
    pole^[konec].y:=ny;
    pole^[konec].min:=akt;
  end
end;

begin
  new(buf);
  new(pole);
  Cist:=0;
  Zapisovat:=1;
  Buf^[0].x:=x1;
  Buf^[0].y:=y1;
  buf^[0].smer:=1;
  akt:=1;
  konec:=1;
  pole^[1].x:=x1;
  pole^[1].y:=x2;
  pole^[1].min:=0;
  PutPixel(x1,y1,20);
  {v bufferu je uveden seznam uz vyplnenych bodu, pri prochazeni uz se
   nezobrazuji, ale pouze se k nim vyhledaji sousede}

  while Cist<>Zapisovat do begin {dokud nevyprazdnime buffer}
    if (Buf^[Cist].x=x2)and(Buf^[Cist].y=y2) then
    {dosli jsme na konec}
      break;
    x:=Buf^[Cist].x;
    y:=Buf^[Cist].y;
    aktsm:=buf^[cist].smer;
    po2:=false;
    case aktsm of
      1{4}:begin
        sm:=1; ZkusBod(x,y-delta);    {horni bod}
        sm:=2; ZkusBod(x,y+delta);    {dolni bod}
        sm:=3; ZkusBod(x-delta,y);    {levy bod}
        sm:=4; ZkusBod(x+delta,y)     {pravy bod}
      end;
      2{1}:begin
        sm:=2; ZkusBod(x,y+delta);    {dolni bod}
        sm:=3; ZkusBod(x-delta,y);    {levy bod}
        sm:=4; ZkusBod(x+delta,y);    {pravy bod}
        sm:=1; ZkusBod(x,y-delta)     {horni bod}
      end;
      3{2}:begin
        sm:=3; ZkusBod(x-delta,y);    {levy bod}
        sm:=4; ZkusBod(x+delta,y);    {pravy bod}
        sm:=1; ZkusBod(x,y-delta);    {horni bod}
        sm:=2; ZkusBod(x,y+delta)     {dolni bod}
      end;
      4{3}:begin
        sm:=4; ZkusBod(x+delta,y);    {pravy bod}
        sm:=1; ZkusBod(x,y-delta);    {horni bod}
        sm:=2; ZkusBod(x,y+delta);    {dolni bod}
        sm:=3; ZkusBod(x-delta,y)     {levy bod}
      end
    {pokud chci vodorovne a svisle cary, nechat to, co je v zavorkach;
     pokud mi ale delaji naopak dobre sikme cary na 45 stupnu, tak to
     odzavorkovat, nebot u techto kombinaci se smer, odkud jsem prisel,
     netestuje jako 1., ale naopak jako posledni a to dava sanci sikmym
     caram a mam tedy sikme cary i bez fileni na 8 smeru !!!!!
pozn. mozna taky experimentovat jako : misto SJZV a jako kulatych rotaci dat
      SVJZ nebo SZJV a jeho kulate rotace (po/proti smeru hodinovych rucicek}
    end;
(*    ZkusBod(x-delta,y-delta); {4 sikme smery}
    ZkusBod(x+delta,y-delta);
    ZkusBod(x-delta,y+delta);
    ZkusBod(x+delta,y+delta);   {neni to vhodne} *)
    Cist:=succ(Cist) mod (400*2);
    inc(akt);
    {vezmeme z bufferu dalsi zkoumany bod a priradime si, ze ho zkoumame}
  end;
  if cist=zapisovat then {nenasli jsme}
    write(#7)
{mozna misto taho prijit na jeho nejblizsi hranici, i kdyz blizkost je tady
 vlastne dost relativni pojem a asi by to dalo poradne zabrat;
 krome toho si myslim, ze ostatni hry taky pri kliku, kde nic neni, tam
 odmitnou zajit a stoji (myslim, ze LOOOM); kazdopadne to prozkoumat !!!!!
 pozn. !!!!!
 GOOD IDEA !!!!! hra prece potrebuje vedet, kam se muze jit, aby mohla
   zmenit kursor mysi ===> po zapnuti mistnosti a po kazde zmene teto
   mistnosti se vyfili tato mistnost a zapise se do bitmapy delene po 4
   bodech (jako tady), kam se muze jit, bay se mohl dobre menit kursor
   mysi ===> hra zaregistruje klik a pohyb pouze tam, kde to jde ===> tady se
   o to strachovat nemusime a teoreticky bychom mohli odstranit i ten #7, ale
   pro ucely ladeni tam tuto moznost dat musim !!!!!
 pozn. naprosto souhlasim sLukasovym vzorkovanim po 4 (tady pri fileni, i pri
   uchovavani bitmapy pro testovani "doletu" mysi) !!!!!

 pozn. !!!!! uz vim, jak se zachovat, kdyz tam nejde dojit; budu mit prece
       k dispozici pole, kam se da a neda dojit, ktere bude vlastnit hra
       kvuli zmene kursoru mysi a preda mi ho, abych si to nemusel zbytecne
       fillit do lokalni promenne a ztracet tim cas a pamet; a ja se do toho
       pole podivam a kdyz se tam da dojit, o.k.; kdyz se tam neda dojit, tak
       povedu usecku od ciloveho do startovniho bodu, dokud se nedostane na
       bod, ke kteremu se da dojit; a tento bod budu povazovat za nejblissi
       a na nej dojdu
 !!!!! pozn. tato metoda ma jen 1 krpu, ktera se ale projevi malokdy;
       prdstavme si situaci : ja na Z, cil na V, mezi nama je bod po bodu zed
       (obrovska, treba i 100 bodu siroka; jedina cesta, co vede, je smerem
       na Z, kde se pak stoci na S a vrchem dojde daleko na V, kde se stoci
       k J a zpet na Z smerem k cili (takove obrovske C otoceny o 90 stupnu
       podle hodinek); pak jestlize kliknu na cil, dojde tam; pokud kliknu
       od cilu smerem na V, tak tam dojde taky; pokud ale kliknu nekde mezi
       cil a mne, ale strasne blizko u cile, tak se carovej algoritmus
       dostane az k me strane zdi a ja v podstate zustanu na miste;
 jinak je to ale genialni algoritmus a asi ho pouziju a toto je ojedinely
   pripad a stejne je sporne, akm by panacek vlastne v tomto pripade mel
   dojit a mozna ze podle zakonu logiky zdraveho rozumu je to, kam dojde,
   opravdu nejblizsi cil
 pozn. tak to pry meji delany nektere hry, nevim, to rikal Lukas}
  else begin {ano, vrat vhodne polozky z bufferu}
    vyslpocet:=0;
    repeat
      inc(vyslpocet);
      vysl^[vyslpocet].x:=pole^[akt].x;
      vysl^[vyslpocet].y:=pole^[akt].y;
      akt:=pole^[akt].min
    until pole^[akt].min=0
    {zpetne projdi seznam a vrat projitou cestu, ktera je mimochodem
     vyhybkami schvalne navzorkovana tak, aby v ni bylo co nejvic/nejmin
     zatacek !!!!!}
  end;
  dispose(pole);
  dispose(buf)
end;

var i:byte;
    mx,my:integer;
    pocet:integer;
    pole:ppole;
begin
  if not sti('e:\paint\picture\sipka.gcf','e:\paint\picture\mesto.pal','e:\user\fe\stand2.fon') then
    exit;
  initmouse;
  mouseon(3,0,mouseimage);
  setvisualpage(3);
  setactivepage(3);

(*  repeat                        {kliknout na vypln}
    repeat
    until mousekey<>0;
    if mousekey=1 then begin
      mx:=mousex;
      my:=mousey;
      repeat
      until mousekey=0;
      line(mx,my,mousex,mousey,7);
      line(mx-1,my,mousex-1,mousey,7);
      line(mx-2,my,mousex-2,mousey,7);
      line(mx-3,my,mousex-3,mousey,7);
      line(mx,my-1,mousex,mousey-1,7);
      line(mx,my-2,mousex,mousey-2,7);
      line(mx,my-3,mousex,mousey-3,7);
    end
  until mousekey=2; *)
  repeat
    if mousekey=1 then begin
      mouseswitchoff;
      bar(mousex,mousey,rozmobd,rozmobd,7);
      mouseswitchon
    end
  until mousekey=2;

  repeat
  until mousekey=0;
  repeat
  until mousekey=1;
  mx:=mousex;
  my:=mousey;
  repeat
  until mousekey=0;
  repeat
  until mousekey=1;

  new(pole);
  mouseswitchoff;               {vypln}
  chuze((mx div 4)*4,(my div 4)*4,
        (mousex div 4)*4,(mousey div 4)*4,pocet,pole);
  for pocet:=2 to pocet do
    line(pole^[pocet-1].x,pole^[pocet-1].y,
         pole^[pocet].x,pole^[pocet].y,40);
  mouseswitchon;
  dispose(pole);

  repeat
  until mousekey=0;
  repeat                        {kliknout na konec}
  until mousekey<>0;

  ste
  {pozn. HURRRAAA, hned pri 1. overeni MEMAVAIL jsem zjistil, ze je to dobre
         a vse se spravne alokuje i dealokuje !!!!!}
end.
