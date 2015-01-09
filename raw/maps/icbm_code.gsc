#include common_scripts\utility;
#include maps\_utility;
#include maps\_anim;
#include maps\_debug;
#include maps\_stealth_logic;
#include maps\icbm_dialog;
#include maps\icbm;
#include maps\icbm_anim;


//if you want to change the distances at which enemies detect you or your team - use this function:

 //        stealth_detect_ranges_set( hidden, alert, spotted )

//the parameters are optional and they are an array of 3...here's the default for hidden
   //     hidden = [];
   //     hidden[ "prone" ]       = 70;
   //     hidden[ "crouch" ]      = 600;
   //     hidden[ "stand" ]       = 1024;


//if you want your friendly ai to use a smart stance handler turn this flag on

//        ai ent_flag_set( "_stealth_stance_handler" );


	//if( flag( "_stealth_spotted" ) )
	//	return;
	//level endon( "_stealth_spotted" );	

	//level endon( "_stealth_stop_stealth_logic" );



//array_thread( getentarray( "tableguards", "script_noteworthy" ), ::add_spawn_function, ::idle_anim_think );

idle_anim_think()
{
	self endon("death");
	
	if( !isdefined( self.target ) )
		return;
	
	node = getent(self.target, "targetname");
	
	if( !isdefined( node.script_animation ) )
		return;
		
	anime = undefined;
	switch( node.script_animation )
	{
		case "coffee":
			anime = "coffee_"; 
			break;
		case "sleep":
			anime = "sleep_"; 
			break;
		case "phone":
			anime = "cellphone_";
			break;
		case "smoke":
			anime = "smoke_";
			break;
		case "lean_smoke":
			anime = "lean_smoke_";
			break;
		default:
			return;
	}
	
	self.allowdeath = true;
	
	node = getent(self.target, "targetname");
	self.ref_node = node;
	
	if( node.script_animation == "sleep" )
	{
		chair = spawn_anim_model( "chair" );
		self.has_delta = true;
		self.anim_props = make_array( chair );
		node thread anim_first_frame_solo( chair, "sleep_react" );
		
		node stealth_ai_idle_and_react( self, anime + "idle", anime + "react" );
	}
	else
		node stealth_ai_reach_and_arrive_idle_and_react( self, anime + "reach", anime + "idle", anime + "react" );
}


//friendly_stealth_state = [];
//friendly_stealth_state[ "hidden" ]       = ::friendly_state_hidden;
//friendly_stealth_state[ "alert" ]      = 600;
//friendly_stealth_state[ "spotted" ]       = 1024;

ICBM_friendly_state_hidden()
{
	level endon("_stealth_detection_level_change");
	
	self.baseAccuracy 	= self._stealth.behavior.goodaccuracy;
	self.Accuracy 		= self._stealth.behavior.goodaccuracy;
	self._stealth.behavior.oldgrenadeammo	= self.grenadeammo;
	self.grenadeammo	= 0;
	self.forceSideArm 	= false;
	self.ignoreall 		= true;
	self.ignoreme 		= true;
	self disable_ai_color();
	waittillframeend;
	self.fixednode		= false;
}

ICBM_friendly_state_alert()
{
	level endon("_stealth_detection_level_change");
	self ICBM_friendly_state_hidden();
}


ICBM_friendly_state_spotted()
{
	level endon("_stealth_detection_level_change");
	
	self thread maps\_stealth_behavior::friendly_spotted_getup_from_prone();
		
	self.baseAccuracy 	= self._stealth.behavior.badaccuracy;
	self.Accuracy 		= self._stealth.behavior.badaccuracy;
	self.grenadeammo 	= self._stealth.behavior.oldgrenadeammo;
	self allowedstances( "prone", "crouch", "stand" );
	self stopanimscripted();
	self.ignoreall 	= false;
	self.ignoreme 	= false;
	self disable_cqbwalk();
	self enable_ai_color();
	self.disablearrivals 	= true;
	self.disableexits 		= true;
	self pushplayer( false );
}


friendlies_stop_on_truck_spotted()
{
	self endon ( "death" );
	
	flag_wait ( "truck_spotted" );
	if ( flag ( "truckguys dead" ) )
		return;
		
	self disable_ai_color();
	self setgoalpos ( self.origin ); 
	self.goalradius = 30;
	
	flag_wait( "truckguys dead" );

	wait 1;
	
	self enable_ai_color();
}

friendlies_stop_paths_to_fight()
{
	self endon ( "death" );
	
	level waittill_either( "_stealth_spotted", "at_range" );
	//flag_wait( "_stealth_spotted" );
	
	if ( flag ( "patrollers_dead" ) )
		return;
	
	self.fixednode = false;
	self notify( "stop_going_to_node" );
	self.goalradius = 5000;
	
	flag_wait( "patrollers_dead" ); 
	
	wait 3;
	make_friendies_not_cqb();
	activate_trigger_with_targetname( "basement_door_nodes" );
	self.fixednode = true;
}

disable_ignoreme_on_stealth_spotted()
{
	flag_wait( "_stealth_spotted" );
	//iprintlnbold ( "_stealth_spotted" );
	
	//turn_off_flashlights();
	stop_make_friendies_ignored();
}

disable_deadlyness_on_stealth_spotted()
{
	flag_wait( "_stealth_spotted" );
	//iprintlnbold ( "_stealth_spotted" );
	
	disable_friendly_deadlyness();
}

disable_friendly_deadlyness()
{
	allies = getaiarray( "allies" );
	for ( i = 0; i < allies.size; i++ )
	{
		if ( isdefined ( allies[ i ].normal_baseaccuracy ) )
			allies[ i ].baseAccuracy = allies[ i ].normal_baseaccuracy;
	} 
}

stop_make_friendies_ignored()
{
	allies = getaiarray( "allies" );
	for ( i = 0; i < allies.size; i++ )
	{
		allies[ i ].ignoreme = false;
	} 
}


friendlies_fighting_nodes()
{
	level endon ( "outside_cleared" );
	flag_wait ( "_stealth_spotted" );
	activate_trigger_with_targetname ( "friendlies_fighting_nodes" );
}




icbm_introscreen()
{
	level.player freezeControls( true );
	
	lines = [];
	lines[ lines.size ] = &"ICBM_INTROSCREEN_LINE_1";	
	lines[ "date" ] 	= &"ICBM_INTROSCREEN_LINE_2";
	//lines[ "date" ] = "Day 6 - 6:19:[{FAKE_INTRO_SECONDS:32}]";
	lines[ lines.size ] = &"ICBM_INTROSCREEN_LINE_3";	
	lines[ lines.size ] = &"ICBM_INTROSCREEN_LINE_4";	
	lines[ lines.size ] = &"ICBM_INTROSCREEN_LINE_5";	
	
	
	thread maps\_introscreen::introscreen_feed_lines( lines );
	thread maps\_introscreen::introscreen_generic_black_fade_in( 5 );
	setSavedDvar( "sm_sunEnable", 0 ); // optimization: disable sun shadows for start section
	setSavedDvar( "sm_spotEnable", 0 ); // optimization: disable spot shadows for start section
	wait 5;
	level.player freezeControls( false );
}


truck_setup()
{
	self waittill ( "trigger" );
	
	truck = maps\_vehicle::waittill_vehiclespawn( "truck" );
	//truck = getent( "truck", "targetname" );
	truck maps\_vehicle::lights_on( "headlights" );
	wait .5;
									

	flag_wait ( "truck_stopped" );
	
 	truck maps\_vehicle::lights_on( "brakelights" );	
	flag_set( "truck arived" );
}

truck_guys_think()
{
	self endon ( "death" );
	level.truckguys[level.truckguys.size] = self;
	self.ignoreme = true;
	
	flag_wait ( "truck_stopped" );	
	wait 2;
	
	self.ignoreme = false;
	
	//wait 1;
	
	//self attach_flashlight( true );  //flashlights are held wrong for these anims
}

ignore_truck_guys_till_truck_stopped()
{
	truck_guys = getentarray ( "truck_guys", "script_noteworthy" );
	flag_wait ( "truck_stopped" );	
	
}

music_tension_loop( endonMsg, musicAlias, musicLength, musicFadeTime )
{
	// icbm_combat_tension( 55 seconds )
	// icbm_tower_tension( 95 seconds )
	
	level endon( endonMsg );
	
	if( !isdefined( musicFadeTime ) )
		musicFadeTime = 1;
	
	musicStop( 3 );
	wait 3.1;
	while ( 1 )
	{
		MusicPlayWrapper( musicAlias ); 
		wait( musicLength );
		musicStop( musicFadeTime );
		wait ( musicFadeTime + 0.2 );
	}
}

