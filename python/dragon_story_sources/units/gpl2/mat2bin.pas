{převodník matematických výrazů z infixového do postfixového tvaru}

unit mat2bin;
interface
uses txt2iden;


{poradi: <jmeno>#0 priorita1 priorita2 <zprava> <cislo v kodu>
 priorita1 se zapíše do stacku
 priorita2 se porovnává se stackem před zápisem
 zprava: 0=vyhodnocuj zleva, 1=vyhodnocuj zprava, 2=funkce, levá závorka
         3=pravá závorka
         0,1 chce z obou stran číslo
         2 chce zleva operátor, zprava číslo
         3 chce zleva číslo, zprava operátor
         číslo chce z obou stran operátor
 vyšší priorita se vyhodnocuje dřív}
const operatory1:string='&'#0#9#9#0#1'&&'#0#9#9#0#1'AND'#0#9#9#0#1+
                        '|'#0#8#8#0#2'||'#0#8#8#0#2'OR'#0#8#8#0#2+
                        '^'#0#10#10#0#3'^^'#0#10#10#0#3'XOR'#0#10#10#0#3+
                        '='#0#15#15#0#4'=='#0#15#15#0#4'EQ'#0#15#15#0#4+
                        '<>'#0#15#15#0#5'!='#0#15#15#0#5'NE'#0#15#15#0#5+
                        '<'#0#15#15#0#6'LT'#0#15#15#0#6+
                        '>'#0#15#15#0#7'GT'#0#15#15#0#7+
                        '<='#0#15#15#0#8'LE'#0#15#15#0#8+
                        '>='#0#15#15#0#9'GE'#0#15#15#0#9+
                        '!'#0#16#16#2#1'NOT'#0#16#16#2#1+ {funkce!}
                        '('#0#6#20#2#30'['#0#6#20#2#30+ {chovají se jako funkce}
                        '{'#0#6#20#2#30+
                        ')'#0#5#5#3#31']'#0#5#5#3#31+
                        '}'#0#5#5#3#31+
{todo!}
                        #13#0#1#1#3#32+
                        #0;
      {příliš dlouhý 1 řetězec}
      operatory2:string='*'#0#9#9#0#10'TIMES'#0#9#9#0#10+{krát}
                        '/'#0#9#9#0#11'DIV'#0#9#9#0#11+{děleno}
                        '%'#0#9#9#0#12'MOD'#0#9#9#0#12+{zbytek}
                        '+'#0#8#8#0#13'PLUS'#0#8#8#0#13+{plus}
                        '-'#0#8#8#0#14'MINUS'#0#8#8#0#14+{mínus}
                        'NAHODA'#0#16#16#2#2'RANDOM'#0#16#16#2#2+
                        #0;
      operatory3:string='ISICOON'#0#16#16#2#3'ISACTICO'#0#16#16#2#4+
                        'ICOSTAT'#0#16#16#2#5'ACTICO'#0#16#16#2#6+
                        'ISOBJON'#0#16#16#2#7'ISOBJOFF'#0#16#16#2#8+
                        'ISOBJAWAY'#0#16#16#2#9+'OBJSTAT'#0#16#16#2#10+
                        #0;
      operatory4:string='LASTBLOCK'#0#16#16#2#11+'LAST'#0#16#16#2#11+
                        'ATBEGIN'#0#16#16#2#12+'BEG'#0#16#16#2#12+
                        'VARBLOCK'#0#16#16#2#13+
                        #0;
      operatory5:string='HASBEEN'#0#16#16#2#14+'BEEN'#0#16#16#2#14+
                        'MAXLINE'#0#16#16#2#15+'MAX'#0#16#16#2#15+
                        'ACTPHASE'#0#16#16#2#16+'CHEAT'#0#16#16#2#17+
                        #0;

      mozneznakyoperatoru:set of char=
        ['<','>','=','&','|','^','(',')','{','}','[',']','!',
         '*','/','%','+','-'];

      pricistza:array[0..3]of byte= (0,1,1,0);
      {při porovnávání stacku (0=zleva, 1=zprava, 2=funkce/(, 3=) )}

