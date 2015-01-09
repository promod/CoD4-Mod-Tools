#include common_scripts\utility;
#include maps\_utility;
#include maps\_hud_util;
#include maps\_anim;
#include maps\_vehicle;
#include maps\jake_tools;
#using_animtree( "generic_human" );

main()
{

	if ( getdvar( "r_reflectionProbeGenerate" ) == "1" )
		return;

	//setsaveddvar( "cg_hudCompassMaxRange", 1000 );
	setsaveddvar( "sm_sunSampleSizeNear", 1 ); // air
	setsaveddvar( "sm_sunShadowScale", 0.5 ); // optimization
	setsaveddvar( "r_specularcolorscale", "1.0" );
	setsaveddvar( "compassMaxRange", 2000 );

	if ( getdvar( "bog_camerashake") == "" )
		setdvar( "bog_camerashake", "1" );
	if ( getdvar( "ragdoll_deaths" ) == "" )
		setdvar( "ragdoll_deaths", "1" );
	if ( getdvar( "debug_airlift" ) == "" )
		setdvar( "debug_airlift", "0" );
	
	initPrecache();
	/*-----------------------
	LEVEL VARIABLES
	-------------------------*/	
	level.allCarsDamagedByPlayer = true;
	level.custom_player_attacker = ::player_attacks_from_seaknight;
	level.dontReviveHud = true;
	level.mortarWithinFOV = undefined;
	level.playerMortarFovOffset = ( 0, 40, 0 );
	level.traceHeight = 50;
	level.usingstartpoint = false;
	level.playerHasSeenMI17crash = false;
	level.excludedAi = [];
	level.excludedAi[0] = level.vasquez;	
	level.excludedAi[1] = level.crewchief;
	level.excludedAi[2] = level.smokeleader;
	level.dontTankCrush = false;
	level.crush_car = getent( "crunch_sedan", "targetname" );
	level.grenadeToggle = 0;
	level.turretOverheat = false;
	level.turret_heat_status = 1;
	level.turret_heat_max = 114;
	level.turret_heat_maxshots = 10;
	level.turret_cooldownrate = 35;
	
	level.cobras = [];
	level.t72s = [];
	level.playerInSeaknight = false;
	level.zpuBlastRadius = 384;
	level.section = undefined;
	level.onMark19 = false;
	level.physicsSphereRadius = 300;
	level.physicsSphereForce = 1.0;
	
	level.CannonRange = 5000;
	level.CannonRangeSquared = level.CannonRange * level.CannonRange;
	level.crewchiefRange = 256;
	level.crewchiefRangeSquared = level.crewchiefRange * level.crewchiefRange;
	level.AIdeleteDistance = 1024;
	level.hitsToDestroyT72 = 4;
	level.hitsToDestroyBMP = 2;
	level.cobraTargetExcluders = [];
	level.cosine = [];
	level.cosine[ "15" ] = cos( 15 );
	level.cosine[ "20" ] = cos( 20 );
	level.cosine[ "25" ] = cos( 25 );
	level.cosine[ "30" ] = cos( 30 );
	level.cosine[ "35" ] = cos( 35 );
	level.cosine[ "40" ] = cos( 40 );
	level.cosine[ "45" ] = cos( 45 );
	level.cosine[ "55" ] = cos( 55 );
	level.vehicles_axis = [];
	level.vehicles_allies = [];
	level.AIdeleteDistance = 512;
	level.spawnerCallbackThread = ::AI_think;
	level.droneCallbackThread = ::AI_drone_think;
	level.aColornodeTriggers = [];
	trigs = getentarray( "trigger_multiple", "classname" );
	for ( i = 0;i < trigs.size;i ++ )
	{
		if ( ( isdefined( trigs[ i ].script_noteworthy ) ) && ( getsubstr( trigs[ i ].script_noteworthy, 0, 10 ) == "colornodes" ) )
			level.aColornodeTriggers = array_add( level.aColornodeTriggers, trigs[ i ] );
	}
	/*-----------------------
	STARTS
	-------------------------*/
	add_start( "debug", ::start_debug, &"STARTS_DEBUG" );	
	add_start( "smoketown", ::start_smoketown, &"STARTS_SMOKETOWN" );
	add_start( "cobraflight", ::start_cobraflight, &"STARTS_COBRAFLIGHT" );
	add_start( "cobrastreets", ::start_cobrastreets , &"STARTS_COBRASTREETS");
	add_start( "nuke", ::start_nuke, &"STARTS_STARTSCOBRASTREETS" );
	
	default_start( ::start_default );
	
	/*-----------------------
	GLOBAL SCRIPTS
	-------------------------*/
	array_thread( getentarray( "destructible", "targetname" ), ::destructibles_think );
	//level.mortar_min_dist = 250;
	//level.airliftMortarDist = 3500;
	level.noMaxMortarDist = true;
	maps\_drone::init(); 
	maps\_zpu_antiair::main( "vehicle_zpu4_low" );
	maps\_seaknight::main( "vehicle_ch46e" );
	maps\_mi17::main( "vehicle_mi17_woodland_fly_cheap" );
	maps\_seaknight_airlift::main( "vehicle_ch46e_opened_door_interior" );
	maps\_m1a1::main( "vehicle_m1a1_abrams" );
	maps\_mig29::main( "vehicle_av8b_harrier_jet" );
	maps\_bmp::main( "vehicle_bmp_woodland_low" );
	maps\_t72::main( "vehicle_t72_tank_low" );
	maps\_cobra::main( "vehicle_cobra_helicopter_low" );
	maps\airlift_anim::main();
	level.weaponClipModels = [];
	level.weaponClipModels[0] = "weapon_mp5_clip";
	level.weaponClipModels[1] = "weapon_ak47_clip";
	level.weaponClipModels[2] = "weapon_m16_clip";
	level.weaponClipModels[3] = "weapon_saw_clip";
	level.weaponClipModels[4] = "weapon_dragunov_clip";
	level.weaponClipModels[5] = "weapon_g3_clip";	

	maps\createart\airlift_art::main();
	level thread maps\airlift_fx::main();

	maps\_load::main();
	maps\_compass::setupMiniMap( "compass_map_airlift" );
	level thread maps\airlift_amb::main();	
	thread maps\_mortar::bog_style_mortar();

	//disables tread fx, but not seaknight_player
	maps\_treadfx::setallvehiclefx( "cobra", undefined );
	maps\_treadfx::setallvehiclefx( "seaknight", undefined );
	maps\_treadfx::setallvehiclefx( "bmp", undefined );
	maps\_treadfx::setallvehiclefx( "t72", undefined );
	//maps\_treadfx::setallvehiclefx( "m1a1", undefined );

	/*-----------------------
	FLAGS
	-------------------------*/	
	flag_init( "aa_bridge_to_gas_station_section" );
	flag_init( "aa_gas_station_to_plaza_section" );
	flag_init( "aa_smoketown_to_construction_section" );
	flag_init( "aa_construction_to_lz_section" );
	flag_init( "aa_cobra_rescue_section" );
	flag_init( "aa_cobra_escape_section" );
	
	//intro ride
	flag_init( "difficulty_initialized" );
	flag_init( "seaknight_set_up" );
	flag_init( "cobra_shoots_at_bridge" );
	
	//plaza
	flag_init( "plaza_deploy" );
	flag_init( "start_tank_crush" );
	flag_init( "car_getting_crushed" );
	flag_init( "right_side_seaknight_lift_off" );
	
	//smoketown
	flag_init( "seaknight_landed_smoketown" );
	flag_init( "player_exited_seaknight_smoketown" );
	flag_init( "player_constrction_dialogue_spoken" );
	flag_init( "at4_sequence_over" );
	flag_init( "smoketown_mi17_unloaded" );
	flag_init( "smoketown_mi17_owned" );
	flag_init( "smoketown_cobra_returns" );
	flag_init( "seaknight_back_at_smoketown_lz" );
	flag_init( "smoketown_hardpoint_overrun" );
	flag_init( "player_at_smoketown_lz" );
	
	//cobraflight
	flag_init( "cobra_rpg_launch" );
	flag_init( "cobra_hit" );
	flag_init( "cobra_on_deck" );
	flag_init( "cobra_crash_dialogue_over" );
	
	//cobrastreets
	flag_init( "seaknight_landed_cobrastreets" );
	flag_init( "player_exited_seaknight_cobrastreets" );
	flag_init( "pilot_taken_from_cockpit" );
	flag_init( "player_putting_down_pilot" );
	flag_init( "pilot_put_down_in_seaknight" );
	flag_init( "seaknight_leaving_cobrastreets" );
	flag_init( "cobrastreet_seaknight_loading" );
	
	//nuke
	flag_init( "nuke_section_start" );
	flag_init( "nuke_explodes" );
	flag_init( "nuke_shockwave_hits" );
	flag_init( "shockwave_about_to_hit_player");
	flag_init( "shockwave_hit_player");
	flag_init( "nuke_flattens_trees" );
	
	
	//objectives
	flag_init( "obj_plaza_clear_given" );
	flag_init( "obj_plaza_clear_complete" );
	flag_init( "obj_extract_team_given" );
	flag_init( "obj_extract_team_complete" );
	flag_init( "obj_extract_to_lz_given" );
	flag_init( "obj_extract_to_lz_complete" );
	flag_init( "obj_get_on_mark_19_given" );
	flag_init( "obj_get_on_mark_19_complete" );	
	flag_init( "obj_rescue_pilot_given" );
	flag_init( "obj_rescue_pilot_complete" );
	flag_init( "obj_return_pilot_given" );
	flag_init( "obj_return_pilot_complete" );

	/*-----------------------
	SPAWNER THREADS
	-------------------------*/	
	array_thread( getentarray( "constructionSpawners", "script_noteworthy" ), ::add_spawn_function, ::AI_construction_spawner_think );
	array_thread( getentarray( "fastrope_and_die", "script_noteworthy" ), ::add_spawn_function, ::AI_fastrope_and_die );
	array_thread( getentarray( "hostiles_bmp_bridge", "script_noteworthy" ), ::add_spawn_function, ::AI_hostiles_bmp_bridge );
	array_thread( getentarray( "low_engage_dist", "script_noteworthy" ), ::add_spawn_function, ::AI_low_engage_dist_think );
	array_thread( getentarray( "smoketown_ambient_hostiles", "script_noteworthy" ), ::add_spawn_function, ::smoketown_ambient_hostiles_think );
	array_thread( getentarray( "smoketown_ambient_friendlies", "script_noteworthy" ), ::add_spawn_function, ::smoketown_ambient_friendlies_think );
	array_thread( getentarray( "allies_plaza_assaulters", "script_noteworthy" ), ::add_spawn_function, ::allies_plaza_assaulters_think );
	
	/*-----------------------
	GLOBAL THREADS
	-------------------------*/	
	createthreatbiasgroup( "player" );
	createthreatbiasgroup( "ignored" );
	createthreatbiasgroup( "ambient_axis" );
	createthreatbiasgroup( "ambient_allies" ) ;
	createthreatbiasgroup( "oblivious" );
	level.player setthreatbiasgroup( "player" );
	// make oblivious ingnored and ignore by everything.
	setignoremegroup( "allies", "oblivious" );	// oblivious ignore allies
	setignoremegroup( "axis", "oblivious" );	// oblivious ignore axis
	setignoremegroup( "player", "oblivious" );	// oblivious ignore player
	setignoremegroup( "oblivious", "allies" );	// allies ignore oblivious
	setignoremegroup( "oblivious", "axis" );	// axis ignore oblivious
	setignoremegroup( "oblivious", "oblivious" );	// oblivious ignore oblivious
	setthreatbias( "ambient_allies", "axis", -15000 );
	setthreatbias( "axis", "ambient_allies", -15000 );
	setthreatbias( "ambient_axis", "allies", -15000 );
	setthreatbias( "allies", "ambient_axis", -15000 );
	setthreatbias( "ambient_axis", "ambient_allies", 9999999 );
	setthreatbias( "ambient_allies", "ambient_axis", 9999999 );
	initDifficulty();
	fx_management();
	disable_color_trigs();
	hideAll();
	thread nuke_trees();
	thread player_death();
	thread exploder_statue();
	array_thread( getentarray( "badplace_volume", "targetname" ), ::badplace_volume_think );
	array_thread( getvehiclenodearray( "plane_sound", "script_noteworthy" ), maps\_mig29::plane_sound_node );
	array_thread( getvehiclenodearray( "plane_bomb", "script_noteworthy" ), maps\_mig29::plane_bomb_cluster );
	aFlight_flag_origins = getentarray( "flightFlag", "script_noteworthy" );
	array_thread( aFlight_flag_origins,::flight_flags_think );
	aExploder_trigs_mark19 = getentarray( "exploder_trigs_mark19", "targetname" );
	array_thread( aExploder_trigs_mark19,::exploder_trigs_mark19_think );
	assertex( isdefined( level.vehicle_spawners ), "level.vehicle_spawners is undefined"  );
	array_thread( level.vehicle_spawners,::vehicle_think );
	level thread smoketown_construction_door();
	
	//thread debug();

}

debug()
{
	wait(5);
	eNode = getent( "seaknight_plaza_alt_landing", "targetname" );
	assert( isdefined( eNode ) );
	aFriendliesSeaknightWingman = spawnGroup( getentarray( "allies_seaknight_wingman", "targetname" ), true );
	array_thread( aFriendliesSeaknightWingman, ::friendlies_plaza_seaknights );
	delaythread (0, ::vehicle_animated_seaknight_land, eNode, undefined, aFriendliesSeaknightWingman );		
}
/****************************************************************************
    START FUNCTIONS
****************************************************************************/ 
start_default()
{
	AA_intro_init();
	//start_plazafly();
	//start_plaza();
	//start_smoketown();
	//start_cobraflight();
	//start_cobrastreets();
	//start_nuke();
}

start_debug()
{
	AA_intro_init();
}

start_plazafly()
{
	thread seaknight_player_think( "plazafly" );
	level thread AA_plaza_init();
}

start_plaza()
{
	thread seaknight_player_think( "plaza" );
	flag_set( "seaknightInPlazaFly" );
	level thread AA_plaza_init();
}

start_smoketown()
{
	level.usingstartpoint = true;
	thread seaknight_player_think( "smoketown" );
	flag_set( "seaknightLeavePlaza" );
	level thread AA_smoketown_init();
}

start_cobrastreets()
{
	thread seaknight_player_think( "cobrastreets" );
	level thread AA_cobrastreets_init();
	thread show_cobra_crash();
}

start_cobraflight()
{
	thread seaknight_player_think( "cobraflight" );
	flag_wait( "seaknight_set_up" );
	level.seaknight thread maps\airlift_anim::seaknight_open_doors();
	eNode = getent( "seaknight_land_smoketown2", "script_noteworthy" );
	level.seaknight vehicle_detachfrompath();
	level.seaknight setgoalyaw( eNode.angles[ 1 ] );
	level.seaknight vehicle_land();
	thread seaknight_player_triggers();
	waittill_trigger_seaknight_gun();
	seaknight_player_mount_gun( true );
	level.seaknight thread maps\airlift_anim::seaknight_close_doors();
	level thread AA_cobraflight_init();
}

start_nuke()
{
	level.usingstartpoint = true;
	thread seaknight_player_think( "nuke" );
	flag_wait( "seaknight_set_up" );
	level.seaknight thread maps\airlift_anim::seaknight_open_doors();
	level.crewchief = spawnDude( getent( "seaknight_crewchief_cobrastreets", "targetname" ), true );
	level.crewchief thread anim_loop_solo( level.crewchief, "crewchief_idle", "tag_detach", "stop_idle_crewchief", level.seaknight );	
	level.crewchief gun_remove();
	level.crewchief linkto( level.seaknight );
	thread cobrastreets_crewchief_think();
	flag_set( "pilot_taken_from_cockpit" );
	flag_set( "obj_rescue_pilot_complete" );
	flag_set( "obj_return_pilot_complete" );
	flag_set( "player_cobra_retreat_03" );
	setsaveddvar( "player_deathinvulnerabletime", "10000" );
	level.ePlayerview = spawn_anim_model( "player_carry" );
	level.ePlayerview hide();
	level.player disableweapons();
	eNode = getent( "seaknight_land_cobrastreets", "script_noteworthy" );
	eNode waittill( "trigger", vehicle );
	level.seaknight vehicle_detachfrompath();
	level.seaknight setgoalyaw( eNode.angles[ 1 ] );
	level.seaknight vehicle_land();
	thread seaknight_player_triggers();
	level thread AA_nuke_init();
}

/****************************************************************************
    FLIGHT INTO CITY
****************************************************************************/ 

AA_intro_init()
{
	level.section = "intro_to_plaza";
	thread fx_intro();
	thread dialogue_intro();
	thread music_intro();
	thread obj_plaza_clear();
	thread seaknight_player_think( "default" );
	flag_wait( "seaknight_set_up" );
	thread cobra_wingman_think();
	thread intro_flyover();
	
	flag_wait( "seaknightInPlazaFly" );
	level thread AA_plaza_init();
}

fx_intro()
{
	wait(2);
	/*-----------------------
	DISABLE ALL FX IN OTHER SECTIONS
	-------------------------*/
	array_thread(level.fxSmoketown, ::pauseEffect);
	array_thread(level.fxCobrastreets, ::pauseEffect);	
}

music_intro()
{
	MusicPlayWrapper( "airlift_start_music" );
	flag_wait( "plaza_deploy" );
	musicStop(1);
	wait(1.1);
	MusicPlayWrapper( "airlift_deploy_music" );
}

dialogue_intro()
{
	wait(3);
	//Male Helicopter Pilot
	//In formation. Approaching objective. 30 seconds.
	radio_dialogue_queue( "airlift_mhp_information" );
	
	wait(2);
	
	//Female Helicopter Pilot
	//Outlaw, this is Deadly. We'll take out the big targets, mop up any troublemakers with the Mark 19.
	radio_dialogue_queue( "airlift_fhp_bigtargets" );
	
	flag_set( "obj_plaza_clear_given" );
	
	wait(8.5);
	//HQ Radio Voice
	//All callsigns this is Overlook. We're seeing enemy armor in the palm grove west of the river.
	radio_dialogue_queue( "airlift_hqr_allcallsigns" );
	
	wait(8);
	//Male Helicopter Pilot
	//Taking fire.
	radio_dialogue_queue( "airlift_mhp_takingfire" );

}

intro_flyover()
{

	/*-----------------------
	ABRAMS GO INTO DISTANCE
	-------------------------*/	
	delaythread (10, maps\_vehicle::create_vehicle_from_spawngroup_and_gopath, 1 );

	/*-----------------------
	COBRA WINGMAN
	-------------------------*/	
	delaythread (0, maps\_vehicle::create_vehicle_from_spawngroup_and_gopath, 4 );	

	/*-----------------------
	COBRA WINGMEN
	-------------------------*/	
	delaythread (0, maps\_vehicle::create_vehicle_from_spawngroup_and_gopath, 7 );	
	
	/*-----------------------
	MORTARS ON
	-------------------------*/	
	delaythread (3, maps\_mortar::bog_style_mortar_on, 0 );	

	/*-----------------------
	SEAKNIGHT WINGMAN
	-------------------------*/	
	delaythread (0, maps\_vehicle::create_vehicle_from_spawngroup_and_gopath, 3 );	
	
	/*-----------------------
	ENEMY TANKS ON BRIDGE
	-------------------------*/	
	delaythread (13, maps\_vehicle::create_vehicle_from_spawngroup_and_gopath, 5 );	

	/*-----------------------
	BMPS APPROACHING BRIDGE
	-------------------------*/	
	if ( getdvar( "airlift_min_spec") != "1" )
		delaythread (25, maps\_vehicle::create_vehicle_from_spawngroup_and_gopath, 6 );	
	
	/*-----------------------
	PLANES FLY IN DISTANCE
	-------------------------*/
	delaythread (18, maps\_vehicle::create_vehicle_from_spawngroup_and_gopath, 2 );	
	delaythread (4, maps\_vehicle::create_vehicle_from_spawngroup_and_gopath, 19 );	
	delaythread (4.5, maps\_vehicle::create_vehicle_from_spawngroup_and_gopath, 20 );	
	delaythread (4.3, maps\_vehicle::create_vehicle_from_spawngroup_and_gopath, 21 );	
	delaythread (6, maps\_vehicle::create_vehicle_from_spawngroup_and_gopath, 22 );	
	delaythread (6.2, maps\_vehicle::create_vehicle_from_spawngroup_and_gopath, 23 );

	wait(6);

	/*-----------------------
	DRONES NEAR BRIDGE SIDE
	-------------------------*/	
	wait(8.5);
	if ( getdvar( "airlift_min_spec") != "1" )
		triggerActivate( "trig_spawn_drones_bridge_side" );
	wait(6);
	if ( getdvar( "airlift_min_spec") != "1" )
		triggerActivate( "trig_spawn_drones_bridge" );
	wait(6);

	/*-----------------------
	PALM GROVE COBRAS
	-------------------------*/	
	if ( getdvar( "airlift_min_spec") != "1" )
		delaythread (0, maps\_vehicle::create_vehicle_from_spawngroup_and_gopath, 16 );

	flag_set( "aa_bridge_to_gas_station_section" );

	
	/*-----------------------
	FIRST ZPU
	-------------------------*/		
	triggerActivate( "trig_spawn_zpu_start" );
	
	wait(3);
	/*-----------------------
	COBRA SHOOTS AT BRIDGE
	-------------------------*/	
	flag_set( "cobra_shoots_at_bridge" );
	thread autosave_by_name( "plaza_bridge" );

	/*-----------------------
	MORTARS OFF
	-------------------------*/		
	thread maps\_mortar::bog_style_mortar_off( 0 );
	
	/*-----------------------
	BRIDGE DRONES
	-------------------------*/		
	flag_wait( "seaknightBridgeEnd" );	
	
	/*-----------------------
	DELETE BRIDGE AI WHEN OUT OF SIGHT
	-------------------------*/		
	flag_wait( "seaknightInPlazaFly" );		

	/*-----------------------
	STOP ALL FX IN INTRO
	-------------------------*/	
	array_thread(level.fxIntro, ::pauseEffect);	
		
	thread autosave_by_name( "plaza_start" );
	
	aAI_to_delete = getentarray( "hostiles_bmp_bridge", "script_noteworthy" );
	thread AI_delete_when_out_of_sight( aAI_to_delete, level.AIdeleteDistance );
}

AI_hostiles_bmp_bridge()
{
	self endon( "death" );
	self set_goalvolume( "volume_bridge_01" );
	flag_wait( "seaknightInPlazaFly" );
	self set_goalvolume( "volume_retreat_bridge" );
	flag_wait( "seaknightInPlaza" );
	self delete();

}

seaknight_wingman_think()
{
	level.ch46Wingman = maps\_vehicle::waittill_vehiclespawn( "seaknight_wingman" );

}

cobra_wingman_think()
{
	level.cobraWingman = maps\_vehicle::waittill_vehiclespawn( "wingman" );
	
	wait(2);
	level.cobraWingman notify( "stop_default_behavior" );
	//level.cobraWingman ClearGoalYaw();
	flag_wait( "cobra_shoots_at_bridge" );
	
	/*-----------------------
	COBRA FIRES AT BRIDGE ARMOR
	-------------------------*/		
	wait (1);
	eTarget = getent( "cobra_bridge_tank1", "targetname" );
	assert(isdefined(eTarget));
	level.cobraWingman maps\_helicopter_globals::fire_missile( "ffar_airlift", 2, eTarget);
	wait(1.5);

	eTarget = getent( "cobra_bridge_tank2", "targetname" );
	assert(isdefined(eTarget));
	level.cobraWingman maps\_helicopter_globals::fire_missile( "ffar_airlift", 2, eTarget);
	wait ( 2 );
	level.cobraWingman thread vehicle_cobra_default_weapons_think();

}

cobra_wingman2_think()
{
	level.cobraWingman2 = maps\_vehicle::waittill_vehiclespawn( "wingman2" );
	
	flag_wait( "cobra_shoots_at_bridge" );
	/*-----------------------
	COBRA FIRES AT BRIDGE ARMOR
	-------------------------*/		
	//level.cobraWingman2 thread maps\_vehicle::mgon();


}

/****************************************************************************
    PLAZA SECTION
****************************************************************************/ 
AA_plaza_init()
{
	flag_wait( "seaknight_set_up" );
	thread dialogue_plaza();
	thread plaza_flyover();
	thread cobra_plaza_chase();
	thread tank_crush_plaza();
	thread tank_crush_destructible();

}

allies_plaza_assaulters_think()
{
	self endon( "death" );
	self setcontents(0); //so they don't get run over by tanks
}

