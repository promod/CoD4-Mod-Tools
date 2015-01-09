#include maps\_utility;
#include common_scripts\utility;


PlayerJavelinAds()
{
	if ( level.player playerads() < 1.0 )
		return false;
	
	weap = level.player getCurrentWeapon();
	if ( weap != "javelin" )
		return false;

	return true;
}


InsideJavelinReticleNoLock( target )
{
	//TODO: sighttrace
	return target_isinrect( target, level.player, 25, 60, 30 );
}


InsideJavelinReticleLocked( target )
{
	//TODO: sighttrace
	return target_isinrect( target, level.player, 25, 90, 45 );
}


ClearCLUTarget()
{
	level.player notify( "javelin_clu_cleartarget" );
	level.player notify( "stop_lockon_sound" );
	level.javelinLockStartTime = 0;
	level.javelinLockStarted = false;
	level.javelinLockFinalized = false;
	level.javelinTarget = undefined;
	level.player WeaponLockFree();
	level.player WeaponLockTargetTooClose( false );
	level.player WeaponLockNoClearance( false );
	level.player StopLocalSound( "javelin_clu_lock" );
	level.player StopLocalSound( "javelin_clu_aquiring_lock" );
}


GetBestJavelinTarget()
{
	targetsAll = target_getArray();
	targetsValid = [];

	for ( idx = 0; idx < targetsAll.size; idx++ )
	{
		if ( InsideJavelinReticleNoLock( targetsAll[idx] ) )
			targetsValid[targetsValid.size] = targetsAll[idx];
			
		target_setOffscreenShader( targetsAll[idx], "javelin_hud_target_offscreen" );
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


IsStillValidTarget( ent )
{
	if ( ! isDefined( ent ) )
		return false;
	if ( ! target_isTarget( ent ) )
		return false;
	if ( ! InsideJavelinReticleLocked( ent ) )
		return false;

	return true;
}


SetTargetTooClose( ent )
{
	MINIMUM_JAV_DISTANCE = 1000;

	if ( ! isDefined( ent ) )
		return false;
	dist = Distance2D( level.player.origin, ent.origin );
	
	//PrintLn( "Jav Distance: ", dist );
	
	if ( dist < MINIMUM_JAV_DISTANCE )
		level.player WeaponLockTargetTooClose( true );
	else
		level.player WeaponLockTargetTooClose( false );
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
}


JavelinCLULoop()
{
	level.player endon( "death" );
	level.player endon( "javelin_clu_off" );

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

		clipAmmo = level.player GetCurrentWeaponClipAmmo();
		if ( !clipAmmo )
		{
			ClearCLUTarget();
			continue;
		}

		if ( level.javelinLockFinalized )
		{
			if ( ! IsStillValidTarget( level.javelinTarget ) )
			{
				ClearCLUTarget();
				continue;
			}
			SetTargetTooClose( level.javelinTarget );
			SetNoClearance();
			//print3D( level.javelinTarget.origin, "* LOCKED!", (.2, 1, .3), 1, 5 );
			continue;
		}

		if ( level.javelinLockStarted )
		{
			if ( ! IsStillValidTarget( level.javelinTarget ) )
			{
				ClearCLUTarget();
				continue;
			}

			//print3D( level.javelinTarget.origin, "* locking...!", (.2, 1, .3), 1, 5 );

			timePassed = getTime() - level.javelinLockStartTime;
			if ( timePassed < LOCK_LENGTH )
				continue;

			assert( isdefined( level.javelinTarget ) );
			level.player notify( "stop_lockon_sound" );
			level.javelinLockFinalized = true;
			level.player WeaponLockFinalize( level.javelinTarget );
			level.player PlayLocalSound( "javelin_clu_lock" );
			SetTargetTooClose( level.javelinTarget );
			SetNoClearance();
			continue;
		}
		
		bestTarget = GetBestJavelinTarget();
		if ( !isDefined( bestTarget ) )
			continue;

		level.javelinTarget = bestTarget;
		level.javelinLockStartTime = getTime();
		level.javelinLockStarted = true;
		level.player WeaponLockStart( bestTarget );
		thread LoopLocalSeekSound( "javelin_clu_aquiring_lock", 0.6 );
	}
}


JavelinToggleLoop()
{
	level.player endon ( "death" );
	
	for (;;)
	{
		while( ! PlayerJavelinAds() )
			wait 0.05;
		thread JavelinCLULoop();

		while( PlayerJavelinAds() )
			wait 0.05;
		level.player notify( "javelin_clu_off" );
		ClearCLUTarget();
	}
}


TraceConstantTest()
{
	for (;;)
	{
		wait 0.05;
		SetNoClearance();
	}
}

init()
{
	precacheShader( "javelin_hud_target_offscreen" );

	ClearCLUTarget();
	
	SetSavedDvar( "vehHudTargetSize", 50 );
	SetSavedDvar( "vehHudTargetScreenEdgeClampBufferLeft", 120 );
	SetSavedDvar( "vehHudTargetScreenEdgeClampBufferRight", 126 );
	SetSavedDvar( "vehHudTargetScreenEdgeClampBufferTop", 139 );	
	SetSavedDvar( "vehHudTargetScreenEdgeClampBufferBottom", 134 );	

	thread JavelinToggleLoop();
	//thread TraceConstantTest();
}


LoopLocalSeekSound( alias, interval )
{
	level.player endon ( "stop_lockon_sound" );
	
	for (;;)
	{
		level.player PlayLocalSound( alias );
		wait interval;
	}
}
