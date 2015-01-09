#include animscripts\traverse\shared;

// step_up.gsc
// Makes the character step up onto a ledge.  Currently the ledge is assumed to be 36 units.

#using_animtree ("generic_human");

main()
{
	if ( self.type == "human" )
		step_up_human();
	else if ( self.type == "dog" )
		dog_jump_up( 40, 3 );
}

step_up_human()
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

	
	self setFlaggedAnimKnoballRestart("stepanim",%step_up_low_wall, %body, 1, .1, 1);
	self waittillmatch("stepanim", "gravity on");
	self traverseMode("gravity");
	self animscripts\shared::DoNoteTracks("stepanim");
	self setAnimKnobAllRestart( animscripts\run::GetCrouchRunAnim(), %body, 1, 0.1, 1 );
}

