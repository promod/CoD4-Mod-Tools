@ECHO OFF

set treepath=%~1
set mapname=%2
set mpmap=%3

cd %treepath%
if "%mpmap%" == "1" (
	mp_tool.exe +set r_fullscreen 0 +set loc_warnings 0 +set +set developer 1 +set logfile 2 +set thereisacow 1337 +set sv_pure 0 +set com_introplayed 1 +set useFastFile 0 +set ui_autoContinue 1 +set r_reflectionProbeGenerateExit 1+set com_hunkMegs 512 +set r_reflectionProbeRegenerateAll 1 +set r_dof_enable 0 +set r_zFeather 1 +set sys_smp_allowed 0 +set r_reflectionProbeGenerate 1 +devmap %mapname%
) else (
	sp_tool.exe +set r_fullscreen 0 +set loc_warnings 0 +set +set developer 1 +set logfile 2 +set thereisacow 1337 +set com_introplayed 1 +set useFastFile 0 +set ui_autoContinue 1 +set r_reflectionProbeGenerateExit 1+set com_hunkMegs 512 +set r_reflectionProbeRegenerateAll 1 +set r_dof_enable 0 +set r_zFeather 1 +set sys_smp_allowed 0 +set r_reflectionProbeGenerate 1 +devmap %mapname%
)

cls