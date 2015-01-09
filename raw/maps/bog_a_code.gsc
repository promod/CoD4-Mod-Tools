#include maps\_utility;
#include maps\_vehicle;
#include common_scripts\utility;
#include maps\_anim;
#include maps\bog_a;
#include animscripts\utility;

start_court()
{	
	level.player setOrigin ( getnode( "start_leaving_apartment", "targetname" ).origin );
}

start_melee()
{
	ai = getaiarray( "axis" );
	array_thread( ai, ::delete_me );
	thread melee_sequence();
	level.player setplayerangles( ( 0, 240, 0) );
	level.player setorigin( ( 10181.9, 708.265, 100.567 ) );
}

start_breach()
{
	flag_set( "second_floor_door_breach_initiated" );
	ai = getaiarray( "axis" );
	array_thread( ai, ::delete_me );
	thread melee_sequence();
	level.player setplayerangles( ( 0, 180, 0) );
	level.player setorigin( ( 9976.2, 423.6, 236 ) );
	
	thread second_floor_door_breach_setup();
	for ( ;; )
	{
		second_floor_door_breach_trigger = getent( "second_floor_door_breach_trigger", "script_noteworthy" );
		second_floor_door_breach_trigger notify( "trigger" );
		wait( 1 );
	}
	
}

second_floor_door_breach_setup()
{
	for( ;; )
	{
		second_floor_door_breach_guys( true );
		door = getent( "apartment_second_floor_door_breach", "targetname" );
		door connectPaths();
		door door_opens(-1);
	}
}

start_apart()
{
	/*
	thread friendlies_arrange_in_hallway_of_apartment();

	red = getent( "red_friendly", "targetname" );
	green = getent( "green_friendly", "targetname" );

	red teleport( ( 10273, 808, 105 ) );
	green teleport( ( 10279, 877, 94 ) );

	node = getnode( "friendly_destination_node", "targetname" );
	red setgoalnode( node );
	green setgoalnode( node );
	red.goalradius = node.radius;
	green.goalradius = node.radius;
			
	level.player setplayerangles( ( 0, 240, 0) );
	level.player setorigin( ( 10381, 870, 102 ) );
	*/
	thread melee_sequence();
	level.player setplayerangles( ( 0, 240, 0) );
	level.player setorigin( ( 10181.9, 708.265, 100.567 ) );
}

spawn_guys_that_run_away( msg )
{
	spawners = getentarray( msg, "targetname" );
	array_thread( spawners, ::spawn_guy_that_runs_away );
}

spawn_guy_that_runs_away()
{
	self.count = 1;
	spawn = self spawn_ai();
	if ( spawn_failed( spawn ) )
		return;
			
	spawn endon( "death" );
	defaultDist = spawn.pathEnemyFightDist;
	spawn.pathEnemyFightDist = 0;
	spawn waittill( "goal" );
	spawn.pathEnemyFightDist = defaultDist;
}

delayed_spawn_and_kill( msg, timer )
{
	wait( timer );
	spawner = getent( msg, "targetname" );
	spawn = spawner spawn_ai();
	if ( spawn_failed( spawn ) )
		return;

	spawn dodamage( spawn.health + 50, ( 0,0,0 ) );	
}

ai_walk_trigger()
{
	for ( ;; )
	{
		self waittill( "trigger", other );
		if ( other.team == "axis" )
			return;
			
		other cqb_walk( "on" );
		
		if ( !flag( "night_vision" ) )
		{		
			flag_set( "night_vision" );
			
			green = getent( "green_friendly", "targetname" );
			// <Cpl Black> Switching to night vision" );
			green anim_single_solo( green, "night_vision" );
		}
	}
}

friendlies_wait_for_ambush_then_fight_back()
{
	self endon( "death" );
	self.pacifist = true;
	self.goalheight = 48;
//	self.pathenemylookahead = 100;
//	self.pathenemyfightdist = 100;
	flag_wait( "friendlies_take_fire" );
	self.pacifist = false;
}

rooftop_damage_trigger()
{
	trigger = getent( "rooftop_damage_trigger", "targetname" );
	trigger waittill( "trigger" );
	trigger delete();
	flag_set( "rooftop_guys_fall_back" );
}

bridge_truck_pauses_then_leaves()
{
	truck = spawn_vehicle_from_targetname( "bridge_truck_pause" );
	truck drives();
	getvehiclenode( "bridge_pause_node", "script_noteworthy" ) waittill( "trigger" );
	truck setspeed( 0, 12 );
	wait( 10 );
	truck setspeed( 25, 10 );
}


bridge_damage_trigger()
{
	trigger = getent( "bridge_damage_trigger", "targetname" );
	for ( ;; )
	{
		trigger waittill( "trigger", other );
		if ( other == level.player )
			break;
			
		if ( !isdefined( other.team ) )
		{
			println( "Other was " + other.classname );
			continue;
		}
		
		if ( other.team == "axis" )
			flag_set( "bridge_walkers_attack" );
	}
	
	flag_set( "bridge_damage_trigger" );
}

bridge_runners()
{
	wait( 3 );
	spawn = self spawn_ai();
	if ( spawn_failed( spawn ) )
		return;
		
	spawn endon( "death" );
		
	node = getnode( spawn.target, "targetname" );
	spawn setgoalnode( node );
	spawn.interval = 0;
	spawn.ignoresuppression = true;
	spawn.goalradius = 64;
	
	spawn waittill( "goal" );
	if ( level.bridge_damage_trigger == "cleared" )
	{
		level.bridge_damage_trigger = "set";
		thread bridge_damage_trigger();
	}
	
	wait_for_flag_or_timeout( "bridge_damage_trigger", 13 );
	flag_set( "bridge_runners_flee" );
	waitSpread( 1, 5 );

	node = getnode( "early_bridge_node", "targetname" );
	spawn setgoalnode( node );
}

bridge_truck_drives( msg )
{
	maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( msg );
}

vehicle_delete_trigger()
{
	level endon( "player_enters_laundrymat" );
	trigger = getent( "vehicle_delete_trigger", "targetname" );
	for (;;)
	{
		trigger waittill( "trigger", other );
		other delete();
	}
}

bad_infantry_attack()
{
	level.bad_infantry_count = 0;
	array = getentarray( "tank_killing_guy", "targetname" );
//	array_thread( array, ::bad_infantry_spawner );
}

bad_infantry_spawner()
{
	self endon( "death" );
	for ( ;; )
	{
		wait( randomfloatrange( 1, 2 ) );
		if ( level.bad_infantry_count >= 10 )
		{
			level waittill( "bad_infantry_died" );
			continue;
		}
		
		self.count = 1;
		spawn = self stalingradSpawn(); // on a bridge where their heads might be visible or some such
		
		if ( spawn_failed( spawn ) )
			continue;
			
		spawn thread bad_infantry_think();
	}
}

bad_infantry_think()
{
	level.bad_infantry_count++;
	node = getnode( "tank_kill_node", "targetname" );
	if ( isalive( level.goodTank ) )
		self setEntityTarget( level.goodTank );
		
	self setgoalnode( node );
	self.goalradius = 384;
	thread bad_infantry_reaches_goal_and_deletes();
	self waittill( "death" );	

	level.bad_infantry_count--;
	level notify( "bad_infantry_died" );
}

bad_infantry_reaches_goal_and_deletes()
{
	self endon( "death" );
	self waittill( "goal" );
	self delete();
}

stop_at_node( msg )
{
	self notify( "new_stop_node" );
	thread stop_at_node_thread( msg );
}

stop_at_node_thread( msg )
{
	self endon( "new_stop_node" );
	self endon( "death" );
	getvehiclenode( msg, "script_noteworthy" ) waittill ("trigger");	
	self setSpeed(0, 100);
}

opens_fire()
{
	thread open_fire_thread();
}

open_fire_thread()
{
	assertEx( isalive( self.current_target ), "Told tank to target a dead or non existant target" );
	self endon( "death" );
	self endon( "stop_firing" );
	self.current_target endon( "death" );
	
	for ( ;; )
	{
		self fireWeapon();
		wait ( randomfloatrange( 5, 12 ) );
	}
}

stop_firing_when_target_dies()
{
	thread stop_firing_when_target_dies_thread();
}

stop_firing_when_target_dies_thread()
{
	self.current_target waittill( "death" );
	stops_firing();
}

stops_firing()
{
	self notify( "stop_firing" );
}

targets_tank( tank )
{
	thread targets_tank_thread( tank );
}

targets_tank_thread( tank )
{
	wait( 0.11 );
	self setTurretTargetEnt( tank, (0,0,60) );
	self.current_target = tank;
}

becomes_vulnerable()
{
	self godOff();
	self.health = 1;
}

drives()
{
	thread goPath( self );
}

heli_riders_spawn_and_delete()
{
	self waittill( "spawned", spawn );
	if ( spawn_failed( spawn ) )
		return;
		
	spawn endon( "death" );
	level waittill( "heli_gone" );
	spawn delete();
}

heli_guys_run_in()
{
	wait( 3 );
	spawners = getentarray( "heli_squad_spawner", "targetname" );
	for ( i=0; i<spawners.size; i++ )
	{
		spawn = spawners[ i ] spawn_ai();
		if ( spawn_failed( spawn ) )
			continue;
			
		spawn.goalradius = 200;
		spawn setGoalPos( ( 8131.3, 2652.8, 87.8 ) );
	}
}

helicopter_drops_off_guys()
{
//	getent( "guy", "targetname" ) thread testguy();
	heli_squad = getentarray( "heli_squad", "targetname" );
	array_thread( heli_squad, ::heli_riders_spawn_and_delete );
	dest = getent( "heli_path", "targetname" );
//	heli = spawnVehicle( "vehicle_blackhawk", "helicopter", "blackhawk", dest.origin, dest.angles );
	heli = spawn_vehicle_from_targetname( "heli" );
	heli.health = 10000000;
	
	heli setSpeed( 150, 35, 35 );
	heli setneargoalnotifydist( 500 );

	for ( ;; )
	{
		if ( !isdefined( dest.target ) )
			break;
		dest = getent( dest.target, "targetname" );
		heli setgoalyaw( dest.angles[ 1 ] );
		heli setVehGoalPos( dest.origin, true );
		while ( distance( heli.origin, dest.origin ) >= 500 )
			wait( 0.05 );
	}

	heli setneargoalnotifydist( 50 );
	heli waittill( "near_goal" );

	heli notify( "unload" );
	wait( 8 );

	thread heli_guys_run_in();
	heli setSpeed( 50, 15, 15 );

	heli setneargoalnotifydist( 500 );
	dest = getent( "heli_retreat_path", "targetname" );

 	for ( ;; )
	{
		heli setVehGoalPos( dest.origin, true );
		while ( distance( heli.origin, dest.origin ) >= 500 )
			wait( 0.05 );

		heli setSpeed( 150, 25, 15 );

		if ( !isdefined( dest.target ) )
			break;
		dest = getent( dest.target, "targetname" );
		heli setgoalyaw( dest.angles[ 1 ] );
	}
	
	heli delete();
	level notify( "heli_gone" );
}


draw_dest_line( org )
{
	self notify( "new_dest_line" );	
	self endon( "new_dest_line" );	
	
	for ( ;; )
	{
		line( self.origin, org, (1,1,0) );
		wait( 0.05 );
	}
}


helicopter_flies_by_overhead( name, delay, maxspeed, accel )
{
	if ( isdefined( delay ) )
		wait( delay );
	heli = spawn_vehicle_from_targetname( name );
	heli heli_flies( maxspeed, accel);
}

