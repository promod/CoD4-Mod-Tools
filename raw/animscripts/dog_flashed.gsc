#include animscripts\Combat_utility;

#using_animtree ("dog");

main()
{
	self endon( "killanimscript" );
	self endon( "stop_flashbang_effect" );

	wait randomfloatrange( 0, 0.4 );
	
	self clearanim(%root, 0.1);

	duration = self startFlashBanged() * 0.001;
	
	if ( duration > 2 && randomint( 100 ) > 60 )
		self setflaggedanimrestart( "flashed_anim", %german_shepherd_run_pain, 1, 0.2, self.animplaybackrate * 0.75 );
	else
		self setflaggedanimrestart( "flashed_anim", %german_shepherd_run_flashbang, 1, 0.2, self.animplaybackrate );
		
	animLength = getanimlength( %german_shepherd_run_flashbang ) * self.animplaybackrate;
		
	if ( duration < animLength )
		self animscripts\shared::DoNoteTracksForTime( duration, "flashed_anim" );
	else
		self animscripts\shared::DoNoteTracks( "flashed_anim" );

	self setFlashBanged( false );
	self.flashed = false;
	self notify( "stop_flashbang_effect" );
}