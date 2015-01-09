/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
Level: 		Blackout
Campaign: 	SAS
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */ 

#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_stealth_logic;
#include maps\blackout_code;
#using_animtree( "generic_human" );

main()
{
	level.next_tango_timer = 0;	
	setsaveddvar( "r_specularColorScale", "2.2" );
	setsaveddvar( "sm_sunShadowScale", "0.5" ); // optimization - night shadows can be lower resolution
	maps\createart\blackout_art::main();

	precacheModel( "weapon_saw_MG_setup" );
	precacheModel( "weapon_rpd_MG_setup" );
	precacheModel( "com_folding_chair" );
	precacheModel( "ch_street_wall_light_01_off" );
	precachestring( &"BLACKOUT_THE_INFORMANT_WAS_KILLED" );
	precachestring( &"SCRIPT_LEARN_CLAYMORES" );
	precachestring( &"BLACKOUT_PROVIDE_SNIPER_SUPPORT" );
	precachestring( &"BLACKOUT_CUT_OFF_ENEMY_REINFORCEMENTS" );
	precachestring( &"BLACKOUT_PROVIDE_SNIPER_SUPPORT1" );
	precachestring( &"BLACKOUT_FOLLOW_KAMAROV_TO_POWER_STATION" );
	precachestring( &"BLACKOUT_PROVIDE_MORE_SNIPER_SUPPORT" );
	precachestring( &"BLACKOUT_RAPPEL_DOWN_FROM_THE" );
	precachestring( &"BLACKOUT_RESCUE_THE_INFORMANT" );
	precachestring( &"BLACKOUT_EVAC_WITH_THE_INFORMANT" );
	precachestring( &"BLACKOUT_ELIMINATE_THE_OUTER_GUARD" );
	precachestring( &"BLACKOUT_MEET_THE_RUSSIAN_LOYALISTS" );
	precachestring( &"BLACKOUT_RAPPEL_HINT" );
	precachestring( &"BLACKOUT_THE_INFORMANT_WAS_KILLED" );

	thread breach_door();
	maps\_stealth_logic::stealth_init();
	maps\_stealth_behavior::main();
	maps\_breach::main();
	maps\_blackhawk::main( "vehicle_blackhawk_sas_night", undefined, true );

	maps\_bm21::main( "vehicle_bm21_mobile" );
	maps\_uaz::main( "vehicle_uaz_fabric", undefined, true );
//	maps\_truck::main( "vehicle_pickup_4door" );
	maps\_bmp::main( "vehicle_bmp_woodland" );
	maps\_mi17::main( "vehicle_mi17_woodland_fly_cheap", undefined, true );
//	maps\_bmp::main( "vehicle_bmp" );

	level thread maps\blackout_fx::main();

	maps\_hud::init();
	maps\_hiding_door::main();

	maps\_compass::setupMiniMap("compass_map_blackout");
	
	default_start( ::start_normal );
	add_start( "chess", ::start_chess, &"STARTS_CHESS" );
	add_start( "field", ::start_field, &"STARTS_FIELD1" );
	add_start( "overlook", ::start_overlook, &"STARTS_OVERLOOK" );
	add_start( "cliff", ::start_cliff, &"STARTS_CLIFF" );
	add_start( "rappel", ::start_rappel, &"STARTS_RAPPEL" );
	add_start( "farmhouse", ::start_farmhouse, &"STARTS_FARMHOUSE" );
	add_start( "blackout", ::start_blackout, &"STARTS_BLACKOUT" );
	add_start( "rescue", ::start_rescue, &"STARTS_RESCUE" );
	
	level.strings[ "mantle" ]				= &"SCRIPT_MANTLE";
	maps\_hud_util::create_mantle();

	setsaveddvar( "ai_eventDistProjImpact", "0" ); // so claymores don't get the AI's attention
	
	level.weaponClipModels = [];
	level.weaponClipModels[0] = "weapon_mp5_clip";
	level.weaponClipModels[1] = "weapon_ak47_clip";
	level.weaponClipModels[2] = "weapon_dragunov_clip";
	level.weaponClipModels[3] = "weapon_g36_clip";
	level.weaponClipModels[4] = "weapon_g3_clip";
	level.weaponClipModels[5] = "weapon_m16_clip";
	
	maps\_load::main();

	// init friendly stealth
	ai = getaiarray( "allies" );
	array_thread( ai, ::friendly_init );
	add_global_spawn_function( "allies", ::friendly_init );

	maps\_nightvision::main();
	maps\_load::set_player_viewhand_model( "viewhands_sas_woodland" );
	level thread maps\blackout_amb::main();

	maps\blackout_anim::main();

	default_fog = getent( "blackout_swamp_fog", "script_noteworthy" );
	// the default start will overwrite this with the real fog
	default_fog apply_end_fog();	

	/#
	if ( getdvar( "debug_jitter" ) != "" )
		add_global_spawn_function( "axis", ::set_generic_deathanim, "exposed_headshot" );
	#/

	
	flag_init( "high_alert" );
	flag_init( "second_shacks" );
	flag_init( "russians_stand_up" );
	flag_init( "go_up_hill" );
	flag_init( "go_to_overlook" );
	flag_init( "overlook_attack_begins" );
	flag_init( "overlook_attention" );
	flag_init( "hut_cleared" );
	flag_init( "cliff_fighting" );
	flag_init( "cliff_moveup" );
	flag_init( "recent_flashed" );
	flag_init( "on_to_the_farm" );
	flag_init( "player_rappels" );
	flag_init( "head_to_rappel_spot" );
	flag_init( "gaz_and_price_go_up_hill" );
	flag_init( "kam_heads_to_rappel_spot" );
	flag_init( "gaz_opens_door" );
	flag_init( "farm_complete" );
	flag_init( "blackout_rescue_complete" );
	flag_init( "blackout_flashlightguy_dead" );
	flag_init( "blackhawk_lands" );
	flag_init( "kam_go_through_burning_house" );	
	flag_init( "gaz_goes_by_other_window" );
	flag_init( "price_and_gaz_attack_flashlight_guy" );
	flag_init( "gaz_got_to_blackout_door" );
	flag_init( "player_finishes_rappel" );
	flag_init( "lights_out" );
	flag_init( "commence_attack" );
	flag_init( "player_enters_burning_house" );
	flag_init( "player_near_heli" );
	flag_init( "meeting_begins" );
	flag_init( "rappel_kamarov_ready" );
	flag_init( "rappel_gaz_ready" );
	flag_init( "ready_to_commence_attack" );
	flag_init( "start_cliff_scene_gaz" );
	flag_init( "start_cliff_scene_kamarov" );
	flag_init( "kamarov_drops_binocs" );
	flag_init( "first_bmp_destroyed" );
	flag_init( "bm21s_attack" );
	flag_init( "weapons_free" );
	flag_init( "gaz_rappels" );
	flag_init( "hurry_to_nikolai" ); //set this just as Price starts to say "Soap, Gaz, we've got to reach that house..."
	flag_init( "go_through_burning_house" );
	flag_init( "player_near_pier" );
	flag_init( "shack_signal" );
	flag_init( "field_stop" );
	flag_init( "field_go" );
	flag_init( "gaz_rushes_hut" );
	flag_init( "visible_mg_gunner_alive" );
	flag_init( "head_to_the_cliff" );
	flag_init( "power_station_dialogue_begins" );
	flag_init( "kam_wants_more_sniping" );
	flag_init( "gaz_convinces_kam_otherwise" );
	flag_init( "gaz_fight_preps" );
	flag_init( "gaz_kam_fight_begins" );
	flag_init( "final_raid_begins" );
	flag_init( "price_got_to_go" );
	flag_init( "mission_chatter" );
	flag_init( "price_and_gaz_arrive_at_fight" );
	flag_init( "price_at_fight" );
	flag_init( "gaz_at_fight" );
	flag_init( "kam_at_fight" );

	flag_set( "no_ai_tv_damage" );

	thread do_in_order( ::flag_wait, "power_plant_cleared", ::flag_clear, "aa_power_plant" );

//	thread do_in_order( ::flag_wait, "gaz_runs_by_second_window", ::flag_set, "gaz_goes_by_other_window" );
	flag_set( "gaz_goes_by_other_window" );
	thread set_high_alert();
	thread hut_cleared();

	add_hint_string( "nvg", &"SCRIPT_NIGHTVISION_USE", maps\_nightvision::ShouldBreakNVGHintPrint );
	add_hint_string( "grenade_launcher", &"SCRIPT_LEARN_GRENADE_LAUNCHER", ::should_break_grenade_launcher_hint );
	add_hint_string( "sniper_rifle", &"SCRIPT_LEARN_M14_SWITCH", ::should_break_sniper_rifle_hint );
	add_hint_string( "claymore_plant", &"SCRIPT_LEARN_CLAYMORES", ::should_break_claymores );
	add_hint_string( "disable_nvg", &"SCRIPT_NIGHTVISION_STOP_USE", maps\_nightvision::should_break_disable_nvg_print );
	add_hint_string( "claymore_placement", &"SCRIPT_LEARN_CLAYMORE_PLACEMENT", ::should_break_claymore_placement );
	


	thread grenade_hint_logic();

//	battlechatter_off( "allies" );
	
//	run_thread_on_targetname( "no_prone", ::no_prone_think );
//	run_thread_on_targetname( "no_crouch_or_prone", ::no_crouch_or_prone_think );
	run_thread_on_targetname( "second_shack_trigger", ::second_shack_trigger );
	run_thread_on_targetname( "physics_launch", ::physics_launch_think );
	run_thread_on_targetname( "prep_for_rappel", ::prep_for_rappel_think );
	run_thread_on_targetname( "price_finishes_farm", ::price_finishes_farm );
	run_thread_on_targetname( "delete", ::_delete  );
	run_thread_on_targetname( "burning_door_trigger", ::open_door_trigger, "burning" ); // burning_door_open
	run_thread_on_targetname( "meeting_door_trigger", ::open_door_trigger, "meeting" ); // meeting_door_open
	run_thread_on_targetname( "sniper_remove_trigger", ::sniper_remove_trigger ); // meeting_door_open
	run_thread_on_targetname( "trigger_deletes_children", ::trigger_deletes_children ); // meeting_door_open

	run_thread_on_noteworthy( "shack_sleeper", ::add_spawn_function, ::shack_sleeper );
	run_thread_on_noteworthy( "power_plant_spawner", ::add_spawn_function, ::power_plant_spawner );
	run_thread_on_noteworthy( "power_plant_second_wave", ::add_spawn_function, ::swarm_hillside );
	
	run_thread_on_noteworthy( "clear_target_radius", ::clear_target_radius );
	run_thread_on_noteworthy( "visible_mgguy", ::add_spawn_function, ::visible_mgguy_think );

	run_thread_on_noteworthy( "bored_guy", ::ignore_until_high_alert );
	hut_runner = getent( "hut_runner", "script_linkname" );
	hut_runner thread hut_runner_think();
	
	run_thread_on_noteworthy( "hut_sentry", ::tango_down_detection );
	run_thread_on_targetname( "hut_patrol", ::tango_down_detection );

	run_thread_on_noteworthy( "chess_guy_1", ::add_spawn_function, ::tango_down_detection );
	run_thread_on_noteworthy( "chess_guy_2", ::add_spawn_function, ::tango_down_detection );
	run_thread_on_noteworthy( "shack_sleeper", ::add_spawn_function, ::tango_down_detection );
	run_thread_on_noteworthy( "instant_high_alert", ::add_spawn_function, ::instant_high_alert );
	
	
	thread smell_kamarov();
	thread power_station_dialogue();
	
//	shack_guys = getentarray( "shack_guy", "targetname" );
//	array_thread( shack_guys, ::spawn_ai );
	
	thread descriptions();
	thread blackout_stealth_settings();
	
	level.respawn_spawner = getent( "ally_respawn", "targetname" );
	flag_set( "respawn_friendlies" );

	assault_spawners = getentarray( "assault_spawner", "targetname" );
	array_thread( assault_spawners, ::add_spawn_function, ::replace_on_death );
	array_thread( assault_spawners, ::add_spawn_function, ::ground_allied_forces );

	assault_second_waves = getentarray( "assault_second_wave", "targetname" );
	array_thread( assault_second_waves, ::add_spawn_function, ::replace_on_death );
	array_thread( assault_second_waves, ::add_spawn_function, ::ground_allied_forces );

	color_spawners = getentarray( "color_spawner", "targetname" );
	array_thread( color_spawners, ::add_spawn_function, ::ground_allied_forces );
	
	heli_rescue_trigger = getent( "heli_rescue_trigger", "script_noteworthy" );
	heli_rescue_trigger trigger_off();

	blackout_fence_down = getent( "blackout_fence_down", "targetname" );
	blackout_fence_down hide();
	blackout_fence_down notsolid();

	thread set_nvg_vision( "blackout_nvg", 0.5 );
	
	level.friendlynamedist = getdvarint( "g_friendlynamedist" );

	thread player_rappel_think();
	thread detect_recent_flashed();
	battlechatter_off( "allies" );

	thread music_control();

	wait( 5 );
	setsaveddvar( "cg_cinematicFullScreen", "0" );
	for ( ;; )
	{
		flag_wait( "hut_tv_on" );
		thread loop_cinematic();
		flag_waitopen( "hut_tv_on" );
		level notify( "stop_cinematic" );
		StopCinematicInGame();
	}
}

