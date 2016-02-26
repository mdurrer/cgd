unit dma;
interface

function  InitDMA(name1, name2 : string) : boolean;
function  PlayDMAString(w : word;freqofDMA : word;from_dubbing_file : boolean) : boolean;
procedure DoneDMA;

implementation

uses sblaster,texts,crt;

type tlongintarray= array[0..4001]of longint;
     {kuliva lenosti pri zjistovani delky to ma vo polozku vice}
     plongintarray= ^tlongintarray;
     tsoundevent= (speech, fx, nothing);

var samplename1, samplename2 : string;
    openfile : boolean;
    seektab: plongintarray;
    lastopened: tsoundevent;
    lastoccupiedspeech: integer;

function InitDMA;
var i: integer;
    notoccupied: longint;
begin
  samplename1:=name1;
  samplename2:=name2;
  lastopened:= nothing;
  if (BaseAddr<>0)and(SbNo<>255) then begin
    initDMA:=false;
    ResetDSP;
    if not getmemdma(dmabuffer) then exit;
    {nejdriv nacteme celou tabulku:}
    assign(samplefile,samplename1);
    reset(samplefile,1);
    if ioresult<>0 then exit;
{if filesize(samplefile)<14000000 then errormessage(19);}
    new(seektab);
    blockread(samplefile, seektab^, 4002*4);
    {zjistime obsazeni samplu:}
    {budeme predpokladat, ze posledni polozka neni obsazena...}
    notoccupied:= seektab^[4001]; i:= 4000;
    while(i>=0)and(seektab^[i]=notoccupied)do dec(i);
    {vezmeme to po i+1 polozku:}
    lastoccupiedspeech:= i+1;
    dispose(seektab);
    getmem(seektab, (lastoccupiedspeech+1)*4);
    seek(samplefile, 0);
    blockread(samplefile, seektab^, (lastoccupiedspeech+1)*4);

    openfile:=true;
    lastopened:= speech;
  end;
  initdma:=true;
end;


function PlayDMAString(w : word; freqofDMA : word;from_dubbing_file : boolean) : boolean;
var s1, s2 : longint;
begin
  PlayDMAString:=false;
  if (not from_dubbing_file)and(SampleType=1) then exit;
  if from_dubbing_file then SampleType:=1 else SampleType:=0;

  if (BaseAddr=0)or(SbNo=255) then begin
    sampletype:=0;
    exit;
  end;
  if from_dubbing_file then begin
    if lastopened<>speech then begin
      if openfile then close(samplefile);
      openfile:=false;
      assign(samplefile,samplename1);
      reset(samplefile,1);
      if ioresult<>0 then begin
        sampletype:=0;
        exit;
      end;
      openfile:=true;
      lastopened:= speech;
    end;
  end else begin
    if lastopened<>fx then begin
      if openfile then close(samplefile);
      openfile:=false;
      assign(samplefile,samplename2);
      reset(samplefile,1);
      if ioresult<>0 then begin
        sound(1000);
        sampletype:=0;
        exit;
      end;
      openfile:=true;
      lastopened:= fx;
    end;
  end;
  if from_dubbing_file then begin
    if lastoccupiedspeech<w then s1:= 0 else s1:= seektab^[w];
    s2:= seektab^[w+1];
  end else begin
    seek(samplefile,sizeof(longint)*w);
    blockread(samplefile,s1,sizeof(longint));
    blockread(samplefile,s2,sizeof(longint));
  end;
  if (s2-s1=0)or(s1=0)or(s2=0)or(ioresult<>0)then begin
   SampleType:= 0;
   exit;
  end;
  seek(samplefile,s1);
  PlayDMAFile(s2-s1,freqofDMA,from_dubbing_file);
  PlayDMAString:=true;
end;

procedure DoneDMA;
var nic : byte;
begin
  if (BaseAddr=0)or(SbNo=255) then exit;
  StopDMA;
  if openfile then close(samplefile);
  FreeMemDMA(DMABuffer);
  if lastoccupiedspeech>0 then freemem(seektab, (lastoccupiedspeech+1)*4);
  nic:=ioresult;
end;

begin
  openfile:=false;
end.