/*
music_launch()
{
	musicStop( 1 );
	wait 2;
	MusicPlayWrapper( "icbm_launch_tension_music" );
}
*/

friendlies_start_paths()
{
	path_left = getnode ( "path_left", "targetname" );
	path_center = getnode ( "path_center", "targetname" );
	path_right = getnode ( "path_right", "targetname" );
	
	//greens = get_force_color_guys( "allies", "g" );
	//reds = get_force_color_guys( "allies", "r" );
	third_guy = get_a_generic_friendly();
	
	
	
	level.gaz thread maps\_spawner::go_to_node( path_center );
	level.price thread maps\_spawner::go_to_node( path_left );
	if ( isalive ( third_guy ) )
		third_guy thread maps\_spawner::go_to_node( path_right );
	
	/*
	path_starts = getnodearray ( "path_starts", "targetname" );
	friendlies = getaiarray( "allies" );
	for(i = 0; i < friendlies.size; i++)
	{
		closest = getclosest ( friendlies[ i ].origin, path_starts );
		path = getnode ( closest.target, "targetname" );
		friendlies[ i ].goalradius = 64;
	    friendlies[ i ] thread maps\_spawner::go_to_node( path );
	}
	*/
}

get_a_generic_friendly()
{
	allies = getaiarray( "allies" );
	allies = remove_heroes_from_array( allies );
	return allies[ 0 ];
}

attach_flashlight( state, delayed )
{
	self endon ( "death" );
	if ( isDefined( self.have_flashlight ) )
		return;
	if (isdefined ( delayed ) )
		wait ( randomfloatrange ( 0, 5 ) );
	self attach( "com_flashlight_on", "tag_inhand", true );
	self.have_flashlight = true;
	self flashlight_light( state );
	
	self thread dropFlashlightOnDeath();
}

dropFlashlightOnDeath()
{
	self waittill( "death" );
	if ( isdefined( self ) )
		self detach_flashlight();
}

detach_flashlight_onspotted()
{
	self endon( "death" );
	
	self waittill( "drop_light" );
		
	self detach_flashlight();
}

detach_flashlight()
{
	if ( !isdefined( self.have_flashlight ) )
		return;
	self detach( "com_flashlight_on", "tag_inhand" );
	self flashlight_light( false );
	self.have_flashlight = undefined;
}

flashlight_light( state )
{
	flash_light_tag = "tag_light";

	if ( state )
	{
		flashlight_fx_ent = spawn( "script_model", ( 0, 0, 0 ) );
		flashlight_fx_ent setmodel( "tag_origin" );
		flashlight_fx_ent hide();
		flashlight_fx_ent linkto( self, flash_light_tag, ( 0, 0, 0 ), ( 0, 0, 0 ) );

		self thread flashlight_light_death( flashlight_fx_ent );
		playfxontag( level._effect[ "flashlight" ], flashlight_fx_ent, "tag_origin" );
	}
	else if ( isdefined( self.have_flashlight ) )
		self notify( "flashlight_off" );
}

flashlight_light_death( flashlight_fx_ent )
{
	self waittill_either( "death", "flashlight_off" );

	flashlight_fx_ent delete();
	self.have_flashlight = undefined;

}





////// time of day change stuff///////

set_interior_vision()
{
	while ( 1 )
	{
		flag_wait ( "player_is_inside" );
		
		set_vision_set( "icbm_interior", 6 );
		
		flag_waitopen ( "player_is_inside" );
		
		set_vision_set( level.outsideVisionFile, 6 );
	}
}

SunRise()
{
	level.sunRiseInterpColors = [];
	
	sunRiseInitColor( "sun", ( 0.1, 0.1, 0.1 ) );
	setOutsideVisionFile( "icbm_sunrise0", 0.05 );

	thread doSunRiseColors();
	setExpFog( 0.00, 4000.00, 0.5, 0.5, 0.5, 0 );
	wait .05;
	
	//first values:
	
	setExpFog( 0, 771.52, 0.5, 0.5, 0.5, 20 );

	interval = .05;
	//thinker:
	while ( 1 )
	{
		sunColor = sunRiseIncrTime( "sun", interval );
		setSunLight( sunColor[ 0 ], sunColor[ 1 ], sunColor[ 2 ] );
		wait interval;
	}
}

setOutsideVisionFile( visionFile, interval )
{
	level.outsideVisionFile = visionFile;
	if ( !level.playerIsInside )
	{
		set_vision_set( visionFile, interval );
	}
}

skip_to_sunrise2()
{
	sunrise2 = getent( "sunrise2", "targetname" );
	wait .1;
	sunrise2.interval = .05;
	sunrise2 notify ( "trigger" );
}


skip_to_sunrise3()
{
	sunrise2 = getent( "sunrise2", "targetname" );
	sunrise3 = getent( "sunrise3", "targetname" );
	wait .1;
	sunrise2 notify ( "trigger" );
	wait .1;
	sunrise3.interval = .05;
	sunrise3 notify ( "trigger" );
}

skip_to_sunrise4()
{
	sunrise2 = getent( "sunrise2", "targetname" );
	sunrise3 = getent( "sunrise3", "targetname" );
	sunrise4 = getent( "sunrise4", "targetname" );
	wait .1;
	sunrise2 notify ( "trigger" );
	wait .1;
	sunrise3 notify ( "trigger" );
	wait .1;
	sunrise4.interval = .05;
	sunrise4 notify ( "trigger" );
}

doSunRiseColors()
{
	sunrise2 = getent( "sunrise2", "targetname" );
	sunrise3 = getent( "sunrise3", "targetname" );
	sunrise4 = getent( "sunrise4", "targetname" );
	
	sunrise2.interval = 60;
	sunrise3.interval = 20;
	sunrise4.interval = 20;
	
	// these intervals will probably need tweaking when there's gameplay.

	// note that we don't actually wait for the intervals to pass.
	// if we hit the next trigger before it passes, everything will just
	// interpolate ahead from its current value.~
	
	///////////////////////////////////////////////////////////~
	//#1st trigger
	/* getent( "sunrise1", "targetname" ) waittill( "trigger" );
	interval = 20;
	setExpFog( 200, 10000, .1, .1, .2, interval );
	sunRiseSetColorTarget( "sun", ( 0, 0, 0 ), interval );
	set_vision_set( "icbm_sunrise1", interval );*/ 


	///////////////////////////////////////////////////////////
	//#2nd trigger
	sunrise2 waittill( "trigger" );
	setSavedDvar( "sm_sunEnable", 1 ); // re-enable sun shadows
	setSavedDvar( "sm_spotEnable", 1 ); // re-enable spot shadows
	interval = sunrise2.interval;
	setExpFog( 200, 12000, .27, .25, .35, interval );
	sunRiseSetColorTarget( "sun", vectorScale( ( 1, .5, .2 ), .75 ), interval );
	setOutsideVisionFile( "icbm_sunrise2", interval );
	// iprintlnbold( "Sunrise 2" );
	thread stopSnow();

	///////////////////////////////////////////////////////////
	//#3: approaching the industrial area. sun becomes strong red over 20 seconds
	sunrise3 waittill( "trigger" );
	interval = sunrise3.interval;
	setExpFog( 200, 12000, .169, .168, .244, interval );
	sunRiseSetColorTarget( "sun", vectorScale( ( 1, .6, .3 ), 1 ), interval );
	setOutsideVisionFile( "icbm_sunrise3", interval );
	// iprintlnbold( "Sunrise 3" );

	///////////////////////////////////////////////////////////
	//#4: leaving the industrial area. sun becomes near white over 20 seconds
	sunrise4 waittill( "trigger" );
	interval = sunrise4.interval;
	setExpFog( 200, 15000, .169, .168, .244, interval );
	sunRiseSetColorTarget( "sun", vectorScale( ( 1, .7, .4 ), 1.35 ), interval );
	setOutsideVisionFile( "icbm_sunrise4", interval );
	// iprintlnbold( "Sunrise 4" );
}

sunRiseIncrTime( colorName, time )
{
	data = level.sunRiseInterpColors[ colorName ];
	
	assert( isdefined( data ) );
	
	data[ "timePassed" ] += time;
	if ( data[ "timePassed" ] >= data[ "timeTotal" ] )
		data[ "timePassed" ] = data[ "timeTotal" ];
	
	A = data[ "start" ];
	B = data[ "target" ];
	t = data[ "timePassed" ] / data[ "timeTotal" ];
	
	data[ "current" ] = vectorScale( A, 1 - t ) + vectorScale( B, t );
	
	level.sunRiseInterpColors[ colorName ] = data;
	
	return data[ "current" ];
}

sunRiseInitColor( colorName, color )
{
	data[ "start" ] = color;
	data[ "target" ] = color;
	data[ "current" ] = color;
	data[ "timePassed" ] = 0;
	data[ "timeTotal" ] = 1;
	
	level.sunRiseInterpColors[ colorName ] = data;
}

