#include common_scripts\utility;
#include maps\_utility;
#include maps\_anim;
#include maps\_debug;
#include maps\armada;
#include maps\armada_anim;

		
near_tv()
{
	level endon ( "tvstation_entered" );
	
	while ( 1 )
	{
		self waittill ( "trigger" );
		
		flag_set ( "near_tv" );
		while ( level.player istouching ( self ) )
			wait 1;
		
		StopCinematicInGame();
		level notify ( "away_from_tv" );
		flag_clear ( "near_tv" );
	}
}
		

movies_on_tvs()
{	
	level endon ( "stop_asad_recording" );
	wait 2;
	setsaveddvar( "cg_cinematicFullScreen", "0" );
	
	while ( 1 )
	{
		flag_wait_any ( "tvstation_entered", "near_tv" );
		start_movie_loop();
	}
}

start_movie_loop()
{
	level endon ( "away_from_tv" );
	level endon ( "stop_asad_recording" );

	for ( ;; )
	{
	  if ( getdvar("ps3Game") == "true" )
	    CinematicInGameLoopFromFastfile( "asad_speech_180" );
	  else
	    CinematicInGameLoopResident( "asad_speech_180" );
	    
	  wait 5;
	  
	  while ( IsCinematicPlaying() )
		wait 1;
	}
}

flashbang_hint()
{
	trigger = getent( "flashbang_hint", "targetname" );
	trigger waittill ( "trigger" );
	level.price anim_single_queue ( level.price, "throwflash" );
	wait 2;
	
	if ( ! flag ( "player_has_flashed" ) )
		thread keyhint( &"ARMADA_HINT_FLASH", "flash", "+smoke", 10 );
}

flag_on_flash()
{
	level.player notifyOnCommand( "player_flash", "-smoke" );
	
	level.player waittill ( "player_flash" );
	
	flag_set ( "player_has_flashed" );
}

quiet_circling_helicopters()
{
	circling_helis = get_vehiclearray( "circling_heli", "script_noteworthy" );
	//lerp_enginesound( time, base_vol, dest_vol )
	
	for ( i = 0; i < circling_helis.size; i++ )
		circling_helis[ i ] maps\_vehicle::lerp_enginesound( 2, 1, .2 ); 
}



init_heli_turrets()
{
	level.heli_turrets = [];
	maps\_vehicle::waittill_vehiclespawn_noteworthy( "circling_heli" );
	wait .1;
	
	circling_helis = get_vehiclearray( "circling_heli", "script_noteworthy" );
	array_thread( circling_helis, ::setup_circling_heli_turret );
}


circling_helis_fire()
{
	//maps\_vehicle::waittill_vehiclespawn_noteworthy( "circling_heli" );
	while ( level.heli_turrets.size == 0 )
		wait 1;
	array_thread( level.heli_turrets, ::circling_heli_minigun_firethread );
	array_thread( level.heli_turrets, ::heli_minigun_targetthread, 10 );
}

intro_helis_fire()
{
	array_thread( level.heli_turrets, ::intro_heli_minigun_firethread );
	array_thread( level.heli_turrets, ::heli_minigun_targetthread, 2 );
	
	flag_wait ( "kill_rpgs" );
	
    level notify( "helis_stop_firing" );
}


setup_circling_heli_turret()
{
	tag = "tag_gun_l";
	//tag = "tag_turret";
    turret = spawnturret( "misc_turret", self gettagorigin( tag ), "heli_minigun_noai" );
    turret setmodel( "weapon_saw_MG_setup" );
    turret linkto( self, tag, ( 0, 0, -24 ), ( 0, 90, 0 ) );
    turret maketurretunusable();
    turret setmode( "manual" );
    turret setturretteam( "allies" );
    turret setconvergencetime( 0, "yaw" );
    turret setconvergencetime( 0, "pitch" );
    
    level.heli_turrets [ level.heli_turrets.size ] = turret;

    //default_target = spawn( "script_model", self gettagorigin( tag ) );
    //default_target linkto( self, tag, ( 300, 0, 0 ), self.angles );

    //turret thread heli_minigun_firethread(); 
    //turret thread heli_minigun_targetthread();
}

intro_heli_minigun_firethread() 
{
    level endon ( "helis_stop_firing" );
	level.miniguns_firing = true;

    while( 1 )
	{
		if ( level.miniguns_firing )
        {
      	  burst = randomintrange( 3, 7 );
      	  for( i = 0; i < burst; i++ )
      	  {
      	      self shootturret();
      	      wait( 0.1 );
      	  }
    	}
		wait randomfloat( 0.5, 2 );
    }
}

