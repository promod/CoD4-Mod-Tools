#include common_scripts\utility;
#include maps\_utility;
#include maps\_anim;
#include maps\_debug;
#include maps\killhouse;
#include maps\killhouse_anim;
#include maps\_hud_util;



new_look_training_setup()
{
	aim_down_target = getEnt( "aim_down_target", "targetname" );
	aim_up_target = getEnt( "aim_up_target", "targetname" );

	aim_down_target rotateto ( aim_down_target.angles + (0,0,-90), .25, 0, 0 );
	aim_up_target rotateto ( aim_down_target.angles + (0,0,90), .25, 0, 0 );
	
}
new_look_wait_for_target( up, down)
{
	self setCanDamage( true );
	self rotateto ( self.angles + (0,0,up), .25, 0, 0 );
	self playSound( "killhouse_target_up" );
	
	while ( 1 )
	{
		self waittill ( "damage", amount, attacker, direction_vec, point, cause );
		if ( isADS() )
			break;
		else
		{
			if ( level.Xenon )
				thread keyHint( "ads_360" );
			else
				thread keyHint( "ads" );
		}
	}

	self playSound( "killhouse_buzzer" );
	self playSound( "killhouse_target_up" );
	self rotateto ( self.angles + (0,0,down), .25, 0, 0 );
}

rope_obj()
{
	level endon ( "starting_cargoship_obj" );
	setObjectiveString( "obj_price", &"KILLHOUSE_SLIDE_DOWN_THE_ROPE" );
	top_of_rope = getent( "top_of_rope", "targetname" );
	setObjectiveLocation( "obj_price", top_of_rope );
}

level_scripted_unloadnode()
{
	while(1)
	{
		self waittill ("trigger",helicopter );
		helicopter vehicle_detachfrompath();
		helicopter setspeed( 20,20 );
		helicopter vehicle_land();
		//helicopter notify ("unload");
		//helicopter waittill ("unloaded");
		//ai = getnonridingai();
		//helicopter thread maps\_vehicle::vehicle_load_ai( ai );  // -Nate. I changed this comment just incase you decide to enable uncomment.
		//helicopter notify ("load",ai);
		//helicopter waittill ("loaded");
		wait 10;
		helicopter vehicle_resumepath();
	}
}




ambient_trucks()
{
	trigger = getent ( "se_truck_trigger", "targetname" );
	while ( 1 )
	{
		//trigger notify ( "trigger" );
		group = randomint( 8 );
		vehicles = maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( group );
		for ( i = 0; i < vehicles.size; i++ )
		{
			speed = randomintrange ( 30, 50 );
			vehicles [ i ] setspeed ( speed, 30, 30 );
		}
		wait ( randomintrange ( 3, 6 ) );
	}
}

delay_objective_after_intro()
{
	registerObjective( "obj_rifle", &"KILLHOUSE_PICK_UP_A_RIFLE_FROM", getEnt( "obj_rifle_ammo", "targetname" ) );
	wait 3;
	setObjectiveState( "obj_rifle", "current" );
}

waters_think()
{
	level.waters = getent("waters", "script_noteworthy");
	assert( isDefined( level.waters ) );
	level.waters.animname = "gaz";
	level.waters.disablearrivals = true;
	level.waters.disableexits = true;
	level.waters.lastSpeakTime = 0;
	level.waters.lastNagTime = 0;
	level.waters.speaking = false;
	//level.waters pushplayer( true );
}

newcastle_think()
{
	flag_wait ( "spawn_frags" );
	
	spawner = getent("nwc", "script_noteworthy");
	assert( isDefined( spawner ) );
	
	level.newcastle = spawner spawn_ai();
	
	level.newcastle.animname = "nwc";
	level.newcastle.disablearrivals = true;
	level.newcastle.disableexits = true;
	level.newcastle.lastSpeakTime = 0;
	level.newcastle.lastNagTime = 0;
	level.newcastle.speaking = false;
	//level.newcastle pushplayer( true );
}

mac_think()
{
	level.mac = getent("mac", "script_noteworthy");
	assert( isDefined( level.mac ) );
	level.mac.animname = "mac";
	level.mac.disablearrivals = true;
	level.mac.disableexits = true;
	level.mac.lastSpeakTime = 0;
	level.mac.lastNagTime = 0;
	level.mac.speaking = false;
	//level.mac pushplayer( true );
}

price_think()
{
	level.price = getent("price", "script_noteworthy");
	assert( isDefined( level.price ) );
	level.price.animname = "price";
	level.price.disablearrivals = true;
	level.price.disableexits = true;
	level.price.lastSpeakTime = 0;
	level.price.lastNagTime = 0;
	level.price.speaking = false;
	level.price pushplayer( true );
}


clear_hints_on_flag( msg )
{
	flag_wait ( msg );
	clear_hints();
}

generic_compass_hint_reminder( msg, time )
{
	thread clear_hints_on_flag( msg );
	level endon ( msg );
	wait time;
	
	compass_hint();
	
	wait 2;
	
	timePassed = 6;
	for ( ;; )
	{
		if ( timePassed > 20.0 )
		{
			thread compass_reminder();
			RefreshHudCompass();
			timePassed = 0;
		}
		timePassed += 0.05;
		wait ( 0.05 );
	}
}


objective_hints( completion_flag )
{
	level endon ( "mission failed" );
	level endon ( "navigationTraining_end" );
	level endon ( "reveal_dialog_starting" );
	
	compass_hint();
	
	wait 2;
	
	if ( level.Console )
	{
		if ( level.Xenon )
			keyHint( "objectives", 6.0);
		else
			hint( &"KILLHOUSE_HINT_CHECK_OBJECTIVES_SCORES_PS3", 6 ); 
	}
	else
	{ 
		keyHint( "objectives_pc", 6.0);
	}
	
	//level.marine1.lastNagTime = getTime();
	timePassed = 16;
	for ( ;; )
	{
		//if( distance( level.player.origin, level.marine1.origin ) < 512 )
		//	level.marine1 nagPlayer( "squadwaiting", 15.0 );

		if ( !flag( completion_flag ) && timePassed > 20.0 )
		{
			//hint( &"KILLHOUSE_HINT_OBJECTIVE_REMINDER", 6.0 );
			thread compass_reminder();
			RefreshHudCompass();
			//wait( 0.5 );
			//thread hint( &"KILLHOUSE_HINT_OBJECTIVE_REMINDER2", 10.0 );
			timePassed = 0;
		}

		timePassed += 0.05;
		wait ( 0.05 );
	}
}

add_hint_background( double_line )
{
	if ( isdefined ( double_line ) )
		level.hintbackground = createIcon( "popmenu_bg", 650, 50 );
	else
		level.hintbackground = createIcon( "popmenu_bg", 650, 30 );
	level.hintbackground.hidewheninmenu = true;
	level.hintbackground setPoint( "TOP", undefined, 0, 105 );
	level.hintbackground.alpha = .5;
	level.hintbackground.sort = 0;
}

compass_hint( text, timeOut )
{
	if ( getdvar( "chaplincheat" ) == "1" )
		return;

	clear_hints();
	level endon ( "clearing_hints" );

	double_line = true;
	add_hint_background( double_line );
	level.hintElem = createFontString( "objective", level.hint_text_size );
	level.hintElem.hidewheninmenu = true;
	level.hintElem setPoint( "TOP", undefined, 0, 110 );
	level.hintElem.sort = 0.5;

	level.hintElem setText( &"KILLHOUSE_HINT_OBJECTIVE_MARKER" );

	level.iconElem = createIcon( "objective", 32, 32 );
	level.iconElem.hidewheninmenu = true;
	//level.iconElem setPoint( "CENTER", "CENTER", 0, -60 );
	level.iconElem setPoint( "TOP", undefined, 0, 155 );

	wait 5;

	level.iconElem setPoint( "CENTER", "BOTTOM", 0, -20, 1.0 );
	
	level.iconElem scaleovertime(1, 20, 20);
	
	wait .85;
	level.iconElem fadeovertime(.15);
	level.iconElem.alpha = 0;
	
	wait .5;
	level.hintElem fadeovertime(.5);
	level.hintElem.alpha = 0;
	
	clear_hints();
}

compass_reminder()
{	
	if ( getdvar( "chaplincheat" ) == "1" )
		return;

	clear_hints();
	level endon ( "clearing_hints" );

	double_line = true;
	add_hint_background( double_line );
	level.hintElem = createFontString( "objective", level.hint_text_size );
	level.hintElem.hidewheninmenu = true;
	level.hintElem setPoint( "TOP", undefined, 0, 110 );
	level.hintElem.sort = 0.5;

	level.hintElem setText( &"KILLHOUSE_HINT_OBJECTIVE_REMINDER" );


	level.iconElem = createIcon( "objective", 32, 32 );
	level.iconElem.hidewheninmenu = true;
	//level.iconElem setPoint( "CENTER", "CENTER", 0, -60 );
	level.iconElem setPoint( "TOP", undefined, 0, 155 );

	wait 5;
	//setObjectiveLocation( "obj_enter_range", getEnt( "rifle_range_obj", "targetname" )  );

	level.iconElem setPoint( "CENTER", "BOTTOM", 0, -20, 1.0 );
	
	level.iconElem scaleovertime(1, 20, 20);
	
	wait .85;
	level.iconElem fadeovertime(.15);
	level.iconElem.alpha = 0;
	
	wait 2;
	level.hintElem fadeovertime(.5);
	level.hintElem.alpha = 0;
	
	clear_hints();
}


move_gaz_once_player_past()
{
	flag_wait ( "past_gaz" );
	//level.waters walk_to ( 	getnode ( "stationone_node", "script_noteworthy" ) );
	temp = getnode ( "stationone_node", "script_noteworthy" );
	node = spawn( "script_origin", temp.origin + (0,12,0) );
	node.angles = temp.angles;
		
	level.waters.ref_node = node;
	node anim_generic_reach_and_arrive( level.waters, "killhouse_gaz_idle_arrive" );
	
	level.waters.ref_node thread anim_loop_solo( level.waters, "killhouse_gaz_idleB", undefined, "stop_loop" );	
	flag_set( "gaz_in_idle_position" );
}

