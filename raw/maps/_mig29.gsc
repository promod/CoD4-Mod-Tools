#include maps\_utility;
#include common_scripts\utility;
#include maps\_vehicle_aianim;
#include maps\_vehicle;
#using_animtree( "vehicles" );
main( model, type )
{
	build_template( "mig29", model, type );
	build_localinit( ::init_local );

	build_deathmodel( "vehicle_mig29_desert" );
	build_deathmodel( "vehicle_av8b_harrier_jet" );
	
	//special for mig29/////
	level._effect[ "afterburner" ]				= loadfx( "fire/jet_afterburner" );
	level._effect[ "contrail" ]					= loadfx( "smoke/jet_contrail" );
	////////////////////////

	build_deathfx( "explosions/large_vehicle_explosion", undefined, "explo_metal_rand" );
	build_life( 999, 500, 1500 );
	build_rumble( "mig_rumble", .1,     .2,         11300,         .05,          .05 );
	build_team( "allies" );
}

init_local()
{
	thread playAfterBurner();
	thread playConTrail();
}

#using_animtree( "vehicles" );
set_vehicle_anims( positions )
{
	ropemodel = "rope_test";
	precachemodel( ropemodel );
	/*
	positions[ 0 ].vehicle_getinanim = %tigertank_hatch_open;
	positions[ 1 ].vehicle_getoutanim = %tigertank_hatch_open;
	*/
	return positions;
}


#using_animtree( "generic_human" );

setanims()
{
	positions = [];
	for( i=0;i<1;i++ )
		positions[ i ] = spawnstruct();
		
	return positions;
}

playAfterBurner()
{
	//After Burners are pretty much like turbo boost. They don't use them all the time except when 
	//bursts of speed are needed. Needs a cool sound when they're triggered. Currently, they are set
	//to be on all the time, but it would be cool to see them engauge as they fly away.
		
	playfxontag( level._effect[ "afterburner" ], self, "tag_engine_right" );
	playfxontag( level._effect[ "afterburner" ], self, "tag_engine_left" );

}

playConTrail()
{
	//This is a geoTrail effect that loops forever. It has to be enabled and disabled while playing as 
	//one effect. It can't be played in a wait loop like other effects because a geo trail is one 
	//continuous effect. ConTrails should only be played during high "G" or high speed maneuvers.
	playfxontag( level._effect[ "contrail" ], self, "tag_right_wingtip" );
	playfxontag( level._effect[ "contrail" ], self, "tag_left_wingtip" );
}


playerisclose( other )
{
	infront = playerisinfront( other );
	if( infront )
		dir = 1;
	else
		dir = -1;
	a = flat_origin( other.origin );
	b = a+vector_multiply( anglestoforward( flat_angle( other.angles ) ), ( dir*100000 ) );
	point = pointOnSegmentNearestToPoint( a, b, level.player.origin );
	dist = distance( a, point );
	if( dist < 3000 )
		return true;
	else
		return false;
}

playerisinfront( other )
{
		forwardvec = anglestoforward( flat_angle( other.angles ) );
		normalvec = vectorNormalize( flat_origin( level.player.origin )-other.origin );
		dot = vectordot( forwardvec, normalvec ); 
		if( dot > 0 )
			return true;
		else
			return false;
}

plane_sound_node()
{
		self waittill( "trigger", other );
		other endon( "death" );
		self thread plane_sound_node(); // spawn new thread for next plane that passes through this pathnode
		other thread play_loop_sound_on_entity( "veh_mig29_dist_loop" );
		while( playerisinfront( other ) )
			wait .05;
		wait .5; // little delay for the boom
		other thread play_sound_in_space( "veh_mig29_sonic_boom" );
		other waittill( "reached_end_node" );
		other stop_sound( "veh_mig29_dist_loop" );
		other delete();
}

