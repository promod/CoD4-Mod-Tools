#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

init()
{
	level.serverDvars = [];
	
	game["allies_assault_count"] = 0;
	game["allies_specops_count"] = 0;
	game["allies_heavygunner_count"] = 0;
	game["allies_demolitions_count"] = 0;
	game["allies_sniper_count"] = 0;

	game["axis_assault_count"] = 0;
	game["axis_specops_count"] = 0;
	game["axis_heavygunner_count"] = 0;
	game["axis_demolitions_count"] = 0;
	game["axis_sniper_count"] = 0;

	// classes
	setServerDvarDefault( "class_assault_limit", 64, 0, 64 );
	setServerDvarDefault( "class_specops_limit", 64, 0, 64 );
	setServerDvarDefault( "class_heavygunner_limit", 64, 0, 64 );
	setServerDvarDefault( "class_demolitions_limit", 64, 0, 64 );
	setServerDvarDefault( "class_sniper_limit", 64, 0, 64 );

	setDvarDefault( "class_assault_allowdrop", 1, 0, 1 );
	setDvarDefault( "class_specops_allowdrop", 1, 0, 1 );
	setDvarDefault( "class_heavygunner_allowdrop", 1, 0, 1 );
	setDvarDefault( "class_demolitions_allowdrop", 1, 0, 1 );
	setDvarDefault( "class_sniper_allowdrop", 1, 0, 1 );

	// assault rifles
	setDvarDefault( "weap_allow_m16", 1, 0, 1 );
	setDvarDefault( "weap_allow_ak47", 1, 0, 1 );
	setDvarDefault( "weap_allow_m4", 1, 0, 1 );
	setDvarDefault( "weap_allow_g3", 1, 0, 1 );
	setDvarDefault( "weap_allow_g36c", 1, 0, 1 );
	setDvarDefault( "weap_allow_m14", 1, 0, 1 );
	setDvarDefault( "weap_allow_mp44", 1, 0, 1 );
	// assault attachments
	setDvarDefault( "attach_allow_assault_none", 1, 0, 1 );
	setDvarDefault( "attach_allow_assault_gl", 1, 0, 1 );
	setDvarDefault( "attach_allow_assault_reflex", 1, 0, 1 );
	setDvarDefault( "attach_allow_assault_silencer", 1, 0, 1 );
	setDvarDefault( "attach_allow_assault_acog", 1, 0, 1 );

	// smgs
	setDvarDefault( "weap_allow_mp5", 1, 0, 1 );
	setDvarDefault( "weap_allow_skorpion", 1, 0, 1 );
	setDvarDefault( "weap_allow_uzi", 1, 0, 1 );
	setDvarDefault( "weap_allow_ak74u", 1, 0, 1 );
	setDvarDefault( "weap_allow_p90", 1, 0, 1 );
	// smg attachments
	setDvarDefault( "attach_allow_smg_none", 1, 0, 1 );
	setDvarDefault( "attach_allow_smg_reflex", 1, 0, 1 );
	setDvarDefault( "attach_allow_smg_silencer", 1, 0, 1 );
	setDvarDefault( "attach_allow_smg_acog", 1, 0, 1 );
	
	// shotguns
	setDvarDefault( "weap_allow_m1014", 1, 0, 1 );
	setDvarDefault( "weap_allow_winchester1200", 1, 0, 1 );
	// shotgun attachments
	setDvarDefault( "attach_allow_shotgun_none", 1, 0, 1 );
	setDvarDefault( "attach_allow_shotgun_reflex", 1, 0, 1 );
	setDvarDefault( "attach_allow_shotgun_grip", 1, 0, 1 );
	
	// light machine guns
	setDvarDefault( "weap_allow_saw", 1, 0, 1 );
	setDvarDefault( "weap_allow_rpd", 1, 0, 1 );
	setDvarDefault( "weap_allow_m60e4", 1, 0, 1 );
	// lmg attachments
	setDvarDefault( "attach_allow_lmg_none", 1, 0, 1 );
	setDvarDefault( "attach_allow_lmg_reflex", 1, 0, 1 );
	setDvarDefault( "attach_allow_lmg_grip", 1, 0, 1 );
	setDvarDefault( "attach_allow_lmg_acog", 1, 0, 1 );
	
	// sniper rifles
	setDvarDefault( "weap_allow_dragunov", 1, 0, 1 );
	setDvarDefault( "weap_allow_m40a3", 1, 0, 1 );
	setDvarDefault( "weap_allow_barrett", 1, 0, 1 );
	setDvarDefault( "weap_allow_remington700", 1, 0, 1 );
	setDvarDefault( "weap_allow_m21", 1, 0, 1 );
	// sniper attachments
	setDvarDefault( "attach_allow_sniper_none", 1, 0, 1 );
	setDvarDefault( "attach_allow_sniper_acog", 1, 0, 1 );
	
	// pistols
	setServerDvarDefault( "weap_allow_beretta", 1, 0, 1 );
	setServerDvarDefault( "weap_allow_colt45", 1, 0, 1 );
	setServerDvarDefault( "weap_allow_usp", 1, 0, 1 );
	setServerDvarDefault( "weap_allow_deserteagle", 1, 0, 1 );
	setServerDvarDefault( "weap_allow_deserteaglegold", 1, 0, 1 );
	// pistol attachments
	setServerDvarDefault( "attach_allow_pistol_none", 1, 0, 1 );
	setServerDvarDefault( "attach_allow_pistol_silencer", 1, 0, 1 );

	// grenades
	setServerDvarDefault( "weap_allow_frag_grenade", 1, 0, 1 );
	setServerDvarDefault( "weap_allow_concussion_grenade", 1, 0, 1 );
	setServerDvarDefault( "weap_allow_flash_grenade", 1, 0, 1 );
	setServerDvarDefault( "weap_allow_smoke_grenade", 1, 0, 1 );
	
	// perks
	setServerDvarDefault( "perk_allow_specialty_parabolic", 1, 0, 1 );
	setServerDvarDefault( "perk_allow_specialty_gpsjammer", 1, 0, 1 );
	setServerDvarDefault( "perk_allow_specialty_holdbreath", 1, 0, 1 );
	setServerDvarDefault( "perk_allow_specialty_quieter", 1, 0, 1 );
	setServerDvarDefault( "perk_allow_specialty_longersprint", 1, 0, 1 );
	setServerDvarDefault( "perk_allow_specialty_detectexplosive", 1, 0, 1 );
	setServerDvarDefault( "perk_allow_specialty_explosivedamage", 1, 0, 1 );
	setServerDvarDefault( "perk_allow_specialty_pistoldeath", 1, 0, 1 );
	setServerDvarDefault( "perk_allow_specialty_grenadepulldeath", 1, 0, 1 );
	setServerDvarDefault( "perk_allow_specialty_bulletdamage", 1, 0, 1 );
	setServerDvarDefault( "perk_allow_specialty_bulletpenetration", 1, 0, 1 );
	setServerDvarDefault( "perk_allow_specialty_bulletaccuracy", 1, 0, 1 );
	setServerDvarDefault( "perk_allow_specialty_rof", 1, 0, 1 );
	setServerDvarDefault( "perk_allow_specialty_fastreload", 1, 0, 1 );
	setServerDvarDefault( "perk_allow_specialty_extraammo", 1, 0, 1 );
	setServerDvarDefault( "perk_allow_specialty_armorvest", 1, 0, 1 );
	setServerDvarDefault( "perk_allow_specialty_fraggrenade", 1, 0, 1 );
	setServerDvarDefault( "perk_allow_specialty_specialgrenade", 1, 0, 1 );
	setServerDvarDefault( "perk_allow_c4_mp", 1, 0, 1 );
	setServerDvarDefault( "perk_allow_claymore_mp", 1, 0, 1 );
	setServerDvarDefault( "perk_allow_rpg_mp", 1, 0, 1 );
	
	// client menu only
	setServerDvarDefault( "allies_allow_assault", 1, 0, 1 );
	setServerDvarDefault( "allies_allow_specops", 1, 0, 1 );
	setServerDvarDefault( "allies_allow_heavygunner", 1, 0, 1 );
	setServerDvarDefault( "allies_allow_demolitions", 1, 0, 1 );
	setServerDvarDefault( "allies_allow_sniper", 1, 0, 1 );
	setServerDvarDefault( "axis_allow_assault", 1, 0, 1 );
	setServerDvarDefault( "axis_allow_specops", 1, 0, 1 );
	setServerDvarDefault( "axis_allow_heavygunner", 1, 0, 1 );
	setServerDvarDefault( "axis_allow_demolitions", 1, 0, 1 );
	setServerDvarDefault( "axis_allow_sniper", 1, 0, 1 );

	// assault class default loadout
	setDvarDefault( "class_assault_primary", "m16" );
	setDvarDefault( "class_assault_primary_attachment", "gl" );
	setDvarDefault( "class_assault_secondary", "beretta" );
	setDvarDefault( "class_assault_secondary_attachment", "none" );
	setDvarDefault( "class_assault_perk1", "specialty_null" );
	setDvarDefault( "class_assault_perk2", "specialty_bulletdamage" );
	setDvarDefault( "class_assault_perk3", "specialty_longersprint" );
	setDvarDefault( "class_assault_grenade", "concussion_grenade" );
	setDvarDefault( "class_assault_camo", "camo_none" );
	setDvarDefault( "class_assault_frags", 1, 0, 4 );
	setDvarDefault( "class_assault_special", 1, 0, 4 );

	// specops class default loadout
	setDvarDefault( "class_specops_primary", "mp5" );
	setDvarDefault( "class_specops_primary_attachment", "none" );
	setDvarDefault( "class_specops_secondary", "usp" );
	setDvarDefault( "class_specops_secondary_attachment", "silencer" );
	setDvarDefault( "class_specops_perk1", "c4_mp" );
	setDvarDefault( "class_specops_perk2", "specialty_explosivedamage" );
	setDvarDefault( "class_specops_perk3", "specialty_bulletaccuracy" );
	setDvarDefault( "class_specops_grenade", "flash_grenade" );
	setDvarDefault( "class_specops_camo", "camo_none" );
	setDvarDefault( "class_specops_frags", 1, 0, 4 );
	setDvarDefault( "class_specops_special", 1, 0, 4 );

	// heavygunner class default loadout
	setDvarDefault( "class_heavygunner_primary", "saw" );
	setDvarDefault( "class_heavygunner_primary_attachment", "none" );
	setDvarDefault( "class_heavygunner_secondary", "usp" );
	setDvarDefault( "class_heavygunner_secondary_attachment", "none" );
	setDvarDefault( "class_heavygunner_perk1", "specialty_specialgrenade" );
	setDvarDefault( "class_heavygunner_perk2", "specialty_armorvest" );
	setDvarDefault( "class_heavygunner_perk3", "specialty_bulletpenetration" );
	setDvarDefault( "class_heavygunner_grenade", "concussion_grenade" );
	setDvarDefault( "class_heavygunner_camo", "camo_none" );
	setDvarDefault( "class_heavygunner_frags", 1, 0, 4 );
	setDvarDefault( "class_heavygunner_special", 1, 0, 4 );

	// demolitions class default loadout
	setDvarDefault( "class_demolitions_primary", "winchester1200" );
	setDvarDefault( "class_demolitions_primary_attachment", "none" );
	setDvarDefault( "class_demolitions_secondary", "beretta" );
	setDvarDefault( "class_demolitions_secondary_attachment", "none" );
	setDvarDefault( "class_demolitions_perk1", "rpg_mp" );
	setDvarDefault( "class_demolitions_perk2", "specialty_explosivedamage" );
	setDvarDefault( "class_demolitions_perk3", "specialty_longersprint" );
	setDvarDefault( "class_demolitions_grenade", "smoke_grenade" );
	setDvarDefault( "class_demolitions_camo", "camo_none" );
	setDvarDefault( "class_demolitions_frags", 1, 0, 4 );
	setDvarDefault( "class_demolitions_special", 1, 0, 4 );

	// sniper class default loadout
	setDvarDefault( "class_sniper_primary", "m40a3" );
	setDvarDefault( "class_sniper_primary_attachment", "none" );
	setDvarDefault( "class_sniper_secondary", "beretta" );
	setDvarDefault( "class_sniper_secondary_attachment", "silencer" );
	setDvarDefault( "class_sniper_perk1", "specialty_specialgrenade" );
	setDvarDefault( "class_sniper_perk2", "specialty_bulletdamage" );
	setDvarDefault( "class_sniper_perk3", "specialty_bulletpenetration" );
	setDvarDefault( "class_sniper_grenade", "flash_grenade" );
	setDvarDefault( "class_sniper_camo", "camo_none" );
	setDvarDefault( "class_sniper_frags", 1, 0, 4 );
	setDvarDefault( "class_sniper_special", 1, 0, 4 );

	setDvarDefault( "scr_enable_nightvision", 1, 0, 1 );
	setDvarDefault( "scr_enable_music", 1, 0, 1 );
	setDvarDefault( "scr_enable_hiticon", 1, 0, 2 );
	setDvarDefault( "scr_enable_scoretext", 1, 0, 1 );

	setDvarDefault( "class_assault_movespeed", 0.95, 0.25, 2.0 );
	setDvarDefault( "class_specops_movespeed", 1.00, 0.25, 2.0 );
	setDvarDefault( "class_heavygunner_movespeed", 0.875, 0.25, 2.0 );
	setDvarDefault( "class_demolitions_movespeed", 1.00, 0.25, 2.0 );
	setDvarDefault( "class_sniper_movespeed", 1.00, 0.25, 2.0 );

	level thread classDvarUpdate();
	level thread onPlayerConnect();
}


