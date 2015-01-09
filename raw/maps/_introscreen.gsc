#include common_scripts\utility;
#include maps\_utility;

main()
{
	flag_init( "pullup_weapon" );
	flag_init( "introscreen_complete" );
	flag_init( "safe_for_objectives" );	
	flag_init( "introscreen_complete" );
	delaythread( 10, ::flag_set, "safe_for_objectives" );
	level.linefeed_delay = 16;

	precacheshader("black");
	precacheshader("white");

	if (getDvar("introscreen") == "")
		setDvar("introscreen", "1");
	
	//String1 = Title of the level
	//String2 = Place, Country or just Country
	//String3 = Month Day, Year
	//String4 = Optional additional detailed information
	//Pausetime1 = length of pause in seconds after title of level
	//Pausetime2 = length of pause in seconds after Month Day, Year
	//Pausetime3 = length of pause in seconds before the level fades in 
	
	if ( isdefined( level.credits_active ) )
		return;

	switch ( level.script )
	{
	case "ac130":
		precacheString( &"AC130_INTROSCREEN_LINE_1" );
		precacheString( &"AC130_INTROSCREEN_LINE_2" );
		precacheString( &"AC130_INTROSCREEN_LINE_3" );
		precacheString( &"AC130_INTROSCREEN_LINE_4" );
		precacheString( &"AC130_INTROSCREEN_LINE_5" );
		introscreen_delay(&"AC130_INTROSCREEN_LINE_1", &"AC130_INTROSCREEN_LINE_2", &"AC130_INTROSCREEN_LINE_3", &"AC130_INTROSCREEN_LINE_4", 0.2, 0.2, 0.2);
		break;
	case "aftermath":
		precacheString(&"INTROSCREEN_TITLE");
		precacheString(&"INTROSCREEN_PLACE");
		precacheString(&"INTROSCREEN_DATE");
		precacheString(&"INTROSCREEN_INFO");
		introscreen_delay(&"INTROSCREEN_TITLE", &"INTROSCREEN_PLACE", &"INTROSCREEN_DATE", &"INTROSCREEN_INFO", 0.2, 0.2, 0.2);
		break;
	case "ambush":
		precacheString(&"INTROSCREEN_TITLE");
		precacheString(&"INTROSCREEN_PLACE");
		precacheString(&"INTROSCREEN_DATE");
		precacheString(&"INTROSCREEN_INFO");
		introscreen_delay(&"INTROSCREEN_TITLE", &"INTROSCREEN_PLACE", &"INTROSCREEN_DATE", &"INTROSCREEN_INFO", 0.2, 0.2, 0.2);
		break;
	case "blackout":
		precacheString(&"BLACKOUT_INTRO_1");
		precacheString(&"BLACKOUT_INTRO_2");
		precacheString(&"BLACKOUT_INTRO_3");
		precacheString(&"BLACKOUT_INTRO_4");
		precacheString(&"BLACKOUT_INTRO_5");
		precacheString(&"INTROSCREEN_INFO");
		introscreen_delay(&"INTROSCREEN_TITLE", &"INTROSCREEN_PLACE", &"INTROSCREEN_DATE", &"INTROSCREEN_INFO", 0.2, 0.2, 0.2);
		break;
	case "bog_a":
		precacheString(&"INTROSCREEN_TITLE");
		precacheString(&"INTROSCREEN_PLACE");
		precacheString(&"INTROSCREEN_DATE");
		precacheString(&"INTROSCREEN_INFO");
		introscreen_delay(&"INTROSCREEN_TITLE", &"INTROSCREEN_PLACE", &"INTROSCREEN_DATE", &"INTROSCREEN_INFO", 0.2, 0.2, 0.2);
		break;
	case "bog_b":
		precacheString( &"BOG_B_INTROSCREEN_LINE_1" );
		precacheString( &"BOG_B_INTROSCREEN_LINE_2" );
		precacheString( &"BOG_B_INTROSCREEN_LINE_3" );
		precacheString( &"BOG_B_INTROSCREEN_LINE_4" );
		introscreen_delay(&"BOG_B_INTROSCREEN_LINE_1", &"BOG_B_INTROSCREEN_LINE_2", &"BOG_B_INTROSCREEN_LINE_3", &"BOG_B_INTROSCREEN_LINE_4", 0.2, 0.2, 0.2);
		break;
	case "hunted":
		precacheString( &"HUNTED_INTROSCREEN_LINE_1" );
		precacheString( &"HUNTED_INTROSCREEN_LINE_2" );
		precacheString( &"HUNTED_INTROSCREEN_LINE_3" );
		precacheString( &"HUNTED_INTROSCREEN_LINE_4" );
		precacheString( &"HUNTED_INTROSCREEN_LINE_5" );
		introscreen_delay(&"HUNTED_INTROSCREEN_LINE_1", &"HUNTED_INTROSCREEN_LINE_2", &"HUNTED_INTROSCREEN_LINE_3", &"HUNTED_INTROSCREEN_LINE_4", 0.2, 0.2, 0.2);
		break;
	case "village_assault":
		precacheString( &"VILLAGE_ASSAULT_INTROSCREEN_LINE_1" );
		precacheString( &"VILLAGE_ASSAULT_INTROSCREEN_LINE_2" );
		precacheString( &"VILLAGE_ASSAULT_INTROSCREEN_LINE_3" );
		precacheString( &"VILLAGE_ASSAULT_INTROSCREEN_LINE_4" );
		precacheString( &"VILLAGE_ASSAULT_INTROSCREEN_LINE_5" );
		introscreen_delay(&"VILLAGE_ASSAULT_INTROSCREEN_LINE_1", &"VILLAGE_ASSAULT_INTROSCREEN_LINE_2", &"VILLAGE_ASSAULT_INTROSCREEN_LINE_3", &"VILLAGE_ASSAULT_INTROSCREEN_LINE_4", 0.2, 0.2, 0.2);
		break;
	case "village_defend":
		precacheString( &"VILLAGE_DEFEND_INTRO_1" );
		precacheString( &"VILLAGE_DEFEND_INTRO_2" );
		precacheString( &"VILLAGE_DEFEND_INTRO_3" );
		precacheString( &"VILLAGE_DEFEND_INTRO_4" );
		precacheString( &"VILLAGE_DEFEND_INTRO_5" );
		precacheString( &"VILLAGE_DEFEND_PRESENT_DAY" );
		introscreen_delay(&"VILLAGE_DEFEND_INTRO_1", &"VILLAGE_DEFEND_INTRO_1", &"VILLAGE_DEFEND_INTRO_1", &"VILLAGE_DEFEND_INTRO_1", 0.2, 0.2, 0.2);
		break;
	case "cargoship":
		precacheString(&"CARGOSHIP_LINE1");
		precacheString(&"CARGOSHIP_LINE2");
		precacheString(&"CARGOSHIP_LINE3");
		precacheString(&"CARGOSHIP_LINE4");
		precacheString(&"CARGOSHIP_LINE5");
		introscreen_delay(&"CARGOSHIP_LINE1", &"CARGOSHIP_LINE2", &"CARGOSHIP_LINE3", &"CARGOSHIP_LINE4", 2, 3, 3);
		break;
	case "launchfacility_a":
		precacheString(&"LAUNCHFACILITY_A_INTROSCREEN_LINE_1");
		precacheString(&"LAUNCHFACILITY_A_INTROSCREEN_LINE_2");
		precacheString(&"LAUNCHFACILITY_A_INTROSCREEN_LINE_3");
		precacheString(&"LAUNCHFACILITY_A_INTROSCREEN_LINE_4");
		precacheString(&"LAUNCHFACILITY_A_INTROSCREEN_LINE_5");
		introscreen_delay(&"LAUNCHFACILITY_A_INTROSCREEN_LINE_5", &"LAUNCHFACILITY_A_INTROSCREEN_LINE_5", &"LAUNCHFACILITY_A_INTROSCREEN_LINE_5", &"LAUNCHFACILITY_A_INTROSCREEN_LINE_5", 2, 3, 3);
		break;
	case "launchfacility_b":
		precacheString(&"LAUNCHFACILITY_B_INTROSCREEN_LINE_1");
		precacheString(&"LAUNCHFACILITY_B_INTROSCREEN_LINE_2");
		precacheString(&"LAUNCHFACILITY_B_INTROSCREEN_LINE_3");
		precacheString(&"LAUNCHFACILITY_B_INTROSCREEN_LINE_4");
		precacheString(&"LAUNCHFACILITY_B_INTROSCREEN_LINE_5");
		introscreen_delay(&"INTROSCREEN_TITLE", &"INTROSCREEN_PLACE", &"INTROSCREEN_DATE", &"INTROSCREEN_INFO", 2, 3, 3);
		break;
	case "airlift":
		precacheString(&"AIRLIFT_INTROSCREEN_LINE_1");
		precacheString(&"AIRLIFT_INTROSCREEN_LINE_2");
		precacheString(&"AIRLIFT_INTROSCREEN_LINE_3");
		precacheString(&"AIRLIFT_INTROSCREEN_LINE_4");
		introscreen_delay(&"AIRLIFT_INTROSCREEN_LINE_1", &"AIRLIFT_INTROSCREEN_LINE_2", &"AIRLIFT_INTROSCREEN_LINE_2", &"AIRLIFT_INTROSCREEN_LINE_4", 2, 3, 3);
		break;
	case "jeepride":
		precacheString(&"JEEPRIDE_INTROSCREEN_LINE1");
		precacheString(&"JEEPRIDE_INTROSCREEN_LINE2");
		precacheString(&"JEEPRIDE_INTROSCREEN_LINE3");
		precacheString(&"JEEPRIDE_INTROSCREEN_LINE4");
		precacheString(&"JEEPRIDE_INTROSCREEN_LINE5");
		introscreen_delay(&"JEEPRIDE_INTROSCREEN_LINE1", &"JEEPRIDE_INTROSCREEN_LINE2", &"JEEPRIDE_INTROSCREEN_LINE3", &"JEEPRIDE_INTROSCREEN_LINE4", 0.2, 0.2, 0.2);
		break;
	case "icbm":
    	precachestring( &"ICBM_INTROSCREEN_LINE_1" );
		precachestring( &"ICBM_INTROSCREEN_LINE_2" );
		precachestring( &"ICBM_INTROSCREEN_LINE_3" );
		precachestring( &"ICBM_INTROSCREEN_LINE_4" );
		precachestring( &"ICBM_INTROSCREEN_LINE_5" );
		introscreen_delay(&"ICBM_INTROSCREEN_LINE_1", &"ICBM_INTROSCREEN_LINE_2", &"ICBM_INTROSCREEN_LINE_3", &"ICBM_INTROSCREEN_LINE_4", &"ICBM_INTROSCREEN_LINE_5");		
		break;
	case "scoutsniper":
		precacheString(&"SCOUTSNIPER_INTRO_1");
		precacheString(&"SCOUTSNIPER_INTRO_2");
		precacheString(&"SCOUTSNIPER_INTRO_3");
		precacheString(&"SCOUTSNIPER_INTRO_4");
		precacheString(&"SCOUTSNIPER_15_YEARS_AGO");
		introscreen_delay(&"SCOUTSNIPER_INTRO_1", &"SCOUTSNIPER_INTRO_1", &"SCOUTSNIPER_INTRO_1", &"SCOUTSNIPER_INTRO_1", 3, 3);
		break;
	case "killhouse":
		precachestring( &"KILLHOUSE_INTROSCREEN_LINE_1" );
		precachestring( &"KILLHOUSE_INTROSCREEN_LINE_2" );//not used
		precachestring( &"KILLHOUSE_INTROSCREEN_LINE_3" );
		precachestring( &"KILLHOUSE_INTROSCREEN_LINE_4" );
		precachestring( &"KILLHOUSE_INTROSCREEN_LINE_5" );
		introscreen_delay(&"KILLHOUSE_INTROSCREEN_LINE_1", &"KILLHOUSE_INTROSCREEN_LINE_3", &"KILLHOUSE_INTROSCREEN_LINE_4", &"KILLHOUSE_INTROSCREEN_LINE_5");
		break;
	case "example":
		/*
		precacheString(&"INTROSCREEN_EXAMPLE_TITLE");
		precacheString(&"INTROSCREEN_EXAMPLE_PLACE");
		precacheString(&"INTROSCREEN_EXAMPLE_DATE");
		precacheString(&"INTROSCREEN_EXAMPLE_INFO");
		introscreen_delay(&"INTROSCREEN_EXAMPLE_TITLE", &"INTROSCREEN_EXAMPLE_PLACE", &"INTROSCREEN_EXAMPLE_DATE", &"INTROSCREEN_EXAMPLE_INFO");
		*/
		break;
	case "bridge":
		thread flying_intro();
		break;
	default:
		// Shouldn't do a notify without a wait statement before it, or bad things can happen when loading a save game.
		wait 0.05; 
		level notify("finished final intro screen fadein");
		wait 0.05; 
		level notify("starting final intro screen fadeout");
		wait 0.05; 
		level notify("controls_active"); // Notify when player controls have been restored
		wait 0.05; 
		flag_set("introscreen_complete"); // Do final notify when player controls have been restored
		break;
	}
}

