main( shoot, recover, aim, turret )
{
	self endon( "killanimscript" ); // code
 
    animscripts\utility::initialize( "technical" );

	self.a.special = "technical";

	if ( isDefined( turret.script_delay_min ) )
		turret_delay = turret.script_delay_min;
	else
		turret_delay = maps\_mgturret::burst_fire_settings( "delay" );

	if ( isDefined( turret.script_delay_max ) ) 
		turret_delay_range = turret.script_delay_max - turret_delay;
	else
		turret_delay_range = maps\_mgturret::burst_fire_settings( "delay_range" );

	if ( isDefined( turret.script_burst_min ) )
		turret_burst = turret.script_burst_min;
	else
		turret_burst = maps\_mgturret::burst_fire_settings ( "burst" );

	if ( isDefined( turret.script_burst_max ) ) 
		turret_burst_range = turret.script_burst_max - turret_burst;
	else
		turret_burst_range = maps\_mgturret::burst_fire_settings ( "burst_range" );

	pauseUntilTime = getTime();
	turretState = "start";
	
	self animscripts\shared::placeWeaponOn( self.weapon, "none" );
	self.a.postScriptFunc = ::preplacedPostScriptFunc;

	for (;;)
	{
		duration = (pauseUntilTime - getTime()) * 0.001;
		if ( turret isFiringTurret() && (duration <= 0) )
		{
			if (turretState != "fire")
			{
				turretState = "fire";
				thread [[shoot]]( turret ); // non blocking
			}

			duration = turret_burst + randomFloat( turret_burst_range );

			thread turretTimer( duration, turret );



			turret waittill( "turretstatechange" ); // code or script

			duration = turret_delay + randomFloat( turret_delay_range );

			pauseUntilTime = getTime() + int(duration * 1000);

			if ( isDefined( recover ) )
			{
				turretState = "recover";
				[[recover]]( turret ); // blocking
			}
		}
		else
		{
			if ( turretState != "aim" )
			{
				turretState = "aim";
				thread [[aim]]( turret ); // non blocking
			}
			
			thread turretTimer( duration, turret );

			turret waittill( "turretstatechange" ); // code or script
		}
	}
}


turretTimer( duration, turret )
{
	if (duration <= 0)
		return;

	self endon( "killanimscript" ); // code
	turret endon( "turretstatechange" ); // code

	wait ( duration );
	turret notify( "turretstatechange" );
}


preplacedPostScriptFunc( animscript )
{
	self animscripts\shared::placeWeaponOn( self.weapon, "right" );
}
