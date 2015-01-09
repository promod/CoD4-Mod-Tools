#include maps\_utility;
#include maps\_equalizer;
#include common_scripts\utility;

/* 			Example map_amb.gsc file:
main()
{
	// Set the underlying ambient track
	level.ambient_track [ "exterior" ] = "ambient_test";
	thread maps\_utility::set_ambient( "exterior" );

	// Set the eq filter for the ambient channels
	// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- - 	
	//   define a filter and give it a name
	//   or use one of the presets( see _equalizer.gsc )
	//   arguments are: name, band, type, freq, gain, q
	// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- - 
	// maps\_equalizer::defineFilter( "test", 0, "lowshelf", 3000, 6, 2 );
	// maps\_equalizer::defineFilter( "test", 1, "highshelf", 3000, -12, 2 );
	// maps\_equalizer::defineFilter( "test", 2, "bell", 1500, 6, 3 );
	
	// attach the filter to a region and channel
	// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
	setupEq( "exterior", "local", "test" );
	
		
	ambientDelay( "exterior", 1.3, 3.4 );// Trackname, min and max delay between ambient events
	ambientEvent( "exterior", "burnville_foley_13b", 			 0.3 );
	ambientEvent( "exterior", "boat_sink", 					 0.6 );
	ambientEvent( "exterior", "bullet_large_canvas", 			 0.3 );
	ambientEvent( "exterior", "explo_boat", 					 1.3 );
	ambientEvent( "exterior", "Stuka_hit", 					 0.1 );
	
	ambientEventStart( "exterior" );
}
*/ 

init()
{
	level.ambient_zones = [];
	add_zone( "ac130" );
	add_zone( "alley" );
	add_zone( "bunker" );
	add_zone( "city" );
	add_zone( "container" );
	add_zone( "exterior" );
	add_zone( "exterior1" );
	add_zone( "exterior2" );
	add_zone( "exterior3" );
	add_zone( "exterior4" );
	add_zone( "exterior5" );
	add_zone( "forrest" );
	add_zone( "hangar" );
	add_zone( "interior" );
	add_zone( "interior_metal" );
	add_zone( "interior_stone" );
	add_zone( "interior_vehicle" );
	add_zone( "interior_wood" );
	add_zone( "mountains" );
	add_zone( "pipe" );
	add_zone( "shanty" );
	add_zone( "tunnel" );
	add_zone( "underpass" );
	


	
	if ( !isDefined( level.ambient_reverb ) )
		level.ambient_reverb = [];

	if ( !isDefined( level.ambient_eq ) )
		level.ambient_eq = [];
	
	if ( !isDefined( level.fxfireloopmod ) )
		level.fxfireloopmod = 1;

	level.eq_main_track = 0;
	level.eq_mix_track = 1;
	level.eq_track[ level.eq_main_track ] = "";
	level.eq_track[ level.eq_mix_track ] = "";
	
	// used to change the meaning of interior / exterior / rain ambience midlevel.
	level.ambient_modifier[ "interior" ] = "";
	level.ambient_modifier[ "exterior" ] = "";
	level.ambient_modifier[ "rain" ] = "";

	// loads any predefined filters in _equalizer.gsc
	loadPresets();
	
}


// starts this ambient track
activateAmbient( ambient )
{
	level.ambient = ambient;

	if ( level.ambient == "exterior" )
		ambient += level.ambient_modifier[ "exterior" ];
	if ( level.ambient == "interior" )
		ambient += level.ambient_modifier[ "interior" ];
		
	assert( isDefined( level.ambient_track ) && isDefined( level.ambient_track[ ambient ] ) );
	ambientPlay( level.ambient_track[ ambient + level.ambient_modifier[ "rain" ] ], 1 );
	thread ambientEventStart( ambient + level.ambient_modifier[ "rain" ] );
	println( "Ambience becomes: ", ambient + level.ambient_modifier[ "rain" ] );
}


ambientVolume()
{
	for ( ;; )
	{
		self waittill( "trigger" );
		activateAmbient( "interior" );
		while ( level.player isTouching( self ) )
			wait 0.1;		
		activateAmbient( "exterior" );
	}
}


ambientDelay( track, min, max )
{
	assertEX( max > min, "Ambient max must be greater than min for track " + track );
	if ( !isdefined( level.ambientEventEnt ) )
		level.ambientEventEnt[ track ] = spawnstruct();
	else
	if ( !isdefined( level.ambientEventEnt[ track ] ) )
		level.ambientEventEnt[ track ] = spawnstruct();
	
	level.ambientEventEnt[ track ].min = min;
	level.ambientEventEnt[ track ].range = max - min;
}

