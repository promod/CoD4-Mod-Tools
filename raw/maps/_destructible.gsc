#include maps\_utility;
#include common_scripts\utility;
#using_animtree( "vehicles" );
main()
{
	/#
	if ( getdvar( "debug_destructibles" ) == "" )
		setdvar( "debug_destructibles", "0" );
	if ( getdvar( "destructibles_enable_physics" ) == "" )
		setdvar( "destructibles_enable_physics", "1" );
	#/
	
	level.destructibleSpawnedEntsLimit = 50;
	level.destructibleSpawnedEnts = [];
	
	find_destructibles();
}

destructible_create( type, health, validAttackers, validDamageZone, validDamageCause )
{
	// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- - 
	// Creates a new information structure for a destructible object
	// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- - 
	assert( isdefined( type ) );
	
	if ( !isdefined( level.destructible_type ) )
		level.destructible_type = [];
	
	destructibleIndex = level.destructible_type.size;
	

	destructibleIndex = level.destructible_type.size;
	level.destructible_type[ destructibleIndex ] = spawnStruct();
	level.destructible_type[ destructibleIndex ].v[ "type" ] = type;
	
	level.destructible_type[ destructibleIndex ].parts = [];
	level.destructible_type[ destructibleIndex ].parts[ 0 ][ 0 ] = spawnStruct();
	level.destructible_type[ destructibleIndex ].parts[ 0 ][ 0 ].v[ "modelName" ] = self.model;
	level.destructible_type[ destructibleIndex ].parts[ 0 ][ 0 ].v[ "health" ] = health;
	level.destructible_type[ destructibleIndex ].parts[ 0 ][ 0 ].v[ "validAttackers" ] = validAttackers;
	level.destructible_type[ destructibleIndex ].parts[ 0 ][ 0 ].v[ "validDamageZone" ] = validDamageZone;
	level.destructible_type[ destructibleIndex ].parts[ 0 ][ 0 ].v[ "validDamageCause" ] = validDamageCause;
	level.destructible_type[ destructibleIndex ].parts[ 0 ][ 0 ].v[ "godModeAllowed" ] = true;
}

destructible_part( tagName, modelName, health, validAttackers, validDamageZone, validDamageCause, alsoDamageParent, physicsOnExplosion, grenadeImpactDeath )
{
	// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- - 
	// Adds a part to the last created destructible information structure
	// This part will be created and attached to the specified bone on load
	// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- - 
	destructibleIndex = ( level.destructible_type.size - 1 );
	assert( isdefined( level.destructible_type[ destructibleIndex ].parts ) );
	assert( isdefined( level.destructible_type[ destructibleIndex ].parts.size ) );
	
	partIndex = level.destructible_type[ destructibleIndex ].parts.size;
	assert( partIndex > 0 );
	
	stateIndex = 0;
	
	destructible_info( partIndex, stateIndex, tagName, modelName, health, validAttackers, validDamageZone, validDamageCause, alsoDamageParent, physicsOnExplosion, grenadeImpactDeath );
}

destructible_state( tagName, modelName, health, validAttackers, validDamageZone, validDamageCause, grenadeImpactDeath )
{
	// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- - 
	// Adds a new part that is a state of the last created part
	// When the previous part reaches zero health this part will show up
	// and the previous part will be removed
	// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- - 
	
	destructibleIndex = ( level.destructible_type.size - 1 );
	partIndex = ( level.destructible_type[ destructibleIndex ].parts.size - 1 );
	stateIndex = ( level.destructible_type[ destructibleIndex ].parts[ partIndex ].size );
	
	destructible_info( partIndex, stateIndex, tagName, modelName, health, validAttackers, validDamageZone, validDamageCause, undefined, undefined, grenadeImpactDeath );
}

destructible_fx( tagName, fxName, useTagAngles )
{
	assert( isdefined( fxName ) );
	
	if ( !isdefined( useTagAngles ) )
		useTagAngles = true;
	
	destructibleIndex = ( level.destructible_type.size - 1 );
	partIndex = ( level.destructible_type[ destructibleIndex ].parts.size - 1 );
	stateIndex = ( level.destructible_type[ destructibleIndex ].parts[ partIndex ].size - 1 );
	
	assert( isdefined( level.destructible_type ) );
	assert( isdefined( level.destructible_type[ destructibleIndex ] ) );
	assert( isdefined( level.destructible_type[ destructibleIndex ].parts ) );
	assert( isdefined( level.destructible_type[ destructibleIndex ].parts[ partIndex ] ) );
	assert( isdefined( level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ] ) );
	
	level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ].v[ "fx_filename" ] = fxName;
	level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ].v[ "fx_tag" ] = tagName;
	level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ].v[ "fx_useTagAngles" ] = useTagAngles;
}

destructible_loopfx( tagName, fxName, loopRate )
{
	assert( isdefined( tagName ) );
	assert( isdefined( fxName ) );
	assert( isdefined( loopRate ) );
	assert( loopRate > 0 );
	
	destructibleIndex = ( level.destructible_type.size - 1 );
	partIndex = ( level.destructible_type[ destructibleIndex ].parts.size - 1 );
	stateIndex = ( level.destructible_type[ destructibleIndex ].parts[ partIndex ].size - 1 );
	
	assert( isdefined( level.destructible_type ) );
	assert( isdefined( level.destructible_type[ destructibleIndex ] ) );
	assert( isdefined( level.destructible_type[ destructibleIndex ].parts ) );
	assert( isdefined( level.destructible_type[ destructibleIndex ].parts[ partIndex ] ) );
	assert( isdefined( level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ] ) );
	
	level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ].v[ "loopfx_filename" ] = fxName;
	level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ].v[ "loopfx_tag" ] = tagName;
	level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ].v[ "loopfx_rate" ] = loopRate;
}

destructible_healthdrain( amount, interval, badplaceRadius, badplaceTeam )
{
	assert( isdefined( amount ) );
	
	destructibleIndex = ( level.destructible_type.size - 1 );
	partIndex = ( level.destructible_type[ destructibleIndex ].parts.size - 1 );
	stateIndex = ( level.destructible_type[ destructibleIndex ].parts[ partIndex ].size - 1 );
	
	assert( isdefined( level.destructible_type ) );
	assert( isdefined( level.destructible_type[ destructibleIndex ] ) );
	assert( isdefined( level.destructible_type[ destructibleIndex ].parts ) );
	assert( isdefined( level.destructible_type[ destructibleIndex ].parts[ partIndex ] ) );
	assert( isdefined( level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ] ) );
	
	level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ].v[ "healthdrain_amount" ] = amount;
	level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ].v[ "healthdrain_interval" ] = interval;
	level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ].v[ "badplace_radius" ] = badplaceRadius;
	level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ].v[ "badplace_team" ] = badplaceTeam;
}

