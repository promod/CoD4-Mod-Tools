#include maps\_utility;
#include common_scripts\utility;
#using_animtree("ac130");
init()
{
	setsaveddvar( "scr_dof_enable", "0" );
//	flag_clear( "nightvision_enabled" );
	
	level.ac130 = spawn( "script_model", level.player getOrigin() );
	level.ac130 setModel( "c130_zoomrig" );
	level.ac130.angles = ( 0, 115, 0 );
	level.ac130 hide();
	
	if ( getdvar( "ac130_enabled" ) == "" )
		setdvar( "ac130_enabled", "1" );
	
	if ( getdvar( "ac130_post_effects_enabled" ) == "" )
		setdvar( "ac130_post_effects_enabled", "1" );
	
	if ( getdvar( "ac130_debug_weapons" ) == "" )
		setdvar( "ac130_debug_weapons", "0" );
	
	if ( getdvar( "ac130_debug_context_sensative_dialog" ) == "" )
		setdvar( "ac130_debug_context_sensative_dialog", "0" );
	
	if ( getdvar( "ac130_debug_friendly_count" ) == "" )
		setdvar( "ac130_debug_friendly_count", "0" );
	
	if ( getdvar( "ac130_hud_text_misc" ) == "" )
		setdvar( "ac130_hud_text_misc", "1" );
	
	if ( getdvar( "ac130_hud_text_thermal" ) == "" )
		setdvar( "ac130_hud_text_thermal", "1" );
	
	if ( getdvar( "ac130_hud_text_weapons" ) == "" )
		setdvar( "ac130_hud_text_weapons", "1" );
	
	if ( getdvar( "ac130_target_markers" ) == "" )
		setdvar( "ac130_target_markers", "0" );
	
	//0 - player can freely engage targets before being authorized
	//1 - player fails the mission for engage targets before being authorized
	//2 - player gets red X over crosshairs when trying to fire before being authorized
	if ( getdvar( "ac130_pre_engagement_mode" ) == "" )
		setdvar( "ac130_pre_engagement_mode", "2" );
	
	if ( getdvar( "ac130_alternate_controls" ) == "" )
		setdvar( "ac130_alternate_controls", "0" );
	
	if ( getdvar( "ac130_ragdoll_deaths" ) == "" )
		setdvar( "ac130_ragdoll_deaths", "1" );
	
	precacheShader( "ac130_overlay_25mm" );
	precacheShader( "ac130_overlay_40mm" );
	precacheShader( "ac130_overlay_105mm" );
	precacheShader( "ac130_overlay_grain" );
	precacheShader( "ac130_overlay_nofire" );
	precacheShader( "ac130_hud_target" );
	precacheShader( "ac130_hud_target_flash" );
	precacheShader( "ac130_hud_target_offscreen" );
	precacheShader( "ac130_friendly_fire_icon" );
	precacheShader( "black" );
	
	precacheString( &"AC130_HUD_TOP_BAR" );
	precacheString( &"AC130_HUD_LEFT_BLOCK" );
	precacheString( &"AC130_HUD_RIGHT_BLOCK" );
	precacheString( &"AC130_HUD_BOTTOM_BLOCK" );
	precacheString( &"AC130_HUD_THERMAL_WHOT" );
	precacheString( &"AC130_HUD_THERMAL_BHOT" );
	precacheString( &"AC130_HUD_WEAPON_105MM" );
	precacheString( &"AC130_HUD_WEAPON_40MM" );
	precacheString( &"AC130_HUD_WEAPON_25MM" );
	precacheString( &"AC130_HUD_AGL" );
	
	if (getdvar("ac130_alternate_controls") == "0")
	{
		precacheItem("ac130_25mm");
		precacheItem("ac130_40mm");
		precacheItem("ac130_105mm");
	}
	else
	{
		precacheItem("ac130_25mm_alt");
		precacheItem("ac130_40mm_alt");
		precacheItem("ac130_105mm_alt");
	}
	
	precacheShellShock("ac130");
	
	level._effect[ "cloud" ] = loadfx( "misc/ac130_cloud" );
	level._effect[ "beacon" ] = loadfx( "misc/ir_beacon" );
	
	level.custom_friendly_fire_message = "@AC130_FRIENDLY_FIRE";
	level.custom_friendly_fire_shader = "ac130_friendly_fire_icon";
	
	level.spawnerCallbackThread = ::spawn_callback_thread;
	level.vehicleSpawnCallbackThread = ::context_Sensative_Dialog_VehicleSpawn;
	
	level.enemiesKilledInTimeWindow = 0;
	
	level.radioForcedTransmissionQueue = [];
	
	level.lastRadioTransmission = getTime();
	
	level.color[ "white" ] = ( 1, 1, 1 );
	level.color[ "red" ] = ( 1, 0, 0 );
	level.color[ "blue" ] = ( .1, .3, 1 );
	
	level.cosine = [];
	level.cosine[ "45" ] = cos( 45 );
	level.cosine[ "5" ] = cos( 5 );
	
	level.player takeallweapons();
	level.player.ignoreme = true;
	
	level.badplaceRadius[ "ac130_25mm" ] = 800;
	level.badplaceRadius[ "ac130_40mm" ] = 1000;
	level.badplaceRadius[ "ac130_105mm" ] = 1600;
	level.badplaceRadius[ "ac130_25mm_alt" ] = level.badplaceRadius[ "ac130_25mm" ];
	level.badplaceRadius[ "ac130_40mm_alt" ] = level.badplaceRadius[ "ac130_40mm" ];
	level.badplaceRadius[ "ac130_105mm_alt" ] = level.badplaceRadius[ "ac130_105mm" ];
	
	level.badplaceDuration[ "ac130_25mm" ] = 2.0;
	level.badplaceDuration[ "ac130_40mm" ] = 9.0;
	level.badplaceDuration[ "ac130_105mm" ] = 12.0;
	level.badplaceDuration[ "ac130_25mm_alt" ] = level.badplaceDuration[ "ac130_25mm" ];
	level.badplaceDuration[ "ac130_40mm_alt" ] = level.badplaceDuration[ "ac130_40mm" ];
	level.badplaceDuration[ "ac130_105mm_alt" ] = level.badplaceDuration[ "ac130_105mm" ];
	
	level.physicsSphereRadius[ "ac130_25mm" ] = 60;
	level.physicsSphereRadius[ "ac130_40mm" ] = 600;
	level.physicsSphereRadius[ "ac130_105mm" ] = 1000;
	level.physicsSphereRadius[ "ac130_25mm_alt" ] = level.physicsSphereRadius[ "ac130_25mm" ];
	level.physicsSphereRadius[ "ac130_40mm_alt" ] = level.physicsSphereRadius[ "ac130_40mm" ];
	level.physicsSphereRadius[ "ac130_105mm_alt" ] = level.physicsSphereRadius[ "ac130_105mm" ];
	
	level.physicsSphereForce[ "ac130_25mm" ] = 0;
	level.physicsSphereForce[ "ac130_40mm" ] = 3.0;
	level.physicsSphereForce[ "ac130_105mm" ] = 6.0;
	level.physicsSphereForce[ "ac130_25mm_alt" ] = level.physicsSphereForce[ "ac130_25mm" ];
	level.physicsSphereForce[ "ac130_40mm_alt" ] = level.physicsSphereForce[ "ac130_40mm" ];
	level.physicsSphereForce[ "ac130_105mm_alt" ] = level.physicsSphereForce[ "ac130_105mm" ];
	
	level.weaponReloadTime[ "ac130_25mm" ] = 0.05;
	level.weaponReloadTime[ "ac130_40mm" ] = 0.5;
	level.weaponReloadTime[ "ac130_105mm" ] = 6.0;
	level.weaponReloadTime[ "ac130_25mm_alt" ] = level.weaponReloadTime[ "ac130_25mm" ];
	level.weaponReloadTime[ "ac130_40mm_alt" ] = level.weaponReloadTime[ "ac130_40mm" ];
	level.weaponReloadTime[ "ac130_105mm_alt" ] = level.weaponReloadTime[ "ac130_105mm" ];
	
	level.weaponFriendlyCloseDistance[ "ac130_25mm" ] = 150;
	level.weaponFriendlyCloseDistance[ "ac130_40mm" ] = 500;
	level.weaponFriendlyCloseDistance[ "ac130_105mm" ] = 1000;
	level.weaponFriendlyCloseDistance[ "ac130_25mm_alt" ] = level.weaponFriendlyCloseDistance[ "ac130_25mm" ];
	level.weaponFriendlyCloseDistance[ "ac130_40mm_alt" ] = level.weaponFriendlyCloseDistance[ "ac130_40mm" ];
	level.weaponFriendlyCloseDistance[ "ac130_105mm_alt" ] = level.weaponFriendlyCloseDistance[ "ac130_105mm" ];
	
	level.weaponReadyToFire[ "ac130_25mm" ] = true;
	level.weaponReadyToFire[ "ac130_40mm" ] = true;
	level.weaponReadyToFire[ "ac130_105mm" ] = true;
	level.weaponReadyToFire[ "ac130_25mm_alt" ] = level.weaponReadyToFire[ "ac130_25mm" ];
	level.weaponReadyToFire[ "ac130_40mm_alt" ] = level.weaponReadyToFire[ "ac130_40mm" ];
	level.weaponReadyToFire[ "ac130_105mm_alt" ] = level.weaponReadyToFire[ "ac130_105mm" ];
	
	level.ac130_Speed[ "move" ] = 250;
	level.ac130_Speed[ "rotate" ] = 70;
	
	level.enemiesKilledByPlayer = 0;
	
	//flag_init( "ir_beakons_on" );
	flag_init( "allow_context_sensative_dialog" );
	flag_init( "clear_to_engage" );
	flag_init( "player_changed_weapons" );
	
	level.player takeallweapons();
	if (getdvar("ac130_alternate_controls") == "0")
	{
		level.player giveweapon("ac130_105mm");
		level.player switchtoweapon("ac130_105mm");
	}
	else
	{
		level.player giveweapon("ac130_105mm_alt");
		level.player switchtoweapon("ac130_105mm_alt");
	}
	level.player SetActionSlot( 3, "" );
	Setammo();
	
	if (getdvar("ac130_enabled") == "1")
	{
		thread overlay();
		thread HUDItemsOff();
		thread attachPlayer();
		thread changeWeapons();
		thread weaponFiredThread();
		thread invertThermal();
		if ( getdvar( "ac130_pre_engagement_mode" ) == "1" )
			thread failMissionForEngaging();
		if ( getdvar( "ac130_pre_engagement_mode" ) == "2" )
			thread nofireCrossHair();
		thread context_Sensative_Dialog();
		thread shotFired();
		thread clouds();
		thread maps\_ac130_amb::main();
		thread rotatePlane( "on" );
		thread hud_target_blink_timer();
	}
}

