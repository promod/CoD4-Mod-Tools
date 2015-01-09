//	Wahey!!
/****************************************************************************
Level: 		"There's No Fighting In The War Room" ( launchfacility_b.bsp )
Campaign: 	Marine Force Recon
****************************************************************************/

#include maps\_hud_util;
#include maps\_utility;
#include maps\_anim;
#include common_scripts\utility;
#using_animtree( "generic_human" );

main()

{
	setsaveddvar ( "compassmaxrange", 1200 );
	add_start( "warehouse", ::start_warehouse, &"STARTS_WAREHOUSE" );
	add_start( "launchtubes", ::start_launchtubes, &"STARTS_LAUNCHTUBES" );
	add_start( "vaultdoors", ::start_vaultdoors, &"STARTS_VAULTDOORS" );
	add_start( "controlroom", ::start_controlroom, &"STARTS_CONTROLROOM" ); // Starts at blowing the wall to the control room
	add_start( "escape", ::start_escape, &"STARTS_ESCAPE1" );
	add_start( "elevator", ::start_elevator, &"STARTS_ELEVATOR" );
	
	default_start( ::start_default );

	level thread maps\createart\launchfacility_b_art::main();
	level thread maps\launchfacility_b_fx::main();
	
	level.weaponClipModels = [];
	level.weaponClipModels[0] = "weapon_m16_clip";
	level.weaponClipModels[1] = "weapon_saw_clip";
	level.weaponClipModels[2] = "weapon_ak47_clip";
	level.weaponClipModels[3] = "weapon_mp5_clip";
	level.weaponClipModels[4] = "weapon_g36_clip";

	thread maps\_pipes::main();
	thread maps\_leak::main();
	maps\_load::main();
	maps\_nightvision::main();
	level thread maps\launchfacility_b_amb::main();	
	maps\_c4::main();
	maps\launchfacility_b_anim::main();
	maps\_deadbody::main();
	
	maps\_compass::setupMiniMap ( "compass_map_launchfacility_b" );
		
	createthreatbiasgroup( "player" );
		
	precachemodel ( "com_computer_keyboard_obj" );
	precachemodel ( "com_computer_keyboard" );
	
	precachemodel ( "weapon_c4_obj" );
	precachemodel ( "weapon_c4" );	
	
//  progress bar stuff
	precacheShader ( "white" ); 
    precacheShader ( "black" ); 
    precachestring( &"LAUNCHFACILITY_B_PLANT_THE_C4" );
	precachestring( &"LAUNCHFACILITY_B_GET_TO_THE_TELEMETRY" );
	precachestring( &"LAUNCHFACILITY_B_UPLOAD_THE_ABORT_CODES" );
	precachestring( &"LAUNCHFACILITY_B_BOMBS_GO_BOOM" );
	precachestring( &"LAUNCHFACILITY_B_TIME_TILL_ICBM_IMPACT" );
	precachestring( &"LAUNCHFACILITY_B_HINT_UPLOAD_CODES" );
	precachestring( &"LAUNCHFACILITY_B_FOLLOW_PRICE" );
	precachestring( &"LAUNCHFACILITY_B_INTROSCREEN_LINE_1" );
	precachestring( &"LAUNCHFACILITY_B_INTROSCREEN_LINE_3" );
	precachestring( &"LAUNCHFACILITY_B_INTROSCREEN_LINE_2" );
	precachestring( &"LAUNCHFACILITY_B_INTROSCREEN_LINE_4" );
	precachestring( &"LAUNCHFACILITY_B_INTROSCREEN_LINE_5" );
	precachestring( &"LAUNCHFACILITY_B_UPLOADING_CODES" );
		
		
	battlechatter_off ( "allies" );

// 	progress bar stuff
    level.secondaryProgressBarY = 75;
    level.secondaryProgressBarHeight = 14;
    level.secondaryProgressBarWidth = 152;
    level.secondaryProgressBarTextY = 45;
    level.secondaryProgressBarFontSize = 2;
	
	level.usetimer = true;	
	level.missionFailedQuote = &"LAUNCHFACILITY_B_BOMBS_GO_BOOM";
	
	level.c4 = getent ( "c4", "targetname" );
	level.keyboard = getent ( "keyboard", "targetname" );
	level.elevator_upper = getent ( "elevator_upper", "targetname" );
	
	level.wallExplosionSmall_fx						= loadfx ( "explosions/wall_explosion_small" );
	
	price_spawner = getent ( "price", "script_noteworthy" );
	price_spawner add_spawn_function( ::price_think );
	
	grigsby_spawner = getent ( "grigsby", "script_noteworthy" );
	grigsby_spawner add_spawn_function( ::grigsby_think );
	
	team1_spawner = getent ( "team1", "script_noteworthy" );
	team1_spawner add_spawn_function( ::team1_think );
	
	vent_friendlies_group1_spawner = getentarray ( "vent_friendlies_group1", "script_noteworthy" );
	array_thread ( vent_friendlies_group1_spawner, ::add_spawn_function, ::vent_friendlies_group1_spawner_think );	

	vent_enemies_group1_spawner = getentarray ( "vent_enemies_group1", "script_noteworthy" );
	array_thread ( vent_enemies_group1_spawner, ::add_spawn_function, ::vent_enemies_group1_spawner_think );	
		
	vent_friendlies_group2_spawner = getentarray ( "vent_friendlies_group2", "script_noteworthy" );
	array_thread ( vent_friendlies_group2_spawner, ::add_spawn_function, ::vent_friendlies_group2_spawner_think );	
	
	vent_enemies_group2_spawner = getentarray ( "vent_enemies_group2", "script_noteworthy" );
	array_thread ( vent_enemies_group2_spawner, ::add_spawn_function, ::vent_enemies_group2_spawner_think );	
	
	retreating_enemies_spawner = getentarray ( "gassed_runners", "script_noteworthy" );
	array_thread ( retreating_enemies_spawner, ::add_spawn_function, ::warehouse_retreating_enemies_think );
	


	flag_init ( "aa_countdown_started" );	
	flag_init ( "aa_first_floor" );
	flag_init ( "aa_warehouse" );
	flag_init ( "aa_launchtubes" );
	flag_init ( "aa_blow_the_wall" );
	flag_init ( "aa_upload_them_codes" );
	flag_init ( "aa_follow_price_end_level" );
	
	flag_init ( "speakers_active" );
	flag_init ( "control_room" );
	flag_init ( "location_change_stairs" );
	
	flag_init ( "10min_left" );	
	flag_init ( "8min_left" );	
	flag_init ( "6min_left" );	
	flag_init ( "5min_left" );	
	flag_init ( "4min_left" );	
	flag_init ( "3min_left" );	
	flag_init ( "2min_left" );	
	flag_init ( "1min_left" );	

 	flag_init ( "timer_expired" );
	flag_init ( "countdown_started" );
 	
 	flag_init ( "walk" );
 	flag_init ( "begin_countdown" );
 	flag_init ( "grisby_jump" );
 	flag_init ( "move_faster" );	
 	
 	flag_init ( "start_missile_alarm" );
 	flag_init ( "10sec_till_blastoff" );
 	flag_init ( "price_close_door" );
 	flag_init ( "blast_door_player_clip_on" );
 	flag_init ( "blast_door_player_clip_off" );
 	
	flag_init ( "open_vault_doors" );
	flag_init ( "vault_doors_unlocked" );
 	flag_init ( "vault_door_opened" );
 	
	flag_init ( "update_objectives" );
 	flag_init ( "wall_destroyed" );

	flag_init ( "change_films" );
	flag_init ( "zakhaev_leaving" );
 	flag_init ( "codes_uploaded" );
 	flag_init ( "delete_team2" );
 	
 	flag_init ( "elevator_player_clip_on" );
 	flag_init ( "elevator_dialogue" );
 	
 	flag_init ( "at_the_jeep" );
 	flag_init ( "level_end" );	
 
 	flag_init ( "music_start_countdown" );
 
 	flag_init( "successful_confirmation" );
 
	level thread airduct_fan_large();
	level thread airduct_fan_medium();
 	level thread airduct_fan_small();
 	level thread redlights();
 	level thread redlight_spinner();
 	level thread wall_lights();
 	level thread wall_light_spinner();
 	level thread compass_maps();
 	
	level thread obj_control_room();
 	level thread obj_which_way_to_control_room();
	level thread obj_upload_the_abort_codes();
 	level thread obj_plant_the_c4();
 	
 	level thread countdown_begins();
 	level thread grigsby_countdown_spam();

	level thread vent_trigger_move_out();
	level thread vent_trigger_air_raid_siren();
 	level thread vent_dialogue1();
 	level thread vent_dialogue2();
 	level thread vent_trigger_friendlies_vent_jump();
 	level thread vent_trigger_team1_vent_jump();
 	
 	level thread barracks_dialogue();
 	
 	level thread team1_walk_trigger();
	level thread team1_run_trigger();
	
	level thread hide_triggers_1st_floor();
	
	level thread warehouse_trigger_kill_allied_teammate();
	level thread warehouse_trigger_kill_enemies();
	
	level thread launchtubes_missile_alarm();
	level thread launchtubes_effects();
	level thread launch_tube_dialogue();
	level thread launchtubes_teleport_friendlies();
	level thread rocket_powering_up();

	level thread run_to_the_door();
	level thread in_volume();
	level thread blast_door_clip();
	level thread vault_doors_dialogue();
	
	level thread vault_doors_open();	
	level thread spawn_utility_enemies();
	level thread preparing_to_breach();
	
	level thread control_room_noradscreen();
	level thread spawn_telemetry_enemies();
	level thread spawn_telemetry_friendlies();
	level thread upload_codes();
	level thread control_room_dialogue();
	level thread control_room_bigscreen();
	level thread elevator();
	
	level thread elevator_player_clip();
	level thread elevator_dialogue();
	
	level thread music();
	level thread hide_triggers( "escape" );
	
	level thread vehical_depot();
	level thread end_of_level();
					
// ****** Autosave ****** //
	trigger_array = getentarray ( "autosave","targetname" );
	for ( i=0; i<trigger_array.size; i++)
	{
		 trigger_array[i] thread my_autosave();
	}
}

