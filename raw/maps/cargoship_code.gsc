#include common_scripts\utility;
#include maps\_utility;
#include maps\_anim;
#include maps\mo_tools;
#include maps\_hud_util;

stairs()
{
	while(1)
	{
		self waittill("trigger", other);
			
		other thread stairs_proc(self);
	}
}

stairs_proc(trigger)
{
	self endon("death");
	
	if( isdefined(self.beforestairs_moveplaybackrate) )
		return;
	
	if( isdefined(self.cqbwalking) && self.cqbwalking )
		return;
	
	self.beforestairs_moveplaybackrate = self.moveplaybackrate;
	
	self.moveplaybackrate = .64;
		
	while( self istouching(trigger) )
		wait .05;
	
	self.moveplaybackrate = self.beforestairs_moveplaybackrate;
	
	wait .2;
	self.beforestairs_moveplaybackrate = undefined;
}

escape_debri()
{
	trigger = undefined;
	dist = undefined;
	range = undefined;
	
	switch( self.script_noteworthy )
	{
		case "panel_mid":
			trigger = "lead";
			dist = 500; 
			range = 1;
			break;
		case "panel_high":
			trigger = "last";
			dist = 300;	
			range = 2;
			break;
		case "pole_mid":
			trigger = "lead";
			dist = 768;	
			range = 1;
			break;
		default:
			return;
	}
	
	distsqrd = dist * dist;
	
	if( !isdefined( self.target ) )
	{
		self delete();	
		return;
	}
		
	self escape_debri_wait( trigger, distsqrd );
	self thread escape_debri_launch( range );
}

escape_debri_wait( trigger, distsqrd)
{
	//level endon("escape_cargohold1_enter");
		
	pack = [];
	pack[ pack.size ] = level.heroes3["price"];
	pack[ pack.size ] = level.heroes3["alavi"];
	pack[ pack.size ] = level.heroes3["grigsby"];
	
	while(1)
	{
		order = escape_heroes_findorder( pack );
		if( distancesquared( order[ trigger ].origin, self getorigin() ) < distsqrd )
			break;
		wait .05;
	}
}

escape_debri_launch( range )
{		
	wait randomfloat( range );
	
	
	vec = anglestoright( (0,180,0) );
	vec = vector_multiply(vec, 10000);
	
	model = getent(self.target, "targetname");
	model show();
	
	self delete();	
	
	thread play_sound_in_space( "cgoship_panel_break_away", model.origin );
	model physicslaunch(model.origin + (randomfloatrange(-30,30), -10 , -20 ), vec);
}

escape_event()
{	
	type 	= "fx";
	fx 		= undefined;
	oneshotsnd = undefined; 
	loopsnd	= undefined;
	
	quake 	= 0;
	flags 	= undefined;
	
	delay 	= 0;
	
	rotang	= undefined;
	rottime	= undefined;
	rotacc	= undefined;
	rotdec 	= undefined;
	
	targets = undefined;
	gravity = -500;
	
	attr = strtok(self.script_parameters, ":;,= ");
	for(i=0; i<attr.size; i++)
	{
		switch( tolower( attr[i] ) )
		{
			 case "type":
			 	i++;
			 	type = attr[i];
			 	break;
			 case "quake":	
			 	i++;
			 	if( tolower( attr[i] ) == "true" )
			 		quake = 1;
			 	else if(tolower( attr[i] ) == "playeronly" )
			 		quake = 2;
			 	break;
			 case "fx":
			 	i++;
			 	fx = attr[i];
			 	break;
			 case "snd":
			 	i++;
			 	loopsnd = attr[i];
			 	break;
			 case "sndloop":
			 	i++;
			 	loopsnd = attr[i];
			 	break;
			 case "sndoneshot":
			 	i++;
			 	oneshotsnd = attr[i];
			 	break;
			 case "flag":
			 	i++;
			 	flags = attr[i];
			 	break;
			 case "rotang":
			 	i++;
			 	rotang = ( int(attr[i]), int(attr[i+1]), int(attr[i+2]) );
			 	i+=2;
			 	break;
			 case "delay":
			 	i++;
			 	miliseconds = int(attr[i]);
			 	delay = miliseconds * .001;
			 	break;
			 case "rottime":
			 	i++;
			 	miliseconds = int(attr[i]);
			 	rottime = miliseconds * .001;
			 	break;
			 case "rotacc":
			 	i++;
			 	miliseconds = int(attr[i]);
			 	rotacc = miliseconds * .001;
			 	break;
			 case "rotdec":
			 	i++;
			 	miliseconds = int(attr[i]);
			 	rotdec = miliseconds * .001;
			 	break;
		}
	}
	
	self waittill("trigger");
	wait ( delay );
	
	switch(type)
	{
		case "fx":
			targets = getstructarray(self.target, "targetname");
			for(i=0; i<targets.size; i++)
			{
				fxnode = spawn("script_model", targets[i].origin);
				fxnode.angles = targets[i].angles;
				fxnode setmodel("tag_origin");
				fxnode hide();
				
				switch(fx)
				{
					case "event_waterleak":
						if( isdefined( targets[i].target ) )
						{
							trig = getent( targets[i].target, "targetname" );
							trig thread escape_event_waterleak_blur();
						}
						break;	
				}
				
				fxnode thread escape_event_fx(fx, oneshotsnd, loopsnd, flags);
			}
			break;	
		case "cargocontainer":
			model = getent(self.target, "targetname");
						
			magnitude 	= gravity;
			offset 		= ( 0,0,90 );
			contact 	= undefined;
			velocity 	= undefined;
		
			if( model.angles != (0,90,0) && model.angles != (0,270,0) )
			{
				velocity1  = vector_multiply( anglestoup( (0,360,0) ), 4);
				velocity2	= vector_multiply( anglestoright( (0,360,0) ), -1);
				velocity = vectornormalize(velocity1 + velocity2);
				magnitude *= 800;
				dir = anglestoright( (0,360,0) );
				dir = vector_multiply(dir, 64);
				contact = model.origin + dir;
			}
			else
			{
				velocity1 	= anglestoup(level._sea_org.angles);
				velocity2	= vector_multiply( anglestoright( level._sea_org.angles ), -1 );
				contact 	= model.origin + offset;
				velocity = vectornormalize(velocity1 + velocity2);
			}
								
			velocity = velocity * (magnitude * .75);
			model physicsLaunch( contact, velocity );
			break;
		case "physics":
			targets = getentarray(self.target, "targetname");
			for(i=0; i<targets.size; i++)
			{
				magnitude 	= gravity;
				offset 		= ( randomfloat(20),randomfloat(20),randomfloat(20) );
				contact 	= targets[i].origin + offset;
				velocity 	= anglestoup(level._sea_org.angles);
																
				velocity = velocity * magnitude;
				targets[i] physicsLaunch( contact, velocity );
			}
			break;	
		case "rotate":
			targets = getentarray(self.target, "targetname");
			for(i=0; i<targets.size; i++)
			{
				if( isdefined(targets[i].target) )
				{
					attachments = getentarray(targets[i].target, "targetname");
					for(j=0; j<attachments.size; j++)
						attachments[j] linkto( targets[i] );	
				}
				oneshotsnd = loopsnd;
				targets[i] thread escape_event_rotate( oneshotsnd, rotdec, rotacc, rotang, rottime );
			}
			break;
	}
	
	
	if(!quake)
		return;
	
	if(quake > 1)
	{
		earthquake(0.25, .75, level.player.origin, 1024);
		level.player PlayRumbleOnEntity( "tank_rumble" );
		return;
	}
	
	if( distance(level.player.origin, self.origin) < 700 )
	{
		earthquake(0.4, 1.25, level.player.origin, 1024);
		thread escape_event_player();
	}
		
	if(!isdefined(level.escape_stumble_num) )
		level.escape_stumble_num = 1;
	
	keys = getarraykeys( level.heroes3 );
	for(i=0; i<keys.size; i++)
	{
		key = keys[i];
		level.heroes3[ key ] thread escape_event_ai(level.escape_stumble_num);	
		if(level.escape_stumble_num < 3)
			level.escape_stumble_num++;
		else
			level.escape_stumble_num = 1;
	}
		
	array_wait(level.heroes3, "done_stumbling");
	level notify("let player up");
}

escape_event_rotate( snd, rotdec, rotacc, rotang, rottime )
{
	if(isdefined(snd))
		self thread play_sound_on_entity(snd);
		
	ang = self.angles;
	
	if(isdefined(rotdec))
		self rotateto(rotang, rottime, rotacc, rotdec);
	else if(isdefined(rotacc))
		self rotateto(rotang, rottime, rotacc);
	else
	{
		self rotateto(rotang, rottime);
		wait rottime;
		//now bounch
		newang = ang + vector_multiply(rotang, .3);
		newtime = rottime * .5;
		self rotateto(newang, newtime, 0, newtime);
		wait newtime;
		self rotateto(rotang, newtime, newtime, 0);
	}
}

escape_event_waterleak_blur()
{
	self endon("death");
	
	dist = 32;
	distsqrd = dist * dist;
	
	while(1)
	{
		self waittill("trigger");			
		setblur( 2.4, .15 );
		
		while( level.player istouching(self) )
			wait .1;

		wait .1;
							
		setblur( 0, .15 );
	}
}

escape_event_fx(fx, oneshotsnd, loopsnd, flags)
{
	playfxontag(level._effect[fx], self, "tag_origin");
		
	self thread escape_event_sndfx(oneshotsnd, loopsnd);
	if( !isdefined(flags) )
		return;
	
	if( fx == "event_waterleak" )
		self _playloopsound( "cgo_water_breach_large_loop" );
	
	flag_wait(flags);
	
	self stoploopsound();
	waittillframeend;
	self delete();
}

escape_event_sndfx(oneshotsnd, loopsnd)
{
	if(isdefined(oneshotsnd))
		self play_sound_on_entity(oneshotsnd);
	if(isdefined(loopsnd))
		self play_sound_on_entity(loopsnd);
}

escape_event_ai(num)
{
	name = "stumble" + num;
	self.springleak = true;
	
	length = getanimlength( level.scr_anim[self.animname][name]);
	self thread anim_single_solo(self, name);
	
	wait length - .2;
	self stopanimscripted();
	self notify("single_anim_done");
	
	self notify("done_stumbling");
	self.springleak = false;
}

escape_event_player()
{
	level.player allowStand(false);
	level.player allowProne(false);
	level.player setstance( "crouch" );
	level.player setvelocity( (0,1,0) );
	player_speed_set(135, .1);
	delayThread(.5, ::player_speed_set, 185, 2.5);
	level.player PlayRumbleOnEntity( "tank_rumble" );
	delayThread(.05, ::blur_overlay, 2.4, .25);
	delayThread(.3, ::blur_overlay, 0, .5);
	level.player delayThread(.1, ::play_sound_on_entity, "breathing_hurt");
	
	level waittill("let player up");
	level.player delayThread(.1, ::play_sound_on_entity, "breathing_better");
	
	level.player allowStand(true);
	level.player allowProne(true);
	level.player setstance( "stand" );
}

escape_player_last_quake()
{
	level.player setvelocity( (0,90,0) );

	earthquake(0.25, .75, level.player.origin, 1024);

	player_speed_set(110, .1);
	delayThread(.25, ::player_speed_set, 160, 2);
	level.player PlayRumbleOnEntity( "tank_rumble" );
}

misc_light_flicker( fxname, fxflag, startflag )
{
	minDelay = .25;
	maxDelay = .45;
	on = self getLightIntensity();
	off = 0;
	offmodel = undefined;
	onmodel = undefined;
	curr = on;
	num = 0;
	modelswap = false;
	fxswap = false;
	fxlight = undefined;
	
	if( isdefined( fxname ) )
	{
		fxarray = getfxarraybyID( fxname );
		fxlight = getClosestFx(self.origin, fxarray);
		fxswap = true;
	}
	
	modelarray = getentarray("script_lightmodel", "targetname");
	model = getClosest(self.origin, modelarray, 32);
	
	if( isdefined(model) )
	{
		onmodel = model.model;
		modelswap = true;
		switch(onmodel)
		{
			case "com_lightbox_on":
				offmodel = "com_lightbox";
				break;	
			case "ch_industrial_light_02_on":
				offmodel = "ch_industrial_light_02_off";
				break;	
			case "me_lightfluohang_on":
				offmodel = "me_lightfluohang";
				break;	
		}
	}
	
	if(isdefined( startflag ))
		flag_wait( startflag );
	
	while( 1 )
	{
		num = randomintrange(1, 10);
		while( num )
		{
			wait( randomfloatrange(.05, .1) );
			
			if(curr == on)
			{
				curr = off;
				self setLightIntensity(off);
				if(fxswap)
					fxlight pauseEffect();
				if(modelswap)
					model setmodel(offmodel);
			}
			else if( flag(fxflag) )
			{
				curr = on;
				self setLightIntensity(on);
				if(fxswap)
					fxlight restartEffect();
				if(modelswap)
					model setmodel(onmodel);
			}		
			else 
				flag_wait(fxflag);	
						
			num--;			
		}
			
		wait( randomfloatrange( minDelay, maxDelay ) );
	}
}

escape_heroes_holdtheline_run_or_walk_asone( order )
{		
	if( order["last"].run_speed_state == "sprint")
	{
		switch(self.position)
		{
			case "lead":
				if( distance(self.origin, order["middle"].origin) < self.aimaxdist )
					self.dist = order["last"].dist;
				break;
			case "middle":
				if( distance(self.origin, order["last"].origin) < self.aimaxdist )
					self.dist = order["last"].dist;
				break;
		}
	}	
	
	else if(order["lead"].run_speed_state == "jog")
	{
		switch(self.position)
		{
			case "middle":
				if( distance(self.origin, order["lead"].origin) < self.aimaxdist )
					self.dist = order["lead"].dist;
				break;
			case "last":
				if( distance(self.origin, order["middle"].origin) < self.aimaxdist )
					self.dist = order["lead"].dist;
				break;
		}
	}	
}

escape_heroes_holdtheline_stay_in_single_file( order )
{	
	compare = undefined;
	
	switch(self.position)
	{
		case "lead":
			compare = order[ "middle" ];
			break;
		case "middle":	
			compare = order[ "last" ];
			break;
	}
	
	self escape_heroes_holdtheline_adjust_rate_vs_ai( compare );
}

escape_heroes_holdtheline_adjust_rate_vs_ai( compare )
{
	if( isdefined(compare) )
	{
		if( distance(self.origin, compare.origin) < self.aimindist )
		{
			if( self.moveplaybackrate < 1.4)
				self.moveplaybackrate += .05;
		}
		else if( distance(self.origin, compare.origin) > self.aimaxdist)
		{
			if( self.moveplaybackrate > .81)
				self.moveplaybackrate -= .05;
		}
	}
	else if ( self.run_speed_state == "sprint"  && self.moveplaybackrate <  self.aimaxsprintrate)
		self.moveplaybackrate =  self.aimaxsprintrate;
	
	else if ( self.run_speed_state == "jog"  && self.moveplaybackrate > self.aiminjograte)
		self.moveplaybackrate -= .05;
	
	else if( self.moveplaybackrate < 1)
		self.moveplaybackrate += .05;
	else if( self.moveplaybackrate > 1)
		self.moveplaybackrate -= .05;
}

escape_heroes_holdtheline_decide_jog_run_sprint( pushdist, sprintdist )
{
	if ( self.dist < sprintdist )
	{							
		// sprint when player is inside half push dist or ai is not ahead of player.
		if ( self.run_speed_state == "sprint" || self.springleak == true)
			return;
		
		self.run_speed_state = "sprint";
		
		if( isdefined( level.escape_run_section ) )
			self set_generic_run_anim( level.current_run[ level.escape_run_section ][ self.run_speed_state ] );	
		else
			self clear_run_anim();
		
		//self.moveplaybackrate = 1;	
			
		if ( self.moveplaybackrate <  self.aimaxsprintrate)
			self.moveplaybackrate =  self.aimaxsprintrate;
	}
	else if ( self.dist < pushdist )
	{
		// run when player is inside push dist.
		if ( self.run_speed_state == "run" )
			return;
		
		self.run_speed_state = "run";
		
		if( isdefined( level.escape_run_section ) )
			self set_generic_run_anim( level.current_run[ level.escape_run_section ][ self.run_speed_state ] );	
		else
			self clear_run_anim();
		
		self.moveplaybackrate = 1;		
	}
	else if ( self.dist < pushdist * 2 )
	{
		if ( self.run_speed_state == "jog" || self.springleak == true )
			return;
		
		self.run_speed_state = "jog";
		
		if( isdefined( level.escape_run_section ) )
			self set_generic_run_anim( level.current_run[ level.escape_run_section ][ self.run_speed_state ] );	
		else
			self clear_run_anim();
		
		if ( self.moveplaybackrate >  self.aiminjograte)
			self.moveplaybackrate =  self.aiminjograte;
	}
}

escape_heroes_holdtheline( pushdist , pack, sprintdist, maxsprintrate, fake)
{
	self notify( "stop_dynamic_run_speed" );
	self endon( "stop_dynamic_run_speed" );
	self.oldwalkdist = self.walkdist;
	self.old_moveplaybackrate = self.moveplaybackrate;
	self.run_speed_state = "run";
	self.oldanimname = self.animname;
	self.animname = "escape";
	self.dist = 0;
	self.springleak = false;
	self.disableexits = true;
	self.disablearrivals = true;
	if( !isdefined(sprintdist) )
		sprintdist = pushdist * .5;
		
	self.aimaxdist = 150;
	self.aimindist = 75;
	if( isdefined( maxsprintrate ) )
		self.aimaxsprintrate = maxsprintrate;
	else
		self.aimaxsprintrate = 1.4;
	self.aiminjograte = .75;
	
	while ( true )
	{
		wait 0.05;
		
		if( isdefined( fake ) )
			self.dist = sprintdist - 5;	
		else
			self.dist = distance( self.origin, level.player.origin );
		
		order = escape_heroes_findorder(pack);
		self escape_heroes_holdtheline_run_or_walk_asone( order );
		self escape_heroes_holdtheline_stay_in_single_file( order );
		self escape_heroes_holdtheline_decide_jog_run_sprint( pushdist, sprintdist );
	}
}

escape_heroes_findorder(pack)
{
	order = [];
	i=0;
	
	order["last"] 	= pack[0];			
	for(i=1; i<pack.size; i++)
	{
		comparison1 = distancesquared( order["last"].origin, level.player.origin );
		comparison2 = distancesquared( pack[i].origin, level.player.origin );
		if( comparison1 > comparison2 )
			order["last"] 	= pack[i];
	}
	
	order[2] 				= order["last"];
	order["last"].position 	= "last";	
	
	
	order["lead"] = pack[0];
	for(i=1; i<pack.size; i++)
	{
		comparison1 = distancesquared( order["lead"].origin, level.player.origin );
		comparison2 = distancesquared( pack[i].origin, level.player.origin );
		if( comparison1 < comparison2 )
			order["lead"] 	= pack[i];
	}
	
	order[0] 				= order["lead"];
	order["lead"].position 	= "lead";
	
	
	for(i=0; i<pack.size; i++)
	{
		if(pack[i] != order["lead"] && pack[i] != order["last"] )
		{
			order["middle"] = pack[i];	
			order[1] 		= pack[i];
			pack[i].position = "middle";
			break;
		}
	}	

	return order;
}