helicopters_flies_by_overhead( name, delay, maxspeed, accel )
{
	if ( isdefined( delay ) )
		wait( delay );
	helis = spawn_vehicles_from_targetname( name );
	assertEx( helis.size > 1, "Tried to spawn multiple helicopters with the plural command, use helicopter_flies_by_overhead" );
	helis = array_randomize( helis );
	remove = 3;
	for ( i=0; i < helis.size - remove; i++ )
	{
		helis[ i ] thread heli_flies( maxspeed, accel );
	}
	for ( i=helis.size - remove; i < helis.size; i++ )
	{
		helis[ i ] delete();
	}
}

heli_flies( maxspeed, accel )
{
	self endon( "death" );
	self.script_turretmg = false;
	self.health = 10000000;
	self setTurningAbility( 1 );
	self helipath( self.target, maxspeed, accel );
	self delete();
}

lookatpath( msg )
{
	viewTarget = getent( msg, "targetname" );
	self setLookAtEnt( viewTarget );
	wait( 1.5 );
}


aim_trigger_think()
{
	ai = [];
	for ( ;; )
	{
		self waittill( "trigger", other );
		if ( isdefined( ai[ other.ai_number ] ) )
			continue;
			
		ai[ other.ai_number ] = true;
		thread aimsAtSelf( other );
	}
}

aimsAtSelf( ent )
{
	targ = getent( self.target, "targetname" );
	ent endon( "death" );
	
	ent cqb_aim( targ );
	while ( ent istouching( self ) )
	{
		wait( 0.05 );
		continue;
	}
	
	ent cqb_aim();
//	iprintlnbold( "Room clear!" );
}

acquire_ai()
{
	// grab ai that touch the trigger and thread off the death notify
	
	ai = [];
	for ( ;; )
	{
		self waittill( "trigger", other );
		if ( isdefined( ai[ other.ai_number ] ) )
			continue;
		
		ai[ other.ai_number ] = true;
		other thread ai_tells_trigger_he_died( self );
	}
}

ai_tells_trigger_he_died( trigger )
{
	self waittill( "death" );
	if ( self isTouching( trigger ) )
	{
		trigger.deaths++;
		trigger notify( "died" );
	}
}

street_guys_run_for_it()
{
	self endon( "death");
	
	node = getnode( self.target, "targetname" );
	self setgoalnode( node );
	self.goalradius = 32;
	self.ignoresuppression = true;
	self setThreatBiasGroup( "street_guys" );
		
	flag_wait( "street_guys_run" );
	
	waitSpread( 0, 3 );
	
	for ( ;; )
	{
		self waittill( "goal" );
		if ( !isdefined( node.target ) )
			break;
		
		node = getnode( node.target, "targetname" );
		self setgoalnode( node );
	}
	
	if ( !( self cansee( level.player ) ) )
	{
		// poof!
		self delete();
	}
}

ai_enters_apartment( nodename )
{
	level.apartment_reach++;
	node = getnode( "right_house_node", "targetname" );
	waitSpread( 0.01, 2.5 );
	self setgoalnode( node );
	self.ignoresuppression = true;
	self.goalradius = 32;
	self waittill( "goal" );
	node = getnode( node.target, "targetname" );
	self setgoalnode( node );
	self waittill( "goal" );

	node = getnode( nodename, "targetname" );
	self setgoalnode( node );
	self waittill( "goal" );
	self.ignoresuppression = false;
	level.apartment_reach--;
	
	if ( !level.apartment_reach )
		flag_set( "reached_apartment" );
	
}

door_opens( mod )
{
	self playsound ("wood_door_kick");
	rotation = -140;
	if ( isdefined( mod ) )
		rotation *= mod;
	self rotateyaw( rotation, .3, 0, .3);
	self connectpaths();
}

wave()
{
	thread waveProc();
}

waveProc()
{
	self notify( "do_a_wave" );
	self endon( "do_a_wave" );
	self setflaggedanimrestart( "wave", level.scr_anim[ self.animname ][ "wave" ], 1, .1, 1 );
//	thread notetrackprinter( "wave" );
//	self waittillend( "wave" );
	wait( 3 );
	self clearanim( level.scr_anim[ self.animname ][ "wave" ], 0.1 );
}

notetrackprinter( msg )
{
	self endon( "death" );
	self notify( "notetrackprinter" + msg );
	self endon( "notetrackprinter" + msg );
	for ( ;; )
	{
		self waittill( msg, notetrack );
		println( "Recieved " + msg + " notetrack: " + notetrack );
	}
}

target_spot_delayed( org, timer )
{
	self endon( "death" );
	wait( timer );
	self cqb_aim( org );
}

melee_sequence()
{

	// first setup all the entities. Notice they all originate from one entree point in the map!
	trigger = getent( "start_melee", "targetname" );
	sequence_trigger = getent( trigger.target, "targetname" );
	friendly_spawner = getent( sequence_trigger.target, "targetname" );
	friendly_spawner.script_moveoverride = true;
	
	enemy_spawner = getent( "melee_enemy_spawner", "targetname" );
	enemy_spawner.script_moveoverride = true;

	start_node = getnode( friendly_spawner.target, "targetname" );
	player_break_trigger = getent( "player_breaks_melee_sequence", "targetname" );
		
	ai_trigger = getent( "melee_ai_trigger", "targetname" );
	
	end_node = getnode( enemy_spawner.target, "targetname" );

//	wall_blocker = getent( trigger.script_linkto, "script_linkname" );

//	wall_blocker connectPaths();
//	wall_blocker notsolid();
//	spawn_blocker disconnectPaths();

	
	trigger waittill( "trigger" );

	// spawn a wall in so ai dont run through here during melee sequence
//	wall_blocker disConnectPaths();
//	wall_blocker solid();

		
	friendly = friendly_spawner spawn_ai();
	if ( spawn_failed( friendly ) )
	{
		assertEx( 0, "key friendly failed to spawn" );
		return;
	}
	friendly.ignoreall = true;
	friendly.ignoreme = true;
	friendly.pathenemyfightdist = 0;
	friendly.pathenemylookahead = 0;
	friendly.goalheight = 64; // don't go running upstairs buddy!
	friendly.goalradius = 32;
	friendly.IgnoreRandomBulletDamage = true;
	
	enemy = enemy_spawner spawn_ai();
	if ( spawn_failed( enemy ) )
	{
		assertEx( 0, "key enemy failed to spawn" );
		return;
	}
	enemy.ignoreme = true;
	enemy.goalradius = 32;
	enemy.health = 1;
	enemy pushplayer( true );
	enemy.dontavoidplayer = true;
	enemy setthreatbiasgroup( "melee_struggle_guy" );  // so he doesnt ignore the player when the player is inside
	enemy thread achievement( friendly );

	sequence_trigger waittill( "trigger" );
	if ( level.start_point != "melee" )
		assertEx( flag( "friendlies_lead_player" ), "Friendlies were not told to lead the player soon enough." );
	flag_set( "melee_sequence_begins" );
	
	autosave_by_name( "melee_sequence" );
//	clear_player_threatbias_vs_apartment_enemies_and_autosave();

//	wall_blocker connectPaths();
//	wall_blocker delete();
	
	friendly setgoalnode( end_node );
	friendly.dontshootstraight = true;
	friendly.goalradius = 4;
	
	
	ai_trigger waittill( "trigger", other );
	
	if ( other == friendly && !flag( "player_interupts_melee_struggle" ) )
	{
		friendly.IgnoreRandomBulletDamage = false;
		// if the player hits the trigger then abort the sequence
		melee_sequence_plays_out( friendly, enemy );
		if ( isdefined( friendly ) )
		{
			friendly playsound( "bog_scn_melee_struggle_end" );
		}
		if ( isalive( enemy ) && !( enemy canSee( level.player ) ) )
		{
			// player ran past sequence so just kill the enemy
			enemy dodamage( enemy.health + 50, (0,0,0) );
		}
	}
	else
	{
		if ( isalive( friendly ) )
			friendly.dontshootstraight = false;
	}
	
	if ( isalive( enemy ) )
	{
		enemy.deathanim = undefined;
		enemy.ignoreme = false;
//		enemy animscripts\shared::placeWeaponOn( enemy.primaryweapon, "right" );
		// in case you killed the friendly and the enemy is still playing the sequence
		enemy stopAnimScripted();
	}
	
	/#
	if ( !is_default_start() )
		return;
	#/

	if ( isalive( friendly ) )
	{		
		level.saved_friendly = friendly;
		level.saved_friendly thread magic_bullet_shield();
		friendly setThreatbiasGroup( "friendlies_under_unreachable_enemies" );
		friendly set_default_pathenemy_settings();
		friendly set_force_color( "p" );
		friendly.a.nodeath = false;
		friendly.ignoreall = false;
		friendly.IgnoreRandomBulletDamage = false;
		friendly.ignoreSuppression = true;
	}
	else
	{
		instantly_promote_nearest_friendly( "b", "p" );
	}

	flag_set( "melee_sequence_complete" );
}

achievement( friendly )
{
	self waittill( "death", attacker );
	if ( !isalive( friendly ) )
		return;
		
	if ( !isalive( attacker ) )
		return;
	
	if ( attacker != level.player )
		return;

	maps\_utility::giveachievement_wrapper( "RESCUE_ROYCEWICZ" );			
}

melee_sequence_plays_out( friendly, enemy )
{
	level endon( "stop_melee_sequence" );
	if ( !isalive( friendly ) )
		return;
	if ( !isalive( enemy ) )
		return;

	friendly endon( "death" );
	enemy endon( "death" );
	
	friendly.animName = "paulsen";
	enemy.animName = "emslie";
	enemy.deathanim = enemy getanim( "death" );

	animArray = [];
	animArray[ 0 ] = friendly;
	animArray[ 1 ] = enemy;

// now in notetrack so you cant kill him earlier and have him keep playing the normal anim
//	friendly.a.nodeath = true;
	
	//node = getent( "melee_root", "targetname" );
	animbase = spawn( "script_origin", (0,0,0) );
//	animbase.angles = friendly.angles + (0, 110, 0);
//	animbase.origin = friendly.origin + (0,0,0);
	animbase.origin = ( 9705, 1207, 112 );
	animbase.angles = ( 0, 294, 0 );
	
//	println("animbase origin " + animbase.origin + " and angles " + animbase.angles );

//	defender teleport( node.origin );
//	attacker teleport( node.origin );

	friendly.allowDeath = true;
	enemy.allowDeath = true;

	friendly.end_melee_animation = "stand_death";
	friendly thread saved_from_melee( enemy );
	friendly.health = 1;
	// gah!
	friendly thread anim_single_solo( friendly, "gah" );
	animbase anim_single( animArray, "melee" );
}

paulsen_end_standDeath( guy )
{
	// called from a notetrack
	guy.end_melee_animation = undefined;
}

paulsen_start_backDeath1( guy )
{
	// called from a notetrack
	guy.end_melee_animation = "back_death1";
	guy.a.nodeath = true;
	guy notify( "new_end_melee_animation" );
}

paulsen_start_backDeath2( guy )
{
	// called from a notetrack
	guy.end_melee_animation = "back_death2";
	guy.a.nodeath = true;
	guy notify( "new_end_melee_animation" );
}

paulsen_end_fire( guy )
{
	guy.a.lastShootTime = gettime();
	guy thread play_sound_on_tag( "weap_m4carbine_fire_npc", "tag_flash" );
	
	PlayFXOnTag( getfx( "special_fire" ), guy, "tag_flash" );

	angles = guy gettagangles( "tag_flash" );
	forward = anglestoforward( angles );
	vec = vectorscale( forward, 5000 );
	start = guy gettagorigin( "tag_flash" );
	end = start + vec;
	trace = bullettrace( start, end, false, undefined );
	
	playfx( getfx( "flesh_hit" ), trace[ "position" ], ( 0, 0, 1 ) );
	thread play_sound_in_space( "bullet_large_flesh", trace[ "position" ] );

	pos = trace[ "position" ];
	forward = anglestoforward( ( 0, self.angles[ 1 ], 0 ) );
	vec = vectorscale( forward, -5 );
	pos = pos + vec;
	trace = bullettrace( pos + (0,0,5), pos + (0,0,-50 ), false, undefined );
	playfx( getfx( "blood_pool" ), trace[ "position" ], ( 0, 0, 1 ) );
	
}


