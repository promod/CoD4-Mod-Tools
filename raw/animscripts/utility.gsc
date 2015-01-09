#include animscripts\SetPoseMovement;
#include animscripts\combat_utility;
#include common_scripts\utility;
#using_animtree( "generic_human" );

// Every script calls initAnimTree to ensure a clean, fresh, known animtree state.  
// clearanim should never be called directly, and this should never occur other than
// at the start of an animscript
// This function now also does any initialization for the scripts that needs to happen 
// at the beginning of every main script.
initAnimTree( animscript )
{
	if( isValidEnemy( self.a.personImMeleeing ) )
	{
		ImNotMeleeing( self.a.personImMeleeing );
	}
    
    self clearAnim( %body, 0.3 );
	self setAnim( %body, 1, 0 );	// The %body node should always have weight 1.
	
	if( animscript != "pain" && animscript != "death" )
		self.a.special = "none";
	
	self.missedSightChecks = 0;

	self.a.aimweight = 1.0;
	self.a.aimweight_start = 1.0;
	self.a.aimweight_end = 1.0;
	self.a.aimweight_transframes = 0;
	self.a.aimweight_t = 0;
	
	self setanim( %shoot, 0, 0.2, 1 );
	
	IsInCombat();
	
	assertEX( isDefined( animscript ), "Animscript not specified in initAnimTree" );
	self.a.script = animscript;
	
	// Call the handler to get out of Cowering pose.
	[[ self.a.StopCowering ]]();
}

// UpdateAnimPose does housekeeping at the start of every script's main function.  It does stuff like making prone 
// calculations are only being done if the character is actually prone.
UpdateAnimPose()
{
	assertEX( self.a.movement == "stop" || self.a.movement == "walk" || self.a.movement == "run", "UpdateAnimPose " + self.a.pose + " " + self.a.movement );
	
	if( isDefined( self.desired_anim_pose ) && self.desired_anim_pose != self.a.pose )
	{
		if( self.a.pose == "prone" )
			self ExitProneWrapper( 0.5 );
			
		if( self.desired_anim_pose == "prone" )
		{
			self SetProneAnimNodes( - 45, 45, %prone_legs_down, %exposed_aiming, %prone_legs_up );
			self EnterProneWrapper( 0.5 ); 
			self setAnimKnobAll( %prone_aim_5, %body, 1, 0.1, 1 );
		}		
	}
	
	self.desired_anim_pose = undefined;
}


initialize( animscript )
{
	if ( isdefined( self.longDeathStarting ) )
	{
		if ( animscript != "pain" && animscript != "death" )
		{
			// we probably just came out of an animcustom.
			// just die, it's not safe to do anything else
			self dodamage( self.health + 100, self.origin );
		}
		if ( animscript != "pain" )
		{
			self.longDeathStarting = undefined;
			self notify( "kill_long_death" );
		}
	}
	if ( isdefined( self.a.mayOnlyDie ) && animscript != "death" )
	{
		// we probably just came out of an animcustom.
		// just die, it's not safe to do anything else
		self dodamage( self.health + 100, self.origin );
	}
	
	// scripts can define this to allow cleanup before moving on
	if( isDefined( self.a.postScriptFunc ) )
	{
		scriptFunc = self.a.postScriptFunc;
		self.a.postScriptFunc = undefined;
		
		[[ scriptFunc ]]( animscript );
	}
	
	// TODO: proper handing when animations exist
	if( animscript != "combat" && animscript != "pain" && animscript != "death" && usingSidearm() )
	{
		self animscripts\shared::placeWeaponOn( self.primaryweapon, "right" );
	}
	
	if( animscript != "combat" && animscript != "move" && animscript != "pain" )
		self.a.magicReloadWhenReachEnemy = false;
	
	if ( animscript != "death" )
		self.a.nodeath = false;
	
	if ( isDefined( self.isHoldingGrenade ) && (animscript == "pain" || animscript == "death" || animscript == "flashed") )
	{
		self dropGrenade();
	}
	self.isHoldingGrenade = undefined;

	/#
	//thread checkGrenadeInHand( animscript );
	#/
	
	self animscripts\squadmanager::aiUpdateAnimState( animscript );
	
	self.coverNode = undefined;
	self.suppressed = false;
	self.isReloading = false;
	self.changingCoverPos = false;
	self.a.scriptStartTime = gettime();
	
	self.a.atConcealmentNode = false;
	if( isdefined( self.node ) && ( self.node.type == "Conceal Prone" || self.node.type == "Conceal Crouch" || self.node.type == "Conceal Stand" ) )
		self.a.atConcealmentNode = true;
	
	initAnimTree( animscript );

	UpdateAnimPose();
}

/#
checkGrenadeInHand( animscript )
{
	// ensure no grenade left in hand
	self endon("killanimscript");
	
	// pain and death animscripts don't execute script between notifying killanimscript and starting the next animscript,
	// so the grenade cleanup thread might still be waiting to run.
	if ( animscript == "pain" || animscript == "death" )
	{
		wait .05;
		waittillframeend;
	}
	
	attachSize = self getattachsize();
	for ( i = 0; i < attachSize; i++ )
	{
		model = toLower( self getAttachModelName( i ) );
		assertex( model != "weapon_m67_grenade", "AI has a grenade in hand after animscript finished. Please call over an animscripter! " + self.origin );
		assertex( model != "weapon_m84_flashbang_grenade", "AI has a grenade in hand after animscript finished. Please call over an animscripter! " + self.origin );
		assertex( model != "weapon_us_smoke_grenade", "AI has a grenade in hand after animscript finished. Please call over an animscripter! " + self.origin );
	}
}
#/

getPreferredWeapon()
{
	if( isdefined( self.wantshotgun ) && self.wantshotgun )
	{
		if( weaponclass( self.primaryweapon ) == "spread" )
			return self.primaryweapon;
		else if( weaponclass( self.secondaryweapon ) == "spread" )
			return self.secondaryweapon;
	}
	return self.primaryweapon;
}

should_find_a_new_node()
{
	self.a.next_move_to_new_cover -- ;
	if( self.a.next_move_to_new_cover > 0 )
		return false;
	anim_set_next_move_to_new_cover();
	return true;
}


badplacer( time, org, radius )
{
	for( i = 0;i < time * 20;i ++ )
	{
		for( p = 0;p < 10;p ++ )
		{
			angles = ( 0, randomint( 360 ), 0 );
			forward = anglestoforward( angles );
			scale = vectorScale( forward, radius );
			line( org, org + scale, ( 1, 0.3, 0.3 ) );
		}
		wait( 0.05 );
	}
}


printDisplaceInfo()
{
	self endon( "death" );
	self notify( "displaceprint" );
	self endon( "displaceprint" );
	for( ;; )
	{
		print3d( self.origin + ( 0, 0, 60 ), "displacer", ( 0, 0.4, 0.7 ), 0.85, 0.5 );
		wait( 0.05 );
	}
}


getOldRadius()
{
	self notify( "newOldradius" );
	self endon( "newOldradius" );
	self endon( "death" );
	wait( 6 );
	self.goalradius = self.a.oldgoalradius;
}

// Called from special node behaviors at times when eyes could see enemy
// After X checks are missed the script tells code to bail on special behavior
sightCheckNodeProc( invalidateNode, viewOffset )
{
    if( !isDefined( self.missedSightChecks ) )
        self . missedSightChecks = 0;
	if( !isDefined( invalidateNode ) )
		invalidateNode = 1;

	if( isdefined( viewOffset ) )
		canShootAt = canShootEnemyFrom( viewOffset );
	else
		canShootAt = self canShootEnemy();
		
    if( !canShootAt )
	{
		if( invalidateNode )
		  self . missedSightChecks ++ ;
	}
    else
        self . missedSightChecks = 0;// make consecutive
    
    if( self . missedSightChecks > 4 )
    {
		// thread [[ anim.println ]]( "SightCheckNode failed one time too many.  Invalidating current cover node." );#/ 
		self lookForBetterCover();
        self . missedSightChecks = 0;
    }

	return canShootAt;
}

// Called from special node behaviors at times when eyes could see enemy
// After X checks are missed the script tells code to bail on special behavior
sightCheckNode_invalidate( viewOffset )
{
	return sightCheckNodeProc( true, viewOffset );
}

// Called from special node behaviors at times when eyes could see enemy
sightCheckNode( viewOffset )
{
	return sightCheckNodeProc( false, viewOffset );
}

// Returns whether or not the character should be acting like he's under fire or expecting an enemy to appear 
// any second.
IsInCombat()
{
	if( isValidEnemy( self.enemy ) )
	{
		self.a.combatEndTime = gettime() + anim.combatMemoryTimeConst + randomint( anim.combatMemoryTimeRand );
		return true;
	}
	return( self.a.combatEndTime > gettime() );
}


 /#
DebugIsInCombat()
{
	return( self.a.combatEndTime > gettime() );
}
#/ 


holdingWeapon()
{
	if( self.a.weaponPos[ "right" ] == "none" )
		return( false );
		
	if( !isdefined( self.holdingWeapon ) )
		return( true );
		
	return( self.holdingWeapon );
}


