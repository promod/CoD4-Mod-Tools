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
	
	if ( level.onlineGame )
		level.defaultClass = "CLASS_ASSAULT";
	else
		level.defaultClass = "OFFLINE_CLASS1";
	
	level.weapons["frag"] = "frag_grenade_mp";
	level.weapons["smoke"] = "smoke_grenade_mp";
	level.weapons["flash"] = "flash_grenade_mp";
	level.weapons["concussion"] = "concussion_grenade_mp";
	level.weapons["c4"] = "c4_mp";
	level.weapons["claymore"] = "claymore_mp";
	level.weapons["rpg"] = "rpg_mp";
	
	// initializes create a class settings
	cac_init();	
	
	// default class weapon loadout for offline mode
	// param( team, class, stat number, inventory string, inventory count )
	
	offline_class_datatable = "mp/offline_classTable.csv";
	
	load_default_loadout( offline_class_datatable, "both", "OFFLINE_CLASS1", 200 );
	load_default_loadout( offline_class_datatable, "both", "OFFLINE_CLASS2", 210 );
	load_default_loadout( offline_class_datatable, "both", "OFFLINE_CLASS3", 220 );
	load_default_loadout( offline_class_datatable, "both", "OFFLINE_CLASS4", 230 );
	load_default_loadout( offline_class_datatable, "both", "OFFLINE_CLASS5", 240 );
	load_default_loadout( offline_class_datatable, "both", "OFFLINE_CLASS6", 250 );
	load_default_loadout( offline_class_datatable, "both", "OFFLINE_CLASS7", 260 );
	load_default_loadout( offline_class_datatable, "both", "OFFLINE_CLASS8", 270 );
	load_default_loadout( offline_class_datatable, "both", "OFFLINE_CLASS9", 280 );
	load_default_loadout( offline_class_datatable, "both", "OFFLINE_CLASS10", 290 );
	
	online_class_datatable = "mp/classTable.csv";
	
	load_default_loadout( online_class_datatable, "both", "CLASS_ASSAULT", 200 );			// assault
	load_default_loadout( online_class_datatable, "both", "CLASS_SPECOPS", 210 );			// spec ops
	load_default_loadout( online_class_datatable, "both", "CLASS_HEAVYGUNNER", 220 );		// heavy gunner
	load_default_loadout( online_class_datatable, "both", "CLASS_DEMOLITIONS", 230 );		// demolitions
	load_default_loadout( online_class_datatable, "both", "CLASS_SNIPER", 240 );			// sniper
		
	// generating weapon type arrays which classifies the weapon as primary (back stow), pistol, or inventory (side pack stow)
	// using mp/statstable.csv's weapon grouping data ( numbering 0 - 149 )
	level.primary_weapon_array = [];
	level.side_arm_array = [];
	level.grenade_array = [];
	level.inventory_array = [];
	max_weapon_num = 149;
	for( i = 0; i < max_weapon_num; i++ )
	{
		if( !isdefined( level.tbl_weaponIDs[i] ) || level.tbl_weaponIDs[i]["group"] == "" )
			continue;
		if( !isdefined( level.tbl_weaponIDs[i] ) || level.tbl_weaponIDs[i]["reference"] == "" )
			continue;		
			
		//statstablelookup( get_col, with_col, with_data )
		weapon_type = level.tbl_weaponIDs[i]["group"]; //statstablelookup( level.cac_cgroup, level.cac_cstat, i );
		weapon = level.tbl_weaponIDs[i]["reference"]; //statstablelookup( level.cac_creference, level.cac_cstat, i );
		attachment = level.tbl_weaponIDs[i]["attachment"]; //statstablelookup( level.cac_cstring, level.cac_cstat, i );
		
		weapon_class_register( weapon+"_mp", weapon_type );	
		
		if( isdefined( attachment ) && attachment != "" )
		{	
			attachment_tokens = strtok( attachment, " " );
			if( isdefined( attachment_tokens ) )
			{
				if( attachment_tokens.size == 0 )
					weapon_class_register( weapon+"_"+attachment+"_mp", weapon_type );	
				else
				{
					// multiple attachment options
					for( k = 0; k < attachment_tokens.size; k++ )
						weapon_class_register( weapon+"_"+attachment_tokens[k]+"_mp", weapon_type );
				}
			}
		}
	}
	
	precacheShader( "waypoint_bombsquad" );

	level thread onPlayerConnecting();
}

// assigns default class loadout to team from datatable
load_default_loadout( datatable, team, class, stat_num )
{
	if( team == "both" )
	{
		// do not thread, tablelookup is demanding
		load_default_loadout_raw( datatable, "allies", class, stat_num );
		load_default_loadout_raw( datatable, "axis", class, stat_num );
	}
	else
		load_default_loadout_raw( datatable, team, class, stat_num );
}

