#include common_scripts\utility;
#include maps\_utility;

main()
{
	maps\aftermath_fx::main();
	maps\createart\aftermath_art::main();

	// to make the introscreen not error out.
	level.start_point = "default";

	level.weaponClipModels = [];

	level.dontReviveHud = true;
	thread hud_hide();

	maps\_load::main();
	thread maps\aftermath_amb::main();

	level.scr_deadbody[ 1 ] = character\character_sp_usmc_james::main;
	level.scr_deadbody[ 2 ] = character\character_sp_usmc_ryan::main;
	level.scr_deadbody[ 3 ] = character\character_sp_usmc_zach::main;
	level.scr_deadbody[ 4 ] = character\character_sp_pilot_velinda_desert::main;
	

	maps\_deadbody::main();

	precacheshellshock( "slowview" );
	precacheshellshock( "aftermath" );
	precacheshellshock( "aftermath_fall" );

	precacheShader( "overlay_hunted_black" );
	precacheShader( "overlay_hunted_white" );

	precachemodel( "com_airduct_square" );

	flag_init( "awake" );
	flag_init( "fall" );
	flag_init( "collapse" );
	flag_init( "collapse_done" );
	flag_trigger_init( "radiation_death", getent( "death_point", "targetname" ) );

	level.allow_fall = true;

	setup_force_fall();
	level.player_speed = 50;

	level.ground_ref_ent = spawn( "script_model", (0,0,0) );
	level.player playerSetGroundReferenceEnt( level.ground_ref_ent );

	level.player thread player_speed_over_time();
	level.player thread player_heartbeat();
//	level thread objective();
	level thread countdown_to_death();
	level.player thread radiation_death();

	level thread radio_chatter();

//	level.player allowjump( false );
	level.player allowsprint( false );

	level thread slowview();

	player_wakeup();

	level.player thread player_jump_punishment();

	level.player thread limp();
	level thread building_collapse();
	level thread playground();
}

playground()
{
//	trigger = spawn( "trigger_radius", ( -164, 9138, 670.692 ), 0, 420, 128 );
	trigger = getent( "playground", "targetname" );
	trigger waittill( "trigger" );

	play_sound_in_space( "playground_memory", trigger.origin );
}

slowview()
{
	while( true )
	{
		level waittill( "slowview", wait_time );
		if ( isdefined( wait_time ) )
			wait wait_time;
		thread restart_slowview();
		level.player shellshock( "slowview", 15);
	}
}

restart_slowview()
{
	level endon( "slowview" );
	wait 10;
	level notify( "slowview" );
}

radio_chatter()
{
	radio_origin = (-1144, 8506, 660.3);

	wait 4;

	play_sound_in_space( "aftermath_mmr_romeo", radio_origin );
	wait 3;
	play_sound_in_space( "aftermath_fmr_epicenter", radio_origin );
	play_sound_in_space( "aftermath_fmr_evacuation", radio_origin );
	play_sound_in_space( "aftermath_fmr_contcenters", radio_origin );
	play_sound_in_space( "aftermath_fmr_dosimeter", radio_origin );
	play_sound_in_space( "aftermath_fmr_elevatedlevels", radio_origin );
}

countdown_to_death()
{
	level endon( "dying" );

	trigger = getent( "outside", "targetname" );
	trigger wait_for_trigger_or_timeout( 50 );

	wait 30;

	if ( !flag( "collapse_done" ) )
	{
		raze = getent( "raze", "targetname" );
		raze notify( "trigger" );
		flag_wait_or_timeout( "collapse_done", 10 );
	}
	wait 15;

	flag_set( "radiation_death" );
}

objective()
{
	flag_wait( "awake" );

	wait 4;

	obj_origin = getent( "radiac_equipment", "targetname" );
	objective_add( 1, "active", &"AFTERMATH_OBJ_OFFICER", obj_origin.origin );
	objective_current( 1 );

	trigger = getent( "officer", "targetname" );
	trigger waittill( "trigger" );

/*
	fov = cos( 20 );
	while( !within_fov( level.player.origin, level.player getplayerangles(), obj_origin.origin, fov ) )
		wait 0.05;
*/
	objective_state( 1, "done" );

	level.player thread player_jump_punishment();
	wait 3;

	obj_origin = getent( "overhead_cover", "targetname" );
	objective_add( 2, "active", &"AFTERMATH_OBJ_SECURE_COVER", obj_origin.origin );
	objective_current( 2 );

	trigger = getent( "death_point", "targetname" );
	trigger waittill( "trigger" );

	fov = cos( 30 );

	while( !within_fov( level.player.origin, level.player getplayerangles(), obj_origin.origin, fov ) )
		wait 0.05;

	level.player radiation_death();
}

