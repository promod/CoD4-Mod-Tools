#include maps\_utility;
main()
{
	if ( getdvar( "cobrapilot_surface_to_air_missiles_enabled") == "" )
		setdvar( "cobrapilot_surface_to_air_missiles_enabled", "1" );
		
	self tryReload();
	self thread fireMissile();
	self thread turret_think();
	self thread detachall_on_death();
}

detachall_on_death()
{
	self waittill( "death" );
	self DetachAll();
}

turret_think()
{
	self endon ( "death" );
	
	if ( !isdefined( self.script_turret ) )
		return;
	if ( self.script_turret == 0 )
		return;
	assert( isdefined( self.script_team ) );
	
	// if the turret has a radius then use that radius instead of a default value
	self.attackRadius = 30000;
	if ( isdefined( self.radius ) )
		self.attackRadius = self.radius;
	
	maps\_cobrapilot::difficultySettingSelectedWait();
	
	difficultyScaler = 1.0;
	if ( level.cobrapilot_difficulty == "easy" )
		difficultyScaler = 0.5;
	else
	if ( level.cobrapilot_difficulty == "medium" )
		difficultyScaler = 1.7;
	else
	if ( level.cobrapilot_difficulty == "hard" )
		difficultyScaler = 1.0;
	else
	if ( level.cobrapilot_difficulty == "insane" )
		difficultyScaler = 1.5;
	
	self.attackRadius *= difficultyScaler;
	
	if ( getdvar( "cobrapilot_debug") == "1" )
		iprintln( "surface-to-air missile range difficultyScaler = " + difficultyScaler );
	
	for(;;)
	{
		wait ( 2 + randomfloat( 1 ) );
		
		// get a target
		eTarget = undefined;
		eTarget = maps\_helicopter_globals::getEnemyTarget( self.attackRadius, undefined, false, true );
		
		if ( !isdefined( eTarget) )
			continue;
		
		// offset where the missile should aim
		aimOrigin = eTarget.origin;
		if ( isdefined( eTarget.script_targetoffset_z ) )
			aimOrigin += ( 0, 0, eTarget.script_targetoffset_z );
		
		// aim the turret at the target
		self setTurretTargetVec( aimOrigin );
		level thread turret_rotate_timeout( self, 5.0 );
		self waittill ( "turret_rotate_stopped" );
		self clearTurretTarget();
		
		// once the turret it aimed make sure the target is still within attacking range
		if ( distance( self.origin, eTarget.origin ) > self.attackRadius )
			continue;
		
		// make sure a sight trace can still pass so the missile doens't launch into a wall or something
		sightTracePassed = false;
		sightTracePassed = sighttracepassed( self.origin, eTarget.origin + ( 0, 0, 150 ), false, self );
		if ( !sightTracePassed )
			continue;
		
		// fire the missile and wait a while
		if ( getdvar( "cobrapilot_surface_to_air_missiles_enabled") == "1" )
		{
			self notify ( "shoot_target", eTarget );
			self waittill( "missile_fired", eMissile );
			if ( isdefined( eMissile ) )
			{
				if ( level.cobrapilot_difficulty == "hard" )
				{
					wait ( 1 + randomfloat( 2 ) );
					continue;
				}
				else if ( level.cobrapilot_difficulty == "insane" )
					continue;
				else
					eMissile waittill( "death" );
			}
			continue;
		}
	}
}

turret_rotate_timeout( turret, time )
{
	turret endon ( "death" );
	turret endon ( "turret_rotate_stopped" );
	wait time;
	turret notify ( "turret_rotate_stopped" );
}

within_attack_range( targetEnt )
{
	d = distance( ( self.origin[0], self.origin[1], 0 ), ( targetEnt.origin[0], targetEnt.origin[1], 0 ) );
	zDiff = ( targetEnt.origin[2] - self.origin[2] );
	if ( zDiff <= 750 )
		return false;
	zMod = zDiff * 2.5;
	if ( d <= ( self.attackRadius + zMod ) )
		return true;
	return false;
}

fireMissile()
{
	self endon ( "death" );
	
	for (;;)
	{
		self waittill( "shoot_target", targetEnt );
		
		assert( isdefined( targetEnt ) );
		assert( isdefined( self.missileTags[self.missileLaunchNextTag] ) );
		
		// fire the missile
		eMissile = undefined;
		
		if ( !isdefined( targetEnt.script_targetoffset_z ) )
			targetEnt.script_targetoffset_z = 0;
		offset = ( 0, 0, targetEnt.script_targetoffset_z );
		
		eMissile = self fireWeapon( self.missileTags[self.missileLaunchNextTag], targetEnt, offset );
		assert( isdefined( eMissile ) );
		
		if ( getdvar( "cobrapilot_debug") == "1" )
			level thread draw_missile_target_line( eMissile, targetEnt, offset );
		
		if ( !isdefined( targetEnt.incomming_Missiles ) )
			targetEnt.incomming_Missiles = [];
		targetEnt.incomming_Missiles = array_add( targetEnt.incomming_Missiles, eMissile );
		thread maps\_helicopter_globals::missile_deathWait( eMissile, targetEnt );
		
		// detach the missile from the model
		self detach( self.missileModel, self.missileTags[self.missileLaunchNextTag] );
		
		//update tag and ammo info
		self.missileLaunchNextTag++;
		self.missileAmmo--;
		
		// send a notify to the target that it has a missile heading it's way
		targetEnt notify ( "incomming_missile", eMissile );
		
		// reload if we need to ( this makes it reload right after the last shot is fired )
		self tryReload();
		
		wait 0.05;
		
		self notify( "missile_fired", eMissile );
	}
}

draw_missile_target_line( eMissile, targetEnt, offset )
{
	eMissile endon( "death" );
	
	for(;;)
	{
		line( eMissile.origin, targetEnt.origin + offset );
		wait 0.05;
	}
}

tryReload()
{
	if ( !isdefined( self.missileAmmo ) )
		self.missileAmmo = 0;
	if ( !isdefined( self.missileLaunchNextTag ) )
		self.missileLaunchNextTag = 0;
	
	if ( self.missileAmmo > 0 )
		return;
	
	for( i = 0 ; i < self.missileTags.size ; i++ )
		self attach( self.missileModel, self.missileTags[i] );
	
	self.missileAmmo = self.missileTags.size;
	self.missileLaunchNextTag = 0;
}