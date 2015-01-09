#include common_scripts\utility;
#include maps\_utility;
#include maps\_hud_util;
#include maps\_vehicle;
#include maps\_anim;
#include maps\village_defend;

minigun_think()
{
	flag_init( "player_on_minigun" );
	self.animname = "minigun";
	self assign_animtree();
	self thread minigun_used();
	
	for ( ;; )
	{
		for ( ;; )
		{
			// wait for the player to get on the turret
			if ( isdefined( self getturretowner() ) )
				break;
			wait( 0.05 );
		}

		level thread overheat_enable();

		flag_set( "player_on_minigun" );	
		
		for ( ;; )
		{
			if ( !isdefined( self getturretowner() ) )
				break;
			wait( 0.05 );
		}
		
		flag_clear( "player_on_minigun" );	
		level thread overheat_disable();	
		self.rumble_ent stoprumble("minigun_rumble");
	}
}

minigun_const()
{
	level.turret_heat_status = 1;
	level.turret_heat_max = 114;
	level.turret_cooldownrate = 15;
}

minigun_rumble()
{
	//push the rumble origin in and out based on the momentum
	closedist = 0;
	fardist = 750;
	
	between = fardist-closedist;
	
	self.rumble_ent = spawn("script_origin",self.origin);
	while(1)
	{
		wait .05;
		if( self.momentum <= 0 || !flag("player_on_minigun") )
		{
			continue;
		}
		//org = level.player geteye() + vector_multiply( vectornormalize(  anglestoforward( level.player getplayerangles() ) ), fardist - ( between * self.momentum ) );
		self.rumble_ent.origin = level.player geteye()+ (0,0,fardist - ( between * self.momentum ));
		self.rumble_ent PlayRumbleOnentity( "minigun_rumble" );
	}
}

