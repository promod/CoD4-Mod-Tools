#include common_scripts\utility;
#include maps\_utility;
#include maps\_utility_code;
#include maps\_vehicle;
#include maps\jeepride_code;
#include maps\_anim;

main()
{
	level.fxplay_writeindex = 0;
	level.startdelay = 0;
	level.recorded_fx_timer = 0;
	level.recorded_fx = [];
	level.sparksclaimed = 0;
	level.whackamolethread = ::whackamole;
	level.playerlinkinfluence = .50;
	level.exploder_fast = [];
	level.cosine = [];
	level.cosine[ "180" ] = cos( 180 );
	level.minBMPexplosionDmg = 50;
	level.maxBMPexplosionDmg = 100;
	level.bmpCannonRange = 4096;
	level.bmpMGrange = 4000;
	level.bmpMGrangeSquared = level.bmpMGrange * level.bmpMGrange;
	level.potentialweaponitems = alltheweapons();
	level.noTankSquish = true;
	level.vehicles_with_drones = [];
	level.drone_unloader = 0;
	level.ai_in_boundry = false;
	level.last_layer_of_death = 0;
	level.passerby_timing_record = [];
	level.passerby_timing = [];
	level.nocompass = true; // keeps introscreen from re-adding the compass after I want it gone.
	
	maps\scriptgen\jeepride_passbytimings::passbytimings();
// level.struct_remove = [];

	array_levelthread( getentarray( "delete_on_load", "targetname" ), ::deleteEnt );
	array_levelthread( getentarray( "delete_on_load", "target" ), ::deleteEnt );

	// precache stuff
	precacherumble( "tank_rumble" );
	precacherumble( "jeepride_bridgesink" );
	precacherumble( "jeepride_cliffblow" );
	precacherumble( "jeepride_pillarblow" );
	precacheItem( "hind_FFAR_jeepride" );// this is kind of dumb
	precacheItem( "hunted_crash_missile" );
	precacheItem( "rpg" );
	
	precacheItem( "colt45_zak_killer" );
	precacheshader( "black" );
	precacheshader( "white" );
	
	precacheshellshock( "jeepride_bridgebang" );
	precacheshellshock( "jeepride_action" );
	precacheshellshock( "jeepride_zak" );
	precacheshellshock( "jeepride_zak_killing" );
	precacheshellshock( "jeepride_rescue" );
	
	precachemodel( "viewhands_player_usmc" );
	precachemodel( "weapon_colt1911_white" );
	precachemodel( "weapon_colt1911_black" );
	precachemodel( "weapon_saw" );

	default_start( ::ride_start );
	add_start( "start", ::ride_start, &"STARTS_START" );
	add_start( "first_hind", ::start_first_hind, &"STARTS_FIRSTHIND" );
	add_start( "against_traffic", ::wip_start, &"STARTS_AGAINSTTRAFFIC" );
	add_start( "final_stretch", ::wip_start, &"STARTS_FINALSTRETCH" );
	add_start( "bridge_explode", ::bridge_explode_start, &"STARTS_BRIDGEEXPLODE" );
	add_start( "bridge_combat", ::bridge_combat, &"STARTS_BRIDGECOMBAT" );
	add_start( "bridge_zak", ::bridge_zak, &"STARTS_BRIDGEZAK" );
	add_start( "bridge_rescue", ::bridge_rescue_start, &"STARTS_BRIDGERESCUE" );
	add_start( "nowhere", ::start_nowhere, &"STARTS_NOWHERE" );

	if ( getdvar( "jeepride_smoke_shadow" ) == "" )
		setdvar( "jeepride_smoke_shadow", "off" );
	if ( getdvar( "jeepride_crashrepro" ) == "" )
		setdvar( "jeepride_crashrepro", "off" );
	if ( getdvar( "jeepride_showhelitargets" ) == "" )
		setdvar( "jeepride_showhelitargets", "off" );
	if ( getdvar( "jeepride_recordeffects" ) == "" )
		setdvar( "jeepride_recordeffects", "off" );
	if ( getdvar( "jeepride_startgen" ) == "" )
		setdvar( "jeepride_startgen", "off" );
	if ( getdvar( "jeepride_rpgbox" ) == "" )
		setdvar( "jeepride_rpgbox", "off" );
	if ( getdvar( "jeepride_nobridgefx" ) == "" )
		setdvar( "jeepride_nobridgefx", "off" );
	if ( getdvar( "jeepride_tirefx" ) == "" )
		setdvar( "jeepride_tirefx", "off" );
	if ( getdvar( "jeepride_player_pickup" ) == "" )
		setdvar( "jeepride_player_pickup", "off" );
	if ( getdvar( "jeepride_multi_shot" ) == "" )
		setdvar( "jeepride_multi_shot", "off" );

	// comment out this to record effects.
	if ( getdvar( "jeepride_crashrepro" ) == "off" && getdvar( "jeepride_recordeffects" ) == "off" )
	 	thread maps\jeepride_fx::jeepride_fxline();

	array_thread( getentarray( "bridge_triggers", "script_noteworthy" ), ::trigger_off );
	array_thread( getentarray( "bridge_triggers2", "script_noteworthy" ), ::trigger_off );

	// todo, convert these to script_structs
	array_thread( getentarray( "ambient_setter", "targetname" ), ::ambient_setter );
	array_thread( getentarray( "sound_emitter", "targetname" ), ::sound_emitter );
	
	maps\jeepride_fx::main();
	
	level.weaponClipModels[ 0 ] = "weapon_ak47_clip";
	level.weaponClipModels[ 1 ] = "weapon_m16_clip";
	level.weaponClipModels[ 2 ] = "weapon_saw_clip";
	level.weaponClipModels[ 3 ] = "weapon_g36_clip";
	
	
	maps\_bm21_troops::main( "vehicle_bm21_mobile_bed_destructible" );
	maps\_bm21_troops::main( "vehicle_bm21_cover_destructible" );
// 	maps\_vehicle::build_aianims( ::bm21_setanims_override, maps\_bm21_troops::set_vehicle_anims );

	maps\_truck::main( "vehicle_pickup_4door" );
	maps\_truck::main( "vehicle_pickup_roobars" );
	build_deathquake( .7, 1.6, 1500 );
	maps\_luxurysedan::main( "vehicle_luxurysedan" );
	build_deathquake( .7, 1.6, 1000 );
	maps\_tanker::main( "vehicle_tanker_truck_civ" );
	build_deathquake( .7, 1.6, 1000 );
	maps\_80s_wagon1::main( "vehicle_80s_wagon1_tan_destructible" );
	maps\_80s_wagon1::main( "vehicle_80s_wagon1_green_destructible" );
	build_deathquake( .7, 1.6, 1000 );
	maps\_80s_hatch1::main( "vehicle_80s_hatch1_silv_destructible" );
	build_deathquake( .7, 1.6, 1000 );
	maps\_small_wagon::main( "vehicle_small_wagon_white" );
	build_deathquake( .7, 1.6, 1000 );
	maps\_bus::main( "vehicle_bus_destructable" );
	build_deathquake( .7, 1.6, 1000 );
	maps\_small_hatchback::main( "vehicle_small_hatchback_turq" );
	build_deathquake( .5, 1.6, 1000 );
	maps\_hind::main( "vehicle_mi24p_hind_woodland" );
	maps\_bmp::main( "vehicle_bmp_woodland_jeepride" );
	maps\_mi28::main( "vehicle_mi-28_flying" );
	maps\_mi17::main( "vehicle_mi17_woodland_fly" );
	maps\_uaz::main( "vehicle_uaz_open_destructible" );
	maps\_uaz::main( "vehicle_uaz_hardtop_destructible" );
	maps\_uaz::main( "vehicle_uaz_fabric_destructible" );
	maps\_uaz::main( "vehicle_uaz_open_for_ride" );
	build_aianims( maps\jeepride_anim::uaz_overrides, maps\jeepride_anim::uaz_override_vehicle );
	maps\_van::main( "vehicle_uaz_van" );
	maps\createart\jeepride_art::main();
	maps\createfx\jeepride_fx::main();

	maps\_load::main();
	
	maps\_treadfx::setallvehiclefx( "mi28", "treadfx/heli_dust_jeepride" );
	maps\_treadfx::setallvehiclefx( "mi17", "treadfx/heli_dust_jeepride" );

	maps\_treadfx::setallvehiclefx( "hind", "treadfx/heli_dust_jeepride" );
	maps\_treadfx::setvehiclefx( "hind", "water", "treadfx/heli_water_jeepride" );
	
	level.player takeweapon ("fraggrenade");
// 	thread fx_thing();
	
	level.player thread shock_ondeath_loc();
	
	maps\jeepride_anim::main_anim();

	level.vehicle_aianimthread[ "hide_attack_forward" ] = maps\jeepride_code::guy_hide_attack_forward;
	level.vehicle_aianimcheck[ "hide_attack_forward" ] = maps\jeepride_code::guy_hide_attack_forward_check;

	level.vehicle_aianimthread[ "hidetoback_attack" ] = 					maps\jeepride_code::guy_hidetoback_startingback;
	level.vehicle_aianimcheck[ "hidetoback_attack" ] = 					maps\jeepride_code::guy_hidetoback_check;
	
	level.vehicle_aianimthread[ "back_attack" ] = 			 		maps\jeepride_code::guy_back_attack;
	level.vehicle_aianimcheck[ "back_attack" ] = 						maps\jeepride_code::guy_hidetoback_check;
	
	level.vehicle_aianimthread[ "hide_attack_left" ] = 				 		maps\jeepride_code::guy_hide_attack_left;
	level.vehicle_aianimcheck[ "hide_attack_left" ] = 							maps\jeepride_code::guy_hide_attack_left_check;
	
	level.vehicle_aianimthread[ "hide_attack_left_standing" ] = 				 		maps\jeepride_code::guy_hide_attack_left_standing;
	level.vehicle_aianimcheck[ "hide_attack_left_standing" ] = 							maps\jeepride_code::guy_hidetoback_check;
	
	level.vehicle_aianimthread[ "hide_attack_back" ] = 			 			maps\jeepride_code::guy_hide_attack_back;
	level.vehicle_aianimcheck[ "hide_attack_back" ] = 						maps\jeepride_code::guy_hide_attack_back_check;
	
	level.vehicle_aianimthread[ "hide_starting_back" ] = 				maps\jeepride_code::guy_hide_starting_back;
	level.vehicle_aianimcheck[ "hide_starting_back" ] = 				maps\jeepride_code::guy_hidetoback_check;
	
	level.vehicle_aianimthread[ "hide_starting_left" ] = 				maps\jeepride_code::guy_hide_startingleft;
	level.vehicle_aianimcheck[ "hide_starting_left" ] = 				maps\jeepride_code::guy_backtohide_check;
	
	level.vehicle_aianimthread[ "backtohide" ] = 										maps\jeepride_code::guy_backtohide;
	level.vehicle_aianimcheck[ "backtohide" ] = 											maps\jeepride_code::guy_backtohide_check;

	level.vehicle_aianimthread[ "react" ] = 										maps\jeepride_code::guy_react;
	level.vehicle_aianimcheck[ "react" ] = 											maps\jeepride_code::guy_react_check;

	if ( !isdefined( level.fxplay_model ) || getdvar( "jeepride_crashrepro" ) != "off" )
	{
		array_thread( getstructarray( "ghetto_tag", "targetname" ), ::ghetto_tag );
		array_thread( getvehiclenodearray( "sparks_on", "script_noteworthy" ), ::trigger_sparks_on );
		array_thread( getvehiclenodearray( "sparks_off", "script_noteworthy" ), ::trigger_sparks_off );
	}

	// asign heros when they spawn

	getent( "gaz", "script_noteworthy" ) add_spawn_function( ::setup_gaz );
	getent( "price", "script_noteworthy" ) add_spawn_function( ::setup_price );
	getent( "griggs", "script_noteworthy" ) add_spawn_function( ::setup_griggs );
	getent( "medic", "script_noteworthy" ) add_spawn_function( ::setup_medic );
	getent( "ru1", "script_noteworthy" ) add_spawn_function( ::setup_ru1 );
	getent( "ru2", "script_noteworthy" ) add_spawn_function( ::setup_ru2 );

	level.lock_on_player_ent = spawn( "script_model", level.player.origin + ( 0, 0, 24 ) );
	level.lock_on_player_ent setmodel( "fx" );
	level.lock_on_player_ent linkto( level.player );
	level.lock_on_player_ent hide();
	level.lock_on_player_ent.script_attackmetype = "missile";
	level.lock_on_player_ent.script_shotcount = 4;
	level.lock_on_player_ent.oldmissiletype = false;
	level.lock_on_player = false;

	battlechatter_off( "allies" );

	thread objectives();

	maps\jeepride_amb::main();

	level.player allowprone( false );
	level.player AllowSprint( false );

// 	array_thread( getvehiclenodearray( "view_magnet", "script_noteworthy" ), ::view_magnet );
// 	array_thread( level.vehicle_spawners, ::all_god );

	array_thread( level.vehicle_spawners, ::process_vehicles_spawned );
 	array_thread( getentarray( "missile_offshoot", "targetname" ), ::missile_offshoot );

	array_thread( getstructarray( "fliptruck_ghettoanimate", "targetname" ), ::fliptruck_ghettoanimate );
	if ( isdefined( level.fxplay_model ) )
	{
		array_thread( getstructarray( "attack_dummy_path", "targetname" ), ::attack_dummy_path );
		array_thread( getstructarray( "vehicle_badplacer", "targetname" ), ::vehicle_badplacer );
		array_thread( getentarray( "exploder", "targetname" ), ::exploder_animate );
		array_thread( getentarray( "exploder", "targetname" ), ::exploder_phys );
	}

	level.struct_remove = undefined;
	level.struct = [];
	level.struct_class_names = undefined;
	level.struct_class_names = [];
	level.struct_class_names[ "target" ] = [];
	level.struct_class_names[ "targetname" ] = [];
	level.struct_class_names[ "script_noteworthy" ] = [];	

	if ( isdefined( level.fxplay_model ) )
	{
		array_thread( getvehiclenodearray( "nodisconnectpaths", "script_noteworthy" ), ::nodisconnectpaths );
		array_thread( getvehiclenodearray( "crazy_bmp", "script_noteworthy" ), ::crazy_bmp );
		array_thread( getvehiclenodearray( "do_or_die", "script_noteworthy" ), ::do_or_die );
		array_thread( getvehiclenodearray( "hillbump", "script_noteworthy" ), ::hillbump );
		array_thread( getvehiclenodearray( "honker_initiate", "script_noteworthy" ), ::honker_initiate );
	}
	
	array_thread( getvehiclenodearray( "bm21_unloader", "script_noteworthy" ), ::bm21_unloader );
	array_thread( getvehiclenodearray( "attacknow", "script_noteworthy" ), ::attacknow );
	array_thread( getvehiclenodearray( "sideswipe", "script_noteworthy" ), ::sideswipe );
	array_thread( getvehiclenodearray( "destructible_assistance", "script_noteworthy" ), ::destructible_assistance );
	array_thread( getvehiclenodearray( "no_godmoderiders", "script_noteworthy" ), ::no_godmoderiders );
	array_thread( getvehiclenodearray( "jolter", "script_noteworthy" ), ::jolter );
	
	
	if ( isdefined( level.fxplay_model ) )
	{
		array_thread( getvehiclenodearray( "clouds_off", "script_noteworthy" ), ::clouds_off );
		array_thread( getvehiclenodearray( "clouds_on", "script_noteworthy" ), ::clouds_on );
		array_thread( getvehiclenodearray( "unloadmanager", "script_noteworthy" ), ::unloadmanager );
	}
	
	array_thread( getentarray( "hindset", "script_noteworthy" ), ::hindset );
	array_thread( getentarray( "hindset_hindbombplayer", "script_noteworthy" ), ::hindset );
	array_thread( getentarray( "hindset_hindbombplayer", "script_noteworthy" ), ::hind_bombplayer );
	getent( "end_hind_action", "script_noteworthy" ) thread end_hind_action();
	getvehiclenode( "end_bmp_action", "script_noteworthy" ) thread end_bmp_action();

	if ( isdefined( level.fxplay_model ) )
	{
		array_thread( getentarray( "magic_missileguy_spawner", "targetname" ), ::magic_missileguy_spawner );
	 	array_thread( getentarray( "stinger_me", "script_noteworthy" ), ::stinger_me );
	 	array_thread( getentarray( "stinger_me_nolock", "script_noteworthy" ), ::stinger_me, false );
		array_thread( getentarray( "all_allies_targetme", "script_noteworthy" ), ::all_allies_targetme );
		array_thread( getentarray( "heli_focusonplayer", "script_noteworthy" ), ::heli_focusonplayer );
		array_thread( getentarray( "exploder", "targetname" ), ::exploder_hack );
		array_thread( getentarray( "hidemeuntilflag", "script_noteworthy" ), ::hidemeuntilflag );
		array_thread( GetSpawnerArray(), ::spawners_setup );
		array_thread( getentarray( "layer_of_death0", "targetname" ), ::layer_of_death, 0 );
		array_thread( getentarray( "layer_of_death1", "targetname" ), ::layer_of_death, 1 );
		array_thread( getentarray( "layer_of_death2", "targetname" ), ::layer_of_death, 2 );
		array_thread( getentarray( "layer_of_death3", "targetname" ), ::layer_of_death, 3 );
		array_thread( getentarray( "layer_of_death4", "targetname" ), ::layer_of_death, 4 );
		array_thread( getentarray( "falltrigger", "targetname" ), ::bridge_fall );
	}
	else
	{
		level.createfxent = [];
// 		level.vehicle_truckjunk = [];
	}
	
	if ( getdvar( "jeepride_startgen" ) != "off" )
		array_thread( getvehiclenodearray( "startgen", "script_noteworthy" ), ::startgen );


	thread bridge_bumper();
	thread bridge_uaz_crash();
	thread dump_passerbys_handle();
	
	flag_init( "end_action_bmp" );
	flag_init( "end_action_hind" );
	flag_init( "rpg_shot" );
	flag_init( "rpg_taken" );
	flag_init( "cover_from_heli" );
	flag_init( "all_end_scene_guys_dead" );
	flag_init( "bridge_zakhaev_setup" );
	flag_init( "no_more_drone_unloaders" );
	flag_init( "murdering_player" );
	flag_init( "cpr_finished" );
	flag_init( "flag_soundbricks_crumbling" );
	flag_init( "slomo_done" );
	flag_init ( "slam_zoom_done" );

// 	flag_init( "attack_heli" );
	
	getent( "ai_spot1", "script_noteworthy" ) hide();
	getent( "ai_spot2", "script_noteworthy" ) hide();
	getent( "ai_spot3", "script_noteworthy" ) hide();

	thread getplayersride();
	thread player_death();

	setsaveddvar( "sm_sunSampleSizeNear", 0.4 );
	setsaveddvar( "sm_sunShadowScale", 0.5 );// optimization

	thread music();
	thread jeepride_start_dumphandle();
	thread speedbumps_setup();
	thread end_ride();
	thread time_triggers();
	
	level.intro_offsets_dialog_time = 10;
	thread dialog_ride_price();
	thread dialog_ride_griggs();
	thread dialog_get_off_your_ass();
	thread dialog_killconfirm();
	thread dialog_rpg();
	thread end_action();
	thread bridge_vehiclde_drone_unloader();
	thread bridge_defence_bounds();
	thread beam_me_up();

// 	thread can_cannon();

	level.earthquake[ "cliff_blow" ][ "magnitude" ] = .7;
	level.earthquake[ "cliff_blow" ][ "duration" ] = 1;
	level.earthquake[ "cliff_blow" ][ "radius" ]  = 1200;
	
	level.earthquake[ "brace_fall" ][ "magnitude" ] = .3;
	level.earthquake[ "brace_fall" ][ "duration" ] = 1.5; 
	level.earthquake[ "brace_fall" ][ "radius" ]  = 2200;

	thread bridge_save();
	
	array_thread( getentarray( "notvehicle", "script_noteworthy" ), ::deleteme );
	wait .05;// what kind of dumb is this?
	setsaveddvar( "compass", "0" );
	
}


