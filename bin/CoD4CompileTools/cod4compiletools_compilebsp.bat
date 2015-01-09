@ECHO OFF

:: ###########################################
:: 		SET UP VARIABLES
:: ###########################################

set bsppath=%~1
set mapsourcepath=%~2
set treepath=%~3
set mapname=%4
set parmBSPOptions=%~5
set parmLightOptions=%~6
set compileBSP=%7
set compileLight=%8
set compilePaths=%9
shift
set compileVIS=%9
shift
set mpmap=%9

if "%parmBSPoptions%" == "-" (
	set parmBSPoptions=
)

if "%parmLightOptions%" == "-" (
	set parmLightOptions=
)

mkdir "%bsppath%

if "%compileBSP%" == "1" (

	echo .
	echo .
	echo ###########################################
	echo 		COMPILE BSP
	echo ###########################################
	echo .
	echo .
	
	copy "%mapsourcepath%%mapname%.map" "%bsppath%%mapname%.map"
	"%treepath%bin\cod4map" -platform pc -loadFrom "%mapsourcepath%%mapname%.map" %parmBSPOptions% "%bsppath%%mapname%"
)

if "%compileLight%" == "1" (
	
	echo .
	echo .
	echo ###########################################
	echo 		COMPILE LIGHT
	echo ###########################################
	echo .
	echo .

	IF EXIST "%mapsourcepath%%mapname%.grid"	copy "%mapsourcepath%%mapname%.grid" "%bsppath%%mapname%.grid"
	"%treepath%bin\cod4rad" -platform pc %parmLightOptions% "%bsppath%%mapname%"
)

IF EXIST "%bsppath%%mapname%.map"	del "%bsppath%%mapname%.map"
IF EXIST "%bsppath%%mapname%.d3dprt"	del "%bsppath%%mapname%.d3dprt"
IF EXIST "%bsppath%%mapname%.d3dpoly"	del "%bsppath%%mapname%.d3dpoly"
IF EXIST "%bsppath%%mapname%.vclog"	del "%bsppath%%mapname%.vclog"
IF EXIST "%bsppath%%mapname%.grid"	del "%bsppath%%mapname%.grid"

IF EXIST "%bsppath%%mapname%.lin"	move "%bsppath%%mapname%.lin" "%mapsourcepath%%mapname%.lin"

if "%compilePaths%" == "1" (
	
	echo .
	echo .
	echo ###########################################
	echo 		CONNECTING PATHS
	echo ###########################################
	echo .
	echo .

	cd %treepath%
	sp_tool.exe +set r_fullscreen 0 +set logfile 2 +set monkeytoy 0 +set com_introplayed 1 +set usefastfile 0 +set g_connectpaths 2 +devmap %mapname%

)

echo .
echo .
echo ###########################################
echo 		       DONE
echo ###########################################
echo .
echo .
pause