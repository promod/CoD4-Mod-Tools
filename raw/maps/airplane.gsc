#include common_scripts\utility;
#include maps\_utility;
#include maps\_anim;
#include maps\jake_tools;

main()
{
	if ( getdvar( "r_reflectionProbeGenerate" ) == "1" )
		return;

	setsaveddvar( "r_specularcolorscale", "1.2" );
	initPrecache();
	if ( getdvar( "alt_music" ) == "" )
		setdvar( "alt_music", "0" );
	if ( getdvar( "airmasks" ) == "" )
		setdvar( "airmasks", "1" );
	if ( getdvar( "notimer" ) == "" )
		setdvar( "notimer", "0" );
	if ( getdvar( "airplane_debug" ) == "" )
		setdvar( "airplane_debug", "0" );
	setsaveddvar( "g_friendlyNameDist", 0 );
	/*-----------------------
	LEVEL VARIABLES
	-------------------------*/	
	level.peopleSpeaking = false;
	level.firstAxisKilled = false;
	level.TimeBetweenHostileDown = 5;
	level.hostileDownBeingSpoken = false;
	level.playerGotHeadshot = false;
	level.sightDetectDistance = 512;
	level.alertDistance = 128;
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
	add_start( "breach", ::start_breach, &"STARTS_BREACH"  );
	add_start( "vip", ::start_vip, &"STARTS_VIP"  );
	add_start( "freefall", ::start_freefall, &"STARTS_FREEFALL"  );
	add_start( "demo", ::start_demo, &"STARTS_DEMO"  );
	default_start( ::start_default );
		
	/*-----------------------
	GLOBAL SCRIPTS
	-------------------------*/	
	thread no_grenade_death_hack();
	thread breach_compartment_setup();
	maps\createart\airplane_art::main();
	level thread maps\airplane_fx::main();
	maps\airplane_anim::main();
	
	level.weaponClipModels = [];
	level.weaponClipModels[0] = "weapon_m16_clip";
	level.weaponClipModels[1] = "weapon_mp5_clip";
	level.weaponClipModels[2] = "weapon_ak47_clip";

	thread maps\_pipes::main();
	thread maps\_leak::main();
	
	maps\_load::main();
	level thread maps\airplane_amb::main();	
	thread intro_fade_in();
	battlechatter_off( "allies" );
	
	thread player_breach_jump();
	
	/*-----------------------
	FLAGS
	-------------------------*/	
	//objectives
	flag_init( "obj_rescue_vip_given" );
	flag_init( "obj_rescue_vip_complete" );
	flag_init( "obj_freefall_given" );
	flag_init( "obj_freefall_complete" );

	//misc	
	flag_init( "aa_first_floor_section" );
	flag_init( "aa_second_floor_section" );
	flag_init( "aa_humanshield_section" );
	flag_init ( "timer_expired" );
	flag_init( "destabilize_level_2" );
	
	//intro
	flag_init( "enemies_alerted" );
	flag_init( "intro_fade_in_complete" );
	flag_init( "bathroom_guy_dead" );
	flag_init( "bathroom_dude_clear" );
	
	//exit row burst
	flag_init( "fuselage_about_to_blow" );
	flag_init( "fuselage_breached" );
	
	//vip human shield
	flag_init( "human_shield_starting" );
	flag_init( "player_looking_at_human_shield" );
	flag_init ( "hostage_timer_expired" );
	flag_init( "human_shield_actors_spawned" );
	flag_init( "terrorist_killed" );
	flag_init( "terrorist_wounded" );
	flag_init( "human_shield_over" );
	flag_init( "friendlies_killed_human_shield" );
	flag_init( "restore_timescale" );
	
	//freefall
	flag_init( "hostage_idling_for_freefall" );
	flag_init( "exit_door_about_to_blow" );
	flag_init( "exit_door_blown" );
	flag_init( "freefallers_jumping" );
	flag_init( "friendlies_jumped" );
	flag_init( "hostage_jumped_out" );
	flag_init( "player_jumped_out" );
	flag_init( "white_done" );
	flag_init( "plane_explodes" );
	flag_init( "cut_to_black" );
	

	/*-----------------------
	GLOBAL THREADS
	-------------------------*/	
	//SetSavedDvar( "compass", "0" );
	thread dialogue_move();
	thread dialogue_clear();
	level.playerSpeed = 0.85;
	level.player SetMoveSpeedScale( level.playerSpeed );
	array_thread( getentarray( "civilian", "script_noteworthy"), ::AI_civilian_think );
	level.org_view_roll = getent( "org_view_roll", "targetname" );
	assert(isdefined(level.org_view_roll));
	//level.player playerSetGroundReferenceEnt( level.org_view_roll );
	level.aRollers = [];
	level.aRollers = array_add( level.aRollers, level.org_view_roll );
	thread airmasks();
	thread plane_tilt();
	
	createthreatbiasgroup( "player" );
	createthreatbiasgroup( "ignored" );
	createthreatbiasgroup( "oblivious" );
	level.player setthreatbiasgroup( "player" );
	setignoremegroup( "allies", "oblivious" );	// oblivious ignore allies
	setignoremegroup( "axis", "oblivious" );	// oblivious ignore axis
	setignoremegroup( "player", "oblivious" );	// oblivious ignore player
	setignoremegroup( "oblivious", "allies" );	// allies ignore oblivious
	setignoremegroup( "oblivious", "axis" );	// axis ignore oblivious
	setignoremegroup( "oblivious", "oblivious" );	// oblivious ignore oblivious

	array_thread( getentarray( "human_shield", "targetname" ), ::add_spawn_function, ::AI_human_shield_think );
	array_thread( getentarray( "patroller", "script_noteworthy" ), ::add_spawn_function, ::AI_patroller );
	array_thread( getentarray( "scripted_node_dummies", "targetname" ), ::hide_geo );
	thread airplane_destabilize();
	thread fx_management();
	thread hideAll();
	
}

/****************************************************************************
    START FUNCTIONS
****************************************************************************/ 
start_default()
{
	AA_intro_init();
	//start_breach();
	//start_vip();
	//start_freefall();
	//start_demo();
}

start_breach()
{
	initFriendlies( "breach" );
	AA_breach_init();
}

start_vip()
{
	initFriendlies( "vip" );
	AA_vip_init();
}

start_freefall()
{
	initFriendlies( "freefall" );
	thread door_open_double( getentarray( "door_bar", "targetname" ) );
	flag_set( "human_shield_over" );
	AA_freefall_init();
}

start_demo()
{
	thread demo_setup();
	demo_walkthrough();		
}

/****************************************************************************
    INTRO START
****************************************************************************/ 

AA_intro_init()
{
	initFriendlies( "intro" );
	thread music();
	thread intro_setup();
	thread stealth_intro();
	thread airplane_timer();
	thread obj_rescue_vip();
	thread flashbang_detect();
	thread weapon_detect();

	//start other sections
	level thread AA_breach_init();
	level thread AA_vip_init();
	
	flag_set( "aa_first_floor_section" );
}

intro_fade_in()
{
	black_overlay = create_overlay_element( "black", 1 );
	cutaway_geo_floor = getent( "cutaway_geo_floor", "targetname" );
	cutaway_geo_floor hide();
	/*-----------------------
	PLAYER LOOKING THROUGH HOLE IN CEILING
	-------------------------*/	
	airplane_hole_overlay = create_overlay_element( "airplane_hole_overlay", 1 );
	level.player disableWeapons();
	level.player freezeControls( true );

	cutaway_geo = getent( "cutaway_geo", "targetname" );
	org_pos = getent( "org_intro_playerview", "targetname" );
	assert(isdefined(cutaway_geo));
	assert(isdefined(org_pos));
	level.player.origin = org_pos.origin;
	level.player linkto( org_pos );
	org_pos.origin = org_pos.origin + ( 0, 20, -52 );
	
	org_view  = spawn( "script_origin", org_pos.origin );
	org_view.angles = org_pos.angles;
	level.player playerSetGroundReferenceEnt( org_view );
	org_view RotatePitch( 65, .05 );
	org_pos RotateRoll( -10, .05 );
	cutaway_geo.origin = cutaway_geo.origin + ( 15, 20, -10 );
	wait( 0.2 );
	level.price hide();
	/*-----------------------
	CEILING PANEL DROPS
	-------------------------*/	
	black_overlay.alpha = 0;

	thread cutaway_geo(cutaway_geo);
	wait(.3);
	/*-----------------------
	FADE TO BLACK
	-------------------------*/	
	black_overlay = create_overlay_element( "black", 0 );
	black_overlay fadeOverTime(1);
	black_overlay.alpha = 1;
	wait(1);
	airplane_hole_overlay destroy();
	SetSavedDvar( "hud_gasMaskOverlay", 1 );
	level.player playerSetGroundReferenceEnt( level.org_view_roll );
	level.price show();
	level.player unlink();
	player_intro_start = getent( "player_intro_start", "targetname" );
	thread play_sound_in_space( "gear_rattle_plr_run", level.player.origin );
	level.player SetOrigin( player_intro_start.origin );
	level.player SetPlayerAngles( player_intro_start.angles );
	level.player.angles = player_intro_start.angles;
	
	/*-----------------------
	FADE UP WITH WEAPONS
	-------------------------*/		
	flag_set( "intro_fade_in_complete" );
	cutaway_geo_floor show();
	black_overlay fadeOverTime( 2 );
	black_overlay.alpha = 0;
	cutaway_geo hide();
	cutaway_geo notsolid();
	level.player enableWeapons();
	level.player freezeControls( false );
	autosave_now( "start", true );
	wait (2);
	black_overlay destroy();
}