loop_cinematic()
{
	level endon( "stop_cinematic" );

	for ( ;; )
	{
	  if ( getdvar("ps3Game") == "true" )
	    CinematicInGameLoopFromFastfile( "asad_speech_180" );
	  else
	    CinematicInGameLoopResident( "asad_speech_180" );

	  wait 5;
	  
	  while ( IsCinematicPlaying() )
		wait 1;
	}
}

start_normal()
{
	default_fog = getent( "blackout_swamp_fog", "script_noteworthy" );
	default_fog apply_fog();	

//	thread swamp_sprint_protection();	
	thread AA_town_init();
	setup_sas_buddies();
	setup_player();
	walking_the_stream();
}


start_chess()
{
	player_org = getent( "player_chess_org", "targetname" );
	level.player setorigin( player_org.origin );
	activate_trigger_with_targetname( "second_shack_trigger" );
	start_normal();
}


walking_the_stream()
{
	thread outpost_objectives();
	
	thread field_meeting();
	
	node = getnode( "signal1", "script_noteworthy" );
	level.price thread first_signal_on_node( node, "stop2_exposed" );

	allies = getaiarray( "allies" );
//	array_thread( allies, ::stealth_ai );
	array_thread( allies, ::friendly_think );
	
	thread hut_tv();
	
//un_thread_on_targetname( "signal_stop", ::signal_stop );
	
	hut_sentry = getent( "hut_sentry", "script_noteworthy" );
	hut_sentry thread idle_relative_to_target( "smoke_idle", "bored_alert" );

//	run_thread_on_targetname( "pier_trigger", ::pier_trigger_think );

	bored_guys = getentarray( "bored_guy", "script_noteworthy" );
	array_thread( bored_guys, ::reach_and_idle_relative_to_target, "bored_idle_reach", "bored_idle", "bored_alert" );

	bored_guys = getentarray( "hut_hanger", "script_noteworthy" );
	array_thread( bored_guys, ::reach_and_idle_relative_to_target, "bored_idle_reach", "bored_cell_loop", "bored_alert" );
	
	add_wait( ::flag_wait, "play_nears_second_shacks" );
	add_func( ::autosave_by_name, "claymore_save" );
	thread do_wait();
	
	
	add_wait( ::flag_wait, "pier_guys" );
	add_wait( ::flag_wait, "hut_cleared" );
	add_wait( ::flag_wait, "play_nears_second_shacks" );
	do_wait_any();

	if ( flag( "play_nears_second_shacks" ) )
	{
		// sprinted past the action so need to play catchup
		kill_all_ai_of_deathflag( "pier_guys" );
		kill_all_ai_of_deathflag( "hut_guys" );
		price_and_gaz_catchup_to_bridge();
	}
	else
	if ( !flag( "high_alert" ) )
	{
		// the sentry died quietly so we can sneak up to the hut
		wait( randomfloatrange( 0.6, 1.2 ) );
		level.price set_force_color( "b" );
		level.gaz set_force_color( "o" );
//		node = getnode( "signal2", "script_noteworthy" );
//		level.gaz thread signal_on_node( node, "moveout_cqb" );
		thread price_and_gaz_flash_hut();
		
		add_wait( ::flag_wait, "gaz_rushes_hut" );
		add_wait( ::flag_wait, "high_alert" );
		add_wait( ::flag_wait, "hut_cleared" );
		do_wait_any();
				
		level.price stopanimscripted();
		gaz_hut_node = getnode( "gaz_hut_node", "targetname" );
		level.gaz disable_ai_color();
		level.gaz.fixednodesaferadius = 0;
		level.gaz setgoalnode( gaz_hut_node );
		level.gaz.ignoreall = false;
		level.price.ignoreall = false;
//		flag_set( "high_alert" );
	}
	
	flag_wait( "hut_cleared" );
	if ( !flag( "high_alert" ) )
	{
		level.gaz.fixednodesaferadius = 32;
		level.price.ignoreall = true;
		level.gaz.ignoreall = true;
	}

	
	wait( 0.4 );
// Good work. There should be a few more guard posts up ahead. Kamarov and his men will be waiting for us in a field to the northwest.	
	level.price thread dialogue_queue( "guard_posts_ahead" );
	wait( 0.3 );
//	thread watch_for_movement();
//	array_thread( allies, ::set_force_color, "y" );
	level.price set_force_color( "y" );
	level.gaz set_force_color( "p" );

//	activate_trigger_with_targetname( "move_to_bridge" );

	flag_wait_either( "shack_signal", "chess_cleared" );
	if ( !flag( "high_alert" ) && !flag( "chess_cleared" ) )
	{
		node = getnode( "shack_node", "targetname" );
		thread shack_signal( node );
		node = getnode( "shack_node2", "targetname" );
		thread shack_signal( node );
	}
	flag_wait_either( "chess_cleared", "high_alert" );
	
	if ( flag( "high_alert" ) )
		activate_trigger_with_targetname( "hide_from_shack" );
	else
		activate_trigger_with_targetname( "sneak_up_on_shack" );
	
	flag_wait( "shack_cleared" );
	flag_wait( "chess_cleared" );
	wait( 1.5 );
	
	level.price set_force_color( "c" );
	level.gaz set_force_color( "g" );

	add_global_spawn_function( "axis", ::commence_attack_on_death );
	axis = getaiarray( "axis" );
	array_thread( axis, ::commence_attack_on_death );
	
	flag_wait( "meeting_door_open" );
	activate_trigger_with_targetname( "meeting_trigger" );
	flag_set( "meeting_begins" );
	
	setsaveddvar( "g_friendlynamedist", "0" );
	flag_wait( "commence_attack" );
	remove_global_spawn_function( "axis", ::commence_attack_on_death );
}

