#include maps\_utility;
#include maps\_vehicle;
#include common_scripts\utility;
#include maps\_anim;
#include maps\bog_a_code;

main()
{
//	anim.chatInitialized = false;
	setSavedDvar( "r_specularColorScale", "2.42" );
	
	realStart = getent( "real", "targetname" );
	level.player setplayerangles( realStart.angles );
	level.player setorigin( realStart.origin );

	setsaveddvar( "compassMaxRange", 2500 );
	precacheItem("rpg_straight");
	precacheItem("cobra_FFAR_bog_a_lite");
	precacheModel( "tag_laser" );
	precacheModel( "weapon_javelin" );
	precacheModel( "vehicle_zpu4_burn" );
	precacheModel( "com_night_beacon_obj" );
	precacheModel( "com_night_beacon" );
	precachestring( &"BOG_A_INTRO_1" );
	precachestring( &"BOG_A_INTRO_2" );
	precachestring( &"BOG_A_SGT_PAUL_JACKSON" );
	precachestring( &"BOG_A_1ST_FORCE_RECON_CO_USMC" );
	precachestring( &"BOG_A_ELIMINATE_ENEMY_FORCES" );
	precachestring( &"BOG_A_GET_THE_JAVELIN" );
	precachestring( &"BOG_A_DESTROY_THE_ARMORED_VEHICLES" );
	precachestring( &"BOG_A_SECURE_THE_M1A2_ABRAMS" );
	precachestring( &"BOG_A_SECURE_THE_M1A1_ABRAMS" );
	precachestring( &"BOG_A_INTERCEPT_THE_ENEMY_BEFORE" );
	precachestring( &"BOG_A_DESTROY_THE_ZPU_ANTI" );
	precachestring( &"BOG_A_SECURE_THE_SOUTHERN_SECTOR" );
	precachestring( &"BOG_A_PLANT_THE_IR_BEACON_TO" );
	precachestring( &"BOG_A_REGROUP_WITH_THE_SQUAD" );
	precachestring( &"BOG_A_THE_TANK_WAS_OVERRUN" );
	precachestring( &"SCRIPT_PLATFORM_HINT_PLANTBEACON" );
	
	
		
	maps\bog_a_fx::main();
	maps\_javelin::init();

//	thread bcs_disabler();
	// add the starts before _load because _load handles starts now
	add_start( "melee", maps\bog_a_code::start_melee, &"STARTS_MELEE" );
	add_start( "breach", maps\bog_a_code::start_breach, &"STARTS_BREACH1" );
	add_start( "alley", maps\bog_a_code::start_alley, &"STARTS_ALLEY" );
	add_start( "shanty", maps\bog_a_code::start_alley, &"STARTS_SHANTY" );
	add_start( "bog", maps\bog_a_code::start_bog, &"STARTS_BOG" );
	add_start( "zpu", maps\bog_a_backhalf::start_zpu, &"STARTS_ZPU" );
	add_start( "cobras", maps\bog_a_backhalf::start_cobras, &"STARTS_COBRAS" );
	add_start( "end", maps\bog_a_backhalf::start_end, &"STARTS_END1" );
	default_start( ::ambush );
//	verify_that_allies_are_undeletable();

	maps\_flare::main( "tag_flash" );
	maps\_seaknight::main( "vehicle_ch46e_low" );
	maps\_cobra::main( "vehicle_cobra_helicopter_fly_low" );
	maps\_m1a1::main( "vehicle_m1a1_abrams" );
	maps\_t72::main( "vehicle_t72_tank" );
	maps\_c4::main();
//	maps\_blackhawk::main( "vehicle_blackhawk_low" );

	maps\createart\bog_a_art::main();
	maps\createfx\bog_a_fx::main();
	maps\createfx\bog_a_audio::main();

	level.weaponClipModels = [];
	level.weaponClipModels[0] = "weapon_ak47_clip";
	level.weaponClipModels[1] = "weapon_dragunov_clip";
	level.weaponClipModels[2] = "weapon_m16_clip";
	level.weaponClipModels[3] = "weapon_saw_clip";
	level.weaponClipModels[4] = "weapon_m14_clip";
	level.weaponClipModels[5] = "weapon_g3_clip";



	maps\_load::main();
	maps\_nightvision::main();
	maps\_zpu::main( "vehicle_zpu4" );



	maps\bog_a_backhalf::bog_backhalf_init();

	thread debug_player_damage();
	battlechatter_off( "allies" );


	// hint strings
	// Press UP to use nightvision goggles
	add_hint_string( "nvg", &"SCRIPT_NIGHTVISION_USE", maps\_nightvision::ShouldBreakNVGHintPrint );
	add_hint_string( "disable_nvg", &"SCRIPT_NIGHTVISION_STOP_USE", maps\_nightvision::should_break_disable_nvg_print );
	add_hint_string( "c4_use", &"SCRIPT_C4_USE", maps\bog_a_backhalf::dont_show_C4_hint );

//	add_hint_string( "grenade_launcher", &"SCRIPT_LEARN_GRENADE_LAUNCHER", ::should_break_grenade_launcher_hint );
	thread disable_nvg();
//	thread do_in_order( ::flag_wait, "grenade_launcher_hint", ::grenade_launcher_hint, undefined );
	
	

	
	/#
	array_thread( getaiarray(), ::debug_pain );
	array_thread( getspawnerarray(), ::add_spawn_function, ::debug_pain );
	#/

	

	// dummy origins that the enemies aim at when they have no target
	level.aim_targets = getentarray( "aim_target", "targetname" );

	// friendlies need to ignore these guys when they're under them or they look dumbbbb
	createThreatBiasGroup( "upstairs_unreachable_enemies" ); 
	createThreatBiasGroup( "upstairs_window_enemies" ); 
	createThreatBiasGroup( "pacifist_lower_level_enemies" ); 
	createThreatBiasGroup( "melee_struggle_guy" ); 
	
	createThreatBiasGroup( "friendlies_flanking_apartment" ); 
	createThreatBiasGroup( "friendlies_under_unreachable_enemies" ); 
	createThreatBiasGroup( "player_seeker" ); 
	createThreatBiasGroup( "player" ); 


	level.player setthreatbiasgroup( "player" );
//	setThreatBias( "player", "upstairs_unreachable_enemies", -5000 );
//	setThreatBias( "player", "upstairs_window_enemies", -5000 );

	setThreatBias( "player", "player_seeker", 15000 );

	// pacifist rubble guys focus on the flankers once they're in the lower are
	ignoreEachOther( "pacifist_lower_level_enemies", "friendlies_flanking_apartment" );
	ignoreEachOther( "pacifist_lower_level_enemies", "allies" );

	// first the AI flank the apartment
	ignoreEachOther( "upstairs_window_enemies", "friendlies_flanking_apartment" );
	ignoreEachOther( "upstairs_window_enemies", "friendlies_under_unreachable_enemies" );
	ignoreEachOther( "friendlies_under_unreachable_enemies", "upstairs_window_enemies" );

	// then they move under/through it. Now they are no longer ignored by the pacifist enemies on the lowest level, 
	// and they arent completely ignored by the window guys. They continue to ignore the guys in the first part of
	// the apartment.
	ignoreEachOther( "upstairs_unreachable_enemies", "friendlies_under_unreachable_enemies" );
	ignoreEachOther( "upstairs_unreachable_enemies", "friendlies_flanking_apartment" );
	
	// when the player or ai run down from the bridge, they need to be attackable by the guys on the first floor down there
	enable_pacifists_to_attack_me = getentarray( "enable_pacifists_to_attack_me", "targetname" );
	array_thread( enable_pacifists_to_attack_me, ::enable_pacifists_to_attack_me );

	// initial flags	
	flag_init( "friendlies_take_fire" );
	flag_init( "move_up!" );
	flag_init( "initial_contact" );
//	flag_init( "laundrymat_open" );
	flag_init( "melee_sequence_complete" );
	flag_init( "laundry_room_price_talks_to_hq" );	
	flag_init( "price_reaches_end_of_bridge" );
	flag_init( "price_flanks_apartment" );
	flag_init( "friendlies_move_up_the_bridge" );	
	flag_init( "second_floor_ready_for_storming" );
	flag_init( "unreachable_enemies_under_attack" );
	flag_init( "window_enemies_under_attack" );	
	flag_init( "lasers_have_moved" );
	flag_init( "friendlies_lead_player" );
	flag_init( "lasers_shift_fire" );
	flag_init( "melee_sequence_begins" );
	flag_init( "armada_passes_by" );
	flag_init( "price_reaches_moveup_point" );
	flag_init( "alley_enemies_spawn" );
	flag_init( "javelin_guy_in_position" );
	flag_init( "price_in_position_for_jav_seq" );
	flag_init( "player_has_javelin" );
	flag_init( "javelin_guy_died" );	
	flag_init( "pickup_javelin" );
	flag_init( "overpass_baddies_flee" );
	flag_init( "kill_bog_ambient_fighting" );
	flag_init( "second_floor_door_breach_initiated" );
	flag_init( "friendlies_storm_second_floor" );
	flag_init( "price_in_alley_position" );
	flag_init( "vas_stops_leading" );
	flag_init( "bmp_got_killed" );
	flag_init( "all_bmps_dead" );
	flag_init( "contact_on_the_overpado!" );
	flag_init( "jav_guy_ready_for_briefing" );	
	flag_init( "overpass_guy_attacks!" );
	flag_init( "player_enters_the_fray" );
	flag_init( "ambush_player" );
	flag_init( "player_interupts_melee_struggle" );

	thread do_in_order( ::flag_wait, "player_heads_towards_apartment", ::flag_set, "pacifist_guys_move_up" );
	thread do_in_order( ::flag_wait, "alley_enemies_spawn", ::activate_trigger_with_noteworthy, "laundryroom_spawner" );



	
	maps\bog_a_anim::main();
	maps\bog_a_backhalf_anim::main();
	
	maps\_compass::setupMiniMap("compass_map_bog_a");
		
	level thread maps\bog_a_amb::main();

	level._effect[ "vehicle_explosion" ]		= loadfx( "explosions/large_vehicle_explosion" );
	

	upstairs_unreachable_enemies = getentarray( "upper_floor_enemies", "script_noteworthy" );
	array_thread( upstairs_unreachable_enemies, ::upstairs_unreachable_enemies );

	upstairs_window_enemies = getentarray( "window_enemies", "script_noteworthy" );
	array_thread( upstairs_window_enemies, ::upstairs_window_enemies );

	battlechatter_off( "allies" );

	friendlies = getaiarray( "allies" );
	level.friendly_startup_thread = ::bridge_friendly_spawns;

	aim_triggers = getentarray( "aim_trigger", "targetname" );
	array_thread( aim_triggers, ::aim_trigger_think );

	delete_entities = getentarray( "delete", "targetname" );
	array_thread( delete_entities, ::delete_me );


	// for when the player goes inside into the dark
	threatbias_lower_triggers = getentarray( "threatbias_lower", "targetname" );
	array_thread( threatbias_lower_triggers, ::threatbias_lower_trigger );

	threatbias_normal_triggers = getentarray( "threatbias_normal", "targetname" );
	array_thread( threatbias_normal_triggers, ::threatbias_normal_trigger );
	
	thread apartment_second_floor();
	
	// bunch of threading for the spawners in the alley
	balcony_spawner = getent( "alley_balcony_guy", "script_noteworthy" );
	balcony_spawner thread add_spawn_function( ::alley_balcony_guy );
	
	alley_snipers = getentarray( "alley_longrange_guy", "script_noteworthy" );
	array_thread( alley_snipers, ::add_spawn_function, ::alley_sniper_engagementdistance );

	alley_close_smgGuys = getentarray( "alley_shortrange_guy", "script_noteworthy" );
	array_thread( alley_close_smgGuys, ::add_spawn_function, ::alley_close_smg_engagementdistance );

	alley_smgGuys = getentarray( "alley_mediumrange_guy", "script_noteworthy" );
	array_thread( alley_smgGuys, ::add_spawn_function, ::alley_smg_engagementdistance );
	
	alley_roof_guy = getentarray( "alley_roof_guy", "script_noteworthy" );
	array_thread( alley_roof_guy, ::add_spawn_function, ::alley_roof_guy );
	
	alley_playerseeker = getentarray( "alley_playerseeker", "script_noteworthy" );
	array_thread( alley_playerseeker, ::add_spawn_function, ::alley_smg_playerseeker );
	
	breach_guy_1 = getent( "breach_1", "script_noteworthy" );
	breach_guy_1 thread add_spawn_function( ::die_after_spawn, 1.5 ); 
	
	breach_guy_2 = getent( "breach_2", "script_noteworthy" );
	breach_guy_2 thread add_spawn_function( ::die_after_spawn, 4.950 ); 

	thread shanty_fence_cut_setup();
	
	thread music();
}

