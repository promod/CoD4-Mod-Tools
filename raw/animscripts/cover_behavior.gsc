#include maps\_utility;
#include animscripts\combat_utility;
#include animscripts\utility;
#include animscripts\shared;
#include common_scripts\utility;

/*
This file contains the overall behavior for all "whack-a-mole" cover nodes.

Callbacks which must be defined:

 All callbacks should return true or false depending on whether they succeeded in doing something.
 If functionality for a callback isn't available, just don't define it.

mainLoopStart()
	optional
reload()
	plays a reload animation in a hidden position
leaveCoverAndShoot()
	does the main attacking; steps out or stands up and fires, goes back to hiding.
	should obey orders from decideWhatAndHowToShoot in shoot_behavior.gsc.
look( maxtime )
	looks for up to maxtime, stopping and returning if enemy becomes visible or if suppressed
fastlook()
	looks quickly
idle()
	idles until the "end_idle" notify.
flinch()
	flinches briefly (1-2 seconds), doesn't need to return true or false.
grenade( throwAt )
	steps out and throws a grenade at the given player / ai
grenadehidden( throwAt )
	throws a grenade at the given player / ai without leaving cover
blindfire()
	blindfires from cover

example:
behaviorCallbacks = spawnstruct();
behaviorCallbacks.reload = ::reload;
...
animscripts\cover_behavior::main( behaviorCallbacks );

*/

