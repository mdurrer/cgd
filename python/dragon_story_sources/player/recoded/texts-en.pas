{
                S E E   T H E    V E R Y    E N D   !!!!!!!
}

{ This is source file for Pascal. }
{ Text in such this brackets is only remark... }

{ Everything between single quotation marks should be translated. }
{ 1. delete old text between quotation marks }
{ 2. fill in translated sentence }

{ About translating credits: }
{ Some credits may be unnecessary - voices ... }
{ Some credits may be added - translators ... }
{ If there's not additional space, add them on special lines. }

{ About translating error messages: }
{ If there's slash in some message, don't translate text after the slash }
{ Example: }
{ 'Can't write to EMS! /use_ems' }
{ '...translate......../...don't !....' }

confirm_yes='Y';

ctrl_textspeed= 'speed of text';
ctrl_musicvol= 'music volume';
ctrl_voicevol= 'sound volume';
ctrl_loadgame= 'Loading a saved game position';
ctrl_savegame= 'Saving the current game position';
ctrl_askquit1= 'Do you really want to quit the game?';
ctrl_askquit2= '(Y=yes, N=no)';
ctrl_askpassw1= 'Enter please the following from the manual: the ';
ctrl_askpassw2= 'th word on the ';
ctrl_askpassw3= 'th line of page ';

maxaboutlines= 61;
aboutlines: array[1..maxaboutlines] of record
  a: TLineAttr;
  f: TWhatFont;
  l: string[42];
end = (
  (a:Center;f:Big;l:'Dragon History'),
  (a:Center;f:Big;l:'Copyright (c) 1995 NoSense'),
  (a:Center;f:Big;l:''),
  (a:Center;f:Big;l:'Script:'),
  (a:Center;f:Small;l:''),
  (a:Center;f:Big;l:'Pavel Posp¡¨il'),
  (a:Center;f:Big;l:''),
  (a:Center;f:Big;l:'Programmers:'),
  (a:Center;f:Small;l:''),
  (a:Center;f:Big;l:'Luk ¨ Svoboda'),
  (a:Center;f:Small;l:'mostly sound, graphics, and memory routines'),
  (a:Center;f:Small;l:''),
  (a:Center;f:Big;l:'Pavel Posp¡¨il'),
  (a:Center;f:Small;l:'mostly animations and the game engine'),
  (a:Center;f:Small;l:''),
  (a:Center;f:Big;l:'Robert ›palek'),
  (a:Center;f:Small;l:'mostly the game editor, compiler,'),
  (a:Center;f:Small;l:'and interpreter of the game language'),
  (a:Center;f:Big;l:''),
  (a:Center;f:Big;l:'Graphics:'),
  (a:Center;f:Small;l:''),
  (a:Center;f:Big;l:'Pavel Jura'),
  (a:Center;f:Small;l:'background art'),
  (a:Center;f:Small;l:''),
  (a:Center;f:Big;l:'Jakub  Dvorsk˜'),
  (a:Center;f:Small;l:'mostly animations'),
  (a:Center;f:Small;l:''),
  (a:Center;f:Big;l:'Jan Pokorn˜'),
  (a:Center;f:Small;l:'most of the figures, front side of the box'),
  (a:Center;f:Big;l:''),
  (a:Center;f:Big;l:'Music:'),
  (a:Center;f:Small;l:''),
  (a:Center;f:Big;l:'Radovan Kram ©'),
  (a:Center;f:Big;l:''),
  (a:Center;f:Big;l:'Voices:'),
  (a:Center;f:Small;l:''),
  (a:Center;f:Big;l:'Gabriela Burianov , Jana Dvo© kov ,'),
  (a:Center;f:Big;l:'Iva Pazderkov , Milo¨ Bedn ©,'),
  (a:Center;f:Big;l:'Jan Buda©, Robert Koci n, Martin Koll r,'),
  (a:Center;f:Big;l:'Radovan Kram ©, Pavel ›m¡d, Pavel Vran˜'),
  (a:Center;f:Big;l:'et al.'),
  (a:Center;f:Big;l:''),
  (a:Center;f:Big;l:'Testers:'),
  (a:Center;f:Small;l:''),
  (a:Center;f:Big;l:'Martin Argal ¨, Marek Flory n,'),
  (a:Center;f:Big;l:'Tom ¨ Rektor, Martin Weber'),
  (a:Center;f:Big;l:'et al.'),
  (a:Center;f:Big;l:''),
  (a:Center;f:Big;l:'Very special thanks to'),
  (a:Center;f:Small;l:''),
  (a:Center;f:Big;l:'Martin Sedl k'),
  (a:Center;f:Big;l:''),
  (a:Center;f:Big;l:''),
  (a:Center;f:Big;l:'English scripts proofread by'),
  (a:Center;f:Small;l:''),
  (a:Center;f:Big;l:'Tom Pietschmann'),
  (a:Center;f:Big;l:''),
  (a:Center;f:Big;l:'Revived and cleaned up'),
  (a:Center;f:Big;l:'in 2006-2010 by'),
  (a:Center;f:Small;l:''),
  (a:Center;f:Big;l:'Robert ›palek')
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
      {MIDI01}
  'Cannot load file CMF.INS',
  'Cannot load MIDI instruments /midi01',
  'Cannot open file /midi01',
  'The file is too long! /midi01',
  'Cannot load file /midi01',
  'It is not a MIDI /midi01',
  'It is not a MIDI format 0 or 1 /midi01',
  'It is not a MIDI /midi01',
  'Cannot load the configuration file! /midi01',
  'Missing MIDI.CFG and cannot find sound card! /midi01',
  'No extended memory driver present (EMM386)! /use_ems',
  'Cannot load file (into EMS)  /use_ems',
  'Cannot access the extended memory /use_ems',
  'Cannot write to EMS! /use_ems',
  'Cannot read from EMS /use_ems(1)',
  'Cannot read from EMS /use_ems(2)',
  'Cannot read from EMS /use_ems(3)',
  'Trying to load a game position from a different version of the game!',
  'Unauthorized version of the program!',
  'Cannot open file CD.SAM!'
);
