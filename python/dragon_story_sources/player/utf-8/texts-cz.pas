confirm_yes='A';

ctrl_textspeed= 'rychlost textu';
ctrl_musicvol= 'hlasitost hudby';
ctrl_voicevol= 'hlasitost zvuku';
ctrl_loadgame= 'Načtení uložené herní pozice';
ctrl_savegame= 'Uložení aktuální herní pozice';
ctrl_askquit1= 'Opravdu chcete ukončit hru?';
ctrl_askquit2= '(A=ano, N=ne)';
ctrl_askpassw1= 'Opište prosím z manuálu';
ctrl_askpassw2= '. slovo na ';
ctrl_askpassw3= '. řádku ze strany číslo ';

maxaboutlines= 61;
aboutlines: array[1..maxaboutlines] of record
  a: TLineAttr;
  f: TWhatFont;
  l: string[42];
end = (
  (a:Center;f:Big;l:'Dračí Historie'),
  (a:Center;f:Big;l:'Copyright (c) 1995 NoSense'),
  (a:Center;f:Small;l:''),
  (a:Center;f:Big;l:''),
  (a:Center;f:Big;l:'Napsal:'),
  (a:Center;f:Small;l:''),
  (a:Center;f:Big;l:'Pavel Pospíšil'),
  (a:Center;f:Big;l:''),
  (a:Center;f:Big;l:''),
  (a:Center;f:Big;l:'Naprogramovali:'),
  (a:Center;f:Small;l:''),
  (a:Center;f:Big;l:'Lukáš Svoboda'),
  (a:Center;f:Small;l:'zejména zvuk, grafiku a práci s pamětí'),
  (a:Center;f:Small;l:''),
  (a:Center;f:Big;l:'Pavel Pospíšil'),
  (a:Center;f:Small;l:'zejména animace a herní engine'),
  (a:Center;f:Small;l:''),
  (a:Center;f:Big;l:'Robert Špalek'),
  (a:Center;f:Small;l:'zejména vývojové nástroje, (pre)kompilátor'),
  (a:Center;f:Small;l:'a interpret herního jazyka'),
  (a:Center;f:Big;l:''),
  (a:Center;f:Big;l:'Nakreslili:'),
  (a:Center;f:Small;l:''),
  (a:Center;f:Big;l:'Pavel Jura'),
  (a:Center;f:Small;l:'background art'),
  (a:Center;f:Small;l:''),
  (a:Center;f:Big;l:'Jakub  Dvorský'),
  (a:Center;f:Small;l:'zejména animace'),
  (a:Center;f:Small;l:''),
  (a:Center;f:Big;l:'Jan Pokorný'),
  (a:Center;f:Small;l:'většina postaviček, přední strana krabice'),
  (a:Center;f:Big;l:''),
  (a:Center;f:Big;l:'Hudba:'),
  (a:Center;f:Small;l:''),
  (a:Center;f:Big;l:'Radovan Kramář'),
  (a:Center;f:Big;l:''),
  (a:Center;f:Big;l:''),
  (a:Center;f:Big;l:'Hlasy zapůjčili:'),
  (a:Center;f:Small;l:''),
  (a:Center;f:Big;l:'Gabriela Burianová, Jana Dvořáková,'),
  (a:Center;f:Big;l:'Iva Pazderková, Miloš Bednář,'),
  (a:Center;f:Big;l:'Jan Budař, Robert Kocián, Martin Kollár,'),
  (a:Center;f:Big;l:'Radovan Kramář, Pavel Šmíd, Pavel Vraný'),
  (a:Center;f:Big;l:'a další.'),
  (a:Center;f:Big;l:''),
  (a:Center;f:Big;l:''),
  (a:Center;f:Big;l:'Hru testovali:'),
  (a:Center;f:Small;l:''),
  (a:Center;f:Big;l:'Martin Argaláš, Marek Floryán,'),
  (a:Center;f:Big;l:'Tomáš Rektor, Martin Weber'),
  (a:Center;f:Big;l:'a další.'),
  (a:Center;f:Big;l:''),
  (a:Center;f:Big;l:'Velice speciálně děkujeme'),
  (a:Center;f:Small;l:''),
  (a:Center;f:Big;l:'Martinu Sedlákovi'),
  (a:Center;f:Big;l:''),
  (a:Center;f:Big;l:''),
  (a:Center;f:Big;l:'Znovuzrodil, pročistil a spravoval'),
  (a:Center;f:Big;l:'v letech 2006-2010'),
  (a:Center;f:Small;l:''),
  (a:Center;f:Big;l:'Robert Špalek')
);

setup_err : array[1..3] of string[40] = (
  'Nelze otevrit soubor MIDI.CFG',
  'Nelze zapisovat do souboru MIDI.CFG',
  'Nelze zavrit soubor MIDI.CFG'
);
setup_log_success = 'Blaster nalezen a nainstalovan.';
setup_log_failure = 'Blaster nenalezen.';

player_missing_big = 'Neni velky font!';
player_missing_small = 'Neni maly font!';
player_missing_mouse = 'Chybny ovladac mysi!';
player_no_memory_1 = 'Nedostatek pameti!  Potrebuji ';
player_no_memory_2 = ' byte konvencni pameti vic!';

midi_errors : array[1..20] of string[51] = (
      {MIDI01}
  'Nelze nacist soubor  CMF.INS',
  'nelze nacist nastroje midi /midi01',
  'Nelze otevrit soubor /midi01',
  'Soubor je moc dlouhy! /midi01',
  'Nelze nacist soubor /midi01',
  'Neni to midi /midi01',
  'Neni to midiformat 0 nebo 1 /midi01',
  'Neni to midi /midi01',
  'Nelze nacist konfiguracni soubor! /midi01',
  'Chybi MIDI.CFG a zvukovku nelze najit! /midi01',
  'Neni ovladac extended memory (EMM386)! /use_ems',
  'nelze nacist soubor (pro natazeni do EMS)  /use_ems',
  'Nelze zpristupnit extended memory /use_ems',
  'Nelze zapsat do EMS! /use_ems',
  'Nelze cist z EMS /use_ems(1)',
  'Nelze cist z EMS /use_ems(2)',
  'Nelze cist z EMS /use_ems(3)',
  'Pokus o nacteni pozice z neaktualni verze hry!',
  'Neautorizovana verze programu!',
  'Nelze otevrit soubor CD.SAM!'
);