introscreen_feed_lines( lines )
{
	//get array keys returns the keys in reverse order
	keys = getarraykeys( lines );
	keys = maps\_utility::array_reverse( keys );
	
	for ( i=0; i < keys.size; i++ )
	{
		key = keys[ i ];
		interval = 1;
		time = ( i * interval ) + 1;
		delayThread( time, ::introscreen_corner_line, lines[ key ], ( lines.size - i - 1 ), interval, key );
	}	
}

introscreen_generic_black_fade_in( time, fade_time )
{
	introscreen_generic_fade_in( "black", time, fade_time );
}

introscreen_generic_white_fade_in( time, fade_time )
{
	introscreen_generic_fade_in( "white", time, fade_time );
}

introscreen_generic_fade_in( shader, time, fade_time )
{
	if ( !isdefined( fade_time ) )
		fade_time = 1.5;
		
	introblack = newHudElem();
	introblack.x = 0;
	introblack.y = 0;
	introblack.horzAlign = "fullscreen";
	introblack.vertAlign = "fullscreen";
	introblack.foreground = true;
	introblack setShader(shader, 640, 480);

	wait time;
	
	// Fade out black
	introblack fadeOverTime(1.5); 
	introblack.alpha = 0;
}

introscreen_create_line(string)
{
	index = level.introstring.size;
	yPos = (index * 30);
	
	if (level.console)
		yPos -= 60;
	
	level.introstring[index] = newHudElem();
	level.introstring[index].x = 0;
	level.introstring[index].y = yPos;
	level.introstring[index].alignX = "center";
	level.introstring[index].alignY = "middle";
	level.introstring[index].horzAlign= "center";
	level.introstring[index].vertAlign = "middle";
	level.introstring[index].sort = 1; // force to draw after the background
	level.introstring[index].foreground = true;
	level.introstring[index].fontScale = 1.75;
	level.introstring[index] setText(string);
	level.introstring[index].alpha = 0;
	level.introstring[index] fadeOverTime(1.2); 
	level.introstring[index].alpha = 1;
}

