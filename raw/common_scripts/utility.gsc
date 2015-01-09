scriptPrintln(channel, msg)
{
	setprintchannel(channel);
	println(msg);
	setprintchannel ("script");
}

debugPrintln(channel, msg)
{
	setprintchannel("script_debug");
	println(msg);
	setprintchannel ("script");
}

draw_debug_line(start, end, timer)
{
	for (i=0;i<timer*20;i++)
	{
		line (start, end, (1,1,0.5));
		wait (0.05);
	}
}

waittillend(msg)
{
	self waittillmatch (msg, "end");
}

randomvector(num)
{
	return (randomfloat(num) - num*0.5, randomfloat(num) - num*0.5,randomfloat(num) - num*0.5);
}

angle_dif (oldangle, newangle)
{
	// returns the difference between two yaws
	if (oldangle == newangle)
		return 0;
	
	while (newangle > 360)
		newangle -=360;
	
	while (newangle < 0)
		newangle +=360;
	
	while (oldangle > 360)
		oldangle -=360;
	
	while (oldangle < 0)
		oldangle +=360;
	
	olddif = undefined;
	newdif = undefined;
	
	if (newangle > 180)
		newdif = 360 - newangle;
	else
		newdif = newangle;
	
	if (oldangle > 180)
		olddif = 360 - oldangle;
	else
		olddif = oldangle;
	
	outerdif = newdif + olddif;
	innerdif = 0;
	
	if (newangle > oldangle)
		innerdif = newangle - oldangle;
	else
		innerdif = oldangle - newangle;
	
	if (innerdif < outerdif)
		return innerdif;
	else
		return outerdif;
}

vectorScale( vector, scale )
{
	vector = (vector[0] * scale, vector[1] * scale, vector[2] * scale);
	return vector;
}

sign( x )
{
	if ( x >= 0 )
		return 1;
	return -1;
}


track(spot_to_track)
{
	if (isdefined(self.current_target))
	{
		if (spot_to_track == self.current_target)
			return;	
	}
	self.current_target = spot_to_track;	
}

get_enemy_team( team )
{
	assertEx( team != "neutral", "Team must be allies or axis" );
	
	teams = [];
	teams["axis"] = "allies";
	teams["allies"] = "axis";
		
	return teams[team];
}


clear_exception( type )
{
	assert( isdefined( self.exception[ type ] ) );
	self.exception[ type ] = anim.defaultException;
}

set_exception( type, func )
{
	assert( isdefined( self.exception[ type ] ) );
	self.exception[ type ] = func;
}

set_all_exceptions( exceptionFunc )
{
	keys = getArrayKeys( self.exception );
	for ( i=0; i < keys.size; i++ )
	{
		self.exception[ keys[ i ] ] = exceptionFunc;
	}
}

set_flash_duration(time_in_seconds)
{
	self.flashduration = time_in_seconds * 1000;
} 

cointoss()
{
	return randomint( 100 ) >= 50 ;
}


waittill_string( msg, ent )
{
	if ( msg != "death" )
		self endon ("death");
		
	ent endon ( "die" );
	self waittill ( msg );
	ent notify ( "returned", msg );
}

waittill_multiple( string1, string2, string3, string4, string5 )
{
	self endon ("death");
	ent = spawnstruct();
	ent.threads = 0;

	if (isdefined (string1))
	{
		self thread waittill_string (string1, ent);
		ent.threads++;
	}
	if (isdefined (string2))
	{
		self thread waittill_string (string2, ent);
		ent.threads++;
	}
	if (isdefined (string3))
	{
		self thread waittill_string (string3, ent);
		ent.threads++;
	}
	if (isdefined (string4))
	{
		self thread waittill_string (string4, ent);
		ent.threads++;
	}
	if (isdefined (string5))
	{
		self thread waittill_string (string5, ent);
		ent.threads++;
	}

	while (ent.threads)
	{
		ent waittill ("returned");
		ent.threads--;
	}

	ent notify ("die");
}

