#include common_scripts\utility;
#include maps\_utility;

main()
{
	/*
	mortars = getentarray ("mortar","targetname");
	for (i=0;i<mortars.size;i++)
		mortars[i] thread burnville_style_mortar();

	if ( !(isdefined (level.mortar) ) )
		error ("level.mortar not defined. define in level script");
	
	thread generic_style_init();
	*/
}

hurtgen_style()
{
	// One mortar within x distance goes off every x seconds but not within x units of the player

	mortars = getentarray ("mortar","targetname");
	lastmortar = -1;

	for (i=0;i<mortars.size;i++)
	{
		mortars[i] setup_mortar_terrain();
	}
	if ( !(isdefined (level.mortar) ) )
		error ("level.mortar not defined. define in level script");

	level waittill ("start_mortars");

	while (1)
	{
		wait (1 + (randomfloat (2) ) );
		
		r = randomint (mortars.size);
		//println ("mortar size: ", mortars.size);
		//println ("r: ", r);
		for (i=0;i<mortars.size;i++)
		{
			c = (i + r) % mortars.size;
			//println ("current number: ", c);
			d = distance (level.player getorigin(), mortars[c].origin);
			d2 = undefined;
			if (isdefined (level.foley))
				d2 = distance (level.foley.origin, mortars[c].origin);
			else
				d2 = 360;
			if ( (d < 1600) && (d > 400) && (d2 > 350) && (c != lastmortar ) )
			{
				mortars[c] activate_mortar(400, 300, 25,undefined,undefined,undefined,false);
				lastmortar = c;
				if (d < 500)
					maps\_shellshock::main(4);
//					level.player shellshock("default", 4);
				break;
			}
		}
	}
}

railyard_style(fRandomtime, iMaxRange, iMinRange, iBlastRadius, iDamageMax, iDamageMin, fQuakepower, iQuaketime, iQuakeradius, targetsUsed, seedtime)
{
	// One mortar within iMaxRange distance goes off every (random + random) seconds but not within iMinRange units of the player
	// Terminate on demand by setting level.iStopBarrage != 0, operates indefinitely by default
	// Pass optional custom radius damage settings to activate_mortar()
	// Also pass optional custom earthquake settings to mortar_boom() via activate_mortar() if you want more shaking

	if (!isdefined(fRandomtime))
		fRandomtime = 7;
	if (!isdefined(iMaxRange))
		iMaxRange = 2200;
	if (!isdefined(iMinRange))
		iMinRange = 300;

	if (!isdefined(level.iStopBarrage))
		level.iStopBarrage = 0;

	if (!isdefined(targetsUsed))	//this allows railyard_style to get called again and not setup any terrain related stuff
		targetsUsed = 0;

	mortars = getentarray ("mortar","targetname");
	lastmortar = -1;

	for (i=0;i<mortars.size;i++)
	{
		if(isdefined(mortars[i].target) && (targetsUsed == 0))	//no target necessary, mortar will just play effect and sound
		{
			mortars[i] setup_mortar_terrain();
		}
	}
	if ( !(isdefined (level.mortar) ) )
		error ("level.mortar not defined. define in level script");

	if (isdefined(level.mortar_notify))
		level waittill (level.mortar_notify);

	for (;;)
	{
		if (level.iStopBarrage != 0)
			wait 1;
		while (level.iStopBarrage == 0)
		{
			if(isdefined(seedtime))
			{
				wait (seedtime + (randomfloat (fRandomtime) + randomfloat (fRandomtime) ));
			}
			else
			{
				wait (randomfloat (fRandomtime) + randomfloat (fRandomtime) );
			}
	
			r = randomint (mortars.size);
			//println ("mortar size: ", mortars.size);
			//println ("r: ", r);
			for (i=0;i<mortars.size;i++)
			{
				c = (i + r) % mortars.size;
				//println ("current number: ", c);
				d = distance (level.player getorigin(), mortars[c].origin);
				if ( (d < iMaxRange) && (d > iMinRange) && (c != lastmortar ) )
				{
					mortars[c] activate_mortar(iBlastRadius, iDamageMax, iDamageMin, fQuakepower, iQuaketime, iQuakeradius ,false);
					lastmortar = c;
					break;
				}
			}
		}
	}

	//println("MORTAR BARRAGE TERMINATED");
}


