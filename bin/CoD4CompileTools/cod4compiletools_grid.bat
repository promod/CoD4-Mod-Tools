@ECHO OFF
set treepath=%~1
set mapsourcepath=%~2
set makelog=%3
set cullxmodel=%4
set mapname=%5
set mpmap=%6

set exeName=iw3sp.exe
if "%mpmap%" == "1" (
	set exeName=iw3mp.exe
	mkdir "%treepath%main\maps\mp"
	IF EXIST "%mapsourcepath%%mapname%.grid"		copy "%mapsourcepath%%mapname%.grid" "%treepath%main\maps\mp\%mapname%.grid"
) else (
	mkdir "%treepath%main\maps\"
	IF EXIST "%mapsourcepath%%mapname%.grid"		copy "%mapsourcepath%%mapname%.grid" "%treepath%main\maps\%mapname%.grid"
)

cd "%treepath%"

%exeName% +set r_fullscreen 0 +set developer 1 +set logfile 2 +set r_vc_makelog %makelog% +set r_vc_showlog 16 +set r_cullxmodel %cullxmodel% +set thereisacow 1337 +set com_introplayed 1 +devmap %mapname%

IF EXIST "%mapsourcepath%%mapname%.grid"         		attrib -r "%mapsourcepath%%mapname%.grid"

if "%mpmap%" == "1" (
	IF EXIST "%treepath%main\maps\mp\%mapname%.grid"		move /y "%treepath%main\maps\mp\%mapname%.grid" "%mapsourcepath%%mapname%.grid"
) else (
	IF EXIST "%treepath%main\maps\%mapname%.grid"			move /y "%treepath%main\maps\%mapname%.grid" "%mapsourcepath%%mapname%.grid"
)

cls