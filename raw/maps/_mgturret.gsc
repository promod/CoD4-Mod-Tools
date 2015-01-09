#include maps\_utility;
#include common_scripts\utility;
#using_animtree("generic_human");

init_mgTurretsettings()
{
	level.mgTurretSettings["easy"]["convergenceTime"] = 2.5;
	level.mgTurretSettings["easy"]["suppressionTime"] = 3.0;
	level.mgTurretSettings["easy"]["accuracy"] = 0.38;
	level.mgTurretSettings["easy"]["aiSpread"] = 2;
	level.mgTurretSettings["easy"]["playerSpread"] = 0.5;	

	level.mgTurretSettings["medium"]["convergenceTime"] = 1.5;
	level.mgTurretSettings["medium"]["suppressionTime"] = 3.0;
	level.mgTurretSettings["medium"]["accuracy"] = 0.38;
	level.mgTurretSettings["medium"]["aiSpread"] = 2;
	level.mgTurretSettings["medium"]["playerSpread"] = 0.5;	

	level.mgTurretSettings["hard"]["convergenceTime"] = .8;
	level.mgTurretSettings["hard"]["suppressionTime"] = 3.0;
	level.mgTurretSettings["hard"]["accuracy"] = 0.38;
	level.mgTurretSettings["hard"]["aiSpread"] = 2;
	level.mgTurretSettings["hard"]["playerSpread"] = 0.5;	

	level.mgTurretSettings["fu"]["convergenceTime"] = .4;
	level.mgTurretSettings["fu"]["suppressionTime"] = 3.0;
	level.mgTurretSettings["fu"]["accuracy"] = 0.38;
	level.mgTurretSettings["fu"]["aiSpread"] = 2;
	level.mgTurretSettings["fu"]["playerSpread"] = 0.5;	
}

main()
{
	if ( getDvar( "mg42" ) == "" )
		setDvar( "mgTurret", "off" );
		
	level.magic_distance = 24;

	turretInfos = getEntArray( "turretInfo", "targetname" );
	for ( index = 0; index < turretInfos.size; index++ )
		turretInfos[index] delete();
}

portable_mg_behavior()
{
	// turret guys have the turret attached to precache it. This'll have to
	// support allied guns or different guns as we add more, but right now
	// it can be generic
	self detach( "weapon_mg42_carry", "tag_origin" );
	self endon( "death" );

	// first set his goalpos and goalradius
	self.goalradius = level.default_goalradius;
	if ( isdefined( self.target ) )
	{
		node = getnode( self.target, "targetname" );
		if ( isdefined( node ) )
		{
			if ( isdefined( node.radius ) )
				self.goalradius = node.radius;
				
			self setgoalnode( node );
		}
	}
	
	while( !isdefined( self.node ) )
	{
		// wait until the AI picks a node to run to
		wait( 0.05 );
	}

	// try to find a turret to run to
	
	// first try the node we're targetted to
	turret_node = undefined;
	if ( isdefined( self.target ) )
	{
		node = getnode( self.target, "targetname" );
		turret_node = node;
	}
	
	// next try the node we're going to, maybe its a turret node
	if ( !isdefined( turret_node ) )
	{
		turret_node = self.node;
	}

	// just be a normal guy if we're not going to a turret node
	if ( !isdefined( turret_node ) )
	{
		return;
	}
	
	if ( turret_node.type != "Turret" )
		return;
	
	taken_nodes = getTakenNodes();
	taken_nodes[ self.node.origin + "" ] = undefined; // clear our own node since its taken by us

	// some random AI has this node already, probably doing cover there
	if ( isdefined( taken_nodes[ turret_node.origin + "" ] ) )
		return;

	turret = turret_node.turret;
	
	if ( isdefined( turret.reserved ) )
	{
		assert( turret.reserved != self );
		return;
	}
		
	reserve_turret( turret );
	
	// we're not at the turret position so we have to run to it
	if ( turret.isSetup )
	{
		// its already setup so just go there and use it
		leave_gun_and_run_to_new_spot( turret );
	}
	else
	{
		// its not setup yet so go there and set it up then use it
		run_to_new_spot_and_setup_gun( turret );
	}
		
	maps\_mg_penetration::gunner_think( turret_node.turret );
}




mg42_trigger()
{
	self waittill ("trigger");
	level notify (self.targetname);
	level.mg42_trigger[self.targetname] = true;
//	println ("trigger at ", self getorigin()," was triggered");
	self delete();
}

mgTurret_auto(trigger)
{
	trigger waittill ("trigger");
	ai = getaiarray("axis");
	for (i=0;i<ai.size;i++)
	{
		if ((isdefined (ai[i].script_mg42auto)) && (trigger.script_mg42auto == ai[i].script_mg42auto))
		{
			ai[i] notify ("auto_ai");
			println ("^a ai auto on!");
		}
	}

	spawners = getspawnerarray();
	for (i=0;i<spawners.size;i++)
	if ((isdefined (spawners[i].script_mg42auto)) && (trigger.script_mg42auto == spawners[i].script_mg42auto))
	{
		spawners[i].ai_mode = "auto_ai";
		println ("^aspawner ", i," set to auto");
	}
		
	maps\_spawner::kill_trigger( trigger );
}

mg42_suppressionFire(targets)
{
	self endon("death");
	self endon("stop_suppressionFire");
	if (!isdefined (self.suppresionFire))
		self.suppresionFire = true;
	
	for (;;)
	{
		while(self.suppresionFire)
		{
			self settargetentity(targets[randomint(targets.size)]);
			wait (2 + randomfloat(2));
		}
		
		self cleartargetentity();
		while(!self.suppresionFire)
			wait 1;
	}
}

manual_think(mg42) // For regular spawned guys that are told to use mg42s manually vs static target
{
	org = self.origin;
	self waittill ("auto_ai");
	mg42 notify ("stopfiring");
	mg42 setmode("auto_ai"); // auto, auto_ai, manual
	mg42 settargetentity(level.player);
	/*
	mg42 setmode("auto_ai"); // auto, auto_ai, manual
	self useturret(mg42); // dude should be near the mg42
	self.favoriteEnemy = level.player;
//	self doDamage ( 25, self.origin );
	*/
}

burst_fire_settings(setting)
{
	if (setting == "delay")
		return 0.2;
	else
	if (setting == "delay_range")
		return 0.5;
	else
	if (setting == "burst")
		return 0.5;
	else
//	if (setting == "burst_range")
		return 1.5;
}

