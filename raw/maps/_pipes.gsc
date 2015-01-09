#include common_scripts\utility;
#include maps\_utility;

main()
{
	waittillframeend; // insure that structs are initialized

	pipes = getentarray("pipe_shootable","targetname");
	if(!pipes.size)
		return;
	
	level.num_pipe_fx	= 0;
	level.limit_pipe_fx	= 32;
	pipes thread precacheFX();
	pipes thread methodsInit();
	
	array_thread(pipes, ::pipesetup);
	
	pipearray = pipes;
	pipebreak = getentarray("pipe_break","targetname");
	if(pipebreak.size)
	{
		pipebreak pipebreakInit(pipearray);
		pipemasterInit(pipebreak);
			
		array_thread(pipebreak, ::pipebreakthink);
	}
}

methodsInit()
{
	level._pipe_methods = [];
	level._pipe_methods["MOD_UNKNOWN"] 				= ::pipe_calc_splash;
	level._pipe_methods["MOD_PISTOL_BULLET"] 		= ::pipe_calc_ballistic;
	level._pipe_methods["MOD_RIFLE_BULLET"] 		= ::pipe_calc_ballistic;
	level._pipe_methods["MOD_GRENADE"] 				= ::pipe_calc_splash;
	level._pipe_methods["MOD_GRENADE_SPLASH"] 		= ::pipe_calc_splash;
	level._pipe_methods["MOD_PROJECTILE"] 			= ::pipe_calc_splash;
	level._pipe_methods["MOD_PROJECTILE_SPLASH"] 	= ::pipe_calc_splash;
	level._pipe_methods["MOD_MELEE"] 				= ::pipe_calc_nofx;
	level._pipe_methods["MOD_HEAD_SHOT"] 			= ::pipe_calc_nofx;
	level._pipe_methods["MOD_CRUSH"] 				= ::pipe_calc_nofx;
	level._pipe_methods["MOD_TELEFRAG"] 			= ::pipe_calc_nofx;
	level._pipe_methods["MOD_FALLING"] 				= ::pipe_calc_nofx;
	level._pipe_methods["MOD_SUICIDE"] 				= ::pipe_calc_nofx;
	level._pipe_methods["MOD_TRIGGER_HURT"] 		= ::pipe_calc_splash;
	level._pipe_methods["MOD_EXPLOSIVE"] 			= ::pipe_calc_splash;
	level._pipe_methods["MOD_IMPACT"] 				= ::pipe_calc_nofx;
}

pipe_calc_ballistic(P, type)
{
	return P;	
}

pipe_calc_splash(P, type)
{
	vec = vectornormalize( vectorFromLineToPoint(self.A, self.B, P) );
	P = pointOnSegmentNearestToPoint(self.A, self.B, P);
	return ( P + vector_multiply(vec, 4) );
}

pipe_calc_nofx(P, type)
{
	return undefined;
}

pipe_calc_assert(P, type)
{
	assertMsg("BUG to MOHAMMAD ALAVI under LEVEL DESIGN. Pipe at (" + self getorigin() + ") was impacted with unknown type: " + type + ".");
}

pipemasterInit(breaks)
{
	level.pipe_breaks = breaks;
	
	while(level.pipe_breaks.size)
	{
		sample = level.pipe_breaks[level.pipe_breaks.size-1];
		master = spawnstruct();
		master.name = "pipe master at (" + sample.origin + ") position";
		
		sample.master = master;
		level.pipe_breaks = array_remove(level.pipe_breaks, sample);
		master pipemasterIterate(sample);
	}
}

pipemasterIterate(sample)
{
	family = get_pipes_in_range(sample, level.pipe_breaks);
	
	//if we didn't find anything then head back
	if(!isdefined(family) || family.size == 0)
		return;
	
	//if we found more - give them the current master and remove them from the list
	for(i=0; i<family.size; i++)
	{
		family[i].master = self;
		level.pipe_breaks = array_remove(level.pipe_breaks, family[i]);
	}
	
	//since we found new ones - we must see if there are more in the list that are near these
	for(i=0; i<family.size; i++)
		self pipemasterIterate(family[i]);
}

