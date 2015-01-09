#include maps\_utility;

loadPresets()
{
	// add your own preset eq filters here
	// should be used for commonly used, generic filters
	// see _ambient.gsc for defining specialized filters
	
	// sample test eq filters
	// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
	// up to three bands( 0, 1, 2 ) for a filter
	// filter types are: lowshelf, highshelf, bell, lowpass, highpass
	// freq ranges from 20 Hz to 20 kHz
	// gain has no code restricted range, but should probably be between + / - 18 dB
	// q must be > 0 and has no code restricted max
	
	// example of a three band filter
	// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
	// defineFilter( "test", 0, "lowshelf", 3000, 6, 2 );
	// defineFilter( "test", 1, "highshelf", 3000, -12, 2 );
	// defineFilter( "test", 2, "bell", 1500, 6, 3 );
	
	// example of a single band filter
	// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
	// defineFilter( "single", 0, "highpass", 10000, 1, 1 );

// ***********************************************************
	
	level.eq_defs = [];
	level.ambient_reverb = [];

	define_reverb( "ac130" );
	set_reverb_roomtype( "ac130", 		"sewerpipe" );
	set_reverb_drylevel( "ac130", 		0.9 );
	set_reverb_wetlevel( "ac130", 		0.05 );
	set_reverb_fadetime( "ac130", 		2 );
	set_reverb_priority( "ac130", 		"snd_enveffectsprio_level" );

	define_reverb( "alley" );
	set_reverb_roomtype( "alley", 		"alley" );
	set_reverb_drylevel( "alley", 		0.9 );
	set_reverb_wetlevel( "alley", 		0.1 );
	set_reverb_fadetime( "alley", 		2 );
	set_reverb_priority( "alley", 		"snd_enveffectsprio_level" );

	define_reverb( "bunker" );
	set_reverb_roomtype( "bunker",	 	"stoneroom" );
	set_reverb_drylevel( "bunker", 		0.8 );
	set_reverb_wetlevel( "bunker", 		0.4 );
	set_reverb_fadetime( "bunker", 		2 );
	set_reverb_priority( "bunker", 		"snd_enveffectsprio_level" );

	define_reverb( "city" );
	set_reverb_roomtype( "city", 			"city" );
	set_reverb_drylevel( "city", 			0.8 );
	set_reverb_wetlevel( "city", 			0.3 );
	set_reverb_fadetime( "city", 			2 );
	set_reverb_priority( "city", 			"snd_enveffectsprio_level" );

	define_reverb( "container" );
	set_reverb_roomtype( "container", 		"sewerpipe" );
	set_reverb_drylevel( "container", 		0.9 );
	set_reverb_wetlevel( "container", 		0.4 );
	set_reverb_fadetime( "container", 		2 );
	set_reverb_priority( "container", 		"snd_enveffectsprio_level" );

	define_reverb( "exterior" );
	set_reverb_roomtype( "exterior", 		"city" );
	set_reverb_drylevel( "exterior", 		0.9 );
	set_reverb_wetlevel( "exterior", 		0.15 );
	set_reverb_fadetime( "exterior", 		2 );
	set_reverb_priority( "exterior", 		"snd_enveffectsprio_level" );

	define_reverb( "exterior1" );
	set_reverb_roomtype( "exterior1", 		"alley" );
	set_reverb_drylevel( "exterior1", 		0.9 );
	set_reverb_wetlevel( "exterior1", 		0.2 );
	set_reverb_fadetime( "exterior1", 		2 );
	set_reverb_priority( "exterior1", 		"snd_enveffectsprio_level" );

	define_reverb( "exterior2" );
	set_reverb_roomtype( "exterior2", 		"alley" );
	set_reverb_drylevel( "exterior2", 		0.9 );
	set_reverb_wetlevel( "exterior2", 		0.2 );
	set_reverb_fadetime( "exterior2", 		2 );
	set_reverb_priority( "exterior2", 		"snd_enveffectsprio_level" );

	define_reverb( "exterior3" );
	set_reverb_roomtype( "exterior3", 		"alley" );
	set_reverb_drylevel( "exterior3", 		0.9 );
	set_reverb_wetlevel( "exterior3", 		0.2 );
	set_reverb_fadetime( "exterior3", 		2 );
	set_reverb_priority( "exterior3", 		"snd_enveffectsprio_level" );

	define_reverb( "exterior4" );
	set_reverb_roomtype( "exterior4", 		"alley" );
	set_reverb_drylevel( "exterior4", 		0.9 );
	set_reverb_wetlevel( "exterior4", 		0.2 );
	set_reverb_fadetime( "exterior4", 		2 );
	set_reverb_priority( "exterior4", 		"snd_enveffectsprio_level" );

	define_reverb( "exterior5" );
	set_reverb_roomtype( "exterior5", 		"alley" );
	set_reverb_drylevel( "exterior5", 		0.9 );
	set_reverb_wetlevel( "exterior5", 		0.2 );
	set_reverb_fadetime( "exterior5", 		2 );
	set_reverb_priority( "exterior5", 		"snd_enveffectsprio_level" );

	define_reverb( "forrest" );
	set_reverb_roomtype( "forrest", 		"forest" );
	set_reverb_drylevel( "forrest", 		0.9 );
	set_reverb_wetlevel( "forrest", 		0.1 );
	set_reverb_fadetime( "forrest", 		2 );
	set_reverb_priority( "forrest", 		"snd_enveffectsprio_level" );

	define_reverb( "hangar" );
	set_reverb_roomtype( "hangar",	 	"hangar" );
	set_reverb_drylevel( "hangar", 		0.8 );
	set_reverb_wetlevel( "hangar", 		0.3 );
	set_reverb_fadetime( "hangar", 		2 );
	set_reverb_priority( "hangar", 		"snd_enveffectsprio_level" );

	define_reverb( "interior" );
	set_reverb_roomtype( "interior",	 	"stonecorridor" );
	set_reverb_drylevel( "interior", 		0.9 );
	set_reverb_wetlevel( "interior", 		0.3 );
	set_reverb_fadetime( "interior", 		2 );
	set_reverb_priority( "interior", 		"snd_enveffectsprio_level" );

	define_reverb( "interior_metal" );
	set_reverb_roomtype( "interior_metal", 	"sewerpipe" );
	set_reverb_drylevel( "interior_metal", 	0.9 );
	set_reverb_wetlevel( "interior_metal", 	0.2 );
	set_reverb_fadetime( "interior_metal", 	2 );
	set_reverb_priority( "interior_metal", 	"snd_enveffectsprio_level" );

	define_reverb( "interior_stone" );
	set_reverb_roomtype( "interior_stone", 	"stoneroom" );
	set_reverb_drylevel( "interior_stone", 	0.9 );
	set_reverb_wetlevel( "interior_stone", 	0.2 );
	set_reverb_fadetime( "interior_stone", 	2 );
	set_reverb_priority( "interior_stone", 	"snd_enveffectsprio_level" );

	define_reverb( "interior_vehicle" );
	set_reverb_roomtype( "interior_vehicle", 	"carpetedhallway" );
	set_reverb_drylevel( "interior_vehicle", 	0.9 );
	set_reverb_wetlevel( "interior_vehicle", 	0.1 );
	set_reverb_fadetime( "interior_vehicle", 	2 );
	set_reverb_priority( "interior_vehicle", 	"snd_enveffectsprio_level" );

	define_reverb( "interior_wood" );
	set_reverb_roomtype( "interior_wood", 	"livingroom" );
	set_reverb_drylevel( "interior_wood", 	0.9 );
	set_reverb_wetlevel( "interior_wood", 	0.1 );
	set_reverb_fadetime( "interior_wood", 	2 );
	set_reverb_priority( "interior_wood", 	"snd_enveffectsprio_level" );

	define_reverb( "mountains" );
	set_reverb_roomtype( "mountains", 		"mountains" );
	set_reverb_drylevel( "mountains", 		0.8 );
	set_reverb_wetlevel( "mountains", 		0.3 );
	set_reverb_fadetime( "mountains", 		2 );
	set_reverb_priority( "mountains", 		"snd_enveffectsprio_level" );

	define_reverb( "pipe" );
	set_reverb_roomtype( "pipe", 			"sewerpipe" );
	set_reverb_drylevel( "pipe", 			0.9 );
	set_reverb_wetlevel( "pipe", 			0.4 );
	set_reverb_fadetime( "pipe", 			2 );
	set_reverb_priority( "pipe", 			"snd_enveffectsprio_level" );

	define_reverb( "shanty" );
	set_reverb_roomtype( "shanty", 		"livingroom" );
	set_reverb_drylevel( "shanty", 		0.9 );
	set_reverb_wetlevel( "shanty", 		0.1 );
	set_reverb_fadetime( "shanty", 		2 );
	set_reverb_priority( "shanty", 		"snd_enveffectsprio_level" );

	define_reverb( "underpass" );
	set_reverb_roomtype( "underpass", 		"stonecorridor" );
	set_reverb_drylevel( "underpass", 		0.9 );
	set_reverb_wetlevel( "underpass", 		0.3 );
	set_reverb_fadetime( "underpass", 		2 );
	set_reverb_priority( "underpass", 		"snd_enveffectsprio_level" );

	define_reverb( "tunnel" );
	set_reverb_roomtype( "tunnel", 		"stonecorridor" );
	set_reverb_drylevel( "tunnel", 		0.8 );
	set_reverb_wetlevel( "tunnel", 		0.5 );
	set_reverb_fadetime( "tunnel", 		2 );
	set_reverb_priority( "tunnel", 		"snd_enveffectsprio_level" );


// ***********************************************************

	
	define_filter( "ac130" );
	set_filter_type( "ac130", 0, 			"highshelf" );
	set_filter_freq( "ac130", 0, 			2800 );
	set_filter_gain( "ac130", 0, 			-12 );
	set_filter_q( "ac130", 0, 			1 );
	set_filter_type( "ac130", 1, 			"lowshelf" );
	set_filter_freq( "ac130", 1, 			1000 );
	set_filter_gain( "ac130", 1, 			-6 );
	set_filter_q( "ac130", 1, 			1 );
	add_channel_to_filter( "ac130", 		"auto" );
	add_channel_to_filter( "ac130",		 "auto2" );
//	add_channel_to_filter( "ac130", 		"effects1" );
	add_channel_to_filter( "ac130",		 "effects2" );
	add_channel_to_filter( "ac130",		 "vehicle" );
	add_channel_to_filter( "ac130", 		"weapon" );

	define_filter( "alley" );
	set_filter_type( "alley", 0, 			"highshelf" );
	set_filter_freq( "alley", 0, 			3500 );
	set_filter_gain( "alley", 0, 			-2 );
	set_filter_q( "alley", 0, 			1 );
	add_channel_to_filter( "alley", 		"ambient" );
	add_channel_to_filter( "alley", 		"element" );
	add_channel_to_filter( "alley", 		"vehicle" );
	add_channel_to_filter( "alley",		 "weapon" );
	add_channel_to_filter( "alley", 		"voice" );

	define_filter( "bunker" );
	set_filter_type( "bunker", 0, 		"highshelf" );
	set_filter_freq( "bunker", 0, 		3500 );
	set_filter_gain( "bunker", 0, 		-2 );
	set_filter_q( "bunker", 0, 			1 );
	add_channel_to_filter( "bunker", 		"ambient" );
	add_channel_to_filter( "bunker", 		"element" );
	add_channel_to_filter( "bunker", 		"vehicle" );
	add_channel_to_filter( "bunker", 		"weapon" );
	add_channel_to_filter( "bunker", 		"voice" );

	define_filter( "container" );
	set_filter_type( "container", 0, 		"highshelf" );
	set_filter_freq( "container", 0, 		3500 );
	set_filter_gain( "container", 0, 		-6 );
	set_filter_q( "container", 0, 		1 );
	add_channel_to_filter( "container",		"ambient" );
	add_channel_to_filter( "container", 	"element" );
	add_channel_to_filter( "container",		 "vehicle" );
	add_channel_to_filter( "container", 	"weapon" );
	add_channel_to_filter( "container", 	"voice" );

	define_filter( "hangar" );
	set_filter_type( "hangar", 0, 		"highshelf" );
	set_filter_freq( "hangar", 0, 		3500 );
	set_filter_gain( "hangar", 0, 		-2 );
	set_filter_q( "hangar", 0, 			1 );
	add_channel_to_filter( "hangar", 		"ambient" );
	add_channel_to_filter( "hangar", 		"element" );
	add_channel_to_filter( "hangar", 		"vehicle" );
	add_channel_to_filter( "hangar", 		"weapon" );
	add_channel_to_filter( "hangar", 		"voice" );

	define_filter( "interior_metal" );
	set_filter_type( "interior_metal", 0, 	"highshelf" );
	set_filter_freq( "interior_metal", 0, 	3500 );
	set_filter_gain( "interior_metal", 0, 	-6 );
	set_filter_q( "interior_metal", 0, 		1 );
	add_channel_to_filter( "interior_metal", "ambient" );
	add_channel_to_filter( "interior_metal", "element" );
	add_channel_to_filter( "interior_metal", "vehicle" );
	add_channel_to_filter( "interior_metal", "weapon" );
	add_channel_to_filter( "interior_metal", "voice" );

	define_filter( "interior_stone" );
	set_filter_type( "interior_stone", 0, 	"highshelf" );
	set_filter_freq( "interior_stone", 0, 	3500 );
	set_filter_gain( "interior_stone", 0, 	-6 );
	set_filter_q( "interior_stone", 0, 		1 );
	add_channel_to_filter( "interior_stone", "ambient" );
	add_channel_to_filter( "interior_stone", "element" );
	add_channel_to_filter( "interior_stone", "vehicle" );
	add_channel_to_filter( "interior_stone", "weapon" );
	add_channel_to_filter( "interior_stone", "voice" );

	define_filter( "interior_vehicle" );
	set_filter_type( "interior_vehicle", 0, 	"highshelf" );
	set_filter_freq( "interior_vehicle", 0, 	2700 );
	set_filter_gain( "interior_vehicle", 0, 	-12 );
	set_filter_q( "interior_vehicle", 0, 		1 );
	add_channel_to_filter( "interior_vehicle", "ambient" );
	add_channel_to_filter( "interior_vehicle", "auto" );
	add_channel_to_filter( "interior_vehicle", "auto2" );
	add_channel_to_filter( "interior_vehicle", "autodog" );
	add_channel_to_filter( "interior_vehicle", "body" );
	add_channel_to_filter( "interior_vehicle", "element" );
	add_channel_to_filter( "interior_vehicle", "vehicle" );
	add_channel_to_filter( "interior_vehicle", "weapon" );
	add_channel_to_filter( "interior_vehicle", "voice" );

	define_filter( "interior_wood" );
	set_filter_type( "interior_wood", 0, 	"highshelf" );
	set_filter_freq( "interior_wood", 0, 	3500 );
	set_filter_gain( "interior_wood", 0, 	-6 );
	set_filter_q( "interior_wood", 0, 		1 );
	add_channel_to_filter( "interior_wood",	"ambient" );
	add_channel_to_filter( "interior_wood", 	"element" );
	add_channel_to_filter( "interior_wood",	 "vehicle" );
	add_channel_to_filter( "interior_wood", 	"weapon" );
	add_channel_to_filter( "interior_wood", 	"voice" );

	define_filter( "pipe" );
	set_filter_type( "pipe", 0, 			"highshelf" );
	set_filter_freq( "pipe", 0, 			3500 );
	set_filter_gain( "pipe", 0, 			-6 );
	set_filter_q( "pipe", 0, 			1 );
	add_channel_to_filter( "pipe",		"ambient" );
	add_channel_to_filter( "pipe", 		"element" );
	add_channel_to_filter( "pipe",		 "vehicle" );
	add_channel_to_filter( "pipe", 		"weapon" );
	add_channel_to_filter( "pipe", 		"voice" );

	define_filter( "shanty" );
	set_filter_type( "shanty", 0, 		"highshelf" );
	set_filter_freq( "shanty", 0, 		3500 );
	set_filter_gain( "shanty", 0, 		-2 );
	set_filter_q( "shanty", 0, 			1 );
	add_channel_to_filter( "shanty", 		"ambient" );
	add_channel_to_filter( "shanty", 		"element" );
	add_channel_to_filter( "shanty", 		"vehicle" );
	add_channel_to_filter( "shanty", 		"weapon" );
	add_channel_to_filter( "shanty", 		"voice" );

	define_filter( "tunnel" );
	set_filter_type( "tunnel", 0, 		"highshelf" );
	set_filter_freq( "tunnel", 0, 		3500 );
	set_filter_gain( "tunnel", 0, 		-2 );
	set_filter_q( "tunnel", 0, 			1 );
	add_channel_to_filter( "tunnel", 		"ambient" );
	add_channel_to_filter( "tunnel", 		"element" );
	add_channel_to_filter( "tunnel", 		"vehicle" );
	add_channel_to_filter( "tunnel", 		"weapon" );
	add_channel_to_filter( "tunnel", 		"voice" );

	define_filter( "underpass" );
	set_filter_type( "underpass", 0, 		"highshelf" );
	set_filter_freq( "underpass", 0, 		3500 );
	set_filter_gain( "underpass", 0, 		-2 );
	set_filter_q( "underpass", 0, 		1 );
	add_channel_to_filter( "underpass", 	"ambient" );
	add_channel_to_filter( "underpass", 	"element" );
	add_channel_to_filter( "underpass", 	"vehicle" );
	add_channel_to_filter( "underpass", 	"weapon" );
	add_channel_to_filter( "underpass", 	"voice" );


}