burst_fire_unmanned()
{
	self endon("death");
	if (isdefined (self.script_delay_min))
		mg42_delay = self.script_delay_min;
	else
		mg42_delay = burst_fire_settings ("delay");

	if (isdefined (self.script_delay_max)) 
		mg42_delay_range = self.script_delay_max - mg42_delay;
	else
		mg42_delay_range = burst_fire_settings ("delay_range");

	if (isdefined (self.script_burst_min))
		mg42_burst = self.script_burst_min;
	else
		mg42_burst = burst_fire_settings ("burst");

	if (isdefined (self.script_burst_max)) 
		mg42_burst_range = self.script_burst_max - mg42_burst;
	else
		mg42_burst_range = burst_fire_settings ("burst_range");

	pauseUntilTime = gettime();
	turretState = "start";

	for (;;)
	{
		duration = (pauseUntilTime - gettime()) * 0.001;
		if (self isFiringTurret() && (duration <= 0))
		{
			if (turretState != "fire")
			{
				turretState = "fire";

//				self setAnimKnobRestart(%standMG42gun_fire_foward);

				thread DoShoot();
			}

			duration = mg42_burst + randomfloat(mg42_burst_range);

			//println("fire duration: ", duration);
			thread TurretTimer(duration);

			self waittill("turretstatechange"); // code or script

			duration = mg42_delay + randomfloat(mg42_delay_range);
			//println("stop fire duration: ", duration);

			pauseUntilTime = gettime() + int(duration * 1000);
		}
		else
		{
			if (turretState != "aim")
			{
				turretState = "aim";

//				self setAnimKnobRestart(%standMG42gun_aim_foward);
			}
			
			//println("aim duration: ", duration);
			thread TurretTimer(duration);

			self waittill("turretstatechange"); // code or script
		}
	}
}

DoShoot()
{
	self endon("death");
	self endon("turretstatechange"); // code or script

	for (;;)
	{
		self ShootTurret();
		wait 0.1;
	}
}

TurretTimer(duration)
{
	if (duration <= 0)
		return;

	self endon("turretstatechange"); // code

	//println("start turret timer");

	wait duration;
	if (isdefined(self))
		self notify("turretstatechange");

	//println("end turret timer");
}

random_spread(ent)
{
	self endon("death");

	self notify ("stop random_spread");
	self endon ("stop random_spread");
	
	self endon ("stopfiring");
	self settargetentity(ent);
	
	while (1)
	{
		if (ent == level.player)
			ent.origin = self.manual_target getorigin();
		else
			ent.origin = self.manual_target.origin;

		ent.origin += (20 - randomfloat (40), 20 - randomfloat (40), 20 - randomfloat (60));
		wait (0.2);
	}
}

mg42_firing( mg42 )
{
	self notify( "stop_using_built_in_burst_fire" );
	self endon( "stop_using_built_in_burst_fire" );

	mg42 stopfiring();
	
	while (1)
	{
		mg42 waittill ("startfiring");
		self thread burst_fire( mg42 );
		mg42 startfiring();

		mg42 waittill ("stopfiring");
		mg42 stopfiring();
	}
}


burst_fire( mg42, manual_target )
{
	mg42 endon ("stopfiring");
	self endon( "stop_using_built_in_burst_fire" );


	if (isdefined (mg42.script_delay_min))
		mg42_delay = mg42.script_delay_min;
	else
		mg42_delay = maps\_mgturret::burst_fire_settings ("delay");

	if (isdefined (mg42.script_delay_max)) 
		mg42_delay_range = mg42.script_delay_max - mg42_delay;
	else
		mg42_delay_range = maps\_mgturret::burst_fire_settings ("delay_range");

	if (isdefined (mg42.script_burst_min))
		mg42_burst = mg42.script_burst_min;
	else
		mg42_burst = maps\_mgturret::burst_fire_settings ("burst");

	if (isdefined (mg42.script_burst_max)) 
		mg42_burst_range = mg42.script_burst_max - mg42_burst;
	else
		mg42_burst_range = maps\_mgturret::burst_fire_settings ("burst_range");

	while (1)
	{	
		mg42 startfiring();

		if (isdefined (manual_target))
			mg42 thread random_spread (manual_target);
			
		wait (mg42_burst + randomfloat(mg42_burst_range));

		mg42 stopfiring();

		wait (mg42_delay + randomfloat(mg42_delay_range));
	}
}



_spawner_mg42_think ()
{
	if (!isdefined (self.flagged_for_use))
		self.flagged_for_use = false;

	if (!isdefined (self.targetname))
		return;

	node = getnode (self.targetname,"target");
	if (!isdefined (node))
		return;

	if (!isdefined (node.script_mg42))
		return;

	if (!isdefined (node.mg42_enabled))
		node.mg42_enabled = true;

	self.script_mg42 = node.script_mg42;

	first_run = true;
	while (1)
	{
		if (first_run)
		{
			first_run = false;

			if ((isdefined (node.targetname)) || (self.flagged_for_use))
				self waittill ("get new user");
		}

		if (!node.mg42_enabled)
		{
			node waittill ("enable mg42");
			node.mg42_enabled = true;
		}

		excluders = [];
		ai = getaiarray();
		for (i=0;i<ai.size;i++)
		{
			excluded = true;
			if ((isdefined (ai[i].script_mg42)) && (ai[i].script_mg42 == self.script_mg42))
				excluded = false;

			if (isdefined (ai[i].used_an_mg42))
				excluded = true;
				
			if (excluded)
				excluders[excluders.size] = ai[i];
		}

		if (excluders.size)
			ai = maps\_utility::get_closest_ai_exclude (node.origin, undefined, excluders);
		else
			ai = maps\_utility::get_closest_ai (node.origin, undefined);
		excluders = undefined;

		if (isdefined (ai))
		{
			ai notify ("stop_going_to_node");
			ai thread maps\_spawner::go_to_node (node);
			ai waittill ("death");
		}
		else
			self waittill ("get new user");
	}
}

mg42_think()
{		
	if (!isdefined (self.ai_mode))
		self.ai_mode = "manual_ai";
		
	node = getnode(self.target, "targetname");
	if (!isdefined (node))
	{
		println ("Guy at org ", self.origin," had no node");
		return;
	}
	mg42 = getent(node.target, "targetname");
	mg42.org = node.origin;
	
	if (isdefined (mg42.target))
	{
		if ((!isdefined (level.mg42_trigger)) || (!isdefined (level.mg42_trigger[mg42.target])))
		{
			level.mg42_trigger[mg42.target] = false;
			getent (mg42.target, "targetname") thread mg42_trigger();
		}
		trigger = true;
	}
	else
		trigger = false;

	while (1)
	{		
		if (self.count == 0)
			return;

		mg42_gunner = undefined;			
		while (!isdefined (mg42_gunner))
		{
			mg42_gunner = self dospawn();
			wait (1);
		}
		
//		println ("gunner thinking");

		mg42_gunner thread mg42_gunner_think (mg42, trigger, self.ai_mode);
		mg42_gunner thread mg42_firing(mg42);
		
		mg42_gunner waittill ("death");
//		println ("gunner thought");
		if (isdefined (self.script_delay))
			wait (self.script_delay);
		else
		if ((isdefined (self.script_delay_min)) && (isdefined (self.script_delay_max)))
			wait (self.script_delay_min + randomfloat (self.script_delay_max - self.script_delay_min));
		else
			wait (1);
	}
}

kill_objects (owner, msg, temp1, temp2)
{
	owner waittill (msg);
	if (isdefined (temp1))
		temp1 delete();
		
	if (isdefined (temp2))
		temp2 delete();
}