waittill_multiple_ents( ent1, string1, ent2, string2, ent3, string3, ent4, string4 )
{
	self endon ("death");
	ent = spawnstruct();
	ent.threads = 0;

	if ( isdefined( ent1 ) )
	{
		assert( isdefined( string1 ) );
		ent1 thread waittill_string( string1, ent );
		ent.threads++;
	}
	if ( isdefined( ent2 ) )
	{
		assert( isdefined( string2 ) );
		ent2 thread waittill_string ( string2, ent );
		ent.threads++;
	}
	if ( isdefined( ent3 ) )
	{
		assert( isdefined( string3 ) );
		ent3 thread waittill_string ( string3, ent );
		ent.threads++;
	}
	if ( isdefined( ent4 ) )
	{
		assert( isdefined( string4 ) );
		ent4 thread waittill_string ( string4, ent );
		ent.threads++;
	}

	while (ent.threads)
	{
		ent waittill ("returned");
		ent.threads--;
	}

	ent notify ("die");
}

waittill_any_return( string1, string2, string3, string4, string5 )
{
	if ((!isdefined (string1) || string1 != "death") &&
	    (!isdefined (string2) || string2 != "death") &&
	    (!isdefined (string3) || string3 != "death") &&
	    (!isdefined (string4) || string4 != "death") &&
	    (!isdefined (string5) || string5 != "death"))
		self endon ("death");
		
	ent = spawnstruct();

	if (isdefined (string1))
		self thread waittill_string (string1, ent);

	if (isdefined (string2))
		self thread waittill_string (string2, ent);

	if (isdefined (string3))
		self thread waittill_string (string3, ent);

	if (isdefined (string4))
		self thread waittill_string (string4, ent);

	if (isdefined (string5))
		self thread waittill_string (string5, ent);

	ent waittill ("returned", msg);
	ent notify ("die");
	return msg;
}

waittill_any( string1, string2, string3, string4, string5 )
{
	assert( isdefined( string1 ) );
	
	if ( isdefined( string2 ) )
		self endon( string2 );

	if ( isdefined( string3 ) )
		self endon( string3 );

	if ( isdefined( string4 ) )
		self endon( string4 );

	if ( isdefined( string5 ) )
		self endon( string5 );
	
	self waittill( string1 );
}

waittill_any_ents( ent1, string1, ent2, string2, ent3, string3, ent4, string4, ent5, string5, ent6, string6, ent7, string7 )
{
	assert( isdefined( ent1 ) );
	assert( isdefined( string1 ) );
	
	if ( ( isdefined( ent2 ) ) && ( isdefined( string2 ) ) )
		ent2 endon( string2 );

	if ( ( isdefined( ent3 ) ) && ( isdefined( string3 ) ) )
		ent3 endon( string3 );
	
	if ( ( isdefined( ent4 ) ) && ( isdefined( string4 ) ) )
		ent4 endon( string4 );
	
	if ( ( isdefined( ent5 ) ) && ( isdefined( string5 ) ) )
		ent5 endon( string5 );
	
	if ( ( isdefined( ent6 ) ) && ( isdefined( string6 ) ) )
		ent6 endon( string6 );
	
	if ( ( isdefined( ent7 ) ) && ( isdefined( string7 ) ) )
		ent7 endon( string7 );
	
	ent1 waittill( string1 );
}

/*
=============
///ScriptDocBegin
"Name: isFlashed()"
"Summary: Returns true if the player or an AI is flashed"
"Module: Utility"
"CallOn: An AI"
"Example: flashed = level.price isflashed();"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
isFlashed()
{
	if ( !isdefined( self.flashEndTime ) )
		return false;
	
	return gettime() < self.flashEndTime;
}


 /* 
 ============= 
///ScriptDocBegin
"Name: flag( <flagname> )"
"Summary: Checks if the flag is set. Returns true or false."
"Module: Flag"
"CallOn: "
"MandatoryArg: <flagname> : name of the flag to check"
"Example: flag( "hq_cleared" );"
"SPMP: both"
///ScriptDocEnd
 ============= 
 */ 
flag( message )
{
	assertEx( isdefined( message ), "Tried to check flag but the flag was not defined." );
	assertEx( isdefined( level.flag[ message ] ), "Tried to check flag " + message + " but the flag was not initialized." );
	if ( !level.flag[ message ] )
		return false;

	return true;
}


 /* 
 ============= 
///ScriptDocBegin
"Name: flag_init( <flagname> )"
"Summary: Initialize a flag to be used. All flags must be initialized before using flag_set or flag_wait"
"Module: Flag"
"CallOn: "
"MandatoryArg: <flagname> : name of the flag to create"
"Example: flag_init( "hq_cleared" );"
"SPMP: singleplayer"
///ScriptDocEnd
 ============= 
 */ 
