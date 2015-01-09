#include maps\_utility;
#include maps\_vehicle;
#include maps\_anim;
#include maps\scoutsniper;
#include common_scripts\utility;
#include maps\_stealth_logic;
#include maps\_hud_util;


updateFog()
{
	trigger_fogdist3000 = getent( "trigger_fogdist3000", "targetname" );
	trigger_fogdist5000 = getent( "trigger_fogdist5000", "targetname" );

	for( ;; )
	{
		trigger_fogdist3000 waittill( "trigger" );
		setExpFog( 0, 3000, 0.33, 0.39, 0.545313, 1 );
		
		trigger_fogdist5000 waittill( "trigger" );
		setExpFog( 0, 8000, 0.33, 0.39, 0.545313, 1 );
	}
}

// detects player only, friendly AI not supported
execVehicleStealthDetection()
{
	self thread maps\_vehicle::mgoff();
	self endon( "death" );
	
	while( 1 )
	{
		flag_wait( "_stealth_spotted" );
		self thread vehicle_turret_think();
		
		flag_waitopen( "_stealth_spotted" );
		self notify( "nolonger_spotted" );
	}
}

stop_dynamic_run_speed()
{
	self endon( "start_dynamic_run_speed" ); 
	self endon( "death" );
	
	self stop_dynamic_run_speed_wait();
	
	self.moveplaybackrate = 1;
	self clear_run_anim();	
	
	self notify( "stop_loop" );
	self ent_flag_clear( "dynamic_run_speed_stopping" );
	self ent_flag_clear( "dynamic_run_speed_stopped" );
}

stop_dynamic_run_speed_wait()
{
	level endon( "_stealth_spotted" );
	self waittill( "stop_dynamic_run_speed" );
}

dynamic_run_speed( pushdist, sprintdist )
{
	self endon( "death" );
	self notify( "start_dynamic_run_speed" );
	self endon( "start_dynamic_run_speed" );
	self endon( "stop_dynamic_run_speed" );
	level endon( "_stealth_spotted" );
	
	self ent_flag_waitopen( "_stealth_custom_anim" );
	
	if( !isdefined( self.ent_flag[ "dynamic_run_speed_stopped" ] ) )
	{
		self ent_flag_init( "dynamic_run_speed_stopped" );
		self ent_flag_init( "dynamic_run_speed_stopping" );
	}
	else
	{
		self ent_flag_clear( "dynamic_run_speed_stopping" );
		self ent_flag_clear( "dynamic_run_speed_stopped" );
	}
	
	self.run_speed_state = "";
		
	self thread stop_dynamic_run_speed();
	
	if( !isdefined(pushdist) )
		pushdist = 250;
		
	if( !isdefined(sprintdist) )
		sprintdist = pushdist * .5;
			
	while(1)
	{
		wait .05;
		
		//iprintlnbold( self.run_speed_state );
		
		vec = anglestoforward( self.angles );
		vec2 = vectornormalize( ( level.player.origin - self.origin ) );
		vecdot = vectordot(vec, vec2);
		
		//how far is the player
		dist = distance( self.origin, level.player.origin );
		
		//is the player actually ahead of us, even though we're not facing him?
		ahead = false;
		if( isdefined( self.last_set_goalent ) )
			ahead = dynamic_run_ahead_test( self.last_set_goalent, sprintdist );
		else if( isdefined( self.last_set_goalnode ) )
			ahead = dynamic_run_ahead_test( self.last_set_goalnode, sprintdist );
		
		if( isdefined( self.cqbwalking ) && self.cqbwalking )
				self.moveplaybackrate = 1;	
				
		if ( dist < sprintdist || vecdot > -.25 || ahead )
		{							
			dynamic_run_set( "sprint" );
			continue;
		}
		
		else if ( dist < pushdist || vecdot > -.25 )
		{
			dynamic_run_set( "run" );
			continue;
		}
		
		else if ( dist > pushdist * 2 )
		{
			dynamic_run_set( "stop" );
			continue;	
		}
			
		else if ( dist > pushdist * 1.25 )
		{
			dynamic_run_set( "jog" );
			continue;
		}
	}
}

dynamic_run_ahead_test( node, dist )
{
	//only nodes dont have classnames - ents do
	if( !isdefined( node.classname ) )
		getfunc = ::follow_path_get_node;
	else
		getfunc = ::follow_path_get_ent;
	
	return wait_for_player( node, getfunc, dist );
}

dynamic_run_set( speed )
{
	if ( self.run_speed_state == speed )
		return;
		
	self.run_speed_state = speed;
	
	switch( speed )
	{
		case "sprint":
			//self.moveplaybackrate = 1.44;
			
			//self clear_run_anim();
			if( isdefined( self.cqbwalking ) && self.cqbwalking )
				self.moveplaybackrate = 1;
			else
				self.moveplaybackrate = 1.15;
			self set_generic_run_anim( "sprint" );
			
			self notify( "stop_loop" );
			self stopanimscripted();
			self ent_flag_clear( "dynamic_run_speed_stopped" );
			break;
		case "run":
			self.moveplaybackrate = 1;
			
			self clear_run_anim();
				
			self notify( "stop_loop" );
			self stopanimscripted();
			self ent_flag_clear( "dynamic_run_speed_stopped" );
			break;
		case "stop":
			self thread dynamic_run_speed_stopped();
			break;
		case "jog":
			self.moveplaybackrate = 1;
			
			self set_generic_run_anim( "combat_jog" );
			
			self notify( "stop_loop" );
			self stopanimscripted();
			self ent_flag_clear( "dynamic_run_speed_stopped" );
			break;
	}	
}

dynamic_run_speed_stopped()
{
	self endon( "death" );
	
	if( self ent_flag( "dynamic_run_speed_stopped" ) )
		return;
	if( self ent_flag( "dynamic_run_speed_stopping" ) )
		return;
	
	self endon( "stop_dynamic_run_speed" );
		
	self ent_flag_set( "dynamic_run_speed_stopping" );
	self ent_flag_set( "dynamic_run_speed_stopped" );
	
	self endon( "dynamic_run_speed_stopped" );
	
	self ent_flag_waitopen( "_stealth_stance_handler" );
	
	stop = "run_2_stop";	
	self anim_generic_custom_animmode( self, "gravity", stop );
	self ent_flag_clear( "dynamic_run_speed_stopping" ); //this flag gets cleared if we endon
			
	while( self ent_flag( "dynamic_run_speed_stopped" ) )
	{
		self ent_flag_waitopen( "_stealth_stance_handler" );
		
		idle = "combat_idle";
		self thread anim_generic_loop( self, idle, undefined, "stop_loop" );
		
		wait randomfloatrange(12, 20);
		
		self ent_flag_waitopen( "_stealth_stance_handler" );
		
		self notify( "stop_loop" );
		
		if( !self ent_flag( "dynamic_run_speed_stopped" ) ) 
			return;
		
		switch( randomint( 6 ) )
		{
			case 0:
				level thread function_stack(::radio_dialogue, "scoutsniper_mcm_letsgo" );
				break;
			case 1:
				level thread function_stack(::radio_dialogue, "scoutsniper_mcm_letsgo2" );
				break;
			case 2:
				level thread function_stack(::radio_dialogue, "scoutsniper_mcm_moveup" );
				break;
			case 3:
				level thread function_stack(::radio_dialogue, "scoutsniper_mcm_moveout" );
				break;
			case 4:
				level thread function_stack(::radio_dialogue, "scoutsniper_mcm_followme2" );
				break;
			case 5:
				level thread function_stack(::radio_dialogue, "scoutsniper_mcm_onme" );
				break;
				
		}
		
		wave = "moveup_exposed";
		self anim_generic( self, wave ); 
	}
}

follow_path_get_node( name, type )
{
	return getnodearray( name, type );	
}

follow_path_get_ent( name, type )
{
	return getentarray( name, type );	
}

follow_path_set_node( node )
{
	self set_goal_node( node );
	self notify( "follow_path_new_goal" );
}

follow_path_set_ent( ent )
{
	self set_goal_ent( ent );
	self notify( "follow_path_new_goal" );	
}

follow_path( start_node, require_player_dist )
{
	self endon( "death" );
	self endon( "stop_path" );
	
	self notify( "follow_path" );
	self endon( "follow_path" );

	wait 0.1;

	node = start_node;
	
	getfunc = undefined;
	gotofunc = undefined;
	
	if( !isdefined( require_player_dist ) )
		require_player_dist = 300;
	
	//only nodes dont have classnames - ents do
	if( !isdefined( node.classname ) )
	{
		getfunc = ::follow_path_get_node;
		gotofunc = ::follow_path_set_node;
	}
	else
	{
		getfunc = ::follow_path_get_ent;
		gotofunc = ::follow_path_set_ent;
	}
	
	while( isdefined( node ) )	
	{
		if( isdefined( node.radius ) && node.radius != 0 )
			self.goalradius = node.radius;
		if( self.goalradius < 16 )
			self.goalradius = 16;
		if( isdefined( node.height ) && node.height != 0 )
			self.goalheight = node.height;

		self [[ gotofunc ]]( node );
		
		original_goalradius = self.goalradius;
		//actually see if we're at our goal..._stealth might be tricking us
		while(1)
		{
			self waittill( "goal" );
			if( distance( node.origin, self.origin ) < ( original_goalradius + 10 ) )
				break;
		}
		
		node notify( "trigger", self );

		if( isdefined( node.script_requires_player ) )
		{
			while( isalive( level.player ) )
			{
				if( self wait_for_player( node, getfunc, require_player_dist ) )
					break;
				wait 0.05;
			}
		}

		if( !isdefined( node.target ) )
			break;

		node script_delay();

		node = [[ getfunc ]]( node.target, "targetname" );
		node = node[ randomint( node.size ) ];
	}

	self notify( "path_end_reached" );
}

wait_for_player( node, getfunc, dist )
{
	if( distance( level.player.origin, node.origin ) < distance( self.origin, node.origin ) )
		return true;
		
	vec = undefined;
	//is the player ahead of us?
	vec = anglestoforward( self.angles );
	vec2 = vectornormalize( ( level.player.origin - self.origin ) );
	
	if( isdefined( node.target ) )
	{
		temp = [[ getfunc ]]( node.target, "targetname" );
		
		if( temp.size == 1 )
			vec = vectornormalize( temp[0].origin - node.origin );
		else
			vec = anglestoforward( node.angles );
	}
	else
		vec = anglestoforward( node.angles );
		
	//i just created a vector which is in the direction i want to
	//go, lets see if the player is closer to our goal than we are				
	if( vectordot(vec, vec2) > 0 )
		return true;
	
	//ok so that just checked if he was a mile away but more towards the target
	//than us...but we dont want him to be right on top of us before we start moving
	//so lets also do a distance check to see if he's close behind
	
	if( distance( level.player.origin , self.origin ) < dist )
		return true;
	
	return false;
}

crawl_path( start_node, require_player_dist )
{
	self endon( "death" );
		
	node = start_node;
	
	if( !isdefined( require_player_dist ) )
		require_player_dist = 300;
		
	while( isdefined( node ) )	
	{
		radius = 48;
		if( isdefined( node.radius ) && node.radius != 0 )
			radius = node.radius;
				
		if( node == start_node )
		{
			self setgoalpos( node.origin );
			self.goalradius = 16;
			self waittill( "goal" );	
			
			self allowedstances( "prone" );
			
			goal = getent( node.target, "targetname" );
			vec = goal.origin - self.origin;
			angles =  vectortoangles( vec );

			self.ref_node.origin = self.origin;
			self.ref_node.angles = angles;//( 0, angles[ 1 ], 0 );
			
			self.ref_node anim_generic( self, "stand2prone" );
			self.crawl_ref_node = goal;
			self thread crawl_anim();
		}
		else
		{
			while( distance( self.origin, node.origin ) > radius )
				wait .05;	
		}
						
		node notify( "trigger", self );

		if( !isdefined( node.target ) )
			break;
			
		node = getent( node.target, "targetname" );
		self.crawl_ref_node = node;
	}
		
	self notify( "stop_crawl_anim" );
	self notify( "stop_animmode" );
	self.ref_node notify( "stop_animmode" );
	self stopanimscripted();
	self notify( "path_end_reached" );
	
	self orientMode( "face angle", node.angles[1] + 30 );  
}

crawl_anim()
{
	self notify( "crawl_anim" );
	self endon( "crawl_anim" );
	self endon( "stop_crawl_anim" );
	self endon( "death" );
	
	self thread crawl_anim_stop();
	self thread crawl_anim_rotate();
	
	anime = "crawl_loop";
	
	while( 1 )
	{
		node = self.crawl_ref_node;
		self.ref_node.origin = self.origin;
		self.ref_node anim_generic( self, anime ); 	
	}
}