get_pipes_in_range(sample, pipes)
{
	testdist = 34;
	if (pipes.size < 1)
		return;
	
	ents = [];
	foundit = false;
	
	for (i=0;i<pipes.size;i++)
	{
		foundit = false;
		for(e = 0; e < pipes[i].ends.size; e++)
		{
			for(j = 0; j < sample.ends.size; j++)
			{
				dist = distance(pipes[i].ends[e], sample.ends[j]);
				if(dist > testdist)
					continue;
				
				foundit = true;
				ents[ents.size] = pipes[i];
				break;
			}
			
			if(foundit)
				break;
		}
	}
	
	return ents;
}

pipebreakInit(pipes)
{
	for(j=0; j<self.size; j++)
	{	
		self[j].whole = getClosest(self[j] getorigin(), pipes);
		pipes = array_remove(pipes, self[j].whole);
		
		self[j].fxnode = spawnstruct();
		self[j].fxnode.origin = self[j].origin;
		self[j].fxnode.forward = vector_multiply(anglestoright(self[j].angles), -1);
		self[j].fxnode.up = anglestoforward(self[j].angles);
		
		
		/****************************************************************/
		/*		THIS IS A HACK UNTIL I GET A MODEL FOR THIS THING		*/
		/****************************************************************/
				if(self[j].script_noteworthy == "fueltanker")
				{
					node = getstruct(self[j].whole.target, "targetname");
					self[j].fxnode.origin = node.origin;
					self[j].fxnode.forward = anglestoup(node.angles);
					self[j].fxnode.up = anglestoforward(node.angles);
					self[j].fxnode.right = anglestoright(node.angles);
				}
		/****************************************************************/
		/*		THIS IS A HACK UNTIL I GET A MODEL FOR THIS THING		*/
		/****************************************************************/
		
		
		self[j].hurtnode = [];
		switch(self[j].script_noteworthy)
		{
			case "fire64":{
				self[j].hurtnode[self[j].hurtnode.size] = self[j].fxnode.origin;
				}break;
			case "fire96":{
				vec1 = vector_multiply(self[j].fxnode.up, 16);
				self[j].hurtnode[self[j].hurtnode.size] = self[j].fxnode.origin + vec1;
				vec1 = vector_multiply(self[j].fxnode.up, -16);
				self[j].hurtnode[self[j].hurtnode.size] = self[j].fxnode.origin + vec1;
				}break;	
			case "fire128":{
				vec1 = vector_multiply(self[j].fxnode.up, 32);
				self[j].hurtnode[self[j].hurtnode.size] = self[j].fxnode.origin + vec1;
				vec1 = vector_multiply(self[j].fxnode.up, -32);
				self[j].hurtnode[self[j].hurtnode.size] = self[j].fxnode.origin + vec1;
				}break;	
			case "fire256":{
				self[j].fx_multinode = [];
					newnode = spawnstruct();
					vec1 = vector_multiply(self[j].fxnode.up, 64);
					newnode.origin = self[j].fxnode.origin + vec1;
					newnode.forward = self[j].fxnode.forward;
					newnode.up = self[j].fxnode.up;
					self[j].fx_multinode[self[j].fx_multinode.size] = newnode;
					
					newnode = spawnstruct();
					vec1 = vector_multiply(self[j].fxnode.up, -64);
					newnode.origin = self[j].fxnode.origin + vec1;
					newnode.forward = self[j].fxnode.forward;
					newnode.up = self[j].fxnode.up;
					self[j].fx_multinode[self[j].fx_multinode.size] = newnode;
				
				
				vec1 = vector_multiply(self[j].fxnode.up, 64);
				self[j].hurtnode[self[j].hurtnode.size] = self[j].fxnode.origin + vec1;
				vec1 = vector_multiply(self[j].fxnode.up, -64);
				self[j].hurtnode[self[j].hurtnode.size] = self[j].fxnode.origin + vec1;
				}break;	
			case "fueltanker":{
				self[j].fx_multinode = [];
					self[j].fx_multinode[self[j].fx_multinode.size] = self[j].fxnode;
				
				/****************************************************************/
				/*			THIS IS A HACK UNTIL I GET A PROPER EFFECT			*/
				/****************************************************************/
						newnode2 = spawnstruct();
						newnode2.origin = self[j].fxnode.origin;
						newnode2.up = self[j].fxnode.up;
						newnode2.forward = self[j].fxnode.forward + vector_multiply(self[j].fxnode.right, 1);
						self[j].fx_multinode[self[j].fx_multinode.size] = newnode2;
						
						newnode2 = spawnstruct();
						newnode2.origin = self[j].fxnode.origin;
						newnode2.up = self[j].fxnode.up;
						newnode2.forward = self[j].fxnode.forward + vector_multiply(self[j].fxnode.right, -1);
						self[j].fx_multinode[self[j].fx_multinode.size] = newnode2;
									
					newnode = spawnstruct();
					vec1 = vector_multiply(self[j].fxnode.up, 112);
					newnode.origin = self[j].fxnode.origin + vec1;
					newnode.forward = self[j].fxnode.forward;
					newnode.up = self[j].fxnode.up;
					self[j].fx_multinode[self[j].fx_multinode.size] = newnode;
					
						newnode2 = spawnstruct();
						newnode2.origin = newnode.origin;
						newnode2.up = newnode.up;
						newnode2.forward = newnode.forward + vector_multiply(self[j].fxnode.right, 1);
						self[j].fx_multinode[self[j].fx_multinode.size] = newnode2;
						
						newnode2 = spawnstruct();
						newnode2.origin = newnode.origin;
						newnode2.up = newnode.up;
						newnode2.forward = newnode.forward + vector_multiply(self[j].fxnode.right, -1);
						self[j].fx_multinode[self[j].fx_multinode.size] = newnode2;
					
					newnode = spawnstruct();
					vec1 = vector_multiply(self[j].fxnode.up, -112);
					newnode.origin = self[j].fxnode.origin + vec1;
					newnode.forward = self[j].fxnode.forward;
					newnode.up = self[j].fxnode.up;
					self[j].fx_multinode[self[j].fx_multinode.size] = newnode;
					
						newnode2 = spawnstruct();
						newnode2.origin = newnode.origin;
						newnode2.up = newnode.up;
						newnode2.forward = newnode.forward + vector_multiply(self[j].fxnode.right, 1);
						self[j].fx_multinode[self[j].fx_multinode.size] = newnode2;
						
						newnode2 = spawnstruct();
						newnode2.origin = newnode.origin;
						newnode2.up = newnode.up;
						newnode2.forward = newnode.forward + vector_multiply(self[j].fxnode.right, -1);
						self[j].fx_multinode[self[j].fx_multinode.size] = newnode2;
				/****************************************************************/
				/*			THIS IS A HACK UNTIL I GET A PROPER EFFECT			*/
				/****************************************************************/
					
				self[j].hurtnode[self[j].hurtnode.size] = self[j].fxnode.origin;
				vec1 = vector_multiply(self[j].fxnode.up, 184);
				self[j].hurtnode[self[j].hurtnode.size] = self[j].fxnode.origin + vec1;
				vec1 = vector_multiply(self[j].fxnode.up, -184);
				self[j].hurtnode[self[j].hurtnode.size] = self[j].fxnode.origin + vec1;
				}break;
		}
		
		//find the ends of the pipe so we can calculate in a later function what other pipes are attached to this one
		//we'll include the center of the pipe as well for the calculations
		self[j].ends = [];
		displacement = 0;
		switch(self[j].script_noteworthy)
		{
			case "fire64":{
				displacement = 32;
				}break;
			case "fire96":{
				displacement = 48;
				}break;	
			case "fire128":{
				displacement = 64;
				}break;	
			case "fire256":{
				displacement = 128;
				}break;	
			case "fueltanker":{
				displacement = 184;
				}break;	
		}
		self[j].ends[self[j].ends.size] = self[j].fxnode.origin;
		vec1 = vector_multiply(self[j].fxnode.up, displacement);
		self[j].ends[self[j].ends.size] = self[j].fxnode.origin + vec1;
		vec1 = vector_multiply(self[j].fxnode.up, (displacement * -1));
		self[j].ends[self[j].ends.size] = self[j].fxnode.origin + vec1;
	}
}

