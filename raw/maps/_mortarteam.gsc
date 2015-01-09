#include maps\_utility;
#include maps\_anim;
#using_animtree ("generic_human");
main()
{
	// a trigger with targetname "mortar_team" targets a spawner.
	// The spawner targets a node or nodes. The script will randomly pick one for his
	// destination. The node targets script origins which the mortar will fire at.
	// The spawner can also target a second spawner which will spawn a secondary mortar operator.

	anims();
	array_thread (getentarray("mortar_team","targetname"), ::mortarTrigger);
}

mortarTeam(spawners, node, mortar_targets, delay_base, delay_range)
{
	// This command can be called directly from script
	ent = spawnStruct();
	ent.delay_base = delay_base;
	ent.delay_range = delay_range;
	ent thread mortarTeamSpawn(spawners, node, mortar_targets);
	return ent;
}

mortarTrigger()
{	
	spawner = getent(self.target,"targetname");
	spawner endon ("death");
	self waittill ("trigger");
	spawner mortarSpawner(self);
}

mortarSpawner(delayEnt)
{	
	if (!isdefined (delayEnt))
		delayEnt = self;
		
	// wrapper that interfaces with radiant to make mortar guys easier to setup
	spawners[0] = self;
	
	// Optionally target a spawner for an aimguy
	aimguySpawner = getent(self.target,"targetname");
	if (isdefined (aimguySpawner))
		spawners[1] = aimGuySpawner;
		
	// required target of a destination node or nodes
	node = random(getnodearray(self.target,"targetname"));
	assertEx(isdefined(node), "Mortar_team spawner at origin " + self.origin + " must target a node or nodes");
	assertEx(isdefined(node.target), "Mortar node at origin " + node.origin + " must target script origins for mortar targetting");
	
	mortar_targets = getentarray(node.target, "targetname");

	delay_base = 0;
	delay_range = 0;
	if (isdefined (delayEnt.script_delay))
		delay_base = delayEnt.script_delay;
	else
	if (isdefined (delayEnt.script_delay_min))
	{
		delay_base = delayEnt.script_delay_min;
		delay_range = delayEnt.script_delay_max - delayEnt.script_delay_min;
	}
	
	ent = mortarTeam(spawners, node, mortar_targets, delay_base, delay_range);
	return ent;
}

mortarTeamSpawn(spawners, node, mortar_targets)
{
	assertex(isdefined(level.scr_anim["loadguy"]), "Add maps\_mortarteam::anims(); to the top of your script");
	assertex(isdefined(level.mortar), "Define the level.mortar effect that should be used");	
	assertex(spawners.size <= 2, "Mortarteams can't support more than 2 spawners");
	assertex(spawners.size, "Mortarteams need at least 1 spawner");
	name[0] = "loadguy";
	name[1] = "aimguy";
	
	if (!isdefined (node.mortarSetup))
		node.mortarSetup = false; // for making followup spawners not bring a mortar
	mortarThink[0] = ::loadGuy;
	mortarThink[1] = ::aimGuy;
	
	self.objectivePositionEntity = undefined;
	self.setup = false;
	
	if (!isdefined (node.mortarTeamActive))
		node.mortarTeamActive = false;
	assertEx(!node.mortarTeamActive, "Mortarteam that runs to " + node.origin + " has multiple mortar teams active on it. Can only have 1 team at a time operating each unique mortar.");
	
	index = 0;
	for (;;)
	{
		spawners[index].count = 1;
		spawners[index].script_moveoverride = 1;
		spawn = spawners[index] dospawn();
		if (spawn_failed(spawn))
		{
			wait (1);
			continue;
		}
		
		node.mortarTeamActive = true;

		self.guy[index] = spawn;
		spawn.animname = name[index];
		if (spawn.health < 5000)
			spawn.health = 1;
		spawn thread [[mortarThink[index]]](self, node);
		index++;
		if (index >= spawners.size)
			break;
	}

	self waittill ("loadguy_done");
	if (!isalive(self.loadGuy))
	{
		// if the carrier dies, the whole sequence ends there
		node.mortarTeamActive = false;
		self notify ("mortar_done");
		return;
	}

	node.mortarEnt = self;	
	node.mortarEnt endon ("stop_mortar");
	self.node = node; // so we can externally refer to the node to make the scene stop
	node.mortar_targets = mortar_targets;
	if (isalive(self.aimGuy))
		self thread transferObjectivePositionEntity();
	for (;;)
	{
		if (isalive(self.loadGuy))
		{
			if (isalive(self.aimGuy) && self.aimGuy.ready)
				dualMortarUntilDeath(node);
			else
				singleMortarOneRep(node);
		}
		else
		if (isalive(self.aimGuy))
			aimGuyMortarsUntilDeath(node);
		else
			break;
	}
	
	node notify ("stopIdle");
	
	// wait until the end of the frame in case the guy dies while playing the firing animation on the exact same frame
	// that the fire notetrack gets hit and thus potentially causing the mortarEnt to become undefined just as it needs
	// it for firing it.
	waittillframeend; 
	
	node.mortarEnt = undefined;
	node.mortar_targets = undefined;
	node.mortarTeamActive = false;	//was true
	self notify ("mortar_done");
}

