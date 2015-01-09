#include animscripts\Utility;
#include maps\_gameskill;
#include maps\_utility;
#include common_scripts\utility;
#include animscripts\SetPoseMovement;
#using_animtree ("generic_human");

EnemiesWithinStandingRange()
{
	enemyDistanceSq = self MyGetEnemySqDist();
	return ( enemyDistanceSq < anim.standRangeSq );
}


MyGetEnemySqDist()
{
	//prof_begin( "MyGetEnemySqDist" );
    dist = self GetClosestEnemySqDist();
	if (!isDefined(dist))
		dist = 100000000000;
		
	//prof_end( "MyGetEnemySqDist" );
    return dist;
}


getTargetAngleOffset(target)
{
	pos = self getshootatpos() + (0,0,-3); // compensate for eye being higher than gun
	dir = (pos[0] - target[0], pos[1] - target[1], pos[2] - target[2]);
	dir = VectorNormalize( dir );
	fact = dir[2] * -1;
//	println ("offset "  + fact);
	return fact;
}

getSniperBurstDelayTime()
{
	return randomFloatRange( anim.min_sniper_burst_delay_time, anim.max_sniper_burst_delay_time );
}

getRemainingBurstDelayTime()
{
	timeSoFar = (gettime() - self.a.lastShootTime) / 1000;
	delayTime = getBurstDelayTime();
	if ( delayTime > timeSoFar )
		return delayTime - timeSoFar;
	return 0;
}
getBurstDelayTime()
{
	if ( self usingSidearm() )
		return randomFloatRange( .15, .55 );
	else if ( self usingShotgun() )
		return randomFloatRange( 1.0, 1.7 );
	else if ( self isSniper() )
		return getSniperBurstDelayTime();
	else if ( self.fastBurst )
		return randomFloatRange( .1, .35 );
	else
		return randomFloatRange( .4, .9 );
}
burstDelay()
{
	if ( self.bulletsInClip )
	{
		if ( self.shootStyle == "full" && !self.fastBurst )
		{
			if ( self.a.lastShootTime == gettime() )
				wait .05;
			return;
		}

		delayTime = getRemainingBurstDelayTime();
		if ( delayTime )
			wait delayTime;
	}
}

cheatAmmoIfNecessary()
{
	assert( !self.bulletsInClip );
	
	if ( !isdefined( self.enemy ) )
		return false;
	
	if ( self.team != "allies" )
	{
		// cheat and finish off the player if we can.
		if ( !isPlayer( self.enemy ) )
			return false;
		//if ( self.enemy.health > self.enemy.maxHealth * level.healthOverlayCutoff )
		//	return false;
		if ( weaponClipSize( self.weapon ) < 15 )
			return false;
		if ( flag("player_is_invulnerable") )
			return false;
	}
	
	if ( self weaponAnims() == "pistol" )
		return false;
	if ( self weaponAnims() == "rocketlauncher" )
		return false;
	
	if ( isDefined( self.nextCheatTime ) && gettime() < self.nextCheatTime )
		return false;
	
	if ( !self canSee( self.enemy ) )
		return false;
	
	if ( self isCQBWalking() )
		self.bulletsInClip = weaponClipSize( self.weapon );
	else
		self.bulletsInClip = 10;
	
	if ( self.bulletsInClip > weaponClipSize( self.weapon ) )
		self.bulletsInClip = weaponClipSize( self.weapon );
	
	self.nextCheatTime = gettime() + 4000;
	
	return true;
}

shootUntilShootBehaviorChange()
{
	self endon("shoot_behavior_change");
	self endon("stopShooting");
	
	if ( self weaponAnims() == "rocketlauncher" || self isSniper() )
	{
		if ( isDefined( self.enemy ) && self.enemy != level.player && isSentient( self.enemy ) && distanceSquared( level.player.origin, self.enemy.origin ) < 384*384 )
			self.enemy animscripts\battlechatter_ai::addThreatEvent( "infantry", self, 1.0 );
			
		if ( self weaponAnims() == "rocketlauncher" && isSentient( self.enemy ) )
			wait ( randomFloat( 2.0 ) );
	}
	
	while(1)
	{
		burstDelay(); // waits only if necessary
		
		if ( self.shootStyle == "full" )
		{
			self FireUntilOutOfAmmo( animArray( "fire" ), false, animscripts\shared::decideNumShotsForFull() );
		}
		else if ( self.shootStyle == "burst" || self.shootStyle == "single" || self.shootStyle == "semi" )
		{
			numShots = 1;
			if ( self.shootStyle == "burst" || self.shootStyle == "semi" )
				numShots = animscripts\shared::decideNumShotsForBurst();	
				
			if ( numShots == 1 )
				self FireUntilOutOfAmmo( animArrayPickRandom( "single" ), true, numShots );
			else
				self FireUntilOutOfAmmo( animArray( self.shootStyle + numShots ), true, numShots );
		}
		else
		{
			assert( self.shootStyle == "none" );
			self waittill( "hell freezes over" ); // waits for the endons to happen
		}

		if ( !self.bulletsInClip )
			break;
	}
}

getUniqueFlagNameIndex()
{
	anim.animFlagNameIndex++;
	return anim.animFlagNameIndex;
}

FireUntilOutOfAmmo( fireAnim, stopOnAnimationEnd, maxshots )
{
	animName = "fireAnim_" + getUniqueFlagNameIndex();
	
	//prof_begin("FireUntilOutOfAmmo");

	// reset our accuracy as we aim
	maps\_gameskill::resetMissTime();
	
	// first, wait until we're aimed right
	while( !aimedAtShootEntOrPos() )
		wait .05;
		
	//prof_begin("FireUntilOutOfAmmo");		
	
	
	self setAnim( %add_fire, 1, .1, 1 );
	
	rate = randomfloatrange( 0.3, 3.0 );
	if ( self.shootStyle == "full" || self.shootStyle == "burst" )
		rate = animscripts\weaponList::autoShootAnimRate();
	else if ( isdefined( self.shootEnt ) && isdefined( self.shootEnt.magic_bullet_shield ) )
		rate = 0.25;
	
	self setFlaggedAnimKnobRestart( animName, fireAnim, 1, .2, rate );
	
	// Update the sight accuracy against the player.  Should be called before the volley starts.
	self updatePlayerSightAccuracy();

	//prof_end("FireUntilOutOfAmmo");

	FireUntilOutOfAmmoInternal( animName, fireAnim, stopOnAnimationEnd, maxshots );
	
	self clearAnim( %add_fire, .2 );
}

