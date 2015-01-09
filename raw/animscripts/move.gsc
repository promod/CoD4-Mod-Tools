#include animscripts\SetPoseMovement;
#include animscripts\combat_utility;
#include animscripts\utility;
#include animscripts\shared;
#include common_scripts\utility;

#using_animtree ("generic_human");

main()
{
	//prof_begin( "move_init" );
	self endon("killanimscript");
	
	/#
	if ( getdvar("showlookaheaddir") == "on" )
		self thread drawLookaheadDir();
	#/
	
	
	[[ self.exception[ "move" ] ]]();
	
    self trackScriptState( "Move Main", "code" );
	
	if ( self.a.pose == "prone" )
	{
		newPose = self animscripts\utility::choosePose( "stand" );
		
		if ( newPose != "prone" )
		{
			self animMode( "zonly_physics", false );
			rate = 1;
			if ( isdefined( self.grenade ) )
				rate = 2;
			self animscripts\cover_prone::proneTo( newPose, rate );
			self animMode( "none", false );
			self orientMode( "face default" );
		}
	}
	
	previousScript = self.a.script;	// Grab the previous script before initialize updates it.  Used for "cover me" dialogue.
    animscripts\utility::initialize("move");
 	if (self.moveMode == "run")
	{
		// Say something
		switch (previousScript)
		{
		case "combat": // handle most common cases first
		case "stop":
			// Say random poop.
			self animscripts\battleChatter_ai::evaluateMoveEvent (false);
			break;

		case "cover_crouch":
		case "cover_left":
		case "cover_prone":
		case "cover_right":
		case "cover_stand":
		case "concealment_crouch":
		case "concealment_prone":
		case "concealment_stand":
		case "cover_wide_left":
		case "cover_wide_right":
		case "stalingrad_cover_crouch":
		case "hide":
		case "turret":
			// Leaving cover.  Say something like "cover me".
			self animscripts\battleChatter_ai::evaluateMoveEvent (true);
			break;

		default:
			// Say random poop.
			self animscripts\battleChatter_ai::evaluateMoveEvent (false);
			break;
		}
	}
	self animscripts\battlechatter::playBattleChatter();
	
	self thread attackEnemyWhenFlashed();
	
	//prof_end( "move_init" );
	
	// approach/exit stuff
	//prof_begin("move_startMoveTransition");
	self animscripts\cover_arrival::startMoveTransition();
	//prof_end("move_startMoveTransition");
	//prof_begin("move_setupApproachNode");
	self thread animscripts\cover_arrival::setupApproachNode( true );
	//prof_end("move_setupApproachNode");
	
	self.cqb_track_thread = undefined;
	self.shoot_while_moving_thread = undefined;
	
	MoveMainLoop();
}

MoveMainLoop()
{
	prevLoopTime = self getAnimTime( %walk_and_run_loops );
	self.a.runLoopCount = randomint( 10000 ); // integer that is incremented each time we complete a run loop

	// if initial destination is closer than 64 walk to it.
	moveMode = self.moveMode;
	if ( isdefined( self.pathGoalPos ) && distanceSquared( self.origin, self.pathGoalPos ) < 4096 )
		moveMode = "walk";
	
	for (;;)
	{
		//prof_begin("MoveMainLoop");
		loopTime = self getAnimTime( %walk_and_run_loops );
		if ( loopTime < prevLoopTime )
			self.a.runLoopCount++;
		prevLoopTime = loopTime;
		
		self animscripts\face::SetIdleFaceDelayed( anim.alertface );
		
		if ( self animscripts\cqb::shouldCQB() )
		{
			self animscripts\cqb::MoveCQB();
		}
		else
		{
			if ( self.moveMode != "run" )
			{
				moveMode = self.moveMode;
			}
			// if walking, check that the destination is close by, and if not, switch to actual self.moveMode
			else if ( moveMode == "walk" )
			{
				if ( !isdefined( self.pathGoalPos ) || distanceSquared( self.origin, self.pathGoalPos ) > 4096 )
					moveMode = self.moveMode;
			}
		
			if ( moveMode == "run" )
			{
				//prof_begin("MoveRun");
				self animscripts\run::MoveRun();
				//prof_end("MoveRun");
			}
			else
			{
				assert( moveMode == "walk" );
				self animscripts\walk::MoveWalk();
			}
		}
		
		self.exitingCover = false;
		//prof_end("MoveMainLoop");
	}
}

