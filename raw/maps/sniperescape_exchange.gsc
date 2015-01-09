#include maps\_hud_util;
#include maps\_utility;
#include maps\_debug;
#include animscripts\utility;
#include maps\_vehicle;
#include maps\sniperescape;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_stealth_logic;
#include maps\sniperescape_code;
#include maps\sniperescape_wounding;

exchange_turret_org()
{
	turret = getent( "turret2", "targetname" );
	return turret.origin;
}

exchange_turret()
{
	turret = getent( "turret2", "targetname" );
	targ = getent( turret.target, "targetname" );
	turret MakeTurretUnusable();
	turret hide();
	turret.origin = targ.origin;
	
	for ( ;; )
	{
		if ( isdefined( turret getturretowner() ) )
			break;
		wait( 0.05 );
	}

	level.player_can_fire_turret_time = gettime() + 1000;
	setsaveddvar( "sv_znear", "100" ); // 100
	setsaveddvar( "sm_sunShadowCenter", getent( "blood_pool", "targetname" ).origin );
	flag_set( "player_is_on_turret" );
	level.player allowCrouch( false );
	level.player allowStand( false );
	
	if ( !flag( "player_used_zoom" ) )
	{
		thread display_hint( "barrett" );
	}
	
	level.level_specific_dof = true;
	player_org = level.player.origin + (0,0,60); // compensate for intro view in the ground, simulating prone

	flag_wait( "player_gets_off_turret" );

	level.player EnableTurretDismount();
	barrett_trigger = getent( "barrett_trigger", "targetname" );
	barrett_trigger delete();
//	turret useby( level.player );
	turret delete();

	setsaveddvar( "compass", 1 );
	SetSavedDvar( "ammoCounterHide", "0" ); 
	setsaveddvar( "ui_hideMap", "0" );
	SetSavedDvar( "hud_showStance", 1 );	
	setsaveddvar( "sv_znear", "0" );
	setsaveddvar( "sm_sunShadowCenter", ( 0, 0, 0 ) );
	flag_clear( "player_is_on_turret" );
	level.player allowCrouch( true );
	level.player allowStand( true );
	level.level_specific_dof = false;
	
	// clear blur in case we were on min spec pc and holding key
	setblur( 0, 0.05 );


	level.player setorigin( level.player.original_org + (0,0,90));
}


update_goal_yaw( target_ent )
{
	self endon( "death" );
	level endon( "stop_updating_goal_yaw" );
	for ( ;; )
	{
		angles = vectortoangles( target_ent.origin - self.origin );
		self setGoalyaw( angles[ 1 ] );
		wait( 0.1 );
	}
}

track_ent_chain( targetname )
{
	ent = getent( targetname, "targetname" );	
	target_ent = spawn( "script_model", ent.origin );
	thread update_goal_yaw( target_ent );

	dist_ratio = 4926.532227;
	time_ratio = 2.5;

	for ( ;; )
	{
		if ( !isdefined( ent.target ) )
			break;
		
		nextent = getent( ent.target, "targetname" );
		dist = distance( nextent.origin, ent.origin );
		
		timer = ( dist * time_ratio ) / dist_ratio;
		
		if ( timer < 0.05 )
			timer = 0.05;
			
		target_ent moveto( nextent.origin, timer );
		wait( timer );

		ent = nextent;
	}
	
	target_ent delete();
	level notify( "stop_updating_goal_yaw" );
}

exchange_heli_tracking()
{
	vehicle_flag_arrived( "block_heli_arrives" );
	/#
	level endon( "pentest" );
	#/
	wait( 1.5 );
	track_ent_chain( "heli_search_org" );
	flag_set( "block_heli_moves" );
}


/*
tracer()
{
	
	for ( ;; )
	{
		angles = level.player getplayerangles();
		start = level.player geteye();
		
		forward = anglestoforward( angles );
		end = start + vectorscale( forward, 5000 );
		level.trace = BulletTrace( start, end, false, undefined );
		wait( 0.05 );
	}
}
*/

exchange_trace_converter()
{
	// there is a plane blocking the action so we can control where the bullets hit and add a fake bullet travel time
	bullet_block = getent( "bullet_block", "targetname" );
	bullet_block hide();
	/#
//	if ( getdvar( "pentest" ) == "on" )
//		bullet_block delete();
	#/
	firetime = -5000;

	
//	bullet_block_trigger = getent( "bullet_block_trigger", "targetname" );
	
	
	for ( ;; )
	{
//		bullet_block_trigger waittill( "trigger", one, two, three, four, five, six );
		flag_wait( "player_is_on_turret" );
		wait_for_buffer_time_to_pass( firetime, 1.0 );
		
		if ( !level.player attackbuttonpressed() )
		{
			wait( 0.05 );
			continue;
		}
		
		thread exchange_player_fires();
		firetime = gettime();

		// wait for the player to release the fire, as its a semi auto weapon
		while ( level.player attackbuttonpressed() )
		{
			wait( 0.05 );
		}
	}
}