FireUntilOutOfAmmoInternal( animName, fireAnim, stopOnAnimationEnd, maxshots )
{
	self endon("enemy"); // stop shooting if our enemy changes, because we have to reset our accuracy and stuff
	// stop shooting if the player becomes invulnerable, so we will call resetAccuracyAndPause again
	if ( isPlayer( self.enemy ) && (self.shootStyle == "full" || self.shootStyle == "semi") )
		level endon("player_becoming_invulnerable");
	
	if ( stopOnAnimationEnd )
	{
		self thread NotifyOnAnimEnd( animName, "fireAnimEnd" );
		self endon( "fireAnimEnd" );
	}
	
	if ( !isdefined( maxshots ) )
		maxshots = -1;
	
	numshots = 0;
	
	hasFireNotetrack = animHasNoteTrack( fireAnim, "fire" );
	
	usingRocketLauncher = (weaponClass( self.weapon ) == "rocketlauncher");
	
	while(1)
	{
		if ( hasFireNotetrack )
			self waittillmatch( animName, "fire" );
		
		//prof_begin("FireUntilOutOfAmmoInternal");
		if ( numshots == maxshots ) // note: maxshots == -1 if no limit
			break;
		
		if ( !self.bulletsInClip )
		{
			if ( !cheatAmmoIfNecessary() )
				break;
		}
		
		if ( aimedAtShootEntOrPos() )
		{
			self shootAtShootEntOrPos();

			assertex( self.bulletsInClip >= 0, self.bulletsInClip );
			if ( isPlayer( self.enemy ) && flag("player_is_invulnerable") )
			{
				if ( randomint(3) == 0 )
					self.bulletsInClip--;
			}
			else
			{
				self.bulletsInClip--;
			}
			
			if ( usingRocketLauncher )
			{
				self.a.rockets--;
				if ( self.weapon == "rpg" )
				{
					self hidepart("tag_rocket");
					self.a.rocketVisible = false;
				}
			}
		}
		numshots++;
		
		self thread shotgunPumpSound( animName );
		
		if ( self.fastBurst && numshots == maxshots )
			break;
		
		//prof_end("FireUntilOutOfAmmoInternal");
	
		if ( !hasFireNotetrack )
			self waittillmatch( animName, "end" );
	}
	
	if ( stopOnAnimationEnd )
		self notify( "fireAnimEnd" ); // stops NotifyOnAnimEnd()
}

aimedAtShootEntOrPos()
{
	//prof_begin( "aimedAtShootEntOrPos" );
	if ( !isdefined( self.shootPos ) )
	{
		assert( !isdefined( self.shootEnt ) );
		
		//prof_end( "aimedAtShootEntOrPos" );
		return true;
	}
	
	weaponAngles = self gettagangles("tag_weapon");
	anglesToShootPos = vectorToAngles( self.shootPos - self gettagorigin("tag_weapon") );
	
	absyawdiff = AbsAngleClamp180( weaponAngles[1] - anglesToShootPos[1] );
	if ( absyawdiff > self.aimThresholdYaw )
	{
		if ( distanceSquared( self getShootAtPos(), self.shootPos ) > 64*64 || absyawdiff > 45 )
		{
			//prof_end( "aimedAtShootEntOrPos" );
			return false;
		}
	}
	
	//prof_end( "aimedAtShootEntOrPos" );
	return AbsAngleClamp180( weaponAngles[0] - anglesToShootPos[0] ) <= self.aimThresholdPitch;
}

NotifyOnAnimEnd( animNotify, endNotify )
{
	self endon("killanimscript");
	self endon( endNotify );
	self waittillmatch( animNotify, "end" );
	self notify( endNotify );
}

shootAtShootEntOrPos()
{
	//prof_begin("shootAtShootEntOrPos");

	if ( isdefined( self.shootEnt ) )
	{
		if ( isDefined( self.enemy ) && self.shootEnt == self.enemy )
			self shootEnemyWrapper();
		
		// it's possible that shootEnt isn't our enemy, which was probably caused by our enemy changing but shootEnt not being updated yet.
		// we don't want to shoot directly at shootEnt because if our accuracy is 0 we shouldn't hit it perfectly.
		// In retrospect, the existance of self.shootEnt was a bad idea and self.enemy should probably have just been used.
		//else
		//	self shootPosWrapper( self.shootEnt getShootAtPos() );
	}
	else
	{
		// if self.shootPos isn't defined, "shoot_behavior_change" should
		// have been notified and we shouldn't be firing anymore
		assert( isdefined( self.shootPos ) );
		
		self shootPosWrapper( self.shootPos );
	}

	//prof_end("shootAtShootEntOrPos");
}

showRocket()
{
	if ( self.weapon != "rpg" )
		return;
	
	self.a.rocketVisible = true;
	self notify("showing_rocket");
}

showRocketWhenReloadIsDone()
{
	if ( self.weapon != "rpg" )
		return;
	
	self endon("death");
	self endon("showing_rocket");
	self waittill("killanimscript");
	
	self showRocket();
}

decrementBulletsInClip()
{
	// we allow this to happen even when bulletsinclip is zero,
	// because sometimes we want to shoot even if we're out of ammo,
	// like when we've already started a blind fire animation.
	if ( self.bulletsInClip )
		self.bulletsInClip--;
}

shotgunPumpSound( animName )
{
	if ( !self usingShotgun() )
		return;
	
	self endon("killanimscript");
	
	self notify("shotgun_pump_sound_end");
	self endon("shotgun_pump_sound_end");
	
	self thread stopShotgunPumpAfterTime( 2.0 );
	
	self waittillmatch( animName, "rechamber" );
	
	self playSound( "ai_shotgun_pump" );
	
	self notify("shotgun_pump_sound_end");
}

stopShotgunPumpAfterTime( timer )
{
	self endon("killanimscript");
	self endon("shotgun_pump_sound_end");
	wait timer;
	self notify("shotgun_pump_sound_end");
}

// Rechambers the weapon if appropriate
Rechamber(isExposed)
{
	// obsolete...
}

// Returns true if character has less than thresholdFraction of his total bullets in his clip.  Thus, a value 
// of 1 would always reload, 0 would only reload on an empty clip.
NeedToReload( thresholdFraction )
{
	if ( isdefined( self.noreload ) )
	{
		assertex( self.noreload, ".noreload must be true or undefined" );
		if ( self.bulletsinclip < weaponClipSize( self.weapon ) * 0.5 )
			self.bulletsinclip = int( weaponClipSize( self.weapon ) * 0.5 );
		return false;
	}

	if ( self.weapon == "none" )
		return false;
	
	if ( self.bulletsInClip <= weaponClipSize( self.weapon ) * thresholdFraction )
	{
		if ( thresholdFraction == 0 )
		{
			if ( cheatAmmoIfNecessary() )
				return false;
		}
		
		return true;
	}
	return false;
}

// Put the gun back in the AI's hand if he cuts off his weapon throw down animation
putGunBackInHandOnKillAnimScript()
{
	self endon ( "weapon_switch_done" );
	self endon ( "death" );
	
	self waittill( "killanimscript" );
	animscripts\shared::placeWeaponOn( self.primaryweapon, "right" );
}