script_mortargroup_style()
{
	mortars = [];
	mortartrigs = [];
	level.mortars = [];
	models = getentarray ("script_model","classname");
	for(i=0;i<models.size;i++)
		if(isdefined(models[i].script_mortargroup))
		{
			if(!isdefined(level.mortars[models[i].script_mortargroup]))
				level.mortars[models[i].script_mortargroup] = [];

			mortar = spawnstruct();
			mortar.origin = models[i].origin;
			mortar.angles = models[i].angles;
			if(isdefined(models[i].targetname))
				mortar.targetname = models[i].targetname;
			if(isdefined(models[i].target))
				mortar.target = models[i].target;
			level.mortars[models[i].script_mortargroup]
			[level.mortars[models[i].script_mortargroup].size] = mortar;
			models[i] delete();

//			mortars[mortars.size] = models[i];
			
		}
	for (i=0;i<mortars.size;i++)
	{
		mortars[i] hide();
//		mortars[i] setup_mortar_terrain(); 		// this was commented out going to run it and find out just why
		mortars[i].has_terrain = false;  		
	}
	if ( !(isdefined (level.mortar) ) )
		level.mortar = loadfx ("explosions/artilleryExp_dirt_brown");

	triggers = array_combine(getentarray("trigger_multiple","classname"),getentarray("trigger_radius","classname"));
	for(i=0;i<triggers.size;i++)
		if(isdefined(triggers[i].script_mortargroup))
		{
			if(!isdefined(level.mortars[triggers[i].script_mortargroup]))
				level.mortars[triggers[i].script_mortargroup] = [];
			mortartrigs[mortartrigs.size] = triggers[i];
			
		}
	for(i=0;i<mortartrigs.size;i++)
	{
		mortartrigs[i].mortargroup = 0;
		mortartrigs[i] thread script_mortargroup_mortar_group();
	}
	
	lasttrig = undefined;
	while(1)
	{
		level waittill ("mortarzone",mortartrig);
		if(isdefined(lasttrig))
			lasttrig notify ("wait again");
		level.mortarzone = mortartrig.script_mortargroup;
		mortartrig thread script_mortargroup_mortarzone();
		lasttrig = mortartrig;

	}
}

script_mortargroup_mortarzone()
{
	lastblast = [];
	timer = gettime();
	timed = false;
	if(isdefined(self.script_timer))
	{
		level notify ("timed barrage");
		timer = gettime()+self.script_timer*1000;
		timed = true;		
	}
	if(isdefined(self.script_radius))
		mortar_radius = self.script_radius;
	else
		mortar_radius = 0;
		
	if(isdefined(self.script_delay_min) && isdefined(self.script_delay_max))
		customdelay = true;
	else
		customdelay = false;

	count = 0;
	nonbarragesize = 2;
	barragesize = 4;
	barraging = false;
	
	while((level.mortars[self.script_mortargroup].size > 0 && (level.mortarzone == self.script_mortargroup)) || timed)
	{
		if(customdelay)
		{
			wait (randomfloat(self.script_delay_max-self.script_delay_min)+self.script_delay_min);
		}
		else if(barraging)
		{
			if(count < barragesize)
			{
				wait( randomfloat(.5));
				count++;

			}
			else
			{
				count = 0;
				barragesize = 2+randomint(4);
				barraging = false;
				continue;
			}
		}
		else
		{
			if(count < nonbarragesize)
			{
				delay = randomFloat( 2 ) + 1;
				wait( delay );
				count++;
			}
			else
			{
				count = 0;
				barraging = true;
				nonbarragesize = randomint (2)+3;
				continue;
			}
			
		}	
		mortarsinfront = [];
		pick = randomint(level.mortars[self.script_mortargroup].size); 
		if(randomint(100) < 75)
		{
			playerforward = anglestoforward(level.player.angles);
			points = [];
			for(i=0;i<level.mortars[self.script_mortargroup].size;i++)
			{	
				if(mortar_radius > 0 && distance(level.player.origin,level.mortars[self.script_mortargroup][i].origin) > mortar_radius)
					continue;
				if(is_lastblast(level.mortars[self.script_mortargroup][i],lastblast))
					continue;
				normalvec = vectornormalize(level.mortars[self.script_mortargroup][i].origin-level.player.origin);
				if(vectordot(playerforward,normalvec) > 0.3)
					points[points.size] = i;
				
			}
			if(points.size > 0)
				pick = points[randomint(points.size)];
		}
		if(lastblast.size > 3)
			lastblast = [];
		lastblast[lastblast.size] = level.mortars[self.script_mortargroup][pick];
		level.mortars[self.script_mortargroup][pick] thread script_mortargroup_domortar();
//		self.groupedmortars = array_remove(self.groupedmortars,self.groupedmortars[pick]);
		if(timed && gettime() > timer)
		{
			if(isdefined(self.target))
			{
				target = getent(self.target,"targetname");
				if(isdefined(target))
				{
					target notify ("trigger");
					level notify ("timed barrage finished");
					
				}
			}
			break;
			
		}
	}
}