mg42_gunner_think (mg42, trigger, ai_mode)
{
	self endon ("death");

	if (ai_mode == "manual_ai")
	{
		while (1)
		{
			self thread mg42_gunner_manual_think (mg42, trigger);
			self waittill ("auto_ai");			
			self move_use_turret (mg42, "auto_ai"); // was setmode("auto_ai") and cleartargetentity()
			self waittill ("manual_ai");
		}
	}
	else
	{
		while (1)
		{
			self move_use_turret (mg42, "auto_ai", level.player); // was setmode("auto_ai") and settargetentity(level.player)
			self waittill ("manual_ai");
			self thread mg42_gunner_manual_think (mg42, trigger);
			self waittill ("auto_ai");
		}
	}
}

player_safe()
{
	if (!isdefined (level.player_covertrigger))
		return false;

	if (level.player getstance() == "prone")
		return true;

	if ((level.player_covertype == "cow") && (level.player getstance() == "crouch"))
		return true;

	return false;
}

stance_num ()
{
	if (level.player getstance() == "prone")
		return (0,0,5);
	else
	if (level.player getstance() == "crouch")
		return (0,0,25);
	
	return (0,0,50);
}

mg42_gunner_manual_think(mg42, trigger)
{
	self endon ("death");
	self endon ("auto_ai");

//	maps\_utility::debug_message ("MANUAL", self.origin);
	
	self.pacifist = true;
	self setgoalpos (mg42.org);
	self.goalradius = level.magic_distance;
	self waittill ("goal");

	if (trigger)
	{
		if (!level.mg42_trigger[mg42.target])
			level waittill (mg42.target);
	}
	
	self.pacifist = false;
	
//	mg42 setmode("manual_ai"); // auto, auto_ai, manual
	mg42 setmode("auto_ai"); // auto, auto_ai, manual
	mg42 cleartargetentity();
	targ_org = spawn ("script_origin", (0,0,0));

	tempmodel = spawn ("script_model", (0, 0, 0));
	tempmodel.scale = 3;
	if (getdvar("mg42") != "off")
	tempmodel setmodel ("temp");
	tempmodel thread temp_think(mg42, targ_org);
	level thread kill_objects(self, "death", targ_org, tempmodel);
	level thread kill_objects(self, "auto_ai", targ_org, tempmodel);
	
	mg42.player_target = false;
	mg42timer = 0;
	targets = getentarray ("mg42_target","targetname");

	if (targets.size > 0)
	{
		script_targets = true;
		current_org = targets[randomint (targets.size)].origin;
		
		self thread shoot_mg42_script_targets(targets);
		self move_use_turret (mg42);
		self.target_entity = targ_org;
		mg42 setmode("manual_ai"); // auto, auto_ai, manual
		mg42 settargetentity(targ_org);
		mg42 notify ("startfiring");
		 
		mindist = 15;
		wait_time = 0.08; // 2.8 / 20;
		dif = 0.05; // 1 / 20;
//		player_safe_time = gettime() + 5500 + randomfloat (5000);
		targ_org.origin = targets[randomint (targets.size)].origin;

		shoot_timer = 0;
//		while (gettime() < player_safe_time)
			
		while (!isdefined (level.player_covertrigger))
		{
			current_org = targ_org.origin;
			if (distance (current_org, targets[self.gun_targ].origin) > mindist)
			{
				temp_vec = vectornormalize (targets[self.gun_targ].origin - current_org);
				temp_vec = vectorScale (temp_vec, mindist);
				current_org += temp_vec;
			}
			else
				self notify ("next_target");

			targ_org.origin = current_org;

			wait (0.1);
		}
		
		while (1)
		{
			for (i=0;i<1;i+=dif)
			{
				targ_org.origin = vector_multiply (current_org, 1.0-i) + 
					vector_multiply (level.player getorigin() + stance_num(), i);

				if (player_safe())
					i = 2;
								
				wait (wait_time);
			}

			old_org = level.player getorigin();
			while (!player_safe())
			{
				targ_org.origin = level.player getorigin();
				vec_dif = targ_org.origin - old_org;
				targ_org.origin = targ_org.origin + vec_dif + stance_num();
				old_org = level.player getorigin();
				wait (0.1);
			}
	
			if (player_safe())
			{
				shoot_timer = gettime() + 1500 + randomfloat (4000);
				while ((player_safe()) && (isdefined (level.player_covertrigger.target)) && (gettime() < shoot_timer))
				{
					target = getentarray (level.player_covertrigger.target, "targetname");
					target = target[randomint(target.size)];
					targ_org.origin = target.origin + 
						(randomfloat (30) - 15, randomfloat (30) - 15, randomfloat (40) - 60);
						
					wait (0.1);
				}
			}

			self notify ("next_target");
			while (player_safe())
			{
				current_org = targ_org.origin;
				if (distance (current_org, targets[self.gun_targ].origin) > mindist)
				{
					temp_vec = vectornormalize (targets[self.gun_targ].origin - current_org);
					temp_vec = vectorScale (temp_vec, mindist);
					current_org += temp_vec;
				}
				else
					self notify ("next_target");

				targ_org.origin = current_org;

				wait (0.1);
			}
		}
	}
	else
	{
		while (1)
		{
			// Play is not safe, shoot player.
			self move_use_turret (mg42);
			while (!isdefined (level.player_covertrigger))
			{
				if (!mg42.player_target)
				{
					mg42 settargetentity(level.player);
					mg42.player_target = true;
	//				mg42 settargetentity(tempmodel);
					tempmodel.targent = level.player;
				}
				wait (0.2);
			}
			
			// Player is safe so shoot in front of him.
			mg42 setmode("manual_ai"); // auto, auto_ai, manual
			self move_use_turret (mg42);
			mg42 notify ("startfiring");
			shoot_timer = gettime() + 1500 + randomfloat (4000);
			while (shoot_timer > gettime())
			{
				if (isdefined (level.player_covertrigger))
				{
					target = getentarray (level.player_covertrigger.target, "targetname");
					target = target[randomint(target.size)];
					targ_org.origin = target.origin + 
						(randomfloat (30) - 15, randomfloat (30) - 15, randomfloat (40) - 60);
					mg42 settargetentity(targ_org);
					tempmodel.targent = targ_org;
					wait (randomfloat (1));
				}
				else
					break;
			}
			mg42 notify ("stopfiring");

			// Play is still safe, shoot friendlies.
			self move_use_turret (mg42);
			if (mg42.player_target)
			{
				mg42 setmode("auto_ai"); // auto, auto_ai, manual
				mg42 cleartargetentity();
				mg42.player_target = false;
				tempmodel.targent = tempmodel;
				tempmodel.origin = (0,0,0);
			}

			while (isdefined (level.player_covertrigger))
				wait (0.2);			
			
			wait (.750 + randomfloat (.200));
		}	
	}
}


