#include common_scripts\utility;
#include maps\_utility;
#include maps\_ac130;
#include maps\ac130;

precacheLevelStuff()
{
	precachestring( &"AC130_HINT_CYCLE_WEAPONS" );
	precachestring( &"AC130_DO_NOT_ENGAGE" );
	precachestring( &"AC130_CHURCH_DAMAGED" );
	precachestring( &"AC130_ESCAPEVEHICLE_DESTROYED" );
	precachestring( &"AC130_HUD_TOP_BAR" );
	precachestring( &"AC130_HUD_LEFT_BLOCK" );
	precachestring( &"AC130_HUD_RIGHT_BLOCK" );
	precachestring( &"AC130_HUD_BOTTOM_BLOCK" );
	precachestring( &"AC130_HUD_THERMAL_WHOT" );
	precachestring( &"AC130_HUD_THERMAL_BHOT" );
	precachestring( &"AC130_HUD_WEAPON_105MM" );
	precachestring( &"AC130_HUD_WEAPON_40MM" );
	precachestring( &"AC130_HUD_WEAPON_25MM" );
	precachestring( &"AC130_HUD_AGL" );
	precachestring( &"AC130_DEBUG_FRIENDLY_COUNT" );
	precachestring( &"AC130_FRIENDLIES_DEAD" );
	precachestring( &"AC130_FRIENDLY_FIRE" );
	precachestring( &"AC130_FRIENDLY_FIRE_HELICOPTER" );
	precachestring( &"AC130_CIVILIAN_FIRE" );
	precachestring( &"AC130_CIVILIAN_FIRE_VEHICLE" );
	precachestring( &"AC130_OBJECTIVE_SUPPORT_FRIENDLIES" );
	precachestring( &"AC130_INTROSCREEN_LINE_1" );
	precachestring( &"AC130_INTROSCREEN_LINE_2" );
	precachestring( &"AC130_INTROSCREEN_LINE_3" );
	precachestring( &"AC130_INTROSCREEN_LINE_4" );
	precachestring( &"AC130_INTROSCREEN_LINE_5" );
	precachestring( &"SCRIPT_PLATFORM_AC130_HINT_ZOOM_AND_FIRE" );
	precachestring( &"SCRIPT_PLATFORM_AC130_HINT_TOGGLE_THERMAL" );
	
	precacheShader( "popmenu_bg" );
	
	level.nocompass = true;
	
	level.weaponClipModels = [];
	level.weaponClipModels[0] = "weapon_saw_clip";
	level.weaponClipModels[1] = "weapon_m16_clip";
	level.weaponClipModels[2] = "weapon_ak47_clip";
	level.weaponClipModels[3] = "weapon_g3_clip";
}

scriptCalls()
{
	//overrides the destrcution FX and tag to be played on
	maps\_vehicle::build_deathfx_override( "luxurysedan", ( "explosions/large_vehicle_explosion_IR" ), "tag_deathfx", "explo_metal_rand" );
	maps\_vehicle::build_deathfx_override( "truck", ( "explosions/large_vehicle_explosion_IR" ), "tag_origin", "explo_metal_rand" );
	maps\_vehicle::build_deathfx_override( "pickup", ( "explosions/large_vehicle_explosion_IR" ), "tag_origin", "explo_metal_rand" );
	maps\_vehicle::build_deathfx_override( "uaz_ac130", ( "explosions/large_vehicle_explosion_IR" ), "tag_origin", "explo_metal_rand" );
	maps\_vehicle::build_deathfx_override( "bmp", ( "explosions/large_vehicle_explosion_IR" ), "tag_origin", "explo_metal_rand" );
	
	maps\_humvee::main( "vehicle_humvee_thermal" );
	maps\_seaknight::main( "vehicle_ch46e_opened_door" );
	maps\_truck::main( "vehicle_pickup_roobars" );
	maps\_luxurysedan::main( "vehicle_luxurysedan" );
	maps\_uaz_ac130::main( "vehicle_uaz_hardtop_thermal" );
	maps\_bmp::main( "vehicle_bmp_thermal" );
	maps\_blackhawk::main( "vehicle_blackhawk_low_thermal" );
	maps\_camera::main( "vehicle_camera" );
	
	maps\_load::main();
	maps\ac130_snd::main();
	maps\ac130_anim::main();
	maps\_ac130::init();
	
	array_thread( getentarray( "destructible_building", "targetname" ), ::destructible_building );
	array_thread( getentarray( "invulnerable", "script_noteworthy" ), ::add_spawn_function, ::magic_bullet_shield );
	array_thread( getentarray( "damage_church", "targetname" ), ::damage_church );
	array_thread( getentarray( "level_scripted_unloadnode", "script_noteworthy" ), ::level_scripted_unloadnode );
	
	thread helictoper_friendly_fire( "blackhawk1" );
	thread helictoper_friendly_fire( "blackhawk2" );
}

