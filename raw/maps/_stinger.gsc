#include maps\_utility;
#include common_scripts\utility;

init()
{
	precacherumble ( "stinger_lock_rumble" );

	ClearIRTarget();

	thread StingerToggleLoop();
	//thread TraceConstantTest();
	level.player thread StingerFiredNotify();
}

ClearIRTarget()
{
	level.player notify( "stinger_irt_cleartarget" );
	level.player notify( "stop_lockon_sound" );
	level.player notify( "stop_locked_sound" );
	level.player.stingerlocksound = undefined;
	level.player StopRumble( "stinger_lock_rumble" );

	level.stingerLockStartTime = 0;
	level.stingerLockStarted = false;
	level.stingerLockFinalized = false;
	level.stingerTarget = undefined;

	level.player WeaponLockFree();
	level.player WeaponLockTargetTooClose( false );
	level.player WeaponLockNoClearance( false );

	level.player StopLocalSound( "javelin_clu_lock" );
	level.player StopLocalSound( "javelin_clu_aquiring_lock" );
}


StingerFiredNotify()
{
	while ( true )
	{
		level.player waittill( "weapon_fired" );

		weap = level.player getCurrentWeapon();
		if ( weap != "stinger" )
			continue;

		level.player notify( "stinger_fired" );
	}
}


StingerToggleLoop()
{
	level.player endon ( "death" );
	
	for (;;)
	{
		while( ! PlayerStingerAds() )
			wait 0.05;

		thread StingerIRTLoop();

		while( PlayerStingerAds() )
			wait 0.05;
		level.player notify( "stinger_IRT_off" );
		ClearIRTarget();
	}
}

StingerIRTLoop()
{
	level.player endon( "death" );
	level.player endon( "stinger_IRT_off" );

	LOCK_LENGTH = 2000;

	for (;;)
	{
		wait 0.05;

		//-------------------------
		// Four possible states:
		//      No missile in the tube, so CLU will not search for targets.
		//		CLU has a lock.
		//		CLU is locking on to a target.
		//		CLU is searching for a target to begin locking on to.
		//-------------------------

/*
		clipAmmo = level.player GetCurrentWeaponClipAmmo();
		if ( !clipAmmo )
		{
			ClearCLUTarget();
			continue;
		}
*/

		if ( level.stingerLockFinalized )
		{
			if ( ! IsStillValidTarget( level.stingerTarget ) )
			{
				ClearIRTarget();
				continue;
			}

			thread LoopLocalLockSound( "javelin_clu_lock", 0.75 );

			SetTargetTooClose( level.stingerTarget );
			SetNoClearance();
			//print3D( level.javelinTarget.origin, "* LOCKED!", (.2, 1, .3), 1, 5 );
			continue;
		}

		if ( level.stingerLockStarted )
		{
			if ( ! IsStillValidTarget( level.stingerTarget ) )
			{
				ClearIRTarget();
				continue;
			}

			//print3D( level.javelinTarget.origin, "* locking...!", (.2, 1, .3), 1, 5 );

			timePassed = getTime() - level.stingerLockStartTime;
			if ( timePassed < LOCK_LENGTH )
				continue;

			assert( isdefined( level.stingerTarget ) );
			level.player notify( "stop_lockon_sound" );
			level.stingerLockFinalized = true;
			level.player WeaponLockFinalize( level.stingerTarget );
			SetTargetTooClose( level.stingerTarget );
			SetNoClearance();

			continue;
		}
		
		bestTarget = GetBestStingerTarget();
		if ( !isDefined( bestTarget ) )
			continue;

		level.stingerTarget = bestTarget;
		level.stingerLockStartTime = getTime();
		level.stingerLockStarted = true;

		// most likely I don't need this for the stinger.
		// level.player WeaponLockStart( bestTarget );

		thread LoopLocalSeekSound( "javelin_clu_aquiring_lock", 0.6 );
	}
}

GetBestStingerTarget()
{
	targetsAll = target_getArray();
	targetsValid = [];

	for ( idx = 0; idx < targetsAll.size; idx++ )
	{
		if ( InsideStingerReticleNoLock( targetsAll[idx] ) )
			targetsValid[targetsValid.size] = targetsAll[idx];
	}

	if ( targetsValid.size == 0 )
		return undefined;

	chosenEnt = targetsValid[0];
	if ( targetsValid.size > 1 )
	{
		//TODO: find the closest
	}
	
	return chosenEnt;
}

