{$A+,B-,D+,E-,F-,G+,I+,L+,N-,O-,P-,Q+,R+,S+,T-,V+,X+,Y+}
{$M 65520,0,655360}

{kompilátor her 3. verze}
program k3;
uses k3togeth,k3init,k3komp,k3zapis,k3ems,
     together,txt2iden,txt2comm,gpl2;

var mist:pseznammistnosti;              {všeobecné seznamy}
    obj:pseznamobjektu;
    ikon:pseznamikon;
    pov:pseznampovidacku;
    init:pinithry;
    {kod:pkod; společný kód neexistuje, jednotlivé kódy má každá ikona,
               objekt, místnost a rozhovor}
    ret,rozh,pal,hud,map:pseznamretezcu;
    pricistret:integer; {1000 (maxretezcu) řetězců je vyrovnávací paměť
                         stáčící tak akorát pro rozhovor, vždy se vyprázdní
                         a zde je počítadlo indexů (přičítadlo)}
    pocitret:longint;   {a zde je počítadlo pozic řetězců}
    soubret1:tpracsoubret1;      {řetězce se budou meziSAVovat do 2 souborů}
    soubret2:tpracsoubret2;

    ident:pident;                {gpl2 seznamy}
    maxident:byte;
    prik,talk:pprikaz;

begin
  writeln;
  writeln('Dragon History script compiler --- Robert Spalek, NoSense');
  nastavcesty;
  seznamovacikancelar(mist,obj,ikon,pov, init, ret,rozh,pal,hud,map,
    pricistret,pocitret,soubret1,soubret2);
  inicializujgpl2(ident,maxident, prik,talk);
  {nyní víme o všem, co je nadefinováno (vč. jmen animací),
   máme zkompilován init hry
   a máme inicializován gpl2}
  kompilujikony(ikon, obj, rozh,pal,hud,map,
    ret,pricistret,pocitret,soubret1,soubret2,
    ident,maxident, prik,talk);
  {nyní jsme úplně zkompilovali ikony, kromě obrázků, tam máme jen cestu}
  kompilujobjekty(obj, ikon,mist,init, rozh,pal,hud,map,
    ret,pricistret,pocitret,soubret1,soubret2,
    ident,maxident, prik,talk);
  {stejně tak máme zkompilovány objekty, kromě animací}
  kompilujmistnosti(mist, ikon,obj, rozh,pal,hud,map,
    ret,pricistret,pocitret,soubret1,soubret2,
    ident,maxident, prik,talk);
  {stejně tak máme zkompilovány objekty, kromě masek, map...}
  kompilujmluveni(pov);
  {nyní víme všechno o mluvících postavách}
  kompilujrozhovory(rozh, obj, rozh,pal,hud,map,
    ret,pricistret,pocitret,soubret1,soubret2,
    ident,maxident, prik,talk);
  {zapsaly se všechny rozhovory na disk, teď už je z logické části hry
   úplně všechno načteno, nyní to jen zapsat a zkompilovat bitmapy}
  zapisretezce(pricistret,pocitret,soubret1,soubret2);
  zapisikony(ikon,init);
  xxzapisobjekty(ikon,obj);
  zapismistnosti(ikon,obj,mist,init,pal,hud,map);
  zapisinit(init,obj,ikon,mist,pov,rozh);
  zapispovidacky(pov);
  {nyní se všechny výsledky kompilace zapsaly také na disk, vč. bitmap,
   které jsou při tom generovány}
  dealokujgpl2(ident, prik);
  dealokujseznamy(mist,obj,ikon,pov, init, ret,rozh,pal,hud,map);
  {uklidili jsme po sobě}

  {je-li ems, překonvertují se i další archívy než řetězce
   řetězce jediné se z historických důvodů a protože jich je HODNĚ
   ukládají do ems přímo}
{   konverzeemsdfwfajlu(vysoubsamanim);
    konverzeemsdfwfajlu(vysoubpalet);
    konverzeemsdfwfajlu(vysoubmasek);}
  konverzecd2sam(vysoubsamanim, jmvystupnicesty + 'cd2.sam');
end.

{luk: texty dát do 2-složkového dfw-fajlu!
        done
      dát tam všechno možné!
        todo
      kontrolovat duplicitu jmen při vytváření objektů
        todo
      příkaz na zavedení mapy (stejně jako třeba palety...)
        todo
      dealokovat seznamy ještě před bitmapovými operacemi
      paměť by mělo stačit na 30míst, 200obj, 300ik asi 322kb+třeba
      100kb na jiné seznamy a 200kb pro program ---> na 600kb volno to určitě
      pojede (zkusit!)
        todo}
