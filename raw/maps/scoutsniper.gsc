#include common_scripts\utility;
#include maps\_utility;
#include maps\_vehicle;
#include maps\_anim;
#include maps\scoutsniper_code;
#include maps\_stealth_logic;

#using_animtree( "generic_human" );
main()
{
	setsaveddvar( "sm_sunShadowScale", "0.7" ); // optimization

	//flags
	flag_init( "initial_setup_done" );
	
	flag_init( "intro" );
	flag_init( "intro_patrol_guy_down" );
	flag_init( "intro_patrol_guys_dead" );
	flag_init( "intro_last_patrol_dead" );
	flag_init( "intro_leave_area" );
	flag_init( "intro_safezone" );
	flag_init( "intro_left_area" );
	
	flag_init( "church_dialogue_done" );
	flag_init( "church_patroller_dead" );
	flag_init( "church_patroller_faraway" );
	flag_init( "church_lookout_dead" );
	flag_init( "church_area_clear" );
	flag_init( "church_guess_he_cant_see" );
	flag_init( "church_run_for_it" );
	flag_init( "church_door_open" );
	flag_init( "church_and_intro_killed" );
	flag_init( "church_ladder_slide" );
	flag_init( "church_sneakup_dialogue_help" );
	flag_init( "church_start_patroller_line" );
	flag_init( "church_run_for_it_commit" );
	
	flag_init( "graveyard");
	flag_init( "graveyard_moveup" );
	flag_init( "graveyard_church_ladder" );
	flag_init( "graveyard_hind_ready" );
	flag_init( "graveyard_price_at_wall" );
	flag_init( "graveyard_get_down" );
	flag_init( "graveyard_hind_gone" );
	flag_init( "graveyard_hind_down" );
	flag_init( "graveyard_hind_flare" );
	flag_init( "graveyard_church_breakable" );
	
	flag_init( "field" );		
	flag_init( "field_getdown" );
	//flag_init( "field_spawn" );
	flag_init( "field_start" );
	flag_init( "field_price_done" );
	flag_init( "field_start_running" );
	flag_init( "field_stop_bmps" );
		
	//flag_init( "pond"); trigger flag in radient
	flag_init( "pond_enemies_dead" );
	flag_init( "pond_patrol_spawned" );
	flag_init( "pond_thrower_spawned" );
	flag_init( "pond_backup_spawned" );
	flag_init( "pond_patrol_dead" );
	flag_init( "pond_thrower_dead" );
	flag_init( "pond_thrower_kill" );
	
	//flag_init( "cargo" ); trigger flag in radient
	flag_init( "cargo_enemy_ready_to_defend1" );
	flag_init( "cargo_enemy_defend_moment_past" );
	flag_init( "cargo_started_defend_moment" );
	flag_init( "cargo_patrol_defend1_dead" );
	flag_init( "cargo_defender1_away" );
	flag_init( "cargo_patrol_away" );
	flag_init( "cargo_patrol_danger" );
	flag_init( "cargo_patrol_dead" );
	flag_init( "cargo_enemies_dead" );;
	flag_init( "cargo_price_ready_to_kill_patroller" );
	flag_init( "cargo_price_ready_to_attack1" );
	flag_init( "cargo_smokers_spawned" );
	
	flag_init( "dash" );
	flag_init( "dash_spawn" );
	flag_init( "dash_start" );
	flag_init( "dash_last" );
	flag_init( "dash_hind_down" );
	flag_init( "dash_guard_check1" );
	flag_init( "dash_guard_check2" );
	flag_init( "dash_guard_check3" );
	flag_init( "dash_sniper" );
	flag_init( "dash_sniper_dead" );
	flag_init( "dash_stealth_unsure" );
	flag_init( "dash_door_R_open" );
	flag_init( "dash_door_L_open" );
	flag_init( "dash_heli_agro" );
	flag_init( "dash_hind_deleted" );
	flag_init( "dash_crawl_patrol_spawned" );
	flag_init( "dash_reset_stealth_to_default" );
	flag_init( "dash_work_as_team" );
	
	flag_init( "heli_gun" );
	flag_init( "heli_rocket" );
	flag_init( "hind_spotted" );
	
	flag_init( "town" );
	//flag_init( "town_jumpdown" );	trigger flag in radient
	//flag_init( "town_no_turning_back" );	trigger flag in radient
	
	flag_init( "dogs" );
	flag_init( "dogs_dog_dead" );
	flag_init( "dogs_backup" );
	flag_init( "dogs_delete_dogs" );
	
	flag_init( "center" );
	
	flag_init( "end" );
	flag_init( "end_start_music" );
	//flag_init( "level_complete" );	trigger flag in radient
	
	setsaveddvar( "compassmaxrange", 8000 );
	
	flag_init( "prone_hint" );
	flag_init( "broke_stealth" );
	
	level.hearing_distance = 512;
			
	//starts
	default_start( ::start_intro );
	add_start( "church", ::start_church, &"STARTS_CHURCH" );
	add_start( "church_x", ::start_church_x, &"STARTS_CHURCHX" );
	add_start( "graveyard", ::start_graveyard, &"STARTS_GRAVEYARD" );
	add_start( "graveyard_x", ::start_graveyard_x, &"STARTS_GRAVEYARDX" );
	add_start( "field", ::start_field, &"STARTS_FIELD" );
	add_start( "pond", ::start_pond, &"STARTS_POND" );
	add_start( "cargo", ::start_cargo, &"STARTS_CARGO" );
	add_start( "dash", ::start_dash, &"STARTS_DASH" );
	add_start( "town", ::start_town, &"STARTS_TOWN" );
	add_start( "dogs", ::start_dogs, &"STARTS_DOGS" );
	add_start( "center", ::start_center, &"STARTS_CENTER" );
	add_start( "end", ::start_end, &"STARTS_END" );
	
	setsaveddvar("ai_friendlyFireBlockDuration", 0);
	
	//globals
	maps\createart\scoutsniper_art::main();
	maps\_hind::main( "vehicle_mi24p_hind_woodland" );
	//maps\_t72::main( "vehicle_t72_tank_woodland" );
	//maps\_bm21_troops::main( "vehicle_bm21_mobile_cover" );
	maps\_bm21_troops::main( "vehicle_bm21_mobile_bed" );
	maps\_bm21_troops::main( "vehicle_bm21_cover_under_destructible" );
	maps\_bm21_troops::main( "vehicle_bm21_bed_under_destructible" );
	maps\_uaz::main( "vehicle_uaz_light_destructible" );
	maps\_bmp::main( "vehicle_bmp_woodland" );
	
	level.weaponClipModels = [];
	level.weaponClipModels[0] = "weapon_m14_clip";
	level.weaponClipModels[1] = "weapon_ak47_clip";
	level.weaponClipModels[2] = "weapon_g36_clip";
	level.weaponClipModels[3] = "weapon_dragunov_clip";
	level.weaponClipModels[4] = "weapon_g3_clip";
	
	maps\scoutsniper_fx::main();
	thread maps\_pipes::main();
	thread maps\_leak::main();
	maps\_load::main();
	maps\scoutsniper_anim::main();
	maps\_stealth_logic::stealth_init();
	maps\_stealth_behavior::main();
	maps\_load::set_player_viewhand_model( "viewhands_player_marines" );//viewhands_marine_sniper
	animscripts\dog_init::initDogAnimations();
	maps\_stinger::init();
	maps\_compass::setupMiniMap( "compass_map_scoutsniper" );
	
	thread maps\scoutsniper_amb::main();

	//start everything after the first frame so that level.start_point can be
	//initialized - this is a bad way of doing things...if people are initilizing
	//things before they want their start to start, then they should wait on a flag
	waittillframeend;
	
	//these are the actual functions that progress the level
	thread objective_main();	
	thread level_complete();
		
	switch( level.start_point )
	{
		case "default":		thread intro_main();
		case "church":	
		case "church_x":	church_main();
		case "graveyard":
		case "graveyard_x":	graveyard_main();
		case "field":		thread field_main();
		case "pond":		thread pond_main();
		case "cargo":		thread cargo_main();
		case "dash":		dash_main();
		case "town":		thread town_main();
		case "dogs":		thread dogs_main();
		case "center":		center_main();
		case "end":			end_main();
	}
}

/************************************************************************************************************/
/*													INTRO													*/
/************************************************************************************************************/

intro_main()
{
	if( !isalive( level.price ) )
		return;
	level.price endon( "death" );
	
	flag_wait( "initial_setup_done" );
	
	level.player disableweapons();
	
	reference = getent( "price_start_node", "targetname" );
	reference thread anim_first_frame_solo( level.price, "scoutsniper_opening_price" );
	
	wait 4;
	flag_set( "intro" );
	delaythread(12.5, ::giveweapons);
	delaythread(1, ::music_loop, "scoutsniper_pripyat_music", 143, "field_clean_ai" );
	
	array_thread( getentarray( "patrollers", "script_noteworthy" ), ::add_spawn_function, ::stealth_ai );
	array_thread( getentarray( "patrollers", "script_noteworthy" ), ::add_spawn_function, ::mission_dialogue_kill );
	array_thread5( getentarray( "patrollers", "script_noteworthy" ), ::add_spawn_function, maps\_stealth_behavior::ai_create_behavior_function, "alert", "attack", ::intro_attack_logic );
	array_thread( getentarray( "tableguards", "script_noteworthy" ), ::add_spawn_function, ::stealth_ai );
	array_thread( getentarray( "tableguards", "script_noteworthy" ), ::add_spawn_function, ::idle_anim_think );
	array_thread( getentarray( "tableguards", "script_noteworthy" ), ::add_spawn_function, ::mission_dialogue_kill );
	array_thread5( getentarray( "tableguards", "script_noteworthy" ), ::add_spawn_function, maps\_stealth_behavior::ai_create_behavior_function, "alert", "attack", ::intro_attack_logic );
	array_thread( getentarray( "tableguard_last_patrol", "targetname" ), ::add_spawn_function, ::intro_lastguy_think );
	
	delaythread(1, ::set_blur, 4.8, .25 );
	delaythread(4, ::set_blur, 0, 3 );
	
	thread intro_handle_leave_area_flag();
	thread intro_handle_safezone_flag();
	thread intro_handle_last_patrol_clip();
	thread intro_handle_leave_area_clip();
	thread intro_handle_spotted_dialogue();
	thread intro_to_church_spotted();
	delaythread(1, maps\_stealth_behavior::default_event_awareness, ::default_event_awareness_dialogue );
		
	delaythread( randomfloatrange( 3, 7 ), ::scripted_array_spawn, "patrollers", "script_noteworthy", true );
	delaythread( 1, ::scripted_array_spawn, "tableguards", "script_noteworthy", true );
	delaythread( 1, ::scripted_array_spawn, "intro_dogs", "script_noteworthy", true );
	
	wait 13.5;
	
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_radiation" );
	level delaythread( 5, ::function_stack, ::radio_dialogue, "scoutsniper_mcm_followme" );

	wait 1;
	
	try_save( "intro" );
	
	level.price.keepNodeDuringScriptedAnim = true;
	
	thread intro_sneakup_patrollers_death();	
	
	level.price intro_runup( reference );
	level.price notify( "stop_dynamic_run_speed" );
	level.price intro_holdup();
	
	try_save( "intro_shack" );
		
	level.price intro_cqb_into_shack();
	level.price ent_flag_set( "_stealth_stance_handler" );
	level.price intro_sneakup_patrollers();
	level.price ent_flag_clear( "_stealth_stance_handler" );
	
	try_save( "intro_patrollers_killed" );
	
	level.price notify( "stop_path" );
	level.price disable_cqbwalk();
	level.price pushplayer( false );
	
	thread intro_tableguys_event_awareness();
	level.price intro_sneakup_tableguys();
	level.price intro_avoid_tableguys();
	level.price allowedstances( "stand", "crouch", "prone" );
	level.price intro_leave_area();
	try_save( "intro_last_patroller_killed" );
	level.price thread intro_cleanup();
}

intro_handle_spotted_dialogue()
{
	level endon ( "intro_left_area" );
	flag_wait( "_stealth_spotted" );
		
	wait 2;
	
	level function_stack(::radio_dialogue, "scoutsniper_mcm_dogsingrass" );
}

intro_handle_leave_area_clip()
{
	clip = getent("intro_leave_area_clip", "targetname");
	
	clip thread intro_handle_leave_area_clip_spotted();
	
	clip endon("death");
	level endon( "_stealth_spotted" );
	level endon( "church_intro" );
	
	while(1)
	{
		flag_waitopen( "intro_safezone" );
		clip geo_off();
		
		flag_wait( "intro_safezone" );
		clip geo_on();
	}
	
}

intro_handle_leave_area_clip_spotted()
{
	flag_wait_either( "_stealth_spotted", "church_intro" );
	
	self delete();
}

intro_handle_last_patrol_clip()
{		
	clip = getent("intro_last_patrol_clip", "targetname");		
	clip connectpaths();
	clip geo_off();
	
	level endon( "_stealth_spotted" );
	
	flag_wait( "intro_patrol_guys_dead" );
	clip thread intro_handle_last_patrol_clip_spotted();
	
	clip geo_on();
	clip disconnectpaths();
}

intro_handle_last_patrol_clip_spotted()
{
	flag_wait( "_stealth_spotted" );
	
	self connectpaths();
	self delete();
}

intro_handle_leave_area_flag()
{
	level endon( "_stealth_spotted" );
	level endon( "intro_last_patrol_dead" );
	level endon( "intro_left_area" );
	
	trig = getent( "intro_leave_area", "script_noteworthy" );
	
	trig trigger_off();
	
	flag_wait( "intro_last_patrol" );
	
	level.intro_last_patrol waittill("goal");

	trig trigger_on();
	
	while(1)
	{
		trig waittill("trigger", other);
		
		if( other == level.intro_last_patrol )
			break;
	}
	
	flag_set( "intro_leave_area" );
}

intro_handle_safezone_flag()
{
	level endon( "_stealth_spotted" );
	level endon( "church_intro" );
	
	safezone = getent("intro_leave_area_safe_zone", "targetname");
	
	while(1)
	{
		safe = true;
		ai = getaiarray("axis");
		for(i=0; i<ai.size; i++)
		{
			if( !( ai[i] istouching( safezone ) ) )
				continue;	
			
			safe = false;
			break;
		}
		
		if(safe)
		{
			if ( !flag( "intro_safezone" ) )
				flag_set( "intro_safezone" );
		}	
		else if( flag( "intro_safezone" ) )
			flag_clear( "intro_safezone" );
			
		wait .1;	
	}
}

intro_runup( ref )
{	
	if( flag("_stealth_spotted") )
		return;
	level endon("_stealth_spotted");
		
	self allowedstances( "stand" );
	ref thread anim_single_solo( self, "scoutsniper_opening_price" );	
		
	//price moves to a stopping point
	node = getent( "price_intro_path", "targetname" );
		
	length = getanimlength( self getanim("scoutsniper_opening_price") );
	wait length - .2;
	self stopanimscripted();
	
	level delaythread( 2, ::function_stack, ::radio_dialogue, "scoutsniper_mcm_deadman" );
	
	self delaythread( .1, ::dynamic_run_speed );
	self follow_path( node );
}

intro_holdup()
{
	if( flag("_stealth_spotted") )
		return;
	level endon("_stealth_spotted");
	
	if( flag("intro_patrol_guys_dead") )
		return;
	level endon("intro_patrol_guys_dead");
	
	node = getnode("price_intro_holdup","targetname");
	
	node anim_generic_reach_and_arrive( self, "stop2_exposed" );
	
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_standby" );
	
	node thread anim_generic( self, "stop2_exposed" );
	node waittill("stop2_exposed");
}

intro_cqb_into_shack()
{		
	if( flag("_stealth_spotted") )
		return;
	level endon("_stealth_spotted");
	
	if( flag("intro_patrol_guys_dead") )
		return;
	level endon("intro_patrol_guys_dead");
	
	self pushplayer( true );
	
	self enable_cqbwalk();
	node = getnode("price_intro_holdup2","targetname");
	
	//node anim_generic_reach_and_arrive( self, "enemy_exposed" );
	
	self setgoalnode( node );
	self.goalradius = 4;
	self waittill( "goal" );
	
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_deadahead" );
			
	node thread anim_generic( self, "enemy_exposed" );
	node waittill("enemy_exposed");
	
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_staylow" );
		
	node thread anim_generic( self, "down_exposed" );
	node waittill("down_exposed");
	
	self pushplayer( false );
}

intro_sneakup_patrollers()
{
	if( flag("_stealth_spotted") )
		return;
	level endon("_stealth_spotted");
	
	if( flag("intro_patrol_guys_dead") )
		return;	
	
	
	aliases = [];
	aliases[ aliases.size ] = "scoutsniper_ru1_wandering";
	aliases[ aliases.size ] = "scoutsniper_ru2_notwandering";
	aliases[ aliases.size ] = "scoutsniper_ru1_wasteland";
	aliases[ aliases.size ] = "scoutsniper_ru2_zahkaevspayinggood";
	guys = get_living_ai_array("patrollers", "script_noteworthy");
	if( guys.size == 2 )
		mission_dialogue_array( guys, aliases );	
		
		
		
	self thread intro_sneakup_patrollers_kill();
	self thread intro_sneakup_patrollers_dialogue();
	self disable_cqbwalk();
	self.disablearrivals = true;
	self.disableexits = true;
	
	level endon( "intro_patrol_guys_dead" );
	
	node = getnode("price_intro_sneakup", "targetname");
	self thread follow_path( node );
	
	wait 10;
		
	thread intro_sneakup_patrollers_kill_dialogue();
		
	flag_wait( "intro_patrol_guys_dead" );
}

intro_sneakup_patrollers_kill_dialogue()
{
	if( flag("intro_patrol_guys_dead") )
		return;
	level endon( "intro_patrol_guys_dead" );
	
	if( flag("_stealth_spotted") )
		return;
	level endon("_stealth_spotted");
	
	if( flag("_stealth_found_corpse") )
		return;
	level endon("_stealth_found_corpse");
	
	while( !flag( "intro_patrol_guy_down" ) )
	{
		flag_waitopen( "_stealth_event" );
		level function_stack(::radio_dialogue, "scoutsniper_mcm_notlooking" );
		wait 30;
	}	
}

intro_sneakup_patrollers_dialogue()
{
	if( flag("_stealth_spotted") )
		return;
	level endon("_stealth_spotted");
	
	if( !flag( "intro_patrol_guy_down" ) )
	{
		flag_wait( "intro_patrol_guy_down" );
		radio_dialogue_stop();
		level function_stack(::radio_dialogue, "scoutsniper_mcm_hesdown" );
	}
	
	flag_wait( "intro_patrol_guys_dead" );
	radio_dialogue_stop();
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_goodnight" );
}