is_lastblast(mortar,lastblast)
{
	for(i=0;i<lastblast.size;i++)
		if(mortar == lastblast[i])
			return true;
	return false;
}

script_mortargroup_domortar()
{
	if(isdefined(self.targetname) && isdefined(level.mortarthread[self.targetname]))
		level thread [[level.mortarthread[self.targetname]]](self);
	else
		self thread activate_mortar(undefined, undefined, undefined, undefined, undefined, undefined , true);
	self waittill ("mortar");
	if(isdefined(self.target))
	{
		targ = getent(self.target,"targetname");
		if(isdefined(targ))
			targ notify ("trigger");
	}
}

script_mortargroup_mortar_group()
{
	while(1)
	{
		self waittill ("trigger");
		if(isdefined(level.mortarzone) && level.mortarzone == self.script_mortargroup)
			continue;
		level notify ("mortarzone", self);
		self waittill ("wait again");
		
	}
}

trigger_targeted()
{
	//While the player is touching a trigger named "mortartrigger" a targeted script_origin mortar with a defined
	//script_mortargroup value will go off every x seconds regardless of the players distance to the mortar.

	level.mortartrigger = getentarray ("mortartrigger","targetname");
	level.mortars = getentarray ("script_origin","classname");

	for (i=0;i<level.mortars.size;i++)
	{
		if (isdefined (level.mortars[i].script_mortargroup))
		{
			level.mortars[i] setup_mortar_terrain();
		}
	}

	level.lastmortar = -1;

	if ( !(isdefined (level.mortar) ) )
		error ("level.mortar not defined. define in level script");

	for (i=0;i<level.mortartrigger.size;i++)
	{
		thread trigger_targeted_mortars(i);
	}
}

trigger_targeted_mortars(num)
{
	targeted_mortars = getentarray (level.mortartrigger[num].target, "targetname");

	while(1)
	{
		if (level.player istouching (level.mortartrigger[num]))
		{
			r = randomint (targeted_mortars.size);
			while (r == level.lastmortar)
			{
				r = randomint (targeted_mortars.size);
				wait .1;
			}
			targeted_mortars[r] activate_mortar(undefined, undefined, undefined, undefined, undefined, undefined ,false);
			level.lastmortar = r;
		}
		wait (randomfloat (3) + randomfloat (4) );
	}
}

bog_style_mortar()
{
	//	script_structs are placed in the level and grouped with script_mortargroup with targetname "mortar"
	//	mortar group is turned on/off in script
	//	mortar locations will start going off randomly and wont go off within x units of the player
	//	each mortar location has script_fxid so it can play a set fx ( this allows having mortars on land and water in the same group )
	//	mortars will go forever until that group of mortars is notified to stop
	//	each mortar has a cooldown time of x seconds before it can be used again
	
	groups = [];
	groupNum = [];
	structs = getstructarray( "mortar", "targetname" );
	assert( isdefined( structs ) );
	assert( structs.size > 0 );
	for ( i = 0 ; i < structs.size ; i++ )
	{
		if ( !isdefined ( structs[ i ].script_mortargroup ) )
			continue;
		
		index = -1;
		groupNumber = int( structs[ i ].script_mortargroup );
		for ( p = 0 ; p < groups.size ; p++ )
		{
			if ( groupNumber != groupNum[ p ] )
				continue;
			
			index = p;
			break;
		}
		
		if ( index == -1 )
		{
			// new group
			groups[ groups.size ] = [];
			groupNum[ groupNum.size ] = groupNumber;
			index = groups.size - 1;
		}
		
		groups[ index ][ groups[ index ].size ] = structs[ i ];
	}
	
	for ( i = 0 ; i < groups.size ; i++ )
		thread bog_style_mortar_think( groups[ i ] );
	
	wait 0.05;
	
	array_thread( getentarray( "mortar_on", "targetname" ), ::bog_style_mortar_trigger, "on" );
	array_thread( getentarray( "mortar_off", "targetname" ), ::bog_style_mortar_trigger, "off" );
}

