#include common_scripts\utility;
#include maps\_utility;
#include maps\_ac130;
#include maps\ac130_code;

main()
{
	if ( getdvar( "credits_load" ) == "1" )
	{
		thread maps\ac130_credits::credits_main();
		return;
	}
	
	if ( getdvar( "ac130_gameplay_enabled") == "" )
		setdvar( "ac130_gameplay_enabled", "1" );
	
	setExpFog( 1000, 17300, 0/255, 0/255, 0/255, 0 );
	setsaveddvar( "scr_dof_enable", "0" );
	precacheLevelStuff();
	
	flag_init( "mission_failed" );
	flag_init( "hijacked_vehicles_stopped" );
	flag_init( "friendlies_loading_vehicles" );
	flag_init( "choppers_inbound" );
	flag_init( "friendlies_moving_to_choppers" );
	flag_init( "ignore_friendly_move_commands" );
	flag_init( "friendlies_in_choppers" );
	flag_init( "choppers_flew_away" );
	
	level.hintPrintDuration = 5.0;
	level.minimumFriendlyCount = 3;
	level.minimumAutosaveFriendlyCount = 5;
	
	add_start( "church", 	::start_church, &"STARTS_CHURCH" );
	add_start( "field", 	::start_field, &"STARTS_FIELD" );
	add_start( "hijack", 	::start_hijack, &"STARTS_HIJACK" );
	add_start( "junkyard",	::start_junkyard, &"STARTS_JUNKYARD" );
	default_start( ::start_start );
	
	scriptCalls();
	
	wait 10;
	objective_add( 1, "current", &"AC130_OBJECTIVE_SUPPORT_FRIENDLIES", ( 0, 0, 0 ) );
}

start_start()
{
	level waittill( "introscreen_almost_complete" );
	
	spawn_friendlies( "friends_start" );
	thread dialog_opening();
	thread gameplay_start();
}

start_church()
{
	spawn_friendlies( "friends_church" );
	level.ac130.origin = getent( "ac130_waypoint_fight1", "targetname" ).origin;
	flag_set( "clear_to_engage" );
	flag_set( "allow_context_sensative_dialog" );
	thread dialog_cleared_to_engage();
	thread gameplay_chuch();
}

start_field()
{
	spawn_friendlies( "friends_field1" );
	level.ac130.origin = getent( "ac130_waypoint_field1", "targetname" ).origin;
	flag_set( "clear_to_engage" );
	flag_set( "allow_context_sensative_dialog" );
	thread gameplay_fields();
}

start_hijack()
{
	spawn_friendlies( "friends_hijack" );
	level.ac130.origin = getent( "ac130_waypoint_hijack", "targetname" ).origin;
	flag_set( "clear_to_engage" );
	flag_set( "allow_context_sensative_dialog" );
	wait 0.05;
	thread gameplay_hijack();
}

start_junkyard()
{
	spawn_friendlies( "friends_junkyard" );
	level.ac130.origin = getent( "ac130_waypoint_junkyard1", "targetname" ).origin;
	flag_set( "clear_to_engage" );
	flag_set( "allow_context_sensative_dialog" );
	wait 0.05;
	thread gameplay_junkyard1();
}

gameplay_start()
{
	move_friendlies( "friendly_location_01" );
	thread movePlaneToWaypoint( "ac130_waypoint_fight1" );
	wait 27;
	thread gameplay_chuch();
}

gameplay_chuch()
{
	thread autosaveFriendlyCountCheck( "church" );
	
	if ( getdvar( "ac130_gameplay_enabled") == "1" )
	{
		resetPlayerKillCount();
		
		spawn_vehicle( "first_truck_spawn_trigger" );
		wait 5;
		spawn_enemies( "first_truck_reinforcement_spawn_trigger" );
		wait 5;
		spawn_enemies( "first_shack_spawner_trigger" );
		spawn_enemies( "church_spawner_trigger" );
		spawn_enemies( "church_spawner_trigger2" );
		spawn_enemies( "house1_spawner_trigger" );
		wait 25;
		move_friendlies( "friendly_location_02" );
		
		waitForPlayerKillCount( 7 );
		
		wait 15;
	}
	
	thread movePlaneToWaypoint( "ac130_waypoint_fight2" );
	
	if ( getdvar( "ac130_gameplay_enabled") == "1" )
	{
		resetPlayerKillCount();
		
		stop_enemies( "first_shack_spawner_trigger" );
		spawn_enemies( "house2_spawner_trigger" );
		
		wait 10;
		
		waitForPlayerKillCount( 5 );
		
		stop_enemies( "church_spawner_trigger2" );
	}
	
	move_friendlies( "friendly_location_03" );
	
	if ( getdvar( "ac130_gameplay_enabled") == "1" )
	{
		wait 12;
		stop_enemies( "church_spawner_trigger" );
	}
	
	move_friendlies( "friendly_location_04" );
	
	if ( getdvar( "ac130_gameplay_enabled") == "1" )
	{
		spawn_vehicle( "long_road_truck_spawn_trigger" );
		wait 12;
		stop_enemies( "house1_spawner_trigger" );
		stop_enemies( "house2_spawner_trigger" );
	}
	
	thread gameplay_fields();
}