classDvarUpdate()
{
	updateClassAvailability( "allies", "assault" );
	updateClassAvailability( "axis", "assault" );
	updateClassAvailability( "allies", "specops" );
	updateClassAvailability( "axis", "specops" );
	updateClassAvailability( "allies", "heavygunner" );
	updateClassAvailability( "axis", "heavygunner" );
	updateClassAvailability( "allies", "demolitions" );
	updateClassAvailability( "axis", "demolitions" );
	updateClassAvailability( "allies", "sniper" );
	updateClassAvailability( "axis", "sniper" );

	for ( ;; )
	{
		if ( getDvarInt( "class_assault_limit" ) != level.serverDvars["class_assault_limit"] )
		{
			updateClassAvailability( "allies", "assault" );
			updateClassAvailability( "axis", "assault" );
		}
		wait ( 0.05 );

		if ( getDvarInt( "class_specops_limit" ) != level.serverDvars["class_specops_limit"] )
		{
			updateClassAvailability( "allies", "specops" );
			updateClassAvailability( "axis", "specops" );
		}
		wait ( 0.05 );

		if ( getDvarInt( "class_heavygunner_limit" ) != level.serverDvars["class_heavygunner_limit"] )
		{
			updateClassAvailability( "allies", "heavygunner" );
			updateClassAvailability( "axis", "heavygunner" );
		}
		wait ( 0.05 );

		if ( getDvarInt( "class_demolitions_limit" ) != level.serverDvars["class_demolitions_limit"] )
		{
			updateClassAvailability( "allies", "demolitions" );
			updateClassAvailability( "axis", "demolitions" );
		}
		wait ( 0.05 );

		if ( getDvarInt( "class_sniper_limit" ) != level.serverDvars["class_sniper_limit"] )
		{
			updateClassAvailability( "allies", "sniper" );
			updateClassAvailability( "axis", "sniper" );
		}
		wait ( 0.05 );
	}
}