overlay()
{
	wait 0.05;
	if ( isdefined( level.doing_cinematic ) )
		level waittill( "introscreen_black" );
	
	level.HUDItem = [];
	
	level.HUDItem[ "crosshairs" ] = newHudElem();
	level.HUDItem[ "crosshairs" ].x = 0;
	level.HUDItem[ "crosshairs" ].y = 0;
	level.HUDItem[ "crosshairs" ].alignX = "center";
	level.HUDItem[ "crosshairs" ].alignY = "middle";
	level.HUDItem[ "crosshairs" ].horzAlign = "center";
	level.HUDItem[ "crosshairs" ].vertAlign = "middle";
	level.HUDItem[ "crosshairs" ] setshader ("ac130_overlay_105mm", 640, 480);
	level.HUDItem[ "crosshairs" ].sort = -2;
	
	if ( ( getdvar( "ac130_hud_text_misc" ) == "1" ) && ( !isdefined( level.credits_active ) ) )
	{
		level.HUDItem[ "hud_text_top" ] = newHudElem();
		level.HUDItem[ "hud_text_top" ].x = 0;
		level.HUDItem[ "hud_text_top" ].y = 0;
		level.HUDItem[ "hud_text_top" ].alignX = "left";
		level.HUDItem[ "hud_text_top" ].alignY = "top";
		level.HUDItem[ "hud_text_top" ].horzAlign = "left";
		level.HUDItem[ "hud_text_top" ].vertAlign = "top";
		level.HUDItem[ "hud_text_top" ].fontScale = 2.5;
		level.HUDItem[ "hud_text_top" ] settext ( &"AC130_HUD_TOP_BAR" );
		level.HUDItem[ "hud_text_top" ].alpha = 1.0;
		
		level.HUDItem[ "hud_text_left" ] = newHudElem();
		level.HUDItem[ "hud_text_left" ].x = 0;
		level.HUDItem[ "hud_text_left" ].y = 60;
		level.HUDItem[ "hud_text_left" ].alignX = "left";
		level.HUDItem[ "hud_text_left" ].alignY = "top";
		level.HUDItem[ "hud_text_left" ].horzAlign = "left";
		level.HUDItem[ "hud_text_left" ].vertAlign = "top";
		level.HUDItem[ "hud_text_left" ].fontScale = 2.5;
		level.HUDItem[ "hud_text_left" ] settext ( &"AC130_HUD_LEFT_BLOCK" );
		level.HUDItem[ "hud_text_left" ].alpha = 1.0;
		
		level.HUDItem[ "hud_text_right" ] = newHudElem();
		level.HUDItem[ "hud_text_right" ].x = 0;
		level.HUDItem[ "hud_text_right" ].y = 50;
		level.HUDItem[ "hud_text_right" ].alignX = "right";
		level.HUDItem[ "hud_text_right" ].alignY = "top";
		level.HUDItem[ "hud_text_right" ].horzAlign = "right";
		level.HUDItem[ "hud_text_right" ].vertAlign = "top";
		level.HUDItem[ "hud_text_right" ].fontScale = 2.5;
		level.HUDItem[ "hud_text_right" ] settext ( &"AC130_HUD_RIGHT_BLOCK" );
		level.HUDItem[ "hud_text_right" ].alpha = 1.0;
		
		level.HUDItem[ "hud_text_bottom" ] = newHudElem();
		level.HUDItem[ "hud_text_bottom" ].x = 0;
		level.HUDItem[ "hud_text_bottom" ].y = 0;
		level.HUDItem[ "hud_text_bottom" ].alignX = "center";
		level.HUDItem[ "hud_text_bottom" ].alignY = "bottom";
		level.HUDItem[ "hud_text_bottom" ].horzAlign = "center";
		level.HUDItem[ "hud_text_bottom" ].vertAlign = "bottom";
		level.HUDItem[ "hud_text_bottom" ].fontScale = 2.5;
		level.HUDItem[ "hud_text_bottom" ] settext ( &"AC130_HUD_BOTTOM_BLOCK" );
		level.HUDItem[ "hud_text_bottom" ].alpha = 1.0;
	}
	
	if ( ( getdvar( "ac130_hud_text_thermal" ) == "1" ) && ( !isdefined( level.credits_active ) ) )
	{
		level.HUDItem[ "thermal_mode" ] = newHudElem();
		level.HUDItem[ "thermal_mode" ].x = -80;
		level.HUDItem[ "thermal_mode" ].y = 50;
		level.HUDItem[ "thermal_mode" ].alignX = "right";
		level.HUDItem[ "thermal_mode" ].alignY = "top";
		level.HUDItem[ "thermal_mode" ].horzAlign = "right";
		level.HUDItem[ "thermal_mode" ].vertAlign = "top";
		level.HUDItem[ "thermal_mode" ].fontScale = 2.5;
		level.HUDItem[ "thermal_mode" ] settext ( &"AC130_HUD_THERMAL_WHOT" );
		level.HUDItem[ "thermal_mode" ].alpha = 1.0;
	}
	
	if ( ( getdvar( "ac130_hud_text_weapons" ) == "1" ) && ( !isdefined( level.credits_active ) ) )
	{
		level.HUDItem[ "weapon_text" ][ 0 ] = newHudElem();
		level.HUDItem[ "weapon_text" ][ 0 ].x = 0;
		level.HUDItem[ "weapon_text" ][ 0 ].y = 0;
		level.HUDItem[ "weapon_text" ][ 0 ].alignX = "left";
		level.HUDItem[ "weapon_text" ][ 0 ].alignY = "bottom";
		level.HUDItem[ "weapon_text" ][ 0 ].horzAlign = "left";
		level.HUDItem[ "weapon_text" ][ 0 ].vertAlign = "bottom";
		level.HUDItem[ "weapon_text" ][ 0 ].fontScale = 2.5;
		level.HUDItem[ "weapon_text" ][ 0 ] settext ( &"AC130_HUD_WEAPON_105MM" );
		level.HUDItem[ "weapon_text" ][ 0 ].alpha = 1.0;
		
		level.HUDItem[ "weapon_text" ][ 1 ] = newHudElem();
		level.HUDItem[ "weapon_text" ][ 1 ].x = 0;
		level.HUDItem[ "weapon_text" ][ 1 ].y = -30;
		level.HUDItem[ "weapon_text" ][ 1 ].alignX = "left";
		level.HUDItem[ "weapon_text" ][ 1 ].alignY = "bottom";
		level.HUDItem[ "weapon_text" ][ 1 ].horzAlign = "left";
		level.HUDItem[ "weapon_text" ][ 1 ].vertAlign = "bottom";
		level.HUDItem[ "weapon_text" ][ 1 ].fontScale = 2.5;
		level.HUDItem[ "weapon_text" ][ 1 ] settext ( &"AC130_HUD_WEAPON_40MM" );
		level.HUDItem[ "weapon_text" ][ 1 ].alpha = 1.0;
		
		level.HUDItem[ "weapon_text" ][ 2 ] = newHudElem();
		level.HUDItem[ "weapon_text" ][ 2 ].x = 0;
		level.HUDItem[ "weapon_text" ][ 2 ].y = -60;
		level.HUDItem[ "weapon_text" ][ 2 ].alignX = "left";
		level.HUDItem[ "weapon_text" ][ 2 ].alignY = "bottom";
		level.HUDItem[ "weapon_text" ][ 2 ].horzAlign = "left";
		level.HUDItem[ "weapon_text" ][ 2 ].vertAlign = "bottom";
		level.HUDItem[ "weapon_text" ][ 2 ].fontScale = 2.5;
		level.HUDItem[ "weapon_text" ][ 2 ] settext ( &"AC130_HUD_WEAPON_25MM" );
		level.HUDItem[ "weapon_text" ][ 2 ].alpha = 1.0;
	}
	
	thread hud_timer();
	thread overlay_coords();
	thread blink_hud_elem( 0 );
	
	level.HUDItem[ "grain" ] = newHudElem();
	level.HUDItem[ "grain" ].x = 0;
	level.HUDItem[ "grain" ].y = 0;
	level.HUDItem[ "grain" ].alignX = "left";
	level.HUDItem[ "grain" ].alignY = "top";
	level.HUDItem[ "grain" ].horzAlign = "fullscreen";
	level.HUDItem[ "grain" ].vertAlign = "fullscreen";
	level.HUDItem[ "grain" ] setshader ("ac130_overlay_grain", 640, 480);
	level.HUDItem[ "grain" ].alpha = 0.4;
	level.HUDItem[ "grain" ].sort = -3;
		
	thread ac130ShellShock();
	
	wait 0.05;
	
	setsaveddvar( "g_friendlynamedist", 0 );
	setsaveddvar( "compass", 0 );
	
	setblur(1.2, 0);
	setsaveddvar( "cg_tracerwidth", 16 );
}