move_gaz_fake()
{
	temp = getnode ( "stationone_node", "script_noteworthy" );
	node = spawn( "script_origin", temp.origin + (0,12,0) );
	node.angles = temp.angles;
		
	level.waters.ref_node = node;
	level.waters.ref_node thread anim_loop_solo( level.waters, "killhouse_gaz_idleB", undefined, "stop_loop" );	
	flag_set( "gaz_in_idle_position" );
}


fail_on_damage()
{
	while ( 1 )
	{
		self waittill ( "damage", damage, attacker, parm1, parm2, damageType );
		if ( attacker == level.player )
			maps\_friendlyfire::missionfail();
	}
}

fail_if_friendlies_in_line_of_fire()
{
	grenade = true;
	flash = true;
	level endon ( "okay_if_friendlies_in_line_of_fire" );
	while ( true )
	{
		msg = level.player waittill_any_return( "weapon_fired", "player_flash", "player_frag" );
		if ( !isdefined(msg) )
			break;
		if ( msg == "weapon_fired" )
		{
			weap = level.player getCurrentWeapon(); 
			//ignore if melee
			
			if ( weap == "c4" )
				continue;
		}
		if ( msg == "player_frag" && isdefined( grenade ) )
		{
			if ( ! level.player isthrowinggrenade() )
			 	continue;//no ammo
			wait 1;
			//continue;
		}
		if ( msg == "player_flash" && isdefined( flash ) )
		{
			if ( ! level.player isthrowinggrenade() )
				continue;
			wait 1;
			//continue;
		}

		allies = getaiarray( "allies" );
		for ( i = 0; i < allies.size; i++ )
		{
			qBool = within_fov( level.player.origin, level.player.angles, allies[ i ].origin, cos( 25 ) );
			dist = distance ( level.player.origin, allies[ i ].origin );
			if ( ( qBool ) && ( dist < 1000 ) ) 
			{
				level notify ( "mission failed" );	
				setDvar("ui_deadquote", &"KILLHOUSE_FIRED_NEAR_FRIENDLY");
				maps\_utility::missionFailedWrapper();
			}
		}
	}
}


setup_player_action_notifies()
{
	wait 1;
//	level.player notifyOnCommand( "player_gun", "+attack" );
	level.player notifyOnCommand( "player_frag", "+frag" );
	level.player notifyOnCommand( "player_flash", "-smoke" );
}


vision_trigger( vision_file )
{
	while ( 1 )
	{
		self waittill ( "trigger" );	
		set_vision_set( vision_file, 1 );
		while ( level.player istouching ( self ) )
			wait .1;
	}
}


flashed_hud_elem()
{
	while ( 1 )
	{
		if ( level.player isFlashed() )
			level notify ( "flashed" );
		else
			level notify ( "not_flashed" );
	
		wait .2;	
	}
}
	
flashed_debug()
{
	while ( 1 )
	{
		level waittill ( "flashed" );
		flashed = maps\_hud_util::get_countdown_hud();	

  		flashed.y = 130;
  		
	  	flashed setText( &"KILLHOUSE_YOUR_TIME" );
		//flashed.label = &"KILLHOUSE_YOUR_TIME";

		level waittill ( "not_flashed" );
		flashed destroy();
	}
}

flag_when_lowered( flag )
{
	level.targets_hit = 0;
	targetDummies = getTargetDummies( "rifle" );
	numRaised = targetDummies.size;
	while ( level.targets_hit < numRaised )
		wait ( 0.05 );
	
	flag_set ( flag );
}


ADS_shoot_dialog()
{
	wait .4;
	
	if ( !flag( "ADS_targets_shot" ) )
	{
		if( level.Console )
			thread keyHint( "attack" );
		else
			thread keyHint( "pc_attack" );
			
		//Now. Shoot - each - target, while aiming down the sights.
		level.waters execDialog( "shooteachtarget" );
	}
	
	flag_set( "ADS_shoot_dialog" );	
}



deck_start()
{	
	deck_start = getent( "deck_start", "targetname" );
	level.player setOrigin( deck_start.origin );
	level.player setPlayerAngles( deck_start.angles );
	level.player giveWeapon("g36c");
	level.player giveWeapon("mp5");
	level.player switchtoWeapon("mp5");
	
	flag_set ( "start_deck" );
}



deck_training()
{
	deck_targets = getentarray( "deck_target", "script_noteworthy" );
	array_thread( deck_targets, ::cargoship_targets );

	flag_wait ( "start_deck" );
	registerObjective( "obj_deck", &"KILLHOUSE_COMPLETE_THE_DECK_MOCKUP", getent( "area_two_one", "targetname" ) );	
	setObjectiveState( "obj_deck", "current" );
	
	one = getent( "area_two_one", "targetname" );
	two = getent( "area_two_two", "targetname" );
	three = getent( "area_two_three", "targetname" );
	four = getent( "area_two_four", "targetname" );
	five = getent( "area_two_five", "targetname" );
	finish = getent( "area_two_finish", "targetname" );
	first_time = true;
	
	while ( 1 )
	{
		one waittill ( "trigger" );
		thread add_dialogue_line( "price", "Get ready..." );
		wait 2;
		thread add_dialogue_line( "price", "Go go go!!" );
		thread accuracy_bonus();
		thread startTimer( 60 );
		if ( isdefined ( level.IW_best ) )
			level.IW_best destroy();
		thread autosave_by_name( "starting_deck_attack" );
		
		one pop_up_and_wait();
		level.price thread execDialog( "position2" );	//Position 2 go!
		setObjectiveLocation( "obj_deck", two );
		two pop_up_and_wait();
		level.price thread execDialog( "position3" );	//Go to Position 3!
		setObjectiveLocation( "obj_deck", three );
		three pop_up_and_wait();
		level.price thread execDialog( "position4" );	//Position 4!
		setObjectiveLocation( "obj_deck", four );
		four pop_up_and_wait();
		thread add_dialogue_line( "price", "Position five go!!" );
		setObjectiveLocation( "obj_deck", five );
		five pop_up_and_wait();
		thread add_dialogue_line( "price", "Final position go!!" );
		setObjectiveLocation( "obj_deck", finish );
		
		finish waittill ( "trigger" );
		
		level notify ( "test_cleared" );
		killTimer( 15.85, true );
		setObjectiveState( "obj_deck", "done" );
		thread add_dialogue_line( "price", "Not bad, but not that good either." );
		thread add_dialogue_line( "price", "Go back to position one if you want try for a better time." );
		thread add_dialogue_line( "price", "Otherwise come over to the monitors for a debrief." );
		
		if ( first_time )
			thread debrief();
		first_time = false;
	}
}


get_randomized_targets()
{
	tokens = strtok( self.script_linkto, " " );
	targets = [];
	for ( i=0; i < tokens.size; i++ )
	{
		token = tokens[ i ];
		target = getent( token, "script_linkname" );
		if ( isdefined( target ) )
		{
			targets = add_to_array( targets, target ); 
			continue;
		}
	}
	targets = array_randomize( targets );
	return targets;
}

pop_up_and_wait()
{
	self waittill ( "trigger" );
	
	deck_targets = self get_randomized_targets();
	
	targets_needed = 0;
	level.targets_hit = 0;
	friendlies_up = [];
	j = 0;
	
	for ( i = 0; targets_needed < 3; i++ )
	{
		wait randomfloatrange (.25, .4);
		deck_targets[ i ] notify ( "pop_up" );
		if ( deck_targets[ i ].targetname == "hostile" )
			targets_needed++;
		else
		{
			friendlies_up[ j ] = deck_targets[ i ];
			j++;
		}
	}
	
	//level.price thread execDialog( "hittargets" );	//Hit the targets!
			
	while ( level.targets_hit != targets_needed )
		wait ( .05 );
			
	if ( friendlies_up.size > 0 )
	{
		for ( k = 0; k < friendlies_up.size; k++ )
			friendlies_up[ k ] notify ( "pop_down" );
	}
}


jumpoff_monitor()
{
	level endon ( "starting_rope" );
	self waittill ( "trigger" );
		
	level notify ( "mission failed" );	
	if ( flag ( "activate_rope" ) )
		setDvar("ui_deadquote", &"KILLHOUSE_SHIP_JUMPED_OFF");
	else
		setDvar("ui_deadquote", &"KILLHOUSE_SHIP_JUMPED_TOO_EARLY");
	maps\_utility::missionFailedWrapper();	
}

flashbang_ammo_monitor ( flash_volumes )
{
	level endon ( "test_cleared" );
	level.volumes_flashed = 0;
	
	while ( 1 )
	{
		level.player waittill ( "grenade_fire", grenade, weaponName );
		
		grenade waittill ( "death" );
		waittillframeend;
		
		flashes_needed = flash_volumes.size - level.volumes_flashed;
		if ( ( level.player GetWeaponAmmoStock( "flash_grenade" ) ) < flashes_needed )
		{
			level notify ( "mission failed" );	
			setDvar("ui_deadquote", &"KILLHOUSE_SHIP_OUT_OF_FLASH");
			maps\_utility::missionFailedWrapper();	
		}
	}
}


check_if_in_volume( tracker, volume )
{
	self waittill ( "death" );
	if ( tracker istouching ( volume ) )
	{
		volume notify ( "flashed" );
		level.volumes_flashed++;
	}
}

track_grenade_origin( tracker, volume )
{
	self endon ( "death" );
	volume endon ( "flashed" );
	while ( 1 )
	{
		tracker.origin = self.origin;
		wait .05;
	}
}

flash_dialog_three( volume )
{
	level endon ( "clear_course" );
	
	volume endon ( "flashed" );
	self waittill ( "trigger" );
	say_first_dialog = true;
	
	while( 1 )
	{
		if ( ! ( level.player istouching ( self ) ) )
		{
			if ( say_first_dialog )
			{
				level.price thread execDialog( "3" );	//3
				level.price thread execDialog( "goback" );	//Go back!
				say_first_dialog = false;
			}
			else
			{
				level.price thread execDialog( "position3" );	//go to 3
				//level.price thread execDialog( "followarrows" );	//Follow the arrows on the floor. 
				say_first_dialog = true;
			}
		}
		else
		{
			level.price thread execDialog( "flashthrudoor" );	//Flashbang through the door!
			thread keyHint( "flash" );
		}
		//thread add_dialogue_line( "price", "Flash the room!!" );
		wait 5;
	}
}