sunRiseSetColorTarget( colorName, targetColor, time )
{
	data = level.sunRiseInterpColors[ colorName ];
	
	assert( isdefined( data ) );
	
	data[ "start" ] = data[ "current" ];
	data[ "target" ] = targetColor;
	data[ "timePassed" ] = 0;
	data[ "timeTotal" ] = time;
	
	level.sunRiseInterpColors[ colorName ] = data;
}

stopSnow()
{
	//wait 20;
	flag_set( "stop_snow" );
	thread killCloudCover();
}

killCloudCover()
{
	
	cloudcoverfx	 = getfxarraybyID( "cloud_cover" );

	for ( i = 0; i < cloudcoverfx.size; i++ )
		cloudcoverfx[ i ] pauseEffect();

}


min_spec_kill_fx()
{
	fx = [];
	fx = getfxarraybyID( "fog_icbm" );
	fx = array_combine( fx, getfxarraybyID( "fog_icbm_a" ) );
	fx = array_combine( fx, getfxarraybyID( "fog_icbm_b" ) );
	fx = array_combine( fx, getfxarraybyID( "fog_icbm_c" ) );
	fx = array_combine( fx, getfxarraybyID( "cloud_bank" ) );
	fx = array_combine( fx, getfxarraybyID( "cloud_bank_a" ) );
	fx = array_combine( fx, getfxarraybyID( "cloud_bank_far" ) );

	for ( i = 0; i < fx.size; i++ )
		fx[ i ] pauseEffect();
}



whiteIn()
{
	overlay = newHudElem();
	overlay.x = 0;
	overlay.y = 0;
	overlay setshader( "white", 640, 480 );
	overlay.alignX = "left";
	overlay.alignY = "top";
	overlay.horzAlign = "fullscreen";
	overlay.vertAlign = "fullscreen";
	overlay.alpha = 1;
	overlay.sort = 2;
	
	trigger = getent( "cloud", "targetname" );
	assertex( isDefined( trigger ), "cloud trigger not found" );
	trigger waittill( "trigger" );
	
	wait 1;	
	overlay fadeWhiteOut( 2, 0, 6 );
}

fadeWhiteOut( duration, alpha, blur )
{
	self fadeOverTime( duration );
	self.alpha = alpha;
	// setblur( blur, duration );
	wait duration;
}


make_friendies_cqb()
{
	allies = getaiarray( "allies" );
	for ( i = 0; i < allies.size; i++ )
	{
		allies[ i ] enable_cqbwalk();
	} 
}

make_friendies_not_cqb()
{
	allies = getaiarray( "allies" );
	for ( i = 0; i < allies.size; i++ )
	{
		allies[ i ] disable_cqbwalk();
	} 
}


make_friendies_deadly()
{
	allies = getaiarray( "allies" );
	for ( i = 0; i < allies.size; i++ )
	{
		allies[ i ].normal_baseaccuracy = allies[ i ].baseAccuracy;
		allies[ i ].baseAccuracy = 1000;
	} 
}


opforce_more_accurate()
{
	self.baseAccuracy = 5;
}

all_friendlies_turn_blue()
{
	allies = getaiarray( "allies" );
	for ( i = 0; i < allies.size; i++ )
	{
		allies[ i ] set_force_color( "b" );
	}
}



clip_nosight_logic()
{
	self endon( "death" );
	
	flag_wait( self.script_flag );
	
	self thread clip_nosight_logic2();
	self setcandamage(true);
	
	self clip_nosight_wait();
	
	self delete();	
}

clip_nosight_wait()
{
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	self waittill( "damage" );	
}

clip_nosight_logic2()
{
	self endon( "death" );	
	
	flag_wait_either( "_stealth_spotted", "_stealth_found_corpse" );
	
	self delete();
}

first_chopper_fly_over()
{
	wait 3;
	// iprintlnbold( "Marine1 - Enemy helicopters!" );
	level.gaz anim_single_queue( level.gaz, "enemyhelicopters" );
	// iprintlnbold( "Price - Move!" );
	//mi_17_01 = getent( "mi_17_01", "targetname" );


	allies = getaiarray( "allies" );
	for ( i = 0; i < allies.size; i++ )
	{
		allies[ i ] thread prone_till_flag( "chopper_gone" );
	}
    
	wait 1;
	
	flag_wait( "chopper_gone" );
	level.price anim_single_queue( level.price, "move" );
	wait 1;


		
	activate_trigger_with_targetname( "friendlies_at_tower" );
}

prone_till_flag( msg )
{
	self endon ( "death" );
	wait ( randomfloatrange ( 0, .5 ) );	
	self allowedstances( "prone" );
	old_goal = self.goalpos;
	self anim_generic_custom_animmode( self, "gravity", "pronehide_dive" );
	self setgoalpos( self.origin );
	self.goalradius = 4;

	flag_wait( msg );
	
	wait ( randomfloatrange ( 1, 2 ) );
	
	self allowedstances ( "stand", "prone", "crouch" );
	self setgoalpos( old_goal );
}

make_friendies_ignored()
{
	allies = getaiarray( "allies" );
	for ( i = 0; i < allies.size; i++ )
	{
		allies[ i ].ignoreme = true;
	}
}



turn_off_flashlights()
{
	axis = getaiarray( "axis" );
	for ( i = 0; i < axis.size; i++ )
	{
		wait ( randomfloatrange ( .1, .3 ) );
		axis[ i ] detach_flashlight();
		//axis[ i ] notify( "flashlight_off" );
	} 
}

ignoreme_till_close()
{
	//self is bad guy
	self endon ( "death" );
	self.ignoreme = true;
	array_thread( level.friendlies, ::notify_at_range, self, 1200, "at_range" );
	
	level waittill_either( "_stealth_spotted", "at_range" );

	self.ignoreme = false;
}

ignoreme_till_stealth_broken()
{
	//self is bad guy
	self endon ( "death" );
	self.ignoreme = true;
	
	flag_wait ( "_stealth_spotted" );

	self.ignoreme = false;
}

notify_at_range( enemy, range, msg )
{
	self endon ( "death" );
	enemy endon ( "death" );
	while ( ( distance (enemy.origin, self.origin ) ) > range )
		wait 1;
	level notify ( msg );
}

second_squad_talker_think()
{
	level.gm5 = self;
	level.gm5.animname = "gm5";
	
	
}

price_think()
{
	level.price = self;	
	level.price.animname = "price";
	level.price thread magic_bullet_shield();
	level.price.interval = 50;
	level.friendlies[level.friendlies.size] = self;
	level.price make_hero();
}

gaz_think()
{
	level.gaz = self;	
	level.gaz.animname = "gaz";
	level.gaz thread magic_bullet_shield();
	level.gaz.interval = 50;
	level.friendlies[level.friendlies.size] = self;
	level.gaz make_hero();
}

griggs_think()
{
	level.griggs = self;	
	level.griggs.animname = "griggs";
	level.griggs thread magic_bullet_shield();
	level.griggs.interval = 50;
	level.friendlies[level.friendlies.size] = self;
	level.griggs make_hero();
}


captured_griggs_think()
{
	self.pacifist = true;
	self enable_cqbwalk();
	self.ignoreme = true;
	level.griggs_node = getnode( "griggs_node", "targetname" );
	self thread griggs_idle( level.griggs_node );
	wait .1;
	thread griggs_fake_gun();
	
	//if ( getdvar ( "debug_drawcuff" ) == "on" )
	//{
	level.griggs attach( "prop_flex_cuff_obj", "tag_inhand", true );
	level.griggs attach( "prop_flex_cuff", "tag_inhand", true );
	
	level waittill ( "griggs_loose" );
	
	level.griggs detach( "prop_flex_cuff_obj", "tag_inhand" );
	level.griggs detach( "prop_flex_cuff", "tag_inhand" );
	//}
}

griggs_grab_gun( parameter1, parameter2 )
{
	level.griggs.fake_gun delete();
	level.griggs gun_recall();
	//level.griggs animscripts\shared::placeWeaponOn( level.griggs.weapon, "right" );
}

griggs_fake_gun()
{
	org = level.griggs gettagorigin( "TAG_WEAPON_RIGHT" );
	angles = level.griggs gettagangles( "TAG_WEAPON_RIGHT" );
	
	fake_gun = spawn ("script_model", org);
	fake_gun setmodel ( "weapon_saw" );
	fake_gun.angles = angles;
	level.griggs.fake_gun = fake_gun;
	
	level.griggs gun_remove();	
}


griggs_idle( node )
{
	self endon( "griggs_loose" );
	node thread anim_loop_solo( self, "grigsby_rescue_idle", undefined, "stop_idle" );
}

