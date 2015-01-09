#include maps\_utility;
#include animscripts\Combat_utility;
#include animscripts\utility;
#include common_scripts\Utility;

#using_animtree ("generic_human");

corner_think( direction )
{
	self endon ("killanimscript");
	
	self.animArrayFuncs["exposed"]["stand"] = animscripts\corner::set_standing_animarray_aiming;
	self.animArrayFuncs["exposed"]["crouch"] = animscripts\corner::set_crouching_animarray_aiming;
	
	self.coverNode = self.node;
	self.cornerDirection = direction;
	self.a.cornerMode = "unknown";
	
	self.a.standIdleThread = undefined;
	
	if ( self.a.pose == "crouch" )
	{
		set_anim_array( "crouch" );
	}
	else if ( self.a.pose == "stand" )
	{
		set_anim_array( "stand" );
	}
	else
	{
		assert( self.a.pose == "prone" );
		self ExitProneWrapper(1);
		self.a.pose = "crouch";
		self set_anim_array( "crouch" );
	}
	
	self.isshooting = false;
	self.tracking = false;
	
	self.cornerAiming = false;
	
	animscripts\shared::setAnimAimWeight( 0 );
	
	self.haveGoneToCover = false;
		
	behaviorCallbacks = spawnstruct();
	behaviorCallbacks.mainLoopStart			= ::mainLoopStart;
	behaviorCallbacks.reload				= ::cornerReload;
	behaviorCallbacks.leaveCoverAndShoot	= ::stepOutAndShootEnemy;
	behaviorCallbacks.look					= ::lookForEnemy;
	behaviorCallbacks.fastlook				= ::fastlook;
	behaviorCallbacks.idle					= ::idle;
	behaviorCallbacks.grenade				= ::tryThrowingGrenade;
	behaviorCallbacks.grenadehidden			= ::tryThrowingGrenadeStayHidden;
	behaviorCallbacks.blindfire				= ::blindfire;
	
	animscripts\cover_behavior::main( behaviorCallbacks );
}

mainLoopStart()
{
	desiredStance = "stand";
	if ( !self.coverNode doesNodeAllowStance("stand") && self.coverNode doesNodeAllowStance("crouch") )
		desiredStance = "crouch";
	
	/#
	if ( getdvarint("scr_cornerforcecrouch") == 1 )
		desiredStance = "crouch";
	#/
	
	if ( self.haveGoneToCover )
	{
		self transitionToStance( desiredStance );
	}
	else
	{
		if ( self.a.pose == desiredStance )
		{
			GoToCover( animArray( "alert_idle" ), .4, .4 );
		}
		else
		{
			stanceChangeAnim = animarray("stance_change");
			GoToCover( stanceChangeAnim, .4, getAnimLength( stanceChangeAnim ) );
			set_anim_array( desiredStance ); // (sets anim_pose to stance)
		}
		assert( self.a.pose == desiredStance );
		self.haveGoneToCover = true;
	}
}

printYaws()
{
	wait(2);
	for(;;)
	{
		println("coveryaw = ",self.coverNode GetYawToOrigin(getEnemyEyePos()));
		printYawToEnemy();
		wait(0.05);
	}
}

// used within canSeeEnemyFromExposed() (in utility.gsc)
canSeePointFromExposedAtCorner( point, node )
{
	yaw = node GetYawToOrigin( point );
	if ( (yaw > 60) || (yaw < -60) )
		return false;
	
	if ( (node.type == "Cover Left" || node.type == "Cover Left Wide") && yaw > 14 )
		return false;
	if ( (node.type == "Cover Right" || node.type == "Cover Right Wide") && yaw < -12 )
		return false;
	
	return true;
}

shootPosOutsideLegalYawRange()
{
	if ( !isdefined( self.shootPos ) )
		return false;
	
	yaw = self.coverNode GetYawToOrigin( self.shootPos );
	
	if ( self.cornerDirection == "left" )
	{
		if ( self.a.cornerMode == "B" )
		{
			return yaw < 0-self.ABangleCutoff || yaw > 14;
		}
		else if ( self.a.cornerMode == "A" )
		{
			return yaw > 0-self.ABangleCutoff;
		}
		else
		{
			assert( self.a.cornerMode == "lean" );
			return yaw < -50 || yaw > 8; // TODO
		}
	}
	else
	{
		assert( self.cornerDirection == "right" );
		if ( self.a.cornerMode == "B" )
		{
			return yaw > self.ABangleCutoff || yaw < -12;
		}
		else if ( self.a.cornerMode == "A" )
		{
			return yaw < self.ABangleCutoff;
		}
		else
		{
			assert( self.a.cornerMode == "lean" );
			return yaw > 50 || yaw < -8; // TODO
		}
	}
}