Reload( thresholdFraction, optionalAnimation )
{
	self endon("killanimscript");

	if ( !NeedToReload( thresholdFraction ) )
		return false;
		
	//prof_begin( "Reload" );

	self.a.Alertness = "casual";

	self animscripts\battleChatter_ai::evaluateReloadEvent();
	self animscripts\battleChatter::playBattleChatter();

	if ( isDefined( optionalAnimation ) )
	{
		self setFlaggedAnimKnobAll( "reloadanim", optionalAnimation, %body, 1, .1, 1 );
		animscripts\shared::DoNoteTracks( "reloadanim" );
		self animscripts\weaponList::RefillClip();	// This should be in the animation as a notetrack in theory.
		self.a.needsToRechamber = 0;
	}
	else
	{
		if (self.a.pose == "prone")
		{
			self setFlaggedAnimKnobAll("reloadanim",%reload_prone_rifle, %body, 1, .1, 1);
			self UpdateProne(%prone_legs_up, %prone_legs_down, 1, 0.1, 1);
		}
		else 
		{
			println ("Bad anim_pose in combat::Reload");
			//prof_end( "Reload" );
			wait 2;
			return;
		}
		animscripts\shared::DoNoteTracks("reloadanim");
		animscripts\weaponList::RefillClip();	// This should be in the animation as a notetrack in most instances.
		self.a.needsToRechamber = 0;
		self clearanim(%upperbody, .1);		// Only needed for the upper body running reload.
	}

	//prof_end( "Reload" );
	return true;
}

getGrenadeThrowOffset( throwAnim )
{
	//prof_begin( "getGrenadeThrowOffset" );
	offset = (0, 0, 64);
	
	if ( isdefined( throwAnim ) )
	{
		// generated with scr_testgrenadethrows in combat.gsc
		if      ( throwAnim == %exposed_grenadethrowb ) offset = (41.5391, 7.28883, 72.2128);
		else if ( throwAnim == %exposed_grenadethrowc ) offset = (34.8849, -4.77048, 74.0488);
		else if ( throwAnim == %corner_standl_grenade_a ) offset = (41.605, 6.80107, 81.4785);
		else if ( throwAnim == %corner_standl_grenade_b ) offset = (24.1585, -14.7221, 29.2992);
		else if ( throwAnim == %cornercrl_grenadea ) offset = (25.8988, -10.2811, 30.4813);
		else if ( throwAnim == %cornercrl_grenadeb ) offset = (24.688, 45.0702, 64.377);
		else if ( throwAnim == %corner_standr_grenade_a ) offset = (37.1254, -32.7053, 76.5745);
		else if ( throwAnim == %corner_standr_grenade_b ) offset = (19.356, 15.5341, 16.5036);
		else if ( throwAnim == %cornercrr_grenadea ) offset = (39.8857, 5.92472, 24.5878);
		else if ( throwAnim == %covercrouch_grenadea ) offset = (-1.6363, -0.693674, 60.1009);
		else if ( throwAnim == %covercrouch_grenadeb ) offset = (-1.6363, -0.693674, 60.1009);
		else if ( throwAnim == %coverstand_grenadea ) offset = (10.8573, 7.12614, 77.2356);
		else if ( throwAnim == %coverstand_grenadeb ) offset = (19.1804, 5.68214, 73.2278);
		else if ( throwAnim == %prone_grenade_a ) offset = (12.2859, -1.3019, 33.4307);
	}
	
	if ( offset[2] == 64 )
	{
		if ( isdefined( throwAnim ) )
			println( "^1Warning: undefined grenade throw animation used; hand offset unknown" );
		else
			println( "^1Warning: grenade throw animation ", throwAnim, " has no recorded hand offset" );
	}
	
	//prof_end( "getGrenadeThrowOffset" );
	return offset;
}

// this function is called from maps\_utility::ThrowGrenadeAtPlayerASAP
ThrowGrenadeAtPlayerASAP_combat_utility()
{
	if ( anim.numGrenadesInProgressTowardsPlayer == 0 )
	{
		anim.grenadeTimers["player_fraggrenade"] = 0;
		anim.grenadeTimers["player_flash_grenade"] = 0;
	}
	anim.throwGrenadeAtPlayerASAP = true;
	
	/#
	enemies = getaiarray("axis");
	if ( enemies.size == 0 )
		return;
	numwithgrenades = 0;
	for ( i = 0; i < enemies.size; i++ )
	{
		if ( enemies[i].grenadeammo > 0 )
			return;
	}
	println("^1Warning: called ThrowGrenadeAtPlayerASAP, but no enemies have any grenadeammo!");
	#/
}

setActiveGrenadeTimer( throwingAt )
{
	if ( isPlayer( throwingAt ) )
		self.activeGrenadeTimer = "player_" + self.grenadeWeapon;
	else
		self.activeGrenadeTimer = "AI_" + self.grenadeWeapon;
	
	assert( isdefined( anim.grenadeTimers[self.activeGrenadeTimer] ) );
}

considerChangingTarget( throwingAt )
{
	//prof_begin( "considerChangingTarget" );
	
	if ( !isPlayer( throwingAt ) && self.team == "axis" )
	{
		if ( gettime() < anim.grenadeTimers[self.activeGrenadeTimer] )
		{
			if ( level.player.ignoreme )
			{
				//prof_end( "considerChangingTarget" );
				return throwingAt;
			}
				
			// check if player threatbias is set to be ignored by self
			myGroup = self getthreatbiasgroup();
			playerGroup = level.player getthreatbiasgroup();
			
			if ( myGroup != "" && playerGroup != "" && getThreatBias( playerGroup, myGroup ) < -10000 )
			{
				//prof_end( "considerChangingTarget" );
				return throwingAt;
			}
			
			
			// can't throw at an AI right now anyway.
			// check if the player is an acceptable target (be careful not to be aware of him when we wouldn't know about him)
			if ( self canSee( level.player ) || (isAI( throwingAt ) && throwingAt canSee( level.player )) )
			{
				if ( isdefined( self.covernode ) )
				{
					angles = VectorToAngles( level.player.origin - self.origin );
					yawDiff =  AngleClamp180( self.covernode.angles[1] - angles[1] );
				}
				else
				{
					yawDiff = self GetYawToSpot( level.player.origin );
				}
				
				if ( abs( yawDiff ) < 60 )
				{
					throwingAt = level.player;
					self setActiveGrenadeTimer( throwingAt );
				}
			}
		}
	}
	
	//prof_end( "considerChangingTarget" );
	return throwingAt;
}

usingPlayerGrenadeTimer()
{
	return self.activeGrenadeTimer == "player_" + self.grenadeWeapon;
}

setGrenadeTimer( grenadeTimer, newValue )
{
	oldValue = anim.grenadeTimers[ grenadeTimer ];
	anim.grenadeTimers[ grenadeTimer ] = max( newValue, oldValue );
}

getDesiredGrenadeTimerValue()
{
	nextGrenadeTimeToUse = undefined;
	if ( self usingPlayerGrenadeTimer() )
	{
		nextGrenadeTimeToUse = gettime() + anim.playerGrenadeBaseTime + randomint(anim.playerGrenadeRangeTime);
	}
	else
	{
		nextGrenadeTimeToUse = gettime() + 40000 + randomint(60000);
	}
	return nextGrenadeTimeToUse;
}

