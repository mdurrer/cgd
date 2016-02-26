program ConvertToMyFormat;
{verze II 2.x}


uses cg2_util,dos,crt,tool256,prn256_3,mouse,flittle,pcgccpal;

type
    _pismeno = array[0..237] of byte;

var
     paleta_prog, paleta_obr : _paletteptr;
     image, bitmapa : _bmptr;
     workfile : file;
     volba, c, cv : byte;
     g : word;
     Ix, Iy, Iwidth, Iheight : word;
     cesta, cesta_gcc, cesta_out, cuser_pal : string;
     jake_file : SearchRec;
     i1, i2 : word;

const
     cesta_fon='c:\user\fe\little.fon';
label
     HlavniMenu;

procedure ulozitimageproanimaci;
type proviny=^troviny;
     troviny=array[0..16384]of byte;
     trovin=array[0..3]of proviny;
var rov:trovin;
    celkem:_bmptr;
      idx,              {pozice ve vytvarene bajtove mape}
      idx1,             {zapamatovani si zacatku jednotlive bajtove mapy}
      idx2:word;        {zapamatovani si zacatku zpracovavane oblasti}
    i1,                 {cislo zpracovavane bajtove mapy}
    i2,                 {sloupec a potom pozice v jednotl. bajtove mape}
    i3:integer;         {radek a pocitadlo znaku}
    pakovano:Boolean;

    soub:file;
begin
  {ulozi image rozebranou do 4 bajtovych rovin (ne bitovych, kazdy bod je
   reprezentovan 256 barvami=1 bajtem) takto :
     nejprve X a Y obrazku (2*word)
     pak Velikost (word) zkomprimovaneho obrazku, kvuli skladani za sebe
     pak je ulozeno 4* pro kazdou bajtovou rovinu toto :
       Zacatek (1=zacina pruhlednym obalem, 0=zacina primo obrazkem) (byte)
       Velikost zapakovaneho obrazku (word)
       a pak tolikrat (az do vycerpani Velikosti) :
         PocetBajtu (word) - dany pocet bodu obrazku
         ObsahBajtu (byte) - pouze v pripade, ze nejde o obal, ale o vnitrek
   kvuli ulozeni v bajtovych rovinach se obrazek neuklada po radcich, ale
   po sloupcich}
  new(celkem);
  {vytvorime si misto pro novy obrazek}
  idx:=6;
  {budeme zapisovat od pozice 6, pred ni se na konci jeste zapisi parametry
   obrazku jako takoveho}
  for i1:=0 to 3 do begin
    getmem(rov[i1],iheight*((iwidth-i1-1) div 4+1));
    {naalokuji si presne tolik pamti, kolik potrebuji}
    for i2:=0 to ((iwidth-i1-1) div 4) do
      for i3:=0 to iheight-1 do
        rov[i1]^[i2*iheight+i3]:=image^[i3*iwidth+i2*4+i1];
    {nacteme si obrazek do dane bajtove roviny}
    pakovano:=rov[i1]^[0]=255;
    celkem^[idx]:=byte(pakovano);
    {zacina-li obalem nebo obrazkem}
    idx1:=idx+1;
    {zapamatujeme si pozici, na kterou zapiseme na konci velikost teto
     zkomprimovane casti}
    inc(idx,3);
    {posuneme opet index dopredu}

    i2:=0;
    {pozice v puvodni bajtove rovine}
    repeat
      if pakovano then begin
        i3:=0;
        {zatim jsme nalezli 0 bodu}
        while (rov[i1]^[i2]=255)and(i2<iheight*((iwidth-i1-1) div 4+1)) do begin
          inc(i3);
          inc(i2)
          {posun cteci index i2 a pocitadlo i3}
        end;
        celkem^[idx]  :=lo(i3);
        celkem^[idx+1]:=hi(i3);
        {zapis kolikrat jsme nalezli barvu 255}
        inc(idx,2)
        {posun index pro zapis o 2 dale}
      end else begin
        idx2:=idx;
        inc(idx,2);
        {zapamatuj si pozici, kam se zapise pocet znaku a posun zapisovy
         index o 2}
        i3:=0;
        {zatim jsme nalezli 0 bodu}
        while (rov[i1]^[i2]<>255)and(i2<iheight*((iwidth-i1-1) div 4+1)) do begin
          inc(i3);
          inc(i2);
          celkem^[idx]:=rov[i1]^[i2];
          inc(idx)
          {posun cteci index i2, pocitadlo i3, zapisovy index idx a zapis
           bod do vystupu}
        end;
        celkem^[idx2]  :=lo(i3);
        celkem^[idx2+1]:=hi(i3);
        {zapis pocitadlo}
      end;
      pakovano:=not pakovano
    until i2=iheight*((iwidth-i1-1) div 4+1);
    {nyni jsme dojeli na konec 1 bajtove mapy a musime zapsat pocet znaku}

    celkem^[idx1]  :=lo(idx-idx1-2);
    celkem^[idx1+1]:=hi(idx-idx1-2)
    {zapakovanou delku ziskame jako rozdil indexu pro zapis cisla a "dojite"
     pozice - 2, protoze je tam jeste mezera 2 bajtu na TOTO cislo}
  end;
  celkem^[0]:=lo(iwidth);    {sirka obrazku}
  celkem^[1]:=hi(iwidth);
  celkem^[2]:=lo(iheight);   {vyska obrazku}
  celkem^[3]:=hi(iheight);
  celkem^[4]:=lo(idx);       {zapakovana delka vcetne hlavicky a mezihlavicek}
  celkem^[5]:=hi(idx);

  assign(soub,cesta_out);
  rewrite(soub,1);
  blockwrite(soub,celkem^,idx);
  close(soub);

  dispose(celkem);
  for i1:=0 to 3 do
    freemem(rov[i1],iheight*((iwidth-i1-1) div 4+1))
{dopilovat pripad, ze je obrazek moc maly a vsechny bajtove roviny v nem
 nejsou vubec zastoupeny, pak nastane podteceni apod.
 Pozn. to je ten duvod, proc se mi v evidentne cistem obrazku 2*2 objevily
  v 2. a 3. rovine 2 hnusne body a ja nevedel proc.
 Pozn. nutno overit, zda pracuji spravne s temi bajtovymi rovinami, dodelat,
  ze sejmuty obrazek nemusi zacinat prave od 0. roviny
 Pozn. nutno dopilovat, aby to presne pasovalo na Lukasovu animacni rutinu
  a aby to melo optimalni format jak z hlediska rychlosti tak i z hlediska
  poctu registru nutnych k vykresleni celeho tohoto obrazku}
