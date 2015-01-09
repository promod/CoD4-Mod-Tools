#include common_scripts\utility;
#include maps\_utility;
#include maps\_anim;
#include maps\mo_tools;

main(name)
{
	if(!isdefined(name))
	{
		assertmsg("mo_globals called without initialization variable.  mo_globals::main(<level name>);");
		return;	
	}
		
	level.level_name = name;
	switch(name)
	{
		case "descent":
		{
			level.strings["hint_detpack"] = &"DESCENT_HINTSTR_DETPACK";
			precacheString(level.strings["hint_detpack"]);
		}break;
	}	
	
	friendly_main();
	ai_generic_main();
	misc_main();
	interactive_main();
}

/************************************************************************************************************************************/
/************************************************************************************************************************************/
/*                  		                 			  GENERIC AI LOGIC															*/
/************************************************************************************************************************************/
/************************************************************************************************************************************/
ai_generic_main()
{
	spawners = getspawnerarray();
	array_thread(spawners, ::ai_special_parameters);
}

ai_special_parameters()
{
	if(isdefined(self.target) && isdefined(self.script_forcecolor))
		self thread ai_nodebeforecolor_think();
	
	if(!isdefined(self.script_parameters))
		return;
		
	attr = strtok(self.script_parameters, ":;, ");
	
	for(i=0; i<attr.size; i++)
	{
		if(tolower(attr[i]) == "ignoreme")
		{
			i++;
			if(int(attr[i]) == 0)
			{
				self.stopIgnoreNotifyEnt = attr[i];
				i++;
				self.stopIgnoreNotifyMsg = attr[i];
				self thread ai_ignoreme_think();
			}
			else
			{
				self.stopIgnoreTime = int(attr[i]);
				self thread ai_ignoreme_think();
			}
		}
		else if(tolower(attr[i]) == "setforcegoal")
		{
			i++;
			if(int(attr[i]) == 0)
			{
				self.stopForceGoalNotifyEnt = attr[i];
				i++;
				self.stopForceGoalNotifyMsg = attr[i];
				self thread ai_setforcegoal_think();
			}
			else
			{
				self.stopForceGoalTime = int(attr[i]);
				self thread ai_setforcegoal_think();
			}	
		}
		else if(tolower(attr[i]) == "setforcecolor")
		{
			i++;
			self.setForceColorValue = attr[i];
			assert(maps\_colors::colorIsLegit(self.setForceColorValue), "spawner at origin " + self.origin + " has non-legit setforcedcolor, " + self.setForceColorValue + ".");
			i++;
			if(int(attr[i]) == 0)
			{
				self.setForceColorNotifyEnt = attr[i];
				i++;
				self.setForceColorNotifyMsg = attr[i];
				self thread ai_setforcecolor_think();
			}
			else
			{
				self.setForceColorTime = int(attr[i]);
				self thread ai_setforcecolor_think();
			}	
		}
		else if(tolower(attr[i]) == "magicbulletshield")
		{
			i++;
			if(int(attr[i]) == 0)
			{
				self.stopBulletShieldNotifyEnt = attr[i];
				i++;
				self.stopBulletShieldNotifyMsg = attr[i];
				self thread ai_magicbulletshield_think();
			}
			else
			{
				self.stopBulletShieldTime = int(attr[i]);
				self thread ai_magicbulletshield_think();
			}	
		}
		else if(tolower(attr[i]) == "floodspawner")
		{
			i++;
				self.FloodSpawnCount = int(attr[i]);
				self thread ai_floodspawn_think();
		}
		else if(tolower(attr[i]) == "forcespawn")
		{
			self.forcespawn	= 1;
		}
		else if(tolower(attr[i]) == "nobackup")
		{
			self.no_check_wave = true;
		}
	}
}

ai_nodebeforecolor_think()
{
	node = getnode(self.target, "targetname");
	if(!isdefined(node))
		return;
	
	self endon("death");
	
	while(1)
	{
		self waittill("spawned", guy);
		if(spawn_failed(guy))
			continue;
		
		break;
	}
	
	wait .05;
	guy setgoalnode(node);
	
	if(isdefined(node.radius))
		guy.goalradius = node.radius;
}