// Takes a pose( "stand", "crouch", "prone" ) and an optional offset in local space, [ forward, right, up ].
canShootEnemyFromPose( pose, offset, useSightCheck )
{
	if( self.weapon == "mg42" )
		return false;
		
	switch( pose )
	{
	case "stand":
		if( self.a.pose == "stand" )
			poseOffset = ( 0, 0, 0 );
		else if( self.a.pose == "crouch" )
			poseOffset = ( 0, 0, 20 );
		else if( self.a.pose == "prone" )
			poseOffset = ( 0, 0, 55 );
		else
		{
			assertEX( 0, "init::canShootEnemyFromPose " + self.a.pose );
			poseOffset = ( 0, 0, 0 );
		}
		break;
    
	case "crouch":
		if( self.a.pose == "stand" )
			poseOffset = ( 0, 0, -20 );
		else if( self.a.pose == "crouch" )
			poseOffset = ( 0, 0, 0 );
		else if( self.a.pose == "prone" )
			poseOffset = ( 0, 0, 35 );
		else
		{
			assertEX( 0, "init::canShootEnemyFromPose " + self.a.pose );
			poseOffset = ( 0, 0, 0 );
		}
		break;

	case "prone":
		if( self.a.pose == "stand" )
			poseOffset = ( 0, 0, -55 );
		else if( self.a.pose == "crouch" )
			poseOffset = ( 0, 0, -35 );
		else if( self.a.pose == "prone" )
			poseOffset = ( 0, 0, 0 );
		else
		{
			assertEX( 0, "init::canShootEnemyFromPose " + self.a.pose );
			poseOffset = ( 0, 0, 0 );
		}
		break;

	default:
		assertEX( 0, "init::canShootEnemyFromPose - bad supplied pose: " + pose );
		poseOffset = ( 0, 0, 0 );
		break;
	}

	if( isDefined( offset ) )
	{
		poseOffset = poseOffset + self LocalToWorldCoords( offset ) - self.origin;
	}

	return canShootEnemyFrom( poseOffset, undefined, useSightCheck );
}

// Checks multiple points on the enemy, to see if I can shoot any of them.  Check that I can see my enemy 
// too, since canshoot checks from the gun barrel and the gun barrel is often through a wall.  UseSightCheck 
// is optional, defaults to true.
canShootEnemy( posOverrideEntity, useSightCheck )
{
	return canShootEnemyFrom( ( 0, 0, 0 ), posOverrideEntity, useSightCheck );
}

canShootEnemyPos( posOverrideOrigin )
{
	return canShootEnemyFrom( ( 0, 0, 0 ), undefined, true, posOverrideOrigin );	// posOverrideEntity is optional, specifies a substitute enemy.
}
// posOverrideEntity is optional, specifies a substitute enemy.
// useSightCheck is optional, defaults to true.
canShootEnemyFrom( offset, posOverrideEntity, useSightCheck, posOverrideOrigin )
{
	if( !isValidEnemy( self.enemy ) && !isValidEnemy( posOverrideEntity ) )
 		return false;
 		
	if( !holdingWeapon() )
		return false;

	if( isDefined( posOverrideEntity ) )
	{
		if( isSentient( posOverrideEntity ) )
		{
			eye = posOverrideEntity GetEye();
			chest = eye + ( 0, 0, -20 );
		}
		else
		{
			eye = posOverrideEntity.origin;
			chest = eye;
		}
	}
	else
	if( isdefined( posOverrideOrigin ) )
	{
		eye = posOverrideOrigin;
		chest = eye + ( 0, 0, -20 );
	}
	else
	{
		eye = GetEnemyEyePos();
		chest = eye + ( 0, 0, -20 );
	}

	myGunPos = self GetTagOrigin( "tag_flash" );
	if( !isDefined( useSightCheck ) )
		useSightCheck = true;
	if( useSightCheck )
	{
		// "Proper" way( doesn't work because CanSee cannot be called on a vector or with a vector as a parameter )
		// myEye = self getShootAtPos();
		// myEye = myEye + offset;
		// canSee = myEye CanSee( self.enemy );
		// Simple way( not thorough enough for all cases )
		// canSee = self CanSee( self.enemy );
		// Hack way, using canShoot and adding the offset from muzzle to eye.
		myEyeOffset = ( self getShootAtPos() - myGunPos );
		canSee = self canshoot( eye, myEyeOffset + offset );
		// Draw a debug line to my enemy's eye( or just above it, so that the player can see it if the enemy is him ).
		 /#
		if( canSee )
		{
			if( getdebugdvarint( "anim_dotshow" ) == self getentnum() )
			if( getdebugdvar( "anim_debug" ) == "3" )
				thread showDebugLine( myGunPos + myEyeOffset + offset, eye + ( 0, 0, 2 ), ( .5, 1, .5 ), 5 );
		}
		else
		{
			if( getdebugdvarint( "anim_dotshow" ) == self getentnum() )
			if( getdebugdvar( "anim_debug" ) == "3" )
				thread showDebugLine( myGunPos + myEyeOffset + offset, eye + ( 0, 0, 2 ), ( 1, .5, .5 ), 5 );
		}
		#/ 
	}
	else
		canSee = true;

	if( !canSee )
		return false;

	canShoot = self canshoot( eye, offset ) || self canshoot( chest, offset );

	 /#
	if( canShoot )
	{
		if( getdebugdvarint( "anim_dotshow" ) == self getentnum() )
		if( getdebugdvar( "anim_debug" ) == "3" )
			thread showDebugLine( myGunPos + offset + ( 0, 0, 2 ), eye + ( 0, 0, 4 ), ( .5, 1, .5 ), 5 );
	}
	else
	{
		if( getdebugdvarint( "anim_dotshow" ) == self getentnum() )
		if( getdebugdvar( "anim_debug" ) == "3" )
			thread showDebugLine( myGunPos + offset + ( 0, 0, 2 ), eye + ( 0, 0, 4 ), ( 1, .5, .5 ), 5 );
	}
	#/ 

	return( canShoot );
}


GetEnemyEyePos()
{
    if( isValidEnemy( self.enemy ) )
	{
		self.a.lastEnemyPos = self.enemy getShootAtPos();
		self.a.lastEnemyTime = gettime();
		return self.a.lastEnemyPos;
	}
	else if( 
			( isDefined( self.a.lastEnemyTime ) ) && 
			( isDefined( self.a.lastEnemyPos ) ) && 
			( self.a.lastEnemyTime + 3000 < gettime() ) 
			 )
	{
		return self.a.lastEnemyPos;
	}
	else
	{
		// Return a point in front of you.  Note that the distance to this point is significant, because 
		// this function is used to determine an appropriate attack stance. 16 feet( 196 units ) seems good...
		targetPos = self getShootAtPos();
		targetPos = targetPos + ( 196 * self.lookforward[ 0 ], 196 * self.lookforward[ 1 ], 196 * self.lookforward[ 2 ] );
		return targetPos;
	}
}

GetNodeYawToOrigin( pos )
{
	if( isdefined( self.node ) )
		yaw = self.node.angles[ 1 ] - GetYaw( pos );
	else
		yaw = self.angles[ 1 ] - GetYaw( pos );
	
	yaw = AngleClamp180( yaw );
	return yaw;
}

GetNodeYawToEnemy()
{
	pos = undefined;
	if( isValidEnemy( self.enemy ) )
	{
		pos = self.enemy.origin;
	}
	else
	{
		if( isdefined( self.node ) )
			forward = anglestoforward( self.node.angles );
		else
			forward = anglestoforward( self.angles );
		forward = vectorScale( forward, 150 );
		pos = self.origin + forward;
	}
	
	if( isdefined( self.node ) )
		yaw = self.node.angles[ 1 ] - GetYaw( pos );
	else
		yaw = self.angles[ 1 ] - GetYaw( pos );
	yaw = AngleClamp180( yaw );
	return yaw;
}

GetCoverNodeYawToEnemy()
{
	pos = undefined;
	if( isValidEnemy( self.enemy ) )
	{
		pos = self.enemy.origin;
	}
	else
	{
		forward = anglestoforward( self.coverNode.angles + self.animarray[ "angle_step_out" ][ self.a.cornerMode ] );
		forward = vectorScale( forward, 150 );
		pos = self.origin + forward;
	}
	
	yaw = self.CoverNode.angles[ 1 ] + self.animarray[ "angle_step_out" ][ self.a.cornerMode ] - GetYaw( pos );
	yaw = AngleClamp180( yaw );
	return yaw;
}

GetYawToSpot( spot )
{
	pos = spot;
	yaw = self.angles[ 1 ] - GetYaw( pos );
	yaw = AngleClamp180( yaw );
	return yaw;
}
// warning! returns (my yaw - yaw to enemy) instead of (yaw to enemy - my yaw)
GetYawToEnemy()
{
	pos = undefined;
	if( isValidEnemy( self.enemy ) )
	{
		pos = self.enemy.origin;
	}
	else
	{
		forward = anglestoforward( self.angles );
		forward = vectorScale( forward, 150 );
		pos = self.origin + forward;
	}
	
	yaw = self.angles[ 1 ] - GetYaw( pos );
	yaw = AngleClamp180( yaw );
	return yaw;
}

GetYaw( org )
{
	angles = VectorToAngles( org - self.origin );
	return angles[ 1 ];
}

GetYaw2d( org )
{
	angles = VectorToAngles( ( org[ 0 ], org[ 1 ], 0 ) - ( self.origin[ 0 ], self.origin[ 1 ], 0 ) );
	return angles[ 1 ];
}

// 0 if I'm facing my enemy, 90 if I'm side on, 180 if I'm facing away.
AbsYawToEnemy()
{
	assert( isValidEnemy( self.enemy ) );
	yaw = self.angles[ 1 ] - GetYaw( self.enemy.origin );
	yaw = AngleClamp180( yaw );
	if( yaw < 0 )
		yaw = -1 * yaw;
	return yaw;
}

// 0 if I'm facing my enemy, 90 if I'm side on, 180 if I'm facing away.
AbsYawToEnemy2d()
{
	assert( isValidEnemy( self.enemy ) );
	yaw = self.angles[ 1 ] - GetYaw2d( self.enemy.origin );
	yaw = AngleClamp180( yaw );
	if( yaw < 0 )
		yaw = -1 * yaw;
	return yaw;
}

// 0 if I'm facing my enemy, 90 if I'm side on, 180 if I'm facing away.
AbsYawToOrigin( org )
{
	yaw = self.angles[ 1 ] - GetYaw( org );
	yaw = AngleClamp180( yaw );
	if( yaw < 0 )
		yaw = -1 * yaw;
	return yaw;
}

AbsYawToAngles( angles )
{
	yaw = self.angles[ 1 ] - angles;
	yaw = AngleClamp180( yaw );
	if( yaw < 0 )
		yaw = -1 * yaw;
	return yaw;
}

