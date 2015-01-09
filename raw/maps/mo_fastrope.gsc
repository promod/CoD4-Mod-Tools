#include common_scripts\utility;
#include maps\_utility;
#include maps\_anim;
#include maps\mo_tools;

main()
{
	level.fastrope_globals = spawnstruct();
	level.fastrope_globals.helicopters 		= [];
	level.fastrope_globals.animload 		= [];
	level.fastrope_globals.animload["blackhawk"] = false;
	level.fastrope_globals.heli_inflight 	= false;
	level.fastrope_globals.basename			= "fastrope_vehicle";
	
	spawner_array = getspawnerarray();
	
	fastrope_precache();
	
	array_thread(spawner_array, ::fastrope_setup);
}

/************************************************************************************************************************************/
/************************************************************************************************************************************/
/*                  		                 			  	OVERRIDE LOGIC															*/
/************************************************************************************************************************************/
/************************************************************************************************************************************/

fastrope_override(seat, xanim_all, xanim_ride, xanim_unload)
{
	name = fastrope_animname(self.type, seat);
	level.scr_anim[name]["custom_all" + self.targetname]		= xanim_all;
	level.scr_anim[name]["custom_ride" + self.targetname]		= xanim_ride;
	level.scr_anim[name]["custom_unload" + self.targetname]		= xanim_unload;	
}

fastrope_override_vehicle(xanim, node)
{
	level.scr_anim[self.animname]["pathanim"]	= xanim;	
	self.pathnode = node;
}

/************************************************************************************************************************************/
/************************************************************************************************************************************/
/*                  		                 			  	AI LOGIC																*/
/************************************************************************************************************************************/
/************************************************************************************************************************************/

fastrope_spawner_think()
{
	self endon("death");
	
	if(isdefined(self.script_parameters))
	{
		attr = strtok(self.script_parameters, ":;, ");
		for(i=0; i<attr.size; i++)
		{
			if(tolower(attr[i]) == "fastrope_seat")
			{
				i++;
				self.fastrope_seat = int(attr[i]);
			}
			if(tolower(attr[i]) == "nounload")
			{
				self.nounload = true;
			}
		}
	}
	
	while(1)
	{
		self waittill("spawned", guy);
		if(spawn_failed(guy))
			continue;	
		
		guy.spawner = self;
		guy thread fastrope_ai_think(self);
	}
}

fastrope_ai_think_hack(length, time)
{
	if(!isdefined(time))
		time = .2;
	wait length - time;
	self stopanimscripted();
	self notify("single_anim_done");
}

fastrope_ai_think(spawner)
{
	self endon("death");
	self endon("overtakenow");

	pivot = spawn("script_origin", self.origin);
	pivot.angles = self.angles;
	self linkto(pivot);
	pivot.ai = self;
	pivot.ai hide();
	
	//if there is a custom animation for the entire ride - this ends this thread
//	pivot endon("custom_all");
	
	//wait for his turn to go
	spawner fastrope_wait_que(pivot);
	
	//check for a custom anim
	if(isdefined(spawner.nounload) && spawner.nounload == true)
	{
		if(pivot.ai.seat_pos < 9)	
		{
			spawner fastrope_post_unload(pivot);
			spawner.heli waittill("unload_rest");
			spawner.heli.que[spawner.heli.que.size] = spawner;
		}
		else
		{
			spawner fastrope_post_unload(pivot);
			spawner.heli.vehicle waittill("reached_end_node");
			
			pivot delete();
			self delete();
			return;	
		}
	}
	
	spawner.heli notify("unload_" + pivot.ai.side);

	spawner fastrope_pre_unload(pivot);
	//pivot unlink();
	canim = "custom_unload" + spawner.heli.targetname;
	call = "custom_all" + spawner.heli.targetname;
	if(isdefined(level.scr_anim[pivot.ai.animname][call]))
	{		
				
		self waittillmatch("single anim", "start");
		self thread play_sound_on_entity("fastrope_start_npc");
		pivot thread play_loop_sound_on_entity("fastrope_loop_npc");
				
		fastrope_calc(pivot);
		spawner thread fastrope_post_unload(pivot);
		
		self waittillmatch("single_anim_done");
		pivot notify ("stop sound" + "fastrope_loop_npc");
		self thread play_sound_on_entity("fastrope_end_npc");
		self unlink();
		
	}
	else if(isdefined(level.scr_anim[pivot.ai.animname][canim]))
	{
		self thread fastrope_ai_think_hack( getanimlength(level.scr_anim[pivot.ai.animname][canim]) );
		spawner.heli.model thread anim_single_solo(self, canim, "tag_detach");
				
		self waittillmatch("single anim", "start");
		self thread play_sound_on_entity("fastrope_start_npc");
		pivot thread play_loop_sound_on_entity("fastrope_loop_npc");
				
		fastrope_calc(pivot);
		spawner thread fastrope_post_unload(pivot);
		
		self waittillmatch("single_anim_done");
		pivot notify ("stop sound" + "fastrope_loop_npc");
		self thread play_sound_on_entity("fastrope_end_npc");
		self unlink();
	}
	else
	{
		displacement = (45 * pivot.ai.index) + 90;
		spin = 360 * pivot.ai.spin;
		if(pivot.ai.side == "right")
			displacement += 180;		

		//this is where we have an animation of actually gettin on the rope
		self unlink();
		pivot.origin = self.origin;
		pivot.angles = self.angles;
		pivot linkto(self);
		
		spawner.heli thread fastrope_ropethink(self);
		spawner.heli.model thread anim_single_solo(self, "grab", "tag_detach");		
		//self waittillmatch("single anim", "start");
		wait 2.5;
		//rough calculation of drop for time for heli to leave
		fastrope_calc(pivot);
		
		self waittillmatch("single anim", "end");
		pivot unlink();
		self linkto(pivot);
		
		//calculate the drop
		fastrope_calc(pivot);
		spawner thread fastrope_post_unload(pivot);
		
		//go go go
		pivot thread anim_loop_solo(self, "loop", undefined, "stopanimscripted"); 
		self thread play_sound_on_entity("fastrope_start_npc");
		pivot thread play_loop_sound_on_entity("fastrope_loop_npc");
		//iprintlnbold("fastrope_loop_npc");
		
		pivot movez((pivot.range) *- 1, pivot.time);
		ang = displacement - spin;
		pivot rotateyaw(ang, pivot.time);
		wait pivot.time;
		//and the land
		pivot notify ("stopanimscripted");
		pivot.angles = self.angles;
		pivot anim_single_solo (self, "land");
		pivot notify ("stop sound" + "fastrope_loop_npc");
		self thread play_sound_on_entity("fastrope_end_npc");
		//iprintlnbold("fastrope_end_npc");
		
		self unlink();
	}
	
	pivot delete();
	wait 3;
	self pushplayer(false);
}

