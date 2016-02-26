@echo off
rem Compilation of p.pas in all languages

set TPU_DIR=..\units\system;..\units\gpl2;..\units\bar
set OBJ_DIR=..\units\system;..\units\gpl2
set BP7_DIR=d:\bp7\bin

echo Compiling Assembler modules
cd ..\units\gpl2
%BP7_DIR%\tasm play3
cd ..\system
%BP7_DIR%\tasm graphasm
%BP7_DIR%\tasm put

echo Compiling the game player
cd ..\..\player

%BP7_DIR%\bpc -B -DCZECH -U%TPU_DIR% -O%OBJ_DIR% -$G+ p.pas
ren p.exe p-cz.exe

del texts.tpu
%BP7_DIR%\bpc -M -DGERMAN -U%TPU_DIR% -O%OBJ_DIR% -$G+ p.pas
ren p.exe p-de.exe

del texts.tpu
%BP7_DIR%\bpc -M -DPOLISH -U%TPU_DIR% -O%OBJ_DIR% -$G+ p.pas
ren p.exe p-pl.exe

del texts.tpu
%BP7_DIR%\bpc -M -DENGLISH -U%TPU_DIR% -O%OBJ_DIR% -$G+ p.pas
copy p.exe p-en.exe

echo Done
cd ..\scripts