dialogue_plaza()
{

	wait(1);
	
	//Male Helicopter Pilot
	//RPGs on the rooftops.
	radio_dialogue_queue( "airlift_mhp_rpgrooftops" );
	
	wait(7.5);
	//Male Helicopter Pilot
	//Light armor. Take it out, Jackson
	radio_dialogue_queue( "airlift_mhp_lightarmor" );
	
	//Male Helicopter Pilot
	//More ground infantry, watch it
	radio_dialogue_queue( "airlift_mhp_groundinfantry" );
	
	wait(5.5);
	//Male Helicopter Pilot
	//We've got RPG's on the rooftops.
	radio_dialogue_queue( "airlift_mhp_wevegotrpgs" );
	wait(4.5);

	//Male Helicopter Pilot
	//Anti-air battery, rooftop.
	radio_dialogue_queue( "airlift_mhp_antiairrooftop" );

	flag_wait( "seaknightInPlazaStreetEnd" );
	wait(4);
	//Male Helicopter Pilot
	//Hostiles with RPGs.
	radio_dialogue_queue( "airlift_mhp_hostilesrpgs" );
		
	//Male Helicopter Pilot
	//Anti-air on the ground
	//radio_dialogue_queue( "airlift_mhp_antiairground" );
	
	flag_wait( "seaknightInPlaza" );
	
	wait(4);
	//Male Helicopter Pilot
	//Command this is Outlaw Two-Five. Infantry is making a run for it. We are clear to land.
	radio_dialogue_queue( "airlift_mhp_makingarun" );

	wait(1.5);
	//HQ Radio Voice
	//Uh...Roger that. Ok. Bachelor Two-Seven, let's get those Abrams to the front.
	radio_dialogue_queue( "airlift_hqr_getabramsfront" );
	
	flag_set ( "obj_plaza_clear_complete" );

	setsaveddvar( "sm_sunSampleSizeNear", 0.25 ); // ground
	setsaveddvar( "sm_sunShadowScale", 1 ); // default

	//HQ Radio Voice
	//Outlaw, this is command, unload half your chalk here and take the rest 2 clicks west. We need you to evac an advance team pinned down in the city.
	radio_dialogue_queue( "airlift_hqr_2clickswest" );
	
	flag_wait( "plaza_deploy" );
	
	//Helicopter Crew Chief
	//Down the ramp! Move out! Go! Go! Go!	
	level.seaknight play_sound_on_tag( level.scr_sound[ "airlift_hcc_downramp" ], "tag_door_rear" );

	//HQ Radio Voice
	//Roger that command. Outlaw 2-5 is en route
	radio_dialogue_queue( "airlift_hqr_enroute" );
	
	wait(7.5);
	//Lt. Vasquez
	//Marines, listen up! One of our forward recon teams has gotten pinned down and needs our help!
	radio_dialogue_queue( "airlift_vsq_forwardrecon" );		

	setsaveddvar( "sm_sunSampleSizeNear", 1 ); // air
	setsaveddvar( "sm_sunShadowScale", 0.5 ); // optimization

	flag_wait( "seaknightLeavePlaza" );
	wait(2);
	//Female Helicopter Pilot
	//Outlaw this is Deadly. Returning to base to refit and refuel. You’re on your own for now 2-5.
	radio_dialogue_queue( "airlift_fhp_refitandrefuel" );	
}

car_crush_arcademode()
{
	org = self.origin;
	level waittill( "exploder_1000_detonated" );
	arcadeMode_kill( org, "explosive", 200 );
}

tank_crush_destructible()
{
	level endon( "start_tank_crush" );
	crunch_sedan = getent( "crunch_sedan", "targetname" );
	crunch_sedan thread car_crush_arcademode();
	level waittill( "exploder_1000_detonated" );
	if ( !flag( "start_tank_crush" ) )
	{
		level.dontTankCrush = true;
		new_car = spawn( "script_model", crunch_sedan.origin );
		new_car.angles = crunch_sedan.angles;
		new_car setmodel( "vehicle_80s_sedan1_tankcrush_destroyed" );
		level.crush_car = new_car;
		crunch_sedan delete();
		level.dontTankCrush = false;
	}
}

plaza_flyover()
{
	flag_wait( "seaknightInPlazaFly" );
	/*-----------------------
	ROOFTOP DUDES
	-------------------------*/	
	wait(1);
	triggerActivate( "trig_spawn_plaza_roof_01" );

	/*-----------------------
	PLANES FLY IN DISTANCE
	-------------------------*/	
	if ( getdvar( "airlift_min_spec") != "1" )
	{
		delaythread (3.6, maps\_vehicle::create_vehicle_from_spawngroup_and_gopath, 25 );	
		delaythread (3.2, maps\_vehicle::create_vehicle_from_spawngroup_and_gopath, 26 );	
		delaythread (3.6, maps\_vehicle::create_vehicle_from_spawngroup_and_gopath, 27 );	
		delaythread (4, maps\_vehicle::create_vehicle_from_spawngroup_and_gopath, 28 );	
		delaythread (4.2, maps\_vehicle::create_vehicle_from_spawngroup_and_gopath, 29 );			
	}

		
	
	/*-----------------------
	STREET ARMOR AND ZPU IN PLAZA
	-------------------------*/	
	delaythread (0, maps\_vehicle::create_vehicle_from_spawngroup_and_gopath, 14 );
	triggerActivate( "trig_spawn_zpu_plaza" );
	wait(2);
	/*-----------------------
	PALACE DUDES
	-------------------------*/	
	triggerActivate( "trig_spawn_plaza_main" );
	//if ( getdvar( "airlift_min_spec") != "1" )
		triggerActivate( "trig_spawn_drones_palace_01" );
	
	/*-----------------------
	STREET ARMOR IN STREET
	-------------------------*/	
	delaythread (14, maps\_vehicle::create_vehicle_from_spawngroup_and_gopath, 15 );	

	/*-----------------------
	ENEMY TRUCK GUYS
	-------------------------*/	
	flag_wait( "seaknightInPlazaConstruction" );
	triggerActivate( "trig_spawn_zpu_plaza_alley" );
	delaythread (2, maps\_vehicle::create_vehicle_from_spawngroup_and_gopath, 17 );	

	/*-----------------------
	DELETE ALL REMAINING ROOF 01 DUDES
	-------------------------*/
	aAI_to_delete = getentarray( "hostiles_plaza_fodder_roof", "script_noteworthy" );
	thread AI_delete_when_out_of_sight( aAI_to_delete, level.AIdeleteDistance );
	
	
	
	/*-----------------------
	STREET DUDES AND OTHER BMPS NEAR GAS
	-------------------------*/	
	flag_wait( "seaknightInPlazaStreetEnd" );
	flag_clear( "aa_bridge_to_gas_station_section" );
	flag_set( "aa_gas_station_to_plaza_section" );

	
	thread autosave_by_name( "plaza_street_end" );
	
	//delete remaining AI near statue
	aAI_to_delete = getentarray( "hostiles_plaza_fodder_palace", "script_noteworthy" );
	thread AI_delete_when_out_of_sight( aAI_to_delete, 512 );
	
	delaythread (2.5, maps\_vehicle::create_vehicle_from_spawngroup_and_gopath, 18 );	
	wait(4);
	triggerActivate( "trig_spawn_plaza_alley_01" );
	aAI_to_delete = getentarray( "hostiles_bmp_alley", "script_noteworthy" );
	thread AI_delete_when_out_of_sight( aAI_to_delete, level.AIdeleteDistance );
	
	wait(11);
	/*-----------------------
	CONSTRUCTION SITE
	-------------------------*/
	triggerActivate( "trig_spawn_drones_plaza_street_retreat" );

	
	/*-----------------------
	PLAYER SEAKNIGHT LANDS IN PLAZA
	-------------------------*/
	level.seaknight thread vehicle_heli_land( getent( "seaknight_land_plaza", "script_noteworthy" ) );

	/*-----------------------
	DELETE ALL REMAINING ENEMIES
	-------------------------*/
	flag_wait( "seaknightInPlaza" );
	aAI_to_delete = getentarray( "hostiles_plaza_fodder", "script_noteworthy" );
	thread AI_delete_when_out_of_sight( aAI_to_delete, 1024 );

	/*-----------------------
	TOKEN BMP FOR COBRA TO BLOW UP
	-------------------------*/	
	maps\_vehicle::scripted_spawn( 49 );
	wait(0.05);
	/*-----------------------
	COBRA KILLS ANY REMAINING VISIBLE TARGETS
	-------------------------*/	
	aRemainingTargets = getentarray( "targets_plaza_end", "script_noteworthy" );
	if ( aRemainingTargets.size > 0 )
		delaythread (12, ::vehicle_cobra_spawn_and_kill, "cobra_plaza_end", aRemainingTargets, 1 );	

	/*-----------------------
	WINGMAN SEAKNIGHT LANDS IN PLAZA
	-------------------------*/	
	eNode = getent( "seaknight_plaza_alt_landing", "targetname" );
	assert( isdefined( eNode ) );
	aFriendliesSeaknightWingman = spawnGroup( getentarray( "allies_seaknight_wingman", "targetname" ), true );
	array_thread( aFriendliesSeaknightWingman, ::friendlies_plaza_seaknights );
	delaythread (0, ::vehicle_animated_seaknight_land, eNode, undefined, aFriendliesSeaknightWingman );	
	
	/*-----------------------
	OTHER SEAKNIGHT LANDS IN PLAZA
	-------------------------*/	
	eNode = getent( "seaknight_plaza_alt_landing2", "targetname" );
	assert( isdefined( eNode ) );
	aFriendliesSeaknightOther = spawnGroup( getentarray( "allies_seaknight_plaza_ch46_2", "targetname" ), true );
	array_thread( aFriendliesSeaknightOther, ::friendlies_plaza_seaknights );
	delaythread (1, ::vehicle_animated_seaknight_land, eNode, "right_side_seaknight_lift_off", aFriendliesSeaknightOther );	
	
	level.seaknight waittill( "landed" );
	flag_clear( "aa_gas_station_to_plaza_section" );
	
	thread autosave_by_name( "plaza_assault" );
	
	flag_set( "plaza_deploy" );
	thread seaknight_door_open_sound();
	
	if ( level.dontTankCrush == true )
	{
		while( level.dontTankCrush == true )
			wait ( 0.05 );
	}
	flag_set( "start_tank_crush" );
	/*-----------------------
	MARINES TAKE UP POSITIONS 
	-------------------------*/
	wait(10);
	trig_colornode = getent( "colornodes_plaza", "script_noteworthy" );
	trig_colornode notify( "trigger", level.player );
	
	triggerActivate( "trig_spawn_hostiles_palace_assault" );
	/*-----------------------
	SEAKNIGHT LIFTOFF
	-------------------------*/	
	wait(2);
	flag_set( "right_side_seaknight_lift_off" );
	level.seaknight cleargoalyaw();
	level.seaknight vehicle_liftoff();
	level.seaknight vehicle_resumepath();
	
	level thread AA_smoketown_init();
}



cobra_plaza_chase()
{
	/*-----------------------
	COBRA CHASES DOWN ALLEY
	-------------------------*/		
	flag_wait( "seaknightInPlaza" );
	delaythread (0, maps\_vehicle::create_vehicle_from_spawngroup_and_gopath, 30 );	

	/*-----------------------
	DELETE REMAINING ENEMY AI
	-------------------------*/			
	flag_wait( "seaknightPlazaLanding" );
	aAI_to_delete = getaiarray("axis");
	thread AI_delete_when_out_of_sight( aAI_to_delete, 256 );
}



vehicle_cobra_spawn_and_kill( sCobraTargetname, aTargets, fKillDelay )
{
	eCobra = spawn_vehicle_from_targetname( sCobraTargetname );
	thread maps\_vehicle::gopath( eCobra );
	assert( isdefined( eCobra ) );
	
	if ( isdefined( fKillDelay ) )
		wait( fKillDelay );
	
	if ( aTargets.size > 0 )
	{
		eCobra notify( "stop_default_behavior" );
		eCobra thread vehicle_mg_on();
		
		if ( aTargets.size > 1 )
			aTargets = get_array_of_closest( eCobra.origin , aTargets , undefined , aTargets.size );
		for(i=0;i<aTargets.size;i++)
		{
			if ( ( !isdefined( aTargets[i] ) ) || ( !isalive( aTargets[i] ) ) )
				continue;
			
			eCobra maps\_helicopter_globals::fire_missile( "ffar_airlift", 1, aTargets[i]);
			wait(.3);
		}
	}
	else
		println( sCobraTargetname + " doesn't have any targets to shoot." );
}





vehicle_intro_to_plaza_think()
{
	flag_wait( "seaknightInPlaza" );
}



friendlies_plaza_seaknights()
{
	self endon( "death" );
	self waittill ( "unloaded" );
	wait ( randomfloatrange( 2, 3) );
	self notify( "stop_ch46_idle" );
}

tank_crush_plaza()
{
	flag_wait( "start_tank_crush" );
	/*-----------------------
	SPAWN TANK CRUSHER
	-------------------------*/	
	level.tankCrusher = spawn_vehicle_from_targetname( "tank_crusher" );
	thread maps\_vehicle::gopath( level.tankCrusher );
	level.tankCrusher thread maps\_vehicle::mgon();
	/*-----------------------
	COLUMN OF ABRAMS GO PAST
	-------------------------*/	
	delaythread (3, maps\_vehicle::create_vehicle_from_spawngroup_and_gopath, 11 );
	delaythread (8.1, maps\_vehicle::create_vehicle_from_spawngroup_and_gopath, 12 );
	delaythread (10.9, maps\_vehicle::create_vehicle_from_spawngroup_and_gopath, 13 );
	delaythread (18, maps\_vehicle::create_vehicle_from_spawngroup_and_gopath, 45 );
	if ( getdvar( "airlift_min_spec") != "1" )
	{
		delaythread (20, maps\_vehicle::create_vehicle_from_spawngroup_and_gopath, 46 );
		delaythread (23, maps\_vehicle::create_vehicle_from_spawngroup_and_gopath, 47 );
		delaythread (25.8, maps\_vehicle::create_vehicle_from_spawngroup_and_gopath, 48 );		
	}


	/*-----------------------
	ALLIES ASSAULT MAIN BUILDING
	-------------------------*/		
	delaythread (0, ::plaza_building_assault );

	/*-----------------------
	TANK CRUSHES CAR
	-------------------------*/		
	node = getVehicleNode( "sedan_crush_node", "script_noteworthy" );
	assert( isdefined( node ) );
	node waittill( "trigger" );
	flag_set( "car_getting_crushed" );
	level.tankCrusher thread maps\_vehicle::mgoff();
	level.tankCrusher setSpeed( 0, 999999999, 999999999 );
	tank_path_2 = getVehicleNode( "tank_path_2", "targetname" );
	
	level.tankCrusher maps\_vehicle::tank_crush( level.crush_car,
											tank_path_2,
											level.scr_anim[ "tank" ][ "tank_crush" ],
											level.scr_anim[ "sedan" ][ "tank_crush" ],
											level.scr_animtree[ "tank_crush" ],
											level.scr_sound[ "tank_crush" ] );
	level.tankCrusher resumeSpeed( 999999999 );
	
	level.tankCrusher waittill ( "reached_end_node" );
	level.tankCrusher delete();
}

plaza_building_assault()
{
	/*-----------------------
	YOUR CHALK DISEMBARKS AND TAKES UP POSITIONS
	-------------------------*/
	triggerActivate( "trig_spawn_allies_plaza_chalk" );
	thread plaza_AT4_sequence();
	
	/*-----------------------
	ALLIED DRONES FOLLOW TANK COLUMN
	-------------------------*/
	wait(10);
	if ( getdvar( "airlift_min_spec") != "1" )
		triggerActivate( "trig_spawn_drones_plaza_allies" );
}

plaza_AT4_sequence()
{
	eTarget = getent( "org_rpg_plaza_01", "targetname" );
	eAt4_dude = spawnDude( getent( "plaza_at4_dude", "script_noteworthy" ), true );
	node = getnode( "node_at4_guy", "targetname" );
	assert( isdefined( node ));
	eAt4_dude set_threatbiasgroup( "ignored" );
	eAt4_dude.ignoreme = true;
	eAt4_dude.grenadeawareness = 0;
	eAt4_dude setcontents(0);
	setignoremegroup( "ignored", "axis" );
	setignoremegroup( "axis", "ignored" );
	
	node anim_reach_solo (eAt4_dude, "AT4_fire_start");
	eAt4_dude attach("weapon_AT4", "TAG_INHAND");
	node thread anim_single_solo( eAt4_dude, "AT4_fire" );
	eAt4_dude waittillmatch ( "single anim", "fire" );
	org = eAt4_dude gettagorigin( "TAG_INHAND" );
	magicbullet( "rpg_player", org, eTarget.origin );	
	thread plaza_at4_impact();
	eAt4_dude waittillmatch ( "single anim", "end" );
	org_hand = eAt4_dude gettagorigin("TAG_INHAND");
	angles_hand = eAt4_dude gettagangles("TAG_INHAND");
	eAt4_dude detach("weapon_AT4", "TAG_INHAND");
	model_at4 = spawn("script_model", org_hand);
	model_at4 setmodel( "weapon_at4" );
	model_at4.angles = angles_hand;		
	node thread anim_loop_solo ( eAt4_dude, "AT4_idle", undefined, "stop_idle" );
	
	wait (1);
	node notify ( "stop_idle" );
	eNode = getnode( "node_at4_guy_next", "targetname" );
	assert( isdefined( eNode ) );
	eAt4_dude setgoalnode( eNode );
	
	if ( isdefined( eAt4_dude.magic_bullet_shield ) )
		eAt4_dude stop_magic_bullet_shield();
	
	flag_wait( "seaknightLeavePlaza" );
	
	if ( isdefined( eAt4_dude ) )
	{
		eAt4_dude delete();
		model_at4 delete();
	}
}

plaza_at4_impact()
{
	wait(2);
	org_rpg_plaza_01 = getent( "org_rpg_plaza_01", "targetname" );
	thread play_sound_in_space( "building_explosion3", org_rpg_plaza_01.origin );
	exploder( 1 );	
}

/****************************************************************************
    SMOKETOWN
****************************************************************************/ 
AA_smoketown_init()
{
	flag_wait( "seaknight_set_up" );
	thread dialogue_smoketown();
	thread music_smoketown();
	thread obj_extract_team();
	thread obj_extract_to_lz();
	thread obj_get_on_mark_19();
	thread smoketown_flyover();
	thread smoketown_land();
	thread smoketown_mortars();	
	thread smoketown_enemy_heli();
	thread junkyard_assault();
	thread smoketown_upstairs();
	thread smoketown_lz_advance();
	thread lz_spawners();
	thread seaknight_smoketown_think();
	thread green_smoke();
	thread smoketown_lz_door();
	thread smoketown_cobra_think();
}

dialogue_smoketown()
{
	flag_wait( "seaknightLeavePlaza" );
	
	if ( !level.usingstartpoint )
	{
		wait(12.5);
		//HQ Radio Voice
		//Advance team is pinned down in a hot area. They're popping blue smoke to indicate position.
		radio_dialogue_queue( "airlift_hqr_bluesmoke" );
		
		wait(1.7);
		//Male Helicopter Pilot
		//Roger we have a visual. Outlaw 2-5 out.
		radio_dialogue_queue( "airlift_mhp_havevisual" );		
	}

	flag_wait( "seaknight_landed_smoketown" );
	
	battlechatter_off( "allies" );

	setsaveddvar( "sm_sunSampleSizeNear", 0.25 ); // ground
	setsaveddvar( "sm_sunShadowScale", 1 ); // default
	
	wait(1.5);
	//Lt. Vasquez
	//Watch for friendlies near the colored smoke! Let's get our boys evac'ed and get the hell out of here!	HR1	
	radio_dialogue_queue( "airlift_vsq_watchcoloredsmoke" );		
	
	wait(3);
	//Marine 1
	//Mortar fire! Incoming!
	guy = get_closest_ally();
	guy dialogue_execute( "airlift_gm1_firebalcony" );

	flag_wait( "player_exited_seaknight_smoketown" );
	//Male Helicopter Pilot
	//LZ is too hot. We'll circle back in 3 minutes. 
	radio_dialogue_queue( "airlift_mhp_lztoohot" );
	
	battlechatter_on( "allies" );

	flag_wait( "player_constrction_approach" );
	
	battlechatter_off( "allies" );
	//Lt. Vasquez
	//Watch for friendlies near the green smoke on the second floor! Let's get our boys outta there! Move!	HR1	
	radio_dialogue_queue( "airlift_vsq_greensmoke" );		
	
	flag_set( "player_constrction_dialogue_spoken" );
	battlechatter_on( "allies" );
	
	flag_wait( "player_middle_construction" );
	
	battlechatter_off( "allies" );
	//Marine 1
	//Hold your fire! Hold your fire! Friendlies up on the second floor! I repeat, we're up on the second floor!	HR1	
	thread radio_dialogue_queue( "airlift_gm1_holdyourfire" );		
	
	flag_wait( "player_in_upper_construction_stairs" );
	
	//Marine 2
	//Put some fire on that balcony!
	level.smokeleader dialogue_execute( "airlift_gm2_firebalcony" );
	
	flag_wait( "obj_extract_team_complete" );
	
	//Marine 3
	//Reinforcements! Fastroping to the east!
	//guy = get_closest_ally();
	//guy dialogue_execute( "airlift_gm3_reinforcements" );

	//Marine 4
	//So you're our ride out of here?
	level.smokeleader dialogue_execute( "airlift_gm4_reinforcements" );
	
	//Lt. Vasquez
	//We're it, Captain. Let's move out before they regroup.
	level.vasquez thread dialogue_execute( "airlift_vsq_wereit" );	
	flag_set( "smoketown_mi17_owned" );

	wait(2);
	
	flag_set( "obj_extract_to_lz_given" );
	
	flag_wait( "smoketown_cobra_returns" );
	
	wait(1.5);
	//Female Helicopter Pilot
	//Outlaw this is Deadly. Refueled and fully loaded. You guys miss me?
	radio_dialogue_queue( "airlift_fhp_missme" );
	
	battlechatter_on( "allies" );
	
	if ( level.playerHasSeenMI17crash )
	{
		//Marine 3
		//Hell yeah!
		guy = get_closest_ally();
		guy dialogue_execute( "airlift_gm3_hellyeah" );		
	}

	wait(3);
	//Lt. Vasquez
	//Move out! Let's go let's go!
	level.vasquez dialogue_execute( "airlift_vsq_letsgo" );	
	
	flag_wait( "smoketown_hardpoint_overrun" );
	wait(1);
	
	//Lt. Vasquez
	//Get to the LZ! Let's move!
	radio_dialogue_queue( "airlift_vsq_gettolz2" );
	
	trigWait( "smoketown_lz_return" );
	
	level.crewchief notify( "player_returning_to_seaknight" );
	
	//Helicopter Crew Chief
	//Move it! We've gotta be wheels up in 10 seconds! Move!
	//level.crewchief dialogue_execute( "airlift_hcc_wheelsup" );
	
	//Lt. Vasquez
	//Go! Go!
	radio_dialogue_queue( "airlift_vsq_gogo" );
	
	flag_wait( "player_at_smoketown_lz" );
	
	//Helicopter Crew Chief
	//Jackson! Get back on the Mark 19!
	level.crewchief dialogue_execute( "airlift_hcc_backonmark19" );
}

music_smoketown()
{
	flag_wait( "smoketown_hardpoint_overrun" );
	wait(5);
	MusicPlayWrapper( "airlift_deploy_music" );
	
}

smoketown_ambient_friendlies_think()
{
	//called from spawner callback
	self endon( "death" );
	self set_threatbiasgroup( "ambient_allies" );
	self thread smoketown_ambient_think();
}

smoketown_ambient_hostiles_think()
{
	//called from spawner callback
	self endon( "death" );
	self set_threatbiasgroup( "ambient_axis" );
	self thread smoketown_ambient_think();
}

smoketown_ambient_think()
{
	/*-----------------------
	AMBIENT GUYS FIGHT EACHOTHER UNTIL PLAYER ARRIVES
	-------------------------*/	
	self endon( "death" );
	self invulnerable( true );
	
	flag_wait( "player_stairs_construction" );
	if ( isdefined( self.magic_bullet_shield ) )
		self stop_magic_bullet_shield();
	self delete();
}

smoketown_lz_door()
{
	door_smoketown_lz = getent( "door_smoketown_lz", "targetname" );
	assert( isdefined( door_smoketown_lz ) );
	flag_wait( "player_smoketown_junkyard" );
	door_smoketown_lz hide();
	door_smoketown_lz notsolid();
	door_smoketown_lz connectpaths();	
}

smoketown_construction_door()
{
	door_construction = getent( "door_construction", "targetname" );
	assert( isdefined( door_construction ) );

	door_construction hide();
	door_construction notsolid();
	door_construction connectpaths();		
	
	flag_wait( "player_in_upper_construction_stairs" );
	
	door_construction show();
	door_construction solid();
	door_construction disconnectpaths();	
}

green_smoke()
{
	flag_wait( "seaknightLeavePlaza" );
	wait(3);
	exploder( 173 );
	//flag_wait( "cobraCrashStart" );
	flag_wait( "cobra_hit" );
	stop_exploder( 173 );
}

smoketown_flyover()
{
	flag_wait( "seaknightLeavePlaza" );

	/*-----------------------
	START ALL FX IN SMOKETOWN
	-------------------------*/	
	array_thread(level.fxSmoketown, ::restartEffect);
		
	if ( level.usingstartpoint )
		return;
	
	/*-----------------------
	PLANES FLY IN DISTANCE
	-------------------------*/	
	delaythread (10, maps\_vehicle::create_vehicle_from_spawngroup_and_gopath, 24 );	
	
	flag_wait( "seaknightSmokeTownApproach" );
	/*-----------------------
	DELETE ALL AI LEFT BEHIND
	-------------------------*/
	aAI_to_delete = getaiarray();
	thread AI_delete_when_out_of_sight( aAI_to_delete, level.AIdeleteDistance );

	/*-----------------------
	SMOKETOWN ENEMIES ON ROOFTOPS
	-------------------------*/
	triggerActivate( "trig_spawn_smoketown_roof_01" );
	wait(3);
	triggerActivate( "trig_spawn_smoketown_street_01" );
	triggerActivate( "trig_spawn_smoketown_street_02" );

	/*-----------------------
	STOP ALL FX IN PLAZATOWN
	-------------------------*/	
	array_thread(level.fxPlazatown, ::pauseEffect);	

}