start_default()
{
	
}

start_warehouse()
{
	flag_set( "begin_countdown" );
	level notify ( "use_start" );
	
	warehouse_price = getent ( "warehouse_price", "targetname" );
	level.price teleport( warehouse_price.origin, warehouse_price.angles );

	warehouse_grigsby = getent ( "warehouse_grigsby", "targetname" );
	level.grigsby teleport( warehouse_grigsby.origin, warehouse_grigsby.angles );

	warehouse_player = getent ( "warehouse_player", "targetname" );
	level.player setorigin ( warehouse_player.origin );
	level.player setplayerangles ( warehouse_player.angles );

	flag_set ( "walk" );
	flag_set ( "move_faster" );
	
	activate_trigger_with_targetname ( "warehouse_color_init" );
	
	wait 1;
	level.team1[0] delete();
}

start_launchtubes()
{
	flag_set( "begin_countdown" );
	level notify ( "use_start" );

	launchtubes_price = getent ( "launchtubes_price", "targetname" );
	level.price teleport( launchtubes_price.origin, launchtubes_price.angles );

	launchtubes_grigsby = getent ( "launchtubes_grigsby", "targetname" );
	level.grigsby teleport( launchtubes_grigsby.origin, launchtubes_grigsby.angles );

	launchtubes_player = getent ( "launchtubes_player", "targetname" );
	level.player setorigin ( launchtubes_player.origin );
	level.player setplayerangles ( launchtubes_player.angles );
	
	flag_set ( "walk" );
	flag_set ( "move_faster" );

	wait 1;
	level.team1[0] delete();	
}

start_vaultdoors()
{
	flag_set( "begin_countdown" );
	level notify ( "use_start" );
		
	vaultdoors_price = getent ( "vaultdoors_price", "targetname" );
	level.price teleport( vaultdoors_price.origin, vaultdoors_price.angles );

	vaultdoors_grigsby = getent ( "vaultdoors_grigsby", "targetname" );
	level.grigsby teleport( vaultdoors_grigsby.origin, vaultdoors_grigsby.angles );

	vaultdoors_player = getent ( "vaultdoors_player", "targetname" );
	level.player setorigin ( vaultdoors_player.origin );
	level.player setplayerangles ( vaultdoors_player.angles );
	
	flag_set ( "walk" );
	flag_set ( "move_faster" );
	flag_set ( "open_vault_doors" );

	level.price set_force_color( "r" );
	activate_trigger_with_targetname ( "setup_for_vault_doors" );
	
	wait 1;
	level.team1[0] delete();	
}

start_controlroom() // Starts at blowing the wall to the control room
{
	flag_set( "begin_countdown" );
	level notify ( "use_start" );
	
	controlroom_price = getent ( "controlroom_price", "targetname" );
	level.price teleport( controlroom_price.origin, controlroom_price.angles );

	controlroom_grigsby = getent ( "controlroom_grigsby", "targetname" );
	level.grigsby teleport( controlroom_grigsby.origin, controlroom_grigsby.angles );

	controlroom_player = getent ( "controlroom_player", "targetname" );
	level.player setorigin ( controlroom_player.origin );
	level.player setplayerangles ( controlroom_player.angles );
	
	flag_set ( "walk" );
	flag_set ( "move_faster" );
	
	level thread hide_triggers( "attacking" );
	activate_trigger_with_targetname ( "protect_the_c4" );
	
	flag_set ( "update_objectives" );
	thread plant_the_c4();	

// spawn good guys
	telemetry_friendlies = getentarray ( "team2", "script_noteworthy" );
	array_thread( telemetry_friendlies, ::spawn_ai ); 
	
	activate_trigger_with_targetname ( "control_room_friendlies_attack" );

	wait 1;
	level.team1[0] delete();
	
// Open the vault doors
	rdoor = getent ( "vault_door_left","targetname" );
	rclip = getent ( rdoor.target, "targetname" );
	rclip linkto ( rdoor );

	ldoor = getent ( "vault_door_right","targetname" );
	lclip = getent ( ldoor.target, "targetname" );
	lclip linkto ( ldoor );
	
	rdoor rotateyaw ( -103, 1, 0, 1 );
	ldoor rotateyaw ( 103, 1, 0, 1 );
	
	rclip connectpaths();
	lclip connectpaths();	
}

start_escape()
{
	level notify ( "use_start" );
	
	level thread hide_triggers( "attacking" );
	
// Open the vault doors
	rdoor = getent ( "vault_door_left","targetname" );
	rclip = getent ( rdoor.target, "targetname" );
	rclip linkto ( rdoor );

	ldoor = getent ( "vault_door_right","targetname" );
	lclip = getent ( ldoor.target, "targetname" );
	lclip linkto ( ldoor );
	
	rdoor rotateyaw ( -103, 1, 0, 1 );
	ldoor rotateyaw ( 103, 1, 0, 1 );
	
	rclip connectpaths();
	lclip connectpaths();
	
// Remove wall
	blasted_wall = getent ( "blasted_wall","targetname" );
	blasted_wall connectpaths();
	exploder(100);

	escape_price = getent ( "escape_price", "targetname" );
	level.price teleport( escape_price.origin, escape_price.angles );

	escape_grigsby = getent ( "escape_grigsby", "targetname" );
	level.grigsby teleport( escape_grigsby.origin, escape_grigsby.angles );

	escape_player = getent ( "escape_player", "targetname" );
	level.player setorigin ( escape_player.origin );
	level.player setplayerangles ( escape_player.angles );
	
	flag_set ( "walk" );
	flag_set ( "move_faster" );
	
// spawn good guys
	telemetry_friendlies = getentarray ( "team2", "script_noteworthy" );
	array_thread( telemetry_friendlies, ::spawn_ai ); 
	
	activate_trigger_with_targetname ( "control_room_friendlies_attack" );

	level thread show_triggers( "escape" );
	thread telemetry_doors_open();
	thread escape_doors_open();
	thread grigsby_warning();
	thread delete_controlroom_friendlies();
	//Price: Roger that. We'll meet you at the vehicle depot! Out! Everyone follow me let's go!
	radio_dialogue ( "vehicledepot" );
	
	thread follow_price();
		
	wait 1;
	level.team1[0] delete();	
}

start_elevator()
{
	level notify ( "use_start" );
	
	//Price: Move! Move!
	level.price anim_single_queue( level.price, "pri_movemove" );
		
	elevator_price = getent ( "elevator_price", "targetname" );
	level.price teleport( elevator_price.origin, elevator_price.angles );

	elevator_grigsby = getent ( "elevator_grigsby", "targetname" );
	level.grigsby teleport( elevator_grigsby.origin, elevator_grigsby.angles );

	elevator_player = getent ( "elevator_player", "targetname" );
	level.player setorigin ( elevator_player.origin );
	level.player setplayerangles ( elevator_player.angles );
	
	flag_set ( "walk" );
	flag_set ( "move_faster" );
	
	level thread show_triggers( "escape" );
	
// Start the elevator stuff
	level.anim_ent = getent ( "tunnel_animent", "targetname" );
	
	level.price thread ai_to_elevator( "r" );
	level.grigsby thread ai_to_elevator( "o" );
 	level.player in_the_elevator();
	level thread elevator_think();
	
	elevator = getent ( "elevator","targetname" );
	level.anim_ent linkto ( elevator );
	
	wait 1;
	level.team1[0] delete();	
}

/////////////////////////////////////////////////////////////////////////////////////////////////////
////		// ****** game play script ****** //																					 ////
/////////////////////////////////////////////////////////////////////////////////////////////////////

my_autosave()
{
    self waittill ( "trigger" );
	assertex( isdefined( self.script_savetrigger_timer ), "savetrigger needs script_timer value" );
    autosave_by_name_wraper ( "save", self.script_savetrigger_timer );
}

get_remaining_seconds()
{
	current_time = gettime();
	elapsed_time = (current_time - level.timer_start_time) / 1000 / 60;

	return ( level.stopwatch - elapsed_time ) * 60;
}

autosave_by_name_wraper( save_name, required_time )
{
	assertex( isdefined( required_time ), "required_time is needed to save" );

	if ( isdefined( level.timer_start_time ) )
	{
		current_time = gettime();
		elapsed_time = (current_time - level.timer_start_time) / 1000 / 60;
			
		remaining_time = level.stopwatch - elapsed_time;
		required_time = required_time * level.requried_time_scale;

		if ( remaining_time < required_time )
			return;
	}
    //autosave_by_name ( save_name );
    autosave_or_timeout( save_name, 12 );
}

/****** Price ******/
price_think()
{
	level.price = self;
	level.price.animname = "price";
	level.price thread magic_bullet_shield();
	
	self thread ai_duct();
}

/****** Grigsby ******/
grigsby_think()
{
	level.grigsby = self;
	level.grigsby.animname = "grigsby";
	level.grigsby thread magic_bullet_shield();

	self thread ai_duct();
}

