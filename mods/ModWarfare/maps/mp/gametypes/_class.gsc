#include common_scripts\utility;
// check if below includes are removable
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

init()
{
	level.classMap["assault_mp"] = "CLASS_ASSAULT";
	level.classMap["specops_mp"] = "CLASS_SPECOPS";
	level.classMap["heavygunner_mp"] = "CLASS_HEAVYGUNNER";
	level.classMap["demolitions_mp"] = "CLASS_DEMOLITIONS";		
	level.classMap["sniper_mp"] = "CLASS_SNIPER";
	
	level.classMap["offline_class1_mp"] = "OFFLINE_CLASS1";
	level.classMap["offline_class2_mp"] = "OFFLINE_CLASS2";
	level.classMap["offline_class3_mp"] = "OFFLINE_CLASS3";
	level.classMap["offline_class4_mp"] = "OFFLINE_CLASS4";
	level.classMap["offline_class5_mp"] = "OFFLINE_CLASS5";
	level.classMap["offline_class6_mp"] = "OFFLINE_CLASS6";
	level.classMap["offline_class7_mp"] = "OFFLINE_CLASS7";
	level.classMap["offline_class8_mp"] = "OFFLINE_CLASS8";
	level.classMap["offline_class9_mp"] = "OFFLINE_CLASS9";
	level.classMap["offline_class10_mp"] = "OFFLINE_CLASS10";	
	
	level.classMap["custom1"] = "CLASS_CUSTOM1";
	level.classMap["custom2"] = "CLASS_CUSTOM2";
	level.classMap["custom3"] = "CLASS_CUSTOM3";
	level.classMap["custom4"] = "CLASS_CUSTOM4";
	level.classMap["custom5"] = "CLASS_CUSTOM5";
	
	level.weapons["frag"] = "frag_grenade_mp";
	level.weapons["smoke"] = "smoke_grenade_mp";
	level.weapons["flash"] = "flash_grenade_mp";
	level.weapons["concussion"] = "concussion_grenade_mp";
	level.weapons["c4"] = "c4_mp";
	level.weapons["claymore"] = "claymore_mp";
	level.weapons["rpg"] = "rpg_mp";
	
	level.perkNames = [];
	level.perkIcons = [];

	initPerkData( "specialty_parabolic" );
	initPerkData( "specialty_gpsjammer" );
	initPerkData( "specialty_holdbreath" );
	initPerkData( "specialty_quieter" );
	initPerkData( "specialty_longersprint" );
	initPerkData( "specialty_detectexplosive" );
	initPerkData( "specialty_explosivedamage" );
	initPerkData( "specialty_pistoldeath" );
	initPerkData( "specialty_grenadepulldeath" );
	initPerkData( "specialty_bulletdamage" );
	initPerkData( "specialty_bulletpenetration" );
	initPerkData( "specialty_bulletaccuracy" );
	initPerkData( "specialty_rof" );
	initPerkData( "specialty_fastreload" );
	initPerkData( "specialty_extraammo" );
	initPerkData( "specialty_armorvest" );
	initPerkData( "specialty_fraggrenade" );
	initPerkData( "specialty_specialgrenade" );
	initPerkData( "c4_mp" );
	initPerkData( "claymore_mp" );
	initPerkData( "rpg_mp" );

	// generating weapon type arrays which classifies the weapon as primary (back stow), pistol, or inventory (side pack stow)
	// using mp/statstable.csv's weapon grouping data ( numbering 0 - 149 )
	level.primary_weapon_array = [];
	level.side_arm_array = [];
	level.grenade_array = [];
	level.inventory_array = [];
	max_weapon_num = 149;
	for( i = 0; i < max_weapon_num; i++ )
	{
		weapon = tableLookup( "mp/statsTable.csv", 0, i, 4 );
		if ( !isDefined( weapon ) || weapon == "" )
			continue;
		
		weapon_type = tableLookup( "mp/statsTable.csv", 0, i, 2 );
		attachment = tableLookup( "mp/statsTable.csv", 0, i, 8 );
		
		weapon_class_register( weapon+"_mp", weapon_type );	
		
		if( !isdefined( attachment ) || attachment == "" )
			continue;
			
		attachment_tokens = strTok( attachment, " " );
		if( !isDefined( attachment_tokens ) )
			continue;

		if( attachment_tokens.size == 0 )
		{
			weapon_class_register( weapon+"_"+attachment+"_mp", weapon_type );	
		}
		else
		{
			// multiple attachment options
			for( k = 0; k < attachment_tokens.size; k++ )
				weapon_class_register( weapon+"_"+attachment_tokens[k]+"_mp", weapon_type );
		}
	}

	precacheShader( "waypoint_bombsquad" );

	level thread onPlayerConnecting();
}


