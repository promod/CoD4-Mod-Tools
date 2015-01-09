#include common_scripts\utility;
#include maps\_utility;
#include maps\_anim;

#using_animtree("generic_human");
main()
{
	if ( getdvar( "r_reflectionProbeGenerate" ) == "1" )
		return;

	setsaveddvar( "r_specularcolorscale", "2.3" );
	setsaveddvar( "sm_sunShadowScale", "0.5" ); // optimization - night shadows can be lower resolution

	add_start( "crash", ::start_crash, &"STARTS_CRASH" );
	add_start( "path", ::start_dirt_path, &"STARTS_PATH" );
	add_start( "barn", ::start_barn, &"STARTS_BARN" );
	add_start( "field", ::start_field, &"STARTS_FIELD2" );
	add_start( "basement", ::start_basement, &"STARTS_BASEMENT" );
	add_start( "dogs", ::start_farm, &"STARTS_DOGS" );
	add_start( "farm", ::start_farm, &"STARTS_FARM" );
	add_start( "creek", ::start_creek, &"STARTS_CREEK" );
	add_start( "greenhouse", ::start_greenhouse, &"STARTS_GREENHOUSE" );
	add_start( "ac130", ::start_ac130, &"STARTS_AC130");

	precacheShader( "overlay_hunted_red" );
	precacheShader( "overlay_hunted_black" );

	precacheModel( "com_flashlight_on" );

	precacheItem( "hunted_crash_missile" );

	precacherumble ( "tank_rumble" );

	createthreatbiasgroup( "player" );
	createthreatbiasgroup( "dogs" );
	createthreatbiasgroup( "oblivious" );
	createthreatbiasgroup( "heli_guy" );

	setup_flags();

	default_start( ::start_default );

	maps\_truck::main("vehicle_pickup_4door");
	maps\_t72::main("vehicle_t72_tank");
	maps\_bm21_troops::main("vehicle_bm21_mobile_cover");
	maps\_bm21_troops::main("vehicle_bm21_cover_destructible");
	maps\_bm21_troops::main("vehicle_bm21_mobile_bed_destructible");
	maps\_mi17::main("vehicle_mi17_woodland_fly");
	maps\_blackhawk::main("vehicle_blackhawk_hero");
	maps\_vehicle::build_aianims( ::blackhawk_overrides, maps\_blackhawk::set_vehicle_anims );

	maps\_load::set_player_viewhand_model( "viewhands_player_sas_woodland" );

	animscripts\dog_init::initDogAnimations();

	level.weaponClipModels = [];
	level.weaponClipModels[0] = "weapon_ak74u_clip";
	level.weaponClipModels[1] = "weapon_g36_clip";
	level.weaponClipModels[2] = "weapon_m16_clip";
	level.weaponClipModels[3] = "weapon_ak47_clip";
	level.weaponClipModels[4] = "weapon_mp5_clip";
	level.weaponClipModels[5] = "weapon_g3_clip";

	maps\createart\hunted_art::main();
	maps\hunted_fx::main();
	maps\_load::main();

	maps\_stinger::init();

	maps\hunted_anim::main();

	level.player setthreatbiasgroup( "player" );

	// make oblivious ingnored and ignore by everything.
	setignoremegroup( "allies", "oblivious" );	// oblivious ignore allies
	setignoremegroup( "axis", "oblivious" );	// oblivious ignore axis
	setignoremegroup( "player", "oblivious" );	// oblivious ignore player
	setignoremegroup( "oblivious", "allies" );	// allies ignore oblivious
	setignoremegroup( "oblivious", "axis" );	// axis ignore oblivious
	setignoremegroup( "oblivious", "oblivious" );	// oblivious ignore oblivious

	// make heli guy hate the player
	setignoremegroup( "heli_guy", "allies" );	// allies ignore oblivious
	setthreatbias( "player", "heli_guy", 1000000 );	// make the player a great threat

	level.ai_friendlyFireBlockDuration = getdvarfloat( "ai_friendlyFireBlockDuration" );

	level thread maps\hunted_amb::main();
	maps\_compass::setupMiniMap("compass_map_hunted");

	setup_setgoalvolume_trigger();
	setup_enemies();
	setup_visionset_trigger();
	setup_heli_guy();
	setup_spot_target();
	setup_helicopter_delete_node();
	setup_tmp_detour_node();
	setup_gas_station();
	setup_basement_door();

	level.player thread grenade_notifies();
	level thread dynamic_dog_threat();

	level.cos90 = cos(90);

	array_thread( getentarray( "noprone", "targetname" ), ::noprone );
	array_thread( getentarray( "doorknob", "targetname" ), ::doorknob );

	battlechatter_off( "allies" );
	battlechatter_off( "axis" );

	run_thread_on_targetname ( "dead_body" ,:: spawn_dead_body );
}

player_sprint_check()
{
	level endon( "player_interruption" );

	if ( !isdefined( level.player.movespeedscale ) )
		level.player.movespeedscale = 1;

	old_origin = level.player.origin;
	sprint_time = 0;

	while( true )
	{
		wait 0.1;
		origin = level.player.origin;

		min_sprint_speed = int( 25 * level.player.movespeedscale );

		if ( int( distance2d( old_origin, origin ) ) > min_sprint_speed )
			sprint_time++;
		else
			sprint_time = 0;

		if ( sprint_time > 5 )
			flag_set( "player_sprint" );
		else
			flag_clear( "player_sprint" );

		old_origin = origin;
	}
}

setup_flags()
{
	// stat_flags
	flag_init( "aa_flight" );
	flag_init( "aa_crash" );
	flag_init( "aa_dirt_path" );
	flag_init( "aa_barn" );
	flag_init( "aa_field" );
	flag_init( "aa_basement" );
	flag_init( "aa_farm" );
	flag_init( "aa_creek" );
	flag_init( "aa_second_field" );
	flag_init( "aa_greenhouse" );
	flag_init( "aa_stinger" );
	flag_init( "aa_ac130" );
	
	flag_init( "player_sprint" );

	// flight
	flag_init( "flight_missile_warning" );
	flag_init( "blackhawk_hit" );
	flag_init( "blackhawk_down" );

	// crash area
	flag_init( "price_help" );
	flag_init( "wakeup_start" );
	flag_init( "wakeup_done" );
	flag_init( "wounded_check" );
	flag_init( "wounded_check_done" );
	flag_init( "crash_dialogue_done" );

	// path area
	flag_trigger_init( "path_trigger", getent( "path_trigger", "targetname" ) );
	flag_trigger_init( "truck_alert", getent( "truck_alert", "targetname" ) );
	flag_init( "mark_at_goal" );
	flag_init( "trucks_warning" );
	flag_init( "tunnel_rush" );
	flag_init( "spawn_tunnel_helicopter" );
	flag_init( "helicopter_fly_over" );
	flag_init( "price_in_tunnel" );
	flag_init( "mark_in_tunnel" );

	// barn area
	flag_init( "barn_truck_arrived" );
	flag_trigger_init( "barn_moveup", getent( "tunnel_trigger", "script_noteworthy" ) );
	flag_init( "barn_interrogation_start" );
	flag_init( "barn_rear_open" );
	flag_init( "barn_front_open" );
	flag_init( "interrogation_done" );
	flag_init( "start_scene" );
	flag_init( "save_farmer" );
	flag_init( "farmer_gone" );

	// first field area
	flag_init( "field_open" );
	flag_trigger_init( "field_cross", getent( "field_cross", "targetname" ) );
	flag_trigger_init( "field_cover", getent( "field_cover", "targetname" ) );
	flag_init( "field_spoted" );
	flag_init( "field_moveon" );
	flag_init( "field_truck" );
	flag_init( "field_defend" );
	flag_trigger_init( "field_basement", getent( "field_basement", "targetname" ) );
	flag_init( "field_open_basement" );
	flag_init( "hit_the_deck_music" );
	flag_init( "basement_door_open" );
	flag_init( "heli_field_stragler_attack" );

	// basement area
	flag_init( "basement_open" );
	flag_trigger_init( "basement_enter", getent( "basement_enter", "targetname" ) );

	flag_trigger_init( "basement_light_1", getent( "basement_light_1", "targetname" ) );
	flag_trigger_init( "basement_light_2", getent( "basement_light_2", "targetname" ) );
	flag_trigger_init( "basement_light_3", getent( "basement_light_3", "targetname" ) );
	flag_trigger_init( "basement_light_4", getent( "basement_light_4", "targetname" ) );
	flag_trigger_init( "basement_light_5", getent( "basement_light_5", "targetname" ) );
	flag_trigger_init( "basement_light_6", getent( "basement_light_6", "targetname" ) );

	flag_trigger_init( "trim_field", getent( "trim_field", "targetname" ) );
	flag_trigger_init( "basement_heli_takeoff", getent( "basement_heli_takeoff", "targetname" ) );

	flag_trigger_init( "basement_flash", getent( "basement_flash", "targetname" ) );

	flag_init( "squad_in_basement" );
	flag_init( "basement_secure" );

	// farm area
	flag_trigger_init( "farm_start", getent( "farm_start", "targetname" ) );
	flag_trigger_init( "farm_alert", getent( "farm_alert", "targetname" ) );
	flag_trigger_init( "farm_enemies_timer", getent( "farm_enemies_timer", "targetname" ) );
	flag_init( "farm_clear");
	
	// creek area
	flag_trigger_init( "creek_helicopter", getent( "creek_helicopter", "targetname" ) );
	flag_trigger_init( "creek_start", getent( "creek_start", "targetname" ) );
	flag_trigger_init( "creek_bridge", getent( "creek_bridge", "targetname" ) );
	flag_init( "creek_gate_open" );
	flag_init( "creek_truck_on_bridge" );

	// road area
	flag_trigger_init( "road_start", getent( "road_start", "targetname" ) );
	flag_init( "road_open_field" );
	flag_trigger_init( "roadblock", getent( "roadblock", "targetname" ) );
	flag_init( "roadblock_start" );
	flag_init( "roadblock_done" );
	flag_trigger_init( "road_field_search", getent( "road_field_search", "targetname" ) );
	flag_init( "road_field_end" );
	flag_trigger_init( "road_field_cleanup", getent( "road_field_cleanup", "targetname" ) );
	flag_init( "road_field_clear_helicopter" );
	flag_init( "road_field_clear" );
	flag_init( "road_helicopter_cleared" );

	// greenhouse area
	flag_trigger_init( "greenhouse_area", getent( "greenhouse_area", "targetname" ) );
	flag_init( "helicopter_down" );
	flag_trigger_init( "greenhouse_rear_exit", getent( "greenhouse_rear_exit", "targetname" ), true );
	flag_init( "greenhouse_done" );
	flag_trigger_init( "greenhouse_heli_light_off", getent( "greenhouse_heli_light_off", "targetname" ), true );

	// AC-130 area
	flag_trigger_init( "gasstation_start", getent( "gasstation_start", "targetname" ) );
	flag_trigger_init( "ac130_inplace", getent( "ac130_inplace", "targetname" ) );
	flag_init( "ac130_barrage" );
	flag_init( "go_dazed" );
	flag_init( "ac130_barrage_over" );
	flag_trigger_init( "ac130_defend_gasstation", getent( "ac130_gasstation_defend", "targetname" ) );

	// other flags
	flag_trigger_init( "mission_end_trigger", getent( "mission_end_trigger", "targetname" ) );
	flag_init( "helicopter_unloading" );
	flag_init( "player_interruption" );

}

/**** objectives ****/

objective_lz()
{
	lz_origin = getstruct( "bridge_origin", "targetname" );
	objective_add( 1, "active", &"HUNTED_OBJ_EXTRACTION_POINT", lz_origin.origin );
	objective_current( 1 );
}

objective_stinger()
{
	stinger_origin = getent( "stinger_objective", "targetname" );
	objective_add( 2, "active", &"HUNTED_OBJ_DESTROY_HELICOPTER", stinger_origin.origin );
	objective_current( 2 );
	flag_wait ( "helicopter_down" );
	wait 1;
	objective_state( 2, "done" );

	objective_add( 3, "active", &"HUNTED_OBJ_FOLLOW_PRICE", level.price.origin );
	objective_current( 3 );
	level thread my_objective_onentity( 3, level.price );

	flag_wait( "ac130_barrage_over" );

	level notify( "release_objective" );
	objective_state( 3, "done" );

	objective_current( 1 );
}

my_objective_onentity( id, entity )
{
	level endon( "release_objective" );
	while( true )
	{
		objective_position( id, entity.origin );
		wait 0.05;
	}
}

/**** helicopter flight ****/
area_flight_init()
{
	thread hud_hide( true );

	getent( "broken_blackhawk", "targetname" ) hide();

	flag_set( "aa_flight" );

	level.player allowcrouch( false );
	level.player allowprone( false );
	level.player EnableInvulnerability();

	crash_mask = getent( "crash_mask", "targetname" );
	crash_mask.origin = crash_mask.origin + (-3000,64, ( 64 - 500 ) ); // 576 units down since I lifted it.

	level.player disableweapons();
	level thread fligth_missile();

	set_vision_set( "hunted_crash", 0 );
	flight_helicopter();

	setExpFog(2500, 5000, 0.045, 0.17, 0.2, 0);

	crash_mask delete();

	getent( "broken_blackhawk", "targetname" ) show();

	level.player DisableInvulnerability();

	flag_clear( "aa_flight" );

	thread area_crash_init();

}

flight_dialogue( price )
{
	price waittillmatch( "animontagdone", "dialog" );
	price playsound( "hunted_pri_whatthebloody" );

	flag_set( "flight_missile_warning" );

	price waittillmatch( "animontagdone", "dialog" );
	price playsound( "hunted_pri_incomingmissile" );

	self play_sound_on_tag( "hunted_hp1_missileinbound", "tag_driver");

	flag_wait( "blackhawk_hit" );
	wait 1;
	self play_sound_on_tag( "hunted_hp1_maydaymayday", "tag_driver");
}

bnb()
{
	wait 0.7;
	self play_sound_on_tag( "hunted_bnb_missilelock", "tag_driver");
	self play_sound_on_tag( "hunted_bnb_warning", "tag_driver");

	flag_wait( "blackhawk_hit" );
	wait 5;
	self play_sound_on_tag( "hunted_bnb_altitude", "tag_driver");
//	self play_sound_on_tag( "hunted_bnb_caution", "tag_driver");
}

fligth_missile()
{
	missile_point = getstruct( "missile_point", "script_noteworthy" );
	missile_point waittill( "trigger", blackhawk );

	missile_source = getent( "missile_source", "targetname" );
	missile_source hide();

	missile_source setVehWeapon( "hunted_crash_missile" );
	missile_source setturrettargetent( blackhawk );
	wait 1.5;

	dummy_target = getent( "dummy_target", "targetname" );

	missile = missile_source fireweapon( "tag_gun_r", dummy_target, ( 0,0,0 ) );

	while( distance2d( missile.origin, dummy_target.origin ) > 350 && isdefined(missile) )
		wait 0.05;

	missile_source delete();

	missile missile_settarget( Blackhawk, ( 80,20,-200 ) );

	wait 2;

	missile playsound( "blackhawk_down_missile_inbound" );

	old_dist = distancesquared( missile.origin, blackhawk.origin );
	wait 0.05;
	while( distancesquared( missile.origin, blackhawk.origin ) < old_dist )
	{
		old_dist = distancesquared( missile.origin, blackhawk.origin );
		wait 0.1;
	}

	org = missile.origin;
	missile delete();
	
	playfx( level._effect["missile_explosion"], org );

	level thread play_sound_in_space( "blackhawk_down_missile_impact", org );

	flag_set( "blackhawk_hit" );

}

kill_missile( missile )
{
	missile delete();
}

flight_crash()
{
	wait 6;
	self thread bnb();
	self playsound( "alarm_missile_incoming" );

	flag_wait( "blackhawk_hit" );

	self thread flight_crash_rotate();
	self thread flight_crash_overlay();
	
	struct = getstruct( "crash_location", "targetname" );
	self thread heli_path_speed(  struct );

	self playsound( "blackhawk_helicopter_hit" );
	wait 0.5;
	self playsound( "blackhawk_helicopter_dying_loop" );
	wait 8.5;
	self playsound( "blackhawk_helicopter_crash" );
	self stopenginesound();
	self notify( "stop_rotate" );
	wait 7;
	flag_set( "blackhawk_down" );

	self delete();
}

flight_crash_overlay()
{
	red_overlay = create_overlay_element( "overlay_hunted_red", 0 );
//	black_overlay = create_overlay_element( "overlay_hunted_black", 0 );
	black_overlay = create_overlay_element( "black", 0 );
	red_overlay.sort = 0;
	black_overlay.sort = 1;
	wait 4;
	red_overlay thread exp_fade_overlay( 1, 4.5);
	black_overlay thread exp_fade_overlay( 0.5, 4.5);
	wait 5.25;
	black_overlay thread fade_overlay( 1, 0.1);

	flag_wait( "blackhawk_down" );
	red_overlay destroy();

	black_overlay thread fade_overlay( 0, 4);

}

flight_crash_rotate()
{
	self setturningability( 1 );
	self setyawspeed( 1200, 100);

	self endon( "stop_rotate" );
	while ( true )
	{
		earthquake( 0.4, .35, self.origin, 256 );
		level.player PlayRumbleOnEntity( "tank_rumble" );
		self settargetyaw( self.angles[1] - 170 );
		wait 0.1;
	}
}

