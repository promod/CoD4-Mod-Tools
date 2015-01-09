#include animscripts\utility;
#include animscripts\combat_utility;
#include animscripts\shared;
#include common_scripts\utility;
#using_animtree ("generic_human");

shouldCQB()
{
	return self isCQBWalking() && !isdefined( self.grenade );
}

MoveCQB()
{
	animscripts\run::changeWeaponStandRun();
	
	// any endons in this function must also be in CQBShootWhileMoving and CQBDecideWhatAndHowToShoot
	
	if ( self.a.pose != "stand" )
	{
		// (get rid of any prone or other stuff that might be going on)
		self clearAnim( %root, 0.2 );
		if ( self.a.pose == "prone" )
			self ExitProneWrapper( 1 );
		self.a.pose = "stand";
	}
	self.a.movement = self.moveMode;
	
	self clearanim(%combatrun, 0.2);
	
	self thread CQBTracking();
	
	variation = getRandomIntFromSeed( self.a.runLoopCount, 2 );
	if ( variation == 0 )
		cqbWalkAnim = %run_CQB_F_search_v1;
	else
		cqbWalkAnim = %run_CQB_F_search_v2;
	if ( self.movemode == "walk" )
		cqbWalkAnim = %walk_CQB_F;
	
	rate = self.moveplaybackrate;
	
	// (we don't use %body because that would reset the aiming knobs)
	self setFlaggedAnimKnobAll( "runanim", cqbWalkAnim, %walk_and_run_loops, 1, 0.3, rate );
	
	// Play the appropriately weighted animations for the direction he's moving.
	animWeights = animscripts\utility::QuadrantAnimWeights( self getMotionAngle() );
	self setanim(%combatrun_forward, animWeights["front"], 0.2, 1);
	self setanim(%walk_backward, animWeights["back"], 0.2, 1);
	self setanim(%walk_left, animWeights["left"], 0.2, 1);
	self setanim(%walk_right, animWeights["right"], 0.2, 1);
	
	animscripts\shared::DoNoteTracksForTime( 0.2, "runanim" );
	
	self thread DontCQBTrackUnlessWeMoveCQBAgain();
}

CQBTracking()
{
	self notify("want_cqb_tracking");
	
	if ( isdefined( self.cqb_track_thread ) )
		return;
	self.cqb_track_thread = true;
	
	self endon("killanimscript");
	self endon("end_cqb_tracking");
	
	self.rightAimLimit = 45;
	self.leftAimLimit = -45;
	self.upAimLimit = 45;
	self.downAimLimit = -45;
	
	self setAnimLimited( %walk_aim_2 );
	self setAnimLimited( %walk_aim_4 );
	self setAnimLimited( %walk_aim_6 );
	self setAnimLimited( %walk_aim_8 );
	
	self.shootEnt = undefined;
	self.shootPos = undefined;
	
	if ( animscripts\move::MayShootWhileMoving() )
	{
		self thread CQBDecideWhatAndHowToShoot();
		self thread CQBShootWhileMoving();
	}
	self trackLoop( %w_aim_2, %w_aim_4, %w_aim_6, %w_aim_8 );
}
CQBDecideWhatAndHowToShoot()
{
	self endon("killanimscript");
	self endon("end_cqb_tracking");
	self animscripts\shoot_behavior::decideWhatAndHowToShoot( "normal" );
}
CQBShootWhileMoving()
{
	self endon("killanimscript");
	self endon("end_cqb_tracking");
	self animscripts\move::shootWhileMoving();
}
DontCQBTrackUnlessWeMoveCQBAgain()
{
	self endon("killanimscript");
	self endon("want_cqb_tracking");
	
	wait .05;
	
	self notify("end_cqb_tracking");
	self.cqb_track_thread = undefined;
}

setupCQBPointsOfInterest()
{
	level.cqbPointsOfInterest = [];
	pointents = getEntArray( "cqb_point_of_interest", "targetname" );
	for ( i = 0; i < pointents.size; i++ )
	{
		level.cqbPointsOfInterest[i] = pointents[i].origin;
		pointents[i] delete();
	}
}