missionEnd( endLevel )
{
	if ( isdefined( endLevel ) && ( endLevel ) )
	{
		wait 6;
		nextmission();
	}
}

spawn_enemies( sTrigger_Noteworthy )
{
	if ( getdvar( "ac130_gameplay_enabled") == "0" )
		return;
	
	// notifies a trigger so that it's targeted spawners spawn
	assert( isdefined( sTrigger_Noteworthy ) );
	spawn_trigger = getent( sTrigger_Noteworthy, "script_noteworthy" );
	assert( isdefined( spawn_trigger ) );
	spawn_trigger notify( "trigger" );
}

stop_enemies( sTrigger_Noteworthy )
{
	if ( getdvar( "ac130_gameplay_enabled") == "0" )
		return;
	
	// grabs the killspawner value and kills that spawn group
	assert( isdefined( sTrigger_Noteworthy ) );
	spawn_trigger = getent( sTrigger_Noteworthy, "script_noteworthy" );
	assert( isdefined( spawn_trigger ) );
	assert( isdefined( spawn_trigger.script_killspawner_group ) );
	thread maps\_spawner::kill_spawnerNum( spawn_trigger.script_killspawner_group );
}

spawn_friendlies( sTargetname )
{
	spawnerArray = getentarray( sTargetname, "targetname" );
	assert( spawnerArray.size == 8 );
	level.friendlies = [];
	for( i = 0 ; i < spawnerArray.size ; i++ )
	{
		guy = spawnerArray[i] stalingradSpawn();
		if (!spawn_failed(guy))
			level.friendlies[level.friendlies.size] = guy;
	}
	array_thread( level.friendlies, ::friendly_health_init );
	array_thread( level.friendlies, ::mission_fail_casualties );
	array_thread( level.friendlies, ::debug_friendly_count );
	array_thread( level.friendlies, ::add_beacon_effect );
}

spawn_vehicle( sTrigger_Targetname )
{	
	// notifies a trigger so that it's targeted spawners spawn
	assert( isdefined( sTrigger_Targetname ) );
	spawn_trigger = getent( sTrigger_Targetname, "targetname" );
	assert( isdefined( spawn_trigger ) );
	spawn_trigger notify( "trigger" );
}

move_friendlies( sTrigger_Targetname )
{	
	assert( isdefined( sTrigger_Targetname ) );
	color_node_trigger = getent( sTrigger_Targetname, "targetname" );
	assert( isdefined( color_node_trigger ) );
	
	if ( flag( "ignore_friendly_move_commands" ) )
		return;
	
	color_node_trigger notify( "trigger" );
}

damage_church()
{
	if ( getdvar( "ac130_gameplay_enabled") == "0" )
		return;
	
	for (;;)
	{
		self waittill ( "damage", damage, attacker, parm1, parm2, damageType );
		
		if ( attacker != level.player )
			continue;
		
		if ( issubstr( tolower( damageType ), "splash" ) )
			continue;
		
		if ( !flag( "mission_failed" ) )
			break;
	}
	
	thread missionFail_church();
}

autosaveFriendlyCountCheck( sSaveName )
{
	assert( isdefined( sSaveName ) );
	assert( isdefined( level.friendlyCount ) );
	assert( isdefined( level.minimumAutosaveFriendlyCount ) );
	if ( level.friendlyCount >= level.minimumAutosaveFriendlyCount )
		thread maps\_utility::autosave_by_name( sSaveName );
}