introscreen_fadeOutText()
{
	for(i = 0; i < level.introstring.size; i++)
	{
		level.introstring[i] fadeOverTime(1.5);
		level.introstring[i].alpha = 0;
	}

	wait 1.5;

	for(i = 0; i < level.introstring.size; i++)
		level.introstring[i] destroy();
	
}

introscreen_delay(string1, string2, string3, string4, pausetime1, pausetime2, timebeforefade)
{
	//Chaotically wait until the frame ends twice because handle_starts waits for one frame end so that script gets to init vars
	//and this needs to wait for handle_starts to finish so that the level.start_point gets set.
	waittillframeend; 
	waittillframeend; 

	/#	
	skipIntro = level.start_point != "default";
	if ( getdvar( "introscreen" ) == "0" )
		skipIntro = true;
		
	if ( skipIntro )
	{
		waittillframeend;
		level notify("finished final intro screen fadein");
		waittillframeend;
		level notify ("starting final intro screen fadeout");
		waittillframeend;
		level notify("controls_active"); // Notify when player controls have been restored
		waittillframeend;
		flag_set("introscreen_complete"); // Do final notify when player controls have been restored
		flag_set( "pullup_weapon" );
		return;
	}
	#/
	
	if ( flying_intro() )
	{
		return;
	}
	
	if ( level.script == "ac130" )
	{
		ac130_intro();
		return;
	}
	if ( level.script == "hunted" )
	{
		hunted_intro();
		return;
	}
	if ( level.script == "ambush" )
	{
		ambush_intro();
		return;
	}
	if ( level.script == "aftermath" )
	{
		aftermath_intro();
		return;
	}
	if ( level.script == "cargoship" )
	{
		cargoship_intro();
		return;
	}
	if ( level.script == "launchfacility_b" )
	{
		launchfacility_b_intro();
		return;
	}	
	if ( level.script == "airlift" )
	{
		airlift_intro();
		return;
	}
	if ( level.script == "village_defend" )
	{
		village_defend_intro();
		return;
	}
	if ( level.script == "scoutsniper" )
	{
		scoutsniper_intro();
		return;
	}
	if ( level.script == "jeepride" )
	{
		jeepride_intro();
		return;
	}
	
	level.introblack = newHudElem();
	level.introblack.x = 0;
	level.introblack.y = 0;
	level.introblack.horzAlign = "fullscreen";
	level.introblack.vertAlign = "fullscreen";
	level.introblack.foreground = true;
	level.introblack setShader("black", 640, 480);

	level.player freezeControls(true);
	wait .05;

	level.introstring = [];
	
	//Title of level
	
	if(isdefined(string1))
		introscreen_create_line(string1);
	
	if(isdefined(pausetime1))
	{
		wait pausetime1;
	}
	else
	{
		wait 2;	
	}
	
	//City, Country, Date
	
	if(isdefined(string2))
		introscreen_create_line(string2);
	if(isdefined(string3))
		introscreen_create_line(string3);
	
	//Optional Detailed Statement
	
	if(isdefined(string4))
	{
		if(isdefined(pausetime2))
		{
			wait pausetime2;
		}
		else
		{
			wait 2;
		}
	}
	
	if(isdefined(string4))
		introscreen_create_line(string4);
	
	//if(isdefined(string5))
		//introscreen_create_line(string5);
	
	level notify("finished final intro screen fadein");
	
	if(isdefined(timebeforefade))
	{
		wait timebeforefade;
	}
	else
	{
		wait 3;
	}

	// Fade out black
	level.introblack fadeOverTime(1.5); 
	level.introblack.alpha = 0;

	level notify ("starting final intro screen fadeout");

	// Restore player controls part way through the fade in
	level.player freezeControls(false);
	level notify("controls_active"); // Notify when player controls have been restored

	// Fade out text
	introscreen_fadeOutText();

	flag_set("introscreen_complete"); // Notify when complete
}