destructible_sound( soundAlias, soundCause )
{
	assert( isdefined( soundAlias ) );
	
	destructibleIndex = ( level.destructible_type.size - 1 );
	partIndex = ( level.destructible_type[ destructibleIndex ].parts.size - 1 );
	stateIndex = ( level.destructible_type[ destructibleIndex ].parts[ partIndex ].size - 1 );
	
	assert( isdefined( level.destructible_type ) );
	assert( isdefined( level.destructible_type[ destructibleIndex ] ) );
	assert( isdefined( level.destructible_type[ destructibleIndex ].parts ) );
	assert( isdefined( level.destructible_type[ destructibleIndex ].parts[ partIndex ] ) );
	assert( isdefined( level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ] ) );
	
	if ( !isdefined( level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ].v[ "sound" ] ) )
	{
		level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ].v[ "sound" ] = [];
		level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ].v[ "soundCause" ] = [];
	}
	
	index = level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ].v[ "sound" ].size;
	level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ].v[ "sound" ][ index ] = soundAlias;
	level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ].v[ "soundCause" ][ index ] = soundCause;
}

destructible_loopsound( soundAlias, loopsoundCause )
{
	assert( isdefined( soundAlias ) );
	
	destructibleIndex = ( level.destructible_type.size - 1 );
	partIndex = ( level.destructible_type[ destructibleIndex ].parts.size - 1 );
	stateIndex = ( level.destructible_type[ destructibleIndex ].parts[ partIndex ].size - 1 );
	
	assert( isdefined( level.destructible_type ) );
	assert( isdefined( level.destructible_type[ destructibleIndex ] ) );
	assert( isdefined( level.destructible_type[ destructibleIndex ].parts ) );
	assert( isdefined( level.destructible_type[ destructibleIndex ].parts[ partIndex ] ) );
	assert( isdefined( level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ] ) );
	
	if ( !isdefined( level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ].v[ "loopsound" ] ) )
	{
		level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ].v[ "loopsound" ] = [];
		level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ].v[ "loopsoundCause" ] = [];
	}
	
	index = level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ].v[ "loopsound" ].size;
	level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ].v[ "loopsound" ][ index ] = soundAlias;
	level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ].v[ "loopsoundCause" ][ index ] = loopsoundCause;
}

destructible_anim( animName, animTree, animType )
{
	assert( isdefined( anim ) );
	assert( isdefined( animtree ) );
	
	destructibleIndex = ( level.destructible_type.size - 1 );
	partIndex = ( level.destructible_type[ destructibleIndex ].parts.size - 1 );
	stateIndex = ( level.destructible_type[ destructibleIndex ].parts[ partIndex ].size - 1 );
	
	assert( isdefined( level.destructible_type ) );
	assert( isdefined( level.destructible_type[ destructibleIndex ] ) );
	assert( isdefined( level.destructible_type[ destructibleIndex ].parts ) );
	assert( isdefined( level.destructible_type[ destructibleIndex ].parts[ partIndex ] ) );
	assert( isdefined( level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ] ) );
	
	level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ].v[ "anim" ] = animName;
	level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ].v[ "animTree" ] = animtree;
	level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ].v[ "animType" ] = animType;
}

destructible_physics()
{
	destructibleIndex = ( level.destructible_type.size - 1 );
	partIndex = ( level.destructible_type[ destructibleIndex ].parts.size - 1 );
	stateIndex = ( level.destructible_type[ destructibleIndex ].parts[ partIndex ].size - 1 );
	
	assert( isdefined( level.destructible_type ) );
	assert( isdefined( level.destructible_type[ destructibleIndex ] ) );
	assert( isdefined( level.destructible_type[ destructibleIndex ].parts ) );
	assert( isdefined( level.destructible_type[ destructibleIndex ].parts[ partIndex ] ) );
	assert( isdefined( level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ] ) );
	
	level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ].v[ "physics" ] = true;
}

destructible_explode( force_min, force_max, range, mindamage, maxdamage )
{
	destructibleIndex = ( level.destructible_type.size - 1 );
	partIndex = ( level.destructible_type[ destructibleIndex ].parts.size - 1 );
	stateIndex = ( level.destructible_type[ destructibleIndex ].parts[ partIndex ].size - 1 );
	
	assert( isdefined( level.destructible_type ) );
	assert( isdefined( level.destructible_type[ destructibleIndex ] ) );
	assert( isdefined( level.destructible_type[ destructibleIndex ].parts ) );
	assert( isdefined( level.destructible_type[ destructibleIndex ].parts[ partIndex ] ) );
	assert( isdefined( level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ] ) );
	
	level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ].v[ "explode_force_min" ] = force_min;
	level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ].v[ "explode_force_max" ] = force_max;
	level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ].v[ "explode_range" ] = range;
	level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ].v[ "explode_mindamage" ] = mindamage;
	level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ].v[ "explode_maxdamage" ] = maxdamage;
}

destructible_info( partIndex, stateIndex, tagName, modelName, health, validAttackers, validDamageZone, validDamageCause, alsoDamageParent, physicsOnExplosion, grenadeImpactDeath )
{
	assert( isdefined( partIndex ) );
	assert( isdefined( stateIndex ) );
	assert( isdefined( level.destructible_type ) );
	assert( level.destructible_type.size > 0 );
	
	destructibleIndex = ( level.destructible_type.size - 1 );
	
	level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ] = spawnStruct();
	level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ].v[ "modelName" ] = modelName;
	level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ].v[ "tagName" ] = tagName;
	level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ].v[ "health" ] = health;
	level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ].v[ "validAttackers" ] = validAttackers;
	level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ].v[ "validDamageZone" ] = validDamageZone;
	level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ].v[ "validDamageCause" ] = validDamageCause;
	level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ].v[ "alsoDamageParent" ] = alsoDamageParent;
	level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ].v[ "physicsOnExplosion" ] = physicsOnExplosion;
	level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ].v[ "grenadeImpactDeath" ] = grenadeImpactDeath;
	// sanity check please. I set this here so that I don't have to do isdefined on every part evertime it gets hit
	level.destructible_type[ destructibleIndex ].parts[ partIndex ][ stateIndex ].v[ "godModeAllowed" ] = false;

}

find_destructibles()
{
	// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- - 
	// Find all destructibles by their targetnames and run the setup
	// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- - 
	array_thread( getentarray( "destructible", "targetname" ), ::setup_destructibles );
}