GetYawFromOrigin( org, start )
{
	angles = VectorToAngles( org - start );
	return angles[ 1 ];
}

GetYawToTag( tag, org )
{
	yaw = self gettagangles( tag )[ 1 ] - GetYawFromOrigin( org, self gettagorigin( tag ) );
	yaw = AngleClamp180( yaw );
	return yaw;
}

GetYawToOrigin( org )
{
	yaw = self.angles[ 1 ] - GetYaw( org );
	yaw = AngleClamp180( yaw );
	return yaw;
}

GetEyeYawToOrigin( org )
{
	yaw = self gettagangles( "TAG_EYE" )[ 1 ] - GetYaw( org );
	yaw = AngleClamp180( yaw );
	return yaw;
}

GetCoverNodeYawToOrigin( org )
{
	yaw = self.coverNode.angles[ 1 ] + self.animarray[ "angle_step_out" ][ self.a.cornerMode ] - GetYaw( org );
	yaw = AngleClamp180( yaw );
	return yaw;
}


isStanceAllowedWrapper( stance )
{
	if( isdefined( self.coverNode ) )
		return self.coverNode doesNodeAllowStance( stance );
	return self isStanceAllowed( stance );
}


choosePose( preferredPose )
{
	if( !isDefined( preferredPose ) )
	{
		preferredPose = self.a.pose;
	}
	if( EnemiesWithinStandingRange() )
	{
		preferredPose = "stand";
	}
	
	// Find out if we should be standing, crouched or prone
	switch( preferredPose )
	{
	case "stand":
		if( self isStanceAllowedWrapper( "stand" ) )
		{
			resultPose = "stand";
		}
		else if( self isStanceAllowedWrapper( "crouch" ) )
		{
			resultPose = "crouch";
		}
		else if( self isStanceAllowedWrapper( "prone" ) )
		{
			resultPose = "prone";
		}
		else
		{
			println( "No stance allowed!  Remaining standing." );
			resultPose = "stand";
		}
		break;

	case "crouch":
		if( self isStanceAllowedWrapper( "crouch" ) )
		{
			resultPose = "crouch";
		}
		else if( self isStanceAllowedWrapper( "stand" ) )
		{
			resultPose = "stand";
		}
		else if( self isStanceAllowedWrapper( "prone" ) )
		{
			resultPose = "prone";
		}
		else
		{
			println( "No stance allowed!  Remaining crouched." );
			resultPose = "crouch";
		}
		break;

	case "prone":
		if( self isStanceAllowedWrapper( "prone" ) )
		{
			resultPose = "prone";
		}
		else if( self isStanceAllowedWrapper( "crouch" ) )
		{
			resultPose = "crouch";
		}
		else if( self isStanceAllowedWrapper( "stand" ) )
		{
			resultPose = "stand";
		}
		else
		{
			println( "No stance allowed!  Remaining prone." );
			resultPose = "prone";
		}
		break;

	default:
		println( "utility::choosePose, called in " + self.a.script + " script: Unhandled anim_pose " + self.a.pose + " - using stand." );
		resultPose = "stand";
		break;
	}
	return resultPose;
}

// Melee stuff.  Note that isAlive is better than isDefined when you're checking variables that are either 
// undefined or set to an AI.
okToMelee( person )
{
	assert( isDefined( person ) );
	if( isDefined( self.a.personImMeleeing ) )		// Tried to melee someone else when I am already meleeing, possibly because code changed my enemy.
	{
		ImNotMeleeing( self.a.personImMeleeing );
		assert( !isDefined( self.a.personImMeleeing ) );
	}
	if( isDefined( person.a.personMeleeingMe ) )
	{
		// This means that oldAttacker was the last person to melee person.  He may or may not still be meleeing him.
		oldAttacker = person.a.personMeleeingMe;
		if( isDefined( oldAttacker.a.personImMeleeing ) && oldAttacker.a.personImMeleeing == person )
		{
			// This means that oldAttacker is currently meleeing person.
			return false;
		}
		println( "okToMelee - Shouldn't get to here" );
		// This means that oldAttacker is no longer meleeing person and somehow person was never informed.  We can still handle it though.
		person.a.personMeleeingMe = undefined;
		assert( !isDefined( self.a.personImMeleeing ) );
		assert( !isDefined( person.a.personMeleeingMe ) );
		return true;
	}
	assert( !isDefined( self.a.personImMeleeing ) );
	assert( !isDefined( person.a.personMeleeingMe ) );
	return true;
}

IAmMeleeing( person )
{
	assert( isDefined( person ) );
	assert( !isDefined( person.a.personMeleeingMe ) );
	assert( !isDefined( self.a.personImMeleeing ) );
	person.a.personMeleeingMe = self;
	self.a.personImMeleeing = person;
}

ImNotMeleeing( person )
{
	// First check that everything is in synch, just for my own peace of mind.  This can go away once there are no bugs.
	if( ( isDefined( person ) ) && ( isDefined( self.a.personImMeleeing ) ) && ( self.a.personImMeleeing == person ) )
	{
		assert( isDefined( person.a.personMeleeingMe ) );
		assert( person.a.personMeleeingMe == self );
	}
	// This function does not require that I was meleeing Person to start with.  
	if( !isDefined( person ) )
	{
		self.a.personImMeleeing = undefined;
	}
	else if( ( isDefined( person.a.personMeleeingMe ) ) && ( person.a.personMeleeingMe == self ) )
	{
		person.a.personMeleeingMe = undefined;
		assert( self.a.personImMeleeing == person );
		self.a.personImMeleeing = undefined;
	}
	// A final check that I got this right...
	assert( !isDefined( person ) || !isDefined( self.a.personImMeleeing ) || ( self.a.personImMeleeing!= person ) );
	assert( !isDefined( person ) || !isDefined( person.a.personMeleeingMe ) || ( person.a.personMeleeingMe!= self ) );
}

WeaponAnims()
{
	weaponModel = getWeaponModel( self.weapon );
	
	if( ( isDefined( self.holdingWeapon ) && !self.holdingWeapon ) || weaponModel == "" )
		return "none";

	class = weaponClass( self.weapon );
	
	switch( class )
	{
		case "mg":
		case "smg":
			return "rifle";
		
		case "rifle":
		case "pistol":
		case "rocketlauncher":
		case "spread":
			return class;
			
		default:
// 			assertMsg( "no animations for weapon class: " + class );
			return "rifle";
	}
}

GetClaimedNode()
{
	myNode = self.node;
	if( isdefined( myNode ) && ( self nearNode( myNode ) || ( isdefined( self.coverNode ) && myNode == self.coverNode ) ) )
		return myNode;
	return undefined;
}

GetNodeType()
{
	myNode = GetClaimedNode();
	if( isDefined( myNode ) )
		return myNode.type;
	return "none";
}

GetNodeDirection()
{
	myNode = GetClaimedNode();
	if( isdefined( myNode ) )
	{
		// thread [[ anim.println ]]( "GetNodeDirection found node, returned: " + myNode.angles[ 1 ] );#/ 
		return myNode.angles[ 1 ];
	}
	// thread [[ anim.println ]]( "GetNodeDirection didn't find node, returned: " + self.desiredAngle );#/ 
	return self.desiredAngle;
}

GetNodeForward()
{
	myNode = GetClaimedNode();
	if( isdefined( myNode ) )
		return AnglesToForward( myNode.angles );
	return AnglesToForward( self.angles );
}

GetNodeOrigin()
{
	myNode = GetClaimedNode();
	if( isdefined( myNode ) )
		return myNode.origin;
	return self.origin;
}

 /#
isDebugOn()
{
	return( ( getdebugdvarint( "animDebug" ) == 1 ) || ( isDefined( anim.debugEnt ) && anim.debugEnt == self ) );
}

drawDebugLineInternal( fromPoint, toPoint, color, durationFrames )
{
	// println( "Drawing line, color " + color[ 0 ] + ", " + color[ 1 ] + ", " + color[ 2 ] );
	// player = getent( "player", "classname" );
	// println( "Point1 : " + fromPoint + ", Point2: " + toPoint + ", player: " + player.origin );
	for( i = 0;i < durationFrames;i ++ )
	{
		line( fromPoint, toPoint, color );
		wait( 0.05 );
	}
}

drawDebugLine( fromPoint, toPoint, color, durationFrames )
{
	if( isDebugOn() )
		thread drawDebugLineInternal( fromPoint, toPoint, color, durationFrames );
}

debugLine( fromPoint, toPoint, color, durationFrames )
{
	for( i = 0;i < durationFrames * 20;i ++ )
	{
		line( fromPoint, toPoint, color );
		wait( 0.05 );
	}
}

drawDebugCross( atPoint, radius, color, durationFrames )
{
	atPoint_high = 		atPoint + ( 		0, 			0, 		   radius	 );
	atPoint_low = 		atPoint + ( 		0, 			0, 		 - 1 * radius	 );
	atPoint_left = 		atPoint + ( 		0, 		   radius, 		0		 );
	atPoint_right = 		atPoint + ( 		0, 		 - 1 * radius, 		0		 );
	atPoint_forward = 	atPoint + (  radius, 		0, 			0		 );
	atPoint_back = 		atPoint + ( - 1 * radius, 		0, 			0		 );
	thread debugLine( atPoint_high, 	atPoint_low, 	color, durationFrames );
	thread debugLine( atPoint_left, 	atPoint_right, 	color, durationFrames );
	thread debugLine( atPoint_forward, 	atPoint_back, 	color, durationFrames );
}

