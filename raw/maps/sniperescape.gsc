#include maps\_utility;
#include maps\_vehicle;
#include maps\sniperescape_code;
#include maps\sniperescape_exchange;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_stealth_logic;
#include maps\sniperescape_wounding;

main()
{	
	precacheItem( "cobra_seeker" );
	precacheshader( "stance_carry" );
	precacheItem( "hind_turret_penetration" );
	level.sniperescape_fastload = false;

	
	maps\_mi17::main( "vehicle_mi17_woodland_fly_cheap" );
	maps\_mi28::main( "vehicle_mi-28_flying" );
//	maps\_mi28::main( "vehicle_mi-28_flying", "mi28_bulletdamage" );
//	maps\_mi28_bulletdamage::main( "vehicle_mi-28_flying" );
	
//	maps\_uaz::main( "vehicle_uaz_hardtop", undefined, true );
	maps\_uaz::main( "vehicle_uaz_hardtop_destructible", undefined, true );
	precacheitem( "barrett_fake" );
// 	maps\_cobra::main( "vehicle_cobra_helicopter_fly" );
// 	maps\_hind::main( "vehicle_mi24p_hind_woodland" );

	maps\_seaknight::main( "vehicle_ch46e" );

	maps\createart\sniperescape_art::main();
	maps\createfx\sniperescape_audio::main();
	maps\sniperescape_fx::main();
	
	maps\_stealth_logic::stealth_init();
	maps\_stealth_behavior::main();

//	maps\_load::set_player_viewhand_model( "viewhands_marine_sniper" );
//	maps\_load::set_player_viewhand_model( "viewhands_player_usmc" );
	maps\_load::set_player_viewhand_model( "viewhands_player_marines" );

	maps\_compass::setupMiniMap("compass_map_sniperescape");

	
	level.player allowstand( false );

	animscripts\dog_init::initDogAnimations();
	setsaveddvar( "ai_eventDistFootstep", "32" );
	setsaveddvar( "ai_eventDistFootstepLite", "32" );

	precacheModel( "temp" );
	precacheModel( "weapon_c4" );
	precacheItem( "cobra_seeker" );
	precacheItem( "flash_grenade" );
	precacheshellshock( "barrett" );
	precachestring( &"SNIPERESCAPE_ELIMINATE_IMRAN_ZAKHAEV" );
	precachestring( &"SNIPERESCAPE_TAKE_OUT_THE_ATTACK_CHOPPER" );
	precachestring( &"SNIPERESCAPE_GET_OUT_OF_THE_HOTEL" );
	precachestring( &"SNIPERESCAPE_REACH_THE_EXTRACTION" );
	precachestring( &"SNIPERESCAPE_FOLLOW_CPT_MACMILLAN" );
	precachestring( &"SNIPERESCAPE_DRAG_MACMILLAN_BODILY" );
	precachestring( &"SNIPERESCAPE_PUT_CPT_MACMILLAN_DOWN" );
	precachestring( &"SNIPERESCAPE_HOLD_OUT_UNTIL_EVAC" );
	precachestring( &"SNIPERESCAPE_SEAKNIGHT_INCOMING" );
	precachestring( &"SNIPERESCAPE_GET_CPT_MACMILLAN_TO" );
	precachestring( &"SNIPERESCAPE_PICK_UP_CPT_MACMILLAN" );
	precachestring( &"SNIPERESCAPE_CARRY_MACMILLAN_TO_THE" );
	precachestring( &"SNIPERESCAPE_CLAYMORE_HELP" );
	precachestring( &"SNIPERESCAPE_PRESS_FORWARDS_OR_BACKWARDS" );
	precachestring( &"SNIPERESCAPE_YOU_FAILED_TO_REACH_THE" );
	precachestring( &"SNIPERESCAPE_HOLD_1_TO_PUT_CPT_MACMILLAN" );
	precachestring( &"SNIPERESCAPE_HOLD_1_TO_PICK_UP_CPT" );
	precachestring( &"SNIPERESCAPE_YOU_LEFT_YOUR_SPOTTER" );
	precachestring( &"SNIPERESCAPE_CPT_MACMILLAN_DIED" );
	precachestring( &"SNIPERESCAPE_HOLD_1_TO_RAPPEL" );
	precachestring( &"SNIPERESCAPE_TIME_REMAINING" );
	precachestring( &"SNIPERESCAPE_TARGET" );
	precachestring( &"SNIPERESCAPE_ZAKHAEV" );
	precachestring( &"SNIPERESCAPE_DISTANCE" );
	precachestring( &"SNIPERESCAPE_M" );
	precachestring( &"SNIPERESCAPE_BULLET_TRAVEL" );
	precachestring( &"SNIPERESCAPE_S" );
	precachestring( &"SCRIPT_HINT_C4_THROW" );
	
	
	precacheRumble( "crash_heli_rumble" );
	precacheRumble( "crash_heli_rumble_rest" );
	
	level.heli_objective = precacheshader( "objective_heli" );
	level.last_price_kill = 0;
	add_start( "rappel", ::rappel_out_of_hotel, &"STARTS_RAPPEL" );
	add_start( "run", ::start_run, &"STARTS_RUN" );
	add_start( "apart", ::start_apartment, &"STARTS_APART" );
	add_start( "wounding", ::start_wounding, &"STARTS_WOUNDING" );
	add_start( "crash", ::start_crash, &"STARTS_CRASH" );
	add_start( "wounded", ::start_wounded, &"STARTS_WOUNDED");
	add_start( "burnt", ::start_burnt, &"STARTS_BURNT" );
	add_start( "pool", ::start_pool, &"STARTS_POOL" );
	add_start( "fair", ::start_fair, &"STARTS_FAIR" );
	add_start( "fair_battle", ::start_fair_battle, &"STARTS_FAIRBATTLE" );
	add_start( "fair_battle2", ::start_fair_battle, &"STARTS_FAIRBATTLE" );
	add_start( "seaknight", ::start_seaknight, &"STARTS_SEAKNIGHT" );
	default_start( ::snipe );
	createthreatbiasgroup( "price" );
	createthreatbiasgroup( "dog" );
	setignoremegroup( "price", "dog" );

	createthreatbiasgroup( "dog_allies" );
	setignoremegroup( "dog", "dog_allies" );
	setignoremegroup( "dog_allies", "dog" );
	

	level.weaponClipModels = [];
	level.weaponClipModels[0] = "weapon_dragunov_clip";
	level.weaponClipModels[1] = "weapon_ak47_clip";
	level.weaponClipModels[2] = "weapon_m16_clip";
	level.weaponClipModels[3] = "weapon_m14_clip";
	level.weaponClipModels[4] = "weapon_g3_clip";
	level.weaponClipModels[5] = "weapon_mp5_clip";
	
	maps\_load::main();

	// init friendly stealth
	ai = getaiarray( "allies" );
	array_thread( ai, ::friendly_init );

	// friendly and enemy dogs ignore each other
	dog_spawners = getentarray( "actor_enemy_dog", "classname" );
	array_thread( dog_spawners, ::add_spawn_function, ::set_dog_threatbias_group );
	

	level.objectives = [];
	addobj( "zakhaev" );
	addobj( "heli" );
	addobj( "hotel" );
	addobj( "heat" );
	addobj( "wounded" );
	addobj( "putdown" );
	addobj( "holdout" );
	addobj( "seaknight" );
	level.objectives[ "wounded" ] = level.objectives[ "heat" ];
	
//	add_hint_string( "prone_at_fair", &"KILLHOUSE_HINT_PRONE", ::should_break_prone_hint );
	add_hint_string( "claymore_plant", &"SCRIPT_LEARN_CLAYMORES", ::should_break_claymores );
	add_hint_string( "c4", &"SCRIPT_C4_USE", ::should_break_c4 );
	add_hint_string( "barrett", &"SNIPERESCAPE_PRESS_FORWARDS_OR_BACKWARDS", ::should_break_zoom_hint );
	add_hint_string( "where_is_he", &"SNIPERESCAPE_WHERE_IS_HE", ::should_break_where_is_he );
	
	set_c4_throw_binding();  //added by z


	if ( level.start_point != "sunset" )
	{	
		thread maps\_radiation::main();
	}		
	maps\sniperescape_anim::main();
	level thread maps\sniperescape_amb::main();	
	

	curtains_left = getentarray( "curtain_left", "targetname" );
	array_thread( curtains_left, ::curtain, "curtain_left" );

	curtains_right = getentarray( "curtain_right", "targetname" );
	array_thread( curtains_right, ::curtain, "curtain_right" );
	
	level.price = getent( "price", "targetname" );
	level.price thread priceInit();
	level.price pushplayer( true );
	level.price.dontavoidplayer = true;
	level.price.interval = 0;
	level.price_sticky_target_time = 5000;

	
	battlechatter_off( "allies" );
//	battlechatter_off( "axis" );

	thread do_in_order( ::flag_wait, "player_looks_through_skylight", ::exploder, 1 );
	
	level.engagement_dist_func = [];
	add_engagement_func( "actor_enemy_merc_SHTGN_winchester", ::engagement_shotgun );
	add_engagement_func( "actor_enemy_merc_AR_ak47", ::engagement_rifle );
	add_engagement_func( "actor_enemy_merc_LMG_rpd", ::engagement_gun );
	add_engagement_func( "actor_enemy_merc_SNPR_dragunov", ::engagement_sniper );
	add_engagement_func( "actor_enemy_merc_SMG_skorpion", ::engagement_smg );

	enemies = getaiarray( "axis" );
	array_thread( enemies, ::enemy_override );
	add_global_spawn_function( "axis", ::enemy_override );
	add_global_spawn_function( "axis", ::dog_check );
	add_global_spawn_function( "axis", ::price_kill_check );

	// flags
	flag_init( "player_on_barret" );
	flag_init( "launch_zak" );
	flag_init( "player_is_on_turret" );
	flag_init( "player_rappels" );
	flag_init( "exchange_heli_alerted" );
	flag_init( "wounding_sight_blocker_deleted" );	
	flag_init( "heli_destroyed" );
	flag_init( "player_gets_off_turret" );
	flag_init( "wounded_zak_runs_for_car" );
	flag_init( "player_can_rappel" );
	flag_init( "price_starts_rappel" );
	flag_init( "price_comments_on_zak_miss" );
	flag_init( "price_comments_on_zak_hit" );
	flag_init( "zak_uaz_leaves" );
	flag_init( "zak_spawns" );
	flag_init( "player_used_zoom" );
	flag_init( "player_attacks_exchange" );
	flag_init( "exchange_success" );
	flag_init( "hotel_destroyed" );
	flag_init( "apartment_explosion" );
	flag_init( "heat_area_cleared" );
	flag_init( "player_defends_heat_area" );
	flag_init( "price_is_safe_after_wounding" );
	flag_init( "price_was_hit_by_heli" );
	flag_init( "price_picked_up" );
	flag_init( "stop_adjusting_vision" );
	flag_init( "beacon_placed" );
	flag_init( "beacon_ready" );
	flag_init( "seaknight_flies_in" );
	flag_init( "enemy_choppers_incoming" );
	flag_init( "first_pickup" );
	flag_init( "seaknight_prepares_to_leave" );
	flag_init( "seaknight_leaves" );
	flag_init( "price_cuts_to_woods" );
	flag_init( "player_moves_through_burnt_apartment" );
	flag_init( "fairbattle_detected" );
	flag_init( "price_can_be_left" );
	flag_init( "fair_hold_fire" );
	flag_init( "fairbattle_high_intensity" );
	flag_init( "seaknight_lands" );
	flag_init( "faiground_battle_begins" );
	flag_init( "fairbattle_gunshot" );
	flag_init( "price_wants_apartment_cleared" );
	flag_init( "heli_comes_to_rest" );
	flag_init( "can_manage_price" );
	flag_set( "can_manage_price" );
	flag_init( "price_moves_to_position" );
	flag_init( "break_for_apartment" );
	flag_init( "player_looked_in_pool" );
	flag_init( "player_made_it_to_seaknight" );
	flag_init( "price_calls_out_kills" );
	flag_set( "price_calls_out_kills" );
	flag_init( "price_calls_out_enemy_location" );
	flag_set( "price_calls_out_enemy_location" );
	flag_init( "price_told_player_to_go_prone" );
	flag_init( "seaknight_leaves_prematurely" );
	flag_init( "exchange_uazs_arrive" );
	flag_init( "fence_dog_dies" );
	flag_init( "heat_heli_transport" );
	flag_init( "price_opens_door" );	
	flag_init( "kill_heli_attacks" );
	flag_init( "price_is_put_down_near_wheel" );
	flag_init( "fairbattle_threat_visible" );
	flag_init( "put_price_near_wheel" );
	flag_init( "heli_shot_down" );
	flag_init( "can_use_turret" );
	
	flag_init( "aa_snipe" );
	flag_init( "aa_heat" );
	flag_init( "aa_wounded" );
	flag_init( "aa_burnt_apartment" );
	flag_init( "aa_seaknight_rescue" );
	flag_init( "wounding_enemy_detected" );
	
	flag_init( "carry_me_music_resume" );
	flag_init( "music_fairgrounds_fade" );
	flag_init( "havoc_hits_ground" );
	flag_init( "rescue_music_start" );
	
	level.firstplay = true;

	add_wait( ::flag_wait, "apartment_explosion" );
	add_func( ::blow_up_hotel );
	thread do_wait();

	add_wait( ::flag_wait, "player_enters_fairgrounds" );
	add_func( ::check_for_price );
	thread do_wait();

	// group1 initiates group2 when group1 gets low
	group1_enemies = getentarray( "group_1", "script_noteworthy" );
	ent = spawnstruct();
	ent.count = 0;
	array_thread( group1_enemies, ::group1_enemies_think, ent );
	
	level.debounce_triggers = [];
	run_thread_on_targetname( "leave_one", ::leave_one_think );
	run_thread_on_targetname( "heli_trigger", ::heli_trigger );
	run_thread_on_targetname( "block_path", ::block_path );
	run_thread_on_targetname( "debounce_trigger", ::debounce_think );
	run_thread_on_targetname( "set_go_line", ::set_go_line );
// 	run_thread_on_targetname( "flicker_light", ::flicker_light );
	run_thread_on_targetname( "enemy_door_trigger", ::enemy_door_trigger );
	
	run_thread_on_targetname( "grass_obj", ::grass_obj );
	
	level.kill_heli_last_warning_refresh_time = 0;
	level.kill_heli_index = 0;
	level.kill_heli_progression = 0;
	level.kill_heli_progression_triggers = [];
	level.kill_heli_progression_triggers[ 0 ] = 0;
	level.kill_heli_progression_warnings = [];
	level.kill_heli_progression_warnings[ 0 ] = 0;
	level.kill_heli_triggers = [];
	run_thread_on_targetname( "heat_progression", ::heat_progression_summons_kill_heli );
	run_thread_on_targetname( "uaz_placeholder", ::deleteme );
	run_thread_on_targetname( "deleteme", ::deleteme );
	run_thread_on_targetname( "bus_grenade_trigger", ::bus_grenade_think );
	run_thread_on_targetname( "fair_grenade_trigger", ::fair_grenade_trigger_think );
	run_thread_on_targetname( "script_animator", ::script_animator );
	run_thread_on_targetname( "merry_go_round_bottom", ::merry_go_round_bottom );
	run_thread_on_targetname( "merry_grass_delete", ::merry_grass_delete );
	run_thread_on_targetname( "final_heli_clip", ::final_heli_clip );
	
	
	run_thread_on_noteworthy( "patrol_guy", ::add_spawn_function, ::patrol_guy );
	run_thread_on_noteworthy( "chopper_guys", ::add_spawn_function, ::chopper_guys_land );
	run_thread_on_noteworthy( "chase_chopper_guys", ::add_spawn_function, ::chase_chopper_guys_land );
	run_thread_on_noteworthy( "house_chase_spawner", ::add_spawn_function, ::house_chase_spawner );
		
	thread handle_radiation_warning();
	
	
	keys = getarraykeys( level.heli_flag );
	array_levelthread( keys, ::helicopter_broadcast );

	create_price_dialogue_master();
	
	// the turret dvars dont exist onthe first frame
	wait( 0.05 );
	setsaveddvar( "turretScopeZoomMin", "1.5" );
	setsaveddvar( "turretScopeZoomMax", "70" );
	setsaveddvar( "turretScopeZoom", "70" );
	thread player_learns_to_zoom();
	// start angles 12.54 -99.17 0
	// start origin 812.33 -11689.9 973.87
	
	level.player allowstand( true );
}