flash_dialog_six( volume )
{
	level endon ( "clear_course" );

	volume endon ( "flashed" );
	self waittill ( "trigger" );
	say_first_dialog = true;
	
	while( 1 )
	{
		if ( ! ( level.player istouching ( self ) ) )
		{
			if ( say_first_dialog )
			{
				level.price thread execDialog( "goback" );	//Go back!
				say_first_dialog = false;
			}
			else
			{
				level.price thread execDialog( "6go" );	//Six go!
				say_first_dialog = true;
			}
		}
		else
		{
			level.price thread execDialog( "flashthrudoor" );	//Flashbang through the door!
			thread keyHint( "flash" );
		}
		//thread add_dialogue_line( "price", "Flash the room!!" );
		wait 5;
	}
}


wait_till_flashed( volume )
{	
	volume endon ( "flashed" );
	assert ( isdefined ( volume ) );
	
	
	while ( 1 )
	{
		level.player waittill ( "grenade_fire", grenade, weaponName );
		if ( weaponname == "flash_grenade" )
		{
			tracker = spawn ("script_origin", (0,0,0));
			grenade thread track_grenade_origin( tracker, volume );
			grenade thread check_if_in_volume( tracker, volume );
		}
	}
}


wait_till_pos_cleared( skip_trigger )
{	
	level endon ( "clear_course" );
	
	if ( !isdefined ( skip_trigger ) )
		self waittill ( "trigger" );
	
	level.targets_hit = 0;
	if ( isdefined ( self.target ) )
	{
		targets = getentarray( self.target, "targetname" );

		for ( i = 0; i < targets.size; i++ )
			targets[ i ] notify ( "pop_up" );
		
		level.price thread execDialog( "hittargets" );	//Hit the targets!
		time_waited = 0;
		
		while ( level.targets_hit != targets.size )
		{
			if ( time_waited > 5 )
			{
				if ( ! level.player istouching ( self ) )
				{
					go_back = [];
					go_back[ 0 ] = "missgoback"; 
					go_back[ 1 ] = "passgoback"; 
					go_back[ 2 ] = "goback"; 
					
					selection = go_back[ randomint( go_back.size ) ];
					
					level.price thread execDialog( selection );
					time_waited = 0;
				}
				else
				{
					if ( level.targets_hit > 0 )
					{
						dialog = [];
						dialog[ 0 ] = "shoottarget"; 
						dialog[ 1 ] = "remainingtarg"; 
						dialog[ 2 ] = "hitother"; 
		
						selection = dialog[ randomint( dialog.size ) ];
						
						level.price thread execDialog( selection );
						
						//thread add_dialogue_line( "price", "Shoot the other target." );
						//thread add_dialogue_line( "price", "Shoot the remaining targets." );
						//thread add_dialogue_line( "price", "Hit other targets." );
					}
					else
					{
						level.price thread execDialog( "hittargets" );	//Hit the targets!
					}
					
					time_waited = 0;
				}
			}
			time_waited += 0.05;
			wait ( .05 );
		}
	}
	return;
}



rope()
{
	top_of_rope_trigger = getent( "top_of_rope_trigger", "targetname" );
	top_of_rope_trigger trigger_off();
	top_of_rope = getent( "top_of_rope", "targetname" );
	bottom_of_rope = getent( "bottom_of_rope", "targetname" );
	
	while ( 1 )
	{
	
		flag_wait ( "activate_rope" );
		
		top_of_rope_trigger trigger_on();
		top_of_rope_trigger setHintString (&"KILLHOUSE_USE_ROPE");
		
		top_of_rope_trigger waittill ( "trigger" );
		level notify ( "starting_rope" );
		level.player DisableWeapons();
		
		tag_origin = spawn("script_model", top_of_rope.origin + (0,0,-60) );
		tag_origin.angles = top_of_rope.angles;
		tag_origin setmodel("tag_origin");
		
		//lerp_player_view_to_tag( tag, lerptime, fraction, right_arc, left_arc, top_arc, bottom_arc )
		tag_origin lerp_player_view_to_tag( "tag_origin", .2, .2, 45, 45, 30, 30 );
		
		rope_time = 1.5;
		tag_origin moveto ( bottom_of_rope.origin + (0,0,-60), rope_time, 1, .2 );
		wait rope_time;
		tag_origin delete();
		
		level.player EnableWeapons();
		top_of_rope_trigger trigger_off();
	}
}



fail_if_damage_waiter()
{
	self endon ( "pop_down" );
	self waittill ( "damage", amount, attacker, direction_vec, point, cause );
	
	setDvar("ui_deadquote", &"KILLHOUSE_HIT_FRIENDLY");
	maps\_utility::missionFailedWrapper();
}

// ****** Get the timer started ****** //
startTimer( timelimit )
{
// destroy any previous timer just in case ****** //
	
	clear_timer_elems();
	
// destroy timer and thread if objectives completed within limit ****** //
	level endon ( "kill_timer" );
	
	level.hudTimerIndex = 20;

	level.start_time = gettime();
// Timer size and positioning ****** //	
	level.timer = maps\_hud_util::get_countdown_hud();	
	level.timer.label = &"KILLHOUSE_YOUR_TIME";
	level.timer settenthstimerUp( .05 );

// Wait until timer expired
	wait ( timelimit );
	//flag_set ( "timer_expired" );

// Get rid of HUD element and fail the mission 
	level.timer destroy();	
	
	level thread mission_failed_out_of_time();
}

dialog_sprint_reminders()
{
	level endon ( "sprinted" );
	
	while ( 1 )
	{
		wait 8;
		level.price thread execDialog( "sprint" );
		//thread add_dialogue_line( "price", "Sprint to the finish!" );//new
	}
}

mission_failed_out_of_time()
{
	level.player endon ( "death" );
	level endon ( "kill_timer" );
	
	dialog = [];
	dialog[ 0 ] = "startover"; //
	dialog[ 1 ] = "doitagain"; //
	dialog[ 2 ] = "tooslow"; //
					
	selection = dialog[ randomint( dialog.size ) ];
					
	level.price thread execDialog( selection );
	
	
	failures = getdvarint( "killhouse_too_slow" );
	setdvar( "killhouse_too_slow", ( failures + 1 ) );
	
	level notify ( "mission failed" );
	if( !flag( "at_finish" ) )
		setDvar("ui_deadquote", &"KILLHOUSE_SHIP_TOO_SLOW");
	else 
		setDvar("ui_deadquote", &"KILLHOUSE_SHIP_DIDNT_SPRINT");
		
	maps\_utility::missionFailedWrapper();	
}

clear_timer_elems()
{
	if (isdefined (level.timer))
		level.timer destroy();
	if (isdefined (level.bonus))
		level.bonus destroy();
	if (isdefined (level.label))
		level.label destroy();
	if (isdefined (level.IW_best) )
		level.IW_best destroy();
	if (isdefined (level.recommended_label) )
		level.recommended_label destroy();
	if (isdefined (level.recommended_label2) )
		level.recommended_label2 destroy();
	if (isdefined (level.recommended) )
		level.recommended destroy();
}

killTimer( best_time, deck )	
{
	level notify ( "kill_timer" );
	clear_timer_elems();
	
	time = ( ( gettime() - level.start_time ) / 1000 );
	level.timer = maps\_hud_util::get_countdown_hud();	
	level.timer.label = &"KILLHOUSE_YOUR_FINAL_TIME";
	
	level waittill ( "accuracy_bonus" );
	final_time = time - level.bonus_time;
	//iprintlnbold ( "time: " +  time );
	level.timer setValue ( final_time );
	
	level.IW_best = maps\_hud_util::get_countdown_hud();	
	level.IW_best.y = 115;
	level.IW_best.label = &"KILLHOUSE_IW_BEST_TIME";
	level.IW_best setValue ( best_time );
	
	level.recommended_label = maps\_hud_util::get_countdown_hud();	
	level.recommended_label.label = &"KILLHOUSE_RECOMMENDED_LABEL";
	level.recommended_label.y = 145;
	
	level.recommended_label2 = maps\_hud_util::get_countdown_hud();	
	level.recommended_label2.label = &"KILLHOUSE_RECOMMENDED_LABEL2";
	level.recommended_label2.y = 160;
	
	level.recommended = maps\_hud_util::get_countdown_hud();	
	level.recommended.y = 180;
	
	if ( final_time > 40 )
	{
		setdvar ( "recommended_gameskill", "0" );
		level.recommended.label = &"KILLHOUSE_RECOMMENDED_EASY";
	}
	else if ( final_time > 26 )
	{
		setdvar ( "recommended_gameskill", "1" );
		level.recommended.label = &"KILLHOUSE_RECOMMENDED_NORMAL";
	}
	else if ( final_time > 20 )
	{
		setdvar ( "recommended_gameskill", "2" );
		level.recommended.label = &"KILLHOUSE_RECOMMENDED_HARD";
	}
	else
	{
		setdvar ( "recommended_gameskill", "3" );
		level.recommended.label = &"KILLHOUSE_RECOMMENDED_VETERAN";
	}
	
	if( final_time < 20.0 )
		maps\_utility::giveachievement_wrapper( "NEW_SQUADRON_RECORD" ); 
			
	return final_time;
}

accuracy_bonus()
{
	guns = level.player GetWeaponsListPrimaries();
	gun0 = level.player GetWeaponAmmoStock( guns[0] );
	gun1 = level.player GetWeaponAmmoStock( guns[1] );
	gunc0 = level.player GetWeaponAmmoClip( guns[0] );
	gunc1 = level.player GetWeaponAmmoClip( guns[1] );
	starting_ammo = gun0 + gun1 + gunc0 + gunc1;
	//iprintlnbold ( "starting_ammo " +  starting_ammo );
	
	level waittill ( "test_cleared" );
	
	gun0 = level.player GetWeaponAmmoStock( guns[0] );
	gun1 = level.player GetWeaponAmmoStock( guns[1] );
	gunc0 = level.player GetWeaponAmmoClip( guns[0] );
	gunc1 = level.player GetWeaponAmmoClip( guns[1] );
	ending_ammo = gun0 + gun1 + gunc0 + gunc1;
	//iprintlnbold ( "ending_ammo " +  ending_ammo );
	
	used = starting_ammo - ending_ammo;
	//iprintlnbold ( "ammo used: " +  used );

	allowed_shots = 20;
	if ( used > allowed_shots )
		excess_ammo = ( used - allowed_shots );
	else
		excess_ammo = 0;

	level.bonus = maps\_hud_util::get_countdown_hud();	
	level.bonus.y = 85;

	level.bonus_time = ( ( 15 - excess_ammo ) * .2 ); 
	if ( level.bonus_time <= 0 )
	{
		level.bonus.label = &"KILLHOUSE_ACCURACY_BONUS_ZERO";
		level.bonus_time = 0;
	}
	else
	{
		level.bonus.label = &"KILLHOUSE_ACCURACY_BONUS";
		level.bonus setValue ( level.bonus_time );
	}

	level notify ( "accuracy_bonus" );
}



