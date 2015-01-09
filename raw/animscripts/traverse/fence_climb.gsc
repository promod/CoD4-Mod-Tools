// Fence_climb.gsc
// Makes the character climb a 48 unit fence
// TEMP - copied wall dive until we get an animation
// Makes the character dive over a low wall

#using_animtree ("generic_human");

main()
{
	// do not do code prone in this script
	self.desired_anim_pose = "crouch";
	animscripts\utility::UpdateAnimPose();
	
	self.old_anim_movement = self.a.movement;
	self.old_anim_alertness = self.a.alertness;
	
	self endon("killanimscript");
	self traverseMode("nogravity");
	self traverseMode("noclip"); // So he doesn't get stuck if the wall is a little too high
	
	// orient to the Negotiation start node
    startnode = self getnegotiationstartnode();
    assert( isdefined( startnode ) );
    self OrientMode( "face angle", startnode.angles[1] );

	self setFlaggedAnimKnoballRestart("diveanim",%fenceclimb, %body, 1, .1, 1);
//	self waittillmatch("diveanim", "gravity on");
	self animscripts\shared::DoNoteTracks("diveanim");
	self traverseMode("gravity");

	self.a.movement = self.old_anim_movement;
	self.a.alertness = self.old_anim_alertness;

	self setAnimKnobAllRestart( animscripts\run::GetCrouchRunAnim(), %body, 1, 0.1, 1 );
	thread animscripts\run::MakeRunSounds ( "killSoundThread" );
}
