#include common_scripts\utility;
#include maps\mp\_utility;

init()
{
	// assigns weapons with stat numbers from 0-149
	// attachments are now shown here, they are per weapon settings instead
	
	// generating weaponIDs array
	level.weaponIDs = [];
	max_weapon_num = 149;
	attachment_num = 150;
	for( i = 0; i <= max_weapon_num; i++ )
	{
		weapon_name = tablelookup( "mp/statstable.csv", 0, i, 4 );
		if( !isdefined( weapon_name ) || weapon_name == "" )
		{
			level.weaponIDs[i] = "";
			continue;
		}
		level.weaponIDs[i] = weapon_name + "_mp";
		
		// generating attachment combinations
		attachment = tablelookup( "mp/statstable.csv", 0, i, 8 );
		if( !isdefined( attachment ) || attachment == "" )
			continue;
			
		attachment_tokens = strtok( attachment, " " );
		if( !isdefined( attachment_tokens ) )
			continue;
			
		if( attachment_tokens.size == 0 )
		{
			level.weaponIDs[attachment_num] = weapon_name + "_" + attachment + "_mp";
			attachment_num++;
		}
		else
		{
			for( k = 0; k < attachment_tokens.size; k++ )
			{
				level.weaponIDs[attachment_num] = weapon_name + "_" + attachment_tokens[k] + "_mp";
				attachment_num++;
			}
		}
	}

	// generating weaponNames array
	level.weaponNames = [];
	for ( index = 0; index < max_weapon_num; index++ )
	{
		if ( !isdefined( level.weaponIDs[index] ) || level.weaponIDs[index] == "" )
			continue;
			
		level.weaponNames[level.weaponIDs[index]] = index;
	}
	
	// generating weaponlist array
	level.weaponlist = [];
	assertex( isdefined( level.weaponIDs.size ), "level.weaponIDs is corrupted" );
	for( i = 0; i < level.weaponIDs.size; i++ )
	{
		if( !isdefined( level.weaponIDs[i] ) || level.weaponIDs[i] == "" )
			continue;

		level.weaponlist[level.weaponlist.size] = level.weaponIDs[i];
	}

	// based on weaponList array, precache weapons in list
	for ( index = 0; index < level.weaponList.size; index++ )
	{
		precacheItem( level.weaponList[index] );
		println( "Precached weapon: " + level.weaponList[index] );	
	}

	precacheItem( "frag_grenade_short_mp" );
	
	precacheItem( "destructible_car" );	
	
	precacheModel( "weapon_rpg7_stow" );
	
	precacheShellShock( "default" );
	precacheShellShock( "concussion_grenade_mp" );
//	thread maps\mp\_pipebomb::main();
//	thread maps\mp\_ied::main();
	thread maps\mp\_flashgrenades::main();
//	thread maps\mp\_teargrenades::main();
	thread maps\mp\_entityheadicons::init();

	claymoreDetectionConeAngle = 70;
	level.claymoreDetectionDot = cos( claymoreDetectionConeAngle );
	level.claymoreDetectionMinDist = 20;
	level.claymoreDetectionGracePeriod = .75;
	level.claymoreDetonateRadius = 192;
	
	level.C4FXid = loadfx( "misc/light_c4_blink" );
	level.claymoreFXid = loadfx( "misc/claymore_laser" );
	
	level thread onPlayerConnect();
	
	level.c4explodethisframe = false;
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill("connecting", player);

		player.usedWeapons = false;
		player.hits = 0;

		player thread onPlayerSpawned();
	}
}

onPlayerSpawned()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill("spawned_player");

		self.concussionEndTime = 0;
		self.hasDoneCombat = false;
		self thread watchWeaponUsage();
		self thread watchGrenadeUsage();
		self thread watchWeaponChange();
		
		self.droppedDeathWeapon = undefined;
		self.tookWeaponFrom = [];
		
		self thread updateStowedWeapon();
	}
}

watchWeaponChange()
{
	self endon("death");
	self endon("disconnect");
	
	self.lastDroppableWeapon = undefined;
	
	if ( mayDropWeapon( self getCurrentWeapon() ) )
		self.lastDroppableWeapon = self getCurrentWeapon();
	
	while(1)
	{
		self waittill( "weapon_change", newWeapon );
		
		if ( mayDropWeapon( newWeapon ) )
			self.lastDroppableWeapon = newWeapon;
	}
}

isPistol( weapon )
{
	return isdefined( level.side_arm_array[ weapon ] );
}

hasScope( weapon )
{
	if ( isSubStr( weapon, "_acog_" ) )
		return true;
	if ( weapon == "m21_mp" )
		return true;
	if ( weapon == "aw50_mp" )
		return true;
	if ( weapon == "barrett_mp" )
		return true;
	if ( weapon == "dragunov_mp" )
		return true;
	if ( weapon == "m40a3_mp" )
		return true;
	if ( weapon == "remington700_mp" )
		return true;
	return false;
}

isHackWeapon( weapon )
{
	if ( weapon == "radar_mp" || weapon == "airstrike_mp" || weapon == "helicopter_mp" )
		return true;
	if ( weapon == "briefcase_bomb_mp" )
		return true;
	return false;
}

