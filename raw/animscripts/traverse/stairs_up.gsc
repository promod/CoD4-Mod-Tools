// stairs_up.gsc
// Climbs stairs of any height by using a looping animation, and gets off at the top.

#using_animtree ("generic_human");

main()
{
	// do not do code prone in this script
	self.desired_anim_pose = "crouch";
	animscripts\utility::UpdateAnimPose();
	
	self endon("killanimscript");
	self traverseMode("nogravity");

	if ( self animscripts\utility::weaponAnims() == "none" || self animscripts\utility::weaponAnims() == "pistol" )
		climbAnim = %climbstairs_up;
	else
		climbAnim = %climbstairs_up_armed;

    // orient to the Negotiation start node
    startnode = self getnegotiationstartnode();
    assert( isdefined( startNode ) );
    self OrientMode( "face angle", startnode.angles[1] );

	self setFlaggedAnimKnoballRestart("climbanim",climbAnim, %body, 1, .1, 1);
    
    endnode = self getnegotiationendnode();
    assert( isdefined( endnode ) );
	endPos = self endnode.origin + (0,0,1);	// 1 unit padding
	
	horizontalDelta = ( endPos[0]-self.origin[0] , endPos[1]-self.origin[1] , 0 );
	horizontalDistance = length(horizontalDelta);
	cycleDelta = GetMoveDelta (climbAnim, 0, 1);
	cycleDelta = ( cycleDelta[0] , cycleDelta[1] , 0 );
	cycleHorDist = length (cycleDelta);
	cycleTime = getanimlength(climbAnim);
	climbingTime = ( horizontalDistance / cycleHorDist ) * cycleTime;
	//("stairs_down: about to start climbing.  Horizontal dist: " +horizontalDistance+ ", dist/cycle: "+cycleHorDist+", time/cycle: "+cycleTime+", time to play: "+climbingTime);#/

	self animscripts\shared::DoNoteTracksForTime(climbingTime, "climbanim");

//	self traverseMode("gravity");
	self.a.movement = "walk";
	self.a.pose = "stand";
	self.a.alertness = "alert";
//	self setAnimKnobAllRestart( animscripts\run::GetCrouchRunAnim(), %body, 1, 0.1, 1 );
	//("stairs_up: all done");#/
}