drawDebugCrossOld( atPoint, radius, color, durationFrames )
{
	if( thread isDebugOn() )
	{
		atPoint_high = 		atPoint + ( 		0, 			0, 		   radius	 );
		atPoint_low = 		atPoint + ( 		0, 			0, 		 - 1 * radius	 );
		atPoint_left = 		atPoint + ( 		0, 		   radius, 		0		 );
		atPoint_right = 		atPoint + ( 		0, 		 - 1 * radius, 		0		 );
		atPoint_forward = 	atPoint + (  radius, 		0, 			0		 );
		atPoint_back = 		atPoint + ( - 1 * radius, 		0, 			0		 );
		thread animscripts\utility::drawDebugLine( atPoint_high, 	atPoint_low, 	color, durationFrames );
		thread animscripts\utility::drawDebugLine( atPoint_left, 	atPoint_right, 	color, durationFrames );
		thread animscripts\utility::drawDebugLine( atPoint_forward, 	atPoint_back, 	color, durationFrames );
	}
}

UpdateDebugInfoInternal()
{
	if( isDefined( anim.debugEnt ) && ( anim.debugEnt == self ) )
		doInfo = true;
	else
		doInfo = getdebugdvarInt( "animscriptinfo" );

	if( doInfo )
	{
		thread drawDebugInfoThread();
	}
	else
	{
		self notify( "EndDebugInfo" );
	}
}

UpdateDebugInfo()
{
	self endon( "death" );
    for( ;; )
    {
		thread UpdateDebugInfoInternal();
		wait 1;
    }
}


drawDebugInfoThread()
{
	self endon( "EndDebugInfo" );
	self endon( "death" );
	
	for( ;; )
	{
		self thread drawDebugInfo();
		wait 0.05;
	}
}

drawDebugInfo()
{
	// What do we want to print?
	line[ 0 ]  = self getEntityNumber() + " " + self.a.script;
	line[ 1 ]  = self.a.pose + " " + self.a.movement;
	line[ 2 ]  = self.a.alertness + " " + self.a.special;
	if( self thread DebugIsInCombat() )
		line[ 3 ]  = "in combat for " + ( self.a.combatEndTime - gettime() ) + " ms.";
	else
		line[ 3 ]  = "not in combat";
	line[ 4 ]  = self.a.lastDebugPrint1;

	belowFeet = self.origin + ( 0, 0, -8 );	
	// aboveHead = self getShootAtPos() + ( 0, 0, 8 );
	offset = ( 0, 0, -10 );
	for( i = 0 ; i < line.size ; i ++ )
	{
		if( isDefined( line[ i ] ) )
		{
			textPos = ( belowFeet[ 0 ] + ( offset[ 0 ] * i ), belowFeet[ 1 ] + ( offset[ 1 ] * i ), belowFeet[ 2 ] + ( offset[ 2 ] * i ) );
			print3d( textPos, line[ i ], ( .2, .2, 1 ), 1, 0.75 );	// origin, text, RGB, alpha, scale
		}
	}
}
#/ 

safemod( a, b )
{
	 /* 
	Here are some modulus results from in - game:
	10 % 3 = 1
	10 % - 3 = 1
	 - 10 % 3 = -1
	 - 10 % - 3 = -1
	however, we never want a negative result.
	 */ 
	result = int( a ) % b;
	result += b;
	return result % b;
}

// Gives the result as an angle between 0 and 360
AngleClamp( angle )
{
	angleFrac = angle / 360.0;
	angle = ( angleFrac - floor( angleFrac ) ) * 360.0;
	return angle;
}

// Gives the result as an angle between - 180 and 180
AngleClamp180( angle )
{
	angleFrac = angle / 360.0;
	angle = ( angleFrac - floor( angleFrac ) ) * 360.0;
	if( angle > 180.0 )
		return angle - 360.0;
	return angle;
}

// equivalent to abs( AngleClamp180( angle ) )
AbsAngleClamp180( angle )
{
	angleFrac = angle / 360.0;
	angle = ( angleFrac - floor( angleFrac ) ) * 360.0;
	if( angle > 180.0 )
		return 360.0 - angle;
	return angle;
}

// Returns an array of 4 weights( 2 of which are guaranteed to be 0 ), which should be applied to forward, 
// right, back and left animations to get the angle specified.
//           front
//        / -- -- | -- -- \
//       /    180    \
//      / \     |     / \
//     / - 135  |  135  \
//     |     \ | /     |
// left| - 90 -- -- + -- -- 90 - |right
//     |     / | \     |
//     \  - 45  |  45   / 
//      \ /     |     \ / 
//       \     0     / 
//        \ -- -- | -- -- / 
//           back

QuadrantAnimWeights( yaw )
{
	forwardWeight = cos( yaw );
	leftWeight    = sin( yaw );

	result[ "front" ]	 = 0;
	result[ "right" ]	 = 0;
	result[ "back" ]	 = 0;
	result[ "left" ]	 = 0;
	
	if( isdefined( self.alwaysRunForward ) )
	{
		assert( self.alwaysRunForward );// always set alwaysRunForward to either true or undefined.
		
		result[ "front" ] = 1;
		return result;
	}

	if( forwardWeight > 0 )
	{
		result[ "front" ] = forwardWeight;
		
		if( leftWeight > 0 )
			result[ "left" ] = leftWeight;
		else
			result[ "right" ] = -1 * leftWeight;
	}
	else
	{
		// if moving backwards, don't blend.
		// it looks horrible because the feet cycle in the opposite direction.
		// either way, feet slide, but this looks better.
		backWeight = -1 * forwardWeight;
		if( leftWeight > backWeight )
			result[ "left" ] = 1;
		else if( leftWeight < forwardWeight )
			result[ "right" ] = 1;
		else
			result[ "back" ] = 1;
	}


	return result;
}

getQuadrant( angle )
{
	angle = AngleClamp( angle );

	if( angle < 45 || angle > 315 )
	{
		quadrant = "front";
	}
	else if( angle < 135 )
	{
		quadrant = "left";
	}
	else if( angle < 225 )
	{
		quadrant = "back";
	}
	else
	{
		quadrant = "right";
	}
	return quadrant;
}


// Checks to see if the input is equal to any of up to ten other inputs.
IsInSet( input, set )
{
	for( i = set.size - 1; i >= 0; i -- )
	{
		if( input == set[ i ] )
			return true;
	}
	return false;
}

playAnim( animation )
{
	if( isDefined( animation ) )
	{
		// self thread drawString( animation );	// Doesn't work for animations, only strings.
		println( "NOW PLAYING: ", animation );
		self setFlaggedAnimKnobAllRestart( "playAnim", animation, %root, 1, .1, 1 );
		timeToWait = getanimlength( animation );
		timeToWait = ( 3 * timeToWait ) + 1;	// So looping animations play through 3 times.
		self thread NotifyAfterTime( "time is up", "time is up", timeToWait );
		self waittill( "time is up" );
		self notify( "enddrawstring" );
	}
}

NotifyAfterTime( notifyString, killmestring, time )
{
	self endon( "death" );
	self endon( killmestring );
	wait time;
	self notify( notifyString );
}

// Utility function, made for MilestoneAnims(), which displays a string until killed.
drawString( stringtodraw )
{
	self endon( "killanimscript" );
	self endon( "enddrawstring" );
	for( ;; )
	{
		wait .05;
		print3d( ( self GetDebugEye() ) + ( 0, 0, 8 ), stringtodraw, ( 1, 1, 1 ), 1, 0.2 );
	}
}

drawStringTime( msg, org, color, timer )
{
	maxtime = timer * 20;
	for( i = 0;i < maxtime;i ++ )
	{
		print3d( org, msg, color, 1, 1 );
		wait .05;
	}
}

showLastEnemySightPos( string )
{
	self notify( "got known enemy2" );
	self endon( "got known enemy2" );
	self endon( "death" );

	if( !isValidEnemy( self.enemy ) )
		return;
		
	if( self.enemy.team == "allies" )
		color = ( 0.4, 0.7, 1 );
	else
		color = ( 1, 0.7, 0.4 );
		
	while( 1 )
	{
		wait( 0.05 );
		if( !isdefined( self.lastEnemySightPos ) )
			continue;
			
		print3d( self.lastEnemySightPos, string, color, 1, 2.15 );	// origin, text, RGB, alpha, scale
	}
}

 /#
printDebugTextProc( string, org, printTime, color )
{
	level notify( "stop debug print " + org );
	level endon( "stop debug print " + org );

	if( !isdefined( color ) )
		color = ( 0.3, 0.9, 0.6 );
		
	timer = printTime * 20;
	for( i = 0;i < timer;i += 1 )
	{
		wait( 0.05 );
		print3d( org, string, color, 1, 1 );	// origin, text, RGB, alpha, scale
	}
}

printDebugText( string, org, printTime, color )
{
	if( getdebugdvar( "anim_debug" ) != "" )
		level thread printDebugTextProc( string, org, printTime, color );
}
#/ 

hasEnemySightPos()
{
	if( isdefined( self.node ) )
		return( canSeeEnemyFromExposed() || canSuppressEnemyFromExposed() );
	else
		return( canSeeEnemy() || canSuppressEnemy() );
}

getEnemySightPos()
{
	assert( self.goodShootPosValid );
	return self.goodShootPos;
}

tryTurret( targetname )
{
   	turret = getent( targetname, "targetname" );
   	if( !isdefined( turret ) )
   		return false;

	if( ( turret.classname != "misc_mg42" ) && ( turret.classname != "misc_turret" ) )
		return false;

	if( !self isingoal( self.covernode.origin ) )
		return false;

	canuse = self useturret( turret );// dude should be near the mg42
	if( canuse )
	{
		turret setmode( "auto_ai" );// auto, auto_ai, manual
		self thread maps\_mgturret::mg42_firing( turret );
		turret notify( "startfiring" );
		return true;
	}
	else
	{
		return false;
	}
}

util_ignoreCurrentSightPos()
{
	if( !hasEnemySightPos() )
		return;
		
	self.ignoreSightPos = getEnemySightPos();
	self.ignoreOrigin = self.origin;
}

canShootPos( pos )
{
	myGunPos = self GetTagOrigin( "tag_flash" );
	myEyeOffset = ( self getShootAtPos() - myGunPos );
	return( self canshoot( pos, myEyeOffset ) );
}