radiation_death()
{
	flag_wait( "radiation_death" );

	level notify( "dying" );
	thread hud_hide();

	level.player setstance( "prone" );
	setblur( 0, .5 );
	level.player freezeControls( true );

	level.player thread play_sound_on_entity( "bodyfall_gravel_large" );

	level.ground_ref_ent thread stumble( ( 20, 10, 30 ), .2, 1.5 );

	wait .2;
	set_vision_set( "aftermath_pain", 0 );

	level waittill( "recovered" );

	level.player PlayRumbleOnEntity( "grenade_rumble" );

	level.player allowstand( false );
	level.player allowcrouch( false );

	angles = adjust_angles_to_player( (0,0,-20) );
	level.ground_ref_ent rotateto( angles, 6, 3, 1 );

	wait 3;

	set_vision_set( "aftermath_glow", 6 );
	wait 3;

	level notify( "stop_heart" );
	wait 2;

	white_overlay = create_overlay_element( "overlay_hunted_white", 0 );
	white_overlay fadeOverTime( 3 );
	white_overlay.alpha = 1;

	wait 5;

	black_overlay = create_overlay_element( "black", 0 );
	black_overlay fadeOverTime( .1 );
	black_overlay.alpha = 1;
	wait 2;

	SetSavedDvar( "hud_showStance", 0 );
	nextmission();
}

building_collapse()
{
	getent( "raze", "targetname" ) waittill( "trigger" );
	center_ent = getent( "building_collapse", "targetname" );

	fov = cos( 45 );

	while( !within_fov( level.player.origin, level.player getplayerangles(), center_ent.origin + (0,0,-1000), fov ) )
		wait 0.05;

	flag_waitopen( "fall" );

	flag_set( "collapse" );
	level notify( "stop_stumble" );

	thread play_sound_in_space( "exp_building_collapse_dist", level.player.origin );

	building = getentarray( center_ent.target, "targetname" );
	array_thread( building, ::collapse, center_ent );

	center_ent moveto( center_ent.origin + (0,0,-3000), 7, 4, 0 );
	wait 0.5;
	exploder( 1 );
	
	angles = adjust_angles_to_player( (0,0,-20) );
	level.ground_ref_ent rotateto( angles, 2, 1, 1 );
	level.ground_ref_ent waittill( "rotatedone" );
	wait 1;
	level.ground_ref_ent rotateto( (0,0,0), 3, 1.5, 1.5 );

	wait 2;

	flag_clear( "collapse" );
	flag_set( "collapse_done" );
	level notify( "recovered" );

}

collapse( center_ent )
{
	last_dist = distance( center_ent.origin, self.origin );

	while ( distance( center_ent.origin, self.origin ) <= last_dist )
	{
		last_dist = distance( center_ent.origin, self.origin );
		wait 0.05;
	}

	if ( !isdefined( self.script_delay ) )
		self.script_delay = 0;
//	else
//		self.script_delay *= 4;

//	wait randomfloat( 0.1 ) + .8 - self.script_delay;
	wait randomfloat( 0.1 ) + self.script_delay;

	vector = vectornormalize( flat_origin( center_ent.origin ) - flat_origin( self.origin ) );
	rotation = vector_multiply( vector_switch( vectornormalize( vector ) ), randomintrange( 80, 100 ) );
	vector = random_vector( ( 1, 1, 0.1) );
	vector = vector_multiply( vector, randomintrange( 100, 150) );

	self rotatevelocity(  rotation, 2 , .2 ,0 );
	self movegravity( vector, 2 );

	wait 2;
	self delete();
}

vector_switch( vector )
{
	return ( vector[0], vector[2], vector[1] * -1 );
}

