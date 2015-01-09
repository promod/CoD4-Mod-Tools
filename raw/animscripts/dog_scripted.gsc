#using_animtree( "dog" );

main()
{
	self endon( "death" );
	self notify( "killanimscript" );

	self.codeScripted[ "root" ] = %root;	// TEMP!

    self trackScriptState( "Scripted Main", "code" );
	self endon( "end_sequence" );
	self startscriptedanim( self.codeScripted[ "notifyName" ], self.codeScripted[ "origin" ], self.codeScripted[ "angles" ], self.codeScripted[ "anim" ], self.codeScripted[ "animMode" ], self.codeScripted[ "root" ]);

	self.a.script = "scripted";
	self.codeScripted = undefined;

	if ( isdefined( self.deathstring_passed ) )
		self.deathstring = self.deathstring_passed;

	self waittill( "killanimscript" );
}

init( notifyName, origin, angles, theAnim, animMode, root )
{
	self.codeScripted[ "notifyName" ] = notifyName;
	self.codeScripted[ "origin" ] = origin;
	self.codeScripted[ "angles" ] = angles;
	self.codeScripted[ "anim" ] = theAnim;
	if ( isDefined( animMode ) )
		self.codeScripted[ "animMode" ] = animMode;
	else
		self.codeScripted[ "animMode" ] = "normal";
	if ( isDefined( root ) )
		self.codeScripted[ "root" ] = root;
	else
		self.codeScripted[ "root" ] = %root;
}