load_default_loadout_raw( class_dataTable, team, class, stat_num )
{
	// give primary weapon and attachment
	primary_attachment = tablelookup( class_dataTable, 1, stat_num + 2, 4 );
	if( primary_attachment != "" && primary_attachment != "none" )
		level.classWeapons[team][class][0] = tablelookup( class_dataTable, 1, stat_num + 1, 4 ) + "_" + primary_attachment + "_mp";
	else
		level.classWeapons[team][class][0] = tablelookup( class_dataTable, 1, stat_num + 1, 4 ) + "_mp";	

	// give secondary weapon and attachment
	secondary_attachment = tablelookup( class_dataTable, 1, stat_num + 4, 4 );
	if( secondary_attachment != "" && secondary_attachment != "none" )
		level.classSidearm[team][class] = tablelookup( class_dataTable, 1, stat_num + 3, 4 ) + "_" + secondary_attachment + "_mp";
	else
		level.classSidearm[team][class] = tablelookup( class_dataTable, 1, stat_num + 3, 4 ) + "_mp";	
		
	// give frag and special grenades
	level.classGrenades[class]["primary"]["type"] = tablelookup( class_dataTable, 1, stat_num, 4 ) + "_mp";
	level.classGrenades[class]["primary"]["count"] = int( tablelookup( class_dataTable, 1, stat_num, 6 ) );
	level.classGrenades[class]["secondary"]["type"] = tablelookup( class_dataTable, 1, stat_num + 8, 4 ) + "_mp";
	level.classGrenades[class]["secondary"]["count"] = int( tablelookup( class_dataTable, 1, stat_num + 8, 6 ) );
	
	// give default class perks
	level.default_perk[class] = [];	
	level.default_perk[class][0] = tablelookup( class_dataTable, 1, stat_num + 5, 4 );
	level.default_perk[class][1] = tablelookup( class_dataTable, 1, stat_num + 6, 4 );
	level.default_perk[class][2] = tablelookup( class_dataTable, 1, stat_num + 7, 4 );
	
	// give all inventory
	inventory_ref = tablelookup( class_dataTable, 1, stat_num + 5, 4 );
	if( isdefined( inventory_ref ) && tablelookup( "mp/statsTable.csv", 6, inventory_ref, 2 ) == "inventory" )
	{
		inventory_count = int( tablelookup( "mp/statsTable.csv", 6, inventory_ref, 5 ) );
		inventory_item_ref = tablelookup( "mp/statsTable.csv", 6, inventory_ref, 4 );
		assertex( isdefined( inventory_count ) && inventory_count != 0 && isdefined( inventory_item_ref ) && inventory_item_ref != "" , "Inventory in statsTable.csv not specified correctly" );
		
		level.classItem[team][class]["type"] = inventory_item_ref;
		level.classItem[team][class]["count"] = inventory_count;
	}
	else
	{
		level.classItem[team][class]["type"] = "";
		level.classItem[team][class]["count"] = 0;		
	}
	// give all inventory
	//level.classItem[team][class]["type"] = inventory;
	//level.classItem[team][class]["count"] = inv_count;
}

weapon_class_register( weapon, weapon_type )
{
	if( isSubstr( "weapon_smg weapon_assault weapon_projectile weapon_sniper weapon_shotgun weapon_lmg", weapon_type ) )
		level.primary_weapon_array[weapon] = 1;	
	else if( weapon_type == "weapon_pistol" )
		level.side_arm_array[weapon] = 1;
	else if( weapon_type == "weapon_grenade" )
		level.grenade_array[weapon] = 1;
	else if( weapon_type == "weapon_explosive" )
		level.inventory_array[weapon] = 1;
	else
		assertex( false, "Weapon group info is missing from statsTable for: " + weapon_type );
}