shoot_mg42_script_targets(targets)
{
	self endon ("death");
	while (1)
	{
		targ_filled = [];
		for (i=0;i<targets.size;i++)
			targ_filled[i] = false;
			
		for (i=0;i<targets.size;i++)
		{
			self.gun_targ = randomint (targets.size);
			self waittill ("next_target");
			while (targ_filled[self.gun_targ])
			{
				self.gun_targ++;
				if (self.gun_targ >= targets.size)
					self.gun_targ = 0;
			}
			
			targ_filled[self.gun_targ] = true;
			
		}
	}
}	



move_use_turret(mg42, aitype, target)
{
	self setgoalpos (mg42.org);
	self.goalradius = level.magic_distance;
	self waittill ("goal");
	if (isdefined(aitype) && aitype == "auto_ai")
	{
		mg42 setmode("auto_ai");
		if (isdefined(target))
			mg42 settargetentity(target);
		else
			mg42 cleartargetentity();
	}
	self useturret(mg42); // dude should be near the mg42
}

temp_think(mg42, targ)
{
	if (getdvar("mg42") == "off")
		return;

	self.targent = self;
	while (1)
	{
		self.origin = targ.origin;		
		line (self.origin, mg42.origin, (0.2, 0.5, 0.8), 0.5);			
		wait (0.1);
	}
}

// This is a thread that runs for each turret managing AI users of the turret
turret_think( node )
{
	turret = getent(node.auto_mg42_target, "targetname");
	mintime = 0.5;
	if (isdefined (turret.script_turret_reuse_min))
		mintime = turret.script_turret_reuse_min;
	maxtime = 2;
	if (isdefined (turret.script_turret_reuse_max))
		mintime = turret.script_turret_reuse_max;
	assert (maxtime >= mintime);
	for(;;)
	{
		turret waittill( "turret_deactivate" );
		wait (mintime + randomfloat(maxtime - mintime)); // Wait for a bit before calling the next AI over.
		while( !(isturretactive(turret)) )
		{
			turret_find_user(node, turret);
			wait 1.0;
		}
	}
}

turret_find_user(node, turret)
{
	ai = getaiarray();	
	for(i=0;i<ai.size;i++)
	{
		if ( ai[i] isingoal(node.origin) && ai[i] canuseturret(turret) )
		{
			savekeepclaimed = ai[i].keepClaimedNodeInGoal;
			ai[i].keepClaimedNodeInGoal = false;
			if ( !(ai[i] usecovernode(node)) )
			{
				ai[i].keepClaimedNodeInGoal = savekeepclaimed;
			}
		}
	}
}

setDifficulty()
{
	init_mgTurretsettings();
	
	mg42s = getEntArray( "misc_turret", "classname" );
	
	difficulty = getdifficulty();
	
	for ( index = 0; index < mg42s.size; index++ )
	{
		if ( isdefined( mg42s[index].script_skilloverride ) )
		{
			switch( mg42s[index].script_skilloverride )
			{
				case "easy":
					difficulty = "easy";
					break;
				case "medium":
					difficulty = "medium";
					break;
				case "hard":
					difficulty = "hard";
					break;
				case "fu":
					difficulty = "fu";
					break;
				default:
					continue;
			}
		}
		mg42_setdifficulty (mg42s[index],difficulty);
	}
}

mg42_setdifficulty (mg42,difficulty)
{
		mg42.convergenceTime = level.mgTurretSettings[difficulty]["convergenceTime"];
		mg42.suppressionTime = level.mgTurretSettings[difficulty]["suppressionTime"];
		mg42.accuracy = level.mgTurretSettings[difficulty]["accuracy"];
		mg42.aiSpread = level.mgTurretSettings[difficulty]["aiSpread"];
		mg42.playerSpread = level.mgTurretSettings[difficulty]["playerSpread"];	
}


mg42_target_drones(nonai,team,fakeowner)
{
	if(!isdefined(fakeowner))
		fakeowner = false;
	self endon ("death");
	self.dronefailed = false;
	if(!isdefined(self.script_fireondrones))
		self.script_fireondrones = false;
	if(!isdefined(nonai))
		nonai = false;
	self setmode("manual_ai");
	difficulty = getdifficulty();
	if(!isdefined(level.drones))
		waitfornewdrone = true;
	else
		waitfornewdrone = false;
	while(1)
	{
		if(fakeowner && !isdefined(self.fakeowner))
		{
			self setmode("manual");
			while(!isdefined(self.fakeowner))
				wait .2;
			
		}
		else if(nonai)
			self setmode("auto_nonai");
		else
			self setmode("auto_ai");
		
		if(waitfornewdrone)
			level waittill ("new_drone");

		if(!isdefined(self.oldconvergencetime))
			self.oldconvergencetime = self.convergencetime;
		self.convergencetime = 2;

		if(!nonai)
		{
			turretowner = self getturretowner();
			if(!isalive(turretowner) || turretowner == level.player)
			{
				wait .05;
				continue;
			}
			else
				team = turretowner.team;
		}
		else
		{
			if(fakeowner && !isdefined(self.fakeowner))
			{
				wait .05;
				continue;
			}
			assert(isdefined(team));
			turretowner = undefined;
		}
		if(team == "allies")
			targetteam = "axis";
		else
			targetteam = "allies";

		while(level.drones[targetteam].lastindex)
		{
			//self gettagangles ("tag_flash")
			target = get_bestdrone(targetteam);
			if(!isdefined(self.script_fireondrones) || !self.script_fireondrones)
			{
				wait .2;
				break;
			}
			if(!isdefined(target))
			{
				wait .2;
				break;
			}
			if(nonai)	
				self setmode("manual");
			else
				self setmode("manual_ai");
				
			thread drone_fail(target,3);
			if(!self.dronefailed)
			{
				self settargetentity(target.turrettarget);
				self shootturret();
				self startfiring();
			}
			else
			{
				self.dronefailed = false;
				wait .05;
				continue;
				
			}
			target waittill_any ("death","drone_mg42_fail");
			waittillframeend;
			if(!nonai && !(isdefined(self getturretowner()) && self getturretowner() == turretowner))
				break;
		}
		self.convergencetime = self.oldconvergencetime;
		self.oldconvergencetime = undefined;
		self cleartargetentity();
		self stopfiring();
		if(level.drones[targetteam].lastindex)
			waitfornewdrone = false;
		else
			waitfornewdrone = true;
	}
}

drone_fail(drone,time)
{
	self endon ("death");
	drone endon ("death");
	timer=gettime()+(time*1000);
	while(timer > gettime())
	{
		turrettarget = self getturrettarget();
//		bullettracepassed(<start>, <end>, <hit characters>, <ignore entity>)
		if(!sighttracepassed(self gettagorigin("tag_flash"),drone.origin+(0,0,40),0,drone))
		{
			self.dronefailed = true;
			wait .2;
			break;
		}
		else if(isdefined(turrettarget) && distance(turrettarget.origin,self.origin)<distance(self.origin,drone.origin))
		{
			self.dronefailed = true;
			wait .1;
			break;	
		}
		wait .1;
	}
//	maps\_utility::structarray_swaptolast(level.drones[drone.team],drone);
	maps\_utility::structarray_shuffle(level.drones[drone.team],1);
	drone notify ("drone_mg42_fail");
}