ambush()
{
	thread second_floor_door_breach_guys( false );

	// pops out and leads us a bit after we head down the stairs
	thread flank_guy();
	
	// lasers that shine across the pit when you're under the first building
	thread street_laser_light_show();
	
	// spawn the ambush baddies
	ambush_enemies();
	thread helicopters_fly_by();

	// heli that flies by when you look up into the window from the mg
	thread apartment_rubble_helicopter();
	
	// start off with everybody ignoring each other
	ai = getaiarray();
	array_thread( ai, ::set_ignoreme, true );	
		
	// used for debugging door breach
	remove_corner_ai_blocker();
	
	initial_friendlies = getentarray( "initial_friendly", "targetname" );
	array_thread( initial_friendlies, ::initial_friendly_setup );
	
	level.price = getent( "price", "targetname" );
	spawn_failed( level.price );
	level.price make_hero();
	level.price thread run_down_street();
	level.price.animName = "price";
	level.price thread magic_bullet_shield();
	level.price.animplaybackrate = 1;
//	level.price.moveplaybackrate = 1;
	
	level.mark = getent( "friendly3", "script_noteworthy" );
	level.mark thread magic_bullet_shield();
	level.mark make_hero();
//	level.price teleport( ( 12085.6, 4329.96, 202 ), ( 0, 240.275, 0 ) );
	
//	array_thread( getaiarray( "allies" ), ::showname );
	thread friendlies_advance_up_the_bridge();

	// Alpha Company's tank is stuck half a click north of here, let's go let's go!
	level.price thread anim_single_queue( level.price, "tank_is_stuck" );
	
	friendly1 = getent( "friendly1", "script_noteworthy" );
	friendly2 = getent( "friendly2", "script_noteworthy" );
	friendly1.animName = "generic";
	friendly2.animName = "generic";
	friendly1 delayThread( 0, ::anim_single_solo, friendly1, "spin" );
	friendly2 delayThread( 1.5, ::anim_single_solo, friendly2, "spin" );
	delaythread( 5.5, ::price_blends_into_run );

	flag_wait( "safe_for_objectives" );
	objective_add( 1, "active", &"BOG_A_SECURE_THE_M1A2_ABRAMS", ( 4800, 1488, 32 ) );
	objective_current( 1 );
}
	

price_blends_into_run()
{
	level.price stopanimscripted();
	level.price notify( "single anim", "end" );
}

ambush_enemies()
{
	rooftop_spawners = getentarray( "rooftop_guy", "targetname" );
	pacifist_rubble_guys = getentarray( "pacifist_rubble_guys", "targetname" );
	array_thread( pacifist_rubble_guys, ::ignore_suppression_until_ambush );
	array_thread( pacifist_rubble_guys, ::increase_goal_radius_when_friendlies_flank );
	
	ambusher_spawners = getentarray( "ambusher_spawner", "targetname" );
	array_thread( ambusher_spawners, maps\_spawner::flood_spawner_think );
	
	window_mg_spawner = getent( "window_mg_spawner", "script_noteworthy" );
	window_mg_spawner add_spawn_function( ::set_threatbias_group, "upstairs_window_enemies" );
	// wait until all the ai that are going to spawn in this frame have spawned, so later functions
	// can assume they're around
	waittillframeend;
}

friendlies_advance_up_the_bridge()
{
	// trigger that makes AI not use the goalvolume
	lose_goal_volume_trigger = getent( "lose_goal_volume_trigger", "targetname" );
	lose_goal_volume_trigger thread lose_goal_volume();
	
	// set red guys to be replaced by yellow guys
	clear_promotion_order();
	set_promotion_order( "c", "y" );
	set_promotion_order( "b", "y" );
	level.respawn_spawner = getent( "respawn_spawner", "targetname" );

	thread ambush_trigger();
	
	friendly1 = getent( "friendly1", "script_noteworthy" );
	friendly2 = getent( "friendly2", "script_noteworthy" );
	friendly3 = getent( "friendly3", "script_noteworthy" );
	friendly4 = getent( "friendly4", "script_noteworthy" );
	friendly5 = getent( "friendly5", "script_noteworthy" );
	friendly6 = getent( "friendly6", "script_noteworthy" );
	friendly7 = getent( "friendly7", "script_noteworthy" );

	friendly3 allowedstances( "crouch" );
	friendly4 allowedstances( "crouch" );
	friendly7 allowedstances( "crouch" );

	// moves early cause he's doing scripted animation
	friendly1 delayThread( 0, ::run_down_street );

//	bridge_go_trigger = getent( "bridge_go_trigger", "targetname" );
//	bridge_go_trigger wait_for_trigger_or_timeout( 3.5 ); // 3.8
	wait( 3.5 );
	
	thread additional_guys_chime_in();
	friendlies = getentarray( "initial_friendly", "targetname" );
	
	/*
	friendly1.moveplaybackrate = 1.1;
	friendly2.moveplaybackrate = 1.2;
	friendly4.moveplaybackrate = 1.4;
	friendly3.moveplaybackrate = 1.0;
	friendly5.moveplaybackrate = 1.1;
	friendly6.moveplaybackrate = 1.4;
	friendly7.moveplaybackrate = 1.1;
	*/
	
	friendly2 delayThread( 0.0, ::run_down_street );
	friendly3 delayThread( 0.4, ::run_down_street );
	friendly4 delayThread( 0.0, ::run_down_street );
	friendly5 delayThread( 0.0, ::run_down_street );
	friendly6 delayThread( 0.0, ::run_down_street );
	friendly7 delayThread( 0.1, ::run_down_street );


	flag_wait( "friendlies_take_fire" );
	ai = getaiarray();
	array_thread( ai, ::set_ignoreme, false );
	
	delayThread( 2, ::incoming_rpg );
	set_team_pacifist( "axis", false );
	wait( 2.5 );
	thread maps\_flare::flare_from_targetname( "flare" );
	exploder(1);

	org = getent( "underground_obj_org", "targetname" );
	run_thread_on_targetname( "update_underground_obj_trigger", ::update_apartment_objective_position );
	objective_add( 2, "active", &"BOG_A_ELIMINATE_ENEMY_FORCES", org.origin );
	objective_current( 2 );

	if ( !flag( "friendlies_already_moved_up_bridge" ) )
	{
		// set the location for the friendlies to move to
		activate_trigger_with_targetname( "friendlies_move_up_bridge" );
	}
	
	// give friendlies a chance to hide from the ambush
	wait( 1.5 );
	flag_set( "friendlies_move_up_the_bridge" );	


	// price is special
//	level.price set_force_color( "r" );

	// price moves up to call for flanking
	thread price_moves_behind_concrete_barrier();

	// grab the friendlies and send them off to flank
	thread friendly_bridge_flank_grabber();

	// backup guys are yellow, nearest to the player are red, they move up
	allies = getaiarray( "allies" );
	allies = remove_heroes_from_array( allies );
	allies = array_add( allies, level.mark );
	array_thread( allies, ::set_force_color, "y" );

	yellow = get_force_color_guys( "allies", "y" );
	for ( i = yellow.size; i < 8; i++ )
	{
		// make 4 additional friendlies spawn when player is looking the right way
		thread spawn_reinforcement( "m4grunt" );
	}

	thread price_tells_squad_to_flank_right();

	flag_wait( "player_heads_towards_apartment" );
	// switch to night vision!
	level.price thread anim_single_queue( level.price, "switch_to_night_vision" );

	// do night vision line here
	// Carver, you and Roycewicz head upstairs. We’ll cover this entrance. Go!
//	level.price thread anim_single_queue( level.price, "head_upstairs" );
	

	// the second floor AI don't attack the player unless he attacks them
	thread window_enemies_respond_to_attack();

	// the upstairs UNREACHABLE guys ignore the player until one is killed
	thread upstairs_enemies_respond_to_attack();


	
	// the flanker jumps out to lead the way
	level.flank_guy allowedstances( "stand" );
	level.flank_guy thread maps\_spawner::go_to_node(); // makes a guy go through his node chain

	cyan_guys = get_force_color_guys( "allies", "c" );
	cyan_guys = remove_heroes_from_array( cyan_guys );
	
	// need 2 red guys to go cyan. Price will be the third and flank guy will be the 4th.
	for ( i = cyan_guys.size; i < 2; i++ )
	{
		thread promote_nearest_friendly_with_classname( "y", "c", "m4grunt" );
	}

	// move the friendlies up to the next chain	
	activate_trigger_with_targetname( "friendlies_leave_bridge" );

	player_flanks_right_or_goes_straight();

	// flank guy can be a normal guy now
	level.flank_guy stop_magic_bullet_shield();
	level.flank_guy thread replace_on_death();
	level.flank_guy unmake_hero();
	level.flank_guy flanks_apartment();

	flag_wait( "grenade_launcher_hint" ); // this is a more appropriate timing
	
	thread melee_sequence();
	thread player_enters_second_floor();

	// turns on dark blue nodes that friendlies will switch to if the player gets close to them
	activate_trigger_with_targetname( "player_enters_apartment_rubble_area" );
	
	cyan_guys = get_force_color_guys( "allies", "c" );

	flag_set( "friendlies_lead_player" );	
	// if a cyan guy is approached, he becomes a blue guy and leads you inside.
	array_thread( cyan_guys, ::cyan_guys_lead_player_to_apartment );
	level.friendly_promotion_thread = ::promoted_cyan_guy_leads_player_to_apartment;
	
	flag_wait( "player_enters_apartment_rubble_area" );
	// price directs you when you and he are both in the building
	thread price_directs_players_upstairs();
}

