// Jump_across_72.gsc
// Makes the character do a lateral jump of 72 units.

#using_animtree ("generic_human");

main()
{
 	// do not do code prone in this script
	self.desired_anim_pose = "stand";
	animscripts\utility::UpdateAnimPose();
	
	self endon("killanimscript");
	self traverseMode("nogravity");
	self traverseMode("noclip");
	
	// orient to the Negotiation start node
    startnode = self getnegotiationstartnode();
    assert( isdefined( startnode ) );
    self OrientMode( "face angle", startnode.angles[1] );
	
	self setFlaggedAnimKnoballRestart("jumpanim",%jump_across_72, %body, 1, .1, 1);
	self waittillmatch("jumpanim", "gravity on");
	self traverseMode("gravity");
	self animscripts\shared::DoNoteTracks("jumpanim");
	self.a.movement = "run";
	self.a.alertness = "casual";
	self setAnimKnobAllRestart( animscripts\run::GetRunAnim(), %body, 1, 0.2, 1 );
}