smoketown_land()
{

	flag_wait( "seaknightLandingInSmoketown" );
	
	level.scr_sound[ "mortar" ][ "incomming" ] = "mortar_incoming";
	
	/*-----------------------
	SEAKNIGHT LANDS IN SMOKETOWN
	-------------------------*/
	level.seaknight thread vehicle_heli_land( getent( "seaknight_land_smoketown", "script_noteworthy" ) );
	
	/*-----------------------
	FRIENDLIES SPAWNED TO UNLOAD
	-------------------------*/
	aPilot_drones = getentarray( "pilots_smoketown", "targetname" );
	spawn_pilots( aPilot_drones );
	aFriendliesSeaknight = spawnGroup( getentarray( "seaknight_unloaders_smoketown", "targetname" ), true );
	level.vasquez = getDudeFromArray( aFriendliesSeaknight, "vasquez" );
	assert(isdefined( level.vasquez ) );	
	level.crewchief = spawnDude( getent( "seaknight_crewchief_smoketown", "targetname" ), true );
	level.seaknight thread vehicle_seaknight_unload( aFriendliesSeaknight, level.crewchief );
	level.seaknight waittill( "landed" );
	setExpFog(0, 7339.38, 0.564865, 0.460619, 0.322549, 3);
	flag_set( "seaknight_landed_smoketown" );
	flag_set( "aa_smoketown_to_construction_section" );

	
	thread autosave_by_name( "smoketown_start" );
	
	flag_set( "obj_extract_team_given" );


	/*-----------------------
	UNLINK PLAYER AND UNLOAD HIDDEN AI
	-------------------------*/	
	wait(1);
	level.seaknight notify ( "unload_ai" );
	
	thread seaknight_player_dismount_gun();
	thread maps\_utility::set_ambient("amb_ext_ground_intensity3");
	
	aAI_to_delete = getaiarray("axis");
	thread AI_delete_when_out_of_sight( aAI_to_delete, 256 );
	
	level.seaknight waittill ( "all_ai_unloaded" );
	while ( level.playerInSeaknight == true )
		wait ( 0.05 );
	
	flag_set( "player_exited_seaknight_smoketown" );
	for(i=0;i<aFriendliesSeaknight.size;i++)
	{
		aFriendliesSeaknight[i] allowedstances("crouch", "stand", "prone" );
	}
	
	
	//	array_thread( aFriendliesSeaknight, ::ai_notify, "stop_ch46_idle", 10);
	
	/*-----------------------
	COLORNODES AND SPAWN TRIGGERS
	-------------------------*/	
	triggersEnable("colornodes_smoketown_start", "script_noteworthy", true);

	flag_wait( "player_constrction_approach" );
	
	/*-----------------------
	PLANES FLY IN DISTANCE
	-------------------------*/	
	flag_wait( "player_constrction_dialogue_spoken" );
	if ( getdvar( "airlift_min_spec") != "1" )
		delaythread (0, maps\_vehicle::create_vehicle_from_spawngroup_and_gopath, 41 );	

	/*-----------------------
	MAKE VASQUEZ GO UPSTAIRS
	-------------------------*/	
	flag_wait( "player_middle_construction" );
	level.vasquez disable_ai_color();
	eNode = getnode( "vasquez_construction", "targetname" );
	assert(isdefined(eNode));
	level.vasquez setgoalnode( eNode );
	
	/*-----------------------
	SPAWN SMOKE FRIENDLIES UPSTAIRS
	-------------------------*/	
	flag_wait( "player_stairs_construction" );
	aAI_to_delete = getaiarray( "axis" );
	thread AI_delete_when_out_of_sight( aAI_to_delete, 256 );
	level.smokeFriendlies = spawnGroup( getentarray( "smoke_friendlies", "targetname" ), true );
	assertex( level.smokeFriendlies.size == 5, "Need exactly 5 smoke friendlies to spawn..." + level.smokeFriendlies.size );
	level.smokeleader = getDudeFromArray( level.smokeFriendlies, "smokeleader" );
	assert(isdefined( level.smokeleader ) );	
	level.smokeAT4dude = getDudeFromArray( level.smokeFriendlies, "smoketown_at4_dude" );
	assert(isdefined( level.smokeAT4dude ) );
	stair_friendly = getDudeFromArray( level.smokeFriendlies, "stair_friendly" ); 
	assert(isdefined( stair_friendly ) );
	stair_friendly thread stair_friendly_think();
	/*-----------------------
	SPAWN RPD ENEMY ACROSS ROOFTOPS
	-------------------------*/	
	spawner = getent( "smoketown_at4_hostile", "script_noteworthy" );
	smoketown_at4_hostile = spawnDude( spawner, "stalingrad" );
	smoketown_at4_hostile invulnerable ( true );

	/*-----------------------
	AT4 SEQUENCE
	-------------------------*/		
	eTarget = getent( "smoketown_rpg_target", "targetname" );
	attractor = missile_createAttractorEnt( eTarget, 100000, 60000 );
	
	level.smokeAT4dude set_threatbiasgroup( "ignored" );
	setignoremegroup( "ignored", "axis" );
	setignoremegroup( "axis", "ignored" );
	eNode = getnode( "node_construction_rpg", "targetname" );
	assert(isdefined(eNode));
	level.smokeAT4dude.ignoreme = true;
	level.smokeAT4dude.grenadeawareness = 0;
	eNode anim_reach_solo (level.smokeAT4dude, "AT4_fire_short_start");
	//eNode thread anim_loop_solo (level.smokeAT4dude, "RPG_conceal_idle", undefined, "stop_idle");
	level.smokeAT4dude attach("weapon_AT4", "TAG_INHAND");
	eNode thread anim_first_frame_solo( level.smokeAT4dude, "AT4_fire_short" );
	
	flag_wait( "player_in_upper_construction_stairs" );
	thread autosave_by_name( "smoketown_construction" );
	
	//eNode notify ( "stop_idle" );
	eNode thread anim_single_solo( level.smokeAT4dude, "AT4_fire_short" );
	level.smokeAT4dude thread AT4_detach();
	//level.smokeAT4dude thread anim_loop_solo (level.smokeAT4dude, "RPG_stand_idle", undefined, "stop_idle");
	//wait(.5);	
	level.smokeAT4dude waittillmatch ( "single anim", "fire" );
	org = level.smokeAT4dude gettagorigin( "TAG_INHAND" );
	//org = level.smokeAT4dude gettagorigin( "TAG_WEAPON_RIGHT" );
	magicbullet( "at4", org, eTarget.origin );	
	thread smoketown_at4_impact( smoketown_at4_hostile, attractor );
	//wait(.5);
	//level.smokeAT4dude notify ( "stop_idle" );
	level.smokeAT4dude waittillmatch ( "single anim", "end" );
	//level.smokeAT4dude anim_single_solo( level.smokeAT4dude, "RPG_standR_2_conceal" );
	level.smokeAT4dude thread anim_loop_solo (level.smokeAT4dude, "AT4_idle_short", undefined, "stop_idle");
	
	flag_set( "at4_sequence_over" );
	
	flag_wait( "player_smoketown_junkyard" );
	
	level.vasquez enable_ai_color();
}

stair_friendly_think()
{
	self endon( "death" );
	self setthreatbiasgroup ( "oblivious" );
	self disable_ai_color();
	
	flag_wait( "at4_sequence_over" );
	self setthreatbiasgroup ( "allies" );
	self enable_ai_color();
	
}
AT4_detach()
{
	self endon( "death" );
	self waittillmatch ( "single anim", "end" );
	org_hand = self gettagorigin("TAG_INHAND");
	angles_hand = self gettagangles("TAG_INHAND");
	self detach("weapon_AT4", "TAG_INHAND");
	model_at4 = spawn("script_model", org_hand);
	model_at4 setmodel( "weapon_at4" );
	model_at4.angles = angles_hand;	

	flag_wait( "at4_sequence_over" );
	flag_wait( "player_smoketown_junkyard" );	
	
	if ( isdefined( self.magic_bullet_shield ) )
		self stop_magic_bullet_shield();
	self delete();
}

lz_spawners()
{
	trig = getent( "spawn_trig_lz", "targetname" );
	trig trigger_off();
	flag_wait( "player_smoketown_junkyard_hardpoint" );
	trig trigger_on();
}

junkyard_assault()
{
	flag_wait( "at4_sequence_over" );

	flag_set( "obj_extract_team_complete" );

	flag_clear( "aa_smoketown_to_construction_section" );
	flag_set( "aa_construction_to_lz_section" );
		
	/*-----------------------
	COLORNODES FOR JUNKYARD - GUYS JUMP DOWN
	-------------------------*/		
	triggersEnable("colornodes_smoketown_end_initial", "script_noteworthy", true);
	triggersEnable("colornodes_smoketown_end", "script_noteworthy", true);
	trig_colornode = getent( "colornodes_smoketown_end_initial", "script_noteworthy" );
	trig_colornode notify( "trigger", level.player );

	/*-----------------------
	JUNKYARD ENEMIES
	-------------------------*/	
	//spawn_trigger_dummy( "dummy_spawner_construction" );

	/*-----------------------
	PLAYER HAS OVERRUN HARDPOINT
	-------------------------*/		
	flag_wait( "player_smoketown_junkyard_hardpoint" );
	//trigger house killspawner in case player hasn't gone in
	killspawner_smoketown_house = getent( "killspawner_smoketown_house", "targetname" );
	killspawner_smoketown_house notify( "trigger", level.player );
	
	/*-----------------------
	THIN OUT REMAINING AI
	-------------------------*/
	aAI_to_delete = getaiarray( "axis" );
	volume_construction_yard_rear = getent( "volume_construction_yard_rear", "targetname" );
	volume_construction_house_top_floor = getent( "volume_construction_house_top_floor", "targetname" );
	volume_construction_house_bottom_floor = getent( "volume_construction_house_bottom_floor", "targetname" );
	for(i=0;i<aAI_to_delete.size;i++)
	{
		if ( aAI_to_delete[i] istouching( volume_construction_house_top_floor ) )
		{
			aAI_to_delete = array_remove( aAI_to_delete, aAI_to_delete[i] ); 
			continue;
		}
		if ( aAI_to_delete[i] istouching( volume_construction_house_top_floor ) )
		{
			aAI_to_delete = array_remove( aAI_to_delete, aAI_to_delete[i] ); 
			continue;
		}
		if ( aAI_to_delete[i] istouching( volume_construction_house_bottom_floor ) )
		{
			aAI_to_delete = array_remove( aAI_to_delete, aAI_to_delete[i] ); 
			continue;
		}
	}

	thread AI_delete_when_out_of_sight( aAI_to_delete, 512 );
	
	/*-----------------------
	WAIT FOR A FEW SECS OR TILL PLAYER HEADS TO LZ
	-------------------------*/	
	flag_wait_or_timeout( "player_going_to_lz", 3 );
	
	/*-----------------------
	REMAINING AI SEEK OUT PLAYER
	-------------------------*/	
	aHostiles = getaiarray( "axis" );
	array_thread( aHostiles,::AI_player_seek );
	
	flag_set( "smoketown_hardpoint_overrun" );
	flag_clear( "aa_construction_to_lz_section" );
		
	thread autosave_by_name( "smoketown_hardpoint_overrun" );

}

smoketown_upstairs()
{
	flag_wait( "player_upstairs_smoketown" );
	setthreatbias( "player", "axis", 15000 );
}

smoketown_lz_advance()
{
	flag_wait( "smoketown_hardpoint_overrun" );
	/*-----------------------
	COLORNODES TO LZ
	-------------------------*/			
	disable_color_trigs();	
	triggersEnable( "colornodes_smoketown_lz_initial", "script_noteworthy", true );
	trig_colornode = getent( "colornodes_smoketown_lz_initial", "script_noteworthy" );
	trig_colornode notify( "trigger", level.player );
	triggersEnable( "colornodes_smoketown_lz", "script_noteworthy", true );

	/*-----------------------
	PLANES FLY IN DISTANCE
	-------------------------*/	
	flag_wait( "player_smoketown_lz_alley" );
	delaythread (0, maps\_vehicle::create_vehicle_from_spawngroup_and_gopath, 42 );	
	
	/*-----------------------
	PLAYER INSIDE SEAKNIGHT
	-------------------------*/			
	waittill_trigger_seaknight();
	flag_set ( "obj_extract_to_lz_complete" );
	thread autosave_by_name( "obj_extract_to_lz_complete" );
	flag_set( "player_at_smoketown_lz" );
	flag_set ( "obj_get_on_mark_19_given" );
	/*-----------------------
	PLAYER MOUNTS GUN
	-------------------------*/			
	waittill_trigger_seaknight_gun();
	flag_set ( "obj_get_on_mark_19_complete" );
	
	seaknight_player_mount_gun( true );
	thread maps\_utility::set_ambient("amb_int_helicopter_intensity5");
	setExpFog(400, 6500, 0.678431, 0.529574, 0.372549, 3);
	set_vision_set( "airlift", 3 );
	
	/*-----------------------
	DELETE ALL FRIENDLIES
	-------------------------*/		
	aAI_to_delete = getaiarray( "allies" );
	for(i=0;i<aAI_to_delete.size;i++)
	{
		if ( !isdefined( aAI_to_delete[i] ) )
			continue;
		if ( !isalive( aAI_to_delete[i] ) )
			continue;
			
		if ( isdefined( aAI_to_delete[i].magic_bullet_shield ) )
			aAI_to_delete[i] stop_magic_bullet_shield();
		aAI_to_delete[i] delete();
	}
	level thread AA_cobraflight_init();
	
}

smoketown_mortars()
{
	//flag_wait( "seaknight_landed_smoketown" );
	flag_wait( "seaknightLandingInSmoketown" );
	/*-----------------------
	MORTARS AT LZ
	-------------------------*/		
	thread maps\_mortar::bog_style_mortar_on(1);

	/*-----------------------
	STOP MORTARS & DELETE ALL COBRAS FROM LAST SECTION
	-------------------------*/		
	flag_wait( "player_constrction_approach" );
	thread maps\_mortar::bog_style_mortar_off(1);
	thread vehicles_delete_all( "cobras" );
}


smoketown_enemy_heli()
{
	flag_wait( "player_in_upper_construction_stairs" );
	
	/*-----------------------
	ENEMY HELI WITH FASTROPERS
	-------------------------*/
	heli = spawn_vehicle_from_targetname( "smoketown_heli_2" );
	crashOrgHeli = getent( "heli_crash_smoketown_2", "script_noteworthy" );
	assert(isdefined(crashOrgHeli));
	heli.perferred_crash_location = crashOrgHeli;	
	thread maps\_vehicle::gopath( heli );
	
	level.smoketownMi17 = spawn_vehicle_from_targetname( "smoketown_heli_1" );
	crashOrg = getent( "heli_crash_smoketown_1", "script_noteworthy" );
	assert(isdefined(crashOrg));
	level.smoketownMi17.perferred_crash_location = crashOrg;
	
	thread maps\_vehicle::gopath( level.smoketownMi17 );
	assert( isdefined( level.smoketownMi17.riders ) );
	//level.smoketownMi17 waittill( "unload" );
	//wait(4);
	//flag_set( "smoketown_mi17_unloaded" );
}



smoketown_cobra_think()
{
	flag_wait( "player_in_upper_construction_stairs" );

	/*-----------------------
	COBRA REAPPEARS AND PROVIDES CAS
	-------------------------*/	
	eCobra = spawn_vehicle_from_targetname( "cobra_wingman_smoketown" );
	eCobra notify( "stop_default_behavior" );
	
	flag_wait( "smoketown_mi17_owned" );
	thread maps\_vehicle::gopath( eCobra );
	eCobra thread vehicle_cobra_default_weapons_think();
	wait(.25);
	if ( isdefined( level.smoketownMi17 ) ) 
		self.preferredTarget = level.smoketownMi17;
	
	level.smoketownMi17 thread smoketown_heli_destroy_failsafe();
	
	wait(2.6);
	flag_set( "smoketown_cobra_returns" );
	
	/*-----------------------
	COBRA DISAPPEARS SO WE CAN SPAWN A SPECIFIC ONE FOR CRASH
	-------------------------*/				
	flag_wait( "player_smoketown_junkyard_hardpoint" );
	delete_path = getent( "cobra_smoketown_delete_path", "targetname" );
	eCobra vehicle_heli_deletepath( delete_path );
}

smoketown_heli_destroy_failsafe()
{
	org = level.smoketownMi17.origin;
	//self endon( "death");
	wait(4);
	self notify( "death" );
	
	playerEye = level.player getEye();
	bInFOV = within_fov( playerEye, level.player getPlayerAngles(), org, level.cosine[ "25" ]);
	if ( bInFOV )
		level.playerHasSeenMI17crash = true;

}

seaknight_smoketown_think()
{
	/*-----------------------
	SEAKNIGHT GETS THE HELL OUT
	-------------------------*/
	flag_wait( "smoketown_seaknight_leaves" );
	
	level.seaknight cleargoalyaw();
	level.seaknight vehicle_liftoff();
	level.seaknight vehicle_resumepath();

	/*-----------------------
	SEAKNIGHT COMES BACK
	-------------------------*/	
	flag_wait( "player_smoketown_junkyard_hardpoint" );
	
	smoketown_seaknight_return = getent( "smoketown_seaknight_return", "script_noteworthy" );
	level.seaknight vehicle_detachfrompath(); 
	level.seaknight thread vehicle_dynamicpath( smoketown_seaknight_return, false ); 
	level.seaknight thread vehicle_heli_land( getent( "seaknight_land_smoketown2", "script_noteworthy" ) );
	
	eBadplace = getent("volume_smoketown_lz_badplace", "targetname");
	badplace_brush( "volume_smoketown_lz_badplace", 0, eBadplace, "allies", "axis" );


	/*-----------------------
	SEAKNIGHT LANDS AT LZ
	-------------------------*/		
	level.seaknight waittill( "landed" );
	thread seaknight_player_triggers();
	flag_set( "seaknight_back_at_smoketown_lz" );
	badplace_delete( "volume_smoketown_lz_badplace" );

}

smoketown_at4_impact( smoketown_at4_hostile, attractor )
{
	wait(1.1);
	smoketown_at4_hostile invulnerable ( false );
	smoketown_at4_hostile.skipdeathanim = true;
	smoketown_at4_hostile dodamage( smoketown_at4_hostile.health + 1000, smoketown_at4_hostile.origin ); 
	missile_deleteAttractor(attractor);
	smoketown_physics_explosion = getent( "smoketown_physics_explosion", "targetname" );
	thread play_sound_in_space( "building_explosion3", smoketown_physics_explosion.origin );
	exploder( 2 );
	wait(0.1);
	physicsExplosionSphere( smoketown_physics_explosion.origin, level.physicsSphereRadius, level.physicsSphereRadius / 2, level.physicsSphereForce );
}


/****************************************************************************
    COBRA FLIGHT/CRASH
****************************************************************************/ 

AA_cobraflight_init()
{
	flag_wait( "seaknight_set_up" );
	thread cobra_flyover();
	thread cobra_missile();
	thread dialogue_cobraflight();
	thread cobra_crash();
	thread music_cobraflight();
}



music_cobraflight()
{	
	level endon ( "nuke_section_start" );
	
	flag_wait( "cobra_hit");
	musicStop();
	wait(.1);
	
	while( 1 )
	{
		MusicPlayWrapper( "airlift_cobradown_music" );
		wait( 96 );
		musicStop( 4 );
		wait 4.25;
	}
}

dialogue_cobraflight()
{

	//Marine 4
	//Thanks for the lift!
	//radio_dialogue_queue( "airlift_gm4_hellyeah" );



	
	//HQ Radio Voice
	//Outlaw, be advised, we have a situation here, over.
	radio_dialogue_queue( "airlift_hqr_situation" );
	
	//Male Helicopter Pilot
	//Go ahead Command, over.
	radio_dialogue_queue( "airlift_mhp_goahead" );

	//HQ Radio Voice
	//Seal Team Six has located a possible nuclear device at Al-Asad's palace to the west. NEST teams are on the way. Until the device is verified safe, all forces are to fall back to the east, over.
	level thread radio_dialogue_queue( "airlift_hqr_nestteams" );
	wait(6.4);
	flag_set( "cobra_rpg_launch" );
	//Male Helicopter Pilot
	//What's the minimum safe distance over?
	//radio_dialogue_queue( "airlift_mhp_safedistance" );
	
	//HQ Radio Voice
	//Minimum safe distance is ten miles. Get your asses outta there now! Out!
	//radio_dialogue_queue( "airlift_hqr_outtathere" );
	
	//Male Helicopter Pilot
	//Deadly this is Outlaw. Al-Asad's got a nuke. We're buggin' out. Lead the way.
	//level thread radio_dialogue_queue( "airlift_mhp_leadtheway" );

	//Female Helicopter Pilot
	//Roger that. Let's get outta (KABOOM helicopter is hit)
	//radio_dialogue_queue( "airlift_fhp_getoutta" );
	
	flag_wait( "cobra_hit" );
	//flag_wait( "cobraCrashStart" );
	wait(1);
	//Female Helicopter Pilot
	//We're hit we're hit!! I've lost the tail rotor!
	radio_dialogue_queue( "airlift_fhp_werehit" );
	
	wait(5.1);
	//Female Helicopter Pilot
	//Mayday mayday, this is Deadly, going in hard!
	radio_dialogue_queue( "airlift_fhp_mayday" );
	
	flag_wait( "cobraCrash02" );
	
	wait(.5);
	//Female Helicopter Pilot
	//We're going down.
	radio_dialogue_queue( "airlift_fhp_goingdown" );
	
	//Female Helicopter Pilot
	//Keating hang on - ! (static)
	//radio_dialogue_queue( "airlift_fhp_hangon" );
	
	flag_wait( "cobra_on_deck" );
	wait(1.75);
	//Male Helicopter Pilot
	//We have a Cobra down. I repeat, we have a Cobra down.
	radio_dialogue_queue( "airlift_mhp_cobradown" );
	
	//wait(1.5);
	//Male Helicopter Pilot
	//Deadly this Outlaw Two-Five, do you copy?
	//radio_dialogue_queue( "airlift_mhp_doyoucopy" );
	
	wait(2);
	//Male Helicopter Pilot
	//Deadly this Outlaw Two-Five, come in, over!
	radio_dialogue_queue( "airlift_mhp_comein" );
	
	wait(1.5);
	//Male Helicopter Pilot
	//Command, I have a visual on the crash site. I see small arms fire coming from the cockpit. Request permission to initiate search and rescue.
	radio_dialogue_queue( "airlift_mhp_smallarmsfire" );
	
	wait(1);
	//HQ Radio Voice
	//Copy Two-Five, be advised, you will NOT be at a safe distance in the event that nuke goes off. Do you understand?
	radio_dialogue_queue( "airlift_hqr_notsafe" );

	thread autosave_by_name( "cobraflight_end" );	
	//Male Helicopter Pilot
	//Roger that. We know what we're getting into.
	radio_dialogue_queue( "airlift_mhp_weknow" );
	wait(1.5);
	//HQ Radio Voice
	//All right Two-Five, it's your call. Retrieve that pilot if you can. Out.
	radio_dialogue_queue( "airlift_hqr_youcall" );
	
	
	//Male Helicopter Pilot
	//Deadly do you copy? What's your status, over?
	radio_dialogue_queue( "airlift_mhp_youstatus" );

	//Female Helicopter Pilot
	//(cough) I'm here!...(coughing, firing) Keating is KIA!!! Hostiles moving in fast!! (gunfire gunfire) I could sure use some help down here!! (gunfire)
	radio_dialogue_queue( "airlift_fhp_usesomehelp" );

	//Male Helicopter Pilot
	//Hold on, we're coming to ya.
	radio_dialogue_queue( "airlift_mhp_werecoming" );

	//wait(3);
	//HQ Radio Voice
	//Outlaw Two-Five, hundreds of enemy troops are bearing down on the crash site! Estimate your position WILL be overrun in 90 seconds!
	//radio_dialogue_queue( "airlift_hqr_willbeoverrun" );


	flag_set( "cobra_crash_dialogue_over" );
}