exchange_player_fires()
{
	if ( gettime() < level.player_can_fire_turret_time )
		return;
		
	min_zoom = 1.5;
	max_zoom = 20;
	min_eq = 0.15;
	max_eq = 0.80;
	
	zoom = getdvarfloat( "turretScopeZoom" );
	eq = ( zoom - min_zoom ) * ( max_eq - min_eq ) / ( max_zoom - min_zoom );
	eq += min_eq;
	
//	Earthquake( eq, 1, level.player geteye(), 1000 );
	level.player shellshock( "barrett", 1.3 );
	level.fired_barrett = true;
	
	angles = level.player getplayerangles();
	start = level.player geteye();
//	println( "eye " + start );
	// 2412.51 -14950.3, 66.33
	
	forward = anglestoforward( angles );
	end = start + vectorscale( forward, 15000 );
	
//	thread linedraw( eye, end, (1,0,1), 25 );
	
	trace = BulletTrace( start, end, false, undefined );
	level.trace = trace;
	
	if ( trace[ "surfacetype" ] != "default" )
	{
//		thread Linedraw( start, trace[ "position" ], (0,1,0) );
		return;
	}

//	thread Linedraw( start, trace[ "position" ], (1,0,0) );

	start = trace[ "position" ] + vectorscale( forward, 10 );
	
	end = trace[ "position" ] + vectorscale( forward, 15000 );
	
	skill_drift = [];
	skill_drift[ 0 ] = 0.03;
	skill_drift[ 1 ] = 0.07;
	skill_drift[ 2 ] = 0.085;
	skill_drift[ 3 ] = 0.10;

	skill_drift[ 0 ] = 0.025;
	skill_drift[ 1 ] = 0.025;
	skill_drift[ 2 ] = 0.025;
	skill_drift[ 3 ] = 0.025;
	
	
	pos = start;
	move_distance = 314.245;
	move_vec = vectorscale( forward, move_distance );
	/*
	setdvar( "ay", "0" );
	setdvar( "az", "60" );
	setdvar( "ax", "-0.1" );
	setdvar( "az", "16.56" );
	*/
	waittillframeend;
//	eye = level.player.origin + ( -3.62, 0, -66 );
	turret = getent( "turret2", "targetname" );
	if ( !isdefined( turret ) )
		return;
//	eye = turret.origin + ( getdvarfloat( "ax" ), getdvarfloat( "ay" ), getdvarfloat( "az" ) );
	eye = turret.origin + ( -0.1, 0, 15 );
//	eye = level.player.origin + ( getdvarfloat( "ax" ), getdvarfloat( "ay" ), getdvarfloat( "az" ) );
	

	bullet = spawn( "script_model", eye );
	bullet setmodel( "tag_origin" );

	playfxontag( getfx( "bullet_geo" ), bullet, "tag_origin" );
//	println( "start " + start + " firetime " + gettime() );
	count_max = 10;
	count = 0;

	bullet_last_org = bullet.origin;
	
	trace = undefined;
	tried_lock = false;
	lock_on_steps = undefined;
	achieved_lock = false;
	current_step = 0;
	zak_org = undefined;
	drift = (0,0,0);
	
	for ( ;; )
	{
		if ( isalive( level.zakhaev ) && !tried_lock )
		{
			zak_org = level.zakhaev gettagorigin( "J_Shoulder_LE" );
			dist_to_impact = distance( zak_org, bullet.origin );
			if ( dist_to_impact < 3000 )
			{
//				thread linedraw( zak_org, bullet.origin, ( 1, 0.2, 0 ), 50 );
//				thread linedraw( bullet_last_org, bullet.origin, ( 0	 , 0.2, 1 ), 50 );
				tried_lock = true;
				angles = vectorToAngles( zak_org - bullet.origin );
				dotforward = anglesToForward( angles );
				angles = vectorToAngles( bullet.origin - bullet_last_org );
				forward = anglesToForward( angles );
				level.zak_dot = vectordot( dotforward, forward );

				achieved_lock =	level.zak_dot > 0.99998;
				lock_on_steps = dist_to_impact / move_distance;
				achieved_lock = false;
			}
		}
		endpos = pos + move_vec;
		
		if ( !tried_lock || !achieved_lock )
			drift = vectorscale( level.wind_vec, skill_drift[ level.gameskill ] );
		


//		println( "drift " + count + " " + distance( (0,0,0), drift ) );
//		endpos += drift;
		
//		thread linedraw( pos, endpos, ( 1, 0.2, 0 ), 5 );
		
		trace = bullettrace( pos, endpos, true, undefined );
		final_origin = trace[ "position" ];
		if ( trace[ "fraction" ] < 1 )
		{
			exchange_impact_alert( trace[ "position" ] );
			angles = vectortoangles( endpos - pos );
			break;
		}

		view_frac = count / count_max;
//		view_frac -= 0.1;
		if ( view_frac < 0 )
			view_frac = 0;
		if ( view_frac > 1.0 )
			view_frac = 1.0;
		count++;

		level.view_frac = view_frac;
		oldorg = bullet.origin;

		oldeye = eye;
		eye += move_vec;
//		thread linedraw( oldeye, eye, (1,0,0), 25 );

		if ( achieved_lock )
		{
			if ( isalive( level.zakhaev ) )
				zak_org = level.zakhaev gettagorigin( "J_Shoulder_LE" );

			merge_point = zak_org;

			lock_frac = current_step / lock_on_steps;
			lock_frac = lock_frac * lock_frac;
			bullet.origin = vectorscale( final_origin, 1.0 - lock_frac ) + vectorscale( merge_point, lock_frac );
	
//			thread linedraw( oldorg, bullet.origin, (lock_frac,lock_frac,lock_frac), 25 );
			
			current_step++;
			if ( current_step > lock_on_steps )
			{
				achieved_lock = false;
				// update the actual bullet position
				pos = zak_org;
				if ( isalive( level.zakhaev ) )
					level.zakhaev notify( "fake_damage" );
			}
		}
		else
		{
			bullet_last_org = bullet.origin;
			bullet.origin = vectorscale( final_origin, view_frac ) + vectorscale( eye, 1.0 - view_frac );
		}


		pos += move_vec + drift;

//		line( eye, bullet.origin, (1,1,1) );
		wait( 0.05 );		
	}

	println( "hittime " + gettime() );
	forward = anglestoforward( angles );
	// scale it way out for bullet penetration purposes
	pop_vec = vectorscale( forward, 5 );
	move_vec = vectorscale( forward, 15000 );
	MagicBullet( "barrett_fake", pos, pos + move_vec );
	
	wait( 0.25 );
	bullet delete();

	if ( flag( "exchange_success" ) )
	{
		if ( flag( "price_comments_on_zak_hit" ) )
			return;
		price_clears_dialogue();
		flag_set( "price_comments_on_zak_hit" );
		
		//* Target down. I think I saw his arm fly off. Nice work Leftenant. We got him.				target_down_1
		//* Target down. I think you blew off his arm. Shock and blood loss'll take care of the rest.	target_down_2	
		//* Target is down! Nice shot Leftenant. 														target_down_3
		
		the_line = "target_down_" + ( randomint( 3 ) + 1 );
		price_line( the_line );
		return;
	}

	// price comments on the shot		
	if ( flag( "price_comments_on_zak_miss" ) )
		return;	
	flag_set( "price_comments_on_zak_miss" );
	price_clears_dialogue();

	if ( price_thinks_you_are_insane( pos ) )
	{
		// are you insane?
		price_line( "are_you_insane" );
	}
	else
	if ( level.wind_setting == "end" )
	{
		// The target's still standing! Keep firing!
		price_line( "target_still_standing" );
	}
	else
	{
		// Damn, it went wide! Probably should've waited for the wind to die down.
		price_line( "went_wide" );
	}


//	kill_ai_along_path( pos, pos + move_vec, pop_vec );
//	thread linedraw( pos, pos + move_vec, ( 0, 0.5, 1 ), 5 );

	// below here lies ye old bullet tracing magic
	if ( 1 )
		return;
	
	ent = spawnstruct();
	ent.traces = [];
	
	trace = BulletTrace( start, end, true, undefined );

	dist = distance( start, trace[ "position" ] );
	timer = dist * 1.432 / 9000;
	dist_modifier = dist / 9000;

	ent thread exchange_turret_traces( start, end, dist_modifier );
	ent thread exchange_sniper_windmod( end ); 
	wait( timer );
	ent notify( "stop_gathering_traces" );
	
//	thread drawtrace( trace, start );
	exchange_impact_alert( trace[ "position" ] );


/*
	if ( flag( "wind_died_down" ) )
	{
		// shot hits straight on if the wind has died down
		MagicBullet( "barrett_fake", start, end );
		return;
	}
*/

//	assertex( ent.traces.size, "Failed to make a legit trace that didnt hit zakhaev" );

	dest = ent.sniper_shot;
	if ( flag( "exchange_success" ) )
	{
		// once zak has been hit you shouldnt hit him again
		new_dest = ent exchange_get_safe_shot( start );
		if ( !isdefined( new_dest ) )
			return;
		dest = new_dest;
	}

	MagicBullet( "barrett_fake", start, dest );
	/#
	if ( getdebugdvar( "debug_barrett" ) == "on" )
		thread Linedraw( start, dest, (1,0,0) );
	#/
}


exchange_impact_alert( pos )
{
	ai = getaiarray( "axis" );
	if ( !ai.size )
		return;
	closestGuy = getclosest( pos, ai );
	dist = distance( pos, closestGuy.origin );
	if ( dist < 900 )
	{
		flag_set( "player_attacks_exchange" );
	}
}

exchange_sniper_windmod( pos )
{
	self endon( "stop_gathering_traces" );
	// move the shot a bit each frame for the wind
	self.sniper_shot = pos;
	lastpos = pos;
	for( ;; )
	{
		vec = vectorscale( level.wind_vec, 0.20 );
		self.sniper_shot += vec;

//		line( self.sniper_shot, lastpos, (1, 0, 0 ) );
		lastpos = pos;
			
		wait( 0.05 );
	}
}

exchange_get_safe_shot( start )
{
	
	for ( i = 0; i < self.traces.size; i++ )
	{
		trace = bullettrace( start, self.traces[ i ], true, undefined );
		
		hit_zakhaev = false;
		if ( isalive( level.zakhaev ) )
		{
			// extend the trace if it hits guys standing in front of zakhaev
			for ( ;; )
			{
				if ( !isalive( trace[ "entity" ] ) )
					break;
				if ( trace[ "entity" ] == level.zakhaev )
				{
					hit_zakhaev = true;
					break;
				}
				if ( isdefined( trace[ "entity" ].heli ) )
				{
					// kill heli pilots
					trace[ "entity" ] dodamage( trace[ "entity" ].health + 150, (0,0,0) );
				}
			
				trace = bullettrace( trace[ "position" ], self.traces[ i ], true, trace[ "entity" ] );
			}
		}
		
		if ( hit_zakhaev )
			continue;
		
		/#
		if ( getdebugdvar( "debug_barrett" ) == "on" )
			thread Linedraw( start, trace[ "position" ], (1,1,1) );
		#/
		
		return trace[ "position" ];
	}
}

exchange_turret_traces( start, end, dist_modifier )
{
	self endon( "stop_gathering_traces" );
	trace = BulletTrace( start, end, true, undefined );
	center = trace[ "position" ];
	ent = spawn( "script_origin", (0,0,0) );
	level.trace_gather_ent = ent;
	
	local_wind = vectorscale( level.wind_vec, dist_modifier );
	
	ent.origin = center + local_wind;
	ent.angles = vectortoangles( start - end );
//	ent thread maps\_debug::drawOrgForever();
	dist = 0.5;
	
	// the amount to spread on eah check
	range_additive = dist_modifier * 0.75;
	
	for ( ;; )
	{
		ent devaddroll( randomint( 360 ) );
		forward = anglestoup( ent.angles );
		forward = vectorscale( forward, dist );
		
		angles = vectortoangles( ( ent.origin + forward ) - start );
		forward = anglestoforward( angles );
		forward = vectorscale( forward, 25000 );
		
		trace = BulletTrace( start, start + forward, true, undefined );
//		thread linedraw( start, start + forward, ( 0.8, 0.4, 0 ) );
//		thread drawHit( center, ent.origin + forward );
		if ( !hit_zak( trace ) )
		{
			self.traces[ self.traces.size ] = start + forward;
		}

		dist = dist + range_additive;

		wait( 0.025 );
	}
}