slam_zoom_sound()
{
	wait( 0.05 );
	level.player playsound( "ui_camera_whoosh_in" );
	//setsaveddvar( "compass", 0 );
	//SetSavedDvar( "ammoCounterHide", "1" );
}

slam_zoom_intro()
{
	slowmo_start();
		slowmo_setlerptime_in( 0.25 );
		slowmo_setlerptime_out( 0.25 );
		
		level.player freezeControls( true );
		level.player disableweapons();
		level.player setplayerangles( ( 0, 0, 0 ) );
	
		level.player allowcrouch( false );
		level.player allowprone ( false );
//		thread slam_zoom_sound();
	
		origin = getent("slam_zoom_start","targetname");
		target_org = getent(origin.target,"targetname").origin;
		start_origin = origin.origin;
		
		ent = spawn( "script_model", start_origin );
		ent setmodel( "tag_origin" );

		ent.angles = vectortoangles(target_org-start_origin);
		level.player PlayerLinkToDelta( ent, "tag_origin", 1, 0, 0, 0, 0 );
		wait .05;
		setsaveddvar("cg_fov", 55 );
		
		time = 4.5;
//		delaythread(2.5, ::lerp_fov_overtime, 1, 65 );
		thread lerp_fov_overtime( 8, 65 );

		ent moveto ( target_org, time, 2.5, 1 );
		
		wait 3;
		wait 0.525;
//		slowmo_lerp_in();
		wait( 0.25 );
//		ent rotateto( ( -8.4547, 171.59, 0 ), .2,0,0 );
		thread whitescreen();
		array_levelthread( getentarray("slam_zoom_backdrop","targetname"), ::deleteent);
		wait( 0.45 );
		level.player setplayerangles( ( -8.4547, 171.59, 0 ) );
		player_link_update();
		level.player allowcrouch( true );
		
		wait( 0.05 );
//		slowmo_lerp_out();
	slowmo_end();;//reset defaults

	flag_set ( "slam_zoom_done" );
	//println ( "origin goal: " + level.piggyback_guy.origin );
	
	thread play_sound_in_space( "ui_screen_trans_in", level.player.origin );
	
	wait( 0.2 );
	
	
    level.player EnableWeapons();
	
	thread play_sound_in_space( "ui_screen_trans_out", level.player.origin );
	
	wait( 0.2 );
	
	level notify("introscreen_complete"); // Do final notify when player controls have been restored
		
	wait( 2 );
	level notify( "destroy_hud_elements" );
	//setsaveddvar( "compass", 1 );
	//SetSavedDvar( "ammoCounterHide", "0" );
	
	ent delete();
	
	autosave_by_name( "levelstart" );
	//wait 5;
	
}

whitescreen()
{
	wait( 0.2 );
	overlay = newHudElem();
	overlay.x = 0;
	overlay.y = 0;
	overlay setshader( "white", 640, 480 );
	overlay.alignX = "left";
	overlay.alignY = "top";
	overlay.horzAlign = "fullscreen";
	overlay.vertAlign = "fullscreen";
	overlay.alpha = 0;
	overlay fadeOverTime( 0.15 );
	overlay.alpha = 1;
	wait( 0.35 );
	overlay fadeOverTime( 0.15 );
	overlay.alpha = 0;
	wait( 0.15 );
	overlay destroy();
}


end_ride()
{
	flag_wait( "end_ride" );// set by script_flag_set in radiant
	
	setsaveddvar( "sm_sunsamplesizenear", 0.25 );// default
	if ( level.start_point == "bridge_combat" || level.start_point == "bridge_zak" 
	 || level.start_point == "bridge_rescue" )
		return;

	array_thread( getentarray( "bridge_triggers", "script_noteworthy" ), ::trigger_on );

	bridge_transition();
}


getplayersride()
{
	flag_init( "playersride_init" );
	level.playersride = waittill_vehiclespawn( "playersride" );
	level.playersride.dontunloadonend = true;
	level.playersride godon();
	level.lock_on_player_ent unlink();
	level.lock_on_player_ent.origin = level.playersride.origin + ( 0, 0, 24 );
	level.lock_on_player_ent linkto( level.playersride );
	flag_set( "playersride_init" );
}

ride_start()
{
	thread maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 44 );
	thread maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 46 );

	// players ride
	thread maps\_vehicle::scripted_spawn( 45 );

	flag_wait( "playersride_init" );
	level.playersride.target = "playerspath";
	level.playersride getonpath();
	thread slam_zoom_intro();
	thread gopath( level.playersride );
}

wip_start()
{
	array_thread( getvehiclenodearray( level.start_point, "script_noteworthy" ), ::sync_vehicle );
// 	array_thread( getvehiclenodearray( "dumpstart_node", "targetname" ), ::sync_vehicle );
	flag_wait( "playersride_init" );
	player_link_update();
}