gameplay_fields()
{
	thread dialog_passing_church();
	thread autosaveFriendlyCountCheck( "fields" );
	
	thread movePlaneToWaypoint( "ac130_waypoint_field1" );
	
	move_friendlies( "friendly_location_05" );
	
	if ( getdvar( "ac130_gameplay_enabled") == "1" )
	{
		resetPlayerKillCount();
		
		wait 8;
		spawn_enemies( "field1_spawner_trigger" );
		wait 8;
		spawn_vehicle( "field1_truck_spawn_trigger" );
		wait 20;
		
		waitForPlayerKillCount( 10 );
		
		stop_enemies( "field1_spawner_trigger" );
		waittill_dead( getEnemiesInZone( "volume_field1" ), undefined, 30 );
	}
	
	thread gameplay_hijack();
}

#using_animtree( "vehicles" );
gameplay_hijack()
{
	thread ac130_move_in();
	thread movePlaneToWaypoint( "ac130_waypoint_hijack" );
	
	move_friendlies( "friendly_location_06" );
	
	wait 10;
	
	thread autosaveFriendlyCountCheck( "hijack" );
	
	vehGroup = [];
	vehGroup[ 0 ] = [];
	vehGroup[ 1 ] = [];
	if ( getdvar( "ac130_gameplay_enabled") == "1" )
	{
		maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 5 );
		
		level.getaway_vehicle_1 = getent( "getaway_vehicle_1", "targetname" );
		if ( !isdefined( level.getaway_vehicle_1 ) )
			level.getaway_vehicle_1 = maps\_vehicle::waittill_vehiclespawn( "getaway_vehicle_1" );
		
		level.getaway_vehicle_2 = getent( "getaway_vehicle_2", "targetname" );
		if ( !isdefined( level.getaway_vehicle_2 ) )
			level.getaway_vehicle_2 = maps\_vehicle::waittill_vehiclespawn( "getaway_vehicle_2" );
		
		level.getaway_vehicle_1 thread friendly_fire_vehicle_thread();
		level.getaway_vehicle_2 thread friendly_fire_vehicle_thread();
		
		thread civilian_car_riders_spawn_and_idle();
		
		thread dialog_hijack();
		
		//-------------------------------------------
		// stop the vehicles at the hijack roadbloack
		//-------------------------------------------
		getVehicleNode( "vehicle_hijack_start_stop", "script_noteworthy" ) waittill( "trigger" );
		level.getaway_vehicle_1 setSpeed( 0, 10 );
		level.getaway_vehicle_2 setSpeed( 0, 10 );
		flag_set( "hijacked_vehicles_stopped" );
		wait 3;
		
		//------------------------------------------------------------------
		// cars are stopped - create 2 groups of friendlies to hijack 2 cars
		//------------------------------------------------------------------
		wait 2;
		for( i = 0 ; i < level.friendlies.size ; i++ )
		{
			if ( !isdefined( level.friendlies[ i ] ) )
				continue;
			if ( !isalive( level.friendlies[ i ] ) )
				continue;
			if ( vehGroup[ 0 ].size < 4 )
				vehGroup[ 0 ][ vehGroup[ 0 ].size ] = level.friendlies[ i ];
			else if ( vehGroup[ 1 ].size < 4 )
				vehGroup[ 1 ][ vehGroup[ 1 ].size ] = level.friendlies[ i ];
			else
				assertMsg( "Tried to load more than 8 friendlies into two vehicles." );
		}
		// there should at least be one vehicle since mission is failed if there is less than 3 AI alive
		assert( vehGroup[ 0 ].size > 0 );
		
		// Asign animnames
		for( p = 0 ; p < 2 ; p++ )
		{
			for( i = 0 ; i < vehGroup[ p ].size ; i++ )
			{
				if ( p == 0 )
				{
					switch( i )
					{
						case 0:
							vehGroup[ p ][ i ].animname = "hijacker_car1_guy1";
							vehGroup[ p ][ i ].sitTag = "tag_driver";
							break;
						case 1:
							vehGroup[ p ][ i ].animname = "hijacker_car1_guy2";
							vehGroup[ p ][ i ].sitTag = "tag_passenger";
							break;
						case 2:
							vehGroup[ p ][ i ].animname = "hijacker_car1_guy3";
							vehGroup[ p ][ i ].sitTag = "tag_guy0";
							break;
						case 3:
							vehGroup[ p ][ i ].animname = "hijacker_car1_guy4";
							vehGroup[ p ][ i ].sitTag = "tag_guy1";
							break;
					}
				}
				else
				{
					switch( i )
					{
						case 0:
							vehGroup[ p ][ i ].animname = "hijacker_car2_guy1";
							vehGroup[ p ][ i ].sitTag = "tag_driver";
							break;
						case 1:
							vehGroup[ p ][ i ].animname = "hijacker_car2_guy2";
							vehGroup[ p ][ i ].sitTag = "tag_passenger";
							break;
						case 2:
							vehGroup[ p ][ i ].animname = "hijacker_car2_guy3";
							vehGroup[ p ][ i ].sitTag = "tag_guy0";
							break;
						case 3:
							vehGroup[ p ][ i ].animname = "hijacker_car2_guy4";
							vehGroup[ p ][ i ].sitTag = "tag_guy1";
							break;
					}
				}
			}
		}
		
		//------------------------------------------------------------------------
		// Get friendlies into animation position, then play the hijack animations
		//------------------------------------------------------------------------
		
		thread do_hijack( level.getaway_vehicle_1, vehGroup[ 0 ], %ac130_carjack_door_1a, %ac130_carjack_door_others );
		thread do_hijack( level.getaway_vehicle_2, vehGroup[ 1 ], %ac130_carjack_door_1b, %ac130_carjack_door_others );
		flag_set( "friendlies_loading_vehicles" );
		level.getaway_vehicle_1 thread mission_fail_vehicle_death();
		level.getaway_vehicle_2 thread mission_fail_vehicle_death();
	}
	
	if ( getdvar( "ac130_gameplay_enabled") == "1" )
	{
		if ( vehGroup[ 1 ].size > 0 )
			waittill_multiple_ents( level.getaway_vehicle_1, "hijack_done", level.getaway_vehicle_2, "hijack_done" );
		else
			waittill_multiple_ents( level.getaway_vehicle_1, "hijack_done" );
	}
	
	thread dialog_ambush();
	
	wait 17.0;
	
	thread gameplay_ambush();
	thread ac130_move_out();
	
	wait 17.0;
	
	//-------------------------------------------
	// Cars continue path with friendlies in them
	//-------------------------------------------
	if ( getdvar( "ac130_gameplay_enabled") == "1" )
	{
		level.getaway_vehicle_1 resumeSpeed( 5 );
		wait 1.3;
		level.getaway_vehicle_2 resumeSpeed( 5 );
	}
}

