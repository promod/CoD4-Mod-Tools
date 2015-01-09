#include common_scripts\utility;
#include maps\_utility;
#include maps\_anim;

wait_timeout(msg, time)
{
	self endon("wait timed out");
	self thread wait_timeout2(msg, time);
	self waittill("msg");
}

wait_timeout2(msg, time)
{
	self endon("msg");
	wait time;
	self notify("wait timed out");
}

get_ai(name, team, type)
{
	if(!isdefined(team))
		team = "allies";
	if(!isdefined(type))
		type = "targetname";
	
	ai = getaiarray(team);
	array = [];
	for(i=0; i<ai.size; i++)
	{
		switch(type)
		{
			case "targetname":{
				if(isdefined(ai[i].targetname) && ai[i].targetname == name)
					array[array.size] = ai[i];	
			}break;	
		 	case "script_noteworthy":{
				if(isdefined(ai[i].script_noteworthy) && ai[i].script_noteworthy == name)
					array[array.size] = ai[i];
			}break;
			case "script_forcecolor":{
				if(ai[i] check_force_color(name))
					array[array.size] = ai[i];
			}break;
		}
	}
	return array;
}

get_closest(org, array, maxdist)
{
	if (array.size < 1)
		return;
		
	dist = distancesquared(array[0].origin, org);
	ent = array[0];
	for (i=0;i<array.size;i++)
	{
		newdist = distancesquared(array[i].origin, org);
		if (newdist >= dist)
			continue;
		dist = newdist;
		ent = array[i];
	}
	if( isdefined(maxdist) && (distance(org, ent.origin) > maxdist) )
		ent = undefined;
	
	return ent;
}

get_closest_fx(org, array, maxdist)
{
	
}

get_closest_ent(org, array, maxdist)
{
	if (array.size < 1)
		return;
		
	dist = distancesquared(array[0] getorigin(), org);
	ent = array[0];
	for (i=0;i<array.size;i++)
	{
		newdist = distancesquared(array[i] getorigin(), org);
		if (newdist >= dist)
			continue;
		dist = newdist;
		ent = array[i];
	}
	if( isdefined(maxdist) && (distance(org, ent getorigin()) > maxdist) )
		ent = undefined;
	
	return ent;
}

get_ents_within_dist(org, array, testdist)
{
	if (array.size < 1)
		return;
	
	ents = [];
	
	for (i=0;i<array.size;i++)
	{
		dist = distance(array[i] getorigin(), org);
		if (dist > testdist)
			continue;
		ents[ents.size] = array[i];
	}
	
	return ents;
}

door_breach(node, guy, door, anim1)
{
	guy.ignoreme = true;
	guy.oldradius = guy.goalradius;
	guy.goalradius = 16;
	forcegoal = false;
	bulletshield = false;
	if(isdefined(guy.set_forcedgoal))
		forcegoal = true;
	if(isdefined(guy.magic_bullet_shield))
		bulletshield = true;
	
	if(!forcegoal)
		guy set_forcegoal();
	if(!bulletshield)
		guy thread magic_bullet_shield();
	
	if(anim1 == "kick")
	{
		vec = anglestoforward(node.angles);
		vec = vector_multiply(vec, 20);
		
		x = spawn("script_origin", node.origin + vec);	
		x.angles = node.angles;
		node = x;
	}
	
	guy.oldanimname = guy.animname;
	guy.animname = "guy";
	if(anim1 == "kick")
		node anim_reach_solo(guy, anim1);
	else
	{
		guy setgoalnode(node);
		guy waittill("goal");
	}
	node thread anim_single_solo (guy, anim1);
	
	guy waittillmatch("single anim", "kick");
	
	array_thread(door, ::door_breach_door);
	
	if(anim1 == "kick")
	{
		wait .2;
		guy stopanimscripted();
	}
	else
		guy waittillmatch("single anim", "end");
	
	guy.animname = guy.oldanimname;
	guy.goalradius = guy.oldradius;
	guy.ignoreme = false;
	if(!forcegoal)
		guy unset_forcegoal();
	if(!bulletshield)
		guy stop_magic_bullet_shield();
}

door_breach_door()
{
	self notsolid();
	if (self.spawnflags & 1)
		self connectpaths();
	
	x = 0;
	y = 0;
	z = 0;
	
	switch(	self.script_parameters )
	{
		case "left":	{y = randomfloatrange(88, 92);}break;
		case "right":	{y = -1 * randomfloatrange(88, 92);}break;
		case "xleft":	{z = 90;}break;
		case "xright":	{z = -90;}break;
		case "yleft":	{x = 90;}break;
		case "yright":	{x = -90;}break;
	}
	
	time = .4;
	ang = self.angles + (x,y,z);
	self rotateto(ang, time,0.05,0.05);
	
	wait time;
	
	self solid();
	self disconnectpaths();
}

floodspawner_switch(group1, group2)
{
	size = group1.size;
	if(group1.size > group2.size)
		size = group2.size;
		
	for(i=0; i<size; i++)
		group1[i] thread spawner_switch_think(group2[i]);
	
	if(i < group2.size)
	{
		for(j=i; j<group2.size; j++)
			group2[j] thread spawner_switch_think2();
	}
}

spawner_switch_think(spwner)
{
	spwner endon("death");
	spwner.FloodSpawnCount--;
	
	self waittill("death");
	spwner thread spawner_switch_think2();
}

spawner_switch_think2()
{
	self endon("death");
	
	self.count = 1;
	
	if ( !script_wait() )
		wait (randomFloatRange( 2, 4 ));

	while(1)
	{
		guy = self dospawn();
		if(!spawn_failed(guy))
			break;
		wait .2;
	}
}

