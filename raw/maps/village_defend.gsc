/****************************************************************************

Level: 		The Village (village_defend.bsp)
Location:	Northern Azerbaijan
Campaign: 	British SAS Woodland Scheme
Objectives:	1. Obtain new orders from Captain Price. 
			2. Take up a defensive position along the ridgeline. 
			3. Defend the southern hill approach.
			4. Fall back and defend the southwestern approaches. 
			5. Use the detonators to delay the enemy attack.
			6. Get the Javelin.
			7. Destroy the incoming armor.
			8. Survive until the helicopter arrives.
			9. Destroy the enemy attack helicopter. 
			10. Board the rescue helicopter before it leaves.

*****************************************************************************/

#include common_scripts\utility;
#include maps\_utility;
#include maps\_hud_util;
#include maps\_vehicle;
#include maps\_anim;
#include maps\village_defend_code;

main()
{
	preCacheModel( "weapon_c4" );
	preCacheModel( "projectile_cbu97_clusterbomb" );
	preCacheModel( "tag_origin" );
	preCacheModel( "weapon_javelin_obj" );
	preCacheModel( "vehicle_av8b_harrier_jet" );
	
	preCacheItem( "c4" );
	preCacheItem( "javelin" );
	preCacheItem( "airstrike_support" );
	preCacheItem( "flash_grenade" );
	
	precacheshader( "popmenu_bg" );
	precacheshader( "compass_objpoint_airstrike" );
	precacheShader( "hud_dpad" );
	precacheShader( "hud_arrow_down" );
	
	precacheShader( "white" );
	precacheShader( "black" );
	precacheShader( "hud_temperature_gauge" );
	
	precachestring( &"VILLAGE_DEFEND_HINT_SPINUP_MINIGUN" ); 
	precachestring( &"VILLAGE_DEFEND_HELICOPTER_EXTRACTION" ); 
	precacheString( &"VILLAGE_DEFEND_CASREADY" );
	precacheString( &"SCRIPT_PLATFORM_HINT_GET_DETONATOR" );
	precachestring( &"VILLAGE_DEFEND_TAKE_UP_A_DEFENSIVE_POSITION" );
	precachestring( &"VILLAGE_DEFEND_DEFEND_THE_SOUTHERN_HILL" );
	precachestring( &"VILLAGE_DEFEND_FALL_BACK_AND_DEFEND" );
	precachestring( &"VILLAGE_DEFEND_USE_THE_DETONATORS_IN" );
	precachestring( &"VILLAGE_DEFEND_FALL_BACK_TO_THE_FARM" );
	precachestring( &"VILLAGE_DEFEND_GET_THE_JAVELIN_IN_THE" );
	precachestring( &"VILLAGE_DEFEND_SURVIVE_UNTIL_THE_HELICOPTER" );
	precachestring( &"VILLAGE_DEFEND_GET_TO_THE_LZ" );
	precachestring( &"VILLAGE_DEFEND_BOARD_THE_HELICOPTER" );
	precachestring( &"VILLAGE_DEFEND_USE_THE_DETONATORS_IN1" );
	precachestring( &"VILLAGE_DEFEND_DESTROY_THE_INCOMING" );
	precachestring( &"VILLAGE_DEFEND_OBTAIN_NEW_ORDERS_FROM" );
	precachestring( &"VILLAGE_DEFEND_YOU_DIDNT_REACH_THE_HELICOPTER" );
	precachestring( &"VILLAGE_DEFEND_CLOSE_AIR_SUPPORT_STANDING" );
	precachestring( &"VILLAGE_DEFEND_CLOSE_AIR_SUPPORT_STANDING_PC" );
	precachestring( &"VILLAGE_DEFEND_INTRO_1" );
	precachestring( &"VILLAGE_DEFEND_INTRO_2" );
	precachestring( &"VILLAGE_DEFEND_INTRO_3" );
	precachestring( &"VILLAGE_DEFEND_INTRO_4" );
	precachestring( &"VILLAGE_DEFEND_INTRO_5" );
	precachestring( &"VILLAGE_DEFEND_DESTROY_THE_INCOMING1" );
	precachestring( &"VILLAGE_DEFEND_AIRSTRIKE_UNAVAIL" );
	precachestring( &"SCRIPT_PLATFORM_SPOOL_MINIGUN" );
	
	precacherumble( "minigun_rumble" );
	
	set_console_status();

	//add_start( "cobras", ::start_cobras );
	//add_start( "end", ::start_end );
	add_start( "southern_hill", ::start_southern_hill, &"STARTS_SOUTHERNHILL" );
	add_start( "minigun_fallback", ::start_minigun_fallback, &"STARTS_MINIGUNFALLBACK" );
	add_start( "minigun", ::start_minigun, &"STARTS_MINIGUN" );
	add_start( "helidrop", ::start_helidrop, &"STARTS_HELIDROP" );
	add_start( "clackers", ::start_clackers, &"STARTS_CLACKERS" );
	add_start( "field_fallback", ::start_field_fallback, &"STARTS_FIELDFALLBACK" );
	add_start( "javelin", ::start_javelin, &"STARTS_JAVELIN" );
	add_start( "final_battle", ::start_final_battle, &"STARTS_FINALBATTLE" );
	add_start( "seaknight", ::start_seaknight, &"STARTS_SEAKNIGHT1" );
	default_start( ::start_village_defend );
	
	createthreatbiasgroup( "player" );
	
	level.weaponClipModels = [];
	level.weaponClipModels[ 0 ] = "weapon_ak47_clip";
	level.weaponClipModels[ 1 ] = "weapon_saw_clip";
	level.weaponClipModels[ 2 ] = "weapon_g36_clip";
	level.weaponClipModels[ 3 ] = "weapon_ak74u_clip";
	level.weaponClipModels[ 4 ] = "weapon_dragunov_clip";
	level.weaponClipModels[ 5 ] = "weapon_mp5_clip";
	level.weaponClipModels[ 6 ] = "weapon_m16_clip";
	
	maps\_t72::main( "vehicle_t72_tank_woodland" );
	maps\_mi17::main( "vehicle_mi17_woodland_fly_cheap" );
	//maps\_mig29::main( "vehicle_mig29_desert" );
	maps\_seaknight_village_defend::main( "vehicle_ch46e" );
	thread maps\_pipes::main();
	thread maps\_leak::main();
	maps\_load::set_player_viewhand_model( "viewhands_player_sas_woodland" );
	
	maps\village_defend_fx::main();
	maps\village_defend_anim::main();
	maps\_load::main();	
	maps\_javelin::init();
	
	level thread maps\village_defend_amb::main();

	level.killzoneBigExplosion_fx = loadfx( "explosions/artilleryExp_dirt_brown_low" );
	level.killzoneMudExplosion_fx = loadfx( "explosions/grenadeExp_mud_1" );
	level.killzoneDirtExplosion_fx = loadfx( "explosions/grenadeExp_dirt_1" );
	level.killzoneFuelExplosion_fx = loadfx( "explosions/grenadeExp_fuel" );

	level.air_support_fx_yellow = loadfx( "misc/ui_pickup_available" );
	level.air_support_fx_red 	= loadfx( "misc/ui_pickup_unavailable" );

	killzoneFxProgram();

	maps\createart\village_defend_art::main();	

	maps\_compass::setupMiniMap("compass_map_village_defend");
	
	level.price = getent( "price", "targetname" );
	level.price make_hero();
	level.price.animname = "price";
	
	level.gaz = getent( "redshirt2", "targetname" );
	level.gaz make_hero();
	level.gaz.animname = "gaz";
	
	level.redshirt = getent( "redshirt1", "targetname" );
	
	battlechatter_off( "allies" );
	battlechatter_off( "axis" );
	
	setdvar( "village_defend_one_minute", "0" );
	
	flag_init( "intro_tank_fire_authorization" );
	flag_init( "church_tower_explodes" );
	flag_init( "stop_ambush_music" );
	
	flag_init( "objective_price_orders_southern_hill" );
	flag_init( "objective_player_on_ridgeline" );
	flag_init( "objective_price_on_ridgeline" );
	flag_init( "objective_on_ridgeline" );
	flag_init( "objective_price_orders_minigun" );
	flag_init( "objective_player_uses_minigun" );
	flag_init( "objective_player_at_vantage_point" );

	flag_init( "price_ordered_hill_detonation" );	
	flag_init( "southern_hill_action_started" );
	flag_init( "southern_hill_killzone_detonate" );
	flag_init( "southern_mg_openfire" );
	
	flag_init( "southern_hill_smoked" );
	flag_init( "southern_hill_smoke_entry" );
	flag_init( "enemy_breached_wire" );
	
	flag_init( "ridgeline_targeted" );
	flag_init( "ridgeline_unsafe" );
	
	flag_init( "disable_overheat" );
	
	flag_init( "helidrop_started" );
	flag_init( "objective_minigun_baglimit_done" );
	flag_init( "divert_for_clacker" );
	flag_init( "stop_minigun_fallback_shouting" );
	
	flag_init( "objective_detonators" );
	flag_init( "detonators_activate" );
	flag_init( "got_the_clacker" );
	flag_init( "clacker_has_been_exercised" );
	
	flag_init( "crashsite_exploded" );
	flag_init( "cliffside_exploded" );
	flag_init( "nearslope_exploded" );
	flag_init( "farslope_exploded" );
	flag_init( "clacker_far_and_near_slope_done" );
	
	flag_init( "spawncull" );
	flag_init( "player_entered_clacker_house_top_floor" );
	
	flag_init( "storm_the_tavern" );
	flag_init( "player_running_to_farm" );
	flag_init( "fall_back_to_barn" );
	flag_init( "farm_reached" );
	flag_init( "objective_armor_arrival" );

	flag_init( "got_the_javelin" );
	flag_init( "objective_all_tanks_destroyed" );
	flag_init( "kill_jav_glow" );
	
	flag_init( "start_final_battle" );
	flag_init( "return_trip_begins" );
	flag_init( "airstrikes_ready" );
	flag_init( "falcon_one_finished_talking" );
	
	flag_init( "engage_delaying_action" );
	
	flag_init( "objective_get_to_lz" );
	flag_init( "rescue_chopper_ingress" );
	
	flag_init( "seaknight_can_be_boarded" );
		
	flag_init( "lz_reached" );
	
	flag_init( "no_more_grenades" );
	
	flag_init( "player_made_it" );
	flag_init( "player_made_it_with_rescue" );
	
	flag_init( "minigun_lesson_learned" );
	
	flag_init( "all_fake_friendlies_aboard" );
	flag_init( "all_real_friendlies_on_board" );
	flag_init( "seaknight_guards_boarding" );
	flag_init( "seaknight_unboardable" );
	
	flag_init( "aa_southernhill" );
	flag_init( "aa_minigun" );
	flag_init( "aa_detonators" );
	flag_init( "aa_fallback" );
	flag_init( "aa_javelin" );
	flag_init( "aa_returntrip" );
	
	flag_init( "airstrike_in_progress" );
	
	if (level.gameSkill == 0)
	{
		level.southernHillAdvanceBaglimit = 4;
		level.minigunBreachBaglimit = 4;
	}
	
	if (level.gameSkill == 1)
	{
		level.southernHillAdvanceBaglimit = 6;
		level.minigunBreachBaglimit = 6;
	}
	
	if (level.gameSkill == 2)
	{
		level.southernHillAdvanceBaglimit = 8;
		level.minigunBreachBaglimit = 8;
	}
	
	if (level.gameSkill == 3)
	{
		level.southernHillAdvanceBaglimit = 10;
		level.minigunBreachBaglimit = 10;
	}

	level.hint_text_size = 1.6;
	
	if ( getdvar( "village_defend_one_minute") != "1" )
		level.stopwatch = 4;	//minutes
	else
		level.stopwatch = 1;	//minutes
		
	level.encroachMinWait = 3;
	level.encroachMaxWait =	5;
	assertEX( level.encroachMinWait < level.encroachMaxWait, "encroachMinWait must be less than encroachMaxWait!" );
	
	level.magicSniperTalk = true;
	level.southern_hill_magic_sniper_min_cycletime = 5;
	level.southern_hill_magic_sniper_max_cycletime = 15;
	
	level.southernMortarIntroTimer = 3.5; //this many seconds before Price mentions mortars and order the team to pull back
	level.southernMortarKillTimer = 25;	//this many seconds before player is struck by enemy mortars in the ridgeline area
	
	level.genericBaitCount = 0;	//circulates spare enemies to the clacker bait locations for the clacker objective
	
	level.irrelevantDist = 1000;
	level.irrelevantPopLimit = 8;
	
	level.divertClackerRange = 1000;	//distance beyond which enemies will break off attacking the player and move to a prearranged spot
	level.encroachRate = 0.85;			//percentage of goal reduction per encroaching iteration
	
	level.objectiveClackers = 0;
	level.tankPop = 4;
	level.tankid = 0;
	
	level thread minigun_const();
	run_thread_on_targetname( "minigun", ::minigun_think );
	
	level.aSpawners = getspawnerarray();
	level.aRouteNodes = getnodearray( "flanking_route", "targetname" );
	
	level.airstrikeCalledRecently = false;	
	level.airStriker = level.player;
	
	//Primary Zone Spawn Controllers
	
	level.maxAI = 32;
	level.reqSlots = 8;
	level.detectionCycleTime = 45;
	level.smokeBuildTime = 8;
	level.smokeSpawnSafeDist = 640;
	level.detectionRefreshTime = 3;
	level.volumeDesertionTime = 6;
	
	//Airstrike Controllers
	
	level.lowplaneflyby = 0;
	level.strikeZoneGracePeriod = 20;
	level.airstrikeCooldown = 135;
	level.dangerCloseSafeDist = 1200;
	
	level.airstrikeSupportCallsRemaining = 5;
	
	level.sasSeaKnightBoarded = 0;
	
	level.minigunSessions = 0;
	
	level.delayingActionEnemyWaves = 0;
	
	level.activeAirstrikes = 0;
	
	if( level.gameskill == 0 )
		level.enemyWavesAllowed = 1;
	else
	if( level.gameskill == 1 )
		level.enemyWavesAllowed = 3;
	else
	if( level.gameskill == 2 )
		level.enemyWavesAllowed = 4;
	else
	if( level.gameskill == 3 )
		level.enemyWavesAllowed = 5;
	
	level.sniperfx = "weap_m40a3sniper_fire_village";
	
	level thread objectives();
	level thread magic_sniper();
	level thread southern_hill_ambush_mg();
	level thread southern_hill_vanguard_setup();
	level thread friendly_setup();
	level thread southern_hill_killzone_sequence();
	level thread helidrop();
	level thread clacker_init();
	level thread clacker_primary_attack();
	
	level thread player_interior_detect_init();
	level thread enemy_interior_flashbangs();
	
	level thread javelin_init();
	level thread tanks_init();
	level thread barn_helidrop();
	level thread field_fallback();
	level thread barn_fallback();
	
	level thread final_battle();
	level thread autosaves_return_trip();
	level thread airstrike_command();
	
	level thread begin_delaying_action();
	level thread begin_delaying_action_timeout();
	level thread player_detection_volume_init();
	
	level thread escape_fallback();
	
	level thread music();
	level thread seaknight_music();
	
	level thread southern_hill_shotmonitor();
	
	level thread return_trip_friendly_boost();
	
	diff = [];
	diff[ 0 ] = 0.3;
	diff[ 1 ] = 0.6;
	diff[ 2 ] = 1;
	diff[ 3 ] = 1.2;

	level.village_diff = diff;
	
	level thread return_trip_enemy_acc_prep();
	
	//Left trigger spin functionality for console controllers
	
	if( level.console )
	{
		level thread minigun_firstuse_check();
		//level thread minigun_session_check();
		
		add_hint_string( "minigun_spin_left_trigger", &"SCRIPT_PLATFORM_SPOOL_MINIGUN", maps\village_defend::should_break_minigun_spin_hint );
	}
	
	level.playerSafetyBlocker = getent( "helo_safety_blocker", "targetname" );
	level.playerSafetyBlocker notsolid();
}

should_break_minigun_spin_hint()
{
	minigun = getent( "minigun", "targetname" );
	minigunUser = minigun getTurretOwner();

	if ( !isdefined( minigunUser ) )
		return true;

	if ( !flag( "minigun_lesson_learned" ) )
		return false;
				
	return level.player == minigunUser;
}

start_village_defend()
{
	thread intro();
	level.start_intro = true;
	
	level.player setthreatbiasgroup( "player" );
	
	setignoremegroup( "axis", "allies" );	// allies ignore axis
	setignoremegroup( "allies", "axis" ); 	// axis ignore allies
	setignoremegroup( "player", "axis" );	// axis ignore player
}

start_southern_hill()
{
	level.player setthreatbiasgroup( "player" );
	
	setignoremegroup( "axis", "allies" );	// allies ignore axis
	setignoremegroup( "allies", "axis" ); 	// axis ignore allies
	setignoremegroup( "player", "axis" );	// axis ignore player
	
	flag_set( "church_tower_explodes" );
	flag_set( "objective_price_orders_southern_hill" );
	flag_set( "objective_player_on_ridgeline" );
	//flag_set( "objective_price_on_ridgeline" );
	flag_set( "objective_on_ridgeline" );
	
	playerStart = getnode( "player_southern_start", "targetname" );
	level.player setorigin (playerStart.origin);
	
	priceStart = getnode( "price_southern_start", "targetname" );
	level.price = getent( "price", "targetname" );
	level.price teleport (priceStart.origin);
	
	introHillTrigs = getentarray( "introHillTrig", "targetname" );
	for( i = 0 ; i < introHillTrigs.size; i++ )
	{
		introHillTrigs[ i ] notify ("trigger");
	}
	
	//thread intro_tankdrive();
	thread southern_hill_defense();
}

start_minigun_fallback()
{
	//Advance objectives, set past game states
	
	flag_set( "stop_ambush_music" );
	flag_set( "objective_player_on_ridgeline" );
	flag_set( "church_tower_explodes" );
	flag_set( "objective_price_orders_southern_hill" );
	flag_set( "objective_on_ridgeline" );
	flag_set( "southern_hill_killzone_detonate" );
	
	//Position player
	
	//playerStart = getnode( "player_start_minigun", "targetname" );
	playerStart = getnode( "player_southern_start", "targetname" );
	level.player setorigin (playerStart.origin);
	
	//Position friendlies
	
	priceStart = getnode( "price_southern_start", "targetname" );
	level.price = getent( "price", "targetname" );
	level.price teleport (priceStart.origin);
	
	thread moveRedshirts( "redshirt_southern_start1", "redshirt_southern_start2" );
	
	//Restore game state
	
	introHillTrigs = getentarray( "introHillTrig", "targetname" );
	for( i = 0 ; i < introHillTrigs.size; i++ )
	{
		introHillTrigs[ i ] notify ("trigger");
	}
	
	thread southern_hill_smokescreens();
	
	thread saw_gunner_friendly();
}

start_minigun()
{
	//Advance objectives, set past game states
	
	flag_set( "stop_ambush_music" );
	flag_set( "church_tower_explodes" );
	flag_set( "objective_price_orders_southern_hill" );
	flag_set( "objective_on_ridgeline" );
	flag_set( "objective_player_on_ridgeline" );
	flag_set( "southern_hill_killzone_detonate" );
	flag_set( "objective_price_orders_minigun" );
	flag_set( "southern_hill_smoke_entry" );
	
	//Position player
	
	playerStart = getnode( "player_start_minigun", "targetname" );
	level.player setorigin (playerStart.origin);
	
	//Position friendlies
	
	priceStart = getnode( "fallback_price", "targetname" );
	level.price = getent( "price", "targetname" );
	level.price teleport (priceStart.origin);
	level.price setgoalnode( priceStart );
	
	thread moveRedshirts( "fallback_redshirt1", "fallback_redshirt2" );
	
	//Restore game state
	
	thread southern_hill_mortars_killtimer();
	thread minigun_primary_attack();
	thread minigun_smokescreens();
	thread saw_gunner_friendly();
}

start_helidrop()
{
	//Advance objectives, set past game states
	
	flag_set( "stop_ambush_music" );
	flag_set( "church_tower_explodes" );
	flag_set( "objective_price_orders_southern_hill" );
	flag_set( "objective_on_ridgeline" );
	flag_set( "objective_player_on_ridgeline" );
	flag_set( "southern_hill_killzone_detonate" );
	flag_set( "objective_price_orders_minigun" );
	flag_set( "southern_hill_smoke_entry" );
	flag_set( "objective_minigun_baglimit_done" );
	flag_set( "divert_for_clacker" );
	
	//Position player
	
	playerStart = getnode( "player_start_minigun", "targetname" );
	level.player setorigin (playerStart.origin);
	
	//Position friendlies
	
	priceStart = getnode( "fallback_price", "targetname" );
	level.price = getent( "price", "targetname" );
	level.price teleport (priceStart.origin);
	level.price setgoalnode( priceStart );
	
	thread moveRedshirts( "fallback_redshirt1", "fallback_redshirt2" );
	
	//Restore game state
	
	thread southern_hill_mortars_killtimer();
	thread minigun_primary_attack();
	thread minigun_smokescreens();
	thread saw_gunner_friendly();
}

