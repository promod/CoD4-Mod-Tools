// general definitions

#define CHOICE_X_START			0
#define CHOICE_Y_START			34

#define CHOICE_SEP_1			4
#define CHOICE_SEP_2			7

#include "ui_mp/menustyle.inc"
#include "ui/choices_setup_common.menu"
 
#define ORIGIN_STATUS			390 64
#define MENU_FONT_COLOR2		1 1 1 0.5

#include "ui_mp/stats_info.inc"

	// ========================== Perk 1 special cases ===========================
	#define UPDATE_PERK1 \
		execOnDvarStringValue loadout_primary_attachment gl "set loadout_perk1_locked 1;set loadout_perk1 specialty_null"; \
		execOnDvarStringValue loadout_primary_attachment grip "set loadout_perk1_locked 1;set loadout_perk1 specialty_null"; \
		execOnDvarStringValue loadout_primary_attachment none "set loadout_perk1_locked 0"; \
		execOnDvarStringValue loadout_primary_attachment acog "set loadout_perk1_locked 0"; \
		execOnDvarStringValue loadout_primary_attachment silencer "set loadout_perk1_locked 0"; \
		execOnDvarStringValue loadout_primary_attachment reflex "set loadout_perk1_locked 0";	

	menuDef	{
		name			CAC_MENU_NAME
		rect			0 0 640 480
		focuscolor		COLOR_FOCUSED
		style			WINDOW_STYLE_EMPTY
		blurWorld		7.0
		onOpen {			
			setfocus primary_weapon_selection;
			UPDATE_PERK1;
		}
		onEsc {
			scriptMenuResponse "back";
		}

		itemDef
		{
			style			WINDOW_STYLE_SHADER
			rect			FULLSCREEN_WIDE
			background		"animbg_blur_back"
			backcolor		1 1 1 0.75
			visible			1
			decoration
		}

		// ------------------  statics ------------------------

		CHOICE_MENU_TITLE( "@MPUI_CREATE_A_CLASS_CAP" )				
		// ------------------------- buttons ------------------------------
		#define BACK_OPEN ;
		#include "ui_mp/navcontrols.inc"
		
		//=========================================================
		//===================== MENU SELECTION ====================
		//=========================================================
		
		// PRIMARY WEAPON BUTTON =============================================================
		#define CAC_SETUP_ACTION1 \
			play "mouse_click"; \
			execOnDvarStringValue loadout_class assault "set selected_weapon_class assault;set ui_weapon_class_selected @MPUI_ASSAULT_RIFLES"; \
			execOnDvarStringValue loadout_class specops "set selected_weapon_class specops;set ui_weapon_class_selected @MPUI_SUB_MACHINE_GUNS"; \
			execOnDvarStringValue loadout_class heavygunner "set selected_weapon_class heavygunner;set ui_weapon_class_selected @MPUI_LIGHT_MACHINE_GUNS"; \
			execOnDvarStringValue loadout_class demolitions "set selected_weapon_class demolitions;set ui_weapon_class_selected @MPUI_SHOTGUNS"; \
			execOnDvarStringValue loadout_class sniper "set selected_weapon_class sniper;set ui_weapon_class_selected @MPUI_SNIPER_RIFLES"; \
			uiScript openMenuOnDvar loadout_class assault "ocd_popup_cac_assault"; \
			uiScript openMenuOnDvar loadout_class specops "ocd_popup_cac_SMG"; \
			uiScript openMenuOnDvar loadout_class heavygunner "ocd_popup_cac_LMG"; \
			uiScript openMenuOnDvar loadout_class demolitions "ocd_popup_cac_shotgun"; \
			uiScript openMenuOnDvar loadout_class sniper "ocd_popup_cac_sniper";
		
		CHOICE_BUTTON_EX( 1, "@MPUI_PRIMARY_WEAPON1", CAC_SETUP_ACTION1, name primary_weapon_selection )

		#define CAC_SETUP_ACTION_ATTACHMENT \
			play "mouse_click"; \
			uiScript openMenuOnDvar loadout_class assault "ocd_attachment_popup_assault"; \
			uiScript openMenuOnDvar loadout_class specops "ocd_attachment_popup_SMG"; \
			uiScript openMenuOnDvar loadout_class heavygunner "ocd_attachment_popup_LMG"; \
			uiScript openMenuOnDvar loadout_class demolitions "ocd_attachment_popup_shotgun"; \
			uiScript openMenuOnDvar loadout_class sniper "ocd_attachment_popup_sniper";

		CHOICE_BUTTON_BG( 2, 1 )
		CHOICE_HIGHLIGHT( 2, 1 )		
		CHOICE_BUTTON_VIS_NOHI( 2, "@PERKS_ATTACHMENT", CAC_SETUP_ACTION_ATTACHMENT, when( dvarString( loadout_primary ) != "mp44" ) )
		CHOICE_DBUTTON_VIS_NOHI( 2, "@PERKS_ATTACHMENT", when( dvarString( loadout_primary ) == "mp44" ) )

		// SECONDARY WEAPON/SIDE ARM BUTTON =============================================================
		#define CAC_SETUP_ACTION2 \
			play "mouse_click"; \
			open "ocd_popup_cac_secondary";

		CHOICE_BUTTON( 3, "@MPUI_SIDE_ARM1", CAC_SETUP_ACTION2 )
	
		// SPECIAL GRENADE BUTTON =============================================================
		#define CAC_SETUP_ACTION3 \
			play "mouse_click"; \
			open "ocd_popup_cac_extra";
			
		CHOICE_BUTTON( 4, "@MPUI_SPECIAL_GRENADE", CAC_SETUP_ACTION3 )

		/* separator bar */ CHOICE_SEPARATOR( CHOICE_SEP_1 )
				
		#define CAC_SETUP_ACTION4 \
			play "mouse_click"; \
			open "ocd_popup_cac_perk1";	
		
		// PERK 1 BUTTON =============================================================
		// perk 1 empty warning
		CHOICE_BUTTON_BG_RAW( 5, "gradient_fadein", 0.5 0.15 0 0.5, when( dvarString(loadout_perk1) == "specialty_null" && !dvarBool(loadout_perk1_locked) ); )
		CHOICE_BUTTON_FOCUS_VIS_ADV( 5, "@MPUI_PERK_1", CAC_SETUP_ACTION4, ;, ;, when( !dvarBool(loadout_perk1_locked) ), !dvarBool(loadout_perk1_locked) )
		CHOICE_BUTTON_FOCUS_VIS_NOHI( 5, "", ;, ;, ;, when( dvarBool(loadout_perk1_locked) ) )
		CHOICE_DBUTTON_VIS( 5, "@MPUI_PERK_1", when( dvarBool(loadout_perk1_locked) ) )

		// PERK 2 BUTTON =============================================================
		#define CAC_SETUP_ACTION5 \		
			play "mouse_click"; \
			open "ocd_popup_cac_perk2";		

		CHOICE_BUTTON_BG_RAW( 6, "gradient_fadein", 0.5 0.15 0 0.5, when( dvarString(loadout_perk2) == "specialty_null" ); )
		CHOICE_BUTTON( 6, "@MPUI_PERK_2", CAC_SETUP_ACTION5 )
		
		// PERK 3 BUTTON =============================================================
		#define CAC_SETUP_ACTION6 \		
			play "mouse_click"; \
			open "ocd_popup_cac_perk3";		

		CHOICE_BUTTON_BG_RAW( 7, "gradient_fadein", 0.5 0.15 0 0.5, when( dvarString(loadout_perk3) == "specialty_null" ); )
		CHOICE_BUTTON( 7, "@MPUI_PERK_3", CAC_SETUP_ACTION6 )
		
		/* separator bar */ CHOICE_SEPARATOR( CHOICE_SEP_2 )

		#define CAC_SETUP_ACTIONGO \		
			play "mouse_click"; \
			scriptMenuResponse "go";

		CHOICE_BUTTON( 8, "@MENU_ACCEPT", CAC_SETUP_ACTIONGO )
				
		/* ================================================================================= */
		/* ================================ LOADOUT DISPLAY ================================ */
		/* ================================================================================= */

		#define STAT_CAC_PRIMARY				tableLookup("mp/statstable.csv", 4, dvarString( loadout_primary ), 0)
		#define STAT_CAC_PRIMARY_ATTACHMENT		tableLookup("mp/attachmentTable.csv", 4, dvarString( loadout_primary_attachment ), 9)
		#define STAT_CAC_SECONDARY				tableLookup("mp/statstable.csv", 4, dvarString( loadout_secondary ), 0)
		#define STAT_CAC_SECONDARY_ATTACHMENT	tableLookup("mp/attachmentTable.csv", 4, dvarString( loadout_secondary_attachment ), 9)
		#define STAT_CAC_SPECIALTY_EQUIPMENT	tableLookup("mp/statstable.csv", 4, dvarString( loadout_perk1 ), 0)
		#define STAT_CAC_SPECIALTY_WEAPON		tableLookup("mp/statstable.csv", 4, dvarString( loadout_perk2 ), 0)
		#define STAT_CAC_SPECIALTY_ABILITY		tableLookup("mp/statstable.csv", 4, dvarString( loadout_perk3 ), 0)
		#define STAT_CAC_SPECIAL_GRENADE		tableLookup("mp/statstable.csv", 4, dvarString( loadout_grenade ), 0)
		#define STAT_CAC_CAMO					tableLookup("mp/attachmentTable.csv", 4, dvarString( loadout_camo ), 11)
		
		#include "ui_mp/cac_loadout_ingame.inc"

		#include "ui/safearea.menu"
	}

	// close all 2nd and 3rd layer popups on end action
	#define PREPROC_ATTACH_CLOSEALL \
	close "ocd_popup_cac_primary"; \
	close "ocd_popup_cac_secondary"; \
	close "ocd_popup_cac_assault"; \
	close "ocd_popup_cac_SMG"; \
	close "ocd_popup_cac_LMG"; \
	close "ocd_popup_cac_sniper"; \
	close "ocd_popup_cac_shotgun"; \
	close "popup_cac_template"; \
	close "ocd_attachment_popup_assault"; \
	close "ocd_attachment_popup_SMG"; \
	close "ocd_attachment_popup_LMG"; \
	close "ocd_attachment_popup_sniper"; \
	close "ocd_attachment_popup_shotgun"; \
	close "ocd_attachment_popup_pistol"; \
	close "ocd_popup_cac_camo"; \
	close "ocd_attachment_popup_fake";	
	
	// including weapon data
	#include "ui_mp/weaponinfo.menu"
	