// ****** The other guys in team1 ****** //
team1_think()
{
	if( !isdefined( level.team1 ) )
		level.team1 = [];

	self.animname = "steve";
	level.team1[ level.team1.size ] = self;
	
	self thread ai_duct();
}

vent_trigger_move_out()
{
	wait 3;
	activate_trigger_with_targetname ( "move_out" );
	
	flag_set ( "aa_first_floor" );
}

vent_trigger_air_raid_siren()
{
	trigger = getent ( "trigger_air_raid", "targetname" );
	trigger waittill ( "trigger" );	
	
	air_raid_siren = getent ( "air_raid", "targetname" );
	air_raid_siren playsound ( "emt_alarm_missile_siren" );
}

vent_dialogue1()
{
	level endon( "use_start" );

	wait 3;
	//Price: All right, let's move!
	radio_dialogue ( "letsmove" );
	
	wait 3;
	//Marine 1: Captain Price this is Five-Delta Six. We're clearing the east wing and heading for base security, over.
	radio_dialogue ( "basesecurity" );
	
	wait 1;
	//Price: Roger Delta Six, we're right above you in the vents, watch your fire.
	radio_dialogue ( "invents" );
	
	//Marine 1: Copy that sir.
	radio_dialogue ( "gm1_copythat" );
	
	wait 1;
	// Russian Loudspeaker: Alert! Enemy forces have entered the base. I repeat, enemy forces have entered the base.
	play_sound_on_speaker ( "launchfacility_b_rul_alert" );
}

vent_dialogue2()
{
	trigger = getent ( "yankee_six_regroup", "script_noteworthy" );
	trigger thread vent_dialogue2_01();
}

vent_dialogue2_01()
{
	self waittill ( "trigger" );	
	//Marine 2:Captain Price, Two-Yankee Six reporting in. We're meeting with heavy resistance in the south wing. They've locked down our access point over here, over.
	radio_dialogue ( "heavyresistance" );
	
	//Price :Roger Yankee Six. Regroup with Team Two and help them gain control of base security, over.
	radio_dialogue ( "gaincontrol" );
	
	//Marine 2:Roger that sir. We're pulling back to regroup with Team Two. Yankee Six out.
	radio_dialogue ( "regroup" );
	
	flag_set ( "begin_countdown" );
}

// Play these dialogue lines when the player reaches the barracks or the kitchen area.
barracks_dialogue()
{
	trigger = getent ( "barracks_warning", "targetname" );
	trigger waittill ( "trigger" );
	
	// Russian Loudspeaker: Enemy forces have been engaged at the barracks. Reinforcements needed at the barracks.
	play_sound_on_speaker ( "launchfacility_b_rul_barracks" );
}

// ****** Have team1 walk or run ****** //
team1_walk_trigger()
{
	trigger = getent ( "team1_walk", "script_noteworthy" );
	trigger waittill ( "trigger" );
		
	flag_set ( "walk" );
}
		 
team1_run_trigger()
{
	trigger = getent ( "team1_run", "script_noteworthy" );
	trigger waittill ( "trigger" );
		
	flag_set ( "move_faster" );
}

// ****** OBJECTIVES ****** //

// ****** 1st Objective, Get to the Telemetry Room, You have about 10 minutes ****** //
obj_control_room()
{
	level endon( "use_start" );
	
	objective_number = 0;
	
	obj_position = getent ( "origin_obj_stairs", "targetname" );
	
	wait 6;
	objective_add(objective_number, "active", &"LAUNCHFACILITY_B_GET_TO_THE_TELEMETRY", obj_position.origin);
	objective_current (objective_number);
	
	flag_wait ( "location_change_stairs" );
	
	obj_position = getent ( "origin_obj_breach_telemetry_room", "targetname" );	
	objective_position( objective_number, obj_position.origin );

	flag_wait ( "control_room" );
	
	wait 1;
	objective_state (objective_number, "done");
} 

obj_which_way_to_control_room()
{
	trigger = getent ( "pointing_to_control_room", "targetname" );
	trigger waittill ( "trigger" );
	
	flag_set ( "location_change_stairs" );
	
	thread obj_player_reached_control_room();
}

obj_player_reached_control_room()
{
	trigger = getent ( "control_room", "targetname" );
	trigger waittill ( "trigger" );
	
	flag_set ( "control_room" );
}

// ****** New Objective: Tell player to plant the c4 and show where to plant it ****** //
obj_plant_the_c4()
{
	flag_wait ( "update_objectives" );

	objective_number = 1;
	
	new_position = getent ( "wall_explosives", "targetname" );
	objective_add(objective_number, "active", &"LAUNCHFACILITY_B_PLANT_THE_C4", new_position.origin);
	objective_current (objective_number);
	
	flag_wait ( "wall_destroyed" );
	
	wait 1;
	objective_state (objective_number, "done");
}

// ****** New Objective: Upload the Abort Codes and show where to upload them****** //
obj_upload_the_abort_codes()
{
	waittill_aigroupcleared ( "control_room" );
	
	//Griggs: Clear!!
	radio_dialogue ( "grg_clearR" );
	
	//Price: Soap, enter the codes! We'll watch for enemy reinforcements.
	radio_dialogue ( "entercodes" );
	
	objective_number = 2;
	
	wait .5;

	obj_position = getent("keyboard_use_trigger", "targetname");
	objective_add(objective_number, "active", &"LAUNCHFACILITY_B_UPLOAD_THE_ABORT_CODES", obj_position.origin);
	objective_current (objective_number);
		
	flag_wait ( "codes_uploaded" );
	str = "Codes uploaded with " + get_remaining_seconds() + " seconds remaining on gameskill " + level.gameskill;
	logstring( str );
	println( "^6" + str );
	
	objective_state ( objective_number, "done" );
	
	if (level.usetimer)
	{
		level thread killTimer();
	}
	
	wait(1);	
}

// ****** New Objective: Follow Cpt. Price to the jeep ****** //
obj_follow_price()
{
	objective_number = 3;
	obj_position = level.price.origin;	
	objective_add ( objective_number, "active", &"LAUNCHFACILITY_B_FOLLOW_PRICE", obj_position );
	objective_current ( objective_number );

	level.price thread lock_obj_location( objective_number );	

	flag_wait ( "at_the_jeep" );
	objective_state ( objective_number, "done" );
	
	level notify ( "unlock_obj" ); 
	
	wait(1);		
}

lock_obj_location( objective_number )
{
	level endon ( "unlock_obj" ); 
	while ( true )
	{
		objective_position( objective_number, self.origin + ( 0, 0, 48 ));
		wait .5;
	}	
}

countdown_begins()
{
	if ( is_default_start() )
	{
		// this should be a flag instead, so it could be set from the start points and not require this extra script.
		wait_for_targetname_trigger( "countdown_start" );
	}
	
	dialogue_line = undefined;

	switch( level.gameSkill )
	{
		case 1:
			level.stopwatch = 11;
			level.requried_time_scale = 1.25;
			dialogue_line = "11mins";
			break;
		case 2:
			level.stopwatch = 11;
			level.requried_time_scale = 1;
			dialogue_line = "11mins";
			break;
		case 3:
			level.stopwatch = 9;
			//level.requried_time_scale = 0.82;
			level.requried_time_scale = 1;
			dialogue_line = "9mins";
			break;
		default:
			level.stopwatch = 15;
			level.requried_time_scale = 1.36;
			dialogue_line = "15mins";
			break;
	}

	flag_wait ( "begin_countdown" );
	
	//HQ: 15, 11 or 9mins
	radio_dialogue ( dialogue_line );
	
	flag_set( "countdown_started" );
	flag_set ( "aa_countdown_started" );
	arcademode_checkpoint( 2, "a" );

	//Price: Copy that!
	radio_dialogue ( "pri_copythat" );

	level thread startTimer();

	flag_set ( "music_start_countdown" );

	level.timer_start_time = gettime();
}

grigsby_countdown_spam()
{
	flag_wait( "countdown_started" );

	if ( level.stopwatch > 10 )
	thread flag_set_delayed( "10min_left", ( level.stopwatch * 60 ) - 602 );
	thread flag_set_delayed( "8min_left", ( level.stopwatch * 60 ) - 482 );
	thread flag_set_delayed( "6min_left", ( level.stopwatch * 60 ) - 362 );
	thread flag_set_delayed( "5min_left", ( level.stopwatch * 60 ) - 302 );
	thread flag_set_delayed( "4min_left", ( level.stopwatch * 60 ) - 242 );
	thread flag_set_delayed( "3min_left", ( level.stopwatch * 60 ) - 182 );
	thread flag_set_delayed( "2min_left", ( level.stopwatch * 60 ) - 122 );
	thread flag_set_delayed( "1min_left", ( level.stopwatch * 60 ) - 62 );
	
 	level thread grigsby_countdown_dialogue();
}

grigsby_countdown_dialogue()
{
	level endon ( "codes_uploaded" );

	flag_wait ( "10min_left" );	
	radio_dialogue ( "grg_10" );
	
	flag_wait ( "8min_left" );
	radio_dialogue ( "grg_8" );
			
	flag_wait ( "6min_left" );
	radio_dialogue ( "grg_6" );

	flag_wait ( "5min_left" );
	radio_dialogue ( "grg_5" );
	
	flag_wait ( "4min_left" );
	radio_dialogue ( "grg_4" );
		
	flag_wait ( "3min_left" );
	radio_dialogue ( "grg_3" );
}