start_clackers()
{
	//Advance objectives, set past game states
	
	flag_set( "stop_ambush_music" );
	flag_set( "church_tower_explodes" );
	flag_set( "objective_price_orders_southern_hill" );
	flag_set( "objective_on_ridgeline" );
	flag_set( "objective_player_on_ridgeline" );
	flag_set( "southern_hill_killzone_detonate" );
	flag_set( "objective_price_orders_minigun" );
	flag_set( "southern_hill_smoke_entry" );
	flag_set( "objective_detonators" );
	flag_set( "detonators_activate" );
	
	//Position player
	
	playerStart = getnode( "player_start_clacker", "targetname" );
	level.player setorigin (playerStart.origin);
	
	//Restore game state
	
	thread southern_hill_mortars_killtimer();
	thread minigun_primary_attack();
	thread minigun_smokescreens();
	thread saw_gunner_friendly();
	
	wait 7;
	flag_set( "objective_minigun_baglimit_done" );
	flag_set( "divert_for_clacker" );
}

start_field_fallback()
{
	//Advance objectives, set past game states
	
	flag_set( "stop_ambush_music" );
	flag_set( "church_tower_explodes" );
	flag_set( "objective_price_orders_southern_hill" );
	flag_set( "objective_on_ridgeline" );
	flag_set( "objective_player_on_ridgeline" );
	flag_set( "southern_hill_killzone_detonate" );
	flag_set( "objective_price_orders_minigun" );
	flag_set( "southern_hill_smoke_entry" );
	flag_set( "objective_detonators" );
	flag_set( "divert_for_clacker" );
	flag_set( "fall_back_to_barn" );
	flag_set( "barn_assault_begins" );
	flag_set( "objective_armor_arrival" );
	flag_set( "storm_the_tavern" );
	
	//Position player
	
	playerStart = getnode( "player_start_clacker", "targetname" );
	level.player setorigin (playerStart.origin);
	
	//Restore game state
	
	thread southern_hill_mortars_killtimer();
	thread minigun_primary_attack();
	thread minigun_smokescreens();
	thread saw_gunner_friendly();
}

start_javelin()
{
	//Advance objectives, set past game states
	
	flag_set( "stop_ambush_music" );
	flag_set( "church_tower_explodes" );
	flag_set( "objective_price_orders_southern_hill" );
	flag_set( "objective_on_ridgeline" );
	flag_set( "objective_player_on_ridgeline" );
	flag_set( "southern_hill_killzone_detonate" );
	flag_set( "objective_price_orders_minigun" );
	flag_set( "southern_hill_smoke_entry" );
	flag_set( "objective_detonators" );
	flag_set( "divert_for_clacker" );
	flag_set( "fall_back_to_barn" );
	flag_set( "farm_reached" );
	flag_set( "barn_assault_begins" );
	flag_set( "objective_armor_arrival" );
	flag_set( "storm_the_tavern" );
	
	//Position player
	
	level.player setorigin ( ( 1021, 7309, 1006 ) );
	
	//Restore game state
	
	//thread southern_hill_mortars_killtimer();
	//thread minigun_primary_attack();
	//thread minigun_smokescreens();
	thread saw_gunner_friendly();
}

start_final_battle()
{
	//Advance objectives, set past game states
	
	flag_set( "stop_ambush_music" );
	flag_set( "church_tower_explodes" );
	flag_set( "objective_price_orders_southern_hill" );
	flag_set( "objective_on_ridgeline" );
	flag_set( "objective_player_on_ridgeline" );
	flag_set( "southern_hill_killzone_detonate" );
	flag_set( "objective_price_orders_minigun" );
	flag_set( "southern_hill_smoke_entry" );
	flag_set( "objective_detonators" );
	flag_set( "divert_for_clacker" );
	flag_set( "fall_back_to_barn" );
	flag_set( "barn_assault_begins" );
	flag_set( "objective_armor_arrival" );
	flag_set( "farm_reached" );
	flag_set( "got_the_javelin" );
	flag_set( "objective_all_tanks_destroyed" );
	flag_set( "airstrikes_ready" );
	flag_set( "storm_the_tavern" );
	flag_set( "start_final_battle" );
	
	//Position player
	
	level.player setorigin ( ( 1021, 7309, 1006 ) );
	
	//Restore game state
	
	//thread southern_hill_mortars_killtimer();
	//thread minigun_primary_attack();
	//thread minigun_smokescreens();
	thread saw_gunner_friendly();
	
	//Delete the barbed wire 
	
	barbedDets = getentarray( "barbed_wire_detonator", "targetname" );
	
	thread minigun_barbed_wire_detonate( "southern_hill_barbed_wire_wall_1", barbedDets );
	
	wait 2;
	
	thread minigun_barbed_wire_detonate( "southern_hill_barbed_wire_wall_2", barbedDets );
	
	wait 3;
	
	thread minigun_barbed_wire_detonate( "southern_hill_barbed_wire_wall_3", barbedDets );
}

start_seaknight()
{
	//Advance objectives, set past game states
	
	flag_set( "stop_ambush_music" );
	flag_set( "church_tower_explodes" );
	flag_set( "objective_price_orders_southern_hill" );
	flag_set( "objective_on_ridgeline" );
	flag_set( "objective_player_on_ridgeline" );
	flag_set( "southern_hill_killzone_detonate" );
	flag_set( "objective_price_orders_minigun" );
	flag_set( "southern_hill_smoke_entry" );
	flag_set( "objective_detonators" );
	flag_set( "divert_for_clacker" );
	flag_set( "fall_back_to_barn" );
	flag_set( "farm_reached" );
	flag_set( "barn_assault_begins" );
	flag_set( "objective_armor_arrival" );
	flag_set( "got_the_javelin" );
	flag_set( "objective_all_tanks_destroyed" );
	flag_set( "airstrikes_ready" );
	flag_set( "storm_the_tavern" );
	flag_set( "rescue_chopper_ingress" );
	
	//Position player
	
	level.player setorigin ( ( -64, -1904, -80 ) );
	
	//Restore game state
	
	//thread southern_hill_mortars_killtimer();
	//thread minigun_primary_attack();
	//thread minigun_smokescreens();
	thread saw_gunner_friendly();
	
	//Delete the barbed wire 
	
	barbedDets = getentarray( "barbed_wire_detonator", "targetname" );
	
	thread minigun_barbed_wire_detonate( "southern_hill_barbed_wire_wall_1", barbedDets );
	thread minigun_barbed_wire_detonate( "southern_hill_barbed_wire_wall_2", barbedDets );
	thread minigun_barbed_wire_detonate( "southern_hill_barbed_wire_wall_3", barbedDets );
	
	wait 0.05;
	
	aAxis = getaiarray( "axis" );
	for( i = 0; i < aAxis.size; i++ )
	{
		aAxis[ i ] delete();
	}
}

moveRedshirts( node1, node2 )
{
	redshirt1 = getent( "redshirt1", "targetname" );
	redshirt2 = getent( "redshirt2", "targetname" );
	
	redshirt_node1 = getnode( node1, "targetname" );
	redshirt_node2 = getnode( node2, "targetname" );
	
	redshirt1 teleport ( redshirt_node1.origin );
	redshirt1 setgoalnode ( redshirt_node1 );
	
	redshirt2 teleport ( redshirt_node2.origin );
	redshirt2 setgoalnode ( redshirt_node2 );
}

intro()
{
	thread intro_loudspeaker();
	
	aAllies = getaiarray( "allies" );
	
	for( i = 0 ; i < aAllies.size; i++ )
	{
		aAllies[ i ].dontavoidplayer = true;
		aAllies[ i ].baseaccuracy = 15;
	}
	
	aAllies = remove_heroes_from_array( aAllies );
	
	for( i = 0 ; i < aAllies.size; i++ )
	{
		aAllies[ i ] allowedstances ("crouch");
		aAllies[ i ].disableArrivals = true;
		aAllies[ i ].ignoresuppression = true;
	}
	
	introTrigs = getentarray( "introTrig", "targetname" );
	for( i = 0 ; i < introTrigs.size; i++ )
	{
		introTrigs[ i ] notify ("trigger");
	}
	
	for( i = 0 ; i < aAllies.size; i++ )
	{
		aAllies[i] allowedStances ("stand", "crouch", "prone");
	}
	
	wait 18;
	
	price_intro_route = getnode( "price_intro_route", "targetname" );
	
	redshirt1 = getent( "redshirt1", "targetname" );
	redshirt2 = getent( "redshirt2", "targetname" );
	
	//redshirt_routes = [];
	redshirt_route1 = getnode( "sas1_intro_route", "targetname" );
	redshirt_route2 = getnode( "sas2_intro_route", "targetname" );
	
	level.price thread followScriptedPath( price_intro_route, undefined, "prone" );
	
	redshirt1 thread followScriptedPath( redshirt_route1, 0.75, "prone" );
	redshirt2 thread followScriptedPath( redshirt_route2, 0.75, "prone" );
	
	//wait 6.5;
	wait 1;
	
	//"Ignore that load of bollocks. Their counterattack is imminent. Spread out and cover the southern approach."
	//iprintln( "Their counterattack is imminent. Spread out and cover the southern approach." );
	level.price anim_single_queue( level.price, "spreadout" );
	
	flag_set( "objective_price_orders_southern_hill" );
	
	thread intro_ridgeline_check( level.player, "player_southern_start" );
	thread intro_ridgeline_check( level.price, "price_southern_start" );
	thread intro_hillpatrol_check();
	
	//"Bell tower here. Two enemy squads forming up to the south."
	//iprintln( "Bell tower here. Two enemy squads forming up to the south." );
	//radio_dialogue_queue( "belltowerhere" );
	
	//wait 6.2;
	
	//"Sir, they're slowly coming up the hill. Just say when."
	//iprintln( "Sir, they're slowly coming up the hill. Just say when." );
	radio_dialogue_queue( "justsaywhen" );

	thread southern_hill_defense();
}

intro_church_tower_explode()
{
	temp_tower_sequence = getent( "intro_tank_tower_target", "targetname" );

	wait 2;
	
	temp_tower_sequence playsound ( "artillery_incoming" );
	
	wait 1;
	
	//incoming tracer and explosion
	exploder( 1000 );
	wait 1.1;
	exploder( 1001 );
	temp_tower_sequence playsound( "exp_bell_tower" );	
	earthquake( 0.65, 1, temp_tower_sequence.origin, 3000 );
	
	flag_set( "church_tower_explodes" );
	
	deathVolume = getent( "church_explosion_damage", "targetname" );
	
	for( i = 0; i < 20; i++ )
	{
		if( level.player isTouching( deathVolume ) )
			level.player doDamage( level.player.health + 10000, level.player.origin );
		
		wait 0.05;
	}
}

intro_hillpatrol_check()
{
	trig = getent( "hill_patrol_trig", "targetname" );
	trig waittill ( "trigger" );
	
	flag_set( "objective_player_on_ridgeline" );
}

intro_ridgeline_check( guy, nodename )
{
	ridgelinePos = getnode( nodename, "targetname" );
	
	dist = length(level.player.origin - ridgelinePos.origin);
	
	//Wait for guy to reach his place on the ridgeline
	
	while(dist > 128)
	{
		dist = length(guy.origin - ridgelinePos.origin);
		wait 0.1;
	}
	
	if( guy == level.price )
		flag_set( "objective_on_ridgeline" );
		//flag_set( "objective_price_on_ridgeline" );
		
	if( guy == level.player )
	{
		//flag_set( "objective_on_ridgeline" );
		//flag_set( "objective_player_on_ridgeline" );
		flag_set( "objective_player_at_vantage_point" );
	}
}

intro_loudspeaker()
{
	//Ultranationalist Russian commander demanding the surrender of the SAS troops
	
	aSpeakerTalk = [];
	
	//TEMP DIALOGUE
	//"Surrender at once and your lives will be spared. I am sure you will make the right choice given the circumstances."
	aSpeakerTalk[ 0 ] = "villagedef_rul_surrenderatonce";
	
	//TEMP DIALOGUE
	//"Drop your weapons and surrender at once. You will not be harmed if you surrender."
	aSpeakerTalk[ 1 ] = "villagedef_rul_dropyourweapons";
	
	//TEMP DIALOGUE
	//"We know you are hiding in the village. You are surrounded, there is nowhere to run. Surrender and make it easy on yourselves."
	aSpeakerTalk[ 2 ] = "villagedef_rul_weknowyourehiding";
	
	aSpeakers = getentarray( "russian_loudspeaker", "targetname" );
	speakerCount = aSpeakers.size;
	j = 0;
	
	for( i = 0; i < aSpeakerTalk.size; i++ )
	{
		if( j >= speakerCount)
			j = 0;
			
		play_sound_in_space( aSpeakerTalk[ i ], aSpeakers[ j ].origin);
		wait randomfloatrange( 5 , 8);
		j++;
	}
}

southern_hill_defense()
{
	thread southern_hill_intro();
	thread southern_hill_intro_interrupt();
	thread southern_hill_panic_screaming();
	thread southern_hill_javelin();
	thread southern_hill_ambush();
	thread southern_hill_primary_attack();
	thread southern_hill_baglimit();
}

southern_hill_primary_attack()
{
	//level endon ( "objective_player_uses_minigun" );
	level endon ( "southern_hill_smoked" );
	
	startNode = getnode( "southern_hill_waypoint", "targetname" );
	unitName = "southern_hill_assaulter";
	endonMsg = "southern_hill_attack_stop";
	
	squad1 = "spawnRock";
	squad2 = "spawnRoad";
	squad3 = "spawnGas";
	
	level endon ( endonMsg );
	
	flag_wait( "southern_hill_killzone_detonate" );
	wait 1;

	while( 1 )
	{
		thread encroach_start( startNode, unitName, endonMsg, squad1, "southern_hill" );
		thread encroach_start( startNode, unitName, endonMsg, squad2, "southern_hill" );
		thread encroach_start( startNode, unitName, endonMsg, squad3, "southern_hill" );
		
		wait randomfloat( 6, 8 );
		
		thread encroach_start( startNode, unitName, endonMsg, squad2, "southern_hill" );
		thread encroach_start( startNode, unitName, endonMsg, squad2, "southern_hill" );
		thread encroach_start( startNode, unitName, endonMsg, squad3, "southern_hill" );
		
		wait randomfloat( 8, 10 );
		
		thread encroach_start( startNode, unitName, endonMsg, squad1, "southern_hill" );
		thread encroach_start( startNode, unitName, endonMsg, squad3, "southern_hill" );
		thread encroach_start( startNode, unitName, endonMsg, squad2, "southern_hill" );
		
		wait randomfloat( 10, 12 );
	}
}

magic_sniper()
{
	flag_wait( "southern_hill_killzone_detonate" );
	
	wait 2;
	
	n = undefined;
	j = 0;
	magic_sniper = getent( "southern_hill_magic_sniper", "targetname" );
	//sniperfx = "weap_m40a3sniper_fire_village";
	
	while( 1 )
	{
		aAxis = [];
		aValidSniperTargets = [];
		
		aAxis = getaiarray( "axis" );	//bad get?
		
		for( i = 0; i < aAxis.size; i++ )
		{
			guy = aAxis[ i ];
			
			if( !isdefined( guy.targetname ) && !isdefined( guy.script_noteworthy ) )
				continue;
			
			if( guy.script_noteworthy == "spawnGas" )
			{
				aValidSniperTargets[ aValidSniperTargets.size ] = guy;
			}
			else
			if( guy.script_noteworthy == "spawnRoad" )
			{
				aValidSniperTargets[ aValidSniperTargets.size ] = guy;
			}
			else
			if( guy.script_noteworthy == "spawnRock" )
			{
				aValidSniperTargets[ aValidSniperTargets.size ] = guy;
			}
			else
			if( isdefined( guy.targetname ) && guy.targetname == "vanguard" )
			{
				aValidSniperTargets[ aValidSniperTargets.size ] = guy;
			}
			else
			if ( guy.script_noteworthy == "spawnHillFence" )
			{
				aValidSniperTargets[ aValidSniperTargets.size ] = guy;
			}
			else
			if ( guy.script_noteworthy == "spawnHillChurch" )
			{
				aValidSniperTargets[ aValidSniperTargets.size ] = guy;
			}
			else
			if ( guy.script_noteworthy == "spawnHillGraveyard" )
			{
				aValidSniperTargets[ aValidSniperTargets.size ] = guy;
			}
			else
			if ( guy.script_noteworthy == "spawnHillFlank" )
			{
				aValidSniperTargets[ aValidSniperTargets.size ] = guy;
			}
		}	
		
		if( aValidSniperTargets.size == 0 )
		{
			wait 1;
			continue;
		}
			
		n = randomint( aValidSniperTargets.size );
		sniperTarget = aValidSniperTargets[ n ];
		
		magic_sniper playsound( level.sniperfx );
		sniperTarget doDamage ( sniperTarget.health + 100, (0, 0, 0) );
		
		if( level.magicSniperTalk )
		{
			if( j == 0 )
			{
				//"Target down."
				radio_dialogue_queue( "targetdown" );
				j++;
			}
			else
			if( j == 1 )
			{
				//"Got him."
				radio_dialogue_queue( "gothim" );
				j++;
			}
			else
			if( j == 2 )
			{
				//"Target eliminated."
				radio_dialogue_queue( "targeteliminated" );
				j++;
			}
			else
			if( j == 3 )
			{
				//"Goodbye."
				radio_dialogue_queue( "goodbye" );
				j = 0;
			}
		}
		
		aAxis = undefined;
		aValidSniperTargets = undefined;
		
		cycleDelay = randomfloatrange( level.southern_hill_magic_sniper_min_cycletime, level.southern_hill_magic_sniper_max_cycletime );
		wait cycleDelay;
	}
}

southern_hill_vanguard_setup()
{
	vanguards = [];
	vanguards = getentarray( "vanguard", "targetname" );
	
	for( i = 0; i < vanguards.size; i++ )
	{
		vanguards[ i ].goalradius = 16;
	}
	
	flag_wait( "objective_player_on_ridgeline" );
	//flag_wait( "objective_price_on_ridgeline" );
	//flag_wait( "objective_on_ridgeline" );
	
	for( i = 0; i < vanguards.size; i++ )
	{
		//vanguards[ i ] enable_cqbwalk();
		
		if( isdefined( vanguards[ i ] ) )
		{
			vanguards[ i ].animname = "axis";
			vanguards[ i ] set_run_anim( "patrolwalk_" + ( randomint(5) + 1 ) );
			vanguards[ i ] thread southern_hill_vanguard_nav();
			vanguards[ i ] thread southern_hill_vanguard_wakeup();
			vanguards[ i ] thread southern_hill_deathmonitor();
			vanguards[ i ] thread southern_hill_damagemonitor();
			
		}
		
		wait 0.05;
	}
}

southern_hill_vanguard_nav()
{
	self endon ( "death" );
	
	node = undefined;
	
	if( !isdefined( self.script_noteworthy ) )
	{
		node = getnode( "default_vanguard_dest", "targetname" );	
	}
	else
	{
		nodes = getnodearray( "vanguard_node", "targetname" );	
		for( i = 0; i < nodes.size; i++ )
		{
			assertEX( isdefined( nodes[ i ].script_noteworthy ), "vanguard_node without a script_noteworthy" );
			if( self.script_noteworthy == nodes[ i ].script_noteworthy )
			{
				node = nodes[ i ];
				break;
			}
		}
	}
	
	self setgoalnode( node );
	self.goalradius = 2048;
	self thread southern_hill_vanguard_aim();
}

southern_hill_vanguard_aim()
{
	self endon ( "death" );
	
	aimpoints = [];
	aimpoints = getentarray( "vanguard_aimpoint", "targetname" );
	
	while( 1 )
	{
		i = randomint( aimpoints.size );
		self cqb_aim ( aimpoints[ i ] );
		wait randomfloat(1, 2);
	}
}

southern_hill_vanguard_wakeup()
{
	self endon ( "death" );
	
	flag_wait( "southern_hill_action_started" );
	
	self clear_run_anim();
}