ambientEvent( track, name, weight )
{
	assertEX( isdefined( level.ambientEventEnt ), "ambientDelay has not been run" );
	assertEX( isdefined( level.ambientEventEnt[ track ] ), "ambientDelay has not been run" );

	if ( !isdefined( level.ambientEventEnt[ track ].event_alias ) )
		index = 0;
	else
		index = level.ambientEventEnt[ track ].event_alias.size;

	level.ambientEventEnt[ track ].event_alias[ index ] = name;
	level.ambientEventEnt[ track ].event_weight[ index ] = weight;
}

ambientReverb( type )
{
	level.player setReverb( level.ambient_reverb[ type ][ "priority" ], level.ambient_reverb[ type ][ "roomtype" ], level.ambient_reverb[ type ][ "drylevel" ], level.ambient_reverb[ type ][ "wetlevel" ], level.ambient_reverb[ type ][ "fadetime" ] );
	level waittill( "new ambient event track" );
// 	if ( level.ambient != type )
		level.player deactivatereverb( level.ambient_reverb[ type ][ "priority" ], 2 );
}



setupEq( track, channel, filter )
{
	if ( !isDefined( level.ambient_eq[ track ] ) )
		level.ambient_eq[ track ] = [];
	
	level.ambient_eq[ track ][ channel ] = filter;
}


/* 
ambientEq( track )
{
	if ( !isdefined( level.ambient_eq[ track ] ) )
		return;

	setup_eq_channels( track, level.eq_main_track );

	level waittill( "new ambient event track" );
	channels = getArrayKeys( level.ambient_eq[ track ] );
	for ( i = 0; i < channels.size; i++ )
	{
		channel = channels[ i ];
		for ( band = 0; band < 3; band++ )
		{
			level.player deactivateeq( level.eqIndex, channel, band );
		}
	}
}
*/ 



setup_eq_channels( track, eqIndex )
{
	level.eq_track[ eqIndex ] = "exterior";
	if ( !isdefined( level.ambient_eq[ track ] ) )
	{
		deactivate_index( eqIndex );
		return;
	}
	
	level.eq_track[ eqIndex ] = track;
	
	channels = getArrayKeys( level.ambient_eq[ track ] );
	for ( i = 0; i < channels.size; i++ )
	{
		channel = channels[ i ];
		filter = getFilter( level.ambient_eq[ track ][ channel ] );
		if ( !isdefined( filter ) )
			continue;
			
		for ( band = 0; band < 3; band++ )
		{			
			if ( isdefined( filter[ "type" ][ band ] ) )
				level.player seteq( channel, eqIndex, band, filter[ "type" ][ band ], filter[ "gain" ][ band ], filter[ "freq" ][ band ], filter[ "q" ][ band ] );
			else
				level.player deactivateeq( eqIndex, channel, band );
		}				
	}
}

deactivate_index( eqIndex )
{
	level.player deactivateeq( eqIndex );
}

ambientEventStart( track )
{
	set_ambience_single( track );
}

start_ambient_event( track )
{
	level notify( "new ambient event track" );
	level endon( "new ambient event track" );
	
	assertEX( isdefined( level.ambientEventEnt ), "ambientDelay has not been run" );
	assertEX( isdefined( level.ambientEventEnt[ track ] ), "ambientDelay has not been run" );
	
	if ( !isdefined( level.player.soundEnt ) )
	{
		level.player.soundEnt = spawn( "script_origin", ( 0, 0, 0 ) );
		level.player.soundEnt.playingSound = false;
	}
	else
	{
		if ( level.player.soundEnt.playingSound )
			level.player.soundEnt waittill( "sounddone" );
	}	
	
	ent = level.player.soundEnt;
	min = level.ambientEventEnt[ track ].min;
	range = level.ambientEventEnt[ track ].range;
	
	lastIndex = 0;
	index = 0;
	assertEX( level.ambientEventEnt[ track ].event_alias.size > 1, "Need more than one ambient event for track " + track );
	if ( isdefined( level.ambient_reverb[ track ] ) )
		thread ambientReverb( track );

	for ( ;; )
	{
		wait( min + randomfloat( range ) );
		while ( index == lastIndex )
			index = ambientWeight( track );
			
		lastIndex = index;
		ent.origin = level.player.origin;
		ent linkto( level.player );
		ent playsound( level.ambientEventEnt[ track ].event_alias[ index ], "sounddone" );
		ent.playingSound = true;
		ent waittill( "sounddone" );
		ent.playingSound = false;
	}
}