gameplay_ambush()
{
	thread movePlaneToWaypoint( "ac130_waypoint_ambush" );
	
	if ( getdvar( "ac130_gameplay_enabled") == "1" )
	{
		wait 5;
		spawn_vehicle( "ambush_truck1_spawn_trigger" );
		spawn_enemies( "ambush_rooftop_spawn_trigger" );
		wait 5;
		spawn_enemies( "ambush_rpg_spawn_trigger1" );
		spawn_enemies( "ambush_rpg_spawn_trigger4" );
		wait 5;
	}
	thread ac130_move_in();
	
	thread autosaveFriendlyCountCheck( "ambush" );
	
	if ( getdvar( "ac130_gameplay_enabled") == "1" )
	{
		spawn_enemies( "ambush_rpg_spawn_trigger3" );
		wait 5;
		spawn_enemies( "ambush_rpg_spawn_trigger2" );
		wait 20;
		spawn_vehicle( "ambush_bmp_spawn_trigger" );
		wait 32;
	}
	
	thread movePlaneToWaypoint( "ac130_waypoint_junkyard1" );
	
	//-------------------------------------------
	// stop the vehicles at the hijack roadbloack
	//-------------------------------------------
	getVehicleNode( "stop_at_junkyard", "script_noteworthy" ) waittill( "trigger" );
	thread dialog_junkyard1();
	level.getaway_vehicle_2 setSpeed( 0, 10 );
	wait 1;
	level.getaway_vehicle_1 setSpeed( 0, 10 );
	wait 3;
	level.getaway_vehicle_1 notify( "getout" );
	level.getaway_vehicle_2 notify( "getout" );
	level notify( "getaway_vehicles_unloaded" );
	waittillframeend;
	thread gameplay_junkyard1();
}

