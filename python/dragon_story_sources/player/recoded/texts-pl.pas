confirm_yes='T';

ctrl_textspeed='szybkoÜÅ odtwarzania tekstu'; {if too long, delete 'odtwarzania'}
ctrl_musicvol= 'gÉoÜnoÜÅ muzyki';
ctrl_voicevol= 'gÉoÜnoÜÅ dáwiÇku';
ctrl_loadgame= 'Wczytaj grÇ';
ctrl_savegame= 'Zapisz grÇ';
ctrl_askquit1= 'Czy naprawdÇ chcesz wyjÜÅ?';
ctrl_askquit2= '(T-tak, N-nie)'; {Warning! different keys}
ctrl_askpassw1= '';
ctrl_askpassw2= '';
ctrl_askpassw3= '';

maxaboutlines= 61;
aboutlines: array[1..maxaboutlines] of record
  a: TLineAttr;
  f: TWhatFont;
  l: string[42];
end = (
  (a:Center;f:Big;l:'Smocze Historie'),
  (a:Center;f:Big;l:'Copyright (c) 1995 NoSense'),
  (a:Center;f:Big;l:''),
  (a:Center;f:Big;l:'Wersja polska'),
  (a:Center;f:Big;l:'(c) 1996 Mirage Software'),
  (a:Center;f:Big;l:''),
  (a:Center;f:Big;l:'NapisaÉ'),
  (a:Center;f:Small;l:''),
  (a:Center;f:Big;l:'Pavel Posp°®il'),
  (a:Center;f:Big;l:''),
  (a:Center;f:Big;l:'Programowanie:'),
  (a:Center;f:Small;l:''),
  (a:Center;f:Big;l:'Luk†® Svoboda'),
  (a:Center;f:Small;l:'dáwiÇk, grafika i pamiÇÅ'),
  (a:Center;f:Small;l:''),
  (a:Center;f:Big;l:'Pavel Posp°®il'),
  (a:Center;f:Small;l:'animacje i jÄdro gry'),
  (a:Center;f:Small;l:''),
  (a:Center;f:Big;l:'Robert õpalek'),
  (a:Center;f:Small;l:'programy narzÇdziowe, (pre)kompilator'),
  (a:Center;f:Small;l:'i interpreter jÇzyka gry'),
  (a:Center;f:Big;l:''),
  (a:Center;f:Big;l:'Wizerunek artystyczny:'),
  (a:Center;f:Small;l:''),
  (a:Center;f:Big;l:'Pavel Jura'),
  (a:Center;f:Small;l:'grafika w tÉach'),
  (a:Center;f:Small;l:''),
  (a:Center;f:Big;l:'Jakub  Dvorskò'),
  (a:Center;f:Small;l:'animacje'),
  (a:Center;f:Small;l:''),
  (a:Center;f:Big;l:'Jan Pokornò'),
  (a:Center;f:Small;l:'wiÇkszoÜÅ postaci'),
  (a:Center;f:Big;l:''),
  (a:Center;f:Big;l:'Muzyka:'),
  (a:Center;f:Small;l:''),
  (a:Center;f:Big;l:'Radovan Kram†©'),
  (a:Center;f:Big;l:''),
  (a:Center;f:Big;l:'W dialogach wystÇpujÄ'),
  (a:Center;f:Small;l:''),
  (a:Center;f:Big;l:'Gabriela Burianov†, Jana Dvo©†kov†,'),
  (a:Center;f:Big;l:'Iva Pazderkov†, Milo® Bedn†©,'),
  (a:Center;f:Big;l:'Jan Buda©, Robert Koci†n, Martin Koll†r,'),
  (a:Center;f:Big;l:'Radovan Kram†©, Pavel õm°d, Pavel Vranò'),
  (a:Center;f:Big;l:'i inni.'),
  (a:Center;f:Big;l:''),
  (a:Center;f:Big;l:'GrÇ testowali:'),
  (a:Center;f:Small;l:''),
  (a:Center;f:Big;l:'Martin Argal†®, Marek Flory†n,'),
  (a:Center;f:Big;l:'Tom†® Rektor, Martin Weber'),
  (a:Center;f:Big;l:'i inni.'),
  (a:Center;f:Big;l:''),
  (a:Center;f:Big;l:'Specjalne podziÇkowania dla'),
  (a:Center;f:Small;l:''),
  (a:Center;f:Big;l:'Martina Sedl†ka'),
  (a:Center;f:Big;l:''),
  (a:Center;f:Small;l:'Redakcja wydania polskiego:'),
  (a:Center;f:Big;l:'PaweÉ Kalinowski, Mirage'),
  (a:Center;f:Big;l:''),
  (a:Center;f:Big;l:'OàywiÉ i oczyÜciÉ'),
  (a:Center;f:Big;l:'w latach 2006-2010'),
  (a:Center;f:Big;l:'Robert õpalek')
);

setup_err : array[1..3] of string[40] = (
  'Cannot open file MIDI.CFG',
  'Cannot write into file MIDI.CFG',
  'Cannot close file MIDI.CFG'
);
setup_log_success = 'Blaster found and installed.';
setup_log_failure = 'Blaster not found.';

player_missing_big = 'Missing big font!';
player_missing_small = 'Missing small font!';
player_missing_mouse = 'Invalid mouse driver!';
player_no_memory_1 = 'Not enough memory!  I need ';
player_no_memory_2 = ' bytes of conventional memory more!';

midi_errors : array[1..20] of string[51] = (
  'Nie moge przeczytac CMF.INS',
  'Nie moge przeczytac instrumentow midi /midi01',
  'Nie moge otworzyc pliku /midi01',
  'Zbyt dlugi plik /midi01',
  'Nie moge przeczytac pliku /midi01',
  'Plik nie w formacie midi /midi01',
  'Plik nie w formacie midi 0 lub 1 /midi01',
  'Plik nie w formacie midi /midi01',
  'Nie moge przeczytac pliku konfiguracyjnego /midi01',
  'Missing MIDI.CFG and cannot find sound card! /midi01',
  'Nie znalazlem managera pamieci rozszerzonej (EMM386)! /use_ems',
  'Nie moge skopiowac pliku do pamieci EMS!  /use_ems',
  'Nie mam dostepu do pamieci rozszerzonej /use_ems',
  'Nie moge zapisywac do EMS! /use_ems',
  'Nie moge czytac z EMS! /use_ems(1)',
  'Nie moge czytac z EMS! /use_ems(2)',
  'Nie moge czytac z EMS! /use_ems(3)',
  'Nie moge odczytac pozycji gry ze starej wersji!',
  'Nie moge otworzyc pliku CD.SAM',
  'Nie moge otworzyc pliku CD.SAM'
);