nagPlayer( nagAnim, minNagTime )
{
	if ( self.speaking )
		return false;

	time = getTime();
	if ( time - self.lastSpeakTime < 1.0 )
		return false;

	if ( time - self.lastNagTime < (minNagTime * 1000) )
		return false;

	self execDialog( nagAnim );
	self.lastNagTime = self.lastSpeakTime;
	return true;
}


scoldPlayer( scoldAnim )
{
	if ( self.speaking )
		return false;

	self execDialog( scoldAnim );
	return true;
}


execDialog( dialogAnim )
{
	//assert( !self.speaking );
	self.speaking = true;
	//self anim_single_solo( self, dialogAnim );
	self anim_single_queue( self, dialogAnim );
	self.speaking = false;
	self.lastSpeakTime = getTime();
}

actionNodeThink( actionNode )
{
	assert( isDefined( actionNode.script_noteworthy ) );

	switch( actionNode.script_noteworthy )
	{
		case "ammo_node":
			wait ( 2.0 );
			println( self.buddyID + " leaving" );
		break;
	}
}

getFreeActionNode( curNode )
{
	actionNode = undefined;
	while ( isDefined( curNode.target ) )
	{
		nextNode = getNode( curNode.target, "targetname" );

		if ( isDefined( nextNode.script_noteworthy ) )
		{
			if ( nextNode.inUse )
			{
				if ( !isDefined( actionNode ) )
					return curNode;
				else
					return actionNode;
			}

			actionNode = nextNode;
		}

		curNode = nextNode;
	}
	return actionNode;
}


initActionChain( actionNode )
{
	while ( isDefined( actionNode.target ) )
	{
		actionNode.inUse = false;
		actionNode = getNode( actionNode.target, "targetname" );
	}
}

actionChainThink( startNode )
{
	self setGoalNode( startNode );
	self waittill( "goal" );
	curNode = startNode;
	actionNode = undefined;

	while ( !isDefined( actionNode ) )
	{
		actionNode = getFreeActionNode( curNode );
		wait ( 0.05 );
	}

	while ( isDefined( actionNode ) )
	{
		actionNode.inUse = true;
		while ( curNode != actionNode )
		{
			curNode = getNode( curNode.target, "targetname" );
			self setGoalNode( curNode );
			self waittill ( "goal" );
		}

		self actionNodeThink( actionNode );

		while ( isDefined( actionNode ) && curNode == actionNode )
		{
			actionNode = getFreeActionNode( curNode );
			wait ( randomFloatRange( 0.1, 0.5 ) );
		}
		curNode.inUse = false;
	}

	while( isDefined( curNode.target ) )
	{
		curNode = getNode( curNode.target, "targetname" );
		self setGoalNode( curNode );
		self waittill ( "goal" );
	}
}


raisePlywoodWalls()
{
	plywoodWalls = getEntArray( "plywood", "script_noteworthy" );

	for ( index = 0; index < plywoodWalls.size; index++ )
	{
		plywoodWalls[index] rotateRoll( 90, 0.25, 0.1, 0.1 );
		plywoodWalls[index] playSound( "killhouse_target_up_wood" );
	}
}

silently_lowerPlywoodWalls()
{
	plywoodWalls = getEntArray( "plywood", "script_noteworthy" );

	for ( index = 0; index < plywoodWalls.size; index++ )
	{
		plywoodWalls[index] rotateRoll( -90, 0.25, 0.1, 0.1 );
	}
}

lowerPlywoodWalls()
{
	plywoodWalls = getEntArray( "plywood", "script_noteworthy" );

	for ( index = 0; index < plywoodWalls.size; index++ )
	{
		plywoodWalls[index] rotateRoll( -90, 0.25, 0.1, 0.1 );
		plywoodWalls[index] playSound( "killhouse_target_up_wood" );
	}
}


raiseTargetDummies( group, laneID, dummyID )
{
	targetDummies = getEntArray( group + "_target_dummy", "script_noteworthy" );

	for ( index = 0; index < targetDummies.size; index++ )
	{
		targetDummy = targetDummies[index];
		if ( isDefined( dummyID ) && targetDummy.dummyID != dummyID )
			continue;

		if ( isDefined( laneID ) && targetDummy.laneID != laneID )
			continue;

		if ( targetDummy.raised )
			continue;

		targetDummies[index] thread moveTargetDummy( "raise" );
	}
}

moveTargetDummy( command )
{
	self setCanDamage( false );

	while ( self.moving )
		wait ( 0.05 );

	switch( command )
	{
	case "raise":
		if ( !self.raised )
		{
			self.aim_assist_target enableAimAssist();
			speed = 0.25;
			//self playSound( "killhouse_target_up" );
			self playSound( "killhouse_target_up_metal" );
			self.orgEnt rotatePitch( 90, speed, 0.1, 0.1 );
			wait ( 0.25 );
			self.raised = true;
			self.light light_on();

			//if ( self.laneID == 1 )
			//	self enableAimAssist();

			self setCanDamage( true );
		}
		break;

	case "lower":
		if ( self.raised )
		{
			speed = 0.75;
			self.orgEnt rotatePitch( -90, speed, 0.25, 0.25 );
			wait ( 0.75 );
			self.raised = false;
			self.light light_off();
			self playSound( "killhouse_target_up" );

			//if ( self.laneID == 1 )
			//	self disableAimAssist();
			self.aim_assist_target disableAimAssist();

		}
		break;
	}
}

lowerTargetDummies( group, laneID, dummyID )
{
	targetDummies = getEntArray( group + "_target_dummy", "script_noteworthy" );

	for ( index = 0; index < targetDummies.size; index++ )
	{
		targetDummy = targetDummies[index];
		if ( isDefined( dummyID ) && targetDummy.dummyID != dummyID )
		{
			continue;
		}

		if ( isDefined( laneID ) && targetDummy.laneID != laneID )
			continue;

		if ( !targetDummy.raised )
			continue;

		targetDummies[index] thread moveTargetDummy( "lower" );
	}
}


training_targetDummies( group )
{
	targetDummies = getTargetDummies( group );
	for ( index = 0; index < targetDummies.size; index++ )
		targetDummies[index] thread targetDummyThink();
}


targetDummyThink()
{
	self.orgEnt = getEnt( self.target, "targetname" );
	assert( isdefined( self.orgEnt ) );

	self linkto (self.orgEnt);

	self.dummyID = int( self.script_label );
	self.laneID = int( self.targetname[4] );
	
	self.aim_assist_target = getEnt( self.orgEnt.target, "targetname" );
	self.aim_assist_target hide();
	self.aim_assist_target notsolid();
	
	self.light = getEnt( self.aim_assist_target.target, "targetname" );

	self.light light_off();
	self.orgEnt rotatePitch( -90, 0.25 );
	self.raised = false;
	self.moving = false;

	stall = getEnt( "rifleTraining_stall", "targetname" );
	level.waters_speaking = false;
	level.waters_last_line = 0;

	for( ;; )
	{
		while ( 1 )
		{
			self waittill ( "damage", amount, attacker, direction_vec, point, cause );
			
			if ( ! ( level.player istouching ( stall ) ) )
			{
				self target_down();
				
				if ( level.waters_speaking != true )
				{	
					dialog = [];
					dialog[ 0 ] = "gotostation1"; //Soap! Go to Station One.
					dialog[ 1 ] = "heygo"; //Hey. Go to Station One.
					dialog[ 2 ] = "getback"; //Oi, where are you going? Get back to Station One…
					
					selection = dialog[ randomint( dialog.size ) ];
					
					level.waters_speaking = true;
					level.waters execDialog( selection );
					level.waters_speaking = false;
				}
				self moveTargetDummy( "raise" );
				continue;
			}
			
			double_line = true;
			if ( level.hip_fire_required )
			{
				if ( isADS() )
				{
					thread keyHint( "stop_ads", 2, double_line );
					
					self target_down();
					
					if ( level.waters_speaking != true )
					{	
						level.waters_speaking = true;
						
						dialog = [];
						dialog[ 0 ] = "stopaiming"; //Stop aiming down your sights.
						dialog[ 1 ] = "seeyoufire"; //I want to see you fire from the hip.	
					
						if ( level.waters_last_line == 0 )
						{
							level.waters execDialog( "stopaiming" );
							level.waters_last_line = 1;
						}
						else
						{
							level.waters execDialog( "seeyoufire" );
							level.waters_last_line = 0;
						}
						level.waters_speaking = false;
					}
					
					self moveTargetDummy( "raise" );
					continue;
				}
			}
			break;
		}
		self notify ( "hit" );
		level.targets_hit++;
		self playSound( "killhouse_buzzer" );
		
		self target_down();
	}
}

target_down()
{
	self.health = 1000;
	self playSound( "killhouse_target_up" );

	self.moving = true;
	self.aim_assist_target disableAimAssist();
	self setCanDamage( false );
	self.orgEnt rotatePitch( -90, 0.25 );
	wait ( 0.5 );
	self.raised = false;
	self.moving = false;
	self.light light_off();
}