gameplay_junkyard1()
{	
	thread movePlaneToWaypoint( "ac130_waypoint_junkyard1" );
	
	//----------------------------------
	// move friendlies to their position
	//----------------------------------
	move_friendlies( "friendly_location_07" );
	wait 5;
	
	thread autosaveFriendlyCountCheck( "junkyard" );
	
	//--------------------------------
	// Spawn groups of enemies to kill
	//--------------------------------
	if ( getdvar( "ac130_gameplay_enabled") == "1" )
	{
		resetPlayerKillCount();
		
		array_thread( getaiarray( "axis" ), ::self_delete );
		
		spawn_enemies( "junkyard_spawn_trigger1" );
		wait 3;
		spawn_enemies( "junkyard_spawn_trigger4" );
		wait 5;
		spawn_enemies( "junkyard_spawn_trigger2" );
		wait 10;
		spawn_enemies( "junkyard_spawn_trigger5" );
		wait 15;
		spawn_enemies( "junkyard_spawn_trigger3" );
		wait 45;
		
		waitForPlayerKillCount( 12 );
	}
	
	thread gameplay_junkyard2();
}

gameplay_junkyard2()
{
	thread dialog_junkyard2();
	
	stop_enemies( "junkyard_spawn_trigger1" );
	stop_enemies( "junkyard_spawn_trigger2" );
	stop_enemies( "junkyard_spawn_trigger3" );
	
	thread movePlaneToWaypoint( "ac130_waypoint_junkyard2" );
	move_friendlies( "friendly_location_08" );
	
	thread autosaveFriendlyCountCheck( "junkyard2" );
	
	if ( getdvar( "ac130_gameplay_enabled") == "1" )
	{
		resetPlayerKillCount();
		
		spawn_enemies( "junkyard2_spawn_trigger1" );
		spawn_vehicle( "junkyard_truck2_spawn_trigger" );
		wait 10;
		spawn_vehicle( "junkyard_truck1_spawn_trigger" );
		wait 10;
		
		waitForPlayerKillCount( 5 );
		
		stop_enemies( "junkyard_spawn_trigger4" );
		stop_enemies( "junkyard_spawn_trigger5" );
	}
	
	// here come the blackhawks
	flag_set( "choppers_inbound" );
	//array_thread( getentarray( "landnode", "script_noteworthy" ), ::blackhawk_land );
	spawn_vehicle( "blackhawks_spawn_trigger" );
	
	//------------------
	// Temp end of level
	//------------------
	flag_wait( "choppers_flew_away" );
	missionEnd( true );
}

friendly_health_init()
{
	assert( isdefined( self ) );
	assert( isalive( self ) );
	assert( isAI( self ) );
	
	self thread magic_bullet_shield();
	
	// old veteran only stuff never really got tested so it didn't make it in :(
	/*
	skill = getdifficulty();
	switch( skill )
	{
		case "gimp":
		case "easy":
		case "medium":
		case "hard":
		case "difficult":
			self thread magic_bullet_shield();
			break;
		case "fu":
			self.health = 2000;
			break;
	}
	*/
}

clear_to_engage( fDelay )
{
	if ( isdefined( fDelay ) )
		wait fDelay;
	flag_set( "clear_to_engage" );
	array_thread( getAIArray(), ::dontShoot, false );
}

dontShoot( qTrue )
{
	if ( qTrue )
	{
		self.ignoreme = true;
		self.ignoreall = true;
	}
	else
	{
		self.ignoreme = false;
		self.ignoreall = false;
	}
}

