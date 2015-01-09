#include animscripts\Combat_Utility;
#include animscripts\Utility;
#include animscripts\SetPoseMovement;
#using_animtree ("generic_human");

// prone is a bit of a misnomer - it means fighting from prone range,
// not necessarily prone

// FIXME BUG - prone guys start going prone within goal radius and land outside, causing them to get up and run back into radius and repeat - need to check before going prone.
ProneRangeCombat( changeReason )
{
    self trackScriptState( "ProneRangeCombat", changeReason );
	self endon("killanimscript");

	assertEX( isDefined ( changeReason ) , "Script state called without reason.");

	self thread ProneTurningThread(::ProneCombatThread, "kill ProneRangeCombat");
	
	timer = gettime();
	self waittill ("kill ProneRangeCombat");
	if (gettime() == timer)
		wait (0.05); // no time passed, needs a rewrite

	// transition back to combat - FIXME JBW decide on different states from here
	self thread animscripts\combat::main();
}



Set3FlaggedAnimKnobs(animFlag, animArray, weight, blendTime, rate)
{
	self SetAnimKnob(					animArray["left"],	weight, blendTime, rate);
	self SetFlaggedAnimKnob(animFlag,	animArray["middle"],weight, blendTime, rate);
	self SetAnimKnob(					animArray["right"],	weight, blendTime, rate);

	//UpdateCornerAim( animArray, angleArray, cornerYaw );
}

// Runs the actual prone combat thread, and handles turning during prone combat.
ProneTurningThread(threadToSpawn, killmeString)
{
	self endon ("killanimscript");
	self endon ("death");
	self endon (killmeString);

	self.a.usingProneLeftAndRight = false;
	if (isDefined(threadToSpawn))
		self thread [[threadToSpawn]]("kill ProneTurningThread children");

	// Detect when we want to turn, kill the combat thread, turn, and restart the thread.
	for (;;)
	{
		if (self.a.pose != "prone")
		{
			self OrientMode("face default");	// If we're not prone (yet), allow the code to keep turning us as it sees fit.
		}
		else
		{
			self OrientMode("face enemy");

			attackYaw = self.angles[1];
			if (hasEnemySightPos())
			{
				pos = getEnemySightPos();
				attackYaw = animscripts\utility::GetYaw(pos);
			}
				
			yawDelta = self.angles[1] - attackYaw;	// FYI self.desiredyaw does not give me the angle I want - it gives me the current angle.
			yawDelta = int(yawDelta+360) % 360;
			if ( yawDelta > 180 )
				yawDelta -= 360;
			if ( yawDelta > 0 )
			{
				if (self.a.usingProneLeftAndRight)
				{
					amount = yawDelta / 45.0;
					if (amount<0.01)
						amount = 0.01;
					else if (amount>0.99)
						amount = 0.99;
					// SetAnimKnob on one of them so that other animations can't interfere.
					self SetAnimKnob(%prone_straight, 1.0-amount, 0.1, 1);
					self SetAnim(%prone_right45, amount, 0.1, 1);
					self SetAnim(%prone_left45, 0.01, 0.1, 1);
				}
				if ( yawDelta > 45 )
				{
					//thread [[anim.println]]("Prone, turning right");#/
					self notify ("kill ProneTurningThread children");
					self setFlaggedAnimKnobRestart ("turn anim", %prone_turn_right, 1, 0.1, 1);
					self animscripts\shared::DoNoteTracks("turn anim");
					self UpdateProne(%prone_shootfeet_straight45up, %prone_shootfeet_straight45down, 1, 0.1, 1);
					//thread [[anim.println]]("Prone, finished turning right");#/
					if (isDefined(threadToSpawn))
						self thread [[threadToSpawn]]("kill ProneTurningThread children");
				}
			}
			else
			{
				if (self.a.usingProneLeftAndRight)
				{
					amount = yawDelta / -45;
					if (amount<0.01)
						amount = 0.01;
					else if (amount>0.99)
						amount = 0.99;
					// SetAnimKnob on one of them so that other animations can't interfere.
					self SetAnimKnob(%prone_straight, 1.0-amount, 0.1, 1);
					self SetAnim(%prone_left45, amount, 0.1, 1);
					self SetAnim(%prone_right45, 0.01, 0.1, 1);
				}
				if ( yawDelta < -45 )
				{
					//thread [[anim.println]]("Prone, turning left");#/
					self notify ("kill ProneTurningThread children");
					self setFlaggedAnimKnobRestart ("turn anim", %prone_turn_left, 1, 0.1, 1);
					self animscripts\shared::DoNoteTracks("turn anim");
					self UpdateProne(%prone_shootfeet_straight45up, %prone_shootfeet_straight45down, 1, 0.1, 1);
					//thread [[anim.println]]("Prone, finished turning left");#/
					if (isDefined(threadToSpawn))
						self thread [[threadToSpawn]]("kill ProneTurningThread children");
				}
			}
		}
		self thread WaitForNotify("Update prone aim", "Prone aim done waiting", "Prone aim done waiting");
		self thread WaitForTime(0.3, "Prone aim done waiting", "Prone aim done waiting");
		// If the notify is going to be sent later this frame you can get an infinite loop
		waittillframeend;
		self waittill ("Prone aim done waiting");
		lookForBetterCover();
	}
}


