{kompilátor ikon pro k3

 pozn. zbytek řádku se vždy ignoruje}

unit k3komp;
interface
uses k3togeth,
     together,chyby,txt2iden,txt2comm,gpl2,mat2bin;

procedure kompilujikony(
  var ikon:pseznamikon;
  var obj:pseznamobjektu;
  var seznrozh,seznpal,seznhud,seznmap:pseznamretezcu;
  var seznret:pseznamretezcu;
  var pricistret:integer;
  var pocitret:longint;
  var soubret1:tpracsoubret1;
  var soubret2:tpracsoubret2;
  ident:pident;
  maxident:byte;
  prik,talk:pprikaz);

procedure kompilujobjekty(
  var obj:pseznamobjektu;
  var ikon:pseznamikon;
  var mist:pseznammistnosti;
  inithry:pinithry;
  var seznrozh,seznpal,seznhud,seznmap:pseznamretezcu;
  var seznret:pseznamretezcu;
  var pricistret:integer;
  var pocitret:longint;
  var soubret1:tpracsoubret1;
  var soubret2:tpracsoubret2;
  ident:pident;
  maxident:byte;
  prik,talk:pprikaz);

procedure kompilujmistnosti(
  var mist:pseznammistnosti;
  var ikon:pseznamikon;
  var obj:pseznamobjektu;
  var seznrozh,seznpal,seznhud,seznmap:pseznamretezcu;
  var seznret:pseznamretezcu;
  var pricistret:integer;
  var pocitret:longint;
  var soubret1:tpracsoubret1;
  var soubret2:tpracsoubret2;
  ident:pident;
  maxident:byte;
  prik,talk:pprikaz);

procedure kompilujmluveni(
  var pov:pseznampovidacku);

procedure kompilujrozhovory(
  rozh:pseznamretezcu;
  obj:pseznamobjektu;
  var seznrozh,seznpal,seznhud,seznmap:pseznamretezcu;
  var seznret:pseznamretezcu;
  var pricistret:integer;
  var pocitret:longint;
  var soubret1:tpracsoubret1;
  var soubret2:tpracsoubret2;
  var ident:pident;
  var maxident:byte;
  prik,talk:pprikaz);

implementation
uses dos,
     bardfw;

procedure vyprazdniretezce(
  var seznret:pseznamretezcu;
  var pricistret:integer;
  var pocitret:longint;
  var soubret1:tpracsoubret1;
  var soubret2:tpracsoubret2);
{vyflusne obsah řetězcového bufferu do 2 pracovních fajlů}
var x:integer;
    pomret:string;
    i:byte;
begin
  if seznret^.pocet<>0 then begin
    for x:=1 to seznret^.pocet do begin
      pomret:=seznret^.r[x]^;
      for i:=1 to length(pomret) do
        if pomret[i]=#13 then
          pomret[i]:='|';
      pomret:=pomret+'|';

      if caddfrommemory(vysoubretezcu,@pomret,length(pomret)+1)
         <>pricistret+x then
        chyba('(internal) mismatched number when writing string '+pomret);
      blockwrite(soubret1,pocitret,sizeof(pocitret));
      blockwrite(soubret2,pomret[1],length(pomret));
      inc(pocitret,length(pomret));
      {zapíše pozici řetězce a řetězec do pracovních souborů}

      freemem(seznret^.r[x],length(seznret^.r[x]^)+1);
    end;
    inc(pricistret,seznret^.pocet);
    seznret^.pocet:=0;
    writeln('.stack of strings written to disk');
  end;
end;

procedure prevezmiretezcoveparametry(
  seznpomret:pseznampomretezcu;
  _kod:pkod;
  seznrozh,seznpal,seznhud,seznmap:pseznamretezcu;
  obj:pseznamobjektu);
{parametry v řetězcích typu 2-2 (palety, rozhovory a animace)
 překonvertuje na číselné odkazy a zaznamená je do seznamů
 (použito to stejné na 4 místech programu)}
var x,y:integer;
    ret:string;
begin
  {v seznpomret může být:
   a) animace
   b) jméno dialogu: příkaz číslo 9
   c) paleta: příkaz číslo 11}
  for x:=1 to seznpomret^.pocet do begin
    with seznpomret^.r[x] do
      case cis of {číslo příkazu}
        9:begin {jméno dialogu, najde v/přidá do seznamu}
          y:=najdivseznamuretezcu(seznrozh,true,inputpath(r^));
          _kod^.k[vyskyt]:=y; {přepíše to v kódu}
        end;
        11:begin {jméno palety, najde v/přidá do seznamu}
          y:=najdivseznamuretezcu(seznpal,true,inputpath(r^));
          _kod^.k[vyskyt]:=y; {přepíše to v kódu}
        end;
        18:begin {jmeno hudby}
          y:=najdivseznamuretezcu(seznhud,true,inputpath(r^));
          _kod^.k[vyskyt]:=y; {přepíše to v kódu}
        end;
        21:begin {jmeno mapy}
          y:=najdivseznamuretezcu(seznmap,true,inputpath(r^));
          _kod^.k[vyskyt]:=y; {přepíše to v kódu}
        end;
        else begin {jméno soukromé animace objektu}
          ret:=r^;
          uppercase(ret);
          y:=najdivseznamuretezcu(
            obj^.o[ _kod^.k[vyskyt-1] ]^.anim, {před tím je číslo objektu}
            false,ret);
          if y=0 then
            chyba('requested non-existent animation '+ret+' of object '+
              obj^.o[ _kod^.k[vyskyt-1] ]^.id)
          else begin {jinak to přepíše v kódu, vezme abs. číslo animace}
            _kod^.k[vyskyt]:=y+obj^.o[ _kod^.k[vyskyt-1] ]^.idxanim;
            inc(obj^.o[ _kod^.k[vyskyt-1] ]^.useanim^.h[y]);
          end; {zapíše, že byla animace použitá}
        end;
      end;
    freemem(seznpomret^.r[x].r,length(seznpomret^.r[x].r^)+1);
  end;
  seznpomret^.pocet:=0;
end;

procedure kompilujikony(
  var ikon:pseznamikon;
  var obj:pseznamobjektu;
  var seznrozh,seznpal,seznhud,seznmap:pseznamretezcu;
  var seznret:pseznamretezcu;
  var pricistret:integer;
  var pocitret:longint;
  var soubret1:tpracsoubret1;
  var soubret2:tpracsoubret2;
  ident:pident;
  maxident:byte;
  prik,talk:pprikaz);
var fi:text;
    cis:integer;
    x,y:integer;
    ret,slov:string;
    seznpomret:pseznampomretezcu;
    postfix:tpostfix;
    krokupostfix:integer;
    _kod:pkod;