dialog_opening()
{
	if (getdvar("ac130_enabled") == "0")
		return;
	
	array_thread( getAIArray(), ::dontShoot, true );
	
	wait 2;
	
	// Wildfire, we are moving up the road towards a town to the east. Confirm you have a visual on us.
	playSoundOverRadio( level.scr_sound["price"]["ac130_pri_towntoeast"], true );
	wait 1;
	
	// Got eyes on friendlies!
	playSoundOverRadio( level.scr_sound["tvo"]["ac130_tvo_eyesonfriendlies"], true );
	wait 1;
	
	// Crew, do not fire on any target marked by a strobe, those are friendlies.
	playSoundOverRadio( level.scr_sound["fco"]["ac130_fco_nofirestrobe"], true );
	wait 0.5;
	
	hintPrint( &"SCRIPT_PLATFORM_AC130_HINT_TOGGLE_THERMAL" );
	
	if ( !flag( "player_changed_weapons" ) )
		hintPrint( &"AC130_HINT_CYCLE_WEAPONS" );
	
	thread dialog_church_spotted();
}

dialog_church_spotted()
{
	// Uh, TV, confirm you see the church in the town.
	playSoundOverRadio( level.scr_sound["nav"]["ac130_nav_confirmchurch"], true );
	wait 1;
	
	// We see it, start the clock.
	playSoundOverRadio( level.scr_sound["tvo"]["ac130_tvo_weseeit"], true );
	level notify( "start_clock" );
	wait 1;
	
	// Roger that we're there, start talking.
	playSoundOverRadio( level.scr_sound["fco"]["ac130_fco_rogerwerethere"], true );
	wait 0.5;
	
	// You are not authorized to level the church. Do not fire directly on the church.
	playSoundOverRadio( level.scr_sound["nav"]["ac130_nav_notauthorizedchurch"], true );
	
	thread dialog_cleared_to_engage();
}

dialog_cleared_to_engage()
{
	if ( getdvar( "ac130_alternate_controls" ) == "1" )
		hintPrint( &"SCRIPT_PLATFORM_AC130_HINT_ZOOM_AND_FIRE" );
	
	// Got a vehicle moving now!
	playSoundOverRadio( level.scr_sound["tvo"]["ac130_tvo_vehiclemovingnow"], true );
	wait 1;
	
	// One of the vehicles is moving right now.
	playSoundOverRadio( level.scr_sound["fco"]["ac130_fco_onevehiclemoving"], true );
	wait 1;
	
	// Personnel coming out of the church.
	playSoundOverRadio( level.scr_sound["tvo"]["ac130_tvo_personnelchurch"], true );
	wait 1;
	
	// We have armed personnel approaching from the church, request permission to engage.
	playSoundOverRadio( level.scr_sound["fco"]["ac130_fco_armedpersonnelchurch"], true );
	wait 1;
	
	thread clear_to_engage( 1.5 );
	
	// Copy. You are cleared to engage the moving vehicle, and any personnel around you see.
	playSoundOverRadio( level.scr_sound["pilot"]["ac130_plt_cleartoengage"], true );
	wait 1;
	
	flag_set( "allow_context_sensative_dialog" );
	
	// Affirmative. Crew you are cleared to engage but do not fire on the church.
	playSoundOverRadio( level.scr_sound["fco"]["ac130_fco_cleartoengage"], true );
}

dialog_passing_church()
{
	flag_clear( "allow_context_sensative_dialog" );
	
	// Wildfire, this is Bravo Six, be advised, we're passing a large church and continuing towards the main highway! Keep up the fire! Bravo Six out!
	playSoundOverRadio( level.scr_sound["pri"]["ac130_pri_passingchurch"], true );
	
	// Roger that. Engage anything without a flashing strobe light. Those are all hostiles.
	playSoundOverRadio( level.scr_sound["plt"]["ac130_plt_woutstrobe"], true );
	
	flag_set( "allow_context_sensative_dialog" );
}

