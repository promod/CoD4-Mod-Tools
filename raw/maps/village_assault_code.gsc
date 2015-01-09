#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_hud_util;
precacheLevelStuff()
{
	precacheString( &"VILLAGE_ASSAULT_OBJECTIVE_LOCATE_ALASAD" );
	precacheString( &"SCRIPT_ARMOR_DAMAGE" );
	precacheString( &"SCRIPT_LEARN_CHOPPER_AIR_SUPPORT1" );
	precacheString( &"SCRIPT_LEARN_CHOPPER_AIR_SUPPORT1_PC" );
	precacheShader( "black" );
	precacheShader( "hud_icon_cobra" );
	precacheShader( "popmenu_bg" );
	precacheShader( "hud_dpad" );
	precacheShader( "hud_arrow_right" );
	precacheModel( "sundirection_arrow" );
	precacheModel( "com_folding_chair" );
	precacheModel( "com_flashlight_off" );
	precacheModel( "com_flashlight_on" );
	precacheItem( "mi28_ffar_village_assault" );
	precacheItem( "flash_grenade" );
	precacheItem( "colt45_alasad_killer" );
	
	flag_init( "gave_air_support_hint" );
	flag_init( "alasad_sequence_started" );
	flag_init( "air_support_refueling" );
	flag_init( "delete_attack_coord_hint" );
	
	level.weaponClipModels = [];
	level.weaponClipModels[0] = "weapon_ak47_clip";
	level.weaponClipModels[1] = "weapon_mp5_clip";
	level.weaponClipModels[2] = "weapon_m16_clip";
	level.weaponClipModels[3] = "weapon_g36_clip";
	level.weaponClipModels[4] = "weapon_dragunov_clip";
	level.weaponClipModels[5] = "weapon_g3_clip";
}

setLevelDVars()
{
	setSavedDvar( "r_specularColorScale", "1.8" );
	
	if ( getdvar( "village_assault_debug_marker") == "" )
		setdvar( "village_assault_debug_marker", "0" );
	
	level.seekersUsingColors = false;
	level.BMP_Safety_Distance = 512 * 512;
	level.goodFriendlyDistanceFromPlayerSquared = 512 * 512;
	level.chopperSupportCallNextAudio = 0;
	level.buildingClearNextAudio = 0;
	level.air_support_hint_print_dialog_next = 0;
	level.chopperSupportHoverLocations = [];
	hoverEnts = getentarray( "chopper_location", "targetname" );
	for( i = 0 ; i < hoverEnts.size ; i++ )
	{
		level.chopperSupportHoverLocations[ level.chopperSupportHoverLocations.size ] = hoverEnts[ i ].origin;
		hoverEnts[ i ] delete();
	}
	assert( level.chopperSupportHoverLocations.size > 0 );
	level.cosine[ "25" ] = cos( 25 );
	level.cosine[ "45" ] = cos( 45 );
	level.cosine[ "55" ] = cos( 55 );
	level.cosine[ "60" ] = cos( 60 );
	level.cosine[ "70" ] = cos( 70 );
	
	level.alasad_possible_objective_locations = [];
	level.alasad_possible_objective_locations_remaining[ 0 ] = "2";
	level.alasad_possible_objective_locations_remaining[ 1 ] = "6";
	
	level.next_genocide_audio = 0;
	level.genocide_audio[ 0 ] = "assault_killing_distance1";
	level.genocide_audio[ 1 ] = "assault_killing_interior1";
	level.genocide_audio[ 2 ] = "assault_killing_interior2";
	level.genocide_audio[ 3 ] = "assault_killing_interior3";
	
	level.timedAutosaveNumber = 0;
	level.timedAutosaveTime = undefined;
	skill = getdifficulty();
	switch( skill )
	{
		case "gimp":
		case "easy":
			level.timedAutosaveTime = 60;
			array_thread( getentarray( "bmp_spawn_trigger", "script_noteworthy" ), ::trigger_off );
			break;
		case "medium":
			level.timedAutosaveTime = 120;
			break;
		case "hard":
		case "difficult":
			level.timedAutosaveTime = 180;
			break;
		case "fu":
			level.timedAutosaveTime = 0;
			break;
	}
	assert( isdefined( level.timedAutosaveTime ) );
}

scriptCalls()
{
	maps\village_assault_anim::main();
	level thread maps\village_assault_amb::main();
	maps\_compass::setupMiniMap("compass_map_village_assault");
	
	array_thread( getentarray( "seek_player", "script_noteworthy" ), ::add_spawn_function, ::seek_player );
	array_thread( getentarray( "indoor_enemy", "script_noteworthy" ), ::add_spawn_function, ::indoor_enemy );
	array_thread( getentarray( "seek_player_smart", "script_noteworthy" ), ::add_spawn_function, ::seek_player_smart );
	array_thread( getentarray( "dog", "script_noteworthy" ), ::add_spawn_function, ::seek_player_dog );
	array_thread( getentarray( "enemy_color_hint_trigger", "targetname" ), ::enemy_color_hint_trigger_think );
	array_thread( getentarray( "genocide_audio_trigger", "targetname" ), ::genocide_audio_trigger );
	array_thread( getentarray( "dead_civilian", "targetname" ), ::dead_civilian );
	array_thread( getentarray( "trigger_upstairs_guys", "targetname" ), ::trigger_upstairs_guys );
	array_thread( getentarray( "alasad_barn_deletable", "script_noteworthy" ), ::alasad_deletable_hide );
	array_thread( getentarray( "alasad_house_deletable", "script_noteworthy" ), ::alasad_deletable_hide );
	
	add_hint_string( "call_air_support2", &"SCRIPT_PLATFORM_LEARN_CHOPPER_AIR_SUPPORT2", ::should_delete_attack_coord_hint );
	
	thread chopper_air_support();
	thread vehicle_patrol_init();
	thread roaming_bmp();
	thread timedAutosaves();
	
	if ( getdvar( "village_assault_disable_gameplay") == "1" )
		thread disable_gameplay();
	
	wait 6.5;
	
	objective_add( 0, "current", &"VILLAGE_ASSAULT_OBJECTIVE_LOCATE_ALASAD", ( 0, 0, 0 ) );
}

disable_gameplay()
{
	array_thread( getentarray( "trigger_multiple", "classname" ), ::disable_gameplay_trigger );
	array_thread( getentarray( "trigger_radius", "classname" ), ::disable_gameplay_trigger );
}

movePlayerToLocation( sTargetname )
{
	assert( isdefined( sTargetname ) );
	start = getent( sTargetname, "targetname" );
	assert( isdefined( start ) );
	assert( isdefined( level.player ) );
	level.player setOrigin( start.origin );
	level.player setPlayerAngles( ( 0, start.angles[ 1 ], 0 ) );
}

disable_gameplay_trigger()
{
	gameplayTrigger = false;
	
	if ( self.spawnflags & 32 )
		gameplayTrigger = true;
	
	if ( isdefined( self.targetname ) )
	{
		if ( self.targetname == "flood_and_secure" )
			gameplayTrigger = true;
		else if ( self.targetname == "flood_spawner" )
			gameplayTrigger = true;
	}
	
	if ( gameplayTrigger )
		self thread trigger_off();
}

spawn_starting_friendlies( sTargetname )
{
	level.friendlies = [];
	spawners = getentarray( sTargetname, "targetname" );
	for( i = 0 ; i < spawners.size ; i++ )
	{
		friend = spawners[ i ] stalingradSpawn();
		if ( spawn_failed( friend ) )
			assertMsg( "A friendly failed to spawn" );
		
		friend.goalradius = 32;
		friend.fixednode = false;
		
		if ( issubstr( friend.classname, "price" ) )
		{
			level.price = friend;
		}
		else if ( issubstr( friend.classname, "gaz" ) )
		{
			level.gaz = friend;
		}
		else if ( issubstr( friend.classname, "russian" ) )
		{
			level.opening_guy = friend;
			level.opening_guy.animname = "opening_guy";
		}
		
		if ( friend isHero() )
			friend thread magic_bullet_shield( undefined, 5.0 );
		
		level.friendlies[ level.friendlies.size ] = friend;
		
		friend thread friendly_adjust_movement_speed();
		friend thread friendly_bmp_damage_ignore_timer();
	}
	
	assert( isdefined( level.price ) );
	level.price.animname = "price";
	level.price make_hero();
	
	assert( isdefined( level.gaz ) );
	level.gaz.animname = "gaz";
	level.gaz make_hero();
	
	//array_thread( getaiarray( "allies" ), ::replace_on_death );
	assert( level.friendlies.size == spawners.size );
}

friendly_bmp_damage_ignore_timer()
{
	self endon( "death" );
	
	for(;;)
	{
		self waittill( "damage", amount, attacker );
		if ( !isdefined( attacker ) )
			continue;
		if ( !isdefined( attacker.classname ) )
			continue;
		if ( attacker.classname != "script_vehicle" )
			continue;
		self.ignored_by_tank_cannon = true;
		wait randomfloatrange( 4.0, 6.0 );
		self.ignored_by_tank_cannon = undefined;
	}
}

friendly_adjust_movement_speed()
{
	self endon( "death" );
	
	for(;;)
	{
		wait randomfloatrange( 1.0, 3.0 );
		
		while( friendly_should_speed_up() )
		{
			self.moveplaybackrate = 2.0;
			wait 0.05;
		}
		
		self.moveplaybackrate = 1.0;
	}
}

friendly_should_speed_up()
{
	prof_begin( "friendly_movement_rate_math" );
	
	if ( !isdefined( self.goalpos ) )
	{
		prof_end( "friendly_movement_rate_math" );
		return false;
	}
	
	if ( distanceSquared( self.origin, self.goalpos ) <= level.goodFriendlyDistanceFromPlayerSquared )
	{
		prof_end( "friendly_movement_rate_math" );
		return false;
	}
	
	// check if AI is visible in player's FOV
	if ( within_fov( level.player.origin, level.player getPlayerAngles(), self.origin, level.cosine[ "60" ] ) )
	{
		prof_end( "friendly_movement_rate_math" );
		return false;
	}
	
	prof_end( "friendly_movement_rate_math" );
	
	return true;
}

isHero()
{
	if ( !isdefined( self ) )
		return false;
	
	if ( !isdefined( self.script_noteworthy ) )
		return false;
	
	if ( self.script_noteworthy == "hero" )
		return true;
	
	return false;
}

friendly_sight_distance( fDistance )
{
	dist = fDistance * fDistance;
	for( i = 0 ; i < level.friendlies.size ; i++ )
		level.friendlies[ i ].maxsightdistsqrd = dist;
}

friendly_movement_speed( speed )
{
	for( i = 0 ; i < level.friendlies.size ; i++ )
		level.friendlies[ i ].moveplaybackrate = speed;
}

friendly_stance( stance1, stance2, stance3 )
{
	for( i = 0 ; i < level.friendlies.size ; i++ )
	{
		if ( isdefined ( stance3 ) )
			level.friendlies[ i ] allowedStances( stance1, stance2, stance3 );
		else
		if ( isdefined ( stance2 ) )
			level.friendlies[ i ] allowedStances( stance1, stance2 );
		else
		level.friendlies[ i ] allowedStances( stance1 );
	}
}

