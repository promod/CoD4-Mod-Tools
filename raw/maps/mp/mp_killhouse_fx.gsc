main()
{
//	level._effect[ "wood" ]				 = loadfx( "explosions/grenadeExp_wood" );
//	level._effect[ "dust" ]				 = loadfx( "explosions/grenadeExp_dirt_1" );
//	level._effect[ "brick" ]			 = loadfx( "explosions/grenadeExp_concrete_1" );

	level._effect[ "paper_falling_burning" ]			= loadfx( "misc/paper_falling_burning" );
	level._effect[ "ground_smoke_launch_a" ]			= loadfx( "smoke/ground_smoke_launch_a" );
	level._effect[ "amb_dust_hangar" ]					= loadfx( "dust/amb_dust_hangar_mp" );
	level._effect[ "light_shaft_dust_large" ]			= loadfx( "dust/light_shaft_dust_large" );
	level._effect[ "light_shaft_dust_med" ]				= loadfx( "dust/light_shaft_dust_med" );


/#		
	if ( getdvar( "clientSideEffects" ) != "1" )
		maps\createfx\mp_killhouse_fx::main();
#/

}