cargoship_targets()
{
	orgEnt = getEnt( self.target, "targetname" );
	assert( isdefined( orgEnt ) );
	
	self linkto (orgEnt);
	//self.origin = orgEnt.origin;
	//self.angles = orgEnt.angles;
	if ( ! isdefined ( orgEnt.script_noteworthy ) )
		orgEnt.script_noteworthy = "standard";
	
	if (orgEnt.script_noteworthy == "reverse" )
		orgEnt rotatePitch( 90, 0.25 );
	else
		orgEnt rotatePitch( -90, 0.25 );
	
	aim_assist_target = getEnt( orgEnt.target, "targetname" );
	aim_assist_target hide();
	aim_assist_target notsolid();
	
	while ( 1 )
	{
		self waittill ( "pop_up" );
		
		wait randomfloatrange (0, .2);
		
		//self playSound( "killhouse_target_up" );
		self playSound( "killhouse_target_up_metal" );
		self setCanDamage( true );
		if ( self.targetname != "friendly" )
			aim_assist_target enableAimAssist();
		if (orgEnt.script_noteworthy == "reverse" )
			orgEnt rotatePitch( -90, 0.25 );
		else
			orgEnt rotatePitch( 90, 0.25 );
		wait .25;
		
		if ( self.targetname == "friendly" )
		{
			self fail_if_damage_waiter();
		}
		else
		{
			while ( 1 )
			{
				self waittill ( "damage", amount, attacker, direction_vec, point, type );
				if( type == "MOD_IMPACT" )
					continue;
				else
					break;
			}
			self notify ( "hit" );
			self.health = 1000;
			level.targets_hit++;
			self playSound( "killhouse_buzzer" );
			self playSound( "killhouse_target_up" );
			aim_assist_target disableAimAssist();
		}
		
		if (orgEnt.script_noteworthy == "reverse" )
			orgEnt rotatePitch( 90, 0.25 );
		else
			orgEnt rotatePitch( -90, 0.25 );
		self setCanDamage( false );
		wait .25;
	}
}

getTargetDummies( group, laneID, dummyID )
{
	groupTargetDummies = getEntArray( group + "_target_dummy", "script_noteworthy" );

	targetDummies = [];
	for ( index = 0; index < groupTargetDummies.size; index++ )
	{
		targetDummy = groupTargetDummies[index];
		if ( isDefined( dummyID ) && targetDummy.dummyID != dummyID )
			continue;

		if ( isDefined( laneID ) && targetDummy.laneID != laneID )
			continue;

		targetDummies[targetDummies.size] = targetDummy;
	}

	if ( isDefined( laneID ) && isDefined( dummyID ) )
	{
		assert( targetDummies.size == 1 );
	}
	return targetDummies;
}

set_ammo()
{
	if ( (self.classname == "weapon_fraggrenade") || (self.classname == "weapon_flash_grenade") )
		self ItemWeaponSetAmmo( 1, 0 );
	else
		self ItemWeaponSetAmmo( 999, 999 );
}

ammoRespawnThink( flag, type, obj_flag )
{
	wait .2; //timing 
	weapon = self;
	ammoItemClass = weapon.classname;
	ammoItemOrigin = ( weapon.origin + (0,0,8) ); //wont spawn if inside something
	ammoItemAngles = weapon.angles;
	weapon set_ammo();
	
	obj_model = undefined;
	if ( isdefined ( weapon.target ) )
	{
		obj_model = getent ( weapon.target, "targetname" );
		obj_model.origin = weapon.origin;
		obj_model.angles = weapon.angles;
	}
	
	if ( type == "flash_grenade" )
		ammo_fraction_required = 1;
	else 
		ammo_fraction_required = .2;
		
	if ( isdefined ( flag ) )
	{
		//self delete();
		self.origin = self.origin + (0, 0, -10000);
		if ( isdefined ( obj_model ) )
			obj_model hide();
		
		flag_wait ( flag );
		
		if ( isdefined ( obj_model ) )
			obj_model show();
		self.origin = self.origin + (0, 0, 10000);
		//weapon = spawn ( ammoItemClass, ammoItemOrigin );
		//weapon.angles = ammoItemAngles;
		weapon set_ammo();
	}
	
	//if ( isdefined ( obj_model ) )
	//	obj_model hide();//temp hiding of glowing weapons
	
	if ( ( isdefined ( obj_model ) ) && ( isdefined ( obj_flag ) ) )
		obj_model thread delete_if_obj_complete( obj_flag );
	
	weapon waittill ( "trigger" );
	
	if ( isdefined ( obj_model ) )
		obj_model delete();
	
	while ( 1 )
	{
		wait 1;

		if ( ( level.player GetFractionMaxAmmo( type ) ) < ammo_fraction_required )
		{
			while ( distance( level.player.origin, ammoItemOrigin ) < 160 )
				wait 1;
	
			//if ( level.player pointInFov( ammoItemOrigin ) )
			//	continue;
	
			weapon = spawn ( ammoItemClass, ammoItemOrigin, 1 ); //suspended bit flag
			//weapon = spawn ( "weapon_mp5", ammoItemOrigin );
			weapon.angles = ammoItemAngles;
			weapon set_ammo();
			wait .2;
			weapon.origin = ( ammoItemOrigin + (0,0,-8) );
			//weapon.angles = ammoItemAngles;
			
			//weapon waittill ( "trigger" );
			while ( isdefined ( weapon ) )
				wait 1;
		}
	}
}

delete_if_obj_complete( obj_flag )
{
	self endon ( "death" );
	flag_wait ( obj_flag );
	self delete();
}


test2( type )
{
	while (1)
	{
		println ( type + " " + (level.player GetFractionMaxAmmo( type ) ) );
		wait 1;
	}	
}


pointInFov( origin )
{
    forward = anglesToForward( self.angles );
    return ( vectorDot( forward, origin - self.origin ) > 0.766 ); // 80 fov
}


registerObjective( objName, objText, objEntity )
{
	flag_init( objName );
	objID = level.objectives.size;

	newObjective = spawnStruct();
	newObjective.name = objName;
	newObjective.id = objID;
	newObjective.state = "invisible";
	newObjective.text = objText;
	newObjective.entity = objEntity;
	newObjective.added = false;

	level.objectives[objName] = newObjective;

	return newObjective;
}


setObjectiveState( objName, objState )
{
	assert( isDefined( level.objectives[objName] ) );

	objective = level.objectives[objName];
	objective.state = objState;

	if ( !objective.added )
	{
		objective_add( objective.id, objective.state, objective.text, objective.entity.origin );
		objective.added = true;
	}
	else
	{
		objective_state( objective.id, objective.State );
	}

	if ( objective.state == "done" )
		flag_set( objName );
}


setObjectiveString( objName, objString )
{
	objective = level.objectives[objName];
	objective.text = objString;

	objective_string( objective.id, objString );
}

setObjectiveLocation( objName, objLoc )
{
	objective = level.objectives[objName];
	objective.loc = objLoc;

	objective_position( objective.id, objective.loc.origin );
}

setObjectiveRemaining( objName, objString, objRemaining )
{
	assert( isDefined( level.objectives[objName] ) );

	objective = level.objectives[objName];

	if ( !objRemaining )
		objective_string( objective.id, objString );
	else
		objective_string( objective.id, objString, objRemaining );
}


printAboveHead (string, duration, offset, color)
{
	self endon ("death");

	if (!isdefined (offset))
		offset = (0, 0, 0);
	if (!isdefined (color))
		color = (1,0,0);

	for(i = 0; i < (duration * 20); i++)
	{
		if (!isalive (self))
			return;

		aboveHead = self getshootatpos() + (0,0,10) + offset;
		print3d (aboveHead, string, color, 1, 0.5);	// origin, text, RGB, alpha, scale
		wait (0.05);
	}
}

chair_guy_setup()
{
	chair_guy = getent ( "chair_guy", "script_noteworthy" );
	chair_guy_origin = getent ( "chair_guy_origin", "script_noteworthy" );
	chair_guy.animname = "generic";
	chair_guy gun_remove();
	chair_guy teleport ( chair_guy_origin.origin );
	//anim_loop_solo( guy, anime_idle, tag, ender, entity );
	chair_guy_origin thread anim_loop_solo(chair_guy, "chair_idles", undefined, undefined);
}

glowing_rope()
{
	rope = getent ( "glowing_rope", "targetname" );
	//if ( ! isdefined ( rope ) )
	//	return;
		
	rope hide();
	
	while ( 1 )
	{
		level waittill ( "show_glowing_rope" );
	
		rope show();
	
		level waittill ( "hide_glowing_rope" );
	
		rope hide();
	}
}