player_gets_ambushed()
{
	level endon( "friendlies_take_fire" );
	flag_wait( "ambush_player" );

	mgs = getentarray( "apartment_manual_mg", "targetname" );
	gun1 = mgs[ 0 ];
	gun2 = mgs[ 1 ];

	// the player has moved ahead too far too fast
	level.canSave = false;
	level.player endon( "death" );
	gun1 settargetentity( level.player );
	gun2 settargetentity( level.player );
	gun1 thread manual_mg_fire();
	wait( 0.15 );
	gun2 thread manual_mg_fire();
	wait( 1.0 );
	level.player enableHealthShield( false );
	level.player dodamage( level.player.health + 500, (0,0,0) );
}

ambush_trigger()
{
	thread player_gets_ambushed();
	mgs = getentarray( "apartment_manual_mg", "targetname" );
	array_thread( mgs, ::scr_setmode, "manual" );
	gun1 = mgs[ 0 ];
	gun2 = mgs[ 1 ];

	trigger = getent( "ambush_trigger", "targetname" );
	guys = [];
	captured = [];
	for ( ;; )
	{
		trigger waittill( "trigger", other );
		other thread ignore_triggers();
		if ( other is_hero() )
			continue;
			
		if ( isdefined( captured[ other.ai_number ] ) )
			continue;

		captured[ other.ai_number ] = true;
		guys[ guys.size ] = other;
//		other notify( "stop_running_to_node" );
		if ( guys.size >= 3 )
			break;
	}
	
	
	if ( !flag( "player_enters_the_fray" ) )
	{
		array_thread( guys, ::stop_magic_bullet_shield );
	}
	
	// friendlies that are not ambush-killed stop running to their node
	// and run for cover
	ai = getaiarray( "allies" );
	for ( i = 0; i < ai.size; i++ )
	{
		if ( !isdefined( captured[ ai[ i ].ai_number ] ) )
		{
			ai[ i ] thread do_in_order( ::waitSpread, 0.25, ::send_notify, "stop_running_to_node" );
		}
	}
	
	battlechatter_on( "allies" );
	flag_set( "friendlies_take_fire" );

	gun1 settargetEntity( guys[ 0 ] );
	gun2 settargetentity( guys[ 1 ] );
	
	gun1 thread manual_mg_fire();
	wait( 0.15 );
	gun2 thread manual_mg_fire();

	guys[ 0 ] thread die_soon( 0.2 );
	wait_for_death( guys[ 0 ] );
	gun1 settargetentity( guys[ 2 ] );

	guys[ 1 ] thread die_soon( 0.2 );
	wait_for_death( guys[ 1 ] );
	wait( 0.5 );
	gun2 thread shoot_mg_targets();

	guys[ 2 ] thread die_soon( 0.2 );
	wait_for_death( guys[ 2 ] );
	wait( 0.5 );
	gun1 thread shoot_mg_targets();
	
	
	/*
	timer = [];
	timer[ 0 ] = 0;
	timer[ 1 ] = 0.4;
	timer[ 2 ] = 0.3;
	
	for ( i = 0; i < guys.size; i++ )
	{
		guy = guys[ i ];
		if ( !isalive( guy ) )
			continue;
		guy dodamage( guy.health + 50, (0,0,0) );
		wait( timer[ i ] );
	}
	*/
	
//	array_thread( guys, ::die_soon, 0, 1.5 );
	/*
	
	// the guys that get ambushed get gunned down by mgs
	friendlies = getentarray( "ambushed_guy", "targetname" );
	friendly5 = getent( "friendly5", "script_noteworthy" );
	friendly6 = getent( "friendly6", "script_noteworthy" );
	friendly7 = getent( "friendly7", "script_noteworthy" );
	
//	gun1 thread maps\_mgturret::mg42_firing( gun1 );
	
	gun1 settargetentity( friendly5 );
	gun1 thread manual_mg_fire();

	wait( 0.25 );
	gun2 settargetentity( friendly6 );
	gun2 thread manual_mg_fire();
	
	wait_for_death( friendly5 );
	if ( isalive( friendly7 ) )
		gun1 settargetentity( friendly7 );
	wait_for_death( friendly6 );
//	if ( isalive( ambushed_guy4 ) )
//		gun2 settargetentity( ambushed_guy4 );
	wait_for_death( friendly7 );
//	wait_for_death( ambushed_guy4 );
	gun1 notify( "stop_firing" );
	wait( 0.35 );
	gun2 notify( "stop_firing" );
	*/
}


player_enters_second_floor()
{
	// player gets ignored by the second floor guys unless he moves towards them or shoots them or leaves the second floor
	for ( ;; )
	{
		flag_clear( "player_nears_second_floor" );
		flag_wait( "player_nears_second_floor" );
		setignoremegroup( "player", "axis" );
		flag_clear( "player_disrupts_second_floor" );
		flag_clear( "player_leaves_second_floor" );
		wait_for_player_to_disrupt_second_floor_or_leave();

		clear_player_threatbias_vs_apartment_enemies();
		setthreatbias( "player", "axis", 0 );
		
		if ( flag( "player_disrupts_second_floor" ) )
			break;
	}
	
	flag_set( "second_floor_ready_for_storming" );
	flag_wait( "window_enemies_under_attack" );
	waittillframeend; // overwrite the over-threat set incase the player attacks from downstairs
	setThreatBias( "player", "upstairs_window_enemies", 0 );
}

handle_player_flanking()
{
	level endon( "player_enters_apartment_rubble_area" );
	flag_wait( "player_nears_first_building" );
	
	if ( !flag( "friendlies_moves_through_first_building" ) )
	{
		// special node set aside for flank guy
		level.flank_guy set_force_color( "g" );
	
		flag_wait( "friendlies_moves_through_first_building" );
	}
}

player_flanks_right_or_goes_straight()
{
	handle_player_flanking();

	// stops the AI from going the wrong way prematurely
	ai_apartment_flank_blocker = getent( "ai_apartment_flank_blocker", "targetname" );
	ai_apartment_flank_blocker connectPaths();
	ai_apartment_flank_blocker delete();

	activate_trigger_with_targetname( "friendlies_moves_through_first_building" );
}


price_tells_squad_to_flank_right()
{
	assertEx( !flag( "player_heads_towards_apartment" ), "This flag shouldnt be set yet" );
	
	flag_wait( "player_reaches_end_of_bridge" );
	// let the player know about the flank plans

	flag_wait( "price_reaches_end_of_bridge" );
	last_reminder = "";
	reminder = "";
	reminders = [];

	// Let’s go Carver, follow me!
	reminders[ reminders.size ] = "follow_me";

	// Come on Carver, move it!
	reminders[ reminders.size ] = "move_it";

	// Carver! This way!
	reminders[ reminders.size ] = "this_way";

	
	while ( !flag( "player_heads_towards_apartment" ) )
	{
		remind_player = true;
		if ( flag( "price_flanks_apartment" ) )
		{
			remind_player = distance( level.player.origin, level.price.origin ) > 200;
		}
		
		if ( remind_player )
		{
			while ( reminder == last_reminder )
			{
				reminder = random( reminders );
			}
			last_reminder = reminder;
			
			level.price anim_single_queue( level.price, reminder );
		}
		wait( randomfloatrange( 5, 8 ) );
	}
	
}