orient_to_guy( enemy )
{
	self endon( "stop_orienting" );
	org = enemy.origin;
	for ( ;; )
	{
		if ( isdefined( enemy ) && isdefined( enemy.origin ) )
		{
			org = enemy.origin;
		}

		angles = vectortoangles( org - self.origin );
		yaw = angles[ 1 ] - 20;
		self OrientMode( "face angle", yaw );
		wait( 0.05 );
	}
}

saved_from_melee( enemy )
{
	self endon( "death" );
	enemy waittill( "death" );
	org = enemy.origin;
	if ( !isdefined( self.end_melee_animation ) )
		self waittill( "new_end_melee_animation" );	
	if ( self.end_melee_animation == "stand_death" )
	{
		self thread anim_custom_animmode_solo( self, "gravity", self.end_melee_animation );

		self thread orient_to_guy( enemy );
	}
	else
	{
		self thread anim_single_solo( self, self.end_melee_animation );
	}
	self waittill_either( self.end_melee_animation, "damage" );
	self notify( "stop_orienting" );
	self.dontshootstraight = false;
}

/*
friendly_rejoins_party()
{
	level.saved_friendly = self;
	node = getnode( "friendly_saved_node", "targetname" );
	self setgoalnode( node );
	self.health = 150;

	self endon( "death" );
	wait( 1.2 );
	self anim_single_solo( self, "thanks_carver" );
}
*/

threatbias_lower_trigger()
{
	self endon( "death" );
	for ( ;; )
	{
		self waittill( "trigger", other );
		assertEx( other == level.player, "Threatbias triggers should only be used on the player." );
		if ( !isdefined( other.normal_threatbias ) )
		{
			other.normal_threatbias = other.threatbias;
		}
		else
		{
			// does this guy already have this threatbias lowered?
			if ( other.normal_threatbias != other.threatbias )
				continue;
		}
			
		other.threatbias -= 1500;
		wait( 2 );
	}
}

threatbias_normal_trigger()
{
	self endon( "death" );
	for ( ;; )
	{
		self waittill( "trigger", other );
		assertEx( other == level.player, "Threatbias triggers should only be used on the player." );
		if ( !isdefined( other.normal_threatbias ) )
			continue;
			
		other.threatbias = other.normal_threatbias;
		wait( 2 );
	}
}


/*
spawn_from_targetname( targetname, optional_func )
{
	spawners = getentarray( targetname, "targetname" );
	has_optional_func = isdefined( optional_func );
	for ( i=0; i < spawners.size; i++ )
	{
		spawn = spawners[ i ] spawn_ai();
		if ( spawn_failed( spawn ) )
			continue;
		if ( has_optional_func )
			spawn [[ optional_func ]]();
	}
}
*/

spawn_guy_from_targetname( targetname )
{
	guy = spawn_guys_from_targetname( targetname );
	assertEx( guy.size == 1, "Tried to spawn a single guy from spawner with targetname " + targetname + " but it had multiple guys." );
	assertEx( isalive( guy[ 0 ] ), "Failed to spawn a required guy from targetname " + targetname );
	return guy[ 0 ];
}

spawn_guys_from_targetname( targetname )
{
	guys = [];
	spawners = getentarray( targetname, "targetname" );
	for ( i=0; i < spawners.size; i++ )
	{
		spawner = spawners[i];
		spawner.count = 1;
		guy = spawner spawn_ai();
		spawn_failed( guy );
		assertEx( isalive( guy ), "Guy from spawner with targetname " + targetname + " at origin " + spawner.origin + " failed to spawn" );
		
		guys[ guys.size ] = guy;
	}
	
	return guys;
}

force_spawn_guys_from_targetname( targetname )
{
	guys = [];
	spawners = getentarray( targetname, "targetname" );
	for ( i=0; i < spawners.size; i++ )
	{
		spawner = spawners[i];
		spawner.count = 1;
		guy = spawner stalingradspawn();
		spawn_failed( guy );
		assertEx( isalive( guy ), "Guy from spawner with targetname " + targetname + " at origin " + spawner.origin + " failed to spawn" );
		
		guys[ guys.size ] = guy;
	}
	
	return guys;
}


vis_blocker_waits_for_deletion()
{
	
	vis_blocker_delete_trigger = getent( "vis_blocker_delete_trigger", "targetname" );
	vis_blocker_delete_trigger waittill( "trigger" );
	
	vis_blocker = getent( "vis_blocking_brush", "targetname" );
	vis_blocker delete();
}
	
/*
friendly_ignore_upstairs_guys_trigger()
{
	self endon( "death" );
	for ( ;; )
	{
		self waittill( "trigger", other );
		assertEx( isalive( other ), "Dead guy triggered a trigger! Nos!" );
		other setThreatBiasGroup( "friendlies_under_unreachable_enemies" );
	}
}
	
friendly_can_attack_upstairs_guys_trigger()
{
	self endon( "death" );
	for ( ;; )
	{
		self waittill( "trigger", other );
		assertEx( isalive( other ), "Dead guy triggered a trigger! Nos!" );
		other setThreatBiasGroup( "allies" );
	}
}
*/

enable_pacifists_to_attack_me()
{
	self endon( "death" );
	for ( ;; )
	{
		self waittill( "trigger", other );
		
		if ( other == level.player )
		{
//			level.player.threatbias = -250;
			continue;
		}
		
		other setthreatbiasgroup( "friendlies_under_unreachable_enemies" );
	}
}

ignores_unreachable_enemies()
{
	self setthreatbiasgroup( "friendlies_flanking_apartment" );
	self.ignoresuppression = true; // gotta get him to go, can turn it back on later
}

set_threatbias_group( group )
{
	assert( threatbiasgroupexists( group ) );
	self setthreatbiasgroup( group );
}

wait_until_its_time_to_flank()
{
	// if the player hangs back, the friendlies will call for flanking after a few seconds, but if the player rushes
	// ahead then they will call for flanking immediately.
	trigger = getent( "moveup_trigger", "targetname" );
	force_trigger = getent( trigger.target, "targetname" );
	force_trigger wait_for_trigger_or_timeout( 10 );
}

waittill_triggered_by_ai( team )
{
	for ( ;; )
	{
		self waittill( "trigger", other );
		if ( other == level.player )
			continue;
		if ( !isdefined( team ) )
			return;
		if ( other.classname == "worldspawn" )
		{
			println( "waittill_triggered_by_ai(): hit by worldspawn: ", other.classname );
			continue;
		}
			
		if ( team == other.team )
			return;
	}
}

tally_pacifists()
{
	waittillframeend;
	ai = getaiarray();
	tally[ "axis" ] = 0;
	tally[ "allies" ] = 0;
	
	for ( i=0; i < ai.size; i++ )
	{
		guy = ai[ i ];
		
		if ( guy.pacifist )
			tally[ guy.team ]++;
	}
	
	println( tally[ "allies" ] + " pacifist friendlies of " + getaiarray( "allies" ).size + " friendlies, " + tally[ "axis" ] + " pacifist enemies of " + getaiarray( "axis" ).size + " enemies." );
}

put_function_on_spawners( spawners, function )
{
	array_thread( spawners, ::spawner_runs_function_on_spawn, function );
}

spawner_runs_function_on_spawn( function )
{
	self endon( "death" );
	for ( ;; )
	{
		self waittill( "spawned", spawn );
		if ( spawn_failed( spawn ) )
		{
			assertEx( 0, "Impossible!" );
			continue;
		}
		
		spawn [[ function ]]();
	}
}


alley_roof_guy()
{
	// runs over and shoots the player when he gets on the roof
	self endon( "death" );
	flag_wait( "player_enters_roof" );
	
	roof_nodes = getnodearray( "roof_node", "targetname" );
	roof_nodes = array_randomize( roof_nodes );
	for ( i=0; i < roof_nodes.size; i++ )
	{
		node = roof_nodes[ i ];
		if ( isdefined( node.roof_occupied ) )
			continue;

		node.roof_occupied = true;
		self setgoalnode( node );
		self.goalradius = 64;
		return;
	}
}

alley_smg_playerseeker()
{
	self setthreatbiasgroup( "player_seeker" );
	self setEngagementMinDist( randomintrange( 100, 225 ), 0 );
	
	maxdist = randomintrange( 300, 400 );
	self setEngagementMaxDist( maxdist, maxdist + 200 );
	self.pathenemyfightdist = 185;
	self.pathenemylookahead = 185;
}

alley_sniper_engagementdistance()
{
	self setEngagementMinDist( 450, 450 );
	self setEngagementMaxDist( 1500, 2500 );
}

alley_smg_engagementdistance()
{
	self setEngagementMinDist( 350, 0 );
	self setEngagementMaxDist( 450, 550 );
}

alley_close_smg_engagementdistance()
{
	self setEngagementMinDist( 0, 0 );
	self setEngagementMaxDist( 200, 300 );
}

toggle_alley_badplace()
{
	source_ent = getent( "friendly_badplace_arc", "targetname" );
	dest_ent = getent( source_ent.target, "targetname" );
	origin = source_ent.origin;
	direction = origin - dest_ent.origin;
	source_ent delete();
	dest_ent delete();
	
	for ( ;; )
	{
		flag_wait( "player_near_alley_building" );
		badplace_arc( "alley_badplace", 0, origin, 0, 64, direction, 5, 5, "allies" );
		flag_waitopen( "player_near_alley_building" );
		badplace_delete( "alley_badplace" );
	}
}

ambush_clear()
{
//	getent( "apartment_door", "targetname" ) delete();
	flag_set( "friendlies_take_fire" );
	flag_set( "respawn_friendlies" );
	pacifist_rubble_guys = getentarray( "pacifist_rubble_guys", "targetname" );
	array_delete( pacifist_rubble_guys );
}

start_bog()
{
	ambush_clear();
	
	clear_promotion_order();
	set_promotion_order( "r", "y" );

	level.respawn_spawner = getent( "auto2840", "targetname" );
	
	level.price = getent( "price", "targetname" );
	level.price teleport( ( 6782.4, 336.4, 66 ) );
	spawn_failed( level.price );
	level.price setgoalpos( level.price.origin );
	level.price.animName = "price";
	level.price thread magic_bullet_shield();
	level.price set_force_color( "y" );

	allies = getaiarray( "allies" );
	allies = array_remove( allies, level.price );
	array_delete( allies );


	friendlies = force_spawn_guys_from_targetname( "bog_friendly_start" );
	array_thread( friendlies, ::replace_on_death );
	
	level.player setplayerangles( ( 0, 241, 0) );
	level.player setorigin( ( 6872.2, 547.4, 93	 ) );

	bog_is_under_attack();	
}

bog_fight_until_flag()
{
	// bog fighters are invulnerable until the player enters the bog.
	self thread magic_bullet_shield();
	flag_wait( "entered_bog" );
	stop_magic_bullet_shield();
}

bog_is_under_attack()
{
	initial_bog_fighters = getentarray( "initial_bog_fighters", "targetname" );
	array_thread( initial_bog_fighters, ::add_spawn_function, ::bog_fight_until_flag );
}