main( behaviorCallbacks )
{
	/#
	if ( getdvar("scr_forceshotgun") == "on" && self.primaryweapon != "winchester1200" )
	{
		self.secondaryweapon = self.primaryweapon;
		
		self.primaryweapon = "winchester1200";
		self animscripts\init::initWeapon( self.primaryweapon, "primary" );
		self animscripts\init::initWeapon( self.secondaryweapon, "secondary" );
		self animscripts\shared::placeWeaponOn( self.secondaryweapon, "back");
		self animscripts\shared::placeWeaponOn( self.primaryweapon, "right");
		self.weapon = self.primaryweapon;
		self animscripts\weaponList::RefillClip();
	}
	#/
	
	//prof_begin("cover_main");
	
	self.couldntSeeEnemyPos = self.origin; // (set couldntSeeEnemyPos to a place the enemy can't be while we're in corner behavior)
	
	time = gettime();
	nextAllowedLookTime = time - 1;
	nextAllowedSuppressTime = time - 1;
	
	// we won't look for better cover purely out of boredom until this time
	self.a.getBoredOfThisNodeTime = gettime() + randomintrange( 2000, 6000 );
	resetSeekOutEnemyTime();
	self.a.lastEncounterTime = time;
	
	self.a.idlingAtCover = false;
	self.a.movement = "stop";
	
	self thread watchSuppression();
	self thread attackEnemyWhenFlashed();
	
	desynched = (gettime() > 2500);
	
	correctAngles = self.coverNode.angles;
	if ( self.coverNode.type == "Cover Left" || self.coverNode.type == "Cover Left Wide" )
		correctAngles = (correctAngles[0], correctAngles[1] + 90, correctAngles[2]);
	else if ( self.coverNode.type == "Cover Right" || self.coverNode.type == "Cover Right Wide" )
		correctAngles = (correctAngles[0], correctAngles[1] - 90, correctAngles[2]);
	
	/#
	if ( getdvar("scr_coveridle") == "1" )
	{
		self.coverNode.script_onlyidle = true;
	}
	#/
	
	//prof_end("cover_main");
	
	for(;;)
	{
		//prof_begin("cover_main_A");
		if ( isdefined( behaviorCallbacks.mainLoopStart ) )
		{
			startTime = gettime();
			self thread endIdleAtFrameEnd();
			
			//prof_end("cover_main_A");
			[[ behaviorCallbacks.mainLoopStart ]]();
			
			if ( gettime() == startTime )
				self notify("dont_end_idle");
		}
		
		self teleport( self.covernode.origin, correctAngles );
		
		if ( isDefined( self.coverNode.script_onlyidle ) )
		{
			assert( self.coverNode.script_onlyidle ); // true or undefined
			//prof_end("cover_main_A");
			idle( behaviorCallbacks );
			continue;
		}
		
		if ( !desynched )
		{
			//prof_end("cover_main_A");
			idle( behaviorCallbacks, 0.05 + randomfloat( 1.5 ) );
			desynched = true;
			continue;
		}
		
		//prof_end("cover_main_A");
		
		//prof_begin("cover_main_B");
		
		// if we're suppressed, we do other things.
		if ( suppressedBehavior( behaviorCallbacks ) )
		{
			if ( isEnemyVisibleFromExposed() )
				resetSeekOutEnemyTime();
			self.a.lastEncounterTime = gettime();
			//prof_end("cover_main_B");
			continue;
		}
		
		//prof_end("cover_main_B");
		
		//prof_begin("cover_main_C");
		
		// reload if we need to; everything in this loop involves shooting.
		if ( coverReload( behaviorCallbacks, 0 ) )
		{
			//prof_end("cover_main_C");
			continue;
		}
		
		// determine visibility and suppressability of enemy.
		visibleEnemy = false;
		suppressableEnemy = false;
		if ( isalive(self.enemy) )
		{
			visibleEnemy = isEnemyVisibleFromExposed();
			suppressableEnemy = canSuppressEnemyFromExposed();
		}
		
		if ( isdefined( anim.throwGrenadeAtPlayerASAP ) && self.team == "axis" && isAlive( level.player ) )
		{
			if ( tryThrowingGrenade( behaviorCallbacks, level.player ) )
			{
				//prof_end("cover_main_C");
				continue;
			}
		}
		
		//prof_end("cover_main_C");

		// decide what to do.
		if ( visibleEnemy )
		{
			//prof_begin("cover_visible_enemy");
			if ( distanceSquared( self.origin, self.enemy.origin ) > 750 * 750 )
			{
				if ( tryThrowingGrenade( behaviorCallbacks, self.enemy ) )
				{
					//prof_end("cover_visible_enemy");
					continue;
				}
			}
			
			if ( leaveCoverAndShoot( behaviorCallbacks, "normal" ) )
			{
				resetSeekOutEnemyTime();
				self.a.lastEncounterTime = gettime();
			}
			else
			{
				//prof_end("cover_visible_enemy");
				idle( behaviorCallbacks );
			}
			
			//prof_end("cover_visible_enemy");
		}
		else
		{
			//prof_begin("cover_notvisible_enemy");
			if ( !visibleEnemy && enemyIsHiding() && !self.fixedNode )
			{
				if ( advanceOnHidingEnemy() )
				{
					//prof_end("cover_notvisible_enemy");
					return;
				}
			}
			
			if ( suppressableEnemy )
			{
				// randomize the order of trying the following options
				permutation = getPermutation(2);
				done = false;
				for ( i = 0; i < permutation.size && !done; i++ )
				{
					switch( i )
					{
					case 0:
						if ( self.provideCoveringFire || gettime() >= nextAllowedSuppressTime )
						{
							preferredActivity = "suppress";
							if ( !self.provideCoveringFire && (gettime() - self.lastSuppressionTime) > 5000 && randomint(3) < 2 )
								preferredActivity = "ambush";
							if ( !self animscripts\shoot_behavior::shouldSuppress() )
								preferredActivity = "ambush";
							
							if ( leaveCoverAndShoot( behaviorCallbacks, preferredActivity ) )
							{
								nextAllowedSuppressTime = gettime() + randomintrange( 3000, 20000 );
								// if they're there, we've seen them
								if ( isEnemyVisibleFromExposed() )
									self.a.lastEncounterTime = gettime();
								done = true;
							}
						}
						break;
					
					case 1:
						if ( tryThrowingGrenade( behaviorCallbacks, self.enemy ) )
						{
							done = true;
						}
						break;
					}
				}
				if ( done )
					continue;
				
				//prof_end("cover_notvisible_enemy");
				idle( behaviorCallbacks );
			}
			else
			{
				// nothing to do!
				
				if ( coverReload( behaviorCallbacks, 0.1 ) )
				{
					//prof_end("cover_notvisible_enemy");
					continue;
				}
				
				if ( isValidEnemy( self.enemy ) )
				{
					if ( tryThrowingGrenade( behaviorCallbacks, self.enemy ) )
					{
						//prof_end("cover_notvisible_enemy");
						continue;
					}
				}
				
				if ( self.team == "axis" && self weaponAnims() != "rocketlauncher" )
				{
					if ( leaveCoverAndShoot( behaviorCallbacks, "ambush" ) )
					{
						nextAllowedSuppressTime = gettime() + randomintrange( 3000, 20000 );
						// if they're there, we've seen them
						if ( isEnemyVisibleFromExposed() )
							self.a.lastEncounterTime = gettime();
							
						//prof_end("cover_notvisible_enemy");
						continue;
					}
				}
				
				if ( gettime() >= nextAllowedLookTime )
				{
					if ( lookForEnemy( behaviorCallbacks ) )
					{
						nextAllowedLookTime = gettime() + randomintrange( 4000, 15000 );
						
						// if they're there, we've seen them
						//prof_end("cover_notvisible_enemy");
						continue;
					}
				}
				
				// we're *really* bored right now
				if ( gettime() > self.a.getBoredOfThisNodeTime )
				{
					if ( cantFindAnythingToDo() )
					{
						//prof_end("cover_notvisible_enemy");
						return;
					}
				}
				
				if ( gettime() >= nextAllowedSuppressTime && isValidEnemy( self.enemy ) )
				{
					// be ready to ambush them if they happen to show up
					if ( leaveCoverAndShoot( behaviorCallbacks, "ambush" ) )
					{
						if ( isEnemyVisibleFromExposed() )
							resetSeekOutEnemyTime();
						self.a.lastEncounterTime = gettime();
						nextAllowedSuppressTime = gettime() + randomintrange( 6000, 20000 );
						//prof_end("cover_notvisible_enemy");
						continue;
					}
				}
				
				//prof_end("cover_notvisible_enemy");
				idle( behaviorCallbacks );
			}
		}
	}
}