flag_init( message )
{
	if ( !isDefined( level.flag ) )
	{
		level.flag = [];
		level.flags_lock = [];
		if ( !isdefined( level.sp_stat_tracking_func ) )
			level.sp_stat_tracking_func = ::empty_init_func;
	}

	if ( !isdefined( level.first_frame ) )
		assertEx( !isDefined( level.flag[ message ] ), "Attempt to reinitialize existing message: " + message );
		
	level.flag[ message ] = false;
 /#
	level.flags_lock[ message ] = false;
#/ 
	if ( !isdefined( level.trigger_flags ) )
	{
		init_trigger_flags();
		level.trigger_flags[ message ] = [];
	}
	else
	if ( !isdefined( level.trigger_flags[ message ] ) )
	{
		level.trigger_flags[ message ] = [];
	}
	
	if ( issuffix( message, "aa_" ) )
	{
		thread [[ level.sp_stat_tracking_func ]]( message );
	}
}

empty_init_func( empty )
{
}

issuffix( msg, suffix )
{
	if ( suffix.size > msg.size )
		return false;
	
	for ( i = 0; i < suffix.size; i++ )
	{
		if ( msg[ i ] != suffix[ i ] )
			return false;
	}
	return true;
}
 /* 
 ============= 
///ScriptDocBegin
"Name: flag_set( <flagname> )"
"Summary: Sets the specified flag, all scripts using flag_wait will now continue."
"Module: Flag"
"CallOn: "
"MandatoryArg: <flagname> : name of the flag to set"
"Example: flag_set( "hq_cleared" );"
"SPMP: both"
///ScriptDocEnd
 ============= 
 */ 
flag_set( message )
{
 /#
	assertEx( isDefined( level.flag[ message ] ), "Attempt to set a flag before calling flag_init: " + message );
	assert( level.flag[ message ] == level.flags_lock[ message ] );
	level.flags_lock[ message ] = true;
#/ 	
	level.flag[ message ] = true;
	level notify( message );

	set_trigger_flag_permissions( message );
}

 /* 
 ============= 
///ScriptDocBegin
"Name: flag_wait( <flagname> )"
"Summary: Waits until the specified flag is set."
"Module: Flag"
"CallOn: "
"MandatoryArg: <flagname> : name of the flag to wait on"
"Example: flag_wait( "hq_cleared" );"
"SPMP: both"
///ScriptDocEnd
 ============= 
 */ 
flag_wait( msg )
{
	while( !level.flag[ msg ] )
		level waittill( msg );
}

 /* 
 ============= 
///ScriptDocBegin
"Name: flag_clear( <flagname> )"
"Summary: Clears the specified flag."
"Module: Flag"
"CallOn: "
"MandatoryArg: <flagname> : name of the flag to clear"
"Example: flag_clear( "hq_cleared" );"
"SPMP: both"
///ScriptDocEnd
 ============= 
 */ 
flag_clear( message )
{
 /#
	assertEx( isDefined( level.flag[ message ] ), "Attempt to set a flag before calling flag_init: " + message );
	assert( level.flag[ message ] == level.flags_lock[ message ] );
	level.flags_lock[ message ] = false;
#/ 	
	//do this check so we don't unneccessarily send a notify
	if (	level.flag[ message ] )
	{
		level.flag[ message ] = false;
		level notify( message );
		set_trigger_flag_permissions( message );
	}
}