missionFail_church()
{
	if ( flag( "mission_failed" ) )
		return;
	flag_set( "mission_failed" );
	setdvar( "ui_deadquote", "@AC130_CHURCH_DAMAGED" );
	maps\_utility::missionFailedWrapper();
}

mission_fail_vehicle_death()
{
	level endon( "getaway_vehicles_unloaded" );
	
	self waittill( "death", attacker );
	
	if ( flag( "mission_failed" ) )
		return;
	
	if( isdefined( attacker ) && ( attacker == level.player ) )
	{
		flag_set( "mission_failed" );
		setdvar( "ui_deadquote", "@AC130_FRIENDLY_FIRE" );
		maps\_utility::missionFailedWrapper();
	}
	else
	{
		flag_set( "mission_failed" );
		setdvar( "ui_deadquote", "@AC130_FRIENDLIES_DEAD" );
		maps\_utility::missionFailedWrapper();
	}
}

hintPrint( string )
{
	hint = hint_create( string, true, 0.8 );
	wait level.hintPrintDuration;
	hint hint_delete();
}

getEnemiesInZone( sZoneTargetname )
{
	zone = getent( sZoneTargetname, "targetname" );
	axis = getaiarray( "axis" );
	zoneGuys = [];
	for( i = 0 ; i < axis.size ; i++ )
	{
		if ( !axis[ i ] isTouching( zone ) )
			continue;
		zoneGuys[ zoneGuys.size ] = axis[ i ];
	}
	return zoneGuys;
}

level_scripted_unloadnode()
{
	self waittill( "trigger", helicopter );
	helicopter setContents( 0 );
	helicopter.dontDisconnectPaths = true;
	helicopter vehicle_detachfrompath();
	helicopter setspeed( 20, 20 );
	helicopter vehicle_land();
	
	// send friendlies into the choppers
	if ( !isdefined( level.friendlies_told_to_load_choppers ) )
	{
		level.friendlies_told_to_load_choppers = true;
		thread friendlies_into_choppers();
	}
	
	// get the ai that will unload
	unloadedGuys = [];
	for( i = 0 ; i < helicopter.riders.size ; i++ )
	{
		if ( !isdefined( helicopter.riders[ i ] ) )
			continue;
		if ( !isdefined( helicopter.riders[ i ].pos ) )
			continue;
		if ( ( helicopter.riders[ i ].pos >= 1 ) && ( helicopter.riders[ i ].pos <= 4 ) )
			unloadedGuys[ unloadedGuys.size ] = helicopter.riders[ i ];
	}
	assert( unloadedGuys.size == 2 );
	
	helicopter notify( "unload" );
	helicopter waittill( "unloaded" );
	
	flag_wait( "friendlies_in_choppers" );
	
	wait randomfloatrange( 1.0, 5.0 );
	
	helicopter thread maps\_vehicle::vehicle_load_ai( array_removeDead( unloadedGuys ) );
	
	thread missionEndFailSafe();
	
	helicopter waittill( "loaded" );
	helicopter vehicle_resumepath();
	
	wait 5;
	flag_set( "choppers_flew_away" );
}

missionEndFailSafe()
{
	wait 120;
	flag_set( "choppers_flew_away" );
}

friendlies_into_choppers()
{
	flag_set( "ignore_friendly_move_commands" );
	
	level notify( "stop_casualty_tracking" );
	
	node[ 0 ] = getnode( "chopper_ai_node1", "targetname" );
	node[ 1 ] = getnode( "chopper_ai_node2", "targetname" );
	nextNode = 1;
	level.friendlies_not_in_chopper = 0;
	
	for( i = 0 ; i < level.friendlies.size ; i++ )
	{
		if ( !isdefined( level.friendlies[ i ] ) )
			continue;
		if ( !isalive( level.friendlies[ i ] ) )
			continue;
		
		if ( nextNode == 0 )
			nextNode = 1;
		else if ( nextNode == 1 )
			nextNode = 0;
		
		level.friendlies[ i ] thread friendly_run_into_chopper( node[ nextNode ] );
	}
	
	flag_set( "friendlies_moving_to_choppers" );
	
	while( level.friendlies_not_in_chopper > 0 )
		wait 0.05;
		
	flag_set( "friendlies_in_choppers" );
}