cutaway_geo(cutaway_geo)
{
	level.player thread play_sound_on_entity( "airplane_panel_drop" );
	//cutaway_geo rotateyaw(10, .7, .1, .1);
	cutaway_geo rotateroll(-10, .3, .1, .1);
	cutaway_geo movez( -110, .7, .2 );
	wait(.3);
	//cutaway_geo rotateroll(10, .2, .1, .1);
	wait (.2);
	cutaway_geo rotateroll(10, .15, .05, .05);
	wait .15;
	//cutaway_geo rotateroll(25, .15, .05, .05);
	wait .15;
	//cutaway_geo rotateroll(10, .1, .05, .05);
	earthquake( 0.1, .5, level.player.origin, 500);
	

}
intro_fade_in2()
{
	cutaway_geo = getent( "cutaway_geo", "targetname" );
	cutaway_geo hide();
	cutaway_geo notsolid();
	
	//thread mask_and_gun();
	level.player disableWeapons();
	level.player freezeControls( true );
	black_overlay = create_overlay_element( "black", 1 );
	wait(2);
	SetSavedDvar( "hud_gasMaskOverlay", 1 );
	black_overlay fadeOverTime( 2 );
	black_overlay.alpha = 0;
	level.player enableWeapons();
	level.player freezeControls( false );
	autosave_now( "start", true );
	wait (2);
	black_overlay destroy();
	flag_set( "intro_fade_in_complete" );
	level.player playerSetGroundReferenceEnt( level.org_view_roll );
}

//mask_and_gun()
//{
//	wait(.05);
//	PlayerMaskPuton();
//	wait(.05);
//	level.player enableWeapons();	
//}

airplane_timer()
{
	flag_wait( "intro_fade_in_complete" );
	//wait(2);
	level thread timer_start();
	flag_set( "obj_rescue_vip_given" );
}
music()
{
	//musicplaywrapper( "airplane_suspense_music" );
	
	flag_wait_either( "bathroom_guy_dead", "enemies_alerted" );
	//musicstop();
	//wait(0.05);
	//if ( getdvar( "alt_music" ) == "0" )
	musicplaywrapper( "airplane_alt_music" );
	//else
		//musicplaywrapper( "airplane_fastcqb_music" );
	
	flag_wait( "human_shield_starting" );
	musicstop(2);
}

stealth_intro()
{
	battlechatter_off( "axis" );
	/*-----------------------
	ALL IGNORED
	-------------------------*/	
	level.player.ignoreme = true;
	for(i=0;i<level.squad.size;i++)
	{
		level.squad[i].ignoreme = true;
		level.squad[i] setthreatbiasgroup ( "oblivious" );
	}
	
	flag_wait_or_timeout( "enemies_alerted", 10 );
	if ( !flag( "enemies_alerted" ) )
		flag_set( "enemies_alerted" );
	
	level thread radio_dialogue_queue( "airplane_first_hostile_killed_2" );	//Weapons free.
	battlechatter_on( "axis" );
	/*-----------------------
	MOVE UP FRIENDLIES
	-------------------------*/	
	colornodes_intro = getent( "colornodes_intro", "script_noteworthy" );
	colornodes_intro notify( "trigger", level.player );

	level.player.ignoreme = false;
	for(i=0;i<level.squad.size;i++)
	{
		level.squad[i].ignoreme = false;
		level.squad[i] setthreatbiasgroup ( "allies" );
	}

	wait(1);
	
		
}
intro_setup()
{
	flag_wait( "intro_fade_in_complete" );
	/*-----------------------
	SPAWN OTHER PATROLLERS
	-------------------------*/	
	triggerActivate( "trig_spawn_patrollers" );	
	
	/*-----------------------
	PRICE DOES EYES SIGNAL
	-------------------------*/	
	level.price thread anim_generic( level.price, "enemy_cornerR" );

	//flag_wait( "player_approach_intro_bathroom" );
	/*-----------------------
	BATHROOM GUY
	-------------------------*/	
	level.hostile_bathroom = spawnDude( getent( "hostile_bathroom", "targetname" ) );
	level.hostile_bathroom thread hostile_bathroom_think();
	bathroom_flush = getent( "bathroom_flush", "targetname" );
	thread play_sound_in_space( "airplane_toiletflush", bathroom_flush.origin );
	wait(1);
	thread bathroom_door_open( "bathroomdoor_01", "bathroomdoor_02" );
}

hostile_bathroom_think()
{
	self waittill( "damage" );
	flag_set( "bathroom_guy_dead" );
}



/****************************************************************************
    BREACH - FUSELAGE
****************************************************************************/ 

AA_breach_init()
{
	level thread dialogue_breach();
	level thread fuselage_breached();
	level thread breach_kill_ai();
}

dialogue_breach()
{
	flag_wait( "player_approaching_breach" );
	
	level.peopleSpeaking = true;
	
	//Gaz	
	//We've got a hull breaach! Get doown!! Get dooown!!	
	level radio_dialogue( "airplane_gaz_hullbreach" );
	
	flag_wait( "fuselage_breached" );
	wait(1);
	
	level.peopleSpeaking = false;
	
	
	flag_wait( "player_up_breach_stairs" );
	
	level.peopleSpeaking = true;
	
	//Gaz	
	//Stairway clear!	
	level radio_dialogue( "airplane_gaz_stairwayclear" );
	
	//SAS 4	
	//Multiple contacts.
	level radio_dialogue( "airplane_sas4_multiplecont" );
	
	level.peopleSpeaking = false;
	
	flag_wait( "player_approach_bar" );
	
	level.peopleSpeaking = true;
	
	//Gaz	
	//Watch your fire up here. We're looking for a civilian.
	level radio_dialogue( "airplane_gaz_watchyourfire" );
	
	level.peopleSpeaking = false;	
}

fuselage_breached()
{
	breach_org1 = getent( "breach_org1", "targetname" );
	breach_org2 = getent( "breach_org2", "targetname" );
	flag_wait( "player_approaching_breach" );

	/*-----------------------
	MAKE MACEY VULNERABLE
	-------------------------*/	
	if ( isdefined( level.macey.magic_bullet_shield ) )
		level.macey stop_magic_bullet_shield();
	
	/*-----------------------
	SEATS
	-------------------------*/	
	array_thread( getentarray( "breach_seats", "targetname" ), ::breach_seat, "fuselage_breached" );
		
	/*-----------------------
	FUSELAGE METAL STRESS AND AIR LEAK
	-------------------------*/	
	level.player thread play_sound_on_entity ( "fuselage_stress" );
	wait(.5);
	//thread play_sound_in_space( "fuselage_air_leak", breach_org1.origin );
	//thread breach_leaks();
	exploder( 7 );
	wait(1.5);
	level.player thread play_sound_on_entity ( "fuselage_stress" );
	//thread play_sound_in_space( "fuselage_air_leak", breach_org2.origin );
	flag_set( "fuselage_about_to_blow" );
	wait (.5);
	level.player playLocalSound( "airplane_seatbelt", "airplane_seatbelt_done" );
	level.player waittill( "airplane_seatbelt_done" );
	wait(.5);
	/*-----------------------
	FUSELAGE EXPLOSION
	-------------------------*/	
	exploder( 666 );
	earthquake( 0.5, 3, level.player.origin, 8000);
	level.player thread play_sound_on_entity( "fuselage_breach_explosion" );
	flag_set( "fuselage_breached" );

	/*-----------------------
	LUGGAGE COMPARTMENTS
	-------------------------*/	
	compartment_01 = getent( "compartment_01", "targetname" );
	compartment_02 = getent( "compartment_02", "targetname" );
	compartment_01 thread breach_compartment_open( "fuselage_breached", 45 );
	compartment_02 thread breach_compartment_open( "player_approaching_breach_hole", -45 );
	
	thread breach_gravity_shift();
	
	breach_org1 playLoopSound( "airplane_wind_loop" );
	thread maps\_utility::set_ambient("amb_int_airplane_intensity5");
	wait(1.5);
	breach_org2 playLoopSound( "airplane_wind_loop" );
	
	flag_wait( "player_jumped_out" );
	
	breach_org1 stopLoopSound( "airplane_wind_loop" );
	breach_org2 stopLoopSound( "airplane_wind_loop" );

	wait(.5);
}

breach_kill_ai()
{
	flag_wait( "fuselage_breached" );
	
	aAI = getAIarrayTouchingVolume( "axis", "badplace_breach" );
	for(i=0;i<aAI.size;i++)
		aAI[i] thread breach_kill_ai_logic();
	
}

breach_kill_ai_logic()
{
	self.ignoreme = true;
	self.skipDeathAnim = true;
	self dodamage( self.health + 1000, self.origin );
	org = self.origin;
}

breach_compartment_setup()
{
	//move compartments back into place...were lowered to get correct lighting values
	compartments = getentarray( "compartment", "script_noteworthy" );
	for(i=0;i<compartments.size;i++)
		compartments[i] movez( 24, .1 );
}
breach_compartment_open( sFlag, angle )
{
	assert( isdefined( self ) );
	org_physics_pusher = getent( self.target, "targetname" );
	assert(isdefined(org_physics_pusher));
	if ( isdefined( sFlag ) )
		flag_wait( sFlag );
	
	thread play_sound_in_space( "airplane_overhead_compartment_open", org_physics_pusher.origin );
	self rotateroll( angle, .4, .1, .1 );
	wait(.4);
	
	//PhysicsExplosionSphere( <position of explosion>, <outer radius>, <inner radius>, <magnitude> )
	physicsExplosionSphere( org_physics_pusher.origin, 60, 30, .2 );
}

//breach_leaks()
//{
//
//	flag_wait( "fuselage_breached" );
//	array_thread(level.fxBreachLeaks, ::pauseEffect);	
//		
//}

breach_seat( sFlag )
{
	assert( isdefined( self ) );
	org_target = getent( self.target, "targetname" );
	assert(isdefined(org_target));
	org_end = getent( org_target.target, "targetname" );
	assert(isdefined(org_end));
	fDelay = undefined;
	rotateyawangle = undefined;
	yawtime = undefined;
	movetime1 = undefined;
	movetime2 = undefined;	
	
	if ( isdefined( sFlag ) )
		flag_wait( sFlag );
	
	switch ( self.script_noteworthy )
	{
		case "seat_1":
			rotateyawangle = 75;
			yawtime = 1.2;
			movetime1 = .65;
			movetime2 = .25;
			fDelay = 1;
			break;
		case "seat_2":
			rotateyawangle = -75;
			yawtime = 1.2;
			movetime1 = .65;
			movetime2 = .25;
			fDelay = 2;
			break;
		default:
			assertmsg( "not a valid script_noteworthy for chair at " + self.origin );
			break;
	}
	wait( fDelay );
	self RotateYaw( rotateyawangle, yawtime, yawtime/3 );
	wait( yawtime );
	
	
	self MoveTo( org_target.origin, movetime1 );
	self RotateTo( org_target.angles, movetime1 );

	wait( movetime1 );
	self MoveTo( org_end.origin, movetime2 );
	self RotateTo( org_end.angles, movetime2 );
	
	wait(movetime2);
	self delete();

}