cobra_flyover()
{
	
	/*-----------------------
	SOUNDS OF GUYS LOADING IN
	-------------------------*/	
	level notify( "delete_pilots" );
	level.seaknight thread maps\airlift_anim::seaknight_close_doors();
	
	wait(4);

	setsaveddvar( "sm_sunSampleSizeNear", 1 ); // air
	setsaveddvar( "sm_sunShadowScale", 0.5 ); // optimization
	
	/*-----------------------
	START ALL FX IN COBRASTREETS
	-------------------------*/	
	array_thread(level.fxCobrastreets, ::restartEffect);

	/*-----------------------
	MORTARS ON
	-------------------------*/	
	delaythread (3, maps\_mortar::bog_style_mortar_on, 2 );		

	/*-----------------------
	NEW COBRA FLIES BESIDE YOU
	-------------------------*/	
	level.wingman = spawn_vehicle_from_targetname( "wingmanCobraflight" );
	thread maps\_vehicle::gopath( level.wingman );
	
	/*-----------------------
	SEAKNIGHT LIFTOFF FROM SMOKETOWN
	-------------------------*/	
	eLandNode = getent( "seaknight_land_smoketown2", "script_noteworthy" );
	speed = eLandNode.speed;
	decel = eLandNode.script_decel;
	accel = eLandNode.script_accel;
	level.seaknight setSpeed( speed, accel, decel );
	level.seaknight cleargoalyaw();
	level.seaknight vehicle_liftoff();
	level.seaknight vehicle_resumepath();


	
	//level.seaknight setmaxpitchroll( 5, 10 );
	
	/*-----------------------
	CLEAN UP REMAINING AI
	-------------------------*/		
	aAI_to_delete = getaiarray( "allies" );
	thread AI_delete_when_out_of_sight( aAI_to_delete, 10 );
	aAI_to_delete = getaiarray();
	thread AI_delete_when_out_of_sight( aAI_to_delete, 2048 );


	/*-----------------------
	COBRA SHOT DOWN
	-------------------------*/	
	
	flag_wait( "cobra_on_deck" );
	
	/*-----------------------
	DRONES IN THE HILLS
	-------------------------*/	
	delaythread (0, ::triggerActivate, "trig_spawn_drones_cobra_hills_01" );

	/*-----------------------
	DRONES IN THE OASIS
	-------------------------*/	
	delaythread (0, ::triggerActivate, "trig_spawn_drones_cobra_oasis_01" );
	
	/*-----------------------
	ROOFTOP AND ALLEY DUDES
	-------------------------*/			
	wait(8);
	triggerActivate( "trig_spawn_cobra_flyover_01" );
	
	wait(3);
	triggerActivate( "trig_spawn_cobra_roof_03" );
	wait(9.5);
	triggerActivate( "trig_spawn_cobra_roof_01" );

	/*-----------------------
	OASIS TANKS
	-------------------------*/		
	delaythread (2, maps\_vehicle::create_vehicle_from_spawngroup_and_gopath, 52 );

	/*-----------------------
	STOP ALL FX IN SMOKETOWN
	-------------------------*/	
	array_thread(level.fxSmoketown, ::pauseEffect);
	
	/*-----------------------
	SEAKNIGHT LANDS IN SMOKETOWN
	-------------------------*/
	level thread AA_cobrastreets_init();
	
	flag_wait( "seaknightLandingCobratown" );
	
	setsaveddvar( "sm_sunSampleSizeNear", 0.25 ); // ground
	setsaveddvar( "sm_sunShadowScale", 1 ); // default
	
}

cobra_missile()
{
	flag_wait( "cobra_rpg_launch" );
	/*-----------------------
	LAUNCH MISSILE AT DUMMY
	-------------------------*/	
	missile_source = spawn_vehicle_from_targetname( "missile_source" );
	missile_source hide();
	missile_source setVehWeapon( "hunted_crash_missile" );
	missile_source setturrettargetent( level.wingman );
	wait(1);
	dummy_target = getent( "dummy_target", "targetname" );
	missile = missile_source fireweapon( "tag_missile_right", dummy_target, ( 0,0,0 ) );
//	while( distance2d( missile.origin, dummy_target.origin ) > 350 && isdefined(missile) )
//		wait 0.05;
//	maps\_vehicle::delete_group( missile_source );	
	/*-----------------------
	MISSILE CHANGES TARGET TO COBRA TAIL ROTOR
	-------------------------*/	
	dummy = spawn( "script_origin", level.wingman gettagorigin( "tail_rotor_jnt") );
	dummy linkto( level.wingman, "tag_origin", ( 500, 0, 0), ( 0, 0, 0 ) );
	missile missile_settarget( dummy );

	/*-----------------------
	WAIT UNTIL MISSILE HITS
	-------------------------*/	
	old_dist = distancesquared( missile.origin, level.wingman gettagorigin( "tail_rotor_jnt") );
	wait 0.05;
	while( distancesquared( missile.origin, level.wingman gettagorigin( "tail_rotor_jnt") ) < old_dist )
	{
		old_dist = distancesquared( missile.origin, level.wingman gettagorigin( "tail_rotor_jnt") );
		wait 0.1;
	}
	
	//level.wingman waittill( "damage", damage, attacker, direction_vec, point, type );
	flag_set( "cobra_hit" );
	missile delete();
}

cobra_crash()
{
	//flag_wait( "cobraCrashStart" );
	flag_wait( "cobra_hit" );
	
	level.wingman.yawspeed = 400;
	level.wingman.yawaccel = 100;
	level.wingman SetMaxPitchRoll( 100, 200 );
	
	level.wingman thread cobra_crash_rotate();
	level.wingman thread cobra_crash_fx();
	level.wingman thread cobra_crash_attached_fx();

	/*-----------------------
	HITS TREE
	-------------------------*/	
	wait(4.7);
	cobra_crash_tree_01 = getent( "cobra_crash_tree_01", "targetname" );
	cobra_crash_tree_01 playsound( "tree_collapse" );
	fRotateTime = 2;
	ang = cobra_crash_tree_01.angles;
	ang += ( -80, 10, 0);
	cobra_crash_tree_01 rotateto(ang, fRotateTime, fRotateTime/2, fRotateTime/2);


		
	/*-----------------------
	HITS FIRST ROOF
	-------------------------*/	
	flag_wait( "cobraCrash01" );

	cobra_crash_roof_01 = getent( "cobra_crash_roof_01", "targetname" );
	physicsExplosionSphere( cobra_crash_roof_01.origin, level.physicsSphereRadius, level.physicsSphereRadius / 2, level.physicsSphereForce );
	
	cobra_crash_antenna_01 = getent( "cobra_crash_antenna_01", "targetname" );
	fRotateTime = 1;
	ang = cobra_crash_antenna_01.angles;
	ang += ( 0, 0, 80);
	cobra_crash_antenna_01 rotateto(ang, fRotateTime, fRotateTime/2, fRotateTime/2);
	
	wait(.25);
	cobra_crash_antenna_02 = getent( "cobra_crash_antenna_02", "targetname" );
	fRotateTime = 1;
	ang = cobra_crash_antenna_02.angles;
	ang += ( 0, 0, -80);
	cobra_crash_antenna_02 rotateto(ang, fRotateTime, fRotateTime/2, fRotateTime/2);
}

cobra_crash_rotate()
{
	flag_wait( "cobraCrash01" );
	
	self setturningability( 1 );

	self endon( "stop_rotate" );
	while ( isdefined( self ) )
	{
		self setyawspeed( level.wingman.yawspeed, level.wingman.yawaccel );
		self settargetyaw( self.angles[1] - 170 );
		wait 0.1;
	}
}

cobra_crash_fx()
{
	cobraCrash01 = getent( "cobraCrash01", "targetname" );
	cobraCrash02 = getent( "cobraCrash02", "targetname" );
	cobraCrash03 = getent( "cobraCrash03", "targetname" );
	cobra_smoke = getent( "cobra_smoke", "targetname" );
	cobra_crash_end = getent( "cobra_crash_end", "targetname" );

	/*-----------------------
	COBRA HIT BY MISSILE
	-------------------------*/	
	flag_wait( "cobra_hit" );	
	//flag_wait( "cobraCrashStart" );
	playfxontag( getfx( "heli_aerial_explosion_large" ), self, "tail_rotor_jnt" );
	earthquake( 0.5, 2, level.player.origin, 8000);
	
	self thread play_sound_on_entity( "scn_airlift_cobra_down" );
	self thread play_sound_on_entity( "scn_airlift_cobra_exp1" );
	
	//self playsound( "blackhawk_helicopter_hit" );
	wait(1);
	//self thread play_loop_sound_on_entity ("airlift_heli_alarm_loop");
	
	/*-----------------------
	HITS FIRST ROOF
	-------------------------*/	
	flag_wait( "cobraCrash01" );
	self thread play_sound_on_entity( "scn_airlift_cobra_exp2" );
	//self thread play_loop_sound_on_entity ("mi17_helicopter_dying_loop");
	earthquake( 0.4, 1, level.player.origin, 8000);
	exploder_trigger( 600, cobraCrash01.origin );
	playfxontag( getfx( "heli_aerial_explosion" ), self, "tag_deathfx" );

	/*-----------------------
	HITS SECOND ROOF
	-------------------------*/				
	//flag_wait( "cobraCrash03" );
	wait(5.5);
	//cobraCrash03 playsound( "ceiling_collapse" );
	self thread play_sound_on_entity( "scn_airlift_cobra_exp3" );
	earthquake( 0.3, 2, level.player.origin, 8000);
	exploder_trigger( 700, cobraCrash03.origin );
	playfxontag( getfx( "heli_aerial_explosion" ), self, "tag_deathfx" );
	
	
	/*-----------------------
	COBRA HITS THE DECK
	-------------------------*/		
	//flag_wait( "cobraCrashEnd" );
	wait(3);
	self notify ( "stop sound" + "mi17_helicopter_dying_loop" );
	self notify ( "stop sound" + "airlift_heli_alarm_loop" );
	earthquake( .3, 3.5, level.player.origin, 1000);
	exploder_trigger( 800, cobra_crash_end.origin );
	//playfx ( getfx( "smoke_cobra_crash" ), cobra_smoke.origin, ( 0, 0, 0), (0, 0, 0) );
	
	//cobra_crash_end playsound( "ceiling_collapse" );
	//cobra_crash_end playsound( "airlift_cobra_crash_end_02" );
	
	flag_set( "cobra_on_deck" );
	
	/*-----------------------
	SWAP MODELS
	-------------------------*/		

	self notify( "crash_end" );
	self notify( "stop_rotate" );
	self delete();
	thread show_cobra_crash();
	
	cobrapilot_spawn();
}

show_cobra_crash()
{
	cobra_crash = getent( "cobra_crash", "targetname" );
	assert(isdefined(cobra_crash));	
	cobra_crash show();
}

	
exploder_trigger( iNumber, org )
{
	iNumber = string( iNumber );
	exploder( iNumber );
	
	if ( isdefined( level.scr_sound[ "exploder" ][ iNumber ] ) )
	{
		assertex( isdefined( org ), "Need to pass an org for this sound to play on" );
		thread play_sound_in_space( level.scr_sound[ "exploder" ][ iNumber ], org );	
	}
}

cobra_crash_attached_fx()
{
	self endon( "crash_end" );
	self endon( "death" );
	flag_wait( "cobra_hit" );
	//flag_wait( "cobraCrashStart" );
	while ( true )
	{
		org = self GetTagOrigin( "tail_rotor_jnt" );
		playfx( getfx( "smoke_trail_heli" ), org );
		wait(0.05);
	}
}

/****************************************************************************
    COBRA STREETS
****************************************************************************/ 
AA_cobrastreets_init()
{
	flag_wait( "seaknight_set_up" );
	thread cobrastreets_kill();
	thread dialogue_cobrastreets();
	thread cobrastreets_crewchief_think();
	thread obj_rescue_pilot();
	thread obj_return_pilot();
	thread carrying_hint();
	thread cobra_streetfight();
	thread cobra_crashsite_think();
}

cobrastreets_kill()
{
	level endon( "obj_rescue_pilot_complete" );
	level.player endon( "death" );
	trig_cobrastreets_kill = getent( "trig_cobrastreets_kill", "targetname" );
	assert(isdefined(trig_cobrastreets_kill));
	trig_cobrastreets_kill thread cobrastreets_instakill();
	killVolume = getent( "cobrastreets_kill", "targetname" );
	assert(isdefined(killVolume));
	damage = 50;
	while ( true )
	{
		wait( 0.05 );
		if ( level.player isTouching( killVolume ) )
		{
			fViewKick = randomintrange( 90, 127 );
			level.player viewkick(fViewKick, level.player.origin);
			level.player dodamage( 50, level.player.origin ); 
			wait( randomfloatrange( .5, 1.7 ) );
			damage = damage + 30;
		}
	}
}

cobrastreets_instakill()
{
	level endon( "obj_rescue_pilot_complete" );
	level.player endon( "death" );
	self waittill( "trigger" );
	level.player dodamage( level.player.health + 1000, level.player.origin ); 
}

cobrastreets_crewchief_think()
{

	flag_wait( "pilot_taken_from_cockpit" );
	/*-----------------------
	CREWCHIEF NOW PLAYS GUN IDLE
	-------------------------*/	
	level.crewchief notify ( "stop_default_behavior" );		
	level.crewchief notify ( "stop_idle_crewchief" );
	level.crewchief animscripts\shared::placeWeaponOn( level.crewchief.secondaryweapon, "right" );
	level.crewchief thread anim_loop_solo( level.crewchief, "crewchief_gun_idle", "tag_detach", "stop_idle_crewchief", level.seaknight );	
	
	/*-----------------------
	CREWCHIEF FIRES GUN UNTIL PLAYER CLOSE
	-------------------------*/	
	flag_wait( "player_cobra_retreat_03" );

	while ( distancesquared( level.player.origin, level.crewchief.origin ) > level.crewchiefRangeSquared )
	{
		level.crewchief notify ( "stop_idle_crewchief" );
		level.crewchief thread anim_loop_solo( level.crewchief, "crewchief_gun_shoot", "tag_detach", "stop_idle_crewchief", level.seaknight );	
		level.crewchief waittillmatch ( "looping anim", "end" );
	}

	/*-----------------------
	PLAYER GETTING CLOSE...STOP SHOOTING
	-------------------------*/	
	level.crewchief notify ( "stop_default_behavior" );		
	level.crewchief notify ( "stop_idle_crewchief" );
	level.crewchief thread anim_loop_solo( level.crewchief, "crewchief_gun_idle", "tag_detach", "stop_idle_crewchief", level.seaknight );	

	/*-----------------------
	CREWCHIEF WAVES IN WITH GUN
	-------------------------*/
	if ( !level.usingstartpoint )
	{
		flag_wait( "cobrastreet_seaknight_loading" );
		level.crewchief notify ( "stop_idle_crewchief" );
		
		level.crewchief thread anim_loop_solo( level.crewchief, "crewchief_gun_getin", "tag_detach", "stop_idle_crewchief", level.seaknight );
		wait(5);
		level.crewchief waittillmatch ( "looping anim", "end" );
		level.crewchief notify ( "stop_idle_crewchief" );
		level.crewchief thread anim_loop_solo( level.crewchief, "crewchief_gun_idle", "tag_detach", "stop_idle_crewchief", level.seaknight );	
		wait(1.3);
		level.crewchief notify ( "stop_idle_crewchief" );
		level.crewchief thread anim_loop_solo( level.crewchief, "crewchief_gun_getin", "tag_detach", "stop_idle_crewchief", level.seaknight );
		wait(1);

		/*-----------------------
		CREWCHIEF FIRES GUN OUT DOOR
		-------------------------*/	
		level.crewchief notify ( "stop_idle_crewchief" );
		level.crewchief thread anim_loop_solo( level.crewchief, "crewchief_gun_shoot", "tag_detach", "stop_idle_crewchief", level.seaknight );	
		level.crewchief waittillmatch ( "looping anim", "end" );
		level.crewchief notify ( "stop_idle_crewchief" );
		level.crewchief thread anim_loop_solo( level.crewchief, "crewchief_gun_shoot", "tag_detach", "stop_idle_crewchief", level.seaknight );	
		wait(3);
		/*-----------------------
		CREWCHIEF SDTEPS FORWARD AND SHOOTS GUN, THEN PLAYS GUN IDLE
		-------------------------*/	
		level.crewchief notify ( "stop_idle_crewchief" );
		level.seaknight anim_single_solo( level.crewchief, "airlift_crewchief_stepout", "tag_detach", level.seaknight );
		level.crewchief notify ( "stop_idle_crewchief" );
		
		level.seaknight anim_single_solo( level.crewchief, "airlift_crewchief_stepout_fire", "tag_detach", level.seaknight );

		//level.crewchief thread anim_loop_solo( level.crewchief, "airlift_crewchief_stepout_fire", "tag_detach", "stop_idle_crewchief", level.seaknight );	
		//level.crewchief waittillmatch ( "looping anim", "end" );
		//level.crewchief notify ( "stop_idle_crewchief" );
		
		level.seaknight anim_single_solo( level.crewchief, "airlift_crewchief_stepout_fire_2_idle", "tag_detach", level.seaknight );
		level.crewchief thread anim_loop_solo( level.crewchief, "airlift_crewchief_stepout_idle", "tag_detach", "stop_idle_crewchief", level.seaknight );	
	}
	
	/*-----------------------
	CREWCHIEF PLAYS NUKE REACTION/DIES
	-------------------------*/	
	flag_wait( "nuke_explodes" );
	level.crewchief notify ( "stop_idle_crewchief" );
	level.seaknight anim_single_solo( level.crewchief, "crewchief_sucked_out", "tag_detach", level.seaknight );

	if ( isdefined( level.crewchief.magic_bullet_shield ) )
		level.crewchief stop_magic_bullet_shield();
	level.crewchief delete();

}

dialogue_crash_site_nag()
{
	thread dialogue_crash_site_nag_cleanup();
	level endon( "pilot_taken_from_cockpit" );
	iNagNumber = 1;
	while ( !flag( "pilot_taken_from_cockpit" ) )
	{
		wait(10);
		if ( !flag( "pilot_taken_from_cockpit" ) )
		{
			if ( iNagNumber == 1 )
			{
				//Lt. Vasquez
				//Jackson! We're running out of time! Get her out of there! We'll cover you! Move!
				level.vasquez dialogue_execute( "airlift_vsq_getherout" );	
				iNagNumber++;				
			}
			else if ( iNagNumber == 2 )
			{
				//Lt. Vasquez
				//Jackson! Get the pilot! Get the pilot! Hurry!!	
				level.vasquez dialogue_execute( "airlift_gm2_getpilot" );	
				iNagNumber++;	
		
			}
			else if ( iNagNumber == 3 )
			{
				//Lt. Vasquez
				//Jackson! Get the pilot back outta that helo! Move!!!	
				level.vasquez dialogue_execute( "airlift_gm2_outofhelo" );	
				iNagNumber++;	
		
			}
			else if ( iNagNumber == 4 )
			{
				//Lt. Vasquez
				//Sgt. Jackson! Grab the pilot, we'll hold 'em off!!
				level.vasquez dialogue_execute( "airlift_gm2_holdemoff" );	
				iNagNumber++;	
		
			}
			else if ( iNagNumber == 5 )
			{
				//Lt. Vasquez
				//Pull that pilot out of the cockpit while we cover you, Jackson! Move it!	
				level.vasquez dialogue_execute( "airlift_gm2_coveryou" );	
				iNagNumber = 1;	
		
			}				
			if ( !flag( "pilot_taken_from_cockpit" ) )
				thread hint(&"SCRIPT_PLATFORM_AIRLIFT_HINT_GETPILOT", 5);
		}
	}
}

dialogue_crash_site_nag_cleanup()
{
	flag_wait( "pilot_taken_from_cockpit" );
	thread hint_fade();	
}

dialogue_cobrastreets()
{
	flag_wait( "cobra_crash_dialogue_over" );
	
	battlechatter_off( "allies" );
	
	flag_wait( "player_exited_seaknight_cobrastreets" );
	
	//HQ Radio Voice
	//Be advised Two-Five, hostiles advancing parallel southwest of your position towards the crash site.
	radio_dialogue_queue( "airlift_hqr_hostilesadvancing" );

	//Lt. Vasquez
	//We’ve got hostiles converging on the crash site! Move!
	//radio_dialogue_queue( "airlift_vsq_crashsite" );
	
	//Lt. Vasquez
	//We got 90 seconds Jackson! Get the pilot! NO ONE gets left behind!	HR1	
	radio_dialogue_queue( "airlift_vsq_90sec" );
	
	battlechatter_on( "allies" );
	
	flag_wait( "player_near_crash_site" );
	//Lt. Vasquez
	//Jackson! Pull her out of there and get back to the LZ! Do it!
	level.vasquez dialogue_execute( "airlift_vsq_pullherout" );
	
	thread dialogue_crash_site_nag();

	flag_wait( "pilot_taken_from_cockpit" );
	flag_set( "obj_rescue_pilot_complete" );
	wait(3);
	
	//Lt. Vasquez
	//Get to the seaknight! We’ll hold down these corners. Go!
	level.vasquez dialogue_execute( "airlift_vsq_holddown" );
	
	flag_set("obj_return_pilot_given");
	
	//Male Helicopter Pilot
	//Lt. Vasquez, this is Outlaw Two-Five, now would be a good time to get the hell outta here over.
	radio_dialogue_queue( "airlift_mhp_goodtime" );
	
	//Lt. Vasquez
	//Roger that we're on our way!
	radio_dialogue_queue( "airlift_vsq_onourway" );
	
}


cobrapilot_spawn()
{
	level.crashnode = getent( "node_pilot_crash", "targetname" );
	assert(isdefined(level.crashnode));
	spawner = getent( "friendly_cobrapilot", "script_noteworthy" );
	level.cobrapilot = spawnDude( spawner, "stalingrad" );
	level.cobrapilot.animname = "frnd";
	level.cobrapilot thread cobrapilot_think();	
}