friendly_run_into_chopper( node )
{
	self endon( "death" );
	level.friendlies_not_in_chopper++;
	self.fixednode = false;
	self.a.disablePain = true;
	self.ignoreme = true;
	self.ignoreall = true;
	self.maxsightdistsqrd = 0;
	self.ignoresuppression = true;
	self thread ignoreAllEnemies( true );
	self setCanDamage( false );
	self.goalradius = 32;
	self setGoalNode( node );
	self waittill( "goal" );
	if ( isdefined( self.magic_bullet_shield ) )
		self stop_magic_bullet_shield();
	self notify( "boarded_chopper" );
	level.friendlies_not_in_chopper--;
	waittillframeend;
	self delete();
}

friendly_run_into_chopper_death_handler()
{
	self endon( "boarded_chopper" );
	self waittill( "death" );
	level.friendlies_not_in_chopper--;
}

friendly_fire_vehicle_thread()
{
	level endon( "getaway_vehicles_unloaded" );
	
	for(;;)
	{
		self waittill( "damage", amount, attacker );
		
		if ( !isdefined( attacker ) )
			continue;
		
		if ( attacker != level.player )
			continue;
		
		if ( flag( "mission_failed" ) )
			return;
		
		flag_set( "mission_failed" );
		if ( flag( "friendlies_loading_vehicles" ) )
			setdvar( "ui_deadquote", "@AC130_FRIENDLY_FIRE" );
		else
			setdvar( "ui_deadquote", "@AC130_CIVILIAN_FIRE_VEHICLE" );
		maps\_utility::missionFailedWrapper();
	}
}

helictoper_friendly_fire( vehicleTargetname )
{
	vehicle = maps\_vehicle::waittill_vehiclespawn( vehicleTargetname );
	
	for(;;)
	{
		vehicle waittill( "damage", amount, attacker );
		
		if ( !isdefined( attacker ) )
			continue;
		
		if ( attacker != level.player )
			continue;
		
		if ( flag( "mission_failed" ) )
			return;
		
		flag_set( "mission_failed" );
		
		setdvar( "ui_deadquote", "@AC130_FRIENDLY_FIRE_HELICOPTER" );
		
		maps\_utility::missionFailedWrapper();
	}
}

resetPlayerKillCount()
{
	level.enemiesKilledByPlayer = 0;
}

waitForPlayerKillCount( num )
{
	while( level.enemiesKilledByPlayer < num )
		wait 1;
}

civilian_car_riders_spawn_and_idle()
{
	assert( isdefined( level.getaway_vehicle_1 ) );
	assert( isdefined( level.getaway_vehicle_2 ) );
	
	spawners = getentarray( "civilian_car_rider", "targetname" );
	assert( isdefined( spawners ) );
	assert( spawners.size == 2 );
	
	thread civilian_car_riders_spawn_and_idle_start( level.getaway_vehicle_1, spawners[ 0 ], "civiliandriver_car1" );
	thread civilian_car_riders_spawn_and_idle_start( level.getaway_vehicle_2, spawners[ 1 ], "civiliandriver_car2" );
}

civilian_car_riders_spawn_and_idle_start( vehicle, spawner, animname )
{
	vehicle.eDriver = spawner stalingradSpawn();
	spawn_failed( vehicle.eDriver );
	
	vehicle.eDriver gun_remove();
	vehicle.eDriver.ignoreme = true;
	vehicle.eDriver.ignoreall = true;
	vehicle.eDriver.maxsightdistsqrd = 0;
	vehicle.eDriver.ignoresuppression = true;
	vehicle.eDriver thread ignoreAllEnemies( true );
	vehicle.eDriver.civilian = true;
	
	vehicle.eDriver linkto( vehicle );
	vehicle.eDriver.animname = animname;
	vehicle.eDriver thread maps\_anim::anim_loop_solo( vehicle.eDriver, "idle", "tag_driver", "stop_idle", vehicle );
	
	vehicle.eDriver thread civilian_car_riders_mission_fail();
	
	// wait for the civilian to get to his goal after he unloads, then delete him
	vehicle.eDriver endon( "death" );
	vehicle.eDriver waittill( "goal" );
	vehicle.eDriver delete();
}