music_zak_timing()
{
	//wait 2.9;
	wait 2.75;
	flag_set( "music_zak" );
}

music()
{
	flag_init( "music_bridge" );
	flag_init( "music_zak" );
	flag_init( "music_lastman" );
	flag_init( "music_rescue" );
	waittillframeend;
	music_flagged( "jeepride_chase_music", "music_bridge" );
	music_flagged( "jeepride_defend_music", "music_zak" );
	music_flagged( "jeepride_showdown_music", "music_rescue", false );
// 	music_flagged( "jeepride_lastman_music", "music_rescue" );

	MusicPlayWrapper( "jeepride_rescue_music", false );
}

music_flagged( music, flag, timescaleeffect )
{
	if ( !isdefined( timescaleeffect ) )
		timescaleeffect = true;
	if ( level.flag[ flag ] )
		return;
	MusicPlayWrapper( music, timescaleeffect );
	flag_wait( flag );
	musicstop();
	wait .2;
}

music_defend()
{
	MusicPlayWrapper( "jeepride_defend_music" );
	shocktime = 43;
// 	level.player shellshock( "jeepride_action", shocktime );
	wait shocktime;
}


time_triggers()
{
	
	flag_init("aa_riding_rpg_attackers");
	flag_init("aa_riding_hind_attacker");
	flag_init("aa_bridge_forth");
	flag_init("aa_riding_pre_rpg_attackers");

	waittillframeend;
	waittillframeend;
	
	flag_set("aa_riding_pre_rpg_attackers");
	thread delaythread_loc( 51, ::flag_set, "aa_riding_rpg_attackers" );
	thread delaythread_loc( 101, ::flag_set, "aa_riding_hind_attacker" );
	thread delaythread_loc( 159, ::flag_set, "aa_bridge_forth" );
	
	if(level.start_point == "nowhere")
		return;

	if ( getdvar( "start" ) != "wip" )
	{
		thread delaythread_loc( 12, ::autosave_now_loc, "down_the_hill" );
		thread delaythread_loc( 57, ::autosave_now_loc, "First Tunnel Exit" );
		
		thread delaythread_loc( 100, ::reset_autosave_condition );  // rpg guy got thrown instead of killed
		thread delaythread_loc( 100, ::player_link_update );
		
		thread delaythread_loc( 102, ::autosave_now_loc, "Hind Chase" );
		thread delaythread_loc( 160, ::autosave_now_loc, "Bridge Blown" );
		
	}
	
	//hack to keep the players view from clipping into the side. I would use delta link all the time but it's kind of strange and off. feeling
	thread delaythread_loc(36, ::player_link_update_delta );
	thread delaythread_loc(42, ::player_link_update );
	

	thread delaythread_loc( 0, ::play_sound_in_space, "scn_jeepride_dirt1_opening", level.player.origin, true  );
	thread delaythread_loc( 37, ::play_sound_in_space, "scn_jeepride_dirt2_roadside", level.player.origin, true  );
	thread delaythread_loc( 82, ::play_sound_in_space, "scn_jeepride_dirt3_medianskid", level.player.origin, true  );
	thread delaythread_loc( 94, ::play_sound_in_space, "scn_jeepride_dirt4_medianslide", level.player.origin, true  );
	thread delaythread_loc( 113, ::play_sound_in_space, "scn_jeepride_dirt5_mediancross", level.player.origin, true );
	thread delaythread_loc( 91, ::player_link_update, .3 );

	thread delaythread_loc( 122, ::fake_water_tread );
	thread delaythread_loc( 128, ::stop_fake_water_tread );
	
	level.player thread delaythread_loc( 96, ::play_sound_in_space,"exp_tanker_vehicle" ); 
}

dialog_ride_price()
{
	if(level.start_point == "nowhere")
		return;

	wait 1;
	level.price delaythread_loc( 6.5 +level.intro_offsets_dialog_time, ::anim_single_queue, level.price, "jeepride_pri_helistatus" );
	level.player delaythread_loc( 10 +level.intro_offsets_dialog_time, ::play_sound_on_entity, "jeepride_hqr_griggsisnthere" );
	level.price delaythread_loc( 15 +level.intro_offsets_dialog_time, ::anim_single_queue, level.price, "jeepride_pri_notgood" );
	level.price delaythread_loc( 16 +level.intro_offsets_dialog_time, ::anim_single_queue, level.price, "jeepride_pri_truckleft" );
//	level.price delaythread_loc( 32, ::anim_single_queue, level.price, "jeepride_pri_truckleft" );
	level.price delaythread_loc( 48, ::anim_single_queue, level.price, "jeepride_pri_coverrear" );
	level.price delaythread_loc( 78, ::anim_single_queue, level.price, "jeepride_pri_company" );
	level.price delaythread_loc( 81, ::anim_single_queue, level.price, "jeepride_pri_takinghits" );
	level.price delaythread_loc( 88, ::anim_single_queue, level.price, "jeepride_pri_takeouttruck" );
	level.price delaythread_loc( 100, ::anim_single_queue, level.price, "jeepride_pri_hind6oclock" );
	level.price delaythread_loc( 152, ::anim_single_queue, level.price, "jeepride_pri_buggered" );
	
	// gaz finally speaks up.. heh
	level.gaz delaythread_loc( 155, ::anim_single_queue, level.gaz, 	"jeepride_gaz_goodenough" );
	level.gaz delaythread_loc( 161, ::anim_single_queue, level.gaz, 	"jeepride_gaz_stopbloodytruck" );

}

dialog_bridge_radio()
{
	battlechatter_on( "axis" );
	battlechatter_off( "allies" );
	level.gaz anim_single_solo( level.gaz, "jeepride_gaz_heavyattackbridge" );
	level.griggs play_sound_on_entity( "jeepride_hqr_workinonit" );
	level.gaz anim_single_solo( level.gaz, "jeepride_gaz_uselesswanker" );
	wait 2;
	level.price anim_single_solo( level.price, "jeepride_pri_sitreponhelis" );
	level.gaz anim_single_solo( level.gaz, "jeepride_gaz_wereonourown" );
	
	wait 3;
	battlechatter_on( "allies" );
	wait 7.5;
	battlechatter_off( "allies" );
	wait .5;
	level.griggs play_sound_on_entity( "jeepride_kmr_couldusehelp" );
	level.gaz anim_single_solo( level.gaz, "jeepride_gaz_goodtohear" );
	wait 1;
	level.griggs play_sound_on_entity( "jeepride_kmr_standbyalmostthere" );
	wait 1;
	battlechatter_on( "allies" );
	wait 3;
	
//	jeepride_grg_tankabouttoblow

	level.griggs play_sound_on_entity( "jeepride_grg_tankabouttoblow" );
	


// 	level.griggs play_sound_on_entity( "jeepride_hqr_workinonit" );
}


dialog_ride_griggs()
{
	if(level.start_point == "nowhere")
		return;
	
	delaythread( 145, ::end_print_fx );
	wait 1;
	level.griggs delaythread_loc( 9.5, ::anim_single_queue, level.griggs, "jeepride_grg_hangon" );
	level.griggs delaythread_loc( 12.5 , ::anim_single_queue, level.griggs, "jeepride_grg_truck6oclock" );
	level.griggs delaythread_loc( 107, ::anim_single_queue, level.griggs, "jeepride_grg_rpgfirehind" );
	level.griggs delaythread_loc( 122, ::anim_single_queue, level.griggs, "jeepride_grg_hind9oclock" );
	level.griggs delaythread_loc( 127, ::anim_single_queue, level.griggs, "jeepride_grg_hangon" );
	level.griggs delaythread_loc( 132, ::anim_single_queue, level.griggs, "jeepride_grg_rpgfirehind" );
	level.griggs delaythread_loc( 147, ::anim_single_queue, level.griggs, "jeepride_grg_hind12oclock" );
	level.griggs delaythread_loc( 157, ::anim_single_queue, level.griggs, "jeepride_grg_takeoutbridge" );
}

end_print_fx()
{
	if ( !isdefined( level.fxplay_model ) )
		maps\jeepride_fx::playfx_write_all( level.recorded_fx );
}


blown_bridge( eTarget )
{
	while ( isdefined( eTarget ) && distance2d( self.origin, eTarget.origin ) > 350 && isdefined( self ) )
		wait 0.05;
	blow_bridge();
}

blow_bridge()
{
	level notify( "bridge_blower" );// oh man I hope nobody ever looks at this script.
	if ( isdefined( level.bridgeblown ) )
		return;
	level.bridgeblown = true;

	Earthquake( 1.3, .5, ( -35893.6, -15878.5, 460 ), 2500 );
	level.player playrumbleonentity( "tank_rumble" );
	exploder_loc( 3 );
}

setup_gaz()
{
	level.gaz = self;
	level.gaz.animname = "gaz";
	level.gaz thread magic_bullet_shield();
	level.gaz thread make_hero();
}

setup_price()
{
	level.price = self;
	level.price.animname = "price";
	level.price thread magic_bullet_shield();
	level.price thread make_hero();
}

setup_griggs()
{
	level.griggs = self;
	level.griggs.animname = "griggs";
	level.griggs thread magic_bullet_shield();
	level.griggs thread make_hero();
}

setup_medic()
{
	level.medic = self;
	level.medic.animname = "medic";
	level.medic thread magic_bullet_shield();
	level.medic thread make_hero();
}

setup_ru1()
{
	level.ru1 = self;
	level.ru1.animname = "ru1";
	level.ru1.script_char_index = 1; //we'll see if this works
}

setup_ru2()
{
	level.ru2 = self;
	level.ru2.animname = "ru2";
}

dialog_get_off_your_ass()
{
	laststand_time = gettime();
	lasttold_time = gettime();
	level.player endon ("death");

	telltimer = 10000;
	sittimer = 4000;

	level endon( "newrpg" );
	level endon( "bridge_sequence" );
	
	while ( 1 )
	{
		if ( level.player getstance() == "stand" )
			laststand_time = gettime();
		time = gettime();
		if ( time - laststand_time > sittimer && time - lasttold_time > telltimer )
		{
			lasttold_time = gettime();
			level.price anim_single_queue( level.price, "jeepride_pri_getoffyour" );
		}
		wait .05;
	}
}

allowallstances()
{
	self allowedstances( "stand", "crouch", "prone" );
}




bridge_transition()
{
	bridge_startspot = getent( "bridge_startspot", "targetname" );
// 	level.player FreezeControls( true );
	intime = 2;
	fullalphatime = .5;
	outtime = 2;

// 	thread smokey_transition( intime, outtime, fullalphatime );

	level.player takeallweapons();

	thread bridge_setupguys( intime );
	
	black_overlay = create_overlay_element( "black", 0 );
	black_overlay thread exp_fade_overlay( 1, intime );
	wait intime;
	maps\_loadout::give_loadout(); // refresh all the guns and ammo.
	setsaveddvar( "compass", "1" );

	exploder_loc( 71 );
	exploder_loc( 73 );
	array_thread( getaiarray( "allies" ), ::ClearEnemy_loc );

	clear_all_vehicles_but_heros_and_hind();

	level.player unlink();
//	level.player.origin = bridge_startspot.origin;
//	level.player setplayerangles( bridge_startspot.angles );
	struct = spawnstruct();
//	struct thread function_stack( ::player_fudge_moveto, bridge_startspot.origin + ( 0, 0, 48 ), 140 );
	struct thread function_stack( ::player_fudge_moveto, bridge_startspot.origin, 280 );
	thread player_fudge_rotateto( bridge_startspot.angles, fullalphatime );
	
// 	level.player thread lerp_player_view_to_position( bridge_startspot.origin, bridge_startspot.angles, 2, 1 );
// 	level.player setorigin( bridge_startspot.origin );
// 	level.player setplayerangles( bridge_startspot.angles );
	level.player ShellShock( "jeepride_bridgebang", 15 );
	wait fullalphatime;
	level.player allowstand( true );
	level.player allowprone( true );
	level.player allowsprint( true );
	black_overlay thread exp_fade_overlay( 0, outtime);
	
	wait outtime * .6;
	level.player FreezeControls( false );
	wait outtime * .4;
	flag_set( "bridge_sequence" );// some exploder motion paths wait on this to go
	exploder_loc( 72 );
	array_thread( getentarray( "bridge_triggers", "script_noteworthy" ), ::trigger_on );
	thread autosave_now_loc();
	activate_trigger_with_targetname( "bridge_enemies" );
}

