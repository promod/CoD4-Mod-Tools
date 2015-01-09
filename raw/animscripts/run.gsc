#include animscripts\Utility;
#include animscripts\Combat_Utility;
#include animscripts\SetPoseMovement;
#include common_scripts\utility;
#using_animtree ("generic_human");

MoveRun()
{
	desiredPose = self animscripts\utility::choosePose( "stand" );
	
	switch ( desiredPose )
	{
	case "stand":
		if ( BeginStandRun() ) // returns false (and does nothing) if we're already stand-running
			return;
		
		if ( changeWeaponStandRun() )
			return;
		
		if ( ReloadStandRun() )
			return;
		
		if ( self animscripts\utility::IsInCombat() )
		{
			if ( isDefined( self.run_combatanim ) )
				MoveStandCombatOverride();
			else
				MoveStandCombatNormal();
		}
		else
		{
			if ( isDefined( self.run_noncombatanim ) )
				MoveStandNoncombatOverride();
			else
				MoveStandNoncombatNormal();
		}
		break;
		
	case "crouch":
		if ( BeginCrouchRun() ) // returns false (and does nothing) if we're already crouch-running
			return;
		
		if ( isDefined( self.crouchrun_combatanim ) )
			MoveCrouchRunOverride();
		else
			MoveCrouchRunNormal();
		break;

	default:
		assert(desiredPose == "prone");
		if ( BeginProneRun() ) // returns false (and does nothing) if we're already prone-running
			return;
		
		ProneCrawl();
		break;
	}
}

GetRunAnim()
{
	if ( isdefined( self.a.combatRunAnim ) )
		return self.a.combatRunAnim;
	
	return %run_lowready_F;
}

GetCrouchRunAnim()
{
	if ( isdefined( self.a.crouchRunAnim ) )
		return self.a.crouchRunAnim;
	
	return %crouch_fastwalk_F;
}


ProneCrawl()
{
	self.a.movement = "run";
	self setflaggedanimknob( "runanim",%prone_crawl, 1, .3, self.moveplaybackrate );
	animscripts\shared::DoNoteTracksForTime(0.25, "runanim");
}


DoNoteTracksNoShootStandCombat(animName)
{
	animscripts\shared::DoNoteTracksForTime(0.2, animName);	
}

MoveStandCombatOverride()
{
	self clearanim(%combatrun, 0.6);
	self setanimknoball(%combatrun, %body, 1, 0.5, self.moveplaybackrate);
	self setflaggedanimknob("runanim", self.run_combatanim, 1, 0.5);
	DoNoteTracksNoShootStandCombat("runanim");
}