util_evaluateKnownEnemyLocation()
{
	if( !hasEnemySightPos() )
		return false;
		
	myGunPos = self GetTagOrigin( "tag_flash" );
	myEyeOffset = ( self getShootAtPos() - myGunPos );

	if( ( isdefined( self.ignoreSightPos ) ) && ( isdefined( self.ignoreOrigin ) ) )
	{
		// Ignore the current last sight pos if you've previously invalidated it from this position
		if( distance( self.origin, self.ignoreOrigin ) < 25 )
			return false;
	}
	
	self.ignoreSightPos = undefined;

	canSee = self canshoot( getEnemySightPos(), myEyeOffset );
	if( !canSee )
	{
		self.ignoreSightPos = getEnemySightPos();
		return false;
	}
	
	return true;

}


debugTimeout()
{
	wait( 5 );
	self notify( "timeout" );
}

debugPosInternal( org, string, size )
{
	self endon( "death" );
	self notify( "stop debug " + org );
	self endon( "stop debug " + org );
	ent = spawnstruct();
	ent thread debugTimeout();
	ent endon( "timeout" );
	if( self.enemy.team == "allies" )
		color = ( 0.4, 0.7, 1 );
	else
		color = ( 1, 0.7, 0.4 );
		
	while( 1 )
	{
		wait( 0.05 );
		print3d( org, string, color, 1, size );	// origin, text, RGB, alpha, scale
	}
}

debugPos( org, string )
{
	thread debugPosInternal( org, string, 2.15 );
}

debugPosSize( org, string, size )
{
	thread debugPosInternal( org, string, size );
}

debugBurstPrint( numShots, maxShots )
{
	burstSize = numShots / maxShots;
	burstSizeStr = undefined;
	
	if( numShots == self.bulletsInClip )
		burstSizeStr = "all rounds";
	else
	if( burstSize < 0.25 )
		burstSizeStr = "small burst";
	else
	if( burstSize < 0.5 )
		burstSizeStr = "med burst";
	else
		burstSizeStr = "long burst";

	thread animscripts\utility::debugPosSize( self.origin + ( 0, 0, 42 ), burstSizeStr, 1.5 );
	thread animscripts\utility::debugPos( self.origin + ( 0, 0, 60 ), "Suppressing" );
}


printShootProc()
{
	self endon( "death" );
	self notify( "stop shoot " + self.export );
	self endon( "stop shoot " + self.export );

	printTime = 0.25;
	timer = printTime * 20;
	for( i = 0;i < timer;i += 1 )
	{
		wait( 0.05 );
		print3d( self.origin + ( 0, 0, 70 ), "Shoot", ( 1, 0, 0 ), 1, 1 );	// origin, text, RGB, alpha, scale
	}
}

printShoot()
{
	 /#
	if( getdebugdvar( "anim_debug" ) == "3" )
		self thread printShootProc();
	#/ 
}

showDebugProc( fromPoint, toPoint, color, printTime )
{
	self endon( "death" );
// 	self notify( "stop debugline " + self.export );
// 	self endon( "stop debugline " + self.export );

	timer = printTime * 20;
	for( i = 0;i < timer;i += 1 )
	{
		wait( 0.05 );
		line( fromPoint, toPoint, color );
	}
}

showDebugLine( fromPoint, toPoint, color, printTime )
{
	self thread showDebugProc( fromPoint, toPoint + ( 0, 0, -5 ), color, printTime );
}

shootEnemyWrapper()
{
	[[ anim.shootEnemyWrapper_func ]]();
}

shootEnemyWrapper_normal()
{
	self.a.lastShootTime = gettime();
	// set accuracy at time of shoot rather than in a separate thread that is vulnerable to timing issues
	maps\_gameskill::set_accuracy_based_on_situation();
	//prof_begin( "shoot" );
	self shoot();
	//if ( self weaponAnims() != "rocketlauncher" )
	//	self shootBlank();
	//prof_end( "shoot" );
}

ShootEnemyWrapper_shootNotify()
{
	level notify( "an_enemy_shot", self );
	shootEnemyWrapper_normal();
}

shootPosWrapper( shootPos )
{
	endpos = bulletSpread( self gettagorigin( "tag_flash" ), shootPos, 4 );

	self.a.lastShootTime = gettime();
	//prof_begin( "shoot" );
	self shoot( 1, endpos );
	//if ( self weaponAnims() != "rocketlauncher" )
		//self shootBlank( 1, endpos );
	//prof_end( "shoot" );
}


throwGun()
{
	org = spawn( "script_model", ( 0, 0, 0 ) );
	org setmodel( "temp" );
	org.origin = self getTagOrigin( "tag_weapon_right" )  + ( 50, 50, 0 );
	org.angles = self getTagAngles( "tag_weapon_right" );
	right = anglestoright( org.angles );
	right = vectorScale( right, 15 );
	forward = anglestoforward( org.angles );
	forward = vectorScale( forward, 15 );
	org moveGravity( ( 0, 50, 150 ), 100 );

	weaponClass = "weapon_" + self.weapon;
	weapon = spawn( weaponClass, org.origin );
	weapon.angles = self getTagAngles( "tag_weapon_right" ); 
	weapon linkto( org );
	
// 	org rotateVelocity( ( 100, 0, 0 ), 12 );
	lastOrigin = org.origin;
	while( ( isdefined( weapon ) ) && ( isdefined( weapon.origin ) ) )
	{
		start = lastOrigin;
		end = org.origin;
		angles = vectortoangles( end - start );
		forward = anglestoforward( angles );
		forward = vectorScale( forward, 4 );
		trace = bulletTrace( end, end + forward, true, weapon );
		if( isalive( trace[ "entity" ] ) && trace[ "entity" ] == self )
		{
			wait( 0.05 );
			continue;
		}
			
		if( trace[ "fraction" ] < 1.0 )
			break;
		
		lastOrigin = org.origin;
		wait( 0.05 );
	}
	 /* 
	if( isdefined( trace[ "entity" ] ) )
	{
		if( isSentient( trace[ "entity" ] ) )
			trace[ "entity" ] DoDamage( 300, weapon.origin );
	}
	 */ 
	if( ( isdefined( weapon ) ) && ( isdefined( weapon.origin ) ) )
		weapon unlink();
	org delete();
}

getAimDelay()
{
// 	if( level.aim_delay_off )
 /* 		
	if( ( isalive( self.enemy ) ) && ( self.enemy == level.player ) )
	{
		dist = distance( self.origin, self.enemy.origin );
		delay = dist * 0.004;
		delay -= 1;
		delay = delay * 0.5;
		delay += randomfloat( delay );
// 		println( "^7Delaying fire from distance " + dist + " for " + delay + " second" );
		if( delay > 0 )
			return( delay );
	}
 */ 	
	return 0.001;
}

setEnv( env )
{
	anim.idleAnimTransition [ "stand" ][ "in" ] = %casual_stand_idle_trans_in;
	// anim.idleAnimTransition [ "stand" ][ "out" ] = %casual_stand_idle_trans_out;

	anim.idleAnimArray		[ "stand" ][ 0 ][ 0 ] = %casual_stand_idle;
	anim.idleAnimArray		[ "stand" ][ 0 ][ 1 ] = %casual_stand_idle_twitch;
	anim.idleAnimArray		[ "stand" ][ 0 ][ 2 ] = %casual_stand_idle_twitchB;
	anim.idleAnimWeights	[ "stand" ][ 0 ][ 0 ] = 2;
	anim.idleAnimWeights	[ "stand" ][ 0 ][ 1 ] = 1;
	anim.idleAnimWeights	[ "stand" ][ 0 ][ 2 ] = 1;
	
	anim.idleAnimArray		[ "stand" ][ 1 ][ 0 ] = %casual_stand_v2_idle;
	anim.idleAnimArray		[ "stand" ][ 1 ][ 1 ] = %casual_stand_v2_twitch_radio;
	anim.idleAnimArray		[ "stand" ][ 1 ][ 2 ] = %casual_stand_v2_twitch_shift;
	anim.idleAnimArray		[ "stand" ][ 1 ][ 3 ] = %casual_stand_v2_twitch_talk;
	anim.idleAnimWeights	[ "stand" ][ 1 ][ 0 ] = 10;
	anim.idleAnimWeights	[ "stand" ][ 1 ][ 1 ] = 4;
	anim.idleAnimWeights	[ "stand" ][ 1 ][ 2 ] = 7;
	anim.idleAnimWeights	[ "stand" ][ 1 ][ 3 ] = 4;
	
	anim.idleAnimArray		[ "stand_cqb" ][ 0 ][ 0 ] = %cqb_stand_idle;
	anim.idleAnimArray		[ "stand_cqb" ][ 0 ][ 1 ] = %cqb_stand_twitch;
	anim.idleAnimWeights	[ "stand_cqb" ][ 0 ][ 0 ] = 2;
	anim.idleAnimWeights	[ "stand_cqb" ][ 0 ][ 1 ] = 1;
	
	anim.idleAnimTransition [ "crouch" ][ "in" ] = %casual_crouch_idle_in;
	// anim.idleAnimTransition [ "crouch" ][ "out" ] = %casual_crouch_idle_out;

	anim.idleAnimArray		[ "crouch" ][ 0 ][ 0 ] = %casual_crouch_idle;
	anim.idleAnimArray		[ "crouch" ][ 0 ][ 1 ] = %casual_crouch_twitch;
	anim.idleAnimArray		[ "crouch" ][ 0 ][ 2 ] = %casual_crouch_point;
	anim.idleAnimWeights	[ "crouch" ][ 0 ][ 0 ] = 6;
	anim.idleAnimWeights	[ "crouch" ][ 0 ][ 1 ] = 3;
	anim.idleAnimWeights	[ "crouch" ][ 0 ][ 2 ] = 1;
}