dialog_hijack()
{
	flag_clear( "allow_context_sensative_dialog" );
	
	// We got a moving vehicle here.
	playSoundOverRadio( level.scr_sound["fco"]["ac130_fco_movingvehicle"], true );
	
	// Negative negative. Do not engage, I repeat do not engage any vehicles on the main highway.
	playSoundOverRadio( level.scr_sound["fco"]["ac130_fco_donoengage"], true );
	
	// Wildfire, we're going to commandeer civilian transports on the main highway. Cover us!
	playSoundOverRadio( level.scr_sound["pri"]["ac130_pri_coverus"], true );
	
	// Crew, do not engage any vehicles traveling on the highway, those are civilians.
	playSoundOverRadio( level.scr_sound["fco"]["ac130_fco_civilianvehicles"], true );
	
	flag_wait( "hijacked_vehicles_stopped" );
	
	// Ground units are acquiring alternate transport at this time. Do not engage any vehicles on the highway unless cleared to do so.
	playSoundOverRadio( level.scr_sound["fco"]["ac130_fco_alttransport"], true );
	
	// I bet that guy’s pissed! That’s a nice truck!
	playSoundOverRadio( level.scr_sound["tvo"]["ac130_tvo_nicetruck"], true );
	
	// Nah, hehe, he’s scared shitless.
	playSoundOverRadio( level.scr_sound["fco"]["ac130_fco_nahscared"], true );
	
	// Wildfire, we’re marking the vehicles! Confirm you see the beacons!
	playSoundOverRadio( level.scr_sound["pri"]["ac130_pri_confirmyousee"], true );
	
	// Roger, we see the beacons. Crew, do not fire on the vehicles marked with the flashing beacons. I repeat, do NOT fire on the vehicles with the flashing beacons, those are friendlies.
	playSoundOverRadio( level.scr_sound["fco"]["ac130_fco_seebeacons"], true );
	
	flag_set( "allow_context_sensative_dialog" );
}

dialog_ambush()
{
	flag_clear( "allow_context_sensative_dialog" );
	
	// Heads up. Hostile forces are setting up ambush points along the curved road.
	playSoundOverRadio( level.scr_sound["nav"]["ac130_nav_ambushroad"], true );
	
	// Uh, navigation, which one's the curved road over?
	playSoundOverRadio( level.scr_sound["fco"]["ac130_fco_whichcurved"], true );
	
	// Fire control, do you see the water tower, over?
	playSoundOverRadio( level.scr_sound["nav"]["ac130_nav_seewatertower"], true );
	
	// TV, confirm you see the water tower.
	playSoundOverRadio( level.scr_sound["fco"]["ac130_fco_confirmyousee"], true );
	
	// Are you talking about the uh, water tower near the intersection?
	playSoundOverRadio( level.scr_sound["tvo"]["ac130_tvo_nearintersection"], true );
	
	// Roger, that's the one.
	playSoundOverRadio( level.scr_sound["nav"]["ac130_nav_thatstheone"], true );
	
	// And next to that water tower is a curved road, do you see that?
	playSoundOverRadio( level.scr_sound["nav"]["ac130_nav_doyouseethat"], true );
	
	// Roger that.
	playSoundOverRadio( level.scr_sound["fco"]["ac130_fco_rogerthat"], true );
	
	// Track that road into the next village. You should be able to see another water tower in the village further down that road.
	playSoundOverRadio( level.scr_sound["nav"]["ac130_nav_trackthatroad"], true );
	
	// Uh, we're having a bit of trouble acquiring the village. How far up the road is it?
	playSoundOverRadio( level.scr_sound["fco"]["ac130_fco_howfar"], true );
	
	// Approximately…uh, hang on…
	playSoundOverRadio( level.scr_sound["nav"]["ac130_nav_uhhangon"], true );
	
	// It's about 600 metres along the curved road, going away from the highway.
	playSoundOverRadio( level.scr_sound["nav"]["ac130_nav_600meters"], true );
	
	// Roger that.
	playSoundOverRadio( level.scr_sound["tvo"]["ac130_tvo_rogerthat"], true );
	
	//We're banking towards the village. Stand by to engage ground targets.
	playSoundOverRadio( level.scr_sound["plt"]["ac130_plt_bankingtovillage"], true );
	
	// We got hostiles setting up along the curved road.
	playSoundOverRadio( level.scr_sound["tvo"]["ac130_tvo_hostilescurved"], true );
	
	// Hostiles preparing to ambush along the curved road.  They're partially concealed by the trees.
	playSoundOverRadio( level.scr_sound["fco"]["ac130_fco_partiallyconcealed"], true );
	
	// Whoa, someone just fired an RPG!
	playSoundOverRadio( level.scr_sound["tvo"]["ac130_tvo_firedrpg"], true );
	
	// Roger that. Crew, go ahead and take out everything in that village.
	playSoundOverRadio( level.scr_sound["fco"]["ac130_fco_takeout"], true );
	
	// Armored vehicle right there! Right there, coming out of the barn.
	playSoundOverRadio( level.scr_sound["fco"]["ac130_fco_outofbarn"], true );
	
	// Targets in the village are confirmed as hostile. Cleared to engage. Smoke 'em.
	playSoundOverRadio( level.scr_sound["plt"]["ac130_plt_smokem"], true );
	
	// Wildfire, we're under attack. We could use some help here.
	playSoundOverRadio( level.scr_sound["pri"]["ac130_pri_underattack"], true );
	
	// Crew, track those smoke trails and take 'em out at the source. Clear a path for our guys.
	playSoundOverRadio( level.scr_sound["fco"]["ac130_fco_smoketrails"], true );
	
	// Personnel on the roof of that U-shaped building.
	playSoundOverRadio( level.scr_sound["tvo"]["ac130_tvo_ushaped"], true );
	
	// Uh, U-shaped building?
	playSoundOverRadio( level.scr_sound["fco"]["ac130_fco_ushaped"], true );
	
	// Roger, it's the one with the square structure on the roof. It's the one with a flat roof.
	playSoundOverRadio( level.scr_sound["tvo"]["ac130_tvo_flatroof"], true );
	
	flag_set( "allow_context_sensative_dialog" );
}