bridge_setupguys( intime )
{
	platform1 = getnode( "platform1", "targetname" );
	platform2 = getnode( "platform2", "targetname" );
	platform3 = getnode( "platform3", "targetname" );
	ai_spot1 = getent( "ai_spot1", "script_noteworthy" );
	ai_spot2 = getent( "ai_spot2", "script_noteworthy" );
	ai_spot3 = getent( "ai_spot3", "script_noteworthy" );
	ai_spot1 hide();
 	ai_spot2 hide();
	ai_spot3 hide();
	level.price unlink();
	
	guy_force_remove_from_vehicle( level.price.ridingvehicle, level.price, ai_spot1.origin );
	
	level.price linkto( ai_spot1, "polySurface1", ( 0, 0, 0 ), ( 0, 0, 0 ) );
	level.price teleport( ai_spot1.origin, ( 0, 0, 0 ) );
	level.price hide();
	
	setsaveddvar("ai_friendlyFireBlockDuration", 0);
	level.price.a.disablePain = true;
	level.price.ignoresuppression = true;

	guy_force_remove_from_vehicle( level.griggs.ridingvehicle, level.griggs, ai_spot2.origin );
	level.griggs unlink();
	level.griggs linkto( ai_spot2, "polySurface1", ( 0, 0, 0 ), ( 0, 0, 0 ) );
	level.griggs thread force_position( ai_spot2.origin );         
	level.griggs unlink();

	guy_force_remove_from_vehicle( level.gaz.ridingvehicle, level.gaz, ai_spot3.origin );
	level.gaz unlink();
	level.gaz linkto( ai_spot3, "polySurface1", ( 0, 0, 0 ), ( 0, 0, 0 ) );
	level.gaz thread force_position( ai_spot3.origin );         
	level.gaz unlink();

	ai = getaiarray( "allies" );
	for ( i = 0; i < ai.size; i++ )
	{
		
		if ( ai[ i ] ishero() )
			continue;
		if ( isdefined( ai[ i ].magic_bullet_shield ) && ai[ i ].magic_bullet_shield )
		{
			ai[ i ] stop_magic_bullet_shield();
			ai[ i ] delete();
		}
	}

	animtimebeforevisisible = intime - 1;
	wait animtimebeforevisisible;
	thread price_bridge_crawl_anims( ai_spot1 );
// 	ai_spot1 thread anim_single_solo( level.price, "wave_player_over" );
	wait intime - animtimebeforevisisible;
	level.price show();
	wait 2;
	level.price thread anim_single_queue( level.price, "jeepride_pri_thebridge" );
	wait 4;
	level.griggs unlink();
	level.price pushplayer( true );
	level.price unlink();
	wait 1;
	level.price pushplayer( true );
	level.price thread maps\_spawner::go_to_node( platform1 );
	wait 2;
	
	level.griggs thread anim_single_queue( level.griggs, "jeepride_grg_bouttocollapse" );

// 	level.price thread maps\_spawner::go_to_node( platform3 );

	exploder(11); // hack.  calls this exploder so that the disconnect path will happen allowing price to continue on the bridge faster.
	activate_trigger_with_targetname( "allies_startcolor" );
	flag_set( "music_bridge" );
	create_vehicle_from_spawngroup_and_gopath( 66 );
	
	wait 5;
// 	level.price anim_single_queue( level.price, "jeepride_pri_thebridge" );
	wait 5;
	setup_bridge_defense();
}

bridge_explode_start()
{
	thread bridge_explode_onstart();
	wip_start();
}

bridge_explode_onstart()
{
	getvehiclenode( "bridge_explode_onstart", "script_noteworthy" ) waittill( "trigger" );
	blow_bridge();
}

setup_bridge_defense()
{
	node = getnode( "bridge_defendnode", "targetname" );

// 	array_thread( getaiarray( "allies" ), maps\_spawner::go_to_node, node );

	thread dialog_bridge_radio();
	remove_non_hero_shields();
	thread encroacher();
	array_thread( getaiarray(), ::allowallstances );// blah.
	wait 3;
	activate_trigger_with_targetname( "bridgealliesinplace" );
	flag_wait_or_timeout( "no_more_drone_unloaders", 45 );
	create_vehicle_from_spawngroup_and_gopath( 72 );

}



bridge_combat()
{
	flag_set( "music_bridge" );
	level.startdelay = 250000;
	// just setting up a / start spot here.
	
	
	bridge_combat_price = getent( "bridge_combat_price", "targetname" );
	bridge_combat_griggs = getent( "bridge_combat_griggs", "targetname" );
	bridge_combat_player = getent( "bridge_combat_player", "targetname" );


	spawn_heros_for_start( bridge_combat_price.origin, bridge_combat_griggs.origin, bridge_combat_griggs.origin + ( 0, 128, 0 ) );

	level.player setorigin( bridge_combat_player.origin );


	create_vehicle_from_spawngroup_and_gopath( 66 );
	exploder_loc( 3, true );
	exploder_loc( 71, true );
	exploder_loc( 72, true );
	exploder_loc( 73 );

	array_thread( getentarray( "bridge_triggers", "script_noteworthy" ), ::trigger_on );

// 	battlechatter_on( "allies" );

	flag_set( "end_ride" );
	flag_set( "bridge_sequence" );



	level.player allowstand( true );
	level.player allowprone( true );
	level.player allowsprint( true );
	wait 1;
	setup_bridge_defense();
	wait .1;

}

spawn_heros_for_start( priceorg, griggsorg, gazorg )
{
	spawner = getent( "price", "script_noteworthy" );
	spawner.origin = priceorg;
	spawned = spawner stalingradspawn();
	
	spawn_failed( spawned ) ;

	spawner = getent( "griggs", "script_noteworthy" );
	spawner.origin = griggsorg;
	spawned = spawner stalingradspawn();
	spawn_failed( spawned );
	
	spawner = getent( "gaz", "script_noteworthy" );
	spawner.origin = gazorg;
	spawned = spawner stalingradspawn();
	spawn_failed( spawned );
}

bridge_zak()
{
// 	disable_bridge_triggers_for_zak_start();
	level.startdelay = 250000;

	bridge_combat_price = getent( "zak_price_spot", "targetname" );
	bridge_combat_griggs = getent( "zak_griggs_spot", "targetname" );
	bridge_combat_player = getent( "zak_player_spot", "targetname" );
	level.player setorigin( bridge_combat_player.origin );
	
	spawn_heros_for_start( bridge_combat_price.origin, bridge_combat_griggs.origin, bridge_combat_player.origin );
	
	flag_set( "end_ride" );
	flag_set( "bridge_sequence" );
	flag_set( "van_smash" );
	flag_set( "music_bridge" );
	flag_set( "music_zak" );

// 	thread spawn_vehiclegroup_and_go_to_end_node_quick_and_then_blow_up_boy_this_function_name_is_sure_going_to_make_mackey_smile( 66 );
// 	thread spawn_vehiclegroup_and_go_to_end_node_quick_and_then_blow_up_boy_this_function_name_is_sure_going_to_make_mackey_smile( 67 );
// 	thread spawn_vehiclegroup_and_go_to_end_node_quick_and_then_blow_up_boy_this_function_name_is_sure_going_to_make_mackey_smile( 68 );

// 	exploder_loc( 3, true );
// 	exploder_loc( 71, true );
// 	exploder_loc( 72, true );
	exploder_loc( 73, true );

	wait 4.5;
	ai = getaiarray();
	for ( i = 0; i < ai.size; i++ )
	{
		if ( ai[ i ] ishero() )
			continue;
		if ( isdefined( ai[ i ].magic_bullet_shield ) && ai[ i ].magic_bullet_shield )
			ai[ i ] stop_magic_bullet_shield();
		ai[ i ] delete();
	}
	
	level.hind = create_vehicle_from_spawngroup_and_gopath( 70 )[ 0 ];

	bridge_zakhaev();
}

hindset()
{
	self waittill( "trigger", other );
	level.hind = other;
}


spawn_vehiclegroup_and_go_to_end_node_quick_and_then_blow_up_boy_this_function_name_is_sure_going_to_make_mackey_smile( group )
{
	vehicle_array = create_vehicle_from_spawngroup_and_gopath( group );
	for ( i = 0; i < vehicle_array.size; i++ )
	{
		vehicle_array[ i ] setspeed( 200, 200 );
		vehicle_array[ i ] thread blow_up_at_end_node();
	}
}

disable_bridge_triggers_for_zak_start()
{
	bridge_triggers = getentarray( "bridge_triggers", "script_noteworthy" );
	for ( i = 0; i < bridge_triggers.size; i++ )
	{
// 		if ( bridge_triggers[ i ].script_vehiclespawngroup == "67"
// 				 || bridge_triggers[ i ].script_vehiclespawngroup == "66" )
			bridge_triggers[ i ] trigger_off();

	}
}

blow_up_at_end_node()
{
	self waittill( "reached_end_node" );
	self.godmode = false;
	if ( self isDestructible() )
		maps\_destructible::force_explosion();
	else
		self notify( "death" );
}

switch_team_fordamage()
{
	if ( self.vehicletype == "hind" || self.vehicletype == "bmp" )
		return;
	self.script_team = "allies";// so hind can start blowing stuff up
	while ( 1 )
	{
		self waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName );
		if ( isdefined( attacker.classname ) && attacker.classname == "misc_turret" )
			break;
		if ( isdefined( attacker.vehicletype ) && ( attacker.vehicletype == "hind" || attacker.vehicletype == "bmp" )  )
			break;
	}
	// they don't normally take damage from anything but the player.
	self godoff();
	if ( self isDestructible() )
		maps\_destructible::force_explosion();
	self notify( "death" );
}

destructible_crumble( attacker )
{
	destructibleparts = level.destructible_type[ self.destuctableInfo ].parts;
	for ( i = 1; i < destructibleparts.size; i++ )
	{
		states = destructibleparts[ i ];
		for ( j = 0; j < states.size; j++ )
		{
			if ( !isdefined( destructibleparts[ i ][ j ].v[ "tagName" ] ) || ! isdefined( destructibleparts[ i ][ j ].v[ "modelName" ] ) ) 
				continue;
			self notify( "damage", 300, attacker, self gettagangles( destructibleparts[ i ][ j ].v[ "tagName" ] ), self gettagorigin( destructibleparts[ i ][ j ].v[ "tagName" ] ), "bullet", destructibleparts[ i ][ j ].v[ "modelName" ], destructibleparts[ i ][ j ].v[ "tagName" ] );
			wait .05;
		}
	}
// 	level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ stateIndex ].v[ "modelName" ] = modelName;
// 	level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ].v[ "tagName" ] = tagName;
}


remove_non_hero_shields()
{
	ai = getaiarray( "allies" );
	for ( i = 0; i < ai.size; i++ )
		if ( !( ai[ i ] ishero() ) && isdefined( ai[ i ].magic_bullet_shield ) && ai[ i ].magic_bullet_shield )
			ai[ i ] stop_magic_bullet_shield();
}

end_hind_action()
{
	self waittill( "trigger", other );
	level.hind = other;
	other setlookatent( level.player );
	other setTurretTargetEnt( level.player );
	other SetHoverParams( 40, 20, 15 );
	
	flag_set( "end_action_hind" );
	
	level.lock_on_player_ent.script_attackmetype = "mg_burst";
	level.lock_on_player_ent unlink();
	level.lock_on_player_ent.origin = level.player geteye();
	level.lock_on_player_ent linkto( level.player );

	other endon( "stop_killing_theplayer" ) ;

	wait 2;	
	other shootnearest_non_hero_friend();
// 	other shoot_the_vehicles();
	other shootnearest_non_hero_friend();
}

refresh_burst( lockent )
{
	lockent endon( "death" );
	self endon( "death" );
	while ( 1 )
	{
		lockent.script_attackmetype = "mg_burst";// hacks abound
		wait 2;
	}
}

random_around_player( offset )
{
	x = -1 * offset + randomfloat( 2 * offset );
	y = -1 * offset + randomfloat( 2 * offset );
	z = 0;
	return level.player.origin + ( x, y, z );
}

ignoreall_for_running_away()
{
	self endon( "death" );
	self.ignoreSuppression = true;
	self.ignoreall = true;
	wait 3;
	self.ignoreSuppression = false;
	self.ignoreall = false;
}

objectives()
{
	flag_init( "objective_off_the_bridge" );
	flag_init( "objective_finishedthelevel" );
	objective_add( 1, "active", &"JEEPRIDE_SURVIVE_THE_ESCAPE" );
	objective_current( 1 );
	flag_wait( "objective_finishedthelevel" );
	objective_state( 1, "done" );
	
}

