uses
  crt, dialog, editor, files, gmu, dfw,
  graform, graph256, animace3, anmplay, soundpas, comfreq2;

var PreviousPath, Path: string;

procedure ChooseFile(JakTridit: ttrideni; PreviousPath, Extension: string);
begin
  Path:= vybersouboru(InfMenu[52].X,InfMenu[52].Y,InfMenu[52].Pocet,
    DColor1, DColor2, DColor3, DColor4, DColor5, Font,
    JakTridit, PreviousPath, Extension);
end;

procedure AddPicturesToStore;
var
  hp1, hp2 : longint;
  LoadedPalette: pointer;
  LoadedScreen: pointer;
  ChoosenImage: pointer;
  ax, ay, awidth, aheigth: integer;
  acolor: byte;
  sx,sy,sw,sh,sc: string[3];
  Number: byte;
  NumStr: string[3];
  PictureName: string[12];
  name: string;
  Ext: string[3];

{  PalFile: file;}

  procedure Cleaning;
  begin
    DisposeImage(LoadedScreen);
    FreeMem(LoadedPalette, 768);
    SetPalette(Palette);
  end;

begin
  ChooseFile(trid_jmena, Picture_Path, '*.lbm;*.pcx;*.bmp' );
  if (path=#27)or(path=#0)then exit;
  if LoadImage(LoadedScreen, LoadedPalette, path)= 0 then begin
    standardnidialog('Chyba při čtení souboru:|'+path,
    DColor1, DColor2, DColor3, DColor4, DColor5, font, BeruNaVedomi);
    exit;
  end;

  Number:= 0; {cislo prave prenaseneho obrazku}
  repeat
    hp1:= MaxAvail;
    MouseSwitchOff;
    PutImage(0, 0, LoadedScreen);
    MouseSwitchOn;
    standardnidialog('Klikni mimo obrázek',
    DColor1, DColor2, DColor3, DColor4, DColor5, font, BeruNaVedomi);
    SetPalette(LoadedPalette);


    repeat until MouseKey=1;
    ax:= MouseX;
    ay:= MouseY;
    MouseSwitchOff;
    acolor:= GetPixel(ax, ay);
    MouseSwitchOn;

    repeat until MouseKey=0;
    SetPalette(Palette);
    standardnidialog('Klikni dovnitř obrázku',
    DColor1, DColor2, DColor3, DColor4, DColor5, font, BeruNaVedomi);
    SetPalette(LoadedPalette);
    repeat until MouseKey=1;
    ax:= MouseX;
    ay:= MouseY;
    repeat until MouseKey=0;
    MarkImage(ax, ay, awidth, aheigth, ActivePage, acolor);
    Str(ax:3, sx);
    Str(ay:3, sy);
    Str(awidth:3, sw);
    Str(aheigth:3, sh);
    Str(acolor:3, sc);
    MouseSwitchOff;
    PutImage(0, 0, LoadedScreen);
    SetPalette(Palette);
    MouseSwitchOn;
    if standardnidialog('x:'+sx+'|y:'+sy+'|šířka:'+sw+'|výška:'+sh+'|barva kolem:'+sc+
      +'|Vybrat?', DColor1, DColor2, DColor3, DColor4, DColor5, font, Ano_Ne)= 1 then begin

      if (awidth=0)or(aheigth=0)then begin
        standardnidialog('Výběr proběhl neúspěšně!|Buď je nulová výška nebo šířka!',
        DColor1, DColor2, DColor3, DColor4, DColor5, font, BeruNaVedomi);
      end else begin
        if Number=0 then begin
          name:= ReadText(InfMenu[57].X, InfMenu[57].Y, 200, 'Jméno prvního z obrázků:','');
          if name[1]= #27 then begin
            Cleaning;
            Exit;
          end;
          if Length(name)>10 then byte(name[0]):= 10;
        end;
        Str(Number: 2, NumStr);
        PictureName:= name+ '.'+ NumStr;
        CAddFromMemory(ANM_Path+ANM_Name+'.AN0', @PictureName, 13);

        MouseSwitchOff;

        NewImage(awidth, aheigth, ChoosenImage);
        GetImage(ax, ay, awidth, aheigth, ChoosenImage);
        CAddFromMemory(ANM_Path+ANM_Name+'.AN1', ChoosenImage, awidth*aheigth+4 );
        DisposeImage(ChoosenImage);

        Inc(Number);
      end;
    end;
    if hp1<>MaxAvail then write(#7);
  until standardnidialog('Vybrat další?',
  DColor1, DColor2, DColor3, DColor4, DColor5, font, Ano_Ne)= 2;

  MouseSwitchOn;
  Cleaning;

end;
procedure LookPicturesDialog;
var
  hp1, hp2: longint;
  dial:pdialog;
  vysl:pstav;
  ExitCode, Button: byte;

  Picture_Name: string[12];
  PackedLength_s, Length_s, ActPicture_s, NumOfPictures_s: string[5];

  ActPicture: byte;

  ActPictureImage: pointer;
  APBarX, APBarY: word;

  procedure DeleteActPicture;

    procedure AdjustSequences;
    var
      ActSequence: byte;
      f: byte;
    begin
      if GetArchiveOccupy(ANM_Path+ANM_Name+'.AN5')< 2 then exit;
      for ActSequence:= 2 to GetArchiveOccupy(ANM_Path+ANM_Name+'.AN5') do begin
        ReadSeqNameFromStore(2);
        ReadSequenceFromStore(2);
        for f:= 1 to EdAnim^.Header.NumOfPhases do with EdAnim^.Phase[f] do begin
          if EdAnim^.Phase[f].Picture= ActPicture then EdAnim^.Phase[f].Picture:= 0;
          if EdAnim^.Phase[f].Picture> ActPicture then Dec(EdAnim^.Phase[f].Picture);
        end;

        EraseReadedSeqNameFromStore(2);
        EraseReadedSequenceFromStore(2);
        WriteSeqNameToStore;
        WriteSequenceToStore;
      end;
    end;

  begin
    CEraseItem(ANM_Path+ANM_Name+'.AN1', ActPicture);
    CEraseItem(ANM_Path+ANM_Name+'.AN0', ActPicture);
    AdjustSequences;
    if ActPicture> GetArchiveOccupy(ANM_Path+ANM_Name+'.AN1')then ActPicture:= GetArchiveOccupy(ANM_Path+ANM_Name+'.AN1');
  end;


begin
  ActPicture:= 2;
  Button:= 1;
repeat
  hp1:= MaxAvail;

  mouseswitchoff;                       {uklid mys pro vypis}
  ClearScr(0);
  if GetArchiveOccupy(ANM_Path+ANM_Name+'.AN1')< 2 then exit;

  CLoadItem(ANM_Path+ANM_Name+'.AN1', ActPictureImage, ActPicture);

  APBarX:= PWordArray(ActPictureImage)^[0];
  APBarY:= PWordArray(ActPictureImage)^[1];
  if APBarX>320 then APBarX:= 320;
  if APBarY>200 then APBarY:= 200;
  Bar(0, 0, APBarX, APBarY, 255);
{Protoze musim pouzivat putovaci rutiny s maskovanim, vytiskl jsem si nejdriv}
{bar pod obrazek, aby byla zretelna velikost obrazku}
  PutMaskImagePart(0, 0, 0, 0, 320, 200, ActPictureImage);
  DisposeImage(ActPictureImage);

  Str(GetArchiveOccupy(ANM_Path+ANM_Name+'.AN1'): 5, NumOfPictures_s);
  Str(UnpackedItemSize(ANM_Path+ANM_Name+'.AN1', ActPicture): 5, Length_s);
  Str(PackedItemSize(ANM_Path+ANM_Name+'.AN1', ActPicture): 5, PackedLength_s);
  Str(ActPicture: 5, ActPicture_s);

  CLoadItem(ANM_Path+ANM_Name+'.AN0', pointer(Ptr_Name), ActPicture);
  Picture_Name:= Ptr_Name^;
  FreeMem(Ptr_Name, 13);

{  Picture_Name:='xx';}

  hp2:= MaxAvail;

  alokujdialog(dial, InfMenu[62].X, InfMenu[62].Y , 112, 76,
                 DColor2, DColor4, DColor5, {pozadi, ramecek, okraj}
                 false,                 {escvenku}
                 true,                  {ramtlac}
                 true,                 {presouvatelny}
                 true, false);          {kreslit/nemazat}


  nastavpocty(dial,8,6,0,0,0);
{            _nap,_tlac,_check,_radio,_input }
  {pouze nastavi pocty do alokovaneho dialogu}

  alokujpredvoleny(vysl,1,Button,1);

  alokujnapis(dial, 1,  2, 2, DColor1, font, 'Jméno:');
  alokujnapis(dial, 2, 38, 2, DColor4, font, Picture_Name);
  alokujnapis(dial, 3,  2, 14, DColor4, font, ActPicture_s);
  alokujnapis(dial, 4,  2, 26, DColor2, font, NumOfPictures_s);
  alokujnapis(dial, 5,  2, 50, DColor2, font, 'Délka    :');
  alokujnapis(dial, 6,  68, 50, DColor1, font, Length_s);
  alokujnapis(dial, 7,  2, 62, DColor2, font, 'Zpakované:');
  alokujnapis(dial, 8,  68, 62, DColor1, font, PackedLength_s);

  alokujtlac(dial, 1,  8, 38, DColor1, DColor3, font, '~<<');
  alokujtlac(dial, 2,  40,38, DColor1, DColor3, font, '<~,');
  alokujtlac(dial, 3,  66,38, DColor1, DColor3, font, '~.>');
  alokujtlac(dial, 4,  92,38, DColor1, DColor3, font, '>~>');
  alokujtlac(dial, 5,  74,26, DColor1, DColor3, font, '~Vymaž');
  alokujtlac(dial, 6,  74,14, DColor1, DColor3, font, '~Zpět ');

  with dial^ do begin
    {tady, pokud to chci lepe, musim rucne nastavit sirky ramecku, aby to,
     co je pod sebou, melo i shodny ramecek}
  end;


  vyberdialog(dial,vysl);               {on po sobe mys taky uklidi}

  InfMenu[62].X:= Dial^.X;
  InfMenu[62].Y:= Dial^.Y;

  ExitCode:=Vysl^.UkAkce;
  Button:= Vysl^.PredvObj;

  if ExitCode=1 then begin
    Dec(ExitCode);
    Button:= 6;
  end;
  {upravim hodnoty v pripade Escape}

  dealokujdialog(dial, vysl);
  if hp2<>MaxAvail then write(#7);

  if (ExitCode=0)or(ExitCode=2) then begin
    case Button of
     1: ActPicture:= 2{na zacatek skladu obrazku};
     2: if ActPicture> 2 then Dec(ActPicture){o jeden obr. zpet};
     3: if ActPicture< GetArchiveOccupy(ANM_Path+ANM_Name+'.AN1') then Inc(ActPicture){o jeden obr. vpred};
     4: ActPicture:= GetArchiveOccupy(ANM_Path+ANM_Name+'.AN1'){posledni obrazek ve skladu};
     5: if standardnidialog('Mám tento obrázek vymazat?',
        DColor1, DColor2, DColor3, DColor4, DColor5, font, Ano_Ne)=1 then DeleteActPicture;
        {vymazani aktualniho obr. ze skladu, prekopani sekvenci}
     6: {ukonceni prohlizeni skladu, navrat do menu nahoru};
    end;
  end;

{  smazdialog(dial);}

  if hp1<>MaxAvail then write(#7);
until ( (ExitCode=0)or(ExitCode=2) )and(Button=6);

  ClearScr(0);
end;


procedure PicturesMenu;
begin
  InfMenu[54].Volba:= 1;
  repeat
    repeat until MouseKey=0;

    InfMenu[54].Volba:=VytvorMenu('#     Obrázky|#-------------------'+
      +'|~Přidání do skladu|Prohlížení ~skladu|#-------------------'+
      +'|~Zpět',
      DColor1, DColor2, DColor3, DColor4,DColor5, font, InfMenu[54].X, InfMenu[54].Y,
      InfMenu[54].Volba, -1);
    case InfMenu[54].Volba of
      1 : AddPicturesToStore;
      2 : LookPicturesDialog;
    end;
    if (InfMenu[54].Volba=-1)then InfMenu[54].Volba:= 3;
  until (InfMenu[54].Volba= 3);
end;