_CornerLineThread( string, size, interval, index_key )
{
	level notify("new_introscreen_element");
	
	if( !isdefined( level.intro_offset ) )
		level.intro_offset = 0;
	else
		level.intro_offset++;
		
	y = _CornerLineThread_height();
	
	hudelem = newHudElem();
	hudelem.x = 20;
	hudelem.y = y;
	hudelem.alignX = "left";
	hudelem.alignY = "bottom";
	hudelem.horzAlign= "left";
	hudelem.vertAlign = "bottom";
	hudelem.sort = 1; // force to draw after the background
	hudelem.foreground = true;
	hudelem setText( string );
	hudelem.alpha = 0;
	hudelem fadeOverTime( 0.2 ); 
	hudelem.alpha = 1;

	hudelem.hidewheninmenu = true;
	hudelem.fontScale = 2.0; //was 1.6 and 2.4, larger font change
	hudelem.color = (0.8, 1.0, 0.8);
	hudelem.font = "objective";
	hudelem.glowColor = (0.3, 0.6, 0.3);
	hudelem.glowAlpha = 1;
	duration = int((size * interval * 1000) + 4000);
	hudelem SetPulseFX( 30, duration, 700 );//something, decay start, decay duration

	thread hudelem_destroy( hudelem );
	
	if( !isdefined( index_key ) ) 
		return;
	if( !isstring( index_key ) )
		return;
	if( index_key != "date" )
		return;
}


_CornerLineThread_height()
{
	//return ( ( ( pos ) * 19 ) - 10 );
	return ( ( ( level.intro_offset ) * 20 ) - 82 ); //was 19 and 22 larger font change
}

introscreen_corner_line( string, size, interval, index_key )
{
	thread _CornerLineThread( string, size, interval, index_key );
}


hudelem_destroy( hudelem )
{
	wait( level.linefeed_delay );
	hudelem notify( "destroying" );
	level.intro_offset = undefined;

	time = .5;
	hudelem fadeOverTime( time ); 
	hudelem.alpha = 0;
	wait time;
	hudelem notify( "destroy" );
	hudelem destroy();
}


cargoship_intro_dvars()
{
	wait( 0.05 );
	setsaveddvar( "compass", 0 );
	SetSavedDvar( "ammoCounterHide", "1" );	
	SetSavedDvar( "hud_showStance", 0 );
	setSavedDvar( "hud_drawhud", "0" );
}

cargoship_intro()
{
	thread cargoship_intro_dvars();
	level.player freezeControls(true);
	
	cinematicingamesync("cargoship_fade");
	
	wait .4;
	level notify( "intro_movie_done" );
	saveGame( "levelstart", &"AUTOSAVE_LEVELSTART", "whatever", true );
	
	introscreen_generic_white_fade_in( 1.75 );

	lines = [];
	lines[ lines.size ] = &"CARGOSHIP_LINE1";
	lines[ "date" ] 	= &"CARGOSHIP_LINE2";
	lines[ lines.size ] = &"CARGOSHIP_LINE3";
	lines[ lines.size ] = &"CARGOSHIP_LINE4";
	lines[ lines.size ] = &"CARGOSHIP_LINE5";
	
	introscreen_feed_lines( lines );
	
	wait( 1 );

	 // Do final notify when player controls have been restored
	level.player freezeControls( false );
	
	level notify("introscreen_complete");
	level.player freezeControls( false );
}

