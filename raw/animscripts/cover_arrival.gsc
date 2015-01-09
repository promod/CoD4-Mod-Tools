#include animscripts\SetPoseMovement;
#include animscripts\combat_utility;
#include animscripts\utility;
#include common_scripts\utility;
#include maps\_utility;

#using_animtree ("generic_human");

main()
{
	self endon("killanimscript");
	
	if ( isdefined( self.doMiniArrival ) )
	{
		self.doMiniArrival = undefined;
		node = self.miniArrivalNode;
		self.miniArrivalNode = undefined;
		self DoMiniArrival( node );
		return;
	}
	
	approachnumber = self.approachNumber;
	
	newstance = undefined;
	
	assert( isdefined( self.approachtype ) );
	
	arrivalAnim = anim.coverTrans[ self.approachtype ][ approachnumber ];
	assert( isdefined( arrivalAnim ) );
	
	switch ( self.approachtype )
	{
		case "left":
		case "right":
		case "stand":
		case "stand_saw":
		case "exposed":
			newstance = "stand";
			break;
			
		case "left_crouch":
		case "right_crouch":
		case "crouch_saw":
		case "crouch":
		case "exposed_crouch":
			newstance = "crouch";
			break;
		
		case "prone_saw":
			newstance = "prone";
			break;
			
		default:
			assertmsg("bad node approach type: " + self.approachtype);
			return;			
	}
	
	self setFlaggedAnimKnobAllRestart( "coverArrival", arrivalAnim, %body, 1, 0.3, 1 );
	self animscripts\shared::DoNoteTracks( "coverArrival" );
	
	if ( isdefined( newstance ) )
		self.a.pose = newstance;
	self.a.movement = "stop";

	self.a.arrivalType = self.approachType;
	
	// we rely on cover to start doing something else with animations very soon.
	// in the meantime, we don't want any of our parent nodes lying around with positive weights.
	self clearanim( %root, .3 );
}

getNodeStanceYawOffset( approachtype )
{
	// returns the base stance's yaw offset when hiding at a node, based off the approach type
	
	if ( approachtype == "left" || approachtype == "left_crouch" )
		return 90.0;
	else if ( approachtype == "right" || approachtype == "right_crouch" )
		return -90.0;
	
	return 0;
}


canUseSawApproach( node )
{
	if ( self.weapon != "saw" && self.weapon != "rpd" )
		return false;
	
	if ( !isDefined( node.turretInfo ) )
		return false;
	
	if ( node.type != "Cover Stand" && node.type != "Cover Prone" && node.type!= "Cover Crouch" )
		return false;
	
	if ( isDefined( self.enemy ) && distanceSquared( self.enemy.origin, node.origin ) < 256*256 )
		return false;
	
	if ( GetNodeYawToEnemy() > 40 || GetNodeYawToEnemy() < -40 )
		return false;
	
	return true;
}

determineNodeApproachType( node )
{
//	if ( isdefined( node.approachtype ) )
//		return;

	if ( canUseSawApproach( node ) )
	{
		if ( node.type == "Cover Stand" )
			node.approachtype = "stand_saw";
		if ( node.type == "Cover Crouch" )
			node.approachtype = "crouch_saw";
		else if ( node.type == "Cover Prone" )
			node.approachtype = "prone_saw";
		assert( isdefined( node.approachtype ) );
		return;
	}
	
	if ( !isdefined( anim.approach_types[ node.type ] ) )
		return;
	
	stance = node isNodeDontStand() && !node isNodeDontCrouch();
	
	node.approachtype = anim.approach_types[ node.type ][ stance ];
}

getMaxDirectionsAndExcludeDirFromApproachType( approachtype )
{
	returnobj = spawnstruct();
	
	if ( approachtype == "left" || approachtype == "left_crouch" )
	{
		returnobj.maxDirections = 9;
		returnobj.excludeDir = 9;
	}
	else if ( approachtype == "right" || approachtype == "right_crouch" )
	{
		returnobj.maxDirections = 9;
		returnobj.excludeDir = 7;
	}
	else if ( approachtype == "stand" || approachtype == "crouch" || approachtype == "stand_saw" || approachType == "crouch_saw" )
	{
		returnobj.maxDirections = 6;
		returnobj.excludeDir = -1;
	}
	else if ( approachtype == "exposed" || approachtype == "exposed_crouch" )
	{
		returnobj.maxDirections = 9;
		returnobj.excludeDir = -1;
	}
	else if ( approachtype == "prone_saw" )
	{
		returnobj.maxDirections = 3;
		returnobj.excludeDir = -1;
	}
	else
	{
		assertmsg( "unsupported approach type " + approachtype );
	}
	return returnobj;
}

shouldApproachToExposed()
{
	// decide whether it's a good idea to go directly into the exposed position as we approach this node.
	
	if ( !isValidEnemy( self.enemy ) )
		return false; // nothing to shoot!
	
	if ( self NeedToReload( 0.5 ) )
		return false;
	
	if ( self isSuppressedWrapper() )
		return false; // too dangerous, we need cover
	
	// path nodes have no special "exposed" position
	if ( self.node.approachtype == "exposed" || self.node.approachtype == "exposed_crouch" )
		return false;
	
	// no arrival animations into exposed for left/right crouch
	if ( self.node.approachtype == "left_crouch" || self.node.approachtype == "right_crouch" )
		return false;
	
	return canSeePointFromExposedAtNode( self.enemy getShootAtPos(), self.node );
}