cobra_streetfight()
{
	flag_wait( "seaknightLandingCobratown" );

	maps\_friendlyfire::TurnOff();	//set because the seaknight will sometimes land on hidden friendlies in cobrastreets

	/*-----------------------
	DISABLE RETREAT TRIGGERS
	-------------------------*/
	aTrigger_cobra_retreat = getentarray( "trigger_cobra_retreat", "script_noteworthy" );
	array_thread( aTrigger_cobra_retreat,::trigger_off );
	
	/*-----------------------
	SEAKNIGHT LANDS IN SMOKETOWN
	-------------------------*/
	level.seaknight thread vehicle_heli_land( getent( "seaknight_land_cobrastreets", "script_noteworthy" ) );
	
	/*-----------------------
	FRIENDLIES SPAWNED TO UNLOAD
	-------------------------*/
	level.aFriendliesSeaknight = spawnGroup( getentarray( "seaknight_unloaders_cobrastreets", "targetname" ), true );
	level.vasquez = getDudeFromArray( level.aFriendliesSeaknight, "vasquez" );
	assert(isdefined( level.vasquez ) );		
	level.crewchief = spawnDude( getent( "seaknight_crewchief_cobrastreets", "targetname" ), true );
	level.seaknight thread vehicle_seaknight_unload( level.aFriendliesSeaknight, level.crewchief );
	level.seaknight waittill( "landed" );
	aAI_to_delete = getaiarray( "axis" );
	thread AI_delete_when_out_of_sight( aAI_to_delete, 100 );

	flag_set( "seaknight_landed_cobrastreets" );

	flag_set( "aa_cobra_rescue_section" );
	
	thread maps\_mortar::bog_style_mortar_off( 2 );

	
	/*-----------------------
	SPAWN PILOT, DEAD PILOT
	-------------------------*/	
	
	if ( !isdefined( level.cobrapilot ) )
		cobrapilot_spawn();
	spawner = getent( "friendly_deadpilot", "script_noteworthy" );
	level.deadpilot = spawnDude( spawner, "stalingrad" );
	//level.deadpilot = dronespawn( spawner );
	level.deadpilot.animname = "frnd";
	level.deadpilot gun_remove();
	level.deadpilot setcontents(0);
	level.deadpilot.allowdeath = false;
	level.deadpilot.ignoreme = true;
	level.deadpilot.grenadeawareness = 0;
	level.crashnode thread anim_loop_solo( level.deadpilot, "deadpilot_idle", undefined, "stop_idle_deadpilot" );

	/*-----------------------
	LZ FRIENDLIES WHO PROTECT YOUR ADVANCE
	-------------------------*/
	level.aFriendliesLZ = spawnGroup( getentarray( "friendlies_cobrastreets_lz", "targetname" ), true );
	aPilot_drones = getentarray( "pilots_cobrastreets", "targetname" );
	spawn_pilots( aPilot_drones );
	/*-----------------------
	UNLINK PLAYER AND UNLOAD HIDDEN AI
	-------------------------*/	
	wait(2);
	flag_set( "obj_rescue_pilot_given" );

	/*-----------------------
	START TIMER
	-------------------------*/		
	delaythread( 1, ::rescue_timer, 90 );
	thread vehicles_delete_all( "t72s" );

	level.seaknight notify ( "unload_ai" );
	thread seaknight_player_dismount_gun();
	thread maps\_utility::set_ambient("amb_ext_ground_intensity4");
	maps\_friendlyfire::TurnBackOn(); //set because the seaknight will sometimes land on hidden friendlies in cobrastreets
	level.seaknight waittill ( "all_ai_unloaded" );
	
	while ( level.playerInSeaknight == true )
		wait ( 0.05 );
	flag_set( "player_exited_seaknight_cobrastreets" );
	/*-----------------------
	PLANES FLY IN DISTANCE
	-------------------------*/
	delaythread (0, maps\_vehicle::create_vehicle_from_spawngroup_and_gopath, 51 );	
	thread autosave_by_name( "seaknight_landed_cobrastreets" );
	/*-----------------------
	COLORNODES FOR COBRA APPROACH
	-------------------------*/		
	array_thread( level.aFriendliesSeaknight, ::ai_notify, "stop_ch46_idle", 10);
	triggersEnable("colornodes_cobrastreets_start", "script_noteworthy", true);
	
	flag_wait( "pilot_taken_from_cockpit" );
	flag_clear( "aa_cobra_rescue_section" );
	flag_set( "aa_cobra_escape_section" );
	delaythread (4, ::stance_carry_icon_enable, true );
	setsaveddvar( "player_deathinvulnerabletime", "10000" );


	/*-----------------------
	ENABLE RETREAT TRIGGERS
	-------------------------*/
	aTrigger_cobra_retreat = getentarray( "trigger_cobra_retreat", "script_noteworthy" );
	array_thread( aTrigger_cobra_retreat,::trigger_on );
	
	/*-----------------------
	COLORNODES FOR COBRA RETREAT
	-------------------------*/		
	triggersEnable("colornodes_cobrastreets_start", "script_noteworthy", false);
	triggersEnable("colornodes_cobrastreets_end", "script_noteworthy", true);
	
	/*-----------------------
	SETUP DUMMIES FOR SEAKNIGHT EXIT
	-------------------------*/			
	//4 dudes slam to idle positions outside seaknight and are hidden
	level.aFriendliesLZdummies = spawnGroup( getentarray( "friendlies_cobrastreets_lz_dummies", "targetname" ), true );
	vehicle_seaknight_idle_and_load( level.aFriendliesLZdummies );	
	
	/*-----------------------
	ENEMIES OVERWHELM PLAYER AS RETREATING
	-------------------------*/		
	flag_wait( "player_cobra_retreat_01" );
	triggerActivate( "killspawner_cobra_retreat_01" );
	spawn_trigger_dummy( "dummy_spawner_cobra_retreat_01" );
	wait( 0.1 );
	aHostiles = getaiarray( "axis" );
	array_thread( aHostiles,::AI_player_seek );
	
	/*-----------------------
	3 OF YOUR RED SQUAD BECOME VULNERABLE
	-------------------------*/	
	level.aFriendliesSeaknight = array_remove( level.aFriendliesSeaknight, level.vasquez );
	for(i=0;i<level.aFriendliesSeaknight.size;i++)
	{
		if ( isdefined( level.aFriendliesSeaknight[i].magic_bullet_shield ) )
			level.aFriendliesSeaknight[i] stop_magic_bullet_shield();
	}
		
	//flag_wait( "player_cobra_retreat_02" );
	
	//flag_wait( "player_cobra_retreat_03" );

	/*-----------------------
	PLAYER PUTS DOWN PILOT
	-------------------------*/	
	flag_wait( "player_putting_down_pilot" );
	flag_clear( "aa_cobra_escape_section" );
	thread stance_carry_icon_enable( false );
	flag_set ( "obj_return_pilot_complete" );
	thread kill_timer();
	thread autosave_by_name( "obj_return_pilot_complete" );
	
	/*-----------------------
	REPULSOR FOR SEAKNIGHT
	-------------------------*/	
	ent = spawn( "script_origin", level.seaknight.origin );
	ent.origin = level.seaknight gettagorigin( "tag_door_rear" );
	Seaknightrepulsor = Missile_CreateRepulsorEnt( ent, 7000, 500 );
	ent linkto( level.seaknight, "tag_door_rear", ( 0, 0, 100 ), ( 0, 0, 0 ) );

	/*-----------------------
	MORE ENEMIES SWARM CRASH SITE
	-------------------------*/			
	triggerActivate( "killspawner_cobra_retreat_01" );
	spawn_trigger_dummy( "dummy_spawner_cobra_end" );
	wait( 0.1 );
	aHostiles = getaiarray( "axis" );
	array_thread( aHostiles,::AI_player_seek );
	
	/*-----------------------
	DELETE ALL FRIENDLIES AND SHOW DUMMIES INSTEAD
	-------------------------*/		
	
	//show dudes outside and delete others
	level.seaknight notify ( "show_loaders" );
	
	for(i=0;i<level.aFriendliesLZ.size;i++)
	{
		if ( isdefined( level.aFriendliesLZ[i].magic_bullet_shield ) )
			level.aFriendliesLZ[i] stop_magic_bullet_shield();
		level.aFriendliesLZ[i] delete();
	}

	for(i=0;i<level.aFriendliesSeaknight.size;i++)
	{
		if ( !isdefined( level.aFriendliesSeaknight[i] ) )
			continue;
		if ( !isalive( level.aFriendliesSeaknight[i] ) )
			continue;
		if ( isdefined( level.aFriendliesSeaknight[i].magic_bullet_shield ) )
			level.aFriendliesSeaknight[i] stop_magic_bullet_shield();
		level.aFriendliesSeaknight[i] delete();
	}	
	if ( isdefined( level.vasquez ) )
	{
		if ( isdefined( level.vasquez.magic_bullet_shield ) )
			level.vasquez stop_magic_bullet_shield();
		level.vasquez delete();
	}

	
	wait(1);
	level.seaknight notify ( "load" );
	flag_set( "cobrastreet_seaknight_loading" );

	flag_wait( "seaknight_leaving_cobrastreets" );
	
	missile_deleteAttractor(Seaknightrepulsor);

}

cobra_crashsite_think()
{
	/*-----------------------
	RPG REPULSOR
	-------------------------*/		
	eTarget = getent( "obj_rescue_pilot", "targetname" );
	repulsor = Missile_CreateRepulsorEnt( eTarget, 7000, 500 );

	flag_wait( "pilot_taken_from_cockpit" );
	wait(3);
	missile_deleteAttractor(repulsor);

	/*-----------------------
	SCUTTLE THE CRASHSITE
	-------------------------*/			

}

cobrapilot_wave()
{
	level endon( "pilot_taken_from_cockpit" );

	level.crashnode notify ( "stop_idle_pilot" );
	level.crashnode anim_single_solo( self, "wounded_cockpit_wave_over" );
	level.crashnode thread anim_loop_solo( self, "wounded_cockpit_idle", undefined, "stop_idle_pilot" );
	wait( randomfloatrange(2,4) );	
	while ( !flag( "pilot_taken_from_cockpit" ) )
	{
		wait( 0.05 );
		if ( !flag( "player_near_cobra" ) )
		{
			level.crashnode notify ( "stop_idle_pilot" );
			level.crashnode anim_single_solo( self, "wounded_cockpit_wave_over" );
			level.crashnode thread anim_loop_solo( self, "wounded_cockpit_idle", undefined, "stop_idle_pilot" );	
			wait( randomfloatrange(2,4) );
		}
	}
}

cobrapilot_think()
{
	self.useable = true;
	self thread cobrapilot_shoots_enemies();
	
	//anim_loop_solo( guy, anime, tag, ender, entity )
	level.crashnode thread anim_loop_solo( self, "wounded_cockpit_shoot", undefined, "stop_idle_pilot" );

	/*-----------------------
	PILOT STOPS SHOOTING AND WAVES AS PLAYER APPROACHES
	-------------------------*/
	flag_wait( "player_near_crash_site" );
	self.ignoreme = true;
	self.grenadeawareness = 0;
	self setthreatbiasgroup ( "oblivious" );
	self thread cobrapilot_wave();

	/*-----------------------
	PLAYER ACTIVATES COCKPIT
	-------------------------*/	
	self SetCursorHint( "HINT_NOICON" );
	self sethintstring( &"SCRIPT_PLATFORM_AIRLIFT_HINT_PICKUP_PILOT" );
	self waittill ( "trigger" );
	level.player EnableInvulnerability();
	flag_set( "pilot_taken_from_cockpit" );
	level.player allowprone( false );
   	level.player allowcrouch( false );
	
	level.cobrapilot.useable = false;
	//flag_wait( "player_activates_cockpit" );

	/*-----------------------
	PLAYER PLAYS PULLOUT ANIM WITH PILOT
	-------------------------*/	
	level.player disableweapons();
	level.player SetMoveSpeedScale( 0.85 );
	level.player allowCrouch( false );
	level.player allowProne( false );
	level.player allowsprint( false );
	level.player allowjump( false );
		
	// this is the model the player will attach to for the pullout sequence
	level.ePlayerview = spawn_anim_model( "player_carry" );
	level.ePlayerview hide();
	
	// put the level.ePlayerview in the first frame so the tags are in the right place
	level.crashnode anim_first_frame_solo( level.ePlayerview, "wounded_pullout" );

	// this smoothly hooks the player up to the animating tag
	level.ePlayerview lerp_player_view_to_tag( "tag_player", 0.5, 1, 35, 35, 45, 0 );

	// now animate the tag and then unlink the player when the animation ends
	level.ePlayerview show();
	level.crashnode thread anim_single_solo( level.ePlayerview, "wounded_pullout" );
	level.crashnode anim_single_solo( self, "wounded_pullout" );
	level.ePlayerview delete();

	level.player unlink();
	self hide();
	self setcontents(0);

	level.player DisableInvulnerability();
	
	level thread AA_nuke_init();

}

cobrapilot_shoots_enemies()
{
	spawner = getent( "hostile_velindakill", "targetname" );
	eHostile = undefined;
	level thread cobrapilot_shoots_enemies_cleanup( eHostile );
	while ( !flag( "velinda_kills_dude" ) )
	{
		wait( .05 );
		if ( isdefined( eHostile ) )
			continue;
		self waittillmatch ( "looping anim", "end" );
		wait(.8);
		eHostile = spawnDude( spawner, true );
		eHostile.ignoreme = true;
		eHostile setthreatbiasgroup ( "oblivious" );
		eHostile waittill( "goal" );
		self waittillmatch ( "looping anim", "fire" );
		if ( !isdefined( eHostile ) )
			continue;
		magicbullet( level.cobrapilot.weapon, level.cobrapilot gettagorigin( "tag_flash" ), eHostile gettagorigin ( "TAG_EYE" ) );	
		playfxontag( getfx( "headshot" ), eHostile, "tag_eye");	
	}
}

cobrapilot_shoots_enemies_cleanup( eHostile )
{
	flag_wait( "velinda_kills_dude" );
	if ( isdefined( eHostile ) )
	{
		eHostile.ignoreme = false;
		eHostile setthreatbiasgroup ( "axis" );
	}
	
}

/****************************************************************************
    NUKE!
****************************************************************************/ 

AA_nuke_init()
{
	thread nuke_flight();
	thread dialogue_nuke();
	thread music_nuke();
	thread seaknight_speed_up();
	thread nuke();
}

music_nuke()
{
	flag_wait( "nuke_section_start" );
	
	//musicStop(5);
	//wait 5.1;
	
	//MusicPlayWrapper( "icbm_combat_tension_music" );
	
	flag_wait( "nuke_explodes");
	
	musicStop( 4 );
	wait 4.1;
	
	flag_wait( "shockwave_about_to_hit_player");
	
	wait(1);
	
	MusicPlayWrapper( "airlift_crash_music" );
}

dialogue_nuke()
{
	flag_wait( "nuke_section_start" );
	
	//HQ Radio Voice
	//Outlaw this is Command. We have a probable nuclear threat in the capital. Proceed to the minimum safe distance until the all clear is given by the NEST team.
	radio_dialogue_queue( "airlift_hqr_nuclearthreat" );
	
	wait(1);
	//Lt. Vasquez
	//Go! Go!
	radio_dialogue_queue( "airlift_vsq_gogo" );
	
	wait(5.5);

	setsaveddvar( "sm_sunSampleSizeNear", 1 ); // air
	setsaveddvar( "sm_sunShadowScale", 0.5 ); // optimization

	//Male Helicopter Pilot
	//Ladies and gentlemen this is your Captain speaking. We're in for some chop! Hang on! Jake gimme max power.
	radio_dialogue_queue( "airlift_mhp_inforchop" );
	
	wait(.5);
	//Co Pilot
	//Roger that.
	//radio_dialogue_queue( "airlift_cop_rogerthat" );
	
	//HQ Radio Voice
	//All U.S. forces, be advised, we have a confirmed nuclear threat in the city. NEST teams are on site and attempting to disarm. I repeat, we have a confirmed nu-(BOOM)
	level thread radio_dialogue_queue( "airlift_hqr_confirmed" );
	
	flag_wait( "shockwave_about_to_hit_player");
	//Lt. Vasquez
	//Everyone hang onnnn!!!
	level thread radio_dialogue( "airlift_vsq_hangon" );
}


nuke_flight()
{
	level.ePlayerview = spawn_anim_model( "player_carry" );
	level.ePlayerview hide();
	
	// put the level.ePlayerview in the first frame so the tags are in the right place
	arrayTemp = [];
	arrayTemp[0] = level.ePlayerview;
	anim_teleport( arrayTemp, "wounded_putdown", "tag_detach", undefined, level.seaknight );
	level.seaknight anim_first_frame_solo( level.ePlayerview, "wounded_putdown", "tag_detach" );
	
	if ( isdefined( level.cobrapilot ) )
	{
		if ( isdefined( level.cobrapilot.magic_bullet_shield ) )
			level.cobrapilot stop_magic_bullet_shield();
		level.cobrapilot delete();
	}
	spawner = getent( "friendly_cobrapilot_2", "script_noteworthy" );
	spawner.animname = "frnd";
	arrayTemp = [];
	arrayTemp[0] = spawner;
	anim_spawner_teleport( arrayTemp, "wounded_putdown", "tag_detach", undefined, level.seaknight );
	level.cobrapilot = spawnDude( spawner, "stalingrad" );
	level.cobrapilot setcontents(0);
	level.cobrapilot.ignoreme = true;
	level.cobrapilot.grenadeawareness = 0;
	level.cobrapilot setthreatbiasgroup ( "oblivious" );
	level.cobrapilot hide();
	level.seaknight anim_first_frame_solo( level.cobrapilot, "wounded_putdown", "tag_detach" );
	/*-----------------------
	WAIT FOR PLAYER TO RE-ENTER SEAKNIGHT
	-------------------------*/	
	trig_pilot_putdown = getent( "trig_pilot_putdown", "targetname" );
	trig_pilot_putdown waittill ( "trigger" );
	
	flag_set( "nuke_section_start" );
	thread hud_hide( true );
	thread maps\_utility::set_ambient("amb_int_helicopter_intensity5");
	
	/*-----------------------
	PLACE PILOT AND PLAYER
	-------------------------*/	
	flag_set( "player_putting_down_pilot" );
	level.player EnableInvulnerability();
	//setsaveddvar( "cg_hudGrenadeIconEnabled", 0 ); // no grenade indicator since you are in god mode
	
	level notify( "delete_pilots" );
	
	wait(0.05);
	// this smoothly hooks the player up to the animating tag
	level.ePlayerview lerp_player_view_to_tag( "tag_player", 0.5, 1, 35, 35, 45, 0 );

	// now animate the tag and then unlink the player when the animation ends
	level.cobrapilot show();
	level.ePlayerview show();
	
	thread cobrapilot_grunt();

	level.seaknight thread anim_single_solo( level.ePlayerview, "wounded_putdown", "tag_detach", level.seaknight );
	
	level.seaknight anim_single_solo( level.cobrapilot, "wounded_putdown", "tag_detach", level.seaknight );
	
	level.ePlayerview hide();
	
	/*-----------------------
	LINK PLAYER TO CURRENT POS TO SEE NUKE
	-------------------------*/		
	level.player enableweapons();
										//<viewpercentag fraction>, <right arc>, <left arc>, <top arc>, <bottom arc> )
	level.ePlayerview linkto( level.seaknight );
	level.player playerlinktodelta( level.ePlayerview, "tag_player", 1, 20, 45, 5, 25 );
	
	wait(1);
	
	if ( isdefined( level.cobrapilot.magic_bullet_shield ) )
		level.cobrapilot stop_magic_bullet_shield();
	level.cobrapilot delete();			

	flag_set( "pilot_put_down_in_seaknight" );
	/*-----------------------
	SPAWN NUKE CHOPPERS
	-------------------------*/		
	delaythread (14, maps\_vehicle::create_vehicle_from_spawngroup_and_gopath, 36 );

	
	wait(8);
	
	
	level.seaknight setSpeed(60);
	level.seaknight cleargoalyaw();
	level.seaknight vehicle_liftoff();
	level.seaknight vehicle_resumepath();
	level.seaknight setmaxpitchroll( 25, 50 );
	level.seaknight setAirResistance(1);
	level.seaknight SetAcceleration(5);
	level.seaknight SetJitterParams( (0,0,20), 0.5, 1.5 ); // Jitter up or down randomly within 20 units, switching every 0.5 to 1.5 seconds
	flag_set( "seaknight_leaving_cobrastreets" );
	/*-----------------------
	RPGS PASS DOOR
	-------------------------*/	
	delaythread (1.5, ::rpg_fake, "rpg_source_cobra_end" );

	/*-----------------------
	STOP ALL FX
	-------------------------*/	
	array_thread(level.fxCobrastreets, ::pauseEffect);
	array_thread(level.fxSmoketown, ::pauseEffect);
	array_thread(level.fxIntro, ::pauseEffect);
	
		
	/*-----------------------
	KILL OFF REMAINING AI
	-------------------------*/	
	triggerActivate( "killspawner_cobra_end" );
	thread autosave_by_name( "cobra_leave" );
	aAI_to_delete = getaiarray( "axis" );
	thread AI_delete_when_out_of_sight( aAI_to_delete, 2048 );

}

cobrapilot_grunt()
{
	wait (1.5);
	level.player thread play_sound_on_entity( level.scr_sound[ "airlift_fhp_pains" ] );
}
	
nuke()
{
	flag_wait( "seaknightStartingNukePath" );

	wait(5.5);
	
	/*-----------------------
	NUKE HITS
	-------------------------*/	
	thread nuke_sunlight();
	flag_set( "nuke_explodes" );
	wait(.5);
	level.player disableWeapons();
	level.player playlocalsound( "airlift_nuke_impact" );
	level.player playlocalsound( "airlift_nuke" );
	exploder( 666 );
	setExpFog(0, 17000, 0.678352, 0.498765, 0.372533, 0.5);
	thread nuke_shockwave_blur();
	wait(1);
	thread nuke_earthquake();
	
	/*-----------------------
	CHOPPERS ENGULFED
	-------------------------*/	
	delaythread (1.8, ::nuke_chopper_crash, "nuke_cobra_04" );
	delaythread (2.3, ::nuke_chopper_crash, "nuke_cobra_02" );
	delaythread (2.3, ::nuke_chopper_crash, "nuke_seaknight_01" );
	delaythread (3.0, ::nuke_chopper_crash, "nuke_cobra_03" );
	delaythread (3.7, ::nuke_chopper_crash, "nuke_cobra_01" );
	delaythread (4.2, ::nuke_chopper_crash, "nuke_cobra_05" );
	
	//delete other seaknight which is now out of view
	nuke_seaknight_02 = getent( "nuke_seaknight_02", "targetname" );
	nuke_seaknight_02 delete();
	
	wait(1);
	flag_set( "nuke_flattens_trees" );
	wait(2);
	
	flag_set( "shockwave_about_to_hit_player");
	wait(2);
	/*-----------------------
	SEAKNIGHT BEGINS CRASH
	-------------------------*/		
	flag_set( "nuke_shockwave_hits" );
	thread nuke_shockwave_blur();
	set_vision_set( "airlift_nuke", 8 );
	level.seaknight.yawspeed = 400;
	level.seaknight.yawaccel = 100;
	//level.seaknight SetMaxPitchRoll( 100, 200 );
	level.seaknight thread nuke_seaknight_spin();
	level.seaknight thread play_sound_on_entity ("ch46_helicopter_dying_loop");
	level.player thread play_loop_sound_on_entity ("airlift_heli_alarm_loop");
	level.player thread play_sound_on_entity( "airlift_ch46_nuke_exp" );
													//<right arc>, <left arc>, <top arc>, <bottom arc> 
	level.player playerlinktodelta( level.ePlayerview, "tag_player", 1, 0, 55, 5, 25 );
	
	//level.player play_sound_in_space( "airlift_ch46_nuke_shockwave" );
	//earthquake( .4, 20, level.player.origin, 80000);
	flag_set( "shockwave_hit_player");
	
	wait(7);
	/*-----------------------
	SEAKNIGHT DETACHES AND HEADS TO DIRT
	-------------------------*/			
	nuke_crash = getent( "nuke_crash", "targetname" );
	level.seaknight vehicle_detachfrompath();
	level.seaknight setvehgoalpos( nuke_crash.origin, false );
	
	wait(6.5);

	/*-----------------------
	FLASH AND BLACK OUT
	-------------------------*/		
	set_vision_set( "airlift_nuke_flash", 2 );
	
	wait(1.5);
	wait(.5);
	black_overlay = create_overlay_element( "black", 1 );
	level.player thread play_sound_in_space( "airlift_ch46_nuke_crash" );
	level.player freezeControls(true);
	//black_overlay fadeOverTime( .1 );
	//black_overlay.alpha = 1;
	//wait(.5);
	musicstop();
	AmbientStop();
	level.player notify ( "stop sound" + "airlift_heli_alarm_loop" );
	level.seaknight StopSounds();
	level.player StopSounds();
	wait(.1);
	
	level.seaknight delete();

	wait(4);
	nextmission();
}

nuke_earthquake()
{
	wait(1);
	while ( !flag( "shockwave_hit_player" ) )
	{
		earthquake( .08, .05, level.player.origin, 80000);
		wait(.05);
	}
	earthquake( .5, 1, level.player.origin, 80000);
	while ( true )
	{
		earthquake( .25, .05, level.player.origin, 80000);
		wait(.05);
	}
}

nuke_sunlight()
{
	level.defaultSun = getMapSunLight();
	level.nukeSun = ( 3.11, 2.05, 1.67 );
	sun_light_fade( level.defaultSun, level.nukeSun, 2 );
	wait(1);
	thread sun_light_fade( level.nukeSun, level.defaultSun, 2 );
}

nuke_shockwave_blur()
{
	earthquake( 0.3, .5, level.player.origin, 80000);
	SetBlur( 3, .1 );
	wait 1;
	SetBlur( 0, .5 );
}

nuke_seaknight_spin()
{
	self setturningability( 1 );
	self endon( "stop_rotate" );
	while ( isdefined( self ) )
	{
		self setyawspeed( level.seaknight.yawspeed, level.seaknight.yawaccel );
		self settargetyaw( self.angles[1] + 150 );
		wait 0.1;
	}
}

nuke_chopper_crash( sTargetname )
{
	eChopper = getent( sTargetname, "targetname" );
	assert(isdefined(eChopper));
	eChopper notify( "crash" );
}

nuke_choppers_think()
{
	self endon( "death" );
	self notify( "stop_default_behavior" );
	if ( getdvar( "debug_airlift" ) == "1" )
		self thread print3Dthread( self.targetname, undefined, 3.5, 100 );	
	self waittill( "crash" );

	/*-----------------------
	IS THIS THE COBRA RIGHT NEAR THE PLAYER DOOR? (bIsWingman = true)
	-------------------------*/		
	bIsWingman = false;
	if ( ( isdefined( self.targetname ) ) && ( self.targetname == "nuke_cobra_05" ) )
		bIsWingman = true;
		
	/*-----------------------
	HELI CRASH
	-------------------------*/	
	self thread nuke_chopper_spin_and_fx(bIsWingman);
	wait(6);
	/*-----------------------
	HELI EXPLODES
	-------------------------*/		
	self notify( "stop spin" );
	//playfxOnTag( getfx( "nuked_chopper_explosion" ), self, "tag_origin");

	
	self delete();
}

nuke_chopper_spin_and_fx(bIsWingman)
{
	self endon( "death" );
	self endon( "stop spin" );
	self SetMaxPitchRoll( 100, 200 );
	self setturningability( 1 );
	yawspeed = 1400;
	yawaccel = 200;
	targetyaw = undefined;
	spinLeft = undefined;	
	if ( RandomInt( 100 ) > 50 )
	{
		spinLeft = true;
		//yawspeed = 1200;
		//yawaccel = 200;
	}
	/*-----------------------
	INITIAL EXPLOSION FX (IF ANY)
	-------------------------*/		
	if ( ( isdefined( bIsWingman ) ) && ( bIsWingman == true ) )
	{
		playfxOnTag( getfx( "heli_aerial_explosion_large" ), self, "tag_engine_left");
	}
	else
	{
		//custom fx for default choppers instead of looping
		playfxOnTag( getfx( "nuked_chopper_explosion" ), self, "tag_engine_left");
	}
	/*-----------------------
	SPIN AND PLAY SMOKE TRAIL
	-------------------------*/			
	while ( isdefined( self ) )
	{
		if ( isdefined( spinLeft ) )
			targetyaw = self.angles[1] + 100;
		else
			targetyaw = self.angles[1] - 100;
		self setyawspeed( yawspeed, yawaccel );
		self settargetyaw( targetyaw );
		if ( ( isdefined( bIsWingman ) ) && ( bIsWingman == true ) )
		{
			playfxOnTag( getfx( "nuked_chopper_smoke_trail" ), self, "tag_engine_left");
		}
		else
			playfxOnTag( getfx( "nuked_chopper_smoke_trail" ), self, "tag_engine_left");
		wait 0.1;
	}
}


seaknight_speed_up()
{
	/*-----------------------
	SEAKNIGHT SPEEDS UP INCREMENTALLY UNTIL NUKE GOES OFF
	-------------------------*/	
	flag_wait( "seaknightStartingNukePath" );
	iBaseSpeed = 80;
	while( !flag( "nuke_shockwave_hits" ) )
	{
		iBaseSpeed += 5;
		level.seaknight setSpeed(iBaseSpeed);
		if ( !flag( "nuke_shockwave_hits" ) )
			wait(.5);
	}
}





/****************************************************************************
    OBJECTIVES
****************************************************************************/ 

obj_plaza_clear()
{
	flag_wait("obj_plaza_clear_given");
	objective_number = 2;
	
	obj_position = getent ( "obj_rescue_pilot", "targetname" );
	objective_add( objective_number, "active", &"AIRLIFT_OBJ_PLAZA_CLEAR", obj_position.origin );
	objective_current ( objective_number );

	flag_wait ( "obj_plaza_clear_complete" );
	
	objective_state ( objective_number, "done" );	
}