flight_helicopter()
{
	blackhawk = maps\_vehicle::spawn_vehicle_from_targetname_and_drive( "crash_blackhawk" );
//	blackhawk thread maps\_vehicle::lights_on( "interior" );

	blackhawk setturningability( 0.2 );
	blackhawk thread flight_crash();
	blackhawk maps\_vehicle::godon();

	price = undefined;

	for( i = 0 ; i < blackhawk.riders.size ; i ++ )
	{
		if ( issubstr( blackhawk.riders[i].classname, "vip" ) )
			blackhawk.riders[i].has_ir = undefined;
		if ( !issubstr( blackhawk.riders[i].classname, "price" ) )
			continue;
		price = blackhawk.riders[i];
	}

	blackhawk thread flight_dialogue( price );
	blackhawk thread flight_helicopter_dlight();

	blackhawk.tag_ent = blackhawk fake_tag( "tag_origin", (-10,32,-132), (0,140,0) );

	level.player playerlinktodelta( blackhawk.tag_ent, "tag_origin", 0.5, 80, 80, 30, 20);
	level.player setplayerangles( (0,35,0) );

	flag_wait( "blackhawk_down" );
	level.player unlink();

}

flight_helicopter_dlight()
{
	// price 
	self.dlight_ent1 = self fake_tag( "tag_light_cargo01", (10,-25,-60), (0,0,0) );
	playfxontag( level._effect["heli_dlight_blue"], self.dlight_ent1, "tag_origin" );

	// other guy
	self.dlight_ent2 = self fake_tag( "tag_light_cargo01", (20,-25,40), (0,0,0) );
	playfxontag( level._effect["heli_dlight_blue"], self.dlight_ent2, "tag_origin" );

	flag_wait( "flight_missile_warning" );

	self.dlight_ent3 = self fake_tag( "tag_light_cargo01", (4,-58,-37), (0,0,0) );
	playfxontag( level._effect["heli_dlight_red"], self.dlight_ent3, "tag_origin" );

	self.dlight_ent4 = self fake_tag( "tag_light_cargo01", (4,-58,37), (0,0,0) );
	playfxontag( level._effect["heli_dlight_red"], self.dlight_ent4, "tag_origin" );
}

fake_tag( tag, origin_offset, angles_offset )
{
	ent = spawn( "script_model", self.origin);
	ent setmodel( "tag_origin" );
	ent hide();
	ent linkto( self, tag, origin_offset, angles_offset );
	self thread fake_tag_destroy( ent );
	return ent;
}

tmp_point()
{
	model = spawn( "script_model", self.origin );
	model setModel( "fx" );
	model linkto ( self );
	wait 2;
	model delete();
}

fake_tag_destroy( fake_tag )
{
	self waittill( "death" );
	fake_tag delete();
}

blackhawk_overrides()
{
	positions = maps\_blackhawk::setanims();

//	level.scr_sound[ "generic" ][ "whatthebloody" ] =		"hunted_pri_whatthebloody";
//	level.scr_sound[ "generic" ][ "incomingmissile" ] =		"hunted_pri_incomingmissile";

	// 1, 2, 4, 5, 8,  6
	positions[ 2 ].idle = %bh_1_idle;
	positions[ 3 ].idle = %hunted_bh2_crash;
	positions[ 4 ].idle = %bh_4_idle;
	positions[ 5 ].idle = %bh_5_idle;
	positions[ 6 ].idle = %hunted_bh8_crash;
	positions[ 7 ].idle = %hunted_bh6_crash;

	return positions;
}


/**** crash area ****/
area_crash_init()
{
	set_specular_scale( 1.7, 0 );

	thread maps\_utility::set_ambient("exterior_level2");

	flag_set( "aa_crash" );
	setculldist( 11000 );

	setExpFog(512, 6145, 0.132176, 0.192839, 0.238414, 0);
	set_vision_set( "hunted", 0 );

	setup_friendlies();

	array_thread( level.squad, ::set_fixednode, false );

	level thread crash_player();
	level.price thread crash_price();
	level.steve thread crash_steve();
	level thread crash_wounded_dialogue();
	level thread music();

	flag_set("price_help");

	flag_wait( "wakeup_done" );

	set_specular_scale( 2.3, 1 );

	hud_hide( false );

	flag_wait( "wounded_check_done" );

	flag_clear( "aa_crash" );

	level thread area_dirt_path_init();
}

crash_wounded_dialogue()
{
	flag_wait( "wakeup_done" );

	wait 1;
	level.price anim_single_queue( level.price, "casualtyreport" );
	level.mark anim_single_queue( level.mark, "bothpilotsdead" );
	level.price anim_single_queue( level.price, "bugger" );
	wait 3;
	level.price anim_single_queue( level.price, "extractionpoint" );

	flag_wait( "path_trigger" );

	radio_dialogue( "hunted_price_ac130_inbound" );
	level.price anim_single_queue( level.price, "hunted_pri_copy" );
	level.mark anim_single_queue( level.mark, "hunted_uk2_ac130" );

	flag_set( "crash_dialogue_done" );
}

crash_price()
{
	anim_ent = getent( "start_animent", "targetname" );
	flag_wait("price_help");

	self notify( "stop_going_to_node" );

	wait 7.5;

	self thread fuel_explosion();
	anim_ent anim_reach_solo( self, "hunted_opening_price" );
	flag_set( "wakeup_start" );

	anim_ent anim_single_solo( self, "hunted_opening_price" );
	self set_force_color( "c" );
}

fuel_explosion()
{
	self waittillmatch( "single anim", "fuel_ignition");
	maps\hunted_fx::fuel_explosion();
}

crash_steve()
{
	self set_run_anim( "path_slow" );

	anim_ent = getent( "wounded_animent", "targetname" );
	wounded = crash_setup_wounded( anim_ent );

	flag_wait( "wounded_check" );

	wait 15.5;

	self notify( "stop_going_to_node" );
	anim_ent anim_reach_solo( self, "hunted_dying" );

	actors[0] = level.steve;
	actors[1] = wounded;

	anim_ent anim_single( actors, "hunted_dying" );
	flag_set( "wounded_check_done" );
	anim_ent thread anim_loop_solo( wounded, "hunted_dying_endidle", undefined, "stop_idle" );

	flag_wait( "tunnel_rush" );
	wounded delete();
}

crash_setup_wounded( anim_ent )
{
	spawner = getent( "dead_guy_spawner", "targetname" );
	dude = dronespawn( spawner );
	dude.animname = "dead_guy";
	anim_ent anim_first_frame_solo( dude, "hunted_dying" );

	return dude;
}

crash_player()
{
	level thread crash_wakeup();

	level.player allowcrouch( true );
	level.player allowprone( true );

	level.player set_playerspeed( 130 );

	flag_set( "wounded_check" );

	flag_wait("wakeup_done");

	level.player EnableWeapons();

}

#using_animtree("player");
crash_wakeup()
{
	anim_ent = getent( "start_animent", "targetname" );

	start_origin = getstartorigin( anim_ent.origin, anim_ent.angles, %hunted_opening_player );
	start_angles = getstartangles( anim_ent.origin, anim_ent.angles, %hunted_opening_player );

	view_ent = PlayerView_Spawn( start_origin, start_angles );
	level.player setorigin( start_origin );
	level.player setplayerangles( start_angles ); 
	level.player playerlinktoabsolute( view_ent, "tag_player" );

	view_ent setflaggedanimrestart( "viewanim", %hunted_opening_player_idle );

	level thread crash_wakeup_overlay();
	flag_wait( "wakeup_start" );
	view_ent clearanim( %hunted_opening_player_idle, 0 );
	view_ent setflaggedanimrestart( "viewanim", %hunted_opening_player );
	view_ent animscripts\shared::DoNoteTracks( "viewanim" );

	view_ent clearanim( %hunted_opening_player, 0 );

	level.player unlink();
	view_ent delete();
	flag_set( "wakeup_done" );

}