// getCornerMode will return "none" if no corner modes are acceptable.
getCornerMode( node, point )
{
	yaw = 0;
	if ( isdefined( point ) )
		yaw = node GetYawToOrigin( point );
	
	/#
	dvarval = getdvar("scr_cornerforcestance");
	if ( dvarval == "lean" || dvarval == "a" || dvarval == "b" )
		return dvarval;
	#/

	if ( self.cornerDirection == "left" )
	{
		if ( self shouldLean() )
		{
			if ( yaw >= -40 && yaw <= 0 )
				return "lean";
		}
		
		if ( yaw > 14 )
			return "none";
		if ( yaw < 0-self.ABangleCutoff )
			return "A";
	}
	else
	{
		assert( self.cornerDirection == "right" );
		
		if ( shouldLean() )
		{
			if ( yaw <= 40 && yaw >= 0 )
				return "lean";
		}

		if ( yaw < -12 )
			return "none";
		if ( yaw > self.ABangleCutoff )
			return "A";
	}
	return "B";
}

// getBestStepOutPos never returns "none".
// it returns the best stepoutpos that we can get to from our current one.
getBestStepOutPos()
{
	yaw = 0;
	if (canSuppressEnemy())
		yaw = self.coverNode GetYawToOrigin( getEnemySightPos() );
	
	/#
	dvarval = getdvar("scr_cornerforcestance");
	if ( dvarval == "lean" || dvarval == "a" || dvarval == "b" )
		return dvarval;
	#/

	if ( self.a.cornerMode == "lean" )
		return "lean";
	else if ( self.a.cornerMode == "B" )
	{
		if(self.cornerDirection == "left")
		{
			if(yaw < 0-self.ABangleCutoff)
				return "A";
		}
		else if(self.cornerDirection == "right")
		{
			if(yaw > self.ABangleCutoff)
				return "A";
		}
		return "B";
	}
	else if ( self.a.cornerMode == "A" )
	{
		positionToSwitchTo = "B";
		if(self.cornerDirection == "left")
		{
			if(yaw > 0-self.ABangleCutoff)
				return "B";
		}
		else if(self.cornerDirection == "right")
		{
			if(yaw < self.ABangleCutoff)
				return "B";
		}
		return "A";
	}
}

changeStepOutPos()
{
	self endon ("killanimscript");

	positionToSwitchTo = getBestStepOutPos();
	
	if ( positionToSwitchTo == self.a.cornerMode )
		return false;
	
	// can't switch between lean and other stepoutposes
	// so if this assert fails then getBestStepOutPos gave us a bad return value
	assert( self.a.cornerMode != "lean" && positionToSwitchTo != "lean" );
	
	self.changingCoverPos = true; self notify("done_changing_cover_pos");
	
	animname = self.a.cornerMode + "_to_" + positionToSwitchTo;
	assert( animArrayAnyExist( animname ) );
	switchanim = animArrayPickRandom( animname );
	
	midpoint = getPredictedPathMidpoint();
	if ( !self mayMoveToPoint( midpoint ) )
		return false;
	if ( !self mayMoveFromPointToPoint( midpoint, getAnimEndPos( switchanim ) ) )
		return false;
	
	self endStandIdleThread();
	
	// turn off aiming while we move.
	self StopAiming( .3 );
	
	prev_anim_pose = self.a.pose;
	
	self setanimlimited(animarray("straight_level"), 0, .2);
	
	self setFlaggedAnimKnob( "changeStepOutPos", switchanim, 1, .2, 1 );
	self thread DoNoteTracksWithEndon( "changeStepOutPos" );
	
	if ( animHasNotetrack( switchanim, "start_aim" ) )
	{
		self waittillmatch( "changeStepOutPos", "start_aim" );
	}
	else
	{
		/#println("^1Corner position switch animation \"" + animname + "\" in corner_" + self.cornerDirection + " " + self.a.pose + " didn't have \"start_aim\" notetrack");#/
		self waittillmatch( "changeStepOutPos", "end" );
	}
	
	self thread StartAiming( undefined, false, .3 );

	self waittillmatch( "changeStepOutPos", "end" );
	self clearanim(switchanim, .1);
	self.a.cornerMode = positionToSwitchTo;
	
	self.changingCoverPos = false;
	self.coverPosEstablishedTime = gettime();

	assert( self.a.pose == "stand" || self.a.pose == "crouch" );
	if ( self.a.pose != prev_anim_pose )
		set_anim_array( self.a.pose ); // don't call this if we don't have to, because we don't want to reset %exposed_aiming
	
	self thread ChangeAiming( undefined, true, .3 );
	
	return true;
}