isEnemyVisibleFromExposed()
{
	if ( !isdefined( self.enemy ) )
		return false;
	
	// if we couldn't see our enemy last time we stepped out, and they haven't moved, assume we still can't see them.
	if ( distanceSquared(self.enemy.origin, self.couldntSeeEnemyPos) < 16*16 )
		return false;
	else
		return canSeeEnemyFromExposed();
}

suppressedBehavior( behaviorCallbacks )
{
	if ( !isSuppressedWrapper() )
		return false;
	
	nextAllowedBlindfireTime = gettime();
	
	justlooked = true;
	
	//prof_begin( "suppressedBehavior" );
	
	while ( isSuppressedWrapper() )
	{
		justlooked = false;

		self teleport( self.coverNode.origin );
		
		if ( tryToGetOutOfDangerousSituation() )
		{
			self notify("killanimscript");
			//prof_end( "suppressedBehavior" );
			return true;
		}
		
		canThrowGrenade = isEnemyVisibleFromExposed() || canSuppressEnemyFromExposed();
		
		
		// if we're only at a concealment node, and it's not providing cover, we shouldn't try to use the cover to keep us safe!
		if ( self.a.atConcealmentNode && self canSeeEnemy() )
		{
			//prof_end( "suppressedBehavior" );
			return false;
		}
		
		
		if ( canThrowGrenade && isdefined( anim.throwGrenadeAtPlayerASAP ) && self.team == "axis" && isAlive( level.player ) )
		{
			if ( tryThrowingGrenade( behaviorCallbacks, level.player ) )
				continue;
		}


		if ( coverReload( behaviorCallbacks, 0 ) )
			continue;
		
		
		// randomize the order of trying the following options
		permutation = getPermutation(2);
		done = false;
		for ( i = 0; i < permutation.size && !done; i++ )
		{
			switch( i )
			{
			case 0:
				if ( self.team != "allies" && gettime() >= nextAllowedBlindfireTime )
				{
					if ( blindfire( behaviorCallbacks ) )
					{
						nextAllowedBlindfireTime = gettime() + randomintrange( 3000, 12000 );
						done = true;
					}
				}
				break;
				
			case 1:
				if ( canThrowGrenade && tryThrowingGrenade( behaviorCallbacks, self.enemy ) )
				{
					justlooked = true;
					done = true;
				}
				break;
			}
		}
		if ( done )
			continue;
		
		
		if ( coverReload( behaviorCallbacks, 0.1 ) )
			continue;
		
		//prof_end( "suppressedBehavior" );
		idle( behaviorCallbacks );
	}
	
	if ( !justlooked && randomint(2) == 0 )
		lookfast( behaviorCallbacks );
	
	//prof_end( "suppressedBehavior" );
	return true;
}

// returns array of integers 0 through n-1, in random order
getPermutation( n )
{
	permutation = [];
	assert( n > 0 );
	if ( n == 1 )
	{
		permutation[0] = 0;
	}
	else if ( n == 2 )
	{
		permutation[0] = randomint(2);
		permutation[1] = 1 - permutation[0];
	}
	else
	{
		for ( i = 0; i < n; i++ )
			permutation[i] = i;
		for ( i = 0; i < n; i++ )
		{
			switchIndex = i + randomint(n - i);
			temp = permutation[switchIndex];
			permutation[SwitchIndex] = permutation[i];
			permutation[i] = temp;
		}
	}
	return permutation;
}