enemys_run_to_safety()
{
	ai = getaiarray( "axis" );
	points = getentarray( "endenemypile", "targetname" );
	pointindex = 0;
	for ( i = 0; i < ai.size; i++ )
	{
		ai[ i ] disable_ai_color();
		ai[ i ].goalradius = 32;
		ai[ i ] setgoalpos( points[ pointindex ].origin );
		ai[ i ] thread ignoreall_for_running_away();
		pointindex++ ;
		if ( pointindex == points.size )
			pointindex = 0;
	}
}

end_action()
{
	flag_wait( "end_action_bmp" );
// 	thread add_dialogue_line( "Price", "Fall back!" );

	remove_non_hero_shields();

	flag_wait( "end_action_hind" );
	
	// friendlies use color nodes to run away
	activate_trigger_with_targetname( "friends_fall_back" );
	
	// enemies use this ghetto script to run away
	enemys_run_to_safety();
	
	array_thread( getentarray( "script_vehicle", "classname" ), ::switch_team_fordamage );
	array_thread( getentarray( "bridge_triggers", "script_noteworthy" ), ::trigger_off );
	array_thread( getaiarray( "allies" ), ::ignoreall_for_running_away );
	// todo, failsafe this. possible to sprint back and miss the trigger.( make trigger encompass more area )
	array_thread( getentarray( "bridge_triggers2", "script_noteworthy" ), ::trigger_on );
	thread bridge_blow_trigger();
}

end_bmp_action()
{
	level endon( "bridge_zakhaev_setup" );// this guy is still going on the start position
	self waittill( "trigger", other );
	flag_set( "end_action_bmp" );
	other thread vehicle_turret_think();
}

bridge_blow_trigger()
{
// 	array_thread( getentarray( "cover_from_heli", "targetname" ), ::trigger_set_cover_from_heli );
// 	flag_wait( "cover_from_heli" );
	wait .5;
	bridge_zakhaev();
}

trigger_set_cover_from_heli()
{
	level endon( "cover_from_heli" );
	if ( !level.player istouching( self ) )
		self waittill( "trigger" );
	flag_set( "cover_from_heli" );
}

attack_origin_with_targetname( targetname )
{
	origin = getent( targetname, "targetname" ).origin;
	BadPlace_Cylinder( "tanktarget", 4, origin, 750, 300, "allies", "axis" );
	self SetTurretTargetvec( origin );
	self waittill( "turret_on_target" );
	vehicle_fire_main_cannon( 24 );
}

#using_animtree( "generic_human" );

force_position( origin, angles )
{
	if ( !isdefined( angles ) )
		angles = ( 0, 0, 0 );

// 	while ( 1 )
// 	{                      
		self dontinterpolate();
		self animscripted( "forcemove", origin, ( 0, 88, 0 ), %dying_crawl );
// 		self waittillmatch( "forcemove", "end" );
		
// 	}
}

dying_crawl()
{
	self endon( "death" );
	self.holdingWeapon = false;
	self animscripts\shared::placeWeaponOn( self.weapon, "none" );
	while ( 1 )
	{
		self animscripted( "dieingcrawl", self.origin, ( 0, 88, 0 ), %dying_crawl );
		self waittillmatch( "dieingcrawl", "end" );
	}
}

angletoplayer()
{
	return vectortoangles( level.player.origin - self.origin );
}

bridge_zakhaev_shock()
{
	level.player ShellShock( "jeepride_zak", 60 );
}


escape_shellshock_heartbeat()
{
	level endon( "stop_heartbeat_sound" );
	interval = -.5;
	while ( 1 )
	{
		level.player play_sound_on_entity( "breathing_heartbeat" );
		if ( interval > 0 )
			wait interval;
		interval += .1;
	}
}



escape_shellshock_thing( playerview )
{
	playfx( level._effect[ "player_explode" ], level.player geteye() );
	
	// breathing sounds
	level.player delayThread( 1.5, ::play_sound_on_entity, "breathing_hurt_start" );
	level.player delayThread( 2.5, ::play_sound_on_entity, "breathing_hurt" );
	level.player delayThread( 4, ::play_sound_on_entity, "breathing_hurt" );
	level.player delayThread( 5, ::play_sound_on_entity, "breathing_hurt" );
	level.player delayThread( 13, ::play_sound_on_entity, "breathing_better" );
	level.player delayThread( 16, ::play_sound_on_entity, "breathing_better" );
	thread overlaysmoke();
	black_overlay = create_overlay_element( "black", 0 );
	black_overlay thread exp_fade_overlay( 1, .55 );

	earthquake( .65, 1, level.player.origin, 1000 );
	level.player PlayRumbleOnEntity( "tank_rumble" );
	level thread notify_delay( "stop_heartbeat_sound", 18 );
 	level.player freezecontrols( true );
	level.player disableweapons();
	waittillframeend;
	wait 1;
	level.player PlayerLinkToDelta( playerview, "tag_player", 1, 5, 5, 5, 5 );
 	level.player freezecontrols( false );
	delete_all_non_heros();
	remove_all_weapons();// items on the ground
	clearallcorpses();
	remove_all_weapons();// items on the ground, throwing this out there again and again. I see setting of .dropweapon in the animscripts and I'm not sure if that's getting hit. bugs don't have replays so I'm just throwing redundant removing of weapons everywhere.
	wait 1;
	rottime = .5;
	wait 1;
	wait .5;
	remove_all_weapons();// items on the ground, throwing this out there again and again. I see setting of .dropweapon in the animscripts and I'm not sure if that's getting hit. bugs don't have replays so I'm just throwing redundant removing of weapons everywhere.
	level.player takeallweapons();
	black_overlay thread exp_fade_overlay( 0, 3 );
	delaythread(3.1,::_destroy, black_overlay );
}

_destroy(hudelem)
{
	hudelem destroy();
}

delete_all_non_heros()
{
	ai = getaiarray();
	for ( i = 0; i < ai.size; i++ )
	{
		if ( ai[ i ] ishero() )
			continue;
		if ( isdefined( ai[ i ].magic_bullet_shield ) )
			ai[ i ] stop_magic_bullet_shield();
		ai[ i ] delete();
	}	
}

set_player_eye_target()
{
	origin = spawn( "script_origin", level.player geteye() );
	origin thread maintain_player_eye_target();
	return origin;
}

maintain_player_eye_target()
{
	while ( 1 )
	{
		self.origin = level.player geteye();
		wait .05;
	}
}

stop_anim_scripted_on_death()
{
	self waittill( "death" );
	self stopanimscripted();
}

killguy( guy )
{
	guy DoDamage( guy.health + 10, guy.origin );
}

hold_fordeath( guy )
{
	self.origin = guy.origin;
	self.angles = guy.angles;
	self anim_first_frame_solo( guy, "pain_pose" );
}

end_scene_actor_unlink_on_death()
{
	self waittill( "death" );
	self unlink();
}

zakhaev_buddy2_execute_guy( guy )
{
	self waittillmatch( "single anim", "fire" );
	wait .05;
	if ( !isalive( guy ) )
		return;
	MagicBullet( self.weapon, self gettagorigin("tag_flash"), guy geteye() );
}                      
       
       

