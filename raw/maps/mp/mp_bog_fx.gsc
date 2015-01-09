main()
{
	level._effect[ "wood" ]							 = loadfx( "explosions/grenadeExp_wood" );
	level._effect[ "dust" ]							 = loadfx( "explosions/grenadeExp_dirt_1" );
	level._effect[ "brick" ]						 = loadfx( "explosions/grenadeExp_concrete_1" );
	level._effect[ "firelp_barrel_pm" ]				 = loadfx( "fire/firelp_barrel_pm" );
	level._effect[ "antiair_runner" ]				 = loadfx( "misc/antiair_runner_night" );
	level._effect[ "fog_bog_a" ]					 = loadfx( "weather/fog_bog_a" );
	level._effect[ "battlefield_smokebank_S" ]		 = loadfx( "smoke/battlefield_smokebank_bog_a" );
	level._effect[ "mp_bog_horizon_flash" ]			 = loadfx( "ambient_runners/mp_bog_horizon_flash" );

/#
	if ( getdvar( "clientSideEffects" ) != "1" )
		maps\createfx\mp_bog_fx::main();
#/		
}