onPlayerConnect()
{
	for(;;)
	{
		level waittill( "connecting", player );
		
		player thread initClassLoadouts();
		player thread updateServerDvars();
	}
}


releaseClass( teamName, classType )
{
	game[teamName + "_" + classType + "_count"]--;
	updateClassAvailability( teamName, classType );
}


claimClass( teamName, classType )
{
	game[teamName + "_" + classType + "_count"]++;
	updateClassAvailability( teamName, classType );
}


setClassChoice( classType )
{
	if ( isDefined( self.class ) )
		releaseClass( self.pers["team"], self.class );
	if ( isDefined( self.curClass ) && self.curClass != self.class )
		releaseClass( self.pers["team"], self.curClass );

	self.pers["class"] = classType;
	self.class = classType;

	self claimClass( self.pers["team"], self.class );

	if ( isDefined( self.curClass ) && self.curClass != self.class )
		self claimClass( self.pers["team"], self.curClass );
		
	self setClientDvar( "loadout_class", classType );
	self setDvarsFromClass( classType );
	
	switch ( classType )
	{
		case "assault":
			self setClientDvars(
					"weap_allow_m16", getDvar( "weap_allow_m16" ), 
					"weap_allow_ak47", getDvar( "weap_allow_ak47" ), 
					"weap_allow_m4", getDvar( "weap_allow_m4" ), 
					"weap_allow_g3", getDvar( "weap_allow_g3" ), 
					"weap_allow_g36c", getDvar( "weap_allow_g36c" ), 
					"weap_allow_m14", getDvar( "weap_allow_m14" ), 
					"weap_allow_mp44", getDvar( "weap_allow_mp44" ) );
			self setClientDvars(
					"attach_allow_assault_none", getDvar( "attach_allow_assault_none" ), 
					"attach_allow_assault_gl", getDvar( "attach_allow_assault_gl" ), 
					"attach_allow_assault_reflex", getDvar( "attach_allow_assault_reflex" ), 
					"attach_allow_assault_silencer", getDvar( "attach_allow_assault_silencer" ), 
					"attach_allow_assault_acog", getDvar( "attach_allow_assault_acog" ) );
			break;
		case "specops":
			self setClientDvars(
					"weap_allow_mp5", getDvar( "weap_allow_mp5" ), 
					"weap_allow_skorpion", getDvar( "weap_allow_skorpion" ), 
					"weap_allow_uzi", getDvar( "weap_allow_uzi" ), 
					"weap_allow_ak74u", getDvar( "weap_allow_ak74u" ), 
					"weap_allow_p90", getDvar( "weap_allow_p90" ) );
			self setClientDvars(
					"attach_allow_smg_none", getDvar( "attach_allow_smg_none" ), 
					"attach_allow_smg_reflex", getDvar( "attach_allow_smg_reflex" ), 
					"attach_allow_smg_silencer", getDvar( "attach_allow_smg_silencer" ), 
					"attach_allow_smg_acog", getDvar( "attach_allow_smg_acog" ) );
			break;
		case "heavygunner":
			self setClientDvars(
					"weap_allow_saw", getDvar( "weap_allow_saw" ), 
					"weap_allow_rpd", getDvar( "weap_allow_rpd" ), 
					"weap_allow_m60e4", getDvar( "weap_allow_m60e4" ) );
			self setClientDvars(
					"attach_allow_lmg_none", getDvar( "attach_allow_lmg_none" ), 
					"attach_allow_lmg_reflex", getDvar( "attach_allow_lmg_reflex" ), 
					"attach_allow_lmg_grip", getDvar( "attach_allow_lmg_grip" ), 
					"attach_allow_lmg_acog", getDvar( "attach_allow_lmg_acog" ) );
			break;
		case "demolitions":
			self setClientDvars(
					"weap_allow_m1014", getDvar( "weap_allow_m1014" ), 
					"weap_allow_winchester1200", getDvar( "weap_allow_winchester1200" ) );
			self setClientDvars(
					"attach_allow_shotgun_none", getDvar( "attach_allow_shotgun_none" ), 
					"attach_allow_shotgun_reflex", getDvar( "attach_allow_shotgun_reflex" ), 
					"attach_allow_shotgun_grip", getDvar( "attach_allow_shotgun_grip" ) );
			break;
		case "sniper":
			self setClientDvars(
					"weap_allow_m40a3", getDvar( "weap_allow_m40a3" ), 
					"weap_allow_m21", getDvar( "weap_allow_m21" ), 
					"weap_allow_dragunov", getDvar( "weap_allow_dragunov" ), 
					"weap_allow_barrett", getDvar( "weap_allow_barrett" ), 
					"weap_allow_remington700", getDvar( "weap_allow_remington700" ) );
			self setClientDvars(
					"attach_allow_sniper_none", getDvar( "attach_allow_sniper_none" ), 
					"attach_allow_sniper_acog", getDvar( "attach_allow_sniper_acog" ) );
			break;
	}
}