jeepride_intro()
{
	level.player freezeControls(true);
	
	cinematicingamesync("jeepride_fade");
	
	lines = [];
	lines[ lines.size ] = &"JEEPRIDE_INTROSCREEN_LINE1";
	lines[ "date" ] 	= &"JEEPRIDE_INTROSCREEN_LINE2";
	lines[ lines.size ] = &"JEEPRIDE_INTROSCREEN_LINE3";
	lines[ lines.size ] = &"JEEPRIDE_INTROSCREEN_LINE4";
	lines[ lines.size ] = &"JEEPRIDE_INTROSCREEN_LINE5";

	introscreen_feed_lines( lines );
//	introscreen_generic_black_fade_in( 2 );
	
	level notify("introscreen_complete");
	level.player freezeControls( false );
}

airlift_intro_dvars()
{
	wait( 0.05 );
	setsaveddvar( "compass", 0 );
	SetSavedDvar( "ammoCounterHide", "1" );	
}

airlift_intro()
{
	thread airlift_intro_dvars();
	
	level.player freezeControls(true);
	cinematicingamesync("airlift_fade");
	
	lines = [];
	lines[ lines.size ] = &"AIRLIFT_INTROSCREEN_LINE_1";	//"Shock and Awe"
	lines[ "date" ] 	= &"AIRLIFT_INTROSCREEN_LINE_2";	//"Day 03 – 18:00:[{FAKE_INTRO_SECONDS:02}]"
	lines[ lines.size ] = &"AIRLIFT_INTROSCREEN_LINE_3";	//"Sgt. Paul Jackson"
	lines[ lines.size ] = &"AIRLIFT_INTROSCREEN_LINE_4";	//"1st Bn, 7th Marine Regiment"

	introscreen_feed_lines( lines );
	
	wait 2;
	saveGame( "levelstart", &"AUTOSAVE_LEVELSTART", "whatever", true );
	
	level notify( "introscreen_black" );
	
	introblack = newHudElem();
	introblack.x = 0;
	introblack.y = 0;
	introblack.horzAlign = "fullscreen";
	introblack.vertAlign = "fullscreen";
	introblack.sort = 1000;
	introblack setShader("white", 640, 480);
	
	wait 1;
	
	// Fade out black
	introblack fadeOverTime(1.5); 
	introblack.alpha = 0;

	wait( 1 );
	level notify( "introscreen_complete" );
	thread autosave_now( undefined, true );
	level.player freezeControls( false );
}

village_defend_intro_dvars()
{
	wait( 0.05 );
	setsaveddvar( "compass", 0 );
	SetSavedDvar( "ammoCounterHide", "1" );	
}

village_defend_intro()
{
	thread village_defend_intro_dvars();
	
	level.player freezeControls(true);
	
	//cinematicingamesync( "village_defend_fade" );
	
	introblack = newHudElem();
	introblack.x = 0;
	introblack.y = 0;
	introblack.horzAlign = "fullscreen";
	introblack.vertAlign = "fullscreen";
	introblack.foreground = true;
	introblack setShader("black", 640, 480);

	wait .25;

	introtime = newHudElem();
	introtime.x = 0;
	introtime.y = 0;
	introtime.alignX = "center";
	introtime.alignY = "middle";
	introtime.horzAlign = "center";
	introtime.vertAlign = "middle";
	introtime.sort = 1;
	introtime.foreground = true;
	introtime setText( &"VILLAGE_DEFEND_PRESENT_DAY" );
	introtime.fontScale = 1.6;
	introtime.color = (0.8, 1.0, 0.8);
	introtime.font = "objective";
	introtime.glowColor = (0.3, 0.6, 0.3);
	introtime.glowAlpha = 1;
	introtime SetPulseFX( 30, 8000, 700 );//something, decay start, decay duration

	wait 8.8;
	
	lines = [];
	lines[ lines.size ] = &"VILLAGE_DEFEND_INTRO_1";
	lines[ "date" ] 	= &"VILLAGE_DEFEND_INTRO_2";
	lines[ lines.size ] = &"VILLAGE_DEFEND_INTRO_3";
	lines[ lines.size ] = &"VILLAGE_DEFEND_INTRO_4";
	lines[ lines.size ] = &"VILLAGE_DEFEND_INTRO_5";

	introscreen_feed_lines( lines );
	//introscreen_generic_black_fade_in( 3 );
	
	wait 10;
	
	// Fade out black
	introblack fadeOverTime(1.5); 
	introblack.alpha = 0;
	
	setsaveddvar( "compass", 1 );
	SetSavedDvar( "ammoCounterHide", "0" );
	SetSavedDvar( "hud_showStance", 1 );

	wait( 1 );
	 // Do final notify when player controls have been restored
	level.player freezeControls( false );
	
	level notify("introscreen_complete");
	level.player freezeControls( false );
}