/*
=============
///ScriptDocBegin
"Name: flag_waitopen( <flagname> )"
"Summary: Waits for the flag to open"
"Module: Flag"
"MandatoryArg: <flagname>: The flag"
"Example: flag_waitopen( "get_me_bagels" );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/

flag_waitopen( msg )
{
	while( level.flag[ msg ] )
		level waittill( msg );
}

script_gen_dump_addline( string, signature )
{
	
	if ( !isdefined( string ) )
		string = "nowrite";// some things like the standardized CSV sound entries don't really need anything in script. just the asset
		
	if ( !isdefined( level._loadstarted ) )
	{
			// stashes commands away so they can be handled in the correct place within load
			if ( !isdefined( level.script_gen_dump_preload ) )
				level.script_gen_dump_preload = [];
			struct = spawnstruct();
			struct.string = string;
			struct.signature = signature;
			level.script_gen_dump_preload[ level.script_gen_dump_preload.size ] = struct;
			return;
	}
		
		
	if ( !isdefined( level.script_gen_dump[ signature ] ) )
		level.script_gen_dump_reasons[ level.script_gen_dump_reasons.size ] = "Added: " + string;// console print as well as triggering the dump
	level.script_gen_dump[ signature ] = string;
	level.script_gen_dump2[ signature ] = string;// second array gets compared later with saved array. When something is missing dump is generated
}

/* 
 ============= 
///ScriptDocBegin
"Name: array_thread( <entities> , <process> , <var1> , <var2> , <var3> )"
"Summary: Threads the < process > function on every entity in the < entities > array. The entity will become "self" in the specified function."
"Module: Array"
"CallOn: "
"MandatoryArg: <entities> : array of entities to thread the process"
"MandatoryArg: <process> : pointer to a script function"
"OptionalArg: <var1> : parameter 1 to pass to the process"
"OptionalArg: <var2> : parameter 2 to pass to the process"
"OptionalArg: <var3> : parameter 3 to pass to the process"
"Example: array_thread( getaiarray( "allies" ), ::set_ignoreme, false );"
"SPMP: both"
///ScriptDocEnd
 ============= 
*/ 
array_thread( entities, process, var1, var2, var3 )
{
	keys = getArrayKeys( entities );
	
	if ( isdefined( var3 ) )
	{
		for( i = 0 ; i < keys.size ; i ++ )
			entities[ keys[ i ] ] thread [[ process ]]( var1, var2, var3 );
			
		return;
	}

	if ( isdefined( var2 ) )
	{
		for( i = 0 ; i < keys.size ; i ++ )
			entities[ keys[ i ] ] thread [[ process ]]( var1, var2 );
			
		return;
	}

	if ( isdefined( var1 ) )
	{
		for( i = 0 ; i < keys.size ; i ++ )
			entities[ keys[ i ] ] thread [[ process ]]( var1 );
			
		return;
	}

	for( i = 0 ; i < keys.size ; i ++ )
		entities[ keys[ i ] ] thread [[ process ]]();
}

array_thread4( entities, process, var1, var2, var3, var4 )
{
	keys = getArrayKeys( entities );
	for( i = 0 ; i < keys.size ; i ++ )
		entities[ keys[ i ] ] thread [[ process ]]( var1, var2, var3, var4 );
}

array_thread5( entities, process, var1, var2, var3, var4, var5 )
{
	keys = getArrayKeys( entities );
	for( i = 0 ; i < keys.size ; i ++ )
		entities[ keys[ i ] ] thread [[ process ]]( var1, var2, var3, var4, var5 );
}

remove_undefined_from_array( array )
{
	newarray = [];
	for( i = 0; i < array.size; i ++ )
	{
		if ( !isdefined( array[ i ] ) )
			continue;
		newarray[ newarray.size ] = array[ i ];
	}
	return newarray;
}

/* 
 ============= 
///ScriptDocBegin
"Name: trigger_on( <name>, <type> )"
"Summary: Turns a trigger on. This only needs to be called if it was previously turned off"
"Module: Trigger"
"CallOn: A trigger"
"OptionalArg: <name> : the name corrisponding to a targetname or script_noteworthy to grab the trigger internally"
"OptionalArg: <type> : the type( targetname, or script_noteworthy ) corrisponding to a name to grab the trigger internally"
"Example: trigger trigger_on(); -or- trigger_on( "base_trigger", "targetname" )"
"SPMP: both"
///ScriptDocEnd
 ============= 
 */ 
trigger_on( name, type )
{
	if ( isdefined ( name ) && isdefined( type ) )
	{
		ents = getentarray( name, type );
		array_thread( ents, ::trigger_on_proc );
	}
	else
		self trigger_on_proc();	
}