begin
  otevrisouborcteni(jmsoubikon,fi);
  cis:=0;
  new(seznpomret);
  seznpomret^.pocet:=0;
  while not eof(fi) do begin
    readln(fi,ret);
    orizni(ret);
    if (ret='')or(ret[1]='{') then continue;
    slov:=slovo(ret);
    uppercase(slov);
    if slov='ICON' then begin {strukturu už jsme před tím prošli}
      if cis<>0 then
      with ikon^.i[cis] do begin
        if init=-1 then begin inc(kod^.delka); init:=kod^.delka; kod^.k[kod^.delka]:=0; end;
        if look=-1 then begin inc(kod^.delka); look:=kod^.delka; kod^.k[kod^.delka]:=0; end;
        if use=-1  then begin inc(kod^.delka); use :=kod^.delka; kod^.k[kod^.delka]:=0; end;
        if canuse=-1 then {canuse:=0;}{begin inc(kod^.delka); canuse:=kod^.delka; kod^.k[kod^.delka]:=0; end;} begin
          inc(kod^.delka);
          canuse:=kod^.delka;
          kod^.k[kod^.delka]:=1;
          inc(kod^.delka);
          kod^.k[kod^.delka]:=0;
          inc(kod^.delka);
          kod^.k[kod^.delka]:=0;
        end;
        if CADdfrommemory(pracprogramy,kod,2+kod^.delka*sizeof(integer))<>cis then
	  chyba('(internal) when temporarily writing the program of item '+id);
        freemem(kod,2+maxobjdelkakodu*sizeof(integer));
      end;
      inc(cis);
      with ikon^.i[cis] do begin
        title:=#0; {kontrola, aby se něco nedefinovalo dvakrát}
        init:=-1;
        look:=-1;
        use:=-1;
        canuse:=-1;
        iminit:=255;
        imlook:=255;
        imuse:=255;
        status:=255;
        obr:=#0;
        getmem(kod,2+maxobjdelkakodu*sizeof(integer));
        kod^.delka:=0;
        _kod:=kod;
      end;
    end else if cis=0 then
      chyba('definition of item body before ICON <item name> '+slov+' '+ret)
    else if slov='TITLE' then begin
      if ikon^.i[cis].title=#0 then
        ikon^.i[cis].title:=ret+'|'
      else
        chyba('multiple TITLE '+ret+' of item '+ikon^.i[cis].id)
    end else if (slov='INIT')or(slov='LOOK')or(slov='USE') then begin
      uppercase(ret);
      y:=byte(slovo(ret)='IMMEDIATELY'); {zbytek se ignoruje}
      x:=1; {chyba}
      if slov='INIT' then begin
        if ikon^.i[cis].init=-1 then begin
          x:=0; {bez chyby}
          ikon^.i[cis].init:=_kod^.delka+1;
          ikon^.i[cis].iminit:=y;
        end;
      end else if slov='LOOK' then begin
        if ikon^.i[cis].look=-1 then begin
          x:=0;
          ikon^.i[cis].look:=_kod^.delka+1;
          ikon^.i[cis].imlook:=y;
        end;
      end else if slov='USE' then begin
        if ikon^.i[cis].use=-1 then begin
          x:=0;
          ikon^.i[cis].use:=_kod^.delka+1;
          ikon^.i[cis].imuse:=y;
        end;
      end;
      if x=1 then
	chyba('multiple programs '+slov+' of item '+
          ikon^.i[cis].id);
      x:=gpl2kompiluj(fi,_kod,seznret,pricistret,seznpomret,ident,maxident,prik,talk);
      if x<>0 then chyba(chybhlasky[x]+' of item '+
	ikon^.i[cis].id+' and program '+slov);
      prevezmiretezcoveparametry(seznpomret,_kod,seznrozh,seznpal,seznhud,seznmap,obj);
      {parametry v řetězcích typu 2-2 (palety, rozhovory a animace)
       překonvertuje na číselné odkazy a zaznamená je do seznamů}
    end else if slov='CANUSE' then begin
      if ikon^.i[cis].canuse<>-1 then
        chyba('multiple CANUSE conditions of item '+
          ikon^.i[cis].id);
      uppercase(ret); {vzít matematický výraz, zkompilovat ho a zařadit do kódu}
      x:=mat2postfix(ret,ident,postfix,krokupostfix);
      if x<>0 then chyba(chybhlasky[x]+' of item '+ikon^.i[cis].id+
        ' of CANUSE condition');
      inc(_kod^.delka);
      ikon^.i[cis].canuse:=_kod^.delka;
      move(postfix,_kod^.k[_kod^.delka],krokupostfix*2*sizeof(integer)-2);
      inc(_kod^.delka,krokupostfix*sizeof(integer)-1-1);
    end else if slov='STATUS' then begin
      if ikon^.i[cis].status<>255 then
        chyba('multiple STATUS of item '+ikon^.i[cis].id);
      slov:=slovo(ret);
      uppercase(slov);
      if (slov='ON')or(slov='YES') then
        ikon^.i[cis].status:=1
      else if (slov='OFF')or(slov='NO') then
        ikon^.i[cis].status:=0
      else
        chyba('error when defining STATUS of item '+ikon^.i[cis].id);
    end else if slov='PICTURE' then begin
      if ikon^.i[cis].obr=#0 then
        ikon^.i[cis].obr:=inputpath(ret)
      else
        chyba('multiple PICTURE '+ret+' of item '+ikon^.i[cis].id);
    end else
      chyba('specified unknown property '+slov+' of item '+ikon^.i[cis].id);
  end;
  dispose(seznpomret);
  with ikon^.i[cis] do begin
    if init=-1 then begin inc(kod^.delka); init:=kod^.delka; kod^.k[kod^.delka]:=0; end;
    if look=-1 then begin inc(kod^.delka); look:=kod^.delka; kod^.k[kod^.delka]:=0; end;
    if use=-1  then begin inc(kod^.delka); use :=kod^.delka; kod^.k[kod^.delka]:=0; end;
    if canuse=-1 then {canuse:=0;}{begin inc(kod^.delka); canuse:=kod^.delka; kod^.k[kod^.delka]:=0; end;} begin
      inc(kod^.delka);
      canuse:=kod^.delka;
      kod^.k[kod^.delka]:=1;
      inc(kod^.delka);
      kod^.k[kod^.delka]:=0;
      inc(kod^.delka);
      kod^.k[kod^.delka]:=0;
    end;
    if CADdfrommemory(pracprogramy,kod,2+kod^.delka*sizeof(integer))<>cis then
      chyba('(internal) when temporarily writing the program of item '+id);
    freemem(kod,2+maxobjdelkakodu*sizeof(integer));
  end;
  if cis<>ikon^.pocet then
    chyba('(internal) mismatched number of items after compilation');
  for cis:=1 to ikon^.pocet do
    with ikon^.i[cis] do begin {překonvertujeme nezadané veličiny}
      if title=#0 then title:={id}'|';
