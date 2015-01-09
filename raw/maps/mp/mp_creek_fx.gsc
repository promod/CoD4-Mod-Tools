main()
{
	level._effect[ "leaves_ground_gentlewind" ]	 	= loadfx( "misc/leaves_ground_gentlewind" );	
	level._effect[ "leaves_fall_gentlewind" ]	 	= loadfx( "misc/leaves_fall_gentlewind" );
 	level._effect[ "insects_carcass_runner" ]	 	= loadfx( "misc/insects_carcass_runner" );
 	level._effect[ "fog_daytime" ]					 = loadfx( "weather/fog_daytime" );

	//ambient runners
	level._effect[ "mp_overgrown_insects01" ]	 	= loadfx( "ambient_runners/mp_overgrown_insects01" );
	level._effect[ "mp_overgrown_insects02" ]	 	= loadfx( "ambient_runners/mp_overgrown_insects02" );
	level._effect[ "mp_overgrown_insects03" ]	 	= loadfx( "ambient_runners/mp_overgrown_insects03" );
	level._effect[ "mp_overgrown_insects04" ]	 	= loadfx( "ambient_runners/mp_overgrown_insects04" );
	level._effect[ "mp_overgrown_insects05" ]	 	= loadfx( "ambient_runners/mp_overgrown_insects05" );
	level._effect[ "mp_overgrown_fog_daytime01" ]	= loadfx( "ambient_runners/mp_overgrown_fog_daytime01" );
	level._effect[ "mp_overgrown_leavesfall01" ]	= loadfx( "ambient_runners/mp_overgrown_leavesfall01" );
	level._effect[ "mp_overgrown_leavesground01" ]	= loadfx( "ambient_runners/mp_overgrown_leavesground01" );

	level.scr_sound[ "flak88_explode" ]			 = "flak88_explode";

	level._effect[ "hawks" ]					= loadfx( "misc/hawks" );

	level._effect["sewer_stream_village"]		= loadfx ("distortion/mp_creek_stream");
	level._effect["sewer_stream_village_far"]	= loadfx ("misc/stream_creek_far");
	level._effect["sewer_stream_village_far_fast"]	= loadfx ("distortion/mp_creek_stream_fast");
	
	level._effect["insect_trail_runner"]		= loadfx ("misc/insect_trail_runner");	
	level._effect["toilet_flies"]		= loadfx ("misc/insect_trail_runner");	

	level._effect["waterfall_0"]	= loadfx ("misc/mp_creek_waterfall1");
	level._effect["waterfall_1"]	= loadfx ("misc/mp_creek_waterfall2");
	
	level._effect["waterfall_large"]	= loadfx ("misc/mp_creek_waterfall_large");



	level._effect[ "light_shaft_dust_large_mp_creek" ]	 = loadfx( "dust/light_shaft_dust_large_mp_creek" );	
	level._effect[ "room_dust_200_mp_creek" ]					 = loadfx( "dust/room_dust_200_blend_mp_creek" );	
	level._effect[ "cave_particulates" ]					 = loadfx( "dust/cave_particulates" );	
	level._effect[ "mp_cave_dripping" ]					 = loadfx( "misc/mp_cave_dripping" );

/#
	if ( getdvar( "clientSideEffects" ) != "1" )
		maps\createfx\mp_creek_fx::main();
#/

}