MoveStandCombatNormal()
{
	self clearanim( %walk_and_run_loops, 0.2 );
	
	self setanimknob( %combatrun, 1.0, 0.5, self.moveplaybackrate );
	
	decidedAnimation = false;
	
	if ( isdefined( self.sprint ) && self.sprint )
	{
		self setFlaggedAnimKnob ("runanim", %sprint1_loop, 1, 0.5 );
		decidedAnimation = true;
	}
	else if ( animscripts\move::MayShootWhileMoving() && self.bulletsInClip > 0 && isValidEnemy( self.enemy ) )
	{
		runShootWhileMovingThreads();
		
		if ( self.shootStyle != "none" )
		{
			if ( CanShootWhileRunningForward() )
			{
				enemyyaw = self GetPredictedYawToEnemy( 0.2 );
				sideanim = %run_n_gun_R;
				othersideanim = %run_n_gun_L;
				if ( enemyyaw < 0 )
				{
					enemyyaw = -1 * enemyyaw;
					sideanim = %run_n_gun_L;
					othersideanim = %run_n_gun_R;
				}
				if ( enemyyaw > 60.0 )
				{
					self setAnimKnobLimited( sideanim, 1, 0.2 );
				}
				else
				{
					weight = enemyyaw / 60.0;
					assertex( weight >= 0 && weight <= 1, weight );
					self setAnimLimited( %run_n_gun_F, 1.0 - weight, 0.2 );
					self setAnimLimited( sideanim, weight, 0.2 );
					self setAnimLimited( othersideanim, 0, 0.2 );
				}
				
				self setFlaggedAnimKnob("runanim", %run_n_gun, 1, 0.3, 0.8);
				
				self.a.allowedPartialReloadOnTheRunTime = gettime() + 500;
				
				if ( isplayer( self.enemy ) )
					self updatePlayerSightAccuracy();
				
				decidedAnimation = true;
			}
			else if ( CanShootWhileRunningBackward() )
			{
				// we don't blend the running-backward animation because it
				// doesn't blend well with the run-left and run-right animations.
				// it's also easier to just play one animation than rework everything
				// to consider the possibility of multiple "backwards" animations
				
				self setFlaggedAnimKnob( "runanim", %run_n_gun_B, 1, 0.3 );
				
				if ( isplayer( self.enemy ) )
					self updatePlayerSightAccuracy();
		
				DoNoteTracksNoShootStandCombat("runanim");
				
				self thread stopShootWhileMovingThreads();
				
				self notify("stopRunning");
				self clearAnim( %run_n_gun_B, 0.2 );
				
				return;
			}
		}
	}
	if ( !decidedAnimation )
	{
		runAnim = GetRunAnim();
		self setFlaggedAnimKnob ("runanim", runAnim, 1, 0.5 );
	}
	
	// Play the appropriately weighted run animations for the direction he's moving
	self UpdateRunWeightsOnce(
		%combatrun_forward,
		%run_lowready_B,
		%run_lowready_L,
		%run_lowready_R
	);
	DoNoteTracksNoShootStandCombat("runanim"); // does 0.2 seconds
	
	self thread stopShootWhileMovingThreads();
	
	self notify("stopRunning");
}


runShootWhileMovingThreads()
{
	self notify("want_shoot_while_moving");

	if ( isdefined( self.shoot_while_moving_thread ) )
		return;
	self.shoot_while_moving_thread = true;
	
	self thread RunDecideWhatAndHowToShoot();
	self thread RunShootWhileMoving();
}
stopShootWhileMovingThreads() // we don't stop them if we shoot while moving again
{
	self endon("killanimscript");
	self endon("want_shoot_while_moving");
	
	wait .05;
	
	self notify("end_shoot_while_moving");
	self.shoot_while_moving_thread = undefined;
}


RunDecideWhatAndHowToShoot()
{
	self endon("killanimscript");
	self endon("end_shoot_while_moving");
	self animscripts\shoot_behavior::decideWhatAndHowToShoot( "normal" );
}
RunShootWhileMoving()
{
	self endon("killanimscript");
	self endon("end_shoot_while_moving");
	self animscripts\move::shootWhileMoving();
}

aimedSomewhatAtEnemy()
{
	weaponAngles = self gettagangles("tag_weapon");
	anglesToShootPos = vectorToAngles( self.enemy getShootAtPos() - self gettagorigin("tag_weapon") );
	
	if ( AbsAngleClamp180( weaponAngles[1] - anglesToShootPos[1] ) > 15 )
		return false;
	
	return AbsAngleClamp180( weaponAngles[0] - anglesToShootPos[0] ) <= 20;
}

CanShootWhileRunningForward()
{
	if ( abs( self getMotionAngle() ) > 60 )
		return false;
	
	enemyyaw = self GetPredictedYawToEnemy( 0.2 );
	if ( abs( enemyyaw ) > 75 )
		return false;
	
	return true;
}

CanShootWhileRunningBackward()
{
	if ( 180 - abs( self getMotionAngle() ) >= 45 )
		return false;
	
	enemyyaw = self GetPredictedYawToEnemy( 0.2 );
	if ( abs( enemyyaw ) > 30 )
		return false;
	
	return true;
}

CanShootWhileRunning()
{
	return animscripts\move::MayShootWhileMoving() && isValidEnemy( self.enemy ) && (CanShootWhileRunningForward() || CanShootWhileRunningBackward());
}