// gets the point and angle to approach in order to arrive in exposed
getExposedApproachData()
{
	returnobj = spawnstruct();
	
	if ( self.node.approachtype == "stand" )
	{
		returnobj.point = self.node.origin + calculateNodeOffsetFromAnimationDelta( self.node.angles, getMoveDelta( %coverstand_hide_2_aim ) );
		returnobj.yaw = self.node.angles[1];
	}
	else if ( self.node.approachtype == "crouch" )
	{
		returnobj.point = self.node.origin + calculateNodeOffsetFromAnimationDelta( self.node.angles, getMoveDelta( %covercrouch_hide_2_stand ) );
		returnobj.yaw = self.node.angles[1];
	}
	else if ( self.node.approachtype == "left" || self.node.approachtype == "left_crouch" )
	{
		cornerMode = animscripts\corner::getCornerMode( self.node, self.enemy getShootAtPos() );
		assert( cornerMode != "none" ); // we should have caught this case within canSeePointFromExposedAtNode() from inside shouldApproachToExposed()
		
		alert_to_exposed_anim = undefined;
		if ( self.node.approachtype == "left" )
		{
			if ( cornerMode == "A" )
				alert_to_exposed_anim = %corner_standL_trans_alert_2_A;
			else
				alert_to_exposed_anim = %corner_standL_trans_alert_2_B;
		}
		else
		{
			assert( self.node.approachtype == "left_crouch" );
			if ( cornerMode == "A" )
				alert_to_exposed_anim = %CornerCrL_trans_alert_2_A;
			else
				alert_to_exposed_anim = %CornerCrL_trans_alert_2_B;
		}
		
		baseAngles = self.node.angles;
		baseAngles = (baseAngles[0], baseAngles[1] + getNodeStanceYawOffset( self.node.approachtype ), baseAngles[2]);
		
		returnobj.point = self.node.origin + calculateNodeOffsetFromAnimationDelta( baseAngles, getMoveDelta( alert_to_exposed_anim ) );
		returnobj.yaw = baseAngles[1] + getAngleDelta( alert_to_exposed_anim )[1];
	}
	else if ( self.node.approachtype == "right" || self.node.approachtype == "right_crouch" )
	{
		cornerMode = animscripts\corner::getCornerMode( self.node, self.enemy getShootAtPos() );
		assert( cornerMode != "none" ); // we should have caught this case within canSeePointFromExposedAtNode() from inside shouldApproachToExposed()
		
		alert_to_exposed_anim = undefined;
		if ( self.node.approachtype == "right" )
		{
			if ( cornerMode == "A" )
				alert_to_exposed_anim = %corner_standR_trans_alert_2_A;
			else
				alert_to_exposed_anim = %corner_standR_trans_alert_2_B;
		}
		else
		{
			assert( self.node.approachtype == "right_crouch" );
			if ( cornerMode == "A" )
				alert_to_exposed_anim = %CornerCrR_trans_alert_2_A;
			else
				alert_to_exposed_anim = %CornerCrR_trans_alert_2_B;
		}
		
		baseAngles = self.node.angles;
		baseAngles = (baseAngles[0], baseAngles[1] + getNodeStanceYawOffset( self.node.approachtype ), baseAngles[2]);
		
		returnobj.point = self.node.origin + calculateNodeOffsetFromAnimationDelta( baseAngles, getMoveDelta( alert_to_exposed_anim ) );
		returnobj.yaw = baseAngles[1] + getAngleDelta( alert_to_exposed_anim )[1];
	}
	else
	{
		assertmsg( "bad node approach type: " + self.node.approachtype );
	}
	
	return returnobj;
}

calculateNodeOffsetFromAnimationDelta( nodeAngles, delta )
{
	// in the animation, forward = +x and right = -y
	right = anglestoright( nodeAngles );
	forward = anglestoforward( nodeAngles );
		
	return vectorScale( forward, delta[0] ) + vectorScale( right, 0-delta[1] );
}

setupApproachNode( firstTime )
{
	self endon("killanimscript");
	
	// this lets code know that script is expecting the "corner_approach" notify
	if ( firstTime )
		self.requestArrivalNotify = true;
	
	self.a.arrivalType = undefined;
	self thread doLastMinuteExposedApproachWrapper();
	
	// "corner_approach" actually means "cover_approach".
	self waittill( "corner_approach", approach_dir );
	
	// if we're going to do a negotiation, we want to wait until it's over and move.gsc is called again
	if ( isdefined( self getnegotiationstartnode() ) )
	{
		/#
		debug_arrival( "Not doing approach: path has negotiation start node" );
		#/
		return;
	}
	
	if ( isdefined( self.disableArrivals ) && self.disableArrivals )
	{
		/#
		debug_arrival("Not doing approach: self.disableArrivals is true");
		#/
		return;
	}

	/*if ( self isCQBWalking() )
	{
		/#
		debug_arrival("Not doing approach: self.cqbwalking is true");
		#/
		return;
	}*/

	self thread setupApproachNode( false );	// wait again
	
	approachType = "exposed";
	approachPoint = self.pathGoalPos;
	approachNodeYaw = vectorToAngles( approach_dir )[1];
	approachFinalYaw = approachNodeYaw;
	if ( isdefined( self.node ) )
	{
		determineNodeApproachType( self.node );
		if ( isdefined( self.node.approachtype ) && self.node.approachtype != "exposed" )
		{
			approachType = self.node.approachtype;

			if ( approachType == "stand_saw" )
			{
				approachPoint = (self.node.turretInfo.origin[0], self.node.turretInfo.origin[1], self.node.origin[2]);
				forward = anglesToForward( (0,self.node.turretInfo.angles[1],0) );
				right = anglesToRight( (0,self.node.turretInfo.angles[1],0) );
				approachPoint = approachPoint + vectorScale( forward, -32.545 ) - vectorScale( right, 6.899 );
			}
			else if ( approachType == "crouch_saw" )
			{
				approachPoint = (self.node.turretInfo.origin[0], self.node.turretInfo.origin[1], self.node.origin[2]);
				forward = anglesToForward( (0,self.node.turretInfo.angles[1],0) );
				right = anglesToRight( (0,self.node.turretInfo.angles[1],0) );
				approachPoint = approachPoint + vectorScale( forward, -32.545 ) - vectorScale( right, 6.899 );
			}
			else if ( approachType == "prone_saw" )
			{
				approachPoint = (self.node.turretInfo.origin[0], self.node.turretInfo.origin[1], self.node.origin[2]);
				forward = anglesToForward( (0,self.node.turretInfo.angles[1],0) );
				right = anglesToRight( (0,self.node.turretInfo.angles[1],0) );
				approachPoint = approachPoint + vectorScale( forward, -37.36 ) - vectorScale( right, 13.279 );
			}
			else
			{
				approachPoint = self.node.origin;
			}
				
			approachNodeYaw = self.node.angles[1];
			approachFinalYaw = approachNodeYaw + getNodeStanceYawOffset( approachType );
		}
		
		/#
		if ( isdefined( level.testingApproaches ) && approachType == "exposed" )
		{
			approachNodeYaw = self.node.angles[1];
			approachFinalYaw = approachNodeYaw;
		}
		#/
	}
	
	//if ( approachType == "exposed" && !isdefined( self.pathGoalPos ) )
	//	return;
	
	/#
	if ( debug_arrivals_on_actor() )
	{
		println("^5approaching cover (ent " + self getentnum() + ", type \"" + approachType + "\"):");
		println("   approach_dir = (" + approach_dir[0] + ", " + approach_dir[1] + ", " + approach_dir[2] + ")");
		angle = AngleClamp180( vectortoangles( approach_dir )[1] - approachNodeYaw + 180 );
		if ( angle < 0 )
			println("   (Angle of " + (0-angle) + " right from node forward.)");
		else
			println("   (Angle of " + angle + " left from node forward.)");
	}
	#/
	
	// we're doing default exposed approaches in doLastMinuteExposedApproach now
	if ( approachType == "exposed" )
	{
		/#
		if ( isdefined( self.node ) )
		{
			if ( isdefined( self.node.approachtype ) )
				debug_arrival( "Aborting cover approach: node approach type was " + self.node.approachtype );
			else
				debug_arrival( "Aborting cover approach: node approach type was undefined" );
		}
		else
		{
			debug_arrival( "Aborting cover approach: self.node is undefined" );
		}
		#/
		return;
	}
	
	/#
	if ( debug_arrivals_on_actor() )
	{
		// removed this because it needs to be maintained/fixed but i didn't feel it was that important
		//thread drawTransAnglesOnNode(self.node);
		thread drawApproachVec(approach_dir);
	}
	#/
	
	//prof_begin( "move_startCornerApproach" );
	startCornerApproach( approachType, approachPoint, approachNodeYaw, approachFinalYaw, approach_dir );
	//prof_end( "move_startCornerApproach" );
}