friendly_think()
{	
	self.animname = "generic";
	self.interval = 50;
	self thread replace_on_death();
	level.friendlies[level.friendlies.size] = self;
}


respawned_friendly_think()
{	
	self.animname = "generic";
	self.interval = 50;
	level.friendlies[level.friendlies.size] = self;
}


kill_during_breach1(  parameter1, parameter2 )
{
	enemies = getaiarray ( "axis" );
	for ( i = 0; i < enemies.size; i++ )
		if ( enemies[ i ].script_noteworthy == "interogation_speaker" )
			enemies[ i ] doDamage( enemies[ i ].health + 100, enemies[ i ].origin );
}


kill_during_breach2( parameter1, parameter2 )
{
	enemies = getaiarray ( "axis" );
	for ( i = 0; i < enemies.size; i++ )
		if ( enemies[ i ].script_noteworthy == "interogation_buddy" )
			enemies[ i ] doDamage( enemies[ i ].health + 100, enemies[ i ].origin );
}

parachute_player()
{
	level thread maps\icbm_fx::playerEffect();
	level thread maps\icbm_fx::cloudCover();
	level.player disableweapons();
	level thread whiteIn();
	// MusicPlayWrapper( "icbm_intro_music" ); 
	
	// setSavedDvar( "hud_drawhud", "0" );	
	
	level.player allowProne( false );
	level.player allowCrouch( false );
	para_start = getent( "para_start", "targetname" );
	para_stop = getent( "para_stop", "targetname" );
	// level waittill( "starting final intro screen fadeout" );
	
	
	level.player linkto( para_start );
	para_start moveto( para_stop.origin, 3, 0, 0 );	
	// level.player thread maps\_utility::playSoundOnTag( "parachute_land_player" );

	para_start waittill( "movedone" );
	level.player unlink();
	level.player enableweapons();
	
	// setSavedDvar( "hud_drawhud", "1" );	
	
	level.player allowProne( true );
	level.player allowCrouch( true );

	//autosave_by_name( "on_the_ground" );	
}


trigger_wait_and_set_flag( trigger_targetname )
{
	flag_init( "trigger_" + trigger_targetname );

	trigger = getent( trigger_targetname, "targetname" );
	assertex( isDefined( trigger ), trigger_targetname + " trigger not found" );
	trigger waittill( "trigger" );
	trigger trigger_off();
	
	flag_set( "trigger_" + trigger_targetname );
}


sound_fade_then_delete()
{
	self waittill ( "trigger" , vehicle ); 
	vehicle maps\_vehicle::volume_down( 2 ); 
	wait 2;
	if ( isdefined ( vehicle ) ) 
		vehicle delete();
}

start_interogation()
{
	interogation_speaker = getent( "interogation_speaker", "script_noteworthy" );
	interogation_speaker add_spawn_function( ::interogation_speaker_think );
		
	interogators = getentarray( "interogators", "targetname" );
	//array_thread( interogators, ::add_spawn_function, ::stealth_ai );
	array_thread( interogators, ::add_spawn_function, ::ignore_all_till_flag, "breach_started" );
	
	array_thread( interogators, ::spawn_ai );
	flag_set ( "start_interogation" );
	wait .5;
	thread dialog_grigs_guys_jibjab();
}

ignore_all_till_flag( msg )
{
	self endon ( "death" );
	self.ignoreall = true;
	
	flag_wait( msg );
	
	self.ignoreall = false;
}

interogation_speaker_think()
{
	level.ru1 = self;
	self.animname = "ru1";
	self.a.disableLongDeath = true;
}

knife_kill_setup()
{
	/* -- -- -- -- -- -- -- -- -- -- -- - 
	WAIT FOR PRICE AND FOR PLAYER LOOK
	 -- -- -- -- -- -- -- -- -- -- -- -- -*/ 	
	// level.price waittill( "in_position_for_kill" );
	// level.price cqb_walk( "on" );
	trigger = getent( "price_knife_kill", "targetname" );
	assertex( isDefined( trigger ), "price_knife_kill trigger not found" );
	trigger waittill( "trigger" );
	trigger trigger_off();	
	bd01_spawner = getent( "house01_badguy01", "script_noteworthy" );
	level.knifeKillNode = getnode( "knifeKillNode", "targetname" );
	
	//level.player setthreatbiasgroup( "icbm_friendlies" );
	createthreatbiasgroup( "victims" );
	setignoremegroup( "icbm_friendlies", "victims" ); //victims will ignore friendlies
	
	bd01_spawner add_spawn_function( ::AI_hostile_think );
	bd01_spawner add_spawn_function( ::stealth_ai );
	bd01_spawner add_spawn_function( ::set_threatbias_group, "victims" );

	house01_badguy01 = bd01_spawner spawn_ai();

	assertex( isDefined( house01_badguy01 ), "knife kill spawner undefined" );

	house01_badguy01 thread AI_hostile_knife_kill_think();
	
	house01_badguy01 waittill( "death" );
	level.price enable_ai_color();
	flag_set( "knife_sequence_done" );	
}

AI_hostile_think()
{
	self endon( "death" );
	
	self.animname = "hostile";
	self.allowdeath = true;
	self.ignoreme = true;
	self.health = 1;
	//self.ignoreall = true;	
	//self.pacifist = true;
	self thread stealth_enemy_endon_alert();
	
	level.knifeKillNode  anim_reach_solo( self, "phoneguy_idle_start" );
	level.knifeKillNode thread anim_loop_solo( self, "phoneguy_idle", undefined, "stop_idle" );
	
	
	self waittill( "stealth_enemy_endon_alert" );
	
	self setthreatbiasgroup();
	self.ignoreme = false;
	level.knifeKillNode  notify( "stop_idle" );
	// self stopanimscripted();
	//self notify( "stop_talking" );
	//self thread anim_single_solo( self, "phoneguy_alerted" );
}

AI_hostile_knife_kill_think()
{
	self endon( "death" );
	self endon( "stealth_enemy_endon_alert" );
	
	/* -- -- -- -- -- -- -- -- -- -- -- - 
	PRICE STARTS TO SNEAK UP
	 -- -- -- -- -- -- -- -- -- -- -- -- -*/ 	
	level.price setgoalpos( self.origin );
	flag_set( "knife_sequence_starting" );
	
	level.knifeKillNode anim_reach_solo( level.price, "knifekill_price" );
	
	self thread knife_kill_fx();
	self thread AI_hostile_knife_kill_abort_think();
	level.price attach( "weapon_parabolic_knife", "TAG_INHAND" );
	level.price playsound ( "scn_icbm_knife_melee" );

	level.knifeKillNode thread anim_single_solo( level.price, "knifekill_price" );
	level.knifeKillNode thread anim_single_solo( self, "phoneguy_death" );
	
	time = 	getanimlength( self getanim( "phoneguy_death" ) );
	time -= 2.75;
	self delaythread( time, ::AI_hostile_knife_kill_finish_anim );

	self delaythread ( time, ::set_ignore_all );

	
	//self waittillmatch( "single anim", "end_reaction" );
	//self notify( "knife_kill_point_of_no_return" );
	/* -- -- -- -- -- -- -- -- -- -- -- - 
	KNIFE KILL!!!!!
	 -- -- -- -- -- -- -- -- -- -- -- -- -*/ 	
	// thread play_sound_in_space( level.scr_sound[ "knife_sequence" ], self.origin );
	//self.allowdeath = false;
	
	level.knifeKillNode waittill( "phoneguy_death" );
	
	//self waittillmatch( "single anim", "end" );
	level notify( "knife_kill_done" );
	level.price setgoalpos( level.price.origin );
	level.price stopanimscripted();
	
	self.a.nodeath = true;
	self.allowdeath = true;
	self animscripts\shared::DropAllAIWeapons();
	self dodamage( self.health + 50, ( 0, 0, 0 ) );
}

AI_hostile_knife_kill_finish_anim()
{
	self endon( "stealth_enemy_endon_alert" );
	
	self notify( "_stealth_stop_stealth_logic" );
	self.allowdeath = false;
	self.a.nodeath = true;
}
set_ignore_all()
{
	self.ignoreall = true;
}

AI_hostile_knife_kill_abort_think()
{
	//self endon( "knife_kill_point_of_no_return" );
	flag_wait( "knife_sequence_starting" );
	
	self waittill_either( "death", "stealth_enemy_endon_alert" );
	level.price detach( "weapon_parabolic_knife", "TAG_INHAND" );
	level.price stopanimscripted();
}


knife_kill_fx()
{
	self endon( "death" );
	
	self waittillmatch( "single anim", "knife hit" );
	playfxontag( level._effect[ "knife_stab" ], self, "j_neck" );
}