drawHit( start, end )
{
	for ( ;; )
	{
		line( start, end, ( 1, 0, 0 ) );
		wait( 0.05 );
	}
}

hit_zak( trace )
{
	if ( !isalive( trace[ "entity" ] ) )
		return false;
	if ( !isalive( level.zakhaev ) )
		return false;
	return trace[ "entity" ] == level.zakhaev;
}

drawtrace( trace, start )
{
	timer = 6*20;
	
	for ( i = 0; i < timer; i++ )
	{
		line( start, trace[ "position" ], ( 1, 0.3, 0 ) );
		wait( 0.05 );
	}
}

exchange_bored_idle()
{
	if ( isdefined( self.script_noteworthy ) )
	{
		// this guy will get a custom anim
		return;	
	}

	self anim_generic_loop( self, "bored_idle" );
}

lean_and_smoke()
{
	targ = getent( self.target, "targetname" );
	targ anim_generic_loop( self, "smoke_idle" );
}

stand_and_smoke()
{
	targ = getent( self.target, "targetname" );
	targ anim_generic_loop( self, "smoking" );
}

exchange_barrett_trigger()
{
	flag_wait( "can_use_turret" );
	barrett_trigger = getent( "barrett_trigger", "targetname" );
	barrett_trigger sethintstring( &"SNIPERESCAPE_BARRETT_USE" );
	turret = getent( "turret2", "targetname" );
	
	barrett_trigger waittill( "trigger" );
	barrett_trigger trigger_off();
	
	blendtime = 5;
	smooth_in = 0.4;
	smooth_out = 0.45;
	level.view_org moveto( ( 781.86, -11719.7, 953.57 ), blendtime, blendtime * smooth_in, blendtime * smooth_out );
	level.view_org rotateto( ( 8.48, -56.48, 0 ), blendtime, blendtime * smooth_in, blendtime * smooth_out );
	thread blackscreen( blendtime );	
	wait( blendtime );
	
	level.view_org moveto( level.view_org.origin + (0,0,260), 0.1 );
	level.view_org delete();

	level.player SetPlayerAngles( ( 5.5, -65.06, 0 ) );
	level.player.original_org = level.player.origin;

	turret useby( level.player );
	thread autosave_now( "beginning", true );
	
	wait( 1 );
	thread sniper_text( &"SNIPERESCAPE_TARGET", 0, 0 ); // "Target: "
	wait( 0.5 );
	thread sniper_text( &"SNIPERESCAPE_ZAKHAEV", 70, 0 ); // "Imran Zakhaev"
	wait( 1.5 );
	thread sniper_text( &"SNIPERESCAPE_DISTANCE", 0, 1 ); // "Distance to target: "
	wait( 0.85 );
	thread sniper_text_countup( 896.7, &"SNIPERESCAPE_M", 158, 1 ); // "m"
	wait( 1.5 );
	thread sniper_text( &"SNIPERESCAPE_BULLET_TRAVEL", 0, 2 ); // "Bullet travel time: "
	wait( 0.80 );
	thread sniper_text_countup( 1.05, &"SNIPERESCAPE_S", 155, 2 ); // "s"
}

sniper_text_countup( count, msg, x, offset )
{
	hudelem = sniper_text_init( msg, x, offset );
	hudelem setText( msg );

	if ( 1 ) return;
	
	hudelem = sniper_text_init( msg, x, offset );
	num = 0;
	rate = 0.11;
	if ( count > 10 )
		rate = 110.11;
	for ( ;; )
	{
		level.player playsound( "ui_pulse_text_type" );
		num += rate;
		if ( num > count )
			num = count;
		hudelem setText( num );
		if ( num == count )
			return;
		wait( 0.05 );
	}
	wait( 5 );
	
}

sniper_text( msg, x, offset )
{
	hudelem = sniper_text_init( msg, x, offset );
	hudelem setText( msg );
}

sniper_text_init( msg, x, offset )
{
	y = 20 * offset;
	hudelem = newHudElem();
	hudelem.x = x + 10;
	hudelem.y = y;
	hudelem.alignX = "left";
	hudelem.alignY = "top";
	hudelem.horzAlign= "left";
	hudelem.vertAlign = "top";
	hudelem.sort = 1; // force to draw after the background
	hudelem.foreground = true;
	hudelem.alpha = 0;
	hudelem fadeOverTime( 0.2 ); 
	hudelem.alpha = 1;

	hudelem.hidewheninmenu = true;
	hudelem.fontScale = 1.2; //was 1.6 and 2.4, larger font change
	hudelem.color = (0.8, 1.0, 0.8);
	hudelem.font = "objective";
	hudelem.glowColor = (0.3, 0.6, 0.3);
	hudelem.glowAlpha = 1;
	duration = 10000;
	hudelem SetPulseFX( 30, duration, 700 );
	thread hudelem_destroyer( hudelem );
	return hudelem;
}

hudelem_destroyer( hudelem )
{
	wait( 10 );
	hudelem destroy();
}

blackscreen( timer )
{
	overlay = newHudElem();
	overlay.x = 0;
	overlay.y = 0;
	overlay setshader( "black", 640, 480 );
	overlay.alignX = "left";
	overlay.alignY = "top";
	overlay.horzAlign = "fullscreen";
	overlay.vertAlign = "fullscreen";
	overlay.alpha = 0;
	wait( timer - 1 );
	overlay fadeOverTime( 1 );
	overlay.alpha = 1;
	wait( 1.2 );
	overlay fadeOverTime( 1 );
	overlay.alpha = 0;
	wait( 1 );
	overlay destroy();
}

whitescreen()
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
	wait( 0.05 );
	
	setsaveddvar( "ui_hideMap", "1" );
	setsaveddvar( "compass", 0 );
	SetSavedDvar( "ammoCounterHide", "1" ); 
	SetSavedDvar( "hud_showStance", 0 );	
	
	overlay fadeOverTime( 1 );
	overlay.alpha = 0;
	wait( 1 );
	overlay destroy();
}

stop_loop()
{
	// tell our target to stop looping us
	if ( !isdefined( self.target ) )
	{
		self notify( "stop_loop" );
		return;
	}
	
	targ = getent( self.target, "targetname" );
	if ( isdefined( targ ) )
	{
		targ notify( "stop_loop" );
		return;
	}
	
	targ = getnode( self.target, "targetname" );
	if ( isdefined( targ ) )
	{
		targ notify( "stop_loop" );
		return;
	}
}

exchange_baddie_main_think()
{
	self endon( "death" );	
	
	if ( !isdefined( self.drivingVehicle ) )
		self.allowdeath = true;
	self ent_flag_init( "run_to_car" );

	thread exchange_guy_dies();
	
	if ( isdefined( self.ridingvehicle ) )
	{
		exchange_rider_gets_out();
	}
	
	if ( isdefined( self.script_linkto ) )
	{
		thread exchange_baddie_runs_to_car();
	}

	flag_wait( "player_attacks_exchange" );

	if ( isdefined( self.ridingvehicle ) )
	{
		self notify( "riding_still" );
		return;
	}

	surprise_anim = "exchange_surprise_" + randomint( level.surprise_anims );
	if ( is_zak() )
	{
		surprise_anim = "exchange_surprise_zakhaev";
		delaythread( 1.8, ::send_notify, "stop_animmode" );
	}

	if ( !isdefined( self.zak_got_hit ) )
	{
		if ( isdefined( self.main_baddie ) )
		{
			wait( level.exchanger_surprise_time );
		}
		else
		{
			wait( randomfloatrange( 0.2, 0.4 ) );
		}
		
		if ( !isdefined( self.drivingVehicle ) )
		{
			stop_loop();
			self stopanimscripted();
			self anim_generic_custom_animmode( self, "gravity", surprise_anim );
			self clear_run_anim();
			self.disableexits = false;
		}
		
		self ent_flag_set( "run_to_car" );
	}

	self notify( "run_to_car" );
}

exchange_baddie_flags_on_death( delete_targ )
{
	self waittill_either( "death", "riding_still" );
	delete_targ ent_flag_set( "passenger_got_in" );
}

exchange_waittill_time_to_go_to_car()
{
	self endon( "run_to_car" );
	level endon( "heli_moves_again" );

	flag_wait( "player_attacks_exchange" );
}

