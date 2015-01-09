#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

init()
{
	if ( !level.oldschool )
	{
		deletePickups();
		return;
	}
	
	if ( getdvar( "scr_os_pickupweaponrespawntime" ) == "" )
		setdvar( "scr_os_pickupweaponrespawntime", "15" );
	level.pickupWeaponRespawnTime = getdvarfloat( "scr_os_pickupweaponrespawntime" );
	if ( getdvar( "scr_os_pickupperkrespawntime" ) == "" )
		setdvar( "scr_os_pickupperkrespawntime", "25" );
	level.pickupPerkRespawnTime = getdvarfloat( "scr_os_pickupperkrespawntime" );
	
	thread initPickups();
	
	thread onPlayerConnect();
	
	
	
	oldschoolLoadout = spawnstruct();
	
	oldschoolLoadout.primaryWeapon = "skorpion_mp";
	
	oldschoolLoadout.secondaryWeapon = "beretta_mp";
	
	oldschoolLoadout.inventoryWeapon = "";
	oldschoolLoadout.inventoryWeaponAmmo = 0;
	
	//grenade types: "", "frag", "smoke", "flash"
	oldschoolLoadout.grenadeTypePrimary = "frag";
	oldschoolLoadout.grenadeCountPrimary = 1;
	
	oldschoolLoadout.grenadeTypeSecondary = "";
	oldschoolLoadout.grenadeCountSecondary = 0;
	
	level.oldschoolLoadout = oldschoolLoadout;
	
	// mp_player_join
	level.oldschoolPickupSound = "oldschool_pickup";
	level.oldschoolRespawnSound = "oldschool_return";
	
	level.validPerks = [];
	for( i = 150; i < 199; i++ )
	{
		perk = tableLookup( "mp/statstable.csv", 0, i, 4 );
		if ( issubstr( perk, "specialty_" ) )
			level.validPerks[ level.validPerks.size ] = perk;
	}
	
	level.perkPickupHints = [];
	level.perkPickupHints[ "specialty_bulletdamage"			] = &"PLATFORM_PICK_UP_STOPPING_POWER";
	level.perkPickupHints[ "specialty_armorvest"			] = &"PLATFORM_PICK_UP_JUGGERNAUT";
	level.perkPickupHints[ "specialty_rof"					] = &"PLATFORM_PICK_UP_DOUBLE_TAP";
	level.perkPickupHints[ "specialty_pistoldeath"			] = &"PLATFORM_PICK_UP_LAST_STAND";
	level.perkPickupHints[ "specialty_grenadepulldeath"		] = &"PLATFORM_PICK_UP_MARTYRDOM";
	level.perkPickupHints[ "specialty_fastreload"			] = &"PLATFORM_PICK_UP_SLEIGHT_OF_HAND";

	perkPickupKeys = getArrayKeys( level.perkPickupHints ); 

	for ( i = 0; i < perkPickupKeys.size; i++ )
		precacheString( level.perkPickupHints[ perkPickupKeys[i] ] );
}

giveLoadout()
{
	assert( isdefined( level.oldschoolLoadout ) );
	
	loadout = level.oldschoolLoadout;
	
	primaryTokens = strtok( loadout.primaryWeapon, "_" );
	self.pers["primaryWeapon"] = primaryTokens[0];
	
	self maps\mp\gametypes\_teams::playerModelForWeapon( self.pers["primaryWeapon"] );		
	
	self GiveWeapon( loadout.primaryWeapon );
	self giveStartAmmo( loadout.primaryWeapon );
	self setSpawnWeapon( loadout.primaryWeapon );
	
	// give secondary weapon
	self GiveWeapon( loadout.secondaryWeapon );
	self giveStartAmmo( loadout.secondaryWeapon );
	
	self SetActionSlot( 1, "nightvision" );
	
	if ( loadout.inventoryWeapon != "" )
	{
		self GiveWeapon( loadout.inventoryWeapon );
		self maps\mp\gametypes\_class::setWeaponAmmoOverall( loadout.inventoryWeapon, loadout.inventoryWeaponAmmo );
		
		self.inventoryWeapon = loadout.inventoryWeapon;
		
		self SetActionSlot( 3, "weapon", loadout.inventoryWeapon );
		self SetActionSlot( 4, "" );
	}
	else
	{
		self SetActionSlot( 3, "altMode" );
		self SetActionSlot( 4, "" );
	}
	
	if ( loadout.grenadeTypePrimary != "" )
	{
		grenadeTypePrimary = level.weapons[ loadout.grenadeTypePrimary ];
		
		self GiveWeapon( grenadeTypePrimary );
		self SetWeaponAmmoClip( grenadeTypePrimary, loadout.grenadeCountPrimary );
		self SwitchToOffhand( grenadeTypePrimary );
	}
	
	if ( loadout.grenadeTypeSecondary != "" )
	{
		grenadeTypeSecondary = level.weapons[ loadout.grenadeTypeSecondary ];
		
		if ( grenadeTypeSecondary == level.weapons["flash"])
			self setOffhandSecondaryClass("flash");
		else
			self setOffhandSecondaryClass("smoke");
		
		self giveWeapon( grenadeTypeSecondary );
		self SetWeaponAmmoClip( grenadeTypeSecondary, loadout.grenadeCountSecondary );
	}
}