price_moves_behind_concrete_barrier()
{
	while ( !isdefined( level.price.reached_bridge_flee_spot ) )
	{
		wait( 1 );
	}

	price_moves_up_and_waves_player_on();
	flag_wait( "player_heads_towards_apartment" );
	node = getnode( "price_flank_node", "targetname" );
	node notify( "stop_idle" );

	flag_set( "price_flanks_apartment" );
	level.price flanks_apartment();
}

price_moves_up_and_waves_player_on()
{
	level endon( "player_heads_towards_apartment" );

	// get price to a certain node
	node = getnode( "price_road_node", "targetname" );
	level.price setgoalnode( node );
	level.price.goalradius = 64;
	level.price waittill( "goal" );
	flag_set( "price_reaches_moveup_point" );
	wait( 1 );

	node = getnode( "price_flank_node", "targetname" );
	node anim_reach_solo( level.price, "wait_approach" );
	node anim_single_solo( level.price, "wait_approach" );
	thread price_waits_at_node_and_waves( node, "price_flanks_apartment" );
	
	flag_set( "price_reaches_end_of_bridge" );
	wait_until_player_gets_close_or_progresses();
}


wait_until_player_gets_close_or_progresses()
{
	// player is already progressing
	if ( flag( "player_heads_towards_apartment" ) )
		return;
		
	level endon( "player_heads_towards_apartment" );
	while ( distance( level.player.origin, level.price.origin ) > 115 )
	{
		wait( 1 );
	}
}

flanks_apartment()
{
	// cyan is the new red.
	self set_force_color( "c" );
	self.ignoreSuppression = true;
	self.ignoreme = false;
	self.pacifist = false;
	
	if ( self getthreatbiasgroup() == "friendlies_flanking_apartment" )
		return;

	// doesnt get shot by guys defending the apartment, so it looks safe to the player
	if ( self getthreatbiasgroup() == "allies" )
	{
		self setThreatBiasGroup( "friendlies_flanking_apartment" );
	}
	else
	{
		assert( self getthreatbiasgroup() == "friendlies_under_unreachable_enemies" );
	}
}


friendly_bridge_flank_grabber()
{
	level endon( "player_heads_towards_apartment" );
	assertEx( !flag( "player_heads_towards_apartment" ), "Flag should not be set yet" );
	
	thread friendly_flank_deleter();
	trigger = getent( "friendly_bridge_trigger", "targetname" );
	runner = 2;
	wait( 5 );

	for ( ;; )
	{
		// only send 2 guys down at a time total because there's
		// only enough space for 4 friendlies down there.
		total_cyan_guys = get_force_color_guys( "allies", "c" ).size;
		assert( total_cyan_guys < 3 );
		if ( total_cyan_guys >= 2 )
		{
			wait( 1 );
			continue;
		}
		
		allies = getaiarray( "allies" );
		allies = remove_heroes_from_array( allies );
		
		for ( i = 0; i < allies.size; i++ )
		{
			guy = allies[ i ];
				
			if ( !( guy istouching( trigger ) ) )
				continue;
				
			guy flanks_apartment();
			break;
		}
		
		// send a new friendly over every 10 seconds
		wait( 10 );
		/*
		if ( !isalive( other ) )
			continue;
		
		if ( other == level.price )
		{
			// price runs to a noticeable node
			node = getnode( "price_bridge_node", "targetname" );
			other setgoalnode( node );
			other.goalradius = 128;
			other disable_ai_color();
			continue;
		}
		
		other thread ignore_triggers( 3 );
		// send every 3rd guy on the flank route
		runner--;
		if ( runner > 0 )
			continue;
		
		runner = 2;
		
		thread spawn_reinforcement();
		// the friendly runs ahead on the flank route
		other set_force_color( "c" );
		other.ignoreSuppression = true;
		*/
	}
}

friendly_flank_deleter()
{
	// delete friendlies that get ahead until the player goes downstairs
	level endon( "player_heads_towards_apartment" );
	trigger = getent( "allies_apartment_delete", "targetname" );
	for ( ;; )
	{
		trigger waittill( "trigger", other );
		if ( !isalive( other ) )
			continue;
		
		if ( other == level.price )
		{
			other thread ignore_triggers();
			continue;
		}
		
		// make them yellow so that replacements are yellow instead of cyan
		other set_force_color( "y" );
		if ( isdefined( other.magic_bullet_shield ) )
			other stop_magic_bullet_shield();
		other delete();
	}	
}

additional_guys_chime_in()
{
	ent = spawnstruct();
	ent.guys = getentarray( "initial_friendly", "targetname" );
	ent.index = 0;
	
	wait( 3.5 );

	// move it! move it!
	ent set_talker();
	ent.talker thread anim_single_solo( ent.talker, "move_it" );
	wait( 2.2 );

	// Clear! Keep moving up!
	ent set_talker();
	ent.talker thread anim_single_solo( ent.talker, "keep_moving_up" );
	
	flag_wait( "friendlies_take_fire" );
	wait( 1.35 );
	
	// Ambush!
	ent set_talker();
	ent.talker thread anim_single_solo( ent.talker, "ambush1" );
	wait( 1.3 );

	// Contact right! Contact right!
	ent set_talker();
	ent.talker thread anim_single_solo( ent.talker, "contact_right" );
	wait( 0.5 );

	// Ambush!
	ent set_talker();
	ent.talker thread anim_single_solo( ent.talker, "ambush2" );
	wait( 1.5 );
	
	// Get suppression fire on that building! We have to move forward!
	level.price anim_single_queue( level.price, "suppress_building" );

	flag_wait( "price_reaches_moveup_point" );

	// Keep moving forward!
	level.price anim_single_queue( level.price, "keep_moving" );
	
	flag_wait( "price_reaches_end_of_bridge" );
	
	// Alpha, let’s take the stairs and hit their flank! Bravo, give us covering fire!
	level.price anim_single_queue( level.price, "take_the_stairs" );
}

apartment_second_floor()
{
	// magic lasers you see from outside into the hallway
	thread second_floor_laser_light_show();
	
	wait_until_player_goes_into_second_floor_or_melee_sequence_completes();
	level notify( "stop_melee_sequence" );
	flag_wait( "melee_sequence_complete" );

	// the upstairs UNREACHABLE guys again ignore the player, now that the player is inside
	thread upstairs_enemies_respond_to_attack();

	/#
	if ( !is_default_start() )
		return;
	#/
	
	flag_set( "friendlies_storm_second_floor" );
	
	// friendlies move up to this area now
	level.price set_force_color( "p" );
	level.price.ignoresuppression = true;
	instantly_promote_nearest_friendly( "b", "p" );
	purple_guys = get_force_color_guys( "allies", "p" );
	array_thread( purple_guys, ::set_ignoreSuppression, true );
	assertEx( purple_guys.size == 3, "Not enough purple guys" );

	flag_wait( "magic_lasers_turn_on" );
	level.mark stop_magic_bullet_shield();
	level.mark delete();
	
	// teleport the laggers to the apartment so they hit their mark
	teleport_purple_guys_closer();
	
	// some of the purple guys may be from earlier in the level so they need to all have the
	// correct threatbias group so the unreachable guys don't attack them prematurely
	purple_guys = get_force_color_guys( "allies", "p" );
	array_thread( purple_guys, ::set_threatbias_group, "friendlies_under_unreachable_enemies" );
	array_thread( purple_guys, ::set_ignoreme, true );
	
	flag_wait( "second_floor_ready_for_storming" );
	// the ai on the second floor have been attacked or approached by the player
	array_thread( purple_guys, ::set_ignoreme, false );
	clearThreatBias( "friendlies_under_unreachable_enemies", "upstairs_window_enemies" );

	// dont want them to move until the lasers have shifted fire
	flag_wait( "lasers_have_moved" );
	wait( 3 );
	
	activate_trigger_with_targetname( "friendlies_storm_second_floor" );
	
	// allow friendlies to be triggered to advance into this room
	flag_set( "player_can_trigger_rubble_attack" );
	
	pacifist_trigger = getent( "second_floor_pacifist_trigger", "script_noteworthy" );
	pacifist_trigger trigger_off();

	flag_wait( "rubble_room_cleared" );

	// spawn the friendlies that run up and breach the second floor door
	flag_set( "second_floor_door_breach_initiated" );

	wait( 1 );
	// clear!
	
	clearGuy = get_closest_colored_friendly( "p", ( 10327.1, -386.339, 236 ) );
	clearGuy.animname = "third_floor_left_guy";
	clearGuy anim_single_solo( clearGuy, "clear" );
	
	flag_clear( "player_can_trigger_rubble_attack" );

	
	// friendlies move to the balcony to shoot the enemies up there	
	activate_trigger_with_targetname( "mg_flank_trigger" );
	setThreatBias( "upstairs_unreachable_enemies", "friendlies_under_unreachable_enemies", 0 );

	fight_across_the_gap_until_the_enemies_die();
	
	// stop spawning the guys on the top floor
	maps\_spawner::kill_spawnerNum( 5 );
	enemies = [];

	window_enemies = getentarray( "window_enemies", "script_noteworthy" );
	enemies = array_combine( enemies, window_enemies );
	
	pacifist_enemies = getentarray( "pacifist_rubble_guys", "targetname" );
	enemies = array_combine( enemies, pacifist_enemies );

	array_thread( enemies, ::die_shortly );

	wait( 1 );

	door_trace_org = getent( "door_trace_org", "targetname" );
	waittill_player_not_looking( door_trace_org.origin );
	thread open_laundrymat();
	
	thread price_talks_to_hq();
	// only get the force color ones so we dont get the door breach guys
	allies = get_all_force_color_friendlies();
		
	// clean these guys so they're like fresh spawns
	array_thread( allies, ::scrub );
	array_thread( allies, ::set_ignoreSuppression, true ); // cant move worth a damn without it!
	restart_price();
	
	level.price set_force_color( "c" );
	
	allies = remove_heroes_from_array( allies );
	
	allies = instantly_set_color_from_array_with_classname( allies, "o", "shotgun" );
	allies = instantly_set_color_from_array_with_classname( allies, "o", "m4grunt" );
	allies = instantly_set_color_from_array( allies, "y" );
	allies = instantly_set_color_from_array( allies, "y" );
	allies = instantly_set_color_from_array( allies, "y" );
	
	// turn 2 of the remaining guys red
	remaining_guys = allies.size;
	if ( remaining_guys > 2 )
	{
		remaining_guys = 2;
	}
	
	for ( i=0; i < remaining_guys; i++ )
	{
		allies = instantly_set_color_from_array( allies, "r" );
	}

	// the rest wait outside as green
	array_thread( allies, ::set_force_color, "g" );
	array_thread( allies, ::set_ignoreall, 1 );
		
	yellow_guys = get_force_color_guys( "allies", "y" );
	orange_guys = get_force_color_guys( "allies", "o" );
	red_guys = get_force_color_guys( "allies", "r" );
	
	array_thread( red_guys, ::replace_on_death );
	array_thread( yellow_guys, ::replace_on_death );
	array_thread( orange_guys, ::replace_on_death );
	
	// the rest of the guys are set to red, to hang back
	// they dont get replaced on death and will be reomved at first convenience
}