// ****** Get the timer started ****** //
startTimer()
{
// destroy any previous timer just in case ****** //
	killTimer();
	
// destroy timer and thread if objectives completed within limit ****** //
	level endon ( "kill_timer" );
	
	level.hudTimerIndex = 20;

// Timer size and positioning ****** //	
	level.timer = maps\_hud_util::get_countdown_hud();	
	level.timer SetPulseFX( 30, 900000, 700 );//something, decay start, decay duration
  		
	level.timer.label = &"LAUNCHFACILITY_B_TIME_TILL_ICBM_IMPACT";
	level.timer settenthstimer( level.stopwatch * 60 );

// Wait until timer expired
	wait ( level.stopwatch * 60 );
	flag_set ( "timer_expired" );

// Get rid of HUD element and fail the mission 
	level.timer destroy();	
	
	level thread mission_failed_out_of_time();
}

mission_failed_out_of_time()
{
	level.player endon ( "death" );
	level endon ( "kill_timer" );

	level notify ( "mission failed" );	
	setDvar("ui_deadquote", level.missionFailedQuote);
	maps\_utility::missionFailedWrapper();	
}

killTimer()	
{
	level notify ( "kill_timer" );
	if (isdefined (level.timer))
		level.timer destroy();		
}

// ****** Air duct ****** //
ai_duct()
{
	self.flashbangImmunity = true;
	self.interval = 24;
	self allowedstances ( "crouch" );
	
	flag_wait ( "walk" );
	self cqb_walk ( "on" );
	self allowedstances ( "stand", "crouch", "prone" );

	flag_wait ( "move_faster" );
	self cqb_walk ( "off" );
}

vent_friendlies_group1_spawner_think()
{
	self thread magic_bullet_shield();
	self.grenadeAmmo = 0;	
	
	self cqb_walk ( "on" );
	self allowedstances ( "stand", "crouch", "prone" );
	
	waittill_aigroupcleared ( "vent_enemies_group1" );
	activate_trigger_with_targetname ( "vent_friendlies_group1_move" );
	
	self cqb_walk ( "off" );
	
	wait 1;
	self waittill ( "goal" );
	self stop_magic_bullet_shield();
	self delete();	
}

vent_enemies_group1_spawner_think()
{
	self endon ( "death" );
	self.grenadeAmmo = 0;	
	self thread delete_on_damage();
	
	wait 10;
	self delete();		
}

delete_on_damage()
{
	self endon ( "death" );

	self waittill ( "damage" );
	self delete();		
}

vent_friendlies_group2_spawner_think()
{
	self thread magic_bullet_shield();	
	
	waittill_aigroupcleared ( "vent_enemies_group2" );
	activate_trigger_with_targetname ( "vent_friendlies_group2_move" );
	
	wait 1;
	self waittill ( "goal" );
	self stop_magic_bullet_shield();
	self delete();
}

vent_enemies_group2_spawner_think()
{
	self.health =2;	

	wait 10;
	if( isalive( self ) )
		self doDamage( self.health + 100, self.origin );	
}

vent_trigger_friendlies_vent_jump()
{
	trigger = getent ( "price_grigsby_jump", "targetname" );
	trigger waittill ( "trigger" );
	
	thread vent_friendlies_vent_jump();
	thread vent_grisby_vent_jump();
}

vent_trigger_team1_vent_jump()
{
	trigger = getent ( "team1_jump", "targetname" );
	trigger waittill ( "trigger" );
	
	thread vent_team1_vent_jump();
}

vent_friendlies_vent_jump()
{
	flag_set ( "grisby_jump" );
	
	anim_ent = getent ( "vent_jump_animent", "targetname" );
	anim_ent anim_reach_solo ( level.price, "vent_drop_l" );
	anim_ent anim_single_solo ( level.price, "vent_drop_l" );
		
	level.price set_force_color( "r" );
	
	wait .5;
	activate_trigger_with_targetname ( "grigsby_price_setup_shower" );
}

vent_grisby_vent_jump()
{
	flag_wait ( "grisby_jump" );
	
	anim_ent = getent ( "vent_jump_animent", "targetname" );
	anim_ent anim_reach_solo ( level.grigsby, "vent_drop_r" );
	
	wait 1;
	anim_ent anim_single_solo ( level.grigsby, "vent_drop_r" );
	
	level.grigsby set_force_color( "o" );
}

vent_team1_vent_jump()
{
	anim_ent = getent ( "vent_jump_animent", "targetname" );
	anim_ent anim_single_solo ( level.team1[0], "vent_drop_team1" );
	
	level.team1[0] set_force_color( "y" );
	activate_trigger_with_targetname ( "team1_setup_shower" );
}

hide_triggers_1st_floor()
{
	trigger = getent ( "attacking_1st_floor", "targetname" );
	trigger waittill ( "trigger" );
	
	level thread hide_triggers( "attacking_1st_floor" );
	
	flag_clear ( "aa_first_floor" );
	flag_set ( "aa_warehouse" );
	arcademode_checkpoint( 3, "b" );
}

//warehouse_area()//	
warehouse_retreating_enemies_think()
{
	self endon ( "death" );	
	self waittill ( "goal" );
	self delete();		
}

//	Kill the lone allied teammate so I don't have to deal with him for the rest of the level.
warehouse_trigger_kill_allied_teammate()
{
	trigger = getent ( "kill_yellow_allied", "targetname" );
	trigger waittill ( "trigger" );	
	
	if( isalive( level.team1[0] ) )
		level.team1[0] doDamage( level.team1[0].health + 100, level.team1[0].origin );	
}

warehouse_trigger_kill_enemies()
{
	trigger = getent ( "warehouse_killer", "targetname" );
	trigger waittill ( "trigger" );
	
	thread warehouse_kill_all_enemy();

	flag_clear ( "aa_warehouse" );
	flag_set ( "aa_launchtubes" );
	arcademode_checkpoint( 3, "c" );
}

warehouse_kill_all_enemy()
{
	volume = getent ( "killer_warehouse", "targetname" );
	
	enemies = getaiarray( "axis" );
	for( i = 0 ; i < enemies.size ; i++ )
	{
		if ( enemies[ i ] istouching( volume ) )
			enemies[ i ] doDamage( enemies[ i ].health + 1000, enemies[ i ].origin );
	}
}

//launch_tubes()
play_sound_on_speaker( soundalias, interrupt )
{
	speaker_array = getentarray ( "speaker" ,"targetname" );

	if ( isdefined( interrupt ) )
	{
		level notify( "speaker_interrupt" );

		for( i=0; i<speaker_array.size; i++ )
		{
			speaker_array[i] stopsounds();
		}
		wait .5;
	}
	else if ( flag( "speakers_active" ) )
		return;		
		
	level endon( "speaker_interrupt" );
	flag_set( "speakers_active" );

	speaker_array = get_array_of_closest( level.player.origin ,speaker_array, undefined, 2);

	speaker_array[0] playsound( soundalias, "sounddone", true );
	speaker_array[1] playsound( soundalias );
	speaker_array[0] waittill( "sounddone" );

	flag_clear( "speakers_active" );
}

launch_tube_dialogue()
{
	trigger = getent ( "times_running_out", "targetname" );
	trigger waittill ( "trigger" );
	
	// Griggs: We're runnin' outta time. We gotta move.
	radio_dialogue ( "grg_gottamove" );

	level endon( "speaker_interrupt" );

	wait 2;
	// Russian Loudspeaker: Storage area has been compromised. Enemy forces have reached the launch tubes. Sealing primary access door to launch control area.
	play_sound_on_speaker ( "launchfacility_b_rul_storagearea" );

	// Russian Loudspeaker: Primary launch sequence initiated for tubes 3 through 6. Standby.
	play_sound_on_speaker( "launchfacility_b_rul_primaryinititated" );
	
	// Russian Loudspeaker: Secure all missile bays. Fuel lines detached.	
	play_sound_on_speaker( "launchfacility_b_rul_securemissilebay" );
	
	//Griggs: Sir, what's goin' on? What are they sayin'?
	radio_dialogue ( "grg_goinon" );
		
	//Price: They've started a bloody countdown! Zakhaev's going to launch the remaining missiles! Keep moving.
	radio_dialogue ( "startedcountdown" );
}

rocket_powering_up()
{
	trigger = getent ( "rocket_power_up", "targetname" );
	trigger waittill ( "trigger" );
	
	// Russian Loudspeaker: Thirty seconds. Terminal guidance program uploaded.	
	play_sound_on_speaker( "launchfacility_b_rul_30secs" );
	
	wait ( randomfloatrange ( 0.2, 1.2 ) );
	
	while( !flag("blast_door_player_clip_off") )
	{
		earthquake(0.05, 1, level.player.origin, 1024);	
		wait .2;
	}
}

