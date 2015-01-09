#include animscripts\SetPoseMovement;
#include animscripts\combat_utility;
#using_animtree ("generic_human");

hackangle()
{
	self endon("killanimscript");

	for (;;)
	{
		enemyAngle = animscripts\utility::GetYawToEnemy();
		self OrientMode ("face angle", enemyAngle);
		wait .05;
	}
}

main( )
{
	println("anim1");
	self endon("killanimscript");
	self endon("outoftruck");
	animscripts\utility::initialize("l33t truckride combat");

    	self trackScriptState( "l33t truckride combat", "becauseisaidso" );
    	thread hackangle();
	self OrientMode("face enemy");
	if(randomint(100) >50)
		nextaction = ("stand");
	else
		nextaction = ("crouch");

	for ( ;; )
	{
		// Nothing below will work if our gun is completely empty.
	        self SetPoseMovement("","stop");
	        Reload(0);
//	        if ( canShootstand && canStand &&
//	             ( !canShootCrouch || !canCrouch || ( dist < anim.standRangeSq )) )

		if(nextaction == ("stand"))
		{
			timer = gettime()+randomint(2000)+2000;
			while(timer > gettime())
		        {

			        self SetPoseMovement("stand","stop");
//				self animscripts\aim::aim();
				success = LocalShootVolley(0);
		//			if (!success)
		//				self interruptPoint();	// We couldn't shoot for some reason, so now would be a good time to run for cover.
				nextaction = ("crouch");

		        }
		}
		else if(nextaction == ("crouch"))
		{
		        timer = gettime()+randomint(2000)+2000;
		        while(timer > gettime())
		        {
				/#thread [[anim.println]]("ExposedCombat - Crouched combat");#/
				self SetPoseMovement("crouch","stop");

//				self animscripts\aim::aim();
				success = ShootVolley();
				if (!success)
					continue;
				nextaction = ("stand");
		        }

		}
	}
}


LocalShootVolley(completeLastShot, forceShoot, posOverrideEntity )
{
	if (!isDefined(forceShoot))
	{
		forceShoot = "dontForceShoot";
	}
	self animscripts\shared::placeWeaponOn( self.primaryweapon, "none" );
	if (self.a.pose == "stand")
	{
		anim_autofire = %stand_shoot_auto;
		anim_semiautofire = %stand_shoot;
		anim_boltfire = %stand_shoot;
	}
	else // assume crouch
	{
		anim_autofire = %crouch_shoot_auto;
		anim_semiautofire = %crouch_shoot;
		anim_boltfire = %crouch_shoot;
	}

 	// Make sure the aim and shoot animations are ready to play
	self setanimknob(%shoot, 1, .15, 1);


	if (animscripts\weaponList::usingAutomaticWeapon())
	{
		self animscripts\face::SetIdleFace(anim.autofireface);
		self setflaggedanimknob("animdone", anim_autofire, 1, .15, 0);
		wait 0.20;
		animRate = animscripts\weaponList::autoShootAnimRate();
		self setFlaggedAnimKnobRestart("shootdone", anim_autofire, 1, .05, animRate);
		numShots = randomint(8) + 6;
		enemyAngle = animscripts\utility::AbsYawToEnemy();
		/#thread [[anim.locspam]]("c16a");#/
		for (i = 0; (i<numShots && self.bulletsInClip>0 && enemyAngle<20); i ++)
		{
			self waittillmatch ("shootdone", "fire");
			if ( isDefined ( posOverrideEntity ) )
			{
				if (isSentient(posOverrideEntity))
				{
					pos = posOverrideEntity GetEye();
				}
				else
				{
					pos = posOverrideEntity.origin;
				}
				self shoot ( 1 , pos );
			}
			else
				self shoot();
			self decrementBulletsInClip();
			enemyAngle = animscripts\utility::AbsYawToEnemy();
		}
		if (completeLastShot)
			wait animscripts\weaponList::waitAfterShot();
		self notify ("stopautofireFace");
	}
	else if (animscripts\weaponList::usingSemiAutoWeapon())
	{

		self animscripts\face::SetIdleFace(anim.aimface);

		self setanimknob(anim_semiautofire, 1, .15, 0);
		wait 0.2;

		rand = randomint(2) + 2;
		for (i = 0; (i<rand && self.bulletsInClip>0); i ++)
		{
			self setFlaggedAnimKnobRestart("shootdone", anim_semiautofire, 1, 0, 1);
			if ( isDefined ( posOverrideEntity ) )
	           	 	self shoot ( 1 , posOverrideEntity . origin );
			else
				self shoot();
			self decrementBulletsInClip();
			/#thread [[anim.locspam]]("c17.1b");#/
			shootTime = animscripts\weaponList::shootAnimTime();
			quickTime = animscripts\weaponList::waitAfterShot();
			wait quickTime;
			if ( ( (completeLastShot) || (i<rand-1) ) && shootTime>quickTime)
				wait shootTime - quickTime;
		}
	}
	else // Bolt action
	{
//		/#thread [[anim.println]](" ShootVolley: bolt-action fire, "+self.bulletsInClip+" rounds in clip, enemyDistanceSq is "+self.enemyDistanceSq+".");#/
		Rechamber();	// In theory you will almost never need to rechamber here, because you will have done
						// it somewhere smarter, like in cover.
		self animscripts\face::SetIdleFace(anim.aimface);
		// Slowly blend in the first frame of the shoot instead of playing the transition.
		self setanimknob(anim_boltfire, 1, .15, 0);

		wait 0.2;

		self setFlaggedAnimKnobRestart("shootdone", anim_boltfire, 1, 0, 1);
		if ( isDefined ( posOverrideEntity ) )
			self shoot ( 1 , posOverrideEntity . origin );
		else
			self shoot();
		self.a.needsToRechamber = 1;
		self decrementBulletsInClip();
		shootTime = animscripts\weaponList::shootAnimTime();
		quickTime = animscripts\weaponList::waitAfterShot();
		wait quickTime;
	}
	self setanim(%shoot,0.0,0.2,1); // cleanup and turn down shoot knob
	return 1;
}

