escape_heroes_run_wait(name)
{
	msg = name + "_flag";
	level endon( msg );
	
	temp = getnodearray(name + "_end","targetname");
	nodes = [];
	
	for(i=0; i<temp.size; i++)
		nodes[ int(temp[i].script_noteworthy) ] = temp[i];
	
	//who's furthest left
	pack = [];
	pack[ pack.size ] = level.heroes3["price"];
	pack[ pack.size ] = level.heroes3["alavi"];
	pack[ pack.size ] = level.heroes3["grigsby"];
	
	order = escape_heroes_findorder(pack);
	
	for(i=0; i< 3; i++)
	{
		if(order[i].script_noteworthy == self.script_noteworthy)
		{
			self thread enable_arrivals();
			self setgoalnode( nodes[ (i+1) ] );
			self.goalradius = 16;	
			break;
		}
	}	
}

escape_waterlevel_parts(model)
{
	switch(self.script_noteworthy)
	{
		case "path":
			model.path = self;
			break;
		case "fx_locked":
			fxnode = spawn("script_model", self.origin );
			fxnode.angles = self.angles + (-90,0,90);
			fxnode setmodel("tag_origin");
			fxnode linkto(model);
			fxnode hide();
			
			model waittill("show");	
					
			self thread escape_waterlevel_parts_fx("sinking_waterlevel_center", fxnode, model);
			break;
		case "fx_norotate":
			fxpos = spawn("script_origin", self.origin );
			fxpos linkto(model);
			
			model waittill("show");
			fxnode = spawn("script_model", self.origin );
			fxnode.angles = self.angles + (-90,0,90);
			fxnode setmodel("tag_origin");
			fxnode hide();
			
			self thread escape_waterlevel_parts_fx("sinking_waterlevel_edge", fxnode, model);
			fxnode endon ("death");
			while(1)
			{
				fxnode moveto(fxpos.origin, .1);
				wait .1;				
			}break;
	}	
}

escape_waterlevel_parts_fx(name, fxnode, model)
{
	startflag 	= undefined;
	endflag 	= undefined;
	
	attr = strtok(model.script_parameters, ":;,= ");
	for(i=0; i<attr.size; i++)
	{
		switch( tolower( attr[i] ) )
		{
			 case "fxstartflag":
			 	i++;
			 	startflag = attr[i];
			 	break;
			 case "fxendflag":
				 i++;
			 	endflag = attr[i];
			 	break;
		}
	}
	
	if( isdefined( startflag ) )
	{
		flag_wait( startflag );
		wait 1;
	}
		
	playfxontag(level._effect[name], fxnode, "tag_origin");
		
	if( isdefined( endflag ) )	
	{
		flag_wait( endflag );
		fxnode delete();
	}
}

escape_quake()
{
	level.player endon("stopquake");
			
	while( !flag("escape_tilt_30") )
	{
		wait .1;
		earthquake(0.15, .1, level.player.origin, 256);
	}
	
	while( !flag("escape_cargohold1_enter") )
	{
		wait .1;
		earthquake(0.175, .1, level.player.origin, 256);
	}
	
	while( !flag("escape_hallway_lower_flag") )
	{
		wait .1;
		earthquake(0.2, .1, level.player.origin, 256);
	}
	
	while( !flag("end_start_player_anim") )
	{
		wait .1;
		earthquake(0.225, .1, level.player.origin, 256);
	}
}

escape_explosion_drops()
{
	bigcontainer = getent("escape_first_falling_container", "targetname");
	bigcontainerend = getent("escape_first_fallen_container","targetname");
	
	time = 2;
	acc = 0;
	dec = 0;
	
	bigcontainer rotateto( (0,45,0), 2);
	
	wait time;
	
	bigcontainer delete();
	bigcontainerend solid();
	bigcontainerend show();
	
	blockerstart = getentarray("escape_big_blocker_before","targetname");
	blockerend = getentarray("escape_big_blocker","targetname");
	
	for(i=0; i< blockerstart.size; i++)
		blockerstart[i] delete();
	
	for(i=0; i< blockerend.size; i++)
	{
		blockerend[i] show();
		blockerend[i] solid();
		if(blockerend[i].spawnflags & 1)
			blockerend[i] disconnectpaths();
	}
}

escape_shellshock_vision()
{
	black_overlay = create_overlay_element( "black", 0 );
		
	//blinking
	black_overlay delayThread(1.5, ::exp_fade_overlay, 1, .5 );
	black_overlay delayThread(2.25, ::exp_fade_overlay, 0, .5 );
	
	black_overlay delayThread(3, ::exp_fade_overlay, .5, .25 );
	black_overlay delayThread(3.25, ::exp_fade_overlay, 0, .25 );	
	
	black_overlay delayThread(5, ::exp_fade_overlay, 1, .5 );
	black_overlay delayThread(6, ::exp_fade_overlay, 0, .5 );
	
	black_overlay delayThread(10, ::exp_fade_overlay, 1, .5 );
	black_overlay delayThread(10.75, ::exp_fade_overlay, 0, .5 );
	
	black_overlay delayThread(13, ::exp_fade_overlay, 1, .5 );
	black_overlay delayThread(13.75, ::exp_fade_overlay, 0, .5 );
	
	//blurring
	delayThread(.75, ::blur_overlay, 4.8, .5);
	delayThread(1.25, ::blur_overlay, 0, 4);
	
	delayThread(7.25, ::blur_overlay, 4.8, 2);
	delayThread(9.25, ::blur_overlay, 0, 2);
	
	delayThread(13, ::blur_overlay, 7.2, 1);
	delayThread(14, ::blur_overlay, 0, 1);
	
	//breathing sounds
	level.player delayThread(1.5, ::play_sound_on_entity, "breathing_hurt_start");
	level.player delayThread(2.5, ::play_sound_on_entity, "breathing_hurt");
	level.player delayThread(4, ::play_sound_on_entity, "breathing_hurt");
	level.player delayThread(5, ::play_sound_on_entity, "breathing_hurt");
	level.player delayThread(8.5, ::play_sound_on_entity, "breathing_hurt");
	level.player delayThread(11, ::play_sound_on_entity, "breathing_hurt");
	
	level.player delayThread(13, ::play_sound_on_entity, "breathing_better");
	level.player delayThread(16, ::play_sound_on_entity, "breathing_better");
	level.player delayThread(21, ::play_sound_on_entity, "breathing_better");
	level.player delayThread(24, ::play_sound_on_entity, "breathing_better");
	
	flag_wait("escape_get_to_catwalks");
	black_overlay destroy();
}

escape_shellshock_heartbeat()
{
	level endon("stop_heartbeat_sound");
	interval = -.5;
	while(1)
	{
		level.player play_sound_on_entity("breathing_heartbeat");
		if(interval > 0)
			wait interval;
		interval += .1;
	}
}

escape_shellshock()
{
	//level.player shellshock("cargoship", 14);	
	thread escape_shellshock_vision();
	thread escape_shellshock_heartbeat();
	level.player PlayRumbleOnEntity( "tank_rumble" );
	level thread notify_delay("stop_heartbeat_sound", 18);
	SetSavedDvar( "hud_gasMaskOverlay", 0 );
	clearallcorpses();
	
	targetorigin = ( 620, -296, -360 );
	
	dummy = spawn_anim_model( "end_hands" );
	dummy.origin = get_player_feet_from_view();
	level.player setstance( "stand" );
	dummy.angles = level.player getplayerangles();
	dummy hide();
	
	level.player playerlinktoabsolute( dummy, "tag_player", 1 );
	
	org = spawn("script_model", level.player.origin);
	org.angles = level.player getplayerangles();
	org setmodel("tag_origin");
	
	dummy linkto( org, "tag_origin" );
	//level.player playerlinktodelta (org, "tag_origin", 1, 0, 0, 0, 0);
	
	org thread play_loop_sound_on_entity("shellshock_loop");	
	playerWeaponTake();
	
	guns = getentarray();
	for ( i = 0; i < guns.size; i++ )
	{
		if ( getsubstr( guns[i].classname, 0, 7 ) == "weapon_" )
			guns[i] delete();
	}	
	
	door = getent( "hallways_door", "targetname" );
	clip = getent(door.target, "targetname");
	
	door delete();
	clip delete();
	
	angles = (358.273, 286.02, -89.0164);
	dummy2 = spawn_anim_model( "end_hands" );
	dummy2 hide();
	node = spawn( "script_origin", targetorigin );
	node.angles = (0,180,0);
	
	node anim_first_frame_solo( dummy2, "player_explosion" );
	waittillframeend;
	angles = dummy2 gettagangles( "tag_player" );
	pos = dummy2 gettagorigin( "tag_player" );
	
	node delete();
	dummy2 delete();
		
	org rotateto( angles, .6, 0, 0);
	org moveto( pos , .6);//rotate side
	org waittill( "movedone" );
	//wait .6;
	
	thread escape_new_explosion_scene( org, dummy, targetorigin );
//	thread escape_old_explosion_scene( org, targetorigin );
	
	wait 8.45; 
	level notify("escape_show_waterlevel");
	
	wait 14.74;
	org stop_loop_sound_on_entity("shellshock_loop");
	
	wait .3;
	//wait 23.09;	
	//iprintlnbold( "original end of scene " + 23.49 + " sec" );
}

escape_new_explosion_scene( org, dummy, pos )
{		
	dummy unlink();
	price = level.heroes3[ "price" ];
	
	node = spawn( "script_origin", pos );
	node.angles = (0,180,0);
		
	origin = GetStartOrigin( node.origin, node.angles, dummy getanim( "player_explosion" ) );
	spot = dummy.origin - origin;
	
	node.origin += spot;
	node.origin = (node.origin[0], node.origin[1], -360 );
		 
	dummy show();
	node anim_first_frame_solo( dummy, "player_explosion" );
//	wait 1;
	
	price stopanimscripted();
	price unlink();	
	node thread anim_generic( price, "price_explosion" );	
	node anim_single_solo( dummy, "player_explosion" );
	
	//iprintlnbold( "NEW end of scene " + getanimlength( getanim_generic( "price_explosion" ) ) + " sec" );
	level notify("escape_unlink_player");
	level.player unlink();
	
	org delete();
	node delete();
	dummy delete();
}

escape_old_explosion_scene( org, pos )
{
	org rotateto( (344.064, 286.67, -93.2207), .2, 0, .2);//bounce up
	org moveto( ( pos ) , .2, 0, .2);
	wait .1;
	
	//waver up once
	
	org rotateto( (358.273, 286.02, -89.0164), .3, .3, 0);//come down
	org moveto( ( org.origin + (0, 0, -12) ) , .3, .3, 0);
	wait .3;
	
	org rotateto( (344.064, 286.67, -93.2207), 2.05, 0, 2.05);
	org moveto( ( org.origin + (0, 0, 0) ) , 2.05, 0, 2.05);
	wait 2.05;
	
	//look the other way		
	org rotateto( (321.374, 134.198, 58.7419), 6, 3, 3);
	org moveto( ( org.origin + (0, 0, -32) ) , 3, 3, 0);
	wait 3;	
	org moveto( ( org.origin + (0, 0, 32) ) , 3, 0, 3);
	wait 3;
	
	//level notify("escape_show_waterlevel");
		
	//look back
	org rotateto( (344.064, 286.67, -93.2207), 6, 3, 3);//bounce up
	org moveto( ( org.origin + (0, 0, -32) ) , 3, 3, 0);
	wait 3;	
	org moveto( ( org.origin + (0, 0, 36) ) , 3, 0, 3);
	wait 3;
	
	//and again
	org rotateto( (321.374, 134.198, 58.7419), 4, 2, 2);
	org moveto( ( org.origin + (0, 0, -32) ) , 2, 2, 0);
	wait 2;	
	org moveto( ( org.origin + (0, 0, 36) ) , 2, 0, 2);
	wait 2;


	//get up	
	org rotateto( (330.674, 192.977, -13.8899), 2, 1, 1);
	org moveto( ( org.origin + (0, 0, -16) ) , 2, 2, 0);
	wait 2;
	
	org rotateto( (327.722, 180.996, -2.2776), .5, .25, .25);
	wait .5;
	
	wait .25;
	
	org rotateto( (-10, 180, 0), .5);
	org moveto( ( org.origin + (0, 0, 0) ) , .5);
	wait .5;
	
	//org rotateto( (32.3864, 132.707, 29.6049), .75);
	org rotateto( (0, 75, 10), 1.5);
	wait .35;
	org moveto( ( org.origin + (0, 0, 10) ) , .75);
	wait .4;
	
	wait .74;
	//org stop_loop_sound_on_entity("shellshock_loop");
	
	wait .3;
}

PlayerMaskPuton()
{
	orig_nightVisionFadeInOutTime = GetDvar( "nightVisionFadeInOutTime" );
	orig_nightVisionPowerOnTime = GetDvar( "nightVisionPowerOnTime" );
	SetSavedDvar( "nightVisionPowerOnTime", 0.5 );
	SetSavedDvar( "nightVisionFadeInOutTime", 0.5 );
	SetSavedDvar( "overrideNVGModelWithKnife", 1 );
	SetSavedDvar( "nightVisionDisableEffects", 1 );

	wait( 0.01 ); //give the knife override a frame to catch up
	level.player ForceViewmodelAnimation( "facemask", "nvg_down" );
	wait( 2.0 );
	SetSavedDvar( "hud_gasMaskOverlay", 1 );
	wait( 2.5 );

	SetSavedDvar( "nightVisionDisableEffects", 0 );
	SetSavedDvar( "overrideNVGModelWithKnife", 0 );
	SetSavedDvar( "nightVisionPowerOnTime", orig_nightVisionPowerOnTime );
	SetSavedDvar( "nightVisionFadeInOutTime", orig_nightVisionFadeInOutTime );
}

priceCigarDelete()
{
	wait 26;
	self delete();
}

priceCigarExhaleFX(cigar)
{
	cigar endon ("death");
	for (;;)
	{
		self waittillmatch("single anim", "exhale");
		playfxOnTag (level._effect["cigar_exhale"], self, "tag_eye");
	}	
}

priceCigarPuffFX(cigar)
{
	cigar endon ("death");
	for (;;)
	{
		self waittillmatch("single anim", "puff");
		playfxOnTag (level._effect["cigar_glow_puff"], cigar, "tag_cigarglow");
		wait 1;
		playfxOnTag (level._effect["cigar_smoke_puff"], self, "tag_eye");
	}	
}

execute_ai_solo(guy, delay, numshots, accurate, checkplayer )
{
	ai = [];
	ai[0] = guy;
	if( !isdefined( accurate ) )
		accurate = false;
	execute_ai(ai, delay, numshots, accurate, checkplayer );
}

execute_ai(ai, delay, numshots, accurate, checkplayer)
{	
	shots = 0;
	if(!isdefined(delay))
		delay = 0;
	if(!isdefined(accurate))
		accurate = false;
	_checkplayer = isdefined( checkplayer );
	
	while( isdefined(self.execute_mode) && self.execute_mode == true )
		self waittill( "execute_mode" );
	
	self.execute_mode = true;
	
	cqboff = true;
	if( isdefined(self.cqbwalking) && self.cqbwalking)
		cqboff = false;
	
	for(i=0; i< ai.size; i++)
	{
		//select an enemy
		if( !isalive( ai[i] ) || isdefined( ai[i].execute_target ) )
			continue;
		
		//create a target and link it to the enemy
		ai[i].execute_target = true;
		target = spawn("script_origin", ai[i] gettagorigin("j_spine4"));
		target linkto(ai[i], "j_spine4");
		self enable_cqbwalk_ign_demo_wrapper();
		self cqb_aim( target );
		
		if( accurate )
		{
			while(	abs( vectordot(self gettagangles( "tag_flash" ), vectornormalize(target.origin - self gettagorigin( "tag_flash" )) ) ) < .95  )
				wait .05;
		}
		wait delay;
		
		//if the player is in the way...check
		while( _checkplayer )
		{
			trace = bullettrace( self gettagorigin( "tag_flash" ), target.origin, true, self );
			
			if( !isdefined( trace[ "entity" ] ) || trace[ "entity" ] != level.player )
				break;
			wait .1;
		}
		
		//now fire on him until he's dead
		if(isdefined(numshots))
			shots = numshots;
		else
			shots = randomintrange(3,6);
		
		if( accurate )
		{
			while( isalive(ai[i]) )
				self burstshot(shots);
		}
		else
		{
			self burstshot(shots);
			ai[i] dodamage(ai[i].health + 300, self gettagorigin("tag_flash") );		
		}
		//wait .2;
		target delete();
		//wait a second, then find another target
		wait .1;
	}
	
	self cqb_aim( undefined );
	if(cqboff)
		self disable_cqbwalk_ign_demo_wrapper();
	self.execute_mode = false;
	self notify( "execute_mode" );
}

burstshot(shots)
{
	if( self.bulletsInClip < shots )
		self.bulletsInClip = shots;
		
	for(i=0; i<shots; i++)
	{
		self shoot();
		wait .1;
	}
}

#using_animtree("generic_human");
patrol()
{
	//self ==> the AI doing the patrol
	//eNode ==> (optional) the AI will patrol back and forth between connected nodes, 
	//           or just navigate and stay at the one node (optional because can just have AI target a node

	self thread patrol2();
	
	self allowedstances( "stand" );
	self.disableArrivals = true;

	self endon("patrol_stop");
	self endon ("damage");
	
	self.animname = "patrol";
	self set_run_anim( "walk" + randomintrange(1,5) );

	
	
	nodes = [];
	nodes[nodes.size] = getnode( self.target, "targetname" );
	while( isdefined( nodes[ nodes.size - 1 ].target ) )
		nodes[ nodes.size ] = getnode( nodes[ nodes.size - 1 ].target, "targetname" );
		
	self attach( "com_flashlight_on" ,"tag_inhand", true );
	self flashlight_light( true );
	
	self waittill("goal");
	
	index = 0;
	while( 1 )
	{		
		index++;
		if(index < nodes.size)
		{
			node = nodes[ index ];
			self setgoalnode( node );
			if(node.radius)
				self.goalradius = node.radius;
			else
				self.radius = 16;
			
			self waittill("goal");
			continue;
		}
		
		//self anim_single_solo(self, "pause");
		self anim_single_solo(self, "turn");
		
		index = 0;
		nodes = array_reverse(nodes);		
	}
}

patrol2()
{
	self waittill_either("damage", "patrol_stop");
	self notify("stopanimscripted");
	self stopanimscripted();
	
	self clear_run_anim();
	
	self thread enable_arrivals();
	
	self flashlight_light( false );
	self detach( "com_flashlight_on" ,"tag_inhand" );
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
		playfxontag( level._effect["flashlight"], flashlight_fx_ent, "tag_origin" );
	}
	else
		self notify( "flashlight_off" );
}