PlayerView_Spawn( start_origin, start_angles )
{
	playerView = spawn( "script_model", start_origin );
	playerView.angles = start_angles;
	playerView setModel( "viewhands_player_sas_woodland" );
	playerView useAnimTree( #animtree );
	playerView hide();

	return playerView;
}

#using_animtree("generic_human");
crash_wakeup_overlay()
{
	red_overlay = create_overlay_element( "overlay_low_health", 0 );
//	black_overlay = create_overlay_element( "overlay_hunted_black", 1 );
	black_overlay = create_overlay_element( "black", 1 );

	wait 2;
	setblur(5, 0);
	
	black_overlay thread exp_fade_overlay( 0.25, 4);
	wait 1.5;
	level.player play_sound_on_entity("breathing_better");
	wait 1.5;
	setblur(0, 2);
	wait 3;
	black_overlay exp_fade_overlay( 1, 2);
	wait .5;
	black_overlay thread exp_fade_overlay( 0, 3);
	wait 2;
	setblur(2.4, 1);
	wait 1;
	setblur(0, 2);
	wait 2;

	black_overlay destroy();
	red_overlay destroy();
}

/**** dirt path area ****/
area_dirt_path_init()
{
	autosave_by_name( "dirt_path" );

	if ( !flag( "path_trigger" ) )
		activate_trigger_with_targetname( "dirt_path_color_init" );

	flag_set( "aa_dirt_path" );

	level thread objective_lz();

	level thread dirt_path_truck();
	level thread dirt_path_barn_truck();
	level thread dirt_path_helicopter();
	level thread dirt_path_allies();
	level thread dirt_path_player_speed();
	level thread dirt_path_player();

	level thread player_interruption();

	flag_wait( "price_in_tunnel" );
	flag_wait( "mark_in_tunnel" );
	flag_wait( "barn_moveup" );

	flag_clear( "aa_dirt_path" );

	level thread area_barn_init();
}

dirt_path_allies()
{
	level.price thread dirt_path_price();
	level.steve thread dirt_path_steve();
	level.charlie thread dirt_path_charlie();
	level.mark thread dirt_path_mark();
}

dirt_path_player()
{
	flag_wait("tunnel_rush");
	wait 1;

	level.player set_playerspeed( 190, 2 );
}

dirt_path_price_dialogue()
{
	flag_wait( "crash_dialogue_done" );
	wait 2;
	if ( !flag( "truck_alert" ) )
		level.price anim_single_queue( level.price, "lowprofile" );
}

dirt_path_price()
{
	self thread dirt_path_price_dialogue();

	self notify( "stop_going_to_node" );

	self set_force_color( "c" );

	flag_wait( "truck_alert" );

	anim_ent = getent( "truck_warning_animent", "targetname" );
	anim_ent anim_reach_solo( self, "hunted_wave_chat" );

	flag_set("trucks_warning");
	anim_ent anim_single_solo( self, "hunted_wave_chat" );

	self.disableArrivals = false;

	anim_ent = getent( "tunnel_animent", "targetname" );
	anim_ent anim_reach_solo( self, "hunted_tunnel_guy2_runin" );

	anim_ent anim_single_solo( self, "hunted_tunnel_guy2_runin" );
	anim_ent thread anim_loop_solo( self, "hunted_tunnel_guy2_idle", undefined, "price_stop_idle" );
	
	wait 3;

	flag_wait( "helicopter_fly_over" );

	flag_set( "price_in_tunnel" );

	getent( "tunnel_trigger", "script_noteworthy" ) thread trigger_timeout( 8 );
	flag_wait_either( "barn_moveup", "player_interruption" );
	flag_set( "barn_moveup" );

	anim_ent notify( "price_stop_idle" );
	if ( flag( "player_interruption" ) )
		anim_ent anim_single_solo( self, "hunted_tunnel_guy2_runout_interrupt" );
	else
		anim_ent anim_single_solo( self, "hunted_tunnel_guy2_runout" );

	self pushplayer( false );
}

dirt_path_charlie()
{
	anim_ent = getent( "truck_warning_animent", "targetname" );
	anim_ent anim_reach_and_idle_solo( self, "hunted_wave_chat", "hunted_spotter_idle", "charlie_stop_idle" );

	flag_wait("trucks_warning");

	level thread flag_set_delayed( "tunnel_rush", 3);

	anim_ent notify( "charlie_stop_idle" );
	anim_ent anim_single_solo( self, "hunted_wave_chat" );

	node = getnode( "charlie_tunnel", "targetname" );
	self setgoalnode( node );
	self.goalradius = 0;
	self waittill("goal");
	self clear_run_anim();
}

dirt_path_mark()
{
	self notify( "stop_going_to_node" );

	self set_force_color( "g" );

	flag_wait("tunnel_rush");

	self pushplayer( true );

	anim_ent = getent( "tunnel_animent", "targetname" );
	anim_ent anim_reach_solo( self, "hunted_tunnel_guy1_runin" );
	anim_ent anim_single_solo( self, "hunted_tunnel_guy1_runin" );

	if ( !flag( "helicopter_fly_over" ) )
	{
		anim_ent thread anim_loop_solo( self, "hunted_tunnel_guy1_idle", undefined, "mark_stop_idle" );

		flag_wait( "helicopter_fly_over" );

		anim_ent notify( "mark_stop_idle" );
		anim_ent anim_single_solo( self, "hunted_tunnel_guy1_lookup" );
	}

	anim_ent thread anim_loop_solo( self, "hunted_tunnel_guy1_idle", undefined, "mark_stop_idle" );

	flag_set( "mark_in_tunnel" );
	flag_wait( "barn_moveup" );

	wait 2;
	anim_ent notify( "mark_stop_idle" );
	anim_ent anim_single_solo( self, "hunted_tunnel_guy1_runout" );
	self pushplayer( false );
}

dirt_path_mark_path_end()
{
	self endon( "stop_path" );
	self waittill( "path_end_reached" );
	flag_set ("mark_at_goal");
}

dirt_path_steve()
{
	self notify( "stop_going_to_node" );

	self set_force_color( "g" );

	self clear_run_anim();

	flag_wait("trucks_warning");

	self.disableArrivals = false;
	node = getnode( "steve_tunnel", "targetname" );
	self setgoalnode( node );
	self.goalradius = 0;
	self pushplayer( false );

}

dirt_path_helicopter()
{
	flag_wait( "spawn_tunnel_helicopter" );

	helicopter = maps\_vehicle::spawn_vehicle_from_targetname( "tunnel_heli" );

	helicopter sethoverparams(128, 10, 3);

	helicopter thread heli_path_speed();
	helicopter waittill_either( "near_goal", "goal" );
	wait 0.05;

	helicopter_alloted_time = level.move_time;
	fly_over_point = getstruct( "fly_over_point", "script_noteworthy" );
	dist = distance( helicopter.origin, fly_over_point.origin );
	MPH = dist / helicopter_alloted_time / 17.6;

	helicopter setSpeed( MPH, MPH);
	helicopter helicopter_searchlight_on();

	fly_over_point waittill( "trigger" );
	flag_set( "helicopter_fly_over" );

	helicopter thread dirt_path_helicopter_react();

	trigger = getent( "heli_away", "targetname" );
	trigger waittill( "trigger" );

	helicopter notify( "heli_away" );
}

dirt_path_helicopter_react()
{
	level endon( "barn_rear_open" );

	self thread impact_trigger_attach();

	self waittill_either( "impact", "heli_away" );

	path_struct = getstruct( "heli_away_path", "targetname" );
	self thread heli_path_speed( path_struct );
	self notify( "spot_target_path" );
	self helicopter_setturrettargetent( self.spotlight_default_target );
}

impact_trigger_attach()
{
	trigger = getent( "heli_damage_trigger", "targetname" );

	if ( isdefined( trigger.inuse ) )
		trigger unlink();
	else
		trigger enablelinkto();

	trigger.inuse = true;
	trigger linkto( self, "tag_origin", (0,0,0), (0,0,0) );

	trigger thread notify_impact( self );
}

notify_impact( heli )
{
	heli endon( "death" );
	while( true )
	{
		self waittill( "damage" );
		heli notify( "impact" );
	}
}


dirt_path_player_speed()
{
	calc_speed_trigger = getent( "calc_speed_trigger", "script_noteworthy" ) ;
	helicopter_trigger = getent( "helicopter_trigger", "script_noteworthy" ) ;

	calc_speed_trigger waittill( "trigger" );
	start_time = gettime();

	helicopter_trigger waittill( "trigger" );
	end_time = gettime();

	move_time = (end_time - start_time) / 1000;

	if ( move_time > 0.75 )
		move_time = 0.75;

	move_time = 1 + move_time * 4;

	level.move_time = move_time;

	// no helicopter until the tunnel rush is started.
	flag_wait ( "tunnel_rush" );
	flag_set( "spawn_tunnel_helicopter" );
}

dirt_path_truck()
{
	flag_wait("trucks_warning");

	truck = maps\_vehicle::spawn_vehicle_from_targetname( "path_truck" );
	thread maps\_vehicle::gopath ( truck );
	truck maps\_vehicle::lights_on( "headlights" );
	truck maps\_vehicle::godon();
	
}

player_interruption()
{
	flag_wait( "tunnel_rush" );

	wait 3;

	level thread set_flag_on_player_action( "player_interruption", false, true);
}

dirt_path_barn_truck()
{
	flag_wait("trucks_warning");
	wait 2;

	truck  = maps\_vehicle::spawn_vehicle_from_targetname( "barn_truck" );
	truck maps\_vehicle::godon();

	wait 0.1;

	barn_axis = truck.riders;

	for ( i=0; i<barn_axis.size; i++ )
	{
		barn_axis[i] thread magic_bullet_shield();
		barn_axis[i] setthreatbiasgroup ( "oblivious" );
	}

	thread maps\_vehicle::gopath ( truck );
	truck maps\_vehicle::lights_on( "headlights" );

	truck thread barn_russian_joke( barn_axis );

	truck waittill( "reached_end_node" );
	wait 1;

	flag_set("barn_truck_arrived");

	array_thread( barn_axis, ::stop_magic_bullet_shield );

	// reconnects the path that got disconnected when the truck stoped.
	truck connectpaths();

	if ( !flag( "player_interruption" ) )
	{
		activate_trigger_with_targetname( "barn_truck_color_init" );
		flag_wait( "interrogation_done" );
	}

	truck maps\_vehicle::godoff();
	truck.script_bulletshield = 0;

	truck dirt_path_disable_truck();
	
}

barn_russian_joke( thugs )
{
	thugs[0] endon( "death" );
	thugs[1] endon( "death" );

	level endon( "player_interruption" );
	flag_wait("barn_truck_arrived");

	anim_generic( thugs[0], "hunted_ru1_isadump" );
	thread anim_generic( thugs[0], "laugh1" );
	anim_generic( thugs[1], "laugh2" );
}

dirt_path_disable_truck()
{
	self endon( "death" );

	wait 5;

	self maps\_vehicle::lights_off( "headlights" );

	while ( true )
	{
		playfx( level._effect["truck_smoke"], self gettagorigin( "tag_engine_left" ) );
		wait .5;
	}
}
/**** barn area ****/

area_barn_init()
{
	if ( !flag("player_interruption") )
	{
		autosave_by_name( "barn" );
		level thread set_flag_on_player_action( "player_interruption", true, true);
		level thread glass_shatter_wait();
	}

	flag_set( "aa_barn" );

	level thread barn_early_interruption();

	level thread barn_interrogation_wait();

	level.price thread barn_price_moveup();
	level.mark thread barn_mark_moveup();

	level.steve set_force_color( "r" );
	level.charlie set_force_color( "r" );

	flag_wait( "barn_front_open" );

	waittill_aigroupcleared( "barn_enemies" );

	level.mark disable_ai_color();
	level.price disable_ai_color();
	level.steve disable_ai_color();
	level.charlie disable_ai_color();

	level.price set_goalnode( getnode( "price_barn_exterior", "targetname" ) );
	level.mark set_goalnode( getnode( "mark_barn_exterior2", "targetname" ) );
	level.steve set_goalnode( getnode( "steve_barn_exterior", "targetname" ) );
	level.charlie set_goalnode( getnode( "charlie_barn_exterior", "targetname" ) );

	level.mark waittill( "goal" );
	
	flag_clear( "aa_barn" );

	level thread area_field_init();
}

glass_shatter_wait()
{
	level endon( "kill_action_flag" );
	level endon( "player_interruption" );

	level waittill( "glass_shatter" );
	flag_set( "player_interruption" );
}

barn_interrogation_wait()
{
	level endon( "player_interruption" );
	flag_wait( "barn_interrogation_start" );

	wait 2;

	level notify( "stop_barn_early_interruption" );

	level thread barn_interrogation();
}

barn_interrogation()
{
	anim_ent = getent( "barnfarm_animent","targetname");

	farmer = scripted_spawn( "farmer", "targetname", true );
	farmer.health = 1000000;
	farmer.a.disablePain = true;
	farmer set_battlechatter( false );
	farmer SetFlashbangImmunity( true );
	farmer.grenadeawareness = 0;
	farmer.animname = "farmer";
	farmer set_run_anim( "walk" );
	farmer setthreatbiasgroup( "oblivious" );
	farmer.name = "";

	farmer gun_remove();

	leader = undefined;
	thug = undefined;
	thug2 = undefined;

	axis = getaiarray( "axis" );
	for ( i=0; i<axis.size; i++ )
	{
		if ( isdefined( axis[i].script_noteworthy ) && axis[i].script_noteworthy == "leader" )
			leader = axis[i];
		if ( isdefined( axis[i].script_noteworthy ) && axis[i].script_noteworthy == "thug" )
			thug = axis[i];
		if ( isdefined( axis[i].script_noteworthy ) && axis[i].script_noteworthy == "thug2" )
			thug2 = axis[i];
	}

	assert( isdefined( leader ) && isdefined( thug ) && isdefined( farmer ) );

	leader.animname = "leader";
	thug.animname = "thug";
	thug2.animname = "thug2";

	actors[0] = leader;
	actors[1] = farmer;
	actors[2] = thug;
	actors[3] = thug2;

	setsaveddvar("ai_friendlyFireBlockDuration", 0);

	level thread barn_interrogation_interruption();

	array_thread( actors, ::barn_abort_actors );

	autosave_by_name( "interrogation" );

	farmer thread barn_farmer( anim_ent );
	barn_interrogation_anim( anim_ent, actors, farmer );

	activate_trigger_with_targetname( "barn_ambush_color_init" );
	setthreatbiasgroup_on_array( "axis", get_ai_group_ai( "barn_enemies" ) );

	if ( isalive( farmer ) && flag( "player_interruption" ) )
	{
		farmer set_goalnode( getnode( "hide", "targetname" ) );
		farmer thread delete_on_goal();
		if ( flag( "save_farmer" ) )
			maps\_utility::giveachievement_wrapper("MAN_OF_THE_PEOPLE");
	}
	if ( isalive( leader ) && !flag( "player_interruption" ) )
		leader setthreatbiasgroup( "axis" );

	leader waittill_notify_or_timeout( "damage", 1.5 );

	flag_set( "player_interruption" );
	wait 1;
	flag_set( "interrogation_done" );

	setsaveddvar("ai_friendlyFireBlockDuration", level.ai_friendlyFireBlockDuration );
}

barn_price_dialogue()
{
	level endon( "player_interruption" );
	wait 13;
	flag_set( "save_farmer" );
	wait 2;
	level.price thread anim_single_queue( level.price, "killoldman" );
}

barn_interrogation_interruption()
{
	level endon( "interrogation_done" );
	level endon( "kill_action_flag" );

	flag_wait( "player_interruption" );
	level notify( "interrogation_interrupted" );
}

barn_interrogation_anim( anim_ent, actors, farmer )
{
	level endon( "interrogation_interrupted" );

	door = getent( "farmer_front_door", "targetname" );
	door rotateyaw( 95, 0.7, 0.5, 0.2 );
	door connectpaths();

	anim_ent anim_reach_solo( farmer, "hunted_farmsequence");

	flag_set( "start_scene" );

	level.price thread barn_price_dialogue();

	anim_ent thread anim_single( actors, "hunted_farmsequence");
	actors[0] waittillmatch( "single anim", "fire" );
	level notify( "kill_farmer_thread" );
	thread play_sound_in_space( "hunted_famer_shot", actors[0].origin );
}

barn_abort_actors()
{
	level endon( "interrogation_done" );

	flag_wait( "player_interruption" );

	if ( isdefined( self ) )
	{
		self stopanimscripted();
		self notify( "single anim", "end" );
		self StopSounds();
	}
}

barn_farmer( anim_ent )
{
	level endon( "interrupt_farmer" );
	self endon( "death" );

	self thread barn_farmer_interrupt();

	self set_ignoreSuppression( true );

	self waittillmatch( "single anim", "end" );
	anim_ent thread anim_loop_solo( self, "farmer_deathpose");
	self.a.nodeath = true;
	self.allowdeath = true;
	wait 0.1;
	self die();
}

barn_farmer_interrupt()
{
	level endon( "kill_farmer_thread" );
	flag_wait( "player_interruption" );
	level notify( "interrupt_farmer" );
}

barn_early_interruption()
{
	level endon( "stop_barn_early_interruption" );

	flag_wait( "player_interruption" );

	setthreatbiasgroup_on_array( "axis", get_ai_group_ai( "barn_enemies" ) );

	level.price notify( "end_wait" );

	if ( flag( "barn_interrogation_start" ) )
		return;

	wait 0.5;
	
	array_thread( level.squad, ::set_force_color, "y" );
	activate_trigger_with_targetname( "barn_early_interruption" );

	while( get_ai_group_count( "barn_enemies" ) > 2 )
		wait 0.05;

	level.mark disable_ai_color();
	level.price disable_ai_color();
	level.steve set_force_color( "r" );
	level.charlie set_force_color( "r" );

	if ( !flag( "barn_interrogation_start" ) )
		level.price thread barn_early_interruption_price();
}

barn_early_interruption_price()
{
	self barn_price_move_to_door();
	self barn_price_open_door();
	self price_enter_barn();
}

barn_price_moveup()
{
	self barn_price_move_to_door();

	if ( flag( "player_interruption" ) )
		return;	

	self barn_price_wait_at_door();

	trigger = getent( "barn_rear_trigger", "script_noteworthy" );
	trigger waittill( "trigger" );

	flag_wait( "barn_truck_arrived" );

	if ( flag( "player_interruption" ) )
		return;	

	flag_set( "barn_interrogation_start" );

	self barn_price_open_door();
	self price_enter_barn();
}

price_enter_barn()
{
	self enable_cqbwalk();
	self make_ai_move();
	self set_goalnode( getnode( "price_barn_interior", "targetname" ) );
	self waittill( "goal" );
	self make_ai_normal();
	self disable_cqbwalk();
}

barn_price_move_to_door()
{
	anim_ent = getnode( "price_barn_rear", "targetname" );
	anim_ent anim_reach_solo( self, "hunted_open_barndoor_stop" );
	self waittill( "goal" );
}

barn_price_wait_at_door()
{
	anim_ent = getnode( "price_barn_rear", "targetname" );
	anim_ent anim_single_solo( self, "hunted_open_barndoor_stop" );
	self thread barn_price_wait_at_door_idle();
}

barn_price_wait_at_door_idle()
{
	anim_ent = getnode( "price_barn_rear", "targetname" );
	anim_ent thread anim_loop_solo( self, "hunted_open_barndoor_idle", undefined, "stop_idle" );
	self waittill( "end_wait" );
	anim_ent notify( "stop_idle" );
}

barn_price_open_door()
{
	self notify( "end_wait" );

	anim_ent = getnode( "price_barn_rear", "targetname" );

	if ( !flag( "player_interruption" ) )
		anim_ent thread anim_single_solo( self, "hunted_open_barndoor" );
	else
		anim_ent thread anim_single_solo( self, "hunted_open_barndoor_nodialogue" );

	door = getent( "barn_rear_door","targetname");
	old_angles = door.angles;
	door hunted_style_door_open( "door_wood_slow_creaky_open" );
	flag_set( "barn_rear_open" );

	// close the rear barn door so that the player can't backtrack.
	level thread barn_close_rear_door( door, old_angles );
}

barn_close_rear_door( door, old_angles )
{
	flag_wait( "field_cross" );
	door rotateto( old_angles, 1 );
}

barn_mark_moveup()
{
	node = getnode( "mark_barn_rear", "targetname" );
	level.mark set_goalnode( node );

	flag_wait( "barn_rear_open" );

	node = getnode( "mark_barn_interior", "targetname" );
	self set_goalnode( node );

	if ( !flag( "player_interruption" ) )
	{
		flag_wait( "interrogation_done" );
	}

	level.mark barn_front_door();
	level.mark set_goalnode( getnode( "mark_barn_exterior", "targetname" ) );

	flag_set("barn_front_open");
}

barn_front_door()
{
	self make_ai_move();

	self enable_cqbwalk();

	doors = getentarray( "barn_main_door","targetname");

	anim_ent = getent( "front_door_animent", "targetname" );

	anim_ent anim_reach_solo( self, "door_kick_in" );
	anim_ent thread anim_single_solo( self, "door_kick_in" );
	self waittillmatch( "single anim", "kick" );

	doors[0] playsound( "door_wood_double_kick" );

	for ( i=0; i<doors.size; i++ )
	{
		doors[i] connectpaths();

		if ( doors[i].script_noteworthy == "right" )
			doors[i] rotateto( doors[i].angles + (0,-160,0), .6, 0 , .1 );
		else
			doors[i] rotateto( doors[i].angles + (0,175,0), .75, 0 , .1 );
	}

	self make_ai_normal();
	self disable_cqbwalk();

}

/**** field area ****/

area_field_init()
{
	autosave_by_name( "field" );

	arcademode_checkpoint( 6, 1 );

	flag_set( "aa_field" );

	thread maps\_utility::set_ambient("exterior_level1");

	wait 2;
	level thread field_dialgue();
	thread field_open();

	level thread set_playerspeed( 150, 3 );

	array_thread( level.squad, ::field_allies );
	level thread field_helicopter();
	level thread field_truck();
	level thread field_basement();

	flag_wait( "field_moveon" );
	activate_trigger_with_targetname( "field_defend_color_init" );

	level thread set_playerspeed( 190, 3 );

	flag_wait_or_timeout( "field_basement", 7 );
	autosave_by_name( "field_basement" );

	flag_wait( "basement_open" );

	flag_clear( "aa_field" );

	level thread area_basement_init();
}

field_dialgue()
{
	level.mark thread anim_single_queue( level.mark, "areaclear" );
	level.price thread anim_single_solo_delayed( 1, level.price, "keepmoving" );

	struct = getstruct( "field_go_prone", "script_noteworthy" );
	struct waittill( "trigger" );
	
	flag_set( "hit_the_deck_music" );

	level.price anim_single_queue( level.price, "hitdeck" );

	level.price thread field_stay_down();

	flag_wait_or_timeout( "field_spoted", 23 );

	flag_set( "field_moveon" );

	if ( !flag( "field_spoted" ) )
	{
		level.price anim_single_queue( level.price, "helismoving" );
		flag_wait( "field_truck" );
		level.mark anim_single_queue( level.mark, "contact6oclock" );
		wait 2;
		level.price anim_single_queue( level.price, "returnfire2" );
	}
	else
	{
		level.price anim_single_queue( level.price, "ontous" );
		flag_wait( "field_defend" );
		wait 4.5;
		level.mark anim_single_queue( level.mark, "contact6oclock" );
		level.price anim_single_queue( level.price, "returnfire2" );
	}

	level notify( "kill_action_flag" );

	flag_wait( "field_open_basement" );
	level.price anim_single_queue( level.price, "basementdooropen2" );
	level.mark anim_single_queue( level.mark, "imonit" );

	flag_wait( "basement_open" );

	level.mark anim_single_queue( level.mark, "doorsopen" );
	level.price anim_single_queue( level.price, "getinhouse" );

	if ( !flag( "squad_in_basement" ) )
		level thread field_basement_nag();
}

field_stay_down()
{
	level endon( "field_spoted" );
	wait 2;
	level thread set_flag_on_player_action( "field_spoted", true, true );
	wait 3;
	level.price anim_single_queue( level.price, "staydown" );
}

field_basement_nag()
{
	while( true )
	{
		wait 6;
		if ( flag( "squad_in_basement") )
			return;

		level.price anim_single_queue( level.price, "whatwaitingfor" );

		wait 4;
		if ( flag( "squad_in_basement") )
			return;
	
		level.price anim_single_queue( level.price, "getinbasement" );

		wait 6;
		if ( flag( "squad_in_basement") )
			return;
	
		level.price anim_single_queue( level.price, "getinhouse" );

		wait 4;
	}
}

field_open()
{
	flag_set( "field_open" );
	wait 3.5;
	clip = getent( "field_clip", "targetname" );
	clip delete();
}

field_allies()
{
	ai_name = self.animname;
	
	flag_wait( "field_open" );
	wait randomfloatrange( 0.25, 1 );

	node = getnode( ai_name + "_field_path", "targetname" );
	self set_goalnode( node );

	flag_wait( "field_cross" );
	wait randomfloat(.25);
	self thread follow_path( node );

	flag_wait( "field_cover" );
	self notify("stop_path");
	wait randomfloat(.25);

	old_moveplaybackrate = self.moveplaybackrate;
	self.moveplaybackrate = 1.15;

	node = getnode( ai_name + "_field_cover", "targetname" );
	self field_prone_goal( node );

	anim_ent = self get_prone_ent( node );

	anim_ent anim_reach_solo( self, "hunted_dive_2_pronehide" );
	anim_ent anim_single_solo( self, "hunted_dive_2_pronehide" );
	anim_ent thread anim_loop_solo( self, "hunted_pronehide_idle", undefined, "stop_all_idle" );

	self set_force_color( "r" );

	flag_wait( "field_moveon" );

	self.moveplaybackrate = old_moveplaybackrate;

	anim_ent notify( "stop_all_idle" );
	// the notify to stop the idle stoped notetracks from working in the anim_singe_solo
	waittillframeend;
	anim_ent anim_single_solo( self, "hunted_pronehide_2_stand" );
}

get_prone_ent( node )
{
	ent_array = getentarray( "prone_ent", "targetname" );

	current_vector = vectornormalize( node.origin - self.origin );
	current_angle = vectortoangles( current_vector )[1];

	ent_array = get_array_of_closest( self.origin, ent_array );

	for ( i=0; i<ent_array.size; i++)
	{
		vector = ent_array[i].origin - self.origin;
		angle = vectortoangles( vector  )[1];

		dif_angle = abs( current_angle - angle );
		if ( dif_angle < 22.5 && !isdefined( ent_array[i].inuse ) )
		{
			ent_array[i].inuse = true;
			return ent_array[i];
		}
	}

	assertmsg( "No good prone position could be found." );
	return node;
}

field_prone_goal( node )
{
	self set_goalnode( node );
	self endon( "goal");

	struct = getstruct( "field_go_prone", "script_noteworthy" );
	struct waittill( "trigger" );
}

field_helicopter()
{
	flag_wait( "field_cover");

	helicopter = maps\_vehicle::spawn_vehicle_from_targetname( "field_heli" );
	helicopter sethoverparams(128, 10, 3);

	helicopter maps\_vehicle::show_rigs( 4 ); // back
	helicopter maps\_vehicle::show_rigs( 5 ); // front

	level.helicopter = helicopter;

	wait 0.1;

	assert( isdefined( helicopter.riders ) );
	array_thread( helicopter.riders, ::field_axis );

	helicopter thread heli_path_speed();
	helicopter helicopter_searchlight_on();

	helicopter thread field_helicopter_spot();

	flag_wait_either( "field_spoted", "field_truck" );

	path_struct = getstruct( "field_unload_node", "targetname" );
	helicopter thread heli_path_speed( path_struct );
	helicopter waittill( "unload" );
	flag_set( "field_defend" );
}

field_helicopter_spot()
{
	level endon( "field_spoted" );

	while( true )
	{
		wait 0.1;
		if ( distance2d( level.player.origin, self.dlight.origin ) > 400 )
			continue;
		if ( level.player getstance() != "prone" )
			break;
	}
	flag_set( "field_spoted" );
}


helicopter_setturrettargetent( target_ent )
{
	if ( !isdefined( target_ent ) )
		target_ent = self.spotlight_default_target;

	self.current_turret_target = target_ent;
	self setturrettargetent( target_ent );
}

helicopter_getturrettargetent()
{
	return self.current_turret_target;
}

setup_spot_target()
{
	structs = getstructarray( "spot_target", "script_noteworthy" );
	array_thread( structs, ::spot_target_node );
}

spot_target_node()
{
	while( true )
	{
		self waittill( "trigger", vehicle );		
		links = self get_links();
		assert( isdefined( links ) );
		script_origin = getent( links[0], "script_linkname" );
		vehicle thread spot_target_path( script_origin );
	}
}

spot_target_path( script_origin )
{
	/*
	takes the first script_origin in a path
	speed is units per second.
	script_delay works
	*/

	assert( isdefined( script_origin ) );

	speed = 350;

	// a new spot path terminates the old.
	self notify( "spot_target_path" );
	self endon( "spot_target_path" );

	if ( !isdefined( self.spot_target_ent ) )
		self.spot_target_ent = spawn( "script_model", self.spotlight_default_target.origin );

	target_ent = self.spot_target_ent;
//	target_ent setmodel( "fx" );

	self helicopter_setturrettargetent( target_ent );

	self.spot_target_ent  moveto( script_origin.origin, .5 );
	self.spot_target_ent waittill( "movedone" );

	current_origin = target_ent.origin;

	while ( true )
	{
		if ( isdefined( script_origin.speed ) ) 
			speed = script_origin.speed;

		movespeed = ( distance( script_origin.origin, current_origin ) / speed ) + 0.1;

		if ( isdefined( script_origin.radius ) )
			target_ent.spot_radius = script_origin.radius;
		else
			target_ent.spot_radius = undefined;

		target_ent moveto( script_origin.origin, movespeed );
		target_ent waittill( "movedone" );
		script_origin script_delay();

		if ( isdefined( script_origin.script_flag_wait ) )
			flag_wait( script_origin.script_flag_wait );

		if ( !isdefined( script_origin.target ) )
				break;

		current_origin = script_origin.origin;
		script_origin = getent( script_origin.target, "targetname" );
	}

	self helicopter_setturrettargetent( self.spotlight_default_target );
	self.spot_target_ent delete();
}

spot_target_path_end()
{
	self notify( "spot_target_path" );
	self endon( "spot_target_path" );

	while ( isdefined( self.spot_target_ent ) && distance2d( self.spot_target_ent.origin, self.spotlight_default_target.origin ) > 100 )
	{
		self.spot_target_ent  moveto( self.spotlight_default_target.origin, 1 );
		self.spot_target_ent waittill( "movedone" );
	}

	self helicopter_setturrettargetent( self.spotlight_default_target );
	if ( isdefined( self.spot_target_ent ) )
		self.spot_target_ent delete();
}

setup_tmp_detour_node()
{
	delete_nodes = getstructarray( "tmp_detour_node", "script_noteworthy" );
	array_thread( delete_nodes, ::tmp_detour_node );
}

tmp_detour_node()
{
	while ( true )
	{
		self waittill( "trigger", vehicle );
		path_struct = getstruct( "tmp_detour_node2", "script_noteworthy" );
		vehicle thread heli_path_speed( path_struct );
	}
}

setup_helicopter_delete_node()
{
	delete_nodes = getstructarray( "delete_helicopter", "script_noteworthy" );
	array_thread( delete_nodes, ::helicopter_delete_node );
}

helicopter_delete_node()
{
	while ( true )
	{
		self waittill( "trigger", vehicle );
		vehicle delete();
	}
}

field_flyby_speed()
{
	pos1 = level.player.origin;
	wait 2;
	pos2 = level.player.origin;
	dist = distance( pos1, pos2 );

	if ( dist < 250 )
		alloted_time = 9;
	else
		alloted_time = 7;

	dist = distance( self.origin, level.player.origin );
	MPH = dist / alloted_time / 17.6;

	accel = MPH/2;
	if ( accel < 30 )
		accel = 30;

	self setspeed( MPH, accel );
}

field_truck()
{
	flag_wait( "field_moveon" );

	if ( flag( "field_spoted" ) )
		wait 3;

	truck = maps\_vehicle::spawn_vehicle_from_targetname( "field_truck" );
	thread maps\_vehicle::gopath ( truck );

	wait 0.1;

	assert( isdefined( truck.riders ) );
	array_thread( truck.riders, ::field_axis );

	truck maps\_vehicle::lights_on( "headlights" );

	truck waittill( "unload" );

	ai = get_closest_ai( truck.origin , "axis" );
	anim_generic( ai, "bythehouse" );
	flag_set( "field_truck" );
}

field_axis()
{
	if ( !issentient( self ) )
		return;

	self endon( "death" );
	self setthreatbiasgroup( "oblivious" );

	self waittill( "jumpedout" );
	self setthreatbiasgroup( "axis" );

	battlechatter_on( "allies" );
	battlechatter_on( "axis" );

	self waittill( "goal" );
	flag_wait( "field_basement" );

	wait randomfloatrange( 4, 9 ) * 3; // 12 to 28 seconds wait.
	self set_goalnode( getnode( "field_attack_node", "targetname" ) );

	volume = getent( "basement_building", "targetname" );
	trigger = getent( "field_basement", "targetname" );
	trigger2 = getent( "stair_volume", "targetname" );

	flag_wait( "basement_door_open" );

	while ( level.player istouching( volume ) || level.player istouching( trigger ) || level.player istouching( trigger2 ) )
		wait 0.5;

	self setgoalentity( level.player );
	self.health = self.health * 2;
	self.baseAccuracy = 2;

	flag_wait( "basement_door_open" );

	self clearenemy();
	self.baseAccuracy = 1;
}

field_basement()
{

	if ( !flag( "field_spoted" ))
	{
		flag_wait( "field_defend" );
		wait 8;
	}
	else
	{
		flag_wait( "field_truck" );
		wait 4;
	}

	flag_set( "field_open_basement" );
	wait 2;

	level.mark make_ai_move();
	setsaveddvar("ai_friendlyFireBlockDuration", 0);

	anim_ent = getentarray( "basement_animent", "targetname" )[0];

	anim_ent anim_reach_solo( level.mark, "hunted_open_basement_door_kick" );
	anim_ent thread anim_single_solo( level.mark, "hunted_open_basement_door_kick" );
	
	getent( "basement_player_block", "targetname" ) notsolid();

	flag_set( "basement_door_open" );

	level.mark make_ai_normal();
	level.mark enable_ai_color();
}

#using_animtree("door");
setup_basement_door()
{
	getent( "field_basement_door_open_clip", "targetname" ) notsolid();
	door = getent( "basement_door", "targetname" );
	door thread field_basement_door();

	level thread door_pusher();

	door = getent( "basement_inner_door", "targetname" );
	base_origin = getent( door.target, "targetname" );
	door.handle = getent( "basement_door_handle", "targetname" );
	door.handle linkto( door );
	door.origin = base_origin.origin;
}

door_pusher()
{
	pusher = getent( "door_pusher", "targetname" );
	end_pos = getent( pusher.target, "targetname" );
	volume = getent( "basement_door_volume", "targetname" );

	pusher notsolid();

	flag_wait( "basement_door_open" );
	wait 8.2;
	if ( !level.player istouching( volume ) )
		return;
	pusher solid();
	pusher moveto( end_pos.origin, 1 );
	wait 2;
	pusher delete();
}

field_basement_door()
{
	anim_ent = getent( "basement_animent", "targetname" );
	start_origin = getstartorigin( anim_ent.origin, anim_ent.angles, %hunted_open_basement_door_kick_door );
	start_angles = getstartangles( anim_ent.origin, anim_ent.angles, %hunted_open_basement_door_kick_door );

	self.angles = start_angles;
	self.origin = start_origin;

	self useanimtree( #animtree );

	self.animname = "door";
	level.scr_anim[ "door" ][ "door_kick_door" ] =		%hunted_open_basement_door_kick_door;

	anim_ent anim_first_frame_solo( self, "door_kick_door" );
		
	flag_wait( "basement_door_open" );

	self thread field_basement_door_sound();

	self SetFlaggedAnim( "door_anim", %hunted_open_basement_door_kick_door );
	time = getanimlength( %hunted_open_basement_door_kick_door );
	wait time-1;

	clip = getent( self.target, "targetname" );
	clip connectpaths();

	clip delete();

	flag_set( "basement_open" );

	volume = getent( "basement_door_volume", "targetname" );
	while ( level.player istouching( volume ) )
		wait 0.1;

	getent( "field_basement_door_open_clip", "targetname" ) solid();
}

field_basement_door_sound()
{
	level.mark waittillmatch( "single anim", "kick" );
	self playsound( "scn_hunted_cellar_door_open" );
}

/**** basement area ****/
#using_animtree("generic_human");
area_basement_init()
{
	flag_set( "aa_basement" );

	level.price thread basement_price();
	level thread basement_allies();
	level thread basement_helicopter();
	level thread basement_trim_field();
	level thread basement_flash();

	flag_wait( "basement_secure" );
	autosave_by_name( "basement" );

	battlechatter_off( "allies" );

	flag_wait( "farm_start" );

	flag_clear( "aa_basement" );

	level thread area_farm_init();
}

basement_allies()
{
	volume = getent( "basement_building", "targetname" );
	volume2 = getent( "stair_volume", "targetname" );

	array_thread( level.squad, ::make_ai_move );
	array_thread( level.squad, ::set_grenadeawareness, 0 );

	activate_trigger_with_targetname( "basement_color_init" );

	tmp_array = array_remove( level.squad, level.price );
	tmp_array = array_add( tmp_array, level.player );

	loop_count = 0;

	for ( touching = false; !touching; )
	{
		loop_count++;
		if ( loop_count > ( 12 / 0.05 ) && !level.player istouching(volume) && !level.player istouching(volume2) ) // 20 seconds until death 
			level.player magic_kill();

		touching = true;
		for ( i=0; i<tmp_array.size; i++)
		{
			if( !tmp_array[i] istouching( volume ) )
				touching = false;
		}
		wait 0.05;
	}

	if ( flag( "heli_field_stragler_attack" ) )
	{
		path_struct = getstruct( "heli_basement_restart_path", "targetname" );
		level.helicopter thread deactivate_heli_guy();
		level.helicopter thread heli_path_speed( path_struct );
	}			

	flag_set( "squad_in_basement" );

	flag_wait( "basement_secure" );

	array_thread( level.squad, ::make_ai_normal );
	array_thread( level.squad, ::set_grenadeawareness );
	array_thread( level.squad, ::make_walk );

	flag_wait( "farm_start" );
	level notify( "stop_walk");

}

basement_price()
{
	self disable_ai_color();

	old_awareness = self.grenadeawareness;
	self.grenadeawareness = 0;
	self set_goalnode( getnode( "basement_enter_price", "targetname" ) );

	flag_wait( "squad_in_basement" );

	player_block = getent( "basement_player_block", "targetname" );
	player_block solid();

	anim_ent = getentarray( "basement_animent", "targetname" )[0];
	anim_ent anim_reach_solo( self, "hunted_basement_door_block" );
	anim_ent thread anim_single_solo( self, "hunted_basement_door_block" );

	door = getent( "basement_inner_door", "targetname" );

	self thread basement_door_sound( door );

	wait 1;

	door notsolid();
	door rotateyaw( -180, 1.5, .25, 0 );
	door waittill( "rotatedone" );
	door solid();
	door disconnectpaths();

	wait 0.5;
	door.handle unlink();
	door.handle rotatepitch( 130, 0.35 );

	self set_force_color( "y" );

	flag_set( "basement_secure" );

	player_block delete();

	wait 1;
	self thread anim_single_queue( self, "takepoint" );

	self.grenadeawareness = old_awareness;

	flag_wait( "farm_start" );
}

basement_door_sound( door )
{
	self  waittillmatch( "single anim", "scn_hunted_metal_door_closed" );
	door playsound( "scn_hunted_metal_door_closed" );
}

basement_helicopter()
{
	helicopter = level.helicopter;

	flag_wait( "basement_door_open" );

	path_struct = getstruct( "heli_basement_path", "targetname" );

	helicopter thread heli_path_speed( path_struct );
	helicopter deactivate_heli_guy();

}

basement_trim_field()
{
	flag_wait ( "trim_field" );

	axis = getaiarray( "axis" );
	axis = array_exclude( axis, get_ai_group_ai( "basement_field_guy" ) );

	if ( axis.size < 4 )
		activate_trigger_with_targetname( "field_clear_killspawner" );

	for ( i=0; i<axis.size; i++ )
		axis[i] delete();

	while( !flag( "basement_flash" ) && get_ai_group_count( "basement_field_guy" ) > 3 )
		wait 0.05;

	axis = get_ai_group_ai( "basement_field_guy" );
	node = getnode( "field_retreat_node", "targetname" );
	array_thread( axis, ::set_goalnode, node );
	array_thread( axis, ::delete_on_goal );
}

basement_flash()
{
	flag_wait( "basement_flash" );

	scripted_array_spawn( "basement_flash_guy", "targetname", true );

	wait 2;

	axis = getaiarray( "axis" );
	array_thread( axis, ::flash_immunity, 2 );

	if ( isdefined( axis[0] ) )
	{
		flash_guy = axis[0];
		oldGrenadeWeapon = flash_guy.grenadeWeapon;
		flash_guy.grenadeWeapon = "flash_grenade";
		flash_guy.grenadeAmmo++;

		ent = getent( "enemy_flash_bang", "targetname" );
		ent2 = getent( ent.target, "targetname" );

		flash_guy magicgrenade( ent.origin, ent2.origin, 1 );
		flash_guy.grenadeWeapon = oldGrenadeWeapon;
	}

	level.mark thread anim_single_queue( level.mark, "warn_flashbang" );

	while( !flag( "farm_start" ) && get_ai_group_count( "basement_flash_guy" ) )
		wait 0.05;

	flag_set( "farm_start" );

	axis = get_ai_group_ai( "basement_flash_guy" );
	for ( i=0; i<axis.size; i++ )
	{
		axis[i] setgoalentity( level.player );
	}
}

/**** farm area ****/
area_farm_init()
{
	flag_set( "aa_farm" );

	arcademode_checkpoint( 6, 2 );

	setsaveddvar("ai_friendlyFireBlockDuration", level.ai_friendlyFireBlockDuration );

	setculldist( 12000 );

	array_thread( getentarray( "farm_dog", "script_noteworthy" ), ::add_spawn_function, ::farm_dog_spawn_function );
	array_thread( getentarray( "farm_forerunners", "script_noteworthy" ), ::add_spawn_function, ::farm_forerunners );
	array_thread( getentarray( "farm_defenders", "script_noteworthy" ), ::add_spawn_function, ::farm_defenders );

	level thread farm_enemies_timer();
	level thread farm_dialogue();
	level thread farm_push();

	level.player.maxflashedseconds = 3;

	level.price set_force_color( "y" );
	level.mark set_force_color( "y" );
	level.steve set_force_color( "r" );
	level.charlie set_force_color( "r" );

	wait 1;

	activate_trigger_with_targetname( "farm_color_init" );

	flag_wait( "farm_alert" );

	battlechatter_on( "allies" );
	battlechatter_on( "axis" );

	autosave_by_name( "dogs" );

	cistern_color_trigger = getent( "cistern_color_trigger", "script_noteworthy" );
	if ( isdefined( cistern_color_trigger ) )
		cistern_color_trigger trigger_off();

	activate_trigger_with_targetname( "farm_advance_color_init" );

	level thread farm_clear_enemies();

	waittill_aigroupcleared( "farm_forerunners" );
	waittill_aigroupcleared( "farm_defenders" );

	flag_set( "farm_clear");

	farm_color_trigger = getentarray( "farm_color_trigger", "script_noteworthy" );
	array_thread( farm_color_trigger, ::trigger_off );

	activate_trigger_with_targetname( "farm_cleared_color_init" );

	flag_clear( "aa_farm" );

	level thread area_creek_init();	
}

farm_push()
{
	level endon( "farm_clear");

	ai = 100;
	while( ai > 4 )
	{
		ai = get_ai_group_count( "farm_forerunners" );
		ai += get_ai_group_count( "farm_defenders" );
		wait 1;
	}
	activate_trigger_with_targetname( "farm_push_color_init" );
}


dynamic_dog_threat()
{
	// Makes dogs less likely to be shot by allies.
	// until the player is being eaten by a dog.

	while( true )
	{
		setthreatbias( "dogs", "allies", -4000 );
		level.player waittill( "dog_attacks_player" );
		setthreatbias( "dogs", "allies", 0 );
		level.player waittill( "player_saved_from_dog" );
	}
}
farm_enemies_timer()
{
	trigger = getent( "farm_enemies", "script_noteworthy" );
	trigger endon( "trgger" );

	flag_wait( "farm_enemies_timer" );

	wait randomfloatrange( 13, 17 );
	activate_trigger_with_noteworthy( "farm_enemies" );
	activate_trigger_with_noteworthy( "farm_enemy_dogs" );
}

farm_dialogue()
{
	trigger = getent( "quiet_dialogue" , "targetname" );
	trigger waittill( "trigger" );

	level.charlie anim_single_queue( level.charlie, "tooquiet" );
	level.mark anim_single_queue( level.mark, "regrouping" );
	wait 2;
	level.price thread anim_single_queue( level.price, "staysharp" );
	autosave_by_name( "farm" );
}

farm_forerunners()
{
	self endon( "death" );

	if ( randomint(100) > 60 )
		self.grenadeWeapon = "flash_grenade";

	while ( 3 < get_ai_group_count( "farm_forerunners" ) )
		wait 0.1;

	self set_goalvolume( "farm_volume" );

	flag_set( "farm_alert" );
}

farm_defenders()
{
	self endon( "death" );

	if ( randomint(100) > 60 )
		self.grenadeWeapon = "flash_grenade";

	while ( 4 < get_ai_group_count( "farm_defenders" ) )
		wait 0.1;

	self set_goalvolume( "farm_volume" );
}

farm_dog_spawn_function()
{
	self endon( "death" );

	if ( !isdefined( level.farm_dogs ) )
	{
		level.farm_dogs = [];
		level thread farm_dogs_delete();
	}

	level.farm_dogs[ level.farm_dogs.size ] = self;
	
	if ( level.farm_dogs.size == 3 )
		level notify( "dogs_loaded" );

	if ( isdefined( self.target ) )
		self waittill( "goal" );

	self setgoalentity( level.player );
	self.goalradius = 300;

}

farm_dogs_delete()
{
	level waittill( "dogs_loaded" );

	level.farm_dogs = array_randomize( level.farm_dogs );

	switch( level.gameSkill )
	{
		case 0:
			dogs = 2;
			break;
		case 1:
			dogs = 2;
			break;
		default:
			dogs = 3;
			break;
	} 

	for ( i=0; i<level.farm_dogs.size; i++ )
	{
		if ( i < dogs)
			continue;
		level.farm_dogs[i] delete();
	}
}

farm_clear_enemies()
{
	trigger = getent( "farm_clear_enemies", "targetname" );
	trigger waittill( "trigger" );
	
	axis1 = get_ai_group_ai( "farm_forerunners" );
	axis2 = get_ai_group_ai( "farm_defenders" );
	axis = array_combine( axis1, axis2 );
	volume = getent( "farm_volume", "targetname" );

	for ( i=0; i<axis.size; i++ )
	{
		if ( axis[i] istouching( volume ) )
				continue;
		axis[i] setgoalentity( level.player );
		axis[i].goalradius = 450;
	}
}

area_creek_init()
{
	autosave_by_name( "creek" );

	flag_set( "aa_creek" );

	arcademode_checkpoint( 5, 3 );

	battlechatter_off( "allies" );
	battlechatter_off( "axis" );

	flag_clear( "player_interruption" );

	spawner_array = getentarray( "creek_bridge_guy", "script_noteworthy" );
	array_thread( spawner_array, ::add_spawn_function, ::creek_bridge_guy );

	array_thread( getnodearray( "patroll_animation", "script_noteworthy"), ::creek_guard_node );

	flag_wait( "creek_helicopter");

	level thread set_playerspeed( 130, 6 );
	level.player thread player_sprint_check();

	level thread creek_axis_dialogue();
	level thread creek_dialogue();
	level thread creek_truck();
	level thread creek_helicopter();
	level thread creek_gate();

	level thread creek_cqb_setup();

	flag_wait( "creek_truck_on_bridge" );

	level thread set_flag_on_player_action( "player_interruption", true, true );

	flag_wait_either( "road_start", "player_interruption" );

	flag_clear( "aa_creek" );

	level thread area_road_init();
}

creek_gate()
{
	wait 6;

	gate = getent( "creek_gate", "targetname" );
	anim_ent = getent( "creek_gate_animent", "targetname" );

	level.price disable_ai_color();
	activate_trigger_with_targetname( "creek_gate_color_init" );

	anim_ent anim_reach_solo( level.price, "hunted_open_creek_gate" );
	anim_ent anim_single_solo( level.price, "hunted_open_creek_gate_stop" );
	anim_ent thread anim_single_solo( level.price, "hunted_open_creek_gate" );
	level.price enable_cqbwalk();

	flag_set( "creek_gate_open" );

	old_angles = gate.angles;
	gate hunted_style_door_open( "door_gate_chainlink_slow_open" );

	level.price set_force_color( "y" );
	level.price waittill( "done_setting_new_color" );

	activate_trigger_with_targetname( "creek_color_init" );

	flag_wait( "creek_bridge" );

	// close gate to stop the player from falling back.
	gate rotateto( old_angles, .1 );
	gate waittill( "rotatedone");
}

creek_dialogue()
{
	wait 6;
	level.mark anim_single_queue( level.mark, "helicoptersback" );
	wait 3;
	level.price anim_single_queue( level.price, "keepitthatway" );

	flag_wait( "creek_gate_open" );
	wait 0.5;
	level.price anim_single_queue( level.price, "presson" );

	level endon( "player_interruption" );

	heli_node = getstruct( "creek_heli_warning", "script_noteworthy" );
	heli_node waittill( "trigger" );

	level.price thread anim_single_queue( level.price, "sentriesatbridge" );
}

creek_truck()
{
	flag_wait( "creek_start" );
	
	truck = maps\_vehicle::spawn_vehicle_from_targetname( "creek_truck" );
	thread maps\_vehicle::gopath ( truck );
	truck maps\_vehicle::lights_on( "headlights" );
	truck maps\_vehicle::godon();

	truck waittill( "unload" );
	flag_set( "creek_truck_on_bridge" );
}

creek_helicopter()
{
	wait 3;

	helicopter = maps\_vehicle::spawn_vehicle_from_targetname( "creek_heli" );
	helicopter sethoverparams(128, 35, 25);

	wait 0.1;

	for ( i=0; i<helicopter.riders.size; i++ )
	{
		helicopter.riders[i] setthreatbiasgroup ( "oblivious" );
	}

	level.helicopter = helicopter;

	helicopter thread heli_path_speed();
	helicopter helicopter_searchlight_on();

	flag_wait( "creek_bridge" );

	path_struct = getstruct( "creek_flyover_struct", "targetname" );
	
	helicopter thread heli_path_speed( path_struct );
}

creek_bridge_guy()
{
	self endon( "death" );
	self notify( "stop_going_to_node" );

	self setthreatbiasgroup( "oblivious" );
	self thread magic_bullet_shield();

	self.animname = "axis";

	self.disableArrivals = true;
	self set_run_anim( "patrolwalk_" + ( randomint(5) + 1 ) );
	self.alwaysRunForward = true;

	self waittill( "jumpedout" );

	path_node = getnode( self.target, "targetname" );
	self thread follow_path( path_node, true );

	wait 2;

	self attach_flashlight( true );
	self thread road_axis_interrupt();

	wait 5;
	self stop_magic_bullet_shield();

	level endon( "player_interruption" );

	flag_wait( "road_field_end" );

	wait randomfloatrange( 5, 10 );

	self notify( "stop_interrupt" );
	node = getnode( "road_delete_node", "targetname" );
	self set_goalnode( node );
	self thread delete_on_goal();
}

creek_axis_dialogue()
{
	level endon( "road_field_clear" );

	flag_wait( "player_interruption" );

	ai = get_closest_ai( level.player.origin, "axis" );

	if ( !flag( "road_field_search" ) )
	{
		anim_generic( ai, "hunted_ru2_bythecreek" );
		wait randomfloat( 3 ) + 2;
	}

	ai = get_closest_ai( level.player.origin, "axis" );
	anim_generic( ai, "hunted_ru1_inthefield" );
	wait randomfloat( 3 ) + 2;

	ai = get_closest_ai( level.player.origin, "axis" );
	anim_generic( ai, "hunted_ru4_outonfield" );
}

creek_guard_node()
{
	level endon( "player_interruption" );

	while ( true )
	{
		self waittill( "trigger", ai);

		self thread interrupt_guard_node( ai );
		self anim_single_solo( ai, self.script_animation );

		self notify( "guard_anim_done" );
	}
}

interrupt_guard_node( ai )
{
	ai endon( "death" );
	self endon( "guard_anim_done" );

	level waittill( "player_interruption" );

	ai stopanimscripted();
	ai notify( "single anim", "end" );
}

creek_cqb_setup()
{
	array_thread( getentarray( "creek_cqb_start", "targetname" ), ::creek_cqb_start );
	array_thread( getentarray( "creek_cqb_end", "targetname" ), ::creek_cqb_start );
}

creek_cqb_start()
{
	while( true )
	{
		self waittill( "trigger", guy );
		guy thread ignore_triggers( 1 );
		guy enable_cqbwalk();
	}	
}

creek_cqb_end()
{
	while( true )
	{
		self waittill( "trigger", guy );
		guy thread ignore_triggers( 1 );
		guy disable_cqbwalk();
	}	
}

area_road_init()
{
	flag_set( "aa_second_field" );

	level thread road_allies();
	level thread road_axis();
	level thread road_helicopter();
	level thread road_reset_speed();
	level thread road_field_cleanup();
	level thread road_field_clear();

	if ( !flag( "player_interruption" ) )
	{
		autosave_by_name( "road" );
		level thread road_field();
		level thread road_roadblock();
	}
	else
	{
		battlechatter_on( "allies" );
		battlechatter_on( "axis" );
		flag_wait( "road_start" );
		flag_set( "road_open_field" );
	}

	flag_wait( "greenhouse_area" ) ;

	if ( !flag( "player_interruption" ) )
		flag_set( "player_interruption" );

	flag_wait( "road_field_clear" );

	flag_clear( "aa_second_field" );

	level thread area_greenhouse_init();
}

road_field_clear()
{
	while ( get_ai_group_count( "road_group" ) > 3 )
		wait 0.1;

	flag_set( "road_field_clear_helicopter" );
	wait 0.5;
	waittill_aigroupcleared( "road_group" );
	flag_set( "road_field_clear" );
}

road_field_cleanup()
{
	flag_wait( "road_field_cleanup" );

	node = getnode( "road_field_cleanup_node", "targetname" );
	axis = get_ai_group_ai( "road_group" );
	array_thread( axis, ::disable_ai_color );
	array_thread( axis, ::set_goalnode, node );
	array_thread( axis, ::delete_on_goal );

	flag_set( "road_field_clear_helicopter" );
	wait 0.5;
	flag_set( "road_field_clear" );
}

road_reset_speed()
{
	flag_wait( "player_interruption" );
	level thread set_playerspeed( 190, 6 );
}

road_helicopter()
{
	level thread road_helicopter_clear();
	flag_wait( "player_interruption" );

	wait 2;

	level.helicopter notify("stop_path");

	setthreatbias( "player", "heli_guy", 10000 );
	setthreatbias( "heli_guy", "player", 20000 );

	if ( level.gameskill > 1 && !flag( "road_field_clear_helicopter" ) )
	{
		level.heli_guy_accuracy = 2;
		level.heli_guy_health_multiplier = 1;
		level.heli_guy_respawn_delay = 10;
		level.helicopter thread activate_heli_guy();
	}
	else
	{
		level.heli_guy_accuracy = 2;
		level.heli_guy_health_multiplier = 0.8;
		level.heli_guy_respawn_delay = 10;
	}

	// get in position for the fight faster
	level.helicopter heli_path_speed( getstruct( "road_heli_start", "targetname" ) );

	if ( !flag( "road_field_clear_helicopter" ) )
	{
		level.helicopter thread helicopter_attack( 15, "attack_helicopter" );
		wait 4;
	}

	if ( level.gameskill < 2 && !flag( "road_field_clear_helicopter" ) )
		level.helicopter thread activate_heli_guy();

	level.price anim_single_queue( level.price, "watchhelicopter" );
}

road_helicopter_clear()
{
	flag_wait( "road_field_clear_helicopter" );

	level.helicopter stop_helicopter_attack();
	level.helicopter deactivate_heli_guy();
	level.helicopter spot_target_path_end();
	level.helicopter thread heli_path_speed( getstruct( "greenhouse_startpath", "targetname" ) );

	flag_set( "road_helicopter_cleared" );
}

road_field()
{
	flag_wait_or_timeout( "player_interruption", 8 );
	flag_set( "road_open_field" );
}

road_allies()
{
	level endon( "road_field_cleanup" );

	flag_wait( "road_open_field" );

	for( i = 0 ; i < level.squad.size ; i ++ )
	{
		level.squad[i] pushplayer( true );
	}

	road_bridge_wait();

	flag_set( "roadblock" );

	wait 2;

	if ( !flag( "player_interruption" ) )
	{
		level.price thread anim_single_queue( level.price, "staylow" );
		level thread road_allies_exposed();
	}
	else
		level.price anim_single_queue( level.price, "moveit" );

	activate_trigger_with_targetname( "road_color_stage_1" );

	wait 1;
	level.price waittill( "goal" );
	wait 6;

	activate_trigger_with_targetname( "road_color_stage_2" );

	wait 1;
	level.price waittill( "goal" );
	wait 6;

	activate_trigger_with_targetname( "road_color_stage_3" );

	wait 1;
	level.steve waittill( "goal" );
	flag_wait( "road_field_search" ) ;
	wait 4;

	activate_trigger_with_targetname( "road_color_stage_4" );

	wait 1;
	level.price waittill( "goal" );
	wait 2;

	activate_trigger_with_targetname( "road_color_stage_5" );

	flag_set( "road_field_end" );

	level.price waittill( "goal" );

	flag_wait( "player_interruption" ) ;
	while ( get_ai_group_count( "road_group" ) > 4 )
		wait 0.05;

	activate_trigger_with_targetname( "road_color_stage_6" );

	for( i = 0 ; i < level.squad.size ; i ++ )
	{
		level.squad[i] pushplayer( false );
	}
}

road_allies_exposed()
{
	flag_wait( "player_interruption" );

	battlechatter_on( "axis" );

	wait 2;

	level.mark anim_single_queue( level.mark, "hunted_uk2_werecompromised" );

	if ( !flag( "road_field_end" ) )
		level.price anim_single_queue( level.price, "endoffield" );


	battlechatter_on( "allies" );
}

road_bridge_wait()
{
	level endon( "player_interruption" );
	level endon( "roadblock" );

	if ( flag( "player_interruption" ) )
		return;

	bridge_volume = getent( "bridge_volume", "targetname" );

	level.price anim_single_queue( level.price, "outofspotlight" );

	wait 2;
}

road_axis()
{
	flag_wait( "roadblock" );

	if ( !flag( "player_interruption" ) )
	{
		array_thread( getentarray( "road_idle_guy", "targetname" ), ::add_spawn_function, ::road_idle_guy );
		array_thread( getentarray( "road_guy", "targetname" ), ::add_spawn_function, ::road_guy );
		road_guys = scripted_array_spawn( "road_idle_guy", "targetname", true );
		road_guys = scripted_array_spawn( "road_guy", "targetname", true );
	}
	else
	{
		array_thread( getentarray( "road_idle_guy", "targetname" ), ::add_spawn_function, ::road_guy_attack );
		array_thread( getentarray( "road_guy", "targetname" ), ::add_spawn_function, ::road_guy_attack );
		road_guys = scripted_array_spawn( "road_guy", "targetname", true );
		wait 10;
		road_guys = scripted_array_spawn( "road_idle_guy", "targetname", true );
	}
}

road_guy_attack()
{
	self notify( "stop_going_to_node" );
	self set_force_color( "p" );
}

road_guy()
{
	self endon( "death" );
	level endon( "player_interruption" );

	self setthreatbiasgroup( "oblivious" );
	self.disableArrivals = true;
	self.alwaysRunForward = true;

	self.animname = "axis";
	self set_run_anim( "patrolwalk_" + ( randomint(5) + 1 ) );

	self attach_flashlight( true );

	self thread road_axis_interrupt();

	self notify( "stop_going_to_node" );
	path_node = getnode( self.target, "targetname" );
	self thread follow_path( path_node, true );

	self waittill( "path_end_reached" );

	flag_set( "player_interruption" );
}

road_idle_guy()
{
	level endon( "player_interruption" );

	self setthreatbiasgroup( "oblivious" );
	self.disableArrivals = true;

	self.animname = "axis";
	self set_run_anim( "patrolwalk_nolight" );
	self thread road_axis_interrupt();
	self.alwaysRunForward = true;

	flag_wait( "road_field_search" );

	wait randomfloat( 20 );

	self notify( "stop_interrupt" );
	node = getnode( "road_field_cleanup_node", "targetname" );
	self set_goalnode( node );
	self thread delete_on_goal();
}

road_roadblock()
{
	level endon( "player_interruption" );

	flag_wait( "roadblock" );

	actors = scripted_array_spawn( "roadblock_guy", "script_noteworthy", true );
	level thread road_roadblock_anim( actors );

	start_vnode = getvehiclenode( "roadblock_start", "script_noteworthy" );
	stop_vnode = getvehiclenode( "roadblock_stop", "script_noteworthy" );

	sedan = maps\_vehicle::spawn_vehicle_from_targetname( "road_pickup" );
	thread maps\_vehicle::gopath ( sedan );

	start_vnode waittill( "trigger" );

	flag_set( "roadblock_start" );

	stop_vnode waittill( "trigger" );

	sedan setspeed( 0, 15 );
	
	flag_wait( "roadblock_done" );

	sedan resumespeed( 35 );
}

road_roadblock_anim( actors )
{
	level endon( "player_interruption" );

	nodes = getnodearray( "roadblock_path", "targetname" );
	actors[0] thread road_roadblock_guy( "guard1", nodes[1] );
	actors[1] thread road_roadblock_guy( "guard2", nodes[0] );

	anim_ent = getent( "roadblock_animent", "targetname" );

	level thread road_roadblock_interrupt( actors, anim_ent );

	anim_ent anim_reach( actors, "roadblock_sequence" );

	if ( !flag( "roadblock_start" ) && !flag( "player_interruption" ) )
		anim_ent anim_loop( actors, "roadblock_startidle", undefined, "stop_idle" );

	flag_wait( "roadblock_start" );

	anim_ent notify( "stop_idle" );

	anim_ent anim_single( actors, "roadblock_sequence" );

	flag_set( "roadblock_done" );
}

road_roadblock_interrupt( actors, anim_ent )
{
	flag_wait( "player_interruption" );

	anim_ent notify( "stop_idle" );

	if ( !flag( "roadblock_start" ) )
		return;

	actors[0] stopanimscripted();
	actors[0] notify( "single anim", "end" );
	actors[1] stopanimscripted();
	actors[1] notify( "single anim", "end" );

	flag_set( "roadblock_done" );
}

road_roadblock_guy( animname, path_node )
{
	self endon( "death" );
	level endon( "player_interruption" );

	self.animname = animname;
	self.disableArrivals = true;
	self set_run_anim( "patrolwalk" );
	self setthreatbiasgroup( "oblivious" );
	
	self attach_flashlight( true );

	self thread road_axis_interrupt();

	flag_wait( "roadblock_done" );
	self.disableArrivals = true;
	self.animname = "axis";
	self thread follow_path( path_node, true );
}

road_axis_interrupt()
{
	self endon( "death" );
	self endon( "stop_interrupt" );

	self thread road_axis_proximity();

	flag_wait( "player_interruption" );

	if ( !self.spotter )
		wait randomfloat( 2 ) + 0.5;

	self notify( "stop_path" );
	self flashlight_light( false );
	self.disableArrivals = false;
	self clear_run_anim();
	self.alwaysRunForward = undefined;

	self setthreatbiasgroup( "axis" );
	self set_force_color( "p" );

	self detach_flashlight();
}

road_axis_proximity()
{
	level endon( "player_interruption" );
	self endon( "death" );

	self.spotter = false;

	wait randomfloat(1);

	while ( true )
	{
		fov = cos( 65 );
		wait 0.25;
		dist = distance2d( level.player.origin, self.origin );

		if ( dist > 1000 )
			continue;

		if ( dist < 400 && level.player getstance() != "prone" )
			fov = cos( 120 );

		if ( dist < 900 && flag( "player_sprint" ) )
		{
			self.spotter = true;
			flag_set( "player_interruption" );
		}

		if ( !within_fov( self.origin, self.angles, level.player.origin, fov ) )
			continue;

		min_visible = dist / 1000;

		if ( min_visible > level.player scripted_sightconetrace( self geteye() , self ) )
			continue;

		self.spotter = true;
		flag_set( "player_interruption" );
	}
}

area_greenhouse_init()
{
	flag_set( "aa_greenhouse" );

	arcademode_checkpoint( 6, 4 );

	for( i = 0 ; i < level.squad.size ; i ++ )
	{
		level.squad[i] pushplayer( false );
	}

	flag_wait( "road_helicopter_cleared" );

	level.helicopter thread helicopter_attack( 8, "greenhouse_attack_helicopter" );

	activate_trigger_with_targetname( "greenhouse_color_init" );

	level thread greenhouse_heli_light_off();
	level thread greenhouse_stinger();
	level thread greenhouse_fake_target();
	level thread greenhouse_barn_door();
	level thread infinite_stinger();

	flag_wait( "road_field_cleanup" );
	autosave_by_name( "greenhouse" );

	flag_wait( "greenhouse_done" );

	flag_clear( "aa_greenhouse" );

	level thread area_ac130_init();
}

greenhouse_heli_light_off()
{
	flag_wait( "greenhouse_heli_light_off" );
	helicopter_searchlight_off();
}

infinite_stinger()
{
	base_stinger = getent( "infinite_stinger", "targetname" );

	drop_spots = getentarray( base_stinger.target, "targetname" );
	for( i = 0 ; i < drop_spots.size ; i ++ )
		drop_spots[i] hide();

	base_stinger hide();

	i=0;
	while( true )
	{
		stinger_origin = base_stinger.origin + (0,0,5);
		stinger = spawn( "weapon_stinger", stinger_origin );
		stinger.angles = base_stinger.angles;
		wait 1;
		stinger.origin = base_stinger.origin + (0,0,-2);

		stinger waittill( "trigger", dude, oldweapon );

		if ( isdefined(oldweapon) )
		{
			oldweapon.origin = drop_spots[i].origin;
			oldweapon.angles = drop_spots[i].angles;
			i++;
			if ( i>drop_spots.size )
				i=0;
		}
		level.player waittill( "stinger_fired" );
	}
}

greenhouse_stinger()
{
	while( get_ai_group_count( "greenhouse_group" ) > 10 )
		wait 0.05;

	autosave_by_name( "greenhouse" );

	flag_set( "aa_stinger" );

	battlechatter_off( "axis" );
	battlechatter_off( "allies" );

	if ( level.gameskill > 1 )
	{
		// hard and fu
		level.heli_guy_accuracy = 4;
		level.heli_guy_health_multiplier = 1;
		level.heli_guy_respawn_delay = 10;
	}
	else
	{
		// easy and normal
		level.heli_guy_accuracy = 1.5;
		level.heli_guy_health_multiplier = 0.8;
		level.heli_guy_respawn_delay = 15;
	}

	level.helicopter thread activate_heli_guy();

	level.price thread anim_single_queue( level.price, "anotherpass" );

	waittill_aigroupcleared( "greenhouse_group" );

	activate_trigger_with_targetname( "stinger_color_init" );

	if ( !isdefined( level.helicopter ) )
	{
		// if the heli is killed out outside of the mission.
		flag_set( "helicopter_down" );
		flag_clear( "aa_stinger" );
		return;
	}

	level.helicopter stop_helicopter_attack();

	wait 1;

	if ( level.gameskill > 1 )
	{
		// hard and fu
		level.heli_guy_accuracy = 8;
		level.heli_guy_health_multiplier = 2;
		level.heli_guy_respawn_delay = 6;
	}
	else
	{
		// easy and normal
		level.heli_guy_accuracy = 4;
		level.heli_guy_health_multiplier = 2;
		level.heli_guy_respawn_delay = 6;
	}

	if ( isalive(level.helicopter.heli_guy) )
		level.helicopter.heli_guy.baseAccuracy = level.heli_guy_accuracy;

	level.helicopter thread heli_path_speed( getstruct( "stinger_path", "targetname" ) );

	level.mark waittill( "goal" );

	autosave_by_name( "stinger" );

	arcademode_checkpoint( 3, 5 );
	
	level.mark anim_single_queue( level.mark, "missilesinbarn" );

	if ( !isalive( level.helicopter ) )
	{
		flag_set( "helicopter_down" );
		flag_clear( "aa_stinger" );
		return;
	}

	level.price thread anim_single_queue( level.price, "takeoutchopper" );

	delayThread( 3, ::activate_trigger_with_targetname, "heli_fight_color_init" );

	level thread objective_stinger();

	level.helicopter waittill( "death" );
	level.helicopter deactivate_heli_guy();

	helicopter_searchlight_off();
	wait 1;

	level.mark anim_single_queue( level.mark, "niceshooting" );
	wait 5;
	level.price thread anim_single_queue( level.price, "everyoneonme" );
	
	flag_clear( "aa_stinger" );
	flag_set( "helicopter_down" );
}

greenhouse_fake_target()
{
	level.helicopter endon( "death" );

	ent = spawn( "script_model", level.helicopter.origin );
	ent linkto( level.helicopter, "tag_origin", (0,0,-80), (0,0,0) );

	target_set( ent, ( 0,0,-80 ) );
	target_setJavelinOnly( ent, true );

	level.player waittill( "stinger_fired" );

	if ( isalive( level.heli_guy ) )
		level.heli_guy setthreatbiasgroup( "oblivious" );

	greenhouse_helicopter_reaction_wait( 2 );
	level.helicopter thread evasion_path( "evasion_pattern" );
	wait 0.5;

	level thread hunted_flares_fire_burst( level.helicopter, 8, 6, 5.0 );
	wait 0.5;

	thread stinger_nag();

	ent unlink();
	vec = get_vehicle_velocity( level.helicopter, (0,0,10) );
	ent movegravity( vec, 8 );
	ent thread ent_delete();

	target_set( level.helicopter, ( 0,0,-80 ) );
	target_setJavelinOnly( level.helicopter, true );

	if ( isalive( level.heli_guy ) )
		level.heli_guy setthreatbiasgroup( "heli_guy" );

	level.player waittill( "stinger_fired" );
	if ( isalive( level.heli_guy ) )
		level.heli_guy setthreatbiasgroup( "oblivious" );

	greenhouse_helicopter_reaction_wait( 3 );
	level.helicopter thread evasion_path( "evasion_pattern" );

	hunted_flares_fire_burst( level.helicopter, 8, 1, 5.0 );
}

get_vehicle_velocity( vehicle, adjustment )
{
	org1 = vehicle.origin + adjustment;
	wait 0.05;
	vec = ( vehicle.origin - org1 );
	return vectorScale( vec, 20 );
}

ent_delete()
{
	wait 3;
	self delete();
}


stinger_nag()
{
	level.helicopter endon( "death" );
	level.player endon( "stinger_fired" );

	wait 0.5;
	level.mark thread anim_single_queue( level.mark, "hunted_uk2_poppingflares" );
	wait 2;
	level.mark thread anim_single_queue( level.mark, "hunted_uk2_fireagain" );

}

greenhouse_helicopter_reaction_wait( remainder )
{
	projectile_speed = 1100 ;
	dist = distance( level.player.origin, level.helicopter.origin );
	travel_time = dist / projectile_speed - remainder;

	if ( travel_time > 0 )
		wait travel_time;
}

hunted_flares_fire_burst( vehicle, fxCount, flareCount, flareTime )
{
	/*
		copied from maps\_helicopter_globals
		had to change it a litle since I couldn't redirect the missile in my case.
	*/

	assert( isdefined( level.flare_fx[vehicle.vehicletype] ) );
	
	assert( fxCount >= flareCount );
	
	for ( i = 0 ; i < fxCount ; i++ )
	{
		playfx ( level.flare_fx[vehicle.vehicletype], vehicle getTagOrigin( "tag_light_belly" ) );
		
		if ( vehicle == level.playervehicle )
		{
			level.stats["flares_used"]++;
			level.player playLocalSound( "weap_flares_fire" );
		}		
		wait 0.25;
	}
}

evasion_path( path_name )
{
	self endon( "death" );

	if ( isdefined( self.currentnode.target ) )
		old_path = getstruct( self.currentnode.target, "targetname"  );
	else
		old_path = self.currentnode;

	path_struct = self make_evasion_path( path_name );
	self heli_path_speed( path_struct );

	if ( isdefined( old_path ) )
		self heli_path_speed( old_path );
}

make_evasion_path( path_name )
{
	base_struct = getstruct( path_name, "targetname" );

	struct = spawnstruct();
	origin_offset = base_struct.origin;
	start_struct = struct;
	struct_targetname = undefined;

	if ( !isdefined( level.evasion_index ) )
		level.evasion_index = 0;

	while ( true )
	{
		base_struct = getstruct( base_struct.target, "targetname" );
		
		struct.origin = self localtoworldcoords( base_struct.origin - origin_offset );

		if ( isdefined( base_struct.angles ) )
			struct.angles = self.angles + base_struct.angles;
		if ( isdefined( struct_targetname ) )
			struct.targetname = struct_targetname;
		struct_targetname = "evasion_" + level.evasion_index;
		if ( isdefined( base_struct.target ) )
		{
			struct.target = struct_targetname;
			struct add_struct_to_level_array();
		}
		else
		{
			struct add_struct_to_level_array();
			break;
		}

		struct = spawnstruct();
		level.evasion_index++;
	}
	return start_struct;
}

add_struct_to_level_array()
{
	level.struct[ level.struct.size ] = self;

	if ( isdefined( self.targetname ) )
		self add_struct( self.targetname, "targetname" );
	if ( isdefined( self.target ) )
		self add_struct( self.target, "target" );
	if ( isdefined( self.script_noteworthy ) )
		self add_struct( self.script_noteworthy, "script_noteworthy" );
}

add_struct( value, key )
{
	if ( !isdefined( level.struct_class_names[ key ][ value ] ) )
		level.struct_class_names[ key ][ value ] = [];
	size = level.struct_class_names[ key ][ value ].size;
	level.struct_class_names[ key ][ value ][size] = self;
}

greenhouse_barn_door()
{
	flag_wait ( "helicopter_down" );
	
	activate_trigger_with_targetname( "greenhouse_exit_stuckup_color_init" );

	flag_wait( "greenhouse_rear_exit" );

	gate = getent( "big_barn_door", "targetname" );
	anim_ent = getent( "big_barn_animent", "targetname" );

	level.price disable_ai_color();
	anim_ent anim_reach_solo( level.price, "hunted_open_big_barn_gate" );

	anim_ent anim_single_solo( level.price, "hunted_open_big_barn_gate_stop" );
	anim_ent thread anim_single_solo( level.price, "hunted_open_big_barn_gate" );

	gate hunted_style_door_open( "door_metal_slow_open" );

	activate_trigger_with_targetname( "barn_exit_y_color_init" );

	level.price set_force_color( "o" );
	level.price enable_cqbwalk();

	wait 0.5;
	activate_trigger_with_targetname( "barn_exit_r_color_init" );

	level.price waittill_notify_or_timeout( "goal", 3 );
	level.price disable_cqbwalk();

	flag_set( "greenhouse_done" );
}

area_ac130_init()
{
	autosave_by_name( "ac130" );

	arcademode_checkpoint( 3, 6 );

	flag_set( "aa_ac130" );

	level thread set_playerspeed( 130, 5 );

	level thread ac130_allies();
	level thread ac130_devastation();
	level thread ac130_gas_station();
	level thread ac130_enemy_vehicles();

	flag_wait( "go_dazed" );

	level thread set_playerspeed( 190, 4 );

	flag_wait_or_timeout( "mission_end_trigger", 30 );

	flag_clear( "aa_ac130" );

	nextmission();
}

ac130_dazed_guy()
{
	self endon( "death" );

	self setthreatbiasgroup( "oblivious" );
	self.animname = "axis";
	self set_run_anim( "patrolwalk_nolight" );
	self.alwaysRunForward = true;

	self thread ac130_defend_gasstation();

	flag_wait( "ac130_barrage" );
	self clear_run_anim();
	self.alwaysRunForward = undefined;

	if ( isdefined( self.script_noteworthy ) && self.script_noteworthy == "runners" )
	{
		flag_wait( "ac130_barrage_over" );
		self waittill( "damage" );
		self setthreatbiasgroup( "axis" );
	}
	else
	{
		self.skipDeathAnim = true;
		self thread throw_on_death( (6432, 11312, 200), "MOD_EXPLOSIVE" );
		flag_wait( "go_dazed" );

		self setthreatbiasgroup( "oblivious" );
		self set_run_anim( "dazed_" + randomint(5) );
		self.alwaysRunForward = true;

		wait 7;

		self.skipDeathAnim = undefined;

		self thread track_player_proximity();
		self waittill_either( "damage", "proximity" );

		self clear_run_anim();
		self.alwaysRunForward = undefined;
		wait 1;
		self setthreatbiasgroup( "axis" );
	}
}

track_player_proximity()
{
	self endon( "death" );

	wait randomfloat( 0.5 );
	while( distance2d( level.player.origin, self.origin ) > 350 )
		wait 0.25;

	self notify( "proximity" );
}

throw_on_death( death_source_origin, damage_type )
{
	self waittill( "death", a, b, c, d, e, f, g );

	if ( !isdefined( self ) || !isdefined( b ) || b != damage_type )
		return;

	origin = self.origin;

	vector = vectornormalize( origin - death_source_origin );

	self StartRagdoll();
	wait 0.1;
	PhysicsExplosionSphere( origin + vector_multiply( vector, -50 ), 100, 90, 4 );
}

ac130_allies()
{
	setignoremegroup( "axis", "allies" );	// allies ignore axis

	flag_wait_either( "ac130_defend_gasstation", "ac130_barrage" );
	wait 3;
	setthreatbias( "axis", "allies", 0 );	// make axis a threat again.
}

ac130_defend_gasstation()
{
	self endon( "death" );
	level endon( "ac130_barrage" );

	flag_wait( "ac130_defend_gasstation" );
	self clear_run_anim();
	self setthreatbiasgroup( "axis" );

	level thread ac130_kill_player();
}

ac130_kill_player()
{
	while ( true )
	{
		if ( !flag( "ac130_barrage" ) )
		{
			if ( distance2d( ( 6264, 12264, 232 ), level.player.origin ) < 1200 )
				break;
		}
		else if ( !flag( "go_dazed" ) )
		{
			if ( distance2d( ( 5928, 12952, 200 ), level.player.origin ) < 1600 )
				break;
		}
		wait 0.05;
	}

	level.player EnableHealthShield( false );
	damagemultiplier = getdvarfloat( "player_damagemultiplier" );
	damage = 25 / damagemultiplier;
	while ( true )
	{
		level.player dodamage( damage , ( 6896, 12118, 328 ) );
		wait 0.05;
	}
}

ac130_devastation()
{
	flag_set( "gasstation_start" );

	radio_dialogue( "requestfire" );

	flag_wait( "ac130_inplace" );

//	level.price anim_single_queue( level.price, "blockedpath" );
	radio_dialogue( "usesomehelp" );
//	level.mark anim_single_queue( level.mark, "bringingintanks" );
	level thread set_flag_on_player_action( "ac130_defend_gasstation", true, true);
	level.price anim_single_queue( level.price, "100metres" );
	radio_dialogue( "comindown" );
	wait .5;
	flag_set( "ac130_barrage" );

	level notify( "kill_action_flag" );

	wait 1;

	activate_trigger_with_targetname( "cover_color_init" );
	wait 4;

	level.mark.alwaysRunForward = true;
	level.steve.alwaysRunForward = true;
	level.charlie.alwaysRunForward = true;
	level.mark.disableArrivals = true;
	level.steve.disableArrivals = true;
	level.charlie.disableArrivals = true;
	level.mark set_run_anim( "path_slow" );
	level.steve set_run_anim( "path_slow" );
	level.charlie set_run_anim( "path_slow" );

	activate_trigger_with_targetname( "celebrate_color_init" );

	level.mark thread anim_on_goal( "hunted_celebrate", 2.5 );
	level.steve thread anim_on_goal( "hunted_celebrate", 0 );
	level.charlie thread anim_on_goal( "hunted_celebrate", 1 );
	wait 2;

	activate_trigger_with_targetname( "dazed_color_init" );
	flag_set( "go_dazed" );
	wait 10;

	radio_dialogue( "getmovin" );
	level.price thread anim_single_queue( level.price, "comeonletsgo" );

	level thread set_playerspeed( 190, 3 );

	level.mark.alwaysRunForward = undefined;
	level.steve.alwaysRunForward = undefined;
	level.charlie.alwaysRunForward = undefined;
	level.mark clear_run_anim();
	level.steve clear_run_anim();
	level.charlie clear_run_anim();

	activate_trigger_with_targetname( "mission_end_color_init" );

	flag_set( "ac130_barrage_over" );
}

anim_on_goal( anime, time_delay )
{
	wait 0.5;
	self waittill( "goal" );
	wait time_delay;
	self thread anim_single_queue( self,  anime );
}

ac130_enemy_vehicles()
{
	dazed_array = getentarray( "dazed_guy", "targetname" );
	array_thread( dazed_array, ::add_spawn_function, ::ac130_dazed_guy );

	activate_trigger_with_targetname( "gas_station_color_init" );

	flag_wait( "gasstation_start" );

	vehicles = maps\_vehicle::spawn_vehicles_from_targetname_and_drive( "gasstation_truck" );

	tank = undefined;
	for( i = 0 ; i < vehicles.size ; i ++ )
	{
		if ( vehicles[i].model == "vehicle_t72_tank" )
			tank = vehicles[i];
	}

	flag_wait( "ac130_defend_gasstation" );

	if ( flag( "ac130_barrage" ) )
		return;

	battlechatter_on( "axis" );
	battlechatter_on( "allies" );

	activate_trigger_with_targetname( "gas_station_defend_color_init" );

	tank maps\_vehicle::mgon();
	tank setturrettargetent( level.player );
}

ac130_vehicle_die()
{
	self endon( "death" );

	flag_wait( "ac130_barrage" );

	switch( self.script_noteworthy )
	{
		case "1":
			wait 1;
			break;
		case "2":
			wait 2.5;
			break;
		case "3":
			wait 9;
			break;
		default:
	}
	self notify( "death" );
}

ac130_gas_station()
{
	flag_wait( "ac130_barrage" );

	gas_station = getentarray( "gas_station" ,"targetname" );
	gas_station_d = getentarray( "gas_station_d" ,"targetname" );

	exploder( 66 );
	wait 1.0;
	array_thread( gas_station, ::hide_ent );
	array_thread( gas_station_d, ::swap_ent, (7680,0, 0) );
}

hide_ent( nodelay )
{
	if ( isdefined( self.script_delay ) && !isdefined( nodelay ) )
		wait self.script_delay + 0.1;
	self hide();
}

swap_ent( offset )
{
	if ( isdefined( self.script_delay ) )
		wait self.script_delay;
	self.origin = self.origin + offset;
	wait 0.1; 
	self show();
}

setup_gas_station()
{
	gas_station_d = getentarray( "gas_station_d" ,"targetname" );
	array_thread( gas_station_d, ::hide_ent, true );
}

/**** start and setup functions ****/

setup_friendlies()
{
	level.squad = [];
	level.price = scripted_spawn( "price", "script_noteworthy", true );
	level.price.animname = "price";
	level.price.name = "Captain Price";
	level.price thread squad_init();

	level.mark = scripted_spawn( "mark", "script_noteworthy", true );
	level.mark.animname = "mark";
	level.mark.name = "Gaz";
	level.mark thread squad_init();

	level.steve = scripted_spawn( "steve", "script_noteworthy", true );
	level.steve.animname = "steve";
	level.steve.name = "Nikolai";
	level.steve thread squad_init();
	level.steve.has_ir = undefined;

	level.charlie = scripted_spawn( "charlie", "script_noteworthy", true );
	level.charlie.animname = "charlie";
	level.charlie thread squad_init();
}

squad_init()
{
	self thread magic_bullet_shield();
	level.squad[ level.squad.size ] = self;

	self waittill( "death" );
	level.squad = array_remove( level.squad, self );
}

setup_enemies()
{
	axis_spawner_array = getspawnerteamarray ( "axis" );
	for( i = 0 ; i < axis_spawner_array.size ; i ++ )
	{
		if ( axis_spawner_array[i].classname == "actor_enemy_dog" )
			axis_spawner_array[i] add_spawn_function( ::dog_settings );
		else
			axis_spawner_array[i] add_spawn_function( ::axis_settings );
	}
}

axis_settings()
{
	self setengagementmindist( 300, 200 );
	self setengagementmaxdist( 512, 720 );
}

dog_settings()
{
	self setthreatbiasgroup( "dogs" );
	self.battlechatter = false;
}

setup_visionset_trigger()
{
	struct = spawnstruct();
	triggers = getentarray( "vision_trigger", "targetname" );
	array_thread( triggers, ::visionset_trigger, struct );
}

visionset_trigger( struct )
{
	while ( true )
	{
		self waittill( "trigger" );
		struct notify( "new_visionset" );
		set_vision_set( self.script_noteworthy, self.script_delay );
		struct waittill( "new_visionset" );
	}
}

start_default()
{
	area_flight_init();
}

start_flight_cleanup()
{
	crash_mask = getent( "crash_mask", "targetname" );
	crash_mask delete();
	missile_source = getent( "missile_source", "targetname" );
	missile_source delete();
}

start_crash()
{
	start_flight_cleanup();

	thread hud_hide( true );
	level.player disableweapons();

	area_crash_init();
}

start_dirt_path()
{
	setup_friendlies();
	start_teleport_squad( "path" );

	start_flight_cleanup();

	level.player set_playerspeed( 130 );

	area_dirt_path_init();
}

start_barn()
{
	setup_friendlies();
	start_teleport_squad( "barn" );

	start_flight_cleanup();

	level thread set_flag_on_player_action( "player_interruption", true, true);

	level thread objective_lz();

	flag_set("trucks_warning");
	level thread dirt_path_barn_truck();

	// don't spawn the helicopter.
	getent( "calc_speed_trigger", "script_noteworthy") delete();

	flag_wait( "barn_moveup" );

	area_barn_init();
}

start_field()
{
	setup_friendlies();
	start_teleport_squad( "field" );

	start_flight_cleanup();

	level thread objective_lz();

	area_field_init();
}

start_basement()
{
	setup_friendlies();
	start_teleport_squad( "basement" );

	start_flight_cleanup();

	level thread objective_lz();

	for ( i=0; i<level.squad.size; i++ )
	{
		level.squad[i] set_force_color( "r" );
	}

	flag_set( "basement_enter" );
	flag_set( "basement_door_open" );
	flag_set( "squad_in_basement" );

	helicopter = maps\_vehicle::spawn_vehicle_from_targetname( "field_heli" );
	level.helicopter = helicopter;

	helicopter helicopter_searchlight_on();

	area_basement_init();

}

start_farm()
{
	setup_friendlies();
	start_teleport_squad( "farm" );

	start_flight_cleanup();

	level thread objective_lz();

	area_farm_init();
}

start_creek()
{
	setup_friendlies();
	start_teleport_squad( "creek" );
	
	start_flight_cleanup();

	level.price set_force_color( "y" );
	level.mark set_force_color( "y" );
	level.steve set_force_color( "r" );
	level.charlie set_force_color( "r" );

	farm_color_trigger = getentarray( "farm_color_trigger", "script_noteworthy" );
	array_thread( farm_color_trigger, ::trigger_off );

	activate_trigger_with_targetname( "farm_cleared_color_init" );

	flag_set( "farm_clear");
	flag_set( "creek_helicopter");

	level thread objective_lz();

	area_creek_init();
}

start_greenhouse()
{
	setup_friendlies();
	start_teleport_squad( "greenhouse" );
	
	start_flight_cleanup();

	level.price set_force_color( "y" );
	level.mark set_force_color( "y" );
	level.steve set_force_color( "r" );
	level.charlie set_force_color( "r" );

	level.price enable_cqbwalk();
	level.mark enable_cqbwalk();
	level.steve enable_cqbwalk();
	level.charlie enable_cqbwalk();

	flag_set( "player_interruption" );

	// get the creek helicopter on the scene
	thread start_greenhouse_helicopter();
	flag_set( "road_helicopter_cleared" );
	level thread objective_lz();

	wait 1;

	area_greenhouse_init();
}

start_greenhouse_helicopter()
{
	helicopter = maps\_vehicle::spawn_vehicle_from_targetname( "creek_heli" );
	helicopter sethoverparams(128, 35, 25);

	wait 0.1;

	for ( i=0; i<helicopter.riders.size; i++ )
	{
		helicopter.riders[i] setthreatbiasgroup ( "oblivious" );
	}

	helicopter helicopter_searchlight_on();

	level.helicopter = helicopter;

	setthreatbias( "player", "heli_guy", 10000 );
	setthreatbias( "heli_guy", "player", 20000 );

	level.heli_guy_accuracy = 1;
	level.heli_guy_health_multiplier = 2;
	level.heli_guy_respawn_delay = 20;

	level.helicopter heli_path_speed( getstruct( "greenhouse_startpath", "targetname" ) );
}

start_ac130()
{
	setup_friendlies();
	start_teleport_squad( "ac130" );
	
	start_flight_cleanup();

	level.price set_force_color( "o" );
	level.mark set_force_color( "y" );
	level.steve set_force_color( "r" );
	level.charlie set_force_color( "r" );

	level thread objective_lz();

	activate_trigger_with_targetname( "barn_exit_y_color_init" );
	activate_trigger_with_targetname( "barn_exit_r_color_init" );

	area_ac130_init();
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
		node = getnode( nodename, "targetname" );
		level.squad[i] start_teleport( node );
	}
}

start_teleport( node )
{
	if ( !isdefined( node ) )
		return;
	self teleport ( node.origin, node.angles );
	self setgoalpos ( self.origin );
	self.goalradius = node.radius;
	self setgoalnode ( node );
}


/****************************************************/
/****************************************************/
/******************** Utilities *********************/
/****************************************************/
/****************************************************/

scripted_sightconetrace( start_origin, ignore_entity )
{
	eye = level.player geteye();
	point[0] = eye + ( 14, 14,-0);
	point[2] = eye + (-14, 14,-10);
	point[1] = eye + (-14,-14,-20);
	point[3] = eye + ( 14,-14,-30);

	visible = 0;
	for( i = 0 ; i < point.size ; i ++ )
	{
		if ( bullettracepassed( start_origin, point[i], false, ignore_entity ) )
			visible += 0.25;
	}
	return visible;
}

attach_flashlight( state )
{
	self attach( "com_flashlight_on" ,"tag_inhand", true );
	self.have_flashlight = true;
	self flashlight_light( state );
	self thread detach_flashlight_on_death();
}

detach_flashlight_on_death()
{
	self waittill( "death" );
	if ( isdefined( self ) )
		self detach_flashlight();
}

detach_flashlight()
{
	if ( !isdefined( self.have_flashlight ) )
		return;
	self detach( "com_flashlight_on", "tag_inhand" );
	self flashlight_light( false );
	self.have_flashlight = undefined;
}

flashlight_light( state )
{
	flash_light_tag = "tag_light";

	if ( state )
	{
		flashlight_fx_ent = spawn( "script_model", ( 0, 0, 0 ) );
		flashlight_fx_ent setmodel( "tag_origin" );
		flashlight_fx_ent hide();
		flashlight_fx_ent linkto( self, flash_light_tag, ( 0, 0, 0 ), ( 0, 0, 0 ) );

		self thread flashlight_light_death( flashlight_fx_ent );
		playfxontag( level._effect["flashlight"], flashlight_fx_ent, "tag_origin" );
	}
	else if( isdefined( self.have_flashlight ) )
		self notify( "flashlight_off" );
}

flashlight_light_death( flashlight_fx_ent )
{
	self waittill_either( "death", "flashlight_off" );

	flashlight_fx_ent delete();
	self.have_flashlight = undefined;

}

hud_hide( state )
{
	wait 1;
	if ( state )
	{
		SetSavedDvar( "compass", "0" );
		SetSavedDvar( "ammoCounterHide", "1" );
		SetSavedDvar( "hud_showstance", "0" );	
		level.nocompass = true;
	}
	else
	{
		SetSavedDvar( "compass", "1" );
		SetSavedDvar( "ammoCounterHide", "0" );
		SetSavedDvar( "hud_showstance", "1" );	
		level.nocompass = undefined;
	}
}

set_specular_scale( scale, transition_time )
{
    current_scale = GetDvarFloat( "r_specularcolorscale" );

    if ( !isdefined(transition_time) )
        transition_time = 0;

    steps = abs( int( transition_time*4 ) );

    difference = scale - current_scale;

    for( i=0; i<steps; i++ )
    {
        current_scale += difference/steps;
        setsaveddvar( "r_specularcolorscale", current_scale );
        wait 0.25;
    }

    setsaveddvar( "r_specularcolorscale", scale );
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

set_fixednode( state )
{
		self.fixedNode = state;
}

make_walk()
{
	old_walkdist = self.walkdist;
	self.walkdist = 1000;
	level waittill( "stop_walk");
	self.walkdist = old_walkdist;
}

flash_immunity( immunity_time )
{
	self endon( "death" );
	self setFlashbangImmunity( true );
	wait immunity_time;
	self setFlashbangImmunity( false );
}

make_ai_move()
{
	self pushplayer( true );
	self set_ignoreSuppression( true );
	self.a.disablePain = true;
	self setthreatbiasgroup( "oblivious" );
}

make_ai_normal()
{
	self pushplayer( false );
	self set_ignoreSuppression( false );
	self.a.disablePain = false;
	self setthreatbiasgroup( "allies" );
}

delete_on_goal()
{
	self endon( "death" );
	self waittill( "goal" );
	while ( self cansee( level.player ) )
		wait 1;
	self delete();
}

magic_kill()
{
	if ( flag( "heli_field_stragler_attack" ) )
		return;

	flag_set( "heli_field_stragler_attack" );

	path_struct = getstruct( "heli_stragler_attack_path", "targetname" );

	level.helicopter thread heli_path_speed( path_struct );

	level.heli_guy_accuracy = 2;
	level.heli_guy_health_multiplier = 2;
	level.heli_guy_respawn_delay = 5;
	level.helicopter thread activate_heli_guy();
}

setthreatbiasgroup_on_array( group, array, array_exclude )
{
	if ( isdefined( array_exclude ) )
		array = array_exclude( array, array_exclude );

	for ( i=0; i<array.size; i++)
	{
		array[i] setthreatbiasgroup( group );
	}
}

setup_heli_guy()
{
	guy = getent( "heli_guy", "targetname" );
	guy add_spawn_function( ::heli_guy );

	on_triggers = getstructarray( "activate_heli_guy", "script_noteworthy" );
	array_thread( on_triggers, ::activate_heli_guy_trigger );

	off_triggers = getstructarray( "deactivate_heli_guy", "script_noteworthy" );
	array_thread( off_triggers, ::deactivate_heli_guy_trigger );

}

activate_heli_guy_trigger()
{
	while (true )
	{
		self waittill( "trigger", helicopter );
		helicopter activate_heli_guy();
	}
}

activate_heli_guy()
{
	self endon( "death" );
	self endon( "deactivate_heli_guy" );

	assert( !isdefined( self.heli_guy ) );

	if ( !isdefined( level.heli_guy_respawn_delay ) )
		level.heli_guy_respawn_delay = 6;

	while ( true )
	{
		heli_guy = scripted_spawn( "heli_guy", "targetname" );
		heli_guy waittill( "death" );
		wait randomfloat( 3 ) + level.heli_guy_respawn_delay;
	}
}

deactivate_heli_guy_trigger()
{
	while (true )
	{
		self waittill( "trigger", helicopter );
		helicopter deactivate_heli_guy();
	}
}

deactivate_heli_guy()
{
	self notify( "deactivate_heli_guy" );

	self helicopter_close_door();

	wait 1;
	if ( isalive( self.heli_guy ) )
		self.heli_guy delete();

	self.heli_guy = undefined;
}

heli_guy()
{
	if ( !isdefined( level.helicopter ) )
		return;

//	level.helicopter endon( "death" );

	if ( !isdefined( level.heli_guy_accuracy ) )
		level.heli_guy_accuracy = 1;
	if ( !isdefined( level.heli_guy_health_multiplier ) )
		level.heli_guy_health_multiplier = 1.5;

	self.a.disableLongDeath = true;

	self linkto( level.helicopter, "tag_origin", ( 120, 30, -140 ), ( 0,90,0 ) );
	self allowedstances( "crouch" );

	self.health = int( self.health * level.heli_guy_health_multiplier );
	self.baseAccuracy = level.heli_guy_accuracy;
//	self.deathanim = %helicopter_death_fall;

	self setthreatbiasgroup( "heli_guy" );

	level.helicopter notify( "dont_clear_anim" );
	
	level.helicopter helicopter_open_door();
	level.helicopter.heli_guy = self;

	level.helicopter notify( "heli_guy_spawned" );

	self death_monitor();

	if ( isdefined( self ) )
	{
		if ( getdvarint( "ragdoll_enable" ) )
		{
			self.a.nodeath = true; 
			ent = spawn( "script_origin", self.origin );
			ent.angles = level.helicopter.angles + (0,90,0);
			level.scr_anim[ "generic" ][ "heli_fall" ] = %helicopter_death_fall;
			thread play_sound_in_space( "generic_death_falling", level.helicopter.origin );
			ent anim_generic( self, "heli_fall" );
			ent delete();
			if ( isalive( self ) )
				self die();
		}
		else
		{
			self die();
			thread play_sound_in_space( "generic_death_falling", level.helicopter.origin );
			self waittillmatch( "deathanim", "end" );
			self delete();
		}
	}

	if ( isdefined( level.helicopter ) )
		level.helicopter.heli_guy_died = true;
}

death_monitor()
{
	health_buffer = 1000000;
	self.health += health_buffer;

	self endon( "death" );

	while( true )
	{
		self waittill( "damage", a, b, c, d, e, f );
		if ( self.health < health_buffer )
			break;
	}
}

delete_dude()
{
	wait 10;
	self delete();
}

#using_animtree("vehicles");
helicopter_open_door()
{
	wait .5;

	self UseAnimTree( #animtree );
	self setanim( %mi17_heli_idle, 1, 1 );
}

helicopter_close_door()
{
	if ( isdefined( self ) )
		self ClearAnim( %mi17_heli_idle, 1 );
}

#using_animtree("generic_human");
expand_goalradius_ongoal()
{
	self endon( "death" );
	self waittill( "goal" );
	self.goalradius = 1000;
}

setthreatbiasgroup_on_notify( notify_string, group_name )
{
	self endon( "death" );
	self waittill( notify_string );
	self setthreatbiasgroup( group_name );
}

set_goalnode( node )
{
	self setgoalnode( node );
	if ( isdefined( node.radius ) )
		self.goalradius = node.radius;
}

set_goalvolume( volume_targetname )
{
	volume = getent( volume_targetname, "targetname" );
	if ( isdefined(volume.target) )
	{
		node = getnode( volume.target, "targetname" );
		self set_goalnode( node );
	}
	self setgoalvolume( volume );
}

trigger_timeout( timeout_time )
{
	self endon( "trigger" );
	wait timeout_time;
	self notify( "trigger" );
}

setup_setgoalvolume_trigger()
{
	array_thread( getentarray( "setgoalvolume", "targetname" ), ::setgoalvolume_trigger );
}

setgoalvolume_trigger()
{
	volume = getent( self.target, "targetname" );
	node = getnode( volume.target, "targetname" );
	self waittill( "trigger" );

	axis = getaiarray( "axis" );
	for ( i=0; i<axis.size; i++ )
	{
		axis[i] set_goalnode( node );
		axis[i] setgoalvolume( volume );
	}
}

helicopter_attack( hover_time, trigger_name )
{
	// run: helicopter thread activate_heli_guy(); before this thread.

	self endon( "death" );
	self endon( "stop_helicopter_attack" );

	point_struct = setup_helicopter_attack_points( trigger_name );
	elapsed_time = 10000; // so that a point is picked the first time around.

	self sethoverparams( 200, 30, 30);

	if ( !isdefined( self.look_at_ent ) )
		self.look_at_ent = spawn( "script_model", (0, 0, 0) );

	vector = anglestoforward( self.angles );
	self.look_at_ent.origin = self.origin + vector_multiply( vector, 3000 );

	struct = undefined;

	while ( true )
	{
		wait 0.05;

//		iprintln( elapsed_time );

		if ( isdefined( self.heli_guy_died ) )
		{
			elapsed_time += 8; // one time add
			self.heli_guy_died = undefined;
		}
		else if ( distance2d( self.origin, level.player.origin ) < 900 )
			elapsed_time += 0.2;
		//  else if ( isalive( self.heli_guy ) && !self.heli_guy canshoot( level.player geteye(), (0,0,0) ) )
		else if ( isalive( self.heli_guy ) && !sighttracepassed( self.heli_guy geteye(), level.player geteye(), false, self.heli_guy ) )
			elapsed_time += 0.2;
		else
			elapsed_time += 0.05;

		if ( elapsed_time < hover_time && !isdefined( point_struct.new_selection ) )
			continue;

		if ( isdefined( point_struct.new_selection ) )
			self thread spot_target_path_end();

		struct = helicopter_attack_pick_points( point_struct, struct );
		point_struct.new_selection = undefined;

		assert( isdefined( struct.angles ) );

		vector = anglestoforward( struct.angles );
		new_pos = struct.origin + vector_multiply( vector, 3000 );
		movetime = distance2d( struct.origin, self.origin ) / 350;
		self.look_at_ent moveto( new_pos, movetime, movetime/2, movetime/2 );

		self setLookAtEnt( self.look_at_ent );

		self heli_path_speed( struct );
		self clearLookAtEnt();
		elapsed_time = 0;
		self.heli_guy_died = undefined;
	}
}

stop_helicopter_attack()
{
	self clearLookAtEnt();
	self notify( "stop_helicopter_attack" );
}

helicopter_attack_pick_points( point_struct, current_point )
{
	points = array_randomize( point_struct.attack_points );

	if ( isdefined( current_point ) )
		points = array_remove ( points, current_point );

	for( i = 0 ; i < points.size ; i ++ )
	{
		if ( distance2d( points[i].origin, level.player.origin ) < 900 )
			continue;
		if ( sighttracepassed( points[i].origin, level.player geteye(), false, undefined ) )
			return points[i];
	}

	return points[0];
}

setup_helicopter_attack_points( trigger_name )
{
	struct = spawnstruct();
	triggers = getentarray( trigger_name, "targetname" );
	array_thread( triggers, ::helicopter_attack_points , struct );
	struct waittill( "new_trigger" );
	return struct;
}

helicopter_attack_points( struct )
{
	self endon( "stop_helicopter_attack" );

	while ( true )
	{
		self waittill( "trigger" );
		if ( isdefined( struct.current_trigger ) && level.player istouching(struct.current_trigger) )
			continue;
	
		struct notify( "new_trigger" );
		struct.current_trigger = self;
		struct.new_selection = true;
		struct.attack_points = getstructarray( self.target, "targetname" );
		struct waittill( "new_trigger" );
	}
}

follow_path( start_node, disablearrivals )
{
	self endon( "death" );
	self endon( "stop_path" );

	self.path_halt = false;

	node = start_node;
	while ( isdefined( node ) )	
	{
		if ( node.radius != 0 )
			self.goalradius = node.radius;
		if ( isdefined( node.height ) && node.height != 0)
			self.goalheight = node.height;

		self setgoalnode( node );

		if ( isdefined( disablearrivals ) && !disablearrivals )
			self.disableArrivals = true;
		else if ( node node_have_delay() )
			self.disableArrivals = false;
		else
			self disablearrivals_delayed();

		self waittill( "goal" );
		node notify( "trigger", self );

		if (!isdefined (node.target))
			break;

		node script_delay();

		if ( isdefined( node.script_flag_wait ) )
			flag_wait( node.script_flag_wait );

		if ( self.path_halt )
			self waittill( "path_resume" );

		node = getnodearray( node.target, "targetname" );
		node = node[ randomint( node.size ) ];
	}

	self notify( "path_end_reached" );
	self.path_halt = undefined;
}

node_have_delay()
{
	if ( !isdefined (self.target) )
		return true;
	if ( isdefined( self.script_noteworthy ) && self.script_noteworthy == "spot_target" )
	{
		array = getstructarray( self.target, "targetname" );
		if ( !isdefined( array ) )
			return true;
	}
	if ( isdefined ( self.script_delay ) && self.script_delay > 0 )
		return true;
	if ( isdefined ( self.script_delay_max ) && self.script_delay_max > 0 )
		return true;
	if ( isdefined( self.script_flag_wait ) && !flag( self.script_flag_wait ) )
		return true;
	return false;
}

disablearrivals_delayed()
{
	self endon("death");
	self endon( "stop_path" );
	self endon("goal");
	wait 0.5;
	self.disableArrivals = true;
}

scripted_spawn( value, key, stalingrad, spawner )
{
	if ( !isdefined( spawner ) )
		spawner = getent( value, key );

	assertEx( isdefined( spawner ), "Spawner with script_noteworthy " + value + " does not exist." );
	
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

waittill_vehicle_group_spawn ( group )
{
	level waittill ("vehiclegroup spawned"+group,vehicles);
	return vehicles;
}

spawn_ent_on_tag( tag )
{
	tag_ent = spawn( "script_model", self gettagorigin( tag ) );
	tag_ent.angles = self.angles;
	tag_ent setmodel( "tag_origin" );
	tag_ent linkto( self, tag );

	return tag_ent;
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

helicopter_searchlight_on()
{
	while ( distance( level.player.origin, self.origin ) > 7000 )
	{
		wait 0.2;
	}

	helicopter_searchlight_off();
	
	self startIgnoringSpotLight();

//	playfxontag (level._effect["spotlight"], self, "tag_barrel");
	self spawn_searchlight_target();
	self helicopter_setturrettargetent( self.spotlight_default_target );

	self.dlight = spawn( "script_model", self gettagorigin("tag_barrel") );
	self.dlight setModel( "tag_origin" );

/*
	model = spawn( "script_model", self gettagorigin("tag_barrel") );
	model setModel( "fx" );
	model linkto (self.dlight);
*/

	self thread helicopter_searchlight_effect();

	level.fx_ent = spawn( "script_model", self gettagorigin("tag_barrel") );
	level.fx_ent setModel( "tag_origin" );
	level.fx_ent linkto( self, "tag_barrel", ( 0,0,0 ), ( 0,0,0 ) );

	wait 0.5;
//	playfxontag (level._effect["spotlight"], self, "tag_barrel");
	playfxontag (level._effect["spotlight"], level.fx_ent, "tag_origin");
}

helicopter_searchlight_off()
{
	if ( isdefined( level.fx_ent ) )	
		level.fx_ent delete();
}

helicopter_searchlight_effect()
{
	self endon("death");

	self.dlight.spot_radius = 256;
	self thread spotlight_interruption();
	
	count = 0;
	while( true )
	{
		targetent = self helicopter_getturrettargetent();
		
		if ( isdefined( targetent.spot_radius ) )
			self.dlight.spot_radius = targetent.spot_radius;
		else
			self.dlight.spot_radius = 256;

		vector = anglestoforward( self gettagangles( "tag_barrel" ) );
		start = self gettagorigin( "tag_barrel" );
		end = self gettagorigin( "tag_barrel" ) + vector_multiply ( vector, 3000 );

		trace = bullettrace( start, end, false, self );
		dropspot = trace[ "position" ];
		dropspot = dropspot + vector_multiply ( vector, -96 );

		self.dlight moveto( dropspot, .5 );

		wait .5;
	}
}

spotlight_interruption()
{
	self endon( "death" );
	level endon( "player_interruption" );

	while ( distance( level.player.origin, self.dlight.origin ) > self.dlight.spot_radius )
		wait 0.25;

//	iprintln ( distance( level.player.origin, self.dlight.origin ) );
//	iprintln ( self.dlight.spot_radius ) ;

	flag_set( "player_interruption" );
}

spawn_searchlight_target()
{
	spawn_origin = self gettagorigin( "tag_ground" );

	target_ent = spawn( "script_origin", spawn_origin );
	target_ent linkto( self, "tag_ground", (320,0,-256), (0,0,0) );
	self.spotlight_default_target = target_ent;
	self thread searchlight_target_death();
}

searchlight_target_death()
{
	ent = self.spotlight_default_target;
	self waittill( "death" );
	ent delete();
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
	return overlay;
}

fade_overlay( target_alpha, fade_time )
{
	self fadeOverTime( fade_time );
	self.alpha = target_alpha;
	wait fade_time;
}

exp_fade_overlay( target_alpha, fade_time )
{
	fade_steps = 4;
	step_angle = 90 / fade_steps;
	current_angle = 0;
	step_time = fade_time / fade_steps;

	current_alpha = self.alpha;
	alpha_dif = current_alpha - target_alpha;

	for ( i=0; i<fade_steps; i++ )
	{
		current_angle += step_angle;

		self fadeOverTime( step_time );
		if ( target_alpha > current_alpha )
		{
			fraction = 1 - cos( current_angle );
			self.alpha = current_alpha - alpha_dif * fraction;
		}
		else
		{
			fraction = sin( current_angle );
			self.alpha = current_alpha - alpha_dif * fraction;
		}

		wait step_time;
	}
}

noprone()
{
	while( true )
	{
		self waittill( "trigger" );
		level.player AllowProne( false );
		while( level.player istouching( self ) )
			wait 0.05;
		level.player AllowProne( true );
	}
}

doorknob()
{
	ent = getent( self.target, "targetname" );
	self linkto( ent );
}

set_grenadeawareness( value )
{
	if ( !isdefined( self.old_grenadeawareness ) )
		self.old_grenadeawareness = self.grenadeawareness;

	if ( isdefined( value ) )
		self.grenadeawareness = value;
	if ( isdefined( value ) )
		self.grenadeawareness = self.old_grenadeawareness;
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

spawn_dead_body()
{
	if ( !isdefined( level.dead_body_count ) )
		level.dead_body_count = 0;

	index = undefined;
	if ( isdefined ( self.script_index ) )
	{
		index = self.script_index;
	}
	else
	{
		level.dead_body_count++;
		if ( level.dead_body_count > 3 )
			level.dead_body_count = 1;
		index = level.dead_body_count;
	}
	
	model = spawn( "script_model", (0,0,0) );
	model.origin = self.origin;
	model.angles = self.angles;
	model.animname = "dead_guy";
	model assign_animtree();

	if ( index == 1 )
		model character\character_sp_sas_woodland_mac::main();
	if ( index == 2 )
		model character\character_sp_sas_woodland_todd::main();
	if ( index == 3 )
		model character\character_sp_sas_woodland_zied::main();

	assertex( index >= 1 && index <= 3, "unknown index" );
	assertex( isdefined( self.script_noteworthy ), "Dead guy needs script_noteworthy death1 through 5" );
	if ( !isdefined( self.script_trace ) )
	{
		trace = bullettrace( model.origin + (0,0,5), model.origin + (0,0,-64 ), false, undefined );
		model.origin = trace[ "position" ];
	}
	
	model setflaggedanim( "flag", model getanim( self.script_noteworthy ), 1, 0, 1 );
	model waittillmatch( "flag", "end" );
	
	if ( !isdefined( self.script_start ) )
		model startragdoll();

	flag_wait( "tunnel_rush" );

	model delete();
}

music()
{
	//MusicPlayWrapper( "hunted_intro_mysterious_music" );

	MusicPlayWrapper( "hunted_crash_recovery_music" );
	
	flag_wait("trucks_warning");
	
	musicstop(5);
	
	flag_wait( "hit_the_deck_music" );
	wait 2;
	
	MusicPlayWrapper( "hunted_spotlight_music" );
}