// a "double" grenade is when 2 grenades land at the player's feet at once.
// we do this sometimes on harder difficulty modes.
mayThrowDoubleGrenade()
{
	assert( self.activeGrenadeTimer == "player_fraggrenade" );
	if ( player_died_recently() )
		return false;

	if ( !anim.double_grenades_allowed )
		return false;
	
	// if it hasn't been long enough since the last double grenade, don't do it
	if ( gettime() < anim.grenadeTimers[ "player_double_grenade" ] )
		return false;
	
	// if no one's started throwing a grenade recently, we can't do it
	if ( gettime() > anim.lastFragGrenadeToPlayerStart + 3000 )
		return false;
	
	return anim.numGrenadesInProgressTowardsPlayer < 2;
}

myGrenadeCoolDownElapsed()
{
	if ( player_died_recently() )
		return false;
	
	return ( gettime() >= self.a.nextGrenadeTryTime );
}

grenadeCoolDownElapsed()
{
	if (self.script_forcegrenade == 1)
		return true;

	if ( !myGrenadeCoolDownElapsed() )
		return false;
	
	if ( gettime() >= anim.grenadeTimers[self.activeGrenadeTimer] )
		return true;
	
	if ( self.activeGrenadeTimer == "player_fraggrenade" )
		return mayThrowDoubleGrenade();
	
	return false;
}

isGrenadePosSafe( throwingAt, destination )
{
	if ( isdefined( anim.throwGrenadeAtPlayerASAP ) && self usingPlayerGrenadeTimer() )
		return true;

	//prof_begin( "isGrenadePosSafe" );
	
	distanceThreshold = 200;
	if ( self.grenadeWeapon == "flash_grenade" )
		distanceThreshold = 512;
	distanceThresholdSq = distanceThreshold * distanceThreshold;
	
	closest = undefined;
	closestdist = 100000000;
	secondclosest = undefined;
	secondclosestdist = 100000000;
	
	for ( i = 0; i < self.squad.members.size; i++ )
	{
		if ( !isalive( self.squad.members[i] ) )
			continue;
		dist = distanceSquared( self.squad.members[i].origin, destination );
		if ( dist > distanceThresholdSq )
			continue;
		if ( dist < closestdist )
		{
			secondclosestdist = closestdist;
			secondclosest = closest;
			closestdist = dist;
			closest = self.squad.members[i];
		}
		else if ( dist < secondclosestdist )
		{
			secondclosestdist = dist;
			secondclosest = self.squad.members[i];
		}
	}
	
	if ( isdefined( closest ) && sightTracePassed( closest getEye(), destination, false, undefined ) )
	{
		//prof_end( "isGrenadePosSafe" );	
		return false;
	}

	if ( isdefined( secondclosest ) && sightTracePassed( closest getEye(), destination, false, undefined ) )
	{
		//prof_end( "isGrenadePosSafe" );	
		return false;
	}
	
	//prof_end( "isGrenadePosSafe" );	
	return true;
}

/#

printGrenadeTimers()
{
	level notify("stop_printing_grenade_timers");
	level endon("stop_printing_grenade_timers");
	
	x = 40;
	y = 40;
	
	level.grenadeTimerHudElem = [];
	
	keys = getArrayKeys( anim.grenadeTimers );
	for ( i = 0; i < keys.size; i++ )
	{
		textelem = newHudElem();
		textelem.x = x;
		textelem.y = y;
		textelem.alignX = "left";
		textelem.alignY = "top";
		textelem.horzAlign = "fullscreen";
		textelem.vertAlign = "fullscreen";
		textelem setText( keys[i] );
		
		bar = newHudElem();
		bar.x = x + 110;
		bar.y = y + 2;
		bar.alignX = "left";
		bar.alignY = "top";
		bar.horzAlign = "fullscreen";
		bar.vertAlign = "fullscreen";
		bar setshader( "black", 1, 8 );
		
		textelem.bar = bar;
		textelem.key = keys[i];
		
		y += 10;
		
		level.grenadeTimerHudElem[keys[i]] = textelem;
	}
	
	while(1)
	{
		wait .05;
		
		for ( i = 0; i < keys.size; i++ )
		{
			timeleft = (anim.grenadeTimers[keys[i]] - gettime()) / 1000;
			
			width = max( timeleft * 4, 1 );
			width = int( width );
			
			bar = level.grenadeTimerHudElem[keys[i]].bar;
			bar setShader( "black", width, 8 );
		}
	}
}

destroyGrenadeTimers()
{
	if ( !isdefined( level.grenadeTimerHudElem ) )
		return;
	keys = getArrayKeys( anim.grenadeTimers );
	for ( i = 0; i < keys.size; i++ )
	{
		level.grenadeTimerHudElem[keys[i]].bar destroy();
		level.grenadeTimerHudElem[keys[i]] destroy();
	}
}

grenadeTimerDebug()
{
	if ( getdvar("scr_grenade_debug") == "" )
		setdvar("scr_grenade_debug", "0");
	
	while(1)
	{
		while(1)
		{
			if ( getdebugdvar("scr_grenade_debug") != "0" )
				break;
			wait .5;
		}
		thread printGrenadeTimers();
		while(1)
		{
			if ( getdebugdvar("scr_grenade_debug") == "0" )
				break;
			wait .5;
		}
		level notify("stop_printing_grenade_timers");
		destroyGrenadeTimers();
	}
}

grenadeDebug( state, duration, showMissReason )
{
	if ( getdebugdvar("scr_grenade_debug") == "0" )
		return;
	
	self notify("grenade_debug");
	self endon("grenade_debug");
	self endon("killanimscript");
	self endon("death");
	endtime = gettime() + 1000 * duration;
	
	while( gettime() < endtime )
	{
		print3d( self getShootAtPos() + (0,0,10), state );
		if ( isdefined( showMissReason ) && isdefined( self.grenadeMissReason ) )
			print3d( self getShootAtPos() + (0,0,0), "Failed: " + self.grenadeMissReason );
		else if ( isdefined( self.activeGrenadeTimer ) )
			print3d( self getShootAtPos() + (0,0,0), "Timer: " + self.activeGrenadeTimer );
		wait .05;
	}
}

setGrenadeMissReason( reason )
{
	if ( getdebugdvar("scr_grenade_debug") == "0" )
		return;
	self.grenadeMissReason = reason;
}
#/

TryGrenadePosProc( throwingAt, destination, optionalAnimation, armOffset )
{
	// Dont throw a grenade right near you or your buddies
	if ( !isGrenadePosSafe( throwingAt, destination ) )
		return false;
	else if ( distanceSquared( self.origin, destination ) < 200 * 200 )
		return false;
	
	//prof_begin( "TryGrenadePosProc" );	
	
	trace = physicsTrace( destination + (0,0,1), destination + (0,0,-500) );
	if ( trace == destination + (0,0,-500) )
		return false;
	trace += (0,0,.1); // ensure just above ground
	
	//prof_end( "TryGrenadePosProc" );	

	return TryGrenadeThrow( throwingAt, trace, optionalAnimation, armOffset );
}