minigun_used()
{
	flag_wait( "player_on_minigun" );	
	
	//Tweakable values	

	if( level.console )
		overheat_time = 6;	//full usage to overheat (original 8)
	else
		overheat_time = 10;
		
	cooldown_time = 4;	//time to cool down from max heat back to 0 if not operated during this time (original 4)
	penalty_time = 7;	//hold inoperative for this amount of time
	rate = 0.02;
	slow_rate = 0.02;
	overheat_fx_rate = 0.35;
	
	adsbuttonAccumulate = 0; //check for left trigger hold down duration
	
	//Not to tweak
	
	heatrate = 1 / ( overheat_time * 20 );	//increment of the temp gauge for heating up 
	coolrate = 1 / ( cooldown_time * 20 );	//increment of the temp gauge for cooling down
	level.inuse = false;
	momentum = 0;
	self.momentum = 0;
	heat = 0;
	max = 1;
	maxed = false;
	firing = false;
	maxed_time = undefined;
	overheated = false;
	penalized_time = 0;	//if greater than gettime
	startFiringTime = undefined;
	oldheat = 0;
	level.frames = 0;
	level.normframes = 0;
	next_overheat_fx = 0;
	thread minigun_rumble();
	for ( ;; )
	{
		level.normframes++;
		if ( flag( "player_on_minigun" ) )
		{
			if ( !level.inuse )
			{
				if ( level.Console )
				{
					//if ( level.player adsbuttonpressed() || ( level.player attackbuttonpressed() && !overheated ) )
					if ( level.player adsbuttonpressed() )
					{
						level.inuse = true;
						self thread minigun_sound_spinup();
					}
				}
				else
				if( level.player attackbuttonpressed() )
				{
						level.inuse = true;
						self thread minigun_sound_spinup();
				}
			}
			else
			{		
				if ( level.Console )
				{
					//if ( !level.player adsbuttonpressed() && !level.player attackbuttonpressed() )
					if ( !level.player adsbuttonpressed() )
					{
						level.inuse = false;
						self thread minigun_sound_spindown();	
					}
					else
					if( !level.player adsbuttonpressed() && level.player attackbuttonpressed() && overheated )
					{
						level.inuse = false;
						self thread minigun_sound_spindown();
					}
				}
				else
				if( !level.player attackbuttonpressed() )
				{
					level.inuse = false;
					self thread minigun_sound_spindown();
				}
				else
				if( level.player attackbuttonpressed() && overheated )
				{
					level.inuse = false;
					self thread minigun_sound_spindown();
				}
			}
			
			if( level.Console)
			{
				if( level.player adsbuttonpressed() )
				{
					adsbuttonAccumulate += 0.05;
					
					if( adsbuttonAccumulate >= 2.75 )
					{
						flag_set( "minigun_lesson_learned" );
					}
				}
				else
				{
					adsbuttonAccumulate = 0;
				}
			}
			
			if ( !firing )
			{
				if( level.player attackbuttonpressed() && !overheated && maxed )
				{
					firing = true;
					startFiringTime = gettime();
				}
				else
				if ( level.player attackbuttonpressed() && overheated )
				{
					firing = false;
					startFiringTime = undefined;
				}	
			}
			else
			{
				if( !level.player attackbuttonpressed() )
				{
					firing = false;
					startFiringTime = undefined;
				}
				
				if( level.player attackbuttonpressed() && !maxed )
				{
					firing = false;
					startFiringTime = undefined;
				}
			}
		}
		else
		{
			if( firing || level.inuse == true )
			{	
				self thread minigun_sound_spindown();
			}
			
			firing = false;
			level.inuse = false;
		}			
	
		if ( overheated )
		{
			if ( !(heat >= max) )
			{
				overheated = false;
				startFiringTime = undefined;
				self TurretFireEnable();
			}
		}

		if ( level.inuse )
		{
			momentum += rate;
			self.momentum = momentum;
		}
		else
		{
			momentum -= slow_rate;
			self.momentum = momentum;
		}
		
		if ( momentum > max )
		{
			momentum = max;
			self.momentum = momentum;
		}
		if ( momentum < 0 )
		{
			momentum = 0;
			self.momentum = momentum;
			self notify ( "done" );
		}

		if ( momentum == max )
		{
			maxed = true;
			maxed_time = gettime();
			self TurretFireEnable();
		}
		else
		{
			maxed = false;
			self TurretFireDisable();
		}

		if ( firing && !overheated )
		{
			level.frames++;
			heat += heatrate;
		}
		
		if( gettime() > penalized_time && !firing )
			heat -= coolrate;
		
		if ( heat > max )
				heat = max;
		if ( heat < 0 )
				heat = 0;
	
		level.heat = heat;
	
		level.turret_heat_status = int( heat * 114 );
		if ( isdefined( level.overheat_status2 ) )
			thread overheat_hud_update();
		
		if( (heat >= max) && (heat <= max) && ((oldheat < max) || (oldheat > max)) )
		{
			overheated = true;
			penalized_time = gettime() + penalty_time * 1000;
			next_overheat_fx = 0;
			thread overheat_overheated();
		}
		oldheat = heat;
		
		if ( overheated )
		{
			self TurretFireDisable();
			firing = false;
			//playfxOnTag( getfx( "turret_overheat_haze" ), self, "tag_flash");
			if ( gettime() > next_overheat_fx )
			{
				playfxOnTag( getfx( "turret_overheat_smoke" ), self, "tag_flash");
				next_overheat_fx = gettime() + overheat_fx_rate * 1000;
			}
		}

		self setanim( getanim( "spin" ), 1, 0.2, momentum );
		
		wait( 0.05 );
	}
}

minigun_sound_spinup()
{	
	level notify ( "stopMinigunSound" );
	level endon ( "stopMinigunSound" );
	
	/*
	Minigun_gatling_spinup1 0.6 s
	Minigun_gatling_spinup2 0.5 s
	Minigun_gatling_spinup3 0.5 s
	Minigun_gatling_spinup4 0.5 s
	*/
	
	if ( self.momentum < 0.25 )
	{
		self playsound( "minigun_gatling_spinup1" );
		wait 0.6;
		self playsound( "minigun_gatling_spinup2" );
		wait 0.5;
		self playsound( "minigun_gatling_spinup3" );
		wait 0.5;
		self playsound( "minigun_gatling_spinup4" );
		wait 0.5;
	}
	else
	if( self.momentum < 0.5 )
	{
		self playsound( "minigun_gatling_spinup2" );
		wait 0.5;
		self playsound( "minigun_gatling_spinup3" );
		wait 0.5;
		self playsound( "minigun_gatling_spinup4" );
		wait 0.5;
	}
	else
	if( self.momentum < 0.75 )
	{
		self playsound( "minigun_gatling_spinup3" );
		wait 0.5;
		self playsound( "minigun_gatling_spinup4" );
		wait 0.5;
	}
	else
	if( self.momentum < 1 )
	{
		self playsound( "minigun_gatling_spinup4" );
		wait 0.5;
	}
	
	thread minigun_sound_spinloop();
}

