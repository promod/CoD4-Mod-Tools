
// weapon loadout info display ============

	// primary weapon name
	PREPROC_TEXT_DRAW_ALIGNED_EXP2( CHOICE_SIZE_X CHOICE_Y(1) (LOADOUT_WIDTH+8) 20 LOADOUT_ALIGN, ORIGIN_LOADOUT, "@"+tablelookup("mp/statstable.csv", 0, STAT_CAC_PRIMARY, 3), UI_FONT_SMALL, TEXTSIZE_SMALL, 4, 0, ITEM_ALIGN_MIDDLE_LEFT, COLOR_TITLE name CLASS_NAME group GROUP_NAME )
	// primary weapon image
	PREPROC_SHADER_DRAW_ALIGNED( CHOICE_SIZE_X (CHOICE_Y(1)+4) 128 64 LOADOUT_ALIGN, ORIGIN_LOADOUT, tablelookup( "mp/statstable.csv", 0, STAT_CAC_PRIMARY, 6 ), 1 1 1 1, 0, 1, 1 1 1 1 name CLASS_NAME group GROUP_NAME ) 

	// second weapon name
	PREPROC_TEXT_DRAW_ALIGNED_EXP2( CHOICE_SIZE_X (CHOICE_Y(4)+8) (LOADOUT_WIDTH+8) 20 LOADOUT_ALIGN, ORIGIN_LOADOUT, "@"+tablelookup("mp/statstable.csv", 0, STAT_CAC_SECONDARY, 3), UI_FONT_SMALL, TEXTSIZE_SMALL, 4, 0, ITEM_ALIGN_MIDDLE_LEFT, COLOR_TITLE name CLASS_NAME group GROUP_NAME )
	// second weapon image
	PREPROC_SHADER_DRAW_ALIGNED( CHOICE_SIZE_X (CHOICE_Y(4)+16) 64 64 LOADOUT_ALIGN, ORIGIN_LOADOUT, tablelookup( "mp/statstable.csv", 0, STAT_CAC_SECONDARY, 6 ), 1 1 1 1, 0, 1, 1 1 1 1 name CLASS_NAME group GROUP_NAME ) 

// perk loadout info display =============

	// perk 1 icon
	PREPROC_SHADER_DRAW_ALIGNED( PERK_X_OFFSET PERK_Y_OFFSET 32 32 LOADOUT_ALIGN, ORIGIN_LOADOUT, tablelookup( "mp/statstable.csv", 1, STAT_CAC_SPECIALTY_EQUIPMENT, 6 ), 1 1 1 0.65, 0, 1, 1 1 1 1 name CLASS_NAME group GROUP_NAME ) 
	// perk 2 icon
	PREPROC_SHADER_DRAW_ALIGNED( PERK_X_OFFSET (PERK_Y_OFFSET+PERK_Y_SPACING) 32 32 LOADOUT_ALIGN, ORIGIN_LOADOUT, tablelookup( "mp/statstable.csv", 1, STAT_CAC_SPECIALTY_WEAPON, 6 ), 1 1 1 0.65, 0, 1, 1 1 1 1 name CLASS_NAME group GROUP_NAME ) 
	// perk 3 icon
	PREPROC_SHADER_DRAW_ALIGNED( (PERK_X_OFFSET-36) (PERK_Y_OFFSET+PERK_Y_SPACING) 32 32 LOADOUT_ALIGN, ORIGIN_LOADOUT, tablelookup( "mp/statstable.csv", 1, STAT_CAC_SPECIALTY_ABILITY, 6 ), 1 1 1 0.65, 0, 1, 1 1 1 1 name CLASS_NAME group GROUP_NAME ) 

/*
	LOCAL_GRENADE( CLASS_NAME, GROUP_NAME, "Frag / "+tablelookup("mp/statstable.csv",0,STAT_CAC_SPECIAL_GRENADE,3)+" x 1", tablelookup( "mp/statstable.csv", 1, STAT_CAC_SPECIALTY_EQUIPMENT, 4 ) != "specialty_specialgrenade" && tablelookup( "mp/statstable.csv", 1, STAT_CAC_SPECIALTY_EQUIPMENT, 4 ) != "specialty_fraggrenade" )
	LOCAL_GRENADE( CLASS_NAME, GROUP_NAME, "Frag x 1", tablelookup( "mp/statstable.csv", 1, STAT_CAC_SPECIALTY_EQUIPMENT, 4 ) == "specialty_specialgrenade" )
	LOCAL_GRENADE( CLASS_NAME, GROUP_NAME, tablelookup("mp/statstable.csv",0,STAT_CAC_SPECIAL_GRENADE,3)+" x 1", tablelookup("mp/statstable.csv",1,STAT_CAC_SPECIALTY_EQUIPMENT,4)=="specialty_fraggrenade" )
*/

	// grenade icons
	PREPROC_SHADER_DRAW_ALIGNED( PERK_X_OFFSET2 (PERK_Y_OFFSET+6) 32 32 LOADOUT_ALIGN, ORIGIN_LOADOUT, "weapon_fraggrenade", 1 1 1 1, 0, 1, 1 1 1 1 visible when( tablelookup( "mp/statstable.csv", 1, STAT_CAC_SPECIALTY_EQUIPMENT, 4 ) == "specialty_specialgrenade" ); name CLASS_NAME group GROUP_NAME ) 
	PREPROC_SHADER_DRAW_ALIGNED( PERK_X_OFFSET2 (PERK_Y_OFFSET+4) 32 32 LOADOUT_ALIGN, ORIGIN_LOADOUT, "weapon_smokegrenade", 1 1 1 1, 0, 1, 1 1 1 1 visible when( tablelookup("mp/statstable.csv",1,STAT_CAC_SPECIALTY_EQUIPMENT,4)=="specialty_fraggrenade" ); name CLASS_NAME group GROUP_NAME ) 
	PREPROC_SHADER_DRAW_ALIGNED( (PERK_X_OFFSET2-6) (PERK_Y_OFFSET+6) 32 32 LOADOUT_ALIGN, ORIGIN_LOADOUT, "weapon_fraggrenade", 1 1 1 1, 0, 1, 1 1 1 1 visible when( tablelookup( "mp/statstable.csv", 1, STAT_CAC_SPECIALTY_EQUIPMENT, 4 ) != "specialty_specialgrenade" && tablelookup( "mp/statstable.csv", 1, STAT_CAC_SPECIALTY_EQUIPMENT, 4 ) != "specialty_fraggrenade" ); name CLASS_NAME group GROUP_NAME ) 
	PREPROC_SHADER_DRAW_ALIGNED( (PERK_X_OFFSET2+8) (PERK_Y_OFFSET+4) 32 32 LOADOUT_ALIGN, ORIGIN_LOADOUT, "weapon_smokegrenade", 1 1 1 1, 0, 1, 1 1 1 1 visible when( tablelookup( "mp/statstable.csv", 1, STAT_CAC_SPECIALTY_EQUIPMENT, 4 ) != "specialty_specialgrenade" && tablelookup( "mp/statstable.csv", 1, STAT_CAC_SPECIALTY_EQUIPMENT, 4 ) != "specialty_fraggrenade" ); name CLASS_NAME group GROUP_NAME )  