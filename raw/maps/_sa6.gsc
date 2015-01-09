#include maps\_vehicle_aianim;
#include maps\_vehicle;
#using_animtree( "vehicles" );
main( model, type )
{
	build_template( "sa6", model, type );
	build_localinit( ::init_local );

	build_deathmodel( "vehicle_sa6_no_missiles_desert" );
	build_deathmodel( "vehicle_sa6_no_missiles_woodland" );

	//todo: get this into proper format. these extra commands have tendancy to get lost and not updated  - nate 
	precachemodel( "projectile_sa6_missile_desert" );
	build_deathfx( "explosions/large_vehicle_explosion", undefined, "explo_metal_rand" );
	build_life( 999, 500, 1500 );
	build_team( "allies" );
}

init_local()
{
	
	//these settings should not be per vehicle - nate
	self.missileModel = "projectile_sa6_missile_desert";
	self.missileTags = [];
	self.missileTags[ 0 ] = "tag_missle1";
	self.missileTags[ 1 ] = "tag_missle2";
	self.missileTags[ 2 ] = "tag_missle3";
	thread maps\_vehicle_missile::main();
}