// create a class init
cac_init()
{
	// max create a class "class" allowed
	level.cac_size = 5;
	
	// init cac data table column definitions
	level.cac_numbering = 0;	// unique unsigned int - general numbering of all items
	level.cac_cstat = 1;		// unique unsigned int - stat number assigned
	level.cac_cgroup = 2;		// string - item group name, "primary" "secondary" "inventory" "specialty" "grenades" "special grenades" "stow back" "stow side" "attachment"
	level.cac_cname = 3;		// string - name of the item, "Extreme Conditioning"
	level.cac_creference = 4;	// string - reference string of the item, "m203" "m16" "bulletdamage" "c4"
	level.cac_ccount = 5;		// signed int - item count, if exists, -1 = has no count
	level.cac_cimage = 6;		// string - item's image file name
	level.cac_cdesc = 7;		// long string - item's description
	level.cac_cstring = 8;		// long string - item's other string data, reserved
	level.cac_cint = 9;			// signed int - item's other number data, used for attachment number representations
	level.cac_cunlock = 10;		// unsigned int - represents if item is unlocked by default
	level.cac_cint2 = 11;		// signed int - item's other number data, used for primary weapon camo skin number representations
	
	// generating camo/attachment data vars collected from attachmentTable.csv
	level.tbl_CamoSkin = [];
	for( i=0; i<8; i++ )
	{
		// this for-loop is shared because there are equal number of attachments and camo skins.
		level.tbl_CamoSkin[i]["bitmask"] = int( tableLookup( "mp/attachmentTable.csv", 11, i, 10 ) );
		
		level.tbl_WeaponAttachment[i]["bitmask"] = int( tableLookup( "mp/attachmentTable.csv", 9, i, 10 ) );
		level.tbl_WeaponAttachment[i]["reference"] = tableLookup( "mp/attachmentTable.csv", 9, i, 4 );
	}
	
	level.tbl_weaponIDs = [];
	for( i=0; i<150; i++ )
	{
		reference_s = tableLookup( "mp/statsTable.csv", 0, i, 4 );
		if( reference_s != "" )
		{ 
			level.tbl_weaponIDs[i]["reference"] = reference_s;
			level.tbl_weaponIDs[i]["group"] = tablelookup( "mp/statstable.csv", 0, i, 2 );
			level.tbl_weaponIDs[i]["count"] = int( tablelookup( "mp/statstable.csv", 0, i, 5 ) );
			level.tbl_weaponIDs[i]["attachment"] = tablelookup( "mp/statstable.csv", 0, i, 8 );	
		}
		else
			continue;
	}
	
	perkReferenceToIndex = [];
	
	level.perkNames = [];
	level.perkIcons = [];
	level.PerkData = [];
	// generating perk data vars collected form statsTable.csv
	for( i=150; i<194; i++ )
	{
		reference_s = tableLookup( "mp/statsTable.csv", 0, i, 4 );
		if( reference_s != "" )
		{
			level.tbl_PerkData[i]["reference"] = reference_s;
			level.tbl_PerkData[i]["reference_full"] = tableLookup( "mp/statsTable.csv", 0, i, 6 );
			level.tbl_PerkData[i]["count"] = int( tableLookup( "mp/statsTable.csv", 0, i, 5 ) );
			level.tbl_PerkData[i]["group"] = tableLookup( "mp/statsTable.csv", 0, i, 2 );
			level.tbl_PerkData[i]["name"] = tableLookupIString( "mp/statsTable.csv", 0, i, 3 );
			precacheString( level.tbl_PerkData[i]["name"] );
			level.tbl_PerkData[i]["perk_num"] = tableLookup( "mp/statsTable.csv", 0, i, 8 );
			
			perkReferenceToIndex[ level.tbl_PerkData[i]["reference_full"] ] = i;
			
			level.perkNames[level.tbl_PerkData[i]["reference_full"]] = level.tbl_PerkData[i]["name"];
			level.perkIcons[level.tbl_PerkData[i]["reference_full"]] = level.tbl_PerkData[i]["reference_full"];
			precacheShader( level.perkIcons[level.tbl_PerkData[i]["reference_full"]] );
		}
		else
			continue;
	}
	
	// allowed perks in each slot, for validation.
	level.allowedPerks[0] = [];
	level.allowedPerks[1] = [];
	level.allowedPerks[2] = [];
	
	level.allowedPerks[0][ 0] = 190; // 190 through 193 are attachments and "none"
	level.allowedPerks[0][ 1] = 191;
	level.allowedPerks[0][ 2] = 192;
	level.allowedPerks[0][ 3] = 193;
	level.allowedPerks[0][ 4] = perkReferenceToIndex[ "specialty_weapon_c4" ];
	level.allowedPerks[0][ 5] = perkReferenceToIndex[ "specialty_specialgrenade" ];
	level.allowedPerks[0][ 6] = perkReferenceToIndex[ "specialty_weapon_rpg" ];
	level.allowedPerks[0][ 7] = perkReferenceToIndex[ "specialty_weapon_claymore" ];
	level.allowedPerks[0][ 8] = perkReferenceToIndex[ "specialty_fraggrenade" ];
	level.allowedPerks[0][ 9] = perkReferenceToIndex[ "specialty_extraammo" ];
	level.allowedPerks[0][10] = perkReferenceToIndex[ "specialty_detectexplosive" ];
	
	level.allowedPerks[1][ 0] = 190;
	level.allowedPerks[1][ 1] = perkReferenceToIndex[ "specialty_bulletdamage" ];
	level.allowedPerks[1][ 2] = perkReferenceToIndex[ "specialty_armorvest" ];
	level.allowedPerks[1][ 3] = perkReferenceToIndex[ "specialty_fastreload" ];
	level.allowedPerks[1][ 4] = perkReferenceToIndex[ "specialty_rof" ];
	level.allowedPerks[1][ 5] = perkReferenceToIndex[ "specialty_twoprimaries" ];
	level.allowedPerks[1][ 6] = perkReferenceToIndex[ "specialty_gpsjammer" ];
	level.allowedPerks[1][ 7] = perkReferenceToIndex[ "specialty_explosivedamage" ];
	
	level.allowedPerks[2][ 0] = 190;
	level.allowedPerks[2][ 1] = perkReferenceToIndex[ "specialty_longersprint" ];
	level.allowedPerks[2][ 2] = perkReferenceToIndex[ "specialty_bulletaccuracy" ];
	level.allowedPerks[2][ 3] = perkReferenceToIndex[ "specialty_pistoldeath" ];
	level.allowedPerks[2][ 4] = perkReferenceToIndex[ "specialty_grenadepulldeath" ];
	level.allowedPerks[2][ 5] = perkReferenceToIndex[ "specialty_bulletpenetration" ];
	level.allowedPerks[2][ 6] = perkReferenceToIndex[ "specialty_holdbreath" ];
	level.allowedPerks[2][ 7] = perkReferenceToIndex[ "specialty_quieter" ];
	level.allowedPerks[2][ 8] = perkReferenceToIndex[ "specialty_parabolic" ];
}

getClassChoice( response )
{
	tokens = strtok( response, "," );
	
	assert( isDefined( level.classMap[tokens[0]] ) );
	
	return ( level.classMap[tokens[0]] );
}

getWeaponChoice( response )
{
	tokens = strtok( response, "," );
	if ( tokens.size > 1 )
		return int(tokens[1]);
	else
		return 0;
}