music()
{
	level endon ( "music_fairgrounds_fade" );
	level endon ( "havoc_hits_ground" );
	level endon ( "rescue_music_start" );
	
	musicstop( 0.05 );
	wait( 0.2 );
// 	level endon( "price_is_safe_after_wounding" );

	for ( ;; )
	{
		/*
		if( firstplay )
		{
			MusicPlayWrapper( "sniperescape_run_music" ); 
			wait( 134 );
			musicStop( 2 );
			wait 2.5;
			firstplay = false;
		}
		*/
			
		MusicPlayWrapper( "sniperescape_secondary_run_music" );
		
		if( !flag( "fairbattle_detected" ) && flag( "heat_enemies_back_off" ) )
			wait 56;
		else
			wait 24;
			
		if( level.firstplay )
		{
			level.firstplay = false;
			musicStop( 3 );
			wait 3.5;
			MusicPlayWrapper( "sniperescape_secondary_run_music" );
			wait 24;
		}
		
		musicStop( 4 );
		wait 4.5;
				
		MusicPlayWrapper( "sniperescape_run_music" ); 
		wait( 134 );
		musicStop( 2 );
		wait 2.5;
	}
}

music_helicrash()
{
	flag_wait( "havoc_hits_ground" );
	
	wait 12;
	
	musicstop( 1 );
	
	flag_wait( "carry_me_music_resume" );
	
	wait 0.1;
	
	thread music();
}

music_fairgrounds()
{
	level endon ( "fairbattle_detected" );
	
	flag_wait( "music_fairgrounds_fade" );
	musicStop( 8 );
	wait 8.5;
	
	for ( ;; )
	{
		MusicPlayWrapper( "sniperescape_fairgrounds_music" );
		wait 101;
		musicstop( 1 );
		wait 1;
	}
}

music_fairground_battle()
{
	flag_wait( "fairbattle_detected" );
	
	wait 15;
	musicStop( 6 );
	wait 6.1;
	
	thread music();
}

music_rescue()
{
	flag_wait( "seaknight_flies_in" );
	
	wait 36;
	
	flag_set( "rescue_music_start" );
	
	musicStop( 6 );
	wait 6.5;
	
	MusicPlayWrapper( "sniperescape_rescue_music" );
}