price_talks_to_hq()
{
	battlechatter_off( "allies" );

	// Be advised, more enemy troops are converging on the tank. Recommend you get there ASAP!
	radio_dialogue( "get_there_asap" );
	wait( 0.5 );

	// Roger that, we're working on it! Out!
	level.price anim_single_queue( level.price, "working_on_it" );
	
	flag_set( "laundry_room_price_talks_to_hq" );

	battlechatter_on( "allies" );
}

player_mg_reminder()
{
	level endon( "unreachable_apartment_cleared" );
	// Carver use their machine gun!
	level.price anim_single_queue( level.price, "use_their_gun" );
	wait( 4 );


	if ( flag( "unreachable_enemies_under_attack" ) )
		return;

	level endon( "unreachable_enemies_under_attack" );
	for ( ;; )
	{
		for ( i=0; i < 4; i++ )
		{
			if ( player_is_on_mg() )
				return;
			wait( 1 );
		}
		// Carver, use their machine gun!
		level.price anim_single_queue( level.price, "use_their_gun" );
	}
}

player_mg_laser_hint()
{
	if ( flag( "unreachable_apartment_cleared" ) )
		return;

	laser_hint_ent = getent( "laser_hint_ent", "targetname" );
	targ = getent( laser_hint_ent.target, "targetname" );
	
	laser = laser_hint_ent get_laser();	
	laser.origin = laser_hint_ent.origin;
	laser.angles = vectortoangles( targ.origin - laser_hint_ent.origin );
	laser laser_hint_on_mg();
	laser notify( "stop_line" );
	laser delete();
}

laser_hint_on_mg()
{
	level endon( "unreachable_apartment_cleared" );
	for ( ;; )
	{
		if ( player_is_on_mg() )
		{
			self thread modulate_laser();
		}
		
		while ( player_is_on_mg() )
		{
			wait( 0.05 );
		}
		self notify( "stop_line" );
		self laserOff();

		while ( !player_is_on_mg() )
		{
			wait( 0.05 );
		}
	}
}



fight_across_the_gap_until_the_enemies_die()
{
	if ( flag( "unreachable_apartment_cleared" ) )
		return;
	level endon( "unreachable_apartment_cleared" );
		
	wait_until_price_nears_balcony();
	level.price anim_single_queue( level.price, "hit_their_flank" );
	wait( 1 );
	wait_until_player_nears_balcony();
//	thread player_mg_laser_hint();
	if ( !player_is_on_mg() )
	{
		thread player_mg_reminder();
	}

//	flag_wait( "unreachable_enemies_under_attack" );

	// set all the enemies to die eventually	
	upper_floor_enemies = getentarray( "upper_floor_enemies", "script_noteworthy" );
	array_thread( upper_floor_enemies, ::waitSpread_death, 12 );

	for ( i=0; i < 4; i++ )
	{
		if ( player_is_on_mg() )
		{
			break;
		}
		wait( 1 );
	}
	
	// remove the clip that blocks the spot that we need the guy in
	// special behind the wall bonus guy if you get on the MG
	upper_floor_hiding_blocker = getent( "upper_floor_hiding_blocker", "targetname" );
	upper_floor_hiding_blocker connectPaths();
	upper_floor_hiding_blocker delete();
	hiding_guy = spawn_guy_from_targetname( "upper_floor_hiding_spawner" );
	hiding_guy set_force_cover( "hide" );
	hiding_guy thread price_congrates();
	wait( 2.5 );
	if ( isalive( hiding_guy ) )
	{
		if ( player_is_on_mg() )
		{
			// Cut ‘em down!! Shoot ‘em through the wall!!!
			level.price thread anim_single_queue( level.price, "shoot_through_wall" );
		}
		
		hiding_guy delayThread( 10, ::killme );
	}
	
//	delayThread( ::flag_set, 7, "unreachable_apartment_cleared" );
	flag_wait( "unreachable_apartment_cleared" );
}

javelin_guy_spawns()
{
	flag_wait( "contact_on_the_overpado!" );
	wait_until_price_reaches_his_trigger();
	wait_for_friendlies_to_reach_alley_goal();
	
	spawner = getent( "javelin_spawner", "targetname" );
	guy = spawner try_forever_spawn();
	guy thread javelin_guy_runs_in();
}

javelin_guy_runs_in()
{
/#
	if ( level.start_point == "shanty" )
	{
		self endon( "death" );
	}
#/
	self.animname = "javelin_guy";
	self.deathanim = getanim( "death" );
	
	self set_run_anim( "run" );
	self thread magic_bullet_shield();
	self animscripts\shared::placeWeaponOn( self.weapon, "back" );
	level.javelin_guy = self;
	self make_hero();
	model = spawn( "script_model", (0,0,0) );
	model setmodel( "weapon_javelin" );
	model linkto( self, "tag_weapon_right", (0,0,0), (0,0,0) );
	level.javmodel = model;
	
//	self animscripts\shared::placeWeaponOn( "javelin", "right" );


	goal = getent( self.target, "targetname" );
	

	goal anim_reach_solo( self, "hangout_arrival" );
	goal anim_single_solo( self, "hangout_arrival" );

	goal thread anim_loop_solo( self, "hangout_idle", undefined, "stop_looping" );

	flag_set( "jav_guy_ready_for_briefing" );

//	flag_wait( "alley_cleared" );
//	flag_wait( "price_in_alley_position" );
	goal notify( "stop_looping" );
	self stopAnimscripted();

	node = getnode( "jav_drop", "targetname" );
	goal.origin = node.origin;

	self.IgnoreRandomBulletDamage = true;
	self disable_pain();
	
	goal anim_reach_solo( self, "hangout_arrival" );
	goal anim_single_solo( self, "hangout_arrival" );
	goal thread anim_loop_solo( self, "hangout_idle", undefined, "stop_looping" );
	flag_set( "javelin_guy_in_position" );
	
	level.javelin_guy.ignoreme = false;
	level.javelin_guy.threatbias = 2342343;
	level.javelin_guy.health = 1;
	level.javelin_guy.allowDeath = true;
	level.javelin_guy stop_magic_bullet_shield();
	level.javelin_guy add_wait( ::_wait, 16 );
	level.javelin_guy add_wait( ::waittill_msg, "death" );
	do_wait_any();
	
	flag_set( "javelin_guy_died" );	
	thread play_sound_in_space( "bog_a_gm1_westisdown", ( 9153.57, 64.5412, 80 ), true );

	if ( isalive( self ) )
	{
		self dodamage( self.health + 150, (0,0,0) );
	}
	
	disable_auto_adjust_threatbias();
	level.player.threatbias = -450;
	
	
//	self dodamage( self.health + 50, (0,0,0) );
	wait( 2 );
	
	jav = spawn( "weapon_javelin", (0,0,0), 1 ); // 1 = suspended
//	jav.spawnflags = 1;	
//	jav linkto( model, "TAG_ORIGIN", (0,0,0), (0,0,0) );
	jav.origin = model.origin + (0,0,3);
	jav.angles = model.angles;

	jav thread add_jav_glow( "overpass_baddies_flee" );
	org = jav.origin;

	level.javweap = jav;
	wait( 0.25 );
	model delete();	

	autosave_by_name( "javelin_sequence" );
	flag_wait( "pickup_javelin" );
	if ( player_has_javelin() )
	{
		flag_set( "player_has_javelin" );
		return;
	}

	thread price_reminds_player_about_javelin();
	
	objective_add( 4, "active", &"BOG_A_GET_THE_JAVELIN", org );
	objective_current( 4 );
	
	while( !player_has_javelin() )
	{
		wait( 0.05 );
	}
	objective_delete( 4 );
	flag_set( "player_has_javelin" );
	thread price_reminds_player_about_shooting_javelin();
}

price_reminds_player_about_javelin()
{
	assertEx( !player_has_javelin(), "Player got javelin too soon" );
	level endon( "player_has_javelin" );

	hints = [];

	// Carver! Pick up the Javelin so you can take out those tanks!
	hints[ hints.size ] = "pickup_hint_1";

	// Carver! Pick up the Javelin, NOW!
	hints[ hints.size ] = "pickup_hint_2";

	// Carver! Pick up the Javelin!
	hints[ hints.size ] = "pickup_hint_3";

	hint = 0;
	
	for ( ;; )
	{
		wait( randomfloatrange( 8, 12 ) );

		Objective_Ring( 4 );
		level.price anim_single_queue( level.price, hints[ hint ] );

		hint++;
		if ( hint >= hints.size )
			hint = 0;
	}
}