bridge_zakhaev()  
{                     
	if ( !isalive( level.price ) || !isalive( level.griggs ) || !isalive( level.gaz ) || !isalive( level.player ) )
		return;          
	setsaveddvar( "compass", "0" );
	flag_set( "bridge_zakhaev_setup" );
	zak_price_spot = getent( "zak_price_spot", "targetname" );
	zak_gaz_spot = getent( "zak_gaz_spot", "targetname" );
	zak_griggs_spot = getent( "zak_griggs_spot", "targetname" );
	zak_price_spot_hide = getent( "zak_price_spot_hide", "targetname" );
	
	kill_unload_que();// deletes drones who might be on their way to becoming a real ai.
	
	delaythread(1,::arcadeMode_stop_timer);
	
	activate_trigger_with_targetname( "clear_fastropers" );
	
	level.price disable_ai_color();
	level.gaz disable_ai_color();
	level.griggs disable_ai_color();
	level.price.goalradius = 32;
	level.gaz.goalradius = 32;
	level.griggs.goalradius = 32;
	level.price setgoalpos( zak_price_spot_hide.origin );
	level.gaz setgoalpos( zak_gaz_spot.origin );
	level.griggs setgoalpos( zak_griggs_spot.origin );
	
		
	// this stuff should never hit here since the situation that takes away their shield shouldn't be happening.  In the unlikely event that an enemy first a bullet while the player is in this transition I need to be sure.
	if ( !isdefined( level.price.magic_bullet_shield ) )
		level.price thread magic_bullet_shield();
	if ( !isdefined( level.griggs.magic_bullet_shield ) )
		level.griggs thread magic_bullet_shield();
	if ( !isdefined( level.gaz.magic_bullet_shield ) )
		level.gaz thread magic_bullet_shield();
	
	level.player allowcrouch( false );
	level.player allowprone( false );
	level.player allowjump( false );

	
	playerview = spawn_anim_model( "playerview" );
	playerview hide();
	node = getent( "player_drag_node", "targetname" );
	
	
	node anim_first_frame_solo( playerview, "drag_player" );

	SetSavedDvar( "nightVisionDisableEffects", 1 );

	array_thread( getfxarraybyID( "hawks" ), ::pauseEffect );
	
	thread music_zak_timing();

	hind_shoots_the_tanker( playerview.origin );

	setsaveddvar( "hud_showstance", 0 );
// 	setsaveddvar( "hud_showtextnoammo", 0 );
	
	array_thread( getfxarraybyID( "cloud_bank_far" ), ::pauseEffect );
	
	waittillframeend;// let the anim get into place
	
	level.player ShellShock( "jeepride_zak", 60 );
	set_vision_set( "jeepride_zak", 1.5 );

	escape_shellshock_thing( playerview );// borrowed from cargoship does player topple animation

	
	assert( !isdefined( level.special_autosavecondition ) );
	thread autosave_now();
	
	if ( getdvar( "jeepride_nobridgefx" ) == "off" )
		exploder_loc( 142 );

// 	wait .5;
	
	if ( level.start_point != "bridge_zak" )
		level.hind notify( "gunner_new_target" );// stop shooting
		
	array_thread( getentarray( "script_vehicle", "classname" ), ::stop_thinking );

	level.level_specific_dof = 1;
	level.player SetDepthOfField( 6, 148, 3100, 19999, 4.4, 1.65 );
	
// 	level.player takeallweapons();
// 	level.price thread force_teleport( zak_price_spot.origin, zak_price_spot.angles );
	
	setsaveddvar( "sM_sunSampleSizeNear", .16 );
	setsaveddvar( "sm_sunShadowScale", 1 );// default
	
	level.gaz stop_magic_bullet_shield();
	gazdummy = level.gaz maps\_vehicle_aianim::convert_guy_to_drone( level.gaz );
	gazdummy.origin = zak_gaz_spot.origin;
	gazdummy fakeout_donotetracks_animscripts();
	gazdummy.a.script = "griggsshootingandbeingcool";// mad hacks
	maps\_vehicle_aianim::detach_models_with_substr( gazdummy, "weapon_" );

	level.griggs stop_magic_bullet_shield();
	griggsdummy = level.griggs maps\_vehicle_aianim::convert_guy_to_drone( level.griggs );
	griggsdummy.animname = "griggs";
	griggsdummy SetAnimTree();
	anim.fire_notetrack_functions[ "griggsshootingandbeingcool" ] = ::shoot_loc;
	griggsdummy fakeout_donotetracks_animscripts();
	griggsdummy.a.script = "griggsshootingandbeingcool";// mad hacks
	maps\_vehicle_aianim::detach_models_with_substr( griggsdummy, "weapon_" );
	griggsdummy attach( "weapon_colt1911_white", "tag_weapon_right" );
	griggsdummy.scriptedweapon = "weapon_colt1911_white";
	
	
	level.price stop_magic_bullet_shield();

//	pricedummy = maps\_vehicle_aianim::convert_guy_to_drone( level.price );


	pricedummy = spawn("script_model",level.price.origin);
	pricedummy.origin = level.price.origin;
	pricedummy setmodel ("body_complete_sp_sas_woodland_price");
	level.price delete();
	level.pricedummy = pricedummy;

	pricedummy.animname = "price";
	pricedummy SetAnimTree();
	maps\_vehicle_aianim::detach_models_with_substr( pricedummy, "weapon_" );
	pricedummy attach( "weapon_colt1911_black", "tag_weapon_right" );

	end_friend_2 = getent( "end_friend_2", "targetname" ) stalingradspawn();
	spawn_failed( end_friend_2 );
	end_friend_2.animname = "end_friend_2";
	end_friend_2.anim_node = getent( end_friend_2.target, "targetname" );
	end_friend_2.dropweapon = false;
	assert( isdefined( end_friend_2.anim_node ) );
	
	end_friend_3 = getent( "end_friend_3", "targetname" ) stalingradspawn();
	spawn_failed( end_friend_3 ) ;
	end_friend_3.dropweapon = false;
	end_friend_3.animname = "end_friend_3";
	end_friend_3.anim_node = getent( end_friend_3.target, "targetname" );
	assert( isdefined( end_friend_3.anim_node ) );

	endprice_actors[ 0 ] = pricedummy;

	enddrag_actors[ 0 ] = griggsdummy;
	enddrag_actors[ 1 ] = playerview;

	remove_all_weapons();// possible that these guys are dropping weapons. I don't know
	
	delaythread( 2, ::lerp_fov_overtime, 5, 55 );	

	thread bridge_zak_friendly_attack_heli();
	
	waittillframeend;

	node thread anim_single( enddrag_actors, "drag_player" );

	array_thread( getentarray( "drag_shots", "targetname" ), ::drag_shots );

	// these two guys are gagged using standard animscript animations first anim has notetracks to do stuff with weapons.  They are both played at highspeed to get them in place while the player is down
	
	end_friend_2 thread blead_on_death();
	end_friend_2.deathanim = %dying_crawl_death_v1; 
	end_friend_2.anim_node thread function_stack( ::anim_single_solo, 	end_friend_2, "intopain" );
	end_friend_2.anim_node thread function_stack( ::hold_fordeath, 	end_friend_2 );

	end_friend_3 thread blead_on_death();
	end_friend_3.deathanim = %dying_back_death_v2; 
	end_friend_3.anim_node thread function_stack( ::anim_single_solo, 	end_friend_3, "intopain" );
	end_friend_3.anim_node thread function_stack( ::anim_loop_solo, 	end_friend_3, "pain_loop" );
	
	end_friend_2 hide();
	end_friend_3 hide();
	
	delaythread( .25, ::anim_set_rate_single, end_friend_2, "intopain", 20 );
	delaythread( .25, ::anim_set_rate_single, 	end_friend_3, "intopain", 20 );

	zak_price_spot thread anim_single( endprice_actors, "drag_player" );
	
	if ( getdvar( "chaplincheat" ) == "1" )
		thread bridge_zak_slomo_script_timed_CHAPLINCHEAT(  );
	else
		thread bridge_zak_slomo_script_timed(  );
	
	end_friend_2 delaythread(1.3, ::_show );
	end_friend_3 delaythread(1.3, ::_show );
	
	playerview waittillmatch( "single anim", "start_price" );
	
//	pricedummy thread blead( 15 );
	
	zak_price_spot thread anim_single( endprice_actors, "jeepride_ending_price01" );
	
	playerview waittillmatch( "single anim", "start_approach" );
	level notify( "stop_drag_shots" );

	zakhaev = getent( "zakhaev", "targetname" ) stalingradspawn();
	spawn_failed( zakhaev );
	zakhaev.animname = "zakhaev";
	zakhaev.dropweapon = false;
	zakhaev.noragdoll = true;
 	zakhaev.deathanim = %pistol_death_3;

	zakhaev_buddy1 = getent( "zakhaev_buddy1", "targetname" ) stalingradspawn();
	spawn_failed( zakhaev_buddy1 );
	zakhaev_buddy1.animname = "zakhaev_buddy1";

	zakhaev_buddy2 = getent( "zakhaev_buddy2", "targetname" ) stalingradspawn();
	spawn_failed( zakhaev_buddy2 );
	zakhaev_buddy2.animname = "zakhaev_buddy2";
	
	zakhaev_buddy2 thread zakhaev_buddy2_execute_guy( end_friend_3 );
	
	end_friend_1 =  gazdummy;
	end_friend_1.animname = "end_friend_1";
	
	players_eye = set_player_eye_target();
	
	end_scene_actors = [];
	end_scene_actors[ 0 ] = zakhaev;
	end_scene_actors[ 1 ] = zakhaev_buddy1;
	end_scene_actors[ 2 ] = zakhaev_buddy2;
	thread bridge_zak_guys_dead( end_scene_actors );
	
	zakhaev thread blead_on_death( 5 );
	zakhaev_buddy1 thread blead_on_death();
	zakhaev_buddy2 thread blead_on_death();

	level.nextGrenadeDrop = 800;

	for ( i = 0; i < end_scene_actors.size; i++ )
	{
		linker = spawn( "script_origin", end_scene_actors[ i ].origin );
		
		end_scene_actors[ i ] disable_ai_color();
		end_scene_actors[ i ] setgoalpos( end_scene_actors[ i ].origin );
		end_scene_actors[ i ].goalradius = 32;
 		end_scene_actors[ i ] linkto( linker );
 		end_scene_actors[ i ] thread end_scene_actor_unlink_on_death();
 		
 		if(getdvar("jeepride_multi_shot") == "off")
			end_scene_actors[ i ].health = 1;
		else
			end_scene_actors[ i ] thread stop_animscripted_on_damage();
		end_scene_actors[ i ].allowdeath = 1;
		end_scene_actors[ i ].grenadeAmmo = 0;
		
	}
		
	
	end_scene_actors[ 3 ] = end_friend_1;

	level.attack_helidummy notsolid();// just incase a missile goes through it
	
	// ok now let these guys die with one shot.
	end_friend_2.allowdeath = true;
	end_friend_3.allowdeath = true;
	end_friend_2.health = 1;
	end_friend_3.health = 1;
	
	node thread anim_single_solo( level.attack_helidummy, "end_scene_01" );
	node thread anim_single( end_scene_actors, "end_scene_01" );

	// script gagged time. I'd prefer note tracks but whatever.. move along. 
	delaythread( 8.15, ::shot_in_the_head_point_blank, zakhaev, end_friend_1 );
	delaythread( .72, ::flag_set, "attack_heli" );

	playerview waittillmatch( "single anim", "start_price" );
	thread autosave_now();

	zak_price_spot thread anim_single( endprice_actors, "jeepride_ending_price02" );
	
	playerview waittillmatch( "single anim", "start_end_badguys" );

	end_scene_actors = array_remove( end_scene_actors, end_friend_1 );
	
//	thread player_janxed_end_shot( end_scene_actors );
	
	level.player_takes_shots = 0;
	
	anim.fire_notetrack_functions[ "scripted" ] = ::shot_counter;
	anim.shootEnemyWrapper_func = ::shot_counter;
	
	node thread anim_single( end_scene_actors, "end_scene_02" );	
	
	playerview waittillmatch( "single anim", "start_end" );

	level.player PlayerLinkToDelta( playerview, "tag_player", 1, 45, 45, 45, 45 );
	level.player disableinvulnerability();
	level.player ShellShock( "jeepride_zak_killing", 60 );
	level.player giveWeapon( "colt45_zak_killer" );
	level.player giveMaxAmmo( "colt45_zak_killer" );
	level.player switchtoweapon( "colt45_zak_killer" );
	level.player enableweapons();
	level.player setViewmodel( "viewhands_sas_woodland" );
	setsaveddvar( "hud_drawhud", "1" );

	level.attack_helidummy hide();
	

	
	playerview waittillmatch( "single anim", "end" );
	
	flag_wait( "all_end_scene_guys_dead" );
	
	assert( isdefined( level.medic ) );
	bridge_rescue( playerview );

}

stop_animscripted_on_damage()
{
	self waittill( "damage" );
	self stopanimscripted();
}

_show()
{
	self show();
}

player_janxed_end_shot( enemies )
{
	level endon ("all_end_scene_guys_dead");
	while(1)
	{
		while(! level.player isfiring() )
			wait .05;
		fired_at_guy = undefined;
		for ( i = 0; i < enemies.size; i++ )
			if( janxed_end_shot( enemies[ i ] ) )
				fired_at_guy = enemies[ i ];
		if(isdefined( fired_at_guy ) )
		{
			fired_at_guy DoDamage( fired_at_guy.health +100, fired_at_guy geteye(), level.player );
			enemies = array_remove( enemies, fired_at_guy );
		}
		if(!enemies.size)
			break;
		while( level.player isfiring() )
			wait .05;
	}
}

janxed_end_shot( enemy )
{
	return within_fov( level.player geteye(), level.player getplayerangles(), enemy geteye(), cos(5) );
}

arrival_disable()
{
	self.disablearrivals = true;
	self.disableexits = true;	
}


offset_ent()
{
	self.origin += level.rescue_scene_offset;
}

bridge_rescue( playerview )
{
	setsaveddvar( "hud_drawhud", "1" );
	setsaveddvar( "hud_showstance", "0" );
	delaythread( 1, ::lerp_fov_overtime, 8, 65 );
	level.player DisableWeapons();
	flag_set( "music_rescue" );

	zak_price_spot = getent( "rescue_price_spot", "targetname" );
	zak_price_spot thread anim_first_frame_solo( level.pricedummy, "jeepride_CPR_price" );	

	delaythread( 3, ::flag_set, "slomo_done" );


// test thing
	node = getent( "player_drag_node", "targetname" );
//	new_rescue_scene_node = getent( "new_rescue_scene_node", "targetname" );
//	level.rescue_scene_offset = new_rescue_scene_node.origin - node.origin; // apply this to all other relavant scene stuff
//	node = new_rescue_scene_node;
//	array_thread ( getentarray("chopper_offseter","script_noteworthy"), ::offset_ent );
	
	playerview2 = spawn_anim_model( "playerview" );
	playerview2 hide();
	playerview2 notsolid();
	node anim_first_frame_solo( playerview2, "player_pickup" );

	rescuenode = getent( "rescuenode", "script_noteworthy" );
	rescuenode waittill( "trigger", other );
	
	level.player ShellShock( "jeepride_rescue", 60 );

	other waittill( "unloaded" );
	other SetHoverParams( 50, 15, 15 );
	black_overlay = create_overlay_element( "black", 0 );
	
//	level.pricedummy thread blead( 10 );

	
	level.ru1 stop_magic_bullet_shield();
	level.ru2 stop_magic_bullet_shield();
// 	ru1 = maps\_vehicle_aianim::convert_guy_to_drone( level.ru1 );
// 	ru2 = maps\_vehicle_aianim::convert_guy_to_drone( level.ru2 );
	ru1 = level.ru1;
	ru2 = level.ru2;

	level.ru1 thread play_sound_in_space( "jeepride_ru1_barelybreathing" );

	scene_guys = [];
	scene_guys[ 0 ] = ru1;
	scene_guys[ 1 ] = ru2;
	array_thread( scene_guys, ::arrival_disable );
	
	thread movenlink( node, playerview2 );
	node thread anim_reach_solo( ru1, "player_pickup" );
	node anim_reach_solo( ru2, "player_pickup" );
//	level.player delaythread( 3, ::play_sound_in_space, "jeepride_ru2_allrightmyfriend" );
	
	array_thread( getentarray( "rescue_scene_patrol_01", "targetname" ), ::rescue_scene_patrol_01 );

	other SetHoverParams( 0, 0, 0 );
	
	
	other delaythread( 6, maps\_vehicle::vehicle_paths, getent( "chopper_rescuer", "targetname" ) );
	black_overlay thread exp_fade_overlay( 0, 1 );
	scene_guys = [];
	scene_guys[ 0 ] = ru1;
	scene_guys[ 1 ] = ru2;
	scene_guys[ 2 ] = playerview2;
	thread dof_focuser_tag( ru2, 30 );
	node thread anim_single( scene_guys, "player_pickup" );

	wait 9.7;

	// make them just stand there
	ru1 setgoalpos( ru1.origin );
	ru2 setgoalpos( ru2.origin );
	
	medic = level.medic;

	zak_price_spot thread anim_first_frame_solo( medic, "jeepride_CPR_medic" );
	thread dof_focuser_tag( medic, 30 );
	
	delaythread( 3, ::flag_set, "rescue_chopper_adjust" );
	
//	black_overlay thread exp_fade_overlay( 0, 2 );
	wait 4;

	zak_price_spot delaythread(4 ,::anim_single_solo, medic, "jeepride_CPR_medic" );
	zak_price_spot delaythread(4 ,::anim_single_solo, level.pricedummy, "jeepride_CPR_price" );	   

//	level.player delaythread( 10, ::play_sound_in_space, "jeepride_ru2_gethimoutofhere" );
	
	
	
	delaythread( 20, ::dof_focuser_tag, other, 100, "tag_ground", 7 );
	delaythread( 15, ::beam_me_up_to_the_chopper,playerview );
	
	delaythread(15,	::earthquaker_small);					
	delaythread(5, ::dialog_bbc );

//	delaythread( 19, :: array_thread, getaiarray("allies"),::stand_up );
//	delaythread( 19, ::set_rescue_guy_pos );
	array_thread( getentarray("script_vehicle","classname"), maps\_vehicle::volume_down, 20 );
	overlay_cpr( black_overlay );
	flag_set( "cpr_finished" );
	//wait 5;
	wait 19;

	nextmission();
}

