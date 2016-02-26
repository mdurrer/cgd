confirm_yes='T';

ctrl_textspeed='szybkość odtwarzania tekstu'; {if too long, delete 'odtwarzania'}
ctrl_musicvol= 'głośność muzyki';
ctrl_voicevol= 'głośność dźwięku';
ctrl_loadgame= 'Wczytaj grę';
ctrl_savegame= 'Zapisz grę';
ctrl_askquit1= 'Czy naprawdę chcesz wyjść?';
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
  (a:Center;f:Big;l:'Napisał'),
  (a:Center;f:Small;l:''),
  (a:Center;f:Big;l:'Pavel Pospíšil'),
  (a:Center;f:Big;l:''),
  (a:Center;f:Big;l:'Programowanie:'),
  (a:Center;f:Small;l:''),
  (a:Center;f:Big;l:'Lukáš Svoboda'),
  (a:Center;f:Small;l:'dźwięk, grafika i pamięć'),
  (a:Center;f:Small;l:''),
  (a:Center;f:Big;l:'Pavel Pospíšil'),
  (a:Center;f:Small;l:'animacje i jądro gry'),
  (a:Center;f:Small;l:''),
  (a:Center;f:Big;l:'Robert Špalek'),
  (a:Center;f:Small;l:'programy narzędziowe, (pre)kompilator'),
  (a:Center;f:Small;l:'i interpreter języka gry'),
  (a:Center;f:Big;l:''),
  (a:Center;f:Big;l:'Wizerunek artystyczny:'),
  (a:Center;f:Small;l:''),
  (a:Center;f:Big;l:'Pavel Jura'),
  (a:Center;f:Small;l:'grafika w tłach'),
  (a:Center;f:Small;l:''),
  (a:Center;f:Big;l:'Jakub  Dvorský'),
  (a:Center;f:Small;l:'animacje'),
  (a:Center;f:Small;l:''),
  (a:Center;f:Big;l:'Jan Pokorný'),
  (a:Center;f:Small;l:'większość postaci'),
  (a:Center;f:Big;l:''),
  (a:Center;f:Big;l:'Muzyka:'),
  (a:Center;f:Small;l:''),
  (a:Center;f:Big;l:'Radovan Kramář'),
  (a:Center;f:Big;l:''),
  (a:Center;f:Big;l:'W dialogach występują'),
  (a:Center;f:Small;l:''),
  (a:Center;f:Big;l:'Gabriela Burianová, Jana Dvořáková,'),
  (a:Center;f:Big;l:'Iva Pazderková, Miloš Bednář,'),
  (a:Center;f:Big;l:'Jan Budař, Robert Kocián, Martin Kollár,'),
  (a:Center;f:Big;l:'Radovan Kramář, Pavel Šmíd, Pavel Vraný'),
  (a:Center;f:Big;l:'i inni.'),
  (a:Center;f:Big;l:''),
  (a:Center;f:Big;l:'Grę testowali:'),
  (a:Center;f:Small;l:''),
  (a:Center;f:Big;l:'Martin Argaláš, Marek Floryán,'),
  (a:Center;f:Big;l:'Tomáš Rektor, Martin Weber'),
  (a:Center;f:Big;l:'i inni.'),
  (a:Center;f:Big;l:''),
  (a:Center;f:Big;l:'Specjalne podziękowania dla'),
  (a:Center;f:Small;l:''),
  (a:Center;f:Big;l:'Martina Sedláka'),
  (a:Center;f:Big;l:''),
  (a:Center;f:Small;l:'Redakcja wydania polskiego:'),
  (a:Center;f:Big;l:'Paweł Kalinowski, Mirage'),
  (a:Center;f:Big;l:''),
  (a:Center;f:Big;l:'Ożywił i oczyścił'),
  (a:Center;f:Big;l:'w latach 2006-2010'),
  (a:Center;f:Big;l:'Robert Špalek')
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