dialogue_execute( sLineToExecute )
{
	self endon( "death" );

	self anim_single_queue( self, sLineToExecute );

}




friendlies_open_upstairs_door()
{
	//use village assault price anim
	//price opens the door part way, throws in a flashbang and then closes it
}


beehive_wait()
{
	level endon ( "house1_upstairs_dead" );
	flag_wait ( "_stealth_spotted" );
	
	flag_set ( "beehive1_active" );
	thread beehive_attack();
}
	
beehive_attack()
{
	beehive_enemy = getentarray( "beehive_enemy", "targetname" );
	array_thread( beehive_enemy, ::spawn_ai );
		
	wait 4;
	first_door = getEnt( "house1_upstairs_first_door", "targetname" );
	thread open_door( first_door, -178 );

	
	wait 1;
		
	second_door = getEnt( "house1_upstairs_second_door", "targetname" );
	
	beehive_enemy_second_door = getentarray( "beehive_enemy_second_door", "targetname" );	
	open_door( second_door, 176 , beehive_enemy_second_door );
	
	wait .1;
	thread maps\_spawner::kill_spawnerNum( 0 );
}

open_door( door, angle, beehive_enemy_second_door )
{
	while ( distance ( level.player.origin, door.origin ) < 160 )
		wait .1;
	
	if ( isdefined ( beehive_enemy_second_door ) )
		{
			array_thread( beehive_enemy_second_door, ::spawn_ai );
		}
	
	door rotateto( door.angles + (0,angle,0), .5, 0, 0 );
	door connectpaths();
	door playsound ( "icbm_door_slams_open" );
}

beehive2_wait()
{
	level endon ( "outside_dead" );
	flag_wait ( "_stealth_spotted" );
	
	flag_set ( "beehive2_active" );
	thread beehive2_attack();
}

beehive2_think()
{
	self endon ( "death" );
	self.goalradius = 4;	
	
	if (! isdefined ( self.script_noteworthy ) )
		return;
		
	if ( self.script_noteworthy == "door_dog_enemies" )
	{
		level waittill ( "dog_door_open" );
		self.goalradius = 3000;
	}
	
	if ( self.script_noteworthy == "beehive2_enemies" )
	{
		level waittill ( "beehive2_door_open" );
		self.goalradius = 3000;
	}
}

beehive2_attack()
{
	beehive2_enemy = getentarray( "beehive2_enemy", "targetname" );
	array_thread( beehive2_enemy, ::add_spawn_function, ::beehive2_think );
	array_thread( beehive2_enemy, ::spawn_ai );
	
		
	wait 4;
	
	level notify ( "beehive2_door_open" );
	first_door = getEnt( "beehive2_front_door", "targetname" );
	first_door rotateto( first_door.angles + (0,-92,0), .5, 0, 0 );
	first_door connectpaths();
	first_door playsound ( "icbm_door_slams_open" );
	
	wait 1;
	
	level notify ( "dog_door_open" );
	dog_door = getEnt( "beehive1_front_door", "targetname" );
	dog_door rotateto( dog_door.angles + (0,-87,0), .5, 0, 0 );
	dog_door connectpaths();
	dog_door playsound ( "icbm_door_slams_open" );
}

price_gets_ready_to_open_door( anim_ent )
{
	anim_ent anim_reach_and_approach_solo( level.price, "hunted_open_barndoor" );
	anim_ent anim_single_solo( level.price, "hunted_open_barndoor_stop" );
	anim_ent thread anim_loop_solo( level.price, "hunted_open_barndoor_idle", undefined, "stop_idle" );
	flag_set ( "price_ready" );
}


price_opens_door( anim_ent, door, flag_msg )
{
	flag_wait ( "price_ready" );
	//anim_ent thread drawOriginForever();
	anim_ent notify( "stop_idle" );
	anim_ent thread anim_single_solo( level.price, "hunted_open_barndoor" );

	attachments = getentarray( door.target, "targetname" );
	for ( i = 0; i < attachments.size; i++ )
	{
		attachments[ i ] linkto( door );
	}
	door hunted_style_door_open();
	flag_clear ( "price_ready" );
	if ( isdefined ( flag_msg ) )
		flag_set ( flag_msg );
}


base_lights()
{

	// start windows on
	windows_on = getentarray( "windows_on", "targetname" );
	array_thread( windows_on, ::showWindow );
	// windows_off = getentarray( "windows_off", "targetname" );
	// array_thread( windows_off, ::hideWindow );
	
	// turns lights off
	flag_wait( "lights_off" );
	array_thread( windows_on, ::hideWindow );
	// array_thread( windows_off, ::showWindow );
	
	// turns lights on
	flag_wait( "lights_on" );
	array_thread( windows_on, ::showWindow );
	// array_thread( windows_off, ::hideWindow );

}

base_fx_on()
{
	ents = getstructarray( "icbm_post_FX_origin", "targetname" );
	assert( ents.size > 0 );
	
	lightStartTime_Min = 0.05;
	lightStartTime_Max = 1.5;
	
	for ( i = 0 ; i < ents.size ; i++ )
		ents[ i ] thread base_fx_light( randomfloatrange( lightStartTime_Min, lightStartTime_Max ) );
		
	flag_wait( "lights_on" );
	
	for ( i = 0 ; i < ents.size ; i++ )
		ents[ i ] thread base_fx_light( randomfloatrange( lightStartTime_Min, lightStartTime_Max ) );
}

base_fx_light( startDelay )
{
	wait startDelay;
	
	fxEnt = spawn( "script_model", self.origin );
	fxEnt setModel( "tag_origin" );
	
	playfxontag( level._effect[ "icbm_post_light_red" ], fxEnt, "tag_origin" );
	
	flag_wait( "lights_off" );
	
	fxEnt delete();
}

hideWindow()
{
	self hide();
}

showWindow()
{
	wait randomfloatrange( 0.05, 1.5 );
	
	flickers = randomint( 3 );
	for ( i = 0 ; i < flickers ; i++ )
	{
		self show();
		wait randomfloatrange( 0.05, 0.2 );
		self hide();
		wait randomfloatrange( 0.05, 0.2 );
	}
	
	
	self show();
}

tower_earthquakes()
{
	//Earthquake( <scale>, <duration>, <source>, <radius> )
	earthquake( 0.2, .5, level.player.origin, 8000);
	wait 4;
	
	earthquake( 0.2, 1, level.player.origin, 8000);
	wait 5;
	
	earthquake( .4, 3, level.player.origin, 8000);
}

tower_legBreak_fx( tower )
{
	playfxontag( getfx( "powerTower_leg" ), tower, "tag_foot_left" );
	tower_base_left = getent( "tower_base_left", "targetname" );
	thread playsoundinspace( "scn_icbm_tower_base1", tower_base_left.origin );
	wait .1;
	playfxontag( getfx( "powerTower_leg" ), tower, "tag_foot_right" );
	tower_base_right = getent( "tower_base_right", "targetname" );
	thread playsoundinspace( "scn_icbm_tower_base2", tower_base_right.origin );
}

tower_collapse()
{
	flag_wait ( "house1_cleared" );
	tower = getent( "tower", "targetname" );
	tower assign_animtree( "tower" );
	
	num_wires = 12;
	
	wireModelNames = [];
	wireModelNames[ 0 ] = "wire_l1";
	wireModelNames[ 1 ] = "wire_le2";
	wireModelNames[ 2 ] = "wire_le3";	
	wireModelNames[ 3 ] = "wire_ri1";
	wireModelNames[ 4 ] = "wire_ri2";
	wireModelNames[ 5 ] = "wire_ri3";			
	wireModelNames[ 6 ] = "wire_le4";
	wireModelNames[ 7 ] = "wire_le5";
	wireModelNames[ 8 ] = "wire_le6";	
	wireModelNames[ 9 ] = "wire_ri4";
	wireModelNames[ 10 ] = "wire_ri5";
	wireModelNames[ 11 ] = "wire_ri6";		
	
	wires = [];
	for ( i = 0; i < num_wires; i++ )
	{
		modelName = wireModelNames[ i ];
		wires[ i ] = getent( modelName, "targetname" );
		wires[ i ] assign_animtree( "wire" );
	}

	reference = spawn( "script_origin", ( 0, 0, 0 ) );
	reference.origin = tower.origin;
	reference.angles = tower.angles + ( 0, -90, 0 );

	for ( i = 0; i < num_wires; i++ )
	{
		reference thread anim_loop_solo( wires[ i ], "idle" + i, undefined, "stop_idle" );
	}


	flag_wait( "tower_destroyed" );
	reference notify( "stop_idle" );
	
	tower setmodel( "com_powerline_tower_destroyed" );
	reference thread anim_single_solo( tower, "explosion" );
		
	for ( i = 0; i < num_wires; i++ )
	{
		reference thread anim_single_solo( wires[ i ], "explosion" + i );
	}

	
	radiusDamage( tower.origin + ( 0, 0, 96 ), level.towerBlastRadius, 1000, 50 );
}