// ============================================================================
// obtains custom class setup from stat values
cac_getdata()
{
	if ( isDefined( self.cac_initialized ) )
		return;
	
	/* custom class stat allocation order, example of custom class slot 1
	201  weapon_primary    
	202  weapon_primary attachment    
	203  weapon_secondary    
	204  weapon_secondary attachment    
	205  weapon_specialty1    
	206  weapon_specialty2    
	207  weapon_specialty3  
	208  weapon_special_grenade_type
	209	 weapon_primary_camo_style
	*/
	
	for( i = 0; i < 5; i ++ )
	{
		//assertex( self getstat ( i*10+200 ) == 1, "Custom class not initialized!" );
		
		// do not change the allocation and assignment of 0-299 stat bytes, or data will be misinterpreted by this function!
		primary_num = self getstat ( 200+(i*10)+1 );				// returns weapon number (also the unlock stat number from data table)
		primary_attachment_flag = self getstat ( 200+(i*10)+2 ); 	// returns attachment number (from data table)
		if ( !isDefined( level.tbl_WeaponAttachment[primary_attachment_flag] ) ) // handle bad attachment stat
			primary_attachment_flag = 0;
		primary_attachment_mask = level.tbl_WeaponAttachment[primary_attachment_flag]["bitmask"];
		secondary_num = self getstat ( 200+(i*10)+3 );				// returns weapon number (also the unlock stat number from data table)
		secondary_attachment_flag = self getstat ( 200+(i*10)+4 ); 	// returns attachment number (from data table)
		if ( !isDefined( level.tbl_WeaponAttachment[secondary_attachment_flag] ) ) // handle bad attachment stat
			secondary_attachment_flag = 0;
		secondary_attachment_mask = level.tbl_WeaponAttachment[secondary_attachment_flag]["bitmask"];
		specialty1 = self getstat ( 200+(i*10)+5 ); 				// returns specialty number (from data table)
		specialty2 = self getstat ( 200+(i*10)+6 ); 				// returns specialty number (from data table)
		specialty3 = self getstat ( 200+(i*10)+7 ); 				// returns specialty number (from data table)
		special_grenade = self getstat ( 200+(i*10)+8 );			// returns special grenade type as single special grenade items (from data table)
		camo_num = self getstat ( 200+(i*10)+9 );					// returns camo number (from data table)
		
		if ( camo_num < 0 || camo_num >= level.tbl_CamoSkin.size )
		{
			println( "^1Warning: (" + self.name + ") camo " + camo_num + " is invalid. Setting to none." );
			camo_num = 0;
		}
		
		camo_mask = level.tbl_CamoSkin[camo_num]["bitmask"];
		
		m16WeaponIndex = 25;
		assert( level.tbl_weaponIDs[m16WeaponIndex]["reference"] == "m16" );
		if ( primary_num < 0 || !isDefined( level.tbl_weaponIDs[ primary_num ] ) )
		{
			primary_num = m16WeaponIndex;
			primary_attachment_flag = 0;
		}
		if ( secondary_num < 0 || !isDefined( level.tbl_weaponIDs[ secondary_num ] ) )
		{
			secondary_num = 0;
			secondary_attachment_flag = 0;
		}
		
		specialty1 = validatePerk( specialty1, 0 );
		specialty2 = validatePerk( specialty2, 1 );
		specialty3 = validatePerk( specialty3, 2 );
		
		// if specialty2 is not Overkill, disallow anything besides pistols for secondary weapon
		if ( level.tbl_PerkData[specialty2]["reference_full"] != "specialty_twoprimaries" )
		{
			if ( level.tbl_weaponIDs[secondary_num]["group"] != "weapon_pistol" )
			{
				println( "^1Warning: (" + self.name + ") secondary weapon is not a pistol but perk 2 is not Overkill. Setting secondary weapon to pistol." );
				secondary_num = 0;
				secondary_attachment_flag = 0;
			}
		}
		// if certain attachments are used, make sure specialty1 is set right
		primary_attachment_ref = level.tbl_WeaponAttachment[primary_attachment_flag]["reference"];
		secondary_attachment_ref = level.tbl_WeaponAttachment[secondary_attachment_flag]["reference"];
		if ( primary_attachment_ref == "grip" || primary_attachment_ref == "gl" || secondary_attachment_ref == "grip" || secondary_attachment_ref == "gl" )
		{
			if ( specialty1 != 190 && specialty1 != 191 && specialty1 != 192 && specialty1 != 193 )
			{
				println( "^1Warning: (" + self.name + ") grip or grenade launcher is used but perk 1 was index " + specialty1 + ". Setting perk 1 to none." );
				specialty1 = 193; // 193 = there's an attachment, so no perk
			}
		}
		
		// validate weapon attachments, if faulty attachement found, reset to no attachments
		primary_ref = level.tbl_WeaponIDs[primary_num]["reference"];
		primary_attachment_set = level.tbl_weaponIDs[primary_num]["attachment"];
		secondary_ref = level.tbl_WeaponIDs[secondary_num]["reference"];
		secondary_attachment_set = level.tbl_weaponIDs[secondary_num]["attachment"];
		if ( !issubstr( primary_attachment_set, primary_attachment_ref ) )
		{
			println( "^1Warning: (" + self.name + ") attachment [" + primary_attachment_ref + "] is not valid for [" + primary_ref + "]. Removing attachment." );
			primary_attachment_flag = 0;
		}
		if ( !issubstr( secondary_attachment_set, secondary_attachment_ref ) )
		{
			println( "^1Warning: (" + self.name + ") attachment [" + secondary_attachment_ref + "] is not valid for [" + secondary_ref + "]. Removing attachment." );
			secondary_attachment_flag = 0;
		}
		
		// validate special grenade type
		flashGrenadeIndex = 101;
		assert( level.tbl_weaponIDs[flashGrenadeIndex]["reference"] == "flash_grenade" ); // if this fails we need to change flashGrenadeIndex
		if ( !isDefined( level.tbl_weaponIDs[special_grenade] ) )
			special_grenade = flashGrenadeIndex;
		specialGrenadeType = level.tbl_weaponIDs[special_grenade]["reference"];
		if ( specialGrenadeType != "flash_grenade" && specialGrenadeType != "smoke_grenade" && specialGrenadeType != "concussion_grenade" )
		{
			println( "^1Warning: (" + self.name + ") special grenade " + special_grenade + " is invalid. Setting to flash grenade." );
			special_grenade = flashGrenadeIndex;
		}
		
		if ( specialGrenadeType == "smoke_grenade" && level.tbl_PerkData[specialty1]["reference_full"] == "specialty_specialgrenade" )
		{
			println( "^1Warning: (" + self.name + ") smoke grenade may not be used with extra special grenades. Setting to flash grenade." );
			special_grenade = flashGrenadeIndex;
		}
		
		// apply attachment to primary weapon, getting weapon reference strings
		attachment_string = level.tbl_WeaponAttachment[primary_attachment_flag]["reference"];
		if( primary_attachment_flag != 0 && attachment_string != "" )
			self.custom_class[i]["primary"] = level.tbl_weaponIDs[primary_num]["reference"]+"_"+attachment_string+"_mp";
		else
			self.custom_class[i]["primary"] = level.tbl_weaponIDs[primary_num]["reference"]+"_mp";
		
		// apply attachment to secondary weapon, getting weapon reference strings
		attachment_string = level.tbl_WeaponAttachment[secondary_attachment_flag]["reference"];
		if( secondary_attachment_flag != 0 && attachment_string != "" )
			self.custom_class[i]["secondary"] = level.tbl_weaponIDs[secondary_num]["reference"]+"_"+attachment_string+"_mp"; 
		else
			self.custom_class[i]["secondary"] = level.tbl_weaponIDs[secondary_num]["reference"]+"_mp";
		
		// obtaining specialties, getting specialty reference strings
		assertex( isdefined( level.tbl_PerkData[specialty1] ), "Specialty #:"+specialty1+"'s data is undefined" );
		self.custom_class[i]["specialty1"] = level.tbl_PerkData[specialty1]["reference_full"]; //tablelookup( "mp/statstable.csv", level.cac_cstat, specialty1, level.cac_cimage );
		self.custom_class[i]["specialty1_weaponref"] = level.tbl_PerkData[specialty1]["reference"]; //tablelookup( "mp/statstable.csv", level.cac_cstat, specialty1, level.cac_creference );
		self.custom_class[i]["specialty1_count"] = level.tbl_PerkData[specialty1]["count"]; //int( tablelookup( "mp/statstable.csv", level.cac_cstat, specialty1, level.cac_ccount ) );
		self.custom_class[i]["specialty1_group"] = level.tbl_PerkData[specialty1]["group"]; //tablelookup( "mp/statstable.csv", level.cac_cstat, specialty1, level.cac_cgroup );
		
		self.custom_class[i]["specialty2"] = level.tbl_PerkData[specialty2]["reference"]; //tablelookup( "mp/statstable.csv", level.cac_cstat, specialty2, level.cac_creference );
		self.custom_class[i]["specialty2_weaponref"] = self.custom_class[i]["specialty2"];
		self.custom_class[i]["specialty2_count"] = level.tbl_PerkData[specialty2]["count"]; //int( tablelookup( "mp/statstable.csv", level.cac_cstat, specialty2, level.cac_ccount ) );
		self.custom_class[i]["specialty2_group"] = level.tbl_PerkData[specialty2]["group"]; //tablelookup( "mp/statstable.csv", level.cac_cstat, specialty2, level.cac_cgroup );
		
		self.custom_class[i]["specialty3"] = level.tbl_PerkData[specialty3]["reference"]; //tablelookup( "mp/statstable.csv", level.cac_cstat, specialty3, level.cac_creference );
		self.custom_class[i]["specialty3_weaponref"] = self.custom_class[i]["specialty3"];
		self.custom_class[i]["specialty3_count"] = level.tbl_PerkData[specialty3]["count"]; //int( tablelookup( "mp/statstable.csv", level.cac_cstat, specialty3, level.cac_ccount ) );
		self.custom_class[i]["specialty3_group"] = level.tbl_PerkData[specialty3]["group"]; //tablelookup( "mp/statstable.csv", level.cac_cstat, specialty3, level.cac_cgroup );
		
		// builds the full special grenade reference string
		self.custom_class[i]["special_grenade"] = level.tbl_weaponIDs[special_grenade]["reference"]+"_mp"; //tablelookup( "mp/statstable.csv", level.cac_numbering, special_grenade, level.cac_creference ) + "_mp";
		self.custom_class[i]["special_grenade_count"] = level.tbl_weaponIDs[special_grenade]["count"]; //int( tablelookup( "mp/statstable.csv", level.cac_numbering, special_grenade, level.cac_ccount ) );
		
		// camo selection, default 0 = no camo skin
		self.custom_class[i]["camo_num"] = camo_num;
		self.cac_initialized = true;
		
		/* debug
		println( "\n ========== CLASS DEBUG INFO ========== \n" );
		println( "Primary: "+self.custom_class[i]["primary"] );
		println( "Secondary: "+self.custom_class[i]["secondary"] );
		println( "Specialty1: "+self.custom_class[i]["specialty1"]+" - Group: "+self.custom_class[i]["specialty1_group"]+" - Count: "+self.custom_class[i]["specialty1_count"] );
		println( "Specialty2: "+self.custom_class[i]["specialty2"] );
		println( "Specialty3: "+self.custom_class[i]["specialty3"] );
		println( "Special Grenade: "+self.custom_class[i]["special_grenade"]+" - Count: "+self.custom_class[i]["special_grenade_count"] );
		println( "Primary Camo: "+attachmenttablelookup( level.cac_cname, level.cac_cint2, camo_num ) );
		*/
	}
}