GetPredictedYawToEnemy( lookAheadTime )
{
	assert( isValidEnemy( self.enemy ) );
	
	selfPredictedPos = self.origin;
	moveAngle = self.angles[1] + self getMotionAngle();
	selfPredictedPos += (cos( moveAngle ), sin( moveAngle ), 0) * 200.0 * lookAheadTime;
	
	yaw = self.angles[1] - VectorToAngles(self.enemy.origin - selfPredictedPos)[1];
	yaw = AngleClamp180( yaw );
	return yaw;
}

MoveStandNoncombatOverride()
{
	self endon("movemode");

	self clearanim(%combatrun, 0.6);
	self setflaggedanimknoball("runanim", self.run_noncombatanim, %body, 1, 0.3, self.moveplaybackrate );
	animscripts\shared::DoNoteTracksForTime(0.2, "runanim");
}

MoveStandNoncombatNormal()
{
	self endon("movemode");

	self clearanim(%combatrun, 0.6);
	
	self setanimknoball(%combatrun, %body, 1, 0.2, self.moveplaybackrate);

	prerunAnim = GetRunAnim();
	
	// changed it back to 0.3 because it pops when the AI goes from combat to noncombat
	self setflaggedanimknob("runanim", prerunAnim, 1, 0.3); // was 0.3

	// Play the appropriately weighted animations for the direction he's moving.
	animWeights = animscripts\utility::QuadrantAnimWeights( self getMotionAngle() );
	self setanim(%combatrun_forward, animWeights["front"], 0.2, 1);
	self setanim(%run_lowready_B, animWeights["back"], 0.2, 1);
	self setanim(%run_lowready_L, animWeights["left"], 0.2, 1);
	self setanim(%run_lowready_R, animWeights["right"], 0.2, 1);

	animscripts\shared::DoNoteTracksForTime(0.2, "runanim");
}

MoveCrouchRunOverride()
{
	self endon("movemode");

	self setflaggedanimknoball("runanim", self.crouchrun_combatanim, %body, 1, 0.4, self.moveplaybackrate);
	animscripts\shared::DoNoteTracksForTime(0.2, "runanim");
}

MoveCrouchRunNormal()
{
	self endon("movemode");

	// Play the appropriately weighted crouchrun animations for the direction he's moving
	forward_anim = GetCrouchRunAnim();

	self setanimknob( forward_anim, 1, 0.4 );

	animWeights = animscripts\utility::QuadrantAnimWeights( self getMotionAngle() );
	self setanim(forward_anim      , animWeights["front"], 0.2, 1);
	self setanim(%crouch_fastwalk_B, animWeights["back"], 0.2, 1);
	self setanim(%crouch_fastwalk_L, animWeights["left"], 0.2, 1);
	self setanim(%crouch_fastwalk_R, animWeights["right"], 0.2, 1);

	self setflaggedanimknoball("runanim", %crouchrun, %body, 1, 0.2, self.moveplaybackrate);

	animscripts\shared::DoNoteTracksForTime(0.2, "runanim");
}

ReloadStandRun()
{
	reloadIfEmpty = isdefined( self.a.allowedPartialReloadOnTheRunTime ) && self.a.allowedPartialReloadOnTheRunTime > gettime();
	reloadIfEmpty = reloadIfEmpty || ( isdefined( self.enemy ) && distanceSquared( self.origin, self.enemy.origin ) < 256 * 256 );
	if ( reloadIfEmpty )
	{
		if ( !self NeedToReload( 0 ) )
			return false;
	}
	else
	{
		if ( !self NeedToReload( .5 ) )
			return false;
	}
	
	if ( self CanShootWhileRunning() && !self NeedToReload( 0 ) )
		return false;
	
	if ( !isdefined( self.pathGoalPos ) || distanceSquared( self.origin, self.pathGoalPos ) < 256*256 )
		return false;
	
	motionAngle = AngleClamp180( self getMotionAngle() );
	
	// want to be running forward; otherwise we won't see the animation play!
	if ( abs( motionAngle ) > 25 )
		return false;
	
	if ( self WeaponAnims() != "rifle" )
		return false;
	
	// need to restart the run cycle because the reload animation has to be played from start to finish!
	// the goal is to play it only when we're near the end of the run cycle.
	if ( !runLoopIsNearBeginning() )
		return false;
	
	// call in a separate function so we can cleanup if we get an endon
	ReloadStandRunInternal();
	
	self notify("stopRunning");
	// notify "abort_reload" in case the reload didn't finish, maybe due to "movemode" notify. works with handleDropClip() in shared.gsc
	self notify("abort_reload");
	
	return true;
}

