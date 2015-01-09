#include maps\_utility;
#include common_scripts\utility;

globalThink()
{
	if ( !isdefined( self.vehicletype ) )
		return;
	
	isHelicopter = false;
	if ( self.vehicletype == "hind" )
	{
		isHelicopter = true;
	}
	if ( ( self.vehicletype == "cobra" ) || ( self.vehicletype == "cobra_player" ) )
	{
		self thread attachMissiles( "cobra_Hellfire", "cobra_Sidewinder" );
		isHelicopter = true;
	}
	
	if ( !isHelicopter )
		return;
	
	level thread flares_think( self );
	level thread maps\_helicopter_ai::evasive_think( self );
	
	if ( getdvar( "cobrapilot_wingman_enabled") == "1" )
	{
		if ( isdefined( self.script_wingman ) )
		{
			level.wingman = self;
			level thread maps\_helicopter_ai::wingman_think( self );
		}
	}
}

flares_think( vehicle )
{
	vehicle endon( "death" );
	while( vehicle.health > 0 )
	{
		if ( vehicle == level.playervehicle )
		{
			if ( ( !level.player buttonPressed( level.flareButton1 ) ) && ( !level.player buttonPressed( level.flareButton2 ) ) )
			{
				wait 0.05;
				continue;
			}
		}
		else
		{
			vehicle waittill( "incomming_missile", eMissile );
			if ( !isdefined( eMissile ) )
				continue;
			
			//sometimes dont drop flares
			if ( randomint( 3 ) == 0 )
				continue;
			
			wait randomfloatrange( 0.5, 1.0 );
		}
		
		flares_fire( vehicle );
		
		wait 0.05;
		if ( vehicle != level.playervehicle )
			wait 3.0;
	}
}

flares_fire_burst( vehicle, fxCount, flareCount, flareTime )
{
	assert( isdefined( level.flare_fx[vehicle.vehicletype] ) );
	
	assert( fxCount >= flareCount );
	
	for ( i = 0 ; i < fxCount ; i++ )
	{
		playfx ( level.flare_fx[vehicle.vehicletype], vehicle getTagOrigin( "tag_flare" ) );	
		
		if ( vehicle == level.playervehicle )
		{
			level.stats["flares_used"]++;
			level.player playLocalSound( "weap_flares_fire" );
		}
		
		if ( i <= flareCount - 1 )
			thread flares_redirect_missiles( vehicle, flareTime );
		
		wait 0.1;
	}
}

flares_fire( vehicle )
{
	vehicle endon( "death" );
	
	if ( vehicle == level.playervehicle )
	{
		flareTime = 1.0;
		while ( ( level.player buttonPressed( level.flareButton1 ) ) || ( level.player buttonPressed( level.flareButton2 ) ) )
		{
			flares_fire_burst( vehicle, 1, 1, flareTime );
			flareTime = flareTime + 1.0;
			if ( flareTime > 5.0 )
				flareTime = 5.0;
		}
	}
	else
	{
		flares_fire_burst( vehicle, 8, 1, 5.0 );
	}	
	
}

flares_redirect_missiles( vehicle, flareTime )
{
	vehicle notify( "flares_out" );
	vehicle endon( "death" );
	vehicle endon( "flares_out" );
	
	if ( !isdefined( flareTime ) )
		flareTime = 5.0;
	
	// create a script_origin at the flares location and move it down with gravity
	vec = flares_get_vehicle_velocity( vehicle );
	flare = spawn( "script_origin", vehicle getTagOrigin( "tag_flare" ) );
	flare movegravity( vec, flareTime );
	
	if ( !isdefined( vehicle.incomming_Missiles ) )
		return;
	
	// redirect all incomming missiles to the new flares
	for( i = 0 ; i < vehicle.incomming_Missiles.size ; i++ )
		vehicle.incomming_Missiles[i] missile_settarget( flare );
	
	// wait for flares to burn out	
	wait flareTime;
	
	if ( !isdefined( vehicle.script_targetoffset_z ) )
		vehicle.script_targetoffset_z = 0;
	offset = ( 0, 0, vehicle.script_targetoffset_z );
	
	// when the flares burn out redirect missiles to the main target again ( if missile is still alive )
	if ( !isdefined( vehicle.incomming_Missiles ) )
		return;
	for( i = 0 ; i < vehicle.incomming_Missiles.size ; i++ )
		vehicle.incomming_Missiles[i] missile_settarget( vehicle, offset );
}

