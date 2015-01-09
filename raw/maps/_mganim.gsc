#include maps\_utility;
#using_animtree("generic_human");

main()
{
	level.mg_animmg = [];

	level.mg_animmg[ "pain_stand" ] = %saw_gunner_pain;
	level.mg_animmg[ "pain_crouch" ] = %saw_gunner_lowwall_pain_01;
	level.mg_animmg[ "pain_prone" ] = %saw_gunner_prone_pain;

	level.mg_animmg[ "bipod_stand_setup" ] = %saw_gunner_runin_M;
	level.mg_animmg[ "bipod_crouch_setup" ] = %saw_gunner_lowwall_runin_M;
	level.mg_animmg[ "bipod_prone_setup" ] = %saw_gunner_prone_runin_M;
}