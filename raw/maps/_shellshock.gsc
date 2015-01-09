main(duration, nMaxDamageBase, nRanDamageBase, nMinDamageBase, nExposed, customShellShock)
{
	level thread internalMain(duration, nMaxDamageBase, nRanDamageBase, nMinDamageBase, nExposed, customShellShock);
}

internalMain(duration, nMaxDamageBase, nRanDamageBase, nMinDamageBase, nExposed, customShellShock)
{
	if(!isdefined(duration))
	{
		duration = 12;
	}
	else
	if(duration < 7)
	{
		duration = 7;
	}
	
	if(!isdefined(nMaxDamageBase))
	{
		nMaxDamageBase = 150;
	}
	
	if(!isdefined(nRanDamageBase))
	{
		nRanDamageBase = 100;
	}
	
	if(!isdefined(nMinDamageBase))
	{
		nMinDamageBase = 100;
	}
	
	if(!isdefined(customShellShock))
	{
		strShocktype = "default";
	}
	else
	{
		strShocktype = customShellShock;
	}
	
		
	origin = (level.player getorigin() + (0,8,2));
	range = 320;
	maxdamage = nMaxDamageBase + randomint(nRanDamageBase); 
	mindamage = nMinDamageBase;
	
	level.player playsound ("weapons_rocket_explosion");
	wait 0.25;
	
	radiusDamage(origin, range, maxdamage, mindamage);
	earthquake(0.75, 2, origin, 2250);
	
	if(isalive(level.player))
	{
		level.player allowStand(false);
		level.player allowCrouch(false);
		level.player allowProne(true);
		
		wait 0.15;
		level.player viewkick(127, level.player.origin);  //Amount should be in the range 0-127, and is normalized "damage".  No damage is done.
		level.player shellshock(strShocktype, duration);
		
		if(!isdefined(nExposed))
		{
			level thread playerHitable (duration);
		}
		
		wait 1.5;
		
		level.player allowStand(true);
		level.player allowCrouch(true);
	}
}

playerHitable ( duration )
{
	level.player.shellshocked = true;
	level.player.ignoreme = true;
	level notify ("player is shell shocked");
	level endon ("player is shell shocked");
	wait (duration - 1);
	level.player.shellshocked = false;
	level.player.ignoreme = false;
}