exchange_baddie_runs_to_car()
{
	self endon( "death" );	
	delete_targ = getent( self.script_linkto, "script_linkname" );
	if ( !isdefined( delete_targ ) )
	{
		node = getnode( self.script_linkto, "script_linkname" );
		self setgoalnode( node );
		self.goalradius = 32;
		return;
	}
	thread exchange_baddie_flags_on_death( delete_targ );
	
	exchange_waittill_time_to_go_to_car();

	if ( flag( "player_attacks_exchange" ) )
	{
		// player attacked so wait until we noticed before we run
		if ( is_zak() && isdefined( self.zak_got_hit ) )
		{
			flag_wait( "wounded_zak_runs_for_car" );
		}
		else
		{
			self ent_flag_wait( "run_to_car" );
		}
	}
	else
	{
		// player hasnt attacked so walk back to the car
		self.disableexits = true;
		if ( is_zak() )
		{
			set_generic_run_anim( "patrol_jog" );
		}
		else
		{
			self.run_noncombatanim = getAnim_generic( "stealth_walk" );
			set_generic_run_anim( "stealth_walk" );
		}
	}

	if ( is_zak() )
	{
		self setgoalpos( delete_targ.origin );
		self.goalradius = 16;
		self waittill( "goal" );
	}

//	self delete();

	uaz = undefined;
	if ( isdefined( self.script_vehicleride ) )
	{
		uaz = maps\_vehicle_aianim::get_my_vehicleride();
	}
	else
	{
		uaz = get_shared_linkto();
		self.script_vehicleride = uaz.script_vehicleride;
	}

	guys[ 0 ] = self;

	if ( is_zak() )
	{
		self notify( "got_in_car" );
		delete_targ ent_flag_set( "passenger_got_in" );
		self delete();
		return;
	}
	
	uaz maps\_vehicle_aianim::load_ai( guys );
	self waittill( "enteredvehicle" );
	delete_targ ent_flag_set( "passenger_got_in" );
	self notify( "got_in_car" );

	self waittill( "jumpedout" );
	self delete();
}

get_shared_linkto()
{
	// gets the vehicle that links to the same ent I link to
	mylinks = strtok( self.script_linkto, " " );
	assertex( mylinks.size == 1, "Too many links!" );
	mylink = mylinks[ 0 ];
	
	vehicles = getentarray( "script_vehicle", "classname" );
	for ( i = 0; i < vehicles.size; i++ )
	{
		vehicle = vehicles[ i ];
		if ( !isdefined( vehicle.script_linkto ) )
			continue;
		links = strtok( vehicle.script_linkto, " " );
		for ( k = 0; k < links.size; k++ )
		{
			if ( links[ k ] == mylink )
				return vehicle;
		}
	}
}

is_zak()
{
	return isalive( level.zakhaev ) && self == level.zakhaev;
}

exchange_guy_dies()
{
	self endon( "got_in_car" );
	self waittill( "death" );
	flag_set( "player_attacks_exchange" );
}

exchange_rider_gets_out()
{
	self endon( "death" );	
	level endon( "player_attacks_exchange" );
	self waittill( "jumpedout" );
	targ = getnode( self.target, "targetname" );
	if ( !isdefined( targ ) )
	{
		// zaks drivers dont have a place to go stand
		return;
	}
	self.walkdist = 1000;
	self.fixednode = true;
	self setgoalnode( targ );
	self.disableexits = true;
	self.disablearrivals = true;
	self set_generic_run_anim( "stealth_walk" ); //"stealth_jog", false );
	self.goalradius = 16;
}

exchange_uaz_preps_for_escape()
{
	flag_init( self.script_flag );
	self ent_flag_init( "time_to_go" );
	self godon();
	self.enter_count = 0;
	keys = strtok( self.script_linkto, " " );
	array_levelthread( keys, ::exchange_vehicle_waits_for_passengers );

	path = undefined;
	if ( !isdefined( self.script_vehiclespawngroup ) )
	{
		// these start spawned
		path = get_path_from_array( keys );
		self attachpath( path );
	}

	self ent_flag_wait( "time_to_go" );

	if ( self.script_flag == "uaz4" )
		self setspeed( 25, 10 );
	
	if ( isdefined( self.script_vehiclespawngroup ) )
	{
		ownflag = "vehicle_go_" + self.script_vehiclespawngroup;
		if ( isdefined( level.flag[ ownflag ] ) )
		{
			exchange_wait_until_other_spawned_uazs_go();
			// gogogo!
			flag_set( ownflag );
		}
		return;
	}
	
	exchange_wait_until_other_base_uazs_go();
	
	self startpath();
	
	// cleanup vehicle
	self waittill( "reached_end_node" );
	riders = self maps\_vehicle_aianim::vehicle_get_riders();
	array_thread( riders, ::delete_living );
	self delete();
}

get_path_from_array( keys )
{
	for ( i = 0; i < keys.size; i++ )
	{
		node = getvehiclenode( keys[ i ], "script_linkname" );
		if ( isdefined( node ) )
			return node;
	}
	
	assertmsg( "Tried to get vehicle path but couldnt find it! " + self.origin );
}

exchange_vehicle_waits_for_passengers( key )
{
	ent = getent( key, "script_linkname" );
	
	if ( !isdefined( ent ) )
	{
		// could be vehiclenode key
		return;
	}
	
	ent ent_flag_init( "passenger_got_in" );

	self.enter_count++;
	ent ent_flag_wait( "passenger_got_in" );
	self.enter_count--;
	
	if ( !self.enter_count )
	{
		wait( 2 );
		self ent_flag_set( "time_to_go" );
	}
}


draworg2()
{
	println( " " );
	println( int( self.origin[ 0 ] * 100 ) * 0.01 + " " + int( self.origin[ 1 ] * 100 ) * 0.01 + " " + int( self.origin[ 2 ] * 100 ) * 0.01 );
	println( int( self.angles[ 0 ] * 100 ) * 0.01 + " " + int( self.angles[ 1 ] * 100 ) * 0.01 + " " + int( self.angles[ 2 ] * 100 ) * 0.01 );
}

exchange_zaks_car_door()
{
	// zak spawns but doesnt ride in, so he has to do some special script to play nice with the other scripts.
	level endon( "zak_spawns" );
	zak_car_org = getent( "zak_car_org", "script_noteworthy" );
	flag_wait( "player_attacks_exchange" );
	zak_car_org ent_flag_set( "passenger_got_in" );
}

arm_detach()
{
	self setmodel( getmodel( "zak_one_arm" ) );
	self hidepart( "J_Shoulder_LE" );
	arm_goes_flying( self gettagorigin( "J_Shoulder_LE" ) );
}

arm_goes_flying( org )
{
	arm = spawn( "script_model", (0,0,0) );
	arm.origin = org;
	arm setmodel( getmodel( "zak_left_arm" ) );
	if ( getdvar( "ax" ) == "" )
	{
		setdvar( "ax", "-0.01" );
	}
	if ( getdvar( "ay" ) == "" )
	{
		setdvar( "ay", "-0.07" );
	}
	if ( getdvar( "az" ) == "" )
	{
		setdvar( "az", "0.2" );
	}
	ax = -0.01;
	ay = -0.07;
	az = 0.2;
	vec = ( ax, ay, az );
	vec = vectorscale( vec, 50000 );
	midpoint = arm gettagorigin( "J_Elbow_LE" );
//	arm thread maps\_debug::drawtagforever( "J_Elbow_LE" );
//	wait( 1 );
	arm PhysicsLaunch( midpoint, vec );
}

zak_blood()
{
	level endon( "stop_zak_blood" );
	
	for ( ;; )
	{
		playfxontag( getfx( "blood" ), self, "J_Shoulder_LE" );
		wait( 0.1 );
	}
}

zak_arm_blood()
{
	/*
	tags = [];
	tags[ tags.size ] = "J_Clavicle_LE";
	tags[ tags.size ] = "TAG_INHAND";
	tags[ tags.size ] = "J_Shoulder_LE";
	tags[ tags.size ] = "J_Elbow_Bulge_LE";
	tags[ tags.size ] = "J_Elbow_LE";
	tags[ tags.size ] = "J_ShoulderTwist_LE";
	tags[ tags.size ] = "J_Wrist_LE";
	tags[ tags.size ] = "J_WristTwist_LE";
	tags[ tags.size ] = "TAG_WEAPON_LEFT";

	self array_levelthread( tags, maps\_debug::drawtagforever );
	*/

//	self thread maps\_debug::drawtagforever( "J_Shoulder_LE" );

	rate = 0.2;
	timer = 0.5;
	zak_arm_blood_pump( timer, self, rate );
	wait( 0.5 );
	zak_arm_blood_pump( timer, self, rate );
	wait( 0.5 );
	zak_arm_blood_pump( timer, self, rate );
	wait( 0.5 );
	zak_arm_blood_pump( timer, self, rate * 0.5 );
	wait( 0.5 );
	zak_arm_blood_pump( timer, self, rate * 0.25 );
	wait( 0.5 );

	if ( 1 )
		return;
//	self thread maps\_debug::drawtagforever( "J_Shoulder_LE" );
	
	model = spawn( "script_model", (0,0,0) );
	model setmodel( "tag_origin" );
	model linkto( self, "J_Shoulder_LE", (0,0,0), (0,0,0) );
	model thread maps\_debug::drawtagforever( "tag_origin" );

	
	for ( i = 0; i < timer; i++ )
	{
		playfxontag( getfx( "blood" ), model, "tag_origin" );
		wait( rate );
	}

	wait( 5 );
	model delete();
}