intro_sneakup_patrollers_death()
{	
	ai = get_living_ai_array("patrollers", "script_noteworthy");
	waittill_dead( ai );
	
	flag_set( "intro_patrol_guys_dead" );
}

intro_sneakup_patrollers_kill()
{
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	ai = get_living_ai_array( "patrollers", "script_noteworthy" );
	
	if( ai.size > 1 )
		waittill_dead(ai, 1);
	flag_set( "intro_patrol_guy_down" );
	
	level endon( "intro_patrol_guys_dead" );
	
	wait .5;
	
	while( self ent_flag( "_stealth_stay_still" ) )
		self waittill( "_stealth_stay_still" );
	
	enemy = get_living_ai("patrollers", "script_noteworthy");
	
	enemy endon("death");
	
	wait randomfloatrange( .75, 1.25 );
	
	MagicBullet( self.weapon, self gettagorigin( "tag_flash" ), enemy getShootAtPos() );
	wait .05;
	enemy dodamage( enemy.health + 100, self.origin );
}

intro_sneakup_tableguys()
{
	if( flag("_stealth_spotted") )
		return;
	level endon("_stealth_spotted");
	
	if( flag("intro_last_patrol") )
		return;
	level endon("intro_last_patrol");
			
	self.favoriteenemy  = undefined;
	self.ignoreall = true;
	self.disablearrivals = false;
	self.disableexits = false;
	self allowedstances( "stand" );	

	level delaythread( .75, ::function_stack, ::radio_dialogue, "scoutsniper_mcm_move" );
	
	node = getnode("price_intro_tableguys_node1", "targetname");
	
	vec = vectornormalize(node.origin - self.origin);
	self maps\_stealth_behavior::friendly_spotted_getup_from_prone( vectortoangles( vec ) );
	
	self delaythread( .25, ::dynamic_run_speed );
	node anim_generic_reach_and_arrive( self, "stop_cornerR" );
	
	self notify( "stop_dynamic_run_speed" );
	
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_holdup" );	
	self.ref_node.origin = node.origin;
	self.ref_node.angles = node.angles + (0,-90,0);
	self.ref_node thread anim_generic( self, "stop_cornerR" );
	self.ref_node waittill("stop_cornerR");
	
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_goaround" );	
	self.ref_node thread anim_generic( self, "onme_cornerR" );
	self.ref_node waittill("onme_cornerR");
	
	node = getnode("price_intro_tableguys_node2", "targetname");
	self set_goal_node(node);
	self.goalradius = node.radius;
	self waittill("goal");
	
	
	
	aliases = [];
	aliases[ aliases.size ] = "scoutsniper_ru1_passcig";
	aliases[ aliases.size ] = "scoutsniper_ru2_whoseturnisit";
	aliases[ aliases.size ] = "scoutsniper_ru1_wakeup";
	aliases[ aliases.size ] = "scoutsniper_ru4_tooexpensive";
	aliases[ aliases.size ] = "scoutsniper_ru1_tooexpensive";
	guys = get_living_ai_array("tableguards", "script_noteworthy" );
	
	if( guys.size == 4 )
		mission_dialogue_array( guys, aliases );
	
	
	
		
	//self allowedstances( "crouch" );//took this out so he would arrive at window
	
	node = getnode("price_intro_tableguys_node3", "targetname");
	self.ref_node.origin = node.origin;
	self.ref_node.angles = node.angles + (0,-90,0);
	
	//node anim_generic_reach_and_arrive( self, "enemy_cornerR" );
	self setgoalnode( node );
	self.goalradius = 4;
	self waittill( "goal" );
	
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_4tangos" );
	self.ref_node thread anim_generic( self, "enemy_cornerR" );
	
	self setgoalpos( self.origin );
	self.goalradius = 4;
	
//	self.ref_node waittill( "enemy_cornerR" )
	level function_stack(::radio_dialogue, "scoutsniper_mcm_donteven" );
}

intro_avoid_tableguys()
{
	if( flag("_stealth_spotted") )
		return;
	level endon("_stealth_spotted");
	
	if( flag("intro_last_patrol_dead") )
		return;
	level endon("intro_last_patrol_dead");
	
	self allowedstances( "stand" );
	self.disablearrivals = false;
	self.disableexits = false;
			
	node = getnode("price_intro_tableguys_node4", "targetname");
	self.ref_node.origin = node.origin;
	self.ref_node.angles = node.angles + (0,-90,0);
	
	self.ref_node anim_generic_reach_and_arrive( self, "stop_cornerR" );	
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_tangobycar" ); 
	
	intro_corpse_hide();
	
	self.ref_node thread anim_generic( self, "stop_cornerR" );
	self.ref_node waittill( "stop_cornerR" );
	
	self.ref_node thread anim_generic( self, "enemy_cornerR" );
	self.ref_node waittill( "enemy_cornerR" );
	
	self.goalradius = 4;
	
	wait 2;
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_yourcall" ); 
}

intro_corpse_hide()
{
	if( !level._stealth.logic.corpse.array.size )
		return;
	
	size = level._stealth.logic.corpse.array.size;
	for(i=0; i<size; i++)
		level._stealth.logic.corpse.array[ i ].origin -= (0,0,10); 	
}

intro_leave_area()
{
	if( flag("_stealth_spotted") )
		return;
	level endon("_stealth_spotted");
	
	flag_wait_either( "intro_leave_area", "intro_last_patrol_dead" );
	
	if( flag( "intro_leave_area" ) && !flag( "intro_last_patrol_dead" ) )
		level function_stack(::radio_dialogue, "scoutsniper_mcm_backinside" );
	
	node = getnode("price_intro_tableguys_node4", "targetname");
	self.ref_node.origin = node.origin;
	self.ref_node.angles = node.angles + (0,-90,0);
	
	self.ref_node anim_generic_reach_and_arrive( self, "stop_cornerR" );
	
	if( flag( "intro_last_patrol_dead" ) )
		radio_dialogue_stop();
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_okgo" );
	wait 1.1;
	
	self.ref_node thread anim_generic( self, "moveout_cornerR" );
	self.ref_node waittill( "moveout_cornerR" );
	
	node = getnode("price_intro_leave_node", "targetname");
	self thread follow_path( node );
	self thread intro_leave_area_dialogue();
}

intro_leave_area_dialogue()
{
	if( flag("_stealth_spotted") )
		return;
	level endon("_stealth_spotted");
	
	//first node
	self waittill("goal");
	//by barn
	self waittill("goal");
	//by car
	self waittill("goal");
	wait 1;
	level function_stack(::radio_dialogue, "scoutsniper_mcm_moveup" );
}

intro_lastguy_think()
{	
	level.intro_last_patrol = self;
		
	self thread intro_lastguy_death();
	self endon("death");
	
	flag_wait_either( "intro_last_patrol", "_stealth_spotted" );
	
	if( !flag( "_stealth_spotted") )
	{	
		self stealth_ai_clear_custom_idle_and_react();	
						
		self.target = "intro_last_patrol_smoke";
		self thread maps\_patrol::patrol();
	}
}

intro_lastguy_death()
{
	level.intro_last_patroller_corpse_name = "corpse_" + self.ai_number;
	
	self waittill("death");
	
	flag_set("intro_last_patrol_dead");
}

intro_cleanup()
{
	self thread intro_cleanup2();
	
	if( flag("_stealth_spotted") )
		return;
	level endon("_stealth_spotted");
	
	self waittill( "path_end_reached" );
	flag_set( "intro_left_area" );
}

intro_cleanup2()
{
	level endon( "intro_left_area" );
	
	flag_wait("_stealth_spotted");
	self notify("stop_path");
	waittill_dead_or_dying( getaispeciesarray( "axis", "all" ) );
	
	flag_waitopen( "_stealth_spotted" );
	
	flag_set( "intro_left_area" );
}

/************************************************************************************************************/
/*													CHURCH													*/
/************************************************************************************************************/
church_main()
{
	if( !isalive( level.price ) )
		return;
	level.price endon( "death" );
				
//	trigger_off( "church_intro", "script_noteworthy" );
		
	flag_wait( "initial_setup_done" );
		
//	trigger_on( "church_intro", "script_noteworthy" );
		
	thread church_patroller();
	thread church_lookout();
	thread church_event_awareness();
	thread church_handle_area_killed();
		
	flag_wait( "intro_left_area" );
		
	level.price church_runup();
	flag_wait( "church_intro" );
	level.price church_runup2();
		
	try_save( "at_church" );
	level.price notify( "stop_dynamic_run_speed" );
		
	level.price church_holdup();
	level.price ent_flag_set( "_stealth_stance_handler" );
	level.price church_sneakup();
	level.price church_moveup_car();
	level.price church_run_for_it();
		
	level.price ent_flag_clear( "_stealth_stance_handler" );
	level.price allowedstances( "stand", "crouch", "prone" );
		
	if( flag("_stealth_spotted") )
	{
		flag_waitopen( "_stealth_spotted");
		wait .75;
		flag_waitopen( "_stealth_spotted");
	}
	flag_waitopen( "church_run_for_it_commit" );
			
	while( !flag( "church_door_open" ) )
		level.price church_open_door();

	level.price thread church_walkthrough();
}

church_handle_area_killed()
{
	flag_wait( "church_intro" );
	wait .5;
	
	getaispeciesarray( "axis", "all" );
	waittill_dead_or_dying( getaiarray( "axis" ) );
	flag_set( "church_and_intro_killed" );	
}

church_runup()
{	
	if( flag("_stealth_spotted") )
		return;
	level endon("_stealth_spotted");
		
	self allowedstances( "stand", "crouch", "prone" );
	
	if( flag("church_area_clear") )
		return;
	level endon("church_area_clear");
			
	node = getnode( "church_price_node1", "targetname" );	
	
	if( flag("church_intro") )
		return;
	level endon("church_intro");
	
	ai = getaiarray( "axis" );
	if( ( !isdefined( ai ) || ai.size == 0 ) && level.start_point != "church_x" )
	{
	//	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_getuskilled" );
		self delaythread( .1, ::dynamic_run_speed );
	}
	else if( distance( node.origin, self.origin ) > 512 )
	{
		level thread function_stack(::radio_dialogue, "scoutsniper_mcm_letsgo" );
		self delaythread( .1, ::dynamic_run_speed );
	}	

	self follow_path( node );
}

intro_to_church_spotted()
{
	level endon( "graveyard_hind_ready" );
	while( 1 )
	{
		flag_wait( "_stealth_spotted" );
		flag_waitopen( "_stealth_spotted" );
		flag_waitopen( "_stealth_alert" );
		flag_waitopen( "_stealth_event" );
		//sometimes it clears and goes again...wierd
		wait .5;
		flag_waitopen( "_stealth_spotted" );
		flag_waitopen( "_stealth_alert" );
		flag_waitopen( "_stealth_event" );
		if( level.player.health )
			level thread function_stack(::radio_dialogue, "scoutsniper_mcm_getuskilled" );
	}
}

church_runup2()
{
	if( flag("_stealth_spotted") )
		return;
	level endon("_stealth_spotted");
	
	if( flag("church_area_clear") )
		return;
	level endon("church_area_clear");
	
	if( flag("church_run_for_it") )
		return;
	level endon( "church_run_for_it" );
	
	level endon( "event_awareness" );
	
	self allowedstances( "stand", "crouch", "prone" );
	
	/*
	node = getnode( "church_price_node1", "targetname" );
	self.ref_node.origin = node.origin;
	self.ref_node.angles = node.angles + (0,-90,0);
		
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_move" );
	self.ref_node thread anim_generic( self, "moveout_cornerR" );
	self.ref_node waittill( "moveout_cornerR" );	
	*/
	
	node = getnode( "church_price_node2", "targetname" );	
	self follow_path( node );
}

church_holdup()
{
	if( flag("_stealth_spotted") )
		return;
	level endon("_stealth_spotted");
	
	if( flag("church_area_clear") )
		return;
	level endon("church_area_clear");
	
	if( flag("_stealth_found_corpse") )
		return;
	level endon("_stealth_found_corpse");
	
	if( flag("church_run_for_it") )
		return;
	level endon( "church_run_for_it" );
	
	level endon( "event_awareness" );
	
	node = getnode( "church_price_node2", "targetname" );	
	node anim_generic_reach_and_arrive( self, "stop_exposed" );
	
	thread church_holdup_dialogue( node );
	
	node thread anim_generic( self, "stop_exposed" );
	node waittill("stop_exposed");
	
	flag_wait_either( "church_start_patroller_line", "church_patroller_dead" );
	
	if( !flag( "church_patroller_dead" ) )
	{
		node thread anim_generic( self, "enemy_exposed" );
		node waittill("enemy_exposed");
	}
	
	node thread anim_generic( self, "onme2_exposed" );
	node waittill("onme2_exposed");
}

church_holdup_dialogue( node )
{
	if( flag("_stealth_spotted") )
		return;
	level endon("_stealth_spotted");
	
	if( flag("church_area_clear") )
		return;
	level endon("church_area_clear");
	
	if( flag("_stealth_found_corpse") )
		return;
	level endon("_stealth_found_corpse");
	
	if( flag("church_run_for_it") )
		return;
	level endon( "church_run_for_it" );
	
	level endon( "event_awareness" );
		
	if( ! ( flag( "church_patroller_dead" ) && flag( "church_lookout_dead" ) ) )
		level function_stack(::radio_dialogue, "scoutsniper_mcm_dontmove" );
		
	node waittill("stop_exposed");
	if( !flag( "church_lookout_dead" ) )
	{
		if( flag( "church_patroller_dead" ) )
			level function_stack(::radio_dialogue, "scoutsniper_mcm_inthetower" );
		else
			level function_stack(::radio_dialogue, "scoutsniper_mcm_churchtower" );
		if( !flag( "church_patroller_dead" ) )
		{
			flag_set( "church_start_patroller_line" );
			
			if( flag( "church_lookout_dead" ) )
				level thread function_stack(::radio_dialogue, "scoutsniper_mcm_niceshot" );
			else
				level thread function_stack(::radio_dialogue, "scoutsniper_mcm_patrolnorth" );
		}
	}
	else if( !flag( "church_patroller_dead" ) )
	{
		flag_set( "church_start_patroller_line" );
		level thread function_stack(::radio_dialogue, "scoutsniper_mcm_niceshot" );
	}	
	
	node waittill("enemy_exposed");
	
	if( !flag( "church_patroller_dead" ) )
		level function_stack(::radio_dialogue, "scoutsniper_mcm_betterview" );
	
	flag_set( "church_dialogue_done" );
}

church_sneakup()
{
	if( flag("_stealth_spotted") )
		return;
	level endon("_stealth_spotted");
	
	if( flag("church_area_clear") )
		return;
	level endon( "church_area_clear" );
			
	node = getnode( "church_price_sneakup", "targetname" );
	self thread follow_path( node );
		
	if( flag("church_run_for_it") )
		return;
	level endon( "church_run_for_it" );
	
	self waittill( "path_end_reached" );
	
	thread church_sneakup_dialogue_nag();
	thread church_sneakup_dialogue_nag2();
	
	flag_wait( "church_patroller_faraway" );
	flag_set( "church_run_for_it" );
}

church_sneakup_dialogue_nag()
{
	if( flag("_stealth_spotted") )
		return;
	level endon("_stealth_spotted");
	
	if( flag("church_area_clear") )
		return;
	level endon( "church_area_clear" );
	
	if( flag("church_run_for_it") )
		return;
	level endon( "church_run_for_it" );
	
	if( flag("church_lookout_dead") )
		return;
	level endon( "church_lookout_dead" );
	
	if( flag("church_patroller_dead") )
		return;
	level endon( "church_patroller_dead" );
	
	if( flag("_stealth_found_corpse") )
		return;
	level endon( "_stealth_found_corpse" );
	
	level endon( "event_awareness" );
		
	msg_num = 0; 
	msg = [];
	msg[ 0 ] = "scoutsniper_mcm_haveashot";
	msg[ 1 ] = "scoutsniper_mcm_inthetower";
	
	level function_stack(::radio_dialogue, msg[ msg_num ] );
	msg_num++;
	thread church_sneakup_dialogue_help();
	
	while( !flag( "church_lookout_dead" ) )
	{		
		level waittill_notify_or_timeout( "church_sneakup_dialogue_help", 10 );
		if( flag( "church_sneakup_dialogue_help" ) )
		{
			flag_waitopen( "church_sneakup_dialogue_help" );
			continue;
		}
		level function_stack(::radio_dialogue, msg[ msg_num ] );
		
		msg_num++;
		if( msg_num >= msg.size )
			msg_num = 0;
	}
}

church_sneakup_dialogue_help()
{
	if( flag("_stealth_spotted") )
		return;
	level endon("_stealth_spotted");
	
	if( flag("church_area_clear") )
		return;
	level endon( "church_area_clear" );
	
	if( flag("church_run_for_it") )
		return;
	level endon( "church_run_for_it" );
	
	if( flag("church_lookout_dead") )
		return;
	level endon( "church_lookout_dead" );
	
	if( flag("church_patroller_dead") )
		return;
	level endon( "church_patroller_dead" );
	
	if( flag("_stealth_found_corpse") )
		return;
	level endon( "_stealth_found_corpse" );
	
	level endon( "event_awareness" );

	node = getstruct( "church_wrong_tower", "targetname" );

	while( !flag( "church_lookout_dead" ) )
	{		
		while( level.player PlayerAds() < 0.85 )
			wait .05;
		
		while( level.player PlayerAds() > 0.85 )
		{
			vec1 = anglestoforward( level.player getplayerangles() );
			vec2 = vectornormalize( node.origin - level.player.origin );
			if( vectordot( vec1, vec2 ) > .996 )
				break;
			
			wait .05;
		}	
		
		if( level.player PlayerAds() > 0.85 )
		{
			flag_set( "church_sneakup_dialogue_help" );
			level function_stack(::radio_dialogue, "scoutsniper_mcm_wrongtower" );
			flag_clear( "church_sneakup_dialogue_help" );
			wait 5;
		}	
	}		
}

church_sneakup_dialogue_nag2()
{
	if( flag("_stealth_spotted") )
		return;
	level endon("_stealth_spotted");
	
	if( flag("church_area_clear") )
		return;
	level endon( "church_area_clear" );
	
	if( flag("church_run_for_it") )
		return;
	level endon( "church_run_for_it" );
	
	if( flag("church_patroller_dead") )
		return;
	level endon( "church_patroller_dead" );
	
	flag_wait( "church_lookout_dead" );	
	
	wait .5;
	level function_stack(::radio_dialogue, "scoutsniper_mcm_targetnorth" );
	level function_stack(::radio_dialogue, "scoutsniper_mcm_yourcall" );
}


