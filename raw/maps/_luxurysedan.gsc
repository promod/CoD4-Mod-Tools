#include maps\_vehicle_aianim;
#include maps\_vehicle;
#using_animtree( "vehicles" );
main( model, type )
{
	build_template( "luxurysedan",  model,  type );
	build_localinit( ::init_local );
	build_deathmodel( "vehicle_luxurysedan",  "vehicle_luxurysedan_destroy" );
	build_deathmodel( "vehicle_luxurysedan_test",  "vehicle_luxurysedan_destroy" );
	build_deathmodel( "vehicle_luxurysedan_viewmodel",  "vehicle_luxurysedan_destroy" );
	build_deathfx( "explosions/large_vehicle_explosion", undefined, "explo_metal_rand" );

	build_drive( %technical_driving_idle_forward, %technical_driving_idle_backward, 10 );
	build_treadfx();
	build_life( 999,  500,  1500 );
	build_team( "allies" );
	build_aianims( ::setanims , ::set_vehicle_anims );
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

	for( i=0;i<1;i++ )
		positions[ i ] = spawnstruct();
	positions[ 0 ].sittag = "tag_driver";
	positions[ 0 ].idle= %luxurysedan_driver_idle;

	return positions;
}

