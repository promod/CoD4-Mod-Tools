#using_animtree("generic_human");
main()
{
	level.iFlashFuse = 1;			//how long before friendly-throw flashbangs detonate
	
	/*-----------------------
	NO DOOR, FLASH ONLY BREACH (RIGHT SIDE)
	-------------------------*/	

	level.scr_anim[ "generic" ][ "flash_stack_right_start_01" ]		= %breach_flash_R1_idle;
	level.scr_anim[ "generic" ][ "flash_stack_right_start_02" ]		= %breach_flash_R2_idle;	
	level.scr_anim[ "generic" ][ "flash_stack_right_start_single" ]	= %test_breach_R_idle;
	
	level.scr_anim[ "generic" ][ "flash_stack_right_idle_01" ][0]		= %breach_flash_R1_idle;
	level.scr_anim[ "generic" ][ "flash_stack_right_idle_02" ][0]		= %breach_flash_R2_idle;
	level.scr_anim[ "generic" ][ "flash_stack_right_idle_single" ][0]	= %test_breach_R_idle;
	
	level.scr_anim[ "generic" ][ "flash_stack_right_flash_01" ]		= %breach_flash_R1_throw;
	level.scr_anim[ "generic" ][ "flash_stack_right_flash_02" ]		= %breach_flash_R2_throw;
	level.scr_anim[ "generic" ][ "flash_stack_right_flash_single" ]	= %test_breach_R_flashbang;
	
	level.scr_anim[ "generic" ][ "flash_stack_right_breach_01" ]		= %breach_flash_R1_enter;
	level.scr_anim[ "generic" ][ "flash_stack_right_breach_02" ]		= %breach_flash_R2_enter;
	level.scr_anim[ "generic" ][ "flash_stack_right_breach_single" ]	= %test_breach_R_enter;
}