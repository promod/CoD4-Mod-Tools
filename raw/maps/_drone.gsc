#include maps\_utility;
#include common_scripts\utility;
#using_animtree( "generic_human" );
init()
{
	if ( getdvar( "debug_drones" ) == "" )
		setdvar( "debug_drones", "0" );
	
	if (!isdefined(level.traceHeight))
		level.traceHeight = 400;
	
	if (!isdefined(level.droneStepHeight))
		level.droneStepHeight = 100;
	
	//lookahead value - how far the character will lookahead for movement direction
	//larger number makes smother, more linear travel. small value makes character go almost exactly point to point
	if( !isdefined( level.lookAhead_value ) )
		level.drone_lookAhead_value = 200;
	if( !isdefined( level.drone_run_speed ) )
		level.drone_run_speed = 170;
	
	if(!isdefined(level.max_drones))
		level.max_drones = [];
	if(!isdefined(level.max_drones["allies"]))
		level.max_drones["allies"] = 99999;
	if(!isdefined(level.max_drones["axis"]))
		level.max_drones["axis"] = 99999;
	if(!isdefined(level.max_drones["neutral"]))
		level.max_drones["neutral"] = 99999;

	if(!isdefined(level.drones))
		level.drones = [];
	if(!isdefined(level.drones["allies"]))
		level.drones["allies"] = struct_arrayspawn();
	if(!isdefined(level.drones["axis"]))
		level.drones["axis"] = struct_arrayspawn();
	if(!isdefined(level.drones["neutral"]))
		level.drones["neutral"] = struct_arrayspawn();
	
	level.drone_anims[ "stand" ][ "idle" ]	= %drone_stand_idle;
	level.drone_anims[ "stand" ][ "run" ]	= %drone_stand_run;
	level.drone_anims[ "stand" ][ "death" ]	= %drone_stand_death;
	
	level.drone_spawn_func = ::drone_init;
}