initPerkData( perkRef )
{
	level.perkNames[perkRef] = tableLookupIString( "mp/statsTable.csv", 4, perkRef, 3 );
	level.perkIcons[perkRef] = tableLookup( "mp/statsTable.csv", 4, perkRef, 6 );
	precacheString( level.perkNames[perkRef] );
	precacheShader( level.perkIcons[perkRef] );
}


weapon_class_register( weapon, weapon_type )
{
	if( isSubstr( "weapon_smg weapon_assault weapon_projectile weapon_sniper weapon_shotgun weapon_lmg", weapon_type ) )
		level.primary_weapon_array[weapon] = weapon_type;	
	else if( weapon_type == "weapon_pistol" )
		level.side_arm_array[weapon] = 1;
	else if( weapon_type == "weapon_grenade" )
		level.grenade_array[weapon] = 1;
	else if( weapon_type == "weapon_explosive" )
		level.inventory_array[weapon] = 1;
	else
		assertex( false, "Weapon group info is missing from statsTable for: " + weapon_type );
}


giveLoadout( team, class )
{
	self takeAllWeapons();
	self setClass( class );
	
	// initialize specialty array
	self.specialty = [];
	self.specialty[0] = self.pers[class]["loadout_perk1"];
	self.specialty[1] = self.pers[class]["loadout_perk2"];
	self.specialty[2] = self.pers[class]["loadout_perk3"];

	self maps\mp\gametypes\_class::register_perks();
	
	sidearmWeapon = self.pers[class]["loadout_secondary"];

	if ( sideArmWeapon != "none" )
	{
		if ( self.pers[class]["loadout_secondary_attachment"] != "none" )
			sidearmWeapon = sidearmWeapon + "_" + self.pers[class]["loadout_secondary_attachment"] + "_mp";
		else
			sidearmWeapon = sidearmWeapon + "_mp";
			
		self giveWeapon( sidearmWeapon );
		if ( self maps\mp\gametypes\_class::cac_hasSpecialty( "specialty_extraammo" ) )
			self giveMaxAmmo( sidearmWeapon );
	}
	
	primaryWeapon = self.pers[class]["loadout_primary"];
	if ( primaryWeapon != "none" )
	{
		if ( self.pers[class]["loadout_primary_attachment"] != "none" )
			primaryWeapon = primaryWeapon + "_" + self.pers[class]["loadout_primary_attachment"] + "_mp";
		else
			primaryWeapon = primaryWeapon + "_mp";
	
		self maps\mp\gametypes\_teams::playerModelForWeapon( self.pers[class]["loadout_primary"] );	
		self giveWeapon( primaryWeapon ); // TODO add camo
		self setSpawnWeapon( primaryWeapon );
	
		if ( self maps\mp\gametypes\_class::cac_hasSpecialty( "specialty_extraammo" ) )
			self giveMaxAmmo( primaryWeapon );
	}

	if ( getDvarInt( "scr_enable_nightvision" ) )
		self setActionSlot( 1, "nightvision" );
		
	switch ( self.pers[class]["loadout_perk1"] )
	{
		case "claymore_mp":
		case "rpg_mp":
		case "c4_mp":
			self giveWeapon( self.pers[class]["loadout_perk1"] );
			self maps\mp\gametypes\_class::setWeaponAmmoOverall( self.pers[class]["loadout_perk1"], 2 );
			self setActionSlot( 3, "weapon", self.pers[class]["loadout_perk1"] );
			self setActionSlot( 4, "" );
			break;
		default:
			self setActionSlot( 3, "altMode" );
			self setActionSlot( 4, "" );
			break;
	}
	
	// give frag grenade
	grenadeCount = getDvarInt( "class_" + class + "_frags" );
	if ( grenadeCount && getDvarInt( "weap_allow_frag_grenade" ) )
	{
		if ( self maps\mp\gametypes\_class::cac_hasSpecialty( "specialty_fraggrenade" ) )
			grenadeCount += 2;

		self giveWeapon( "frag_grenade_mp" );
		self setWeaponAmmoClip( "frag_grenade_mp", grenadeCount );
		self switchToOffhand( "frag_grenade_mp" );
	}
	
	// give special grenade
	grenadeCount = getDvarInt( "class_" + class + "_special" );
	if ( grenadeCount && self.pers[class]["loadout_grenade"] != "none" )
	{
		//TODO: dvar grenade count control
		if ( self maps\mp\gametypes\_class::cac_hasSpecialty( "specialty_specialgrenade" ) )
			grenadeCount += 2;

		if ( self.pers[class]["loadout_grenade"] == "flash_grenade" )
			self setOffhandSecondaryClass("flash");
		else
			self setOffhandSecondaryClass("smoke");
		
		self giveWeapon( self.pers[class]["loadout_grenade"] + "_mp" );
		self setWeaponAmmoClip( self.pers[class]["loadout_grenade"] + "_mp", grenadeCount );
	}

	switch ( class )
	{
		case "assault":
			self setMoveSpeedScale( getDvarFloat( "class_assault_movespeed" ) );
			break;
		case "specops":
			self setMoveSpeedScale( getDvarFloat( "class_specops_movespeed" ) );
			break;
		case "heavygunner":
			self setMoveSpeedScale( getDvarFloat( "class_heavygunner_movespeed" ) );
			break;
		case "demolitions":
			self setMoveSpeedScale( getDvarFloat( "class_demolitions_movespeed" ) );
			break;
		case "sniper":
			self setMoveSpeedScale( getDvarFloat( "class_sniper_movespeed" ) );
			break;
		default:
			self setMoveSpeedScale( 1.0 );
			break;
	}
	
	// cac specialties that require loop threads
	self maps\mp\gametypes\_class::cac_selector();
}