registerActions()
{
	level.actionBinds = [];
	registerActionBinding( "objectives",		"pause",				&"KILLHOUSE_HINT_CHECK_OBJECTIVES_PAUSED" );
	
	registerActionBinding( "objectives_pc",		"+scores",				&"KILLHOUSE_HINT_CHECK_OBJECTIVES_SCORES" );

	registerActionBinding( "pc_attack", 		"+attack",				&"KILLHOUSE_HINT_ATTACK_PC" );
	registerActionBinding( "pc_hip_attack", 	"+attack",				&"KILLHOUSE_HINT_HIP_ATTACK_PC" );
	
	registerActionBinding( "hip_attack", 		"+attack",				&"KILLHOUSE_HINT_HIP_ATTACK" );
	registerActionBinding( "attack", 			"+attack",				&"KILLHOUSE_HINT_ATTACK" );

	registerActionBinding( "stop_ads",			"+speed_throw",			&"KILLHOUSE_HINT_STOP_ADS_THROW" );
	registerActionBinding( "stop_ads",			"+speed",				&"KILLHOUSE_HINT_STOP_ADS" );
	registerActionBinding( "stop_ads",			"+toggleads_throw",		&"KILLHOUSE_HINT_STOP_ADS_TOGGLE_THROW" );
	registerActionBinding( "stop_ads",			"toggleads",			&"KILLHOUSE_HINT_STOP_ADS_TOGGLE" );
		
	registerActionBinding( "ads_360",			"+speed_throw",			&"KILLHOUSE_HINT_ADS_THROW_360" );
	registerActionBinding( "ads_360",			"+speed",				&"KILLHOUSE_HINT_ADS_360" );
	
	registerActionBinding( "ads",				"+speed_throw",			&"KILLHOUSE_HINT_ADS_THROW" );
	registerActionBinding( "ads",				"+speed",				&"KILLHOUSE_HINT_ADS" );
	registerActionBinding( "ads",				"+toggleads_throw",		&"KILLHOUSE_HINT_ADS_TOGGLE_THROW" );
	registerActionBinding( "ads",				"toggleads",			&"KILLHOUSE_HINT_ADS_TOGGLE" );
	
	registerActionBinding( "ads_switch",		"+speed_throw",			&"KILLHOUSE_HINT_ADS_SWITCH_THROW" );
	registerActionBinding( "ads_switch",		"+speed",				&"KILLHOUSE_HINT_ADS_SWITCH" );

	registerActionBinding( "ads_switch_shoulder",		"+speed_throw",			&"KILLHOUSE_HINT_ADS_SWITCH_THROW_SHOULDER" );
	registerActionBinding( "ads_switch_shoulder",		"+speed",				&"KILLHOUSE_HINT_ADS_SWITCH_SHOULDER" );

	registerActionBinding( "breath",			"+melee_breath",		&"KILLHOUSE_HINT_BREATH_MELEE" );
	registerActionBinding( "breath",			"+breath_sprint",		&"KILLHOUSE_HINT_BREATH_SPRINT" );
	registerActionBinding( "breath",			"+holdbreath",			&"KILLHOUSE_HINT_BREATH" );

	registerActionBinding( "melee",				"+melee",				&"KILLHOUSE_HINT_MELEE" );
	registerActionBinding( "melee",				"+melee_breath",		&"KILLHOUSE_HINT_MELEE_BREATH" );

	registerActionBinding( "prone",				"goprone",				&"KILLHOUSE_HINT_PRONE" );
	registerActionBinding( "prone",				"+stance",				&"KILLHOUSE_HINT_PRONE_STANCE" );
	registerActionBinding( "prone",				"toggleprone",			&"KILLHOUSE_HINT_PRONE_TOGGLE" );
	registerActionBinding( "prone",				"+prone",				&"KILLHOUSE_HINT_PRONE_HOLD" );
	registerActionBinding( "prone",				"lowerstance",			&"KILLHOUSE_HINT_PRONE_DOUBLE" );
//	registerActionBinding( "prone",				"+movedown",			&"" );

	registerActionBinding( "crouch",			"gocrouch",				&"KILLHOUSE_HINT_CROUCH" );
	registerActionBinding( "crouch",			"+stance",				&"KILLHOUSE_HINT_CROUCH_STANCE" );
	registerActionBinding( "crouch",			"togglecrouch",			&"KILLHOUSE_HINT_CROUCH_TOGGLE" );
//	registerActionBinding( "crouch",			"lowerstance",			&"KILLHOUSE_HINT_CROUCH_DOU" );
//	registerActionBinding( "crouch",			"+movedown",			&"KILLHOUSE_HINT_CROUCH" );

	registerActionBinding( "stand",				"+gostand",				&"KILLHOUSE_HINT_STAND" );
	registerActionBinding( "stand",				"+stance",				&"KILLHOUSE_HINT_STAND_STANCE" );

	registerActionBinding( "jump",				"+gostand",				&"KILLHOUSE_HINT_JUMP_STAND" );
	registerActionBinding( "jump",				"+moveup",				&"KILLHOUSE_HINT_JUMP" );

	registerActionBinding( "sprint",			"+breath_sprint",		&"KILLHOUSE_HINT_SPRINT_BREATH" );
	registerActionBinding( "sprint",			"+sprint",				&"KILLHOUSE_HINT_SPRINT" );

	registerActionBinding( "sprint_pc",			"+breath_sprint",		&"KILLHOUSE_HINT_SPRINT_BREATH_PC" );
	registerActionBinding( "sprint_pc",			"+sprint",				&"KILLHOUSE_HINT_SPRINT_PC" );

	registerActionBinding( "sprint2",			"+breath_sprint",		&"KILLHOUSE_HINT_HOLDING_SPRINT_BREATH" );
	registerActionBinding( "sprint2",			"+sprint",				&"KILLHOUSE_HINT_HOLDING_SPRINT" );

	registerActionBinding( "reload",			"+reload",				&"KILLHOUSE_HINT_RELOAD" );
	registerActionBinding( "reload",			"+usereload",			&"KILLHOUSE_HINT_RELOAD_USE" );

	registerActionBinding( "mantle",			"+gostand",				&"KILLHOUSE_HINT_MANTLE" );

	registerActionBinding( "sidearm",			"weapnext",				&"KILLHOUSE_HINT_SIDEARM_SWAP" );

	registerActionBinding( "primary",			"weapnext",				&"KILLHOUSE_HINT_PRIMARY_SWAP" );

	registerActionBinding( "frag",				"+frag",				&"KILLHOUSE_HINT_FRAG" );
	
	registerActionBinding( "flash",				"+smoke",				&"KILLHOUSE_HINT_FLASH" );

	registerActionBinding( "swap_launcher",		"+activate",			&"KILLHOUSE_HINT_SWAP" );
	registerActionBinding( "swap_launcher",		"+usereload",			&"KILLHOUSE_HINT_SWAP_RELOAD" );

	registerActionBinding( "firemode",			"+actionslot 2",		&"KILLHOUSE_HINT_FIREMODE" );

	registerActionBinding( "attack_launcher", 	"+attack",				&"KILLHOUSE_HINT_LAUNCHER_ATTACK" );

	registerActionBinding( "swap_explosives",	"+activate",			&"KILLHOUSE_HINT_EXPLOSIVES" );
	registerActionBinding( "swap_explosives",	"+usereload",			&"KILLHOUSE_HINT_EXPLOSIVES_RELOAD" );

	registerActionBinding( "plant_explosives",	"+activate",			&"KILLHOUSE_HINT_EXPLOSIVES_PLANT" );
	registerActionBinding( "plant_explosives",	"+usereload",			&"KILLHOUSE_HINT_EXPLOSIVES_PLANT_RELOAD" );

	registerActionBinding( "equip_C4",			"+actionslot 4",		&"KILLHOUSE_HINT_EQUIP_C4" );
	
	registerActionBinding( "throw_C4",			"+toggleads_throw",		&"KILLHOUSE_HINT_THROW_C4_TOGGLE" );
	registerActionBinding( "throw_C4",			"+speed_throw",			&"KILLHOUSE_HINT_THROW_C4_SPEED" );
	registerActionBinding( "throw_C4",			"+throw",				&"KILLHOUSE_HINT_THROW_C4" );
	
	registerActionBinding( "detonate_C4",		"+attack",				&"KILLHOUSE_DETONATE_C4" );

	initKeys();
	updateKeysForBindings();
}


registerActionBinding( action, binding, hint )
{
	if ( !isDefined( level.actionBinds[action] ) )
		level.actionBinds[action] = [];

	actionBind = spawnStruct();
	actionBind.binding = binding;
	actionBind.hint = hint;

	actionBind.keyText = undefined;
	actionBind.hintText = undefined;

	precacheString( hint );

	level.actionBinds[action][level.actionBinds[action].size] = actionBind;
}


getActionBind( action )
{
    for ( index = 0; index < level.actionBinds[action].size; index++ )
    {
        actionBind = level.actionBinds[action][index];

        binding = getKeyBinding( actionBind.binding );
        if ( !binding["count"] )
            continue;

        return level.actionBinds[action][index];
    }

    return level.actionBinds[action][0];//unbound
}


updateKeysForBindings()
{
	if ( level.console )
	{
		setKeyForBinding( getCommandFromKey( "BUTTON_START" ), "BUTTON_START" );
		setKeyForBinding( getCommandFromKey( "BUTTON_A" ), "BUTTON_A" );
		setKeyForBinding( getCommandFromKey( "BUTTON_B" ), "BUTTON_B" );
		setKeyForBinding( getCommandFromKey( "BUTTON_X" ), "BUTTON_X" );
		setKeyForBinding( getCommandFromKey( "BUTTON_Y" ), "BUTTON_Y" );
		setKeyForBinding( getCommandFromKey( "BUTTON_LSTICK" ), "BUTTON_LSTICK" );
		setKeyForBinding( getCommandFromKey( "BUTTON_RSTICK" ), "BUTTON_RSTICK" );
		setKeyForBinding( getCommandFromKey( "BUTTON_LSHLDR" ), "BUTTON_LSHLDR" );
		setKeyForBinding( getCommandFromKey( "BUTTON_RSHLDR" ), "BUTTON_RSHLDR" );
		setKeyForBinding( getCommandFromKey( "BUTTON_LTRIG" ), "BUTTON_LTRIG" );
		setKeyForBinding( getCommandFromKey( "BUTTON_RTRIG" ), "BUTTON_RTRIG" );
	}
	else
	{
		//level.kbKeys = "1234567890-=QWERTYUIOP[]ASDFGHJKL;'ZXCVBNM,./";
		//level.specialKeys = [];

		for ( index = 0; index < level.kbKeys.size; index++ )
		{
			setKeyForBinding( getCommandFromKey( level.kbKeys[index] ), level.kbKeys[index] );
		}

		for ( index = 0; index < level.specialKeys.size; index++ )
		{
			setKeyForBinding( getCommandFromKey( level.specialKeys[index] ), level.specialKeys[index] );
		}

	}
}


getActionForBinding( binding )
{
	arrayKeys = getArrayKeys( level.actionBinds );
	for ( index = 0; index < arrayKeys; index++ )
	{
		bindArray = level.actionBinds[arrayKeys[index]];
		for ( bindIndex = 0; bindIndex < bindArray.size; bindIndex++ )
		{
			if ( bindArray[bindIndex].binding != binding )
				continue;

			return arrayKeys[index];
		}
	}
}

setKeyForBinding( binding, key )
{
	if ( binding == "" )
		return;

	arrayKeys = getArrayKeys( level.actionBinds );
	for ( index = 0; index < arrayKeys.size; index++ )
	{
		bindArray = level.actionBinds[arrayKeys[index]];
		for ( bindIndex = 0; bindIndex < bindArray.size; bindIndex++ )
		{
			if ( bindArray[bindIndex].binding != binding )
				continue;

			bindArray[bindIndex].key = key;
		}
	}
}


