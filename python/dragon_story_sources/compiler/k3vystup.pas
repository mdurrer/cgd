{!!!!!!!!!!pavle: v initu hry je počet objektů už integer!!!!!!!!!!!!!!}

{definice výstupních recordů}

unit k3vystup;
interface
uses k3togeth;

type tvystikony=packed record
       init,look,use,canuse:integer;
       iminit,imlook,imuse:byte;
{       status:byte;
       obr:byte;}
       {odříznut id, obr--->byte,
        title a kod je jinde}
     end;

     tvystobjektu=packed record
       init,look,use,canuse:integer;
       iminit,imlook,imuse:byte;
       typ:byte; {walkdir}
{       status:byte;
       mistnost:byte;}
       priorita: byte;
       idxanim, pocanim: integer;
       {oříznut id, anim--->2 indexy,
        title a kod je jinde}
       xlook,ylook,xuse,yuse:integer;
       smerlook,smeruse:byte;
     end;

     TReal48=array [0..5] of byte;
     tvystmistnosti=packed record
{       GateProg: pointer;}
       Prog: pointer;
       ProgLen: word;
       Title: pointer;
       {***}
       mus,map,pal:byte;
       {startmasek,}pocmasek:integer;
       init,look,use,canuse:integer;
       iminit,imlook,imuse:byte;
       mouse,hero:byte;
       persp0,perspstep:TReal48;
       escroom:byte;
       gates:byte;
       gate:array[1..maxgatesmistnosti]of integer;
       {priormasek:array[1..maxpocetmasek]of byte;}
       {oříznut je id, mus/map--->2 indexy, obr/mas--->obrázky,
        title a kod je jinde}
     end;

     tvystinithry=packed record
{PP:}  ActualRoom: byte; {pro kompilator: startovni mistnost}
       map: byte;
       pocetobj, pocetikon{, pocetmist}: {byte!!!}integer;
       pocetprom: byte;
       pocetpostav,pocetrozh:byte;
       {odděláno stary, hero, gatestart, gatemap
        přidán pocetobj a pocetmist}
       imaxx,imaxy:integer;
       maxhud:word;
       crc:array[1..4]of word;
     end;

     tvystpovidacka=packed record
       x,y:integer;
       barva:byte;
       {oříznut je id}
     end;

     {used from Pavel}
     PAnimation= ^TAnimation;
     {popis animacnich sekvenci; pracuje s tim hlavne anmplay...}
     {takhle vypadajici animacni sekvence lezou z aomakera:}
     TAnmPhase= packed record
       Picture      : word;        {cislo obrazku ze skladu}
       X            : integer;     {souradnice x}
       Y            : integer;     {souradnice y}
       ZoomX        : word;        {zoom na ose x}
       ZoomY        : word;        {zoom na ose y}
       Mirror       : byte;        {0=normal, 1=zrcadlit obrazek}
       Sample       : word;        {cislo samplu ze skladu}
       Frequency    : word;        {frekvence samplu}
       Delay        : word;        {zdrzeni pred dalsi fazi}
     end;
     TAnmHeader= packed record
       NumOfPhases    : byte;      {pocet fazi animace}
       MemoryLogic    : byte;      {0=vsechny sprajty jsou v pameti (napr. chuze hlavniho hrdiny)
                                    1=v pameti vyhrazeno misto pro nejvetsi
                                      sprajt a vsechny sprajty se nacitaji
                                      prave do tohoto mista (napr. okno, ktere je nejdriv cele,
                                      pak se rozbiji a nakonec je rozbite)
                                    2=sprajty se pricitaji z disku (napr. jak se hl. hrdina
                                      pro neco shyba, neco pouziva...)}
       DisableErasing : byte;      {0=maze se pod, 1=nemaze se}
       Cyclic         : byte;      {0=zacit a skoncit, 1=cyklicka furt dokola}
       Relative       : byte;      {0=absolutni souradnice, 1=relativni}
     end;
     TAnmPhasesArray= packed array[1..255] of TAnmPhase;
     TAnimation= packed record
       Header         : TAnmHeader;
       Phase          : TAnmPhasesArray;
     end;

implementation

end.

{todo:
  title dat k programum; NE, když už je to dělené, tak na 3 složky!
možná:
  pov<>obj, ale možnost dát stejná jména
  složky animací neuvádět v ""}