ai_floodspawn_think()
{
	self endon("death");
	while(1)
	{
		self waittill("spawned", guy);
		if(spawn_failed(guy))
			continue;
		
		self.FloodSpawnCount--;
		break;
	}
	while(self.FloodSpawnCount > 0)
	{
		guy waittill("death");
		
		self.count = 1;
		// soldier was deleted, not killed if this fails
		// so dont wait - go straight to spawning
		if ( isDefined( guy ) )
		{
			if ( !script_wait() )
				wait (randomFloatRange( 5, 9 ));
		}
		
		while(1)
		{
			if ( isDefined( self.forcespawn ) )
				guy = self stalingradSpawn();
			else
				guy = self doSpawn();
			
			if(!spawn_failed(guy))
			{
				self.FloodSpawnCount--;
				break;
			}
			wait (1);
		}
	}
	waittillframeend;
	self delete();
}

ai_magicbulletshield_think()
{
	self endon("death");
	while(1)
	{
		self waittill("spawned", guy);
		if(spawn_failed(guy))
			continue;
		
		if(isdefined(self.stopBulletShieldTime))
			guy.stopBulletShieldTime = self.stopBulletShieldTime;
		else if(isdefined(self.stopBulletShieldNotifyMsg))
		{
			guy.stopBulletShieldNotifyEnt = self.stopBulletShieldNotifyEnt;
			guy.stopBulletShieldNotifyMsg = self.stopBulletShieldNotifyMsg;
		}	
		else
			assertMsg ("spawner with targetname "+ self.targetname + "has incorrect script_parameters set: correct syntax is magicbulletshield: <time> / or magicbulletshield: <ent> <notify>");
		
		guy thread ai_magicbulletshield_think2();
	}
}

ai_magicbulletshield_think2()
{
	self endon("death");
	self endon ("internal_stop_magic_bullet_shield");
	self thread magic_bullet_shield();
	
	if(isdefined(self.stopForceGoalTime))
	{
		wait(self.stopForceGoalTime);
	}
	else 
	if(isdefined(self.stopForceGoalNotifyMsg))
	{
		if(tolower(self.stopForceGoalNotifyEnt) == "self")
			self waittill(self.stopForceGoalNotifyMsg);
		else if(tolower(self.stopForceGoalNotifyEnt) == "level")
			level waittill(self.stopForceGoalNotifyMsg);
		else
			assertMsg ("spawner with targetname "+ self.targetname + "has invalid script_parameters set: valid entity notify params for magicbulletshield are 'self' and 'level'");
	}
	else
	{
		return;
	}
		
	self stop_magic_bullet_shield();
}

ai_setforcecolor_think()
{
	self endon("death");
	while(1)
	{
		self waittill("spawned", guy);
		if(spawn_failed(guy))
			continue;
			
		guy.setForceColorValue = self.setForceColorValue;
		
		if(isdefined(self.setForceColorTime))
			guy.setForceColorTime = self.setForceColorTime;
		else if(isdefined(self.setForceColorNotifyMsg))
		{
			guy.setForceColorNotifyEnt = self.setForceColorNotifyEnt;
			guy.setForceColorNotifyMsg = self.setForceColorNotifyMsg;
		}
		else
			assertMsg ("spawner with targetname "+ self.targetname + "has incorrect script_parameters set: correct syntax is setforcecolor: <time> / or setforcecolor: <ent> <notify>");
		
		guy thread ai_setforcecolor_think2();
	}
}

ai_setforcecolor_think2()
{
	self endon("death");
		
	if(isdefined(self.setForceColorTime))
		wait(self.setForceColorTime);
	else if(isdefined(self.setForceColorNotifyMsg))
	{
		if(tolower(self.setForceColorNotifyEnt) == "self")
			self waittill(self.setForceColorNotifyMsg);
		else if(tolower(self.setForceColorNotifyEnt) == "level")
			level waittill(self.setForceColorNotifyMsg);
		else
			assertMsg ("spawner with targetname "+ self.targetname + "has invalid script_parameters set: valid entity notify params for setforcecolor are 'self' and 'level'");
	}
	self set_force_color(self.setForceColorValue);
}