HUDItemsOff()
{
	for(;;)
	{
		if ( getdvarint( "ac130_post_effects_enabled" ) == 0 )
			break;
		wait 1.0;
	}
	
	level notify( "post_effects_disabled" );
	
	setblur( 0, 0 );
	setsaveddvar( "cg_tracerwidth", 4 );
	
	hud_items = [];
	hud_items[ hud_items.size ] = "hud_text_top";
	hud_items[ hud_items.size ] = "hud_text_left";
	hud_items[ hud_items.size ] = "hud_text_right";
	hud_items[ hud_items.size ] = "hud_text_bottom";
	hud_items[ hud_items.size ] = "thermal_mode";
	hud_items[ hud_items.size ] = "grain";
	hud_items[ hud_items.size ] = "timer";
	hud_items[ hud_items.size ] = "coordinate_long";
	hud_items[ hud_items.size ] = "coordinate_lat";
	hud_items[ hud_items.size ] = "coordinate_agl";
	
	for ( i = 0 ; i < hud_items.size ; i++ )
	{
		if ( isdefined( level.HUDItem[ hud_items[ i ] ] ) )
			level.HUDItem[ hud_items[ i ] ] destroy();
	}
}

hud_timer()
{
	if ( getdvar( "ac130_hud_text_misc" ) == "0" )
		return;
	
	if ( isdefined( level.credits_active ) )
		return;
	
	level endon( "post_effects_disabled" );
	
	level.HUDItem[ "timer" ] = newHudElem();
	level.HUDItem[ "timer" ].x = -100;
	level.HUDItem[ "timer" ].y = 0;
	level.HUDItem[ "timer" ].alignX = "right";
	level.HUDItem[ "timer" ].alignY = "bottom";
	level.HUDItem[ "timer" ].horzAlign = "right";
	level.HUDItem[ "timer" ].vertAlign = "bottom";
	level.HUDItem[ "timer" ].fontScale = 2.5;
	level.HUDItem[ "timer" ] setTimer( 1.0 );
	level.HUDItem[ "timer" ].alpha = 1.0;
	
	level waittill( "start_clock" );
	
	level.HUDItem[ "timer" ] setTimerUp( 1.0 );
}

overlay_coords()
{
	if ( getdvar( "ac130_hud_text_misc" ) == "0" )
		return;
	
	if ( isdefined( level.credits_active ) )
		return;
	
	level.HUDItem[ "coordinate_long" ] = newHudElem();
	level.HUDItem[ "coordinate_long" ].x = -100;
	level.HUDItem[ "coordinate_long" ].y = 0;
	level.HUDItem[ "coordinate_long" ].alignX = "right";
	level.HUDItem[ "coordinate_long" ].alignY = "top";
	level.HUDItem[ "coordinate_long" ].horzAlign = "right";
	level.HUDItem[ "coordinate_long" ].vertAlign = "top";
	level.HUDItem[ "coordinate_long" ].fontScale = 2.5;
	level.HUDItem[ "coordinate_long" ].alpha = 1.0;
	
	level.HUDItem[ "coordinate_lat" ] = newHudElem();
	level.HUDItem[ "coordinate_lat" ].x = 0;
	level.HUDItem[ "coordinate_lat" ].y = 0;
	level.HUDItem[ "coordinate_lat" ].alignX = "right";
	level.HUDItem[ "coordinate_lat" ].alignY = "top";
	level.HUDItem[ "coordinate_lat" ].horzAlign = "right";
	level.HUDItem[ "coordinate_lat" ].vertAlign = "top";
	level.HUDItem[ "coordinate_lat" ].fontScale = 2.5;
	level.HUDItem[ "coordinate_lat" ].alpha = 1.0;
	
	level.HUDItem[ "coordinate_agl" ] = newHudElem();
	level.HUDItem[ "coordinate_agl" ].x = 0;
	level.HUDItem[ "coordinate_agl" ].y = 20;
	level.HUDItem[ "coordinate_agl" ].alignX = "right";
	level.HUDItem[ "coordinate_agl" ].alignY = "top";
	level.HUDItem[ "coordinate_agl" ].horzAlign = "right";
	level.HUDItem[ "coordinate_agl" ].vertAlign = "top";
	level.HUDItem[ "coordinate_agl" ].fontScale = 2.5;
	level.HUDItem[ "coordinate_agl" ].label = ( &"AC130_HUD_AGL" );
	level.HUDItem[ "coordinate_agl" ].alpha = 1.0;
		
	level endon( "post_effects_disabled" );
	
	wait 0.05;
	for(;;)
	{
		level.HUDItem[ "coordinate_long" ] setValue( abs( int( level.player.origin[0] ) ) );
		level.HUDItem[ "coordinate_lat" ] setValue( abs( int( level.player.origin[1] ) ) );
		
		pos = physicstrace( level.player.origin, level.player.origin - ( 0, 0, 100000 ) );
		if( ( isdefined( pos ) ) && ( isdefined( pos[2] ) ) )
		{
			alt = ( ( level.player.origin[2] - pos[2] ) * 1.5 );
			level.HUDItem[ "coordinate_agl" ] setValue( abs( int( alt ) ) );
		}
		
		wait ( 0.75 + randomfloat( 2 ) );
	}
}

ac130ShellShock()
{
	level endon( "post_effects_disabled" );
	duration = 5;
	for (;;)
	{
		level.player shellshock( "ac130", duration );
		wait duration;
	}
}

rotatePlane( toggle )
{
	level notify("stop_rotatePlane_thread");
	level endon("stop_rotatePlane_thread");
	
	if (toggle == "on")
	{
		rampupDegrees = 10;
		rotateTime = ( level.ac130_Speed[ "rotate" ] / 360 ) * rampupDegrees;
		level.ac130 rotateyaw( level.ac130.angles[ 2 ] + rampupDegrees, rotateTime, rotateTime, 0 );
		
		for (;;)
		{
			level.ac130 rotateyaw( 360, level.ac130_Speed[ "rotate" ] );
			wait level.ac130_Speed[ "rotate" ];
		}
	}
	else if (toggle == "off")
	{
		slowdownDegrees = 10;
		rotateTime = ( level.ac130_Speed[ "rotate" ] / 360 ) * slowdownDegrees;
		level.ac130 rotateyaw( level.ac130.angles[ 2 ] + slowdownDegrees, rotateTime, 0, rotateTime );
	}
}

attachPlayer()
{
	level.player playerLinkToDelta (level.ac130, "tag_player", 1.0, 65, 65, 40, 40 );
	wait 0.05;
	level.player allowProne( false );
	level.player allowCrouch( false );
	level.player setplayerangles ( level.ac130 getTagAngles( "tag_player" ) );
	
	SetSavedDvar( "ammoCounterHide", "1" );
	SetSavedDvar( "hud_showStance", 0 );
}