//	Price and team runs to the blast door and Price prepairs to shut the door
launchtubes_teleport_friendlies()
{
	trigger = getent ( "teleport_the_team", "targetname" );
	trigger waittill ( "trigger" );
	
	flag_set ( "10sec_till_blastoff" );
	
	level.player setthreatbiasgroup( "player" );
	setignoremegroup( "allies", "axis" );	// axis ignore allies
	setignoremegroup( "axis", "allies" );	// allies ignore axis

	thread launchtubes_clear();
	
	launchtubes_teleport_price = getent ( "launchtubes_teleport_price", "targetname" );
	level.price notify( "killanimscript" );
	level.price.a.disablePain = true;
	level.price teleport( launchtubes_teleport_price.origin, launchtubes_teleport_price.angles );
	level.price.grenadeawareness = 0;
	
	launchtubes_teleport_grigsby = getent ( "launchtubes_teleport_grigsby", "targetname" );
	level.grigsby notify( "killanimscript" );
	level.grigsby.a.disablePain = true;
	level.grigsby teleport( launchtubes_teleport_grigsby.origin, launchtubes_teleport_grigsby.angles );
	level.grigsby pushplayer( true );
	level.grigsby.grenadeawareness = 0;		

	setsaveddvar("ai_friendlyFireBlockDuration", 0);
	
	flag_set ( "price_close_door" );

	level.grigsby thread guard_the_vaultdoors_grigsby();
	
	flag_set ( "start_missile_alarm" );
	
	thread rocket_powering_up_dialogue();
	
	//Price: Go Go Go!!
	radio_dialogue ( "pri_gogogo1" );	
}

launchtubes_effects()
{
	flag_wait ( "10sec_till_blastoff" );
	exploder( 1 );
}

launchtubes_clear()
{
	volume = getent ( "kill_hallway_enemies", "targetname" );
	
	enemies = getaiarray( "axis" );
	for( i = 0 ; i < enemies.size ; i++ )
	{
		if ( enemies[ i ] istouching( volume ) )
			enemies[ i ] doDamage( enemies[ i ].health + 1000, enemies[ i ].origin );
	}	
}

rocket_powering_up_dialogue()
{
	wait 1;
	
	// Russian Loudspeaker: Ten.
	play_sound_on_speaker( "launchfacility_b_rul_ten", true );
	
	// Russian Loudspeaker: Nine.
	play_sound_on_speaker( "launchfacility_b_rul_nine" );
		
	// Russian Loudspeaker: Eight.
	play_sound_on_speaker( "launchfacility_b_rul_eight" );
	
	// Russian Loudspeaker: Seven.
	play_sound_on_speaker( "launchfacility_b_rul_seven" );
		
	// Russian Loudspeaker: Six.
	play_sound_on_speaker( "launchfacility_b_rul_six" );
		
	// Russian Loudspeaker: Five.
	play_sound_on_speaker( "launchfacility_b_rul_five" );
		
	wait .3;
	// Russian Loudspeaker: Four.
	play_sound_on_speaker( "launchfacility_b_rul_four" );
		
	wait .3;
	// Russian Loudspeaker: Three.
	play_sound_on_speaker( "launchfacility_b_rul_three" );
		
	wait .3;
	// Russian Loudspeaker: Two.
	play_sound_on_speaker( "launchfacility_b_rul_two" );
		
	wait .3;
	// Russian Loudspeaker: One.
	play_sound_on_speaker( "launchfacility_b_rul_one" );
	
	// Russian Loudspeaker: Ignition. Launch sequence complete.
	play_sound_on_speaker( "launchfacility_b_rul_launchcomplete" );	

	wait 1;
	thread kill_player_in_tubes();
}	
	
launchtubes_missile_alarm()
{
	flag_wait ( "start_missile_alarm" );
	missile_warning = getent ( "alarm_missile_warning", "targetname" );
	missile_warning playsound ( "emt_alarm_missile_warning" );
}

in_volume()
{
    trigger = getent ( "shut_blast_door", "targetname" );

    while ( true )
    {
        trigger waittill ( "trigger" );
   
        allies = getaiarray ( "allies" );
        count = 0;
        for ( i=0; i<allies.size; i++ )
        {
            if ( allies[i] istouching( trigger ) )
                count++;
        }
        if ( count == allies.size )
            return;
    }
}

run_to_the_door()
{	
	level thread guard_the_vaultdoors();

	anim_ent = getent( "close_blastdoor_animent", "targetname" );

	door = getent( "blast_door_slam", "targetname" );

	blastdoor_clip = getent ( "blast_door_col", "targetname" );
	blastdoor_clip linkto ( door, "hinge_jnt", (0,0,0), (0,0,0) );

	volume = getent ( "shut_blast_door", "targetname" );

	wait 2;

	door.animname = "door";
	door SetAnimTree();
	anim_ent anim_first_frame_on_guy( door, "blast_door_close", anim_ent.origin, anim_ent.angles );
	
	wait 2;

	flag_wait( "price_close_door" );

	anim_ent anim_reach_solo( level.price, "blast_door_runto" );
	anim_ent anim_single_solo( level.price, "blast_door_runto" );
	
	anim_ent thread anim_loop_solo( level.price, "blast_door_wave", undefined, "stop_idle" );
	thread price_warning();
	
	level.player in_volume();
	anim_ent notify ( "stop_idle" );

	flag_set ( "blast_door_player_clip_on" );
	flag_set ( "walk" );
	
	actors = [];
	actors[0] = door;
	actors[1] = level.price;
	
	level thread launchtubes_hatch_close_sound();
	anim_ent anim_single( actors, "blast_door_close" );	
	
	flag_set ( "blast_door_player_clip_off" );
	flag_set ( "open_vault_doors" );
	
	switch( level.gameSkill )
	{
		case 1:
			autosave_by_name_wraper ( "escaped_the_silos", 3.25 );
			break;
		case 2:
			autosave_by_name_wraper ( "escaped_the_silos", 3.5 );
			break;
		case 3:
			autosave_by_name_wraper ( "escaped_the_silos", 3 );
			break;
		default:
			autosave_by_name_wraper ( "escaped_the_silos", 3.75 );
			break;
	}
	
	level thread hide_triggers( "kill_tube_volume" );
	level thread kill_enemy_in_tubes();
	
	blastdoor_clip disconnectPaths();
}
	
price_warning()
{
	//Price: Move! Move!
	radio_dialogue ( "pri_movemove" );		
}

launchtubes_hatch_close_sound()
{
	wait .5;
	level.price playsound ( "scn_door_launchb_hatch_close" );
	level.player playsound ( "scn_launchb_missile_launch" );
	exploder( 2 ); //launchtube fire fx
	stop_exploder( 1 );
	
	level thread fireballdlight();
	level thread kill_launchtube_steam_fx();
	thread rockets_launch();
}

//	trigger launch of the rockets	
rockets_launch()
{
	intensity = .15;
        
        while( intensity > 0 )
		{
		earthquake(intensity, .1, level.player.origin, 256);
		wait .1;
		intensity -= .001;       	
		}
}

fireballdlight()
{
	movetime = 2;
    tag_ent = spawn( "script_model", ( 395.177, 2955.42, -300.614) );
    tag_ent setmodel( "tag_origin" );
    playfxontag ( level._effect["launchtube_fire_light"], tag_ent, "tag_origin");
    tag_ent moveto( ( -524, 3898, -292 ), movetime, 0, 1 );
    
    wait movetime;
    tag_ent delete();
}

//	kill the player if he is in the still in the tubes
kill_player_in_tubes()
{		
	volume = getent ( "kill_player_tubes", "targetname" );
	
	if ( level.player istouching( volume ) )
	{
		level.player playsound ( "scn_launchb_missile_launch" );
		level.player enableHealthShield ( false );
		level.player thread player_death_effect();
		wait 1;
		level.player doDamage ( level.player.health + 1000, level.player.origin );
	}	
}

player_death_effect()
{
	player = getent( "player", "classname" );
	playfx ( level._effect["player_death_explosion"], player.origin );

	earthquake( 1, 1, level.player.origin, 100 );
}

kill_launchtube_steam_fx()
{
	
	launchtube_steamfx	 = getfxarraybyID( "steam_jet_med_loop" );
	launchtube_steamfx 	 = array_combine( launchtube_steamfx, getfxarraybyID( "hallway_steam_loop" ) );
	launchtube_steamfx 	 = array_combine( launchtube_steamfx, getfxarraybyID( "steam_jet_med_loop_rand" ) );

	for ( i = 0; i < launchtube_steamfx.size; i++ )
		launchtube_steamfx[ i ] pauseEffect();
}

blast_door_clip()
{
	blast_door_player_clip = getent ( "blast_player_clip","targetname" );
	blast_door_player_clip notsolid();

	flag_wait ( "blast_door_player_clip_on" );
	blast_door_player_clip solid();
	
	flag_wait ( "blast_door_player_clip_off" );
	blast_door_player_clip notsolid();
}

kill_enemy_in_tubes()
{
	volume = getent ( "killer_tubes", "targetname" );
	
	enemies = getaiarray( "axis" );
	for( i = 0 ; i < enemies.size ; i++ )
	{
		if ( enemies[ i ] istouching( volume ) )
			enemies[ i ] doDamage( enemies[ i ].health + 1000, enemies[ i ].origin );
	}
}

guard_the_vaultdoors()
{
	anim_ent = getent( "guard_vaultdoors", "targetname" );	

	flag_wait( "open_vault_doors" );

	actors[0] = level.price;
	actors[1] = level.grigsby;

	anim_ent anim_reach( actors, "guard_vaultdoors" );
	anim_ent anim_single( actors, "guard_vaultdoors" );
}

guard_the_vaultdoors_grigsby()
{
	level endon( "open_vault_doors" );
	anim_ent = getent( "guard_vaultdoors", "targetname" );	
	anim_ent anim_reach_and_approach_solo( level.grigsby, "guard_vaultdoors" );
	anim_ent anim_first_frame_solo( level.grigsby, "guard_vaultdoors" );
}