TryGrenade( throwingAt, optionalAnimation )
{
	if ( self.weapon=="mg42" || self.grenadeammo <= 0 )
		return false;
	
	self setActiveGrenadeTimer( throwingAt );
	
	throwingAt = considerChangingTarget( throwingAt );
	
	if ( !grenadeCoolDownElapsed() )
		return false;
	
	/#
	self thread grenadeDebug( "Tried grenade throw", 4, true );
	#/

	armOffset = getGrenadeThrowOffset( optionalAnimation );
	
	if ( isdefined( self.enemy ) && throwingAt == self.enemy )
	{
		if ( self.grenadeWeapon == "flash_grenade" && !shouldThrowFlashBangAtEnemy() )
			return false;
		
		if ( self canSeeEnemyFromExposed() )
		{
			if ( !isGrenadePosSafe( throwingAt, throwingAt.origin ) )
			{
				/# self setGrenadeMissReason( "Teammates near target" ); #/
				return false;
			}
			return TryGrenadeThrow( throwingAt, undefined, optionalAnimation, armOffset );
		}
		else if ( self canSuppressEnemyFromExposed() )
		{
			return TryGrenadePosProc( throwingAt, self getEnemySightPos(), optionalAnimation, armOffset );
		}
		else
		{
			// hopefully we can get through a grenade hint or something
			if ( !isGrenadePosSafe( throwingAt, throwingAt.origin ) )
			{
				/# self setGrenadeMissReason( "Teammates near target" ); #/
				return false;
			}
			return TryGrenadeThrow( throwingAt, undefined, optionalAnimation, armOffset );
		}
		
		/# self setGrenadeMissReason( "Don't know where to throw" ); #/
		return false; // didn't know where to throw!
	}
	else
	{
		return TryGrenadePosProc( throwingAt, throwingAt.origin, optionalAnimation, armOffset );
	}
}

TryGrenadeThrow( throwingAt, destination, optionalAnimation, armOffset )
{
	// no AI grenade throws in the first 10 seconds, bad during black screen
	if ( gettime() < 10000 )
	{
		/# self setGrenadeMissReason( "First 10 seconds of game" ); #/
		return false;
	}
	
	//prof_begin( "TryGrenadeThrow" );
	
	if (isDefined(optionalAnimation))
	{
		throw_anim = optionalAnimation;
		// Assume armOffset and gunHand are defined whenever optionalAnimation is.
		gunHand = self.a.gunHand;	// Actually we don't want gunhand in this case.  We rely on notetracks.
	}
	else
	{
		switch (self.a.special)
		{
		case "cover_crouch":
		case "none":
			if (self.a.pose == "stand")
			{
				armOffset = (0,0,80);
				throw_anim = %stand_grenade_throw;
			}
			else // if (self.a.pose == "crouch")
			{
				armOffset = (0,0,65);
				throw_anim = %crouch_grenade_throw;
			}
			gunHand = "left";
			break;
		default: // Do nothing - we don't have an appropriate throw animation.
			throw_anim = undefined;
			gunHand = undefined;			
			break;
		}
	}
	
	// If we don't have an animation, we can't throw the grenade.
	if (!isDefined(throw_anim))
	{
		//prof_end( "TryGrenadeThrow" );
		return (false);
	}
	
	if (isdefined (destination)) // Now try to throw it.
	{
		throwvel = self checkGrenadeThrowPos(armOffset, "min energy", destination);
		if (!isdefined(throwvel))
			throwvel = self checkGrenadeThrowPos(armOffset, "min time", destination);
		if (!isdefined(throwvel))
			throwvel = self checkGrenadeThrowPos(armOffset, "max time", destination);		
	}
	else
	{
		throwvel = self checkGrenadeThrow(armOffset, "min energy", self.randomGrenadeRange);
		if (!isdefined(throwvel))
			throwvel = self checkGrenadeThrow(armOffset, "min time", self.randomGrenadeRange);
		if (!isdefined(throwvel))
			throwvel = self checkGrenadeThrow(armOffset, "max time", self.randomGrenadeRange);
	}
	
	// the grenade checks are slow. don't do it too often.
	self.a.nextGrenadeTryTime = gettime() + randomintrange(1000,2000);
	
	if ( isdefined(throwvel) )
	{
		if (!isdefined(self.oldGrenAwareness))
			self.oldGrenAwareness = self.grenadeawareness;
		self.grenadeawareness = 0; // so we dont respond to nearby grenades while throwing one
		
		/#
		if (getdebugdvar ("anim_debug") == "1")
			thread animscripts\utility::debugPos(destination, "O");
		#/
		
		// remember the time we want to delay any future grenade throws to, to avoid throwing too many.
		// however, for now, only set the timer far enough in the future that it will expire when we throw the grenade.
		// that way, if the throw fails (maybe due to killanimscript), we'll try again soon.
		nextGrenadeTimeToUse = self getDesiredGrenadeTimerValue();
		setGrenadeTimer( self.activeGrenadeTimer, min( gettime() + 3000, nextGrenadeTimeToUse ) );
		
		secondGrenadeOfDouble = false;
		if ( self usingPlayerGrenadeTimer() )
		{
			anim.numGrenadesInProgressTowardsPlayer++;
			self thread reduceGIPTPOnKillanimscript();
			if ( anim.numGrenadesInProgressTowardsPlayer > 1 )
				secondGrenadeOfDouble = true;
		}
		
		if ( self.activeGrenadeTimer == "player_fraggrenade" && anim.numGrenadesInProgressTowardsPlayer <= 1 )
			anim.lastFragGrenadeToPlayerStart = gettime();
		
		/#
		if ( getdvar( "grenade_spam" ) == "on" )
			nextGrenadeTimeToUse = 0;
		#/
		
		//prof_end( "TryGrenadeThrow" );
		DoGrenadeThrow( throw_anim, nextGrenadeTimeToUse, secondGrenadeOfDouble );
        return true;
	}
	else
	{
		/# self setGrenadeMissReason( "Couldn't find trajectory" ); #/
		/#
		if (getdebugdvar("debug_grenademiss") == "on" && isdefined (destination))
			thread grenadeLine(armoffset, destination);
		#/		
	}
	
	//prof_end( "TryGrenadeThrow" );
	return false;
}

reduceGIPTPOnKillanimscript()
{
	self endon("dont_reduce_giptp_on_killanimscript");
	self waittill("killanimscript");
	anim.numGrenadesInProgressTowardsPlayer--;
}