ai_setforcegoal_think()
{
	self endon("death");
	while(1)
	{
		self waittill("spawned", guy);
		if(spawn_failed(guy))
			continue;
		
		if(isdefined(self.stopForceGoalTime))
			guy.stopForceGoalTime = self.stopForceGoalTime;
		else if(isdefined(self.stopForceGoalNotifyMsg))
		{
			guy.stopForceGoalNotifyEnt = self.stopForceGoalNotifyEnt;
			guy.stopForceGoalNotifyMsg = self.stopForceGoalNotifyMsg;
		}	
		else
			assertMsg ("spawner with targetname "+ self.targetname + "has incorrect script_parameters set: correct syntax is setforcegoal: <time> / or setforcegoal: <ent> <notify>");
		
		guy thread ai_setforcegoal_think2();
	}
}

ai_setforcegoal_think2()
{
	self endon("death");
	self set_forcegoal();
	
	if(isdefined(self.stopForceGoalTime))
		wait(self.stopForceGoalTime);
	else if(isdefined(self.stopForceGoalNotifyMsg))
	{
		if(tolower(self.stopForceGoalNotifyEnt) == "self")
			self waittill(self.stopForceGoalNotifyMsg);
		else if(tolower(self.stopForceGoalNotifyEnt) == "level")
			level waittill(self.stopForceGoalNotifyMsg);
		else
			assertMsg ("spawner with targetname "+ self.targetname + "has invalid script_parameters set: valid entity notify params for setforcegoal are 'self' and 'level'");
	}
	self unset_forcegoal();
}

ai_ignoreme_think()
{
	self endon("death");
	while(1)
	{
		self waittill("spawned", guy);
		if(spawn_failed(guy))
			continue;
		
		if(isdefined(self.stopIgnoreTime))
			guy.stopIgnoreTime = self.stopIgnoreTime;
		else if(isdefined(self.stopIgnoreNotifyMsg))
		{
			guy.stopIgnoreNotifyEnt = self.stopIgnoreNotifyEnt;
			guy.stopIgnoreNotifyMsg = self.stopIgnoreNotifyMsg;
		}	
		else
			assertMsg ("spawner with targetname "+ self.targetname + "has incorrect script_parameters set: correct syntax is ignoreme: <time> / or ignoreme: <ent> <notify>");
		
		guy thread ai_ignoreme_think2();
	}
}

ai_ignoreme_think2()
{
	self endon("death");
	self.ignoreme = true;
	
	if(isdefined(self.stopIgnoreTime))
		wait(self.stopIgnoreTime);
	else if(isdefined(self.stopIgnoreNotifyMsg))
	{
		if(tolower(self.stopIgnoreNotifyEnt) == "self")
			self waittill(self.stopIgnoreNotifyMsg);
		else if(tolower(self.stopIgnoreNotifyEnt) == "level")
			level waittill(self.stopIgnoreNotifyMsg);
		else
			assertMsg ("spawner with targetname "+ self.targetname + "has invalid script_parameters set: valid entity notify params for ignoreme are 'self' and 'level'");
	}
	self.ignoreme = false;
}

/************************************************************************************************************************************/
/************************************************************************************************************************************/
/*                  		                   FRIENDLY REINFORCEMENTS LOGIC														*/
/************************************************************************************************************************************/
/************************************************************************************************************************************/
friendly_main()
{
	level.friendly_globals = spawnstruct();
	level.friendly_globals.max_num = 4;
	level.friendly_globals.wav_num = 2;
	level.friendly_globals.cur_num = 0;
	level.friendly_globals.force_this_color = [];
		
	triggers = getentarray("friendly_spawner", "script_noteworthy");
	array_thread(triggers, ::friendly_trigger_think);
	
	thread friendly_logic();
}