start_field()
{
	flag_set( "meeting_begins" );
	thread AA_town_init();
	thread field_meeting();
	setup_sas_buddies();
	setup_player();
	
	axis = getaiarray( "axis" );
	array_levelthread( axis, ::deleteent );
	
	allies = getaiarray( "allies" );
	flag_set( "second_shacks" );
		
	player_org = getent( "player_meeting_org", "targetname" );
	
	level.player setorigin( player_org.origin + (0,0,-27000) );
	price_meeting_org = getent( "price_meeting_org", "targetname" );
	gaz_meeting_org = getent( "price_meeting_org", "targetname" );
	level.price teleport( price_meeting_org.origin, price_meeting_org.angles );
	level.gaz teleport( gaz_meeting_org.origin, gaz_meeting_org.angles );

	level.player setorigin( player_org.origin );
	activate_trigger_with_targetname( "meet_at_field" );
	level.gaz set_force_color( "y" );
}


field_meeting()
{
	node = getnode( "farm_meet_node", "targetname" );
	node = getent( "farm_meet_org", "targetname" );
	
	flag_wait( "second_shacks" );
	thread overlook_sniping();
	
	fail_on_friendly_fire();

	level.field_russians = [];
	field_russians = getentarray( "field_russian", "targetname" );
	array_thread( field_russians, ::add_spawn_function, ::field_russian_think );
	array_thread( field_russians, ::spawn_ai );

	russian_leader = getent( "russian_leader", "targetname" );
	russian_leader thread add_spawn_function( ::russian_leader_think, true );
	russian_leader thread add_spawn_function( ::magic_bullet_shield );
	russian_leader thread add_spawn_function( ::set_allowed_stances, "crouch" );
	russian_leader thread spawn_ai();

	meeting_clip = getent( "meeting_clip", "targetname" );
//	meeting_clip connectpaths();
//	meeting_clip notsolid();
	

	flag_wait( "meeting_begins" );
	arcademode_checkpoint( 6, "a" );
	set_ambient( "ambient_ext_level1" );

	level.price disable_ai_color();
	level.gaz disable_ai_color();

	node thread anim_reach_solo( level.price, "meeting" );
	gaz_node = getnode( "gaz_field_node", "targetname" );
	level.gaz setgoalnode( gaz_node );
	
	

//		level.price waittill( "goal" );
//		node anim_reach_solo( level.kamarov, "meeting" );
	kamarov_and_price = make_array( level.price, level.kamarov );

	level.price.goalradius = 180;
	level.price waittill( "goal" );
	level.price.goalradius = 8;
	level.kamarov anim_generic( level.kamarov, "standup" );
	level.kamarov allowedstances( "stand", "crouch", "prone" );
	flag_wait( "field_trigger" );
	level.price waittill( "goal" );
	
//		node = getent( "farm_meet_org3", "targetname" );
//		node anim_single( kamarov_and_price, "meeting" );


	node = getent( "farm_meet_org", "targetname" );
	thread field_russians_go_up_hill();
	thread kam_and_price_chat();
	
	level.price.a.movement = "run";
	level.kamarov.a.movement = "run";
	level.kamarov.a.pose = "stand";
	meeting_clip disconnectpaths();
	meeting_clip solid();

	setsaveddvar( "g_friendlynamedist", "0" );
	delaythread( 7, ::flag_set, "russians_stand_up" );
	delaythread( 9, ::_setsaveddvar, "g_friendlynamedist", level.friendlynamedist );
	delaythread( 16.0, ::flag_set, "go_up_hill" );
	delaythread( 19.2, ::flag_set, "field_stop" );
	delaythread( 25.3, ::flag_set, "field_go" );
	level.kamarov delaythread( 25.5, ::anim_stopanimscripted );
	level.price delaythread( 26.0, ::anim_stopanimscripted );
//	delaythread( 25, ::delete_meeting_clip, meeting_clip );

	level.timer = gettime();
	
	kam_node = getent( "kaz_overlook_org", "targetname" );
	level.kamarov setgoalpos( kam_node.origin );
	
	
	delaythread( 25.20, ::flag_set, "gaz_and_price_go_up_hill" );
	node anim_single( kamarov_and_price, "meeting" );
	
	autosave_by_name( "follow_me" );

	level.hilltop_mortar_team_1 = [];
	level.hilltop_mortar_team_2 = [];
	
	level.kamarov stop_magic_bullet_shield();
	level.kamarov thread sas_main_think();
	ai = getaiarray( "allies" );
	array_thread( ai, ::set_ignoreall, true );
	array_thread( ai, ::set_ignoreme, true );
	
	

//	leader_hilltop_org = getent( "leader_hilltop_org", "targetname" );
//	leader_hilltop_org anim_generic_reach( level.kamarov, "stop_cqb" );
//	leader_hilltop_org thread anim_generic( level.kamarov, "stop_cqb" );

//	thread add_dialogue_queue( kamarov(), "Volsky, Pavlov, set up your mortar here. Petra, Brekov, down there." );
//	wait( 4 );


	flag_set( "go_to_overlook" );
	thread overlook_mortars();
	
	objective_complete( 2 );
	Objective_Add( 3, "current", &"BLACKOUT_PROVIDE_SNIPER_SUPPORT", ( -7587, -2233, 857 ) );

	flag_wait( "over_here" );
	flag_wait( "player_near_overlook" );

	normal_friendly_fire_penalty();
	if ( flag( "high_alert" ) )
	{
		flag_set( "commence_attack" );
		return;
	}
	level endon( "high_alert" );

	// Vanya, standby to attack. Sniper team, report.	
//	level.kamarov dialogue_queue( "standby_to_attack" );
	
	// Sniper team in position. Gaz, cover the left flank.                                                
	level.price dialogue_queue( "in_position" );

	// Roger. Covering left flank.                                                                       
	level.gaz dialogue_queue( "cover_left_flank" );

	wait( 1 );
	
	flag_wait_either( "player_at_overlook", "high_alert" );

	flag_set( "commence_attack" );


	/*
	hilltop_russian_leader_hangout = getent( "hilltop_russian_leader_hangout", "targetname" );
	level.kamarov setgoalpos( hilltop_russian_leader_hangout.origin );
	level.kamarov.goalradius = 32;
	*/
}