startCornerApproach( approachType, approachPoint, approachNodeYaw, approachFinalYaw, approach_dir )
{
	self endon("killanimscript");
	self endon("corner_approach");
	
	assert( isdefined( approachType ) );
	
	if ( approachType == "stand" || approachType == "crouch" )
	{
		assert( isdefined( self.node ) );
		if ( AbsAngleClamp180( vectorToAngles( approach_dir )[1] - self.node.angles[1] + 180 ) < 60 )
		{
			/#
			debug_arrival( "approach aborted: approach_dir is too far forward for node type " + self.node.type );
			#/
			return;
		}
	}
	
	result = getMaxDirectionsAndExcludeDirFromApproachType( approachType );
	maxDirections = result.maxDirections;
	excludeDir = result.excludeDir;
	
	approachNumber = -1;
	approachYaw = undefined;
	finalPositionYawOffset = 0;
	
	if ( approachType == "exposed" )
	{
		result = self CheckArrivalEnterPositions( approachPoint, approachFinalYaw, approachType, approach_dir, maxDirections, excludeDir );
		/#
		for ( i = 0; i < result.data.size; i++ )
			debug_arrival( result.data[i] );
		#/
		if ( result.approachNumber < 0 )
		{
			/#
			debug_arrival( "approach aborted: " + result.failure );
			#/
			return;
		}
		approachNumber = result.approachNumber;
	}
	else
	{
		// approaching a node.
		// try arrival directions into exposed
		tryNormalApproach = true;
		// TODO: try approach to exposed
		/*if ( self shouldApproachToExposed() )
		{
			approachdata = getExposedApproachData();
			// use approachdata.point, approachdata.yaw
			
			// be careful not to set these if we're going to try a normal approach:
			approachFinalYaw = approachdata.yaw;
			approachType = "exposed";
			approachNumber = result.approachNumber;
			approachPoint = ...
			
		}*/
		if ( tryNormalApproach )
		{
			// try arrival directions into node itself
			result = self CheckArrivalEnterPositions( approachPoint, approachFinalYaw, approachType, approach_dir, maxDirections, excludeDir );
			/#
			for ( i = 0; i < result.data.size; i++ )
				debug_arrival( result.data[i] );
			#/
			if ( result.approachNumber < 0 )
			{
				/#
				debug_arrival( "approach aborted: " + result.failure );
				#/
				return;
			}
			approachNumber = result.approachNumber;
		}
	}
	
	/#
	debug_arrival( "approach success: dir " + approachNumber );
	#/
	
	self setRunToPos( self.coverEnterPos );
	
	
	self waittill("runto_arrived");
	
	
	if ( isdefined( self.disableArrivals ) && self.disableArrivals )
	{
		/#
		debug_arrival("approach aborted at last minute: self.disableArrivals is true");
		#/
		return;
	}
	
	/*if ( self isCQBWalking() )
	{
		/#
		debug_arrival("approach aborted at last minute: self.cqbwalking is true");
		#/
		return;
	}*/

	// so we don't make guys turn around when they're (smartly) facing their enemy as they walk away
	if ( abs( self getMotionAngle() ) > 45 && isdefined( self.enemy ) && vectorDot( anglesToForward( self.angles ), vectorNormalize( self.enemy.origin - self.origin ) ) > .8 )
	{
		/#
		debug_arrival("approach aborted at last minute: facing enemy instead of current motion angle");
		#/
		return;
	}

	if ( self.a.pose != "stand" || ( self.a.movement != "run" && !(self isCQBWalking()) ) )
	{
		/#
		debug_arrival( "approach aborted at last minute: not standing and running" );
		#/
		return;
	}
	
	requiredYaw = approachFinalYaw - anim.coverTransAngles[approachType][approachNumber];
	
	if ( AbsAngleClamp180( requiredYaw - self.angles[1] ) > 30 )
	{
		// don't do an approach away from an enemy that we would otherwise face as we moved away from them
		if ( isValidEnemy( self.enemy ) && self canSee( self.enemy ) && distanceSquared( self.origin, self.enemy.origin ) < 256 * 256 )
		{
			// check if enemy is in frontish of us
			if ( vectorDot( anglesToForward( self.angles ), self.enemy.origin - self.origin ) > 0 )
			{
				/#
				debug_arrival( "aborting approach at last minute: don't want to turn back to nearby enemy" );
				#/
				return;
			}
		}
	}

	// make sure the path is still clear
	if ( !checkCoverEnterPos( approachPoint, approachFinalYaw, approachType, approachNumber ) )
	{
		/#
		debug_arrival( "approach blocked at last minute" );
		#/
		return;
	}
	
	self.approachNumber = approachNumber;	// used in cover_arrival::main()
	self.approachType = approachType;
	self.doMiniArrival = undefined;
	self startcoverarrival( self.coverEnterPos, requiredYaw );
}