precache_destructibles()
{	

	
	// I needed this to be seperate for vehicle scripts.
	// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- - 
	// Precache referenced models and load referenced effects
	// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- - 
	if ( isdefined( level.destructible_type[ self.destuctableInfo ].parts ) )
	{
		for ( i = 0 ; i < level.destructible_type[ self.destuctableInfo ].parts.size ; i++ )
		{
			for ( j = 0 ; j < level.destructible_type[ self.destuctableInfo ].parts[ i ].size ; j++ )
			{
				if ( level.destructible_type[ self.destuctableInfo ].parts[ i ].size <= j )
					continue;
				
				if ( isdefined( level.destructible_type[ self.destuctableInfo ].parts[ i ][ j ].v[ "modelName" ] ) )
					precacheModel( level.destructible_type[ self.destuctableInfo ].parts[ i ][ j ].v[ "modelName" ] );
				
				if ( isdefined( level.destructible_type[ self.destuctableInfo ].parts[ i ][ j ].v[ "fx_filename" ] ) )
					level.destructible_type[ self.destuctableInfo ].parts[ i ][ j ].v[ "fx" ] = loadfx( level.destructible_type[ self.destuctableInfo ].parts[ i ][ j ].v[ "fx_filename" ] );
				
				if ( isdefined( level.destructible_type[ self.destuctableInfo ].parts[ i ][ j ].v[ "loopfx_filename" ] ) )
					level.destructible_type[ self.destuctableInfo ].parts[ i ][ j ].v[ "loopfx" ] = loadfx( level.destructible_type[ self.destuctableInfo ].parts[ i ][ j ].v[ "loopfx_filename" ] );
			}
		}
	}	
}

setup_destructibles( cached )
{
	
	if ( !isdefined( cached ) )
		cached = false;
	
	// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- - 
	// Figure out what destructible information this entity should use
	// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- - 
	destuctableInfo = undefined;
	assertEx( isdefined( self.destructible_type ), "Destructible object with targetname 'destructible' does not have a 'destructible_type' key / value" );
	
	self.modeldummyon = false;// - nate added for vehicle dummy stuff. This is so I can turn a destructible into a dummy and throw it around on jeepride.
	self add_damage_owner_recorder();	// Mackey added to track who is damaging the car

	self.destuctableInfo = maps\_destructible_types::makeType( self.destructible_type );
	// println( "### DESTRUCTIBLE ### assigned infotype index: " + self.destuctableInfo );
	assert( self.destuctableInfo >= 0 );
	
	if ( !cached )
		precache_destructibles();
	
	// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- - 
	// Attach all parts to the entity
	// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- - 
	if ( isdefined( level.destructible_type[ self.destuctableInfo ].parts ) )
	{
		self.destructible_parts = [];
		for ( i = 0 ; i < level.destructible_type[ self.destuctableInfo ].parts.size ; i++ )
		{
			// create the struct where the info for each entity will be held
			self.destructible_parts[ i ] = spawnStruct();
			
			// set it's current state to 0 since it has never taken damage yet and will be on it's first state
			self.destructible_parts[ i ].v[ "currentState" ] = 0;
			
			// if it has a health value then store it's value
			if ( isdefined( level.destructible_type[ self.destuctableInfo ].parts[ i ][ 0 ].v[ "health" ] ) )
				self.destructible_parts[ i ].v[ "health" ] = level.destructible_type[ self.destuctableInfo ].parts[ i ][ 0 ].v[ "health" ];
			
			// continue if it's the base model since its not an attached part
			if ( i == 0 )
				continue;
			
			// attach the part now
			modelName = level.destructible_type[ self.destuctableInfo ].parts[ i ][ 0 ].v[ "modelName" ];
			tagName = level.destructible_type[ self.destuctableInfo ].parts[ i ][ 0 ].v[ "tagName" ];
			self attach( modelName, tagName );
			if ( self.modeldummyon )
				self.modeldummy attach( modelName, tagName );
		}
	}
	
	// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- - 
	// Make this entity take damage and wait for events
	// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- - 
	if ( self.classname != "script_vehicle" )
		self setCanDamage( true );
	self thread connectTraverses();
	self thread destructible_think();
}

add_damage_owner_recorder()
{
	// Mackey added to track who is damaging the car
	self.player_damage = 0;
	self.non_player_damage = 0;
	
	self.car_damage_owner_recorder = true;
}

destructible_think()
{	
	// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- - 
	// Wait until this entity takes damage
	// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- - 
	self endon( "stop_taking_damage" );
	for ( ;; )
	{
		self waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName );
		prof_begin( "_destructible" );
		

		if ( !isdefined( damage ) )
			continue;
		if ( damage <= 0 )
			continue;
		
		type = getDamageType( type );
		assert( isdefined( type ) );
		
		/#
		if ( getdvar( "debug_destructibles" ) == "1" )
		{
			print3d( point, ".", ( 1, 1, 1 ), 1.0, 0.5, 100 );
			iprintln( "damage amount: " + damage );
			iprintln( "hit model: " + modelName );
			if ( isdefined( tagName ) )
				iprintln( "hit model tag: " + tagName );
			else
				iprintln( "hit model tag: " );
		}
		#/ 
		
		// override for when base model is damaged. We dont want to pass in empty strings
		assert( isdefined( modelName ) );
		if ( modelName == "" )
		{
			assert( isdefined( self.model ) );
			modelName = self.model;
		}
		if ( isdefined( tagName ) && tagName == "" )
		{
			tagName = undefined;
		}
		
		prof_end( "_destructible" );
		
		// special handling for splash and projectile damage
		if ( type == "splash" )
		{
			 /#
			if ( getdvar( "debug_destructibles" ) == "1" )
				iprintln( "type = splash" );
			#/ 
			
			self destructible_splash_damage( int( damage ), point, direction_vec, attacker, type );
			continue;
		}
		
		self thread destructible_update_part( int( damage ), modelName, tagName, point, direction_vec, attacker, type );
	}
}