// This used to be the bulk of ProneRangeCombat
ProneCombatThread(killmeString)
{
	self endon ("killanimscript");
//	self endon (anim.scriptChange);
	self endon (killmeString);
	
	//("Entering prone::ProneCombatThread");#/
	wait 0;		// This prevents this thread from notifying before ProneTurningThread has got to a wait. 
//	while (self.a.desired_script == "combat")
	for (;;)
    {
		if ( !self isStanceAllowedWrapper("prone") )
		{
			//("Leaving prone::ProneCombatThread (prone not allowed)");#/
			self notify ("kill ProneRangeCombat");
			break;
		}

		isProne = self.a.pose == "prone";
		canShootFromProne = animscripts\utility::canShootEnemyFromPose( "prone", undefined, !isProne );
		canGoProne = CanGoProneHere(self.origin, self.angles[1]);
        if ( !canGoProne )
        {
			//("Leaving prone::ProneCombatThread (can't go prone or can't shoot from prone)");#/
			self notify ("kill ProneRangeCombat");
			break;
        }        

		if ( canShootFromProne )
		{
			ProneShootVolley();
			Reload(0);
		}
		else
		{
			Reload(.999);
			wait .05;
		}

        self.enemyDistanceSq = self GetClosestEnemySqDist();
        if (animscripts\utility::GetNodeType() != "Cover Prone" && self.enemyDistanceSq < anim.proneRangeSq ) 
        {
			//("Leaving prone::ProneCombatThread (enemy too close)");#/
			self notify ("kill ProneRangeCombat");
			break;
        }
    }
	scriptChange();
}

WaitForNotify(waitForString, notifyString, killmeString)
{
	self endon ("killanimscript");
	self endon ("death");
	self endon (killmeString);
	self waittill (waitForString);
	self notify (notifyString);
}

WaitForTime(time, notifyString, killmeString)
{
	self endon ("killanimscript");
	self endon ("death");
	self endon (killmeString);
	wait (time);
	self notify (notifyString);
}


CanDoProneCombat(origin, yaw)
{
	if (!self isStanceAllowedWrapper("prone"))
		return false;
	
	if (weaponAnims() == "pistol")
		return false;
	
    if ( MyGetEnemySqDist() < anim.proneRangeSq )
        return 0;
	
	// Do an early out based on canShootProne because checkProne does a lot if traces
	canShootProne = animscripts\utility::canShootEnemyFromPose ("prone");
	if(!canShootProne)
		return 0;
	
	// We already know canShootProne is true, so just return canFitProne
	return CanGoProneHere(origin, yaw);
}

CanGoProneHere(origin, yaw)
{
	alreadyProne = (self.a.pose == "prone");
	canFitProne = self checkProne(origin, yaw, alreadyProne);
	return canFitProne;
}