ambientWeight( track )
{
	total_events = level.ambientEventEnt[ track ].event_alias.size;
	idleanim = randomint( total_events );
	if ( total_events > 1 )
	{
		weights = 0;
		anim_weight = 0;
		
		for ( i = 0;i < total_events;i++ )
		{
			weights++ ;
			anim_weight += level.ambientEventEnt[ track ].event_weight[ i ];
		}
		
		if ( weights == total_events )
		{
			anim_play = randomfloat( anim_weight );
			anim_weight	 = 0;
			
			for ( i = 0;i < total_events;i++ )
			{
				anim_weight += level.ambientEventEnt[ track ].event_weight[ i ];
				if ( anim_play < anim_weight )
				{
					idleanim = i;
					break;
				}
			}
		}
	}
	
	return idleanim;
}		
	

add_zone( zone )
{
	level.ambient_zones[ zone ] = true;
}

check_ambience( type )
{
// 	assertEx( isdefined( level.ambient_zones[ type ] ), "Ambience " + type + " is not a defined ambience zone" );
}

ambient_trigger()
{
	// get the ambience zones on this trigger
	tokens = strtok( self.ambient, " " );
	if ( tokens.size == 1 )
	{
		// if this trigger only has one ambience then there is no lerping done
		ambience = tokens[ 0 ];
		for ( ;; )
		{
			self waittill( "trigger", other );
			assertEx( other == level.player, "Non - player entity touched an ambient trigger." );
			set_ambience_single( ambience );
		}
	}

	assertEx( isdefined( self.target ), "Ambience trigger at " + self.origin + " has multiple ambient tracks but doesn't target a script origin." );
	ent = getent( self.target, "targetname" );

	start = ent.origin;
	end = undefined;
	
	if ( isdefined( ent.target ) )
	{
		// if the origin targets a second origin, use it as the end point
		target_ent = getent( ent.target, "targetname" );
		end = target_ent.origin;
	}
	else
	{
		// otherwise double the difference between the target origin and start to get the endpoint
		end = start + vectorScale( self.origin - start, 2 );
	}

	dist = distance( start, end );
	
	assertEx( tokens.size == 2, "Ambience trigger at " + self.origin + " doesn't have 2 ambient zones set. Usage is \"ambient\" \"zone1 zone2\"" );

	inner_ambience = tokens[ 0 ];
	outer_ambience = tokens[ 1 ];
	
	 /#
	check_ambience( inner_ambience );
	check_ambience( outer_ambience );
	#/ 
	
	cap = 0.5;
	if ( isdefined( self.targetname ) && self.targetname == "ambient_exit" )
		cap = 0;


	for ( ;; )
	{
		self waittill( "trigger", other );
		assertEx( other == level.player, "Non - player entity touched an ambient trigger." );

		progress = undefined;		
		while ( level.player istouching( self ) )
		{
			progress = get_progress( start, end, dist, level.player.origin );
	
			if ( progress < 0 )
				progress = 0;
			
			if ( progress > 1 )
				progress = 1;
	
			set_ambience_blend( progress, inner_ambience, outer_ambience );
			wait( 0.05 );
		}

		// when you leave the trigger set it to whichever point it was closest too
		// or to the inner_ambience( usually "exterior" ) if self.targetname == "ambient_exit"

		if ( progress > cap )
			progress = 1;
		else
			progress = 0;

		set_ambience_blend( progress, inner_ambience, outer_ambience );
	}
}

get_progress( start, end, dist, org )
{
	normal = vectorNormalize( end - start );
	vec = org - start;
	progress = vectorDot( vec, normal );
	progress = progress / dist;
	return progress;
}


ambient_end_trigger_think( start, end, dist, inner_ambience, outer_ambience )
{
	self endon( "death" );
	for ( ;; )
	{
		self waittill( "trigger", other );
		assertEx( other == level.player, "Non - player entity touched an ambient trigger." );
		ambient_trigger_sets_ambience_levels( start, end, dist, inner_ambience, outer_ambience );
	}
}

ambient_trigger_sets_ambience_levels( start, end, dist, inner_ambience, outer_ambience )
{
	level notify( "trigger_ambience_touched" );
	level endon( "trigger_ambience_touched" );
	
	for ( ;; )
	{
		progress = get_progress( start, end, dist, level.player.origin );

		if ( progress < 0 )
		{
			progress = 0;
			
			set_ambience_single( inner_ambience );
			break;
		}
		
		if ( progress >= 1 )
		{
			set_ambience_single( outer_ambience );
			break;
		}

		set_ambience_blend( progress, inner_ambience, outer_ambience );
		wait( 0.05 );
	}
}