church_moveup_car()
{
	if( flag("_stealth_spotted") )
		return;
	level endon("_stealth_spotted");
	
	if( flag( "church_run_for_it" ) )
		return;
	
	if( flag("church_and_intro_killed") )
		return;
		
	//flag_waitopen( "_stealth_found_corpse" );	
	
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_go" );
	
	node = getnode( "church_price_node_car", "targetname" );
	
	vec = vectornormalize(node.origin - self.origin);
	self ent_flag_clear( "_stealth_stance_handler" );
	self maps\_stealth_behavior::friendly_spotted_getup_from_prone( vectortoangles( vec ) );
	
	self follow_path( node );
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_forwardclear" );
}

church_run_for_it()
{
	if( !flag( "church_run_for_it" ) )
		return;
	
	if( flag("_stealth_spotted") )
		return;
	level endon("_stealth_spotted");
	
//	if( flag( "church_lookout_dead" ) )
//		return;
//	level endon("church_lookout_dead");
	
	if( flag("church_and_intro_killed") )
		return;
	
	self thread church_run_for_it_dead_dialogue();
	
	if( !flag( "church_lookout_dead" ) ) 
	{
		if( flag("church_guess_he_cant_see") )
		{
			level function_stack(::radio_dialogue, "scoutsniper_mcm_closeone" );
			// it sounds weird to be releaved and immediately tell the player 
			// to be ready to move, so we wait a second
			wait .65;
		}	
	}
	
	if( flag( "church_patroller_faraway" ) )
		level function_stack(::radio_dialogue, "scoutsniper_mcm_ourchance" );
		
	self ent_flag_clear( "_stealth_stance_handler" );
	wait .05;
	waittillframeend;
	if( !flag( "church_lookout_dead" ) )
	{
		self allowedstances( "prone" );	
		level function_stack(::radio_dialogue, "scoutsniper_mcm_turnaround" );
	
		angles = (0,45,0);
		vec1 = anglestoforward( angles );
		guy = get_living_ai("church_lookout", "script_noteworthy");
		
		while( isalive( guy ) )
		{
			vec2 = anglestoforward( guy.angles );
			if( vectordot( vec1, vec2 ) > .9 )
				break;
			wait .05;
		}
	}
	
	if( flag( "church_lookout_dead" ) )
		return;
	level endon("church_lookout_dead");
	
	self thread church_run_for_it_commit();
	self waittill( "path_end_reached" );
}
	
church_run_for_it_commit()
{
	flag_set( "church_run_for_it_commit" );
	
	self allowedstances( "crouch", "stand", "prone" );
	self pushplayer( true );
	self set_generic_run_anim( "sprint" );
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_readygo" );
	self notify( "scoutsniper_mcm_readygo" );
	node = getnode( "church_price_runforit", "targetname" );
		
	vec = vectornormalize(node.origin - self.origin);
	self maps\_stealth_behavior::friendly_spotted_getup_from_prone( vectortoangles( vec ) );
	
	self thread follow_path( node );
	
	self waittill( "path_end_reached" );
	
	self pushplayer( false );
	self clear_run_anim();
	
	flag_clear( "church_run_for_it_commit" );
}

church_run_for_it_dead_dialogue()
{
	self endon( "scoutsniper_mcm_readygo" );
	
	flag_wait( "church_lookout_dead" );
	
	level delaythread( .1, ::function_stack, ::radio_dialogue, "scoutsniper_mcm_onme" );
}

church_lookout()
{
	spawner = getent( "church_lookout", "script_noteworthy" );
	
	corpse_array = [];
	corpse_array[ "saw" ] 	= ::church_lookout_stealth_behavior_saw_corpse;
	corpse_array[ "found" ] = ::church_lookout_stealth_behavior_found_corpse;
	
	alert_array = [];
	alert_array[ "alerted_once" ] = ::church_lookout_stealth_behavior_alert_level_investigate;
	alert_array[ "alerted_again" ] = ::church_lookout_stealth_behavior_alert_level_attack;
	alert_array[ "attack" ] = ::church_lookout_stealth_behavior_alert_level_attack;
	
	awareness_array = [];
	awareness_array[ "explode" ] = ::church_lookout_stealth_behavior_explosion;
		
	spawner thread add_spawn_function( ::stealth_ai, undefined, alert_array, corpse_array, awareness_array );
	spawner thread add_spawn_function( ::church_lookout_death );
	
	flag_wait( "church_intro" );

	scripted_array_spawn( "church_lookout", "script_noteworthy", true );
	
	waittillframeend;
	guy = get_living_ai( "church_lookout", "script_noteworthy" );
	guy.a.disablelongdeath = true;
	
	guy endon( "death" );
	
	flag_wait( "church_ladder_slide" );
	
	guy thread church_lookout_cleanup();
	wait 1;
	
	guy.ignoreall = true;
	guy.allowdeath = true;
		
//	guy setgoalpos( (-35002, -917, 247.3) );
	guy.goalradius = 1024;
		
	guy maps\_stealth_behavior::ai_change_behavior_function( "alert", "alerted_once", ::church_lookout_stealth_behavior_alert_level_attack );
			
	node = getent( "church_ladder_slide_node", "targetname" );
	node anim_generic( guy, "ladder_slide" );
	guy setgoalpos( guy.origin );
	
	level.price.ignoreme = false;	
	level.price.ignoreall = false;
	
	guy.ignoreall = false;
}

church_lookout_cleanup()
{
	self waittill( "death" );
	
	level.price.ignoreme = true;	
	level.price.ignoreall = true;
}

church_lookout_wait()
{
	self endon( "_stealth_running_to_corpse" );
	self endon( "_stealth_saw_corpse" );
	self endon( "_stealth_found_corpse" );
	level endon( "_stealth_found_corpse" );
	level endon( "_stealth_spotted" );
	
	self waittill( "enemy_alert_level_change" );
}

church_lookout_death()
{
	name = "corpse_" + self.ai_number;
	self waittill( "death" );
	
	//hook in to fix the dogs running up problem
	clip = getent( "doggie_clip", "targetname" );
	clip solid();
	clip disconnectpaths();	
	
	waittillframeend;//to allow the corpse entity to be created
	
	corpse = getent( name, "script_noteworthy" );
	corpse delete();
	level._stealth.logic.corpse.array = array_removeundefined( level._stealth.logic.corpse.array );
		
	flag_set( "church_lookout_dead" );
	if( flag( "church_patroller_dead" ) )
		flag_set( "church_area_clear" );
	
	if( !flag( "intro_patrol_guys_dead" ) )
	 	return;	
	 			
	check1 = ( !flag("_stealth_spotted") && flag( "church_dialogue_done" ) );
	check2 = ( !flag("_stealth_spotted") && flag( "church_door_open" ) );
	if( check1 || check2 )
		level thread function_stack(::radio_dialogue, "scoutsniper_mcm_beautiful" );
}

church_patroller()
{
	spawner = getent( "church_smoker", "script_noteworthy" );
	spawner thread add_spawn_function( ::stealth_ai );
	spawner thread add_spawn_function( ::church_patroller_death );
	spawner thread add_spawn_function( ::church_patroller_faraway_trig );
	
	flag_wait( "church_intro" );

	thread scripted_array_spawn( "church_smoker", "script_noteworthy", true );
}

church_patroller_faraway_trig()
{
	self endon( "death" );
	
	if( flag("_stealth_spotted") )
		return;
	level endon("_stealth_spotted");
	
	trig = getent("church_patrol_faraway_trig", "targetname" );	
	
	while( 1 )
	{
		trig waittill( "trigger", other );
		if( other == self )
			break;
	}
	
	flag_set( "church_patroller_faraway" );
}

church_patroller_death()
{	
	level endon( "graveyard" );
	self waittill( "death" );
		
	origin = self.origin;
	
	if( !flag("_stealth_spotted") && flag( "church_dialogue_done" ) && flag( "church_lookout_dead" ) )
	{
		radio_dialogue_stop();
		level thread function_stack(::radio_dialogue, "scoutsniper_mcm_tangodown" );
	}
	flag_set( "church_patroller_dead" );
	if( flag( "church_lookout_dead" ) )
		flag_set( "church_area_clear" );
	else
	{
		lookout = get_living_ai( "church_lookout" , "script_noteworthy" );
		if( distance( origin, lookout.origin ) > ( level._stealth.logic.corpse.sight_dist + 150 ) && !flag("_stealth_spotted") )
	 		flag_set( "church_run_for_it" );
	 	else if( flag("_stealth_spotted") )
	 		return;
	 	else
	 	{
	 		if( flag( "intro_patrol_guys_dead" ) )
	 			level thread function_stack(::radio_dialogue, "scoutsniper_mcm_seethebody" );
	 		
	 		wait 12;
	 		if( !flag( "_stealth_spotted" ) && !flag( "_stealth_found_corpse" ) )
	 		{
		 		flag_set( "church_run_for_it" );
		 		flag_set( "church_guess_he_cant_see" );
		 	}
	 	}
	}
}

church_open_door()
{
	name = undefined;
	anime = undefined;
	function = undefined;
	
	if( flag( "_stealth_spotted" ) )
	{
		//do this for the rare case that he gets to the door and you're alerted
		//he'll be in the first frame of the door open and won't break out of it to fight
		//or go to a goal and the game will hang
		self notify( "stop_first_frame" );
		flag_waitopen( "_stealth_spotted" );
	}
	
	waittillframeend;
	
	level endon("_stealth_spotted");
	
	self.disableexits = false;
	self.disablearrivals = false;
	self.animname = "generic";
	
	if( flag( "church_and_intro_killed" ) )
	{
		level delaythread( .1, ::function_stack, ::radio_dialogue, "scoutsniper_mcm_onme" );
		
		name = "church_price_door_kick_node";
		anime = "open_door_kick";
		function = ::door_open_kick;
		
		node = getnode( name, "targetname");
		
		node anim_generic_reach_and_arrive( self, anime );
		self.goalradius = 16;
	}
	else
	{		
		name = "church_door_front_node";
		anime = "open_door_slow";
		function = ::door_open_slow;
		
		node = getent( name, "targetname");
	
		node anim_generic_reach_and_arrive( self, anime );		
		node anim_first_frame_solo( self, anime );
	}

	while( distance( level.player.origin, self.origin ) > 200 )
		wait .1;
	
	self thread church_open_door_commit( node, anime, function );
	node waittill( anime );
}

church_open_door_commit( node, anime, function )
{	
	if( flag("_stealth_spotted") )
		return;
	
	flag_set( "church_door_open" );
	
	node thread anim_single_solo( self, anime );	
	
//	delaythread( .5, ::music_play, "scoutsniper_pripyat_music" );
	
	self enable_cqbwalk();
	door = getent("church_door_front", "targetname");
	door [[ function ]]();
	self delaythread( 2, ::disable_cqbwalk );
}

church_walkthrough()
{	
	self church_walkthrough_lookaround();
	
	flag_waitopen("_stealth_spotted");
		
	node = getnode("church_price_backdoor_node", "targetname");
	self.ref_node.origin = node.origin;
	self.ref_node.angles = node.angles + (0,-90,0);
	
	self.ref_node anim_generic_reach_and_arrive( self, "moveout_cornerR" );
	
	if( !flag( "graveyard_get_down" ) )
		level thread function_stack(::radio_dialogue, "scoutsniper_mcm_coastclear" ); 
	self.ref_node anim_generic( self, "moveout_cornerR" );
	
	flag_set( "graveyard_moveup" );
}

church_walkthrough_lookaround()
{
	if( flag("_stealth_spotted") )
		return;
	level endon("_stealth_spotted");	
	
	ent = getent("church_price_look_around_node", "targetname");
	self set_goal_pos( ent.origin );
	self.goalradius = 90;
	
	self waittill("goal");
	self enable_cqbwalk();
	
	flag_set( "church_ladder_slide" );
	
	self anim_generic( self, "cqb_look_around" );
	
	ent = getent( ent.target, "targetname" ); 
	self set_goal_pos( ent.origin );
	self waittill("goal");
	
	self disable_cqbwalk();
}


/************************************************************************************************************/
/*												GRAVE YARD													*/
/************************************************************************************************************/

graveyard_main()
{
	if( !isalive( level.price ) )
		return;
	level.price endon( "death" );
	
	flag_wait( "initial_setup_done" );
	flag_set( "graveyard" );
	
	try_save( "graveyard" );
	
	array_thread( getentarray( "church_breakable", "targetname" ), ::graveyard_church_breakable );
	thread graveyard_Hind();
	thread field_endmission();	
	level.price thread graveyard_waithind();
	level.price thread graveyard_deadhind();
	while( ! flag( "graveyard_hind_ready" ) )
	{
		level.price graveyard_moveup();
		flag_waitopen( "_stealth_spotted" );
	}
	level.price notify( "stop_loop" );
	level.price allowedstances("prone", "crouch", "stand" );
	thread graveyard_backhalf();
}

graveyard_backhalf()
{
	flag_wait_either( "graveyard_hind_gone", "graveyard_hind_down" );
	
	if( !flag( "graveyard_hind_down" ) )
		level thread function_stack(::radio_dialogue, "scoutsniper_mcm_letsgo2" );
	
	flag_set( "field" );
}

graveyard_moveup()
{
	flag_wait( "graveyard_moveup" );
	
	if( flag("_stealth_spotted") )
		return;
	level endon( "_stealth_spotted" );
	
	level endon( "graveyard_get_down" );
	
	node = getnode( "graveyard_price_node", "targetname" );
	self delaythread( .25, ::dynamic_run_speed );
		
	self.ref_node.origin = node.origin;
	self.ref_node.angles = node.angles + (0,-90,0);
	self.ref_node anim_generic_reach_and_arrive( self, "stop_cornerR" );
	
	flag_set( "graveyard_price_at_wall" );
}

graveyard_waithind()
{
	flag_wait( "graveyard_hind_ready" );
	
	if( flag("_stealth_spotted") )
		return;
	level endon( "_stealth_spotted" );
	
	while( distance( level.hind.origin, level.player.origin ) > 7500 )
		wait .05;
	
	flag_set( "graveyard_get_down" );
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_enemyheli" );
	
	self notify( "stop_dynamic_run_speed" );
		
	if( flag( "graveyard_price_at_wall" ) )
	{
		self allowedstances( "crouch" );
		self anim_generic( self, "corner_crouch" );
		self thread anim_generic_loop( self, "corner_idle", undefined, "stop_loop" );
	}
	else
	{
		self allowedstances( "prone" );
		self anim_generic_custom_animmode( self, "gravity", "pronehide_dive" );
	}
	
	self setgoalpos( self.origin );
	self.goalradius = 4;
		
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_inshadows" );
	
	while( distance( level.hind.origin, self.origin ) < 7500 )
		wait .05;
	
	while( distance( level.hind.origin, level.player.origin ) < 7500 )
		wait .05;
	
	self notify( "stop_loop" );
	self allowedstances("prone", "crouch", "stand" );
	
	wait .5;
	
	flag_set( "graveyard_hind_gone" );
}

graveyard_deadhind()
{
	flag_wait( "graveyard_hind_ready" );
	
	level endon( "field_spawn" );

	level.hind waittill( "death" );
	
	if( isdefined( level.hind ) )
		level.hind clearlookatent();
	
	flag_set( "graveyard_hind_down" );
}

graveyard_hind_death_dialogue()
{
	level endon( "cargo" );
	
	flag_wait( "_stealth_spotted" );
	
	flag_wait( "graveyard_hind_down" );
	if( !flag( "_stealth_spotted" ) )
		wait 5;
	
	flag_waitopen( "_stealth_spotted" );
	flag_waitopen( "_stealth_event" );
	flag_waitopen( "_stealth_alert" );
	wait .5;
	flag_waitopen( "_stealth_spotted" );
	flag_waitopen( "_stealth_alert" );
	flag_waitopen( "_stealth_event" );
	
	if( level.player.health )
		level thread function_stack(::radio_dialogue, "scoutsniper_mcm_showinoff" );
}

graveyard_Hind()
{
	trigger = getent( "field_hind_flyover", "targetname" );
	trigger waittill( "trigger" );
	
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_hearthat" );
		
	hind = spawn_vehicle_from_targetname_and_drive( "field_hind" );
	
	level.hind = hind;
	flag_set( "graveyard_hind_ready" );
				
	hind endon( "death" );
	
	hind thread graveyard_hind_death_dialogue();
	hind thread graveyard_hind_spot_enemy();
	hind thread graveyard_hind_spot_behavior();
	hind thread graveyard_hind_detect_damage();
	hind thread graveyard_hind_stinger_logic();
	
	flag_wait( "_stealth_spotted" );
	
	hind thread graveyard_hind_attack_enemy();
}

graveyard_hind_spot_behavior()
{
	self endon( "death" );
	
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	//you get one chance
	self waittill( "enemy" );
	self thread graveyard_hind_find_best_perimeter( "graveyard_hind_circle_path", true );
	//level thread function_stack(::radio_dialogue, "scoutsniper_mcm_dontmove" );
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_circlingback" );
	
	self waittill( "enemy" );
			
	flag_set( "_stealth_spotted" );
	
	pos = level.player.origin;
	self maps\_stealth_behavior::enemy_announce_spotted_bring_team( pos );
}

graveyard_hind_spot_enemy()
{
	self endon( "death" );
	
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
		
	trig = getent( "graveyard_inside_church_trig", "targetname" );
	
	movetime = 0;
	interval = .05;
	
	while( 1 )
	{		
		wait interval;	
		
		if( level.player istouching( trig ) )
			continue;
		
		checkmov = 1300;
		origin1 = level.player.origin;
		origin2 = (self.origin[0], self.origin[1], origin1[2] );
		velocity = length( level.player getVelocity() );
		
		check1 = ( velocity > 10 && level.player._stealth.logic.stance == "crouch" );
		check2 = ( velocity > 25 && level.player._stealth.logic.stance == "prone" );
		
		if( distance( origin1, origin2 ) < checkmov && ( check1 || check2 ) )
		{
			movetime += interval;
			if( movetime < .5 )
				continue;
			trace = bullettrace(self.origin + (0,0,-128), level.player.origin, true, level.price );
			
			if( !isdefined( trace[ "entity" ] ) || trace[ "entity" ] != level.player )
				continue;
		}
		else if( level.player._stealth.logic.stance == "prone" || level.player._stealth.logic.stance == "crouch" )
		{
			movetime = 0;
			continue;
		}
		else
		{
			movetime = 0;
			//helicopter can see better through your camo because 
			//of it's high angle in the sky
			check = level.player.maxvisibledist;
			check += 3500;
					
			if( distance( self.origin, level.player.origin ) > check )
				continue;
			
			trace = bullettrace(self.origin + (0,0,-128), level.player.origin, true, level.price );
			
			if( !isdefined( trace[ "entity" ] ) || trace[ "entity" ] != level.player )
				continue;
		}
		
		self notify( "enemy" );
		movetime = 0;
		//we wait to give the player a chance to hide
		
		timefrac = distance( self.origin, level.player.origin ) * .0005;
		time = ( .5 + timefrac );
		//iprintlnbold( time );
		wait time;			
	}	
}
		