type tpostfix=array[1..100]of record
       co:{byte;}integer; {kód je formátován po integeru ---> musím}
       hodn:integer;
     end;
{co: 0=konec výrazu;
     1=číslo;
     2=operátor;
     3=funkce;
     3+X=identifikátor třídy X}

function mat2postfix(vyraz:string; ident:pident;
         var postfix:tpostfix;var kroku:integer):integer;

implementation
uses together;

procedure preskocmezery(ret:string;var idx:integer);
begin
  while (idx<=length(ret))and(ret[idx]=' ') do
    inc(idx);
end;

function mat2postfix(vyraz:string; ident:pident;
         var postfix:tpostfix;var kroku:integer):integer;
type tseznamoperatoru=record
       pocet:byte;
       o:array[1..100]of record
         j:string[30];
         pr1,pr2:byte;
         prave:byte;
         cislo:byte;
       end;
     end;
var stack:array[1..100,0..2]of byte; {číslo, priorita, typ}
    ocekava:byte; {0=číslo, 1=operátor}
    i,idx,delka,azdo:integer;
    zpracovano:boolean;
    chyba:integer;
    pom,cteno:string;
    oper:tseznamoperatoru;
    pomident:pident;

procedure pridejoperatory(operatory:string;var oper:tseznamoperatoru);
var idx:integer;
begin
  idx:=1;
  while operatory[idx]<>#0 do begin {inicializace pole operátorů}
    pom:='';
    while operatory[idx]<>#0 do begin pom:=pom+operatory[idx]; inc(idx); end;
    inc(oper.pocet);
    with oper.o[oper.pocet] do begin
      j:=pom;
      inc(idx); pr1:=byte(operatory[idx]);
      inc(idx); pr2:=byte(operatory[idx]);
      inc(idx); prave:=byte(operatory[idx]);
      inc(idx); cislo:=byte(operatory[idx]);
      inc(idx);
    end;
  end;
end;

procedure zpracujcislo;
begin
  if ocekava=1 then begin {očekává se operátor}
    chyba:=54;
    mat2postfix:=54;
    exit;
  end;
  inc(kroku);
  postfix[kroku].co:=1;
  if vyraz[idx]='-' then begin
    i:=1;
    inc(idx);
  end else
    i:=0;
  with postfix[kroku] do begin
    hodn:=0;
    while vyraz[idx]in cisla do begin
      hodn:=hodn*10+byte(vyraz[idx])-$30;
      inc(idx);
    end;
    if i=1 then
      hodn:=-hodn;
  end;
  ocekava:=1;
end;

(*
procedure zpracujnahodu;
begin
  inc(kroku);
  postfix[kroku].co:=3;
  preskocmezery(vyraz,idx);
  if not(vyraz[idx]in['0'..'9']) then begin
    chyba:=28;
    mat2postfix:=28;
    exit;
  end;
  with postfix[kroku] do begin
    hodn:=0;
    while vyraz[idx] in ['0'..'9'] do begin
      hodn:=hodn*10+byte(vyraz[idx])-$30;
      inc(idx);
    end;
{priradit hodnotu podle pozice bloku, prip. dalsi blok pridat!}
  end;
  preskocmezery(vyraz,idx);
  zpracovano:=true;
end;
*)

