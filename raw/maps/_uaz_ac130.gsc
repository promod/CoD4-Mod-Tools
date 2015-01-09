#include maps\_vehicle_aianim;
#include maps\_vehicle;
#using_animtree( "vehicles" );
main( model, type )
{
	build_template( "uaz_ac130", model, type );
	build_localinit( ::init_local );
	
	build_deathmodel( "vehicle_uaz_hardtop_thermal", "vehicle_uaz_hardtop_thermal" );
	
	build_radiusdamage( (0,0,32) , 300, 200, 100, false );
	build_deathfx( "explosions/small_vehicle_explosion", undefined, "explo_metal_rand" );
	build_drive( %uaz_driving_idle_forward, %uaz_driving_idle_backward, 10 );
	build_deathquake( 1, 1.6, 500 );
	
	build_treadfx();
	build_life( 999, 500, 1500 );
	build_team( "axis" );
	build_aianims( ::setanims , ::set_vehicle_anims );
}

init_local()
{
	maps\_uaz::init_local();
}

set_vehicle_anims( positions )
{
	return maps\_uaz::set_vehicle_anims( positions );
}

setanims()
{
	return maps\_uaz::setanims();
}