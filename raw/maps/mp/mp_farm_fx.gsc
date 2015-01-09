main()
{
	level._effect[ "wood" ]					 = loadfx( "explosions/grenadeExp_wood" );
	level._effect[ "dust" ]					 = loadfx( "explosions/grenadeExp_dirt_1" );
	level._effect[ "brick" ]				 = loadfx( "explosions/grenadeExp_concrete_1" );
	level._effect[ "coolaidmanbrick" ]		 = loadfx( "explosions/grenadeExp_concrete_1" );
	level._effect[ "rain_heavy_mist" ]		 = loadfx( "weather/rain_mp_farm" );
	level._effect[ "lightning" ]			 = loadfx( "weather/lightning_mp_farm" );
	level._effect[ "cgoshp_drips_a" ]		 = loadfx( "misc/cgoshp_drips_a" );

	//ambient runners
	level._effect[ "rain_splash_mp_farm" ]	 = loadfx( "ambient_runners/mp_farm_rain_splash01" );
	level._effect[ "water_noise_ud" ]		 = loadfx( "ambient_runners/mp_farm_water_noise_ud01" );
	level._effect[ "water_noise" ]			 = loadfx( "ambient_runners/mp_farm_water_noise01" );

	
/#
	if ( getdvar( "clientSideEffects" ) != "1" )
		maps\createfx\mp_farm_fx::main();
#/		
}