pipebreak_damage()
{
	minDamage = 1;
	maxDamage = 250;
	blastRadius = 200;
	
	if(self.script_noteworthy == "fueltanker")
		blastRadius = 350;

	for(i=0; i<self.hurtnode.size; i++)
		radiusDamage(self.hurtnode[i], blastRadius, maxDamage, minDamage);
}

pipebreakthink()
{
	self hide();
	self notsolid();
	self thread pipebreakthink2();
	self thread pipebreakthink3();
	self thread pipebreakthink4();
	
	self.whole endon("pipe_breaking");
	while(1)
	{
		self.whole waittill("pipe_ruptured");
		badplace_cylinder("",2, self.whole.origin, 250, 250);
		
		self.master notify("pipe_ruptured");
		self thread pipebreakthink2();	
	}
}

pipebreakthink2()
{
	self.whole endon("pipe_ruptured");
	self.whole endon("deleting");
	self.master waittill("pipe_ruptured");
	self.whole.numfx++;
	self thread pipebreakthink2();
}

pipebreakthink3()
{
	self.whole endon("pipe_breaking");
	self.master waittill("hurtme");
	wait randomfloat(.2);
	self.whole notify("pipe_breaking");
}

pipebreakthink4()
{		
	self.whole waittill("pipe_breaking");
	
	self.master notify("hurtme");
	switch(self.script_noteworthy)
	{
		
		case "fueltanker":{
			thread play_sound_in_space("explo_rock", self.fxnode.origin);
		}break;
		default:{
			if(isdefined(self.master.firstsnd))
				thread play_sound_in_space("expl_gas_pipe_burst", self.fxnode.origin);
			else
			{
				self.master.firstsnd = true;
				thread play_sound_in_space("expl_gas_pipe_burst_decay", self.fxnode.origin);	
			}	
			}break;
	}
	
	//DO DAMAGE	
	self thread pipebreak_damage();
	
	self.A = self.whole.A;
	self.B = self.whole.B;
	self setcandamage(true);
	
	self.whole notify("deleting");
	self.whole delete();
	self show();
	self solid();
	if(isdefined(self.fx_multinode))
	{
		for(i=0; i<self.fx_multinode.size; i++)
			playfx( level._effect["pipe_interactive"][self.script_noteworthy], self.fx_multinode[i].origin, self.fx_multinode[i].forward, self.fx_multinode[i].up);
	}	
	else
		playfx( level._effect["pipe_interactive"][self.script_noteworthy], self.fxnode.origin, self.fxnode.forward, self.fxnode.up);
	
	if(self.script_noteworthy == "fueltanker")
		earthquake(0.4, 1.5, self.fxnode.origin, 600);
	
	self thread pipeimpact();
}