friendly_logic()
{
	while(1)
	{
		level waittill("friendly_globals_check_wave");
		
		num = level.friendly_globals.max_num - level.friendly_globals.cur_num;
		
		if( num < level.friendly_globals.wav_num && !( (isdefined(level.fastrope_globals.heli_inflight)) && level.fastrope_globals.heli_inflight == true ) )
			continue;
		
		for(i=0; i<num; i++)
		{
			spawner = level.friendly_globals.curr_trigger friendly_cycle_spawner();
			spawner thread friendly_spawner_think();
		}			
	}
}

friendly_cycle_spawner()
{
	start_index = self.spawner_index;
	
	while(1)
	{
		self.spawner_index++;
		if(self.spawner_array.size == self.spawner_index)
			self.spawner_index = 0;
		
		if(!level.friendly_globals.force_this_color.size)
			break;
		
		if(self.spawner_array[self.spawner_index] check_force_color(level.friendly_globals.force_this_color[level.friendly_globals.force_this_color.size-1]) )
		{
			level.friendly_globals.force_this_color = array_remove(level.friendly_globals.force_this_color, level.friendly_globals.force_this_color[level.friendly_globals.force_this_color.size-1]);
			break;	
		}
		
		if(start_index == self.spawner_index)
		{
			self.spawner_index++;
			if(self.spawner_array.size == self.spawner_index)
				self.spawner_index = 0;
			break;
		}
	}
	
	return self.spawner_array[self.spawner_index];
}

friendly_spawner_think()
{	
	self endon("death");
	self.count = 1;
		
	guy = self dospawn();
	if (spawn_failed(guy))
		return;
	
	level.friendly_globals.cur_num++;
	
	if(isdefined(self.script_noteworthy))
	{
		if(self.script_noteworthy == "repel_friendlies")
		{
			node = getstruct(self.targetname, "target");
			guy thread friendly_repel_spawner_think(node);
		}
	}
	self thread friendly_spawner_death(guy);
	return guy;
}

friendly_spawner_death(guy)
{
	self endon("death");
	guy waittill_any("death", "get_off_friendly_logic");
	if(isdefined(self.force_this_color))
		level.friendly_globals.force_this_color[level.friendly_globals.force_this_color.size] = self.force_this_color;
	
	level.friendly_globals.cur_num--;
	if(isdefined(self.no_check_wave))
		return;
	level notify("friendly_globals_check_wave");
}

#using_animtree("generic_human");
friendly_repel_animload()
{
	if(isdefined(level.global_repel_anims_loaded))
		return;
		
	level.scr_anim["repel_friendly"]["rappel"]			= %rappel;
	level.scr_anim["repel_friendly"]["aim"][0]			= %stand_aim_straight;
	
	level.global_repel_anims_loaded = true;
}

friendly_repel_spawner_think(node)
{
	self endon("death");
				
	self.animname = "repel_friendly";
	
	self thread anim_loop_solo(self, "aim", undefined, "stop_aim");
	wait randomfloat(1);
	self notify("stop_aim");
	
	node thread anim_single_solo (self, "rappel");
}

friendly_force_spawner_think(trigger)
{	
	while(1)
	{
		trigger waittill("trigger");
		self thread friendly_spawner_think();
	}
}