bog_style_mortar_think( mortars, groupNum )
{
	min = undefined;
	max = undefined;
	if ( isdefined( level.mortarMinInterval ) )
		min = level.mortarMinInterval;
	else
		min = 0.5;
	if ( isdefined( level.mortarMaxInterval ) )
		max = level.mortarMaxInterval;
	else
		max = 3;
	groupNum = int( mortars[ 0 ].script_mortargroup );
	for (;;)
	{
		level waittill ( "start_mortars " + groupNum );
		level thread bog_style_mortar_activate( mortars, groupNum, min, max );
	}
}

bog_style_mortar_activate( mortars, groupNum, min, max )
{
	level endon ( "start_mortars " + groupNum );
	level endon ( "stop_mortars " + groupNum );
	
	if( isdefined ( level.mortar_min_dist ) )
		min_dist = level.mortar_min_dist;
	else
		min_dist = 300;
	
	for (;;)
	{
		for(;;)
		{
			wait 0.05;
			rand = randomint( mortars.size );
			if ( isdefined ( mortars[ rand ].cooldown ) )
				continue;
			d = distance( level.player.origin, mortars[rand].origin );
			if ( d < min_dist )
				continue;
			// in case we need to see mortars in the distance
			if(!isdefined(level.noMaxMortarDist) && ( d > 1000 ))
				continue;
			if( ( isdefined( level.mortar_max_dist ) ) && ( d > level.mortar_max_dist ) )
				continue;
			//if we need to check player FOV
			if ( ( isdefined( level.mortarWithinFOV ) ) && ( mortars[ rand ] mortar_within_player_fov( level.mortarWithinFOV ) == false ) )
				continue;
			break;
		}
		if ( ( isdefined( level.noMortars ) ) && ( level.noMortars == true ) )
			return;
		mortars[ rand ] thread bog_style_mortar_explode();
		
		wait ( min + randomfloat( max - min ) );
	}
}

mortar_within_player_fov( fov )
{
	playerEye = level.player getEye();
	playerMortarFovOffset = ( 0, 0, 0 );
	if ( isdefined( level.playerMortarFovOffset ) )
		playerMortarFovOffset = level.playerMortarFovOffset;

	bInFOV = within_fov( playerEye, level.player getPlayerAngles() + playerMortarFovOffset, self.origin, fov );
	return bInFOV;
}



bog_style_mortar_explode( instant, customExploSound )
{
	if( !isdefined( instant ) )
		instant = false;
	
	self thread bog_style_mortar_cooldown();
	if ( !instant )
		self play_sound_in_space ( level.scr_sound[ "mortar" ][ "incomming" ] );
	if ( isdefined( customExploSound ) )
		self thread play_sound_in_space ( customExploSound );
	else
		self thread play_sound_in_space ( level.scr_sound[ "mortar" ][ self.script_fxid ] );
	
	//dont play an effect if it's behind the player - trying to save on particle effects
	setplayerignoreradiusdamage( true );
	radiusDamage ( self.origin, 250, 150, 50 );
	setplayerignoreradiusdamage( false );
	playfx ( level._effect[ "mortar" ][ self.script_fxid ], self.origin );
	
	if ( getdvarint( "bog_camerashake" ) > 0 )
	{
		//if player is trying to snipe dont do view shake
		if ( ( level.player getCurrentWeapon() == "dragunov" ) && ( level.player playerADS() > 0.8 ) )
			return;
		earthquake( 0.25, 0.75, self.origin, 1250 );
	}
}

bog_style_mortar_cooldown()
{
	self.cooldown = true;
	wait ( 3 + randomfloat ( 2 ) );
	self.cooldown = undefined;
}

bog_style_mortar_trigger( value )
{
	assert( isdefined( self.script_mortargroup ) );
	
	self waittill( "trigger" );
	
	if ( value == "on" )
		bog_style_mortar_on( self.script_mortargroup );
	else if ( value == "off" )
		bog_style_mortar_off( self.script_mortargroup );
}

bog_style_mortar_on( groupNum )
{
	level notify ( "start_mortars " + groupNum );
}

bog_style_mortar_off( groupNum )
{
	level notify ( "stop_mortars " + groupNum );
}