// ***********************************************************

 /* 
 ============= 
///ScriptDocBegin
"Name: define_filter( <name> )"
"Summary: Creates a new filter"
"Module: Ambience"
"MandatoryArg: <name> : The name of the filter."
"Example: define_filter( "interior_stone" );"
"SPMP: singleplayer"
///ScriptDocEnd
 ============= 
 */ 
define_filter( name )
{
	assertex( !isdefined( level.eq_defs[ name ] ), "Filter " + name + " is already defined" );
	level.eq_defs[ name ] = [];
}

 /* 
 ============= 
///ScriptDocBegin
"Name: set_filter_type( <name> , <band> , <type> )"
"Summary: Sets the type for a filter"
"Module: Ambience"
"MandatoryArg: <name> : The name of the filter."
"MandatoryArg: <band> : The band( 0 to 2 ) "
"MandatoryArg: <type> : The filter type "
"Example: set_filter_type( "underpass", 0, "highshelf" );"
"SPMP: singleplayer"
///ScriptDocEnd
 ============= 
 */ 
set_filter_type( name, band, type )
{
	assertex( isdefined( level.eq_defs[ name ] ), "Filter " + name + " is not defined" );
	assert( band >= 0 && band < 3 );
	level.eq_defs[ name ][ "type" ][ band ] = type;
}

 /* 
 ============= 
///ScriptDocBegin
"Name: set_filter_freq( <name> , <band> , <freq> )"
"Summary: Sets the freq for a filter"
"Module: Ambience"
"MandatoryArg: <name> : The name of the filter."
"MandatoryArg: <band> : The band( 0 to 2 ) "
"MandatoryArg: <freq> : The filter freq "
"Example: set_filter_freq( "underpass", 0, 3500 );"
"SPMP: singleplayer"
///ScriptDocEnd
 ============= 
 */ 