start_alley()
{
	ambush_clear();

	level.respawn_spawner = getent( "alley_respawn", "targetname" );

	level.price = getent( "price", "targetname" );
	level.price teleport( ( 9695.2, 372.3, 76 ) );
	level.price.animName = "price";
	level.price thread magic_bullet_shield();
	level.price set_force_color( "c" );
	level.price make_hero();

	allies = getaiarray( "allies" );
	allies = remove_heroes_from_array( allies );
	array_delete( allies );

	friendlies = force_spawn_guys_from_targetname( "alley_friendly_spawners" );
	friendlies = remove_color_from_array( friendlies, "g" );
	array_thread( friendlies, ::replace_on_death );

	level.player setplayerangles( ( 0, 255, 0) );
	level.player setorigin( ( 9838.94, 960.646, 76 ) );
	thread open_laundrymat();
	flag_set( "alley_enemies_spawn" );
/*
	activate_trigger_with_targetname( "alley_friendly_trigger" );
	friendly = get_closest_colored_friendly( "y" );
	thread laundryroom_saw_gunner();
	flag_set( "player_enters_laundrymat" );
	flag_set( "laundry_room_price_talks_to_hq" );
	player_enters_laundrymat();
*/
}

start_javelin()
{
	ambush_clear();
	clear_promotion_order();
	set_promotion_order( "r", "y" );
	
	level.respawn_spawner = getent( "alley_respawn", "targetname" );
	

	level.price = getent( "price", "targetname" );
	level.price teleport( ( 8812.1, -557.4, 212 ) );
	level.price.animName = "price";
	level.price thread magic_bullet_shield();
	level.price set_force_color( "y" );

	getent( "playerseeker_spawn_trigger", "script_noteworthy" ) delete();
	level.player setplayerangles( ( 0, 255, 0) );
	level.player setorigin( ( 8636.5, -578.8, 190.9 ) );

	allies = getaiarray( "allies" );
	allies = array_remove( allies, level.price );
	array_delete( allies );

	friendlies = force_spawn_guys_from_targetname( "start_alley_spawn" );
	array_thread( friendlies, ::replace_on_death );
	promote_nearest_friendly( "y", "r" );

	defend_the_roof_with_javelin();
}

announce_backblast()
{
	level endon( "bmps_are_dead" );
	flag_assert( "bmps_are_dead" );
	
	for ( ;; )
	{
		while( !player_fires_javelin() )
		{
			wait( 0.05 );
		}
		
		wait( 1.5 );
		// Backblast area clear! Fire!
		level.javelin_helper thread anim_single_queue( level.javelin_helper, "backblast_clear" );
	}
}

set_flag_when_bmps_are_dead()
{
	ent = spawnstruct();
	ent.count = 0;
	level.bmps_killed_by_player = 0;
	for ( i=1; i<=4; i++ )
	{
		thread bridge_bmp_rolls_in( "bridge_bmp" + i, ent );
	}
	ent waittill( "bmps_are_dead" );
	flag_set( "bmps_are_dead" );
}

bmps_target_stuff_until_they_flee()
{
	level endon( "overpass_baddies_flee" );
	flag_assert( "overpass_baddies_flee" );

	for ( ;; )
	{
		// tank fires at targets based on their distance to the player, getting closer and closer until they nail the player
		targets = getentarray( "new_bmp_target", "targetname" );
		target = random( targets );
		/*
		target = level.player;
		if ( targets.size )
		{
			target = getFarthest( level.player.origin, targets );
			target.targetname = undefined;
		}
		*/
		
		self setTurretTargetEnt( target );
		wait( randomfloatrange( 2, 3 ) );
		self fireWeapon();
		wait ( randomfloatrange( 3, 5 ) );
	}	
}

bmp_drives_for_awhile()
{
	self endon( "death" );
	self drives();
	
//	self waittillmatch( "noteworthy", "stop_node" );
	vehicle_flag_arrived( "bmp_in_position" );
	self setspeed( 0, 925 );

	if ( !flag( "overpass_baddies_flee" ) )
		bmps_target_stuff_until_they_flee();

	flag_wait( "overpass_baddies_flee" );
	self setspeed( 15, 2 );
}

bridge_bmp_is_shot_at()
{
	self endon( "death" );
	for ( ;; )
	{
		if ( !isalive( self ) )
		{
			break;
		}

		oldHealth = self.health;
		self waittill( "damage", dmg, attacker, one, two, weapType );
		if ( isdefined( attacker.classname ) && attacker != level.player )
		{
			self.health = oldHealth;
			continue;
		}
		
		if ( weapType != "MOD_PROJECTILE" )
			continue;

		if ( dmg < 800 )
			continue;
//		if ( !player_has_javelin() )
//			continue;
		
		level.bmps_killed_by_player++;
		arcadeMode_kill( self.origin, "explosive", 500 );
		
		// Target destroyed!				"hit_target_1"
		// Nice one!						"hit_target_2"
		// Good shot man!					"hit_target_3"
		// Ok that’s the last of ‘em.		"hit_target_4"
//		level.javelin_helper thread anim_single_queue( level.javelin_helper, "hit_target_" + level.bmps_killed_by_player );
		level.javelin_helper delaythread( 1, ::anim_single_queue, level.javelin_helper, "hit_target_" + level.bmps_killed_by_player );

		self godoff();
		radiusdamage( self.origin, 150, self.health + 500, self.health + 500 );
	}
}

bridge_bmp_rolls_in( name, ent )
{
	ent.count++;
//	waitSpread( 0, 9 );
	bmp = spawn_vehicle_from_targetname( name );
	
	OFFSET = ( 0, 0, 60 );
	target_set( bmp, OFFSET );
	target_setAttackMode( bmp, "top" );
	target_setJavelinOnly( bmp, true );
	
	bmp.health = 20000;
	bmp godon();
	bmp thread bmp_drives_for_awhile();
	bmp bridge_bmp_is_shot_at();
	flag_set( "bmp_got_killed" );

	ent.count--;
	if ( ent.count <= 2 )
	{
		flag_set( "overpass_baddies_flee" );
		ent notify( "bmps_are_dead" );
	}
	if ( ent.count <= 0 )
	{
		flag_set( "all_bmps_dead" );
	}
	
	if ( isdefined( bmp ) )
	{
		target_remove( bmp );
	}
}



/*
start_shanty()
{
	alley_clear_trigger = getent( "alley_clear_trigger", "targetname" );
	alley_clear_trigger notify( "trigger" );
	battlechatter_off( "allies" );

	getent( "apartment_door", "targetname" ) delete();
	flag_set( "friendlies_take_fire" );

	clear_promotion_order();
	set_promotion_order( "r", "y" );
	
	level.respawn_spawner = getent( "alley_respawn", "targetname" );
	
	pacifist_rubble_guys = getentarray( "pacifist_rubble_guys", "targetname" );
	array_delete( pacifist_rubble_guys );

	level.price = getent( "price", "targetname" );
	level.price teleport( ( 8812.1, -557.4, 212 ) );
	level.price.animName = "price";
	level.price thread magic_bullet_shield();
	level.price set_force_color( "y" );

	getent( "playerseeker_spawn_trigger", "script_noteworthy" ) delete();
	level.player setplayerangles( ( 0, 255, 0) );
	level.player setorigin( ( 8636.5, -578.8, 190.9 ) );

	allies = getaiarray( "allies" );
	allies = array_remove( allies, level.price );
	array_delete( allies );

	friendlies = force_spawn_guys_from_targetname( "start_alley_spawn" );
	array_thread( friendlies, ::replace_on_death );
	promote_nearest_friendly();

	defend_the_roof_with_javelin();
}
*/

wait_until_alley_is_clear_of_enemies()
{
	trigger = getent( "alley_enemy_volume", "targetname" );
	
	for ( ;; )
	{
		axis = getaiarray( "axis" );
		touching_axis = [];
		
		for ( i=0; i < axis.size; i++ )
		{
			guy = axis[ i ];
			
			if ( trigger istouching( guy ) )
				touching_axis[ touching_axis.size ] = guy;
		}
		
		if ( !touching_axis.size )
			break;
		
		ent = spawnstruct();
		
		array_thread( touching_axis, ::toucher_dies, ent );
		ent_waits_for_death_or_timeout( ent, 5 );
	}
}

ent_waits_for_death_or_timeout( ent, timeout )
{
	ent endon( "toucher_died" );
	wait( timeout );
	ent waittill( "toucher_died" );
}

toucher_dies( ent )
{
	self waittill( "death" );
	ent notify( "toucher_died" );
}

set_all_ai_ignoreme( val )
{
	ai = getaiarray();
	for ( i=0; i < ai.size; i++ )
	{
		ai[ i ].ignoreme = val;
	}
}


wait_until_mortars_are_dead()
{
	ent = spawnstruct();
	ent.count = 0;
	mortar_triggers = getentarray( "mortar_trigger", "targetname" );
	array_thread( mortar_triggers, ::mortar_trigger, ent );
	ent waittill( "mortars_complete" );
	objective_state( 5, "done" );
}

mortar_trigger( ent )
{
	ent.count++;
	self waittill( "trigger" );
	self.count = 0;
	
	spawners = getentarray( self.target, "targetname" );
	array_thread( spawners, ::add_spawn_function, ::mortar_guys, self );
	array_thread( spawners, ::spawn_ai );

	self waittill( "mortar_guys_are_dead" );
	ent.count--;
	
	if ( !ent.count )
		ent notify( "mortars_complete" );
}

mortar_guys( trigger )
{
	trigger.count++;
	self setgoalpos( self.origin );
	self.goalradius = 64;
	self waittill( "death" );
	trigger.count--;
	if ( !trigger.count )
		trigger notify( "mortar_guys_are_dead" );
}

wait_until_its_time_to_breach_the_third_floor_room( guy )
{
	while ( distance( guy.origin, level.player.origin ) > 250 )
	{
		wait( 0.05 );
		if ( level.player.origin[ 2 ] < guy.origin[ 2 ] - 32 )
		{
			// player went downstairs
			return false;
		}
	}
	return true;
}

verify_that_allies_are_undeletable()
{
	/#
	ally_spawners = getspawnerteamarray( "allies" );	

	undeleteable = [];
	for ( i=0; i < ally_spawners.size; i++ )
	{
		spawner = ally_spawners[ i ];
		if ( spawner.spawnflags & 4 )
			continue;
		undeleteable[ undeleteable.size ] = spawner.export;
	}

	if ( undeleteable.size > 0 )
	{
		for ( i=0; i < undeleteable.size; i++ )
		{
			println( "Spawner with export " + undeleteable[ i ] + " was not undeletable." );
		}
		assertEx( 0, "Friendly spawner wasnt undeletable, see prints above in console." );
	}
	#/
	
	
}

assign_the_two_closest_friendlies_to_the_player()
{
	for ( i=0; i < 2; i++ )
	{
		promote_nearest_friendly( "y", "r" );
	}
}

magic_laser_light_show()
{
	lasers = getentarray( "magic_laser", "targetname" );
	array_thread( lasers, ::magic_laser_lights );
}

magic_laser_lights()
{
	targets = getentarray( self.target, "targetname" );
	lasers = targets.size - 3;
	endTarg = getent( self.script_linkto, "script_linkname" );
	
	for ( i=0; i < lasers; i++ )
	{
		model = spawn( "script_model", (0,0,0) );
		model.origin = self.origin;
		model setmodel( "tag_laser" );
		model thread laser_targets_points( targets, "lasers_shift_fire", endTarg.origin, 0.75, 1.25 );
	}
	
	endTarg delete();
	self delete();
}


street_laser_light_show()
{
	for ( ;; )
	{
		flag_wait( "player_nears_first_building" );
		flag_clear( "stop_street_lasers" );
		lasers = getentarray( "street_laser", "targetname" );
		array_thread( lasers, ::street_laser_lights );

		flag_waitopen( "player_nears_first_building" );
		flag_set( "stop_street_lasers" );
	}
}

