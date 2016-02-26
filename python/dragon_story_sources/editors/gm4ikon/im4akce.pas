{akce prováděné s místnostmi v gm4}

unit im4akce;
interface
uses im4cti;

function editujmistnost(var m:tseznammistnosti; idx:integer):boolean;
function pridejmistnost(var m:tseznammistnosti):boolean;
function smazmistnost(var m:tseznammistnosti; idx:integer):boolean;
{vrací: byl změněn?}
procedure viewmistnost(var m:tseznammistnosti; idx:integer);
procedure editujikonu(var m:tseznammistnosti; idx:integer);

implementation
uses crt,dos,
     graph256,graform,dialog,editor,files,
     im4toget;

function editujmistnost(var m:tseznammistnosti; idx:integer):boolean;
var d:pdialog;
    s:pstav;
    mist:tmistnost;
    ret,ret1,ret2:string;
    fx,fy,fpocet:integer;
begin
  alokujdialog(d,45,48,220,105, dcolor[2],dcolor[4],dcolor[5], false,true,false, false,false);
  alokujpredvoleny(s,4,1,1);
  nastavpocty(d,4,4,0,0,3);
  alokujnapis(d,1, 55,5, dcolor[1], font, 'Editování ikony');
  alokujnapis(d,2, 5,25, dcolor[1], font, 'Zkratka:');
  alokujnapis(d,3, 5,37, dcolor[1], font, 'Jméno:');
  alokujnapis(d,4, 5,49, dcolor[1], font, 'Obrázek:');
  alokujtlac(d,1, 170,49, dcolor[1],dcolor[3], font, 'Výběr');
  alokujtlac(d,2, 10,90, dcolor[1],dcolor[3], font, '~Uložit');
  alokujtlac(d,3, 70,90, dcolor[1],dcolor[3], font, '~Zrušit');
  alokujtlac(d,4, 130,90, dcolor[1],dcolor[3], font, '~Stand. cesty');
  alokujpocatecni_jednoduchyinput(d,s,1, 55,25,100, '', dcolor[1],dcolor[3], font,musibyttext, m.m[idx]^.symb);
  alokujpocatecni_jednoduchyinput(d,s,2, 55,37,100, '', dcolor[1],dcolor[3], font,musibyttext, m.m[idx]^.jm);
  alokujpocatecni_jednoduchyinput(d,s,3, 55,49,100, '', dcolor[1],dcolor[3], font,musibyttext, m.m[idx]^.obr);

  mouseswitchoff;
  setactivepage(1);
  nakreslidialog(d,s);
  setvisualpage(1);
  repeat
    vyberdialog(d,s);
    if (s^.ukakce in [0,2])and(s^.predvobj=4) then begin
      s^.input[3]^.edtext:=adresarikon+copy(s^.input[1]^.edtext,1,8)+'.gcf';
      smazdialog(d);
      nakreslidialog(d,s);
    end else if (s^.ukakce in [0,2])and(s^.predvobj=1) then begin
      fx:=10;
      fy:=10;
      fpocet:=16;
      if s^.input[s^.predvobj+2]^.edtext<>'' then
        ret1:=jencesta(s^.input[s^.predvobj+2]^.edtext)
      else
        ret1:=adresarikon;
      ret2:=maska;
      ret:=vybersouboru(fx,fy,fpocet, dcolor[1],dcolor[2],dcolor[3],dcolor[4],dcolor[5],font, trid_jmena,
        ret1,ret2);
      if (ret<>#0)and(ret<>#27) then begin
        s^.input[s^.predvobj+2]^.edtext:=fexpand(ret);
        smazdialog(d);
        nakreslidialog(d,s);
      end;
    end else
      break;
  until false;
  setvisualpage(2);
  smazdialog(d);

  if (s^.ukakce in [0,2])and(s^.predvobj=2) then begin
    mist.symb:=s^.input[1]^.edtext;
    mist.jm:=s^.input[2]^.edtext;
    mist.obr:=s^.input[3]^.edtext;
    zmenseznammistnosti(jmsoubmist,jmpomsoubmist,m,idx,mist);
    editujmistnost:=true;
  end else
    editujmistnost:=false;

  dealokujdialog(d,s);

  setvisualpage(2);
  setactivepage(2);
  mouseswitchon;
end;

function pridejmistnost(var m:tseznammistnosti):boolean;
var d:pdialog;
    s:pstav;
    mist:tmistnost;
    ret,ret1,ret2:string;
    fx,fy,fpocet:integer;
begin
  alokujdialog(d,45,48,220,105, dcolor[2],dcolor[4],dcolor[5], false,true,false, false,false);
  alokujpredvoleny(s,4,1,1);
  nastavpocty(d,4,4,0,0,3);
  alokujnapis(d,1, 55,5, dcolor[1], font, 'Přidávání ikony');
  alokujnapis(d,2, 5,25, dcolor[1], font, 'Zkratka:');
  alokujnapis(d,3, 5,37, dcolor[1], font, 'Jméno:');
  alokujnapis(d,4, 5,49, dcolor[1], font, 'Obrázek:');
  alokujtlac(d,1, 170,49, dcolor[1],dcolor[3], font, 'Výběr');
  alokujtlac(d,2, 10,90, dcolor[1],dcolor[3], font, '~Uložit');
  alokujtlac(d,3, 70,90, dcolor[1],dcolor[3], font, '~Zrušit');
  alokujtlac(d,4, 130,90, dcolor[1],dcolor[3], font, '~Stand. cesty');
  alokujpocatecni_jednoduchyinput(d,s,1, 55,25,100, '', dcolor[1],dcolor[3], font,musibyttext, '');
  alokujpocatecni_jednoduchyinput(d,s,2, 55,37,100, '', dcolor[1],dcolor[3], font,musibyttext, '');
  alokujpocatecni_jednoduchyinput(d,s,3, 55,49,100, '', dcolor[1],dcolor[3], font,musibyttext, '');

  mouseswitchoff;
  setactivepage(1);
  nakreslidialog(d,s);
  setvisualpage(1);
  repeat
    vyberdialog(d,s);
    if (s^.ukakce in [0,2])and(s^.predvobj=4) then begin
      s^.input[3]^.edtext:=adresarikon+copy(s^.input[1]^.edtext,1,8)+'.gcf';
      smazdialog(d);
      nakreslidialog(d,s);
    end else if (s^.ukakce in [0,2])and(s^.predvobj=1) then begin
      fx:=10;
      fy:=10;
      fpocet:=16;
      if s^.input[s^.predvobj+2]^.edtext<>'' then
        ret1:=jencesta(s^.input[s^.predvobj+2]^.edtext)
      else
        ret1:=adresarikon;
      ret2:=maska;
      ret:=vybersouboru(fx,fy,fpocet, dcolor[1],dcolor[2],dcolor[3],dcolor[4],dcolor[5],font, trid_jmena,
        ret1,ret2);
      if (ret<>#0)and(ret<>#27) then begin
        s^.input[s^.predvobj+2]^.edtext:=fexpand(ret);
        smazdialog(d);
        nakreslidialog(d,s);
      end;
    end else
      break;
  until false;
  setvisualpage(2);
  smazdialog(d);

 if (s^.ukakce in [0,2])and(s^.predvobj=2) then begin
    mist.symb:=s^.input[1]^.edtext;
    mist.jm:=s^.input[2]^.edtext;
    mist.obr:=s^.input[3]^.edtext;
    pridejdoseznamumistnosti(jmsoubmist,m,mist);
    pridejmistnost:=true;
  end else
    pridejmistnost:=false;

  dealokujdialog(d,s);

  setactivepage(2);
  setvisualpage(2);
  mouseswitchon;
end;

function smazmistnost(var m:tseznammistnosti; idx:integer):boolean;
begin
  if standardnidialog('Chceš opravdu smazat tuto ikonu?',
    dcolor[1],dcolor[2],dcolor[3],dcolor[4],dcolor[5],font,ano_ne)=1 then begin
    vymazzeseznamumistnosti(jmsoubmist,jmpomsoubmist,m,idx);
    smazmistnost:=true;
    setvisualpage(2);
    setactivepage(2);
    {potřeba dělat pouze zde, zeptá-li se na mazání masky a mapy}
  end else
    smazmistnost:=false;
end;

function loadonlygcfimage(var p:pwordarray; soub:string):byte;
var fi:file;
    rozm:array[0..1]of integer;
    del:word;
begin
  loadonlygcfimage:=0;
  if soub='' then
    exit;
  assign(fi,soub);
  {$i-} reset(fi,1); {$i+}
  if ioresult<>0 then exit;
  blockread(fi,rozm,4);{načte x a y}
  del:=word(rozm[0])*rozm[1];
  getmem(p,del+4);
  p^[0]:=rozm[0];
  p^[1]:=rozm[1];
  blockread(fi,p^[2],del);
  close(fi);
  loadonlygcfimage:=1;
end;

procedure viewmistnost(var m:tseznammistnosti; idx:integer);
var obr:pwordarray;
    x:byte;
begin
  x:=loadonlygcfimage(obr,m.m[idx]^.obr);
  if x<>1 then
    exit;

  mouseswitchoff;
  setactivepage(1);
  setpalette(palette);
  clearscr(0);
  putimage(0,0,obr);
  setvisualpage(1);

  repeat
  until keypressed or (mousekey<>0);
  while keypressed do
    readkey;
  repeat until mousekey=0;

  disposeimage(pointer(obr));

  setpalette(palette);
  setactivepage(2);
  setvisualpage(2);
  mouseswitchon;
end;

procedure editujikonu(var m:tseznammistnosti; idx:integer);
{přepne do 0. stránky, kam se může LOADovat obrázek, zvolíme si barvu
 pozadí a pak to filením vybrat}
type tview=record x1,y1,x2,y2:integer; end;
const nic:tview=(x1:1000;y1:1000;x2:-1000;y2:-1000);
var aktv:tview;
    akce:integer;
    zmena:boolean;
    ret:string;
    fx,fy,fpocet:integer;

procedure drawniview;
begin
  mouseswitchoff;
  with aktv do
    if x2<>-1000 then
      xorrectangle(x1,y1,x2-x1+1,y2-y1+1,255);
  mouseswitchon;
end;

procedure savniikonu;
var im:pbytearray;
    dx,dy,x,y:integer;
    fo:file;
    e:peditor;
    dir:dirstr; name:namestr; ext:extstr;
begin
  {umožní změnit cestu k ikoně}
  alokujeditor(e);
  nastavedokno(e,10,10,200,'Jméno ikony:',font,font,true);
  nastavedbarvy(e,dcolor[1],dcolor[2],dcolor[3],dcolor[5],dcolor[4],
    dcolor[5],dcolor[4]);
  nastavedprostredi(e,true,zadnerolovani,musibyttext,
    [#27],[],[#13],[]);
  nastavedparametry(e,true,true,true,false,false,false,254,
    standardnipovzn,[' ','\','/']);
  nastavedobsah(e,m.m[idx]^.obr,1,1);
  editacetextu(e);
  if e^.ukakce<>1 then begin
    dealokujeditor(e);
    exit;
  end else begin
    fsplit(e^.edtext,dir,name,ext);
    if ext='' then ext:='.gcf';
    e^.edtext:=dir+name+ext;
    m.m[idx]^.obr:=e^.edtext;
    dealokujeditor(e);
  end;

  if m.m[idx]^.obr='' then begin
    write(#7);
    exit;
  end else with aktv do
    if x2=-1000 then
      write(#7)
    else begin
      dx:=x2-x1+1;
      dy:=y2-y1+1;
      drawniview; {clear}
      mouseswitchoff;
      newimage(dx,dy,pointer(im));
      setactivepage(3);
      getimage(x1,y1,dx,dy,im);
      setactivepage(0);
      for x:=0 to dx-1 do
        for y:=0 to dy-1 do
          if im^[4+word(x)*dy+y]<>0 then
            im^[4+word(x)*dy+y]:=getpixel(x+x1,y+y1)
          else
            im^[4+word(x)*dy+y]:=255;
      assign(fo,m.m[idx]^.obr);
      {$i-} rewrite(fo,1); {$i+}
      if ioresult=0 then begin
        blockwrite(fo,im^,word(dx)*dy+4);
        close(fo);
      end else
        write(#7);
      disposeimage(pointer(im));
      drawniview;
      mouseswitchon;
      zmena:=false;
    end;
end;

procedure nactipozadi(ret:string);
var x:byte;
    obr:pointer;
begin
  if (ret<>#27)and(ret<>#0) then begin
    if obrpal<>nil then freemem(obrpal,768);
    if jenpripona(ret)='.GCF' then begin
      x:=loadonlygcfimage(pwordarray(obr),ret);
      obrpal:=nil;
    end else
      x:=loadimage(obr,pointer(obrpal),ret);
    if (x<>255)and(x<>1) then begin
      write(#7);
      exit;
    end;
    if x=1 then begin
      obrpal:=nil;
      setpalette(palette);
    end else
      setpalette(obrpal);
    mouseswitchoff;
    clearscr(barvapozadi);
    putimage(0,0,obr);
    disposeimage(obr);
    drawniview;
    zmena:=true;
    mouseswitchon;
  end
end;

procedure kliknutimasky(x,y:integer);
const mindelka=200;
var plnit:array[0..4*mindelka-1,1..2]of integer;
    cist,psat:integer;

procedure zapisbod(x,y:integer);
begin
  if (x>=0)and(x<320)and(y>=0)and(y<200)and(getpixel(x,y)<>barvapozadi) then begin
    {otestovat barvu pozadí tady a zda není vyfilen ve 3. videostránce}
    setactivepage(3);
    if getpixel(x,y)=0 then begin
      plnit[psat,1]:=x;
      plnit[psat,2]:=y;
      inc(psat); if psat=4*mindelka then psat:=0;
      if psat=cist then begin
        dec(psat);
        if psat=0 then psat:=4*mindelka;
      end else
        putpixel(x,y,1);
    end;
    setactivepage(0);
  end;
end;

begin
  drawniview;
  mouseswitchoff;
  cist:=0;
  psat:=1;
  plnit[0,1]:=x;
  plnit[0,2]:=y;
  setvisualpage(3); {budeme se dívat na průběh filení}
  if getpixel(x,y)<>barvapozadi then
    repeat
      x:=plnit[cist,1];
      y:=plnit[cist,2];
      inc(cist); if cist=4*mindelka then cist:=0;
      with aktv do begin
        if x<x1 then x1:=x;
        if y<y1 then y1:=y;
        if x>x2 then x2:=x;
        if y>y2 then y2:=y;
      end;
      zapisbod(x-1,y);
      zapisbod(x+1,y);
      zapisbod(x,y-1);
      zapisbod(x,y+1);
    until cist=psat;
  setvisualpage(0);
  drawniview;
  zmena:=true;
end;

begin
  mouseswitchoff;
  setactivepage(3); {zrušíme nastavení ve 3. stránce}
  clearscr(0);
  setactivepage(0);
  setvisualpage(0);
  if obrpal<>nil then
    setpalette(obrpal);
  aktv:=nic;
  zmena:=false;
  drawniview;
  fx:=10;
  fy:=10;
  fpocet:=16;
  mouseswitchon;
  repeat
    akce:=0;
    if keypressed then begin
      akce:=integer(readkey);
      if (akce=0)and keypressed then
        akce:=256+integer(readkey);
    end else if mousekey<>0 then
      akce:=800+mousekey;

    if (akce=27)or(akce>801)and(akce<820) then begin {esc, pravé --- konec}
      repeat until mousekey=0;
      if not zmena or (standardnidialog('Chceš opravdu skončit bez uložení?',
         dcolor[1],dcolor[2],dcolor[3],dcolor[4],dcolor[5],font,ano_ne)=1) then
        akce:=1000;
    end else if akce=8 then begin {vymaž rámeček}
      if aktv.x2<>-1000 then begin
        mouseswitchoff;
        setactivepage(3);
        clearscr(0);
        setactivepage(0);
        drawniview;
        aktv:=nic;
        zmena:=true;
        drawniview;
      end
    end else if akce=59+256 then begin {f1 - nápověda}
      standardnidialog('F1-help, pravé/Escape-konec|'+
        'F2/Enter-ulož ikonu|'+
        'F3-načti pozadí, F4-nastav barvu pozadí|'+
        'levé-označ OR-filením, BS-vymaž označené',
        dcolor[1],dcolor[2],dcolor[3],dcolor[4],dcolor[5],font,upozorneni);
    end else if (akce=13)or(akce=60+256) then {f2 ulož}
      savniikonu
    else if akce=61+256 then begin {f3}
      ret:=vybersouboru(fx,fy,fpocet, dcolor[1],dcolor[2],dcolor[3],dcolor[4],dcolor[5],font, trid_jmena,
        adresarobrazku,maska);
      nactipozadi(ret);
    end else if akce=62+256 then begin {f4 je klik na pozadí}
      standardnidialog('Klikni na pozadí kolem všech ikon',
        dcolor[1],dcolor[2],dcolor[3],dcolor[4],dcolor[5],font,upozorneni);
      repeat until mousekey<>0;
      if mousekey=1 then {levé tlačítko ---> výběr}
        barvapozadi:=getpixel(mousex,mousey);
      repeat until mousekey=0;
    end else if akce=801 then {kliknutí levým tlačítkem=výběr}
      kliknutimasky(mousex,mousey);
  until akce=1000;
  drawniview; {clear}

  repeat until mousekey=0;
  mouseswitchoff;
  setactivepage(2);
  setvisualpage(2);
  setpalette(palette);
end;

end.

{todo: !nutno nějak savnout zvolenou barvu mapy, ale to se vsákne...
       horší to bude s maskami; dát to na poč. vždycky na 15
       u masek dám colormask[i]=i
       !ale musím udělat i editaci priorit! nebo uděláme původní návrh,
TODO!  že priorita je barva masky (0..255), ale pro editaci je to možno
       změnit; příště to ale bude už zase colormak[i]=i, ale priority
       zůstanou... done
todo:  u masek možná udělat view s dírkováním
       ať nedělá stopu myši, u edit to fachá ---> vzít mouseswitchoff ztama
       dělá to blbosti, když v editu změním jméno ikony (a místnosti)!
       spravit loadimage u gcf bez palety konečně a dodělat loadonlyimage...

k3: udělat nápovědu na /? jako tady!}