burnville_style_mortar()
{
	// Mortar waits for player to come within x units. Then explodes every x seconds if player is x range away
	level endon ("stop falling mortars");
	setup_mortar_terrain();

	wait (randomfloat (0.5) + randomfloat (0.5));

	while (1)
	{
		if (distance(level.player getorigin(), self.origin) < 600)
		{
			activate_mortar(undefined, undefined, undefined, undefined, undefined, undefined ,false);
			break;
		}
		wait (1);
	}

	wait (7 + randomfloat (20));

	while (1)
	{
		if ((distance(level.player getorigin(), self.origin) < 1200) &&
			(distance(level.player getorigin(), self.origin) > 400))
		{
			activate_mortar(undefined, undefined, undefined, undefined, undefined, undefined ,false);

			wait (3 + randomfloat (14));
		}

		wait (1);
	}
}

setup_mortar_terrain()
{
	self.has_terrain = false;
	if (isdefined (self.target))
	{
		self.terrain = getentarray (self.target, "targetname");
		self.has_terrain = true;
	}
	else
	{
		println ("z:          mortar entity has no target: ", self.origin);
	}

	if (!isdefined (self.terrain))
		println ("z:          mortar entity has target, but target doesnt exist: ", self.origin);

	if (isdefined (self.script_hidden) )
	{
		if (isdefined (self.script_hidden))
			self.hidden_terrain = getent (self.script_hidden, "targetname");
		else if ( (isdefined (self.terrain)) && (isdefined (self.terrain[0].target)) )
			self.hidden_terrain = getent (self.terrain[0].target, "targetname");
		
		if (isdefined (self.hidden_terrain) )
			self.hidden_terrain hide();
	}
	
	else if (isdefined (self.has_terrain))
	{
		if ( (isdefined (self.terrain)) && (isdefined (self.terrain[0].target)) )
			self.hidden_terrain = getent (self.terrain[0].target, "targetname");
		
		if (isdefined (self.hidden_terrain) )
			self.hidden_terrain hide();
	}		

}

activate_mortar (range, max_damage, min_damage, fQuakepower, iQuaketime, iQuakeradius , bIsstruct)
{
//	if(bIsstruct)
//	{
//		if(distance(self.origin,level.player.origin) < 1000)
//			incoming_sound( undefined, bIsstruct );
//	}
//	else
	incoming_sound( undefined, bIsstruct );

	level notify ("mortar");
	self notify ("mortar");
	

	if (!isdefined (range))
		range = 256;
	if (!isdefined (max_damage))
		max_damage = 400;
	if (!isdefined (min_damage))
		min_damage = 25;

	radiusDamage ( self.origin, range, max_damage, min_damage);

	if ((isdefined(self.has_terrain) && self.has_terrain == true) && (isdefined (self.terrain)))
	{
		for (i=0;i<self.terrain.size;i++)
		{
			if (isdefined (self.terrain[i]))
				self.terrain[i] delete();
		}
	}
	
	if (isdefined (self.hidden_terrain) )
		self.hidden_terrain show();
	self.has_terrain = false;
	
	mortar_boom( self.origin, fQuakepower, iQuaketime, iQuakeradius , undefined, bIsstruct);
}

mortar_boom(origin, fPower, iTime, iRadius, effect, bIsstruct)
{
	if (!isdefined(fPower))
		fPower = 0.15;
	if (!isdefined(iTime))
		iTime = 2;
	if (!isdefined(iRadius))
		iRadius = 850;


	thread mortar_sound(bIsstruct);

	if(isdefined(effect))
		playfx(effect, origin);
	else
		playfx(level.mortar, origin);
		
	earthquake(fPower, iTime, origin, iRadius);
	
	// Special Burnville Shell shocking
	if (level.script != "burnville")
		return;
	if (isdefined (level.playerMortar))
		return;
	if (distance (level.player.origin, origin) > 300)
		return;
	if (level.script == "carchase" || level.script == "breakout" )
		return;

	level.playerMortar = true;		
	level notify ("shell shock player",	iTime*4);
	maps\_shellshock::main(iTime*4);
//	level.player shellshock("default", iTime*4);
	

//	earthquake(0.15, 2, origin, 1050);
	/*
	earthquake(float scale, float duration, vector source, float radius)

	Example:
		player = getent("player", "classname");
		scale = 0.15;
		duration = 1;
		source = (866, 2240, 0);
		radius = 600;

		earthquake(scale, duration, source, radius);
	*/
}

mortar_sound(bIsstruct)
{
	if(!isdefined(level.mortar_last_sound))
		level.mortar_last_sound = -1;

	soundnum = randomint(3) + 1;
	while(soundnum == level.mortar_last_sound)
		soundnum = randomint(3) + 1;

	level.mortar_last_sound	= soundnum;
	
	if(!bIsstruct)
		self playsound ("mortar_explosion"+soundnum);
	else
		play_sound_in_space ("mortar_explosion"+soundnum,self.origin);
}

