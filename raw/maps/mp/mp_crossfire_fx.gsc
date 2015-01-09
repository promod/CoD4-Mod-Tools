main()
{
	level._effect[ "wood" ]				 = loadfx( "explosions/grenadeExp_wood" );
	level._effect[ "dust" ]				 = loadfx( "explosions/grenadeExp_dirt_1" );
	level._effect[ "brick" ]			 = loadfx( "explosions/grenadeExp_concrete_1" );
	
	//Ambient FX
	level._effect["paper_falling"]						= loadfx( "misc/paper_falling" );
	level._effect["battlefield_smokebank_S"]			= loadfx( "smoke/battlefield_smokebank_S" );
	level._effect["thin_black_smoke_M"]					= loadfx( "smoke/thin_black_smoke_M" );
	level._effect["thin_black_smoke_L"]					= loadfx( "smoke/thin_black_smoke_L" );
	level._effect["dust_wind_slow"]						= loadfx( "dust/dust_wind_slow_yel_loop" );

/#		
	if ( getdvar( "clientSideEffects" ) != "1" )
		maps\createfx\mp_crossfire_fx::main();
#/
}