ReloadStandRunInternal()
{
	self endon("movemode");
	
	flagName = "reload_" + getUniqueFlagNameIndex();
	
	self setFlaggedAnimKnobAllRestart( flagName, %run_lowready_reload, %body, 1, 0.25 );
	
	self thread UpdateRunWeightsBiasForward(
		"stopRunning",
		%combatrun_forward,
		%run_lowready_B,
		%run_lowready_L,
		%run_lowready_R
	);
	animscripts\shared::DoNoteTracks( flagName );
}

runLoopIsNearBeginning()
{
	// there are actually 3 loops (left foot, right foot) in one animation loop.

	animfraction = self getAnimTime( %walk_and_run_loops );
	loopLength = getAnimLength( %run_lowready_F ) / 3.0;
	animfraction *= 3.0;
	if ( animfraction > 3 )
		animfraction -= 2.0;
	else if ( animfraction > 2 )
		animfraction -= 1.0;
	
	if ( animfraction < .15 / loopLength )
		return true;
	if ( animfraction > 1 - .3 / loopLength )
		return true;
	
	return false;
}


UpdateRunWeights(notifyString, frontAnim, backAnim, leftAnim, rightAnim)
{
	self endon("killanimscript");
	self endon(notifyString);
	
	if ( gettime() == self.a.scriptStartTime )
	{
		// our motion angle might change very quickly as we start to run, so reset the anim weights after one frame
		UpdateRunWeightsOnce( frontAnim, backAnim, leftAnim, rightAnim );
		wait .05;
	}
	
	for (;;)
	{
		UpdateRunWeightsOnce( frontAnim, backAnim, leftAnim, rightAnim );
		wait .2;
	}
}

UpdateRunWeightsOnce( frontAnim, backAnim, leftAnim, rightAnim )
{
	animWeights = animscripts\utility::QuadrantAnimWeights( self getMotionAngle() );
	self setanim(frontAnim, animWeights["front"], 0.2, 1 );
	self setanim(backAnim,  animWeights["back"] , 0.2, 1 );
	self setanim(leftAnim,  animWeights["left"] , 0.2, 1 );
	self setanim(rightAnim, animWeights["right"], 0.2, 1 );
}

// same as UpdateRunWeights but never lets the forward animation go below a weight of .2.
// good for "flagged" animations.
UpdateRunWeightsBiasForward(notifyString, frontAnim, backAnim, leftAnim, rightAnim)
{
	self endon("killanimscript");
	self endon(notifyString);

	for (;;)
	{
		animWeights = animscripts\utility::QuadrantAnimWeights( self getMotionAngle() );
		
		if ( animWeights["front"] < .2 )
			animWeights["front"] = .2;
		
		self setanim(frontAnim, animWeights["front"], 0.2, 1);
		self setanim(backAnim,  0.0                 , 0.2, 1);
		self setanim(leftAnim,  animWeights["left"] , 0.2, 1);
		self setanim(rightAnim, animWeights["right"], 0.2, 1);
		wait 0.2;
	}
}

// TODO Make this use the notetrack from the run animation playing.
MakeRunSounds ( notifyString )
{
	self endon("killanimscript");
	self endon(notifyString);
	for (;;)
	{
		wait .5;
		self playsound ("misc_step1");
		wait .5;
		self playsound ("misc_step2");
	}
}