graveyard_hind_kill_body( body )
{	
	self add_wait( ::waittill_msg, "death" );
	level add_wait( ::waittill_msg, "_stealth_spotted" );
	do_wait_any();
	
	if( isdefined( self ) )
		self show();
	
	if( isdefined( body ) )
		body delete();
}

graveyard_hind_attack_enemy()
{
	self endon( "death" );
	
	self thread graveyard_hind_find_best_perimeter( "graveyard_hind_circle_path" );
	
	wait 1;
	
	self thread chopper_ai_mode( level.player );
	self thread chopper_ai_mode_missiles( level.player );
}

/************************************************************************************************************/
/*													FIELD													*/
/************************************************************************************************************/

field_main()
{
	if( !isalive( level.price ) )
		return;
	level.price endon( "death" );
	
	flag_wait( "initial_setup_done" );
			
	thread field_handle_enemys();
	thread field_handle_special_nodes();
	thread field_handle_flags();
	thread field_handle_cleanup();

	flag_wait( "field" );
	
	flag_waitopen( "_stealth_spotted" );
	flag_waitopen( "_stealth_event" );
		try_save( "field" );
	
	//level.price field_road();
	level.price allowedstances( "stand", "crouch", "prone" );
	level.price thread field_getdown();
	level.price thread field_handle_price_spotted();
	
	while( !flag( "field_spawn" ) )
	{
		level.price field_moveup();
			
		if( isdefined( level.hind ) )
			flag_wait( "graveyard_hind_down" );	
		
		flag_waitopen( "_stealth_spotted" );
		flag_waitopen( "_stealth_event" );
	}	
	
//	level.price thread field_handle_price_spotted();
	level.price field_moveup2();
//	level.player thread field_creep_player();
	level.price thread field_creep();
}

field_handle_price_spotted()
{
	level endon( "field_price_done" );
	level.player endon( "death" );
	level.price endon( "death" );
	
	flag_wait( "field_spawn" );
	flag_wait( "_stealth_spotted" );
	
	wait 10;
	
	self stop_magic_bullet_shield();
	self dodamage( self.health + 100, self.origin );
}

field_endmission()
{
	flag_wait( "field_close_church_door" );
	if( flag( "_stealth_spotted" ) && distance( level.player.origin, level.price.origin ) > 1500 )
		level thread function_stack(::radio_dialogue, "scoutsniper_mcm_ateam" );
		
	flag_wait( "field_spawn" );
	if( flag( "_stealth_spotted" ) && distance( level.player.origin, level.price.origin ) > 3500 )
		price_left_behind();
}

field_handle_flags()
{
	trigger = getent( "field_price_getdown", "targetname" );
	trigger waittill( "trigger" );
	
	flag_set( "field_getdown" );
}

field_road()
{
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	if( flag( "field_player_way_ahead" ) )
		return;
	level endon( "field_player_way_ahead" );
			
	node = getnode( "field_before_road_node", "targetname" );
	delaythread( .25, ::dynamic_run_speed );
	self follow_path( node );
	self notify( "stop_dynamic_run_speed" );
	
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_stop" );
		
	wait 2;
	level function_stack(::radio_dialogue, "scoutsniper_mcm_clearleft" );
	level function_stack(::radio_dialogue, "scoutsniper_mcm_clearright" );
	level function_stack(::radio_dialogue, "scoutsniper_mcm_staylow2" );
	level function_stack(::radio_dialogue, "scoutsniper_mcm_go" );
	
	node = getnode( "field_after_road_node", "targetname" );
	node anim_generic_reach( level.price, "pronehide_dive" );
	
	self allowedstances( "prone" );
	self anim_generic_custom_animmode( self, "gravity", "pronehide_dive" );
	self setgoalpos( self.origin );

	wait 1;
	level function_stack(::radio_dialogue, "scoutsniper_mcm_areaclear" );
	self allowedstances( "stand", "crouch" );
	self maps\_stealth_behavior::friendly_spotted_getup_from_prone();
}

field_moveup()
{
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	level endon( "field_cutting_it_close" );
	
	node = getent( "field_price_node1", "targetname" );
	delaythread( .25, ::dynamic_run_speed );
	
	self thread follow_path( node );
	self pushplayer( true );
	
	node = getent( "field_price_stop_dynamic", "targetname" );
	node waittill( "trigger" );
	
	self notify( "stop_dynamic_run_speed" );
	waittillframeend;
	self.moveplaybackrate = 1.44;
	
	if( isdefined( level.hind ) )
		level.hind delete();
	flag_set( "field_spawn" );
}	

field_moveup2()
{
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	level endon( "field_cutting_it_close" );
	
	node = getent( "field_price_decide_start", "targetname" );
	node waittill( "trigger" );

	flag_set( "field_start" );
	
	self waittill( "path_end_reached" );
	
	self allowedstances( "prone" );
	self anim_generic_custom_animmode( self, "gravity", "pronehide_dive" );
	
	thread flag_set_delayed( "prone_hint", 2 );
}

field_getdown()
{	
	flag_wait( "field_getdown" );
	
	try_save( "field2" );
	
	if( !flag( "_stealth_spotted" ) )
		level thread function_stack(::radio_dialogue, "scoutsniper_mcm_getdown" );
			
	delaythread(1, ::music_play, "scoutsniper_surrounded_music" );	
}

field_creep()
{
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
		
	node = getent( "field_price_prone_node", "targetname" );
	self thread follow_path( node );
	
	delaythread( 12, ::field_creep_dialogue );
		
	self.moveplaybackrate = 1;
	wait 12;
	self.moveplaybackrate = .9;
	wait 3;//6
	self.moveplaybackrate = .8;
	wait 3;//9
	self.moveplaybackrate = .7;
	wait 3;//12
	self.moveplaybackrate = .6;
	wait 3;//15
	self.moveplaybackrate = .5;
	
	wait 7;
	
	self maps\_stealth_behavior::friendly_stance_handler_stay_still();
	wait 40;
		
	self maps\_stealth_behavior::friendly_stance_handler_resume_path();
	
	wait 1;
	self.moveplaybackrate = .6;
	wait 1;
	self.moveplaybackrate = .7;
	wait 1; 
	self.moveplaybackrate = .8;
	wait 1; 
	self.moveplaybackrate = .9;
	wait 1;
	self.moveplaybackrate = 1;
	
	self maps\_stealth_behavior::friendly_stance_handler_stay_still();
	

	
	field_waittill_player_passed_guards();
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_niceandslow" );
		
	field_waittill_player_near_price();	
	
	self maps\_stealth_behavior::friendly_stance_handler_resume_path();
	wait .5;
	
	self ent_flag_set( "_stealth_stance_handler" );	
	
	node = getent( "field_price_clear", "targetname" );
	node waittill( "trigger" );
	
	self ent_flag_clear( "_stealth_stance_handler" );	
	self allowedstances( "prone", "crouch", "stand" );
	flag_set( "field_price_done" );
}

field_creep_dialogue()
{
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	level function_stack(::radio_dialogue, "scoutsniper_mcm_holdyourfire" );
	wait 3;	
	level function_stack(::radio_dialogue, "scoutsniper_mcm_anticipatepaths" );	
	wait 2;
	level function_stack(::radio_dialogue, "scoutsniper_mcm_slowandsteady" );	
}

field_creep_player()
{
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	if( flag( "pond" ) )
		return;
	level endon( "pond" );
	
	thread field_creep_player_cleanup();
	
	hidden = [];
	hidden[ "stand" ] = 2;
	hidden[ "crouch" ] = 1;
	hidden[ "prone" ] = .5;
	level.player stealth_friendly_movespeed_scale_set( hidden, hidden );
	
}

field_creep_player_cleanup()
{
	flag_wait_either( "_stealth_spotted", "pond" );
	
	level.player stealth_friendly_movespeed_scale_default();
}

field_handle_enemys()
{
	//field_bmp1 = spawn_vehicle_from_targetname_and_drive( "bmp1" );
	field_bmp1 = spawn_vehicle_from_targetname( "bmp1" );
	field_bmp2 = spawn_vehicle_from_targetname( "bmp2" );
	field_bmp3 = spawn_vehicle_from_targetname( "bmp3" );
	field_bmp4 = spawn_vehicle_from_targetname( "bmp4" );
	
	level.bmps = [];
	level.bmps[ level.bmps.size ] = field_bmp1;
	level.bmps[ level.bmps.size ] = field_bmp2;
	level.bmps[ level.bmps.size ] = field_bmp3;
	level.bmps[ level.bmps.size ] = field_bmp4;
	
	for(i=0; i<level.bmps.size; i++)
	{
		level.bmps[ i ] field_bmp_make_followme();
		level.bmps[ i ] thread field_bmp_quake();
		level.bmps[ i ] thread execVehicleStealthDetection();
	}
	
	state_functions = [];
	state_functions[ "hidden" ] 	= ::dash_state_hidden;
	state_functions[ "alert" ] 		= maps\_stealth_behavior::enemy_state_alert;
	state_functions[ "spotted" ] 	= maps\_stealth_behavior::enemy_state_spotted;
	
	awareness_funcs = [];
	awareness_funcs[ "heard_scream" ] = ::field_enemy_awareness;
	awareness_funcs[ "explode" ] = ::field_enemy_awareness;
	
	corpse_functions = [];
	corpse_functions[ "saw" ] = ::field_enemy_awareness;
	corpse_functions[ "found" ] = ::field_enemy_awareness;
	
	array_thread5( getentarray( "field_guard", "script_noteworthy" ), ::add_spawn_function, ::stealth_ai, state_functions, undefined, corpse_functions, awareness_funcs );
	array_thread5( getentarray( "field_guard2", "script_noteworthy" ), ::add_spawn_function, ::stealth_ai, state_functions, undefined, corpse_functions, awareness_funcs );
	array_thread( getentarray( "field_guard", "script_noteworthy" ), ::add_spawn_function, ::field_enemy_think);
	array_thread( getentarray( "field_guard2", "script_noteworthy" ), ::add_spawn_function, ::field_enemy_think);
	
	flag_wait( "field_spawn" );
	
	if( !flag( "_stealth_spotted" ) )
		battlechatter_off( "axis" );
		
	thread scripted_array_spawn( "field_guard2", "script_noteworthy", true );
	thread scripted_array_spawn( "field_guard", "script_noteworthy", true );

	flag_wait( "field_start" );
	thread field_bmps_stop();
	
	thread maps\_vehicle::gopath( field_bmp1 );
	delaythread( 1, maps\_vehicle::gopath, field_bmp2 );
	delaythread( 3, maps\_vehicle::gopath, field_bmp3 );
	delaythread( 3.5, maps\_vehicle::gopath, field_bmp4 );
	
	ai = get_living_ai_array( "field_guard", "script_noteworthy" );
	
	for(i=0; i<ai.size; i++)
	{
		if( issubstr( ai[ i ].target, "bmp" ) )
			ai[ i ] thread field_enemy_walk_behind_bmp();
		else
		{
			ai[ i ] thread maps\_patrol::patrol();
			ai[ i ] ent_flag_set( "field_walk" );
		}
	}
	
	wait 11;
	
	ai = get_living_ai_array( "field_guard2", "script_noteworthy" );
	
	for(i=0; i<ai.size; i++)
	{
		if( issubstr( ai[ i ].target, "bmp" ) )
			ai[ i ] thread field_enemy_walk_behind_bmp();
		else
		{
			ai[ i ] thread maps\_patrol::patrol();
			ai[ i ] ent_flag_set( "field_walk" );
		}
	}
	
	level endon( "_stealth_spotted" );
	
	wait 140;
	
	flag_set( "field_start_running" );
	for(i=0; i<level.bmps.size; i++)
	{
		level.bmps[ i ] thread bmp_badplace( i );		
	}
	//flag_wait( "field_bmp_badplace" );
}

bmp_badplace( i )
{
	name = "tank" + i;
	
	hasturret = isdefined( level.vehicle_hasMainTurret[ self.model ] ) && level.vehicle_hasMainTurret[ self.model ]; 
	bp_duration = .25; 
	bp_height = 300; 
	bp_angle_left = 17; 
	bp_angle_right = 17; 
	bp_radius = 200; 
	
	//self setcontents( 0 );
	
	while( 1 )
	{
		if ( hasturret )
			bp_direction = anglestoforward( self gettagangles( "tag_turret" ) );
		else
			bp_direction = anglestoforward( self.angles );
	
		badplace_arc( name, bp_duration, self.origin, bp_radius * 1.9, bp_height, bp_direction, bp_angle_left, bp_angle_right, "allies", "axis" );
		badplace_cylinder( name, bp_duration, self.origin, 200, bp_height, "allies", "axis" );
		
		wait bp_duration + .05;
	}	
}

field_bmps_stop()
{
	level endon( "dash_spawn" );
	flag_wait( "field_stop_bmps" );	
	
	for(i=0; i<level.bmps.size; i++)
	{
		if( isdefined( level.bmps[ i ] ) )
			level.bmps[ i ] setspeed( 0, 5 );	
	}
}

field_enemy_think()
{
	self endon( "death" );
	
	self ent_flag_init( "field_walk" );
	self thread field_enemy_think2();

	self thread field_enemy_death();
	self.ignoreme = true;
	
	waittillframeend;
	self maps\_stealth_behavior::ai_change_behavior_function( "alert", "alerted_once", ::field_enemy_alert_level_1 );
	self maps\_stealth_behavior::ai_change_behavior_function( "alert", "alerted_again", ::field_enemy_alert_level_2 );
	self thread field_enemy_patrol_thread();
		
	wait .05;
	self setgoalpos( self.origin );
	self.goalradius = 4;
	wait .05;
	self.fixednode = false;
	
	flag_wait( "field_start" );		
			
	trig = getent( "field_turn_around_trig", "targetname" );

	while(1)
	{
		trig waittill( "trigger", other );
		if( other == self )
			break;			
	}
	
	self maps\_stealth_behavior::ai_change_behavior_function( "alert", "alerted_once", maps\_stealth_behavior::enemy_alert_level_alerted_again );
	self maps\_stealth_behavior::ai_change_behavior_function( "alert", "alerted_again", maps\_stealth_behavior::enemy_alert_level_alerted_again );
	
	dist = 700;
	distsqrd = dist * dist;
	
	while( 1 )
	{
		if( distancesquared( level.player.origin, self.origin ) < distsqrd )
			break;
		
		wait .25;
	}	
	
	self.favoriteenemy = level.player;
}

field_enemy_think2()
{
	level endon( "field_stop_bmps" );
	self endon( "death" );
	
	flag_wait( "field_start_running" );
	
	if( self.export == 47 )
		wait 2;
	
	self notify( "_stealth_stop_corpse_logic" );
	self notify( "end_patrol" );
	
	node = getnode( "field_endup_node", "targetname" );
		
	self setgoalnode( node );
	self.goalradius = 64;
	self clear_run_anim();
	
	self waitOntruegoal( node );
	self delete();
}

/************************************************************************************************************/
/*													POND													*/
/************************************************************************************************************/

pond_main()
{
	if( !isalive( level.price ) )
		return;
	level.price endon( "death" );
		
	awareness_funcs = [];
	awareness_funcs[ "heard_scream" ] = ::field_enemy_awareness;
	awareness_funcs[ "explode" ] = ::field_enemy_awareness;
	
	corpse_functions = [];
	corpse_functions[ "saw" ] = ::field_enemy_awareness;
	corpse_functions[ "found" ] = ::field_enemy_awareness;
	
	array_thread5(getentarray( "pond_patrol", "script_noteworthy" ), ::add_spawn_function, ::stealth_ai, undefined, undefined, corpse_functions, awareness_funcs );	
	array_thread5(getentarray( "pond_throwers", "script_noteworthy" ), ::add_spawn_function, ::stealth_ai, undefined, undefined, corpse_functions, awareness_funcs );	
	array_thread( getentarray( "pond_throwers", "script_noteworthy" ), ::add_spawn_function, ::mission_dialogue_kill);
	array_thread5(getentarray( "pond_backup", "script_noteworthy" ), ::add_spawn_function, ::stealth_ai, undefined, undefined, corpse_functions, awareness_funcs );	
	array_thread( getentarray( "pond_backup", "script_noteworthy" ), ::add_spawn_function, ::mission_dialogue_kill);
	array_thread( getentarray( "pond_backup", "script_noteworthy" ), ::add_spawn_function, ::flag_set, "pond_backup_spawned" );
	
	array_thread( getentarray( "pond_patrol", "script_noteworthy" ), ::add_spawn_function, ::pond_patrol);
	array_thread( getentarray( "pond_throwers", "script_noteworthy" ), ::add_spawn_function, ::pond_thrower);
		
	thread pond_handle_kills( "pond_patrol_spawned", "pond_patrol", "pond_patrol_dead", "scoutsniper_mcm_toppedhim" );
	thread pond_handle_kills( "pond_thrower_spawned", "pond_throwers", "pond_thrower_dead", "scoutsniper_mcm_goodnight" );
	thread pond_handle_clear();
	thread pond_handle_backup();
	thread pond_handle_behavior_change();
	thread pond_dump_bodies();
	thread pond_card_game();
	
	flag_wait( "initial_setup_done" );
	flag_wait( "pond" );
	
	thread maps\_stealth_behavior::default_event_awareness( ::default_event_awareness_dialogue );
	
	level.player._stealth_move_detection_cap = 0;
	
	level.price ent_flag_init( "pond_in_position" );
	
	flag_wait( "field_price_done" );
	try_save( "pond" );
	
	level.price pond_moveup();
	
	trigger_on( "field_clean", "script_noteworthy" );
	if( isalive( level.price ) && !isdefined( level.price.magic_bullet_shield ) )
		level.price delaythread( .1, ::magic_bullet_shield );
	level.price pond_betterview();
	
	level.player._stealth_move_detection_cap = undefined;
	
	try_save( "pond2" );
	
	level.price allowedstances( "prone", "crouch", "stand" );
	level.price ent_flag_set( "_stealth_stance_handler" );
	
	level.price thread pond_kill_patrol();
	level.price thread pond_kill_thrower();
	level.price pond_sneakup();
	
	try_save( "pond3" );
	
	level.price pond_inposition();
	
	if( flag( "pond_enemies_dead" ) )
	{
		level.price ent_flag_clear( "_stealth_stance_handler" );
		level.price allowedstances( "prone", "crouch", "stand" );
	}
	level.price disable_cqbwalk();
	
	if( flag( "_stealth_spotted" ) || flag( "_stealth_event" ) )
	{
		flag_waitopen( "_stealth_spotted" );
		flag_waitopen( "_stealth_event" );
		flag_waitopen( "_stealth_alert" );
		if( level.player.health > 0 )
			level thread function_stack(::radio_dialogue, "scoutsniper_mcm_thewordstealth" );
	}
	else
	{
		flag_wait_either( "pond_enemies_dead", "cargo" );
		if( flag( "pond_enemies_dead" ) )
			level thread function_stack(::radio_dialogue, "scoutsniper_mcm_moveup" );
		else if( distance( level.player.origin, level.price.origin ) > 256 )
			level thread function_stack(::radio_dialogue, "scoutsniper_mcm_ateam" );
		else
			level thread function_stack(::radio_dialogue, "scoutsniper_mcm_moveup" );
	}	
	
	flag_set( "cargo" );
}

