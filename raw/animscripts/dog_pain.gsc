#using_animtree ("dog");

main()
{
	self endon("killanimscript");

	if ( isdefined( self.enemy ) && isdefined( self.enemy.syncedMeleeTarget) && self.enemy.syncedMeleeTarget == self )
	{
		self unlink();
		self.enemy.syncedMeleeTarget = undefined;
	}
	
	self clearanim(%root, 0.2);
	self setflaggedanimrestart("dog_pain_anim", %german_shepherd_run_pain, 1, 0.2, 1);
	
	self animscripts\shared::DoNoteTracks( "dog_pain_anim" );
}