vault_doors_dialogue()
{
	flag_wait ( "open_vault_doors" );
	
	wait 3;
	// Gaz: Captain Price, Delta Six. We've taken control of base security. What's your status over?
	radio_dialogue ( "controlbasesec" );
	
	// Price:Team Two, we're in position. Open the outer door to launch control. 
	level.price anim_single_queue( level.price, "pri_atdoor" );
		
	// Gaz: Workin on it.
	radio_dialogue ( "workinonit" );
	
	wait 2;
	// Gaz: Standby. Almost there.
	radio_dialogue ( "almostthere" );
	
	wait 2;
	// Gaz: Got it. Doors are coming online now.
	radio_dialogue ( "gotit" );
	
	thread vault_doors_team_ready();
		
	wait .5;
	flag_set( "vault_doors_unlocked" );
	
	wait 8;
	// Griggs: Oh, you gotta be shittin' me.
	level.grigsby anim_single_queue( level.grigsby, "grg_shittinme" );
	
	// Price: Got it. Gaz, can't you make it open faster?
	radio_dialogue ( "pri_faster" );
	
	// Gaz: Negative sir. But you can try pulling if it'll make you feel better.
	radio_dialogue ( "gm1_trypulling" );
	
	// Price: Cheeky bastard...
	radio_dialogue ( "pri_cheeky" );
	
	//autosave_by_name_wraper ( "Vault doors are opening", 3 );
	
	switch( level.gameSkill )
	{
		case 1:
			autosave_by_name_wraper ( "vault_doors_are_opening", 2.4 );
			break;
		case 2:
			autosave_by_name_wraper ( "vault_doors_are_opening", 2.75 );
			break;
		case 3:
			autosave_by_name_wraper ( "vault_doors_are_opening", 2.1 );	
			break;
		default:
			autosave_by_name_wraper ( "vault_doors_are_opening", 2.4 );
			break;
	}
	
	setsaveddvar("ai_friendlyFireBlockDuration", 2000);
	
	level.price.a.disablePain = false;
	level.price.grenadeawareness = 0.9;
	
	level.grigsby.a.disablePain = false;
	level.grigsby.grenadeawareness = 0.9;
	
	setthreatbias( "allies", "axis", 0 ); 	// axis hate allies 
	setthreatbias( "axis", "allies", 0 );	// allies hate axis
}

// ****** Open the big Vault Doors ****** //
vault_doors_open()
{
	flag_wait ( "vault_doors_unlocked" );
	
	rdoor = getent ( "vault_door_left","targetname" );
	rclip = getent ( rdoor.target, "targetname" );
	rclip linkto ( rdoor );

	rdoor playsound ( "scn_vault_door_open" );	// Sound of gearworks and door unlocking
	
	ldoor = getent ( "vault_door_right","targetname" );
	lclip = getent ( ldoor.target, "targetname" );
	lclip linkto ( ldoor );

	wait 1;
	rdoor rotateyaw ( -.3, .05 );
	ldoor rotateyaw ( .3, .05 );
	
	rdoor playsound ( "mtl_steam_pipe_burst" ); // Sound of the seal breaking and the doors break free
	ldoor playsound ( "expl_steam_pipe_body" ); // Sound of the seals breaking 
	
	wait 1;
	rdoor playsound ( "expl_steam_pipe_body" ); // Sound of the seals breaking 
	
	wait 2;
	ldoor playsound ( "expl_steam_pipe_body" ); // Sound of the seals breaking 
	rdoor playsound ( "gate_open" ); 			  // Sound of the vault doors opening very slowly
	
	rdoor rotateyaw ( -50, 40, 0, 40 );
	ldoor rotateyaw ( 50, 40, 0, 40 );
	
	wait 20;
	rdoor rotateyaw ( -50, 30, 0, 30 );
	ldoor rotateyaw ( 50, 30, 0, 30 );

//	autosave_by_name_wraper ( "Vault doors are opening", 3 );
	flag_clear ( "aa_launchtubes" );
	arcademode_checkpoint( 5, "d" );
	
	flag_set ( "vault_door_opened" );
	flag_set ( "move_faster" );
	flag_set ( "aa_blow_the_wall" );

	rclip connectpaths();
	lclip connectpaths();
}

// when the vaults doors unlock, Price and Griggs ready themselves for the fight.	
vault_doors_team_ready()
{
	level.price set_force_color( "r" );
	level.grigsby set_force_color( "o" );
	activate_trigger_with_targetname ( "setup_for_vault_doors_opening" );
}

spawn_utility_enemies()	
{
	flag_wait ( "vault_door_opened" );
	
	utility_enemies = getentarray ( "utility_enemies", "script_noteworthy" );
	array_thread ( utility_enemies, ::spawn_ai ); 
	
	thread blow_the_wall_dialogue();	
}

preparing_to_breach()
{		
	level.player endon ( "death" );	
	
	waittill_aigroupcleared ( "utility_badies" );
	level thread hide_triggers( "attacking" );
	
	activate_trigger_with_targetname ( "protect_the_c4" );
}
	
blow_the_wall_dialogue()
{
	trigger = getent ( "plant_explosives_dialogue", "targetname" );
	trigger waittill ( "trigger" );
	
	// Price: Team Three, what's your status, over?
	radio_dialogue ( "status" );
	
	// Marine 2: Team Three in position, at the southeast side of the launch control room. Standing by. Are you at the far wall over?
	radio_dialogue ( "gm2_inposition" );
	
	// Price: Affirmative. Preparing to breach. Soap - plant the explosives, go!
	radio_dialogue ( "pri_plantexplos" );
	
	flag_set ( "update_objectives" );
	thread plant_the_c4();	
	
	switch( level.gameSkill )
	{
		case 1:
			autosave_by_name_wraper ( "time_to_breach_war_room", 1 );
			break;
		case 2:
			autosave_by_name_wraper ( "time_to_breach_war_room", 1.15 );
			break;
		case 3:
			autosave_by_name_wraper ( "time_to_breach_war_room", 0.75 );
			break;
		default:
			autosave_by_name_wraper ( "time_to_breach_war_room", 1.3 );
			break;
	}
}

plant_the_c4()	
{		
	level.player endon ( "death" );	
	
	c4 = getent ( "wall_explosives", "targetname" );
	c4 maps\_c4::c4_location( undefined, (0,0,0) , (0,0,0), c4.origin ); 
	c4 waittill ( "c4_planted" );
	
	activate_trigger_with_targetname ( "take_cover" );
	
	c4 waittill ( "c4_detonation" );
	
	thread blow_the_wall();
}

blow_the_wall()
{
	blasted_wall = getent ( "blasted_wall","targetname" );
	blasted_wall connectpaths();
	
	exploder(100);
	explosives = getent ( "wall_explosives", "targetname" );
	playfx (level.wallExplosionSmall_fx, explosives.origin);
	thread play_sound_in_space ( "detpack_explo_metal", explosives.origin );
	radiusdamage ( explosives.origin, 256, 200, 50 );
	earthquake ( 0.4, 1, explosives.origin, 1000 );

	flag_set( "wall_destroyed" );
	flag_clear ( "aa_blow_the_wall" );
	flag_set ( "aa_upload_them_codes" );
	
	wait 1;
	activate_trigger_with_targetname ( "breaching_control_room" );
	
	//Price: Move in!.
	radio_dialogue ( "pri_gogogo2" );
	
	// Marine 2: Moving in.
	radio_dialogue ( "movingin" );
}	

//	control_room	// 
spawn_telemetry_enemies()	
{
	flag_wait ( "wall_destroyed" );
	
	telemetry_enemies = getentarray ( "telemetry_enemies", "script_noteworthy" );
	array_thread( telemetry_enemies, ::spawn_ai ); 	
}
	
//	team2 spawning	
spawn_telemetry_friendlies()	
{
	telemetry_friendlies = getentarray ( "team2", "script_noteworthy" );
	array_thread ( telemetry_friendlies, ::add_spawn_function, ::telemetry_friendlies_think );	

	flag_wait ( "wall_destroyed" );
	
	array_thread( telemetry_friendlies, ::spawn_ai ); 
	
	activate_trigger_with_targetname ( "control_room_friendlies_attack" );
}

telemetry_friendlies_think()
{
	self endon ( "death" );
	self thread magic_bullet_shield();
	
	flag_wait ( "delete_team2" );
	self stop_magic_bullet_shield();
	self delete();
}

upload_codes()
{
	keyboard_use_trigger = getent ( "keyboard_use_trigger", "targetname" );
	keyboard_use_trigger trigger_off();
	
	waittill_aigroupcleared ( "control_room" );
	
    interval = .05;
    timesofar = 0;
    planttime = 3;

	keyboard_use_trigger trigger_on();
	keyboard_use_trigger sethintstring( &"LAUNCHFACILITY_B_HINT_UPLOAD_CODES" );
	keyboard_use_trigger usetriggerrequirelookat();

	keyboard_to_use = spawn( "script_model", level.keyboard.origin );
	keyboard_to_use.angles = (0, 315, 0);
	keyboard_to_use setmodel( "com_computer_keyboard_obj" );

    while ( true )
    {
    
        keyboard_use_trigger waittill ( "trigger" );
		level.player disableweapons();
        level.player freezeControls( true );

		level.player playsound ( "scn_enter_code_typing" );

        // set hint string on trigger

        keyboard_use_trigger trigger_off();

        level.player startProgressBar( planttime );

        // change to localized string
        level.player.progresstext settext( &"LAUNCHFACILITY_B_UPLOADING_CODES" );

        success = false;
        
        while ( true )
        {
            if (!level.player useButtonPressed())
                break;

            timesofar += interval;
            level.player setProgressBarProgress(timesofar / planttime);

            if (timesofar >= planttime)
            {
                success = true;
                break;
            }
            wait interval;
        }

        level.player endProgressBar();

        if ( success )
            break;

        // give information that input failed.
        level.player stopsounds ( "scn_enter_code_typing" );
        keyboard_use_trigger trigger_on();
		level.player freezeControls( false );
        level.player enableweapons();
    }
	
	level.player enableweapons();	
	level.player freezeControls( false );
	
    level.player stopsounds ( "scn_enter_code_typing" );
    
	keyboard_use_trigger delete();
	keyboard_to_use delete();
	
	keyboard_switched = spawn( "script_model", level.keyboard.origin );
	keyboard_switched.angles = (0, 315, 0);
	keyboard_switched setmodel( "com_computer_keyboard" );

	flag_set ( "codes_uploaded" );
	flag_clear ( "aa_countdown_started" );
	flag_clear ( "aa_upload_them_codes" );
	autosave_by_name ( "Codes have been uploaded" );
	arcademode_checkpoint ( 4, "e" );
}