friendly_trigger_think()
{
	//grab the friendlies who target this trigger
	self.spawner_array = getentarray(self.targetname, "target");
	self.spawner_index = 0;
	
	//find out if any of the friendlies have special attributes
	for(i=0; i < self.spawner_array.size; i++)
	{
		if(isdefined(self.spawner_array[i].script_parameters))
		{
			attr = strtok( self.spawner_array[i].script_parameters, ":;, " );
			for(j=0; j<attr.size; j++)
			{
				if(tolower(attr[j]) == "force_friendlies")
					self.spawner_array[i] thread friendly_force_spawner_think(self);
				if(tolower(attr[j]) == "force_this_color")
				{
					j++;
					self.spawner_array[i].force_this_color = attr[j];
				}
			}	
		}
		if(isdefined(self.spawner_array[i].script_noteworthy) && self.spawner_array[i].script_noteworthy == "repel_friendlies")	
			friendly_repel_animload();
	}
	
	//grab the spawn wave attributes for this trigger
	self.max_num = self.spawner_array.size;
	self.wav_num = 0;
	
	if(isdefined(self.script_parameters))
	{	
		attr = strtok( self.script_parameters, ", " );
		switch(attr.size)
		{
			case 2:
				self.max_num = int(attr[1]);
			case 1:
				self.wav_num = int(attr[0]);	
		}
	}
	//when it's triggered, set the global friendly params
	while(1)
	{
		self waittill("trigger");
		//dont process unless it's a different trigger
		if(isdefined(level.friendly_globals.curr_trigger))
			level.friendly_globals.curr_trigger trigger_on();
		level.friendly_globals.curr_trigger = self;
			
		if(self.max_num > 0)
			level.friendly_globals.max_num = self.max_num;
		if(self.wav_num > 0)
			level.friendly_globals.wav_num = self.wav_num;
		
		level notify("friendly_globals_check_wave");
		
		self trigger_off();
	}
}


/************************************************************************************************************************************/
/************************************************************************************************************************************/
/*                  		                 	  	TEMP BREAKABLES LOGIC															*/
/************************************************************************************************************************************/
/************************************************************************************************************************************/
interactive_main()
{
	crates = getentarray("crate_breakable", "targetname");
	crates thread interactive_precacheFX();
	array_thread(crates, ::interactive_cratethink);
	
	cardboardbox = getentarray("interactive_cardboard_box", "targetname");
	cardboardbox thread interactive_precacheFX();
	array_thread(cardboardbox, ::interactive_cardboardboxthink);
	
	walls = getentarray("wall_breakable","targetname");
	walls thread interactive_precacheFX();
	array_thread(walls, ::interactive_wallthink);
	
	fence = getentarray("fence_shootable", "targetname");
	fence thread interactive_precacheFX();
	array_thread(fence, ::interactive_fencethink);
}

interactive_precacheFX()
{	
	if(!self.size)
		return;
	if(self[0].targetname == "crate_breakable")
	{	
		level._effect["exp_crate1"]			= loadfx("props/crateExp_dust");  
		level._effect["exp_crate2"]			= loadfx("props/crateExp_ammo");
		return;	
	}
	if(self[0].targetname == "wall_breakable")
	{
		level._effect["exp_wall"]			= loadfx("props/wallExp_concrete");
		return;	
	}
	if(self[0].targetname == "fence_shootable")
	{
		level._effect["fence"]				= loadfx("impacts/small_metalhit_1"); 
		return;	
	}	
}

interactive_fencethink()
{
	self setcandamage(true);
	while(1)
	{
		self waittill("damage", damage, other, direction_vec, P );
		name = undefined;
		start = P + vector_multiply(direction_vec, 1);
		end = P + vector_multiply(direction_vec, 1024);
		magicbullet("mp5", start, end);
		playfx( level._effect["fence"], P, vector_multiply(direction_vec, -1));	
	}
}

