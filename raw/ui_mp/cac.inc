// general definitions

#define CHOICE_X_START			0
#define CHOICE_Y_START			34

#define CHOICE_SEP_1			3
#define CHOICE_SEP_2			6

#include "ui_mp/menustyle.inc"
//#undef CHOICE_SIZE_X
//#define CHOICE_SIZE_X			216

#include "ui/choices_setup_common.menu"
 
#define ORIGIN_STATUS			390 20
#define MENU_FONT_COLOR2		1 1 1 0.75

#include "ui_mp/stats_info.inc"

	menuDef	{
		name			CAC_MENU_NAME
		//fullscreen		1
		rect			0 0 640 480
		focuscolor		COLOR_FOCUSED
		style			WINDOW_STYLE_EMPTY //style			WINDOW_STYLE_FILLED
		blurWorld		7.0
		soundloop 		"music_mainmenu_mp"
		onOpen {			
			hidemenu "endofgame";
			// closing the menus behind due to fullscreen 1, which allows buttons behind the menu to be clicked outside the 4:3 area
			close "pc_cac_popup_ingame";
			close "pc_cac_popup";
			
			// load perk 2's selection into ui_perk2_selection so we can check if dual primaries perk is selected
			execnow "statGetInDvar "CAC_S_SPECIALTY_WEAPON" ui_perk2_selection";
			
			execnow "set ui_dual_primaries false";
			execondvarintvalue ui_perk2_selection 166 "set ui_dual_primaries true";
					
			// set focus to first menu selection	
			setfocus primary_weapon_selection;		
		}
		onEsc {
			execnow "uploadstats";
			close CAC_MENU_NAME;
		}
		onClose{
			showmenu "endofgame";
		}

		// ------------------  statics ------------------------
		itemDef
		{
			style			WINDOW_STYLE_SHADER
			rect			FULLSCREEN_WIDE
			background		"animbg_blur_back"
			visible			when( !dvarbool( ui_showEndOfGame ) )
			decoration
		}

		#undef FOG_SCROLL_TIME
		#define FOG_SCROLL_TIME 60000 //30000

		itemDef
		{
			style			WINDOW_STYLE_SHADER
			rect			-107 0 1708 480
			exp				rect X((-107) - ((float(milliseconds() % FOG_SCROLL_TIME) / FOG_SCROLL_TIME) * (854)))
			background		"animbg_blur_fogscroll"
			visible			when( !dvarbool( ui_showEndOfGame ) )
			decoration
		}

		itemDef
		{
			style			WINDOW_STYLE_SHADER
			rect			FULLSCREEN_WIDE
			background		"animbg_blur_front"
			visible			when( !dvarbool( ui_showEndOfGame ) )
			decoration
		}
		
		// ----------------------------------------------------------------
		
		// background overlay
		itemDef
		{
			style			WINDOW_STYLE_FILLED
			rect			0 0 640 480 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN
			backcolor		0 0 0 0.75 //0 0.05 0.15 0.5
			visible			when( dvarbool( ui_showEndOfGame ) )
			decoration
		}

		// gradient_top
		itemDef
		{
			style			WINDOW_STYLE_SHADER
			rect			0 0 854 75 HORIZONTAL_ALIGN_FULLSCREEN 0
			background		"gradient_top"
			visible			when( dvarbool( ui_showEndOfGame ) )
			decoration
		}

		// gradient_bottom
		itemDef
		{
			style			WINDOW_STYLE_SHADER
			rect			0 405 854 75 HORIZONTAL_ALIGN_FULLSCREEN 0
			background		"gradient_bottom"
			visible			when( dvarbool( ui_showEndOfGame ) )
			decoration
		}
		

		CHOICE_MENU_TITLE( "@MPUI_CREATE_A_CLASS_CAP" )				
		// ------------------------- buttons ------------------------------
		#define BACK_OPEN ;
		#include "ui_mp/navcontrols.inc"
		
		// ------------------------ lobby status ----------------------------
		itemDef
		{
			type			ITEM_TYPE_TEXT
			visible			1
			rect			ORIGIN_STATUS 0 0
			origin			0 0
			forecolor		MENU_FONT_COLOR2
			text			"@MENU_MATCH_BEGINNING_IN"
			textfont		UI_FONT_NORMAL
			textscale		TEXTSIZE_SMALL
			visible 		when ( dvarBool( ui_showEndOfGame ) );
			decoration
		}
		itemDef
		{
			name			intermission_timer_countdown
			type			ITEM_TYPE_TEXT
			visible			1
			rect			ORIGIN_STATUS 0 0
			origin			-40 0
			forecolor		MENU_FONT_COLOR2
			exp				text( secondsAsCountdown( timeLeft() ) );
			textfont		UI_FONT_NORMAL
			textscale		TEXTSIZE_SMALL
			visible 		when ( dvarBool( ui_showEndOfGame ) );
			decoration
		}
		
		//=========================================================
		//===================== MENU SELECTION ====================
		//=========================================================
		
		// PRIMARY WEAPON BUTTON =============================================================
		#define CAC_SETUP_ACTION1 \
			execnow "set ui_primary_selected Primary Weapon"; \
			play "mouse_click"; \
			open CAC_PREFIX"popup_cac_primary";
		
		CHOICE_BUTTON_EX( 1, "@MPUI_PRIMARY_WEAPON1", CAC_SETUP_ACTION1, name primary_weapon_selection )
		CHOICE_NEWICON_VIS( 1, "specialty_new", when( statRangeAnyBitsSet( 3010, 3089, WEAPON_NEW_BITMASK ) ); )

		// SECONDARY WEAPON/SIDE ARM BUTTON =============================================================
		#define CAC_SETUP_ACTION2 \
			play "mouse_click"; \
			open CAC_PREFIX"popup_cac_secondary";

		#define CAC_SETUP_ACTION2_2 \
			execnow "set ui_primary_selected Secondary Weapon"; \
			play "mouse_click"; \
			open CAC_PREFIX"popup_cac_primary2";
					
		CHOICE_BUTTON_BG( 2, 1 )
		CHOICE_HIGHLIGHT( 2, 1 )
		CHOICE_BUTTON_VIS_NOHI( 2, "@MPUI_SIDE_ARM1", CAC_SETUP_ACTION2, when( "specialty_twoprimaries" != tablelookup( "mp/statstable.csv", 1, stat(CAC_SPECIALTY_WEAPON) , 4 ) ); )
		CHOICE_NEWICON_VIS( 2, "specialty_new", when( statRangeAnyBitsSet( 3000, 3009, WEAPON_NEW_BITMASK ) && "specialty_twoprimaries" != tablelookup( "mp/statstable.csv", 1, stat(CAC_SPECIALTY_WEAPON) , 4  ) ); )
		CHOICE_BUTTON_VIS_NOHI( 2, "@MPUI_SECONDARY_WEAPON", CAC_SETUP_ACTION2_2, when( "specialty_twoprimaries" == tablelookup( "mp/statstable.csv", 1, stat(CAC_SPECIALTY_WEAPON) , 4  ) ); )
	
		// SPECIAL GRENADE BUTTON =============================================================
		#define CAC_SETUP_ACTION3 \
			play "mouse_click"; \
			open CAC_PREFIX"popup_cac_extra";
			
		CHOICE_BUTTON( 3, "@MPUI_SPECIAL_GRENADE", CAC_SETUP_ACTION3 )

		CHOICE_SEPARATOR( CHOICE_SEP_1 )
		
		// PERK 1 BUTTON =============================================================
		// perk 1 empty warning
		CHOICE_BUTTON_BG_RAW( 4, "gradient_fadein", 0.5 0.15 0 0.5, when(stat(CAC_S_SPECIALTY_EQUIPMENT) == 190); )
		
		#define CAC_SETUP_ACTION4 \
			play "mouse_click"; \
			open CAC_PREFIX"popup_cac_perk1";	
		
		#define LOCAL_VIS4_WHEN \
			( "gl" == tablelookup( "mp/attachmenttable.csv", 9, stat(CAC_PRIMARY_ATTACHMENT), 4 ) ) || \
			( "gl" == tablelookup( "mp/attachmenttable.csv", 9, stat(CAC_SECONDARY_ATTACHMENT), 4 ) ) || \
			( "grip" == tablelookup( "mp/attachmenttable.csv", 9, stat(CAC_PRIMARY_ATTACHMENT), 4 ) ) || \
			( "grip" == tablelookup( "mp/attachmenttable.csv", 9, stat(CAC_SECONDARY_ATTACHMENT), 4 ) )

		#define LOCAL_VIS4_WHEN_NOT \
			( "gl" != tablelookup( "mp/attachmenttable.csv", 9, stat(CAC_PRIMARY_ATTACHMENT), 4 ) ) && \
			( "gl" != tablelookup( "mp/attachmenttable.csv", 9, stat(CAC_SECONDARY_ATTACHMENT), 4 ) ) && \
			( "grip" != tablelookup( "mp/attachmenttable.csv", 9, stat(CAC_PRIMARY_ATTACHMENT), 4 ) ) && \
			( "grip" != tablelookup( "mp/attachmenttable.csv", 9, stat(CAC_SECONDARY_ATTACHMENT), 4 ) )

		CHOICE_BUTTON_FOCUS_VIS_ADV( 4, "@MPUI_PERK_1", CAC_SETUP_ACTION4, ;, ;, when( LOCAL_VIS4_WHEN_NOT ), LOCAL_VIS4_WHEN_NOT )
		CHOICE_BUTTON_FOCUS_VIS_NOHI( 4, "", ;, ;, ;, when( LOCAL_VIS4_WHEN ) )
		CHOICE_DBUTTON_VIS( 4, "@MPUI_PERK_1", when( LOCAL_VIS4_WHEN ) )
		CHOICE_NEWICON_VIS( 4, "specialty_new", when( ANY_NEW_PERK1 ) )

		// PERK 2 BUTTON =============================================================
		#define CAC_SETUP_ACTION5 \		
			play "mouse_click"; \
			open CAC_PREFIX"popup_cac_perk2";		

		CHOICE_BUTTON( 5, "@MPUI_PERK_2", CAC_SETUP_ACTION5 )
		CHOICE_NEWICON_VIS( 5, "specialty_new", when( ANY_NEW_PERK2 ) )
		
		// PERK 3 BUTTON =============================================================
		#define CAC_SETUP_ACTION6 \		
			play "mouse_click"; \
			open CAC_PREFIX"popup_cac_perk3";		

		CHOICE_BUTTON( 6, "@MPUI_PERK_3", CAC_SETUP_ACTION6 )
		CHOICE_NEWICON_VIS( 6, "specialty_new", when( ANY_NEW_PERK3 ) )
		
		CHOICE_SEPARATOR( CHOICE_SEP_2 )

		// RENAME BUTTON =============================================================	
		#define CAC_SETUP_ACTION7 \		
			play "mouse_click"; \
			execNow "ui_keyboard MENU_CUSTOMCLASS_KEYBOARD "CAC_CUSTOM_NAME;				
		
		#ifdef PC
			CHOICE_BUTTON( 7, "@MENU_RENAME", open CAC_PREFIX"pc_rename"; )
		#else
			CHOICE_BUTTON( 7, "@MENU_RENAME", CAC_SETUP_ACTION7 )
		#endif

		// RESET BUTTON =============================================================	
		#define CAC_SETUP_ACTION8 \		
			play "mouse_click"; \
			open CAC_PREFIX"popup_cac_template";			
		
		CHOICE_BUTTON( 8, "@MENU_RESET_TO_DEFAULT", CAC_SETUP_ACTION8 )
				
		/* ================================================================================= */
		/* ================================ LOADOUT DISPLAY ================================ */
		/* ================================================================================= */

		#define STAT_CAC_PRIMARY				stat( CAC_PRIMARY )
		#define STAT_CAC_PRIMARY_ATTACHMENT		stat( CAC_PRIMARY_ATTACHMENT )
		#define STAT_CAC_SECONDARY				stat( CAC_SECONDARY )
		#define STAT_CAC_SECONDARY_ATTACHMENT	stat( CAC_SECONDARY_ATTACHMENT )
		#define STAT_CAC_SPECIALTY_EQUIPMENT	stat( CAC_SPECIALTY_EQUIPMENT )
		#define STAT_CAC_SPECIALTY_WEAPON		stat( CAC_SPECIALTY_WEAPON )
		#define STAT_CAC_SPECIALTY_ABILITY		stat( CAC_SPECIALTY_ABILITY )
		#define STAT_CAC_SPECIAL_GRENADE		stat( CAC_SPECIAL_GRENADE )
		#define STAT_CAC_CAMO					stat( CAC_CAMO )
		
		#include "ui_mp/cac_loadout.inc"

		#include "ui/safearea.menu"
	}
	
	// close all 2nd and 3rd layer popups on end action
	#define PREPROC_ATTACH_CLOSEALL \
	close CAC_PREFIX"popup_cac_primary"; \
	close CAC_PREFIX"popup_cac_primary2"; \
	close CAC_PREFIX"popup_cac_secondary"; \
	close CAC_PREFIX"popup_cac_assault"; \
	close CAC_PREFIX"popup_cac_SMG"; \
	close CAC_PREFIX"popup_cac_LMG"; \
	close CAC_PREFIX"popup_cac_sniper"; \
	close CAC_PREFIX"popup_cac_shotgun"; \
	close CAC_PREFIX"popup_cac_assault2"; \
	close CAC_PREFIX"popup_cac_SMG2"; \
	close CAC_PREFIX"popup_cac_LMG2"; \
	close CAC_PREFIX"popup_cac_sniper2"; \
	close CAC_PREFIX"popup_cac_shotgun2"; \
	close "popup_cac_template"; \
	close CAC_PREFIX"attachment_popup_assault"; \
	close CAC_PREFIX"attachment_popup_SMG"; \
	close CAC_PREFIX"attachment_popup_LMG"; \
	close CAC_PREFIX"attachment_popup_sniper"; \
	close CAC_PREFIX"attachment_popup_shotgun"; \
	close CAC_PREFIX"attachment_popup_pistol"; \
	close CAC_PREFIX"attachment_popup_assault2"; \
	close CAC_PREFIX"attachment_popup_SMG2"; \
	close CAC_PREFIX"attachment_popup_LMG2"; \
	close CAC_PREFIX"attachment_popup_sniper2"; \
	close CAC_PREFIX"attachment_popup_shotgun2"; \
	close CAC_PREFIX"attachment_popup_pistol2"; \
	close CAC_PREFIX"popup_cac_camo"; \
	close CAC_PREFIX"popup_cac_camo2"; \
	close CAC_PREFIX"attachment_popup_fake";
	
	
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

	// ========================== Perk 1 special cases ===========================
	
	#define PERK1_RESET1 \
		execNowOnDvarStringValue ui_perk1_slot 193 "statset "CAC_S_SPECIALTY_EQUIPMENT" 190"; \
		execNowOnDvarStringValue ui_perk1_slot 192 "statset "CAC_S_SPECIALTY_EQUIPMENT" 190"; \
		execNowOnDvarStringValue ui_perk1_slot 191 "statset "CAC_S_SPECIALTY_EQUIPMENT" 190"; 
		
	#define PERK1_RESET \
		execNow "statGetInDvar "CAC_S_SPECIALTY_EQUIPMENT" ui_perk1_slot"; PERK1_RESET1 \
		execNow "statGetInDvar "CAC_S_SECONDARY_ATTACHMENT" ui_secondary_attachment_slot"; \
		execNowOnDvarStringValue ui_secondary_attachment_slot 4 "statset "CAC_S_SPECIALTY_EQUIPMENT" 193"; \
		execNowOnDvarStringValue ui_secondary_attachment_slot 5 "statset "CAC_S_SPECIALTY_EQUIPMENT" 193"; \
		execNow "statGetInDvar "CAC_S_PRIMARY_ATTACHMENT" ui_primary_attachment_slot"; \
		execNowOnDvarStringValue ui_primary_attachment_slot 4 "statset "CAC_S_SPECIALTY_EQUIPMENT" 193"; \
		execNowOnDvarStringValue ui_primary_attachment_slot 5 "statset "CAC_S_SPECIALTY_EQUIPMENT" 193";
		
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
		PREPROC_TEXT_DRAW_ALIGNED_EXP( (CHOICE_POPUP_WIDTH+10) 80 256 20 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "@"+tablelookup("mp/statstable.csv",4,dvarString(highlight_dvar),7), TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, CHOICE_TEXTCOLOR visible when( stat(int(tablelookup("mp/statsTable.csv",4,dvarString(highlight_dvar),1))) & 1 ); )\
		PREPROC_TEXT_DRAW_ALIGNED_EXP( (CHOICE_POPUP_WIDTH+10) 80 256 20 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "@"+tablelookup("mp/statstable.csv",4,dvarString(highlight_dvar),10), TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, COLOR_TITLE visible when( ( stat(int(tablelookup("mp/statsTable.csv",4,dvarString(highlight_dvar),1))) & 1 ) == 0 ); )\
		PREPROC_SHADER_DRAW_ALIGNED( (CHOICE_POPUP_WIDTH+6) 0 (CHOICE_SIZE_Y*2) CHOICE_SIZE_Y CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "specialty_locked", 1 1 1 1, 0, 2, CHOICE_POPUP_BORDER_COLOR visible when( ( stat(int(tablelookup("mp/statsTable.csv",4,dvarString(highlight_dvar),1))) & 1 ) == 0 ); ) \
		PREPROC_SHADER_DRAW_ALIGNED( 0 -24 (CHOICE_POPUP_WIDTH-4) 22 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "white", 0.15 0.15 0.17 1, 0, 2, CHOICE_POPUP_BORDER_COLOR )\
		PREPROC_TEXT_DRAW_ALIGNED_EXP( 8 -24 (CHOICE_POPUP_WIDTH-4) 22 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, -32 0, dvarString(ui_weapon_class_selected), TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_RIGHT, CHOICE_TEXTCOLOR ) \
		/* pointer icon */ \
		PREPROC_SHADER_DRAW_ALIGNED( 200 -16 16 8 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "hitech_arrow_down", 0.9 0.9 0.95 0.4, 0, 2, CHOICE_POPUP_BORDER_COLOR )

	#define LOCAL_PRIMARY_WEAPON_ACTION( suffix, pstat, weapRef ) \
		execnow "statset "CAC_S_PRIMARY_ATTACHMENT" 0; statset "CAC_S_CAMO" 0"; \
		play "mouse_click"; \
		statsetusingtable( CAC_PRIMARY, pstat ); \
		statsetusingtable( CAC_PRIMARY_STORAGE, tableLookup( "mp/statstable.csv", 4, weapRef, 1 ) ); \
		execNow "statGetInDvar "CAC_S_PRIMARY_STORAGE" ui_primary_weapon"; \
		CLEAR_NEW( ui_primary_weapon, WEAPON_NEW_BITMASK ); \
		execNow "statGetInDvar "CAC_S_SPECIALTY_EQUIPMENT" ui_perk1_slot"; PERK1_RESET1 \
		execNow "statGetInDvar "CAC_S_SECONDARY_ATTACHMENT" ui_secondary_attachment_slot"; \
		execNowOnDvarStringValue ui_secondary_attachment_slot 4 "statset "CAC_S_SPECIALTY_EQUIPMENT" 193"; \
		execNowOnDvarStringValue ui_secondary_attachment_slot 5 "statset "CAC_S_SPECIALTY_EQUIPMENT" 193"; \
		uiScript openMenuOnDvar "selected_weapon_class" assault CAC_PREFIX"attachment_popup_assault"suffix; \
		uiScript openMenuOnDvar "selected_weapon_class" SMG CAC_PREFIX"attachment_popup_SMG"suffix; \
		uiScript openMenuOnDvar "selected_weapon_class" LMG CAC_PREFIX"attachment_popup_LMG"suffix; \
		uiScript openMenuOnDvar "selected_weapon_class" shotgun CAC_PREFIX"attachment_popup_shotgun"suffix; \
		uiScript openMenuOnDvar "selected_weapon_class" sniper CAC_PREFIX"attachment_popup_sniper"suffix;

	#define LOCAL_PRIMARY_WEAPON_ACTION2( suffix, pstat, weapRef ) \		
		execnow "statset "CAC_S_SECONDARY_ATTACHMENT" 0"; \
		play "mouse_click"; \
		statsetusingtable( CAC_SECONDARY, pstat ); \
		statsetusingtable( CAC_SECONDARY_STORAGE, tableLookup( "mp/statstable.csv", 4, weapRef, 1 ) ); \
		execNow "statGetInDvar "CAC_S_SECONDARY_STORAGE" ui_secondary_weapon"; \
		CLEAR_NEW( ui_secondary_weapon, WEAPON_NEW_BITMASK ); \
		execNow "statGetInDvar "CAC_S_SPECIALTY_EQUIPMENT" ui_perk1_slot"; \
		execNow "statGetInDvar "CAC_S_PRIMARY_ATTACHMENT" ui_primary_attachment_slot"; \
		execNowOnDvarStringValue ui_primary_attachment_slot 4 "statset "CAC_S_SPECIALTY_EQUIPMENT" 193"; \
		execNowOnDvarStringValue ui_primary_attachment_slot 5 "statset "CAC_S_SPECIALTY_EQUIPMENT" 193"; \
		uiScript openMenuOnDvar "selected_weapon_class" assault CAC_PREFIX"attachment_popup_assault"suffix; \
		uiScript openMenuOnDvar "selected_weapon_class" SMG CAC_PREFIX"attachment_popup_SMG"suffix; \
		uiScript openMenuOnDvar "selected_weapon_class" LMG CAC_PREFIX"attachment_popup_LMG"suffix; \
		uiScript openMenuOnDvar "selected_weapon_class" shotgun CAC_PREFIX"attachment_popup_shotgun"suffix; \
		uiScript openMenuOnDvar "selected_weapon_class" sniper CAC_PREFIX"attachment_popup_sniper"suffix;
		
	#define LOCAL_PRIMARY_WEAPON_ACTION3( suffix, pstat, weapRef ) \
		execnow "statset "CAC_S_PRIMARY_ATTACHMENT" 0; statset "CAC_S_CAMO" 0"; \
		play "mouse_click"; \
		statsetusingtable( CAC_PRIMARY, pstat ); \
		statsetusingtable( CAC_PRIMARY_STORAGE, tableLookup( "mp/statstable.csv", 4, weapRef, 1 ) ); \
		execNow "statGetInDvar "CAC_S_PRIMARY_STORAGE" ui_primary_weapon"; \
		CLEAR_NEW( ui_primary_weapon, WEAPON_NEW_BITMASK ); \
		execNow "statGetInDvar "CAC_S_SPECIALTY_EQUIPMENT" ui_perk1_slot"; PERK1_RESET1 \
		execNow "statGetInDvar "CAC_S_SECONDARY_ATTACHMENT" ui_secondary_attachment_slot"; \
		execNowOnDvarStringValue ui_secondary_attachment_slot 4 "statset "CAC_S_SPECIALTY_EQUIPMENT" 193"; \
		execNowOnDvarStringValue ui_secondary_attachment_slot 5 "statset "CAC_S_SPECIALTY_EQUIPMENT" 193"; \
		open CAC_PREFIX"attachment_popup_fake"; \
		open CAC_PREFIX"popup_cac_camo2";
		
	#define LOCAL_PRIMARY_WEAPON_ACTION4( suffix, pstat, weapRef ) \		
		execnow "statset "CAC_S_SECONDARY_ATTACHMENT" 0"; \
		play "mouse_click"; \
		statsetusingtable( CAC_SECONDARY, pstat ); \
		statsetusingtable( CAC_SECONDARY_STORAGE, tableLookup( "mp/statstable.csv", 4, weapRef, 1 ) ); \
		execNow "statGetInDvar "CAC_S_SECONDARY_STORAGE" ui_secondary_weapon"; \
		CLEAR_NEW( ui_secondary_weapon, WEAPON_NEW_BITMASK ); \
		execNow "statGetInDvar "CAC_S_SPECIALTY_EQUIPMENT" ui_perk1_slot"; \
		execNow "statGetInDvar "CAC_S_PRIMARY_ATTACHMENT" ui_primary_attachment_slot"; \
		execNowOnDvarStringValue ui_primary_attachment_slot 4 "statset "CAC_S_SPECIALTY_EQUIPMENT" 193"; \
		execNowOnDvarStringValue ui_primary_attachment_slot 5 "statset "CAC_S_SPECIALTY_EQUIPMENT" 193"; \
		PREPROC_ATTACH_CLOSEALL
		
	// hacked to hide the second primary if same weapon is selected in first primary, change weapon description to "Already selected"
	#define LOCAL_WEAPON_ITEM( suffix, itemNum, weaponName, weaponStat, weaponRef, highlight_dvar, rawStat )\
		CHOICE_BUTTON_FOCUS_VIS_NOHI( itemNum, "", ;, execnow "set "highlight_dvar" "weaponRef, ;, when( ( stat( int(weaponStat)+3000 ) & 1 ) == 0 ); ) \
		CHOICE_DBUTTON_VIS( itemNum, weaponName, when( 1 ); ) \
		CHOICE_BUTTON_FOCUS_VIS_ADV( itemNum, weaponName, LOCAL_PRIMARY_WEAPON_ACTION( suffix, weaponStat, weaponRef ), \
		execnow "set "highlight_dvar" "weaponRef;, CLEAR_WEAP_NEW( weaponRef );, when( ( stat( int(weaponStat)+3000 ) & 1 ) && dvarString( ui_primary_selected ) == "Primary Weapon" && int(weaponStat) != stat(CAC_SECONDARY) );, \
		( stat( int(weaponStat)+3000 ) & 1 ) && dvarString( ui_primary_selected ) == "Primary Weapon" && int(weaponStat) != stat(CAC_SECONDARY) ) \
		CHOICE_BUTTON_FOCUS_VIS_ADV( itemNum, weaponName, LOCAL_PRIMARY_WEAPON_ACTION2( suffix, weaponStat, weaponRef ), \
		execnow "set "highlight_dvar" "weaponRef;, CLEAR_WEAP_NEW( weaponRef );, when( ( stat( int(weaponStat)+3000 ) & 1 ) && dvarString( ui_primary_selected ) == "Secondary Weapon" && int(weaponStat) != stat(CAC_PRIMARY) );, \
		( stat( int(weaponStat)+3000 ) & 1 ) && dvarString( ui_primary_selected ) == "Secondary Weapon" && int(weaponStat) != stat(CAC_PRIMARY) ) \
		CHOICE_NEWICON_VIS( itemNum, "specialty_new", when( ( stat( int(weaponStat)+3000 ) & (NEW_WEAPON_BITMASK+NEW_ITEMS_MASK)) > 0 ) ) \
		CHOICE_NEWICON_VIS( itemNum, "specialty_locked", when( ( stat( int(weaponStat)+3000 ) & 1 ) == 0 ); ) 
		
	#define LOCAL_WEAPON_ITEM2( suffix, itemNum, weaponName, weaponStat, weaponRef, highlight_dvar, rawStat )\
		CHOICE_BUTTON_FOCUS_VIS_NOHI( itemNum, "", ;, execnow "set "highlight_dvar" "weaponRef, ;, when( ( stat( int(weaponStat)+3000 ) & 1 ) == 0 ); ) \
		CHOICE_DBUTTON_VIS( itemNum, weaponName, when( 1 ); ) \
		CHOICE_BUTTON_FOCUS_VIS_ADV( itemNum, weaponName, LOCAL_PRIMARY_WEAPON_ACTION3( suffix, weaponStat, weaponRef ), \
		execnow "set "highlight_dvar" "weaponRef;, CLEAR_WEAP_NEW( weaponRef );, when( ( stat( int(weaponStat)+3000 ) & 1 ) && dvarString( ui_primary_selected ) == "Primary Weapon" && int(weaponStat) != stat(CAC_SECONDARY) );, \
		( stat( int(weaponStat)+3000 ) & 1 ) && dvarString( ui_primary_selected ) == "Primary Weapon" && int(weaponStat) != stat(CAC_SECONDARY) ) \
		CHOICE_BUTTON_FOCUS_VIS_ADV( itemNum, weaponName, LOCAL_PRIMARY_WEAPON_ACTION4( suffix, weaponStat, weaponRef ), \
		execnow "set "highlight_dvar" "weaponRef;, CLEAR_WEAP_NEW( weaponRef );, when( ( stat( int(weaponStat)+3000 ) & 1 ) && dvarString( ui_primary_selected ) == "Secondary Weapon" && int(weaponStat) != stat(CAC_PRIMARY) );, \
		( stat( int(weaponStat)+3000 ) & 1 ) && dvarString( ui_primary_selected ) == "Secondary Weapon" && int(weaponStat) != stat(CAC_PRIMARY) ) \
		CHOICE_NEWICON_VIS( itemNum, "specialty_new", when( ( stat( int(weaponStat)+3000 ) & (NEW_WEAPON_BITMASK+NEW_ITEMS_MASK)) > 0 ) ) \
		CHOICE_NEWICON_VIS( itemNum, "specialty_locked", when( ( stat( int(weaponStat)+3000 ) & 1 ) == 0 ); ) 
		
	/*			
	#define LOCAL_WEAPON_ITEM_HIDDEN( suffix, itemNum, weaponName, weaponStat, weaponRef, highlight_dvar, rawStat )\
		CHOICE_BUTTON_BG( itemNum, when( ( stat( int(weaponStat)+3000 ) & 1 ) && dvarString( ui_primary_selected ) == "Primary Weapon" ); ) \
		CHOICE_BUTTON_FOCUS_VIS( itemNum, weaponName, LOCAL_PRIMARY_WEAPON_ACTION3( suffix, weaponStat, weaponRef );, execnow "set "highlight_dvar" "weaponRef, CLEAR_WEAP_NEW( weaponRef );, when( ( stat( int(weaponStat)+3000 ) & 1 ) && dvarString( ui_primary_selected ) == "Primary Weapon" ); ) \
		CHOICE_NEWICON_VIS( itemNum, "specialty_new", when( (stat( int(weaponStat)+3000 ) & (NEW_WEAPON_BITMASK+NEW_ITEMS_MASK)) > 0 && dvarString( ui_primary_selected ) == "Primary Weapon" ); )	
	*/
	
	// primary weapon class dropdown
	menuDef
	{
		IMPROVED_POPUP_SETUP_ONOPEN( CAC_PREFIX"popup_cac_primary", 5, (CHOICE_X( 1 )-2), (CHOICE_Y( 1 )-4), ;, execnow "set ui_inside_popup weapon_class; set ui_show_preview 1";, 1 )
		onClose{	execnow "set ui_show_preview 0; set ui_primary_highlighted 0; set ui_attachment_highlighted 0";	}
		
		#define LOCAL_WEAPON_CLASS( itemNum, ptext, plabel, pVis ) \
			CHOICE_BUTTON_EX( itemNum, plabel, play "mouse_click"; execnow "set selected_weapon_class "ptext"; set ui_weapon_class_selected "plabel; open CAC_PREFIX"popup_cac_"ptext;, name ptext ) \
			CHOICE_NEWICON_VIS( itemNum, "specialty_new", when( pVis ) )		

		LOCAL_WEAPON_CLASS( 1, "assault", "@MPUI_ASSAULT_RIFLES", statRangeAnyBitsSet( 3020, 3026, WEAPON_NEW_BITMASK ) )
		LOCAL_WEAPON_CLASS( 2, "SMG", "@MPUI_SUB_MACHINE_GUNS", statRangeAnyBitsSet( 3010, 3019, WEAPON_NEW_BITMASK ) )
		LOCAL_WEAPON_CLASS( 3, "LMG", "@MPUI_LIGHT_MACHINE_GUNS", statRangeAnyBitsSet( 3080, 3089, WEAPON_NEW_BITMASK ) )
		LOCAL_WEAPON_CLASS( 4, "shotgun", "@MPUI_SHOTGUNS", statRangeAnyBitsSet( 3070, 3079, WEAPON_NEW_BITMASK ) )
		LOCAL_WEAPON_CLASS( 5, "sniper", "@MPUI_SNIPER_RIFLES", statRangeAnyBitsSet( 3060, 3069, WEAPON_NEW_BITMASK ) )	
	}
	
	// second primary weapon class dropdown
	menuDef
	{
		IMPROVED_POPUP_SETUP_ONOPEN( CAC_PREFIX"popup_cac_primary2", 5, (CHOICE_X( 2 )-2), (CHOICE_Y( 2 )), ;, execnow "set ui_inside_popup weapon_class; set ui_show_preview 1";, 1 )
		onClose{	execnow "set ui_show_preview 0; set ui_primary_highlighted 0; set ui_attachment_highlighted 0";	}
		
		#define LOCAL_WEAPON_CLASS2( itemNum, ptext, plabel, pVis ) \
			CHOICE_BUTTON_EX( itemNum, plabel, play "mouse_click"; execnow "set selected_weapon_class "ptext"; set ui_weapon_class_selected "plabel; open CAC_PREFIX"popup_cac_"ptext"2";, name ptext ) \
			CHOICE_NEWICON_VIS( itemNum, "specialty_new", when( pVis ) )		

		LOCAL_WEAPON_CLASS2( 1, "assault", "@MPUI_ASSAULT_RIFLES", statRangeAnyBitsSet( 3020, 3026, WEAPON_NEW_BITMASK ) )
		LOCAL_WEAPON_CLASS2( 2, "SMG", "@MPUI_SUB_MACHINE_GUNS", statRangeAnyBitsSet( 3010, 3019, WEAPON_NEW_BITMASK ) )
		LOCAL_WEAPON_CLASS2( 3, "LMG", "@MPUI_LIGHT_MACHINE_GUNS", statRangeAnyBitsSet( 3080, 3089, WEAPON_NEW_BITMASK ) )
		LOCAL_WEAPON_CLASS2( 4, "shotgun", "@MPUI_SHOTGUNS", statRangeAnyBitsSet( 3070, 3079, WEAPON_NEW_BITMASK ) )
		LOCAL_WEAPON_CLASS2( 5, "sniper", "@MPUI_SNIPER_RIFLES", statRangeAnyBitsSet( 3060, 3069, WEAPON_NEW_BITMASK ) )	
	}
	
	// hackaround to work for PC's floating mouse unfocusing
	#undef  UI_FOCUSFIRST
	#ifdef PC
		#define UI_FOCUSFIRST "ui_primary_highlighted"
	#else
		#define UI_FOCUSFIRST "ui_fake_focus"
	#endif
	
	// primary weapon items
	#define LOCAL_MASTER_WEAPON_GROUP( suffix, pos, y_offset )\
	menuDef	{\
		IMPROVED_POPUP_SETUP_ONOPEN( CAC_PREFIX"popup_cac_assault"suffix, 7, (CHOICE_X( pos )-2), (CHOICE_Y( pos )+20+y_offset), ;, execnow "set "UI_FOCUSFIRST" "REF_M16"; set ui_inside_popup assault";, 0 )\
		LOCAL_WEAPON_INFO_WINDOW( "ui_primary_highlighted" )\
		LOCAL_WEAPON_ITEM( suffix, 1, "@WEAPON_M16", STAT_ASSAULT_M16, REF_M16, "ui_primary_highlighted", 3025 )\
		LOCAL_WEAPON_ITEM( suffix, 2, "@WEAPON_AK47", STAT_ASSAULT_AK47, REF_AK47, "ui_primary_highlighted", 3020 )\
		LOCAL_WEAPON_ITEM( suffix, 3, "@WEAPON_M4_CARBINE", STAT_ASSAULT_M4, REF_M4, "ui_primary_highlighted", 3026 )\
		LOCAL_WEAPON_ITEM( suffix, 4, "@WEAPON_G3", STAT_ASSAULT_G3, REF_G3, "ui_primary_highlighted", 3023 )\
		LOCAL_WEAPON_ITEM( suffix, 5, "@WEAPON_G36C", STAT_ASSAULT_G36C, REF_G36C, "ui_primary_highlighted", 3024 )\
		LOCAL_WEAPON_ITEM( suffix, 6, "@WEAPON_M14", STAT_ASSAULT_M14, REF_M14, "ui_primary_highlighted", 3021 )\
		LOCAL_WEAPON_ITEM2( suffix, 7, "@WEAPON_MP44", STAT_ASSAULT_MP44, REF_MP44, "ui_primary_highlighted", 3022 )\
	}\
	menuDef	{\
		IMPROVED_POPUP_SETUP_ONOPEN( CAC_PREFIX"popup_cac_LMG"suffix, 7, (CHOICE_X( pos )-2), (CHOICE_Y( pos )+20+y_offset), ;, execnow "set "UI_FOCUSFIRST" "REF_M249SAW"; set ui_inside_popup lmg";, 0 )\
		LOCAL_WEAPON_INFO_WINDOW( "ui_primary_highlighted" )\
		LOCAL_WEAPON_ITEM( suffix, 1, "@WEAPON_SAW", STAT_LMG_M249SAW, REF_M249SAW, "ui_primary_highlighted", 3081 )\
		LOCAL_WEAPON_ITEM( suffix, 2, "@WEAPON_RPD", STAT_LMG_RPD, REF_RPD, "ui_primary_highlighted", 3080 )\
		LOCAL_WEAPON_ITEM( suffix, 3, "@WEAPON_M60E4", STAT_LMG_M60E4, REF_M60E4, "ui_primary_highlighted", 3082 )\
	}\
	menuDef	{\
		IMPROVED_POPUP_SETUP_ONOPEN( CAC_PREFIX"popup_cac_SMG"suffix, 7, (CHOICE_X( pos )-2), (CHOICE_Y( pos )+20+y_offset), ;, execnow "set "UI_FOCUSFIRST" "REF_MP5";set ui_inside_popup smg";, 0 )\
		LOCAL_WEAPON_INFO_WINDOW( "ui_primary_highlighted" )\
		LOCAL_WEAPON_ITEM( suffix, 1, "@WEAPON_MP5", STAT_SMG_MP5, REF_MP5, "ui_primary_highlighted", 3010 )\
		LOCAL_WEAPON_ITEM( suffix, 2, "@WEAPON_SKORPION", STAT_SMG_SKORPION, REF_SKORPION, "ui_primary_highlighted", 3011 )\
		LOCAL_WEAPON_ITEM( suffix, 3, "@WEAPON_UZI", STAT_SMG_UZI, REF_UZI, "ui_primary_highlighted", 3012 )\
		LOCAL_WEAPON_ITEM( suffix, 4, "@WEAPON_AK74U", STAT_SMG_AK74U, REF_AK74U, "ui_primary_highlighted", 3013 )\
		LOCAL_WEAPON_ITEM( suffix, 5, "@WEAPON_P90", STAT_SMG_P90, REF_P90, "ui_primary_highlighted", 3014 )\
	}\
	menuDef	{\
		IMPROVED_POPUP_SETUP_ONOPEN( CAC_PREFIX"popup_cac_shotgun"suffix, 7, (CHOICE_X( pos )-2), (CHOICE_Y( pos )+20+y_offset), ;, execnow "set "UI_FOCUSFIRST" "REF_WINCHESTER1200"; set ui_inside_popup shotgun";, 0 )\
		LOCAL_WEAPON_INFO_WINDOW( "ui_primary_highlighted" )\
		LOCAL_WEAPON_ITEM( suffix, 1, "@WEAPON_WINCHESTER1200", STAT_SHOTGUN_WINCHESTER1200, REF_WINCHESTER1200, "ui_primary_highlighted", 3071 )\
		LOCAL_WEAPON_ITEM( suffix, 2, "@WEAPON_BENELLI", STAT_SHOTGUN_BENELLIM4, REF_BENELLIM4, "ui_primary_highlighted", 3070 )\
	}\
	menuDef	{\
		IMPROVED_POPUP_SETUP_ONOPEN( CAC_PREFIX"popup_cac_sniper"suffix, 7, (CHOICE_X( pos )-2), (CHOICE_Y( pos )+20+y_offset), ;, execnow "set "UI_FOCUSFIRST" "REF_M40A3"; set ui_inside_popup sniper";, 0 )\
		LOCAL_WEAPON_INFO_WINDOW( "ui_primary_highlighted" )\
		LOCAL_WEAPON_ITEM( suffix, 1, "@WEAPON_M40A3", STAT_SNIPER_M40A3, REF_M40A3, "ui_primary_highlighted", 3061 )\
		LOCAL_WEAPON_ITEM( suffix, 2, "@WEAPON_M21", STAT_SNIPER_M21, REF_M21, "ui_primary_highlighted", 3065 )\
		LOCAL_WEAPON_ITEM( suffix, 3, "@WEAPON_DRAGUNOV", STAT_SNIPER_DRAGUNOVSVD, REF_DRAGUNOVSVD, "ui_primary_highlighted", 3060 )\
		LOCAL_WEAPON_ITEM( suffix, 4, "@WEAPON_REMINGTON700", STAT_SNIPER_REMINGTON700, REF_REMINGTON700, "ui_primary_highlighted", 3064 )\
		LOCAL_WEAPON_ITEM( suffix, 5, "@WEAPON_BARRETT", STAT_SNIPER_BARRETT, REF_BARRETT, "ui_primary_highlighted", 3062 )\
	}
	
	// primary and second primary weapon selection popup menus
	LOCAL_MASTER_WEAPON_GROUP( "", 1, 0 )
	LOCAL_MASTER_WEAPON_GROUP( "2", 2, 4 )
	
	// ====================================================================================================
	// primary and second primary attachment selection ====================================================
	// ====================================================================================================
	#define LOCAL_ATTACHMENT_INFO_WINDOW( pslot ) \
		/* attachment information side frame*/ \
		PREPROC_SHADER_DRAW_ALIGNED( (CHOICE_POPUP_WIDTH-6) -4 280 CHOICE_POPUP_HEIGHT( 7 ) CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "white", CHOICE_POPUP_BORDER_COLOR, 1, 2, CHOICE_POPUP_BORDER_COLOR visible when( dvarString(ui_inside_popup) != "camo" ); ) \
		LOADOUT_PLATING_RAW( CHOICE_POPUP_WIDTH 8, -2, 0, 280, (CHOICE_POPUP_HEIGHT( 7 )-4), CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN visible when( dvarString(ui_inside_popup) != "camo" );, 0, 0 ) \
		/* attachment image*/ \
		PREPROC_SHADER_DRAW_ALIGNED( (CHOICE_POPUP_WIDTH+6) 30 256 48 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "gradient_bottom", 1 1 1 0.3, 0, 2, CHOICE_POPUP_BORDER_COLOR visible when( dvarString(ui_inside_popup) != "camo" ); ) \
		PREPROC_SHADER_DRAW_ALIGNED( (CHOICE_POPUP_WIDTH+182) 6 64 64 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, tablelookup("mp/attachmentTable.csv",4,dvarString(ui_attachment_highlighted),6), 1 1 1 1, 0, 2, CHOICE_POPUP_BORDER_COLOR visible when( dvarString(ui_inside_popup) != "camo" ); ) \
		/* attachment title*/\
		PREPROC_TEXT_DRAW_ALIGNED_EXP( (CHOICE_POPUP_WIDTH+10) 58 256 20 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "@"+tablelookup("mp/attachmentTable.csv",4,dvarString(ui_attachment_highlighted),3), TEXTSIZE_DEFAULT, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, COLOR_TITLE visible when( dvarString(ui_inside_popup) != "camo" ); ) \
		/* attachment desc unlocked*/\
		PREPROC_TEXT_DRAW_ALIGNED_EXP( (CHOICE_POPUP_WIDTH+10) 80 256 20 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "@"+tablelookup("mp/attachmentTable.csv",4,dvarString(ui_attachment_highlighted),7), TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, CHOICE_TEXTCOLOR visible when( stat( stat( pslot-1 )+3000 ) & int(tablelookup( "mp/attachmenttable.csv", 4, dvarString(ui_attachment_highlighted), 10 ) ) ); )\
		PREPROC_TEXT_DRAW_ALIGNED_EXP( (CHOICE_POPUP_WIDTH+10) 80 256 20 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "@"+tablelookup("mp/attachmentTable.csv",4,dvarString(ui_attachment_highlighted),8), TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, COLOR_TITLE visible when( (  stat( stat( pslot-1 )+3000 ) & int(tablelookup( "mp/attachmenttable.csv", 4, dvarString(ui_attachment_highlighted), 10 ) ) ) == 0 ); )\
		PREPROC_SHADER_DRAW_ALIGNED( (CHOICE_POPUP_WIDTH+6) 0 (CHOICE_SIZE_Y*2) CHOICE_SIZE_Y CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "specialty_locked", 1 1 1 1, 0, 2, CHOICE_POPUP_BORDER_COLOR visible when( ( stat( stat( pslot-1 )+3000 ) & int(tablelookup( "mp/attachmenttable.csv", 4, dvarString(ui_attachment_highlighted), 10 ))) == 0 && dvarString(ui_inside_popup) != "camo" ); ) \
		PREPROC_SHADER_DRAW_ALIGNED( 0 -24 (CHOICE_POPUP_WIDTH-4) 22 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "white", 0.15 0.15 0.17 1, 0, 2, CHOICE_POPUP_BORDER_COLOR )\
		PREPROC_TEXT_DRAW_ALIGNED_EXP( 8 -24 (CHOICE_POPUP_WIDTH-4) 22 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, -32 0, "@"+tablelookup("mp/statstable.csv",0,stat(pslot-1),3), TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_RIGHT, CHOICE_TEXTCOLOR )\
		/* pointer icon */ \
		PREPROC_SHADER_DRAW_ALIGNED( 200 -16 16 8 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "hitech_arrow_right", 0.55 0.95 0.55 0.7, 0, 2, CHOICE_POPUP_BORDER_COLOR )

	#define LOCAL_ATTACHMENT_ACTION( pslot, pnum, paction ) \
		paction; \
		statsetusingtable( pslot, pnum ); \
		open CAC_PREFIX"popup_cac_camo";
		
	#define LOCAL_ATTACHMENT_ACTION2( pslot, pnum, paction) \
		paction; \
		statsetusingtable( pslot, pnum );\
		PREPROC_ATTACH_CLOSEALL

	#define LOCAL_ATTACHMENT_ITEM( itemNum, p_setstat, p_numref, pname, paction, ptype, statDvar, bitMask )\
		CHOICE_BUTTON_FOCUS_VIS_ADV( itemNum, "@"+tablelookup("mp/attachmentTable.csv",4,pname,3), LOCAL_ATTACHMENT_ACTION( p_setstat, p_numref, paction );CLEAR_NEW( statDvar, bitMask );, execnow "set ui_attachment_highlighted "pname;, CLEAR_NEW( statDvar, bitMask );, when( ptype == "primary" && ( stat( stat( p_setstat-1 )+3000 ) & int(tablelookup( "mp/attachmenttable.csv", 9, p_numref, 10 ) ) ) ), ptype == "primary" && ( stat( stat( p_setstat-1 )+3000 ) & int(tablelookup( "mp/attachmenttable.csv", 9, p_numref, 10 ) ) ) ) \
		CHOICE_BUTTON_FOCUS_VIS_ADV( itemNum, "@"+tablelookup("mp/attachmentTable.csv",4,pname,3), LOCAL_ATTACHMENT_ACTION2( p_setstat, p_numref, paction );CLEAR_NEW( statDvar, bitMask );, execnow "set ui_attachment_highlighted "pname;, CLEAR_NEW( statDvar, bitMask );, when( ptype == "secondary" && ( stat( stat( p_setstat-1 )+3000 ) & int(tablelookup( "mp/attachmenttable.csv", 9, p_numref, 10 )) ) ), ptype == "secondary" && ( stat( stat( p_setstat-1 )+3000 ) & int(tablelookup( "mp/attachmenttable.csv", 9, p_numref, 10 ) ) ) ) \
		CHOICE_BUTTON_FOCUS_VIS_NOHI( itemNum, "", ;, execnow "set ui_attachment_highlighted "pname, ;, when( ( stat( stat( p_setstat-1 )+3000 ) & int(tablelookup( "mp/attachmenttable.csv", 9, p_numref, 10 ))) == 0 ); ) \
		CHOICE_DBUTTON_VIS( itemNum, "@"+tablelookup("mp/attachmentTable.csv",4,pname,3), when( ( stat( stat( p_setstat-1 )+3000 ) & int(tablelookup( "mp/attachmenttable.csv", 9, p_numref, 10 ))) == 0 ); ) \
		CHOICE_NEWICON_VIS( itemNum, "specialty_new", when( ( int(tablelookup( "mp/attachmenttable.csv", 9, p_numref, 10 )) != 1 ) && (stat( stat( p_setstat-1 )+3000 ) & int(tablelookup( "mp/attachmenttable.csv", 9, p_numref, 10 ))<<16 )) ) \
		CHOICE_NEWICON_VIS( itemNum, "specialty_locked", when( ( stat( stat( p_setstat-1 )+3000 ) & int(tablelookup( "mp/attachmenttable.csv", 9, p_numref, 10 ))) == 0 ); )

	// hackaround to work for PC's floating mouse unfocusing
	#undef  UI_FOCUSFIRST
	#ifdef PC
		#define UI_FOCUSFIRST "ui_attachment_highlighted"
	#else
		#define UI_FOCUSFIRST "ui_fake_focus"
	#endif
		
	// primary and second primary attachment items
	#define LOCAL_MASTER_ATTACHMENT_GROUP( stat_slot, suffix, pos, ptype, y_offset, statDvar )\
	menuDef { /* assault attachments*/ \
		IMPROVED_POPUP_SETUP_ONOPEN( CAC_PREFIX"attachment_popup_assault"suffix, 7, (CHOICE_X( pos )-2), (CHOICE_Y( pos )+44+y_offset), ;, execnow "set "UI_FOCUSFIRST" "REF_ATTACHMENT_NONE"; set ui_inside_popup attachment";, 0 )\
		onClose{execnow "set ui_inside_popup 0";} \
		LOCAL_ATTACHMENT_INFO_WINDOW( stat_slot )\
		LOCAL_ATTACHMENT_ITEM( 1, stat_slot, NUM_NONE, "none", PERK1_RESET, ptype, statDvar, 0 )\
		LOCAL_ATTACHMENT_ITEM( 2, stat_slot, NUM_GL, "gl", play "mouse_click"; execnow "statset "CAC_S_SPECIALTY_EQUIPMENT" 193", ptype, statDvar, GL_NEW_BITMASK )\
		LOCAL_ATTACHMENT_ITEM( 3, stat_slot, NUM_SUPPRESSOR, "silencer", PERK1_RESET, ptype, statDvar, SILENCER_NEW_BITMASK )\
		LOCAL_ATTACHMENT_ITEM( 4, stat_slot, NUM_REFLEX, "reflex", PERK1_RESET, ptype, statDvar, REDDOT_NEW_BITMASK )\
		LOCAL_ATTACHMENT_ITEM( 5, stat_slot, NUM_ACOG, "acog", PERK1_RESET, ptype, statDvar, ACOG_NEW_BITMASK )\
	}\
	menuDef { /* LMG attachments*/\
		IMPROVED_POPUP_SETUP_ONOPEN( CAC_PREFIX"attachment_popup_LMG"suffix, 7, (CHOICE_X( pos )-2), (CHOICE_Y( pos )+44+y_offset), ;, execnow "set "UI_FOCUSFIRST" "REF_ATTACHMENT_NONE"; set ui_inside_popup attachment";, 0 )\
		onClose{execnow "set ui_inside_popup 0";} \
		LOCAL_ATTACHMENT_INFO_WINDOW( stat_slot )\
		LOCAL_ATTACHMENT_ITEM( 1, stat_slot, NUM_NONE, "none", PERK1_RESET, ptype, statDvar, 0 )\
		LOCAL_ATTACHMENT_ITEM( 2, stat_slot, NUM_REFLEX, "reflex", PERK1_RESET, ptype, statDvar, REDDOT_NEW_BITMASK )\
		LOCAL_ATTACHMENT_ITEM( 3, stat_slot, NUM_GRIP, "grip", play "mouse_click"; execnow "statset "CAC_S_SPECIALTY_EQUIPMENT" 193", ptype, statDvar, GRIP_NEW_BITMASK )\
		LOCAL_ATTACHMENT_ITEM( 4, stat_slot, NUM_ACOG, "acog", PERK1_RESET, ptype, statDvar, ACOG_NEW_BITMASK )\
	}\
	menuDef	{ /* SMG attachments*/\
		IMPROVED_POPUP_SETUP_ONOPEN( CAC_PREFIX"attachment_popup_SMG"suffix, 7, (CHOICE_X( pos )-2), (CHOICE_Y( pos )+44+y_offset), ;, execnow "set "UI_FOCUSFIRST" "REF_ATTACHMENT_NONE"; set ui_inside_popup attachment";, 0 )\
		onClose{execnow "set ui_inside_popup 0";} \
		LOCAL_ATTACHMENT_INFO_WINDOW( stat_slot )\
		LOCAL_ATTACHMENT_ITEM( 1, stat_slot, NUM_NONE, "none", PERK1_RESET, ptype, statDvar, 0 )\
		LOCAL_ATTACHMENT_ITEM( 2, stat_slot, NUM_SUPPRESSOR, "silencer", PERK1_RESET, ptype, statDvar, SILENCER_NEW_BITMASK )\
		LOCAL_ATTACHMENT_ITEM( 3, stat_slot, NUM_REFLEX, "reflex", PERK1_RESET, ptype, statDvar, REDDOT_NEW_BITMASK )\
		LOCAL_ATTACHMENT_ITEM( 4, stat_slot, NUM_ACOG, "acog", PERK1_RESET, ptype, statDvar, ACOG_NEW_BITMASK )\
	}\
	menuDef { /* shotgun attachments*/\
		IMPROVED_POPUP_SETUP_ONOPEN( CAC_PREFIX"attachment_popup_shotgun"suffix, 7, (CHOICE_X( pos )-2), (CHOICE_Y( pos )+44+y_offset), ;, execnow "set "UI_FOCUSFIRST" "REF_ATTACHMENT_NONE"; set ui_inside_popup attachment";, 0 )\
		onClose{execnow "set ui_inside_popup 0";} \
		LOCAL_ATTACHMENT_INFO_WINDOW( stat_slot )\
		LOCAL_ATTACHMENT_ITEM( 1, stat_slot, NUM_NONE, "none", PERK1_RESET, ptype, statDvar, 0 )\
		LOCAL_ATTACHMENT_ITEM( 2, stat_slot, NUM_REFLEX, "reflex", PERK1_RESET, ptype, statDvar, REDDOT_NEW_BITMASK )\
		LOCAL_ATTACHMENT_ITEM( 3, stat_slot, NUM_GRIP, "grip", play "mouse_click"; execnow "statset "CAC_S_SPECIALTY_EQUIPMENT" 193", ptype, statDvar, GRIP_NEW_BITMASK )\
	}\
	menuDef	{ /* sniper attachments*/\
		IMPROVED_POPUP_SETUP_ONOPEN( CAC_PREFIX"attachment_popup_sniper"suffix, 7, (CHOICE_X( pos )-2), (CHOICE_Y( pos )+44+y_offset), ;, execnow "set "UI_FOCUSFIRST" "REF_ATTACHMENT_NONE"; set ui_inside_popup attachment";, 0 )\
		onClose{execnow "set ui_inside_popup 0";} \		
		LOCAL_ATTACHMENT_INFO_WINDOW( stat_slot )\
		LOCAL_ATTACHMENT_ITEM( 1, stat_slot, NUM_NONE, "none", PERK1_RESET, ptype, statDvar, 0 )\
		LOCAL_ATTACHMENT_ITEM( 2, stat_slot, NUM_ACOG, "acog", PERK1_RESET, ptype, statDvar, ACOG_NEW_BITMASK )\
	}

	menuDef	{ /* fake attachment heading for weapons without attachments to be displayed on top of camo popup */
		IMPROVED_POPUP_SETUP_ONOPEN( CAC_PREFIX"attachment_popup_fake", 7, (CHOICE_X( 1 )-2), (CHOICE_Y( 1 ) + 44), ;, ;, 0 )
		LOCAL_ATTACHMENT_INFO_WINDOW( CAC_PRIMARY_ATTACHMENT )
		PREPROC_SHADER_DRAW_ALIGNED( 0 -24 (CHOICE_POPUP_WIDTH-4) 22 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "white", 0.15 0.15 0.17 1, 0, 2, CHOICE_POPUP_BORDER_COLOR )
		PREPROC_TEXT_DRAW_ALIGNED_EXP( 8 -24 (CHOICE_POPUP_WIDTH-4) 22 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, -32 0, "@"+tablelookup("mp/statstable.csv",0,stat(CAC_PRIMARY),3), TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_RIGHT, CHOICE_TEXTCOLOR )
		/* pointer icon */
		PREPROC_SHADER_DRAW_ALIGNED( 200 -16 16 8 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "hitech_arrow_right", 0.55 0.95 0.55 0.7, 0, 2, CHOICE_POPUP_BORDER_COLOR )
	}

	// side arm attachment selection ======================================================================
	menuDef	{ /* pistol attachments*/
		IMPROVED_POPUP_SETUP_ONOPEN( CAC_PREFIX"attachment_popup_pistol", 7, (CHOICE_X( 2 )-2), (CHOICE_Y( 2 )+24), ;, execnow "set "UI_FOCUSFIRST" "REF_ATTACHMENT_NONE"; set ui_inside_popup attachment";, 0 )
		onClose{execnow "set ui_inside_popup 0";}
		LOCAL_ATTACHMENT_INFO_WINDOW( CAC_SECONDARY_ATTACHMENT )
		LOCAL_ATTACHMENT_ITEM( 1, CAC_SECONDARY_ATTACHMENT, NUM_NONE, "none", PERK1_RESET, "secondary", "ui_secondary_weapon", 0 )
		LOCAL_ATTACHMENT_ITEM( 2, CAC_SECONDARY_ATTACHMENT, NUM_SUPPRESSOR, "silencer", PERK1_RESET, "secondary", "ui_secondary_weapon", SILENCER_NEW_BITMASK )
	}
	
	// primary and second primary attachment popup menus
	LOCAL_MASTER_ATTACHMENT_GROUP( CAC_PRIMARY_ATTACHMENT, "", 1, "primary", 0, "ui_primary_weapon" )
	LOCAL_MASTER_ATTACHMENT_GROUP( CAC_SECONDARY_ATTACHMENT, "2", 2, "secondary", 4, "ui_secondary_weapon" )

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
		PREPROC_TEXT_DRAW_ALIGNED_EXP( (CHOICE_POPUP_WIDTH+10) 80 256 20 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "@"+tablelookup("mp/statstable.csv",4,dvarString(highlight_dvar),7), TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, CHOICE_TEXTCOLOR visible when( stat(int(tablelookup("mp/statsTable.csv",4,dvarString(highlight_dvar),1))) & 1 ); )\
		PREPROC_TEXT_DRAW_ALIGNED_EXP( (CHOICE_POPUP_WIDTH+10) 80 256 20 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "@"+tablelookup("mp/statstable.csv",4,dvarString(highlight_dvar),10), TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, COLOR_TITLE visible when( ( stat(int(tablelookup("mp/statsTable.csv",4,dvarString(highlight_dvar),1))) & 1 ) == 0 ); )\
		PREPROC_SHADER_DRAW_ALIGNED( (CHOICE_POPUP_WIDTH+6) 0 (CHOICE_SIZE_Y*2) CHOICE_SIZE_Y CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "specialty_locked", 1 1 1 1, 0, 2, CHOICE_POPUP_BORDER_COLOR visible when( ( stat(int(tablelookup("mp/statsTable.csv",4,dvarString(highlight_dvar),1))) & 1 ) == 0 ); ) \

	#define LOCAL_SIDEARM_ACTION( pstat, weapRef ) \
			execnow "statset "CAC_S_SECONDARY_ATTACHMENT" 0" \
			play "mouse_click"; \
			statsetusingtable( CAC_SECONDARY, pstat ); \
			statsetusingtable( CAC_SECONDARY_STORAGE, tableLookup( "mp/statstable.csv", 4, weapRef, 1 ) ); \
			execNow "statGetInDvar "CAC_S_SECONDARY_STORAGE" ui_secondary_weapon"; \
			CLEAR_NEW( ui_secondary_weapon, WEAPON_NEW_BITMASK ); \
			PREPROC_ATTACH_CLOSEALL

	#define LOCAL_SIDEARM_ACTION2( pstat, weapRef ) \		
			execNow "set ui_perk1_slot 0"; \
			execnow "statset "CAC_S_SECONDARY_ATTACHMENT" 0" \
			statsetusingtable( CAC_SECONDARY, pstat ); \
			statsetusingtable( CAC_SECONDARY_STORAGE, tableLookup( "mp/statstable.csv", 4, weapRef, 1 ) ); \
			execNow "statGetInDvar "CAC_S_SECONDARY_STORAGE" ui_secondary_weapon"; \
			CLEAR_NEW( ui_secondary_weapon, WEAPON_NEW_BITMASK ); \
			play "mouse_click"; \
			uiScript openMenuOnDvar "selected_weapon_class" pistol CAC_PREFIX"attachment_popup_pistol";
		
	#define LOCAL_SIDEARM_ITEM( itemNum, weaponName, weaponStat, weaponRef, highlight_dvar )\
		CHOICE_BUTTON_FOCUS_VIS_ADV( itemNum, weaponName, LOCAL_SIDEARM_ACTION( weaponStat, weaponRef ), execnow "set "highlight_dvar" "weaponRef, CLEAR_WEAP_NEW( weaponRef );, \
		when( ( stat(int(weaponStat)+3000) & 1 ) && ( "deserteagle"==tablelookup("mp/statstable.csv", 0, weaponStat , 4) || "deserteaglegold"==tablelookup("mp/statstable.csv", 0, weaponStat , 4) ) );, \
			  ( stat(int(weaponStat)+3000) & 1 ) && ( "deserteagle"==tablelookup("mp/statstable.csv", 0, weaponStat , 4) || "deserteaglegold"==tablelookup("mp/statstable.csv", 0, weaponStat , 4) ) ) \
		CHOICE_BUTTON_FOCUS_VIS_ADV( itemNum, weaponName, LOCAL_SIDEARM_ACTION2( weaponStat, weaponRef ), execnow "set "highlight_dvar" "weaponRef, CLEAR_WEAP_NEW( weaponRef );, \
		when( ( stat(int(weaponStat)+3000) & 1 ) && "deserteagle"!=tablelookup("mp/statstable.csv", 0, weaponStat , 4) && "deserteaglegold"!=tablelookup("mp/statstable.csv", 0, weaponStat , 4) );, \
			  ( stat(int(weaponStat)+3000) & 1 ) && "deserteagle"!=tablelookup("mp/statstable.csv", 0, weaponStat , 4) && "deserteaglegold"!=tablelookup("mp/statstable.csv", 0, weaponStat , 4) ) \
		CHOICE_BUTTON_FOCUS_VIS_NOHI( itemNum, "", ;, execnow "set "highlight_dvar" "weaponRef, ;, when( ( stat(int(weaponStat)+3000) & 1 ) == 0 && "deserteaglegold"!=tablelookup("mp/statstable.csv", 0, weaponStat , 4) ); ) \
		CHOICE_DBUTTON_VIS( itemNum, weaponName, when( ( stat(int(weaponStat)+3000) & 1 ) == 0 && "deserteaglegold"!=tablelookup("mp/statstable.csv", 0, weaponStat , 4) ); ) \
		CHOICE_NEWICON_VIS( itemNum, "specialty_new", when( ( (stat(int(weaponStat)+3000)) & (NEW_WEAPON_BITMASK+NEW_ITEMS_MASK) ) > 0 ) ) \
		CHOICE_NEWICON_VIS( itemNum, "specialty_locked", when( ( stat(int(weaponStat)+3000) & 1 ) == 0 && "deserteaglegold"!=tablelookup("mp/statstable.csv", 0, weaponStat , 4) ); )
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
		IMPROVED_POPUP_SETUP_ONOPEN( CAC_PREFIX"popup_cac_secondary", 7, (CHOICE_X( 2 )-2), (CHOICE_Y( 2 )), ;, execnow "set "UI_FOCUSFIRST" "REF_M9BERETTA"; set selected_weapon_class pistol; set ui_inside_popup pistol";, 1 )
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
		PREPROC_TEXT_DRAW_ALIGNED_EXP( (CHOICE_POPUP_WIDTH+10) 80 256 20 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "@"+tablelookup("mp/attachmenttable.csv",4,dvarString(highlight_dvar),7), TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, CHOICE_TEXTCOLOR visible when( stat(stat(CAC_PRIMARY)+3000) & int(tablelookup( "mp/attachmenttable.csv", 4, dvarString(ui_camo_highlighted), 10 )) ); )\
		PREPROC_TEXT_DRAW_ALIGNED_EXP( (CHOICE_POPUP_WIDTH+10) 80 256 20 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "@"+tablelookup("mp/attachmenttable.csv",4,dvarString(highlight_dvar),8), TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, COLOR_TITLE visible when( ( stat(stat(CAC_PRIMARY)+3000) & int(tablelookup( "mp/attachmenttable.csv", 4, dvarString(ui_camo_highlighted), 10 )) ) == 0 ); )\
		PREPROC_SHADER_DRAW_ALIGNED( (CHOICE_POPUP_WIDTH+6) 0 (CHOICE_SIZE_Y*2) CHOICE_SIZE_Y CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "specialty_locked", 1 1 1 1, 0, 2, CHOICE_POPUP_BORDER_COLOR visible when( ( stat(stat(CAC_PRIMARY)+3000) & int(tablelookup( "mp/attachmenttable.csv", 4, dvarString(ui_camo_highlighted), 10 )) ) == 0 ); ) \
		PREPROC_SHADER_DRAW_ALIGNED( 0 -24 (CHOICE_POPUP_WIDTH-4) 22 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "white", 0.15 0.15 0.17 1, 0, 2, CHOICE_POPUP_BORDER_COLOR )\
		PREPROC_TEXT_DRAW_ALIGNED_EXP( 8 -24 (CHOICE_POPUP_WIDTH-4) 22 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, -32 0, "@"+tablelookup("mp/attachmenttable.csv",9,stat(CAC_PRIMARY_ATTACHMENT),3), TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_RIGHT, CHOICE_TEXTCOLOR )\
		/* pointer icon */ \
		PREPROC_SHADER_DRAW_ALIGNED( 200 -16 16 8 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "hitech_arrow_right", 0.55 0.95 0.55 0.7, 0, 2, CHOICE_POPUP_BORDER_COLOR )

	#define LOCAL_CAMO_ACTION( pnum ) \
			play "mouse_click"; \
			statsetusingtable( CAC_CAMO, pnum ); \
			PREPROC_ATTACH_CLOSEALL
		
	#define LOCAL_CAMO_ITEM( itemNum, camoName, pnum, camoRef, highlight_dvar, bitMask, visArg )\
		CHOICE_BUTTON_FOCUS_VIS_ADV( itemNum, camoName, LOCAL_CAMO_ACTION( pnum );CLEAR_NEW( "ui_primary_weapon", bitMask );, execnow "set "highlight_dvar" "camoRef, CLEAR_NEW( "ui_primary_weapon", bitMask );, \
		when( stat(stat(CAC_PRIMARY)+3000) & int(tablelookup( "mp/attachmenttable.csv", 11, pnum, 10 )) && ( visArg ) );, \
			  stat(stat(CAC_PRIMARY)+3000) & int(tablelookup( "mp/attachmenttable.csv", 11, pnum, 10 )) && ( visArg ) ) \
		CHOICE_BUTTON_FOCUS_VIS_NOHI( itemNum, "", ;, execnow "set "highlight_dvar" "camoRef, ;, when( ( stat(stat(CAC_PRIMARY)+3000) & int(tablelookup( "mp/attachmenttable.csv", 11, pnum, 10 )) ) == 0 && ( visArg ) ); ) \
		CHOICE_DBUTTON_VIS( itemNum, camoName, when( ( stat(stat(CAC_PRIMARY)+3000) & int(tablelookup( "mp/attachmenttable.csv", 11, pnum, 10 )) ) == 0 && ( visArg ) ); ) \
		CHOICE_NEWICON_VIS( itemNum, "specialty_new", when( ( int(tablelookup( "mp/attachmenttable.csv", 11, pnum, 10 )) != 1 ) && \
		( stat(stat(CAC_PRIMARY)+3000) & int(tablelookup( "mp/attachmenttable.csv", 11, pnum, 10 ))<<16 ) && ( visArg ) ) ) \
		CHOICE_NEWICON_VIS( itemNum, "specialty_locked", when( ( stat(stat(CAC_PRIMARY)+3000) & int(tablelookup( "mp/attachmenttable.csv", 11, pnum, 10 )) ) == 0 && ( visArg ) ); )
				
	#define GOLDEN_VIS_CONDITION \
		tablelookup("mp/statstable.csv",1,dvarString(ui_primary_weapon),4)==REF_UZI ||\
		tablelookup("mp/statstable.csv",1,dvarString(ui_primary_weapon),4)==REF_AK47 ||\
		tablelookup("mp/statstable.csv",1,dvarString(ui_primary_weapon),4)==REF_DRAGUNOVSVD ||\
		tablelookup("mp/statstable.csv",1,dvarString(ui_primary_weapon),4)==REF_BENELLIM4 ||\
		tablelookup("mp/statstable.csv",1,dvarString(ui_primary_weapon),4)==REF_M60E4
	
	// BRENT ATTENTION
	#define PRESTIGE_VIS_CONDITION \
		0

	// hackaround to work for PC's floating mouse unfocusing
	#undef  UI_FOCUSFIRST
	#ifdef PC
		#define UI_FOCUSFIRST "ui_camo_highlighted"
	#else
		#define UI_FOCUSFIRST "ui_fake_focus"
	#endif
	
	// camo skin selection for primary weapon popup menu
	#define LOCAL_CAMO_GROUP( prefix, onLeave )\
	menuDef	\
	{\
		IMPROVED_POPUP_SETUP_ONOPEN( CAC_PREFIX"popup_cac_camo"prefix, 8, (CHOICE_X( 1 )-2), (CHOICE_Y( 1 )+68), ;, execnow "set "UI_FOCUSFIRST" "REF_CAMO_NONE"; set ui_inside_popup camo";, 0 )\
		onClose{onLeave;} \
		LOCAL_CAMO_INFO_WINDOW( "ui_camo_highlighted" )\
		LOCAL_CAMO_ITEM( 1, "@MPUI_NONE", CAMO_NONE, REF_CAMO_NONE, "ui_camo_highlighted", 0, 1 )\
		LOCAL_CAMO_ITEM( 2, "@MPUI_DESERT", CAMO_BROCKHUARD, REF_BROCKHUARD, "ui_camo_highlighted", DESERT_NEW_BITMASK, 1 )\
		LOCAL_CAMO_ITEM( 3, "@MPUI_WOODLAND", CAMO_BUSHDWELLER, REF_BUSHDWELLER, "ui_camo_highlighted", WOODLAND_NEW_BITMASK, 1 )\
		LOCAL_CAMO_ITEM( 4, "@MPUI_DIGITAL", CAMO_BLACKWHITEMARPAT, REF_BLACKWHITEMARPAT, "ui_camo_highlighted", DIGITAL_NEW_BITMASK, 1 )\
		LOCAL_CAMO_ITEM( 5, "@MPUI_RED_TIGER", CAMO_TIGERRED, REF_TIGERRED, "ui_camo_highlighted", REDTIGER_NEW_BITMASK, 1 )\
		LOCAL_CAMO_ITEM( 6, "@MPUI_BLUE_TIGER", CAMO_STAGGER, REF_STAGGER, "ui_camo_highlighted", BLUETIGER_NEW_BITMASK, 1 )\
		LOCAL_CAMO_ITEM( 7, "@MPUI_GOLDEN", CAMO_GOLDEN, REF_GOLDEN, "ui_camo_highlighted", GOLDEN_NEW_BITMASK, GOLDEN_VIS_CONDITION )\
		LOCAL_CAMO_ITEM( 8, "@MPUI_PRESTIGE", CAMO_PRESTIGE, REF_PRESTIGE, "ui_camo_highlighted", PRESTIGE_NEW_BITMASK, PRESTIGE_VIS_CONDITION )\
	}
	// camo skin selection for primary weapon popup menu
	LOCAL_CAMO_GROUP( "", execnow "set ui_inside_popup attachment" )
	// camo skin selection for primary weapon without attachments
	LOCAL_CAMO_GROUP( "2", execnow "set ui_inside_popup 0"; close CAC_PREFIX"attachment_popup_fake" )
	
	
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
		visible when( ( ( dvarString(ui_sgrenade_highlighted)=="smoke_grenade") && (tableLookup("mp/statsTable.csv",0,stat(CAC_SPECIALTY_EQUIPMENT),4)=="specialty_specialgrenade") ) == 0 ); )\
		PREPROC_TEXT_DRAW_ALIGNED_EXP( (CHOICE_POPUP_WIDTH+10) 56 256 20 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "@"+tablelookup("mp/statstable.csv",4,dvarString(highlight_dvar),10), TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, COLOR_TITLE \
		visible when( (dvarString(ui_sgrenade_highlighted)=="smoke_grenade") && (tableLookup("mp/statsTable.csv",0,stat(CAC_SPECIALTY_EQUIPMENT),4)=="specialty_specialgrenade") ); )

	#define LOCAL_SGRENADE_ACTION( pstat ) \
			play "mouse_click"; \
			statsetusingtable( CAC_SPECIAL_GRENADE, pstat ); \
			close CAC_PREFIX"popup_cac_extra"
		
	#define LOCAL_SGRENADE_ITEM( itemNum, weaponName, weaponStat, weaponRef, highlight_dvar )\
		CHOICE_BUTTON_FOCUS_VIS_ADV( itemNum, weaponName, LOCAL_SGRENADE_ACTION( weaponStat ), execnow "set "highlight_dvar" "weaponRef, ;, \
		when( ( (tableLookup("mp/statsTable.csv",0,weaponStat,4)=="smoke_grenade") && (tableLookup("mp/statsTable.csv",0,stat(CAC_SPECIALTY_EQUIPMENT),4)=="specialty_specialgrenade") ) == 0 );, \
			  ( (tableLookup("mp/statsTable.csv",0,weaponStat,4)=="smoke_grenade") && (tableLookup("mp/statsTable.csv",0,stat(CAC_SPECIALTY_EQUIPMENT),4)=="specialty_specialgrenade") ) == 0 ) \
		CHOICE_BUTTON_FOCUS_VIS_NOHI( itemNum, "", ;, execnow "set "highlight_dvar" "weaponRef, ;, when( (tableLookup("mp/statsTable.csv",0,weaponStat,4)=="smoke_grenade") && (tableLookup("mp/statsTable.csv",0,stat(CAC_SPECIALTY_EQUIPMENT),4)=="specialty_specialgrenade") ); ) \
		CHOICE_DBUTTON_VIS( itemNum, weaponName, when( (tableLookup("mp/statsTable.csv",0,weaponStat,4)=="smoke_grenade") && (tableLookup("mp/statsTable.csv",0,stat(CAC_SPECIALTY_EQUIPMENT),4)=="specialty_specialgrenade") ); ) \
	
	// hackaround to work for PC's floating mouse unfocusing
	#undef  UI_FOCUSFIRST
	#ifdef PC
		#define UI_FOCUSFIRST "ui_sgrenade_highlighted"
	#else
		#define UI_FOCUSFIRST "ui_fake_focus"
	#endif
	
	// special grenade selection popup menus
	menuDef	
	{
		IMPROVED_POPUP_SETUP_ONOPEN( CAC_PREFIX"popup_cac_extra", 6, (CHOICE_X( 3 )-2), (CHOICE_Y( 3 )+4), ;, execnow "set "UI_FOCUSFIRST" "REF_FLASH_X1"; set ui_inside_popup sgrenade";, 1 )
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
		visible when( stat( int(tablelookup("mp/statsTable.csv",4,dvarString(highlight_dvar),1)) ) > 0 && ( tableLookup("mp/statsTable.csv",0,stat(CAC_SPECIAL_GRENADE),4)=="smoke_grenade" && dvarString(highlight_dvar)=="specialty_specialgrenade" )==0 ); )\
		PREPROC_TEXT_DRAW_ALIGNED_EXP( (CHOICE_POPUP_WIDTH+10) 80 256 20 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0,  "@"+tablelookup("mp/statsTable.csv",4,dvarString(highlight_dvar),10), TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, COLOR_TITLE \
		visible when( stat( int(tablelookup("mp/statsTable.csv",4,dvarString(highlight_dvar),1)) ) == 0 || ( tableLookup("mp/statsTable.csv",0,stat(CAC_SPECIAL_GRENADE),4)=="smoke_grenade" && dvarString(highlight_dvar)=="specialty_specialgrenade" ) ); )\
		PREPROC_SHADER_DRAW_ALIGNED( (CHOICE_POPUP_WIDTH+6) 0 (CHOICE_SIZE_Y*2) CHOICE_SIZE_Y CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "specialty_locked", 1 1 1 1, 0, 2, CHOICE_POPUP_BORDER_COLOR \
		visible when( stat( int(tablelookup("mp/statsTable.csv",4,dvarString(highlight_dvar),1)) ) == 0 ); ) \

	#define LOCAL_PERK_ACTION( pslot, pstat, paction ) \
			play "mouse_click"; \
			close self \
			statsetusingtable( pslot, pstat ); \
			paction
		
	#define LOCAL_PERK_ITEM( itemNum, camoName, pstat, perkRef, pslot, highlight_dvar, paction )\
		LOCAL_PERK_ITEM_VIS( itemNum, camoName, pstat, perkRef, pslot, highlight_dvar, paction, 1 )
		
	#define LOCAL_PERK_ITEM_VIS( itemNum, camoName, pstat, perkRef, pslot, highlight_dvar, paction, visArg )\
		CHOICE_BUTTON_FOCUS_VIS_ADV( itemNum, camoName, LOCAL_PERK_ACTION( pslot, pstat, paction );CLEAR_PERK_NEW( perkRef );, execnow "set "highlight_dvar" "perkRef, CLEAR_PERK_NEW( perkRef );, \
		when( stat( pstat ) > 0 && ( tableLookup("mp/statsTable.csv",0,stat(CAC_SPECIAL_GRENADE),4)=="smoke_grenade" && tableLookup("mp/statsTable.csv",0,pstat,4)=="specialty_specialgrenade" )==0 && visArg );, \
			  stat( pstat ) > 0 && ( tableLookup("mp/statsTable.csv",0,stat(CAC_SPECIAL_GRENADE),4)=="smoke_grenade" && tableLookup("mp/statsTable.csv",0,pstat,4)=="specialty_specialgrenade" )==0 && visArg ) \
		CHOICE_BUTTON_FOCUS_VIS_NOHI( itemNum, "", ;, execnow "set "highlight_dvar" "perkRef, ;, \
		when( ( stat( pstat ) == 0 || ( tableLookup("mp/statsTable.csv",0,stat(CAC_SPECIAL_GRENADE),4)=="smoke_grenade" && tableLookup("mp/statsTable.csv",0,pstat,4)=="specialty_specialgrenade" ) ) && visArg ); ) \
		CHOICE_DBUTTON_VIS( itemNum, camoName, \
		when( ( stat( pstat ) == 0 || tableLookup("mp/statsTable.csv",0,stat(CAC_SPECIAL_GRENADE),4)=="smoke_grenade" && tableLookup("mp/statsTable.csv",0,pstat,4)=="specialty_specialgrenade" ) && visArg ); ) \
		CHOICE_NEWICON_VIS( itemNum, "specialty_new", when( stat( pstat ) > 1 && visArg ); ) \
		CHOICE_NEWICON_VIS( itemNum, "specialty_locked", when( stat( pstat ) == 0 && visArg ); )

	// hackaround to work for PC's floating mouse unfocusing
	#undef  UI_FOCUSFIRST
	#ifdef PC
		#define UI_FOCUSFIRST "ui_perk_highlighted"
	#else
		#define UI_FOCUSFIRST "ui_fake_focus"
	#endif

	// perk1 selection for primary weapon popup menu
	menuDef	
	{
		IMPROVED_POPUP_SETUP_ONOPEN( CAC_PREFIX"popup_cac_perk1", 7, (CHOICE_X( 4 )-2), (CHOICE_Y( 4 )+18), ;, execnow "set "UI_FOCUSFIRST" "REF_C4_X2"; set ui_inside_popup perk1";, 1 )
		onClose{ execnow "set ui_inside_popup 0"; }
		LOCAL_PERK_INFO_WINDOW( "ui_perk_highlighted" )
		LOCAL_PERK_ITEM( 1, "@PERKS_C4_X_2", STAT_C4_X2, REF_C4_X2, CAC_SPECIALTY_EQUIPMENT, "ui_perk_highlighted", ; )
		LOCAL_PERK_ITEM( 2, "@PERKS_SPECIAL_GRENADES_X_3", STAT_SPECIALGRENADE_X3, REF_SPECIALGRENADE_X3, CAC_SPECIALTY_EQUIPMENT, "ui_perk_highlighted", ; )
		LOCAL_PERK_ITEM( 3, "@PERKS_RPG7_X_2", STAT_RPG_X2, REF_RPG_X2, CAC_SPECIALTY_EQUIPMENT, "ui_perk_highlighted", ; )
		LOCAL_PERK_ITEM( 4, "@PERKS_CLAYMORE_X_2", STAT_CLAYMORE_X2, REF_CLAYMORE_X2, CAC_SPECIALTY_EQUIPMENT, "ui_perk_highlighted", ; )
		LOCAL_PERK_ITEM( 5, "@PERKS_FRAG_X_3", STAT_FRAG_X3, REF_FRAG_X3, CAC_SPECIALTY_EQUIPMENT, "ui_perk_highlighted", ; )
		LOCAL_PERK_ITEM( 6, "@PERKS_BANDOLIER", STAT_EXTRAAMMO, REF_EXTRAAMMO, CAC_SPECIALTY_EQUIPMENT, "ui_perk_highlighted", ; )
		LOCAL_PERK_ITEM( 7, "@PERKS_BOMB_SQUAD", STAT_DETECTEXPLOSIVE, REF_DETECTEXPLOSIVE, CAC_SPECIALTY_EQUIPMENT, "ui_perk_highlighted", ; )
	}
	
	#define LOCAL_RESET_PISTOL \
		execnowondvarstringvalue ui_dual_primaries true "statset "CAC_S_SECONDARY" 0; statset "CAC_S_SECONDARY_ATTACHMENT" 0; set ui_dual_primaries false";\
		execNow "statGetInDvar "CAC_S_SPECIALTY_EQUIPMENT" ui_perk1_slot"; PERK1_RESET1 \
		execNow "statGetInDvar "CAC_S_PRIMARY_ATTACHMENT" ui_primary_attachment_slot"; \
		execNowOnDvarStringValue ui_primary_attachment_slot 4 "statset "CAC_S_SPECIALTY_EQUIPMENT" 193"; \
		execNowOnDvarStringValue ui_primary_attachment_slot 5 "statset "CAC_S_SPECIALTY_EQUIPMENT" 193";
		
	#define LOCAL_INIT_DUAL_PRIMARY_M16 \
		execnow "statset "CAC_S_SECONDARY" 25; statset "CAC_S_SECONDARY_ATTACHMENT" 0; set ui_dual_primaries true";

	#define LOCAL_INIT_DUAL_PRIMARY_AK47 \
		execnow "statset "CAC_S_SECONDARY" 20; statset "CAC_S_SECONDARY_ATTACHMENT" 0; set ui_dual_primaries true";	
		
	// perk2 selection for primary weapon popup menu
	menuDef	
	{
		IMPROVED_POPUP_SETUP_ONOPEN( CAC_PREFIX"popup_cac_perk2", 7, (CHOICE_X( 5 )-2), (CHOICE_Y( 5 )+22), ;, execnow "set "UI_FOCUSFIRST" "REF_BULLETDAMAGE"; set ui_inside_popup perk2";, 1 )
		onClose{ execnow "set ui_inside_popup 0"; }
		LOCAL_PERK_INFO_WINDOW( "ui_perk_highlighted" )
		LOCAL_PERK_ITEM( 1, "@PERKS_STOPPING_POWER", STAT_BULLETDAMAGE, REF_BULLETDAMAGE, CAC_SPECIALTY_WEAPON, "ui_perk_highlighted", LOCAL_RESET_PISTOL )
		LOCAL_PERK_ITEM( 2, "@PERKS_JUGGERNAUT", STAT_ARMORVEST, REF_ARMORVEST, CAC_SPECIALTY_WEAPON, "ui_perk_highlighted", LOCAL_RESET_PISTOL )
		LOCAL_PERK_ITEM( 3, "@PERKS_SLEIGHT_OF_HAND", STAT_FASTRELOAD, REF_FASTRELOAD, CAC_SPECIALTY_WEAPON, "ui_perk_highlighted", LOCAL_RESET_PISTOL )
		LOCAL_PERK_ITEM( 4, "@PERKS_DOUBLE_TAP", STAT_ROF, REF_ROF, CAC_SPECIALTY_WEAPON, "ui_perk_highlighted", LOCAL_RESET_PISTOL )
		/*hacked, init to m16 if not m16*/	LOCAL_PERK_ITEM_VIS( 5, "@PERKS_OVERKILL", STAT_TWOPRIMARIES, REF_TWOPRIMARIES, CAC_SPECIALTY_WEAPON, "ui_perk_highlighted", LOCAL_INIT_DUAL_PRIMARY_M16, (stat(CAC_PRIMARY) != 25) )
		/*hacked, init to ak47 if m16*/		LOCAL_PERK_ITEM_VIS( 5, "@PERKS_OVERKILL", STAT_TWOPRIMARIES, REF_TWOPRIMARIES, CAC_SPECIALTY_WEAPON, "ui_perk_highlighted", LOCAL_INIT_DUAL_PRIMARY_AK47, (stat(CAC_PRIMARY) == 25) )
		LOCAL_PERK_ITEM( 6, "@PERKS_UAV_JAMMER", STAT_GPSJAMMER, REF_GPSJAMMER, CAC_SPECIALTY_WEAPON, "ui_perk_highlighted", LOCAL_RESET_PISTOL )
		LOCAL_PERK_ITEM( 7, "@PERKS_SONIC_BOOM", STAT_EXPLOSIVEDAMAGE, REF_EXPLOSIVEDAMAGE, CAC_SPECIALTY_WEAPON, "ui_perk_highlighted", LOCAL_RESET_PISTOL )
	}
				
	// perk3 selection for primary weapon popup menu
	menuDef	
	{
		IMPROVED_POPUP_SETUP_ONOPEN( CAC_PREFIX"popup_cac_perk3", 8, (CHOICE_X( 6 )-2), (CHOICE_Y( 6 )+26), ;, execnow "set "UI_FOCUSFIRST" "REF_LONGERSPRINT"; set ui_inside_popup perk3";, 1 )
		onClose{ execnow "set ui_inside_popup 0"; }
		LOCAL_PERK_INFO_WINDOW( "ui_perk_highlighted" )
		LOCAL_PERK_ITEM( 1, "@PERKS_EXTREME_CONDITIONING", STAT_LONGERSPRINT, REF_LONGERSPRINT, CAC_SPECIALTY_ABILITY, "ui_perk_highlighted", ; )
		LOCAL_PERK_ITEM( 2, "@PERKS_STEADY_AIM", STAT_BULLETACCURACY, REF_BULLETACCURACY, CAC_SPECIALTY_ABILITY, "ui_perk_highlighted", ; )
		LOCAL_PERK_ITEM( 3, "@PERKS_LAST_STAND", STAT_PISTOLDEATH, REF_PISTOLDEATH, CAC_SPECIALTY_ABILITY, "ui_perk_highlighted", ; )
		LOCAL_PERK_ITEM( 4, "@PERKS_MARTYRDOM", STAT_GRENADEPULLDEATH, REF_GRENADEPULLDEATH, CAC_SPECIALTY_ABILITY, "ui_perk_highlighted", ; )
		LOCAL_PERK_ITEM( 5, "@PERKS_DEEP_IMPACT", STAT_BULLETPENETRATION, REF_BULLETPENETRATION, CAC_SPECIALTY_ABILITY, "ui_perk_highlighted", ; )
		LOCAL_PERK_ITEM( 6, "@PERKS_IRON_LUNGS", STAT_HOLDBREATH, REF_HOLDBREATH, CAC_SPECIALTY_ABILITY, "ui_perk_highlighted", ; )
		LOCAL_PERK_ITEM( 7, "@PERKS_DEAD_SILENCE", STAT_QUIETER, REF_QUIETER, CAC_SPECIALTY_ABILITY, "ui_perk_highlighted", ; )
		LOCAL_PERK_ITEM( 8, "@PERKS_EAVESDROP", STAT_PARABOLIC, REF_PARABOLIC, CAC_SPECIALTY_ABILITY, "ui_perk_highlighted", ; )
	}
	
	// ====================================================================================================
	// reset to default class selection ===================================================================
	// ====================================================================================================
	#define LOCAL_RESET_DEFAULT_ACTION( ptype ) \
			play "mouse_click"; \
			open CAC_PREFIX"popup_cac_defaultclasswarning"ptype; \
			close self

	// reset to default class selection popup menu
	menuDef	
	{
		IMPROVED_POPUP_SETUP_ONOPEN( CAC_PREFIX"popup_cac_template", 5, (CHOICE_X( 8 )-2), (CHOICE_Y( 8 )+44), ;, execnow "set ui_inside_popup perk1";, 1 )
		onClose{ execnow "set ui_inside_popup 0"; }
		
		CHOICE_BUTTON( 1, "@CLASS_DEFAULT_ASSAULT", LOCAL_RESET_DEFAULT_ACTION( "_assault" ) )
		CHOICE_BUTTON( 2, "@CLASS_DEFAULT_SPECOPS", LOCAL_RESET_DEFAULT_ACTION( "_spec_ops" ) )
		CHOICE_BUTTON( 3, "@CLASS_DEFAULT_HEAVYGUNNER", LOCAL_RESET_DEFAULT_ACTION( "_heavy_gunner" ) )
		CHOICE_BUTTON( 4, "@CLASS_DEFAULT_DEMOLITIONS", LOCAL_RESET_DEFAULT_ACTION( "_demolitions" ) )
		CHOICE_BUTTON( 5, "@CLASS_DEFAULT_SNIPER", LOCAL_RESET_DEFAULT_ACTION( "_sniper" ) )
	}

	// ====================================================================================================
	// reset to default class confirmation ================================================================
	// ====================================================================================================

	#define LOCAL_ACCEPT_ACTION( pclass, pclass_s, p1, p2, p3, p4, p5, p6, p7, p8, p9 )									\
		execnow "setFromLocString "CAC_CUSTOM_NAME" "pclass;																			\
		statsetusingtable( CAC_S_PRIMARY, tablelookup( "mp/classTable.csv", 1, p1, 5 ) );								\
		statsetusingtable( CAC_S_PRIMARY_ATTACHMENT, tablelookup( "mp/classTable.csv", 1, p2, 5 ) );					\
		statsetusingtable( CAC_S_SECONDARY, tablelookup( "mp/classTable.csv", 1, p3, 5 ) );								\
		statsetusingtable( CAC_S_SECONDARY_ATTACHMENT, tablelookup( "mp/classTable.csv", 1, p4, 5 ) );					\
		statsetusingtable( CAC_S_SPECIALTY_EQUIPMENT, tablelookup( "mp/classTable.csv", 1, p5, 5 ) );					\
		statsetusingtable( CAC_S_SPECIALTY_WEAPON, tablelookup( "mp/classTable.csv", 1, p6, 5 ) );						\
		statsetusingtable( CAC_S_SPECIALTY_ABILITY, tablelookup( "mp/classTable.csv", 1, p7, 5 ) );						\
		statsetusingtable( CAC_S_SPECIAL_GRENADE, tablelookup( "mp/classTable.csv", 1, p8, 5 ) );						\
		statsetusingtable( CAC_S_CAMO, tablelookup( "mp/classTable.csv", 1, p9, 5 ) );									\
		execNow "updategamerprofile";																					\
		/*execNow "ui_keyboard MENU_CUSTOMCLASS_KEYBOARD "CAC_CUSTOM_NAME;*/											\
		play "mouse_click";																								\
		close CAC_PREFIX"popup_cac_defaultclasswarning"pclass_s;														\
		close CAC_PREFIX"popup_cac_template"; 																			
			
	#define LOCAL_CANCEL_ACTION( pclass, pclass_s, p1, p2, p3, p4, p5, p6, p7, p8, p9 )									\
		play "mouse_click"; 																							\
		close CAC_PREFIX"popup_cac_defaultclasswarning"pclass_s; 	

	// reset to default class confirmation popup menu
	#define RESET_WARNING_POPUP( pclass, pclass_s, p1, p2, p3, p4, p5, p6, p7, p8, p9 ) 								\
	menuDef																												\
	{																													\
		IMPROVED_POPUP_SETUP_ONOPEN( CAC_PREFIX"popup_cac_defaultclasswarning"pclass_s, 5, (CHOICE_X( 8 )-2), (CHOICE_Y( 8 )+44), ;, setfocus choice_no, 1 )\
		PREPROC_TEXT_DRAW_ALIGNED_EXP( 4 2 (CHOICE_POPUP_WIDTH-8) 100 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, \
		"@MENU_CUSTOM_CLASS_RESET_WARNING", TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_TOP_LEFT, CHOICE_TEXTCOLOR ) \
		CHOICE_BUTTON( 4, "@MPUI_YES", LOCAL_ACCEPT_ACTION( pclass, pclass_s, p1, p2, p3, p4, p5, p6, p7, p8, p9 ) )			\
		CHOICE_BUTTON_EX( 5, "@MPUI_NO", LOCAL_CANCEL_ACTION( pclass, pclass_s, p1, p2, p3, p4, p5, p6, p7, p8, p9 ), name choice_no )			\
	}

	RESET_WARNING_POPUP( "@CLASS_CUSTOM1", "_assault", 201, 202, 203, 204, 205, 206, 207, 208, 209 )
	RESET_WARNING_POPUP( "@CLASS_CUSTOM2", "_spec_ops", 211, 212, 213, 214, 215, 216, 217, 218, 219 )
	RESET_WARNING_POPUP( "@CLASS_CUSTOM3", "_heavy_gunner", 221, 222, 223, 224, 225, 226, 227, 228, 229 )
	RESET_WARNING_POPUP( "@CLASS_CUSTOM4", "_demolitions", 231, 232, 233, 234, 235, 236, 237, 238, 239 )
	RESET_WARNING_POPUP( "@CLASS_CUSTOM5", "_sniper", 241, 242, 243, 244, 245, 246, 247, 248, 249 )

	#undef CHOICE_SIZE_X
	#define CHOICE_SIZE_X			280
	
	#undef CHOICE_HORIZONTAL_ALIGN
	#define CHOICE_HORIZONTAL_ALIGN	HORIZONTAL_ALIGN_CENTER
	#undef CHOICE_VERTICAL_ALIGN
	#define CHOICE_VERTICAL_ALIGN	VERTICAL_ALIGN_CENTER
	
	#define SIDE_MARGIN		40
	
	menuDef
	{
		CENTER_POPUP_SETUP_ONOPEN( CAC_PREFIX"pc_rename", 4, ;, setfocus renameEntry, 1 )
		CHOICE_POPMENU_TITLE( "@MPUI_RENAME_CLASS" )
		itemDef {
			name			renameEntry
			group			grpControls
			TYPE			4
			text			" "
			dvar			CAC_CUSTOM_NAME
			rect			CHOICE_ORIGIN( 3 ) (CHOICE_SIZE_X-(SIDE_MARGIN*2)) 16
			origin			SIDE_MARGIN -8
			textalignx		-4
			textaligny		0
			maxchars		15
			maxpaintchars	15
			textalign		ITEM_ALIGN_MIDDLE_LEFT
			textfont		UI_FONT_NORMAL
			textscale		TEXTSIZE_SMALL
			forecolor		.9 .9 .9 1
			style			WINDOW_STYLE_FILLED
			backcolor		0 0 0 .3
			visible			1
			mouseenter		{ show keyBindStatus; play "mouse_over"; }
			mouseexit		{ hide keyBindStatus; setfocus ok_button; }
			accept			{ close self; }
		}
		CHOICE_BUTTON_EX( 4, "@MENU_OK", close self;, name ok_button mouseenter	{ setfocus ok_button; } )
	}