incoming_sound(soundnum , bIsstruct)
{
	currenttime = gettime();
	if(!isdefined(level.lastmortarincomingtime))
	{
		level.lastmortarincomingtime = currenttime;
	}
	else if((currenttime-level.lastmortarincomingtime) < 1000)
	{
		wait 1;
		return;
	}
	else
	{
		level.lastmortarincomingtime = currenttime;
	}	

	if (!isdefined (soundnum))
		soundnum = randomint(3) + 1;

	if (soundnum == 1)
	{
		if(bIsstruct)
			thread play_sound_in_space("mortar_incoming1",self.origin);
		else
			self playsound ("mortar_incoming1");
		wait (1.07 - 0.25);
	}
	else
	if (soundnum == 2)
	{
		if(bIsstruct)
			thread play_sound_in_space("mortar_incoming2",self.origin);
		else
			self playsound ("mortar_incoming2");
		wait (0.67 - 0.25);
	}
	else
	{
		if(bIsstruct)
			thread play_sound_in_space("mortar_incoming3",self.origin);
		else
			self playsound ("mortar_incoming3");
		wait (1.55 - 0.25);
	}
}

generic_style_init()
{
	level._explosion_iMaxRange = [];
	level._explosion_iMinRange = [];
	level._explosion_iBlastRadius = [];
	level._explosion_iDamageMax = [];
	level._explosion_iDamageMin = [];
	level._explosion_fQuakePower = [];
	level._explosion_iQuakeTime = [];
	level._explosion_iQuakeRadius = [];
}

generic_style_setradius (strExplosion, iMinRange, iMaxRange)
{
	level._explosion_iMinRange[strExplosion] = iMinRange;
	level._explosion_iMaxRange[strExplosion] = iMaxRange;	
}

generic_style_setdamage (strExplosion, iBlastRadius, iDamageMin, iDamageMax)
{
	level._explosion_iBlastRadius[strExplosion] = iBlastRadius;
	level._explosion_iDamageMin[strExplosion] = iDamageMin;
	level._explosion_iDamageMax[strExplosion] = iDamageMax;
}

generic_style_setquake (strExplosion, fQuakePower, iQuakeTime, iQuakeRadius)
{
	level._explosion_fQuakePower[strExplosion] = fQuakePower;
	level._explosion_iQuakeTime[strExplosion] = iQuakeTime;
	level._explosion_iQuakeRadius[strExplosion] = iQuakeRadius;
}

// REQUIRED: level._effect[strExplosion] 		= loadfx(...);
// REQUIRED: level._effectType[strExplosion]	= strType ("mortar", "bomb" or "artillery")