flashlight_light_death( flashlight_fx_ent )
{
	self waittill_either( "death", "flashlight_off");
	flashlight_fx_ent delete();
}

door_opens( mod )
{
	self playsound ("wood_door_kick");
	rotation = -160;
	if ( isdefined( mod ) )
		rotation *= mod;
	self rotateyaw( rotation, .4, 0, .3);
}

txt_voice(time, color, line1, line2, line3, line4, size)
{
	self endon("death");
	clr = (0,1,0);//defaults to green
	txtsize = .5;
	if(isdefined(size))
		txtsize = size;
	
	if( isdefined( color ) )
	{	
		switch( color )
		{
			case "r":
				clr = (1,0,0); 
				break;
			case "b":
				clr = (0,0,1); 
				break;
			case "g":
				clr = (0,1,0); 
				break;
			case "y":
				clr = (1,1,0); 
				break;
		}
	}	
	
	msg = [];
	if(isdefined(line4))
		msg[msg.size] = line4;
	if(isdefined(line3))
		msg[msg.size] = line3;
	if(isdefined(line2))
		msg[msg.size] = line2;
	if(isdefined(line1))
		msg[msg.size] = line1;
	
	count = int(time * 20);
	
	if(self == level.player)
	{
		while (count)
		{
			ang = level.player getplayerangles();
			vec = anglestoforward(ang);
			vec = vector_multiply(vec, 96 );
			aboveHead = level.player.origin + vec + (0,0,64);
			txtsize = .25;
			clr = (1,1,0);
			
			for (i = 0 ; i < msg.size; i++)
			{
				print3d (aboveHead, msg[i], clr, 1, txtsize);	// origin, text, RGB, alpha, scale
				aboveHead += (0,0, 10 * txtsize);
			}
			wait 0.05;
			count--;
		}	
	}
	else
	{
		while (count)
		{
			aboveHead = self.origin + (0,0,64);
			for (i = 0 ; i < msg.size; i++)
			{
				print3d (aboveHead, msg[i], clr, 1, txtsize);	// origin, text, RGB, alpha, scale
				aboveHead += (0,0, 10 * txtsize);
			}
			wait 0.05;
			count--;
		}	
	}
}

heli_flypath(node)
{
	level.heli notify("heli_flypath");
	level.heli endon("heli_flypath");
	
	while( isdefined(node) )
	{
		stop = true;
		if( isdefined(node.target) )
			stop = false;
					
		level.heli.vehicle setvehgoalpos( node.origin + (0,0,150), stop );
		level.heli.vehicle setNearGoalNotifyDist( 150 );
		level.heli.vehicle waittill( "near_goal" );	
	
		if( isdefined(node.target) )
			node = getstruct( node.target, "targetname" );
		else
			node = undefined;
	}
}

heli_circle_area_start(name)
{
	self.vehicle setspeed( 20, 8, 8 );
	self.vehicle sethoverparams( 16, 10, 3 );
	self.vehicle cleartargetyaw();
	self.vehicle cleargoalyaw();
	self.vehicle clearlookatent();	
		
	self endon("stop_circling_area");
	
	spot = getstruct( name, "targetname");
	self thread heli_circle_area_gun();				
	while(1)
	{				
		self.vehicle setvehgoalpos( spot.origin, 1);
		self.vehicle setNearGoalNotifyDist( 64 );
		self.vehicle settargetyaw(spot.angles[1]);
		
		self.vehicle waittill( "near_goal" );
		wait 5;
		
		if( isdefined( spot.target ) )
			spot = getstruct( spot.target, "targetname" );
		else
			spot = getstruct( name, "targetname");
	}
}
heli_circle_area_gun()
{
	self endon("stop_circling_area");
	self.model.minigun[self.model.minigun_control] setplayerspread(15);
	self.model.minigun[self.model.minigun_control] setaispread(15);
	
	while(1)
	{
		if(isdefined(self.model.spotlight.targetobj))
		{
			self.model.minigun[self.model.minigun_control] settargetentity(self.model.spotlight.targetobj);
			self.model heli_minigun_burstfire();
		}
			
		wait 5;
		self.model heli_minigun_stopfire();
		self.model.minigun[self.model.minigun_control] cleartargetentity();
		wait 6;
	}
}

heli_circle_area_stop()
{
	self notify("stop_circling_area");
	self.model heli_minigun_stopfire();
	self.model.minigun[self.model.minigun_control] cleartargetentity();
}

heli_minigun_fire()
{
	self.minigun[self.minigun_control] thread heli_minigun_firethread(false);
}

heli_minigun_burstfire()
{
	self.minigun[self.minigun_control] thread heli_minigun_firethread(true);
}

heli_minigun_stopfire()
{
	self.minigun[self.minigun_control] notify( "stop_firing" );
}

heli_minigun_firethread(burst)
{
	self endon( "stop_firing" );
	while(1)
	{
		timer = randomfloatrange( 0.2, 0.7 ) * 20;
		
		for ( i = 0; i < timer; i++ )
		{
			self shootturret();
			//self shootturret();
			//self shootturret();
			wait( 0.05 );
		}
		
		if(isdefined(burst) && burst == true)
			wait( randomfloat( 0.5, 2 ) );
	}
}

deck_minigun_dodamage()
{
	self endon("stop_damage");
	self endon("death");
	
	glass = getentarray ("glass", "targetname");
		
	dist = 64;
	distsqrd = dist * dist;
	dist2 = 64;
	distsqrd2 = dist2 * dist2;
	
	while(1)
	{
		for( i = 0; i < glass.size; i++ )
		{
			if( !isdefined(glass[i]) )
				continue;
			if(distancesquared(glass[i] getorigin(), self.origin) < distsqrd)
			{
				glass[i] thread deck_minigun_dodamage_to_ent();		
				glass = array_remove(glass, glass[i]);
				break;
			}
		}
		
		for( i = 0; i < level.aftdeck_enemies.size; i++ )
		{
			if( !isdefined( level.aftdeck_enemies[ i ] ) )
				continue;
			if( !isalive( level.aftdeck_enemies[ i ] ) )
				continue;
			if( distancesquared( level.aftdeck_enemies[ i ] getorigin(), self.origin ) < distsqrd2 )
			{
				
				level.aftdeck_enemies[i] thread deck_minigun_dodamage_to_ent("generic_death_russian_" + randomintrange(1,8));	
				level.aftdeck_enemies = array_remove(level.aftdeck_enemies, level.aftdeck_enemies[i]);
				break;
			}
		}
		glass = array_removeUndefined(glass);
		level.aftdeck_enemies = array_removeDead(level.aftdeck_enemies);
		level.aftdeck_enemies = array_removeUndefined(level.aftdeck_enemies);
		wait .05;	
	}
}

deck_minigun_dodamage_to_ent(snd)
{
	wait .25;
	if(!isdefined(self))
		return;
		
	self dodamage(1000, level.heli.model.origin);
	
	if(isdefined(snd))
		thread play_sound_in_space(snd, self.origin );	
}

deck_enemies_see( enemy )
{
	//self is one of the good guys here
	setthreatbias(self.script_noteworthy , enemy.cgogroup, 0 );		
	
	enemy notify( "stop_smoking" );
	enemy notify( "patrol_stop" );
	enemy notify( "see_enemy" );
	
	enemy stopanimscripted();
}

enemies_death_msg( msg )
{
	self waittill("damage", damage, other);
	if(isalive(self))
		self waittill("death");
		
	radio_msg_stack( msg );
}

deck_enemies_herokill()
{
	self endon("death");
	self endon("marked_for_death");
	
	if(self.ignoreme)
		self waittill("in_range");
		
	ai = level.heroes5;
	keys = getarraykeys(ai);
	maxdist = 700;
	maxdistsqrd = maxdist * maxdist;
	loop = true;
	
	while( loop )
	{
		for(i=0; i<keys.size; i++)
		{
			key = keys[i];
			check1 = distancesquared( ai[ key ].origin, self.origin ) < maxdistsqrd;
			if( check1 )
			{
				loop = false;
				if(ai[ key ] != level.player)
				{
					ai[ key ] thread execute_ai_solo( self, 0, undefined, true );
					self notify("marked_for_death");
				}		
			}
		}
		wait .1;
	}
}

deck_enemies_behavior()
{
	self endon("death");

	self thread deck_enemies_behavior2();
			
	self.cgogroup = ( "deck_enemy" + self.ai_number );
	createthreatbiasgroup( self.cgogroup );
	self setthreatbiasgroup( self.cgogroup );
	
	ai = [];
	ai[ai.size] = level.player;
	ai = array_combine(ai, level.heroes5);

	for(i=0; i<ai.size; i++)
		setignoremegroup(ai[i].script_noteworthy , self.cgogroup );	
	
	maxdist = 700;
	maxdistsqrd = maxdist * maxdist;
	loop = true;
	
	while( loop )
	{
		for(i=0; i<ai.size; i++)
		{
			check1 = distancesquared( ai[i].origin, self.origin ) < maxdistsqrd;
			if( check1 )
			{
				loop = false;
				if(ai[i] != level.player)
				{
					ai[i] thread execute_ai_solo( self, 0, undefined, true );
					self notify("marked_for_death");
				}
				break;			
			}
		}
		wait .25;
	}
	
	self notify("in_range");
	
	maxdist = 350;
	maxdistsqrd = maxdist * maxdist;
	
	while( 1 )
	{
		for(i=0; i<ai.size; i++)
		{
			if( distancesquared( ai[i].origin, self.origin ) < maxdistsqrd  && self cansee(ai[i]) )
				ai[i] thread deck_enemies_see( self );
		}
		wait .25;
	}
}

deck_enemies_behavior2()
{
	self endon( "death" );
	self waittill( "doFlashBanged" );
	
	level.player.ignoreme = false;
	setthreatbias( self.cgogroup, level.player.script_noteworthy, 200 );
	
	level.player thread deck_enemies_see( self );
}

deck_heli_minigun_fx()
{
	self endon ("death");
	while(1)
	{
		playfxontag(level._effect["heli_minigun_shells"], self, "tag_origin");	
		wait .05;
	}	
}

deck_heroes_holdtheline()
{
	flag_wait("walk_deck");
	maxrate = 1.13;
	avgrate = 1;
	minrate = .9;
	maxdist = 140;
	
	pack = [];
	keys = getarraykeys(level.heroes5);
	for(i=0; i<keys.size; i++)
	{
		key = keys[i];
		pack[ pack.size ] = level.heroes5[ key ];
	}
	
	for(i=0; i<pack.size; i++)
	{
		pack[i].oldmoveplaybackrate = pack[i].moveplaybackrate;
		pack[i].moveplaybackrate = avgrate;
	}
	//this only works because the deck of the shit is on perfect 
	//angles and we're headed exactly in the 180 degree direction
	
	while( !flag("deck_windows") )
	{
		//(1) find the leader of the pack...and make his animrate a little slower
		//the leader is based on the x value - the furthest left is less than right
		leader = pack[0];
		for(i=0; i<pack.size; i++)
		{
			if(leader.origin[0] > pack[i].origin[0])
				leader = pack[i];
		}
		
		//(2) anyone who's too far behind, crank up their animrate
		//and anyone who's within range - take their animrate back down to avg
		for(i=0; i<pack.size; i++)
		{
			range = pack[i].origin[0] - leader.origin[0];
				
			if( range > maxdist && pack[i].moveplaybackrate < maxrate)
				pack[i].moveplaybackrate += .05;
			else if(pack[i].moveplaybackrate > avgrate)
				pack[i].moveplaybackrate -= .05;
		}
		
		wait .1;
	}
	for(i=0; i<pack.size; i++)
		pack[i].moveplaybackrate = pack[i].oldmoveplaybackrate;
}

heli_minigun_attach(side)
{
	self.minigun = [];
	name = undefined;
	switch( tolower( side ) )
	{
		case "right":
			name = "_r";
			break;
		case "left":
			name = "_l";
			break;
	}
	
	self.minigun[ tolower( side ) ] = spawnturret("misc_turret", self gettagorigin("tag_gun" + name), "heli_minigun_noai");
	self.minigun[ tolower( side ) ].angles = self gettagangles("tag_gun" + name);
	self.minigun[ tolower( side ) ] setmodel("weapon_minigun");//weapon_minigun //weapon_saw_MG_setup
	self.minigun[ tolower( side ) ] linkto(self, "tag_gun" + name);
	self.minigun[ tolower( side ) ] maketurretunusable();
	self.minigun[ tolower( side ) ] setmode("manual");
	self.minigun[ tolower( side ) ] setturretteam("allies");
	self.minigun_control = tolower(side);
}

heli_searchlight_on()
{
	self.spotlight = spawnturret("misc_turret", self gettagorigin("tag_barrel"), "heli_spotlight");
	self.spotlight.angles = self gettagangles("tag_barrel");
	self.spotlight setmodel("com_blackhawk_spotlight_on_mg_setup");
	self.spotlight linkto(self, "tag_barrel",(0,0,-16), (0,0,0));
	self.spotlight maketurretunusable();
	self.spotlight setmode("manual");
	self.spotlight settoparc(5);
	//self.spotlight hide();

	self.spotlight.dlight = spawn( "script_model", self gettagorigin("tag_barrel") );
	self.spotlight.dlight setModel( "tag_origin" );//self.spotlight.dlight setModel( "projectile_rpg7" );

	self.spotlight thread heli_searchlight_dlight();

	playfxontag (level._effect["heli_spotlight"], self.spotlight, "tag_flash");

	self.spotlight_default_target = spawn( "script_origin", self gettagorigin("tag_barrel") );
	self.spotlight_default_target linkto( self, "tag_turret", (0,0,-256), (0,0,0) );
	self thread heli_searchlight_target( "default" );
	
	wait .1;
	playfxontag (level._effect["spotlight_dlight"], self.spotlight.dlight, "tag_origin");
}

heli_searchlight_off()
{
	self.spotlight_default_target delete();
	
	self.spotlight notify("death");
	self.spotlight.dlight delete();
	
	temp = spawn( "script_model", self.spotlight.origin );
	temp setModel( "tag_origin" );
	self.spotlight linkto(temp);
	
	temp moveto( (0,0,-10000), .05);
	wait .25;
	self.spotlight delete();
	temp delete();
}

heli_searchlight_dlight()
{
	self endon("death");
		
	while(1)
	{
		forward = anglestoforward(self gettagangles("tag_flash"));
		//calculate
		dropspot = physicstrace(self gettagorigin("tag_flash"), ( self gettagorigin("tag_flash") + vector_multiply( forward, 1500 ) ) );
		
		vec = vector_multiply(forward, -64);
		dropspot = dropspot + vec;
		//move the dlight
		self.dlight moveto(dropspot, .1);
		wait .1;
	}
}

heli_searchlight_target_calcai(ai)
{
	playerforward = level.player getplayerangles();
	playerforward = anglestoforward(playerforward);
	
	dot = 0;
	target = ai[0];
	for(i=1; i<ai.size; i++)
	{
		vector = ai[i].origin - level.player.origin;
		vectornormalize(vector);
		
		compare = vectordot(vector, playerforward);
		
		if(compare > dot)
		{
			target = ai[i];
			dot = compare;
		}	
	}
	
	return target;
}

heli_searchlight_target(type, name)
{	
	target = undefined;
	switch(type)
	{
		case "aiarray":	
			ai = getaiarray(name);
			if(name == "allies")
			{
				ai = array_remove( ai, level.heroes7["pilot"] );
				ai = array_remove( ai, level.heroes7["copilot"] );
			}
			target = heli_searchlight_target_calcai(ai);
			break;
		case "player":	
			target = level.player;
			break;
		case "targetname":
			target = getent(name, type);
			break;
		case "script_noteworthy":
			target = getent(name, type);
			break;
		case "hero":
			target = level.heroes5[name];
			break;
		case "default":
			target = self.spotlight_default_target;
			break;
	}
	
	if(!isdefined(target))
		return;
	self notify("new_searchlight_target");
			
	self thread heli_searchlight_think(target);
	
	self endon("new_searchlight_target");
	switch(type)
	{
		case "aiarray":
			wait ( randomfloatrange( 2, 4 ) );
			self thread heli_searchlight_target(type, name);
			break;
	}
}
	
heli_searchlight_think(target)
{
	self endon("new_searchlight_target");
	self.spotlight settargetentity( target );
	self.spotlight.targetobj = target;
	target waittill("death");
	self.spotlight cleartargetentity();
}

player_speed_set(speed, time)
{
	currspeed = int( getdvar( "g_speed" ) );
	goalspeed = speed;
	if( !isdefined( level.player.g_speed ) )
		level.player.g_speed = currspeed;
	
	range = goalspeed - currspeed;
	interval = .05;
	numcycles = time / interval;
	fraction = range / numcycles;
	
	while( abs(goalspeed - currspeed) > abs(fraction * 1.1) )
	{
		currspeed += fraction;
		setsaveddvar( "g_speed", int(currspeed) );
		wait interval;
	}
	
	setsaveddvar( "g_speed", goalspeed );
}

player_speed_reset(time)
{
	if( !isdefined( level.player.g_speed ) )
		return;
	player_speed_set(level.player.g_speed, time);
	level.player.g_speed = undefined;
}

cargohold_1_light_sway( model )
{
	node = spawn("script_origin", self.origin );
	node linkto( model );
	
	while(1)
	{
		self moveto( node.origin, .1 );
		wait .1;	
	}
}

misc_light_sway()
{
	if( isdefined( self.script_noteworthy ) && self.script_noteworthy == "nosway" )
		return;
	ang = self.angles;
	pos = self.origin;
	ang += (0,90,0);
	while(1)
	{
		level._sea_org waittill("sway1");
		
		time =  (level._sea_org.time);
		acc = time * .5;
		
		//self rotateto( ang + (-5,0,0), time, acc, acc );
		self moveto( pos + (0,20,0), time, acc, acc );
		
		level._sea_org waittill("sway2");
		
		time =  (level._sea_org.time );
		acc = time * .5;
		
		//self rotateto( ang + (5,0, 0), time, acc, acc );
		self moveto( pos + (0,-20,0), time, acc, acc );
	}	
}

misc_tv_stairs_on()
{
	wait 1;
	self.usetrig notify("trigger");
	start = getent("start_bridge_standoff", "targetname");
	start waittill("trigger");
	self.usetrig notify("trigger");	
}

misc_tv()
{
	self setcandamage(true);
	self.damagemodel = undefined;
	self.offmodel = undefined;
	
	switch(self.model)
	{
		case "com_tv2_testpattern":
			self.damagemodel = "com_tv2_d";
			self.offmodel = "com_tv2";
			self.onmodel = "com_tv2_testpattern";
			break;
		case "com_tv1_testpattern":
			self.damagemodel = "com_tv2_d";
			self.offmodel = "com_tv1";
			self.onmodel = "com_tv1_testpattern";
			break;	
	}
		
	self.glow = undefined;
	self.gloworg = self.origin + (0,0,14) + vector_multiply(anglestoforward(self.angles), 55);
	self.usetrig = getent(self.target, "targetname");
	self.usetrig usetriggerrequirelookat();
	self.usetrig setcursorhint("HINT_NOICON");
	
	if( isdefined( self.usetrig.target ) )
	{
		self.lite = getent(self.usetrig.target, "targetname");
		if( isdefined( self.lite ) )
			self.liteintensity = self.lite getLightIntensity();
	}
	self thread misc_tv_damage();
	self thread misc_tv_off();
}

