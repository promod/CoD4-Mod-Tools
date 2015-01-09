#include maps\_vehicle_aianim;
#include maps\_vehicle;
#using_animtree( "vehicles" );
main( model, type )
{
	build_template( "small_hatchback", model, type );
	build_localinit( ::init_local );
	
	build_deathmodel( "vehicle_small_hatchback_blue", "vehicle_small_hatchback_d_blue" );
	build_deathmodel( "vehicle_small_hatchback_green", "vehicle_small_hatchback_d_green" );
	build_deathmodel( "vehicle_small_hatchback_turq", "vehicle_small_hatchback_d_turq" );
	build_deathmodel( "vehicle_small_hatchback_white", "vehicle_small_hatchback_d_white" );

	build_destructible( "vehicle_small_hatch_blue_destructible" , "vehicle_small_hatch_blue" );
	build_destructible( "vehicle_small_hatch_green_destructible" , "vehicle_small_hatch_green" );
	build_destructible( "vehicle_small_hatch_turq_destructible" , "vehicle_small_hatch_turq" );
	build_destructible( "vehicle_small_hatch_white_destructible" , "vehicle_small_hatch_white" );

 	build_deathfx( "explosions/large_vehicle_explosion", undefined, "explo_metal_rand" );

	build_treadfx();
	build_life( 999, 500, 1500 );
	build_team( "allies" );
	build_aianims( ::setanims, ::set_vehicle_anims );
}

init_local()
{
	
}

set_vehicle_anims( positions )
{
	return positions;
}

#using_animtree( "generic_human" );
setanims()
{
	positions = [];
	return positions;
}