DoGrenadeThrow( throw_anim, nextGrenadeTimeToUse, secondGrenadeOfDouble )
{
	/#
	self thread grenadeDebug( "Starting throw", 3 );
	#/

	//prof_begin( "DoGrenadeThrow" );	
	self animscripts\battleChatter_ai::evaluateAttackEvent("grenade");
	self notify ("stop_aiming_at_enemy");
	self SetFlaggedAnimKnobAllRestart("throwanim", throw_anim, %body, 1, 0.1, 1);

	self thread animscripts\shared::DoNoteTracksForever("throwanim", "killanimscript");

	//prof_begin( "DoGrenadeThrow" );	

	model = getGrenadeModel();
	
	attachside = "none";
	for (;;)
	{
		self waittill("throwanim", notetrack);
		//prof_begin( "DoGrenadeThrow" );	
		if ( notetrack == "grenade_left" || notetrack == "grenade_right" )
		{
			attachside = attachGrenadeModel(model, "TAG_INHAND");
			self.isHoldingGrenade = true;
		}
		if ( notetrack == "grenade_throw" || notetrack == "grenade throw" )
			break;
		assert(notetrack != "end"); // we shouldn't hit "end" until after we've hit "grenade_throw"!
		if ( notetrack == "end" ) // failsafe
		{
			anim.numGrenadesInProgressTowardsPlayer--;
			self notify("dont_reduce_giptp_on_killanimscript");
			//prof_end( "DoGrenadeThrow" );
			return false;
		}
	}

	/#
	if (getdebugdvar("debug_grenadehand") == "on")
	{
		tags = [];
		numTags = self getAttachSize();
		emptySlot = [];
		for (i=0;i<numTags;i++)
		{
			name = self getAttachModelName(i);
			if (issubstr(name, "weapon"))
			{
				tagName = self getAttachTagname(i);
				emptySlot[tagname] = 0;
				tags[tags.size] = tagName;
			}
		}
		
		for (i=0;i<tags.size;i++)
		{
			emptySlot[tags[i]]++;
			if (emptySlot[tags[i]] < 2)
				continue;
			iprintlnbold ("Grenade throw needs fixing (check console)");
			println ("Grenade throw animation ", throw_anim, " has multiple weapons attached to ", tags[i]);
			break;
		}
	}
	#/
	
	/#
	self thread grenadeDebug( "Threw", 5 );
	#/
	
	self notify("dont_reduce_giptp_on_killanimscript");
	
	if ( self usingPlayerGrenadeTimer() )
	{
		// give the grenade some time to get to the player.
		// if it gets there, we'll reset the timer so we don't throw any more in a while.
		self thread watchGrenadeTowardsPlayer( nextGrenadeTimeToUse );
	}

	self throwGrenade();
	
	
	if ( !self usingPlayerGrenadeTimer() )
	{
		setGrenadeTimer( self.activeGrenadeTimer, nextGrenadeTimeToUse );
	}
	
	if ( secondGrenadeOfDouble )
	{
		if ( anim.numGrenadesInProgressTowardsPlayer > 1 || gettime() - anim.lastGrenadeLandedNearPlayerTime < 2000 )
		{
			// two grenades in progress toward player. give them time to arrive.
			anim.grenadeTimers["player_double_grenade"] = gettime() + min( 5000, anim.playerDoubleGrenadeTime );
		}
	}
	
	self notify ("stop grenade check");
	
//		assert (attachSide != "none");
	if ( attachSide != "none" )		
		self detach(model, attachside);
	else
	{
		print ("No grenade hand set: ");
		println (throw_anim);
		println("animation in console does not specify grenade hand");
	}
	self.isHoldingGrenade = undefined;

	self.grenadeawareness = self.oldGrenAwareness;
	self.oldGrenAwareness = undefined;
	
	//prof_end( "DoGrenadeThrow" );

	self waittillmatch("throwanim", "end");
	// modern
	
	// TODO: why is this here? why are we assuming that the calling function wants these particular animnodes turned on?
	self setanim(%exposed_modern,1,.2);
	self setanim(%exposed_aiming,1);
	self clearanim(throw_anim,.2);
}

watchGrenadeTowardsPlayer( nextGrenadeTimeToUse )
{
	level.player endon("death");
	
	watchGrenadeTowardsPlayerInternal( nextGrenadeTimeToUse );
	anim.numGrenadesInProgressTowardsPlayer--;
}

watchGrenadeTowardsPlayerInternal( nextGrenadeTimeToUse )
{
	// give the grenade at least 5 seconds to land
	activeGrenadeTimer = self.activeGrenadeTimer;
	timeoutObj = spawnstruct();
	timeoutObj thread watchGrenadeTowardsPlayerTimeout( 5 );
	timeoutObj endon("watchGrenadeTowardsPlayerTimeout");
	
	type = self.grenadeWeapon;
	
	grenade = self getGrenadeIThrew();
	if ( !isdefined( grenade ) )
	{
		// the throw failed. maybe we died. =(
		return;
	}
	
	setGrenadeTimer( activeGrenadeTimer, min( gettime() + 5000, nextGrenadeTimeToUse ) );

	/#
	grenade thread grenadeDebug( "Incoming", 5 );
	#/
	
	goodRadiusSqrd = 250 * 250;
	giveUpRadiusSqrd = 400 * 400;
	if ( type == "flash_grenade" )
	{
		goodRadiusSqrd = 900 * 900;
		giveUpRadiusSqrd = 1300 * 1300;
	}
	
	// wait for grenade to settle
	prevorigin = grenade.origin;
	while(1)
	{
		wait .1;
		
		if ( !isdefined( grenade ) )
			break;
		
		if ( grenade.origin == prevorigin )
		{
			if ( distanceSquared( grenade.origin, level.player.origin ) < goodRadiusSqrd || distanceSquared( grenade.origin, level.player.origin ) > giveUpRadiusSqrd )
				break;
		}
		prevorigin = grenade.origin;
	}
	
	grenadeorigin = prevorigin;
	if ( isdefined( grenade ) )
		grenadeorigin = grenade.origin;
	
	if ( distanceSquared( grenadeorigin, level.player.origin ) < goodRadiusSqrd )
	{
		/#
		if ( isdefined( grenade ) )
			grenade thread grenadeDebug( "Landed near player", 5 );
		#/
		
		// the grenade landed near the player! =D
		level notify("threw_grenade_at_player");
		anim.throwGrenadeAtPlayerASAP = undefined;
		
		if ( gettime() - anim.lastGrenadeLandedNearPlayerTime < 3000 )
		{
			// double grenade happened
			anim.grenadeTimers["player_double_grenade"] = gettime() + anim.playerDoubleGrenadeTime;
		}
		
		anim.lastGrenadeLandedNearPlayerTime = gettime();
		
		setGrenadeTimer( activeGrenadeTimer, nextGrenadeTimeToUse );
	}
	else
	{
		/#
		if ( isdefined( grenade ) )
			grenade thread grenadeDebug( "Missed", 5 );
		#/
	}
}

getGrenadeIThrew()
{
	self endon("killanimscript");
	self waittill( "grenade_fire", grenade );
	return grenade;
}

watchGrenadeTowardsPlayerTimeout( timerlength )
{
	wait timerlength;
	self notify("watchGrenadeTowardsPlayerTimeout");
}


attachGrenadeModel(model, tag)
{
	self attach (model, tag);
	thread detachGrenadeOnScriptChange(model, tag);
	return tag;
}