southern_hill_timeout()
{
	//timeout on waiting for player if player was close to Price at the time Price reached his goal
	
	wait 10;
	flag_set( "objective_player_at_vantage_point" );
}

southern_hill_intro()
{
	level endon ( "intro_hill_interrupted" );
	
	flag_wait( "objective_player_on_ridgeline" );	//guys are walking
	//flag_wait( "objective_price_on_ridgeline" );
	flag_wait( "objective_on_ridgeline" );			//price is there
	
	dist = length( level.player.origin - level.price.origin );
	
	if( dist < 512 )
	{
		thread southern_hill_timeout();
		flag_wait( "objective_player_at_vantage_point" );	//wait longer if player is likely following price
	}
	
	wait 6;
	
	if( !flag( "southern_hill_action_started" ) ) 
	{
		//"Do it."
		//iprintln( "Do it." );
		flag_set( "price_ordered_hill_detonation" );
		radio_dialogue_queue( "doit" );
	}
		
		//"Ka-boom."
		//iprintln( "Ka-boom." );
		radio_dialogue_queue( "kaboom" );
	
	if( !flag( "southern_hill_action_started" ) ) 
	{
		flag_set( "southern_hill_killzone_detonate" );
		
		wait 0.5;
		
		flag_set( "southern_hill_action_started" );
	}
	else
	{	
		flag_set( "southern_hill_killzone_detonate" );
	}
}

southern_hill_intro_interrupt()
{
	//if a grenade is thrown by the player and kills an enemy on the hill or the player opens fire, start the battle

	flag_wait( "southern_hill_action_started" );

	level notify ( "intro_hill_interrupted" );
	
	flag_set( "southern_hill_action_started" );
	
	wait 0.35;
	
	if( !flag( "price_ordered_hill_detonation" ) )
	{
		radio_dialogue_queue( "doit" );
		radio_dialogue_queue( "kaboom" );
	}
	
	flag_set( "southern_hill_killzone_detonate" );
}

southern_hill_ambush()
{
	flag_wait( "southern_hill_action_started" );
	
	//wait 0.15;
	
	flag_set( "southern_mg_openfire" );
	
	//wait 0.3;
	
	setthreatbias( "player", "axis", 0 );	// axis fight player
	setthreatbias( "allies", "axis", 0 ); 	// axis fight allies
	setthreatbias( "axis", "allies", 0 );	// allies fight axis
	
	flag_wait( "southern_hill_killzone_detonate" );
	
	wait 2;
		
	//"OPEN FIIRRRRRE!!!!!"
	//iprintln( "OPEN FIIRRRRRE!!!!!" );
	level.price thread anim_single_queue( level.price, "openfire" );
	
	wait 1;
	
	battlechatter_on( "allies" );
}

southern_hill_killzone_sequence()
{
	killzone1 = [];
	killzone2 = [];
	killzone1point = getent( "southern_hill_killzone_1", "targetname" );
	killzone2point = getent( "southern_hill_killzone_2", "targetname" );

	while( 1 )
	{
		killzone1[ killzone1.size ] = killzone1point;
		
		if( isdefined( killzone1point.target ) )
			killzone1point = getent( killzone1point.target, "targetname" );
		else
			break;
			
		wait 0.05;
	}
	
	while( 1 )
	{
		killzone2[ killzone2.size ] = killzone2point;
		
		if( isdefined( killzone2point.target ) )
			killzone2point = getent( killzone2point.target, "targetname" );
		else
			break;
			
		wait 0.05;
	}
	
	flag_wait( "southern_hill_killzone_detonate" );
	
	battlechatter_on( "axis" );

	thread killzone_detonation( killzone1 );
	wait 1.25;
	thread killzone_detonation( killzone2 );
	
	wait 2;
	
	flag_set( "stop_ambush_music" );
	musicStop( 1 );
}

southern_hill_panic_screaming()
{
	//level endon ( "temp_demo_stopshooting" );	//TEMP LEVEL STOP FOR DEMOING PURPOSES ONLY
	
	level endon ( "stop_hill_screaming" );
	
	flag_wait( "southern_hill_action_started" );
	
	speakers = getentarray( "ambush_speaker", "targetname" );
	for( j = 0; j < 4; j++ )
	{
		for( i = 0; i < speakers.size; i++ )
		{
			speaker = speakers[ i ];
			play_sound_in_space( "RU_1_reaction_casualty_generic", speaker.origin );	
			wait 1;
			play_sound_in_space( "RU_1_order_move_generic", speaker.origin );	
			wait 1;
			play_sound_in_space( "RU_1_order_attack_infantry", speaker.origin );	
			wait 1;
			play_sound_in_space( "RU_1_order_action_coverme", speaker.origin );	
			wait 1;
			play_sound_in_space( "RU_1_inform_suppressed_generic", speaker.origin );	
			wait 1;
			play_sound_in_space( "RU_1_order_action_suppress", speaker.origin );	
			wait 1;
			play_sound_in_space( "RU_1_response_ack_covering", speaker.origin );	
			wait 1;
			play_sound_in_space( "RU_1_response_ack_follow", speaker.origin );	
			wait 1;	
			play_sound_in_space( "villagedef_ru4_helpmeimwounded", speaker.origin );	
			wait 1;	
			play_sound_in_space( "villagedef_ru1_noicantmove", speaker.origin );	
			wait 1;	
			play_sound_in_space( "villagedef_ru2_death", speaker.origin );	
			wait 1;	
			play_sound_in_space( "villagedef_ru3_death", speaker.origin );	
			wait 1;	
			play_sound_in_space( "villagedef_ru4_wheretheyshooting", speaker.origin );	
			wait 1;	
			play_sound_in_space( "villagedef_ru1_icantseethem", speaker.origin );	
			wait 1;	
			play_sound_in_space( "villagedef_ru2_underheavyfire", speaker.origin );	
			wait 1;	
			play_sound_in_space( "villagedef_ru4_reinforcements", speaker.origin );	
			wait 1;	
			play_sound_in_space( "villagedef_ru1_goaroundwest", speaker.origin );	
			wait 1;	
			play_sound_in_space( "villagedef_ru4_imhitmedic", speaker.origin );	
			wait 1;	
			play_sound_in_space( "villagedef_ru1_medic", speaker.origin );	
			wait 1;	
		}
	}
}

southern_hill_ambush_mg()
{
	southern_sas_mg = getent( "southern_house_manual_mg", "targetname" );
	southern_sas_mg setmode( "manual" );
	southern_sas_mg thread southern_hill_mg_targeting();
	
	flag_wait( "southern_mg_openfire" );
	
	southern_sas_mg thread manual_mg_fire();
}

southern_hill_mg_targeting()
{
	level endon ( "sawgunner_moving" ); 
	
	targets = getentarray( self.target, "targetname" );
	n = 0;
	
	while( 1 )
	{
		target = random( targets );
		
		self settargetentity( target );
		
		wait( randomfloatrange( 1, 5 ) );
		
		n++;
		
		//Occasionally pick off a bad guy
		
		if( n > 8 )
		{
			aAxis = [];
			aAxis = getaiarray( "axis" );
			if( aAxis.size )
			{
				target = random( aAxis );
				self settargetentity( target );
				wait( randomfloatrange( 1, 2 ) );
				
				n = 0;
				aAxis = undefined;
			}
			else
			{
				break;
			}
		}
	}
}

manual_mg_fire()
{	
	level endon( "sawgunner_moving" );
	self.turret_fires = true;
	n = 0;
	for ( ;; )
	{
		timer = randomfloatrange( 0.4, 0.7 ) * 20;
		if ( self.turret_fires )
		{
			for ( i = 0; i < timer; i++ )
			{
				self shootturret();
				wait( 0.05 );
			}
		}
		
		n++;
		
		//time between bursts
		wait( randomfloat( 3.3, 6 ) );
		
		if(n >= 10)
		{
			//pretend reloading
			wait randomfloat( 6.1, 7.4 );
			n = 0;
		}
	}
}

southern_hill_javelin()
{
	flag_wait( "southern_hill_action_started" );
	
	wait 4;
	
	//"Nice shot mate!"
	radio_dialogue_queue( "niceshotmate" );
}

southern_hill_baglimit()
{
	i=0;
	
	speakers = getentarray( "ambush_speaker", "targetname" );
	
	while( i < level.southernHillAdvanceBaglimit )
	{
		level waittill ( "player_killed_southern_hill_enemy" );
		i++;
		
		if( i == level.southernHillAdvanceBaglimit / 2 )
		{
			speaker = speakers[ randomint( speakers.size ) ];
			
			play_sound_in_space( "villagedef_ru1_mustbetwoplatoons", speaker.origin );	
			wait 2;
			
			//"Squad, hold your ground, they think we're a larger force than we really are."
			radio_dialogue_queue( "largerforce" );
				
			//"Copy."
			radio_dialogue_queue( "copy" );
		}
	}
	
	thread saw_gunner_friendly();
	
	wait 7;
	
	flag_set( "southern_hill_smoked" );
	
	wait 20;
	
	thread southern_hill_smokescreens();
}

southern_hill_deathmonitor()
{
	self waittill ( "death", nAttacker );
	
	flag_set( "southern_hill_action_started" );
	
	if( isdefined( nAttacker ) && nAttacker == level.player )
	{
		level notify ( "player_killed_southern_hill_enemy" );
	}
}

southern_hill_damagemonitor()
{
	self waittill ( "damage", nAttacker );
	
	flag_set( "southern_hill_action_started" );
}

southern_hill_shotmonitor()
{
	trig = getent( "hill_patrol_shotdetector", "targetname" );
	
	/*
	
	trig waittill ( "damage", nAttacker );
	
	if( isdefined( nAttacker ) && nAttacker == level.player )
	{
		flag_set( "southern_hill_action_started" );	
	}
	
	*/
	
	trig waittill ( "trigger" );
	flag_set( "southern_hill_action_started" );	
}

saw_gunner_friendly()
{
	//spawn the SAW gunner
	
	sasGunner = getent( "sasGunner", "targetname" );
	level.sasGunner = sasGunner doSpawn();
	if( spawn_failed( level.sasGunner ) )
	{
			return;
	}
	sasGunnerNode = getnode( "fallback_sasGunner", "targetname" );
	level.sasGunner setgoalnode( sasGunnerNode );
	level.sasGunner thread hero();
	level.sasGunner.ignoreSuppression = true;
	//level.sasGunner.baseaccuracy = 1;
	
	flag_wait( "objective_minigun_baglimit_done" );
}

/*
intro_tankdrive()
{
	tank = spawn_vehicle_from_targetname_and_drive( "intro_tank" );
	node = getVehicleNode( "intro_tank_church_aim", "targetname" );
	targetpoint = getent( "intro_tank_tower_target", "targetname" );

	tank setwaitnode(node);
	tank waittill ("reached_wait_node");
	tank setTurretTargetEnt( targetpoint );
	tank waittill_notify_or_timeout( "turret_rotate_stopped", 5.0 );
	
	flag_wait( "intro_tank_fire_authorization" );
	tank fireweapon();
}
*/

southern_hill_smokescreens()
{
	//playfx(level.smokegrenade, smokeSquad.origin);
	//smokescreen_southern_hill
	
	speakers = getentarray( "ambush_speaker", "targetname" );
	speaker = speakers[ randomint( speakers.size ) ];
			
	play_sound_in_space( "villagedef_ru2_putupsmokescreen", speaker.origin );	
	
	aSmokes = getentarray( "smokescreen_southern_hill", "targetname" );
	for( i = 0; i < aSmokes.size; i++ )
	{
		playfx(level.smokegrenade, aSmokes[ i ].origin);	
	}
	
	level notify ( "sawgunner_moving" );
	
	wait 2;
	
	level notify ( "stop_hill_screaming" );
	level.magicSniperTalk = false;
	
	wait 2;
	
	//"They're putting up smokescreens. Mac - you see anything?"
	//iprintln( "They're putting up smokescreens. Mac - you see anything?" );
	radio_dialogue_queue( "smokescreensmac" );
	
	wait 0.5;
	
	//"Not much movement on the road. They might be moving to our west."
	//iprintln( "Not much movement on the road. They might be moving to our west." );
	radio_dialogue_queue( "notmuchmovement" );
	
	wait 4;
	
	thread southern_hill_mortars();
	
	while( !flag( "objective_player_uses_minigun" ) && !flag( "ridgeline_unsafe" ) )
	{
		for( i = 0; i < aSmokes.size; i++ )
		{
			playfx(level.smokegrenade, aSmokes[ i ].origin);
			wait randomfloatrange( 1.2, 2.3 );	
		}
		
		wait 32;
	}
}

southern_hill_mortars()
{
	//mortars start hitting around on the fake points
	//Price orders everyone to fall back to the next defensive zone
	//Price tells the player to get on the minigun
	//after the friendlies are out of the killzone, mortars start hitting around the real points
	//if the player enters the killzone after the timeout, he is killed by a magic mortar
	//use level.killzoneBigExplosion_fx
	
	aHits = getentarray( "southern_hill_mortar_hit", "targetname" );
	aRealHits = getentarray( "southern_hill_mortar_hit_real", "targetname" );
	
	thread minigun_fallback();
	thread southern_hill_mortars_killtimer();
	thread southern_hill_mortars_timing( "southern_hill_mortar_hit", "ridgeline_unsafe", 192 );
	
	//start the barbed wire breach concealing smoke when the player killing mortars start happening
	
	flag_set( "southern_hill_smoke_entry" );
	
	thread minigun_smokescreens();
	
	flag_wait( "ridgeline_unsafe" );
	
	thread southern_hill_mortars_timing( "southern_hill_mortar_hit_real", "enemy_breached_wire", 0 );
	
	wait 1.5;
	
	thread minigun_primary_attack();
}

minigun_smokescreens()
{
	//level endon ( "enemy_breached_wire" );
	level endon ( "objective_detonators" );
	
	aSmokes = getentarray( "smokescreen_barbed_wire", "targetname" );
	
	//while( !flag( "enemy_breached_wire" ) )
	while( 1 )
	{
		if( flag( "southern_hill_smoke_entry" ) )
		{
			for( i = 0; i < aSmokes.size; i++ )
			{
				playfx(level.smokegrenade, aSmokes[ i ].origin);
				wait randomfloatrange( 1.2, 2.3 );	
			}
			
			wait 28;
		}
		
		wait 0.25;
	}
	
}

southern_hill_mortars_timing( mortarMsg, endonMsg, safeDist )
{
	assertEX( isdefined( mortarMsg ), "mortarMsg not defined" );
	assertEX( isdefined( endonMsg ), "endonMsg not defined" );
	assertEX( isdefined( safeDist ), "safeDist not defined" );
	
	level endon ( endonMsg );
	
	aHits = getentarray( mortarMsg, "targetname" );
	aHits = array_randomize(aHits);		
	
	while( !flag( endonMsg ) )
	{
		for( i = 0; i < aHits.size; i++ )
		{
			hit = aHits[ i ];
			dist = distance(level.player.origin, hit.origin);
			
			if( dist > safeDist )
			{	
				southern_hill_mortar_detonate( hit );
				wait randomfloatrange( 0.7, 1.4 );
			}
		}
		
		aHits = array_randomize(aHits);		
	}
}

southern_hill_mortars_killtimer()
{
	wait level.southernMortarIntroTimer;
	flag_set( "ridgeline_targeted" );
	
	wait level.southernMortarKillTimer;
	flag_set( "ridgeline_unsafe" );
	
	//wait 20;
	
	thread southern_hill_mortars_killplayer();
}

southern_hill_mortars_killplayer()
{
	//Blows up player if player is too close to the ridgeline after Price orders the team to fall back
	
	level endon ( "arm_delaying_action" );
	
	dangerZone = getent( "ridgeline_dangerarea", "targetname" );
	
	while( 1 )
	{
		if( level.player isTouching( dangerZone ) )
		{
			wait 2;
			if ( level.player isTouching( dangerZone ) )
			{
				thread southern_hill_mortar_detonate( level.player );
				level.player doDamage( level.player.health + 10000, level.player.origin );
			}
		}
		
		wait 0.5;
	}
}

minigun_fallback()
{
	flag_wait( "ridgeline_targeted" );

	autosave_by_name( "ridgeline_under_mortar_fire" );
	
	redshirt1 = getent( "redshirt1", "targetname" );
	redshirt2 = getent( "redshirt2", "targetname" );
	
	redshirt_node1 = getnode( "fallback_redshirt1", "targetname" );
	redshirt_node2 = getnode( "fallback_redshirt2", "targetname" );
	
	//"They're targeting our position with mortars. It's time to fall back."
	//iprintln( "They're targeting our position with mortars. It's time to fall back." );
	radio_dialogue_queue( "targetingour" );
	
	thread minigun_orders();
	
	wait 2;
	
	//"Two, falling back."
	radio_dialogue_queue( "twofallingback" );
	
	redshirt1 allowedstances ( "stand", "crouch", "prone" );
	redshirt1 setgoalnode( redshirt_node1 );
	wait randomfloatrange( 0.7, 1.2 );
	
	//"Three, on the move."
	radio_dialogue_queue( "threeonthemove" );
	
	redshirt2 allowedstances ( "stand", "crouch", "prone" );
	redshirt2 setgoalnode( redshirt_node2 );
	
	priceNode = getnode( "fallback_price", "targetname" );
	level.price allowedstances ( "stand", "crouch", "prone" );
	level.price setgoalnode( priceNode );
	
	//"Three here. Two's in the far eastern building. We've got the eastern road locked down."
	radio_dialogue_queue( "easternroadlocked" );
	
	level.price.baseaccuracy = 1;
	level.price.ignoreSuppression = true;
	
	redshirt1.baseaccuracy = 1;
	redshirt1.ignoreSuppression = true;
	
	redshirt2.baseaccuracy = 1;
	redshirt2.ignoreSuppression = true;
	
	thread friendly_pushplayer( "off" );
	
	wait 5;
	
	thread intro_church_tower_explode();
}

minigun_orders()
{
	level endon ( "objective_player_uses_minigun" );
	level endon ( "objective_minigun_baglimit_done" );
	
	//Price gives orders for the minigun.
	
	flag_set( "objective_price_orders_minigun" );
	
	//"Right. Soap, get to the minigun and cover the western flank. Go."
	//iprintln( "Right. Soap, get to the minigun and cover the western flank. Go." );
	radio_dialogue_queue( "minigunflank" );
	
	thread minigun_use();
	thread minigun_arming_check();
	
	n = 0;
	cycleTime = 30;
	
	while( 1 )
	{
		wait cycleTime;
		
		if( n == 0 )
		{
			//"Soap, get to the minigun! Move! It's attached to the crashed helicopter."
			radio_dialogue_queue( "miniguncrashed" );
		}
		
		if( n == 1 )
		{
			//"Soap, the minigun's online. It's in the crashed helicopter."
			radio_dialogue_queue( "gazminigunonline" );
		}
		
		if( n == 2 )
		{
			//"Soap, I need you to operate the minigun! Get your arse moving!"
			radio_dialogue_queue( "minigunarse" );
		}
		
		if( n == 3 )
		{
			//Soap. The minigun is inside the crashed helicopter.
			radio_dialogue_queue( "priceminiguninheli" );
		}
		
		if( n == 4 )
		{
			//Soap, get inside the crashed helicopter and use the minigun!
			level.gaz anim_single_queue( level.gaz, "gazuseminigun" );
		}
		
		if( n == 5 )
		{
			//"Get on the minigun in the helicopter. Move!"
			radio_dialogue_queue( "priceminiguninhelimove" );
			n = 0;
			cycleTime = 65;
			continue;
		}

		n++;
		
	}
}

minigun_fallback_shouting()
{
	level endon ( "stop_minigun_fallback_shouting" );
	
	minigun = getent( "minigun", "targetname" );
	minigunNagDelayTime = 5;
	normalNagDelayTime = 10;
	normalNagOnly = false;
	n = 0;
	k = 0;
	m = 0;
	j = 0;
	
	while( !flag( "stop_minigun_fallback_shouting" ) )
	{
		minigunUser = minigun getTurretOwner();
		
		if( isdefined( minigunUser ) && !normalNagOnly )
		{
			if( k == 2 )
			{
				normalNagOnly = true;
				continue;
			}
			
			if( n == 0 )
			{
				//GAZ: Soaap!!! Get off the miniguun! We're faalling baack!
				radio_dialogue_queue( "detminigunfallbackremind1" );
			}
			
			if( n == 1 )
			{
				//GAZ: Forget the minigun! We've go to go! NOW!
				radio_dialogue_queue( "detminigunfallbackremind2" );
				n = 0;
				k++;
				wait minigunNagDelayTime * 3;
				continue;
			}
			
			n++;
			
			
			wait minigunNagDelayTime;
		}
		else
		{
			/*
			if( m == 3 )
			{
				break;
			}
			*/
			
			if( j == 0 )
			{
				//GAZ: Soap! We're falling back to the next phase line! Let's go! Let's go! You're gonna be left behind!!
				radio_dialogue_queue( "detfallbackremind1" );
			}
			
			if( j == 1 )
			{
				//GAZ: Let's gooo!!! Fall back now!!!
				radio_dialogue_queue( "detfallbackremind2" );
			}
			
			if( j == 2 )
			{
				//PRICE: Soap! Fall back to the next phase line! You're going to get overrun!
				radio_dialogue_queue( "detfallbackremind3" );
				j = 0;
				//m++;
				continue;
			}
			
			j++;
			
			wait normalNagDelayTime;
		}
	}
}