// sets the amount of ammo in the gun.
// if the clip maxs out, the rest goes into the stock.
setWeaponAmmoOverall( weaponname, amount )
{
	if ( isWeaponClipOnly( weaponname ) )
	{
		self setWeaponAmmoClip( weaponname, amount );
	}
	else
	{
		self setWeaponAmmoClip( weaponname, amount );
		diff = amount - self getWeaponAmmoClip( weaponname );
		assert( diff >= 0 );
		self setWeaponAmmoStock( weaponname, diff );
	}
}


onPlayerConnecting()
{
	for(;;)
	{
		level waittill( "connecting", player );

		if ( !isDefined( player.pers["class"] ) )
			player.pers["class"] = undefined;
		player.class = player.pers["class"];
		player.detectExplosives = false;
		player.bombSquadIcons = [];
		player.bombSquadIds = [];	
	}
}


fadeAway( waitDelay, fadeDelay )
{
	wait waitDelay;
	
	self fadeOverTime( fadeDelay );
	self.alpha = 0;
}


setClass( newClass )
{
	self setClientDvar( "loadout_curclass", newClass );
	self.curClass = newClass;
}


// ============================================================================================
// =======																				=======
// =======						 Create a Class Specialties 							=======
// =======																				=======
// ============================================================================================

initPerkDvars()
{
	level.cac_bulletdamage_data = cac_get_dvar_int( "perk_bulletDamage", "40" );		// increased bullet damage by this %
	level.cac_armorvest_data = cac_get_dvar_int( "perk_armorVest", "75" );				// increased health by this %
	level.cac_explosivedamage_data = cac_get_dvar_int( "perk_explosiveDamage", "25" );	// increased explosive damage by this %
}

// CAC: Selector function, calls the individual cac features according to player's class settings
// Info: Called every time player spawns during loadout stage
cac_selector()
{
	perks = self.specialty;

	self.detectExplosives = false;
	for( i=0; i<perks.size; i++ )
	{
		perk = perks[i];
		// run scripted perk that thread loops
		if( perk == "specialty_detectexplosive" )
			self.detectExplosives = true;
	}
	
	maps\mp\gametypes\_weapons::setupBombSquad();
}

register_perks()
{
	perks = self.specialty;
	self clearPerks();
	for( i=0; i<perks.size; i++ )
	{
		perk = perks[i];

		// TO DO: ask code to register the inventory perks and null perk
		// not registering inventory and null perks to code
		if ( perk == "specialty_null" || isSubStr( perk, "_mp" ) )
			continue;
			
		if ( !getDvarInt( "scr_game_perks" ) )
			continue;
			
		self setPerk( perk );
	}
}

// returns dvar value in int
cac_get_dvar_int( dvar, def )
{
	return int( cac_get_dvar( dvar, def ) );
}

// dvar set/fetch/check
cac_get_dvar( dvar, def )
{
	if ( getdvar( dvar ) != "" )
		return getdvarfloat( dvar );
	else
	{
		setdvar( dvar, def );
		return def;
	}
}

