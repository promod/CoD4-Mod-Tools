#include maps\_vehicle_aianim;
#include maps\_vehicle;
#using_animtree ("vehicles");
main(model,type)
{
	build_template( "small_wagon", model, type );
	build_localinit( ::init_local );

	build_deathmodel( "vehicle_small_wagon_white", "vehicle_small_wagon_d_white" );  
	build_deathmodel( "vehicle_small_wagon_turq", "vehicle_small_wagon_d_turq" );  
	build_deathmodel( "vehicle_small_wagon_green", "vehicle_small_wagon_d_green" );  
	build_deathmodel( "vehicle_small_wagon_blue", "vehicle_small_wagon_d_blue" );  

	build_destructible( "vehicle_small_wagon_white_destructible" , "vehicle_small_wagon_white" );
	build_destructible( "vehicle_small_wagon_blue_destructible" , "vehicle_small_wagon_blue" );
	build_destructible( "vehicle_small_wagon_green_destructible" , "vehicle_small_wagon_green" );
	build_destructible( "vehicle_small_wagon_turq_destructible" , "vehicle_small_wagon_turq" );

	build_drive( %technical_driving_idle_forward, %technical_driving_idle_backward, 10 );
	build_treadfx();
	build_life ( 999, 500, 1500 );
	build_team( "allies");
	build_aianims( ::setanims , ::set_vehicle_anims );
}

init_local()
{
	
}

set_vehicle_anims(positions)
{
	return positions;
}

#using_animtree ("generic_human");

setanims ()
{
	positions = [];
	return positions; // no anims yet
}