trigger_on_proc()
{
	if ( isDefined( self.realOrigin ) )
		self.origin = self.realOrigin;
	self.trigger_off = undefined;
}


 /* 
 ============= 
///ScriptDocBegin
"Name: trigger_off( <name>, <type> )"
"Summary: Turns a trigger off so it can no longer be triggered."
"Module: Trigger"
"CallOn: A trigger"
"OptionalArg: <name> : the name corrisponding to a targetname or script_noteworthy to grab the trigger internally"
"OptionalArg: <type> : the type( targetname, or script_noteworthy ) corrisponding to a name to grab the trigger internally"
"Example: trigger trigger_off();"
"SPMP: both"
///ScriptDocEnd
 ============= 
 */
trigger_off( name, type )
{
	if ( isdefined ( name ) && isdefined( type ) )
	{
		ents = getentarray( name, type );
		array_thread( ents, ::trigger_off_proc );
	}
	else
		self trigger_off_proc();	
}
 
trigger_off_proc()
{
	if ( !isDefined( self.realOrigin ) )
		self.realOrigin = self.origin;

	if ( self.origin == self.realorigin )
		self.origin += ( 0, 0, -10000 );
	self.trigger_off = true;
}

set_trigger_flag_permissions( msg )
{
	// turns triggers on or off depending on if they have the proper flags set, based on their shift-g menu settings

	// this can be init before _load has run, thanks to AI.
	if ( !isdefined( level.trigger_flags ) )
		return;

	// cheaper to do the upkeep at this time rather than with endons and waittills on the individual triggers	
	level.trigger_flags[ msg ] = remove_undefined_from_array( level.trigger_flags[ msg ] );
	array_thread( level.trigger_flags[ msg ], ::update_trigger_based_on_flags );
}

update_trigger_based_on_flags()
{
	true_on = true;
	if ( isdefined( self.script_flag_true ) )
	{
		true_on = false;
		tokens = create_flags_and_return_tokens( self.script_flag_true );
		
		// stay off unless all the flags are false
		for( i=0; i < tokens.size; i++ )
		{
			if ( flag( tokens[ i ] ) )
			{
				true_on = true;
				break;
			}
		}	
	}
	
	false_on = true;
	if ( isdefined( self.script_flag_false ) )
	{
		tokens = create_flags_and_return_tokens( self.script_flag_false );
		
		// stay off unless all the flags are false
		for( i=0; i < tokens.size; i++ )
		{
			if ( flag( tokens[ i ] ) )
			{
				false_on = false;
				break;
			}
		}	
	}
	
	[ [ level.trigger_func[ true_on && false_on ] ] ]();
}

create_flags_and_return_tokens( flags )
{
	tokens = strtok( flags, " " );	

	// create the flag if level script does not
	for( i=0; i < tokens.size; i++ )
	{
		if ( !isdefined( level.flag[ tokens[ i ] ] ) )
		{
			flag_init( tokens[ i ] );
		}
	}
	
	return tokens;
}

init_trigger_flags()
{
	level.trigger_flags = [];
	level.trigger_func[ true ] = ::trigger_on;
	level.trigger_func[ false ] = ::trigger_off;
}

 /* 
 ============= 
///ScriptDocBegin
"Name: getstructarray( <name> , <type )"
"Summary: gets an array of script_structs"
"Module: Array"
"CallOn: An entity"
"MandatoryArg: <name> : "
"MandatoryArg: <type> : "
"Example: fxemitters = getstructarray( "streetlights", "targetname" )"
"SPMP: both"
///ScriptDocEnd
 ============= 
 */ 

getstructarray( name, type )
{
	assertEx( isdefined( level.struct_class_names ), "Tried to getstruct before the structs were init" );
	
	array = level.struct_class_names[ type ][ name ];
	if ( !isdefined( array ) )
		return [];
	return array;
}