zak_arm_blood_pump( timer, model, rate )
{
	timer = timer * ( 1 / rate );
	for ( i = 0; i < timer; i++ )
	{
		playfxontag( getfx( "blood" ), model, "J_Shoulder_LE" );
		wait( rate );
	}
}

zak_blood_pool()
{
	self endon( "stop_blood" );
	wait( 1 );
	blood_pool = getent( "blood_pool", "targetname" );
	z = blood_pool.origin[ 2 ];

	for ( ;; )
	{
		start = self gettagorigin( "J_Shoulder_LE" ) + (0,0,50);
		end = start + (0,0,-250);
		trace = bullettrace( start, end, false, undefined );
		pos = ( trace[ "position" ][ 0 ], trace[ "position" ][ 1 ], z );
		playfx( getfx( "blood_pool" ), pos, ( 0, 0, 1 ) );
		wait( 0.35 );
	}
}

blood_pool()
{
	pool = self;
	// spreads from under the table
	count = 5;
	for ( ;; )
	{
		playfx( getfx( "blood_pool" ), pool.origin + (0,0,1), ( 0, 0, 1 ) );
		count--;
		if ( count <= 0 )
			wait( 0.3 );
		if ( !isdefined( pool.target ) )
			return;
		pool = getent( pool.target, "targetname" );
	}
}

zak_dies()
{
	self.health = 50000;
	self endon( "death" );
	self disable_long_death();

	zakmodel = spawn( "script_model", (0,0,0) );
	zakmodel character\character_sp_zakhaev_onearm::main();
	zakmodel hide();
	zakmodel.animname = "zakhaev";
	zakmodel assign_animtree();
	zakmodel linkto( self, "tag_origin", (0,0,0), (0,0,0) );

//	arm_model linkto( self, "J_Shoulder_LE", (0,0,0), (0,0,0) );
//	arm_model hide();
//	arm_model thread manual_taglinkto( self, "J_Shoulder_LE" );

	self waittill_either( "damage", "fake_damage" );
	
	playfxontag( getfx( "blood" ), self, "J_Shoulder_LE" );

	if ( !isdefined( self ) )
		return;

	arcadeMode_kill( self geteye(), "rifle", 2000 );
	
	if ( !flag( "exchange_heli_alerted" ) )
	{
		thread autosave_now();
	}
	
//	zakmodel thread arm_detach();
	run_thread_on_targetname( "blood_pool", ::blood_pool );
	flag_set( "exchange_success" );
	zakmodel unlink();
	ent = spawn( "script_origin", (0,0,0) );
	ent.origin = self.origin;
	yaw = 135;
	ent.angles = ( 0, yaw, 0 );

	org = getstartorigin( ent.origin, ent.angles, level.scr_anim[ "zak_left_arm" ][ "zak_pain" ] );
	arm_model = spawn_anim_model( "zak_left_arm", org );
//	arm_model thread zak_arm_blood();
	/#
	if ( getdvar( "debug_arm" ) != "" )
	{
		arm_model thread zak_arm_blood();
	}
	#/

	zakmodels = make_array( zakmodel, arm_model );
	ent anim_first_frame_solo( arm_model, "zak_pain" );
	ent thread anim_single_solo( zakmodel, "zak_pain" );
	ent delaythread( 0.05, ::anim_single_solo, arm_model, "zak_pain" );


	zakmodel thread zak_blood();
//	zakmodel thread zak_blood_pool();

	zakmodel show();
	self delete();
	ent waittill( "zak_pain" );
	level notify( "stop_zak_blood" );
	/*
	level.zak_timer = gettime();
//	self.zak_got_hit = true;
	self.a.pose = "crouch";
	self.disableexits = false;
	self.a.movement = "stop";
	self.a.movemode = "stop";
	self setgoalpos( self.origin );
	self.goalradius = 16;
//	delaythread( 0.45, ::anim_stopanimscripted );
//	delaythread( 1.0, ::flag_set, "wounded_zak_runs_for_car" );

	if ( isdefined( self ) )
	{
		flag_set( "exchange_success" );
	}
	
	*/
}

exchange_zak_and_guards_jab_it_up( node, baddies )
{
	if ( flag( "player_attacks_exchange" ) )
		return;
	
	thread exchange_zaks_car_door();
	
	level endon( "player_attacks_exchange" );
	flag_wait( "player_on_barret" );	
	flag_wait( "exchange_uazs_arrive" );
	flag_wait( "launch_zak" );
	
	wait( 2 );
	// the fake case gives us reliable vector for the case's movement
	fake_case = spawn_anim_model( "briefcase" );
	fake_case hide();
	level.fake_case = fake_case;
	node thread anim_single_solo( fake_case, "exchange" );
	wait( 0.25 );

	
	flag_set( "zak_spawns" );
	zakhaev = get_guy_with_targetname_from_spawner( "exchange_zak" );
	level.zakhaev = zakhaev;
	zakhaev thread exchange_baddie_main_think();
	zakhaev.a.disablePain = true;
	zakhaev thread zak_dies();
	zakhaev.no_magic_death = true;
	zakhaev.main_baddie = true;

	zakhaev.animname = "zakhaev";
	zakhaev set_run_anim( "run" );
	zakhaev.ignoreall = true;
	zakhaev.disableexits = true;
	zakhaev.disablearrivals = true;

	zakhaev putGunAway();

	briefcase = spawn_anim_model( "briefcase" );
	baddies[ baddies.size ] = zakhaev;

	briefcase thread exchange_brick_drop();
	
	array_thread( baddies, ::set_allowdeath, true );
	
	baddies[ baddies.size ] = briefcase;
	
	array_thread( baddies, ::set_exchange_timings, node );

	node notify( "stop_loop" );
	node thread anim_single( baddies, "exchange" );

	flag_wait( "block_heli_arrives" );
	wait( 2 );
	
	node2 = getent( "exchange_org2", "targetname" );
	if ( isdefined( briefcase ) )
		briefcase unlink();
//	node moveto( node2.origin, 2 );	
		
	node waittill( "exchange" );
}


set_exchange_timings( node )
{
	self endon( "death" );
	level endon( "player_attacks_exchange" );
	// basically pause the anim while the heli is in the way
	flag_wait( "block_heli_arrives" );
	wait( 2 );
	self setanim( getanim( "exchange" ), 1, 0, 0 );
	self linkto( node );
	self thread exchange_unlink();	
	flag_wait( "block_heli_moves" );
	
	self setanim( getanim( "exchange" ), 1, 0, 1 );
	self setanimtime( getanim( "exchange" ), 0.49 );
	flag_wait( "heli_moves_again" );
	self setanimtime( getanim( "exchange" ), 0.9 );
}

exchange_unlink()
{
	self endon( "death" );
	flag_wait( "block_heli_moves" );
	self unlink();	
}



exchange_vehicles_flee_conflict()
{
	flag_wait( "player_attacks_exchange" );	
	
	nodes = getvehiclenodearray( "unloading_node", "script_noteworthy" );
	array_thread( nodes, ::clear_unload );
}

clear_unload()
{
	self.script_unload = undefined;
}

exchange_dof()
{
	for ( ;; )
	{
		flag_wait( "player_is_on_turret" );
		exchange_scale_dof_while_on_turret();
		flag_waitopen( "player_is_on_turret" );
		level.player SetDepthOfField( 0, 0, 0, 0, 8, 8 );
	}
}

