#include common_scripts\utility;
#include maps\_utility;
#include maps\_ac130;
#using_animtree( "generic_human" );
precacheLevelStuff()
{
	//setdvar( "ac130_hud_text_misc", "0" );
	//setdvar( "ac130_hud_text_thermal", "0" );
	//setdvar( "ac130_hud_text_weapons", "0" );
	//setdvar( "ac130_target_markers", "1" );
	
	precacheShader( "popmenu_bg" );
	
	level.scr_anim[ "guy" ][ "patrol_walk" ] = %patrol_bored_patrolwalk;
	
	// Set scan range.
	level.scr_radio[ "ac130_plt_scanrange" ] = "ac130_plt_scanrange";
	
	// Recalibrate azimuth sweep angle. Adjust elevation scan.
	level.scr_radio[ "ac130_plt_azimuthsweep" ] = "ac130_plt_azimuthsweep";
	
	// Roger that.
	level.scr_radio[ "ac130_tvo_rogerthat" ] = "ac130_tvo_rogerthat";
	
	// Cleared to engage all of those.
	level.scr_radio[ "ac130_plt_clearedtoengage" ] = "ac130_plt_clearedtoengage";
	
	// Copy, smoke ‘em.
	level.scr_radio[ "ac130_plt_copysmoke" ] = "ac130_plt_copysmoke";
	
	// Ka-boom.
	level.scr_radio[ "ac130_fco_kaboom" ] = "ac130_fco_kaboom";
	
	// We got a vehicle on the move.
	level.scr_radio[ "ac130_fco_vehicleonmove" ] = "ac130_fco_vehicleonmove";
	
	// You are cleared to engage the moving vehicle.
	level.scr_radio[ "ac130_plt_engvehicle" ] = "ac130_plt_engvehicle";
	
	// Confirmed, vehicle neutralized.
	level.scr_radio[ "ac130_fco_confirmed" ] = "ac130_fco_confirmed";
	
	// More enemy personnel.
	level.scr_radio[ "ac130_fco_moreenemy" ] = "ac130_fco_moreenemy";
	
	// Cleared to engage all of those.
	level.scr_radio[ "ac130_plt_clearedtoengage" ] = "ac130_plt_clearedtoengage";
	
	// Hot damn!
	level.scr_radio[ "ac130_fco_hotdamn3" ] = "ac130_fco_hotdamn3";
	
	// Man these guys are goin' to town!
	level.scr_radio[ "ac130_fco_gointotown" ] = "ac130_fco_gointotown";
	
	// Crew, go ahead and smoke ‘em.
	level.scr_radio[ "ac130_fco_smokeem" ] = "ac130_fco_smokeem";
	
	// Rollin' in
	level.scr_radio[ "ac130_plt_rollinin" ] = "ac130_plt_rollinin";
	
	// Right there...tracking.
	level.scr_radio[ "ac130_fco_rightthere" ] = "ac130_fco_rightthere";
	
	// There's armed personnel running out of the church.
	level.scr_radio[ "ac130_fco_outofchurch" ] = "ac130_fco_outofchurch";
	
	//Hehe, this is gonna be one helluva highlight reel.
	level.scr_radio[ "ac130_fco_highlightreel" ] = "ac130_fco_highlightreel";
	
	// Roger that. Returning to base.
	level.scr_radio[ "ac130_plt_returningbase" ] = "ac130_plt_returningbase";
	
	level.viewMovementSpeed = 1000;
	
	level.weaponClipModels = [];
	level.weaponClipModels[0] = "weapon_saw_clip";
	level.weaponClipModels[1] = "weapon_m16_clip";
	level.weaponClipModels[2] = "weapon_ak47_clip";
	level.weaponClipModels[3] = "weapon_g3_clip";
}