street_laser_lights()
{
	targets = getentarray( self.target, "targetname" );
	lasers = 4;
	if ( lasers > targets.size )
		lasers = targets.size;
	
	for ( i=0; i < lasers; i++ )
	{
		model = spawn( "script_model", (0,0,0) );
		model.origin = self.origin;
		model setmodel( "tag_laser" );
		model thread laser_targets_points( targets, "stop_street_lasers", undefined, 0.15, 0.9 );
	}
}

laser_targets_points( targets, endFlag, endOrg, minspeed, maxspeed )
{
	dest = spawn( "script_origin", (0,0,0) );
	thread draw_laser_line( dest );
	target = undefined;
	orgSet = false;
	lastNum = -1;
	while ( !flag( endFlag ) )
	{
		// get an unused target
		num = randomint( targets.size );
		for ( ;; )
		{
			target = targets[ num ];
			if ( num!= lastNum && !isdefined( target.used ) )
			{
				lastNum = num;
				break;
			}
			num++;
			if ( num >= targets.size )
				num = 0;
		}
		
		assert( !isdefined( target.used ) );
		if ( !orgSet )
		{
			dest.origin = target.origin;
			orgset = true;
		}
		else
		{
			movetime = distance( dest.origin, target.origin ) * 0.015;
			movetime *= randomfloatrange( minspeed, maxspeed );
			dest moveto( target.origin, movetime, movetime * 0.3, movetime * 0.3 );
			laser_waits( endFlag, movetime );
		}
		
		dest thread laser_jitters();
		laser_waits( endFlag, randomfloatrange( 1, 5 ) );
		dest notify( "stop_jitter" );
		target.used = undefined;
	}
	
	dest thread laser_jitters();
	waitSpread( 2 );
	dest notify( "stop_jitter" );
	
	if ( isdefined( endOrg ) )
	{
		endOrg = endOrg + randomVector( 25 );
		endOrg = ( endOrg[ 0 ], endOrg[ 1 ], dest.origin[ 2 ] );
		movetime = distance( dest.origin, endOrg ) * 0.002;
		movetime *= randomfloatrange( minspeed, maxspeed );
		
		dest moveto( endOrg, movetime, movetime * 0.3, movetime * 0.3 );
		wait( moveTime );
	}
	else
	{
		// so lasers dont all turn off simultaneously
		wait( randomfloat( 0.1, 0.35 ) );
	}
	self notify( "stop_line" );
	self laserOff();
	dest delete();
	self delete();
}

laser_waits( endFlag, timer )
{
	if ( flag( endFlag ) )
		return;
	level endon( endFlag );
	wait( timer );
}

laser_jitters()
{
	self endon( "stop_jitter" );
	org = self.origin;
	
	for ( ;; )
	{
		neworg = org + randomvector( 3 );
		movetime = randomfloatrange( 0.05, 0.2 );
		self moveto( neworg, movetime );
		wait( movetime );
	}
}

modulate_laser()
{
	self.dolaser = false;
	self endon( "stop_line" );
	for ( ;; )
	{
		flag_wait( "nightvision_on" );
		self.dolaser = true;
		self laserOn();
		flag_waitopen( "nightvision_on" );
		self.dolaser = false;
		self laserOff();
	}
}


get_laser()
{
	model = spawn( "script_model", (0,0,0) );
	model.origin = self.origin;
	model setmodel( "tag_laser" );
	return model;
}

draw_laser_line( dest )
{
	self endon( "stop_line" );
	thread modulate_laser();
	wait( 0.05 );
	self.angles = vectortoangles( dest.origin - self.origin );
	wait( 0.05 );
	for ( ;; )
	{
		self rotateto( vectortoangles( dest.origin - self.origin ), 0.1 );
		if ( self.dolaser )
		{
//			line( self.origin, dest.origin, (0,1,0) );
		}
		
		wait( 0.1 );
	}
}



enemies_respond_to_attack( noteworthy, group, msg )
{
	flag_clear( msg );
	enemies = getentarray( noteworthy, "script_noteworthy" );
	array_thread( enemies, ::attack_player_when_attacked, msg );

	setIgnoremeGroup( "player", group );
	flag_wait( msg );
	
	// clear the threatbias on the entities that are attacking them, so that they can fight back
	setThreatBias( "player", group, 50000 );
}

upstairs_enemies_respond_to_attack()
{
	enemies_respond_to_attack( "upper_floor_enemies", "upstairs_unreachable_enemies", "unreachable_enemies_under_attack" );
	
	if ( flag( "lasers_have_moved" ) )
	{
		setThreatBias( "player", "upstairs_unreachable_enemies", 0 );
		setThreatBias( "friendlies_under_unreachable_enemies", "upstairs_unreachable_enemies", 0 );
	}
}

window_enemies_respond_to_attack()
{
	enemies_respond_to_attack( "window_enemies", "upstairs_window_enemies", "window_enemies_under_attack" );
}

	
second_floor_laser_light_show()
{
	flag_wait( "magic_lasers_turn_on" );

	// turn the lasers on
	thread magic_laser_light_show();
	
	wait_until_its_time_to_move_lasers();
	
	// make the lasers move
	flag_set( "lasers_shift_fire" );
	wait( 2 );
	flag_set( "lasers_have_moved" );
}

attack_player_when_attacked( msg )
{
	if ( flag( msg ) )
		return;

	if ( isSpawner() )
	{
		// a spawner. Spawner should run this on guys that spawn
		self add_spawn_function( ::attack_player_when_attacked, msg );
		return;
	}
	
	level endon( msg );
	self waittill( "death", enemy );
	
	// was deleted
	if ( !isdefined( self ) )
		return;
		
	if ( enemy == level.player )
	{
		flag_set( msg );
	}
}


wait_until_its_time_to_move_lasers()
{
	// the lasers move when the dialogue elapses, time elapses (if paulsen is dead) or the player advances prematurely
	level endon( "magic_lasers_turn_off" );

	// We're on the second floor! Watch your fire!
	level.price anim_single_queue( level.price, "watch_your_fire" );
	// roger that! Shifting fire!
	radio_dialogue( "shifting_fire" );
}

set_talker()
{
	// increment the next guy to talk, based on who is alive.
	for ( ;; )
	{
		self.index++;
		if ( self.index >= self.guys.size )
			self.index = 0;
			
		if ( isalive( self.guys[ self.index ] ) )
		{
			self.talker = self.guys[ self.index ];
			return;
		}
	}
}


wait_until_player_goes_into_second_floor_or_melee_sequence_completes()
{
	level endon( "melee_sequence_complete" );
	// spawn a guy down the hall that runs out, so we notice that there's stuff at the end of the hall
	wait_for_targetname_trigger( "hint_guy_trigger" );
}


wait_then_go()
{
	self setgoalpos( self.origin );
	self.goalheight = 64;
	self.goalradius = 32;
	wait( 0.5 );
	node = getnode( self.target, "targetname" );
	self setgoalnode( node );
}
	
die_shortly()
{
	// spawner?
	if ( !isalive( self ) )
		return;
		
	self endon( "death" );
	waitspread( 0, 8 );
//	if ( distance( self.origin, level.player.origin ) < 240 )
//		return;
	
	self dodamage( self.health + 50, (0,0,0) );
}

wait_while_enemies_are_alive_near_player()
{
	for ( ;; )
	{
		enemy_near_player = false;
		enemies = getaiarray( "axis" );
		if ( !enemies.size )
			return;

		for ( i=0; i < enemies.size; i++ )
		{
			enemy = enemies[ i ];
			if ( distance( enemy.origin, level.player.origin ) < 240 )
			{
				enemy_near_player = true;
				break;
			}
		}

		if ( !enemy_near_player )
			return;
		wait( 0.05 );
	}
}

aim_at_target()
{
	self endon( "death" );
	targetting_origin = false;
	for ( ;; )
	{
		if ( isdefined( self.enemy ) )
		{
			// clear it
			if ( targetting_origin )
			{
				self clearenemy();
				targetting_origin = false;
			}
			wait( 1 );
			continue;
		}
		
		targetting_origin = true;
		// target a random origin
		self setEntityTarget( random( level.aim_targets ) );
		wait randomfloatrange( 1, 4.5 );
	}
}

clear_player_threatbias_vs_apartment_enemies()
{
	// the player is no longer ignored by the apartment's inhabitants
	setThreatBias( "player", "upstairs_unreachable_enemies", 0 );
	setThreatBias( "player", "upstairs_window_enemies", 0 );
}

stick_me_to_my_spot()
{
	self.maxsightdistsqrd = 0;
	self setgoalpos( self.origin );
	self.goalradius = 16;
}

ignore_suppression_until_ambush()
{
	self endon( "death" );
	self.ignoreSuppression = true;
	self.pacifist = true;
	flag_wait( "friendlies_take_fire" );	
	self.pacifist = false;
	self.ignoreSuppression = false;
}

increase_goal_radius_when_friendlies_flank()
{
	self endon( "death" );
	self.goalheight = 60;
	self.goalradius = 128;
	flag_wait( "pacifist_guys_move_up" );
	self.goalradius = 3050;
	self setEngagementMinDist( randomintrange( 0, 125 ), 0 );
	maxdist = randomintrange( 250, 350 );
	self setEngagementMaxDist( maxdist, maxdist + 100 );
	self setThreatbiasGroup( "pacifist_lower_level_enemies" );
	self.ignoreSuppression = true;
}



debug_player_damage()
{
	for ( ;; )
	{
		level.player waittill( "damage", a, b, c, d, e, f, g, h );
		level.hitenemy = b;
		i=5;
	}
}



initial_friendly_setup()
{
	spawn_failed( self );
//	self set_force_color( "r" );
	self.animname = "generic";
	self.moveplaybackrate = 1;
	self.goalradius = 16;
	self setgoalpos( self.origin );
	self.pacifist = true;
}


bridge_friendly_spawns()
{
	self endon( "death" );
	if ( !isdefined( self.script_forceColor ) )
	{
		self set_force_color( "y" );
	}
	set_engagement_to_closer();
	self.ignoresuppression = true;
	self.IgnoreRandomBulletDamage = true;
	self.pacifist = true;
	flag_wait( "friendlies_move_up_the_bridge" );	
	self.pacifist = false;
}
	

small_pathenemy()
{
	self.pathenemyfightdist = 50;
	self.pathenemylookahead = 50;
}

magic_rpgs_fire()
{
	targets = getentarray( self.target, "targetname" );
	for ( i=0; i < targets.size; i++ )
	{
		magicbullet( "rpg_straight", self.origin, targets[ i ].origin );
		wait( randomfloatrange( 1.5, 5 ) );		
	}
}

magic_rpg_fires( name )
{
	rpg = getent( name, "targetname" );
	rpg magic_rpgs_fire();
}

delete_me()
{
	self delete();
}

set_engagement_to_closer()
{
	self setEngagementMinDist( 0, 0 );
	self setEngagementMaxDist( 1000, 3000 );
}

set_min_engagement_distance( min, min_falloff )
{
	self setEngagementMinDist( min, min_falloff );
}

set_max_engagement_distance( max, max_falloff )
{
	self setEngagementmaxDist( max, max_falloff );
}

incoming_rpg()
{
	magic_rpg_fires( "magic_rpg1" );
	wait( 2.5 );
	magic_rpg_fires( "magic_rpg2" );

	/*
	wait( 0.4 );
	// add some extra kick to the rocket
	explosion_point = getent( "explosion_point", "targetname" );
	radiusDamage( explosion_point.origin, explosion_point.radius, 9000, 9000 );
	explosion_point delete();
	*/
}

ambushed_guys_die()
{
	wait( 1.5 );
	ai = getentarray( "ambushed_guy", "targetname" );
	array_thread( ai, ::killme );
}

killme()
{
	self dodamage( 5000, ( 0,0,0 ) );
}