mayDropWeapon( weapon )
{
	if ( weapon == "none" )
		return false;
		
	if ( isHackWeapon( weapon ) )
		return false;
	
	invType = WeaponInventoryType( weapon );
	if ( invType != "primary" )
		return false;
	
	if ( weapon == "none" )
		return false;
	
	if ( !isPrimaryWeapon( weapon ) )
		return false;		
	
	switch ( level.primary_weapon_array[weapon] )
	{
		case "weapon_assault":
			return ( getDvarInt( "class_assault_allowdrop" ) );
		case "weapon_smg":
			return ( getDvarInt( "class_specops_allowdrop" ) );
		case "weapon_sniper":
			return ( getDvarInt( "class_sniper_allowdrop" ) );
		case "weapon_shotgun":
			return ( getDvarInt( "class_demolitions_allowdrop" ) );
		case "weapon_lmg":
			return ( getDvarInt( "class_heavygunner_allowdrop" ) );
	}
	return true;
}

dropWeaponForDeath( attacker )
{
	weapon = self.lastDroppableWeapon;
	
	if ( isdefined( self.droppedDeathWeapon ) )
		return;
	
	if ( !isdefined( weapon ) )
	{
		/#
		if ( getdvar("scr_dropdebug") == "1" )
			println( "didn't drop weapon: not defined" );
		#/
		return;
	}
	
	if ( weapon == "none" )
	{
		/#
		if ( getdvar("scr_dropdebug") == "1" )
			println( "didn't drop weapon: weapon == none" );
		#/
		return;
	}
	
	if ( !self hasWeapon( weapon ) )
	{
		/#
		if ( getdvar("scr_dropdebug") == "1" )
			println( "didn't drop weapon: don't have it anymore (" + weapon + ")" );
		#/
		return;
	}
	
	if ( !(self AnyAmmoForWeaponModes( weapon )) )
	{
		/#
		if ( getdvar("scr_dropdebug") == "1" )
			println( "didn't drop weapon: no ammo for weapon modes" );
		#/
		return;
	}
	
	clipAmmo = self GetWeaponAmmoClip( weapon );
	if ( !clipAmmo )
	{
		/#
		if ( getdvar("scr_dropdebug") == "1" )
			println( "didn't drop weapon: no ammo in clip" );
		#/
		return;
	}

	stockAmmo = self GetWeaponAmmoStock( weapon );
	stockMax = WeaponMaxAmmo( weapon );
	if ( stockAmmo > stockMax )
		stockAmmo = stockMax;

	item = self dropItem( weapon );
	/#
	if ( getdvar("scr_dropdebug") == "1" )
		println( "dropped weapon: " + weapon );
	#/
	
	self.droppedDeathWeapon = true;

	item ItemWeaponSetAmmo( clipAmmo, stockAmmo );
	item itemRemoveAmmoFromAltModes();
	
	item.owner = self;
	item.ownersattacker = attacker;
	
	item thread watchPickup();
	
	item thread deletePickupAfterAWhile();
}

deletePickupAfterAWhile()
{
	self endon("death");
	
	wait 60;

	if ( !isDefined( self ) )
		return;

	self delete();
}

getItemWeaponName()
{
	classname = self.classname;
	assert( getsubstr( classname, 0, 7 ) == "weapon_" );
	weapname = getsubstr( classname, 7 );
	return weapname;
}

watchPickup()
{
	self endon("death");
	
	weapname = self getItemWeaponName();
	
	while(1)
	{
		self waittill( "trigger", player, droppedItem );
		
		if ( isdefined( droppedItem ) )
			break;
		// otherwise, player merely acquired ammo and didn't pick this up
	}
	
	/#
	if ( getdvar("scr_dropdebug") == "1" )
		println( "picked up weapon: " + weapname + ", " + isdefined( self.ownersattacker ) );
	#/

	assert( isdefined( player.tookWeaponFrom ) );
	
	// make sure the owner information on the dropped item is preserved
	droppedWeaponName = droppedItem getItemWeaponName();
	if ( isdefined( player.tookWeaponFrom[ droppedWeaponName ] ) )
	{
		droppedItem.owner = player.tookWeaponFrom[ droppedWeaponName ];
		droppedItem.ownersattacker = player;
		player.tookWeaponFrom[ droppedWeaponName ] = undefined;
	}
	droppedItem thread watchPickup();
	
	// take owner information from self and put it onto player
	if ( isdefined( self.ownersattacker ) && self.ownersattacker == player )
	{
		player.tookWeaponFrom[ weapname ] = self.owner;
	}
	else
	{
		player.tookWeaponFrom[ weapname ] = undefined;
	}
}

itemRemoveAmmoFromAltModes()
{
	origweapname = self getItemWeaponName();
	
	curweapname = weaponAltWeaponName( origweapname );
	
	altindex = 1;
	while ( curweapname != "none" && curweapname != origweapname )
	{
		self itemWeaponSetAmmo( 0, 0, altindex );
		curweapname = weaponAltWeaponName( curweapname );
		altindex++;
	}
}