set_filter_freq( name, band, freq )
{
	assertex( isdefined( level.eq_defs[ name ] ), "Filter " + name + " is not defined" );
	assert( band >= 0 && band < 3 );
	level.eq_defs[ name ][ "freq" ][ band ] = freq;
}

 /* 
 ============= 
///ScriptDocBegin
"Name: set_filter_gain( <name> , <band> , <gain> )"
"Summary: Sets the gain for a filter"
"Module: Ambience"
"MandatoryArg: <name> : The name of the filter."
"MandatoryArg: <band> : The band( 0 to 2 ) "
"MandatoryArg: <gain> : The filter gain "
"Example: set_filter_gain( "underpass", 0, -2 );"
"SPMP: singleplayer"
///ScriptDocEnd
 ============= 
 */ 
set_filter_gain( name, band, gain )
{
	assertex( isdefined( level.eq_defs[ name ] ), "Filter " + name + " is not defined" );
	assert( band >= 0 && band < 3 );
	level.eq_defs[ name ][ "gain" ][ band ] = gain;
}

 /* 
 ============= 
///ScriptDocBegin
"Name: set_filter_q( <name> , <band> , <q> )"
"Summary: Sets the q for a filter"
"Module: Ambience"
"MandatoryArg: <name> : The name of the filter."
"MandatoryArg: <band> : The band( 0 to 2 ) "
"MandatoryArg: <q> : The filter q "
"Example: set_filter_q( "underpass", 0, 1 );"
"SPMP: singleplayer"
///ScriptDocEnd
 ============= 
 */ 
