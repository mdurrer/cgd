confirm_yes='J';

ctrl_textspeed= 'Geschwindigkeit der Untertitel';
ctrl_musicvol= 'Musik Lautstärke';
ctrl_voicevol= 'Effekt Lautstärke';
ctrl_loadgame= 'Spielstand laden';
ctrl_savegame= 'Spielstand sichern';
ctrl_askquit1= 'Willst du das Spiel wirklich beenden?';
ctrl_askquit2= '(J=ja, N=nein)';
ctrl_askpassw1= 'Bitte gib Folgendes aus dem Handbuch ein: Das ';
ctrl_askpassw2= 'te Wort in der ';
ctrl_askpassw3= 'ten Zeile auf Seite ';

maxaboutlines= 61;
aboutlines: array[1..maxaboutlines] of record
  a: TLineAttr;
  f: TWhatFont;
  l: string[60];
end = (
  (a:Center;f:Big;l:'Dragon History'),
  (a:Center;f:Big;l:'Copyright (c) 1995 NoSense'),
  (a:Center;f:Big;l:''),
  (a:Center;f:Big;l:'Skript:'),
  (a:Center;f:Small;l:''),
  (a:Center;f:Big;l:'Pavel Pospíšil'),
  (a:Center;f:Big;l:''),
  (a:Center;f:Big;l:'Programmierung:'),
  (a:Center;f:Small;l:''),
  (a:Center;f:Big;l:'Lukáš Svoboda'),
  (a:Center;f:Small;l:'Hauptsächlich Sound-, Grafik-, und Speicherroutinen'),
  (a:Center;f:Small;l:''),
  (a:Center;f:Big;l:'Pavel Pospíšil'),
  (a:Center;f:Small;l:'Hauptsächlich Animationen und die Spielengine'),
  (a:Center;f:Small;l:''),
  (a:Center;f:Big;l:'Robert Špalek'),
  (a:Center;f:Small;l:'Hauptsächlich den Spieleditor, Kompilierer,'),
  (a:Center;f:Small;l:'und Interpreter der Spielsprache'),
  (a:Center;f:Big;l:''),
  (a:Center;f:Big;l:'Grafik:'),
  (a:Center;f:Small;l:''),
  (a:Center;f:Big;l:'Pavel Jura'),
  (a:Center;f:Small;l:'Hintergründe'),
  (a:Center;f:Small;l:''),
  (a:Center;f:Big;l:'Jakub  Dvorský'),
  (a:Center;f:Small;l:'Hauptsächlich Animationen'),
  (a:Center;f:Small;l:''),
  (a:Center;f:Big;l:'Jan Pokorný'),
  (a:Center;f:Small;l:'Die meisten Figuren, Vorderseite der Verpackung'),
  (a:Center;f:Big;l:''),
  (a:Center;f:Big;l:'Musik:'),
  (a:Center;f:Small;l:''),
  (a:Center;f:Big;l:'Radovan Kramář'),
  (a:Center;f:Big;l:''),
  (a:Center;f:Big;l:'Stimmen:'),
  (a:Center;f:Small;l:''),
  (a:Center;f:Big;l:'Gabriela Burianová, Jana Dvořáková,'),
  (a:Center;f:Big;l:'Iva Pazderková, Miloš Bednář,'),
  (a:Center;f:Big;l:'Jan Budař, Robert Kocián, Martin Kollár,'),
  (a:Center;f:Big;l:'Radovan Kramář, Pavel Šmíd, Pavel Vraný'),
  (a:Center;f:Big;l:'et al.'),
  (a:Center;f:Big;l:''),
  (a:Center;f:Big;l:'Tester:'),
  (a:Center;f:Small;l:''),
  (a:Center;f:Big;l:'Martin Argaláš, Marek Floryán,'),
  (a:Center;f:Big;l:'Tomáš Rektor, Martin Weber'),
  (a:Center;f:Big;l:'et al.'),
  (a:Center;f:Big;l:''),
  (a:Center;f:Big;l:'Besonderer Dank gilt'),
  (a:Center;f:Small;l:''),
  (a:Center;f:Big;l:'Martin Sedlák'),
  (a:Center;f:Big;l:''),
  (a:Center;f:Big;l:''),
  (a:Center;f:Big;l:'Deutsche Übersetzung von'),
  (a:Center;f:Small;l:''),
  (a:Center;f:Big;l:'Kevin Werdelmann, Hubert Maier'),
  (a:Center;f:Big;l:''),
  (a:Center;f:Big;l:'Wiederbelebt und bereinigt'),
  (a:Center;f:Big;l:'2006-2010 von'),
  (a:Center;f:Small;l:''),
  (a:Center;f:Big;l:'Robert Špalek')
);

setup_err : array[1..3] of string[40] = (
  'Kann Datei MIDI.CFG nicht oeffnen',
  'Kann nicht in Datei MIDI.CFG schreiben',
  'Kann Datei MIDI.CFG nicht schliessen'
);
setup_log_success = 'Blaster gefunden und installiert.';
setup_log_failure = 'Blaster nicht gefunden.';

player_missing_big = 'Grosse Schriftart fehlt!';
player_missing_small = 'Kleine Schriftart fehlt!';
player_missing_mouse = 'Ungueltiger Maustreiber!';
player_no_memory_1 = 'Nicht genug Speicher! Benoetige ';
player_no_memory_2 = ' Bytes mehr konventionellen Speicher!';

midi_errors : array[1..20] of string[70] = (
      {MIDI01}
  'Kann CMF.INS nicht laden',
  'Kann MIDI Instrumente nicht laden /midi01',
  'Kann Datei nicht oeffnen /midi01',
  'Die Datei ist zu lang! /midi01',
  'Kann Datei nicht laden /midi01',
  'Dies ist keine MIDI Datei /midi01i',
  'Dies ist kein MIDI des Formats 0 oder 1 /midi01',
  'Dies ist kein MIDI /midi01',
  'Kann Konfigurationsdatei nicht lesen! /midi01',
  'MIDI.CFG fehlt und Soundkarte nicht gefunden! /midi01',
  'Kein Treiber fuer erweiterten Speicher vorhanden (EMM386)! /use_ems',
  'Kann Datei nicht laden (in den EMS)  /use_ems',
  'Kann nicht auf erweiterten Speicher zugreifen /use_ems',
  'Kann nicht in den EMS schreiben! /use_ems',
  'Kann nicht aus dem EMS lesen /use_ems(1)',
  'Kann nicht aus dem EMS lesen /use_ems(2)',
  'Kann nicht aus dem EMS lesen /use_ems(3)',
  'Spielstand stammt von einer anderen Version des Spiels!',
  'Unautorisierte Version des Programms!',
  'Kann Datei CD.SAM nicht oeffnen!'
);