minigun_sound_spinloop()
{
	//Minigun_gatling_spinloop  (loops until canceled) 2.855 s
	
	level notify ( "stopMinigunSound" );
	level endon ( "stopMinigunSound" );
	
	while( 1 )
	{
		self playsound( "minigun_gatling_spin" );
		wait 2.5;
	}
}

minigun_sound_spindown()
{	
	level notify ( "stopMinigunSound" );
	level endon ( "stopMinigunSound" );
	
	/*
	Minigun_gatling_spindown4 0.5 s
	Minigun_gatling_spindown3 0.5 s
	Minigun_gatling_spindown2 0.5 s
	Minigun_gatling_spindown1 0.65 s
	*/
	
	if( self.momentum > 0.75 )
	{
		self stopsounds();
		self playsound( "minigun_gatling_spindown4" );
		wait 0.5;
		self playsound( "minigun_gatling_spindown3" );
		wait 0.5;
		self playsound( "minigun_gatling_spindown2" );
		wait 0.5;
		self playsound( "minigun_gatling_spindown1" );
		wait 0.65;
	}
	else
	if( self.momentum > 0.5 )
	{
		self playsound( "minigun_gatling_spindown3" );
		wait 0.5;
		self playsound( "minigun_gatling_spindown2" );
		wait 0.5;
		self playsound( "minigun_gatling_spindown1" );
		wait 0.65;
	}
	else
	if( self.momentum > 0.25 )
	{
		self playsound( "minigun_gatling_spindown2" );
		wait 0.5;
		self playsound( "minigun_gatling_spindown1" );
		wait 0.65;
	}
	else
	{
		self playsound( "minigun_gatling_spindown1" );
		wait 0.65;
	}
}

overheat_enable()
{
	//Draw the temperature gauge
	
	//level.turretOverheat = true;
	level thread overheat_hud();
	flag_clear( "disable_overheat" );
}

overheat_disable()
{
	//Erase the temperature gauge
	
	//level.turretOverheat = false;
	//level notify ( "disable_overheat" );
	flag_set( "disable_overheat" );
	level.savehere = undefined;
	
	waittillframeend;
	
	if (isdefined(level.overheat_bg))
		level.overheat_bg destroy();
	if (isdefined(level.overheat_status))
		level.overheat_status destroy();
	if (isdefined(level.overheat_status2))
		level.overheat_status2 destroy();
	if (isdefined(level.overheat_flashing))
		level.overheat_flashing destroy();
}