validatePerk( perkIndex, perkSlotIndex )
{
	for ( i = 0; i < level.allowedPerks[ perkSlotIndex ].size; i++ )
	{
		if ( perkIndex == level.allowedPerks[ perkSlotIndex ][i] )
			return perkIndex;
	}
	println( "^1Warning: (" + self.name + ") Perk " + level.tbl_PerkData[perkIndex]["reference_full"] + " is not allowed for perk slot index " + perkSlotIndex + "; replacing with no perk" );
	return 190;
}


logClassChoice( class, primaryWeapon, specialType, perks )
{
	if ( class == self.lastClass )
		return;

	self logstring( "choseclass: " + class + " weapon: " + primaryWeapon + " special: " + specialType );		
	for( i=0; i<perks.size; i++ )
		self logstring( "perk" + i + ": " + perks[i] );
	
	self.lastClass = class;
}

// distributes the specialties into the corrent slots; inventory, grenades, special grenades, generic specialties
get_specialtydata( class_num, specialty )
{
	cac_reference = self.custom_class[class_num][specialty];
	cac_weaponref = self.custom_class[class_num][specialty+"_weaponref"];	// for inventory whos string ref is the weapon ref
	cac_group = self.custom_class[class_num][specialty+"_group"];
	cac_count = self.custom_class[class_num][specialty+"_count"];
		
	assertex( isdefined( cac_group ), "Missing "+specialty+"'s group name" );
	
	// grenade classification and distribution ==================
	if( specialty == "specialty1" )
	{
		if( isSubstr( cac_group, "grenade" ) )
		{
			// if user selected 3 frags, then give 3 count, else always give 1
			if( cac_reference == "specialty_fraggrenade" )
			{
				self.custom_class[class_num]["grenades"] = level.weapons["frag"];
				self.custom_class[class_num]["grenades_count"] = cac_count;
			}
			else
			{
				self.custom_class[class_num]["grenades"] = level.weapons["frag"];
				self.custom_class[class_num]["grenades_count"] = 1;
			}
			
			// if user selected 3 special grenades, then give 3 count to the selected special grenade type, else always give 1
			assertex( isdefined( self.custom_class[class_num]["special_grenade"] ) && isdefined( self.custom_class[class_num]["special_grenade_count"] ), "Special grenade missing from custom class loadout" );
			if( cac_reference == "specialty_specialgrenade" )
			{
				self.custom_class[class_num]["specialgrenades"] = self.custom_class[class_num]["special_grenade"];
				self.custom_class[class_num]["specialgrenades_count"] = cac_count;
			}
			else
			{
				self.custom_class[class_num]["specialgrenades"] = self.custom_class[class_num]["special_grenade"];
				self.custom_class[class_num]["specialgrenades_count"] = 1;
			}
			return;
		}
		else
		{
			assertex( isdefined( self.custom_class[class_num]["special_grenade"] ), "Special grenade missing from custom class loadout" );
			self.custom_class[class_num]["grenades"] = level.weapons["frag"];
			self.custom_class[class_num]["grenades_count"] = 1;
			self.custom_class[class_num]["specialgrenades"] = self.custom_class[class_num]["special_grenade"];
			self.custom_class[class_num]["specialgrenades_count"] = 1;
		}
	}
			
	// if user selected inventory items
	if( cac_group == "inventory" )
	{
		// inventory distribution to action slot 3 - unique per class
		assertex( isdefined( cac_count ) && isdefined( cac_weaponref ), "Missing "+specialty+"'s reference or count data" );
		self.custom_class[class_num]["inventory"] = cac_weaponref;		// loads inventory into action slot 3
		self.custom_class[class_num]["inventory_count"] = cac_count;	// loads ammo count
	}
	else if( cac_group == "specialty" )
	{
		// building player's specialty, variable size array with size 3 max
		if( self.custom_class[class_num][specialty] != "" )
			self.specialty[self.specialty.size] = self.custom_class[class_num][specialty];
	}
}