(*      if init=-1 then begin inc(kod^.delka); init:=kod^.delka; kod^.k[kod^.delka]:=0; end;
      if look=-1 then begin inc(kod^.delka); look:=kod^.delka; kod^.k[kod^.delka]:=0; end;
      if use=-1  then begin inc(kod^.delka); use :=kod^.delka; kod^.k[kod^.delka]:=0; end;
      if canuse=-1 then {canuse:=0;}{begin inc(kod^.delka); canuse:=kod^.delka; kod^.k[kod^.delka]:=0; end;} begin
        inc(kod^.delka);
        canuse:=kod^.delka;
        kod^.k[kod^.delka]:=1;
        inc(kod^.delka);
        kod^.k[kod^.delka]:=0;
        inc(kod^.delka);
        kod^.k[kod^.delka]:=0;
      end; *)
      if iminit=255 then iminit:=0;
      if imlook=255 then imlook:=0;
      if imuse=255  then imuse:=0;
      if status=255 then status:=0;
      if obr=#0 then
        chyba('missing path to the picture of item '+ikon^.i[cis].id)
      else if not existujesoubor(obr) then
        chyba('cannot find file '+obr+' with picture of item '+ikon^.i[cis].id);
{      if CADdfrommemory(pracprogramy,kod,2+kod^.delka*sizeof(integer))<>cis then
        chyba('(internal) when temporarily writing the program of item '+id);
      freemem(kod,2+maxobjdelkakodu*sizeof(integer));}
    end;
  close(fi);
  writeln('compiled all item properties');
  vyprazdniretezce(seznret,pricistret,pocitret,soubret1,soubret2);
end;

procedure kompilujobjekty(
  var obj:pseznamobjektu;
  var ikon:pseznamikon;
  var mist:pseznammistnosti;
  inithry:pinithry;
  var seznrozh,seznpal,seznhud,seznmap:pseznamretezcu;
  var seznret:pseznamretezcu;
  var pricistret:integer;
  var pocitret:longint;
  var soubret1:tpracsoubret1;
  var soubret2:tpracsoubret2;
  ident:pident;
  maxident:byte;
  prik,talk:pprikaz);
var fi:text;
    cis:integer;
    x,y,ch:integer;
    valcis:longint;
    ret,slov:string;
    seznpomret:pseznampomretezcu;
    postfix:tpostfix;
    krokupostfix:integer;
    _kod:pkod;
    _ident:pident;
