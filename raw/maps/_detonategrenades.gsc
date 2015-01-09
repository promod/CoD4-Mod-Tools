#include common_scripts\utility;
#include maps\_utility;

init()
{
	level._effect[ "c4_light_blink" ] = loadfx( "misc/light_c4_blink" );
	level._effect[ "claymore_laser" ] = loadfx( "misc/claymore_laser" );
}

watchGrenadeUsage()
{
	level.c4explodethisframe = false;
	self endon( "death" );
	self.c4array = [];
	self.throwingGrenade = false;
	
	thread watchC4();
	thread watchC4Detonation();
	thread watchClaymores();
	
	for ( ;; )
	{
		self waittill ( "grenade_pullback", weaponName );
		self.throwingGrenade = true;
		
		if ( weaponName == "c4" )
			self beginC4Tracking();
		else if( weaponName == "smoke_grenade_american" )
			self beginsmokegrenadetracking();
		else
			self beginGrenadeTracking();
	}
}

beginsmokegrenadetracking()
{
	self waittill ( "grenade_fire", grenade, weaponName );
	if(!isdefined( level.smokegrenades ) )
		level.smokegrenades = 0;
	if( level.smokegrenades > 2 && getdvar("player_sustainAmmo") != "0" )
		grenade delete();
	else
		grenade thread smoke_grenade_death();

	
}

smoke_grenade_death()
{
	level.smokegrenades ++;
	wait 50;
	level.smokegrenades --;
}

beginGrenadeTracking()
{
	self endon ( "death" );
	
	self waittill ( "grenade_fire", grenade, weaponName );
//	if ( weaponName == "frag_grenade_mp" )
//		grenade thread maps\mp\gametypes\_shellshock::grenade_earthQuake();
		
	self.throwingGrenade = false;
}


beginC4Tracking()
{
	self endon ( "death" );
	
	self waittill_any ( "grenade_fire", "weapon_change" );
	self.throwingGrenade = false;
}


watchC4()
{
	//maxc4 = 2;

	while(1)
	{
		self waittill( "grenade_fire", c4, weapname );
		if ( weapname == "c4" )
		{
			/*if ( self.c4array.size >= maxc4 )
			{
				newarray = [];
				for ( i = 0; i < self.c4array.size; i++ )
				{
					if ( isdefined(self.c4array[i]) )
						newarray[newarray.size] = self.c4array[i];
				}
				self.c4array = newarray;
				for ( i = 0; i < self.c4array.size - maxc4 + 1; i++ )
				{
					self.c4array[i] delete();
				}
				newarray = [];
				for ( i = 0; i < maxc4 - 1; i++ )
				{
					newarray[i] = self.c4array[self.c4array.size - maxc4 + 1 + i];
				}
				self.c4array = newarray;
			}*/
			self.c4array[self.c4array.size] = c4;
			if(self.c4array.size > 15 && getdvar("player_sustainAmmo") != "0" )
				self.c4array[0] delete();
			c4.owner = self;
//			c4 thread maps\mp\gametypes\_shellshock::c4_earthQuake();
			c4 thread c4Damage();
			self thread c4death( c4 );
			c4 thread playC4Effects();
		}
	}
}

c4death( c4 )
{
	// this allows me to delete the first one thrown and reconstruct the array for cheats that enable all the ammo. - Nate
	c4 waittill ("death");
	self.c4array = array_remove_nokeys( self.c4array, c4 );
}

watchClaymores()
{
	self endon( "spawned_player" );
	self endon( "disconnect" );

	while(1)
	{
		self waittill( "grenade_fire", claymore, weapname );
		if ( weapname == "claymore" || weapname == "claymore_mp" )
		{
			claymore.owner = self;
			claymore thread c4Damage();
			claymore thread claymoreDetonation();
			claymore thread playClaymoreEffects();
		}
	}
}

waitTillNotMoving()
{
	prevorigin = self.origin;
	while(1)
	{
		wait .1;
		if ( self.origin == prevorigin )
			break;
		prevorigin = self.origin;
	}
}

