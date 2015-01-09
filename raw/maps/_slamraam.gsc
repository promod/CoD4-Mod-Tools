#include maps\_vehicle;
#include maps\_vehicle_aianim;
#using_animtree( "vehicles" );
main( model, type )
{
	build_template( "slamraam", model, type );
	build_localinit( ::init_local );

	build_deathmodel( "vehicle_slamraam" );

	// nate - lets fix this up.
	precachemodel( "projectile_slamraam_missile" );

	build_deathfx( "explosions/large_vehicle_explosion", undefined, "explo_metal_rand" );
	build_life( 999, 500, 1500 );
	build_team( "allies" );
}

init_local()
{
	self.missileModel = "projectile_slamraam_missile";
	self.missileTags = [];
	self.missileTags[ 0 ] = "tag_missle1";
	self.missileTags[ 1 ] = "tag_missle2";
	self.missileTags[ 2 ] = "tag_missle3";
	self.missileTags[ 3 ] = "tag_missle4";
	self.missileTags[ 4 ] = "tag_missle5";
	self.missileTags[ 5 ] = "tag_missle6";
	self.missileTags[ 6 ] = "tag_missle7";
	self.missileTags[ 7 ] = "tag_missle8";
	
	thread maps\_vehicle_missile::main();
}