deletePickups()
{
	pickups = getentarray( "oldschool_pickup", "targetname" );
	
	for ( i = 0; i < pickups.size; i++ )
	{
		if ( isdefined( pickups[i].target ) )
			getent( pickups[i].target, "targetname" ) delete();
		pickups[i] delete();
	}
}

initPickups()
{
	level.pickupAvailableEffect = loadfx( "misc/ui_pickup_available" );
	level.pickupUnavailableEffect = loadfx( "misc/ui_pickup_unavailable" );
	
	wait .5; // so all pickups have a chance to spawn and drop to the ground
	
	pickups = getentarray( "oldschool_pickup", "targetname" );
	
	for ( i = 0; i < pickups.size; i++ )
		thread trackPickup( pickups[i], i );
}

spawnPickupFX( groundpoint, fx )
{
	effect = spawnFx( fx, groundpoint, (0,0,1), (1,0,0) );
	triggerFx( effect );
	
	return effect;
}

playEffectShortly( fx )
{
	self endon("death");
	wait .05;
	playFxOnTag( fx, self, "tag_origin" );
}

getPickupGroundpoint( pickup )
{
	trace = bullettrace( pickup.origin, pickup.origin + (0,0,-128), false, pickup );
	groundpoint = trace["position"];
	
	finalz = groundpoint[2];
	
	for ( radiusCounter = 1; radiusCounter <= 3; radiusCounter++ )
	{
		radius = radiusCounter / 3.0 * 50;
		
		for ( angleCounter = 0; angleCounter < 10; angleCounter++ )
		{
			angle = angleCounter / 10.0 * 360.0;
			
			pos = pickup.origin + (cos(angle), sin(angle), 0) * radius;
			
			trace = bullettrace( pos, pos + (0,0,-128), false, pickup );
			hitpos = trace["position"];
			
			if ( hitpos[2] > finalz && hitpos[2] < groundpoint[2] + 15 )
				finalz = hitpos[2];
		}
	}
	return (groundpoint[0], groundpoint[1], finalz);
}

