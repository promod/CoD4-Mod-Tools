main()
{
	self endon( "death" );
	self endon( "stop_first_frame" );
	self notify( "killanimscript" );
	self.pushable = 0;

    self clearAnim( self.root_anim, 0.3 );
//	self setAnim( %body, 1, 0 );	// The %body node should always have weight 1.

	self OrientMode( "face angle", self.angles[ 1 ] );

	self setanim( level.scr_anim[ self._animname ][ self._first_frame_anim ], 1, 0, 0 );
	self._first_frame_anim = undefined;
	
	self waittill( "killanimscript" );
}