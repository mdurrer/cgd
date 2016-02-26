confirm_yes='A';

ctrl_textspeed= 'rychlost textu';
ctrl_musicvol= 'hlasitost hudby';
ctrl_voicevol= 'hlasitost zvuku';
ctrl_loadgame= 'Na‡ten¡ ulo‘en‚ hern¡ pozice';
ctrl_savegame= 'Ulo‘en¡ aktu ln¡ hern¡ pozice';
ctrl_askquit1= 'Opravdu chcete ukon‡it hru?';
ctrl_askquit2= '(A=ano, N=ne)';
ctrl_askpassw1= 'Opi¨te pros¡m z manu lu';
ctrl_askpassw2= '. slovo na ';
ctrl_askpassw3= '. © dku ze strany ‡¡slo ';

maxaboutlines= 61;
aboutlines: array[1..maxaboutlines] of record
  a: TLineAttr;
  f: TWhatFont;
  l: string[42];
end = (
  (a:Center;f:Big;l:'Dra‡¡ Historie'),
  (a:Center;f:Big;l:'Copyright (c) 1995 NoSense'),
  (a:Center;f:Small;l:''),
  (a:Center;f:Big;l:''),
  (a:Center;f:Big;l:'Napsal:'),
  (a:Center;f:Small;l:''),
  (a:Center;f:Big;l:'Pavel Posp¡¨il'),
  (a:Center;f:Big;l:''),
  (a:Center;f:Big;l:''),
  (a:Center;f:Big;l:'Naprogramovali:'),
  (a:Center;f:Small;l:''),
  (a:Center;f:Big;l:'Luk ¨ Svoboda'),
  (a:Center;f:Small;l:'zejm‚na zvuk, grafiku a pr ci s pamˆt¡'),
  (a:Center;f:Small;l:''),
  (a:Center;f:Big;l:'Pavel Posp¡¨il'),
  (a:Center;f:Small;l:'zejm‚na animace a hern¡ engine'),
  (a:Center;f:Small;l:''),
  (a:Center;f:Big;l:'Robert ›palek'),
  (a:Center;f:Small;l:'zejm‚na v˜vojov‚ n stroje, (pre)kompil tor'),
  (a:Center;f:Small;l:'a interpret hern¡ho jazyka'),
  (a:Center;f:Big;l:''),
  (a:Center;f:Big;l:'Nakreslili:'),
  (a:Center;f:Small;l:''),
  (a:Center;f:Big;l:'Pavel Jura'),
  (a:Center;f:Small;l:'background art'),
  (a:Center;f:Small;l:''),
  (a:Center;f:Big;l:'Jakub  Dvorsk˜'),
  (a:Center;f:Small;l:'zejm‚na animace'),
  (a:Center;f:Small;l:''),
  (a:Center;f:Big;l:'Jan Pokorn˜'),
  (a:Center;f:Small;l:'vˆt¨ina postavi‡ek, p©edn¡ strana krabice'),
  (a:Center;f:Big;l:''),
  (a:Center;f:Big;l:'Hudba:'),
  (a:Center;f:Small;l:''),
  (a:Center;f:Big;l:'Radovan Kram ©'),
  (a:Center;f:Big;l:''),
  (a:Center;f:Big;l:''),
  (a:Center;f:Big;l:'Hlasy zap–j‡ili:'),
  (a:Center;f:Small;l:''),
  (a:Center;f:Big;l:'Gabriela Burianov , Jana Dvo© kov ,'),
  (a:Center;f:Big;l:'Iva Pazderkov , Milo¨ Bedn ©,'),
  (a:Center;f:Big;l:'Jan Buda©, Robert Koci n, Martin Koll r,'),
  (a:Center;f:Big;l:'Radovan Kram ©, Pavel ›m¡d, Pavel Vran˜'),
  (a:Center;f:Big;l:'a dal¨¡.'),
  (a:Center;f:Big;l:''),
  (a:Center;f:Big;l:''),
  (a:Center;f:Big;l:'Hru testovali:'),
  (a:Center;f:Small;l:''),
  (a:Center;f:Big;l:'Martin Argal ¨, Marek Flory n,'),
  (a:Center;f:Big;l:'Tom ¨ Rektor, Martin Weber'),
  (a:Center;f:Big;l:'a dal¨¡.'),
  (a:Center;f:Big;l:''),
  (a:Center;f:Big;l:'Velice speci lnˆ dˆkujeme'),
  (a:Center;f:Small;l:''),
  (a:Center;f:Big;l:'Martinu Sedl kovi'),
  (a:Center;f:Big;l:''),
  (a:Center;f:Big;l:''),
  (a:Center;f:Big;l:'Znovuzrodil, pro‡istil a spravoval'),
  (a:Center;f:Big;l:'v letech 2006-2010'),
  (a:Center;f:Small;l:''),
  (a:Center;f:Big;l:'Robert ›palek')
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