CheckArrivalEnterPositions( approachpoint, approachYaw, approachtype, approach_dir, maxDirections, excludeDir )
{
	angleDataObj = spawnstruct();
	
	calculateNodeTransitionAngles( angleDataObj, approachtype, true, approachYaw, approach_dir, maxDirections, excludeDir );
	sortNodeTransitionAngles( angleDataObj, maxDirections );
	
	resultobj = spawnstruct();
	/#resultobj.data = [];#/
	
	arrivalPos = (0, 0, 0);
	resultobj.approachNumber = -1;
	
	numAttempts = 2;
	if ( approachtype == "exposed" )
		numAttempts = 1;
	
	for ( i = 1; i <= numAttempts; i++ )
	{
		assert( angleDataObj.transIndex[i] != excludeDir ); // shouldn't hit excludeDir unless numAttempts is too big
		
		resultobj.approachNumber = angleDataObj.transIndex[i];
		if ( !self checkCoverEnterPos( approachpoint, approachYaw, approachtype, resultobj.approachNumber ) )
		{
			/#resultobj.data[resultobj.data.size] = "approach blocked: dir " + resultobj.approachNumber;#/
			continue;
		}
		break;
	}
	if ( i > numAttempts )
	{
		/#resultobj.failure = numAttempts + " direction attempts failed";#/
		resultobj.approachNumber = -1;
		return resultobj;
	}
	
	// if AI is closer to node than coverEnterPos is, don't do arrival
	distToApproachPoint = distanceSquared( approachpoint, self.origin );
	distToAnimStart = distanceSquared( approachpoint, self.coverEnterPos );
	if ( distToApproachPoint < distToAnimStart * 2 * 2 )
	{
		if ( distToApproachPoint < distToAnimStart )
		{
			/#resultobj.failure = "too close to destination";#/
			resultobj.approachNumber = -1;
			return resultobj;
		}
		
		// if AI is less than twice the distance from the node than the beginning of the approach animation,
		// make sure the angle we'll turn when we start the animation is small.
		selfToAnimStart = vectorNormalize( self.coverEnterPos - self.origin );
		AnimStartToNode = vectorNormalize( approachpoint - self.coverEnterPos );
		cosAngle = vectorDot( selfToAnimStart, AnimStartToNode );
		
		if ( cosAngle < 0.819 ) // 0.819 == cos(35)
		{
			/#resultobj.failure = "angle to start of animation is too great (angle of " + acos( cosAngle ) + " > 35)";#/
			resultobj.approachNumber = -1;
			return resultobj;
		}
	}
	
	return resultobj;
}

doLastMinuteExposedApproachWrapper()
{
	self endon("killanimscript");

	self notify("doing_last_minute_exposed_approach");
	self endon ("doing_last_minute_exposed_approach");
	
	self thread watchGoalChanged();
	
	while(1)
	{
		doLastMinuteExposedApproach();
		
		// try again when our goal pos changes
		while(1)
		{
			self waittill_any("goal_changed", "goal_changed_previous_frame");

			// our goal didn't *really* change if it only changed because we called setRunToPos
			if ( isdefined( self.coverEnterPos ) && isdefined( self.pathGoalPos ) && distanceSquared( self.coverEnterPos, self.pathGoalPos ) < 1 )
				continue;
			break;
		}
	}
}

watchGoalChanged()
{
	self endon("killanimscript");
	self endon ("doing_last_minute_exposed_approach");
	
	while(1)
	{
		self waittill("goal_changed");
		wait .05;
		self notify("goal_changed_previous_frame");
	}
}

doLastMinuteExposedApproach()
{
	self endon("goal_changed");
	
	if ( isdefined( self getnegotiationstartnode() ) )
		return;
	
	maxSpeed = 200; // units/sec
	
	allowedError = 6;

	// wait until we get to the point where we have to decide what approach animation to play
	while(1)
	{
		if ( !isdefined( self.pathGoalPos ) )
			self waitForPathGoalPos();
		
		dist = distance( self.origin, self.pathGoalPos );
		
		if ( dist <= anim.longestExposedApproachDist + allowedError )
			break;
		
		// underestimate how long to wait so we don't miss the crucial point
		waittime = (dist - anim.longestExposedApproachDist) / maxSpeed - .1;
		if ( waittime < .05 )
			waittime = .05;

		///#self thread animscripts\shared::showNoteTrack("wait " + waittime);#/
		wait waittime;
	}
	
	if ( isdefined( self.grenade ) && isdefined( self.grenade.activator ) && self.grenade.activator == self )
		return;
	
	// only do an arrival if we have a clear path
	if ( !self maymovetopoint( self.pathGoalPos ) )
	{
		/#debug_arrival("Aborting exposed approach: maymove check failed");#/
		return;
	}
	
	approachType = "exposed";
	
	if ( isdefined( self.node ) && isdefined( self.pathGoalPos ) && distanceSquared( self.pathGoalPos, self.node.origin ) < 1 )
	{
		determineNodeApproachType( self.node );
		if ( isdefined( self.node.approachtype ) && (self.node.approachtype == "exposed" || self.node.approachtype == "exposed_crouch") )
		{
			approachType = self.node.approachtype;
		}
		self thread alignToNodeAngles(); // we'll cancel this if our arrival succeeds
	}

	approachDir = VectorNormalize( self.pathGoalPos - self.origin );
	
	// by default, want to face forward
	desiredFacingYaw = vectorToAngles( approachDir )[1];
	if ( isValidEnemy( self.enemy ) && sightTracePassed( self.enemy getShootAtPos(), self.pathGoalPos + (0,0,60), false, undefined ) )
	{
		desiredFacingYaw = vectorToAngles( self.enemy.origin - self.pathGoalPos )[1];
	}
	else if ( isdefined( self.node ) && ( self.node.type == "Guard" ) && self.node.origin == self.pathGoalPos )
	{
		desiredFacingYaw = self.node.angles[1];
	}
	else
	{
		likelyEnemyDir = self getAnglesToLikelyEnemyPath();
		if ( isdefined( likelyEnemyDir ) )
			desiredFacingYaw = likelyEnemyDir[1];
	}
	
	angleDataObj = spawnstruct();
	calculateNodeTransitionAngles( angleDataObj, approachType, true, desiredFacingYaw, approachDir, 9, -1 );
	
	// take best animation
	best = 1;
	for ( i = 2; i < 9; i++ )
	{
		if ( angleDataObj.transitions[i] > angleDataObj.transitions[best] )
			best = i;
	}
	self.approachNumber = angleDataObj.transIndex[best];
	self.approachType = approachType;
	
	/#
	debug_arrival("Doing exposed approach in direction " + self.approachNumber);
	#/
	
	approachAnim = anim.coverTrans[approachType][self.approachNumber];
	
	animDist = length( anim.coverTransDist[approachType][self.approachNumber] );
	
	requiredDistSq = animDist + allowedError;
	requiredDistSq = requiredDistSq * requiredDistSq;
	
	// we should already be close
	while( isdefined( self.pathGoalPos ) && distanceSquared( self.origin, self.pathGoalPos ) > requiredDistSq )
		wait .05;
	
	if ( !isdefined( self.pathGoalPos ) )
	{
		/#
		debug_arrival("Aborting exposed approach because I have no path");
		#/
		return;
	}
	
	if ( isdefined( self.node ) && distanceSquared( self.pathGoalPos, self.node.origin ) < 1 )
	{
		if ( self.node.type != "Guard" && self.node.type != "Path" && self.node.type != "Cover Prone" && self.node.type != "Conceal Prone" )
		{
			/#
			debug_arrival("Aborting exposed approach because we're going to a cover node");
			#/
			return;
		}
	}

	if ( isdefined( self.disableArrivals ) && self.disableArrivals )
	{
		/#
		debug_arrival("Aborting exposed approach because self.disableArrivals is true");
		#/
		return;
	}

	if ( self isCQBWalking() && ( !isdefined( self.node ) || self.node.type == "Path" ) )
	{
		/#
		debug_arrival("Aborting exposed approach because self.cqbwalking is true and not going to a node");
		#/
		return;
	}

	if ( self.a.pose != "stand" || self.a.movement != "run" )
	{
		/#
		debug_arrival( "approach aborted at last minute: not standing and running" );
		#/
		return;
	}
	
	dist = distance( self.origin, self.pathGoalPos );
	if ( abs( dist - animDist ) > allowedError )
	{
		/#
		debug_arrival("Aborting exposed approach because distance difference exceeded allowed error: " + dist + " more than " + allowedError + " from " + animDist);
		#/
		return;
	}
	
	facingYaw = vectorToAngles( self.pathGoalPos - self.origin )[1];
	
	delta = anim.coverTransDist[approachType][self.approachNumber];
	assert( delta[0] != 0 );
	yawToMakeDeltaMatchUp = atan( delta[1] / delta[0] );
	
	requiredYaw = facingYaw - yawToMakeDeltaMatchUp;
	if ( AbsAngleClamp180( requiredYaw - self.angles[1] ) > 30 )
	{
		/#
		debug_arrival("Aborting exposed approach because angle change was too great");
		#/
		return;
	}
	
	closerDist = dist - animDist;
	idealStartPos = self.origin + VectorScale( vectorNormalize( self.pathGoalPos - self.origin ), closerDist );
	
	self notify( "dont_align_to_node_angles" );
	
	self startcoverarrival( idealStartPos, requiredYaw );
}