minigun_fallback_shouting_cancel()
{	
	trig = getent( "minigun_fallback_shouting", "targetname" );
	trig waittill ( "trigger" );
	
	flag_set( "stop_minigun_fallback_shouting" );
	
	thread clacker_use_shouting();
}

clacker_use_shouting()
{
	level endon ( "clacker_has_been_exercised" );
	
	wait 5;
	
	//n = 0;
	
	while( !flag( "clacker_has_been_exercised" ) )
	{
		/*
		if( n == 2 )
		{
			break;
		}
		*/
		
		//GAZ: Soap! Use the detonators! There's four of them in the tavern! Move!
		radio_dialogue_queue( "detuseremind1" );
		
		wait 20;
		
		//GAZ: The detonators are on the second floor of the tavern! Check your compass and move! We'll try to hold them off!
		radio_dialogue_queue( "detuseremind2" );
		
		wait 25;
		
		//n++;
	}
}

minigun_use()
{
	flag_wait( "objective_player_uses_minigun" );
	
	level notify ( "southern_hill_attack_stop" );	//stops southern hill attack
}

minigun_primary_attack()
{	
	//Mortar shreds the barbed wire out of the way on the southern hill
	
	barbedDets = getentarray( "barbed_wire_detonator", "targetname" );
	
	thread minigun_barbed_wire_detonate( "southern_hill_barbed_wire_wall_1", barbedDets );
	
	wait 2;
	
	thread minigun_barbed_wire_detonate( "southern_hill_barbed_wire_wall_2", barbedDets );
	
	wait 3;
	
	thread minigun_barbed_wire_detonate( "southern_hill_barbed_wire_wall_3", barbedDets );
	
	autosave_by_name( "southwestern_flanking_assault" );
	
	thread minigun_breach_baglimit();
	
	//startNode = getnode( "southern_hill_waypoint", "targetname" );
	//unitName = "southern_hill_assaulter";
	//endonMsg = "southern_hill_attack_stop";
	
	//squad1 = "spawnRock";
	//squad2 = "spawnRoad";
	//squad3 = "spawnGas";
	
	//thread encroach_start( startNode, unitName, endonMsg, squad1, "southern_hill" );
	
	startnode1 = getnode( "southern_hill_breach_church", "targetname" );
	startnode2 = getnode( "southern_hill_breach_graveyard", "targetname" );
	startnode3 = getnode( "southern_hill_breach_housegap", "targetname" );
	startnode4 = getnode( "southern_hill_breach_flank", "targetname" );
	
	unitName = "southern_hill_breacher";
	
	endonMsg = "halfway_through_field";	//enemy continues to attack heavily until player is in the barn and has picked up the javelin
	
	squad1 = "spawnHillChurch";
	squad2 = "spawnHillGraveyard";
	squad3 = "spawnHillFence";
	squad4 = "spawnHillFlank";
	
	deathmonitorName = "minigun_breach";
	
	level endon ( endonMsg );
	
	while( 1 )
	{	
		thread encroach_start( startNode2, unitName, endonMsg, squad1, deathmonitorName );
		thread encroach_start( startNode2, unitName, endonMsg, squad2, deathmonitorName );		
		thread encroach_start( startNode3, unitName, endonMsg, squad3, deathmonitorName );
		
		wait randomfloatrange( 6, 8 );
		
		thread encroach_start( startNode1, unitName, endonMsg, squad1, deathmonitorName );
		thread encroach_start( startNode2, unitName, endonMsg, squad2, deathmonitorName );		
		thread encroach_start( startNode1, unitName, endonMsg, squad3, deathmonitorName );	
		
		wait randomfloatrange( 9, 11 );	
		
		thread encroach_start( startNode3, unitName, endonMsg, squad1, deathmonitorName );
		thread encroach_start( startNode2, unitName, endonMsg, squad2, deathmonitorName );		
		thread encroach_start( startNode2, unitName, endonMsg, squad3, deathmonitorName );
		//thread encroach_start( startNode4, unitName, endonMsg, squad4, deathmonitorName );	
		
		wait randomfloatrange( 12, 14 );	
	}
}

minigun_breach_deathmonitor()
{
	self waittill ( "death", nAttacker );
	if( isdefined( nAttacker ) && nAttacker == level.player )
	{
		level notify ( "player_killed_minigun_breach_enemy" );
	}
}

minigun_breach_baglimit()
{
	i=0;
	while( i < level.minigunBreachBaglimit )
	{
		level waittill ( "player_killed_minigun_breach_enemy" );
		i++;
	}
	
	flag_set( "objective_minigun_baglimit_done" );
	flag_set( "divert_for_clacker" );
}

minigun_barbed_wire_detonate( barricade, detonators )
{
	obstacle = getentarray( barricade, "targetname" );
	
	for( i = 0; i < detonators.size; i++ )
	{
		det = detonators[ i ];
		if( !isdefined( det.script_noteworthy ) )
			continue;
		if( det.script_noteworthy != barricade )
			continue;
		
		playfx( level.megaExplosion, det.origin );
		det playsound( "explo_mine" );
		earthquake( 0.5, 0.5, level.player.origin, 1250 );
		radiusDamage(det.origin, 256, 1000, 500);	//radiusDamage(origin, range, maxdamage, mindamage);
	}
	
	for( i = 0; i < obstacle.size; i++ )
	{
		obstacle[ i ] delete();
	}
	
	flag_set( "enemy_breached_wire" );
	
	level.magicSniperTalk = true;
}

minigun_firstuse_check()
{
	while( !flag( "minigun_lesson_learned" ) )
	{
		minigun = getent( "minigun", "targetname" );
		minigun waittill( "turretownerchange" );
		minigunUser = minigun getTurretOwner();
		
		if( !isdefined( minigunUser) )
		{
			level notify ( "minigun_session" );
			continue;
		}
		
		if( level.console )
			thread display_hint( "minigun_spin_left_trigger" );
	}
}

/*
minigun_session_check()
{
	//First three uses, player gets the hint to use left trigger
	
	while( level.minigunSessions < 2 )
	{
		level waittill ( "minigun_session" );
		level.minigunSessions++;
	}
	
	flag_set( "minigun_lesson_learned" );
}
*/

minigun_arming_check()
{
	//Checks to see if the player is on the minigun. 
	//Lowers enemy AI accuracy when player is on the minigun.
	
	minigun = getent( "minigun", "targetname" );
	
	while(1)
	{
		minigunUser = minigun getTurretOwner();
		if( !isdefined( minigunUser ) )
		{
			minigun waittill("turretownerchange");
			minigunUser = minigun getTurretOwner();
		}
		
		wait 1;
		
		if((isdefined(minigunUser) && level.player != minigunUser) || !isdefined(minigunUser))
		{
			aEnemy = [];
			aEnemy = getaiarray( "axis" );
			/*
			for( i = 0; i < aEnemy.size; i++ )
			{
				aEnemy[ i ].baseAccuracy = 8;
			}
			*/
		}
		
		if( (isdefined(minigunUser) && level.player == minigunUser) )
		{
			if( !flag( "objective_player_uses_minigun" ) )
			{
				flag_set( "objective_player_uses_minigun" );
				
				wait 2.5;
				
				//"Soap. Keep the minigun spooled up. Fire in bursts, 30 seconds max."
				radio_dialogue_queue( "spooledup" );
			}
			
			aEnemy = [];
			aEnemy = getaiarray( "axis" );
			
			/*
			for( i = 0; i < aEnemy.size; i++ )
			{
				aEnemy[ i ].baseAccuracy = 5;
			}
			*/
		}
	}
}

helidrop()
{
	flag_wait( "objective_minigun_baglimit_done" );
	flag_set( "helidrop_started" );
	
	level.magicSniperTalk = false;
	
	spawn_vehicle_from_targetname_and_drive( "helidrop_01" );
	spawn_vehicle_from_targetname_and_drive( "helidrop_02" );
	spawn_vehicle_from_targetname_and_drive( "helidrop_03" );
	spawn_vehicle_from_targetname_and_drive( "helidrop_04" );
	spawn_vehicle_from_targetname_and_drive( "helidrop_05" );
	
	thread helidrop_rider_setup( "helidrop_01" );
	thread helidrop_rider_setup( "helidrop_02" );
	thread helidrop_rider_setup( "helidrop_03" );
	thread helidrop_rider_setup( "helidrop_04" );
	thread helidrop_rider_setup( "helidrop_05" );
	
	wait 20;
	
	//"We've got a problem here...heads up!"
	radio_dialogue_queue( "headsup" );

	//"Bloody hell, that's a lot of helis innit?"
	radio_dialogue_queue( "lotofhelis" );
	
	//"Soap, fall back to the tavern and man the detonators."
	//iprintln( "Soap, fall back to the tavern and man the detonators." );
	radio_dialogue_queue( "tavern" );
	
	flag_set( "objective_detonators" );
	flag_set( "detonators_activate" );
	
	//"The rest of us will keep them busy from the next defensive line. Everyone move!"
	//iprintln( "The rest of us will keep them busy from the next defensive line. Everyone move!" );
	radio_dialogue_queue( "nextdefensiveline" );
	
	priceNode = getnode( "clacker_fallback_price", "targetname" );
	level.price setgoalnode( priceNode );
	level.price thread hero_scripted_travel();
	
	redshirt1 = getent( "redshirt1", "targetname" );
	redshirt_node1 = getnode( "clacker_fallback_redshirt1", "targetname" );
	redshirt1 setgoalnode( redshirt_node1 );
	redshirt1 thread hero_scripted_travel();
	
	redshirt2 = getent( "redshirt2", "targetname" );
	redshirt_node2 = getnode( "clacker_fallback_redshirt2", "targetname" );
	redshirt2 setgoalnode( redshirt_node2 );
	redshirt2 thread hero_scripted_travel();
	
	sasGunnerNode = getnode( "clacker_fallback_sasGunner", "targetname" );
	level.sasGunner setgoalnode( sasGunnerNode );
	level.sasGunner thread hero_scripted_travel();
	
	thread minigun_fallback_shouting_cancel();
	thread minigun_fallback_shouting();
}

hero_scripted_travel()
{
	self.disableArrivals = true;
	self.goalradius = 16;
	
	self waittill ( "goal" );
	wait 2;
	self.disableArrivals = false;
	self.goalradius = 2048;
}

helidrop_rider_setup( heliName )
{
	heli = getent( heliName, "targetname" );
	aRiders = heli.riders;
	
	for( i = 0; i < aRiders.size; i++ )
	{
		rider = aRiders[ i ];
		rider thread hunt_player( heli );
		rider thread helidrop_clacker_divert( heli );
	}
}

hunt_player( heli )
{
	self endon ( "death" );
	self endon ( "going_to_baitnode" );
	
	if( isdefined( heli ) )
		heli waittill ( "unloaded" );
		
	self.goalradius = 1800;	
	
	//Adjust accuracy of helidrop troops to make them more effective in the larger spaces inherent in this layout
	/*
	switch( level.gameSkill )
	{
		case 0:
			self.baseAccuracy = 1;
			break;
		case 1:
			self.baseAccuracy = 2;
			break;
		case 2:
			self.baseAccuracy = 4;
			break;
		case 3:
			self.baseAccuracy = 5;
			break;
	}
	*/
	
	//Encroach on the player and kill the player
	//When player enters the upper floor of the clacker house a flag is set
	
	self.pathenemyfightdist = 1800;
	self.pathenemylookahead = 1800;
	
	playerHeliDetector = getent( "player_in_blackhawk_detector", "targetname" );
	heliDefaultNode = getnode( "bait_crashsite", "targetname" );
	
	while( self.goalradius > 640 )
	{
		if( level.player isTouching( playerHeliDetector ) )
		{
			self setgoalnode( heliDefaultNode );
		}
		else
		{
			self setgoalpos( level.player.origin );
		}
		
		self.goalradius = self.goalradius * level.encroachRate;	
		self waittill ( "goal" );
		wait randomintrange( 10, 15 );
	}
}

helidrop_clacker_divert( heli )
{
	self endon ( "death" );
	
	if( isdefined( heli ) )
		heli waittill ( "unloaded" );
	
	flag_wait( "player_entered_clacker_house_top_floor" );
	
	self notify ( "going_to_baitnode" );
	
	//if enemy is already within X of player, commits to pursuing player
	//outside of X enemy will maneuver to killzone
	
	baitNode = undefined;
	
	if( isdefined( self.script_noteworthy ) )
	{
		if( self.script_noteworthy == "helidrop_bait_grassyknoll" && !flag( "farslope_exploded" ) )
		{
			baitNode = getnode( "bait_farslope", "targetname" );
		}
		else
		if( self.script_noteworthy == "helidrop_bait_grassyknoll" && flag( "farslope_exploded" ) && !flag( "nearslope_exploded") )
		{
			baitNode = getnode( "bait_nearslope", "targetname" );
		}
		else
		if( self.script_noteworthy == "helidrop_bait_grassyknoll" && flag( "farslope_exploded" ) && flag( "nearslope_exploded" ) )
		{
			if( flag( "fall_back_to_barn" ) )
				flag_wait( "storm_the_tavern" );
				
			self thread hunt_player();
			return;
		}
		else
		if( self.script_noteworthy == "helidrop_bait_crashsite" && !flag( "crashsite_exploded" ) )
		{
			baitNode = getnode( "bait_crashsite", "targetname" );
		}
		else
		if( self.script_noteworthy == "helidrop_bait_crashsite" && flag( "crashsite_exploded" ) && !flag( "cliffside_exploded" ) )
		{
			baitNode = getnode( "bait_crashsite", "targetname" );
		}
		else
		if( self.script_noteworthy == "helidrop_bait_crashsite" && flag( "crashsite_exploded" ) && flag( "cliffside_exploded" ) )
		{
			baitNode = getnode( "bait_crashsite", "targetname" );	//best blocking position
		}
		else
		if( self.script_noteworthy == "helidrop_bait_trees" && !flag( "cliffside_exploded" ) )
		{
			baitNode = getnode( "bait_trees", "targetname" );
		}
		if( self.script_noteworthy == "helidrop_bait_trees" && flag( "cliffside_exploded" ) && !flag( "crashsite_exploded" ) )
		{
			baitNode = getnode( "bait_crashsite", "targetname" );
		}
		else
		if( self.script_noteworthy == "spawnHillFlank" )
		{
			baitNode = getnode( "bait_nearslope", "targetname" );			
		}
		else
		{
			self.goalradius = 2400;	
			
			switch( level.genericBaitCount )
			{
				case 0:
					baitNode = getnode( "bait_nearslope", "targetname" );
					level.genericBaitCount++;
					break;
				case 1:
					baitNode = getnode( "bait_trees", "targetname" );
					level.genericBaitCount = 0;
					break;
			}
		}
	}
	else
	{
		if( flag( "fall_back_to_barn" ) )
			flag_wait( "storm_the_tavern" );
			
		self thread hunt_player();
		return;
	}
	
	distToPlayer = distance( level.player.origin, self.origin );
	wait 0.5;
	distToBaitNode = distance( baitNode.origin, self.origin );
	
	if( ( level.divertClackerRange < distToPlayer ) && ( distToBaitNode < distToPlayer ) )
	{
		self setgoalnode( baitNode );
	}
	
	flag_wait( "fall_back_to_barn" );
	
	//Storm the tavern and the player hardcore
	
	//wait randomfloatrange( 1.5, 2.8 );
	
	if( flag( "fall_back_to_barn" ) )
		flag_wait( "storm_the_tavern" );
	
	self thread hunt_player();
}

tavern_storming_delay()
{	
	trig = getent( "tavern_fallback_shouting", "targetname" );
	trig thread tavern_stop_shouting();
	
	thread tavern_storming_hints();
	
	wait 5;

	if( !flag( "player_running_to_farm" ) )
		flag_clear( "can_save" );
	
	wait 55;
	
	flag_set( "storm_the_tavern" );
}

tavern_storming_hints()
{
	level endon ( "stop_shouting_tavern" );
	
	flag_wait( "objective_armor_arrival" );
	
	for( i = 0; i < 2; i++ )
	{
		//PRICE: "Fall back to the farm at the top of the hill. Let's go. Now."
		radio_dialogue_queue( "fallbacktofarm1" );
		
		wait 1;
		
		if( i < 1 )
		{
			//GAZ: "FALL BAAACK!!! FAALLL BAACK!!!"
			level.gaz anim_single_queue( level.gaz, "fallbackgeneric" );
		}
		
		wait 1;
		
		if( i < 1 )
		{
			//GAZ: "Head for the farm to the north! Go! Go! Go!"
			level.gaz anim_single_queue( level.gaz, "fallbacktofarm3" );
		}
		
		wait 12;
		
		//PRICE: "Soap! You wanna be left behind? Fall back to the farm. Move!"
		radio_dialogue_queue( "fallbacktofarm2" );
		
		wait 12;
		
		//GAZ: "Soap! They're going to overrun your position! Fall back now!"
		radio_dialogue_queue( "tavernoverrunsoon" );
		
		wait 10;
	}
}

tavern_stop_shouting()
{
	self waittill ( "trigger" );
	level notify ( "stop_shouting_tavern" );
	
	flag_set( "player_running_to_farm" );
	flag_set( "can_save" );
	
	autosave_by_name( "running_to_farm" );
}

clacker_primary_attack()
{
	flag_wait( "objective_minigun_baglimit_done" );
	flag_set( "spawncull" );
	
	thread clacker_nearfarslope_check();
	
	startnode4 = getnode( "southern_hill_breach_flank", "targetname" );
	
	unitName = "southern_hill_breacher";
	
	endonMsg = "clacker_far_and_near_slope_done";
	
	squad4 = "spawnHillFlank";
	
	level endon ( endonMsg );
	
	startAttackTrig = getent( "nearfarslope_activation", "targetname" );
	startAttackTrig waittill ( "trigger" );
	
	flag_set( "player_entered_clacker_house_top_floor" );
	
	autosave_by_name( "player_entered_clacker_house" );
	
	flag_wait( "helidrop_started" );
	
	while( 1 )
	{	
		aAxis = undefined;
		aAxis = [];
		aAxis = getaiarray( "axis" );
		if( aAxis.size < 27 )
		{
			thread encroach_start( startNode4, unitName, endonMsg, squad4, undefined );
			wait randomfloatrange( 2, 3 );		
		}
		
		wait 0.5;
	}
}

clacker_nearfarslope_check()
{
	//if player has detonated the near and far slope mines, then stop attacks from the southern hill left flank
	
	flag_wait( "nearslope_exploded" );
	flag_wait( "farslope_exploded" );
	
	flag_set( "clacker_far_and_near_slope_done" );
}

clacker_init()
{
	aUseTrigs = getentarray( "detonator_usetrig", "targetname" );
	aDets = [];
	detEnts = [];
	det = undefined;
	
	for( i = 0; i < aUseTrigs.size; i++ )
	{
		if( !isdefined( aUseTrigs[ i ].target ) )
			continue;
			
		detEnts = getentarray( aUseTrigs[ i ].target, "targetname" );
		
		for( j = 0; j < detEnts.size; j++ )
		{
			det = detEnts[ j ];
			
			if( !isdefined( det.script_namenumber ) )
				continue;
			
			if( det.script_namenumber == "objective_clacker" )
			{
				level.objectiveClackers++;
				aDets[ aDets.size ] = det;
				det hide();
			}
		}
		
		detEnts = [];
	}
	
	for( i = 0; i < aDets.size; i++ )
	{
		markers = [];
		markers = aDets[ i ] clacker_marker_setup();
		aDets[ i ] thread clacker_standby( markers );
	}
}

clacker_marker_setup()
{
	markers = [];
	currentMarker = getent( self.target, "targetname" );	
	
	while( 1 )
	{
		markers[ markers.size ] = currentMarker;
		
		if( isdefined( currentMarker.target ) )
			currentMarker = getent( currentMarker.target, "targetname" );
		else
			break;
		
		wait 0.05;
	}
	
	return( markers );
}