exchange_scale_dof_while_on_turret()
{
	level.fired_barrett = false;
	level endon( "player_is_on_turret" );
//	SetDepthOfField( <near start>, <near end>, <far start>, <far end>, <near blur>, <far blur> )
	olddist = getdvarint( "turretscopezoom" );
	
	zoom[ 9 ] = 6750;
	
	depthdist = 500;
	
	max_depthdist = 24000;
	min_depthdist = 6500;
	clear_rate = 300;
	focus_rate = 300;
	fog_rate = 1000;
	
	depth_near = 6000;

	max_blurring = 14000;
	
	fired_barrett_dist = 6500;

	level.blur = 0;
	blur_barret_fired = 8.0;
	blur_stable_rate = -0.2;
	blur_in_rate = 0.10;
	blur_out_rate = -0.25;
	
	stable = false;
	for ( ;; )
	{
		dist = getdvarint( "turretscopezoom" );
		
		if ( dist < olddist )
		{
			if ( dist >= max_blurring )
			{
				dist = max_blurring;
			}

			// zooming in, so bring the fog in
			depthdist -= fog_rate;
			
			level.blur += blur_in_rate;
			stable = false;
		}
		else
		if ( dist == olddist )
		{
			if ( stable )
			{
				// stable, focus the eyes
				depthdist += focus_rate;
			
				level.blur = level.blur * 0.9;
				if ( level.blur < 0.1 )
					level.blur = 0;
			}
			stable = true;
		}
		else
		{
			stable = false;
			// zooming out, sharpen things up quick
			depthdist += clear_rate;
			
			level.blur += blur_out_rate;
		}

		if ( level.fired_barrett )
		{
			level.fired_barrett = false;
			depthdist = fired_barrett_dist;
			level.blur = blur_barret_fired;
		}
		
		if ( level.blur > 12 )
			level.blur = 12;
		if ( level.blur < 0 )
			level.blur = 0;
		
		far_min = depthdist - depth_near;
		if ( far_min < 0 )
			far_min = 0;

		if ( depthdist > max_depthdist )
			depthdist = max_depthdist;
		else
		if ( depthdist < min_depthdist )
			depthdist = min_depthdist;

//		println( "dofdist " + depthdist + " zoom " + dist );		
		level.player SetDepthOfField( 0, 0, far_min, depthdist, 8, 8 );
		if ( getdvarint( "r_dof_enable" ) != true )
		{
			setblur( level.blur, 0.05 );
		}
		olddist = dist;
		wait( 0.05 );
	}
}

add_waiters( waiters, myflag, flag1, flag2, flag3 )
{
	if ( self.script_flag != myflag )
		return waiters;
		
	waiters[ waiters.size ] = flag1;
		
	if ( isdefined( flag2 ) )
		waiters[ waiters.size ] = flag2;
		
	if ( isdefined( flag3 ) )
		waiters[ waiters.size ] = flag3;
		
	return waiters;
}

exchange_wait_until_other_spawned_uazs_go()
{
	waiters = [];
//	waiters = add_waiters( waiters, "uaz7", "uaz6", "uaz5" );
	waiters = add_waiters( waiters, "uaz6", "uaz5" );
	
	exchange_wait_until_other_uazs_go( waiters );
}

exchange_wait_until_other_base_uazs_go()
{
	waiters = [];
	waiters = add_waiters( waiters, "uaz3", "uaz2", "uaz1" );
	waiters = add_waiters( waiters, "uaz2", "uaz1" );
	
	exchange_wait_until_other_uazs_go( waiters );
}

exchange_wait_until_other_uazs_go( waiters )
{
	flag_set( self.script_flag );
	if ( !waiters.size )
		return;
		
	timer = gettime();
	for ( i = 0; i < waiters.size; i++ )
	{
		flag_wait( waiters[ i ] );
	}
	
	if ( gettime() != timer )
	{
		// wait until the one in front of us goes
		wait( 0.4 );
		
		if ( self.script_flag == "uaz6" )
			wait( 2.2 );
	}
}

exchange_uaz_that_backs_up()
{
	flag_wait( "uaz_reaches_pause_spot" );
	wait( 0.45 );
	flag_set( "uaz_pauses_a_sec" );
}

exchange_case_velcalc()
{
	// stores the velocity of the case for cool physics
	level endon( "player_attacks_exchange" );
	self endon( "death" );
	for ( ;; )
	{
//		line( level.fake_case gettagorigin( "J_Case" ), self gettagorigin( "J_Case" ), ( 1,1, 0 ) );
		wait( 0.05 );
	}
}

exchange_brick_drop()
{
	casemodel = spawn( "script_model", (0,0,0) );
	casemodel linkto( self, "J_Case", (0,0,0), (0,0,0) );

	goldbar = spawn( "script_model", (0,0,0) );
	goldbar linkto( self, "TAG_GOLD_BRICK", (0,0,0), (0,0,0) );
	
	flag_wait( "player_attacks_exchange" );

//		line( level.fake_case gettagorigin( "J_Case" ), self gettagorigin( "J_Case" ), ( 1,1, 0 ) );
//	thread linedraw( self gettagorigin( "J_Case" ), self gettagorigin( "J_Case" ) + vec, (0,1,0) );
	wait( level.exchanger_surprise_time );
	if ( !flag( "briefcase_placed" ) )
	{
		vec = self gettagorigin( "J_Case" ) - level.fake_case gettagorigin( "J_Case" );
		vec = vectorscale( vec, -100 );
		// brief case hasnt been put down yet, so it falls to the ground
		casemodel unlink();
		casemodel setmodel( "com_gold_brick_case" );
		casemodel PhysicsLaunch( casemodel.origin, vec );
		self delete();
	}
	else
	{
		vec = self gettagorigin( "TAG_GOLD_BRICK" ) - level.fake_case gettagorigin( "TAG_GOLD_BRICK" );
		vec = vectorscale( vec, -50 );
		self hidepart( "TAG_GOLD_BRICK" );
		goldbar unlink();
		goldbar setmodel( "com_golden_brick" );
		goldbar PhysicsLaunch( goldbar.origin, vec );
		
		// dont want the case to magiclose later
		self setanim( getanim( "exchange" ), 1, 0, 0 );
	}
}


wait_until_seaknight_gets_close( dist )
{
	seaknight_node = getent( "seaknight_landing", "targetname" );
	level.seanode = seaknight_node;
	for ( ;; )
	{
		newdist = distance( level.seaknight.origin, seaknight_node.origin );
		if ( newdist < dist )
			return;
		wait( 0.05 );
	}
}

should_break_prone_hint()
{
	player_snipe_spot = getent( "player_snipe_spot", "targetname" );
	if ( distance( level.player.origin, player_snipe_spot.origin ) >= player_snipe_spot.radius )
		return true;
	
	return level.player getstance() == "prone";
}

should_break_claymores()
{
	claymoreCount = getPlayerClaymores();
	if ( claymoreCount <= 0 )
		return true;

	if ( flag( "beacon_placed" ) )
		return true;

	return level.player GetCurrentWeapon() == "claymore";
}

should_break_c4()
{
	c4Count = getPlayerC4();
	if ( c4Count <= 0 )
		return true;

	if ( flag( "beacon_placed" ) )
		return true;
		
	return level.player GetCurrentWeapon() == "c4";
}

should_break_c4_throw()
{
	c4Count = getPlayerC4();
	if ( level.new_c4Count > c4Count )
		return true;

	if ( flag( "beacon_placed" ) )
		return true;

	return level.player GetCurrentWeapon() != "c4";
}

clear_path_speed( min )
{
	vnode = undefined;
	if ( isdefined( self.target ) )
	{
		vnode = getvehiclenode( self.target, "targetname" );
	}
	else
	{
		keys = strtok( self.script_linkto, " " );
		vnode = get_path_from_array( keys );
	}
	
	for ( ;; )
	{
		if ( isdefined( vnode.speed ) )
		{
			if ( vnode.speed < min )
				vnode.speed = min;
		}
		
		if ( !isdefined( vnode.target ) )
			break;
		
		vnode = getvehiclenode( vnode.target, "targetname" );
	}
}

exchange_wind_flag()
{
	wind_flag = getent( "wind_flag", "script_noteworthy" );
	wind_flag endon( "death" );
	
	for ( ;; )
	{
		forward = anglestoforward( wind_flag.angles );
		level.wind_vec = vectorscale( forward, level.wind_vel );
		/#
		if ( getdvar( "nowind" ) != "" )
			level.wind_vec = (0,0,0);
		#/
		wait( 0.05 );
	}
}

exchange_flag_rotates()
{
	wait( 0.1 ); // wait to get linked up and for the vehicle to settle
	self unlink();
	
	for ( ;; )
	{
		level waittill( "wind_flag_rotation", rotation, timer );
		self rotateyaw( rotation, timer, timer * 0.25, timer * 0.25 );
	}
}

exchange_wind_generator()
{
	range = 140;
	for ( ;; )
	{
		timer = randomfloatrange( 0.3, 0.9 );
		level notify( "wind_flag_rotation", randomint( range ) - range * 0.5, timer );
		wait( timer );
	}
}