shouldLean()
{
	if ( self.a.pose != "stand" )
		return false;
	
	if ( self.team == "allies" )
		return true;
	if ( self isPartiallySuppressedWrapper() )
		return true;
	return false;
}

DoNoteTracksWithEndon( animname )
{
	self endon("killanimscript");
	self animscripts\shared::DoNoteTracks( animname );
}

StartAiming( spot, fullbody, transtime )
{
	assert( !self.cornerAiming );
	self.cornerAiming = true;
	
	self SetAimingParams( spot, fullbody, transTime, self.a.cornerMode == "lean" );
}
ChangeAiming( spot, fullbody, transtime )
{
	assert( self.cornerAiming );
	self SetAimingParams( spot, fullbody, transTime, self.a.cornerMode == "lean" );
}
StopAiming( transtime )
{
	assert( self.cornerAiming );
	self.cornerAiming = false;
	
	// turn off shooting
	self clearAnim( %add_fire, transtime );
	// and turn off aiming
	animscripts\shared::setAnimAimWeight( 0, transtime );
}

SetAimingParams( spot, fullbody, transTime, lean )
{
	assert( isdefined(fullbody) );
	
	self.spot = spot; // undefined is ok
	
	self setanimlimited( %exposed_modern, 1, transTime );
	self setanimlimited( %exposed_aiming, 1, transTime );
	animscripts\shared::setAnimAimWeight( 1, transTime );

	if ( lean )
	{
		self setAnimLimited(animArray("lean_aim_straight"), 1, transTime);
		
		self setAnimKnobLimited(animArray("lean_aim_left"), 1, transTime);	
		self setAnimKnobLimited(animArray("lean_aim_right"), 1, transTime);			
		self setAnimKnobLimited(animArray("lean_aim_up"), 1, transTime);	
		self setAnimKnobLimited(animArray("lean_aim_down"), 1, transTime);	
	}
	else if ( fullbody )
	{
		self setAnimLimited(animarray("straight_level"), 1, transTime);
		
		self setAnimKnobLimited(animArray("add_aim_up"),1,transTime);
		self setAnimKnobLimited(animArray("add_aim_down"),1,transTime);
		self setAnimKnobLimited(animArray("add_aim_left"),1,transTime);
		self setAnimKnobLimited(animArray("add_aim_right"),1,transTime);
	}
	else
	{
		self setAnimLimited(animarray("straight_level"), 0, transTime);

		self setAnimKnobLimited(animArray("add_turn_aim_up"),1,transTime);
		self setAnimKnobLimited(animArray("add_turn_aim_down"),1,transTime);
		self setAnimKnobLimited(animArray("add_turn_aim_left"),1,transTime);
		self setAnimKnobLimited(animArray("add_turn_aim_right"),1,transTime);
	}
}

stepOut() /* bool */
{
	self.a.cornerMode = "alert";
	
	self animMode ( "zonly_physics" );
	
	if ( self.a.pose == "stand" )
	{
		self.ABangleCutoff = 38;
	}
	else
	{
		assert( self.a.pose == "crouch" );
		self.ABangleCutoff = 31;
	}
	
	thisNodePose = self.a.pose;
	set_anim_array( thisNodePose );
	
	newCornerMode = "none";
	if ( hasEnemySightPos() )
		newCornerMode = getCornerMode( self.coverNode, getEnemySightPos() );
	else
		newCornerMode = getCornerMode( self.coverNode );
	if ( newCornerMode == "none" )
		return false;
	
	animname = "alert_to_" + newCornerMode;
	assert( animArrayAnyExist( animname ) );
	switchanim = animArrayPickRandom( animname );
	
	if ( !isPathClear( switchanim, newCornerMode != "lean" ) )
		return false;
	
	self.a.cornerMode = newCornerMode;
	
	self set_aiming_limits();
	if ( self.a.cornerMode == "lean" )
	{
		if ( self.cornerDirection == "left" )
			self.rightaimlimit = 0;
		else
			self.leftaimlimit = 0;
	}

	self.a.special = "none";

	self.keepclaimednode = true;
	self.keepClaimedNodeInGoal = true;
	
	self.changingCoverPos = true; self notify("done_changing_cover_pos");
	
	self setFlaggedAnimKnobAllRestart( "stepout", switchanim, %root, 1, .2, 1.0 );
	self thread DoNoteTracksWithEndon( "stepout" );
	
	hasStartAim = animHasNotetrack( switchanim, "start_aim" );
	if ( hasStartAim )
	{
		self waittillmatch("stepout","start_aim");
	}
	else
	{
		/#println("^1Corner stepout animation \"" + animname + "\" in corner_" + self.cornerDirection + " " + self.a.pose + " didn't have \"start_aim\" notetrack");#/
		self waittillmatch( "stepout", "end" );
	}
	
	
	if ( newCornerMode == "B" && self.cornerDirection == "right" )
		self.a.special = "corner_right_mode_b";
	
	set_anim_array_aiming( thisNodePose );

	self StartAiming( undefined, false, .3 );
	self thread animscripts\shared::trackShootEntOrPos();
	
	if ( hasStartAim )
		self waittillmatch("stepout","end");
	
	self ChangeAiming( undefined, true, 0.2 );
	self clearAnim( %cover, 0.2 );
	self clearAnim( %corner, 0.2 );
	
	self.changingCoverPos = false;
	self.coverPosEstablishedTime = gettime();
	
	return true;
}