dropOffhand()
{
	grenadeTypes = [];
	// no dropping of primary grenades.
	//grenadeTypes[grenadeTypes.size] = "frag_grenade_mp";
	// no dropping of secondary grenades.
	//grenadeTypes[grenadeTypes.size] = "smoke_grenade_mp";
	//grenadeTypes[grenadeTypes.size] = "flash_grenade_mp";
	//grenadeTypes[grenadeTypes.size] = "concussion_grenade_mp";

	for ( index = 0; index < grenadeTypes.size; index++ )
	{
		if ( !self hasWeapon( grenadeTypes[index] ) )
			continue;
			
		count = self getAmmoCount( grenadeTypes[index] );
		
		if ( !count )
			continue;
			
		self dropItem( grenadeTypes[index] );
	}
}

getWeaponBasedGrenadeCount(weapon)
{
	return 2;
}

getWeaponBasedSmokeGrenadeCount(weapon)
{
	return 1;
}

getFragGrenadeCount()
{
	grenadetype = "frag_grenade_mp";

	count = self getammocount(grenadetype);
	return count;
}

getSmokeGrenadeCount()
{
	grenadetype = "smoke_grenade_mp";

	count = self getammocount(grenadetype);
	return count;
}


watchWeaponUsage()
{
	self endon( "death" );
	self endon( "disconnect" );
	level endon ( "game_ended" );
	
	self.firingWeapon = false;
	
	for ( ;; )
	{	
		self waittill ( "begin_firing" );
		self.hasDoneCombat = true;
		self.firingWeapon = true;	
		
		curWeapon = self getCurrentWeapon();
		
		switch ( weaponClass( curWeapon ) )
		{
			case "rifle":
			case "pistol":
			case "mg":
			case "smg":
			case "spread":
				self thread watchCurrentFiring( curWeapon );
				break;
			default:
				break;
		}
		self waittill ( "end_firing" );
		self.firingWeapon = false;
	}
}

watchCurrentFiring( curWeapon )
{
	self endon("disconnect");
	
	startAmmo = self getWeaponAmmoClip( curWeapon );
	wasInLastStand = isDefined( self.lastStand );
	
	self waittill ( "end_firing" );
	
	if ( !self hasWeapon( curWeapon ) )
		return;
	
	// ignore the case where a player is firing as they enter last stand.
	// it makes it too hard to calculate shotsFired properly.
	if ( isDefined( self.lastStand ) && !wasInLastStand )
		return;
	
	shotsFired = startAmmo - (self getWeaponAmmoClip( curWeapon )) + 1;

	if ( isDefined( self.lastStandParams ) && self.lastStandParams.lastStandStartTime == getTime() )
	{
		self.hits = 0;
		return;
	}

	assertEx( shotsFired >= 0, shotsFired + " startAmmo: " + startAmmo + " clipAmmo: " + self getWeaponAmmoclip( curWeapon ) + " w/ " + curWeapon  );	
	if ( shotsFired <= 0 )
		return;
	
	statTotal = self maps\mp\gametypes\_persistence::statGet( "total_shots" ) + shotsFired;		
	statHits  = self maps\mp\gametypes\_persistence::statGet( "hits" ) + self.hits;
	statMisses = self maps\mp\gametypes\_persistence::statGet( "misses" ) + shotsFired - self.hits;
	
	self maps\mp\gametypes\_persistence::statSet( "total_shots", statTotal );
	self maps\mp\gametypes\_persistence::statSet( "hits", statHits );
	self maps\mp\gametypes\_persistence::statSet( "misses", statMisses );
	self maps\mp\gametypes\_persistence::statSet( "accuracy", int(statHits * 10000 / statTotal) );
/*
	printLn( "total:    " + statTotal );
	printLn( "hits:     " + statHits );
	printLn( "misses:   " + statMisses );
	printLn( "accuracy: " + int(statHits * 10000 / statTotal) );
*/
	self.hits = 0;
}

checkHit( sWeapon )
{
	switch ( weaponClass( sWeapon ) )
	{
		case "rifle":
		case "pistol":
		case "mg":
		case "smg":
			self.hits++;
			break;
		case "spread":
			self.hits = 1;
			break;
		default:
			break;
	}
}
/*
updateWeaponUsageStats( startAmmo, endAmmo )
{
	shotsFired = startAmmo - endAmmo + 1;

	if ( shotsFired == 0 )
		return;

	assert( shotsFired >= 0 );

	total = self maps\mp\gametypes\_persistence::statGet( "total_shots" ) + shotsFired;				
	hits  = self maps\mp\gametypes\_persistence::statGet( "hits" );				
	self maps\mp\gametypes\_persistence::statSet( "misses", total - hits );
	self maps\mp\gametypes\_persistence::statSet( "total_shots", total );
	self maps\mp\gametypes\_persistence::statSet( "accuracy", int(hits * 10000 / total) );

	self.clipammo = 0;
	self.weapon = "none";
}
*/

// returns true if damage should be done to the item given its owner and the attacker
friendlyFireCheck( owner, attacker, forcedFriendlyFireRule )
{
	if ( !isdefined(owner) ) // owner has disconnected? allow it
		return true;
	
	if ( !level.teamBased ) // not a team based mode? allow it
		return true;
	
	friendlyFireRule = level.friendlyfire;
	if ( isdefined( forcedFriendlyFireRule ) )
		friendlyFireRule = forcedFriendlyFireRule;
	
	if ( friendlyFireRule != 0 ) // friendly fire is on? allow it
		return true;
	
	if ( attacker == owner ) // owner may attack his own items
		return true;
	
	if (!isdefined(attacker.pers["team"])) // attacker not on a team? allow it
		return true;
	
	if ( attacker.pers["team"] != owner.pers["team"] ) // attacker not on the same team as the owner? allow it
		return true;
	
	return false; // disallow it
}