waitForPathGoalPos()
{
	while(1)
	{
		if ( isdefined( self.pathgoalpos ) )
			return;
		
		wait 1;
	}
}

alignToNodeAngles()
{
	self endon("killanimscript");
	self endon("goal_changed");
	self endon( "dont_align_to_node_angles" );
	self endon("doing_last_minute_exposed_approach");
	
	waittillframeend;
	
	// this is a last ditch fake approach.
	// we gradually turn to face the direction we want to face at the node
	// as we get there.
	
	maxdist = 80;
	
	while(1)
	{
		if ( !isdefined( self.node ) || self.node.type == "Path" || self.node.type == "Guard" || !isdefined( self.pathGoalPos ) || distanceSquared( self.node.origin, self.pathGoalPos ) > 1 )
			return;
		
		// don't do this if we're too far away.
		if ( distanceSquared( self.origin, self.node.origin ) > maxdist * maxdist )
		{
			wait .05;
			continue;
		}
		
		// don't do this if we're going to do an approach.
		if ( isdefined( self.coverEnterPos ) && isdefined( self.pathGoalPos ) && distanceSquared( self.coverEnterPos, self.pathGoalPos ) < 1 )
		{
			wait .1;
			continue;
		}
		
		break;
	}
	
	if ( isdefined( self.disableArrivals ) && self.disableArrivals )
		return;

	startdist = distance( self.origin, self.node.origin );
	
	if ( startdist <= 0 )
		return;
	
	determineNodeApproachType( self.node );
	
	startYaw = self.angles[1];
	targetYaw = self.node.angles[1];
	if ( isdefined( self.node.approachtype ) )
		targetYaw += getNodeStanceYawOffset( self.node.approachtype );
	targetYaw = startYaw + AngleClamp180(targetYaw - startYaw);
	
	self thread resetOrientModeOnGoalChange();

	while(1)
	{
		if ( !isdefined( self.node ) )
		{
			self orientMode("face default");
			return;
		}
		
		if ( self ShouldDoMiniArrival() )
		{
			self StartMiniArrival();
			return;
		}
		
		dist = distance( self.origin, self.node.origin );
		
		if ( dist > startdist * 1.1 ) // failsafe
		{
			self orientMode("face default");
			return;
		}
		
		distfrac = 1.0 - (dist / startdist);
		
		currentYaw = startYaw + distfrac * (targetYaw - startYaw);
		
		self orientMode( "face angle", currentYaw );
		
		wait .05;
	}
}

resetOrientModeOnGoalChange()
{
	self endon("killanimscript");
	self waittill_any("goal_changed", "dont_align_to_node_angles");
	
	self orientMode("face default");
}