claymoreDetonation()
{
	self endon("death");
	
	// wait until we settle
	self waitTillNotMoving();
	
	detonateRadius = 192;//matches MP
	
	damagearea = spawn("trigger_radius", self.origin + (0,0,0-detonateRadius), 9, detonateRadius, detonateRadius*2);

	self thread deleteOnDeath( damagearea );
	
	if(!isdefined(level.claymores))
		level.claymores = [];
	level.claymores = array_add( level.claymores, self );
	
	if( level.claymores.size > 15 && getdvar("player_sustainAmmo") != "0" )
		level.claymores[0] delete();
	
	while(1)
	{
		damagearea waittill( "trigger", ent );
		
		if ( isdefined( self.owner ) && ent == self.owner )
			continue;

		if ( ent == level.player ) 
			continue; // no enemy claymores in SP.

		if ( ent damageConeTrace(self.origin, self) > 0 )
		{
			self playsound ("claymore_activated_SP");
			wait 0.4;
			if ( isdefined( self.owner ) )
				self detonate( self.owner );
			else
				self detonate( undefined );
				
			return;
		}
	}
}

deleteOnDeath(ent)
{
	self waittill("death");
	// stupid getarraykeys in array_remove reversing the order - nate
	level.claymores = array_remove_nokeys( level.claymores, self );
	wait .05;
	if ( isdefined( ent ) )
		ent delete();
}

watchC4Detonation()
{
	self endon("death");
	while(1)
	{
		self waittill( "detonate" );
		weap = self getCurrentWeapon();
		if ( weap == "c4" )
		{
			for ( i = 0; i < self.c4array.size; i++ )
			{
				if ( isdefined(self.c4array[i]) )
					self.c4array[i] thread waitAndDetonate( 0.1 );
			}
			self.c4array = [];
		}
	}
}

waitAndDetonate( delay )
{
	self endon("death");
	wait delay;

	self detonate();
}


c4Damage()
{
//	self endon( "death" );

	self.health = 100;
	self setcandamage(true);
	self.maxhealth = 100000;
	self.health = self.maxhealth;
	
	attacker = undefined;
	
	while(1)
	{
		self waittill("damage", amount, attacker);
		if ( !isplayer(attacker) )
			continue;

		// don't allow people to destroy C4 on their team if FF is off
//		if ( !friendlyFireCheck(self.owner, attacker) )
//			continue;
		
		break;
	}
	
	if ( level.c4explodethisframe )
		wait .1 + randomfloat(.4);
	else
		wait .05;
	
	if (!isdefined(self))
		return;
	
	level.c4explodethisframe = true;
	
	thread resetC4ExplodeThisFrame();
	
	self detonate( attacker );
	// won't get here; got death notify.
}

resetC4ExplodeThisFrame()
{
	wait .05;
	level.c4explodethisframe = false;
}

saydamaged(orig, amount)
{
	for (i = 0; i < 60; i++)
	{
		print3d(orig, "damaged! " + amount);
		wait .05;
	}
}


playC4Effects()
{
	self endon("death");
	
	self waitTillNotMoving();
	
	PlayFXOnTag( getfx( "c4_light_blink" ), self, "tag_fx" );
}

playClaymoreEffects()
{
	self endon("death");
	
	self waitTillNotMoving();
	
	PlayFXOnTag( getfx( "claymore_laser" ), self, "tag_fx" );
}

clearFXOnDeath( fx )
{
	self waittill("death");
	fx delete();
}



// these functions are used with scripted weapons (like c4, claymores, artillery)
// returns an array of objects representing damageable entities (including players) within a given sphere.
// each object has the property damageCenter, which represents its center (the location from which it can be damaged).
// each object also has the property entity, which contains the entity that it represents.
// to damage it, call damageEnt() on it.
getDamageableEnts(pos, radius, doLOS, startRadius)
{
	ents = [];
	
	if (!isdefined(doLOS))
		doLOS = false;
		
	if ( !isdefined( startRadius ) )
		startRadius = 0;
	
	// players
	players = getentarray("player", "classname");
	for (i = 0; i < players.size; i++)
	{
		if (!isalive(players[i]) || players[i].sessionstate != "playing")
			continue;
		
		playerpos = players[i].origin + (0,0,32);
		dist = distance(pos, playerpos);
		if (dist < radius && (!doLOS || weaponDamageTracePassed(pos, playerpos, startRadius, undefined)))
		{
			newent = spawnstruct();
			newent.isPlayer = true;
			newent.isADestructable = false;
			newent.entity = players[i];
			newent.damageCenter = playerpos;
			ents[ents.size] = newent;
		}
	}
	
	// grenades
	grenades = getentarray("grenade", "classname");
	for (i = 0; i < grenades.size; i++)
	{
		entpos = grenades[i].origin;
		dist = distance(pos, entpos);
		if (dist < radius && (!doLOS || weaponDamageTracePassed(pos, entpos, startRadius, grenades[i])))
		{
			newent = spawnstruct();
			newent.isPlayer = false;
			newent.isADestructable = false;
			newent.entity = grenades[i];
			newent.damageCenter = entpos;
			ents[ents.size] = newent;
		}
	}
	
	destructables = getentarray("destructable", "targetname");
	for (i = 0; i < destructables.size; i++)
	{
		entpos = destructables[i].origin;
		dist = distance(pos, entpos);
		if (dist < radius && (!doLOS || weaponDamageTracePassed(pos, entpos, startRadius, destructables[i])))
		{
			newent = spawnstruct();
			newent.isPlayer = false;
			newent.isADestructable = true;
			newent.entity = destructables[i];
			newent.damageCenter = entpos;
			ents[ents.size] = newent;
		}
	}
	
	return ents;
}

