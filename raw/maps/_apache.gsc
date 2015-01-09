#include maps\_vehicle;
#include maps\_vehicle_aianim;
#using_animtree( "vehicles" );
main( model, type )
{
	build_template( "apache", model, type );
	build_localinit( ::init_local );

	build_deathmodel( "vehicle_apache" );
	build_deathmodel( "vehicle_apache_dark" );

	build_deathfx( "explosions/large_vehicle_explosion", undefined, "explosions/large_vehicle_explosion" );
	
	build_life( 999, 500, 1500 );
	
	build_team( "allies" );

}

init_local()
{
	self.script_badplace = false; //All helicopters dont need to create bad places
}

set_vehicle_anims( positions )
{

	return positions;
}


#using_animtree( "generic_human" );
setanims()
{
	positions = [];
	for( i=0;i<11;i++ )
		positions[ i ] = spawnstruct();

	positions[ 0 ].getout_delete = true;

	return positions;
}