begin
  otevrisouborcteni(jmsoubobj,fi);
  cis:=0;
  new(seznpomret);
  seznpomret^.pocet:=0;
  while not eof(fi) do begin
    readln(fi,ret);
    orizni(ret);
    if (ret='')or(ret[1]='{') then continue;
    slov:=slovo(ret);
    uppercase(slov);
    if slov='OBJECT' then begin {strukturu už jsme před tím prošli}
      if cis<>0 then
      with obj^.o[cis]^ do begin
        if init=-1 then begin inc(kod^.delka); init:=kod^.delka; kod^.k[kod^.delka]:=0; end;
        if look=-1 then begin inc(kod^.delka); look:=kod^.delka; kod^.k[kod^.delka]:=0; end;
        if use=-1  then begin inc(kod^.delka); use :=kod^.delka; kod^.k[kod^.delka]:=0; end;
        if canuse=-1 then {canuse:=0;}{begin inc(kod^.delka); canuse:=kod^.delka; kod^.k[kod^.delka]:=0; end;} begin
          inc(kod^.delka);
          canuse:=kod^.delka;
          kod^.k[kod^.delka]:=1;
          inc(kod^.delka);
          kod^.k[kod^.delka]:=0;
          inc(kod^.delka);
          kod^.k[kod^.delka]:=0;
        end;
        if CADdfrommemory(pracprogramy,kod,2+kod^.delka*sizeof(integer))<>cis+ikon^.pocet then
          chyba('(internal) when temporarily writing the program of object '+id);
        freemem(kod,2+maxobjdelkakodu*sizeof(integer));
      end;
      inc(cis);
      with obj^.o[cis]^ do begin
        title:=#0; {kontrola, aby se něco nedefinovalo dvakrát}
        init:=-1;
        look:=-1;
        use:=-1;
        canuse:=-1;
        iminit:=255;
        imlook:=255;
        imuse:=255;
        status:=255;
        mistnost:=0;
        priorita:=255;
        {animace jsou už načteny a zkontrolovány}
        getmem(kod,2+maxobjdelkakodu*sizeof(integer));
        kod^.delka:=0;
        _kod:=kod;
        xuse:=-1;
        yuse:=-1;
        xlook:=-1;
        ylook:=-1;
        smerlook:=255;
        smeruse:=255;
      end;
      slov:=slovo(ret); {to je jméno objektu}
      slov:=slovo(ret); {to je příp. vlastnost objektu}
      uppercase(slov);
      if slov='' then
        obj^.o[cis]^.typ:=1 {nic}
      else if slov='LEFT' then
        obj^.o[cis]^.typ:=2
      else if slov='RIGHT' then
        obj^.o[cis]^.typ:=3
      else if slov='DOWN' then
        obj^.o[cis]^.typ:=4
      else if slov='UP' then
        obj^.o[cis]^.typ:=5
      else
        chyba('unknown object type '+obj^.o[cis]^.id);
    end else if cis=0 then
      chyba('definition of object body before OBJECT <object name> '+slov+' '+ret)
    else if slov='TITLE' then begin
      if obj^.o[cis]^.title=#0 then
        obj^.o[cis]^.title:=ret+'|'
      else
        chyba('multiple TITLE '+ret+' of object '+obj^.o[cis]^.id)
    end else if (slov='INIT')or(slov='LOOK')or(slov='USE') then begin
      uppercase(ret);
      y:=byte(slovo(ret)='IMMEDIATELY'); {zbytek se ignoruje}
      x:=1; {chyba}
      if slov='INIT' then begin
        if obj^.o[cis]^.init=-1 then begin
          x:=0; {bez chyby}
          obj^.o[cis]^.init:=_kod^.delka+1;
          obj^.o[cis]^.iminit:=y;
        end;
      end else if slov='LOOK' then begin
        if obj^.o[cis]^.look=-1 then begin
          x:=0;
          obj^.o[cis]^.look:=_kod^.delka+1;
          obj^.o[cis]^.imlook:=y;
        end;
      end else if slov='USE' then begin
        if obj^.o[cis]^.use=-1 then begin
          x:=0;
          obj^.o[cis]^.use:=_kod^.delka+1;
          obj^.o[cis]^.imuse:=y;
        end;
      end;
      if x=1 then
	chyba('multiple programs '+slov+' of object '+obj^.o[cis]^.id);
      x:=gpl2kompiluj(fi,_kod,seznret,pricistret,seznpomret,ident,maxident,prik,talk);
      if x<>0 then chyba(chybhlasky[x]+' in program '+slov+' of object '+obj^.o[cis]^.id);
      prevezmiretezcoveparametry(seznpomret,_kod,seznrozh,seznpal,seznhud,seznmap,obj);
      {parametry v řetězcích typu 2-2 (palety, rozhovory a animace)
       překonvertuje na číselné odkazy a zaznamená je do seznamů}
    end else if slov='CANUSE' then begin
      if obj^.o[cis]^.canuse<>-1 then
        chyba('multiple CANUSE conditions of object '+obj^.o[cis]^.id);
      uppercase(ret); {vzít matematický výraz, zkompilovat ho a zařadit do kódu}
      x:=mat2postfix(ret,ident,postfix,krokupostfix);
      if x<>0 then chyba(chybhlasky[x]+' in CANUSE condition of object '+obj^.o[cis]^.id);
      inc(_kod^.delka);
      obj^.o[cis]^.canuse:=_kod^.delka;
      move(postfix,_kod^.k[_kod^.delka],krokupostfix*2*sizeof(integer)-2);
      inc(_kod^.delka,krokupostfix*sizeof(integer)-1-1);
    end else if slov='STATUS' then begin
      if obj^.o[cis]^.status<>255 then
        chyba('multiple STATUS of object '+obj^.o[cis]^.id);
      slov:=slovo(ret);
      uppercase(slov);
      if (slov='ON')or(slov='YES') then
        obj^.o[cis]^.status:=0
      else if (slov='OFF')or(slov='NO') then
        obj^.o[cis]^.status:=1
      else if slov='AWAY' then
        obj^.o[cis]^.status:=2
      else
        chyba('error in STATUS of object '+obj^.o[cis]^.id);
    end else if slov='ROOM' then begin {definice domovské místnosti}
      slov:=slovo(ret); {načti jméno místnosti}
      uppercase(slov);
      if obj^.o[cis]^.mistnost<>0 then
        chyba('multiple ROOM '+slov+' of object '+obj^.o[cis]^.id);
      y:=1;
      while (y<=mist^.pocet)and(slov<>mist^.m[y].id) do
        inc(y);
      if y>mist^.pocet then
        chyba('unknown home location '+slov+' of object '+obj^.o[cis]^.id);
      obj^.o[cis]^.mistnost:=y;
    end else if slov='PRIORITY' then begin {definice priority}
      if obj^.o[cis]^.priorita<>255 then
        chyba('multiple PRIORITY '+ret+' of object '+obj^.o[cis]^.id);
      val(ret,valcis,ch);
      if (ch<>0)or(valcis<0)or(valcis>{200}254) then
        chyba('invalid PRIORITY '+ret+' of object '+obj^.o[cis]^.id);
      obj^.o[cis]^.priorita:=valcis;
    end else if slov='LOOKC' then begin {definice look-souradnic}
      if obj^.o[cis]^.smerlook<>255 then
        chyba('multiple LOOKC '+ret+' of object '+obj^.o[cis]^.id);
      slov:=slovo(ret);
      val(slov,valcis,ch); {x}
      if (ch<>0){or(valcis<0)or(valcis>319)} then
        chyba('invalid LOOKC-X '+ret+' of object '+obj^.o[cis]^.id);
      obj^.o[cis]^.xlook:=valcis;
      slov:=slovo(ret);
      val(slov,valcis,ch); {y}
      if (ch<>0){or(valcis<0)or(valcis>319)} then
        chyba('invalid LOOKC-Y '+ret+' of object '+obj^.o[cis]^.id);
      obj^.o[cis]^.ylook:=valcis;
      _ident:=ident^.dalsi;
      uppercase(ret); {smer}
      while (_ident<>nil)and(_ident^.txt<>ret) do
        _ident:=_ident^.dalsi;
      if (_ident=nil)or(_ident^.trida<>6) then
        chyba('invalid LOOKC-SMER '+ret+' of object '+obj^.o[cis]^.id);
      obj^.o[cis]^.smerlook:=_ident^.hodn;
    end else if slov='USEC' then begin {definice use-souradnic}
      if obj^.o[cis]^.smeruse<>255 then
        chyba('multiple USEC '+ret+' of object '+obj^.o[cis]^.id);
      slov:=slovo(ret);
      val(slov,valcis,ch); {x}
      if (ch<>0){or(valcis<0)or(valcis>319)} then
        chyba('invalid USEC-X '+ret+' of object '+obj^.o[cis]^.id);
      obj^.o[cis]^.xuse:=valcis;
      slov:=slovo(ret);
      val(slov,valcis,ch); {y}
      if (ch<>0){or(valcis<0)or(valcis>319)} then
        chyba('invalid USEC-Y '+ret+' of object '+obj^.o[cis]^.id);
      obj^.o[cis]^.yuse:=valcis;
      _ident:=ident^.dalsi;
      uppercase(ret); {smer}
      while (_ident<>nil)and(_ident^.txt<>ret) do
        _ident:=_ident^.dalsi;
      if (_ident=nil)or(_ident^.trida<>6) then
        chyba('invalid USEC-SMER '+ret+' of object '+obj^.o[cis]^.id);
      obj^.o[cis]^.smeruse:=_ident^.hodn;
(*      uppercase(ret); {smer}
      while (_ident<>nil)and(_ident^.txt<>ret) do
        _ident:=_ident^.dalsi;
      if (_ident=nil)or(_ident^.trida<>6) then
        chyba('invalid USEC-SMER '+ret+' of object '+obj^.o[cis]^.id);
      obj^.o[cis]^.smeruse:=_ident^.hodn;*)
    end else if slov='SEQ' then begin
    {seqence už byly kontrolovány a načteny v minulém průchodu}
    end else
      chyba('specified unknown property '+slov+' of object '+obj^.o[cis]^.id);
  end;
  dispose(seznpomret);
  with obj^.o[cis]^ do begin
    if init=-1 then begin inc(kod^.delka); init:=kod^.delka; kod^.k[kod^.delka]:=0; end;
    if look=-1 then begin inc(kod^.delka); look:=kod^.delka; kod^.k[kod^.delka]:=0; end;
    if use=-1  then begin inc(kod^.delka); use :=kod^.delka; kod^.k[kod^.delka]:=0; end;
    if canuse=-1 then {canuse:=0;}{begin inc(kod^.delka); canuse:=kod^.delka; kod^.k[kod^.delka]:=0; end;} begin
      inc(kod^.delka);
      canuse:=kod^.delka;
      kod^.k[kod^.delka]:=1;
      inc(kod^.delka);
      kod^.k[kod^.delka]:=0;
      inc(kod^.delka);
      kod^.k[kod^.delka]:=0;
    end;
    if CADdfrommemory(pracprogramy,kod,2+kod^.delka*sizeof(integer))<>cis+ikon^.pocet then
      chyba('(internal) when temporarily writing programs of object '+id);
    freemem(kod,2+maxobjdelkakodu*sizeof(integer));
  end;
  if cis<>obj^.pocet then
    chyba('(internal) missing number of objects after compilation');
  for cis:=1 to obj^.pocet do
    with obj^.o[cis]^ do begin {překonvertujeme nezadané veličiny}
      if title=#0 then title:={id}'|';