setDvarWrapper( dvarName, setVal )
{
	setDvar( dvarName, setVal );
	if ( isDefined( level.serverDvars[dvarName] ) )
	{
		level.serverDvars[dvarName] = setVal;
		players = level.players;
		for ( index = 0; index < level.players.size; index++ )
			players[index] setClientDvar( dvarName, setVal );
	}
}


// set a dvar to a default value or, if it already has a value, assure that it's in the valid range
setDvarDefault( dvarName, setVal, minVal, maxVal )
{
	// no value set
	if ( getDvar( dvarName ) != "" )
	{
		if ( isString( setVal ) )
			setVal = getDvar( dvarName );
		else
			setVal = getDvarFloat( dvarName );
	}
		
	if ( isDefined( minVal ) && !isString( setVal ) )
		setVal = max( setVal, minVal );

	if ( isDefined( maxVal ) && !isString( setVal ) )
		setVal = min( setVal, maxVal );

	setDvar( dvarName, setVal );
	return setVal;
}


// set a dvar to a default value or, if it already has a value, assure that it's in the valid range
// server dvars should always be updated to client when they change
setServerDvarDefault( dvarName, setVal, minVal, maxVal )
{
	setVal = setDvarDefault( dvarName, setVal, minVal, maxVal );

	level.serverDvars[dvarName] = setVal;
}


