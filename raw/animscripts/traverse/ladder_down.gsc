// ladder_down.gsc
// Climbs down a ladder of any height by using a looping animation.

#using_animtree ("generic_human");

main()
{
	// do not do code prone in this script
	self.desired_anim_pose = "crouch";
	animscripts\utility::UpdateAnimPose();
	
	self endon("killanimscript");
	self traverseMode("nogravity");
	self traverseMode("noclip");

	// First, get on
	endnode = self getnegotiationendnode();
	assert( isdefined( endnode ) );
	endPos = endnode.origin;
	//("ladder_down: about to start climbing.  Height to climb: " + (endPos[2] - self.origin[2]) );#/

    // orient to the Negotiation start node
    startnode = self getnegotiationstartnode();
    assert( isdefined( startnode ) );
    self OrientMode( "face angle", startnode.angles[1] );

	self setFlaggedAnimKnoballRestart("climbanim",%ladder_climbon, %body, 1, .1, 1);
	self animscripts\shared::DoNoteTracks("climbanim");

	// Now do the cycle
	climbAnim = %ladder_climbdown;
	self setFlaggedAnimKnoballRestart("climbanim",climbAnim, %body, 1, .1, 1);

	cycleDelta = GetMoveDelta (climbAnim, 0, 1);
	climbRate = cycleDelta[2] /  getanimlength(climbAnim);
	climbingTime = ( endPos[2] - self.origin[2] ) / climbRate;

	self animscripts\shared::DoNoteTracksForTime(climbingTime, "climbanim");

	self traverseMode("gravity");
	self.a.movement = "stop";
	self.a.pose = "stand";
	self.a.alertness = "alert";
	//("ladder_down: all done");#/
}