(*      if init=-1 then begin inc(kod^.delka); init:=kod^.delka; kod^.k[kod^.delka]:=0; end;
      if look=-1 then begin inc(kod^.delka); look:=kod^.delka; kod^.k[kod^.delka]:=0; end;
      if use=-1  then begin inc(kod^.delka); use :=kod^.delka; kod^.k[kod^.delka]:=0; end;
      if canuse=-1 then {canuse:=0;}{begin inc(kod^.delka); canuse:=kod^.delka; kod^.k[kod^.delka]:=0; end;} begin
        inc(kod^.delka);
        canuse:=kod^.delka;
        kod^.k[kod^.delka]:=1;
        inc(kod^.delka);
        kod^.k[kod^.delka]:=0;
        inc(kod^.delka);
        kod^.k[kod^.delka]:=0;
      end; *)
      if iminit=255 then iminit:=0;
      if imlook=255 then imlook:=0;
      if imuse=255  then imuse:=0;
      {typ byl naplněn při initu}
      if status=255 then status:=1; {off, kvůli away opačně než u ikonek}
      if mistnost=255 then
        chyba('missing home location of object '+obj^.o[cis]^.id);
        {objekt je buď ve své rodičovské místnosti nebo nikde, protože ho
         nelze pokládat a i animace jsou šity přesně na míru na dané
         souřadnice, proto taky ani souřadnice neexistují...}
      if (priorita=255)and(cis<>inithry^.hero) then
        chyba('missing priority of object '+obj^.o[cis]^.id+', which is not the hero object');
      {cestaanim atd... už bylo zkontrolováno}
      if xuse=-1 then begin
        xuse:=0;
        yuse:=0;
        smeruse:=0;
      end;
      if xlook=-1 then begin
        xlook:=0;
        ylook:=0;
        smerlook:=0;
      end;
      {mluvi už bylo taky načteno}
{      if CADdfrommemory(pracprogramy,kod,2+kod^.delka*sizeof(integer))<>cis+ikon^.pocet then
         chyba('(internal) when temporarily writing the program of object '+id);
      freemem(kod,2+maxobjdelkakodu*sizeof(integer));}
    end;
  close(fi);
  writeln('compiled all object properties');
  vyprazdniretezce(seznret,pricistret,pocitret,soubret1,soubret2);
end;

procedure kompilujmistnosti(
  var mist:pseznammistnosti;
  var ikon:pseznamikon;
  var obj:pseznamobjektu;
  var seznrozh,seznpal,seznhud,seznmap:pseznamretezcu;
  var seznret:pseznamretezcu;
  var pricistret:integer;
  var pocitret:longint;
  var soubret1:tpracsoubret1;
  var soubret2:tpracsoubret2;
  ident:pident;
  maxident:byte;
  prik,talk:pprikaz);
var fi:text;
    cis:integer;
    x,y,ch:integer;
    valcis:longint;
    ret,slov:string;
    seznpomret:pseznampomretezcu;
    postfix:tpostfix;
    krokupostfix:integer;
    _kod:pkod;