get_bestdrone(team)
{
        //prof_begin("drone_mg42");
//	dotvalue = .88;
//	dist = 9999999;
	if (level.drones[team].lastindex < 1)
		return;
	ent = undefined;
	dotforward = anglestoforward(self.angles);
	for (i=0;i<level.drones[team].lastindex;i++)
	{
		angles = vectortoangles(level.drones[team].array[i].origin - self.origin);
		forward = anglestoforward(angles);
		if(vectordot(dotforward,forward) < .88)
			continue;
//		if(!sighttracepassed(level.drones[team].array[i].origin,self.origin+(0,0,10),0,level.drones[team].array[i]))
//			continue;
//		newdist = distance(level.drones[team].array[i].origin, self.origin);
//		if (newdist >= dist)
//			continue;
//		dist = newdist;
		ent = level.drones[team].array[i];
		break;
	}
	aitarget = self getturrettarget();
	if(isdefined(ent) && isdefined(aitarget) && distance(self.origin,aitarget.origin)<distance(self.origin,ent.origin))
		ent = undefined;  // shoot at ai if they are closer
        //prof_end("drone_mg42");
	return ent;
}


saw_mgTurretLink( nodes )
{
	possible_turrets = getEntArray( "misc_turret", "classname" );
	turrets = [];
	for ( i=0; i < possible_turrets.size; i++ )
	{
		if ( isDefined( possible_turrets[ i ].targetname ) )
			continue;
			
		if ( isdefined( possible_turrets[ i ].isvehicleattached ) )
		{
			assertEx( possible_turrets[ i ].isvehicleattached != 0, "Setting must be either true or undefined" );
			continue;
		}

		turrets[ possible_turrets[ i ].origin + "" ] = possible_turrets[ i ];
	}

	// did we find any turrets?
	if ( !turrets.size )
		return;
		
	for ( nodeIndex = 0; nodeIndex < nodes.size; nodeIndex++)
	{
		node = nodes[ nodeIndex ];
		if ( node.type == "Path" )
			continue;
		if ( node.type == "Begin" )
			continue;
		if ( node.type == "End" )
			continue;

	    nodeForward = anglesToForward( ( 0, node.angles[ 1 ], 0 ) );

		keys = getArrayKeys( turrets );
		for ( i=0; i < keys.size; i++ )
		{
			turret = turrets[ keys[ i ] ];
			
			if ( distance( node.origin, turret.origin ) > 50 )
				continue;
		
		    turretForward = anglesToForward( ( 0, turret.angles[ 1 ], 0 ) );
		    
			dot = vectorDot( nodeForward, turretForward );
			if ( dot < 0.9 )
				continue;
	
			node.turretInfo = spawn( "script_origin", turret.origin );
			node.turretInfo.angles = turret.angles;
			node.turretInfo.node = node;
			
			node.turretInfo.leftArc = 45;
			node.turretInfo.rightArc = 45;
			node.turretInfo.topArc = 15;
			node.turretInfo.bottomArc = 15;
			
			if ( isDefined( turret.leftArc ) )
				node.turretInfo.leftArc = min( turret.leftArc, 45 );

			if ( isDefined( turret.rightArc ) )
				node.turretInfo.rightArc = min( turret.rightArc, 45 );

			if ( isDefined( turret.topArc ) )
				node.turretInfo.topArc = min( turret.topArc, 15 );

			if ( isDefined( turret.bottomArc ) )
				node.turretInfo.bottomArc = min( turret.bottomArc, 15 );


			turrets[ keys[ i ] ] = undefined;
			turret delete();
		}
	}

	keys = getArrayKeys( turrets );
	for ( i=0; i < keys.size; i++ )
	{
		turret = turrets[ keys[ i ] ];
		assertMsg( "ERROR: turret at " + turret.origin + " could not link to any node!" );
	}
}


auto_mgTurretLink( nodes )
{
	// Attaches MG turrets with targetname auto_mgTurret to cover crouch and stand nodes.
	possible_turrets = getEntArray( "misc_turret", "classname" );
	turrets = [];
	for ( i=0; i < possible_turrets.size; i++ )
	{
		if ( !isDefined( possible_turrets[ i ].targetname ) || tolower( possible_turrets[ i ].targetname ) != "auto_mgturret" )
			continue;
		// if the turret is legit, create a unique string reference to it
		if ( !isdefined( possible_turrets[ i ].export ) )
			continue;
		if ( !isdefined( possible_turrets[ i ].script_dont_link_turret ) )
			turrets[ possible_turrets[ i ].origin + "" ] = possible_turrets[ i ];
	}

	// did we find any turrets?
	if ( !turrets.size )
		return;
		
	for ( nodeIndex = 0; nodeIndex < nodes.size; nodeIndex++)
	{
		node = nodes[ nodeIndex ];
		if ( node.type == "Path" )
			continue;
		if ( node.type == "Begin" )
			continue;
		if ( node.type == "End" )
			continue;
//		if ( node.type != "Turret" )
//			continue;

	    nodeForward = anglesToForward( ( 0, node.angles[ 1 ], 0 ) );

		keys = getArrayKeys( turrets );
		for ( i=0; i < keys.size; i++ )
		{
			turret = turrets[ keys[ i ] ];
			if ( distance( node.origin, turret.origin ) > 70 )
				continue;
		
		    turretForward = anglesToForward( ( 0, turret.angles[ 1 ], 0 ) );
		    
			dot = vectorDot( nodeForward, turretForward );
			if ( dot < 0.9 )
				continue;
	
			node.turret = turret;
			turret.node = node;
			turret.isSetup = true;
			assertEx( isdefined( turret.export ), "Turret at " + turret.origin + " does not have a .export value but is near a cover node. If you do not want them to link, use .script_dont_link_turret." );

			// remove the reference for it so that the other nodes dont
			// scan for this turret
			turrets[ keys[ i ] ] = undefined;
		}
		
//		assertEx( isdefined( node.turret ), "Cover node at " + node.origin + " has no turret!" );
	}
	
	/#
	// err the unclaimed turrets
	keys = getArrayKeys( turrets );
	if ( keys.size )
	{
		println( "The turrets at the following origins were not auto-bound to a node_turret." );
		println( "Set .script_dont_link_turret if you do not want a turret to use a node_turret." );
		for ( i=0; i < keys.size; i++ )
		{
			println( keys[ i ] );
		}
		assertEx( 0, "Turrets failed to be linked to node_turrets, see list above." );
	}
	#/
	
		/*
		// logic that makes the node "call" for ai
		if ( isDefined( node.auto_mgTurret_target ) )
		{
			thread maps\_mgturret::turret_think( node );
		}
		*/

	
	nodes = undefined;
}


