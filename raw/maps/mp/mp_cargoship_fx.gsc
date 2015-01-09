main()
{
	level._effect[ "wood" ]					 				= loadfx( "explosions/grenadeExp_wood" );
	level._effect[ "dust" ]					 				= loadfx( "explosions/grenadeExp_dirt_1" );
	level._effect[ "brick" ]								= loadfx( "explosions/grenadeExp_concrete_1" );
	level._effect[ "coolaidmanbrick" ]		 				= loadfx( "explosions/grenadeExp_concrete_1" );

	// rainfx
	level._effect[ "rain_heavy_mist" ]		 				= loadfx( "weather/rain_mp_cargoship" );
	level._effect[ "lightning" ]			 				= loadfx( "weather/lightning_mp_farm" );
	level._effect[ "cgoshp_drips" ]			 				= loadfx( "misc/cgoshp_drips" );
	level._effect[ "cgoshp_drips_a" ]		 				= loadfx( "misc/cgoshp_drips_a" );
//	level._effect[ "rain_noise" ]		 					= loadfx( "weather/rain_noise" );
//	level._effect[ "rain_noise_ud" ]		 				= loadfx( "weather/rain_noise_ud" );

	level._effect[ "mp_cargoship_rain_noise01" ]			= loadfx( "ambient_runners/mp_cargoship_rain_noise01" );
	level._effect[ "mp_cargoship_rain_noise02" ]			= loadfx( "ambient_runners/mp_cargoship_rain_noise02" );
	level._effect[ "mp_cargoship_rain_noise03" ]			= loadfx( "ambient_runners/mp_cargoship_rain_noise03" );
	level._effect[ "mp_cargoship_rain_noise04" ]			= loadfx( "ambient_runners/mp_cargoship_rain_noise04" );
	level._effect[ "mp_cargoship_rain_noise05" ]			= loadfx( "ambient_runners/mp_cargoship_rain_noise05" );

	level._effect[ "mp_cargoship_rain_noise_ud01" ]			= loadfx( "ambient_runners/mp_cargoship_rain_noise_ud01" );
	level._effect[ "mp_cargoship_rain_noise_ud02" ]			= loadfx( "ambient_runners/mp_cargoship_rain_noise_ud02" );
	level._effect[ "mp_cargoship_rain_noise_ud03" ]			= loadfx( "ambient_runners/mp_cargoship_rain_noise_ud03" );

	
/#	
	if ( getdvar( "clientSideEffects" ) != "1" )
		maps\createfx\mp_cargoship_fx::main();
#/
}