InsideStingerReticleNoLock( target )
{
//	todo: sight trace dont' work well
//	if ( !sighttracepassed(level.player geteye(), target.origin, true, target) )
//		return false;

	return target_isincircle( target, level.player, 65, 60 );
}

InsideStingerReticleLocked( target )
{
//	todo: sight trace dont' work well
//	if ( !sighttracepassed(level.player geteye(), target.origin, true, target) )
//		return false;

	return target_isincircle( target, level.player, 65, 75 );
}

IsStillValidTarget( ent )
{
	if ( ! isDefined( ent ) )
		return false;
	if ( ! target_isTarget( ent ) )
		return false;
	if ( ! InsideStingerReticleLocked( ent ) )
		return false;

	return true;
}

PlayerStingerAds()
{
	weap = level.player getCurrentWeapon();
	if ( weap != "stinger" )
		return false;

	if ( level.player playerads() == 1.0 )
		return true;

	return false;
}

SetNoClearance()
{
	ORIGINOFFSET_UP = 60;
	ORIGINOFFSET_RIGHT = 10;
	DISTANCE = 400;
	
	COLOR_PASSED = (0,1,0);
	COLOR_FAILED = (1,0,0);

	checks = [];
	checks[0] = ( 0, 0, 80 );
	checks[1] = ( -40, 0, 120 );
	checks[2] = ( 40, 0, 120 );
	checks[3] = ( -40, 0, 40 );
	checks[4] = ( 40, 0, 40 );
	
	if ( GetDVar( "missileDebugDraw" ) == "1" )
		debug = true;
	else
		debug = false;
	
	playerAngles = level.player GetPlayerAngles();
	forward = AnglesToForward( playerAngles );
	right = AnglesToRight( playerAngles );
	up = AnglesToUp( playerAngles );

	origin = level.player.origin + (0,0,ORIGINOFFSET_UP) + right * ORIGINOFFSET_RIGHT;

	obstructed = false;
	for( idx = 0; idx < checks.size; idx++ )
	{
		endpoint = origin + forward * DISTANCE + up * checks[idx][2] + right * checks[idx][0];
		trace = BulletTrace( origin, endpoint, false, undefined );
		
		if ( trace["fraction"] < 1 )
		{
			obstructed = true;
			if ( debug )
				line( origin, trace["position"], COLOR_FAILED, 1 );
			else
				break;
		}
		else
		{
			if ( debug )
				line( origin, trace["position"], COLOR_PASSED, 1 );
		}
	}
	
	level.player WeaponLockNoClearance( obstructed );
	level.player.noclearance = obstructed;

}

SetTargetTooClose( ent )
{
	MINIMUM_STI_DISTANCE = 1000;

	if ( ! isDefined( ent ) )
		return false;
	dist = Distance2D( level.player.origin, ent.origin );
	
	//PrintLn( "Jav Distance: ", dist );
	
	if ( dist < MINIMUM_STI_DISTANCE )
	{
		level.targettoclose = true;
		level.player WeaponLockTargetTooClose( true );
	}
	else
	{
		level.targettoclose = false;
		level.player WeaponLockTargetTooClose( false );
	}

}

LoopLocalSeekSound( alias, interval )
{
	level.player endon ( "stop_lockon_sound" );
	
	for (;;)
	{
		level.player playLocalSound( alias );
		level.player PlayRumbleOnEntity( "stinger_lock_rumble" );

		wait interval;
	}
}

LoopLocalLockSound( alias, interval )
{
	level.player endon ( "stop_locked_sound" );
	
	if ( isdefined( level.player.stingerlocksound ) )
		return;

	level.player.stingerlocksound = true;
	for (;;)
	{
		level.player playLocalSound( alias );
		level.player PlayRumbleOnEntity( "stinger_lock_rumble" );
		wait interval/3;

		level.player PlayRumbleOnEntity( "stinger_lock_rumble" );
		wait interval/3;

		level.player PlayRumbleOnEntity( "stinger_lock_rumble" );
		wait interval/3;

		level.player StopRumble( "stinger_lock_rumble" );
	}
	level.player.stingerlocksound = undefined;
}