// set a dvar to a default value or, if it already has a value, assure that it's in the valid range
// server info dvars are automatically updated to the clients by code, but increase the config string count and gamestate size
setServerInfoDvarDefault( dvarName, setVal, minVal, maxVal )
{
	makeDvarServerInfo( dvarName, setVal );

	setVal = setDvarDefault( dvarName, setVal, minVal, maxVal );
}


// init all player classes to default server settings
initClassLoadouts()
{
	self initLoadoutForClass( "assault" );
	self initLoadoutForClass( "specops" );
	self initLoadoutForClass( "heavygunner" );
	self initLoadoutForClass( "demolitions" );
	self initLoadoutForClass( "sniper" );
}


// copy server side class settings into client loadout
initLoadoutForClass( classType )
{
	if ( !isDefined( self.pers[classType] ) || !isDefined( self.pers[classType]["loadout_primary"] ) )
		self.pers[classType]["loadout_primary"] = getDvar( "class_" + classType + "_primary" );
	if ( !isDefined( self.pers[classType] ) || !isDefined( self.pers[classType]["loadout_primary_attachment"] ) )
		self.pers[classType]["loadout_primary_attachment"] = getDvar( "class_" + classType + "_primary_attachment" );
	if ( !isDefined( self.pers[classType] ) || !isDefined( self.pers[classType]["loadout_secondary"] ) )
		self.pers[classType]["loadout_secondary"] = getDvar( "class_" + classType + "_secondary" );
	if ( !isDefined( self.pers[classType] ) || !isDefined( self.pers[classType]["loadout_secondary_attachment"] ) )
		self.pers[classType]["loadout_secondary_attachment"] = getDvar( "class_" + classType + "_secondary_attachment" );
	if ( !isDefined( self.pers[classType] ) || !isDefined( self.pers[classType]["loadout_perk1"] ) )
		self.pers[classType]["loadout_perk1"] = getDvar( "class_" + classType + "_perk1" );
	if ( !isDefined( self.pers[classType] ) || !isDefined( self.pers[classType]["loadout_perk2"] ) )
		self.pers[classType]["loadout_perk2"] = getDvar( "class_" + classType + "_perk2" );
	if ( !isDefined( self.pers[classType] ) || !isDefined( self.pers[classType]["loadout_perk3"] ) )
		self.pers[classType]["loadout_perk3"] = getDvar( "class_" + classType + "_perk3" );
	if ( !isDefined( self.pers[classType] ) || !isDefined( self.pers[classType]["loadout_grenade"] ) )
		self.pers[classType]["loadout_grenade"] = getDvar( "class_" + classType + "_grenade" );
	if ( !isDefined( self.pers[classType] ) || !isDefined( self.pers[classType]["loadout_camo"] ) )
		self.pers[classType]["loadout_camo"] = getDvar( "class_" + classType + "_camo" );
}