stepOutAndShootEnemy()
{
	/*
	// rambo disabled.
	ramboChance = 10;
	if ( isdefined( self.lastSuppressionTime ) && gettime() - self.lastSuppressionTime < 3000 )
		ramboChance = 30;
	
	if ( self.shootObjective == "normal" && canDoRambo() && randomint(100) < ramboChance && haventRamboedWithinTime( 7 ) )
	{
		return ramboStepOut();
	}*/

	if ( !StepOut() ) // may not be room to step out
		return false;
	
	shootAsTold();

	if ( isDefined( self.shootPos ) )
	{
		distSqToShootPos = lengthsquared( self.origin - self.shootPos );
		// too close for RPG or out of ammo
		if ( weaponAnims() == "rocketlauncher" && (distSqToShootPos < squared( 512 ) || self.a.rockets < 1 ) )
		{
			if ( self.a.pose == "stand" )
				animscripts\shared::throwDownWeapon( %RPG_stand_throw );
			else
				animscripts\shared::throwDownWeapon( %RPG_crouch_throw );

			self thread runCombat();
			return;
		}
	}
	
	returnToCover();
	
	return true;
}

canDoRambo()
{
	return animArrayAnyExist("rambo") && self.team != "allies";
}

haventRamboedWithinTime(time)
{
	if ( !isdefined( self.lastRamboTime ) )
		return true;
	return gettime() - self.lastRamboTime > time * 1000;
}

/*ramboStepOut()
{
	assert( animArrayAnyExist("rambo") );
	ramboanim = animArrayPickRandom("rambo");
	
	if ( !isPathClear() )
		return false;
	
	self.a.special = "none";
	
	self animMode ( "zonly_physics" );
	self.keepClaimedNodeInGoal = true;

	self setFlaggedAnimKnobAllRestart("rambo", ramboanim, %body, 1, 0);
	self animscripts\shared::DoNoteTracks("rambo");

	self.lastRamboTime = gettime();

	self.keepClaimedNodeInGoal = false;
	
	return true;
}*/

shootAsTold()
{
	self maps\_gameskill::didSomethingOtherThanShooting();
	
	while(1)
	{
		while(1)
		{
			if ( self.shouldReturnToCover )
				break;
			
			if ( !isdefined( self.shootPos ) ) {
				assert( !isdefined( self.shootEnt ) );
				// give shoot_behavior a chance to iterate
				wait .05;
				waittillframeend;
				if ( isdefined( self.shootPos ) )
					continue;
				break;
			}
			
			if ( !self.bulletsInClip )
				break;
			
			if ( shootPosOutsideLegalYawRange() )
			{
				if ( !changeStepOutPos() )
				{
					// if we failed because there's no better step out pos, give up
					if ( getBestStepOutPos() == self.a.cornerMode )
						break;
					
					// couldn't change position, shoot for a short bit and we'll try again
					shootUntilShootBehaviorChangeForTime( .2 );
					continue;
				}
				
				// if they're moving back and forth too fast for us to respond intelligently to them,
				// give up on firing at them for the moment
				if ( shootPosOutsideLegalYawRange() )
					break;
				
				continue;
			}
			
			shootUntilShootBehaviorChange_corner( true );
			
			self clearAnim( %add_fire, .2 );
		}
		
		if ( self canReturnToCover( self.a.cornerMode != "lean" ) )
			break;

		// couldn't return to cover. keep shooting and try again
		
		// (change step out pos if necessary and possible)
		if ( shootPosOutsideLegalYawRange() && changeStepOutPos() )
			continue;
		
		shootUntilShootBehaviorChangeForTime( .2 );
	}
}