overheat_hud()
{
	//Draw the temperature gauge and filler bar components
	
	level endon ( "disable_overheat" );
	if ( !isdefined( level.overheat_bg ) )
	{
		level.overheat_bg = newhudelem();
		level.overheat_bg.alignX = "right";
		level.overheat_bg.alignY = "bottom";
		level.overheat_bg.horzAlign = "right";
		level.overheat_bg.vertAlign = "bottom";
		level.overheat_bg.x = 2;
		level.overheat_bg.y = -120;
		level.overheat_bg setShader("hud_temperature_gauge", 35, 150);
		level.overheat_bg.sort = 4;
	}
	
	barX = -10;
	barY = -152;
	
	//status bar
	if ( !isdefined( level.overheat_status ) )
	{
		level.overheat_status = newhudelem();
		level.overheat_status.alignX = "right";
		level.overheat_status.alignY = "bottom";
		level.overheat_status.horzAlign = "right";
		level.overheat_status.vertAlign = "bottom";
		level.overheat_status.x = barX;
		level.overheat_status.y = barY;
		level.overheat_status setShader("white", 10, 0);
		level.overheat_status.color = (1,.9,0);
		level.overheat_status.alpha = 0;
		level.overheat_status.sort = 1;
	}
	
	//draw fake bar to cover up a hitch
	
	if ( !isdefined( level.overheat_status2 ) )
	{
		level.overheat_status2 = newhudelem();
		level.overheat_status2.alignX = "right";
		level.overheat_status2.alignY = "bottom";
		level.overheat_status2.horzAlign = "right";
		level.overheat_status2.vertAlign = "bottom";
		level.overheat_status2.x = barX;
		level.overheat_status2.y = barY;
		level.overheat_status2 setShader("white", 10, 0);
		level.overheat_status2.color = (1,.9,0);
		level.overheat_status2.alpha = 0;
		level.overheat_status.sort = 2;
	}
	
	if ( !isdefined( level.overheat_flashing ) )
	{ 
		level.overheat_flashing = newhudelem();
		level.overheat_flashing.alignX = "right";
		level.overheat_flashing.alignY = "bottom";
		level.overheat_flashing.horzAlign = "right";
		level.overheat_flashing.vertAlign = "bottom";
		level.overheat_flashing.x = barX;
		level.overheat_flashing.y = barY;
		level.overheat_flashing setShader("white", 10, level.turret_heat_max);
		level.overheat_flashing.color = (.8,.16,0);
		level.overheat_flashing.alpha = 0;
		level.overheat_status.sort = 3;
	}
}

overheat_overheated()
{
	//Gun has overheated - flash full temp bar, do not drain
	
	level endon ( "disable_overheat" );
	if( !flag( "disable_overheat" ) )
	{
		level.savehere = false;
		level.player thread play_sound_on_entity ("smokegrenade_explode_default");
		
		level.overheat_flashing.alpha = 1;
		level.overheat_status.alpha = 0;
		level.overheat_status2.alpha = 0;
		
		level notify ( "stop_overheat_drain" );
		level.turret_heat_status = level.turret_heat_max;
		thread overheat_hud_update();
		
		for (i=0;i<4;i++)
		{
			level.overheat_flashing fadeovertime(0.5);
			level.overheat_flashing.alpha = 0.5;
			wait 0.5;
			level.overheat_flashing fadeovertime(0.5);
			level.overheat_flashing.alpha = 1.0;
		}
		level.overheat_flashing fadeovertime(0.5);
		level.overheat_flashing.alpha = 0.0;
		level.overheat_status.alpha = 1;
		wait 0.5;
		
		thread overheat_hud_drain();
		
		wait 2;
		level.savehere = undefined;
	}
}

overheat_hud_update()
{
	level endon ( "disable_overheat" );
	level notify ( "stop_overheat_drain" );
	
	if ( level.turret_heat_status > 1 )
		level.overheat_status.alpha = 1;
	else
	{
		level.overheat_status.alpha = 0;
		level.overheat_status fadeovertime( 0.25 );
	}
	
	if ( isdefined( level.overheat_status2 ) && level.turret_heat_status > 1 )
	{
		level.overheat_status2.alpha = 1;
		level.overheat_status2 setShader( "white", 10, int( level.turret_heat_status ) );
		level.overheat_status scaleovertime( 0.05, 10, int( level.turret_heat_status ) );
	}
	else
	{
		level.overheat_status2.alpha = 0;
		level.overheat_status2 fadeovertime( 0.25 );
	}
	
	//set color of bar
	overheat_setColor( level.turret_heat_status );
	
	wait 0.05;
	if ( isdefined( level.overheat_status2 ) )
		level.overheat_status2.alpha = 0;
	if ( isdefined( level.overheat_status ) && level.turret_heat_status < level.turret_heat_max )
		thread overheat_hud_drain();
}