overlook_mortars()
{
	flag_wait_either( "commence_attack", "high_alert" );
	flag_wait( "ready_to_commence_attack" );
	
	wait( 1 );
	// All units, commence the attack.	
	level.kamarov dialogue_queue( "commence_attack" );

	wait( 1.5 );
	thread exploder( 60 );
	wait( 3 );
	flag_set( "overlook_attack_begins" );
}

start_overlook()
{
	thread AA_town_init();
	flag_set( "go_up_hill" );
	flag_set( "second_shacks" );
	flag_set( "bm21s_attack" );
	flag_set( "ready_to_commence_attack" );

	thread overlook_mortars();

	setup_sas_buddies();
	russian_leader = getent( "russian_leader", "targetname" );
	russian_leader thread add_spawn_function( ::russian_leader_think );
	russian_leader thread add_spawn_function( ::sas_main_think );
	russian_leader thread spawn_ai();

	setup_player();

	delaythread( 0.05, ::flag_set, "go_to_overlook" );
	
	axis = getaiarray( "axis" );
	array_levelthread( axis, ::deleteent );
	
	allies = getaiarray( "allies" );
	player_org = getent( "player_overlook_org", "targetname" );
	level.player setorigin( player_org.origin + (0,0,-27000) );

	ally_orgs = getentarray( "friendly_overlook_org", "targetname" );
	for ( i = 0; i < allies.size; i++ )
	{
		allies[ i ].ignoreall = true;
		allies[ i ] teleport( ally_orgs[ i ].origin, ally_orgs[ i ].angles );
	}



	thread overlook_sniping();

	level.player setorigin( player_org.origin );
	
	wait( 2 );
	flag_set( "commence_attack" );
}