exchange_flag_relinks( vehicle )
{
	waittillframeend; // wait for flag to be initialized
	vehicle ent_flag_wait( "time_to_go" );
	flag_wait_either( "zak_uaz_leaves", "player_attacks_exchange" );
	self.angles = ( 0, vehicle.angles[ 1 ] + 180, 0 );
	self linkto( vehicle );
}

exchange_flag()
{
	flag = spawn_anim_model( "flag" );
	flag.origin = self.origin;
	flag.angles = self.angles;
	
	vehicle = getent( self.script_linkto, "script_linkname" );
	self linkto( flag );
	flag linkto( vehicle );
	flag thread exchange_flag_rotates();
	flag thread exchange_flag_relinks( vehicle );
	
//	blend = randomfloatrange( 50, 99 ) * 0.01;
	blend = 0;
	rate = 0.5;
	for ( ;; )
	{
		// blend the flag to the current wind vel
		desired_blend = level.wind_vel / 100;
		if ( desired_blend < 0 )
			desired_blend = 0;
		else
		if ( desired_blend > 0.99 )
			desired_blend = 0.99;
			
		if ( blend < desired_blend )
		{
			blend += rate;
			if ( blend > desired_blend )
				blend = desired_blend;
		}
		else
		{
			blend -= rate;
			if ( blend < desired_blend )
				blend = desired_blend;
		}
		
		blendtime = randomfloatrange( 0.1, 1 );
		flag setanim( flag getanim( "up" ), blend, blendtime, 5 );
		flag setanim( flag getanim( "down" ), 1 - blend, blendtime, 5 );
		wait( blendtime );
	}
}

exchange_heli_second_wave()
{
	helis = spawn_vehicles_from_targetname_and_drive( "hotel_attack_helis" );
	array_thread( helis, ::exchange_second_heli );
	array_thread( helis, ::exchange_followup_heli_shoots_hotel );
}

exchange_heli()
{
	heli = spawn_vehicle_from_targetname_and_drive( "view_block_heli" );
	heli thread exchange_heli_tracking();
	heli thread exchange_heli_think( 35, 35 );
	heli thread exchange_heli_preps_missiles();
	heli thread exchange_block_view_on_attack();
	heli thread do_in_order( ::waittill_msg, "death_spiral", ::flag_set, "block_heli_starts" );
	heli setenginevolume( 0 );

	add_wait( ::flag_wait, "player_attacks_exchange" );
	add_wait( ::flag_wait, "block_heli_starts" );
	heli add_func( ::volume_up, 1 );
	thread do_wait_any();
	
	heli endon( "death" );
	level endon( "player_attacks_exchange" );
	
	flag_wait( "block_heli_moves" );
	wait( 22.0 );
	flag_set( "heli_blocks_zak" );

	flag_wait( "zak_escape" );

	// alright take the shot
	delaythread( 4.5, ::flag_set, "heli_moves_again" );
	wait( 4.0 );
	if ( isalive( level.zakhaev ) )
	{
		level.zakhaev notify( "run_to_car" );
		level.zakhaev anim_stopanimscripted();
	}

	wait( 10 );
	flag_set( "zak_uaz_leaves" );
}

exchange_followup_heli_shoots_hotel()
{
	self endon( "death" );
	self endon( "death_spiral" );
	vehicle_flag_arrived( "block_heli_followup" );
	hotel_look_org = getent( "hotel_look_org", "targetname" );
	self setlookatent( hotel_look_org );

	flag_wait( "apartment_explosion" );
	
	wait( 1.5 );
	exchange_heli_shoots_hotel();

	for ( i = 0; i < 1; i++ )
	{
		exchange_heli_shoots_hotel();
		wait( randomfloatrange( 1, 3 ) );
	}
	wait( randomfloatrange( 18, 22 ) );
	flag_set( "block_heli_followup" );
}

exchange_block_view_on_attack()
{
	self endon( "death" );
	flag_wait( "player_attacks_exchange" );
	self notify( "newpath" );
	heli_block_org = getent( "heli_block_org", "targetname" );
	self setvehgoalpos( heli_block_org.origin, true );
	hotel_look_org = getent( "hotel_look_org", "targetname" );
	self setlookatent( hotel_look_org );
	self waittill( "goal" );
	self.vehicle_flags[ "block_heli_starts" ] = true;
	self notify( "vehicle_flag_arrived", "block_heli_starts" );
}

exchange_heli_preps_missiles()
{
	self endon( "death" );
	self endon( "death_spiral" );

	flag_wait( "player_attacks_exchange" );
	vehicle_flag_arrived( "block_heli_starts" );
	delaythread( 5, ::flag_set, "exchange_heli_alerted" );
	delaythread( 5, ::flag_clear, "can_save" );
	wait( 15 );
	flag_set( "apartment_explosion" );
	wait( 1.5 );
	thread exchange_heli_shoots_hotel();
}

exchange_heli_shoots_hotel()
{
	hotel_org = getstructarray( "hotel_org", "targetname" );
	ent = spawn( "script_origin", (0,0,0) );
	org = random( hotel_org );
	ent.origin = org.origin;
	self shoots_down( ent, 25 );
	ent delaythread( 5, ::self_delete );
}

exchange_second_heli()
{
	self thread helipath( self.target, 45, 45 );
}
	
exchange_heli_think( speed, accell )
{
	self thread helipath( self.target, speed, accell );
	
	self godon();
	self thread exchange_heli_death_spiral();
	
	spawners = self get_linked_ents();
	assertex( spawners.size == 2, "Heli doesn't link to two pilots" );
	self.pilots = [];
	self thread exchange_heli_pilot( spawners[ 0 ], "tag_pilot", "gunner_idle", "tag_window_back" );
	self thread exchange_heli_pilot( spawners[ 1 ], "tag_gunner", "pilot_idle", "tag_window_front" );

	waittillframeend; // for pilots to get filled
	self.bloodmodels = [];
	pilots = self.pilots;	
	
	self waittill_either( "death_spiral", "death" );
	if ( isalive( self ) )
	{
		bloodmodels = self.bloodmodels;
	
		self waittill( "death" );
		array_thread( bloodmodels, ::_delete );
	}
	
	array_thread( pilots, ::delete_living );
}

exchange_heli_pilot( spawner, tag, idle_anim, blood_tag )
{
	pilot = spawner spawn_ai();
	if ( spawn_failed( pilot ) )
		return;
		
	self endon( "death" );
	pilot linkto( self, tag );
	pilot.no_magic_death = true;
	pilot.allowdeath = true;
	pilot.health = 50000;
	pilot gun_remove();
	pilot.heli = self;
	self.pilots[ self.pilots.size ] = pilot;
	
	self thread anim_generic_loop( pilot, idle_anim, tag, "stop_loop" + tag );
	
	for ( ;; )
	{
		pilot waittill( "damage" );
		if ( !isdefined( pilot.damagelocation ) )
			continue;
		if ( pilot.damagelocation == "head" || pilot.damagelocation == "neck" )
		{
			level.pilot_headshot = true;
			break;
		}
		if ( isdefined( level.pilot_headshot ) )
			return;
		if ( pilot.damagelocation == "torso_upper" )
			break;
	}
	
		
	model = spawn( "script_model", (0,0,0) );
	model setmodel( level.scr_model[ tag ] );
	model linkto( self, blood_tag, (0,0,0), (0,0,0) );
	self.bloodmodels[ self.bloodmodels.size ] = model;
	self notify( "death_spiral" );
}

exchange_heli_death_spiral()
{
	self endon( "death" );
	self waittill( "death_spiral" );
	
	delayThread( 0.5, ::flag_set, "heli_destroyed" );
	wait( 0.2 );

	self thread kill_fx( self.model );
	helicopter_crash_move();
	playfx( getfx( "heli_explosion" ), self.origin );
	self thread play_sound_in_space( "havoc_helicopter_crash", self.origin );
	wait( 0.25 );
	self godoff();
//	self dodamage( self.health + 25000, (0,0,0) );	
//	RadiusDamage( self.origin, 250, 50000, 50000 );
	self delete();
}

exchange_ready_to_run( guy )
{
	anim_stopanimscripted();
}

exchange_claymore()
{
	claymore_org = getent( "claymore_org", "targetname" );
	claymore_org.origin = ( 215.199, -10977.9, 1028 );
	claymore_org.angles = ( 0, 161.65, 0 );
	
	level.price.grenadeweapon = "claymore";
	level.price MagicGrenadeManual( claymore_org.origin, (0,0,0), 9000 );
	
	grenades = getentarray( "grenade", "classname" );
	assertex( grenades.size == 1, "Should only be 1 grenade now" );
	
	grenade = grenades[ 0 ];
	grenade.angles = claymore_org.angles;
	grenade maps\_detonategrenades::playClaymoreEffects();
	level.price.grenadeweapon = "fraggrenade";
//		claymore = spawn( "claymore", (0,0,0) );
//	level.price MagicGrenadeManual( <origin>, <velocity>, <time to blow> )

//	claymore.origin = claymore_org.origin;
//	claymore.angles = claymore_org.angles;
}