// update the client ui with dvars from the specified class
setDvarsFromClass( classType )
{
	self setClientDvars(
		"loadout_primary", self.pers[classType]["loadout_primary"],
		"loadout_primary_attachment", self.pers[classType]["loadout_primary_attachment"],
		"loadout_secondary", self.pers[classType]["loadout_secondary"],
		"loadout_secondary_attachment", self.pers[classType]["loadout_secondary_attachment"],
		"loadout_perk1", self.pers[classType]["loadout_perk1"],
		"loadout_perk2", self.pers[classType]["loadout_perk2"],
		"loadout_perk3", self.pers[classType]["loadout_perk3"],
		"loadout_grenade", self.pers[classType]["loadout_grenade"],
		"loadout_camo", self.pers[classType]["loadout_camo"],
		"loadout_frags", getDvarInt( "class_"+classType+"_frags" ),
		"loadout_special", getDvarInt( "class_"+classType+"_special" )
		);
}


// handle script menu responses related to loadout changes
processLoadoutResponse( respString )
{
	commandTokens = strTok( respString, "," );
	
	for ( index = 0; index < commandTokens.size; index++ )
	{
		subTokens = strTok( commandTokens[index], ":" );
		assert( subTokens.size > 1 );

		switch ( subTokens[0] )
		{
			case "loadout_primary":
			case "loadout_secondary":
				if ( getDvarInt( "weap_allow_" + subTokens[1] ) && self verifyWeaponChoice( subTokens[1], self.class ) )
				{
					self.pers[self.class][subTokens[0]] = subTokens[1];
					self setClientDvar( subTokens[0], subTokens[1] );
					if ( subTokens[1] == "mp44" )
					{
						self.pers[self.class]["loadout_primary_attachment"] = "none";
						self setClientDvar( "loadout_primary_attachment", "none" );
					}
					else if ( subTokens[1] == "deserteagle" || subTokens[1] == "deserteaglegold" )
					{
						self.pers[self.class]["loadout_secondary_attachment"] = "none";
						self setClientDvar( "loadout_secondary_attachment", "none" );
					}
				}
				else
				{
					// invalid selection, so reset them to their class default
					self setClientDvar( subTokens[0], self.pers[self.class][subTokens[0]] );
				}
				break;
				
			case "loadout_primary_attachment":
			case "loadout_secondary_attachment":
				if ( subTokens[0] == "loadout_primary_attachment" && self.pers[self.class]["loadout_primary"] == "mp44" )
				{
					self.pers[self.class]["loadout_primary_attachment"] = "none";
					self setClientDvar( "loadout_primary_attachment", "none" );
				}
				else if ( getDvarInt( "attach_allow_" + subTokens[1] + "_" + subTokens[2] ) )
				{
					self.pers[self.class][subTokens[0]] = subTokens[2];
					self setClientDvar( subTokens[0], subTokens[2] );
					// grenade launchers and grips take up the perk 1 slot
					if ( subTokens[2] == "gl" || subTokens[2] == "grip" )
					{
						self.pers[self.class]["loadout_perk1"] = "specialty_null";
						self setClientDvar( "loadout_perk1", "specialty_null" );
					}
				}
				else
				{
					// invalid selection, so reset them to their class default
					self setClientDvar( subTokens[0], self.pers[self.class][subTokens[0]] );
				}
				break;

			case "loadout_perk1":
			case "loadout_perk2":
			case "loadout_perk3":
				if ( getDvarInt( "perk_allow_" + subTokens[1] ) )
				{
					self.pers[self.class][subTokens[0]] = subTokens[1];
					self setClientDvar( subTokens[0], subTokens[1] );
				}
				else
				{
					// invalid selection, so reset them to their class default
					self setClientDvar( subTokens[0], self.pers[self.class][subTokens[0]] );
				}
				break;

			case "loadout_grenade":
				if ( getDvarInt( "weap_allow_" + subTokens[1] ) )
				{
					self.pers[self.class][subTokens[0]] = subTokens[1];
					self setClientDvar( subTokens[0], subTokens[1] );
				}
				else
				{
					self setClientDvar( subTokens[0], self.pers[self.class][subTokens[0]] );
				}
				break;

			case "loadout_camo":
				break;
		}
	}
}