startMoveTransition()
{
	self endon("killanimscript");
	
	self.exitingCover = false;
	
	// if we don't know where we're going, we can't check if it's a good idea to do the exit animation
	// (and it's probably not)
	if ( !isdefined( self.pathGoalPos ) )
	{
		/#
		debug_arrival("not exiting cover (ent " + self getentnum() + "): self.pathGoalPos is undefined");
		#/
		return;
	}
	
	if ( self.a.pose == "prone" )
	{
		/#
		debug_arrival("not exiting cover (ent " + self getentnum() + "): self.a.pose is \"prone\"");
		#/
		return;
	}
	
	if ( isdefined( self.disableExits ) && self.disableExits )
	{
		/#
		debug_arrival("not exiting cover (ent " + self getentnum() + "): self.disableExits is true");
		#/
		return;
	}
	
	if ( !self isStanceAllowed( "stand" ) )
	{
		/#
		debug_arrival("not exiting cover (ent " + self getentnum() + "): not allowed to stand");
		#/
		return;
	}
	
	/*if ( self isCQBWalking() )
	{
		/#
		debug_arrival("not exiting cover (ent " + self getentnum() + "): self.cqbwalking is true");
		#/
		return;
	}*/

	// assume an exit from exposed.
	exitpos = self.origin;
	exityaw = self.angles[1];
	exittype = "exposed";
	
	exitNode = undefined;
	if ( isdefined( self.node ) && ( distanceSquared( self.origin, self.node.origin ) < 225 ) )
		exitNode = self.node;
	else if ( isdefined( self.prevNode ) )
		exitNode = self.prevNode;
	
	// if we're at a node, try to do an exit from the node.
	if ( isdefined( exitNode ) )
	{
		determineNodeApproachType( exitNode );

		if ( isdefined( exitNode.approachtype ) && exitNode.approachtype != "exposed" && exitNode.approachtype != "stand_saw" && exitNode.approachType != "crouch_saw" )
		{
			// if far from cover node, or angle is wrong, don't do exit behavior for the node.
			
			distancesq = distancesquared( exitNode.origin, self.origin );
			anglediff = AbsAngleClamp180( self.angles[1] - exitNode.angles[1] - getNodeStanceYawOffset( exitNode.approachtype ) );
			if ( distancesq < 225 && anglediff < 5 ) // (225 = 15 * 15)
			{
				// do exit behavior for the node.
				exitpos = exitNode.origin;
				exityaw = exitNode.angles[1];
				exittype = exitNode.approachtype;
			}
		}
	}
	
	/#
	if ( debug_arrivals_on_actor() )
	{
		println("^3exiting cover (ent " + self getentnum() + ", type \"" + exittype + "\"):");
		println("   lookaheaddir = (" + self.lookaheaddir[0] + ", " + self.lookaheaddir[1] + ", " + self.lookaheaddir[2] + ")");
		angle = AngleClamp180( vectortoangles( self.lookaheaddir )[1] - exityaw );
		if ( angle < 0 )
			println("   (Angle of " + (0-angle) + " right from node forward.)");
		else
			println("   (Angle of " + angle + " left from node forward.)");
	}
	#/
	
	if ( !isdefined( exittype ) )
	{
		/#
		debug_arrival( "aborting exit: not supported for node type " + exitNode.type );
		#/
		return;
	}
	
	// since we transition directly into a standing run anyway,
	// we might as well just use the standing exits when crouching too
	if ( exittype == "exposed" )
	{
		if ( self.a.pose != "stand" && self.a.pose != "crouch" )
		{
			/#
			debug_arrival( "exposed exit aborted because anim_pose is not \"stand\" or \"crouch\"" );
			#/
			return;
		}
		if ( self.a.movement != "stop" )
		{
			/#
			debug_arrival( "exposed exit aborted because anim_movement is not \"stop\"" );
			#/
			return;
		}
		if ( self.a.pose == "crouch" )
			exittype = "exposed_crouch";
	}
	
	/*if ( exittype == "crouch" || exittype == "stand" )
	{
		if ( AbsAngleClamp180( vectorToAngles( self.lookaheaddir )[1] - exityaw ) < 60 )
		{
			/#
			debug_arrival( "aborting exit: lookaheaddir is too far forward for node type " + exittype );
			#/
			return;
		}
	}*/
	
	// don't do an exit away from an enemy that we would otherwise face as we moved away from them
	if ( isValidEnemy( self.enemy ) && vectorDot( self.lookaheaddir, self.enemy.origin - self.origin ) < 0 )
	{
		if ( self canSeeEnemyFromExposed() && distanceSquared( self.origin, self.enemy.origin ) < 300 * 300 )
		{
			/#
			debug_arrival( "aborting exit: don't want to turn back to nearby enemy" );
			#/
			return;
		}
	}
	
	// since we're leaving, take the opposite direction of lookahead
	leaveDir = ( -1 * self.lookaheaddir[0], -1 * self.lookaheaddir[1], 0 );
	
	//println("lookaheaddir: " + self.lookaheaddir[0] + " " + self.lookaheaddir[1] );
	
	
	result = getMaxDirectionsAndExcludeDirFromApproachType( exittype );
	maxDirections = result.maxDirections;
	excludeDir = result.excludeDir;
	
	exityaw = exityaw + getNodeStanceYawOffset( exittype );
	
	angleDataObj = spawnstruct();
	
	calculateNodeTransitionAngles( angleDataObj, exittype, false, exityaw, leaveDir, maxDirections, excludeDir );
	sortNodeTransitionAngles( angleDataObj, maxDirections );
	
	approachnumber = -1;
	numAttempts = 3;
	if ( exittype == "exposed" || exittype == "exposed_crouch" )
		numAttempts = 1;
	
	for ( i = 1; i <= numAttempts; i++ )
	{
		assert( angleDataObj.transIndex[i] != excludeDir ); // shouldn't hit excludeDir unless numAttempts is too big
	
		approachNumber = angleDataObj.transIndex[i];
		if ( self checkCoverExitPos( exitpos, exityaw, exittype, approachNumber ) )
			break;

		/#
		debug_arrival( "exit blocked: dir " + approachNumber );
		#/
	}
	
	if ( i > numAttempts )
	{
		/#
		debug_arrival( "aborting exit: too many exit directions blocked" );
	#/
		return;
	}

	// if AI is closer to destination than arrivalPos is, don't do exit
	allowedDistSq = distanceSquared( self.origin, self.coverExitPos ) * 1.25*1.25;
	if ( distanceSquared( self.origin, self.pathgoalpos ) < allowedDistSq )
	{
		/#
		debug_arrival( "exit failed, too close to destination" );
		#/
		return;
	}

	/#
	debug_arrival( "exit success: dir " + approachNumber );
	#/
	self doCoverExitAnimation( exittype, approachNumber );
}

str( val )
{
	if (!isdefined(val))
		return "{undefined}";
	return val;
}