waitspread_death( timer )
{
	if ( !isalive( self ) )
		return;
	self endon( "death" );
	waitspread( timer );
	killme();
}

slowdown()
{
	self endon( "death" );
	self.walkdist = 5000;
	wait( 0.4 );
	self setgoalpos( self.origin );
}



set_ignore_suppression( val )
{
	self.ignoreSuppression = val;
}

wait_until_price_triggers_or_player_reaches_bridge_end()
{
	level endon( "player_reaches_end_of_bridge" );
	if ( flag( "player_reaches_end_of_bridge" ) )
		return;

	for ( ;; )
	{
		self waittill( "trigger", other );
		if ( !isalive( other ) )
			continue;
			
		if ( other != level.price )
			continue;
		break;
	}
}

promoted_cyan_guy_leads_player_to_apartment( null )
{
	if ( self.script_forceColor != "c" )
		return;
	thread cyan_guys_lead_player_to_apartment();
}

wait_until_player_gets_close_or_enters_apartment()
{
	level endon( "friendlies_move_into_apartment" );
	while ( distance( self.origin, level.player.origin ) > 128 )
	{
		if ( self cansee( level.player ) )
		{
			// if the player is looking at me I can lead the way!
			player_angles = level.player GetPlayerAngles();
		    player_forward = anglesToForward( player_angles );
			normal = vectorNormalize( self.origin - level.player.origin );
			dot = vectorDot( player_forward, normal );
			if ( dot > 0.80 ) 
				return;
		}
		
		wait( 1 );
	}
}

cyan_guys_lead_player_to_apartment()
{
	self endon( "death" );
	self endon( "damage_notdone" );
	wait_until_player_gets_close_or_enters_apartment();

	// becomes a dark blue guy and gets magic bullet shield
	// leads player to the apartment
	self set_force_color( "b" );
	
	if ( self == level.price )
	{
		self thread price_signals_player_into_apartment();
	}
	
		
	if ( !is_hero() )
	{
		self thread magic_bullet_shield();
	}

	flag_wait( "pit_guys_cleared" );
	self.ignoreall = true;
	flag_wait( "friendlies_storm_second_floor" );
	
	self.ignoreall = false;
}

price_signals_player_into_apartment()
{
	if ( flag( "friendlies_storm_second_floor" ) )
		return;
	level endon( "friendlies_storm_second_floor" );
	node = getnode( "price_underground_node", "targetname" );

	for ( ;; )
	{
		node anim_reach_solo( level.price, "wait_approach" );
		if ( distance( node.origin, level.price.origin ) < 16 )
			break;
	}
	
	node anim_single_solo( level.price, "wait_approach" );
		
	thread price_waits_at_node_and_waves( node, "vas_stops_leading" );
	thread price_recovers_from_waving( node );
}

price_recovers_from_waving( node )
{
	flag_wait( "friendlies_storm_second_floor" );
	level notify( "vas_stops_leading" );
	node notify( "stop_idle" );
	level.price stopanimscripted();
	level.price notify( "single anim", "end" );
	level.price notify( "looping anim", "end" );
	//update_underground_obj_trigger
}

wait_for_player_to_disrupt_second_floor_or_leave()
{
	level endon( "player_leaves_second_floor" );
	flag_wait( "player_disrupts_second_floor" );
}

manual_mg_fire()
{
	self endon( "stop_firing" );
	self.turret_fires = true;
	for ( ;; )
	{
		timer = randomfloatrange( 0.2, 0.7 ) * 20;
		if ( self.turret_fires )
		{
			for ( i = 0; i < timer; i++ )
			{
				self shootturret();
				wait( 0.05 );
			}
		}
		wait( randomfloat( 0.5, 2 ) );
	}
}

wait_for_death( guy )
{
	if ( !isalive( guy ) )
		return;
	guy waittill( "death" );
}

scr_setmode( mode )
{
	self setmode( mode );
}


flank_guy()
{
	// guy that spawns up ahead and down the stairs on the first flank
	level.flank_guy = getent( "flank_guy", "targetname" );
	spawn_failed( level.flank_guy );
	level.flank_guy.goalradius = 8;
	level.flank_guy.pacifist = true;
	level.flank_guy allowedstances( "crouch" );
	level.flank_guy thread magic_bullet_shield();
	level.flank_guy.ignoreme = true;
	level.flank_guy make_hero();
	level.flank_guy.ignoreSuppression = true;

}

rooftop_guys_attack()
{
	self endon( "death" );
	waitSpread(5);
	for ( i=0; i < self.count; i++ )
	{
		spawn = self spawn_ai();
		if ( spawn_failed( spawn ) )
			return;
		
		spawn waittill( "death" );
	}
}

hint_guy_gets_the_players_attention()
{
	self.ignoreme = true;
	self.ignoresuppression = true;
	self endon( "death" );
	wait( 2.5 ); // give player a chance to shoot the guys in the hallway
	
	self maps\_spawner::go_to_node();
	wait( 3 );
	self.ignoreme = false;	
	self.goalradius = 2048;	// now he can go and hide and draw the player in
}

upstairs_unreachable_enemies()
{
	self add_spawn_function( ::ignore_suppression_until_ambush );
	self add_spawn_function( ::small_pathenemy );
	self add_spawn_function( ::set_threatbias_group, "upstairs_unreachable_enemies" );
}

upstairs_window_enemies()
{
	self add_spawn_function( ::ignore_suppression_until_ambush );
//	self add_spawn_function( ::small_pathenemy );
	self add_spawn_function( ::set_threatbias_group, "upstairs_window_enemies" );
}

teleport_purple_guys_closer()
{
	purple_guys = get_force_color_guys( "allies", "p" );
	points = getentarray( "purple_teleport_org", "targetname" );
	for ( i=0; i < purple_guys.size; i++ )
	{
		guy = purple_guys[ i ];
		
		// saved friendly is already hanging with us
		if ( isalive( level.saved_friendly ) && guy == level.saved_friendly )
			continue;
			
		// dont teleport down
		if ( guy.origin[ 2 ] + 37 > points[ i ].origin[ 2 ] )
			continue;
		guy teleport( points[ i ].origin );
	}
}

remove_corner_ai_blocker()
{
	corner_ai_blocker = getent( "corner_ai_blocker", "targetname" );
	if ( isdefined( corner_ai_blocker ) )
	{
		corner_ai_blocker connectPaths();
		corner_ai_blocker delete();
	}
}

wait_until_price_nears_balcony()
{
	trigger = getent( "price_gap_trigger", "targetname" );
	for ( ;; )
	{
		trigger waittill( "trigger", other );
		if ( other == level.price )
			return;
		other thread ignore_triggers();
	}
}

wait_until_player_nears_balcony()
{
	level.balcony_objective_org = ( 10216.3, 174.7, 239.5 );

	org = ( level.balcony_objective_org[ 0 ], level.balcony_objective_org[ 1 ], 0 );
	while ( distance( org, ( level.player.origin[ 0 ], level.player.origin[ 1 ], 0 ) )  > 200 )
	{
		wait( 0.25 );
	}
}

price_congrates()
{
	self waittill( "death", other );
	if ( isalive( other ) && other == level.player )
	{
		wait( 2.5 );
		// Good job!
		level.price thread anim_single_queue( level.price, "good_job" );
	}
}


player_is_on_mg()
{
	turret = getent( "apartment_window_mg_1", "targetname" );
	owner = turret getTurretOwner();
	if ( !isalive( owner ) )
		return false;
	return owner == level.player;
}


debug_pain()
{
	self endon( "death" );
	for ( ;; )
	{
		self waittill( "pain", attacker, one, two, three, four, five );
		tookpain = undefined;
	}
}

shoot_mg_targets()
{
	thread do_in_order( ::flag_wait, "player_enters_apartment_rubble_area", ::send_notify, "stop_firing" );
	thread stop_firing_when_shot();
	targets = getentarray( self.target, "targetname" );
	
	for ( ;; )
	{
		target = random( targets );
		self settargetentity( target );
		wait( randomfloatrange( 1, 5 ) );
	}
}

explosive_damage( type )
{
	return issubstr( type, "GRENADE" );
}

stop_firing_when_shot()
{
	level endon( "player_enters_apartment_rubble_area" );
	trigger = getent( self.script_linkto, "script_linkname" );
	shots_until_stop = randomintrange( 2, 3 );
	for ( ;; )
	{
		trigger waittill( "damage", damage, other, direction, origin, damage_type );
		if ( other != level.player )
			continue;

		if ( explosive_damage( damage_type ) )
		{
			self.turret_fires = false;
			return;
		}
		
		shots_until_stop--;
		if ( shots_until_stop > 0 )
			continue;
		
		shots_until_stop = randomintrange( 3, 4 );
		self.turret_fires = false;
		wait( randomfloatrange( 7, 10 ) );
		self.turret_fires = true;
	}
}


price_waits_at_node_and_waves( node, ender )
{
	level endon( ender );
	flag_assert( ender );

	odd = true;	
	for ( ;; )
	{
		node thread anim_loop_solo( level.price, "wait_idle", undefined, "stop_idle" );
		wait( randomfloat( 0.1, 2.5 ) );
		node notify( "stop_idle" );
		if ( odd )
		{
			node anim_single_solo( level.price, "wave1" );
		}
		else
		{
			if ( flag( "friendlies_move_up_the_bridge" ) )
				Objective_Ring( 2 );
				
			node anim_single_solo( level.price, "wave2" );
		}
		odd = !odd;
	}
}