pond_card_game()
{
	flag_wait( "pond_backup_spawned" );
	level endon( "dash" );
	level endon( "_stealth_spotted" );
	level endon( "_stealth_found_corpse" );
	
	wait 1;
		
	aliases = [];
	aliases[ aliases.size ] = "scoutsniper_ru1_fivedollars";
	aliases[ aliases.size ] = "scoutsniper_ru4_twentydollars";
	aliases[ aliases.size ] = "scoutsniper_ru1_pairofjacks";
	aliases[ aliases.size ] = "scoutsniper_ru4_threekings";
	aliases[ aliases.size ] = "scoutsniper_ru2_youidiot";
	aliases[ aliases.size ] = "scoutsniper_ru4_wellplayedcomrade";
	aliases[ aliases.size ] = "scoutsniper_ru1_ownmoney";
	aliases[ aliases.size ] = "scoutsniper_ru4_seeaboutthat";
	aliases[ aliases.size ] = "scoutsniper_ru2_call";
	aliases[ aliases.size ] = "scoutsniper_ru4_raise";
	aliases[ aliases.size ] = "scoutsniper_ru4_ifold";
	aliases[ aliases.size ] = "scoutsniper_ru1_cantbelieve";
	aliases[ aliases.size ] = "scoutsniper_ru1_paytheman";
	
	guys = get_living_ai_array("pond_backup", "script_noteworthy");
	
	dist = 300;
	dist2rd = dist*dist;
	
	if( !isalive( guys[0] ) )
		return;
		
	guys[0] endon( "death" );
	
	while( distancesquared( guys[0].origin, level.player.origin ) > dist2rd )
		wait .2;		
	
	mission_dialogue_array( guys, aliases );
}

pond_patrol()
{
	flag_set( "pond_patrol_spawned" );
		
	self.ignoreme = true;
	
	self waittill( "jumpedout" );
	
	if( !isalive( self ) )
		return;
	
	self.goalradius = 4;
	self setgoalpos( self.origin );
		
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	flag_wait( "field_price_done" );
	
	if( !isalive( self ) )
		return;
	
	self thread maps\_patrol::patrol();
	
	while( isalive( self ) )
	{
		self waittill( "damage", ammount, other );
		if( other == level.price && isalive( self ) )
			self dodamage( self.health + 100, level.price.origin );
	}	
}

pond_thrower()
{
	flag_set( "pond_thrower_spawned" );
		
	self.ignoreme = true;
		
	self waittill( "jumpedout" );
	
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	while( isalive( self ) )
	{
		self waittill( "damage", ammount, other );
		if( other == level.price && isalive( self ) )
			self dodamage( self.health + 100, level.price.origin );
	}
}

pond_moveup()
{	
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	if( flag( "cargo" ) )
		return;
	level endon( "cargo" );
	
	self pushplayer( true );
	
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_followme2" );
	node = getnode( "pond_price_moveup_node", "targetname" );
	
	self.ref_node.origin = node.origin;
	self.ref_node.angles = node.angles;
	
	self setgoalnode( node );
	self.goalradius = 4;
	self waittill( "goal" );
	
	wait 1;
	
	self.ref_node thread anim_generic( self, "look_up_stand" );
	self.ref_node waittill("look_up_stand");
	
	self thread pond_price_hack();	
	self thread anim_generic_loop( self, "look_idle_stand", undefined, "stop_loop" );	
	
	delaythread(.1, ::music_loop, "scoutsniper_deadpool_music", 119, "dash_spawn" );
		
	level function_stack(::radio_dialogue, "scoutsniper_mcm_buyout" );
	
	
	
	aliases = [];
	aliases[ aliases.size ] = "scoutsniper_ru2_sendsomeonetocheck";
	aliases[ aliases.size ] = "scoutsniper_ru4_thisonesheavy";
	aliases[ aliases.size ] = "scoutsniper_ru2_andreibringingfood";
	aliases[ aliases.size ] = "scoutsniper_ru4_didnteatbreakfast";
	aliases[ aliases.size ] = "scoutsniper_ru2_quicklyaspossible";
	aliases[ aliases.size ] = "scoutsniper_ru4_takenzakhaevsoffer";
	guys = get_living_ai_array( "pond_throwers", "script_noteworthy" );
	if( guys.size == 2 )
		mission_dialogue_array( guys, aliases );	
	
	
	
		
	self notify( "stop_loop" );
	
	self thread anim_generic( self, "look_down_stand" );
	self waittill("look_down_stand");
	
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_betterview" );		
	
	wait 1;
}

pond_price_hack()
{
	self endon( "stop_loop" );
	level endon( "_stealth_spotted" );
	
	flag_wait( "cargo" );
	
	self notify( "stop_loop" );
}

pond_betterview()
{
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	if( flag( "cargo" ) )
		return;
	level endon( "cargo" );
	
	level endon( "event_awareness" );
	
	node = getnode( "price_pond_better_node", "targetname" );
	
	self.ref_node.origin = node.origin;
	self.ref_node.angles = node.angles + (0,90,0);
		
	self setgoalnode( node );
	self.goalradius = 100;
	
	wait 1;
	self allowedstances( "crouch" );
	self waittill( "goal" );
	
	self allowedstances( "crouch", "stand" );
	
	self setgoalnode( node );
	self.goalradius = 4;
	self waittill( "goal" );
	
	wait .5;
	
	self.ref_node thread anim_generic( self, "alert2look_cornerL" );
	self.ref_node waittill("alert2look_cornerL");
	
	self thread anim_generic_loop( self, "look_idle_cornerL", undefined, "stop_loop" );	
	
	level function_stack(::radio_dialogue, "scoutsniper_mcm_withoutalerting" );		
	
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_sneakingpast" );		
			
	self notify( "stop_loop" );
	
	self thread anim_generic( self, "look2alert_cornerL" );
	self waittill("look2alert_cornerL");
	
	level function_stack(::radio_dialogue, "scoutsniper_mcm_yourcall2" );	
}

pond_sneakup()
{
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	if( flag( "pond_enemies_dead" ) )
		return;
	level endon( "pond_enemies_dead" );
	
	if( flag( "pond_patrol_dead" ) )
		return;
	level endon( "pond_patrol_dead" );
	
	if( flag( "cargo" ) )
		return;
	level endon( "cargo" );
	
	while( distance( level.player.origin, self.origin ) < 96 )
		wait .05;
	
	node = getnode( "price_pond_sneak_node", "targetname" );
	self follow_path( node, 128 );
}

pond_inposition()
{
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	if( flag( "pond_enemies_dead" ) )
		return;
	level endon( "pond_enemies_dead" );
	
	if( flag( "pond_thrower_dead" ) )
		return;
	level endon( "pond_thrower_dead" );
	
	if( flag( "cargo" ) )
		return;
	level endon( "cargo" );
	
	flag_wait( "pond_patrol_dead" );
	if( !flag( "_stealth_event" ) )
		level function_stack(::radio_dialogue, "scoutsniper_mcm_dontfire" );
	if( !flag( "_stealth_event" ) )
		level function_stack(::radio_dialogue, "scoutsniper_mcm_sametime" );
	
	nodes = getnodearray( "pond_in_position", "script_noteworthy" );
	nodes = get_array_of_closest( self.origin, nodes );
		
	node = nodes[0];
	self delaythread(.05, ::follow_path, node, 1 );
	first = true;
	msg = "scoutsniper_mcm_whenyoureready";
	
	
	while( isdefined( node ) )
	{
		self waittill( "follow_path_new_goal" );
		self disable_cqbwalk();
		self ent_flag_set( "_stealth_stance_handler" );
		self ent_flag_clear( "pond_in_position" );
		
		if( first )
		{
			if( distance( node.origin, self.origin ) < 8 ) 
				msg = undefined;
			else if( !flag( "_stealth_event" ) )
				level thread function_stack(::radio_dialogue, "scoutsniper_mcm_waitforme" );
			first = false;	
		}
		else if( !flag( "_stealth_event" ) )
			level thread function_stack(::radio_dialogue, "scoutsniper_mcm_holdyourfiremoving" );
			
		node waittill( "trigger" );	
		self thread pond_inposition_takeshot( node, msg );
		msg = undefined;
		
		if( isdefined( node.target ) )
			node = getnode( node.target, "targetname" );
		else
			node = undefined;
	}
}

pond_handle_kills( _wait, name, _flag, msg )
{
	level endon( "dash_spawn" );
	
	flag_wait( _wait );
	
	waittillframeend;
	
	ai = get_living_ai_array( name, "script_noteworthy" );
	
	waittill_dead( ai );
	
	flag_set( _flag );
	
	if( flag( "_stealth_spotted" ) )
		return;
		
	level thread function_stack(::radio_dialogue, msg );
}

pond_handle_clear()
{
	flag_wait( "pond_patrol_dead" );
	flag_wait( "pond_thrower_dead" );
	flag_set( "pond_enemies_dead" );
}

pond_kill_patrol()
{
	self endon( "death" );
	
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	if( flag( "cargo" ) )
		return;
	level endon( "cargo" );
	
	if( flag( "pond_enemies_dead" ) )
		return;
	level endon( "pond_enemies_dead" );
	
	if( flag( "pond_patrol_dead" ) )
		return;
	level endon( "pond_patrol_dead" );
	
	if( flag( "dash_spawn" ) )
		return;
	level endon( "dash_spawn" );
	
	ai = get_living_ai_array( "pond_patrol", "script_noteworthy" );
	
	if( ai.size > 1 )
	{
		waittill_dead(ai, 1);
		level thread function_stack(::radio_dialogue, "scoutsniper_mcm_targetelim" );
	}		
	
	wait .25;
		
	while( self ent_flag( "_stealth_stay_still" ) )
		self waittill( "_stealth_stay_still" );
	
	enemy = get_living_ai("pond_patrol", "script_noteworthy");
		
	enemy endon("death");
	
	//self thread intro_sneakup_patrollers_moveto_kill( enemy );
		
	while( isalive( enemy ) )
	{
		test = get_living_ai_array( "pond_throwers", "script_noteworthy" );
		
		//this makes sure price doesn't kill him and leave a corpse right infront of
		//the throwers
		if( test.size && isalive( test[0] ) )
		{
			if( distance( enemy.origin, test[0].origin ) < 550 )
			{
				wait .5;
				continue;	
			}
		}
		
		break;
	}
	self.ignoreall = false;
	enemy.ignoreme = false;
	self.favoriteenemy  = enemy;
	wait 1;
}

pond_kill_thrower()
{
	/*if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );*/
	
	if( flag( "cargo" ) )
		return;
	level endon( "cargo" );
	
	self endon( "death" );
	
	if( flag( "pond_enemies_dead" ) )
		return;
	level endon( "pond_enemies_dead" );
	
	if( flag( "pond_thrower_dead" ) )
		return;
	level endon( "pond_thrower_dead" );
	
	ai = get_living_ai_array( "pond_throwers", "script_noteworthy" );
	
	if( ai.size > 1 )
		waittill_dead(ai, 1);
		
	flag_set( "pond_thrower_kill" );
	
	wait .15;
		
	enemy = get_living_ai("pond_throwers", "script_noteworthy");
	
	if( !isdefined( enemy ) )
		return;
	
	self.ignoreall = false;
	enemy.ignoreme = false;
	
	enemy endon("death");
	
	//self thread intro_sneakup_patrollers_moveto_kill( enemy );
	
	if( flag( "pond_patrol_dead" ) )
	{
		self ent_flag_wait( "pond_in_position" );
		MagicBullet( self.weapon, self gettagorigin( "tag_flash" ), enemy getShootAtPos() );
		wait .05;
		enemy dodamage( enemy.health + 100, self.origin );
	}
	else
	{
		while( isalive( enemy ) )
		{
			self.favoriteenemy  = enemy;
			wait 1;
		}
	}
}

/************************************************************************************************************/
/*													CARGO													*/
/************************************************************************************************************/

cargo_main()
{
	if( !isalive( level.price ) )
		return;
	level.price endon( "death" );
	
	array = [];
	array[ "attack" ] = ::cargo_enemy_attack;
	
	array_thread( getentarray( "cargo_guys", "targetname" ), ::add_spawn_function, ::stealth_ai, undefined, array);
	array_thread( getentarray( "cargo_smokers", "script_noteworthy" ), ::add_spawn_function, ::idle_anim_think);
	array_thread( getentarray( "cargo_smokers", "script_noteworthy" ), ::add_spawn_function, ::flag_set, "cargo_smokers_spawned");
	array_thread( getentarray( "cargo_smokers", "script_noteworthy" ), ::add_spawn_function, ::mission_dialogue_kill);
	array_thread( getentarray( "cargo_sleeper", "script_noteworthy" ), ::add_spawn_function, ::idle_anim_think);
	array_thread( getentarray( "cargo_patrol_defend2", "script_noteworthy" ), ::add_spawn_function, ::idle_anim_think);
	array_thread( getentarray( "cargo_sleeper", "script_noteworthy" ), ::add_spawn_function, ::cargo_sleeper);
	array_thread( getentarray( "cargo_patrol", "script_noteworthy" ), ::add_spawn_function, ::cargo_patrol_death);
	array_thread( getentarray( "cargo_patrol_defend1", "script_noteworthy" ), ::add_spawn_function, ::cargo_patrol_defend1_death);
	
	thread cargo_enemies_death();
	thread cargo_handle_patroller();
	thread cargo_handle_defend1_flag();
	thread cargo_dialogue();				
	flag_wait( "initial_setup_done" );
	flag_wait( "cargo" );
	flag_wait( "field_price_done" );
		
	if( !flag( "_stealth_spotted" ) )
	{
		level.price.ignoreall = true;
		try_save( "cargo" );
		
		if( flag(  "pond_enemies_dead" ) )
		{
			level.price allowedstances( "prone", "crouch", "stand" );
			level.price ent_flag_clear( "_stealth_stance_handler" );
			level.price thread dynamic_run_speed();
		}
	}
	
	while( 1 )
	{
		level.price cargo_moveup();
		level.price allowedstances( "prone", "crouch", "stand" );
		level.price ent_flag_clear( "_stealth_stance_handler" );
		level.price notify( "stop_dynamic_run_speed" );
		
		level.price cargo_sneakup();
		
		if( flag( "cargo_smokers_spawned" ) )
			break;
			
		level add_wait( ::flag_waitopen, "_stealth_spotted" );
		level add_wait( ::flag_wait, "cargo_smokers_spawned" );
		level do_wait_any();
		
		level.price thread dynamic_run_speed();
	}
	
	
	level.price cargo_attack1();
	level.price allowedstances( "prone", "crouch", "stand" );
	
	level.price cargo_waitmove();
	
	level.price ent_flag_clear( "_stealth_stance_handler" );
	level.price allowedstances( "prone", "crouch", "stand" );
	
	level.price notify( "stop_dynamic_run_speed" );
	delaythread( 1, ::try_save, "cargo2" );
	
	level.price cargo_slipby();
	level.price disable_cqbwalk();
	level.price cargo_leave();
	
	while( flag( "_stealth_spotted" ) || flag( "_stealth_event" ) )
	{
		flag_waitopen( "_stealth_spotted" );
		flag_waitopen( "_stealth_event" );
		level.price cargo_leave();
	}
	
	flag_set( "dash" );	
}

cargo_dialogue()
{
	flag_wait( "cargo_smokers_spawned" );
	
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	if( flag( "_stealth_found_corpse" ) )
		return;
	level endon( "_stealth_found_corpse" );
	
	wait 1;
	
	aliases = [];
	aliases[ aliases.size ] = "scoutsniper_ru2_anyoneseedogs";
	aliases[ aliases.size ] = "scoutsniper_ru1_mercenaries";
	aliases[ aliases.size ] = "scoutsniper_ru4_radiationdogs";
	aliases[ aliases.size ] = "scoutsniper_ru2_buymotorbike";
	aliases[ aliases.size ] = "scoutsniper_ru2_americagoingtostartwar";
	guys = get_living_ai_array("cargo_smokers", "script_noteworthy");
	mission_dialogue_array( guys, aliases );		
}

cargo_patrol_death()
{
	self.fixednode = false;
	
	self waittill( "death" );
	flag_set( "cargo_patrol_dead" );
	
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	if( flag( "dash_spawn" ) )
		return;
	level endon( "dash_spawn" );
	
	if( !isdefined( self ) || !isalive( level.price ) )//might be removed - not killed
		return;	
		
	if( level.price cansee( self ) )
		level function_stack(::radio_dialogue, "scoutsniper_mcm_tangodown" );
}

cargo_enemies_death()
{
	trig = getent( "cargo_guys", "target" );
	trig waittill( "trigger" );
	
	wait .1;
	
	ai = get_living_ai_array( "cargo_smokers", "script_noteworthy" );
	ai = array_combine( ai, get_living_ai_array( "cargo_sleeper", "script_noteworthy" ) );
	ai = array_combine( ai, get_living_ai_array( "cargo_patrol", "script_noteworthy" ) );
	ai = array_combine( ai, get_living_ai_array( "cargo_patrol_defend1", "script_noteworthy" ) );
	ai = array_combine( ai, get_living_ai_array( "cargo_patrol_defend2", "script_noteworthy" ) );
	
	waittill_dead( ai );
	
	flag_set( "cargo_enemies_dead" );
}