transferObjectivePositionEntity()
{
	self.loadGuy waittill ("death");
	if (isalive(self.aimGuy))
		self.objectivePositionEntity = self.aimGuy;
}

singleMortarOneRep(node)
{
	// Make the loadguy fire the mortar once
	loadGuy = self.loadGuy;
	loadGuy endon ("death");
	if (loadGuy.health < 5000)
		loadGuy.health = 1;

	node notify ("stopIdle"); // in case we broke abruptly from a previous loop to start this one

	loadGuy animscripts\shared::placeWeaponOn( self.weapon, "none" );
	node thread anim_loop_solo(loadGuy, "wait_idle", undefined, "stopIdle");
	wait (self.delay_base + randomfloat(self.delay_range));
	node notify ("stopIdle");
	node anim_single_solo(loadGuy, "pickup");
	node anim_single_solo(loadGuy, "fire");
}

aimGuyMortarsUntilDeath(node)
{
	// make the aimguy fire the mortar until he dies
	aimGuy = self.aimGuy;
	if (aimGuy.health < 5000)
		aimGuy.health = 1;
	aimGuy endon ("death");
	aimGuy endon ("stop_mortar");
	
	node notify ("stopIdle");
	node anim_reach_solo(aimGuy, "pickup");
	aimGuy animscripts\shared::placeWeaponOn( self.weapon, "none" );
	aimGuy.deathanim = %crouch_death_clutchchest;
	for (;;)
	{
		node notify ("stopIdle"); // in case we broke abruptly from a previous loop to start this one
		node thread anim_loop_solo(aimGuy, "wait_idle", undefined, "stopIdle");
		wait (self.delay_base + randomfloat(self.delay_range));
		node notify ("stopIdle");
		node anim_single_solo (aimGuy, "pickup_alone");
		node anim_single_solo (aimGuy, "fire_alone");
	}
}

dualMortarUntilDeath(node)
{
	// make the loadguy and aimguy fire the mortar until either dies
	loadGuy = self.loadGuy;
	aimGuy = self.aimGuy;
	guy = self.guy;
	if (loadGuy.health < 5000)
		loadGuy.health = 1;
	if (aimGuy.health < 5000)
		aimGuy.health = 1;
		
	loadGuy endon ("death");
	aimGuy endon ("death");
	loadGuy endon ("stop_mortar");
	aimGuy endon ("stop_mortar");
	
	node notify ("stopIdle"); // in case we broke abruptly from a previous loop to start this one
	node thread anim_loop_solo(loadGuy, "wait_idle", undefined, "stopIdle");
	node anim_reach_solo (aimGuy, "fire");
	node notify ("stopIdle");

	loadGuy animscripts\shared::placeWeaponOn( self.weapon, "none" );
	aimGuy animscripts\shared::placeWeaponOn( self.weapon, "none" );
	aimGuy.deathanim = %crouch_death_clutchchest;
	for (;;)
	{
		node thread anim_loop(guy, "wait_idle", undefined, "stopIdle");
		wait (self.delay_base + randomfloat(self.delay_range));
		node notify ("stopIdle");
		node anim_single (guy, "pickup");
		node anim_single (guy, "fire");
	}
}