shootUntilShootBehaviorChangeForTime( time )
{
	self thread notifyStopShootingAfterTime( time );
	
	starttime = gettime();
	
	shootUntilShootBehaviorChange_corner( false );
	self notify("stopNotifyStopShootingAfterTime");

	timepassed = (gettime() - starttime) / 1000;
	if ( timepassed < time )
		wait time - timepassed;
}

notifyStopShootingAfterTime( time )
{
	self endon("killanimscript");
	self endon("stopNotifyStopShootingAfterTime");
	
	wait time;
	
	self notify("stopShooting");
}

shootUntilShootBehaviorChange_corner( runAngleRangeThread )
{
	self endon("return_to_cover");
	
	if ( runAngleRangeThread )
		self thread angleRangeThread(); // gives stopShooting notify when shootPosOutsideLegalYawRange returns true
	self thread standIdleThread();
	
	shootUntilShootBehaviorChange();
}

standIdleThread()
{
	self endon("killanimscript");
	
	if ( isdefined( self.a.standIdleThread ) )
		return;
	self.a.standIdleThread = true;
	
	self setAnim( %add_idle, 1, .2 );
	standIdleThreadInternal();
	self clearAnim( %add_idle, .2 );
}

endStandIdleThread()
{
	self.a.standIdleThread = undefined;
	self notify("end_stand_idle_thread");
}

standIdleThreadInternal()
{
	self endon("killanimscript");
	self endon("end_stand_idle_thread");
	
	animArrayArg = "exposed_idle";
	if ( self.a.cornerMode == "lean" )
		animArrayArg = "lean_idle";
	
	assert( animArrayAnyExist( animArrayArg ) );
	for( i = 0; ; i++ )
	{
		flagname = "idle" + i;
		idleanim = animArrayPickRandom( animArrayArg );
		
		self setFlaggedAnimKnobLimitedRestart( flagname, idleanim, 1, 0.2 );
		
		self waittillmatch( flagname, "end" );
	}
}

angleRangeThread()
{
	self endon ("killanimscript");
	self notify ("newAngleRangeCheck");
	self endon ("newAngleRangeCheck");
	self endon ("take_cover_at_corner");
	
	while (1)
	{
		if ( shootPosOutsideLegalYawRange() )
			break;
		wait (0.1);
	}

	self notify ("stopShooting"); // For changing shooting pose to compensate for player moving
}

showstate()
{
	self.enemy endon("death");
	self endon("enemy");
	self endon("stopshowstate");
	
	while(1)
	{
		wait .05;
		print3d(self.origin + (0,0,60), self.statetext);
	}
}

canReturnToCover( doMidpointCheck )
{
	if ( !anim.maymoveCheckEnabled )
		return true;
	
	if ( doMidpointCheck )
	{
		midpoint = getPredictedPathMidpoint();
		
		if ( !self mayMoveToPoint( midpoint ) )
			return false;
		
		return self mayMoveFromPointToPoint( midpoint, self.coverNode.origin );
	}
	else
	{
		return self mayMoveToPoint( self.coverNode.origin );
	}
}

returnToCover()
{
	assert( self canReturnToCover( self.a.cornerMode != "lean" ) );
	
	self endStandIdleThread();
	
	// Go back into hiding.
	suppressed = issuppressedWrapper();
	self notify ("take_cover_at_corner"); // Stop doing the adjust-stance transition thread
	
	self thread resetAnimSpecial( 0.3 );
	
	if ( suppressed )
		rate = 1.5;
	else
		rate = 1;
	
	self.changingCoverPos = true; self notify("done_changing_cover_pos");
	
	animname = self.a.cornerMode + "_to_alert";
	assert( animArrayAnyExist( animname ) );
	switchanim = animArrayPickRandom( animname );

	self StopAiming( .3 );
	self clearAnim( %add_fire, .2 );
	
	reloading = false;
	if ( self.a.cornerMode != "lean" && suppressed && animArrayAnyExist( animname + "_reload" ) && randomfloat(100) < 75 )
	{
		switchanim = animArrayPickRandom( animname + "_reload" );
		rate = 1;
		reloading = true;
	}
	// turn off the standing anim
	self setanimlimited(animarray("straight_level"), 0, .1);
	
	// as we turn on the hiding anim
	self setFlaggedAnimKnobAllRestart("hide", switchanim, %body, 1, .1, rate);
	self animscripts\shared::DoNoteTracks("hide");
	self.a.alertness = "alert";	// Should be set in the aim2alert animation but sometimes isn't.
	
	if ( reloading )
		self animscripts\weaponList::RefillClip();
	
	self notify ( "stop updating angles" );
	self notify ("stop EyesAtEnemy");
	self notify ("stop tracking");
	
	self.changingCoverPos = false;
	if( self.cornerDirection == "left" )
		self.a.special = "cover_left";
	else
		self.a.special = "cover_right";
	
	self.keepClaimedNodeInGoal = false;
	self.keepclaimednode = false;
	
	self clearAnim( switchanim, 0.2 );
}