distracted_guys_spawn()
{
	script_org = getent( self.target, "targetname" );
	assert( isdefined( script_org ) );
	assert( script_org.classname == "script_origin" );
	distractedGuyStruct = spawnStruct();
	
	targeted = getentarray( script_org.target, "targetname" );
	distractedGuyStruct.alert_triggers = [];
	distractedGuyStruct.spawners = [];
	for( i = 0 ; i < targeted.size ; i++ )
	{
		if ( issubstr( targeted[ i ].classname, "trigger" ) )
		{
			assert( isdefined( targeted[ i ].script_noteworthy ) );
			distractedGuyStruct.alert_triggers[ distractedGuyStruct.alert_triggers.size ] = targeted[ i ];
		}
		else if ( targeted[ i ] isSpawner() )
		{
			assert( isdefined( targeted[ i ].script_animation ) );
			distractedGuyStruct.spawners[ distractedGuyStruct.spawners.size ] = targeted[ i ];
		}
	}
	assert( distractedGuyStruct.alert_triggers.size > 0 );
	assert( distractedGuyStruct.spawners.size > 0 );
	
	distractedGuyStruct.nodes = [];
	for( i = 0 ; i < distractedGuyStruct.spawners.size ; i++ )
	{
		assert( isdefined( distractedGuyStruct.spawners[ i ].target ) );
		node = getnode( distractedGuyStruct.spawners[ i ].target, "targetname" );
		assert( isdefined( node ) );
		distractedGuyStruct.nodes[ distractedGuyStruct.nodes.size ] = node;
	}
	
	assert( distractedGuyStruct.nodes.size > 0 );
	assert( distractedGuyStruct.nodes.size == distractedGuyStruct.spawners.size );
	
	self waittill( "trigger" );
	
	// spawn the guys
	distractedGuyStruct.guys = [];
	for( i = 0 ; i < distractedGuyStruct.spawners.size ; i++ )
	{
		spawned = distractedGuyStruct.spawners[ i ] stalingradSpawn();
		if ( spawn_failed( spawned ) )
		{
			assertMsg( "distracted guy failed to spawn" );
			return;
		}
		distractedGuyStruct.guys[ distractedGuyStruct.guys.size ] = spawned;
	}
	assert( distractedGuyStruct.guys.size > 0 );
	
	thread distractedGuys_animate( distractedGuyStruct );
}

distractedGuys_animate( distractedGuyStruct )
{
	for( i = 0 ; i < distractedGuyStruct.alert_triggers.size ; i++ )
		distractedGuyStruct.alert_triggers[ i ] thread distractedGuys_alert_trigger( distractedGuyStruct );
	
	for( i = 0 ; i < distractedGuyStruct.guys.size ; i++ )
	{
		distractedGuyStruct.guys[ i ].distracted = true;
		//distractedGuyStruct.guys[ i ].ignoreme = true;
		distractedGuyStruct.guys[ i ] thread alert_event_notify( distractedGuyStruct );
		distractedGuyStruct.guys[ i ].animname = distractedGuyStruct.guys[ i ].script_animation;
		distractedGuyStruct.nodes[ i ] thread anim_loop_solo( distractedGuyStruct.guys[ i ], "idle", undefined, "stop_idle" );
		distractedGuyStruct.guys[ i ].allowdeath = true;
		if ( isdefined( level.scr_anim[ distractedGuyStruct.guys[ i ].animname ][ "death" ] ) )
			distractedGuyStruct.guys[ i ].deathanim = level.scr_anim[ distractedGuyStruct.guys[ i ].animname ][ "death" ];
	}
	
	thread distractedGuys_alert( distractedGuyStruct );
}

distractedGuys_alert_trigger( distractedGuyStruct )
{
	self waittill( self.script_noteworthy );
	distractedGuyStruct notify( "alerted" );
}

distractedGuys_alert( distractedGuyStruct )
{
	switch( distractedGuyStruct.guys.size )
	{
		case 1:
			level waittill_any_ents(	distractedGuyStruct, "alerted",
										distractedGuyStruct.guys[ 0 ] , "alerted",
										distractedGuyStruct.guys[ 0 ], "death",
										distractedGuyStruct.guys[ 0 ], "damage" );
			break;
		case 2:
			level waittill_any_ents(	distractedGuyStruct, "alerted",
										distractedGuyStruct.guys[ 0 ] , "alerted",
										distractedGuyStruct.guys[ 0 ], "death",
										distractedGuyStruct.guys[ 0 ], "damage",
										distractedGuyStruct.guys[ 1 ], "alerted",
										distractedGuyStruct.guys[ 1 ], "death",
										distractedGuyStruct.guys[ 1 ], "damage" );
			break;
	}
	
	distractedGuyStruct notify( "alerted" );
	wait randomfloatrange( 0, 1.3 );
	
	for( i = 0 ; i < distractedGuyStruct.guys.size ; i++ )
	{
		if ( !isalive( distractedGuyStruct.guys[ i ] ) )
			continue;
		
		distractedGuyStruct.guys[ i ].distracted = undefined;
		//distractedGuyStruct.guys[ i ].ignoreme = false;
		distractedGuyStruct.guys[ i ] notify( "alerted" );
		distractedGuyStruct.guys[ i ] notify( "stop_idle" );
		distractedGuyStruct.guys[ i ].deathanim = undefined;
		if ( isdefined( level.scr_anim[ distractedGuyStruct.guys[ i ].animname ][ "react" ] ) )
			distractedGuyStruct.nodes[ i ] thread anim_single_solo( distractedGuyStruct.guys[ i ], "react" );
		else
			distractedGuyStruct.guys[ i ] stopanimscripted();
	}
}

assasination()
{
	targeted = getentarray( self.target, "targetname" );
	script_org = undefined;
	assasinate_trigger = undefined;
	for( i = 0 ; i < targeted.size ; i++ )
	{
		if ( targeted[ i ].classname == "script_origin" )
			script_org = targeted[ i ];
		if ( issubstr( targeted[ i ].classname, "trigger" ) )
			assasinate_trigger = targeted[ i ];
	}
	assert( isdefined( script_org ) );
	assasinationStruct = spawnStruct();
	if ( isdefined( assasinate_trigger ) )
		assasinationStruct.assasinate_trigger = assasinate_trigger;
	
	targeted = getentarray( script_org.target, "targetname" );
	assasinationStruct.assasination_triggers = [];
	assasinationStruct.spawners = [];
	for( i = 0 ; i < targeted.size ; i++ )
	{
		if ( issubstr( targeted[ i ].classname, "trigger" ) )
		{
			assert( isdefined( targeted[ i ].script_noteworthy ) );
			assasinationStruct.assasination_triggers[ assasinationStruct.assasination_triggers.size ] = targeted[ i ];
		}
		else if ( targeted[ i ] isSpawner() )
		{
			assasinationStruct.spawners[ assasinationStruct.spawners.size ] = targeted[ i ];
		}
	}
	assert( assasinationStruct.assasination_triggers.size > 0 );
	assert( assasinationStruct.spawners.size > 0 );
	
	for( i = 0 ; i < assasinationStruct.spawners.size ; i++ )
	{
		assert( isdefined( assasinationStruct.spawners[ i ].target ) );
		node = getnode( assasinationStruct.spawners[ i ].target, "targetname" );
		assert( isdefined( node ) );
		assasinationStruct.spawners[ i ].animnode = node;
	}
		
	self waittill( "trigger" );
	
	// spawn the guys
	assasinationStruct.guys = [];
	for( i = 0 ; i < assasinationStruct.spawners.size ; i++ )
	{
		spawned = assasinationStruct.spawners[ i ] stalingradSpawn();
		if ( spawn_failed( spawned ) )
		{
			assertMsg( "assasination guy failed to spawn" );
			return;
		}
		assert( isdefined( assasinationStruct.spawners[ i ].animnode ) );
		spawned.animnode = assasinationStruct.spawners[ i ].animnode;
		assasinationStruct.guys[ assasinationStruct.guys.size ] = spawned;
	}
	assert( assasinationStruct.guys.size > 0 );
	assasinationStruct.executioners = [];
	allGuys = assasinationStruct.guys;
	for( i = 0 ; i < allGuys.size ; i++ )
	{
		if ( allGuys[ i ].team != "axis" )
		{
			//allGuys[ i ].ignoreme = true;
			continue;
		}
		
		assasinationStruct.executioners[ assasinationStruct.executioners.size ] = allGuys[ i ];
		assasinationStruct.guys = array_remove( assasinationStruct.guys, allGuys[ i ] );
	}
	assert( assasinationStruct.executioners.size > 0 );
	assert( assasinationStruct.guys.size > 0 );
	assert( assasinationStruct.guys.size + assasinationStruct.executioners.size == assasinationStruct.spawners.size );
	
	thread assasination_think( assasinationStruct );
}

assasination_think( assasinationStruct )
{
	for( i = 0 ; i < assasinationStruct.executioners.size ; i++ )
		assasinationStruct.executioners[ i ] endon( "death" );
	
	for( i = 0 ; i < assasinationStruct.guys.size ; i++ )
		thread assasination_assasinated_idle( assasinationStruct, i );
	
	for( i = 0 ; i < assasinationStruct.executioners.size ; i++ )
		thread assasination_executioner_idle( assasinationStruct, i );
	
	thread assasination_alert( assasinationStruct );

	assasinationStruct waittill_any( "alerted", "assasinate" );
	
	createthreatbiasgroup( "executioner" );
	createthreatbiasgroup( "assasinated" );
	setthreatbias( "assasinated", "executioner", 100000 );
	
	for( i = 0 ; i < assasinationStruct.executioners.size ; i++ )
	{
		assasinationStruct.executioners[ i ] setthreatbiasgroup( "executioner" );
		assasinationStruct.executioners[ i ] notify( "stop_idle" );
		assasinationStruct.executioners[ i ] stopanimscripted();
		assasinationStruct.executioners[ i ].goalradius = 16;
		assasinationStruct.executioners[ i ] setGoalNode( assasinationStruct.executioners[ i ].animnode );
		assasinationStruct.executioners[ i ].old_baseAccuracy = assasinationStruct.executioners[ i ].baseAccuracy;
		assasinationStruct.executioners[ i ].baseAccuracy = 1000;
	}
	
	for( i = 0 ; i < assasinationStruct.guys.size ; i++ )
	{
		assasinationStruct.guys[ i ] setthreatbiasgroup( "assasinated" );
		assasinationStruct.guys[ i ].deathanim = level.scr_anim[ "assasinated" ][ "knees_fall" ];
		assasinationStruct.guys[ i ] thread assasination_ragdoll_death();
		assasinationStruct.guys[ i ].allowdeath = true;
		//assasinationStruct.guys[ i ].ignoreme = false;
	}
	
	switch( assasinationStruct.guys.size )
	{
		case 1:
			assasinationStruct.guys[ 0 ] waittill( "death" );
			break;
		case 2:
			waittill_multiple_ents( assasinationStruct.guys[ 0 ], "death", assasinationStruct.guys[ 1 ], "death" );
			break;
		case 3:
			waittill_multiple_ents( assasinationStruct.guys[ 0 ], "death", assasinationStruct.guys[ 1 ], "death", assasinationStruct.guys[ 2 ], "death" );
			break;
		case 4:
			waittill_multiple_ents( assasinationStruct.guys[ 0 ], "death", assasinationStruct.guys[ 1 ], "death", assasinationStruct.guys[ 2 ], "death", assasinationStruct.guys[ 3 ], "death" );
			break;
	}
	
	for( i = 0 ; i < assasinationStruct.executioners.size ; i++ )
	{
		assasinationStruct.executioners[ i ].baseAccuracy = assasinationStruct.executioners[ i ].old_baseAccuracy;
		assasinationStruct.executioners[ i ].old_baseAccuracy = undefined;
	}
}

