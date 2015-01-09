#include maps\_vehicle_aianim;
#include maps\_vehicle;
#using_animtree( "vehicles" );
main( model, type )
{
	build_template( "bus", model, type );
	build_localinit( ::init_local );
	build_destructible( "vehicle_bus_destructable" , "vehicle_bus_destructible" );
	build_drive( %bus_driving_idle_forward, %bus_driving_idle_backward, 10 );
	build_treadfx();
	build_life( 999, 500, 1500 );
	build_team( "axis" );
}

init_local()
{
}
