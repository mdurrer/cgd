program MakeUnitFromPalette;

uses crt,dos, tool256;

const
  txt1='unit ';
  txt2='interface';
  txt3='uses prn256_3;';
  txt4='var';
  txt5='_pal : _paletteptr;';
  txt6='implementation';
  txt7='const palarray : array[';
  txt8='0..';
  txt9=']of byte = (';
  txt10=');';
  txt11='begin';
  txt12='_pal:=@palarray[0];end.';

var
  nazevpalety : string[7];
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

  { Jestlize pripona neexistuje, pridam standartni '.pal' }
   if(tecka=0) then begin
      path := path+ '.pal';
      tecka := Pos('.', path );
      end;

  { V pripade, ze je pripona delsi>3znaky, zkratim ji }
   if(tecka < byte(path[0])-3) then byte(path[0]) := tecka+3;

   CheckPath := (Copy(path, tecka+1, 3) = 'pal');
end;

begin
     ClrScr;
     WriteLn('--- Makes unit from palette ---  U N I T P A L ---');
     WriteLn('');
     WriteLn('Type path and filename of .PAL file...');
     ReadLn(cesta);
     if not(CheckPath(cesta)) then begin
        WriteLn('This isn''t a .PAL file !');
        Halt;
     end;
     FindFirst(cesta, AnyFile, jake_file );
      if(DosError=0) then begin
           New(paleta);
           Assign(workfile,cesta);
           Reset(workfile,768);
           Seek(workfile, 0);
           BlockRead(workfile, paleta^[0], 1);
           Close(workfile);

      end else begin
        if(DosError=3) then WriteLn('Path not found.') else
         if(DosError=2)or(DosError=18)then WriteLn('File not found.')else
          WriteLn('DosError No. ', DosError );
        Halt;
      end;

     Write('Zadej nazev unitu:');
     ReadLn(nazevpalety);

{Zaregistrovani vystupniho text. souboru}
     Assign(unitfile, 'p'+nazevpalety+'.pas');
     Rewrite(unitfile);

     Write(unitfile, txt1);
     WriteLn(unitfile,'f'+nazevpalety+';');
     WriteLn(unitfile);
     WriteLn(unitfile, txt2);
     WriteLn(unitfile);
     WriteLn(unitfile, txt3);
     WriteLn(unitfile);
     WriteLn(unitfile, txt4);
     WriteLn(unitfile);

     Write(unitfile, nazevpalety);
     WriteLn(unitfile, txt5);
     WriteLn(unitfile);
     WriteLn(unitfile, txt6);
     WriteLn(unitfile);
     Write(unitfile, txt7);
     Write(unitfile, txt8);


     for f:= 0 to 766 do begin
       Str(paleta^[f], hodnota);
       WriteLn(unitfile, hodnota+',');
     end;
     Str(paleta^[f+1], hodnota);
     WriteLn(unitfile, hodnota);

     WriteLn(unitfile, txt10);
     WriteLn(unitfile);
     WriteLn(unitfile, txt11);
     Write(unitfile, nazevpalety);
     WriteLn(unitfile, txt12);

     Close(unitfile);
end.