doCoverExitAnimation( exittype, approachNumber )
{
	assert( isdefined( approachNumber ) );
	assert( approachnumber > 0 );
	
	assert( isdefined( exittype ) );

	leaveAnim = anim.coverExit[exittype][approachnumber];
	
	assert( isdefined( leaveAnim ) );

	lookaheadAngles = vectortoangles( self.lookaheaddir );
	
	/#
	if ( debug_arrivals_on_actor() )
	{
		endpos = self.origin + vectorscale( self.lookaheaddir, 100 );
		thread debugLine( self.origin, endpos, (1,0,0), 1.5 );
	}
	#/
	
	if ( self.a.pose == "prone" )
		return;

	transTime = 0.2;
	
	self animMode( "zonly_physics", false );
	self OrientMode( "face angle", self.angles[1] );
	self setFlaggedAnimKnobAllRestart( "coverexit", leaveAnim, %body, 1, transTime, 1 );
	
	hasExitAlign = animHasNotetrack( leaveAnim, "exit_align" );
	if ( !hasExitAlign )
		println("^1Animation anim.coverExit[\"" + exittype + "\"][" + approachnumber + "] has no \"exit_align\" notetrack");

	self thread DoNoteTracksForExit( "coverexit", hasExitAlign );
	
	self waittillmatch( "coverexit", "exit_align" );
	
	self.exitingCover = true;
	
	self.a.pose = "stand";
	self.a.movement = "run";

	hasCodeMoveNoteTrack = animHasNotetrack( leaveAnim, "code_move" );

	while ( 1 )
	{
		curfrac = self getAnimTime( leaveAnim );
		remainingMoveDelta = getMoveDelta( leaveAnim, curfrac, 1 );
		remainingAngleDelta = getAngleDelta( leaveAnim, curfrac, 1 );
		faceYaw = lookaheadAngles[1] - remainingAngleDelta;
		
		// make sure we can complete the animation in this direction
		forward = anglesToForward( (0,faceYaw,0) );
		right = anglesToRight( (0,faceYaw,0) );
		endPoint = self.origin + vectorScale( forward, remainingMoveDelta[0] ) - vectorScale( right, remainingMoveDelta[1] );
		
		if ( self mayMoveToPoint( endPoint ) )
		{
			self OrientMode( "face angle", faceYaw );
			break;
		}

		if ( hasCodeMoveNoteTrack )
			break;
		
		// wait a bit or until the animation is over, then try again
		
		timeLeft = getAnimLength( leaveAnim ) * (1 - curfrac) - .05;
		
		if ( timeLeft < .05 )
			break;
		
		if ( timeLeft > .4 )
			timeleft = .4;
		
		wait timeleft;
	}

	if ( hasCodeMoveNoteTrack )
	{
		self waittillmatch( "coverexit", "code_move" );
		self OrientMode( "face default" );
		self animmode( "none", false );
	}

	self waittillmatch("coverexit", "end");
	
	self clearanim( %root, 0 );

	// the end of the exit animations (should) line up *exactly* with the start of the run animations.
	// Play a run animation immediately so that if we blend to something other than a run, we don't pop.
	self setAnimRestart( %run_lowready_F, 1, 0 );
	
	self OrientMode( "face motion" );
	self thread faceEnemyOrMotionAfterABit();
	self animMode( "normal", false );
}

faceEnemyOrMotionAfterABit()
{
	self endon("killanimscript");
	
	wait 1.0;
	
	// don't want to spin around if we're almost where we're going anyway
	while ( isdefined( self.pathGoalPos ) && distanceSquared( self.origin, self.pathGoalPos ) < 200*200 )
		wait .25;
	
	self OrientMode( "face default" );
}

DoNoteTracksForExit( animname, hasExitAlign )
{
	self endon("killanimscript");
	self animscripts\shared::DoNoteTracks( animname );

	if ( !hasExitAlign )
		self notify( animname, "exit_align" ); // failsafe
}

/*RestartAllMoveAnims( timeUntilTheyWrap )
{
	// rely on loopsynch to reset the time of all movement animations
	fractionalTimeUntilTheyWrap = timeUntilTheyWrap / getAnimLength( %run_lowready_F );
	// this doesn't work unless the anim has a goal weight > 0
	self setanim( %run_lowready_F, .01, 1000 );
	self setanim( %precombatrun1, .01, 1000 );
	self setAnimTime( %run_lowready_F, 1 - fractionalTimeUntilTheyWrap );
	self setAnimTime( %precombatrun1, 1 - fractionalTimeUntilTheyWrap );
}*/


drawVec( start, end, duration, color )
{
	for( i = 0; i < duration * 100; i++ )
	{
		line( start + (0,0,30), end + (0,0,30), color);
		wait 0.05;
	}
}

drawApproachVec(approach_dir)
{
	self endon("killanimscript");
	for(;;)
	{
		if(!isdefined(self.node))
			break;
		line(self.node.origin + (0,0,20), (self.node.origin - vectorscale(approach_dir,64)) + (0,0,20));	
		wait(0.05);
	}	
}

calculateNodeTransitionAngles( angleDataObj, approachtype, isarrival, arrivalYaw, approach_dir, maxDirections, excludeDir )
{
	angleDataObj.transitions = [];
	angleDataObj.transIndex = [];
	
	anglearray = undefined;
	sign = 1;
	offset = 0;
	if ( isarrival )
	{
		anglearray = anim.coverTransAngles[approachtype];
		sign = -1;
		offset = 0;
	}
	else
	{
		anglearray = anim.coverExitAngles[approachtype];
		sign = 1;
		offset = 180;
	}
	
	for ( i = 1; i <= maxDirections; i++ )
	{
		angleDataObj.transIndex[i] = i;
		
		if ( i == 5 || i == excludeDir || !isdefined( anglearray[i] ) )
		{
			angleDataObj.transitions[i] = -1.0003;	// cos180 - epsilon
			continue;
		}
		
		angles = ( 0, arrivalYaw + sign * anglearray[i] + offset, 0 );
		
		dir = vectornormalize( anglestoforward( angles ) );
		angleDataObj.transitions[i] = vectordot( approach_dir, dir );
	}
}

/#
printdebug(pos, offset, text, color, linecolor)
{
	for ( i = 0; i < 20*5; i++ )
	{
		line(pos, pos+offset, linecolor);
		print3d(pos + offset, text, (color,color,color));
		wait .05;
	}
}
#/


// TODO: probably better done in code
// (actually, for an array of 8 elements, insertion sort should be fine)
sortNodeTransitionAngles( angleDataObj, maxDirections )
{
	for ( i = 2; i <= maxDirections; i++ )
	{
		currentValue = angleDataObj.transitions[ angleDataObj.transIndex[i] ];
		currentIndex = angleDataObj.transIndex[i];
		
		for ( j = i-1; j >= 1; j-- )
		{
			if ( currentValue < angleDataObj.transitions[ angleDataObj.transIndex[j] ] )
				break;
			
			angleDataObj.transIndex[j + 1]  = angleDataObj.transIndex[j];
		}
		
		angleDataObj.transIndex[j + 1] = currentIndex;
	}
}