begin
  vyraz:=vyraz+#13;
  chyba:=0;
  oper.pocet:=0;
  pridejoperatory(operatory1,oper);
  pridejoperatory(operatory2,oper);
  pridejoperatory(operatory3,oper);
  pridejoperatory(operatory4,oper);
  pridejoperatory(operatory5,oper);
  delka:=0;
  kroku:=0;
  idx:=1;
  ocekava:=0;

  repeat {čteme, dokud není konec výrazu}
    preskocmezery(vyraz,idx);
    if vyraz[idx]in cisla then begin
    {-číslo se nebere ---> musí se použít 0-číslo}
      zpracujcislo;
      if chyba<>0 then
        exit;
      continue;
    end;
    cteno:='';
    if vyraz[idx]=#13 then begin
      cteno:=#13;
      inc(idx);
    end else if vyraz[idx]in znaky then
      while vyraz[idx]in znaky do begin
        cteno:=cteno+vyraz[idx];
        inc(idx);
      end
    else
      while (vyraz[idx]in mozneznakyoperatoru) do begin
        cteno:=cteno+vyraz[idx];
        inc(idx);
      end;

    azdo:=length(cteno);
    zpracovano:=false;
    while azdo>=1 do begin
      pom:=copy(cteno,1,azdo);
{      if (pom='NAHODA')or(pom='NAHODNE')or(pom='RANDOM') then begin
        zpracujnahodu;
        if chyba<>0 then
          exit;
        break;
      end else }if pom[1]in znaky then begin {identifikátor}
        pomident:=ident^.dalsi;
        while (pomident<>nil)and(pomident^.txt<pom) do
          pomident:=pomident^.dalsi;
        if pomident^.txt=pom then begin {nalezen identifikátor}
          if ocekava=1 then begin {očekává se operátor}
            mat2postfix:=55;
            exit;
          end;
          inc(kroku);
          postfix[kroku].co:=3+pomident^.trida;
          postfix[kroku].hodn:=pomident^.hodn;
          zpracovano:=true;
          ocekava:=1;
          break;
        end;
      end; {jinak je to operátor:}
      i:=1;
      while (i<=oper.pocet) do
        if pom=oper.o[i].j
          then break
          else inc(i);
      if i<=oper.pocet then
        break;
      dec(azdo);
    end;
    if azdo=0 then                              {nenalezeno}
      if (length(pom)>0)and(pom[1]in znaky) then begin
      {neznámý identifikátor}
        mat2postfix:=52;
        exit;
      end else begin {neznámý operátor}
        mat2postfix:=53;
        exit;
      end;
    dec(idx,length(cteno)-azdo);
    if zpracovano then continue;                   {uz bylo zpracovano}

    if ocekava=0 then begin {chce to číslo}
      case oper.o[i].prave of
        0,1:chyba:=56; {je tam operátor}
        2:; {je tam funkce/(, O.K., požedavek na číslo zůstane}
        3:if oper.o[i].pr1<>1 then
          chyba:=57 {pravá závorka}
        else
          chyba:=58; {konec výrazu}
      end;
    end else begin {chce to operátor}
      case oper.o[i].prave of
        0,1:ocekava:=0; {operátor, bude to chtít číslo}
        2:if oper.o[i].pr1<>6 then
          chyba:=59 {funkce}
        else
          chyba:=60; {levá závorka}
        3:; {pravá závorka, O.K., požadavek na operátor zůstane}
      end;
    end;
    if chyba<>0 then begin
      mat2postfix:=chyba;
      exit;
    end;
    while (delka>0)and(byte(stack[delka][1])>= {zapíšeme operátor}
           oper.o[i].pr2+pricistza[oper.o[i].prave]) do
      if stack[delka][0]<>30{'('} then begin
        inc(kroku);
        postfix[kroku].co:={2}stack[delka][2];
        postfix[kroku].hodn:=integer(stack[delka][0]);
        dec(delka);
      end else
        break;

    if oper.o[i].cislo<>31{')'} then begin
      inc(delka);
      stack[delka][0]:=oper.o[i].cislo;
      stack[delka][1]:=oper.o[i].pr1;
      if oper.o[i].prave=2 then {funkce}
        stack[delka][2]:=3
      else {operátor}
        stack[delka][2]:=2;
    end else
      if (delka>0)and(stack[delka][0]=30{'('}) then
        dec(delka);
  until idx>length(vyraz);

  inc(kroku); {přidá znak konce výrazu, to je lepší na uložení než před}
  postfix[kroku].co:=0; {to dát délku výrazu}
  postfix[kroku].hodn:=0;

  mat2postfix:=0; {bezchybné provedení}
end;

end.

{todo: slepě převzato a přebudováno ze staré verze ---> zkontrolovat
         o.k., done
       zabudovat kontrolu (závorky nevadí, ale hlavně správné pořadí)
         o.k., done
       podívat se do těch svých papírků na to, co jsem příp. zapomněl
         o.k., done

 player kódu --- dodělat
 přidat sem hrací funkce!}