breach_gravity_shift()
{
	
	org_breach_push = getent( "org_breach_push", "targetname" );
	assert(isdefined(org_breach_push));
	wait(1);
	
	/*-----------------------
	SWITCH GRAVITY TO THE RIGHT
	-------------------------*/	
	thread gravity_shift( 25 );
	
	/*-----------------------
	PHYSICS PUSH TOWARDS RIGHT
	-------------------------*/	
	breach_physics = getent( "breach_physics", "targetname" );
	assert(isdefined(breach_physics));
	breach_org1 = getent( "breach_org1", "targetname" );
	assert(isdefined(breach_org1));
	
	breach_physics thread physicsjolt_proximity( 5000, 2500, ( 0, 0, 0.25 ) );

	
	flag_wait( "player_up_breach_stairs" );
	flag_clear( "aa_first_floor_section" );
	flag_set( "aa_second_floor_section" );

	breach_physics notify( "stop_physicsjolt" );

	flag_wait( "exit_door_blown" );
	
	thread final_roll();
	shake_org = getent( "shake_org", "targetname" );
	assert(isdefined(shake_org));
	shake_org thread physicsjolt_proximity( 5000, 2500, ( 0, 0, 0.25 ) );
	flag_wait( "player_jumped_out" );
	shake_org notify( "stop_physicsjolt" );
}

final_roll()
{
	thread gravity_shift( -25 );
	array_thread( level.aRollers, ::rotate_rollers, -13 );
	wait(6);	
	array_thread( level.aRollers, ::rotate_rollers, 13 );
}

physicsShake()
{
	level endon( "stop_physics_shake" );
	while ( true )
	{
		wait( .1);
		physicsJitter( level.player.origin, 5000, 2500, .45, .9 );
	}
}

plane_tilt()
{
	flag_wait( "fuselage_breached" );
	
	array_thread( level.aRollers, ::rotate_rollers, 15 );
	
	wait(6);
	
	array_thread( level.aRollers, ::rotate_rollers, -13 );
	
	wait(5);
	
	array_thread( level.aRollers, ::rotate_rollers, 10 );
	
	wait(5);
	
	array_thread( level.aRollers, ::rotate_rollers, -12 );
	
	wait(5);
	
	flag_wait( "player_up_breach_stairs" );

	/*-----------------------
	AMBIENT ROLL
	-------------------------*/	
}

rotate_rollers( angle )
{
	self rotateroll( angle, 5, 2, 2 );
} 

/****************************************************************************
    VIP
****************************************************************************/ 
AA_vip_init()
{
	thread friendly_human_shield_setup();
	thread restore_timescale();
	thread dialogue_humanshield();
	thread humanshield();
	thread blood_pool();
	thread humanshield_timer_kill();
	AA_freefall_init();
}

restore_timescale()
{
	flag_wait_either( "terrorist_killed", "terrorist_wounded" );
	wait(1.3);
	flag_set( "restore_timescale" );
}
dialogue_humanshield()
{

	flag_wait( "human_shield_actors_spawned" );
	

	//Russian 1	
	//Get back! I'll blow his fucking head off! I said get back!
	level.terrorist thread dialogue_execute( "airplane_ter_illkillhim" );

	wait(1);

	//Gaz	
	//Drop the weapon!!! Down on the floor now
	level thread radio_dialogue( "airplane_gaz_downonfloor" );
	
}

blood_pool()
{
	BloodPool = getent( "blood_pool", "targetname" );
	flag_wait( "human_shield_over" );
	if ( level.playerGotHeadshot )
		playfx( getfx( "blood_pool" ), BloodPool.origin + ( 0, 0, 1), ( 0, 0, 1 ) );		
}

humanshield_timer_kill()
{
	flag_wait_either( "terrorist_killed", "terrorist_wounded" );
	killTimer();
}

friendly_human_shield_setup()
{
	aNodes = getnodearray( "nodeStart_vip", "targetname" );
	ePriceNode = undefined;
	eGriggsNode = undefined;
	for(i=0;i<aNodes.size;i++)
	{
		if ( isdefined( aNodes[i].script_noteworthy ) )
		{
			if ( aNodes[i].script_noteworthy == "nodePrice" )
				ePriceNode = aNodes[i];
			if ( aNodes[i].script_noteworthy == "nodeGrigsby" )
				eGriggsNode = aNodes[i];
		}
	}
	assert(isdefined(ePriceNode));
	assert(isdefined(eGriggsNode));
	
	flag_wait( "player_looking_at_human_shield" );
	
	level.price thread teleport_human_shield( ePriceNode );
	level.grigsby thread teleport_human_shield( eGriggsNode );
}

teleport_human_shield( eNode )
{
	self disable_ai_color();
	self force_teleport( eNode.origin, eNode.angles );
	self setgoalpos (self.origin);
	self setgoalradius (eNode.radius);
	self setgoalnode (eNode);
}

humanshield()
{
	flag_wait( "player_approach_human_shield" );
	thread kill_ai();
	flag_clear( "aa_second_floor_section" );
	flag_set( "aa_humanshield_section" );
	
	level.nodeShield = getnode( "node_freefall", "targetname" );
	assert(isdefined(level.nodeShield));
	
	/*-----------------------
	SETUP AI
	-------------------------*/	
	level.hostage = spawn_script_noteworthy( "hostage" );
	level.terrorist = spawn_script_noteworthy( "terrorist" );
	flag_set( "human_shield_actors_spawned" );
	
	/*-----------------------
	DOOR BUSTS OPEN, GO TO SLO-MO
	-------------------------*/
	flag_set( "human_shield_starting" );
	level notify( "stop_airplane_destabilize" );
	thread hostage_timer( 5 );
	thread door_open_double( getentarray( "door_bar", "targetname" ) );
	delaythread (1, ::player_hearbeat );
	thread humanshield_player_weapon();
	org_humanshield_playerview = getent( "org_humanshield_playerview", "targetname" );
	org_humanshield_playerview.origin = level.player.origin;
	create_playerview( org_humanshield_playerview );
	fLerpTime = 0.5;
	level.player thread play_sound_on_entity( "airplane_jump_whoosh" );
	set_vision_set( "airplane_slomo", 2 );											//( <tag> , <lerptime> , <fraction> , <right_arc> , <left_arc> , <top_arc> , <bottom_arc> )"
	level.ePlayerview lerp_player_view_to_tag( "tag_player", fLerpTime, 1, 35, 35, 45, 45 );
	wait( fLerpTime );
	flag_set( "player_looking_at_human_shield" );
	
	if ( getdvar( "chaplincheat" ) == "1" )
	{
		level.player SetMoveSpeedScale( .2 );
		level.ePlayerview delete();
		
		//flag_wait( "human_shield_over" );
		flag_wait( "restore_timescale" );
		flag_set( "obj_rescue_vip_complete" );
		flag_clear( "aa_humanshield_section" );	
	}
	else
	{
		slowmo_start();
			slowmo_setspeed_slow( .3 );
			slowmo_setlerptime_in( .05 );
			slowmo_lerp_in();	
			
			level.player SetMoveSpeedScale( .2 );
			level.ePlayerview delete();
			
			/*-----------------------
			BACK TO REGULAR MODE
			-------------------------*/			
			//flag_wait( "human_shield_over" );
			flag_wait( "restore_timescale" );
			flag_set( "obj_rescue_vip_complete" );
			flag_clear( "aa_humanshield_section" );	
			
			slowmo_setlerptime_out( .05 );
			slowmo_lerp_out();
		slowmo_end();
	}
	
	thread airplane_destabilize();
	level.player SetMoveSpeedScale( level.playerSpeed );
	level.player thread play_sound_on_entity( "airplane_jump_whoosh" );
	set_vision_set( "airplane", 2 );
	level notify( "stop_player_heartbeat" );
}

kill_ai()
{
	aAi = getaiarray( "axis" );
	for(i=0;i<aAi.size;i++)
		aAi[i] dodamage( aAi[i].health + 1000, aAi[i].origin );
}

player_hearbeat()
{
	level endon( "stop_player_heartbeat" );
	while ( true )
	{
		//level.player thread play_sound_on_entity( "breathing_heartbeat_slowmo" );
		level.player thread play_sound_on_entity( "breathing_heartbeat" );
		wait .5;	
	}
}		

humanshield_player_weapon()
{
	/*-----------------------
	MAX OUT CURRENT AMMO
	-------------------------*/	
	
	currentweapon = level.player getCurrentWeapon();
	level.player takeweapon( currentweapon );
	wait(1);
	level.player giveweapon( "usp_silencer" );
	level.player giveMaxAmmo( "usp_silencer" );
	level.player switchtoWeapon( "usp_silencer" );
}

//
//
//friendly_c4_door_setup()
//{
//	level.grigsby disable_ai_color();
//	node = getnode( "node_macey_freefall", "targetname" );
//	//level.macey teleport( node.origin );
//	level.grigsby.ignoreme = true;
//	level.grigsby.goalradius = 32;
//	level.grigsby setgoalnode(node);
//}

AI_human_shield_think()
{
	flag_wait( "human_shield_actors_spawned" );
	
	self endon( "death" );
	/*-----------------------
	SETUP AI
	-------------------------*/	
	self.ignoreme = true;
	self setFlashbangImmunity( true );
	self setthreatbiasgroup ( "oblivious" );
	self setgoalpos( self.origin );
	self setFlashbangImmunity( true );
	self thread human_shield_death_monitor();
	self thread human_shield_pain_monitor();
	
	ePartner = undefined;
	switch ( self.script_noteworthy )
	{
		case "terrorist":
			self.allowdeath = false;
			self.animname = "terrorist";
			ePartner = level.hostage;
			break;
		case "hostage":
			self.allowdeath = true;
			self.disablearrivals = true;
			self.disableexits = true;	
			self.team = "neutral";
			self.animname = "hostage";
			self set_run_anim( "unarmed_run2" );
			self.deathanim = level.scr_anim["hostage"]["human_shield_death"];
			ePartner = level.terrorist;
			self gun_remove();
			break;	
	}
	
	/*-----------------------
	PLAY IDLE
	-------------------------*/		
	self setgoalpos( self.origin );
	level.nodeShield thread anim_loop_solo( self, "human_shield_idle", undefined, "stop_idle" );
	
	flag_wait( "human_shield_over" );

	/*-----------------------
	RESET AI WHEN HUMAN SHIELD OVER
	-------------------------*/		
	
	if ( isdefined( self ) )
	{
		self.deathanim = undefined;
	}
}