resetAnimSpecial( delay )
{
	self endon("killanimscript");
	wait delay;
	self.a.special = "none";
}

blindfire()
{
	if ( !animArrayAnyExist("blind_fire") )
		return false;
	
	self animMode ( "zonly_physics" );
	self.keepClaimedNodeInGoal = true;

	self setFlaggedAnimKnobAllRestart("blindfire", animArrayPickRandom("blind_fire"), %body, 1, 0, 1);
	self animscripts\shared::DoNoteTracks("blindfire");

	self.keepClaimedNodeInGoal = false;
	
	return true;
}

linethread(a,b,col)
{
	if ( !isdefined(col) )
		col = (1,1,1);
	for ( i = 0; i < 100; i++)
	{
		line(a,b,col);
		wait .05;
	}
}

tryThrowingGrenadeStayHidden( throwAt )
{
	return tryThrowingGrenade( throwAt, true );
}

tryThrowingGrenade( throwAt, safe )
{
	if ( !self mayMoveToPoint( self getPredictedPathMidpoint() ) )
		return false;
	
	theanim = undefined;
	if ( isdefined(safe) && safe ) {
		if ( !isdefined( self.a.array["grenade_safe"] ) )
			return false;
		theanim = animArray("grenade_safe");
	}
	else {
		if ( !isdefined( self.a.array["grenade_exposed"] ) )
			return false;
		theanim = animArray("grenade_exposed");
	}
	
	self animMode ( "zonly_physics" ); // Unlatch the feet
	self.keepClaimedNodeInGoal = true;
	
	armOffset = (32,20,64); // needs fixing!
	threwGrenade = TryGrenade( throwAt, theanim );
	
	self.keepClaimedNodeInGoal = false;
	return threwGrenade;
}

printYawToEnemy() 
{
	println("yaw: ",self getYawToEnemy());
}

lookForEnemy( lookTime )
{
	if ( !isdefined( self.a.array["alert_to_look"] ) )
		return false;
	
	self animMode( "zonly_physics" ); // Unlatch the feet
	self.keepClaimedNodeInGoal = true;
	
	// look out from alert
	if ( !peekOut() )
		return false;
	
	animscripts\shared::playLookAnimation( animarray("look_idle"), lookTime, ::canStopPeeking );
	
	lookanim = undefined;
	if ( self isSuppressedWrapper() )
		lookanim = animArray("look_to_alert_fast");
	else
		lookanim = animArray("look_to_alert");
	
	self setflaggedanimknoballrestart("looking_end", lookanim, %body, 1, .1, 1.0);
	animscripts\shared::DoNoteTracks("looking_end");
	
	self animMode ( "zonly_physics" ); // Unlatch the feet
	
	self.keepClaimedNodeInGoal = false;
	
	return true;
}


peekOut()
{
	peekanim = animArray("alert_to_look");
	
	if ( !self mayMoveToPoint( getAnimEndPos( peekanim ) ) )
		return false;
	
	// not safe to stop peeking in the middle because it will screw up our deltas
	//self thread _peekStop();
	//self endon ("stopPeeking");
	
	self setflaggedanimknobAll("looking_start", peekanim, %body, 1, .2, 1);
	animscripts\shared::DoNoteTracks("looking_start");
	//self notify ("stopPeekCheckThread");
	
	return true;
}

canStopPeeking()
{
	return self mayMoveToPoint( self.coverNode.origin );
}

fastlook()
{
	// corner fast look animations aren't set up right.
	return false;
	
	/*
	if ( !isdefined( self.a.array["look"] ) )
		return false;
	
	self setFlaggedAnimKnobAllRestart( "look", animArray( "look" ), %body, 1, .1 );
	self animscripts\shared::DoNoteTracks( "look" );
	
	return true;
	*/
}

cornerReload()
{
	assert( animArrayAnyExist( "reload" ) );
	
	reloadanim = animArrayPickRandom( "reload" );
	self setFlaggedAnimKnobRestart( "cornerReload", reloadanim, 1, .2 );
	
	self animscripts\shared::DoNoteTracks( "cornerReload" );
	
	self animscripts\weaponList::RefillClip();
	
	self setAnimRestart( animarray( "alert_idle" ), 1, .2 );
	self clearAnim( reloadanim, .2 );
	
	return true;
}