#include "ui_mp/popupstyle.inc"	
#include "ui/choices_setup_popmenu.menu"

#undef CHOICE_SIZE_X
#define CHOICE_SIZE_X			216

#undef NEW_X_OFFSET			
#define NEW_X_OFFSET	(0-CHOICE_SIZE_X)

#undef NEW_Y_OFFSET			
#define NEW_Y_OFFSET	(0-2)

	// ====================================================================================================
	// primary weapon selection ===========================================================================
	// ====================================================================================================
	#define LOCAL_WEAPON_INFO_WINDOW( highlight_dvar ) \
		/* weapon information side frame*/ \
		PREPROC_SHADER_DRAW_ALIGNED( (CHOICE_POPUP_WIDTH-6) -4 280 CHOICE_POPUP_HEIGHT( 7 ) CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "white", CHOICE_POPUP_BORDER_COLOR, 1, 2, CHOICE_POPUP_BORDER_COLOR visible when( dvarString(ui_inside_popup) != "attachment" && dvarString(ui_inside_popup) != "camo" ); ) \
		LOADOUT_PLATING_RAW( CHOICE_POPUP_WIDTH 8, -2, 0, 280, (CHOICE_POPUP_HEIGHT( 7 )-4), CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN visible when( dvarString(ui_inside_popup) != "attachment" && dvarString(ui_inside_popup) != "camo" );, 0, 0 )\
		/* weapon image*/ \
		PREPROC_SHADER_DRAW_ALIGNED( (CHOICE_POPUP_WIDTH+6) 30 256 48 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "gradient_bottom", 1 1 1 0.3, 0, 2, CHOICE_POPUP_BORDER_COLOR visible when( dvarString(ui_inside_popup) != "attachment" && dvarString(ui_inside_popup) != "camo" ); ) \
		PREPROC_SHADER_DRAW_ALIGNED( (CHOICE_POPUP_WIDTH+72) -6 180 90 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, tablelookup("mp/statsTable.csv",4,dvarString(highlight_dvar),6), 1 1 1 1, 0, 2, CHOICE_POPUP_BORDER_COLOR visible when( dvarString(ui_inside_popup) != "attachment" && dvarString(ui_inside_popup) != "camo" ); ) \
		/* weapon title*/\
		PREPROC_TEXT_DRAW_ALIGNED_EXP( (CHOICE_POPUP_WIDTH+10) 58 256 20 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "@"+tablelookup("mp/statstable.csv",4,dvarString(highlight_dvar),3), TEXTSIZE_DEFAULT, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, COLOR_TITLE visible when( dvarString(ui_inside_popup) != "attachment" && dvarString(ui_inside_popup) != "camo" ); ) \
		/* weapon desc unlocked*/\
		PREPROC_TEXT_DRAW_ALIGNED_EXP( (CHOICE_POPUP_WIDTH+10) 80 256 20 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "@"+tablelookup("mp/statstable.csv",4,dvarString(highlight_dvar),7), TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, CHOICE_TEXTCOLOR visible when( dvarBool( ui_primary_hl_unlocked ) ); )\
		PREPROC_TEXT_DRAW_ALIGNED_EXP( (CHOICE_POPUP_WIDTH+10) 80 256 20 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "@MENU_DISABLED", TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, COLOR_TITLE visible when( !dvarBool( ui_primary_hl_unlocked ) ); )\
		PREPROC_SHADER_DRAW_ALIGNED( (CHOICE_POPUP_WIDTH+6) 0 (CHOICE_SIZE_Y*2) CHOICE_SIZE_Y CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "specialty_locked", 1 1 1 1, 0, 2, CHOICE_POPUP_BORDER_COLOR visible when( !dvarBool( ui_primary_hl_unlocked ) ); ) \
		PREPROC_SHADER_DRAW_ALIGNED( 0 -24 (CHOICE_POPUP_WIDTH-4) 22 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "white", 0.15 0.15 0.17 1, 0, 2, CHOICE_POPUP_BORDER_COLOR )\
		PREPROC_TEXT_DRAW_ALIGNED_EXP( 8 -24 (CHOICE_POPUP_WIDTH-4) 22 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, -32 0, dvarString(ui_weapon_class_selected), TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_RIGHT, CHOICE_TEXTCOLOR ) \
		/* pointer icon */ \
		PREPROC_SHADER_DRAW_ALIGNED( 200 -16 16 8 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "hitech_arrow_down", 0.9 0.9 0.95 0.4, 0, 2, CHOICE_POPUP_BORDER_COLOR )

	#define LOCAL_PRIMARY_WEAPON_ACTION( suffix, weapClass, weapRef ) \
		play "mouse_click"; \
		execOnDvarStringValue loadout_primary_attachment gl ""; \
		scriptMenuResponse "loadout_primary:"weapRef;\
		setdvar loadout_primary weapRef; \
		close self;

	#define LOCAL_PRIMARY_WEAPON_ACTION3( suffix, weapClass, weapRef ) \
		play "mouse_click"; \
		execOnDvarStringValue loadout_primary_attachment gl ""; \
		scriptMenuResponse "loadout_primary:"weapRef;\
		setdvar loadout_primary weapRef; \
		setdvar	loadout_primary_attachment none; \
		setdvar loadout_perk1_locked 0; \
		close self;
		
	#define WI_FOCUS_ACTION( weaponRef ) \
		execOnDvarStringValue "weap_allow_"weaponRef 0 "set ui_primary_hl_unlocked 0";\
		execOnDvarStringValue "weap_allow_"weaponRef 1 "set ui_primary_hl_unlocked 1";\
		exec "set ui_primary_highlighted "weaponRef;
	
	// hacked to hide the second primary if same weapon is selected in first primary, change weapon description to "Already selected"
	#define LOCAL_WEAPON_ITEM( suffix, itemNum, weaponName, weaponClass, weaponRef )\
		CHOICE_BUTTON_FOCUS_VIS_NOHI( itemNum, "", ;, WI_FOCUS_ACTION( weaponRef ), ;, when( !dvarBool( "weap_allow_"weaponRef ) ); ) \
		CHOICE_DBUTTON_VIS( itemNum, weaponName, when( 1 ); ) \
		CHOICE_BUTTON_FOCUS_VIS_ADV( itemNum, weaponName, LOCAL_PRIMARY_WEAPON_ACTION( suffix, weaponClass, weaponRef ), \
		WI_FOCUS_ACTION( weaponRef ), ;, when( dvarBool( "weap_allow_"weaponRef ) );, \
		dvarBool( "weap_allow_"weaponRef ) ) \
		
	#define LOCAL_WEAPON_ITEM2( suffix, itemNum, weaponName, weaponClass, weaponRef )\
		CHOICE_BUTTON_FOCUS_VIS_NOHI( itemNum, "", ;, WI_FOCUS_ACTION( weaponRef ), ;, when( !dvarBool( "weap_allow_"weaponRef ) ); ) \
		CHOICE_DBUTTON_VIS( itemNum, weaponName, when( 1 ); ) \
		CHOICE_BUTTON_FOCUS_VIS_ADV( itemNum, weaponName, LOCAL_PRIMARY_WEAPON_ACTION3( suffix, weaponClass, weaponRef ), \
		WI_FOCUS_ACTION( weaponRef ), ;, when( dvarBool( "weap_allow_"weaponRef ) );, \
		dvarBool( "weap_allow_"weaponRef ) ) \

	// primary weapon class dropdown
	menuDef
	{
		IMPROVED_POPUP_SETUP_ONOPEN( "ocd_popup_cac_primary", 5, (CHOICE_X( 1 )-2), (CHOICE_Y( 1 )-4), ;, execnow "set ui_inside_popup weapon_class; set ui_show_preview 1";, 1 )
		onClose{	execnow "set ui_show_preview 0; set ui_primary_highlighted 0; set ui_attachment_highlighted 0";	}
		
		#define LOCAL_WEAPON_CLASS( itemNum, ptext, plabel ) \
			CHOICE_BUTTON_EX( itemNum, plabel, play "mouse_click"; execnow "set selected_weapon_class "ptext"; set ui_weapon_class_selected "plabel; open "ocd_popup_cac_"ptext;, name ptext )

		LOCAL_WEAPON_CLASS( 1, "assault", "@MPUI_ASSAULT_RIFLES" )
		LOCAL_WEAPON_CLASS( 2, "SMG", "@MPUI_SUB_MACHINE_GUNS" )
		LOCAL_WEAPON_CLASS( 3, "LMG", "@MPUI_LIGHT_MACHINE_GUNS" )
		LOCAL_WEAPON_CLASS( 4, "shotgun", "@MPUI_SHOTGUNS" )
		LOCAL_WEAPON_CLASS( 5, "sniper", "@MPUI_SNIPER_RIFLES" )	
	}

	// hackaround to work for PC's floating mouse unfocusing
	#undef  UI_FOCUSFIRST
	#define UI_FOCUSFIRST "ui_primary_highlighted"
		
	// primary weapon items
	#define LOCAL_MASTER_WEAPON_GROUP( suffix, pos, y_offset )\
	menuDef	{\
		IMPROVED_POPUP_SETUP_ONOPEN( "ocd_popup_cac_assault"suffix, 7, (CHOICE_X( pos )-2), (CHOICE_Y( pos )+20+y_offset), ;, execnow "set "UI_FOCUSFIRST" "REF_M16"; set ui_inside_popup assault";, 0 )\
		LOCAL_WEAPON_INFO_WINDOW( "ui_primary_highlighted" )\
		LOCAL_WEAPON_ITEM( suffix, 1, "@WEAPON_M16", "assault", REF_M16 )\
		LOCAL_WEAPON_ITEM( suffix, 2, "@WEAPON_AK47", "assault", REF_AK47 )\
		LOCAL_WEAPON_ITEM( suffix, 3, "@WEAPON_M4_CARBINE", "assault", REF_M4 )\
		LOCAL_WEAPON_ITEM( suffix, 4, "@WEAPON_G3", "assault", REF_G3 )\
		LOCAL_WEAPON_ITEM( suffix, 5, "@WEAPON_G36C", "assault", REF_G36C )\
		LOCAL_WEAPON_ITEM( suffix, 6, "@WEAPON_M14", "assault", REF_M14 )\
		LOCAL_WEAPON_ITEM2( suffix, 7, "@WEAPON_MP44", "assault", REF_MP44 )\
	}\
	menuDef	{\
		IMPROVED_POPUP_SETUP_ONOPEN( "ocd_popup_cac_LMG"suffix, 7, (CHOICE_X( pos )-2), (CHOICE_Y( pos )+20+y_offset), ;, execnow "set "UI_FOCUSFIRST" "REF_M249SAW"; set ui_inside_popup lmg";, 0 )\
		LOCAL_WEAPON_INFO_WINDOW( "ui_primary_highlighted" )\
		LOCAL_WEAPON_ITEM( suffix, 1, "@WEAPON_SAW", "LMG", REF_M249SAW )\
		LOCAL_WEAPON_ITEM( suffix, 2, "@WEAPON_RPD", "LMG", REF_RPD )\
		LOCAL_WEAPON_ITEM( suffix, 3, "@WEAPON_M60E4", "LMG", REF_M60E4 )\
	}\
	menuDef	{\
		IMPROVED_POPUP_SETUP_ONOPEN( "ocd_popup_cac_SMG"suffix, 7, (CHOICE_X( pos )-2), (CHOICE_Y( pos )+20+y_offset), ;, execnow "set "UI_FOCUSFIRST" "REF_MP5";set ui_inside_popup smg";, 0 )\
		LOCAL_WEAPON_INFO_WINDOW( "ui_primary_highlighted" )\
		LOCAL_WEAPON_ITEM( suffix, 1, "@WEAPON_MP5", "SMG", REF_MP5 )\
		LOCAL_WEAPON_ITEM( suffix, 2, "@WEAPON_SKORPION", "SMG", REF_SKORPION )\
		LOCAL_WEAPON_ITEM( suffix, 3, "@WEAPON_UZI", "SMG", REF_UZI )\
		LOCAL_WEAPON_ITEM( suffix, 4, "@WEAPON_AK74U", "SMG", REF_AK74U )\
		LOCAL_WEAPON_ITEM( suffix, 5, "@WEAPON_P90", "SMG", REF_P90 )\
	}\
	menuDef	{\
		IMPROVED_POPUP_SETUP_ONOPEN( "ocd_popup_cac_shotgun"suffix, 7, (CHOICE_X( pos )-2), (CHOICE_Y( pos )+20+y_offset), ;, execnow "set "UI_FOCUSFIRST" "REF_WINCHESTER1200"; set ui_inside_popup shotgun";, 0 )\
		LOCAL_WEAPON_INFO_WINDOW( "ui_primary_highlighted" )\
		LOCAL_WEAPON_ITEM( suffix, 1, "@WEAPON_WINCHESTER1200", "shotgun", REF_WINCHESTER1200 )\
		LOCAL_WEAPON_ITEM( suffix, 2, "@WEAPON_BENELLI", "shotgun", REF_BENELLIM4 )\
	}\
	menuDef	{\
		IMPROVED_POPUP_SETUP_ONOPEN( "ocd_popup_cac_sniper"suffix, 7, (CHOICE_X( pos )-2), (CHOICE_Y( pos )+20+y_offset), ;, execnow "set "UI_FOCUSFIRST" "REF_M40A3"; set ui_inside_popup sniper";, 0 )\
		LOCAL_WEAPON_INFO_WINDOW( "ui_primary_highlighted" )\
		LOCAL_WEAPON_ITEM( suffix, 1, "@WEAPON_M40A3", "sniper", REF_M40A3 )\
		LOCAL_WEAPON_ITEM( suffix, 2, "@WEAPON_M21", "sniper", REF_M21 )\
		LOCAL_WEAPON_ITEM( suffix, 3, "@WEAPON_DRAGUNOV", "sniper", REF_DRAGUNOVSVD )\
		LOCAL_WEAPON_ITEM( suffix, 4, "@WEAPON_REMINGTON700", "sniper", REF_REMINGTON700 )\
		LOCAL_WEAPON_ITEM( suffix, 5, "@WEAPON_BARRETT", "sniper", REF_BARRETT )\
	}
	

	// primary and second primary weapon selection popup menus
	LOCAL_MASTER_WEAPON_GROUP( "", 1, 0 )
	
	// ====================================================================================================
	// primary and second primary attachment selection ====================================================
	// ====================================================================================================
	#define LOCAL_ATTACHMENT_INFO_WINDOW( parentDvar ) \
		/* attachment information side frame*/ \
		PREPROC_SHADER_DRAW_ALIGNED( (CHOICE_POPUP_WIDTH-6) -4 280 CHOICE_POPUP_HEIGHT( 7 ) CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "white", CHOICE_POPUP_BORDER_COLOR, 1, 2, CHOICE_POPUP_BORDER_COLOR visible when( dvarString(ui_inside_popup) != "camo" ); ) \
		LOADOUT_PLATING_RAW( CHOICE_POPUP_WIDTH 8, -2, 0, 280, (CHOICE_POPUP_HEIGHT( 7 )-4), CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN visible when( dvarString(ui_inside_popup) != "camo" );, 0, 0 ) \
		/* attachment image*/ \
		PREPROC_SHADER_DRAW_ALIGNED( (CHOICE_POPUP_WIDTH+6) 30 256 48 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "gradient_bottom", 1 1 1 0.3, 0, 2, CHOICE_POPUP_BORDER_COLOR visible when( dvarString(ui_inside_popup) != "camo" ); ) \
		PREPROC_SHADER_DRAW_ALIGNED( (CHOICE_POPUP_WIDTH+182) 6 64 64 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, tablelookup("mp/attachmentTable.csv",4,dvarString(ui_attachment_highlighted),6), 1 1 1 1, 0, 2, CHOICE_POPUP_BORDER_COLOR visible when( dvarString(ui_inside_popup) != "camo" ); ) \
		/* attachment title*/\
		PREPROC_TEXT_DRAW_ALIGNED_EXP( (CHOICE_POPUP_WIDTH+10) 58 256 20 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "@"+tablelookup("mp/attachmentTable.csv",4,dvarString(ui_attachment_highlighted),3), TEXTSIZE_DEFAULT, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, COLOR_TITLE visible when( dvarString(ui_inside_popup) != "camo" ); ) \
		/* attachment desc unlocked*/\
		PREPROC_TEXT_DRAW_ALIGNED_EXP( (CHOICE_POPUP_WIDTH+10) 80 256 20 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "@"+tablelookup("mp/attachmentTable.csv",4,dvarString(ui_attachment_highlighted),7), TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, CHOICE_TEXTCOLOR visible when( dvarBool( ui_attachment_hl_unlocked ) ); )\
		PREPROC_TEXT_DRAW_ALIGNED_EXP( (CHOICE_POPUP_WIDTH+10) 80 256 20 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "@MENU_DISABLED", TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, COLOR_TITLE visible when( !dvarBool( ui_attachment_hl_unlocked ) ); )\
		PREPROC_SHADER_DRAW_ALIGNED( (CHOICE_POPUP_WIDTH+6) 0 (CHOICE_SIZE_Y*2) CHOICE_SIZE_Y CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "specialty_locked", 1 1 1 1, 0, 2, CHOICE_POPUP_BORDER_COLOR visible when( !dvarBool( ui_attachment_hl_unlocked ) && dvarString(ui_inside_popup) != "camo" ); ) \
		PREPROC_SHADER_DRAW_ALIGNED( 0 -24 (CHOICE_POPUP_WIDTH-4) 22 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "white", 0.15 0.15 0.17 1, 0, 2, CHOICE_POPUP_BORDER_COLOR )\
		PREPROC_TEXT_DRAW_ALIGNED_EXP( 8 -24 (CHOICE_POPUP_WIDTH-4) 22 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, -32 0, "@"+tablelookup("mp/statstable.csv",4,dvarString(parentDvar),3), TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_RIGHT, CHOICE_TEXTCOLOR )\
		/* pointer icon */ \
		PREPROC_SHADER_DRAW_ALIGNED( 200 -16 16 8 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "hitech_arrow_right", 0.55 0.95 0.55 0.7, 0, 2, CHOICE_POPUP_BORDER_COLOR )

	#define LOCAL_ATTACHMENT_ACTION( attachmentDvar, attachmentName, paction, groupArg ) \
		setdvar loadout_primary_attachment attachmentName; \
		scriptMenuResponse "loadout_primary_attachment:"groupArg":"attachmentName;\
		UPDATE_PERK1 \
		close self;
		/*
		setdvar loadout_camo camo_none; \
		open "ocd_popup_cac_camo";
		*/
		
	#define LOCAL_ATTACHMENT_ACTION2( attachmentDvar, attachmentName, paction, groupArg ) \
		setdvar loadout_secondary_attachment attachmentName; \
		scriptMenuResponse "loadout_secondary_attachment:"groupArg":"attachmentName;\
		UPDATE_PERK1 \
		PREPROC_ATTACH_CLOSEALL

	#define AI_FOCUS_ACTION( groupArg, weaponRef ) \
		execOnDvarStringValue "attach_allow_"groupArg"_"weaponRef 0 "set ui_attachment_hl_unlocked 0";\
		execOnDvarStringValue "attach_allow_"groupArg"_"weaponRef 1 "set ui_attachment_hl_unlocked 1";\
		exec "set ui_attachment_highlighted "weaponRef;

	#define LOCAL_ATTACHMENT_ITEM( itemNum, p_setstat, groupArg ,p_numref, pname, paction, ptype, statDvar, bitMask )\
		CHOICE_BUTTON_FOCUS_VIS_ADV( itemNum, "@"+tablelookup("mp/attachmentTable.csv",4,pname,3), LOCAL_ATTACHMENT_ACTION( statDvar, pname, paction, groupArg );, AI_FOCUS_ACTION(groupArg,pname), ;, when( ptype == "primary" && dvarBool( "attach_allow_"groupArg"_"pname ) ), ptype == "primary" && dvarBool( "attach_allow_"groupArg"_"pname ) ) \
		CHOICE_BUTTON_FOCUS_VIS_ADV( itemNum, "@"+tablelookup("mp/attachmentTable.csv",4,pname,3), LOCAL_ATTACHMENT_ACTION2( statDvar, pname, paction, groupArg );, AI_FOCUS_ACTION(groupArg,pname), ;, when( ptype == "secondary" && dvarBool( "attach_allow_"groupArg"_"pname ) ), ptype == "primary" && dvarBool( "attach_allow_"groupArg"_"pname ) ) \
		CHOICE_BUTTON_FOCUS_VIS_NOHI( itemNum, "", ;, AI_FOCUS_ACTION(groupArg,pname), ;, when( !dvarBool( "attach_allow_"groupArg"_"pname ) ); ) \
		CHOICE_DBUTTON_VIS( itemNum, "@"+tablelookup("mp/attachmentTable.csv",4,pname,3), when( !dvarBool( "attach_allow_"groupArg"_"pname ) ); )
	// hackaround to work for PC's floating mouse unfocusing
	#undef  UI_FOCUSFIRST
	#define UI_FOCUSFIRST "ui_attachment_highlighted"
		
	// primary and second primary attachment items
	#define LOCAL_MASTER_ATTACHMENT_GROUP( stat_slot, suffix, pos, ptype, y_offset, statDvar )\
	menuDef { /* assault attachments*/ \
		IMPROVED_POPUP_SETUP_ONOPEN( "ocd_attachment_popup_assault"suffix, 7, (CHOICE_X( pos )-2), (CHOICE_Y( pos )+44+y_offset), ;, execnow "set "UI_FOCUSFIRST" "REF_ATTACHMENT_NONE"; set ui_inside_popup attachment";, 0 )\
		onClose{execnow "set ui_inside_popup 0";} \
		LOCAL_ATTACHMENT_INFO_WINDOW( "loadout_"ptype )\
		LOCAL_ATTACHMENT_ITEM( 1, stat_slot, "assault", NUM_NONE, "none", ;, ptype, statDvar, 0 )\
		LOCAL_ATTACHMENT_ITEM( 2, stat_slot, "assault", NUM_GL, "gl", play "mouse_click"; ;, ptype, statDvar, GL_NEW_BITMASK )\
		LOCAL_ATTACHMENT_ITEM( 3, stat_slot, "assault", NUM_SUPPRESSOR, "silencer", ;, ptype, statDvar, SILENCER_NEW_BITMASK )\
		LOCAL_ATTACHMENT_ITEM( 4, stat_slot, "assault", NUM_REFLEX, "reflex", ;, ptype, statDvar, REDDOT_NEW_BITMASK )\
		LOCAL_ATTACHMENT_ITEM( 5, stat_slot, "assault", NUM_ACOG, "acog", ;, ptype, statDvar, ACOG_NEW_BITMASK )\
	}\
	menuDef { /* LMG attachments*/\
		IMPROVED_POPUP_SETUP_ONOPEN( "ocd_attachment_popup_LMG"suffix, 7, (CHOICE_X( pos )-2), (CHOICE_Y( pos )+44+y_offset), ;, execnow "set "UI_FOCUSFIRST" "REF_ATTACHMENT_NONE"; set ui_inside_popup attachment";, 0 )\
		onClose{execnow "set ui_inside_popup 0";} \
		LOCAL_ATTACHMENT_INFO_WINDOW( "loadout_"ptype )\
		LOCAL_ATTACHMENT_ITEM( 1, stat_slot, "lmg", NUM_NONE, "none", ;, ptype, statDvar, 0 )\
		LOCAL_ATTACHMENT_ITEM( 2, stat_slot, "lmg", NUM_REFLEX, "reflex", ;, ptype, statDvar, REDDOT_NEW_BITMASK )\
		LOCAL_ATTACHMENT_ITEM( 3, stat_slot, "lmg", NUM_GRIP, "grip", ;, ptype, statDvar, GRIP_NEW_BITMASK )\
		LOCAL_ATTACHMENT_ITEM( 4, stat_slot, "lmg", NUM_ACOG, "acog", ;, ptype, statDvar, ACOG_NEW_BITMASK )\
	}\
	menuDef	{ /* SMG attachments*/\
		IMPROVED_POPUP_SETUP_ONOPEN( "ocd_attachment_popup_SMG"suffix, 7, (CHOICE_X( pos )-2), (CHOICE_Y( pos )+44+y_offset), ;, execnow "set "UI_FOCUSFIRST" "REF_ATTACHMENT_NONE"; set ui_inside_popup attachment";, 0 )\
		onClose{execnow "set ui_inside_popup 0";} \
		LOCAL_ATTACHMENT_INFO_WINDOW( "loadout_"ptype )\
		LOCAL_ATTACHMENT_ITEM( 1, stat_slot, "smg", NUM_NONE, "none", ;, ptype, statDvar, 0 )\
		LOCAL_ATTACHMENT_ITEM( 2, stat_slot, "smg", NUM_SUPPRESSOR, "silencer", ;, ptype, statDvar, SILENCER_NEW_BITMASK )\
		LOCAL_ATTACHMENT_ITEM( 3, stat_slot, "smg", NUM_REFLEX, "reflex", ;, ptype, statDvar, REDDOT_NEW_BITMASK )\
		LOCAL_ATTACHMENT_ITEM( 4, stat_slot, "smg", NUM_ACOG, "acog", ;, ptype, statDvar, ACOG_NEW_BITMASK )\
	}\
	menuDef { /* shotgun attachments*/\
		IMPROVED_POPUP_SETUP_ONOPEN( "ocd_attachment_popup_shotgun"suffix, 7, (CHOICE_X( pos )-2), (CHOICE_Y( pos )+44+y_offset), ;, execnow "set "UI_FOCUSFIRST" "REF_ATTACHMENT_NONE"; set ui_inside_popup attachment";, 0 )\
		onClose{execnow "set ui_inside_popup 0";} \
		LOCAL_ATTACHMENT_INFO_WINDOW( "loadout_"ptype )\
		LOCAL_ATTACHMENT_ITEM( 1, stat_slot, "shotgun", NUM_NONE, "none", ;, ptype, statDvar, 0 )\
		LOCAL_ATTACHMENT_ITEM( 2, stat_slot, "shotgun", NUM_REFLEX, "reflex", ;, ptype, statDvar, REDDOT_NEW_BITMASK )\
		LOCAL_ATTACHMENT_ITEM( 3, stat_slot, "shotgun", NUM_GRIP, "grip", ;, ptype, statDvar, GRIP_NEW_BITMASK )\
	}\
	menuDef	{ /* sniper attachments*/\
		IMPROVED_POPUP_SETUP_ONOPEN( "ocd_attachment_popup_sniper"suffix, 7, (CHOICE_X( pos )-2), (CHOICE_Y( pos )+44+y_offset), ;, execnow "set "UI_FOCUSFIRST" "REF_ATTACHMENT_NONE"; set ui_inside_popup attachment";, 0 )\
		onClose{execnow "set ui_inside_popup 0";} \		
		LOCAL_ATTACHMENT_INFO_WINDOW( "loadout_"ptype )\
		LOCAL_ATTACHMENT_ITEM( 1, stat_slot, "sniper", NUM_NONE, "none", ;, ptype, statDvar, 0 )\
		LOCAL_ATTACHMENT_ITEM( 2, stat_slot, "sniper", NUM_ACOG, "acog", ;, ptype, statDvar, ACOG_NEW_BITMASK )\
	}

	menuDef	{ /* fake attachment heading for weapons without attachments to be displayed on top of camo popup */
		IMPROVED_POPUP_SETUP_ONOPEN( "ocd_attachment_popup_fake", 7, (CHOICE_X( 1 )-2), (CHOICE_Y( 1 ) + 44), ;, ;, 0 )
		LOCAL_ATTACHMENT_INFO_WINDOW( "loadout_primary" )
		PREPROC_SHADER_DRAW_ALIGNED( 0 -24 (CHOICE_POPUP_WIDTH-4) 22 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "white", 0.15 0.15 0.17 1, 0, 2, CHOICE_POPUP_BORDER_COLOR )
		PREPROC_TEXT_DRAW_ALIGNED_EXP( 8 -24 (CHOICE_POPUP_WIDTH-4) 22 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, -32 0, "@"+tablelookup("mp/statstable.csv",4,dvarString(loadout_primary),3), TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_RIGHT, CHOICE_TEXTCOLOR )
		/* pointer icon */
		PREPROC_SHADER_DRAW_ALIGNED( 200 -16 16 8 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "hitech_arrow_right", 0.55 0.95 0.55 0.7, 0, 2, CHOICE_POPUP_BORDER_COLOR )
	}

	// side arm attachment selection ======================================================================
	menuDef	{ /* pistol attachments*/
		IMPROVED_POPUP_SETUP_ONOPEN( "ocd_attachment_popup_pistol", 7, (CHOICE_X( 2 )-2), (CHOICE_Y( 2 )+24), ;, execnow "set "UI_FOCUSFIRST" "REF_ATTACHMENT_NONE"; set ui_inside_popup attachment";, 0 )
		onClose{execnow "set ui_inside_popup 0";}
		LOCAL_ATTACHMENT_INFO_WINDOW( "loadout_secondary" )
		LOCAL_ATTACHMENT_ITEM( 1, CAC_SECONDARY_ATTACHMENT, "pistol", NUM_NONE, "none", ;, "secondary", "ui_secondary_weapon", 0 )
		LOCAL_ATTACHMENT_ITEM( 2, CAC_SECONDARY_ATTACHMENT, "pistol", NUM_SUPPRESSOR, "silencer", ;, "secondary", "ui_secondary_weapon", SILENCER_NEW_BITMASK )
	}
	
	// primary and second primary attachment popup menus
	LOCAL_MASTER_ATTACHMENT_GROUP( CAC_PRIMARY_ATTACHMENT, "", 1, "primary", 0, "loadout_primary_attachment" )

	// ====================================================================================================
	// side arm selection ===============================================================================
	// ====================================================================================================
	#define LOCAL_SIDEARM_INFO_WINDOW( highlight_dvar ) \
		/* sidearm information side frame*/ \
		PREPROC_SHADER_DRAW_ALIGNED( (CHOICE_POPUP_WIDTH-6) -4 280 CHOICE_POPUP_HEIGHT( 7 ) CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "white", CHOICE_POPUP_BORDER_COLOR, 1, 2, CHOICE_POPUP_BORDER_COLOR visible when( dvarString(ui_inside_popup) != "attachment" ); ) \
		LOADOUT_PLATING_RAW( CHOICE_POPUP_WIDTH 8, -2, 0, 280, (CHOICE_POPUP_HEIGHT( 7 )-4), CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN visible when( dvarString(ui_inside_popup) != "attachment" );, 0, 0 )\
		/* sidearm image*/ \
		PREPROC_SHADER_DRAW_ALIGNED( (CHOICE_POPUP_WIDTH+6) 30 256 48 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "gradient_bottom", 1 1 1 0.3, 0, 2, CHOICE_POPUP_BORDER_COLOR visible when( dvarString(ui_inside_popup) != "attachment" ); ) \
		PREPROC_SHADER_DRAW_ALIGNED( (CHOICE_POPUP_WIDTH+138) -12 90 90 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, tablelookup("mp/statsTable.csv",4,dvarString(highlight_dvar),6), 1 1 1 1, 0, 2, CHOICE_POPUP_BORDER_COLOR visible when( dvarString(ui_inside_popup) != "attachment" ); ) \
		/* sidearm title*/\
		PREPROC_TEXT_DRAW_ALIGNED_EXP( (CHOICE_POPUP_WIDTH+10) 58 256 20 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "@"+tablelookup("mp/statstable.csv",4,dvarString(highlight_dvar),3), TEXTSIZE_DEFAULT, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, COLOR_TITLE visible when( dvarString(ui_inside_popup) != "attachment" ); ) \
		/* sidearm desc unlocked*/\
		PREPROC_TEXT_DRAW_ALIGNED_EXP( (CHOICE_POPUP_WIDTH+10) 80 256 20 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "@"+tablelookup("mp/statstable.csv",4,dvarString(highlight_dvar),7), TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, CHOICE_TEXTCOLOR visible when( dvarBool( ui_sidearm_hl_unlocked ) ); )\
		PREPROC_TEXT_DRAW_ALIGNED_EXP( (CHOICE_POPUP_WIDTH+10) 80 256 20 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "@MENU_DISABLED", TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, COLOR_TITLE visible when( !dvarBool( ui_sidearm_hl_unlocked ) ); )\
		PREPROC_SHADER_DRAW_ALIGNED( (CHOICE_POPUP_WIDTH+6) 0 (CHOICE_SIZE_Y*2) CHOICE_SIZE_Y CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "specialty_locked", 1 1 1 1, 0, 2, CHOICE_POPUP_BORDER_COLOR visible when( !dvarBool( ui_sidearm_hl_unlocked ) ); ) \

	#define LOCAL_SIDEARM_ACTION( pstat, weaponRef ) \
			play "mouse_click"; \
			setdvar	loadout_secondary weaponRef; \
			setdvar	loadout_secondary_attachment none; \
			scriptMenuResponse "loadout_secondary:"weaponRef;\
			PREPROC_ATTACH_CLOSEALL

	#define LOCAL_SIDEARM_ACTION2( pstat, weaponRef ) \		
			play "mouse_click"; \
			setdvar	loadout_secondary weaponRef; \
			setdvar	loadout_secondary_attachment none; \
			scriptMenuResponse "loadout_secondary:"weaponRef;\
			uiScript openMenuOnDvar "selected_weapon_class" pistol "ocd_attachment_popup_pistol";
	
	#define SI_FOCUS_ACTION( weaponRef ) \
		execOnDvarStringValue "weap_allow_"weaponRef 0 "set ui_sidearm_hl_unlocked 0";\
		execOnDvarStringValue "weap_allow_"weaponRef 1 "set ui_sidearm_hl_unlocked 1";\
		exec "set ui_sidearm_highlighted "weaponRef;


	#define LOCAL_SIDEARM_ITEM( itemNum, weaponName, weaponStat, weaponRef, highlight_dvar )\
		CHOICE_BUTTON_FOCUS_VIS_ADV( itemNum, weaponName, LOCAL_SIDEARM_ACTION( weaponStat, weaponRef ), SI_FOCUS_ACTION( weaponRef ), ;, \
		when( dvarBool( "weap_allow_"weaponRef ) && ( weaponRef == REF_DESERTEAGLE || weaponRef == REF_DESERTEAGLEGOLD ) );, \
			  dvarBool( "weap_allow_"weaponRef ) && ( weaponRef == REF_DESERTEAGLE || weaponRef == REF_DESERTEAGLEGOLD ) ) \
		CHOICE_BUTTON_FOCUS_VIS_ADV( itemNum, weaponName, LOCAL_SIDEARM_ACTION2( weaponStat, weaponRef ), SI_FOCUS_ACTION( weaponRef ), ;, \
		when( dvarBool( "weap_allow_"weaponRef ) && weaponRef != REF_DESERTEAGLE && weaponRef != REF_DESERTEAGLEGOLD );, \
			  dvarBool( "weap_allow_"weaponRef ) && weaponRef != REF_DESERTEAGLE && weaponRef != REF_DESERTEAGLEGOLD ) \
		CHOICE_BUTTON_FOCUS_VIS_NOHI( itemNum, "", ;, SI_FOCUS_ACTION( weaponRef ), ;, when( !dvarBool( "weap_allow_"weaponRef ) ); ) \
		CHOICE_DBUTTON_VIS( itemNum, weaponName, when( !dvarBool( "weap_allow_"weaponRef ) ); )
	// side arm selection popup menu
	
	// hackaround to work for PC's floating mouse unfocusing
	#undef  UI_FOCUSFIRST
	#ifdef PC
		#define UI_FOCUSFIRST "ui_sidearm_highlighted"
	#else
		#define UI_FOCUSFIRST "ui_fake_focus"
	#endif
	
	menuDef	
	{
		IMPROVED_POPUP_SETUP_ONOPEN( "ocd_popup_cac_secondary", 7, (CHOICE_X( 2 )-2), (CHOICE_Y( 2 )), ;, execnow "set "UI_FOCUSFIRST" "REF_M9BERETTA"; set selected_weapon_class pistol; set ui_inside_popup pistol";, 1 )
		onClose{execnow "set ui_inside_popup 0";}
		LOCAL_SIDEARM_INFO_WINDOW( "ui_sidearm_highlighted" )
		LOCAL_SIDEARM_ITEM( 1, "@WEAPON_BERETTA", STAT_PISTOL_M9BERETTA, REF_M9BERETTA, "ui_sidearm_highlighted" )
		LOCAL_SIDEARM_ITEM( 2, "@WEAPON_USP", STAT_PISTOL_USP, REF_USP, "ui_sidearm_highlighted" )
		LOCAL_SIDEARM_ITEM( 3, "@WEAPON_COLT1911", STAT_PISTOL_COLT45, REF_COLT45, "ui_sidearm_highlighted" )
		LOCAL_SIDEARM_ITEM( 4, "@WEAPON_DESERTEAGLE", STAT_PISTOL_DESERTEAGLE, REF_DESERTEAGLE, "ui_sidearm_highlighted" )
		LOCAL_SIDEARM_ITEM( 5, "@WEAPON_DESERTEAGLEGOLD", STAT_PISTOL_DESERTEAGLEGOLD, REF_DESERTEAGLEGOLD, "ui_sidearm_highlighted" )
	}

	// ====================================================================================================
	// camo skin selection ================================================================================
	// ====================================================================================================
	#define LOCAL_CAMO_INFO_WINDOW( highlight_dvar ) \
		/* camo information side frame*/ \
		PREPROC_SHADER_DRAW_ALIGNED( (CHOICE_POPUP_WIDTH-6) -4 280 CHOICE_POPUP_HEIGHT( 8 ) CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "white", CHOICE_POPUP_BORDER_COLOR, 1, 2, CHOICE_POPUP_BORDER_COLOR ) \
		LOADOUT_PLATING_RAW( CHOICE_POPUP_WIDTH 8, -2, 0, 280, (CHOICE_POPUP_HEIGHT( 8 )-4), CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0, 0 )\
		/* camo image*/ \
		PREPROC_SHADER_DRAW_ALIGNED( (CHOICE_POPUP_WIDTH+6) 30 256 48 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "gradient_bottom", 1 1 1 0.3, 0, 2, CHOICE_POPUP_BORDER_COLOR ) \
		PREPROC_SHADER_DRAW_ALIGNED( (CHOICE_POPUP_WIDTH+184) 0 64 64 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, tablelookup("mp/attachmentTable.csv",4,dvarString(highlight_dvar),6), 1 1 1 0.75, 1, 7, 0.2 0.2 0.225 1 ) \
		/* camo title*/\
		PREPROC_TEXT_DRAW_ALIGNED_EXP( (CHOICE_POPUP_WIDTH+10) 58 256 20 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "@"+tablelookup("mp/attachmenttable.csv",4,dvarString(highlight_dvar),3), TEXTSIZE_DEFAULT, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, COLOR_TITLE ) \
		/* camo desc unlocked*/\
		PREPROC_TEXT_DRAW_ALIGNED_EXP( (CHOICE_POPUP_WIDTH+10) 80 256 20 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "@"+tablelookup("mp/attachmenttable.csv",4,dvarString(highlight_dvar),7), TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, CHOICE_TEXTCOLOR visible when( 1 ); )\
		PREPROC_SHADER_DRAW_ALIGNED( 0 -24 (CHOICE_POPUP_WIDTH-4) 22 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "white", 0.15 0.15 0.17 1, 0, 2, CHOICE_POPUP_BORDER_COLOR )\
		PREPROC_TEXT_DRAW_ALIGNED_EXP( 8 -24 (CHOICE_POPUP_WIDTH-4) 22 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, -32 0, "@"+tablelookup("mp/attachmenttable.csv",4,dvarString(loadout_primary_attachment),3), TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_RIGHT, CHOICE_TEXTCOLOR )\
		/* pointer icon */ \
		PREPROC_SHADER_DRAW_ALIGNED( 200 -16 16 8 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "hitech_arrow_right", 0.55 0.95 0.55 0.7, 0, 2, CHOICE_POPUP_BORDER_COLOR )

	#define LOCAL_CAMO_ACTION( camoRef ) \
			play "mouse_click"; \
			setdvar loadout_camo camoRef;\
			scriptMenuResponse "loadout_camo:"camoRef;\
			PREPROC_ATTACH_CLOSEALL

	#define LOCAL_CAMO_ITEM( itemNum, camoName, pnum, camoRef, highlight_dvar, bitMask, visArg )\
		CHOICE_BUTTON_FOCUS( itemNum, camoName, LOCAL_CAMO_ACTION( camoRef );, execnow "set "highlight_dvar" "camoRef;, ; );

	// hackaround to work for PC's floating mouse unfocusing
	#undef  UI_FOCUSFIRST
	#define UI_FOCUSFIRST "ui_camo_highlighted"
	
	// camo skin selection for primary weapon popup menu
	#define LOCAL_CAMO_GROUP( prefix, onLeave )\
	menuDef	\
	{\
		IMPROVED_POPUP_SETUP_ONOPEN( "ocd_popup_cac_camo"prefix, 8, (CHOICE_X( 1 )-2), (CHOICE_Y( 1 )+68), ;, execnow "set "UI_FOCUSFIRST" "REF_CAMO_NONE"; set ui_inside_popup camo";, 0 )\
		onClose{onLeave;} \
		LOCAL_CAMO_INFO_WINDOW( "ui_camo_highlighted" )\
		LOCAL_CAMO_ITEM( 1, "@MPUI_NONE", CAMO_NONE, REF_CAMO_NONE, "ui_camo_highlighted", 0, 1 )\
		LOCAL_CAMO_ITEM( 2, "@MPUI_DESERT", CAMO_BROCKHUARD, REF_BROCKHUARD, "ui_camo_highlighted", DESERT_NEW_BITMASK, 1 )\
		LOCAL_CAMO_ITEM( 3, "@MPUI_WOODLAND", CAMO_BUSHDWELLER, REF_BUSHDWELLER, "ui_camo_highlighted", WOODLAND_NEW_BITMASK, 1 )\
		LOCAL_CAMO_ITEM( 4, "@MPUI_DIGITAL", CAMO_BLACKWHITEMARPAT, REF_BLACKWHITEMARPAT, "ui_camo_highlighted", DIGITAL_NEW_BITMASK, 1 )\
		LOCAL_CAMO_ITEM( 5, "@MPUI_RED_TIGER", CAMO_TIGERRED, REF_TIGERRED, "ui_camo_highlighted", REDTIGER_NEW_BITMASK, 1 )\
		LOCAL_CAMO_ITEM( 6, "@MPUI_BLUE_TIGER", CAMO_STAGGER, REF_STAGGER, "ui_camo_highlighted", BLUETIGER_NEW_BITMASK, 1 )\
	}
	// camo skin selection for primary weapon popup menu
	LOCAL_CAMO_GROUP( "", execnow "set ui_inside_popup attachment" )
	// camo skin selection for primary weapon without attachments
	LOCAL_CAMO_GROUP( "2", execnow "set ui_inside_popup 0"; close "ocd_attachment_popup_fake" )
	
	
	// ====================================================================================================
	// special grenade selection ==========================================================================
	// ====================================================================================================
	#define LOCAL_SGRENADE_INFO_WINDOW( highlight_dvar ) \
		/* special grenade information side frame*/ \
		PREPROC_SHADER_DRAW_ALIGNED( (CHOICE_POPUP_WIDTH-6) -4 280 CHOICE_POPUP_HEIGHT(6) CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "white", CHOICE_POPUP_BORDER_COLOR, 1, 2, CHOICE_POPUP_BORDER_COLOR ) \
		LOADOUT_PLATING_RAW( CHOICE_POPUP_WIDTH 8, -2, 0, 280, (CHOICE_POPUP_HEIGHT(6)-4), CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN visible when( dvarString(ui_inside_popup) != "attachment" );, 0, 0 )\
		/*PREPROC_SHADER_DRAW_ALIGNED( (CHOICE_POPUP_WIDTH-6) (CHOICE_POPUP_HEIGHT(3)-4) 2 (CHOICE_POPUP_HEIGHT(6)-CHOICE_POPUP_HEIGHT(3)+2) CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "white", CHOICE_POPUP_BORDER_COLOR, 0, 2, CHOICE_POPUP_BORDER_COLOR )*/ \
		/* special grenade image*/ \
		PREPROC_SHADER_DRAW_ALIGNED( (CHOICE_POPUP_WIDTH+6) 6 256 48 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "gradient_bottom", 1 1 1 0.3, 0, 2, CHOICE_POPUP_BORDER_COLOR visible when( dvarString(ui_inside_popup) != "attachment" ); ) \
		PREPROC_SHADER_DRAW_ALIGNED( (CHOICE_POPUP_WIDTH+178) -6 64 64 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, tablelookup("mp/statsTable.csv",4,dvarString(highlight_dvar),6), 1 1 1 1, 0, 2, CHOICE_POPUP_BORDER_COLOR ) \
		/* special grenade title*/\
		PREPROC_TEXT_DRAW_ALIGNED_EXP( (CHOICE_POPUP_WIDTH+10) 34 256 20 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "@"+tablelookup("mp/statstable.csv",4,dvarString(highlight_dvar),3), TEXTSIZE_DEFAULT, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, COLOR_TITLE ) \
		/* special grenade desc unlocked*/\
		PREPROC_TEXT_DRAW_ALIGNED_EXP( (CHOICE_POPUP_WIDTH+10) 56 256 20 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "@"+tablelookup("mp/statstable.csv",4,dvarString(highlight_dvar),7), TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, CHOICE_TEXTCOLOR \
		visible when( ( ( dvarString(ui_sgrenade_highlighted)=="smoke_grenade") && (dvarString( loadout_perk1 )=="specialty_specialgrenade") ) == 0 ); )\
		PREPROC_TEXT_DRAW_ALIGNED_EXP( (CHOICE_POPUP_WIDTH+10) 56 256 20 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "@MENU_DISABLED", TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, COLOR_TITLE \
		visible when( (dvarString(ui_sgrenade_highlighted)=="smoke_grenade") && (dvarString( loadout_perk1 )=="specialty_specialgrenade") ); )

	#define LOCAL_SGRENADE_ACTION( weaponRef ) \
			play "mouse_click"; \
			setdvar loadout_grenade weaponRef; \
			scriptMenuResponse "loadout_grenade:"weaponRef;\
			close "ocd_popup_cac_extra"
		
	#define LOCAL_SGRENADE_ITEM( itemNum, weaponName, weaponStat, weaponRef, highlight_dvar )\
		CHOICE_BUTTON_FOCUS_VIS_ADV( itemNum, weaponName, LOCAL_SGRENADE_ACTION( weaponRef ), execnow "set "highlight_dvar" "weaponRef, ;, \
		when( ( weaponRef == REF_SMOKE_X1 && (dvarString(loadout_perk1)=="specialty_specialgrenade") ) == 0 && dvarBool("weap_allow_"weaponRef) );, \
			  ( weaponRef == REF_SMOKE_X1 && (dvarString(loadout_perk1)=="specialty_specialgrenade") ) == 0 && dvarBool("weap_allow_"weaponRef) ) \
		CHOICE_BUTTON_FOCUS_VIS_NOHI( itemNum, "", ;, execnow "set "highlight_dvar" "weaponRef, ;, when( weaponRef == REF_SMOKE_X1 && (dvarString(loadout_perk1)=="specialty_specialgrenade") && dvarBool("weap_allow_"weaponRef)); ) \
		CHOICE_DBUTTON_VIS( itemNum, weaponName, when( (weaponRef == REF_SMOKE_X1 && (dvarString(loadout_perk1)=="specialty_specialgrenade")) || !dvarBool("weap_allow_"weaponRef) ); )
	
	// hackaround to work for PC's floating mouse unfocusing
	#undef  UI_FOCUSFIRST
	#define UI_FOCUSFIRST "ui_sgrenade_highlighted"
	
	// special grenade selection popup menus
	menuDef	
	{
		IMPROVED_POPUP_SETUP_ONOPEN( "ocd_popup_cac_extra", 6, (CHOICE_X( 3 )-2), (CHOICE_Y( 3 )+4), ;, execnow "set "UI_FOCUSFIRST" "REF_FLASH_X1"; set ui_inside_popup sgrenade";, 1 )
		onClose{ execnow "set ui_inside_popup 0"; }
		LOCAL_SGRENADE_INFO_WINDOW( "ui_sgrenade_highlighted" )
		LOCAL_SGRENADE_ITEM( 1, "@WEAPON_FLASH_GRENADE", STAT_FLASH_X1, REF_FLASH_X1, "ui_sgrenade_highlighted" )
		LOCAL_SGRENADE_ITEM( 2, "@WEAPON_STUN_GRENADE", STAT_CONCUSSION_X1, REF_CONCUSSION_X1, "ui_sgrenade_highlighted" )
		LOCAL_SGRENADE_ITEM( 3, "@WEAPON_SMOKE_GRENADE", STAT_SMOKE_X1, REF_SMOKE_X1, "ui_sgrenade_highlighted" )
	}
	
	// ====================================================================================================
	// perk selection =====================================================================================
	// ====================================================================================================
	#define LOCAL_PERK_INFO_WINDOW( highlight_dvar ) \
		/* perk information side frame*/ \
		PREPROC_SHADER_DRAW_ALIGNED( (CHOICE_POPUP_WIDTH-6) -4 280 CHOICE_POPUP_HEIGHT( 7 ) CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "white", CHOICE_POPUP_BORDER_COLOR, 1, 2, CHOICE_POPUP_BORDER_COLOR ) \
		LOADOUT_PLATING_RAW( CHOICE_POPUP_WIDTH 8, -2, 0, 280, (CHOICE_POPUP_HEIGHT( 7 )-4), CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0, 0 )\
		/* perk image*/ \
		PREPROC_SHADER_DRAW_ALIGNED( (CHOICE_POPUP_WIDTH+6) 30 256 48 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "gradient_bottom", 1 1 1 0.3, 0, 2, CHOICE_POPUP_BORDER_COLOR ) \
		PREPROC_SHADER_DRAW_ALIGNED( (CHOICE_POPUP_WIDTH+188) -2 64 64 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, tablelookup("mp/statsTable.csv",4,dvarString(highlight_dvar),6), 1 1 1 0.75, 0, 0, 0.2 0.2 0.225 1 ) \
		/* perk title*/\
		PREPROC_TEXT_DRAW_ALIGNED_EXP( (CHOICE_POPUP_WIDTH+10) 58 256 20 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "@"+tablelookup("mp/statsTable.csv",4,dvarString(highlight_dvar),3), TEXTSIZE_DEFAULT, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, COLOR_TITLE ) \
		/* perk desc unlocked*/\
		PREPROC_TEXT_DRAW_ALIGNED_EXP( (CHOICE_POPUP_WIDTH+10) 80 256 20 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0,  "@"+tablelookup("mp/statsTable.csv",4,dvarString(highlight_dvar),7), TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, CHOICE_TEXTCOLOR \
		visible when( dvarBool( ui_perk_hl_unlocked ) && ( dvarString( loadout_grenade )=="smoke_grenade" && dvarString(highlight_dvar)=="specialty_specialgrenade" )==0 ); )\
		PREPROC_TEXT_DRAW_ALIGNED_EXP( (CHOICE_POPUP_WIDTH+10) 80 256 20 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0,  "@MENU_DISABLED", TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, COLOR_TITLE \
		visible when( !dvarBool( ui_perk_hl_unlocked ) || ( dvarString( loadout_grenade )=="smoke_grenade" && dvarString(highlight_dvar)=="specialty_specialgrenade" ) ); )\
		PREPROC_SHADER_DRAW_ALIGNED( (CHOICE_POPUP_WIDTH+6) 0 (CHOICE_SIZE_Y*2) CHOICE_SIZE_Y CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "specialty_locked", 1 1 1 1, 0, 2, CHOICE_POPUP_BORDER_COLOR \
		visible when( !dvarBool( ui_perk_hl_unlocked ) ); ) \

	#define LOCAL_PERK_ACTION( perkDvar, perkRef, paction ) \
			play "mouse_click"; \
			close self \
			exec "set "perkDvar" "perkRef;\
			scriptMenuResponse perkDvar":"perkRef;\
			paction
		
	#define LOCAL_PERK_ITEM( itemNum, camoName, perkDvar, perkRef, pslot, highlight_dvar, paction )\
		LOCAL_PERK_ITEM_VIS( itemNum, camoName, perkDvar, perkRef, pslot, highlight_dvar, paction, 1 )

	#define PI_FOCUS_ACTION( perkRef ) \
		execOnDvarStringValue "perk_allow_"perkRef 0 "set ui_perk_hl_unlocked 0";\
		execOnDvarStringValue "perk_allow_"perkRef 1 "set ui_perk_hl_unlocked 1";\
		exec "set ui_perk_highlighted "perkRef;
		
	#define LOCAL_PERK_ITEM_VIS( itemNum, camoName, perkDvar, perkRef, pslot, highlight_dvar, paction, visArg )\
		CHOICE_BUTTON_FOCUS_VIS_ADV( itemNum, camoName, LOCAL_PERK_ACTION( perkDvar, perkRef, paction );, PI_FOCUS_ACTION( perkRef ), ;, \
		when( dvarBool( "perk_allow_"perkRef ) && ( dvarString(loadout_grenade)==REF_SMOKE_X1 && perkRef==REF_SPECIALGRENADE_X3 )==0 && visArg );, \
			  dvarBool( "perk_allow_"perkRef ) && ( dvarString(loadout_grenade)==REF_SMOKE_X1 && perkRef==REF_SPECIALGRENADE_X3 )==0 && visArg ) \
		CHOICE_BUTTON_FOCUS_VIS_NOHI( itemNum, "", ;,PI_FOCUS_ACTION( perkRef ), ;, \
		when( ( !dvarBool( "perk_allow_"perkRef ) || ( dvarString(loadout_grenade)==REF_SMOKE_X1 && perkRef==REF_SPECIALGRENADE_X3 ) ) && visArg ); ) \
		CHOICE_DBUTTON_VIS( itemNum, camoName, \
		when( ( !dvarBool( "perk_allow_"perkRef ) || dvarString(loadout_grenade)==REF_SMOKE_X1 && perkRef==REF_SPECIALGRENADE_X3 ) && visArg ); )

	// hackaround to work for PC's floating mouse unfocusing
	#undef  UI_FOCUSFIRST
	#define UI_FOCUSFIRST "ui_perk_highlighted"

	// perk1 selection for primary weapon popup menu
	menuDef	
	{
		IMPROVED_POPUP_SETUP_ONOPEN( "ocd_popup_cac_perk1", 7, (CHOICE_X( 4 )-2), (CHOICE_Y( 4 )+18), ;, execnow "set "UI_FOCUSFIRST" "REF_C4_X2"; set ui_inside_popup perk1";, 1 )
		onClose{ execnow "set ui_inside_popup 0"; }
		LOCAL_PERK_INFO_WINDOW( "ui_perk_highlighted" )
		LOCAL_PERK_ITEM( 1, "@PERKS_C4_X_2", "loadout_perk1", REF_C4_X2, CAC_SPECIALTY_EQUIPMENT, "ui_perk_highlighted", ; )
		LOCAL_PERK_ITEM( 2, "@PERKS_SPECIAL_GRENADES_X_3", "loadout_perk1", REF_SPECIALGRENADE_X3, CAC_SPECIALTY_EQUIPMENT, "ui_perk_highlighted", ; )
		LOCAL_PERK_ITEM( 3, "@PERKS_RPG7_X_2", "loadout_perk1", REF_RPG_X2, CAC_SPECIALTY_EQUIPMENT, "ui_perk_highlighted", ; )
		LOCAL_PERK_ITEM( 4, "@PERKS_CLAYMORE_X_2", "loadout_perk1", REF_CLAYMORE_X2, CAC_SPECIALTY_EQUIPMENT, "ui_perk_highlighted", ; )
		LOCAL_PERK_ITEM( 5, "@PERKS_FRAG_X_3", "loadout_perk1", REF_FRAG_X3, CAC_SPECIALTY_EQUIPMENT, "ui_perk_highlighted", ; )
		LOCAL_PERK_ITEM( 6, "@PERKS_BANDOLIER", "loadout_perk1", REF_EXTRAAMMO, CAC_SPECIALTY_EQUIPMENT, "ui_perk_highlighted", ; )
		LOCAL_PERK_ITEM( 7, "@PERKS_BOMB_SQUAD", "loadout_perk1", REF_DETECTEXPLOSIVE, CAC_SPECIALTY_EQUIPMENT, "ui_perk_highlighted", ; )
	}
	
	// perk2 selection for primary weapon popup menu
	menuDef	
	{
		IMPROVED_POPUP_SETUP_ONOPEN( "ocd_popup_cac_perk2", 6, (CHOICE_X( 5 )-2), (CHOICE_Y( 5 )+22), ;, execnow "set "UI_FOCUSFIRST" "REF_BULLETDAMAGE"; set ui_inside_popup perk2";, 1 )
		onClose{ execnow "set ui_inside_popup 0"; }
		LOCAL_PERK_INFO_WINDOW( "ui_perk_highlighted" )
		LOCAL_PERK_ITEM( 1, "@PERKS_STOPPING_POWER", "loadout_perk2", REF_BULLETDAMAGE, CAC_SPECIALTY_WEAPON, "ui_perk_highlighted", ; )
		LOCAL_PERK_ITEM( 2, "@PERKS_JUGGERNAUT", "loadout_perk2", REF_ARMORVEST, CAC_SPECIALTY_WEAPON, "ui_perk_highlighted", ; )
		LOCAL_PERK_ITEM( 3, "@PERKS_SLEIGHT_OF_HAND", "loadout_perk2", REF_FASTRELOAD, CAC_SPECIALTY_WEAPON, "ui_perk_highlighted", ; )
		LOCAL_PERK_ITEM( 4, "@PERKS_DOUBLE_TAP", "loadout_perk2", REF_ROF, CAC_SPECIALTY_WEAPON, "ui_perk_highlighted", ; )
		LOCAL_PERK_ITEM( 5, "@PERKS_UAV_JAMMER", "loadout_perk2", REF_GPSJAMMER, CAC_SPECIALTY_WEAPON, "ui_perk_highlighted", ; )
		LOCAL_PERK_ITEM( 6, "@PERKS_SONIC_BOOM", "loadout_perk2", REF_EXPLOSIVEDAMAGE, CAC_SPECIALTY_WEAPON, "ui_perk_highlighted", ; )
	}
				
	// perk3 selection for primary weapon popup menu
	menuDef	
	{
		IMPROVED_POPUP_SETUP_ONOPEN( "ocd_popup_cac_perk3", 8, (CHOICE_X( 6 )-2), (CHOICE_Y( 6 )+26), ;, execnow "set "UI_FOCUSFIRST" "REF_LONGERSPRINT"; set ui_inside_popup perk3";, 1 )
		onClose{ execnow "set ui_inside_popup 0"; }
		LOCAL_PERK_INFO_WINDOW( "ui_perk_highlighted" )
		LOCAL_PERK_ITEM( 1, "@PERKS_EXTREME_CONDITIONING", "loadout_perk3", REF_LONGERSPRINT, CAC_SPECIALTY_ABILITY, "ui_perk_highlighted", ; )
		LOCAL_PERK_ITEM( 2, "@PERKS_STEADY_AIM", "loadout_perk3", REF_BULLETACCURACY, CAC_SPECIALTY_ABILITY, "ui_perk_highlighted", ; )
		LOCAL_PERK_ITEM( 3, "@PERKS_LAST_STAND", "loadout_perk3", REF_PISTOLDEATH, CAC_SPECIALTY_ABILITY, "ui_perk_highlighted", ; )
		LOCAL_PERK_ITEM( 4, "@PERKS_MARTYRDOM", "loadout_perk3", REF_GRENADEPULLDEATH, CAC_SPECIALTY_ABILITY, "ui_perk_highlighted", ; )
		LOCAL_PERK_ITEM( 5, "@PERKS_DEEP_IMPACT", "loadout_perk3", REF_BULLETPENETRATION, CAC_SPECIALTY_ABILITY, "ui_perk_highlighted", ; )
		LOCAL_PERK_ITEM( 6, "@PERKS_IRON_LUNGS", "loadout_perk3", REF_HOLDBREATH, CAC_SPECIALTY_ABILITY, "ui_perk_highlighted", ; )
		LOCAL_PERK_ITEM( 7, "@PERKS_DEAD_SILENCE", "loadout_perk3", REF_QUIETER, CAC_SPECIALTY_ABILITY, "ui_perk_highlighted", ; )
		LOCAL_PERK_ITEM( 8, "@PERKS_EAVESDROP", "loadout_perk3", REF_PARABOLIC, CAC_SPECIALTY_ABILITY, "ui_perk_highlighted", ; )
	}
