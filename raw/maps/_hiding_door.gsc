#include maps\_anim;
#include maps\_utility;
#using_animtree( "script_model" );
main()
{
	//level.scr_anim[ "chair" ][ "chair_react" ]					= %parabolic_guard_sleeper_react_chair;
	//level.scr_animtree[ "chair" ] 								= #animtree;	
	//level.scr_model[ "chair" ] 									= "com_folding_chair";

	level.scr_animtree[ "hiding_door" ] 						= #animtree;	
	level.scr_model[ "hiding_door" ] 							= "com_door_01_handleleft";

	level.scr_anim[ "hiding_door" ][ "close" ]					= %doorpeek_close_door;
	level.scr_anim[ "hiding_door" ][ "death_1" ]				= %doorpeek_deathA_door;
	level.scr_anim[ "hiding_door" ][ "death_2" ]				= %doorpeek_deathB_door;

	level.scr_anim[ "hiding_door" ][ "fire_1" ]					= %doorpeek_fireA_door;
	level.scr_anim[ "hiding_door" ][ "fire_2" ]					= %doorpeek_fireB_door;
	level.scr_anim[ "hiding_door" ][ "fire_3" ]					= %doorpeek_fireC_door;
	
	level.scr_anim[ "hiding_door" ][ "grenade" ]				= %doorpeek_grenade_door;

	level.scr_anim[ "hiding_door" ][ "idle" ][ 0 ]				= %doorpeek_idle_door;
	level.scr_anim[ "hiding_door" ][ "jump" ]					= %doorpeek_jump_door;
	level.scr_anim[ "hiding_door" ][ "kick" ]					= %doorpeek_kick_door;
	level.scr_anim[ "hiding_door" ][ "open" ]					= %doorpeek_open_door;
	precachemodel( level.scr_model[ "hiding_door" ] );


	addNotetrack_sound( "hiding_door", "sound door death", "any", "scn_doorpeek_door_open_death" );
	addNotetrack_sound( "hiding_door", "sound door open", "any", "scn_doorpeek_door_open" );
	addNotetrack_sound( "hiding_door", "sound door slam", "any", "scn_doorpeek_door_slam" );
	main_guy();
	thread notetracks();
}

#using_animtree("generic_human");
main_guy()
{

	level.scr_anim[ "hiding_door_guy" ][ "close" ]				= %doorpeek_close;
	level.scr_anim[ "hiding_door_guy" ][ "death_1" ]			= %doorpeek_deathA;
	level.scr_anim[ "hiding_door_guy" ][ "death_2" ]			= %doorpeek_deathB;

	level.scr_anim[ "hiding_door_guy" ][ "fire_1" ]				= %doorpeek_fireA;
	level.scr_anim[ "hiding_door_guy" ][ "fire_2" ]				= %doorpeek_fireB;
	level.scr_anim[ "hiding_door_guy" ][ "fire_3" ]				= %doorpeek_fireC;
	
	level.scr_anim[ "hiding_door_guy" ][ "grenade" ]			= %doorpeek_grenade;
	
	level.scr_anim[ "hiding_door_guy" ][ "idle" ][ 0 ]			= %doorpeek_idle;
	level.scr_anim[ "hiding_door_guy" ][ "jump" ]				= %doorpeek_jump;
	level.scr_anim[ "hiding_door_guy" ][ "kick" ]				= %doorpeek_kick;
	level.scr_anim[ "hiding_door_guy" ][ "open" ]				= %doorpeek_open;
}

notetracks()
{
	wait 0.05;
	maps\_anim::addNotetrack_customFunction( "hiding_door_guy", "grenade_throw", maps\_spawner::hiding_door_guy_grenade_throw );
}