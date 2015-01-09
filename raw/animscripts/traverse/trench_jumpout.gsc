#using_animtree ("generic_human");
main()
{
	// do not do code prone in this script
	self.desired_anim_pose = "crouch";
	animscripts\utility::UpdateAnimPose();
	
	self endon("killanimscript");
	self.a.movement = "walk";
	self.a.alertness = "casual";	
	self traverseMode("nogravity");
	
	// orient to the Negotiation start node
    startnode = self getnegotiationstartnode();
    assert (isdefined( startnode ));
    self OrientMode( "face angle", startnode.angles[1] );
	
	self setFlaggedAnimKnoballRestart("stepanim",%gully_trenchjump, %body, 1, .1, 1);
	self waittillmatch("stepanim", "gravity on");
	self traverseMode("gravity");
	self animscripts\shared::DoNoteTracks("stepanim");
	self setAnimKnobAllRestart( animscripts\run::GetCrouchRunAnim(), %body, 1, 0.1, 1 );
}