pipesetup()
{
	self setcandamage(true);
	node = undefined;
	
	if(isdefined(self.target))
	{
		node = getstruct(self.target, "targetname");	
		self.A = node.origin;
		vec = anglesToForward (node.angles);
		vec = vector_multiply(vec, 128);
		self.B = self.A+vec;
	}
	else
	{
		vec = anglestoforward(self.angles);
		vec1 = vector_multiply(vec, 64);
		self.A = self.origin + vec1;
		vec1 = vector_multiply(vec, -64);
		self.B = self.origin + vec1;
	}
	
	if(	self.script_noteworthy == "fire")
		self.limit = 4;
	
	self thread pipethink();
}

pipethink()
{
	P = (0,0,0);//just to initialize P as a vector
	self.numfx = 0;
	
	self endon("deleting");
	
	//FIRE
	if(isdefined(self.limit))
	{
		while(1)
		{
			self waittill("damage", other, damage, direction_vec, P, type );
			if(type == "MOD_MELEE" || type == "MOD_IMPACT")
				continue;
	
			self pipethink_logic(self.numfx, self.limit, direction_vec, P, type);
			self.numfx++;
			
		}
	}
	//EVERYTHING ELSE
	else
	{
		while(1)
		{
			self waittill("damage", other, damage, direction_vec, P, type );
			if(type == "MOD_MELEE" || type == "MOD_IMPACT")
				continue;
				
			self pipethink_logic(level.num_pipe_fx, level.limit_pipe_fx, direction_vec, P, type);
			level.num_pipe_fx++;
			self thread pipethink2();
		}
	}
}