fastrope_wait_que(pivot)
{
	pivot.ai endon("death");
	//wait for the helicopter to be ready
	self fastrope_waiton_helicopter(pivot);
	
	//if it's a custom unload - then don't wait for the que
	if(isdefined(level.scr_anim[pivot.ai.animname]["custom_unload" + self.heli.targetname]))
		return;
	if(isdefined(level.scr_anim[pivot.ai.animname]["custom_all" + self.heli.targetname]))
		return;

	if(pivot.ai.side == "left")
		wait .5;
}

#using_animtree("generic_human");
fastrope_ropethink(ai)
{
	side = ai.side;
	xanim = "ropeidle" + side;
	xall = "ropeall" + side;
	//has a rope animation been set for this helicopter?
	if(!isdefined(level.scr_anim[self.targetname]))
		return;
		
	if( !( isdefined( level.scr_anim[self.targetname][xanim] ) || isdefined( level.scr_anim[self.targetname][xall] ) ) )
		return;
	//has it already been created?
	if( isdefined(self.rope_dropped[ side ] ) && self.rope_dropped[ side ] == true )
		return;
	
	self.rope_dropped[side] = true;
	
	tag = undefined;
	switch(self.type)
	{
		case "blackhawk":{
			switch(side)
			{
				case "left":{	tag = "TAG_FastRope_LE";	}break;
				case "right":{	tag = "TAG_FastRope_RI";	}break;
			}
		}break;
	}
	
	rope = spawn("script_model", self.model gettagorigin(tag));
	rope.angles = self.model gettagangles(tag);
	rope setmodel(level.models["heli"]["rope"][side]);
	rope.animname = self.animname;
	rope UseAnimTree(#animtree);
	rope linkto(self.model, tag);
	
	if(isdefined( level.scr_anim[self.targetname][xall] ) )
	{
		length = getanimlength( level.scr_anim[ self.targetname ][ xall ] );
		self.model thread anim_single_solo(rope, xall, tag);
		
		wait length - 1.5;
	}
	else
	{
		self.model thread anim_loop_solo(rope, xanim, tag, ("stop_" + xanim));
	
		self waittill("unload_" + side);
	
		//self waittill("ready");
		self.model notify(("stop_" + xanim));
	
		xanim = "ropedrop" + side;
		self.model thread anim_single_solo(rope, xanim, tag);
	
		while((self.que.size))
			self waittill("check_fastrope_que");

		wait self.lasttime;
	}
	rope unlink();
	
	self waittill("returnflight");
	self.rope_dropped[side] = false;
}

fastrope_pre_unload(pivot)
{
	self fastrope_free_seat(pivot);
}

fastrope_post_unload(pivot)
{	
	self.heli.lasttime = pivot.time;
	wait .1;
	self.heli.que = array_remove(self.heli.que, self);
	self.heli thread fastrope_que_check();
}

fastrope_que_check()
{
	wait self.unloadwait;
	self notify("check_fastrope_que");
}

fastrope_waiton_helicopter(pivot)
{	
	pivot.ai endon("death");
	self thread fastrope_attach_helicopter(pivot);
	//are we inflight yet?  if not, then take off
	if(!self.heli.inflight)
		self.heli thread fastrope_heli_fly();
	//are we ready to unload yet?
	self.heli endon("overtakenow");
	if(!self.heli.ready)
		self.heli waittill ("ready");
}

fastrope_attach_helicopter(pivot)
{
	pivot.ai endon("death");
	pivot.ai endon("overtakenow");
	
	//if a helicopter is unloading or on it's return trip - then this will 
	//wait until the next helicopter has taken off to attach it's guy to.
	while(1)
	{
		if(!self.heli.inflight)
			self.heli waittill("inflight");
		//no lets find his seat and play the animation
		self fastrope_find_seat(pivot.ai);
		//if we don't find a seat, then wait for to open up
		//and go back to the top to wait for another helicopter
		if(!isdefined(pivot.ai.seat_index))
		{
			self.heli waittill("seat_open");
			continue;
		}
		else
			break;
	}

	self.heli.model endon("death");

	index = pivot.ai.seat_index;
	pivot.ai.animname 	= self.heli.seats[index].animname;
	pivot.ai.index	 	= self.heli.seats[index].index;
	pivot.ai.side 		= self.heli.seats[index].side; 
	pivot.ai.spin 		= self.heli.seats[index].spin; 
	self.heli.que[self.heli.que.size] = self;
	
	//so the heli is ready - move the ai to the heli and link him
	pivot moveto(self.heli.model gettagorigin("tag_detach"), .05);
	wait .1;
	
	pivot.angles = self.heli.model gettagangles("tag_detach");
	pivot linkto(self.heli.model, "tag_detach");
	pivot.ai show();
	pivot.ai linkto(self.heli.model, "tag_detach");
	
	self.heli thread fastrope_ropethink(pivot.ai);
	
	self.heli.model endon( ("stop_" + index) );
	
	//check for a custom anim
	if(isdefined(level.scr_anim[pivot.ai.animname]["custom_all" + self.heli.targetname]))
	{
		pivot.ai linkto(self.heli.model, "tag_detach");//unlink();
		pivot.ai pushplayer(true);
		pivot linkto(pivot.ai);
		self.heli.model thread anim_single_solo(pivot.ai, "custom_all" + self.heli.targetname, "tag_detach");
		
		pivot notify("custom_all");
		pivot.ai thread fastrope_ai_think_hack( getanimlength(level.scr_anim[pivot.ai.animname]["custom_all" + self.heli.targetname]), .25 );
		return;
	}
	
	if(isdefined(level.scr_anim[pivot.ai.animname]["custom_ride" + self.heli.targetname]))
	{
		pivot.ai linkto(self.heli.model, "tag_detach");//unlink();
		pivot.ai pushplayer(true);
		pivot linkto(pivot.ai);
		
		self.heli.model anim_single_solo(pivot.ai, "custom_ride" + self.heli.targetname, "tag_detach");
		if(self.heli.ready)
			return;
	}
	self.heli.model thread anim_loop_solo(pivot.ai, "idle", "tag_detach", ("stop_" + index));
}

fastrope_free_seat(pivot)
{
	if( ! isdefined(level.scr_anim[pivot.ai.animname]["custom_all" + self.heli.targetname]))
	{
		self.heli.model notify(("stop_" + pivot.ai.seat_index));
		pivot.ai stopanimscripted();
		pivot.origin = pivot.ai.origin;
		pivot.angles = pivot.ai.angles;
	//	pivot.ai linkto(pivot);
	}
	self.heli.seats[pivot.ai.seat_index].taken = undefined;
	self.heli notify("seat_open");
}

fastrope_find_seat(ai)
{
	ai.seat_index = undefined;
		
	if(isdefined(self.fastrope_seat))
	{
		for(i=0; i<self.heli.seats.size; i++)
		{
			if(self.heli.seats[i].pos != self.fastrope_seat)
				continue;
			
			if(isdefined(self.heli.seats[i].taken))
			{
				//find the guy who already had a seat, another seat
				self.heli.seats[i].taken.spawner fastrope_find_seat(self.heli.seats[i].taken);
			}
			
			self.heli.seats[i].taken = ai;
			ai.seat_index = i;
			ai.seat_pos = self.heli.seats[i].pos;
			return;
		}
	}
	
	for(i=0; i<self.heli.seats.size; i++)
	{
		if(isdefined(self.heli.seats[i].taken))
			continue;
		
		self.heli.seats[i].taken = ai;
		ai.seat_index = i;
		ai.seat_pos = self.heli.seats[i].pos;
		break;
	}
}

/************************************************************************************************************************************/
/************************************************************************************************************************************/
/*                  		                 			  	PLAYER RIDE LOGIC														*/
/************************************************************************************************************************************/
/************************************************************************************************************************************/

#using_animtree("fastrope");
fastrope_player_think()
{
	playerWeaponTake();
			
	camera = self fastrope_player_attach();
	level.player.cgocamera = camera;
	self.model thread fastrope_player_quake();
	
	self endon("overtakenow");
	
	wait .1;
	insert = 0;
	for(i=0; i<self.seats.size; i++)
	{
		if(isdefined(self.seats[i].taken))
		{
			if(self.seats[i].taken != level.player)
				insert++;
			else
				break;
		}
	}
	
	self.que = array_insert(self.que, level.player, insert);
	
	//i dont know why the fuck i have to do this now
	//but if i dont wait 2.4 seconds, then the setplayer angles doesn't work
	wait 2;
	level.player setplayerangles( (15, 70,0) );
	
	self.vehicle waittill("reached_wait_node");
	
	wait 2.5;
	
	if (getdvar("fastropeunlock") == "")
    	setdvar("fastropeunlock", "0");
    
    if (!isdefined(getdvar ("fastropeunlock")))
	 	setdvar ("fastropeunlock", "0");
    		
	self fastrope_player_viewshift();
	self fastrope_player_unload();

}

play_fast_rope_fx()
{
	fxorigin = spawn( "script_model", level.player.origin );
	fxorigin setmodel( "tag_origin" );
	fxorigin linkto ( level.player );

	playfxontag (level._effect["rain_drops_fastrope"], fxorigin, "tag_origin");
	wait 3;
	fxorigin delete ();
		
}


fastrope_player_viewshift()
{
	string = int( getdvar("fastropeunlock") );
	if( !string )
		self fastrope_player_viewshift_lock();
	else
		self fastrope_player_viewshift_nolock();
}

fastrope_player_unload()
{
	string = int( getdvar("fastropeunlock") );
	if( !string )
		self fastrope_player_unload_lock();
	else
		self fastrope_player_unload_nolock();
}

fastrope_player_viewshift_nolock()
{	
	camera = level.player.cgocamera;

	wait 1;
	level.player playerlinktodelta(camera, "tag_player", 1, 100, 100, 30, 80);			
	camera waittillmatch("single anim", "end");
}

fastrope_player_unload_nolock()
{
	camera = level.player.cgocamera;
	
	link = spawn("script_origin", camera.origin);
	link.angles = camera.angles;
	camera linkto(link);
	
	time1 = 1;
			
	back = anglestoforward( (0,233,0) );
	back = vector_multiply(back, 30);
	
	self.que =  array_remove(self.que, level.player);
	self thread fastrope_que_check();
	
	fastrope_calc(level.player);
	level.player.time += 1;
	self.lasttime = level.player.time;
	
	zrange = (level.player.range + 100) *- 1;
	
	//link moveto(level.player.origin + (0,0,zrange) + back, level.player.time);
	link moveto( (3220, 255, 435), level.player.time);
	link thread anim_loop_solo(camera, "loop", undefined, "stopanimscripted");
	camera thread play_sound_on_entity("fastrope_start_plr");
	camera thread play_loop_sound_on_entity("fastrope_loop_plr");
		
	wait level.player.time;
	
	camera notify ("stop sound" + "fastrope_loop_plr");
	camera thread play_sound_on_entity("fastrope_end_plr");

	link notify("stopanimscripted");
		
	playerWeaponGive();
	setsaveddvar( "compass", 1 );
	SetSavedDvar( "ammoCounterHide", "0" );
	SetSavedDvar( "hud_showStance", 1 );
	setSavedDvar( "hud_drawhud", "1" );

	level.player unlink();
	level.player allowLean(true);
	level.player allowcrouch(true);
	level.player allowprone(true);

	link delete();
	camera delete();
}

fastrope_player_viewshift_nolock2()
{	
	camera = level.player.cgocamera;

	wait 1;
	level.player playerlinktodelta(camera, "tag_player", 1, 100, 100, 30, 80);			
	camera waittillmatch("single anim", "end");
}

fastrope_player_unload_nolock2()
{	
	camera = level.player.cgocamera;
	
	link = spawn("script_origin", camera.origin);
	link.angles = camera.angles;
	camera linkto(link);
	
	time1 = 1;
			
	back = anglestoforward( (0,233,0) );
	back = vector_multiply(back, 30);
	
	self.que =  array_remove(self.que, level.player);
	self thread fastrope_que_check();
	
	fastrope_calc(level.player);
	level.player.time += 1;
	self.lasttime = level.player.time;
	
	zrange = (level.player.range + 100) *- 1;
	
	//link moveto(level.player.origin + (0,0,zrange) + back, level.player.time);
	link moveto( (3220, 300, 400), level.player.time);
	link thread anim_loop_solo(camera, "loop", undefined, "stopanimscripted");
	camera thread play_sound_on_entity("fastrope_start_plr");
	camera thread play_loop_sound_on_entity("fastrope_loop_plr");
	
	time3 = .5;
	wait level.player.time - time3;
	
	link rotateto((-60, 225, 0), time3, time3 * .5, time3 * .5);
	
	wait time3;
	
	camera notify ("stop sound" + "fastrope_loop_plr");
	camera thread play_sound_on_entity("fastrope_end_plr");

	link notify("stopanimscripted");
		
	playerWeaponGive();
	setsaveddvar( "compass", 1 );
	SetSavedDvar( "ammoCounterHide", "0" );
	SetSavedDvar( "hud_showStance", 1 );
	setSavedDvar( "hud_drawhud", "1" );
	
	level.player unlink();
	level.player allowLean(true);
	level.player allowcrouch(true);
	level.player allowprone(true);

	link delete();
	camera delete();
	
	
}

fastrope_player_viewshift_lock()
{	
	camera = level.player.cgocamera;
	
	camera2 = spawn("script_origin", camera.origin);
	camera2.angles = level.player getplayerangles();
		
	time = 1;
	goalangles = camera gettagangles( "tag_player" );
	camera2 rotateto(goalangles, time, time * .5, time * .5);
	
	num = int(time * 20);
	numtotal = num;
	level.player freezecontrols(true);
	while(num)
	{
		num--;
		level.player setplayerangles( (camera2.angles[0], camera2.angles[1], level.player getplayerangles()[2]) );
		wait .05;
		
		if(num > (numtotal * .5) )
			continue;
		if( num%2 )
			continue;
		if(!num)
			break;
			
		goalangles = camera gettagangles( "tag_player" );
		camera2 rotateto(goalangles, (time * ( num/numtotal )) );
	}
	level.player setplayerangles( (camera2.angles[0], camera2.angles[1], level.player getplayerangles()[2]) );
	level.player playerlinktodelta(camera, "tag_player", 1, 15, 15, 5, 5);
	
	wait .1;
	
	level.player freezecontrols(false);
	
	camera2 delete();
			
	camera waittillmatch("single anim", "end");
}

fastrope_player_unload_lock()
{	
	camera = level.player.cgocamera;
	
	link = spawn("script_origin", camera.origin);
	link.angles = camera.angles;
	camera linkto(link);
	
	time1 = 1;
			
	back = anglestoforward( (0,233,0) );
	back = vector_multiply(back, -50);
	
	self.que =  array_remove(self.que, level.player);
	self thread fastrope_que_check();
	
	fastrope_calc(level.player);
	level.player.time += .5;
	self.lasttime = level.player.time;
	
	zrange = (level.player.range + 100) *- 1;
	
	timefrac = time1 / (level.player.time + .5);
	zfrac = zrange * timefrac;
	movefinal = link.origin + back + (0,0,zfrac);
	
	link rotateto((80, 233, 0), time1, time1 * .5, time1 * .5); 
	link moveto(movefinal, time1);
	
	link thread anim_loop_solo(camera, "loop", undefined, "stopanimscripted");
	camera thread play_sound_on_entity("fastrope_start_plr");
	camera thread play_loop_sound_on_entity("fastrope_loop_plr");

	thread play_fast_rope_fx();
		
	wait time1;
	
	time3 = .5;
	time2 = level.player.time - time1 + .5 - time3;
	
	zfrac = zrange - zfrac;
	timefrac = (level.player.time + .5) * (zfrac/zrange);
	back = vector_multiply(back, -1);
	
	movefinal = link.origin + back + (0,0,zfrac);
	link moveto(movefinal, (level.player.time + .5 - time1));
		
	wait time2;
	
	link rotateto((10, 233, 0), time3, time3 * .5, time3 * .5); 
		
	wait time3 - .25;
	camera notify ("stop sound" + "fastrope_loop_plr");
	camera thread play_sound_on_entity("fastrope_end_plr");
	
	link moveto( (3200, 225, 337), .5);

	link notify("stopanimscripted");
		
	playerWeaponGive();
	setsaveddvar( "compass", 1 );
	SetSavedDvar( "ammoCounterHide", "0" );
	SetSavedDvar( "hud_showStance", 1 );
	setSavedDvar( "hud_drawhud", "1" );
	wait .4;
	
	level.player unlink();
	level.player allowLean(true);
	level.player allowcrouch(true);
	level.player allowprone(true);

	link delete();
	camera delete();	
}

#using_animtree("fastrope");
fastrope_player_attach()
{
	camera = spawn("script_model", self.model gettagorigin("tag_detach"));
	camera setmodel(level.models["player"]["fastrope"]);
	//camera linkto(self.model, "tag_detach", (-30,28,-26), (0,0,0));
	camera linkto(self.model, "tag_detach", (0,0,0), (0,0,0));
	//camera linkto(self.model, "tag_detach", (-30,25,-26), (0,0,0));
	camera.animname = fastrope_animname(self.type, "player");
	camera UseAnimTree(#animtree);
	camera hide();
	
	level.player playerlinktodelta(camera, "tag_player", 1, 100, 100, 30, 60);

	self.model thread anim_single_solo(camera, "ride", "tag_detach", self.model);
	//iprintlnbold( getanimlength( camera getanim( "ride" ) ) );
	level.player allowLean(false);
	level.player allowcrouch(false);
	level.player allowprone(false);
	//level.player setplayerangles( (10,42,0) );
	
	
	return camera;
}

fastrope_player_quake()
{
	self endon("death");
	self endon("stopquake");
	while(1)
	{
		wait .1;
		earthquake(0.2, .1, self.origin, 256);
	}
}

/************************************************************************************************************************************/
/************************************************************************************************************************************/
/*                  		                 			  	HELICOPTER LOGIC														*/
/************************************************************************************************************************************/
/************************************************************************************************************************************/

#using_animtree("vehicles");
//#using_animtree("embassy");
fastrope_heli_fly()
{
	self.inflight = true;
	if(self.ready)
		return;
	if(self.returnflight)
		self waittill("returnflight");
	
	if(isdefined(self.pathnode))
	{
		vStartingOrigin = getstartorigin( self.pathnode.origin, self.pathnode.angles, level.scr_anim[self.animname]["pathanim"]);
		aStartingAngles = getstartangles( self.pathnode.origin, self.pathnode.angles, level.scr_anim[self.animname]["pathanim"]);
		
		self.vehicle 		= spawn("script_model", vStartingOrigin);
		self.vehicle.angles = aStartingAngles;
	}
	else if(isdefined(self.startnode))
		self.vehicle 	= spawnvehicle(self.modelname, self.targetname, self.type, self.startnode.origin, self.startnode.angles);
	else
	{
		assertmsg("fastrope helicopter vehicle (" + self.targetname + ") does not have a path animation set nor a vehicle node");
		return;
	}
	self.vehicle 	setmodel(self.modelname); 
	self.model 		= self.vehicle;
	
	if(isdefined(level._sea_org))
	{
		self.model 			= spawn("script_model", self.vehicle.origin);
		self.model 			setmodel(self.modelname);
		self.model.angles 	= self.vehicle.angles;	
		self.model thread fastrope_heli_fly_sea(self.vehicle);
		self.vehicle hide();
		self.vehicle setcontents(0);
	}

	self.model UseAnimTree(#animtree);
	self.model setanim(level.scr_anim[fastrope_animname(self.type, "heli")]["loop"][0]);
	self.model.vehicletype = self.type;
	self.model thread maps\_vehicle::helicopter_dust_kickup();
	
	self notify("inflight");
	
	//attach player
	if(self.player)
		self thread fastrope_player_think();
		
	self endon ("overtakenow");
	
	wait .1;
	level.fastrope_globals.heli_inflight = true;

	self fastrope_heli_waittill_unload();
	self.vehicle notify ("reached_wait_node");
	
	self.inflight = false;
	level.fastrope_globals.heli_inflight = false;
	self.returnflight = true;
	self.ready = true;
	self notify("ready");//this notify starts unloading guys
	self.ready = false;//stops anyone else from getting on who isn't already on board
	
	while((self.que.size))
		self waittill("check_fastrope_que");
	
	wait self.lasttime;// + 2.5;
	
	self.vehicle notify("going_home");//can be used by outside scripts to find out when it's leaving
	
	if(isdefined(self.overtake))
	{
		self notify("overtake");
		return;	
	}	
	
	if(isdefined(self.pathnode))
	{
		self.vehicle waittillmatch("single anim", "end");
		self.vehicle notify("reached_end_node");	
	}
	else
	{
		self.vehicle resumespeed(10);
		self.vehicle waittill("reached_end_node");
	}
	
	self fastrope_heli_cleanup();
}

#using_animtree("vehicles");
fastrope_heli_waittill_unload()
{
	if(isdefined(self.pathnode))
	{
		self.vehicle endon ("fake_wait_node");
		
		wait .1;
		self.model thread play_loop_sound_on_entity(self.enginesnd);
		self.vehicle.animname = self.animname;
		self.vehicle UseAnimTree(#animtree);
		wait 1.15;
		self.pathnode thread anim_single_solo(self.vehicle, "pathanim");
		self.vehicle waittillmatch("single anim", "stop");
	}
	
	else
	{
		self.vehicle attachPath(self.startnode);
		self.vehicle startpath();
		wait .1;
		self.model thread play_loop_sound_on_entity(self.enginesnd);
		self.vehicle setWaitNode(self.stopnode);
		self.vehicle waittill( "reached_wait_node");
		self notify("almost_ready");
		self.vehicle setspeed(0,25);
	
		while(self.vehicle getspeed() > 0)
			wait .1;
	}
}

fastrope_heli_cleanup()
{
	self.model notify("stop_anim_loop");
	self.model notify("stop sound" + self.enginesnd);
	self.vehicle delete();
	self.vehicle = undefined;
	if(isdefined(self.model))
	{
		self.model delete();
		self.model = undefined;
	}
	
	self.returnflight = false;
	self notify("returnflight");
}

fastrope_heli_overtake()
{
	self.overtake = true;
	self waittill("overtake");
	self.model notify("overtake");
	
	angles = self.model.angles;
	origin = self.vehicle.origin;
	
	self.vehicle delete();
	self.vehicle = undefined;
	
	self.vehicle = spawnvehicle(self.modelname, self.targetname, self.type, origin, angles);
	self.vehicle.health = 100000;
	self.vehicle hide();
	self.vehicle setcontents(0);
	
	self.model thread fastrope_heli_fly_sea(self.vehicle);
}

fastrope_heli_overtake_now()
{
	self.overtake = true;
	self notify("overtakenow");
	self.model notify("overtake");
	
	angles = self.vehicle.angles;
	origin = self.vehicle.origin;
	
	self.vehicle delete();
	self.vehicle = undefined;
	
	self.vehicle = spawnvehicle(self.modelname, self.targetname, self.type, origin, angles);
	self.vehicle.health = 100000;
	self.vehicle hide();
	self.vehicle setcontents(0);
	
	self.model thread fastrope_heli_fly_sea(self.vehicle);
}

fastrope_heli_playExteriorLightFX()
{
	playfxontag( level._effect[ "aircraft_light_wingtip_red" ], self, "tag_light_L_wing" );
	playfxontag( level._effect[ "aircraft_light_wingtip_green" ], self, "tag_light_R_wing" );
	playfxontag( level._effect[ "aircraft_light_white_blink" ], self, "tag_light_belly" );
	wait .25;
	playfxontag( level._effect[ "aircraft_light_white_blink" ], self, "tag_light_tail" );
}

fastrope_heli_playInteriorLightFX()
{
	playfxontag( level._effect[ "aircraft_light_cockpit_blue" ], self, "tag_light_cockpit01" );
}

fastrope_heli_playInteriorLightFX2()
{
	playfxontag( level._effect[ "aircraft_light_cockpit_red" ], self, "tag_light_cargo01" );
}

fastrope_heli_fly_sea(heli)
{
	self endon("death");
	self endon("overtake");
	
	while(1)
	{
		/************************************************/
		/*					hey RAYME					*/
		/*												*/
		/*	to test the anim bug, just change every		*/
		/*	instance of _sea_link to _sea_org in this	*/
		/*	function									*/
		/************************************************/
		pos = level._sea_link localtoworldcoords(heli.origin);
		ang = combineangles(level._sea_link.angles, heli gettagangles("tag_detach"));
		
		self moveto(pos + level._sea_link.offset, .1);
		self rotateto(ang, .1);
		wait .1;
	}	
}

fastrope_calc(ent)
{
	start = ent.origin;
	
	end = physicstrace(start, (start + (0,0,-10000)) );
	
	//calc distances
	dist = distance(start, end) + 1;
	turndistance = 400;
	range = int(dist - 128);
	turns = int(range/turndistance);
	remainder = range - (turndistance * turns);
	fraction = remainder / turndistance;
	time = (turns + fraction) * 1.6; //per turn
	ang = (fraction * -360);
	angle = (ent.angles + (0, ang, 0));
	
	ent.range		= range;
	ent.time		= time;
	ent.startangle	= angle;
	//iprintlnbold("done calculating");
}

/************************************************************************************************************************************/
/************************************************************************************************************************************/
/*                  		                 			  	INITIAL SETUP															*/
/************************************************************************************************************************************/
/************************************************************************************************************************************/

fastrope_setup()
{
	//if we're not a fastrope guy - get outta here
	if( ! (isdefined(self.script_noteworthy) && self.script_noteworthy == "fastrope_friendlies") )
		return;
	
	//grab the helicopter
	self.heli = fastrope_heli_setup(self.targetname);
	
	fastrope_animload(self.heli);
	
	self thread fastrope_spawner_think();
}

fastrope_heli_setup(name)
{
	heli = undefined;
	//does it exist already?
	heli = level.fastrope_globals.helicopters[fastrope_heliname(name)];
	//if we find it - then it's a heli we've already made
	if(isdefined(heli))
		return heli;
	
	//it's a new helicopter, lets create it
	ent 				= getstruct(name, "target");
	heli 				= spawnstruct();
	heli.vehicle 		= undefined;
	heli.targetname		= fastrope_heliname(name);
	heli.animname		= heli.targetname;
	heli.startnode 		= getvehiclenode(name, "targetname");
	heli.stopnode		= undefined;
	
	heli.lasttime		= undefined;
	
	heli.ready 			= false;
	heli.inflight 		= false;
	heli.returnflight 	= false;	
	heli.que			= [];
	heli.rope_dropped	= [];
	
	//set default helicopter type
	heli.modelname 		= "vehicle_blackhawk_hero_sas_night";
	heli.type 			= "blackhawk";
	heli.enginesnd 		= "blackhawk_engine_high";
	heli.player			= 0;
	heli.unload			= "both";
	heli.unloadwait		= 1;
	
	//grab parameters from the struct
	if(isdefined(ent.script_parameters))
	{
		attr = strtok(ent.script_parameters, ":;,= ");
		for(i=0; i<attr.size; i++)
		{
			if(tolower(attr[i]) == "model")
			{
				i++;
				switch(attr[i])
				{
					case "blackhawk":{
						heli.modelname 	= "vehicle_blackhawk_hero_sas_night";
						heli.type 		= "blackhawk";
						heli.enginesnd 	= "blackhawk_engine_high";
						}break;
				}
			}
			else if(tolower(attr[i]) == "player")
			{
				i++;
				if(tolower(attr[i]) == "true")
					heli.player = true;
			}
			else if(tolower(attr[i]) == "unload")
			{
				i++;
				if( ( attr[i] == "both" || attr[i] == "left" || attr[i] == "right" ) )
					heli.unload = attr[i];
			}
		}
	}
		
	fastrope_heli_setup_seats(heli);
		
	if(isdefined(heli.startnode))
	{
		//setup the vehicle path
		node = heli.startnode;
		
		while(isdefined(node.target))
		{
			node = getvehiclenode(node.target, "targetname");
			if(isdefined(node.script_noteworthy) && node.script_noteworthy == "stop")
			{
				heli.stopnode = node;
				break;	
			}	
		}
		if(!isdefined(heli.stopnode))
			assertmsg("fastrope helicopter vehicle path with path starting at (" + heli.startnode.origin + ") does not have a node to unload fastrope ai.  Please set script_noteworthy = stop on the node you want to unload.");
	}
	
	level.fastrope_globals.helicopters[heli.targetname] = heli;
	return heli;
}

fastrope_heli_setup_seats(heli)
{
	//setup the seating
	heli.seats = [];
	
	//this decides the order guys will be loaded into the heli
	switch(heli.type)
	{
		case "blackhawk":{
			switch(heli.unload)
			{
				case "both":{
					heli.seats[0] = fastrope_createseat(heli.type, 1);
					heli.seats[1] = fastrope_createseat(heli.type, 2);
					heli.seats[2] = fastrope_createseat(heli.type, 5);
					heli.seats[3] = fastrope_createseat(heli.type, 4);
					heli.seats[4] = fastrope_createseat(heli.type, 8);
					heli.seats[5] = fastrope_createseat(heli.type, 6);
					heli.seats[6] = fastrope_createseat(heli.type, 7);
					heli.seats[7] = fastrope_createseat(heli.type, 3);
					heli.seats[8] = fastrope_createseat(heli.type, 9);
					heli.seats[9] = fastrope_createseat(heli.type, 10);
				
					//save one seat for the player
					if(heli.player)
					{
						level.player.side = "right";
						heli.seats[4].taken = level.player;
					}
					}break;
				case "right":{
					heli.seats[0] = fastrope_createseat(heli.type, 1);
					heli.seats[1] = fastrope_createseat(heli.type, 2);
					heli.seats[2] = fastrope_createseat(heli.type, 8);
					heli.seats[3] = fastrope_createseat(heli.type, 7);
					heli.seats[4] = fastrope_createseat(heli.type, 9);
					heli.seats[5] = fastrope_createseat(heli.type, 10);
				
					//save one seat for the player
					if(heli.player)
					{
						level.player.side = "right";
						heli.seats[2].taken = level.player;
					}
					}break;
				case "left":{
					heli.seats[0] = fastrope_createseat(heli.type, 5);
					heli.seats[1] = fastrope_createseat(heli.type, 4);
					heli.seats[2] = fastrope_createseat(heli.type, 6);
					heli.seats[3] = fastrope_createseat(heli.type, 3);
					heli.seats[4] = fastrope_createseat(heli.type, 9);
					heli.seats[5] = fastrope_createseat(heli.type, 10);
					
					if(heli.player)
					{
						level.player.side = "right";
					}				
					}break;
			}
			}break;
	}
}

fastrope_precache()
{
	level.models["player"]["fastrope"] = "fastrope_arms";
	level.models["heli"]["rope"]["right"] = "rope_test_ri";
	level.models["heli"]["rope"]["left"] = "rope_test";
		
	precacheModel(level.models["player"]["fastrope"]);
	precacheModel(level.models["heli"]["rope"]["right"]);
	precacheModel(level.models["heli"]["rope"]["left"]);
}

fastrope_ropeanimload(xidle, xdrop, side, xall)
{	
	level.scr_anim[self.targetname]["ropeall" + side] = xall;
	level.scr_anim[self.targetname]["ropeidle" + side][0] = xidle;
	level.scr_anim[self.targetname]["ropedrop" + side] = xdrop;
}

#using_animtree("generic_human");
fastrope_animload(heli)
{
	type = heli.type;
	if(level.fastrope_globals.animload[type])
		return;
	
	level.fastrope_globals.animload[type] = true;
	
	fastrope_animload_heli(type);
	fastrope_animload_player(type);
	
	switch(type)
	{
		case "blackhawk":{
			name = fastrope_animname(type, 1);
			level.scr_anim[name]["idle"][0]		= %bh_1_idle;
			level.scr_anim[name]["grab"]		= %bh_1_begining;
			level.scr_anim[name]["loop"][0]		= %bh_fastrope_loop;
			level.scr_anim[name]["land"]		= %bh_fastrope_land;
			
			name = fastrope_animname(type, 2);
			level.scr_anim[name]["idle"][0]		= %bh_2_idle;
			level.scr_anim[name]["grab"]		= %bh_2_begining;
			level.scr_anim[name]["loop"][0]		= %bh_fastrope_loop;
			level.scr_anim[name]["land"]		= %bh_fastrope_land;
			
			name = fastrope_animname(type, 3);
			level.scr_anim[name]["idle"][0]		= %bh_2_idle;
			level.scr_anim[name]["grab"]		= %bh_2_begining;//-->
			level.scr_anim[name]["loop"][0]		= %bh_fastrope_loop;
			level.scr_anim[name]["land"]		= %bh_fastrope_land;
			
			name = fastrope_animname(type, 4);
			level.scr_anim[name]["idle"][0]		= %bh_4_idle;
			level.scr_anim[name]["grab"]		= %bh_4_begining;
			level.scr_anim[name]["loop"][0]		= %bh_fastrope_loop;
			level.scr_anim[name]["land"]		= %bh_fastrope_land;
			
			name = fastrope_animname(type, 5);
			level.scr_anim[name]["idle"][0]		= %bh_5_idle;
			level.scr_anim[name]["grab"]		= %bh_5_begining;
			level.scr_anim[name]["loop"][0]		= %bh_fastrope_loop;
			level.scr_anim[name]["land"]		= %bh_fastrope_land;
			
			name = fastrope_animname(type, 6);
			level.scr_anim[name]["idle"][0]		= %bh_6_idle;
			level.scr_anim[name]["grab"]		= %bh_6_begining;//-->
			level.scr_anim[name]["loop"][0]		= %bh_fastrope_loop;
			level.scr_anim[name]["land"]		= %bh_fastrope_land;
			
			name = fastrope_animname(type, 7);
			level.scr_anim[name]["idle"][0]		= %bh_2_idle;
			level.scr_anim[name]["grab"]		= %bh_2_begining;//-->
			level.scr_anim[name]["loop"][0]		= %bh_fastrope_loop;
			level.scr_anim[name]["land"]		= %bh_fastrope_land;
			
			name = fastrope_animname(type, 8);
			level.scr_anim[name]["idle"][0]		= %bh_2_idle;//%bh_8_idle;//-->
			level.scr_anim[name]["grab"]		= %bh_2_begining;//%bh_8_begining;//-->
			level.scr_anim[name]["loop"][0]		= %bh_fastrope_loop;
			level.scr_anim[name]["land"]		= %bh_fastrope_land;
			
			name = fastrope_animname(type, 9);
			level.scr_anim[name]["idle"][0]		= %bh_Pilot_idle;
			
			name = fastrope_animname(type, 10);
			level.scr_anim[name]["idle"][0]		= %bh_coPilot_idle;
			}break;
	}
}

fastrope_createseat(type, pos)
{
	seat 			= spawnstruct();
	seat.taken 		= undefined;
	seat.animname 	= fastrope_animname(type, pos);
	seat.side 		= fastrope_getside(type, pos);
	seat.index		= fastrope_getindex(type, pos);
	seat.spin		= fastrope_getspin(type, pos);
	seat.pos		= pos;
	return seat;
}

fastrope_heliname(name)
{
	return (level.fastrope_globals.basename + name);
}

fastrope_animname(type, seat)
{
	return ("fastrope_" + type + "_" + seat);
}

fastrope_get_heli(name)
{
	return level.fastrope_globals.helicopters[(level.fastrope_globals.basename + name)];	
}

fastrope_getspin(type, seat)
{
	seats = [];
	switch(type)
	{
		case "blackhawk":{
			
			seats[1] = 0;
			seats[2] = 0;
			seats[8] = 0;
			seats[7] = 0;
			
			seats[5] = 0;
			seats[4] = 1;
			seats[6] = 1;
			seats[3] = 1;
			
			seats[9] = undefined;
			seats[10] = undefined;
		};	
	}
	return seats[seat];
}

fastrope_getindex(type, seat)
{
	seats = [];
	switch(type)
	{
		case "blackhawk":{
			
			seats[1] = 0;
			seats[2] = .25;
			seats[8] = -1.5;
			seats[7] = 1;
			
			seats[5] = 0;
			seats[4] = .25;
			seats[6] = -1.5;
			seats[3] = 1;
			
			seats[9] = undefined;
			seats[10] = undefined;
		};	
	}
	return seats[seat];
}

fastrope_getside(type, seat)
{
	seats = [];
	switch(type)
	{
		case "blackhawk":{
			
			seats[1] = "right";
			seats[2] = "right";
			seats[3] = "left";
			seats[4] = "left";
			seats[5] = "left";
			seats[6] = "left";
			seats[7] = "right";
			seats[8] = "right";
			seats[9] = "right";
			seats[10] = "right";
		};	
	}
	return seats[seat];
}	

#using_animtree("fastrope");
fastrope_animload_player(type)
{
	switch(type)
	{
		case "blackhawk":{
			name = fastrope_animname(type, "player");
			level.scr_anim[name]["idle"][0]		= %cs_bh_player_idle;
			level.scr_anim[name]["ride"]			= %bh_player_rope_start;
			level.scr_anim[name]["loop"][0]		= %bh_player_rope_middle;
			level.scr_anim[name]["land"]		= %bh_player_rope_end;
			}break;
	}
}

#using_animtree("vehicles");
fastrope_animload_heli(type)
{
	switch(type)
	{
		case "blackhawk":{
			name = fastrope_animname(type, "heli");
			level.scr_anim[name]["loop"][0]		= %bh_rotors;
			}break;
	}
}