// Allows for multiple sets of explosions in a single level
// One explosion within iMaxRange distance goes off every (random + random) seconds but not within iMinRange units of the player
// Starts on notify specified by level.explosion_start[strExplosion]
// Terminates on notify specified by level.explosion_stop[strExplosion]
// Terminate on demand by setting level.bStopBarrage[strExplosion] == true, operates indefinitely by default
generic_style (strExplosion, fDelay, iBarrageSize, fBarrageDelay, iMinRange, iMaxRange, bTargetsUsed)
{
	//// Safety checks
	assertex((isdefined (strExplosion) && (strExplosion != "")), "strExplosion not passed. pass in level script");
	assertex((isdefined (level._effect) && isdefined (level._effect[strExplosion])), "level._effect[strMortars] not defined. define in level script");

	//// Initialize Defaults
	iLastExplosion = -1;
	iMaxRangeLocal = iMaxRange;
	iMinRangeLocal = iMinRange;

	generic_style_setradius(strExplosion, 300, 2200);
	
	if (!isdefined (fDelay))
		fDelay = 7;
		
	if (!isdefined (iBarrageSize))
		iBarrageSize = 1;
		
	if (!isdefined (fBarrageDelay))
		fBarrageDelay = 0;

	if (!isdefined (bTargetsUsed))	//this allows generic_style to get called again and not setup any terrain related stuff
		bTargetsUsed = false;

	if (isdefined (level.explosion_stopNotify) && isdefined (level.explosion_stopNotify[strExplosion]))
		level endon (level.explosion_stopNotify[strExplosion]);

	// for backwards compatibility
	if (!isdefined (level.bStopBarrage) || !isdefined (level.bStopBarrage[strExplosion]))
		level.bStopBarrage[strExplosion] = false;

	//// Explosion Points
	aeExplosions = getentarray (strExplosion, "targetname");

	//// Terrain Setup
	for (i = 0; i < aeExplosions.size; i++)
	{
		if(isdefined (aeExplosions[i].target) && (!bTargetsUsed))	//no target necessary, mortar will just play effect and sound
			aeExplosions[i] setup_mortar_terrain();
	}

	//// Start Wait
	if (isdefined (level.explosion_startNotify) && isdefined (level.explosion_startNotify[strExplosion]))
		level waittill (level.explosion_startNotify[strExplosion]);

	//// Main Loop
	while ( true )
	{
		while ( !level.bStopBarrage[strExplosion] )
		{
			for (j = 0; j < iBarrageSize; j++)
			{
				// putting this here allows for updates during barrage
				if (!isdefined (iMaxRange))
					iMaxRangeLocal = level._explosion_iMaxRange[strExplosion];		
				if (!isdefined (iMinRange))
					iMinRangeLocal = level._explosion_iMinRange[strExplosion];
			
				iRand = randomint (aeExplosions.size);
				for (i = 0; i < aeExplosions.size; i++)
				{
					iCur = (i + iRand) % aeExplosions.size;
					fDist = distance (level.player getorigin(), aeExplosions[iCur].origin);
					if ( (fDist < iMaxRangeLocal) && (fDist > iMinRangeLocal) && (iCur != iLastExplosion ) )
	//				if ( (fDist < iMaxRangeLocal) && (fDist > iMinRangeLocal))
					{
						aeExplosions[iCur].iMinRange = iMinRangeLocal;
						aeExplosions[iCur] explosion_activate (strExplosion);
						iLastExplosion = iCur;
						break;
					}
				}
				iLastExplosion = -1;
				if (isdefined (level.explosion_delay) && isdefined (level.explosion_delay[strExplosion]))
					wait (level.explosion_delay[strExplosion]);
				else
					wait (randomfloat (fDelay) + randomFloat (fDelay));
			}
			if (isdefined (level.explosion_barrage_delay) && isdefined (level.explosion_barrage_delay[strExplosion]))
				wait (level.explosion_barrage_delay[strExplosion]);
			else
				wait (randomfloat (fBarrageDelay) + randomFloat (fBarrageDelay));
		}
		wait (0.05);
	}
}

explosion_activate (strExplosion, iBlastRadius, iDamageMin, iDamageMax, fQuakePower, iQuakeTime, iQuakeRadius)
{
	//// Initialize Defaults
	generic_style_setdamage(strExplosion, 256, 25, 400);
	generic_style_setquake(strExplosion, 0.15, 2, 850);
	
	if (!isdefined (iBlastRadius))
		iBlastRadius = level._explosion_iBlastRadius[strExplosion];
	if (!isdefined (iDamageMin))
		iDamageMin = level._explosion_iDamageMin[strExplosion];
	if (!isdefined (iDamageMax))
		iDamageMax = level._explosion_iDamageMax[strExplosion];

	if (!isdefined (fQuakePower))
		fQuakePower = level._explosion_fQuakePower[strExplosion];
	if (!isdefined (iQuakeTime))
		iQuakeTime = level._explosion_iQuakeTime[strExplosion];
	if (!isdefined (iQuakeRadius))
		iQuakeRadius = level._explosion_iQuakeRadius[strExplosion];

	//// Incoming Sound
	explosion_incoming (strExplosion);

	level notify ("explosion", strExplosion);

	bDoDamage = true;
	fPreDist = undefined;
	eLocation = self;
	if (isdefined (self.iMinRange) && distance (level.player.origin, self.origin) < self.iMinRange)
	{
		// get closest location outside iMinRange
		aeExplosions = getentarray (strExplosion, "targetname");
		for (iCur=0; iCur < aeExplosions.size; iCur++)
		{
			fDist = distance (level.player getorigin(), aeExplosions[iCur].origin);
			if (fDist > self.iMinRange)
			{
				if (!isdefined(fPreDist) || fDist < fPreDist)
				{
					fPreDist = fDist;
					eLocation = aeExplosions[iCur];
				}
			}
		}
		if (!isdefined(fPreDist))
		{
			bDoDamage = false;
		}
	}

	if (bDoDamage)
		radiusDamage (eLocation.origin, iBlastRadius, iDamageMax, iDamageMin);

	//// Process Terrain
	if ((isdefined(eLocation.has_terrain) && eLocation.has_terrain == true) && (isdefined (eLocation.terrain)))
	{
		for (i=0;i<eLocation.terrain.size;i++)
		{
			if (isdefined (eLocation.terrain[i]))
				eLocation.terrain[i] delete();
		}
	}
	
	if (isdefined (eLocation.hidden_terrain) )
		eLocation.hidden_terrain show();
	eLocation.has_terrain = false;
	
	//// Explosion Effects
	eLocation explosion_boom (strExplosion, fQuakePower, iQuakeTime, iQuakeRadius);
}