hint( text, timeOut, double_line )
{
	if ( getdvar( "chaplincheat" ) == "1" )
		return;

	clear_hints();
	level endon ( "clearing_hints" );

	add_hint_background( double_line );
	level.hintElem = createFontString( "objective", level.hint_text_size );
	level.hintElem.hidewheninmenu = true;
	level.hintElem setPoint( "TOP", undefined, 0, 110 );
	level.hintElem.sort = 0.5;

	level.hintElem setText( text );
	//level.hintElem endon ( "death" );

	if ( isDefined( timeOut ) )
		wait ( timeOut );
	else
		return;

	level.hintElem fadeOverTime( 0.5 );
	level.hintElem.alpha = 0;
	wait ( 0.5 );

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

keyHint( actionName, timeOut, doubleline )
{
	if ( getdvar( "chaplincheat" ) == "1" )
		return;

	clear_hints();
	level endon ( "clearing_hints" );

	if ( isdefined ( doubleline ) )
		add_hint_background( doubleline );
	else
		add_hint_background();
	level.hintElem = createFontString( "objective", level.hint_text_size );
	level.hintElem.hidewheninmenu = true;
	level.hintElem setPoint( "TOP", undefined, 0, 110 );
	level.hintElem.sort = 0.5;

	actionBind = getActionBind( actionName );
	if ( ( actionName == "melee" ) && ( level.xenon ) && ( actionBind.key == "BUTTON_RSTICK" ) )
		level.hintElem setText( &"KILLHOUSE_HINT_MELEE_CLICK" );
	else
		level.hintElem setText( actionBind.hint );
	//level.hintElem endon ( "death" );

	notifyName = "did_action_" + actionName;
	for ( index = 0; index < level.actionBinds[actionName].size; index++ )
	{
		actionBind = level.actionBinds[actionName][index];
		level.player notifyOnCommand( notifyName, actionBind.binding );
	}

	if ( isDefined( timeOut ) )
		level.player thread notifyOnTimeout( notifyName, timeOut );
	level.player waittill( notifyName );

	level.hintElem fadeOverTime( 0.5 );
	level.hintElem.alpha = 0;

	wait ( 0.5 );
	
	clear_hints();
}

second_sprint_hint()
{
	level endon ( "kill_sprint_hint" );
	//getEnt( "obstacleTraining_sprint", "targetname" ) waittill ( "trigger" );

	wait .5;
	actionBind = getActionBind( "sprint2" );
	hint( actionBind.hint, 5 );
}


notifyOnTimeout( finishedNotify, timeOut )
{
	self endon( finishedNotify );
	wait timeOut;
	self notify( finishedNotify );
}


training_stallTriggers( group, endonString )
{
	stallTriggers = getEntArray( group + "_stall_trigger", "script_noteworthy" );

	for ( index = 0; index < stallTriggers.size; index++ )
		stallTriggers[index] thread stallTriggerThink( group );

	thread wrongStallNag( endonString );
}


wrongStallNag( endonString )
{
	level endon ( endonString );
	for( ;; )
	{
		level waittill ( "player_wrong_stall", stallString );

		level.marine2 anim_single_solo( level.marine2, "gotofour" );

		wait ( 10.0 );
	}
}


stallTriggerThink( group )
{
	for ( ;; )
	{
		self waittill ( "trigger", entity );

		if ( entity != level.player )
			continue;

		if ( self.targetname != "stall4" )
			level notify ( "player_wrong_stall", self.targetname );
		else
			flag_set( group + "_player_at_stall" );
	}
}

initKeys()
{
	level.kbKeys = "1234567890-=qwertyuiop[]asdfghjkl;'zxcvbnm,./";

	level.specialKeys = [];

	level.specialKeys[level.specialKeys.size] = "TAB";
	level.specialKeys[level.specialKeys.size] = "ENTER";
	level.specialKeys[level.specialKeys.size] = "ESCAPE";
	level.specialKeys[level.specialKeys.size] = "SPACE";
	level.specialKeys[level.specialKeys.size] = "BACKSPACE";
	level.specialKeys[level.specialKeys.size] = "UPARROW";
	level.specialKeys[level.specialKeys.size] = "DOWNARROW";
	level.specialKeys[level.specialKeys.size] = "LEFTARROW";
	level.specialKeys[level.specialKeys.size] = "RIGHTARROW";
	level.specialKeys[level.specialKeys.size] = "ALT";
	level.specialKeys[level.specialKeys.size] = "CTRL";
	level.specialKeys[level.specialKeys.size] = "SHIFT";
	level.specialKeys[level.specialKeys.size] = "CAPSLOCK";
	level.specialKeys[level.specialKeys.size] = "F1";
	level.specialKeys[level.specialKeys.size] = "F2";
	level.specialKeys[level.specialKeys.size] = "F3";
	level.specialKeys[level.specialKeys.size] = "F4";
	level.specialKeys[level.specialKeys.size] = "F5";
	level.specialKeys[level.specialKeys.size] = "F6";
	level.specialKeys[level.specialKeys.size] = "F7";
	level.specialKeys[level.specialKeys.size] = "F8";
	level.specialKeys[level.specialKeys.size] = "F9";
	level.specialKeys[level.specialKeys.size] = "F10";
	level.specialKeys[level.specialKeys.size] = "F11";
	level.specialKeys[level.specialKeys.size] = "F12";
	level.specialKeys[level.specialKeys.size] = "INS";
	level.specialKeys[level.specialKeys.size] = "DEL";
	level.specialKeys[level.specialKeys.size] = "PGDN";
	level.specialKeys[level.specialKeys.size] = "PGUP";
	level.specialKeys[level.specialKeys.size] = "HOME";
	level.specialKeys[level.specialKeys.size] = "END";
	level.specialKeys[level.specialKeys.size] = "MOUSE1";
	level.specialKeys[level.specialKeys.size] = "MOUSE2";
	level.specialKeys[level.specialKeys.size] = "MOUSE3";
	level.specialKeys[level.specialKeys.size] = "MOUSE4";
	level.specialKeys[level.specialKeys.size] = "MOUSE5";
	level.specialKeys[level.specialKeys.size] = "MWHEELUP";
	level.specialKeys[level.specialKeys.size] = "MWHEELDOWN";
	level.specialKeys[level.specialKeys.size] = "AUX1";
	level.specialKeys[level.specialKeys.size] = "AUX2";
	level.specialKeys[level.specialKeys.size] = "AUX3";
	level.specialKeys[level.specialKeys.size] = "AUX4";
	level.specialKeys[level.specialKeys.size] = "AUX5";
	level.specialKeys[level.specialKeys.size] = "AUX6";
	level.specialKeys[level.specialKeys.size] = "AUX7";
	level.specialKeys[level.specialKeys.size] = "AUX8";
	level.specialKeys[level.specialKeys.size] = "AUX9";
	level.specialKeys[level.specialKeys.size] = "AUX10";
	level.specialKeys[level.specialKeys.size] = "AUX11";
	level.specialKeys[level.specialKeys.size] = "AUX12";
	level.specialKeys[level.specialKeys.size] = "AUX13";
	level.specialKeys[level.specialKeys.size] = "AUX14";
	level.specialKeys[level.specialKeys.size] = "AUX15";
	level.specialKeys[level.specialKeys.size] = "AUX16";
	level.specialKeys[level.specialKeys.size] = "KP_HOME";
	level.specialKeys[level.specialKeys.size] = "KP_UPARROW";
	level.specialKeys[level.specialKeys.size] = "KP_PGUP";
	level.specialKeys[level.specialKeys.size] = "KP_LEFTARROW";
	level.specialKeys[level.specialKeys.size] = "KP_5";
	level.specialKeys[level.specialKeys.size] = "KP_RIGHTARROW";
	level.specialKeys[level.specialKeys.size] = "KP_END";
	level.specialKeys[level.specialKeys.size] = "KP_DOWNARROW";
	level.specialKeys[level.specialKeys.size] = "KP_PGDN";
	level.specialKeys[level.specialKeys.size] = "KP_ENTER";
	level.specialKeys[level.specialKeys.size] = "KP_INS";
	level.specialKeys[level.specialKeys.size] = "KP_DEL";
	level.specialKeys[level.specialKeys.size] = "KP_SLASH";
	level.specialKeys[level.specialKeys.size] = "KP_MINUS";
	level.specialKeys[level.specialKeys.size] = "KP_PLUS";
	level.specialKeys[level.specialKeys.size] = "KP_NUMLOCK";
	level.specialKeys[level.specialKeys.size] = "KP_STAR";
	level.specialKeys[level.specialKeys.size] = "KP_EQUALS";
	level.specialKeys[level.specialKeys.size] = "PAUSE";
	level.specialKeys[level.specialKeys.size] = "SEMICOLON";
	level.specialKeys[level.specialKeys.size] = "COMMAND";
	level.specialKeys[level.specialKeys.size] = "181";
	level.specialKeys[level.specialKeys.size] = "191";
	level.specialKeys[level.specialKeys.size] = "223";
	level.specialKeys[level.specialKeys.size] = "224";
	level.specialKeys[level.specialKeys.size] = "225";
	level.specialKeys[level.specialKeys.size] = "228";
	level.specialKeys[level.specialKeys.size] = "229";
	level.specialKeys[level.specialKeys.size] = "230";
	level.specialKeys[level.specialKeys.size] = "231";
	level.specialKeys[level.specialKeys.size] = "232";
	level.specialKeys[level.specialKeys.size] = "233";
	level.specialKeys[level.specialKeys.size] = "236";
	level.specialKeys[level.specialKeys.size] = "241";
	level.specialKeys[level.specialKeys.size] = "242";
	level.specialKeys[level.specialKeys.size] = "243";
	level.specialKeys[level.specialKeys.size] = "246";
	level.specialKeys[level.specialKeys.size] = "248";
	level.specialKeys[level.specialKeys.size] = "249";
	level.specialKeys[level.specialKeys.size] = "250";
	level.specialKeys[level.specialKeys.size] = "252";
}



turn_off_frag_lights()
{
	frag_lights = getentarray ( "frag_lights", "script_noteworthy" );
	
	for(i = 0; i < frag_lights.size; i++)
		frag_lights[ i ] setLightIntensity( 0 );
}

blink_primary_lights()
{
	frag_lights = getentarray ( "frag_lights", "script_noteworthy" );
	
	while( 1 )
	{
		wait 1;
		for(i = 0; i < frag_lights.size; i++)
			frag_lights[ i ] setLightIntensity( 1 );
		wait 1;
	
		for(i = 0; i < frag_lights.size; i++)
			frag_lights[ i ] setLightIntensity( 0 );
	}
}


melon_think()
{	
	melon = getEnt ( "scr_watermelon", "targetname" );
	melon_model = getEnt ( melon.target, "targetname" );
	melon_model hide();
	melon_model notsolid();

	level waittill ( "show_melon" );
	
	melon_model show();
	melon_model solid();
	
	melon waittill ( "trigger" );
	
	melon playsound ( "melee_knife_hit_watermelon" );

	flag_set ( "melee_complete" );
	playfx (level._effect["watermelon"], melon_model.origin);
	melon_model hide();
	melon_model notsolid();
}

test()
{
	while (1)
	{
		println (" ammo: " + level.player GetWeaponAmmoClip( level.gunPrimary )	);
		wait 1;
	}
}



clear_hints_on_stand()
{
	while (level.player GetStance() != "stand" )
		wait .05;
	clear_hints();
}


move_mac()
{
	self waittill ( "trigger" );
	
	level.mac set_generic_run_anim(  "jog" );
	level.mac setgoalnode ( getnode ( self.target, "targetname" ) );
}

loop_obstacle()
{
	for ( index = 0; index < level.buddies.size; index++ )
	{
		level.mac set_generic_run_anim(  "jog" );
		level.buddies[index] thread obstacleTrainingCourseThink( level.buddies[index].startNode );
	}
	
	level.mac set_generic_run_anim( "walk", true );
	level.mac setgoalnode ( getnode ( "mac_start_node", "targetname" ) );
	level.mac waittill ( "goal" );
	
	//level notify ( "start_course" );
}

obstacleTraining_buddies()
{
	buddiesInit();

	for ( index = 0; index < level.buddies.size; index++ )
	{
		buddy = level.buddies[index];
		buddy.startNode = getNode( "obstacle_lane_node" + buddy.buddyID, "targetname" );

		level.buddies[index] thread obstacleTrainingCourseThink( buddy.startNode );
	}
}

buddiesInit()
{
	level.buddies = getEntArray( "buddy", "script_noteworthy" );
	level.buddiesByID = [];
	for ( index = 0; index < level.buddies.size; index++ )
	{
		level.buddies[index].buddyID = int( level.buddies[index].targetname[5] );
		level.buddiesByID[level.buddies[index].buddyID] = level.buddies[index];
	}
}

obstacleTrainingCourseThink( goalNode )
{
	level endon( "obstacleTraining_end" );

	self.goalradius = 32;
	self setGoalNode( goalNode );
	self waittill ( "goal" );

	flag_wait ( "start_course" );
	
	noteworthy_function[ "prone" ] = ::set_allowed_stances_prone;
	noteworthy_function[ "stand" ] = ::set_allowed_stances_all;
	noteworthy_function[ "sprint" ] = ::set_sprint;
	
	self.disablearrivals = true;
	while ( isDefined( goalNode.target ) )
	{
		goalNode = getNode( goalNode.target, "targetname" );

		self setGoalNode( goalNode );
		self waittill ( "goal" );

		if ( !isDefined( goalNode.script_noteworthy ) )
			continue;
			
		[[ noteworthy_function[ goalNode.script_noteworthy ] ]]();
	}
	self.disablearrivals = false;
}

set_allowed_stances_prone()
{
	self allowedStances( "prone" );
}

set_allowed_stances_all()
{
	self allowedStances( "prone", "stand", "crouch" );
}

set_sprint()
{
	self.sprint = true;
}


frag_trigger_think( flag, trigger, continuous )
{
	flag_init( flag );
	trigger enablegrenadetouchdamage();
	if ( isdefined ( trigger.target ) )
		trigger.light = getEnt( trigger.target, "targetname" );
	
	if ( isdefined ( trigger.light ) )
		trigger.light thread flicker_on();
	
	if( !isDefined( continuous ) )
		continuous = false;
	
	trigger _flag_wait_trigger( flag, continuous );
	
	level.player playSound( "killhouse_buzzer" );
	
	if ( isdefined ( trigger.light ) )
		trigger.light thread flicker_off();
	
	return trigger;
}

light_off()
{
	self setLightIntensity( 0 );
}

light_on()
{
	self setLightIntensity( 1 );
}

flicker_off()
{
	wait randomfloatrange ( .2, .5);
	self setLightIntensity( 0 );
	wait randomfloatrange ( .05, .1);
	self setLightIntensity( .7 );
	wait randomfloatrange ( .1, .2);
	self setLightIntensity( 0 );
	wait randomfloatrange ( .05, .4);
	self setLightIntensity( .5 );
	wait randomfloatrange ( .1, .5);
	self setLightIntensity( 0 );
}

flicker_on()
{
	wait randomfloatrange ( .2, .5);
	self setLightIntensity( .4 );
	wait randomfloatrange ( .2, .4);
	self setLightIntensity( 0 );
	wait randomfloatrange ( .2, .5);
	self setLightIntensity( .6 );
	wait randomfloatrange ( .05, .2);
	self setLightIntensity( 0 );
	wait randomfloatrange ( .05, .1);
	self setLightIntensity( 1 );
}

in_pit()
{
	pit = getEnt( "safety_pit", "targetname" );
	if ( !level.player istouching( pit ) )
		return false;
	return true;
}

frag_too_low_hint()
{
	level endon ( "fragTraining_end" );
	self enablegrenadetouchdamage();
	while( 1 )
	{
		self waittill ( "trigger" );	
		clear_hints();
		hint( &"KILLHOUSE_HINT_GRENADE_TOO_LOW", 6 ); 
	}
}

walk_to( goal )
{
	self set_generic_run_anim( "walk", true );
	//self.walk_combatanim = level.scr_anim[ "generic" ][ "walk" ];
	//self.walk_noncombatanim = level.scr_anim[ "generic" ][ "walk" ];
	self.disablearrivals = true;
	self.disableexits = true;
	
	self.goalradius = 32;
	self setgoalnode ( goal );
	self waittill ( "goal" );
	self anim_generic( self, "patrol_stop" );
	self setgoalpos ( self.origin );
}

dialog_nag_till_in_pit()
{
	level endon ( "in_pit_with_frags" );
	while( 1 )
	{
		level.newcastle execDialog( "getinsafety" );
		wait 10;
	}
}

pause_anim()
{
	self setflaggedanim( "single anim", self getanim( "reveal" ), 1, 0, 0 ); // pause
}

unpause_anim()
{
	self setflaggedanim( "single anim", self getanim( "reveal" ), 1, 0, 1 ); // unpause
}


M203_icon_hint()
{
	if ( getdvar( "chaplincheat" ) == "1" )
		return;

	clear_hints();
	//level endon ( "clearing_hints" );
	
	add_hint_background();
	//Notice you now have an icon of a grenade launcher on your HUD.
	level.hintElem = createFontString( "objective", level.hint_text_size );
	level.hintElem.hidewheninmenu = true;
	level.hintElem setPoint( "TOP", undefined, 0, 130 );
	level.hintElem.sort = 0.5;

	level.hintElem setText( &"KILLHOUSE_HINT_LAUNCHER_ICON" );
	
	iconElem = createIcon( "hud_dpad", 32, 32 );
	iconElem.hidewheninmenu = true;
	iconElem setPoint( "TOP", undefined, 16, 165 );
	
	iconElem2 = createIcon( "hud_icon_40mm_grenade", 64, 32 );
	iconElem2.hidewheninmenu = true;
	iconElem2 setPoint( "TOP", undefined, -32, 165 );

	level waittill ( "clearing_hints" );

	iconElem setPoint( "CENTER", "BOTTOM", -304, -20, 1.0 );
	iconElem2 setPoint( "CENTER", "BOTTOM", -336, -20, 1.0 );
	
	iconElem scaleovertime(1, 20, 20);
	iconElem2 scaleovertime(1, 20, 20);
	
	wait .70;
	iconElem fadeovertime(.15);
	iconElem.alpha = 0;
	
	iconElem2 fadeovertime(.15);
	iconElem2.alpha = 0;
	wait .5;
	
	//clear_hints();
}


C4_icon_hint()
{
	if ( getdvar( "chaplincheat" ) == "1" )
		return;

	clear_hints();
	level endon ( "clearing_hints" );

	add_hint_background();
	level.hintElem = createFontString( "objective", level.hint_text_size );
	level.hintElem.hidewheninmenu = true;
	level.hintElem setPoint( "TOP", undefined, 0, 130 );
	level.hintElem.sort = 0.5;

	level.hintElem setText( &"KILLHOUSE_HINT_C4_ICON" );
	//level.hintElem endon ( "death" );

	level.iconElem = createIcon( "hud_dpad", 32, 32 );
	level.iconElem.hidewheninmenu = true;
	level.iconElem setPoint( "TOP", undefined, 0, 175 );
	
	level.iconElem2 = createIcon( "hud_icon_c4", 32, 32 );
	level.iconElem2.hidewheninmenu = true;
	level.iconElem2 setPoint( "TOP", undefined, 0, 205 );	


	level waittill ( "c4_equiped" );

	level.iconElem3 = createIcon( "hud_arrow_down", 24, 24 );
	level.iconElem3.hidewheninmenu = true;
	level.iconElem3 setPoint( "TOP", undefined, 0, 179 );
	level.iconElem3.sort = 1;
	level.iconElem3.color = (1,1,0);
	level.iconElem3.alpha = .7;

	level waittill ( "C4_the_car" );
	
	
	level.iconElem setPoint( "CENTER", "BOTTOM", -320, -20, 1.0 );
	level.iconElem2 setPoint( "CENTER", "BOTTOM", -320, -20, 1.0 );
	level.iconElem3 setPoint( "CENTER", "BOTTOM", -320, -20, 1.0 );
	
	level.iconElem scaleovertime(1, 20, 20);
	level.iconElem2 scaleovertime(1, 20, 20);
	level.iconElem3 scaleovertime(1, 15, 15);
	
	wait .85;
	level.iconElem fadeovertime(.15);
	level.iconElem.alpha = 0;
	
	level.iconElem2 fadeovertime(.15);
	level.iconElem2.alpha = 0;
	
	level.iconElem3 fadeovertime(.15);
	level.iconElem3.alpha = 0;
	
	level.iconElem destroy();
	level.iconElem2 destroy();
	level.iconElem3 destroy();
}


auto_aim()
{
	if ( level.console )
	{
		if(isdefined( getdvar("input_autoaim") ) )
			if ( getdvar("input_autoaim") == "1" )
				return true;
	}
	return false;
}



is_ps3_flipped()
{
	ps3_flipped = false;
	config = getdvar ( "gpad_buttonsConfig" );
	if ( isdefined ( config ) )
		if ( issubstr ( config , "_alt" ) )
			ps3_flipped = true;
	return ps3_flipped;
}

gaz_animation( name, delay )
{
	if( isdefined( delay ) )
		wait delay;
		
	if( !flag( "gaz_in_idle_position" ) )
		return;
	
	level.waters notify( "gaz_animation" );
	level.waters endon( "gaz_animation" );
	
	level.waters.ref_node notify( "stop_loop" );
	level.waters stopanimscripted();
	level.waters.ref_node anim_single_solo( level.waters, name );
	
	level.waters.ref_node thread anim_loop_solo( level.waters, "killhouse_gaz_idleB", undefined, "stop_loop" );
}