circling_heli_minigun_firethread() 
{
    level endon ( "helis_stop_firing" );
	level.miniguns_firing = true;

    while( 1 )
	{
		if ( level.miniguns_firing )
		{
        	burst = randomintrange( 3, 7 );
        	for( i = 0; i < burst; i++ )
        	{
        	    self shootturret();
        	    wait( 0.1 );
        	}
    	}
		if( randomint( 3 ) == 0 )
		{
			wait randomintrange( 5, 8 );
		}
		
		wait randomfloat( 0.5, 2 );
    }
}

heli_minigun_targetthread( target_reaquire_time ) 
{
    level endon( "helis_stop_firing" );    
    target = getent( "minigun_target", "targetname" );
    self settargetentity( target );
	//tracker = spawn ("script_origin", (0,0,0));
	//tracker thread draw_target();
	
    while( true )
	{
        enemies = getaiarray( "axis" );
        enemies = remove_technical_enemies_from_array( enemies );
        if( enemies.size > 0 )
        {
			level.miniguns_firing = true;
        	//tracker notify ( "clear_target" );
        	target = enemies[ randomint( enemies.size ) ];
        	self settargetentity( target );
        	//tracker.origin = target.origin;
		}
		else
		{
			level.miniguns_firing = false;
		}
        wait target_reaquire_time;
    }
}

remove_technical_enemies_from_array( array )
{
	newarray = [];
	for( i = 0; i < array.size; i ++ )
	{
		if ( isdefined ( array[ i ].script_noteworthy ) )
			if( array[ i ].script_noteworthy == "technical_enemies" )
				continue;
		newarray[ newarray.size ] = array[ i ];
	}
	return newarray;
}


draw_target()
{
	//self endon ( "clear_target" );
	for( ;; )
	{
		maps\_debug::drawArrow( self.origin, self.angles );
		wait( 0.05 );
	}
}

get_vehiclearray( key1, key2 )
{
	vehicle_array = getentarray( key1, key2 );
	
	j = 0;
	new_vehicle_array = [];
	for( i = 0; i < vehicle_array.size; i++ )
	{
		if( vehicle_array[ i ].classname == "script_vehicle" )
		{
			new_vehicle_array[ j ] = vehicle_array[ i ];
			j++;
		}
	}
			
	return new_vehicle_array;
}

/*
circling_helis_rpg_guy_spawner()
{
	circling_heli_rpg_spawners = getentarray( "circling_heli_rpg_guy", "script_noteworthy" );
	total_spawners = circling_heli_rpg_spawners.size;
	circling_heli_rpg_spawners = array_randomize( circling_heli_rpg_spawners );
	array_thread( circling_heli_rpg_spawners, ::add_spawn_function, ::circling_helis_rpg_guy_think );
	//array_thread( circling_heli_rpg_spawners, ::add_spawn_function, ::kill_in_ten );
	
	flag_wait( "hq_cleared" ); 
	wait 1;
	level.circling_helis = get_vehiclearray( "circling_heli", "script_noteworthy" );
	
	i = 0;
	//while( ! flag( "some_flag" ) )
	while( 1 )
	{
		living_rpg_guys = getentarray( "circling_heli_rpg_guy", "script_noteworthy" );
		level.living_rpg_guys = get_living( living_rpg_guys );
		
		spawner = circling_heli_rpg_spawners[ i ];
		spawner.count = 1;
		if( level.living_rpg_guys.size < 4 )
		{
			guy = spawner spawn_ai();
			i++;
		}
		if( i >= total_spawners )
		{
			i = 0;
		}
		wait 1;
    }
}
*/


slam_zoom_intro()
{
	setSavedDvar( "hud_drawhud", "0" );	
	level.player freezeControls( true );
	level.player disableweapons();
	level.player setplayerangles( ( 0, 0, 0 ) );
	//cinematicingamesync( "armada_fade" );
	thread maps\_introscreen::introscreen_generic_black_fade_in( 0.2, 0.20 );
	
	lines = [];
	lines[ lines.size ] = &"ARMADA_INTRO";	//
	lines[ "date" ] = &"ARMADA_DATE";	//
	lines[ lines.size ] = &"ARMADA_PLACE";	//"Sgt. Paul Jackson"
	lines[ lines.size ] = &"ARMADA_INFO";	//"1st Bn, 7th Marine Regiment"
	
	maps\_introscreen::introscreen_feed_lines( lines );
	
	wait 3;
	
	level.player freezeControls( false );

	wait 2; //wait for date stamp
	
    level.player EnableWeapons();
	
	level notify("introscreen_complete"); // Do final notify when player controls have been restored
		
	wait( 2 );
	
	autosave_by_name( "levelstart" );
}