clacker_standby( markers )
{
	assertEX( isdefined( self.targetname ), "clacker use trigger should target the clacker" );
	trig = getent( self.targetname, "target" );
		
	assertEX( isdefined( self.script_noteworthy ), "useVolume should have a targetname matching the clacker script_noteworthy" );
	useVolume = getent( self.script_noteworthy, "targetname" );
	
	flag_wait( "detonators_activate" );
	
	self show();
	
	trigFlag = trig.script_flag_true;
	flag_set( trigFlag );
	
	while( 1 )
	{	
		self thread clacker_markers( useVolume, markers );	
		
		trig sethintstring( &"SCRIPT_PLATFORM_HINT_GET_DETONATOR" );
		trig waittill ( "trigger" );
		
		self thread clacker_enable( trig, useVolume, markers );
		self thread clacker_notouch( trig, useVolume );
	}
}

clacker_markers( useVolume, detMarkers )
{
	//Display the marker effects
	
	objGroup = undefined;
	
	while( isdefined( useVolume ) )
	{
		if( level.player isTouching( useVolume ) )
		{
			setthreatbias( "player", "axis", 50 );	//don't shoot player as much when at detonator window
			
			//effect = spawnFx( getfx( "firelp_small_dl" ), markerPos.origin + (0, 0, 64) );
			
			objGroup = [];
			
			for( i = 0; i < detMarkers.size; i++ )
			{
				obj = spawn( "script_model", ( 0, 0, 0 ) );
				obj setModel( "tag_origin" );  
				obj.angles = ( -90, 0, 0 );
				obj.origin = detMarkers[ i ].origin;
				objGroup[ objGroup.size ] = obj;
				
				playfxontag( getfx( "killzone_marker" ), obj, "tag_origin" );
			}
		}
		
		while( isdefined( useVolume) && level.player isTouching( useVolume ) )
		{
			wait 0.1;
		}
		
		//Remove the glowing hint effects for the killzone if they were generated previously
		
		if( isdefined( objGroup ) )
		{
			assertEX( objGroup.size > 0, "there are no detMarkers to delete" );
			
			count = objGroup.size;
			
			for( i = 0; i < count; i++ )
			{
				objGroup[ i ] delete();
			}
			
			objGroup = undefined;
			
			setthreatbias( "player", "axis", 1000 );	//resume normal aggression when player is not near a detonator window
		}
		
		wait 0.1;
	}
}

clacker_enable( trig, useVolume, markers )
{
	if( level.player isTouching( useVolume ) )
	{
		self hide();	//hide the prop clacker
		
		//Bring up the clacker in hand
		
		flag_set( "got_the_clacker" );
		
		level.player maps\_c4::switch_to_detonator();
		
		self thread clacker_drop( trig, useVolume );
			
		//The use trigger for this specific clacker is deactivated while player has the clacker
			
		trigFlag = trig.script_flag_true;
		flag_clear( trigFlag );
		
		//trig hide();
		//trig trigger_off();
		
		self thread clacker_fire( trig, useVolume, markers );
		
		while( level.player getcurrentweapon() != "c4" )
		{
			wait 0.05;
		}
		
		flag_clear( "got_the_clacker" );
	}
}

clacker_drop( trig, useVolume )
{
	//detects when player switches to another weapon, which automatically counts as 'clacker dropped'
	
	while( isdefined( useVolume) && level.player isTouching ( useVolume ) && !flag( "got_the_clacker" ) )
	{
		//wait 2;
		weapon = level.player getcurrentweapon();
	
		if( weapon != "c4" )
			self thread clacker_disable( trig, useVolume );
			
		wait 0.05;	
	}
}

clacker_notouch(trig, useVolume )
{
	while( isdefined( useVolume ) && level.player isTouching( useVolume ) )
	{
		wait 0.1;
	}
			
	self thread clacker_disable( trig, useVolume );
}

clacker_disable( trig, useVolume )
{
	//Actively disarm the armed clacker
	
	if( isdefined( trig ) )
	{
		level notify ( "detclacker_disarm" );
		flag_clear( "got_the_clacker" );
		
		//If clacker has been picked up
		//and player is not in the detection volume 
		//or player switched weapons away from the clacker
		
		//Return the clacker to its rightful spot
		//Clacker reappears
		
		level.player takeweapon( "c4" );
		self show();
		
		//Reenable use trigger for clacker pickup
		
		trigFlag = trig.script_flag_true;
		flag_set( trigFlag );
		
		//trig show();
		//trig trigger_on();
		
		//Switch to normal weapon	
		
		level.player switchtoweapon( level.player GetWeaponsListPrimaries()[0] );
	}
}

clacker_fire( trig, useVolume, markers )
{
	level endon ( "detclacker_disarm" );

	//Arm the clacker	
	level.player waittill( "detonate" );
	
	flag_set( "clacker_has_been_exercised" );
	
	assertEX( isdefined( trig ), "trig is not defined" );
	
	if( !isdefined( trig ) )
		return;
	
	if( self.script_noteworthy == "detonator_nearslope" )
		flag_set( "nearslope_exploded" );
	
	if( self.script_noteworthy == "detonator_farslope" )
		flag_set( "farslope_exploded" );
	
	if( self.script_noteworthy == "detonator_crashsite" )
		flag_set( "crashsite_exploded" );
	
	if( self.script_noteworthy == "detonator_cliffside" )
		flag_set( "cliffside_exploded" );
	
	thread killzone_detonation( markers, level.player );
	
	earthquake( 0.5, 2, level.player.origin, 1650 );
	
	level.player takeweapon( "c4" );
	level.player switchtoweapon( level.player GetWeaponsListPrimaries()[0] );
	
	//Objective position updating for clackers
	
	//Locate the clacker position that was just used
	
	targ = undefined;
	usedClackerObjectiveMarker = undefined;
	
	trigTargets = getentarray( trig.target, "targetname" );
	
	for( i = 0 ; i < trigTargets.size; i++ )
	{
		targ = trigTargets[ i ];
		
		if( !isdefined( targ.script_noteworthy ) )
			continue;
			
		if( !( targ.script_noteworthy == "clacker_objective_marker" ) )
			continue;
		
		usedClackerObjectiveMarker = targ;
	}
	
	//Get the clacker positions and remove the position that was just used
	
	aManualDets = getentarray( "clacker_objective_marker", "script_noteworthy" );
	
	for( i = 0; i < aManualDets.size; i++ )
	{
		det = aManualDets[ i ];
		if( det == usedClackerObjectiveMarker )
			aManualDets = maps\_utility::array_remove(aManualDets, det);
	}
	
	useVolume delete();
	
	//Reprint the objective with the latest unused clacker positions
	
	objective_delete( 5 );
	objective_add( 5, "active", &"VILLAGE_DEFEND_USE_THE_DETONATORS_IN1" );
	objective_current( 5 );
	
	for( i = 0; i < aManualDets.size; i++ )
	{
		det = aManualDets[ i ];
		if( isdefined( det ) )
			objective_additionalposition( 5, i, det.origin);
	}

	trig delete();
	usedClackerObjectiveMarker delete();
	
	level.objectiveClackers--;
	
	if( !level.objectiveClackers )
	{
		flag_set( "fall_back_to_barn" );
		flag_set( "barn_assault_begins" );
		
		autosave_by_name( "clackers_all_used_up" );
		
		thread tavern_storming_delay();
	}
}

player_interior_detect_init()
{
	level endon ( "farm_reached" );
	
	flag_wait( "fall_back_to_barn" );
	
	detectors = getentarray( "interior_detection_volume", "targetname" );
	
	level.playerIndoors = false;
	n = 0;
	
	while( 1 )
	{
		for( i = 0; i < detectors.size; i++ )
		{
			if( level.player isTouching( detectors[ i ] ) )
			{
				level.playerIndoors = true;
			}
			else
			{
				n++;
			}
			
			wait 0.5;
		}
		
		if( n == detectors.size )
		{
			level.playerIndoors = false;
		}
		
		n = 0;
		
		wait 0.5;
	}
}

enemy_interior_flashbangs()
{
	level endon ( "farm_reached" );
	
	enemyApproachTrig = getent( "enemy_near_interior_trig", "targetname" );
	
	flag_wait( "fall_back_to_barn" );
	
	while( 1 )
	{
		enemyApproachTrig waittill ( "trigger", enemyAI );
		
		enemyAI notify ( "reset_loadout" );
		
		wait 0.1;
		
		if( isdefined( enemyAI ) )
		{		
			enemyAI thread enemy_interior_grenadeswap();
			enemyAI thread enemy_loadout_reset();
		}
	}
}

enemy_interior_grenadeswap()
{
	self endon ( "death" );
	self endon ( "reset_loadout" );
	
	level endon ( "farm_reached" );
	
	while( 1 )
	{
		if( level.playerIndoors )
		{
			self.grenadeammo = 6;
			self.grenadeweapon  = "flash_grenade";
		}
		else
		{
			self.grenadeammo = 6;
			self.grenadeweapon  = "fraggrenade";
			break;
		}
		
		wait 0.5;
	}
}

enemy_loadout_reset()
{
	self endon ( "death" );
	self endon ( "reset_loadout" );
	
	flag_wait( "farm_reached" );
	
	wait 0.5;
	
	self.grenadeammo = 6;
	self.grenadeweapon  = "fraggrenade";
}

javelin_init()
{	
	flag_wait( "fall_back_to_barn" );
	
	javelin = spawn( "weapon_javelin", (1021.1, 7309.2, 1006), 1 ); // suspended
	javelin.angles = (356.201, 346.91, -0.426635);
	
	javelin thread add_jav_glow( "kill_jav_glow" );
	
	javelin waittill ( "trigger" );
	
	flag_set( "got_the_javelin" );
}

tanks_init()
{
	if ( getdvar( "start" ) != "final_battle" && getdvar( "start" ) != "seaknight" )
	{
		flag_wait( "fall_back_to_barn" );
		
		//"We have enemy tanks approaching from the north! (sounds of fighting for a second) Bloody hell I'm hit! Arrrgh - (static)"
		radio_dialogue_queue( "enemytanksnorth" );
		
		//"Mac's in trouble! Soap! Get to the barn at the northern end of the village and stop those tanks! Use the Javelins in the barn!"
		radio_dialogue_queue( "gettothebarn" );
		
		flag_set( "objective_armor_arrival" );
		
		flag_wait( "got_the_javelin" );
		
		//wait randomfloatrange( 3, 5 );
		
		for( i = 1; i < 5; i++ )
		{
			thread tanks_deploy( "tank_backyard_0" + i );
		}
	}
}

tanks_engage( name )
{
	self endon ( "death" );
	level.player endon ( "death" );
	
	node = undefined;
	killzoneTrig = undefined;
	
	if( name == "tank_backyard_01" )
	{
		node = getVehicleNode( "tank1_fire_position", "script_noteworthy" );
		killzoneTrig = getent( "tank_killzone_east", "targetname" );
	}
	else
	if( name == "tank_backyard_02" )
	{
		node = getVehicleNode( "tank2_fire_position", "script_noteworthy" );
		killzoneTrig = getent( "tank_killzone_west", "targetname" );
	}
	else
	if( name == "tank_backyard_03" )
	{
		node = getVehicleNode( "tank3_fire_position", "script_noteworthy" );
		killzoneTrig = getent( "tank_killzone_west", "targetname" );
	}
	else
	if( name == "tank_backyard_04" )
	{
		node = getVehicleNode( "tank4_fire_position", "script_noteworthy" );
		killzoneTrig = getent( "tank_killzone_east", "targetname" );
	}
	
	self setwaitnode( node );
	
	self waittill ("reached_wait_node");

	while( 1 )
	{
		killzoneTrig waittill ( "trigger" );
		self setTurretTargetVec( level.player.origin + ( 0, 0, 72 ) );
		self waittill_notify_or_timeout( "turret_rotate_stopped", 8.0 );
		self fireweapon();
		wait 4;
	}
}

tanks_deploy( name )
{
	tank = spawn_vehicle_from_targetname_and_drive( name );
	tank thread tanks_engage( name );
	
	tank.mgturret[ 0 ].maxrange = 6000;
	
	level.tankid++;
	tanknumber = level.tankid;
	
	tank thread tank_ping( tanknumber );
	
	OFFSET = ( 0, 0, 60 );
	target_set( tank, OFFSET );
	target_setAttackMode( tank, "top" );
	target_setJavelinOnly( tank, true );
	
	tank waittill ( "death" );
	
	level.tankPop--;
	
	if( level.tankPop )
	{
		objective_delete( 8 );
		objective_add( 8, "active", "" );
		objective_string( 8, &"VILLAGE_DEFEND_DESTROY_THE_INCOMING", level.tankPop );
		objective_current( 8 );
		
		autosave_or_timeout( "save_tank_destroyed_with_javelin", 10 );
	}
	else
	{
		flag_set( "objective_all_tanks_destroyed" );
		flag_set( "kill_jav_glow" );
	}
	
	if ( isdefined( tank ) )
	{
		target_remove( tank );	//javelin targeting reticle removal
	}
	
	arcadeMode_kill( tank.origin, "explosive", 1000 );
}

tank_ping( tanknumber )
{
	self endon ( "death" );
	
	while( isalive( self ) )
	{
		objective_additionalposition( 8, tanknumber, self.origin);
		objective_ring( 8 );
		wait 1.2;
	}
}

barn_helidrop()
{	
	if ( getdvar( "start" ) != "final_battle" && getdvar( "start" ) != "javelin" && getdvar( "start" ) != "seaknight" )
	{
		//enemy_heli_reinforcement_shoulder
		//enemy_heli_reinforcement_barncenter
		//enemy_heli_reinforcement_parkinglot
		//enemy_heli_reinforcement_barnleft
		//enemy_heli_reinforcement_cowfield
		
		barnHelidropTrig = getent( "barn_helidrop", "targetname" );
		
		flag_wait( "barn_assault_begins" );
		
		barnHelidropTrig waittill ( "trigger" );
		
		level notify ( "halfway_through_field" );
		
		spawn_vehicle_from_targetname_and_drive( "enemy_heli_reinforcement_shoulder" );
		spawn_vehicle_from_targetname_and_drive( "enemy_heli_reinforcement_barncenter" );
		spawn_vehicle_from_targetname_and_drive( "enemy_heli_reinforcement_cowfield" );
		//spawn_vehicle_from_targetname_and_drive( "enemy_heli_reinforcement_barnleft" );
	}
}

field_fallback()
{
	redshirt1 = getent( "redshirt1", "targetname" );
	redshirt2 = getent( "redshirt2", "targetname" );
	redshirt_node1 = getnode( "field_fallback_redshirt1", "targetname" );
	redshirt_node2 = getnode( "field_fallback_redshirt2", "targetname" );
	priceNode = getnode( "field_fallback_price", "targetname" );
	sasGunnerNode = getnode( "field_fallback_sasGunner", "targetname" );
	
	flag_wait( "fall_back_to_barn" );

	redshirt1 setgoalnode( redshirt_node1 );
	wait 2;

	redshirt2 setgoalnode( redshirt_node2 );	
	wait 2;
	
	level.price setgoalnode( priceNode );
	wait 5;
	
	level.sasGunner setgoalnode( sasGunnerNode );
}

barn_fallback()
{
	redshirt1 = getent( "redshirt1", "targetname" );
	redshirt_node1 = getnode( "barn_fallback_redshirt1", "targetname" );
	
	redshirt2 = getent( "redshirt2", "targetname" );
	redshirt_node2 = getnode( "barn_fallback_redshirt2", "targetname" );
	
	priceNode = getnode( "barn_fallback_price", "targetname" );
	
	sasGunnerNode = getnode( "barn_fallback_sasGunner", "targetname" );
	
	flag_wait( "got_the_javelin" );
	
	redshirt1 setgoalnode( redshirt_node1 );
	wait 1;
	
	redshirt2 setgoalnode( redshirt_node2 );
	wait 2;
	
	level.price setgoalnode( priceNode );	
	wait 3;

	level.sasGunner setgoalnode( sasGunnerNode );
}

escape_fallback()
{	
	trig = getent( "final_lz", "targetname" );
	
	redshirt1 = getent( "redshirt1", "targetname" );
	redshirt_node1 = getnode( "final_rally_gaz", "targetname" );
	
	redshirt2 = getent( "redshirt2", "targetname" );
	redshirt_node2 = getnode( "final_rally_redshirt2", "targetname" );
	
	priceNode = getnode( "final_rally_price", "targetname" );
	
	sasGunnerNode = getnode( "final_rally_redshirt1", "targetname" );
	
	flag_wait( "arm_delaying_action" );
	
	trig waittill ( "trigger" );
	
	flag_set( "lz_reached" );
	
	redshirt2 setgoalnode( redshirt_node2 );
	level.price setgoalnode( priceNode );
	level.sasGunner setgoalnode( sasGunnerNode );
	redshirt1 setgoalnode( redshirt_node1 );
}

final_battle()
{
	if ( getdvar( "start" ) != "seaknight" )
	{
		flag_wait( "start_final_battle" );
		
		wait 6;
		
		flag_set( "airstrikes_ready" );
		
		wait 5;
		
		flag_wait( "falcon_one_finished_talking" );
		
		//"Bravo Six, this is Gryphon Two-Seven. We've just crossed into Azerbaijani airspace. E.T.A. is four minutes. Be ready for pickup."
		radio_dialogue_queue( "etafourminutes" );
		
		autosave_by_name( "start_the_clock" );
	}
	
	thread objective_stopwatch();
	thread countdown_events();
	//thread early_chopper();
	thread rescue_chopper();
	thread mandown_reverse_spawn();
	
	if ( getdvar( "start" ) != "seaknight" )
	{
		if ( getdvar( "village_defend_one_minute") != "1" )
		{	
			//MHP: Bravo Six, The LZ is too hot! We cannot land at the farm! I repeat, we CANNOT land at the farm! We're picking up SAM sites all over these mountains!
			radio_dialogue_queue( "pickingupSAMs" );
			
			thread escape_music();
		
			//GAZ: That's just great!! Where the hell are they gonna land now?
			level.gaz anim_single_queue( level.gaz, "thatsjustgreat" );
			
			//"Bravo Six, we're getting' a lot of enemy radar signatures, we'll try to land closer to the bottom of the hill to avoid a lock-on."
			radio_dialogue_queue( "lzbottomhill" );
			
			
			//GAZ: Is he takin' the piss? We just busted our arses to get to this LZ and now they want us to go all the way back down?!
			radio_dialogue_queue( "takingthepiss" );
		
			//PRICE: Forget it Gaz! We've got to get to the new LZ at the bottom of the hill! Now! Soap! Take point! Go!
			radio_dialogue_queue( "thenewlz" );
		}
		
			flag_set( "objective_get_to_lz" );
			flag_set( "return_trip_begins" );
		
			wait 15;
		
			//Bravo Six, be advised, we're gonna come in low from the south across the river. Recommend you haul ass to LZ Bravo at the base of the hill. Out.
			radio_dialogue_queue( "lzfoxtrot" );
			
			//"Copy Two-Seven! Everyone - head for the landing zone! It's our last chance! Move!"
			radio_dialogue_queue( "headlandingzone" );
	}
}

return_trip_friendly_boost()
{
	flag_wait( "return_trip_begins" );
	
	aAllies = getaiarray( "allies" );
	for( i = 0; i < aAllies.size; i++ )
	{
		if( level.gameSkill == 0 )
			aAllies[ i ].baseAccuracy = 12;
			
		if( level.gameSkill == 1 )
			aAllies[ i ].baseAccuracy = 6;
		
		if( level.gameSkill == 2 )
			aAllies[ i ].baseAccuracy = 2;
			
		if( level.gameSkill == 3 )
			aAllies[ i ].baseAccuracy = 1.5;
	}
}

airstrike_command()
{
	flag_wait( "airstrikes_ready" );
	
	thread callStrike( level.player.origin, 1, ( 0, 110, 0 ) );
	wait 1.2;
	thread callStrike( level.player.origin, 1, ( 0, 96, 0 ) );
	wait 1;
	thread callStrike( level.player.origin, 1, ( 0, 126, 0 ) );
	
	wait 5;
	
	//"Bravo Six, this is Falcon One standing by to provide close air support. Gimme a target over."
	radio_dialogue_queue( "casready" );
	
	if ( isdefined( level.console ) && level.console )
		thread airstrike_hint_console();
	else
		thread airstrike_hint_pc();
	
	level.player giveWeapon( "airstrike_support" );
	level.player SetActionSlot( 2, "weapon" , "airstrike_support" );
	
	thread airstrike_support();
	
	wait 3;
	
	flag_set( "falcon_one_finished_talking" );
	
	flag_wait( "return_trip_begins" );
	
	thread airstrike_frequency_check();
	
	level endon ( "stop_airstrike_reminders" );
	level endon ( "no_airstrike_ammo" );
	
	while( 1 )
	{
		startTime = gettime();
		wait 70;
		
		if( !level.airstrikeCalledRecently )
		{
			//"Bravo Six, this is Falcon One standing by to provide close air support. Gimme a target over."
			radio_dialogue_queue( "casready" );
			
			level.airstrikeCalledRecently = false;	
		}
	}
}

