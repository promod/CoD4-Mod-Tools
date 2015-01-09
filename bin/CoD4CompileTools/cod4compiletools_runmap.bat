@ECHO OFF

set treepath=%~1
set mapname=%2
set mpmap=%3
set cmdOptions=%~4

set exeName=iw3sp.exe
if "%mpmap%" == "1" (
	set exeName=iw3mp.exe
)

cd %treepath%
echo %exeName% +set logfile 2 +set monkeytoy 0 +set com_introplayed 1 +devmap %mapname% %cmdOptions%
%exeName% +set logfile 2 +set monkeytoy 0 +set com_introplayed 1 +devmap %mapname% %cmdOptions%

cls