misc_tv_off()
{
	self.usetrig endon("death");
	
	while(1)
	{
		self.glow = spawn("script_model", self.gloworg);
		self.glow setmodel("tag_origin");
		self.glow hide();
		playfxontag( level._effect[ "aircraft_light_cockpit_blue" ], self.glow, "tag_origin" );
		
		if( isdefined( self.lite ) )
			self.lite setLightIntensity(self.liteintensity);
		
		wait .2;
		self.usetrig waittill("trigger");
		self setmodel(self.offmodel);
		
		self.glow delete();
		self.glow = undefined;
		
		if( isdefined( self.lite ) )
			self.lite setLightIntensity(0);
		
		wait .2;
		self.usetrig waittill("trigger");
		self setmodel(self.onmodel);
	}
}

misc_tv_damage()
{
	self waittill("damage", damage, other, direction_vec, P, type );
	
	self.usetrig notify("death");
	
	if(isdefined(self.glow))
		self.glow delete();
	
	if( isdefined( self.lite ) )
		self.lite setLightIntensity(0);

	playfxontag( level.misc_tv_damage_fx["tv_explode"], self, "tag_fx" );
	self playsound( "tv_shot_burst" );
	
	self.usetrig delete();
	self setmodel(self.damagemodel);
}

misc_vision()
{
	attr = strtok(self.script_parameters, ":;, ");
	time = 5;
	for(j=0;j<attr.size; j++)
	{
		if(attr[j] == "time")
		{
			j++;
			time = int(attr[j]);
		}
	}
	while(1)
	{
		self waittill("trigger");
		set_vision_set( self.script_noteworthy, time );
	}
}

misc_fx_handler_trig()
{
	if(!isdefined(level.fx_handlers))
		level.fx_handlers = [];
	level.fx_handlers[level.fx_handlers.size] = self.script_noteworthy;
	
	while(1)
	{
		self waittill("trigger");
		
		for(i=0; i<level.fx_handlers.size; i++)
		{
			if(level.fx_handlers[i] == self.script_noteworthy)
				flag_set( self.script_noteworthy );
			else
				flag_clear( level.fx_handlers[i] );
		}	
	}
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
	return overlay;
}

create_credit_element( shader_name )
{
	overlay = newHudElem();
	overlay.x = 0;
	overlay.y = 0;
	overlay setshader ( shader_name, 512, 256);
	overlay.alignX = "center";
	overlay.alignY = "middle";
	overlay.horzAlign = "center";
	overlay.vertAlign = "middle";
	overlay.alpha = 0;
	return overlay;	
}

fade_overlay( target_alpha, fade_time )
{
	self fadeOverTime( fade_time );
	self.alpha = target_alpha;
	wait fade_time;
}

exp_fade_overlay( target_alpha, fade_time )
{
	self notify("exp_fade_overlay");
	self endon("exp_fade_overlay");
	
	fade_steps = 4;
	step_angle = 90 / fade_steps;
	current_angle = 0;
	step_time = fade_time / fade_steps;

	current_alpha = self.alpha;
	alpha_dif = current_alpha - target_alpha;

	for ( i=0; i<fade_steps; i++ )
	{
		current_angle += step_angle;

		self fadeOverTime( step_time );
		if ( target_alpha > current_alpha )
		{
			fraction = 1 - cos( current_angle );
			self.alpha = current_alpha - alpha_dif * fraction;
		}
		else
		{
			fraction = sin( current_angle );
			self.alpha = current_alpha - alpha_dif * fraction;
		}

		wait step_time;
	}
}

blur_overlay( target, time )
{
	setblur( target, time );	
}