priceInit()
{
	spawn_failed( self );
	self.provideCoveringFire = false;
	self thread magic_bullet_shield();
	self.baseaccuracy = 1000;
	self.moveplaybackrate = 1.21;
	self.ignoresuppression = true;
	self.animname = "price";
	self.IgnoreRandomBulletDamage = true;
	
	thread maps\_props::ghillie_leaves();
}

playerangles()
{
	for ( ;; )
	{
		println( level.player getplayerangles() );
		wait( 0.05 );
	}
}

vision_glow_change()
{
	flag_set( "stop_adjusting_vision" );
	// gotta do 2 vision sets to clear the glow
	set_vision_set( "sniperescape_glow_off", 5 );
	wait( 10 );
	set_vision_set( "sniperescape_outside", 5 );
}

snipe_vision_adjust()
{
	level endon( "stop_adjusting_vision" );
	if ( 1 )
		return;

	for ( ;; )
	{
		flag_wait( "near_window" );
		glow_change = 1.25;
		vision_change = 1.25;
		set_vision_set( "sniperescape_glow_off", glow_change );
		flag_waitopen_or_timeout( "near_window", glow_change );
		set_vision_set( "sniperescape_outside", vision_change );
		flag_waitopen_or_timeout( "near_window", vision_change );

		flag_waitopen( "near_window" );
		glow_change = 0.25;
		vision_change = 1.25;
		set_vision_set( "sniperescape_glow_off", glow_change );
		flag_wait_or_timeout( "near_window", glow_change );
		set_vision_set( "sniperescape", vision_change );
		flag_wait_or_timeout( "near_window", vision_change );
	}
}


snipe()
{
	objective_add( getobj( "zakhaev" ), "active", &"SNIPERESCAPE_ELIMINATE_IMRAN_ZAKHAEV", exchange_turret_org() );

	level.player setplayerangles( ( 9.8, -104, 0 ) );
	thread exchange_wind_flunctuates();
	
	thread exchange_heli();
	thread exchange_trace_converter();

	level.price thread price_watches();
	thread price_talks();
	thread snipe_vision_adjust();
	thread player_gets_on_barret();
	run_thread_on_targetname( "flag_org", ::exchange_flag );
	run_thread_on_targetname( "uaz_clip_brush", ::exchange_vehicle_clip );
	
	thread barrett_intro();

	thread exchange_claymore();
	thread exchange_uaz();
	thread exchange_turret();
	thread exchange_barrett_trigger();
	thread exchange_vehicles_flee_conflict();
	thread exchange_dof();
	thread exchange_uaz_that_backs_up();
	thread exchange_wind_flag();
	thread exchange_wind_generator();
	thread exchange_mission_failure();
	
	flag_set( "aa_snipe" );
	
	run_thread_on_noteworthy( "leaning_smoker", ::add_spawn_function, ::lean_and_smoke );
	run_thread_on_noteworthy( "standing_smoker", ::add_spawn_function, ::stand_and_smoke );

	exchange_riders = getentarray( "exchange_rider", "targetname" );
	array_thread( exchange_riders, ::add_spawn_function, ::set_ignoreall, true );
	array_thread( exchange_riders, ::add_spawn_function, ::exchange_baddie_main_think );

	exchange_guards = getentarray( "exchange_guard", "targetname" );
	array_thread( exchange_guards, ::add_spawn_function, ::set_ignoreall, true );
	array_thread( exchange_guards, ::add_spawn_function, ::exchange_baddie_main_think );
	array_thread( exchange_guards, ::add_spawn_function, ::exchange_bored_idle );
	array_thread( exchange_guards, ::spawn_ai );

	exchange_baddies = getentarray( "exchange_baddy", "targetname" );
	array_thread( exchange_baddies, ::add_spawn_function, ::set_ignoreall, true );
	array_thread( exchange_baddies, ::add_spawn_function, ::exchange_baddie_main_think );
	baddies = array_spawn( exchange_baddies );
	

	level.exchanger_surprise_time = 0.5;
	guard = baddies[ 0 ];
	dealer = baddies[ 1 ];
	
	guard.animname = "guard";
	dealer.animname = "dealer";
	guard.main_baddie = true;
	dealer.main_baddie = true;
	node = getent( "exchange_org", "targetname" );

//	node anim_teleport( baddies, "exchange" );
	node thread anim_loop( baddies, "exchange_idle" );
//	array_thread( baddies, ::stay_put );

	
	exchange_zak_and_guards_jab_it_up( node, baddies );
	
	
	// in case we were cut off during the idle
	node notify( "stop_loop" );
	
	level.price allowedstances( "prone", "crouch", "stand" );
	flag_wait_either( "player_attacks_exchange", "zakhaev_escaped" );

	musicStop( 3 );

	wait( 0.25 ); 
	
	price_clears_dialogue();
	
	if ( !flag( "exchange_success" ) )
	{
		// some line about missing
		flag_wait( "exchange_success" );
	}

	/*
	// done in the bullet hit logic
	// Damn, my line of sight was blocked. Did you take him out? I thought I saw his arm fly off! Can you see him?
//	price_line( "did_you_take_him_out" );
	line = "target_down_" + randomint( 3 ) + 1;
	// Target down. I think I saw his arm fly off. Nice work Leftenant. We got him.					target_down_1
	// Target down. I think you blew off his arm. Shock and blood loss'll take care of the rest.	target_down_2	
	// Target is down! Nice shot Leftenant. 														target_down_3
	price_line( line );
	*/

	objective_complete( getobj( "zakhaev" ) );
	
	wait( 2 );
	
	if ( !flag( "heli_destroyed" ) )
	{
		//* Shit... they’re on to us! Take out that helicopter, it’ll buy us some time!
		price_line( "take_out_that_heli" );
	
		objective_add( getobj( "heli" ), "active", &"SNIPERESCAPE_TAKE_OUT_THE_ATTACK_CHOPPER", exchange_turret_org() );
		flag_wait( "heli_destroyed" );
		objective_complete( getobj( "heli" ) );
	}
	
	thread exchange_heli_second_wave();

	objective_add( getobj( "hotel" ), "active", &"SNIPERESCAPE_GET_OUT_OF_THE_HOTEL", rappel_obj_org() );

	//* Great shot Leftenant! Now let's go! They'll be searching for us!
	price_line( "great_shot_now_go" );
	
	thread music();
	thread music_helicrash();
	thread music_fairgrounds();
	thread music_fairground_battle();
	thread music_rescue();

	wait( 2.5 );
	flag_set( "player_gets_off_turret" );

	thread rappel_out_of_hotel();
}

exchange_uaz()
{
	guard_uazs = getentarray( "base_uaz", "targetname" );
	array_thread( guard_uazs, ::exchange_uaz_preps_for_escape );

	uazs = spawn_vehicles_from_targetname( "uaz" );
	array_thread( uazs, ::exchange_uaz_preps_for_escape );
	
	uaz = get_ent_with_key_from_array( uazs, "zaks_ride", "script_noteworthy" );
	jeep_window = getent( "jeep_window", "targetname" );
	jeep_window linkto( uaz, "body_animate_jnt", (-75,00,54), (0,0,0) );
	wait( 2 );

	flag_wait( "player_on_barret" );	

	array_levelthread( uazs, ::gopath );
	flag_wait( "zak_arrives" );
//	uaz waittill( "reached_end_node" );

	wait( 2 );
	flag_set( "exchange_uazs_arrive" );
}

price_watches( firstframe )
{
	self.animname = "price";
	binocs = spawn( "script_model", (0,0,0) );
	binocs setmodel( level.scr_model[ "binocs" ] );
	binocs linkto( self, "TAG_INHAND", (0,0,0), (0,0,0) );
	level.binocs = binocs;
	
	targ = getent( self.target, "targetname" );
	targ anim_single_solo( self, "spotter_wave" );
	targ thread anim_loop_solo( self, "spotter_idle" );
}

price_talks()
{
	level endon( "player_attacks_exchange" );
	//	Leftenant Price, the meeting is underway. Enemy transport sighted entering the target area.
	price_line( "transport_sighted" );

	
	flag_wait( "player_on_barret" );	
	MusicPlayWrapper( "sniperescape_exchange_music" ); 
		
	wait( 1.25 );
	// Now get on the Barrett rifle and wait for my signal. Do not engage until I give the word.
	// the wind's gettin a bit choppy, you can compensate for it..
	thread price_line( "get_on_barrett" );

	// Remember what I've taught you. Keep in mind variable humidity and wind speed along the bullet's flight path. At this distance you’ll also have to take the Coriolis effect into account.
	price_line( "remember_my_teaching" );

	/*
	// Prepare for ranging. Standby.
	price_line( "prepare_for_ranging" );

	// White truck on the left, range, 1203.5 meters.
	price_line( "white_truck" );

	// Range to BMP, 1207 meters.
	price_line( "range_to_bmp" );

	// The table with the briefcase, range, 1206 meters.
	price_line( "table_with_case" );
	*/

	//flag_wait( "exchange_uazs_arrive" );
	flag_wait( "zak_is_seen" );
	
	flag_set( "launch_zak" );

	level.wind_setting = "middle";

	delaythread( 25.8, ::flag_set, "block_heli_starts" );
	wait( 5.6 );
	// Ok... I think I see him. Wait for my mark.
	price_line( "i_see_him" );

	// Target...acquired. I have a positive I.D. on Imran Zakhaev.
	thread price_line( "target_acquired" );
	// Wait - the wind's picked up. Let it die down before you take the shot. Don’t rush it.
	// steady, keep an eye on that flag
	thread price_line( "wind_picked_up" );

	flag_wait( "block_heli_arrives" );
	level.helitimer = gettime();

	wait( 1.2 );
	// Ach, where did he come from? Patience laddie... Wait for a clear shot….
	thread price_line( "where_did_he_come_from" );

	flag_wait( "block_heli_moves" );


	wait( 13 );
	
	// player can take the shot early if he's paying attention to the wind
	level.wind_setting = "start";
	wait( 3 );
	
	level notify( "wind_stops_flunctuating" );
	level.wind_vel = 0;
	// Ok take the shot.
	level.wind_setting = "end";
	
	
	wait( 5 );

	// It's now or never, take the shot!		
	price_line( "now_or_never" ); // "take_the_shot"
	musicstop( 3 );
}