drone_init()
{
	// Dont keep this drone if we've reached the max population for that team of drones
	assertEx( isdefined( level.max_drones ), "You need to put maps\_drone::init(); in your level script!" );
	if ( level.drones[ self.team ].array.size >= level.max_drones[ self.team ] )
	{
		self delete();
		return;
	}
	structarray_add( level.drones[ self.team ], self );
	
	// Give the drone default health and make it take damage like an AI does
	self.health = 150;
	self setCanDamage( true );
	
	// Tell drone which animtree to use
	self useAnimTree( #animtree );
	
	// Put a friendly name on the drone so they look like AI
	if ( self.team == "allies" )
	{
		// force to be american, but should probably figure out what it really should be since all friendlies aren't american
		self.voice = "american";
		
		// asign name
		self maps\_names::get_name();
		self setlookattext( self.name, &"" );
	}
	
	if ( isdefined ( level.droneCallbackThread ) )
		self thread [[ level.droneCallbackThread ]]();
	
	// Run the friendly fire thread on this drone so the mission can be failed for killing friendly drones
	// Runs on all teams since friendly fire script also keeps track of enemies killed, etc.
	level thread maps\_friendlyfire::friendly_fire_think( self );
	
	// Wait until this drone loses it's health so it can die
	level thread drone_death_thread( self );
	
	// If the drone targets something then make it move, otherwise just idle in place
	if ( isdefined( self.target ) && !isdefined( self.script_moveoverride ) )
		self drone_move();
	self drone_idle();
}

drone_death_thread( drone )
{
	// Wait until the drone reaches 0 health
	while( isdefined( drone ) )
	{
		drone waittill( "damage" );
		if ( drone.health <= 0 )
			break;
	}
	
	// Make drone die
	drone notify( "death" );
	drone stopAnimScripted();
	if ( isdefined( drone.skipDeathAnim ) )
	{
		drone startragdoll();
		drone drone_play_anim( level.drone_anims[ "stand" ][ "death"] );
	}
	else
	{
		drone drone_play_anim( level.drone_anims[ "stand" ][ "death"] );
		drone startragdoll();
	}
	wait 10;
	if ( isdefined( drone ) )
		drone delete();
}

drone_play_anim( droneAnim )
{
	self animscripted( "drone_anim", self.origin, self.angles, droneAnim );
	self waittillmatch( "drone_anim", "end" );
}

drone_idle()
{
	// Loop idle animation
	self stopAnimScripted();
	self thread drone_play_anim( level.drone_anims[ "stand" ][ "idle" ] );
}

drone_move()
{
	self endon ("death");
	
	// Loop run animation
	wait randomfloat( 0.5 );
	self thread drone_play_anim( level.drone_anims[ "stand" ][ "run" ] );
	
	nodes = self getPathArray( self.target, self.origin );
	assert( isdefined( nodes ) );
	assert( isdefined( nodes[0] ) );
	
	prof_begin( "drone_math" );
	
	loopTime = 0.5;
	currentNode_LookAhead = 0;
	for (;;)
	{
		if ( !isdefined( nodes[currentNode_LookAhead] ) )
			break;
		
		// Calculate how far and what direction the lookahead path point should move
		//--------------------------------------------------------------------------
		
		// find point on real path where character is
		vec1 = nodes[ currentNode_LookAhead ][ "vec" ];
		vec2 = ( self.origin - nodes[ currentNode_LookAhead ][ "origin" ] );
		distanceFromPoint1 = vectorDot( vectorNormalize( vec1 ), vec2 );
		
		// check if this is the last node (wont have a distance value)
		if ( !isdefined( nodes[ currentNode_LookAhead ][ "dist" ] ) )
			break;
		
		lookaheadDistanceFromNode = ( distanceFromPoint1 + level.drone_lookAhead_value );
		assert( isdefined( lookaheadDistanceFromNode ) );
		
		assert( isdefined( currentNode_LookAhead ) );
		assert( isdefined( nodes[ currentNode_LookAhead ] ) );
		assert( isdefined( nodes[ currentNode_LookAhead ][ "dist" ] ) );
		
		while ( lookaheadDistanceFromNode > nodes[ currentNode_LookAhead ][ "dist" ] )
		{
			// moving the lookahead would pass the node, so move it the remaining distance on the vector of the next node
			lookaheadDistanceFromNode = lookaheadDistanceFromNode - nodes[ currentNode_LookAhead ][ "dist" ];
			currentNode_LookAhead++;
			
			if( !isdefined( nodes[ currentNode_LookAhead ][ "dist" ] ) )
			{
				//last node on the chain
				self rotateTo( vectorToAngles( nodes[ nodes.size -1 ][ "vec" ] ), loopTime );
				d = distance( self.origin, nodes[ nodes.size - 1 ][ "origin" ] );
				timeOfMove = ( d / level.drone_run_speed );
				moveToDest = physicstrace( nodes[ nodes.size -1 ][ "origin" ] + ( 0, 0, level.traceHeight ), nodes[ nodes.size - 1 ][ "origin" ] - ( 0, 0, level.traceHeight ) );
				self moveTo( moveToDest, timeOfMove );
				wait timeOfMove;
				prof_end( "drone_math" );
				self notify ( "goal" );
				return;
			}
			
			if ( !isdefined( nodes[ currentNode_LookAhead ] ) )
			{
				prof_end( "drone_math" );
				self notify ( "goal" );
				return;
			}
			
			assert( isdefined( nodes[ currentNode_LookAhead ] ) );
		}
		//-------------------------------------------------------------------------
		
		
		// Move the lookahead point down along it's path
		//----------------------------------------------
		assert( isdefined( nodes[ currentNode_LookAhead ][ "vec" ] ) );
		assert( isdefined( nodes[ currentNode_LookAhead ][ "vec" ][ 0 ] ) );
		assert( isdefined( nodes[ currentNode_LookAhead ][ "vec" ][ 1 ] ) );
		assert( isdefined( nodes[ currentNode_LookAhead ][ "vec" ][ 2 ] ) );
		desiredPosition = vectorScale ( nodes[ currentNode_LookAhead ][ "vec" ], lookaheadDistanceFromNode );
		desiredPosition = desiredPosition + nodes[ currentNode_LookAhead ][ "origin" ];
		lookaheadPoint = desiredPosition;
		// trace the lookahead point to the ground
		lookaheadPoint = physicstrace( lookaheadPoint + ( 0, 0, level.traceHeight ), lookaheadPoint - ( 0, 0, level.traceHeight ) );
		if ( getdvar( "debug_drones" ) == "1" )
		{
			thread draw_line_for_time( self.origin + ( 0, 0, 16 ), lookaheadPoint, 1, 0, 0, loopTime );
			println ( lookaheadDistanceFromNode + "/" + nodes[ currentNode_LookAhead ]["dist"] + " units forward from node[" + currentNode_LookAhead + "]" );
		}
		//---------------------------------------------
		
		
		//Rotate character to face the lookahead point
		//--------------------------------------------
		assert( isdefined ( lookaheadPoint ) );
		characterFaceDirection = VectorToAngles( lookaheadPoint - self.origin );
		assert( isdefined( characterFaceDirection ) );
		assert( isdefined( characterFaceDirection[ 0 ] ) );
		assert( isdefined( characterFaceDirection[ 1 ] ) );
		assert( isdefined( characterFaceDirection[ 2 ] ) );
		self rotateTo( ( 0, characterFaceDirection[ 1 ], 0 ), loopTime );
		//--------------------------------------------
		
		
		//Move the character in the direction of the lookahead point
		//----------------------------------------------------------
		characterDistanceToMove = ( level.drone_run_speed * loopTime );
		moveVec = vectorNormalize( lookaheadPoint - self.origin );
		desiredPosition = vectorScale ( moveVec, characterDistanceToMove );
		desiredPosition = desiredPosition + self.origin;
		if ( getdvar( "debug_drones" ) == "1" )
			thread draw_line_for_time( self.origin, desiredPosition, 0, 0, 1, loopTime );
		self moveTo( desiredPosition, loopTime );
		//----------------------------------------------------------
		
		wait loopTime;
	}
	
	prof_end( "drone_math" );
	self notify ( "goal" );
}

getPathArray( firstTargetName, initialPoint )
{
	//#########################################################################################################
	//	make an array of all the points along the spline starting with the characters current position,
	//	then starting with the point with the passed in targetname
	//
	//	information stored in array:
	//
	//	origin - origin of the node
	//	dist - distance to the next node ( will be undefined if there is not a next node )
	//	vec	- vector to the next node ( if there is not a next node, the vector will be the same as the previous node )
	//
	//#########################################################################################################
	
	usingNodes = true;
	assert( isdefined( firstTargetName ) );
	
	prof_begin( "drone_math" );
	
	assert( isdefined( initialPoint ) );
	
	nodes = [];
	nodes[ 0 ][ "origin" ] = initialPoint;
	nodes[ 0 ][ "dist" ] = 0;
	
	nextNodeName = undefined;
	nextNodeName = firstTargetName;
	
	for (;;)
	{
		index = nodes.size;
		
		// get the next node in the chain
		node = getstruct( nextNodeName, "targetname" );
			
		// no script_struct was found
		if ( !isdefined( node ) )
		{
			if ( index == 0 )
				assertMsg( "Drone was told to walk to a node with a targetname that doesnt match a script_struct targetname" );
			break;
		}
				
		// add this node information to the chain data array
		org = node.origin;
		
		//check for radius on node, since you can make them run to a radius rather than an exact point
		if ( isdefined( node.radius ) )
		{
			assert( node.radius > 0 );
			
			// offset for this drone (-1 to 1)
			if ( !isdefined( self.droneRunOffset ) )
				self.droneRunOffset = ( 0 - 1 + ( randomfloat( 2 ) ) );
			
			if ( !isdefined( node.angles ) )
				node.angles = ( 0, 0, 0 );
				
			prof_begin( "drone_math" );
				forwardVec = anglestoforward( node.angles );
				rightVec = anglestoright( node.angles );
				upVec = anglestoup( node.angles );
				relativeOffset = ( 0, ( self.droneRunOffset * node.radius ), 0 );
				org += vector_multiply( forwardVec, relativeOffset[ 0 ] );
				org += vector_multiply( rightVec, relativeOffset[ 1 ] );
				org += vector_multiply( upVec, relativeOffset[ 2 ] );
			prof_end("drone_math");
		}
		nodes[ index ][ "origin" ] = org;
		
		// find the distance from the previous node to this node, and the vector of of the previous node to this node
		// then add the info to the previous nodes data
		nodes[ index - 1 ][ "dist" ] = distance( nodes[ index ][ "origin" ], nodes[ index - 1 ][ "origin" ] );
		nodes[ index - 1 ][ "vec" ] = vectorNormalize( nodes[ index ][ "origin" ] - nodes[ index - 1 ][ "origin" ] );
		
		//if the node doesn't target another node then it's the last of the chain
		if ( !isdefined( node.target ) )
			break;
		//it targets something
		nextNodeName = node.target;
	}
	
	nodes[ index ][ "vec" ] = nodes[ index - 1 ][ "vec" ];
	
	node = undefined;
	
	prof_end( "drone_math" );
	
	return nodes;
}