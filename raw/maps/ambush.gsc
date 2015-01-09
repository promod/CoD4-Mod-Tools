#include maps\_utility;
#include maps\_anim;
#include common_scripts\utility;
#include maps\_hud_util;

main()
{
	if ( getdvar( "r_reflectionProbeGenerate" ) == "1" )
		return;

	setsaveddvar( "sm_sunShadowScale", "0.7" ); // optimization

	add_start( "ambush", ::start_ambush, &"STARTS_AMBUSH" );
	add_start( "village", ::start_village, &"STARTS_VILLAGE");
	add_start( "morpheus", ::start_morpheus, &"STARTS_MORPHEUS");
	add_start( "apartment", ::start_apartment, &"STARTS_APARTMENT");

	default_start( ::start_default );

	createthreatbiasgroup( "player" );
	createthreatbiasgroup( "oblivious" );
	createthreatbiasgroup( "group1" );
	createthreatbiasgroup( "group2" );
	createthreatbiasgroup( "badguy" );

	maps\_bm21_troops::main( "vehicle_bm21_mobile_cover" );
	maps\_bmp::main( "vehicle_bmp_low" );
	maps\_blackhawk::main("vehicle_blackhawk");
	maps\_uaz::main( "vehicle_uaz_open" );
	maps\_vehicle::build_aianims( ::uaz_anims, ::uaz_vehicle_anims );

	precacheItem( "hunted_crash_missile" );

	precacheModel( "viewhands_op_force" );

	precacheTurret( "heli_minigun_noai" );
	
	precacheShader( "overlay_hunted_black" );
	precachestring(&"AMBUSH_OBJ_CHECKPOINT" );
	precachestring(&"AMBUSH_OBJ_GET_IN_POSITION" );
	precachestring(&"AMBUSH_OBJ_SECURE_CHECKPOINT" );
	precachestring(&"AMBUSH_TWO_HOURS_LATER" );
	precachestring(&"AMBUSH_OBJ_CAPTURE_TARGET" );
	precachestring(&"AMBUSH_OBJ_AMBUSH_CONVOY" );
	precachestring(&"AMBUSH_MISSIONFAIL_KILLED_TARGET" );
	precachestring(&"AMBUSH_MISSIONFAIL_STARTED_EARLY" );
	precachestring(&"AMBUSH_MISSIONFAIL_ESCAPED" );
	precachestring(&"AMBUSH_MISSIONFAIL_ESCAPED_WRONG_WAY" );
	precachestring(&"AMBUSH_INTROSCREEN_LINE_1" );
	precachestring(&"AMBUSH_INTROSCREEN_LINE_2" );
	precachestring(&"AMBUSH_INTROSCREEN_LINE_3" );
	precachestring(&"AMBUSH_INTROSCREEN_LINE_4" );
	precachestring(&"AMBUSH_INTROSCREEN_LINE_5" );
	
	level.weaponClipModels = [];
	level.weaponClipModels[0] = "weapon_m16_clip";
	level.weaponClipModels[1] = "weapon_mp5_clip";
	level.weaponClipModels[2] = "weapon_ak74u_clip";
	level.weaponClipModels[3] = "weapon_ak47_clip";
	level.weaponClipModels[4] = "weapon_dragunov_clip";
	level.weaponClipModels[5] = "weapon_g36_clip";
	level.weaponClipModels[6] = "weapon_saw_clip";
	level.weaponClipModels[7] = "weapon_g3_clip";

	maps\_load::set_player_viewhand_model( "viewhands_player_sas_woodland" );

	setup_flags();

	maps\ambush_fx::main();
	maps\_load::main();
	level thread maps\ambush_amb::main();
	maps\_compass::setupMiniMap("compass_map_ambush");

	maps\ambush_anim::main();

	maps\createart\ambush_art::main();

	animscripts\dog_init::initDogAnimations();

   level.vehicle_aianimthread[ "hide_attack_left" ] =	::guy_hide_attack_left;
   level.vehicle_aianimcheck[ "hide_attack_left" ] =	::guy_hide_attack_left_check;
   level.vehicle_aianimthread[ "escape" ] =	::guy_escape;
   level.vehicle_aianimcheck[ "escape" ] =	::guy_escape_check;

	setignoremegroup( "badguy", "allies" );	// allies ignore badguy
	setignoremegroup( "badguy", "axis" );	// axis ignore badguy

	// make oblivious ingnored and ignore by everything.
	setignoremegroup( "allies", "oblivious" );	// oblivious ignore allies
	setignoremegroup( "axis", "oblivious" );	// oblivious ignore axis
	setignoremegroup( "player", "oblivious" );	// oblivious ignore player
	setignoremegroup( "oblivious", "allies" );	// allies ignore oblivious
	setignoremegroup( "oblivious", "axis" );	// axis ignore oblivious
	setignoremegroup( "oblivious", "oblivious" );	// oblivious ignore oblivious

	level.bmpCannonRange = 2048;
	level.bmpMGrange = 1200;
	level.bmpMGrangeSquared = level.bmpMGrange * level.bmpMGrange;
	level.cosine["180"] = cos(180);
	level.ai_friendlyFireBlockDuration = getdvarfloat( "ai_friendlyFireBlockDuration" );

	level thread ambush_streetlight();
	level thread fixednode_trigger_setup();
	level.player thread grenade_notifies();
	level thread setup_vehicle_pause_node();
	level thread ambush_tower_fall();
	level thread detonate_car_setup();
	
	level thread music_control();

	// add respawn guys to the squad
	array_thread( getentarray( "respawn_guy", "script_noteworthy" ), ::add_spawn_function, ::generic_allied );

	level.sm_sunsamplesizenear = GetDvarFloat( "sm_sunsamplesizenear" );
}

#using_animtree( "vehicles" );   
uaz_vehicle_anims( positions )
{
	positions = maps\_uaz::set_vehicle_anims( positions );

//	positions[ 0 ].vehicle_getoutanim = undefined;
	positions[ 0 ].vehicle_getoutanim = %ambush_VIP_escape_UAZ;
	positions[ 0 ].vehicle_getoutanim_clear = false;

	return positions;
}

uaz_vehicle_anims_clear()
{
	self clearanim( %ambush_VIP_escape_UAZ, 0 );
}

#using_animtree( "generic_human" );   
uaz_anims()
{
	positions = maps\_uaz::setanims();

	positions[ 0 ].idle = %uaz_driver_idle_drive;
	positions[ 0 ].getout = %ambush_VIP_escape_son;

	positions[ 0 ].hide_attack_left = %UAZ_Lguy_fire_side_v1;
	positions[ 0 ].escape = %uaz_driver_idle_drive;

//	positions[ 2 ].idle = %uaz_passenger_idle_drive;
	positions[ 2 ].idle = %UAZ_Lguy_idle_hide;
	positions[ 2 ].hide_attack_left[0] = %UAZ_Lguy_standfire_side_v3;
	positions[ 2 ].hide_attack_left[1] = %UAZ_Lguy_standfire_side_v4;
	positions[ 2 ].hide_attack_left_occurrence[0] = 500;
	positions[ 2 ].hide_attack_left_occurrence[1] = 500;

	positions[ 2 ].escape[0] = %UAZ_Lguy_fire_side_v1;
	positions[ 2 ].escape[1] = %UAZ_Lguy_fire_side_v2;
	positions[ 2 ].escape_occurrence[0] = 500;
	positions[ 2 ].escape_occurrence[1] = 500;

	return positions;

}

guy_escape( guy, pos )
{
	guy endon( "newanim" );
	self endon( "death" );
	guy endon( "death" );
	animpos = maps\_vehicle_aianim::anim_pos( self, pos );
	
	assert( isdefined( animpos.escape ) );

	while ( 1 )
	{
		if ( isdefined( animpos.escape_occurrence ) )
		{
			theanim = maps\_vehicle_aianim::randomoccurrance( guy, animpos.escape_occurrence );
			maps\_vehicle_aianim::animontag( guy, animpos.sittag, animpos.escape[ theanim ] );
		}
		else
			maps\_vehicle_aianim::animontag( guy, animpos.sittag, animpos.escape );
	}
}

guy_escape_check( guy, pos )
{
	return isdefined( maps\_vehicle_aianim::anim_pos( self, pos ).escape );
}

guy_hide_attack_left( guy, pos )
{
	guy endon( "newanim" );
	self endon( "death" );
	guy endon( "death" );
	animpos = maps\_vehicle_aianim::anim_pos( self, pos );
	
	assert( isdefined( animpos.hide_attack_left ) );

	while ( 1 )
	{
		if ( isdefined( animpos.hide_attack_left_occurrence ) )
		{
			theanim = maps\_vehicle_aianim::randomoccurrance( guy, animpos.hide_attack_left_occurrence );
			maps\_vehicle_aianim::animontag( guy, animpos.sittag, animpos.hide_attack_left[ theanim ] );
		}
		else
			maps\_vehicle_aianim::animontag( guy, animpos.sittag, animpos.hide_attack_left );
	}
}

guy_hide_attack_left_check( guy, pos )
{
	return isdefined( maps\_vehicle_aianim::anim_pos( self, pos ).hide_attack_left );
}

setup_flags()
{
	// stat_flags
	flag_init( "aa_takeover" );
	flag_init( "aa_ambush" );
	flag_init( "aa_hunt" );
	flag_init( "aa_village" );
	flag_init( "aa_morpheus" );
	flag_init( "aa_apartment" );

	takeover_flags();
	ambush_flags();
	village_flags();
	morpheus_flags();
	apartment_flags();
}

takeover_flags()
{
	// takeover

	flag_trigger_init( "takeover_danger", getent( "takeover_danger_trigger", "targetname" ) );
	flag_trigger_init( "takeover_setup", getent( "takeover_setup", "targetname" ) );
	flag_init( "takeover_checkpoint_located" );
	flag_trigger_init( "takeover_inplace", getent( "takeover_inplace", "targetname" ) );
	flag_trigger_init( "takeover_force", getent( "takeover_boundary", "targetname" ) );
	flag_trigger_init( "takeover_advance", getent( "takeover_boundary", "targetname" ) );

	flag_init( "takeover_done" );
	flag_init( "takeover_briefing_done" );
	flag_init( "takeover_fade" );
	flag_init( "takeover_fade_clear" );
	flag_init( "takeover_fade_done" );
}

ambush_flags()
{
	// ambush
	
	flag_init( "caravan_on_the_move" );
	
	flag_init( "ambush_mission_fail" );
	flag_init( "ambush_early_start" );
	flag_init( "ambush_vehicles_inplace" );
	flag_init( "ambush_badguy_spotted" );
	flag_init( "ambush_rocket" );
	flag_init( "ambush_start" );
	flag_init( "ambush_rear_bmp_destroyed" );
	flag_init( "ambush_truck_hit" );
	flag_init( "ambush_tower_fall" );
	flag_init( "ambush_switch_tower" );
	flag_init( "ambush_recovered" );
	
	flag_init( "player_tower_hits_ground" );
	flag_init( "son_of_zakhaev_money_shot" );
}

village_flags()
{
	flag_init( "village_helicopter_greeting" );

	flag_trigger_init( "village_gasstation", getent( "village_gasstation", "targetname" ), true );

	flag_trigger_init( "junkyard_exit", getent( "junkyard_exit", "targetname" ) );
	flag_trigger_init( "village_road", getent( "village_road", "targetname" ) );

	flag_trigger_init( "village_approach", getent( "village_approach", "targetname" ) );
	flag_init( "village_defend" );
	flag_trigger_init( "village_retreat", getent( "village_retreat", "targetname" ) );
	flag_trigger_init( "village_force_escape", getent( "village_force_escape", "targetname" ) );
	flag_trigger_init( "village_wrong_way", getent( "village_wrong_way", "targetname" ) );
	flag_trigger_init( "village_past_alley", getent( "village_past_alley", "targetname" ) );

	flag_init( "village_badguy_escape" );
	flag_init( "village_alley" );
}

morpheus_flags()
{
	flag_trigger_init( "morpheus_quick_start",		getent( "morpheus_quick_start",		"targetname" ) );
	flag_trigger_init( "morpheus_dumpster",			getent( "morpheus_dumpster",		"targetname" ) );
	flag_trigger_init( "morpheus_green_car",		getent( "morpheus_green_car",		"targetname" ) );
	flag_trigger_init( "morpheus_iron_fence",		getent( "morpheus_iron_fence",		"targetname" ) );
	flag_init( "morpheus_iron_fence_fight" );
	flag_trigger_init( "morpheus_flanker",			getent( "morpheus_flanker",			"targetname" ) );
	flag_trigger_init( "morpheus_rpg",				getent( "morpheus_rpg",				"targetname" ) );
	flag_trigger_init( "morpheus_2nd_floor",		getent( "morpheus_2nd_floor",		"targetname" ) );
	flag_trigger_init( "morpheus_single",			getent( "morpheus_single",			"targetname" ) );
	flag_trigger_init( "morpheus_target",			getent( "morpheus_target",			"targetname" ) );
	flag_trigger_init( "morpheus_target_moving",	getent( "morpheus_target_moving",	"targetname" ) );
	flag_trigger_init( "morpheus_alley",			getent( "morpheus_alley",			"targetname" ) );
}

apartment_flags()
{
	flag_trigger_init( "apartment_start",			getent( "apartment_start",			"targetname" ) );
	flag_trigger_init( "apartment_badguy_run",		getent( "apartment_badguy_run",		"targetname" ) );
	flag_trigger_init( "apartment_fire",			getent( "apartment_fire",			"targetname" ) );
	flag_init( "apartment_heli_attack" );
	flag_init( "apartment_heli_firing" );
	flag_init( "apartment_mg_destroyed" );
	flag_trigger_init( "apartment_badguy_attack",	getent( "apartment_badguy_attack",	"targetname" ) );
	flag_trigger_init( "apartment_inside",			getent( "apartment_inside",			"targetname" ) );
	flag_trigger_init( "apartment_badguy_3rd_flr",	getent( "apartment_badguy_3rd_flr",	"targetname" ) );
	flag_trigger_init( "apartment_mg_4th_flr",		getent( "apartment_mg_4th_flr",		"targetname" ) );
	flag_init( "apartment_mg_destroyed_2" );
	flag_init( "apartment_clear" );
	
	flag_init( "gaz_shouts_at_zakhaev" );
	
	flag_trigger_init( "apartment_roof",			getent( "apartment_roof",			"targetname" ) );
	flag_trigger_init( "apartment_roof_friendlies",	getent( "apartment_roof_friendlies","targetname" ) );
	flag_trigger_init( "apartment_stairs",			getent( "apartment_stairs",			"targetname" ) );
	flag_trigger_init( "apartment_suicide",			getent( "apartment_suicide",		"targetname" ) );

	flag_init( "obj_flexicuff" );

	flag_trigger_init( "stage1",					getent( "stage1",		"targetname" ) );
	flag_trigger_init( "stage2",					getent( "stage2",		"targetname" ) );
	flag_trigger_init( "stage3",					getent( "stage3",		"targetname" ) );
	flag_init( "forced_suicide" );
	flag_init( "timed_suicide" );
	flag_init( "apartment_suicide_done" );
	flag_init( "mission_done" );

}