begin
  otevrisouborcteni(jmsoubmist,fi);
  cis:=0;
  new(seznpomret);
  seznpomret^.pocet:=0;
  while not eof(fi) do begin
    readln(fi,ret);
    orizni(ret);
    if (ret='')or(ret[1]='{') then continue;
    slov:=slovo(ret);
    uppercase(slov);
    if slov='ROOM' then begin {strukturu už jsme před tím prošli}
      if cis<>0 then
      with mist^.m[cis] do begin
        if init=-1 then begin inc(kod^.delka); init:=kod^.delka; kod^.k[kod^.delka]:=0; end;
        if look=-1 then begin inc(kod^.delka); look:=kod^.delka; kod^.k[kod^.delka]:=0; end;
        if use=-1  then begin inc(kod^.delka); use :=kod^.delka; kod^.k[kod^.delka]:=0; end;
        if canuse=-1 then {canuse:=0;}{begin inc(kod^.delka); canuse:=kod^.delka; kod^.k[kod^.delka]:=0; end;} begin
          inc(kod^.delka);
          canuse:=kod^.delka;
          kod^.k[kod^.delka]:=1;
          inc(kod^.delka);
          kod^.k[kod^.delka]:=0;
          inc(kod^.delka);
          kod^.k[kod^.delka]:=0;
        end;
        if CADdfrommemory(pracprogramy,kod,2+kod^.delka*sizeof(integer))<>cis+ikon^.pocet+obj^.pocet then
	  chyba('(internal) when temporarily writing the program of location '+id);
        freemem(kod,2+maxobjdelkakodu*sizeof(integer));
      end;
      inc(cis);
      with mist^.m[cis] do begin
        title:=#0; {kontrola, aby se něco nedefinovalo dvakrát}
        init:=-1;
        look:=-1;
        use:=-1;
        canuse:=-1;
        iminit:=255;
        imlook:=255;
        imuse:=255;
        obr:=#0;
        mus:=#0;
        mask:=#0;
        map:=#0;
        mouse:=255;
        hero:=255;
        persp0:=-100;
        perspstep:=-100;
        escroom:=255;
        gates:=0;
        for x:=1 to maxgatesmistnosti do
          gate[x]:=0;
        getmem(kod,2+maxobjdelkakodu*sizeof(integer));
        kod^.delka:=0;
        _kod:=kod;
      end;
    end else if cis=0 then
      chyba('definition of location body before ROOM <location name> '+slov+' '+ret)
    else if slov='TITLE' then begin
      if mist^.m[cis].title=#0 then
        mist^.m[cis].title:=ret+'|'
      else
        chyba('multiple TITLE '+ret+' of location '+mist^.m[cis].id)
    end else if (slov='INIT')or(slov='LOOK')or(slov='USE') then begin
      uppercase(ret);
      y:=byte(slovo(ret)='IMMEDIATELY'); {zbytek se ignoruje}
      x:=1; {chyba}
      if slov='INIT' then begin
        if mist^.m[cis].init=-1 then begin
          x:=0; {bez chyby}
          mist^.m[cis].init:=_kod^.delka+1;
          mist^.m[cis].iminit:=y;
        end;
      end else if slov='LOOK' then begin
        if mist^.m[cis].look=-1 then begin
          x:=0;
          mist^.m[cis].look:=_kod^.delka+1;
          mist^.m[cis].imlook:=y;
        end;
      end else if slov='USE' then begin
        if mist^.m[cis].use=-1 then begin
          x:=0;
          mist^.m[cis].use:=_kod^.delka+1;
          mist^.m[cis].imuse:=y;
        end;
      end;
      if x=1 then
	chyba('multiple programs '+slov+' of location '+mist^.m[cis].id);
      x:=gpl2kompiluj(fi,_kod,seznret,pricistret,seznpomret,ident,maxident,prik,talk);
      if x<>0 then chyba(chybhlasky[x]+' in program '+slov+' of location '
        +mist^.m[cis].id);
      prevezmiretezcoveparametry(seznpomret,_kod,seznrozh,seznpal,seznhud,seznmap,obj);
      {parametry v řetězcích typu 2-2 (palety, rozhovory a animace)
       překonvertuje na číselné odkazy a zaznamená je do seznamů}
    end else if slov='CANUSE' then begin
      if mist^.m[cis].canuse<>-1 then
        chyba('multiple CANUSE conditions of location '+mist^.m[cis].id);
      uppercase(ret); {vzít matematický výraz, zkompilovat ho a zařadit do kódu}
      x:=mat2postfix(ret,ident,postfix,krokupostfix);
      if x<>0 then chyba(chybhlasky[x]+' in CANUSE condition of location '
        +mist^.m[cis].id);
      inc(_kod^.delka);
      mist^.m[cis].canuse:=_kod^.delka;
      move(postfix,_kod^.k[_kod^.delka],krokupostfix*2*sizeof(integer)-2);
      inc(_kod^.delka,krokupostfix*sizeof(integer)-1-1);
    end else if slov='BACK' then begin {definice pozadí místnosti}
      if mist^.m[cis].obr=#0 then
        mist^.m[cis].obr:=inputpath(ret)
      else
        chyba('multiple BACK '+ret+' of location '+mist^.m[cis].id)
    end else if slov='MUSIC' then begin {definice hudby v místnosti}
      if mist^.m[cis].mus=#0 then
        mist^.m[cis].mus:=inputpath(ret)
      else
        chyba('multiple MUSIC '+ret+' of location '+mist^.m[cis].id)
    end else if slov='MASK' then begin {definice masek místnosti}
      if mist^.m[cis].mask=#0 then
        mist^.m[cis].mask:=inputpath(ret)
      else
        chyba('multiple MASK '+ret+' of location '+mist^.m[cis].id)
    end else if slov='MAP' then begin {definice mapy místnosti}
      if mist^.m[cis].map=#0 then
        mist^.m[cis].map:=inputpath(ret)
      else
        chyba('multiple MAP '+ret+' of location '+mist^.m[cis].id)
    end else if slov='HERO' then begin {je hrdina v místnosti?}
      slov:=slovo(ret);
      uppercase(slov);
      if mist^.m[cis].hero<>255 then
        chyba('multiple HERO '+slov+' of location '+mist^.m[cis].id);
      if (slov='ON')or(slov='YES') then
        mist^.m[cis].hero:=1
      else if (slov='OFF')or(slov='NO') then
        mist^.m[cis].hero:=0
      else
        chyba('invalid HERO '+slov+' of location '+mist^.m[cis].id);
    end else if slov='MOUSE' then begin {je myš v místnosti?}
      slov:=slovo(ret);
      uppercase(slov);
      if mist^.m[cis].mouse<>255 then
        chyba('multiple MOUSE '+slov+' of location '+mist^.m[cis].id);
      if (slov='ON')or(slov='YES') then
        mist^.m[cis].mouse:=1
      else if (slov='OFF')or(slov='NO') then
        mist^.m[cis].mouse:=0
      else
        chyba('invalid MOUSE '+slov+' of location '+mist^.m[cis].id);
    end else if slov='PERSP0' then begin {prespektiva na 1. řádku}
      slov:=slovo(ret);
      if mist^.m[cis].persp0<>-100 then
        chyba('multiple PERSP0 '+slov+' of location '+mist^.m[cis].id);
      val(slov,mist^.m[cis].persp0,ch);
{PP:zmena, persp0 muze byt i zaporna! neni taky duvod, proc ma byt <1!}
      if (ch<>0){or(mist^.m[cis].persp0<0)or(mist^.m[cis].persp0>1)} then
        chyba('invalid PERSP0 '+slov+' of location '+mist^.m[cis].id);
    end else if slov='PERSPSTEP' then begin {krok prespektivy}
      slov:=slovo(ret);
      if mist^.m[cis].perspstep<>-100 then
        chyba('multiple PERSPSTEP '+slov+' of location '+mist^.m[cis].id);
      val(slov,mist^.m[cis].perspstep,ch);
      if (ch<>0)or(mist^.m[cis].perspstep<0)or(mist^.m[cis].perspstep>1) then
        chyba('invalid PERSPSTEP '+slov+' of location '+mist^.m[cis].id);
    end else if slov='ESCROOM' then begin {definice escape místnosti}
      slov:=slovo(ret); {načti jméno místnosti}
      uppercase(slov);
      if mist^.m[cis].escroom<>255 then
        chyba('multiple ESCROOM '+slov+' of location '+mist^.m[cis].id);
      if slov='' then
        mist^.m[cis].escroom:=0
      else begin
        y:=1;
        while (y<=mist^.pocet)and(slov<>mist^.m[y].id) do
          inc(y);
        if y>mist^.pocet then
          chyba('invalid ESCROOM '+slov+' of location '+mist^.m[cis].id);
        mist^.m[cis].escroom:=y;
      end;
    end else if slov='GATE' then begin {definice gate číslo X místnosti}
      slov:=slovo(ret); {načti jméno místnosti}
      val(slov,valcis,ch);
      if (ch<>0)or(valcis<1)or(valcis>maxgatesmistnosti) then
        chyba('invalid GATE '+slov+' of location '+mist^.m[cis].id);
      if valcis>mist^.m[cis].gates then
        mist^.m[cis].gates:=valcis;
      if mist^.m[cis].gate[valcis]<>0 then
        chyba('multiple GATE '+slov+' of location '+mist^.m[cis].id);
      mist^.m[cis].gate[valcis]:=_kod^.delka+1;
      x:=gpl2kompiluj(fi,_kod,seznret,pricistret,seznpomret,ident,maxident,prik,talk);
      if x<>0 then chyba(chybhlasky[x]+' in GATE '+slov+' of location '
        +mist^.m[cis].id);
      prevezmiretezcoveparametry(seznpomret,_kod,seznrozh,seznpal,seznhud,seznmap,obj);
      {parametry v řetězcích typu 2-2 (palety, rozhovory a animace)
       překonvertuje na číselné odkazy a zaznamená je do seznamů}
    end else
      chyba('specified unknown property '+slov+' of location '+mist^.m[cis].id);
  end;
  dispose(seznpomret);
  with mist^.m[cis] do begin
    if init=-1 then begin inc(kod^.delka); init:=kod^.delka; kod^.k[kod^.delka]:=0; end;
    if look=-1 then begin inc(kod^.delka); look:=kod^.delka; kod^.k[kod^.delka]:=0; end;
    if use=-1  then begin inc(kod^.delka); use :=kod^.delka; kod^.k[kod^.delka]:=0; end;
    if canuse=-1 then {canuse:=0;}{begin inc(kod^.delka); canuse:=kod^.delka; kod^.k[kod^.delka]:=0; end;} begin
      inc(kod^.delka);
      canuse:=kod^.delka;
      kod^.k[kod^.delka]:=1;
      inc(kod^.delka);
      kod^.k[kod^.delka]:=0;
      inc(kod^.delka);
      kod^.k[kod^.delka]:=0;
    end;
    if CADdfrommemory(pracprogramy,kod,2+kod^.delka*sizeof(integer))<>cis+ikon^.pocet+obj^.pocet then
      chyba('(internal) when temporarily writing the program of location '+id);
    freemem(kod,2+maxobjdelkakodu*sizeof(integer));
  end;
  if cis<>mist^.pocet then
    chyba('(internal) mismatched number of locations after compilation');
  for cis:=1 to mist^.pocet do
    with mist^.m[cis] do begin {překonvertujeme nezadané veličiny}
      if gates=0 then
        chyba('location '+mist^.m[cis].id+' needs at least 1 GATE');
      for x:=1 to gates do
        if gate[x]=0 then
          chyba('GATEs of location '+mist^.m[cis].id+' do not form a sequence 1..N');
      if title=#0 then title:={id}'|';