#using_animtree("fastrope");
player_fastrope_go(ent)
{
	camera = spawn("script_model", ent.origin);
	camera setmodel("fastrope_arms");
	camera.angles = ent.angles;
	
	link = spawn("script_origin", ent.origin);
	link.angles = level.player.angles;
	
	camera linkto(link);
	camera.animname = ("playerfastrope");
	camera UseAnimTree(#animtree);
	
	level.player allowLean(false);
	level.player freezecontrols(true);
	level.player playerlinktoabsolute(camera, "tag_player");
	
	playerWeaponTake();
	link anim_single_solo(camera, "fastrope_on");
	link movez((ent.range + 96) *- 1, ent.time + .5);
	link thread anim_loop_solo(camera, "fastrope_loop", undefined, "stopanimscripted");
	wait ent.time;
	link notify("stopanimscripted");
	level.player anim_single_solo(camera, "fastrope_off");
	
	playerWeaponGive();
	
	level.player unlink();
	level.player freezecontrols(false);
	level.player allowLean(true);
	
	link delete();
	camera delete();
}

ai_clear_dialog(spawners, end_ent, end_msg, dlg_ent, dlg_msg)
{
	if(!isdefined(level.ai_clear_dialog_last))
		level.ai_clear_dialog_last = 0;
		
	ai = getaiarray("axis");
	ai_clear_dialog_logic(ai, spawners, end_ent, end_msg, dlg_ent, dlg_msg);
}

ai_clear_dialog_logic_guy(check)
{
	self waittill("death");
	
	check.count--;
	check notify("ai_death");
}

ai_clear_dialog_logic_check()
{
	self endon("death");
	
	self.ready = false;
	
	while(self.count)
		self waittill("ai_death");
	
	self.ready = true;
	self notify("ready");
}

ai_clear_dialog_logic(array, spawners, end_ent, end_msg, dlg_ent, dlg_msg)
{
	if(isdefined(end_ent))
		end_ent endon(end_msg);
	
	//check init
	check = spawnstruct();
	check.ready 	= true;
	
	
	if(isdefined(spawners))
	{
		check.count 	= spawners.size;
		check thread ai_clear_dialog_logic_check();
		array_thread(spawners, ::add_spawn_function, ::ai_clear_dialog_logic_guy, check);
	}
	
	waittill_dead(array);
	
	if(!check.ready)
		check waittill("ready");
	
	check notify("death");
	
	//ok everyone's dead - do the dialog logic
	if(isdefined(dlg_ent))
	{
		wait .5;
		if( dlg_ent == level.player )
			thread radio_msg_stack( dlg_msg );
		else
			dlg_ent thread play_sound_on_entity(dlg_msg);
	}
	else
	{	
		ai = getaiarray("allies");
		
		speaker = [];
		
		guy = get_closest_living(level.player.origin, ai, 1024);
		if(!isdefined(guy))
		{
			level notify("ai_clear_dialog_done");
			return;
		}
		num =2;
		
		rand = level.ai_clear_dialog_last;
		while(rand == level.ai_clear_dialog_last)
			rand = randomint(num);
		
		level.ai_clear_dialog_last = rand;
		
		wait .5;
		
		switch(rand)
		{
			case 0:{	guy thread play_sound_on_entity(level.level_name + "_gm2_clear");	}break;
			case 1:{	guy thread play_sound_on_entity(level.level_name + "_gm3_clear");	}break;	
		}
	}
	
	level notify("ai_clear_dialog_done");
}

playerWeaponGive()
{
	level.player notify ("restore_player_weapons");
}

playerWeaponTake()
{
	thread playerWeaponTakeLogic();
}

playerWeaponTakeLogic()
{
	if( isdefined( level.player.weaponstaken ) )
		return;

	level.player.weaponstaken = true;
	level.player DisableWeapons();

	level.player waittill( "restore_player_weapons" );

	level.player EnableWeapons();
	level.player.weaponstaken = undefined;	
}

anim_single_stack( guy, xanim )
{
	localentity = spawnstruct();
	
	localentity thread anim_single_stack_proc( guy, xanim );
	localentity waittill("anim_single_done");
}

anim_single_stack_proc( guy, xanim )
{
	if( !isdefined(level.anim_stack) )
		level.anim_stack = [];
	
	id = "" + guy.ai_number + xanim;
	
		
	level.anim_stack [ level.anim_stack.size ] = id;
	
	while(level.anim_stack[0] != id )
		level waittill("level_anim_stack_ready");

	self anim_single_solo( guy, xanim);
	
	level.anim_stack = array_remove( level.anim_stack, id );
	level notify("level_anim_stack_ready");
	self notify("anim_single_done");
}

radio_msg_stack( msg )
{
	localentity = spawnstruct();
	
	localentity thread radio_msg_stack_proc( msg );
	localentity waittill("radio_dialogue_done");
}

radio_msg_stack_proc( msg )
{
	if( !isdefined(level.radio_stack) )
		level.radio_stack = [];
	
	level.radio_stack [ level.radio_stack.size ] = msg;
	
	while(level.radio_stack[0] != msg )
		level waittill("level_radio_stack_ready");

	radio_dialogue( msg );
	
	level.radio_stack = array_remove( level.radio_stack, msg );
	
	level notify("level_radio_stack_ready");
	self notify("radio_dialogue_done");
}

disable_cqbwalk_ign_demo_wrapper()
{
	self disable_cqbwalk();
	self.interval = 96;
}

enable_cqbwalk_ign_demo_wrapper()
{
	self enable_cqbwalk();
	self.interval = 50;
}