struct_class_init()
{
	assertEx( !isdefined( level.struct_class_names ), "level.struct_class_names is being initialized in the wrong place! It shouldn't be initialized yet." );
	
	level.struct_class_names = [];
	level.struct_class_names[ "target" ] = [];
	level.struct_class_names[ "targetname" ] = [];
	level.struct_class_names[ "script_noteworthy" ] = [];
	level.struct_class_names[ "script_linkname" ] = [];
	
	for ( i=0; i < level.struct.size; i++ )
	{
		if ( isdefined( level.struct[ i ].targetname ) )
		{
			if ( !isdefined( level.struct_class_names[ "targetname" ][ level.struct[ i ].targetname ] ) )
				level.struct_class_names[ "targetname" ][ level.struct[ i ].targetname ] = [];
			
			size = level.struct_class_names[ "targetname" ][ level.struct[ i ].targetname ].size;
			level.struct_class_names[ "targetname" ][ level.struct[ i ].targetname ][ size ] = level.struct[ i ];
		}
		if ( isdefined( level.struct[ i ].target ) )
		{
			if ( !isdefined( level.struct_class_names[ "target" ][ level.struct[ i ].target ] ) )
				level.struct_class_names[ "target" ][ level.struct[ i ].target ] = [];
			
			size = level.struct_class_names[ "target" ][ level.struct[ i ].target ].size;
			level.struct_class_names[ "target" ][ level.struct[ i ].target ][ size ] = level.struct[ i ];
		}
		if ( isdefined( level.struct[ i ].script_noteworthy ) )
		{
			if ( !isdefined( level.struct_class_names[ "script_noteworthy" ][ level.struct[ i ].script_noteworthy ] ) )
				level.struct_class_names[ "script_noteworthy" ][ level.struct[ i ].script_noteworthy ] = [];
			
			size = level.struct_class_names[ "script_noteworthy" ][ level.struct[ i ].script_noteworthy ].size;
			level.struct_class_names[ "script_noteworthy" ][ level.struct[ i ].script_noteworthy ][ size ] = level.struct[ i ];
		}
		if ( isdefined( level.struct[ i ].script_linkname ) )
		{
			assertex( !isdefined( level.struct_class_names[ "script_linkname" ][ level.struct[ i ].script_linkname ] ), "Two structs have the same linkname" );
			level.struct_class_names[ "script_linkname" ][ level.struct[ i ].script_linkname ][ 0 ] = level.struct[ i ];
		}
	}
}

fileprint_start( file )
{
	 /#
	filename = file;

//hackery here, sometimes the file just doesn't open so keep trying
//	file = -1;
//	while( file == -1 )
//	{
		file = openfile( filename, "write" );
//		if (file == -1)
//			wait .05; // try every frame untill the file becomes writeable
//	}
	level.fileprint = file;
	level.fileprintlinecount = 0;
	level.fileprint_filename = filename;
	#/ 
}

 /* 
 ============= 
///ScriptDocBegin
"Name: fileprint_map_start( <filename> )"
"Summary: starts map export with the file trees\cod3\cod3\map_source\xenon_export\ < filename > .map adds header / worldspawn entity to the map.  Use this if you want to start a .map export."
"Module: Fileprint"
"CallOn: Level"
"MandatoryArg: <param1> : "
"OptionalArg: <param2> : "
"Example: fileprint_map_start( filename );"
"SPMP: singleplayer"
///ScriptDocEnd
 ============= 
 */ 

fileprint_map_start( file )
{
	 /#
	file = "map_source/" + file + ".map";
	fileprint_start( file );

	// for the entity count
	level.fileprint_mapentcount = 0;

	fileprint_map_header( true );
	#/ 
	
}

fileprint_chk( file , str )
{
	/#
		//dodging infinite loops for file dumping. kind of dangerous
		level.fileprintlinecount++;
		if (level.fileprintlinecount>400)
		{
			wait .05;
			level.fileprintlinecount++;
			level.fileprintlinecount = 0;
		}
		fprintln( file, str );
	#/
}

fileprint_map_header( bInclude_blank_worldspawn )
{
	if ( !isdefined( bInclude_blank_worldspawn ) )
		bInclude_blank_worldspawn = false;
		
	// this may need to be updated if map format changes
	assert( isdefined( level.fileprint ) );
	 /#
	fileprint_chk( level.fileprint, "iwmap 4" );
	fileprint_chk( level.fileprint, "\"000_Global\" flags  active" );
	fileprint_chk( level.fileprint, "\"The Map\" flags" ); 
	
	if ( !bInclude_blank_worldspawn )
		return;
	 fileprint_map_entity_start();
	 fileprint_map_keypairprint( "classname", "worldspawn" );
	 fileprint_map_entity_end();

	#/ 
}

 /* 
 ============= 
///ScriptDocBegin
"Name: fileprint_map_keypairprint( <key1> , <key2> )"
"Summary: prints a pair of keys to the current open map( by fileprint_map_start() )"
"Module: Fileprint"
"CallOn: Level"
"MandatoryArg: <key1> : "
"MandatoryArg: <key2> : "
"Example: fileprint_map_keypairprint( "classname", "script_model" );"
"SPMP: singleplayer"
///ScriptDocEnd
 ============= 
 */ 