cargo_sleeper()
{
	self endon( "death" );
	self.ignoreall = true;
	
	cargo_sleeper_wait_wakeup();
	
	self.ignoreall = false;	
}

cargo_patrol_defend1_death()
{
	self SetTalkToSpecies();//talk to no one
	
	name = "corpse_" + self.ai_number;
	
	self waittill("death");
	
	flag_set( "cargo_patrol_defend1_dead" );
	
	waittillframeend;//to allow the corpse entity to be created
	
	corpse = getent( name, "script_noteworthy" );
	if( !isdefined( corpse ) )
		return;
		
	corpse delete();
	level._stealth.logic.corpse.array = array_removeundefined( level._stealth.logic.corpse.array );
}

cargo_handle_defend1_flag()
{
	level endon( "cargo_started_defend_moment" );
	
	node = getent( "cargo_defend1_node", "targetname" );
	node waittill( "trigger" );
	
	flag_set( "cargo_enemy_ready_to_defend1" );
	
	length = getanimlength( %patrol_bored_idle_smoke );
	wait length - 1.25;
	flag_clear( "cargo_enemy_ready_to_defend1" );
	flag_set( "cargo_enemy_defend_moment_past" );
}

cargo_moveup()
{
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	node = getnode( "cargo_price_node1", "targetname" );
	self follow_path( node );
	
	if( !flag( "cargo_patrol_defend1_dead" ) )
		level function_stack(::radio_dialogue, "scoutsniper_mcm_inshadows" );
}

cargo_sneakup()
{
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	if( !flag( "cargo_patrol_defend1_dead" ) )
	{
		node = getent( "cargo_price_sneakup_node", "targetname" );
		self allowedstances( "crouch" );
		self follow_path( node );
	}
	
	//thread music_play( "scoutsniper_stealth_01_music" );
	thread cargo_sneakup_dialogue();
}

cargo_sneakup_dialogue()
{
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	if( flag( "cargo_enemies_dead" ) )
		return;
	level endon( "cargo_enemies_dead" );
	
	if( flag( "cargo_enemy_defend_moment_past" ) )
		return;
	level endon( "cargo_enemy_defend_moment_past" );
	
	if( !flag( "cargo_patrol_defend1_dead" ) )
	{
		if( !flag( "cargo_enemy_ready_to_defend1" ) )
			level function_stack(::radio_dialogue, "scoutsniper_mcm_stayback" );
		
		flag_wait_either( "cargo_enemy_ready_to_defend1", "cargo_patrol_defend1_dead" );
		
		if( !flag( "cargo_patrol_defend1_dead" ) )
		{
			radio_dialogue_stop();
			level thread function_stack(::radio_dialogue, "scoutsniper_mcm_hesmine" );
			wait 1.5;
			flag_set( "cargo_price_ready_to_attack1" );
		}
		else
		{
			//level function_stack(::radio_dialogue, "scoutsniper_mcm_tangodown" );
			if( level.price cansee( level.player ) )
				level function_stack(::radio_dialogue, "scoutsniper_mcm_move" );
		}
	}
	else
	{
		if( level.price cansee( level.player ) )
			level function_stack(::radio_dialogue, "scoutsniper_mcm_move" );
	}
}

cargo_attack1()
{
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	if( flag( "cargo_patrol_defend1_dead" ) )
		return;
	level endon( "cargo_patrol_defend1_dead" );
	
	if( flag( "cargo_enemy_defend_moment_past" ) )
		return;
	level endon( "cargo_enemy_defend_moment_past" );
		
	flag_wait( "cargo_enemy_ready_to_defend1" );
	flag_set( "cargo_started_defend_moment" );
	
	defender = get_living_ai( "cargo_patrol_defend1", "script_noteworthy" );
	defender endon( "death" );
	
	flag_wait( "cargo_price_ready_to_attack1" );
	
	node = spawn( "script_origin", defender.origin );
	node.angles = defender.angles;	
	
	node anim_generic_reach(self, "cargo_attack_1" );
	
	self thread cargo_attack1_commit( node, defender );
	node waittill ( "cargo_attack_1" );
}

cargo_attack1_commit( node, defender )
{	
	defender endon( "death" );
		
	defender notify( "end_patrol" );
	defender notify( "_stealth_stop_stealth_logic" );
	waittillframeend;//this sets allowdeath to false...so we need to wait a frame to make sure we can turn it back on below
	
	defender.ignoreall = true;
	defender.allowdeath = true;
	
	delaythread( .15, ::radio_dialogue_stop );	
	level delaythread( .2, ::function_stack, ::radio_dialogue, "scoutsniper_mcm_oisuzy" );
	
	alias = "scoutsniper_ru" + defender._stealth.behavior.sndnum + "_huh";
	defender delaythread(1, ::play_sound_on_entity, alias );
	
	self.favoriteenemy = defender;
	node thread anim_generic_custom_animmode( defender, "gravity", "cargo_defend_1" );
	
	self thread cargo_attack_commit_fail( defender, node, "cargo_attack_1" );
	node thread anim_generic_custom_animmode( self, "gravity", "cargo_attack_1" );
}

cargo_attack_commit_fail( guy, node, msg )
{
	node endon( msg );
	
	guy thread killed_by_player();
	
	guy waittill( "killed_by_player" );
	self stopanimscripted(); 
	self notify ( "stop_animmode" );
	node notify ( "stop_animmode" );
	anime = "run_2_stop";
	self anim_generic_custom_animmode( self, "gravity", anime );
}

cargo_waitmove()
{
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	if( flag( "cargo_enemies_dead" ) )
		return;
	level endon( "cargo_enemies_dead" );
	
	if( !flag( "cargo_enemy_defend_moment_past" ) )
		return;
		
	self allowedstances( "crouch" );
	
	self ent_flag_set( "_stealth_stance_handler" );
	
	check1 = (flag( "cargo_defender1_away" ) || flag( "cargo_patrol_defend1_dead" ) );

	if( !check1 )
	{
		level function_stack(::radio_dialogue, "scoutsniper_mcm_observe" );
	}
	else
	{
		level thread function_stack(::radio_dialogue, "scoutsniper_mcm_go" );
		return;
	}
		
	while( 1 )
	{
		flag_wait_any( "cargo_defender1_away", "cargo_patrol_defend1_dead" );	
		
		check1 = (flag( "cargo_defender1_away" ) || flag( "cargo_patrol_defend1_dead" ) );
		
		if( check1 )
			break;
		
		else
			level thread function_stack(::radio_dialogue, "scoutsniper_mcm_standby" );
	}
	
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_ourchance" );
}

cargo_slipby()
{
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	if( flag( "cargo_enemies_dead" ) )
		return;
	level endon( "cargo_enemies_dead" );
	
	thread cargo_insane();
	
	self enable_cqbwalk();
	
	dist = 300;
	//get to the next spot and wait for the player
		node = getnode( "cargo_price_slipby_1", "targetname" );	
		//level delaythread(1, ::function_stack, ::radio_dialogue, "scoutsniper_mcm_followme" );
		self follow_path( node );
	
	//handle the situation
	self cargo_slipby_part1( dist );
	//if we hit this line of code then the patroller is still alive and 
	//is either coming up on us, or has just past us and into the container
	
	dist = 450;
	//get to the next spot and wait for the player
		node = getnode( "cargo_price_slipby_3", "targetname" );
		self.ref_node.origin = node.origin;
		self.ref_node.angles = node.angles + (0,-90,0);
		self.ref_node anim_generic_reach_and_arrive( self, "stop_cornerR" );
		self.goalradius = 4;
		
		while( !( self wait_for_player( node, ::follow_path_get_node, dist ) ) )
			wait .05;
	
	//handle the situation
	self cargo_slipby_part2( dist );
	
	dist = 500;
	//get to the next spot and wait for the player	
		node = getnode( "cargo_price_slipby_4", "targetname" );
		self.ref_node.origin = node.origin;
		self.ref_node.angles = node.angles;
		self.ref_node anim_generic_reach_and_arrive( self, "stop_cqb" );
		self.goalradius = 4;
		
		//we're in plain view here - so if the player doesn't hurry up
		//and we're about to be spotted - we move on
		while( 1 )
		{
			wait .05;
			if( !flag( "cargo_patrol_away" ) && !flag( "cargo_patrol_dead" ) )
				break;
			if( self wait_for_player( node, ::follow_path_get_node, dist ) )
				break;
		}
	
	//handle the situation
	self cargo_slipby_part3( dist );
}

cargo_insane()
{	
	trig = getent( "cargo_insane", "targetname" );
	use = getentarray( "intelligence_item", "targetname" );
	use = get_array_of_closest( trig getorigin(), use );
	
	use[0] thread cargo_insane_handle_use();
	
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	if( flag( "cargo_enemies_dead" ) )
		return;
	level endon( "cargo_enemies_dead" );
	
	trig waittill( "trigger" );
	
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_youinsane" );
	
	use[0] waittill( "trigger" );
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_gotminerals" );
}

cargo_leave()
{
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	/*
	if( flag( "cargo_enemies_dead" ) )
		return;
	level endon( "cargo_enemies_dead" );
	*/
	
	thread cargo_leave_dialogue();
	
	node = getnode( "cargo_price_leave_node", "targetname" );
	
	self follow_path( node, 160 );
}

cargo_leave_dialogue()
{
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	wait 2;
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_letsgo" );	
}

/************************************************************************************************************/
/*													DASH													*/
/************************************************************************************************************/

dash_main()
{
	if( !isalive( level.price ) )
		return;
	level.price endon( "death" );
	
	state_functions = [];
	state_functions[ "hidden" ] 	= ::dash_state_hidden;
	state_functions[ "alert" ] 		= maps\_stealth_behavior::enemy_state_alert;
	state_functions[ "spotted" ] 	= maps\_stealth_behavior::enemy_state_spotted;
	
	corpse_functions = [];
	corpse_functions[ "saw" ] = ::field_enemy_awareness;
	corpse_functions[ "found" ] = ::field_enemy_awareness;
	
	awareness_funcs = [];
	awareness_funcs[ "heard_scream" ] = ::field_enemy_awareness;
	awareness_funcs[ "explode" ] = ::field_enemy_awareness;
		
	//intro guys
		array_thread( getentarray( "dash_intro_guy", "targetname" ), ::add_spawn_function, ::dash_kill_nosave );
		array_thread( getentarray( "dash_intro_guy2", "targetname" ), ::add_spawn_function, ::dash_kill_nosave );
		array_thread( getentarray( "dash_stander", "targetname" ), ::add_spawn_function, ::dash_kill_nosave );
	array_thread5( getentarray( "dash_intro_guy", "targetname" ), ::add_spawn_function, ::stealth_ai, state_functions, undefined, corpse_functions, awareness_funcs );
	array_thread( getentarray( "dash_intro_runner", "script_noteworthy" ), ::add_spawn_function, ::dash_intro_runner );
	array_thread( getentarray( "dash_intro_patroller", "script_noteworthy" ), ::add_spawn_function, ::dash_intro_patrol );
	array_thread5( getentarray( "dash_intro_guy2", "targetname" ), ::add_spawn_function, ::stealth_ai, state_functions, undefined, corpse_functions, awareness_funcs );
	array_thread5( getentarray( "dash_stander", "targetname" ), ::add_spawn_function, ::stealth_ai, state_functions, undefined, corpse_functions, awareness_funcs );
	array_thread( getentarray( "dash_stander", "targetname" ), ::add_spawn_function, ::dash_stander );
	
	//random
		array_thread( getentarray( "dash_bus_guys", "targetname" ), ::add_spawn_function, ::dash_kill_nosave );
	array_thread5( getentarray( "dash_bus_guys", "targetname" ), ::add_spawn_function, ::stealth_ai, state_functions, undefined, corpse_functions, awareness_funcs );
	array_thread( getentarray( "dash_bus_idler", "script_noteworthy" ), ::add_spawn_function, ::dash_idler );	
	array_thread( getentarray( "dash_bus_runner", "script_noteworthy" ), ::add_spawn_function, ::deleteOntruegoal );	
	
		array_thread( getentarray( "dash_crawl_patroller", "script_noteworthy" ), ::add_spawn_function, ::dash_kill_nosave );
	array_thread5( getentarray( "dash_crawl_patroller", "script_noteworthy" ), ::add_spawn_function, ::stealth_ai, state_functions, undefined, corpse_functions, awareness_funcs );
	array_thread( getentarray( "dash_crawl_patroller", "script_noteworthy" ), ::add_spawn_function, ::dash_crawl_patrol );
	array_thread( getentarray( "dash_crawl_patroller", "script_noteworthy" ), ::add_spawn_function, ::mission_dialogue_kill );
	
		array_thread( getentarray( "dash_on_road_guy", "targetname" ), ::add_spawn_function, ::dash_kill_nosave );
		array_thread( getentarray( "dash_on_road_guy2", "targetname" ), ::add_spawn_function, ::dash_kill_nosave );
	array_thread5( getentarray( "dash_on_road_guy", "targetname" ), ::add_spawn_function, ::stealth_ai, state_functions, undefined, corpse_functions, awareness_funcs );
	array_thread( getentarray( "dash_on_road_guy", "targetname" ), ::add_spawn_function, ::deleteOntruegoal );
	array_thread5( getentarray( "dash_on_road_guy2", "targetname" ), ::add_spawn_function, ::stealth_ai, state_functions, undefined, corpse_functions, awareness_funcs );
	array_thread( getentarray( "dash_on_road_guy2", "targetname" ), ::add_spawn_function, ::deleteOntruegoal );
	
		array_thread( getentarray( "dash_last_runner", "targetname" ), ::add_spawn_function, ::dash_kill_nosave );
	array_thread( getentarray( "dash_last_runner", "targetname" ), ::add_spawn_function, ::stealth_ai );
	array_thread( getentarray( "dash_last_runner", "targetname" ), ::add_spawn_function, ::deleteOntruegoal );
	
	//guys in cars
		array_thread( getentarray( "dash_patroller", "targetname" ), ::add_spawn_function, ::dash_kill_nosave );
		array_thread( getentarray( "dash_idler", "targetname" ), ::add_spawn_function, ::dash_kill_nosave );
	array_thread5( getentarray( "dash_patroller", "targetname" ), ::add_spawn_function, ::stealth_ai, state_functions, undefined, corpse_functions, awareness_funcs );
	array_thread5( getentarray( "dash_idler", "targetname" ), ::add_spawn_function, ::stealth_ai, state_functions, undefined, corpse_functions, awareness_funcs );
	array_thread( getentarray( "dash_patroller", "targetname" ), ::add_spawn_function, ::dash_ai );
	array_thread( getentarray( "dash_idler", "targetname" ), ::add_spawn_function, ::dash_ai );
	
	alert_functions = [];
	alert_functions[ "reset" ] = ::dash_sniper_alert;
	alert_functions[ "alerted_once" ] = ::dash_sniper_alert;
	alert_functions[ "alerted_again" ] = ::dash_sniper_attack;
	alert_functions[ "attack" ] = ::dash_sniper_attack;
	
	//sniper
	array_thread5( getentarray( "dash_sniper", "targetname" ), ::add_spawn_function, ::stealth_ai, undefined, alert_functions, corpse_functions, awareness_funcs );
	array_thread( getentarray( "dash_sniper", "targetname" ), ::add_spawn_function, ::dash_sniper_death );
		
	//nodes that set flags
	array_thread( getentarray( "dash_guard_check", "script_noteworthy" ), ::dash_run_check );
	
	trigger = getent( "dash_intro_guy", "target" );
	thread set_flag_on_trigger( trigger, "dash_spawn" );
	
	thread dash_handle_price_stop_bullet_shield();	
	thread dash_handle_doors_blowopen();
	thread dash_handle_nosight_clip();
	thread dash_handle_heli();
	thread dash_hind_death_dialogue();	
	thread dash_handle_stealth_unsure();
	thread dash_dialogue();
	
	flag_wait( "initial_setup_done" );
	flag_wait( "dash" );
	
	level.price dash_holdup();
	if( !flag( "dash_stealth_unsure" ) )	
		try_save( "dash_start" );	
	level.price dash_run();
	if( !flag( "dash_stealth_unsure" ) )	
		try_save( "dash_run" );
	level.price dash_crawl();
	level.price dash_last();
	
	dash_reset_stealth_to_default();
	
	level.price dash_sniper();
	
	thread dash_delay_save();
		
	level.price.moveplaybackrate = 1;
	level.price clear_run_anim();	
	
	level.price allowedstances( "stand", "crouch", "prone" );
	
	if( flag( "_stealth_spotted" ) || flag( "_stealth_event" ) )
	{
		flag_waitopen( "_stealth_spotted" );
		flag_waitopen( "_stealth_event" );
		flag_waitopen( "_stealth_alert" );
		if( level.player.health )
			level thread function_stack(::radio_dialogue, "scoutsniper_mcm_getuskilled" );
	}
	else
		level thread function_stack(::radio_dialogue, "scoutsniper_mcm_moveout" );	
	
	flag_set( "town" );
}

dash_kill_nosave()
{
	level endon( "dash_reset_stealth_to_default" );
	
	self waittill( "death", other );
	if( !isdefined( other ) )
		return;
	if( other == level.player )
		flag_set( "dash_stealth_unsure" );
}