overheat_setColor( value, fadeTime )
{
	level endon ("disable_overheat");
	
	//define what colors to use
	color_cold = [];
	color_cold[0] = 1.0;
	color_cold[1] = 0.9;
	color_cold[2] = 0.0;
	color_warm = [];
	color_warm[0] = 1.0;
	color_warm[1] = 0.5;
	color_warm[2] = 0.0;
	color_hot = [];
	color_hot[0] = 0.9;
	color_hot[1] = 0.16;
	color_hot[2] = 0.0;
	
	//default color
	SetValue = [];
	SetValue[0] = color_cold[0];
	SetValue[1] = color_cold[1];
	SetValue[2] = color_cold[2];
	
	//define where the non blend points are
	cold = 0;
	warm = (level.turret_heat_max / 2);
	hot = level.turret_heat_max;
	
	iPercentage = undefined;
	difference = undefined;
	increment = undefined;
	
	if ( (value > cold) && (value <= warm) )
	{
		iPercentage = int(value * (100 / warm));
		for ( colorIndex = 0 ; colorIndex < SetValue.size ; colorIndex++ )
		{
			difference = (color_warm[colorIndex] - color_cold[colorIndex]);
			increment = (difference / 100);
			SetValue[colorIndex] = color_cold[colorIndex] + (increment * iPercentage);
		}
	}
	else if ( (value > warm) && (value <= hot) )
	{
		iPercentage = int( (value - warm) * (100 / (hot - warm) ) );
		for ( colorIndex = 0 ; colorIndex < SetValue.size ; colorIndex++ )
		{
			difference = (color_hot[colorIndex] - color_warm[colorIndex]);
			increment = (difference / 100);
			SetValue[colorIndex] = color_warm[colorIndex] + (increment * iPercentage);
		}
	}
	
	if (isdefined( fadeTime ) )
		level.overheat_status fadeOverTime( fadeTime );
	
	if( isdefined( level.overheat_status.color ) )
		level.overheat_status.color = (SetValue[0], SetValue[1], SetValue[2]);
	
	if( isdefined( level.overheat_status2.color ) )
		level.overheat_status2.color = (SetValue[0], SetValue[1], SetValue[2]);
}

overheat_hud_drain()
{
	level endon ( "disable_overheat" );
	level endon ( "stop_overheat_drain" );
	
	waitTime = 1.0;
	for (;;)
	{
		if ( level.turret_heat_status > 1 )
			level.overheat_status.alpha = 1;
		
		value = level.turret_heat_status - level.turret_cooldownrate;
		thread overheat_status_rampdown( value, waitTime );
		if ( value < 1 )
			value = 1;
		level.overheat_status scaleovertime( waitTime, 10, int( value ) );
		overheat_setColor( level.turret_heat_status, waitTime );
		wait waitTime;
		
		if ( isdefined( level.overheat_status ) && level.turret_heat_status <= 1 )
			level.overheat_status.alpha = 0;
		
		if ( isdefined( level.overheat_status2 ) && level.turret_heat_status <= 1 )
			level.overheat_status2.alpha = 0;
	}
}

overheat_status_rampdown( targetvalue, time )
{
	level endon ( "disable_overheat" );
	level endon ( "stop_overheat_drain" );
	
	frames = (20 * time);
	difference = ( level.turret_heat_status - targetvalue );
	frame_difference = ( difference / frames );
	
	for ( i = 0; i < frames; i++ )
	{
		level.turret_heat_status -= frame_difference;
		if ( level.turret_heat_status < 1 )
		{
			level.turret_heat_status = 1;
			return;
		}
		wait 0.05;
	}
}

//script_anglevehicle = 1
//script_decel = 10000
//script_noteworthy = seaknight_land_location
//script_stopnode = 1 