crawl_anim_rotate()
{
	self endon( "crawl_anim" );
	self endon( "stop_crawl_anim" );
	self endon( "death" );
	
	while( 1 )
	{
		node = self.crawl_ref_node;
		
		vec = node.origin - self.origin;
		angles =  vectortoangles( vec );
		self.ref_node rotateto( angles, .25 );//( 0, angles[ 1 ], 0 );
		wait .25;
	}
}

crawl_anim_stop()
{
	self endon( "crawl_anim" );
	
	self waittill( "stop_crawl_anim" );
	self setgoalpos( self.origin );
}

node_have_delay()
{
	if( !isdefined( self.target ) )
		return true;
	if( isdefined( self.script_delay ) && self.script_delay > 0 )
		return true;
	if( isdefined( self.script_delay_max ) && self.script_delay_max > 0 )
		return true;
	return false;
}

disablearrivals_delayed()
{
	self endon( "death" );
	self endon( "goal" );
	wait 0.5;
	self.disableArrivals = true;
}

delete_on_unloaded()
{
	// todo: see it there is a way to get away from the wait .5;
	self endon( "death" );
	self waittill( "jumpedout" );
	wait .5;
	self delete();
}

fly_path( path_struct )
{
	self notify( "stop_path" );
	self endon( "stop_path" );
	self endon( "death" );

	if( !isdefined( path_struct ) )
		path_struct = getstruct( self.target, "targetname" );

	self setNearGoalNotifyDist( 512 );

	if( !isdefined( path_struct.speed ) )
		self fly_path_set_speed( 30, true );

	while( true )
	{
		self fly_to( path_struct );

		if( !isdefined( path_struct.target ) )
			break;
		path_struct = getstruct( path_struct.target, "targetname" );
	}
}

fly_to( path_struct )
{
	self fly_path_set_speed( path_struct.speed );

	if( isdefined( path_struct.radius ) )
		self setNearGoalNotifyDist( path_struct.radius );
	else
		self setNearGoalNotifyDist( 512 );
		
	stop = false;
	if( isdefined( path_struct.script_delay ) || isdefined( path_struct.script_delay_min ) )
		stop = true;

	if( isdefined( path_struct.script_unload ) )
	{
		stop = true;
		path_struct = self unload_struct_adjustment( path_struct );
		self thread unload_helicopter();
	}

	if( isdefined( path_struct.angles ) )
	{
		if( stop )
			self setgoalyaw( path_struct.angles[ 1 ] );
		else
			self settargetyaw( path_struct.angles[ 1 ] );
	}
	else
		self cleartargetyaw();

	self setvehgoalpos( path_struct.origin +( 0, 0, self.originheightoffset ), stop );

	self waittill_any( "near_goal", "goal" );
	path_struct notify( "trigger", self );

	flag_waitopen( "helicopter_unloading" );	// wait if helicopter is unloading.

	if( stop )
		path_struct script_delay();

	if( isdefined( path_struct.script_noteworthy ) && path_struct.script_noteworthy == "delete_helicopter" ) 
		self delete();
}

fly_path_set_speed( new_speed, immediate )
{
	if( isdefined( new_speed ) )
	{
		accel = 20;
		if( accel < new_speed / 2.5 )
			accel =( new_speed / 2.5 );

		decel = accel;
		current_speed = self getspeedmph();
		if( current_speed > accel )
			decel = current_speed;

		if( isdefined( immediate ) )
			self setspeedimmediate( new_speed, accel, decel );
		else
			self setSpeed( new_speed, accel, decel );
	}
}

unload_helicopter()
{
		/*
		maps\_vehicle::waittill_stable();
		sethoverparams( 128, 10, 3 );
		*/

		self endon( "stop_path" );

		flag_set( "helicopter_unloading" );

		self sethoverparams( 0, 0, 0 );

		self waittill( "goal" );
		self notify( "unload", "both" );
		wait 12;	// todo: the time it takes to unload must exist somewhere.
		flag_clear( "helicopter_unloading" );

		self sethoverparams( 128, 10, 3 );
}

unload_struct_adjustment( path_struct )
{
	ground = physicstrace( path_struct.origin, path_struct.origin +( 0, 0, -10000 ) );
	path_struct.origin = ground +( 0, 0, self.fastropeoffset );
//	path_struct.origin = ground +( 0, 0, self.fastropeoffset + self.originheightoffset );
	return path_struct;
}

dialogprint( string, duration, delay )
{
	if( isdefined( delay ) && delay > 0 )
		wait delay;
	
	iprintln( string );
	
	if( isdefined( duration ) && duration > 0 )
		wait duration;
}

scripted_spawn2( value, key, stalingrad, spawner )
{
	if ( !isdefined( spawner ) )
		spawner = getent( value, key );

	assertEx( isdefined( spawner ), "Spawner with script_noteworthy " + value + " does not exist." );
	
	if ( isdefined( stalingrad ) )
		ai = spawner stalingradSpawn( true );
	else
		ai = spawner dospawn( true );
	spawn_failed( ai );
	assert( isDefined( ai ) );
	return ai;
}

scripted_array_spawn( value, key, stalingrad )
{
	spawner = getentarray( value, key );
	ai = [];

	for ( i=0; i<spawner.size; i++ )
		ai[i] = scripted_spawn2( value, key, stalingrad, spawner[i] );
	return ai;
}