/* interface function for code table lookup using class table data
classtablelookup( get_col, with_col, with_data )
{
	return_value = tablelookup( "mp/classtable.csv", with_col, with_data, get_col );
	assertex( isdefined( return_value ), "Data not found: "+get_col+" column, using "+with_data+" in the "+with_col+"th column. ");
	return return_value;	
}

// interface function for code table lookup using weapon attachment table data
attachmenttablelookup( get_col, with_col, with_data )
{
	return_value = tablelookup( "mp/attachmenttable.csv", with_col, with_data, get_col );
	assertex( isdefined( return_value ), "Data not found: "+get_col+" column, using "+with_data+" in the "+with_col+"th column. ");
	return return_value;	
}

// interface function for code table lookup using weapon stats table data
statstablelookup( get_col, with_col, with_data )
{
	// with_data = the data from the table
	// with_col = look in this column for the data
	// get_col = once data found, return the value of get_col in the same row	
	return_value = tablelookup( "mp/statstable.csv", with_col, with_data, get_col );
	assertex( isdefined( return_value ), "Data not found: "+get_col+" column, using "+with_data+" in the "+with_col+"th column. ");
	return return_value;
}
*/

// clears all player's custom class variables, prepare for update with new stat data
reset_specialty_slots( class_num )
{
	self.specialty = [];		// clear all specialties
	self.custom_class[class_num]["inventory"] = "";
	self.custom_class[class_num]["inventory_count"] = 0;
	self.custom_class[class_num]["inventory_group"] = "";
	self.custom_class[class_num]["grenades"] = ""; 
	self.custom_class[class_num]["grenades_count"] = 0;
	self.custom_class[class_num]["grenades_group"] = "";
	self.custom_class[class_num]["specialgrenades"] = "";
	self.custom_class[class_num]["specialgrenades_count"] = 0;
	self.custom_class[class_num]["specialgrenades_group"] = "";
}