barline()
{
	for( ;; )
	{
//		Line( self gettagorigin( "tag_origin" ), level.player.origin, (1,1,0) );
		Line( self.origin, level.player.origin, (1,1,0) );
		wait( 0.05 );
	}
}

setup_rappel()
{
	rappel_trigger = getent( "rappel_trigger", "targetname" );
	rappel_trigger trigger_off();
	
	rope = spawn_anim_model( "rope" );
	level.rope = rope;
// 	level.rope hide();
	node = getnode( "price_rappel_node", "targetname" );
	node thread anim_first_frame_solo( rope, "rappel_start" );
	
	bullet_block = getent( "bullet_block", "targetname" );
	bullet_block delete();

	
	// It's time to move.	
	org = getent( level.price.target, "targetname" );
	org notify( "stop_loop" );
	level.price stopanimscripted();
//	level.price anim_single_queue( level.price, "time_to_move" );

	flag_clear( "aa_snipe" );
	org anim_single_solo( level.price, "spotter_exit" );
	
	if ( isdefined( level.binocs ) )
		level.binocs delete();
	

// 	level.rope thread maps\_debug::drawTagForever( "RopeSnap_RI" );
}

player_rappel()
{

	
	// the rappel sequence is relative to this node
	player_node = getnode( "player_rappel_node", "targetname" );

	rope = spawn_anim_model( "player_rope" );
	player_node thread anim_first_frame_solo( rope, "rappel_for_player" );

	rope_glow = spawn_anim_model( "player_rope_obj" );
	player_node thread anim_first_frame_solo( rope_glow, "rappel_for_player" );
	rope_glow hide();

	// this is the model the player will attach to for the rappel sequence
	model = spawn_anim_model( "player_rappel" );
	model hide();
	
	// put the model in the first frame so the tags are in the right place
	player_node anim_first_frame_solo( model, "rappel" );

	// this is sniperescape specific stuff for the helicopter that attacks and the explosion that goes off
//	thread heli_attacks_start();

//	flag_wait( "player_can_rappel" );

	rappel_trigger = getent( "rappel_trigger", "targetname" );
	rappel_trigger trigger_on();


	rappel_trigger.origin = ( 481.4, -10823.2, 1068.9 );
	rappel_trigger sethintstring( &"SNIPERESCAPE_HOLD_1_TO_RAPPEL" );
	
	rope_glow show();

	rappel_trigger waittill( "trigger" );	
	rappel_trigger delete();
	
	thread vision_glow_change();
	
	rope_glow hide();
	flag_set( "player_rappels" );
	level.rappel_buffer = gettime();
	level.timer = gettime();
	
	level.player thread take_weapons();
	
	//1.7
	delayThread( 1.2, ::flag_set, "apartment_explosion" );

	// this smoothly hooks the player up to the animating tag
	model lerp_player_view_to_tag( "tag_player", 0.5, 0.9, 5, 5, 45, 0 );

	// now animate the tag and then unlink the player when the animation ends
	player_node thread anim_single_solo( model, "rappel" );
	player_node thread anim_single_solo( rope, "rappel_for_player" );
	player_node waittill( "rappel" );
	level.player unlink();
	model delete();
	flag_set( "can_save" );
	objective_complete( getobj( "hotel" ) );
	
	level.player give_back_weapons();
	//thread music();
	delaythread( 1.5, ::flag_set, "heli_moves_on" );
}

rappel_out_of_hotel()
{
	wait( 0.05 );
	thread setup_rappel();

//	ai = getaispeciesarray( "axis", "all" );
//	array_thread( ai, ::delete_living );

	thread player_rappel();
	price_node = getnode( "price_rappel_node", "targetname" );
	price_node thread anim_reach_solo( level.price, "rappel_start" );
	
	// birds fly up
	delayThread( 2, ::exploder, 6 );
	
	flag_set( "player_can_rappel" );
	
	guys = [];
	guys[ guys.size ] = level.price;
	guys[ guys.size ] = level.rope;

	if ( !flag( "player_rappels" ) )
	{
		price_climbs_until_player_rappels( guys, price_node );
	}
	if ( !flag( "price_starts_rappel" ) )
	{
		level.price_anim_start_time = gettime();
		price_node thread anim_single( guys, "rappel_start" );
	}
	wait( 0.05 );

	buffer_time = 1;
	if ( !isdefined( level.rappel_buffer ) )
	{
		wait( buffer_time );
	}
	else
	{
		wait_for_buffer_time_to_pass( level.rappel_buffer, buffer_time );
	}


	animlength = getanimlength( level.price getanim( "rappel_start" ) );
	current_time = gettime() - level.price_anim_start_time;
	current_progress = ( current_time * 0.001 ) / animlength;
	progress = 0.51;
	if ( current_progress < progress )
	{	
		// jump to the end of the anim
		level.price anim_self_set_time( "rappel_start", progress );
		level.rope anim_self_set_time( "rappel_start", progress );
	}
	level.price waittillend( "single anim" );
		
	price_node thread anim_single( guys, "rappel_end" );
	wait( 4 );
	setsaveddvar( "phys_bulletspinscale", "3" ); // back to default
	level.price set_force_color( "r" );
	thread battle_through_heat_area();
}

price_climbs_until_player_rappels( guys, price_node )
{
	level endon( "player_rappels" );

	level.price waittill( "goal" );

	thread apartment_explosion();
	flag_set( "price_starts_rappel" );
	level.price_anim_start_time = gettime();
	price_node anim_single( guys, "rappel_start" );
	
	if ( !flag( "player_rappels" ) )
	{
		price_node thread anim_loop( guys, "rappel_idle", undefined, "stop_idle" );
		flag_wait( "player_rappels" );
		price_node notify( "stop_idle" );
	}
	
	arcademode_checkpoint( 5, "a" );
	
	price_node thread anim_single( guys, "rappel_end" );
}

apartment_explosion()
{
// temporarily disable this for show
	// blow up the apartment if the player doesn't rappel soon enough
// 	explosion_death_trigger
	
	wait( 4.0 );
	flag_set( "apartment_explosion" );
	/*
	flag_wait_or_timeout( "apartment_explosion" , 8 );

	// blow up the top floor
	blow_up_hotel();
	*/
}

start_run()
{
	thread music();
	thread vision_glow_change();
	ai = getaispeciesarray( "axis", "all" );
	array_thread( ai, ::delete_living );
	node = getnode( "tele_node", "targetname" );
	org = getent( "tele_org", "targetname" );
	
	level.player setplayerangles( ( 0, 0, 0 ) );
	level.player setorigin( org.origin + ( 0, 0, -34341 ) );
	level.price teleport( node.origin );
	plant_price();
	level.player setorigin( org.origin );
	
	thread battle_through_heat_area();
}

battle_through_heat_area()
{
	// kill heli comes and gets you if you take too long in one zone
	thread kill_heli_logic();

	level.price.dontshootwhilemoving = true;
	level.move_in_trigger_used = [];
	run_thread_on_targetname( "move_in_trigger", ::move_in );
// 	level.price thread price_calls_out_kills();
	thread heat_helis_transport_guys_in();

	weapons_dealers = getentarray( "weapons_dealer", "targetname" );
	array_thread( weapons_dealers, ::delete_living );

	// change enemy accuracy on the fly so we can fight tons of guys without it being lame
	thread enemy_accuracy_assignment();

	east_spawners = getentarray( "east_spawner", "targetname" );
	thread heat_spawners_attack( east_spawners, "start_heat_spawners", "stop_heat_spawners" );

	west_spawners = getentarray( "west_spawner", "targetname" );
	thread heat_spawners_attack( west_spawners, "start_heat_spawners", "stop_heat_spawners" );

	wait( 1 );
	flag_set( "aa_heat" );

	// Leftenant Price, follow me!	
	level.price anim_single_queue( level.price, "follow_me" );

	objective_add( getobj( "heat" ), "active", &"SNIPERESCAPE_REACH_THE_EXTRACTION", extraction_point() );
	objective_current( getobj( "heat" ) );
	thread modify_objective_destination_babystep( getobj( "heat" ) );

	level.timer = gettime();
	// Delta Two Four, this is Alpha Six! We have been compromised, I repeat we have been compromised, now heading to Extraction Point four!	
	delayThread( 1, ::price_line, "compromised" );

	// Alpha Six, Seaknight Five - Niner is en route, E.T.A. - 20 minutes. Don't be late. We're stretchin' our fuel as it is. Out.	
	delayThread( 3, ::price_line, "eta_20_min" );
	delayThread( 9.35, ::autosave_by_name, "eta_20_min" );
	delayThread( 5.5, ::countdown, 20 );

	thread price_runs_for_woods_on_contact();

// 	thread player_hit_debug();
	
	flag_wait( "start_heat_spawners" );
//	autosave_or_timeout( "heat_begins", 2.5 );
	
	// temporary work around for - onlyents bug
	spawn_vehicle_from_targetname_and_drive( "introchopper1" );

	flag_wait( "heat_enemies_back_off" );
	// _colors is waiting for this script to hit, so we have to wait for that to happen so that
	// the orange and yellow colors get set
	waittillframeend;
	
	activate_trigger_with_targetname( "price_heads_for_apartment" );
	assertex( level.price.script_forcecolor == "b", "Price's color was wrong" );	
//	level.price set_force_color( "o" );

	thread defend_heat_area_until_enemies_leave();	

//	assertex( level.price.script_forcecolor == "o", "Price's color was wrong" );	
	level.price set_force_color( "y" );
	
	thread the_apartment();
}

