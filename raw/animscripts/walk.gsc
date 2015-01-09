#include animscripts\SetPoseMovement;
#include animscripts\Utility;
#using_animtree ("generic_human");

MoveWalk()
{
	// Decide what pose to use
	desiredPose = self animscripts\utility::choosePose();
	
	switch ( desiredPose )
	{
	case "stand":
		if ( BeginStandWalk() )
			return;

		walkAnim = getStandWalkAnim();
		DoWalkAnim( walkAnim );
		break;
	
	case "crouch":
		if ( BeginCrouchWalk() )
			return;
		
		DoWalkAnim( %crouch_fastwalk_F );
		break;
	
	default:
		assert(desiredPose == "prone");
		if ( BeginProneWalk() )
			return;

		self.a.movement = "walk";
		DoWalkAnim( %prone_crawl );
		break;
	}
}

DoWalkAnim( walkAnim )
{
	self endon("movemode");
	
	self setFlaggedAnimKnobAll( "walkanim", walkAnim, %body, 1, 1.2, 1 );
	if ( self.a.pose != "prone" )
	{
		self animscripts\run::UpdateRunWeightsOnce(
			%combatrun_forward,
			%walk_lowready_B,
			%walk_lowready_L,
			%walk_lowready_R
		);
	}
	
	self animscripts\shared::DoNoteTracksForTime( 0.2, "walkanim" );
}

getStandWalkAnim()
{
	if ( (isDefined(self.walk_combatanim)) && (self animscripts\utility::IsInCombat()) )
	{
		rand = randomint(10);
		if ( (rand < 2) && (isDefined(self.walk_combatanim2)) )
			return self.walk_combatanim2;
		else
			return self.walk_combatanim;
	}
	else if ( (isDefined(self.walk_noncombatanim)) && (!self animscripts\utility::IsInCombat()) )
	{
		rand = randomint(10);
		if ( (rand < 2) && (isDefined(self.walk_noncombatanim2)) )
			return self.walk_noncombatanim2;
		else
			return self.walk_noncombatanim;
	}
	else
	{
		return %walk_lowready_F;
	}
}