MayShootWhileMoving()
{
	if ( self.weapon == "none" )
		return false;
	
	weapclass = weaponClass( self.weapon );
	if ( weapclass != "rifle" && weapclass != "smg" && weapclass != "spread" && weapclass != "mg" )
		return false;
	
	if ( self isSniper() )
		return false;
	
	if ( isdefined( self.dontShootWhileMoving ) )
	{
		assert( self.dontShootWhileMoving ); // true or undefined
		return false;
	}

	return true;
}

shootWhileMoving()
{
	self endon("killanimscript");
	
	// it's possible for this to be called by CQB while it's already running from run.gsc,
	// even though run.gsc will kill it on the next frame. We can't let it run twice at once.
	self notify("doing_shootWhileMoving");
	self endon("doing_shootWhileMoving");
	
	self.a.array["fire"] = %exposed_shoot_auto_v3;
	
	if ( isdefined( self.weapon ) && weaponClass( self.weapon ) == "spread" )
		self.a.array["single"] = array( %shotgun_stand_fire_1A, %shotgun_stand_fire_1B );
	else
		self.a.array["single"] = array( %exposed_shoot_semi1 );
	
	self.a.array["burst2"] = %exposed_shoot_burst3;
	self.a.array["burst3"] = %exposed_shoot_burst3;
	self.a.array["burst4"] = %exposed_shoot_burst4;
	self.a.array["burst5"] = %exposed_shoot_burst5;
	self.a.array["burst6"] = %exposed_shoot_burst6;
	
	self.a.array["semi2"] = %exposed_shoot_semi2;
	self.a.array["semi3"] = %exposed_shoot_semi3;
	self.a.array["semi4"] = %exposed_shoot_semi4;
	self.a.array["semi5"] = %exposed_shoot_semi5;
	
	while(1)
	{
		if ( !self.bulletsInClip )
		{
			if ( self isCQBWalking() )
				cheatAmmoIfNecessary();

			if ( !self.bulletsInClip )
			{
				wait 0.5;
				continue;
			}
		}
		
		self shootUntilShootBehaviorChange();
		// can't clear %exposed_modern because there are transition animations within it that we might play when going to prone
		self clearAnim( %exposed_aiming, 0.2 );
	}
}

combatBreaker()
{
	self endon("killanimscript");
	while (isalive(self.enemy) && isdefined(self.node) && self canSee(self.enemy))
	{
		if (seekingCoverInMyFov())
			break;
		wait (0.25);
	}
	self thread moveAgain();
}

moveAgain()
{
	self notify("killanimscript");
	animscripts\move::main();
}

seekingCoverInMyFov()
{
	// Run back to cover if you're not in your goalradius
	if (distance(self.origin, self.node.origin) > self.goalradius)
		return true;
	if (distance(self.origin, self.node.origin) < 80)
		return true;
//	print3d(self.node.origin, "node for " + self getentnum(), (1,1,0));
	enemyAngles = vectorToAngles(self.origin - self.enemy.origin);
	enemyForward = anglesToForward(enemyAngles);
	nodeAngles = vectorToAngles(self.origin - self.node.origin);
	nodeForward = anglesToForward(nodeAngles);
	return (vectorDot(enemyForward, nodeforward) > 0.1);
}

RunBreaker()
{
	self endon("killanimscript");
	for (;;)
	{
		if (isalive(self.enemy) && isdefined(self.node) && self canSee(self.enemy))
		{
			if (!seekingCoverInMyFov())
				break;
		}
		wait (0.25);
	}
	self thread moveAgain();
}

/#
drawLookaheadDir()
{
	self endon("killanimscript");
	for (;;)
	{
		line(self.origin + (0,0,20), (self.origin + vectorscale(self.lookaheaddir,64)) + (0,0,20));	
		wait(0.05);
	}
}
#/
