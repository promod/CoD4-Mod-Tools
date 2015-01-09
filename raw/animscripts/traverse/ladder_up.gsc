// ladder_up.gsc
// Climbs a ladder of any height by using a looping animation, and gets off at the top.

#using_animtree ("generic_human");

main()
{
	// do not do code prone in this script
	self.desired_anim_pose = "crouch";
	animscripts\utility::UpdateAnimPose();
	
	self endon("killanimscript");
//	self traverseMode("nogravity");
	self traverseMode("noclip");

	climbAnim = %ladder_climbup;
	endAnim = %ladder_climboff;

    // orient to the Negotiation start node
    startnode = self getnegotiationstartnode();
    assert( isdefined( startnode ) );
    self OrientMode( "face angle", startnode.angles[1] );

	self setFlaggedAnimKnoballRestart("climbanim",climbAnim, %body, 1, .1, 1);

	endAnimDelta = GetMoveDelta (endAnim, 0, 1);
	
	endNode = self getnegotiationendnode();
	assert( isdefined( endnode ) );
	endPos =  endnode.origin - endAnimDelta + (0,0,1);	// 1 unit padding
	
	cycleDelta = GetMoveDelta (climbAnim, 0, 1);
	climbRate = cycleDelta[2] /  getanimlength(climbAnim);
	//("ladder_up: about to start climbing.  Height to climb: " + (endAnimDelta[2] + endPos[2] - self.origin[2]) );#/

	climbingTime = ( endPos[2] - self.origin[2] ) / climbRate;
	if (climbingTime > 0)
	{
		self animscripts\shared::DoNoteTracksForTime(climbingTime, "climbanim");
//	println ("elapsed ", (gettime() - timer) * 0.001);
		self setFlaggedAnimKnoballRestart("climbanim",endAnim, %body, 1, .1, 1);
		self animscripts\shared::DoNoteTracks("climbanim");
	}
	
	self traverseMode("gravity");
	self.a.movement = "run";
	self.a.pose = "crouch";
	self.a.alertness = "alert";
	self setAnimKnobAllRestart( animscripts\run::GetCrouchRunAnim(), %body, 1, 0.1, 1 );
	//("ladder_up: all done");#/
}

