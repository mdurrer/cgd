{udelat kontrolu chyb, at se to nehrouti na RangCheck (napr. backspace
 na pozici [1,1] atp...)}

{!!!!!!!!!!!!!!!!!!! je potreba neproporcionalni pismo, s proporcionalnim
 to jede taky, ale je to hnusny a nerucim za nasledky !!!!!!!!!!!!!!!!!

 co takhle nejak zobrazovat aktualni pozici v textu ????????????????

 Ctrl-W mi tady udela scrollovani a ja za nej nemam nahradu !!!!!!!

 bloky a find/replace !!!!!}

{$A+,B-,D+,E+,F+,G+,I+,L+,N+,O-,P-,Q+,R+,S+,T-,V+,X+,Y+}
{$M 16384,0,655360}

program TextovyEditor;
uses graph256,ted,dfw,users;
var ed:pted;
    newfont:pfont;
    delka:word;
    f : file;
    p : pointer;
begin
{  getMem(p,64000);
  Assign(f,'c:\autoexec.bat');
  reset(f,1);
  Blockread(f,p^,65500,delka);
  close(f);
  Deletefile('ted1.pas');
  CAddFromMemory('ted1.pas',p,delka);
  FreeMem(p,64000);}
  if not sti('..\units\mouse.gcf','..\units\test.pal','..\units\stand2.fon') then
    exit;
  initmouse;
  mouseon(3,0,mouseimage);

  {tady laboruji s novym fontem :}
  if registerfont(newfont,'..\units\if.fon') then
    exit;

  alokujtedokno(ed,10,20,150,100,6{sirka posuvniku},'Napiš něco :');
  nastavtedfontybarvy(ed,font,newfont,7,25,15,15,96,15);
  nastavtedkursor(ed,1,1,1,1,0);
  nactiDFWsoubor(ed,'ted1.pas',1);
  editujtext(ed);
  DeleteFile('ted1.pas');
  zapisDFWsoubor(ed,'ted1.pas');
  dealokujted(ed);

  {tady take laboruji s novym fontem :}
  FreeMem(NewFont, NewFont^[0]*NewFont^[1]*138+140 );
  fonwidth:=font^[0];
  fonheigth:=font^[1];
{udelat proceduru nastav fonheigth podle heigthoffont a stejne tak i pro
 width, prip. tyto promenne uplne zrusit, nebo aspon odstranit odkazy na ne
 anebo udelat, ze 1 font je aktivni a tam budou ulozeny odkazy na nej a nebo
 udelat, ze se uzivatel nebude o promenne typu pfont vubec starat a graph256
 bude mit spojovy seznam fontu a odkazovat se na ne bude cislem a kazdy font
 bude mit vlastni fonheigth atp...
 ===> tolik fontu, kolik si jich treba na zacatku zaregistruju, tolik jich
 budu mit (jako v bp)}

  ste
end.
