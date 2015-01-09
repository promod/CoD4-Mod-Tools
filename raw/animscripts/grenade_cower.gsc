#include animscripts\Utility;
#using_animtree ("generic_human");

main ( )
{
    self trackScriptState( "GrenadeCower Main", "code" );
	self endon("killanimscript");
	animscripts\utility::initialize("grenadecower");
	
	if ( self.a.pose == "prone" )
	{
		// TODO: use an i-just-dived loop?
		
		animscripts\stop::main();
		return;	// Should never get to here
	}
	
	self AnimMode( "zonly_physics" );
	self OrientMode( "face angle", self.angles[1] );
	
	grenadeAngle = 0;

	assert( isdefined( self.grenade ) );
	if ( isdefined( self.grenade ) ) // failsafe
	{
		grenadeAngle = AngleClamp180( vectorToAngles( self.grenade.origin - self.origin )[1] - self.angles[1] );
	}
	
	if ( self.a.pose == "stand" )
	{
		if ( TryDive( grenadeAngle ) )
			return;
		
		self setFlaggedAnimKnobAllRestart( "cowerstart", %exposed_squat_down_grenade_F, %body, 1, 0.2 );
		self animscripts\shared::DoNoteTracks( "cowerstart" );
	}
	self.a.pose = "crouch";
	self.a.movement = "stop";
	
	self setFlaggedAnimKnobAllRestart( "cower", %exposed_squat_idle_grenade_F, %body, 1, 0.2 );
	self animscripts\shared::DoNoteTracks( "cower" );
	
	self waittill( "never" );
}

TryDive( grenadeAngle )
{
	diveAnim = undefined;
	if ( abs( grenadeAngle ) > 90 )
	{
		// grenade behind us
		diveAnim = %exposed_dive_grenade_B;
	}
	else
	{
		// grenade in front of us
		diveAnim = %exposed_dive_grenade_F;
	}
	
	// when the dives are split into a dive, idle, and get up,
	// maybe we can get a better point to do the moveto check with
	moveBy = getMoveDelta( diveAnim, 0, 0.5 );
	diveToPos = self localToWorldCoords( moveBy );
	
	if ( !self MayMoveToPoint( diveToPos ) )
		return false;
	
	self setFlaggedAnimKnobAllRestart( "cowerstart", diveAnim, %body, 1, 0.2 );
	self animscripts\shared::DoNoteTracks( "cowerstart" );
	
	return true;
}

/*
// obsolete, just keeping this around in case i want it later
StopCowering()
{
	if ( self.a.script == "pain" || self.a.script == "death" )
	{
		self.a.StopCowering = animscripts\init::DoNothing;
		return;
	}
	if (self.a.grenadeCowerSide == "left")
	{
		hideloop =		%grenadehide_left;
		hide2crouch =	%grenadehide_left2crouch;
	}
	else
	{
		hideloop =		%grenadehide_right;
		hide2crouch =	%grenadehide_right2crouch;
	}

	self setAnimKnoball(hideloop, %body, 1, .4, 1);
	wait ( randomfloat(0.25) );	// NB This will wait up to but not including 0.25 seconds.
	self setFlaggedAnimKnoballRestart("hideanim",hide2crouch, %body, 1, .4, 1);
	self.a.pose = "crouch";
	self.a.StopCowering = animscripts\init::DoNothing;
}
*/