dialog_bbc()
{
	wait 13;
	
	level.player play_sound_on_entity( "jeepride_bbc_missiletest" );
	
	wait 0.5;
	
	level.player play_sound_on_entity( "jeepride_bbc_unprotocols" );
	
	wait 0.5;
	
	level.player play_sound_on_entity( "jeepride_bbc_rumors" );
	
	wait 1;
	
	level.player play_sound_on_entity( "jeepride_bbc_calledoff" );
}

set_rescue_guy_pos( )
{
	level.medic thread rescue_guy_pos( getent("end_stander_medic","targetname") );
	level.ru1 thread rescue_guy_pos( getent("end_stander_ru1","targetname") );
	level.ru2 thread rescue_guy_pos( getent("end_stander_ru2","targetname") );
}

rescue_guy_pos( stander )
{
	linker = spawn("script_model", stander.origin );
	linker setmodel ("tag_origin");
	linker.origin = stander.origin;
	linker.angles = stander.angles;
	self linkto (linker,"tag_origin",(0,0,0),(0,0,0));
	
	self allowedstances("stand");
	self animscripted( "animscripted", linker.origin, linker.angles, %crouch2stand );
	self animscripts\shared::DoNoteTracks( "animscripted" );
	
}

stand_up()
{
	self allowedstances("stand");
	self animscripted( "animscripted", self.origin, self.angles, %crouch2stand );
	self animscripts\shared::DoNoteTracks( "animscripted" );
}

movenlink( node, playerview )
{
//	level.player dontinterpolate();
	lerp_player_view_to_position_oldstyle_loc( playerview gettagorigin( "tag_player" ), playerview gettagangles( "tag_camera" ), .9, 1, 0, 0, 0, 0 );
//	level.player dontinterpolate();
	level.player PlayerLinkToDelta( playerview, "tag_player", 1, 5, 5, 5, 5 );
}

lerp_player_view_to_position_oldstyle_loc( origin, angles, lerptime, fraction, right_arc, left_arc, top_arc, bottom_arc, hit_geo )
{
	linker = spawn( "script_origin", ( 0, 0, 0 ) );
//	linker dontinterpolate();
	linker.origin = get_player_feet_from_view();
	linker.angles = level.player getplayerangles();

	if( isdefined( hit_geo ) )
	{
		level.player playerlinktodelta( linker, "", fraction, right_arc, left_arc, top_arc, bottom_arc, hit_geo );
	}
	else
	if( isdefined( right_arc ) )
	{
		level.player playerlinktodelta( linker, "", fraction, right_arc, left_arc, top_arc, bottom_arc );
	}
	else
	if( isdefined( fraction ) )
	{
		level.player playerlinktodelta( linker, "", fraction );
	}
	else
	{
		level.player playerlinktodelta( linker );
	}
		
	linker moveto( origin, lerptime, lerptime * 0.25, lerptime * 0.25 );
	linker rotateto( angles, lerptime, lerptime * 0.25, lerptime * 0.25 );
	wait( lerptime-.05 );
//	linker delete(); // meh leave it around the map is over anyway
}

overlay_cpr( black_overlay )
{
	black_overlay 	delaythread( 8.5, ::exp_fade_overlay, .5, .7 );
					delaythread( 8.5, ::_setblur, 2.4, .7 );
	black_overlay 	delaythread( 9.5, ::exp_fade_overlay, 0, .5 );
					delaythread( 9.5, ::_setblur, 0, .5 );
	black_overlay 	delaythread( 12.5, ::exp_fade_overlay, .7, .7 );
					delaythread( 12.5, ::_setblur, 2.8, .7 );
	black_overlay 	delaythread( 13.3, ::exp_fade_overlay, 0, 1 );
					delaythread( 13.3, ::_setblur, 0, 1 );
//	black_overlay 	delaythread( 15.3, ::exp_fade_overlay, 1, 2 );
//					delaythread( 15.3, ::_setblur, 3.2, 1 );
//	black_overlay 	delaythread( 20.3, ::exp_fade_overlay, 0, 1 );
//					delaythread( 20.3, ::_setblur, 0, 1 );
 	wait 22.3;
	white_overlay = black_overlay;
	white_overlay setshader( "white", 640, 480 );

	white_overlay 	delaythread( 7.55, ::exp_fade_overlay, 1, 2 );
					delaythread( 3.25, ::_setblur, 2.4, 6 );

	set_vision_set( "jeepride_flyaway" , 8 );
	wait 8;	
}

earthquaker_small()
{
	thread exploder(192);
	intensity = .12;
//	for ( i = 0;i < count;i++ )
	while(1)
	{
		Earthquake( intensity, randomfloatrange(.8,1.0), level.player.origin, 150 );
		wait randomfloatrange(0.2,.4);
	}
}

_setblur( par1, par2 )
{
	if ( getdvar( "jeepride_player_pickup" ) == "off" )
	setblur( par1, par2 );
}                                    

dof_focuser_tag( guy, dofrange, tag, nearblur, farblur )
{
	level notify( "new_dof_focus" );
	level endon( "new_dof_focus" );
	if ( !isdefined( nearblur ) )
		nearblur = 4;
	if ( !isdefined( farblur ) )
		farblur = 4;
	
	if ( !isdefined( tag ) )
		tag = "J_Head";
	
	while ( 1 )
	{
		dist = distance( level.player geteye(), guy gettagorigin( tag ) );
		nearstart = 0;
		nearend  = dist - dofrange;
		if ( nearend <= 0 )
			nearend = 1;
		farstart = dist + dofrange;
		farend  = farstart + 35000;// go hard code!
		nearblur = 4;
		farblur = 4;
		level.player SetDepthOfField( nearstart, nearend, farstart, farend, nearblur, farblur );
		wait .05;
	}
}





medic_focus( playerview )
{
	viewturner = spawn( "script_model", level.player.origin );
	viewturner setmodel( "tag_origin" );

	while ( 1 )
	{
		viewturner.angles = level.player getplayerangles();
		destang = vectortoangles( vectornormalize( level.pricedummy.origin - viewturner.origin ) );
		playerview linkto( viewturner );
		playerview rotateto( destang, .05, 0, 0 );
		wait .05;
		playerview unlink();
	}
}

player_takes_shots()
{
	// can't seem to get these guys to hit the player with the bullets so I'm forcing it based on how many shots they fire, 
	// some warning shots then death.
	level.player_takes_shots = 0;
	while ( level.player_takes_shots < 2 )
		level waittill( "player_takes_shot" );
	player_kill();
	      
}         
          
shot_counter()
{         
	in_fov = within_fov( self gettagorigin( "tag_flash" ), self gettagangles( "tag_flash" ), level.player geteye(), cos( 10 ) );
	if ( ! in_fov )
	{     
		self ShootBlank();
		return;
	}     
	level.player_takes_shots++ ;
	
	killer = false;
	if ( level.gameskill == 0 )
	{
		if ( level.player_takes_shots > 4 )
			killer = true;
	}
	else if ( level.gameskill == 1 )
	{
		if ( level.player_takes_shots > 3 )
			killer = true;
	}
	else 
	{
		if ( level.player_takes_shots > 2 )
			killer = true;
	}
	
	if ( killer )
		level.player enableHealthShield( false );
	self Shoot( 1, level.player geteye() );
	
}


bridge_zak_friendly_attack_heli()
{
	level.hind thread vehicle_paths( getent( "hind_roll_in", "script_noteworthy" ) );
	level.hind SetLookAtEnt( level.player );
	helis = create_vehicle_from_spawngroup_and_gopath( 71 );
	
	level.attack_heli = undefined;
	for ( i = 0; i < helis.size; i++ )
		if ( helis[ i ].vehicletype == "mi28" )
		{
			level.attack_heli = helis[ i ];
			break;
		}
// 	level.attack_heli = create_vehicle_from_spawngroup_and_gopath( 71 )[ 0 ];
// 	level.attack_heli setspeed( 0, 60 );
	level.attack_heli stopenginesound();
	
	level.attack_helidummy = level.attack_heli vehicle_to_dummy();
	level.attack_helidummy hide();
	level.attack_helidummy.animname = "mi28";
	level.attack_helidummy setanimtree();
	level.attack_helidummy thread maps\jeepride_anim::override_roto_anim();
	
	flag_wait( "attack_heli" );
	
	level.attack_helidummy show();

	wait 12.25;

// 	level.attack_heli = create_vehicle_from_spawngroup_and_gopath( 71 )[ 0 ];
	assert( isdefined( level.hind ) );
	level.attack_heli SetLookAtEnt( level.hind );
	level.hind SetLookAtEnt( level.attack_heli );
	
	level.hind godoff();
	
	level.hind clearlookatent();
	
	level.attack_heli fake_missile( level.hind );
	delaythread( 0.1, ::_Earthquake, 0.8, 0.8, level.player.origin, 20000 );

//	level.attack_heli thread shootspotoncewithmissile( level.hind.origin + ( 0, 0, -70 ) );
	
	level.hind notify ("death");
	wait .5;
	level.hind delete();
	
// 	flag_set( "hind_killed" );
}

fake_missile( targetent )
{
	
	barrelpos = self.origin+(0,0,-34);
	barrelang = self.angles;

	fxent = spawn( "script_model", barrelpos );
	fxent.angles = (180,0,0);

	fxent setmodel( "projectile_sidewinder_missile" );
	PlayFXOnTag( level._effect[ "rocket_trail" ], fxent, "TAG_FX" );
	movespeed = 7500;
	fire_org = targetent.origin+(0,0,-34) ;
//	PlayFXOnTag( level._effect[ "rpg_trail" ], fxent, "TAG_FX" );
	lastdest = barrelpos;
	fxent notsolid();
	fxent movewithrate( fire_org, fxent.angles, movespeed );
	wait .1;
	fxent delete();
}




bridge_zak_guys_dead( guys )
{
	waittill_dead_or_dying( guys );
	flag_set( "all_end_scene_guys_dead" );
}



bridge_zak_slomo_script_timed(  )
{

	//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	// If you update this function, mirror the changes in bridge_zak_slomo_script_timed_CHAPLINCHEAT() !
	//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

 	slowmo_start();

		slowmo_setspeed_slow( 0.4 );
		slowmo_lerp_in();
	
		wait 13.4;
		slowmo_setspeed_slow( 0.25 );
		slowmo_lerp_in();
	
		wait 1.2;
	
		// turn to price
		slowmo_setspeed_slow( 0.4 );
		slowmo_lerp_in();
	
		wait 6.7;
		
		// now focused on enemies walking up
		slowmo_setspeed_slow( 0.8 );
		slowmo_lerp_in();
	
		wait 11.2;
	
		// helicopter blows up, now panning back to price
		slowmo_setspeed_slow( 0.45 );
		slowmo_lerp_in();
		
		wait 6.2;
	
		slowmo_setspeed_slow( 0.35 );
		slowmo_lerp_in();
		
		wait 2.1;
		
		// player has gun;
		slowmo_setspeed_slow( 0.45 );
		slowmo_lerp_in();
			
		flag_wait( "all_end_scene_guys_dead" );
		flag_set( "rescue_choppers" );// radiant nodes
		flag_set( "music_lastman" );
	
		slowmo_setspeed_slow( 0.55 );
		slowmo_lerp_in();
		
		flag_wait( "slomo_done" );
		slowmo_setlerptime_out( 8.75 );
		delaythread( 3, ::slowmo_lerp_out );	
		
		wait 5;
		level.player disableweapons();
		flag_set( "objective_finishedthelevel" );
		set_vision_set( "jeepride", 10 );
	
	slowmo_end();
}