startProgressBar(planttime)
{
    // show hud elements
    self.progresstext = createSecondaryProgressBarText();
    self.progressbar = createSecondaryProgressBar(); }

setProgressBarProgress(amount)
{
    if (amount > 1)
        amount = 1;
    
    self.progressbar updateBar(amount);
}

endProgressBar()
{
    self notify("progress_bar_ended");
    self.progresstext destroyElem();
    self.progressbar destroyElem();
}

// should be moved to _hud.gsc
createSecondaryProgressBar()
{
    bar = createBar( "white", "black", level.secondaryProgressBarWidth, level.secondaryProgressBarHeight );
    bar setPoint("CENTER", undefined, 0, level.secondaryProgressBarY);
    return bar;
}

// should be moved to _hud.gsc
createSecondaryProgressBarText()
{
    text = createFontString("default", level.secondaryProgressBarFontSize);
    text setPoint("CENTER", undefined, 0, level.secondaryProgressBarTextY);
    return text;
}

control_room_dialogue()
{
	flag_wait ( "codes_uploaded" );
	level thread show_triggers ( "escape" );
	thread telemetry_doors_open();
	thread escape_doors_open();
	thread grigsby_warning();
	thread delete_controlroom_friendlies();
	
	//HQ: Standby for confirmation.
	radio_dialogue ( "hqr_confirm" );
	
	wait 2;
	
	//HQ: Standby...standby...
	radio_dialogue ( "hqr_standby" );
	
	wait 1;
	
	flag_set( "successful_confirmation" );

	//HQ: Bravo Six, all warheads have been confirmed destroyed in flight. We got a ton of debris, but most of it's landing in the ocean.
	radio_dialogue ( "hqr_confdest" );

	flag_set( "zakhaev_leaving" );
	
	//Marine 2: Sir, check the security feed! It's Zakhaev. He's takin' off!
	radio_dialogue ( "checkfeed2" );

	//Gaz: Captain Price, this is Gaz at the security station. They came in by trucks. I'm thinking we can all use them to get the hell outta here. I'm sending you the coordinates to the vehicle depot.
	radio_dialogue ( "sendcoordinates" );

	//Price: Roger that. We'll meet you at the vehicle depot! Out!
	radio_dialogue ( "vehicledepot" );
	
	thread follow_price();
	
	//Price: Everyone follow me let's go!
	radio_dialogue ( "pri_outtahere" );
	
	flag_set ( "aa_follow_price_end_level" );
	
	//HQ: All teams this is Command, recommend you exfil from the area immediately. Large numbers of hostile forces are converging on your position. Get outta there now.
	radio_dialogue ( "exfilfromarea" );
}

control_room_noradscreen()
{
	flag_wait ( "change_films" );
	
	noradscreen = getent ( "noradscreen","targetname" );
	noradscreen delete();
}
	
control_room_bigscreen()
{
	flag_wait ( "zakhaev_leaving" );
	flag_set ( "change_films" );
	
	setsaveddvar( "cg_cinematicFullScreen", "0" );
	CinematicInGame ( "zakhaev_escape" );
}	

telemetry_doors_open()
{
	trigger = getent ( "open_telemetry_door", "targetname" );
	trigger waittill ( "trigger" );

	telemetry_room_door = getent ( "telemetry_room_door","targetname" );
	
	telemetry_room_door rotateyaw ( -70, 1, 1, 0 );	
	telemetry_room_door playsound ( "gate_open" ); 			  // Sound of the vault doors opening very slowly	
	
	telemetry_room_door connectpaths();
}

escape_doors_open()
{
	trigger = getent ( "open_escape_door", "targetname" );
	trigger waittill ( "trigger" );
	
	escape_door_right = getent ( "escape_door_right" ,"targetname" );
	moveto_place = getent ( escape_door_right.target, "targetname" );

	escape_door_right moveto ( moveto_place.origin, 3, 1, 2 );
	escape_door_right connectpaths();
}

//	Escape... Good Job, Now lets get to the jeeps!
follow_price()
{	
	activate_trigger_with_targetname ( "escape" );
	level thread obj_follow_price();
	
	autosave_by_name ( "let's get out of here" );	
	
	waittill_aigroupcleared ( "hallway_escape" );
	activate_trigger_with_targetname ( "escape_hallway" );
}

grigsby_warning()
{
	incoming_enemies = getent ( "incoming_enemy", "script_noteworthy" );
	incoming_enemies waittill ( "spawned" );
	
	wait 1;
	
	//Griggs: WE GOT COMPANYYYY!!!!! Enemy reinforcements movin' in!
	level.grigsby anim_single_queue( level.grigsby, "grg_company" );
}

delete_controlroom_friendlies()
{
	trigger = getent ( "delete_team2", "targetname" );
	trigger waittill ( "trigger" );	
	
	flag_set ( "delete_team2" );
}

elevator()
{
	waittill_aigroupcleared ( "elevator" );
	
	//Price: Move! Move!
	level.price anim_single_queue( level.price, "pri_movemove" );
	
	level.anim_ent = getent ( "tunnel_animent", "targetname" );
	
	level.price thread ai_to_elevator( "r" );
	level.grigsby thread ai_to_elevator( "o" );
 	level.player in_the_elevator();
	level thread elevator_think();
	
	elevator = getent ( "elevator","targetname" );
	level.anim_ent linkto ( elevator );
}	

elevator_player_clip()
{
	elevator_player_clip = getent ( "elevator_player_clip","targetname" );
	elevator_player_clip notsolid();

	flag_wait ( "elevator_player_clip_on" );
	elevator_player_clip solid();
}

ai_to_elevator( color )
{
	level.anim_ent anim_reach_solo ( self, "elevator_runin" );
	level.anim_ent anim_single_solo ( self, "elevator_runin" );
	level.anim_ent thread anim_loop_solo ( self, "elevator_idle", undefined, "stop_idle" );
	self linkto ( level.anim_ent );
	
	trigger = getent ( "elevator_top", "targetname" );
	trigger waittill ( "trigger" );

	wait 2;
	self unlink ( level.anim_ent );
	level.anim_ent notify ( "stop_idle" );
	level.anim_ent anim_single_solo( self, "elevator_runout" );
	
	self set_force_color( color );
}
	
in_the_elevator()
{
    trigger = getent ( "standing_in_elevator", "targetname" );

    while ( true )
    {
        trigger waittill ( "trigger" );
        if ( level.price istouching( trigger ) && level.grigsby istouching( trigger ) )
			return;
    }
}

linkto_elevator( elevator )
{
	self linkto ( elevator );
}

elevator_think()
{	
	flag_set ( "elevator_player_clip_on" );
	
	elevator = getent ( "elevator","targetname" );
	
	lights = getentarray ( "elevator_lights", "targetname" );
	array_thread ( lights,::linkto_elevator, elevator );

	level.elevator_door_inner_top = getent ( "elevator_door_inner_top", "targetname" );
	level.elevator_door_inner_top linkto ( elevator );

	level.elevator_door_inner_bottom = getent ( "elevator_door_inner_bottom", "targetname" );
	elevator_door_inner_bottom = getent ( "elevator_door_inner_bottom","targetname" );
	elevator_door_inner_bottom movez ( -102, 2, 1, 1 );
	elevator_door_inner_bottom playsound ( "scn_elevator_door_close" );	// Sound of elevator door closing/opening

	elevator_door_inner_bottom waittill ( "movedone" );
	level.elevator_door_inner_bottom linkto ( elevator );

	elevator_door_outside1_bottom = getent ( "elevator_door_outside1_bottom","targetname" );
	moveto_place = getent ( elevator_door_outside1_bottom.target, "targetname" );
	elevator_door_outside1_bottom moveto ( moveto_place.origin, 2, 1, 1 );
	
	elevator_door_outside2_bottom = getent ( "elevator_door_outside2_bottom","targetname" );
	moveto_place = getent ( elevator_door_outside2_bottom.target, "targetname" );
	elevator_door_outside2_bottom moveto ( moveto_place.origin, 2, 1, 1 );

		
	elevator_door_outside1_bottom waittill ( "movedone" );

	elevator moveto ( level.elevator_upper.origin, 15, .5, .10 );
	elevator playsound ( "scn_elevator_move" );	// Sound of elevator moving up

	flag_set ( "elevator_dialogue" );
	
	elevator waittill ( "movedone" );
	
	autosave_by_name( "On our way" );
	arcademode_checkpoint ( 3, "f" );
	
	level.elevator_door_inner_top = getent ( "elevator_door_inner_top", "targetname" );	
	level.elevator_door_inner_top unlink ( elevator );

	level.elevator_door_inner_top = getent ( "elevator_door_inner_top", "targetname" );
	elevator_door_inner_top = getent ( "elevator_door_inner_top","targetname" );
	elevator_door_inner_top movez ( 102, 2, 1, 1 );
	elevator_door_inner_top connectpaths();
	elevator_door_inner_top playsound ( "scn_elevator_door_open" );	// Sound of elevator door closing/opening

	elevator_door_inner_top waittill ( "movedone" );
	elevator_door_outside1_top = getent ( "elevator_door_outside1_top","targetname" );
	moveto_place = getent ( elevator_door_outside1_top.target, "targetname" );
	elevator_door_outside1_top moveto ( moveto_place.origin, 2, 1, 1 );
	elevator_door_outside1_top connectpaths();

	elevator_door_outside2_top = getent ( "elevator_door_outside2_top","targetname" );
	moveto_place = getent ( elevator_door_outside2_top.target, "targetname" );
	elevator_door_outside2_top moveto ( moveto_place.origin, 2, 1, 1 );
	elevator_door_outside2_top connectpaths();
}