random_vector( max )
{
	return ( (randomfloat(2)-1) * max[0], (randomfloat(2)-1) * max[1], (randomfloat(2)-1) * max[2] );
}

player_speed_over_time()
{
//	setsaveddvar( "aim_turnrate_yaw", 50 );

	while( true )
	{
		level.player setMoveSpeedScale( level.player_speed/190 );
		wait 10;
		level.player_speed--;
		if ( level.player_speed < 30 )
			return;
	}
}

player_heartbeat()
{
	level endon( "stop_heart" );

	wait 3;
	while( true )
	{
		if ( !flag( "fall" ) )
		{
			level.player thread play_sound_on_entity( "breathing_heartbeat" );
			wait 0.05;
			level.player PlayRumbleOnEntity( "damage_light" );
			wait .8;
		}		

		wait ( 0 + randomfloat (0.1) );

		if ( randomint(50) > level.player_speed )
			wait randomfloat(1);
	}
}

player_wakeup()
{
	set_vision_set( "aftermath_glow", 0 );
	level.player setstance( "prone" );

	level.player shellshock( "aftermath", 18);
	level notify( "slowview" );

	level.player disableweapons();
	level.player freezeControls( true );
	level.player allowstand( false );
	level.player allowcrouch( false );

	player_origin = ( -989, 8433, 666 );
	player_angles = ( -18, 25, 0 );

	level.player setorigin( player_origin );
	level.player setplayerangles( player_angles );

	black_overlay = create_overlay_element( "overlay_hunted_black", 1 );
	wait 5;

	wait .5;

	black_overlay fadeOverTime( 12 );
	black_overlay.alpha = 0;

	wait 1;

	level.player freezeControls( false );

	wait 7;

	level.player play_sound_on_entity( "sprint_gasp" );
	wait .5;
	thread recover();
	level.player play_sound_on_entity( "breathing_hurt_start" );
	level.player thread play_sound_on_entity( "breathing_better" );

	setsaveddvar( "cg_footsteps", 0 );

//	level.player freezeControls( false );
	level.player setstance( "prone" );
	wait 2;
	level.player allowcrouch( true );

	flag_set( "awake" );

	set_vision_set( "aftermath", 10 );
	wait 10;
	level.player allowstand( true );

	black_overlay destroy();
}

adjust_angles_to_player( stumble_angles )
{
		pa = stumble_angles[0];
		ra = stumble_angles[2];

		rv = anglestoright( level.player.angles );
		fv = anglestoforward( level.player.angles );

		rva = ( rv[0], 0, rv[1]*-1 );
		fva = ( fv[0], 0, fv[1]*-1 );
		angles = vector_multiply( rva, pa );
		angles = angles + vector_multiply( fva, ra );
		return angles + ( 0, stumble_angles[1], 0 );
}

limp()
{
	level.player thread player_random_blur();

	stumble = 0;
	alt = 0;

	while( true )
	{
		velocity = level.player getvelocity();
		player_speed = abs(velocity [0]) + abs(velocity[1]);

		if ( player_speed < 10 )
		{
			wait 0.05;
			continue;
		}

		speed_multiplier = player_speed / level.player_speed;

		p = randomfloatrange( 3, 5 );
		if ( randomint(100) < 20 ) 
			p *= 3;
		r = randomfloatrange( 3, 7 );
		y = randomfloatrange( -8, -2 );

		stumble_angles = ( p, y, r );
		stumble_angles = vector_multiply( stumble_angles, speed_multiplier );
	
		stumble_time = randomfloatrange( .35, .45 );
		recover_time = randomfloatrange( .65, .8 );

		stumble++;
		if ( speed_multiplier > 1.3 )
			stumble++;

		thread stumble( stumble_angles, stumble_time, recover_time );

		level waittill( "recovered" );
	}
}

player_random_blur()
{
	level endon( "dying" );

	while( true )
	{
		wait 0.05;
		if ( randomint(100) > 10 )
			continue;

		blur = randomint(3)+2;
		blur_time = randomfloatrange( 0.3, 0.7 );
		recovery_time = randomfloatrange( 0.3, 1 );
		setblur( blur * 1.2, blur_time );
		wait blur_time;
		setblur( 0, recovery_time );
		wait 5;

	}	
}

