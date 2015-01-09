#include animscripts\traverse\shared;
// jump_down_96.gsc
// Makes the character jump down off a ledge.  Designed for 96 units but should work for 70-110 or so.
main()
{
	if ( self.type == "human" )
		jump_down_human();
	else if ( self.type == "dog" )
		dog_jump_down( 96, 7 );
}


#using_animtree ("generic_human");

jump_down_human()
{
	// do not do code prone in this script
	self.desired_anim_pose = "crouch";
	animscripts\utility::UpdateAnimPose();
	
	self endon("killanimscript");
	self.a.movement = "walk";
	self.a.alertness = "alert";
	self traverseMode("nogravity");
	
	// orient to the Negotiation start node
    startnode = self getnegotiationstartnode();
    assert( isdefined( startnode ) );
    self OrientMode( "face angle", startnode.angles[1] );

	self setFlaggedAnimKnoballRestart("stepanim",%jump_down_96, %body, 1, .1, 1);
	self waittillmatch("stepanim", "gravity on");
	self traverseMode("gravity");
	self animscripts\shared::DoNoteTracks("stepanim");
	self.a.pose = "crouch";
//	self setAnimKnobAllRestart(%crouch_fastwalk_F, %body, 1, 0.1, 1);
}