findCQBPointsOfInterest()
{
	if ( isdefined( anim.findingCQBPointsOfInterest ) )
		return;
	anim.findingCQBPointsOfInterest = true;
	
	// one AI per frame, find best point of interest.
	if ( !level.cqbPointsOfInterest.size )
		return;
	
	while(1)
	{
		ai = getaiarray();
		waited = false;
		for ( i = 0; i < ai.size; i++ )
		{
			if ( isAlive( ai[i] ) && ai[i] isCQBWalking() )
			{
				moving = ( ai[i].a.movement != "stop" );
				
				// if you change this, change the debug function below too
				
				shootAtPos = ai[i] getShootAtPos();
				lookAheadPoint = shootAtPos;
				forward = anglesToForward( ai[i].angles );
				if ( moving )
				{
					trace = bulletTrace( lookAheadPoint, lookAheadPoint + forward * 128, false, undefined );
					lookAheadPoint = trace["position"];
				}
				
				best = -1;
				bestdist = 1024*1024;
				for ( j = 0; j < level.cqbPointsOfInterest.size; j++ )
				{
					point = level.cqbPointsOfInterest[j];
					
					dist = distanceSquared( point, lookAheadPoint );
					if ( dist < bestdist )
					{
						if ( moving )
						{
							if ( distanceSquared( point, shootAtPos ) < 64 * 64 )
								continue;
							dot = vectorDot( vectorNormalize(point - shootAtPos), forward );
							if ( dot < 0.643 || dot > 0.966 ) // 0.643 = cos(50), 0.966 = cos(15)
								continue;
						}
						else
						{
							if ( dist < 50 * 50 )
								continue;
						}
						
						if ( !sightTracePassed( lookAheadPoint, point, false, undefined ) )
							continue;
						
						bestdist = dist;
						best = j;
					}
				}
				
				if ( best < 0 )
					ai[i].cqb_point_of_interest = undefined;
				else
					ai[i].cqb_point_of_interest = level.cqbPointsOfInterest[best];
				
				wait .05;
				waited = true;
			}
		}
		if ( !waited )
			wait .25;
	}
}

/#
CQBDebug()
{
	self notify("end_cqb_debug");
	self endon("end_cqb_debug");
	self endon("death");
	
	if ( getdvar("scr_cqbdebug") == "" )
		setdvar("scr_cqbdebug", "off");
	
	level thread CQBDebugGlobal();
	
	while(1)
	{
		if ( getdebugdvar("scr_cqbdebug") == "on" || getdebugdvarint("scr_cqbdebug") == self getentnum() )
		{
			if ( isdefined( self.shootPos ) )
			{
				line( self getShootAtPos(), self.shootPos, (1,1,1) );
				print3d( self.shootPos, "shootPos", (1,1,1), 1, 0.5 );
			}
			else if ( isdefined( self.cqb_target ) )
			{
				line( self getShootAtPos(), self.cqb_target.origin, (.5,1,.5) );
				print3d( self.cqb_target.origin, "cqb_target", (.5,1,.5), 1, 0.5 );
			}
			else
			{
				moving = ( self.a.movement != "stop" );
				
				forward = anglesToForward( self.angles );
				shootAtPos = self getShootAtPos();
				lookAheadPoint = shootAtPos;
				if ( moving )
				{
					lookAheadPoint += forward * 128;
					line( shootAtPos, lookAheadPoint, (0.7,.5,.5) );
					
					right = anglesToRight( self.angles );
					leftScanArea  = shootAtPos + (forward * 0.643 - right) * 64;
					rightScanArea = shootAtPos + (forward * 0.643 + right) * 64;
					line( shootAtPos, leftScanArea , (0.5,0.5,0.5), 0.7 );
					line( shootAtPos, rightScanArea, (0.5,0.5,0.5), 0.7 );
				}

				if ( isdefined( self.cqb_point_of_interest ) )
				{
					line( lookAheadPoint, self.cqb_point_of_interest, (1,.5,.5) );
					print3d( self.cqb_point_of_interest, "cqb_point_of_interest", (1,.5,.5), 1, 0.5 );
				}
			}
			
			wait .05;
			continue;
		}
		
		wait 1;
	}
}

CQBDebugGlobal()
{
	if ( isdefined( level.cqbdebugglobal ) )
		return;
	level.cqbdebugglobal = true;
	
	while(1)
	{
		if ( getdebugdvar("scr_cqbdebug") != "on" )
		{
			wait 1;
			continue;
		}
		
		for ( i = 0; i < level.cqbPointsOfInterest.size; i++ )
		{
			print3d( level.cqbPointsOfInterest[i], ".", (.7,.7,1), .7, 3 );
		}
		
		wait .05;
	}
}
#/

