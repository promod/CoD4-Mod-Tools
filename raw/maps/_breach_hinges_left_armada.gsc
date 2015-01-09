#using_animtree("generic_human");
main()
{
	level.door_objmodel = "com_door_breach_left_obj";	
	precacheModel(level.door_objmodel);	
	/*-----------------------
	SHOTGUN BREACH A (HINGE SHOOT #1)
	-------------------------*/	
	
	level.scr_anim[ "generic" ][ "shotgunhinges_breach_left_stack_start_01" ]			= %breach_sh_breacherL1_idle;
	level.scr_anim[ "generic" ][ "shotgunhinges_breach_left_stack_start_02" ]			= %breach_sh_stackR1_idle;	
	
	level.scr_anim[ "generic" ][ "shotgunhinges_breach_left_stack_idle_01" ][0]		= %breach_sh_breacherL1_idle;
	level.scr_anim[ "generic" ][ "shotgunhinges_breach_left_stack_idle_02" ][0]		= %breach_sh_stackR1_idle;
	
	level.scr_anim[ "generic" ][ "shotgunhinges_breach_left_stack_breach_01" ]			= %breach_sh_breacherL1_enter_A;
	level.scr_anim[ "generic" ][ "shotgunhinges_breach_left_stack_breach_02" ]			= %breach_sh_stackR1_enter_A;

	// animated door breach ==> breach_sh_door
}