checkCoverExitPos( exitpoint, exityaw, exittype, approachNumber )
{
	angle = (0, exityaw, 0);
	
	forwardDir = anglestoforward( angle );
	rightDir = anglestoright( angle );

	forward = vectorscale( forwardDir, anim.coverExitDist[exittype][approachNumber][0] );
	right   = vectorscale( rightDir, anim.coverExitDist[exittype][approachNumber][1] );
	
	exitPos = exitpoint + forward - right;
	self.coverExitPos = exitPos;
	
	isExposedApproach = ( exittype == "exposed" || exittype == "exposed_crouch" );
	
	/#
	if ( debug_arrivals_on_actor() )
		thread debugLine( self.origin, exitpos, (1,.5,.5), 1.5 );
	#/
	
	if ( !isExposedApproach && !( self checkCoverExitPosWithPath( exitPos ) ) )
	{
		/#
		debug_arrival( "cover exit " + approachNumber + " path check failed" );
		#/
		return false;
	}
	
	if ( !( self maymovefrompointtopoint( self.origin, exitPos ) ) )
		return false;

	if ( approachNumber <= 6 || isExposedApproach )
		return true;

	assert( exittype == "left" || exittype == "left_crouch" || exittype == "right" || exittype == "right_crouch" );

	// if 7, 8, 9 direction, split up check into two parts of the 90 degree turn around corner
	// (already did the first part, from node to corner, now doing from corner to end of exit anim)
	forward = vectorscale( forwardDir, anim.coverExitPostDist[exittype][approachNumber][0] );
	right   = vectorscale( rightDir, anim.coverExitPostDist[exittype][approachNumber][1] );
	
	finalExitPos = exitPos + forward - right;
	self.coverExitPos = finalExitPos;

	/#
	if ( debug_arrivals_on_actor() )
		thread debugLine( exitpos, finalExitPos, (1,.5,.5), 1.5 );
	#/
	return ( self maymovefrompointtopoint( exitPos, finalExitPos ) );
}

checkCoverEnterPos( arrivalpoint, arrivalYaw, approachtype, approachNumber )
{
	angle = (0, arrivalYaw - anim.coverTransAngles[approachtype][approachNumber], 0);
	
	forwardDir = anglestoforward( angle );
	rightDir = anglestoright( angle );

	forward = vectorscale( forwardDir, anim.coverTransDist[approachtype][approachNumber][0] );
	right   = vectorscale( rightDir, anim.coverTransDist[approachtype][approachNumber][1] );
	
	enterPos = arrivalpoint - forward + right;
	self.coverEnterPos = enterPos;

	/#
	if ( debug_arrivals_on_actor() )
		thread debugLine( enterPos, arrivalpoint, (1,.5,.5), 1.5 );
	#/
	if ( !( self maymovefrompointtopoint( enterPos, arrivalpoint ) ) )
		return false;
	
	if ( approachNumber <= 6 || approachtype == "exposed" || approachtype == "exposed_crouch" )
		return true;
	
	assert( approachtype == "left" || approachtype == "left_crouch" || approachtype == "right" || approachtype == "right_crouch" );
	
	// if 7, 8, 9 direction, split up check into two parts of the 90 degree turn around corner
	// (already did the second part, from corner to node, now doing from start of enter anim to corner)
	
	forward = vectorscale( forwardDir, anim.coverTransPreDist[approachtype][approachNumber][0] );
	right   = vectorscale( rightDir, anim.coverTransPreDist[approachtype][approachNumber][1] );
	
	originalEnterPos = enterPos - forward + right;
	self.coverEnterPos = originalEnterPos;
	
	/#
	if ( debug_arrivals_on_actor() )
		thread debugLine( originalEnterPos, enterPos, (1,.5,.5), 1.5 );
	#/
	return ( self maymovefrompointtopoint( originalEnterPos, enterPos ) );
}


ShouldDoMiniArrival()
{
	node = self.node;
	assert( isdefined( node ) );
	
	if ( getdvar("scr_miniarrivals") != "1" && getdvar("scr_miniarrivals") != "on" )
		return false;
	
	if ( distanceSquared( self.origin, node.origin ) > 40 * 40 )
		return false;
	
	determineNodeApproachType( node );
	
	// only cover stand for now
	if ( !isdefined( node.approachtype ) || node.approachtype != "stand" )
		return false;
	
	if ( !self mayMoveToPoint( node.origin ) )
		return false;
	
	return true;
}

StartMiniArrival()
{
	self.doMiniArrival = true;
	assert( isdefined( self.node ) );
	self.miniArrivalNode = self.node;
	self startcoverarrival( self.origin, self.angles[1] );
}

DoMiniArrival( node )
{
	arrivalanim = decideMiniArrivalAnim( node, self.origin );
	
	animtime = getAnimLength( arrivalanim );

	transTime = 0.2;
	if ( self.a.movement != "stop" )
		transTime = animtime * 0.65;
	
	self setAnimKnobAllRestart( arrivalAnim, %body, 1, transTime );
	
	totalAnimDist = length( getMoveDelta( arrivalAnim, 0, 1 ) );
	if ( totalAnimDist <= 0 )
		totalAnimDist = 0.5;
	
	numFrames = floor( animtime * 20 );
	
	startPos = self.origin;
	targetPos = node.origin;
	startYaw = self.angles[1];
	targetYaw = node.angles[1];
	if ( isdefined( node.approachtype ) )
		targetYaw += getNodeStanceYawOffset( node.approachtype );
	targetYaw = startYaw + AngleClamp180(targetYaw - startYaw);
	
	for ( i = 0; i < numFrames; i++ )
	{
		timefrac = (i + 1) / numFrames;
		frac = length( getMoveDelta( arrivalAnim, 0, timefrac ) ) / totalAnimDist;
		
		currentYaw = startYaw + frac * (targetYaw - startYaw);
		currentPos = startPos + frac * (targetPos - startPos);
		
		self orientMode( "face angle", currentYaw );
		self teleport( currentPos );
		
		wait .05;
	}
	
	return true;
}

decideMiniArrivalAnim( node, pos )
{
	dirToNode = pos - node.origin;
	angle = AngleClamp180( vectorToAngles( dirToNode )[1] - node.angles[1] );
	
	dir = -1;
	if ( angle < -180 + 22.5 )
		dir = 2;
	else if ( angle < -180 + 67.5 )
		dir = 3;
	else if ( angle < 0 )
		dir = 6;
	else if ( angle < 180 - 67.5 )
		dir = 4;
	else if ( angle < 180 - 22.5 )
		dir = 1;
	else
		dir = 2;
	
	// for now, assume cover stand
	anims = [];
	anims[1] = %coverstand_mini_approach_1;
	anims[2] = %coverstand_mini_approach_2;
	anims[3] = %coverstand_mini_approach_3;
	anims[4] = %coverstand_mini_approach_4;
	anims[6] = %coverstand_mini_approach_6;
	
	assertex( isdefined( anims[ dir ] ), dir );
	
	return anims[ dir ];
}


debug_arrivals_on_actor()
{
	/#
	dvar = getdebugdvar( "debug_arrivals" );
	if ( dvar == "off" )
		return false;
	
	if ( dvar == "on" )
		return true;
	
	if ( int( dvar ) == self getentnum() )
		return true;
	#/
	
	return false;
}


debug_arrival( msg )
{
	if ( !debug_arrivals_on_actor() )
		return;
	println( msg );
}