destructible_update_part( damage, modelName, tagName, point, direction_vec, attacker, damageType )
{	
	// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- - 
	// Find what part this is, or is a child of. If the base model was
	// the entity that was damaged the part index will be - 1
	// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- - 
	if ( !isdefined( self.destructible_parts ) )
		return;
	if ( self.destructible_parts.size == 0 )
		return;
	
	prof_begin( "_destructible" );
	
	partIndex = -1;
	stateIndex = -1;
	assert( isdefined( self.model ) );
	if ( ( tolower( modelName ) == tolower( self.model ) ) && ( !isdefined( tagName ) ) )
	{
		modelName = self.model;
		tagName = undefined;
		partIndex = 0;
		stateIndex = 0;
	}
	
	for ( i = 0 ; i < level.destructible_type[ self.destuctableInfo ].parts.size ; i++ )
	{
		stateIndex = self.destructible_parts[ i ].v[ "currentState" ];
		
		if ( level.destructible_type[ self.destuctableInfo ].parts[ i ].size <= stateIndex )
			continue;
		
		if ( !isdefined( level.destructible_type[ self.destuctableInfo ].parts[ i ][ stateIndex ].v[ "modelName" ] ) )
			continue;
		
		if ( tolower( level.destructible_type[ self.destuctableInfo ].parts[ i ][ stateIndex ].v[ "modelName" ] ) == tolower( modelName ) )
		{
			if ( level.destructible_type[ self.destuctableInfo ].parts[ i ][ stateIndex ].v[ "tagName" ] == tagName )
			{
				partIndex = i;
				break;
			}
		}
	}
	assert( stateIndex >= 0 );
	
	prof_end( "_destructible" );
	
	if ( partIndex < 0 )
		return;
	
	// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- - 
	// Deduct the damage amount from the part's health
	// If the part runs out of health go to the next state
	// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- - 
	state_before = stateIndex;
	updateHealthValue = false;
	delayModelSwap = false;
	prof_begin( "_destructible" );
	for ( ;; )
	{
		stateIndex = self.destructible_parts[ partIndex ].v[ "currentState" ];
		
		// there isn't another state to go to when damaged
		if ( !isdefined( level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ stateIndex ] ) )
			break;
		
		// see if the model is also supposed to damage the parent
		if ( isdefined( level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ 0 ].v[ "alsoDamageParent" ] ) )
		{
			if ( getDamageType( damageType ) != "splash" )
			{
				ratio = level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ 0 ].v[ "alsoDamageParent" ];
				parentDamage = int( damage * ratio );
				self thread notifyDamageAfterFrame( parentDamage, attacker, direction_vec, point, damageType, "", "" );
			}
		}
		
		if ( !isdefined( level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ stateIndex ].v[ "health" ] ) )
			break;
		if ( !isdefined( self.destructible_parts[ partIndex ].v[ "health" ] ) )
			break;
		
		if ( updateHealthValue )
			self.destructible_parts[ partIndex ].v[ "health" ] = level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ stateIndex ].v[ "health" ];
		updateHealthValue = false;
		
		 /#
		if ( getdvar( "debug_destructibles" ) == "1" )
		{
			iprintln( "stateindex: " + stateIndex );
			iprintln( "damage: " + damage );
			iprintln( "health( before ): " + self.destructible_parts[ partIndex ].v[ "health" ] );
		}
		#/ 
		
		// Handle grenades hitting glass parts. Grenades should make the glass completely break instead of just doing 1 damage and shattering the glass
		if ( ( isdefined( level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ stateIndex ].v[ "grenadeImpactDeath" ] ) ) && ( damageType == "impact" ) )
			damage = 100000000;
		
		// apply the damage to the part if the attacker was a valid attacker
		validAttacker = self isAttackerValid( partIndex, stateIndex, attacker );
		if ( validAttacker )
		{
			validDamageCause = self isValidDamageCause( partIndex, stateIndex, damageType );
			if ( validDamageCause )
			{
				// validHitLocation = self isValidHitLocation( partIndex, stateIndex, attacker, point );
				// if ( validHitLocation )
				// {
				
				if ( attacker == level.player )
				{
					self.player_damage += damage;
				}
				else
				{
					if ( attacker != self )
						self.non_player_damage += damage;
				}
				
				self.destructible_parts[ partIndex ].v[ "health" ] -= damage;
				// }
			}
		}
		
		 /#
		if ( getdvar( "debug_destructibles" ) == "1" )
			iprintln( "health( after ): " + self.destructible_parts[ partIndex ].v[ "health" ] );
		#/ 
		
		// if the part still has health left then we're done
		if ( self.destructible_parts[ partIndex ].v[ "health" ] > 0 )
		{
			prof_end( "_destructible" );
			return;
		}
		
		// if the part ran out of health then carry over to the next part
		damage = int( abs( self.destructible_parts[ partIndex ].v[ "health" ] ) );
		if ( damage < 0 )
		{
			prof_end( "_destructible" );
			return;
		}
		self.destructible_parts[ partIndex ].v[ "currentState" ]++ ;
		stateIndex = self.destructible_parts[ partIndex ].v[ "currentState" ];
		actionStateIndex = ( stateIndex - 1 );
		
		if ( !isdefined( level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ actionStateIndex ] ) )
		{
			prof_end( "_destructible" );
			return;
		}
		
		// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- - 
		// A state change is required so detach the old model or replace it if 
		// it's the base model that took the damage.
		// Then attach the model( if specified ) used for the new state
		// Only do this if there is another state to go to, some parts might have
		// fx or anims, or sounds but no next model to go to
		// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- - 
		
		// if the part is meant to explode on this state set a flag. Actual explosion will be done down below
		if ( isdefined( level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ actionStateIndex ].v[ "explode_force_min" ] ) )
			self.exploding = true;
		
		// stop all previously looped sounds
		if ( ( isdefined( self.loopingSoundStopNotifies ) ) && ( isdefined( self.loopingSoundStopNotifies[ string( partIndex ) ] ) ) )
		{
			
			for ( i = 0 ; i < self.loopingSoundStopNotifies[ string( partIndex ) ].size ; i++ )
			{
				self notify( self.loopingSoundStopNotifies[ string( partIndex ) ][ i ] );
				if ( self.modeldummyon )
					self.modeldummy notify( self.loopingSoundStopNotifies[ string( partIndex ) ][ i ] );
			}
			self.loopingSoundStopNotifies[ string( partIndex ) ] = undefined;
		}
		
		if ( isdefined( level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ stateIndex ] ) )
		{
			if ( partIndex == 0 )
			{
				newModel = level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ stateIndex ].v[ "modelName" ];
				self setmodel( newModel );
				if ( self.modeldummyon )
					self.modeldummy setmodel( newModel );
			}
			else
			{
				// handle a part getting damaged here - must be detached and reattached
				self detach( modelName, tagName );
				if ( self.modeldummyon )
					self.modeldummy detach( modelName, tagName );
					
				modelName = level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ stateIndex ].v[ "modelName" ];
				tagName = level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ stateIndex ].v[ "tagName" ];
			
				if ( isdefined( modelName ) && isdefined( tagName ) )
				{
					if ( self.modeldummyon )
						self.modeldummy attach( modelName, tagName );
					self attach( modelName, tagName );
				}
					
			}
		}

		eModel = get_dummy();
		
		// if the part has an fx then play it now
		if ( isdefined( level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ actionStateIndex ].v[ "fx" ] ) )
		{
			fx = level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ actionStateIndex ].v[ "fx" ];
			
			if ( isdefined( level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ actionStateIndex ].v[ "fx_tag" ] ) )
			{
				fx_tag = level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ actionStateIndex ].v[ "fx_tag" ];
				self notify( "FX_State_Change" + partIndex );
				if ( level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ actionStateIndex ].v[ "fx_useTagAngles" ] )
				{
					playfxontag( fx, eModel, fx_tag );
				}
				else
				{
					fxOrigin = eModel getTagOrigin( fx_tag );
					forward = ( fxOrigin + ( 0, 0, 100 ) ) - fxOrigin;
					playfx( fx, fxOrigin, forward );
				}
			}
			else
			{
				fxOrigin = eModel.origin;
				forward = ( fxOrigin + ( 0, 0, 100 ) ) - fxOrigin;
				playfx( fx, fxOrigin, forward );
			}
		}
		
		// if the part has a looping fx then play it now
		if ( isdefined( level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ actionStateIndex ].v[ "loopfx" ] ) )
		{
			assert( isdefined( level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ actionStateIndex ].v[ "loopfx_tag" ] ) );
			loopfx = level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ actionStateIndex ].v[ "loopfx" ];
			loopfx_tag = level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ actionStateIndex ].v[ "loopfx_tag" ];
			loopRate = level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ actionStateIndex ].v[ "loopfx_rate" ];
			self notify( "FX_State_Change" + partIndex );
			self thread loopfx_onTag( loopfx, loopfx_tag, loopRate, partIndex );
		}
		
		// if the part has an anim then play it now
		if ( !isdefined( self.exploded ) )
		{
			
			if ( isdefined( level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ actionStateIndex ].v[ "anim" ] ) )
			{
				animName = level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ actionStateIndex ].v[ "anim" ];
				animTree = level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ actionStateIndex ].v[ "animTree" ];
				eModel useanimtree( animTree );
				animType = level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ actionStateIndex ].v[ "animType" ];
				if ( !isdefined( self.animsApplied ) )
					self.animsApplied = [];
				self.animsApplied[ self.animsApplied.size ] = animName;
				
				if ( isdefined( self.exploding ) )
				{
					// clear all previously blended anims if the vehicle is exploding so the explosion doesn't have to blend with anything
					if ( isdefined( self.animsApplied ) )
					{
						for ( i = 0 ; i < self.animsApplied.size ; i++ )
						{
							eModel clearAnim( self.animsApplied[ i ], 0 );
						}
					}
				}
				
				if ( animType == "setanim" )
					eModel setAnim( animName, 1.0, 1.0, 1.0 );
				else if ( animType == "setanimknob" )
					eModel setAnimKnob( animName, 1.0, 1.0, 1.0 );
				else
					assertMsg( "Tried to play an animation on a destructible with an invalid animType: " + animType );
			}
		}
		
		// if the part has a soundalias then play it now
		if ( !isdefined( self.exploded ) )
		{
			if ( isdefined( level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ actionStateIndex ].v[ "sound" ] ) )
			{
				for ( i = 0 ; i < level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ actionStateIndex ].v[ "sound" ].size ; i++ )
				{
					validSoundCause = self isValidSoundCause( "soundCause", partIndex, actionStateIndex, i, damageType );
					if ( validSoundCause )
					{
						soundAlias = level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ actionStateIndex ].v[ "sound" ][ i ];
						soundTagName = level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ actionStateIndex ].v[ "tagName" ];
						eModel thread play_sound_on_tag( soundAlias, soundTagName );
					}
				}
			}
		}
		
		// if the part has a looping soundalias then start looping it now
		if ( isdefined( level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ actionStateIndex ].v[ "loopsound" ] ) )
		{
			for ( i = 0 ; i < level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ actionStateIndex ].v[ "loopsound" ].size ; i++ )
			{
				validSoundCause = self isValidSoundCause( "loopsoundCause", partIndex, actionStateIndex, i, damageType );
				if ( validSoundCause )
				{
					loopsoundAlias = level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ actionStateIndex ].v[ "loopsound" ][ i ];
					loopsoundTagName = level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ actionStateIndex ].v[ "tagName" ];
					self thread play_loop_sound_on_destructible( loopsoundAlias, loopsoundTagName );
					
					if ( !isdefined( self.loopingSoundStopNotifies ) )
						self.loopingSoundStopNotifies = [];
					if ( !isdefined( self.loopingSoundStopNotifies[ string( partIndex ) ] ) )
						self.loopingSoundStopNotifies[ string( partIndex ) ] = [];
					size = self.loopingSoundStopNotifies[ string( partIndex ) ].size;
					self.loopingSoundStopNotifies[ string( partIndex ) ][ size ] = "stop sound" + loopsoundAlias;
				}
			}
		}
		
		// if the part should drain health then start the drain
		if ( isdefined( level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ actionStateIndex ].v[ "healthdrain_amount" ] ) )
		{
			self notify( "Health_Drain_State_Change" + partIndex );
			healthdrain_amount 		 = level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ actionStateIndex ].v[ "healthdrain_amount" ];
			healthdrain_interval 	 = level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ actionStateIndex ].v[ "healthdrain_interval" ];
			healthdrain_modelName 	 = level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ actionStateIndex ].v[ "modelName" ];
			healthdrain_tagName 	 = level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ actionStateIndex ].v[ "tagName" ];
			badplaceRadius 			 = level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ actionStateIndex ].v[ "badplace_radius" ];
			badplaceTeam 			 = level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ actionStateIndex ].v[ "badplace_team" ];
			if ( healthdrain_amount > 0 )
			{
				assert( ( isdefined( healthdrain_interval ) ) && ( healthdrain_interval > 0 ) );
				self thread health_drain( healthdrain_amount, healthdrain_interval, partIndex, healthdrain_modelName, healthdrain_tagName, badplaceRadius, badplaceTeam );
			}
		}
		
		// if the part is meant to explode on this state then do it now. Causes all attached models to become physics with the specified force
		if ( isdefined( level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ actionStateIndex ].v[ "explode_force_min" ] ) )
		{
			delayModelSwap = true;
			force_min 	 = level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ actionStateIndex ].v[ "explode_force_min" ];
			force_max 	 = level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ actionStateIndex ].v[ "explode_force_max" ];
			range 		 = level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ actionStateIndex ].v[ "explode_range" ];
			mindamage 	 = level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ actionStateIndex ].v[ "explode_mindamage" ];
			maxdamage 	 = level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ actionStateIndex ].v[ "explode_maxdamage" ];
			
			if( isdefined( attacker ) && attacker != self )
				self.attacker = attacker; // achievement hook.

			self thread explode( partIndex, force_min, force_max, range, mindamage, maxdamage );
		}
		
		// if the part should do physics here then initiate the physics and velocity
		if ( isdefined( level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ actionStateIndex ].v[ "physics" ] ) )
		{
			initial_velocity = point;
			impactDir = ( 0, 0, 0 );
			if ( isdefined( attacker ) )
			{
				impactDir = attacker.origin;
				if ( attacker == level.player )
					impactDir = level.player getEye();
				initial_velocity = vectorNormalize( point - impactDir );
				initial_velocity = vectorScale( initial_velocity, 200 );
			}
			self thread physics_launch( partIndex, actionStateIndex, point, initial_velocity );
			return;
		}
		
		updateHealthValue = true;
	}
	prof_end( "_destructible" );
}

