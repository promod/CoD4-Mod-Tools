main()
{

	level._effect[ "fog_bog_a" ]						 = loadfx( "weather/fog_bog_a" );
	level._effect[ "amb_ash" ]							 = loadfx( "smoke/amb_ash" );
	level._effect[ "floodlight_white" ]					 = loadfx( "misc/floodlight_white" );
	level._effect[ "floodlight_yellow" ]				 = loadfx( "misc/floodlight_yellow" );
	level._effect[ "fluorescent_glow" ]					 = loadfx( "misc/fluorescent_glow" );

/#
	if ( getdvar( "clientSideEffects" ) != "1" )	
		maps\createfx\mp_citystreets_fx::main();
#/
}