trackPickup( pickup, id )
{
	groundpoint = getPickupGroundpoint( pickup );
	
	effectObj = spawnPickupFX( groundpoint, level.pickupAvailableEffect );
	
	classname = pickup.classname;
	origin = pickup.origin;
	angles = pickup.angles;
	spawnflags = pickup.spawnflags;
	model = pickup.model;
	
	isWeapon = false;
	isPerk = false;
	weapname = undefined;
	perk = undefined;
	trig = undefined;
	respawnTime = undefined;

	if ( issubstr( classname, "weapon_" ) )
	{
		isWeapon = true;
		weapname = pickup maps\mp\gametypes\_weapons::getItemWeaponName();
		respawnTime = level.pickupWeaponRespawnTime;
	}
	else if ( classname == "script_model" )
	{
		isPerk = true;
		perk = pickup.script_noteworthy;
		for ( i = 0; i < level.validPerks.size; i++ )
		{
			if ( level.validPerks[i] == perk )
				break;
		}
		if ( i == level.validPerks.size )
		{
			maps\mp\_utility::error( "oldschool_pickup with classname script_model does not have script_noteworthy set to a valid perk" );
			return;
		}
		trig = getent( pickup.target, "targetname" );
		respawnTime = level.pickupPerkRespawnTime;
		
		if ( !getDvarInt( "scr_game_perks" ) )
		{
			pickup delete();
			trig delete();
			effectObj delete();
			return;
		}
		
		if ( isDefined( level.perkPickupHints[ perk ] ) )
			trig setHintString( level.perkPickupHints[ perk ] );
	}
	else
	{
		maps\mp\_utility::error( "oldschool_pickup with classname " + classname + " is not supported (at location " + pickup.origin + ")" );
		return;
	}
	
	if ( isDefined( pickup.script_delay ) )
		respawnTime = pickup.script_delay;
	
	while(1)
	{
		//pickup thread spinPickup();
		
		player = undefined;
		
		if ( isWeapon )
		{
			pickup thread changeSecondaryGrenadeType( weapname );
			pickup setPickupStartAmmo( weapname );
			
			while(1)
			{
				pickup waittill( "trigger", player, dropped );
				
				if ( !isdefined( pickup ) )
					break;
				
				// player only picked up ammo. the pickup still remains.
				assert( !isdefined( dropped ) );
			}
			
			if ( isdefined( dropped ) )
			{
				dropDeleteTime = 5;
				if ( dropDeleteTime > respawnTime )
					dropDeleteTime = respawnTime;
				dropped thread delayedDeletion( dropDeleteTime );
			}
		}
		else
		{
			assert( isPerk );
			
			/*
			while(1)
			{
				trig waittill( "trigger", player );
				if ( !player hasPerk( perk ) )
					break;
			}
			*/
			
			trig waittill( "trigger", player );
			
			pickup delete();
			trig triggerOff();
		}
		
		if ( isWeapon )
		{
			if ( weaponInventoryType( weapname ) == "item" && (!isdefined( player.inventoryWeapon ) || weapname != player.inventoryWeapon) )
			{
				player removeInventoryWeapon();
				player.inventoryWeapon = weapname;
				player SetActionSlot( 3, "weapon", weapname );
				// this used to reset the action slot to alt mode when your ammo is up for the weapon.
				// however, this isn't safe for C4, which you need to still have even when you have no ammo, so you can detonate.
				//player thread resetActionSlotToAltMode( weapname );
			}
		}
		else
		{
			assert( isPerk );
			
			if ( !player hasPerk( perk ) )
			{
				player setPerk( perk );
				player showPerk( player.numperks, perk, -50 );
				player thread hidePerkNameAfterTime( player.numperks, 3.0 );
				
				player.numPerks++;
			}
		}
		
		thread playSoundinSpace( level.oldschoolPickupSound, origin );
		
		effectObj delete();
		effectObj = spawnPickupFX( groundpoint, level.pickupUnavailableEffect );
		
		wait respawnTime;
		
		pickup = spawn( classname, origin, spawnflags );
		pickup.angles = angles;
		if ( isPerk )
		{
			pickup setModel( model );
			trig triggerOn();
		}
		
		pickup playSound( level.oldschoolRespawnSound );
		
		effectObj delete();
		effectObj = spawnPickupFX( groundpoint, level.pickupAvailableEffect );
	}
}


hidePerkNameAfterTime( index, delay )
{
	self endon("disconnect");
	
	wait delay;
	
	self thread hidePerk( index, 2.0, true );
}


playSoundinSpace( alias, origin )
{
	org = spawn( "script_origin", origin );
	org.origin = origin;
	org playSound( alias  );
	wait 10; // MP doesn't have "sounddone" notifies =(
	org delete();
}

setPickupStartAmmo( weapname )
{
	curweapname = weapname;
	altindex = 0;
	while ( altindex == 0 || (curweapname != weapname && curweapname != "none") )
	{
		allammo = weaponStartAmmo( curweapname );
		clipammo = weaponClipSize( curweapname );
		
		reserveammo = 0;
		if ( clipammo >= allammo )
		{
			clipammo = allammo;
		}
		else
		{
			reserveammo = allammo - clipammo;
		}
		
		self itemWeaponSetAmmo( clipammo, reserveammo, altindex );
		curweapname = weaponAltWeaponName( curweapname );
		altindex++;
	}
}