callOptionalBehaviorCallback( callback, arg, arg2, arg3 )
{
	if ( !isdefined( callback ) )
		return false;
	
	//prof_begin( "callOptionalBehaviorCallback" );
	self thread endIdleAtFrameEnd();
	
	starttime = gettime();
	
	val = undefined;
	if( isdefined( arg3 ) )
		val = [[callback]]( arg, arg2, arg3 );
	else if ( isdefined( arg2 ) )
		val = [[callback]]( arg, arg2 );
	else if ( isdefined( arg ) )
		val = [[callback]]( arg );
	else
		val = [[callback]]();
	
	/#
	// if this assert fails, a behaviorCallback callback didn't return true or false.
	assert( isdefined( val ) && (val == true || val == false) );
	
	// behaviorCallbacks must return true if and only if they let time pass.
	// (it is also important that they only let time pass if they did what they were supposed to do,
	//  but that's not so easy to enforce.)
	if ( val )
		assert( gettime() != starttime );
	else
		assert( gettime() == starttime );
	#/
	
	if ( !val )
		self notify("dont_end_idle");
		
	//prof_end( "callOptionalBehaviorCallback" );
	
	return val;
}

watchSuppression()
{
	self endon("killanimscript");
	
	// self.lastSuppressionTime is the last time a bullet whizzed by.
	// self.suppressionStart is the last time we were thinking it was safe when a bullet whizzed by.
	
	self.lastSuppressionTime = gettime() - 100000;
	self.suppressionStart = self.lastSuppressionTime;
	
	while(1)
	{
		self waittill("suppression");
		
		time = gettime();
		if ( self.lastSuppressionTime < time - 700 )
			self.suppressionStart = time;
		self.lastSuppressionTime = time;
	}
}

coverReload( behaviorCallbacks, threshold )
{
	if ( self.bulletsInClip > weaponClipSize( self.weapon ) * threshold )
		return false;
	
	self.isreloading = true;
	
	result = callOptionalBehaviorCallback( behaviorCallbacks.reload );
	
	self.isreloading = false;
	
	return result;
}

// initialGoal can be either "normal", "suppress", or "ambush".
leaveCoverAndShoot( behaviorCallbacks, initialGoal )
{
	self thread animscripts\shoot_behavior::decideWhatAndHowToShoot( initialGoal );
	
	if ( !self.fixedNode )
		self thread breakOutOfShootingIfWantToMoveUp();
	
	val = callOptionalBehaviorCallback( behaviorCallbacks.leaveCoverAndShoot );
	
	self notify("stop_deciding_how_to_shoot");
	
	return val;
}

lookForEnemy( behaviorCallbacks )
{
	if ( self.a.atConcealmentNode && self canSeeEnemy() )
		return false;
	
	if ( self.a.lastEncounterTime + 6000 > gettime() )
	{
		return lookfast( behaviorCallbacks );
	}
	else
	{
		// look slow if possible
		result = callOptionalBehaviorCallback( behaviorCallbacks.look, 2 + randomfloat( 2 ) );
		if ( result )
			return true;
		return callOptionalBehaviorCallback( behaviorCallbacks.fastlook );
	}
}

lookfast( behaviorCallbacks )
{
	// look fast if possible
	result = callOptionalBehaviorCallback( behaviorCallbacks.fastlook );
	if ( result )
		return true;
	return callOptionalBehaviorCallback( behaviorCallbacks.look, 0 );
}

idle( behaviorCallbacks, howLong )
{
	self.flinching = false;
	
	if ( isdefined( behaviorCallbacks.flinch ) )
	{
		// flinch if we just started getting shot at very recently
		if ( !self.a.idlingAtCover && gettime() - self.suppressionStart < 600 )
		{
			if ( [[ behaviorCallbacks.flinch ]]() )
				return true;
		}
		else
		{
			// if bullets aren't already whizzing by, idle for now but flinch if we get incoming fire
			self thread flinchWhenSuppressed( behaviorCallbacks );
		}
	}
	
	if ( !self.a.idlingAtCover )
	{
		assert( isdefined( behaviorCallbacks.idle ) ); // idle must be available!
		self thread idleThread( behaviorCallbacks.idle ); // this thread doesn't stop until "end_idle", which must be notified before we start anything else! use endIdleAtFrameEnd() to do this.
		self.a.idlingAtCover = true;
	}
	
	if ( isdefined( howLong ) )
		self idleWait( howLong );
	else
		self idleWaitABit();
	
	if ( self.flinching )
		self waittill("flinch_done");
	
	self notify("stop_waiting_to_flinch");
}

idleWait( howLong )
{
	self endon("end_idle");
	wait howLong;
}

idleWaitAbit()
{
	self endon("end_idle");
	wait 0.3 + randomfloat( 0.1 );
	self waittill("do_slow_things");
}