#using_animtree("vehicles");
seaknight_spawn(node)
{
	struct = spawnstruct();
	struct.modelname 	= "vehicle_ch46e_opened_door_interior";
	struct.type 		= "seaknight";
	struct.targetname	= "escape_seaknight";
	
	
	origin = getstartorigin(node.origin, node.angles, level.scr_anim[ "bigbird" ][ "in" ] );
	angles = getstartangles(node.origin, node.angles, level.scr_anim[ "bigbird" ][ "in" ] );
	struct.model 			= spawn("script_model", origin );
	struct.model 			setmodel( struct.modelname );
	struct.model.angles 	= angles;
	struct.model.animname 	= "bigbird";
		
	struct.model.vehicletype = struct.type;
	struct.model thread maps\_vehicle::helicopter_dust_kickup();
	
	struct.model thread maps\mo_fastrope::fastrope_player_quake();
	
	struct.model useanimtree( #animtree );
	struct.model setanim( %ch46_turret_idle );            
//	struct.model setanim( %sniper_escape_ch46_rotors );
	
	return struct;	
}

seaknight_playlightfx()
{		
	playfxontag( level._effect[ "aircraft_light_wingtip_green" ], self, "tag_light_L_wing1" );
	playfxontag( level._effect[ "aircraft_light_wingtip_green" ], self, "tag_light_L_wing2" );
	
	playfxontag( level._effect[ "aircraft_light_wingtip_red" ], self, "tag_light_R_wing1" );	
	playfxontag( level._effect[ "aircraft_light_wingtip_red" ], self, "tag_light_R_wing2" );
	
	playfxontag( level._effect[ "aircraft_light_red_blink" ], self, "tag_light_belly" );
	wait .25;
	playfxontag( level._effect[ "aircraft_light_red_blink" ], self, "tag_light_tail" );
	
	playfxontag( level._effect[ "aircraft_light_cockpit_blue" ], self, "tag_light_cockpit01" );
	playfxontag( level._effect[ "aircraft_light_cockpit_blue" ], self, "tag_light_cockpit01" );
	
	playfxontag( level._effect[ "aircraft_light_cockpit_red" ], self, "tag_light_cargo02" );
	playfxontag( level._effect[ "aircraft_light_cockpit_red" ], self, "tag_light_cargo02" );
}

hallways_heroes(name, _flag, msgs, delays, exits)
{
	if( flag( _flag ) )
		return;		
	level endon(_flag);
	
	if( !isdefined(msgs) )
	{
		msgs = [];
		msgs["alavi"] 	= undefined;
		msgs["grigsby"] = undefined;
		msgs["price"] 	= undefined;
	}
	
	if( !isdefined(exits) )
	{
		exits = [];
		exits["alavi"] 	= undefined;
		exits["grigsby"] = undefined;
		exits["price"] 	= undefined;
	}
	
	if( !isdefined(delays) )
	{
		delays = [];
		delays["alavi"] 	= 0;
		delays["grigsby"] = 1;
		delays["price"] 	= 2;
	}
	
	keys = getarraykeys( level.heroes3 );
	
	for(i=0; i<keys.size; i++)
	{
		key = keys[ i ];
		level.heroes3[ key ] delaythread(delays[ key ], ::hallways_heroes_solo, name, _flag, msgs[ key ], exits[ key ] );
	}
	
	array_wait(level.heroes3, "hallways_heroes_ready");
	flag_wait(name);
}

wtfhack()
{
	wait .25;
	self.disableexits = false;	
}
hallways_heroes_solo(name, _flag, msg, exit)
{
	if( !isdefined( self.dontpushplayer ) )
		self pushplayer(true);
	
	if( flag( _flag ) )
		return;
	level endon( _flag );
	
	self notify( "hallways_heroes_solo" );
	self endon( "hallways_heroes_solo" );
	
	//self.animplaybackrate = 1;
	
	nodes = getnodearray(name,"targetname");
	node = undefined;
	
	for(i=0; i<nodes.size;i++)
	{
		if( nodes[i].script_noteworthy == self.script_noteworthy )
		{
			node = nodes[i];
			break;	
		}
	}	
	
	while( isdefined( node ) )
	{
		self setgoalnode( node );
		if( node.radius )
			self.goalradius = node.radius;
		else
			self.goalradius = 80;
		
		if( isdefined( exit ) )
		{
			reenableexits = true;
			if(isdefined(self.disableexits) && self.disableexits == true)
				reenableexits = false;
			self.disableexits = true;
			ref = undefined;
			
			if( exit == "stand2run180" )
				ref = self;
			else if( isdefined(self.node) && distance(self.node.origin, self.origin) < 4 )
				ref = self.node;
			else if(isdefined(self.goodnode) && distance(self.goodnode.origin, self.origin) < 4)
				ref = self.goodnode;
			else
				ref = self;
				
			pos = spawn("script_origin", ref.origin);
			pos.angles = ref.angles;
			
			self.hackexit = pos;
			
			if( exit == "stand2run180" )
				pos.angles += (0,32,0);
			
			if(ref != self)
			{
				if( issubstr(exit, "cornerleft" ) )
					pos.angles += (0,90,0);
				else if( issubstr(exit, "cornerright" ) )
					pos.angles -= (0,90,0);
			}
				
			self.animname = "guy";
			length = getanimlength( level.scr_anim[ self.animname ][ exit ] );
			pos thread anim_single_solo(self, exit);		
			wait length - .2;
			self stopanimscripted();
			pos delete();
			exit = undefined;
			if(reenableexits)
				thread wtfhack();
		}
		
		self waittill("goal");
		if( isdefined( node.script_parameters ) )
		{
			attr = strtok( node.script_parameters, ":;, " );
			for(j=0;j<attr.size; j++)
			{
				switch( attr[j] )
				{
					case "disable_cqb":
						if(isdefined(node.target))
							self disable_cqbwalk_ign_demo_wrapper();
						else
							self delaythread(1.5, ::disable_cqbwalk_ign_demo_wrapper);
						break;
					case "enable_cqb":
						if(isdefined(node.target))
							self enable_cqbwalk_ign_demo_wrapper();
						else
							self delaythread(1.5, ::enable_cqbwalk_ign_demo_wrapper);
						break;
				}
			}
		}	
	
		if( isdefined( node.target ) )
			node = getnode( node.target, "targetname" );
		else
			node = undefined;
	}
	
	self notify( "hallways_heroes_atgoal");
	
	if( isdefined(msg) )
		radio_msg_stack( msg );
	
	self notify("hallways_heroes_ready");
}

cargohold_flashthrow( offset, velocity, magnitude )
{
	self.animname = "guy";
	if(isdefined(self.node))
		self.goodnode = self.node;
	else
	{
		temp = getallnodes();
		list = [];
		for(i=0; i<temp.size; i++)
		{
			if( issubstr( tolower( temp[i].type ), "cover left" ))
				list[ list.size ] = temp[i];
		}	
		
		self.goodnode = getClosest(self.origin, list, 90);
	}
	node = spawn("script_origin", self.goodnode.origin);
	node.angles = self.goodnode.angles + (0,90,0);
		
	node thread anim_single_solo(self, "grenade_throw");
	
	oldGrenadeWeapon = self.grenadeWeapon;
	self.grenadeWeapon = "flash_grenade";
	self.grenadeAmmo++;
	
	wait 3.5;		
	
	start = self.origin + (30,25,30);
	end = start + offset;
	
	if( isdefined(velocity) )
	{
		end = end + (0,0,200);
		vec = vectornormalize(end - start);
		if( !isdefined(magnitude) )
			magnitude = 350;
		vec = vector_multiply(vec, magnitude);
		
		self magicgrenademanual( start, vec, 1.1 );
	}
	else
		self magicgrenade( start, end, 1.1 );
	self.grenadeWeapon = oldGrenadeWeapon;	
	self.grenadeAmmo = 0;
	
	wait 1.3;
	//self stopanimscripted();
}

/************************************************************************************************************************************/
/************************************************************************************************************************************/
/*                  		                 			  	JUMPTO LOGIC															*/
/************************************************************************************************************************************/
/************************************************************************************************************************************/

jumptoInit()
{
	if (getdvar("jumpto") == "")
    	setdvar("jumpto", "");
    
    if (!isdefined(getdvar ("jumpto")))
	 	setdvar ("jumpto", "");
    	
	//skip to a point in the level
	string1 = getdvar("start");
	string2 = getdvar("jumpto");
	level.jumpto	= "start";
	level.jumptosection = "bridge";
	
	if(isdefined(string1) && !( string1 == "" || issubstr( string1 , " ** ")) )
		level.jumpto = string1;
	if(isdefined(string2) && string2 != "")
		level.jumpto = string2;
	
	jumpnum = 1;
	if(level.jumpto == "bridge" || level.jumpto == "" + jumpnum)	
	{	level.jumptosection = "bridge"; level.jumpto = "bridge"; return; }
	jumpnum++;
	if(level.jumpto == "quarters" || level.jumpto == "" + jumpnum)	
	{	level.jumptosection = "quarters"; level.jumpto = "quarters"; return; }
	jumpnum++;
	if(level.jumpto == "deck" || level.jumpto == "" + jumpnum)	
	{	level.jumptosection = "deck"; level.jumpto = "deck"; return; }
	jumpnum++;
	if(level.jumpto == "hallways" || level.jumpto == "" + jumpnum)	
	{	level.jumptosection = "hallways"; level.jumpto = "hallways"; return; }
	jumpnum++;
	if(level.jumpto == "cargohold" || level.jumpto == "" + jumpnum)	
	{	level.jumptosection = "cargohold"; level.jumpto = "cargohold"; return; }
	jumpnum++;
	if(level.jumpto == "cargohold2" || level.jumpto == "" + jumpnum)	
	{	level.jumptosection = "cargohold2"; level.jumpto = "cargohold2"; return; }
	jumpnum++;
	if(level.jumpto == "laststand" || level.jumpto == "" + jumpnum)	
	{	level.jumptosection = "laststand"; level.jumpto = "laststand"; return; }
	jumpnum++;
	if(level.jumpto == "package" || level.jumpto == "" + jumpnum)	
	{	level.jumptosection = "package"; level.jumpto = "package"; return; }
	jumpnum++;
	if(level.jumpto == "escape" || level.jumpto == "" + jumpnum)	
	{	level.jumptosection = "escape"; level.jumpto = "escape"; return; }
	jumpnum++;
	if(level.jumpto == "end" || level.jumpto == "" + jumpnum)	
	{	level.jumptosection = "end"; level.jumpto = "end"; return; }
	jumpnum++;
}

jumptoThink()
{
	jumptoRandomTrig(level.jumpto);
	trig = [];
	
	switch(level.jumpto)
	{
		case "start":
			//flag_set("_sea_viewbob");
			break;
		case "bridge":
			flag_set("_sea_viewbob");
			flag_wait("heroes_ready");
			
			level.heli maps\mo_fastrope::fastrope_heli_overtake_now();
			level.heli.vehicle setspeed(700, 700);
			level.heli.vehicle setvehgoalpos(getstruct( "intro_ride_node", "targetname" ).origin + (0,0,920), 1);
			level.heli.vehicle settargetyaw(220);
			
			wait 5.5;
			level.player.time = 3;
			//level.player playerlinktodelta(level.player.cgocamera, "tag_player", 1, 15, 15, 5, 5);
			level.heli maps\mo_fastrope::fastrope_player_unload();
			level notify("bridge_jumpto_done");
			
			break;
		case "deck":
			flag_set("_sea_viewbob");
			flag_set("_sea_waves");
			flag_clear("_sea_bob");
			flag_wait("heroes_ready");
						
			level.heli maps\mo_fastrope::fastrope_heli_overtake_now();
			level.heli.vehicle setspeed(300, 300, 250);
			level.heli.vehicle setvehgoalpos(getstruct( "heli_deck_landing_node", "targetname" ).origin + (0,0,146), 1);
			
												
			node = getnode("quarters_price_2","targetname");
			level.heroes5["price"] thread jumptoActor(node.origin);
						
			node = getnode("quarters_alavi_2","targetname");
			level.heroes5["alavi"] thread jumptoActor(node.origin);
						
			level.heli.model heli_searchlight_on();		
			wait 1;
	
			flag_set("deck_drop");
			flag_set("deck_heli");
			flag_set("deck");
			
			break;
		case "hallways":
			flag_set("_sea_viewbob");
			flag_set("_sea_waves");
			
			flag_wait("heroes_ready");
			level.heli maps\mo_fastrope::fastrope_heli_overtake_now();
						
			temp = getnodearray("hallways_door_open_guard","targetname");
			node = [];
			for(i=0; i<temp.size; i++)
				node[temp[i].script_noteworthy] = temp[i];
						
			level.heroes5["price"] 	thread jumptoActor(node["alavi"].origin + (-100,0,0) );
			level.heroes5["grigsby"] thread jumptoActor(node["alavi"].origin + (250,0,0));
			
			level.heroes5["alavi"] 	thread jumptoActor(node["alavi"].origin);
			level.heroes5["seat5"] 	thread jumptoActor(node["seat5"].origin);
			level.heroes5["seat6"] 	thread jumptoActor(node["seat6"].origin);
			
			level.heroes5["price"] 	disable_cqbwalk_ign_demo_wrapper();
			level.heroes5["grigsby"] disable_cqbwalk_ign_demo_wrapper();
			level.heroes5["alavi"] 	disable_cqbwalk_ign_demo_wrapper();
			level.heroes5["seat5"] disable_cqbwalk_ign_demo_wrapper();
			level.heroes5["seat6"] 	disable_cqbwalk_ign_demo_wrapper();
						
			wait .1;
			level.heli.model delete();
			level.heli.vehicle delete();
						
			level.heroes7["pilot"] delete();
			level.heroes7["copilot"] delete();
			
			flag_set("hallways");
			flag_set("hallways_moveup");
			break;
		case "cargohold":
			flag_clear("_sea_waves");
			flag_clear("topside_fx");
			flag_set("_sea_viewbob");
			flag_set("cargohold_fx");
			thread maps\_weather::rainNone(1);
			set_vision_set( "cargoship_indoor", 1 );
			
			flag_wait("heroes_ready");
			level.heli maps\mo_fastrope::fastrope_heli_overtake_now();
						
			temp = getnodearray("hallways_door_open_guard","targetname");
			node = [];
			for(i=0; i<temp.size; i++)
				node[temp[i].script_noteworthy] = temp[i];
						
			level.heroes5["seat5"] 	thread jumptoActor(node["seat5"].origin);
			level.heroes5["seat6"] 	thread jumptoActor(node["seat6"].origin);
			
			temp = getnodearray("hallways_lowerhall2","targetname");
			node = [];
			for(i=0; i<temp.size; i++)
				node[temp[i].script_noteworthy] = temp[i];
			
			level.heroes5["alavi"] 	thread jumptoActor(node["alavi"].origin);
			level.heroes5["price"] 	thread jumptoActor(node["price"].origin);
			level.heroes5["grigsby"] thread jumptoActor(node["grigsby"].origin);
			
			level.heroes5["price"] 	enable_cqbwalk_ign_demo_wrapper();
			level.heroes5["grigsby"] enable_cqbwalk_ign_demo_wrapper();
			level.heroes5["alavi"] 	enable_cqbwalk_ign_demo_wrapper();
			level.heroes5["seat5"] disable_cqbwalk_ign_demo_wrapper();
			level.heroes5["seat6"] 	disable_cqbwalk_ign_demo_wrapper();
			
			level.heroes5["price" ].baseaccuracy 	= level.heroes5["price" ].cgo_old_baseaccuracy;
			level.heroes5["alavi" ].baseaccuracy 	= level.heroes5["price" ].cgo_old_baseaccuracy;
			level.heroes5["grigsby" ].baseaccuracy 	= level.heroes5["price" ].cgo_old_baseaccuracy;
			level.heroes5["price" ].accuracy 		= level.heroes5["price" ].cgo_old_accuracy;
			level.heroes5["alavi" ].accuracy 		= level.heroes5["price" ].cgo_old_accuracy;
			level.heroes5["grigsby" ].accuracy 		= level.heroes5["price" ].cgo_old_accuracy;

			thread player_speed_set(137, 1);
									
			getent("hallways_lower_runners", "target") trigger_off();
			getent("hallways_lower_runners2", "target") trigger_off();
									
			flag_set("hallways_lowerhall2");
			break;
		case "cargohold2":
			flag_clear("_sea_waves");
			flag_clear("topside_fx");
			flag_set("_sea_viewbob");
			flag_set("cargohold_fx");
			thread maps\_weather::rainNone(1);
			set_vision_set( "cargoship_indoor", 1 );
			
			flag_wait("heroes_ready");
			level.heli maps\mo_fastrope::fastrope_heli_overtake_now();
						
			temp = getnodearray("hallways_door_open_guard","targetname");
			node = [];
			for(i=0; i<temp.size; i++)
				node[temp[i].script_noteworthy] = temp[i];
						
			level.heroes5["seat5"] 	thread jumptoActor(node["seat5"].origin);
			level.heroes5["seat6"] 	thread jumptoActor(node["seat6"].origin);
			
			temp = getnodearray("cargoholds_1_part5","targetname");
			node = [];
			for(i=0; i<temp.size; i++)
				node[temp[i].script_noteworthy] = temp[i];
			
			level.heroes5["alavi"] 	thread jumptoActor(node["alavi"].origin);
			level.heroes5["price"] 	thread jumptoActor(node["price"].origin);
			level.heroes5["grigsby"] thread jumptoActor(node["grigsby"].origin);
			
			level.heroes5["price"] 	enable_cqbwalk_ign_demo_wrapper();
			level.heroes5["grigsby"] enable_cqbwalk_ign_demo_wrapper();
			level.heroes5["alavi"] 	enable_cqbwalk_ign_demo_wrapper();
			level.heroes5["seat5"] disable_cqbwalk_ign_demo_wrapper();
			level.heroes5["seat6"] 	disable_cqbwalk_ign_demo_wrapper();
			
			level.heroes5["price" ].baseaccuracy 	= level.heroes5["price" ].cgo_old_baseaccuracy;
			level.heroes5["alavi" ].baseaccuracy 	= level.heroes5["price" ].cgo_old_baseaccuracy;
			level.heroes5["grigsby" ].baseaccuracy 	= level.heroes5["price" ].cgo_old_baseaccuracy;
			level.heroes5["price" ].accuracy 		= level.heroes5["price" ].cgo_old_accuracy;
			level.heroes5["alavi" ].accuracy 		= level.heroes5["price" ].cgo_old_accuracy;
			level.heroes5["grigsby" ].accuracy 		= level.heroes5["price" ].cgo_old_accuracy;
			level.heroes5["grigsby"].wantshotgun = true;

			thread player_speed_set(137, 1);
									
			getent("hallways_lower_runners", "target") trigger_off();
			getent("hallways_lower_runners2", "target") trigger_off();
			getent("cargohold1_flashed_enemies", "target") trigger_off();
			array_thread(getentarray("pulp_fiction_trigger", "targetname"), ::trigger_off );
									
			flag_set("cargoholds2");
			break;
			
		case "laststand":
			flag_clear("_sea_waves");
			flag_clear("topside_fx");
			flag_set("_sea_viewbob");
			flag_set("cargohold_fx");
			
			thread maps\_weather::rainNone(1);
			set_vision_set( "cargoship_indoor", 1 );
			
			flag_wait("heroes_ready");
			level.heli maps\mo_fastrope::fastrope_heli_overtake_now();
						
			temp = getnodearray("hallways_door_open_guard","targetname");
			node = [];
			for(i=0; i<temp.size; i++)
				node[temp[i].script_noteworthy] = temp[i];
						
			level.heroes5["seat5"] 	thread jumptoActor(node["seat5"].origin);
			level.heroes5["seat6"] 	thread jumptoActor(node["seat6"].origin);
			
			temp = getnodearray("cargohold2_door","targetname");
			node = [];
			for(i=0; i<temp.size; i++)
				node[temp[i].script_noteworthy] = temp[i];
			
			level.heroes5["alavi"] 	thread jumptoActor(node["alavi"].origin);
			level.heroes5["price"] 	thread jumptoActor(node["price"].origin);
			level.heroes5["grigsby"] thread jumptoActor(node["grigsby"].origin);
			
			level.heroes5["price"] 	enable_cqbwalk_ign_demo_wrapper();
			level.heroes5["grigsby"] enable_cqbwalk_ign_demo_wrapper();
			level.heroes5["alavi"] 	enable_cqbwalk_ign_demo_wrapper();
			level.heroes5["seat5"] disable_cqbwalk_ign_demo_wrapper();
			level.heroes5["seat6"] 	disable_cqbwalk_ign_demo_wrapper();
			
			level.heroes5["price" ].baseaccuracy 	= level.heroes5["price" ].cgo_old_baseaccuracy;
			level.heroes5["alavi" ].baseaccuracy 	= level.heroes5["price" ].cgo_old_baseaccuracy;
			level.heroes5["grigsby" ].baseaccuracy 	= level.heroes5["price" ].cgo_old_baseaccuracy;
			level.heroes5["price" ].accuracy 		= level.heroes5["price" ].cgo_old_accuracy;
			level.heroes5["alavi" ].accuracy 		= level.heroes5["price" ].cgo_old_accuracy;
			level.heroes5["grigsby" ].accuracy 		= level.heroes5["price" ].cgo_old_accuracy;
			level.heroes5["grigsby"].wantshotgun = true;
			
			level.heroes5["price" ].ignoreme 	= false;
			level.heroes5["alavi" ].ignoreme 	= false;
			level.heroes5["grigsby" ].ignoreme 	= false;
			
			thread player_speed_set(137, 1);
			
			getent("hallways_lower_runners", "target") trigger_off();
			getent("hallways_lower_runners2", "target") trigger_off();
			getent("cargohold1_flashed_enemies", "target") trigger_off();
			getent("cargohold2_catwalk_enemies2", "target") trigger_off();
			getent("cargohold2_catwalk_enemies", "target") trigger_off();
			array_thread(getentarray("pulp_fiction_trigger", "targetname"), ::trigger_off );
						
			flag_set("laststand");
			
			break;
		case "package":
			flag_clear("_sea_waves");
			flag_clear("topside_fx");
			flag_set("_sea_viewbob");
			flag_set("cargohold_fx");
			
			thread maps\_weather::rainNone(1);
			set_vision_set( "cargoship_indoor", 1 );
			
			flag_wait("heroes_ready");
			level.heli maps\mo_fastrope::fastrope_heli_overtake_now();
						
			temp = getnodearray("hallways_door_open_guard","targetname");
			node = [];
			for(i=0; i<temp.size; i++)
				node[temp[i].script_noteworthy] = temp[i];
						
			level.heroes5["seat5"] 	thread jumptoActor(node["seat5"].origin);
			level.heroes5["seat6"] 	thread jumptoActor(node["seat6"].origin);
			
			temp = getnodearray("package1","targetname");
			node = [];
			for(i=0; i<temp.size; i++)
				node[temp[i].script_noteworthy] = temp[i];
			
			level.heroes5["alavi"] 	thread jumptoActor(node["alavi"].origin);
			level.heroes5["price"] 	thread jumptoActor(node["price"].origin);
			level.heroes5["grigsby"] thread jumptoActor(node["grigsby"].origin);
			
			level.heroes5["price"] 	disable_cqbwalk_ign_demo_wrapper();
			level.heroes5["grigsby"] disable_cqbwalk_ign_demo_wrapper();
			level.heroes5["alavi"] 	disable_cqbwalk_ign_demo_wrapper();
			level.heroes5["seat5"] disable_cqbwalk_ign_demo_wrapper();
			level.heroes5["seat6"] 	disable_cqbwalk_ign_demo_wrapper();
			level.heroes5["grigsby"].wantshotgun = true;
			
			getent("hallways_lower_runners", "target") trigger_off();
			getent("hallways_lower_runners2", "target") trigger_off();
			getent("cargohold1_flashed_enemies", "target") trigger_off();
			getent("cargohold3_enemies1", "target") trigger_off();
			getent("cargohold3_enemies2", "target") trigger_off();
			getent("cargohold3_enemies3", "target") trigger_off();
			getent("cargohold2_catwalk_enemies2", "target") trigger_off();
			getent("cargohold2_catwalk_enemies", "target") trigger_off();
			array_thread(getentarray("pulp_fiction_trigger", "targetname"), ::trigger_off );
			
			
			flag_set("package");
			break;
		case "escape":
	
			//thread maps\cargoship::package_open_doors();
		
			flag_clear("_sea_waves");
			flag_clear("topside_fx");
			flag_set("_sea_viewbob");
			flag_set("cargohold_fx");
			thread maps\_weather::rainNone(1);
			set_vision_set( "cargoship_indoor", 1 );
			
			flag_wait("heroes_ready");
			level.heli maps\mo_fastrope::fastrope_heli_overtake_now();
						
			temp = getnodearray("escape_nodes","targetname");
			node = [];
			for(i=0; i<temp.size; i++)
				node[temp[i].script_noteworthy] = temp[i];
			
			level.heroes3["price"] 	thread jumptoActor(node["price"].origin);
			level.heroes3["grigsby"] thread jumptoActor(node["grigsby"].origin);
			level.heroes3["alavi"] 	thread jumptoActor(node["alavi"].origin);
			
			level.heroes3["price"] 	disable_cqbwalk_ign_demo_wrapper();
			level.heroes3["grigsby"] disable_cqbwalk_ign_demo_wrapper();
			level.heroes3["alavi"] 	disable_cqbwalk_ign_demo_wrapper();
			level.heroes5["grigsby"].wantshotgun = true;
			
			level.heroes3["price"] setmodel( "body_complete_sp_sas_ct_price_maskup" );
						
			wait .1;
			level.heli.model delete();
			level.heli.vehicle delete();
						
			temp = getnodearray("hallways_door_open_guard","targetname");
			node = [];
			for(i=0; i<temp.size; i++)
				node[temp[i].script_noteworthy] = temp[i];
						
			level.heroes5["seat5"] 	thread jumptoActor(node["seat5"].origin);
			level.heroes5["seat6"] 	thread jumptoActor(node["seat6"].origin);
			
			level.heroes7["pilot"] delete();
			level.heroes7["copilot"] delete();
			
			getent("hallways_lower_runners", "target") trigger_off();
			getent("hallways_lower_runners2", "target") trigger_off();
			getent("cargohold1_flashed_enemies", "target") trigger_off();
			getent("cargohold3_enemies1", "target") trigger_off();
			getent("cargohold3_enemies2", "target") trigger_off();
			getent("cargohold3_enemies3", "target") trigger_off();
			getent("cargohold2_catwalk_enemies2", "target") trigger_off();
			getent("cargohold2_catwalk_enemies", "target") trigger_off();
			array_thread(getentarray("pulp_fiction_trigger", "targetname"), ::trigger_off );
			
			flag_set("escape");
			thread flag_set_delayed("package_secure", 1);
			
			break;
			
		case "end":	
			flag_clear("_sea_waves");
			flag_clear("cargohold_fx");
			flag_set("topside_fx");
			flag_set("_sea_viewbob");
			flag_clear("_sea_bob");
			thread maps\_weather::rainNone(1);
			set_vision_set( "cargoship_indoor", 1 );
			
			flag_wait("heroes_ready");
						
			level.heli maps\mo_fastrope::fastrope_heli_overtake_now();
						
			keys = getarraykeys(level.heroes5);
			for(i=0; i<keys.size; i++)
			{
				key = keys[ i ];
				guy = level.heroes5[ key ];
				guy notify( "stop_" + guy.index );
				level.heli.model notify( "stop_" + guy.index );
			}
			
			waittillframeend;
			
			temp = getnodearray("hallway_attack","targetname");
			node = [];
			for(i=0; i<temp.size; i++)
				node[temp[i].script_noteworthy] = temp[i];
			
			level.heroes3["price"] 	thread jumptoActor(node["price"].origin);
			level.heroes3["grigsby"] thread jumptoActor(node["grigsby"].origin);
			level.heroes3["alavi"] 	thread jumptoActor(node["alavi"].origin);
			
			level.heroes3["price"] 	disable_cqbwalk_ign_demo_wrapper();
			level.heroes3["grigsby"] disable_cqbwalk_ign_demo_wrapper();
			level.heroes3["alavi"] 	disable_cqbwalk_ign_demo_wrapper();
			
			level.heroes3["price"] setmodel( "body_complete_sp_sas_ct_price_maskup" );
						
			level.heli.model delete();
			level.heli.vehicle delete();
						
			temp = getnodearray("hallways_door_open_guard","targetname");
			node = [];
			for(i=0; i<temp.size; i++)
				node[temp[i].script_noteworthy] = temp[i];
						
			level.heroes5["seat5"] 	thread jumptoActor(node["seat5"].origin);
			level.heroes5["seat6"] 	thread jumptoActor(node["seat6"].origin);
			
			level.heroes7["pilot"] delete();
			level.heroes7["copilot"] delete();
			
			getent("hallways_lower_runners", "target") trigger_off();
			getent("hallways_lower_runners2", "target") trigger_off();
			getent("cargohold1_flashed_enemies", "target") trigger_off();
			getent("cargohold3_enemies1", "target") trigger_off();
			getent("cargohold3_enemies2", "target") trigger_off();
			getent("cargohold3_enemies3", "target") trigger_off();
			getent("cargohold2_catwalk_enemies2", "target") trigger_off();
			getent("cargohold2_catwalk_enemies", "target") trigger_off();
			array_thread(getentarray("pulp_fiction_trigger", "targetname"), ::trigger_off );
			
			flag_set("escape");
			flag_set("package_secure");
			flag_set("escape_hallway_lower_flag");
			flag_set( "cargoship_end_music" );
			
			array_thread(getentarray("escape_flags","script_noteworthy"), ::trigger_on);
						
			waittillframeend;
			
			playerWeaponTake();
			
			level.heroes3["alavi"].animname 	= "escape";
			level.heroes3["grigsby"].animname 	= "escape";
			level.heroes3["price"].animname 	= "escape";
			
			pack = [];
			pack[ pack.size ] = level.heroes3["price"];
			pack[ pack.size ] = level.heroes3["alavi"];
			pack[ pack.size ] = level.heroes3["grigsby"];
			
			level.heroes3["price"] 		ent_flag_init("turning");
			level.heroes3["grigsby"]	ent_flag_init("turning");
			level.heroes3["alavi"]		ent_flag_init("turning");
			
			level.heroes3["alavi"] thread escape_heroes_holdtheline(500, pack, 200);
			level.heroes3["grigsby"] thread escape_heroes_holdtheline(400, pack, 150);
			level.heroes3["price"] thread escape_heroes_holdtheline(350, pack, 150);
			
			escape_heroes_turn_setup();
			escape_heroes_runanim_setup();
			thread maps\cargoship::escape_seaknight();
			thread maps\cargoship::end_main();
			
			level.heroes3["alavi"] thread function_stack( ::escape_heroes_run, "escape_aftdeck" );	
			level.heroes3["grigsby"] delaythread(2,::function_stack, ::escape_heroes_run, "escape_aftdeck" );	
			level.heroes3["price"] delaythread(3, ::function_stack, ::escape_heroes_run, "escape_aftdeck" );	
			
		/*	keys = getarraykeys(level.heroes3);
			for(i=0; i<keys.size; i++)
			{
				key = keys[ i ];
				level.heroes3[ key ] delaythread(3.5, ::function_stack, ::escape_heroes_run, "escape_aftdeckb");
			}*/
			
			thread flag_set_delayed( "escape_hallway_upper_flag", 3.75 );
			
			level._sea_org notify("tilt_40_degrees");
			level._sea_org.sway = "sway1";
			level._sea_org notify("sway1");
					
			level._sea_org.time = .1;
			level._sea_org.acctime = level._sea_org.time * .5;
			level._sea_org.dectime = level._sea_org.time * .5;
			level._sea_org.rotation = (0,0,-40);
			
			level._sea_link rotateto(level._sea_org.rotation, level._sea_org.time, level._sea_org.acctime, level._sea_org.dectime);	
			level._sea_org 	rotateto(level._sea_org.rotation, level._sea_org.time, level._sea_org.acctime, level._sea_org.dectime);	
						
			level._sea_link movez(-300, .1 );//, .5, .5); 
			level._sea_org movez(-300, .1);//, .5, .5);
			
			break;
	}
	
	switch(level.jumpto)
	{
		case "end":
		case "escape":
		case "package":
			door = getent( "cargohold1_door", "targetname" );
			clip = getent(door.target, "targetname");
			clip notsolid();
			clip connectpaths();
			door door_opens();	
		case "cargohold":		
			door = getent( "hallways_door", "targetname" );
			clip = getent(door.target, "targetname");
			clip notsolid();
			clip connectpaths();
			door door_opens();
	}
		
	array_thread(trig, ::jumptoRandomTrigThink);
	
	if( level.jumpto != "end" )
		playerWeaponGive();
	
	node = getstruct(("jumpto_" + level.jumpto), "targetname");
	if(!isdefined(node))
		return;
	
	level.player unlink();
	level.player allowLean(true);
	level.player allowcrouch(true);
	level.player allowprone(true);
	level.player setorigin (node.origin + (0,0,8));
	level.player setplayerangles (node.angles);
}

jumptoActor(org)
{
	self notify("overtakenow");
	self unlink();
	self stopanimscripted();
	link = spawn("script_origin", self.origin);
	self linkto(link);
	link moveto(org, .2);
	
	wait .25;
	
	self unlink();
	link delete();
	self.loops = 0;

	self setgoalpos(org);
	self.goalradius = 16;
	
	self waittill_notify_or_timeout("goal", 1.25);
	wait .1;
	self setgoalpos(org);
	self.goalradius = 16;
}

jumptoRandomTrig(name)
{
	array = getentarray("jumptoRandomTrig", "script_noteworthy");
	for(i=0;i<array.size;i++)
	{
		attr = strtok(array[i].script_parameters, ":;, ");
		for(j=0;j<attr.size; j++)
		{
			if(attr[j] == name)
			{
				array[i].jumptoRandomType = tolower(attr[j+1]);
				array[i] thread jumptoRandomTrigThink();
				break;	
			}
		}
	}
}

jumptoRandomTrigThink()
{
	if(self.classname != "trigger_multiple" && self.classname != "trigger_radius" && (!isdefined(self.jumptoRandomType)) )
		return;
	if(!isdefined(self.jumptoRandomType))
		self.jumptoRandomType = "trigger";
	switch(self.jumptoRandomType)
	{
		case "trigger":		{wait .1; self notify("trigger"); 	}break;
		case "off":			{self trigger_off(); 				}break;
		case "open":		{self door_breach_door(); 			}break;
	}
}


escape_catwalk()
{
	catwalk = getent("escape_catwalk","targetname");
	attachments = getentarray(catwalk.targetname, "target");	
	
	for(i=0; i<attachments.size; i++)
		attachments[i] linkto( catwalk );
	
	flag_wait("escape_catwalk");
	
	//catwalk moveto( catwalk getorigin() + ( 0, 4, -4 ), .25, 0, 0 );	
	catwalk movez( -4 , .25, 0, 0 );	
	catwalk rotateto( (0, 0, 5) , .25, 0, 0 );	
	catwalk waittill("rotatedone");
	
	catwalk thread escape_catwalk_sway();
	
	flag_wait_either("escape_death_cargohold1", "escape_catwalk_fall");
	
	red_overlay = create_overlay_element( "overlay_hunted_red", 0 );
	thread escape_catwalk_live( red_overlay );
	
	red_overlay thread exp_fade_overlay( 1, 6);
		
	catwalk notify("stop_swaying");
	
	time = 2.5;
	if( level.gameSkill == 0 )//easy
		time = 3.5;
	
	catwalk rotateto( (20, -50, 50) , time, time, 0 );	
	wait time;
	catwalk movez( -16 , 1.5, 0, 1.5 );	
	catwalk rotateto( (10, 0, 90) , 1.5, 0, 1.5 );	
	
	wait 2;
	if( !flag("escape_catwalk_madeit") )
		escape_mission_failed();
}

escape_catwalk_live( overlay )
{
	flag_wait("escape_catwalk_madeit");
	overlay exp_fade_overlay( 0, .5);
	overlay destroy();
}

escape_catwalk_sway()
{	
	self endon("stop_swaying");
	
	while(1)
	{
		self rotateto( (0, -2, -2) , 1, .5, .5 );	
		self waittill("rotatedone");
		self rotateto( (0, -2, 2) , 1, .5, .5 );
		self waittill("rotatedone");
	}
}

escape_heroes_turn_setup()
{
	temp = getentarray("escape_turn_animations", "targetname");
	level.escape_turns = [];
	for(i=0; i<temp.size; i++)
		level.escape_turns[ temp[i].script_noteworthy ] = temp[i];	
}

#using_animtree("generic_human");
escape_turn( xanim )
{
	level endon("killanimscript");
	
	self OrientMode( "face angle", self.turn_anim[ "angle" ][1] );
	self setflaggedanimknoball( "custom_anim", self.turn_anim[ "anim" ], %body, 1, .2, self.turn_anim[ "rate" ] );
	wait self.turn_anim[ "wait" ];
}

escape_heroes_run(name)
{				
	self allowedstances("stand", "crouch");
	
	self pushplayer( true );
	self.goalradius = 116;
	self.ignoreme = true;
	self.ignoresuppression = true;
	self.interval = 0;//self.oldinterval;
	self.disableArrivals = true;
		
	if( isdefined( level.escape_turns[ name ] ) )
	{
		animnode 	= level.escape_turns[ name ];
		anime 		= animnode.script_parameters;
		xanim 		= self getanim( anime );
		length 		= getanimlength( xanim );
		origin  	= getstartorigin(animnode.origin, animnode.angles, xanim );
		
		self setgoalpos( origin );
		self.goalradius = 20;
		self waittill("goal");
		
		
		level.escape_run_section = name;
		
		self.turn_anim = [];
		self.turn_anim[ "anim" ] 	= xanim;
		self.turn_anim[ "angle" ]	= animnode.angles;
		self.turn_anim[ "length" ] 	= length;
		self.turn_anim[ "rate" ] 	= 2.1;
		self.turn_anim[ "wait" ] 	= ( length / self.turn_anim[ "rate" ] ) - .2;
		
		self animcustom(::escape_turn );
		//if( isdefined( level.current_run[ name ] ) )
		self delayThread( (self.turn_anim[ "wait" ] - .2), ::set_generic_run_anim, level.current_run[ name ][ self.run_speed_state ] );	
		
		wait ( self.turn_anim[ "wait" ] );
	}
	else //if( isdefined( level.current_run[ name ] ) )
		self delayThread( .75, ::set_generic_run_anim, level.current_run[ name ][ self.run_speed_state ] );	
	
		
	temp = getnodearray(name + "_start","targetname");
	
	if( isdefined(temp) && temp.size )
	{
	
		node = undefined;
		
		for(i=0; i<temp.size; i++)
		{
			if(	temp[i].script_noteworthy == self.script_noteworthy )
			{
				node = temp[i];
				break;	
			}
		}
	
		while( isdefined( node ) )
		{
			self setgoalnode( node );
			
			if( node.radius )
				self.goalradius = node.radius;
			else
				self.goalradius = 116;
		
			self waittill("goal");
			
			if(isdefined(node.target))
				node = getnode(node.target, "targetname");
			else
				node = undefined;
		}
	}
	
	self notify("end_escape_run");
}

escape_heroes2()
{	
	self.animplaybackrate = 1.0;
	self.moveplaybackrate = 1.0;
		
	node = spawn("script_origin", self.origin);
	node.angles = (0, 180, 0);
	
	self.oldanimname = self.animname;
	self.animname = "escape";
	
	self allowedstances("crouch", "stand");
	
	self stopanimscripted();
	self linkto( node );
	node thread anim_single_solo(self, "blowback");
	
	pos = undefined;
	
	switch(self.script_noteworthy)
	{
		case "alavi":
			pos = (600, -160,  -359);
			break;	
		case "grigsby":
			self gun_remove();
			pos = (520, -320,  -359);
			break;	
		case "price":
			self allowedstances("prone");
			pos = (442, -230,  -359);
			break;	
	}
	
	node moveto( pos, 1, 0, .5);
	
	//wait 10;
	//self stopanimscripted();
	
	if( self.script_noteworthy == "price")
		wait 5;
	else
		self waittillmatch("single anim", "end");
	
	switch(self.script_noteworthy)
	{
		case "alavi":
			pos = self.origin;
			break;	
		case "grigsby":
			pos = self.origin + (45, 45,  0);
			break;	
		case "price":
			node delete();
			self allowedstances("stand");
			break;	
	}
	
	//new
	if( self.script_noteworthy == "price" )
		return;
	
	self stopanimscripted();
	self unlink();
	self setgoalpos( pos );
	self.goalradius = 16;
	self.animname = self.oldanimname;
	
	switch(self.script_noteworthy)
	{
		case "price":
			wait 2;
			node.origin = self.origin;
			node.angles = (0,230,0);
			node anim_single_solo(self, "standup");	
			break;
		case "grigsby":
			wait .5;
			self animscripts\shared::placeWeaponOn( self.weapon, "right" );
			node.origin += (0,-35,0);
			node.angles = (0,360,0);
			node anim_single_solo(self, "stumble3");	
			break;
	}	
	
	node delete();
	self allowedstances("stand");
}

escape_heroes()
{
	level endon ("escape_explosion");
	//self.disableArrivals = true;
	temp = getnodearray("escape_nodes","targetname");
	node = undefined;
	for(i=0; i<temp.size; i++)
	{
		if(	temp[i].script_noteworthy == self.script_noteworthy )
		{
			node = temp[i];
			break;	
		}
	}
	
	self allowedstances("crouch", "stand");
	
	time = 0;
	switch(self.script_noteworthy)
	{
		case "grigsby":
			time = 0;
			break;
		case "price":
			time = .4;
			break;
		case "alavi":
			time = 1;
			break;	
	}
	
	self pushplayer( true );
	self.goalradius = 80;
	self.ignoreme = true;
	self.ignoresuppression = true;
	self.oldinterval = self.interval;
	self.interval = 0;
		
	while( isdefined( node ) )
	{
		self setgoalnode( node );
		
		if( node.radius )
			self.goalradius = node.radius;
		else
			self.goalradius = 80;
	
		self waittill("goal");
		
		struct = getstruct(node.targetname, "target");
		if( isdefined( struct ) )
		{
			trig = getent( struct.targetname, "target" );
			if( !flag( trig.script_flag ) )
			{
				flag_wait( trig.script_flag );
				if(trig.script_flag == "escape_moveup1")
					wait time;
			}
		}
		
		if(isdefined(node.target))
			node = getnode(node.target, "targetname");
		else
			node = undefined;
	}
	
}

escape_waterlevel()
{	
	level waittill("escape_show_waterlevel");
	self geo_on();
		
	start = self.path;
	self show();
	self moveto(start.origin, .5);
	self rotateto(start.angles, .5);
	
	wait .5;
	self notify("show");
	
	level._sea_org waittill("tilt_20_degrees");
	
	start = getstruct(start.target, "targetname");
	self moveto(start.origin, level._sea_org.time, level._sea_org.acctime, level._sea_org.dectime);
	self rotateto(start.angles, level._sea_org.time, level._sea_org.acctime, level._sea_org.dectime);
	
	level._sea_org waittill("tilt_30_degrees");
	
	start = getstruct(start.target, "targetname");
	self moveto(start.origin, level._sea_org.time, level._sea_org.acctime, level._sea_org.dectime);
	self rotateto(start.angles, level._sea_org.time, level._sea_org.acctime, level._sea_org.dectime);
}

escape_tilt_gravity( degrees )
{
	level endon("stop_escape_tilt_gravity");
	if(isdefined (degrees))
	{
		ang = (0,0,degrees);
		vec1 = vector_multiply( anglestoup( ang ), -1 );
		vec2 = vector_multiply( anglestoright( ang ), .25);
		vec = vec1 + vec2;
		setPhysicsGravityDir( vec );		
	}
	while(1)
	{
		wait .05;
		vec1 = vector_multiply( anglestoup( level._sea_org.angles ), -1 );
		vec2 = vector_multiply( anglestoright( level._sea_org.angles ), .25);
		vec = vec1 + vec2;
		setPhysicsGravityDir( vec );
	}
}
escape_tiltboat()
{	
	flag_wait("start_sinking_boat");
	
	setsaveddvar("phys_gravityChangeWakeupRadius", 1600);
	
	objects = getentarray("boat_sway", "script_noteworthy");
	for(i=0; i<objects.size; i++)
		objects[i].link.setscale = 1.0;
	
	level waittill("escape_show_waterlevel");
	thread escape_tilt_gravity();
	
	level._sea_org.time = 1;
	level._sea_org.rotation = (0,0,-10);	//10 degrees
		
	if(level._sea_org.sway == "sway2")
	{
		level._sea_org.sway = "sway1";
		level._sea_org notify("sway1");
		wait .05;
	}
	
	level._sea_org.sway = "sway2";
	level._sea_org notify("sway2");
	
	level._sea_link rotateto(level._sea_org.rotation, level._sea_org.time, 1, 0);	
	level._sea_org 	rotateto(level._sea_org.rotation, level._sea_org.time, 1, 0);	
	
	wait level._sea_org.time;
	level notify("stop_escape_tilt_gravity");
	
	level waittill("escape_unlink_player");
	thread escape_tilt_gravity();
	
	level._sea_org.time = 3.5;
	level._sea_org.acctime = 0;
	level._sea_org.dectime = 1.75;
	level._sea_org.rotation = (0,0,-20);	//20 degrees
	
	level._sea_org notify("tilt_20_degrees");
	level._sea_org.sway = "sway1";
	level._sea_org notify("sway1");
	
	level._sea_link rotateto(level._sea_org.rotation, level._sea_org.time, level._sea_org.acctime, level._sea_org.dectime);	
	level._sea_org 	rotateto(level._sea_org.rotation, level._sea_org.time, level._sea_org.acctime, level._sea_org.dectime);	
	
	wait level._sea_org.time;
	level notify("stop_escape_tilt_gravity");
	
	flag_wait("escape_tilt_30");
	thread escape_tilt_gravity(-40);
	
	level._sea_org.time = 3.5;
	level._sea_org.acctime = 1.75;
	level._sea_org.dectime = 1.75;
	level._sea_org.rotation = (0,0,-32);	//30 degrees
	
	level._sea_org notify("tilt_30_degrees");
	level._sea_org.sway = "sway2";
	level._sea_org notify("sway2");
	
	level._sea_link rotateto(level._sea_org.rotation, level._sea_org.time, level._sea_org.acctime, level._sea_org.dectime);	
	level._sea_org 	rotateto(level._sea_org.rotation, level._sea_org.time, level._sea_org.acctime, level._sea_org.dectime);	
	wait level._sea_org.time;
	
	level._sea_org.time = 1;
	level._sea_org.acctime = level._sea_org.time * .5;
	level._sea_org.dectime = level._sea_org.time * .5;
	level._sea_org.rotation = (0,0,-30);
	
	level._sea_link rotateto(level._sea_org.rotation, level._sea_org.time, level._sea_org.acctime, level._sea_org.dectime);	
	level._sea_org 	rotateto(level._sea_org.rotation, level._sea_org.time, level._sea_org.acctime, level._sea_org.dectime);	
	
	wait level._sea_org.time;	
	level notify("stop_escape_tilt_gravity");
	
	flag_wait("escape_cargohold1_enter");
	thread escape_tilt_gravity();
	
	level._sea_org.time = 3.5;
	level._sea_org.acctime = 1.75;
	level._sea_org.dectime = 1.75;
	level._sea_org.rotation = (0,0,-42);	//40 degrees
	
	level._sea_org notify("tilt_40_degrees");
	level._sea_org.sway = "sway1";
	level._sea_org notify("sway1");
	
	level._sea_link rotateto(level._sea_org.rotation, level._sea_org.time, level._sea_org.acctime, level._sea_org.dectime);	
	level._sea_org 	rotateto(level._sea_org.rotation, level._sea_org.time, level._sea_org.acctime, level._sea_org.dectime);	
	wait level._sea_org.time;
	
	level._sea_org.time = 1;
	level._sea_org.acctime = level._sea_org.time * .5;
	level._sea_org.dectime = level._sea_org.time * .5;
	level._sea_org.rotation = (0,0,-40);
	
	level._sea_link rotateto(level._sea_org.rotation, level._sea_org.time, level._sea_org.acctime, level._sea_org.dectime);	
	level._sea_org 	rotateto(level._sea_org.rotation, level._sea_org.time, level._sea_org.acctime, level._sea_org.dectime);	
	
	wait level._sea_org.time;
	level notify("stop_escape_tilt_gravity");
	
	level._sea_link movez(-300, 1, .5, .5); 
	level._sea_org movez(-300, 1, .5, .5);
	
	flag_wait("escape_hallway_lower_enter");
	wait .5;
	
	vec = vector_multiply( anglestoup( level._sea_org.angles ), -1 );
	setPhysicsGravityDir( vec );	
	setsaveddvar("phys_gravityChangeWakeupRadius", 1000);
}

escape_fx_setup()
{
	allcargoholdfx	= getfxarraybyID( "cargo_vl_red_thin" );
	allcargoholdfx 	= array_combine(allcargoholdfx, getfxarraybyID( "cargo_vl_red_lrg" ));
	allcargoholdfx 	= array_combine(allcargoholdfx, getfxarraybyID( "cargo_steam" ));
	allcargoholdfx 	= array_combine(allcargoholdfx, getfxarraybyID( "cargo_steam_add" ));
	
	escapefx = getfxarraybyID( "sparks_runner" );
	escapefx = array_combine(escapefx, getfxarraybyID( "escape_waternoise" ) );
	escapefx = array_combine(escapefx, getfxarraybyID( "escape_waternoise_ud" ) );
	escapefx = array_combine(escapefx, getfxarraybyID( "escape_waterdrips" ) );
	escapefx = array_combine(escapefx, getfxarraybyID( "escape_caustics" ) );
	
	
	flag_wait("start_sinking_boat");
	array_thread(allcargoholdfx, ::pauseEffect);
	
	flag_wait("escape_explosion");
	
	array_thread(escapefx, ::restartEffect);
	
	pipes = getentarray("escape_pipe","script_noteworthy");
	for(i=0; i< pipes.size; i++)
		pipes[i] show();
	
	trigs = getentarray("escape_pipe_hide","targetname");
	pipes = getentarray("pipe_shootable", "targetname");
	
	test = spawn("script_origin", (0,0,0) );
	for(i=0; i<trigs.size; i++)
	{
		del = [];
		for(j=0; j<pipes.size; j++)
		{
			test.origin = pipes[ j ].origin;
			if(trigs[ i ] istouching( test ) )
			{
				del[ del.size ] = pipes[ j ]; 
				pipes[ j ] = undefined;
			}
		}	
		for(d = 0; d< del.size; d++)
			del[ d ] delete();
		pipes = array_removeUndefined( pipes );
	}
	test delete();
	
	containers = getentarray("escape_container", "targetname");
	for(i=0; i<containers.size; i++)
	{
		target = getent(containers[ i ].target, "targetname");
		target show();	
		containers[ i ] delete();
	}
	
	siren = [];
	siren[ siren.size ] = spawn( "script_origin", ( 520, 596, -90 ) );
	siren[ siren.size ] = spawn( "script_origin", ( -1376, 596, -90 ) );
	siren[ siren.size ] = spawn( "script_origin", ( -2640, 32, -80 ) );
	
	for(i=0; i<siren.size; i++ ) 
		siren[ i ] playloopsound( "emt_alarm_ship_sinking" ); 
	
	flag_wait("escape_hallway_lower_enter");
	
	wait 1;
	
	allcargoholdfx	= getfxarraybyID( "cargo_vl_white" );
	allcargoholdfx 	= array_combine(allcargoholdfx, getfxarraybyID( "cargo_vl_white_soft" ));
	allcargoholdfx 	= array_combine(allcargoholdfx, getfxarraybyID( "cargo_vl_white_eql" ));
	allcargoholdfx 	= array_combine(allcargoholdfx, getfxarraybyID( "cargo_vl_white_eql_flare" ));
	allcargoholdfx 	= array_combine(allcargoholdfx, getfxarraybyID( "cargo_vl_white_sml" ));
	allcargoholdfx 	= array_combine(allcargoholdfx, getfxarraybyID( "cargo_vl_white_sml_a" ));
	
	escapefx = getfxarraybyID( "escape_water_drip_stairs" );
	escapefx = array_combine(escapefx, getfxarraybyID( "escape_water_gush_stairs" ) );
	
	array_thread(allcargoholdfx, ::pauseEffect);
	array_thread(escapefx, ::restartEffect);
	
	//throw a whole bunch of shit down the stairs
	flag_wait("escape_hallway_lower_flag");
	origin = (-2804, -32, 96);
	range = 8;
	delayThread(.25, ::escape_fx_setup_throw_obj, "com_soup_can", origin, range );
	delayThread(.5, ::escape_fx_setup_throw_obj, "com_pipe_coupling_metal", origin, range );
	delayThread(.75, ::escape_fx_setup_throw_obj, "com_pipe_4_coupling_ceramic", origin, range );
	delayThread(1, ::escape_fx_setup_throw_obj, "com_milk_carton", origin, range );	
	delayThread(1.25, ::escape_fx_setup_throw_obj, "com_soup_can", origin, range );
	delayThread(1.5, ::escape_fx_setup_throw_obj, "com_milk_carton", origin, range );
	delayThread(1.75, ::escape_fx_setup_throw_obj, "com_soup_can", origin, range );
	delayThread(2, ::escape_fx_setup_throw_obj, "com_milk_carton", origin, range );
	
	//throw a whole bunch of shit down the hallway
	flag_wait("escape_topofstairs");
	
	origin = (-2420, 176, 110);
	range = 8;
	thread escape_fx_setup_throw_obj( "com_fire_extinguisher", origin, range );
	thread escape_fx_setup_throw_obj( "com_pipe_4_coupling_ceramic", origin, range );
	thread escape_fx_setup_throw_obj( "me_plastic_crate9", origin, range );
	
	delayThread(.25, ::escape_fx_setup_throw_obj, "com_pot_metal", origin, range );
	delayThread(.25, ::escape_fx_setup_throw_obj, "com_milk_carton", origin, range );
	delayThread(.25, ::escape_fx_setup_throw_obj, "me_plastic_crate6", origin, range );
	
	delayThread(.4, ::escape_fx_setup_throw_obj, "me_plastic_crate9", origin, range );
	delayThread(.4, ::escape_fx_setup_throw_obj, "com_pan_copper", origin, range );
	delayThread(.4, ::escape_fx_setup_throw_obj, "me_plastic_crate10", origin, range );
	
	delayThread(.5, ::escape_fx_setup_throw_obj, "me_ac_window", origin, range, 5500 );
	
	delayThread(.75, ::escape_fx_setup_throw_obj, "com_fire_extinguisher", origin, range );
	delayThread(.75, ::escape_fx_setup_throw_obj, "com_propane_tank", origin, range );
	delayThread(.75, ::escape_fx_setup_throw_obj, "me_plastic_crate1", origin, range );
	
	delayThread(1.25, ::escape_fx_setup_throw_obj, "com_pail_metal1", origin, range );
	delayThread(1.25, ::escape_fx_setup_throw_obj, "com_propane_tank", origin, range );
	delayThread(1.5, ::escape_fx_setup_throw_obj, "com_plastic_bucket", origin, range );
	
	/*
	me_ac_window
	com_fire_extinguisher
	com_pipe_4_coupling_ceramic
	com_pipe_coupling_metal
	me_plastic_crate3
	me_plastic_crate10
	me_plastic_crate1
	me_plastic_crate4
	me_plastic_crate9
	com_pot_metal
	com_soup_can
	com_milk_carton
	me_plastic_crate6
	com_pail_metal1
	com_pan_copper
	com_propane_tank
	com_plastic_bucket
	*/
	
	flag_wait("escape_hallway_upper_flag");
	
	bottomfx 	= getfxarraybyID( "escape_water_gush_stairs" );
	bottomfx 	= array_combine(bottomfx, getfxarraybyID( "escape_water_drip_stairs" ));
	bottomfx 	= array_combine(bottomfx, getfxarraybyID( "escape_caustics" ));
	
	topsidefx	= getfxarraybyID( "cgoshp_drips_a" );
	topsidefx 	= array_combine(topsidefx, getfxarraybyID( "cgoshp_drips" ));
	
	array_thread(bottomfx, ::pauseEffect);
	array_thread(topsidefx, ::pauseEffect);
	
	//lighting thunder and waves
	delayThread(1, maps\_weather::lightningFlash, maps\cargoship_fx::normal, maps\cargoship_fx::flash );
	delayThread(2, maps\_weather::lightningFlash, maps\cargoship_fx::normal, maps\cargoship_fx::flash );
	
	delayThread(1, ::play_sound_in_space, "elm_wave_crash_ext", (-2304, -864, -128) );
	delayThread(1, ::exploder, 126 );
	
	flag_wait("escape_aftdeck_flag");
	
	bottomfx = getfxarraybyID( "escape_waternoise_ud" );
	bottomfx 	= array_combine(bottomfx, getfxarraybyID( "escape_waternoise" ));

	array_thread(bottomfx, ::pauseEffect);
	
	delayThread(.1, maps\_weather::lightningFlash, maps\cargoship_fx::normal, maps\cargoship_fx::flash );
	delayThread(2, maps\_weather::lightningFlash, maps\cargoship_fx::normal, maps\cargoship_fx::flash );
	delayThread(5, maps\_weather::lightningFlash, maps\cargoship_fx::normal, maps\cargoship_fx::flash );
	delayThread(7, maps\_weather::lightningFlash, maps\cargoship_fx::normal, maps\cargoship_fx::flash );
	delayThread(9, maps\_weather::lightningFlash, maps\cargoship_fx::normal, maps\cargoship_fx::flash );
	
	delayThread(.5, ::play_sound_in_space, "elm_wave_crash_ext", (-2304, -864, -128) );
	delayThread(.5, ::exploder, 126 );
	
	delayThread(1.25, ::play_sound_in_space, "elm_wave_crash_ext", (-2848, -800, -64) );
	delayThread(1.25, ::exploder, 300 );
	
	delayThread(4, ::play_sound_in_space, "elm_wave_crash_ext", (-3808, -368, -64) );
	delayThread(4, ::exploder, 302 );
	
//	delayThread(6, ::play_sound_in_space, "elm_wave_crash_ext", (-3808, 336, -64) );
//	delayThread(6, ::exploder, 303 );
}

escape_fx_setup_throw_obj(name, origin, range, force)
{
	offset = ( randomfloatrange(-32, 32), randomfloatrange(-32, 32), randomfloatrange(-32, 32) );
	model = spawn("script_model", origin + offset );
	model setmodel( name );
	
	offset = ( randomfloatrange(-10, 10), randomfloatrange(-10, 10), randomfloatrange(-10, 10) );
	vec = anglestoright( (0,180,0) );
	if( !isdefined(force) )
		force = randomintrange(500, 1000);
	vec = vector_multiply(vec, force );
	
	model physicslaunch( (model.origin + offset), vec );
}

escape_explosion()
{
	
	trig = getent("escape_sink_start", "targetname");
	trig waittill("trigger");
	
	flag_clear("_sea_bob");
	flag_set("start_sinking_boat");
	level._sea_org notify("manual_override");

	level notify("sinking the ship");

	level notify ( "cargoship_escape_music" );
	musicstop( 0.1 );
    wait .2;
	MusicPlayWrapper("cargoship_end_music");
	thread flag_set_delayed( "cargoship_end_music", 93 );
	flag_set("escape_explosion");

	thread escape_explosion_drops();
	earthquake(0.3, .5, level.player.origin, 256);
	
	exp = spawn("script_model", (8, -360, -216));
	exp.angles = (0,90,0);
	exp setmodel("tag_origin");
	exp playsound( "cgo_helicopter_hit" );
	
	playfxontag(level._effect["sinking_explosion"], exp, "tag_origin");
	set_vision_set( "cargoship_blast", .25 );
	
	setsaveddvar( "compass", 0 );		
	SetSavedDvar( "ammoCounterHide", "1" );		
	SetSavedDvar( "hud_showStance", 0 );
		
	wait .2;
	level.player allowsprint( false );
	thread player_speed_set( 185, .5);
	thread escape_shellshock();
	
	wait .3;
		
	exp.origin = (100, -600, -70);	
	exp.angles = (0,-90,0);
	playfxontag(level._effect["sinking_leak_large"], exp, "tag_origin");
	exp _playloopsound( "cgo_water_breach_large_loop" );

	wait 15;
	level.player thread escape_quake();
	//flag_set("start_sinking_boat");
	set_vision_set( "cargoship_indoor2", 6 );
	if( level.gameSkill < 2 ) // easy and regular
		setsaveddvar( "compass", 1 );
	SetSavedDvar( "hud_showStance", 1 );
		
	stairs = spawn( "script_origin", (-2808, -199, 0) );
	stairs playloopsound( "cgo_water_stairs_large_loop" );
	
	/*wait 2;
		
	exp2 = spawn("script_model", (350, -500, -150));
	exp2.angles = (0,-90,0);
	exp2 setmodel("tag_origin");
	exp2 playloopsound( "water_pipe_large_loop" );
	
	playfxontag(level._effect["event_waterleak"], exp2, "tag_origin");
		*/
	flag_wait("escape_hallway_lower_enter");
	
	exp stoploopsound();
	waittillframeend;
	exp delete();
	//exp2 delete();
}


escape_heroes_runanim_setup()
{
	level.current_run = [];
	level.current_run[ "escape_cargohold2" ]		= [];
	level.current_run[ "escape_cargohold2b" ] 		= [];
	level.current_run[ "escape_cargohold1" ]	 	= [];
	level.current_run[ "escape_hallway_lower" ]		= [];
	level.current_run[ "escape_hallway_lowerb" ] 	= [];
	level.current_run[ "escape_hallway_lowerc" ]	= [];
	level.current_run[ "escape_hallway_lowerd" ] 	= [];
	level.current_run[ "escape_hallway_lowere" ]	= [];
	level.current_run[ "escape_hallway_upper" ]		= [];
	level.current_run[ "escape_hallway_upperb" ]	= [];
	level.current_run[ "escape_aftdeck" ]			= [];
	level.current_run[ "escape_aftdeckb" ]			= [];
	
	level.current_run[ "escape_cargohold2" ]["run"]			= "lean_none";
	level.current_run[ "escape_cargohold2b" ]["run"] 		= "lean_right";
	level.current_run[ "escape_cargohold1" ]["run"]	 		= "lean_right";
	level.current_run[ "escape_hallway_lower" ]["run"] 		= "lean_back";
	level.current_run[ "escape_hallway_lowerb" ]["run"] 	= "lean_right";
	level.current_run[ "escape_hallway_lowerc" ]["run"] 	= "lean_none";
	level.current_run[ "escape_hallway_lowerd" ]["run"] 	= "lean_left";
	level.current_run[ "escape_hallway_lowere" ]["run"] 	= "lean_forward";
	level.current_run[ "escape_hallway_upper" ]["run"] 		= "lean_left";
	level.current_run[ "escape_hallway_upperb" ]["run"] 	= "lean_back";
	level.current_run[ "escape_aftdeck" ]["run"] 			= "lean_right";
	level.current_run[ "escape_aftdeckb" ]["run"] 			= "lean_forward";
	
	level.current_run[ "escape_cargohold2" ]["sprint"]		= "lean_none";
	level.current_run[ "escape_cargohold2b" ]["sprint"] 	= "lean_right";
	level.current_run[ "escape_cargohold1" ]["sprint"]	 	= "lean_right";
	level.current_run[ "escape_hallway_lower" ]["sprint"] 	= "lean_back";
	level.current_run[ "escape_hallway_lowerb" ]["sprint"] 	= "lean_right";
	level.current_run[ "escape_hallway_lowerc" ]["sprint"] 	= "lean_none";
	level.current_run[ "escape_hallway_lowerd" ]["sprint"] 	= "lean_left";
	level.current_run[ "escape_hallway_lowere" ]["sprint"] 	= "lean_forward";
	level.current_run[ "escape_hallway_upper" ]["sprint"] 	= "lean_left";
	level.current_run[ "escape_hallway_upperb" ]["sprint"] 	= "lean_back";
	level.current_run[ "escape_aftdeck" ]["sprint"] 		= "lean_right";
	level.current_run[ "escape_aftdeckb" ]["sprint"] 		= "lean_forward";
	
	level.current_run[ "escape_cargohold2" ]["jog"]			= "lean_none_jog";
	level.current_run[ "escape_cargohold2b" ]["jog"] 		= "lean_right_jog";
	level.current_run[ "escape_cargohold1" ]["jog"]	 		= "lean_right_jog";
	level.current_run[ "escape_hallway_lower" ]["jog"] 		= "lean_back_jog";
	level.current_run[ "escape_hallway_lowerb" ]["jog"] 	= "lean_right_jog";
	level.current_run[ "escape_hallway_lowerc" ]["jog"] 	= "lean_none_jog";
	level.current_run[ "escape_hallway_lowerd" ]["jog"] 	= "lean_left_jog";
	level.current_run[ "escape_hallway_lowere" ]["jog"] 	= "lean_forward_jog";
	level.current_run[ "escape_hallway_upper" ]["jog"] 		= "lean_left_jog";
	level.current_run[ "escape_hallway_upperb" ]["jog"] 	= "lean_back_jog";
	level.current_run[ "escape_aftdeck" ]["jog"] 			= "lean_right_jog";
	level.current_run[ "escape_aftdeckb" ]["jog"] 			= "lean_forward_jog";
}

escape_hallways_lower_flood()
{
	flag_wait("escape_hallway_lower_enter");
	
	flag_wait_or_timeout("escape_hallway_lower_flood_save", level.escape_timer["escape_hallway_lower_flood_save"] + level.timer_grace_period);
	if (flag("escape_hallway_lower_flood_save"))
		flag_wait_or_timeout("escape_hallway_lower_flood", 3);
	
	if( flag( "escape_hallway_lower_flood" ) )
		wait .5;
		
	exp = spawn("script_model", (-3000, -400, -50));
	exp.angles = (0,-90,0);
	exp setmodel("tag_origin");
	exp hide();
	exp playsound( "cgo_helicopter_hit" );

	playfxontag(level._effect["sinking_leak_large"], exp, "tag_origin");
	exp _playloopsound( "cgo_water_breach_large_loop" );
	
	wait 1;
	if( !flag( "escape_hallway_lower_flood" ) )
		thread escape_mission_failed();
			
	flag_wait("escape_hallway_upper_flag");
	wait 1;
//	exp stoploopsound();
//	waittillframeend;
//	exp delete();
}

_playloopsound( alias )
{
	self thread _playloopsound_proc( alias );
}

_playloopsound_proc( alias )
{
	wait .5;
	if( !isdefined( self ) )
		return;
	
	ent = spawn( "script_origin", self.origin );	
	ent playloopsound( alias );
	
	self waittill( "death" );
	ent stoploopsound();
	waittillframeend;
	ent delete();
}

escape_cargohold_flood()
{
	flag_wait("escape_get_to_catwalks");
	
	flag_wait_or_timeout("escape_cargohold1_enter", level.escape_timer["escape_cargohold1_enter"] + level.timer_grace_period);
	if (flag("escape_cargohold1_enter"))
		wait 1.25;
	
	exp = spawn("script_model", (-536, 580, -160));
	exp.angles = (10,90,0);
	exp setmodel("tag_origin");
	exp hide();
	exp playsound( "cgo_helicopter_hit" );

	playfxontag(level._effect["sinking_leak_large"], exp, "tag_origin");
	exp _playloopsound( "cgo_water_breach_large_loop" );
	flag_wait("escape_hallway_lower_enter");
	wait 1;
	
	exp stoploopsound();
	waittillframeend;
	exp delete();
}

escape_invisible_timer()
{
	level.timer_grace_period = undefined;
	
	switch(level.gameSkill)
	{
		case 0://easy
			level.timer_grace_period = 6;
			break;	
		case 1://regular
			level.timer_grace_period = 2.5;
			break;	
		case 2://hardened
			level.timer_grace_period = 1.25;
			break;	
		case 3://veteran
			level.timer_grace_period = .5;
			break;	
	}
	
	thread escape_handle_wrongway();
	
	//level.timer_grace_period = 0;
	
	level.escape_timer = [];
	level.escape_timer["escape_cargohold1_enter"] 	= 18;
	level.escape_timer["escape_catwalk_madeit"] 	= 12;
	level.escape_timer["escape_hallway_lower_flood_save"] = 14;
	level.escape_timer["escape_aftdeck_flag"] 		= 9;
	level.escape_timer["end_no_jump"] 	= 12.5;
	
	flag_wait("escape_get_to_catwalks");
	escape_timer_section("escape_cargohold1_enter");
	
	thread flag_set_delayed("escape_death_cargohold1", (level.escape_timer["escape_catwalk_madeit"]  - 2.5 + level.timer_grace_period) );
	escape_timer_section("escape_catwalk_madeit");

	escape_timer_section("escape_hallway_lower_flood_save");
	
	escape_timer_section("escape_aftdeck_flag");

	escape_timer_section("end_no_jump");
}

escape_timer_section( flag )
{
	if( flag( flag ) )
		return;//need to check this cause autosaving fucks this up
	level endon( flag );
	
	level endon("mission_failed");
		
	wait (level.escape_timer[ flag ] + level.timer_grace_period);	
	
	if( !flag( flag ) )
		thread escape_mission_failed();
}

escape_autosaves()
{
	level endon("mission_failed");
	
	seaknight_flag = undefined;
	
	trigs = getentarray("escape_flags", "script_noteworthy");
	for(i=0; i<trigs.size; i++)
	{
		if( !isdefined( trigs[i].script_flag ) )
			continue;
		if( trigs[i].script_flag == "escape_seaknight_flag" )
		{
			seaknight_flag = trigs[i];
			break;
		}		
	}
	
	flag_wait( "escape_get_to_catwalks" );
	wait .5;
	delaythread( 2.0, ::autosave_now, "escape1" );	
	seaknight_flag trigger_off();
	
	flag_wait( "escape_cargohold1_enter" );
	autosave_now("escape2");
	
	flag_wait( "escape_catwalk_madeit" );
	wait .5;
	autosave_now("escape3");
	
	flag_wait( "escape_hallway_lower_flood_save" );
	wait .1;
	autosave_now("escape4");
	
	flag_wait( "escape_aftdeck_flag" );
	autosave_now("escape5");
	
	seaknight_flag trigger_on();
	
//	flag_wait( "escape_seaknight_flag" );
//	autosave_now("escape5");
	
	flag_wait( "player_rescued" );
	autosave_now("rescued");
}

escape_mission_failed()
{
	if( flag( "end_start_player_anim" ) )
		return;
	level notify("mission_failed");
	setDvar("ui_deadquote", level.missionFailedQuote["escape"] );
	maps\_utility::missionFailedWrapper();	
}

end_handle_player_fall()
{
	flag_wait( "escape_aftdeck_flag" );
	clip = getent( "end_player_clip", "targetname" );
	clip delete();
	
	level endon( "end_start_player_anim" );
	
	trig = getent( "end_player_fall", "targetname" );
	trig waittill( "trigger" );
	
	if (getdvar("cargoship_jump") == "")
		setdvar("cargoship_jump", "1");
	
	switch( int( getdvar( "cargoship_jump" ) ) )
	{
		case 1:
			level.missionFailedQuote["escape"] = level.missionFailedQuote["jump1"];
			setdvar("cargoship_jump", "2");
			break;
	/*	case 2:
			level.missionFailedQuote["escape"] = level.missionFailedQuote["jump2"];
			setdvar("cargoship_jump", "3");
			break;
		case 3:	
			level.missionFailedQuote["escape"] = level.missionFailedQuote["jump3"];
			setdvar("cargoship_jump", "4");
			break;*/
		default:
			level.missionFailedQuote["escape"] = level.missionFailedQuote["jump"];
			break;
	}
	
	escape_mission_failed();
}

escape_handle_wrongway()
{
	flag_wait("escape_explosion");
	
	thread escape_handle_wrongway_kill();
	trig = getent( "end_wrongway", "targetname" );

	while( 1 )
	{
		trig waittill( "trigger" );
		
		level.missionFailedQuote["escape"] = level.missionFailedQuote["wrongway"];
		
		while( level.player istouching( trig ) )
			wait .1;
		
		level.missionFailedQuote["escape"] = level.missionFailedQuote["slow"];	
	}	
}

escape_handle_wrongway_kill()
{
	trig = getent( "end_wrongway_kill", "targetname" );
	trig waittill( "trigger" );
	level.missionFailedQuote["escape"] = level.missionFailedQuote["wrongway"];
	escape_mission_failed();		
}

water_stuff_for_art1( static )
{	
	black = "cargoship_water_black";
	reg = "cargoship_water";
	bhide = false;
	
	if( isdefined( static ) )
	{
		black = "cargoship_water_black_static";
		reg = "cargoship_water_static";
		bhide = true;
	}
	
	model = getent("sea_black","targetname");
	origin = model getorigin();
	model delete();
	model = spawn("script_model", origin);
	model setmodel( black );
	model.targetname = "sea_black";
	
	if( bhide )
		level.sea_black = model;
	
	model = getent("sea_foam","targetname");
	model delete();
	model = spawn("script_model", origin);
	model setmodel( reg );
	model.targetname = "sea_foam";
	
	if( bhide )
		level.sea_foam = model;
	
	if( bhide )
	{	
		level.sea_black hide();
		level.sea_black.angles = level._sea_link.angles;
		level.sea_black linkto(level._sea_link);
		
		level.sea_foam hide();
		level.sea_foam.angles = level._sea_link.angles;
		level.sea_foam linkto(level._sea_link);
	}
}

water_stuff_for_art2( time )
{
	wait time;
	level.sea_foam thread maps\_sea::sea_animate();
	level.sea_black thread maps\_sea::sea_animate();	
}

centerLineThread( string, size, interval )
{
	level notify("new_introscreen_element");
	
	if( !isdefined( level.intro_offset ) )
		level.intro_offset = 0;
	else
		level.intro_offset++;
		
	y = maps\_introscreen::_CornerLineThread_height();
	
	hudelem = newHudElem();
	hudelem.x = 0;
	hudelem.y = 0;
	hudelem.alignX = "center";
	hudelem.alignY = "middle";
	hudelem.horzAlign= "center";
	hudelem.vertAlign = "middle";
	hudelem.sort = 1; // force to draw after the background
	hudelem.foreground = true;
	hudelem setText( string );
	hudelem.alpha = 0;
	hudelem fadeOverTime( 0.2 ); 
	hudelem.alpha = 1;

	hudelem.hidewheninmenu = true;
	hudelem.fontScale = 1.6;
	hudelem.color = (0.8, 1.0, 0.8);
	hudelem.font = "objective";
	hudelem.glowColor = (0.3, 0.6, 0.3);
	hudelem.glowAlpha = 1;
	duration = int((size * interval * 1000) + 3000);
	hudelem SetPulseFX( 30, duration, 700 );//something, decay start, decay duration

	thread maps\_introscreen::hudelem_destroy( hudelem );
}

cargoship_hack_animreach( guy, anime, idle, ender, _flag )
{
	self anim_reach_and_idle_solo( guy, anime, idle, ender );
	flag_set( _flag );
}

cargoship_breach2_setup( guy, approach, idle, ender, _flag )
{
	self anim_generic_reach( guy, approach );
	self anim_generic( guy, approach );
	self thread anim_generic_loop( guy, idle, undefined, ender );
	flag_set( _flag );
}

carogship_shotgunpulla( guy )
{
	putGunOnTag = "none";
	guy animscripts\shared::placeWeaponOn( guy.weapon, putGunOnTag );
}

carogship_shotgunpullb( guy )
{
	guy.lastweapon = guy.weapon;
	
	guy animscripts\shared::placeWeaponOn( guy.secondaryweapon, "right" );
	
	// reset ammo (assume fully loaded weapon)
	guy.bulletsInClip = weaponClipSize( guy.weapon );
}

player_noprone()
{	
	while( 1 )
	{
		self waittill( "trigger" );
		
		level.player allowprone( false );
		
		while( level.player istouching( self ) )
			wait .2;	
		
		level.player allowprone( true );
	}
}

nadehint()
{
	level.player endon( "kill_nade_hint" );
	level.player endon( "death" );

	level.player notifyOnCommand( "kill_nade_hint", "+frag" );
	
	flag_wait( "nade_hint" );
	thread keyHint( "frag", 8 );
}

crouchhint()
{
	level.player endon( "kill_crouch_hint" );
	level.player endon( "death" );

	level.player notifyOnCommand( "kill_crouch_hint", "+stance" );
	level.player notifyOnCommand( "kill_crouch_hint", "gocrouch" );
	level.player notifyOnCommand( "kill_crouch_hint", "togglecrouch" );
	
	flag_wait( "crouch_hint" );
	
	thread keyHint( "crouch", 8 );
}

standhint()
{
	level.player endon( "kill_stand_hint" );
	level.player endon( "death" );
	
	flag_wait( "crouch_hint" );
	
	delaythread( 2, ::standhint_kill );
		
	flag_wait( "stand_hint" );
	
	while( level.player getstance() == "stand" )
		return;
	thread keyHint( "stand", 8 );
}

standhint_kill()
{
	level endon( "stand_hint" );
	
	while( level.player getstance() != "crouch" )
		wait .05;
	while( level.player getstance() != "stand" )
		wait .05;
		
	level.player notify( "kill_stand_hint" );
}

hint_setup()
{
	maps\_utility::set_console_status();	
	if ( level.console )
		level.hint_text_size = 1.6;
	else
		level.hint_text_size = 1.2;
		
	level.actionBinds = [];
	
	registerActionBinding( "frag",	"+frag",	&"CARGOSHIP_HINT_FRAG" );
	registerActionBinding( "crouch",			"+stance",				&"CARGOSHIP_HINT_CROUCH_STANCE" );
	registerActionBinding( "crouch",			"gocrouch",				&"CARGOSHIP_HINT_CROUCH" );
	registerActionBinding( "crouch",			"togglecrouch",			&"CARGOSHIP_HINT_CROUCH_TOGGLE" );
	registerActionBinding( "stand",				"+gostand",				&"CARGOSHIP_HINT_STAND" );
	registerActionBinding( "stand",				"+stance",				&"CARGOSHIP_HINT_STAND_STANCE" );
	
	initKeys();
	updateKeysForBindings();
	thread nadehint();
	thread crouchhint();
	thread standhint();
}

//from killhouse
keyHint( actionName, timeOut )
{
	if ( getdvar( "chaplincheat" ) == "1" )
		return;

	clear_hints();
	level endon ( "clearing_hints" );

	add_hint_background();
	level.hintElem = createFontString( "default", level.hint_text_size );
	level.hintElem.hidewheninmenu = true;
	level.hintElem setPoint( "TOP", undefined, 0, 130 );

	actionBind = getActionBind( actionName );
	level.hintElem setText( actionBind.hint );
	//level.hintElem endon ( "death" );

	notifyName = "did_action_" + actionName;
	for ( index = 0; index < level.actionBinds[actionName].size; index++ )
	{
		actionBind = level.actionBinds[actionName][index];
		level.player notifyOnCommand( notifyName, actionBind.binding );
	}

	if ( isDefined( timeOut ) )
		level.player thread notifyOnTimeout( notifyName, timeOut );
	level.player waittill( notifyName );

	level.hintElem fadeOverTime( 0.5 );
	level.hintElem.alpha = 0;

	wait ( 0.5 );
	
	clear_hints();
}

clear_hints()
{
	if ( isDefined( level.hintElem ) )
		level.hintElem destroyElem();
	if ( isDefined( level.iconElem ) )
		level.iconElem destroyElem();
	if ( isDefined( level.iconElem2 ) )
		level.iconElem2 destroyElem();
	if ( isDefined( level.iconElem3 ) )
		level.iconElem3 destroyElem();
	if ( isDefined( level.hintbackground ) )
		level.hintbackground destroyElem();
	level notify ( "clearing_hints" );
}

add_hint_background( double_line )
{
	if ( isdefined ( double_line ) )
		level.hintbackground = createIcon( "popmenu_bg", 650, 50 );
	else
		level.hintbackground = createIcon( "popmenu_bg", 650, 30 );
	level.hintbackground.hidewheninmenu = true;
	level.hintbackground setPoint( "TOP", undefined, 0, 125 );
	level.hintbackground.alpha = .5;
}

getActionBind( action )
{
    for ( index = 0; index < level.actionBinds[action].size; index++ )
    {
        actionBind = level.actionBinds[action][index];

        binding = getKeyBinding( actionBind.binding );
        if ( !binding["count"] )
            continue;

        return level.actionBinds[action][index];
    }

    return level.actionBinds[action][0];//unbound
}

notifyOnTimeout( finishedNotify, timeOut )
{
	self endon( finishedNotify );
	wait timeOut;
	self notify( finishedNotify );
}

registerActionBinding( action, binding, hint )
{
	if ( !isDefined( level.actionBinds[action] ) )
		level.actionBinds[action] = [];

	actionBind = spawnStruct();
	actionBind.binding = binding;
	actionBind.hint = hint;

	actionBind.keyText = undefined;
	actionBind.hintText = undefined;

	precacheString( hint );

	level.actionBinds[action][level.actionBinds[action].size] = actionBind;
}

initKeys()
{
	level.kbKeys = "1234567890-=qwertyuiop[]asdfghjkl;'zxcvbnm,./";

	level.specialKeys = [];

	level.specialKeys[level.specialKeys.size] = "TAB";
	level.specialKeys[level.specialKeys.size] = "ENTER";
	level.specialKeys[level.specialKeys.size] = "ESCAPE";
	level.specialKeys[level.specialKeys.size] = "SPACE";
	level.specialKeys[level.specialKeys.size] = "BACKSPACE";
	level.specialKeys[level.specialKeys.size] = "UPARROW";
	level.specialKeys[level.specialKeys.size] = "DOWNARROW";
	level.specialKeys[level.specialKeys.size] = "LEFTARROW";
	level.specialKeys[level.specialKeys.size] = "RIGHTARROW";
	level.specialKeys[level.specialKeys.size] = "ALT";
	level.specialKeys[level.specialKeys.size] = "CTRL";
	level.specialKeys[level.specialKeys.size] = "SHIFT";
	level.specialKeys[level.specialKeys.size] = "CAPSLOCK";
	level.specialKeys[level.specialKeys.size] = "F1";
	level.specialKeys[level.specialKeys.size] = "F2";
	level.specialKeys[level.specialKeys.size] = "F3";
	level.specialKeys[level.specialKeys.size] = "F4";
	level.specialKeys[level.specialKeys.size] = "F5";
	level.specialKeys[level.specialKeys.size] = "F6";
	level.specialKeys[level.specialKeys.size] = "F7";
	level.specialKeys[level.specialKeys.size] = "F8";
	level.specialKeys[level.specialKeys.size] = "F9";
	level.specialKeys[level.specialKeys.size] = "F10";
	level.specialKeys[level.specialKeys.size] = "F11";
	level.specialKeys[level.specialKeys.size] = "F12";
	level.specialKeys[level.specialKeys.size] = "INS";
	level.specialKeys[level.specialKeys.size] = "DEL";
	level.specialKeys[level.specialKeys.size] = "PGDN";
	level.specialKeys[level.specialKeys.size] = "PGUP";
	level.specialKeys[level.specialKeys.size] = "HOME";
	level.specialKeys[level.specialKeys.size] = "END";
	level.specialKeys[level.specialKeys.size] = "MOUSE1";
	level.specialKeys[level.specialKeys.size] = "MOUSE2";
	level.specialKeys[level.specialKeys.size] = "MOUSE3";
	level.specialKeys[level.specialKeys.size] = "MOUSE4";
	level.specialKeys[level.specialKeys.size] = "MOUSE5";
	level.specialKeys[level.specialKeys.size] = "MWHEELUP";
	level.specialKeys[level.specialKeys.size] = "MWHEELDOWN";
	level.specialKeys[level.specialKeys.size] = "AUX1";
	level.specialKeys[level.specialKeys.size] = "AUX2";
	level.specialKeys[level.specialKeys.size] = "AUX3";
	level.specialKeys[level.specialKeys.size] = "AUX4";
	level.specialKeys[level.specialKeys.size] = "AUX5";
	level.specialKeys[level.specialKeys.size] = "AUX6";
	level.specialKeys[level.specialKeys.size] = "AUX7";
	level.specialKeys[level.specialKeys.size] = "AUX8";
	level.specialKeys[level.specialKeys.size] = "AUX9";
	level.specialKeys[level.specialKeys.size] = "AUX10";
	level.specialKeys[level.specialKeys.size] = "AUX11";
	level.specialKeys[level.specialKeys.size] = "AUX12";
	level.specialKeys[level.specialKeys.size] = "AUX13";
	level.specialKeys[level.specialKeys.size] = "AUX14";
	level.specialKeys[level.specialKeys.size] = "AUX15";
	level.specialKeys[level.specialKeys.size] = "AUX16";
	level.specialKeys[level.specialKeys.size] = "KP_HOME";
	level.specialKeys[level.specialKeys.size] = "KP_UPARROW";
	level.specialKeys[level.specialKeys.size] = "KP_PGUP";
	level.specialKeys[level.specialKeys.size] = "KP_LEFTARROW";
	level.specialKeys[level.specialKeys.size] = "KP_5";
	level.specialKeys[level.specialKeys.size] = "KP_RIGHTARROW";
	level.specialKeys[level.specialKeys.size] = "KP_END";
	level.specialKeys[level.specialKeys.size] = "KP_DOWNARROW";
	level.specialKeys[level.specialKeys.size] = "KP_PGDN";
	level.specialKeys[level.specialKeys.size] = "KP_ENTER";
	level.specialKeys[level.specialKeys.size] = "KP_INS";
	level.specialKeys[level.specialKeys.size] = "KP_DEL";
	level.specialKeys[level.specialKeys.size] = "KP_SLASH";
	level.specialKeys[level.specialKeys.size] = "KP_MINUS";
	level.specialKeys[level.specialKeys.size] = "KP_PLUS";
	level.specialKeys[level.specialKeys.size] = "KP_NUMLOCK";
	level.specialKeys[level.specialKeys.size] = "KP_STAR";
	level.specialKeys[level.specialKeys.size] = "KP_EQUALS";
	level.specialKeys[level.specialKeys.size] = "PAUSE";
	level.specialKeys[level.specialKeys.size] = "SEMICOLON";
	level.specialKeys[level.specialKeys.size] = "COMMAND";
	level.specialKeys[level.specialKeys.size] = "181";
	level.specialKeys[level.specialKeys.size] = "191";
	level.specialKeys[level.specialKeys.size] = "223";
	level.specialKeys[level.specialKeys.size] = "224";
	level.specialKeys[level.specialKeys.size] = "225";
	level.specialKeys[level.specialKeys.size] = "228";
	level.specialKeys[level.specialKeys.size] = "229";
	level.specialKeys[level.specialKeys.size] = "230";
	level.specialKeys[level.specialKeys.size] = "231";
	level.specialKeys[level.specialKeys.size] = "232";
	level.specialKeys[level.specialKeys.size] = "233";
	level.specialKeys[level.specialKeys.size] = "236";
	level.specialKeys[level.specialKeys.size] = "241";
	level.specialKeys[level.specialKeys.size] = "242";
	level.specialKeys[level.specialKeys.size] = "243";
	level.specialKeys[level.specialKeys.size] = "246";
	level.specialKeys[level.specialKeys.size] = "248";
	level.specialKeys[level.specialKeys.size] = "249";
	level.specialKeys[level.specialKeys.size] = "250";
	level.specialKeys[level.specialKeys.size] = "252";
}

updateKeysForBindings()
{
	if ( level.console )
	{
		setKeyForBinding( getCommandFromKey( "BUTTON_START" ), "BUTTON_START" );
		setKeyForBinding( getCommandFromKey( "BUTTON_A" ), "BUTTON_A" );
		setKeyForBinding( getCommandFromKey( "BUTTON_B" ), "BUTTON_B" );
		setKeyForBinding( getCommandFromKey( "BUTTON_X" ), "BUTTON_X" );
		setKeyForBinding( getCommandFromKey( "BUTTON_Y" ), "BUTTON_Y" );
		setKeyForBinding( getCommandFromKey( "BUTTON_LSTICK" ), "BUTTON_LSTICK" );
		setKeyForBinding( getCommandFromKey( "BUTTON_RSTICK" ), "BUTTON_RSTICK" );
		setKeyForBinding( getCommandFromKey( "BUTTON_LSHLDR" ), "BUTTON_LSHLDR" );
		setKeyForBinding( getCommandFromKey( "BUTTON_RSHLDR" ), "BUTTON_RSHLDR" );
		setKeyForBinding( getCommandFromKey( "BUTTON_LTRIG" ), "BUTTON_LTRIG" );
		setKeyForBinding( getCommandFromKey( "BUTTON_RTRIG" ), "BUTTON_RTRIG" );
	}
	else
	{
		//level.kbKeys = "1234567890-=QWERTYUIOP[]ASDFGHJKL;'ZXCVBNM,./";
		//level.specialKeys = [];

		for ( index = 0; index < level.kbKeys.size; index++ )
		{
			setKeyForBinding( getCommandFromKey( level.kbKeys[index] ), level.kbKeys[index] );
		}

		for ( index = 0; index < level.specialKeys.size; index++ )
		{
			setKeyForBinding( getCommandFromKey( level.specialKeys[index] ), level.specialKeys[index] );
		}

	}
}

setKeyForBinding( binding, key )
{
	if ( binding == "" )
		return;

	arrayKeys = getArrayKeys( level.actionBinds );
	for ( index = 0; index < arrayKeys.size; index++ )
	{
		bindArray = level.actionBinds[arrayKeys[index]];
		for ( bindIndex = 0; bindIndex < bindArray.size; bindIndex++ )
		{
			if ( bindArray[bindIndex].binding != binding )
				continue;

			bindArray[bindIndex].key = key;
		}
	}
}