civilian_car_riders_mission_fail()
{
	self endon( "goal" );
	
	while( isdefined( self ) && isalive( self ) )
	{
		self waittill( "damage", amount, attacker );
		
		if ( !isdefined( attacker ) )
			continue;
		
		if ( attacker != level.player )
			continue;
		
		if ( flag( "mission_failed" ) )
			return;
		
		flag_set( "mission_failed" );
		setdvar( "ui_deadquote", "@AC130_CIVILIAN_FIRE" );
		maps\_utility::missionFailedWrapper();
	}
}

do_hijack( vehicle, guys, vehicleAnim1, vehicleAnim2 )
{
	assert( isdefined( vehicle.eDriver ) );
	
	array_thread( guys, ::dontShoot, true );
	
	vehicle disconnectPaths();
	
	// get friendlies in position
	vehicle maps\_anim::anim_reach( guys, "hijack", "tag_detach", undefined, vehicle );
	
	array_thread( guys, ::do_car_idle_after_hijack, vehicle );
	
	// friendlies in position, add driver to array
	vehicle.eDriver notify( "stop_idle" );
	vehicle.eDriver unlink();
	
	// make group1 the driver and friendly 1
	// make group2 the other 3 friendlies that get in the vehicle
	firstGroup = [];
	secondGroup = [];
	for ( i = 0 ; i < guys.size ; i++ )
	{
		if ( i == 0 )
			firstGroup[ firstGroup.size ] = guys[ i ];
		else
			secondGroup[ secondGroup.size ] = guys[ i ];
	}
	firstGroup[ firstGroup.size ] = vehicle.eDriver;
	
	// driver and guy1 animate
	vehicle thread maps\_anim::anim_single( firstGroup, "hijack", "tag_detach", undefined, vehicle );
	vehicle thread do_hijack_vehicle_anim( vehicleAnim1 );
	
	firstGroup[ 0 ] waittill( "others_hijack_start" );
	
	// rest of friendlies animate
	vehicle thread do_hijack_vehicle_anim( vehicleAnim2 );
	vehicle maps\_anim::anim_single( secondGroup, "hijack", "tag_detach", undefined, vehicle );
	
	vehicle notify( "hijack_done" );
	
	array_thread( guys, ::dontShoot, false );
}

do_hijack_others( guy )
{
	// called from a notetrack
	guy notify( "others_hijack_start" );
}