aimGuy(ent, node)
{
//	self thread debugOrigin();
	ent.aimGuy = self;
	
	self endon ("death");
	self.ready = false;

	self.allowDeath = true;
	self setgoalnode (node);
	if (node.radius > 0)
		self.goalradius = node.radius;
	else
		self.goalradius = 350;
		
	self waittill ("goal");
	self.ready = true;
	thread detachMortarOnDeath();
}

deathNotify(ent)
{
	ent endon ("loadguy_done");
	self waittill ("death");
	ent notify ("loadguy_done");
}

loadGuy(ent, node)
{
//	self thread debugOrigin();

	ent.loadGuy = self;
	ent.objectivePositionEntity = self;
	
	ent notify ("objective_created");


	self endon ("death");
	self thread deathNotify(ent);
	self.allowDeath = true;
//	self.combat_runanim = %mortar_loadguy_run;
	self.run_combatanim = %mortar_loadguy_run;
	self.deathanim = %crouch_death_clutchchest;

	thread detachMortarOnDeath();

	if (node.mortarSetup)
	{
		// if the mortar is already setup
		node anim_reach_solo(self, "pickup");
		ent.mortar = node.mortar;
		ent.setup = true;
		ent notify ("loadguy_done");
		return;
	}

	animscripts\shared::placeWeaponOn( self.weapon, "none" );
	self attach ("prop_mortar", "TAG_WEAPON_LEFT");
	self setanimknob(%mortar_closed_setup, 1, 0, 1);
	setupAnim[0] = %mortar_loadguy_setup;
	setupString[0] = "setup_straight";
	setupAnim[1] = %mortar_loadguy_setup_left;
	setupString[1] = "setup_left";
	setupAnim[2] = %mortar_loadguy_setup_right;
	setupString[2] = "setup_right";
	dist = undefined;
	for (i=0;i<setupAnim.size;i++)
		dist[i] = distance(self.origin, getstartorigin (node.origin, node.angles, setupAnim[i]));

	index = 0;
	current_dist = dist[0];
	for (i=1;i<dist.size;i++)
	{
		if (dist[i] >= current_dist)
			continue;
		index = i;
		current_dist = dist[i];
	}
	
	node anim_reach_solo(self, setupString[index]);

	ent notify ("loadguy_starting");

	node thread anim_single_solo(self, setupString[index]);
	self waittillmatch ("single anim", "open_mortar");
	if (soundexists("weapon_setup"))
		thread play_sound_in_space("weapon_setup");
	self setanimknob(%mortar_open_setup, 1, 0, 1);
	node waittill (setupString[index]);
	
	mortar = spawn ("script_model", (0,0,0));
	mortar.origin = self gettagorigin ("TAG_WEAPON_LEFT");
	mortar.angles = self gettagangles ("TAG_WEAPON_LEFT");
	mortar setmodel ("prop_mortar");
	
	node.mortarSetup = true;
	ent.mortar = mortar;
	node.mortar = mortar;
	self detach ("prop_mortar", "TAG_WEAPON_LEFT");
	ent.setup = true;
	ent notify ("loadguy_done");
	ent notify ("mortar_setup_finished", self.script_squadname);
}

fire(guy)
{
	if (!isalive(guy))
		return;
		
	mortarEnt = self.mortarEnt;
	mortar_targets = self.mortar_targets;
	mortar = mortarEnt.mortar;
	org = guy.origin;
	wait (0.25);
	
	switch (randomint(3))
	{
		case 1:
			thread play_sound_in_space("weap_mortar_fire", org);
			break;
		case 2:
			thread play_sound_in_space("weap_mortar_fire_alt", org);
			break;
		default:
			thread play_sound_in_space("weap_mortar_fire", org);
			break;
	}
	wait (0.4);
	
	playfxontag(level._effect["mortar_flash"], mortar, "TAG_flash");
	target = random(mortar_targets);
	
	if(isdefined(mortarEnt))
		mortarEnt notify ("mortar_fired");
	
	if(isdefined(level.timetoimpact))
	{
		wait level.timetoimpact;
	}
	else
	{
		wait (distance (self.origin, target.origin) * 0.0008);
		switch (randomint(4))
		{
			case 1:
				play_sound_in_space("mortar_incoming1", target.origin);
				break;
			case 2:
				play_sound_in_space("mortar_incoming2", target.origin);
				break;
			case 3:
				play_sound_in_space("mortar_incoming3", target.origin);
				break;
			default:
				play_sound_in_space("mortar_incoming1", target.origin);
				break;
		}
		
		wait 0.35;
	}
	
	if(!isdefined(level.explosionhide))
	{
		thread play_sound_in_space("mortar_explosion", target.origin);
		playfx(level.mortar, target.origin);
	}
}