fileprint_map_keypairprint( key1, key2 )
{
	 /#
	assert( isdefined( level.fileprint ) );
	fileprint_chk( level.fileprint, "\"" + key1 + "\" \"" + key2 + "\"" );
	#/ 
}

 /* 
 ============= 
///ScriptDocBegin
"Name: fileprint_map_entity_start()"
"Summary: prints entity number and opening bracket to currently opened file"
"Module: Fileprint"
"CallOn: Level"
"Example: fileprint_map_entity_start();"
"SPMP: singleplayer"
///ScriptDocEnd
 ============= 
 */ 

fileprint_map_entity_start()
{
	 /#
	assert( !isdefined( level.fileprint_entitystart ) );
	level.fileprint_entitystart = true;
	assert( isdefined( level.fileprint ) );
	fileprint_chk( level.fileprint, "// entity " + level.fileprint_mapentcount );
	fileprint_chk( level.fileprint, "{" );
	level.fileprint_mapentcount ++ ;
	#/ 
}

 /* 
 ============= 
///ScriptDocBegin
"Name: fileprint_map_entity_end()"
"Summary: close brackets an entity, required for the next entity to begin"
"Module: Fileprint"
"CallOn: Level"
"Example: fileprint_map_entity_end();"
"SPMP: singleplayer"
///ScriptDocEnd
 ============= 
 */ 

fileprint_map_entity_end()
{
	 /#
	assert( isdefined( level.fileprint_entitystart ) );
	assert( isdefined( level.fileprint ) );
	level.fileprint_entitystart = undefined;
	fileprint_chk( level.fileprint, "}" );
	#/ 
}

 /* 
 ============= 
///ScriptDocBegin
"Name: fileprint_end()"
"Summary: saves the currently opened file"
"Module: Fileprint"
"CallOn: Level"
"Example: fileprint_end();"
"SPMP: singleplayer"
///ScriptDocEnd
 ============= 
 */ 
 
fileprint_end()
{
	 /#
	assert( !isdefined( level.fileprint_entitystart ) );
	saved = closefile( level.fileprint );
	if (saved != 1)
	{
		println("-----------------------------------");
		println(" ");
		println("file write failure");
		println("file with name: "+level.fileprint_filename);
		println("make sure you checkout the file you are trying to save");
		println("note: USE P4 Search to find the file and check that one out");
		println("      Do not checkin files in from the xenonoutput folder, ");
		println("      this is junctioned to the proper directory where you need to go");
		println("junctions looks like this");
		println(" ");
		println("..\\xenonOutput\\scriptdata\\createfx      ..\\share\\raw\\maps\\createfx");
		println("..\\xenonOutput\\scriptdata\\createart     ..\\share\\raw\\maps\\createart");
		println("..\\xenonOutput\\scriptdata\\vision        ..\\share\\raw\\vision");
		println("..\\xenonOutput\\scriptdata\\scriptgen     ..\\share\\raw\\maps\\scriptgen");
		println("..\\xenonOutput\\scriptdata\\zone_source   ..\\xenon\\zone_source");
		println("..\\xenonOutput\\accuracy                  ..\\share\\raw\\accuracy");
		println("..\\xenonOutput\\scriptdata\\map_source    ..\\map_source\\xenon_export");
		println(" ");
		println("-----------------------------------");
		
		println( "File not saved( see console.log for info ) " );
	}
	level.fileprint = undefined;
	level.fileprint_filename = undefined;
	#/ 
}

 /* 
 ============= 
///ScriptDocBegin
"Name: fileprint_radiant_vec( <vector> )"
"Summary: this converts a vector to a .map file readable format"
"Module: Fileprint"
"CallOn: An entity"
"MandatoryArg: <vector> : "
"Example: origin_string = fileprint_radiant_vec( vehicle.angles )"
"SPMP: singleplayer"
///ScriptDocEnd
 ============= 
 */ 

fileprint_radiant_vec( vector )
{
	 /#
		string = "" + vector[ 0 ] + " " + vector[ 1 ] + " " + vector[ 2 ] + "";
		return string;
	#/ 
}