price_runs_for_woods_on_contact()
{
//	level waittill( "price_sees_enemy" );
	flag_wait( "start_heat_spawners" );

	level.price set_force_color( "b" );
	level.price.dontshootwhilemoving = undefined;

	// Enemy contact up ahead. Let's cut through the woods.	
//	level.price anim_single_queue( level.price, "cut_through_woods" );
//	wait( 8 );
	flag_set( "price_cuts_to_woods" );

}

start_apartment()
{
	thread music();
	thread vision_glow_change();
	thread countdown( 18 );
	objective_add( getobj( "heat" ), "active", &"SNIPERESCAPE_FOLLOW_CPT_MACMILLAN", extraction_point() );
	objective_current( getobj( "heat" ) );

	ai = getaispeciesarray( "axis", "all" );
	array_thread( ai, ::delete_living );
	price_org = getent( "price_apartment_org", "targetname" );
	player_org = getent( "player_apartment_org", "targetname" );
	
	level.player setplayerangles( ( 0, 0, 0 ) );
	level.player setorigin( player_org.origin + ( 0, 0, -34341 ) );
	level.price teleport( price_org.origin );
	plant_price();
	level.player setorigin( player_org.origin );
	level.price set_force_color( "y" );
	thread the_apartment();
}

the_apartment()
{
	thread set_min_time_remaining( 8 );
	flag_set( "break_for_apartment" );
	flag_clear( "aa_heat" );
	thread apartment_price_waits_for_dog_death();
	
//	price_fights_until_enemies_leave();
	
	level notify( "stop_adjusting_enemy_accuracy" );
	// We'll lose 'em in that apartment! Come on!	
	level.price thread anim_single_queue( level.price, "lose_them_in_apartment" );
//	create_apartment_badplace();	

	spin_trigger = getent( "price_explore_trigger", "targetname" );
	spin_trigger waittill( "trigger" );
	spin_ent = getent( spin_trigger.target, "targetname" );
	autosave_by_name( "into_the_apartment" );
// 	MusicPlayWrapper( "bog_a_shantytown" ); 

	arcademode_checkpoint( 4, "b" );

	flag_set( "price_opens_door" );
	thread player_touches_wounded_blocker();
	activate_trigger_with_targetname( "price_opens_door" );

	spin_ent anim_reach_solo( level.price, "spin" );
	length = getanimlength( level.price getanim( "spin" ) );
	length = length * 0.87;
	spin_ent thread anim_single_solo( level.price, "spin" );
	wait( length );
	level.price stopanimscripted();

	slow_door_org = getent( "slow_door_org", "targetname" );
	slow_door_org anim_reach_and_approach_solo( level.price, "smooth_door_open" );

	door = getent( "slow_door", "targetname" );
	door thread palm_style_door_open();
	slow_door_org anim_single_solo( level.price, "smooth_door_open" );
	level.price set_force_color( "y" );

	flag_wait( "fence_dog_attacks" );
	level.price clearenemy();
	
	thread dog_attacks_fence();

	thread the_wounding();
}

start_wounding()
{
	thread music();
// 	thread heli_attacks_price();
	thread vision_glow_change();
//	create_apartment_badplace();
	objective_add( getobj( "heat" ), "active", &"SNIPERESCAPE_FOLLOW_CPT_MACMILLAN", extraction_point() );
	objective_current( getobj( "heat" ) );
	thread countdown( 16 );

	ai = getaispeciesarray( "axis", "all" );
	array_thread( ai, ::delete_living );
	price_org = getent( "price_apart_org", "targetname" );
	player_org = getent( "player_apart_org", "targetname" );
	
	level.player setplayerangles( player_org.angles );
	level.player setorigin( player_org.origin + ( 0, 0, -34341 ) );
	level.price teleport( price_org.origin );
	plant_price();
	level.player setorigin( player_org.origin );
	level.price setgoalpos( level.price.origin );
	level.price enable_cqbwalk();
	level.price set_force_color( "y" );
	thread the_wounding();
	thread player_touches_wounded_blocker();
}

start_crash()
{
	thread music();
// 	thread heli_attacks_price();
	thread vision_glow_change();
//	create_apartment_badplace();
	objective_add( getobj( "heat" ), "active", &"SNIPERESCAPE_FOLLOW_CPT_MACMILLAN", extraction_point() );
	objective_current( getobj( "heat" ) );
	thread countdown( 16 );

	ai = getaispeciesarray( "axis", "all" );
	array_thread( ai, ::delete_living );
	price_org = getent( "price_apart_org", "targetname" );
	player_org = getent( "player_wounding_org", "targetname" );
	
	level.player setplayerangles( player_org.angles );
	level.player setorigin( player_org.origin + ( 0, 0, -34341 ) );
	level.price teleport( price_org.origin );
	node = getnode( "price_wounding_node", "targetname" );
	node anim_teleport_solo( level.price, "crash" );
	
	plant_price();
	level.player setorigin( player_org.origin );
	level.price setgoalpos( level.price.origin );
	level.price enable_cqbwalk();
	level.price set_force_color( "y" );
//	thread the_wounding();
	thread player_touches_wounded_blocker();
	thread heli_attacks_price_new();
	
	wait( 1 );
	array_thread( level.deathflags[ "surprise_guys_dead" ][ "ai" ], ::self_delete );
	array_thread( level.deathflags[ "surprise_guys_dead" ][ "spawners" ], ::self_delete );
	flag_set( "surprise_guys_dead" );
	flag_set( "patrol_guys_dead" );
	level waittill( "start_continues" );
	flag_set( "heli_shot_down" );
}

the_wounding()
{
	thread set_min_time_remaining( 7 );
	flag_set( "price_calls_out_kills" );
	flag_wait( "price_signals_holdup" );
	
	if ( !player_is_enemy() && !flag( "wounding_enemy_detected" ) )
	{
		price_goes_to_window_to_shoot();
		level.price.ignoreme = false;
	}

	level.price pushplayer( true );
	level.price enable_ai_color();
	activate_trigger_with_targetname( "price_moves_to_window_trigger" );
	
	level.price.ignoreall = false;
	delete_wounding_sight_blocker();
	wait( 2.5 );

	
// 	flag_wait( "plant_claymore" );
// 	flag_clear( "plant_claymore" );

	// Quickly - plant claymores if they come this way!	
// 	level.price thread anim_single_queue( level.price, "place_claymore" );
	
//	flag_wait( "player_moves_through_apartment" );

//	thread price_wounding_kill_trigger();
	

	/*
	wait( 0.2 );	
	level.price.disableexits = false;

// 	level.price.maxVisibleDist = 32;
// 	level.player.maxVisibleDist = 32;
	
	price_waits_for_enemies_to_walk_past();	
	level.price.maxvisibledist = 200;
	*/
// 	delaythread( 4.0, ::activate_trigger_with_targetname, "surprise_trigger" );	
	flag_wait_either( "patrol_guys_dead", "player_touches_wounding_clip" );
//	flag_wait( "player_touches_wounding_clip" );
	
//	node = getnode( "price_heli_fight_node", "targetname" );
	
	level.price disable_ai_color();
	level.price.fixedNodeSafeRadius = 32;
	level.price.fixednode = true;
	level.price.goalradius = 32;

	node = getnode( "price_wounding_node", "targetname" );
	node thread anim_reach_solo( level.price, "crash" );
//	thread price_sets_stance();	
	
	flag_wait( "player_touches_wounding_clip" );
	surprisers = getentarray( "surprise_spawner", "targetname" );
	array_thread( surprisers, ::spawn_ai );
	// More behind us!	
	level.price delaythread( 2, ::anim_single_queue, level.price, "more_behind" );

	level.price waittill( "goal" );
	level.price.maxvisibledist = 8000;
	
//	flag_wait( "player_touches_wounding_clip" );
//	waittill_noteworthy_dies( "patrol_guy" );
//	node = getnode( "price_apartment_destination_node", "targetname" );
//	level.price.fixedNodeSafeRadius = node.fixedNodeSafeRadius;
//	level.price setgoalnode( node );
	
	/* 
	// now done via trigger
	door_left = getent( "wounding_door_left", "targetname" );
	door_right = getent( "wounding_door_right", "targetname" );
	door_left thread door_opens();
	door_right thread door_opens( - 1 );
	*/ 
	
// 	flag_wait( "price_walks_into_trap" );
	thread heli_attacks_price_new();
}
	