isPathClear( stepoutanim, doMidpointCheck )
{
	if ( !anim.maymoveCheckEnabled )
		return true;
	
	if ( doMidpointCheck )
	{
		midpoint = getPredictedPathMidpoint();
		
		if ( !self maymovetopoint( midpoint ) )
			return false;
	
		return self maymovefrompointtopoint( midpoint, getAnimEndPos( stepoutanim ) );
	}
	else
	{
		return self maymovetopoint( getAnimEndPos( stepoutanim ) );
	}
}

getPredictedPathMidpoint()
{
	angles = self.coverNode.angles;
	right = anglestoright(angles);
	switch ( self.a.script )
	{
		case "cover_left":
			right = vectorScale(right, -36);
		break;

		case "cover_right":
			right = vectorScale(right, 36);
		break;
		
		default:
			assertEx(0, "What kind of node is this????");
	}
	
	return self.coverNode.origin + (right[0], right[1], 0);
}

idle()
{
	self endon("end_idle");
	
	while( 1 )
	{
		useTwitch = (randomint(2) == 0 && animArrayAnyExist("alert_idle_twitch"));
		if ( useTwitch )
			idleanim = animArrayPickRandom("alert_idle_twitch");
		else
			idleanim = animarray("alert_idle");
	
		playIdleAnimation( idleAnim, useTwitch );
	}
}

flinch()
{
	if ( !animArrayAnyExist("alert_idle_flinch") )
		return false;
	
	playIdleAnimation( animArrayPickRandom("alert_idle_flinch"), true );
	
	return true;
}

playIdleAnimation( idleAnim, needsRestart )
{
	if ( needsRestart )
		self setFlaggedAnimKnobAllRestart( "idle", idleAnim, %body, 1, .1, 1);
	else
		self setFlaggedAnimKnobAll       ( "idle", idleAnim, %body, 1, .1, 1);
	
	self animscripts\shared::DoNoteTracks( "idle" );
}


set_anim_array( stance ) 
{
	[[ self.animArrayFuncs["hiding"][ stance ] ]]();
	[[ self.animArrayFuncs["exposed"][ stance ] ]]();
}
set_anim_array_aiming( stance )
{
	[[ self.animArrayFuncs["exposed"][ stance ] ]]();
}

transitionToStance( stance )
{
	if (self.a.pose == stance)
	{
		set_anim_array( stance );
		return;
	}

//	self ExitProneWrapper(0.5);
	self setFlaggedAnimKnobAllRestart( "changeStance", animarray("stance_change"), %body);

	set_anim_array( stance ); // (sets anim_pose to stance)

	self animscripts\shared::DoNoteTracks( "changeStance" );
	assert( self.a.pose == stance );
	wait (0.2);
}

GoToCover( coveranim, transTime, playTime )
{	
	cornerAngle = GetNodeDirection();
	cornerOrigin = GetNodeOrigin();
	
	desiredYaw = cornerAngle + self.hideyawoffset;

	self OrientMode( "face angle", desiredYaw );

	self animMode ( "normal" );
	
	assert( transTime <= playTime );
	
	self thread animscripts\shared::moveToOriginOverTime( cornerOrigin, transTime );
	self setFlaggedAnimKnobAllRestart( "coveranim", coveranim, %body, 1, transTime );
	self animscripts\shared::DoNoteTracksForTime( playTime, "coveranim" );
	
	while ( AbsAngleClamp180( self.angles[1] - desiredYaw ) > 1 )
	{
		self animscripts\shared::DoNoteTracksForTime( 0.1, "coveranim" );
	}
	
	self animMode ( "zonly_physics" );

	if( self.cornerDirection == "left" )
		self.a.special = "cover_left";
	else
		self.a.special = "cover_right";
}

drawoffset()
{
	self endon("killanimscript");
	for(;;)
	{
		line(self.node.origin + (0,0,20),(0,0,20) + self.node.origin + vectorscale(anglestoright(self.node.angles + (0,0,0)),16));
		wait(0.05);	
	}
}