watchGrenadeUsage()
{
	self endon( "death" );
	self endon( "disconnect" );
	
	self.throwingGrenade = false;
	self.gotPullbackNotify = false;
	
	if ( getdvar("scr_deleteexplosivesonspawn") == "" )
		setdvar("scr_deleteexplosivesonspawn", "1");
	if ( getdvarint("scr_deleteexplosivesonspawn") == 1 )
	{
		// delete c4 from previous spawn
		if ( isdefined( self.c4array ) )
		{
			for ( i = 0; i < self.c4array.size; i++ )
			{
				if ( isdefined(self.c4array[i]) )
					self.c4array[i] delete();
			}
		}
		self.c4array = [];
		// delete claymores from previous spawn
		if ( isdefined( self.claymorearray ) )
		{
			for ( i = 0; i < self.claymorearray.size; i++ )
			{
				if ( isdefined(self.claymorearray[i]) )
					self.claymorearray[i] delete();
			}
		}
		self.claymorearray = [];
	}
	else
	{
		if ( !isdefined( self.c4array ) )
			self.c4array = [];
		if ( !isdefined( self.claymorearray ) )
			self.claymorearray = [];
	}
	
	thread watchC4();
	thread watchC4Detonation();
	thread watchC4AltDetonation();
	thread watchClaymores();
	thread deleteC4AndClaymoresOnDisconnect();
	
	self thread watchForThrowbacks();
	
	for ( ;; )
	{
		self waittill ( "grenade_pullback", weaponName );
		
		self.hasDoneCombat = true;

		if ( weaponName == "claymore_mp" )
			continue;
		
		self.throwingGrenade = true;
		self.gotPullbackNotify = true;
		
		if ( weaponName == "c4_mp" )
			self beginC4Tracking();
		else
			self beginGrenadeTracking();
	}
}


beginGrenadeTracking()
{
	self endon ( "death" );
	self endon ( "disconnect" );
	
	startTime = getTime();
	
	self waittill ( "grenade_fire", grenade, weaponName );
	
	if ( (getTime() - startTime > 1000) )
		grenade.isCooked = true;
	
	if ( weaponName == "frag_grenade_mp" )
	{
		grenade thread maps\mp\gametypes\_shellshock::grenade_earthQuake();
		grenade.originalOwner = self;
	}
		
	self.throwingGrenade = false;
}


beginC4Tracking()
{
	self endon ( "death" );
	self endon ( "disconnect" );
	
	self waittill_any ( "grenade_fire", "weapon_change" );
	self.throwingGrenade = false;
}

watchForThrowbacks()
{
	self endon ( "death" );
	self endon ( "disconnect" );
	
	for ( ;; )
	{
		self waittill ( "grenade_fire", grenade, weapname );
		if ( self.gotPullbackNotify )
		{
			self.gotPullbackNotify = false;
			continue;
		}
		if ( !isSubStr( weapname, "frag_" ) )
			continue;
		
		// no grenade_pullback notify! we must have picked it up off the ground.
		grenade.threwBack = true;
		
		grenade thread maps\mp\gametypes\_shellshock::grenade_earthQuake();
		grenade.originalOwner = self;
	}
}

watchC4()
{
	self endon( "spawned_player" );
	self endon( "disconnect" );

	//maxc4 = 2;

	while(1)
	{
		self waittill( "grenade_fire", c4, weapname );
		if ( weapname == "c4" || weapname == "c4_mp" )
		{
			if ( !self.c4array.size )
				self thread watchC4AltDetonate();
			
			self.c4array[self.c4array.size] = c4;
			c4.owner = self;
			c4.activated = false;
			
			c4 thread maps\mp\gametypes\_shellshock::c4_earthQuake();
			c4 thread c4Activate();
			c4 thread c4Damage();
			c4 thread playC4Effects();
			c4 thread c4DetectionTrigger( self.pers["team"] );
		}
	}
}


watchClaymores()
{
	self endon( "spawned_player" );
	self endon( "disconnect" );

	self.claymorearray = [];
	while(1)
	{
		self waittill( "grenade_fire", claymore, weapname );
		if ( weapname == "claymore" || weapname == "claymore_mp" )
		{
			self.claymorearray[self.claymorearray.size] = claymore;
			claymore.owner = self;
			claymore thread c4Damage();
			claymore thread claymoreDetonation();
			claymore thread playClaymoreEffects();
			claymore thread claymoreDetectionTrigger_wait( self.pers["team"] );
			claymore maps\mp\_entityheadicons::setEntityHeadIcon(self.pers["team"], (0,0,20));
			
			/#
			if ( getdvarint("scr_claymoredebug") )
			{
				claymore thread claymoreDebug();
			}
			#/
		}
	}
}

/#
claymoreDebug()
{
	self waitTillNotMoving();
	self thread showCone( acos( level.claymoreDetectionDot ), level.claymoreDetonateRadius, (1,.85,0) );
	self thread showCone( 60, 256, (1,0,0) );
}