set_filter_q( name, band, q )
{
	assertex( isdefined( level.eq_defs[ name ] ), "Filter " + name + " is not defined" );
	assert( band >= 0 && band < 3 );
	level.eq_defs[ name ][ "q" ][ band ] = q;
}


 /* 
 ============= 
///ScriptDocBegin
"Name: define_reverb( <name> )"
"Summary: Creates a new reverb setting"
"Module: Ambience"
"MandatoryArg: <name> : The name of the reverb."
"Example: define_reverb( "interior_stone" );"
"SPMP: singleplayer"
///ScriptDocEnd
 ============= 
 */ 
define_reverb( name )
{
	assertex( !isdefined( level.ambient_reverb[ name ] ), "Reverb " + name + " is already defined" );
	level.ambient_reverb[ name ] = [];
}

 /* 
 ============= 
///ScriptDocBegin
"Name: set_reverb_roomtype( <name> , <roomtype> )"
"Summary: Sets the roomtype for a reverb setting."
"Module: Ambience"
"MandatoryArg: <name> : The reverb setting."
"MandatoryArg: <name> : The roomtype."
"Example: set_reverb_roomtype( "interior_stone", "stoneroom" );"
"SPMP: singleplayer"
///ScriptDocEnd
 ============= 
 */ 
set_reverb_roomtype( name, roomtype )
{
	assertex( isdefined( level.ambient_reverb[ name ] ), "Reverb " + name + " is not defined" );
	level.ambient_reverb[ name ][ "roomtype" ] = roomtype;
}

 /* 
 ============= 
///ScriptDocBegin
"Name: set_reverb_drylevel( <name> , <drylevel> )"
"Summary: Sets the drylevel for a reverb setting."
"Module: Ambience"
"MandatoryArg: <name> : The reverb setting."
"MandatoryArg: <name> : The drylevel."
"Example: set_reverb_drylevel( "interior_stone", 0.6 );"
"SPMP: singleplayer"
///ScriptDocEnd
 ============= 
 */ 