destructible_splash_damage( damage, point, direction_vec, attacker, damageType )
{
	if ( damage <= 0 )
		return;
	
	// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
	// Fill an array of all possible parts that might have been splash damaged
	// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
	damagedParts = [];
	closestPartDist = undefined;
	prof_begin( "_destructible" );
	if ( isdefined( level.destructible_type[ self.destuctableInfo ].parts ) )
	{
		for ( i = 0 ; i < level.destructible_type[ self.destuctableInfo ].parts.size ; i++ )
		{
			for ( j = 0 ; j < level.destructible_type[ self.destuctableInfo ].parts[ i ].size ; j++ )
			{
				if ( level.destructible_type[ self.destuctableInfo ].parts[ i ].size <= j )
					continue;
				
				if ( isdefined( level.destructible_type[ self.destuctableInfo ].parts[ i ][ j ].v[ "modelName" ] ) )
				{
					// see how far the part is from the splash damage origin
					modelName = level.destructible_type[ self.destuctableInfo ].parts[ i ][ j ].v[ "modelName" ];
					assert( isdefined( modelName ) );
					
					// special handling for the base model which doesn't use a tag
					if ( i == 0 )
					{
						d = distance( point, self.origin );
						tagName = undefined;
					}
					else
					{
						tagName = level.destructible_type[ self.destuctableInfo ].parts[ i ][ j ].v[ "tagName" ];
						assert( isdefined( tagName ) );
						d = distance( point, self getTagOrigin( tagName ) );
					}
					
					if ( ( !isdefined( closestPartDist ) ) || ( d < closestPartDist ) )
						closestPartDist = d;
					
					// add the part to the list of parts to be damaged
					index = damagedParts.size;
					damagedParts[ index ] = spawnStruct();
					damagedParts[ index ].v[ "modelName" ] = modelName;
					damagedParts[ index ].v[ "tagName" ] = tagName;
					damagedParts[ index ].v[ "distance" ] = d;
				}
			}
		}
	}
	prof_end( "_destructible" );
	
	if ( !isdefined( closestPartDist ) )
		return;
	if ( closestPartDist < 0 )
		return;
	if ( damagedParts.size <= 0 )
		return;
	
	// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
	// Damage each part depending on how close it was to the splash damage point
	// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
	prof_begin( "_destructible" );
	for ( i = 0 ; i < damagedParts.size ; i++ )
	{
		distanceMod = ( damagedParts[ i ].v[ "distance" ] * 1.4 );
		damageAmount = ( damage - ( distanceMod - closestPartDist ) );
		
		if ( damageAmount <= 0 )
			continue;
		
		/#
		if ( getdvar( "debug_destructibles" ) == "1" )
		{
			if ( isdefined( damagedParts[ i ].v[ "tagName" ] ) )
				print3d( self getTagOrigin( damagedParts[ i ].v[ "tagName" ] ), damageAmount, ( 1, 1, 1 ), 1.0, 0.5, 200 );				
		}
		#/
		
		self thread destructible_update_part( damageAmount, damagedParts[ i ].v[ "modelName" ], damagedParts[ i ].v[ "tagName" ], point, direction_vec, attacker, damageType );
	}
	prof_end( "_destructible" );
}