exchange_wind_flunctuates()
{
	
	wind_min = [];
	wind_max = [];
	level.wind_setting = "start";

	wind_min[ "start" ][ 0 ] = 20;
	wind_max[ "start" ][ 0 ] = 50;

	wind_min[ "start" ][ 1 ] = 20;
	wind_max[ "start" ][ 1 ] = 50;

	wind_min[ "start" ][ 2 ] = 20;
	wind_max[ "start" ][ 2 ] = 50;

	wind_min[ "start" ][ 3 ] = 20;
	wind_max[ "start" ][ 3 ] = 50;

	
	wind_min[ "middle" ][ 0 ] = 80;
	wind_max[ "middle" ][ 0 ] = 100;

	wind_min[ "middle" ][ 1 ] = 80;
	wind_max[ "middle" ][ 1 ] = 100;

	wind_min[ "middle" ][ 2 ] = 80;
	wind_max[ "middle" ][ 2 ] = 100;

	wind_min[ "middle" ][ 3 ] = 80;
	wind_max[ "middle" ][ 3 ] = 100;

	
	wind_min[ "end" ][ 0 ] = 0;
	wind_max[ "end" ][ 0 ] = 10;

	wind_min[ "end" ][ 1 ] = 0;
	wind_max[ "end" ][ 1 ] = 10;

	wind_min[ "end" ][ 2 ] = 10;
	wind_max[ "end" ][ 2 ] = 20;

	wind_min[ "end" ][ 3 ] = 40;
	wind_max[ "end" ][ 3 ] = 60;
	
	rate = 10;
	count = 0;
	target_vel = 0;
	level.wind_vel = 0;
	for ( ;; )
	{
		if ( level.wind_vel < target_vel )
		{
			level.wind_vel += rate;
			if ( level.wind_vel > target_vel )
				level.wind_vel = target_vel;
		}
		else
		if ( level.wind_vel > target_vel )
		{
			level.wind_vel -= rate;
			if ( level.wind_vel < target_vel )
				level.wind_vel = target_vel;
		}

		count--;
		if ( count <= 0 )
		{
			count = int( randomfloatrange( 1, 2 ) * 20 );
			min = wind_min[ level.wind_setting ][ level.gameskill ];
			max = wind_max[ level.wind_setting ][ level.gameskill ];
			if ( max > min )
				target_vel = randomfloatrange( min, max );
			else
				target_vel = max;
		}
		wait( 0.05 );
	}
}


hotel_rumble()
{
//	playrumbleonposition( "crash_heli_rumble", level.player.origin );
//	Earthquake( 0.6, 1.2, level.player.origin, 6000 );
}

blow_up_hotel()
{
	if ( flag( "hotel_destroyed" ) )
		return;
	flag_set( "hotel_destroyed" );
	delaythread( 1.75, ::flag_set, "player_gets_off_turret" );

	delaythread( 1.8, ::exploder, 3 );
	delaythreaD( 1.8, ::hotel_rumble );
	delaythread( 4.2, ::exploder, 37 );
	wait( 1.5 );
	
	price_clears_dialogue();	
	wait( 0.5 );
	
	level.player endon( "death" );
	timer = 2.2 / 7;
	deathtrig = getent( "explosion_death_trigger", "targetname" );
	for ( ;; )
	{
		deathtrig thread deathtouch();
		if ( !isdefined( deathtrig.target ) )
			break;
		deathtrig = getent( deathtrig.target, "targetname" );
		wait( timer );
	}
}

deathtouch()
{	
	if ( !isalive( level.player ) )
		return;
	timer = 3 * 20;
	
	for ( i = 0; i < timer; i++ )
	{
		if ( level.player istouching( self ) )
		{
			radiusdamage( level.player.origin, 16, 35, 35, level.player );
			if ( level.player.health <= 1 )
			{
				level.player enableHealthShield( false );
				level.player unlink();
			}
		}
		wait( 0.05 );
	}
}


exchange_mission_failure()
{
	flag_wait( "zakhaev_escaped" );
	if ( flag( "exchange_success" ) )
		return;

	// "Zakhaev escaped unharmed"
	setdvar( "ui_deadquote", &"SNIPERESCAPE_ZAKHAEV_ESCAPED" );
	maps\_utility::missionFailedWrapper();
}

exchange_vehicle_clip()
{
	self connectpaths();
	self delete();
}

wait_for_hint_destroy()
{
	
}

/*
barrett_hint()
{
	original_scale = getdvarint( "turretscopezoom" );
	for ( ;; )
	{
		flag_wait( "player_is_on_turret" );
		hudelem = maps\_hud_util::createFontString( "default", 1.5 );
		hudelem.location = 0;
		hudelem.alignX = "center";
		hudelem.alignY = "middle";
		hudelem.foreground = 1;
		hudelem.sort = 20;
	
		hudelem.alpha = 1;
		hudelem.x = 0;
		hudelem.y = 40;
		hudelem.label = "Press Towards or Back to adjust zoom";
		hudelem.color = (1,1,1);
		
		wait_for_hint_destroy();
		hudelem destroy();
	}	
}
*/

should_break_zoom_hint()
{
	if ( !flag( "player_is_on_turret" ) )
		return true;
	
	return flag( "player_used_zoom" );
}

player_learns_to_zoom()
{
	original_scale = getdvarint( "turretscopezoom" );
	for ( ;; )
	{
		new_scale = getdvarint( "turretscopezoom" );
		if ( abs( new_scale - original_scale ) > 5 )
			break;
		wait( 0.05 );
	}
	
	flag_set( "player_used_zoom" );
}

kill_ai_along_path( start, end, pop )
{
	/#
	if ( getdvar( "pentest" ) == "on" )
		return;
	#/
	oldstart = (0,0,0);
	for ( ;; )
	{
		if ( start == end )
			return;
			
		trace = bullettrace( start, end, true, undefined ); 
		if ( trace[ "fraction" ] == 1 )
			return;

		oldstart = start;
		start = trace[ "position" ] + pop;
		if ( start == oldstart )
			return;
		if ( !isalive( trace[ "entity" ] ) )
			continue;
		
		ent = trace[ "entity" ];
		if ( !issentient( ent ) )
			continue;

		if ( isdefined( ent.no_magic_death ) )
		{
			ent dodamage( 50, (0,0,0) );
			continue;
		}

		ent dodamage( ent.health + 150, (0,0,0) );
		wait( 0.05 );
		return;
	}
}


_hidepart( part )
{
	self hidepart( part );
}

barrett_intro()
{
	level.player DisableTurretDismount();
	thread whitescreen();
	level.player disableweapons();
	level.player allowCrouch( false );
	level.player allowStand( true );
	
	org = spawn( "script_model", (0,0,0) );
	org.origin = ( 791.70, -11707.8, 977.11 - 20 );
	org.angles = ( 17.38, -104.33, 0 );
	org setmodel( "tag_origin" );
	level.view_org = org;
	
//	level.player setorigin( org.origin );
//	level.player setplayerangles( org.angles );
//	level.player playerlinktodelta( org, "tag_origin", 1, 45, 45, 20, 20 );
	org lerp_player_view_to_tag( "tag_origin", 0.1, 1, 5, 15, 10, 10 );
	wait( 2 );
	setsaveddvar( "phys_bulletspinscale", "0.01" );
	flag_set( "can_use_turret" );
}

armtest()
{
	flying_arm = getent( "flying_arm", "targetname" );
	ent = spawn( "script_origin", (0,0,0) );
	ent.origin = flying_arm.origin;
	yaw = 135;
	ent.angles = ( 0, yaw, 0 );
	
	for ( ;; )
	{
		zakmodel = spawn( "script_model", (0,0,0) );
		zakmodel character\character_sp_zakhaev_onearm::main();
		zakmodel.animname = "zakhaev";
		zakmodel assign_animtree();
		wait( 0.5 );	
		
		ent thread anim_generic_first_frame( zakmodel, "zak_pain" );
		wait( 0.1 );
		zakmodel thread arm_detach();
		ent thread anim_generic( zakmodel, "zak_pain" );
		wait ( 1 );
		zakmodel delete();
		
	}
}

price_thinks_you_are_insane( pos )
{
	if ( !flag( "zak_spawns" ) )
		return true;
		
	if ( level.wind_setting == "start" )
		return true;
	
	return isalive( level.zakhaev ) && distance( level.zakhaev.origin, pos ) > 600;
}