aarea_takeover_init()
{
	delayThread( 1.5, ::activate_trigger_with_targetname, "start_color_init" );

	flag_set( "aa_takeover" );

	battlechatter_off( "allies" );
	battlechatter_off( "axis" );

	setExpFog( 600, 2500, 0.690196, 0.721569, 0.67451, 0 );
	set_vision_set ( "ambush_start", 0 );

	normal_sunlight = 1.5;
	start_sunlight = 0.58312;
	ratio = ( normal_sunlight / start_sunlight );
	r = 0.980392;
	g = 0.960784;
	b = 0.882353;
	
	r = r / ratio;
	g = g / ratio;
	b = b / ratio;
	
	//iprintlnbold ("ratio: "+ ratio );
	//iprintlnbold ("sunlight: "+ r + " " + g + " " + b );
	SetSunLight (r, g, b);

	setsaveddvar( "r_specularcolorscale", "1.24265" );


	// turn village triggers off.
	array_thread( getentarray( "village_trigger", "script_noteworthy" ) , ::trigger_off );

	setup_friendlies( 3 );
	level.player set_playerspeed( 130 );

	array_thread( level.squad, ::enable_cqbwalk );
	array_thread( get_generic_allies(), ::replace_on_death );

	level thread guardtower_dead_enemies();

	level thread takeover_player();
	level thread takeover_objective();
	level thread takeover_setup();
	level thread takeover_attack();
	level thread takeover_clear_roof();
	level thread takeover_fade();

	array_thread( getentarray( "checkpoint_guy", "targetname" ), ::add_spawn_function, ::checkpoint_guy );
	scripted_array_spawn( "checkpoint_guy", "targetname", true );

	flag_wait( "takeover_fade" );

	flag_clear( "aa_takeover" );

	level thread aarea_ambush_init();
}