end;

begin
   Iwidth:=1;
   Iheight:=1;
   GetMem(image, Iwidth*Iheight);

   InitGraph;

{ Nastaveni palety... }
{ v unitu   "pcgccpal"  }

   New(paleta_prog);
   New(paleta_obr);

   paleta_prog:=cgccpal_pal;
   Font:=little_fon;

{ Nastaveni fontu...   }
{ v unitu   "flittle"  }


   ClearScr(255);
   InstallGrMouse;
   cesta:='e:\paint\picture\';
   cesta_gcc:='e:\paint\picture\';
   cesta_out:='';
   cuser_pal:='e:\paint\picture\';
HlavniMenu:
   SetPalette(paleta_prog);
   MouseOn;
   volba:=GrMenu(100,40,'CONVGCC II v.2.x|Načíst *.BMP|Načíst *.GCC|'+
                        'Načíst *.PAL|Vybrat image|Uložit *.GCC|'+
                        'Ulozit *.GCF|About...|Konec|Ulozit pro animaci|');
   case volba of
     0: goto HlavniMenu;
     1: begin

     WindowedAddInput(cesta);
     if not(CheckPath(cesta,'bmp')) then begin
        RepWindowed('Soubor není typu BMP');
        goto HlavniMenu;
     end;
     FindFirst(cesta, AnyFile, jake_file );
      if(DosError=0) then begin