#using_animtree ("vehicles");
cobra_crash()
{
	for ( ;; )
	{
		self waittill( "trigger", other );
//		if ( other.vehicleType != "cobra" )
//			continue;
		if ( other.targetname != "heli_crash" )
			continue;
		/*
		dummy = other maps\_vehicle::vehicle_to_dummy();
		dummy useAnimTree( #animtree );
		dummy animscripted( "single_anim", dummy.origin, dummy.angles, %cobra_crash );
		//dummy setanimknob( %cobra_crash, 1, 0.25, 1 );
		*/
		ent = spawn( "script_model", (0,0,0) );
		ent.origin = other.origin;
		ent.angles = other.angles;
		ent setmodel( other.model );
		ent useAnimTree( #animtree );
		ent animScripted( "blah", ent.origin, ent.angles, %cobra_crash );
		other delete();
		playfxontag( getfx( "heli_aerial_explosion_large" ), ent, "tag_body" );
		ent playsound( "helicopter_hit" );
		delaythread( 0.1, ::_Earthquake, 0.4, 1.2, ent.origin, 6000 );
		ent playloopsound( "helicopter_dying_loop" );
		ent thread tailfx();
//		ent waittillmatch( "blah", "end" );
		wait( 2 );
		playfxontag( getfx( "heli_aerial_explosion" ), ent, "tail_rotor_jnt" );
		ent playsound( "helicopter_hit" );
		wait( 1 );
		playfxontag( getfx( "heli_aerial_explosion" ), ent, "tag_deathfx" );
		ent playsound( "helicopter_hit" );

		wait( 3 );
		exploder( 2 );

		ent notify( "stop_tail_fx" );
		ent delete();
		
//		ent setanimknob( %cobra_crash_additive, 1, 0.25, 1 );
		wait( 5 );
	}
}

tailfx()
{
	self endon( "stop_tail_fx" );
	tags = [];
//	tags[ tags.size ] = "tag_gunner";
	tags[ tags.size ] = "tail_rotor_jnt";
	//tags[ tags.size ] = "tag_engine_rear_left";
//	tags[ tags.size ] = "tag_engine_rear_right";
	
	tagsKeys = getarraykeys( tags );
	fx = undefined;
	
	for ( ;; )
	{
		for ( i=0; i < tagsKeys.size; i++ )
		{
			org = self GetTagOrigin( tags[ tagsKeys[ i ] ] );
			playfx( getfx( "smoke_trail_heli" ), org );
//			fx = spawnFx( getfx( "smoke_trail_heli" ), org ); 
//			delayThread( ::deleteEnt, 30, fx );
//			triggerFx( fx, 0 );
			
//			playfxontag( getfx( "smoke_trail_heli" ), self, tags[ tagsKeys[ i ] ] );
//			playfxontag( getfx( "fire_trail_heli" ), self, tags[ tagsKeys[ i ] ] );
		}

		wait( 0.05 );
	}
}


helis_ambient()
{
	thread helicopter_flies_by_overhead( "intro_heli", 5, 			95, 95 );
	thread helicopter_flies_by_overhead( "intro_helib", 5.85, 		95, 95 );
	thread helicopter_flies_by_overhead( "intro_heli2", 9,			95, 95 );
	thread helicopter_flies_by_overhead( "intro_heli2b", 9.95, 		95, 95 );
	thread helicopter_flies_by_overhead( "intro_heli3", 14, 		135, 95 );
	thread helicopter_flies_by_overhead( "intro_heli3b", 14.95, 	135, 95 );
//	thread helicopter_flies_by_overhead( "intro_heli4", 22, 		135, 95 );
//	thread helicopter_flies_by_overhead( "intro_heli4b", 22.95, 	165, 95 );

	flag_wait( "armada_passes_by" );
	helisets = [];
	helisets = add_heli_set( "intro_heli", 	95, 95 );
	helisets = add_heli_set( "intro_heli2", 95, 95 );
	helisets = add_heli_set( "intro_heli3", 135, 95 );
	helisets = add_heli_set( "intro_heli4", 165, 95 );
	
	for ( ;; )
	{
		helisets = array_randomize( helisets );
		for ( i=0; i < helisets.size; i++ )
		{
			set = helisets[ i ];
			thread helicopter_flies_by_overhead( set[ "heli1" ], 0, set[ "maxspeed" ], set[ "accell" ] );
			thread helicopter_flies_by_overhead( set[ "heli2" ], 0.8, set[ "maxspeed" ], set[ "accell" ] );
			wait( randomfloatrange( 8, 12 ) );
		}
	}
}

add_heli_set( name, maxspeed, accell )
{
	array = [];
	array[ "heli1" ] = name;
	array[ "heli2" ] = name + "b";
	array[ "maxspeed" ] = maxspeed;
	array[ "accell" ] = accell;
	return array;
}


die_soon( when )
{
	if ( !isalive( self ) )
		return;
	self endon( "death" );
	wait( when );
	self dodamage( self.health + 50, (0,0,0) );
}

player_has_javelin()
{
	weaponList = level.player GetWeaponsListPrimaries();
	for ( i=0; i < weaponList.size; i++ )
	{
		if ( issubstr( weaponList[ i ], "avelin" ) )
		{
			return true;
		}
	}
	
	return false;
}

player_using_javelin()
{
	return issubstr( level.player getcurrentweapon(), "avelin" );
}

player_fires_javelin()
{
	return level.player isFiring() && issubstr( level.player getcurrentweapon(), "avelin" );
}


overpass_baddies_attack()
{
	level endon( "overpass_baddies_flee" );
	assertEx( !flag( "overpass_baddies_flee" ), "flag was set too soon" );
	
	wait( 5 );
	spawners = getentarray( "bridge_spawner", "targetname" );
	
	for ( ;; )
	{
		if ( getaiarray( "axis" ).size >= 18 )
		{
			wait( 180 );
			continue;
		}
		
		spawner = random( spawners );
		spawner.count = 3;
		// pyramid spawns 3 guys
		spawner thread maps\_spawner::flood_spawner_think();
		wait( 5 );
	}
}

die_asap()
{
	self endon( "death" );
	while ( self canSee( level.player ) )
	{
		wait( 0.2 );
	}
	
	self delete();
}

shanty_run()
{
	if ( isdefined( self.target ) )
	{
		trigger = getent( self.target, "targetname" );
		trigger.trigger_num = self.trigger_num + 1;
		trigger thread shanty_run();
	}
	
	for ( ;; )
	{
		self waittill( "trigger", other );

		if ( !isalive( other ) )
			continue;

		other.trigger_num = self.trigger_num;

		if ( other == level.player )
		{
			level notify( "new_player_trigger_num" );
		}
		else		
		{
			other notify( "new_trigger_num" );
		}
	}
}

waittill_new_trigger_num()
{
	self endon( "new_trigger_num" );
	level waittill( "new_player_trigger_num" );
}

shanty_allies_cqb_through()
{
	self endon( "death" );
	flag_wait( "start_shanty_run" );

	// pick one of two paths through
	dests = getentarray( "shanty_destination", "targetname" );
	dest = random( dests );
	self.goalradius = 128;	
	self.interval = 0;
	self disable_ai_color();
	self maps\_spawner::go_to_origin( dest );

	self.interval = 96;

	if ( self == level.price )
	{
		backhalf_price = getent( "price_spawner", "targetname" );
		level.price set_force_color( backhalf_price.script_forceColor );
		return;
	}	
	
	if ( self == level.mark )
	{
		backhalf_mark = getent( "mark_spawner", "targetname" );
		level.mark set_force_color( backhalf_mark.script_forceColor );
		return;
	}

	if ( level.ending_bog_redshirts >= 2 )
	{
		// extra guys run in and die in the bog
		org = getent( "ally_charge_bog_org", "targetname" ).origin;
		self setgoalpos( org );
		if ( isdefined( self.magic_bullet_shield ) )
			self stop_magic_bullet_shield();
		self.health = 1;
		return;
	}

	// steve wants 2 redshirts, one red, one blue
	level.ending_bog_redshirts++;

	if ( level.ending_bog_redshirts == 1 )
	{
		self set_force_color( "r" );
	}
	else
	{
		self set_force_color( "b" );
	}
//	self thread replace_on_death();
}



shanty_ai_think()
{
	self disable_ai_color();
	self.trigger_num = 0;
	self endon( "death" );
	self.interval = 0;
	
	self endon( "reached_shanty_end" );
	if ( self != level.price )
	{
		self.animname = "generic";
	}
	
//	thread run_to_end_of_shanty();
	
//	actionBind = getActionBind( "sprint2" );
	//thread showPlaybackRate();
	for ( ;; )
	{
		waittill_new_trigger_num();
		
		if ( level.player.trigger_num - self.trigger_num >= 2 )
		{
			self.moveplaybackrate = 1.21;
//			self set_run_anim( "sprint" );
		}
		else
		if ( level.player.trigger_num - self.trigger_num == 1 )
		{
			self.moveplaybackrate = 1.1;
//			self set_run_anim( "sprint" );
		}
		else
		if ( level.player.trigger_num - self.trigger_num == 0 )
		{
			self.moveplaybackrate = 1.0;
//			self set_run_anim( "sprint" );
		}
		else
		if ( level.player.trigger_num - self.trigger_num == -1 )
		{
			self.moveplaybackrate = 1.0;
		}
		else
		if ( level.player.trigger_num - self.trigger_num == -2 )
		{
			self.moveplaybackrate = 1.0;
		}
		else
		if ( level.player.trigger_num - self.trigger_num <= -3 )
		{
			time_since_last_stopper = ( gettime() - level.shanty_timer ) * 0.001;
			next_stop_time = time_since_last_stopper + randomfloatrange( 2, 3 );
			level.shanty_timer = gettime();
			
			if ( next_stop_time > 0 )
			{
				wait( next_stop_time );
			}
				
			if ( level.player.trigger_num - self.trigger_num <= -3 )
			{
				// is it still true?
				self setgoalpos( self.origin );
			}
//			self.moveplaybackrate = 0.7;
		}
	}
}


shanty_ai_sprint()
{
	self disable_ai_color();
	self.trigger_num = 0;

	if ( self != level.price )
	{
		self.animname = "generic";
	}

	self set_run_anim( "sprint" );

//	thread run_to_end_of_shanty();
}

showPlaybackRate()
{
	self endon( "death" );
	for ( ;; )
	{
		print3d( self.origin + (0,0,64), self.moveplaybackrate, (1,1,1), 1, 1 );
		wait( 0.05 );
	}
}

magic_rpgs_fire_randomly()
{
	waitSpread( 1, 6 );
	magic_rpgs_fire();
}

magic_rpg_trigger()
{
	level endon( "stop_shanty_rockets" );
	self waittill( "trigger" );
	targets = getentarray( self.target, "targetname" );
	for ( i=0; i < targets.size; i++ )
	{
		targets[ i ] magic_rpgs_fire();
		wait( randomfloatrange( 1.5, 5 ) );		
	}
}

bog_ambient_fighting()
{
	self endon( "death" );
	thread magic_bullet_shield();
	self.goalradius = 1450;
	flag_wait( "kill_bog_ambient_fighting" );
	self stop_magic_bullet_shield();
	self delete();
}

take_cover_against_overpass()
{
	if ( isdefined( self.fence_guy ) )
		return;
		
	self endon( "death" );
	self disable_ai_color();
	self setgoalpos( self.origin );
	waitspread( 2 );
	self.fixednode = false;
	self.goalradius = 2048;
}

alley_balcony_guy()
{
	// price "throws a grenade" at this guy if he doesnt die soon enough
	self endon( "death" );
	flag_wait( "price_in_alley_position" );
	magicbullet( "rpg_straight", self.origin + (0,0,10), self.origin );
}

lose_goal_volume()
{
	for ( ;; )
	{
		self waittill( "trigger", other );
		if ( !isalive( other ) )
			continue;
			
		other thread ignore_triggers();
		other.dont_use_goal_volume = true;
	}
}

wait_until_javelin_guy_died_or_must_die()
{
	if ( !isalive( self ) )
		return;
	self waittill( "death" );
}

die_after_spawn( timer )
{
	self endon( "death" );
	wait( timer );
	self dodamage( self.health + 150, (0,0,0) );
}


wait_until_price_reaches_his_trigger()
{
	trigger = getent( "price_alley_trig", "targetname" );
	
	for ( ;; )
	{
		trigger waittill( "trigger", other );
		if ( !isalive( other ) )
			continue;
		if ( other != level.price )
			continue;
		return;
	}
}

wait_for_friendlies_to_reach_alley_goal()
{
	maxtime = gettime() + 15000;
	for ( ;; )
	{
		if ( check_allies_in_position() )
			return;
		if ( gettime() > maxtime )
			return;
		wait( 0.1 );
	}
}

check_allies_in_position()
{
	yellow = get_force_color_guys( "allies", "y" );
	orange = get_force_color_guys( "allies", "o" );
	allies = array_combine( yellow, orange );
	
	// check most of them
	count = allies.size - 2;
	for ( i = 0; i < allies.size; i++ )
	{
		guy = allies[ i ];
		if ( !isdefined( guy.goalpos ) )
			continue;
		if ( distance( guy.origin, guy.goalpos ) > 60 )
			continue;
		count--;
		if ( count <= 0 )
			return true;
	}
	
	return false;
}

shanty_fence_cut_setup()
{
	shanty_fence = spawn_anim_model( "fence" );
	shanty_fence_org = getent( "shanty_fence_org", "targetname" );
	shanty_fence_org thread anim_first_frame_solo( shanty_fence, "fence_cut" );
	level.shanty_fence = shanty_fence;
}

shanty_fence_cut()
{
	shanty_fence = level.shanty_fence;
	shanty_fence_org = getent( "shanty_fence_org", "targetname" );
	
	shanty_fence_clip = getent( "shanty_fence_clip", "targetname" );
	shanty_fence_clip connectPaths();
	
	shanty_fence.animname = "fence";
	shanty_fence assign_animtree();
	
	assertex( isalive( level.fence_guys[ 0 ] ), "Fence guy 1 was not alive" );
	assertex( isalive( level.fence_guys[ 1 ] ), "Fence guy 1 was not alive" );
	
	guy1 = level.fence_guys[ 0 ];
	guy2 = level.fence_guys[ 1 ];

	guy1.animname = "fence_guy1";
	guy2.animname = "fence_guy2";
	
	fence_cutters = [];
	fence_cutters[ fence_cutters.size ] = guy1;
	fence_cutters[ fence_cutters.size ] = guy2;
	
	shanty_fence_org anim_reach_and_plant( fence_cutters, "fence_cut" );

	array_thread( fence_cutters, ::set_allowpain, false );

	shanty_fence_org thread anim_single_solo( shanty_fence, "fence_cut" );
	shanty_fence_clip delaythread( 12.45, ::self_delete );
	delaythread( 12.45, ::activate_trigger_with_targetname, "shanty_after_fence" );

	guy1 pushPlayer( true );
	shanty_fence_org thread anim_custom_animmode( fence_cutters, "gravity", "fence_cut" );
	array_thread( fence_cutters, ::set_force_color, "r" );
	shanty_fence_org waittill( "fence_cut" );
	guy1 pushPlayer( false );
	
	array_thread( fence_cutters, ::stop_magic_bullet_shield );
	array_thread( fence_cutters, ::set_allowpain, true );
}

set_allowpain( val )
{
	self.allowPain = val;
}

wait_until_deathflag_enemies_remaining( deathflag, num )
{
	ai = getaiarray( "axis" );
	for ( ;; )
	{
		count = 0;
		
		spawners = level.deathflags[ deathflag ][ "spawners" ];
		keys = getarraykeys( spawners );
		for ( i = 0; i < keys.size; i++ )
		{
			if ( isdefined( spawners[ keys[ i ] ] ) )
				count += spawners[ keys[ i ] ].count;
		}
		
		count += level.deathflags[ deathflag ][ "ai" ].size;
		level.temp_deathflagcount = count;
		
		if ( count <= num )
			break;
		
		wait( 1 );
	}
}

friendlies_charge_alley_early()
{
	wait_until_deathflag_enemies_remaining( "alley_cleared", 6 );
	flag_set( "friendlies_charge_alley" );
}


second_floor_door_breach_guys( debugmode )
{
	door = getent( "apartment_second_floor_door_breach", "targetname" );
	door_model = spawn_anim_model( "door" );
	door hide();
	door linkto( door_model, "door_jnt", (0,0,0), (0,0,0) );
	node = getnode( "second_floor_door_breach_node", "targetname" );
	level.door_mod = ( -20, -5.35, 0 );
	door_ent = spawn( "script_origin", node.origin + level.door_mod );
	level.door_ent = door_ent;
//	door_model thread maps\_debug::drawtagforever( "door_jnt" );
//	door_ent = spawn( "script_origin", node.origin + ( -20, -13, 0 ));
	door_ent.angles = node.angles + (0,270,0);
	door_ent thread anim_first_frame_solo( door_model, "door_breach" );

	ent = spawn( "script_origin", node.origin + ( -20, -13, 0 ));
	ent.angles = node.angles;
	
	flag_wait( "second_floor_door_breach_initiated" );
	
	// keeps the corner free from traffic
	remove_corner_ai_blocker();

	if ( debugmode )
	{
		right_guy = get_guy_with_script_noteworthy_from_spawner( "second_floor_right_door_breach_guy" );
		left_guy = get_guy_with_script_noteworthy_from_spawner( "second_floor_left_door_breach_guy" );
	}
	else
	{
		// one blue guy and one purple guy become the door breachers
//		right_guy = get_closest_colored_friendly( "b" );
		left_guy = get_closest_colored_friendly( "p" );
		left_guy make_hero();
		left_guy clear_force_color();

		right_guy = get_closest_colored_friendly_with_classname( "b", "shotgun" );
		if ( !isalive( right_guy ) )
		{
			right_guy = get_closest_colored_friendly_with_classname( "p", "shotgun" );
		}
		if ( !isalive( right_guy ) )
		{
			trigger = getent( "player_sees_breach_spawner", "targetname" );
			while ( level.player istouching( trigger ) )
			{
				wait( 0.1 );
			}

			right_guy = get_guy_with_script_noteworthy_from_spawner( "second_floor_left_door_breach_guy" );
		}
		assertEx( isalive( right_guy ), "right_guy didnt spawn" );
		right_guy make_hero();
		right_guy clear_force_color();
	}

	left_guy.goalHeight = 64;
	right_guy.goalHeight = 64;
	
	left_guy.animName = "second_floor_left_guy";
	right_guy.animName = "second_floor_right_guy";
	
	if ( !isdefined( left_guy.magic_bullet_shield ) )
		left_guy thread magic_bullet_shield();
	
	if ( !isdefined( right_guy.magic_bullet_shield ) )
		right_guy thread magic_bullet_shield();
	
	guyArray = [];
	guyArray[ guyArray.size ] = left_guy;
	guyArray[ guyArray.size ] = right_guy;
	
//	if ( !isdefined( level.tweakOffset ) )
//		level.tweakOffset = ( 0,0,0 );
	ent anim_reach_and_idle( guyArray, "door_breach_setup", "door_breach_setup_idle", "stop_door_breach_idle" );
	
//	left_guy.ignoreme = true;
//	right_guy.ignoreme = true;

	ent notify( "stop_door_breach_idle" );
	ent anim_single( guyArray, "door_breach_setup" );
	ent thread anim_loop( guyArray, "door_breach_idle", undefined, "stop_loop" );
	
	second_floor_waittill_breach( guyArray );
	if ( flag( "player_enters_laundrymat" ) )
	{
		array_thread( guyArray, ::stop_magic_bullet_shield );
		array_thread( guyArray, ::_delete );
		return;
	}
		
	ent notify( "stop_loop" );
	
	
	ent thread anim_single( guyArray, "door_breach" );
	

	right_guy waittillmatch( "single anim", "kick" );
	door_ent thread anim_single_solo( door_model, "door_breach" );
	door connectPaths();
	door playsound ("wood_door_kick");
	
	left_guy.goalradius = 32;
	right_guy.goalradius = 32;
	left_guy.threatbias = 5500;
	left_guy.baseAccuracy = 1000;
	right_guy.baseAccuracy = 1000;

	badGuys = spawn_guys_from_targetname( node.target );

	
//	door door_opens();
	
	
	for ( i=0; i < badGuys.size; i++ )
	{
//		badGuys[ i ] setFlashBanged( true, 1 );
		badguy = badGuys[ i ];
		badguy.baseAccuracy = 0;
		badguy.goalradius = 8;
		badguy.health = 1;
		badguy.pathenemyfightdist = 0;
		badguy.pathenemylookahead = 0;
		
		badguy allowedstances( "stand" );
		if ( isdefined( badguy.target ) )
			badguy thread wait_then_go_to_target();
	}

	wait( 2 );
	left_guy setgoalpos( left_guy.origin );
	ent waittill( "door_breach" );

	
	for ( i = 0; i < badGuys.size; i++ )
	{
		if ( isalive( badGuys[ i ] ) )
			badGuys[ i ] waittill( "death" );
	}

	right_guy.baseAccuracy = 1;
	left_guy_node = getnode( "left_guy_breach_node", "targetname" );
	right_guy_node = getnode( "right_guy_breach_node", "targetname" );
	left_guy.baseAccuracy = 1;
	left_guy setgoalpos( left_guy.origin );
	left_guy.goalradius = 64;
	left_guy setgoalnode( left_guy_node );

	right_guy anim_single_solo( right_guy, "clear" );

	node = getnode( "second_floor_clear_node", "targetname" );
	left_guy setgoalnode( node );
	left_guy.goalradius = 32;
	left_guy waittill( "goal" );
	left_guy.threatbias = 0;
	left_guy anim_single_solo( left_guy, "clear" );

	if ( debugmode )
	{
		for ( i=0; i < guyArray.size; i++ )
		{
			guy = guyArray[ i ];
			guy stop_magic_bullet_shield();
			guy delete();
		}
		return;
	}
	
	// Three coming out!
	left_guy anim_single_solo( left_guy, "three_coming_out" );
	wait( 1 );
	left_guy scrub();
	left_guy setgoalnode( left_guy_node );
	left_guy.goalradius = 32;

	// Roger that!
	level.price thread anim_single_queue( level.price, "roger_that" );

	// clear!
	right_guy anim_single_solo( right_guy, "clear" );
	right_guy scrub();
	right_guy setgoalnode( right_guy_node );
	right_guy.goalradius = 32;

	flag_wait( "alley_enemies_spawn" );
	right_guy thread door_breach_guy_leaves( "right_leave_node" );
	left_guy thread door_breach_guy_leaves( "left_leave_node" );
}

door_breach_guy_leaves( msg )
{
	self endon( "death" );
	node = getnode( msg, "targetname" );
	self setgoalnode( node );

	self add_wait( ::waittill_player_lookat );
	add_wait( ::flag_wait, "player_enters_laundrymat" );
	do_wait_any();
	
	wait( randomfloat( 2, 3 ) );
	self set_force_color( "g" );
	self.ignoreall = true;
}	

second_floor_waittill_breach( guys )
{
	add_wait( ::wait_for_targetname_trigger, "second_floor_door_breach_trigger" );
	add_wait( ::flag_wait, "player_enters_laundrymat" );
	
	for ( i = 0; i < guys.size; i++ )
	{
		guys[ i ] add_wait( ::waittill_player_lookat_for_time, 0.3 );
	}
	
	do_wait_any();
}

waittill_player_not_looking( org )
{
	for ( ;; )
	{
		if ( !player_looking_at( org, 0.7 ) )
			break;
		wait( 0.1 );
	}
}

update_obj_on_dropped_jav( org )
{
	level endon( "overpass_baddies_flee" );
	flag_assert( "overpass_baddies_flee" );
	
	for ( ;; )
	{
		weapons = getentarray( "weapon_javelin", "classname" );
		assertex( weapons.size < 2, "Somehow level had 2 javelins" );
		if ( !weapons.size )
		{
			wait( 0.05 );
			continue;
		}
		
		jav = weapons[ 0 ];
		jav thread add_jav_glow( "overpass_baddies_flee" );
		objective_position( 4, jav.origin );

		for ( ;; )
		{
			weapons = getentarray( "weapon_javelin", "classname" );
			if ( !weapons.size )
				break;
			wait( 0.05 );
		}

		objective_position( 4, org );
	}
}

wait_for_fence_guys_to_be_drafted()
{
	if ( !isdefined( level.fence_guys ) )
		level.fence_guys = [];
		
	if ( level.fence_guys.size >= 2 )
		return;

	level notify( "drafting_fence_guys" );
	level endon( "drafting_fence_guys" );		
	for ( ;; )
	{
		// kill off excess friendlies
		allies = getaiarray( "allies" );
		allies = remove_heroes_from_array( allies );

		if ( !allies.size )
		{
			wait( 0.5 );
			continue;
		}
		
		guy = allies[ 0 ];
		guy thread magic_bullet_shield();
		guy make_hero();
		guy set_force_color( "r" );
		guy.fence_guy = true;
		level.fence_guys[ level.fence_guys.size ] = guy;
		if ( level.fence_guys.size >= 2 )
			break;
	}
}

disable_nvg()
{
	flag_wait( "player_enters_laundrymat" );
	wait( 4.0 );
	display_hint( "disable_nvg" );
}

update_apartment_objective_position()
{
	// baby baby baby STEP
	self waittill( "trigger" );
	targ = getent( self.target, "targetname" );
	objective_position( 2, targ.origin );
}