scriptCalls()
{
	//overrides the destrcution FX and tag to be played on
	maps\_vehicle::build_deathfx_override( "luxurysedan", ( "explosions/large_vehicle_explosion_IR" ), "tag_deathfx", "explo_metal_rand" );
	maps\_vehicle::build_deathfx_override( "truck", ( "explosions/large_vehicle_explosion_IR" ), "tag_origin", "explo_metal_rand" );
	maps\_vehicle::build_deathfx_override( "pickup", ( "explosions/large_vehicle_explosion_IR" ), "tag_origin", "explo_metal_rand" );
	maps\_vehicle::build_deathfx_override( "uaz_ac130", ( "explosions/large_vehicle_explosion_IR" ), "tag_origin", "explo_metal_rand" );
	maps\_vehicle::build_deathfx_override( "bmp", ( "explosions/large_vehicle_explosion_IR" ), "tag_origin", "explo_metal_rand" );
	maps\_vehicle::build_deathfx_override( "humvee", ( "explosions/large_vehicle_explosion_IR" ), "tag_origin", "explo_metal_rand" );
	
	maps\_humvee::main( "vehicle_humvee_thermal" );
	maps\_seaknight::main( "vehicle_ch46e_opened_door" );
	maps\_truck::main( "vehicle_pickup_roobars" );
	maps\_luxurysedan::main( "vehicle_luxurysedan" );
	maps\_uaz_ac130::main( "vehicle_uaz_hardtop_thermal" );
	maps\_bmp::main( "vehicle_bmp_thermal" );
	maps\_blackhawk::main( "vehicle_blackhawk_low_thermal" );
	maps\_camera::main( "vehicle_camera" );
	
	maps\_load::main();
	setSavedDvar( "sv_saveOnStartMap", false );
	maps\ac130_snd::main();
	maps\_ac130::init();
	viewInit();
	
	// take away the players control
	level.player freezeControls( true );
	
	flag_set( "clear_to_engage" );
}

viewInit()
{
	// put the ac130 in the first location
	level.ac130.origin = getent( "ac130_waypoint_fight1", "targetname" ).origin;
	level.cameraDummy = spawn( "script_origin", level.ac130.origin );
	thread keepViewOnCameraDummy();
	wait .1;
	setWeapon( "105" );
}

keepViewOnCameraDummy()
{
	for(;;)
	{
		faceAngle = vectorToAngles( level.cameraDummy.origin - level.ac130 getTagOrigin( "tag_player" ) );
		level.player setPlayerAngles( faceAngle );
		wait 0.05;
	}
}

aimViewAtEnt( targetEntity, trackEntity, movementSpeedMultiplier )
{
	level notify( "moving_view" );
	level endon( "moving_view" );
	
	if ( !isdefined( trackEntity ) )
		trackEntity = false;
	
	if ( !isdefined( movementSpeedMultiplier ) )
		movementSpeedMultiplier = 1.0;
	
	dist = distance( level.cameraDummy.origin, targetEntity.origin );
	moveTime = ( dist / ( level.viewMovementSpeed * movementSpeedMultiplier ) );
	if ( moveTime <= 0 )
		return;
	if ( ( moveTime < 2.0 ) && ( movementSpeedMultiplier == 1.0 ) )
		moveTime = 2.0;
	
	if ( trackEntity )
	{
		for(;;)
		{
			level.cameraDummy moveto( targetEntity.origin, moveTime );
			wait 0.1;
		}
	}
	else
	{
		accel = moveTime / 2;
		decel = moveTime / 2;
		level.cameraDummy moveto( targetEntity.origin, moveTime, accel, decel );
		wait moveTime;
		level notify( "view_move_done" );
	}
}

setWhiteHot()
{
	set_vision_set( "ac130", 0 );
	if ( isdefined( level.HUDItem[ "thermal_mode" ] ) )
		level.HUDItem[ "thermal_mode" ] settext ( &"AC130_HUD_THERMAL_WHOT" );
}

setBlackHot()
{
	set_vision_set( "ac130_inverted", 0 );
	if ( isdefined( level.HUDItem[ "thermal_mode" ] ) )
		level.HUDItem[ "thermal_mode" ] settext ( &"AC130_HUD_THERMAL_BHOT" );
}