flares_get_vehicle_velocity( vehicle )
{
	org1 = vehicle.origin;
	wait 0.05;
	vec = ( vehicle.origin - org1 );
	return vectorScale( vec, 20 );
}

missile_deathWait( eMissile, eMissile_Target )
{
	eMissile_Target endon ( "death" );
	
	eMissile waittill ( "death" );
	
	if ( !isdefined( eMissile_Target.incomming_Missiles ) )
		return;
	
	eMissile_Target.incomming_Missiles = array_remove( eMissile_Target.incomming_Missiles, eMissile );
}

getEnemyTarget( fRadius, iFOVcos, getAITargets, doSightTrace, getVehicleTargets, randomizeTargetArray, aExcluders )
{
	if ( !isdefined( getAITargets ) )
		getAITargets = false;
	
	if ( !isdefined( doSightTrace ) )
		doSightTrace = false;
	
	if ( !isdefined( getVehicleTargets ) )
		getVehicleTargets = true;
	
	if ( !isdefined( randomizeTargetArray ) )
		randomizeTargetArray = false;
	
	// look for a vehicle target
	eTargets = [];
	eClosestValidTarget = undefined;
	
	enemyTeam = common_scripts\utility::get_enemy_team( self.script_team );
	possibleTargets = [];
	//prof_begin( "cobrapilot_ai" );
	
	if ( getVehicleTargets )
	{
		assert( isdefined( level.vehicles[enemyTeam] ) );
		for( i = 0 ; i < level.vehicles[enemyTeam].size ; i++ )
			possibleTargets[possibleTargets.size] = level.vehicles[enemyTeam][i];
	}
	
	if ( getAITargets )
	{
		enemyAI = getaiarray( enemyTeam );
		for( i = 0 ; i < enemyAI.size ; i++ )
			possibleTargets[possibleTargets.size] = enemyAI[i];
		if ( enemyTeam == "allies" )
			possibleTargets[possibleTargets.size] = level.player;
	}
	
	if ( isdefined( aExcluders ) )
		possibleTargets = array_exclude( possibleTargets, aExcluders );
	
	if ( randomizeTargetArray )
		possibleTargets = array_randomize( possibleTargets );
	
	forwardvec = anglestoforward( self.angles );
	for( i = 0 ; i < possibleTargets.size ; i++ )
	{
		if ( isdefined( self.ignored_by_tank_cannon ) )
			continue;
		
		// threatbias - if this is an ignored group then dont consider this target
		if ( isdefined( self.threatBiasGroup ) )
		{
			bias = getThreatBias( possibleTargets[i] getThreatBiasGroup(), self.threatBiasGroup );
			if ( bias <= -1000000 )
				continue;
		}
		
		// check if the target is within range
		if ( isdefined( fRadius ) && ( fRadius > 0 ) )
		{
			if ( distance( self.origin, possibleTargets[i].origin ) > fRadius )
				continue;
		}
		
		// check if the target is within fov
		if ( isdefined( iFOVcos ) )
		{
			normalvec = vectorNormalize( possibleTargets[i].origin - ( self.origin ) );
			vecdot = vectordot( forwardvec, normalvec );
			if ( vecdot <= iFOVcos )
				continue;
		}
		
		// check if a sight trace passes
		if ( doSightTrace )
		{
			sightTracePassed = false;
			if ( isAi( possibleTargets[i] ) )
				TraceZoffset = 48;
			else
				TraceZoffset = 150;
			sightTracePassed = sighttracepassed( self.origin, possibleTargets[i].origin + ( 0, 0, TraceZoffset ), false, self );
			if ( !sightTracePassed )
				continue;
		}
		
		eTargets[eTargets.size] = possibleTargets[i];
	}
	
	//prof_end( "cobrapilot_ai" );
	
	self notify( "gunner_new_target" );
	
	// return if no targets were found
	if ( eTargets.size == 0 )
		return eClosestValidTarget;
	
	// if only one target was found return it
	if ( eTargets.size == 1 )
		return eTargets[0];
	
	// return the closest of the targets
	//prof_begin( "cobrapilot_ai" );
	theTarget = getClosest( self.origin, eTargets );
	//prof_end( "cobrapilot_ai" );
	
	return theTarget;
}