(*      if init=-1 then begin inc(kod^.delka); init:=kod^.delka; kod^.k[kod^.delka]:=0; end;
      if look=-1 then begin inc(kod^.delka); look:=kod^.delka; kod^.k[kod^.delka]:=0; end;
      if use=-1  then begin inc(kod^.delka); use :=kod^.delka; kod^.k[kod^.delka]:=0; end;
      if canuse=-1 then {canuse:=0;}{begin inc(kod^.delka); canuse:=kod^.delka; kod^.k[kod^.delka]:=0; end;} begin
        inc(kod^.delka);
        canuse:=kod^.delka;
        kod^.k[kod^.delka]:=1;
        inc(kod^.delka);
        kod^.k[kod^.delka]:=0;
        inc(kod^.delka);
        kod^.k[kod^.delka]:=0;
      end; *)
      if iminit=255 then iminit:=0;
      if imlook=255 then imlook:=0;
      if imuse=255  then imuse:=0;
      if obr=#0 then
        chyba('undefined background of location '+mist^.m[cis].id+', needed at least for a palette')
      else if not existujesoubor(obr) then
        chyba('cannot find background '+obr+' of location '+mist^.m[cis].id);
      if (mus<>#0)and(not existujesoubor(mus)) then
        chyba('cannot find music '+mus+' of location '+mist^.m[cis].id);
      if (mask<>#0)and(not existujesoubor(mask)) then
        chyba('cannot find mask '+mask+' of location '+mist^.m[cis].id);
      if (map<>#0)and(not existujesoubor(map)) then
        chyba('cannot find map '+map+' of location '+mist^.m[cis].id);
      if mouse=255 then mouse:=1;
      if hero=255  then hero:=1;
      if (persp0=-100)and(perspstep=-100) then begin
        persp0:=1;
        perspstep:=0;
      end;
      if (persp0=-100)or(perspstep=-100) then
        chyba('perspective of location '+mist^.m[cis].id+' is non-empty but incomplete');
      if escroom=255 then escroom:=0;
      {(bill) gates je nutno vyplnit}
{      if CADdfrommemory(pracprogramy,kod,2+kod^.delka*sizeof(integer))<>cis+ikon^.pocet+obj^.pocet then
         chyba('(internal) when temporarily writing the program of location '+id);
      freemem(kod,2+maxobjdelkakodu*sizeof(integer));}
    end;
  close(fi);
  writeln('compiled all location properties');
  vyprazdniretezce(seznret,pricistret,pocitret,soubret1,soubret2);
end;

procedure kompilujmluveni(
  var pov:pseznampovidacku);
var fi:text;
    akt:integer; {zrovna se kompiluje postava}
    ret,slov:string;
    cis:longint;
    ch:integer;
begin
  otevrisouborcteni(jmsoubmluveni,fi);
  akt:=0; {zatím nikdo není definován}
  while not eof(fi) do begin
    readln(fi,ret);
    orizni(ret);
    uppercase(ret);
    if (ret='')or(ret[1]='{') then continue;
    slov:=slovo(ret);
    if slov='PERSON' then begin {další mluvící postava}
      inc(akt);
      with pov^.p[akt] do begin {inicializujeme proměnné postavy}
        x:=-1;
        y:=-1;
        barva:=-1;
      end;
    end else if akt=0 then {definice vlastnosti, aniž byla definována postava}
      chyba('definition of person body before PERSON <person name> '+slov+' '+ret)
    else if slov='X' then begin {X}
      if pov^.p[akt].x<>-1 then
        chyba('multiple X-position '+ret+' of person '+pov^.p[akt].id);
      val(ret,cis,ch);
      if (ch<>0)or(cis<0)or(cis>320) then
        chyba('invalid X-position '+ret+' of person '+pov^.p[akt].id);
      pov^.p[akt].x:=cis;
    end else if slov='Y' then begin {Y}
      if pov^.p[akt].y<>-1 then
        chyba('multiple Y-position '+ret+' of person '+pov^.p[akt].id);
      val(ret,cis,ch);
      if (ch<>0)or(cis<0)or(cis>200) then
        chyba('invalid Y-position '+ret+' of person '+pov^.p[akt].id);
      pov^.p[akt].y:=cis;
    end else if slov='FONCOLOR' then begin {barva písma}
      if pov^.p[akt].barva<>-1 then
        chyba('multiple color '+ret+' of person '+pov^.p[akt].id);
      val(ret,cis,ch);
      if (ch<>0)or(cis<0)or(cis>255) then
        chyba('invalid color '+ret+' of person '+pov^.p[akt].id);
      pov^.p[akt].barva:=cis;
    end else
      chyba('specified unknown property '+slov+' of person '+pov^.p[akt].id);
  end;
  for akt:=1 to pov^.pocet do begin {zkontrolujeme každou postavu}
    if (pov^.p[akt].x=-1)or(pov^.p[akt].y=-1) then
      chyba('missing speaking position of person '+pov^.p[akt].id);
    if pov^.p[akt].barva=-1 then
      chyba('missing speaking color of person '+pov^.p[akt].id);
  end; {načteme číslo další postavy}
  close(fi);
  writeln('compiled all person properties');
end;

procedure kompilujrozhovory(
  rozh:pseznamretezcu;
  obj:pseznamobjektu;
  var seznrozh,seznpal,seznhud,seznmap:pseznamretezcu;
  var seznret:pseznamretezcu;
  var pricistret:integer;
  var pocitret:longint;
  var soubret1:tpracsoubret1;
  var soubret2:tpracsoubret2;
  var ident:pident;
  var maxident:byte;
  prik,talk:pprikaz);
var x:integer;
    akt:integer;

 procedure kompilujrozhovor(soubor:string; cislo:integer; var akt:integer);
 {vraci pocet TITLU rozhovoru}
 var fi,fo:text;
     r:tseznamident;
     slov,ret,jm:string;
     x:integer;
     kod:pkod;
     postfix:tpostfix;
     delkapostfix:integer;
     seznpomret:pseznampomretezcu;
 begin
   nactiseznam(soubor,r,maxblokurozhovoru,'BLOCK','dialog blocks');
   otevrisouborcteni(pracsoubident2,fi);
   otevrisouborzapis(pracsoubident3,fo);
   while not eof(fi) do begin
     readln(fi,ret);
     writeln(fo,ret);
   end;
   close(fi);
{   writeln(fo);
   writeln(fo,'class 9'); } {to už tam je}
   for x:=1 to r.pocet do
     writeln(fo,r.i[x],' ',x);
   close(fo);
   dealokujidentifikatory(ident);
   x:=nactiidentifikatory(pracsoubident3,ident,maxident);
   if x<>0 then chyba(chybhlasky[x]+' in dialog '+soubor);
   {nyní máme přidány k identifikátorům i tyto nové}
   str(cislo,ret);
   jm:=vysoubrozhovoru+ret+'.dfw';
   smazsoubor(jm); {výstupní dfw soubor}
   otevrisouborcteni(soubor,fi);
   getmem(kod,2+maxdelkakodu*sizeof(integer));
   kod^.delka:=0;
   new(seznpomret);
   seznpomret^.pocet:=0;
   akt:=0;
   while not eof(fi) do begin
     readln(fi,ret);
     orizni(ret);
     uppercase(ret);
     if (ret='')or(ret[1]='{') then continue;
     slov:=slovo(ret);
     if slov='BLOCK' then begin {nový blok rozhovoru}
       slov:=slovo(ret); {slov=jméno bloku, známe, nezájem}
       x:=mat2postfix(ret,ident,postfix,delkapostfix);
       if x<>0 then chyba(chybhlasky[x]+' in condition '+
         ret+' of dialog '+soubor);
       caddfrommemory(jm,@postfix,delkapostfix*2*sizeof(integer));
       {zapíše se podmínka do dfw-fajlu}
       inc(akt);
     end else
       chyba('expecting definition of dialog block (BLOCK) '+soubor+
         ', not '+slov+' '+ret);

     if eof(fi) then
       chyba('expecting TITLE of dialog block '+soubor+', not end of file');
     readln(fi,ret);
     orizni(ret);
     slov:=slovo(ret);
     uppercase(slov);
     if slov<>'TITLE' then
       chyba('expecting TITLE of dialog block '+soubor+', not '+slov+' '+ret);
     ret:=ret+'|';
     caddfrommemory(jm,@ret,length(ret)+1); {zapíše se title do dfw-fajlu}

     x:=gpl2kompiluj(fi,kod,seznret,pricistret,seznpomret,ident,maxident,prik,talk);
     if x<>0 then chyba(chybhlasky[x]+' when compiling block '+r.i[akt]+
       ' of dialog '+soubor);
     prevezmiretezcoveparametry(seznpomret,kod,seznrozh,seznpal,seznhud,seznmap,obj);
     {parametry v řetězcích typu 2-2 (palety, rozhovory a animace)
      překonvertuje na číselné odkazy a zaznamená je do seznamů}

     if kod^.delka<>0
       then caddfrommemory(jm,@kod^.k[1],kod^.delka*sizeof(integer))
       else caddfrommemory(jm,@kod^.delka,1);
     {zapiš zkompilovaný kód do dfw-fajlu}
     kod^.delka:=0;
   end;
   dispose(seznpomret);
   freemem(kod,2+maxdelkakodu*sizeof(integer));
   close(fi);
   writeln('compiled dialog '+fsplit2(soubor,6));
   vyprazdniretezce(seznret,pricistret,pocitret,soubret1,soubret2);
 end;

begin
  x:=1;
  while x<=rozh^.pocet do begin {mohou postupně přibývat}
    kompilujrozhovor(rozh^.r[x]^,x,akt);
    freemem(rozh^.r[x],length(rozh^.r[x]^)+1); {zapiseme pocet TITLU}
    getmem(rozh^.r[x],2);
    rozh^.r[x]^[0]:=#1;
    rozh^.r[x]^[1]:=char(akt);
    inc(x);
  end;
  {nedealokovat řetězce
   misto jmen souboru v nich ted budou pocty jejich TITLU}
  dealokujidentifikatory(ident);
  x:=nactiidentifikatory(pracsoubident2,ident,maxident);
  if x<>0 then chyba(chybhlasky[x]+' after dialogs');
  {obnovit identifikátory}
end;

end.

{todo: možná ikony a objekty skladovat v paměti úplně stejně, když jsou
         stejné (ne, nejsou)
       v příkazech, kde je par. číslo, dát možnost i mat. výraz (např.
         míst souřadnic výraz podle akt. pozice, nebo třeba i ident. míst
         umožnit zadat jako výraz, tam totiž jde ident. míst taky použít)
       + ve výrazech budou věci jako PosledniBod a HrdinaX zavedeny, ale
         nebudou jako proměnné, ale jako ident. (á la on...) a mat.
         vyhodnocovač (on jediný se s nimi setká) je rozezná a doplní
       kontrola persp0 a perspstep je empirická (pod/nadtečení)
       gm4 ať při odvození cesty ka masce a mapě přepíše nejenom příponu,
         ale i cestu

TODO!: brat v uvahu Pavlovy `kidy': pridat | na konec titlu (done),
         mazat mezety v řetězcích (todo), není-li maska, tak brát
         z obrázku pozadí pouze paletu (todo), hudby povolit nova (cislo)
         nebo zustat stara (0)
       a vůbec! dávat #13 a ne |, když už to umí gpl2 (těžké), proč by to
         neměla umět animace4 (lehké)?
       zpracovat položky, které nebyly def., udělat tu reakci na nedefinici
         obrázku místnosti (nebo definici prázdného) --- že to pak nemá
         ani žádné masky...
       zkompilovat 2-průchodově rozhovory
       bacha na přetečení u rozhovorů a palet
- chtělo by to Linux, který každé vytečení z paměti striktně ohlásí}