elevator_dialogue()
{
	flag_wait ( "elevator_dialogue" );
	
	gaz_spawner = getent ( "the_gaz_man", "script_noteworthy" );
    gaz_spawner add_spawn_function( ::protect_gaz );
	
	wait 1.5;
	//Gaz: This is Gaz. We're takin' some fire up here at the vehicle depot. Where the hell are you guys?
	radio_dialogue ( "takinfire" );
	
	//Price: We're coming up the lift. Standby.
	radio_dialogue ( "upthelift" );	
	
	wait 1;
	//Griggs: You know sir, I wouldn't mind gettin' a shot at Zakhaev.
	level.grigsby anim_single_queue( level.grigsby, "grg_ashot" );
	
	//Price: Yeah...well, get in line mate...if he doesn't find us first...
	level.price anim_single_queue( level.price, "pri_getinline" );
}

protect_gaz()
{
	self thread magic_bullet_shield();
}

// ****** End of Level ****** //
vehical_depot()
{
	waittill_aigroupcleared ( "garage" );
	
	flag_set ( "at_the_jeep" );
	
	wait 1.5;
	//Price: All right, get in the trucks! Let's go!
	radio_dialogue ( "letsgo" );
	
	//Griggs: You heard the man! Move!
	radio_dialogue ( "grg_move" );
	
	flag_set ( "level_end" );
	flag_clear ( "aa_follow_price_end_level" );
	arcademode_checkpoint ( 2, "g" );
}

end_of_level()
{
	flag_wait ( "level_end" );

	nextmission();
}

// ****** Misc ****** //

compass_maps()
{
	trigger_upper = getent ( "compass_map_upper", "targetname" );	
	trigger_lower = getent ( "compass_map_lower", "targetname" );	
	
	trigger_upper thread map_change( "compass_map_launchfacility_b" );
	trigger_lower thread map_change( "compass_map_launchfacility_b_2" );
}

map_change( compass_map_name )
{
	while( 1 )
	{
			self waittill( "trigger" );
			maps\_compass::setupMiniMap( compass_map_name );
	}
}

#using_animtree("animated_props");
airduct_fan_large()
{
	fan = getent ( "airduct_fan_large","targetname" );
	fan useanimtree ( #animtree );	

	fan setanim ( %ICBM_turbofan176_spin, 1, 0.1, 1 );
}

airduct_fan_medium()
{
	medium_fans = getentarray ( "airduct_fan_medium","targetname" );
	array_thread( medium_fans, ::medium_fans_think );
}
	
medium_fans_think()
{	
	self useanimtree ( #animtree );
	self setanim( %ICBM_turbofan64_spin, 1, 0.1, 1.5 );
	
}
airduct_fan_small()
{
	small_fans = getentarray ( "airduct_fan_small","targetname" );
	array_thread( small_fans, ::small_fans_think );
}
	
small_fans_think()
{	
	self useanimtree ( #animtree );
	self setanim( %ICBM_turbofan50_spin, 1, 0.1, 3 );
	
} 

redlights()
{
	light = getentarray ( "redlight","targetname" );
	array_thread( light, ::redlights_think );
}

redlights_think()
{
	time = 5000;

	while( true )
	{
		self rotatevelocity((0,360,0), time);           
		wait time;
	}
}

redlight_spinner()
{
	horizonal_spinners = getentarray ( "horizonal_spinner","targetname" );
	array_thread( horizonal_spinners, ::horizonal_spinners_think );
}
	
horizonal_spinners_think()
{	
	self useanimtree ( #animtree );
	self setanim( %launchfacility_b_emergencylight, 1, 0.1, 1.0 );
} 

wall_lights()
{
	light = getentarray ( "wall_light","targetname" );
	array_thread( light, ::wall_lights_think );
}

wall_lights_think()
{
	time = 5000;
	
	while( true )
	{
		self rotatevelocity((360,0,0), time);           
		wait time;
	}
} 

wall_light_spinner()
{
	vertical_spinners = getentarray ( "vertical_spinner","targetname" );
	array_thread( vertical_spinners, ::vertical_spinners_think );
}
	
vertical_spinners_think()
{	
	self useanimtree ( #animtree );
	self setanim( %launchfacility_b_emergencylight, 1, 0.1, 1.0 );

} 

#using_animtree("generic_human");
music()
{
	wait 0.1;
	thread music_vents();
	
	flag_wait ( "music_start_countdown" );
	musicStop( 5 );
	wait 5.15;
	
	thread music_countdown( level.gameskill );
	
	flag_wait ( "codes_uploaded" );
	
	musicStop( 8 );
	wait 8.1;
	
	flag_wait( "successful_confirmation" );
	
	MusicPlayWrapper( "launch_b_victory_music" );
	wait 19;
	musicstop( 1 );
	wait 1.1;
	
	while( 1 ) 
	{
		MusicPlayWrapper ( "tension_maintheme_groove" );
		wait 46;
		musicStop( 1 );
		wait 1.1;
	}
}

music_vents()
{
	level endon ( "music_start_countdown" );
	
	while( 1 )
	{
		MusicPlayWrapper ( "tension_maintheme_groove" );
		wait 46;
		musicStop( 1 );
		wait 1.1;
	}
}

music_countdown( skill )
{
	level endon ( "codes_uploaded" );
	
	if( skill == 0 )
	{
		//15 minutes

		for( i = 0; i < 2; i++ )
		{		
			MusicPlayWrapper ( "launch_b_count_01" );
			wait 36;	
			musicStop( 1 );
			wait 1.1;
			
			MusicPlayWrapper ( "launch_b_count_02" );
			wait 94;	
			musicStop( 1 );
			wait 1.1;
			
			MusicPlayWrapper ( "launch_b_count_03" );
			wait 140;	
			musicStop( 3 );
			wait 3.1;
			
			MusicPlayWrapper ( "launch_b_count_04" );
			wait 54;	
			musicStop( 0.1 );
			wait 0.15;
		}
		
		MusicPlayWrapper ( "launch_b_count_01" );
		wait 36;	
		musicStop( 1 );
		wait 1.1;
		
		MusicPlayWrapper ( "launch_b_count_05" );
		wait 192;	
		musicStop( 4 );
		wait 4.1;
	}
	else
	if ( skill == 1 || skill == 2 )
	{
		//11 minutes
		
		MusicPlayWrapper ( "launch_b_count_01" );
		wait 36;	
		musicStop( 1 );
		wait 1.1;
		
		MusicPlayWrapper ( "launch_b_count_02" );
		wait 92;	
		musicStop( 2 );
		wait 2.1;
		
		MusicPlayWrapper ( "launch_b_count_03" );
		wait 138;	
		musicStop( 3 );
		wait 3.1;
		
		MusicPlayWrapper ( "launch_b_count_04" );
		wait 54;	
		musicStop( 0.1 );
		wait 0.15;
		
		MusicPlayWrapper ( "launch_b_count_01" );
		wait 36;	
		musicStop( 1 );
		wait 1.1;
		
		MusicPlayWrapper ( "launch_b_count_02" );
		wait 92;	
		musicStop( 2 );
		wait 2.1;
		
		MusicPlayWrapper ( "launch_b_count_05" );
		wait 192;	
		musicStop( 4 );
		wait 4.1;
	}
	else
	if ( skill == 3 )
	{
		//9 minutes
		
		wait 13;
		
		MusicPlayWrapper ( "launch_b_count_01" );
		wait 36;	
		musicStop( 1 );
		wait 1.1;
		
		MusicPlayWrapper ( "launch_b_count_02" );
		wait 94;	
		musicStop( 2 );
		wait 2.1;
		
		MusicPlayWrapper ( "launch_b_count_03" );
		wait 140;	
		musicStop( 3 );
		wait 3.1;
		
		MusicPlayWrapper ( "launch_b_count_04" );
		wait 54;	
		musicStop( 0.1 );
		wait 0.15;
		
		MusicPlayWrapper ( "launch_b_count_05" );
		wait 194;	
		musicStop( 2 );
		wait 2.1;
	}
}

hide_triggers( trigger_name )
{
	trigger = getentarray ( trigger_name, "script_noteworthy");
	for (i=0; i<trigger.size; i++)
	{
		trigger[i] trigger_off();
	}
}

show_triggers( trigger_name )
{
	trigger = getentarray ( trigger_name, "script_noteworthy");
	for (i=0; i<trigger.size; i++)
	{
		trigger[i] trigger_on();
	}
}

//*	Ned Man *//