assasination_alert( assasinationStruct )
{
	for( i = 0 ; i < assasinationStruct.assasination_triggers.size ; i++ )
		assasinationStruct.assasination_triggers[ i ] thread assasination_kill_trigger( assasinationStruct );
	
	for( i = 0 ; i < assasinationStruct.executioners.size ; i++ )
	{
		assasinationStruct.executioners[ i ] thread alert_event_notify( assasinationStruct );
		thread assasination_alert_thread( assasinationStruct.executioners[ i ], assasinationStruct );
	}
}

assasination_alert_thread( guy, assasinationStruct )
{
	level waittill_any_ents(	assasinationStruct, "alerted",
								guy , "alerted",
								guy, "death",
								guy, "damage" );
	
	assasinationStruct notify( "assasinate" );
}

assasination_ragdoll_death()
{
	self waittill( "death" );
	wait 0.5;
	if ( isdefined( self ) )
		self startRagDoll();
}

assasination_assasinated_idle( assasinationStruct, guyIndex )
{
	assasinationStruct.guys[ guyIndex ] thread gun_remove();
	assasinationStruct.guys[ guyIndex ].animname = "assasinated";
	if ( randomint( 3 ) == 0 )
	{
		if ( randomint( 3 ) == 0 )
			assasinationStruct.guys[ guyIndex ].animnode anim_single_solo( assasinationStruct.guys[ guyIndex ], "stand_idle2" );
		assasinationStruct.guys[ guyIndex ].animnode anim_single_solo( assasinationStruct.guys[ guyIndex ], "stand_fall" );
	}
	assasinationStruct.guys[ guyIndex ].animnode thread anim_loop_solo( assasinationStruct.guys[ guyIndex ], "knees_idle", undefined, "stop_idle" );
}

assasination_executioner_idle( assasinationStruct, guyIndex )
{
	assasinationStruct.executioners[ guyIndex ].allowdeath = true;
	assasinationStruct.executioners[ guyIndex ].animname = "executioner";
	assasinationStruct.executioners[ guyIndex ].animnode thread anim_loop_solo( assasinationStruct.executioners[ guyIndex ], "idle", undefined, "stop_idle" );
}

assasination_kill_trigger( assasinationStruct )
{
	self waittill( self.script_noteworthy );
	assasinationStruct notify( "assasinate" );
}

alert_event_notify( struct )
{
	struct endon( "alerted" );
	self endon( "death" );
	
	self thread add_event_listener( "grenade danger" );
	self thread add_event_listener( "gunshot" );
	self thread add_event_listener( "silenced_shot" );
	self thread add_event_listener( "bulletwhizby" );
	self thread add_event_listener( "projectile_impact" );
	
	self waittill( "event_notify" );
	
	struct notify( "alerted" );
}

add_event_listener( sEventString )
{
	self endon( "death" );
	self endon( "event_notify" );
	self addAIEventListener( sEventString );
	self waittill( sEventString );
	self removeAIEventListener( sEventString );
	self notify( "event_notify" );
}

seek_player()
{
	self endon( "death" );
	
	if ( ( isdefined( self.distracted ) ) && ( self.distracted == true ) )
		self waittill( "alerted" );
	
	self.goalradius = 600;
	self setgoalentity( level.player );
}

enemy_color_hint_trigger_think()
{
	for(;;)
	{
		// trigger is hit - notify the targeted trigger to make enemies use color nodes
		self waittill( "trigger" );
		
		getent( self.target, "targetname" ) notify( "trigger" );
		level.seekersUsingColors = true;
		
		while( level.player isTouching( self ) )
			wait 0.1;
		
		// player not in trigger anymore - make enemies use players goal pos
		level.seekersUsingColors = false;
		level notify( "seekers_chase_player" );
	}
}

seek_player_smart()
{
	self endon( "death" );
	
	if ( ( isdefined( self.distracted ) ) && ( self.distracted == true ) )
		self waittill( "alerted" );
	
	self set_force_color( "r" );
	for(;;)
	{
		if ( !level.seekersUsingColors )
		{
			self.goalradius = 2000;
			self.pathenemyfightdist = 1500;
			self setEngagementMinDist( 1300, 1000 );
			self setgoalentity( level.player );
		}
		level waittill( "seekers_chase_player" );
	}
}

seek_player_dog()
{
	self.goalradius = 1000;
	self setgoalentity( level.player );
}

indoor_enemy()
{
	//self.engagemaxdist = 512;
	//self.engagemaxfalloffdist = 1024;
}

waittill_ai_in_volume_dead( volumeTargetname )
{
	volume = getent( volumeTargetname, "targetname" );
	axis = getaiarray( "axis" );
	volumeAxis = [];
	for( i = 0 ; i < axis.size ; i++ )
	{
		if ( !axis[ i ] isTouching( volume ) )
			continue;
		volumeAxis[ volumeAxis.size ] = axis[ i ];
	}
	
	if( volumeAxis.size > 0 )
		waittill_dead( volumeAxis );
}

add_objective_building( aiGroupNum )
{
	if ( !isdefined( level._ai_group ) )
		return;
	
	if ( !isdefined( level._ai_group[ aiGroupNum ] ) )
		return;
	
	if ( !isdefined( level.buildings_remaining ) )
		level.buildings_remaining = 0;
	level.buildings_remaining++;
	
	if ( !isdefined( level.suggested_objective_order ) )
		level.suggested_objective_order = [];
	
	// Find the matching script_origin building location for this objective. It will have the same script_aigroup as the AI
	all_obj_locs = getentarray( "objective_location", "targetname" );
	objective_location = undefined;
	for( i = 0 ; i < all_obj_locs.size ; i++ )
	{
		assert( isdefined( all_obj_locs[ i ].script_aigroup ) );
		if ( all_obj_locs[ i ].script_aigroup != aiGroupNum )
			continue;
		objective_location = all_obj_locs[ i ].origin;
		break;
	}
	assert( isdefined( objective_location ) );
	
	// add this objective to the suggested order
	objectiveIndex = level.suggested_objective_order.size;
	level.suggested_objective_order[ objectiveIndex ] = spawnStruct();
	level.suggested_objective_order[ objectiveIndex ].aiGroupNum = aiGroupNum;
	level.suggested_objective_order[ objectiveIndex ].completed = false;
	level.suggested_objective_order[ objectiveIndex ].additionalPositionIndex = level.buildings_remaining;
	level.suggested_objective_order[ objectiveIndex ].location = objective_location;
	
	// Wait until all AI at this building objective are dead
	waittill_aigroupcleared( aiGroupNum );
	
	wait randomfloatrange( 1.5, 3.0 );
	
	arcademode_checkpoint( 4, "building_" + aiGroupNum );
	
	if ( ( isdefined( level.alasad_objective_location ) ) && ( aiGroupNum == level.alasad_objective_location ) )
		return;
	
	// Buildings cleared - update waypoints
	level.buildings_remaining--;
	level.suggested_objective_order[ objectiveIndex ].completed = true;
	thread objective_updateNextWaypoints();
	
	if ( !flag( "alasad_sequence_started" ) )
	{
		if ( level.buildingClearNextAudio == 0 )
		{
			// Building clear. No sign of Al-Asad. Move on.
			level.gaz thread anim_single_solo( level.gaz, "nosign" );
			
			// increase the ambient
			thread maps\_utility::set_ambient( "exterior3" );
		}
		else if ( level.buildingClearNextAudio == 1 )
		{
			// Building is clear. Move on to the next one.
			level.gaz thread anim_single_solo( level.gaz, "nextone" );
		}
		else if ( level.buildingClearNextAudio == 2 )
		{
			// This building's clear! Let's check the other buildings!
			level.gaz thread anim_single_solo( level.gaz, "checkother" );
		}
		else if ( level.buildingClearNextAudio == 3 )
		{
			// Building clear. Let's check the next one.
			level.gaz thread anim_single_solo( level.gaz, "checknext" );
			
			// settle the ambient
			thread maps\_utility::set_ambient( "exterior1" );
		}
		else if ( level.buildingClearNextAudio == 4 )
		{
			// Building clear. No sign of Al-Asad. Move on.
			level.gaz thread anim_single_solo( level.gaz, "nosign" );
		}
		level.buildingClearNextAudio++;
	}
	
	// Autosave the game at this point
	thread doAutoSave( "building_" + aiGroupNum + "_cleared" );
	
	// if there is only one possible alasad location remaining then activate it now
	level.alasad_possible_objective_locations_remaining = array_remove( level.alasad_possible_objective_locations_remaining, aiGroupNum );
	if ( level.alasad_possible_objective_locations_remaining.size > 1 )
		return;
	if ( isdefined( level.alasad_sequence_init ) )
		return;
	if ( level.alasad_possible_objective_locations_remaining[ 0 ] == "2" )
		thread do_alasad( "house" );
	else if ( level.alasad_possible_objective_locations_remaining[ 0 ] == "6" )
		thread do_alasad( "barn" );
}

objective_updateNextWaypoints()
{
	numObjectivesDisplayed = 2;
	numObjectivesAdded = 0;
	
	// clear all objective waypoints
	for ( i = 0 ; i < level.suggested_objective_order.size ; i++ )
		objective_additionalposition( 0, i, ( 0, 0, 0 ) );
	
	// get the next locations to be shown
	for ( objectiveIndex = 0 ; objectiveIndex < level.suggested_objective_order.size ; objectiveIndex++ )
	{
		if ( level.suggested_objective_order[ objectiveIndex ].completed )
			continue;
		
		// add objective waypoint
		positionIndex = level.suggested_objective_order[ objectiveIndex ].additionalPositionIndex;
		location = level.suggested_objective_order[ objectiveIndex ].location;
		objective_additionalposition( 0, numObjectivesAdded + 1, location );
		
		// make sure we only add as many waypoints as specified
		numObjectivesAdded++;
		if ( numObjectivesAdded == numObjectivesDisplayed )
			return;
		assert( numObjectivesAdded < numObjectivesDisplayed );
	}
}

