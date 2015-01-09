#include maps\_utility;
#include common_scripts\utility;
#include maps\_mgTurret;

gunner_think( turret )
{
	self endon( "death" );
	self notify( "end_mg_behavior" );
	self endon( "end_mg_behavior" );

	self.can_fire_turret = true;
	self.wants_to_fire = false;

	if ( !use_the_turret( turret ) )
	{
		self notify( "continue_cover_script" );
		return;
	}
		
	// clear it so that it can be set by record_enemy_sightings fresh
	self.last_enemy_sighting_position = undefined;
	thread record_enemy_sightings();	
	
	forward = anglestoforward( turret.angles );
	
	ent = spawn( "script_origin", (0,0,0) );
	thread target_ent_cleanup( ent );

//	ent setmodel( "temp" );
	ent.origin = turret.origin + vectorScale( forward, 500 );
	
	if ( isdefined( self.last_enemy_sighting_position ) )
	{
		// jump to the enemy sight position so we start "on target"
		ent.origin = self.last_enemy_sighting_position;
	}
	
	turret setTargetEntity( ent );
	
	enemy = undefined;

	for ( ;; )
	{
		if ( !isalive( self.current_enemy ) )
		{
			self stop_firing();
			self waittill( "new_enemy" );
		}
			
		self start_firing();
		shoot_enemy_until_he_hides_then_shoot_wall( ent );
	
		// do we still have an enemy?	
		if ( !isalive( self.current_enemy ) )
			continue;

		// is he hiding from us?
		if ( self canSee( self.current_enemy ) )
			continue;
	
		// if so then try to find a new angle on him
//		find_a_new_turret_spot( ent );
		self waittill( "saw_enemy" );
	}
}

target_ent_cleanup( ent )
{
	waittill_either( "death", "end_mg_behavior" );
	ent delete();
}


shoot_enemy_until_he_hides_then_shoot_wall( ent )
{
	self endon( "death" );
	self endon( "new_enemy" );
	self.current_enemy endon( "death" );
	enemy = self.current_enemy;

	// shoot at the enemy while we can see him
	while ( self canSee( enemy ) )
	{
//		line ( enemy geteye(), ent.origin, (1,0,1), 1, 10 );
		angles = vectortoangles( enemy geteye() - ent.origin );
		angles = anglestoforward( angles );
		ent moveto( ent.origin +  vectorscale( angles, 12 ), 0.1 );
		wait( 0.1 );
	}

	if ( enemy == level.player )
	{
		// shoot into the wall in the direction he exited our vision, then bring it back
		
		self endon( "saw_enemy" );
	
		eye = enemy geteye();	
		angles = vectortoangles( eye - ent.origin );
		angles = anglestoforward( angles );
	
		units_per_second = 150;	
		timer = distance( ent.origin, self.last_enemy_sighting_position ) / units_per_second;
		if ( timer > 0 )
		{
			ent moveto( self.last_enemy_sighting_position, timer );
			wait( timer );
		}
	
	//	oldOrigin = get_suppress_point( self geteye(), ent.origin, ent.origin + vectorscale( angles, 80 ) );
		org = ent.origin + vectorscale( angles, 180 );
		oldOrigin = get_suppress_point( self geteye(), ent.origin, org );
		if ( !isdefined( oldOrigin ) )
			oldOrigin = ent.origin;
			
		ent moveto( ent.origin + vectorscale( angles, 80 ) + (0,0, randomfloatrange( 15, 50 ) * -1 ), 3, 1, 1 );
		wait( 3.5 );
		ent moveto( oldOrigin + vectorscale( angles, -20 ), 3, 1, 1 );
	}

	wait( randomfloatrange( 2.5, 4 ) );
	self stop_firing();
}

set_firing( val )
{
	if ( val )
	{
		self.can_fire_turret = true;
		if ( self.wants_to_fire )
		{
			self.turret notify("startfiring");
		}
	}
	else
	{
		self.can_fire_turret = false;
		self.turret notify("stopfiring");
	}
}

stop_firing()
{
	self.wants_to_fire = false;

	self.turret notify("stopfiring");
}

start_firing()
{
	self.wants_to_fire = true;
	if ( self.can_fire_turret )
	{
		self.turret notify("startfiring");
	}
}

create_mg_team()
{
	// the guys that spawn on the same frame and have "mgpair" get put together
	// when one dies, the other gets ANGRY
	
	if ( isdefined( level.mg_gunner_team ) )
	{
		level.mg_gunner_team[ level.mg_gunner_team.size ] = self;
		return;
	}

	level.mg_gunner_team = [];
	level.mg_gunner_team[ level.mg_gunner_team.size ] = self;
	waittillframeend; // so everybody who spawns in this frame can get in the team

	ent = spawnstruct();
	array_thread( level.mg_gunner_team, ::mg_gunner_death_notify, ent );	
	
	array = level.mg_gunner_team;
	level.mg_gunner_team = undefined; // for the next team that spawns
	
	ent waittill( "gunner_died" );
	
	for ( i=0; i<array.size; i++ )
	{
		if ( !isalive( array[i] ) )
			continue;
			
		array[i] notify( "stop_using_built_in_burst_fire" );
		array[i] thread solo_fires();
	}
}

