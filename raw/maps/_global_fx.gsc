#include common_scripts\utility;
#include maps\_utility;

	// This script automaticly plays a users specified oneshot effect on all prefabs that have the 
	// specified "script_struct" and "targetname" It also excepts angles from the "script_struct" 
	// but will set a default angle of ( 0, 0, 0 ) if none is defined.
	//
	// example of the syntax: 
	// global_FX( "targetname", "fxIDname", "fxFile", "delay"
	
main()
{
	level._global_fx_ents = [];	
	randomStartDelay = randomfloatrange( -20, -15);
	
	//map_source/prefabs/misc_models/com_barrel_fire.map
	global_FX( "barrel_fireFX_origin", "global_barrel_fire", "fire/firelp_barrel_pm", randomStartDelay, "fire_barrel_small" );

	//map_source/prefabs/misc_models/ch_street_light_02_on.map
	//prefabs/misc_models/ch_street_wall_light_01_on.map
	global_FX( "ch_streetlight_02_FX_origin", "ch_streetlight_02_FX", "misc/lighthaze", randomStartDelay );

	//prefabs/misc_models/me_streetlight_on.map
	//prefabs/misc_models/me_streetlight_on_scaleddown80.map
	global_FX( "me_streetlight_01_FX_origin", "me_streetlight_01_FX", "misc/lighthaze_bog_a", randomStartDelay );

	//prefabs\village_assault\misc\lamp_post.map
	global_FX( "ch_street_light_01_on", "lamp_glow_FX", "misc/light_glow_white", randomStartDelay );

	//prefabs\village_assault\misc\highway_lamp_post.map
	global_FX( "highway_lamp_post", "ch_streetlight_02_FX", "misc/lighthaze_villassault", randomStartDelay );
	
	//prefabs/misc_models/cs_cargoship_spotlight_on.map
	global_FX( "cs_cargoship_spotlight_on_FX_origin", "cs_cargoship_spotlight_on_FX", "misc/lighthaze", randomStartDelay );

	//prefabs/misc_models/me_dumpster_fire.map
	global_FX( "me_dumpster_fire_FX_origin", "me_dumpster_fire_FX", "fire/firelp_med_pm", randomStartDelay, "fire_dumpster_medium" );
 
	//map_source/prefabs/misc_models/com_tires01_burning.map
	global_FX( "com_tires_burning01_FX_origin", "com_tires_burning01_FX", "fire/tire_fire_med", randomStartDelay );

	//map_source/prefabs/icbm/icbm_powerlinetower02.map
	global_FX( "icbm_powerlinetower_FX_origin", "icbm_powerlinetower_FX", "misc/power_tower_light_red_blink", randomStartDelay );

	//map_source/prefabs/icbm/icbm_powerlinetower02.map
	global_FX( "icbm_mainframe_FX_origin", "icbm_mainframe_FX", "props/icbm_mainframe_lightblink", randomStartDelay );

	//map_source/prefabs/misc_model/cs_cargoship_wall_light_red_pulse.map
	global_FX( "light_pulse_red_FX_origin", "light_pulse_red_FX", "misc/light_glow_red_generic_pulse", -2 );

	//map_source/prefabs/misc_model/cs_cargoship_wall_light_red_pulse.map
	global_FX( "light_pulse_red_FX_origin", "light_pulse_red_FX", "misc/light_glow_red_generic_pulse", -2 );

	//map_source/prefabs/misc_model/cs_cargoship_wall_light_orange_pulse.map
	global_FX( "light_pulse_orange_FX_origin", "light_pulse_orange_FX", "misc/light_glow_orange_generic_pulse", -2 );

}

global_FX( targetname, fxName, fxFile, delay, soundalias )
{
	// script_structs
	ents = getstructarray(targetname,"targetname");
	if ( !isdefined( ents ) )
		return;
	if ( ents.size <= 0 )
		return;
	
	for ( i = 0 ; i < ents.size ; i++ )
	{
		ent = ents[i] global_FX_create( fxName, fxFile, delay, soundalias );
		if ( !isdefined( ents[ i ].script_noteworthy ) )
			continue;
			
		note = ents[ i ].script_noteworthy;
		if ( !isdefined( level._global_fx_ents[ note ] ) )
		{
			level._global_fx_ents[ note ] = [];
		}
		
		level._global_fx_ents[ note ][ level._global_fx_ents[ note ].size ] = ent;
	}
}

global_FX_create( fxName, fxFile, delay, soundalias )
{
	if ( !isdefined( level._effect ) )
		level._effect = [];
	if ( !isdefined( level._effect[ fxName ] ) )
		level._effect[ fxName ]	= loadfx( fxFile );
	
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
	return ent;	
}