chopper_air_support()
{
	dialogIndex = 0;
	level.lastUsedWeapon = undefined;
	level.fake_chopper_ammo = 1;
	flag_init("ammo_cheat_for_chopper");
	
	for(;;)
	{
		while( level.player getcurrentweapon() != "cobra_air_support" )
		{
			level.lastUsedWeapon = level.player GetCurrentWeapon();
			wait 0.05;
		}
		
		if(getdvar("player_sustainAmmo") == "0" && !flag("ammo_cheat_for_chopper"))
			ammo = level.player getAmmoCount( "cobra_air_support" );
		else
		{
			flag_set("ammo_cheat_for_chopper"); //once cheat has been called maintain fake ammo. going in and out breaks things. - Nate
			ammo = level.fake_chopper_ammo;
		}
		
		if ( ( !isdefined( ammo ) ) || ( ammo <= 0 ) )
		{
			// give player his weapon back
			chopper_air_support_giveBackWeapon();
			
			if ( flag( "air_support_refueling" ) )
			{
				if ( dialogIndex == 0 )
				{
					// Negative, we are refueling at this time. Standby.
					thread radio_dialogue_queue( "refueling" );
					dialogIndex = 1;
				}
				else
				{
					// We are rearming at this time. Standby.
					thread radio_dialogue_queue( "rearming" );
					dialogIndex = 0;
				}
			}
			
			wait 1;
			continue;
		}
		
		thread chopper_air_support_activate();
		
		while( level.player getcurrentweapon() == "cobra_air_support" )
			wait 0.05;
		
		level notify( "air_support_canceled" );
		thread chopper_air_support_deactive();
	}
}

chopper_air_support_removeFunctionality()
{
	level.player takeWeapon( "cobra_air_support" );
	level notify( "air_support_canceled" );
	level notify( "air_support_deleted" );
	thread chopper_air_support_deactive();
	if ( isdefined( level.chopper ) )
	{
		level.chopper.delete_on_death = true;
		level.chopper notify( "death" );
	}
}