PersonalColdBreath()
{
	tag = "TAG_EYE";
	self endon( "death" );
	self notify( "stop personal effect" );
	self endon( "stop personal effect" );
	for( ;; )
	{
		if( self.a.movement != "run" )
		{
			playfxOnTag( level._effect[ "cold_breath" ], self, tag );
			wait( 2.5 + randomfloat( 3 ) );
		}
		else
			wait( 0.5 );
	}
}

PersonalColdBreathSpawner()
{
	self endon( "death" );
	self notify( "stop personal effect" );
	self endon( "stop personal effect" );
	for( ;; )
	{
		self waittill( "spawned", spawn );
		if( maps\_utility::spawn_failed( spawn ) )
			continue;
		spawn thread PersonalColdBreath();
	}
}

isSuppressedWrapper()
{
	if ( forcedCover( "show" ) )
		return false;
	if ( forcedCover( "hide" ) )
		return true;
	if( self.suppressionMeter <= self.suppressionThreshold )
		return false;
	return self issuppressed();	// takes into account .ignoreSuppression
}

// if not suppressed, sometimes we still want to look cautious, like leaning out of a corner instead of stepping out.
// this determines whether we should do that or not.
isPartiallySuppressedWrapper()
{
	if( forcedCover( "show" ) )
		return false;
	if( self.suppressionMeter <= self.suppressionThreshold * 0.25 )
		return false;
	return( self issuppressed() );	// takes into account .ignoreSuppression
}

getNodeOffset( node )
{
	if( isdefined( node.offset ) )
		return node.offset;

	// ( right offset, forward offset, vertical offset )
	// you can get an actor's current eye offset by setting scr_eyeoffset to his entnum.
	// this should be redone whenever animations change significantly.
	cover_left_crouch_offset = 	( - 26, .4, 36 );
	cover_left_stand_offset = 	( - 32, 7, 63 );
	cover_right_crouch_offset = ( 43.5, 11, 36 );
	cover_right_stand_offset = 	( 36, 8.3, 63 );
	cover_crouch_offset = 		( 3.5, -12.5, 45 );// maybe we could account for the fact that in cover crouch he can stand if he needs to?
	cover_stand_offset = 		( - 3.7, -22, 63 );

	cornernode = false;
	nodeOffset = ( 0, 0, 0 );
	
	right = anglestoright( node.angles );
	forward = anglestoforward( node.angles );

	switch( node.type )
	{
		case "Cover Left":
		case "Cover Left Wide":
			if( node isNodeDontStand() && !node isNodeDontCrouch() )
				nodeOffset = calculateNodeOffset( right, forward, cover_left_crouch_offset );
			else
				nodeOffset = calculateNodeOffset( right, forward, cover_left_stand_offset );
		break;

		case "Cover Right":
		case "Cover Right Wide":
			if( node isNodeDontStand() && !node isNodeDontCrouch() )
				nodeOffset = calculateNodeOffset( right, forward, cover_right_crouch_offset );
			else
				nodeOffset = calculateNodeOffset( right, forward, cover_right_stand_offset );
		break;
		
		case "Cover Stand":
		case "Conceal Stand":
		case "Turret":
			nodeOffset = calculateNodeOffset( right, forward, cover_stand_offset );
		break;
			
		case "Cover Crouch":
		case "Cover Crouch Window":
		case "Conceal Crouch":
			nodeOffset = calculateNodeOffset( right, forward, cover_crouch_offset );
		break;
	}

	node.offset = nodeOffset;
	return node.offset;
}

calculateNodeOffset( right, forward, baseoffset )
{
	return vectorScale( right, baseoffset[ 0 ] ) + vectorScale( forward, baseoffset[ 1 ] ) + ( 0, 0, baseoffset[ 2 ] );
}

canSeeEnemy()
{
	if( !isValidEnemy( self.enemy ) )
		return false;
	
	if( self canSee( self.enemy ) )
	{
		if( !checkPitchVisibility( self geteye(), self.enemy getshootatpos() ) )
			return false;
		
		self.goodShootPosValid = true;
		self.goodShootPos = GetEnemyEyePos();
		
		dontGiveUpOnSuppressionYet();
		
		return true;
	}
	
	return false;
}

canSeeEnemyFromExposed()
{
	//prof_begin( "canSeeEnemyFromExposed" );
	
	if( !isValidEnemy( self.enemy ) )
	{
		self.goodShootPosValid = false;
		//prof_end( "canSeeEnemyFromExposed" );
		return false;
	}

	enemyEye = GetEnemyEyePos();
	if( !isDefined( self.node ) )
	{
		result = self canSee( self.enemy );
	}
	else
	{
		result = canSeePointFromExposedAtNode( enemyEye, self.node );
	}
	
	if( result )
	{
		self.goodShootPosValid = true;
		self.goodShootPos = enemyEye;
		
		dontGiveUpOnSuppressionYet();
	}
	else
	{
		 /#
		if( self getentnum() == getdebugdvarint( "anim_dotshow" ) )
			thread persistentDebugLine( self.node.origin + getNodeOffset( self.node ), enemyEye );
		#/ 
	}
	
	//prof_end( "canSeeEnemyFromExposed" );
	return result;
}

canSeePointFromExposedAtNode( point, node )
{
	if( node.type == "Cover Left" || node.type == "Cover Right" || node.type == "Cover Left Wide" || node.type == "Cover Right Wide" )
	{
		if( !self animscripts\corner::canSeePointFromExposedAtCorner( point, node ) )
			return false;
	}
	
	nodeOffset = getNodeOffset( node );
	lookFromPoint = node.origin + nodeOffset;
	
	if( !checkPitchVisibility( lookFromPoint, point, node ) )
		return false;
	
	if( !sightTracePassed( lookFromPoint, point, false, undefined ) )
	{
		if( node.type == "Cover Crouch" || node.type == "Conceal Crouch" )
		{
			// also consider the ability to stand at crouch nodes
			lookFromPoint = ( 0, 0, 64 ) + node.origin;
			return sightTracePassed( lookFromPoint, point, false, undefined );
		}
		
		return false;
	}
	
	return true;
}

checkPitchVisibility( fromPoint, toPoint, atNode )
{
	// check vertical angle is within our aiming abilities
	
	pitch = AngleClamp180( vectorToAngles( toPoint - fromPoint )[ 0 ] );
	if( abs( pitch ) > 45 )
	{
		if( isdefined( atNode ) && atNode.type != "Cover Crouch" && atNode.type != "Conceal Crouch" )
			return false;
		if( pitch > 45 || pitch < anim.coverCrouchLeanPitch - 45 )
			return false;
	}
	return true;
}

dontGiveUpOnSuppressionYet()
{
	// we'll reset the giveUpOnSuppression timer the next time we want to suppress
	self.a.shouldResetGiveUpOnSuppressionTimer = true;
}
updateGiveUpOnSuppressionTimer()
{
	if( !isdefined( self.a.shouldResetGiveUpOnSuppressionTimer ) )
		self.a.shouldResetGiveUpOnSuppressionTimer = true;
	
	if( self.a.shouldResetGiveUpOnSuppressionTimer )
	{
		// after this time, we will decide that our enemy might not be where we thought they were
		// this will cause us to look for better cover
		self.a.giveUpOnSuppressionTime = gettime() + randomintrange( 15000, 30000 );
		
		self.a.shouldResetGiveUpOnSuppressionTimer = false;
	}
}

showLines( start, end, end2 )
{
	for( ;; )
	{
		line( start, end, ( 1, 0, 0 ), 1 );
		wait( 0.05 );
		line( start, end2, ( 0, 0, 1 ), 1 );
		wait( 0.05 );
	}
}

aiSuppressAI()
{
	if( !self canAttackEnemyNode() )
		return false;

	shootPos = undefined;
	if( isdefined( self.enemy.node ) )
	{
		nodeOffset = getNodeOffset( self.enemy.node );
		shootPos = self.enemy.node.origin + nodeOffset;
	}
	else
		shootPos = self.enemy getShootAtPos();
	
	// canAttackEnemyNode sometimes returns true even though we can't see the point, because
	// our eye pos is not right at our node's offset
	if( !self canShoot( shootPos ) )
		return false;
	if( self.a.script == "combat" )
	{
		// make sure we can also see the tip of our gun
		if( !sighttracepassed( self geteye(), self gettagorigin( "tag_flash" ), false, undefined ) )
			return false;
	}
	
	self.goodShootPosValid = true;
	self.goodShootPos = shootPos;
	return true;
}

canSuppressEnemyFromExposed()
{
	// FromExposed includes checking from the offset of the node the AI is at
	
	if( !hasSuppressableEnemy() )
	{
		self.goodShootPosValid = false;
		return false;
	}

	if( self.enemy != level.player )
		return aiSuppressAI();

	if( isdefined( self.node ) )
	{
		if( self.node.type == "Cover Left" || self.node.type == "Cover Right" || self.node.type == "Cover Left Wide" || self.node.type == "Cover Right Wide" )
		{
			// Don't try to shoot at stuff behind the node
			if( !self animscripts\corner::canSeePointFromExposedAtCorner( self GetEnemyEyePos(), self.node ) )
				return false;
		}
		
		nodeOffset = getNodeOffset( self.node );
		startOffset = self.node.origin + nodeOffset;
	}
	else
		startOffset = self GetTagOrigin( "tag_flash" );

	if( !checkPitchVisibility( startOffset, self.lastEnemySightPos ) )
		return false;
	
	return findGoodSuppressSpot( startOffset );
}

canSuppressEnemy()
{
	if( !hasSuppressableEnemy() )
	{
		self.goodShootPosValid = false;
		return false;
	}

	if( self.enemy != level.player )
		return aiSuppressAI();

	startOffset = self GetTagOrigin( "tag_flash" );

	if( !checkPitchVisibility( startOffset, self.lastEnemySightPos ) )
		return false;

	return findGoodSuppressSpot( startOffset );
}

