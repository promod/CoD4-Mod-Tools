#include maps\_anim;
#using_animtree( "generic_human" );
main()
{
	level.scr_anim[ "civiliandriver_car1" ][ "idle" ][ 0 ]	= %bm21_driver_idle;
	level.scr_anim[ "civiliandriver_car2" ][ "idle" ][ 0 ]	= %bm21_driver_idle;
	
	level.scr_anim[ "civiliandriver_car1" ][ "hijack" ]		= %ac130_carjack_driver_1a;
	level.scr_anim[ "civiliandriver_car2" ][ "hijack" ]		= %ac130_carjack_driver_1b;
	
	level.scr_anim[ "hijacker_car1_guy1" ][ "hijack" ]		= %ac130_carjack_1a;
	level.scr_anim[ "hijacker_car1_guy2" ][ "hijack" ]		= %ac130_carjack_2;
	level.scr_anim[ "hijacker_car1_guy3" ][ "hijack" ]		= %ac130_carjack_3;
	level.scr_anim[ "hijacker_car1_guy4" ][ "hijack" ]		= %ac130_carjack_4;
	addNotetrack_customFunction( "hijacker_car1_guy1", "start_others", maps\ac130_code::do_hijack_others );
	
	level.scr_anim[ "hijacker_car2_guy1" ][ "hijack" ]		= %ac130_carjack_1b;
	level.scr_anim[ "hijacker_car2_guy2" ][ "hijack" ]		= %ac130_carjack_2;
	level.scr_anim[ "hijacker_car2_guy3" ][ "hijack" ]		= %ac130_carjack_3;
	level.scr_anim[ "hijacker_car2_guy4" ][ "hijack" ]		= %ac130_carjack_4;
	addNotetrack_customFunction( "hijacker_car2_guy1", "start_others", maps\ac130_code::do_hijack_others );
	
	level.scr_anim[ "hijacker_car1_guy1" ][ "idle" ][ 0 ]	= %bm21_driver_idle;
	level.scr_anim[ "hijacker_car1_guy2" ][ "idle" ][ 0 ]	= %technical_passenger_idle;
	level.scr_anim[ "hijacker_car1_guy3" ][ "idle" ][ 0 ]	= %technical_passenger_idle;
	level.scr_anim[ "hijacker_car1_guy4" ][ "idle" ][ 0 ]	= %technical_passenger_idle;
	
	level.scr_anim[ "hijacker_car2_guy1" ][ "idle" ][ 0 ]	= %bm21_driver_idle;
	level.scr_anim[ "hijacker_car2_guy2" ][ "idle" ][ 0 ]	= %technical_passenger_idle;
	level.scr_anim[ "hijacker_car2_guy3" ][ "idle" ][ 0 ]	= %technical_passenger_idle;
	level.scr_anim[ "hijacker_car2_guy4" ][ "idle" ][ 0 ]	= %technical_passenger_idle;
	
	level.scr_anim[ "hijacker_car1_guy1" ][ "getout" ]		= %pickup_driver_climb_out;
	level.scr_anim[ "hijacker_car1_guy2" ][ "getout" ]		= %pickup_passenger_climb_out;
	level.scr_anim[ "hijacker_car1_guy3" ][ "getout" ]		= %pickup_passenger_RR_climb_out;
	level.scr_anim[ "hijacker_car1_guy4" ][ "getout" ]		= %pickup_passenger_RL_climb_out;
	
	level.scr_anim[ "hijacker_car2_guy1" ][ "getout" ]		= %pickup_driver_climb_out;
	level.scr_anim[ "hijacker_car2_guy2" ][ "getout" ]		= %pickup_passenger_climb_out;
	level.scr_anim[ "hijacker_car2_guy3" ][ "getout" ]		= %pickup_passenger_RR_climb_out;
	level.scr_anim[ "hijacker_car2_guy4" ][ "getout" ]		= %pickup_passenger_RL_climb_out;
}