heli_attacks_price()
{
	node = getnode( "price_apartment_destination_node", "targetname" );

	heli = spawn_vehicle_from_targetname_and_drive( "heli_price" );
	level.price_heli = heli;
	heli thread helipath( heli.target, 70, 70 );
	wait( 1 );
	
	level.price endon( "death" );
	// More behind us!	
	level.price thread anim_single_queue( level.price, "more_behind" );

	node anim_reach_solo( level.price, "wounded_begins" );
	
	flag_wait( "price_heli_in_position" );

	node anim_reach_solo( level.price, "wounded_begins" );
	
// 	heli thread kills_enemies_then_wounds_price_then_leaves();
	delaythread( 5.5, ::flag_set, "price_heli_moves_on" );
	target = getent( "wounding_target", "targetname" );
	heli delaythread( 6.5, ::heli_shoots_rockets_at_ent, target );
	delaythread( 7.2, ::exploder, 500 );

	// Chopper!!! Get back! I'll cover you!	sniperescape_mcm_choppergetback
	node anim_single_solo( level.price, "wounded_begins" );
	
	thread wounded_combat();
}

price_waits_for_enemies_to_walk_past()
{
	if ( flag( "enemies_walked_past" ) )
		return;
 	if ( flag( "wounding_sight_blocker_deleted" ) )
 		return;
 		
	level endon( "wounding_sight_blocker_deleted" );
	flag_wait( "price_says_wait" );

	autosave_by_name( "standby" );	

	flag_wait( "walked_past_price" );

	// Now!	
	level.price thread anim_single_queue( level.price, "now" );
}

start_wounded()
{
	thread music();
	thread vision_glow_change();
//	create_apartment_badplace();
	objective_add( getobj( "heat" ), "active", &"SNIPERESCAPE_FOLLOW_CPT_MACMILLAN", extraction_point() );
	objective_current( getobj( "heat" ) );
	wounding_sight_blocker = getent( "wounding_sight_blocker", "targetname" );
	wounding_sight_blocker connectpaths();
	wounding_sight_blocker delete();

	thread countdown( 13 );

	ai = getaispeciesarray( "axis", "all" );
	array_thread( ai, ::delete_living );
	price_org = getnode( "price_apartment_destination_node", "targetname" );
	player_org = getent( "player_post_wound_org", "targetname" );
	
	level.player setplayerangles( player_org.angles );
	level.player setorigin( player_org.origin + ( 0, 0, -34341 ) );
	level.price teleport( price_org.origin );
	plant_price();
	level.player setorigin( player_org.origin );
	level.price disable_ai_color();
	
	thread wounded_combat();
}

wounded_combat()
{
	level.price endon( "death" );
	// dont like this guy anymore
	maps\_spawner::kill_spawnerNum( 10 );
	
	run_thread_on_noteworthy( "flee_guy", ::add_spawn_function, ::flee_guy_runs );
	run_thread_on_noteworthy( "force_patrol", ::add_spawn_function, ::force_patrol_think );
	


//	delete_apartment_badplace();
	add_global_spawn_function( "axis", ::on_the_run_enemies );

	run_thread_on_targetname( "wounded_combat_trigger", ::wounded_combat_trigger );

	thread second_apartment_line();
	

	flag_set( "price_is_safe_after_wounding" );
	autosave_by_name( "carry_price" );	
// 	musicStop();

	kill_all_enemies();

	// (coughing) Damn! My leg's all messed up, I can't move! (coughing)		
	thread price_line( "cant_move_3" );

	objective_string( getobj( "wounded" ), &"SNIPERESCAPE_PICK_UP_CPT_MACMILLAN" );
	objective_position( getobj( "wounded" ), level.price.origin );
	// price is hit so he is no longer the objective
	level notify( "stop_updating_objective" );
// 	delaythread( 5, ::activate_trigger_with_targetname, "surprise_trigger" );	
	
// 	zones = getentarray( "zone", "targetname" );
// 	array_thread( zones, ::enemy_spawn_zone );
	thread escort_to_park();
}

escort_to_park()
{
	thread set_min_time_remaining( 5 );
	thread price_wounded_logic();

	thread price_followup_line();

	// The extraction point is to the southwest. We can still make it if we hurry.	
	thread do_in_order( ::flag_wait, "price_picked_up", ::price_line, "extraction_is_southwest" );
	
	flag_wait( "price_picked_up" );
	arcademode_checkpoint( 10, "c" );


	flag_set( "aa_wounded" );
	thread do_in_order( ::flag_wait, "enter_burnt", ::flag_clear, "aa_wounded" );

	objective_string( getobj( "wounded" ), &"SNIPERESCAPE_CARRY_MACMILLAN_TO_THE" );
	set_objective_pos_to_extraction_point( getobj( "wounded" ) );

	
	thread enemy_zone_spawner();

	flag_wait( "enter_burnt" );
	autosave_by_name( "entered_burnt" );
	thread enter_burnt_apartment();
}

start_burnt()
{
	thread music();
	flag_set( "first_pickup" );
	add_global_spawn_function( "axis", ::on_the_run_enemies );
	thread vision_glow_change();
	objective_add( getobj( "wounded" ), "active", &"SNIPERESCAPE_DRAG_MACMILLAN_BODILY", extraction_point() );
	objective_current( getobj( "wounded" ) );
	set_objective_pos_to_extraction_point( getobj( "wounded" ) );
	wounding_sight_blocker = getent( "wounding_sight_blocker", "targetname" );
	wounding_sight_blocker connectpaths();
	wounding_sight_blocker delete();

	thread countdown( 6 );

	ai = getaispeciesarray( "axis", "all" );
	array_thread( ai, ::delete_living );
	player_org = getent( "player_burnt_org", "targetname" );
	price_org = getent( "price_burnt_org", "targetname" );
	
	level.player setorigin( player_org.origin + ( 0, 0, -5150 ) );
	level.price teleport( price_org.origin );
	plant_price();
	level.player setplayerangles( player_org.angles );
	level.player setorigin( player_org.origin );
	
	wait( 0.05 );// magic bullet shield lameness
	thread price_wounded_logic();
	thread enter_burnt_apartment();
}

enter_burnt_apartment()
{
	thread burnt_blocker();

// 	thread apartment_hunters();
// 	thread more_plant_claymores();
// 	thread burnt_spawners();
	thread spooky_sighting();
	thread spooky_dog();

	thread do_in_order( ::flag_wait, "spawn_spooky_dog", ::flag_set, "aa_burnt_apartment" );
	thread do_in_order( ::flag_wait, "apartment_cleared", ::flag_clear, "aa_burnt_apartment" );

	setdvar( "player_sees_pool_dogs", "" );
	
	run_thread_on_noteworthy( "apartment_guard", ::add_spawn_function, ::set_fixednode_true );
	run_thread_on_noteworthy( "apartment_guard", ::add_spawn_function, ::set_baseaccuracy, 100 );

	thread do_in_order( ::flag_wait, "enter_burnt", ::clear_dvar, "player_hasnt_been_spooked" );
	thread player_navigates_burnt_apartment();
	
	/* 
	assert( level.flag[ "to_the_pool" ] );
	ai = getaiarray( "axis", "all" );
	array_thread( ai, ::deleteme );
	*/ 
	thread pool();
	
	trigger = getent( "level_end", "targetname" );
	trigger.origin += ( 0, 150, 0 );
// 	wait_for_targetname_trigger( "level_end" );
// 	iprintlnbold( "End of current level" );
// 	wait( 2 );
// 	missionsuccess( "icbm", false );
	
	thread fairgrounds_before_battle();
}

start_pool()
{
	thread music();
	flag_set( "first_pickup" );
	thread vision_glow_change();
	objective_add( getobj( "wounded" ), "active", &"SNIPERESCAPE_DRAG_MACMILLAN_BODILY", extraction_point() );
	objective_current( getobj( "wounded" ) );
	set_objective_pos_to_extraction_point( getobj( "wounded" ) );
	wounding_sight_blocker = getent( "wounding_sight_blocker", "targetname" );
	wounding_sight_blocker connectpaths();
	wounding_sight_blocker delete();

	thread countdown( 8 );

	ai = getaispeciesarray( "axis", "all" );
	array_thread( ai, ::delete_living );
	player_org = getent( "player_pool_org", "targetname" );
	price_org = getent( "price_pool_org", "targetname" );
	
	level.player setorigin( player_org.origin + ( 0, 0, -5150 ) );
	level.price teleport( price_org.origin );
	plant_price();
	level.player setplayerangles( player_org.angles );
	level.player setorigin( player_org.origin );
	
	setdvar( "player_sees_pool_dogs", "" );
	wait( 0.05 );// magic bullet shield lameness
	flag_set( "to_the_pool" );
	thread price_wounded_logic();
	thread fairgrounds_before_battle();
	thread pool();
}

