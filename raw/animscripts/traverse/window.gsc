// Window.gsc
// Makes the character climb through a window with a 36 unit high lower edge.
// TEMP - copied wall dive until we get an animation
// Makes the character dive over a low wall

#using_animtree ("generic_human");

main()
{    
	// do not do code prone in this script
	self.desired_anim_pose = "crouch";
	animscripts\utility::UpdateAnimPose();
	
	self endon("killanimscript");
	self traverseMode("nogravity");
	self traverseMode("noclip"); // JBW - hitting window

	// orient to the Negotiation start node
    startnode = self getnegotiationstartnode();
    assert ( isdefined( startnode ) );
    self OrientMode( "face angle", startnode.angles[1] );

	self setFlaggedAnimKnoballRestart("diveanim",%windowclimb, %body, 1, .1, 1);
	self waittillmatch("diveanim", "gravity on");
	self traverseMode("gravity");
	self animscripts\shared::DoNoteTracks("diveanim");
	self.a.movement = "run";
	self.a.alertness = "casual";
	while (self getGroundEntType() == "none")
		wait 0.05;
	self setAnimKnobAllRestart( animscripts\run::GetCrouchRunAnim(), %body, 1, 0.1, 1 );
	thread animscripts\run::MakeRunSounds ( "killSoundThread" );
}