seaknight()
{
	//seaknight_path = getent( "seaknight_path", "targetname" );
	//seaknight_land_location = getent( "seaknight_land_location", "script_noteworthy" );
	/*
	// make friends go to seaknight
	friends = getaiarray( "allies" );
	for ( i = 0 ; i < friends.size ; i++ )
		friends[ i ] set_force_color( "c" );
	getent( "seaknight_friendly_trigger", "targetname" ) notify( "trigger" );
	*/
	
	// spawn the helicopter
	level.seaknight1 = spawn_vehicle_from_targetname_and_drive( "rescue_chopper" );
	assert( isdefined( level.seaknight1 ) );
	
	wait 0.05;
	
	// make riders only crouch so their anims look good when they unload
	//seaknightRiders = level.seaknight1.riders;
	seaknightRiders = [];
	for( i = 0; i < level.seaknight1.riders.size; i++ )
	{
		if( level.seaknight1.riders[ i ].classname != "actor_ally_pilot_zach_woodland" )
			seaknightRiders[ seaknightRiders.size ] = level.seaknight1.riders[ i ];
			
		if( level.seaknight1.riders[ i ].classname == "actor_ally_hero_mark_woodland" )
		{
			level.griggs = level.seaknight1.riders[ i ];
			level.griggs.animname = "griggs";
		}
	}
	
	//assert( seaknightRiders.size == 5 );
	for ( i = 0 ; i < seaknightRiders.size ; i++ )
		seaknightRiders[ i ] thread seaknightRiders_standInPlace();
	
	flag_set( "no_more_grenades" );
	
	aAxis = getaiarray( "axis" );
	for( i = 0; i < aAxis.size; i++ )
	{
		aAxis[ i ].grenadeammo = 0;
	}
	
	flag_wait( "open_bay_doors" );
	
	wait 4;
	
	level.seaknight1 setanim( getanim_generic( "ch46_doors_open" ), 1 );	//target weight
	level.seaknight1 playsound( "seaknight_door_open" );
	
	//flag_wait( "reached_evac_point" );	//sea knight reaches landing spot
	
	wait 5;
	
	repulsor = Missile_CreateRepulsorEnt( level.seaknight1, 5000, 1500 );
	
	level.seaknight1.dontDisconnectPaths = true;
	//level.seaknight1 vehicle_detachfrompath();
	//level.seaknight1 vehicle_land();
	level.seaknight1 setHoverParams( 0, 0, 0 );
	
	wait 3.0;
	
	level.seaknight1 notify( "unload" );
	
	wait 4.5;
	
	level.playerSafetyBlocker delete();
	
	flag_set( "seaknight_can_be_boarded" );
	
	thread seaknight_griggs_speech();
	
	//level.seaknightFakeRamp show();
		
	iLoadNumber = 0;
	for(i=0;i<seaknightRiders.size;i++)
	{
		iLoadNumber++;
		seaknightRiders[ i ] thread vehicle_seaknight_idle_and_load_think( iLoadNumber );
		seaknightRiders[ i ] thread seaknight_riders_erase();
	}
	
	thread seaknight_departure_sequence();
	
	flag_wait( "player_made_it" );
	
	if ( isalive( level.player ) )
	{
		level.player EnableInvulnerability();
		level.player.attackeraccuracy = 0;
	}
	
	createthreatbiasgroup( "sas_evac_guy" );
	
	wait 0.25;
	
	redshirt1 = getent( "redshirt1", "targetname" );	
	redshirt1 thread seaknight_sas_load();
	level.sasSeaKnightBoarded++;
	
	redshirt2 = getent( "redshirt2", "targetname" );
	redshirt2 thread seaknight_sas_load();
	level.sasSeaKnightBoarded++;
	
	level.sasGunner thread seaknight_sas_load();
	level.sasSeaKnightBoarded++;
	
	level.price thread seaknight_sas_load();
	level.sasSeaKnightBoarded++;
	
	while( level.sasSeaKnightBoarded > 0 )
	{
		wait 0.1;
	}
	
	flag_set( "all_real_friendlies_on_board" );
	flag_set( "seaknight_guards_boarding" );
}

seaknight_departure_sequence()
{
	flag_wait( "seaknight_guards_boarding" );
	
	wait 10;
	
	if( !flag( "player_made_it" ) )
		wait 2;
	
	flag_set( "all_fake_friendlies_aboard" );
	
	//grace period
	
	if( !flag( "player_made_it" ) )
		wait 5;
	
	//Point of no return, late arrival check during grace period
	
	if( flag( "player_made_it" ) )
	{
		flag_wait( "all_real_friendlies_on_board" );
		
		//"All right we're all aboard!!! Go! Go!"
		level.player playsound( "villagedef_grg_wereallaboard" );
		wait 1;
	}
	else
	{
		//player can no longer trigger personal and live friendly boarding sequence
		flag_set( "seaknight_unboardable" );	
	}
	
	
	flag_set( "outtahere" );	//seaknight takes off
	
	wait 1.5;
	
	//"Ok we're outta here."
	thread countdown_speech( "outtahere" );
}