changeSecondaryGrenadeType( weapname )
{
	self endon("trigger");
	
	if ( weapname != level.weapons["smoke"] && weapname != level.weapons["flash"] && weapname != level.weapons["concussion"] )
		return;
	
	offhandClass = "smoke";
	if ( weapname == level.weapons["flash"] )
		offhandClass = "flash";
	
	trig = spawn( "trigger_radius", self.origin - (0,0,20), 0, 128, 64 );
	self thread deleteTriggerWhenPickedUp( trig );
	
	while(1)
	{
		trig waittill( "trigger", player );
		if ( player getWeaponAmmoTotal( level.weapons["smoke"] ) == 0 && 
			player getWeaponAmmoTotal( level.weapons["flash"] ) == 0 && 
			player getWeaponAmmoTotal( level.weapons["concussion"] ) == 0 )
		{
			player setOffhandSecondaryClass( offhandClass );
		}
	}
}

deleteTriggerWhenPickedUp( trig )
{
	self waittill("trigger");
	trig delete();
}

resetActionSlotToAltMode( weapname )
{
	self notify("resetting_action_slot_to_alt_mode");
	self endon("resetting_action_slot_to_alt_mode");
	
	while(1)
	{
		if ( self getWeaponAmmoTotal( weapname ) == 0 )
		{
			curweap = self getCurrentWeapon();
			if ( curweap != weapname && curweap != "none" )
				break;
		}
		wait .2;
	}
	
	self removeInventoryWeapon();
	self SetActionSlot( 3, "altmode" );
}

getWeaponAmmoTotal( weapname )
{
	return self getWeaponAmmoClip( weapname ) + self getWeaponAmmoStock( weapname );
}

removeInventoryWeapon()
{
	if ( isDefined( self.inventoryWeapon ) )
		self takeWeapon( self.inventoryWeapon );
	self.inventoryWeapon = undefined;
}

spinPickup()
{
	if ( self.spawnflags & 2 || self.classname == "script_model" )
	{
		self endon("death");
		
		org = spawn( "script_origin", self.origin );
		org endon("death");
		
		self linkto( org );
		self thread deleteOnDeath( org );
		
		while(1)
		{
			org rotateyaw( 360, 3, 0, 0 );
			wait 2.9;
		}
	}
}

deleteOnDeath( ent )
{
	ent endon("death");
	self waittill("death");
	ent delete();
}

delayedDeletion( delay )
{
	self thread delayedDeletionOnSwappedWeapons( delay );
	
	wait delay;
	
	if ( isDefined( self ) )
	{
		self notify("death");
		self delete();
	}
}

delayedDeletionOnSwappedWeapons( delay )
{
	self endon("death");
	while(1)
	{
		self waittill( "trigger", player, dropped );
		if ( isdefined( dropped ) )
			break;
	}
	dropped thread delayedDeletion( delay );
}


onPlayerConnect()
{
	for(;;)
	{
		level waittill ( "connecting", player );

		player thread onPlayerSpawned();
	}
}

onPlayerSpawned()
{
	self endon( "disconnect" );

	for(;;)
	{
		self waittill( "spawned_player" );
		
		self.inventoryWeapon = undefined;
		
		self clearPerks();
		self.numPerks = 0;
		self thread clearPerksOnDeath();
		
		self thread watchWeaponsList();
	}
}

clearPerksOnDeath()
{
	self endon("disconnect");
	self waittill("death");
	
	self clearPerks();
	for ( i = 0; i < self.numPerks; i++ )
	{
		self hidePerk( i, 0.05 );
	}
	self.numPerks = 0;
}

watchWeaponsList()
{
	self endon("death");
	
	waittillframeend;
	
	self.weapons = self getWeaponsList();
	
	for(;;)
	{
		self waittill( "weapon_change", newWeapon );
		
		self thread updateWeaponsList( .05 );
	}
}

updateWeaponsList( delay )
{
	self endon("death");
	self notify("updating_weapons_list");
	self endon("updating_weapons_list");
	
	self.weapons = self getWeaponsList();
}

hadWeaponBeforePickingUp( newWeapon )
{
	for ( i = 0; i < self.weapons.size; i++ )
	{
		if ( self.weapons[i] == newWeapon )
			return true;
	}
	return false;
}

