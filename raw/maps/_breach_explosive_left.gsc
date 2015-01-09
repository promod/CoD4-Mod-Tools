#using_animtree("generic_human");
main()
{
	/*-----------------------
	EXPLOSIVE BREACH (LEFT SIDE)
	-------------------------*/	
	level.maxDetpackDamage = 100;	//max damage done by breach detpacks
	level.minDetpackDamage = 50;	//max damage done by breach detpacks
	level.detpackStunRadius = 250;	//how close enemies have to be to detpack to be stunned
	level.door_objmodel = "com_door_breach_left_obj";	
	level.stunnedAnimNumber = 1;
	
	precacheModel(level.door_objmodel);	
	precacheModel("weapon_detcord");

	level.scr_anim[ "generic" ][ "detcord_stack_left_start_01" ]		= %breach_stackL_approach;
	level.scr_anim[ "generic" ][ "detcord_stack_left_start_02" ]		= %breach_explosive_approach;	

	level.scr_anim[ "generic" ][ "detcord_stack_left_start_no_approach_01" ]		= %explosivebreach_v1_stackL_idle;
	level.scr_anim[ "generic" ][ "detcord_stack_left_start_no_approach_02" ]		= %explosivebreach_v1_detcord_idle;	
		
	level.scr_anim[ "generic" ][ "detcord_stack_leftidle_01" ][0]		= %explosivebreach_v1_stackL_idle;
	level.scr_anim[ "generic" ][ "detcord_stack_leftidle_02" ][0]		= %explosivebreach_v1_detcord_idle;
	
	level.scr_anim[ "generic" ][ "detcord_stack_leftbreach_01" ]		= %explosivebreach_v1_stackL;
	level.scr_anim[ "generic" ][ "detcord_stack_leftbreach_02" ]		= %explosivebreach_v1_detcord;

	level.scr_anim[ "generic" ][ "exposed_flashbang_v1" ]			= %exposed_flashbang_v1;
	level.scr_anim[ "generic" ][ "exposed_flashbang_v2" ]			= %exposed_flashbang_v2;

}