// CAC: Selected feature check function, returns boolean if a specialty is selected by the current class
// Info: Called on "player" as self, "feature" parameter is a string reference of the specialty in question
cac_hasSpecialty( perk_reference )
{
	return_value = self hasPerk( perk_reference );
	return return_value;
	
	/*
	perks = self.specialty;
	for( i=0; i<perks.size; i++ )
	{
		perk = perks[i];
		if( perk == perk_reference )
			return true;
	}
	return false;
	*/
}

// CAC: Weapon Specialty: Increased bullet damage feature
// CAC: Weapon Specialty: Armor Vest feature
// CAC: Ability: Increased explosive damage feature
cac_modified_damage( victim, attacker, damage, meansofdeath )
{
	// skip conditions
	if( !isdefined( victim) || !isdefined( attacker ) || !isplayer( attacker ) || !isplayer( victim ) )
		return damage;
	if( attacker.sessionstate != "playing" || !isdefined( damage ) || !isdefined( meansofdeath ) )
		return damage;
	if( meansofdeath == "" )
		return damage;
		
	old_damage = damage;
	final_damage = damage;
	
	/* Cases =======================
	attacker - bullet damage
		victim - none
		victim - armor
	attacker - explosive damage
		victim - none
		victim - armor
	attacker - none
		victim - none
		victim - armor
	===============================*/
	
	// if attacker has bullet damage then increase bullet damage
	if( attacker cac_hasSpecialty( "specialty_bulletdamage" ) && isPrimaryDamage( meansofdeath ) )
	{
		// if victim has armor then do not change damage, it is cancelled out, else damage is increased

		if( isdefined( victim ) && isPlayer( victim ) && victim cac_hasSpecialty( "specialty_armorvest" ) )
		{
			final_damage = old_damage;
			/#
			if ( getdvarint("scr_perkdebug") )
				println( "Perk/> " + victim.name + "'s armor countered " + attacker.name + "'s increased bullet damage" );
			#/
		}
		else
		{
			final_damage = damage*(100+level.cac_bulletdamage_data)/100;
			/#
			if ( getdvarint("scr_perkdebug") )
				println( "Perk/> " + attacker.name + "'s bullet damage did extra damage to " + victim.name );
			#/
		}
	}
	else if( attacker cac_hasSpecialty( "specialty_explosivedamage" ) && isExplosiveDamage( meansofdeath ) )
	{
		// if victim has armor then do not change damage, it is cancelled out, else damage is increased

		if( isdefined( victim ) && isPlayer( victim ) && victim cac_hasSpecialty( "specialty_armorvest" ) )
		{
			final_damage = old_damage;
			/#
			if ( getdvarint("scr_perkdebug") )
				println( "Perk/> " + victim.name + "'s armor countered " + attacker.name + "'s increased explosive damage" );
			#/
		}
		else
		{
			final_damage = damage*(100+level.cac_explosivedamage_data)/100;
			/#
			if ( getdvarint("scr_perkdebug") )
				println( "Perk/> " + attacker.name + "'s explosive damage did extra damage to " + victim.name );
			#/
		}
	}
	else
	{	
		// if attacker has no bullet damage then check if victim has armor
		// if victim has armor then less damage is taken, else damage unchanged
		
		if( isdefined( victim ) && isPlayer( victim ) && victim cac_hasSpecialty( "specialty_armorvest" ) )
		{
			final_damage = old_damage*(level.cac_armorvest_data/100);
			/#
			if ( getdvarint("scr_perkdebug") )
				println( "Perk/> " + victim.name + "'s armor decreased " + attacker.name + "'s damage" );
			#/
		}
		else
		{
			final_damage = old_damage;
		}	
	}
	
	// debug
	/#
	if ( getdvarint("scr_perkdebug") )
		println( "Perk/> Damage Factor: " + final_damage/old_damage + " - Pre Damage: " + old_damage + " - Post Damage: " + final_damage );
	#/
	
	// return unchanged damage
	return int( final_damage );
}

// including grenade launcher, grenade, RPG, C4, claymore
isExplosiveDamage( meansofdeath )
{
	explosivedamage = "MOD_GRENADE MOD_GRENADE_SPLASH MOD_PROJECTILE MOD_PROJECTILE_SPLASH MOD_EXPLOSIVE";
	if( isSubstr( explosivedamage, meansofdeath ) )
		return true;
	return false;
}

// if primary weapon damage
isPrimaryDamage( meansofdeath )
{
	// including pistols as well since sometimes they share ammo
	if( meansofdeath == "MOD_RIFLE_BULLET" || meansofdeath == "MOD_PISTOL_BULLET" )
		return true;
	return false;
}