human_shield_ter_wounded_failsafe()
{
	self endon( "death" );
	aOrgs = getentarray( "org_humanshield_magicbullet", "targetname" );
	bulletOrg = undefined;
	wait(1.5);

	/*-----------------------
	SEE IF PRICE/GRIGSBY HAS CLEAR SHOT
	-------------------------*/			
	orgs = [];
	org[0] = level.price gettagorigin ("TAG_FLASH");
	org[1] = level.grigsby gettagorigin ("TAG_FLASH");
	for(i=0;i<orgs.size;i++)
	{
		hasClearShot = bullettracepassed( orgs[0].origin, self gettagorigin ("TAG_EYE"), true, self);
		if ( hasClearShot == true )
		{
			bulletOrg = orgs[0];
			break;
		}
	}
	/*-----------------------
	IF NO NPC HAS CLEAR SHOT, FIRE FROM A SCRIPT_ORIGIN
	-------------------------*/			
	if ( !isdefined( bulletOrg ) )
		bulletOrg = getFarthest( level.player.origin, aOrgs );

	/*-----------------------
	IF NO NPC HAS CLEAR SHOT, FIRE FROM A SCRIPT_ORIGIN
	-------------------------*/		
	//magicbullet( "mp5_silencer", bulletOrg.origin, self gettagorigin ("TAG_EYE") );
	targetTagOrigin = self gettagorigin ("TAG_EYE");
	bullettracer( bulletOrg.origin, targetTagOrigin, true );
	thread play_sound_in_space( "weap_usp45sd_fire_plr", level.player.origin );
	flag_set( "friendlies_killed_human_shield" );
	self dodamage( self.health + 100, targetTagOrigin );
}

headshot_fx()
{
	angles = level.player.angles;
	forward = anglestoforward( angles );
	vec = vectorscale( forward, 5000 );
	start = level.player geteye();
	end = start + vec;
	trace = bullettrace( start, end, false, undefined );
	
	playfx( getfx( "flesh_hit" ), trace[ "position" ], ( 0, 0, 1 ) );
	playfx( getfx( "headshot1" ), trace[ "position" ], ( 0, 0, 1 ) );
	playfx( getfx( "headshot1" ), trace[ "position" ], ( -25, 10, -10 ) );
	playfx( getfx( "headshot2" ), trace[ "position" ], ( 0, 0, 1 ) );
	playfx( getfx( "headshot3" ), trace[ "position" ], ( 0, 0, 1 ) );
	thread play_sound_in_space( "bullet_large_flesh", level.player.origin );

	thread suitcase_splatter();
}

suitcase_splatter()
{
	/*-----------------------
	SPLAT SOME BLOOD ON THE SUITCASE
	-------------------------*/	
	splatter_start = getent( "splatter", "targetname" );
	splatter_end = getent( "bomb_flash", "targetname" );
	angles = splatter_start.angles;
	forward = anglestoforward( angles );
	vec = vectorscale( forward, 10000 );
	start = splatter_start.origin;
	end = splatter_end.origin;
	trace = bullettrace( start, end, false, undefined );
	PlayFX( getfx( "headshot1" ), end + (100, -10, 10), vec, ( 0, 10, 1 ) );
}

human_shield_death_monitor()
{
	level endon( "hostage_jumped_out" );
	self waittill( "death" );
	pos = self.origin;
	if ( self == level.hostage )
		thread maps\_friendlyfire::missionFail();
}

