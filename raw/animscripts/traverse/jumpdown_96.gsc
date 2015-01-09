#include animscripts\utility;
#include animscripts\traverse\shared;
#using_animtree ("generic_human");

main()
{
	if ( self.type == "human" )
		low_wall_human();
	else if ( self.type == "dog" )
		dog_jump_down( 96, 7 );
}

low_wall_human()
{
	traverseData = [];
	traverseData[ "traverseAnim" ]			= %traverse_jumpdown_96;
	
	DoTraverse( traverseData );
}