price_reminds_player_about_shooting_javelin()
{
	flag_assert( "overpass_baddies_flee" );
	level endon( "overpass_baddies_flee" );
	level endon( "bmp_got_killed" );

	hints = [];

	// Carver! Get to the second floor and take out those tanks!
	hints[ hints.size ] = "second_floor_hint_1";

	// Hit those targets at the far end of the bridge! Hurry!
	hints[ hints.size ] = "second_floor_hint_2";

	hint = 0;
	
	for ( ;; )
	{
		wait( randomfloatrange( 8, 12 ) );

		Objective_Ring( 4 );
		level.price anim_single_queue( level.price, hints[ hint ] );

		hint++;
		if ( hint >= hints.size )
			hint = 0;
	}
}

open_laundrymat()
{
	flag_clear( "aa_apartment" );
	delaythread( 2, ::autosave_by_name, "javelin_sequence" );

	thread laundryroom_saw_gunner();
	thread javelin_guy_spawns();
	flag_set( "alley_enemies_spawn" );
	// makes guys move into the laundrymat
	activate_trigger_with_targetname( "alley_friendly_trigger" );
	
//	wait_while_enemies_are_alive_near_player();

	clear_promotion_order();
	set_empty_promotion_order( "y" );
	set_empty_promotion_order( "o" );
	set_empty_promotion_order( "g" );
	set_promotion_order( "r", "o" );

	apartment_door = getent( "apartment_door", "targetname" );
	apartment_door playsound( "door_wood_slow_open" );
	apartment_door connectpaths();
	apartment_door rotateyaw( -100, 1, .5, 0 );

	wait( 1 );
	objective_state( 2, "done");
	arcademode_checkpoint( 8, "a" );
	objective_current( 1 );
	
	
	flag_set( "laundrymat_open" );
	
	// disabling the indoor triggers for the apartment, waiting for that to finish
	waittillframeend;
	
	allies = getaiarray( "allies" );
	array_thread( allies, ::disable_cqbwalk );

/*	
	if ( 1 )
	{
		flag_wait( "player_enters_laundrymat" );
//		spawners = getspawnerarray();
//		array_levelthread( spawners, ::deleteEnt );
		axis = getaiarray( "axis" );
		array_levelthread( axis, ::deleteEnt );
		triggers = getentarray( "trigger_multiple", "classname" );
		extra_triggers = getentarray( "trigger_radius", "classname" );
		triggers = array_combine( triggers, extra_triggers );
		for ( i=0; i < triggers.size; i++ )
		{
			if ( isdefined( triggers[ i ].script_color_allies ) )
				continue;
			if ( isdefined( triggers[ i ].script_flag ) )
				continue;
				
			triggers[ i ] delete();
		}
		
		wait( 1.35 );
		level.price set_force_color( "r" );
		flag_wait( "player_leaves_shanty" );
		
		ai = getaiarray( "allies" );
		ai = remove_heroes_from_array( ai );
		array_levelthread( ai, ::deleteEnt );
		
		spawners = getentarray( "bog_friendly_start", "targetname" );
		for ( i = 0; i < spawners.size; i++ )
		{
			spawners[ i ] stalingradspawn();
		}
		return;
	}
*/	
	
	thread player_enters_laundrymat();

}

kick_ac_unit( guy )
{
	ac_unit = getent( "window_ac_unit", "targetname" );
	ac_unit stopLoopSound( "bog_ac_loop" );
	ac_unit playSound( "bog_ac_kick" );
	wait( 1 );
	ac_unit playSound( "bog_ac_crash" );
//	ac_unit delete();
	/*
	target = getent( ac_unit.target, "targetname" );
	force = vectorToAngles( target.origin - ac_unit.origin );
	force = vectorScale( force, 100 );
	ac_unit physicsLaunch( guy.origin + (0,0,32), force );
	*/
}

seetag()
{
	for ( ;; )
	{
		maps\_debug::drawTag( "tag_origin" );
		wait( 0.05 );
	}
}

laundryroom_saw_gunner()
{
	saw_gunner = spawn_guy_from_targetname( "saw_gunner" );
	level.mark = saw_gunner;
	saw_gunner thread magic_bullet_shield();
	saw_gunner make_hero();
	saw_gunner.goalradius = 4;
	saw_gunner.interval = 0;

	trigger = getent( "friendly_enters_laundrymat", "targetname" );
	node = getnode( trigger.target, "targetname" );

	
	ac_unit = getent( "window_ac_unit", "targetname" );
	ac_unit playLoopSound( "bog_ac_loop" );
//	ac_unit thread seetag();
	ac_unit.animname = "ac";
	ac_unit assign_animtree();
	node anim_start_pos_solo( ac_unit, "setup" );

	flag_wait( "player_nears_laundrymat" );
	
	thread helicopter_flies_by_overhead( "alley_heli", 0, 		135, 95 );
	thread helicopter_flies_by_overhead( "alley_heli", 1, 		135, 95 );
	thread helicopter_flies_by_overhead( "alley_heli", 30, 	135, 95 );
	thread helicopter_flies_by_overhead( "alley_heli", 31, 	135, 95 );
	thread helicopter_flies_by_overhead( "alley_heli", 70, 	135, 95 );
	thread helicopter_flies_by_overhead( "alley_heli", 71, 	135, 95 );

	saw_gunner.animname = "saw";
	

	
	team = [];
	team[ team.size ] = ac_unit;
	team[ team.size ] = saw_gunner;
	
	mark_ac_block = getent( "mark_ac_block", "targetname" );
	mark_ac_block connectpaths();
	mark_ac_block delete();
	
	node anim_reach_solo( saw_gunner, "setup" );
	saw_gunner.goalradius = 4;

	delaythread( 0, ::autosave_by_name, "saw_gunner" );
	node anim_single( team, "setup" );
	
	saw_gunner.interval = 96;
	saw_gunner setgoalpos( saw_gunner.origin );
	saw_gunner.goalradius = 32;

	saw_gunner thread saw_gunner_chatter();
	node thread anim_loop_solo( saw_gunner, "fire_loop", undefined, "stop_loop" );
	wait( 5 );
	
	node notify( "stop_loop" );

	saw_gunner.fixednode = false; // so he uses cover node
	flag_wait( "friendlies_charge_alley" );
	saw_gunner.fixednode = true;
}

saw_gunner_chatter()
{
	battlechatter_off( "allies" );
	flag_wait( "laundry_room_price_talks_to_hq" );
	self anim_single_solo( self, "ton_of_them" );
//	wait( 0.5 );
	level.price anim_single_queue( level.price, "shut_up" );
	wait( 0.5 );
	self anim_single_solo( self, "suppressing_fire" );
	battlechatter_on( "allies" );
}

player_enters_laundrymat()
{
	// turns on a badplace so AI dont run out the door they shouldnt
//	thread toggle_alley_badplace();
	
//	level.respawn_spawner = getent( "alley_respawn", "targetname" );
	
	// set the friendlies to the appropriate nodes.
	activate_trigger_with_targetname( "alley_friendly_trigger" );

	flag_wait( "player_enters_alley" );
	
	green_guys = get_force_color_guys( "allies", "g" );
	array_thread( green_guys, ::die_asap );
	
	total_red_guys = get_force_color_guys( "allies", "r" ).size;
	
	for ( i = total_red_guys; i < 2; i++ )
	{
		promote_nearest_friendly( "o", "r" );
		spawn_reinforcement( undefined, "o" );
	}
	
//	wait_until_alley_is_clear_of_enemies();
	// friendlies move into the alley
	thread friendlies_charge_alley_early();
	
	flag_wait_or_timeout( "friendlies_charge_alley", 45 );
	flag_set( "friendlies_charge_alley" );

	activate_trigger_with_targetname( "friendly_alley_charge_trigger" );

	// blocks friendlies from running the dumb looking way
	alley_blocker = getent( "friendly_alley_blocker", "targetname" );
	alley_blocker delete();

	// kill the playerseeker spawners
	maps\_spawner::kill_spawnerNum( 10 );

	// kill the random spawners from around the back of the alley
	maps\_spawner::kill_spawnerNum( 9 );
	
	// kill the rocket guys on the roof
	alley_roof_guys = getentarray( "alley_roof_guy", "script_noteworthy" );
	for ( i=0; i < alley_roof_guys.size; i++ )
	{
		alley_roof_guy = alley_roof_guys[ i ];
		if ( isalive( alley_roof_guy ) )
		{
			alley_roof_guy dodamage( alley_roof_guy.health + 100, (0,0,0) );
			wait( randomfloatrange( 0.5, 1.5 ) );
		}
	}

	axis = getaiarray( "axis" );
	node = getnode( "enemy_alley_node", "targetname" );
	array_thread( axis, ::move_in_on_goal, node );

	// gets set by the objective_event 	
//	flag_wait( "alley_cleared" );
	flag_set( "price_in_alley_position" );
	
	thread wait_for_fence_guys_to_be_drafted();
	wait_until_deathflag_enemies_remaining( "alley_cleared", 6 );
//	wait_until_price_reaches_his_trigger();
//	wait_for_friendlies_to_reach_alley_goal();

	//activate_trigger_with_targetname( "alley_circle_trigger_old" );

//	allies = getaiarray( "allies" );
//	allies = remove_heroes_from_array( allies );
//	array_thread( allies, ::disable_ai_color );
//	array_thread( allies, ::set_goal_entity, level.player );

	battlechatter_off( "allies" );
	
	// squad regroup on me!
//	level.price thread anim_single_queue( level.price, "squad_regroup" );
	
	
	// friendlies fill up the alley
//	activate_trigger_with_targetname( "alley_clear_trigger" );
	
	
//	wait( 1.5 );
//	regroup_org = getent( "price_regroup_origin", "targetname" );
//	objective_add( 3, "active", "Regroup with Captain Price.", regroup_org.origin );
//	objective_current( 3 );
	
	
//	price_circle_node = getnode( "price_circle_node", "targetname" );
//	price_circle_node anim_reach_and_approach_solo( level.price, "javelin_briefing" );
//	price_circle_node thread anim_loop_solo( level.price, "javelin_briefing_idle", undefined, "stop_idle" );
	
	/*
	flag_wait( "javelin_guy_in_position" );
	while ( distance( regroup_org.origin, level.player.origin ) > 290 )
	{
		wait( 0.05 );
	}
	*/

//	objective_state( 3, "done");
//	objective_current( 1 );

/#
	if ( level.start_point == "shanty" )
	{
//		price_circle_node notify( "stop_idle" );
		wait_for_fence_guys_to_be_drafted();
		shanty_opens();
		return;
	}
#/

	wait_for_fence_guys_to_be_drafted();

	defend_the_roof_with_javelin();
}