ProneShootVolley()
{
	self SetPoseMovement("prone","stop");
	shootanims["middle"]	= %prone_shoot_straight;
	shootanims["left"]		= %prone_shoot_left;
	shootanims["right"]		= %prone_shoot_right;
	autoshootanims["middle"]	= %prone_shoot_auto_straight;
	autoshootanims["left"]		= %prone_shoot_auto_left;
	autoshootanims["right"]		= %prone_shoot_auto_right;

	self animscripts\face::SetIdleFace(anim.aimface);
	self.a.usingProneLeftAndRight = true;
	self notify ("Update prone aim");	// This makes sure we're aiming the right way, since we were probably 
										// aiming straight ahead when we entered this thread.

//	self setanimknob(%prone_legsstraight, 1, 0.05, 1); // Didn't want to mess with prone hierarchy
	self setanimknob(%prone, 1, 0.15, 1);
	// Aim for a moment, just to add some variety.
	rand = randomfloat(1);
	self Set3FlaggedAnimKnobs("shootanim", shootanims, 1, 0.15, 0); // TODO - make this an aim anim.
//	self UpdateProne(%prone_shootfeet_straight45up, %prone_shootfeet_straight45down, 1, 0.1, 1);
	wait rand;
	
	// Update the sight accuracy against the player.  Should be called before the volley starts.
	self updatePlayerSightAccuracy();
	
	if (animscripts\weaponList::usingAutomaticWeapon())
	{
		self animscripts\face::SetIdleFace(anim.autofireface);
		self Set3FlaggedAnimKnobs("shootanim", autoshootanims, 1, 0.15, 0); // TODO - make this an aim anim.
//		self UpdateProne(%prone_shootfeet_straight45up, %prone_shootfeet_straight45down, 1, 0.1, 1);
		wait 0.2;

		animRate = animscripts\weaponList::autoShootAnimRate();
		self Set3FlaggedAnimKnobs("shootanim", autoshootanims, 1, 0.05, animRate);
//		self UpdateProne(%prone_shootfeet_straight45up, %prone_shootfeet_straight45down, 1, 0.1, 1);
		rand = randomint(8)+6;
//		enemyAngle = animscripts\utility::AbsYawToEnemy();
		for (i=0; i<rand /*&& enemyAngle<20*/; i++)
		{
			self waittillmatch ("shootanim", "fire");
			self shootEnemyWrapper();	
			self decrementBulletsInClip();
//			enemyAngle = animscripts\utility::AbsYawToEnemy();
		}
	}
	else if (animscripts\weaponList::usingSemiAutoWeapon())
	{
		self Set3FlaggedAnimKnobs("shootanim", shootanims, 1, 0.2, 0);
//		self UpdateProne(%prone_shootfeet_straight45up, %prone_shootfeet_straight45down, 1, 0.1, 1);
		wait 0.2;

		rand = randomint(3)+2;
//		enemyAngle = animscripts\utility::AbsYawToEnemy();
		for (i=0; i<rand /*&& enemyAngle<20*/; i++)
		{
			self Set3FlaggedAnimKnobs("shootanim", shootanims, 1, 0, 1);
//			self UpdateProne(%prone_shootfeet_straight45up, %prone_shootfeet_straight45down, 1, 0.1, 1);
			self shootEnemyWrapper();	
			self decrementBulletsInClip();
			shootTime = animscripts\weaponList::shootAnimTime();
			quickTime = animscripts\weaponList::waitAfterShot();
			wait quickTime;
			if (i<rand-1 && shootTime>quickTime)
				wait shootTime - quickTime;
//			enemyAngle = animscripts\utility::AbsYawToEnemy();
		}
	}
	else // Bolt action
	{
		Rechamber();	// In theory you will almost never need to rechamber here, 
											// because you will have done it somewhere smarter, like in cover.
		// Slowly blend in the first frame of the shoot instead of playing the transition.
		self Set3FlaggedAnimKnobs("shootanim", shootanims, 1, 0.2, 0);
//		self UpdateProne(%prone_shootfeet_straight45up, %prone_shootfeet_straight45down, 1, 0.1, 1);
		wait 0.2;

		self Set3FlaggedAnimKnobs("shootanim", shootanims, 1, 0, 1);
//		self UpdateProne(%prone_shootfeet_straight45up, %prone_shootfeet_straight45down, 1, 0.1, 1);
		self shootEnemyWrapper();	
		self decrementBulletsInClip();
		self.a.needsToRechamber = 1;
		quickTime = animscripts\weaponList::waitAfterShot();
		wait quickTime;
	}
	self.a.usingProneLeftAndRight = false;
}