player_jump_punishment()
{
	wait 1;
	while( true )
	{
		wait 0.05;
		if ( level.player isonground() )
			continue;
		wait 0.2;
		if ( level.player isonground() )
			continue;

		level notify( "stop_stumble" );
		wait 0.2;
		level.player fall();
	}
}

setup_force_fall()
{
	trigger = getentarray( "force_fall", "targetname" );
	array_thread( trigger, ::force_fall );
}

force_fall()
{
	self waittill( "trigger" );
	level.player fall();
}

fall()
{
	level endon( "stop_stumble" );

	if ( !level.allow_fall )
		return;

	flag_set( "fall" );

	level.player setstance( "prone" );

	level.player thread play_sound_on_entity( "bodyfall_gravel_large" );

	level.ground_ref_ent thread stumble( ( 20, 10, 30 ), .2, 1.5, true );

	wait .2;
	set_vision_set( "aftermath_pain", 0 );

	level.player PlayRumbleOnEntity( "grenade_rumble" );

	level.player allowstand( false );
	level.player allowcrouch( false );
	level.player viewkick( 127, level.player.origin );
	level.player shellshock( "aftermath_fall", 3);
	level notify( "slowview", 3.5 );

//	level.player PlayRumbleloopOnEntity( "damage_heavy" );

	wait 1.5;
	flag_set( "fall" );

	thread recover();

	level.player play_sound_in_space( "sprint_gasp" );
	level.player play_sound_in_space( "breathing_hurt_start" );
	level.player play_sound_in_space( "breathing_better" );

	set_vision_set( "aftermath", 5 );

	level.player play_sound_on_entity( "breathing_better" );

	flag_clear( "fall" );

	level.player allowstand( true );
	level.player allowcrouch( true );
	level notify( "recovered" );

}

stumble( stumble_angles, stumble_time, recover_time, no_notify)
{
	level endon( "stop_stumble" );

	if ( flag( "collapse" ) )
		return;

	stumble_angles = adjust_angles_to_player( stumble_angles );

	level.ground_ref_ent rotateto( stumble_angles, stumble_time, (stumble_time/4*3), (stumble_time/4) );
	level.ground_ref_ent waittill( "rotatedone" );

//	if ( level.player getstance() == "stand" )
//		level.player PlayRumbleOnEntity( "damage_light" );

	base_angles = ( randomfloat(4)-4, randomfloat(5), 0 );
	base_angles = adjust_angles_to_player( base_angles );

	level.ground_ref_ent rotateto( base_angles, recover_time, 0, recover_time/2 );
	level.ground_ref_ent waittill( "rotatedone" );

 	if ( !isdefined( no_notify ) )
		level notify( "recovered" );
}

recover()
{
	angles = adjust_angles_to_player( (-5,-5,0) );
	level.ground_ref_ent rotateto( angles, .6, 0.6, 0 );
	level.ground_ref_ent waittill( "rotatedone" );

	angles = adjust_angles_to_player( (-15,-20,0) );
	level.ground_ref_ent rotateto( angles, 2.5, 0, 2.5 );
	level.ground_ref_ent waittill( "rotatedone" );

	angles = adjust_angles_to_player( (5,5,0) );
	level.ground_ref_ent rotateto( angles, 2.5, 2, 0.5 );
	level.ground_ref_ent waittill( "rotatedone" );

	level.ground_ref_ent rotateto( (0,0,0), 1, 0.2, 0.8 );
}

create_overlay_element( shader_name, start_alpha )
{
	overlay = newHudElem();
	overlay.x = 0;
	overlay.y = 0;
	overlay setshader ( shader_name, 640, 480);
	overlay.alignX = "left";
	overlay.alignY = "top";
	overlay.horzAlign = "fullscreen";
	overlay.vertAlign = "fullscreen";
	overlay.alpha = start_alpha;
	overlay.foreground = true;
	return overlay;
}

hud_hide( state )
{
	wait 0.1;
	SetSavedDvar( "hud_showStance", 0 );
	SetSavedDvar( "compass", "0" );
	SetSavedDvar( "ammoCounterHide", "1" );
}