vehicle_turret_think()
{
	self endon( "nolonger_spotted" );
	self endon ("death");
	self endon ( "c4_detonation" );
	self thread maps\_vehicle::mgoff();
	self.turretFiring = false;
	eTarget = undefined;
	aExcluders = [];

	aExcluders[0] = level.price;

	currentTargetLoc = undefined;
	
	//if (getdvar("debug_bmp") == "1")
		//self thread vehicle_debug();

	while (true)
	{
		wait (0.05);
		/*-----------------------
		GET A NEW TARGET UNLESS CURRENT ONE IS PLAYER
		-------------------------*/		
		if ( (isdefined(eTarget)) && (eTarget == level.player) )
		{
			sightTracePassed = false;
			sightTracePassed = sighttracepassed( self.origin, level.player.origin + ( 0, 0, 150 ), false, self );
			if ( !sightTracePassed )
			{
				//self clearTurretTarget();
				eTarget = self vehicle_get_target(aExcluders);
			}
				
		}
		else
			eTarget = self vehicle_get_target(aExcluders);

		/*-----------------------
		ROTATE TURRET TO CURRENT TARGET
		-------------------------*/		
		if ( (isdefined(eTarget)) && (isalive(eTarget)) )
		{
			targetLoc = eTarget.origin + (0, 0, 32);
			self setTurretTargetVec(targetLoc);
			
			if (getdvar("debug_bmp") == "1")
				thread draw_line_until_notify(self.origin + (0, 0, 32), targetLoc, 1, 0, 0, self, "stop_drawing_line");
			
			fRand = ( randomfloatrange(1, 1.5));
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
					
					wait(.25);
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

vehicle_get_target(aExcluders)
{
	eTarget = maps\_helicopter_globals::getEnemyTarget( level.bmpCannonRange, level.cosine[ "180" ], true, true, false, false,  aExcluders);
	return eTarget;
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

music_loop( name, time, _flag )
{
	level notify( "music_loop" );
	musicStop();
	waittillframeend;
	if( isdefined( name ) )
		level.music_loop = name;
	
	thread music_loop_proc( time, _flag );
	
	if( isdefined( _flag ) )
		thread music_loop_fade( _flag ); 
}

music_loop_fade( _flag )
{
	level endon( "music_loop" );
	flag_wait( _flag );
	
	if( flag( "end_kill_music" ) )
		musicstop( 12 );
	else
		musicStop( 6 );
}

music_loop_proc( time, _flag )
{
	level endon( "music_loop" );
	
	if( isdefined( _flag ) )
	{
		if( flag( _flag ) )
			return;
		level endon( _flag );
	}
		
	thread music_loop_stop( time, _flag );
	
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	while( 1 )
	{
		MusicPlayWrapper( level.music_loop ); 
		wait time;
	}
}

music_loop_stop( time, _flag )
{
	level endon( "music_loop" );
	
	if( isdefined( _flag ) )
	{
		if( flag( _flag ) )
			return;
		level endon( _flag );
	}
		
	flag_wait( "_stealth_spotted" );
	musicStop( .5 );
	
	flag_waitopen( "_stealth_spotted" );
	wait 1;
	flag_waitopen( "_stealth_spotted" );
	
	thread music_loop_proc( time );	
}

music_play( musicalias, time )
{
	level notify( "music_loop" );
	// TODO: make current music fade over delay
	if( isdefined( time ) )
	{
		musicStop( time );	
		wait time;
	}
	else
		musicStop();	
		
	MusicPlayWrapper( musicalias ); 
}

teleport_actor( node )
{
	level.player setorigin( level.player.origin + ( 0, 0, -34341 ) );
	self teleport( node.origin, node.angles );
	self setgoalpos( node.origin );	
}

teleport_player( name )
{
	if( !isdefined( name ) )
		name = level.start_point;
	
	nodes = getentarray("start_point","targetname");
	
	for(i=0; i<nodes.size; i++)
	{
		if( nodes[i].script_noteworthy == name)
		{
			level.player setorigin( nodes[i].origin + (0,0,4) );
			level.player setplayerangles( nodes[i].angles );
			return;
		}
	}
}

clip_nosight_logic()
{
	self endon( "death" );
	
	flag_wait( self.script_flag );
	
	self thread clip_nosight_logic2();
	self setcandamage(true);
	
	self clip_nosight_wait();
	
	self delete();	
}

clip_nosight_wait()
{
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	self waittill( "damage" );	
}

clip_nosight_logic2()
{
	self endon( "death" );	
	
	flag_wait_either( "_stealth_spotted", "_stealth_found_corpse" );
	
	self delete();
}

flashbang_from_corner( name, node, angle, magnitude )
{
	node thread anim_generic( self, name );
	
	self delayThread(3.5, ::flashbang_from_corner_nade, angle, magnitude );
	
	node waittill( name );
}

flashbang_from_corner_nade( angle, magnitude )
{
	oldGrenadeWeapon = self.grenadeWeapon;
	self.grenadeWeapon = "flash_grenade";
	self.grenadeAmmo++;
	
	start = self.origin + (30,25,30);
	vec = anglestoforward( angle );
	vec = vector_multiply( vec, magnitude );
	self magicgrenademanual( start, vec, 1.1 );
	
	self.grenadeWeapon = oldGrenadeWeapon;	
	self.grenadeAmmo = 0;
}

initDogs()
{
	dogs = getentarray("stealth_dogs", "targetname");
	array_thread( dogs, ::add_spawn_function, ::stealth_ai);
}

idle_anim_think()
{
	self endon("death");
	
	if( !isdefined( self.target ) )
		return;
	
	node = getent(self.target, "targetname");
	
	if( !isdefined( node.script_animation ) )
		return;
		
	anime = undefined;
	switch( node.script_animation )
	{
		case "coffee":
			anime = "coffee_"; 
			break;
		case "sleep":
			anime = "sleep_"; 
			break;
		case "phone":
			anime = "cellphone_";
			break;
		case "smoke":
			anime = "smoke_";
			break;
		case "lean_smoke":
			anime = "lean_smoke_";
			break;
		default:
			return;
	}
	
	self.allowdeath = true;
	
	node = getent(self.target, "targetname");
	self.ref_node = node;
	
	if( node.script_animation == "sleep" )
	{
		chair = spawn_anim_model( "chair" );
		self.has_delta = true;
		self.anim_props = make_array( chair );
		node thread anim_first_frame_solo( chair, "sleep_react" );
		
		node stealth_ai_idle_and_react( self, anime + "idle", anime + "react" );
	}
	else
		node stealth_ai_reach_and_arrive_idle_and_react( self, anime + "reach", anime + "idle", anime + "react" );
}

dash_door_slow( mod )
{
	children = getentarray( self.targetname, "target" );
	for(i=0; i<children.size; i++)
		children[ i ] linkto( self );
		
	self.old_angles = self.angles;
	self rotateto( self.angles + (0, (70 * mod ),0), 2, .5, 0 );
	self connectpaths();
	self waittill( "rotatedone");	
}

dash_door_super_fast( mod )
{
	children = getentarray( self.targetname, "target" );
	for(i=0; i<children.size; i++)
		children[ i ] linkto( self );
		
	self rotateto( self.angles + (0,( 70 * mod ), 0), ( .1 * abs( mod ) ), ( .05 * abs( mod ) ), 0 );
	self connectpaths();
	self waittill( "rotatedone");
}

dash_door_fast( mod )
{
	children = getentarray( self.targetname, "target" );
	for(i=0; i<children.size; i++)
		children[ i ] linkto( self );
		
	self rotateto( self.angles + (0,( 70 * mod ), 0), ( .3 * abs( mod ) ), ( .15 * abs( mod ) ), 0 );
	self connectpaths();
	self waittill( "rotatedone");
}

door_open_slow()
{
	self.old_angles = self.angles;
	self hunted_style_door_open();
}

door_open_kick()
{
	wait .6;

	self.old_angles = self.angles;
	self playsound ("wood_door_kick");
	self rotateto( self.angles + (0,130,0), .3, 0, .15 );
	self connectpaths();
	self waittill( "rotatedone");
}

door_close()
{
	if( !isdefined( self.old_angles ) )
		return;
	
	self rotateto( self.old_angles, .2);
}

church_lookout_stealth_behavior_alert_level_investigate( enemy )
{
	guy = get_living_ai( "church_smoker", "script_noteworthy" );

	pos = (-34245, -1550, 608);
	self setgoalpos( pos );
	self.goalradius = 16;
	
	self maps\_stealth_behavior::enemy_stop_current_behavior();	
	
	self thread maps\_stealth_behavior::enemy_announce_huh();	
	
	self church_lookout_goto_bestpos( enemy.origin );
	
	self endon( "death" );
	
	if( isdefined( guy ) && isalive( guy ) )
	{
	
		if( !isdefined( enemy._stealth.logic.spotted_list[ guy.ai_number ] ) )
			enemy._stealth.logic.spotted_list[ guy.ai_number ] = 1;
			
		self playsound("RU_0_reaction_casualty_generic");
		
		guy.favoriteenemy = enemy;
	
		guy endon("death");
		
		guy waittill( "enemy" );
	
		guy.favoriteenemy = undefined;
		
		guy waittill( "normal" );
	}
	else
		wait 3;
	
	self thread maps\_stealth_behavior::enemy_announce_hmph();
	self thread maps\_patrol::patrol();
}

church_lookout_goto_bestpos( pos, radius )
{
	if( !isdefined( radius ) )
		radius = 16;
	nodes = getentarray( "church_lookout_aware", "targetname" );
	nodes = get_array_of_closest( pos, nodes );
	
	self setgoalpos( nodes[0].origin );
	self.goalradius = radius;
	self waittill( "goal" );
}

church_lookout_stealth_behavior_alert_level_attack( enemy )
{
	self thread maps\_stealth_behavior::enemy_announce_huh();
	
	self church_lookout_goto_bestpos( enemy.origin, 80 );
	
	pos = ( -35040, -1632, 224 );
	self thread maps\_stealth_behavior::enemy_announce_spotted( pos );
	self thread church_lookout_fire();
}

church_lookout_fire()
{
	self endon( "death" );
	
	self.favoriteenemy = level.player;
	
	wait 5;
	
	while( 1 )
	{
		if( isdefined( self.enemy ) )
		{
			vec1 = anglestoforward( self gettagangles( "tag_flash" ) );
			vec2 = vectornormalize( self.enemy.origin - self.origin );
			dot = vectordot( vec1, vec2 );
			
			if( dot > .75 )
			{
				num = randomintrange( 5, 25 );
				for( i=0; i<num; i++ )
				{	
					self shoot();
					wait .05;
				}	
				
				wait randomfloatrange( 1, 2 );
			}
			else
				wait .1;
		} 	
		else
			wait .1;
	}
}

church_lookout_stealth_behavior_saw_corpse()
{
	self thread maps\_stealth_behavior::enemy_announce_huh();
		
	if( isdefined( level.intro_last_patroller_corpse_name ) )
	{
		corpse = getent( level.intro_last_patroller_corpse_name, "script_noteworthy" );
		if( isdefined( corpse ) )
			level._stealth.logic.corpse.array = array_remove( level._stealth.logic.corpse.array, corpse );
	}
	
	corpse = self._stealth.logic.corpse.corpse_entity;
	
	self clear_run_anim();
	
	self church_lookout_goto_bestpos( corpse.origin );
	
	wait 1;
		
	if( !ent_flag( "_stealth_found_corpse" ) )
		self ent_flag_set( "_stealth_found_corpse" );
	else
		self notify( "_stealth_found_corpse" );

	self thread maps\_stealth_logic::enemy_corpse_found( corpse );
}

church_lookout_stealth_behavior_found_corpse()
{
	flag_wait( "_stealth_found_corpse" );	
	self thread maps\_stealth_behavior::enemy_announce_corpse();
}

church_lookout_stealth_behavior_explosion( type )
{
	self endon("_stealth_enemy_alert_level_change");
	self endon("death");
	level endon("_stealth_spotted");
	
	origin = self._stealth.logic.event.awareness[ type ];
			
	self thread maps\_stealth_behavior::enemy_announce_wtf();
	
	self church_lookout_goto_bestpos( origin );
}

graveyard_hind_find_best_perimeter( name, resumepath )
{
	self endon( "death" );
	self notify( "graveyard_hind_find_best_perimeter" );
	self endon( "graveyard_hind_find_best_perimeter" );
	
	if( !isdefined( resumepath ) )
		resumepath = false;
	
	startold = undefined;
	startcurrent = undefined;
	
	self thread vehicle_detachfrompath();
	
	resumenode = self.currentnode;
	
	while( 1 )
	{
		starts = getstructarray( name, "targetname" );
		startcurrent = get_array_of_closest( level.player.origin, starts )[0];
		
		if( !isdefined( startold ) || startold != startcurrent )
		{
			if( resumepath )
			{
				self graveyard_hind_strafe_path( startcurrent, resumepath );
				break;	
			}
			else	
				self thread graveyard_hind_strafe_path( startcurrent, resumepath, level.player );
		}	
		
		startold = startcurrent;
		
		wait .05;
	}	
	
	self thread vehicle_detachfrompath();
	self.currentnode = resumenode;
	self setspeed( 70, 30, 30 );
	self thread vehicle_resumepath();
}

graveyard_hind_strafe_path( startnode, resumepath, ent )
{
	self endon( "death" );
	self notify( "graveyard_hind_strafe_path" );
	self endon( "graveyard_hind_strafe_path" );
	
	if( isdefined( ent ) )
		self setLookAtEnt( ent );
	
	nodearray = [];
	node = getstruct( startnode.target, "targetname" );
	
	while( isdefined( node ) )
	{
		nodearray[ nodearray.size ] = node;
		
		if( isdefined( node.target ) )
			node = getstruct( node.target, "targetname" );
		else
			node = undefined;
	}
	
	startnode = get_array_of_closest( self.origin, nodearray )[0];
	
	self setspeed( 30, 20, 20 );
	self thread vehicle_dynamicpath( startnode );
	
	if( !resumepath )
		return;
		
	//this is when it starts the loop
	startnode waittill( "trigger" );
	//this is when it ends the loop
	startnode waittill( "trigger" );	
}

graveyard_hind_stinger_logic( once )
{
	self endon( "death" );
	
	flag_clear( "hind_spotted" );
	thread hind_spotted();
	
	if( !isdefined( once ) )
	{
		ent = spawn( "script_model", self.origin );
		ent linkto( self, "tag_origin", (0,0,0), (0,0,0) );
		
		target_set( ent, ( 0,0,-80 ) );
		target_setJavelinOnly( ent, true );
	
		level.player waittill( "stinger_fired" );
		flag_set( "hind_spotted" );
	
		self graveyard_hind_stinger_reaction_wait( 3.5 );
	
		level thread graveyard_hind_stinger_flares_fire_burst( self, 8, 6, 5.0 );
		wait 0.5;
		
		ent unlink();
		vec = maps\_helicopter_globals::flares_get_vehicle_velocity( self );
		ent movegravity( vec, 8 );
	}
	
	
	target_set( self, ( 0,0,-80 ) );
	target_setJavelinOnly( self, true );

	level.player waittill( "stinger_fired" );
	
	flag_set( "hind_spotted" );
	
	self graveyard_hind_stinger_reaction_wait( 3 );
	
	graveyard_hind_stinger_flares_fire_burst( self, 8, 1, 5.0 );
}

hind_spotted()
{
	level endon( "_stealth_spotted" );
	flag_wait( "hind_spotted" );
	flag_set( "_stealth_spotted" );
}

graveyard_hind_stinger_reaction_wait( remainder )
{
	self endon( "death" );
	projectile_speed = 1100 ;
	dist = distance( level.player.origin, self.origin );
	travel_time = dist / projectile_speed - remainder;

	if ( travel_time > 0 )
		wait travel_time;
}

graveyard_hind_stinger_flares_fire_burst( vehicle, fxCount, flareCount, flareTime )
{
	vehicle endon( "death" );
	
	flag_set( "graveyard_hind_flare" );
	
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
	
	delaythread(3, ::flag_clear, "graveyard_hind_flare" );
}

graveyard_church_breakable_flag()
{
	flag_set( "graveyard_church_breakable" );
	wait 2;
	flag_clear( "graveyard_church_breakable" );
}
graveyard_church_breakable()
{
	self setcandamage( true );
	origin = self getorigin();
	
	while( 1 )
	{
		self waittill( "damage", damage, other, direction_vec, P, type );
		
		if( other.classname != "script_vehicle" )
			continue;
		
		if( type == "MOD_PROJECTILE" )
			break;
	}
	
	objs = getentarray( "field_church_tower_model", "targetname" );
	objs = get_array_of_closest( origin, objs, undefined, undefined, 512 );
	for(i=0; i<objs.size; i++)
		objs[i] delete();
	
	if( distance( origin, level.player.origin ) < 512 )
	{
		if ( !isdefined( level.player_view ) )
			level.player setstance( "crouch" );
		level.player setvelocity( (0,1,0) );
		level.player shellshock( "radiation_med", 3 );
	}
	
	if( !flag( "graveyard_church_breakable" ) )
	{
		playfx ( level._effect["church_roof_exp"], origin, origin + (0,0,-1) );
		thread graveyard_church_breakable_flag();
	}	
	
	self delete();
	
	clearallcorpses();	
	
	if( flag( "graveyard_church_ladder" ) )
		return;
	level endon( "graveyard_church_ladder" );
	
	breakladder = false;
	ladders = getentarray( "churchladder" , "script_noteworthy" );
	
	for( i=0; i<ladders.size; i++)
	{
		if( distance( origin, ladders[i].origin ) > 1024 ) 
			continue;
		breakladder = true;
		break;
	}
	
	if( !breakladder )
		return;
		
	for( i=0; i<ladders.size; i++)
		ladders[i] delete();//physicslaunch( ladders[i].origin, (10,20,500) );
	
	ent = getent( "church_ladder_entity", "targetname" );
	ent delete();
	
	array = getentarray( "intelligence_item", "targetname" );
	if( array.size )
	{
		array = get_array_of_closest( origin, array );
		model = getent( array[0].target, "targetname" );
		model hide();
	}	
	
	flag_set( "graveyard_church_ladder" );
}

chopper_ai_mode( eTarget )
{
	self endon( "death" );
	level endon( "air_support_over" );
	
	flag_clear( "heli_gun" );
	flag_clear( "heli_rocket" );
	
	for(;;)
	{
		flag_waitopen( "graveyard_hind_flare" );
		
		wait randomfloatrange( 0.2, 1.0 );
		
		flag_set( "heli_gun" );
		flag_waitopen( "heli_rocket" );
		
		self setVehWeapon( "hind_turret" );
		
		vec1 = anglestoforward( self.angles );
		vec2 = vectornormalize( eTarget.origin - self.origin );
		if( vectordot( vec1, vec2 ) < .25 )
		{
			flag_clear( "heli_gun" );
			continue;
		}
		self thread maps\_helicopter_globals::shootEnemyTarget_Bullets( eTarget );
		self notify_delay( "mg_off", randomfloatrange(2,4) );
		
		flag_clear( "heli_gun" );
	}
}

chopper_ai_mode_missiles( eTarget )
{
	self endon( "death" );
	level endon( "air_support_over" );
	
	target = spawn ("script_origin", eTarget.origin );
	trig = getent( "graveyard_inside_church_trig", "targetname" );
	
	flag_clear( "heli_gun" );
	flag_clear( "heli_rocket" );
	
	for(;;)
	{	
		flag_waitopen( "graveyard_hind_flare" );
		
		wait randomfloatrange( 1, 3 );
		
		flag_set( "heli_rocket" );
		flag_waitopen( "heli_gun" );
		
		vec1 = anglestoforward( self.angles );
		vec2 = vectornormalize( eTarget.origin - self.origin );
		if( vectordot( vec1, vec2 ) < .85 )
		{
			flag_clear( "heli_rocket" );
			continue;
		}	
		iShots = randomintrange( 4, 6 );
				
		trace = bullettrace(self.origin + (0,0,-150), eTarget.origin, true, level.price );
				
		if( !isdefined( trace[ "entity" ] ) || trace[ "entity" ] != level.player )
		{
			//can't see the player
			roof = getentarray( "church_breakable", "targetname" );
			
			//is there a roof?
			if( isdefined( roof ) && roof.size && eTarget istouching( trig ) )
			{
				roof = get_array_of_closest( eTarget.origin, roof );
				target.origin = roof[0] getorigin();	
			}
			else
				target.origin = eTarget.origin + ( 0,0,128 );		
		}
		else
			target.origin = eTarget.origin;
					
		self maps\_helicopter_globals::fire_missile( "ffar_hind", iShots, target, .2 );
		
		flag_clear( "heli_rocket" );
	}
}

clean_previous_ai( _flag, name, type )
{
	flag_wait( _flag );
	flag_waitopen( "_stealth_spotted" );
	//flag_waitopen( "_stealth_found_corpse" );
	
	ai = undefined;
	
	if( !isdefined( name ) )
		ai = getaispeciesarray( "axis", "all" );
	else
		ai = get_living_aispecies_array( name, type );
		
	for( i=0; i<ai.size; i++ )
		ai[i] delete();
}

field_bmp_quake()
{
	self endon( "death" );
	
	time = .1;
	while( 1 )
	{
		Earthquake( .15, time, self.origin, 512 );
		wait time;
	}
}

get_vehicle( name, type )
{
	array = getentarray( name, type );
	vehicle = undefined;
	
	for(i=0; i< array.size; i++)
	{
		if( array[i].classname != "script_vehicle" )
			continue;
		
		vehicle = array[i];
		break;
	}
	return vehicle;
}

fake_radiation()
{	
	while( 1 )
	{
		self waittill( "trigger" );
			
		while( level.player istouching( self ) )
		{
			if( level.radiation_ratepercent < 5 )
				level.radiation_ratepercent = 5;
			else
				level.radiation_ratepercent = 0;
			
			wait .1;
		}
		
		level.radiation_ratepercent = 0;
	}
}

body_splash( guy )
{
	if( flag( "pond_abort" ) )
		return;
	exploder( 6 );
}

pond_handle_backup()
{
	flag_wait( "pond_patrol_spawned" );
	
	pond_handle_backup_wait();
	
	wait 2;
	
	doorright = getent( "pond_door_right", "script_noteworthy" );
	model = getent( doorright.targetname, "target" );
	model linkto( doorright );
	doorleft = getent( "pond_door_left", "script_noteworthy" );	
	model = getent( doorleft.targetname, "target" );
	model linkto( doorleft );
	
	doorright rotateyaw( 130, .3, 0, .15 );
	doorright connectpaths();
	doorleft rotateyaw( -130, .4, 0, .2 );
	doorleft connectpaths();
}

pond_handle_backup_wait()
{
	level endon( "_stealth_spotted" );
	
	type = undefined;
	while(1)
	{
		level waittill( "event_awareness", type );
		
		if( type == "explode" )
			break;
		if( type == "heard_scream" )
			break;
		if( type == "heard_corpse" )
			break;
	}
}

pond_inposition_takeshot( node, msg )
{
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	if( flag( "pond_enemies_dead" ) )
		return;
	level endon( "pond_enemies_dead" );
		
	self endon( "follow_path_new_goal" );
	
	self allowedstances( "prone", "crouch" );
	self ent_flag_clear( "_stealth_stance_handler" );
	
	self.goalradius = 16;
	self waittill( "goal" );
	
	wait .25;
	
	if( !isdefined( msg ) )
		msg = "scoutsniper_mcm_inposition";
		
	self enable_cqbwalk();
		
	ai = get_living_ai_array( "pond_throwers", "script_noteworthy" );
	self cqb_aim( ai[ 0 ] );
	
	if( !flag( "_stealth_event" ) )
		level thread function_stack(::radio_dialogue, msg );
			
	self ent_flag_set( "pond_in_position" );
}

field_bmp_make_followme()
{
	vec = anglestoforward( self.angles );
	pos = self.origin + vector_multiply( vec, -128 );
	spot = spawn( "script_origin", pos );
	
	spot linkto( self );
	self.followme = spot;
}

field_creep_player_calc_movement()
{
	score_move = length( self getVelocity() );
	stance = self._stealth.logic.stance;
	check = (stance == "prone" && score_move == 0 );
	return check; 
}

field_handle_special_nodes()
{
	array_thread( getentarray( "field_jog", "script_noteworthy" ), ::field_handle_special_nodes_jog );	
}

field_handle_special_nodes_jog()
{
	while( 1 )
	{
		self waittill( "trigger", other );
		
		if( isdefined( other.script_animation ) && other.script_animation == "jog" )
		{
			if( !flag( "_stealth_spotted" ) )
			{
				other set_generic_run_anim( "patrol_jog" );	
				other notify( "patrol_walk_twitch_loop" );
				wait 2;
				
				if( isalive( other ) && !flag( "_stealth_spotted" ) )
				{
					other set_generic_run_anim( "patrol_walk", true );	
					other thread maps\_patrol::patrol_walk_twitch_loop();
				}
			}
		}
	}
}

field_enemy_walk_behind_bmp()
{
	self endon("death");
	level endon( "_stealth_spotted" );
	
	//hack job to stop one dude from dying by bmps
	if( self.export == 39 )
		self endon( "end_patrol" );
	
	self set_generic_run_anim( "patrol_walk", true );
	self.disableexits = true;
	self.disablearrivals = true;
	
	ent = getent( self.target, "targetname" );
	self setgoalentity( ent.followme );
	
	while( 1 )
	{
		wait .5;
		
		if( distance( self.origin, ent.followme.origin ) > 60 )	
			continue;
		
		self anim_generic_custom_animmode( self, "gravity", "patrol_stop" );
		self setgoalpos( self.origin );
				
		self anim_generic_custom_animmode( self, "gravity", "patrol_start" ); 
		self setgoalentity( ent.followme );
	}
}	

field_enemy_death()
{
	while( isalive( self ) )
	{
		self waittill( "damage", ammount, other );
		if( other == level.player ) 
		{
			self thread maps\_stealth_behavior::enemy_announce_spotted_bring_team( level.player.origin );
			flag_set( "_stealth_spotted" );
			break;
		}
	}
}

field_enemy_alert_level_1( enemy )
{
	self endon("_stealth_enemy_alert_level_change");
	level endon("_stealth_spotted");
	self endon( "death" );
	
	self thread maps\_stealth_behavior::enemy_announce_huh();
		
	wait 3.5;
	
	self ent_flag_clear( "_stealth_enemy_alert_level_action" );
	self flag_waitopen( "_stealth_found_corpse" );
	
	if( !isdefined( self._stealth.logic.corpse.corpse_entity ) )
		self thread maps\_stealth_behavior::enemy_announce_hmph();	
}

field_enemy_patrol_thread()
{
	self endon( "stop_patrol_thread" );
	self endon( "death" );
	self endon( "attack" );
	
	self thread field_enemy_patrol_thread2();
	
	while( 1 )
	{
		self waittill( "enemy" );
		
		waittillframeend;
		//getting an enemy automatically kills patrol script
	
		if( !issubstr( self.target, "bmp" ) && self ent_flag( "field_walk" ) )
		{
			if( isdefined( self.last_patrol_goal ) )
				self.target = self.last_patrol_goal.targetname;
			self thread maps\_patrol::patrol();
		}
		else
			self set_generic_run_anim( "patrol_walk", true );
	}
}

field_enemy_patrol_thread2()
{
	self endon( "death" );
	self endon( "attack" );
	
	dist = 46;
	distsqrd = dist * dist;
	
	while( distancesquared( level.player.origin, self.origin ) > distsqrd )
		wait .1;
		
	level.player._stealth.logic.spotted_list[ self.ai_number ] = 2;
	self.favoriteenemy = level.player;
}

field_enemy_alert_level_2( enemy )
{
	self endon("_stealth_enemy_alert_level_change");
	level endon("_stealth_spotted");
	self endon( "death" );
	self notify( "stop_patrol_thread" );
	
	self thread maps\_stealth_behavior::enemy_announce_huh();
	
	flag_set( "field_stop_bmps" );
	self clear_run_anim();
	self setgoalpos( enemy.origin );
	self.goalradius = 80;
	
	self waittill( "goal" );
	level.player._stealth.logic.spotted_list[ self.ai_number ] = 2;
	self.favoriteenemy = enemy;
}

field_enemy_awareness( var )
{
	self endon("_stealth_enemy_alert_level_change");
	level endon("_stealth_spotted");
	self endon( "death" );
	self notify( "stop_patrol_thread" );
	
	flag_set( "field_stop_bmps" );
	self clear_run_anim();
	
	level.player._stealth.logic.spotted_list[ self.ai_number ] = 2;
	self.favoriteenemy = level.player;
}

cargo_enemy_attack( enemy )
{	
	self endon ( "death" );
	self endon( "pain_death" );
	
	self thread maps\_stealth_behavior::enemy_announce_spotted( self.origin );
			
	self thread maps\_stealth_behavior::enemy_close_in_on_target();
}

cargo_attack2v2( defender )
{
	self thread cargo_attack2v2_cleanup( defender );
	
	defender endon( "death" );
	defender endon( "_stealth_stop_stealth_logic" );
	
	defender waittill( "stealth_enemy_endon_alert" );	
	self.ignoreall = false;
	self.favoriteenemy = defender;	
}

cargo_attack2v2_cleanup( defender )
{
	defender waittill( "dead" );
	self.ignoreall = true;
	self.favoriteenemy = undefined;
}

cargo_sleeper_wait_wakeup()
{
	self endon( "death" );
	
	self thread stealth_enemy_endon_alert();
	self endon( "stealth_enemy_endon_alert" );
	
	dist = 32;
	distsqrd = dist * dist;
	
	while( distancesquared( self.origin, level.player.origin ) > distsqrd )
		wait .1;
}

cargo_handle_patroller()
{
	array_thread( getentarray( "cargo_patrol_flag_set", "script_noteworthy" ), ::cargo_handle_patroller_flag, true );
	array_thread( getentarray( "cargo_patrol_flag_clear", "script_noteworthy" ), ::cargo_handle_patroller_flag, false );
	trig = getent( "cargo_patrol_kill_flag", "script_noteworthy" );
	trig thread cargo_handle_patroller_kill_trig();
}

cargo_handle_patroller_flag( set )
{
	level endon( "dash_start" );
	
	while( 1 )
	{
		self waittill("trigger");
		if( set )
			flag_set( self.script_flag );
		else
			flag_clear( self.script_flag );
	}
}

cargo_handle_patroller_kill_trig()
{
	self trigger_off();	
	flag_wait( "cargo_price_ready_to_kill_patroller" );
	self trigger_on();	
	
	while( 1 )
	{
		self waittill( "trigger", other );
		
		while( isalive( other ) && other istouching( self ) )
			wait .1;
		
		wait .25;
		
		flag_clear( "cargo_patrol_kill" );
	}
}

cargo_insane_handle_use()
{
	self endon( "trigger" );
	self endon( "death" );
	
	while(1)
	{
		while( level.player._stealth.logic.stance != "prone" )
			wait .05; 
			
		self trigger_off();
		
		while( level.player._stealth.logic.stance == "prone" )
			wait .05;
		
		self trigger_on();
	}
}

cargo_slipby_part1( dist )
{	
	//we came here because the player is either with us or ahead of us
	
	//is he with us?
	if( distance( level.player.origin, self.origin ) <= dist && !flag( "cargo_patrol_dead" )  )
	{	
		//lets tell him to wait
		level function_stack(::radio_dialogue, "scoutsniper_mcm_holdup" );
		
		//is the patrol dead after our dialogue is done?
		if( flag( "cargo_patrol_dead" ) )
			level thread function_stack(::radio_dialogue, "scoutsniper_mcm_letsgo2" );	
		
		//is he too close for us to move?
		else
		if( flag( "cargo_patrol_danger" ) )
		{
			level thread function_stack(::radio_dialogue, "scoutsniper_mcm_patrolthisway" );
			
			cargo_patrol_waitdead_or_flag_open( "cargo_patrol_danger" );
			if( !flag( "cargo_patrol_dead" ) )
				level thread function_stack(::radio_dialogue, "scoutsniper_mcm_waithere2" );
			else 
				level thread function_stack(::radio_dialogue, "scoutsniper_mcm_letsgo2" );		
		}
		//not too close...so we can go
		else
		{
			level thread function_stack(::radio_dialogue, "scoutsniper_mcm_waithere2" );
		}		
	}
	//then tell him to follow us
	else
	{
		//but we should still be smart and wait for the patroller if he's too close
		cargo_patrol_waitdead_or_flag_open( "cargo_patrol_danger" );
		level thread function_stack(::radio_dialogue, "scoutsniper_mcm_followme2" );
	}
}
cargo_slipby_part2( dist )
{
	//we came here because the player is either with us or ahead of us
	flag_set( "cargo_price_ready_to_kill_patroller" );
	
	wait .1;//we do this to give the game a chance to set the flag if the patrol is in the container	
	
	//is he dead?
	if( !flag( "cargo_patrol_dead" ) )
	{
		//ok he's not dead...where is he?
		
		//if this is true - he's either coming into the danger zone or just into the container
		if( !flag( "cargo_patrol_away"  ) && !flag( "cargo_patrol_danger" ) )
		{
			//check the container - if it's empty then he must be coming into the danger zone
			if( !flag( "cargo_patrol_kill" ) )
			{
				if( distance( level.player.origin, self.origin ) <= dist )
					level thread function_stack(::radio_dialogue, "scoutsniper_mcm_anotherpass" );
			}		
			//wait for him to enter the danger zone, go far away, enter the container, or die
			flag_wait_any( "cargo_patrol_away", "cargo_patrol_danger", "cargo_patrol_dead", "cargo_patrol_kill" );
		}
			
		//danger zone?
		if( flag( "cargo_patrol_danger" ) && !flag( "cargo_patrol_dead" ) )
		{
			//is the player near for dialogue?	
			if( distance( level.player.origin, self.origin ) <= dist )
				level thread function_stack(::radio_dialogue, "scoutsniper_mcm_patrolthisway" );
			//wait for him to leave
			cargo_patrol_waitdead_or_flag_open( "cargo_patrol_danger" );
		}		
		//container?
		if( flag( "cargo_patrol_kill" ) && !flag( "cargo_patrol_dead" ) )
		{
			//wait for him to leave or die
			cargo_slipby_kill_patrol();
		}		
	}
	
	//ok so at this point - he's either dead, or coming out of the container or far away
	//if the player is near do this
	if( distance( level.player.origin, self.origin ) <= dist )
	{	
		//whether dead or just gone - the forward area is clear and we're good to go
		level function_stack(::radio_dialogue, "scoutsniper_mcm_forwardclear" );	
		level thread function_stack(::radio_dialogue, "scoutsniper_mcm_go" );
		self.ref_node thread anim_generic( self, "moveout_cornerR" );
		self.ref_node waittill( "moveout_cornerR" );
	}
	//otherwise just let him know where we are
	else
		level thread function_stack(::radio_dialogue, "scoutsniper_mcm_onme" );
}

cargo_slipby_part3( dist )
{
	if( distance( level.player.origin, self.origin ) <= dist )
	{	
		if( !( !flag( "cargo_patrol_away" ) && !flag( "cargo_patrol_dead" ) ) )
		{
			level thread function_stack(::radio_dialogue, "scoutsniper_mcm_shhh" );
			self.ref_node thread anim_generic( self, "stop_cqb" );
			self.ref_node waittill( "stop_cqb" );
		}		
		
		if( !flag( "cargo_patrol_away" ) && !flag( "cargo_patrol_dead" ) )
		{
			level thread function_stack(::radio_dialogue, "scoutsniper_mcm_patrolthisway" );
			
			self allowedstances( "prone" );
			self anim_generic_custom_animmode( self, "gravity", "stand2prone" );
			self setgoalpos( self.origin );
									
			flag_wait_any( "cargo_patrol_dead", "cargo_patrol_away", "cargo_patrol_kill" );
			
			self allowedstances( "prone", "crouch", "stand" );
			level thread function_stack(::radio_dialogue, "scoutsniper_mcm_moveup" );	
		}
			
		else
		{
			self.ref_node thread anim_generic( self, "moveup_cqb" );
			level function_stack(::radio_dialogue, "scoutsniper_mcm_stayhidden" );
			level thread function_stack(::radio_dialogue, "scoutsniper_mcm_moveup" );	
		}
	}			
}

cargo_slipby_kill_patrol()
{
	if( flag( "cargo_patrol_kill" ) )
	{
		self.ignoreall = false;
		self.favoriteenemy = get_living_ai( "cargo_patrol", "script_noteworthy" );//its ok if we set him to undefined
		cargo_patrol_waitdead_or_flag_open( "cargo_patrol_kill" );
		self.ignoreall = true;
		self.favoriteenemy = undefined;
		return true;
	}	
	return false;
}

cargo_patrol_waitdead_or_flag_set( _flag )
{
	if( flag( "cargo_patrol_dead" ) )
		return;
	level endon( "cargo_patrol_dead" );
	
	flag_wait( _flag );
}	

cargo_patrol_waitdead_or_flag_open( _flag )
{
	if( flag( "cargo_patrol_dead" ) )
		return;
	level endon( "cargo_patrol_dead" );
	
	flag_waitopen( _flag );
}

dash_ai()
{
	self endon( "death" );
	self.ignoreall = true;
	
	flag_wait( "dash_start" );	
	
	self.ignoreall = false;
	if( !isdefined( self.script_moveoverride ) )
		return;
	
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	self endon( "death" );
	
	self waittill( "jumpedout" );
	
	ent = getent( self.target, "targetname" );
	
	if( isdefined( ent.target ) )
		self thread maps\_patrol::patrol();	
	else
		self thread dash_idler();
}

dash_intro_runner()
{
	self endon( "death" );
	self thread dash_intro_common();	
}

dash_intro_patrol()
{
	self endon( "death" );
	self thread dash_intro_common();
	
	self.disableexits = true;
	self set_generic_run_anim( "patrol_walk", true );
}

dash_intro_common()
{
	self endon( "death" );
//	self.ignoreall = true;
	self.fixednode = false;
	self.goalradius = 4;
	
	flag_wait( "dash_start" );
	
	ent = getent( self.target, "targetname" );
	
	self thread follow_path( ent );
	self thread deleteOntruegoal();
}

dash_idler()
{
	self.disableexits = true;
	self set_generic_run_anim( "patrol_walk", true );
	self.fixednode = false;
	self.goalradius = 64;	
	
	ent = getent( self.target, "targetname" );
	
	self thread follow_path( ent );
	
	node = getent( self.target, "targetname" );
	
	while( 1 )
	{		
		self set_goal_pos( node.origin );
		self waitOntruegoal( node );
		
		if( !isdefined( node.target ) )
			break;
						
		node = getent( node.target, "targetname" );
	}
	
	self.target = node.targetname;	
	self thread idle_anim_think();		
}

dash_fake_easy_mode()
{
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
		
	if( flag( "dash_sniper" ) )
		return;
	level endon( "dash_sniper" );
	
	level.player endon( "death" );
	
	move = [];
	move[ "stand" ] = 0;
	move[ "crouch" ] = 0;
	move[ "prone" ] = 2;
	
	hidden = [];
	hidden[ "prone" ]	= 70;
	hidden[ "crouch" ]	= 400;
	hidden[ "stand" ]	= 600;
	
	alert = [];
	alert[ "prone" ]	= 90;
	alert[ "crouch" ]	= 600;
	alert[ "stand" ]	= 900;
	
	dist = 160;
	distsqrd = dist * dist;
	
	while( isalive( level.player ) )
	{
		level.player stealth_friendly_movespeed_scale_set( move, move );
		stealth_detect_ranges_set( hidden, alert );
		
		while( distancesquared( level.player.origin, level.price.origin ) <= distsqrd )
			wait .1;
		
		level.player stealth_friendly_movespeed_scale_default();
		stealth_detect_ranges_default();
		
		while( distancesquared( level.player.origin, level.price.origin ) > distsqrd )
			wait .1;
	}
}

dash_run_check()
{
	self waittill( "trigger" );
	flag_set( self.script_flag );
}

dash_handle_price_stop_bullet_shield()
{
	level.price endon( "death" );
	level.player endon( "death" );
	level endon( "dash_reset_stealth_to_default" );
	
	flag_wait( "dash_spawn" );
	
	level.price stop_magic_bullet_shield();	
	level.price.maxhealth = 1;
	level.price.health = 1;	
	
	
	flag_wait( "_stealth_spotted" );
	wait 6;
	level.price dodamage( level.price.health + 100, level.price.origin );
}

dash_handle_doors_blowopen()
{
	level endon( "dash_door_L_open" );
	
	flag_wait( "dash_spawn" );
		
	wait .05;//wait for the ai to spawn
	
	//put this above the _stealth spotted so we have a guy
	//and can get his origin - you put it later and he might
	//be dead.
		guys = get_living_ai_array( "dash_intro_runner" , "script_noteworthy" );
		dude = undefined;
		
		for( i=0; i<guys.size; i++)
		{
			if( guys[ i ].classname != "actor_enemy_merc_AT_RPG7" )
				continue;
			
			dude = guys[i];
			break;	
		}
		start = dude.origin + (0,0,75);
	
	
	flag_wait( "_stealth_spotted" );
	
	doorR = getent( "dash_door_right", "script_noteworthy" );	
	doorL = getent( "dash_door_left", "script_noteworthy" );
	
	
	
	end = doorR getorigin();
	vec = vectornormalize( end - start );
	vec = vector_multiply( vec, 48 );
	start += vec;
	
	magicbullet( "rpg", start, end );	
	
	wait .5;
	
	if( !flag( "dash_door_R_open" ) )
		doorR thread dash_door_super_fast( -.85 );
	else
		doorR thread dash_door_super_fast( .35 );
		
	if( !flag( "dash_door_L_open" ) )
		doorL thread dash_door_super_fast( .95 );
}

dash_handle_nosight_clip()
{
	flag_wait( "dash_spawn" );
	
	flag_wait_either( "_stealth_spotted", "dash_start" );
	
	if( !flag( "_stealth_spotted" ) )
		flag_wait_or_timeout( "_stealth_spotted", 5 );
	
	clip = getent( "dash_nosight_clip", "targetname" );
	clip delete();	
}

dash_crawl_patrol()
{
	flag_set( "dash_crawl_patrol_spawned" );
	
	offset = ( 24281, -4069.5, -330.5 );
	model = spawn( "script_model", (-21828, 3997, 249) + offset );
	model.angles = (0.17992, 214.91, 1.77098);
	model setmodel( "vehicle_bm21_mobile_cover" );
	model hide();
	
	self linkto( model, "tag_detach" );
	self.allowdeath = true;
	
	anime = undefined;
	if( self.script_startingposition == 9 )
		anime = "bm21_unload2";
	else
		anime = "bm21_unload1";
		
	model anim_generic( self, anime, "tag_detach" );
	
	model delete();
}

dash_state_hidden()
{
	level endon("_stealth_detection_level_change");
	
	self.fovcosine = .86;//30 degrees to either side...60 cone. //DEFAULT is 60 degrees and 120 cone
	self.favoriteenemy = undefined;
	
	if( self._stealth.logic.dog )
		return;
		
	self.dieQuietly = true;
	if( !isdefined( self.old_baseAccuracy ) )
		self.old_baseAccuracy = self.baseaccuracy;
	if( !isdefined( self.old_Accuracy ) )
		self.old_Accuracy = self.accuracy;
		
	self.baseAccuracy 	= self.old_baseAccuracy;
	self.Accuracy 		= self.old_Accuracy;
	self.fixednode		= true;
	self clearenemy();
}

dash_sniper_death()
{
	flag_set( "dash_sniper" );
	
	if( dash_sniper_player_weapon_check() )
	{
		self delete();	
		flag_set( "dash_sniper_dead" );	
		return;
	}
	
	self ent_flag_init( "death_anim" );
	
	self thread dash_sniper_anim();
	
	range = [];
	range[ "prone" ]	= 1300;
	range[ "crouch" ]	= 1600;
	range[ "stand" ]	= 1800;
	stealth_detect_ranges_set( range, range );
	move = [];
	move[ "stand" ] = 0;
	move[ "crouch" ] = 0;
	move[ "prone" ] = 2;
	level.player stealth_friendly_movespeed_scale_set( move, move );
	
	self.health = 10000;
	self waittill( "damage", ammount, other );
	self notify ( "_stealth_stop_stealth_logic" );
	
	node = getnode( self.target, "targetname" );
	
	if( self ent_flag( "death_anim" ) )
	{
		node thread anim_generic( self, "balcony_death" );
		delaythread( 1.2, ::rag_doll, self );
	}
	else
		self dodamage( self.health + 100, other.origin );
		
	flag_set( "dash_sniper_dead" );	
	
	if( !flag( "_stealth_spotted" ) )
	{
		radio_dialogue_stop();
		if( flag( "dash_last" ) )
			level thread function_stack(::radio_dialogue, "scoutsniper_mcm_beautiful" );
		else
		{
			flag_set( "dash_work_as_team" );
			level thread function_stack(::radio_dialogue, "scoutsniper_mcm_ateam" );
		}
	}
}

dash_sniper_player_weapon_check()
{
	weapList = level.player GetWeaponsList();
	goodWeap = [];
	goodWeap[ goodWeap.size ] = "m14_scoped_silencer";
	goodWeap[ goodWeap.size ] = "p90_silencer";
	if( level.gameskill > 0 )
		goodWeap[ goodWeap.size ] = "usp_silencer";
	
	for( i=0; i<weapList.size; i++ )
	{ 
		for( j=0; j<goodWeap.size; j++ )
		{
			if( weapList[ i ] != goodWeap[ j ] )
				continue;
			
			ammo = level.player GetWeaponAmmoStock( weapList[ i ] );
			ammo += level.player GetWeaponAmmoClip( weapList[ i ] );
		
			if( ammo <= 0 )
				continue;
				
			return false;	
		}			
	}
	return true;	
}

#using_animtree("generic_human");
dash_sniper_anim()
{
	self endon( "death" );
	
	self waittill( "goal" );
	self ent_flag_set( "death_anim" );
	
	self waittill( "_stealth_enemy_alert_level_change" );
	self ent_flag_clear( "death_anim" );
}

dash_sniper_alert( enemy )
{
	node = getnode( "dash_sniper_node", "targetname" );
	
	self thread maps\_stealth_behavior::enemy_announce_huh();
	
	self setgoalnode( node );
	self.goalradius = 32;
}

dash_sniper_attack( enemy )
{
	node = getnode( "dash_sniper_node", "targetname" );
	
	self thread maps\_stealth_behavior::enemy_announce_spotted( enemy.origin );
			
	self setgoalnode( node );
	self.goalradius = 32;
}

dash_handle_heli()
{
	thread dash_Hind();
	level endon( "_stealth_spotted" );
	
	node = getent( "dash_heli_land", "script_noteworthy" );
	node waittill( "trigger", heli );
	heli endon( "death" );
	
	heli thread dash_heli_liftoff();
	
	heli vehicle_land();
}

dash_heli_liftoff()
{
	self endon( "death" );
	flag_wait( "_stealth_spotted" );
	flag_set( "dash_heli_agro" );
	
	self vehicle_liftoff( 512 );
}

dash_Hind()
{
	ent = getent( "dash_heli_path", "targetname" );
	ent waittill( "trigger" );		
	hind = get_vehicle( "dash_hind", "targetname" );
	
	hind add_wait( ::waittill_msg,  "death" );
	level add_func( ::flag_set, "dash_hind_down" );
	level add_func( ::flag_clear, "dash_heli_agro" );
	thread do_wait();
	
	level.hind = hind;
		
	hind endon( "death" );
	
	hind thread dash_hind_detect_damage();
	hind thread dash_hind_distance_logic();
	hind thread graveyard_hind_stinger_logic( true );
	
	flag_wait( "_stealth_spotted" );
	
	hind thread dash_hind_attack_enemy();
}

dash_hind_distance_logic()
{
	self endon( "death" );
	
	dist = 600;
	dist2rd = dist * dist;
	
	while( distancesquared( level.player.origin, self.origin ) > dist2rd )
		wait .25;
		
	flag_set( "_stealth_spotted" );	
}

dash_hind_attack_enemy()
{
	self endon( "death" );
	
	self thread graveyard_hind_find_best_perimeter( "dash_hind_circle_path" );
	
	wait 10;
	
	self thread chopper_ai_mode( level.player );
}

dash_stander()
{
	if( !isdefined( self.target ) )
		return;
		
	node = getent( self.target, "targetname" );
	wait .15;
	
	self.goalradius = 4;
	self orientMode( "face angle", node.angles[1] + 35); 
}

dash_handle_stealth_unsure()
{
	level endon( "town_no_turning_back" );
	
	while( 1 )
	{
		level waittill_either("_stealth_enemy_alert_level_change", "dash_heli_agro" );	
		
		flag_set( "dash_stealth_unsure" );
		
		wait 10;
		
		flag_waitopen( "_stealth_spotted" );
		flag_waitopen( "dash_heli_agro" );
		
		flag_clear( "dash_stealth_unsure" );
	}
}

dogs_eater_eat()
{
	self endon( "death" );
	self endon( "dog_mode" );

	if( self.mode == "eat" )
		return;
	self.mode = "eat";
	
	self.allowdeath = true;
	
	self notify( "stop_loop" );
	self.ref_node notify( "stop_loop" );

	self.ref_node.angles = self.angles;
	self linkto( self.ref_node );
	
	self.ref_node thread anim_generic_loop( self, "dog_idle" );
	wait randomfloatrange( 1, 3 );
	self.ref_node notify( "stop_loop" );
	
	self.ref_node rotateto( self.ref_angles, .4 );
	
	while( 1 )
	{	
		self playsound( "anml_dog_eating_body" );	
		self.ref_node anim_generic( self, "dog_eating_single" );
	}
}

dogs_eater_growl()
{
	self endon( "death" );
	self notify( "dog_mode" );
	
	if( self.mode == "growl" )
		return;
	self.mode = "growl";
	
	self.allowdeath = true;
	
	self unlink();
	
	self notify( "stop_loop" );
	self.ref_node notify( "stop_loop" );
	self stopanimscripted();
	
	//self.ref_node thread anim_generic_loop( self, "dog_growling" );
	
	self setgoalpos( self gettagorigin( "tag_origin" ) );
	
	wait 0.05;	// HACK: stopanimscripted waits clears orientation on next think
	self orientmode( "face angle", self.angles[1] );

	self stopsounds();
}

dogs_eater_bark()
{
	self endon( "death" );
	self notify( "dog_mode" );
	
	if( self.mode == "bark" )
		return;
	self.mode = "bark";
	
	self.allowdeath = true;
	
	self unlink();
	
	self notify( "stop_loop" );
	self.ref_node notify( "stop_loop" );
	self stopanimscripted();
	
	//self.ref_node thread anim_generic_loop( self, "dog_barking" );
	
	self stopsounds();
}

break_glass()
{
	wait randomfloat( .5 );
	
	origin = self getorigin();
	
	direction_vec = (0,-1,0);
				
	thread play_sound_in_space( "veh_glass_break_small" , origin);
	playfx( level._effect["glass_break"], origin, direction_vec);
	
	self delete();
}

center_heli_quake( msg )
{
	level endon( msg );
	
	while( 1 )
	{
		wait .1;
		earthquake(0.25, .1, self.origin, 2000);
	}
}

price_death()
{
	level endon( "missionfailed" );
	level.player endon( "death" );
		
	self waittill( "death", other );
	
	radio_dialogue_stop();
	
	quote = undefined;
	
	if( isplayer( other ) )
		quote = &"SCOUTSNIPER_FRIENDLY_FIRE_WILL_NOT";
	else
		quote = &"SCOUTSNIPER_YOUR_ACTIONS_GOT_CPT";
			 
	setDvar("ui_deadquote", quote );
	thread maps\_utility::missionFailedWrapper();	
}

price_left_behind()
{
	radio_dialogue_stop();
	
	quote = &"SCOUTSNIPER_LEFT_BEHIND";
	setDvar("ui_deadquote", quote );
	thread maps\_utility::missionFailedWrapper();		
}

deleteOntruegoal()
{
	self endon( "death" );
		
	node = getnodearray( self.target, "targetname" );
	getfunc = undefined;
	
	if( node.size )
		getfunc = ::follow_path_get_node;
	else
	{
		node = getentarray( self.target, "targetname" );
		getfunc = ::follow_path_get_ent;	
	}	
	
	while( isdefined( node[0].target ) )
		node = [[ getfunc ]]( node[0].target, "targetname" );
		
	self waitOntruegoal( node[0] );	
	
	anime = "smoke_";
	if( !isdefined( self.script_parameters ) )
		self delete();
	else
		self stealth_ai_idle_and_react( self, anime + "idle", anime + "react" );
}

waitOntruegoal( node )
{	
	radius = 16;
	if( isdefined( node.radius ) && node.radius != 0 )
		radius = node.radius;
	while( 1 )
	{
		self waittill( "goal" );
		if( distance( self.origin, node.origin ) < radius + 10 )
			break;
	}		
}

field_waittill_player_near_price()
{
	while( 1 )
	{
		if( distance( level.player.origin, level.price.origin ) < 256 )
			return;
		
		vec1 = anglestoforward( level.price.angles );
		vec2 = vectornormalize( level.player.origin - level.price.origin );
		
		if( vectordot( vec1, vec2 ) > .1 )
			return;
		
		wait .1;
	}	
}

field_waittill_player_passed_guards()
{
	while( 1 )
	{
		angles = (0,225,0);
		vec = anglestoforward( angles );
		
		ai = get_living_ai_array( "field_guard", "script_noteworthy" );
		ai = array_combine( ai, get_living_ai_array( "field_guard2", "script_noteworthy" ) );
		
		stop = true;
		
		for( i=0; i<ai.size; i++)
		{
			vec2 = vectornormalize( level.player.origin - ai[ i ].origin );
			if( vectordot( vec2, vec ) < 0 )
				continue;
			
			stop = false;
		}
		
		if( stop )
			return;
		
		wait .1;
	}	
}

kill_self( guy )
{
	guy endon( "death" );
	
	wait .1;//for no death to be sent
	guy.allowdeath = true;
	guy animscripts\shared::DropAllAIWeapons();
	guy dodamage( guy.health + 200, guy.origin );
}

melee_kill( guy )
{
	guy playsound( "melee_swing_large" );
	
	alias = "generic_pain_russian_" + guy.favoriteenemy._stealth.behavior.sndnum;
	
	guy.favoriteenemy playsound( alias );
	guy.favoriteenemy playsound( "melee_hit" );
	guy.favoriteenemy.allowdeath = false;
	guy.favoriteenemy notify( "anim_death" );
	
	thread kill_self( guy.favoriteenemy );
	
	level delaythread( .75, ::function_stack, ::radio_dialogue, "scoutsniper_mcm_howitsdone" );
	
}

rag_doll_death( guy )
{		
	guy thread killed_by_player( true );	
}

killed_by_player( ragdoll )
{
	//self endon( "anim_death" );
	
	self notify( "killed_by_player_func" );
	self endon( "killed_by_player_func" );
	
	while( 1 )
	{
		self waittill( "death", other );
		if( isdefined( other ) && other == level.player )
			break;
	}
	self notify( "killed_by_player" );	
	if( isdefined( ragdoll ) )
	{
		self animscripts\shared::DropAllAIWeapons();
		self startragdoll();	
	}
}

rag_doll( guy )
{
	guy playsound( "generic_pain_russian_1" );
	guy thread animscripts\shared::DropAllAIWeapons();
	guy.a.nodeath = true;
	guy dodamage( guy.health + 100, level.player.origin );
	guy startragdoll();	
}

empty_function( var )
{
	
}

default_corpse_dialogue()
{
	while( 1 )
	{
		flag_wait( "_stealth_found_corpse" );
		
		if( level.player.health <= 0 )
			return;
		
		wait randomfloatrange( .5, 1 );
		
		if( !flag( "_stealth_spotted" ) )
		{
			//check to see if only 1 is alive
			ai = getaispeciesarray( "axis", "all" );
			if( ai.size < 2 )
				level thread function_stack(::radio_dialogue, "scoutsniper_mcm_nooneleft" );
			else
				level thread function_stack(::radio_dialogue, "scoutsniper_mcm_goloud" );
		}
		
		flag_waitopen( "_stealth_found_corpse" );
	}
}

intro_tableguys_event_awareness()
{
	maps\_stealth_behavior::default_event_awareness( ::default_event_awareness_dialogue, "intro_left_area" );
}

church_event_awareness()
{
	maps\_stealth_behavior::default_event_awareness( ::default_event_awareness_dialogue, "intro_left_area", "church_door_open", "church_area_clear" );
}

default_event_awareness_dialogue()
{	
	if( flag( "_stealth_found_corpse" ) )
		return;
	level endon( "_stealth_found_corpse" );
	
	wait randomfloatrange( .5, 1 );
	
	switch( randomint( 3 ) )
	{
		case 0:
			level thread function_stack(::radio_dialogue, "scoutsniper_mcm_letthemmove" );
			break;
		case 1:
			level thread function_stack(::radio_dialogue, "scoutsniper_mcm_anythingstupid" );
			break;
		case 2:
			level thread function_stack(::radio_dialogue, "scoutsniper_mcm_notontous" );
			break;	
	}
}

centerLineThread( string, size, interval )
{
	level notify("new_introscreen_element");
	
	if( !isdefined( level.intro_offset ) )
		level.intro_offset = 0;
	else
		level.intro_offset++;
		
	y = maps\_introscreen::_CornerLineThread_height();
	
	hudelem = newHudElem();
	hudelem.x = 0;
	hudelem.y = 0;
	hudelem.alignX = "center";
	hudelem.alignY = "middle";
	hudelem.horzAlign= "center";
	hudelem.vertAlign = "middle";
	hudelem.sort = 1; // force to draw after the background
	hudelem.foreground = true;
	hudelem setText( string );
	hudelem.alpha = 0;
	hudelem fadeOverTime( 0.2 ); 
	hudelem.alpha = 1;

	hudelem.hidewheninmenu = true;
	hudelem.fontScale = 1.6;
	hudelem.color = (0.8, 1.0, 0.8);
	hudelem.font = "objective";
	hudelem.glowColor = (0.3, 0.6, 0.3);
	hudelem.glowAlpha = 1;
	duration = int((size * interval * 1000) + 3000);
	hudelem SetPulseFX( 30, duration, 700 );//something, decay start, decay duration

	thread maps\_introscreen::hudelem_destroy( hudelem );
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

create_credit_element( shader_name )
{
	overlay = newHudElem();
	overlay.x = 0;
	overlay.y = 0;
	overlay setshader ( shader_name, 512, 256);
	overlay.alignX = "center";
	overlay.alignY = "middle";
	overlay.horzAlign = "center";
	overlay.vertAlign = "middle";
	overlay.alpha = 0;
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
	self notify("exp_fade_overlay");
	self endon("exp_fade_overlay");
	
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

blur_overlay( target, time )
{
	setblur( target, time );	
}

player_prone_DOF()
{
	while(1)
	{
		level.player setDefaultdepthoffield();
			
		while( level.player._stealth.logic.stance != "prone" )
			wait 0.05;
		
		level.player setPronedepthoffield();
			
		while( level.player._stealth.logic.stance == "prone" )	
			wait 0.05;	
	}
}

initProneDOF()
{
	//wait .05;
	level.dofProne["nearStart"] = 10;
	level.dofProne["nearEnd"] = 50;
	level.dofProne["nearBlur"] = 6;
	
	level.dofReg["nearStart"] = level.dofDefault["nearStart"];
	level.dofReg["nearEnd"] = level.dofDefault["nearEnd"];
	level.dofReg["nearBlur"] = level.dofDefault["nearBlur"];
}

setDefaultdepthoffield()
{
	level.dofDefault["nearStart"] 	= level.dofReg["nearStart"];
	level.dofDefault["nearEnd"] 	= level.dofReg["nearEnd"];
	level.dofDefault["nearBlur"] 	= level.dofReg["nearBlur"];
	
	level.player setViewModelDepthOfField( 0, 0 );
	
	level.player maps\_art::setdefaultdepthoffield();	
}

setPronedepthoffield()
{
	level.dofDefault["nearStart"] 	= level.dofProne["nearStart"];
	level.dofDefault["nearEnd"] 	= level.dofProne["nearEnd"];
	level.dofDefault["nearBlur"] 	= level.dofProne["nearBlur"];
	
	level.player setViewModelDepthOfField( 10, 50 );
		
	level.player maps\_art::setdefaultdepthoffield();
}

try_save( name )
{
	thread try_save_proc( name );	
}

try_save_proc( name )
{
	level notify( "try_save" );
	level endon( "try_save" );
		
	if( flag( "_stealth_spotted" ) )
		return;
	if( flag( "_stealth_alert" ) )
		return;
	if( flag( "_stealth_found_corpse" ) )
		return;
	
	level endon( "_stealth_spotted" );
	level endon( "_stealth_alert" );
	
	level endon( "event_awareness" );
	level endon( "_stealth_found_corpse" );
	level endon( "_stealth_saw_corpse" );
	
	level thread notify_delay( "kill_save", 5 );
	level endon( "kill_save" );
	
	
	if( flag( "player_threw_nade" ) )
	{		
		flag_waitopen_or_timeout( "player_threw_nade", 4 );
	
		if( flag( "player_threw_nade" ) )
			return;
		level endon( "player_threw_nade" );
		wait 1;
		
	}
	level endon( "player_threw_nade" );
	
	
	if( flag( "_radiation_poisoning" ) )
	{ 
		flag_waitopen_or_timeout( "_radiation_poisoning", 4 );
		
		if( flag( "_radiation_poisoning" ) )
			return;
		level endon( "_radiation_poisoning" );
		wait 1;
	}
	level endon( "_radiation_poisoning" );
	
	
	waittillframeend;//so the endon doesn't trigger on the line below
	while(  issubstr( "stinger", level.player getcurrentweapon() ) )
		wait .1;	
	
	autosave_by_name( name );
}

player_grenade_check()
{
	flag_init( "player_threw_nade" );
	level.player_nades = 0;
	level.player notifyOnCommand( "player_frag", "+frag" );
	
	while( 1 )
	{
		level.player waittill ( "player_frag" );
		
		flag_set( "player_threw_nade" );
			
		level.player waittill ( "grenade_fire", grenade );
		
		thread player_grenade_check2( grenade );		
	}
}

player_grenade_check2( grenade )
{
	level.player_nades++;
	
	
	grenade waittill_notify_or_timeout ( "death", 10 );	
	
	level.player_nades--;
	
	if( !level.player_nades )
		flag_clear( "player_threw_nade" );
}

jumptoActor(org)
{
	self notify("overtakenow");
	self unlink();
	self stopanimscripted();
	link = spawn("script_origin", self.origin);
	self linkto(link);
	link moveto(org, .2);
	
	wait .25;
	
	self unlink();
	link delete();
	self.loops = 0;

	self setgoalpos(org);
	self.goalradius = 16;
	
	self waittill_notify_or_timeout("goal", 1.25);
	wait .1;
	self setgoalpos(org);
	self.goalradius = 16;
}

default_spotted_dialogue()
{
	level endon( "dogs_dog_dead" );
	
	while( 1 )
	{
		flag_wait( "_stealth_spotted" );
		
		if( level.player.health <= 0 )
			return;
		
		radio_dialogue_stop();
		if( flag( "dogs_dog_dead" ) )
			radio_dialogue( "scoutsniper_mcm_dogsingrass" );	
		else
			radio_dialogue( "scoutsniper_mcm_spotted" );	
		
		flag_waitopen( "_stealth_spotted" );
	}
}

pond_dump_bodies()
{
	spawner = getent( "pond_deadguy1", "script_noteworthy" );
	flag_wait( "pond_thrower_spawned" );	
	
	thread pond_create_body_piles();
	
	flag_init( "pond_abort" );
	
	level endon( "pond_abort" );
	
	ai = get_living_ai_array( "pond_throwers", "script_noteworthy" );
	guy1 = ai[0];
	guy2 = ai[1];
	
	guy1 thread pond_dump_bodies_check_abort();
	guy2 thread pond_dump_bodies_check_abort();
	
	guy1 endon( "death" );
	guy2 endon( "death" );
	
	guy2 waittill( "jumpedout" );
	
	wait 2;
	
	truck = get_vehicle( "pond_truck", "script_noteworthy" );
		
	origin = truck.origin;
	vec = anglestoforward( truck.angles );
	vec = vector_multiply( vec, -1 );
	
	//angles = vectortoangles( vec );
	
	vec = vector_multiply( vec, 330 );
	origin += ( vec + (0,0,16) );
	
	//vec = vector_multiply( vec, 190 );
	//origin += ( vec + (0,0,76) );
	
	
	spot = spawn("script_origin", origin );
	spot.angles = (0,180,0);
	//spot.angles = angles;
	
	num = 1;
	
	guy1.allowdeath = true;
	guy2.allowdeath = true;
	
	while( 1 )
	{		
		guy1 notify( "single anim", "end" );
		
		spot thread anim_generic( guy1, "bodydump_guy1" );
		spot thread pond_dump_createbody( "deadguy_throw1" );
		spot thread pond_dump_2nd( guy1 );
		//spot delaythread(10.75, ::pond_dump_createbody, "deadguy_throw2" );
		spot anim_generic( guy2, "bodydump_guy2" );
	}
}

pond_dump_2nd( guy )
{
	guy endon( "death" );
	guy waittillmatch( "single anim", "start_deadbody" );
	self pond_dump_createbody( "deadguy_throw2" );
}

pond_create_body_piles()
{
	offset = ( 24281, -4069.5, -330.5 );
	pond_create_body_pile( (-27269, 3850, 194) + offset );
	pond_create_body_pile( (-27210, 3900, 198) + offset, (6,90,-6 ), true );
	pond_create_body_pile( (-27430, 3900, 180) + offset, (8,120,0) );
}

#using_animtree("generic_human");
pond_create_body_pile( origin, angles, notlastguy )
{
	link = spawn( "script_origin", origin );
	link.angles = (0,0,0);
	
	guy = pond_create_drone( link, origin, (0,0,0) );
	guy useAnimTree( #animtree );
	guy setanim( %covercrouch_death_1 );
		
	guy = pond_create_drone( link, origin + (-25,0,0), (0,0,0) );
	guy useAnimTree( #animtree );
	guy setanim( %covercrouch_death_2 );
	
	guy = pond_create_drone( link, origin + (-20,40,0), (0,-135,0) );
	guy useAnimTree( #animtree );
	guy setanim( %covercrouch_death_3 );
	
	if( !isdefined( notlastguy ) )
	{
		guy = pond_create_drone( link, origin + (-45,20,-5), (6,90,0) );
		guy useAnimTree( #animtree );
		guy setanim( %corner_standR_death_grenade_slump );
	}
	
	if( isdefined( angles ) )
	{
		link rotateto( angles, .1 );
		wait .15;
	}
	link delete();
}

pond_create_drone( link, origin, angles )
{
	spawner = getent( "pond_deadguy1", "script_noteworthy" );
	spawner.count = 1;
	ai = dronespawn( spawner );
	ai.script_noteworthy = undefined;
	ai.ignoreall = true;
	ai.ignoreme = true;
	ai.team = "neutral";
	ai detach( getWeaponModel( "ak47" ), "TAG_WEAPON_RIGHT" );
	ai.origin = origin;
	ai.angles = spawner.angles + angles;
	ai linkto( link );
	wait .05;
	return ai;
}

pond_dump_bodies_check_abort()
{	
	self endon( "death" );
	self gun_remove();
	
	self thread stealth_enemy_endon_alert();
	self thread pond_dump_bodies_abort_thrower();	
	self thread pond_dump_bodies_abort_thrower2();
	
	self waittill( "stealth_enemy_endon_alert" );
	flag_set( "pond_abort" );
	
	self gun_recall();
}

pond_dump_bodies_abort_thrower2()
{
	level endon( "pond_abort" );
	self waittill( "death" );
	flag_set( "pond_abort" );
}


pond_dump_bodies_abort_thrower()
{
	self endon( "death" );
	self endon( "stealth_enemy_endon_alert" );
	
	flag_wait( "pond_abort" );
	
	self stopanimscripted();
	self gun_recall();
}

pond_dump_bodies_abort()
{
	self endon( "death" );
	flag_wait( "pond_abort" );
	
	self thread pond_dump_bodies_abort2();
	self notify( "ragdoll" );
}

pond_dump_bodies_abort2()
{
	self dodamage( self.health + 100, self.origin );
	waittillframeend;//if you dont do this - a ghost ai will appear.
	self startragdoll();	
}

pond_dump_createbody( anime )
{
	level endon( "pond_abort" );
	spot = self;
	body = pond_dump_createbody2();
	
	if( !isalive( body ) )
	{
		if( isdefined( body ) )
			body delete();
		return;
	}	
	
	body endon( "ragdoll" );
	
	body thread pond_dump_bodies_abort();
	
	spot anim_generic( body, anime );
	body delete();
}

pond_dump_createbody2()
{
	spawner = getent( "pond_deadguy1", "script_noteworthy" );
	spawner.count = 1;
	
	ai = spawner stalingradSpawn( true );
	
	spawn_failed( ai );
	assert( isDefined( ai ) );
	
	ai.script_noteworthy = undefined;
	ai.ignoreall = true;
	ai.ignoreme = true;
	ai.team = "neutral";
	ai.name = "";
	ai.a.nodeath = true;
	ai gun_remove();
	
	if( flag( "pond_abort" ) && isdefined( ai ) )
	{
		ai delete();
		return undefined;
	}
	return ai;
}

ShootEnemyWrapper_price()
{
	self endon( "death" );
	
	while( 1 )
	{
		self waittill( "animscript_shot" );
		
		if( flag( "_stealth_spotted" ) )
			continue;
		if( isalive( self.enemy ) )
			self.enemy dodamage( self.enemy.health + 200, self.origin );
	}	
}

ShootEnemyWrapper_SSNotify()
{
	self notify( "animscript_shot" );
	animscripts\utility::shootEnemyWrapper_normal();
}

player_noprone_water()
{
	water = getent( "water_no_prone", "targetname" );
	
	while( 1 )
	{
		water waittill( "trigger" );
		
		level.player allowprone( false );
		
		while( level.player istouching( water ) )
			wait .2;	
		
		level.player allowprone( true );
	}
}


town_kill_dash_heli()
{
	flag_wait( "town_no_turning_back" );
	flag_waitopen( "_stealth_spotted" );
	flag_waitopen( "dash_heli_agro" );
	
	heli = get_vehicle( "dash_hind", "targetname" );
	if( !isdefined( heli ) )
		return;
	
	waittillframeend;
	level endon( "_stealth_spotted" );
	level endon( "dash_heli_agro" );
	
	heli maps\_vehicle::volume_down( 6 );
	
	flag_set( "dash_hind_deleted" );
		
	wait .5;
	heli delete();
}

dash_reset_stealth_to_default()
{
	if( flag( "_stealth_spotted" ) )
		return;
	
	flag_set( "dash_reset_stealth_to_default" );
		
	if( isalive( level.price ) && !isdefined( level.price.magic_bullet_shield ) )
		level.price delaythread( .1, ::magic_bullet_shield );
		
	ai = getaispeciesarray( "axis", "all" );
	
	state_functions = [];
	state_functions[ "spotted" ] = ::town_state_spotted;
	
	for(i=0; i<ai.size; i++ )
	{
		ai[ i ] maps\_stealth_behavior::enemy_default_ai_functions( "state" );
		ai[ i ] maps\_stealth_behavior::ai_change_ai_functions( "state", state_functions );
		ai[ i ] maps\_stealth_behavior::enemy_default_ai_functions( "corpse" );
		ai[ i ] maps\_stealth_behavior::enemy_default_ai_functions( "awareness" );
	}
}

town_state_spotted()
{
	_flag = "_stealth_spotted";
	ender = "_stealth_detection_level_change" + _flag;
	thread maps\_stealth_behavior::state_change_ender( _flag, ender );
	level endon( ender );
	self endon( "death" );
	
	self.fovcosine = .01;// 90 degrees to either side...180 cone...default view cone
	self.ignoreall = false;
	
	if ( !self._stealth.logic.dog )
	{
		self.dieQuietly 	 = false;
		self clear_run_anim();
		self.baseAccuracy 	 = 1;
		self.Accuracy 		 = 1;
		self.fixednode		 = false;
		
		self maps\_stealth_behavior::enemy_stop_current_behavior();
	}
	
	if ( !isalive( self.enemy ) )
		self waittill_notify_or_timeout( "enemy", randomfloatrange( 1, 3 ) );

	if ( self._stealth.logic.dog )
		self.favoriteenemy = level.player;
	//else if ( randomint( 100 ) > 60 )
	//	self.favoriteenemy = level.player;// 60% chance that favorite enemy is the player
	
}

mission_dialogue_array( guys, aliases, _flag )
{
	if( !guys.size )
		return;
	if( !aliases.size )
		return;
	thread mission_dialogue_array_proc( guys, aliases, _flag );
}

mission_dialogue_array_proc( guys, aliases, _flag )
{
	if( isdefined( _flag ) )
		flag_wait( _flag );
		
	for( i=0; i<guys.size; i++)
	{
		if( !isalive( guys[ i ] ) )
			return;
		if( guys[ i ] ent_flag( "mission_dialogue_kill" ) )
			return;
		guys[ i ] endon( "mission_dialogue_kill" );
		guys[ i ] endon( "death" );
	}
	
	speaker = 0;
	
	for( i=0; i<aliases.size; i++ )
	{
		guys[ speaker ] mission_dialogue( aliases[ i ] );
		speaker++;
		if( speaker >= guys.size )
			speaker = 0;
	}
}

mission_dialogue( alias )
{
	
	if( !isalive( self ) || self ent_flag( "mission_dialogue_kill" ) )
		return;
		
	self thread play_sound( alias );
	self waittill( "play_sound_done" );
}

mission_dialogue_kill_sound()
{
	self ent_flag_wait( "mission_dialogue_kill" );
	self stopsounds(); 	
}

mission_dialogue_kill()
{
	self endon( "death" );
	
	self ent_flag_init( "mission_dialogue_kill" );
	self mission_dialogue_kill_wait();
	self ent_flag_set( "mission_dialogue_kill" );
}

mission_dialogue_kill_wait()
{
	self endon( "death" );
	self endon( "event_awareness" );
	self endon( "enemy" );
	level endon( "_stealth_spotted" );
	
	flag_wait_any( "_stealth_alert", "_stealth_spotted", "_stealth_found_corpse" );		
}

play_sound( alias )
{
	if ( is_dead_sentient() )
		return;
	
	org = spawn( "script_origin", ( 0, 0, 0 ) );
	org endon( "death" );
	thread maps\_utility::delete_on_death_wait_sound( org, "sounddone" );
	
	org.origin = self.origin;
	org.angles = self.angles;
	org linkto( self );
	
	org playsound( alias, "sounddone" );
	
	self play_sound_wait( org );
	if( isalive( self ) )
		self notify( "play_sound_done" );
	
	org StopSounds();
	wait( 0.05 ); // stopsounds doesnt work if the org is deleted same frame
	
	org delete();
}

play_sound_wait( org )
{
	self endon( "death" );
	self endon( "mission_dialogue_kill" );
	org waittill( "sounddone" );
}

dash_state_spotted()
{
	level endon( "_stealth_detection_level_change" );
	
	//self thread friendly_spotted_getup_from_prone();
		
	self.baseAccuracy 	 = self._stealth.behavior.badaccuracy;
	self.Accuracy 		 = self._stealth.behavior.badaccuracy;
	self.grenadeammo 	 = self._stealth.behavior.oldgrenadeammo;
	self stopanimscripted();
	//self.ignoreall 	 = false;
	self.ignoreme 	 = false;
	//self disable_cqbwalk();
	//self enable_ai_color();
	self.disablearrivals 	 = true;
	self.disableexits 		 = true;
	self pushplayer( false );
//	self setgoalpos( self.origin );
	self allowedstances( "prone" );//, "crouch", "stand" );
}

intro_attack_logic( enemy )
{	
	self endon( "death" );
	self endon( "pain_death" );
	self endon( "_stealth_stop_stealth_behavior" );
	
	self thread maps\_stealth_behavior::enemy_announce_spotted( self.origin );
				
	self thread intro_close_in_on_target();
}

intro_close_in_on_target()
{
	radius = 2048;
	self.goalradius = radius;
	
	if ( isdefined( self.script_stealth_dontseek ) )
		return;
		
	self endon( "death" );
	self endon( "_stealth_stop_stealth_behavior" );
		
	while ( isdefined( self.enemy ) )
	{
		spot = self.enemy.origin;
		if( self MayMoveToPoint( spot ) )
			self setgoalpos( spot );
		else
		{
			nodes = maps\_stealth_behavior::enemy_get_closest_pathnodes( 400, spot );
			if( nodes.size )
				self setgoalpos( nodes[0].origin );
		}
		
		self.goalradius = radius;
		
		if ( radius > 600 )
			radius *= .75;
		
		wait 15;
	}	
}

clean_corpse( _flag )
{
	flag_wait( _flag );
	if( !level._stealth.logic.corpse.array.size )
		return;
	
	size = level._stealth.logic.corpse.array.size;
	for(i=0; i<size; i++)
		maps\_stealth_logic::enemy_corpse_shorten_stack();	
}

field_handle_cleanup()
{
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	flag_wait( "field_clean" );
	
	ai = get_living_ai_array( "field_guard", "script_noteworthy" );
	ai = array_combine( ai, get_living_ai_array( "field_guard2", "script_noteworthy" ) );
	for(i=0; i<ai.size; i++)
		ai[ i ] thread field_handle_cleanup2();
	
}

pond_handle_behavior_change()
{
	flag_wait( "field_clean" );
	
	ai = get_living_ai_array( "pond_patrol", "script_noteworthy" );
	ai = array_combine( ai, get_living_ai_array( "pond_throwers", "script_noteworthy" ) );
	ai = array_combine( ai, get_living_ai_array( "pond_backup", "script_noteworthy" ) );
	
	for(i=0; i<ai.size; i++)
	{
		ai[ i ] maps\_stealth_behavior::enemy_default_ai_functions( "corpse" );
		ai[ i ] maps\_stealth_behavior::enemy_default_ai_functions( "awareness" );
	}
}

field_handle_cleanup2()
{
	self endon( "death" );
	dist = 2500;
	dist2rd = dist*dist;
	
	while( distancesquared( level.player.origin, self.origin ) < dist2rd || self cansee( level.player ) )
		wait .5;
	
	self delete();
}

hint_setup()
{
	maps\_utility::set_console_status();	
	if ( level.console )
		level.hint_text_size = 1.6;
	else
		level.hint_text_size = 1.2;
		
	precacheshader( "popmenu_bg" );
	precachestring( &"SCOUTSNIPER_HINT_PRONE_STANCE" );
	precachestring( &"SCOUTSNIPER_HINT_PRONE" );
	precachestring( &"SCOUTSNIPER_HINT_PRONE_TOGGLE" );
	precachestring( &"SCOUTSNIPER_HINT_PRONE_HOLD" );
	precachestring( &"SCOUTSNIPER_HINT_PRONE_DOUBLE" );	
		
	level.actionBinds = [];
	
	registerActionBinding( "prone",				"+stance",				&"SCOUTSNIPER_HINT_PRONE_STANCE" );
	registerActionBinding( "prone",				"goprone",				&"SCOUTSNIPER_HINT_PRONE" );
	registerActionBinding( "prone",				"toggleprone",			&"SCOUTSNIPER_HINT_PRONE_TOGGLE" );
	registerActionBinding( "prone",				"+prone",				&"SCOUTSNIPER_HINT_PRONE_HOLD" );
	registerActionBinding( "prone",				"lowerstance",			&"SCOUTSNIPER_HINT_PRONE_DOUBLE" );
	
	initKeys();
	updateKeysForBindings();
	delaythread( 1, ::pronehint );
}

pronehint()
{
	level.player endon( "kill_prone_hint" );
	level.player endon( "death" );

	thread printhint2( "kill_prone_hint" );
	
	flag_wait( "prone_hint" );
	thread keyHint( "prone", 8, true );
}

printhint2( name )
{
	level.player endon( "death" );
	
	while( level.player._stealth.logic.stance != "prone" )
		wait .2;
	
	level.player notify( name );
}

//from killhouse
keyHint( actionName, timeOut, prone )
{
	if ( getdvar( "chaplincheat" ) == "1" )
		return;

	clear_hints();
	level endon ( "clearing_hints" );

	add_hint_background();
	level.hintElem = createFontString( "default", level.hint_text_size );
	level.hintElem.hidewheninmenu = true;
	level.hintElem setPoint( "TOP", undefined, 0, 130 );

	actionBind = getActionBind( actionName );
	level.hintElem setText( actionBind.hint );
	//level.hintElem endon ( "death" );

	notifyName = "did_action_" + actionName;
	
	if( !isdefined( prone ) )
	{
		for ( index = 0; index < level.actionBinds[actionName].size; index++ )
		{
			actionBind = level.actionBinds[actionName][index];
			level.player notifyOnCommand( notifyName, actionBind.binding );
		}
	}
	else
		thread printhint2( notifyName );
	
	if ( isDefined( timeOut ) )
		level.player thread notifyOnTimeout( notifyName, timeOut );
	level.player waittill( notifyName );

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

notifyOnTimeout( finishedNotify, timeOut )
{
	self endon( finishedNotify );
	wait timeOut;
	self notify( finishedNotify );
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