bridge_zak_slomo_script_timed_CHAPLINCHEAT()
{
	//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	// This is bridge_zak_slomo_script_timed() with the the slomo taken out.
	//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

	wait 13.4;

	wait 1.2;

	// turn to price
	wait 6.7;
	
	// now focused on enemies walking up
	wait 11.2;

	// helicopter blows up, now panning back to price
	wait 6.2;

	wait 2.1;
	
	// player has gun;
	flag_wait( "all_end_scene_guys_dead" );
	flag_set( "rescue_choppers" );// radiant nodes
	flag_set( "music_lastman" );

	wait 5;
	level.player disableweapons();
	flag_set( "objective_finishedthelevel" );
}


fakeout_donotetracks_animscripts()
{
	self.a = spawnstruct();// I just want to donotetracks on a dummy.. asdfaskdjfaksjdflisjdflkjl
	self.a.lastShootTime = gettime();
	self.a.bulletsinclip = 500;
	self.weapon = "colt45";
	self.primaryweapon = "colt45";
	self.secondaryweapon = "colt45";
	self.a.isSniper = false;
	self.a.misstime = false;
	self.weapon = "none";	
	// hahahaha. sigh. This seemed like it was going to be easy. in my defense. I'm delerious
}

shoot_loc()
{
// 	self shoot();
	// playfx? I don' know. guess best to ma
	// ganked from assman for colt45.. l33t hax
	if ( self.scriptedweapon == "weapon_colt1911_white" )
	{
		PlayFXOnTag( level._effect[ "griggs_pistol" ], self, "TAG_FLASH" );
		thread play_sound_on_tag( "weap_m1911colt45_fire_npc", "TAG_FLASH" );
	}
	else
	{
		flashorg = self gettagorigin( "TAG_FLASH" );
		bullettracer( flashorg, flashorg + vector_multiply( anglestoforward( self gettagangles( "TAG_FLASH" ) ), 3000 ) );
		PlayFXOnTag( level._effect[ "griggs_saw" ], self, "TAG_FLASH" );
		thread play_sound_on_tag( "weap_m249saw_fire_npc", "TAG_FLASH" );
	}
	
}



price_bridge_crawl_anims( node )
{
	node anim_single_solo( level.price, "wave_player_over" );
	level.price animscripted( "animscripted", level.price.origin, level.price.angles, %stand2crouch_attack );
	level.price waittillmatch( "animscripted", "end" );
// 	level.price animscripted( "animscripted", level.price.origin, level.price.angles, %crouch_pain_holdstomach );
// 	level.price waittillmatch( "animscripted", "end" );
	level.price animscripted( "animscripted", level.price.origin, level.price.angles, %crouch2stand );
	level.price waittillmatch( "animscripted", "end" );
}

stop_thinking()
{
	self notify( "stop_thinking" );
	self mgoff();
}

hind_shoots_the_tanker( player_dest_origin )
{
	level.hind notify( "gunner_new_target" );
// 	wait 4;
	target = spawn( "script_origin", ( -36282.6, -16678.1, 451 ) );
	target.script_attackmetype = "missile_bridgebuster";
	target.script_shotcount = 2;
	target.oldmissiletype = false;	
	thread earthquaker( 10 );

	if( ! player_in_blastradius() )
		level.player enableinvulnerability();
		
		
	level.hind thread shootEnemyTarget( target );      
//	thread player_trackmissile( player_dest_origin, target );   
	level waittill( "bridge_blower" );
	if( player_in_blastradius() )
		player_kill();

	MusicStop( 3.5 );
	level.player freezecontrols( false );
	level.hind notify( "stop_killing_theplayer" );
	level.hind notify( "gunner_new_target" );
	
	level.player ShellShock( "jeepride_zak", 60 );

	thread rumbler();
	wait .25;// script is to fast. phew.
	thread earthquaker( 4 );
	
	exploder_loc( 13 );
}

rumbler()
{
	count = 5;
	for ( i = 0;i < count;i++ )
	{
		level.player PlayRumbleOnEntity ("tank_rumble");
		wait randomfloatrange( .2, .5 );
	}
}


earthquaker( count )
{
	for ( i = 0;i < count;i++ )
	{
		Earthquake( .2, randomfloatrange( 1, 1.5 ), level.player.origin, 50 );
		wait randomfloatrange( 1, 1.5 );
	}
}


player_trackmissile( player_dest_origin, target )
{
	level endon( "bridge_blower" );
	level waittill( "missile_tracker", eMissile );
	wait .5;
	org = spawn( "script_model", level.player.origin );
	org setmodel( "tag_origin" );
	org.angles = level.player getplayerangles();
	level.player playerlinktoabsolute( org, "tag_origin", ( 0, 0, 0 ), ( 0, 0, 0 ) );
	level.player freezecontrols( true );
//	dest_angle = vectortoangles( vectornormalize( ( level.hind.origin ) - level.player geteye() ) );
//	org RotateTo( dest_angle, .5, .2, .2 ); 
//	wait .5;
	dest_angle = vectortoangles( vectornormalize( ( target.origin ) - level.player geteye() ) );
	rottime = .5;
	org RotateTo( dest_angle, rottime, .2, .2 ); 
	wait rottime;
	
// 	while ( isdefined( eMissile ) )
// 	{
// 		dest_angle = vectortoangles( vectornormalize( ( eMissile.origin ) - level.player geteye() ) );
// 		level.player setplayerangles( dest_angle );
// 		wait.05;
// 	}
}

overlaysmoke()
{
	emitter = spawn( "script_model", level.player geteye() );
	emitter.origin = level.player geteye();
	emitter.angles = ( 0, 0, 0 );
	emitter setmodel( "axis" );
	emitter hide();
	PlayFXOnTag( level._effect[ "smoke_blind" ], emitter, "polySurface1" );
	wait 10;
	emitter delete();
}

dump_passerbys_handle()
{
	 /#
	button1 = "e";
	button2 = "CTRL";
	while ( 1 )
	{
		while ( !twobuttonspressed( button1, button2 ) )
			wait .05;
		print_passerby_timing();
		while ( twobuttonspressed( button1, button2 ) )
			wait .05;
	}
	#/ 
}

bridge_save()
{
	bridge_save = getent( "bridge_save", "targetname" );
	bridge_save waittill( "trigger" );
 	level.special_autosavecondition = ::bridge_save_check;
 	
 	
 	// this is a good place for price to get all of this info back
 	setsaveddvar("ai_friendlyFireBlockDuration", 250);
	level.price.a.disablePain = false;
	level.price.ignoresuppression = false;
	
 	thread autosave_by_name( "bridge_save" );

 	
 	while(!flag("game_saving"))
 		level waittill ("game_saving");
 		
 	level.special_autosavecondition = undefined;
 	
}

bridge_save_check()
{
	bridge_save = getent( "bridge_save", "targetname" );
	return distance( flat_origin( level.player.origin ), flat_origin( bridge_save.origin ) )< bridge_save.radius;
}


shock_ondeath_loc()
{
	precacheShellshock( "jeepride_ridedeath" );
	self.specialDeath = true;
	self waittill( "death" );
	if ( getdvar( "r_texturebits" ) == "16" )
		return;
	self shellshock( "jeepride_ridedeath", 3 );
}

bridge_rescue_start()
{
	level.startdelay = 350000;

	bridge_combat_price = getent( "zak_price_spot", "targetname" );
	bridge_combat_griggs = getent( "zak_griggs_spot", "targetname" );
	bridge_combat_player = getent( "zak_player_spot", "targetname" );
	level.player setorigin( bridge_combat_player.origin );
	
	spawn_heros_for_start( bridge_combat_price.origin, bridge_combat_griggs.origin, bridge_combat_player.origin );
	
	flag_set( "end_ride" );
	flag_set( "bridge_sequence" );
	flag_set( "van_smash" );
	flag_set( "music_bridge" );
	flag_set( "music_zak" );
	flag_set( "bridge_zakhaev_setup" );

 	exploder_loc( 3, true );
 	exploder_loc( 71, true );
 	exploder_loc( 72, true );
	exploder_loc( 73, true );

	wait 4.5;
	ai = getaiarray();
	for ( i = 0; i < ai.size; i++ )
	{
		if ( ai[ i ] ishero() )
			continue;
		if ( isdefined( ai[ i ].magic_bullet_shield ) && ai[ i ].magic_bullet_shield )
			ai[ i ] stop_magic_bullet_shield();
		ai[ i ] delete();
	}

	thread create_vehicle_from_spawngroup_and_gopath( 71 );
	
	level.price stop_magic_bullet_shield();
	pricedummy = maps\_vehicle_aianim::convert_guy_to_drone( level.price );
	pricedummy.animname = "price";
	level.pricedummy = pricedummy;

	playerview = spawn_anim_model( "playerview" );
	playerview hide();
	
	
	node = getent( "player_drag_node", "targetname" );
	
	
	
	node thread anim_single_solo( playerview, "drag_player" );
	node thread anim_set_rate_single( playerview, "drag_player", 15 );
	

	level.level_specific_dof = 1;
	level.player SetDepthOfField( 0, 100, 3100, 19999, 8, 1.65 );

	level.player allowstand( true );
	level.player allowprone( false );
	level.player allowsprint( false );

	wait 5;
	
	flag_set( "rescue_choppers" );
	flag_set( "music_rescue" );

	level.player PlayerLinkToDelta( playerview, "tag_player", 1, 45, 45, 45, 45 );
	bridge_rescue( playerview );
	

}


bm21_unloader()
{
	pre_trigger = getvehiclenode(self.targetname,"target");
	prepree_trigger = getvehiclenode(pre_trigger.targetname,"target");
	prepree_trigger waittill ("trigger", other);
	other notify( "unload", "passengers" );
	self waittill( "trigger", other ); //little potential for bm21 stopping forever here. but haven't seen it happen.
	other setspeed( 0, 200 );
//	other notify( "unload", "passengers" );
	other waittill( "unloaded" );
	other resumespeed( 15 );
}


autosave_now_loc( uselessstring )
{
	if ( !isalive( level.player ) )
		return;

	if ( level.missionfailed )
		return;

	level.player.attackerAccuracy = 0;
	thread autosave_now( uselessstring );
	level.player.attackerAccuracy = 1;

}

start_first_hind()
{
	array_thread( getvehiclenodearray( "attacknow_firsthind", "script_noteworthy" ), ::attacknow );
	wip_start();
}

start_nowhere()
{
	
}

bm21_setanims_override()
{
	positions = maps\_bm21_troops::setanims();

	positions[ 0 ].idle = [];
	positions[ 0 ].idle[ 0 ] = %UAZ_driver_idle;
	positions[ 0 ].idle[ 1 ] = %UAZ_driver_duck;
	positions[ 0 ].idle[ 2 ] = %UAZ_driver_weave;
	positions[ 0 ].idleoccurrence[ 0 ] = 100;
	positions[ 0 ].idleoccurrence[ 1 ] = 100;
	positions[ 0 ].idleoccurrence[ 2 ] = 100;
	
	return positions;
}
	
fx_thing()
{
	fx = loadfx( "explosions/small_vehicle_explosion" );
	while ( 1 )
	{
		while ( !level.player usebuttonpressed() )
			wait( .05 );
		playfx( fx, level.player geteye() );
		while ( level.player usebuttonpressed() )
			wait( .05 );
	}
}
   
   
framer( org, angles )
{
	framer = spawn( "script_model", org );
	framer.angles = angles;
	framer setmodel( "tag_origin" );
	level.player unlink();
	level.player PlayerLinkToDelta( framer, "tag_origin", 1, 5, 5, 5, 5 );
	return framer;
}


beam_me_up()
{
	beam_me_up = getent( "beam_me_up", "targetname" );
	beam_me_up hide();
	beam_me_uppers = getentarray( beam_me_up.target, "targetname" );
	for ( i = 0; i < beam_me_uppers.size; i++ )
	{
		beam_me_uppers[ i ] hide();
		beam_me_uppers[ i ] linkto( beam_me_up );
	} 
	beam_me_up.beam_me_uppers = beam_me_uppers;
}

beam_me_up_to_the_chopper( playerview )
{
	beam_me_up = getent( "beam_me_up", "targetname" );
	beam_me_uppers = beam_me_up.beam_me_uppers;
	beam_me_up show();
	level.player playrumbleonentity( "tank_rumble" );
	for ( i = 0; i < beam_me_uppers.size; i++ )
	{
		beam_me_uppers[ i ] show();
	}
	wait 1;                        
	                                          	
	beam_me_up ghettolinkto( level.player ); 
}

ghettolinkto( linktoer )
{
	self endon( "death" );
	org = spawn( "script_origin", level.player.origin );
	self linkto( org );	
	while ( 1 )
	{
		org.origin = linktoer.origin;
// 		org moveto( linktoer.origin, .05, 0, 0 );
		wait .05;
	}
}