pool()
{
	thread set_min_time_remaining( 4 );
	flag_wait( "to_the_pool" );
	flag_set( "price_calls_out_enemy_location" );
	
	arcademode_checkpoint( 20, "d" );

	thread do_in_order( ::flag_wait, "pool_lookat", ::flag_set, "player_looked_in_pool" );
	
	oldmaxdist = level.player.maxvisibledist;
	level.player.maxvisibledist = 168;
	
	autosave_by_name( "to_the_pool" );
	
	// We're almost there. The extraction point is on the other side of that building.	
	thread price_line( "almost_there" );
	
	flag_set( "music_fairgrounds_fade" );
	
	thread pool_have_body();

	flag_init( "pool_dogs_flee" );
	
	// if you're coming from a checkpoint, the dogs flee
	if ( getdvar( "player_sees_pool_dogs" ) == "" )
	{
		setdvar( "player_sees_pool_dogs", "1" );
	}
	else
	{
		flag_set( "pool_dogs_flee" );
	}

	if ( !flag( "fairbattle_high_intensity" ) )
	{
		dogs = get_guys_with_targetname_from_spawner( "eating_dog" );
		array_thread( dogs, ::pool_dog_think );
	}
	
	flag_wait( "player_enters_fairgrounds" );
	level.player.maxvisibledist = oldmaxdist;
		
	/* 
	flag_wait( "pool_heli_attacks" );
	wait( 1.2 );

	pool_heli = spawn_vehicle_from_targetname_and_drive( "pool_heli" );
	pool_heli setturningability( 1 );
	
	flag_wait( "pool_heli_in_position" );
	wait( 1.5 );
	heli_target = getent( "pool_heli_target_1", "targetname" );
	pool_heli shoot_at_entity_chain( heli_target );

	flag_set( "pool_heli_tries_another_angle" );
	flag_wait( "pool_heli_in_second_position" );
	wait( 1 );

	heli_target = getent( "pool_heli_target_2", "targetname" );
	pool_heli shoot_at_entity_chain( heli_target );

	flag_set( "pool_heli_leaves" );
	wait( 2 );
	if ( !flag( "player_enters_fairgrounds" ) )
	{
// 		iprintlnbold( " < MacMillan > I think it's leaving, let's make a run for it" );
	}
	*/ 
}

start_fair()
{
	thread music();
	flag_set( "first_pickup" );
	thread vision_glow_change();
	objective_add( getobj( "wounded" ), "active", &"SNIPERESCAPE_DRAG_MACMILLAN_BODILY", extraction_point() );
	objective_current( getobj( "wounded" ) );
	set_objective_pos_to_extraction_point( getobj( "wounded" ) );
	wounding_sight_blocker = getent( "wounding_sight_blocker", "targetname" );
	wounding_sight_blocker connectpaths();
	wounding_sight_blocker delete();

	thread countdown( 20 );

	ai = getaispeciesarray( "axis", "all" );
	array_thread( ai, ::delete_living );
	player_org = getent( "player_fair_org", "targetname" );
	price_org = getent( "price_fair_org", "targetname" );
	
	level.player setorigin( player_org.origin + ( 0, 0, -5150 ) );
	level.price teleport( price_org.origin );
	plant_price();
	level.player setplayerangles( player_org.angles );
	level.player setorigin( player_org.origin );
	
	wait( 0.05 );// magic bullet shield lameness
	thread price_wounded_logic();
	flag_wait( "price_picked_up" );
	thread fairgrounds_before_battle();
	flag_set( "player_enters_fairgrounds" );
	flag_set( "to_the_pool" );
	flag_set( "fair_snipers_died" );
}

start_fair_battle()
{
	thread music();
	flag_set( "first_pickup" );
	thread vision_glow_change();
	objective_add( getobj( "wounded" ), "active", &"SNIPERESCAPE_DRAG_MACMILLAN_BODILY", extraction_point() );
	objective_current( getobj( "wounded" ) );
	set_objective_pos_to_extraction_point( getobj( "wounded" ) );
	wounding_sight_blocker = getent( "wounding_sight_blocker", "targetname" );
	wounding_sight_blocker connectpaths();
	wounding_sight_blocker delete();

//	thread countdown( 8 );

	ai = getaispeciesarray( "axis", "all" );
	array_thread( ai, ::delete_living );
	player_org = getent( "player_fair_org", "targetname" );
	price_org = getent( "price_gnoll", "targetname" );
	
	level.player setorigin( player_org.origin + ( 0, 0, -5150 ) );
	level.price teleport( price_org.origin, price_org.angles );
	plant_price();
	level.player setplayerangles( player_org.angles );
	level.player setorigin( player_org.origin );
	
	wait( 0.05 );// magic bullet shield lameness
	
	flag_set( "price_can_be_left" );
	thread price_wounded_logic();
	thread fairgrounds_after_prep();
	flag_set( "player_enters_fairgrounds" );
	flag_set( "to_the_pool" );
}

fairgrounds_before_battle()
{
	thread fairground_patrollers();
	
	level.price_gnoll_dist = 250;

	flag_wait( "player_enters_fairgrounds" );
	for ( ;; )
	{
		flag_wait( "player_reaches_extraction_point" );
		if ( flag( "price_picked_up" ) )
			break;
		flag_clear( "player_reaches_extraction_point" );
	}

	array_thread( level.deathflags[ "fair_snipers_died" ][ "ai" ], ::fair_spawner_seeks_player );
	flag_wait( "fair_snipers_died" );
	
	// Alpha Six, this is Big Bird. Standing by for your signal, over.
	price_line( "waiting_for_signal" );
	
	wait( 0.35 );
//gone// Good. Our helicopter is standing by at a safe distance. The enemy will try to overrun our LZ once they pick him up on radar, so find a good sniping spot and go prone. Once you're in position, I'll call in the helicopter. Go.

	// Our helicopter is standing by at a safe distance.
	price_line( "helicopter_is_standing_by" );

	// Put me down behind the Ferris wheel, where I can provide sniper support.
	price_line( "put_down_behind_wheel" );

	wait( 2 );
	objective_complete( getobj( "wounded" ) );
	
	flag_set( "put_price_near_wheel" );
	objective_add( getobj( "putdown" ), "active", &"SNIPERESCAPE_PUT_CPT_MACMILLAN_DOWN", price_fair_defendspot() );
	objective_current( getobj( "putdown" ) );
	thread update_objective_position_for_fairground( getobj( "putdown" ) );
	thread price_says_this_is_fine();
	thread price_says_a_bit_farther();

	price_placement_trigger = getent( "price_placement_trigger", "targetname" );
	
	for ( ;; )
	{
		flag_waitopen( "price_picked_up" );
		if ( level.price istouching( price_placement_trigger ) )
			break;
		if ( distance( level.price.origin, price_fair_defendspot() ) <= level.price_gnoll_dist )
			break;
		flag_wait( "price_picked_up" );
	}
	flag_set( "price_is_put_down_near_wheel" );
	objective_complete( getobj( "putdown" ) );

	thread fairgrounds_after_prep();	
}

fairgrounds_after_prep()
{
	flag_set( "price_moves_to_position" );
	flag_clear( "can_manage_price" );
	flag_set( "fair_hold_fire" );
	flag_set( "price_can_be_left" );
	flag_set( "first_pickup" );
	flag_clear( "price_calls_out_enemy_location" );

	fairground_chopper_spawners = getentarray( "chase_chopper_spawner", "script_noteworthy" );
	array_thread( fairground_chopper_spawners, ::add_spawn_function, ::fairground_enemies );
	
	 
	autosave_by_name( "the_fairgrounds" );
	wait( 2 );	
	
//	level.player givemaxammo("claymore");
	// more ammo for final battle
	maps\_loadout::sniper_escape_initial_secondary_weapon_loadout();
	if ( level.gameskill <= 1 )
		maps\_loadout::max_ammo_on_legit_sniper_escape_weapon();	

	if ( getdvar( "claymore_hint" ) == "" )
	{
		setdvar( "claymore_hint", "claymore" );
		claymoreCount = getPlayerClaymores();
		if ( claymoreCount )
		{
			if ( claymoreCount < 9 )
			{				
				// Take the rest of my claymores, now is the time to use them.		
				thread price_line( "take_my_claymores" );
			}
			else
			{
				// And if you have any claymores left, now is the time to use them.
				thread price_line( "use_claymores" );
			}
						
			thread display_hint( "claymore_plant" );
			wait( 4 );
		}
	}
	else
	if ( getdvar( "claymore_hint" ) == "claymore" )
	{
		setdvar( "claymore_hint", "c4" );
		thread c4_hint();
	}

		
	// The enemy is bound to enter this area, so find a good sniping position.
	thread price_line( "find_a_good_snipe" );
	// I will signal the helicopter in thirty seconds.
	thread price_line( "i_will_signal_in_30" );
	wait( 4 );

	claymoreCount = getPlayerClaymores();
	wait_for_player_to_place_claymores();

	
	if ( autosave_on_good_claymore_placement( claymoreCount ) )
	{
		// player did a decent job placing claymores so lets just save it
//		autosave_now( "claymores_placed" );
	}
	
	
// 	player_snipe_spot = getent( "player_snipe_spot", "targetname" );
	
	objective_add( getobj( "holdout" ), "active", &"SNIPERESCAPE_HOLD_OUT_UNTIL_EVAC", level.price.origin );
	objective_current( getobj( "holdout" ) );

// 	fairgrounds_wait_until_player_is_ready();

	// Alright lad, I've activated the beacon. Good luck.
	price_line( "activated_beacon" );
	wait( 2.2 );

	// Alpha Six, we have a fix on your position. Hang tight. Big Bird out.
	thread price_line( "have_a_fix" );
	
//	objective_complete( 3 );
	
	flag_set( "beacon_placed" );
	price_putdown_hint_trigger = getent( "price_putdown_hint_trigger", "targetname" );
	price_putdown_hint_trigger delete();

	
	thread fairground_battle();	

	thread seaknight_flies_in( false );


	// wait until the _vehicle scripts can do assorted waits they do	
	wait( 1 );

// 	thread do_in_order( ::wait_until_seaknight_gets_close, 150000, ::flag_set, "seaknight_flies_in" );
	objective_add( getobj( "holdout" ), "active", &"SNIPERESCAPE_SEAKNIGHT_INCOMING", level.seaknight.origin );
	objective_additionalcurrent( getobj( "holdout" ) );
	objective_icon( getobj( "holdout" ), "objective_heli" );
	thread update_seaknight_objective_pos( getobj( "holdout" ) );
	
// 	thread fairground_air_war();
}