// change our weapon while running if we want to and can
changeWeaponStandRun()
{
	// right now this only handles shotguns, but it could do other things too
	wantShotgun = (isdefined( self.wantShotgun ) && self.wantShotgun);
	usingShotgun = (weaponclass( self.weapon ) == "spread");
	if ( wantShotgun == usingShotgun )
		return false;
	
	if ( !isdefined( self.pathGoalPos ) || distanceSquared( self.origin, self.pathGoalPos ) < 256*256 )
		return false;

	if ( usingSidearm() )
		return false;
	assert( self.weapon == self.primaryweapon || self.weapon == self.secondaryweapon );
	
	if ( self.weapon == self.primaryweapon )
	{
		if ( !wantShotgun )
			return false;
		if ( weaponclass( self.secondaryweapon ) != "spread" )
			return false;
	}
	else
	{
		assert( self.weapon == self.secondaryweapon );
		
		if ( wantShotgun )
			return false;
		if ( weaponclass( self.primaryweapon ) == "spread" )
			return false;
	}
	
	// want to be running forward; otherwise we won't see the animation play!
	motionAngle = AngleClamp180( self getMotionAngle() );
	if ( abs( motionAngle ) > 25 )
		return false;

	if ( !runLoopIsNearBeginning() )
		return false;
	
	if ( wantShotgun )
		shotgunSwitchStandRunInternal( "shotgunPullout", %shotgun_CQBrun_pullout, "gun_2_chest", "none", self.secondaryweapon, "shotgun_pickup" );
	else
		shotgunSwitchStandRunInternal( "shotgunPutaway", %shotgun_CQBrun_putaway, "gun_2_back", "back", self.primaryweapon, "shotgun_pickup" );
	
	self notify("switchEnded");
	
	return true;
}

shotgunSwitchStandRunInternal( flagName, switchAnim, dropGunNotetrack, putGunOnTag, newGun, pickupNewGunNotetrack )
{
	self endon("movemode");
	
	self setFlaggedAnimKnobAllRestart( flagName, switchAnim, %body, 1, 0.25 );
	
	self thread animscripts\run::UpdateRunWeightsBiasForward(
		"switchEnded",
		%combatrun_forward,
		%run_lowready_B,
		%run_lowready_L,
		%run_lowready_R
	);
	
	self thread watchShotgunSwitchNotetracks( flagName, dropGunNotetrack, putGunOnTag, newGun, pickupNewGunNotetrack );
	
	animscripts\shared::DoNoteTracksForTimeIntercept( getAnimLength( switchAnim ) - 0.25, flagName, ::interceptNotetracksForWeaponSwitch );
}

interceptNotetracksForWeaponSwitch( notetrack )
{
	if ( notetrack == "gun_2_chest" || notetrack == "gun_2_back" )
		return true; // "don't do the default behavior for this notetrack"
}

watchShotgunSwitchNotetracks( flagName, dropGunNotetrack, putGunOnTag, newGun, pickupNewGunNotetrack )
{
	self endon("killanimscript");
	self endon("movemode");
	self endon("switchEnded");
	
	self waittillmatch( flagName, dropGunNotetrack );
	
	animscripts\shared::placeWeaponOn( self.weapon, putGunOnTag );
	self thread shotgunSwitchFinish( newGun );
	
	self waittillmatch( flagName, pickupNewGunNotetrack );
	self notify( "complete_weapon_switch" );
}

shotgunSwitchFinish( newGun )
{
	self endon( "death" );
	
	self waittill_any( "killanimscript", "movemode", "switchEnded", "complete_weapon_switch" );
	
	self.lastweapon = self.weapon;
	
	animscripts\shared::placeWeaponOn( newGun, "right" );
	assert( self.weapon == newGun ); // placeWeaponOn should have handled this
	
	// reset ammo (assume fully loaded weapon)
	self.bulletsInClip = weaponClipSize( self.weapon );
}