#using_animtree( "vehicles" );
do_hijack_vehicle_anim( vehicleAnim )
{
	self useAnimTree( #animtree );
	self setanim( vehicleAnim );
}

do_car_idle_after_hijack( vehicle )
{
	assert( isdefined( self.sitTag ) );
	self waittillmatch( "single anim", "end" );
	self linkto( vehicle );
	vehicle thread maps\_anim::anim_loop_solo( self, "idle", self.sitTag, "stop_idle", vehicle );
	vehicle waittill( "getout" );
	self set_force_color( "r" );
	vehicle maps\_anim::anim_single_solo( self, "getout", self.sitTag, undefined, vehicle );
	self unlink();
}

destructible_building()
{
	// trigger targets destroyed version of the building and fxorigin
	// destroyed building targets all the parts of the "before" building
	// destroyed building targets all the exploderchunk parts
	
	assert( isdefined( self ) );
	assert( isdefined( self.target ) );
	
	destroyedBuilding = getentarray( self.target, "targetname" );
	assert( destroyedBuilding.size > 0 );
	
	// -------------------------------------------------------
	// Get all the parts for the building and it's destruction
	// -------------------------------------------------------
	building = [];
	exploderchunks = [];
	fxOrigin = undefined;
	for( i = 0 ; i < destroyedBuilding.size ; i++ )
	{
		if ( destroyedBuilding[ i ].classname == "script_origin" )
		{
			fxOrigin = destroyedBuilding[ i ];
			continue;
		}
		
		tempBuildingParts = getentarray( destroyedBuilding[ i ].target, "targetname" );
		assert( tempBuildingParts.size > 0 );
		for ( p = 0 ; p < tempBuildingParts.size ; p++ )
		{
			if ( ( isdefined( tempBuildingParts[ p ].script_noteworthy ) ) && ( tempBuildingParts[ p ].script_noteworthy == "exploderchunk" ) )
				exploderchunks[ exploderchunks.size ] = tempBuildingParts[ p ];
			else
				building[ building.size ] = tempBuildingParts[ p ];
		}
	}
	assert( isdefined( fxOrigin ) );
	assert( building.size > 0 );
	assert( exploderchunks.size > 0 );
	
	// -------------------------------------------
	// Hide destroyed and exploderchunk components
	// -------------------------------------------
	for( i = 0 ; i < destroyedBuilding.size ; i++ )
		destroyedBuilding[ i ] hide();
	
	for( i = 0 ; i < exploderchunks.size ; i++ )
		exploderchunks[ i ] hide();
	
	self thread trigger_40mm_hit_timeframe();
	for (;;)
	{
		self waittill ( "damage", damage, attacker, parm1, parm2, damageType );
		
		if ( !isdefined( level.credits_active ) )
		{
			if ( attacker != level.player )
				continue;
		}
		
		if ( issubstr( tolower( damageType ), "splash" ) )
			continue;
		
		if ( damage == 990 )
		{
			self notify ( "40mm_damage" );
			continue;
		}
		
		if ( damage < 990 )
			continue;
		
		break;
	}
	
	// ---------------------
	//building collapses now
	// ---------------------
	
	thread arcadeMode_kill( self.origin, "explosive", 1000 );
	
	for( i = 0 ; i < destroyedBuilding.size ; i++ )
		destroyedBuilding[ i ] show();
	
	// only do exploderchunk if the 105mm was used
	if ( damage == 1000 )
	{
		for( i = 0 ; i < exploderchunks.size ; i++ )
		{
			exploderchunks[ i ] show();
			startorg = exploderchunks[ i ].origin;
			startang = exploderchunks[ i ].angles;
			targetEnt = getent( exploderchunks[ i ].target, "targetname" );
			temp_vec = ( targetEnt.origin - startOrg );
			x = temp_vec[ 0 ];
			y = temp_vec[ 1 ];
			z = temp_vec[ 2 ];
			exploderchunks[ i ] rotateVelocity( ( x, y, z ), 12 );
			exploderchunks[ i ] moveGravity( ( x, y, z ), 12 );
			self thread delayThread( 12, ::self_delete );
		}
	}
	
	for( i = 0 ; i < building.size ; i++ )
	{
		randomPitch = -20 + randomfloat( 40 );
		randomYaw = -5 + randomfloat( 10 );
		randomRoll = -20 + randomfloat( 40 );
		
		collapseTime = 5.0;
		accelTime = 2.0;
		decelTime = 2.0;
		
		building[ i ] moveTo( building[ i ].origin - ( 0, 0, 512 ), collapseTime, accelTime, decelTime );
		building[ i ] rotateTo( building[ i ].angles + ( randomPitch, randomYaw, randomRoll ), collapseTime / 2, accelTime / 2, decelTime / 2 );
		building[ i ] thread delayThread( 5.0, ::self_delete );
	}
	
	self delete();
}

trigger_40mm_hit_timeframe()
{
	self endon ( "deleting" );
	
	timeWindow = 4.0;
	requiredInTime = 4;
	
	for (;;)
	{
		self waittill ( "40mm_damage" );
		self thread trigger_40mm_hit_timeframe_wait( timeWindow, requiredInTime );
	}
}

trigger_40mm_hit_timeframe_wait( timeWindow, requiredInTime )
{
	self endon ( "deleting" );
	
	firstTime = gettime();
	
	// running this thread indicates 1 time happened already
	// wait for the rest of the times
	requiredInTime--;
	for ( i = 0 ; i < requiredInTime ; i++ )
	{
		self waittill ( "40mm_damage" );
	}
	
	currentTime = gettime();
	timeElapsed = currentTime - firstTime;
	if ( timeElapsed <= timeWindow * 1000 )
	{
		// make the building fall:
		self notify ( "damage", 999, level.player, undefined, undefined, "MOD_PROJECTILE" );
		self notify ( "deleting" );
	}
}