start_seaknight()
{
	thread music();
	flag_set( "price_can_be_left" );
	flag_set( "first_pickup" );
	thread vision_glow_change();
	objective_add( getobj( "wounded" ), "active", &"SNIPERESCAPE_DRAG_MACMILLAN_BODILY", extraction_point() );
	objective_current( getobj( "wounded" ) );
	set_objective_pos_to_extraction_point( getobj( "wounded" ) );
	wounding_sight_blocker = getent( "wounding_sight_blocker", "targetname" );
	wounding_sight_blocker connectpaths();
	wounding_sight_blocker delete();

	thread countdown( 8 );

	ai = getaispeciesarray( "axis", "all" );
	array_thread( ai, ::delete_living );
	player_org = getent( "player_fair_org", "targetname" );
	price_org = getent( "price_gnoll", "targetname" );
	
	level.player setorigin( player_org.origin + ( 0, 0, -5150 ) );
	level.price teleport( price_org.origin, price_org.angles );
	plant_price();
	level.player setplayerangles( player_org.angles );
	level.player setorigin( player_org.origin );
	
	wait( 0.05 );// magic bullet shield lameness
	thread price_wounded_logic();
//	thread fairgrounds_after_prep();
	flag_set( "player_enters_fairgrounds" );
	thread seaknight_flies_in( true );
	wait( 1 );
// 	thread do_in_order( ::wait_until_seaknight_gets_close, 150000, ::flag_set, "seaknight_flies_in" );
	objective_add( getobj( "holdout" ), "active", &"SNIPERESCAPE_SEAKNIGHT_INCOMING", level.seaknight.origin );
	objective_additionalcurrent( getobj( "holdout" ) );
	objective_icon( getobj( "holdout" ), "objective_heli" );
	thread update_seaknight_objective_pos( getobj( "holdout" ) );
}


seaknight_flies_in( debug )
{
	seaknight_name = "seaknight_normal";
	if ( level.gameskill >= 1 )
		seaknight_name = "seaknight_hard"; // farther away
	seaknight = spawn_vehicle_from_targetname_and_drive( seaknight_name );
	level.seaknight = seaknight;
	
// 	seaknight.origin = ( - 558000, seaknight.origin[ 1 ], seaknight.origin[ 2 ] );
	if ( !debug )
		seaknight waittill( "reached_dynamic_path_end" );
		
	seaknight_node = getent( "seaknight_landing", "targetname" );

	oldseaknight = seaknight;
	seaknight = seaknight vehicle_to_dummy();

	if ( level.start_point == "seaknight" )
	{
		seaknight thread maps\_debug::drawTagForever( "tag_detach" );
		seaknight thread maps\_debug::drawTagForever( "tag_origin" );
		seaknight thread maps\_debug::drawOriginForever();
	}
	
	seaknight.animname = "seaknight";
	seaknight thread rotor_anim();
	flag_set( "seaknight_flies_in" );
	oldseaknight stopEngineSound();
	
	level.seaknight = seaknight;
	seaknight thread seaknight_badplace();
// 	seaknight thread maps\_debug::drawTagForever( "tag_origin" );
// 	seaknight thread maps\_debug::drawTagForever( "tag_detach" );
	seaknight assign_animtree();
	seaknight_collmap = getent( "seaknight_collmap", "targetname" );
	seaknight_collmap linkto( seaknight, "tag_origin", ( 0, 0, 0 ), ( 0, 0, 0 ) );
	
	seaknight thread seaknight_sound();

	seaknight_entrance_trigger = getent( "seaknight_trigger", "targetname" );
	seaknight_entrance_trigger thread manual_linkto( seaknight_collmap );

	seaknight_death_trigger = getent( "seaknight_death_trigger", "targetname" );
	seaknight_death_trigger thread manual_linkto( seaknight );
	seaknight_death_trigger thread heli_squashes_stuff( "seaknight_lands" );
	
	seaknight thread spawn_seaknight_crew();
	seaknight_node anim_single_solo( seaknight, "landing" );
	flag_set( "seaknight_lands" );
	thread fairbattle_autosave();
	thread player_becomes_invul_on_pickup();

	// Alpha Team, we're at the LZ. Standing by.
	thread price_line( "heli_at_the_lz" );
	hangout_time = 60;
	
	thread seaknight_leaving_warning( hangout_time );
		
	// dont want to save after this
	flag_clear( "can_save" );

	// no more grenades from baddies for the big exit.
	add_global_spawn_function( "axis", ::no_grenades );
	axis = getaiarray( "axis" );
	array_thread( axis, ::set_grenadeammo, 0 );

	seaknight_node thread anim_loop_solo( seaknight, "idle", undefined, "stop_idle" );
	seaknight_death_trigger delete();

	objective_complete( getobj( "holdout" ) );

	trigger = spawn( "script_origin", (0,0,0) );
	trigger.origin = seaknight gettagorigin( "tag_door_rear" );
	trigger.radius = 27.731134;

	objective_add( getobj( "seaknight" ), "active", &"SNIPERESCAPE_GET_CPT_MACMILLAN_TO", trigger.origin );
	objective_current( getobj( "seaknight" ) );

	flag_set( "can_manage_price" );

	thread player_abandons_seaknight_protection();

	thread player_boards_seaknight( seaknight, trigger );
	delaythread( hangout_time, ::flag_set, "seaknight_leaves_prematurely" );

	wait_for_seaknight_to_take_off();
	
	
	if ( flag( "player_made_it_to_seaknight" ) )
	{
		wait( 5 ); // guys delay getting in so they dont intersect player
		thread bring_in_heli_spawners();
	}
	
	flag_set( "seaknight_prepares_to_leave" );

	// wait for the guys to get back on, comes from flag
	wait( 12 );
	seaknight_node notify( "stop_idle" );
	flag_set( "seaknight_leaves" );

	seaknight_collmap delete();
	seaknight_node thread anim_single_solo( seaknight, "take_off" );
	if ( flag( "player_made_it_to_seaknight" ) )
	{
		wait( 2.5 );
		flag_clear( "aa_seaknight_rescue" );
		wait( 2 );
		if ( isalive( level.player ) )
		{
			objective_complete( getobj( "seaknight" ) );
		}
		return;
	}
	
	wait( 5 );
	setdvar( "ui_deadquote", &"SNIPERESCAPE_YOU_FAILED_TO_REACH_THE" );
	maps\_utility::missionFailedWrapper();
}

end_level( empty )
{
	nextmission();
}

bring_in_heli_spawners()
{
	wait( 6 );
	// bad guys cant shoot you after you start to get in
	remove_global_spawn_function( "axis", ::no_accuracy );
	level notify( "stop_having_low_accuracy" );

	heli_chaser_spawners = getentarray( "heli_chaser_spawner", "targetname" );
	array_thread( heli_chaser_spawners, ::spawn_ai );
	badplace_delete( "seaknight_badplace" );
}

spawn_seaknight_crew()
{
	spawners = getentarray( "seaknight_spawner", "targetname" );
	array_thread( spawners, ::add_spawn_function, ::seaknight_defender );
	org = self gettagorigin( "tag_detach" );
	guys = [];
	for ( i = 0; i < spawners.size; i++ )
	{
		spawners[ i ].origin = org;
		spawn = spawners[ i ] stalingradspawn();
		spawn.animname = "guy" + ( i + 1 );
		guys[ guys.size ] = spawn;
	}
	
	self thread anim_first_frame( guys, "unload", "tag_detach" );
	
	for ( i = 0; i < guys.size; i++ )
	{
		guys[ i ] linkto( self, "tag_detach" );
		guys[ i ].attackeraccuracy = 0;
	}
	
	flag_wait( "seaknight_lands" );
	
	array_thread( guys, ::send_notify, "stop_first_frame" );
	self anim_single( guys, "unload", "tag_detach" );

	for ( i = 0; i < guys.size; i++ )
	{
		guys[ i ] unlink();
	}
	flag_wait( "seaknight_prepares_to_leave" );

	for ( i = 0; i < guys.size; i++ )
	{
		guys[ i ] linkto( self, "tag_detach" );
	}
	self anim_single( guys, "load", "tag_detach" );
	
	flag_wait( "player_made_it_to_seaknight" );
	flag_wait( "seaknight_leaves" );

 	array_thread( guys, ::stop_magic_bullet_shield );
 	array_thread( guys, ::deleteme );
}

seaknight_defender()
{
	self thread magic_bullet_shield();
	self setthreatbiasgroup( "price" ); // so dogs dont attack me
	self allowedstances( "crouch" );

	wait( 1 );
	self.a.pose = "crouch";
	self waittillmatch( "single anim", "end" );
	self setgoalpos( self.origin );	
	self.goalradius = 16;
}