idleThread( idlecallback )
{
	self endon("killanimscript");
	self [[ idlecallback ]]();
}

flinchWhenSuppressed( behaviorCallbacks )
{
	self endon ("killanimscript");
	self endon ("stop_waiting_to_flinch");
	
	lastSuppressionTime = self.lastSuppressionTime;
	
	while(1)
	{
		self waittill("suppression");
		
		time = gettime();
		
		if ( lastSuppressionTime < time - 2000 )
			break;
		
		lastSuppressionTime = time;
	}
	
	self.flinching = true;
	
	self thread endIdleAtFrameEnd();
	
	assert( isdefined( behaviorCallbacks.flinch ) );
	val = [[ behaviorCallbacks.flinch ]]();
	
	if ( !val )
		self notify("dont_end_idle");
	
	self.flinching = false;
	self notify("flinch_done");
}

endIdleAtFrameEnd()
{
	self endon("killanimscript");
	self endon("dont_end_idle");
	waittillframeend;
	self notify("end_idle");
	self.a.idlingAtCover = false;
}

tryThrowingGrenade( behaviorCallbacks, throwAt )
{
	if ( self isPartiallySuppressedWrapper() )
	{
		return callOptionalBehaviorCallback( behaviorCallbacks.grenadehidden, throwAt );
	}
	else
	{
		return callOptionalBehaviorCallback( behaviorCallbacks.grenade, throwAt );
	}
}

blindfire( behaviorCallbacks )
{
	if ( !canBlindFire() )
		return false;
	
	return callOptionalBehaviorCallback( behaviorCallbacks.blindfire );
}

breakOutOfShootingIfWantToMoveUp()
{
	self endon("killanimscript");
	self endon("stop_deciding_how_to_shoot");
	
	while(1)
	{
		if ( self.fixedNode )
			return;
			
		wait 0.5 + randomfloat( 0.75 );
		
		if ( !isValidEnemy( self.enemy ) )
			continue;
		
		if ( enemyIsHiding() )
		{
			if ( advanceOnHidingEnemy() )
				return;
		}
		
		if ( !self canSeeEnemy() && !self canSuppressEnemy() )
		{
			if ( gettime() > self.a.getBoredOfThisNodeTime )
			{
				if ( cantFindAnythingToDo() )
					return;
			}
		}
	}
}

enemyIsHiding()
{
	// if this function is called, we already know that our enemy is not visible from exposed.
	// check to see if they're doing anything hiding-like.
	
	if ( !isdefined( self.enemy ) )
		return false;
	
	if ( self.enemy isFlashed() )
		return true;
	
	if ( isplayer( self.enemy ) )
	{
		if ( isdefined( self.enemy.health ) && self.enemy.health < self.enemy.maxhealth )
			return true;
	}
	else
	{
		if ( issentient( self.enemy ) && self.enemy isSuppressedWrapper() )
			return true;
	}
	
	if ( isdefined( self.enemy.isreloading ) && self.enemy.isreloading )
		return true;
	
	return false;
}

wouldBeSmartForMyAITypeToSeekOutEnemy()
{
	if ( self weaponAnims() == "rocketlauncher" )
		return false;
	if ( self isSniper() )
		return false;
	return true;
}

resetSeekOutEnemyTime()
{
	// we'll be willing to actually run right up to our enemy in order to find them if we haven't seen them by this time.
	// however, we'll try to find better cover before seeking them out
	self.seekOutEnemyTime = gettime() + randomintrange( 3000, 5000 );
}

// these next functions are "look for better cover" functions.
// they don't always need to cause the actor to leave the node immediately,
// but if they keep being called over and over they need to become more and more likely to do so,
// as this indicates that new cover is strongly needed.
cantFindAnythingToDo()
{
	return advanceOnHidingEnemy();
}

advanceOnHidingEnemy()
{
	foundBetterCover = false;
	if ( !isValidEnemy( self.enemy ) || !self.enemy isFlashed() )
		foundBetterCover = lookForBetterCover();
	
	if ( !foundBetterCover && isValidEnemy( self.enemy ) && wouldBeSmartForMyAITypeToSeekOutEnemy() && !self canSeeEnemyFromExposed() )
	{
		if ( gettime() >= self.seekOutEnemyTime || self.enemy isFlashed() )
		{
			return tryRunningToEnemy( false );
		}
	}
	
	// maybe at this point we could look for someone who's suppressing our enemy,
	// and if someone is, we can say "cover me!" and have them say "i got you covered" or something.
	
	return foundBetterCover;
}

tryToGetOutOfDangerousSituation()
{
	// maybe later we can do something more sophisticated here
	return lookForBetterCover();
}

