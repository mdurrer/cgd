program MakeAObj;

uses crt, dialog, files, gmu, users, dfw, graph256;

var
  CFG_File: file;

  AN0_ImageName,
  AN1_Image,
  AN2_SampleName,
  AN3_Sample,
  AN4_SequenceName,
  AN5_Sequence: file;


  ANM_Name: string [8];

  ArchivniFajl: file;
  poradi: word;

const
  Background_Path: string= '';
  Music_Path     : string= '';
  Work_Path      : string= '';
  ANM_Path       : string= '';
  ImageNameHead   :string[32]= '<sklad jmen obrazku_-_-_-_-_-_->';
  ImageHead       :string[32]= '<obrazky-_-_-_-_-_-_-_-_-_-_-_->';
  SampleNameHead  :string[32]= '<sklad jmen samplu-_-_-_-_-_-_->';
  SampleHead      :string[32]= '<samply_-_-_-_-_-_-_-_-_-_-_-_->';
  SequenceNameHead:string[32]= '<sklad jmen animacnich sekvenci>';
  SequenceHead    :string[32]= '<animacni sekvence-_-_-_-_-_-_->';

  NazevArchivu : string = 'zkusebni.arc';
  NazevFajlu = 'e:\paint\picture\mesto.gcf';

procedure AssignAllArchives;
begin
  Assign(AN0_ImageName,    ANM_Path+ANM_Name+'.AN0');
  Assign(AN1_Image,        ANM_Path+ANM_Name+'.AN1');
  Assign(AN2_SampleName,   ANM_Path+ANM_Name+'.AN2');
  Assign(AN3_Sample,       ANM_Path+ANM_Name+'.AN3');
  Assign(AN4_SequenceName, ANM_Path+ANM_Name+'.AN4');
  Assign(AN5_Sequence,     ANM_Path+ANM_Name+'.AN5');
end;

procedure EraseAllArchives;
begin
  Erase(AN0_ImageName);
  Erase(AN1_Image);
  Erase(AN2_SampleName);
  Erase(AN3_Sample);
  Erase(AN4_SequenceName);
  Erase(AN5_Sequence);
end;

procedure RewriteAllArchives;
begin
  SetArchiveCapacity(1);

  CAddFromMemory(ANM_Path+ANM_Name+'.AN0', @ImageNameHead,    Length(ImageHead)+1 );
  CAddFromMemory(ANM_Path+ANM_Name+'.AN1', @ImageHead,        Length(ImageHead)+1 );
  CAddFromMemory(ANM_Path+ANM_Name+'.AN2', @SampleNameHead,   Length(ImageHead)+1 );
  CAddFromMemory(ANM_Path+ANM_Name+'.AN3', @SampleHead,       Length(ImageHead)+1 );
  CAddFromMemory(ANM_Path+ANM_Name+'.AN4', @SequenceNameHead, Length(ImageHead)+1 );
  CAddFromMemory(ANM_Path+ANM_Name+'.AN5', @SequenceHead,     Length(ImageHead)+1 );
end;

begin
  ANM_Path:= '';
  ANM_Name:= 'zkusebni';
  RewriteAllArchives;

{  AssignAllArchives;
  EraseAllArchives;
}
{  ClrScr;
  Assign(ArchivniFajl, NazevArchivu);
  Erase(ArchivniFajl);
  SetArchiveCapacity(2);

  Assign(ArchivniFajl, NazevArchivu);
  WriteLn( GetArchiveAvail(NazevArchivu) );
  poradi:= CAddFromFile(NazevArchivu, NazevFajlu);
  WriteLn( poradi );
  WriteLn( PackedItemSize(NazevArchivu, poradi) );
  WriteLn( UnpackedItemSize(NazevArchivu, poradi) );
  WriteLn( GetArchiveAvail(NazevArchivu) );
  readkey;
}
end.