save_turret_sharing_info()
{
	// shares turrets so a guy at a turret knows where to run if he decides to move the turret
	self.shared_turrets = [];
	self.shared_turrets[ "connected" ] = [];
	self.shared_turrets[ "ambush" ] = [];
	
	if ( !isdefined( self.export ) )
	{
		assertEx( !isdefined( self.script_turret_share ), "Turret at " + self.origin + " has script_turret_share but has no .export value, so script_turret_share won't have any effect." );
		assertEx( !isdefined( self.script_turret_ambush ), "Turret at " + self.origin + " has script_turret_ambush but has no .export value, so script_turret_ambush won't have any effect." );
		return;
	}
		
	level.shared_portable_turrets[ self.export ] = self;

	if ( isdefined( self.script_turret_share ) )
	{
		// turn the origin into a unique string
		
		// record which turrets share with this one
		strings = strtok( self.script_turret_share, " ");
		
		for ( i=0; i < strings.size; i++ )
		{
			self.shared_turrets[ "connected" ][ strings[ i ] ] = true;
		}
	}

	if ( isdefined( self.script_turret_ambush ) )
	{
		// turn the origin into a unique string
		
		// record which turrets share with this one
		strings = strtok( self.script_turret_ambush, " ");
		
		for ( i=0; i < strings.size; i++ )
		{
			self.shared_turrets[ "ambush" ][ strings[ i ] ] = true;
		}
	}
}

/*
mg42setup_gun()
{
	assertEX (isdefined(self.target), "Portable MG42 guy at origin " + self.origin + " has no target");
	mg42node = getnode (self.target,"targetname");
	mg42 = getent (self.target,"targetname");
	
	if ( !isdefined( mg42.shared_turrets ) )
		mg42 save_turret_sharing_info();
	
	// If the portable gunner targets a node then he's going to do a chain of nodes to the destination, which should
	// be an mg42. Otherwise he's directly targetting an mg42.
	if (isdefined (mg42node))
	{
		// Set this so later we can run along it as a chain.
		self.mg42node = mg42node;
		assert (!isdefined (mg42), "guy at " + self.origin + " targets an ent and a node");
		for (;;)
		{
			newnode = getnode (mg42node.target,"targetname");
			if (!isdefined (newnode))
			{
				mg42 = getent (mg42node.target,"targetname");
				break;
			}
			mg42node = newnode;
		}
	}
	
	assertEX (isdefined(mg42), "Portable MG42 guy at origin " + self.origin + " doesn't target an mg42");
	assertEX (mg42.classname == "misc_turret", "Portable MG42 guy at origin " + self.origin + " doesn't target an mg42");
	if (!isdefined(mg42.isSetup))
	{
		mg42 hide_turret();
	}
	return mg42;
}
*/

restoreDefaultPitch()
{
	self notify( "gun_placed_again" );
	self endon( "gun_placed_again" );
	self waittill ("restore_default_drop_pitch");
	wait (1);
	self restoredefaultdroppitch();
}

dropTurret()
{
	thread dropTurretProc();
}

dropTurretProc()
{
	turret = spawn ("script_model",(0,0,0));
	turret.origin = self gettagorigin ( level.portable_mg_gun_tag );
	turret.angles = self gettagangles ( level.portable_mg_gun_tag );
	turret setmodel (self.turretModel);
	forward = anglestoforward(self.angles);
	forward = vectorScale (forward, 100);
	turret moveGravity (forward, 0.5);
	self detach(self.turretModel,  level.portable_mg_gun_tag );
	self.turretmodel = undefined;
	wait (0.7);
	turret delete();
}


turretDeathDetacher()
{
	self endon ("kill_turret_detach_thread");
	self endon ("dropped_gun");
	self waittill ("death");
	if (!isdefined(self))
		return; // in case many guys die at once and we are removed
	dropTurret();
}

turretDetacher()
{
	self endon ("death");
	self endon ("kill_turret_detach_thread");
	// in case the enemy gets close to a portable turret guy
	self waittill ("dropped_gun");
	self detach(self.turretModel,  level.portable_mg_gun_tag );
}

restoreDefaults()
{
//	self.goalradius = 350;
	self.run_noncombatanim = undefined;
	self.run_combatanim = undefined;
	self set_all_exceptions( animscripts\init::empty );
}

restorePitch()
{
	self waittill( "turret_deactivate" );
	self restoredefaultdroppitch();
}

update_enemy_target_pos_while_running( ent )
{
	self endon( "death" );
	self endon( "end_mg_behavior" );
	self endon( "stop_updating_enemy_target_pos" );

	for ( ;; )
	{
		self waittill( "saw_enemy" );		
		ent.origin = self.last_enemy_sighting_position;
	}
}

move_target_pos_to_new_turrets_visibility( ent, new_spot )
{
	// moves the target position to a point where the new turret
	// can see it. If the position gets updated by seeing an enemy
	// then that position also gets pushed towards the last turret to
	// the point of visibility on the assumption that towards the old
	// turret will bring it into visibility without causing it to 
	// go to a weird point.
	
	// in any case the whole system probably needs a failsafe in case
	// the target position gets way outside the gun's allowed angles
	
	self endon( "death" );
	self endon( "end_mg_behavior" );
	self endon( "stop_updating_enemy_target_pos" );

	old_turret_pos = self.turret.origin + ( 0, 0, 16 ); // turrets are on geo so it could abstruct;
	dest_pos = new_spot.origin + ( 0, 0, 16 );
	
	for ( ;; )
	{
		wait ( 0.05 ); // plenty of time while he runs, doesn't have to happen often

		if ( sighttracepassed( ent.origin, dest_pos, 0, undefined ) )
		{
//			line( ent.origin, dest_pos, ( 0,1,0 ) );
			continue;
		}

//		line( ent.origin, dest_pos, ( 1,0,0 ) );
		
		// move the target pos towards the last turret position
		angles = vectortoangles( old_turret_pos - ent.origin );
		forward = anglestoforward( angles );
		forward = vectorscale( forward, 8 );
		
		ent.origin = ent.origin + forward;
	}
}

record_bread_crumbs_for_ambush( ent )
{
	self endon( "death" );
	self endon( "end_mg_behavior" );
	self endon( "stop_updating_enemy_target_pos" );
	
	ent.bread_crumbs = [];
	for ( ;; )
	{
//		print3d( self.origin + (0,0,50), "*", (1,1,0), 1, 1.5, 10*20 );
		ent.bread_crumbs[ ent.bread_crumbs.size ] = self.origin + ( 0, 0, 50 );
		wait( 0.35 );	
	}
}

aim_turret_at_ambush_point_or_visible_enemy( turret, ent )
{
	if ( !isalive( self.current_enemy ) && self canSee( self.current_enemy ) )
	{
		// if we can see our enemy then just aim at him
		ent.origin = self.last_enemy_sighting_position;
		return;
	}
	
	
	forward = anglestoforward( turret.angles );
	
	// find the best bread crumb to aim at
	// start a few from the back because the crumbs from while we were walking at the gun
	// arent going to be good
	for ( i = ent.bread_crumbs.size - 3; i >= 0; i-- )
	{
		// dot check it so we're not aiming at the breadcrumbs we walked over
		crumb = ent.bread_crumbs[ i ];
		normal = vectorNormalize( crumb - turret.origin );
		dot = vectorDot( forward, normal );
		if ( dot < 0.75 )
			continue;

		ent.origin = crumb;
			
		// find the first one we cant see and aim there
		if ( sighttracepassed( turret.origin, crumb, 0, undefined ) )
		{
//			linetime( turret.origin, crumb, ( 0, 1, 0 ), 10 );
			continue;
		}
		
//		linetime( turret.origin, crumb, ( 1, 0, 0 ), 10 );
		break;
	}
}

