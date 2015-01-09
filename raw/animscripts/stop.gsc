// "Stop" makes the character not walk, run or fight.  He can be standing, crouching or lying 
// prone; he can be alert or idle. 

#include animscripts\combat_utility;
#include animscripts\Utility;
#include animscripts\SetPoseMovement; 
#using_animtree ("generic_human");

main()
{
	self notify("stopScript");
	self endon("killanimscript");
	/#
	if (getdebugdvar("anim_preview") != "")
		return;
	#/

	[[ self.exception[ "stop_immediate" ] ]]();
	// We do the exception_stop script a little late so that the AI has some animation they're playing
	// otherwise they'd go into basepose.
	thread delayedException();

	self trackScriptState( "Stop Main", "code" );
	animscripts\utility::initialize("stop");
	
	self randomizeIdleSet();
	
	self thread setLastStoppedTime();
	
	transitionedToIdle = gettime() < 3000;
	if ( !transitionedToIdle )
	{
		if ( self.a.weaponPos["right"] == "none" && self.a.weaponPos["left"] == "none" )
			transitionedToIdle = true;
		else if ( AngleClamp180( self getTagAngles( "tag_weapon" )[0] ) > 20 )
			transitionedToIdle = true;
	}
	
	for(;;)
	{
		desiredPose = getDesiredIdlePose();
		
		if ( desiredPose == "prone" )
		{
			transitionedToIdle = true;
			self ProneStill();
		}
		else
		{
			assertex( desiredPose == "crouch" || desiredPose == "stand", desiredPose );
			
			if ( self.a.pose != desiredPose )
			{
				self clearAnim( %root, 0.3 );
				transitionedToIdle = false;
			}
			self SetPoseMovement( desiredPose, "stop" );
			
			if ( !transitionedToIdle )
			{
				self transitionToIdle( desiredPose, self.a.idleSet );
				transitionedToIdle = true;
			}
			else
			{
				self playIdle( desiredPose, self.a.idleSet );
			}
		}
	}
}

setLastStoppedTime()
{
	self endon("death");
	self waittill("killanimscript");
	self.lastStoppedTime = gettime();
}

getDesiredIdlePose()
{
	myNode = animscripts\utility::GetClaimedNode();
	if ( isDefined( myNode ) )
	{
		myNodeAngle = myNode.angles[1];
		myNodeType = myNode.type;
	}
	else
	{
		myNodeAngle = self.desiredAngle;
		myNodeType = "node was undefined";
	}
	
	self animscripts\face::SetIdleFace(anim.alertface);

	// Find out if we should be standing, crouched or prone
	desiredPose = animscripts\utility::choosePose();

	if ( myNodeType == "Cover Stand" || myNodeType == "Conceal Stand" )
	{
		// At cover_stand nodes, we don't want to crouch since it'll most likely make our gun go through the wall.
		desiredPose = animscripts\utility::choosePose("stand");
	}
	else if ( myNodeType == "Cover Crouch" || myNodeType == "Conceal Crouch")
	{
		// We should crouch at concealment crouch nodes.
		desiredPose = animscripts\utility::choosePose("crouch");
	}
	else if ( myNodeType == "Cover Prone" || myNodeType == "Conceal Prone" )
	{
		// We should go prone at prone nodes.
		desiredPose = animscripts\utility::choosePose("prone");
	}
	
	return desiredPose;
}

transitionToIdle( pose, idleSet )
{
	if ( self isCQBWalking() && self.a.pose == "stand" && self IsInCombat() )
		pose = "stand_cqb";
	
	if ( isdefined( anim.idleAnimTransition[pose] ) )
	{
		assert( isdefined( anim.idleAnimTransition[pose]["in"] ) );
		
		idleAnim = anim.idleAnimTransition[pose]["in"];
		self setFlaggedAnimKnobAllRestart( "idle_transition", idleAnim, %body, 1, .3, self.animplaybackrate );
		self animscripts\shared::DoNoteTracks ("idle_transition");
	}
}

playIdle( pose, idleSet )
{
	if ( self isCQBWalking() && self.a.pose == "stand" && self IsInCombat() )
		pose = "stand_cqb";
	
	idleSet = idleSet % anim.idleAnimArray[pose].size;
	
	idleAnim = anim_array( anim.idleAnimArray[pose][idleSet], anim.idleAnimWeights[pose][idleSet] );
	
	transTime = 0.2;
	if ( gettime() == self.a.scriptStartTime )
		transTime = 0.5;
	
	self setFlaggedAnimKnobAllRestart( "idle", idleAnim, %body, 1, transTime, self.animplaybackrate );
	self animscripts\shared::DoNoteTracks ("idle");
}

ProneStill()
{
	if ( self.a.pose != "prone" )
	{
		anim_array["stand_2_prone"] = %stand_2_prone;
		anim_array["crouch_2_prone"] = %crouch_2_prone;
		
		transAnim = anim_array[ self.a.pose + "_2_prone" ];
		assertex( isdefined( transAnim ), self.a.pose );
		assert( animHasNotetrack( transAnim, "anim_pose = \"prone\"" ) );
		
		self setFlaggedAnimKnobAllRestart( "trans", transAnim, %body, 1, .2, 1.0 );
		animscripts\shared::DoNoteTracks( "trans" );
		
		assert( self.a.pose == "prone" );
		self.a.movement = "stop";
		
		self setProneAnimNodes( -45, 45, %prone_legs_down, %exposed_modern, %prone_legs_up );
		
		return; // in case we need to change our pose again for whatever reason
	}
	
	self thread UpdateProneThread();
	
	if ( randomint(10) < 3 )
	{
		twitches = [];
		twitches[0] = %prone_twitch_ammocheck;
		twitches[1] = %prone_twitch_ammocheck2;
		twitches[2] = %prone_twitch_look;
		twitches[3] = %prone_twitch_lookfast;
		twitches[4] = %prone_twitch_lookup;
		twitches[5] = %prone_twitch_scan;
		twitches[6] = %prone_twitch_scan2;
		
		twitchAnim = twitches[ randomint( twitches.size ) ];
		self setFlaggedAnimKnobAll( "prone_idle", twitchAnim, %exposed_modern, 1, 0.2 );
	}
	else
	{
		self setAnimKnobAll( %prone_aim_5, %exposed_modern, 1, 0.2 );
		self setFlaggedAnimKnob( "prone_idle", %prone_idle, 1, 0.2 ); // (additive idle on top)
	}
	self waittillmatch( "prone_idle", "end" );
	
	self notify( "kill UpdateProneThread" );
}

UpdateProneThread()
{
	self endon( "killanimscript" );
	self endon( "kill UpdateProneThread" );
	
	for (;;)
	{
		self animscripts\cover_prone::UpdateProneWrapper( 0.1 );
		wait 0.1;
	}
}

delayedException()
{
	self endon("killanimscript");
	wait (0.05);
	[[ self.exception[ "stop" ] ]]();
}