tower_impact_fx( tower )
{
	exploder( 5 );
}

tower_spark_fx( tower )
{
	thread playsoundinspace( "scn_icbm_tower_sparks", tower.origin + (0,0,512) );
	playfxontag( getfx( "powerTower_spark_exp" ), tower, "tag_fx_electric_left03" );
	playfxontag( getfx( "powerTower_spark_exp" ), tower, "tag_fx_electric_right03" );
	wait .1;
	playfxontag( getfx( "powerTower_spark_exp" ), tower, "tag_fx_electric_right02" );
	playfxontag( getfx( "powerTower_spark_exp" ), tower, "tag_fx_electric_left02" );
	wait .1;
	playfxontag( getfx( "powerTower_spark_exp" ), tower, "tag_fx_electric_left01" );
	playfxontag( getfx( "powerTower_spark_exp" ), tower, "tag_fx_electric_right01" );

	//thread playsoundinspace( "scn_icbm_tower_wire_snap", tower.origin + (0,0,512) );
}

spraycan_fx( gaz )
{
	level endon( "stop_spray_fx" );
	level endon( "death" );
	while ( true )
	{
		playfxontag( getfx( "freezespray" ), gaz, "tag_spraycan_fx" );
		wait .1;	
	}
}

spraycan_fx_stop( gaz )
{
	level notify( "stop_spray_fx" );
}

//* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * **// 
// 		  UTILITIES								// 
//* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * **// 

