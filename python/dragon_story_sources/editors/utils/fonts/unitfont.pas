program MakeUnitFromFont;

uses crt,dos, prn256_3;

const
  txt1='unit ';
  txt2='interface';
  txt3='uses prn256_3;';
  txt4='var';
  txt5='_fon : _fontptr;';
  txt6='implementation';
  txt7='const fontarray : array[';
  txt8='0..';
  txt9=']of byte = (';
  txt10=');';
  txt11='begin';
  txt12='_fon:=@fontarray[0];FonWidth:=fontarray[0];FonHeight:=fontarray[1];end.';

var
  nazevfontu : string[7];
  unitfile : text;
  cesta : string;
  jake_file : SearchRec;
  hodnota : string;
  f : word;

function CheckPath(var path : string ):boolean;

var
   tecka : byte;                { pozice tecky v path and file name }

begin
{ Nejdriv najdu, kde je pripona - hledam tecku='.' }
   tecka := Pos('.', path );

  { Jestlize pripona neexistuje, pridam standartni '.fon' }
   if(tecka=0) then begin
      path := path+ '.fon';
      tecka := Pos('.', path );
      end;

  { V pripade, ze je pripona delsi>3znaky, zkratim ji }
   if(tecka < byte(path[0])-3) then byte(path[0]) := tecka+3;

   CheckPath := (Copy(path, tecka+1, 3) = 'fon');
end;

begin
     ClrScr;
     WriteLn('--- Makes unit from font ---  U N I T F O N T ---');
     WriteLn('');
     WriteLn('Type path and filename of .FON file...');
     ReadLn(cesta);
     if not(CheckPath(cesta)) then begin
        WriteLn('This isn''t a .FON file !');
        Halt;
     end;
     FindFirst(cesta, AnyFile, jake_file );
      if(DosError=0) then begin

      RegisterFont(Font, cesta);

      end else begin
        if(DosError=3) then WriteLn('Path not found.') else
         if(DosError=2)or(DosError=18)then WriteLn('File not found.')else
          WriteLn('DosError No. ', DosError );
        Halt;
      end;

     Write('Zadej nazev unitu:');
     ReadLn(nazevfontu);

{Zaregistrovani vystupniho text. souboru}
     Assign(unitfile, 'f'+nazevfontu+'.pas');
     Rewrite(unitfile);

     Write(unitfile, txt1);
     WriteLn(unitfile,'f'+nazevfontu+';');
     WriteLn(unitfile);
     WriteLn(unitfile, txt2);
     WriteLn(unitfile);
     WriteLn(unitfile, txt3);
     WriteLn(unitfile);
     WriteLn(unitfile, txt4);
     WriteLn(unitfile);

     Write(unitfile, nazevfontu);
     WriteLn(unitfile, txt5);
     WriteLn(unitfile);
     WriteLn(unitfile, txt6);
     WriteLn(unitfile);
     Write(unitfile, txt7);
     Write(unitfile, txt8);

     Str(FonWidth*FonHeight*138+141, hodnota);
     Write(unitfile, hodnota);
     WriteLn(unitfile, txt9);
     WriteLn(unitfile);

     for f:= 0 to (FonWidth*FonHeight*138+140) do begin
       Str(Font^[f], hodnota);
       WriteLn(unitfile, hodnota+',');
     end;
     Str(Font^[FonWidth*FonHeight*138+141], hodnota);
     WriteLn(unitfile, hodnota);

     WriteLn(unitfile, txt10);
     WriteLn(unitfile);
     WriteLn(unitfile, txt11);
     Write(unitfile, nazevfontu);
     WriteLn(unitfile, txt12);

     Close(unitfile);
end.
