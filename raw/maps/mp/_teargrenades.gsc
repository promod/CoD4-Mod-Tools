main()
{
	level.tearradius = 170;
	level.tearheight = 128;
	level.teargasfillduration = 7; // time until gas fills the area specified
	level.teargasduration = 23; // duration gas remains in area
	level.tearsufferingduration = 3; // (duration after leaving area of effect)
	
	level.teargrenadetimer = 4; // should match time to appearance of effect
	
	precacheShellShock("teargas");
	
	fgmonitor = maps\mp\gametypes\_perplayer::init("tear_grenade_monitor", ::startMonitoringTearUsage, ::stopMonitoringTearUsage);
	maps\mp\gametypes\_perplayer::enable(fgmonitor);
}

startMonitoringTearUsage()
{
	self thread monitorTearUsage();
}
stopMonitoringTearUsage(disconnected)
{
	self notify("stop_monitoring_tear_usage");
}

monitorTearUsage()
{
	self endon("stop_monitoring_tear_usage");
	
	wait .05;
	
	if (!self hasWeapon("tear_grenade_mp"))
		return;
	
	// when this player's tear grenade ammo goes down, assume the nearest "grenade" entity is a tear grenade.
	
	prevammo = self getammocount("tear_grenade_mp");
	while(1)
	{
		ammo = self getammocount("tear_grenade_mp");
		if (ammo < prevammo)
		{
			num = prevammo - ammo;
			iprintln(num);
			for (i = 0; i < num; i++)
			{
				grenades = getEntArray("grenade", "classname");
				bestdist = undefined;
				bestg = undefined;
				for (g = 0; g < grenades.size; g++)
				{
					if (!isdefined(grenades[g].teargrenade))
					{
						dist = distance(grenades[g].origin, self.origin + (0,0,48));
						if (!isdefined(bestdist) || dist < bestdist)
						{
							bestdist = dist;
							bestg = g;
						}
					}
				}
				if (isdefined(bestdist))
				{
					grenades[bestg].teargrenade = true;
					grenades[bestg] thread tearGrenade_think(self.pers["team"]);
				}
			}
		}
		prevammo = ammo;
		wait .05;
	}
}

tearGrenade_think(team)
{
	// wait for death
	
	// (grenade doesn't actually die until finished smoking)
	wait level.teargrenadetimer;
	
	ent = spawnstruct();
	ent thread tear(self.origin);
}

tear(pos)
{
	trig = spawn("trigger_radius", pos, 0, level.tearradius, level.tearheight);
	
	//thread drawcylinder(pos, level.tearradius, level.tearheight);
	
	starttime = gettime();
	
	self thread teartimer();
	self endon("tear_timeout");
	
	while(1)
	{
		trig waittill("trigger", player);
		
		if (player.sessionstate != "playing")
			continue;
		
		time = (gettime() - starttime) / 1000;
		
		currad = level.tearradius;
		curheight = level.tearheight;
		if (time < level.teargasfillduration) {
			currad = currad * (time / level.teargasfillduration);
			curheight = curheight * (time / level.teargasfillduration);
		}
		
		offset = (player.origin + (0,0,32)) - pos;
		offset2d = (offset[0], offset[1], 0);
		if (lengthsquared(offset2d) > currad*currad)
			continue;
		if (player.origin[2] - pos[2] > curheight)
			continue;
		
		player.teargasstarttime = gettime(); // purposely overriding old value
		if (!isdefined(player.teargassuffering))
			player thread teargassuffering();
	}
}
teartimer()
{
	wait level.teargasduration;
	self notify("tear_timeout");
}

teargassuffering()
{
	self endon("death");
	self endon("disconnect");
	
	self.teargassuffering = true;
	
	self shellshock("teargas", 60);
	
	while(1)
	{
		if (gettime() - self.teargasstarttime > level.tearsufferingduration * 1000)
			break;
		
		wait 1;
	}
	
	self shellshock("teargas", 1);
	
	self.teargassuffering = undefined;
}

drawcylinder(pos, rad, height)
{
	time = 0;
	while(1)
	{
		currad = rad;
		curheight = height;
		if (time < level.teargasfillduration) {
			currad = currad * (time / level.teargasfillduration);
			curheight = curheight * (time / level.teargasfillduration);
		}
		
		for (r = 0; r < 20; r++)
		{
			theta = r / 20 * 360;
			theta2 = (r + 1) / 20 * 360;
			
			line(pos + (cos(theta) * currad, sin(theta) * currad, 0), pos + (cos(theta2) * currad, sin(theta2) * currad, 0));
			line(pos + (cos(theta) * currad, sin(theta) * currad, curheight), pos + (cos(theta2) * currad, sin(theta2) * currad, curheight));
			line(pos + (cos(theta) * currad, sin(theta) * currad, 0), pos + (cos(theta) * currad, sin(theta) * currad, curheight));
		}
		time += .05;
		if (time > level.teargasduration)
			break;
		wait .05;
	}
}