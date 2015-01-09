#include animscripts\traverse\shared;
#include animscripts\utility;
#include maps\_utility;
#using_animtree ("generic_human");


main()
{
	if ( self.type == "human" )
		slide_across_car_human();
	else if ( self.type == "dog" )
		slide_across_car_dog();
}

slide_across_car_human()
{
	traverseData = [];
	traverseData[ "traverseAnim" ]			= %slide_across_car;
	traverseData[ "traverseToCoverAnim" ]	= %slide_across_car_2_cover;
	traverseData[ "coverType" ]				= "Cover Crouch";
	traverseData[ "traverseHeight" ]		= 38.0;
	traverseData[ "interruptDeathAnim" ][0]	= array( %slide_across_car_death );
	traverseData[ "traverseSound" ] 		= "npc_car_slide_hood";
	traverseData[ "traverseToCoverSound" ]	= "npc_car_slide_cover";
	
	DoTraverse( traverseData );
}

#using_animtree ("dog");

slide_across_car_dog()
{
	self endon("killanimscript");
	self traverseMode("noclip");

	// orient to the Negotiation start node
	startnode = self getnegotiationstartnode();
	assert( isdefined( startnode ) );
	self OrientMode( "face angle", startnode.angles[1] );
	
	self clearanim(%root, 0.1);
	self setflaggedanimrestart( "traverse", anim.dogTraverseAnims["jump_up_40"], 1, 0.1, 1);
	self animscripts\shared::DoNoteTracks( "traverse" );

	// TEMP, can't hear jump over sounds
	self thread play_sound_in_space( "anml_dog_bark", self gettagorigin( "tag_eye" ) );

	self clearanim(%root, 0);
	self setflaggedanimrestart( "traverse", anim.dogTraverseAnims["jump_down_40"], 1, 0, 1);
	self animscripts\shared::DoNoteTracks( "traverse" );

	self traverseMode("gravity");	
	self.traverseComplete = true;
}