overlook_sniping()
{
	flag_wait( "go_up_hill" );
//	thread haunted_sniping();

	thread price_tells_player_to_come_over();
	
	village_blocker = getent( "village_blocker", "targetname" );
	village_blocker connectpaths();
	village_blocker notsolid();
	
	overlook_runners = getentarray( "overlook_runner", "script_noteworthy" );
	array_thread( overlook_runners, ::add_spawn_function, ::overlook_runner_think );

	smoker_spawners = getentarray( "smoker_spawner", "targetname" );
	array_thread4( smoker_spawners, ::add_spawn_function, ::reach_and_idle_relative_to_target, "smoking_reach", "smoking", "smoking_react" );
	array_thread( smoker_spawners, ::add_spawn_function, maps\_props::attach_cig_self );
	array_thread( smoker_spawners, ::spawn_ai );

	bored_guys = getentarray( "wall_idler", "targetname" );
	array_thread4( bored_guys, ::add_spawn_function, ::reach_and_idle_relative_to_target, "bored_idle_reach", "bored_cell_loop", "bored_alert" );
	array_thread( bored_guys, ::spawn_ai );

	street_walkers = getentarray( "street_walker", "targetname" );
	array_thread( street_walkers, ::add_spawn_function, ::street_walker_think );
	array_thread( street_walkers, ::spawn_ai );
	
	
	
	flag_wait( "player_at_overlook" );
	flag_set( "bm21s_attack" );

	autosave_by_name( "overlook" );
	
	delaythread( 2, ::display_sniper_hint );
	level.player.threatbias = -350;
	
	thread turn_off_stealth();

	thread hilltop_sniper();
	
	
	thread overlook_player_mortarvision();
	flag_wait( "overlook_attack_begins" );
	set_ambient( "ambient_ext_level3" );
	
	battlechatter_on( "allies" );
	ai = getaiarray( "allies" );
	array_thread( ai, ::set_ignoreme, false );
	
	activate_trigger_with_targetname( "overlook_charge" );

	assault_spawners = getentarray( "assault_spawner", "targetname" );
	array_thread( assault_spawners, ::spawn_ai );


	first_mg_guys = getentarray( "first_mg_guys", "targetname" );
	array_thread( first_mg_guys, ::add_spawn_function, ::overlook_turret_think );
	array_thread( first_mg_guys, ::spawn_ai );
	
	thread overlook_price_tells_you_to_shoot_mgs();

	thread overlook_badguys_pour_in();

	
	first_rpg_spawner = getent( "first_rpg_spawner", "targetname" );
	first_rpg_spawner thread add_spawn_function( ::first_rpg_spawner_think );
	first_rpg_spawner spawn_ai();
	flag_wait( "first_bmp_destroyed" );
	flag_wait( "mgs_cleared" );

	thread breach_first_building();	
	thread spawn_vehicles_from_targetname_and_drive( "enemy_heli" );
	
//	flag_wait_or_timeout( "breach_complete", 10 );
	wait( 4.5 );
	flag_wait( "begin_the_breach" );
	level.player.threatbias = 0;

	level.player.maxvisibledist = 2048;
	flag_set( "kam_go_through_burning_house" );	
	activate_trigger_with_targetname( "to_the_cliff" );
	damn_helicopters();
	
	Objective_complete( 3 );
	Objective_Add( 4, "current", &"BLACKOUT_CUT_OFF_ENEMY_REINFORCEMENTS", power_plant_org() );

	// the axis fall back!	
//	axis = getaiarray( "axis" );
//	arraY_thread( axis, ::fall_back_to_defensive_position );
	flag_set( "go_through_burning_house" );	
	arcademode_checkpoint( 8, "b" );
	
	wait( 1.2 );

	
	//flag_set( "breach_complete" );
	autosave_by_name( "to_the_cliff" );
	
//	iprintlnbold( "End of current mission" );

	village_blocker disconnectpaths();
	village_blocker solid();

	delaythread( 20, ::cliff_reminder );
	flag_wait( "player_reaches_cliff_area" );

	// Sir, we've got company! Helicopter troops closing in fast!                                       
	level.gaz delaythread( 1.5, ::dialogue_queue, "helicopter_troops" );

	activate_trigger_with_targetname( "cliff_ground_forces" );
	level.price.ignoreall = false;
	level.gaz.ignoreall = false;
	level.kamarov.ignoreall = false;
//	missionsuccess( "armada", false );
	
	// enemies fall back
	
//	first_breach_org
	
	thread cliff_sniping();
	
	thread player_battles_towards_power_plant();

	flag_wait( "power_plant_cleared" );	
	level.price.baseaccuracy = 1;
	level.gaz.baseaccuracy = 1;
	level.kamarov.baseaccuracy = 1;
	Objective_complete( 4 );
//Provide sniper support from the cliff above town.
	Objective_Add( 5, "current", &"BLACKOUT_PROVIDE_SNIPER_SUPPORT1", cliff_org() );
}

player_battles_towards_power_plant()
{
	level endon( "power_plant_cleared" );
	flag_assert( "power_plant_cleared" );
	
	flag_wait( "heroes_high_accuracy" );
	array_thread( level.deathflags[ "power_plant_cleared" ][ "ai" ], ::attack_player );
	level.price.baseaccuracy = 1000;
	level.gaz.baseaccuracy = 1000;
	level.kamarov.baseaccuracy = 1000;
	flag_wait( "player_approaches_power_plant" );
	array_thread( level.deathflags[ "power_plant_cleared" ][ "spawners" ], ::_delete );
	array_thread( level.deathflags[ "power_plant_cleared" ][ "ai" ], ::kill_player );
}

overlook_badguys_pour_in()
{
	level endon( "breach_complete" );
	flag_assert( "breach_complete" );
	flag_wait_or_timeout( "overlook_attention", 20 );
	
	thread overlook_alarm();
	
	east_spawners = getentarray( "east_spawner", "targetname" );
	array_thread( east_spawners, ::add_spawn_function, ::fall_back_to_defensive_position );
	array_thread( east_spawners, ::spawn_ai );

	wait( 15 );
	mid_spawners = getentarray( "mid_spawner", "targetname" );
	array_thread( mid_spawners, ::add_spawn_function, ::fall_back_to_defensive_position );
	array_thread( mid_spawners, ::spawn_ai );

	thread spawn_replacement_baddies();

	assault_second_waves = getentarray( "assault_second_wave", "targetname" );
	array_thread( assault_second_waves, ::spawn_ai );
}


haunted_sniping()
{
	trigger = getent( "bmp_trigger", "targetname" );
	trigger waittill( "trigger" );
	bmp = spawn_vehicle_from_targetname_and_drive( "bmp" );
}