obj_extract_team()
{
	flag_wait("obj_extract_team_given");
	objective_number = 4;
	
	obj_position = getent ( "obj_extract_team", "targetname" );
	objective_add( objective_number, "active", &"AIRLIFT_OBJ_EXTRACT_TEAM", obj_position.origin );
	objective_current ( objective_number );
	
	flag_wait ( "obj_extract_team_complete" );
	
	objective_state ( objective_number, "done" );	
}



obj_extract_to_lz()
{
	flag_wait("obj_extract_to_lz_given");
	objective_number = 6;
	
	obj_position = getent ( "obj_lz_handhold", "targetname" );
	objective_add( objective_number, "active", &"AIRLIFT_OBJ_EXTRACT_TO_LZ", obj_position.origin );
	objective_current ( objective_number );

	obj_position = getent ( "obj_extract_to_lz", "targetname" );
	
	flag_wait_either( "obj_extract_to_lz_complete", "seaknight_back_at_smoketown_lz" );

	Objective_Position( objective_number, obj_position.origin );
	
	flag_wait ( "obj_extract_to_lz_complete" );
	
	objective_state ( objective_number, "done" );	
}

obj_get_on_mark_19()
{
	flag_wait("obj_get_on_mark_19_given");
	objective_number = 7;
	
	obj_position = getent ( "trigger_seaknight_gun", "targetname" );
	objective_add( objective_number, "active", &"AIRLIFT_OBJ_GET_ON_MARK_19", obj_position.origin );
	objective_current ( objective_number );

	flag_wait ( "obj_get_on_mark_19_complete" );
	
	objective_state ( objective_number, "done" );	
}

obj_rescue_pilot()
{
	flag_wait("obj_rescue_pilot_given");
	objective_number = 8;

	obj_position = getent ( "obj_rescue_pilot", "targetname" );
	
	objective_add( objective_number, "active", &"AIRLIFT_OBJ_RESCUE_PILOT", obj_position.origin );
	objective_current ( objective_number );
	
	flag_wait ( "obj_rescue_pilot_complete" );
	
	objective_state ( objective_number, "done" );	
}

obj_return_pilot()
{
	flag_wait("obj_return_pilot_given");
	objective_number = 9;

	obj_position = getent( "obj_rescue_pilot_putdown", "targetname" );
	
	objective_add( objective_number, "active", &"AIRLIFT_OBJ_RETURN_PILOT", obj_position.origin );
	objective_current ( objective_number );
	
	flag_wait ( "obj_return_pilot_complete" );
	
	objective_state ( objective_number, "done" );	
}

obj_safe_distance()
{
	flag_wait("obj_safe_distance_given");
	objective_number = 10;
	
	obj_position = getent ( "obj_rescue_pilot", "targetname" );
	objective_add( objective_number, "active", &"AIRLIFT_OBJ_SAFE_DISTANCE", obj_position.origin );
	objective_current ( objective_number );

	flag_wait ( "obj_safe_distance_complete" );
	
	objective_state ( objective_number, "done" );	
}


/****************************************************************************
    VEHICLE FUNCTIONS
****************************************************************************/ 
AA_vehicles()
{
	
}

vehicles_delete_all( sVehicleType )
{
	aVehicle_array = [];
	switch( sVehicleType )
	{
		case "cobras":
			aVehicle_array = level.cobras;
			break;
		case "t72s":
			aVehicle_array = level.t72s;
			break;			
	}
	
	for(i=0;i<aVehicle_array.size;i++)
	{
		if ( isdefined( aVehicle_array[i] ) )
			aVehicle_array[i] delete();
	}
	
}

vehicle_delete_thread()
{
	//wait until a certain flag is set, then destroy this vehicle
	self endon( "death" );
	if ( ( isdefined( self.script_noteworthy ) ) && ( getsubstr( self.script_noteworthy, 0, 10 ) == "deleteFlag" ) )
	{
		sFlag = getsubstr( self.script_noteworthy, 11 );
		flag_wait( sFlag );
		
		while ( true )
		{
			wait (0.05);
			playerEye = level.player getEye();
			bInFOV = within_fov( playerEye, level.player getPlayerAngles(), self.origin, level.cosine[ "25" ]);
			if ( !bInFOV )
			{
				self notify ( "death" );	
				break;
			}
			else
				wait ( randomfloatrange(1, 2.2) );
		}
	}
}




vehicle_think()
{
	eVehicle = maps\_vehicle::waittill_vehiclespawn_spawner_id( self.spawner_id );
	if ( ( isdefined( self.script_parameters ) ) && ( self.script_parameters == "playerTarget" ) )
		level.cobraTargetExcluders[ level.cobraTargetExcluders.size ] = eVehicle;
	if ( ( isdefined( eVehicle.targetname ) ) && ( eVehicle.targetname == "seaknightPlayer" ) )
		return;
	if ( ( isdefined( eVehicle.vehicletype ) ) && ( eVehicle.vehicletype == "flare" ) )
		return;	
	if ( ( isdefined( eVehicle.vehicletype ) ) && ( eVehicle.vehicletype == "nuke" ) )
		return;	
	/*-----------------------
	VARIABLE SETUP
	-------------------------*/	
	assertex( isdefined( self.script_team ), "Need to define a script_team for vehicle at " + eVehicle.origin);
	if ( self.script_team == "axis" )
	{
		eVehicle thread vehicle_death_think();
		level.vehicles_axis = array_add( level.vehicles_axis, eVehicle );
	}
		
	else if ( self.script_team == "allies" )
		level.vehicles_allies = array_add( level.vehicles_allies, eVehicle );
		
	else
		assertmsg( "vehicle at " + eVehicle.origin + " has script_team defined, but it is neither axis or allies ( " + eVehicle.script_team + " ? )" );
		
	assertex( isdefined( eVehicle.vehicletype ), "No vehicletype defined for vehicle at " + eVehicle.origin );

	/*-----------------------
	RUN VEHICLE SPECIFIC THREADS
	-------------------------*/	
	eVehicle thread vehicle_damage_think();
	eVehicle thread vehicle_delete_thread();

	/*-----------------------
	RUN SECTION-SPECIFIC THREADS FOR THIS VEHICLE
	-------------------------*/	
//	if ( !isdefined( level.section ) )
//		return;
//	
//	switch ( level.section )
//	{
//		case "intro_to_plaza":
//			self thread vehicle_intro_to_plaza_think();
//
//	}
//		

	if ( ( isdefined( eVehicle.script_noteworthy ) ) && ( eVehicle.script_noteworthy == "nuke_choppers" ) )
		eVehicle thread nuke_choppers_think();
	else
	{
		switch ( eVehicle.vehicletype )
	    {
	    	case "zpu_antiair":
	    		eVehicle thread vehicle_zpu_think();
	    	case "m1a1":
	    		eVehicle thread vehicle_m1a1_think();
	    		break;
	    	case "bmp":
	    		eVehicle thread vehicle_bmp_think();
	    		break;
	    	case "t72":
	    		eVehicle thread vehicle_t72_think();
	    		level.t72s = array_add( level.t72s, eVehicle );	
	    		break;
	    	case "cobra":
	    		eVehicle thread vehicle_cobra_think();
	    		level.cobras = array_add( level.cobras, eVehicle );	
	    		break;
	     	case "mig29":
	    		break; 
	     	case "seaknight_airlift":
	    		break; 
	    }		
	}
}

vehicle_heli_deletepath( eDeletePathStart )
{
	assert( isdefined( eDeletePathStart) );
	self vehicle_detachfrompath(); 
	self thread vehicle_dynamicpath( eDeletePathStart, false ); 
	eEndNode = eDeletePathStart get_last_ent_in_chain( "ent" );
	assert(isdefined(eEndNode));
	eEndNode waittill( "trigger", vehicle );
	self vehicle_detachfrompath();
	self delete();
}

vehicle_death_think()
{
	self waittill( "death", attacker, cause );
	if ( ( isdefined( attacker ) ) && ( isdefined( attacker.targetname ) ) && ( attacker.targetname == "seaknightPlayer" ) )
		arcadeMode_kill( self.origin, "explosive", 150 );
	if ( isdefined( self ) )
		earthquake( 0.2, 2, self.origin, 8000);	
}

vehicle_zpu_think()
{
	self endon( "death" );
	assertex( isdefined( self.script_linkTo ), "ZPU needs to script_linkTo at least one script_origin for a default target" );
	self.defaultTargets = getentarray( self.script_linkTo, "script_linkname"  );
	assertex( self.defaultTargets.size > 0, "You need to have this ZPU target at least one script_origin to use as a default target. Origin: " + self.origin );
	self thread vehicle_turret_think();
	self thread vehicle_zpu_death();
}

vehicle_zpu_death()
{
	self waittill ( "damage", damage, attacker, direction_vec, point, type );
	println( "zpu damaged" );
}

vehicle_heli_land( eNode )
{
	self endon( "death" );
	eNode waittill( "trigger", vehicle );
	self notify( "landing" );
	self vehicle_detachfrompath();
	self setgoalyaw( eNode.angles[ 1 ] );
	vehicle_land();
	self notify( "landed" );
}

vehicle_cobra_think()
{
	self endon( "death" );
	self thread vehicle_cobra_default_weapons_think();

	/*-----------------------
	REACHES NEXT-TO-LAST AND LAST NODE IN CHAIN
	-------------------------*/	
	eEndNode = self get_last_ent_in_chain( "ent" );
	bReachedNextToLastNode = false;
	bReachedLastNode = false;

	/*-----------------------
	CONTINUALLY CHECK NODES AND UPDATE COBRA INFO
	-------------------------*/	
	while ( isdefined( eEndNode ) )
	{
		
		self waittill_any( "near_goal", "goal" );
		self.preferredTarget = undefined;
		eNextNode = undefined;

		/*-----------------------
		SEE IF THERE IS A NEXT NODE IN CHAIN
		-------------------------*/				
		if ( ( isdefined( self.currentnode ) ) && ( isdefined( self.currentnode.target ) )  )		
			eNextNode = getent( self.currentnode.target, "targetname" );
		
		/*-----------------------
		CHECK IF NEXT NODE HAS ANY PREFERRED TARGETS
		-------------------------*/		
		if ( ( isdefined( eNextNode ) ) && ( isdefined( eNextNode.script_linkTo ) ) )
			self.preferredTarget = getent( eNextNode.script_linkTo, "script_linkname" );
			
		/*-----------------------
		COBRA NOTIFY WHEN AT NEXT TO LAST NODE IN CHAIN
		-------------------------*/			
		if ( ( bReachedNextToLastNode == false ) && ( isdefined( eNextNode ) ) )
		{
			if ( eNextNode == eEndNode )
			{
				self notify( "near_default_path_end" );
				bReachedNextToLastNode = true;			
			}
		}
		/*-----------------------
		COBRA NOTIFY WHEN AT LAST NODE IN CHAIN
		-------------------------*/		
		if ( ( bReachedNextToLastNode == true ) && ( isdefined( self.currentnode ) ) && ( self.currentnode == eEndNode ) )
		{
			self notify( "reached_default_path_end" );
			bReachedLastNode = true;
		}
		/*-----------------------
		RESTART CHECKING AFTER SWITCHES TO ANOTHER PATH
		-------------------------*/				
		if ( ( bReachedLastNode == true ) && ( bReachedNextToLastNode == true ) )
		{
			bReachedNextToLastNode = false;
			bReachedLastNode = false;
			self waittill( "start_dynamicpath" );
			eEndNode = self get_last_ent_in_chain( "ent" );
		}
			
	}

}

vehicle_cobra_default_weapons_think()
{
	self endon( "death" );
	self endon( "stop_default_behavior" );
	//self thread vehicle_mg_on();
	self.turretFiring = false;
	while ( true )
	{
		wait( 0.05 );	

		/*-----------------------
		FIRE MISSILES AT PREFERRED TARGETS FIRST
		-------------------------*/		
		if ( isdefined( self.preferredTarget ) )
			eTarget = self.preferredTarget;

		/*-----------------------
		OTHERWISE FIND A GOOD VEHICLE TARGET
		-------------------------*/			
		//getEnemyTarget( fRadius, iFOVcos, getAITargets, doSightTrace, getVehicleTargets, randomizeTargetArray, aExcluders )
		else
			eTarget = maps\_helicopter_globals::getEnemyTarget( 3000, level.cosine[ "20" ], true, true, true, true, level.cobraTargetExcluders );
		
		if ( ( isdefined( eTarget ) ) && ( isdefined( eTarget.classname ) ) )
		{
			switch ( eTarget.classname )
			{
				case "script_origin":	//a preferred target that the next node in cobra's path is script_linkTo'ed
					
					// check if the cobra is within fov
					iFOVcos = level.cosine[ "15" ];
					forwardvec = anglestoforward( self.angles );
					normalvec = vectorNormalize( eTarget.origin - ( self.origin ) );
					vecdot = vectordot( forwardvec, normalvec );
					if ( vecdot <= iFOVcos )
						break;
					else
					{
						iShots = 1;
						self maps\_helicopter_globals::fire_missile( "ffar_airlift", iShots, eTarget );
						wait randomfloatrange( 2, 4.0 );	
						
//						
//						//if random target, make sure player can see it
//						playerEye = level.player getEye();
//						
//						// check if the cobra or target is within fov
//						bInFOV = within_fov( playerEye, level.player getPlayerAngles(), self.origin, level.cosine[ "40" ]);
//						if ( !bInFOV )
//							bInFOV = within_fov( playerEye, level.player getPlayerAngles(), eTarget.origin, level.cosine[ "40" ]);
//						
//						// FIRE if either is within FOV
//						if ( bInFOV )
//						{
//							iShots = 1;
//							self maps\_helicopter_globals::fire_missile( "ffar_airlift", iShots, eTarget );
//							wait randomfloatrange( 2, 4.0 );						
//						}

					}
					break;
				case "script_vehicle":	
					iShots = 1;
					if ( ( isdefined( level.smoketownMi17 ) ) && ( eTarget == level.smoketownMi17 ) )
						self maps\_helicopter_globals::fire_missile( "ffar_airlift_nofx", iShots, eTarget );
					else
						self maps\_helicopter_globals::fire_missile( "ffar_airlift", iShots, eTarget );
					wait randomfloatrange( 1, 4.0 );
					break;
				default:
					//enemy target must be an AI, GUN HIS ASS DOWN!!!
					self setTurretTargetEnt( eTarget, ( 0, 0, 48) );	//48 offfset targets right in the middle
					if (!self.turretFiring)
						self thread fireMG();
					break;
			}
		}
	}	
}

fireMG()
{
	self endon ("death");
	iFireTime = 0.1;
	//iFireTime = weaponfiretime("hind_turret");
	iBurstNumber = randomintrange(8, 20);
	self.turretFiring = true;
	i = 0;
	while (i < iBurstNumber)
	{
		i++;
		wait(iFireTime);
		self fireWeapon();
	}
	self.turretFiring = false;
}

vehicle_m1a1_think()
{
	self endon( "death" );
	self endon( "stop_default_behavior" );
	if ( ( isdefined( self.targetname ) )  && ( self.targetname == "tank_crusher" ) )
		return;
	
	self thread vehicle_turret_scan();
}

vehicle_turret_scan()
{
	self endon( "death" );
	/*-----------------------
	RANDOMLY SCAN WITH TURRET
	-------------------------*/			
	i = RandomInt(2);
	
	while ( isdefined( self ) )
	{
		if ( RandomInt( 100 ) > 50 )
		{
			self vehicle_aim_turret_at_angle( 0 );
			wait( randomfloatrange( 2,10 ) );
		}
		
		if ( i == 0 )
		{
			angle = randomintrange( 10, 30 );
			i = 1;
		}
		else
		{
			angle = randomintrange( -30, -10 );
			i = 0;			
		}

		self vehicle_aim_turret_at_angle( angle );
		wait( randomfloatrange( 2,10 ) );
	}	
}

vehicle_aim_turret_at_angle( iAngle )
{
	self endon( "death" );
	vec = AnglesToForward( self.angles + ( 0, iAngle, 0 ) );
	vec = vectorscale( vec, 10000 );
	dummy = spawn( "script_origin", self.origin + vec + ( 0, 0, 70 ) );
	dummy linkto( self );
	self setTurretTargetEnt( dummy );
	self waittill_notify_or_timeout( "turret_rotate_stopped", 10 );
	dummy delete();
}

vehicle_bmp_think()
{
	self SetDeceleration(50);
	self thread vehicle_turret_think();
}

vehicle_mg_off()
{
	//if ( isdefined( self.mgturret ) )
		self thread maps\_vehicle::mgoff();
}

vehicle_mg_on()
{
	//if ( isdefined( self.mgturret ) )
		self thread maps\_vehicle::mgon();
}

vehicle_turret_think()
{
	self endon ("death");
	self vehicle_mg_off();
	self.turretFiring = false;
	eTarget = undefined;
	while ( true )
	{
		wait (0.05);
		/*-----------------------
		DISTANCE CHECK TO PLAYER
		-------------------------*/	
		if ( distancesquared( level.player.origin, self.origin ) > level.CannonRangeSquared )
			eTarget = undefined;
		else
			eTarget = level.player;

		/*-----------------------
		IF CURRENT IS PLAYER, DO SIGHT TRACE
		-------------------------*/		
		if ( (isdefined(eTarget)) && (eTarget == level.player) )
		{
			sightTracePassed = false;
			sightTracePassed = sighttracepassed( self.origin, level.player.origin + ( 0, 0, 150 ), false, self );
			/*-----------------------
			IF CURRENT IS PLAYER BUT CAN'T SEE HIM, GET ANOTHER TARGET
			-------------------------*/		
			if ( !sightTracePassed )
			{
				eTarget = undefined;
			}
		}

		/*-----------------------
		IF PLAYER ISN'T CURRENT TARGET, GET ANOTHER
		-------------------------*/	
		if ( !isdefined( eTarget ) )
			eTarget = self vehicle_get_target();


		/*-----------------------
		ROTATE TURRET TO CURRENT TARGET
		-------------------------*/		
		if ( ( isdefined( eTarget ) ) && ( isalive( eTarget ) ) )
		{
			targetLoc = eTarget.origin + (0, 0, 32);
			self setTurretTargetVec( targetLoc );
			fRand = ( randomfloatrange( 2, 3 ) );
			self waittill_notify_or_timeout( "turret_rotate_stopped", fRand );

			/*-----------------------
			FIRE MAIN CANNON IF WITHIN **PLAYER** FOV (NO CHEAP SHOTS)
			-------------------------*/
			if ( (isdefined(eTarget)) && (eTarget == level.player) )
			{
				playerEye = level.player getEye();
				bInFOV = within_fov( playerEye, level.seaknight.angles + ( 0, -90, 0 ), self.origin, level.cosine[ "45" ]);
				if ( bInFOV )
				{
					if ( getdvar( "debug_airlift" ) == "1" )
						self thread print3Dthread( "firing at player", undefined, 3.5, 100 );
					if (!self.turretFiring)
						self thread vehicle_fire_main_cannon();		
				}
				else
				{
					if ( getdvar( "debug_airlift" ) == "1" )
						self notify ("stop_3dprint");
				}
				
			}
			if ( (isdefined(eTarget)) && (eTarget != level.player) )
			{
				if (!self.turretFiring)
					self thread vehicle_fire_main_cannon();					
			}

		}
	}
}

vehicle_get_target()
{
	eTarget = undefined;
	switch ( self.vehicletype )
	{
		case "zpu_antiair":
			self.defaultTargets = array_randomize( self.defaultTargets );
			eTarget = self.defaultTargets[0];
			break;
		case "bmp":
												//  getEnemyTarget( fRadius, iFOVcos, getAITargets, doSightTrace, getVehicleTargets, randomizeTargetArray, aExcluders )
			eTarget = maps\_helicopter_globals::getEnemyTarget( level.CannonRange, level.cosine[ "180" ], true, true, false, true );
			break;
	}
	if ( isdefined( eTarget ) )
		return eTarget;
}

vehicle_fire_main_cannon()
{
	self endon ("death");
	iFireTime = undefined;
	iBurstNumber = undefined;
			
	switch ( self.vehicletype )
	{
		case "zpu_antiair":
			iFireTime = weaponfiretime("bmp_turret");
			iBurstNumber = randomintrange(8, 15);
			break;
		case "bmp":
			iFireTime = weaponfiretime("bmp_turret");
			iBurstNumber = randomintrange(3, 8);
			break;
		default:
			assertmsg( "need to define a case statement for " + self.vehicletype );
	}

	assert( isdefined( iFireTime ) );
	self.turretFiring = true;
	i = 0;
	while (i < iBurstNumber)
	{
		i++;
		wait(iFireTime);
		self fireWeapon();
	}
	self.turretFiring = false;
}

vehicle_t72_think()
{
	self SetDeceleration(1);
	self thread maps\_vehicle::mgoff();
	self thread vehicle_turret_scan();
}

vehicle_damage_think()
{
	self endon( "death" );
	iPlayerProjectileHits = 0;
	bKilled = false;
	while ( true )
	{
		self waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName );
		wait ( 0.05 );
		damageType = vehicle_get_damage_type_and_attacker( type, damage, attacker, self.vehicletype );

		//player_missile
		//cobra_missile
		if ( self.script_team == "allies" )
		{
			if ( ( isdefined( attacker ) ) && ( isdefined( attacker.targetname ) ) && ( attacker.targetname == "seaknightPlayer" ) && ( isdefined( damage ) ) && ( damage > 150 ) )
				thread maps\_friendlyfire::missionFail();
		}
			
		switch ( self.vehicletype )
	    {
	    	case "mi17":
	    		if ( damageType == "cobra_missile" )
	    			bKilled = true;
	    			break;
	    }
	    
	    if ( bKilled == true )
	    	break;

	}
	
	self thread vehicle_death();

}


vehicle_death()
{
	self notify ( "death" );

}

vehicle_get_damage_type_and_attacker( type, damage, attacker, vehicletypeAttacked )
{
	if ( !isdefined( type ) )
		return "unknown";
	if ( !isdefined( attacker ) )
		return "unknown";	
	
	sAttacker = undefined;
	sDamage = undefined;

	/*-----------------------
	IS THE ATTACKER PLAYER OR A VEHICLE?
	-------------------------*/		
	if ( attacker == level.player )
		sAttacker = "player";
	else if ( ( isdefined ( attacker.classname ) ) && ( attacker.classname == "script_vehicle" ) )
	{
		switch ( attacker.vehicletype )
		{
			case "cobra":
				sAttacker = "cobra";
		}
	}
	
	/*-----------------------
	FIND OUT WHAT WEAPON USED
	-------------------------*/	
	type = tolower( type );
	switch( type )
	{
		case "mod_projectile":
		case "mod_projectile_splash":
			sDamage = "missile";
			break;
		case "mod_grenade":
		case "mod_grenade_splash":
			sDamage = "grenade";
			break;
		default:
			sDamage = undefined;
			break;
	}	

	/*-----------------------
	RETURN CONCATENATED STRING OF ATTACKER AND DAMAGE
	-------------------------*/		
	if ( !isdefined( sAttacker ) )
		return undefined;
	else if ( !isdefined( sDamage ) )
		return undefined;
	else
		return sAttacker + "_" + sDamage;
	
}

vehicle_cobra_attack_pattern_think( sStartNode )
{
	self endon( "death" );
	self notify( "starting_new_attack_pattern" );
	self endon( "starting_new_attack_pattern" );
	eStartNode = getent( sStartNode, "script_noteworthy" );
	assertex( isdefined( eStartNode ), "No start node with the script_noteworthy " + sStartNode +  " exists" );
	
	/*-----------------------
	SWITCH TO OTHER PATH
	-------------------------*/		
	self vehicle_detachfrompath(); 
	self thread vehicle_dynamicpath( eStartNode, false );
	eStartNode waittill( "trigger", vehicle );
}

vehicle_animated_seaknight_land( eNode, sFlagDepart, aFriendlies )
{
	eSeaknight = spawn( "script_model", eNode.origin + ( 0, 0, 100 ) );
	eSeaknight setmodel( "vehicle_ch46e" );
	eSeaknight.animname = "seaknight";
	eSeaknight assign_animtree();
	eSeaknight thread vehicle_seaknight_rotors();
	eNode anim_first_frame_solo( eSeaknight, "landing" );
	if ( isdefined( aFriendlies ) )
		eSeaknight thread vehicle_seaknight_unload( aFriendlies );
	wait(0.5);
	eOrgFx = spawn( "script_origin", eNode.origin );
	eSeaknight delaythread ( 19, ::vehicle_canned_seaknight_fx, eOrgFx, eNode );
	eNode anim_single_solo( eSeaknight, "landing" );
	eNode thread anim_loop_solo( eSeaknight, "idle", undefined, "stop_idle" );	
	eSeaknight notify ( "unload_ai" );
	eSeaknight waittill( "all_ai_unloaded" );
	
	if ( isdefined( sFlagDepart ) )
		flag_wait( sFlagDepart );
		
	wait(1);
	eNode notify( "stop_idle" );
	eNode thread anim_single_solo( eSeaknight, "take_off" );
	wait(1.5);
	eSeaknight notify( "taking_off" );
	eOrgFx delete();
	eSeaknight waittillmatch( "single anim", "end" );
	eSeaknight delete();

}