dialog_junkyard1()
{
	flag_clear( "allow_context_sensative_dialog" );
	
	// Wildfie, we're approaching the LZ at the junkyard and leaving the vehicles.
	playSoundOverRadio( level.scr_sound["pri"]["ac130_pri_junkyard"], true );
	
	// Roger that Bravo Six. Crew, friendlies are leaving the vehicles and moving on foot towards the LZ. Do not fire on any personnel marked by a flashing strobe.
	playSoundOverRadio( level.scr_sound["fco"]["ac130_fco_flashingstrobe"], true );
	
	// Affirmative. Keep watching for those strobe lights. Those are friendlies.
	playSoundOverRadio( level.scr_sound["fco"]["ac130_fco_watchstrobe"], true );
	
	// Enemy personnel in the junkyard. 
	playSoundOverRadio( level.scr_sound["tvo"]["ac130_tvo_enemyjunkyard"], true );
	
	// Crew, go ahead and smoke ‘em.
	playSoundOverRadio( level.scr_sound["fco"]["ac130_fco_smokeem"], true );

	// Man these guys are goin' to town!
	playSoundOverRadio( level.scr_sound["fco"]["ac130_fco_gointotown"], true );
	
	flag_set( "allow_context_sensative_dialog" );
}

dialog_junkyard2()
{
	flag_clear( "allow_context_sensative_dialog" );
	
	// Wildfire, we've reached the LZ, but we're taking fire from all sides!! Request fire support on all sides of the LZ, danger close!!!
	playSoundOverRadio( level.scr_sound["pri"]["ac130_pri_fireallsides"], true );

	// Enemy personnel closing on the LZ from multiple sides. Danger close. Recommend you stick to the 25 millimeter in the vicinity of the LZ. 
	playSoundOverRadio( level.scr_sound["nav"]["ac130_nav_dangerclose"], true );
	
	flag_set( "allow_context_sensative_dialog" );
	flag_wait( "choppers_inbound" );
	flag_clear( "allow_context_sensative_dialog" );
	
	// Crew, be advised, friendly helicopters entering the area. Watch your fire.
	playSoundOverRadio( level.scr_sound["fco"]["ac130_fco_friendliesentering"], true );
	
	// Copy.
	playSoundOverRadio( level.scr_sound["tvo"]["ac130_tvo_copy"], true );
	
	flag_wait( "friendlies_moving_to_choppers" );
	
	// Wildfire, we've moving towards the helicopters now. Thanks for the assist. Bravo Six out.
	playSoundOverRadio( level.scr_sound["pri"]["ac130_pri_thanksforassist"], true );
	
	// Hehe, this is gonna be one helluva highlight reel.
	playSoundOverRadio( level.scr_sound["fco"]["ac130_fco_highlightreel"], true );
	
	// I heard that!
	playSoundOverRadio( level.scr_sound["tvo"]["ac130_tvo_heardthat"], true );
	
	flag_wait( "friendlies_in_choppers" );
	
	// Crew, VIP is secure and in custody. Good job everyone.
	playSoundOverRadio( level.scr_sound["nav"]["ac130_nav_vipsecure"], true );
	
	// Roger that. Returning to base.
	playSoundOverRadio( level.scr_sound["plt"]["ac130_plt_returningbase"], true );
}