set_standing_animarray_aiming() 
{
	if(!isdefined(self.a.array))
		assertmsg("set_standing_animarray_aiming_AandC::this function needs to be called after the initial corner set_ functions"); 
	
	self.a.array["add_aim_up"] = %exposed_aim_8;
	self.a.array["add_aim_down"] = %exposed_aim_2;
	self.a.array["add_aim_left"] = %exposed_aim_4;
	self.a.array["add_aim_right"] = %exposed_aim_6;
	self.a.array["add_turn_aim_up"] = %exposed_turn_aim_8;
	self.a.array["add_turn_aim_down"] = %exposed_turn_aim_2;
	self.a.array["add_turn_aim_left"] = %exposed_turn_aim_4;
	self.a.array["add_turn_aim_right"] = %exposed_turn_aim_6;
	self.a.array["straight_level"] = %exposed_aim_5;
	
	if ( self.a.cornerMode == "lean" )
	{
		// use the lean animations set up in cover_left and cover_right.gsc
		leanfire = self.a.array["lean_fire"];
		self.a.array["fire"] = leanfire;
		self.a.array["single"] = array( self.a.array["lean_single"] );

		self.a.array["semi2"] = leanfire;
		self.a.array["semi3"] = leanfire;
		self.a.array["semi4"] = leanfire;
		self.a.array["semi5"] = leanfire;

		self.a.array["burst2"] = leanfire;
		self.a.array["burst3"] = leanfire;
		self.a.array["burst4"] = leanfire;
		self.a.array["burst5"] = leanfire;
		self.a.array["burst6"] = leanfire;
	}
	else
	{
		self.a.array["fire"] = %exposed_shoot_auto_v2;
		self.a.array["semi2"] = %exposed_shoot_semi2;
		self.a.array["semi3"] = %exposed_shoot_semi3;
		self.a.array["semi4"] = %exposed_shoot_semi4;
		self.a.array["semi5"] = %exposed_shoot_semi5;
		
		if ( self usingShotgun() )
			self.a.array["single"] = array( %shotgun_stand_fire_1A );
		else
			self.a.array["single"] = array( %exposed_shoot_semi1 );
		
		self.a.array["burst2"] = %exposed_shoot_burst3; // (will be limited to 2 shots)
		self.a.array["burst3"] = %exposed_shoot_burst3;
		self.a.array["burst4"] = %exposed_shoot_burst4;
		self.a.array["burst5"] = %exposed_shoot_burst5;
		self.a.array["burst6"] = %exposed_shoot_burst6;
	}
	self.a.array["exposed_idle"] = array( %exposed_idle_alert_v1, %exposed_idle_alert_v2, %exposed_idle_alert_v3 );
}

set_crouching_animarray_aiming() 
{
	if(!isdefined(self.a.array))
		assertmsg("set_standing_animarray_aiming_AandC::this function needs to be called after the initial corner set_ functions"); 
	
	self.a.array["add_aim_up"] = %exposed_crouch_aim_8;
	self.a.array["add_aim_down"] = %exposed_crouch_aim_2;
	self.a.array["add_aim_left"] = %exposed_crouch_aim_4;
	self.a.array["add_aim_right"] = %exposed_crouch_aim_6;
	self.a.array["add_turn_aim_up"] = %exposed_crouch_turn_aim_8;
	self.a.array["add_turn_aim_down"] = %exposed_crouch_turn_aim_2;
	self.a.array["add_turn_aim_left"] = %exposed_crouch_turn_aim_4;
	self.a.array["add_turn_aim_right"] = %exposed_crouch_turn_aim_6;
	self.a.array["straight_level"] = %exposed_crouch_aim_5;
	
	self.a.array["fire"] = %exposed_crouch_shoot_auto_v2;
	self.a.array["semi2"] = %exposed_crouch_shoot_semi2;
	self.a.array["semi3"] = %exposed_crouch_shoot_semi3;
	self.a.array["semi4"] = %exposed_crouch_shoot_semi4;
	self.a.array["semi5"] = %exposed_crouch_shoot_semi5;
	
	if ( self usingShotgun() )
		self.a.array["single"] = array( %shotgun_crouch_fire );
	else
		self.a.array["single"] = array( %exposed_crouch_shoot_semi1 );

	self.a.array["burst2"] = %exposed_crouch_shoot_burst3; // (will be limited to 2 shots)
	self.a.array["burst3"] = %exposed_crouch_shoot_burst3;
	self.a.array["burst4"] = %exposed_crouch_shoot_burst4;
	self.a.array["burst5"] = %exposed_crouch_shoot_burst5;
	self.a.array["burst6"] = %exposed_crouch_shoot_burst6;
	
	self.a.array["exposed_idle"] = array( %exposed_crouch_idle_alert_v1, %exposed_crouch_idle_alert_v2, %exposed_crouch_idle_alert_v3 );
}

set_aiming_limits() 
{
	self.rightAimLimit = 45;
	self.leftAimLimit = -45;
	self.upAimLimit = 45;
	self.downAimLimit = -45;
}

runCombat()
{
	self notify( "killanimscript" );
	self thread animscripts\combat::main();
}