plane_bomb_node()
{
		level._effect[ "plane_bomb_explosion1" ]			= loadfx( "explosions/airlift_explosion_large" );
		level._effect[ "plane_bomb_explosion2" ]			= loadfx( "explosions/tanker_explosion" );
		self waittill( "trigger", other );
		other endon( "death" );
		self thread plane_bomb_node(); // spawn new thread for next plane that passes through this pathnode
		
		// get array of targets
		aBomb_targets = getentarray( self.script_linkTo, "script_linkname" );
		assertEx( isdefined( aBomb_targets ), "Plane bomb node at " + self.origin  + " needs to script_linkTo at least one script_origin to use as a bomb target");
		assertEx( aBomb_targets.size > 1, "Plane bomb node at " + self.origin  + " needs to script_linkTo at least one script_origin to use as a bomb target");
		
		//sort array of targets from nearest to furthest to determine order of bombing
		aBomb_targets = get_array_of_closest( self.origin , aBomb_targets , undefined , aBomb_targets.size );
		iExplosionNumber = 0;
		
		wait randomfloatrange( .3, .8 );
		for(i=0;i<aBomb_targets.size;i++)
		{
			iExplosionNumber++;
			if (iExplosionNumber == 3)
				iExplosionNumber = 1;
			aBomb_targets[i] thread play_sound_on_entity( "airstrike_explosion" );
			//aBomb_targets[i] thread play_sound_on_entity( "rocket_explode_sand" );
			playfx( level._effect[ "plane_bomb_explosion" +  iExplosionNumber], aBomb_targets[i].origin);
			wait randomfloatrange( .3, 1.2 );
		}
}

plane_bomb_cluster()
{
	/*-----------------------
	WAIT FOR PLANE TO HIT NODE
	-------------------------*/		
	self waittill( "trigger", other );
	other endon( "death" );
	plane = other;
	plane thread plane_bomb_cluster(); // spawn new thread for next plane that passes through this pathnode

	/*-----------------------
	SPAWN A BOMB MODEL
	-------------------------*/				
	bomb = spawn( "script_model", plane.origin - ( 0, 0, 100 ) );
	bomb.angles = plane.angles;
	bomb setModel( "projectile_cbu97_clusterbomb" );

	/*-----------------------
	LAUNCH FROM PLANE UNTIL CLOSE TO GROUND
	-------------------------*/		
	vecForward = vectorscale( anglestoforward( plane.angles ), 2 );
	vecUp = vectorScale( anglestoup( plane.angles ), -0.2 );	//invert the up angles
	vec = [];
	for ( i = 0; i < 3; i++ )
		vec[i] = ( vecForward[ i ] + vecUp[ i ] ) / 2;
	vec = ( vec[0], vec[1], vec[2] );
	vec = vectorscale( vec, 7000 );
	bomb moveGravity( vec, 2.0 );
	wait ( 1.2 );
	
	newBomb = spawn( "script_model", bomb.origin );
	newBomb setModel( "tag_origin" );
	newBomb.origin = bomb.origin;
	newBomb.angles = bomb.angles;
	wait (0.05);
	
	bomb delete();
	bomb = newBomb;

	/*-----------------------
	PLAY FX ON INVISIBLE BOMB
	-------------------------*/	
	bombOrigin = bomb.origin;
	bombAngles = bomb.angles;
	playfxontag( level.airstrikefx, bomb, "tag_origin" );

	wait 1.6;
	repeat = 12;
	minAngles = 5;
	maxAngles = 55;
	angleDiff = (maxAngles - minAngles) / repeat;
	
	for( i = 0; i < repeat; i++ )
	{
		traceDir = anglesToForward( bombAngles + (maxAngles-(angleDiff * i),randomInt( 10 )-5,0) );
		traceEnd = bombOrigin + vectorScale( traceDir, 10000 );
		trace = bulletTrace( bombOrigin, traceEnd, false, undefined );
		
		traceHit = trace["position"];
		
		radiusDamage( traceHit + (0,0,16), 512, 400, 30); // targetpos, radius, maxdamage, mindamage
		
		if ( i%3 == 0 )
		{
			thread maps\_utility::play_sound_in_space( "airstrike_explosion", traceHit );
			playRumbleOnPosition( "artillery_rumble", traceHit );
			earthquake( 0.7, 0.75, traceHit, 1000 );
		}
		
		wait ( 0.75/repeat );
	}
	wait ( 1.0 );
	bomb delete();

}

stop_sound( alias )
{
	self notify( "stop sound"+alias );
}