giveLoadout( team, class )
{
	self takeAllWeapons();
	
	/*
	if ( level.splitscreen )
		primaryIndex = 0;
	else
		primaryIndex = self.pers["primary"];
	*/
	
	primaryIndex = 0;
	
	// initialize specialty array
	self.specialty = [];

	primaryWeapon = undefined;
	
	// ============= custom class selected ==============
	if( isSubstr( class, "CLASS_CUSTOM" ) )
	{	
		// gets custom class data from stat bytes
		self cac_getdata();
	
		// obtains the custom class number
		class_num = int( class[class.size-1] )-1;
		self.class_num = class_num;
		
		assertex( isdefined( self.custom_class[class_num]["primary"] ), "Custom class "+class_num+": primary weapon setting missing" );
		assertex( isdefined( self.custom_class[class_num]["secondary"] ), "Custom class "+class_num+": secondary weapon setting missing" );
		assertex( isdefined( self.custom_class[class_num]["specialty1"] ), "Custom class "+class_num+": specialty1 setting missing" );
		assertex( isdefined( self.custom_class[class_num]["specialty2"] ), "Custom class "+class_num+": specialty2 setting missing" );
		assertex( isdefined( self.custom_class[class_num]["specialty3"] ), "Custom class "+class_num+": specialty3 setting missing" );
		
		// clear of specialty slots, repopulate the current selected class' setup
		self reset_specialty_slots( class_num );
		self get_specialtydata( class_num, "specialty1" );
		self get_specialtydata( class_num, "specialty2" );
		self get_specialtydata( class_num, "specialty3" );
		
		// set re-register perks to code
		self register_perks();
		// at this stage, the specialties are loaded into the correct weapon slots, and special slots
		
		// weapon override for round based gametypes
		// TODO: if they switched to a sidearm, we shouldn't give them that as their primary!
		if ( isDefined( self.pers["weapon"] ) && self.pers["weapon"] != "none" )
			weapon = self.pers["weapon"];
		else
			weapon = self.custom_class[class_num]["primary"];
		
		sidearm = self.custom_class[class_num]["secondary"];

		self GiveWeapon( sidearm );
		if ( self cac_hasSpecialty( "specialty_extraammo" ) )
			self giveMaxAmmo( sidearm );
			
		// give primary weapon
		primaryWeapon = weapon;
		
		assertex( isdefined( self.custom_class[class_num]["camo_num"] ), "Player's camo skin is not defined, it should be at least initialized to 0" );

		primaryTokens = strtok( primaryWeapon, "_" );
		self.pers["primaryWeapon"] = primaryTokens[0];
		
		self maps\mp\gametypes\_teams::playerModelForWeapon( self.pers["primaryWeapon"] );
		
		self GiveWeapon( weapon, self.custom_class[class_num]["camo_num"] );
		if ( self cac_hasSpecialty( "specialty_extraammo" ) )
			self giveMaxAmmo( weapon );
		self setSpawnWeapon( weapon );
		
		// give secondary weapon
		
		self SetActionSlot( 1, "nightvision" );
		
		secondaryWeapon = self.custom_class[class_num]["inventory"];
		if ( secondaryWeapon != "" )
		{
			self GiveWeapon( secondaryWeapon );
			
			self setWeaponAmmoOverall( secondaryWeapon, self.custom_class[class_num]["inventory_count"] );
			
			self SetActionSlot( 3, "weapon", secondaryWeapon );
			self SetActionSlot( 4, "" );
		}
		else
		{
			self SetActionSlot( 3, "altMode" );
			self SetActionSlot( 4, "" );
		}
		
		// give frag for all no matter what
		grenadeTypePrimary = self.custom_class[class_num]["grenades"]; 
		if ( grenadeTypePrimary != "" )
		{
			grenadeCount = self.custom_class[class_num]["grenades_count"]; 
	
			self GiveWeapon( grenadeTypePrimary );
			self SetWeaponAmmoClip( grenadeTypePrimary, grenadeCount );
			self SwitchToOffhand( grenadeTypePrimary );
		}
		
		// give special grenade
		grenadeTypeSecondary = self.custom_class[class_num]["specialgrenades"]; 
		if ( grenadeTypeSecondary != "" )
		{
			grenadeCount = self.custom_class[class_num]["specialgrenades_count"]; 
	
			if ( grenadeTypeSecondary == level.weapons["flash"])
				self setOffhandSecondaryClass("flash");
			else
				self setOffhandSecondaryClass("smoke");
			
			self giveWeapon( grenadeTypeSecondary );
			self SetWeaponAmmoClip( grenadeTypeSecondary, grenadeCount );
		}
		
		self thread logClassChoice( class, primaryWeapon, grenadeTypeSecondary, self.specialty );
	}
	else
	{	
		// ============= selected one of the default classes ==============
				
		// load the selected default class's specialties
		assertex( isdefined(self.pers["class"]), "Player during spawn and loadout got no class!" );
		selected_class = self.pers["class"];
		specialty_size = level.default_perk[selected_class].size;
		
		for( i = 0; i < specialty_size; i++ )
		{
			if( isdefined( level.default_perk[selected_class][i] ) && level.default_perk[selected_class][i] != "" )
				self.specialty[self.specialty.size] = level.default_perk[selected_class][i];
		}
		assertex( isdefined( self.specialty ) && self.specialty.size > 0, "Default class: " + self.pers["class"] + " is missing specialties " );
		
		// re-registering perks to code since perks are cleared after respawn in case if players switch classes
		self register_perks();
		
		// weapon override for round based gametypes
		// TODO: if they switched to a sidearm, we shouldn't give them that as their primary!
		if ( isDefined( self.pers["weapon"] ) && self.pers["weapon"] != "none" )
			weapon = self.pers["weapon"];
		else
			weapon = level.classWeapons[team][class][primaryIndex];
		
		sidearm = level.classSidearm[team][class];
		
		self GiveWeapon( sidearm );
		if ( self cac_hasSpecialty( "specialty_extraammo" ) )
			self giveMaxAmmo( sidearm );

		// give primary weapon
		primaryWeapon = weapon;

		primaryTokens = strtok( primaryWeapon, "_" );
		self.pers["primaryWeapon"] = primaryTokens[0];
		
		if ( self.pers["primaryWeapon"] == "m14" )
			self.pers["primaryWeapon"] = "m21";
	
		self maps\mp\gametypes\_teams::playerModelForWeapon( self.pers["primaryWeapon"] );		

		self GiveWeapon( weapon );
		if( self cac_hasSpecialty( "specialty_extraammo" ) )
			self giveMaxAmmo( weapon );
		self setSpawnWeapon( weapon );
		
		// give secondary weapon
		self SetActionSlot( 1, "nightvision" );
	
		secondaryWeapon = level.classItem[team][class]["type"];	
		if ( secondaryWeapon != "" )
		{
			self GiveWeapon( secondaryWeapon );
			
			self setWeaponAmmoOverall( secondaryWeapon, level.classItem[team][class]["count"] );
			
			self SetActionSlot( 3, "weapon", secondaryWeapon );
			self SetActionSlot( 4, "" );
		}
		else
		{
			self SetActionSlot( 3, "altMode" );
			self SetActionSlot( 4, "" );
		}
		
		grenadeTypePrimary = level.classGrenades[class]["primary"]["type"];
		if ( grenadeTypePrimary != "" )
		{
			grenadeCount = level.classGrenades[class]["primary"]["count"];
	
			self GiveWeapon( grenadeTypePrimary );
			self SetWeaponAmmoClip( grenadeTypePrimary, grenadeCount );
			self SwitchToOffhand( grenadeTypePrimary );
		}
		
		grenadeTypeSecondary = level.classGrenades[class]["secondary"]["type"];
		if ( grenadeTypeSecondary != "" )
		{
			grenadeCount = level.classGrenades[class]["secondary"]["count"];
	
			if ( grenadeTypeSecondary == level.weapons["flash"])
				self setOffhandSecondaryClass("flash");
			else
				self setOffhandSecondaryClass("smoke");
			
			self giveWeapon( grenadeTypeSecondary );
			self SetWeaponAmmoClip( grenadeTypeSecondary, grenadeCount );
		}

		self thread logClassChoice( class, primaryWeapon, grenadeTypeSecondary, self.specialty );
	}

	switch ( weaponClass( primaryWeapon ) )
	{
		case "rifle":
			self setMoveSpeedScale( 0.95 );
			break;
		case "pistol":
			self setMoveSpeedScale( 1.0 );
			break;
		case "mg":
			self setMoveSpeedScale( 0.875 );
			break;
		case "smg":
			self setMoveSpeedScale( 1.0 );
			break;
		case "spread":
			self setMoveSpeedScale( 1.0 );
			break;
		default:
			self setMoveSpeedScale( 1.0 );
			break;
	}
	
	// cac specialties that require loop threads
	self cac_selector();
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

replenishLoadout() // used by ammo hardpoint.
{
	team = self.pers["team"];
	class = self.pers["class"];

    weaponsList = self GetWeaponsList();
    for( idx = 0; idx < weaponsList.size; idx++ )
    {
		weapon = weaponsList[idx];

		self giveMaxAmmo( weapon );
		self SetWeaponAmmoClip( weapon, 9999 );

		if ( weapon == "claymore_mp" || weapon == "claymore_detonator_mp" )
			self setWeaponAmmoStock( weapon, 2 );
    }
	
	if ( self getAmmoCount( level.classGrenades[class]["primary"]["type"] ) < level.classGrenades[class]["primary"]["count"] )
 		self SetWeaponAmmoClip( level.classGrenades[class]["primary"]["type"], level.classGrenades[class]["primary"]["count"] );

	if ( self getAmmoCount( level.classGrenades[class]["secondary"]["type"] ) < level.classGrenades[class]["secondary"]["count"] )
 		self SetWeaponAmmoClip( level.classGrenades[class]["secondary"]["type"], level.classGrenades[class]["secondary"]["count"] );	
}

onPlayerConnecting()
{
	for(;;)
	{
		level waittill( "connecting", player );

		if ( !level.oldschool )
		{
			if ( !isDefined( player.pers["class"] ) )
			{
				player.pers["class"] = "";
			}
			player.class = player.pers["class"];
			player.lastClass = "";
		}
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
		if ( perk == "specialty_null" || isSubStr( perk, "specialty_weapon_" ) )
			continue;
			
		self setPerk( perk );
	}
	
	/#
	maps\mp\gametypes\_dev::giveExtraPerks();
	#/
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
