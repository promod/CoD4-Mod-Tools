main()
{
	level._effect[ "snow_light" ]		 = loadfx( "weather/snow_light_mp_bloc" );
	level._effect[ "hallway_smoke" ]	 = loadfx( "smoke/hallway_smoke_light" );
	level._effect[ "snow_wind" ]		 = loadfx( "weather/snow_wind" );

/#
	if ( getdvar( "clientSideEffects" ) != "1" )
		maps\createfx\mp_bloc_fx::main();
#/		
}
