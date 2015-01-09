#using_animtree ("dog");

main()
{
	self endon("killanimscript");
	if ( isdefined( self.a.nodeath ) )
	{
		assertex( self.a.nodeath, "Nodeath needs to be set to true or undefined." );
		
		// allow death script to run for a bit so it doesn't turn to corpse and get deleted too soon during melee sequence
		wait 3;
		return;
	}

	self unlink();

	if ( isdefined( self.enemy ) && isdefined( self.enemy.syncedMeleeTarget ) && self.enemy.syncedMeleeTarget == self )
	{
		self.enemy.syncedMeleeTarget = undefined;
	}

	self clearanim(%root, 0.2);
	self setflaggedanimrestart("dog_anim", %german_shepherd_death_front, 1, 0.2, 1);
	self animscripts\shared::DoNoteTracks( "dog_anim" );
}
