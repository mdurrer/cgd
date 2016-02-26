{Na vysvetlenou: tento unit byl nove zaveden diky tomu, ze sem si}
{nevedel rady s tim, kam zaradit funkci PosFrom. Je natolik obecna,}
{ze v animaci, pro kterou jsem ji potreboval, by byla jaksi navic;}
{nehodi se ani do graph256, vzdyt s grafikou prece nema nic spolecneho}
{Pri psani PosFrom jsem se inspiroval standardni pascalovskou funkci}
{Pos, ktera vyhleda pozici pod-retezce v retezci. Ma ale jeden maly}
{nedostatek: retezec vzdy prohledava od zacatku, a to neni ve vsech}
{pripadech to prave orechove, co chci. Takze sem napsal PosFrom, ktera}
{to prohledava od mnou urceneho znaku, navic v pripade neuspechu vraci}
{to, co ja chci, viz. comment u procedury}
{UNIT Extended se jmenuje prave tak, jak se jmenuje, proto, ze tedy}
{vlastne rozsiruje okruh standardnich pascalovskych proc. a fci}

unit Extended;
{rozsiruje moznosti standardnich procedur a funkci, moznosti}
{standardnich jednotek}

interface
function PosFrom(substr: string; s: char; pos: byte): byte;
{vyhleda pozici znaku  s  v retezci  substr ; retezec prohledava}
{od  pos -teho znaku v retezci. Neni-li  s  nalezen, vraci delku}
{retezce, cili pozici posledniho znaku}

implementation

function PosFrom(substr: string; s: char; pos: byte): byte;
{vyhleda pozici znaku  s  v retezci  substr ; retezec prohledava}
{od  pos -teho znaku v retezci. Neni-li  s  nalezen, vraci delku}
{retezce, cili pozici posledniho znaku}
var
  PosInString: byte;
begin
  PosInString:= pos;
  while (PosInString<Length(substr))and(substr[PosInString]<> s) do Inc(PosInString);
{  if (PosInString<>Length(substr))then }PosFrom:= PosInString
  {else PosFrom:= 0};
end;

begin
end.