//delete_original_ai_spawns()
//{
//	allies = getaiarray( "allies" );
//	for ( i = 0; i < allies.size; i++ )
//	{
//		allies[ i ] delete();
//	}
//}
//
//init_ally()
//{
//	self.pacifist = true;
//	self enable_cqbwalk();
//	self setthreatbiasgroup( "allies" );
//	self set_force_color( "b" );
//	
//	if ( self.script_noteworthy == "buddies_spawner" )
//		self.script_noteworthy = "buddies";
//}
//
//
//
//
//
//beehive()
//{
//	// POKE THE BEEHIVE
//	trigger = getent( "beehive01_dmg", "targetname" );
//	assertex( isDefined( trigger ), "beehive01_dmg trigger not found" );
//	trigger waittill( "trigger" );
//	wait 2;
//	flag_set( "sound alarm" );
//}	
//
//reinforcements()
//{
//
//	// Spawn extra men, sortie script( go here, wait, then target player )
//	// need to play door open anim
//	flag_wait( "sound alarm" );
//
//	iprintlnbold( "ALARM SOUNDED!!" );
//	wait 2;
//	battlechatter_on( "axis" );
//	spawners = getentarray( "beehive_badguys", "script_noteworthy" );
//	array_thread( spawners, ::spawn_beehive_guys );
//	
//	wait 2;
//
//	door = getent( "beehive1_front_door", "targetname" );
//	door rotateto( door.angles + ( 0, -110, 0 ), .5, 0, .3 );
//	door connectpaths();
//		
//	wait 1.75;
//
//	door = getent( "beehive2_front_door", "targetname" );
//	door rotateto( door.angles + ( 0, -110, 0 ), .5, 0, .3 );
//	door connectpaths();
//	
//	allies = getaiarray( "allies" );
//	for ( i = 0; i < allies.size; i++ )
//	{
//		allies[ i ].pacifist = false;
//		allies[ i ] disable_cqbwalk();
//		allies[ i ] setthreatbiasgroup( "fight" );
//	}
//	battlechatter_on( "allies" );
//							
//}
//
//
//
//set_goalnode( node, range )
//{
//       self endon( "death" );
//       self notify( "abort_chain" );
//
//       assert( isdefined( node ) );
//       if ( isdefined( range ) )
//       {
//               assert( range >= 0.1 );
//               wait randomfloatrange( 0.1, range );
//       }
//       if ( isdefined( node.radius ) )
//               self.goalradius = node.radius;
//       if ( isalive( self ) )
//               self setgoalnode( node );
//}
//
//
//setgoalentityforbuddies( target )
//{
//      // COUNT UP BUDDIES
//       for ( i = 0;i < level.buddies.size;i++ )
//       {
//               if ( isalive( level.buddies[ i ] ) )
//                       level.buddies[ i ] setgoalentity( target );
//       }
//}
//
//setgoalforbuddies( goal )
//{
//      // COUNT UP BUDDIES
//       for ( i = 0;i < level.buddies.size;i++ )
//       {
//               if ( isalive( level.buddies[ i ] ) )
//               {
//                       level.buddies[ i ] setgoalnode( goal );
//                       level.buddies[ i ].goalradius = goal.radius;
//
//               }
//       }
// 
//}
//
//magic_buddies()
//{
//	
//   	// COUNT UP BUDDIES
//	level.buddies = getentarray( "buddies", "script_noteworthy" );
//       
//  	for ( i = 0;i < level.buddies.size;i++ )
//    {
//               if ( isalive( level.buddies[ i ] ) )
//               {
//				level.buddies[ i ] thread magic_bullet_shield();
//				level.buddies[ i ].animname = "generic";
//               }
//    }
//
//
//}
//
//selfdospawn()
//{
//
//	self dospawn();
//
//}
//
//spawn_beehive_guys()
//{
//
//	beehive_spawn = self dospawn();	
//	if ( spawn_failed( beehive_spawn ) )
//		return;	
//	beehive_spawn.pacifist = false;
//	beehive_spawn disable_cqbwalk();
//	beehive_spawn.goalradius = 1024;
//	beehive_spawn.goalheight = 512;
//	beehive_spawn.fightdist = 0;
//	beehive_spawn.maxdist = 0;
//	beehive_radius = getnode( "beehive_radius", "targetname" );	
//	beehive_spawn setGoalNode( beehive_radius );
//		
//			
//
//}
//
//stopIgnoringPlayerWhenShot()
//{
//   	self endon( "death" );
//   	self waittill_any( "bulletwhizby", "suppression", "enemy" );
//   	// level.player anim_single_queue( level.player, "contact" );
//   	wait 5;
//   	flag_set( "sound alarm" );
//}
//
//unawareBehavior()
//{
//   	self endon( "death" );
//   	self endon( "end_unaware_behavior" );
//   	
//   	self.lastFoughtTime = -9999999;
//   	
//   	self.preUnawareBehaviorSightDistSqrd = self.maxSightDistSqrd;
//   	self.maxSightDistSqrd = 600 * 600;
//	
//	otherteam = "allies";
//	if ( self.team == "allies" )
//		otherteam = "axis";
//	
//	while ( 1 )
//	{
//		self.pacifist = true;
//		debugUnawareBehavior( "unaware of enemy" );
//		
//		// wait until we see an enemy
//		self waitUntilAwareOfEnemy();
//		
//		// we've seen someone!
//		debugUnawareBehavior( "i think i see an enemy! waiting..." );
//		self.pacifist = false;
//		
//		// alert our friends.
//		debugUnawareBehavior( "telling friends about enemies while i fight" );
//		self thread alertFriendsAboutEnemies();
//		self waitUntilHaventFoughtForAwhile ();
//		self notify( "stop_alerting_friends_about_enemies" );
//	}
//}
//
//endUnawareBehavior()
//{
//	self notify( "end_unaware_behavior" );
//	self.pacifist = false;
//	self.maxSightDistSqrd = self.preUnawareBehaviorSightDistSqrd;
//	self detach_flashlight();
//}
//
//waitUntilAwareOfEnemy()
//{
//	self endon( "find_out_about_enemies" );
//	self endon( "bulletwhizby" );
//	self endon( "suppression" );
//	
//	otherteam = "allies";
//	if ( self.team == "allies" )
//		otherteam = "axis";
//	
//	seeEnemyDist = 400;
//	if ( self.team == "allies" )
//		seeEnemyDist = 512;
//	
//	// todo:
//	// break out if someone shoots a non - silenced weapon
//	
//	while ( 1 )
//	{
//		if ( !self.pacifist )
//			break;
//		if ( isdefined( self.grenade ) )
//			break;
//		
//		sawSomeone = false;
//		
//		potentialEnemies = getaiarray( otherteam );
//		if ( level.player.team == otherteam )
//			potentialEnemies[ potentialEnemies.size ] = level.player;
//		for ( i = 0; i < potentialEnemies.size; i++ )
//		{
//			if ( distance( potentialEnemies[ i ].origin, self.origin ) > seeEnemyDist )
//				continue;
//			
//			if ( !sightTracePassed( self geteye(), potentialEnemies[ i ] getShootAtPos(), false, undefined ) )
//				continue;
//			
//			sawSomeone = true;
//			break;
//		}
//		
//		if ( sawSomeone )
//			break;
//			
//		wait .3;		
//	}
//}
//
//alertFriendsAboutEnemies()
//{
//	self endon( "death" );
//	self endon( "stop_alerting_friends_about_enemies" );
//
//	wait randomFloatRange( 0.8, 1.2 );
//	
//	// if we're not actually fighting, don't alert other friendlies
//	while ( self.lastFoughtTime < gettime() - 1000 )
//		wait .3;
//	
//	while ( 1 )
//	{
//		others = getaiarray( self.team );
//		// if I'm axis, I don't have a silenced weapon
//		if ( self.team == "axis" )
//			others = getaiarray();
//		
//		for ( i = 0; i < others.size; i++ )
//		{
//			if ( others[ i ] == self )
//				continue;
//			
//			if ( distance( others[ i ].origin, self.origin ) > 512 )
//				continue;
//
//			if ( !sightTracePassed( self geteye(), others[ i ] geteye(), false, undefined ) )
//				continue;
//
//			others[ i ] notify( "find_out_about_enemies" );
//		}
//		
//		wait .3;
//	}
//}
//
//waitUntilHaventFoughtForAwhile ()
//{
//	forgetTime = 2;
//	
//	self.lastFoughtTime = gettime();
//	
//	while ( 1 )
//	{
//		amFighting = false;
//		if ( isdefined( self.enemy ) && sightTracePassed( self geteye(), self.enemy getShootAtPos(), false, undefined ) )
//			amFighting = true;
//		
//		if ( amFighting )
//		{
//			self.lastFoughtTime = gettime();
//		}
//		else
//		{
//			if ( gettime() - self.lastFoughtTime > forgetTime * 1000 )
//				break;
//		}
//		
//		wait .03;
//	}
//}
//
//debugUnawareBehavior( text )
//{
//	 /#
//	self notify( "stop_debugging_unaware" );
//	
//	if ( getdebugdvar( "scr_unaware" ) != "on" )
//		return;
//	
//	self thread debugUnawareProx( text );
//	#/ 
//}
//
// /#
//debugUnawareProx( text )
//{
//	self endon( "death" );
//	self endon( "stop_debugging_unaware" );
//	self endon( "end_unaware_behavior" );
//	
//	while ( 1 )
//	{
//		print3d( self.origin + ( 0, 0, 60 ), text );
//		foughttime = ( gettime() - self.lastFoughtTime ) / 1000;
//		print3d( self.origin + ( 0, 0, 40 ), "last fought " + foughttime + " seconds ago" );
//		
//		wait .05;
//	}
//}
//#/ 
//
//setup_sortie()
//{
//    aSpawner = getentarray( "sortie", "script_noteworthy" );
//    level array_thread( aSpawner, ::sortie ); }
//
//sortie()
//{
//    while ( true )
//    {
//        self waittill( "spawned", ai );
//        ai thread sortie_wait( self.script_wait, self.script_waittill );
//    }
//}
//
//sortie_wait( waittime, waitstring )
//{
//    self endon( "death" );
//    self endon( "escape your doom" );
//
//    if ( isdefined( waitstring ) )
//        level waittill( waitstring );
//    else
//        self waittill( "goal" );
//    if ( isdefined( waittime ) )
//        wait randomfloatrange( waittime, waittime + 4 );
//
//    println( "sortie " + self getentitynumber() );
//
//    self setgoalentity( level.player );
//    self.goalradius = 1536;
//}
//
//vehicle_c4_think()
//{
//
//	iEntityNumber = self getentitynumber();	
//	self thread vehicle_death( iEntityNumber );
//	self maps\_c4::c4_location( "rear_hatch_open_jnt_left", ( 0, -33, 10 ), ( 0, 90, -90 ) );
//	self maps\_c4::c4_location( "tag_origin", ( 129, 0, 35 ), ( 0, 90, 144 ) );
//	
//	self waittill( "c4_detonation" );
//
//	/* -- -- -- -- -- -- -- -- -- -- -- - 
//	C4 STUNS AI CLOSEBY
//	 -- -- -- -- -- -- -- -- -- -- -- -- -*/ 			
//	
//	self notify( "death" );
//}
//
//vehicle_death( iEntityNumber )
//{
//	self waittill( "death" );
//
//	AI = get_ai_within_radius( 512, self.origin, "axis" );
//	if ( ( isdefined( AI ) ) && ( AI.size > 0 ) )
//		array_thread( AI, ::AI_stun, .75 );
//
//	self notify( "clear_c4" );
//	setplayerignoreradiusdamage( true );
//	
//	/* -- -- -- -- -- -- -- -- -- -- -- - 
//	SECONDARY EXPLOSIONS
//	 -- -- -- -- -- -- -- -- -- -- -- -- -*/ 		
//
//	// 	wait( randomfloatrange( 0.5, 1 ) );
//	// 	thread play_sound_in_space( "explo_metal_rand", self.origin );
//	// 	playfxontag( level._effect[ "c4_secondary_explosion_01" ], self, sC4tag );
//	// 	radiusdamage( self.origin, 128, level.maxBMPexplosionDmg, level.minBMPexplosionDmg );
//	// 
//	// 	wait( randomfloatrange( 1, 1.5 ) );
//	// 	thread play_sound_in_space( "explo_metal_rand", self gettagorigin( "tag_turret" ) );
//	// 	playfxontag( level._effect[ "c4_secondary_explosion_02" ], self, "tag_turret" );
//	// 	radiusdamage( self.origin, 128, level.maxBMPexplosionDmg, level.minBMPexplosionDmg );
//	// 	wait( randomfloatrange( 0.55, .75 ) );
//	
//	/* -- -- -- -- -- -- -- -- -- -- -- - 
//	FINAL EXPLOSION
//	 -- -- -- -- -- -- -- -- -- -- -- -- -*/ 		
//	earthquake( 0.6, 2, self.origin, 2000 );	
//	thread play_sound_in_space( "exp_armor_vehicle", self gettagorigin( "tag_turret" ) );
//	AI = get_ai_within_radius( 1024, self.origin, "axis" );
//	if ( ( isdefined( AI ) ) && ( AI.size > 0 ) )
//		array_thread( AI, ::AI_stun, .85 );
//
//	/* -- -- -- -- -- -- -- -- -- -- -- - 
//	ONLY TOKEN DAMAGE INFLICTED ON PLAYER
//	 -- -- -- -- -- -- -- -- -- -- -- -- -*/ 
//	radiusdamage( self.origin, 256, level.maxBMPexplosionDmg, level.minBMPexplosionDmg );
//	thread player_token_vehicle_damage( self.origin );
//	thread autosave_by_name( "bmp_" + iEntityNumber + "_destroyed" );	
//	
//	wait( 2 );
//	setplayerignoreradiusdamage( false );
//}
//
//player_token_vehicle_damage( org )
//{
//	if ( distancesquared( org, level.player.origin ) <= level.playerVehicleDamageRangeSquared )
//		level.player dodamage( level.player.health / 3, ( 0, 0, 0 ) );
//}
//AI_stun( fAmount )
//{
//	self endon( "death" );
//	if ( ( isdefined( self ) ) && ( isalive( self ) ) && ( self getFlashBangedStrength() == 0 ) )
//		self setFlashBanged( true, fAmount );
//}
//
//get_ai_within_radius( fRadius, org, sTeam )
//{
//	if ( isdefined( sTeam ) )
//		ai = getaiarray( sTeam );
//	else
//		ai = getaiarray();
//	
//	aDudes = [];
//	for ( i = 0;i < ai.size;i++ )
//	{
//		if ( distance( org, self.origin ) <= fRadius )
//			array_add( aDudes, ai[ i ] );
//	}
//	return aDudes;
//}