vectorcross( v1, v2 )
{
	return ( v1[1]*v2[2] - v1[2]*v2[1], v1[2]*v2[0] - v1[0]*v2[2], v1[0]*v2[1] - v1[1]*v2[0] );
}

showCone( angle, range, color )
{
	self endon("death");
	
	start = self.origin;
	forward = anglestoforward(self.angles);
	right = vectorcross( forward, (0,0,1) );
	up = vectorcross( forward, right );
	
	fullforward = forward * range * cos( angle );
	sideamnt = range * sin( angle );
	
	while(1)
	{
		prevpoint = (0,0,0);
		for ( i = 0; i <= 20; i++ )
		{
			coneangle = i/20.0 * 360;
			point = start + fullforward + sideamnt * (right * cos(coneangle) + up * sin(coneangle));
			if ( i > 0 )
			{
				line( start, point, color );
				line( prevpoint, point, color );
			}
			prevpoint = point;
		}
		wait .05;
	}
}
#/

waitTillNotMoving()
{
	prevorigin = self.origin;
	while(1)
	{
		wait .15;
		if ( self.origin == prevorigin )
			break;
		prevorigin = self.origin;
	}
}

claymoreDetonation()
{
	self endon("death");
	
	self waitTillNotMoving();
	
	damagearea = spawn("trigger_radius", self.origin + (0,0,0-level.claymoreDetonateRadius), 0, level.claymoreDetonateRadius, level.claymoreDetonateRadius*2);
	self thread deleteOnDeath( damagearea );
	
	while(1)
	{
		damagearea waittill("trigger", player);
		
		if ( getdvarint("scr_claymoredebug") != 1 )
		{
			if ( isdefined( self.owner ) && player == self.owner )
				continue;
			if ( !friendlyFireCheck( self.owner, player, 0 ) )
				continue;
		}
		if ( lengthsquared( player getVelocity() ) < 10 )
			continue;
		
		if ( !player shouldAffectClaymore( self ) )
			continue;
		
		if ( player damageConeTrace( self.origin, self ) > 0 )
			break;
	}
	
	self playsound ("claymore_activated");
	
	wait level.claymoreDetectionGracePeriod;
	
	self maps\mp\_entityheadicons::setEntityHeadIcon("none");
	self detonate();
}

shouldAffectClaymore( claymore )
{
	pos = self.origin + (0,0,32);
	
	dirToPos = pos - claymore.origin;
	claymoreForward = anglesToForward( claymore.angles );
	
	dist = vectorDot( dirToPos, claymoreForward );
	if ( dist < level.claymoreDetectionMinDist )
		return false;
	
	dirToPos = vectornormalize( dirToPos );
	
	dot = vectorDot( dirToPos, claymoreForward );
	return ( dot > level.claymoreDetectionDot );
}

deleteOnDeath(ent)
{
	self waittill("death");
	wait .05;
	if ( isdefined(ent) )
		ent delete();
}

c4Activate()
{
	self endon("death");

	self waittillNotMoving();
	
	wait 0.05;
	
	self notify("activated");
	self.activated = true;
}

watchC4AltDetonate()
{
	self endon("death");
	self endon( "disconnect" );	
	self endon( "detonated" );
	level endon( "game_ended" );
	
	buttonTime = 0;
	for( ;; )
	{
		if ( self UseButtonPressed() )
		{
			buttonTime = 0;
			while( self UseButtonPressed() )
			{
				buttonTime += 0.05;
				wait( 0.05 );
			}
			
			println( "pressTime1: " + buttonTime );
			if ( buttonTime >= 0.5 )
				continue;
			
			buttonTime = 0;				
			while ( !self UseButtonPressed() && buttonTime < 0.5 )
			{
				buttonTime += 0.05;
				wait( 0.05 );
			}
			
			println( "delayTime: " + buttonTime );
			if ( buttonTime >= 0.5 )
				continue;

			if ( !self.c4Array.size )
				return;
				
			self notify ( "alt_detonate" );
		}
		wait ( 0.05 );
	}
}

watchC4Detonation()
{
	self endon("death");
	self endon("disconnect");

	while(1)
	{
		self waittill( "detonate" );
		weap = self getCurrentWeapon();
		if ( weap == "c4_mp" )
		{
			newarray = [];
			for ( i = 0; i < self.c4array.size; i++ )
			{
				c4 = self.c4array[i];
				if ( isdefined(self.c4array[i]) )
				{
					//if ( c4.activated )
					//{
						c4 thread waitAndDetonate( 0.1 );
					//}
					//else
					//{
					//	newarray[ newarray.size ] = c4;
					//}
				}
			}
			self.c4array = newarray;
			self notify ( "detonated" );
		}
	}
}


watchC4AltDetonation()
{
	self endon("death");
	self endon("disconnect");

	while(1)
	{
		self waittill( "alt_detonate" );
		weap = self getCurrentWeapon();
		if ( weap != "c4_mp" )
		{
			newarray = [];
			for ( i = 0; i < self.c4array.size; i++ )
			{
				c4 = self.c4array[i];
				if ( isdefined(self.c4array[i]) )
					c4 thread waitAndDetonate( 0.1 );
			}
			self.c4array = newarray;
			self notify ( "detonated" );
		}
	}
}


waitAndDetonate( delay )
{
	self endon("death");
	wait delay;

	self detonate();
}