start_cliff()
{
	thread AA_town_init();
	flag_set( "go_through_burning_house" );
	flag_set( "go_up_hill" );
	flag_set( "go_to_overlook" );
	flag_set( "overlook_attack_begins" );
	flag_set( "breach_complete" );
	flag_set( "bm21s_attack" );
	delayThread( 1, ::flag_set, "power_plant_cleared" );
	
	russian_leader = getent( "russian_leader", "targetname" );
	russian_leader thread add_spawn_function( ::russian_leader_think );
//	russian_leader thread add_spawn_function( ::sas_main_think );
	russian_leader thread spawn_ai();
	
	allies = getaiarray( "allies" );
	setup_sas_buddies();
	setup_player();
	
	axis = getaiarray( "axis" );
	array_levelthread( axis, ::deleteent );
	
	thread cliff_sniping();
	
	guys = get_guys_with_targetname_from_spawner( "assault_spawner" );
	otherguys = get_guys_with_targetname_from_spawner( "assault_second_wave" );
	
	guys = array_combine( guys, otherguys );
	wait( 0.05 );
	starts = getentarray( "ally_cliff_start_org", "targetname" );
	
	for ( i = 0; i < guys.size; i++ )
	{
		guys[ i ] teleport( starts[ i ].origin );
	}

	flag_set( "player_reaches_cliff_area" );
	wait( 0.5 );
	player_org = getent( "player_cliff_org", "targetname" );
	level.player setorigin( player_org.origin + (0,0,-27000) );

/*
	guy = get_guy_with_targetname_from_spawner( "blackout_spawner" );
	org = getent( guy.target, "targetname" );
	guy.ignoreall = true;
*/
	ally_orgs = getentarray( "friendly_cliff_org", "targetname" );
	for ( i = 0; i < allies.size; i++ )
	{
		allies[ i ] teleport( ally_orgs[ i ].origin, ally_orgs[ i ].angles );
	}
	level.player setorigin( player_org.origin );
	
}

cliff_sniping()
{
	activate_trigger_with_targetname( "cliff_trigger" );

	level.respawn_spawner = getent( "ally_cliff_spawner", "targetname" );
	flag_set( "cliff_fighting" );	
	thread spawn_replacement_cliff_baddies();
//	friendly_bmp = spawn_vehicle_from_targetname_and_drive( "friendly_bmp" );
	level.enemy_bmp = spawn_vehicle_from_targetname_and_drive( "enemy_bmp" );
	level.enemy_bmp thread bmp_targets_stuff();
	level.enemy_bmp godon();

	level.defenders_killed = 0;
	thread cliff_bm21_blows_up();
	
	flag_wait( "cliff_look" );
	thread do_in_order( ::flag_wait, "power_plant_cleared", ::autosave_by_name, "power_plant_cleared" );
	flag_set( "cliff_tanks_move" );

	level.player.ignoreme = true;
	
	flag_wait( "cliff_moveup" ); // gets set by defenders dying
	
	activate_trigger_with_targetname( "cliff_allies_advance" );
	flag_wait( "cliff_tank_path_end" );

	wait( 3 );
	
	bmp_killer_spawner = getent( "bmp_killer_spawner", "targetname" );
	bmp_killer_spawner thread add_spawn_function( ::bmp_killer_spawner_think );
	bmp_killer_spawner thread spawn_ai();
	wait( 0.05 );
	assertex( isalive( level.bmp_killer ), "bmp_killer_spawner failed to spawn" );
	
	if ( !flag( "power_plant_cleared" ) )
	{
		array_thread( level.deathflags[ "power_plant_cleared" ][ "ai" ], ::attack_player );
		array_thread( level.deathflags[ "power_plant_cleared" ][ "spawners" ], ::_delete );
		flag_wait( "power_plant_cleared" );
	}

	roof_sniper_spawners = getentarray( "roof_sniper_spawner", "targetname" );
	array_thread( roof_sniper_spawners, ::add_spawn_function, ::roof_spawner_think );
	array_thread( roof_sniper_spawners, ::spawn_ai );

	flag_wait( "cliff_roof_snipers_cleared" );

	// Good! Now we are making progress. Follow me to the power station.	
	level.kamarov thread dialogue_queue( "making_progress" );
	flag_set( "kam_heads_to_rappel_spot" );
	wait( 4 );
	flag_set( "cliff_complete" );
	activate_trigger_with_targetname( "friendlies_charge_farmhouse" );

	Objective_complete( 5 );
	Objective_Add( 6, "current", &"BLACKOUT_FOLLOW_KAMAROV_TO_POWER_STATION", rappel_org() );

	flag_set( "head_to_rappel_spot" );
	arcademode_checkpoint( 10, "c" );
	
	flag_wait( "final_raid_begins" );
	thread raid_farmhouse();	
	// Follow Kamarov to the Power Station
	
	
	flag_wait( "kam_wants_more_sniping" );
	
	// Provide even more sniper support.
	Objective_string( 6, &"BLACKOUT_PROVIDE_MORE_SNIPER_SUPPORT" );

	flag_wait( "gaz_convinces_kam_otherwise" );

	//"Rappel down from the Power Station."
	Objective_string( 6, &"BLACKOUT_RAPPEL_DOWN_FROM_THE" );
	
	flag_wait( "player_rappels" );

	Objective_Complete( 6 );
//Rescue the informant.
	Objective_Add( 7, "current", &"BLACKOUT_RESCUE_THE_INFORMANT", informant_org() );
	autosave_by_name( "attack_farmhouse" );
}


start_rappel()
{
	flag_set( "cliff_look" );
	flag_set( "cliff_moveup" ); // gets set by defenders dying
	flag_set( "cliff_roof_snipers_cleared" );
	flag_set( "go_through_burning_house" );
	flag_set( "bm21s_attack" );
	flag_set( "kam_heads_to_rappel_spot" );
	flag_set( "head_to_rappel_spot" );
	flag_set( "cliff_complete" );
	thread start_cliff();
}

start_farmhouse()
{
	thread AA_town_init();
	flag_set( "saw_first_bm21" );
	thread cliff_bm21_blows_up();
	flag_set( "go_up_hill" );
	flag_set( "go_to_overlook" );
	flag_set( "overlook_attack_begins" );
	flag_set( "breach_complete" );
	flag_set( "on_to_the_farm" );
	flag_set( "power_plant_cleared" );
	flag_set( "go_through_burning_house" );	
	flag_set( "kam_go_through_burning_house" );	
	flag_set( "bm21s_attack" );
		
	allies = getaiarray( "allies" );
	setup_sas_buddies();
	setup_player();
	
	axis = getaiarray( "axis" );
	array_levelthread( axis, ::deleteent );
	
	flag_set( "player_reaches_cliff_area" );

	wait( 0.5 );
	player_org = getent( "player_farmhouse_org", "targetname" );
	level.player setorigin( player_org.origin + (0,0,-27000) );

	ally_orgs = getentarray( "ally_farmhouse_org", "targetname" );
	for ( i = 0; i < allies.size; i++ )
	{
		allies[ i ] teleport( ally_orgs[ i ].origin, ally_orgs[ i ].angles );
	}
	level.player setorigin( player_org.origin );

	thread raid_farmhouse();	
}
	