//vehicle_get_target( aExcluders )
//{
//	eTarget = maps\_helicopter_globals::getEnemyTarget( level.bmpCannonRange, level.cosine[ "180" ], true, true, false, false, aExcluders );
//	return eTarget;
//}
//
//
//vehicle_turret_think()
//{
//	self endon( "death" );
//	self endon( "c4_detonation" );
//	self thread maps\_vehicle::mgoff();
//	self.turretFiring = false;
//	eTarget = undefined;
//	aExcluders = [];
//
//	aExcluders[ 0 ] = level.price;
//	aExcluders[ 1 ] = level.griggs;
//
//
//	currentTargetLoc = undefined;
//
//	
//	// if ( getdvar( "debug_bmp" ) == "1" )
//		// self thread vehicle_debug();
//
//	while ( true )
//	{
//		wait( 0.05 );
//		/* -- -- -- -- -- -- -- -- -- -- -- - 
//		GET A NEW TARGET UNLESS CURRENT ONE IS PLAYER
//		 -- -- -- -- -- -- -- -- -- -- -- -- -*/ 		
//		if ( ( isdefined( eTarget ) ) && ( eTarget == level.player ) )
//		{
//			sightTracePassed = false;
//			sightTracePassed = sighttracepassed( self.origin, level.player.origin + ( 0, 0, 150 ), false, self );
//			if ( !sightTracePassed )
//			{
//				// self clearTurretTarget();
//				eTarget = self vehicle_get_target( aExcluders );
//			}
//				
//		}
//		else
//			eTarget = self vehicle_get_target( aExcluders );
//
//		/* -- -- -- -- -- -- -- -- -- -- -- - 
//		ROTATE TURRET TO CURRENT TARGET
//		 -- -- -- -- -- -- -- -- -- -- -- -- -*/ 		
//		if ( ( isdefined( eTarget ) ) && ( isalive( eTarget ) ) )
//		{
//			targetLoc = eTarget.origin + ( 0, 0, 32 );
//			self setTurretTargetVec( targetLoc );
//			
//			
//			if ( getdvar( "debug_bmp" ) == "1" )
//				thread draw_line_until_notify( self.origin + ( 0, 0, 32 ), targetLoc, 1, 0, 0, self, "stop_drawing_line" );
//			
//			fRand = ( randomfloatrange( 2, 3 ) );
//			self waittill_notify_or_timeout( "turret_rotate_stopped", fRand );
//
//			/* -- -- -- -- -- -- -- -- -- -- -- - 
//			FIRE MAIN CANNON OR MG
//			 -- -- -- -- -- -- -- -- -- -- -- -- -*/ 
//			if ( ( isdefined( eTarget ) ) && ( isalive( eTarget ) ) )
//			{
//				if ( distancesquared( eTarget.origin, self.origin ) <= level.bmpMGrangeSquared )
//				{
//					if ( !self.mgturret[ 0 ] isfiringturret() )
//						self thread maps\_vehicle::mgon();
//					
//					wait( .5 );
//					if ( !self.mgturret[ 0 ] isfiringturret() )
//					{
//						self thread maps\_vehicle::mgoff();
//						if ( !self.turretFiring )
//							self thread vehicle_fire_main_cannon();			
//					}
//	
//				}
//				else
//				{
//					self thread maps\_vehicle::mgoff();
//					if ( !self.turretFiring )
//						self thread vehicle_fire_main_cannon();	
//				}				
//			}
//
//		}
//		
//		// wait( randomfloatrange( 2, 5 ) );
//	
//		if ( getdvar( "debug_bmp" ) == "1" )
//			self notify( "stop_drawing_line" );
//	}
//}
//
//vehicle_fire_main_cannon()
//{
//	self endon( "death" );
//	self endon( "c4_detonation" );
//	// self notify( "firing_cannon" );
//	// self endon( "firing_cannon" );
//	
//	iFireTime = weaponfiretime( "bmp_turret" );
//	assert( isdefined( iFireTime ) );
//	
//	iBurstNumber = randomintrange( 3, 8 );
//	
//	self.turretFiring = true;
//	i = 0;
//	while ( i < iBurstNumber )
//	{
//		i++ ;
//		wait( iFireTime );
//		self fireWeapon();
//	}
//	self.turretFiring = false;
//}




playSoundinSpace (alias, origin, master)
{
	org = spawn ("script_origin",(0,0,1));
	if (!isdefined (origin))
		origin = self.origin;
	org.origin = origin;
	if (isdefined(master) && master)
		org playsoundasmaster (alias);
	else
		org playsound (alias);
	wait ( 10.0 );
	org delete();
}



//#using_animtree( "generic_human" );
//spawnerThink( ent )
//{
//	self endon( "death" );
//	self waittill( "spawned", spawn );
//	ent.guys[ ent.guys.size ] = spawn;
//	ent notify( "spawned_guy" );
//}
//

tower_interface()
{
	level endon( "tower_destroyed" );
	
	while ( !flag( "tower_destroyed" ) )
	{
		weapon = level.player getcurrentweapon();
		
		if ( weapon != "c4" )
			level.player switchtoweapon( "c4" );
			
		wait 0.5;
	}
}

set_threatbias_group( group )
{
	assert( threatbiasgroupexists( group ) );
	self setthreatbiasgroup( group );
}

kill_enemies()
{
	enemies = getaiarray ( "axis" );
	for( i = 0 ; i < enemies.size ; i++ )
		enemies[ i ] dodamage( enemies[ i ].health + 100 , enemies[ i ].origin );
}

anim_reach_and_approach_solo_set_flag( guy, animname, flagname )
{
	self anim_reach_and_approach_solo( guy, animname );
	flag_set( flagname );
}


missile_launch01()
{
	missile01_start = getent( "missile01_start", "targetname" );
	missile01_end = getent( "missile01_end", "targetname" );
	icbm_missile01 = getent( "icbm_missile01", "targetname" );
	flag_wait( "launch_01" );	
	// FIRE!!
	exploder( 1 );
	
	//Earthquake( <scale>, <duration>, <source>, <radius> )
	earthquake( 0.1, 8, level.player.origin, 8000);
	
	icbm_missile01 linkto( missile01_start );
	missile01_start moveto( missile01_end.origin, 50, 10, 0 );	
	// icbm_missile thread maps\_utility::playSoundOnTag( "parachute_land_player" );
	playfxontag( level._effect[ "smoke_geotrail_icbm" ], icbm_missile01, "tag_nozzle" );
	missile01_start waittill( "movedone" );
	icbm_missile01 delete();
}

missile_launch02()
{
	missile02_start = getent( "missile02_start", "targetname" );
	missile02_end = getent( "missile02_end", "targetname" );
	icbm_missile02 = getent( "icbm_missile02", "targetname" );
	flag_wait( "launch_02" );
	wait 1.5;	
	// FIRE!!
	exploder( 2 );
	
	//Earthquake( <scale>, <duration>, <source>, <radius> )
	earthquake( 0.1, 8, level.player.origin, 8000);
	
	icbm_missile02 linkto( missile02_start );
	missile02_start moveto( missile02_end.origin, 50, 10, 0 );	
	// icbm_missile thread maps\_utility::playSoundOnTag( "parachute_land_player" );
	playfxontag( level._effect[ "smoke_geotrail_icbm" ], icbm_missile02, "tag_nozzle" );
	missile02_start waittill( "movedone" );
	icbm_missile02 delete();
}

LaunchVision()
{
	set_vision_set( "icbm_launch", 4 );	
	wait 10;
	set_vision_set( "icbm_sunrise4", 6 );
}


woods_patroller_think()
{
	patrol = [];
	patrol[ patrol.size ] =  "patrolwalk_1";
	patrol[ patrol.size ] =  "patrolwalk_2";
	patrol[ patrol.size ] =  "patrolwalk_3";
	patrol[ patrol.size ] =  "patrolwalk_4";
	patrol[ patrol.size ] =  "patrolwalk_5";
	
	self.patrol_walk_twitch = "patrolwalk_pause";
	
	self.patrol_walk_anim = patrol[ randomint ( patrol.size ) ];
	self thread maps\_patrol::patrol();
	
	wait .05;
	
	self maps\_stealth_behavior::ai_create_behavior_function( "animation", "wrapper", ::woods_animation_wrapper );
	self thread woods_keep_patroling();
}

woods_animation_wrapper( type )
{
	self endon( "death" );
	self endon( "pain_death" );
	
	if( !isdefined( level.woods_pause ) )
		level.woods_pause = 0;
	else
		level.woods_pause += .2;
			
	wait level.woods_pause;
	
	self notify( "drop_light" );
				
	// ALWAYS RUN THIS UNLESS YOU'RE SURE YOU KNOW WHAT YOU"RE DOING
	if ( self maps\_stealth_behavior::enemy_animation_pre_anim( type ) )
		return;	
	
	self maps\_stealth_behavior::enemy_animation_do_anim( type );
	
	// ALWAYS RUN THIS UNLESS YOU'RE SURE YOU KNOW WHAT YOU"RE DOING
	self maps\_stealth_behavior::enemy_animation_post_anim( type );
}

woods_keep_patroling()
{
	self endon( "death" );
	self endon( "drop_light" );

	while( 1 )
	{
		woods_keep_patrolling_wait();
		self thread maps\_patrol::patrol();
	}
}

woods_keep_patrolling_wait()
{
	self endon( "death" );
	self endon( "end_patrol" );
	level endon( "_stealth_spotted" );
	level endon( "_stealth_found_corpse" );
	
	self waittill( "enemy" );
}