vehicle_seaknight_rotors()
{
	self endon( "death" );
	xanim = self getanim( "rotors" );
	length = getanimlength(xanim);
	
	while (true )
	{
		if (!isdefined( self ) )
			break;
		self setanim( xanim );
		wait length;
	}
}

vehicle_seaknight_fake_load( aFriendlies, eDeleteNode )
{
	array_thread( aFriendlies, ::vehicle_seaknight_fake_load_think, eDeleteNode );	
	while ( aFriendlies.size > 0 )
	{
		wait(.05);
		aFriendlies = array_removeDead( aFriendlies );
	}
}

vehicle_seaknight_fake_load_think( eDeleteNode )
{
	self disable_ai_color();
	self pushplayer( true );
	self setgoalnode( eDeleteNode );
	self setGoalRadius( eDeleteNode.radius );	
	self waittill ("goal");
	
	if ( isdefined( self.magic_bullet_shield ) )
		self stop_magic_bullet_shield();
	self delete();	
}


vehicle_seaknight_idle_and_load( aFriendlies )
{
	assertex( aFriendlies.size == 4, "Need to pass exactly 4 friendlies to this function. You passed " + aFriendlies.size );
	iLoadNumber = 0;
	for(i=0;i<aFriendlies.size;i++)
	{
		iLoadNumber++;
		aFriendlies[i] thread vehicle_seaknight_idle_and_load_think( iLoadNumber );
	}
}

vehicle_seaknight_idle_and_load_think( iAnimNumber )
{
	self endon( "death" );
	sAnimUnload = "ch46_unload_" + iAnimNumber;
	sAnimLoad = "ch46_load_" + iAnimNumber;

	/*-----------------------
	HIDE WHILE DOING UNLOAD
	-------------------------*/		
	self hide();
	self setcontents(0);
	self.ignoreme = true;
	self.grenadeawareness = 0;
	self setthreatbiasgroup ( "oblivious" );
	level.seaknight anim_generic( self, sAnimUnload, "tag_detach" );
	
	/*-----------------------
	IDLE IN POSITION OUTSIDE SEAKNIGHT
	-------------------------*/		
	level.seaknight waittill ( "show_loaders" );
	self show();
	self thread anim_generic_loop( self, "ch46_unload_idle", undefined, "stop_ch46_idle" );

	/*-----------------------
	LOAD INTO SEAKNIGHT AND DELETE
	-------------------------*/	
	level.seaknight waittill ( "load" );
		
	self notify ( "stop_ch46_idle" );
	level.seaknight anim_generic( self, sAnimLoad, "tag_detach" );
	
	if ( isdefined( self.magic_bullet_shield ) )
		self stop_magic_bullet_shield();
	self delete();		
}

seaknight_crewchief_think()
{
	self endon( "death" );
	self endon( "stop_default_behavior" );
	
	/*-----------------------
	CREWCHIEF IDLE
	-------------------------*/	
	self gun_remove();
	self linkto( level.seaknight );
	self thread anim_loop_solo( self, "crewchief_idle", "tag_detach", "stop_idle_crewchief", level.seaknight );	
	
	level.seaknight waittill ( "unload_ai" );

	/*-----------------------
	CREWCHIEF WAVE OUT ANIM
	-------------------------*/		
	self notify ( "stop_idle_crewchief" );
	self thread anim_loop_solo( self, "crewchief_getout", "tag_detach", "stop_idle_crewchief", level.seaknight );	
	
	level.seaknight waittill ( "all_ai_unloaded" );

	/*-----------------------
	CREWCHIEF IDLE
	-------------------------*/		
	self notify ( "stop_idle_crewchief" );
	self thread anim_loop_solo( self, "crewchief_idle", "tag_detach", "stop_idle_crewchief", level.seaknight );	
	
	level.crewchief waittill ( "player_returning_to_seaknight");
	/*-----------------------
	CREWCHIEF WAVES IN WHILE PLAYER IS NEAR REAR DOOR
	-------------------------*/
	iAnim = 1;
	while ( distancesquared( level.player.origin, level.crewchief.origin ) > level.crewchiefRangeSquared )
	{
		sAnimName = undefined;
		switch( iAnim )
		{
			case 1:
				sAnimName = "crewchief_getin_lookback";
				iAnim++;
				break;
			case 2:
				sAnimName = "crewchief_getin_quick";
				iAnim++;
				break;
			case 3:
				sAnimName = "crewchief_getin";
				iAnim = 1;
				break;
		}
		level.crewchief notify ( "stop_idle_crewchief" );
		level.crewchief thread anim_loop_solo( level.crewchief, sAnimName, "tag_detach", "stop_idle_crewchief", level.seaknight );	
		level.crewchief waittillmatch ( "looping anim", "end" );
	
		self notify ( "stop_idle_crewchief" );
		self thread anim_loop_solo( self, "crewchief_idle", "tag_detach", "stop_idle_crewchief", level.seaknight );	
		wait( randomfloatrange( 2, 5.5) );
	}

//	level.seaknight waittill ( "load" );
//	/*-----------------------
//	CREWCHIEF WAVE IN ANIM
//	-------------------------*/	
//	self notify ( "stop_idle_crewchief" );
//	self thread anim_loop_solo( self, "crewchief_getin", "tag_detach", "stop_idle_crewchief", level.seaknight );
//	
//	wait(9);
//	
//	/*-----------------------
//	CREWCHIEF IDLE
//	-------------------------*/		
//	self notify ( "stop_idle_crewchief" );
//	self thread anim_loop_solo( self, "crewchief_idle", "tag_detach", "stop_idle_crewchief", level.seaknight );	

}



vehicle_seaknight_unload( aFriendlies, eCrewchief )
{
	//self ==> the seaknight vehicle
	self endon( "death" );
	
	assertex( aFriendlies.size == 4, "Need 4 AI for seaknight unload, you passed " + aFriendlies.size );

	if ( isdefined( eCrewchief ) )
		eCrewchief thread seaknight_crewchief_think();
	
	iAnimNumber = 1;
	for(i=0;i<aFriendlies.size;i++)
	{
		sAnim = "ch46_unload_" + iAnimNumber;
		iAnimNumber++;
		aFriendlies[i] thread vehicle_seaknight_unload_ai_think( sAnim, self );
	}

	self waittill( "unload_ai" );
	
	if ( self == level.seaknight )
		self thread maps\airlift_anim::seaknight_open_doors();
	/*-----------------------
	CHECK TO SEE WHEN ALL AI UNLOADED
	-------------------------*/		
	aUnloadedAI = aFriendlies;
	while( aUnloadedAI.size > 0 )
	{
		wait( 0.05 );
		for(i=0;i<aUnloadedAI.size;i++)
		{
			if ( isdefined( aUnloadedAI[i].unloaded ) )
			{
				aUnloadedAI[i].unloaded = undefined;
				aUnloadedAI = array_remove( aUnloadedAI, aUnloadedAI[i] );
			}
		}
	} 
	self notify( "all_ai_unloaded" );
	println( "all ai unloaded" );
}

vehicle_seaknight_unload_ai_think( sAnim, eSeaknight )
{
	self endon( "death" );
	self allowedstances("crouch");
	//self setthreatbiasgroup ( "oblivious" );
	sTag = undefined;
	if ( eSeaknight == level.seaknight )
		sTag = "tag_door_rear";
	else
		sTag = "tag_detach";
	
	self force_teleport( eSeaknight gettagorigin( sTag ),eSeaknight gettagangles( sTag ) );
	eSeaknight anim_generic_first_frame( self, sAnim, "tag_detach" );
	self linkto( eSeaknight, sTag );
	
	eSeaknight waittill ( "unload_ai" );
	//self unlink();
	self show();
	eSeaknight anim_generic( self, sAnim, "tag_detach" );
	self unlink();
	self setgoalpos( self.origin );
	self notify ( "unloaded" );
	self.unloaded = true;
	self waittill( "stop_ch46_idle" );
	self allowedstances("crouch", "stand", "prone" );
	//self setthreatbiasgroup ( "allies" );
}

vehicle_canned_seaknight_fx( eOrgFx, eNode )
{
	self endon( "death" );
	self endon( "taking_off" );
	
	offset = undefined;
	
	if ( eNode.targetname == "seaknight_plaza_alt_landing2" )
		offset = ( -240, 0, 0 );
	else
		offset = ( 0, 0, 0 );

	while ( isdefined( eOrgFx ) )
	{
		playfx ( getfx( "heli_dust_default" ), eOrgFx.origin + offset );	
		wait( 0.1 );
	}
}

/****************************************************************************
    UTILITIES / HOUSEKEEPING
****************************************************************************/ 
AA_Utility()
{
	
}


player_death()
{
	level.player waittill( "death" );
	if ( !level.onMark19 )
		return;

	/*-----------------------
	MAKE SURE PLAYER STAYS ATTACHED
	-------------------------*/		
	level.seaknight lerp_player_view_to_tag_oldstyle( "tag_player", 0.05, 0.5, 90, 90, 90, 90 );
}	

rescue_timer( iSeconds )
{
	// destroy any previous timer just in case
	kill_timer();
	level endon( "pilot_put_down_in_seaknight" );
	level endon ( "kill_timer" );

	/*-----------------------
	TIMER SETUP
	-------------------------*/		
	level.hudTimerIndex = 20;
	level.timer = maps\_hud_util::get_countdown_hud();
	level.timer SetPulseFX( 30, 900000, 700 );//something, decay start, decay duration
	level.timer.label = &"AIRLIFT_TIME_REMAINING";
	level.timer settenthstimer( iSeconds );

	/*-----------------------
	TIMER EXPIRED
	-------------------------*/	
	thread timer_tick();
	wait ( iSeconds );
	level.timer destroy();
	level thread mission_failed_out_of_time();
}

timer_tick()
{
	level endon ( "kill_timer" );
	while ( true )
	{
		wait(1);
		level.player thread play_sound_on_entity ( "countdown_beep" );
	}
}

mission_failed_out_of_time()
{
	level.player endon ( "death" );
	level endon ( "kill_timer" );
	level notify ( "mission failed" );	
	musicstop(1);
	setDvar("ui_deadquote", &"AIRLIFT_RAN_OUT_OF_TIME" );
	maps\_utility::missionFailedWrapper();	
	level notify ( "kill_timer" );
}

kill_timer()	
{
	level notify ( "kill_timer" );
	if (isdefined (level.timer))
		level.timer destroy();		
}

nuke_trees()
{
	fExplosionDuration = 2.5;
	
	/*-----------------------
	GET ALL NUKE TREES IN THE LEVEL
	-------------------------*/	
	nuke_trees = getentarray( "nuke_trees", "targetname" );
	nuke_origin = getent( "nuke_origin", "targetname" );

	/*-----------------------
	GET ALL MOSQUE EXPLODER TRIGS
	-------------------------*/	
	nuke_exploder_trigs = getentarray( "nuke_exploder", "targetname" );
	//get the exploder associated with this trigger for fx
	for(i=0;i<level.fxTowerExploders.size;i++)
	{
		org = level.fxTowerExploders[i].v[ "origin" ];
		closet_trigger = getclosest( org, nuke_exploder_trigs );
		assert(isdefined(closet_trigger));
		closet_trigger.fxExploderNum = level.fxTowerExploders[i].v[ "exploder" ];
		assert(isdefined(closet_trigger.fxExploderNum));
		
	}

	/*-----------------------
	FIND THE FURTHEST TREE/EXPLODER AWAY TO GET THE MULTIPLIER
	-------------------------*/	
	tempArray = [];
	tempArray = array_merge( nuke_trees, nuke_exploder_trigs );
	eFurthestTree = getFarthest( nuke_origin.origin, tempArray );
	maxDist = distancesquared( eFurthestTree.origin, nuke_origin.origin );
	fMultiplier = fExplosionDuration/maxDist;

	/*-----------------------
	GET VECTOR TO ROTATE EACH TREE AND ASSIGN DELAY
	-------------------------*/	
	for(i=0;i<nuke_trees.size;i++)
	{
		tree = nuke_trees[i];
		dist = distancesquared( tree.origin, nuke_origin.origin );
		tree.fDelay = dist * fMultiplier;
		//new_angles = VectorToAngles( tree.origin - ( nuke_origin.origin ) );
		normalvec = vectorNormalize( tree.origin - ( nuke_origin.origin ) );
		new_angles = VectorToAngles( normalvec );
		tree.dummy = spawn( "script_origin", tree.origin );
		tree.dummy.angles = new_angles;
		tree linkto( tree.dummy );
	}

	/*-----------------------
	GET DELAY FOR NUKE EXPLODERS
	-------------------------*/	
	for(i=0;i<nuke_exploder_trigs.size;i++)
	{
		trig = nuke_exploder_trigs[i];
		dist = distancesquared( trig.origin, nuke_origin.origin );
		trig.fDelay = dist * fMultiplier;
	}
	
	flag_wait( "nuke_flattens_trees" );
	array_thread( nuke_trees, ::nuke_tree_fall );
	array_thread( nuke_exploder_trigs, ::nuke_exploders_think );
}

nuke_tree_fall()
{
	wait( self.fDelay );
	fRotateTime = 2;
	ang = self.dummy.angles;
	ang += ( 80, 0, 0);
	self.dummy rotateto(ang, fRotateTime, fRotateTime/2, fRotateTime/2);
}

nuke_exploders_think()
{
	//ugly hack to trigger placed mosque fx at same time as generic mosque exploder
	iEffectExploderNum = self.fxExploderNum;
	assert(isdefined(iEffectExploderNum));
	
	
	wait( self.fDelay );
	wait(1);
	
	//trigger the mosque
	self notify( "trigger" );
	exploder(iEffectExploderNum);
}

carrying_hint()
{
	flag_wait( "pilot_taken_from_cockpit" );
	level endon( "obj_return_pilot_complete" );
	level thread player_mashing_buttons();
	level thread carrying_hint_cleanup();
	wait(3);
	displayingCarryHint = false;
	while ( !flag( "obj_return_pilot_complete" ) )
	{
		level waittill( "player_mashing_buttons" );
		
		if ( !displayingCarryHint )
		{
			displayingCarryHint = true;
			thread hint(&"AIRLIFT_HINT_CARRYING_PILOT", 3);
			wait( 5 );
			displayingCarryHint = false;
		}
	
	}	
}

carrying_hint_cleanup()
{
	flag_wait( "obj_return_pilot_complete" );
	thread hint_fade();
}

player_mashing_buttons()
{
	level endon( "obj_return_pilot_complete" );
	while ( !flag( "obj_return_pilot_complete" ) )
	{
		if ( ( level.player attackButtonPressed() ) 
			|| ( level.player usebuttonpressed() ) 
			|| ( level.player buttonPressed( "BUTTON_A" ) ) 
			|| ( level.player buttonPressed( "BUTTON_B" ) )
			|| ( level.player buttonPressed( "BUTTON_Y" ) ) )
			level notify( "player_mashing_buttons" );
		wait( 0.05 );

	}
}

fx_management()
{
	/*-----------------------
	CREATE ARRAYS OF FX FOR THE LEVEL
	-------------------------*/	
	level.fxIntro = [];
	level.fxPlazatown = [];
	level.fxSmoketown = [];
	level.fxCobrastreets = [];
	level.fxTowerExploders = getfxarraybyID( "building_collapse_nuke" );
	fx_volume_intro = getent( "fx_volume_intro", "targetname" );
	fx_volume_plazatown = getent( "fx_volume_plazatown", "targetname" );
	fx_volume_smoketown = getent( "fx_volume_smoketown", "targetname" );
	fx_volume_cobrastreets = getent( "fx_volume_cobrastreets", "targetname" );
	dummy = spawn( "script_origin", ( 0, 0, 0 ) );
	for(i=0;i<level.createfxent.size;i++)
	{
		EntFx = level.createfxent[i];
		dummy.origin = EntFx.v["origin"];
		if ( dummy istouching( fx_volume_intro ) )
		{
			level.fxIntro[ level.fxIntro.size ] = EntFx;
			continue;
		}
		if ( dummy istouching( fx_volume_plazatown ) )
		{
			level.fxPlazatown[ level.fxPlazatown.size ] = EntFx;
			continue;
		}
		if ( dummy istouching( fx_volume_smoketown ) )
		{
			level.fxSmoketown[ level.fxSmoketown.size ] = EntFx;
			continue;
		}
		if ( dummy istouching( fx_volume_cobrastreets ) )
		{
			level.fxCobrastreets[ level.fxCobrastreets.size ] = EntFx;
			continue;
		}
	}
	dummy delete();

}

destructibles_think()
{
	switch ( self.destructible_type )
	{
		case "vehicle_tanker_truck":
			self thread tanker_gas_station_think();
			self waittill ( "destroyed" );
			earthquake( 0.4, 2, self.origin, 8000);
			dummy = spawn( "script_origin", self.origin + ( 0, 0, 110 ) );
			dummy.angles = self.angles;
			fx = spawnFx( getFx( "tanker_fire" ), dummy.origin );
			triggerFx( fx );
			flag_wait( "cobra_hit" );
			fx delete();
			//destroy the gas station regardless of which tanker
			if ( ( isdefined( level.gasStationTrigger ) ) && ( isdefined( level.seaknight ) ) )
				level.gasStationTrigger notify ( "damage", 1000, level.seaknight, undefined, undefined, "mod_projectile" );	
			break;
	}
	
}



badplace_volume_think()
{
	assert(isdefined(self.script_noteworthy));
	if ( ( self.script_noteworthy == "axis" ) || ( self.script_noteworthy == "allies" ) )
		badplace_brush( self getentitynumber(), 0, self, self.script_noteworthy );
	else
		assertmsg( "badplace volumes need a script_noteworthy of either axis or allies" );
}

rpg_fake( sTargetname )
{
	aRpgSources = getentarray( sTargetname, "targetname" );
	assert(isdefined(aRpgSources));
	assert( aRpgSources.size > 0 );
	for(i=0;i<aRpgSources.size;i++)
	{
		assert( isdefined(aRpgSources[i].target) );
		eTarget = getent( aRpgSources[i].target, "targetname" );
		magicbullet( "rpg", aRpgSources[i].origin, eTarget.origin );
		wait( randomfloatrange(1,2.5));
	}
}

disable_color_trigs()
{
	array_thread(level.aColornodeTriggers, ::trigger_off);
}

waittill_trigger_seaknight()
{
	trigger_seaknight = getent( "trigger_seaknight", "targetname" );
	trigger_seaknight waittill( "trigger" );	
}

waittill_trigger_seaknight_gun()
{
	trigger_seaknight_gun = getent( "trigger_seaknight_gun", "targetname" );
	//trigger_seaknight_gun.useable = true;
	//trigger_seaknight_gun sethintstring( &"SCRIPT_PLATFORM_HINT_MOUNT_MARK19" );
	trigger_seaknight_gun waittill( "trigger" );
	//trigger_seaknight_gun.useable = false;
}

initDifficulty()
{
	level.InvulnerableTimeSeaknight = undefined;
	level.InvulnerableTimeDefault = getdvar( "player_deathinvulnerabletime" );
	assert(isdefined( level.InvulnerableTimeDefault ));
	
	/*-----------------------
	SETUP VARIABLES
	-------------------------*/		

	switch( level.gameSkill )
	{
		case 0: //easy
			level.InvulnerableTimeSeaknight = level.InvulnerableTimeDefault;
			break;
		case 1://regular
			level.InvulnerableTimeSeaknight = level.InvulnerableTimeDefault;
			break;
		case 2://hardened
			level.InvulnerableTimeSeaknight = level.InvulnerableTimeDefault;
			break;
		case 3://veteran
			level.InvulnerableTimeSeaknight = "600";
			break;	
	}
	
	flag_set( "difficulty_initialized" );
}

player_invulnerable_time_tweak()
{
	setsaveddvar( "player_deathinvulnerabletime", level.InvulnerableTimeSeaknight );
	
	level waittill( "player_off_turret" );
	
	setsaveddvar( "player_deathinvulnerabletime", level.InvulnerableTimeDefault );

}


spawn_trigger_dummy( sDummyTargetname )
{
	//triggers a spawner trig through convoluted means 
	//since I can't use a unique targetname or script_noteworthy
	ent = getent( sDummyTargetname, "targetname" );
	assert(isdefined(ent));
	assert(isdefined(ent.script_linkTo));
	trig = getent( ent.script_linkTo, "script_linkname" );
	assert(isdefined(trig));
	trig notify( "trigger", level.player );
}

deleteWeapons()
{
	if (isdefined(self))
		self delete();
}

AI_player_seek()
{
	self endon ("death");
	if ( !isdefined( self ) )
		return;
	newGoalRadius = distance( self.origin, level.player.origin );
	for(;;)
	{
		wait 2;
		self.goalradius = newGoalRadius;
			
		self setgoalentity ( level.player );
		newGoalRadius -= 175;
		if ( newGoalRadius < 512 )
		{
			newGoalRadius = 512;
			return;
		}
	}
}

AI_fastrope_and_die()
{
	self endon( "death" );
	self.ignoreme = true;
	//self waittill( "jumpedout" );
	//self waittill( "gotime" );
	while( !isdefined( self.ridingvehicle ) )
		wait( 0.05 );
	while( isdefined( self.ridingvehicle ) )
		wait( 0.05 );

	self delete();
}

AI_low_engage_dist_think()
{
	self endon( "death" );
	defaultDist = self.pathEnemyFightDist;
	defaultLookAhead = self.pathenemylookahead;
	self.goalradius = 8;
	self.pathEnemyFightDist = 0;
	self.pathenemylookahead = 0;
	self.ignoresuppression = true;
	
	
	self waittill( "goal" );
	self.pathEnemyFightDist = defaultDist;
	self.pathenemylookahead = defaultLookAhead;
	self.ignoresuppression = false;
	
}

getDamageType( type )
{
	//returns a simple damage type: melee, bullet, splash, or unknown
	if ( !isdefined( type ) )
		return "unknown";
	
	type = tolower( type );
	switch( type )
	{
		case "mod_explosive":
		case "mod_explosive_splash":
			return "c4";
		case "mod_projectile":
		case "mod_projectile_splash":
			return "rocket";
		case "mod_grenade":
		case "mod_grenade_splash":
			return "grenade";
		case "unknown":
			return "unknown";
		default:
			return "unknown";
	}
}

initPrecache()
{
	preCacheModel( "projectile_cbu97_clusterbomb" );
	
	precacheShader( "black" );
	precacheShader( "stance_carry" );
	
	precacheItem( "cobra_FFAR_airlift" );
	precacheItem( "cobra_FFAR_airlift_nofx" );
	precacheItem( "hunted_crash_missile" );
	precacheItem( "rpg_player" );
	precacheItem( "at4" );
	
	precacheModel( "weapon_AT4" );
	precacheModel( "viewhands_player_usmc" );

	precacheModel( "weapon_saw_MG_Setup" );
	precacheModel( "weapon_rpd_MG_Setup" );
	precacheModel( "vehicle_80s_sedan1_tankcrush_destroyed" );
	
	precachestring( &"AIRLIFT_OBJ_PLAZA_CLEAR" );
	precachestring( &"AIRLIFT_OBJ_EXTRACT_TEAM" );
	precachestring( &"AIRLIFT_OBJ_EXTRACT_TO_LZ" );
	precachestring( &"AIRLIFT_OBJ_RESCUE_PILOT" );
	precachestring( &"AIRLIFT_OBJ_RETURN_PILOT" );
	precachestring( &"SCRIPT_PLATFORM_AIRLIFT_HINT_GETPILOT" );
	precachestring( &"AIRLIFT_TIME_REMAINING" );
	precachestring( &"AIRLIFT_RAN_OUT_OF_TIME" );
	
	
	
	precachestring( &"AIRLIFT_HINT_CARRYING_PILOT" );
	
	precachestring( &"SCRIPT_PLATFORM_AIRLIFT_HINT_PICKUP_PILOT" );
	precachestring( &"SCRIPT_PLATFORM_HINT_PILOT_PUTDOWN" );
	
	precacheShader( "white" );
	precacheShader( "black" );
	precacheShader( "hud_temperature_gauge" );
}

seaknight_player_think( sStartPoint )
{
	eStartPath = undefined;
	eStartNode = undefined;
	switch( sStartPoint )
	{
		case "default":
			break;
		case "plazafly":
			eStartPath = getent( "flightPathstart_plazafly", "targetname" );
			break;
		case "plaza":
			eStartPath = getent( "flightPathstart_plaza", "targetname" );
			break;
		case "smoketown":
			eStartPath = getent( "flightPathstart_smoketown", "targetname" );
			break;
		case "cobraflight":
			eStartNode = getent( "player_start_cobraflight", "targetname" );
			eStartPath = getent( "flightPathstart_cobraflight", "targetname" );
			break;
		case "cobrastreets":
			eStartPath = getent( "flightPathstart_cobrastreets", "targetname" );
			break;
		case "nuke":
			eStartNode = getnode( "player_start_nuke", "targetname" );
			eStartPath = getent( "flightPathstart_cobrastreets", "targetname" );
			break;
	}
	
	if ( sStartPoint != "default" )
	{
		eSeaknightSpawner = getvehiclespawner( "seaknightPlayer" );
		eSeaknightSpawner.origin = eStartPath.origin;
		eSeaknightSpawner.angles = eStartPath.angles;
	}
	
	level.seaknight = spawn_vehicle_from_targetname( "seaknightPlayer" );
	thread maps\_vehicle::gopath( level.seaknight );
	level.seaknight seaknight_turret_think();
	if ( sStartPoint != "default" )
	{
		level.seaknight vehicle_detachfrompath(); 
		level.seaknight thread vehicle_dynamicpath( eStartPath, false ); 	
	}

	/*-----------------------
	SEAKNIGHT SETUP
	-------------------------*/	
	level.seaknight maps\airlift_anim::seaknight_turret_anim_init();
	level.seaknight setmaxpitchroll( 5, 10 );
	level.seaknight sethoverparams( 32, 10, 3 );
	level.seaknight maps\_vehicle::godon();
	level.seaknight.animname = "seaknight";
	level.seaknight assign_animtree();
	
	if ( isdefined( eStartNode ) )
	{
		thread seaknight_player_dismount_gun();
		level waittill( "player_dismounted_from_gun" );
		level.player EnableInvulnerability();
		level.player setorigin ( eStartNode.origin );
		level.player setplayerangles ( eStartNode.angles );
		level.player DisableInvulnerability();
	}
	
	flag_set( "seaknight_set_up" );
}