isValidSoundCause( soundCauseVar, partIndex, stateIndex, soundIndex, damageType )
{
	soundCause = level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ stateIndex ].v[ soundCauseVar ][ soundIndex ];
	if ( !isdefined( soundCause ) )
		return true;
	
	if ( soundCause == damageType )
		return true;
	
	return false;
}

isAttackerValid( partIndex, stateIndex, attacker )
{
	// return true if the vehicle is being force exploded
	if ( isdefined( self.forceExploding ) )
		return true;
	
	// return false if the vehicle is trying to explode but it's not allowed to
	if ( isdefined( level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ stateIndex ].v[ "explode_force_min" ] ) )
	{
		if ( isdefined( self.dontAllowExplode ) )
			return false;
	}
	
	if ( !isdefined( attacker ) )
		return true;
	
	if ( attacker == self )
		return true;
	
	sType = level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ stateIndex ].v[ "validAttackers" ];
	if ( !isdefined( sType ) )
		return true;
	
	if ( sType == "no_player" )
	{
		if ( attacker != level.player )
			return true;
	}
	else
	if ( sType == "player_only" )
	{
		if ( attacker == level.player )
			return true;
	}
	else
	if ( sType == "no_ai" )
	{
		if ( !isAI( attacker ) )
			return true;
	}
	else
	if ( sType == "ai_only" )
	{
		if ( isAI( attacker ) )
			return true;
	}
	else
	{
		assertMsg( "Invalid attacker rules on destructible vehicle. Valid types are: ai_only, no_ai, player_only, no_player" );
	}
	
	return false;
}

isValidDamageCause( partIndex, stateIndex, damageType )
{
	if ( !isdefined( damageType ) )
		return true;
	
	godModeAllowed = level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ stateIndex ].v[ "godModeAllowed" ];
	if ( godModeAllowed && ( ( isdefined( self.godmode ) && self.godmode ) || ( isdefined( self.script_bulletshield ) && self.script_bulletshield ) && damageType == "bullet" ) )
		return false;
	
	validType = level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ stateIndex ].v[ "validDamageCause" ];
	if ( !isdefined( validType ) )
		return true;
	
	if ( ( validType == "no_melee" ) && ( damageType == "melee" ) )
		return false;
		
	return true;
}
/* 
isValidHitLocation( partIndex, stateIndex, attacker, point )
{
	validDamageZone = level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ stateIndex ].v[ "validDamageZone" ];
	if ( !isdefined( validDamageZone ) )
		return true;
	
	if ( attacker == self )
		return true;
	
	if ( partIndex != 0 )
		return true;
	
	// only do damage if it was to the front of the car( 32 units or more forward from the center )
	prof_begin( "_destructible" );
	forward = anglesToForward( self.angles );
	vecToPoint = ( point - self.origin );
	d = vectorDot( forward, vecToPoint );
	prof_end( "_destructible" );
	
	if ( validDamageZone >= 0 )
	{
		if ( d < validDamageZone )
			return false;
	}
	else
	{
		if ( d > validDamageZone )
			return false;
	}
	
	return true;
}
*/ 
getDamageType( type )
{
	// returns a simple damage type: melee, bullet, splash, or unknown
	
	if ( !isdefined( type ) )
		return "unknown";
	
	type = tolower( type );
	switch( type )
	{
		case "mod_melee":
		case "mod_crush":
		case "melee":
			return "melee";
		case "mod_pistol_bullet":
		case "mod_rifle_bullet":
		case "bullet":
			return "bullet";
		case "mod_grenade":
		case "mod_grenade_splash":
		case "mod_projectile":
		case "mod_projectile_splash":
		case "mod_explosive":
		case "splash":
			return "splash";
		case "mod_impact":
			return "impact";
		case "unknown":
			return "unknown";
		default:
			return "unknown";
	}
}