detachGrenadeOnScriptChange(model, tag)
{
	//self endon ("death"); // don't end on death or it will hover when we die!
	self endon ("stop grenade check");
	self waittill ("killanimscript");
	
	if ( !isdefined( self ) ) // we may be dead but still defined. if we're not defined, we were probably deleted.
		return;
	
	if (isdefined(self.oldGrenAwareness))
	{	
		self.grenadeawareness = self.oldGrenAwareness;
		self.oldGrenAwareness = undefined;
	}
	
	self detach(model, tag);
}

offsetToOrigin(start)
{
	forward = anglestoforward(self.angles);
	right = anglestoright(self.angles);
	up = anglestoup(self.angles);
	forward = vectorScale (forward, start[0]);
	right = vectorScale (right, start[1]);
	up = vectorScale (up, start[2]);
	return (forward + right + up);
}

grenadeLine(start, end)
{
	level notify ("armoffset");
	level endon ("armoffset");
	
	start = self.origin + offsetToOrigin(start);
	for (;;)
	{
		line (start, end, (1,0,1));
		print3d (start, start, (0.2,0.5,1.0), 1, 1);	// origin, text, RGB, alpha, scale
		print3d (end, end, (0.2,0.5,1.0), 1, 1);	// origin, text, RGB, alpha, scale
		wait (0.05);
	}
}

getGrenadeDropVelocity()
{
	yaw = randomFloat( 360 );
	pitch = randomFloatRange( 30, 75 );
	
	amntz = sin( pitch );
	cospitch = cos( pitch );
	
	amntx = cos( yaw ) * cospitch;
	amnty = sin( yaw ) * cospitch;
	
	speed = randomFloatRange( 100, 200 );
	
	velocity = (amntx, amnty, amntz) * speed;
	return velocity;
}

dropGrenade()
{
	grenadeOrigin = self GetTagOrigin ( "tag_inhand" );
	velocity = getGrenadeDropVelocity();
	self MagicGrenadeManual( grenadeOrigin, velocity, 3 );
}

// For use by combat scripts, looks at the enemy until the script is interrupted, or "stop EyesAtEnemy" is notified.
EyesAtEnemy()
{
	self notify ("stop EyesAtEnemy internal");	// Prevent buildup of threads.
	self endon ("death");
	self endon ("stop EyesAtEnemy internal");
	for (;;)
	{
		if (isDefined(self.enemy))
			self animscripts\shared::LookAtEntity(self.enemy, 2, "alert", "eyes only", "don't interrupt");
		wait 2;
	}
}

FindCoverNearSelf()
{
	//prof_begin( "FindCoverNearSelf" );	
	
	oldKeepNodeInGoal = self.keepClaimedNodeInGoal;
	oldKeepNode = self.keepClaimedNode;
	self.keepClaimedNodeInGoal = false;
	self.keepClaimedNode = false;
	
	node = self FindBestCoverNode();
	
	if ( isdefined( node ) )
	{
		if ( self.a.script != "combat" || animscripts\combat::shouldGoToNode( node ) )
		{
			if ( self UseCoverNode( node ) )
			{
				//prof_end( "FindCoverNearSelf" );
				return true;
			}
			else
			{
				/#self thread DebugFailedCoverUsage( node );#/
			}
		}
	}
	
	self.keepClaimedNodeInGoal = oldKeepNodeInGoal;
	self.keepClaimedNode = oldKeepNode;
	
	//prof_end( "FindCoverNearSelf" );	
	return false;
}


lookForBetterCover()
{
	// don't do cover searches if we don't have an enemy.
	if ( !isValidEnemy( self.enemy ) )
		return false;
		
	if ( self.fixedNode )
		return false;
	
	//prof_begin( "lookForBetterCover" );
	
	node = self getBestCoverNodeIfAvailable();
	
	if ( isdefined( node ) )
	{
		//prof_end( "lookForBetterCover" );
		return useCoverNodeIfPossible( node );
	}
	
	//prof_end( "lookForBetterCover" );
	return false;
}

getBestCoverNodeIfAvailable()
{
	//prof_begin( "getBestCoverNodeIfAvailable" );
	node = self FindBestCoverNode();
	
	if ( !isdefined(node) )
	{
		//prof_end( "getBestCoverNodeIfAvailable" );
		return undefined;
	}

	currentNode = self GetClaimedNode();
	if ( isdefined( currentNode ) && node == currentNode )
	{
		//prof_end( "getBestCoverNodeIfAvailable" );
		return undefined;
	}
	
	// work around FindBestCoverNode() resetting my .node in rare cases involving overlapping nodes
	// This prevents us from thinking we've found a new node somewhere when in reality it's the one we're already at, so we won't abort our script.
	if ( isdefined( self.coverNode ) && node == self.coverNode )
	{
		//prof_end( "getBestCoverNodeIfAvailable" );
		return undefined;
	}
	
	if ( self.a.script == "combat" && !animscripts\combat::shouldGoToNode( node ) )
	{
		//prof_end( "getBestCoverNodeIfAvailable" );
		return undefined;
	}
	
	//prof_end( "getBestCoverNodeIfAvailable" );
	return node;
}

useCoverNodeIfPossible( node )
{
	oldKeepNodeInGoal = self.keepClaimedNodeInGoal;
	oldKeepNode = self.keepClaimedNode;
	self.keepClaimedNodeInGoal = false;
	self.keepClaimedNode = false;

	if ( self UseCoverNode( node ) )
	{
		return true;
	}
	else
	{
		/#self thread DebugFailedCoverUsage( node );#/
	}
	
	self.keepClaimedNodeInGoal = oldKeepNodeInGoal;
	self.keepClaimedNode = oldKeepNode;
	
	return false;
}

/#
DebugFailedCoverUsage( node )
{
	if ( getdvar("scr_debugfailedcover") == "" )
		setdvar("scr_debugfailedcover", "0");
	if ( getdebugdvarint("scr_debugfailedcover") == 1 )
	{
		self endon("death");
		for ( i = 0; i < 20; i++ )
		{
			line( self.origin, node.origin );
			print3d( node.origin, "failed" );
			wait .05;
		}
	}
}
#/

// this function seems okish,
// but the idea behind FindReacquireNode() is that you call it once,
// and then call GetReacquireNode() many times until it returns undefined.
// if we're just taking the first node (the best), we might as well just be using
// FindBestCoverNode().
/*
tryReacquireNode()
{
	self FindReacquireNode();
	node = self GetReacquireNode();
	if (!isdefined(node))
		return false;
	return (self UseReacquireNode(node));
}
*/