slam_zoom_sound()
{
	wait( 0.05 );
	level.player playsound( "ui_camera_whoosh_in" );
	//setsaveddvar( "compass", 0 );
	//SetSavedDvar( "ammoCounterHide", "1" );
}

slam_zoom_intro_old()
{
	slowmo_start();
		slowmo_setlerptime_in( 0.25 );
		slowmo_setlerptime_out( 0.25 );
		level.player freezeControls( true );
		level.player disableweapons();
		level.player setplayerangles( ( 0, 0, 0 ) );
	
	
		thread slam_zoom_sound();
		thread maps\_introscreen::introscreen_generic_black_fade_in( 0.7, 0.20 );
		//cinematicingamesync( "armada_fade" );
		//cinematicingame("fade_bog_b");
		
		
		lines = [];
		lines[ lines.size ] = &"ARMADA_INTRO";	//
		lines[ "date" ] = &"ARMADA_DATE";	//
		lines[ lines.size ] = &"ARMADA_PLACE";	//"Sgt. Paul Jackson"
		lines[ lines.size ] = &"ARMADA_INFO";	//"1st Bn, 7th Marine Regiment"
		
		
		zoomHeight = 60000;
		
		maps\_introscreen::introscreen_feed_lines( lines );
		/*
		for ( i=0; i < lines.size; i++ )
		{
			interval = 1;
			time = ( i * interval ) + 1;
			delayThread( time, maps\_introscreen::introscreen_corner_line, lines[ i ], ( lines.size - i - 1 ), interval );
		}
		*/
	
		origin = (970.23, -10403.9, -217.093);
		origin = origin + ( -50, -250, 0 );
		level.player.origin = origin + ( 0, 0, zoomHeight );
		ent = spawn( "script_model", (69,69,69) );
		ent.origin = level.player.origin;
		
		ent setmodel( "tag_origin" );
		ent.angles = level.player.angles;
		level.player linkto( ent );//, "tag_player", 1 );
		ent.angles = ( ent.angles[ 0 ] + 89, ent.angles[ 1 ] + 29.7492, 0 );
		
		time = 2;
		
		ent moveto ( origin + (0,0,0), time, 0, time );
		wait 1.25;
		slowmo_lerp_in();
		wait( 0.25 );
		thread whitescreen();
		wait( 0.45 );
	
		level.player notify ( "attach_to_heli" );
		wait( 0.05 );
		slowmo_lerp_out();
	slowmo_end();;//reset defaults

	//level.player unlink();
	//level.player freezeControls( false );
	
	flag_set ( "slam_zoom_done" );
	//println ( "origin goal: " + level.piggyback_guy.origin );
	
	thread play_sound_in_space( "ui_screen_trans_in", level.player.origin );
	
	wait( 0.2 );
	
    level.player EnableWeapons();
	
	thread play_sound_in_space( "ui_screen_trans_out", level.player.origin );
	
	wait( 0.2 );
	
	level notify("introscreen_complete"); // Do final notify when player controls have been restored
		
	wait( 2 );
	level notify( "destroy_hud_elements" );
	//setsaveddvar( "compass", 1 );
	//SetSavedDvar( "ammoCounterHide", "0" );
	
	ent delete();
	
	autosave_by_name( "levelstart" );
	//wait 5;
	
}


whitescreen()
{
	wait( 0.2 );
	overlay = newHudElem();
	overlay.x = 0;
	overlay.y = 0;
	overlay setshader( "white", 640, 480 );
	overlay.alignX = "left";
	overlay.alignY = "top";
	overlay.horzAlign = "fullscreen";
	overlay.vertAlign = "fullscreen";
	overlay.alpha = 0;
	overlay fadeOverTime( 0.15 );
	overlay.alpha = 1;
	wait( 0.35 );
	overlay fadeOverTime( 0.15 );
	overlay.alpha = 0;
	wait( 0.15 );
	overlay destroy();
	setSavedDvar( "hud_drawhud", "0" );	
}