scoutsniper_intro()
{
	thread scoutsniperIntroDvars();
	thread scoutsniperIntroPlayer();
	
	cinematicingamesync("scoutsniper_fade");

	wait 4;

	set_vision_set( "grayscale" );

	saveGame( "levelstart", &"AUTOSAVE_LEVELSTART", "whatever", true );	
	introblack = newHudElem();
	introblack.x = 0;
	introblack.y = 0;
	introblack.horzAlign = "fullscreen";
	introblack.vertAlign = "fullscreen";
	introblack.foreground = true;
	introblack setShader("black", 640, 480);
	

	wait .25;

	introtime = newHudElem();
	introtime.x = 0;
	introtime.y = 0;
	introtime.alignX = "center";
	introtime.alignY = "middle";
	introtime.horzAlign = "center";
	introtime.vertAlign = "middle";
	introtime.sort = 1;
	introtime.foreground = true;
	introtime setText( &"SCOUTSNIPER_15_YEARS_AGO" );
	introtime.fontScale = 1.6;
	introtime.color = (0.8, 1.0, 0.8);
	introtime.font = "objective";
	introtime.glowColor = (0.3, 0.6, 0.3);
	introtime.glowAlpha = 1;
	introtime SetPulseFX( 30, 2000, 700 );//something, decay start, decay duration

	wait 2;

	lines = [];
	lines[ lines.size ] = &"SCOUTSNIPER_INTRO_1";
	lines[ lines.size ] = &"SCOUTSNIPER_INTRO_2";
	lines[ lines.size ] = &"SCOUTSNIPER_INTRO_3";
	lines[ lines.size ] = &"SCOUTSNIPER_INTRO_4";

	introscreen_feed_lines( lines );
		
	wait 1;
	
	// Fade out black
	introblack fadeOverTime(1.5); 
	introblack.alpha = 0;

	wait 5.5;
	
	set_vision_set( "scoutsniper", 2 );

	wait( 7.0 );
	 // Do final notify when player controls have been restored	
	level notify("introscreen_complete");
	level.player freezeControls( false );
	
	wait( .5 );
	
	setsaveddvar( "compass", 1 );
	SetSavedDvar( "ammoCounterHide", "0" );
	SetSavedDvar( "hud_showStance", 1 );
}

scoutsniperIntroPlayer()
{
	ang = level.player getplayerangles();
	wait 1;
	level.player setstance("crouch");
	level.player freezeControls(true);
	level.player setplayerangles(ang);
}

scoutsniperIntroDvars()
{
	wait( 0.05 );
	setsaveddvar( "compass", 0 );
	SetSavedDvar( "ammoCounterHide", "1" );	
	SetSavedDvar( "hud_showStance", 0 );
}

bog_intro_sound()
{
	wait( 0.05 );
	//level.player playsound( "ui_camera_whoosh_in" );
	setsaveddvar( "compass", 0 );
	SetSavedDvar( "ammoCounterHide", "1" );
	SetSavedDvar( "hud_showstance", "0" );	
	SetSavedDvar( "actionSlotsHide", "1" );
	
}