seaknight_sas_load()
{	
	self endon ( "death" );
	
	self.interval = 8;
	
	self setthreatbiasgroup( "sas_evac_guy" );
	
	setignoremegroup( "axis" , "sas_evac_guy" );	// allies ignore axis
	
	self.goalradius = 160;
	self.disableArrivals = true;
	self.ignoresuppression = true;
	self.ignoreAll = true;
	
	wait randomfloatrange( 1.5, 3.2 );
	
	fakeramp_startnode = getnode( "seaknight_fakeramp_startpoint", "targetname" );
	self setgoalnode( fakeramp_startnode );
	self waittill ( "goal" );
	
	if( isdefined( fakeramp_startnode.radius ) )
		self.goalradius = fakeramp_startnode.radius;
	
	fakeramp_endnode = getnode( "seaknight_fakeramp_end", "targetname" );
	self setgoalnode( fakeramp_endnode );
	self waittill ( "goal" );
	
	level.sasSeaKnightBoarded--;
	
	if ( isdefined( self.magic_bullet_shield ) )
		self stop_magic_bullet_shield();
	
	self delete();		
}

seaknight_griggs_speech()
{	
	flag_wait( "seaknight_can_be_boarded" );
	
	if( !flag( "lz_reached" ) )	//if heli arrives early
	{
		flag_wait( "lz_reached" );
	}
	else
	{
		wait 5.5;	//if player arrives early
	}
	
	//"Heard you guys needed a ride outta here!"
	level.griggs anim_single_queue( level.griggs, "needaride" );
	
	wait 0.45;
	
	//"Get on board! Move! Move!!"
	level.griggs anim_single_queue( level.griggs, "getonboard" );
	
	wait 2;
	
	//"Let's go! Let's go!"
	level.griggs anim_single_queue( level.griggs, "griggsletsgo" );
}

vehicle_seaknight_idle_and_load_think( iAnimNumber )
{
	self endon( "death" );
	
	flag_wait( "seaknight_guards_boarding" );
	
	sAnimLoad = "ch46_load_" + iAnimNumber;

	/*-----------------------
	LOAD INTO SEAKNIGHT AND DELETE
	-------------------------*/	
	
	level.seaknight1 anim_generic( self, sAnimLoad, "tag_detach" );
	
	self setGoalPos( self.origin );
	self.goalradius = 4;
	
	if( !flag( "player_made_it" ) )
	{
		//flag_wait( "outtahere" );
	
		self LinkTo( level.seaknight1, "tag_detach" );
	}
	
	flag_wait( "player_made_it" );
	
	wait 1;
	
	if ( isdefined( self.magic_bullet_shield ) )
		self stop_magic_bullet_shield();
		
	self delete();		
}

seaknight_riders_erase()
{
	if( isdefined( self.animname ) && self.animname == "griggs" )
		return;
	
	self endon ( "death" );
	
	flag_wait( "player_made_it" );
	
	wait 1;
	
	flag_wait( "all_fake_friendlies_aboard" );
	
	if ( isdefined( self.magic_bullet_shield ) )
			self stop_magic_bullet_shield();
	
	self delete();
}

deleteme()
{
	self delete();
}

seaknightRiders_standInPlace()
{
	if ( !isAI( self ) )
		return;
	self allowedStances( "crouch" );
	self thread hero();
	self waittill( "jumpedout" );
	self allowedStances( "crouch" );
	waittillframeend;
	self allowedStances( "crouch" );
	self.goalradius = 4;
	self pushPlayer( true );
	self.pushable = false;
	self setGoalPos( self.origin );
	self.grenadeawareness = 0;
	self.grenadeammo = 0;
	self.ignoresuppression = true;
	//self.ignoreall = true;
}

friendly_pushplayer( status )
{
	if( !isdefined( status ) )
		status = false;
	
	aAllies = getaiarray( "allies" );
	for( i = 0; i < aAllies.size; i++ )
	{
		if( status == "on" )
		{
			aAllies[ i ] pushplayer( true );
			aAllies[ i ].dontavoidplayer = true;
			aAllies[ i ].pushable = false;
		}
		else
		{
			aAllies[ i ] pushplayer( false );
			aAllies[ i ].dontavoidplayer = false;
			aAllies[ i ].pushable = true;
		}
	}
}