raid_farmhouse()
{
	activate_trigger_with_targetname( "friendlies_charge_farmhouse" );
	ally_forced_farm_spawners = getentarray( "ally_forced_farm_spawner", "targetname" );
	array_thread( ally_forced_farm_spawners, ::add_spawn_function, ::replace_on_death );
	array_thread( ally_forced_farm_spawners, ::spawn_ai );
	ally_farm_spawner = getent( "ally_farm_spawner", "targetname" );
	level.respawn_spawner = ally_farm_spawner;
	clear_promotion_order();
	set_promotion_order( "c", "r" );
	instantly_promote_nearest_friendly( "r", "c" );
	instantly_promote_nearest_friendly( "r", "c" );
	instantly_promote_nearest_friendly( "r", "c" );

	thread activate_farmhouse_defenders();
	
	farm_rpg_spawner = getent( "farm_rpg_spawner", "targetname" );
	farm_rpg_spawner thread add_spawn_function( ::farm_rpg_guy_attacks_bm21s );
	farm_rpg_spawner spawn_ai();
	
	
	flag_wait( "rpg_guy_attacks_bm21s" );
	set_ambient( "ambient_ext_level5" );
	flag_wait( "farm_complete" );
	set_ambient( "ambient_ext_level1" );

	/*
	// Kamarov, we've completed our end of the bargain. Now where is the informant?                      
	level.price dialogue_queue( "where_is_informant" );

	// Very well. Your informant is being held in the house at the northeast end of the village. Dead or alive you will find him there. Good luck.	
	radio_dialogue( "informant_held_in_house" );

	// May be alive?? I hate bargaining with Kamarov. There's always a bloody catch.                    
	level.gaz dialogue_queue( "hate_bargaining" );
	*/

	// Bloody hell let's move. He may still be alive.                                                  
	level.price dialogue_queue( "lets_move" );

	level.price set_force_color( "y" );	
	level.gaz set_force_color( "y" );	
//	level.bob set_force_color( "y" );	
	thread blackout_house();
}


start_blackout()
{
	flag_set( "go_up_hill" );
	flag_set( "go_to_overlook" );
	flag_set( "overlook_attack_begins" );
	flag_set( "farm_complete" );
	flag_set( "blackout_house_begins" );
	flag_set( "go_through_burning_house" );
	
	setup_sas_buddies();
	setup_player();
	
	axis = getaiarray( "axis" );
	array_levelthread( axis, ::deleteent );
	
	player_org = getent( "player_blackout_org", "targetname" );
	level.player setorigin( player_org.origin + (0,0,-27000) );

/*
	guy = get_guy_with_targetname_from_spawner( "blackout_spawner" );
	org = getent( guy.target, "targetname" );
	guy.ignoreall = true;
*/
	allies = getaiarray( "allies" );
	ally_orgs = getentarray( "ally_blackout_org", "targetname" );
	for ( i = 0; i < allies.size; i++ )
	{
		allies[ i ] teleport( ally_orgs[ i ].origin, ally_orgs[ i ].angles );
	}

	level.player setorigin( player_org.origin );
	
	/*
	wait( 2 );
	anims = [];
	anims[ anims.size ] = "blind_fire_pistol";	// corner guy aiming with pistol
	anims[ anims.size ] = "blind_fire_pistol_death";
	anims[ anims.size ] = "blind_hide_fire";		// pop up from behind cover spray area
	anims[ anims.size ] = "blind_hide_fire_death";
	anims[ anims.size ] = "blind_lightswitch";
	anims[ anims.size ] = "blind_lightswitch_death";
	anims[ anims.size ] = "blind_wall_feel";
	anims[ anims.size ] = "blind_wall_feel_death";
	
	anims[ anims.size ] = "close";
	anims[ anims.size ] = "death_1";
	anims[ anims.size ] = "death_2";
	anims[ anims.size ] = "fire_1";
	anims[ anims.size ] = "fire_2";
	anims[ anims.size ] = "fire_3";
	anims[ anims.size ] = "grenade";
	anims[ anims.size ] = "idle";
	anims[ anims.size ] = "jump";
	anims[ anims.size ] = "kick";
	anims[ anims.size ] = "open";

	door = spawn_anim_model( "door" );	
	
	guy.animname = "generic";
	guys = [];
	guys[ guys.size ] = guy;
	guys[ guys.size ] = door;

	guy.noback = true;

	for ( i=0; i < anims.size; i++ )
	{
		anime = anims[ i ];
		iprintlnbold( "about to play: " + anime );
		wait( 2 );
//		guy animscripts\shared::placeWeaponOn( guy.sidearm, "right" );
//		org anim_generic( guy, anime );
		org anim_single( guys, anime );
		wait( 1 );
	}	
	*/
	
	thread blackout_house();
}



blackout_house()
{
	battlechatter_off( "allies" );

	Objective_Position( 7, informant_org() );
	Objective_Ring( 7 );
	
	blackout_path_block = getent( "blackout_path_block", "targetname" );
	blackout_path_block connectpaths();
	blackout_path_block notsolid();

	flag_wait( "blackout_house_begins" );
	
	thread blackout_vision_adjustment();
	
	blind_guy_spawners = getentarray( "blind_guy_spawner", "targetname" );
	array_thread( blind_guy_spawners, ::add_spawn_function, ::blind_guy_think );
	array_thread( blind_guy_spawners, ::spawn_ai );

	level.price.baseaccuracy = 5000;
	level.gaz.baseaccuracy = 5000;
	level.price.grenadeammo = 0;
	level.gaz.grenadeammo = 0;
		
	// Gaz, go around the back and cut the power. Everyone else, get ready!                                
	level.price dialogue_queue( "cut_the_power" );

	thread gaz_goes_to_cut_the_power();
	
	level.price disable_ai_color();
	level.gaz disable_ai_color();

	add_wait( ::flag_wait, "player_in_house" );
	add_func( ::player_in_house );
	thread do_wait();
	
	price_approaches_door();

	autosave_by_name( "blackout" );
	
	level.gaz.goalradius = 120;
	level.gaz waittill( "goal" );

	flag_wait( "player_at_blackout_door" );
	level.price anim_single_queue( level.price, "gaz_do_it" );

	blackout_lights_go_out();
	wait( 0.5 );
	level.gaz thread anim_single_queue( level.gaz, "i_cut_the_power" );
	
	wait( 0.25 );

	level.price cqb_walk( "on" );
	level.price.disablearrivals = true;

	thread lightswitch_response();
	
	
	price_opens_door_and_goes_in();	

	flag_wait( "player_in_house" );
	gaz_teleports_upstairs();
	thread blackout_rescue();
	
	flag_wait( "gaz_runs_by_window" );
	autosave_by_name( "blackout_inside" );
	blackout_upstairs_spotlight = getent( "blackout_upstairs_spotlight", "script_noteworthy" );
	blackout_upstairs_spotlight setLightIntensity( blackout_upstairs_spotlight.old_intensity );
	
	blackout_fence_swap();

	thread gaz_runs_by_window();
	
	flag_wait_either( "turned_corner", "heli_flies_by" );
	flag_set( "turned_corner" );

	
	if ( !flag( "door" ) )
	{
		delaythread( 2, ::price_attacks_door_guy );
		
		flag_wait( "door" ); // door guy died, nice descriptive flag there
		wait( 0.75 );
	}
	else
	{
		thread price_attacks_door_guy();
	}

	thread gaz_opens_door_and_enters();

	flag_wait( "blackout_rescue_complete" );
}	
	