verifyWeaponChoice( weaponName, classType )
{
	if ( tableLookup( "mp/statsTable.csv", 4, weaponName, 2 ) == "weapon_pistol" )
		return true;
		
	switch ( classType )
	{
		case "assault":
			if ( tableLookup( "mp/statsTable.csv", 4, weaponName, 2 ) == "weapon_assault" )
				return true;
			break;
		case "specops":
			if ( tableLookup( "mp/statsTable.csv", 4, weaponName, 2 ) == "weapon_smg" )
				return true;
			break;
		case "heavygunner":
			if ( tableLookup( "mp/statsTable.csv", 4, weaponName, 2 ) == "weapon_lmg" )
				return true;
			break;
		case "demolitions":
			if ( tableLookup( "mp/statsTable.csv", 4, weaponName, 2 ) == "weapon_shotgun" )
				return true;
			break;
		case "sniper":
			if ( tableLookup( "mp/statsTable.csv", 4, weaponName, 2 ) == "weapon_sniper" )
				return true;
			break;
	}

	return false;
}


verifyClassChoice( teamName, classType )
{
	assert( teamName == "allies" || teamName == "axis" );
	assert( classType == "assault" || classType == "specops" || classType == "heavygunner" || classType == "demolitions" || classType == "sniper" );
	if ( isDefined( self.curClass ) && self.curClass == classType && getDvarInt( "class_" + classType + "_limit" ) )
		return true;

	return ( game[teamName + "_" + classType + "_count"] < getDvarInt( "class_" + classType + "_limit" ) );
}