getRealAC130Angles()
{
	angle = level.ac130.angles[ 1 ];
	while( angle >= 360 )
		angle -= 360;
	while( angle < 0 )
		angle += 360;
	return angle;
}

getFlyingAC130AnglesToPoint( vec )
{
	destAng = vectorToAngles( level.ac130.origin - vec );
	destAng = destAng[ 1 ] + 90;
	while( destAng >= 360 )
		destAng -= 360;
	while( destAng < 0 )
		destAng += 360;
	return destAng;
}

movePlaneToWaypoint( sWaypointTargetname, rotationWait )
{
	assert( isdefined( sWaypointTargetname ) );
	waypoint = getent( sWaypointTargetname, "targetname" );
	assert( isdefined( waypoint ) );
	assert( isdefined( waypoint.origin ) );
	movePlaneToPoint( waypoint.origin, rotationWait );
}

movePlaneToPoint( coordinate, rotationWait )
{
	level notify ( "ac130_reposition" );
	level endon ( "ac130_reposition" );
	
	if ( !isdefined( rotationWait ) )
		rotationWait = false;
	
	d = distance( level.ac130.origin, coordinate );
	moveTime = ( d / level.ac130_Speed[ "move" ] );
	if ( moveTime <= 0 )
		return;
	accel = moveTime / 2;
	decel = moveTime / 2;
	
	if ( rotationWait )
	{
		thread rotatePlane( "off" );
		
		// find how many more degrees the plane should turn before facing the right direction
		angDiff = getFlyingAC130AnglesToPoint( coordinate ) - getRealAC130Angles();
		if ( angDiff < 0 )
			angDiff = 360 - abs( angDiff );
		//iprintln( "angle differance: " + angDiff );
		
		// if the plane isn't close enough to the desired angles then rotate it until the plane is facing it's flying direction
		planeCanFly = false;
		angleTollerance = 20;
		if ( ( angDiff > 0 ) && ( angDiff <= angleTollerance ) )
			planeCanFly = true;
		if ( ( angDiff > 360 - angleTollerance ) && ( angDiff < 360 ) )
			planeCanFly = true;
		if ( !planeCanFly )
		{
			//iprintln( "waiting for plane to rotate " + angDiff + " degrees" );
			//assert( angDiff - 20 > 0 );
			rotateTime = ( level.ac130_Speed[ "rotate" ] / 360 ) * angDiff;
			decelTime = 0;
			if ( rotateTime > 3.0 )
				decelTime = 3.0;
			assert( rotateTime > 0 );
			level.ac130 rotateyaw( angDiff, rotateTime, 0, decelTime );
			wait rotateTime - decelTime;
			thread ac130_move_out();
		}
	}
	
	level.ac130 moveto ( coordinate, moveTime, accel, decel );
	if ( moveTime > 2.0 )
	{
		wait ( moveTime - 2.0 );
		level notify( "ac130_almost_at_destination" );
		if ( rotationWait )
			thread rotatePlane( "on" );
		wait 2.0;
	}
	else
	{
		wait moveTime;
		if ( rotationWait )
			thread rotatePlane( "on" );
	}
}