chopper_air_support_activate()
{
	level endon( "air_support_canceled" );
	level endon( "air_support_called" );
	thread chopper_air_support_paint_target();
	thread air_support_hint_print_call();
	
	// Make the arrow
	level.chopperAttackArrow = spawn( "script_model", ( 0, 0, 0 ) );
	level.chopperAttackArrow setModel( "tag_origin" );
	level.chopperAttackArrow.angles = ( -90, 0, 0 );
	level.chopperAttackArrow.offset = 4;
	
	playfxontag( getfx( "air_support_fx_yellow" ), level.chopperAttackArrow, "tag_origin" );
	
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
	
	rotateTime = 0;
	
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
			
			if ( getdvar( "village_assault_debug_marker") == "1" )
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
			
			if ( getdvar( "village_assault_debug_marker") == "1" )
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
		
		if ( getdvar( "village_assault_debug_marker") == "1" )
			thread draw_line_for_time( level.player getEye(), fxLocation, 1, 0, 0, 0.05 );
		
		thread drawChopperAttackArrow( fxLocation, fxNormal, rotateTime );
		
		rotateTime = 0.2;
		
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

chopper_air_support_deactive()
{
	thread delete_attack_coord_hint();
	wait 0.05;
	if ( isdefined( level.chopperAttackArrow ) )
		level.chopperAttackArrow delete();
}

chopper_air_support_giveBackWeapon()
{
	if ( ( isdefined( level.lastUsedWeapon ) ) && ( level.player HasWeapon( level.lastUsedWeapon ) ) )
	{
		level.player switchToWeapon( level.lastUsedWeapon );
	}
	else
	{
		weaponList = level.player GetWeaponsListPrimaries();
		if ( isdefined( weaponList[ 0 ] ) )
			level.player switchToWeapon( weaponList[ 0 ] );
	}
}

chopper_air_support_paint_target()
{
	level endon( "air_support_canceled" );
	level.player waittill ( "weapon_fired" );
	
	level.fake_chopper_ammo = 0;
	level.playerCalledAirSupport = true;
	
	thread chopper_air_support_mark();
	
	// give player his weapon back
	chopper_air_support_giveBackWeapon();
	
	thread chopper_air_support_call_chopper( level.chopperAttackArrow.origin );
	
	level notify( "air_support_called" );
	chopper_air_support_deactive();
	
	if ( level.chopperSupportCallNextAudio == 0 )
		thread radio_dialogue_queue( "ontheway" );			// Mosin Two-Five here. We're on the way. Standby for air support.
	else if ( level.chopperSupportCallNextAudio == 1 )
		thread radio_dialogue_queue( "helicopteronway" );	// Helicopter is on the way. We'll handle it. Out.
	else if ( level.chopperSupportCallNextAudio == 2 )
		thread radio_dialogue_queue( "wehavetarget" );		// This is Mosin Two-Five, we have the target. Standby.
	
	level.chopperSupportCallNextAudio++;
	if ( level.chopperSupportCallNextAudio > 2 )
		level.chopperSupportCallNextAudio = 0;
}

chopper_dialog()
{
	
}

chopper_air_support_mark()
{
	marker = spawn( "script_model", level.chopperAttackArrow.origin );
	marker setModel( "tag_origin" );
	marker.angles = level.chopperAttackArrow.angles;
	
	wait 0.1;
	
	playfxontag( getfx( "air_support_fx_red" ), marker, "tag_origin" );
	
	wait 5.0;
	
	marker delete();
}

chopper_air_support_friendlyFire()
{
	self endon( "death" );
	chopper_accumulated_friendly_damage = 0;
	for(;;)
	{
		self waittill( "damage", amount, attacker, direction, point, type );
		if ( attacker != level.player )
			continue;
		if ( ( isdefined( type ) ) && ( !issubstr( tolower( type ), "bullet" ) ) )
			break;
		
		if ( isdefined( amount ) && ( amount > 0 ) )
			chopper_accumulated_friendly_damage += amount;
		
		if ( chopper_accumulated_friendly_damage >= 500 )
			break;
	}
	thread maps\_friendlyfire::missionfail();
}

chopper_air_support_call_chopper( coordinate )
{
	closestPoint = findBestChopperWaypoint( coordinate, 45 );
	if ( closestPoint <= -1 )
	{
		wait 0.05;
		closestPoint = findBestChopperWaypoint( coordinate, 70 );
		if ( closestPoint <= -1 )
		{
			wait 0.05;
			closestPoint = findBestChopperWaypoint( coordinate, 70, true );
		}
	}
	assert( closestPoint > -1 );
	
	if ( getdvar( "debug_chopper_air_support") == "1" )
		print3d( level.chopperSupportHoverLocations[ closestPoint ] + ( 0, 0,20 ), "chosen", ( 0, 0, 1 ), 1.0, 3.0, 10000 );
	
	// spawn the chopper
	level.chopper = maps\_vehicle::spawn_vehicle_from_targetname( "chopper" );
	assert( isdefined( level.chopper ) );
	level.chopper endon( "death" );
	
	level.chopper thread chopper_air_support_friendlyFire();
	
	returnToBasePos = level.chopper.origin;
	
	// fly chopper to that point and make it face the direction of the target
	eTarget = spawn( "script_origin", coordinate );
	level.chopper setLookAtEnt( eTarget );
	
	level.chopper setspeed( 65, 10, 20 );
	level.chopper sethoverparams( 250, 60, 35 );
	yawAngle = vectorToAngles( coordinate - level.chopperSupportHoverLocations[ closestPoint ] );
	level.chopper setgoalyaw( yawAngle[ 1 ] );
	level.chopper setvehgoalpos( level.chopperSupportHoverLocations[ closestPoint ], true );
	
	level.chopper setNearGoalNotifyDist( 4000 );
	level.chopper waittill( "near_goal" );
	level.chopper thread chopper_ai_mode();
	level.chopper settargetyaw( yawAngle[ 1 ] );
	
	level.chopper waittill( "goal" );
	
	// kill all the spawners nearby the coordinate
	killspawns = getentarray( "helicopter_force_kill_spawn", "targetname" );
	for ( i = 0 ; i < killspawns.size ; i++ )
	{
		if ( eTarget isTouching( killspawns[ i ] ) )
		{
			assert( isdefined( killspawns[ i ].target ) );
			trig = getentarray( killspawns[ i ].target, "targetname" );
			for ( j = 0 ; j < trig.size ; j++ )
				trig[ j ] notify( "trigger" );
		}
	}
	
	level.chopper thread chopper_ai_mode_missiles( eTarget );
	
	badplace_cylinder( "air_support_AOE", 30.0, eTarget.origin, 1050, 10000, "allies" );
	thread chopper_air_support_end( returnToBasePos );
	
}

player_activated_air_support()
{
	return isdefined( level.playerActivatedAirSupport );
}

player_called_air_support()
{
	return isdefined( level.playerCalledAirSupport );
}

delete_hint_print_activated_air_support()
{
	if ( isdefined( level.air_support_hint_delete ) )
	{
		level.air_support_hint_delete = undefined;
		return true;
	}
	
	return isdefined( level.playerActivatedAirSupport );
}

delete_attack_coord_hint()
{
	flag_set( "delete_attack_coord_hint" );
	level waittill( "checked_should_delete_hint" );
	flag_clear( "delete_attack_coord_hint" );
}

should_delete_attack_coord_hint()
{
	ans = flag( "delete_attack_coord_hint" );
	level notify( "checked_should_delete_hint" );
	return ans;
}

findBestChopperWaypoint( coordinate, fov_angle, bForceLocation )
{
	if ( getdvar( "debug_chopper_air_support") == "1" )
		iprintln( "chopper deciding which location to fly to" );
	
	playerCoordinate = level.player.origin;
	playerFaceAngle = level.player getPlayerAngles();
	targetFaceAngle = playerFaceAngle + ( 0, 180, 0 );
	cosine = cos( fov_angle );
	
	if ( !isdefined( bForceLocation ) )
		bForceLocation = false;
	
	closestPoint = -1;
	closestDist = 1000000000;
	minimumSafeDistance = 1000 * 1000;
	for( i = 0 ; i < level.chopperSupportHoverLocations.size ; i++ )
	{
		p = level.chopperSupportHoverLocations[ i ];
		
		if ( !bForceLocation )
		{
			// dont use the point if it's not on the same side of the target as the player ( using imaginary perpindicular line to players facing direction )
			if( !within_fov( flat_origin( coordinate ), flat_angle( targetFaceAngle ), flat_origin( p ), cosine ) )
				continue;
		}

		// get the closest point on the segment to the point
		nearestPointOnLine = pointOnSegmentNearestToPoint( coordinate, playerCoordinate, p );
		d = distanceSquared( nearestPointOnLine, p );
		
		if ( !bForceLocation )
		{
			// make sure the chopper wont fly to a location too close to the target
			if ( d < minimumSafeDistance )
				continue;
		}
		
		if( d < closestDist )
		{
			closestPoint = i;
			closestDist = d;
		}
		
		if ( getdvar( "debug_chopper_air_support") == "1" )
			print3d( p, d, ( 1, 1, 1 ), 1.0, 3.0, 10000 );
	}
	return closestPoint;
}

chopper_air_support_end( returnToBasePos )
{
	level endon( "air_support_deleted" );
	
	flag_clear( "air_support_refueling" );
	
	wait 30;
	
	flag_set( "air_support_refueling" );
	
	// This is Two-Five. We have to refuel and rearm. We will not be available for some time.
	thread radio_dialogue_queue( "refuelandrearm" );
	
	level notify( "air_support_over" );
	flyHomeVec = vectorToAngles( returnToBasePos - level.chopper.origin );
	
	if ( !isdefined( level.chopper ) )
		return;
	
	level.chopper clearLookatEnt();
	level.chopper setTargetYaw( flyHomeVec[ 1 ] );
	level.chopper setVehGoalPos( returnToBasePos );
	
	level.chopper waittill( "goal" );
	level.chopper delete();
	level.chopper = undefined;
	
	wait 20;
	
	flag_clear( "air_support_refueling" );
	
	// Mosin Two-Five here. We are ready to attack and are standing by for new orders.
	thread radio_dialogue_queue( "readytoattack" );
	
	level.player giveStartAmmo( "cobra_air_support" );
	level.fake_chopper_ammo = 1;
}

chopper_ai_mode()
{
	self thread chopper_ai_mode_aim_turret();
	self thread chopper_ai_mode_shoot_turret();
	self thread chopper_ai_mode_flares();
}

chopper_ai_mode_aim_turret()
{
	self endon( "death" );
	level endon( "air_support_over" );
	
	for(;;)
	{
		eTarget = maps\_helicopter_globals::getEnemyTarget( 6000, level.cosine[ "45" ], true, true, true, true );
		if( isdefined( eTarget ) )
		{
			eTargetOffset = ( 0, 0, 0 );
			if ( isdefined( eTarget.script_targetoffset_z ) )
				eTargetOffset += ( 0, 0, eTarget.script_targetoffset_z );
			else if ( isSentient( eTarget ) )
				eTargetOffset = ( 0, 0, 32 );
			self setTurretTargetEnt( eTarget, eTargetOffset );
		}
		wait randomfloatrange( 0.2, 1.0 );
	}
}

chopper_ai_mode_shoot_turret()
{
	self endon( "death" );
	level endon( "air_support_over" );
	
	for(;;)
	{
		randomShots = randomintrange( 30, 60 );
		self setVehWeapon( "hind_turret" );
		for( i = 0 ; i < randomShots ; i++ )
		{
			self fireWeapon( "tag_flash" );
			wait 0.05;
		}
		wait randomfloatrange( 1.0, 1.75 );
	}
}

chopper_ai_mode_flares()
{
	self endon( "death" );
	level endon( "air_support_over" );
	
	for(;;)
	{
		iNumFlares = randomintrange( 2, 8 );
		thread maps\_helicopter_globals::flares_fire_burst( self, iNumFlares, 1, 5.0 );
		wait randomfloatrange( 4.0, 8.0 );
	}
}

chopper_ai_mode_missiles( eTarget )
{
	eTargetOriginal = eTarget;
	
	self endon( "death" );
	level endon( "air_support_over" );
	for(;;)
	{
		iShots = randomintrange( 1, 5 );
		eTarget = maps\_helicopter_globals::getEnemyTarget( 6000, level.cosine[ "25" ], true, true, true, true );
		if ( ( isdefined( eTarget ) ) && ( isdefined( eTarget.origin ) ) )
			self maps\_helicopter_globals::fire_missile( "ffar_mi28_village_assault", iShots, eTarget );
		else
			self maps\_helicopter_globals::fire_missile( "ffar_mi28_village_assault", iShots, eTargetOriginal );
		wait randomfloatrange( 3.5, 6.0 );
	}
}

drawChopperAttackArrow( coord, normal, rotateTime )
{
	assert( isdefined( level.chopperAttackArrow ) );
	assert( isdefined( coord ) );
	assert( isdefined( normal ) );
	assert( isdefined( rotateTime ) );
	
	coord += vector_multiply( normal, level.chopperAttackArrow.offset );
	level.chopperAttackArrow.origin = coord;
	
	if ( rotateTime > 0 )
		level.chopperAttackArrow rotateTo( vectortoangles( normal ), 0.2 );
	else
		level.chopperAttackArrow.angles = vectortoangles( normal );
}

getClosestInFOV( startOrigin, arrayEnts, fov_angle, minDistance )
{
	cos = cos( fov_angle );
	
	closestEnt = undefined;
	secondClosestEnt = undefined;
	closestDist = 1000000000;
	for( i = 0 ; i < arrayEnts.size ; i++ )
	{
		//if( !within_fov( flat_origin( startOrigin ), flat_angle( level.player getPlayerAngles() ), flat_origin( arrayEnts[ i ].origin ), cos ) )
		//	continue;
		
		d = distancesquared( startOrigin, arrayEnts[ i ].origin );
		
		if ( d < minDistance )
			continue;
		
		if( d < closestDist )
		{
			secondClosestEnt = closestEnt;
			closestEnt = arrayEnts[ i ];
			closestDist = d;
		}
	}
	array = [];
	array[ 0 ] = closestEnt;
	array[ 1 ] = secondClosestEnt;
	return array;
}

vehicle_c4_think()
{
	iEntityNumber = self getentitynumber();
	rearOrgOffset = (0, -33, 10);
	rearAngOffset = (0, 90, -90);
	frontOrgOffset = (129, 0, 35);
	frontAngOffset = (0, 90, 144);	
	
	self maps\_c4::c4_location( "rear_hatch_open_jnt_left", rearOrgOffset,  rearAngOffset );
	self maps\_c4::c4_location( "tag_origin", frontOrgOffset, frontAngOffset );
	self.rearC4location = spawn( "script_origin", self.origin );
	self.frontC4location = spawn( "script_origin", self.origin );
	self.rearC4location linkto( self, "rear_hatch_open_jnt_left", rearOrgOffset, rearAngOffset );
	self.frontC4location linkto( self, "tag_origin", frontOrgOffset, frontAngOffset );
	
	self waittill( "c4_detonation" );

	self.frontC4location delete();
	self.rearC4location delete();
	
	self thread vehicle_death( iEntityNumber );
}

vehicle_death( iEntityNumber )
{
	self notify( "clear_c4" );
	setplayerignoreradiusdamage( true );

	//-----------------------
	// FINAL EXPLOSION
	//-----------------------
	earthquake( 0.6, 2, self.origin, 2000 );
	self notify( "death" );
	thread play_sound_in_space( "exp_armor_vehicle", self gettagorigin( "tag_turret" ) );
	AI = get_ai_within_radius( 1024, self.origin, "axis" );
	if ( (isdefined(AI)) && (AI.size > 0) )
		array_thread(AI, ::AI_stun, .85);
	
	radiusdamage( self.origin, 256, 200, 100 );
	
	if ( distancesquared( self.origin, level.player.origin ) <= ( 256 * 256 ) )
		level.player dodamage( level.player.health / 3, ( 0, 0, 0 ) );
}

AI_stun( fAmount )
{
	self endon( "death" );
	if( ( isdefined( self ) ) && ( isalive( self ) ) && ( self getFlashBangedStrength() == 0 ) )
		self setFlashBanged( true, fAmount );
}

get_ai_within_radius( fRadius, org, sTeam )
{
	if( isdefined( sTeam ) )
		ai = getaiarray( sTeam );
	else
		ai = getaiarray();
	
	aDudes = [];
	for( i = 0 ; i < ai.size ; i++ )
	{
		if ( distance( org, self.origin ) <= fRadius )
			array_add( aDudes, ai[ i ] );
	}
	return aDudes;
}

roaming_bmp()
{
	bmp = maps\_vehicle::waittill_vehiclespawn( "roaming_bmp" );
	assert( isdefined( bmp ) );
	
	target_set( bmp, ( 0, 0, 32 ) );
	target_setJavelinOnly( bmp, true );
	
	bmp thread vehicle_patrol_think();
	bmp thread vehicle_turret_think();
	bmp thread vehicle_c4_think();
	bmp thread maps\_vehicle::damage_hints();
	bmp thread bmp_autosave_on_death();
	bmp thread vehicle_death_think();
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

vehicle_death_think()
{
	self endon ("death");
	for(;;)
	{
		self waittill( "damage", damage, attacker, direction_vec, point, type );

		if (attacker != level.player)
			continue;
		
		if ( !isdefined( damage ) )
			continue;
		
		if ( damage <= 0 )
			continue;
		
		type = getDamageType( type );
		assert( isdefined( type ) );
		
		if ( ( type == "rocket" ) && ( damage >= 300 ) )
			break;
		
		if ( ( type == "c4" ) && ( damage >= 250 ) )
			break;
	}
	self notify( "c4_detonation" );
}




vehicle_patrol_init()
{
	level.aVehicleNodes = [];
	array1 = getvehiclenodearray( "go_forward", "script_noteworthy" );
	array2 = getvehiclenodearray( "go_backward", "script_noteworthy" );
	level.aVehicleNodes = array_merge( array1, array2 );	
}

vehicle_patrol_think()
{
	level endon( "alasad_sequence_started" );
	self endon( "death" );

	ePathstart = self.attachedpath;
	self waittill( "reached_end_node" );
	
	for(;;)
	{
		prof_begin( "bmp_logic" );
		
		//-----------------------
		// REINITIALIZE ALL VARIABLES
		//-----------------------
		aLinked_nodes = [];
		eCurrentNode = undefined;
		go_backward_node = undefined;
		go_forward_node = undefined;
		eStartNode = undefined;
		closestEndNodes = undefined;
		
		//-----------------------
		// GET LAST NODE IN CHAIN (CURRENT POSITION
		//-----------------------
		assert( isdefined( ePathstart ) );
		eCurrentNode = ePathstart get_last_ent_in_chain( "vehiclenode" );

		//-----------------------
		// GET ALL NODES THAT ARE GROUPED WITH THIS PATH END
		//-----------------------
		aLinked_nodes = level.aVehicleNodes;
		aLinked_nodes = array_remove( aLinked_nodes, eCurrentNode);
		aVehicleNodes = level.aVehicleNodes;
		sScript_vehiclenodegroup = eCurrentNode.script_vehiclenodegroup;
		assert(isdefined(sScript_vehiclenodegroup));
		for(i=0;i<aVehicleNodes.size;i++)
		{
			assertEx((isdefined(aVehicleNodes[i].script_vehiclenodegroup)), "Vehiclenode at " + aVehicleNodes[i].origin + " needs to be assigned a script_vehiclenodegroup");
			if ( aVehicleNodes[i].script_vehiclenodegroup != sScript_vehiclenodegroup )
				aLinked_nodes = array_remove( aLinked_nodes, aVehicleNodes[i] );
		}
		//-----------------------
		// GET START NODES TO GO FORWARD/BACKWARD FROM HERE
		//-----------------------
		assertEx(aLinked_nodes.size > 0, "Ends of vehicle paths need to be grouped with at least one other chain of nodes for moving forward, backward or both");
		for(i=0;i<aLinked_nodes.size;i++)
		{
			if ( isdefined(aLinked_nodes[i].script_noteworthy) && (aLinked_nodes[i].script_noteworthy == "go_backward") )
			{
				go_backward_node = aLinked_nodes[i];
				go_backward_node.end = undefined;				
			}

			else if ( isdefined(aLinked_nodes[i].script_noteworthy) && (aLinked_nodes[i].script_noteworthy == "go_forward") )
			{
				go_forward_node = aLinked_nodes[i];
				go_forward_node.end = undefined;
			}
		}
		
		//-----------------------
		// DEFINE THE END NODE FOR EACH START NODE
		//-----------------------
		if ( isdefined( go_backward_node ) )
			go_backward_node.end = go_backward_node get_last_ent_in_chain( "vehiclenode" );
		
		if ( isdefined( go_forward_node ) )
			go_forward_node.end = go_forward_node get_last_ent_in_chain( "vehiclenode" );
				
		//-----------------------
		// STAY PUT, OR START A NEW PATH?
		//-----------------------
		closestEndNodes = getClosestInFOV( level.player.origin, level.aVehicleNodes, 55, level.BMP_Safety_Distance );
		assert( isdefined( closestEndNodes[ 0 ] ) );
		assert( isdefined( closestEndNodes[ 0 ].script_vehiclenodegroup ) );
		if ( isdefined( closestEndNodes[ 1 ] ) )
		{
			assert( isdefined( closestEndNodes[ 1 ].script_vehiclenodegroup ) );
			if ( closestEndNodes[ 1 ].script_vehiclenodegroup < closestEndNodes[ 0 ].script_vehiclenodegroup )
			{
				temp = closestEndNodes[ 0 ];
				closestEndNodes[ 0 ] = closestEndNodes[ 1 ];
				closestEndNodes[ 1 ] = temp;
			}
		}
		if ( closestEndNodes[ 0 ] == eCurrentNode )
			eStartNode = undefined;
		else if ( ( isdefined( go_forward_node ) ) && ( closestEndNodes[ 0 ].script_vehiclenodegroup >= go_forward_node.end.script_vehiclenodegroup ) )
			eStartNode = go_forward_node;
		else if ( ( isdefined( go_backward_node ) ) && ( closestEndNodes[ 0 ].script_vehiclenodegroup <= go_backward_node.end.script_vehiclenodegroup ) )
			eStartNode = go_backward_node;
		
		prof_end( "bmp_logic" );
		
		//-----------------------
		// GO ON THE NEW PATH TO GET CLOSER TO PLAYER OTHERWISE STAY PUT
		//-----------------------
		if ( isdefined(eStartNode) )
		{
			self attachpath( eStartNode );
			ePathstart = eStartNode;
			wait randomfloatrange( 0.2, 1.2 );
			self resumeSpeed( 100 );
			self waittill( "reached_end_node" );
		}
		else
		{
			wait randomfloatrange( 3, 6 );
		}
	}
}

vehicle_turret_think()
{
	level endon( "alasad_sequence_started" );
	self endon( "death" );
	
	eTarget = undefined;
	
	for(;;)
	{
		prof_begin( "bmp_logic" );
		
		eTarget = maps\_helicopter_globals::getEnemyTarget( 3000, undefined, true, true, false, true );
		
		prof_end( "bmp_logic" );
		
		if ( isdefined( eTarget ) )
		{
			self setTurretTargetEnt( eTarget, ( 0, 0, 32 ) );
			self waittill_notify_or_timeout( "turret_rotate_stopped", randomfloatrange( 2.0, 3.0 ) );
			
			iFireTime = weaponfiretime( "bmp_turret" );
			assert( isdefined( iFireTime ) );
			assert( iFireTime > 0 );
			
			iShots = randomintrange( 3, 8 );
			for( i = 0 ; i < iShots ; i++ )
			{
				self fireWeapon();
				wait iFireTime;
			}
		}
		wait randomfloat( 3.0, 6.0 );
	}
}

doAutoSave( sSaveName )
{
	assert( isdefined( sSaveName ) );
	thread autosave_by_name( sSaveName );
	thread timedAutosaves();
}

bmp_autosave_on_death()
{
	self waittill( "death" );
	if ( isdefined( self ) )
		target_remove( self );
	thread doAutoSave( "bmp_destroyed" );
}

timedAutosaves()
{
	level endon( "alasad_sequence_started" );
	level notify( "timedAutosaveThread" );
	level endon( "timedAutosaveThread" );
	
	if ( level.timedAutosaveTime == 0 )
		return;
	
	for(;;)
	{
		wait level.timedAutosaveTime;
		level.timedAutosaveNumber++;
		thread doAutoSave( "timed_autosave" + level.timedAutosaveNumber );
	}
}

genocide_audio_trigger()
{
	soundEnt = getent( self.target, "targetname" );
	assert( isdefined( soundEnt ) );
	
	self waittill( "trigger" );
	
	if ( isdefined( self.script_delay ) )
		wait self.script_delay;
	
	assert( isdefined( level.genocide_audio[ level.next_genocide_audio ] ) );
	
	soundEnt playSound( level.genocide_audio[ level.next_genocide_audio ] );
	
	level.next_genocide_audio++;
}

dead_civilian()
{
	wait randomfloatrange( 0.05, 0.2 );
	spawned = dronespawn( self );
	spawned setContents( 0 );
	spawned startRagDoll();
}

air_support_hint_print_activate()
{
	level endon( "alasad_sequence_started" );
	
	while( !player_activated_air_support() )
	{	
		if ( level.air_support_hint_print_dialog_next == 0 )
		{
			// Soap! Call in air support on that building!	
			level.price thread anim_single_solo( level.price, "airsupport" );
		}
		else if ( level.air_support_hint_print_dialog_next == 1 )
		{
			// Use our air support to soften up that building!
			level.price thread anim_single_solo( level.price, "softenup" );
		}
		else
		{
			// Mosin Two-Five here. We are ready to attack and are standing by for new orders.
			thread radio_dialogue_queue( "readytoattack" );
		}
		level.air_support_hint_print_dialog_next++;
		
		if ( !flag( "gave_air_support_hint" ) )
		{
			flag_set( "gave_air_support_hint" );
			if ( isdefined( level.console ) && level.console )
				thread display_air_support_hint_console();
			else
				thread display_air_support_hint_pc();
		}
		wait 5;
		level.air_support_hint_delete = true;
		wait 60;
	}
}

display_air_support_hint_console()
{
	level endon( "clearing_hints" );
	
	add_hint_background();
	
	level.hintElem = createFontString( "default", 1.6 );
	level.hintElem setPoint( "TOP", undefined, 0, 130 );
	level.hintElem setText( &"SCRIPT_LEARN_CHOPPER_AIR_SUPPORT1" );
	
	level.iconElem1 = createIcon( "hud_dpad", 32, 32 );
	level.iconElem1 setPoint( "TOP", undefined, -32, 165 );
	
	level.iconElem3 = createIcon( "hud_arrow_right", 24, 24 );
	level.iconElem3 setPoint( "TOP", undefined, -31.5, 170 );
	level.iconElem3.sort = 1;
	level.iconElem3.color = (1,1,0);
	level.iconElem3.alpha = .7;
	
	level.iconElem2 = createIcon( "hud_icon_cobra", 64, 32 );
	level.iconElem2 setPoint( "TOP", undefined, 16, 165 );	
	
	wait 4;
	
	level.iconElem1 setPoint( "CENTER", "BOTTOM", -320, -20, 1.0 );
	level.iconElem2 setPoint( "CENTER", "BOTTOM", -320, -20, 1.0 );
	level.iconElem3 setPoint( "CENTER", "BOTTOM", -320, -20, 1.0 );
	
	level.iconElem1 scaleovertime(1, 20, 20);
	level.iconElem2 scaleovertime(1, 20, 20);
	level.iconElem3 scaleovertime(1, 20, 20);
	
	wait .70;
	
	level.hintElem fadeovertime(.15);
	level.hintElem.alpha = 0;
	
	level.iconElem1 fadeovertime(.15);
	level.iconElem1.alpha = 0;
	
	level.iconElem2 fadeovertime(.15);
	level.iconElem2.alpha = 0;
	
	level.iconElem3 fadeovertime(.15);
	level.iconElem3.alpha = 0;
	
	level.hintbackground fadeovertime(.15);
	level.hintbackground.alpha = 0;
	
	wait 0.15;
	
	clear_hints();
}

display_air_support_hint_pc()
{
	level endon( "clearing_hints" );
	
	add_hint_background();
	
	level.hintElem = createFontString( "default", 1.6 );
	level.hintElem setPoint( "TOP", undefined, 0, 130 );
	level.hintElem setText( &"SCRIPT_LEARN_CHOPPER_AIR_SUPPORT1_PC" );
	
	level.iconElem2 = createIcon( "hud_icon_cobra", 64, 32 );
	level.iconElem2 setPoint( "TOP", undefined, 16, 165 );	
	
	wait 4;
	
	level.iconElem2 setPoint( "CENTER", "BOTTOM", -320, -20, 1.0 );
	
	level.iconElem2 scaleovertime(1, 20, 20);
	
	wait .70;
	
	level.hintElem fadeovertime(.15);
	level.hintElem.alpha = 0;
	
	level.iconElem2 fadeovertime(.15);
	level.iconElem2.alpha = 0;
	
	level.hintbackground fadeovertime(.15);
	level.hintbackground.alpha = 0;
	
	wait 0.15;
	
	clear_hints();
}

add_hint_background( double_line )
{
	if ( isdefined ( double_line ) )
		level.hintbackground = createIcon( "popmenu_bg", 650, 50 );
	else
		level.hintbackground = createIcon( "popmenu_bg", 650, 30 );
	level.hintbackground.hidewheninmenu = true;
	level.hintbackground setPoint( "TOP", undefined, 0, 125 );
	level.hintbackground.alpha = .5;
}

clear_hints()
{
	level notify ( "clearing_hints" );
	if ( isDefined( level.hintElem ) )
		level.hintElem destroy();
	if ( isDefined( level.iconElem1 ) )
		level.iconElem1 destroy();
	if ( isDefined( level.iconElem2 ) )
		level.iconElem2 destroy();
	if ( isDefined( level.iconElem3 ) )
		level.iconElem3 destroy();
	if ( isDefined( level.hintbackground ) )
		level.hintbackground destroy();
}

air_support_hint_print_call()
{
	if ( player_called_air_support() )
		return;
	
	level endon( "alasad_sequence_started" );	
	thread clear_hints();
	thread display_hint( "call_air_support2" );
	wait 5;
	level.air_support_hint_delete = true;
}

trigger_upstairs_guys()
{
	assert( isdefined( self.target ) );
	
	volume = getent( self.target, "targetname" );
	assert( isdefined( volume ) );
	assert( isdefined( volume.target ) );
	
	node = getnode( volume.target, "targetname" );
	assert( isdefined( node ) );
	assert( isdefined( node.radius ) );
	
	self waittill( "trigger" );
	
	wait randomfloatrange( 5.0, 10.0 );
	
	enemies = getaiarray( "axis" );
	for( i = 0 ; i < enemies.size ; i++ )
	{
		if ( !( enemies[ i ] istouching( volume ) ) )
			continue;
		
		enemies[i].goalradius = node.radius;
		enemies[i] setgoalnode( node );
	}
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

alasad_deletable_hide()
{
	if ( isdefined( self.spawnflags ) && ( self.spawnflags & 1 ) )
		self connectpaths();
	self.origin -= ( 0, 0, 5000 );
}

alasad_deletable_show()
{
	self.origin += ( 0, 0, 5000 );
	if ( isdefined( self.spawnflags ) && ( self.spawnflags & 1 ) )
		self disconnectpaths();
}

spawn_ai_and_make_dumb( spawnerTargetname, linkInPlace )
{
	spawner = getent( spawnerTargetname, "targetname" );
	assert( isdefined( spawner ) );
	if ( isdefined( spawner.script_drone ) )
	{
		guy = droneSpawn( spawner );
	}
	else
	{
		guy = spawner stalingradSpawn();
		spawn_failed( guy );
		guy.maxsightdistsqrd = 0;
		guy.ignoreme = true;
		guy.ignoreall = true;
		guy thread ignoreAllEnemies( true );
	}
	guy.health = 100000;
	
	if ( isdefined( linkInPlace ) )
	{
		dummy = spawn( "script_origin", spawner.origin );
		guy linkto( dummy );
	}
	
	return guy;
}

headshot( guy, killguy )
{
	if ( !isdefined( guy ) )
		return;
	if ( !isAlive( guy ) )
		return;
	if ( !isdefined( killguy ) )
		killguy = true;
	playFX( getfx( "headshot" ), guy getTagOrigin( "tag_eye" ) );
	if ( killguy )
		guy doDamage( guy.health + 100, guy getTagOrigin( "tag_eye" ) );
}

goBlack( fDelay, fFadeTimeIn, fFadeTimeOut )
{
	overlay = newHudElem();
	overlay.x = 0;
	overlay.y = 0;
	overlay.alignX = "left";
	overlay.alignY = "top";
	overlay.horzAlign = "fullscreen";
	overlay.vertAlign = "fullscreen";
	overlay setshader ( "black", 640, 480 );
	overlay.sort = 1;
	overlay.alpha = 0;
	
	assert( isdefined( fFadeTimeIn ) );
	assert( isdefined( fFadeTimeOut ) );
	assert( fFadeTimeIn >= 0 );
	assert( fFadeTimeOut >= 0 );
	
	if ( fFadeTimeIn > 0 )
		overlay fadeOverTime( fFadeTimeIn );
	overlay.alpha = 1.0;
	wait fFadeTimeIn;
	
	if ( !isdefined( fDelay ) )
		return;
	assert( fDelay > 0 );
	
	wait fDelay;
	
	level notify( "fade_from_black" );
	wait 0.1;
	
	if ( fFadeTimeOut > 0 )
		overlay fadeOverTime( fFadeTimeOut );
	overlay.alpha = 0.0;
	wait fFadeTimeOut;
	
	overlay destroy();
}

do_alasad( location )
{
	assert( isdefined( location ) );
	
	level.alasad_sequence_init = true;
	
	struct = spawnStruct();
	
	if ( location == "barn" )
	{
		println( "Al Asad is in the ^3BARN" );
		
		struct.nodeTargetname1 = "alasad_barn_node";
		struct.nodeTargetname2 = "alasad_barn_node2";
		struct.deletableNoteworthy = "alasad_barn_deletable";
		struct.brushDoorTargetname = "alasad_barn_door";
		struct.spawnersToDeleteKillspawner = 12;
		struct.friendlyColorTriggerTargetname1 = "alasad_barn_friendly_color_trigger";
		struct.friendlyColorTriggerTargetname2 = "alasad_barn_last_friendly_trigger";
		struct.AlAsadSpawnerTargetname = "alasad_spawner_barn";
		struct.AlAsadFirstShotSpawnerTargetname = "alasad_barn_first_shot_spawner";
		struct.AlAsadSecondShotSpawnerTargetname = "alasad_barn_second_shot_spawner";
		struct.startSequenceTriggerTargetname = "alasad_barn_trigger";
		struct.playerLocationSceneBTargetname = "alasad_barn_playerlocation";
		struct.setupAreaTriggerTargetname = "alasad_barn_area";
		struct.AItoDeleteAreaTargetname = "area_barn";
		
		level.alasad_flashbang_location = getent( "alasad_barn_flash_location", "targetname" ).origin;
		
		level.alasad_objective_location = "6";
	}
	else if ( location == "house" )
	{
		println( "Al Asad is in the ^3HOUSE" );
		
		struct.nodeTargetname1 = "alasad_house_node";
		struct.nodeTargetname2 = "alasad_house_node2";
		struct.deletableNoteworthy = "alasad_house_deletable";
		struct.brushDoorTargetname = "alasad_house_door";
		struct.spawnersToDeleteKillspawner = 2;
		struct.friendlyColorTriggerTargetname1 = "alasad_house_friendly_color_trigger";
		struct.friendlyColorTriggerTargetname2 = "alasad_house_last_friendly_trigger";
		struct.AlAsadSpawnerTargetname = "alasad_spawner_house";
		struct.AlAsadFirstShotSpawnerTargetname = "alasad_house_first_shot_spawner";
		struct.AlAsadSecondShotSpawnerTargetname = "alasad_house_second_shot_spawner";
		struct.startSequenceTriggerTargetname = "alasad_house_trigger";
		struct.playerLocationSceneBTargetname = "alasad_house_playerlocation";
		struct.setupAreaTriggerTargetname = "alasad_house_area";
		struct.AItoDeleteAreaTargetname = "area_grandmas_house";
		
		level.alasad_flashbang_location = getent( "alasad_house_flash_location", "targetname" ).origin;
		
		level.alasad_objective_location = "2";
	}
	
	assert( isdefined( struct ) );
	assert( isdefined( struct.nodeTargetname1 ) );
	assert( isdefined( struct.nodeTargetname2 ) );
	assert( isdefined( struct.deletableNoteworthy ) );
	assert( isdefined( struct.brushDoorTargetname ) );
	assert( isdefined( struct.friendlyColorTriggerTargetname1 ) );
	assert( isdefined( struct.friendlyColorTriggerTargetname2 ) );
	assert( isdefined( struct.AlAsadSpawnerTargetname ) );
	assert( isdefined( struct.AlAsadFirstShotSpawnerTargetname ) );
	assert( isdefined( struct.AlAsadSecondShotSpawnerTargetname ) );
	assert( isdefined( struct.startSequenceTriggerTargetname ) );
	assert( isdefined( struct.playerLocationSceneBTargetname ) );
	assert( isdefined( struct.setupAreaTriggerTargetname ) );
	assert( isdefined( level.alasad_flashbang_location ) );
	
	alasad_sequence_init( struct );
}

alasad_sequence_init( struct )
{
	// prepares the correct location for the scene by removing spawners and setting up doors etc.
	
	array_thread( getentarray( struct.deletableNoteworthy, "script_noteworthy" ), ::alasad_deletable_show );
	
	// get the first node
	struct.node = getnode( struct.nodeTargetname1, "targetname" );
	assert( isdefined( struct.node ) );
	
	// spawn the door and make it play frame 0 so it's shut
	struct.door = spawn_anim_model( "door" );
	struct.node thread anim_first_frame_solo( struct.door, "interrogationA" );
	
	// link the door to the model door that animates and hide the model door
	struct.brushmodel_door = getent( struct.brushDoorTargetname, "targetname" );
	assert( isdefined( struct.brushmodel_door ) );
	struct.brushmodel_door linkto( struct.door, "door_hinge_jnt" );
	struct.door hide();
	
	// delete AI and spawners with this noteworthy when the barn will be the location of al asad
	if ( isdefined( struct.spawnersToDeleteKillspawner ) )
		thread maps\_spawner::kill_spawnerNum( struct.spawnersToDeleteKillspawner );
	if ( isdefined( struct.AItoDeleteAreaTargetname ) )
	{
		area = getent( struct.AItoDeleteAreaTargetname, "targetname" );
		axis = getAIArray( "axis" );
		for ( i = 0 ; i < axis.size ; i++ )
		{
			if ( !axis[ i ] istouching( area ) )
				continue;
			axis[ i ].dieQuietly = true;
			axis[ i ] doDamage( axis[ i ].health + 100, axis[ i ].origin );
		}
	}
	
	alasad_sequence_wait( struct );
}

alasad_sequence_wait( struct )
{
	// Waits for the player to get close to Al Asad's location and moves the friendlies to the door
	// If the player runs off the friendlies leave the door and go back to normal AI until the player returns
	
	level endon( "alasad_sequence_started" );
	
	struct.alasad_area = getent( struct.setupAreaTriggerTargetname, "targetname" );
	assert( isdefined( struct.alasad_area ) );
	
	struct.color_trigger = getent( struct.friendlyColorTriggerTargetname1, "targetname" );
	assert( isdefined( struct.color_trigger ) );
	
	for(;;)
	{
		if ( level.player isTouching( struct.alasad_area ) )
		{
			// make all friendlies orange color group and send them to the door
			array_thread( getAIArray( "allies" ), ::set_force_color, "o" );
			struct.color_trigger notify( "trigger" );
			
			thread alasad_sequence_ready( struct );
			
			while( level.player isTouching( struct.alasad_area ) )
				wait 0.05;
		}
		else
		{
			level notify( "alasad_sequence_canceled" );
			
			// make all friendlies red color group again because player is leaving the area
			array_thread( getAIArray( "allies" ), ::set_force_color, "r" );
			
			while( !level.player isTouching( struct.alasad_area ) )
				wait 0.05;
		}
	}
}

alasad_sequence_ready( struct )
{
	level endon( "alasad_sequence_canceled" );
	
	// get price into position
	struct.node thread anim_reach_solo( level.price, "interrogationA" );
	
	// wait for the player to get close
	getent( struct.startSequenceTriggerTargetname, "targetname" ) waittill( "trigger" );
	
	alasad_sequence_start( struct );
}

alasad_sequence_start( struct )
{
	level notify( "alasad_sequence_started" );
	level.air_support_hint_delete = true;
	
	// take away flash, grenade, smoke, etc
	removeWeaponFromPlayer( "fraggrenade" );
	removeWeaponFromPlayer( "smoke_grenade_american" );
	removeWeaponFromPlayer( "c4" );
	removeWeaponFromPlayer( "flash_grenade" );
	
	thread battlechatter_off( "allies" );
	thread battlechatter_off( "axis" );
	
	thread doAutoSave( "capturing_al_asad" );
	
	//---------------
	// SCENE A
	//---------------
	
	// spawn and prepare Al Asad
	level.alasad = spawn_ai_and_make_dumb( struct.AlAsadSpawnerTargetname );
	level.alasad thread removeWeapon();
	level.alasad.animname = "alasad";
	waittillframeend;	// waittillframeend so that Al Asad can finish spawning before he gets teleported
	struct.node thread anim_teleport_solo( level.alasad, "interrogationA" );
	
	// spawn the guys guarding Al Asad
	level.alasad_guard1 = spawn_ai_and_make_dumb( struct.AlAsadFirstShotSpawnerTargetname, true );
	level.alasad_guard2 = spawn_ai_and_make_dumb( struct.AlAsadSecondShotSpawnerTargetname, true );
	
	// spawn the phone
	phone = spawn_anim_model( "phone" );
	struct.node thread anim_first_frame_solo( phone, "interrogationA" );
	
	struct.guys = [];
	struct.guys[ struct.guys.size ] = level.price;
	
	// get them into position to start the sequence
	struct.node anim_reach( struct.guys, "interrogationA" );
	struct.guys[ struct.guys.size ] = level.alasad;
	
	// give price his special weapon for the scene
	level.price animscripts\init::initWeapon( "colt45_alasad_killer", "sidearm" );
	level.price.sidearm = "colt45_alasad_killer";
	
	// wait until the player can see the sequence
	level.price waittill_player_lookat( level.cosine[ "60" ] );
	
	flag_set( "alasad_sequence_started" );
	
	level.price thread play_sound_on_entity( "scn_assault_interogation_enter" );
	
	// Remember, we want Al-Asad alive. He's no good to us dead. Let's go.
	level.price thread anim_single_solo( level.price, "nogooddead" );
	
	// start the seqence
	delayThread( 5.9, ::activate_trigger_with_targetname, struct.friendlyColorTriggerTargetname2 );
	delayThread( 6.0, ::disconnectPathsWrapper, struct.brushmodel_door );
	struct.guys[ struct.guys.size ] = struct.door;
	struct.guys[ struct.guys.size ] = phone;
	struct.node anim_single( struct.guys, "interrogationA" );
	
	// take away ability to call air support
	thread chopper_air_support_removeFunctionality();
	
	thread goBlack( 18.0, 0.0, 0.5 );
	thread blackscreen1_dialog();
	thread alasad_kill_axis();
	level.player NightVisionForceOff();
	
	//---------------
	// SCENE B
	//---------------
	
	objective_state( 0, "done" );
	
	struct.node = getnode( struct.nodeTargetname2, "targetname" );
	assert( isdefined( struct.node ) );
	
	level.price detach( "weapon_m4grunt_sp_silencer", "tag_weapon_chest" );
	level.price.a.weaponPos[ "chest" ] = "none";
	
	// spawn the chair
	chair = spawn_anim_model( "chair" );
	
	// first frame of next scene so it's ready
	struct.guys = [];
	struct.guys[ struct.guys.size ] = level.price;
	struct.guys[ struct.guys.size ] = level.gaz;
	struct.guys[ struct.guys.size ] = level.alasad;
	struct.guys[ struct.guys.size ] = chair;
	struct.guys[ struct.guys.size ] = phone;
	
	struct.node thread anim_first_frame( struct.guys, "interrogationB" );
	
	// put the player in a good spot
	level.player freezeControls( true );
	delete_dropped_weapons();
	level.player takeAllWeapons();
	movePlayerToLocation( struct.playerLocationSceneBTargetname );
	
	level waittill( "fade_from_black" );
	level.player freezeControls( false );
	
	level.price thread alasad_execution_notes();
	level.price thread alasad_cell_phone_sounds( phone );
	level.gaz thread play_sound_on_entity( "scn_assault_interogation_pickup" );
	level.price thread play_sound_on_entity( "scn_assault_interogation_beating" );
	level.alasad thread play_sound_on_entity( "scn_assault_interogation_breathing" );
	struct.node anim_single( struct.guys, "interrogationB" );
	
	level.price.weaponInfo["m4_silencer"].position = "none";
}

blackscreen1_dialog()
{
	wait 2;
	
	level.player thread play_sound_on_entity( "scn_assault_interogation_black" );
	
	// Why'd you do it? Where did you get the bomb?
	level.price thread delayThread( 0.0, ::anim_single_solo, level.price, "whydyoudoit" );
	
	// It wasn't me!!
	level.alasad thread delayThread( 3.05, ::anim_single_solo, level.alasad, "wasntme1" );
	
	// Who then?
	level.price thread delayThread( 5.3, ::anim_single_solo, level.price, "whothen" );
	
	// It wasn't me!!
	level.alasad thread delayThread( 8.3, ::anim_single_solo, level.alasad, "wasntme2" );
	
	// Who!? Give me a name!
	level.price thread delayThread( 10.85, ::anim_single_solo, level.price, "givemeaname" );
	
	// A name! I - want - his - name!
	level.price thread delayThread( 13.65, ::anim_single_solo, level.price, "aname" );
	
	wait 16;
}

blackscreen2_dialog()
{
	wait 1;
	
	// Who was that sir?
	level.gaz thread anim_single_solo( level.gaz, "whowasthat" );
	
	wait 2;
	
	// Zakhaev.
	level.price thread anim_single_solo( level.price, "zakhaev" );
	
	wait 2;
	
	// Imran Zakhaev.
	level.price thread anim_single_solo( level.price, "imran" );
}

alasad_execution_notes()
{
	level.price waittillmatch( "single anim", "pistol_pickup" );
	level.price detach( "weapon_colt1911_black", "tag_weapon_right" );
	wait 0.2;
	level.price attach( "weapon_colt1911_black", "tag_weapon_right" );
	
	level.price waittillmatch( "single anim", "fire" );
	wait 3.5;
	
	level.player freezeControls( true );
	thread goBlack( 60.0, 1.0, 0.5 );
	thread blackscreen2_dialog();
	wait 7;
	nextmission();
}

alasad_cell_phone_sounds( phone )
{
	wait 2;
	
	thread alasad_cell_phone_ring( phone );
	
	wait 7;
	
	phone notify( "stop ringing" );
	
	wait 1;
	
	// Sir. It's his cell phone.
	level.gaz thread anim_single_solo( level.gaz, "cellphone" );
}

alasad_cell_phone_ring( phone )
{
	phone endon( "stop ringing" );
	for(;;)
	{
		level.gaz thread play_sound_on_entity( "scn_assault_mobile_ring" );
		wait 2;
	}
}

alasad_notetracks( guy )
{
	// called from a notetrack
	
	sHandTag = "J_Mid_RI_3";
	guy attach( "projectile_m84_flashbang_grenade", sHandTag );
	
	wait 2.0;
	
	// price tosses in a flashbang
	guy detach( "projectile_m84_flashbang_grenade", sHandTag );
	thread alasad_flashbang( 1.0 );
	
	// price picks up pistol so need to replace the rifle
	guy waittillmatch( "single anim", "pistol_pickup" );
	
	// price drops his gun
	guy waittillmatch( "single anim", "pistol_drop" );
	guy gun_remove();
	
	// al asad gets shot
	guy waittillmatch( "single anim", "fire" );
	headshot( level.alasad, false );
}

alasad_flashbang( fDelay )
{
	assert( isdefined( level.alasad_flashbang_location ) );
	wait fDelay;
	playFX( getfx( "alasad_flash" ), level.alasad_flashbang_location );
	thread play_sound_in_space( "flashbang_explode_default", level.alasad_flashbang_location );
	
	// two guards get shot
	wait 1.0;
	headshot( level.alasad_guard1 );
	wait 0.5;
	headshot( level.alasad_guard2 );
}

alasad_kill_axis()
{
	axis = getaiarray( "axis" );
	for ( i = 0 ; i < axis.size ; i++ )
	{
		if ( !isAlive( axis[ i ] ) )
			continue;
		if ( axis[ i ] == level.alasad )
			continue;
		if ( axis[ i ] == level.alasad_guard1 )
			continue;
		if ( axis[ i ] == level.alasad_guard2 )
			continue;
		axis[ i ].dieQuietly = true;
		axis[ i ] doDamage( axis[ i ].health + 100, axis[ i ].origin );
	}
}

disconnectPathsWrapper( ent )
{
	ent connectPaths();
}

opening_sequence()
{
	assert( isdefined( level.opening_guy ) );
	node = getnode( "opening_sequence_node", "targetname" );
	assert( isdefined( node ) );
	guys = [];
	guys[ 0 ] = level.price;
	guys[ 1 ] = level.opening_guy;
	node anim_first_frame( guys, "opening" );
	wait 4.0;
	thread opening_sequence_notetracks( level.opening_guy );
	thread opening_sequence_dialog( level.opening_guy );
	node anim_single( guys, "opening" );
}

opening_sequence_notetracks( guy )
{
	guy attach( "com_flashlight_off", "tag_inhand" );
	
	guy waittillmatch( "single anim", "flash" );
	thread opening_sequence_flashLight( guy );
	
	guy waittillmatch( "single anim", "flash" );
	thread opening_sequence_flashLight( guy );
	
	guy waittillmatch( "single anim", "flash" );
	thread opening_sequence_flashLight( guy );
	
	guy waittillmatch( "single anim", "detach flashlight" );
	guy detach( "com_flashlight_off", "tag_inhand" );
}

opening_sequence_flashLight( guy )
{
	tagName = "tag_inhand";
	modelOn = "com_flashlight_on";
	modelOff = "com_flashlight_off";
	
	// on
	if ( guy isModelAttached( modelOff, tagName ) )
		guy detach( modelOff, tagName );
	guy attach( modelOn, tagName );
	guy thread flashlight_light( true );
	wait 0.1;
	
	// off
	if ( guy isModelAttached( modelOn, tagName ) )
		guy detach( modelOn, tagName );
	guy attach( modelOff, tagName );
	guy thread flashlight_light( false );
}

opening_sequence_dialog( guy )
{
	wait 3;
	
	//There's Kamarov's man, let's go.
	level.price thread anim_single_solo( level.price, "kamarovsman" );
	
	wait 5;
	
	//Al-Asad is in the village. The Ultranationalists are protecting him.
	guy thread anim_single_solo( guy, "asadinvillage" );
	
	wait 4.5;
	
	//Perfect. Move out.
	level.price thread anim_single_solo( level.price, "perfect" );
	
	wait 10;
	
	//What the bloody hell's going on up there?
	level.gaz thread anim_single_solo( level.gaz, "whatsgoingon" );
	
	wait 2.5;
	
	//It's the Ultranationalists. They're killing the villagers.
	guy thread anim_single_solo( guy, "killingvillagers" );
	
	wait 3.5;
	
	//Not for long they're not.
	level.gaz thread anim_single_solo( level.gaz, "notforlong" );
}

isModelAttached( modelName, tagName )
{
	qAttached = false;
	
	modelName = tolower( modelName );
	tagName = tolower( tagName );
	
	assert( isdefined( modelName ) );
	if ( !isdefined( tagName ) )
		return qAttached;
	
	attachedModelCount = self getattachsize();
	attachedModels = [];
	for ( i = 0 ; i < attachedModelCount ; i++ )
		attachedModels[ i ] = tolower( self getAttachModelName( i ) );
	
	for ( i = 0 ; i < attachedModels.size ; i++ )
	{
		if ( attachedModels[ i ] != modelName )
			continue;
		
		sName = tolower( self getattachtagname( i ) );
		if ( tagName != sName )
			continue;
		
		qAttached = true;
		break;
	}
	
	return qAttached;
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
		playfxontag( level._effect[ "flashlight" ], flashlight_fx_ent, "tag_origin" );
	}
	else
		self notify( "flashlight_off" );
}

flashlight_light_death( flashlight_fx_ent )
{
	self waittill_either( "death", "flashlight_off" );
	flashlight_fx_ent delete();
}

removeWeaponFromPlayer( weaponName )
{
	assert( isdefined( weaponName ) );
	if( level.player HasWeapon( weaponName ) )
		level.player takeWeapon( weaponName );
}

removeWeapon( optionalWeaponName )
{
	if( IsAI( self ) )
		self gun_remove();
	else
	{
		size = self getattachsize();
		for ( i = 0; i < size; i++ )
		{
			model = self getattachmodelname( i );
			tag = self GetAttachTagName( i );
			if ( isdefined( optionalWeaponName ) )
			{
				if ( model == optionalWeaponName )
					self detach( model, tag );
			}
			else
			{
				if ( issubstr( tolower( model ), "weapon_" ) )
					self detach( model, tag );
			}
		}
	}
}
