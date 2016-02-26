{akce prováděné s místnostmi v gm4}

unit mm4akce;
interface
uses mm4cti;

function editujmistnost(var m:tseznammistnosti; idx:integer):boolean;
function pridejmistnost(var m:tseznammistnosti):boolean;
function smazmistnost(var m:tseznammistnosti; idx:integer):boolean;
{vrací: byl změněn?}
procedure viewmistnost(var m:tseznammistnosti; idx:integer);
function editujmapu(var m:tseznammistnosti; idx:integer):boolean;
function editujmasku(var m:tseznammistnosti; idx:integer):boolean;

implementation
uses crt,dos,
     graph256,graform,dialog,editor,files,
     makeobj,mm4toget;

function editujmistnost(var m:tseznammistnosti; idx:integer):boolean;
var d:pdialog;
    s:pstav;
    mist:tmistnost;
    ret,ret1,ret2:string;
    fx,fy,fpocet:integer;
begin
  alokujdialog(d,45,48,220,105, dcolor[2],dcolor[4],dcolor[5], false,true,false, false,false);
  alokujpredvoleny(s,4,1,1);
  nastavpocty(d,6,6,0,0,5);
  alokujnapis(d,1, 55,5, dcolor[1], font, 'Editování místnosti');
  alokujnapis(d,2, 5,25, dcolor[1], font, 'Zkratka:');
  alokujnapis(d,3, 5,37, dcolor[1], font, 'Jméno:');
  alokujnapis(d,4, 5,49, dcolor[1], font, 'Pozadí:');
  alokujnapis(d,5, 5,61, dcolor[1], font, 'Masky:');
  alokujnapis(d,6, 5,73, dcolor[1], font, 'Mapy:');
  alokujtlac(d,1, 170,49, dcolor[1],dcolor[3], font, 'Výběr');
  alokujtlac(d,2, 170,61, dcolor[1],dcolor[3], font, 'Výběr');
  alokujtlac(d,3, 170,73, dcolor[1],dcolor[3], font, 'Výběr');
  alokujtlac(d,4, 10,90, dcolor[1],dcolor[3], font, '~Uložit');
  alokujtlac(d,5, 70,90, dcolor[1],dcolor[3], font, '~Zrušit');
  alokujtlac(d,6, 130,90, dcolor[1],dcolor[3], font, '~Stand. cesty');
  alokujpocatecni_jednoduchyinput(d,s,1, 55,25,100, '', dcolor[1],dcolor[3], font,musibyttext, m.m[idx]^.symb);
  alokujpocatecni_jednoduchyinput(d,s,2, 55,37,100, '', dcolor[1],dcolor[3], font,musibyttext, m.m[idx]^.jm);
  alokujpocatecni_jednoduchyinput(d,s,3, 55,49,100, '', dcolor[1],dcolor[3], font,musibyttext, m.m[idx]^.obr);
  alokujpocatecni_jednoduchyinput(d,s,4, 55,61,100, '', dcolor[1],dcolor[3], font,musibyttext, m.m[idx]^.mask);
  alokujpocatecni_jednoduchyinput(d,s,5, 55,73,100, '', dcolor[1],dcolor[3], font,musibyttext, m.m[idx]^.map);

  mouseswitchoff;
  setactivepage(1);
  nakreslidialog(d,s);
  setvisualpage(1);
  repeat
    vyberdialog(d,s);
    if (s^.ukakce in [0,2])and(s^.predvobj<=3) then begin
      fx:=10;
      fy:=10;
      fpocet:=16;
      if s^.input[s^.predvobj+2]^.edtext<>'' then
        ret1:=jencesta(s^.input[s^.predvobj+2]^.edtext)
      else case s^.predvobj of
        1:ret1:=adresarobrazku;
        2:ret1:=adresarmasek;
        3:ret1:=adresarmap;
      end;
      case s^.predvobj of
        1:ret2:='*.gcf;*.pcx;*.bmp;*.lbm';
        2:ret2:='*.msk';
        3:ret2:='*.map';
      end;
      ret:=vybersouboru(fx,fy,fpocet, dcolor[1],dcolor[2],dcolor[3],dcolor[4],dcolor[5],font, trid_jmena,
        ret1,ret2);
      if (ret<>#0)and(ret<>#27) then begin
        s^.input[s^.predvobj+2]^.edtext:=fexpand(ret);
        smazdialog(d);
        nakreslidialog(d,s);
      end;
    end else if (s^.ukakce in [0,2])and(s^.predvobj=6) then begin
      s^.input[4]^.edtext:=fexpand(jinapripona(s^.input[3]^.edtext,adresarmasek,maskamasek));
      s^.input[5]^.edtext:=fexpand(jinapripona(s^.input[3]^.edtext,adresarmap,maskamap));
      smazdialog(d);
      nakreslidialog(d,s);
    end else
      break;
  until false;
  setvisualpage(2);
  smazdialog(d);


  if (s^.ukakce in [0,2])and(s^.predvobj=4) then begin
    mist.symb:=s^.input[1]^.edtext;
    mist.jm:=s^.input[2]^.edtext;
    mist.obr:=s^.input[3]^.edtext;
    mist.mask:=s^.input[4]^.edtext;
    mist.map:=s^.input[5]^.edtext;
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
  nastavpocty(d,6,6,0,0,5);
  alokujnapis(d,1, 45,5, dcolor[1], font, 'Přidávání nové místnosti');
  alokujnapis(d,2, 5,25, dcolor[1], font, 'Zkratka:');
  alokujnapis(d,3, 5,37, dcolor[1], font, 'Jméno:');
  alokujnapis(d,4, 5,49, dcolor[1], font, 'Pozadí:');
  alokujnapis(d,5, 5,61, dcolor[1], font, 'Masky:');
  alokujnapis(d,6, 5,73, dcolor[1], font, 'Mapy:');
  alokujtlac(d,1, 170,49, dcolor[1],dcolor[3], font, 'Výběr');
  alokujtlac(d,2, 170,61, dcolor[1],dcolor[3], font, 'Výběr');
  alokujtlac(d,3, 170,73, dcolor[1],dcolor[3], font, 'Výběr');
  alokujtlac(d,4, 10,90, dcolor[1],dcolor[3], font, '~Uložit');
  alokujtlac(d,5, 70,90, dcolor[1],dcolor[3], font, '~Zrušit');
  alokujtlac(d,6, 130,90, dcolor[1],dcolor[3], font, '~Stand. cesty');
  alokujpocatecni_jednoduchyinput(d,s,1, 55,25,100, '', dcolor[1],dcolor[3], font,musibyttext, '');
  alokujpocatecni_jednoduchyinput(d,s,2, 55,37,100, '', dcolor[1],dcolor[3], font,musibyttext, '');
  alokujpocatecni_jednoduchyinput(d,s,3, 55,49,100, '', dcolor[1],dcolor[3], font,musibyttext, '');
  alokujpocatecni_jednoduchyinput(d,s,4, 55,61,100, '', dcolor[1],dcolor[3], font,musibyttext, '');
  alokujpocatecni_jednoduchyinput(d,s,5, 55,73,100, '', dcolor[1],dcolor[3], font,musibyttext, '');

  mouseswitchoff;
  setactivepage(1);
  nakreslidialog(d,s);
  setvisualpage(1);
  repeat
    vyberdialog(d,s);
    if (s^.ukakce in [0,2])and(s^.predvobj<=3) then begin
      fx:=10;
      fy:=10;
      fpocet:=16;
      if s^.input[s^.predvobj+2]^.edtext<>'' then
        ret1:=jencesta(s^.input[s^.predvobj+2]^.edtext)
      else case s^.predvobj of
        1:ret1:=adresarobrazku;
        2:ret1:=adresarmasek;
        3:ret1:=adresarmap;
      end;
      case s^.predvobj of
        1:ret2:='*.gcf;*.pcx;*.bmp;*.lbm';
        2:ret2:='*.msk';
        3:ret2:='*.map';
      end;
      ret:=vybersouboru(fx,fy,fpocet, dcolor[1],dcolor[2],dcolor[3],dcolor[4],dcolor[5],font, trid_jmena,
        ret1,ret2);
      if (ret<>#0)and(ret<>#27) then begin
        s^.input[s^.predvobj+2]^.edtext:=fexpand(ret);
        smazdialog(d);
        nakreslidialog(d,s);
      end;
    end else if (s^.ukakce in [0,2])and(s^.predvobj=6) then begin
      s^.input[4]^.edtext:=fexpand(jinapripona(s^.input[3]^.edtext,adresarmasek,maskamasek));
      s^.input[5]^.edtext:=fexpand(jinapripona(s^.input[3]^.edtext,adresarmap,maskamap));
      smazdialog(d);
      nakreslidialog(d,s);
    end else
      break;
  until false;
  setvisualpage(2);
  smazdialog(d);

  if (s^.ukakce in [0,2])and(s^.predvobj=4) then begin
    mist.symb:=s^.input[1]^.edtext;
    mist.jm:=s^.input[2]^.edtext;
    mist.obr:=s^.input[3]^.edtext;
    mist.mask:=s^.input[4]^.edtext;
    mist.map:=s^.input[5]^.edtext;
    pridejdoseznamumistnosti(jmsoubmist,m,mist);
    pridejmistnost:=true;
  end else
    pridejmistnost:=false;

  dealokujdialog(d,s);

  setactivepage(2);
  mouseswitchon;
end;

function smazmistnost(var m:tseznammistnosti; idx:integer):boolean;
begin
  if standardnidialog('Chceš opravdu smazat tuto místnost?',
    dcolor[1],dcolor[2],dcolor[3],dcolor[4],dcolor[5],font,ano_ne)=1 then begin
    vymazzeseznamumistnosti(jmsoubmist,jmpomsoubmist,m,idx);
    smazmistnost:=true;
    setvisualpage(2);
    setactivepage(2);
    {potřeba dělat pouze zde, zeptá-li se na mazání masky a mapy}
  end else
    smazmistnost:=false;
end;

procedure viewmistnost(var m:tseznammistnosti; idx:integer);
var obr,pal:pointer;
    x:byte;
begin
  x:=loadimage(obr,pal,m.m[idx]^.obr);
  if (x<>1)and(x<>255) then
    exit;

  mouseswitchoff;
  setactivepage(1);
  if x=255 then
    setpalette(pal);
  clearscr(0);
  putimage(0,0,obr);
  setvisualpage(1);

  repeat
  until keypressed or (mousekey<>0);
  while keypressed do
    readkey;
  repeat until mousekey=0;

  if x=255 then
    freemem(pal,768);
  disposeimage(obr);

  setpalette(palette);
  setactivepage(2);
  setvisualpage(2);
  mouseswitchon;
end;

function editujmapu(var m:tseznammistnosti; idx:integer):boolean;
var obr,pal:pointer;
    x,y:byte;
    map:pointer; delmap:word;
    fi:file;
    max,ted:longint; comax:byte;
begin
  editujmapu:=false;
  x:=loadimage(obr,pal,m.m[idx]^.obr);
  if (x<>1)and(x<>255) then
    exit;

  if m.m[idx]^.map='' then
    assign(fi,':::')
  else
    assign(fi,m.m[idx]^.map);
  {$i-} reset(fi,1); {$i+}
  if ioresult=0 then begin
    delmap:=filesize(fi);
    getmem(map,delmap);
    blockread(fi,map^,delmap);
    close(fi);
  end else begin
    delmap:=newmap(obr, roztecx,roztecy, map);
  end;

  mouseswitchoff;
  setactivepage(0);
  if x=255 then
    setpalette(pal);
  clearscr(0);
  putimage(0,0,obr);
  setvisualpage(0);

  colorgomap:=255{15}; {vyresetuji vždycky barvu}
  if x=255 then begin {hledej svetle misto}
    max:=0; comax:=0;
    for y:=0 to 255 do begin
      ted:=sqr(word(pbytearray(pal)^[y*3]));
      ted:=ted+sqr(word(pbytearray(pal)^[y*3+1]));
      ted:=ted+sqr(word(pbytearray(pal)^[y*3+2]));
      if ted>=max then begin
        max:=ted;
        comax:=y;
      end;
    end;
    if max<>0 then
      colorgomap:=comax;
  end;
  y:=editmap(0,0,obr,map);
  if y=1 then begin {uložit případné změny v mapě}
    {$i-} rewrite(fi,1); {$i+}
    if ioresult=0 then begin
      blockwrite(fi,map^,delmap);
      close(fi);
      editujmapu:=true;
    end else
      write(#7);
  end;

  freemem(map,delmap);
  if x=255 then
    freemem(pal,768);
  disposeimage(obr);

  setpalette(palette);
  setactivepage(2);
  setvisualpage(2);
  mouseswitchon;
end;

function editujmasku(var m:tseznammistnosti; idx:integer):boolean;
var obr,pal,mask:pointer;
    x,y:byte;
    delmask:word;
    fi:file;
begin
  editujmasku:=false;
  x:=loadimage(obr,pal,m.m[idx]^.obr);
  if (x<>1)and(x<>255) then
    exit;

  if m.m[idx]^.mask='' then
    assign(fi,':::')
  else
    assign(fi,m.m[idx]^.mask);
  {$i-} reset(fi,1); {$i+}
  if ioresult=0 then begin
    delmask:=filesize(fi); {možná je to image, ale kašlu na to...}
    getmem(mask,delmask);
    blockread(fi,mask^,delmask);
    close(fi);
    setactivepage(3);
    putimage(0,0,mask);
    disposeimage(mask);
    GetMem(ColorMask,SizeOf(ColorMask^));
    for y:=0 to 255 do
      colormask^[y]:=y; {vyresetuji vždycky barvy}
  end else begin
    newmask(obr); {vyresetuje za mě}
  end;

  mouseswitchoff;
  setactivepage(0);
  if x=255 then
    setpalette(pal);
  clearscr(0);
  putimage(0,0,obr);
  setvisualpage(0);

  y:=editmask(obr,pal,m.m[idx]^.symb);
  dcolor[1]:=15; {možná se remapovala paleta, vrátit ji zpět}
  dcolor[2]:=7;
  dcolor[3]:=12;
  dcolor[4]:=10;
  dcolor[5]:=8;
  if y=1 then begin {uložit případné změny v mapě}
    {$i-} rewrite(fi,1); {$i+}
    if ioresult=0 then begin
      setactivepage(3);
      newimage(320,200,mask);
      delmask:=320*200+4;
      getimage(0,0,320,200,mask);
      blockwrite(fi,mask^,delmask);
      close(fi);
      disposeimage(mask);
      editujmasku:=true;
    end else
      write(#7);
  end;

  disposemask;
  if x=255 then
    freemem(pal,768);
  disposeimage(obr);

  setpalette(palette);
  setactivepage(2);
  setvisualpage(2);
  mouseswitchon;
end;

end.

{todo: !nutno nějak savnout zvolenou barvu mapy, ale to se vsákne...
       horší to bude s maskami; dát to na poč. vždycky na 15
       u masek dám colormask[i]=i
       !ale musím udělat i editaci priorit! nebo uděláme původní návrh,
TODO!  že priorita je barva masky (0..255), ale pro editaci je to možno
       změnit; příště to ale bude už zase colormak[i]=i, ale priority
       zůstanou... done
todo:  u masek možná udělat view s dírkováním}