airstrike_frequency_check()
{
	level endon ( "stop_airstrike_reminders" );
	level endon ( "no_airstrike_ammo" );
	
	while( 1 )
	{
		level waittill ( "air_support_called" );
		level.airstrikeCalledRecently = true;
	}
}

farm_javelin_nag()
{	
	wait 8;
	
	while( !flag( "got_the_javelin" ) )
	{
		thread radio_dialogue_queue( "javelinorder2" );
		wait 30;
	}
}

objectives()
{
	minigun = getent( "minigun", "targetname" );
	aManualDets = getentarray( "clacker_objective_marker", "script_noteworthy" );
	farmTrig = getent( "farm_reached_trig", "targetname" );
	extractionPoint = getent( "extraction_point", "targetname" );
	
	if ( is_default_start() )
	{
		wait 25;
	}
	
	objective_add( 1, "active", &"VILLAGE_DEFEND_OBTAIN_NEW_ORDERS_FROM", ( level.price.origin ) );
	objective_current( 1 );
	
	flag_wait( "objective_price_orders_southern_hill" );
	
	objective_state( 1 , "done" );
	
	//playerDefensePos = getnode( "player_southern_start", "targetname" );
	
	flag_set( "aa_southernhill" );
	
	objective_add( 2, "active", &"VILLAGE_DEFEND_TAKE_UP_A_DEFENSIVE_POSITION", ( -732, -1473, 188 ) );
	objective_current( 2 );
	
	//flag_wait( "objective_on_ridgeline" );
	flag_wait( "objective_player_on_ridgeline" );
	
	wait 3;
	
	objective_state( 2 , "done" );
	
	objective_add( 3, "active", &"VILLAGE_DEFEND_DEFEND_THE_SOUTHERN_HILL", ( -732, -1473, 188 ) );
	objective_current( 3 );
	
	autosave_by_name( "ready_for_ambush" );
	
	flag_wait( "objective_price_orders_minigun" );
	
	objective_state( 3 , "done" );
	
	flag_clear( "aa_southernhill" );
	flag_set( "aa_minigun" );
	
	objective_add( 4, "active", &"VILLAGE_DEFEND_FALL_BACK_AND_DEFEND", ( minigun.origin ) );
	objective_current( 4 );
	
	arcademode_checkpoint( 4, "a" );
	
	autosave_by_name( "minigun_defense" );
	
	flag_wait( "objective_detonators" );
	
	objective_state( 4 , "done" );
	
	flag_clear( "aa_minigun" );
	flag_set( "aa_detonators" );
	
	objective_add( 5, "active", &"VILLAGE_DEFEND_USE_THE_DETONATORS_IN", aManualDets[ 0 ].origin );
	objective_current( 5 );
	
	arcademode_checkpoint( 5, "b" );
	
	autosave_by_name( "detonator_defense" );
	
	for( i = 1; i < aManualDets.size; i++ )
	{
		det = aManualDets[ i ];
		
		objective_additionalposition( 5, i, det.origin);
	}
	
	flag_wait( "objective_armor_arrival" );
	
	objective_state( 5, "done" );
	
	flag_clear( "aa_detonators" );
	flag_set( "aa_fallback" );
	
	autosave_by_name( "detonators_all_used_up" );
	
	objective_add( 6, "active", &"VILLAGE_DEFEND_FALL_BACK_TO_THE_FARM", farmTrig.origin );
	objective_current( 6 );
	
	arcademode_checkpoint( 3.5, "c" );
	
	thread farm_javelin_nag();
	
	if ( getdvar( "start" ) != "final_battle" && getdvar( "start" ) != "seaknight" && getdvar( "start" ) != "javelin" )
		farmTrig waittill ( "trigger" );
	
	flag_set( "farm_reached" );
	
	objective_state( 6, "done" );
	
	flag_clear( "aa_fallback" );
	flag_set( "aa_javelin" );
	
	autosave_by_name( "player_got_to_the_farm" );
	
	objective_add( 7, "active", &"VILLAGE_DEFEND_GET_THE_JAVELIN_IN_THE", ( 1021.1, 7309.2, 1006 ) );
	objective_current( 7 );
	
	arcademode_checkpoint( 2, "d" );
	
	//thread radio_dialogue_queue( "javelinorder2" );
	
	flag_wait( "got_the_javelin" );
	
	objective_state( 7, "done" );
	
	autosave_by_name( "got_javelin" );
	
	thread early_chopper();
	
	objective_add( 8, "active", "" );
	objective_string( 8, &"VILLAGE_DEFEND_DESTROY_THE_INCOMING", 4 );
	objective_current( 8 );
	
	arcademode_checkpoint( 4, "e" );
	
	//objective_add( 8, "active", &"VILLAGE_DEFEND_DESTROY_THE_INCOMING", 4 );
	
	flag_wait( "objective_all_tanks_destroyed" );
	
	level.playerSafetyBlocker solid();
	
	objective_string( 8, &"VILLAGE_DEFEND_DESTROY_THE_INCOMING1" );
	objective_state( 8, "done" );
	
	flag_clear( "aa_javelin" );
	flag_set( "aa_returntrip" );
	
	autosave_by_name( "tanks_cleared" );
	
	flag_set( "arm_delaying_action" );
	
	objective_add( 9, "active", &"VILLAGE_DEFEND_SURVIVE_UNTIL_THE_HELICOPTER" );
	objective_current( 9 ); 
	
	arcademode_checkpoint( 3, "f" );
	
	flag_set( "start_final_battle" );
	
	flag_wait( "objective_get_to_lz" );
	
	objective_add( 9, "active", &"VILLAGE_DEFEND_GET_TO_THE_LZ", extractionPoint.origin );
	objective_current( 9 ); 
	
	autosave_by_name( "get_to_the_choppah" );
	
	arcademode_checkpoint( 7, "g" );
	
	priceDist = length( level.price.origin - level.player.origin );
	priceCopy = getent( "price_seaknight_doppel", "targetname" );
	
	gazDist = length( level.gaz.origin - level.player.origin );
	gazCopy = getent( "gaz_seaknight_doppel", "targetname" );
	
	redshirtDist = length( level.redshirt.origin - level.player.origin );
	redshirtCopy = getent( "redshirt_seaknight_doppel", "targetname" );
	
	gunnerDist = length( level.sasgunner.origin - level.player.origin );
	gunnerCopy = getent( "sasGunner_seaknight_doppel", "targetname" );
	
	playerFollowers = [];
	
	playerFollowers[ 0 ] = level.price;
	playerFollowers[ 1 ] = level.gaz;
	playerFollowers[ 2 ] = level.redshirt;
	playerFollowers[ 3 ] = level.sasgunner;
	
	/*
	aAllies = getaiarray( "allies" );
	
	for( i = 0; i < aAllies.size; i++ )
	{
		aAllies[ i ] thread friendly_player_tracking_nav();
	}
	*/
	
	for( i = 0; i < playerFollowers.size; i++ )
	{
		playerFollowers[ i ] thread friendly_player_tracking_nav();
	}
	
	flag_wait( "lz_reached" );
	
	level notify ( "stop_airstrike_reminders" );
	
	thread friendly_pushplayer( "on" );
	
	objective_state( 9, "done" );
	
	objective_add( 10, "active", &"VILLAGE_DEFEND_SURVIVE_UNTIL_THE_HELICOPTER" );
	objective_current( 10 ); 
	
	flag_wait( "seaknight_can_be_boarded" );
	
	objective_state( 10, "done" );
	
	objective_add( 11, "active", &"VILLAGE_DEFEND_BOARD_THE_HELICOPTER", extractionPoint.origin );
	objective_current( 11 ); 
	
	flag_wait( "player_made_it" );
	
	arcademode_checkpoint( 1.75, "h" );
	autosave_by_name( "inside_choppah" );
	
	flag_wait( "outtahere" );
	
	objective_state( 11, "done" );
	
	flag_clear( "aa_returntrip" );
}

autosaves_return_trip()
{
	level endon ( "outtahere" );
	
	flag_wait( "return_trip_begins" );
	
	saveTrig1 = getent( "first_return_save" , "targetname" );
	saveTrig2 = getent( "second_return_save" , "targetname" );
	saveTrig3 = getent( "third_return_save" , "targetname" );
	
	totalTime = level.stopwatch * 60 * 1000;
	startTime = gettime();
	
	saveTrig1 waittill ( "trigger" );
	timeSpent = ( gettime() - startTime ) / 1000;
	maxTimeAllowed = 90;
	thread autosaves_safety( timeSpent, maxTimeAllowed );
	
	saveTrig2 waittill ( "trigger" );
	timeSpent = ( gettime() - startTime ) / 1000;
	maxTimeAllowed = 120;
	thread autosaves_safety( timeSpent, maxTimeAllowed );
	
	saveTrig3 waittill ( "trigger" );
	timeSpent = ( gettime() - startTime ) / 1000;
	//maxTimeAllowed = 160;
	maxTimeAllowed = 180;
	noExceptions = true;
	thread autosaves_safety( timeSpent, maxTimeAllowed, noExceptions );
}

autosaves_safety( timeSpent, maxTimeAllowed, noExceptions )
{
	if( !isdefined( noExceptions ) )
		noExceptions = false;
	
	if( timeSpent <= maxTimeAllowed )
	{
		//autosave_by_name( "return_trip_section" );
		autosave_or_timeout( "return_trip_section", 10 );
		
		if( noExceptions )
			wait 3;
		else 
			wait 10;
			
		flag_clear( "can_save" );
		wait 2;
		flag_set( "can_save" );
	}
}

objective_stopwatch()
{
	flag_wait( "objective_get_to_lz" );
	level notify ( "start stopwatch" );
	
	//fMissionLength = level.stopwatch;							//how long until relieved (minutes)	
	//iMissionTime_ms = gettime() + int(fMissionLength*60*1000);	//convert to milliseconds
	
	// Setup the HUD display of the timer.
	level.hudelem = maps\_hud_util::get_countdown_hud();	
	
	level.hudelem SetPulseFX( 30, 900000, 700 );//something, decay start, decay duration
	countdown = 20 * 60;
	if ( isdefined( level.stopwatch ) )
		countdown = level.stopwatch * 60;

	level.hudelem.label = &"VILLAGE_DEFEND_HELICOPTER_EXTRACTION";// + minutes + ":" + seconds
	level.hudelem settenthstimer( countdown );
	
	
	wait(level.stopwatch*60);
	
	//if( isdefined( level.timer ) )
		//level.timer destroy();
	
	if( isdefined( level.hudelem ) )
		level.hudelem destroy();
}

countdown_speech( alias )
{
	assertEX( isdefined( alias ), "Specify a speech sound." );
	
	level endon ( "player_made_it" );
	
	radio_dialogue_queue( alias );
}


countdown_events()
{	
	flag_wait( "objective_get_to_lz" );
	
	level endon ( "player_made_it" );
	
	missionTime = level.stopwatch * 60;
	
	if ( getdvar( "village_defend_one_minute") != "1" )
	{
		wait 60;
		
		if( !flag( "reached_evac_point" ) && !flag( "lz_reached" ) )
		{
			//Bravo Six, be advised we are almost there but we're low on fuel. You guys have three minutes before we have to leave without you, over.
			thread countdown_speech( "almosttherethree" );
		}
		
		if( !flag( "lz_reached" ) )
		{
			//GAZ: "We're gonna get left behind! We've got to get to the landing zone!"
			thread countdown_speech( "gettolandingzone" );
		}
		
		wait 60;
		
		//You got two minutes, over! *MISSING*
		thread countdown_speech( "twominutesleft" );
		
		if( !flag( "lz_reached" ) )
		{
			//PRICE: Copy that, we're on our way!
			thread countdown_speech( "copywereonourway" );
			
			//PRICE: "We've got to break through their lines to reach the LZ! Keep pushing downhill!"
			thread countdown_speech( "breakthroughtolz" );
			
			//GAZ: Let's go! Let's go! Get down the hill!!
			thread countdown_speech( "getdownthehill" );
		}
		
		wait 30;
		
		//"Ninety seconds to dustoff."
		thread countdown_speech( "ninetysecondsleft" );
		
		flag_set( "rescue_chopper_ingress" );
		
		wait 30;
	}
	
	//"One minute to bingo fuel."
	thread countdown_speech( "oneminutebingo" );
	
	if( !flag( "lz_reached" ) )
	{
		//PRICE: "Get to the bottom of the hill!!! Move move!!!"
		thread countdown_speech( "bottomofthehill" );
	}
	
	wait 30;
	
	//"Thirty seconds."
	thread countdown_speech( "thirtyseconds" );
	
	if( !flag( "lz_reached" ) )
	{
		//GAZ: Get to the LZ! Go! Go!
		thread countdown_speech( "gettothelzgogo" );
	}
	
	wait 30;
	
	if( !flag( "player_made_it" ) )
	{
		flag_set( "seaknight_guards_boarding" );
		flag_wait( "seaknight_unboardable" );
		
		wait 3;
		
		if( !flag( "player_made_it" ) && isalive( level.player ) )
		{
			setDvar( "ui_deadquote", &"VILLAGE_DEFEND_YOU_DIDNT_REACH_THE_HELICOPTER" );
			maps\_utility::missionFailedWrapper();
		}
	}
}

early_chopper()
{
	trig = getent( "early_chopper", "targetname" );
	trig waittill ( "trigger" );
	
	flag_set( "rescue_chopper_ingress" );
}

escape_music()
{
	level endon ( "open_bay_doors" );
	
	MusicPlayWrapper( "village_defend_fallback" );
	wait 94;
	musicStop( 6 );
	wait 6.1;
	
	MusicPlayWrapper( "village_defend_direstraits" );
	wait 83;
	musicStop( 6 );
	wait 6.1;
	
	MusicPlayWrapper( "village_defend_fallback" );
	wait 94;
	musicStop( 6 );
	wait 6.1;
	
	MusicPlayWrapper( "village_defend_direstraits" );
	wait 83;
	musicStop( 6 );
	wait 6.1;
}

seaknight_music()
{
	flag_wait( "open_bay_doors" );
	
	musicStop( 3 );
	wait 3.1;
	
	MusicPlayWrapper( "village_defend_escape" );
}

rescue_chopper()
{
	if ( getdvar( "village_defend_one_minute") != "1" )
		flag_wait( "rescue_chopper_ingress" );
	
	thread seaknight();
	
	flag_wait( "seaknight_can_be_boarded" );
	
	trigger = spawn( "script_origin", (0,0,0) );
	trigger.origin = level.seaknight1 gettagorigin( "tag_door_rear" );
	trigger.radius = 27.731134;
	
	for( ;; )
	{
		wait 0.05;
		
		if ( distance( level.player.origin, trigger.origin ) >= trigger.radius )
			continue;
		else
			break;
	}
	
	if( !flag( "seaknight_unboardable" ) )
	{	
		flag_set( "player_made_it" );
		
		rescue_ride();
		
		thread rescue_teleport_friendlies();
		thread rescue_failsafe();
		
		if( isdefined( level.hudelem ) )
			level.hudelem destroy();
		
		flag_wait( "outtahere" );
		
		wait 2;
		
		//"Baseplate this is Gryphon Two-Seven. We got 'em and we're comin' home. Out."
		radio_dialogue_queue( "cominhome" );
		
		wait 1;
		
		nextmission();
	}
	else
	{
		sniperSoundSource = getent( "intro_tank_tower_target", "targetname" );
		sniperSoundSource playsound( level.sniperfx );
		wait 0.1;
		level.player doDamage( level.player.health + 10000, level.player.origin );
	}
}

rescue_teleport_friendlies()
{	
	wait 2;
	
	priceDist = length( level.price.origin - level.player.origin );
	priceCopy = getent( "price_seaknight_doppel", "targetname" );
	
	gazDist = length( level.gaz.origin - level.player.origin );
	gazCopy = getent( "gaz_seaknight_doppel", "targetname" );
	
	redshirtDist = length( level.redshirt.origin - level.player.origin );
	redshirtCopy = getent( "redshirt_seaknight_doppel", "targetname" );
	
	gunnerDist = length( level.sasgunner.origin - level.player.origin );
	gunnerCopy = getent( "sasGunner_seaknight_doppel", "targetname" );
	
	allowedDist = 1800;
	
	if( priceDist > allowedDist )
	{
		level.price stop_magic_bullet_shield();
		level.price delete();
		priceCopy thread rescue_doppel_spawn();
	}
	
	if( gazDist > allowedDist )
	{
		level.gaz stop_magic_bullet_shield();
		level.gaz delete();
		gazCopy thread rescue_doppel_spawn();
	}
	
	if( redshirtDist > allowedDist )
	{
		level.redshirt stop_magic_bullet_shield();
		level.redshirt delete();
		redshirtCopy thread rescue_doppel_spawn();
	}
	
	if( gunnerDist > allowedDist )
	{
		level.sasgunner stop_magic_bullet_shield();
		level.sasgunner delete();
		gunnerCopy thread rescue_doppel_spawn();
	}
}

rescue_doppel_spawn()
{
	guy = self stalingradSpawn();
	if( spawn_failed( guy ) )
	{
		return;
	}	
	
	guy thread hero();
	guy.fixedNode = false;
	
	guy thread seaknight_sas_load();
}

rescue_failsafe()
{
	//if the friendlies don't board the helicopter for any reason, failsafe
	
	wait 45;
	
	nextmission();
}

rescue_ride()
{
	level.player disableweapons();
	
	// this is the model the player will attach to for the pullout sequence
	ePlayerview = spawn_anim_model( "player_carry" );
	ePlayerview hide();

	// put the ePlayerview in the first frame so the tags are in the right place
	//level.seaknight1 anim_first_frame_solo( ePlayerview, "wounded_seaknight_putdown", "tag_detach" );
	level.seaknight1 anim_first_frame_solo( ePlayerview, "village_player_getin", "tag_detach" );
	
	ePlayerview linkto( level.seaknight1, "tag_detach" );

	// this smoothly hooks the player up to the animating tag
	ePlayerview lerp_player_view_to_tag( "tag_player", 0.5, 0.9, 35, 35, 45, 0 );
	
	guys_animating = [];
	guys_animating[ guys_animating.size ] = ePlayerview;
	
	level.seaknight1 anim_single( guys_animating, "village_player_getin", "tag_detach" );

	/* -- -- -- -- -- -- -- -- -- -- -- - 
	LINK PLAYER TO CURRENT POS TO SEE LANDSCAPE
	 -- -- -- -- -- -- -- -- -- -- -- -- -*/ 		
	level.player enableweapons();
	// < viewpercentag fraction> , <right arc> , <left arc> , <top arc> , <bottom arc> )
	level.player playerlinktodelta( ePlayerview, "tag_player", 1, 20, 45, 5, 25 );
}

music()
{
	//flag_wait( "church_tower_explodes" );
	
	level endon ( "stop_ambush_music" );
	
	if ( getdvar( "start" ) != "final_battle" && getdvar( "start" ) != "seaknight" )
	{
		while( !flag( "stop_ambush_music" ) )
		{
			//MusicPlayWrapper( "village_defend_ambush_music" );
			MusicPlayWrapper( "village_defend_vanguards" );
			wait 85.2;
			musicStop( 0.1 );
			wait 0.15;
		}
	}
}

mandown_reverse_spawn()
{
	trig = getent( "back_spawning_activator", "script_noteworthy" );
	trig waittill ( "trigger" );
	
	flag_set( "back_spawn_stoppable" );
}

//Datatables and Utilities

killzone_detonation( squibs, attacker )
{
	n = 0;
	
	for( i = 0 ; i < squibs.size; i++ )
	{
		squib = squibs[ i ];
		vfx = level.killZoneFxProgram[ n ];
		soundfx = level.killZoneSfx[ n ];
		
		playfx( vfx, squib.origin );
		squib playsound( soundfx );	
		earthquake( 0.1, 0.5, level.player.origin, 1250 );
		
		if( !isdefined( attacker ) )
			radiusDamage(squib.origin, 240, 100500, 100500);	//radiusDamage(origin, range, maxdamage, mindamage);
		else
			radiusDamage(squib.origin, 240, 100500, 100500, attacker);	//radiusDamage(origin, range, maxdamage, mindamage);
		
		n++;
		if( n >= level.killZoneFxProgram.size )
		{
			n = 0;
		}	
		
		wait randomfloatrange( 0.05 , 0.15 );
	}
}