find_a_new_turret_spot( ent )
{
	// find a new spot to go to
	array = get_portable_mg_spot( ent );
	new_spot = array[ "spot" ];
	connection_type = array[ "type" ];
	
	if ( !isdefined( new_spot ) )
		return;

	reserve_turret( new_spot );
		
	// if we see the enemy while we run, update the target position
	thread update_enemy_target_pos_while_running( ent );
	thread move_target_pos_to_new_turrets_visibility( ent, new_spot );
	
	if ( connection_type == "ambush" )
	{
		thread record_bread_crumbs_for_ambush( ent );
	}

	if ( new_spot.isSetup )
	{
		leave_gun_and_run_to_new_spot( new_spot );
	}
	else
	{
		pickup_gun( new_spot );
		run_to_new_spot_and_setup_gun( new_spot );
	}
		
	self notify( "stop_updating_enemy_target_pos" );

	if ( connection_type == "ambush" )
	{
		aim_turret_at_ambush_point_or_visible_enemy( new_spot, ent );
	}

//	thread snap_lock_turret_onto_target( new_spot );
	
	new_spot setTargetEntity( ent );
}

snap_lock_turret_onto_target( turret )
{
	// turn manual on for a moment so he aims quickly to the spot he wants to aim at.
	turret setmode( "manual" );
	wait( 0.5 );
	turret setmode( "manual_ai" );
}

leave_gun_and_run_to_new_spot( spot )
{
	assert( spot.reserved == self );
	// spot is a bit of a misnomer as its actually a hidden gun we 
	// rematerialize when he runs to it

	self stopuseturret();
	self animscripts\shared::placeWeaponOn( self.primaryweapon, "none" );

	// run to the spot where the gun is setup
	setup_anim = get_turret_setup_anim( spot );
	org = getStartOrigin ( spot.origin, spot.angles, setup_anim );
	self setruntopos( org );
	assertEx( distance( org, self.goalpos ) < self.goalradius, "Tried to set the run pos outside the goalradius" );
	
	self waittill( "runto_arrived" );
	
	use_the_turret( spot );
}

pickup_gun( spot )
{
	// spot is a bit of a misnomer as its actually a hidden gun we 
	// rematerialize when he runs to it
	
	self stopuseturret();
	self.turret hide_turret();
}

get_turret_setup_anim( turret )
{
	spot_types = [];
	spot_types[ "saw_bipod_stand" ] =			level.mg_animmg[ "bipod_stand_setup" ];
	spot_types[ "saw_bipod_crouch" ] =			level.mg_animmg[ "bipod_crouch_setup" ];
	spot_types[ "saw_bipod_prone" ] =			level.mg_animmg[ "bipod_prone_setup" ];

	return spot_types[ turret.weaponinfo ];
}

run_to_new_spot_and_setup_gun( spot )
{
	assert( spot.reserved == self );
	
	oldhealth = self.health;
	spot endon( "turret_deactivate" );
	
	self.mg42 = spot; // used in the animscript exceptions
	self endon( "death" );
	self endon( "dropped_gun" );

	setup_anim = get_turret_setup_anim( spot );
	
	self.turretModel = "weapon_mg42_carry";
	
	// guys are meant to get their gun back automatically when they ditch an mg
	self notify( "kill_get_gun_back_on_killanimscript_thread" );
	self animscripts\shared::placeWeaponOn( self.weapon, "none" );
	if (self.team == "axis")
		self.health = 1;

	// set the run anim
	self.run_noncombatanim = %saw_gunner_run_slow;
	self.run_combatanim = %saw_gunner_run_fast;
	self.crouchrun_combatanim = %saw_gunner_run_fast;

	// attach the carry version of the gun		
	self attach(self.turretModel, level.portable_mg_gun_tag);
	thread turretDeathDetacher();

	// run to the spot where the gun is going to be setup
	org = getStartOrigin ( spot.origin, spot.angles, setup_anim );
	self setruntopos( org );
	assertEx( distance( org, self.goalpos ) < self.goalradius, "Tried to set the run pos outside the goalradius" );
	
	wait (0.05); // must figure out what this wait is needed for
	self set_all_exceptions( animscripts\combat::exception_exposed_mg42_portable );
	clear_exception( "move" );
	set_exception( "cover_crouch", ::hold_indefintely );
	
	while ( distance( self.origin, org ) > 16 )
	{
		self setruntopos( org );
		wait ( 0.05 );
	}
//	self waittill( "runto_arrived" );
		
	self notify ("kill_turret_detach_thread");
	
	if (self.team == "axis")
		self.health = oldhealth;

	
	if ( soundexists( "weapon_setup" ) )
		thread play_sound_in_space( "weapon_setup" );
		
	self animscripted( "setup_done", spot.origin, spot.angles, setup_anim );
	
	restoreDefaults(); // reset the run anims
	
	self waittillmatch( "setup_done", "end" );
	spot notify( "restore_default_drop_pitch" );
	spot show_turret();
	
	self animscripts\shared::placeWeaponOn( self.primaryweapon, "right" );

	use_the_turret( spot );
	self detach( self.turretModel, level.portable_mg_gun_tag );
	self set_all_exceptions( animscripts\init::empty );

	self notify( "bcs_portable_turret_setup" );
}

move_to_run_pos()
{
	self setruntopos( self.runpos );
}

hold_indefintely()
{
	self endon( "killanimscript" );
	self waittill( "death" );
}

using_a_turret()
{
	if ( !isdefined( self.turret ) )
		return false;
		
	return self.turret.owner == self;
}
	

turret_user_moves()
{
	// we've been forced to move by goalradius change or becoming exposed
	if ( !using_a_turret() )
	{
		clear_exception( "move" );
		return;
	}

	array = find_connected_turrets( "connected" );
	new_spots = array[ "spots" ];
	
	if ( !new_spots.size )
	{
		// none of the turrets in the area we're moving to are connected to the 
		// one we were at so we turn back to normal guy now
		clear_exception( "move" );
		return;
	}
	
	// lets see if we have a new node, and if we do, if its a compatible turret node
	turret_node = self.node;

	// if its not, then lets use a random node from the connected nodes that are
	// within our goal radius	
	if ( !isdefined( turret_node ) || !is_in_array( new_spots, turret_node ) )
	{
		taken_nodes = getTakenNodes();
		for ( i=0; i < new_spots.size; i++ )
		{
			turret_node = random( new_spots );
	
			// some random AI has this node already, probably doing cover there
			// if we get the ability to push AI off their node then we'll do that here later
			if ( isdefined( taken_nodes[ turret_node.origin + "" ] ) )
				return;
		}
	}
	
	turret = turret_node.turret;
	
	if ( isdefined( turret.reserved ) )
	{
		assert( turret.reserved != self );
		return;
	}
		
	reserve_turret( turret );
	
	// we're not at the turret position so we have to run to it
	if ( turret.isSetup )
	{
		// its already setup so just go there and use it
		leave_gun_and_run_to_new_spot( turret );
	}
	else
	{
		// its not setup yet so go there and set it up then use it
		run_to_new_spot_and_setup_gun( turret );
	}
		
	maps\_mg_penetration::gunner_think( turret_node.turret );
}