shootEnemyTarget_Bullets( eTarget )
{
	self endon( "death" );
	self endon( "mg_off" );
	eTarget endon( "death" );
	self endon( "gunner_new_target" );
	if ( self == level.playervehicle )
		self endon( "gunner_stop_firing" );
	
	eTargetOffset = ( 0, 0, 0 );
	if ( isdefined( eTarget.script_targetoffset_z ) )
		eTargetOffset += ( 0, 0, eTarget.script_targetoffset_z );
	else if ( isSentient( eTarget ) )
		eTargetOffset = ( 0, 0, 32 );
	
	self setTurretTargetEnt( eTarget, eTargetOffset );
	
	while( self.health > 0 )
	{
		randomShots = randomintrange( 1, 25 );
		if ( getdvar( "cobrapilot_debug") == "1" )
			iprintln( "randomShots = " + randomShots );
		
		for( i = 0 ; i < randomShots ; i++ )
		{
			// if the vehicle firing the bullets is the players vehicle we have to switch to the 20mm gun
			if ( self == level.playervehicle )
			{
				if ( ( isdefined( level.cobraWeapon ) ) && ( level.cobraWeapon.size > 0 ) )
					level.playervehicle setVehWeapon( level.GunnerWeapon );
			}
			
			self thread shootEnemyTarget_Bullets_DebugLine( self, "tag_turret", eTarget, eTargetOffset, (1,1,0), 0.05 );
			self fireWeapon( "tag_flash" );
			
			// then switch it back to the players selection after the shots are fired
			if ( self == level.playervehicle )
				level.playervehicle setVehWeapon( level.cobraWeapon[level.currentWeapon].v["weapon"] );
			
			wait 0.05;
		}
		
		wait randomFloatRange( 0.25, 2.5 );
	}
}

shootEnemyTarget_Bullets_DebugLine( eStartEnt, eStartEntTag, eTarget, eTargetOffset, color, timer )
{
	if ( getdvar( "cobrapilot_debug") != "1" )
		return;
	
	if ( !isdefined( color ) )
		color = ( 0, 0, 0 );
	
	eTarget endon( "death" );
	self endon( "gunner_new_target" );
	
	assert( isdefined( eStartEntTag ) );
	
	if ( !isdefined( eTargetOffset ) )
		eTargetOffset = ( 0, 0, 0 );
	
	if ( isdefined( timer ) )
	{
		timer = gettime()+( timer * 1000 );
		while( gettime() < timer )
		{
			line( eStartEnt getTagOrigin( eStartEntTag ), eTarget.origin + eTargetOffset, color );
			wait 0.05;
		}
	}
	else
	{
		for (;;)
		{
			line( eStartEnt getTagOrigin( eStartEntTag ), eTarget.origin + eTargetOffset, color );
			wait 0.05;
		}
	}
}

attachMissiles( weapon1, weapon2, weapon3, weapon4 )
{
	self.hasAttachedWeapons = true;
	assert( isdefined( weapon1 ) );
	weapon = [];
	weapon[0] = weapon1;
	if ( isdefined( weapon2 ) )
		weapon[1] = weapon2;
	if ( isdefined( weapon3 ) )
		weapon[2] = weapon3;
	if ( isdefined( weapon4 ) )
		weapon[3] = weapon4;
	
	/*
	for( i = 0 ; i < weapon.size ; i++ )
	{
		for( k = 0 ; k < level.cobra_weapon_tags[weapon[i]].size ; k++ )
		{
			self attach( level.cobra_missile_models[weapon[i]], level.cobra_weapon_tags[weapon[i]][k] );
		}
	}
	*/
	
	for( i = 0 ; i < weapon.size ; i++ )
	{
		for( k = 0 ; k < level.cobra_weapon_tags[weapon[i]].size ; k++ )
		{
			self attach( level.cobra_missile_models[weapon[i]], level.cobra_weapon_tags[weapon[i]][k] );
		}
	}
}