killzoneFxProgram()
{
	level.killZoneFxProgram = [];
	
	level.killZoneFxProgram[ 0 ] = level.killzoneBigExplosion_fx;
	level.killZoneFxProgram[ 1 ] = level.killzoneMudExplosion_fx;
	level.killZoneFxProgram[ 2 ] = level.killzoneBigExplosion_fx;
	level.killZoneFxProgram[ 3 ] = level.killzoneFuelExplosion_fx;
	level.killZoneFxProgram[ 4 ] = level.killzoneDirtExplosion_fx;
	level.killZoneFxProgram[ 5 ] = level.killzoneMudExplosion_fx;
	level.killZoneFxProgram[ 6 ] = level.killzoneBigExplosion_fx;
	level.killZoneFxProgram[ 7 ] = level.killzoneFuelExplosion_fx;
	level.killZoneFxProgram[ 8 ] = level.killzoneDirtExplosion_fx;
	level.killZoneFxProgram[ 9 ] = level.killzoneBigExplosion_fx;
	
	level.killZoneSfx = [];
	
	level.killZoneSfx[ 0 ] = "explo_mine";
	level.killZoneSfx[ 1 ] = "explo_tree";
	level.killZoneSfx[ 2 ] = "explo_mine";
	level.killZoneSfx[ 3 ] = "explo_rock";
	level.killZoneSfx[ 4 ] = "explo_roadblock";
	level.killZoneSfx[ 5 ] = "explo_tree";
	level.killZoneSfx[ 6 ] = "explo_mine";
	level.killZoneSfx[ 7 ] = "explo_rock";
	level.killZoneSfx[ 8 ] = "explo_roadblock";
	level.killZoneSfx[ 9 ] = "explo_mine";
	
	assertEX( level.killZoneFxProgram.size == level.killZoneSfx.size, "Fx and Sfx programs should have equal number of entries." );
}

followScriptedPath( node, delayTime, stance )
{
	if( !isdefined( delayTime ) )
		delayTime = 0;
		
	wait delayTime;
	
	nodes = [];
	
	while( 1 )
	{
		nodes[ nodes.size ] = node;
		
		if( isdefined( node.target ) )
		{
			node = getnode( node.target, "targetname" );
		}
		else
		{
			break;
		}
	}
	
	self.disableArrivals = true;
	
	for( i = 0; i < nodes.size; i++ )
	{
		node = nodes[ i ];
		self setgoalnode( node );
		
		if( isdefined( node.radius ) )
			self.goalradius = node.radius;
		
		if( isdefined( node.script_stance ) )
			self allowedstances( node.script_stance );
		
		self waittill( "goal" );
		if( !isdefined( node.target ) )
			self notify ("reached_last_node_in_chain");
		if( !isdefined( node.script_noteworthy ) )
			continue;
		//if( node.script_noteworthy == "tower_reaction" )
			//continue;
			//iprintln( "Team reacts to bell tower explosion!" );
			//TEMP ANIM OF REACTION TO BELL TOWER EXPLOSION
		
		wait 0.1;
	}	
	
	self.disableArrivals = false;
}

friendly_setup()
{
	aAllies = getaiarray( "allies" );	
	for( i = 0; i < aAllies.size; i++ )
	{
		aAllies[ i ] thread hero();
		aAllies[ i ].grenadeammo = 0;
	}
	
	flag_wait( "objective_price_orders_minigun" );
	
	aAllies = getaiarray( "allies" );	
	for( i = 0; i < aAllies.size; i++ )
	{
		aAllies[ i ].grenadeammo = 5;
	}
}

hero()
{
	self thread magic_bullet_shield();
	self pushPlayer( true );
	self.IgnoreRandomBulletDamage = true;
	self.ignoresuppression = true;
}

//self set_run_anim( "path_slow" );
//self clear_run_anim();

encroach_start( node, groupname, msg, squadname, deathmonitorname )
{
	//node - ent - starting main node for enemy infantry attack run
	//groupname - str - targetname of enemy spawners;
	//msg - str - endon
	//squadname - str - script_noteworthy of enemy spawners' starting area on spawner; 
	
	level endon ( msg );
	
	aGroup = [];
	aSquad = [];
	guy = undefined;
	
	aGroup = getentarray( groupname, "targetname" );
	for( i = 0; i < aGroup.size; i++ )
	{
		if( isdefined( aGroup[ i ].script_noteworthy ) )
		{
			if( aGroup[ i ].script_noteworthy == squadname )
			{
				aSquad[ aSquad.size ] = aGroup[ i ];
			}
		}
	}
	
	for( i = 0; i < aSquad.size; i++ )
	{
		aSquad[ i ].count = 1;
		guy = aSquad[ i ] stalingradSpawn();
		if( spawn_failed( guy ) )
		{
			return;
		}
		
		if( flag( "no_more_grenades" ) )
			self.grenadeammo = 0;
		
		guy thread encroach_nav( node, msg );
		
		minigun = getent( "minigun", "targetname" );
		minigunUser = minigun getTurretOwner();
		/*
		if((isdefined(minigunUser) && level.player == minigunUser))
		{
			guy.baseAccuracy = 5;
		}
		*/
		
		if( isdefined( deathmonitorname ) )
		{
			if( deathmonitorname == "southern_hill" )
				guy thread southern_hill_deathmonitor();
		}
		
		if( isdefined( deathmonitorname ) )
		{
			if( deathmonitorname == "minigun_breach" )
				guy thread minigun_breach_deathmonitor();
		}
	}
}

encroach_nav( node, msg )
{
	level endon ( msg );
	self endon ( "death" );
	
	if( !flag( "objective_minigun_baglimit_done" ) )
	{
		aRoutes = [];
		startNode = node;
		n = undefined;
		while( 1 )
		{
			aRoutes[ aRoutes.size ] = startNode;
			if( isdefined( startNode.target ) )
			{
				aBranchNodes = getnodearray( startNode.target, "targetname" );
				assertEX( aBranchNodes.size > 0, "At least one node should be targeted for encroach_nav routes" );
				
				n = randomint( aBranchNodes.size );
				startNode = aBranchNodes[ n ];
			}
			else
			{
				break;
			}
		}
		
		for( i = 0; i < aRoutes.size; i++ )
		{
			self setgoalnode( aRoutes[ i ] );
			self waittill ( "goal" );
			wait randomfloatrange( level.encroachMinWait, level.encroachMaxWait );
		}
		
		//flag_wait( "objective_minigun_baglimit_done" );
		flag_wait( "divert_for_clacker" );
	}
	
	if( flag( "fall_back_to_barn" ) )
		flag_wait( "storm_the_tavern" );
	
	self thread hunt_player();
	self thread helidrop_clacker_divert();
}

southern_hill_mortar_detonate( squib )
{
	//squib = origin ent
	//inFX = incoming sound
	//detFX = explosion sound
	
	vfx = level.killzoneBigExplosion_fx;
	inFX = "artillery_incoming";
	detFX = [];
	detFX[ 0 ] = "explo_mine";
	detFX[ 1 ] = "explo_rock";
	detFX[ 2 ] = "explo_tree";
	
	squib playsound( inFX );
	wait 0.25;
		
	playfx( vfx, squib.origin );
	
	j = randomintrange( 0, detFX.size );
	detSound = detFX[ j ];
	squib playsound( detSound );
	earthquake( 0.35, 0.5, level.player.origin, 1250 );
	radiusDamage(squib.origin, 256, 1000, 500);	//radiusDamage(origin, range, maxdamage, mindamage);
}

//=======================================================================

begin_delaying_action()
{
	flag_wait( "arm_delaying_action" );
	
	if ( level.gameSkill == 0 )
	{
		//level.detectionCycleTime = 120;
		level.detectionCycleTime = 60;
	}
	
	if ( level.gameSkill == 1 )
	{
		//level.detectionCycleTime = 90;
		level.detectionCycleTime = 25;
	}
	
	if ( level.gameSkill == 2 )
	{
		//level.detectionCycleTime = 60;
		level.detectionCycleTime = 22;
	}
	
	if ( level.gameSkill == 3 )
	{
		//level.detectionCycleTime = 50;
		level.detectionCycleTime = 19;
	}
	
	trig = getent( "delaying_action_trigger", "targetname" );
	trig waittill ( "trigger" );	
	
	flag_set( "engage_delaying_action" );
}

begin_delaying_action_timeout()
{
	flag_wait( "arm_delaying_action" );
	
	wait 180;
	flag_set( "engage_delaying_action" );
}

//=======================================================================

player_detection_volume_init()
{
	aVolumes = getentarray( "player_detection_volume", "targetname" );
	
	for( i = 0; i < aVolumes.size; i++ )
	{
		aSpawnProcs = player_detection_collect( aVolumes[ i ] );
		aProcEntsContainer = player_spawnProc_ents_collect( aVolumes[ i ] );
		thread player_detection_loop( aVolumes[ i ], aSpawnProcs, aProcEntsContainer );
	}
}

player_detection_collect( detectionVolume )
{
	aSpawnProcs = getentarray( detectionVolume.target, "targetname" );
	
	aProcEnts = [];
	
	for( i = 0; i < aSpawnProcs.size; i++ )
	{
		aProcEnts = getentarray( aSpawnProcs[ i ].target, "targetname" );
	}
	
	return( aSpawnProcs );
}

player_spawnProc_ents_collect( detectionVolume )
{
	aSpawnProcs = getentarray( detectionVolume.target, "targetname" );
	
	aProcEntsContainer = [];
	
	for( i = 0; i < aSpawnProcs.size; i++ )
	{
		aProcEnts = getentarray( aSpawnProcs[ i ].target, "targetname" );
		aProcEntsContainer[ aProcEntsContainer.size ] = aProcEnts; 
	}
	
	return( aProcEntsContainer );
}

player_detection_loop( detectionVolume, aSpawnProcs, aProcEntsContainer )
{
	level endon ( "engage_delaying_action" );
	
	flag_wait( "fall_back_to_barn" );
	
	while( 1 )
	{
		//Check AI population capacity before spawning
		
		aAxis = getaiarray( "axis" );
		aAllies = getaiarray( "allies" );
		
		//Some overspawning is ok but not too much
		
		aiPop = aAxis.size + aAllies.size;
		slotsAvailable = level.maxAI - aiPop;
	
		//Detect player position using isTouching volume
		
		if( slotsAvailable >= level.reqSlots )
		{
			if( level.player isTouching( detectionVolume ) )
			{
				thread ai_spawnprocessor( detectionVolume, aSpawnProcs, aProcEntsContainer );
				
				if( flag( "objective_all_tanks_destroyed" ) )
					level.delayingActionEnemyWaves++;
				
				if( level.delayingActionEnemyWaves >= level.enemyWavesAllowed )
					flag_set( "engage_delaying_action" );
			}
			
			wait level.detectionCycleTime;
		}
		
		wait 0.5;
	}
}

ai_spawnprocessor( detectionVolume, aSpawnProcs, aProcEntsContainer )
{
	//Activate the spawn processors for this detection volume
	
	for( i = 0; i < aSpawnProcs.size; i++ )
	{
		thread ai_spawn_control_set_create( aSpawnProcs[ i ], detectionVolume, aProcEntsContainer[ i ] );
	}	
}

ai_spawn_control_set_create( spawnProc, detectionVolume, procEntsContainer )
{	
	//Get the spawners for this unit
	
	aProcSpawners = [];
	
	for( i = 0; i < level.aSpawners.size; i++ )
	{
		spawner = level.aSpawners[ i ];
		
		if( !isdefined( spawner.targetname ) )
			continue;
		
		if( spawner.targetname == spawnProc.target )
		{
			aProcSpawners[ aProcSpawners.size ] = spawner;
		}
	}
	
	//Check for smokescreen usage on this unit and get the smoke generator if it exists
	
	smokeEnt = undefined;
	aProcEnts = [];
	aProcEnts = procEntsContainer;
	
	for( i = 0; i < aProcEnts.size; i++ )
	{			
		procEnt = aProcEnts[ i ];
	
		if( !isdefined( procEnt.script_noteworthy ) )
		{
			continue;
		}
		
		if( procEnt.script_noteworthy == "smoke_generator" )
		{
			smokeEnt = procEnt;
			break;
		}
	}
	
	//Get the flank routing node for this unit
	
	routeNode = undefined;
	assertEX( isdefined( spawnProc.script_namenumber ), "Spawn processor is missing a routing label e.g. AR15" );
	routeID = spawnProc.script_namenumber;
	
	for( i = 0; i < level.aRouteNodes.size; i++ )
	{
		routeStartNode = level.aRouteNodes[ i ];
		
		if( !isdefined( routeStartNode.script_noteworthy ) )
			continue;
		
		if( routeStartNode.script_noteworthy == routeID )
		{
			routeNode = routeStartNode;
			break;
		}
	}
	
	thread ai_spawn_and_attack( aProcSpawners, smokeEnt, routeNode, detectionVolume );
}

ai_spawn_and_attack( spawners, smokeEnt, routeNode, detectionVolume )
{
	//If smoke is being deployed to cover the spawn:
	//1. Wait X seconds for the smoke to build to sufficient opacity and size
	//2. Confirm that the player is far enough from the smoke cloud origin
	//3. Spawn and attack along assigned routes and run the reacquisition monitor 
	
	if( isdefined( smokeEnt ) )
	{
		playfx( level.smokegrenade, smokeEnt.origin );
		wait level.smokeBuildTime;
		
		dist = length( level.player.origin - smokeEnt.origin );
		if( dist < level.smokeSpawnSafeDist )
		{
			return;
		}
	}
		
	//If smoke is not being used to cover the spawn:
	//1. Spawn and attack along assigned routes and run the reacquisition monitor 
	
	//Spawners become finite during the return trip
	
	for( i = 0; i < spawners.size; i++ )
	{
		spawner = spawners[ i ];
		
		/*
		if( flag( "return_trip_begins" ))
		{
			if( !isdefined( spawner[ i ].script_namenumber ) )
			{
				if( level.gameSkill == 0 )
				{
					spawner[ i ].count = 3;
					self.baseAccuracy = 0.3;
				}
				else
				if( level.gameSkill == 1 )
				{
					spawner[ i ].count = 4;
					self.baseAccuracy = 0.5;
				}
				else
				if( level.gameSkill == 2 )
				{
					spawner[ i ].count = 5;
				}
				else
				if( level.gameSkill == 3 )
				{
					spawner[ i ].count = 6;
				}
			}
				
			spawner[ i ].script_namenumber = true;
		}
		else
		{
			spawners[ i ].count = 1;
		}
		*/
		
		spawners[ i ].count = 1;
		
		totalPop = aiPopCount();
		
		if( totalPop < 32 )
		{
			guy = spawner stalingradSpawn();
			if( spawn_failed( guy ) )
			{
				continue;
			}
			
			if( flag( "no_more_grenades" ) )
				self.grenadeammo = 0;
			
			guy thread ai_flank_route( routeNode );
			guy thread ai_reacquire_player( detectionVolume );
		}
	}
}

ai_flank_route( routeNode )
{
	self endon ( "death" );
	self endon ( "reacquire_player" );
	
	while( 1 )
	{
		self setgoalnode( routeNode );
		
		if( isdefined( routeNode.radius ) )
			self.goalradius = routeNode.radius;
		
		self waittill ( "goal" );
		
		if( isdefined( routeNode.script_node_pausetime ) )
		{
			pauseTime = routeNode.script_node_pausetime + randomfloatrange( 0.5, 1.5 );
			
			wait( pauseTime );
		}
		
		if( !isdefined( routeNode.target ) )
		{
			if( flag( "fall_back_to_barn" ) )
				flag_wait( "storm_the_tavern" );
				
			self thread hunt_player();
			break;
		}
		
		routeNode = getnode( routeNode.target, "targetname" );
	}
}

ai_reacquire_player( detectionVolume )
{	
	//If player leaves the original detection volume substantially, the
	//1. Check to see that the player is still touching the volume.
	//2. Wait a bit, then resample to see if the player is still touching the volume.
	//3. If not, send the guy after the player using hunt_player.

	self endon ( "death" );
	
	while( 1 )
	{
		if( !level.player isTouching ( detectionVolume ) )
		{
			wait level.volumeDesertionTime;
			
			if( !level.player isTouching ( detectionVolume ) )
			{
				self notify ( "reacquire_player" );
				wait 0.5;
				
				if( flag( "fall_back_to_barn" ) )
					flag_wait( "storm_the_tavern" );
					
				self thread hunt_player();
				break;
			}
		}
		
		wait level.detectionRefreshTime;
	}
}

return_trip_enemy_acc_prep()
{
	aFloods = getentarray( "flood_spawner" , "targetname" );
	aSpawners = [];
	
	for( i = 0 ; i < aFloods.size; i++ )
	{
		aSpawners = getentarray( aFloods[ i ].target, "targetname" );
		array_thread( aSpawners, ::add_spawn_function, ::return_trip_enemy_acc );
		
		aSpawners = undefined;
		aSpawners = [];
	}
}

return_trip_enemy_acc()
{
	flag_wait( "start_final_battle" );
	
	self.baseAccuracy = level.village_diff[ level.gameskill ];
}

//=======================================================================

add_hint_background( double_line )
{
	if ( isdefined ( double_line ) )
		level.hintbackground = createIcon( "popmenu_bg", 650, 50 );
	else
		level.hintbackground = createIcon( "popmenu_bg", 650, 30 );
	
	level.hintbackground setPoint( "TOP", undefined, 0, 125 );
	level.hintbackground.alpha = .5;
}

airstrike_hint_console()
{
	add_hint_background();
	
	//Airstrikes standing by.
	level.hintElem = createFontString( "objective", level.hint_text_size );
	level.hintElem setPoint( "TOP", undefined, 0, 130 );
	//level.hintElem.label = &"VILLAGE_DEFEND_CASREADY";
	level.hintElem setText( &"VILLAGE_DEFEND_CLOSE_AIR_SUPPORT_STANDING" );
	
	level.iconElem = createIcon( "hud_dpad", 32, 32 );
	level.iconElem setPoint( "TOP", undefined, -16, 165 );
	
	level.iconElem2 = createIcon( "compass_objpoint_airstrike", 32, 32 );
	level.iconElem2 setPoint( "TOP", undefined, -15, 196 );	
	
	level.iconElem3 = createIcon( "hud_arrow_down", 24, 24 );
	level.iconElem3 setPoint( "TOP", undefined, -15.5, 170 );
	level.iconElem3.sort = 1;
	level.iconElem3.color = (1,1,0);
	level.iconElem3.alpha = .7;
	
	wait 4;

	level.iconElem setPoint( "CENTER", "BOTTOM", -320, -20, 1.0 );
	level.iconElem2 setPoint( "CENTER", "BOTTOM", -320, -20, 1.0 );
	level.iconElem3 setPoint( "CENTER", "BOTTOM", -320, -20, 1.0 );
	
	level.iconElem scaleovertime(1, 20, 20);
	level.iconElem2 scaleovertime(1, 20, 20);
	level.iconElem3 scaleovertime(1, 20, 20);
	
	wait .70;
	
	level.hintElem fadeovertime(.15);
	level.hintElem.alpha = 0;
	
	level.iconElem fadeovertime(.15);
	level.iconElem.alpha = 0;
	
	level.iconElem2 fadeovertime(.15);
	level.iconElem2.alpha = 0;
	
	level.iconElem3 fadeovertime(.15);
	level.iconElem3.alpha = 0;
	
	clear_hints();
}

airstrike_hint_pc()
{
	add_hint_background();
	
	//Airstrikes standing by.
	level.hintElem = createFontString( "objective", level.hint_text_size );
	level.hintElem setPoint( "TOP", undefined, 0, 130 );
	//level.hintElem.label = &"VILLAGE_DEFEND_CASREADY";
	level.hintElem setText( &"VILLAGE_DEFEND_CLOSE_AIR_SUPPORT_STANDING_PC" );
	
	level.iconElem2 = createIcon( "compass_objpoint_airstrike", 32, 32 );
	level.iconElem2 setPoint( "TOP", undefined, -15, 196 );	
	
	wait 4;
	
	level.iconElem2 setPoint( "CENTER", "BOTTOM", -320, -20, 1.0 );
	
	level.iconElem2 scaleovertime(1, 20, 20);
	
	wait .70;
	
	level.hintElem fadeovertime(.15);
	level.hintElem.alpha = 0;
	
	level.iconElem2 fadeovertime(.15);
	level.iconElem2.alpha = 0;
	
	clear_hints();
}