set_reverb_drylevel( name, drylevel )
{
	assertex( isdefined( level.ambient_reverb[ name ] ), "Reverb " + name + " is not defined" );
	level.ambient_reverb[ name ][ "drylevel" ] = drylevel;
}

 /* 
 ============= 
///ScriptDocBegin
"Name: set_reverb_wetlevel( <name> , <wetlevel> )"
"Summary: Sets the roomtype for a reverb setting."
"Module: Ambience"
"MandatoryArg: <name> : The reverb setting."
"MandatoryArg: <name> : The wetlevel."
"Example: set_reverb_wetlevel( "interior_stone", 0.3 );"
"SPMP: singleplayer"
///ScriptDocEnd
 ============= 
 */ 
set_reverb_wetlevel( name, wetlevel )
{
	assertex( isdefined( level.ambient_reverb[ name ] ), "Reverb " + name + " is not defined" );
	level.ambient_reverb[ name ][ "wetlevel" ] = wetlevel;
}

 /* 
 ============= 
///ScriptDocBegin
"Name: set_reverb_fadetime( <name> , <fadetime> )"
"Summary: Sets the fadetime for a reverb setting."
"Module: Ambience"
"MandatoryArg: <name> : The reverb setting."
"MandatoryArg: <name> : The fadetime."
"Example: set_reverb_fadetime( "interior_stone", 2 );"
"SPMP: singleplayer"
///ScriptDocEnd
 ============= 
 */ 