tryRunningToEnemy( ignoreSuppression )
{
	if ( !isValidEnemy( self.enemy ) )
		return false;
	
	if ( self.fixedNode )
		return false;
		
	//prof_begin( "tryRunningToEnemy" );
	
	if ( self isingoal( self.enemy.origin ) )
		self FindReacquireDirectPath( ignoreSuppression );
	else
		self FindReacquireProximatePath( ignoreSuppression );
	
	// TrimPathToAttack is supposed to be called multiple times, until it returns false.
	// it trims the path a little more each time, until trimming it more would make the enemy invisible from the end of the path.
	// we're skipping this step and just running until we get within close range of the enemy.
	// maybe later we can periodically check while moving if the enemy is visible, and if so, enter exposed.
	//self TrimPathToAttack();
	
	if ( self ReacquireMove() )
	{
		self.keepClaimedNodeInGoal = false;
		self.keepClaimedNode = false;
		
		self.a.magicReloadWhenReachEnemy = true;
		//prof_end( "tryRunningToEnemy" );
		return true;
	}
	
	//prof_end( "tryRunningToEnemy" );
	return false;
}

delayedBadplace(org)
{
	self endon ("death");
	wait (0.5);
	/#
		if (getdebugdvar("debug_displace") == "on")
			thread badplacer(5, org, 16);
	#/
	
	string = "" + anim.badPlaceInt;
	badplace_cylinder(string, 5, org, 16, 64, self.team);
	anim.badPlaces[anim.badPlaces.size] = string;
	if (anim.badPlaces.size >= 10) // too many badplaces, delete the oldest one and then remove it from the array
	{
		newArray = [];
		for (i=1;i<anim.badPlaces.size;i++)
			newArray[newArray.size] = anim.badPlaces[i];
		badplace_delete(anim.badPlaces[0]);
		anim.badPlaces = newArray;
	}
	anim.badPlaceInt++;
	if (anim.badPlaceInt > 10)
		anim.badPlaceInt-= 20;
}

valueIsWithin(value,min,max)
{
	if(value > min && value < max)
		return true;
	return false;	
}

getGunYawToShootEntOrPos()
{
	if ( !isdefined( self.shootPos ) )
	{
		assert( !isdefined( self.shootEnt ) );
		return 0;
	}
	
	yaw = self gettagangles("tag_weapon")[1] - GetYaw( self.shootPos );
	yaw = AngleClamp180( yaw );
	return yaw;
}

getGunPitchToShootEntOrPos()
{
	if ( !isdefined( self.shootPos ) )
	{
		assert( !isdefined( self.shootEnt ) );
		return 0;
	}
	
	pitch = self gettagangles("tag_weapon")[0] - VectorToAngles( self.shootPos - self gettagorigin("tag_weapon") )[0];
	pitch = AngleClamp180( pitch );
	return pitch;
}

getPitchToEnemy()
{
	if(!isdefined(self.enemy))
		return 0;
	
	vectorToEnemy = self.enemy getshootatpos() - self getshootatpos();	
	vectorToEnemy = vectornormalize(vectortoenemy);
	pitchDelta = 360 - vectortoangles(vectorToEnemy)[0];
	
	return AngleClamp180( pitchDelta );
}

getPitchToSpot(spot)
{
	if(!isdefined(spot))
		return 0;
	
	vectorToEnemy = spot - self getshootatpos();	
	vectorToEnemy = vectornormalize(vectortoenemy);
	pitchDelta = 360 - vectortoangles(vectorToEnemy)[0];
	
	return AngleClamp180( pitchDelta );
}

anim_set_next_move_to_new_cover()
{
	self.a.next_move_to_new_cover = randomintrange( 1, 4 );
}

watchReloading()
{
	// this only works on the player.
	self.isreloading = false;
	while(1)
	{
		self waittill("reload_start");
		self.isreloading = true;
		
		self waittillreloadfinished();
		self.isreloading = false;
	}
}

waittillReloadFinished()
{
	self thread timedNotify( 4, "reloadtimeout" );
	self endon("reloadtimeout");
	while(1)
	{
		self waittill("reload");
		
		weap = self getCurrentWeapon();
		if ( weap == "none" )
			break;
		
		if ( self getCurrentWeaponClipAmmo() >= weaponClipSize( weap ) )
			break;
	}
	self notify("reloadtimeout");
}

timedNotify( time, msg )
{
	self endon( msg );
	wait time;
	self notify( msg );
}

attackEnemyWhenFlashed()
{
	self endon("killanimscript");
	
	while(1)
	{
		if ( !isdefined( self.enemy ) || !isalive( self.enemy ) || !isSentient( self.enemy ) )
		{
			self waittill("enemy");
			continue;
		}
		
		attackSpecificEnemyWhenFlashed();
	}
}

attackSpecificEnemyWhenFlashed()
{
	self endon("enemy");
	self.enemy endon("death");
	
	if ( isdefined( self.enemy.flashendtime ) && gettime() < self.enemy.flashendtime )
		tryToAttackFlashedEnemy();
	
	while ( 1 )
	{
		self.enemy waittill("flashed");
		
		tryToAttackFlashedEnemy();
	}
}

tryToAttackFlashedEnemy()
{
	if ( self.enemy.flashingTeam != self.team )
		return;
	
	if ( distanceSquared( self.origin, self.enemy.origin ) > 1024*1024 )
		return;
	
	while ( gettime() < self.enemy.flashendtime - 500 )
	{
		if ( !self cansee( self.enemy ) && distanceSquared( self.origin, self.enemy.origin ) < 800*800 )
			tryRunningToEnemy( true );
		
		wait .05;
	}
}

shouldThrowFlashBangAtEnemy()
{
	if ( distanceSquared( self.origin, self.enemy.origin ) > 768 * 768 )
		return false;
	
	return true;
}

startFlashBanged()
{
	if ( isdefined( self.flashduration ) )
		duration = self.flashduration;
	else
		duration = self getFlashBangedStrength() * 1000;
	
	self.flashendtime = gettime() + duration;
	self notify("flashed");
	
	return duration;
}

monitorFlash()
{
	self endon("death");
	self endon("stop_monitoring_flash");
	
	while(1)
	{
		// "flashbang" is code notifying that the AI can be flash banged
		// "doFlashBanged" is sent below if the AI should do flash banged behavior
		self waittill( "flashbang", amount_distance, amount_angle, attacker, attackerteam );
		
		if ( self.flashbangImmunity )
			continue;
		
		if( isdefined( self.script_immunetoflash ) && self.script_immunetoflash != 0 )
			continue;
		
		if ( isdefined( self.team ) && isdefined( attackerteam ) && self.team == attackerteam )
		{
			// AI get a break when their own team flashbangs them.
			amount_distance = 3 * (amount_distance - .75);
			if ( amount_distance < 0 )
				continue;
		}
		
		// at 200 or less of the full range of 1000 units, get the full effect
		minamountdist = 0.2;
		if ( amount_distance > 1 - minamountdist )
			amount_distance = 1.0;
		else
			amount_distance = amount_distance / (1 - minamountdist);
		
		duration = 4.5 * amount_distance;
		
		if ( duration < 0.25 )
			continue;
		
		self.flashingTeam = attackerteam;
		self setFlashBanged( true, duration );
		self notify( "doFlashBanged", attacker );
	}
}

isSniper()
{
	return self.isSniper;
}


isSniperRifle( weapon )
{
	return isdefined( anim.sniperRifles[ weapon ] );
}