flying_intro()
{

	flying_levels = [];
	flying_levels[ "bog_a" ] = true;
	flying_levels[ "bog_b" ] = true;
	flying_levels[ "blackout" ] = true;
	flying_levels[ "killhouse" ] = true;
	flying_levels[ "icbm" ] = true;
	flying_levels[ "launchfacility_a" ] = true;
	flying_levels[ "village_assault" ] = true;
	//flying_levels[ "village_defend" ] = true;
	
	if ( !isdefined( level.dontReviveHud ) )
		thread revive_ammo_counter();
	
	if ( !isdefined( flying_levels[ level.script ] ) )
		return false;
	
	
	thread bog_intro_sound();
	thread weapon_pullout();
	
	level.player freezeControls( true );
	
	zoomHeight = 16000;
	slamzoom = true;
	/#
	if ( getdvar( "slamzoom" ) != "" )
		slamzoom = false;
	#/
	
	extra_delay = 0;
	special_save = false;
	
	if ( slamzoom )
	{
		lines = [];
		if ( level.script == "bog_a" )
		{
			cinematicingamesync("bog_a_fade");
			lines[ lines.size ] = &"BOG_A_INTRO_1";
			lines[ "date" ] 	= &"BOG_A_INTRO_2";
			lines[ lines.size ] = &"BOG_A_SGT_PAUL_JACKSON";
			lines[ lines.size ] = &"BOG_A_1ST_FORCE_RECON_CO_USMC";
		}
		else if ( level.script == "bog_b" )
		{
			extra_delay = 2.0;
//			thread introscreen_generic_black_fade_in( 0.7, 0.20 );
			cinematicingamesync("bog_b_fade");
			lines[ lines.size ] = &"BOG_B_INTROSCREEN_LINE_1";	//"War Pig"
			lines[ "date" ] 	= &"BOG_B_INTROSCREEN_LINE_2";	//"Day 3 – 1630 hrs"
			lines[ lines.size ] = &"BOG_B_INTROSCREEN_LINE_3";	//"Sgt. Paul Jackson"
			lines[ lines.size ] = &"BOG_B_INTROSCREEN_LINE_4";	//"1st Bn, 7th Marine Regiment"
			zoomHeight = 6500;
		}
		else if ( level.script == "blackout" )
		{
//			thread introscreen_generic_black_fade_in( 0.7, 0.20 );
			cinematicingamesync( "blackout_fade" );
			lines[ lines.size ] = &"BLACKOUT_INTRO_1";
			lines[ "date" ] 	= &"BLACKOUT_INTRO_2";
			lines[ lines.size ] = &"BLACKOUT_INTRO_3";
			lines[ lines.size ] = &"BLACKOUT_INTRO_4";
			lines[ lines.size ] = &"BLACKOUT_INTRO_5";
	//		lines[ lines.size ] = "Sgt. John 'Soap' MacTavish";
	//		lines[ lines.size ] = "22nd SAS Regiment";
			zoomHeight = 4000;
		}
		else if ( level.script == "killhouse" )
		{
			special_save = true;
			//thread introscreen_generic_black_fade_in( 0.7, 0.20 );
			cinematicingamesync("killhouse_fade");
			lines = [];
			lines[ lines.size ] = &"KILLHOUSE_INTROSCREEN_LINE_1";	
		//	lines[ "date" ] 	= &"KILLHOUSE_INTROSCREEN_LINE_2";
		//	lines[ "date" ] = "Day 1 - 6:30:[{FAKE_INTRO_SECONDS:09}]";
			lines[ lines.size ] = &"KILLHOUSE_INTROSCREEN_LINE_3";	
			lines[ lines.size ] = &"KILLHOUSE_INTROSCREEN_LINE_4";	
			lines[ lines.size ] = &"KILLHOUSE_INTROSCREEN_LINE_5";	
		}
		else if ( level.script == "icbm" )
		{
			extra_delay = .6;
			//thread introscreen_generic_black_fade_in( 0.7, 0.20 );
			cinematicingamesync("icbm_fade");
			lines = [];
			lines[ lines.size ] = &"ICBM_INTROSCREEN_LINE_1";	
			lines[ "date" ] 	= &"ICBM_INTROSCREEN_LINE_2";
			//lines[ "date" ] = "Day 6 - 6:19:[{FAKE_INTRO_SECONDS:32}]";
			lines[ lines.size ] = &"ICBM_INTROSCREEN_LINE_3";	
			lines[ lines.size ] = &"ICBM_INTROSCREEN_LINE_4";	
			lines[ lines.size ] = &"ICBM_INTROSCREEN_LINE_5";	
		}
		else if ( level.script == "launchfacility_a" )
		{
			//thread introscreen_generic_black_fade_in( 0.7, 0.20 );
			cinematicingamesync("launchfacility_a_fade");
			lines = [];
			lines[ lines.size ] = &"LAUNCHFACILITY_A_INTROSCREEN_LINE_1";	
			lines[ "date" ] 	= &"LAUNCHFACILITY_A_INTROSCREEN_LINE_2";
			//lines[ "date" ] = "Day 6 - 6:19:[{FAKE_INTRO_SECONDS:32}]";
			lines[ lines.size ] = &"LAUNCHFACILITY_A_INTROSCREEN_LINE_3";	
			lines[ lines.size ] = &"LAUNCHFACILITY_A_INTROSCREEN_LINE_4";	
			lines[ lines.size ] = &"LAUNCHFACILITY_A_INTROSCREEN_LINE_5";	
		}
		else if ( level.script == "village_assault" )
		{
			//thread introscreen_generic_black_fade_in( 0.05 );
			cinematicingamesync( "village_assault_fade" );
			lines = [];
			lines[ lines.size ] = &"VILLAGE_ASSAULT_INTROSCREEN_LINE_1";
			lines[ "date" ] 	= &"VILLAGE_ASSAULT_INTROSCREEN_LINE_2";
			lines[ lines.size ] = &"VILLAGE_ASSAULT_INTROSCREEN_LINE_3";
			lines[ lines.size ] = &"VILLAGE_ASSAULT_INTROSCREEN_LINE_4";
			lines[ lines.size ] = &"VILLAGE_ASSAULT_INTROSCREEN_LINE_5";
		}
		/*
		else if ( level.script == "village_defend" )
		{
			//thread introscreen_generic_black_fade_in( 0.05 );
			cinematicingamesync( "village_defend_fade" );
			lines = [];
			lines[ lines.size ] = &"VILLAGE_DEFEND_INTRO_1";
			lines[ "date" ] 	= &"VILLAGE_DEFEND_INTRO_2";
			lines[ lines.size ] = &"VILLAGE_DEFEND_INTRO_3";
			lines[ lines.size ] = &"VILLAGE_DEFEND_INTRO_4";
			lines[ lines.size ] = &"VILLAGE_DEFEND_INTRO_5";
		}
		*/
		introscreen_feed_lines( lines );
	}
	
	origin = level.player.origin;
	level.player.origin = origin + ( 0, 0, zoomHeight );
	ent = spawn( "script_model", (69,69,69) );
	ent.origin = level.player.origin;
	
	ent setmodel( "tag_origin" );
	ent.angles = level.player.angles;
	level.player linkto( ent );
	ent.angles = ( ent.angles[ 0 ] + 89, ent.angles[ 1 ], 0 );

	wait( extra_delay );	
	ent moveto ( origin + (0,0,0), 2, 0, 2 );
	


	
	wait ( 1.00 );
	wait( 0.5 );
	ent rotateto( ( ent.angles[ 0 ] - 89, ent.angles[ 1 ], 0 ), 0.5, 0.3, 0.2 );
	if ( !special_save )
		saveGame( "levelstart", &"AUTOSAVE_LEVELSTART", "whatever", true );
	wait ( 0.5 );
	flag_set( "pullup_weapon" );

	wait( 0.2 );
	level.player unlink();
	level.player freezeControls( false );
	
	thread play_sound_in_space( "ui_screen_trans_in", level.player.origin );
	
	wait( 0.2 );
	
	thread play_sound_in_space( "ui_screen_trans_out", level.player.origin );
	
	wait( 0.2 );
	
	// Do final notify when player controls have been restored
	flag_set( "introscreen_complete" );
		
	wait( 2 );
	
	ent delete();
	
	return true;
}

