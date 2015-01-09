#include animscripts\utility;
#include animscripts\traverse\shared;
#using_animtree ("generic_human");

main()
{
	if ( self.type == "human" )
		low_wall_human();
	else if ( self.type == "dog" )
		dog_wall_and_window_hop( "window_40", 40 );
}

low_wall_human()
{
	traverseData = [];
	traverseData[ "traverseAnim" ]			= %traverse40;
	traverseData[ "traverseToCoverAnim" ]	= %traverse40_2_cover;
	traverseData[ "coverType" ]				= "Cover Crouch";
	traverseData[ "traverseHeight" ]		= 40.0;
	traverseData[ "interruptDeathAnim" ][0]	= array( %traverse40_death_start, %traverse40_death_start_2 );
	traverseData[ "interruptDeathAnim" ][1]	= array( %traverse40_death_end, %traverse40_death_end_2 );
	
	DoTraverse( traverseData );
}
