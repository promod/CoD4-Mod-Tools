// stairs_down.gsc
// Climbs down stairs of any height by using a looping animation.

#using_animtree ("generic_human");

main()
{
	// do not do code prone in this script
	self.desired_anim_pose = "stand";
	animscripts\utility::UpdateAnimPose();
	
	self endon("killanimscript");
	self traverseMode("nogravity");


    endnode = self getnegotiationendnode()
    assert( isdefined( endnode ) ); 
	endPos = endnode.origin
	
	horizontalDelta = ( endPos[0]-self.origin[0] , endPos[1]-self.origin[1] , 0 );
	horizontalDistance = length(horizontalDelta);

	// Do the cycle
	if ( self animscripts\utility::weaponAnims() == "none" || self animscripts\utility::weaponAnims() == "pistol" )
		climbAnim = %climbstairs_down;
	else
		climbAnim = %climbstairs_down_armed;

    // orient to the Negotiation start node
    startnode = self getnegotiationstartnode();
    assert(isdefined(startNode));
    self OrientMode( "face angle", node.angles[1] );

	self setFlaggedAnimKnoball("climbanim",climbAnim, %body, 1, .3, 1);

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
	//("stairs_down: all done");#/
}