price_responds_to_overpass()
{
	self waittill( "javelin_briefing" );
	level.price setgoalpos( level.price.origin );
	level.price.goalradius = 32;
	level.price allowedstances( "crouch" );
	level.price allowedstances( "stand", "crouch", "prone" );
	wait( 3 );
	level.price.goalradius = 512;
}


right_away_line()
{
	timer = debugvar( "timer1", 4.8 );
	wait( timer );

	// right away s--
	level.javelin_guy thread anim_single_solo( level.javelin_guy, "right_away" );
}

bridge_wave_spawner_think()
{
	self endon( "death" );
	self.ignoreme = true;
	self.dontshootwhilemoving = true;
	self.disablearrivals = true;
	
	while ( self.a.lastshoottime == 0 )
	{
		wait( 0.05 );
	}
	wait( 1.2 );
	flag_set( "overpass_guy_attacks!" );
	self.ignoreme = false;
	
	flag_wait( "javelin_guy_in_position" );
	self.baseAccuracy = 1000;
	self.accuracy = 1000;
	wait( randomfloat( 0.5 ) );
	self shoot();
	flag_wait( "javelin_guy_died" );	
	self.baseAccuracy = 1;
	self.accuracy = 1;
}	

friendly_overpass_dialogue_response()
{
	flag_wait( "overpass_guy_attacks!" );
	flag_clear( "aa_alley" );

	allies = getaiarray( "allies" );
	allies = remove_heroes_from_array( allies );
	friendly = getclosest( level.player.origin, allies );
	friendly.animname = "guy_one";

	flag_set( "contact_on_the_overpado!" );

	
	autosave_by_name( "contact_on_the_overpass" );

	// Contact on the overpass!
	friendly anim_single_solo( friendly, "contact_overpass" );
}

defend_the_roof_with_javelin()
{
//	set_all_ai_ignoreme( true );
//	level.player.ignoreme = true;

	flag_init( "bmps_are_dead" );
	// enemies attack from the bridge
	bridge_wave_spawners = getentarray( "bridge_wave_spawner", "script_noteworthy" );
	array_thread( bridge_wave_spawners, ::add_spawn_function, ::bridge_wave_spawner_think );

	initial_contact_spawners = getentarray( "initial_contact_spawner", "script_noteworthy" );
	array_thread( initial_contact_spawners, maps\_spawner::flood_spawner_think );
	
	thread overpass_baddies_attack();		

	timer = gettime();
//	price_circle_node = getnode( "price_circle_node", "targetname" );
//	price_circle_node notify( "stop_idle" );

	level.brieftime = gettime();
//	price_circle_node thread price_responds_to_overpass();

	set_all_ai_ignoreme( false );
	level.player.ignoreme = false;

	thread friendly_overpass_dialogue_response();

	wait( 15 );
	flag_wait( "jav_guy_ready_for_briefing" );

	// Private Carver! UAV recon's spotted mechanized infantry coming this way!
	// Get on the roof with Rusedski and hit 'em with the Javelin!
	level.price thread anim_single_solo( level.price, "javelin_briefing" );
	
	thread right_away_line();
	
	flag_wait( "javelin_guy_died" );	
	arcademode_checkpoint( 3.0, "b" );
	autosave_by_name( "javelin_defense_begins" );

	wait( 1.5 );	
	activate_trigger_with_targetname( "allies_prep_for_fence" );

	// Carver! Pick up the Javelin! Get to the second floor and take out those APCs!!
	level.price anim_single_queue( level.price, "get_jav" );
	flag_set( "pickup_javelin" );
	
	allies = getaiarray( "allies" );
//	allies = remove_heroes_from_array( allies );
	array_thread( allies, ::take_cover_against_overpass );

	allies = remove_all_animnamed_guys_from_array( allies );
	allies = remove_heroes_from_array( allies );

	roof_guy = getClosest( level.player.origin, allies );
	level.javelin_helper = roof_guy;
	roof_guy thread magic_bullet_shield();
	roof_guy make_hero();
	roof_guy.animname = "generic";
	roof_node = getnode( "friendly_javelin_node", "targetname" );
	roof_guy setgoalnode( roof_node );
	roof_guy.goalradius = 64;

	battlechatter_on( "allies" );
	
	delaythread( 3, ::set_flag_when_bmps_are_dead );

	/#
	heroes = get_heroes();
	assertex( heroes.size == 5, "Should be 5 heroes" );
	#/
	
	// stops any incoming guys from spawning
	maps\_colors::kill_color_replacements();

	flag_wait( "player_has_javelin" );	


	apartment_door = getent( "apartment_door", "targetname" );
	apartment_door rotateyaw( 100, 1, .5, 0 );
	
	thread update_obj_on_dropped_jav( roof_node.origin );

	// Hit those vehicles with the Javelin! Or something
	level.price delaythread( 1, ::anim_single_queue, level.price, "second_floor_hint_2" );
	
	objective_add( 4, "active", &"BOG_A_DESTROY_THE_ARMORED_VEHICLES", roof_node.origin );
	objective_current( 4 );
	
//	thread drop_javelin( ( 8573, -507, 212 ) );

//	thread announce_backblast();

	flag_wait( "overpass_baddies_flee" );
	
	axis = getaiarray( "axis" );
	array_thread( axis, ::flee_overpass );

	// kill off excess friendlies
	allies = getaiarray( "allies" );
	allies = remove_heroes_from_array( allies );
	
	
	index = 0;
	for ( i = 0; i < 40; i++ )
	{
		if ( getaiarray( "allies" ).size <= 5 )
			break;
			
		guy = allies[ index ];
		guy disable_replace_on_death();
		guy dodamage( guy.health + 150, (0,0,0) );
		index++;
	}
	
	/#
	assertex( getaiarray( "allies" ).size <= 5, "Too many allies existed for shanty run" );
	#/
	
	flag_wait( "bmps_are_dead" );
	enable_auto_adjust_threatbias();
	wait( 1 );	
	objective_state( 4, "done" );
	objective_current( 1 );
	arcademode_checkpoint( 10, "c" );

	
	thread shanty_opens();

	flag_wait( "all_bmps_dead" );
	wait( 2 );
	roof_guy waittill_empty_queue();
	if ( isdefined( roof_guy.magic_bullet_shield ) )
		roof_guy stop_magic_bullet_shield();
	roof_guy unmake_hero();
}

flee_overpass()
{
	nodes = getnodearray( "bridge_flee_node", "targetname" );
	node = random( nodes );
	self setgoalnode( node );
	self.goalradius = 64;
	self endon( "death" );
	wait( randomfloat( 3.5 ) );
	self.ignoreme = true;
}

shanty_opens()
{
	magic_rpg_triggers = getentarray( "magic_rpg_trigger", "targetname" );
	array_thread( magic_rpg_triggers, ::magic_rpg_trigger );

	// setup a flare for later in the shantytown
	thread do_in_order( ::flag_wait, "shanty_flare_trigger", maps\_flare::flare_from_targetname, "shanty_flare" );
	
	if ( isalive( level.javelin_guy ) )
	{
		assertEx( level.start_point == "shanty", "Didnt come from shanty start?" );
		level.javelin_guy stop_magic_bullet_shield();
		level.javelin_guy delete();
	}
	autosave_by_name( "shanty_opens" );

/*
	shanty_fence = getent( "shanty_fence", "targetname" );
	shanty_fence connectPaths();
	shanty_fence delete();
*/

	// clear the current colors so backhalf doesn't have residual colors
	level.currentColorForced[ "allies" ] = [];
	activate_trigger_with_targetname( "allies_prep_for_shanty" );

	allies = getaiarray( "allies" );
	array_thread( allies, ::set_force_color, "o" );
	shanty_fence_cut();
	delaythread( 1.1, maps\_flare::flare_from_targetname, "alley_flare" );

	
	allies = getaiarray( "allies" );
	

	level.ending_bog_redshirts = 0;
	array_thread( allies, ::enable_cqbwalk );
	array_thread( allies, ::shanty_allies_cqb_through );
		
	/#		
	count = 0;
	allies = getaiarray( "allies" );
	
	for ( i=0; i < allies.size; i++ )
	{
		guy = allies[ i ];
		// the AI try to keep with the player in the shanty town by slowing down or speeding up if need be
		if ( guy is_hero() )
			continue;

		if ( isdefined( guy.magic_bullet_shield ) )
			guy stop_magic_bullet_shield();
		if ( isdefined( guy.script_forcecolor ) && guy.script_forcecolor == "r" )
			continue;

		if ( level.start_point == "shanty" && count >= 1 )
		{
			// dont need extra guys for shanty run
			guy disable_ai_color();
			guy delete();
		}
		count++;
	}
	#/

		
	/#
	red = get_force_color_guys( "allies", "r" );
	orange = get_force_color_guys( "allies", "o" );
	assertex( red.size == 2, "Should be 2 red guys" );
	assertex( orange.size <= 3, "Should be up to 3 orange guys guys" );
	#/
	

	
	flag_set( "shanty_open" );
	thread do_in_order( ::flag_wait, "start_shanty_run", ::activate_trigger_with_targetname, "backhalf_friendly_start_trigger" );
	
	// make sure this happens after shanty ai think/sprint
	bog_ambient_spawners = getentarray( "bog_ambient_spawner", "targetname" );
	array_thread( bog_ambient_spawners, ::add_spawn_function, ::bog_ambient_fighting );
	array_thread( bog_ambient_spawners, ::spawn_ai );

	shanty_run_trigger = getent( "shanty_run_trigger", "targetname" );
	shanty_run_trigger.trigger_num = 1;
	level.shanty_timer = 0;
	level.player.trigger_num = 0;
//	shanty_run_trigger thread shanty_run();
	shanty_run_trigger thread shanty_run_drop_weapon();
	
	thread radio_heavy_fire_dialogue();
	
	flag_wait( "shanty_progress" );
	
	activate_trigger_with_targetname( "friendly_tank_defend_trigger" );
	
	rpgs = getentarray( "magic_shanty_rpg", "targetname" );
	array_thread( rpgs, ::magic_rpgs_fire_randomly );
	
	allies = getaiarray( "allies" );
	allies = remove_heroes_from_array( allies );
	ai = getClosest( level.player.origin, allies );
	assertEx( isalive( ai ), "Couldn't find a friendly for sequence" );
	ai.animName = "generic";
	
	// The tank’s on the other side of that overpass! Come on - let’s get back to the squad!
 	ai thread anim_single_solo( ai, "other_side" );
	thread this_way_trigger();
/*
	
	trigger = getent( "shanty_damage_trigger", "targetname" );
	trigger waittill( "trigger" );
	friendly = get_closest_colored_friendly( "y", trigger.origin );
	friendly.animname = "guy_two";
	wait( 1 );
	friendly anim_single_solo( friendly, "contact_left" );
	
	flag_wait( "entered_bog" );
	objective_state( 1, "done" );
//	mortar_trigger = random( getentarray( "mortar_trigger", "targetname" ) );
//	mortar_targets = getent( mortar_trigger
	objective_add( 5, "active", "ELIMINATE THE ENEMY MORTAR UNITS. (3 REMAINING)", (0,0,0) );
	objective_current( 5 );

	wait_until_mortars_are_dead();
*/

	flag_wait( "coming_from_south" );
//	iprintlnbold( "No scripting beyond this point" );
	flag_set( "kill_bog_ambient_fighting" );
	
	ai = getaiarray( "allies" );
	array_thread( ai, ::set_fixednode_true );
	
	// give the guys a chance to be kilt
	waittillframeend;
	maps\bog_a_backhalf::start_bog_backhalf();
}