set_ambience_blend( progress, inner_ambience, outer_ambience )
{
	if ( level.eq_track[ level.eq_main_track ] != outer_ambience )
	{
		maps\_ambient::setup_eq_channels( outer_ambience, level.eq_main_track );
	}

	if ( level.eq_track[ level.eq_mix_track ] != inner_ambience )
	{
		maps\_ambient::setup_eq_channels( inner_ambience, level.eq_mix_track );
	}
	
	level.player seteqlerp( progress, level.eq_main_track );
	/#
	ambience_hud( progress, level.eq_track[ level.eq_main_track ], level.eq_track[ level.eq_mix_track ] );
	#/ 

	if ( progress == 1 || progress == 0 )
		level.nextmsg = 0;
		
	if ( !isdefined( level.nextmsg ) )
		level.nextmsg = 0;
		
	if ( gettime() < level.nextmsg )
		return;
	
	level.nextmsg = gettime() + 200;
}

set_ambience_single( ambience )
{
	if ( isdefined( level.ambientEventEnt[ ambience ] ) )
	{
// 		thread ambientEventStart( ambience );
		thread start_ambient_event( ambience );
	}
	
	if ( level.eq_track[ level.eq_main_track ] != ambience )
	{
		maps\_ambient::setup_eq_channels( ambience, level.eq_main_track );
	}

	level.player seteqlerp( 1, level.eq_main_track );
	 /#
	ambience_hud( 1, level.eq_track[ level.eq_main_track ] );
	#/ 
}

ambience_hud( progress, inner_ambience, outer_ambience )
{
	if ( getdvar( "loc_warnings" ) == "1" )
		return;
	if ( getdvar( "debug_hud" ) != "" )
		return;
		
	if ( !isdefined( level.amb_hud ) )
	{
		x = -40;
		y = 460;
		level.amb_hud = [];

		hud = newHudElem();
		hud.alignX = "left";
		hud.alignY = "bottom";
		hud.x = x + 22;
		hud.y = y + 10;
		hud.color = ( 0.4, 0.9, 0.6 );
		level.amb_hud[ "inner" ] = hud;

		hud = newHudElem();
		hud.alignX = "left";
		hud.alignY = "bottom";
		hud.x = x;
		hud.y = y + 10;
		hud.color = ( 0.4, 0.9, 0.6 );
		level.amb_hud[ "frac_inner" ] = hud;

		hud = newHudElem();
		hud.alignX = "left";
		hud.alignY = "bottom";
		hud.x = x + 22;
		hud.y = y;
		hud.color = ( 0.4, 0.9, 0.6 );
		level.amb_hud[ "outer" ] = hud;

		hud = newHudElem();
		hud.alignX = "left";
		hud.alignY = "bottom";
		hud.x = x;
		hud.y = y;
		hud.color = ( 0.4, 0.9, 0.6 );
		level.amb_hud[ "frac_outer" ] = hud;
	}
	
	if ( isdefined( outer_ambience ) )
	{
		level.amb_hud[ "frac_outer" ].label = int( 100 * ( 1 - progress ) );
		level.amb_hud[ "frac_outer" ].alpha = 1;
		level.amb_hud[ "outer" ].label = outer_ambience;
		level.amb_hud[ "outer" ].alpha = 1;
	}
	else
	{
		level.amb_hud[ "outer" ].alpha = 0;
		level.amb_hud[ "frac_outer" ].alpha = 0;
	}

	level.amb_hud[ "outer" ] fadeovertime( 0.5 );
	level.amb_hud[ "frac_outer" ] fadeovertime( 0.5 );

	level.amb_hud[ "frac_inner" ].label = int( 100 * progress );
	level.amb_hud[ "frac_inner" ].alpha = 1;
	level.amb_hud[ "frac_inner" ] fadeovertime( 0.5 );

	level.amb_hud[ "inner" ] settext( inner_ambience );
	level.amb_hud[ "inner" ].alpha = 1;
	level.amb_hud[ "inner" ] fadeovertime( 0.5 );
}
set_ambience_blend_over_time( time, inner_ambience, outer_ambience )
{
	if ( time == 0 )
	{
		set_ambience_blend( 1, inner_ambience, outer_ambience );
		return;
	}
	
	progress = 0;
	update_freq = 0.05;
	update_amount = 1 / ( time / update_freq );
	
	// is progress 0 on the first iteration? it shouldn't be
	for ( ;; )
	// for ( progress = 0; progress < 1; progress += update_amount )
	{
		progress = progress + update_amount;
		
		if ( progress >= 1 )
		{
			set_ambience_single( outer_ambience );
			break;
		}

		set_ambience_blend( progress, inner_ambience, outer_ambience );
		wait update_freq;
	}
}