human_shield_pain_monitor()
{
	level.hostage endon( "death" );
	
	while ( isdefined( self ) )
	{
		self waittill ( "damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, idFlags );

		/*-----------------------
		IGNORE FLASHBANG DAMAGE
		-------------------------*/			
		if ( ( isdefined( type ) ) && ( type == "MOD_IMPACT" ) )
			continue;
			
		if ( self == level.hostage )
		{
			/*-----------------------
			HOSTAGE HIT (KILLED)
			-------------------------*/	
			if ( ( isdefined( attacker ) ) && ( attacker == level.player ) )
			{

				self dodamage( self.health + 100, self.origin );
				break;					
			
			}
		}
		else
		{
			/*-----------------------
			TERRORIST HEADSHOT
			-------------------------*/	
			if ( ( isdefined( partName ) ) && ( partName == "j_head" ) )
			{
				flag_set( "terrorist_killed" );
				level.playerGotHeadshot = true;
				dummy = maps\_vehicle_aianim::convert_guy_to_drone( self );
				dummy.animname = "terrorist";
				level.nodeShield notify( "stop_idle" );
				dummy thread headshot_fx();
				level.nodeShield thread anim_single_solo( dummy, "human_shield_death" );
				dummy.animname = "terrorist";
				dummy setcontents(0);
				level.nodeShield anim_single_solo( level.hostage, "human_shield_breakfree_partner_dead" );
				break;
			}
			/*-----------------------
			TERRORIST WOUNDED
			-------------------------*/	
			else if ( !flag( "terrorist_wounded" ) )
			{
				//play pain anim if terrorist
				flag_set( "terrorist_wounded" );
				
				/*-----------------------
				FAIL MISSION IF ON VETERAN
				-------------------------*/					
				if ( level.gameskill == 3)
					thread mission_failed_veteran_no_headshot();
					
				self.allowdeath = true;
				self thread human_shield_ter_wounded_failsafe();
				level.nodeShield notify( "stop_idle" );
				level.nodeShield thread anim_single_solo( self, "human_shield_pain" );
				level.nodeShield anim_single_solo( level.hostage, "human_shield_breakfree_partner_wounded" );
				break;	
			}
		}
	}
	flag_set( "human_shield_over" );
}


mission_failed_veteran_no_headshot()
{
	level notify ( "mission failed" );	
	thread killTimer();
	level notify ( "kill_timer" );
	setDvar("ui_deadquote", &"AIRPLANE_HOSTAGE_NO_HEADSHOT" );
	maps\_utility::missionFailedWrapper();
}

dummy_kill()
{
	self waittillmatch( "single anim", "end" );
	self dodamage( self.health + 1000, self.origin );
}

/****************************************************************************
    FREEFALL
****************************************************************************/ 
AA_freefall_init()
{
	thread dialogue_freefall();
	thread dialogue_jumped_out();
	thread freefall();
	thread freefall_AI_setup();
	thread obj_freefall();
}


dialogue_freefall()
{
	//flag_wait_either( "terrorist_killed", "terrorist_wounded" );
	
	flag_wait( "human_shield_over" );
	//Russian 4	
	//Please! Just don't hurt me. I want to go home. I just want to get out of here	
	level.hostage thread dialogue_execute( "airplane_ru4_donthurtme" );
	
	wait(1);	
	//SAS 4	
	//Shite, someone's armed the bomb. We don't have much time. We've got to go - now.
	level radio_dialogue( "airplane_sas4_armedbomb" );

	//Gaz	
	//Roger that. Prepare to breach.
	level radio_dialogue( "airplane_gaz_preptobreach" );	
	
	flag_wait( "freefallers_jumping" );

	if ( !flag( "player_jumped_out" ) )
	{
		//Gaz	
		//We're goin' for a little freefall mate! On your feet! (slight exertion from shoving protesting VIP)
		level thread radio_dialogue( "airplane_gaz_onyourfeet" );			
	}

	
	if ( !flag( "player_jumped_out" ) )
	{
		//Russian 4	
		//What? No!... Wait! What are you doing? I don't have a parachuuuuuuute
		level.hostage dialogue_execute( "airplane_ru4_noparachute" );		
	}

	
	wait(3);
	if ( !flag( "player_jumped_out" ) )
	{
		//SAS 1	
		//Let's go! Let's go! Out the door before this thing blows!		
		level thread radio_dialogue( "airplane_sas1_letsgo" );
	}
	
}

dialogue_jumped_out()
{
	flag_wait( "player_jumped_out" );
	
	//wait(1.5);
	//Gaz	
	//Mission accomplished! See ya next time mate!		
	level radio_dialogue( "airplane_gaz_seeya" );
	
}

bomb_think()
{
	bomb_flash = getent( "bomb_flash", "targetname" );
	level waittill( "timer_tick" );
	playfx( getfx( "c4_light_blink" ), bomb_flash.origin + ( 0, 0, 0) );
}

freefall_AI_setup()
{
	flag_wait( "human_shield_over" );
	/*-----------------------
	IF START POINT, SPAWN A HOSTAGE
	-------------------------*/			
	if ( !isdefined( level.hostage ) )
	{
		level.hostage = spawn_script_noteworthy( "hostage2" );
		level.hostage.animname = "hostage";
		level.hostage gun_remove();
	}

	/*-----------------------
	HOSTAGE PRICE FREEFALL SEQUENCE
	-------------------------*/				
	level.nodeFreefall = getnode( "node_freefall", "targetname" );
	assert( isdefined( level.nodeFreefall ) );
	level.freefallersReady = 0;
	level.hostage thread AI_freefall_think();
	level.price thread AI_freefall_think();
}

AI_freefall_think( eNode )
{
	self endon( "death" );
	self pushplayer( true );
	self setthreatbiasgroup ( "oblivious" );
	/*-----------------------
	SETUP FOR EACH AI
	-------------------------*/		
	if ( self == level.hostage )
	{
		self.disablearrivals = true;
	}
	else
	{
		self disable_ai_color();
		self.disablearrivals = true;
	}

	self setgoalpos( self.origin );		
		
	/*-----------------------
	HOSTAGE COWERS IN CORNER
	-------------------------*/		
	if ( self == level.hostage )
	{
		level.nodeFreefall thread anim_loop_solo( self, "airplane_end_VIP_idle", undefined, "stop_idle" );
		flag_set( "hostage_idling_for_freefall" );
	}
	/*-----------------------
	PRICE GETS INTO POSITION
	-------------------------*/		
	else
	{
		level.nodeFreefall anim_reach_solo( self, "airplane_end_VIP_start" );
	}

	level.freefallersReady++;
	/*-----------------------
	ALL AI IN POSITION AND DOOR BLOWN
	-------------------------*/		
	flag_wait( "hostage_idling_for_freefall" );
	flag_wait( "exit_door_blown" );

	while ( level.freefallersReady < 2 )
		wait( 0.05 );
	
	
	flag_wait_or_timeout( "player_near_freefall", 3 );
	flag_set( "freefallers_jumping" );
	//wait(1);
	if ( self == level.hostage )
		level.nodeFreefall notify( "stop_idle" );
		
	/*-----------------------
	PLAY FREEFALL
	-------------------------*/			
	level.nodeFreefall anim_single_solo( self, "airplane_end_VIP" );	
	flag_set( "hostage_jumped_out" );
	
	if ( isdefined( self.magic_bullet_shield ) )
		self stop_magic_bullet_shield();
	self delete();
}

freefall()
{
	flag_wait( "human_shield_over" );
	
	//thread clouds();
	thread friendly_blows_door();
	wait(1);
	musicplaywrapper( "airplane_freefall_prep_music" );
	level thread timer_logic( 30, &"AIRPLANE_TIME_TILL_EXPLOSION", true );
	thread bomb_think();

	/*-----------------------
	FRIENDLY BLOWS EXIT
	-------------------------*/			
	flag_wait( "exit_door_blown" );
	flag_set( "obj_freefall_given" );
	thread exit_door_fx();
	
	/*-----------------------
	FRIENDLIES HAVE JUMPED OUT
	-------------------------*/			
	//flag_wait( "friendlies_jumped" );
	trig_exit_door = getent( "trig_exit_door", "targetname" );
	trig_exit_door waittill ( "trigger" );
	thread white_flash();
	level.player disableweapons();
	/*-----------------------
	PLAYER JUMPS OUT
	-------------------------*/	
	//thread end_music();
	thread freefall_camerashake();
	//flag_set( "obj_freefall_complete" );
	flag_set( "player_jumped_out" );
	thread killtimer();
	thread saveTime();
	AmbientStop( 1 );
	level.player thread play_sound_on_entity( "airplane_jump_whoosh" );
	wait(.5);
	level.player_sound_org = spawn( "script_origin", level.player.origin + ( 0, 0, 32 ) );
	level.player_sound_org linkto(level.player);
	level.player_sound_org playLoopSound( "airplane_wind_loop" );

	
	/*-----------------------
	PLAYER FALL LOGIC
	-------------------------*/			
	fraction = 1;
	right_arc = 1;
	left_arc = 1;
	top_arc = 1;
	bottom_arc = 1;
	
	org_player_freefall = getent( "org_player_freefall", "targetname" );
	fLerpTime = .2;
	
	flag_wait( "white_done" );
	//lerp_player_view_to_position( org_player_freefall.origin, org_player_freefall.angles, fLerpTime, fraction, right_arc, left_arc, top_arc, bottom_arc );
	//wait( fLerpTime );
	
	level.player SetPlayerAngles( org_player_freefall.angles );
	level.player SetOrigin( org_player_freefall.origin );
	level.player linkto ( org_player_freefall );
	
	org_player_freefall2 = getent( org_player_freefall.target, "targetname" );
	fLerpTime = 4;

	thread plane_explodes();
	level.player unlink();
	lerp_player_view_to_position( org_player_freefall2.origin, org_player_freefall2.angles, fLerpTime, fraction, right_arc, left_arc, top_arc, bottom_arc );
	level.player linkto ( org_player_freefall2 );
}

saveTime()
{
	if ( isdefined( level.timeToVipMessage ) )
		logString( level.timeToVipMessage );
}

white_flash()
{
	white_overlay = create_overlay_element( "white", 0 );
	white_overlay fadeOverTime( .5 );
	white_overlay.alpha = 1;
	wait( 1 );
	flag_set( "white_done" );
	white_overlay fadeOverTime( 1 );
	white_overlay.alpha = 0;
}

exit_door_fx()
{
	array_thread(level.fxExitDoor, ::restartEffect);	
	exit_org1 = getent( "exit_org1", "targetname" );
	exit_org2 = getent( "exit_org2", "targetname" );
	exit_org1 playLoopSound( "airplane_wind_loop" );
	wait(1);
	exit_org2 playLoopSound( "airplane_wind_loop" );
	flag_wait( "plane_explodes" );
	exit_org1 stopLoopSound( "airplane_wind_loop" );
	exit_org2 stopLoopSound( "airplane_wind_loop" );
	level.player_sound_org stopLoopSound( "airplane_wind_loop" );
}

end_music()
{
	musicstop(1);
	wait(1.5);
	musicplaywrapper( "airplane_end_music" );
}

plane_explodes()
{
	wait(1.8);
	flag_set( "plane_explodes" );
	/*-----------------------
	PLANE EXPLODES
	-------------------------*/	
	exploder(1);
	thread end_sound_start();
	musicstop(1);
	wait(1.5);
	
	/*-----------------------
	CUT TO BLACK
	-------------------------*/		
	flag_set( "cut_to_black" );
	black_overlay = create_overlay_element( "black", 0 );
	black_overlay fadeOverTime( .1 );
	black_overlay.alpha = 1;
	
	level.player_sound_org StopSounds();
	wait(.1);
	level.player_sound_org delete();
	
	wait(2.5);
	nextmission();
}

end_sound_start()
{
	thread end_sound_stop();
	level.player playLocalSound( "airplane_final_explosion" );
	//thread play_sound_in_space ( "airplane_final_explosion", level.nodeFreefall.origin );
}

end_sound_stop()
{
	flag_wait( "cut_to_black" );
	AmbientStop();
	//level.player StopLocalSound( "airplane_final_explosion" );
	//level.player StopLocalSound( "airplane_final_explosion_dist" );
	//level.player StopLocalSound( "airplane_final_explosion_close" );
	
	if ( getdvar("arcademode") != "1" )
		level.player Shellshock( "nosound", 60, false );
}
//
//clouds()
//{
//	clouds = getentarray( "clouds", "script_noteworthy" );
//	for(i=0;i<clouds.size;i++)
//	{
//		sEffectName = "clouds" + i;
//		sEffectName = spawnFx( getfx("cloud"), clouds[i].origin );
//		triggerFx( sEffectName );
//	}		
//}

friendly_blows_door()
{
	org_exit_door = getent( "org_exit_door", "targetname" );
	node = getnode( "node_door", "targetname" );
	c4 = getent( "c4_door", "targetname" );
	level.grigsby disable_ai_color();
	level.grigsby.ignoreme = true;
	level.grigsby.goalradius = 32;
	level.grigsby pushplayer( true );
	node anim_reach_solo( level.grigsby, "C4_plant_start" );
	flag_set( "exit_door_about_to_blow" );
	level.grigsby allowedstances("crouch");
	wait(2);
	c4 show();
	level.grigsby allowedstances("crouch", "stand", "prone" );
	level.grigsby.goalradius = 32;
	node = getnode( "node_door_cover", "targetname" );
	level.grigsby setgoalnode( node );
	level.grigsby waittill_notify_or_timeout( "goal", 3 );
	//level.grigsby waittill( "goal" );
	exploder(100);
	earthquake( 0.5, 3, org_exit_door.origin, 3000);
	c4 delete();
	level.player thread play_sound_on_entity( "fuselage_breach_explosion" );
	flag_set( "exit_door_blown" );
}

freefall_camerashake()
{
	level notify( "stop_airplane_destabilize" );
	while ( !flag( "plane_explodes" ) )
	{
		earthquake( .2, .05, level.player.origin, 80000);
		wait(.05);
	}
	while ( true )
	{
		earthquake( .5, .05, level.player.origin, 80000);
		wait(.05);
	}
}

/****************************************************************************
    UTILITY FUNCTIONS
****************************************************************************/ 

AA_utility()
{
	
}

dialogue_move()
{
	flag_wait( "bathroom_guy_dead" );
	wait(10);
	while( !flag( "player_approach_human_shield" ) )
	{
		sas_dialogue_random( "keepmoving" );
		wait(randomintrange(10, 20));
	}	
}

dialogue_clear()
{
	
}

sas_dialogue_random( sType )
{
	if ( level.peopleSpeaking == true )
		return;

	sDialogue = undefined;
	sLine = undefined;
	iNumber = undefined;
	bExecuteLine = true;
	
	switch( sType )
	{
		case "keepmoving":
			sLine = "airplane_gaz_keepmoving_";
			iNumber = randomIntRange(1, level.dialogueMoveLines + 1);
			break;
		case "hostiledown":
			sLine = "airplane_killfirm_";
			iNumber = randomIntRange(1, level.dialogueHostileDown + 1);
			bExecuteLine = can_say_hostiledown();
			break;
		case "areaclear":
			sLine = "airplane_areaclear_";
			iNumber = randomIntRange(1, level.dialogueAreaClear + 1);
			break;
		default:
			assertmsg( "Not a valid dialogue type: " + sType );
	}
	sDialogue = sLine + iNumber;
	assertEx( isdefined(level.scr_radio[sDialogue]), "This dialogue line does not exist: " + sDialogue );
	
	if ( bExecuteLine == true )
		level thread radio_dialogue_queue( sDialogue );
}

can_say_hostiledown()
{
	if ( level.hostileDownBeingSpoken == true )
		return false;
	else
	{
		thread hostile_down_timer();
		return true;
	}
}


hostile_down_timer()
{
	if ( level.hostileDownBeingSpoken == true )
		return;
		
	level.hostileDownBeingSpoken = true;
	wait(level.TimeBetweenHostileDown);
	level.hostileDownBeingSpoken = false;
}


airmasks()
{
	aAirmasks = getentarray( "airmask", "targetname" );
	array_thread( aAirmasks,::airmask_think );

	aAirmask_breach = getentarray( "airmask_breach", "targetname" );
	array_thread( aAirmask_breach,::airmask_breach_think );
}

airmask_think()
{
	self.dummy = spawn( "script_origin", self.origin + ( 0, 0, 30 ) );
	self.dummy.angles = level.org_view_roll.angles;
	level.aRollers = array_add( level.aRollers, self.dummy );
	self linkto ( self.dummy );
	self.dummy movez(45, .1);
	self hide();
	flag_wait( "fuselage_breached" );
	
	if ( getdvar( "airmasks" ) == "0" )
		return;
	
	self show();
	iTime = randomfloatrange( .75, 1.2 );
	self.dummy movez(-55, iTime, iTime/3, iTime/3 );
	wait( iTime );
	self.dummy movez(10, iTime/2);
	wait( iTime/2 );
	
	wait(randomfloatrange(.3,.9));
	dist = -0.5;
	while( true )
	{
		wait(0.05);
		prof_begin("masks");
		self.dummy movez(dist, .05);
		if ( dist == -0.5 )
			dist = 0.5;
		else
			dist = -0.5;
		prof_end("masks");
	}
}

airmask_breach_think()
{
	self.dummy = spawn( "script_origin", self.origin );
	self.dummy.angles = level.org_view_roll.angles;
	self linkto ( self.dummy );
	self.dummy movez(45, .1);
	self hide();
	
	flag_wait( "fuselage_breached" );

	if ( getdvar( "airmasks" ) == "0" )
		return;
	
	self show();
	iTime = randomfloatrange( .75, 1.2 );
	self.dummy movez(-45, iTime, iTime/3, iTime/3 );
	wait(randomfloatrange(.3,.9));
	angle = -5;
	while( true )
	{
		wait(0.05);
		prof_begin("masks");
		self.dummy rotateroll( angle, .05);
		if ( angle == -5 )
			angle = 5;
		else
			angle = -5;
		prof_end("masks");
	}
}

obj_rescue_vip()
{
	flag_wait("obj_rescue_vip_given");
	objective_number = 1;
	
	obj_position1 = getent ( "obj_rescue_vip1", "targetname" );
	assert(isdefined(obj_position1));
	objective_add( objective_number, "active", &"AIRPLANE_OBJ_RESCUE_VIP", obj_position1.origin );
	objective_current ( objective_number );
	
	flag_wait( "player_up_breach_stairs" );
	
	obj_position2 = getent ( "obj_rescue_vip2", "targetname" );
	assert(isdefined(obj_position2));
	Objective_Position( objective_number, obj_position2.origin );
	
	flag_wait ( "obj_rescue_vip_complete" );
	
	objective_state ( objective_number, "done" );	
}

obj_freefall()
{
	flag_wait("obj_freefall_given");
	objective_number = 2;
	
	obj_position = getent ( "obj_freefall", "targetname" );
	objective_add( objective_number, "active", &"AIRPLANE_OBJ_FREEFALL", obj_position.origin );
	objective_current ( objective_number );

	flag_wait ( "obj_freefall_complete" );
	
	objective_state ( objective_number, "done" );	
}

weapon_detect()
{
	level endon( "enemies_alerted" );
	trig = getent( "intro_damage", "targetname" );
	trig waittill( "trigger" );
	if ( !flag( "enemies_alerted" ) )
		flag_set( "enemies_alerted" );
}

flashbang_detect()
{
	level endon ( "enemies_alerted" );

	while (true)
	{
		wait(0.05);
		aFlashGrenades = getentarray ("grenade", "classname");
		for(i=0;i<aFlashGrenades.size;i++)
		{
			if ( (aFlashGrenades[i].model == "projectile_us_smoke_grenade") || (aFlashGrenades[i].model == "projectile_m84_flashbang_grenade") )
			{
				wait(2);
				if ( !flag( "enemies_alerted" ) )
					flag_set( "enemies_alerted" );
			}
		}
	}
}

player_breach_jump()
{
	level.player endon( "death" );
	flag_wait( "player_breach_jump" );
	level notify ( "mission failed" );	
	thread killTimer();
	level notify ( "kill_timer" );
	setDvar("ui_deadquote", &"AIRPLANE_FAILED_JUMPED_OUT" );
	maps\_utility::missionFailedWrapper();
	
	level.player dodamage( level.player.health + 1000, level.player.origin );
}	

no_grenade_death_hack()
{
	//can't have any AI doing grenade death since they have no grenades
	while( true )
	{
		anim.nextCornerGrenadeDeathTime = gettime() + 60*1000 * 5; wait 60;
	}
}

gravity_shift( degrees )
{
	level endon("stop_gravity_shift");
	
	setsaveddvar("phys_gravityChangeWakeupRadius", 1600);
	
	if(isdefined (degrees))
	{
		ang = (0,0,degrees);
		vec1 = vector_multiply( anglestoup( ang ), -1 );
		vec2 = vector_multiply( anglestoright( ang ), .25);
		vec = vec1 + vec2;
		setPhysicsGravityDir( vec );		
	}
}


gravity_shift2( degrees )
{
	level endon("stop_gravity_shift");
	
	setsaveddvar("phys_gravityChangeWakeupRadius", 1600);
	
	if(isdefined (degrees))
	{
		ang = (0,0,degrees);
		vec1 = vector_multiply( anglestoup( ang ), -1 );
		vec2 = vector_multiply( anglestoright( ang ), .25);
		vec = vec1 + vec2;
		setPhysicsGravityDir( vec );		
	}
	while(1)
	{
		wait .05;
		vec1 = vector_multiply( anglestoup( level.org_view_roll.angles ), -1 );
		vec2 = vector_multiply( anglestoright( level.org_view_roll.angles ), .25);
		vec = vec1 + vec2;
		setPhysicsGravityDir( vec );
	}
}

create_playerview( ent )
{
	assert(isdefined(ent));
	if ( isdefined( level.ePlayerview ) )
		level.ePlayerview delete();
	level.ePlayerview = spawn_anim_model( "player_view" );
	level.ePlayerview hide();
	level.ePlayerview.origin = ent.origin;
	level.ePlayerview.angles = ent.angles;
	level.ePlayerview linkto(ent);
}

door_open_double( aDoorEnts )
{
	left_door = undefined;
	right_door = undefined;
	knobs_left = [];
	knobs_right = [];
	fx_org = undefined;

	/*-----------------------
	SETUP EACH PART OF THE DOOR
	-------------------------*/			
	for(i=0;i<aDoorEnts.size;i++)
	{
		ent = aDoorEnts[i];
		assert( isdefined( ent.script_noteworthy ));
		switch ( ent.script_noteworthy )
		{
			case "left":
				left_door = ent;
				break;
			case "right":
				right_door = ent;
				break;
			case "knobs_left":
				knobs_left = array_add( knobs_left, ent );
				break;
			case "knobs_right":
				knobs_right = array_add( knobs_right, ent );
				break;
			case "door_fx":
				fx_org = ent;
				break;
		}
	}

	/*-----------------------
	ATTACH KNOBS
	-------------------------*/		
	assert(isdefined(left_door));
	assert(isdefined(right_door));
	assert(isdefined(fx_org));
	assert( knobs_left.size == 2 );
	assert( knobs_right.size == 2 );		
	for(i=0;i<knobs_left.size;i++)
		knobs_left[i] linkto( left_door );
	for(i=0;i<knobs_right.size;i++)
		knobs_right[i] linkto( right_door );	
		
	/*-----------------------
	OPEN DOORS
	-------------------------*/		
	thread play_sound_in_space( "wood_door_kick", fx_org.origin );
	playfx( getfx( "door_kick_dust" ), fx_org.origin );

	fTime = 0.6;
	left_door rotateyaw(-165, fTime, 0, fTime/2 );
	right_door rotateyaw(175, fTime, 0, fTime/2 );
	left_door connectpaths();
	right_door connectpaths();
	left_door movex( 2, fTime );
	right_door movex( 2, fTime );

}

bathroom_door_open( doorLeft, doorRight )
{
	thread bathroom_dude_clear();
	blocker_bathroom_door = getent( "blocker_bathroom_door", "targetname" );
	
	blocker_bathroom_door hide();
	blocker_bathroom_door notsolid();
	blocker_bathroom_door connectpaths();

	door1 = getent( doorLeft, "targetname" );
	door2 = getent( doorRight, "targetname" );
	assert( isdefined( door1 ) );
	assert( isdefined( door2 ) );
	
	thread play_sound_in_space( "airplane_bathroom_door_open", door1.origin );
	fTime = 1;
	door1 rotateyaw(90, fTime, fTime/2, fTime/2 );
	door1 movey( 1, fTime );
	door1 connectpaths();

	door2 rotateyaw(-90, fTime, fTime/2, fTime/2 );
	door2 connectpaths();
	door2 movex( 25, fTime );

	wait(2);
	
	flag_wait( "bathroom_dude_clear" );
	bathroom_volume = getent( "bathroom_volume", "targetname" );
	badplace_brush("badplace_bathroom", 0, bathroom_volume, "allies", "axis");
	
	assert( isdefined( bathroom_volume ) );
	while ( true )
	{
		wait( 0.05 );
		if ( !level.player istouching( bathroom_volume ) )
			break;
	}
	
	thread play_sound_in_space( "airplane_bathroom_door_close", door1.origin );
	blocker_bathroom_door show();
	blocker_bathroom_door solid();
	blocker_bathroom_door disconnectpaths();
	
	door1 rotateyaw(-90, fTime, fTime/2, fTime/2 );
	door1 disconnectpaths();

	door2 rotateyaw(90, fTime, fTime/2, fTime/2 );
	door2 disconnectpaths();
	door2 movex( -25, fTime );	
	
	badplace_delete( "badplace_bathroom" );
}

bathroom_dude_clear()
{
	trig = getent( "bathroom_dude_clear", "targetname" );
	while ( !flag( "bathroom_dude_clear" ) )
	{
		trig waittill( "trigger", other);
		if ( ( isdefined( other) ) && ( other == level.hostile_bathroom ) )
			flag_set( "bathroom_dude_clear" );
	}
}

airplane_destabilize()
{
	level endon( "stop_airplane_destabilize" );
	flag_wait( "fuselage_breached" );
	
	while ( true )
	{
		earthquake( .15, .05, level.player.origin, 80000);
		wait(.05);
	}
}

fx_management()
{
	//level.fxBreachLeaks = getfxarraybyID( "fuselage_breach_airleak1" );
	//level.fxBreachLeaks = array_combine(level.fxBreachLeaks, getfxarraybyID( "fuselage_breach_airleak2" ));
	
	level.fxExitDoor = getfxarraybyID( "exit_door_dust" );
	level.fxExitDoor = array_combine(level.fxExitDoor, getfxarraybyID( "exit_door_wind_suck" ));
	
	wait(.5);
	
	//array_thread(level.fxBreachLeaks, ::pauseEffect);
	array_thread(level.fxExitDoor, ::pauseEffect);
}

timer_start()
{
	if ( getdvar( "notimer" ) == "1" )
		return;
	dialogue_line = undefined;
	iSeconds = undefined;
	switch( level.gameSkill )
	{
		case 0: //easy
			iSeconds = 180;
			break;
		case 1://regular
			iSeconds = 150;
			break;
		case 2://hardened
			iSeconds = 105;
			break;
		case 3://veteran
			iSeconds = 60;
			break;	
	}
	assert(isdefined(iSeconds));

	level thread timer_logic( iSeconds, &"AIRPLANE_TIME_TO_LOCATE_VIP" );
	level.timer_start_time = gettime();
}

timer_logic( iSeconds, sLabel, bUseTick )
{
	
	if ( getdvar( "notimer" ) == "1" )
		return;
	
	if ( !isdefined( bUseTick ) )
		bUseTick = false;
	// destroy any previous timer just in case
	killTimer();
	level endon ( "kill_timer" );

	/*-----------------------
	TIMER SETUP
	-------------------------*/		
	level.hudTimerIndex = 20;
	level.timer = maps\_hud_util::get_countdown_hud(-250);
	level.timer SetPulseFX( 30, 900000, 700 );//something, decay start, decay duration
	level.timer.label = sLabel;
	level.timer settenthstimer( iSeconds );
	level.start_time = gettime();
	
	/*-----------------------
	TIMER EXPIRED
	-------------------------*/	
	if ( bUseTick == true )
		thread timer_tick();
	wait ( iSeconds );
	
	flag_set ( "timer_expired" );
	level.timer destroy();
	level thread mission_failed_out_of_time( &"AIRPLANE_TIMER_EXPIRED" );
}

hostage_timer_cleanup()
{
	flag_wait_either( "terrorist_killed", "terrorist_wounded" );
	killTimer();
}

hostage_timer( iSeconds )
{
	if ( getdvar( "notimer" ) == "1" )
		return;
	
	if ( isdefined( level.start_time ) )
	{
		level.timeToReachVip = ( ( gettime() - level.start_time ) / 1000 );
		level.timeToVipMessage = "Airplane - difficulty " + level.gameskill + ": Time to hostage sequence: ( " + level.timeToReachVip + " seconds )";
		if ( getdvar( "airplane_debug" ) == "1" )
			println( level.timeToVipMessage );
	}
	
	if ( level.gameskill != 3 ) 
		thread autosave_now( "hostage", true );
	
	level endon( "human_shield_over" );
	killTimer();
	level endon ( "kill_timer" );

	/*-----------------------
	TIMER SETUP
	-------------------------*/		
	level.hudTimerIndex = 20;
	level.timer = newHudElem();
	level.timer.alignX = "center";
	level.timer.alignY = "middle";
	level.timer.horzAlign = "center";
    level.timer.vertAlign = "top";
    //level.timer.x = -225;
   	level.timer.y = 100;
  	level.timer.fontScale = 1.6;
	level.timer.color = (0.8, 1.0, 0.8);
	level.timer.font = "objective";
	level.timer.glowColor = (0.3, 0.6, 0.3);
	level.timer.glowAlpha = 1;
	level.timer SetPulseFX( 30, 900000, 700 );//something, decay start, decay duration
 	level.timer.hidewheninmenu = true;
	level.timer.label = &"AIRPLANE_TIME_TILL_HOSTAGE_KILL";
	level.timer settenthstimer( iSeconds );
	
	thread hostage_timer_cleanup();
	/*-----------------------
	TIMER EXPIRED
	-------------------------*/	
	thread timer_tick();
	wait ( iSeconds );
	
	flag_set ( "hostage_timer_expired" );
	level.timer destroy();
	level thread mission_failed_out_of_time( &"AIRPLANE_HOSTAGE_TIMER_EXPIRED" );
}

timer_tick()
{
	level endon( "stop_timer_tick" );
	level endon( "kill_timer" );
	while ( true )
	{
		wait(1);
		level.player thread play_sound_on_entity ( "countdown_beep" );
		level notify( "timer_tick" );
	}
}

mission_failed_out_of_time( deadquote )
{
	level.player endon ( "death" );
	level endon ( "kill_timer" );
	level notify ( "mission failed" );	
	level.player freezeControls( true );
	level.player thread player_death_effect();
	level.player thread play_sound_on_entity( "airplane_final_explosion" );
	musicstop(1);
	setDvar("ui_deadquote", deadquote );
	maps\_utility::missionFailedWrapper();	
	level notify ( "kill_timer" );
}

player_death_effect()
{
	player = getent("player","classname");
	playfx ( level._effect["player_death_explosion"], player.origin );

	earthquake( 1, 1, level.player.origin, 100);
}

killTimer()	
{
	level notify ( "kill_timer" );
	if (isdefined (level.timer))
		level.timer destroy();		
}


AI_think(guy)
{
	/*-----------------------
	RUN ON EVERY DUDE THAT SPAWNS
	-------------------------*/		
	if ( ( isdefined( guy.script_parameters )) && ( guy.script_parameters == "scripted" ) )
		return;
	if (guy.team == "axis")
		guy thread AI_axis_think();
	
	if (guy.team == "allies")
		guy thread AI_allies_think();

}

AI_allies_think()
{
	self.animname = "frnd";
	self setFlashbangImmunity( true );
	self enable_cqbwalk();
	if ( !isdefined( self.magic_bullet_shield ) )
		self thread magic_bullet_shield();
	self.a.disablePain = true;
	switch( level.gameSkill )
	{
		case 0: //easy
			//self.baseaccuracy = 1000;
			break;
		case 1://regular
			//self.baseaccuracy = 1000;
			break;
		case 2://hardened
			break;
		case 3://veteran
			//self.baseaccuracy = 2;
			break;	
	}
}

AI_civilian_think()
{
	eNode = getent( self.target, "targetname" );
	assert( isdefined( eNode) );
	sAnim = eNode.script_noteworthy;
	assertex( isdefined( level.scr_anim[ "generic" ][ sAnim ], "There is no animation defined named: " + sAnim ) );

	guy = maps\_vehicle_aianim::convert_guy_to_drone( self );
	guy.allowdeath = false;
	guy.NoFriendlyfire = true;
	maps\_vehicle_aianim::detach_models_with_substr( guy, "weapon_" );
	guy.ignoreme = true;
	if ( !isdefined( guy.magic_bullet_shield ) )
		guy thread magic_bullet_shield();
	eNode thread anim_generic_loop( guy, sAnim, undefined, "stop_idle" );	
}

AI_patroller()
{
	self endon ( "death" );
	self thread AI_patroller_damage();
	self thread AI_patroller_death();
	level endon ( "enemies_alerted" );
	while ( !flag( "enemies_alerted" ) )
	{
		wait (0.05);

		if ( flag( "enemies_alerted" ) )
			break;
		waittill_player_in_range( self.origin, level.sightDetectDistance );

		if ( flag( "enemies_alerted" ) )
			break;
			
					
		if ( self CanSee( level.player ) )
		{
			if ( !flag( "enemies_alerted" ) )
				flag_set( "enemies_alerted" );
		}		

		if ( distance(self.origin, level.player.origin ) <= level.alertDistance )
			if ( bullettracepassed( level.player getEye(), self.origin + (0, 0, 48), false, undefined ) )
			{
				if ( !flag( "enemies_alerted" ) )
					flag_set( "enemies_alerted" );
			}	
	}	
}

AI_patroller_damage()
{
	level endon ( "enemies_alerted" );
	self endon( "death" );
	self waittill( "damage" );
	if ( !flag( "enemies_alerted" ) )
		flag_set( "enemies_alerted" );
}

AI_patroller_death()
{
	level endon ( "enemies_alerted" );
	self waittill( "death" );
	if ( !flag( "enemies_alerted" ) )
		flag_set( "enemies_alerted" );
}

AI_axis_think()
{
	self.animname = "hostile";
	self thread AI_flashbang_detect();
	
	if (!flag( "player_approach_human_shield" ) )
		self thread AI_Axis_death_think();
	//self.grenadeammo = 0;
}

AI_Axis_death_think()
{
	if ( ( isdefined( level.hostile_bathroom ) ) && ( self == level.hostile_bathroom ) )
		return;
	self waittill( "death");
	wait(1);
	
	if ( level.firstAxisKilled == false )
	{
		level.firstAxisKilled = true;
		level thread radio_dialogue_queue( "airplane_first_hostile_killed_1" );	//Tango down in section one alpha.	
	}
	else
		level thread sas_dialogue_random( "hostiledown" );
}
	
AI_flashbang_detect()
{
	self endon( "death" );
	if ( flag( "enemies_alerted" ) )
		return;

	self waittill( "flashbang" );
	if ( !flag( "enemies_alerted" ) )
		flag_set( "enemies_alerted" );
}

AI_drone_think()
{

}

initPrecache()
{
	precacheShellshock( "nosound" );
	precachestring( &"AIRPLANE_TIME_TILL_EXPLOSION" );
	precachestring( &"AIRPLANE_TIME_TO_LOCATE_VIP" );
	precachestring( &"AIRPLANE_TIMER_EXPIRED" );
	precachestring( &"AIRPLANE_FAILED_JUMPED_OUT" );
	precachestring( &"AIRPLANE_OBJ_RESCUE_VIP" );
	precachestring( &"AIRPLANE_OBJ_FREEFALL" );
	precachestring( &"AIRPLANE_TIME_TILL_HOSTAGE_KILL" );
	precachestring( &"AIRPLANE_HOSTAGE_NO_HEADSHOT" );
	
	
	precacheModel( "viewhands_player_usmc" );
	
	precacheItem( "facemask" );
	precacheShader( "black" );
	precacheShader( "white" );
}

disable_color_trigs()
{
	array_thread(level.aColornodeTriggers, ::trigger_off);
}

//PlayerMaskPuton()
//{
//	orig_nightVisionFadeInOutTime = GetDvar( "nightVisionFadeInOutTime" );
//	orig_nightVisionPowerOnTime = GetDvar( "nightVisionPowerOnTime" );
//	SetSavedDvar( "nightVisionPowerOnTime", 0.5 );
//	SetSavedDvar( "nightVisionFadeInOutTime", 0.5 );
//	SetSavedDvar( "overrideNVGModelWithKnife", 1 );
//	SetSavedDvar( "nightVisionDisableEffects", 1 );
//
//	wait( 0.01 ); //give the knife override a frame to catch up
//	level.player ForceViewmodelAnimation( "facemask", "nvg_down" );
//	wait( 2.0 );
//	SetSavedDvar( "hud_gasMaskOverlay", 1 );
//	wait( 2.5 );
//
//	SetSavedDvar( "nightVisionDisableEffects", 0 );
//	SetSavedDvar( "overrideNVGModelWithKnife", 0 );
//	SetSavedDvar( "nightVisionPowerOnTime", orig_nightVisionPowerOnTime );
//	SetSavedDvar( "nightVisionFadeInOutTime", orig_nightVisionFadeInOutTime );
//}

initFriendlies(sStartPoint)
{
	waittillframeend;
	assert(isdefined(sStartPoint));
		
	level.squad = [];
	level.price = spawn_script_noteworthy( "price" );
	level.grigsby = spawn_script_noteworthy( "grigsby" );
	level.macey = spawn_script_noteworthy( "macey" );
	level.squad[0] = level.price;
	level.squad[1] = level.grigsby;
	level.squad[2] = level.macey;

	/*-----------------------
	WARP HEROES TO CORRECT POSITIONS
	-------------------------*/		
	aFriendlies = level.squad;
	warpNodes = getnodearray("nodeStart_" + sStartPoint, "targetname");
	assertEx( warpNodes.size == 4, "Need exactly 4 nodes with targetname: nodeStart_" + sStartPoint);
	iKeyFriendlies = 0;
	playerNode = undefined;
	while (iKeyFriendlies < 4)
	{
		wait (0.05);
		for(i=0;i<warpNodes.size;i++)
		{
			if (isdefined(warpNodes[i].script_noteworthy))
			{
				switch (warpNodes[i].script_noteworthy)
				{
					case "nodePrice":
						level.price start_teleport ( warpNodes[i] );
						aFriendlies = array_remove(aFriendlies, level.price);
						warpNodes = array_remove(warpNodes, warpNodes[i]);
						iKeyFriendlies ++;
						break;
					case "nodeGrigsby":
						level.grigsby start_teleport ( warpNodes[i] );
						aFriendlies = array_remove(aFriendlies, level.grigsby);
						warpNodes = array_remove(warpNodes, warpNodes[i]);
						iKeyFriendlies ++;
						break;
					case "nodeMacey":
						level.macey start_teleport ( warpNodes[i] );
						aFriendlies = array_remove(aFriendlies, level.macey);
						warpNodes = array_remove(warpNodes, warpNodes[i]);
						iKeyFriendlies ++;
						break;
					case "nodePlayer":
						playerNode = warpNodes[i];
						warpNodes = array_remove(warpNodes, warpNodes[i]);
						iKeyFriendlies ++;
						break;
					default:
						assertmsg( "node has invalid name for initFriendlies() function: " + warpNodes[i].script_noteworthy );
						break;
				}
			}	
		}		
	}

	/*-----------------------
	WARP PLAYER LAST SO HE DOESN'T SEE
	-------------------------*/	
	flag_wait( "intro_fade_in_complete" );
	assert(isdefined(playerNode));	
	level.player setorigin ( playerNode.origin );
	level.player setplayerangles ( playerNode.angles );

}



/****************************************************************************
    DEMO FUNCTIONS
****************************************************************************/ 
demo_setup()
{
	
	flag_init("heroes_ready");
	flag_init("part1");
	flag_init("part2");
	flag_init("part3");
	flag_init("part4");
	flag_init("part5");
	
	flag_set("part1");
	flag_set("part2");
	flag_set("part3");
	flag_set("part4");
	flag_set("part5");
	
	trigger = getent("demo_spawners","target");
	trigger notify("trigger");
			
	wait .1;
	ai = getaiarray("allies");
	
	level.heroes = [];
	
	for(i=0; i<ai.size; i++)
	{
		switch( ai[i].script_noteworthy )
		{
			case "demo_alavi":
				level.heroes[ "alavi" ]	= ai[i];
				break;
			case "demo_price":
				level.heroes[ "price" ]	= ai[i];
				break;
			case "demo_grigsby":
				level.heroes[ "grigsby" ] = ai[i];
				break;
		}
	}
	battlechatter_off();
	flag_set("heroes_ready");
}

demo_walkthrough()
{
	flag_wait("heroes_ready");
	
	keys = getarraykeys(level.heroes);
	for(i=0; i<keys.size; i++)
	{
		key = keys[ i ];
		level.heroes[ key ] enable_cqbwalk();
		level.heroes[ key ].interval = 60;
		level.heroes[ key ].disableexits = true;
	}
	
	delays = [];
	delays[ "alavi" ]	= .85;
	delays[ "grigsby" ]	= 0;
	delays[ "price" ]	= .5;
	
	thread hallways_heroes("part1", "nothing", undefined, delays);
	
	wait 4.25; 
	level.heroes[ "price" ] handsignal("onme");
	//hallways_heroes("part2", "nothing", undefined, delays);
}

hallways_heroes(name, _flag, msgs, delays, exits)
{
	if( !isdefined(msgs) )
	{
		msgs = [];
		msgs["alavi"] 	= undefined;
		msgs["grigsby"] = undefined;
		msgs["price"] 	= undefined;
	}
	
	if( !isdefined(exits) )
	{
		exits = [];
		exits["alavi"] 	= undefined;
		exits["grigsby"] = undefined;
		exits["price"] 	= undefined;
	}
	
	if( !isdefined(delays) )
	{
		delays = [];
		delays["alavi"] 	= 0;
		delays["grigsby"] = 1;
		delays["price"] 	= 2;
	}
	
	keys = getarraykeys( level.heroes );
	
	for(i=0; i<keys.size; i++)
	{
		key = keys[ i ];
		level.heroes[ key ] delaythread(delays[ key ], ::hallways_heroes_solo, name, _flag, msgs[ key ], exits[ key ] );
	}
			
	level endon(_flag);
	
	array_wait(level.heroes, "hallways_heroes_ready");
	flag_wait(name);
}

hallways_heroes_solo(name, _flag, msg, exit)
{
	self pushplayer( true );
	level endon(_flag);
	
	//self.animplaybackrate = 1;
	
	nodes = getnodearray(name,"targetname");
	node = undefined;
	
	for(i=0; i<nodes.size;i++)
	{
		if( nodes[i].script_noteworthy == self.script_noteworthy )
		{
			node = nodes[i];
			break;	
		}
	}	
	
	while( isdefined( node ) )
	{
		self setgoalnode( node );
		if( node.radius )
			self.goalradius = node.radius;
		else
			self.goalradius = 80;
		
		if( isdefined( exit ) )
		{
			reenableexits = true;
			if(isdefined(self.disableexits) && self.disableexits == true)
				reenableexits = false;
			self.disableexits = true;
			ref = undefined;
			
			if( exit == "stand2run180" )
				ref = self;
			else if( isdefined(self.node) && distance(self.node.origin, self.origin) < 4 )
				ref = self.node;
			else if(isdefined(self.goodnode) && distance(self.goodnode.origin, self.origin) < 4)
				ref = self.goodnode;
			else
				ref = self;
				
			pos = spawn("script_origin", ref.origin);
			pos.angles = ref.angles;
			
			self.hackexit = pos;
			
			if( exit == "stand2run180" )
				pos.angles += (0,32,0);
			
			if(ref != self)
			{
				if( issubstr(exit, "cornerleft" ) )
					pos.angles += (0,90,0);
				else if( issubstr(exit, "cornerright" ) )
					pos.angles -= (0,90,0);
			}
				
			self.animname = "guy";
			length = getanimlength( level.scr_anim[ self.animname ][ exit ] );
			pos thread anim_single_solo(self, exit);		
			wait length - .2;
			self stopanimscripted();
			pos delete();
			exit = undefined;
			if(reenableexits)
				self.disableexits = false;
		}
		
		self waittill("goal");
		if( isdefined( node.script_parameters ) )
		{
			attr = strtok( node.script_parameters, ":;, " );
			for(j=0;j<attr.size; j++)
			{
				switch( attr[j] )
				{
					case "disable_cqb":
						if(isdefined(node.target))
							self disable_cqbwalk_ign_demo_wrapper();
						else
							self delaythread(1.5, ::disable_cqbwalk_ign_demo_wrapper);
						break;
					case "enable_cqb":
						if(isdefined(node.target))
							self enable_cqbwalk_ign_demo_wrapper();
						else
							self delaythread(1.5, ::enable_cqbwalk_ign_demo_wrapper);
						break;
				}
			}
		}	
	
		if( isdefined( node.target ) )
			node = getnode( node.target, "targetname" );
		else
			node = undefined;
	}
	
	
	self notify("hallways_heroes_ready");
}

decanim(rate)
{
	while(	self.animplaybackrate != rate )
	{
		self.animplaybackrate -= .05;
		wait .1;
	}	
}

disable_cqbwalk_ign_demo_wrapper()
{
	self disable_cqbwalk();
	self.interval = 96;
}

enable_cqbwalk_ign_demo_wrapper()
{
	self enable_cqbwalk();
	self.interval = 50;
}