{ Nacteni bitmapy }

     Assign(workfile, cesta);
     Reset(workfile, 1);
     Seek(workfile, 54);

     for c := 0 to 255 do begin
        BlockRead(workfile, paleta_obr^[c*3], 3);
        Seek(workfile, FilePos(workfile)+1);
     end;

     for c := 0 to 255 do begin
        cv := paleta_obr^[c*3];
        paleta_obr^[c*3] := paleta_obr^[c*3+2];
        paleta_obr^[c*3+2] :=cv;
     end;

     SetPalette(paleta_obr);

     New(bitmapa);

     Seek(workfile, 1078);

     BlockRead(workfile, bitmapa^[0], 64000);

     Close(workfile);            {po ukonceni prace se file MUSI zavrit!}


      end else begin
        if(DosError=3) then RepWindowed('Neplatná cesta')else
         if(DosError=2)or(DosError=18)then RepWindowed('Soubor nenalezen')else
          RepWindowed('DosError');
        goto HlavniMenu;
      end;



{Zobrazeni obrazku}
    MouseOff;
    asm
       push ds                  {musi byt - pro Pascal}
       lds si,bitmapa           { ds=seg.bitmapa, si=ofs.bitmapa}
       mov ax,0a000h            {adr. segmentu videoram}
       mov es,ax
       mov di,63680             {ofs.adr. zacatku posledniho radku VRAM}
       mov cx,200               {pocitadlo radku}
       cld                      {movs.. bude zvysovat...}
    @line:
       push cx
       mov cx,160               {presouvame po wordech, 160*2=320 bodu}
       rep movsw                {presun kresby}
       sub di,640               {posuv adresy ve o 1bod nahoru na zac. rad.}
       pop cx
       loop @line               {dalsi radek}
       pop ds                   {byl ulozeny...}
    end;

   MouseOn;
   Dispose(bitmapa);
   goto HlavniMenu;
   end;

     2: begin
          WindowedAddInput(cesta_gcc);
          if not(CheckPath(cesta_gcc,'gcc')) then begin
             RepWindowed('Soubor není typu GCC');
             goto HlavniMenu;
          end;
          FindFirst(cesta_gcc, AnyFile, jake_file );
           if(DosError=0) then begin
{ Nacteni image *.gcc }
            FreeMem(image, Iwidth*Iheight);
            Assign(workfile, cesta_gcc);
            Reset(workfile, 1);
            BlockRead(workfile, Iwidth, 2);
            BlockRead(workfile, Iheight, 2);
            GetMem(image, Iwidth*Iheight );
            BlockRead(workfile, image^[0], Iwidth*Iheight);
            Close(workfile);
{ Pokud existuje paleta, nahraju ji taky }
            byte(cesta_gcc[0]) := Length(cesta_gcc)-3;
            cesta_gcc := cesta_gcc+'pal';

            FindFirst(cesta_gcc, AnyFile, jake_file );
             if(DosError=0) then begin
               Assign(workfile,cesta_gcc);
               Reset(workfile,768);
               Seek(workfile, 0);
               BlockRead(workfile, paleta_obr^[0], 1);
               Close(workfile);
             end;

            byte(cesta_gcc[0]) := Length(cesta_gcc)-3;
            cesta_gcc := cesta_gcc+'gcc';

            MouseOff;
            SetPalette(paleta_obr);
            ClearScr(255);
            PutImage(Iwidth,Iheight,0,0,@image^[0]);
            SetPalette(paleta_prog);
            goto HlavniMenu;
           end else begin
            if(DosError=3) then RepWindowed('Neplatná cesta')else
             if(DosError=2)or(DosError=18)then RepWindowed('Soubor nenalezen')else
              RepWindowed('DosError');
            goto HlavniMenu;
           end;


        end;


     3: begin
          WindowedAddInput(cuser_pal);
          if not(CheckPath(cuser_pal,'pal')) then begin
             RepWindowed('Soubor není typu PAL');
             goto HlavniMenu;
          end;
          FindFirst(cuser_pal, AnyFile, jake_file );
          if(DosError=0) then begin
               Assign(workfile,cuser_pal);
               Reset(workfile,768);
               Seek(workfile, 0);
               BlockRead(workfile, paleta_obr^[0], 1);
               Close(workfile);
          SetPalette(paleta_obr);
          goto HlavniMenu;
          end else begin
            if(DosError=3) then RepWindowed('Neplatná cesta')else
             if(DosError=2)or(DosError=18)then RepWindowed('Soubor nenalezen')else
              RepWindowed('DosError');
            goto HlavniMenu;
           end;
        end;

     4: begin
          FreeMem(image, Iwidth*Iheight);
          SetPalette(paleta_obr);
          MouseOff;
          repeat until MouseKey=4;
          InputRectXor(Ix,Iy,Iwidth,Iheight);
          GetMem(image, Iwidth*Iheight);
          MouseOff;
          GetImage(Iwidth, Iheight, Ix, Iy, image);
          Delay(300);
          SetPalette(paleta_prog);
          MouseOn;
          goto HlavniMenu;
        end;
   5: begin
        WindowedInput(cesta_out);
        if not(CheckPath(cesta_out,'gcc')) then begin
           RepWindowed('Soubor musí mít příponu GCC');
           goto HlavniMenu;
        end;
        FindFirst(cesta_out, AnyFile, jake_file );
         if(DosError=2)or(DosError=18) or
         ( (DosError=0)and (GrMenu(50,60,'Soubor již existuje. Přepsat?|Ano|Ne|')=1))
         then begin
            Assign(workfile, cesta_out);
            Rewrite(workfile, 1);
            BlockWrite(workfile, Iwidth, 2);
            BlockWrite(workfile, Iheight, 2);
            BlockWrite(workfile, image^[0], Iwidth*Iheight);
            Close(workfile);
            if GrMenu(50,60,'Uložit i paletu?|Ano|Ne|')=1 then begin
              byte(cesta_out[0]) := Length(cesta_out)-3;
              cesta_out := cesta_out+'pal';
              Assign(workfile,cesta_out);
              Rewrite(workfile,768);
              Seek(workfile, 0);
              BlockWrite(workfile, paleta_obr^[0], 1);
              Close(workfile);
            end;
            goto HlavniMenu;
         end else begin
           if(DosError=3) then RepWindowed('Neplatná cesta')else
             if(DosError<>0)then RepWindowed('DosError');
           goto HlavniMenu;
         end;
       end;

     6: begin
          WindowedInput(cesta_out);
          if not(CheckPath(cesta_out,'gcf')) then begin
             RepWindowed('Soubor musí mít příponu GCF');
             goto HlavniMenu;
          end;
          FindFirst(cesta_out, AnyFile, jake_file );
           if(DosError=2)or(DosError=18) or
           ( (DosError=0)and (GrMenu(50,60,'Soubor již existuje. Přepsat?|Ano|Ne|')=1))
           then begin
              Assign(workfile, cesta_out);
              Rewrite(workfile, 1);
              BlockWrite(workfile, Iwidth, 2);
              BlockWrite(workfile, Iheight, 2);

              for i1:=0 to Iwidth-1 do
                for i2:=0 to Iheight-1 do        {i2=y}
                  BlockWrite(workfile, image^[i2*(Iwidth)+i1], 1);

              Close(workfile);
              if GrMenu(50,60,'Uložit i paletu?|Ano|Ne|')=1 then begin
{Lukasovo GCF ma paletu uz primo posunutou }
                for i1:=0 to 767 do paleta_obr^[i1]:= paleta_obr^[i1] shr 2;

                byte(cesta_out[0]) := Length(cesta_out)-3;
                cesta_out := cesta_out+'pal';
                Assign(workfile,cesta_out);
                Rewrite(workfile,768);
                Seek(workfile, 0);
                BlockWrite(workfile, paleta_obr^[0], 1);
                Close(workfile);
              end;
              goto HlavniMenu;
           end else begin
             if(DosError=3) then RepWindowed('Neplatná cesta')else
               if(DosError<>0)then RepWindowed('DosError');
             goto HlavniMenu;
           end;
        end;
     7: begin
          RepWindowed('Konverze BMP do formátu GCC. (C)1993 GCC');
          goto HlavniMenu;
        end;
     8: begin
          if GrMenu(90,60,'Opravdu?|Ano|Ne|')=1 then begin
             CloseGraph;
             Halt;
          end else goto HlavniMenu;
        end;
     9:begin
         windowedinput(cesta_out);
         ulozitimageproanimaci;
         goto hlavnimenu
       end
   end;

end.