fire_missile( sMissileType, iShots, eTarget, fDelay )
{
	if ( !isdefined( iShots ) )
		iShots = 1;
	assert( self.health > 0 );
	
	weaponName = undefined;
	weaponShootTime = undefined;
	defaultWeapon = "cobra_20mm";
	tags = [];
	switch( sMissileType )
	{
		case "mi28_seeker":
			weaponName = "cobra_seeker";
			tags[ 0 ] = "tag_store_L_1_a";
			tags[ 1 ] = "tag_store_R_1_a";
			tags[ 2 ] = "tag_store_L_2_a";
			tags[ 3 ] = "tag_store_R_2_a";
			break;
		case "ffar":
			weaponName = "cobra_FFAR";
			tags[ 0 ] = "tag_store_r_2";
			break;
		case "seeker":
			weaponName = "cobra_seeker";
			tags[ 0 ] = "tag_store_r_2";
			break;
		case "ffar_bog_a_lite":
			weaponName = "cobra_FFAR_bog_a_lite";
			tags[ 0 ] = "tag_store_r_2";
			break;
		case "ffar_airlift":
			weaponName = "cobra_FFAR_airlift";
			tags[ 0 ] = "tag_store_L_wing";
			tags[ 1 ] = "tag_store_R_wing";
			break;
		case "ffar_airlift_nofx":
			weaponName = "cobra_FFAR_airlift_nofx";
			tags[ 0 ] = "tag_store_L_wing";
			tags[ 1 ] = "tag_store_R_wing";
			break;
		case "ffar_hind":
			defaultWeapon = "hind_turret";
			weaponName = "hind_FFAR";
			tags[ 0 ] = "tag_missile_left";
			tags[ 1 ] = "tag_missile_right";
			break;
		case "ffar_hind_nodamage":
			defaultWeapon = "hind_turret";
			weaponName = "hind_FFAR_nodamage";
			tags[ 0 ] = "tag_missile_left";
			tags[ 1 ] = "tag_missile_right";
			break;
		case "ffar_mi28_village_assault":
			defaultWeapon = "hind_turret";
			weaponName = "mi28_ffar_village_assault";
			tags[ 0 ] = "tag_store_L_2_a";
			tags[ 1 ] = "tag_store_R_2_a";		
			tags[ 2 ] = "tag_store_L_2_b";
			tags[ 3 ] = "tag_store_R_2_b";
			tags[ 4 ] = "tag_store_L_2_c";
			tags[ 5 ] = "tag_store_R_2_c";
			tags[ 6 ] = "tag_store_L_2_d";
			tags[ 7 ] = "tag_store_R_2_d";
			break;
		default:
			assertMsg( "Invalid missile type specified." );
			break;
	}
	assert( isdefined( weaponName ) );
	assert( tags.size > 0 );
	
	weaponShootTime = weaponfiretime( weaponName );
	assert( isdefined( weaponShootTime ) );
	
	nextMissileTag = -1;
	for( i = 0 ; i < iShots ; i++ )
	{
		nextMissileTag++;
		if ( nextMissileTag >= tags.size )
			nextMissileTag = 0;
		
		if ( sMissileType == "ffar_mi28_village_assault" )
		{
			if ( isdefined( eTarget ) && isdefined( eTarget.origin ) )
			{
				magicBullet( weaponName, self getTagOrigin( tags[ nextMissileTag ] ), eTarget.origin );
				if ( isdefined( level._effect["ffar_mi28_muzzleflash"] ) )
					playfxontag( getfx( "ffar_mi28_muzzleflash" ), self, tags[ nextMissileTag ] );
				thread delayed_earthquake( 0.1, 0.5, 0.2, eTarget.origin, 1600 );
			}
		}
		else
		{
			self setVehWeapon( weaponName );
			if ( isdefined( eTarget ) )
			{
				eMissile = self fireWeapon( tags[ nextMissileTag ], eTarget );
				if ( sMissileType == "ffar" )
					eMissile thread missileLoseTarget( 0.1 );
				if ( sMissileType == "ffar_bog_a_lite" )
					eMissile thread missileLoseTarget( 0.1 );
				if ( sMissileType == "ffar_airlift" )
					eMissile thread missileLoseTarget( 0.1 );
			}
			else
				eMissile = self fireWeapon( tags[ nextMissileTag ] );
		}
		
		if ( i < iShots - 1 )
			wait weaponShootTime;
			
		if ( isdefined( fDelay ) )
			wait ( fDelay );
	}
	
	self setVehWeapon( defaultWeapon );
}

delayed_earthquake( fDelay, scale, duration, source, fRadius )
{
	wait fDelay;
	earthquake( scale, duration, source, fRadius );
}

missileLoseTarget( fDelay )
{
	self endon( "death" );
	wait fDelay;
	if ( isdefined( self ) )
		self missile_settarget( undefined );
}