interactive_wallthink()
{
	self setcandamage(true);
	vec = undefined;
	node = undefined;
	
	//if we have an axis node - then calculate the direction of the fx based on that
	if(isdefined(self.target))
	{
		node = getent(self.target, "targetname");
		if(isdefined(node.script_noteworthy) && node.script_noteworthy == "doorframe")
		{
			P = self getorigin();
			N = undefined;
			
			if(distance(P, node.origin) < node.radius)
				N = node.origin;
			else
			{
				//reposition our virtual node on the otherside of the frame
				vec = anglesToForward (node.angles);
				vec1 = vector_multiply(vec, 88);
				N = node.origin + vec1;
			}
			
			vec = anglestoup(node.angles);
			vec1 = vector_multiply(vec, 64);
			A = N + vec1;
			vec1 = vector_multiply(vec, -64);
			B = N + vec1;
					
			//calculate the vector derived from the center line of our wall and the point of break
			vec = vectorFromLineToPoint(A, B, P);
		}
		if(isdefined(node.script_noteworthy) && node.script_noteworthy == "windowframe")
		{
			P = self getorigin();
			N = undefined;
			
			if(distance(P, node.origin) < node.radius)
				N = node.origin;
			else
			{
				//reposition our virtual node on the otherside of the frame
				vec = anglesToForward (node.angles);
				vec1 = vector_multiply(vec, 72);
				N = node.origin + vec1;
			}
			
			vec = anglestoup(node.angles);
			vec1 = vector_multiply(vec, 64);
			A = N + vec1;
			vec1 = vector_multiply(vec, -64);
			B = N + vec1;
					
			//calculate the vector derived from the center line of our wall and the point of break
			vec = vectorFromLineToPoint(A, B, P);
		}
		else
		{
			A = node.origin;
			vec = anglesToForward (node.angles);
			vec = vector_multiply(vec, 128);
			B = A+vec;
			
			P = self getorigin();
			
			//calculate the vector derived from the center line of our wall and the point of break
			vec = vectorFromLineToPoint(A, B, P);
		}
	}
	
	wait .1;
	if(isdefined(node))
		node delete();
		
	self waittill("damage", damage, other, direction_vec, P );
	self delete();	
	
	if(isdefined(vec))
		playfx ( level._effect["exp_wall"], P, vec);	
	else
		playfx ( level._effect["exp_wall"], P);	
	thread play_sound_in_space("stone_wall_impact_med", P);
}

interactive_cardboardboxthink()
{
	self setcandamage(true);
	
	up = (0,0,1);
	time = 5;
	
	while(1)
	{
		self waittill("damage", damage, other, direction_vec, P, type );
		
		if(type == "MOD_MELEE" || type == "MOD_IMPACT")
			continue;
		ang = anglestoright(vectortoangles(direction_vec));
		up = vector_multiply(up, randomfloatrange(400,600)); 
		//vec = vector_multiply(ang, (randomfloat(1) - .5));
		vec = direction_vec;
		vec = vector_multiply(vec, 1.5);//(damage * randomfloatrange(2, 4)) ); 
		vec += up; 
		impact =  vector_multiply( (P - self.origin), .25);
		
		self physicsLaunch( (self.origin + impact) , vec);
		
		break;
	}
	
	//self delete();
}

interactive_cratethink()
{
	self setcandamage(true);
	
	if(isdefined(self.target))
	{
		self.debri = getent(self.target, "targetname");	
		self.debri hide();
	}	
	
	self waittill("damage", damage, ent);//, direction_vec, P );
	
	if(isdefined(self.debri))
		self.debri show();
		
	x = randomint(5);
	if(x>0)
		playfx(level._effect["exp_crate1"], self.origin);
	else
		playfx(level._effect["exp_crate2"], self.origin);
	thread play_sound_in_space("wood_crate_break_med", self.origin);
		
	others = getentarray("crate_breakable","targetname");
	for (i=0;i<others.size;i++)
	{
		other = others[i];	
		//see if it's within 40 units from this box on X or Y
		diffX = abs(self.origin[0] - other.origin[0]);
		diffY = abs(self.origin[1] - other.origin[1]);
		
		if ( (diffX <= 20) && (diffY <= 20) )
		{
			//see if it's above the box (would probably be resting on it)
			diffZ = (self.origin[2] - other.origin[2]);
			if (diffZ <= 0)
				other notify ("damage", damage, ent);
		}
	}

	self delete();	
}

/************************************************************************************************************************************/
/************************************************************************************************************************************/
/*                  		                 			  MISC LEVEL LOGIC															*/
/************************************************************************************************************************************/
/************************************************************************************************************************************/

