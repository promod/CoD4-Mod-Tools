init()
{
	// level.destructableFX = loadfx("breakables/exp_wall_cinderblock_96");

	ents = getentarray("destructable", "targetname");
	
	if (getdvar("scr_destructables") == "0")
	{
		for (i = 0; i < ents.size; i++)
			ents[i] delete();
	}
	else
	{
		for (i = 0; i < ents.size; i++)
		{
			ents[i] thread destructable_think();
		}
	}
}

destructable_think()
{
	accumulate = 40;
	threshold = 0;

	if (isdefined(self.script_accumulate))
		accumulate = self.script_accumulate;
	if (isdefined(self.script_threshold))
		threshold = self.script_threshold;
	
	if (isdefined(self.script_destructable_area)) {
		areas = strtok(self.script_destructable_area, " ");
		for (i = 0; i < areas.size; i++)
			self blockArea(areas[i]);
	}
	
	if ( isdefined( self.script_fxid ) )
		self.fx = loadfx( self.script_fxid );
	
	dmg = 0;

	self setcandamage(true);
	while(1)
	{
		self waittill("damage", amount, other);
		if (amount >= threshold)
		{
			dmg += amount;
			if (dmg >= accumulate)
			{
				self thread destructable_destruct();
				return;
			}
		}
	}
}

destructable_destruct()
{
	ent = self;
	if (isdefined(self.script_destructable_area)) {
		areas = strtok(self.script_destructable_area, " ");
		for (i = 0; i < areas.size; i++)
			self unblockArea(areas[i]);
	}
	if ( isdefined( ent.fx ) )
		playfx( ent.fx, ent.origin + (0,0,6) );
	ent delete();
}

blockArea(area)
{
	spawns = getentarray("mp_tdm_spawn", "classname");
	blockEntsInArea(spawns, area);
	spawns = getentarray("mp_dm_spawn", "classname");
	blockEntsInArea(spawns, area);
}
blockEntsInArea(ents, area)
{
	for (i = 0; i < ents.size; i++) {
		if (!isdefined(ents[i].script_destructable_area) || ents[i].script_destructable_area != area)
			continue;
		ents[i].blockedoff = true;
	}
}
unblockArea(area)
{
	spawns = getentarray("mp_tdm_spawn", "classname");
	unblockEntsInArea(spawns, area);
	spawns = getentarray("mp_dm_spawn", "classname");
	unblockEntsInArea(spawns, area);
}
unblockEntsInArea(ents, area)
{
	for (i = 0; i < ents.size; i++) {
		if (!isdefined(ents[i].script_destructable_area) || ents[i].script_destructable_area != area)
			continue;
		ents[i].blockedoff = false;
	}
}