deleteC4AndClaymoresOnDisconnect()
{
	self endon("death");
	self waittill("disconnect");
	
	c4array = self.c4array;
	claymorearray = self.claymorearray;
	
	wait .05;
	
	for ( i = 0; i < c4array.size; i++ )
	{
		if ( isdefined(c4array[i]) )
			c4array[i] delete();
	}
	for ( i = 0; i < claymorearray.size; i++ )
	{
		if ( isdefined(claymorearray[i]) )
			claymorearray[i] delete();
	}
}

c4Damage()
{
	self endon( "death" );

	self setcandamage(true);
	self.maxhealth = 100000;
	self.health = self.maxhealth;
	
	attacker = undefined;
	
	while(1)
	{
		self waittill ( "damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, iDFlags );
		if ( !isplayer(attacker) )
			continue;
		
		// don't allow people to destroy C4 on their team if FF is off
		if ( !friendlyFireCheck( self.owner, attacker ) )
			continue;
		
		if ( damage < 5 ) // ignore concussion grenades
			continue;
		
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
	
	self maps\mp\_entityheadicons::setEntityHeadIcon("none");
	
	if ( isDefined( type ) && (isSubStr( type, "MOD_GRENADE" ) || isSubStr( type, "MOD_EXPLOSIVE" )) )
		self.wasChained = true;
	
	if ( isDefined( iDFlags ) && (iDFlags & level.iDFLAGS_PENETRATION) )
		self.wasDamagedFromBulletPenetration = true;
	
	self.wasDamaged = true;
	
	// "destroyed_explosive" notify, for challenges
	if ( isdefined( attacker ) && isdefined( attacker.pers["team"] ) && isdefined( self.owner ) && isdefined( self.owner.pers["team"] ) )
	{
		if ( attacker.pers["team"] != self.owner.pers["team"] )
			attacker notify("destroyed_explosive");
	}
	
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
	self waittill("activated");
	
	while(1)
	{
		org = self getTagOrigin( "tag_fx" );
		ang = self getTagAngles( "tag_fx" );
		
		fx = spawnFx( level.C4FXid, org, anglesToForward( ang ), anglesToUp( ang ) );
		triggerfx( fx );
		
		self thread clearFXOnDeath( fx );
		
		originalOrigin = self.origin;
		
		while(1)
		{
			wait .25;
			if ( self.origin != originalOrigin )
				break;
		}
		
		fx delete();
		self waittillNotMoving();
	}
}


c4DetectionTrigger( ownerTeam )
{
	if ( level.oldschool )
		return;

	self waittill( "activated" );
	
	trigger = spawn( "trigger_radius", self.origin-(0,0,128), 0, 512, 256 );
	trigger.detectId = "trigger" + getTime() + randomInt( 1000000 );

	trigger thread detectIconWaiter( level.otherTeam[ownerTeam] );
		
	self waittill( "death" );
	trigger notify ( "end_detection" );

	if ( isDefined( trigger.bombSquadIcon ) )
		trigger.bombSquadIcon destroy();
	
	trigger delete();
}


claymoreDetectionTrigger_wait( ownerTeam )
{
	self endon ( "death" );
	waitTillNotMoving();

	if ( level.oldschool )
		return;

	self thread claymoreDetectionTrigger( ownerTeam );
}

claymoreDetectionTrigger( ownerTeam )
{
	trigger = spawn( "trigger_radius", self.origin-(0,0,128), 0, 512, 256 );
	trigger.detectId = "trigger" + getTime() + randomInt( 1000000 );
		
	trigger thread detectIconWaiter( level.otherTeam[ownerTeam] );

	self waittill( "death" );
	trigger notify ( "end_detection" );

	if ( isDefined( trigger.bombSquadIcon ) )
		trigger.bombSquadIcon destroy();
	
	trigger delete();	
}


detectIconWaiter( detectTeam )
{
	self endon ( "end_detection" );
	level endon ( "game_ended" );

	while( !level.gameEnded )
	{
		self waittill( "trigger", player );
		
		if ( !isDefined( player.detectExplosives ) || !player.detectExplosives )
			continue;
			
		if ( player.team != detectTeam )
			continue;
			
		if ( isDefined( player.bombSquadIds[self.detectId] ) )
			continue;

		player thread showHeadIcon( self );
		/*
		if ( !isDefined( self.bombSquadIcon ) )
		{
			self.bombSquadIcon = newTeamHudElem( player.pers["team"] );
			self.bombSquadIcon.x = self.origin[0];
			self.bombSquadIcon.y = self.origin[1];
			self.bombSquadIcon.z = self.origin[2]+25+128;
			self.bombSquadIcon.alpha = 0;
			self.bombSquadIcon.archived = true;
			self.bombSquadIcon setShader( "waypoint_bombsquad", 14, 14 );
			self.bombSquadIcon setwaypoint( false );
		}

		self.bombSquadIcon fadeOverTime( 0.25 );
		self.bombSquadIcon.alpha = 0.85;

		while( isAlive( player ) && player isTouching( self ) )
			wait ( 0.05 );
		
		self.bombSquadIcon fadeOverTime( 0.25 );
		self.bombSquadIcon.alpha = 0;
		*/
	}
}


setupBombSquad()
{
	self.bombSquadIds = [];
	
	if ( self.detectExplosives && !self.bombSquadIcons.size )
	{
		for ( index = 0; index < 4; index++ )
		{
			self.bombSquadIcons[index] = newClientHudElem( self );
			self.bombSquadIcons[index].x = 0;
			self.bombSquadIcons[index].y = 0;
			self.bombSquadIcons[index].z = 0;
			self.bombSquadIcons[index].alpha = 0;
			self.bombSquadIcons[index].archived = true;
			self.bombSquadIcons[index] setShader( "waypoint_bombsquad", 14, 14 );
			self.bombSquadIcons[index] setWaypoint( false );
			self.bombSquadIcons[index].detectId = "";
		}
	}
	else if ( !self.detectExplosives )
	{
		for ( index = 0; index < self.bombSquadIcons.size; index++ )
			self.bombSquadIcons[index] destroy();
			
		self.bombSquadIcons = [];
	}
}


showHeadIcon( trigger )
{
	triggerDetectId = trigger.detectId;
	useId = -1;
	for ( index = 0; index < 4; index++ )
	{
		detectId = self.bombSquadIcons[index].detectId;

		if ( detectId == triggerDetectId )
			return;
			
		if ( detectId == "" )
			useId = index;
	}
	
	if ( useId < 0 )
		return;

	self.bombSquadIds[triggerDetectId] = true;
	
	self.bombSquadIcons[useId].x = trigger.origin[0];
	self.bombSquadIcons[useId].y = trigger.origin[1];
	self.bombSquadIcons[useId].z = trigger.origin[2]+24+128;

	self.bombSquadIcons[useId] fadeOverTime( 0.25 );
	self.bombSquadIcons[useId].alpha = 1;
	self.bombSquadIcons[useId].detectId = trigger.detectId;
	
	while ( isAlive( self ) && isDefined( trigger ) && self isTouching( trigger ) )
		wait ( 0.05 );
		
	if ( !isDefined( self ) )
		return;
		
	self.bombSquadIcons[useId].detectId = "";
	self.bombSquadIcons[useId] fadeOverTime( 0.25 );
	self.bombSquadIcons[useId].alpha = 0;
	self.bombSquadIds[triggerDetectId] = undefined;
}


playClaymoreEffects()
{
	self endon("death");
	
	while(1)
	{
		self waittillNotMoving();
		
		org = self getTagOrigin( "tag_fx" );
		ang = self getTagAngles( "tag_fx" );
		fx = spawnFx( level.claymoreFXid, org, anglesToForward( ang ), anglesToUp( ang ) );
		triggerfx( fx );
		
		self thread clearFXOnDeath( fx );
		
		originalOrigin = self.origin;
		
		while(1)
		{
			wait .25;
			if ( self.origin != originalOrigin )
				break;
		}
		
		fx delete();
	}
}

clearFXOnDeath( fx )
{
	fx endon("death");
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
	players = level.players;
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

	destructibles = getentarray("destructible", "targetname");
	for (i = 0; i < destructibles.size; i++)
	{
		entpos = destructibles[i].origin;
		dist = distance(pos, entpos);
		if (dist < radius && (!doLOS || weaponDamageTracePassed(pos, entpos, startRadius, destructibles[i])))
		{
			newent = spawnstruct();
			newent.isPlayer = false;
			newent.isADestructable = false;
			newent.entity = destructibles[i];
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
		
		self.entity notify("damage", iDamage, eAttacker, (0,0,0), (0,0,0), "mod_explosive", "", "" );
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
	self endon ( "disconnect" );

	switch( sWeapon )
	{
		case "concussion_grenade_mp":
			// should match weapon settings in gdt
			radius = 512;
			scale = 1 - (distance( self.origin, eInflictor.origin ) / radius);
			
			if ( scale < 0 )
				scale = 0;
			
			time = 2 + (4 * scale);
			
			wait ( 0.05 );
			self shellShock( "concussion_grenade_mp", time );
			self.concussionEndTime = getTime() + (time * 1000);
		break;
		default:
			// shellshock will only be done if meansofdeath is an appropriate type and if there is enough damage.
			maps\mp\gametypes\_shellshock::shellshockOnDamage( meansOfDeath, damage );
		break;
	}
	
}

// weapon stowing logic ===================================================================

// weapon class boolean helpers
isPrimaryWeapon( weaponname )
{
	return isdefined( level.primary_weapon_array[weaponname] );
}
isSideArm( weaponname )
{
	return isdefined( level.side_arm_array[weaponname] );
}
isInventory( weaponname )
{
	return isdefined( level.inventory_array[weaponname] );
}
isGrenade( weaponname )
{
	return isdefined( level.grenade_array[weaponname] );
}
getWeaponClass_array( current )
{
	if( isPrimaryWeapon( current ) )
		return level.primary_weapon_array;
	else if( isSideArm( current ) )
		return level.side_arm_array;
	else if( isGrenade( current ) )
		return level.grenade_array;
	else
		return level.inventory_array;
}

// thread loop life = player's life
updateStowedWeapon()
{
	self endon( "spawned" );
	self endon( "killed_player" );
	self endon( "disconnect" );
	
	//detach_all_weapons();
	
	self.tag_stowed_back = undefined;
	self.tag_stowed_hip = undefined;
	
	team = self.pers["team"];
	class = self.pers["class"];
	
	while ( true )
	{
		self waittill( "weapon_change", newWeapon );
		
		// weapon array reset, might have swapped weapons off the ground
		self.weapon_array_primary =[];
		self.weapon_array_sidearm = [];
		self.weapon_array_grenade = [];
		self.weapon_array_inventory =[];
	
		// populate player's weapon stock arrays
		weaponsList = self GetWeaponsList();
		for( idx = 0; idx < weaponsList.size; idx++ )
		{
			if ( isPrimaryWeapon( weaponsList[idx] ) )
				self.weapon_array_primary[self.weapon_array_primary.size] = weaponsList[idx];
			else if ( isSideArm( weaponsList[idx] ) )
				self.weapon_array_sidearm[self.weapon_array_sidearm.size] = weaponsList[idx];
			else if ( isGrenade( weaponsList[idx] ) )
				self.weapon_array_grenade[self.weapon_array_grenade.size] = weaponsList[idx];
			else if ( isInventory( weaponsList[idx] ) )
				self.weapon_array_inventory[self.weapon_array_inventory.size] = weaponsList[idx];
		}

		detach_all_weapons();
		stow_on_back();
		stow_on_hip();
	}
}

detach_all_weapons()
{
	if( isDefined( self.tag_stowed_back ) )
	{
		self detach( self.tag_stowed_back, "tag_stowed_back" );
		self.tag_stowed_back = undefined;
	}
	if( isDefined( self.tag_stowed_hip ) )
	{
		detach_model = getWeaponModel( self.tag_stowed_hip );
		self detach( detach_model, "tag_stowed_hip_rear" );
		self.tag_stowed_hip = undefined;
	}
}

stow_on_back()
{
	current = self getCurrentWeapon();

	self.tag_stowed_back = undefined;
	
	//  large projectile weaponry always show
	if ( self hasWeapon( "rpg_mp" ) && current != "rpg_mp" )
	{
		self.tag_stowed_back = "weapon_rpg7_stow";
	}
	else
	{
		for ( idx = 0; idx < self.weapon_array_primary.size; idx++ )
		{
			index_weapon = self.weapon_array_primary[idx];
			assertex( isdefined( index_weapon ), "Primary weapon list corrupted." );
			
			if ( index_weapon == current )
				continue;
				
			if( isSubStr( current, "gl_" ) || isSubStr( index_weapon, "gl_" ) )
			{
				index_weapon_tok = strtok( index_weapon, "_" );
				current_tok = strtok( current, "_" );
				// finding the alt-mode of current weapon; the tokens of both weapons are subsets of each other
				for( i=0; i<index_weapon_tok.size; i++ ) 
				{
					if( !isSubStr( current, index_weapon_tok[i] ) || index_weapon_tok.size != current_tok.size )
					{
						i = 0;
						break;
					}
				}
				if( i == index_weapon_tok.size )
					continue;
			}

			// camo only applicable for custom classes
			/*
			assertex( isdefined( self.curclass ), "Player missing current class" );
			if ( isDefined( self.custom_class ) && isDefined( self.custom_class[self.class_num]["camo_num"] ) && isSubStr( index_weapon, self.pers["primaryWeapon"] ) && isSubStr( self.curclass, "CUSTOM" ) )
				self.tag_stowed_back = getWeaponModel( index_weapon, self.custom_class[self.class_num]["camo_num"] );
			else
			*/
				self.tag_stowed_back = getWeaponModel( index_weapon, 0 );
		}
	}
	
	if ( !isDefined( self.tag_stowed_back ) )
		return;

	self attach( self.tag_stowed_back, "tag_stowed_back", true );
}

stow_on_hip()
{
	current = self getCurrentWeapon();

	self.tag_stowed_hip = undefined;
	/*
	for ( idx = 0; idx < self.weapon_array_sidearm.size; idx++ )
	{
		if ( self.weapon_array_sidearm[idx] == current )
			continue;
			
		self.tag_stowed_hip = self.weapon_array_sidearm[idx];
	}
	*/
	
	for ( idx = 0; idx < self.weapon_array_inventory.size; idx++ )
	{
		if ( self.weapon_array_inventory[idx] == current )
			continue;

		if ( !self GetWeaponAmmoStock( self.weapon_array_inventory[idx] ) )
			continue;
			
		self.tag_stowed_hip = self.weapon_array_inventory[idx];
	}
	
	if ( !isDefined( self.tag_stowed_hip ) )
		return;

	weapon_model = getWeaponModel( self.tag_stowed_hip );
	self attach( weapon_model, "tag_stowed_hip_rear", true );
}


stow_inventory( inventories, current )
{
	// deatch last weapon attached
	if( isdefined( self.inventory_tag ) )
	{
		detach_model = getweaponmodel( self.inventory_tag );
		self detach( detach_model, "tag_stowed_hip_rear" );
		self.inventory_tag = undefined;
	}

	if( !isdefined( inventories[0] ) || self GetWeaponAmmoStock( inventories[0] ) == 0 )
		return;

	if( inventories[0] != current )
	{
		self.inventory_tag = inventories[0];
		weapon_model = getweaponmodel( self.inventory_tag );
		self attach( weapon_model, "tag_stowed_hip_rear", true );
	}
}