ac130_move_in()
{
	if ( isdefined( level.ac130_moving_in ) )
		return;
	level.ac130_moving_in = true;
	level.ac130_moving_out = undefined;
	
	thread context_Sensative_Dialog_Play_Random_Group_Sound( "plane", "rolling_in", true );
	
	level.ac130 useAnimTree( #animtree );
	level.ac130 setflaggedanim ( "ac130_move_in", %ac130_move_in, 1.0, 0.2, 0.1 );
	level.ac130 waittillmatch( "ac130_move_in", "end" );
	
	level.ac130_moving_in = undefined;
}

ac130_move_out()
{
	if ( isdefined( level.ac130_moving_out ) )
		return;
	level.ac130_moving_out = true;
	level.ac130_moving_in = undefined;
	
	level.ac130 useAnimTree( #animtree );
	level.ac130 setflaggedanim ( "ac130_move_out", %ac130_move_out, 1.0, 0.2, 0.3 );
	level.ac130 waittillmatch( "ac130_move_out", "end" );
	
	level.ac130_moving_out = undefined;
}

changeWeapons()
{
	level.ac130_weapon = [];
	
	level.ac130_weapon[ 0 ] = spawnstruct();
	level.ac130_weapon[ 0 ].overlay = "ac130_overlay_105mm";
	level.ac130_weapon[ 0 ].fov = "55";
	level.ac130_weapon[ 0 ].name = "105mm";
	level.ac130_weapon[ 0 ].string = ( &"AC130_HUD_WEAPON_105MM" );
	level.ac130_weapon[ 0 ].hudelem_y = -20;
	
	level.ac130_weapon[ 1 ] = spawnstruct();
	level.ac130_weapon[ 1 ].overlay = "ac130_overlay_40mm";
	level.ac130_weapon[ 1 ].fov = "25";
	level.ac130_weapon[ 1 ].name = "40mm";
	level.ac130_weapon[ 1 ].string = ( &"AC130_HUD_WEAPON_40MM" );
	level.ac130_weapon[ 1 ].hudelem_y = -40;
	
	level.ac130_weapon[ 2 ] = spawnstruct();
	level.ac130_weapon[ 2 ].overlay = "ac130_overlay_25mm";
	level.ac130_weapon[ 2 ].fov = "10";
	level.ac130_weapon[ 2 ].name = "25mm";
	level.ac130_weapon[ 2 ].string = ( &"AC130_HUD_WEAPON_25MM" );
	level.ac130_weapon[ 2 ].hudelem_y = -60;
	
	if (getdvar("ac130_alternate_controls") == "0")
	{
		level.ac130_weapon[0].weapon = "ac130_105mm";
		level.ac130_weapon[1].weapon = "ac130_40mm";
		level.ac130_weapon[2].weapon = "ac130_25mm";
	}
	else
	{
		level.ac130_weapon[0].weapon = "ac130_105mm_alt";
		level.ac130_weapon[1].weapon = "ac130_40mm_alt";
		level.ac130_weapon[2].weapon = "ac130_25mm_alt";
	}
	
	currentWeapon = 0;
	level.currentWeapon = level.ac130_weapon[currentWeapon].name;
	thread fire_screenShake();
	
	if ( isdefined( level.credits_active ) )
		return;
	
	level.player notifyOnCommand( "switch weapons", "weapnext" );
	
	for(;;)
	{
		level.player waittill ( "switch weapons" );
		
		// no weapon changes allowed during cinematic
		if ( isdefined( level.doing_cinematic ) )
		{
			wait 0.05;
			continue;
		}
		
		level.player notify( "shot weapon" );
		
		currentWeapon++;
		if ( currentWeapon >= level.ac130_weapon.size )
			currentWeapon = 0;
		level.currentWeapon = level.ac130_weapon[currentWeapon].name;
		
		level.HUDItem[ "crosshairs" ] setshader ( level.ac130_weapon[currentWeapon].overlay, 640, 480 );
		
		thread blink_crosshairs( level.ac130_weapon[ currentWeapon ].weapon );
		thread blink_hud_elem( currentWeapon );
		
		if ( getdvar( "ac130_alternate_controls" ) == "0" )
			setsaveddvar( "cg_fov",level.ac130_weapon[currentWeapon].fov );
		
		level.player takeallweapons();
		level.player giveweapon( level.ac130_weapon[currentWeapon].weapon );
		level.playerWeapon = level.ac130_weapon[currentWeapon].weapon;
		level.player switchtoweapon( level.ac130_weapon[currentWeapon].weapon );
		setAmmo();
		
		level.player thread play_sound_on_entity( "ac130_weapon_switch" );
		
		flag_set( "player_changed_weapons" );
	}
}

blink_hud_elem( curentWeapon )
{
	
	level notify( "blinking_weapon_name_hud_elem" );
	level endon( "blinking_weapon_name_hud_elem" );
	
	if ( !isdefined( level.HUDItem[ "weapon_text" ] ) )
		return;
	
	for( i = 0 ; i < level.HUDItem[ "weapon_text" ].size ; i++ )
		level.HUDItem[ "weapon_text" ][ i ].alpha = 0.5;
	
	level.HUDItem[ "weapon_text" ][ curentWeapon ].alpha = 1;
	for(;;)
	{
		level.HUDItem[ "weapon_text" ][ curentWeapon ] fadeOverTime( 0.2 );
		level.HUDItem[ "weapon_text" ][ curentWeapon ].alpha = 0;
		wait 0.2;
		
		level.HUDItem[ "weapon_text" ][ curentWeapon ] fadeOverTime( 0.2 );
		level.HUDItem[ "weapon_text" ][ curentWeapon ].alpha = 1;
		wait 0.2;
	}
}

blink_crosshairs( weaponName )
{
	level notify( "stop_blinking_crosshairs" );
	level endon( "stop_blinking_crosshairs" );
	
	level.HUDItem[ "crosshairs" ].alpha = 1;
	
	if ( !issubstr( tolower( weaponName ), "105" ) )
		return;
	
	waittillframeend;
	if ( level.weaponReadyToFire[ weaponName ] )
		return;
	
	for(;;)
	{
		level.HUDItem[ "crosshairs" ] fadeOverTime( 0.3 );
		level.HUDItem[ "crosshairs" ].alpha = 0;
		wait 0.3;
		
		level.HUDItem[ "crosshairs" ] fadeOverTime( 0.3 );
		level.HUDItem[ "crosshairs" ].alpha = 1;
		wait 0.3;
	}
}

blink_crosshairs_stop()
{
	level notify( "stop_blinking_crosshairs" );
	level.HUDItem[ "crosshairs" ].alpha = 1;
}

weaponFiredThread()
{
	for(;;)
	{
		level.player waittill( "weapon_fired" );
		
		weaponList = level.player GetWeaponsListPrimaries();
		assert( isdefined( weaponList[ 0 ] ) );
		
		if ( !level.weaponReadyToFire[ weaponList[ 0 ] ] )
			continue;
		
		thread blink_crosshairs( weaponList[ 0 ] );
		
		thread weaponReload( weaponList[ 0 ] );
	}
}

weaponReload( weapon )
{
	level.weaponReadyToFire[ weapon ] = false;
	
	wait level.weaponReloadTime[ weapon ] - 0.05;
	
	level.weaponReadyToFire[ weapon ] = true;
	
	setAmmo();
}

invertThermal()
{
	level.player endon( "death" );

	set_vision_set( "ac130", 0 );
	inverted = "0";
	
	if ( isdefined( level.credits_active ) )
		return;
	
	level.player notifyOnCommand( "switch thermal", "+usereload" );
	level.player notifyOnCommand( "switch thermal", "+activate" );
	for (;;)
	{
		level.player waittill ( "switch thermal" );
		
		// no thermal changes allowed during cinematic
		if ( isdefined( level.doing_cinematic ) )
		{
			wait 0.05;
			continue;
		}
		
		if ( inverted == "0" )
		{
			set_vision_set( "ac130_inverted", 0 );
			if ( isdefined( level.HUDItem[ "thermal_mode" ] ) )
				level.HUDItem[ "thermal_mode" ] settext ( &"AC130_HUD_THERMAL_BHOT" );
			inverted = "1";
		}
		else
		{
			set_vision_set( "ac130", 0 );
			if ( isdefined( level.HUDItem[ "thermal_mode" ] ) )
				level.HUDItem[ "thermal_mode" ] settext ( &"AC130_HUD_THERMAL_WHOT" );
			inverted = "0";
		}
	}
}

setAmmo()
{
	level notify( "setting_ammo" );
	level endon( "setting_ammo" );
	
	if ( flag( "clear_to_engage" ) )
		ammoCount = 1;
	else
		ammoCount = 0;

    weaponList = level.player GetWeaponsListPrimaries();
    for( i = 0 ; i < weaponList.size ; i++ )
    {
    	// only add the ammo if the gun is reloaded
		if ( level.weaponReadyToFire[ weaponList[ i ] ] )
			level.player SetWeaponAmmoClip( weaponList[ i ], ammoCount );
    }
}

failMissionForEngaging()
{
	level endon ( "clear_to_engage" );
	
	level.player waittill ( "weapon_fired" );
	
	wait 2;
	
	if ( !flag( "mission_failed" ) )
	{
		flag_set( "mission_failed" );
		setdvar( "ui_deadquote", "@AC130_DO_NOT_ENGAGE" );
		maps\_utility::missionFailedWrapper();
	}
}

nofireCrossHair()
{
	level endon ( "clear_to_engage" );
	
	if ( flag( "clear_to_engage" ) )
		return;
	
	level.ac130_nofire = newHudElem();
	level.ac130_nofire.x = 0;
	level.ac130_nofire.y = 0;
	level.ac130_nofire.alignX = "center";
	level.ac130_nofire.alignY = "middle";
	level.ac130_nofire.horzAlign = "center";
	level.ac130_nofire.vertAlign = "middle";
	level.ac130_nofire setshader ( "ac130_overlay_nofire", 64, 64 );
	
	thread nofireCrossHair_Remove();
	
	level.ac130_nofire.alpha = 0;
	
	for (;;)
	{
		while( level.player attackButtonPressed() )
		{
			// no red x allowed during cinematic
			if ( isdefined( level.doing_cinematic ) )
			{
				wait 0.05;
				break;
			}
			
			level.ac130_nofire.alpha = 1;
			level.ac130_nofire fadeOverTime( 1.0 );
			level.ac130_nofire.alpha = 0;
			wait 1.0;
		}
		wait 0.05;
	}
}

nofireCrossHair_Remove()
{
	level waittill ( "clear_to_engage" );
	level.ac130_nofire destroy();
	thread setAmmo();
}

fire_screenShake()
{
	for (;;)
	{
		level.player waittill ( "weapon_fired" );
		
		if (level.currentWeapon == "105mm")
		{
			if ( ( getdvar( "ac130_pre_engagement_mode" ) == "2" ) && ( !flag( "clear_to_engage" ) ) )
				continue;
			
			thread gun_fired_and_ready_105mm();
			
			//earthquake(<scale>,<duration>,<source>,<radius>)
			earthquake (0.2, 1, level.player.origin, 1000);
		}
		else
		if (level.currentWeapon == "40mm")
		{
			if ( ( getdvar( "ac130_pre_engagement_mode" ) == "2" ) && ( !flag( "clear_to_engage" ) ) )
				continue;
			
			//earthquake(<scale>,<duration>,<source>,<radius>)
			earthquake (0.1, 0.5, level.player.origin, 1000);
		}
		
		wait 0.05;
	}
}

clouds()
{
	level endon( "stop_clounds" );
	wait 6;
	clouds_create();
	for(;;)
	{
		wait( randomfloatrange( 40, 80 ) );
		clouds_create();
	}
}

clouds_create()
{
	if ( ( isdefined( level.playerWeapon ) ) && ( issubstr( tolower( level.playerWeapon ), "25" ) ) )
		return;
	playfxontag ( level._effect[ "cloud" ], level.ac130, "tag_player" );
}

gun_fired_and_ready_105mm()
{
	level notify( "gun_fired_and_ready_105mm" );
	level endon( "gun_fired_and_ready_105mm" );
	
	wait 0.5;
	
	if ( randomint( 2 ) == 0 )
		thread context_Sensative_Dialog_Play_Random_Group_Sound( "weapons", "105mm_fired" );
	
	wait 5.0;	
	
	thread blink_crosshairs_stop();
	thread context_Sensative_Dialog_Play_Random_Group_Sound( "weapons", "105mm_ready" );
}

getFriendlysCenter()
{
	//returns vector which is the center mass of all friendlies
	averageVec = undefined;
	friendlies = getaiarray("allies");
	if (!isdefined(friendlies))
		return (0,0,0);
	if (friendlies.size <= 0)
		return (0,0,0);
	for( i = 0 ; i < friendlies.size ; i++ )
	{
		if (!isdefined(averageVec))
			averageVec = friendlies[i].origin;
		else
			averageVec += friendlies[i].origin;
	}
	averageVec = ( (averageVec[0] / friendlies.size), (averageVec[1] / friendlies.size), (averageVec[2] / friendlies.size) );
	return averageVec;
}

shotFired()
{
	for (;;)
	{
		level.player waittill( "projectile_impact", weaponName, position, radius );
		
		thread shotFiredFriendlyProximity( weaponName, position );
		
		if ( issubstr( tolower( weaponName ), "105" ) )
			thread shotFiredDarkScreenOverlay();
		thread shotFiredBadPlace( position, weaponName );
		if ( getdvar( "ac130_ragdoll_deaths" ) == "1" )
			thread shotFiredPhysicsSphere( position, weaponName );
		wait 0.05;
	}
}

shotFiredFriendlyProximity( weaponName, position )
{
	if ( !isdefined( level.weaponFriendlyCloseDistance[ weaponName ] ) )
		return;
	
	trigger_origin = position - ( 0, 0, 50 );
	trigger_radius = level.weaponFriendlyCloseDistance[ weaponName ];
	trigger_height = 300;
	trigger_spawnflags = 10; //AI_ALLIES and NOT_PLAYER
	trigger_lifetime = 1.0;
	
	prof_begin( "ac130_friendly_proximity_check" );
	trigger = spawn( "trigger_radius", trigger_origin, trigger_spawnflags, trigger_radius, trigger_height );
	prof_end( "ac130_friendly_proximity_check" );
	level thread shotFiredFriendlyProximity_trigger( trigger, trigger_lifetime );
	
	if ( getdvar( "ac130_debug_weapons" ) == "1" )
	{
		thread debug_circle( trigger_origin, trigger_radius, trigger_lifetime, level.color[ "white" ], undefined, true );
		thread debug_circle( trigger_origin + ( 0, 0, trigger_height ), trigger_radius, trigger_lifetime, level.color[ "white" ], undefined, true );
	}
}

shotFiredFriendlyProximity_trigger( trigger, trigger_lifetime )
{
	trigger endon( "timeout" );
	level thread shotFiredFriendlyProximity_trigger_timeout( trigger, trigger_lifetime );
	trigger waittill( "trigger" );
	
	// don't play warning dialog if one played within the last 5 seconds.
	prof_begin( "ac130_friendly_proximity_check" );
	if ( ( isdefined( level.lastFriendlyProximityWarningPlayed ) ) && ( gettime() - level.lastFriendlyProximityWarningPlayed < 7000 ) )
	{
		prof_end( "ac130_friendly_proximity_check" );
		return;
	}
	
	level.lastFriendlyProximityWarningPlayed = gettime();
	prof_end( "ac130_friendly_proximity_check" );
	
	thread playSoundOverRadio( level.scr_sound[ "fco" ][ "ac130_fco_firingtoclose" ], true, 5.0 );
}

shotFiredFriendlyProximity_trigger_timeout( trigger, trigger_lifetime )
{
	wait trigger_lifetime;
	trigger notify( "timeout" );
	trigger delete();
}

shotFiredBadPlace( center, weapon )
{
	assert( isdefined( level.badplaceRadius[ weapon ] ) );
	badplace_cylinder( "", level.badplaceDuration[ weapon ], center, level.badplaceRadius[ weapon ], level.badplaceRadius[ weapon ], "axis" );
	
	if ( getdvar( "ac130_debug_weapons" ) == "1" )
		thread debug_circle( center, level.badplaceRadius[ weapon ], level.badplaceDuration[ weapon ], level.color[ "blue" ], undefined, true );
}

shotFiredPhysicsSphere( center, weapon )
{
	wait 0.1;
	physicsExplosionSphere( center, level.physicsSphereRadius[ weapon ], level.physicsSphereRadius[ weapon ] / 2, level.physicsSphereForce[ weapon ] );
}

shotFiredDarkScreenOverlay()
{
	level notify( "darkScreenOverlay" );
	level endon( "darkScreenOverlay" );
	
	if ( !isdefined( level.darkScreenOverlay ) )
	{
		level.darkScreenOverlay = newHudElem();
		level.darkScreenOverlay.x = 0;
		level.darkScreenOverlay.y = 0;
		level.darkScreenOverlay.alignX = "left";
		level.darkScreenOverlay.alignY = "top";
		level.darkScreenOverlay.horzAlign = "fullscreen";
		level.darkScreenOverlay.vertAlign = "fullscreen";
		level.darkScreenOverlay setshader ( "black", 640, 480 );
		level.darkScreenOverlay.sort = -10;
		level.darkScreenOverlay.alpha = 0.0;
	}
	level.darkScreenOverlay.alpha = 0.0;
	level.darkScreenOverlay fadeOverTime( 0.2 );
	level.darkScreenOverlay.alpha = 0.6;
	wait 0.4;
	level.darkScreenOverlay fadeOverTime( 0.8 );
	level.darkScreenOverlay.alpha = 0.0;
}

add_beacon_effect()
{
	self endon( "death" );
	
	flashDelay = 0.75;
	
	wait randomfloat(3.0);
	for (;;)
	{
		playfxontag( level._effect[ "beacon" ], self, "j_spine4" );
		wait flashDelay;
	}
}

/*
breakable()
{
	self setcandamage( true );
	for (;;)
	{
		self waittill ( "damage", damage, attacker );
		if ( ( attacker == level.player ) & ( damage >= 1000 ) )
			break;
	}
	self delete();
}
*/
/*
tree_fall()
{
	self setcandamage( true );
	for (;;)
	{
		self waittill( "damage", damage, attacker, direction_vec, point );
		if ( attacker != level.player )
			continue;
		if ( randomint( 2 ) == 0 )
			continue;
		break;
	}
	
	tree = self;
	
	treeorg = spawn( "script_origin", tree.origin );
	treeorg.origin = tree.origin;
	
	org = point;
	pos1 = (org[0],org[1],0);
	org = tree.origin;
	pos2 = (org[0],org[1],0);
	treeorg.angles = vectortoangles( pos1 - pos2 );
	
 	treeang = tree.angles;
	ang = treeorg.angles;
	org = point;
	pos1 = (org[0],org[1],0);
	org = tree.origin;
	pos2 = (org[0],org[1],0);
	treeorg.angles = vectortoangles( pos1 - pos2 );
	tree linkto( treeorg );
	
	treeorg rotatepitch( -90, 1.1, .05, .2 );
	treeorg waittill( "rotatedone" );
	treeorg rotatepitch( 5, .21, .05, .15 );
	treeorg waittill( "rotatedone" );
	treeorg rotatepitch( -5, .26, .15, .1 );
	treeorg waittill( "rotatedone" );
	tree unlink();
	treeorg delete();
}
*/

spawn_callback_thread( guy )
{
	if ( isdefined( level.LevelSpecificSpawnerCallbackThread ) )
		thread [[ level.LevelSpecificSpawnerCallbackThread ]]( guy );
	
	if ( !isdefined( guy ) )
		return;
	
	if ( !isdefined( guy.team ) )
		return;
	
	if ( guy.team == "axis" )
	{
		thread enemy_killed_thread( guy );
	}

	if ( getdvar( "ac130_target_markers" ) == "1" )
	{
		target_set( guy, ( 0, 0, 32 ) );
		thread hud_target_blink( guy );
	}
}

hud_target_blink( guy )
{
	guy endon( "death" );
	while( isdefined( guy ) )
	{
		target_setshader( guy, "ac130_hud_target" );
		target_setoffscreenshader( guy, "ac130_hud_target_offscreen" );
		level waittill( "hud_target_blink_off" );
		target_setshader( guy, "ac130_hud_target_flash" );
		target_setoffscreenshader( guy, "ac130_hud_target_flash" );
		level waittill( "hud_target_blink_on" );
	}
}

hud_target_blink_timer()
{
	for(;;)
	{
		level notify( "hud_target_blink_on" );
		wait 0.5;
		level notify( "hud_target_blink_off" );
		wait 0.2;
	}
}

enemy_killed_thread( guy )
{
	if ( guy.team != "axis" )
		return;
	
	if ( getdvar( "ac130_ragdoll_deaths" ) == "1" )
		guy.skipDeathAnim = true;
	
	guy waittill ( "death", attacker );
	
	if ( ( isdefined( attacker ) ) && ( attacker == level.player ) )
		level.enemiesKilledByPlayer++;
	
	if ( getdvar( "ac130_ragdoll_deaths" ) == "1" )
	{
		if ( ( isdefined( guy.damageweapon ) ) && ( issubstr( guy.damageweapon, "25mm" ) ) )
			guy.skipDeathAnim = undefined;
	}
	
	// context kill dialog
	thread context_Sensative_Dialog_Kill( guy, attacker );
}

context_Sensative_Dialog()
{
	thread context_Sensative_Dialog_Guy_In_Sight();
	thread context_Sensative_Dialog_Guy_Crawling();
	thread context_Sensative_Dialog_Guy_Pain();
	thread context_Sensative_Dialog_Guy_Pain_Falling();
	thread context_Sensative_Dialog_Secondary_Explosion_Vehicle();
	thread context_Sensative_Dialog_Kill_Thread();
	thread context_Sensative_Dialog_Locations();
	thread context_Sensative_Dialog_Filler();
}

context_Sensative_Dialog_Guy_In_Sight()
{
	for (;;)
	{
		if ( context_Sensative_Dialog_Guy_In_Sight_Check() )
			thread context_Sensative_Dialog_Play_Random_Group_Sound( "ai", "in_sight" );
		wait randomfloatrange( 1, 3 );
	}
}

context_Sensative_Dialog_Guy_In_Sight_Check()
{
	prof_begin( "AI_in_sight_check" );
	
	enemies = getaiarray( "axis" );
	for( i = 0 ; i < enemies.size ; i++ )
	{
		if ( !isdefined( enemies[ i ] ) )
			continue;
		
		if ( !isalive( enemies[ i ] ) )
			continue;
		
		if ( within_fov( level.player getEye(), level.player getPlayerAngles(), enemies[ i ].origin, level.cosine[ "5" ] ) )
		{
			prof_end( "AI_in_sight_check" );
			return true;
		}
		wait 0.05;
	}
	
	prof_end( "AI_in_sight_check" );
	return false;
}

context_Sensative_Dialog_Guy_Crawling()
{
	for (;;)
	{
		level waittill ( "ai_crawling", guy );
		
		if ( ( isdefined( guy ) ) && ( isdefined( guy.origin ) ) )
		{
			if ( getdvar( "ac130_debug_context_sensative_dialog" ) == "1" )
				thread debug_line(level.player.origin, guy.origin, 5.0, ( 0, 1, 0 ) );
		}
		
		thread context_Sensative_Dialog_Play_Random_Group_Sound( "ai", "wounded_crawl" );
	}
}

context_Sensative_Dialog_Guy_Pain_Falling()
{
	for (;;)
	{
		level waittill ( "ai_pain_falling", guy );
		
		if ( ( isdefined( guy ) ) && ( isdefined( guy.origin ) ) )
		{
			if ( getdvar( "ac130_debug_context_sensative_dialog" ) == "1" )
				thread debug_line(level.player.origin, guy.origin, 5.0, ( 1, 0, 0 ) );
		}
		
		thread context_Sensative_Dialog_Play_Random_Group_Sound( "ai", "wounded_pain" );
	}
}

context_Sensative_Dialog_Guy_Pain()
{
	for (;;)
	{
		level waittill ( "ai_pain", guy );
		
		if ( ( isdefined( guy ) ) && ( isdefined( guy.origin ) ) )
		{
			if ( getdvar( "ac130_debug_context_sensative_dialog" ) == "1" )
				thread debug_line(level.player.origin, guy.origin, 5.0, ( 1, 0, 0 ) );
		}
		
		thread context_Sensative_Dialog_Play_Random_Group_Sound( "ai", "wounded_pain" );
	}
}

context_Sensative_Dialog_Secondary_Explosion_Vehicle()
{
	for (;;)
	{
		level waittill ( "vehicle_explosion", vehicle_origin );
		
		wait 1;
		
		if ( isdefined( vehicle_origin ) )
		{
			if ( getdvar( "ac130_debug_context_sensative_dialog" ) == "1" )
				thread debug_line(level.player.origin, vehicle_origin, 5.0, ( 0, 0, 1 ) );
		}
		
		thread context_Sensative_Dialog_Play_Random_Group_Sound( "explosion", "secondary" );
	}
}

context_Sensative_Dialog_Kill( guy, attacker )
{
	if ( !isdefined( attacker ) )
		return;
	
	if ( attacker != level.player )
		return;
	
	level.enemiesKilledInTimeWindow++;
	level notify ( "enemy_killed" );
	
	if ( ( isdefined( guy ) ) && ( isdefined( guy.origin ) ) )
	{
		if ( getdvar( "ac130_debug_context_sensative_dialog" ) == "1" )
			thread debug_line(level.player.origin, guy.origin, 5.0, ( 1, 1, 0 ) );
	}
}

context_Sensative_Dialog_Kill_Thread()
{
	timeWindow = 1;
	for (;;)
	{
		level waittill ( "enemy_killed" );
		wait timeWindow;
		println ( "guys killed in time window: " );
		println ( level.enemiesKilledInTimeWindow );
		
		soundAlias1 = "kill";
		soundAlias2 = undefined;
		
		if ( level.enemiesKilledInTimeWindow >= 5 )
			maps\_utility::giveachievement_wrapper("STRAIGHT_FLUSH");
			
		if ( level.enemiesKilledInTimeWindow >= 3 )
			soundAlias2 = "large_group";
		else if ( level.enemiesKilledInTimeWindow == 2 )
			soundAlias2 = "small_group";
		else
		{
			soundAlias2 = "single";
			if ( randomint( 3 ) != 1 )
			{
				level.enemiesKilledInTimeWindow = 0;
				continue;
			}
		}
		
		level.enemiesKilledInTimeWindow = 0;
		assert( isdefined( soundAlias2 ) );
		
		thread context_Sensative_Dialog_Play_Random_Group_Sound( soundAlias1, soundAlias2, true );
	}
}

context_Sensative_Dialog_Locations()
{
	array_thread( getentarray( "context_dialog_car",		"targetname" ),	::context_Sensative_Dialog_Locations_Add_Notify_Event, "car" );
	array_thread( getentarray( "context_dialog_truck",		"targetname" ),	::context_Sensative_Dialog_Locations_Add_Notify_Event, "truck" );
	array_thread( getentarray( "context_dialog_building",	"targetname" ),	::context_Sensative_Dialog_Locations_Add_Notify_Event, "building" );
	array_thread( getentarray( "context_dialog_wall",		"targetname" ),	::context_Sensative_Dialog_Locations_Add_Notify_Event, "wall" );
	array_thread( getentarray( "context_dialog_field",		"targetname" ),	::context_Sensative_Dialog_Locations_Add_Notify_Event, "field" );
	array_thread( getentarray( "context_dialog_road",		"targetname" ),	::context_Sensative_Dialog_Locations_Add_Notify_Event, "road" );
	array_thread( getentarray( "context_dialog_church",		"targetname" ),	::context_Sensative_Dialog_Locations_Add_Notify_Event, "church" );
	array_thread( getentarray( "context_dialog_ditch",		"targetname" ),	::context_Sensative_Dialog_Locations_Add_Notify_Event, "ditch" );
	
	thread context_Sensative_Dialog_Locations_Thread();
}

context_Sensative_Dialog_Locations_Thread()
{
	for (;;)
	{
		level waittill ( "context_location", locationType );
		
		if ( !isdefined( locationType ) )
		{
			assertMsg( "LocationType " + locationType + " is not valid" );
			continue;
		}
		
		if ( !flag( "allow_context_sensative_dialog" ) )
			continue;
		
		thread context_Sensative_Dialog_Play_Random_Group_Sound( "location", locationType );
		
		wait ( 5 + randomfloat( 10 ) );
	}
}

context_Sensative_Dialog_Locations_Add_Notify_Event( locationType )
{
	for (;;)
	{
		self waittill ( "trigger", triggerer );
		
		if ( !isdefined( triggerer ) )
			continue;
		
		if ( ( !isdefined( triggerer.team) ) || ( triggerer.team != "axis" ) )
			continue;
		
		level notify ( "context_location", locationType );
		
		wait 5;
	}
}

context_Sensative_Dialog_VehicleSpawn( vehicle )
{
	if ( vehicle.script_team != "axis" )
		return;
	
	thread context_Sensative_Dialog_VehicleDeath( vehicle );
	
	vehicle endon( "death" );
	
	while( !within_fov( level.player getEye(), level.player getPlayerAngles(), vehicle.origin, level.cosine[ "45" ] ) )
		wait 0.5;
	
	context_Sensative_Dialog_Play_Random_Group_Sound( "vehicle", "incoming" );
}

context_Sensative_Dialog_VehicleDeath( vehicle )
{
	vehicle waittill( "death" );
	thread context_Sensative_Dialog_Play_Random_Group_Sound( "vehicle", "death" );
}

context_Sensative_Dialog_Filler()
{
	for(;;)
	{
		if( ( isdefined( level.radio_in_use ) ) && ( level.radio_in_use == true ) )
			level waittill ( "radio_not_in_use" );
		
		// if 3 seconds has passed and nothing has been transmitted then play a sound
		currentTime = getTime();
		if ( ( currentTime - level.lastRadioTransmission ) >= 3000 )
		{
			level.lastRadioTransmission = currentTime;
			thread context_Sensative_Dialog_Play_Random_Group_Sound( "misc", "action" );
		}
		
		wait 0.25;
	}
}

context_Sensative_Dialog_Play_Random_Group_Sound( name1, name2, force_transmit_on_turn )
{
	assert( isdefined( level.scr_sound[ name1 ] ) );
	assert( isdefined( level.scr_sound[ name1 ][ name2 ] ) );
	
	if ( !isdefined( force_transmit_on_turn ) )
		force_transmit_on_turn = false;
	
	if ( !flag( "allow_context_sensative_dialog" ) )
	{
		if ( force_transmit_on_turn )
			flag_wait( "allow_context_sensative_dialog" );
		else
			return;
	}
	
	validGroupNum = undefined;
	
	randGroup = randomint( level.scr_sound[ name1 ][ name2 ].size );
	
	// if randGroup has already played
	if ( level.scr_sound[ name1 ][ name2 ][ randGroup ].played == true )
	{
		//loop through all groups and use the next one that hasn't played yet
		
		for( i = 0 ; i < level.scr_sound[ name1 ][ name2 ].size ; i++ )
		{
			randGroup++;
			if ( randGroup >= level.scr_sound[ name1 ][ name2 ].size )
				randGroup = 0;
			if ( level.scr_sound[ name1 ][ name2 ][ randGroup ].played == true )
				continue;
			validGroupNum = randGroup;
			break;
		}
		
		// all groups have been played, reset all groups to false and pick a new random one
		if ( !isdefined( validGroupNum ) )
		{
			for( i = 0 ; i < level.scr_sound[ name1 ][ name2 ].size ; i++ )
				level.scr_sound[ name1 ][ name2 ][ i ].played = false;
			validGroupNum = randomint( level.scr_sound[ name1 ][ name2 ].size );
		}
	}
	else
		validGroupNum = randGroup;
	
	assert( isdefined( validGroupNum ) );
	assert( validGroupNum >= 0 );
	
	if ( context_Sensative_Dialog_Timedout( name1, name2, validGroupNum ) )
		return;
	
	level.scr_sound[ name1 ][ name2 ][ validGroupNum ].played = true;
	randSound = randomint( level.scr_sound[ name1 ][ name2 ][ validGroupNum ].size );
	playSoundOverRadio( level.scr_sound[ name1 ][ name2 ][ validGroupNum ].sounds[ randSound ], force_transmit_on_turn );
}

context_Sensative_Dialog_Timedout( name1, name2, groupNum )
{
	// dont play this sound if it has a timeout specified and the timeout has not expired
	
	if( !isdefined( level.context_sensative_dialog_timeouts ) )
		return false;
	
	if( !isdefined( level.context_sensative_dialog_timeouts[ name1 ] ) )
		return false;
	
	if( !isdefined( level.context_sensative_dialog_timeouts[ name1 ][name2 ] ) )
		return false;
	
	if( ( isdefined( level.context_sensative_dialog_timeouts[ name1 ][ name2 ].groups ) ) && ( isdefined( level.context_sensative_dialog_timeouts[ name1 ][ name2 ].groups[ string( groupNum ) ] ) ) )
	{
		assert( isdefined( level.context_sensative_dialog_timeouts[ name1 ][ name2 ].groups[ string( groupNum ) ].v[ "timeoutDuration" ] ) );
		assert( isdefined( level.context_sensative_dialog_timeouts[ name1 ][ name2 ].groups[ string( groupNum ) ].v[ "lastPlayed" ] ) );
		
		currentTime = getTime();
		if( ( currentTime - level.context_sensative_dialog_timeouts[ name1 ][ name2 ].groups[ string( groupNum ) ].v[ "lastPlayed" ] ) < level.context_sensative_dialog_timeouts[ name1 ][ name2 ].groups[ string( groupNum ) ].v[ "timeoutDuration" ] )
			return true;
		
		level.context_sensative_dialog_timeouts[ name1 ][ name2 ].groups[ string( groupNum ) ].v[ "lastPlayed" ] = currentTime;
	}
	else if ( isdefined( level.context_sensative_dialog_timeouts[ name1 ][ name2 ].v ) )
	{
		assert( isdefined( level.context_sensative_dialog_timeouts[ name1 ][ name2 ].v[ "timeoutDuration" ] ) );
		assert( isdefined( level.context_sensative_dialog_timeouts[ name1 ][ name2 ].v[ "lastPlayed" ] ) );
		
		currentTime = getTime();
		if( ( currentTime - level.context_sensative_dialog_timeouts[ name1 ][ name2 ].v[ "lastPlayed" ] ) < level.context_sensative_dialog_timeouts[ name1 ][ name2 ].v[ "timeoutDuration" ] )
			return true;
		
		level.context_sensative_dialog_timeouts[ name1 ][ name2 ].v[ "lastPlayed" ] = currentTime;
	}
	
	return false;
}

playSoundOverRadio( soundAlias, force_transmit_on_turn, timeout )
{
	if ( !isdefined( level.radio_in_use ) )
		level.radio_in_use = false;
	if ( !isdefined( force_transmit_on_turn ) )
		force_transmit_on_turn = false;
	if ( !isdefined( timeout ) )
		timeout = 0;
	timeout = timeout * 1000;
	soundQueueTime = gettime();
	
	soundPlayed = false;
	soundPlayed = playAliasOverRadio( soundAlias );
	if ( soundPlayed )
		return;
	
	// Dont make the sound wait to be played if force transmit wasn't set to true
	if ( !force_transmit_on_turn )
		return;
	
	level.radioForcedTransmissionQueue[ level.radioForcedTransmissionQueue.size ] = soundAlias;
	while( !soundPlayed )
	{
		if ( level.radio_in_use )
			level waittill ( "radio_not_in_use" );
		
		if ( ( timeout > 0 ) && ( getTime() - soundQueueTime > timeout ) )
			break;
		
		soundPlayed = playAliasOverRadio( level.radioForcedTransmissionQueue[ 0 ] );
		if ( !level.radio_in_use && !soundPlayed )
			assertMsg( "The radio wasn't in use but the sound still did not play. This should never happen." );
	}
	level.radioForcedTransmissionQueue = array_remove_index( level.radioForcedTransmissionQueue, 0 );
}

playAliasOverRadio( soundAlias )
{
	if ( level.radio_in_use )
		return false;
	
	level.radio_in_use = true;
	level.player playLocalSound( soundAlias, "playSoundOverRadio_done" );
	level.player waittill( "playSoundOverRadio_done" );
	level.radio_in_use = false;
	level.lastRadioTransmission = getTime();
	level notify ( "radio_not_in_use" );
	return true;
}

mission_fail_casualties()
{
	level endon( "stop_casualty_tracking" );
	
	if ( !isdefined( level.friendlyCount ) )
		level.friendlyCount = 0;
	level.friendlyCount++;
	
	self waittill( "death" );
	
	level.friendlyCount--;
	
	if ( level.friendlyCount < level.minimumFriendlyCount )
	{
		flag_set( "mission_failed" );
		setdvar( "ui_deadquote", "@AC130_FRIENDLIES_DEAD" );
		maps\_utility::missionFailedWrapper();
	}
}

debug_friendly_count()
{
	while( getdvar( "ac130_debug_friendly_count") != "1" )
		wait 1;
	
	assert( isdefined( level.friendlyCount ) );
	
	if ( !isdefined( level.friendlyCountHudElem ) )
	{
		level.friendlyCountHudElem = newHudElem();
		level.friendlyCountHudElem.x = 0;
		level.friendlyCountHudElem.y = 0;
		level.friendlyCountHudElem.fontScale = 2.5;
		level.friendlyCountHudElem.alignX = "left";
		level.friendlyCountHudElem.alignY = "bottom";
		level.friendlyCountHudElem.horzAlign = "left";
		level.friendlyCountHudElem.vertAlign = "bottom";
		//level.friendlyCountHudElem.foreground = true;
		level.friendlyCountHudElem.label = &"AC130_DEBUG_FRIENDLY_COUNT";
		level.friendlyCountHudElem.alpha = 1;
	}
	level.friendlyCountHudElem setValue( level.friendlyCount );
	
	self waittill( "death" );
	
	level.friendlyCountHudElem fadeOverTime( 0.3 );
	level.friendlyCountHudElem.alpha = 0;
	waittillframeend;
	level.friendlyCountHudElem setValue( level.friendlyCount );
	level.friendlyCountHudElem fadeOverTime( 0.3 );
	level.friendlyCountHudElem.alpha = 1;
}

debug_circle(center, radius, duration, color, startDelay, fillCenter)
{
	circle_sides = 16;
	
	angleFrac = 360/circle_sides;
	circlepoints = [];
	for(i=0;i<circle_sides;i++)
	{
		angle = (angleFrac * i);
		xAdd = cos(angle) * radius;
		yAdd = sin(angle) * radius;
		x = center[0] + xAdd;
		y = center[1] + yAdd;
		z = center[2];
		circlepoints[circlepoints.size] = (x,y,z);
	}
	
	if (isdefined(startDelay))
		wait startDelay;
	
	thread debug_circle_drawlines(circlepoints, duration, color, fillCenter, center);
}

debug_circle_drawlines(circlepoints, duration, color, fillCenter, center)
{
	if (!isdefined(fillCenter))
		fillCenter = false;
	if (!isdefined(center))
		fillCenter = false;
	
	for( i = 0 ; i < circlepoints.size ; i++ )
	{
		start = circlepoints[i];
		if (i + 1 >= circlepoints.size)
			end = circlepoints[0];
		else
			end = circlepoints[i + 1];
		
		thread debug_line( start, end, duration, color);
		
		if (fillCenter)
			thread debug_line( center, start, duration, color);
	}
}

debug_line(start, end, duration, color)
{
	if (!isdefined(color))
		color = (1,1,1);
	
	for ( i = 0; i < (duration * 20) ; i++ )
	{
		line(start, end, color);
		wait 0.05;
	}
}