start_rescue()
{
	flag_set( "door" );
	flag_set( "go_up_hill" );
	flag_set( "go_to_overlook" );
	flag_set( "overlook_attack_begins" );
	flag_set( "farm_complete" );
	flag_set( "blackout_house_begins" );
	flag_set( "player_in_house" );
	flag_set( "go_through_burning_house" );
	flag_set( "gaz_opens_door" );
	
	setup_sas_buddies();
	setup_player();
	
	axis = getaiarray( "axis" );
	array_levelthread( axis, ::deleteent );
	
	player_org = getent( "rescue_player_org", "targetname" );
	level.player setorigin( player_org.origin + (0,0,-27000) );

	price_org = getent( "rescue_price_org", "targetname" );
	level.price teleport( price_org.origin );
	level.player setorigin( player_org.origin );
	level.player setplayerangles( player_org.angles );

	power_node = getnode( "gaz_door_dead_node", "targetname" );
	level.gaz teleport( power_node.origin );
	
	thread blackout_vision_adjustment();

	thread blackout_rescue();
	level.price.baseaccuracy = 5000;
	level.gaz.baseaccuracy = 5000;
	level.price.grenadeammo = 0;
	level.gaz.grenadeammo = 0;

	blackout_fence_swap();
	wait( 1 );
	level.price setgoalpos( level.price.origin );
	level.price.goalradius = 32;
	level.gaz setgoalnode( power_node );
	level.gaz.goalradius = 32;
	door = getent( "exit_door", "targetname" );
	door thread palm_style_door_open();
	
}
	
blackout_rescue()
{
	thread blackout_flashlight_guy();
	flag_wait( "door" );

	flag_wait( "blackout_rescue_complete" );	
	flag_clear( "heli_flies_by" );
	objective_complete( 7 );
	//	Evac with the Informant.
	Objective_Add( 8, "current", &"BLACKOUT_EVAC_WITH_THE_INFORMANT", get_evac_org() );
	level.price cqb_walk( "off" );
	level.gaz cqb_walk( "off" );

	blackout_path_block = getent( "blackout_path_block", "targetname" );
	blackout_path_block solid();
	blackout_path_block disconnectpaths();
	blackout_path_block notsolid();
//	blackout_path_block delete();

	// the friendlies movement is set by the rescue dialogue thread		
	
	blackhawk = spawn_vehicle_from_targetname( "rescue_blackhawk" );
	blackhawk_node = getent( "rescue_heli_org", "targetname" );
	oldblackhawk = blackhawk;
	blackhawk = blackhawk vehicle_to_dummy();
	blackhawk thread blackhawk_sound();
	oldblackhawk stopEngineSound();
	
	blackhawk_collision = getent( "blackhawk_collision", "targetname" );
	blackhawk_collision linkto( blackhawk, "tag_origin", (0,0,0), (0,0,0) );

	blackhawk_death_trigger = getent( "blackhawk_death_trigger", "targetname" );
	blackhawk_death_trigger thread manual_linkto( blackhawk, (0,0,-50) ); // -50 cause the tail is too high in the trigger and its too late to recompile
	blackhawk_death_trigger thread heli_squashes_stuff( "blackhawk_lands" );

	blackhawk.animname = "blackhawk";
	blackhawk thread rotor_anim();
	level.blackhawk = blackhawk;
	blackhawk assign_animtree();

	add_wait( ::flag_wait, "heli_flies_by" );
	add_wait( ::flag_waitopen, "player_in_house" );
	do_wait_any();
	
	
	blackhawk_node anim_single_solo( blackhawk, "landing" );
	blackhawk_node thread anim_loop_solo( blackhawk, "idle" );

	flag_set( "blackhawk_lands" );
	
	// this is the model the player will attach to for boarding the heli
	model = spawn_anim_model( "player_rig" );
	model hide();
//	model thread maps\_debug::drawtagforever( "tag_player" );
	// put the model in the first frame so the tags are in the right place
	blackhawk anim_first_frame_solo( model, "player_evac", "tag_detach" );

	model linkto( blackhawk, "tag_detach" );
	
	
	blackhawk anim_reach_solo( level.price, "evac", "tag_detach" );		
	level.price linkto( blackhawk, "tag_detach" );
	blackhawk thread anim_single_solo( level.price, "evac", "tag_detach" );
	blackhawk thread price_evac_idle();


	heli_rescue_trigger = getent( "heli_rescue_trigger", "script_noteworthy" );
	heli_rescue_trigger trigger_on();
	thread player_jumps_into_heli();
	
	// hold jump to climb in
//	heli_rescue_trigger sethintstring( &"SCRIPT_MANTLE" );
	
	flag_wait( "player_gets_on_heli" );
	heli_rescue_trigger delete();
	level.hud_mantle[ "text" ].alpha = 0;
	level.hud_mantle[ "icon" ].alpha = 0;

	level.player allowCrouch( false );
	level.player disableweapons();
	// this smoothly hooks the player up to the animating tag
	model lerp_player_view_to_tag_oldstyle( "tag_player", 0.5, 0.9, 90, 90, 90, 90 );
	// now animate the tag and then unlink the player when the animation ends
	blackhawk thread anim_single_solo( model, "player_evac", "tag_detach" );
//	blackhawk waittill( "player_evac" );

	guys = [];
	guys[ guys.size ] = level.gaz;
	guys[ guys.size ] = level.vip;

	wait( 2.5 );

	array_thread( guys, ::_linkto, blackhawk, "tag_detach" );
	blackhawk thread anim_single( guys, "evac", "tag_detach" );

//	delaythread( 6, ::vip_talks_to_price );
	wait( 8 );
	flag_clear( "blackhawk_lands" );

	blackhawk notify( "stop_loop" ); // stop price from looping
	blackhawk thread anim_single_solo( level.price, "evac_flyaway", "tag_detach" );
	
	blackhawk_node notify( "stop_loop" ); // stop blackhawk idle anim
	blackhawk_node thread anim_single_solo( blackhawk, "take_off" );

	Objective_Complete( 8 );
}