mg_gunner_death_notify( ent )
{
	self waittill( "death" );
	ent notify( "gunner_died" );
}

		


mgTeam_take_turns_firing( mgTeam )
{
	wait( 1 ); // wait for the guy to get on the turret
	level notify( "new_mg_firing_team" + mgTeam[0].script_noteworthy );
	level endon( "new_mg_firing_team" + mgTeam[0].script_noteworthy );
	
	for ( ;; )
	{
		dual_firing( mgTeam );
		solo_firing( mgTeam );
	}
}

solo_firing( mgTeam )
{
	mgGunner = undefined;
	for ( i=0; i<mgTeam.size; i++ )
	{
		if ( !isalive( mgTeam[i] ) )
			continue;
		mgGunner = mgTeam[i];
		break;
	}
	if ( !isdefined( mgGunner ) )
		return;

//	mgGunner solo_fires(); changed solo fires
}

solo_fires()
{		
	self endon( "death" );
	for ( ;; )
	{
		//self set_firing( true );
		self.turret startFiring();
		wait( randomfloatrange( 0.3, 0.7 ) );

		//self set_firing( false );
		self.turret stopFiring();
		wait( randomfloatrange( 0.1, 1.1 ) );
	}
}

dual_firing( mgTeam )
{
	for ( i=0;i<mgTeam.size; i++ )
		mgTeam[i] endon( "death" );

	a = 0;
	b = 1;
		
	for ( ;; )
	{
		if ( isalive( mgTeam[a] ) )
			mgTeam[a] set_firing( true );

		if ( isalive( mgTeam[b] ) )
			mgTeam[b] set_firing( false );
		
		c = a;
		a = b;
		b = c;
		wait( randomfloatrange( 2.3, 3.5 ) );
	}
}


spotted_an_enemy( ent, enemy )
{
	self start_firing();
	// saw a new enemy
	self endon( "death" );
	self endon( "new_enemy" );
	enemy endon( "death" );

	while ( self canSee( enemy ) )
	{
//		line ( enemy geteye(), ent.origin, (1,0,1), 1, 10 );
		angles = vectortoangles( enemy geteye() - ent.origin );
		angles = anglestoforward( angles );
		ent moveto( ent.origin +  vectorscale( angles, 10 ), 0.2 );
		wait( 0.2 );
	}

	angles = vectortoangles( enemy geteye() - ent.origin );
	angles = anglestoforward( angles );

	units_per_second = 150;	
	timer = distance( ent.origin, self.last_enemy_sighting_position ) / units_per_second;
	ent moveto( self.last_enemy_sighting_position, timer );
	wait( timer );
	oldOrigin = ent.origin;
	ent moveto( ent.origin + vectorscale( angles, 80 ) + (0,0,-25), 3, 1, 1 );
	wait( 3.5 );
	ent moveto( oldOrigin + vectorscale( angles, -20 ), 3, 1, 1 );
	wait( 1 );
	self stop_firing();
}


get_suppress_point( origin, trace_start, trace_end )
{
	traces = distance( trace_start, trace_end ) * 0.05;

	if ( traces < 5 )
		traces = 5;
	if ( traces > 20 )
		traces = 20; // cap it 

	vectorDif = trace_end - trace_start;
	vectorDif = ( vectorDif[0]/traces, vectorDif[1]/traces, vectorDif[2]/traces );

//	print3d( origin, "*", (0,1,1), 1, 5, 240 );
//	print3d( trace_end, "*", (0,1,0), 1, 5, 240 );
//	print3d( trace_start, "*", (0,0,1), 1, 5, 240 );
	
	offset = (0,0,0);

	hit_pos = undefined;
	for ( i=0; i < traces+  2; i++ )
	{
//		print3d( trace_end + offset, "*", (1,0,0), 1, 5, 40 );
		
		trace = bullettrace( origin, trace_start + offset, false, undefined );
		if ( trace["fraction"] < 1 )
		{
//			thread linetime( origin, trace["position"], ( 1,0,0 ), 10 );
			hit_pos = trace[ "position" ];	
			break;
		}
//		thread linetime( origin, trace["position"], ( 0,1,0 ), 10 );
	
//		print3d( trace[ "position" ], "*", (1,1,0), 1, 5, 40 );
		offset += vectorDif;
	}

	return hit_pos;
}

record_enemy_sightings()
{
	self endon( "death" );
	self endon( "end_mg_behavior" );
	
	self.current_enemy = undefined;
	for ( ;; )
	{
		record_sighting();
		wait( 0.05 );
	}
}

record_sighting()
{
	if ( !isalive( self.enemy ) )
		return;
	
	if ( !( self canSee( self.enemy ) ) )
		return;

	self.last_enemy_sighting_position = self.enemy geteye();

	self notify( "saw_enemy" );		
	if ( !isalive( self.current_enemy ) || self.current_enemy != self.enemy )
	{
		self.current_enemy = self.enemy;
		self notify( "new_enemy" );
	}
}