use_the_turret( spot )
{
	turretWasUsed = self useturret( spot );

	if ( turretWasUsed )
	{	
		set_exception( "move", ::turret_user_moves ); // run this before running move so we might move the turret

		self.turret = spot;
		self thread mg42_firing( spot ); // does the burst fire timings
		spot setmode( "manual_ai" );
		spot thread restorePitch();
		self.turret = spot;
		spot.owner = self;
//		self useturret( spot ); // dude should be near the mg42
//		spot setmode( "manual_ai" ); // auto, auto_ai, manual
//		self.turret = spot;
		return true;
	}
	else
	{
		spot restoredefaultdroppitch();
		return false;
	}

}

get_portable_mg_spot( ent )
{
	find_spot_funcs = [];
	find_spot_funcs[ find_spot_funcs.size ] = ::find_different_way_to_attack_last_seen_position;
	find_spot_funcs[ find_spot_funcs.size ] = ::find_good_ambush_spot;

	find_spot_funcs = array_randomize( find_spot_funcs );
	
	for ( i=0; i < find_spot_funcs.size; i++ )
	{
		array = [[ find_spot_funcs[ i ] ]]( ent );
		
		if ( !isdefined( array[ "spots" ] ) )
			continue;
		
		array[ "spot" ] = random( array[ "spots" ] );
		return array;
	}
}

getTakenNodes()
{
	// returns an array of node origins owned by AI
	array = [];
	ai = getaiarray();
	
	for ( i=0; i < ai.size; i++ )
	{
		if ( !isdefined( ai[ i ].node ) )
			continue;
		
		array[ ai[ i ].node.origin + "" ] = true;
	}
	
	return array;
}

find_connected_turrets( connection_type )
{
	spots = level.shared_portable_turrets;	// an array of shared turrets, using their origin as the index
	usable_spots = [];
	
	spot_exports = getArrayKeys( spots );
	
	taken_nodes = getTakenNodes();
	taken_nodes[ self.node.origin + "" ] = undefined;
	
	// find turrets that share the same keys
	for ( i=0; i < spot_exports.size; i++ )
	{
		export = spot_exports[ i ];
		if ( spots[ export ] == self.turret )
			continue;
			
		
		keys = getArrayKeys( self.turret.shared_turrets[ connection_type ] );	
		for ( p=0; p < keys.size; p++ )
		{
			// go through each key that the turret the guy is currently on has,
			// and see if any turrets share keys.
			// cast export as a string because arraykeys returns strings
			if ( spots[ export ].export + "" != keys[ p ] )
				continue;
				
			// somebody else has this one or they're running to it
			if ( isdefined( spots[ export ].reserved ) )
				continue;
				
			// some random AI has this node already, probably doing cover there
			if ( isdefined( taken_nodes[ spots[ export ].node.origin + "" ] ) )
				continue;
				
			// don't pick one that is outside the goalradius
			if ( distance( self.goalpos, spots[ export ].origin ) > self.goalradius )
				continue;
				
			// this spot is usable				
			usable_spots[ usable_spots.size ] = spots[ export ];
		}
	}

	array = [];
	// store it so we can figure out the best place for an ambusher to aim
	array[ "type" ] = connection_type;
	array[ "spots" ] = usable_spots;
	return array;	
}

find_good_ambush_spot( ent )
{
	return find_connected_turrets( "ambush" );
}

find_different_way_to_attack_last_seen_position( ent )
{
	array = find_connected_turrets( "connected" );
	usable_spots = array[ "spots" ];
	
	if ( !usable_spots.size )
		return;

	good_spot = [];
	
	// find a spot that has a good fov and LOS on the target spot
	for ( i=0; i < usable_spots.size; i++ )
	{
			
		if ( !within_fov( usable_spots[ i ].origin, usable_spots[ i ].angles, ent.origin, 0.75 ) )
			continue;
		
		/*
		normal = vectorNormalize( ent.origin - ( usable_spots[ i ].origin + offset ) );
		forward = anglestoforward( usable_spots[ i ].angles );
		dot = vectorDot( forward, normal );

		thread linetime( usable_spots[ i ].origin + offset, usable_spots[ i ].origin + offset + vectorscale( forward, 1000 ), ( 1, 0, 0 ), 10 );
		thread linetime( ent.origin, usable_spots[ i ].origin + offset, ( 0, 0, 1 ), 10 );
		*/
			
		if ( !sighttracepassed( ent.origin, usable_spots[ i ].origin + (0,0,16), 0, undefined ) )
			continue;
	
		good_spot[ good_spot.size ] = usable_spots[ i ];
	}
	
	array[ "spots" ] = good_spot;
	return array;
}

portable_mg_spot()
{
	save_turret_sharing_info();	
	
	turret_preplaced = 1;
	self.isSetup = true;
	assert( !isdefined( self.reserved ) );
	self.reserved = undefined;
	if(isdefined(self.isvehicleattached))
		return;	//nate
	if ( self.spawnflags & turret_preplaced )
		return;
		
	// a spot where a gun could be placed
	hide_turret();
	
}


hide_turret()
{
	assert( self.isSetup );
	self notify( "stop_checking_for_flanking" );
	self.isSetup = false;
	self hide();
	self.solid = false;
	self maketurretunusable();
	self setdefaultdroppitch(0);
	self thread restoreDefaultPitch();
}

show_turret()
{
	self show();
	self.solid = true;
	self maketurretusable();
	assert( !self.isSetup );
	self.isSetup = true;
	thread stop_mg_behavior_if_flanked();
}

stop_mg_behavior_if_flanked()
{
	self endon( "stop_checking_for_flanking" );
	
	self waittill( "turret_deactivate" );
	if ( isalive( self.owner ) )
		self.owner notify( "end_mg_behavior" );
}

turret_is_mine( turret )
{
	owner = turret getTurretOwner();
	if ( !isdefined( owner ) )
		return false;
	
	return owner == self;
}

end_turret_reservation( turret )
{
	waittill_turret_is_released( turret );
	turret.reserved = undefined;
}

waittill_turret_is_released( turret )
{
	turret endon( "turret_deactivate" );
	self endon( "death" );
	self waittill( "end_mg_behavior" );
}
	
reserve_turret( turret )
{
	turret.reserved = self;
	thread end_turret_reservation( turret );
}
