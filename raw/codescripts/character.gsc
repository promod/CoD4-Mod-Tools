setModelFromArray( a )
{
	self setModel( a[ randomint( a.size ) ] );
}

precacheModelArray( a )
{
	for ( i = 0; i < a.size; i++ )
		precacheModel( a[ i ] );
}

useOptionalModels()
{
	return getdvarint( "g_useGear" );
}

randomElement( a )
{
	return a[ randomint( a.size ) ];
}

attachFromArray( a )
{
	self attach( randomElement( a ), "", true );
}

new()
{
	self detachAll();
	oldGunHand = self.anim_gunHand;
	if ( !isdefined( oldGunHand ) )
		return;
	self.anim_gunHand = "none";
	self [[ anim.PutGunInHand ]]( oldGunHand );
}

save()
{
	info[ "gunHand" ] = self.anim_gunHand;
	info[ "gunInHand" ] = self.anim_gunInHand;
	info[ "model" ] = self.model;
	info[ "hatModel" ] = self.hatModel;
	if ( isdefined( self.name ) )
	{
		info[ "name" ] = self.name;
		println( "Save: Guy has name ", self.name );
	}
	else
		println( "save: Guy had no name!" );
		
	attachSize = self getAttachSize();
	for ( i = 0; i < attachSize; i++ )
	{
		info[ "attach" ][ i ][ "model" ] = self getAttachModelName( i );
		info[ "attach" ][ i ][ "tag" ] = self getAttachTagName( i );
	}
	return info;
}

load( info )
{
	self detachAll();
	self.anim_gunHand = info[ "gunHand" ];
	self.anim_gunInHand = info[ "gunInHand" ];
	self setModel( info[ "model" ] );
	self.hatModel = info[ "hatModel" ];
	if ( isdefined( info[ "name" ] ) )
	{
		self.name = info[ "name" ];
		println( "Load: Guy has name ", self.name );
	}
	else
		println( "Load: Guy had no name!" );
		
	attachInfo = info[ "attach" ];
	attachSize = attachInfo.size;
	for ( i = 0; i < attachSize; i++ )
		self attach( attachInfo[ i ][ "model" ], attachInfo[ i ][ "tag" ] );
}

precache( info )
{
	if ( isdefined( info[ "name" ] ) )
		println( "Precache: Guy has name ", info[ "name" ] );
	else
		println( "Precache: Guy had no name!" );

	precacheModel( info[ "model" ] );

	attachInfo = info[ "attach" ];
	attachSize = attachInfo.size;
	for ( i = 0; i < attachSize; i++ )
		precacheModel( attachInfo[ i ][ "model" ] );
}

/* 
sample save / precache / load usage( precache is only required if there are any waits in the level script before load ):

save:
	info = foley codescripts\character::save();
	game[ "foley" ] = info;
	changelevel( "burnville", 0, true );

precache:
	codescripts\character::precache( game[ "foley" ] );

load:
	foley codescripts\character::load( game[ "foley" ] );

*/ 

get_random_character( amount )
{
	self_info = strtok( self.classname, "_" );
	if ( self_info.size <= 2 )
	{
		// some custom guy that doesn't use standard naming convention
		return randomint( amount );
	}
	
	
	group = "auto"; // by default the type is an auto-selected character
	index = undefined;
	prefix = self_info[ 2 ]; // merc, marine, etc
	
	// the designer can overwrite the character
	if ( isdefined( self.script_char_index ) )
	{
		index = self.script_char_index;
	}

	// the designer can hint that this guy is a member of a group of like - spawned guys, so he should use a different index
	if ( isdefined( self.script_char_group ) )
	{
		type = "grouped";
		group = "group_" + self.script_char_group;
	}
	
	if ( !isdefined( level.character_index_cache ) )
	{
		// separately store script grouped guys and auto guys so that they dont influence each other
		level.character_index_cache = [];
	}
	
	if ( !isdefined( level.character_index_cache[ prefix ] ) )
	{
		// separately store script grouped guys and auto guys so that they dont influence each other
		level.character_index_cache[ prefix ] = [];
	}
	
	if ( !isdefined( level.character_index_cache[ prefix ][ group ] ) )
	{
		initialize_character_group( prefix, group, amount );
	}

	if ( !isdefined( index ) )
	{
		index = get_least_used_index( prefix, group );

		if ( !isdefined( index ) )
		{
			// fail safe
			index = randomint( 5000 );
		}
	}

		
	while ( index >= amount )
	{
		index -= amount;
	}

	level.character_index_cache[ prefix ][ group ][ index ]++;
	
	return index;
}

get_least_used_index( prefix, group )
{
	lowest_indices = [];
	lowest_use = level.character_index_cache[ prefix ][ group ][ 0 ];
	lowest_indices[ 0 ] = 0;
	
	for ( i = 1; i < level.character_index_cache[ prefix ][ group ].size; i++ )
	{
		if ( level.character_index_cache[ prefix ][ group ][ i ] > lowest_use )
		{
			continue;
		}
		
		if ( level.character_index_cache[ prefix ][ group ][ i ] < lowest_use )
		{
			// if its the new lowest, start over on the array
			lowest_indices = [];
			lowest_use = level.character_index_cache[ prefix ][ group ][ i ];
		}

		// the equal amounts end up in the array
		lowest_indices[ lowest_indices.size ] = i;
	}
	assertex( lowest_indices.size, "Tried to spawn a character but the lowest indices didn't exist" );
	return random( lowest_indices );
}

initialize_character_group( prefix, group, amount )
{
	for ( i = 0; i < amount; i++ )
	{
		level.character_index_cache[ prefix ][ group ][ i ] = 0;
	}
}

random( array )
{
	return array [ randomint( array.size ) ];
}