guardtower_dead_enemies()
{
	flag_wait( "takeover_fade_clear" );

	drone = [];
	drone[0] = spawn( "script_model", (0,0,0) );
	drone[1] = spawn( "script_model", (0,0,0) );

	drone[0] character\character_sp_opforce_geoff::main();
	drone[0].animname = "generic";
	drone[0] UseAnimTree( #animtree );

	drone[1] character\character_sp_opforce_c::main();
	drone[1].animname = "generic";
	drone[1] UseAnimTree( #animtree );

	locations = getentarray( "dead_enemies", "script_noteworthy" );

	for( i = 0 ; i < drone.size ; i ++ )
	{
		locations[i] anim_first_frame_solo( drone[i], "death_pose_" + i );
		drone[i] linkto( locations[i] );
	}
}

takeover_objective()
{
	wait 8;
	checkpoint = getent( "obj_checkpoint", "targetname" );
	objective_add( 0, "active", &"AMBUSH_OBJ_CHECKPOINT", checkpoint.origin );
	objective_current( 0 );

	flag_wait_either( "takeover_checkpoint_located", "takeover_force" );

	objective_state( 0, "done" );

	if ( !flag( "takeover_force" ) )
	{
		dumpster = getent( "obj_dumpster", "targetname" );
		objective_add( 1, "active", &"AMBUSH_OBJ_GET_IN_POSITION", dumpster.origin);
		objective_current( 1 );
	}

	flag_wait( "takeover_force" );

	waittill_dead_or_dying( get_ai_group_ai( "tower_guy" ), undefined, 4 );

	if ( flag( "takeover_checkpoint_located" ) )
		objective_state( 1, "done" );

	objective_add( 2, "active", &"AMBUSH_OBJ_SECURE_CHECKPOINT", checkpoint.origin);
	objective_current( 2 );

	flag_wait( "takeover_done" );

	arcademode_checkpoint( 3.5, 1 );

	objective_state( 2, "done" );

}

takeover_player()
{
	flag_wait( "takeover_danger" );

	level thread set_flag_on_player_action( "takeover_force", true, true);

	flag_wait( "takeover_force" );

	level.player set_playerspeed( 190, 3 );
}

takeover_setup()
{
	level endon( "takeover_force" );

	wait 4;
	level.kamarov.animname = "kamarov";
	level.kamarov anim_single_queue( level.kamarov, "ambush_kmr_bestwayin" );
	level.kamarov.animname = "generic";

	level.price anim_single_queue( level.price, "ambush_pri_notbad" );
	level radio_dialogue_queue( "ambush_mhp_radiojammers" );

	getent( "gate_open", "targetname" ) hide();
	getent( "rear_blocker_open", "targetname" ) hide();

	flag_wait( "takeover_setup" );

	autosave_by_name( "dumpster" );

	flag_set( "takeover_checkpoint_located" );

	level.price anim_single_queue( level.price, "ambush_pri_onmymark" );
	level.price waittill( "goal" );
	activate_trigger_with_targetname( "takeover_setup_color_init" );

	flag_wait( "takeover_inplace" );
	level.price thread anim_single_queue( level.price, "ambush_pri_takethemout" );

	wait 7;
	level.price thread anim_single_queue( level.price, "ambush_pri_cleartower" );

	wait 7;
	flag_set( "takeover_force" );
}

takeover_attack()
{
	flag_wait( "takeover_force" );

	blocker = getent( "takeout_path_blocker", "targetname" );
	blocker connectpaths();
	blocker delete();

	array_thread( getentarray( "takeover_trigger", "script_noteworthy" ) , ::trigger_off );
	activate_trigger_with_targetname( "takeover_attack_color_init" );

	level.price thread anim_single_queue( level.price, "ambush_pri_movemove" );

//	todo: fit this in here. - done
	level.price thread anim_single_queue( level.price, "ambush_pri_goloud" );

	battlechatter_on( "allies" );
	battlechatter_on( "axis" );

	activate_trigger_with_targetname( "takeover_attack_color_init" );
	flag_wait_or_timeout( "takeover_advance", 10 );

	activate_trigger_with_targetname( "takeover_advance_color_init" );

	axis = getaiarray( "axis" );
	waittill_dead_or_dying( axis, axis.size - 3 );

	if ( isdefined( getent( "takeover_diner_color_init", "targetname" ) ) )
	{
		activate_trigger_with_targetname( "takeover_diner_color_init" );
		getent( "takeover_diner_color_init", "targetname" ) trigger_off();
	}

	axis = getaiarray( "axis" );
	waittill_dead_or_dying( axis );

	array_thread( level.squad, ::disable_cqbwalk );

	activate_trigger_with_targetname( "takeover_hero_clear_color_init" );
	wait 2;
	level.mark thread anim_single_queue( level.mark, "ambush_grg_areasecure" );
	activate_trigger_with_targetname( "takeover_clear_color_init" );

	level thread takeover_briefing();

	wait 2;
	flag_set( "takeover_done" );
}

takeover_briefing()
{
	level.price disable_ai_color();

	actors[0] = level.price;
	actors[1] = level.kamarov;

	anim_ent = getent( "cleanup_animent", "targetname" );

	anim_ent anim_reach_and_approach( actors, "tower_briefing" );
	level thread takeover_briefing_dialogue();

	anim_ent anim_single( actors, "tower_briefing" );
	level.price setgoalpos( level.price.origin );
	level.kamarov setgoalpos( level.kamarov.origin );

	flag_set( "takeover_briefing_done" );
}

takeover_briefing_dialogue()
{
	level.price waittillmatch( "single anim", "dialog" );
	level.price waittillmatch( "single anim", "dialog" );
	level.price waittillmatch( "single anim", "dialog" );
	wait 2.5;
	flag_set( "takeover_fade" );
}

takeover_clear_roof()
{
	trigger = getent( "clear_roof", "targetname" );
	trigger waittill( "trigger" );

	array_thread( get_ai_group_ai( "roof_guy" ), ::kill_ai, 0, 5 );
}

takeover_fade()
{
	flag_wait( "takeover_fade" );
	black = create_overlay_element( "black", 0 );
	black fadeovertime( 2 );
	black.alpha = 1;
	thread hud_hide();

	wait 2;
	level.player FreezeControls( true );

	flag_wait( "takeover_fade_clear" );

	hud_string();

	black fadeovertime( 4 );
	black.alpha = 0;
	level.player FreezeControls( false );
 	wait 2;
	thread hud_hide( false );
	wait 2;
	black destroy();
	flag_set( "takeover_fade_done" );
}

hud_string()
{
	hud_string = createFontString( "objective", 1.5 );
	hud_string.sort = 3;
	hud_string.glowColor = ( 0.7, 0.7, 0.3 );
	hud_string.glowAlpha = 1;
	hud_string SetPulseFX( 60, 3500, 700 );
	hud_string.foreground = true;

	hud_string setPoint( "BOTTOM", undefined, 0, -150 );

	hud_string setText( &"AMBUSH_TWO_HOURS_LATER" );

	wait 5;

	hud_string destroy();
}

checkpoint_guy()
{
	self endon( "death" );

	if ( isdefined( self.script_aigroup ) && self.script_aigroup == "tower_guy" )
		self setflashbangimmunity( true );

	self setthreatbiasgroup( "oblivious" );

	flag_wait( "takeover_force" );

	wait 0.5;

	self setthreatbiasgroup( "axis" );
	self.fixednode = false;
}

aarea_ambush_init()
{
	level thread ambush_mark();

	setculldist( 8000 );

	battlechatter_off( "allies" );
	battlechatter_off( "axis" );

	ambush_setup();
	autosave_by_name( "ambush" );

	flag_set( "aa_ambush" );

	blocker = getent( "rear_blocker", "targetname" );
	blocker connectpaths();
	blocker delete();

	getent( "rear_blocker_open", "targetname" ) show();

	getent( "badguy", "script_noteworthy" ) add_spawn_function( ::ambush_badguy_spawn_function );
	getent( "badguy_passanger", "script_noteworthy" ) add_spawn_function( ::ambush_badguy_passanger_spawn_function );

	activate_trigger_with_targetname( "ambush_enemy_color_init" );

	level thread ambush_player_interrupt();

	level thread ambush_helicopter();
	level thread ambush_objective();
	level thread ambush_price();
	level thread ambush_steve();
	level thread ambush_rockets();
	level thread ambush_caravan();

	flag_wait( "ambush_recovered" );

	flag_clear( "aa_ambush" );

	level thread aarea_village_init();
}

ambush_player_interrupt()
{
	level endon( "ambush_rocket" );

	level thread ambush_mission_fail();

	vnode = getvehiclenode( "caravan_approach", "script_noteworthy" );
	vnode waittill( "trigger" );

	level thread set_flag_on_player_action( "ambush_mission_fail", false, true);

	flag_wait( "ambush_vehicles_inplace" );

	level thread set_flag_on_player_action( "ambush_early_start", false, true);

	flag_wait( "ambush_early_start" );

	flag_set( "ambush_start" );
	flag_set( "ambush_rocket" );
}

ambush_mission_fail()
{
	level endon( "ambush_vehicles_inplace" );

	flag_wait( "ambush_mission_fail" );

	setdvar( "ui_deadquote", "@AMBUSH_MISSIONFAIL_STARTED_EARLY" );
	maps\_utility::missionFailedWrapper();
}

ambush_helicopter()
{
	flag_wait( "ambush_start" );

	level.helicopter = maps\_vehicle::spawn_vehicle_from_targetname( "blackhawk" );
	struct = getstruct( level.helicopter.target, "targetname" );
	level.helicopter thread heli_path_speed();
	level.helicopter sethoverparams( 150, 120, 60);

	struct = getstruct( "rocket_attack", "script_noteworthy" );
	struct waittill( "trigger" );

	level.helicopter setVehWeapon( "hunted_crash_missile" );
	level.helicopter setturrettargetent( level.rear_bmp );
	
	level.rear_bmp maps\_vehicle::godoff();

	level.helicopter fireweapon( "tag_barrel", level.rear_bmp, ( 0,0,0 ) );
	wait 0.5;
	missile = level.helicopter fireweapon( "tag_barrel", level.rear_bmp, ( 0,0,0 ) );

	assert( isdefined( missile ) );

	missile waittill( "death" );

	if ( isalive( level.rear_bmp ) )
		level.rear_bmp notify( "death" );

	flag_set( "ambush_rear_bmp_destroyed" );

}

ambush_objective()
{
	flag_wait( "takeover_fade_done" );

	objective_add( 3, "active", &"AMBUSH_OBJ_AMBUSH_CONVOY", level.player.origin );
	objective_current( 3 );

	flag_wait( "ambush_start" );
	objective_state( 3, "done" );
}


ambush_badguy_spawn_function()
{
	level.badguy = self;
	self.name = "V. Zakhaev";

	self set_battlechatter( false );

	self setthreatbiasgroup( "oblivious" );
	self set_ignoreSuppression( true );
	self.a.disablePain = true;
	self.grenadeawareness = 0;
	self.allowdeath = true;
	self.deathanim = %death_stand_dropinplace;
	self thread badguy_died( 10 );

	self setFlashbangImmunity( true );
	self.script_immunetoflash = true;

	flag_wait( "ambush_switch_tower" );
	self thread magic_bullet_shield();

	level.badguy animscripts\shared::placeWeaponOn( level.badguy.secondaryweapon, "right" );

	level.badguy_jeep waittill( "death" );
	self unlink();

	node = getnode( "ambush_badguy_path", "targetname" );
	self thread maps\_spawner::go_to_node( node );

	self waittill( "reached_path_end" );
	self notify( "stop_death_fail" );
	self stop_magic_bullet_shield();
	self delete();
}

ambush_badguy_passanger_spawn_function()
{
	self setthreatbiasgroup( "oblivious" );
	self.allowdeath = true;
	self.deathanim = %death_stand_dropinplace;

	self waittill( "jumpedout" );
	self setthreatbiasgroup( "axis" );
	self.deathanim = undefined;
}

driver_death()
{
	self endon( "death" );
	self.deathanim = %crouch_death_clutchchest;
	flag_wait( "ambush_vehicles_inplace" );
	self.allowdeath = true;

	flag_wait( "ambush_rocket" );
	wait 1.2;
	self die();
}

ambush_caravan()
{
	array_thread( getentarray( "drivers", "script_noteworthy" ), ::add_spawn_function, ::driver_death );

	wait 8;
	vehicles = maps\_vehicle::scripted_spawn( 0 );

	wait 0.1;

	level.badguy_jeep = undefined;
	level.rear_truck = undefined;
	level.bm21 = undefined;
	level.middle_bm21 = undefined;
	level.bmp = undefined;
	level.rear_bmp = undefined;

	for( i = 0 ; i < vehicles.size ; i ++ )
	{
		thread maps\_vehicle::gopath( vehicles[i] );
		
		if ( !isdefined( vehicles[i].script_noteworthy ) )
			continue;
		else if ( vehicles[i].script_noteworthy == "ambush_jeep" )
			level.badguy_jeep = vehicles[i];
		else if ( vehicles[i].script_noteworthy == "rear_truck" )
			level.rear_truck = vehicles[i];
		if ( vehicles[i].script_noteworthy == "bm21" )
			level.bm21 = vehicles[i];
		if ( vehicles[i].script_noteworthy == "middle_bm21" )
			level.middle_bm21 = vehicles[i];
		if ( vehicles[i].script_noteworthy == "bmp" )
			level.bmp = vehicles[i];
		if ( vehicles[i].script_noteworthy == "rear_bmp" )
			level.rear_bmp = vehicles[i];
	}

	level.badguy_jeep maps\_vehicle::godon();

	level.vehicle_ResumeSpeed = 20;

	vnode = getvehiclenode( "bm21_inplace", "script_noteworthy" );
	vnode waittill( "trigger" );

	flag_set( "ambush_vehicles_inplace" );

	flag_wait( "ambush_rocket" );
	flag_wait_or_timeout( "ambush_start", 1 );

	battlechatter_on( "allies" );
	battlechatter_on( "axis" );

	level.bm21 notify( "unload", "all" );
	level.middle_bm21 notify( "unload", "passengers" );

	level.rear_bmp thread ambush_bmp_attack();

	wait 1;
	level.badguy_jeep notify( "groupedanimevent","hide_attack_left" );

	flag_wait( "ambush_rear_bmp_destroyed" );

	wait 1;

	activate_trigger_with_noteworthy( "ambush_extra_enemies" );

	wait 3;

	activate_trigger_with_targetname( "jeep_vehiclegate" );

	level.badguy_jeep notify( "groupedanimevent","escape" );

}

ambush_streetlight()
{
	streetlight = getent( "streetlight", "targetname" );
	ents = getentarray( streetlight.target, "targetname" );
	if ( ents[0].classname == "script_model" )
	{
		end_angles = ents[0].angles;
		end_origin = ents[0].origin;
		ents[0] delete();
	 	ents[1] linkto( streetlight );
	}
	else
	{
		end_angles = ents[1].angles;
		end_origin = ents[1].origin;
		ents[1] delete();
	 	ents[0] linkto( streetlight );
	}

	vnode = getvehiclenode( "streetlight_hit", "script_noteworthy" );
	vnode waittill( "trigger" );

	streetlight rotateto( end_angles, 0.3, 0, 0.1 );
	streetlight moveto( end_origin, 0.3, 0, 0.1 );

	vnode = getvehiclenode( "truck_hit", "script_noteworthy" );
	vnode waittill( "trigger" );
	level.middle_bm21 JoltBody( ( level.middle_bm21.origin + (0,0,64) ), 2 );
}

ambush_bmp_attack()
{
	self endon( "death" );

	ent = getent( "bmp_target", "targetname" );
	level.rear_bmp thread bmp_pan_target( ent );

	level.rear_bmp waittill("turret_on_target");

	while ( true )
	{
		level.rear_bmp fireweapon();
		wait 0.1;
	}
}

bmp_pan_target( ent )
{
	self setturrettargetent( ent );
	self waittill("turret_on_target");

	while( isdefined( ent.target ) )
	{
		wait 0.5;
		ent = getent( ent.target, "targetname" );
		self setturrettargetent( ent );
		self waittill("turret_on_target");
	}
}

ambush_rockets()
{
	flag_wait( "ambush_rocket" );

	ai = get_ai_group_ai( "rocket_man" );
	ai = get_array_of_closest( level.rear_truck.origin , ai );

	target1 = getent( "rpg_target1", "targetname" );	//	BMP
	target2 = getent( "rpg_target2", "targetname" );	//	rear BM21

	ai[0] notify( "end_patrol" );
	ai[0] set_ignoreSuppression( true );
	ai[0] setgoalnode( getnode( "bmp_attack_node", "targetname" ) );
	ai[0] setstablemissile( true );
	ai[0].goalradius = 32;
	ai[0] setentitytarget( target1 );
	ai[0].a.rockets = 1;
	ai[0].maxSightDistSqrd = 8192*8192;
	
	level.bmp thread destroy_rocket_target( ai[0] );
	level.bmp maps\_vehicle::godoff();

	ai[1] notify( "end_patrol" );
	ai[1] set_ignoreSuppression( true );
	ai[1] setgoalnode( getnode( "rear_truck_attack_node", "targetname" ) );
	ai[1] setstablemissile( true );
	ai[1].goalradius = 32;
	ai[1] setentitytarget( target2 );
	ai[1].a.rockets = 1;
	ai[1].maxSightDistSqrd = 8192*8192;

	level.rear_truck thread destroy_rocket_target( ai[1] );
	level.rear_truck maps\_vehicle::godoff();	
}

destroy_rocket_target( ai )
{
	while ( true )
	{
		self waittill( "damage", damage, attacker );
		if ( attacker == ai )
		{
			flag_set( "ambush_start" );
			ai clearenemy();
			ai setthreatbiasgroup( "allies" );
			ai stop_magic_bullet_shield();

			if ( isalive( self ) )
				self notify( "death" );
			break;
		}
	}
}

ambush_price()
{
	wait 6;
	level radio_dialogue_queue( "ambush_mhp_enemyconvoy" );

//	todo: switch on dialogue I think - done
	level.price thread anim_single_queue( level.price, "ambush_pri_nobodyfires" );
//	level.price anim_single_queue( level.price, "ambush_pri_copythat" );
//	level.price anim_single_queue( level.price, "ambush_pri_targetinjeep" );
//	level.price thread anim_single_queue( level.price, "ambush_pri_youknow" );
	
	flag_set( "caravan_on_the_move" );

	level thread ambush_price_leadup();

	flag_wait_either( "ambush_rocket", "ambush_early_start" );

	activate_trigger_with_targetname( "ambush_attack_color_init" );

//	todo: switch on dialogue. - done
	level.price thread anim_single_queue( level.price, "ambush_pri_smokeem" );
//	level.price thread anim_single_queue( level.price, "ambush_pri_go" );


	flag_wait_or_timeout( "ambush_start", 3 );
	level.price setthreatbiasgroup( "allies" );
	level.player setthreatbiasgroup( "player" );
}

ambush_price_leadup()
{
	level endon( "ambush_early_start" );

	flag_wait( "ambush_badguy_spotted" );

//	todo: switch on dialogue. - done
	level.price thread anim_single_queue( level.price, "ambush_pri_targetinjeep" );
//	level.price anim_single_queue( level.price, "ambush_pri_thirdfront" );

	level.price anim_single_queue( level.price, "ambush_pri_takealive" );
	level.price anim_single_queue( level.price, "ambush_pri_standby" );
	flag_set( "ambush_rocket" );
}

ambush_mark()
{
	flag_wait( "takeover_fade_clear" );
	wait 2.5;

	level.mark pushplayer( true );
	level.mark.a.disablePain = true;
	level.mark setFlashbangImmunity( true );

//	level.mark anim_single_queue( level.mark, "ambush_grg_blackrussian" );
	level.mark anim_single_queue( level.mark, "ambush_grg_likeaclown" );
	level.mark anim_single_queue( level.mark, "ambush_grg_nothinglikerussian" );

	flag_wait( "ambush_rocket" );

	ent = getent( "ambush_mark_target", "targetname" );
	level.mark setentitytarget( ent, 1 );

	flag_wait_or_timeout( "ambush_start", 4 );

	level.mark clearenemy();

	// make group1 hate group2 
	setthreatbias( "group2", "group1", 100000 );

	level.mark setthreatbiasgroup( "group1" );

	ai = get_ai_group_ai( "mark_targets" );
	for( i = 0 ; i < ai.size ; i ++ )
	{
		ai[i] setthreatbiasgroup( "group2" );
	}

	flag_wait( "ambush_truck_hit" );
	level.mark anim_single_queue( level.mark, "ambush_grg_hittower" );

	flag_wait( "ambush_tower_fall" );
	level.mark setthreatbiasgroup( "oblivious" );

	if ( randomint( 2 ) )
		level.mark anim_single_queue( level.mark, "ambush_grg_ohno1" );
	else
		level.mark anim_single_queue( level.mark, "ambush_grg_ohno2" );

	level.mark set_run_anim( "sprint" );

	flag_wait( "ambush_recovered" );
	level.mark setthreatbiasgroup( "allies" );
	level.mark.a.disablePain = false;
	level.mark pushplayer( false );
	level.mark setFlashbangImmunity( false );

}

ambush_setup()
{
	flag_wait( "takeover_briefing_done" );

	level notify( "putout_fires" );
	thread maps\_utility::set_ambient("exterior_norain");

	ent = getent( "player_outofsight", "targetname" );
	level.player setorigin ( ent.origin );
	level.player setplayerangles ( ent.angles );

	flag_set( "takeover_fade_clear" );
	wait 0.1;

	node = getnode( "startnodeprice_ambush", "targetname" );
	level.price notify( "killanimscript" );
	level.price teleport ( node.origin, node.angles );
	level.price setthreatbiasgroup( "oblivious" );
	level.price set_force_color( "o" );

	node = getnode( "startnodemark_ambush", "targetname" );
	level.mark notify( "killanimscript" );
	level.mark teleport ( node.origin, node.angles );
	level.mark setthreatbiasgroup( "oblivious" );

	level.steve stop_magic_bullet_shield();
	level.steve delete();

	level.steve = scripted_spawn( "ambush_steve", "targetname", true );
	level.steve thread magic_bullet_shield();
	level.steve.animname = "steve";
	level.steve.name = "Gaz";
	level.steve thread squad_init();

	level.steve setthreatbiasgroup( "oblivious" );
	level.steve.pacifist = true;
	level.steve.a.lastshoottime = gettime();
	level.steve.team = "allies";
	level.steve.voice = "british";
	level.steve set_battlechatter( false );
	level.steve.ignoreme = true;
	level.steve.maxSightDistSqrd = 4;
	level.steve.no_ir_beacon = true;

	node = getnode( "startnodesteve_ambush", "targetname" );
	level.steve notify( "killanimscript" );
	level.steve teleport ( node.origin, node.angles );
	level.steve setthreatbiasgroup( "oblivious" );

	ambush_setup_enemy_allies();

	node = getnode( "startnodeplayer_ambush", "targetname" );
	level.player setorigin ( node.origin );
	level.player setplayerangles ( node.angles + (13,0,0) );
	level.player setthreatbiasgroup( "oblivious" );

	activate_trigger_with_targetname( "ambush_setup_color_init" );

	if ( level.player HasWeapon( "remington700" ) )
	{
		level.player takeweapon( "remington700" );
		level.player giveweapon( "rpd" );
		level.player switchToWeapon( "rpd" );
	}

	level.player setViewmodel( "viewhands_op_force" );
	level.player disableweapons();

	delete_dropped_weapons();
	clearallcorpses();

	getent( "gate_open", "targetname" ) show();
	getent( "gate_closed", "targetname" ) hide();

	setExpFog(2000, 5500, .462618, .478346, .455313, 0);
	set_vision_set( "ambush", 0 );
	ResetSunLight();
	setsaveddvar( "r_specularcolorscale", "1" );

	setsaveddvar( "sm_sunsamplesizenear", 0.45 );

	flag_wait( "takeover_fade_done" );

	level.player enableweapons();
}

ambush_setup_enemy_allies()
{
	level.names_copies = [];

	generic = get_generic_allies(); 
	for ( i=0; i < generic.size; i++ )
	{
		level.names_copies[ level.names_copies.size ] = generic[i].name;
		generic[i] disable_replace_on_death();
		generic[i] delete();
	}

	// need this here so that deleted ai get removed from level.squad
	waittillframeend;

	array_thread( getentarray( "ambush_allied_axis", "targetname" ), ::add_spawn_function, ::ambush_allied_axis_spawnfunc );
	scripted_array_spawn( "ambush_allied_axis", "targetname", true );

	array_thread( getentarray( "ambush_allied", "targetname" ), ::add_spawn_function, ::ambush_allied_spawnfunc );
	scripted_array_spawn( "ambush_allied", "targetname", true );

}

ambush_allied_axis_spawnfunc()
{
	self setthreatbiasgroup( "oblivious" );
	self.pacifist = true;
	self.a.lastshoottime = gettime();
	self.team = "allies";
	self.voice = "russian";
	self set_battlechatter( false );
	self.ignoreme = true;
	self.maxSightDistSqrd = 4;
	self.no_ir_beacon = true;
	self thread magic_bullet_shield();

	if ( isdefined( self.script_noteworthy ) && self.script_noteworthy == "delay_guy" )
		self thread ambush_delay();

	if ( level.names_copies.size > 0 )
	{
		self.name = level.names_copies[ level.names_copies.size - 1 ];
		level.names_copies = array_remove( level.names_copies, self.name );
	}
	else
		self maps\_names::get_name();

	self thread generic_allied();

	flag_wait( "ambush_rocket" );
	flag_wait_or_timeout( "ambush_start", 2 );

	if ( !isdefined( self.script_aigroup ) || self.script_aigroup != "rocket_man" )
		self stop_magic_bullet_shield();

	self.pacifist = false;
	self.ignoreme = false;
	self.maxSightDistSqrd = 8192*8192;

	if ( self.script_aigroup == "ground_man_upper" )
	{
		self setthreatbiasgroup( "allies" );
		self set_force_color( "r" );
	}
	if ( self.script_aigroup == "ground_man_lower" )
	{
		self setthreatbiasgroup( "allies" );
		self set_force_color( "c" );
	}
}

ambush_steve()
{
	level endon( "ambush_early_start" );
	level thread ambush_steve_fight();

	level.steve set_goalnode( getnode( "steve_ambush_node", "targetname" ) );

	old_grenadeawareness = level.steve.grenadeawareness;
	level.steve.grenadeawareness = 0;

	flag_wait( "ambush_vehicles_inplace" );
	level.steve thread maps\_patrol::patrol( "caravan_walkby" );

	ent = getent( "badguy_spotted", "script_noteworthy" );
	ent waittill( "trigger" );

	level.steve.grenadeawareness = old_grenadeawareness;

	level.steve anim_single_queue( level.steve, "ambush_gaz_visualtarget" );
	flag_set( "ambush_badguy_spotted" );
}

ambush_steve_fight()
{
	flag_wait( "ambush_rocket" );
	level.steve notify( "end_patrol" );
	level.steve set_force_color( "c" );
	wait 4;
	level.steve setthreatbiasgroup( "allies" );

	flag_wait( "ambush_rear_bmp_destroyed" );
	wait 3;
	level.steve anim_single_queue( level.steve, "ambush_gaz_gotcompany" );
}

ambush_delay()
{
	self endon( "death" );

	vnode = getvehiclenode( "delay_node", "script_noteworthy" );
	vnode waittill( "trigger" );

	wait 0.5;

	self maps\_patrol::patrol( "delay_path" );

	flag_wait( "ambush_vehicles_inplace" );

	flag_wait( "ambush_rocket" );
	wait 1;

	ent = getent( "delay_fire_target", "targetname" );
	self setentitytarget( ent );
	self.maxSightDistSqrd = 8192*8192;

	wait 1;

	self clearenemy();
	self set_force_color( "c" );

	wait 5;
	self setthreatbiasgroup( "allies" );

}

ambush_delay_dialogue()
{
	russian = level.middle_bm21.riders[0];
	if ( !isalive( russian ) )
		return;

	level endon( "ambush_start" );
	russian endon( "death" );
	self endon( "death" );

	russian.animname = "russian";
	self.animname = "loyalist";

	self anim_single_queue( self, "ambush_ru2_papersplease" );
	wait 0.5;
	russian anim_single_queue( russian, "ambush_ru1_paperswhatpapers" );
	russian anim_single_queue( russian, "ambush_ru1_fatpolitician" );
	wait 0.5;
	russian anim_single_queue( russian, "ambush_ru1_whatareyouwaitingfor" );
	wait 0.5;
	self anim_single_queue( self, "ambush_ru2_illdothatrightnow" );
}

ambush_allied_spawnfunc()
{
	self endon( "death" );

	self thread generic_allied();
	self setthreatbiasgroup( "oblivious" );

	flag_wait( "ambush_rocket" );
	self setthreatbiasgroup( "allies" );
}

ambush_tower_fall()
{
	guard_tower_blocker = getent( "guard_tower_blocker", "script_noteworthy" );
	guard_tower_blocker notsolid();

	guard_tower = getent( "guard_tower", "targetname" );
	parts = getentarray( "guard_tower_part", "targetname" );
	for( i = 0 ; i < parts.size ; i ++ )
	{
		parts[i] linkto( guard_tower );
	}

	guard_tower_d = getentarray( "guard_tower_d", "targetname" );
	array_thread( guard_tower_d, ::ambush_tower_swap );

	flag_wait( "takeover_fade_clear" );
	guard_tower_blocker solid();

	flag_wait( "takeover_fade_done" );

	vnode = getvehiclenode( "collision_imminent", "script_noteworthy" );
	vnode waittill( "trigger", vehicle );
	vehicle playsound( "ambush_jeep_skid" );

	flag_set( "ambush_truck_hit" );

	vnode = getvehiclenode( "tower_collision", "script_noteworthy" );
	vnode waittill( "trigger", vehicle );

	vehicle playsound( "ambush_car_crash" );
	guard_tower playsound( "ambush_tower_crash" );

	level.mark linkto( guard_tower );
	flag_set( "ambush_tower_fall" );
	earthquake( 0.1, 0.5, level.player.origin, 400 );

	guard_tower rotateto( ( 5,0,0 ), 0.5, 0, 0.5 );
	wait 0.5;

	guard_tower rotateto( ( 2,0,5 ), 1, 0.7, 0.3 );
	wait 1;

	guard_tower rotateto( ( 0,0,-2 ), 0.7, 0.5, 0.2 );
	wait 0.7;

	guard_tower rotateto( ( 0,20,90 ), 1.7, 1.7, 0 );
	wait 1.65;

	level.mark unlink();

	flag_set( "player_tower_hits_ground" );

	level thread ambush_tower_blackout();

	wait 1;

	for( i = 0 ; i < parts.size ; i ++ )
	{
		parts[i] unlink();
		parts[i] delete();
	}
	guard_tower delete();

	sandbags = getentarray( "guard_tower_sandbags", "targetname" );
	for( i = 0 ; i < sandbags.size ; i ++ )
		sandbags[i] delete();

	flag_set( "ambush_switch_tower" );
}

ambush_tower_swap()
{
	self hide();

	if ( self.classname == "script_brushmodel" )
	{
		self connectpaths();
		self notsolid();
	}

	flag_wait( "ambush_switch_tower" );

	if ( self.classname == "script_brushmodel" )
	{
		self solid();
		self disconnectpaths();
	}
	self show();

}

ambush_tower_blackout()
{
	level.player setthreatbiasgroup( "oblivious" );

	black = create_overlay_element( "black", 1 );

	level.player shellshock( "default", 20 );

	ent = getent( "player_outofsight", "targetname" );
	level.player setorigin ( ent.origin );
	level.player setplayerangles ( ent.angles );
	level.player EnableInvulnerability();

	wait 1;

	node = getnode( "startnodemark_village", "targetname" );
	level.mark notify( "killanimscript" );
	level.mark teleport( node.origin, node.angles );

	player_origin = ( -439, -197, 9 );
	player_angles = ( -25, 40, 0 );

	level.player setorigin( player_origin );
	level.player setplayerangles( player_angles );

	// teleport player and lock him to a view. Same as in aftermath. Even do the view movement.
	level.player setstance( "prone" );

	level.player disableweapons();
	level.player allowstand( false );
	level.player allowcrouch( false );
	level.player freezeControls( true );

	wait 1;

	setsaveddvar( "sm_sunsamplesizenear", level.sm_sunsamplesizenear );

	black fadeovertime( 3 );
	black.alpha = 0;

	thread ambush_recover();
	wait 2;
	level.badguy_jeep notify( "unload", "all" );
	exploder(1);
	wait 7;

	level.badguy_jeep uaz_vehicle_anims_clear();
	level.badguy_jeep notify( "death" );
	
	flag_set( "son_of_zakhaev_money_shot" );
	
	wait 10;

	black destroy();

	level.player freezeControls( false );
	level.player allowstand( true );
	level.player allowcrouch( true  );

	flag_set( "ambush_recovered" );

	wait 2;
	level.player enableweapons();
	level.player DisableInvulnerability();

	level.player setthreatbiasgroup( "player" );

}


ambush_recover()
{
	ground_ref_ent = spawn( "script_model", (0,0,0) );
	level.player playerSetGroundReferenceEnt( ground_ref_ent );

	motion = [];
	motion[0]["angles"] = ( 10, -40, -10 );
	motion[0]["time"] = ( 0, 0, 0 );

	motion[1]["angles"] = ( 0, 25, 0 );
	motion[1]["time"] = ( 3.3, 3.3, 0 );

	motion[2]["angles"] = ( -5, 30, 3 );
	motion[2]["time"] = ( 1, 0, 1 );

	motion[3]["angles"] = ( -1, 30, -3 );
	motion[3]["time"] = ( 3, 3, 0 );

	motion[4]["angles"] = ( 0, 30, -4 );
	motion[4]["time"] = ( 1, 0, 1 );

	motion[5]["angles"] = ( -3, 28, -2 );
	motion[5]["time"] = ( 0.65, 0.65, 0 );

	// explosion
	motion[6]["angles"] = ( 20, -10, 15 );
	motion[6]["time"] = ( 0.7, 0, .4 );

	motion[7]["angles"] = ( 0, -16, 0 );
	motion[7]["time"] = ( 4, 2, 2 );

	// running
	motion[8]["angles"] = ( 10, -70, 0 );
	motion[8]["time"] = ( 3.5, 2, 1.5 );

	motion[9]["angles"] = ( 0, -20, 0 );
	motion[9]["time"] = ( 2, 1, 0 );

	for( i = 0 ; i < motion.size ; i ++ )
	{
		angles = adjust_angles_to_player( motion[i]["angles"] );
		time = motion[i]["time"][0];
		acc = motion[i]["time"][1];
		dec = motion[i]["time"][2];

		if ( time == 0)
			ground_ref_ent.angles = angles;
		else
		{
			ground_ref_ent rotateto( angles, time, acc, dec );
			ground_ref_ent waittill( "rotatedone" );
		}
	}

	ground_ref_ent rotateto( (0,0,0), 1, 0.5, 0.5 );
	ground_ref_ent waittill( "rotatedone" );

	level.player playerSetGroundReferenceEnt( undefined );
}

main_objective()
{
	objective_trigger = getent( "main_objective", "targetname" );
	objective_add( 4, "active", &"AMBUSH_OBJ_CAPTURE_TARGET", objective_trigger.origin);
	objective_current( 4 );

	while ( isdefined( objective_trigger.target) )
	{
		objective_trigger waittill( "trigger" );

		if ( isdefined( objective_trigger.script_flag_wait ) )
			flag_wait( objective_trigger.script_flag_wait );

		objective_trigger = getent( objective_trigger.target, "targetname" );
		objective_position( 4, objective_trigger.origin);
		objective_Ring( 4 );

		level notify( "main_objective_updated" );
	}

	flag_wait( "obj_flexicuff" );

	objective_string( 4, &"AMBUSH_OBJ_FLEXICUFF" );

	flag_wait( "apartment_suicide_done" );

//	objective_state( 4, "failed" );
}

aarea_village_init()
{
	flag_set( "aa_hunt" );

	setculldist( 0 );

	level thread village_nag( "village_gasstation", undefined, "ambush_mhp_wrongway", true);

	// turn village triggers on.
	array_thread( getentarray( "village_trigger", "script_noteworthy" ) , ::trigger_on );

	getent( "badguy_village", "script_noteworthy" ) add_spawn_function( ::badguy_spawn_function );
	getent( "badguy_village", "script_noteworthy" ) add_spawn_function( ::village_badguy );

	autosave_by_name( "village" );

	arcademode_checkpoint( 4, 2 );

	level thread village_friendlies();
	level thread village_enemies();
	level thread main_objective();
	level thread village_helicopter();
	level thread village_price();
	level thread village_mark();

	level thread failed_to_pursue();
	
	level thread village_cleanup();

	flag_wait_either( "village_alley", "morpheus_quick_start" );

	flag_clear( "aa_village" );

	level thread aarea_morpheus_init();
}

village_friendlies()
{
	flag_wait( "junkyard_exit" );

	maps\_spawner::kill_spawnerNum( 1 );
	array_delete( getaiarray( "axis" ) );

	generic = get_generic_allies(); 
	for( i = 0 ; i < generic.size ; i ++ )
	{
		generic[i] delete();
	}

	ai = scripted_array_spawn( "village_friendlies", "targetname" );
	array_thread( ai, ::generic_allied );

	level.price notify( "killanimscript" );
	level.price teleport( getnode( "village_price_teleport", "targetname").origin );
	level.price set_force_color( "r" );

	level.steve stop_magic_bullet_shield();
	level.steve delete();

	// need this here so that deleted ai get removed from level.squad
	waittillframeend;

	spawner = getent( "steve", "targetname" );
	spawner.count = 1;

	level.steve = scripted_spawn( "steve", "targetname", true );
	level.steve thread magic_bullet_shield();
	level.steve.animname = "steve";
	level.steve.name = "Gaz";
	level.steve thread squad_init();

	level.steve notify( "killanimscript" );
	level.steve teleport( getnode( "village_steve_teleport", "targetname").origin );
	level.steve set_force_color( "r" );

	array_thread( get_generic_allies(), ::replace_on_death );

	array_thread( level.squad, ::enable_careful );

	level endon( "morpheus_quick_start" );

	level thread village_friendlies_six();
	
	flag_wait( "village_badguy_escape" );

	wait 5;

	level radio_dialogue_queue( "ambush_mhp_sidealley" );

	wait 3;

	flag_set( "village_alley" );

	level.price anim_single_queue( level.price, "ambush_pri_goafterhim" );
	level.mark anim_single_queue( level.mark, "ambush_grg_soapgoalley" );

	level.mark thread village_nag( undefined, 25, "ambush_grg_thisway" );
	level thread village_nag( undefined, 12, "ambush_mhp_cuthrualley", true );
	level thread village_nag( "village_wrong_way", undefined, "ambush_mhp_wrongway", true );
	level thread village_nag( "village_past_alley", undefined, "ambush_mhp_passedalley", true, "village_wrong_way" );
}

village_nag( flag_str, delay, nag, radio, ender )
{
	level endon( "morpheus_quick_start" );

	if ( isdefined( ender ) )
		level endon( ender  );

	if ( isdefined( flag_str ) )
		flag_wait( flag_str );
	if ( isdefined( delay ) )
		wait delay;
	if ( isdefined( radio ) )
		level radio_dialogue_queue( nag );
	else
		self anim_single_queue( self, nag ); 
}


village_friendlies_six()
{
	level endon( "village_badguy_escape" );

	trigger = getent( "friendlies_arriving", "targetname" );
	while ( true )
	{
		trigger waittill( "trigger", ent );
		if ( ent != level.mark )
			break;
	}	

	level.mark anim_single_queue( level.mark, "ambush_grg_friendliessixoclock" );
}

village_enemies()
{
	array_thread( getentarray( "village_force", "script_noteworthy" ), ::add_spawn_function, ::village_enemies_spawn_function );

	level thread village_bmp();

	flag_wait( "village_defend" );
	activate_trigger_with_targetname( "village_defend_color_init" );

	flag_wait( "village_retreat" );
	wait 3;
	activate_trigger_with_targetname( "village_retreat_1_color_init" );

	while( !flag( "village_force_escape" ) && get_ai_group_count( "village_force" ) > 4 )
		wait 0.05;

	i = 0;
	while ( !flag( "village_force_escape" ) && enemies_close( 512 ) && i > 10 )
	{
		wait 1;
		i++;
	}

	flag_set( "village_badguy_escape" );

	activate_trigger_with_targetname( "village_retreat_2_color_init" );

	triggers = getentarray( "village_second_force", "script_noteworthy" );
	array_thread( triggers, ::activate_trigger );
}

enemies_close( dist )
{
	ai = getaiarray( "axis" );
	for( i = 0 ; i < ai.size ; i ++ )
	{
		if ( distance2d( level.player.origin, ai[i].origin ) < dist )
			return true;
	}
	return false;
}


village_bmp()
{
	bmp = maps\_vehicle::waittill_vehiclespawn( "village_bmp" );
	bmp waittill( "reached_end_node" );
	bmp thread vehicle_turret_think();
}

village_enemies_spawn_function()
{
	self endon( "death" );

	self thread village_enemies_allert();

	self setthreatbiasgroup( "oblivious" );

	flag_wait( "village_defend" );

	self setthreatbiasgroup( "axis" );
}

village_enemies_allert()
{
	level endon( "village_approach" );
	self waittill( "damage" );
	flag_set( "village_approach" );
}

village_badguy()
{
	self set_generic_run_anim( "sprint" );
	self.moveplaybackrate = 1.2;

	setignoremegroup( "allies", "badguy" );	// badguy ignore allies;
	setignoremegroup( "player", "badguy" );	// badguy ignore player;

	flag_wait( "village_approach" );

	// stat_flags
	flag_clear( "aa_hunt" );
	flag_set( "aa_village" );

	flag_set( "village_defend" );

	wait 3;

	self thread badguy_health_shield();

	setthreatbias( "player", "badguy", 0 );	// badguy nolonger ignore player;
	setthreatbias( "allies", "badguy", 0 );	// badguy nolonger ignore allies;

	node = getnode( "badguy_village_retreat_node", "targetname" );
	self set_goalnode( node );

	flag_wait( "village_badguy_escape" );

	node = getnode( "badguy_village_delete_node", "targetname" );
	self set_goalnode( node );

	self waittill( "goal" );

	self notify( "stop_death_fail" );
	self delete();
}

badguy_health_shield()
{
	health_buffer = 1000000;
	self.health += health_buffer;

	self endon( "stop_death_fail" );

	while( true )
	{
		self waittill( "damage", a, b, c, d, e, f );
		if ( b == level.player )
			if ( self.health < health_buffer )
				break;
	}
	self.health = 150;  
}

village_mark()
{
	activate_trigger_with_targetname( "village_color_init" );

	waittill_aigroupcleared( "junkyard_dog" );
	activate_trigger_with_targetname( "dog_dead_color_init" );

	wait 1.5;
	level.mark thread anim_single_queue( level.mark, "ambush_grg_downboy" );

	flag_wait( "village_defend" );
	level.mark clear_run_anim();
}

village_helicopter()
{
	flag_wait( "village_helicopter_greeting" );

	wait 1;

	level thread radio_dialogue_queue( "ambush_mhp_jmovesfast" );
	wait 5;
	level thread radio_dialogue_queue( "ambush_mhp_junkyard" );

	flag_wait( "junkyard_exit" );
	level radio_dialogue_queue( "ambush_mhp_cityoutskirts" );

	flag_wait( "village_road" );
	level radio_dialogue_queue( "ambush_mhp_hostileforces" );

	flag_wait( "village_retreat" );
	level radio_dialogue_queue( "ambush_mhp_checkyourfire" );
}

village_price()
{
	level endon( "morpheus_quick_start" );

	level.price anim_single_queue( level.price, "ambush_pri_runforit" );
	level.price anim_single_queue( level.price, "ambush_pri_chasehim" );

	flag_set( "village_helicopter_greeting" );
}

village_cleanup()
{
	flag_wait( "morpheus_rpg" );

	level.price stop_magic_bullet_shield();
	level.price disable_replace_on_death();

	allies = getaiarray( "allies" );
	for( i = 0 ; i < allies.size ; i ++ )
	{
		if ( allies[i] == level.mark || allies[i] == level.steve )
			continue;

		allies[i] disable_replace_on_death();
		allies[i] delete();
	}

	axis = get_ai_group_ai( "village_force" );
	axis = array_merge( axis, get_ai_group_ai( "village_enemy" ) );
	axis = array_merge( axis, get_ai_group_ai( "village_dog" ) );

	array_delete( axis );
}

aarea_morpheus_init()
{
	autosave_or_timeout( "morpheus", 10 );

	flag_set( "aa_morpheus" );

	flag_set( "village_alley" );

	level thread fall_death();

	generic = get_generic_allies(); 
	for ( i=0; i < generic.size; i++ )
	{
		generic[i] disable_replace_on_death();
	}

	level.steve set_force_color( "g" );
	activate_trigger_with_targetname( "morpheus_color_init" );

	level.steve thread morpheus_allies();
	level.mark thread morpheus_allies();

	setsaveddvar("ai_friendlyFireBlockDuration", 0 );

	morpheus_sets();

	flag_wait( "morpheus_dumpster" );
	setsaveddvar("ai_friendlyFireBlockDuration", level.ai_friendlyFireBlockDuration );

	flag_wait( "apartment_start" );

	setsaveddvar("ai_friendlyFireBlockDuration", 500 );

	flag_clear( "aa_morpheus" );

	level thread aarea_apartment_init();
}

morpheus_allies()
{
	self set_ignoreSuppression( true );
	self.a.disablePain = true;
	self setthreatbiasgroup( "oblivious" );

	flag_wait( "morpheus_dumpster" );

	self set_ignoreSuppression( false );
	self.a.disablePain = false;
	self setthreatbiasgroup( "allies" );
}

morpheus_sets()
{
	array_thread( getentarray( "iron_fence_guy", "script_noteworthy" ), ::add_spawn_function, ::morpheus_iron_fence_spawn_function );

//	level thread morpheus_dumpster();
	level thread morpheus_iron_fence();
	level thread morpheus_flanker();
	level thread morpheus_rpg();
	level thread morpheus_2nd_floor();
	level thread morpheus_single();
//	level thread morpheus_target();
	level thread morpheus_alley();
}

morpheus_completion( completion_notify, dialogue )
{
	level endon( "new_morpheus_set" );

	level waittill( completion_notify );

	level thread radio_dialogue_queue( dialogue );
}

morpheus_dumpster()
{
	flag_wait( "morpheus_dumpster" );
	level notify( "new_morpheus_set" );

	level thread morpheus_completion( "morpheus_dumpster_complete", "ambush_mhp_gotem" );

	waittill_aigroupcleared( "dumpster_front_guy" );
	if ( flag( "morpheus_green_car" ) )
		return;

	level thread radio_dialogue_queue( "ambush_mhp_dumpster" );

	ai = get_ai_group_ai( "dumpster_guy" );
	for( i = 0 ; i < ai.size ; i ++ )
	{
		ai[i] setthreatbiasgroup( "axis" );
	}

	level thread morpheus_dumpster_clear( "morpheus_dumpster_complete" );
	level endon( "morpheus_dumpster_clear" );

	waittill_aigroupcleared( "dumpster_guy" );

	level notify( "morpheus_dumpster_complete" );
}

morpheus_dumpster_clear( completion_notify )
{
	level endon( completion_notify );

	flag_wait( "morpheus_iron_fence" );

	array_thread( get_ai_group_ai( "dumpster_guy" ), ::self_delete );
	level notify( "morpheus_dumpster_clear" );
}

morpheus_iron_fence()
{
	flag_wait( "morpheus_iron_fence" );
	level notify( "new_morpheus_set" );

//	autosave_by_name( "iron_fence" );

	level thread morpheus_completion( "morpheus_iron_fence_complete", "ambush_mhp_goodkill" );

	level thread radio_dialogue_queue( "ambush_mhp_ironfence" );

	level thread morpheus_iron_fence_fight();

	flag_wait( "morpheus_iron_fence_fight" );

	activate_trigger_with_targetname( "iron_fence_color_init" );
}

morpheus_iron_fence_fight()
{
	level endon( "morpheus_iron_fence_fight" );

	level thread set_flag_on_player_action( "morpheus_iron_fence_fight", true, true);

	trigger = getent( "fight_timeout_trigger", "targetname" );
	trigger waittill( "trigger" );

	trigger = getent( "fight_trigger", "targetname" );
	trigger wait_for_trigger_or_timeout( 2.5 );

	flag_set( "morpheus_iron_fence_fight" );
}

morpheus_iron_fence_spawn_function()
{
	if ( flag( "morpheus_iron_fence_fight" ) )
		return;

	self setthreatbiasgroup( "oblivious" );
	self.fixednode = true;

	self endon( "death" );

	flag_wait( "morpheus_iron_fence_fight" );

	randomfloatrange( 0.5, 1.5 );

	self setthreatbiasgroup( "axis" );
	self.fixednode = false;
}

morpheus_flanker()
{
	flag_wait( "morpheus_flanker" );
	level notify( "new_morpheus_set" );

	if ( !get_ai_group_count( "flanker" ) )
		return;

	flag_wait( "morpheus_iron_fence_fight" );

	level thread morpheus_completion( "morpheus_flanker_complete", "ambush_mhp_gotem" );

	level thread radio_dialogue_queue( "ambush_mhp_rightflank" );

	level thread morpheus_flanker_clear( "morpheus_flanker_complete" );
	level endon( "morpheus_flanker_clear" );

	wait 1;
	activate_trigger_with_targetname( "morpheus_flanker_color_init" );

	waittill_aigroupcleared( "flanker" );
	level notify( "morpheus_flanker_complete" );
}

morpheus_flanker_clear( completion_notify )
{
	level endon( completion_notify );
	wait 10;
	level notify( "morpheus_flanker_clear" );
}

morpheus_rpg()
{
	flag_wait( "morpheus_rpg" );
	level notify( "new_morpheus_set" );

	level thread morpheus_completion( "morpheus_rpg_complete", "ambush_mhp_niceone" );

	level thread morpheus_rpg_dialogue();

	level thread morpheus_rpg_clear( "morpheus_rpg_complete" );
	level endon( "morpheus_rpg_clear" );

	waittill_aigroupcleared( "roof_guy" );
	level notify( "morpheus_rpg_complete" );
}

morpheus_rpg_dialogue()
{
	level radio_dialogue_queue( "ambush_mhp_rooftops" );
	level.mark anim_single_queue( level.mark, "ambush_grg_movementroof" );
}

morpheus_rpg_clear( completion_notify )
{
	level endon( completion_notify );

	trigger = getent( "morpheus_rpg_clear", "targetname" );
	trigger waittill( "trigger" );

	array_thread( get_ai_group_ai( "roof_guy" ), ::self_delete );
	level notify( "morpheus_rpg_clear" );
}

morpheus_2nd_floor()
{
	flag_wait( "morpheus_2nd_floor" );

	level notify( "new_morpheus_set" );

	activate_trigger_with_targetname( "roof_guy_spawn_trigger" );

	level thread morpheus_completion( "morpheus_2nd_floor_complete", "ambush_mhp_gotem" );

	level thread radio_dialogue_queue( "ambush_mhp_secondfloor" );

	level thread morpheus_2nd_floor_clear( "morpheus_2nd_floor_complete" );
	level endon( "morpheus_2nd_floor_clear" );

	waittill_aigroupcleared( "floor_guy" );
	level notify( "morpheus_2nd_floor_complete" );
}

morpheus_2nd_floor_clear( completion_notify )
{
	level endon( completion_notify );

	trigger = getent( "morpheus_rpg_clear", "targetname" );
	trigger waittill( "trigger" );

	array_thread( get_ai_group_ai( "floor_guy" ), ::self_delete );
	level notify( "morpheus_2nd_floor_clear" );
}

morpheus_single()
{
	flag_wait( "morpheus_single" );

//	autosave_by_name( "morpheus_single" );

	level notify( "new_morpheus_set" );

	level thread morpheus_single_dialogue();

	level thread morpheus_single_clear( "morpheus_single_complete" );
	level endon( "morpheus_single_clear" );

	waittill_aigroupcleared( "single_guy" );
	level notify( "morpheus_single_complete" );
}

morpheus_single_dialogue()
{
	level radio_dialogue_queue( "ambush_mhp_overturneddump" );
	level.mark anim_single_queue( level.mark, "ambush_grg_bydumpster" );
}

morpheus_single_clear( completion_notify )
{
	level endon( completion_notify );

	trigger = getent( "morpheus_single_clear", "targetname" );
	trigger waittill( "trigger" );

	array_thread( get_ai_group_ai( "single_guy" ), ::self_delete );
	level notify( "morpheus_single_clear" );
}

morpheus_target()
{
	flag_wait( "morpheus_target" );
	level notify( "new_morpheus_set" );

	waittill_aigroupcleared( "single_guy" );
	flag_wait( "morpheus_target_moving" );
	
	level thread radio_dialogue_queue( "ambush_mhp_deadahead" );

	setignoremegroup( "allies", "badguy" );	// badguy ignore allies;
	setignoremegroup( "player", "badguy" );	// badguy ignore player;

	badguy = scripted_spawn( "badguy_runby", "targetname" );
	badguy badguy_spawn_function();

	badguy.moveplaybackrate = 0.64;
	
	badguy waittill( "goal" );

	badguy notify( "stop_death_fail" );
	badguy delete();
}

morpheus_alley()
{
	flag_wait( "morpheus_alley" );
	level notify( "new_morpheus_set" );

	level thread morpheus_completion( "morpheus_alley_complete", "ambush_mhp_allclear" );

	level thread radio_dialogue_queue( "ambush_mhp_alleyleft" );

	level thread morpheus_alley_clear( "morpheus_alley_complete" );
	level endon( "morpheus_alley_clear" );

	flag_wait( "morpheus_green_car" );
	level thread radio_dialogue_queue( "ambush_mhp_greencar" );

	waittill_aigroupcleared( "alley_guy" );
	level notify( "morpheus_alley_complete" );
}

morpheus_alley_clear( completion_notify )
{
	level endon( completion_notify );

	trigger = getent( "morpheus_alley_clear", "targetname" );
	trigger waittill( "trigger" );

	array_thread( get_ai_group_ai( "alley_guy" ), ::self_delete );
	level notify( "morpheus_alley_clear" );
}

detonate_car_setup()
{
	cars = getentarray( "destructible", "targetname" );
	array_thread( getentarray( "detonate_car", "targetname" ), ::detonate_car, cars );
}

detonate_car( cars )
{
	level endon( "apartment_mg_destroyed" );

	org = getent( self.target, "targetname" );
	car = getclosest( org.origin, cars );

	self waittill( "trigger" );
	car maps\_destructible::force_explosion();
}

aarea_apartment_init()
{
	flag_set( "aa_apartment" );

	autosave_by_name( "apartment_start" );

	arcademode_checkpoint( 4, 4 );

	axis = getaiarray( "axis" );
	for( i = 0 ; i < axis.size ; i ++ )
	{
		if ( isdefined( axis[i].script_aigroup ) && axis[i].script_aigroup == "alley_guy" )
			continue;
		axis[i] delete();
	}

	level thread apartment_dialogue();
	level thread apartment_slowdown();
	level thread apartment_badguy();
	level thread apartment_friendlies();

	level thread apartment_mg_nest();

	level thread apartment_helicopter();

	level thread apartment_mg_nest_2();

	level thread apartment_suicide();

	flag_wait( "apartment_inside" );
	autosave_by_name( "inside" );

	flag_wait( "apartment_badguy_3rd_flr" );
	wait 4;
	autosave_by_name( "stairs" );

	flag_wait( "apartment_roof" );
	autosave_by_name( "roof" );

	flag_wait( "mission_done" );

	flag_clear( "aa_apartment" );

	nextmission();
}

apartment_slowdown()
{
	flag_wait( "apartment_roof_friendlies" );
	level.player thread set_playerspeed( 130, 6 );

	flag_wait( "apartment_roof" );
	wait 1.5;
	ai = getaiarray( "allies" );
	for( i = 0 ; i < ai.size ; i ++ )
	{
		if ( is_in_array( level.squad, ai[i] ) )
			continue;
		ai[i] enable_cqbwalk();
	}
}

apartment_helicopter()
{
	flag_wait( "apartment_heli_attack" );

	maps\_spawner::kill_spawnerNum( 6 );

	aim_path_start = getent( "heli_mg_nest_aim_point", "targetname" );
	level.helicopter thread apartment_helicopter_turret( aim_path_start, undefined, 300 );

	struct = getstruct( "helicopter_fire", "script_noteworthy" );
	struct waittill( "trigger" );
	flag_set( "apartment_heli_firing" );

	ent = getent( "mg_destroyed", "script_noteworthy" );
	ent waittill( "trigger" );
	wait 1;
	flag_set( "apartment_mg_destroyed" );

	flag_wait( "apartment_inside" );

	aim_path_start = getent( "heli_ambient_targets", "targetname" );
	level.helicopter thread apartment_helicopter_ambient_turret( aim_path_start, 100 );

	wait_ambient_turret_end();
	level notify( "ambient_turret_end" );

	flag_clear( "apartment_heli_firing" );
	flag_wait( "apartment_mg_4th_flr" );

	aim_path_start = getent( "heli_mg_nest_aim_point_2", "targetname" );
	level.helicopter thread apartment_helicopter_turret( aim_path_start, true, 100 );

	wait 4;
	flag_set( "apartment_heli_firing" );

	maps\_spawner::kill_spawnerNum( 7 );

	ent = getent( "mg_destroyed_2", "script_noteworthy" );
	ent waittill( "trigger" );
	wait 1;

	flag_set( "apartment_mg_destroyed_2" );

	waittill_aigroupcleared( "fourthfloor_guy" );
	flag_set( "apartment_clear" );

	level radio_dialogue_queue( "ambush_mhp_goodtogo" );
}

apartment_helicopter_turret_guy()
{
	drone = spawn( "script_model", (0,0,0) );
	drone character\character_sp_opforce_geoff::main();
	drone.animname = "generic";
	drone UseAnimTree( #animtree );
	drone linkto( self, "tag_origin", ( 0,-32,-25 ), ( 0,90,0 ) );

	level.scr_anim[ "generic" ][ "crouch_shoot" ] = %crouch_shoot_straight;
	self anim_generic_first_frame( drone, "crouch_shoot" );

	self waittill( "death" );
	drone delete();
}

wait_ambient_turret_end()
{
	level endon( "apartment_badguy_3rd_flr" );
	waittill_aigroupcleared( "apartment_main_force" );
}

apartment_helicopter_ambient_turret( aim_path_start, ups )
{
	level notify( "remove_old_turret" );

    turret = spawnturret( "misc_turret", (0,0,0), "heli_minigun_noai" );
    turret setmodel( "cod3mg42" );
	turret.team = "allies";

    turret linkto( level.helicopter, "tag_detach", ( 0, 120, 10 ), ( 0, 0, 0 ) );

	turret thread apartment_helicopter_turret_guy();

    turret maketurretunusable();
    turret setmode( "manual" ); //"auto_ai", "manual", "manual_ai" and "auto_nonai"
    turret setturretteam( "allies" );

	aim_point = aim_path_start;
	aim_ent = spawn( "script_origin", aim_point.origin );
	turret settargetentity( aim_ent );
	turret.target_ent = aim_ent;

	wait 2;

	turret thread manual_mg_fire( 6, 0.5, 3 );
	turret startfiring();

	turret apartment_helicopter_ambient_turret_track( aim_point, aim_ent, ups);

	turret notify( "stop_firing" );
	turret stopfiring();

	level waittill( "remove_old_turret" );
	turret delete();
}

apartment_helicopter_ambient_turret_track( aim_point, aim_ent, ups )
{
	level endon( "ambient_turret_end" );

	while ( isdefined( aim_point.target) )
	{
		aim_point = getent( aim_point.target, "targetname" );
		dist = distance( aim_point.origin, aim_ent.origin );
		move_time = dist/ups;
		aim_ent moveto( aim_point.origin, move_time );
		aim_ent waittill( "movedone" );
		aim_point notify( "trigger" );
		aim_point script_delay();
	}
}

apartment_helicopter_turret( aim_path_start, otherside, ups )
{
	level notify( "remove_old_turret" );

    turret = spawnturret( "misc_turret", (0,0,0), "heli_minigun_noai" );
    turret setmodel( "cod3mg42" );
	turret.team = "allies";

	if ( isdefined( otherside ) )
	    turret linkto( level.helicopter, "tag_detach", ( 0, 120, 10 ), ( 0, 0, 0 ) );
	else
	    turret linkto( level.helicopter, "tag_detach", ( 0, 12, 10 ), ( 0, 180, 0 ) );

	turret thread apartment_helicopter_turret_guy();

    turret maketurretunusable();
    turret setmode( "manual" ); //"auto_ai", "manual", "manual_ai" and "auto_nonai"
    turret setturretteam( "allies" );

	aim_point = aim_path_start;
	aim_ent = spawn( "script_origin", aim_point.origin );
	turret settargetentity( aim_ent );
	turret.target_ent = aim_ent;

	flag_wait( "apartment_heli_firing" );

	turret thread manual_mg_fire( 6, 0.5, 3 );
	turret startfiring();

	turret apartment_helicopter_turret_mg_nest( aim_point, aim_ent, ups );

	turret notify( "stop_firing" );
	turret stopfiring();

	level waittill( "remove_old_turret" );
	turret delete();
}

apartment_helicopter_turret_mg_nest( aim_point, aim_ent, ups )
{
	while ( isdefined( aim_point.target) )
	{
		aim_point = getent( aim_point.target, "targetname" );
		dist = distance( aim_point.origin, aim_ent.origin );
		move_time = dist/ups;
		aim_ent moveto( aim_point.origin, move_time );
		aim_ent waittill( "movedone" );
		aim_point notify( "trigger" );
		aim_point script_delay();
	}

	if ( !flag( "apartment_inside" ) )
		aigroup = "fifthfloor_guy";
	else
		aigroup = "fourthfloor_guy";

	axis = get_ai_group_ai( aigroup );

	while ( isdefined( axis ) && axis.size )
	{
		self settargetentity( axis[0] );
		axis[0] waittill( "death" );
		axis = get_ai_group_ai( aigroup );
	}
}

apartment_friendlies()
{
	flag_wait( "apartment_mg_destroyed" );

	activate_trigger_with_targetname( "apartment_entry_color_init" );
}

apartment_badguy()
{
	flag_wait( "apartment_start" );

	flag_wait_or_timeout( "apartment_badguy_run", 5 );
	flag_set( "apartment_badguy_run" );

	activate_trigger_with_noteworthy( "spawn_mg_nest_ai" );
	flag_set( "apartment_fire");

	badguy = scripted_spawn( "badguy_apartment", "targetname", true );
	level.badguy = badguy;
	badguy badguy_spawn_function();

	badguy notify( "stop_proximity_kill" );

	setignoremegroup( "allies", "badguy" );	// badguy ignore allies;
	setignoremegroup( "player", "badguy" );	// badguy ignore player;

	flag_wait( "apartment_mg_destroyed" );
	badguy set_goalnode( getnode( "badguy_attack_node", "targetname" ) );

	flag_wait( "apartment_badguy_attack" );

	setthreatbias( "player", "badguy", 0 );	// badguy nolonger ignore player;
	setthreatbias( "allies", "badguy", 0 );	// badguy nolonger ignore allies;
	wait 1;

	setignoremegroup( "allies", "badguy" );	// badguy ignore allies;
	setignoremegroup( "player", "badguy" );	// badguy ignore player;

	badguy set_goalnode( getnode( "badguy_third_floor_node", "targetname" ) );

	flag_wait( "apartment_badguy_3rd_flr" );

	badguy set_goalnode( getnode( "badguy_4th_floor_node", "targetname" ) );

	flag_wait( "apartment_roof" );
	badguy set_goalnode( getnode( "badguy_roof_node", "targetname" ) );

}
apartment_dialogue()
{
	level radio_dialogue_queue( "ambush_mhp_fivestory" );
//	level.mark anim_single_queue( level.mark, "ambush_grg_acrosslot" );

	flag_wait( "apartment_fire" );
	flag_set( "apartment_heli_attack" );

	level.steve anim_single_queue( level.steve, "ambush_gaz_heavyfire" );
	level radio_dialogue_queue( "ambush_mhp_firstonefree" );

	flag_wait( "apartment_mg_destroyed" );
	wait 2;
	level radio_dialogue_queue( "ambush_mhp_goodtogo" );
	level radio_dialogue_queue( "ambush_mhp_visual" );
	level.steve anim_single_queue( level.steve, "ambush_gaz_fivestory" );

	flag_wait( "apartment_badguy_attack" );
	wait 6;
	level radio_dialogue_queue( "ambush_mhp_northeast" );

	flag_wait( "apartment_badguy_3rd_flr" );
	level radio_dialogue_queue( "ambush_mhp_staircase" );

	flag_wait( "apartment_mg_4th_flr" );
	level radio_dialogue_queue( "ambush_mhp_deeperinto" );
	level radio_dialogue_queue( "ambush_mhp_holdon" );

	flag_wait( "apartment_mg_destroyed_2" );

	level.mark disable_cqbwalk();
	level.steve disable_cqbwalk();

	flag_wait( "apartment_roof" );
	level thread radio_dialogue_queue( "ambush_mhp_movementroof" );
	wait 3;
	level radio_dialogue_queue( "ambush_mhp_onroof" );
}

apartment_mg_nest()
{
	mg = getent( "apartment_manual_mg", "targetname" );
	mg.team = "axis";

	kill_trigger = getent( "mg_player_kill", "targetname" );
	zone_trigger = getent( "mg_player_target", "targetname" );
	mg thread apartment_mg_killzone( kill_trigger, zone_trigger, "apartment_mg_destroyed" );

	damage_trigger = getent( "mg_nest_damage_trigger", "targetname" );
	level thread apartment_mg_nest_player_damage( "apartment_mg_destroyed", damage_trigger, 600 );

	sandbags = getentarray( "sandbag", "targetname" );
	array_thread( sandbags, ::apartment_mg_nest_sandbag );

	flag_wait( "apartment_fire");

	mg thread manual_mg_fire( 3, 1 );
	mg thread apartment_mg_nest_heli();

	flag_wait( "apartment_mg_destroyed" );

	mg notify( "stop_targeting" );
	mg notify( "stop_firing" );

	fake_mg = spawn( "script_model", mg.origin );
	fake_mg.angles = mg.angles;
	fake_mg setmodel( mg.model );

	mg hide();

	wait 0.9;
	fake_mg physicslaunch( fake_mg.origin + ( 0,-50,0 ), (0,600,0) );

	flag_wait( "apartment_inside" );
	ai = get_ai_group_ai( "fifthfloor_guy" );
	array_thread( ai, ::self_delete );
}

apartment_mg_nest_heli()
{
	level endon( "apartment_mg_destroyed" );
	flag_wait( "apartment_heli_firing" );

	wait 2;

	self notify( "stop_targeting" );
	self settargetentity( level.helicopter );
}

apartment_mg_nest_player_damage( flag_to_set, trigger, health )
{
	while( true )
	{
		trigger waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName );
		if ( attacker != level.player )
			continue;

		if ( damage < 150 )
			damage = 10;
		else
			damage = 150;
		health -= damage;

		if ( health < 0 )
			break;
	}

	flag_set( flag_to_set );
}

apartment_mg_nest_sandbag()
{
	flag_wait( "apartment_mg_destroyed" );

	self script_delay();
	self physicslaunch( self.origin + ( 0,-10,0 ), (0,1500,200) );
}

apartment_mg_nest_2()
{
	mg = getent( "apartment_manual_mg_2", "targetname" );
	mg.team = "axis";

	kill_trigger = getent( "mg_player_kill_2", "targetname" );
	zone_trigger = getent( "mg_player_target_2", "targetname" );
	mg thread apartment_mg_killzone( kill_trigger, zone_trigger, "apartment_mg_destroyed_2" );

	damage_trigger = getent( "mg_nest_damage_trigger_2", "targetname" );
	level thread apartment_mg_nest_player_damage( "apartment_mg_destroyed_2", damage_trigger, 450 );

	getent( "nest_2_clip", "targetname" ) delete();

	explosion_origin = getent( "mg_nest_2_explosion", "targetname" );
	nest_2 = getentarray( "nest_2", "targetname" );
	array_thread( nest_2, ::apartment_mg_nest_2_explosion, explosion_origin.origin );

	flag_wait( "apartment_mg_4th_flr");

	mg thread manual_mg_fire( 1, 1 );

	flag_wait( "apartment_mg_destroyed_2" );

	playfx( level._effect["mg_nest_expl"], explosion_origin.origin );

	mg notify( "stop_targeting" );
	mg notify( "stop_firing" );

	wait 0.5;
	mg delete();
	
}

apartment_mg_nest_2_explosion( explosion_origin )
{
	flag_wait( "apartment_mg_destroyed_2" );

	vector = self.origin - explosion_origin;
	force = vector * 800;

	if ( IsSubStr( self.model, "metal" ) )
		force = force/10;

	self physicslaunch( explosion_origin, force );
}

apartment_mg_killzone( kill_trigger, zone_trigger, ender )
{
	level endon( ender );
	level endon( "mg_player_kill" );

	kill_trigger thread apartment_mg_kill( self, ender );

	while ( true )
	{
		self shoot_mg_targets();
		zone_trigger waittill( "trigger" );

		self notify( "stop_targeting" );
		self settargetentity( level.player );
		while ( level.player istouching( zone_trigger ) ) 
			wait 0.5;
	}
}

apartment_mg_kill( mg, ender )
{
	level endon( ender );

	level.player endon( "death" );
	self waittill( "trigger" );

	level notify( "mg_player_kill" );

	level.player EnableHealthShield( false );

	damagemultiplier = getdvarfloat( "player_damagemultiplier" );

	damage = 25 / damagemultiplier;

	while ( true )
	{
		level.player dodamage( damage , mg.origin );
		wait 0.05;
	}
}

apartment_suicide()
{
	flag_wait( "apartment_roof_friendlies" );
	scripted_array_spawn( "roof_runners", "targetname", true );

	flag_wait( "apartment_stairs" );

	clearallcorpses();

	level thread apartment_suicide_badguy();
	level thread apartment_suicide_price();
	level thread apartment_suicide_dialogue();
}

apartment_suicide_price()
{
	level endon( "missionfailed" );

	level.price = scripted_spawn( "roof_price", "targetname", true );
	level.price thread magic_bullet_shield();
	level.price.animname = "price";
	level.price thread squad_init();
	level.price.name = "Captain Price";

	node = getnode( "price_roof_end", "targetname" );
	ent = getent( "price_roof_ent", "targetname" );
	
	level.price.goalradius = 64;
	level.price setgoalnode( node );

	ent thread anim_loop_solo( level.price, "roof_idle", undefined, "stop_idle" );

	flag_wait_either( "stage3", "timed_suicide" );
	ent notify( "stop_idle" );

	if ( !flag( "timed_suicide" ) )
	{
		level.price anim_single_solo( level.price, "roof_move" );
		level.price thread anim_loop_solo( level.price, "roof_idle", undefined, "stop_idle" );
	}

	flag_wait_either( "forced_suicide", "timed_suicide" );

	wait 0.2;

	level.price notify( "stop_idle" );
}

apartment_suicide_badguy()
{
	level endon( "missionfailed" );
	level endon( "suicide_badguy_interrupt" );

	level.badguy animscripts\shared::placeWeaponOn( level.badguy.secondaryweapon, "right" );

	level.badguy.allowdeath = true;
	level.badguy.dropweapon = false;
	level.badguy.grenadeAmmo = 0;
	level.badguy.health = 10;

	anim_ent = getent( "roof_anim_ent_3", "targetname" );
	anim_ent anim_first_frame_solo( level.badguy, "jump" );

	flag_wait( "apartment_suicide" );

	level.badguy thread apartment_suicide_badguy_fx();
	level thread apartment_suicide_badguy_interrupt();
	level thread apartment_suicide_badguy_timed();

	level endon( "forced_suicide" );

	anim_ent anim_single_solo( level.badguy, "jump" );

	if ( !isalive( level.badguy ) )
		return;

	level.badguy notify( "stop_death_fail" );
	level.badguy.a.nodeath = true;
	level.badguy.allowdeath = true;
	level.badguy dodamage( 10000, (0,0,0) );

	level notify( "slowdown_done" );

	flag_set( "apartment_suicide_done" );
}

apartment_suicide_badguy_timed()
{
	level endon( "missionfailed" );
	level endon( "forced_suicide" );

	time = getanimlength( level.scr_anim[ "badguy" ][ "jump" ] );

	wait ( time * 0.83 );

	flag_set( "timed_suicide" );

	wait 0.5;

	level.badguy.allowdeath = false;
	level thread slowdown();
}

apartment_suicide_badguy_fx()
{
	self waittillmatch( "single anim", "fire" );
	origin = self gettagorigin( "tag_flash" );
	angles = self gettagangles( "tag_flash" );

	vector = AnglesToForward( angles );
	origin = origin + vector_multiply( vector, 8 );

	thread play_sound_in_space( "ambush_soz_shot", origin );

	PlayFX( level._effect["head_fatal"], origin, AnglesToForward( angles ), AnglesToUp( angles ) );

	wait 1.5;

	angles = ( 270, 0, 0 );
	origin = ( -4688, -9280, 659.5 );
	PlayFX( level._effect["bloodpool"], origin, AnglesToForward( angles ), AnglesToUp( angles ) );
}

apartment_suicide_badguy_interrupt()
{
	level endon( "missionfailed" );
	level endon( "timed_suicide" );

	trigger = getent( "force_suicide", "targetname" );
	trigger waittill( "trigger" );

	flag_set( "forced_suicide" );

	if ( !isalive( level.badguy ) )
		return;

	level.player disableweapons();

	level thread slowdown();
	level.player thread set_playerspeed( 60, 0.25 );

	level.badguy stopanimscripted();
	level.badguy notify( "single anim", "end" );

	level.badguy.allowdeath = false;

	anim_ent = getent( "roof_anim_ent_3", "targetname" );
	anim_ent anim_single_solo( level.badguy, "quick_jump" );

	if ( !isalive( level.badguy ) )
		return;

	level.badguy notify( "stop_death_fail" );
	level.badguy.a.nodeath = true;
	level.badguy.allowdeath = true;
	level.badguy dodamage( 10000, (0,0,0) );

	level notify( "slowdown_done" );
	level.player thread set_playerspeed( 140, 2 );

	flag_set( "apartment_suicide_done" );
}

slowdown()
{
	slowmo_start();
	
		slowmo_setspeed_slow( .3 );
		slowmo_setlerptime_in( .6 );
		slowmo_lerp_in();	

		level waittill( "slowdown_done" );
		
		slowmo_setlerptime_out( 1.2 );
		slowmo_lerp_out();
			
	slowmo_end();
}

apartment_suicide_dialogue()
{
//	level.badguy anim_single_queue( level.badguy, "ambush_soz_stopthebloodshed" );

//	wait 2;

	level endon( "missionfailed" );

	flag_set( "gaz_shouts_at_zakhaev" );

	level.steve anim_single_queue( level.steve, "ambush_gaz_dropgun" );

	wait 1; 
	level.mark anim_single_queue( level.mark, "ambush_grg_inhisleg" );

	level.price thread anim_single_queue( level.price, "ambush_pri_cantriskit" );

	level.price thread restrain_dialogue();
	level.mark thread dropgun_dialogue();
	flag_set( "obj_flexicuff" );

	flag_wait_either( "forced_suicide", "timed_suicide" );

	level.steve anim_single_queue( level.steve, "ambush_gaz_no" );

//	level.badguy anim_single_queue( level.badguy, "ambush_soz_deadsoonanyway" );
//	level.badguy anim_single_queue( level.badguy, "ambush_soz_gofyourself" );

	flag_wait( "apartment_suicide_done" );

	wait 1.5;

	arcadeMode_stop_timer();

	level.mark anim_single_queue( level.mark, "ambush_grg_kidissues" );


//	todo: switch once new dialogue is in. - done
	level.price anim_single_queue( level.price, "ambush_pri_sonisdead" );
//	level.price anim_single_queue( level.price, "ambush_pri_2isdead" );

	wait 2;

	level.steve anim_single_queue( level.steve, "ambush_gaz_onlylead" );
	level.price anim_single_queue( level.price, "ambush_pri_knowtheman" );

	flag_set( "mission_done" );
}

dropgun_dialogue()
{
	level endon( "missionfailed" );
	level endon( "forced_suicide" );
	level endon( "timed_suicide" );

	wait 5;

	level.steve anim_single_queue( level.steve, "ambush_gaz_dropit" );
	wait 1;
	level.steve anim_single_queue( level.steve, "ambush_gaz_dropitnow" );
}

restrain_dialogue()
{
	level endon( "missionfailed" );
	level endon( "forced_suicide" );
	level endon( "timed_suicide" );

	level.price anim_single_queue( level.price, "ambush_pri_restrainhim" );
	wait 3;
	level.price anim_single_queue( level.price, "ambush_pri_restrainnow" );
}

/**********/

failed_to_pursue()
{
	array_thread( getentarray( "failed_to_pursue", "targetname" ), ::failed_to_pursue_trigger );

	level thread failed_to_pursue_timer( 35 );
	flag_wait( "junkyard_exit" );
	level notify( "made the time" );

	level thread failed_to_pursue_timer( 15, "ambush_mhp_guyshaulin" );
	flag_wait( "village_road" );
	level notify( "made the time" );

	autosave_or_timeout( "village_road", 10 );

	flag_wait( "village_alley" );

	autosave_or_timeout( "village_alley", 5 );

	level thread failed_to_pursue_timer( 35, "ambush_mhp_getaway" );
	flag_wait( "morpheus_dumpster" );
	level notify( "made the time" );

	autosave_or_timeout( "morpheus_dumpster", 5 );

	level thread failed_to_pursue_timer( 30, "ambush_mhp_guyshaulin" );
	flag_wait( "morpheus_iron_fence" );
	level notify( "made the time" );

	autosave_or_timeout( "morpheus_iron_fence", 20 );

	arcademode_checkpoint( 7, 3 );

	level thread failed_to_pursue_timer( 120, "ambush_mhp_betterhurry" );
	flag_wait( "morpheus_target_moving" );
	level notify( "made the time" );

	autosave_or_timeout( "morpheus_target_moving", 8 );

	level thread failed_to_pursue_timer( 50, "ambush_mhp_gonnalose" );
	flag_wait( "apartment_start" );
	level notify( "made the time" );
}

failed_to_pursue_timer( failtime_sec, nag )
{
	level endon( "made the time" );

	failtime = gettime() + ( failtime_sec * 1000 );

	if ( isdefined( nag ) ) 
	{
		// Nags after 75% of the allotted time
		nagtime = gettime() + ( int( failtime_sec * 0.65 ) * 1000 );
		while( nagtime > gettime() )
			wait 1;
		level thread radio_dialogue_queue( nag );
	}

	while( failtime > gettime() )
		wait 1;

	if ( IsSaveRecentlyLoaded() )
		wait 10;

	thread failed();
}

failed()
{
	i = randomint( 4 );
	level thread radio_dialogue_queue( "ambush_mhp_losthim_" + i );
	wait 1.5;

	setdvar( "ui_deadquote", "@AMBUSH_MISSIONFAIL_ESCAPED" );
	maps\_utility::missionFailedWrapper();
}

failed_to_pursue_trigger()
{
	self waittill( "trigger" );

	level notify( "made the time" );

	thread failed();
}

/**** badguy generic functions ****/

badguy_spawn_function()
{
	self.name = "V. Zakhaev";
	self.animname = "badguy";

	self set_battlechatter( false );

	self setthreatbiasgroup( "badguy" );
	self.fixednode = true;

	self thread badguy_died();
	self thread badguy_proximity_kill();

	self set_ignoreSuppression( true );
	self.a.disablePain = true;
	self.grenadeawareness = 1;
	self setFlashbangImmunity( true );
	self.script_immunetoflash = true;
}

badguy_died( health_multiplier )
{
	if ( !isdefined( health_multiplier ) )
		health_multiplier = 3;

	self endon( "stop_death_fail" );

	self.health = self.health * health_multiplier;

	self waittill( "death" );
	setdvar( "ui_deadquote", "@AMBUSH_MISSIONFAIL_KILLED_TARGET" );
	maps\_utility::missionFailedWrapper();
}

badguy_proximity_kill()
{
	// will try to kill the player if he gets to close.

	self  endon( "stop_proximity_kill" );
	level.player endon( "death" );
	self endon( "death" );

	old_accuracy = self.baseAccuracy;

	while( true )
	{
			while( distance2d( level.player.origin, self.origin ) > 350 )
				wait 0.1;

			self.baseAccuracy = self.baseAccuracy * 10;

			// make badguy hate player
			setthreatbias( "player", "badguy", 100000 );

			while( distance2d( level.player.origin, self.origin ) < 400 )
				wait 0.1;

			self.baseAccuracy = old_accuracy;
			// make group1 hate group2 
			setthreatbias( "player", "badguy", 0 );
	}
}

/******* start points *******/ 

start_default()
{
	aarea_takeover_init();
}

start_ambush()
{
	// turn old triggers off.
	array_thread( getentarray( "takeover_trigger", "script_noteworthy" ) , ::trigger_off );

	// turn village triggers off.
	array_thread( getentarray( "village_trigger", "script_noteworthy" ) , ::trigger_off );

	setup_friendlies( 3 );
	start_teleport_squad( "ambush" );

	blocker = getent( "takeout_path_blocker", "targetname" );
	blocker connectpaths();
	blocker delete();

	getent( "gate_open", "targetname" ) hide();
	getent( "rear_blocker_open", "targetname" ) hide();

	level thread guardtower_dead_enemies();
	flag_set( "takeover_fade_clear" );
	flag_set( "takeover_fade_done" );
	flag_set( "takeover_briefing_done" );

	aarea_ambush_init();
}

start_village()
{
	setup_friendlies( 3 );
	start_teleport_squad( "village" );

	flag_set( "takeover_done" );

	ResetSunLight();
	setsaveddvar( "r_specularcolorscale", "1" );

	level.player setthreatbiasgroup( "player" );

	activate_trigger_with_targetname( "ambush_attack_color_init" );

	// turn old triggers off.
	array_thread( getentarray( "takeover_trigger", "script_noteworthy" ) , ::trigger_off );

	// turn village triggers off.
	array_thread( getentarray( "village_trigger", "script_noteworthy" ) , ::trigger_off );

	blocker = getent( "takeout_path_blocker", "targetname" );
	blocker connectpaths();
	blocker delete();

	blocker = getent( "rear_blocker", "targetname" );
	blocker connectpaths();
	blocker delete();

	guard_tower = getent( "guard_tower", "targetname" );
	parts = getentarray( "guard_tower_part", "targetname" );
	for( i = 0 ; i < parts.size ; i ++ )
		parts[i] delete();
	guard_tower delete();
	sandbags = getentarray( "guard_tower_sandbags", "targetname" );
	for( i = 0 ; i < sandbags.size ; i ++ )
		sandbags[i] delete();

	level.helicopter = maps\_vehicle::spawn_vehicle_from_targetname( "blackhawk" );
	struct = getstruct( "village_heli_start", "targetname" );
	level.helicopter thread heli_path_speed( struct );

	aarea_village_init();
}

start_morpheus()
{
	setup_friendlies( 0 );
	start_teleport_squad( "morpheus" );

	ResetSunLight();
	setsaveddvar( "r_specularcolorscale", "1" );

	level.player setthreatbiasgroup( "player" );

	activate_trigger_with_targetname( "village_retreat_2_color_init" );

	level.helicopter = maps\_vehicle::spawn_vehicle_from_targetname( "blackhawk" );
	struct = getstruct( "apartment_heli_start", "targetname" );
	level.helicopter thread heli_path_speed( struct );

	aarea_morpheus_init();
}

start_apartment()
{
	setup_friendlies( 0 );
	start_teleport_squad( "apartment" );

	ResetSunLight();
	setsaveddvar( "r_specularcolorscale", "1" );

	level.player setthreatbiasgroup( "player" );

	level.steve set_force_color( "g" );

	activate_trigger_with_targetname( "apartment_color_init" );

	level.helicopter = maps\_vehicle::spawn_vehicle_from_targetname( "blackhawk" );
	struct = getstruct( "apartment_heli_start", "targetname" );
	level.helicopter thread heli_path_speed( struct );

	flag_wait( "apartment_start" );

	aarea_apartment_init();
}

/********* setup and utilities *********/

setup_friendlies( extras )
{
	if ( !isdefined( extras ) )
		extras = 0;

	level.squad = [];

	level.price = scripted_spawn( "price", "targetname", true );
	level.price thread magic_bullet_shield();
	level.price.animname = "price";
	level.price thread squad_init();
	level.price.name = "Captain Price";

	level.mark = scripted_spawn( "mark", "targetname", true );
	level.mark.script_bcdialog = false;
	level.mark thread magic_bullet_shield();
	level.mark.animname = "mark";
	level.mark thread squad_init();
	level.mark.battlechatter = false;
	level.mark.name = "SSgt. Griggs";

	level.steve = scripted_spawn( "steve", "targetname", true );
	level.steve thread magic_bullet_shield();
	level.steve.animname = "steve";
	level.steve.name = "Gaz";
	level.steve thread squad_init();

	getent( "kamarov", "script_noteworthy" ) add_spawn_function( ::kamarov );

	allied_spawner = getentarray( "allies", "targetname" );

	for ( i=0; i<extras; i++ )
	{
		ai = scripted_spawn( undefined, undefined, true, allied_spawner[i] );
		ai generic_allied();
	}

	array_thread( getentarray( "color_spawner", "targetname" ), ::add_spawn_function, ::generic_allied );
}

kamarov()
{
	self endon( "death" );

	level.kamarov = self;
	self.name = "Sgt. Kamarov";
	self thread magic_bullet_shield();

	flag_wait( "takeover_fade_clear" );

	self stop_magic_bullet_shield();
}

squad_init()
{
	level.squad[ level.squad.size ] = self;
	self waittill( "death" );
	level.squad = array_remove( level.squad, self );
}

generic_allied()
{
	self.animname = "generic";
	self thread squad_init();
}

get_generic_allies()
{
	ai = [];
	for( i = 0 ; i < level.squad.size ; i ++ )
	{
		if ( level.squad[i].animname == "generic" )
			ai[ ai.size ] = level.squad[i];
	}
	return ai;
}

scripted_spawn( value, key, stalingrad, spawner )
{
	if ( !isdefined( spawner ) )
		spawner = getent( value, key );

	if ( isdefined( stalingrad ) )
		ai = spawner stalingradSpawn();
	else
		ai = spawner dospawn();
	spawn_failed( ai );
	assert( isDefined( ai ) );
	return ai;
}

scripted_array_spawn( value, key, stalingrad )
{
	spawner = getentarray( value, key );
	ai = [];

	for ( i=0; i<spawner.size; i++ )
		ai[i] = scripted_spawn( value, key, stalingrad, spawner[i] );
	return ai;
}

start_teleport_squad( startname )
{
	node = getnode( "startnodeplayer_"+ startname, "targetname" );
	level.player setorigin ( node.origin );
	level.player setplayerangles ( node.angles );

	for ( i=0; i<level.squad.size; i++ )
	{
		level.squad[i] notify( "stop_going_to_node" );
		nodename = "startnode" + level.squad[i].animname + "_" + startname;
		node = getnodearray( nodename, "targetname" );
		level.squad[i] start_teleport( node );
	}
}

start_teleport( node )
{
	if ( node.size > 1 )
	{
		for ( i=0; i<node.size; i++ )
		{
			if ( isdefined( node[i].teleport_used ) )
				continue;
			node = node[i];
			break;
		}
	}
	else
		node = node[0];

	node.teleport_used = true;

	self teleport ( node.origin, node.angles );
	self setgoalpos ( self.origin );
	self.goalradius = node.radius;
	self setgoalnode ( node );
}

delete_dropped_weapons()
{
	wc = [];
	wc = array_add( wc, "weapon_ak47" );
	wc = array_add( wc, "weapon_beretta" );
	wc = array_add( wc, "weapon_g36c" );
	wc = array_add( wc, "weapon_m14" );
	wc = array_add( wc, "weapon_m16" );
	wc = array_add( wc, "weapon_m203" );
	wc = array_add( wc, "weapon_rpg" );
	wc = array_add( wc, "weapon_saw" );
	wc = array_add( wc, "weapon_m4" );
	wc = array_add( wc, "weapon_m40a3" );
	wc = array_add( wc, "weapon_mp5" );
	wc = array_add( wc, "weapon_mp5sd" );
	wc = array_add( wc, "weapon_usp" );
	wc = array_add( wc, "weapon_at4" );
	wc = array_add( wc, "weapon_dragunov" );
	wc = array_add( wc, "weapon_g3" );
	wc = array_add( wc, "weapon_uzi" );

	for( i = 0 ; i < wc.size ; i ++ )
	{
		weapons = getentarray( wc[i], "classname" );
		for( n = 0 ; n < weapons.size ; n ++ )
		{
			if ( isdefined( weapons[n].targetname ) )
				continue;
			weapons[n] delete();
		}
	}
}

shoot_mg_targets()
{
	self endon( "stop_targeting" );

	self setmode( "manual" );
	self setbottomarc( 60 );
	self setleftarc( 60 );
	self setrightarc( 60 );

	all_targets = getentarray( self.target, "targetname" );
	all_targets = array_add( all_targets, level.player );

	target = undefined;

	while ( true )
	{
		if ( isdefined( target ) )
			excl[0] = target;
		else
			excl = undefined;
	
		targets = get_array_of_closest( level.player.origin, all_targets, excl, 3);
		target = random( targets );
		self settargetentity( target );
		wait( randomfloatrange( 1, 3 ) );
	}
}

manual_mg_fire( burst, cooldown, extra_bullets )
{
	self endon( "stop_firing" );
	self.turret_fires = true;

	if ( !isdefined( extra_bullets ) )
		extra_bullets = 0;
	
	for ( ;; )
	{
		timer = randomfloatrange( 0.8, 1.5 ) * burst * 20;
		if ( self.turret_fires )
		{
			for ( i = 0; i < timer; i++ )
			{
				self shootturret();
				wait( 0.05 );
			}
		}

		if ( self.team != "allies" && randomint(2) )
		{
			while ( !BulletTracePassed( self gettagorigin( "tag_flash" ), level.player geteye(), false, self ) )
				wait 0.05;
		}

		wait randomfloatrange( 0.6, 1.2 ) * cooldown;
	}
}

random_offest( offset )
{
	return( offset - randomfloat( offset*2 ), offset - randomfloat( offset*2 ), offset - randomfloat( offset*2 ) );
}

set_playerspeed( player_speed, transition_time )
{
	base_speed = 190;

	if ( !isdefined( level.player.MoveSpeedScale ) )
		level.player.MoveSpeedScale = 1;

	if ( !isdefined(transition_time) )
		transition_time = 0;

	steps = abs( int( transition_time*4 ) );

	targetMoveSpeedScale = player_speed / base_speed;
	difference = level.player.MoveSpeedScale - targetMoveSpeedScale;

	for( i=0; i<steps; i++ )
	{	
		level.player.MoveSpeedScale -= difference/steps;
		level.player setMoveSpeedScale( level.player.MoveSpeedScale );
		wait 0.5;
	}

	level.player.MoveSpeedScale = targetMoveSpeedScale;
	level.player setMoveSpeedScale( level.player.MoveSpeedScale );
}

grenade_notifies()
{
	while ( true )
	{
		level.player waittill("grenade_fire", grenade, weapname);
		grenade thread notify_on_detonation( weapname );
	}
}

notify_on_detonation( weapname )
{
	while ( isdefined( self ) )
		wait 0.1;

	level.player notify( weapname );
}

set_flag_on_player_action( flag_str, flash, grenade )
{
	level notify( "kill_action_flag" );
	level endon( "kill_action_flag" );
	level endon( flag_str );

	if ( flag( flag_str ) )
		return;

	while ( true )
	{
		msg = level.player waittill_any_return( "weapon_fired", "fraggrenade", "flash_grenade" );
		if ( !isdefined(msg) )
			break;
		if ( msg == "weapon_fired" )
			break;
		if ( msg == "fraggrenade" && isdefined( grenade ) )
			break;
		if ( msg == "flash_grenade" && isdefined( flash ) )
			break;
	}

	flag_set( flag_str );
}

kill_ai( mindelay, maxdelay )
{
	self endon( "death" );

	randomfloat( mindelay, maxdelay );
	self dodamage( self.health * 1.5, level.player.origin );
}

create_overlay_element( shader_name, start_alpha )
{
	overlay = newHudElem();
	overlay.x = 0;
	overlay.y = 0;
	overlay setshader ( shader_name, 640, 480);
	overlay.alignX = "left";
	overlay.alignY = "top";
	overlay.horzAlign = "fullscreen";
	overlay.vertAlign = "fullscreen";
	overlay.alpha = start_alpha;
	overlay.foreground = true;
	overlay.sort = 2;
	return overlay;
}

hud_hide( state )
{
	wait 0.05;

	if ( isdefined( state ) && !state )
	{
		setdvar( "ui_hud_showstanceicon", "1" );
		SetSavedDvar( "compass", "1" );
		SetSavedDvar( "ammoCounterHide", "0" );
	}
	else
	{
		setdvar( "ui_hud_showstanceicon", "0" );
		SetSavedDvar( "compass", "0" );
		SetSavedDvar( "ammoCounterHide", "1" );
	}
}

setup_vehicle_pause_node()
{
	array_thread( getvehiclenodearray( "pause_node", "script_noteworthy" ), ::vehicle_pause_node );
}

vehicle_pause_node()
{
	self waittill( "trigger", vehicle );	
	vehicle setspeed( 0, 60 );
	wait self.script_delay;
	vehicle resumespeed( 20 );
}

adjust_angles_to_player( stumble_angles )
{
		pa = stumble_angles[0];
		ra = stumble_angles[2];

		rv = anglestoright( level.player.angles );
		fv = anglestoforward( level.player.angles );

		rva = ( rv[0], 0, rv[1]*-1 );
		fva = ( fv[0], 0, fv[1]*-1 );
		angles = vector_multiply( rva, pa );
		angles = angles + vector_multiply( fva, ra );
		return angles + ( 0, stumble_angles[1], 0 );
}

set_goalnode( node )
{
	self setgoalnode( node );
	if ( isdefined( node.radius ) )
		self.goalradius = node.radius;
}

delete_on_goal()
{
	self endon( "death" );
	self waittill( "goal" );
	while ( self cansee( level.player ) )
		wait 1;
	self delete();
}

kill_guy( origin )
{
	if ( isalive( self ) )
		self dodamage( self.health * 2, origin );
}

heli_path_speed( struct )
{
	if( isdefined( struct ) && isdefined( struct.speed ) )
	{
		accel = 25; 
		decel = undefined;
		if( isdefined( struct.script_decel ) )
		{
			decel = struct.script_decel;
		}
		speed = struct.speed;

		if( isdefined( struct.script_accel ) )
		{
			accel = struct.script_accel;
		}
		else
		{
			max_accel = speed / 4;
			if( accel > max_accel )
			{
				accel = max_accel;
			}
		}
		if ( isdefined( decel ) )
		{
			self setSpeed( speed, accel, decel );
		}
		else
		{
			self setSpeed( speed, accel );
		}
	}

	maps\_vehicle::vehicle_paths( struct );
}

fixednode_trigger_setup()
{
	array_thread( getentarray( "fixednode_set", "targetname" ), ::fixednode_set );
	array_thread( getentarray( "fixednode_unset", "targetname" ), ::fixednode_unset );
}

fixednode_set()
{
	while( true )
	{
		self waittill( "trigger", ai );
		if ( !ai.fixednode )
			ai.fixednode = true;
	}
}

fixednode_unset()
{
	while( true )
	{
		self waittill( "trigger", ai );
		if ( ai.fixednode )
			ai.fixednode = false;
	}
}

fall_death()
{
	trigger = getent( "fall_death", "targetname" );
	while( true )
	{
		trigger waittill( "trigger", ai );
		if ( ai isragdoll() )
			continue;

		if ( getdvarint( "ragdoll_enable" ) )
		{
			ai.skipdeathanim = true;
			ai die();
		}
		else
			ai die();
	}
}

// from launchfacility_a, minor changes.
vehicle_turret_think()
{
	self endon ("death");
	self endon ( "c4_detonation" );
	self thread maps\_vehicle::mgoff();
	self.turretFiring = false;
	eTarget = undefined;

	currentTargetLoc = undefined;

	while (true)
	{
		wait (0.05);
		/*-----------------------
		TRY TO GET THE PLAYER AS A TARGET FIRST
		-------------------------*/		
		if ( !isdefined(eTarget) )
			eTarget = self vehicle_get_target_player_only();
		else if ( ( isdefined(eTarget) ) && ( eTarget != level.player ) )
			eTarget = self vehicle_get_target_player_only();
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
				//self clearTurretTarget();
				eTarget = self vehicle_get_target(level.bmpExcluders);
			}
				
		}
		/*-----------------------
		IF PLAYER ISN'T CURRENT TARGET, GET ANOTHER
		-------------------------*/	
		else
			eTarget = self vehicle_get_target(level.bmpExcluders);

		/*-----------------------
		ROTATE TURRET TO CURRENT TARGET
		-------------------------*/		
		if ( (isdefined(eTarget)) && (isalive(eTarget)) )
		{
			targetLoc = eTarget.origin + (0, 0, 32);
			self setTurretTargetVec(targetLoc);
			
			
			if (getdvar("debug_bmp") == "1")
				thread draw_line_until_notify(self.origin + (0, 0, 32), targetLoc, 1, 0, 0, self, "stop_drawing_line");
			
			fRand = ( randomfloatrange(2, 3));
			self waittill_notify_or_timeout( "turret_rotate_stopped", fRand );

			/*-----------------------
			FIRE MAIN CANNON OR MG
			-------------------------*/
			if ( (isdefined(eTarget)) && (isalive(eTarget)) )
			{
				if ( distancesquared(eTarget.origin,self.origin) <= level.bmpMGrangeSquared)
				{
					if (!self.mgturret[0] isfiringturret())
						self thread maps\_vehicle::mgon();
					
					wait(.5);
					if (!self.mgturret[0] isfiringturret())
					{
						self thread maps\_vehicle::mgoff();
						if (!self.turretFiring)
							self thread vehicle_fire_main_cannon();			
					}
	
				}
				else
				{
					self thread maps\_vehicle::mgoff();
					if (!self.turretFiring)
						self thread vehicle_fire_main_cannon();	
				}				
			}

		}
		
		//wait( randomfloatrange(2, 5));
	
		if (getdvar( "debug_bmp") == "1")
			self notify( "stop_drawing_line" );
	}
}