loopfx_onTag( loopfx, loopfx_tag, loopRate, partIndex )
{
	eModel = get_dummy();
	self endon( "FX_State_Change" + partIndex );
	self endon( "delete_destructible" );  
	level endon( "putout_fires" );  

	for ( ;; )
	{
		eModel = get_dummy();
		playfxontag( loopfx, eModel, loopfx_tag );
		wait loopRate;
	}
}

health_drain( amount, interval, partIndex, modelName, tagName, badplaceRadius, badplaceTeam )
{
	self endon( "Health_Drain_State_Change" + partIndex );
	level endon( "putout_fires" );

	wait interval;
	
	self.healthDrain = true;
	
	uniqueName = undefined;
	if ( isdefined( badplaceRadius ) && isdefined( badplaceTeam ) )
	{
		uniqueName = "" + getTime();
		if ( !isdefined( self.disableBadPlace ) )
		{
			if ( badplaceTeam == "both" )
				badplace_cylinder( uniqueName, 0, self.origin, badplaceRadius, 128, "allies", "axis" );
			else
				badplace_cylinder( uniqueName, 0, self.origin, badplaceRadius, 128, badplaceTeam );
		}
	}
	
	while ( self.destructible_parts[ partIndex ].v[ "health" ] > 0 )
	{
		/#
		if ( getdvar( "debug_destructibles" ) == "1" )
		{
			iprintln( "health before damage: " + self.destructible_parts[ partIndex ].v[ "health" ] );
			iprintln( "doing " + amount + " damage" );
		}
		#/
		self notify( "damage", amount, self, ( 0, 0, 0 ), ( 0, 0, 0 ), "MOD_UNKNOWN", modelName, tagName );
		wait interval;
	}
	
	if ( isdefined( badplaceRadius ) && isdefined( badplaceTeam ) )
	{
		assert( isdefined( uniqueName ) );
		badplace_delete( uniqueName );
	}
}

physics_launch( partIndex, stateIndex, point, initial_velocity )
{
	detachModelName = get_model_from_part( partIndex, stateIndex );
	spawnModelName = get_last_model_from_part( partIndex );
	
	tagName = get_tag_from_part( partIndex, stateIndex );
	
	// Make sure this part is still attached to the base model
	if ( !isModelAttached( detachModelName, tagName ) )
		return;
	
	// Detach the part
	self detach( detachModelName, tagName );
	if ( self.modeldummyon )
		self.modeldummy detach( detachModelName, tagName );
	
	/#
	if ( getdvar( "destructibles_enable_physics" ) == "0" )
		return;
	#/
	
	// If we've reached the max number of spawned physics models for destructible vehicles then delete one before creating another
	if ( level.destructibleSpawnedEnts.size >= level.destructibleSpawnedEntsLimit )
		physics_object_remove( level.destructibleSpawnedEnts[ 0 ] );
	
	// Spawn a model to use for physics using the modelname and position of the part
	physicsObject = spawn( "script_model", self getTagOrigin( tagName ) );
	physicsObject.angles = self getTagAngles( tagName );
	physicsObject setModel( spawnModelName );
	
	// Keep track of the new part so it can be removed later if we reach the max
	level.destructibleSpawnedEnts[ level.destructibleSpawnedEnts.size ] = physicsObject;
	
	// Do physics on the model
	physicsObject physicsLaunch( point, initial_velocity );
}

physics_object_remove( ent )
{
	newArray = [];
	for ( i = 0 ; i < level.destructibleSpawnedEnts.size ; i++ )
	{
		if ( level.destructibleSpawnedEnts[ i ] == ent )
			continue;
		newArray[ newArray.size ] = level.destructibleSpawnedEnts[ i ];
	}
	level.destructibleSpawnedEnts = newArray;
	ent delete();
}

explode( partIndex, force_min, force_max, range, mindamage, maxdamage )
{
	assert( isdefined( force_min ) );
	assert( isdefined( force_max ) );
	if ( isdefined( self.exploded ) )
		return;
	self.exploded = true;
	
	if ( self.classname == "script_vehicle" )
		self notify( "death" );
	
	// check if there is a disconnect paths brush to disconnect any traverses
	self thread disconnectTraverses();
	
	wait 0.05;
	
	tagName = level.destructible_type[ self.destuctableInfo ].parts[ partIndex ][ self.destructible_parts[ partIndex ].v[ "currentState" ] ].v[ "tagName" ];
	
	if ( isdefined( tagName ) )
		explosionOrigin = self getTagOrigin( tagName );
	else
		explosionOrigin = self.origin;
	
	self notify( "damage", maxdamage, self, ( 0, 0, 0 ), explosionOrigin, "MOD_EXPLOSIVE", "", "" );
	
	waittillframeend;
	
	prof_begin( "_destructible" );
	
	if ( isdefined( level.destructible_type[ self.destuctableInfo ].parts ) )
	{
		for ( i = ( level.destructible_type[ self.destuctableInfo ].parts.size - 1 ); i >= 0; i -- )
		{
			if ( i == partIndex )
				continue;
			
			stateIndex = self.destructible_parts[ i ].v[ "currentState" ];
			if ( stateIndex >= level.destructible_type[ self.destuctableInfo ].parts[ i ].size )
				stateIndex = level.destructible_type[ self.destuctableInfo ].parts[ i ].size - 1;
			
			modelName = get_model_from_part( i, stateIndex );
			tagName = get_tag_from_part( i, stateIndex );
			
			if ( !isdefined( modelName ) )
				continue;
			if ( !isdefined( tagName ) )
				continue;
			
			if ( !isModelAttached( modelName, tagName ) )
				continue;
				
			// dont do physics on parts that are supposed to be removed on explosion
			if ( part_has_physics_exposion( i ) )
			{
				apply_physics_explosion_to_part( i, stateIndex, tagName, explosionOrigin, force_min, force_max );
				continue;
			}

			self detach( modelName, tagName );
			if ( self.modeldummyon )
				self.modeldummy detach( modelName, tagName );
		}
	}
	
	prof_end( "_destructible" );
	
	self notify( "stop_taking_damage" );
	wait 0.05;
	
	damageLocation = explosionOrigin + ( 0, 0, 80 );
	if ( getSubStr( level.destructible_type[ self.destuctableInfo ].v[ "type" ], 0, 7 ) == "vehicle" )
	{
		anim.lastCarExplosionTime = gettime();
		anim.lastCarExplosionDamageLocation = damageLocation;
		anim.lastCarExplosionLocation = explosionOrigin;
		anim.lastCarExplosionRange = range;
	}
	
	self radiusdamage( damageLocation, range, maxdamage, mindamage, self );

	if ( arcadeMode_car_kill() )
	{
		thread maps\_arcademode::arcadeMode_add_points( self.origin, true, "explosive", 200 );
	}
	
	self notify( "destroyed" );
}