hasSuppressableEnemy()
{
	if( !isValidEnemy( self.enemy ) )
		return false;
	
	if( !isdefined( self.lastEnemySightPos ) )
		return false;
	
	updateGiveUpOnSuppressionTimer();
	if( gettime() > self.a.giveUpOnSuppressionTime )
		return false;
	
	if( !needRecalculateSuppressSpot() )
		return self.goodShootPosValid;

	return true;
}

canSeeAndShootPoint( point )
{
	if( !sightTracePassed( self getShootAtPos(), point, false, undefined ) )
		return false;

	if( self.a.weaponPos[ "right" ] == "none" )
		return false;

	gunpoint = self GetTagOrigin( "tag_flash" );
	
	return sightTracePassed( gunpoint, point, false, undefined );
}

needRecalculateSuppressSpot()
{
	if( self.goodShootPosValid && !self canSeeAndShootPoint( self.goodShootPos ) )
		return true;
	
	// we need to recalculate the suppress spot
	// if we've moved or if we saw our enemy in a different place than when we
	// last calculated it
	return( 
		!isdefined( self.lastEnemySightPosOld ) || 
		self.lastEnemySightPosOld != self.lastEnemySightPos || 
		distanceSquared( self.lastEnemySightPosSelfOrigin, self.origin ) > 1024// 1024 = 32 * 32
	 );
}

findGoodSuppressSpot( startOffset )
{
	if( !needRecalculateSuppressSpot() )
		return self.goodShootPosValid;
	
	// make sure we can see from our eye to our gun; if we can't then we really shouldn't be trying to suppress at all!
	if( !sightTracePassed( self getShootAtPos(), startOffset, false, undefined ) )
	{
		self.goodShootPosValid = false;
		return false;
	}
	
	
	self.lastEnemySightPosSelfOrigin = self.origin;
	self.lastEnemySightPosOld = self.lastEnemySightPos;
	
	
	currentEnemyPos = GetEnemyEyePos();
	
	trace = bullettrace( self.lastEnemySightPos, currentEnemyPos, false, undefined );
	startTracesAt = trace[ "position" ];
	
	percievedMovementVector = self.lastEnemySightPos - startTracesAt;
	lookVector = vectorNormalize( self.lastEnemySightPos - startOffset );
	percievedMovementVector = percievedMovementVector - vectorScale( lookVector, vectorDot( percievedMovementVector, lookVector ) );
	// percievedMovementVector is what self.lastEnemySightPos - startTracesAt looks like from our position( that is, projected perpendicular to the direction we're looking ).
	
	idealTraceInterval = 20.0;
	numTraces = int( length( percievedMovementVector ) / idealTraceInterval + 0.5 );// one trace every 20 units, ideally
	if( numTraces < 1 )
		numTraces = 1;
	if( numTraces > 20 )
		numTraces = 20;// cap it 
	vectorDif = self.lastEnemySightPos - startTracesAt;
	vectorDif = ( vectorDif[ 0 ] / numTraces, vectorDif[ 1 ] / numTraces, vectorDif[ 2 ] / numTraces );
	numTraces ++ ;// to get both start and end points for traces
	
	traceTo = startTracesAt;
	 /#
	if( getdebugdvarint( "debug_dotshow" ) == self getentnum() )
	{
		thread print3dtime( 15, self.lastEnemySightPos, "lastpos", ( 1, .2, .2 ), 1, 0.75 );	// origin, text, RGB, alpha, scale
		thread print3dtime( 15, startTracesAt, "currentpos", ( 1, .2, .2 ), 1, 0.75 );	// origin, text, RGB, alpha, scale
	}
	#/ 
	
	self.goodShootPosValid = false;

	goodTraces = 0;
	neededGoodTraces = 2;// we stop at 3 good traces away from the cover where they disappeared, should be about 40 units
	for( i = 0; i < numTraces + neededGoodTraces; i ++ )
	{
		tracePassed = sightTracePassed( startOffset, traceTo, false, undefined );
		thisTraceTo = traceTo;
		
		 /#
		if( getdebugdvarint( "debug_dotshow" ) == self getentnum() )
		{
			if( tracePassed )
				color = ( .2, .2, 1 );
			else
				color = ( .2, .2, .2 );
			// showDebugLine( startOffset, traceTo, color, 0.75 );
			thread print3dtime( 15, traceTo, ".", color, 1, 0.75 );	// origin, text, RGB, alpha, scale
		}
		#/ 
		
		// after we've hit self.lastEnemySightPos, look only perpendicular to our line of sight
		if( i == numTraces - 1 )
		{
			vectorDif = vectorDif - vectorScale( lookVector, vectorDot( vectorDif, lookVector ) );
		}
		
		traceTo += vectorDif;// for next time
		
		if( tracePassed )
		{
			goodTraces ++ ;
			
			self.goodShootPosValid = true;
			self.goodShootPos = thisTraceTo;
			
			// if first trace succeeded, we take it, because it probably means they're crouched under cover and we can shoot over it
			if( i > 0 && goodTraces < neededGoodTraces && i < numTraces + neededGoodTraces - 1 )
				continue;
			
			return true;
		}
		else
		{
			goodTraces = 0;
		}
	}
	
	return self.goodShootPosValid;
}

// Returns an animation from an array of animations with a corrosponding array of weights.
anim_array( animArray, animWeights )
{
	total_anims = animArray.size;
	idleanim = randomint( total_anims );
	assert( total_anims );
	assert( animArray.size == animWeights.size );
	if( total_anims == 1 )
		return animArray[ 0 ];
		
	weights = 0;
	total_weight = 0;
	
	for( i = 0;i < total_anims;i ++ )
		total_weight += animWeights[ i ];
	
	anim_play = randomfloat( total_weight );
	current_weight	 = 0;
	
	for( i = 0;i < total_anims;i ++ )
	{
		current_weight += animWeights[ i ];
		if( anim_play >= current_weight )
			continue;

		idleanim = i;
		break;
	}
	
	return animArray[ idleanim ];
}		

notForcedCover()
{
	return( ( self.a.forced_cover == "none" ) || ( self.a.forced_cover == "show" ) );
} 

forcedCover( msg )
{
	return isdefined( self.a.forced_cover ) && ( self.a.forced_cover == msg );
} 

print3dtime( timer, org, msg, color, alpha, scale )
{
	newtime = timer / 0.05;
	for( i = 0;i < newtime;i ++ )
	{
		print3d( org, msg, color, alpha, scale );
		wait( 0.05 );
	}
}

print3drise( org, msg, color, alpha, scale )
{
	newtime = 5 / 0.05;
	up = 0;
	org = org + randomvector( 30 );

	for( i = 0;i < newtime;i ++ )
	{
		up += 0.5;
		print3d( org + ( 0, 0, up ), msg, color, alpha, scale );
		wait( 0.05 );
	}
}

crossproduct( vec1, vec2 )
{
	return( vec1[ 0 ] * vec2[ 1 ] - vec1[ 1 ] * vec2[ 0 ] > 0 );
}

scriptChange()
{
	self.a.current_script = "none";
	self notify( anim.scriptChange );
}

delayedScriptChange()
{
	wait( 0.05 );
	scriptChange();
}


handleSuppressingEnemy()
{
	if( !isalive( self ) )
		return;
		
	self endon( "suppressionAttackComplete" );
	assert( !self.a.suppressingEnemy );
	if( self.a.suppressingEnemy )
	{
			self SetPoseMovement( self.a.pose, "stop" );
		self waittill( "suppressionAttackComplete" );
	}
	// In case a suppression Attack is occurring in shootrunningsuppressionvolley
	self notify( "clearSuppressionAttack" ); 
}


getGrenadeModel()
{
	return getWeaponModel( self.grenadeweapon );
}

sawEnemyMove( timer )
{
	if( !isdefined( timer ) )
		timer = 500;
	return( gettime() - self.personalSightTime < timer );
}

canThrowGrenade()
{
	if( !self.grenadeAmmo )
		return false;
	
	if( self.script_forceGrenade )
		return true;
		
	return( self.enemy == level.player );
}

usingBoltActionWeapon()
{
	return( weaponIsBoltAction( self.weapon ) );
}

random_weight( array )
{
	idleanim = randomint( array.size );
	if( array.size > 1 )
	{
		anim_weight = 0;
		for( i = 0;i < array.size;i ++ )
			anim_weight += array[ i ];
		
		anim_play = randomfloat( anim_weight );
		
		anim_weight = 0;
		for( i = 0;i < array.size;i ++ )
		{
			anim_weight += array[ i ];
			if( anim_play < anim_weight )
			{
				idleanim = i;
				break;
			}
		}
	}
	
	return idleanim;
}		

removeableHat()
{
	if( !isdefined( self.hatmodel ) )
		return false;

	if( isdefined( anim.noHatClassname[ self.classname ] ) )
		return false;
	
	return( !isdefined( anim.noHat[ self.model ] ) );
}

metalHat()
{
	if( !isdefined( self.hatmodel ) )
		return false;
	
	return( isdefined( anim.metalHat[ self.model ] ) );
}

fatGuy()
{
	return( isdefined( anim.fatGuy[ self.model ] ) );
}

setFootstepEffect( name, fx )
{
	assertEx( isdefined( name ), "Need to define the footstep surface type." );
	assertEx( isdefined( fx ), "Need to define the mud footstep effect." );
	if( !isdefined( anim.optionalStepEffects ) )
		anim.optionalStepEffects = [];
	anim.optionalStepEffects[ anim.optionalStepEffects.size ] = name;
	level._effect[ "step_" + name ] = fx;
	anim.optionalStepEffectFunction = animscripts\shared::playFootStepEffect;
}


persistentDebugLine( start, end )
{
	self endon( "death" );
	level notify( "newdebugline" );
	level endon( "newdebugline" );
	
	for( ;; )
	{
		line( start, end, ( 0.3, 1, 0 ), 1 );
		wait( 0.05 );
	}
}


EnterProneWrapper( timer )
{
	thread enterProneWrapperProc( timer );
}