updateClassAvailability( teamName, classType )
{
	assert( teamName == "allies" || teamName == "axis" );
	assert( classType == "assault" || classType == "specops" || classType == "heavygunner" || classType == "demolitions" || classType == "sniper" );	
	setDvarWrapper( teamName + "_allow_" + classType, game[teamName + "_" + classType + "_count"] < getDvarInt( "class_" + classType + "_limit" ) );
}


menuAcceptClass()
{
	self maps\mp\gametypes\_globallogic::closeMenus();
	
	// this should probably be an assert
	if(!isDefined(self.pers["team"]) || (self.pers["team"] != "allies" && self.pers["team"] != "axis"))
		return;
	
	// already playing
	if ( self.sessionstate == "playing" )
	{
		self.pers["primary"] = undefined;
		self.pers["weapon"] = undefined;

		if ( game["state"] == "postgame" )
			return;

		if ( level.inGracePeriod && !self.hasDoneCombat ) // used weapons check?
		{
			self.tag_stowed_back = undefined;
			self.tag_stowed_hip = undefined;
			if ( isDefined( self.curClass ) && self.curClass != self.class )
				self releaseClass( self.pers["team"], self.curClass );
				
			self maps\mp\gametypes\_class::giveLoadout( self.pers["team"], self.pers["class"] );
		}
		else
		{
			self iPrintLnBold( game["strings"]["change_class"] );

			if ( level.numLives == 1 && !level.inGracePeriod && self.curClass != self.pers["class"] )
			{
				self releaseClass( self.pers["team"], self.curClass );
				self setClientDvar( "loadout_curclass", "" );
				self.curClass = undefined;
			}
		}
	}
	else
	{
		self.pers["primary"] = undefined;
		self.pers["weapon"] = undefined;

		if ( game["state"] == "postgame" )
			return;

		if ( game["state"] == "playing" )
			self thread [[level.spawnClient]]();
	}

	level thread maps\mp\gametypes\_globallogic::updateTeamStatus();
	self thread maps\mp\gametypes\_spectating::setSpectatePermissions();
}


//this could be optimized to use setClientDvars
updateServerDvars()
{
	self endon ( "disconnect" );
	
	dvarKeys = getArrayKeys( level.serverDvars );
	for ( index = 0; index < dvarKeys.size; index++ )
	{
		self setClientDvar( dvarKeys[index], level.serverDvars[dvarKeys[index]] );
		wait ( 0.05 );
	}
}