ac130_intro()
{
	level.player freezeControls(true);
	
	lines = [];
	lines[ lines.size ] = &"AC130_INTROSCREEN_LINE_1";	// 'Death from Above'
	lines[ "date" ] 	= &"AC130_INTROSCREEN_LINE_2";	// Day 2 - 0420 hrs
	lines[ lines.size ] = &"AC130_INTROSCREEN_LINE_3";	// Western Russia
	lines[ lines.size ] = &"AC130_INTROSCREEN_LINE_4";	// Thermal Imaging TV Operator
	lines[ lines.size ] = &"AC130_INTROSCREEN_LINE_5";	// AC-130H Spectre Gunship
	
	introscreen_feed_lines( lines );
	
	level notify( "introscreen_black" );
	
	saveGame( "levelstart", &"AUTOSAVE_LEVELSTART", "whatever", true );	
	
	introblack = newHudElem();
	introblack.x = 0;
	introblack.y = 0;
	introblack.horzAlign = "fullscreen";
	introblack.vertAlign = "fullscreen";
	introblack.sort = 1000;
	introblack setShader("black", 640, 480);
	
	wait 4.0;
	
	level notify( "introscreen_almost_complete" );
	
	wait 1.5;
	
	// Fade out black
	introblack fadeOverTime(1.5); 
	introblack.alpha = 0;

	wait( 1 );
	level.player freezeControls( false );
	SetSavedDvar( "hud_showStance", 0 );
	level notify( "introscreen_complete" );
	
	level.player freezeControls( false );
	
	
}

aftermath_intro()
{
	cinematicingamesync("black");
	level notify( "introscreen_complete" );
}

hunted_intro_dvars()
{
	wait( 0.05 );

	setsaveddvar( "compass", 0 );
	SetSavedDvar( "ammoCounterHide", "1" );	
}

hunted_intro()
{
	thread hunted_intro_dvars();
	
	level.player freezeControls(true);
	
	lines = [];
	lines[ lines.size ] = &"HUNTED_INTROSCREEN_LINE_1";
	lines[ "date" ] 	= &"HUNTED_INTROSCREEN_LINE_2";
	lines[ lines.size ] = &"HUNTED_INTROSCREEN_LINE_3";
	lines[ lines.size ] = &"HUNTED_INTROSCREEN_LINE_4";
	lines[ lines.size ] = &"HUNTED_INTROSCREEN_LINE_5";

	introscreen_feed_lines( lines );
	cinematicingamesync( "hunted_fade" );
	wait 1;
	saveGame( "levelstart", &"AUTOSAVE_LEVELSTART", "whatever", true );
	introscreen_generic_white_fade_in( 2 );
	
	saveGame( "levelstart", &"AUTOSAVE_LEVELSTART", "whatever", true );	

	wait( 1 );
	 // Do final notify when player controls have been restored
	level.player freezeControls( false );
	
	level notify("introscreen_complete");
	level.player freezeControls( false );
}

launchfacility_b_intro_dvars()
{
	wait( 0.05 );

	setsaveddvar( "compass", 0 );
	SetSavedDvar( "ammoCounterHide", "1" );	
	SetSavedDvar( "actionSlotsHide", "1" );
	SetSavedDvar( "hud_showstance", "0" );	
	thread revive_ammo_counter();

}

launchfacility_b_intro()
{
	thread launchfacility_b_intro_dvars();
	
	level.player freezeControls(true);
	
	lines = [];
	lines[ lines.size ] = &"LAUNCHFACILITY_B_INTROSCREEN_LINE_1";
	lines[ "date" ] 	= &"LAUNCHFACILITY_B_INTROSCREEN_LINE_2";
	lines[ lines.size ] = &"LAUNCHFACILITY_B_INTROSCREEN_LINE_3";
	lines[ lines.size ] = &"LAUNCHFACILITY_B_INTROSCREEN_LINE_4";
	lines[ lines.size ] = &"LAUNCHFACILITY_B_INTROSCREEN_LINE_5";

	introscreen_feed_lines( lines );
	//introscreen_generic_black_fade_in( 3 );
	introscreen_generic_white_fade_in( 1 );

	wait( 1 );
	 // Do final notify when player controls have been restored
	level.player freezeControls( false );
	
	level notify("introscreen_complete");
	level.player freezeControls( false );
}

ambush_intro_dvars()
{
	wait( 0.05 );
	setsaveddvar( "compass", 0 );
	SetSavedDvar( "ammoCounterHide", "1" );	
}

ambush_intro()
{
	thread ambush_intro_dvars();
	
	level.player freezeControls(true);
	
	lines = [];
	lines[ lines.size ] = &"AMBUSH_INTROSCREEN_LINE_1";
	lines[ "date" ] 	= &"AMBUSH_INTROSCREEN_LINE_2";
	lines[ lines.size ] = &"AMBUSH_INTROSCREEN_LINE_3";
	lines[ lines.size ] = &"AMBUSH_INTROSCREEN_LINE_4";
	lines[ lines.size ] = &"AMBUSH_INTROSCREEN_LINE_5";

	introscreen_feed_lines( lines );
	cinematicingamesync( "ambush_fade" );
	wait 2;
	saveGame( "levelstart", &"AUTOSAVE_LEVELSTART", "whatever", true );	
	introscreen_generic_white_fade_in( 2 );

	thread autosave_now( "start", true );

	setsaveddvar( "compass", 1 );
	SetSavedDvar( "ammoCounterHide", "0" );
	SetSavedDvar( "hud_showStance", 1 );

	wait( 1 );
	 // Do final notify when player controls have been restored
	level.player freezeControls( false );

	level notify("introscreen_complete");
	level.player freezeControls( false );
}

weapon_pullout()
{
	weap = level.player getweaponslist()[ 0 ];
    level.player DisableWeapons();
	flag_wait( "pullup_weapon" );
    level.player EnableWeapons();
//	level.player switchToWeapon( weap );
}

revive_ammo_counter()
{
	flag_wait( "safe_for_objectives" );
	if( !isdefined( level.nocompass ) )
		setsaveddvar( "compass", 1 );
	SetSavedDvar( "ammoCounterHide", "0" );
	SetSavedDvar( "actionSlotsHide", "0" );
	SetSavedDvar( "hud_showstance", "1" );	
}