set_reverb_fadetime( name, fadetime )
{
	assertex( isdefined( level.ambient_reverb[ name ] ), "Reverb " + name + " is not defined" );
	level.ambient_reverb[ name ][ "fadetime" ] = fadetime;
}

 /* 
 ============= 
///ScriptDocBegin
"Name: set_reverb_priority( <name> , <priority> )"
"Summary: Sets the priority for a reverb setting."
"Module: Ambience"
"MandatoryArg: <name> : The reverb setting."
"MandatoryArg: <name> : The priority."
"Example: set_reverb_priority( "interior_stone", "snd_enveffectsprio_level" );"
"SPMP: singleplayer"
///ScriptDocEnd
 ============= 
 */ 
set_reverb_priority( name, priority )
{
	assertex( isdefined( level.ambient_reverb[ name ] ), "Reverb " + name + " is not defined" );
	level.ambient_reverb[ name ][ "priority" ] = priority;
}

getFilter( name )
{
	if ( isDefined( name ) && isDefined( level.eq_defs ) && isDefined( level.eq_defs[ name ] ) )
		return level.eq_defs[ name ];
	else 
		return undefined;
}

/*
=============
///ScriptDocBegin
"Name: add_channel_to_filter( <track> , <channel> )"
"Summary: Makes a filter effect a sound channel."
"Module: Ambience"
"MandatoryArg: <track>: The filter. "
"MandatoryArg: <channel>: The channel to add. "
"Example: add_channel_to_filter( "interior_stone", "ambient" );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
add_channel_to_filter( track, channel )
{
	if( !isDefined( level.ambient_eq[ track ] ) )
		level.ambient_eq[ track ] = [];

	level.ambient_eq[ track ][ channel ] = track;
}

// 	EXAMPLE OVERWRITE
//	if ( mission( "bog_a" ) )
//	{
//		// bog_a aint as wet?
//		set_reverb_wetlevel( "interior_stone", 	0.3 );
//	}
