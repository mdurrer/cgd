{Upgrades old DFW files to newer BAR files}
program upgrade;
uses bardfw;
var i, souboru, delka: word;
    pom: pointer;
    fo: file;
    ret: string;
begin
  if paramcount < 2 then begin
    writeln('upgrade.exe <vstup.dfw> <vystup.bar>');
    halt(0);
  end;
  souboru := getarchiveoccupy(paramstr(1));
  writeln('Prevadim ', souboru, ' souboru');
  for i := 1 to souboru do begin
    delka := cloaditem(paramstr(1), pom, i);
    caddfrommemory(paramstr(2), pom, delka);
    {If you want to extract separate files instead of creating a new archive,
    enable the following code:}
    if false then begin
      str(i, ret);
      assign(fo, paramstr(2) + '-' + ret + '.dat');
      rewrite(fo, 1);
      blockwrite(fo, pom^, delka);
      close(fo);
    end;
    freemem(pom, delka);
    writeln('Soubor ', i, ' ma delku ', delka);
  end;
end.