weaponDamageTracePassed(from, to, startRadius, ignore)
{
	midpos = undefined;
	
	diff = to - from;
	if ( lengthsquared( diff ) < startRadius*startRadius )
		midpos = to;
	dir = vectornormalize( diff );
	midpos = from + (dir[0]*startRadius, dir[1]*startRadius, dir[2]*startRadius);

	trace = bullettrace(midpos, to, false, ignore);
	
	if ( getdvarint("scr_damage_debug") != 0 )
	{
		if (trace["fraction"] == 1)
		{
			thread debugline(midpos, to, (1,1,1));
		}
		else
		{
			thread debugline(midpos, trace["position"], (1,.9,.8));
			thread debugline(trace["position"], to, (1,.4,.3));
		}
	}
	
	return (trace["fraction"] == 1);
}

// eInflictor = the entity that causes the damage (e.g. a claymore)
// eAttacker = the player that is attacking
// iDamage = the amount of damage to do
// sMeansOfDeath = string specifying the method of death (e.g. "MOD_PROJECTILE_SPLASH")
// sWeapon = string specifying the weapon used (e.g. "claymore_mp")
// damagepos = the position damage is coming from
// damagedir = the direction damage is moving in
damageEnt(eInflictor, eAttacker, iDamage, sMeansOfDeath, sWeapon, damagepos, damagedir)
{
	if (self.isPlayer)
	{
		self.damageOrigin = damagepos;
		self.entity thread [[level.callbackPlayerDamage]](
			eInflictor, // eInflictor The entity that causes the damage.(e.g. a turret)
			eAttacker, // eAttacker The entity that is attacking.
			iDamage, // iDamage Integer specifying the amount of damage done
			0, // iDFlags Integer specifying flags that are to be applied to the damage
			sMeansOfDeath, // sMeansOfDeath Integer specifying the method of death
			sWeapon, // sWeapon The weapon number of the weapon used to inflict the damage
			damagepos, // vPoint The point the damage is from?
			damagedir, // vDir The direction of the damage
			"none", // sHitLoc The location of the hit
			0 // psOffsetTime The time offset for the damage
		);
	}
	else
	{
		// destructable walls and such can only be damaged in certain ways.
		if (self.isADestructable && (sWeapon == "artillery_mp" || sWeapon == "claymore_mp"))
			return;
		
		self.entity notify("damage", iDamage, eAttacker);
	}
}

debugline(a, b, color)
{
	for (i = 0; i < 30*20; i++)
	{
		line(a,b, color);
		wait .05;
	}
}


onWeaponDamage( eInflictor, sWeapon, meansOfDeath, damage )
{
	self endon ( "death" );

	switch( sWeapon )
	{
		case "concussion_grenade_mp":
			// should match weapon settings in gdt
			radius = 512;
			scale = 1 - (distance( self.origin, eInflictor.origin ) / radius);
			
			time = 1 + (4 * scale);
			
			wait ( 0.05 );
			self shellShock( "concussion_grenade_mp", time );
		break;
		default:
			// shellshock will only be done if meansofdeath is an appropriate type and if there is enough damage.
//			maps\mp\gametypes\_shellshock::shellshockOnDamage( meansOfDeath, damage );
		break;
	}
	
}