vehicle_fire_main_cannon()
{
	self endon ("death");
	self endon ( "c4_detonation" );
	//self notify ("firing_cannon");
	//self endon ("firing_cannon");
	
	iFireTime = weaponfiretime("bmp_turret");
	assert(isdefined(iFireTime));
	
	iBurstNumber = randomintrange(3, 8);
	
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

vehicle_get_target(aExcluders)
{
									//  getEnemyTarget( fRadius, iFOVcos, getAITargets, doSightTrace, getVehicleTargets, randomizeTargetArray, aExcluders )
	eTarget = maps\_helicopter_globals::getEnemyTarget( level.bmpCannonRange, level.cosine[ "180" ], true, true, false, true, aExcluders);
	return eTarget;
}

vehicle_get_target_player_only()
{
	aExcluders = level.squad;
									//  getEnemyTarget( fRadius, 			iFOVcos, 				getAITargets, doSightTrace, getVehicleTargets, randomizeTargetArray, aExcluders )
	eTarget = maps\_helicopter_globals::getEnemyTarget( level.bmpCannonRange, level.cosine[ "180" ], false, true, false, false, aExcluders);
	return eTarget;
}

music_control()
{
	//ambush_somber_music ( 120 s )
	//ambush_trucks_music ( 117 s)
	//ambush_chase_music ( 136 s )
	//ambush_standoff_music ( stop at 24 s )
	
	wait( 1 );
	
	thread music_playback( "ambush_somber_music", 120, true, 1 );
	
	flag_wait( "takeover_fade" );
	level notify ( "next_music_track" );
	musicstop( 6 );
	
	flag_wait( "caravan_on_the_move" );
	wait 3;
	thread music_playback( "ambush_trucks_music", 117 );
	
	flag_wait( "player_tower_hits_ground" );
	level notify ( "next_music_track" );
	musicstop();
	wait 1;
	
	flag_wait( "son_of_zakhaev_money_shot" );
	wait 4;
	thread music_playback( "ambush_chase_music", 136, true, 1 );
	
	flag_wait( "apartment_roof" );
	level notify ( "next_music_track" );
	musicstop( 6 );
	wait 6.5;
	
	flag_wait( "gaz_shouts_at_zakhaev" );
	thread music_playback( "ambush_standoff_music", 211 );
	
	while( 1 )
	{
		if( flag( "forced_suicide" ) || flag( "apartment_suicide_done" ) )
		{
			level notify ( "next_music_track" );
			musicstop();
			break;
		}
			
		wait 0.05;
	}
	
	flag_wait( "apartment_suicide_done" );
	level notify ( "next_music_track" );
	musicstop( 3 );
	wait 3.1;
	thread music_playback( "ambush_somber_music", 120 );
}

music_playback( cuename, cuelength, repeating, repeatgap )
{
	level endon( "next_music_track" );
	
	assertEX( isdefined( cuename ), "specify an alias to play" );
	assertEX( isdefined( cuelength ), "specify the length of the music cue in seconds" );
	
	if ( !isdefined( repeating ) )
		repeating = false;
		
	if ( !isdefined( repeatgap ) )
		repeatgap = 1;
	
	if ( repeating )
	{
		while ( 1 )
		{
			MusicPlayWrapper( cuename );
			wait cuelength;
			musicstop();
			wait repeatgap;
		}
	}
	else
	{
		MusicPlayWrapper( cuename );
	}
}