pipethink_logic(num, limit, direction_vec, P, type)
{
	if(num < limit )
	{
		P = self [[ level._pipe_methods[type] ]](P, type);
		
		if( !isdefined( P ) )
			return;
		
		//calculate the vector derived from the center line of our pipe and the point of damage
		vec = vectorFromLineToPoint(self.A, self.B, P);
		self thread pipefx(P, vec);
	 
		self notify("pipe_ruptured");
	}
	else
		self notify("pipe_breaking");
}

pipethink2()
{
	//self endon("deleting");
	wait level.pipe_fx_time[self.script_noteworthy];
	level.num_pipe_fx--;
}

pipefx(P, vec)
{
	if(self.script_noteworthy != "fire")
	{
		playfx ( level._effect["pipe_interactive"][self.script_noteworthy], P, vec);
		thread play_sound_in_space(level._sound["pipe_interactive"][self.script_noteworthy], P);
		return;
	}
	self endon("pipe_breaking");
	
	time = .1;
	if(!isdefined(self.burnsec))
	{
		self.burnsec = int(2 / time); //2 secs / time = num of times to loop
		self.burninterval = int(self.burnsec * .15);
	}
	else
		self.burnsec -= self.burninterval;
		
	thread play_sound_in_space("mtl_gas_pipe_hit", P);
	self thread pipesndloopfx("mtl_gas_pipe_flame_loop", P, "pipe_breaking");
	
	if(vec == (0,0,0))
		vec = (0,360,0);
			
	for(i=0; i<self.burnsec; i++)
	{
		playfx ( level._effect["pipe_interactive"][self.script_noteworthy], P, vec);
		wait time;	
	}
	
	self notify("pipe_breaking");	
}

pipeimpact()
{
	P = (0,0,0);//just to initialize P as a vector
	
	self endon("deleting");
	
	while(1)
	{
		self waittill("damage", other, damage, direction_vec, P , type);
		if(type == "MOD_MELEE" || type == "MOD_IMPACT")
			continue;	
		P = self [[ level._pipe_methods[type] ]](P, type);
		
		//play the metal hit fx
		direction_vec = vector_multiply(direction_vec, -1);
		playfx( level._effect["pipe_interactive"]["impact"], P, direction_vec);	
	}
}

pipesndloopfx(snd, P, msg, time)
{
	self endon(msg);
	
	if(isdefined(time))
		wait time;
	while(1)
	{
		play_sound_in_space(snd, P);
	}
}

precacheFX()
{	
	for(i=0; i< self.size; i++)
	{
		if(self[i].script_noteworthy != "steam")
			continue;
		
		level._effect["pipe_interactive"][self[i].script_noteworthy]		= loadfx("impacts/pipe_steam"); 	
		level._sound["pipe_interactive"][self[i].script_noteworthy] 		= "mtl_steam_pipe_hit";
		level.pipe_fx_time[self[i].script_noteworthy]			= 5;
		
		break;
	}
	for(i=0; i< self.size; i++)
	{
		if(self[i].script_noteworthy != "water")
			continue;
		
		level._effect["pipe_interactive"][self[i].script_noteworthy]		= loadfx("impacts/pipe_water");  
		level._sound["pipe_interactive"][self[i].script_noteworthy] 		= "mtl_water_pipe_hit";	
		level.pipe_fx_time[self[i].script_noteworthy]			= 2.6;
		break;
	}
	for(i=0; i< self.size; i++)
	{
		if(self[i].script_noteworthy != "fire")
			continue;
		
		level._effect["pipe_interactive"][self[i].script_noteworthy	]		= loadfx("impacts/pipe_fire"); 	
		level._effect["pipe_interactive"]["fire64"]		= loadfx("explosions/pipe_explosion64"); 	
		level._effect["pipe_interactive"]["fire96"]		= loadfx("explosions/pipe_explosion64"); 	
		level._effect["pipe_interactive"]["fire128"]	= loadfx("explosions/pipe_explosion128"); 	
		level._effect["pipe_interactive"]["fire256"]	= loadfx("explosions/pipe_explosion128"); 	
		level._effect["pipe_interactive"]["fueltanker"]	= loadfx("explosions/pipe_explosion128"); 	
			
		break;
	}
	
	level._effect["pipe_interactive"]["impact"]		= loadfx("impacts/small_metalhit_1"); 	
}