arcadeMode_car_kill()
{
	if ( !arcadeMode() )
		return false;

	if ( level.script == "ac130" )
		return false;
		
	if ( isdefined( level.allCarsDamagedByPlayer ) )
		return true;
		
	return self maps\_gameskill::player_did_most_damage();
}


get_destructible_index( index, stateIndex, indexName )
{
	if ( stateIndex >= 0 )
	{
		return level.destructible_type[ self.destuctableInfo ].parts[ index ][ stateIndex ].v[ indexName ];
	}
	else if ( stateIndex == -1 )
	{
		// return the last value provided in the hierarchy
		lastInHierarchy = undefined;
		
		for ( i = 0 ; i < level.destructible_type[ self.destuctableInfo ].parts[ index ].size ; i++ )
		{
			if ( isdefined( level.destructible_type[ self.destuctableInfo ].parts[ index ][ i ].v[ indexName ] ) )
				lastInHierarchy = level.destructible_type[ self.destuctableInfo ].parts[ index ][ i ].v[ indexName ];
		}
	
		assert( isdefined( lastInHierarchy ) );
		return lastInHierarchy;
	}
}

get_tag_from_part( index, stateIndex )
{
	return get_destructible_index( index, stateIndex, "tagName" );
}

get_model_from_part( index, stateIndex )
{
	return get_destructible_index( index, stateIndex, "modelName" );
}

get_last_model_from_part( index )
{
	return get_destructible_index( index, -1, "modelName" );
}

apply_physics_explosion_to_part( index, stateIndex, tagName, explosionOrigin, force_min, force_max )
{
	velocityScaler = level.destructible_type[ self.destuctableInfo ].parts[ index ][ 0 ].v[ "physicsOnExplosion" ];
	
	point = self getTagOrigin( tagName );
	initial_velocity = vectorNormalize( point - explosionOrigin );
	initial_velocity = vectorScale( initial_velocity, randomfloatrange( force_min, force_max ) * velocityScaler );
	
	self thread physics_launch( index, stateIndex, point, initial_velocity );
}

part_has_physics_exposion( index )
{
	if ( !isdefined( level.destructible_type[ self.destuctableInfo ].parts[ index ][ 0 ].v[ "physicsOnExplosion" ] ) )
		return false;

	return level.destructible_type[ self.destuctableInfo ].parts[ index ][ 0 ].v[ "physicsOnExplosion" ] > 0;
}

isModelAttached( modelName, tagName )
{
	qAttached = false;
	
	modelName = tolower( modelName );
	tagName = tolower( tagName );
	
	assert( isdefined( modelName ) );
	if ( !isdefined( tagName ) )
		return qAttached;
	
	prof_begin( "_destructible" );
	
	attachedModelCount = self getattachsize();
	attachedModels = [];
	for ( i = 0 ; i < attachedModelCount ; i++ )
		attachedModels[ i ] = tolower( self getAttachModelName( i ) );
	
	for ( i = 0 ; i < attachedModels.size ; i++ )
	{
		if ( attachedModels[ i ] != modelName )
			continue;
		
		sName = tolower( self getattachtagname( i ) );
		if ( tagName != sName )
			continue;
		
		qAttached = true;
		break;
	}
	prof_end( "_destructible" );
	
	return qAttached;
}

play_loop_sound_on_destructible( alias, tag )
{
	eModel = get_dummy();

	org = spawn( "script_origin", ( 0, 0, 0 ) );
	if ( isdefined( tag ) )
		org.origin = eModel getTagOrigin( tag );
	else
		org.origin = eModel.origin;
	
	org playloopsound( alias );

	eModel thread force_stop_sound( alias );

	eModel waittill( "stop sound" + alias );
	org stoploopsound( alias );
	org delete();
}

force_stop_sound( alias )
{
	self endon( "stop sound" + alias );

	level waittill( "putout_fires" );
	self notify( "stop sound" + alias );
}

notifyDamageAfterFrame( damage, attacker, direction_vec, point, damageType, modelName, tagName )
{
	if ( isdefined( level.notifyDamageAfterFrame ) )
		return;
	level.notifyDamageAfterFrame = true;
	waittillframeend;
	if ( isdefined( self.exploded ) )
	{
		level.notifyDamageAfterFrame = undefined;
		return;
	}
	self notify( "damage", damage, attacker, direction_vec, point, damageType, modelName, tagName );
	level.notifyDamageAfterFrame = undefined;
}


get_dummy()
{
	if ( self.modeldummyon )
		eModel = self.modeldummy;
	else
		eModel = self;
	return eModel;
}

disable_explosion()
{
	self.dontAllowExplode = true;
}

force_explosion()
{
	self.dontAllowExplode = undefined;
	self.forceExploding = true;
	self notify( "damage", 1000000000, self, self.origin, self.origin, "MOD_EXPLOSIVE", "", "" );
}

get_traverse_disconnect_brush()
{
	if ( !isdefined( self.target ) )
		return undefined;
	
	clip = getent( self.target, "targetname" );
	if ( !isdefined( clip ) )
		return undefined;
	
	if ( !clip.spawnflags & 1 ) 
		return undefined;
	
	return clip;
}

connectTraverses()
{
	clip = get_traverse_disconnect_brush();
	
	if ( !isdefined( clip ) )
		return;
	
	clip connectPaths();
	clip.origin -= ( 0, 0, 10000 );
}

disconnectTraverses()
{
	clip = get_traverse_disconnect_brush();
	
	if ( !isdefined( clip ) )
		return;
	
	clip.origin += ( 0, 0, 10000 );
	clip disconnectPaths();
	clip.origin -= ( 0, 0, 10000 );
}