setWeapon( weaponName )
{
	assert( isdefined( weaponName ) );
	weaponIndex = getWeaponIndex( weaponName );
	assert( isdefined( weaponIndex ) );
	
	level.currentWeapon = level.ac130_weapon[ weaponIndex ].name;
	level.currentWeaponName = level.ac130_weapon[ weaponIndex ].weapon;
	
	level.HUDItem[ "crosshairs" ] setshader ( level.ac130_weapon[ weaponIndex ].overlay, 640, 480 );
	
	thread blink_crosshairs( level.ac130_weapon[ weaponIndex ].weapon );
	thread blink_hud_elem( weaponIndex );
	
	if ( getdvar( "ac130_alternate_controls" ) == "0" )
		setsaveddvar( "cg_fov", level.ac130_weapon[ weaponIndex ].fov );
	
	level.player takeallweapons();
	level.player giveweapon( level.ac130_weapon[ weaponIndex ].weapon );
	level.player switchtoweapon( level.ac130_weapon[ weaponIndex ].weapon );
	setAmmo();
	
	level.player thread play_sound_on_entity( "ac130_weapon_switch" );
}

shootWeapon( numberOfShots )
{
	if ( !isdefined( numberOfShots ) )
		numberOfShots = 1;
	
	for ( i = 0 ; i < numberOfShots ; i++ )
	{
		magicbullet( level.currentWeaponName, level.player getEye(), level.cameraDummy.origin );
		level.player notify( "weapon_fired" );
		wait level.weaponReloadTime[ level.currentWeaponName ];
	}
}

getWeaponIndex( weaponName )
{
	weaponIndex = undefined;
	if ( weaponName == "105" )
		weaponIndex = 0;
	else if ( weaponName == "40" )
		weaponIndex = 1;
	else if ( weaponName == "25" )
		weaponIndex = 2;
	assert( isdefined( weaponIndex ) );
	assert( isdefined( level.ac130_weapon ) );
	assert( isdefined( level.ac130_weapon[ weaponIndex ] ) );
	return weaponIndex;
}

spawnAI( sTargetname )
{
	assert( isdefined( sTargetname ) );
	guy = getent( sTargetname, "targetname" ) stalingradSpawn();
	spawn_failed( guy );
	return guy;
}

forceKillAI( actor )
{
	if ( !isdefined( actor ) )
		return;
	if ( !isalive( actor ) )
		return;
	actor doDamage( actor.health + 100, actor.origin );
}

show_target()
{
	target_set( self, ( 0, 0, 32 ) );
	target_setshader( self, "ac130_hud_target" );
	target_setoffscreenshader( self, "ac130_hud_target_offscreen" );
	
	wait 0.5;
	target_setshader( self, "ac130_hud_target_flash" );
	target_setoffscreenshader( self, "ac130_hud_target_flash" );

	wait 0.2;
	target_setshader( self, "ac130_hud_target" );
	target_setoffscreenshader( self, "ac130_hud_target_offscreen" );

	wait 0.5;
	target_setshader( self, "ac130_hud_target_flash" );
	target_setoffscreenshader( self, "ac130_hud_target_flash" );

	wait 0.2;
	target_setshader( self, "ac130_hud_target" );
	target_setoffscreenshader( self, "ac130_hud_target_offscreen" );

	wait 0.5;
	target_setshader( self, "ac130_hud_target_flash" );
	target_setoffscreenshader( self, "ac130_hud_target_flash" );

	wait 0.2;
	target_setshader( self, "ac130_hud_target" );
	target_setoffscreenshader( self, "ac130_hud_target_offscreen" );

	wait 0.5;
	target_setshader( self, "ac130_hud_target_flash" );
	target_setoffscreenshader( self, "ac130_hud_target_flash" );
	
	wait 0.2;
	target_setshader( self, "ac130_hud_target" );
	target_setoffscreenshader( self, "ac130_hud_target_offscreen" );

	wait 0.5;
	target_setshader( self, "ac130_hud_target_flash" );
	target_setoffscreenshader( self, "ac130_hud_target_flash" );
}