explosion_boom (strExplosion, fPower, iTime, iRadius)
{
	if (!isdefined(fPower))
		fPower = 0.15;
	if (!isdefined(iTime))
		iTime = 2;
	if (!isdefined(iRadius))
		iRadius = 850;

	explosion_sound (strExplosion);

	explosion_origin = self.origin;

	playfx (level._effect[strExplosion], explosion_origin);
	earthquake(fPower, iTime, explosion_origin, iRadius);
	
	if (distance (level.player.origin, explosion_origin) > 300)
		return;
	if (level.script == "carchase" || level.script == "breakout" )
		return;

	level.playerMortar = true;		
	level notify ("shell shock player",	iTime * 4);
	maps\_shellshock::main(iTime*4);
}

explosion_sound(strExplosion)
{
	if (!isdefined (level._explosion_last_sound))
		level._explosion_last_sound = 0;

	soundnum = randomint(3) + 1;
	while (soundnum == level._explosion_last_sound)
		soundnum = randomint(3) + 1;

	level._explosion_last_sound = soundnum;

	if (level._effectType[strExplosion] == "mortar")
	{
		switch (soundnum)
		{
		case 1:
			self playsound ("mortar_explosion1");
			break;
		case 2:
			self playsound ("mortar_explosion2");
			break;
		case 3:
			self playsound ("mortar_explosion3");
			break;
		}
	}
	else if (level._effectType[strExplosion] == "artillery")
	{
		switch (soundnum)
		{
		case 1:
			self playsound ("mortar_explosion4");
			break;
		case 2:
			self playsound ("mortar_explosion5");
			break;
		case 3:
			self playsound ("mortar_explosion1");
			break;
		}
	}
	else if (level._effectType[strExplosion] == "bomb")
	{
		switch (soundnum)
		{
		case 1:
			self playsound ("mortar_explosion1");
			break;
		case 2:
			self playsound ("mortar_explosion4");
			break;
		case 3:
			self playsound ("mortar_explosion5");
			break;
		}
	}
}

explosion_incoming(strExplosion, soundnum)
{
	if (!isdefined (level._explosion_last_incoming))
		level._explosion_last_incoming = -1;

	soundnum = randomint(4) + 1;
	while (soundnum == level._explosion_last_incoming)
		soundnum = randomint(4) + 1;

	level._explosion_last_incoming	= soundnum;

	if (level._effectType[strExplosion] == "mortar")
	{
		switch (soundnum)
		{
		case 1:
			self playsound ("mortar_incoming1");
			wait (1.07 - 0.25);
			break;
		case 2:
			self playsound ("mortar_incoming2");
			wait (0.67 - 0.25);
			break;
		case 3:
			self playsound ("mortar_incoming3");
			wait (1.55 - 0.25);
			break;
		default:
			wait (1.75);
			break;
		}
	}
	else if (level._effectType[strExplosion] == "artillery")
	{
		switch (soundnum)
		{
		case 1:
			self playsound ("mortar_incoming4");
			wait (1.07 - 0.25);
			break;
		case 2:
			self playsound ("mortar_incoming4_new");
			wait (0.67 - 0.25);
			break;
		case 3:
			self playsound ("mortar_incoming1_new");
			wait (1.55 - 0.25);
			break;
		default:
			wait (1.75);
			break;
		}
	}
	else if (level._effectType[strExplosion] == "bomb")
	{
		switch (soundnum)
		{
		case 1:
			self playsound ("mortar_incoming2_new");
			wait (1.75);
			break;
		case 2:
			self playsound ("mortar_incoming3_new");
			wait (1.75);
			break;
		case 3:
			self playsound ("mortar_incoming4_new");
			wait (1.75);
			break;
		default:
			wait (1.75);
			break;
		}
	}
}
