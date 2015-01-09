#include common_scripts\utility;
#include maps\mp\_utility;

main()
{
	precacheFX();
		
/#
	if ( getdvar( "clientSideEffects" ) != "1" )
		maps\createfx\mp_carentan_fx::main();
#/

}

precacheFX()
{
 	level._effect[ "fog_ground_200" ]					 = loadfx( "weather/fog_ground_200" );
 	level._effect[ "fog_ground_200_red" ]				 = loadfx( "weather/fog_ground_200_red" );
	level._effect[ "hallway_smoke_dark" ]				 = loadfx( "smoke/hallway_smoke_dark" );
	level._effect[ "moth_runner" ]						 = loadfx( "misc/moth_runner" );
	level._effect[ "insects_carcass_runner" ]			 = loadfx( "misc/insects_carcass_runner" );
 	level._effect[ "drips_slow" ]					 	 = loadfx( "misc/drips_slow" );
 	level._effect[ "steam_vent_small" ]					 = loadfx( "smoke/steam_vent_small" );
 	level._effect[ "steam_manhole" ]					 = loadfx( "smoke/steam_manhole" );
 	level._effect[ "chinese_lantern_FX" ]				 = loadfx( "misc/chinese_latern_glow_orange" );
 	level._effect[ "ct_street_lamp_glow_FX" ]			 = loadfx( "misc/ct_street_lamp_glow" );
	
}

	
placeGlows()
{
	
	randomStartDelay = randomfloatrange( -20, -15);
	
	//map_source\prefabs\mp_carentan\lantern01.map
	thread lightGlows( "chinese_lantern_FX_origin", "chinese_lantern_FX", "misc/chinese_latern_glow_orange", randomStartDelay );

	//map_source\prefabs\misc_models\ct_street_lamp_on.map
	thread lightGlows( "ct_street_lamp_glow_FX_origin", "ct_street_lamp_glow_FX", "misc/ct_street_lamp_glow", randomStartDelay );

}

lightGlows( targetname, fxName, fxFile, delay, soundalias )
{
	lev = level;
	if ( !isdefined( level._effect ) )
		lev._effect = [];
	if ( !isdefined( level._effect[ fxName ] ) )
		lev._effect[ fxName ]	= loadfx( fxFile );

	waittillframeend;

	// script_structs
	ents = getstructarray(targetname,"targetname");
	if ( !isdefined( ents ) )
		return;
	if ( ents.size <= 0 )
		return;
	
	for ( i = 0 ; i < ents.size ; i++ )
		ents[i] lightGlows_create( fxName, fxFile, delay, soundalias );
}

lightGlows_create( fxName, fxFile, delay, soundalias )
{
	// default effect angles if they dont exist
	if ( !isdefined( self.angles ) )
		self.angles = ( 0, 0, 0 );
	
	ent = createOneshotEffect( fxName );
	ent.v[ "origin" ] = ( self.origin );
	ent.v[ "angles" ] = ( self.angles );
	ent.v[ "fxid" ] = fxName;
	ent.v[ "delay" ] = delay;
	if ( isdefined( soundalias ) )
	{
		ent.v[ "soundalias" ] = soundalias;
	}
}

