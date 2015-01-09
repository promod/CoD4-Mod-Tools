#include maps\_vehicle;
#using_animtree( "vehicles" );
main( model, type, no_death )
{
	build_template( "van", model, type );
	build_localinit( ::init_local );
	build_deathmodel( "vehicle_uaz_van", "vehicle_uaz_van" );
	build_radiusdamage( (0,0,32) , 300, 200, 100, false );
	build_drive( %uaz_driving_idle_forward, %uaz_driving_idle_backward, 10 );
	build_deathquake( 1, 1.6, 500 );
	build_treadfx();
	build_life( 999, 500, 1500 );
	build_team( "axis" );
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
	for( i=0;i<2;i++ )
		positions[ i ] = spawnstruct();

	positions[ 0 ].sittag = "tag_driver";
	positions[ 1 ].sittag = "tag_passenger";	 

	positions[ 0 ].idle = %uaz_driver_idle_drive;
	positions[ 1 ].idle = %uaz_passenger_idle_drive;

	return positions;
} 
  
  
  
  
  
  
  
  
  
  
  