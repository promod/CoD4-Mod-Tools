#include maps\_vehicle_aianim;
#include maps\_vehicle;
#using_animtree( "vehicles" );
main( model, type )
{
	build_template( "camera", model, type );
	build_localinit( ::init_local );
	build_deathmodel( "vehicle_camera" );
}

init_local()
{
}