dash_delay_save()
{
	wait .5;
	if( !flag( "dash_stealth_unsure" ) )	
		try_save( "dash_run" );
}
dash_dialogue()
{
	flag_wait( "dash_door_R_open" );
	
	level endon( "_stealth_spotted" );
	level endon( "_stealth_found_corpse" );
	
	aliases = [];
	aliases[ aliases.size ] = "scoutsniper_ru1_readytomove";
	aliases[ aliases.size ] = "scoutsniper_ru2_yescomrade";
	aliases[ aliases.size ] = "scoutsniper_ru1_helicopteronway";
	aliases[ aliases.size ] = "scoutsniper_ru1_zonesafe";
	aliases[ aliases.size ] = "scoutsniper_ru1_okbringin";
	aliases[ aliases.size ] = "scoutsniper_ru2_clearrotorblades";
	aliases[ aliases.size ] = "scoutsniper_ru1_checkthewoods";
	
	temp = get_array_of_closest( level.player.origin, get_living_ai_array( "dash_intro_patroller", "script_noteworthy" ) );
	if( temp.size )
	{
		guys = [];
		guys[ 0 ] = temp[ 0 ];
		
		guys[0] thread mission_dialogue_kill();
		
		mission_dialogue_array( guys, aliases );		
	}
	
	flag_wait( "dash_crawl_patrol_spawned" );
	
	wait 1;
	
	aliases = [];
	aliases[ aliases.size ] = "scoutsniper_ru2_radiationdosimeters";
	aliases[ aliases.size ] = "scoutsniper_ru1_replacedbatteries";
	aliases[ aliases.size ] = "scoutsniper_ru1_getsworse";
	aliases[ aliases.size ] = "scoutsniper_ru2_dontbelieveatall";
	aliases[ aliases.size ] = "scoutsniper_ru1_dogsdontgetclose";
	aliases[ aliases.size ] = "scoutsniper_ru2_ok";
	aliases[ aliases.size ] = "scoutsniper_ru4_mayhaveproblem";
	aliases[ aliases.size ] = "scoutsniper_ru1_whathappened";
	aliases[ aliases.size ] = "scoutsniper_ru2_professionaljob";
	aliases[ aliases.size ] = "scoutsniper_ru1_specialforces";
	aliases[ aliases.size ] = "scoutsniper_ru2_possiblyspetznaz";
	aliases[ aliases.size ] = "scoutsniper_ru4_canceltransactions";
	aliases[ aliases.size ] = "scoutsniper_ru1_nuclearreactor";
	
	guys = get_living_ai_array( "dash_crawl_patroller", "script_noteworthy" );
	if( !guys.size )
		return;
	mission_dialogue_array( guys, aliases );
}

dash_holdup()
{		
	self pushplayer( true );
	
	node = getnode("dash_price_start_node", "targetname");
	
	self follow_path( node, 200 );
	
	thread dash_fake_easy_mode();
		
	flag_set( "dash_start" );
	
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
		
	wait 1;
	
	doorR = getent( "dash_door_right", "script_noteworthy" );	
	doorL = getent( "dash_door_left", "script_noteworthy" );	
	
	flag_set( "dash_door_R_open" );
	doorR playsound( "door_cargo_container_push_open" );
	doorR dash_door_slow( 1 );
	
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_mysignal" );	
}

dash_run()
{
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	doorR = getent( "dash_door_right", "script_noteworthy" );	
	doorL = getent( "dash_door_left", "script_noteworthy" );
	
	self.moveplaybackrate = 1.25;
	self set_generic_run_anim( "sprint" );	
	
	wait 9.5;
	
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_hoooold" );
	
	wait 4;
	
	delaythread( 2.25, ::music_play, "scoutsniper_dash_music" );
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_okgo" );
	
	wait 2;
	
	flag_set( "dash_door_L_open" );
	doorR thread dash_door_fast( .35 );
	doorL thread dash_door_fast( -1.35 );
	doorL playsound( "door_cargo_container_burst_open" );
	
	node = getnode( "dash_price_node2", "targetname" );
	self follow_path( node );
	
	wait 2;
}

dash_crawl()
{
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	self.moveplaybackrate = 1;
	self clear_run_anim();	
	
	node = getent( "dash_price_crawl_start", "targetname" );
	if( distance( level.player.origin, level.price.origin ) < level.hearing_distance )
		level thread function_stack(::radio_dialogue, "scoutsniper_mcm_letsgo2" );
	self thread crawl_path( node );
	self maps\_stealth_behavior::ai_create_behavior_function( "state", "spotted", ::dash_state_spotted );
	
	trig = getent( "dash_crawl_patroller1", "target" );
	trig waittill( "trigger" );
	
	trig = getent( "dash_crawl_firsttruck", "targetname" );
	trig waittill( "trigger" );
	if( distance( level.player.origin, level.price.origin ) < level.hearing_distance )
		level thread function_stack(::radio_dialogue, "scoutsniper_mcm_useascover" );	
		
	self waittill( "path_end_reached" );
	
	flag_set( "dash_last" );
	
	if( flag( "town_no_turning_back" ) )
		return;
	level endon( "town_no_turning_back" );
	
	if( distance( level.player.origin, level.price.origin ) < level.hearing_distance )
		level thread function_stack(::radio_dialogue, "scoutsniper_mcm_crawlout" );
	
	wait 13.5;
	
	if( distance( level.player.origin, level.price.origin ) < level.hearing_distance )
		level thread function_stack(::radio_dialogue, "scoutsniper_mcm_anythingstupid" );
	
	wait 12.5;
	
	if( distance( level.player.origin, level.price.origin ) < level.hearing_distance )
		level thread function_stack(::radio_dialogue, "scoutsniper_mcm_standbygo" );
	
	self maps\_stealth_behavior::ai_create_behavior_function( "state", "spotted", maps\_stealth_behavior::friendly_state_spotted );
	wait 4;
}

dash_last()
{
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	node = getnode( "dash_last_stretch1", "targetname" );
	
	vec = node.origin - self.origin;
	angles =  vectortoangles( vec );
	self.ref_node.origin = self.origin;
	self.ref_node.angles = ( 0, angles[ 1 ], 0 );
	
	//level thread function_stack(::radio_dialogue, "scoutsniper_mcm_go" );
	
	self.ref_node anim_generic( self, "crawl_loop" );
	
	length = getanimlength( getanim_generic( "prone2stand" ) );
	self thread anim_generic( self, "prone2stand" );
	wait length - .2;
	self stopanimscripted();
	
	self allowedstances( "stand", "crouch", "prone" );
	self delaythread( .5, ::follow_path, node, 100 );	
	
	length = getanimlength( getanim_generic( "stand2run" ) );
	self thread anim_generic( self, "stand2run" );
	wait length - .2;
	self stopanimscripted();
	
	if( flag( "town_no_turning_back" ) )
	{
		if( !flag( "dash_work_as_team" ) )
			level thread function_stack(::radio_dialogue, "scoutsniper_mcm_ateam" );
		return;
	}
	level endon( "town_no_turning_back" );
	
	self waittill( "path_end_reached" );
	
	if( !flag( "dash_stealth_unsure" ) )	
		try_save( "dash_last" );
	
	self.moveplaybackrate = 1.25;
	self set_generic_run_anim( "sprint" );		
	node = getnode( "dash_last_stretch2", "targetname" );
	
	if( distance( level.player.origin, level.price.origin ) < level.hearing_distance )
		level thread function_stack(::radio_dialogue, "scoutsniper_mcm_readygo" );
	
	wait 1;
	
	if( flag( "dash_sniper_dead" ) )
		return;
	level endon( "dash_sniper_dead" );
	
	delaythread( .1, ::music_play, "scoutsniper_dash_music" );
		
	self follow_path( node, 400 );
	
	self.moveplaybackrate = 1;
	self clear_run_anim();
	
	wait 1;
	
	self.ref_node.origin = node.origin;
	self.ref_node.angles = node.angles + (0,-90,0);
	
	if( distance( level.player.origin, level.price.origin ) < level.hearing_distance )
		level thread function_stack(::radio_dialogue, "scoutsniper_mcm_holdfast" );
	self.ref_node thread anim_generic( self, "stop_cornerR" );
	self.ref_node waittill("stop_cornerR");
		
	wait .5;
	if( distance( level.player.origin, level.price.origin ) < level.hearing_distance )
		level thread function_stack(::radio_dialogue, "scoutsniper_mcm_noonesaw" );
	
	wait .5;
	
	self.ref_node thread anim_generic( self, "onme_cornerR" );
	self.ref_node waittill("onme_cornerR");
}

dash_sniper()
{
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	if( flag( "dash_sniper_dead" ) )
		return;
	level endon( "dash_sniper_dead" );
	
	node = getnode( "dash_lookout_node", "targetname" );
	//delay to give price a chance to face in the right direction...otherwise
	//since he's facing the wrong way - he thinks the player hasn't caught up
	//when in fact he's actually ahead
	self delaythread( 1, ::dynamic_run_speed ); 
	self follow_path( node );	
	self notify( "stop_dynamic_run_speed" );
	
	
	heli = get_vehicle( "dash_hind", "targetname" );
	if( isdefined( heli ) )
		heli thread maps\_vehicle::lerp_enginesound( 4, 1, .75 );
	
		
	wait .5;
	
	self.ref_node.origin = node.origin;
	self.ref_node.angles = node.angles + (0,-90,0);
	
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_dontmove" );
	self.ref_node thread anim_generic( self, "stop_cornerR" );
	self.ref_node waittill("stop_cornerR");
	
	self.ref_node thread anim_generic( self, "enemy_cornerR" );
	level function_stack(::radio_dialogue, "scoutsniper_mcm_sniperahead" );
	level function_stack(::radio_dialogue, "scoutsniper_mcm_giveaway" );
	
	while( !flag( "dash_sniper_dead" ) )
	{
		wait randomfloatrange( 12, 15 );
		
		level function_stack(::radio_dialogue, "scoutsniper_mcm_topbalcony" );		
	}
}

dash_hind_death_dialogue()
{
	level endon( "end" );
	level endon( "dash_hind_deleted" );
	
	flag_wait( "_stealth_spotted" );
	
	flag_wait( "dash_hind_down" );
		
	flag_waitopen( "_stealth_spotted" );
	flag_waitopen( "_stealth_event" );
	flag_waitopen( "_stealth_alert" );
	wait .5;
	flag_waitopen( "_stealth_spotted" );
	flag_waitopen( "_stealth_event" );
	flag_waitopen( "_stealth_alert" );
	
	if( level.player.health )
		level thread function_stack(::radio_dialogue, "scoutsniper_mcm_getuskilled" );
}

/************************************************************************************************************/
/*													TOWN													*/
/************************************************************************************************************/

town_main()
{
	if( !isalive( level.price ) )
		return;
	level.price endon( "death" );
	
	flag_wait( "initial_setup_done" );
	
	thread town_kill_dash_heli();
	
	//trig = getent( "dog_eater_trigger", "targetname" );
	//thread set_flag_on_trigger( trig, "end_start_music" );
	
	level add_wait( ::flag_wait, "town_no_turning_back" );
	level add_func( ::music_loop, "scoutsniper_abandoned_music", 117, "end_kill_music" );
	thread do_wait();
	
	flag_wait( "town" );
		
	thread dash_fake_easy_mode();
		
	level.price town_moveup();
	level.price notify( "stop_dynamic_run_speed" );
		
	level.price town_moveup2();
	level.price notify( "stop_dynamic_run_speed" );
		
	level.player stealth_friendly_movespeed_scale_default();
	stealth_detect_ranges_default();
	
	level.price town_moveup3();
	level.price notify( "stop_dynamic_run_speed" );
	
	if( !flag( "_stealth_spotted" ) && !flag( "dash_heli_agro" ) )
		level delaythread(1, ::function_stack, ::radio_dialogue, "scoutsniper_mcm_notthereyet" );
	
	if( !flag( "dash_heli_agro" ) )
		try_save( "town" );
	
	flag_set( "dogs" );
}

town_moveup()
{
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	if( flag( "dash_heli_agro" ) )
		return;
	level endon( "dash_heli_agro" );
	
	if( flag( "town_no_turning_back" ) )
		return;
	level endon( "town_no_turning_back" );
	
	node = getnode( "town_moveup_node", "targetname" );	
	
	//delay to give price a chance to face in the right direction...otherwise
	//since he's facing the wrong way - he thinks the player hasn't caught up
	//when in fact he's actually ahead	
	self delaythread( .5, ::dynamic_run_speed, undefined, 80  );
	self follow_path( node );
		
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_go" );	
}

town_moveup2()
{
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	if( flag( "dash_heli_agro" ) )
		return;
	level endon( "dash_heli_agro" );
	
	if( flag( "town_no_turning_back" ) )
		return;
	level endon( "town_no_turning_back" );
	
	
	node = getnode( "town_moveup_node2", "targetname" );	
		
	self thread dynamic_run_speed( undefined, 80 );
	self follow_path( node, 180 );
	
	flag_wait( "town_jumpdown" );
	
	self notify( "stop_dynamic_run_speed" );
	
	wait .5;
	
	self.ref_node.origin = node.origin;
	self.ref_node.angles = node.angles + (0,-90,0);
	
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_areaclear" );
}

town_moveup3()
{
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	if( flag( "dash_heli_agro" ) )
		return;
	level endon( "dash_heli_agro" );
	
	node = getnode( "town_moveup_node3", "targetname" );	
	
	self thread dynamic_run_speed( undefined, 80 );
	self follow_path( node, 400 );
	self notify( "stop_dynamic_run_speed" );	
}

/************************************************************************************************************/
/*													DOGS													*/
/************************************************************************************************************/
dogs_main()
{
	if( !isalive( level.price ) )
		return;
	level.price endon( "death" );
	
	array_thread( getentarray( "dogs_backup", "targetname" ), ::add_spawn_function, ::stealth_ai );
	array_thread( getentarray( "dogs_backup", "targetname" ), ::add_spawn_function, ::dogs_backup );
	array_thread( getentarray( "dogs_food", "script_noteworthy" ), ::add_spawn_function, ::dogs_food );
	array_thread( getentarray( "dogs_eater", "script_noteworthy" ), ::add_spawn_function, ::dogs_eater );
	array_thread( getentarray( "dogs_eater", "script_noteworthy" ), ::add_spawn_function, ::dogs_eater_death );
		
	flag_wait( "initial_setup_done" );
	
	flag_wait( "dogs" );
	
	level.price dogs_moveup();
	
	if( !flag( "_stealth_spotted" ) && !flag( "dogs_dog_dead" ) && !flag( "dogs_backup" ) )	
		try_save( "dogs1" );
	
	level.price dogs_sneakpast();
	
	flag_waitopen( "_stealth_spotted" );
	flag_waitopen( "_stealth_event" );
	flag_waitopen( "dogs_dog_dead" );
	flag_waitopen( "dogs_backup" );
	flag_waitopen( "dash_heli_agro" );	
	
	wait .5;
	
	flag_waitopen( "_stealth_spotted" );
	flag_waitopen( "_stealth_event" );
	flag_waitopen( "dogs_dog_dead" );
	flag_waitopen( "dogs_backup" );
	flag_waitopen( "dash_heli_agro" );	
	
	flag_set( "center" );
	
	//try_save( "dogs2" );
	
	level.price.ignoreme = true;
}

dogs_food()
{
	self.dieQuietly = true;
	self.deathanim = %covercrouch_death_1;
	self gun_remove();
	self dodamage( self.health + 300, self.origin );
}

dogs_eater()
{
	self endon( "death" );
	
	node = getent( "dogs_eat_node", "targetname" );
	self.ref_node = node;
	self.ref_angles = node.angles;
	self.mode = "none";
	self.health = 1;
	self.maxhealth = 1;
		
	oldRadius = self.goalradius;
	self.goalradius = 4;
	self linkto( node );
	self thread dog_eater_unlink_on_death();
		
	while( 1 )
	{		
		if( distance( self.origin, level.player.origin) > 500 )
			self thread dogs_eater_eat();
		else
		if( distance( self.origin, level.player.origin) > 350 )
			self thread dogs_eater_growl();
		else	
		if( distance( self.origin, level.player.origin) > 200 )
			self thread dogs_eater_bark();
		else
			break;
		
		wait .1;
	}
	
	self unlink();
	
	self.goalradius = oldRadius;	
	
	self notify( "stop_loop" );
	self.ref_node notify( "stop_loop" );
	self stopanimscripted();
	self.favoriteenemy = level.player;
}

dog_eater_unlink_on_death()
{
	self waittill( "death" );
	
	if( isdefined( self ) )
		self unlink();	
}

dogs_eater_death()
{
	level endon( "dogs_delete_dogs" );
	
	self waittill( "death" );
	
	if( isdefined( self ) )
		self stoploopsound();
	
	flag_set( "dogs_dog_dead" );
	trigger_on( "dogs_backup", "target" );	
	
	flag_wait( "dogs_backup" );
	
	level.price stop_magic_bullet_shield();
	
	
	thread music_play( "scoutsniper_surrounded_music" );
	
	wait 3;
	
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_soundgood" );	
	
	flag_wait( "_stealth_spotted" );
	flag_waitopen( "_stealth_spotted" );
	flag_waitopen( "_stealth_event" );
	
	flag_clear( "dogs_backup" );
	
	if( isalive( level.price ) && !isdefined( level.price.magic_bullet_shield ) )
		level.price delaythread( .1, ::magic_bullet_shield );
	
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_whew" );
	delaythread(.1, ::music_loop, "scoutsniper_abandoned_music", 117, "end_kill_music" );
}

dogs_backup()
{
	flag_set( "dogs_backup" );
	flag_clear( "dogs_dog_dead" );
	
	if( !isalive( self ) )
		return;
	self endon( "death" );
	
	if( isdefined( self.script_animation ) )
	{	
		self script_delay();	
		self playsound( "anml_dog_excited_distant" );
		wait randomfloatrange( 1.5, 3 );
	}
	else
		wait randomfloatrange( 4, 6 );
			
	self.ignoreall = false;
	self setthreatbiasgroup();
		
	if( randomint( 100 ) > 65 && isalive( level.price ) )
		self.favoriteenemy = level.price;	
	else if( isalive( level.player ) )
		self.favoriteenemy = level.player;
	
	if( isalive( level.price ) )
		level.price.ignoreme = false;
}

dogs_moveup()
{
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );	
	
	if( flag( "dogs_backup" ) )
		return;
	level endon( "dogs_backup" );
	
	if( flag( "dogs_dog_dead" ) )
		return;
	level endon( "dogs_dog_dead" );
	
	if( flag( "dash_heli_agro" ) )
		return;
	level endon( "dash_heli_agro" );
		
	node = getnode( "dogs_moveup_node1", "targetname" );	
		
	self thread dynamic_run_speed( undefined, 80 );
	self thread follow_path( node );
	
	//node waittill( "trigger" );
	
	self waittill( "path_end_reached" );
	//thread music_play( "scoutsniper_pripyat_music" );
	self notify( "stop_dynamic_run_speed" );
	
	wait .5;
	self enable_cqbwalk();
	
	self.ref_node.origin = self.origin;
	self.ref_node.angles = self.angles;
	
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_stop" );
	self.ref_node thread anim_generic( self, "stop2_exposed" );
	self.ref_node waittill("stop2_exposed");
	
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_wilddog" );
	
	self.ref_node thread anim_generic( self, "enemy_exposed" );
	self.ref_node waittill("enemy_exposed");
	
	
	node = getent( "dogs_moveup_node2", "targetname" );
	node anim_generic_reach( self, "cqb_look_around" );
	node thread anim_generic( self, "cqb_look_around" );
	
	wait 1;
	
	node = getnode( "dogs_moveup_node3", "targetname" );
	self follow_path( node );
}