attachMortar(guy)
{
	if (!isdefined (guy.mortarAmmo))
		guy.mortarAmmo = false;
	if (!guy.mortarAmmo)
		guy attach("prop_mortar_ammunition", "TAG_WEAPON_RIGHT");
	guy.mortarAmmo = true;
}

detachMortar(guy)
{
	if (guy.mortarAmmo)
	{
		guy detach("prop_mortar_ammunition", "TAG_WEAPON_RIGHT");
		thread fire(guy);
	}
	guy.mortarAmmo = false;
}

detachMortarOnDeath()
{
	self waittill ("death");
	if (!isdefined (self.mortarAmmo))
		return;
	if (!self.mortarAmmo)
		return;

	self detach("prop_mortar_ammunition", "TAG_WEAPON_RIGHT");
	self.mortarAmmo = false;
}

anims()
{
	precacheModel("prop_mortar");
	precacheModel("prop_mortar_ammunition");
	level._effect["mortar_flash"] = loadfx("muzzleflashes/mortar_flash");

	level.scr_anim["loadguy"]["ready_idle"][0] 	= %mortar_loadguy_readyidle;
	level.scr_anim["loadguy"]["wait_idle"][0] 	= %mortar_loadguy_waitidle;
	level.scr_anim["loadguy"]["wait_idle"][1] 	= %mortar_loadguy_waittwitch;
	level.scr_anim["loadguy"]["fire"]		 	= %mortar_loadguy_fire;
	level.scr_anim["loadguy"]["pickup"]		 	= %mortar_loadguy_pickup;
	level.scr_anim["loadguy"]["setup_straight"]	= %mortar_loadguy_setup;
	level.scr_anim["loadguy"]["setup_left"]		= %mortar_loadguy_setup_left;
	level.scr_anim["loadguy"]["setup_right"]	= %mortar_loadguy_setup_right;

//	addNotetrack_attach("loadguy", "attach shell = right", "prop_mortar_ammunition", "TAG_WEAPON_RIGHT");
//	addNotetrack_detach("loadguy", "detach shell = right", "prop_mortar_ammunition", "TAG_WEAPON_RIGHT");
//	addNotetrack_customFunction("loadguy", "fire", ::fire);
	addNotetrack_customFunction("loadguy", "attach shell = right", ::attachMortar);
	addNotetrack_customFunction("loadguy", "detach shell = right", ::detachMortar);
	
	level.scr_anim["aimguy"]["ready_idle"][0]		= %mortar_aimguy_readyidle;
	level.scr_anim["aimguy"]["ready_alone_idle"][0]	= %mortar_aimguy_readyidle_alone;
	level.scr_anim["aimguy"]["wait_idle"][0]		= %mortar_aimguy_waitidle;
	level.scr_anim["aimguy"]["wait_idle"][1]		= %mortar_aimguy_waittwitch;
	level.scr_anim["aimguy"]["fire"] 				= %mortar_aimguy_fire;
	level.scr_anim["aimguy"]["pickup"]			 	= %mortar_aimguy_pickup;
	level.scr_anim["aimguy"]["pickup_alone"] 		= %mortar_aimguy_pickup_alone;
	level.scr_anim["aimguy"]["fire_alone"] 			= %mortar_aimguy_fire_alone;
	
//	addNotetrack_attach("aimguy", "attach shell = right", "prop_mortar_ammunition", "TAG_WEAPON_RIGHT");
//	addNotetrack_detach("aimguy", "detach shell = right", "prop_mortar_ammunition", "TAG_WEAPON_RIGHT");
//	addNotetrack_customFunction("aimguy", "fire", ::fire);
	addNotetrack_customFunction("aimguy", "attach shell = right", ::attachMortar);
	addNotetrack_customFunction("aimguy", "detach shell = right", ::detachMortar);
}