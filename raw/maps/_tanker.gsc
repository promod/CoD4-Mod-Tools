#include maps\_vehicle_aianim;
#include maps\_vehicle;
#using_animtree( "vehicles" );
main( model, type )
{
	build_template( "tanker", model, type );
	build_localinit( ::init_local );
	build_deathfx( "explosions/large_vehicle_explosion", undefined, "explo_metal_rand" );
	build_treadfx();
	build_life( 999, 500, 1500 );
	build_drive( %tanker_truck_driving_idle_forward, %tanker_truck_driving_idle_backward, 10 );

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