dogs_sneakpast()
{
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );	
	
	if( flag( "dogs_backup" ) )
		return;
	level endon( "dogs_backup" );
	
	if( flag( "dogs_dog_dead" ) )
		return;
	level endon( "dogs_dog_dead" );
	
	if( flag( "dash_heli_agro" ) )
		return;
	level endon( "dash_heli_agro" );
		
	level function_stack(::radio_dialogue, "scoutsniper_mcm_pooch" );
	level delaythread( 1, ::function_stack, ::radio_dialogue, "scoutsniper_mcm_noneed" );
	
	node = getnode( "dogs_sneakpast", "targetname" );
	self follow_path( node, 200 );	
	
	node = self.last_set_goalnode;
	self.ref_node.origin = node.origin;
	self.ref_node.angles = node.angles + (0,-90,0);
	
	level function_stack(::radio_dialogue, "scoutsniper_mcm_clearright" );
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_go" );
	self.ref_node thread anim_generic( self, "moveout_cornerR" );
	self.ref_node waittill("moveout_cornerR");
}

/************************************************************************************************************/
/*													CENTER													*/
/************************************************************************************************************/
center_main()
{
	if( !isalive( level.price ) )
		return;
	level.price endon( "death" );
	
	flag_wait( "initial_setup_done" );
	flag_wait( "center" );
	
	level.player playsound( "playground_memory" );
	
	thread center_handle_heli();
	
	level.price center_moveup();
	
	flag_waitopen( "_stealth_spotted" );
	flag_waitopen( "dogs_dog_dead" );
	flag_waitopen( "dogs_backup" );
	
	level.price center_moveup2();
	
	flag_waitopen( "_stealth_spotted" );
	flag_waitopen( "dogs_dog_dead" );
	flag_waitopen( "dogs_backup" );
	
	flag_set( "dogs_delete_dogs" );
	trigger_off( "dogs_backup", "target" );	
	
	level.price center_moveup3();
	level.price center_moveup4();
	//level.price center_moveup5();
	
	flag_set( "end" );
}

center_handle_heli()
{
	msg = "kill_center_handle_heli_thread";
	level endon( msg );
	node = getent( "center_heli_path", "targetname" );
			
	node waittill( "trigger", heli );
	
	heli endon( "death" );
	
	target_set( heli, ( 0,0,-80 ) );
	target_setJavelinOnly( heli, true );
	
	heli thread center_heli_quake( msg );
	
	level thread notify_delay( msg, 10 );
}

center_moveup()
{
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );	
	
	if( flag( "dogs_backup" ) )
		return;
	level endon( "dogs_backup" );
	
	if( flag( "dogs_dog_dead" ) )
		return;
	level endon( "dogs_dog_dead" );
	
	self disable_cqbwalk();
	self delaythread( .5, ::dynamic_run_speed, undefined, 80  );
	
	node = getnode( "center_node1", "targetname" );
	self follow_path( node );
	
	//thread music_play( "scoutsniper_stealth_01_music" );
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_forwardclear" );
}

center_moveup2()
{
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );	
	
	if( flag( "dogs_backup" ) )
		return;
	level endon( "dogs_backup" );
	
	if( flag( "dogs_dog_dead" ) )
		return;
	level endon( "dogs_dog_dead" );
	
	
	node = getnode( "center_node2", "targetname" );
	self thread follow_path( node );
	
	if( distance( self.origin, node.origin ) > 700 )
	{
		self disable_cqbwalk();
		self delaythread( .5, ::dynamic_run_speed,  undefined, 80  );
	}
	else
		self enable_cqbwalk();
	
	node waittill( "trigger" );
	self notify( "stop_dynamic_run_speed" );
	self enable_cqbwalk();
	 
	self waittill( "path_end_reached" );
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_moveup" );
}

center_moveup3()
{
	self disable_cqbwalk();
	
	node = getnode( "center_node4", "targetname" );
	self thread follow_path( node, 325 );
	
	node waittill( "trigger" );
	//thread music_play( "scoutsniper_deadpool_music" );
		
	self notify( "stop_dynamic_run_speed" );
	self enable_cqbwalk();
	
	wait 2;
	
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_ghosttown" );	
				
	self waittill( "path_end_reached" );
}

center_moveup4()
{
	self disable_cqbwalk();
	
	node = getnode( "center_node5", "targetname" );
	self follow_path( node, 200 );
	
	wait .25;
	
	self.ref_node.origin = node.origin;
	self.ref_node.angles = node.angles + (0,-90,0);
	
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_move" );
	self.ref_node thread anim_generic( self, "moveout_cornerR" );
	self.ref_node waittill("moveout_cornerR");
	
	self enable_cqbwalk();
		
	node = getnode( "center_node6", "targetname" );
	self follow_path( node );
}

/************************************************************************************************************/
/*													END														*/
/************************************************************************************************************/

end_main()
{
	if( !isalive( level.price ) )
		return;
	level.price endon( "death" );
	
	flag_wait( "initial_setup_done" );
	flag_wait( "end" );
	
	level.price end_moveup();
	
	flag_set( "level_complete" );
}

end_moveup()
{
	node = getnode( "end_node_look", "targetname" );
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_letsgo" );
	
	self disable_cqbwalk();
	self delaythread( .25, ::dynamic_run_speed, undefined, 80  );
	
	self follow_path( node, 200 );
	level thread function_stack(::radio_dialogue, "scoutsniper_mcm_thereshotel" );
	
	origin = node.origin;
	vec = anglestoforward( node.angles );
	vec = vector_multiply( vec, 100 );
	origin += vec;
	origin += (0,0,80);	
	
	target = spawn( "script_origin", origin );
	target movez( 30, 2.5 );
		
	self enable_cqbwalk();	
	self cqb_aim( target );
		
	wait 2.5;
	target moveto( target.origin + ( 0, 100, 60 ), 2.5 );
	wait 2.5;
	
	self disable_cqbwalk();
	target delete();
	
	node = getnode( "end_node_end", "targetname" );
	self setgoalnode( node );
	self.goalradius = 16;
			
	wait 3;
}

level_complete()
{
	flag_wait( "level_complete" );
	
	if( !flag( "broke_stealth" ) )
		maps\_utility::giveachievement_wrapper("GHILLIES_IN_THE_MIST");
		
	maps\_loadout::SavePlayerWeaponStatePersistent( "scoutsniper" );
	nextmission();
}

/************************************************************************************************************/
/*												OBJECTIVES													*/
/************************************************************************************************************/

objective_main()
{
	waittillframeend;
	if( level.start_point == "default" )
	{
		flag_wait( "intro" );
		wait 14;
	}
	//hotel_entrance = getent( "hotel_entrance", "targetname" );
	objective_add( 1, "active", &"SCOUTSNIPER_FOLLOW_CPT_MACMILLAN" );
	objective_current( 1 );
	thread objective_price();
}

objective_price()
{
	while( isalive( level.price ) )
	{
		objective_position( 1, level.price.origin );
		wait .05;
	}
}

/************************************************************************************************************/
/*											START POINT INITS												*/
/************************************************************************************************************/

start_intro()
{
	start_common();
	
	flag_set( "initial_setup_done" );
}

start_church()
{
	start_church_x();
	
	array_thread( getentarray( "tableguards", "script_noteworthy" ), ::add_spawn_function, ::stealth_ai);
	array_thread( getentarray( "tableguards", "script_noteworthy" ), ::add_spawn_function, ::idle_anim_think);
	array_thread5( getentarray( "tableguards", "script_noteworthy" ), ::add_spawn_function, maps\_stealth_behavior::ai_create_behavior_function, "alert", "attack", ::intro_attack_logic );
	array_thread( getentarray( "tableguard_last_patrol", "targetname" ), ::add_spawn_function, ::intro_lastguy_think);
	
	delaythread( .1, ::scripted_array_spawn, "tableguards", "script_noteworthy", true );
	delaythread( .1, ::scripted_array_spawn, "intro_dogs", "script_noteworthy", true );
	
	flag_set( "initial_setup_done" );
}

start_church_x()
{
	start_common();
	thread intro_to_church_spotted();
	level.price teleport_actor( getnode( "church_price_node1", "targetname" ) );
	teleport_player( "church" );
	
	flag_set( "initial_setup_done" );
	thread flag_set_delayed( "intro_last_patrol", 2 );
	thread flag_set_delayed( "intro_left_area", .5 );
}

start_graveyard()
{
	start_graveyard_x();
	
	array_thread( getentarray( "tableguards", "script_noteworthy" ), ::add_spawn_function, ::stealth_ai);
	array_thread( getentarray( "tableguards", "script_noteworthy" ), ::add_spawn_function, ::idle_anim_think);
	array_thread( getentarray( "tableguard_last_patrol", "targetname" ), ::add_spawn_function, ::intro_lastguy_think);
	
	delaythread( .1, ::scripted_array_spawn, "tableguards", "script_noteworthy", true );
	delaythread( .1, ::scripted_array_spawn, "intro_dogs", "script_noteworthy", true );
}

start_graveyard_x()
{
	start_common();
	
	door = getent("church_door_front", "targetname");
	door thread door_open_slow();
	
	level.price teleport_actor( getnode( "church_price_backdoor_node", "targetname" ) );
	teleport_player( "graveyard" );
	
	flag_set( "initial_setup_done" );
	thread flag_set_delayed( "graveyard_moveup", 1 );
	//thread music_play( "scoutsniper_pripyat_music" );
}

start_field()
{
	start_common();
	
	level.price teleport_actor( getnode( "price_field_start", "targetname" ) );
	teleport_player();
	
	waittillframeend;//wait for price to have a magic bullet shield before we take it away
	
	flag_set( "initial_setup_done" );
	flag_set( "field" );
}

start_pond()
{
	start_common();
	
	waittillframeend;
	
	trig = getent( "pond_guys_trig", "targetname" );
	trig notify( "trigger" );
	
	level.price teleport_actor( getent( "field_price_clear", "targetname" ) );
	
	waittillframeend;
	
	teleport_player();
	
	flag_set( "initial_setup_done" );
	flag_set( "field_price_done" );
	flag_set( "pond" );
}

start_cargo()
{
	start_common();
	
	trigger_off( "pond_backup", "target" );
	waittillframeend;
	
	level.price teleport_actor( getnode( "cargo_price_node1", "targetname" ) );
	teleport_player();
	
	thread maps\_stealth_behavior::default_event_awareness( ::default_event_awareness_dialogue );
	
	flag_set( "initial_setup_done" );
	flag_set( "cargo" );	
	flag_set( "field_price_done" );	
}

start_dash()
{
	start_common();
		
	level.price teleport_actor( getnode( "dash_price_start_node", "targetname" ) );
	teleport_player();
	
	waittillframeend;//wait for price to have a magic bullet shield before we take it away
	
	thread maps\_stealth_behavior::default_event_awareness( ::default_event_awareness_dialogue );
	
	flag_set( "initial_setup_done" );
	flag_set( "dash" );
}

start_town()
{
	start_common();
		
	trigger_off( "dash_sniper", "target" );
	waittillframeend;
		
	level.price teleport_actor( getnode( "town_moveup_node", "targetname" ) );
	teleport_player();
	
	waittillframeend;//wait for price to have a magic bullet shield before we take it away
	
	flag_set( "initial_setup_done" );
	flag_set( "town" );
}

start_dogs()
{
	start_common();
	
	level.price teleport_actor( getnode( "dogs_moveup_node1", "targetname" ) );
	teleport_player();
	
	flag_set( "initial_setup_done" );
	flag_set( "dogs" );
}

start_center()
{
	start_common();
	
	level.price teleport_actor( getnode( "center_node1", "targetname" ) );
	teleport_player();
	
	flag_set( "initial_setup_done" );
	flag_set( "center" );
}

start_end()
{
	start_common();
	
	level.price teleport_actor( getnode( "center_node_last", "targetname" ) );
	teleport_player();
	
	flag_set( "initial_setup_done" );
	flag_set( "end" );
}

start_common()
{
	initLevel();
	initPlayer();
	initPrice();
	initDogs();
	miscprecache();
	
	thread clean_previous_ai( "field_clean_ai", "patrollers", "script_noteworthy" ); 
	thread clean_previous_ai( "field_clean_ai", "tableguards", "script_noteworthy" ); 
	thread clean_previous_ai( "field_clean_ai", "intro_dogs", "script_noteworthy" ); 
	thread clean_previous_ai( "field_clean_ai", "church_smoker", "script_noteworthy" ); 
	thread clean_previous_ai( "field_clean_ai", "church_lookout", "script_noteworthy" ); 	
	thread clean_corpse( "field_start" );
	
	thread clean_previous_ai( "cargo", "field_guard", "script_noteworthy" );
	thread clean_previous_ai( "cargo", "field_guard2", "script_noteworthy" );
	thread clean_previous_ai( "dash_spawn", "pond_patrol", "script_noteworthy" );
	thread clean_previous_ai( "dash_spawn", "pond_throwers", "script_noteworthy" );
	thread clean_previous_ai( "dash_spawn", "pond_backup", "script_noteworthy" );
	thread clean_previous_ai( "dash_clean_ai", "cargo_smokers", "script_noteworthy" );
	thread clean_previous_ai( "dash_clean_ai", "cargo_patrol_defend1", "script_noteworthy" );
	thread clean_previous_ai( "dash_clean_ai", "cargo_patrol_defend2", "script_noteworthy" );
	thread clean_previous_ai( "dash_clean_ai", "cargo_sleeper", "script_noteworthy" );	
	thread clean_previous_ai( "town_no_turning_back" );//complete clean	
	thread clean_previous_ai( "dogs_delete_dogs" );//complete clean	
				
	array_thread( getentarray( "fake_radiation", "targetname" ), ::fake_radiation );
	
	//this is valid - it turns off the spawning trigger for the dogs sequence
	trigger_off( "dogs_backup", "target" );
	
	//eventually remove these from the map file - these are dash spawners that need to be removed
	trigger_off( "dash_bus_guys", "target" );
	trigger_off( "dash_last_runner", "target" );
	trigger_off( "dash_on_road_guy", "target" );
}

miscprecache()
{
	precacheitem( "flash_grenade" );
	precacheItem( "hind_FFAR" );
	precacheModel( "tag_origin" );
	precacheModel( "com_folding_chair" );
	precacheModel( "vehicle_bm21_mobile_cover" );
	precacheString( &"SCRIPT_ARMOR_DAMAGE" );
	//precacheShader( "overlay_hunted_black" );  
	
	precachestring( &"SCOUTSNIPER_FRIENDLY_FIRE_WILL_NOT" );
	precachestring( &"SCOUTSNIPER_YOUR_ACTIONS_GOT_CPT" );
	precachestring( &"SCOUTSNIPER_LEFT_BEHIND" );
}

initLevel()
{
	level.cosine["180"] = cos(180);
	level.minBMPexplosionDmg = 50;
	level.maxBMPexplosionDmg = 100;
	level.bmpCannonRange = 2048;
	level.bmpMGrange = 850;
	level.bmpMGrangeSquared = level.bmpMGrange * level.bmpMGrange;
	
	thread stealth_achievement();
	
	thread maps\_radiation::main();
	initProneDOF();
	thread updateFog();//should move this into a fcuntion closer to where it happens
	thread player_grenade_check();
	
	battlechatter_off( "allies" );
	battlechatter_off( "axis" );
	
	array_thread( getentarray( "clip_nosight", "targetname" ), ::clip_nosight_logic );
	trigger_off( "field_clean", "script_noteworthy" );
	
	createthreatbiasgroup( "price" );
	createthreatbiasgroup( "dog" );
	setignoremegroup( "price", "dog" );
	
	delaythread( .5, ::initLevel2 );
	
	clip = getent( "doggie_clip", "targetname" );
	clip notsolid();
	clip connectpaths();
	
	hint_setup();
}

initLevel2()
{
	anim.shootEnemyWrapper_func = ::ShootEnemyWrapper_SSNotify;
}

stealth_achievement()
{
	flag_wait( "_stealth_spotted" );
	flag_set( "broke_stealth" );
}

initPlayer()
{
	level.player setthreatbiasgroup( "allies" );
	level.player thread stealth_ai();
	if( getdvar( "consoleGame" ) == "true" || getdvarint("drew_notes") > 2 )
		delaythread(1, ::player_prone_DOF );
	level.player thread player_noprone_water();
}

giveweapons()
{
	level.player enableweapons();
	
}

player_health_shield()
{
	level.player enableHealthShield( false );
	
	while(1)
	{
		level.player waittill("death");
		level.player enableHealthShield(true);
	}	
}

initPrice()
{
	spawner = getent( "price", "script_noteworthy" );
	level.price = spawner dospawn();
	level.price.ref_node = spawn("script_origin", level.price.origin);
	spawn_failed( level.price );
	assert( isDefined( level.price ) );
	
	level.price.fixednode = false;	
	level.price.ignoreall = true;
	level.price.ignoreme = true;
	level.price disable_ai_color();
	
	level.price setthreatbiasgroup( "allies" );
	level.price thread stealth_ai();
	
	level.price.animname = "price";
	level.price thread magic_bullet_shield();
	level.price make_hero();
	level.price thread price_death();
	level.price setthreatbiasgroup( "price" );
	
	level.price thread ShootEnemyWrapper_price();
	
	thread default_corpse_dialogue();
	thread default_spotted_dialogue();
}


#using_animtree("vehicles");
graveyard_hind_detect_damage()
{
	self endon( "death" );
	level endon( "_stealth_spotted" );
	
	body = spawn( "script_model", self.origin );
	body.angles = self.angles;
	body setmodel( self.model );
	body linkto( self );
	self.body = body;
	self hide();
	body useanimtree( #animtree );
	body setanim( %bh_rotors );
	self thread graveyard_hind_kill_body( body );
	
	body setcandamage( true );
	
	body waittill( "damage" );
	
	if( isdefined( self ) )
		self show();
	if( isdefined( body ) )
		body delete();	

	self notify( "enemy" );
	
	wait .25;
		
	self notify( "enemy" );
	
	if( isdefined( body ) )
		body delete();
}

#using_animtree("vehicles");
dash_hind_detect_damage()
{
	self endon( "death" );
	level endon( "_stealth_spotted" );
	
	body = spawn( "script_model", self.origin );
	body.angles = self.angles;
	body setmodel( self.model );
	body linkto( self );
	self.body = body;
	self hide();
	body useanimtree( #animtree );
	body setanim( %bh_rotors );
	self thread graveyard_hind_kill_body( body );
	
	body setcandamage( true );
	
	body waittill( "damage" );
	
	if( isdefined( self ) )
		self show();
	if( isdefined( body ) )
		body delete();	

	flag_set( "_stealth_spotted" );
	
	if( isdefined( body ) )
		body delete();
}