clear_hints()
{
	if ( isDefined( level.hintElem ) )
		level.hintElem destroyElem();
	if ( isDefined( level.iconElem ) )
		level.iconElem destroyElem();
	if ( isDefined( level.iconElem2 ) )
		level.iconElem2 destroyElem();
	if ( isDefined( level.iconElem3 ) )
		level.iconElem3 destroyElem();
	if ( isDefined( level.hintbackground ) )
		level.hintbackground destroyElem();
	level notify ( "clearing_hints" );
}

airstrike_support()
{
	level.playerPreviousWeapon = undefined;
	
	for(;;)
	{
		while( level.player getcurrentweapon() != "airstrike_support" )
		{
			level.playerPreviousWeapon = level.player getcurrentweapon();
			wait 0.05;
		}
		
		airstrike_ammo = level.player getWeaponAmmoStock( "airstrike_support" );
		
		if( !isdefined( airstrike_ammo ) )
		{
			break;
		}
		else
		if( airstrike_ammo == 0 )
		{
			break;		
		}
		
		thread airstrike_support_activate();
		
		while( level.player getcurrentweapon() == "airstrike_support" )
			wait 0.05;
		
		level notify( "air_support_canceled" );
		thread airstrike_support_deactive();
	}
}

airstrike_support_activate()
{
	level endon( "air_support_canceled" );
	level endon( "air_support_called" );
	thread airstrike_support_paint_target();
	
	// Make the arrow
	level.airstrikeAttackArrow = spawn( "script_model", ( 0, 0, 0 ) );
	level.airstrikeAttackArrow setModel( "tag_origin" );
	level.airstrikeAttackArrow.angles = ( -90, 0, 0 );
	level.airstrikeAttackArrow.offset = 4;
	
	playfxontag( level.air_support_fx_yellow, level.airstrikeAttackArrow, "tag_origin" );
	
	level.playerActivatedAirSupport = true;
	
	coord = undefined;
	
	traceOffset = 15;
	traceLength = 15000;
	minValidLength = 300 * 300;
	
	trace = [];
	
	trace[ 0 ] = spawnStruct();
	trace[ 0 ].offsetDir = "vertical";
	trace[ 0 ].offsetDist = traceOffset;
	
	trace[ 1 ] = spawnStruct();
	trace[ 1 ].offsetDir = "vertical";
	trace[ 1 ].offsetDist = traceOffset * -1;
	
	trace[ 2 ] = spawnStruct();
	trace[ 2 ].offsetDir = "horizontal";
	trace[ 2 ].offsetDist = traceOffset;
	
	trace[ 3 ] = spawnStruct();
	trace[ 3 ].offsetDir = "horizontal";
	trace[ 3 ].offsetDist = traceOffset * -1;
	
	for(;;)
	{
		wait 0.05;
		
		prof_begin( "spotting_marker" );
		
		// Trace to where the player is looking
		direction = level.player getPlayerAngles();
		direction_vec = anglesToForward( direction );
		eye = level.player getEye();
		
		for ( i = 0 ; i < trace.size ; i++ )
		{
			start = eye;
			vec = undefined;
			if ( trace[ i ].offsetDir == "vertical" )
				vec = anglesToUp( direction );
			else if ( trace[ i ].offsetDir == "horizontal" )
				vec = anglesToRight( direction );
			assert( isdefined( vec ) );
			start = start + vector_multiply( vec, trace[ i ].offsetDist );
			trace[ i ].trace = bullettrace( start, start + vector_multiply( direction_vec , traceLength ), 0, undefined );
			trace[ i ].length = distanceSquared( start, trace[ i ].trace[ "position" ] );
			
			if ( getdvar( "village_defend_debug_marker") == "1" )
				thread draw_line_for_time( start, trace[ i ].trace[ "position" ], 1, 1, 1, 0.05 );
		}
		
		validLocations = [];
		validNormals = [];
		for ( i = 0 ; i < trace.size ; i++ )
		{
			if ( trace[ i ].length < minValidLength )
				continue;
			index = validLocations.size;
			validLocations[ index ] = trace[ i ].trace[ "position" ];
			validNormals[ index ] = trace[ i ].trace[ "normal" ];
			
			if ( getdvar( "village_defend_debug_marker") == "1" )
				thread draw_line_for_time( level.player getEye(), validLocations[ index ], 0, 1, 0, 0.05 );
		}
		
		// if all points are too close just use all of them since none are good
		if ( validLocations.size == 0 )
		{
			for ( i = 0 ; i < trace.size ; i++ )
			{
				validLocations[ i ] = trace[ i ].trace[ "position" ];
				validNormals[ i ] = trace[ i ].trace[ "normal" ];
			}
		}
		
		assert( validLocations.size > 0 );
		
		if ( validLocations.size == 4 )
		{
			fxLocation = findAveragePointVec( validLocations[ 0 ], validLocations[ 1 ], validLocations[ 2 ], validLocations[ 3 ] );
			fxNormal = findAveragePointVec( validNormals[ 0 ], validNormals[ 1 ], validNormals[ 2 ], validNormals[ 3 ] );
		}
		else if ( validLocations.size == 3 )
		{
			fxLocation = findAveragePointVec( validLocations[ 0 ], validLocations[ 1 ], validLocations[ 2 ] );
			fxNormal = findAveragePointVec( validNormals[ 0 ], validNormals[ 1 ], validNormals[ 2 ] );
		}
		else if ( validLocations.size == 2 )
		{
			fxLocation = findAveragePointVec( validLocations[ 0 ], validLocations[ 1 ] );
			fxNormal = findAveragePointVec( validNormals[ 0 ], validNormals[ 1 ] );
		}
		else
		{
			fxLocation = validLocations[ 0 ];
			fxNormal = validNormals[ 0 ];
		}
		
		if ( getdvar( "village_defend_debug_marker") == "1" )
			thread draw_line_for_time( level.player getEye(), fxLocation, 1, 0, 0, 0.05 );
		
		// Draw the arrow and circle around the arrow
		thread drawAirstrikeAttackArrow( fxLocation, fxNormal );
		
		prof_end( "spotting_marker" );
	}
}

findAveragePointVec( point1, point2, point3, point4 )
{
	assert( isdefined( point1 ) );
	assert( isdefined( point2 ) );
	
	if ( isdefined( point4 ) )
	{
		x = findAveragePoint( point1[ 0 ], point2[ 0 ], point3[ 0 ], point4[ 0 ] );
		y = findAveragePoint( point1[ 1 ], point2[ 1 ], point3[ 1 ], point4[ 1 ] );
		z = findAveragePoint( point1[ 2 ], point2[ 2 ], point3[ 2 ], point4[ 2 ] );
	}
	else if ( isdefined( point3 ) )
	{
		x = findAveragePoint( point1[ 0 ], point2[ 0 ], point3[ 0 ] );
		y = findAveragePoint( point1[ 1 ], point2[ 1 ], point3[ 1 ] );
		z = findAveragePoint( point1[ 2 ], point2[ 2 ], point3[ 2 ] );
	}
	else
	{	
		x = findAveragePoint( point1[ 0 ], point2[ 0 ] );
		y = findAveragePoint( point1[ 1 ], point2[ 1 ] );
		z = findAveragePoint( point1[ 2 ], point2[ 2 ] );
	}
	return( x, y, z );
}

findAveragePoint( point1, point2, point3, point4 )
{
	assert( isdefined( point1 ) );
	assert( isdefined( point2 ) );
	
	if ( isdefined( point4 ) )
		return ( ( point1 + point2 + point3 + point4 ) / 4 );
	else if ( isdefined( point3 ) )
		return ( ( point1 + point2 + point3 ) / 3 );
	else
		return ( ( point1 + point2 ) / 2 );
}

drawAirstrikeAttackArrow( coord, normal )
{	
	assert( isdefined( level.airstrikeAttackArrow ) );
	
	coord += vector_multiply( normal, level.airstrikeAttackArrow.offset );
	level.airstrikeAttackArrow.origin = coord;
	level.airstrikeAttackArrow rotateTo( vectortoangles( normal ), 0.2 );
}

airstrike_support_deactive()
{
	wait 0.05;
	if ( isdefined( level.airstrikeAttackArrow ) )
		level.airstrikeAttackArrow delete();
}

airstrike_support_paint_target()
{
	level endon( "air_support_canceled" );
	level.player waittill ( "weapon_fired" );
	
	flag_set( "airstrike_in_progress" );
	
	maps\_friendlyfire::TurnOff();
	
	level.activeAirstrikes++;
	
	airstrike_ammo = level.player getWeaponAmmoStock( "airstrike_support" );
		
	if( !isdefined( airstrike_ammo ) )
	{
		level notify ( "no_airstrike_ammo" );
	}
	else
	if( airstrike_ammo == 0 )
	{
		level notify ( "no_airstrike_ammo" );
	}
	
	thread airstrike_support_mark();
	
	// give player his weapon back
	
	weaponList = level.player GetWeaponsListPrimaries();
	
	if ( isdefined( weaponList[ 0 ] ) && ( weaponList[ 0 ] == level.playerPreviousWeapon ) )
	{
		level.player switchToWeapon( weaponList[ 0 ] );
	}
	else
	if ( isdefined( weaponList[ 1 ] ) && ( weaponList[ 1 ] == level.playerPreviousWeapon ) )
	{
		level.player switchToWeapon( weaponList[ 1 ] );
	}
	else
	{
		level.player switchToWeapon( weaponList[ 0 ] );
	}
	
	coord = level.airstrikeAttackArrow.origin;
	
	thread airstrike_support_launch( coord );
	
	level notify( "air_support_called" );
	airstrike_support_deactive();
	
	level.airstrikeSupportCallsRemaining--;
	
	if ( ( level.airstrikeSupportCallsRemaining % 2 ) == 0 )
		radio_dialogue_queue( "airstrikewarning" );
	else
	if ( ( level.airstrikeSupportCallsRemaining % 2 ) != 0 )
		radio_dialogue_queue( "airstrikewarning" );
	else
	if ( level.airstrikeSupportCallsRemaining <= 0 )
		radio_dialogue_queue( "airstrikewarning" );
}

airstrike_support_launch( coord )
{
	wait 5;
	
	thread callStrike( coord );
}

airstrike_support_mark()
{
	marker = spawn( "script_model", level.airstrikeAttackArrow.origin );
	marker setModel( "tag_origin" );
	marker.angles = level.airstrikeAttackArrow.angles;
	
	wait 0.1;
	
	playfxontag( level.air_support_fx_red, marker, "tag_origin" );
	
	wait 5.0;
	
	marker delete();
}

//=======================================================================

callStrike( coord, flybyOnly, direction )
{	
	// Get starting and ending point for the plane
	
	if( !isdefined( direction ) )
	{
		//direction = ( 0, randomint( 360 ), 0 );
	
		//get vector between player's current position and the target coordinates and pick a good flight path start point
		//so that the planes don't cluster bomb the player, which is annoying
		
		vec =  coord - level.player.origin;
		angles = vectortoangles( vec );
		yaw = angles[ 1 ];
		
		spread = 75;

		for ( ;; )
		{		
			direction = ( 0, randomint( 360 ), 0 );
			absyawdiff = animscripts\utility::AbsAngleClamp180( yaw - direction[ 1 ] );
			if ( absyawdiff < 180 - spread )
				break;
			if ( absyawdiff > 180 + spread )
				break;
			wait 0.05;
		}
	}
			
	planeHalfDistance = 24000;
	planeBombExplodeDistance = 200;	//1500
	
	if( level.lowplaneflyby < 3 )
	{
		planeFlyHeight = 850;
		level.lowplaneflyby++;
	}
	else
	{
		planeFlyHeight = 1850;	//850 original
	}
	
	planeFlySpeed = 6000;	//7000

	startPoint = coord + vector_scale( anglestoforward( direction ), -1 * planeHalfDistance );
	startPoint += ( 0, 0, planeFlyHeight );

	endPoint = coord + vector_scale( anglestoforward( direction ), planeHalfDistance );
	endPoint += ( 0, 0, planeFlyHeight );
	
	// Make the plane fly by
	d = length( startPoint - endPoint );
	flyTime = ( d / planeFlySpeed );
	
	// bomb explodes planeBombExplodeDistance after the plane passes the center
	d = abs( d/2 + planeBombExplodeDistance  );
	bombTime = ( d / planeFlySpeed );
	
	assert( flyTime > bombTime );
	
	if( isdefined( flybyOnly ) )
	{
		level thread doPlaneStrike( coord, startPoint+(0,0,randomInt(500)), endPoint+(0,0,randomInt(500)), bombTime, flyTime, direction, flybyOnly );	
		return;
	}
	
	level thread doPlaneStrike( coord, startPoint+(0,0,randomInt(500)), endPoint+(0,0,randomInt(500)), bombTime, flyTime, direction );
	wait randomfloatrange( 1.5, 2.5 );
	level thread doPlaneStrike( coord, startPoint+(0,0,randomInt(200)), endPoint+(0,0,randomInt(200)), bombTime, flyTime, direction );
	wait randomfloatrange( .3, 1 );
	level thread doPlaneStrike( coord, startPoint+(0,0,randomInt(200)), endPoint+(0,0,randomInt(200)), bombTime, flyTime, direction );
	wait randomfloatrange( 1.5, 2.5 );
	level thread doPlaneStrike( coord, startPoint+(0,0,randomInt(200)), endPoint+(0,0,randomInt(200)), bombTime, flyTime, direction );
	
	thread airstrike_completion_check();
}

airstrike_completion_check()
{
	wait 27;
	level.activeAirstrikes--;
	
	if( !level.activeAirstrikes )
	{
		flag_clear( "airstrike_in_progress" );
		maps\_friendlyfire::TurnBackOn();
	}
}

vector_scale(vec, scale)
{
	vec = (vec[0] * scale, vec[1] * scale, vec[2] * scale);
	return vec;
}

doPlaneStrike( bombsite, startPoint, endPoint, bombTime, flyTime, direction, flybyOnly )
{
	// plane spawning randomness = up to 125 units, biased towards 0
	// radius of bomb damage is 512
	
	startPathRandomness = 100;
	endPathRandomness = 150;
	
	pathStart = startPoint + ( (randomfloat(2) - 1)*startPathRandomness, (randomfloat(2) - 1)*startPathRandomness, 0 );
	pathEnd   = endPoint   + ( (randomfloat(2) - 1)*endPathRandomness  , (randomfloat(2) - 1)*endPathRandomness  , 0 );
	
	// Spawn the planes
	//plane = spawnplane( "script_model", pathStart );
	
	plane = spawn( "script_model", pathStart );
	//plane setModel( "vehicle_mig29_desert" );
	plane setModel( "vehicle_av8b_harrier_jet" );
	plane.angles = direction;
	
	plane thread playContrail();
	
	plane moveTo( pathEnd, flyTime, 0, 0 );
	
	thread callStrike_planeSound( plane, bombsite );
	
	// callStrike_bomb( bomb time, bomb location, number of bombs )
	thread callStrike_bombEffect( plane, bombTime - 1.0, flybyOnly );
	//thread callStrike_bomb( bombTime, bombsite, 2, owner );
	
	// Delete the plane after its flyby
	wait flyTime;
	plane notify( "delete" );
	plane delete();
}

playContrail()
{
	self endon ( "death" );
	
	if ( !isDefined( level.mapCenter ) )
		mapCenter = (0,0,0);
	else
		mapCenter = level.mapCenter;
	
	while ( isdefined( self ) )
	{
		if ( distance( self.origin , mapCenter ) <= 4000 )
		{
			playfxontag( level.fx_airstrike_contrail, self, "tag_right_wingtip" );
			playfxontag( level.fx_airstrike_contrail, self, "tag_left_wingtip" );
			return;
		}
		wait 0.05;
	}
}

callStrike_planeSound( plane, bombsite )
{
	plane thread play_loop_sound_on_entity( "veh_mig29_dist_loop" );
	while( !targetisclose( plane, bombsite ) )
		wait .05;
	plane notify ( "stop sound" + "veh_mig29_dist_loop" );
	plane thread play_loop_sound_on_entity( "veh_mig29_close_loop" );
	while( targetisinfront( plane, bombsite ) )
		wait .05;
	wait .5;
	//plane thread play_sound_in_space( "veh_mig29_sonic_boom" );
	while( targetisclose( plane, bombsite ) )
		wait .05;
	plane notify ( "stop sound" + "veh_mig29_close_loop" );
	plane thread play_loop_sound_on_entity( "veh_mig29_dist_loop" );
	plane waittill( "delete" );
	plane notify ( "stop sound" + "veh_mig29_dist_loop" );
}

targetisinfront(other, target)
{
	forwardvec = anglestoforward(flat_angle(other.angles));
	normalvec = vectorNormalize(flat_origin(target)-other.origin);
	dot = vectordot(forwardvec,normalvec); 
	if(dot > 0)
		return true;
	else
		return false;
}

targetisclose(other, target)
{
	infront = targetisinfront(other, target);
	if(infront)
		dir = 1;
	else
		dir = -1;
	a = flat_origin(other.origin);
	b = a+vector_scale(anglestoforward(flat_angle(other.angles)), (dir*100000));
	point = pointOnSegmentNearestToPoint(a,b, target);
	dist = distance(a,point);
	if (dist < 3000)
		return true;
	else
		return false;
}

callStrike_bombEffect( plane, launchTime, flybyOnly )
{
	wait ( launchTime );
	
	plane thread play_sound_in_space( "veh_mig29_sonic_boom" );
	
	if( !isdefined( flybyOnly ) )
	{
		bomb = spawnbomb( plane.origin, plane.angles );
		bomb moveGravity( vector_scale( anglestoforward( plane.angles ), 7000/1.5 ), 3.0 );
		
		wait ( 1.0 );
		newBomb = spawn( "script_model", bomb.origin );
		newBomb setModel( "tag_origin" );
		newBomb.origin = bomb.origin;
		newBomb.angles = bomb.angles;
		wait (0.05);
		
		bomb delete();
		bomb = newBomb;
		
		bombOrigin = bomb.origin;
		bombAngles = bomb.angles;
		playfxontag( level.airstrikefx, bomb, "tag_origin" );
	//	bomb hide();
		
		//wait ( 0.5 );
		wait 1.6;
		repeat = 12;
		minAngles = 5;
		maxAngles = 55;
		angleDiff = (maxAngles - minAngles) / repeat;
		
		for( i = 0; i < repeat; i++ )
		{
			traceDir = anglesToForward( bombAngles + (maxAngles-(angleDiff * i),randomInt( 10 )-5,0) );
			traceEnd = bombOrigin + vector_scale( traceDir, 10000 );
			trace = bulletTrace( bombOrigin, traceEnd, false, undefined );
			
			traceHit = trace["position"];
			
			radiusDamage( traceHit + (0,0,16), 512, 400, 30, level.airStriker ); // targetpos, radius, maxdamage, mindamage
			
			if ( i%3 == 0 )
			{
				thread playsoundinspace( "clusterbomb_explode_default", traceHit );
				playRumbleOnPosition( "artillery_rumble", traceHit );
				earthquake( 0.7, 0.75, traceHit, 1000 );
			}
			
			wait ( 0.75/repeat );
		}
		wait ( 1.0 );
		bomb delete();
	}
}

playSoundinSpace (alias, origin, master)
{
	org = spawn ("script_origin",(0,0,1));
	if (!isdefined (origin))
		origin = self.origin;
	org.origin = origin;
	if (isdefined(master) && master)
		org playsoundasmaster (alias);
	else
		org playsound (alias);
	wait ( 10.0 );
	org delete();
}

spawnbomb( origin, angles )
{
	bomb = spawn( "script_model", origin );
	bomb.angles = angles;
	bomb setModel( "projectile_cbu97_clusterbomb" );
	
	return bomb;
}

friendly_player_tracking_nav()
{
	self endon ( "death" );
	level endon ( "lz_reached" );
	level endon ( "player_made_it" );
	
	self.goalradius = 1400;
	self.fixednode = false;
	
	playerHeliDetector = getent( "player_in_blackhawk_detector", "targetname" );
	heliDefaultNode = getnode( "bait_crashsite", "targetname" );
	
	while( 1 )
	{
		wait randomfloatrange( 3, 5 );
		
		if( level.player isTouching( playerHeliDetector ) )
		{
			self setgoalnode( heliDefaultNode );
		}
		else
		{
			self setgoalpos( level.player.origin );
		}
	}
}

aiPopCount()
{
	aAllies = getaiarray( "allies" );
	aAxis = getaiarray( "axis" );
	
	totalPop = aAllies.size + aAxis.size;
	
	return( totalPop );
}