misc_main()
{
	saves = getentarray("autosave", "targetname");
	array_thread(saves, ::auto_save_think);
	bombs = getentarray("wall_breach_check", "targetname");
	if(bombs.size)
	{
		precacheShader("hudStopwatch");
		precacheShader("hudStopwatchNeedle");
		precacheShader("objective");	
	}
	array_thread(bombs, ::wall_breach_think);
	level.scr_anim["player_link"]["loop"][0]				= %bh_fastrope_loop;
	level.scr_anim["player_link"]["land"]					= %bh_fastrope_land;
}

auto_save_think()
{
	self waittill("trigger");
	if(isdefined(self.script_noteworthy))
		autosave_by_name(self.script_noteworthy);
	else
		autosave_by_name("default");
}

wall_breach_think()
{
	struct = spawnstruct();
	
	struct.on 		= self;
	struct.off		= getent(struct.on.target, "targetname");
	struct.obj_glow	= getentarray(struct.off.target, "targetname");
	struct.obj_mdl 	= getentarray(struct.obj_glow[0].target, "targetname");
	struct.use_trig = getentarray(struct.obj_mdl[0].target, "targetname");
	struct.whole	= getent(struct.use_trig[0].target, "targetname");
	struct.broken	= getent(struct.whole.target, "targetname");
	if(isdefined(struct.broken.target))
	struct.chain 	= getent(struct.broken.target, "targetname");
	
	struct.obj_glow[0] hide();	struct.obj_glow[1] hide();
	struct.obj_mdl[0] hide();	struct.obj_mdl[1] hide();
	struct.broken hide();
	struct.whole disconnectpaths();
	
	struct.use_trig[0].time = 4;
	struct.use_trig[0] setHintString(level.strings["hint_detpack"]);	struct.use_trig[1] setHintString(level.strings["hint_detpack"]);
	
	struct endon("used");
	struct thread wall_breach_think2();
	while(1)
	{
		struct.on waittill("trigger");
		struct notify("on");
		struct.obj_glow[0] show();	struct.obj_glow[1] show();
		
		struct.off waittill("trigger");
		struct notify("off");
		struct.obj_glow[0] hide();	struct.obj_glow[1] hide();
	}
}

wall_breach_think2()
{
	//self endon("off");
	
	array_wait(self.use_trig, "trigger", 0);
	
	//self.use_trig waittill("trigger", ent);
	//if(!isdefined(ent) || ent != level.player)
	//self.use_trig[0].time = 2;
	self notify("used");
		
	self.use_trig[0] trigger_off();	self.use_trig[1] trigger_off();
	self.obj_glow[0] delete();	self.obj_glow[1] delete();
	self.obj_mdl[0] show();		self.obj_mdl[1] show();
	
	if(isdefined(self.use_trig[0].jumptoRandomType) || isdefined(self.use_trig[1].jumptoRandomType))
	{
		self.whole 		delete();
		self.broken 	show();
		if (self.broken.spawnflags & 1)
			self.broken disconnectpaths();
		return;	
	}
	//show stopwatch
	self.obj_mdl[0] playLoopSound("bomb_tick");
	timer = get_stop_watch(60,self.use_trig[0].time);
	wait ( self.use_trig[0].time * .5 );
	thread play_sound_in_space(level.level_name + "_ge1_fireinhole", (self.on getorigin()));
	wait ( self.use_trig[0].time * .5 );
	self.obj_mdl[0] stopLoopSound( "bomb_tick" );
	timer destroy();

	playfx(level._effect["exp_breach"], self.obj_mdl[0].origin);
	thread play_sound_in_space("detpack_explo_concrete", self.obj_mdl[0].origin);
			/*
			detpack_explo_metal
			detpack_explo_wood
			*/

	self.use_trig[0] delete();	self.use_trig[1] delete();
	self.whole 		delete();
	self.obj_mdl[0] delete();	self.obj_mdl[1] delete();
	self.broken 	show();
	if (self.broken.spawnflags & 1)
		self.broken disconnectpaths();
	self.on			delete();
	self.off 		delete();
	
	if(!isdefined(self.chain))
		return;
		
	wait(.5);
	self.chain notify("trigger");
}