exploder_trigs_mark19_think()
{
	self endon ( "exploder_detonated" );
	iExploderNum = self.script_noteworthy;
	assertex( isdefined( self.script_noteworthy, "exploder_trigs_mark19 at position " + self.origin + " needs a script_noteworthy with the number of the exploder to trigger" ) );
	assertex( isdefined( level.scr_sound[ "exploder" ][ iExploderNum ], "Need to define a sound for this exploder number: " + iExploderNum ) );
	bExploded = false;
	sMessage = undefined;
	if ( ( isdefined( self.script_parameters ) ) && ( self.script_parameters == "gas_station" ) )
		self thread gas_station_trigger_think();
	while ( bExploded == false )
	{
		self waittill ( "damage", amount, attacker, direction_vec, point, type );	
		if ( !isdefined( attacker ) )
			continue;
		if ( !isdefined( amount ) )
			continue;
		if ( !isdefined( type ) )
			continue;
		
		type = tolower( type );
		if ( ( type == "mod_projectile" ) || ( type == "mod_projectile_splash" ) ) 
		{
			if ( ( isdefined( attacker.targetname ) ) && ( attacker.targetname == "seaknightPlayer" ) && ( amount > 150 ) )
			{
				iExploderNum = string( iExploderNum );
				bExploded = true;
				sMessage = "exploder_" + iExploderNum + "_detonated";
				level notify( sMessage );
				exploder( iExploderNum );
				thread play_sound_in_space( level.scr_sound[ "exploder" ][ iExploderNum ], self.origin );
				self notify( "exploder_detonated" );	
			}
		}
	}
}

gas_station_trigger_think()
{
	level.gasStationTrigger = self;
	self waittill( "exploder_detonated" );
	level notify( "destroy_gas_station_tanker" );
	
}

tanker_gas_station_think()
{
	exploder_gas_startion = getent( "exploder_gas_startion", "targetname" );
	assert(isdefined(exploder_gas_startion));
	if ( distance( self.origin, exploder_gas_startion.origin ) < 1000 )
	{
		level waittill( "destroy_gas_station_tanker" );
		self notify( "damage", 99999, level.seaknight, (4336.64, 676, -2670), (-21, -1600, 245) , "MOD_PROJECTILE", "", undefined );
		wait(0.05);
		self notify( "damage", 99999, level.seaknight, (4336.64, 676, -2670), (-21, -1600, 245) , "MOD_PROJECTILE", "", undefined );
	}
}


exploder_statue()
{
	statue = getent( "statue", "targetname" );
	statue.animname = "statue";
	statue assign_animtree();

	
	level waittill( "exploder_100_detonated" );
	playfx ( getfx("statue_smoke"), statue.origin);
	thread play_sound_in_space( level.scr_sound[ "statue_fall" ], statue.origin );

	xanim = statue getanim( "statue_collapse" );
	length = getanimlength(xanim);
	statue setanim( xanim );
	wait (2);

	thread play_sound_in_space( level.scr_sound[ "statue_impact" ], statue.origin );
}


exploder_statue_old()
{
	statue = getent( "statue", "targetname" );
	statue_fallen = getent( "statue_fallen", "targetname" );
	org_fall = statue_fallen.origin;
	ang_fall = statue_fallen.angles;
	statue_fall_fx = getent( "statue_fall_fx", "targetname" );
	statue_fallen delete();
	
	level waittill( "exploder_100_detonated" );
	playfx ( getfx("statue_smoke"), statue.origin);
	thread play_sound_in_space( level.scr_sound[ "statue_fall" ], org_fall );
	
	fRotateTime = 2;
	fMoveTime = 2;
	
	statue moveto( org_fall, fMoveTime, fMoveTime );
	statue rotateto( ang_fall, fRotateTime, fRotateTime );
	
	wait( fMoveTime );
	thread play_sound_in_space( level.scr_sound[ "statue_impact" ], org_fall );
}

seaknight_turret_test()
{
	while( !isdefined( level.cobraWingman ) )
		wait (0.05);
	
	eTarget = level.cobraWingman;
	
	iFireTime = weaponfiretime("seaknight_mark19");
	while ( true )
	{
		targetLoc = eTarget.origin;
		self setTurretTargetVec(targetLoc);
		fRand = ( randomfloatrange(2, 3));
		self waittill_notify_or_timeout( "turret_rotate_stopped", fRand );
		self fireWeapon();
		wait( 2 );
	}


}

seaknight_turret_think()
{
	// self == > the player seaknight
	level.playerInSeaknight = true;
	
	/*-----------------------
	SETUP TURRET
	-------------------------*/	
	sTag = "tag_player";	
	orgOffset = ( 15, 0, -10 );
	angOffset = ( 0, 0, 0 );
	level.TempTurretOrg = spawn( "script_origin", ( 0, 0, 0 ) );
	level.TempTurretOrg.angles = self.angles;
	level.TempTurretOrg linkto( self, sTag, orgOffset, angOffset );
	
	seaknight_player_mount_gun();
}

seaknight_fire_turret()
{
	level endon( "player_off_turret" );
	
	iFireTime = weaponfiretime( "seaknight_mark19" );
	while ( true )
	{
		self waittill( "turret_fire" );
		self fireWeapon();
		self thread maps\airlift_anim::seaknight_turret_anim();
		earthquake( 0.25, .13, level.player.origin, 200);
		if (level.turretOverheat == true)
		{
			level.turret_heat_status += int(level.turret_heat_max / level.turret_heat_maxshots);
			level overheat_overheated( self );
			level thread overheat_hud_update();
		}
	}
}

overheat_enable()
{
	level.turret_heat_status = 1;
	level.turretOverheat = true;
	level thread overheat_hud();
}

overheat_disable()
{
	level.turretOverheat = false;
	level notify ("disable_overheat");
	level.savehere = undefined;
	
	waittillframeend;
	
	if (isdefined(level.overheat_bg))
		level.overheat_bg destroy();
	if (isdefined(level.overheat_status))
		level.overheat_status destroy();
	if (isdefined(level.overheat_status2))
		level.overheat_status2 destroy();
	if (isdefined(level.overheat_flashing))
		level.overheat_flashing destroy();
}

overheat_overheated( eVehicle )
{
	level endon ("disable_overheat");
	if (level.turret_heat_status <= level.turret_heat_max)
		return;
	
	level.savehere = false;
	level.player thread play_sound_on_entity ("smokegrenade_explode_default");
	eVehicle thread overheat_fx();
	
	level.overheat_flashing.alpha = 1;
	level.overheat_status.alpha = 0;
	level.overheat_status2.alpha = 0;
	
	level notify ("stop_overheat_drain");
	level.turret_heat_status = level.turret_heat_max;
	thread overheat_hud_update();
	
	for (i=0;i<4;i++)
	{
		level.overheat_flashing fadeovertime(0.5);
		level.overheat_flashing.alpha = 0.5;
		wait 0.5;
		level.overheat_flashing fadeovertime(0.5);
		level.overheat_flashing.alpha = 1.0;
	}
	level.overheat_flashing fadeovertime(0.5);
	level.overheat_flashing.alpha = 0.0;
	level.overheat_status.alpha = 1;
	wait 0.5;
	
	thread overheat_hud_drain();
	
	wait 2;
	level.savehere = undefined;
	eVehicle notify("stop_overheatfx");
}

overheat_fx()
{
	level endon ("disable_overheat");
	self endon ("stop_overheatfx");
	for (;;)
	{
		playfxOnTag( getfx( "turret_overheat_haze" ), self, "tag_flash");
		playfxOnTag( getfx( "turret_overheat_smoke" ), self, "tag_flash");
		wait .05;
	}
}

overheat_hud_update()
{
	level endon ("disable_overheat");
	level notify ("stop_overheat_drain");
	
	if ( (level.turret_heat_status > 1) && ( isdefined( level.overheat_status.alpha ) ) )
		level.overheat_status.alpha = 1;
	
	if (isdefined(level.overheat_status2))
	{
		level.overheat_status2.alpha = 1;
		level.overheat_status2 setShader("white", 10, int(level.turret_heat_status));
		level.overheat_status scaleovertime( 0.05, 10, int(level.turret_heat_status));
	}
	
	//set color of bar
	overheat_setColor(level.turret_heat_status);
	
	wait 0.05;
	if (isdefined(level.overheat_status2))
		level.overheat_status2.alpha = 0;
	if (level.turret_heat_status < level.turret_heat_max)
		thread overheat_hud_drain();
}

overheat_setColor(value, fadeTime)
{
	level endon ("disable_overheat");
	
	//define what colors to use
	color_cold = [];
	color_cold[0] = 1.0;
	color_cold[1] = 0.9;
	color_cold[2] = 0.0;
	color_warm = [];
	color_warm[0] = 1.0;
	color_warm[1] = 0.5;
	color_warm[2] = 0.0;
	color_hot = [];
	color_hot[0] = 0.9;
	color_hot[1] = 0.16;
	color_hot[2] = 0.0;
	
	//default color
	SetValue = [];
	SetValue[0] = color_cold[0];
	SetValue[1] = color_cold[1];
	SetValue[2] = color_cold[2];
	
	//define where the non blend points are
	cold = 0;
	warm = (level.turret_heat_max / 2);
	hot = level.turret_heat_max;
	
	iPercentage = undefined;
	difference = undefined;
	increment = undefined;
	
	if ( (value > cold) && (value <= warm) )
	{
		iPercentage = int(value * (100 / warm));
		for ( colorIndex = 0 ; colorIndex < SetValue.size ; colorIndex++ )
		{
			difference = (color_warm[colorIndex] - color_cold[colorIndex]);
			increment = (difference / 100);
			SetValue[colorIndex] = color_cold[colorIndex] + (increment * iPercentage);
		}
	}
	else if ( (value > warm) && (value <= hot) )
	{
		iPercentage = int( (value - warm) * (100 / (hot - warm) ) );
		for ( colorIndex = 0 ; colorIndex < SetValue.size ; colorIndex++ )
		{
			difference = (color_hot[colorIndex] - color_warm[colorIndex]);
			increment = (difference / 100);
			SetValue[colorIndex] = color_warm[colorIndex] + (increment * iPercentage);
		}
	}
	
	if (isdefined(fadeTime))
		level.overheat_status fadeOverTime(fadeTime);
	
	level.overheat_status.color = (SetValue[0], SetValue[1], SetValue[2]);
	level.overheat_status2.color = (SetValue[0], SetValue[1], SetValue[2]);
}

overheat_hud_drain()
{
	level endon ("disable_overheat");
	level endon ("stop_overheat_drain");
	
	waitTime = 1.0;
	for (;;)
	{
		if ( (level.turret_heat_status > 1) && ( isdefined( level.overheat_status.alpha ) ) )
			level.overheat_status.alpha = 1;
		
		value = level.turret_heat_status - level.turret_cooldownrate;
		thread overheat_status_rampdown(value, waitTime);
		if (value < 1)
			value = 1;
		level.overheat_status scaleovertime( waitTime, 10, int(value) );
		overheat_setColor(level.turret_heat_status, waitTime);
		wait waitTime;
		
		if (level.turret_heat_status <= 1)
			level.overheat_status.alpha = 0;
	}
}

overheat_status_rampdown(targetvalue, time)
{
	level endon ("disable_overheat");
	level endon ("stop_overheat_drain");
	
	frames = (20 * time);
	difference = (level.turret_heat_status - targetvalue);
	frame_difference = (difference / frames);
	
	for (i=0;i<frames;i++)
	{
		level.turret_heat_status -= frame_difference;
		if (level.turret_heat_status < 1)
		{
			level.turret_heat_status = 1;
			return;
		}
		wait 0.05;
	}
}

overheat_hud()
{
	level endon ("disable_overheat");
	if (!isdefined(level.overheat_bg))
	{
		level.overheat_bg = newhudelem();
		level.overheat_bg.alignX = "right";
		level.overheat_bg.alignY = "bottom";
		level.overheat_bg.horzAlign = "right";
		level.overheat_bg.vertAlign = "bottom";
		level.overheat_bg.x = 2;
		level.overheat_bg.y = -120;
		level.overheat_bg setShader("hud_temperature_gauge", 35, 150);
		level.overheat_bg.sort = 4;
	}
	
	barX = -10;
	barY = -152;
	
	//status bar
	if (!isdefined(level.overheat_status))
	{
		level.overheat_status = newhudelem();
		level.overheat_status.alignX = "right";
		level.overheat_status.alignY = "bottom";
		level.overheat_status.horzAlign = "right";
		level.overheat_status.vertAlign = "bottom";
		level.overheat_status.x = barX;
		level.overheat_status.y = barY;
		level.overheat_status setShader("white", 10, 0);
		level.overheat_status.color = (1,.9,0);
		level.overheat_status.alpha = 0;
		level.overheat_status.sort = 1;
	}
	
	//draw fake bar to cover up a hitch
	if (!isdefined(level.overheat_status2))
	{
		level.overheat_status2 = newhudelem();
		level.overheat_status2.alignX = "right";
		level.overheat_status2.alignY = "bottom";
		level.overheat_status2.horzAlign = "right";
		level.overheat_status2.vertAlign = "bottom";
		level.overheat_status2.x = barX;
		level.overheat_status2.y = barY;
		level.overheat_status2 setShader("white", 10, 1);
		level.overheat_status2.color = (1,.9,0);
		level.overheat_status2.alpha = 0;
		level.overheat_status.sort = 2;
	}
	
	if (!isdefined(level.overheat_flashing))
	{
		level.overheat_flashing = newhudelem();
		level.overheat_flashing.alignX = "right";
		level.overheat_flashing.alignY = "bottom";
		level.overheat_flashing.horzAlign = "right";
		level.overheat_flashing.vertAlign = "bottom";
		level.overheat_flashing.x = barX;
		level.overheat_flashing.y = barY;
		level.overheat_flashing setShader("white", 10, level.turret_heat_max);
		level.overheat_flashing.color = (.8,.16,0);
		level.overheat_flashing.alpha = 0;
		level.overheat_status.sort = 3;
	}
}

seaknight_player_mount_gun( lerp )
{
	flag_wait( "difficulty_initialized" );
	thread player_invulnerable_time_tweak();
	level.mortarMaxInterval = 1;
	level.mortar_max_dist = 4000;
	level.mortarWithinFOV = level.cosine[ "35" ];
	level thread overheat_enable();
	//level.seaknight thread seaknight_death_think();
	level.onMark19 = true;
	thread hud_hide( true );
	//level.player EnableInvulnerability();
   	level.player allowprone( false );
   	level.player allowcrouch( false );
    thread shotFired();
    thread view_kick_change();
    
    if( isdefined( lerp ) )
    {
    	level.player disableWeapons();
    	level.seaknight lerp_player_view_to_tag( "tag_player", 1, 1, 0,0,0,0 );
    }

	level.seaknight useby ( level.player );
	level.seaknight thread seaknight_fire_turret();   	

	tagAngles = level.seaknight gettagangles( "tag_player" );
	level.player setplayerangles(tagAngles + ( 0, 0, 0) );

}

seaknight_death_think()
{
	level endon( "player_off_turret" );
	level.player waittill( "death" );
	level.seaknight thread play_loop_sound_on_entity( "airlift_heli_alarm_loop" );
	level.seaknight notify("death");
}


view_kick_change()
{
	old_bg_viewKickScale = getdvar( "bg_viewKickScale" ); 	//0.8
	old_bg_viewKickMax = getdvar( "bg_viewKickMax" );		//90
	old_bg_viewKickMin = getdvar( "bg_viewKickMin" );		//5
	old_bg_viewKickRandom = getdvar( "bg_viewKickRandom" );	//0.4

	setsaveddvar( "bg_viewKickScale", 0.3 );
	setsaveddvar( "bg_viewKickMax", "20" );
	//setsaveddvar( "bg_viewKickMin", old_bg_viewKickMin );
	//setsaveddvar( "bg_viewKickRandom", old_bg_viewKickRandom );
	
	level waittill( "player_off_turret" );

	setsaveddvar( "bg_viewKickScale", old_bg_viewKickScale );
	setsaveddvar( "bg_viewKickMax", old_bg_viewKickMax );
	setsaveddvar( "bg_viewKickMin", old_bg_viewKickMin );
	setsaveddvar( "bg_viewKickRandom", old_bg_viewKickRandom );	
}

shotFired()
{
	level endon( "player_off_turret" );
	for (;;)
	{
		level.seaknight waittill( "projectile_impact", weaponName, position, radius );
		if ( getdvar( "ragdoll_deaths" ) == "1" )
			thread shotFiredPhysicsSphere( position );
		wait 0.05;
	}
}

shotFiredPhysicsSphere( center )
{
	wait 0.1;
	physicsExplosionSphere( center, level.physicsSphereRadius, level.physicsSphereRadius / 2, level.physicsSphereForce );
}



seaknight_player_dismount_gun()
{

	level.mortarMaxInterval = undefined;
	level.mortar_max_dist = undefined;
	level.mortarWithinFOV = undefined;
	thread seaknight_player_monitor();
	level.seaknight thread maps\_vehicle::lights_on( "interior" );
	level.onMark19 = false;
	set_vision_set( "airlift_streets", 3 );
	thread hud_hide( false );
	level notify( "player_off_turret" );
	level thread overheat_disable();

	level.seaknight useby (level.player);
	level.player unlink();
	level.player playerlinktodelta( level.seaknight, "tag_player", 1, 50, 50, 30, 45 );
	wait(.05);
	level.seaknight turret_reset();
	level.seaknight lerp_player_view_to_tag( "tag_turret_exit", 1, 0.9, 25, 25, 45, 0 );
    level.player unlink();
    level.player enableWeapons();

	//level.player DisableInvulnerability();
   	level.player allowprone( true );
   	level.player allowcrouch( true );
   	thread seaknight_player_triggers();
	level notify ( "player_dismounted_from_gun" );
}

turret_reset()
{
	angles = self gettagangles( "tag_player" );
	forward = anglestoforward( angles );
	vec = vectorscale( forward, 5000 );
	self SetTurretTargetVec( vec );
}
seaknight_player_triggers()
{
	/*-----------------------
	PUT TRIGGER NEAR DOOR
	-------------------------*/
	trigger_seaknight = getent( "trigger_seaknight", "targetname" );
	assert( isdefined( trigger_seaknight ) );
   	trigger_seaknight.origin = level.seaknight gettagorigin( "tag_door_rear" );
   	
   	/*-----------------------
	PUT USE TRIGGER NEAR GUN
	-------------------------*/
	trigger_seaknight_gun = getent( "trigger_seaknight_gun", "targetname" );
	assert( isdefined( trigger_seaknight_gun ) );
   	trigger_seaknight_gun.origin = level.seaknight gettagorigin( "tag_turret_exit" );	
}
seaknight_player_monitor()
{
	waittill_trigger_seaknight();
	level.playerInSeaknight = false;
}

seaknight_door_open_sound()
{
	level.seaknight playsound ( "seaknight_door_open" );
}

playerWeaponTempRemove()
{
	// HACKED until I get the CH46 rigged with an actual turret
	playerWeapons = level.player GetWeaponsList();
	playerPrimaryWeapons = level.player GetWeaponsListPrimaries();
	
	if ( playerWeapons.size > 0 )
	{
		for(i=0;i<playerWeapons.size;i++)
			level.player takeWeapon(playerWeapons[i]);		
	}
	
	level.player waittill ("restore_player_weapons");
	
	if ( playerWeapons.size > 0 )
	{
		for(i=0;i<playerWeapons.size;i++)
			level.player giveWeapon(playerWeapons[i]);				
	}
	
	if ( isdefined( playerPrimaryWeapons[0] ) )
		level.player switchToWeapon( playerPrimaryWeapons[0] );

}

hud_hide( state )
{
	wait 0.05;
	if ( state )
	{
		setsaveddvar( "ui_hidemap", 1 );
		SetSavedDvar( "hud_showStance", "0" );
		SetSavedDvar( "compass", "0" );
		SetSavedDvar( "ammoCounterHide", "1" );
		//SetSavedDvar( "hud_showTextNoAmmo", "0" ); 
	}
	else
	{
		setsaveddvar( "ui_hidemap", 0 );
		setSavedDvar( "hud_drawhud", "1" );	
		SetSavedDvar( "hud_showStance", "1" );
		SetSavedDvar( "compass", "1" );
		SetSavedDvar( "ammoCounterHide", "0" );
		//SetSavedDvar( "hud_showTextNoAmmo", "1" ); 
	}
}




flight_flags_think()
{
	//self ==> the script_origin with the flag
	assertEx( isdefined( self.script_parameters ), "Flight flags need to have the <vehicleTargetname_FlagName> set in a script_parameters key: ent at location: " + self.origin );
	assertEx( issubstr( self.script_parameters, "_" ), "Flight flags need to have a '_' seperating the vehicle targetname from the flag string. ent at location: " + self.origin );
	aStrings = strtok( self.script_parameters, "_" );
	assertEx( aStrings.size == 2, "Flight flags need to have a SINGLE '_' seperating the vehicle targetname from the flag string. ent at location: " + self.origin );
	vehicleTargetname = aStrings[ 0 ];
	sFlag = aStrings[ 1 ];
	
	flag_init( sFlag );
	level endon ( sFlag );

	/*-----------------------
	SET FLAG ONLY WHEN SPECIFIC VEHICLE HITS ORIGIN
	-------------------------*/		
	while ( true )
	{
		self waittill( "trigger", other );
		if ( other.targetname == vehicleTargetname )
		{
			if ( getdvar( "debug_airlift" ) == "1" )
				self thread print3Dthread( sFlag, undefined, 5 );
			flag_set( sFlag );
		}
	}
}

AI_think(guy)
{
	/*-----------------------
	RUN ON EVERY DUDE THAT SPAWNS
	-------------------------*/		
	if (guy.team == "axis")
		guy thread AI_axis_think();
	
	if (guy.team == "allies")
		guy thread AI_allies_think();

}




AI_allies_think()
{
	self.animname = "frnd";
	if ( !isdefined( self.magic_bullet_shield ) )
		self thread magic_bullet_shield();
	self.a.disablePain = true;
}

AI_axis_think()
{
	self.animname = "hostile";
	self thread AI_ragdoll();
}

AI_ragdoll( bIsDrone )
{
	self waittill( "death", attacker, cause );
	
	if ( !isdefined( attacker ) )
		return;
	
	if ( ( isdefined ( attacker.targetname ) ) && ( attacker.targetname == "seaknightPlayer" ) && ( level.onMark19 == true ) )
	{
		self.skipDeathAnim = true;
		if ( ( isdefined( bIsDrone ) ) && ( bIsDrone == true ) )
			arcadeMode_kill( self.origin, "explosive", 50 );
	}
}

AI_drone_think()
{
	self endon( "death" );
	self thread AI_ragdoll( true );
	self endon ( "stop_default_drone_behavior" );
	self waittill( "goal" );
	self delete();
}

AI_construction_spawner_think()
{
	/*-----------------------
	GIVE LESS GRENADES FOR EASY AND NORMAL
	-------------------------*/		
	switch( level.gameSkill )
	{
		case 0: //easy
			self.script_grenades = 0;
			break;
		case 1://regular
			if ( level.grenadeToggle == 0 )
			{
				self.script_grenades = 0;
				level.grenadeToggle = 1;
			}
			else
				level.grenadeToggle = 0;
			break;
		case 2: //hardened
			break;
		case 3: //veteran
			break;	
	}
}

spawn_pilots( aPilot_drones )
{
	sAnim = "pilot_idle";
	for(i=0;i<aPilot_drones.size;i++)
	{
		guy = dronespawn( aPilot_drones[i] ); 
		guy thread AI_pilots_think( sAnim );
		sAnim = "copilot_idle";
	}
}

AI_pilots_think( sAnim )
{
	self endon( "death" );
	maps\_vehicle_aianim::detach_models_with_substr( self, "weapon_" );
	self.ignoreme = true;	
	self.grenadeawareness = 0;
	self.animname = "drone";
	assert( isdefined( sAnim ) );
	sTag = undefined;
	if ( sAnim == "pilot_idle" )
		sTag = "tag_driver";
	else
		sTag = "tag_passenger";
	
	level.seaknight thread anim_loop_solo( self, sAnim, sTag );
	self linkto(level.seaknight);
	level waittill( "delete_pilots" );
	if ( isdefined( self.magic_bullet_shield ) )
		self stop_magic_bullet_shield();
	self delete();
}

player_attacks_from_seaknight( attacker )
{
	if ( !isdefined( attacker.targetname ) )
		return false;
	return attacker.targetname == "seaknightPlayer";
}