this_way_trigger()
{
	flag_wait( "this_way" );

	// This way let’s go!
//	radio_dialogue_queue( "this_way" );
}

radio_heavy_fire_dialogue()
{
	wait( 4 );
	// Bravo Six we’re taking heavy fire on our position north of the overpass! Where the hell are you?!
	radio_dialogue( "where_are_you" );	

	// We’re almost there! Hang on!
	level.price thread anim_single_queue( level.price, "almost_there" );	
}

run_until_ambush()
{
//	level endon( "	_fire" );	
	self endon( "stop_running_to_node" );
	self allowedstances( "stand" );
	self endon( "going_to_link_node" );
	ent = self;
	for ( ;; )
	{
		ent = getent( ent.target, "targetname" );
		self.goalradius = ent.radius;
		self setgoalpos( ent.origin );
		self waittill( "goal" );
		if ( !isdefined( ent.target ) )
			break;
	}

	flag_wait( "friendlies_take_fire" );	
}

stop_shield_when_player_runs_street()
{
	self endon( "death" );
	if ( is_hero() )
		return;
		
	self thread magic_bullet_shield();
	flag_wait( "player_enters_the_fray" );
	if ( isdefined( self.magic_bullet_shield ) )
		self stop_magic_bullet_shield();
}


run_down_street()
{
	spawn_failed( self );
	self.fixedNode = false;
	thread replace_on_death();
	thread stop_shield_when_player_runs_street();
	
	self endon( "death" );
//	self endon( "stop_running_to_node" );
	self.interval = 0;
	self.pushable = false;
	self.dontshootwhilemoving = true;
	self.IgnoreRandomBulletDamage = true;
	self.moveplaybackrate = self.script_dot;

	run_until_ambush();
	self.interval = 96;
	self.pushable = true;

	animscripts\init::set_anim_playback_rate();
	self allowedstances( "stand", "crouch", "prone" );
	self.ignoreSuppression = true;

	forward = anglestoforward( self.angles );
	vec = vectorScale( forward, 130 );
	timer = gettime() + 1000;
	self setgoalpos( self.origin + vec );
	self.goalradius = 8;
	self waittill( "goal" );
	remaining_time = ( timer - gettime() ) * 0.001;
	if ( remaining_time > 0 )
		wait( remaining_time );
	
	self.pacifist = false;
	self.goalradius = 4000;	

	if ( !flag( "friendlies_move_up_the_bridge" ) )
	{
		assertEx( !isdefined( self.script_forceColor ), "Friendlies shouldnt have forcecolor yet" );
		// some guys get assigned to 
		bridge_volume = getent( "bridge_volume", "targetname" );
		if ( !isdefined( self.dont_use_goal_volume ) )
		{
			// trigger at the end of the bridge stops the from using the goal volume as they leave it (the volume)
			self setgoalvolume( bridge_volume );
		}
		
		while ( !isdefined( self.node ) )
			wait( 0.05 );
		
		self setgoalnode( self.node );
		self.goalradius = 32;
		self waittill( "goal" );
		self.reached_bridge_flee_spot = true;
	}
	thread set_engagement_to_closer();
	self.fixedNode = true;
	self.dontshootwhilemoving = undefined;

	if ( self == level.price )
		return;
		
	flag_wait( "friendlies_move_up_the_bridge" );	
	self.pacifist = false;
}

apartment_rubble_helicopter()
{
	flag_wait( "player_attacks_unreachable_guys_second_floor" );
	thread helicopter_flies_by_overhead( "apartment_heli", 0, 95, 95 );
	wait( 1 );
	flag_wait( "player_attacks_unreachable_guys" );
	thread helicopter_flies_by_overhead( "apartment_heli2", 0, 95, 95 );
	wait( 5 );
	thread helicopter_flies_by_overhead( "apartment_heli", 0, 95, 95 );
	wait( 1 );
	thread helicopter_flies_by_overhead( "apartment_heli2", 0, 95, 95 );
}

price_directs_players_upstairs()
{
	level endon( "melee_sequence_begins" );
	if ( flag( "melee_sequence_begins" ) )
		return;

	trigger = getent( "price_sends_you_upstairs_trigger", "targetname" );
	trigger waittill( "trigger" );
	
	for ( ;; )
	{
		// Carver, you and Roycewicz head upstairs. We’ll cover this entrance. Go!
		level.price thread anim_single_queue( level.price, "head_upstairs" );
		wait( randomfloatrange( 12, 14 ) );
	}
}

helicopters_fly_by()
{
	thread helis_ambient();

	trigger = getent( "armada_trigger", "targetname" );
	trigger waittill( "trigger" );

	trigger = getent( "vehicle_crash_trigger", "targetname" );
	trigger thread cobra_crash();

	thread helicopters_flies_by_overhead( "intro_heli5", 0, 	135, 95 );
	thread helicopter_flies_by_overhead( "heli_crash", 0, 		135, 95 );
}

restart_price()
{
	level.price thread magic_bullet_shield();
	level.price make_hero();
}

runout()
{
	var = [];
	wait( 5 );
	for ( ;; )
	{
		for ( i=0;i<500;i++)
		var[ var.size ] = 5;
		wait( 0.05 );
	}
}

bcs_disabler()
{
	wait( 0.05 );
	setdvar( "bcs_enable", "off" );
}

move_in_on_goal( node )
{
	self endon( "death" );
	wait( 10 );
	self.goalradius = node.radius;
	self.goalheight = 64;
	self setgoalnode( node );
	mindist = 300;
	for ( ;; )
	{
		wait( randomfloatrange( 3, 11 ) );
		dist = distance( node.origin, self.origin ) - 125;
		
		if ( dist < mindist )
		{
			dist = mindist;
		}
		
		self.goalradius = dist;
	}
}

/*
lose_goal_volume_trigger
*/

music()
{
	shantyMusicTrig = getent( "shantyMusicTrig", "targetname" );	
	shantyMusicTrig waittill( "trigger" );
	MusicPlayWrapper( "bog_a_shantytown" ); 
	
	bogMusicTrig = getent( "bogMusicTrig", "targetname" );	
	bogMusicTrig waittill( "trigger" );
	musicStop( 3 );
	wait 3.25;
	MusicPlayWrapper( "bog_a_tankdefense" ); 
}

shanty_run_drop_weapon()
{
	for ( ;; )
	{
		self waittill( "trigger", other );
		if ( !isalive( other ) )
			continue;
		other thread ignore_triggers( 1.0 );
		if ( other == level.player )
			break;
	}

	weapons = getentarray( "weapon_javelin", "classname" );
	array_thread( weapons, ::self_delete );

	if ( !player_has_javelin() )
		return;
	
	hasGren = false;
	tookWeapon = false;
	weaponList = level.player GetWeaponsListPrimaries();
	tookMainWeapon = false;
	
	for ( i=0; i < weaponList.size; i++ )
	{
		if ( issubstr( weaponList[ i ], "avelin" ) )
		{
			tookWeapon = true;
			if ( issubstr( level.player GetCurrentWeapon(), "avelin" ) )
			{
				tookMainWeapon = true;
			    level.player DisableWeapons();
			    wait( 1.5 );
			}
			level.player takeweapon( "javelin" );
			continue;
		}
		
		if ( weaponList[ i ] == "m4_grenadier" )
		{
			hasGren = true;
		}
	}
	
	if ( !tookWeapon )
	{
		return;
	}

    level.player EnableWeapons();
	
	if ( !hasGren )
	{
		level.player giveWeapon("m4_grenadier");
	}

	if ( tookMainWeapon )
		level.player switchToWeapon( "m4_grenadier" );
}

wait_then_go_to_target()
{
	self endon( "death" );
	wait( 2 );
	maps\_spawner::go_to_node();
}

grenade_launcher_hint( nothing )
{
	flag_wait( "nightvision_on" );	
	wait( 1.5 );
	display_hint( "grenade_launcher" );
}