enterProneWrapperProc( timer )
{
	self endon( "death" );
	self notify( "anim_prone_change" );
	self endon( "anim_prone_change" );
	// wrapper so we can put a breakpoint on it
	self EnterProne( timer );
	self waittill( "killanimscript" );
	
	// in case we dont actually make it into prone by the time another script comes in
	if( self.a.pose != "prone" )
		self.a.pose = "prone";
}

ExitProneWrapper( timer )
{
	thread ExitProneWrapperProc( timer );
}

ExitProneWrapperProc( timer )
{
	self endon( "death" );
	self notify( "anim_prone_change" );
	self endon( "anim_prone_change" );
	// wrapper so we can put a breakpoint on it
	self ExitProne( timer );
	self waittill( "killanimscript" );
	
	// in case we dont actually leave prone, change it out of prone
	if( self.a.pose == "prone" )
		self.a.pose = "crouch";
}

canBlindfire()
{
	if( self.a.atConcealmentNode )
		return false;
	
	if( !animscripts\weaponList::usingAutomaticWeapon() )
		return false;
		
	if( weaponClass( self.weapon ) == "mg" )
		return false;

	if( isdefined( self.disable_blindfire ) && self.disable_blindfire == true )
		return false;
		
	return true;
}

canHitSuppressSpot()
{
	if( !hasEnemySightPos() )
		return false;
	myGunPos = self GetTagOrigin( "tag_flash" );
	return( sightTracePassed( myGunPos, getEnemySightPos(), false, undefined ) );
}

isNodeDontStand()
{
	return( self.spawnflags & 4 ) == 4;
}
isNodeDontCrouch()
{
	return( self.spawnflags & 8 ) == 8;
}
isNodeDontProne()
{
	return( self.spawnflags & 16 ) == 16;
}

doesNodeAllowStance( stance )
{
	if( stance == "stand" )
	{
		return !self isNodeDontStand();
	}
	else if( stance == "crouch" )
	{
		return !self isNodeDontCrouch();
	}
	else
	{
		assert( stance == "prone" );
		return !self isNodeDontProne();
	}
}

animArray( animname ) /* string */ 
{
	// println( "playing anim: ", animname );
	
	assert( isdefined( self.a.array ) );
	 /#
	if( !isdefined( self.a.array[ animname ] ) )
	{
		dumpAnimArray();
		assertex( isdefined( self.a.array[ animname ] ), "self.a.array[ \"" + animname + "\" ] is undefined" );
	}
	#/ 
	
	return self.a.array[ animname ];
}

animArrayAnyExist( animname )
{
	assert( isdefined( self.a.array ) );
	 /#
	if( !isdefined( self.a.array[ animname ] ) )
	{
		dumpAnimArray();
		assertex( isdefined( self.a.array[ animname ] ), "self.a.array[ \"" + animname + "\" ] is undefined"  );
	}
	#/ 
	
	return self.a.array[ animname ].size > 0;
}

animArrayPickRandom( animname )
{
	assert( isdefined( self.a.array ) );
	 /#
	if( !isdefined( self.a.array[ animname ] ) )
	{
		dumpAnimArray();
		assertex( isdefined( self.a.array[ animname ] ), "self.a.array[ \"" + animname + "\" ] is undefined"  );
	}
	#/ 
	assert( self.a.array[ animname ].size > 0 );
	
	index = randomint( self.a.array[ animname ].size );

	return self.a.array[ animname ][ index ];
}

 /#
dumpAnimArray()
{
	println( "self.a.array:" );
	keys = getArrayKeys( self.a.array );
	for( i = 0; i < keys.size; i ++ )
	{
		if( isarray( self.a.array[ keys[ i ] ] ) )
			println( " array[ \"" + keys[ i ] + "\" ] = {array of size " + self.a.array[ keys[ i ] ].size + "}" );
		else
			println( " array[ \"" + keys[ i ] + "\" ] = ", self.a.array[ keys[ i ] ] );
	}
}
#/ 

array( a, b, c, d, e, f, g, h, i, j, k, l, m, n )
{
	array = [];
	if( isdefined( a ) ) array[ 0 ] = a; else return array;
	if( isdefined( b ) ) array[ 1 ] = b; else return array;
	if( isdefined( c ) ) array[ 2 ] = c; else return array;
	if( isdefined( d ) ) array[ 3 ] = d; else return array;
	if( isdefined( e ) ) array[ 4 ] = e; else return array;
	if( isdefined( f ) ) array[ 5 ] = f; else return array;
	if( isdefined( g ) ) array[ 6 ] = g; else return array;
	if( isdefined( h ) ) array[ 7 ] = h; else return array;
	if( isdefined( i ) ) array[ 8 ] = i; else return array;
	if( isdefined( j ) ) array[ 9 ] = j; else return array;
	if( isdefined( k ) ) array[ 10 ] = k; else return array;
	if( isdefined( l ) ) array[ 11 ] = l; else return array;
	if( isdefined( m ) ) array[ 12 ] = m; else return array;
	if( isdefined( n ) ) array[ 13 ] = n;
	return array;
}


getAIPrimaryWeapon()
{
	return self.primaryweapon;
}

getAISecondaryWeapon()
{
	return self.secondaryweapon;
}

getAISidearmWeapon()
{
	return self.sidearm;
}

getAICurrentWeapon()
{
	return self.weapon;
}

setAICurrentWeapon( weapon )
{
	if( weapon == self.primaryweapon )
		self.weapon = weapon;
	else if( weapon == self.secondaryweapon )
		self.weapon = weapon;
	else if( weapon == self.sidearm )
		self.weapon = weapon;
	else
		assertMsg( "weapon '" + weapon + "' does not match any known slot" );
}

usingPrimary()
{
	return( self.weapon == self.primaryweapon );
}

usingSecondary()
{
	return( self.weapon == self.secondaryweapon );
}

usingSidearm()
{
	return( self.weapon == self.sidearm );
}

getAICurrentWeaponSlot()
{
	if( self.weapon == self.primaryweapon )
		return "primary";
	else if( self.weapon == self.secondaryweapon )
		return "secondary";
	else if( self.weapon == self.sidearm )
		return "sidearm";
	else
		assertMsg( "self.weapon does not match any known slot" );
}

AIHasWeapon( weapon )
{
	if( isDefined( self.weaponInfo[ weapon ] ) )
		return true;
	
	return false;
}

getAnimEndPos( theanim )
{
	moveDelta = getMoveDelta( theanim, 0, 1 );
	return self localToWorldCoords( moveDelta );
}


isValidEnemy( enemy )
{
	if( !isDefined( enemy ) )
		return false;
	// dead enemies should be valid. AI don't acquire a new enemy until their enemy is done with the death animation, so it's better for them
	// to shoot at a dead enemy for a short time than look like they think they have nothing to do.
	// else if( isSentient( enemy ) && !isAlive( enemy ) && !isPlayer( enemy ) )
	// 	return false;
	
	return true;
}


damageLocationIsAny( a, b, c, d, e, f, g, h, i, j, k, ovr )
{
	 /* possibile self.damageLocation's:
		"torso_upper"
		"torso_lower"
		"helmet"
		"head"
		"neck"
		"left_arm_upper"
		"left_arm_lower"
		"left_hand"
		"right_arm_upper"
		"right_arm_lower"
		"right_hand"
		"gun"
		"none"
		"left_leg_upper"
		"left_leg_lower"
		"left_foot"
		"right_leg_upper"
		"right_leg_lower"
		"right_foot"
	 */ 

	if( !isdefined( a ) ) return false; if( self.damageLocation == a ) return true;
	if( !isdefined( b ) ) return false; if( self.damageLocation == b ) return true;
	if( !isdefined( c ) ) return false; if( self.damageLocation == c ) return true;
	if( !isdefined( d ) ) return false; if( self.damageLocation == d ) return true;
	if( !isdefined( e ) ) return false; if( self.damageLocation == e ) return true;
	if( !isdefined( f ) ) return false; if( self.damageLocation == f ) return true;
	if( !isdefined( g ) ) return false; if( self.damageLocation == g ) return true;
	if( !isdefined( h ) ) return false; if( self.damageLocation == h ) return true;
	if( !isdefined( i ) ) return false; if( self.damageLocation == i ) return true;
	if( !isdefined( j ) ) return false; if( self.damageLocation == j ) return true;
	if( !isdefined( k ) ) return false; if( self.damageLocation == k ) return true;
	assert( !isdefined( ovr ) );
	return false;
}


usingShotgun()
{
	return weaponClass( self.weapon ) == "spread";
}

usingPistol()
{
	return weaponClass( self.weapon ) == "pistol";
}

usingRocketLauncher()
{
	return weaponClass( self.weapon ) == "rocketlauncher";
}

usingRifle()
{
	return weaponClass( self.weapon ) == "rifle";
}

ragdollDeath( moveAnim )
{
	self endon( "killanimscript" );
	
	lastOrg = self.origin;
	moveVec = ( 0, 0, 0 );
	for( ;; )
	{
		wait( 0.05 );
		force = distance( self.origin, lastOrg );
		lastOrg = self.origin;

		if( self.health == 1 )
		{
			self.a.nodeath = true;
			self startRagdoll();
			self clearAnim( moveAnim, 0.1 );
			wait( 0.05 );
			physicsExplosionSphere( lastOrg, 600, 0, force * 0.1 );
			self notify( "killanimscript" );
			return;
		}
		
	}
}

isCQBWalking()
{
	return isdefined( self.cqbwalking ) && self.cqbwalking;
}

squared( value )
{
	return value * value;
}

randomizeIdleSet()
{
	self.a.idleSet = randomint( 2 );
}

weapon_spread()
{
	return weaponclass( self.weapon ) == "spread";
}

// meant to be used with any integer seed, for a small integer maximum (ideally one that divides anim.randomIntTableSize)
getRandomIntFromSeed( intSeed, intMax )
{
	assert( intMax > 0 );
	
	index = intSeed % anim.randomIntTableSize;
	return anim.randomIntTable[ index ] % intMax;
}
