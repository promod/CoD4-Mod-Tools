// control settings

#define LOCALIZATION_FILE	"@MENU"

#ifdef SINGLE_PLAYER
#undef	LOCALIZATION_FILE
#define LOCALIZATION_FILE	"@MENU"
#endif

#undef CONTROL_MENU_NAME
#define CONTROL_MENU_NAME "controls"

#undef CONTROL_THUMBSTICK_NAME
#define CONTROL_THUMBSTICK_NAME "thumbstick"

#undef CONTROL_BUTTONS_NAME
#define CONTROL_BUTTONS_NAME "buttons"

#undef CONTROL_SENSITIVITY_NAME
#define CONTROL_SENSITIVITY_NAME "sensitivity"

#undef CONTROL_SENSITIVITY_CUSTOM_NAME
#define CONTROL_SENSITIVITY_CUSTOM_NAME "sensitivity_custom"

#undef CONTROL_BRIGHTNESS_NAME
#define CONTROL_BRIGHTNESS_NAME "brightness"

#define BG_SHADE_COLOR	0 0 0 0.75

#ifdef	CONTROL_IN_GAME
	#undef CONTROL_MENU_NAME
	#define CONTROL_MENU_NAME "ingame_controls"
	
	#undef CONTROL_THUMBSTICK_NAME
	#define CONTROL_THUMBSTICK_NAME "ingamecontrols_thumbstick"
	
	#undef CONTROL_BUTTONS_NAME
	#define CONTROL_BUTTONS_NAME "ingamecontrols_buttons"
	
	#undef CONTROL_SENSITIVITY_NAME
	#define CONTROL_SENSITIVITY_NAME "ingamecontrols_sensitivity"

	#undef CONTROL_SENSITIVITY_CUSTOM_NAME
	#define CONTROL_SENSITIVITY_CUSTOM_NAME "ingamecontrols_sensitivity_custom"

	#undef CONTROL_BRIGHTNESS_NAME
	#define CONTROL_BRIGHTNESS_NAME "ingamecontrols_brightness"
	
	#undef BG_SHADE_COLOR
	#define BG_SHADE_COLOR	0 0 0 0.75
#endif

#ifdef	CONTROL_IN_GAME_SPLITSCREEN
	#undef CONTROL_MENU_NAME
	#define CONTROL_MENU_NAME "ingame_controls_splitscreen"
	
	#undef CONTROL_THUMBSTICK_NAME
	#define CONTROL_THUMBSTICK_NAME "ingamecontrols_thumbstick_splitscreen"
	
	#undef CONTROL_BUTTONS_NAME
	#define CONTROL_BUTTONS_NAME "ingamecontrols_buttons_splitscreen"
	
	#undef CONTROL_SENSITIVITY_NAME
	#define CONTROL_SENSITIVITY_NAME "ingamecontrols_sensitivity_splitscreen"

	#undef CONTROL_SENSITIVITY_CUSTOM_NAME
	#define CONTROL_SENSITIVITY_CUSTOM_NAME "ingamecontrols_sensitivity_splitscreen_custom"
	
	#undef CONTROL_BRIGHTNESS_NAME
	#define CONTROL_BRIGHTNESS_NAME "ingamecontrols_brightness_splitscreen"

	#undef BG_SHADE_COLOR
	#define BG_SHADE_COLOR	0 0 0 0.85
#endif

#ifdef PS3
	// ps3 voice volume control ==================
	#define LOCAL_VOICE_METER_RAW( dvar1, dvar2 )\
			execOnDvarFloatValue ps3_voiceSpeakerGain dvar1 "set ps3_voiceSpeakerGain "dvar2;
			
	#define LOCAL_VOICE_METER_1 \
			LOCAL_VOICE_METER_RAW( 1.2, "1.5" )\
			LOCAL_VOICE_METER_RAW( 1.5, "2.0" )\
			LOCAL_VOICE_METER_RAW( 2.0, "2.5" )\
			LOCAL_VOICE_METER_RAW( 2.5, "3.0" )\
			LOCAL_VOICE_METER_RAW( 3.0, "3.5" )\
			LOCAL_VOICE_METER_RAW( 3.5, "4.0" )\
			LOCAL_VOICE_METER_RAW( 4.0, "4.5" )\
			LOCAL_VOICE_METER_RAW( 4.5, "5.0" )\
			LOCAL_VOICE_METER_RAW( 5.0, "6.0" )\
			LOCAL_VOICE_METER_RAW( 6.0, "7.0" )\
			LOCAL_VOICE_METER_RAW( 7.0, "8.0" )\
			LOCAL_VOICE_METER_RAW( 8.0, "9.0" )\
			LOCAL_VOICE_METER_RAW( 9.0, "10.0")
			
	#define LOCAL_VOICE_METER_2 \
			LOCAL_VOICE_METER_RAW( 10.0, "9.0")\
			LOCAL_VOICE_METER_RAW( 9.0, "8.0" )\
			LOCAL_VOICE_METER_RAW( 8.0, "7.0" )\
			LOCAL_VOICE_METER_RAW( 7.0, "6.0" )\
			LOCAL_VOICE_METER_RAW( 6.0, "5.0" )\
			LOCAL_VOICE_METER_RAW( 5.0, "4.5" )\
			LOCAL_VOICE_METER_RAW( 4.5, "4.0" )\
			LOCAL_VOICE_METER_RAW( 4.0, "3.5" )\
			LOCAL_VOICE_METER_RAW( 3.5, "3.0" )\
			LOCAL_VOICE_METER_RAW( 3.0, "2.5" )\
			LOCAL_VOICE_METER_RAW( 2.5, "2.0" )\
			LOCAL_VOICE_METER_RAW( 2.0, "1.5" )\
			LOCAL_VOICE_METER_RAW( 1.5, "1.2" )
			
	#define LOCAL_VOICE_EXTRA \
		execKeyInt DPAD_RIGHT { LOCAL_VOICE_METER_1 }\
		execKeyInt APAD_RIGHT { LOCAL_VOICE_METER_1 }\
		execKeyInt DPAD_LEFT { LOCAL_VOICE_METER_2 }\
		execKeyInt APAD_LEFT { LOCAL_VOICE_METER_2 }
#endif

#define LOCAL_BG \
itemDef	{\
	style			WINDOW_STYLE_FILLED\
	rect			0 0 640 480 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN\
	backcolor		BG_SHADE_COLOR\
	visible			1	decoration}\
itemDef	{\
	style			WINDOW_STYLE_SHADER\
	rect			0 0 854 75 HORIZONTAL_ALIGN_FULLSCREEN 0\
	background		"gradient_top"\
	visible			1	decoration}\
itemDef	{\
	style			WINDOW_STYLE_SHADER\
	rect			0 400 854 75 HORIZONTAL_ALIGN_FULLSCREEN 0\
	background		"gradient_bottom"\
	visible			1	decoration}


menuDef
{
	name			CONTROL_MENU_NAME

#ifndef CONTROL_IN_GAME
	fullScreen		1
	rect			0 0 640 480
	focusColor		COLOR_FOCUSED
	soundloop 		"music_mainmenu_mp"
	onOpen	{/*exec "Updatedvarsfromprofile";*/ /*exec "select_save_device";*/ }
	onClose {;}
	onESC	{/*exec "splitscreencontrols";*/	close CONTROL_MENU_NAME; exec "updategamerprofile";
#endif

#ifdef	CONTROL_IN_GAME	
	rect			0 0 640 480
	focuscolor		COLOR_FOCUSED
	style			WINDOW_STYLE_EMPTY
	blurWorld		7.0
	legacySplitScreenScale
	onOpen 	{ /*exec "Updatedvarsfromprofile";*/ setdvar cg_drawhud "0";setDvar ui_allow_controlschange "0";}
	onclose	{setdvar cg_drawhud "1";setDvar ui_allow_controlschange "1";}
	execkeyint BUTTON_START{close self;exec "updategamerprofile";}
	onEsc 	{setdvar cg_drawhud "1";scriptMenuResponse "back";exec "updategamerprofile";
#endif
	
#ifdef SINGLE_PLAYER
	#ifdef CONTROL_IN_GAME
		close self; open "pausedmenu";
	#endif
#endif

	}
	
#ifdef	CONTROL_IN_GAME	
	LOCAL_BG
#else
	#include "ui/bg.inc"
#endif

	// ------------------ TREE TITLE ------------------
	#ifdef	CONTROL_IN_GAME_SPLITSCREEN
		CHOICE_MENU_TITLE_SS( "@MENU_OPTIONS_UPPER_CASE" )
	#else
		#ifdef SINGLE_PLAYER
			CHOICE_MENU_TITLE( "@MENU_CONTROLS_CAP" )
		#else
			CHOICE_MENU_TITLE( "@MENU_OPTIONS_UPPER_CASE" )
		#endif
	#endif
	// ------------------ buttons ---------------------
	#include "ui_mp/navcontrols.inc"

// MENU CHOICES
	CHOICE_BUTTON( 1, LOCALIZATION_FILE"_THUMBSTICK_LAYOUT", close CONTROL_MENU_NAME; open CONTROL_THUMBSTICK_NAME; )	
	CHOICE_BUTTON( 2, LOCALIZATION_FILE"_BUTTON_LAYOUT", close CONTROL_MENU_NAME; open CONTROL_BUTTONS_NAME; )	
	CHOICE_BUTTON( 3, LOCALIZATION_FILE"_LOOK_SENSITIVITY", close CONTROL_MENU_NAME; open CONTROL_SENSITIVITY_NAME; )	
	CHOICE_BUTTON( 4, LOCALIZATION_FILE"_LOOK_INVERSION", exec "toggle input_invertpitch"; )	

	CHOICE_LEFTITEM_VIS( 1, "@MENU_DEFAULT", CHOICE_TEXTCOLOR, when( dvarString( "gpad_sticksConfig" ) == "thumbstick_default" ) )
	CHOICE_LEFTITEM_VIS( 1, "@MENU_SOUTHPAW", CHOICE_TEXTCOLOR, when( dvarString( "gpad_sticksConfig" ) == "thumbstick_southpaw" ) )
	CHOICE_LEFTITEM_VIS( 1, "@MENU_LEGACY", CHOICE_TEXTCOLOR, when( dvarString( "gpad_sticksConfig" ) == "thumbstick_legacy" ) )
	CHOICE_LEFTITEM_VIS( 1, "@MENU_LEGACY_SOUTHPAW", CHOICE_TEXTCOLOR, when( dvarString( "gpad_sticksConfig" ) == "thumbstick_legacysouthpaw" ) )

	CHOICE_LEFTITEM_VIS( 2, "@MENU_DEFAULT", CHOICE_TEXTCOLOR, when( dvarString( "gpad_buttonsConfig" ) == "buttons_default" ) )
	CHOICE_LEFTITEM_VIS( 2, "@MENU_TACTICAL", CHOICE_TEXTCOLOR, when( dvarString( "gpad_buttonsConfig" ) == "buttons_experimental" ) )
	CHOICE_LEFTITEM_VIS( 2, "@MENU_LEFTY", CHOICE_TEXTCOLOR, when( dvarString( "gpad_buttonsConfig" ) == "buttons_lefty" ) )
	#ifdef PS3
	CHOICE_LEFTITEM_VIS( 2, "@MENU_DEFAULT_ALT", CHOICE_TEXTCOLOR, when( dvarString( "gpad_buttonsConfig" ) == "buttons_default_alt" ) )
	CHOICE_LEFTITEM_VIS( 2, "@MENU_TACTICAL_ALT", CHOICE_TEXTCOLOR, when( dvarString( "gpad_buttonsConfig" ) == "buttons_experimental_alt" ) )
	CHOICE_LEFTITEM_VIS( 2, "@MENU_LEFTY_ALT", CHOICE_TEXTCOLOR, when( dvarString( "gpad_buttonsConfig" ) == "buttons_lefty_alt" ) )
	#endif

	#define SENSITIVITY_1	0.6	//(Low)
	#define SENSITIVITY_2	1	//(Medium)
	#define SENSITIVITY_3	1.4
	#define SENSITIVITY_4	1.8	//(High)
	#define SENSITIVITY_5	2.0
	#define SENSITIVITY_6	2.2
	#define SENSITIVITY_7	2.6 //(Very High)
	#define SENSITIVITY_8	3.0
	#define SENSITIVITY_9	3.5
	#define SENSITIVITY_10	4.0 //(Insane)
	#define SENSITIVITY_1_S	"0.6"	//(Low)
	#define SENSITIVITY_2_S	"1"	//(Medium)
	#define SENSITIVITY_3_S	"1.4"
	#define SENSITIVITY_4_S	"1.8"	//(High)
	#define SENSITIVITY_5_S	"2.0"
	#define SENSITIVITY_6_S	"2.2"
	#define SENSITIVITY_7_S	"2.6" //(Very High)
	#define SENSITIVITY_8_S	"3.0"
	#define SENSITIVITY_9_S	"3.5"
	#define SENSITIVITY_10_S	"4.0" //(Insane)	

	CHOICE_LEFTITEM_VIS( 3, "@MENU_LOW", CHOICE_TEXTCOLOR, when( dvarFloat( "input_viewSensitivity" ) == SENSITIVITY_1 ) )
	CHOICE_LEFTITEM_VIS( 3, "@MENU_MEDIUM", CHOICE_TEXTCOLOR, when( dvarFloat( "input_viewSensitivity" ) == SENSITIVITY_2 ) )
	CHOICE_LEFTITEM_VIS( 3, "@MENU_HIGH", CHOICE_TEXTCOLOR, when( dvarFloat( "input_viewSensitivity" ) == SENSITIVITY_4 ) )
	CHOICE_LEFTITEM_VIS( 3, "@MENU_CUSTOM", CHOICE_TEXTCOLOR, when( dvarFloat( "input_viewSensitivity" ) != SENSITIVITY_1 && dvarFloat( "input_viewSensitivity" ) != SENSITIVITY_2 && dvarFloat( "input_viewSensitivity" ) != SENSITIVITY_4 ) )

	CHOICE_LEFTITEM_VIS( 4, "@MENU_DISABLED", CHOICE_TEXTCOLOR, when( dvarString( "input_invertpitch" ) == "0" ) )
	CHOICE_LEFTITEM_VIS( 4, "@MENU_ENABLED", CHOICE_TEXTCOLOR, when( dvarString( "input_invertpitch" ) == "1" ) )

#ifndef PS3
	CHOICE_BUTTON( 5, LOCALIZATION_FILE"_CONTROLLER_VIBRATION", exec "toggle gpad_rumble"; )			
	CHOICE_LEFTITEM_VIS( 5, "@MENU_DISABLED", CHOICE_TEXTCOLOR, when( dvarString( "gpad_rumble" ) == "0" ) )
	CHOICE_LEFTITEM_VIS( 5, "@MENU_ENABLED", CHOICE_TEXTCOLOR, when( dvarString( "gpad_rumble" ) == "1" ) )
#else
	#ifndef SINGLE_PLAYER
		#undef A_BUTTON_OFFSET_X
		#define A_BUTTON_OFFSET_X 100000
		CHOICE_DVARSLIDER_VIS_EX( 5, "@MENU_VOICE_VOLUME", ps3_voiceSpeakerGain, 2.5, 1.0, 10.0, ;, LOCAL_VOICE_EXTRA, 1 )
	#endif
#endif

#undef A_BUTTON_OFFSET_X
#define A_BUTTON_OFFSET_X 100000

#ifndef CONTROL_IN_GAME_SPLITSCREEN
	CHOICE_DVARSLIDER( 6, "@MENU_VOLUME", snd_volume, 0.8, 0.0, 1.0, ; )	
#endif

#undef A_BUTTON_OFFSET_X
#define A_BUTTON_OFFSET_X (0-4)

#ifndef CONTROL_IN_GAME_SPLITSCREEN
	#ifndef SINGLE_PLAYER
		#ifdef PS3
			#ifdef CONTROL_IN_GAME
				CHOICE_BUTTON( 7, "@MENU_BRIGHTNESS", close CONTROL_MENU_NAME; open CONTROL_BRIGHTNESS_NAME; )
			#endif
		#else
			#ifdef CONTROL_IN_GAME
				CHOICE_BUTTON( 7, "@MENU_BRIGHTNESS", close CONTROL_MENU_NAME; open CONTROL_BRIGHTNESS_NAME; )
			#else
				CHOICE_BUTTON_VIS( 7, "@MENU_BRIGHTNESS", close CONTROL_MENU_NAME; open CONTROL_BRIGHTNESS_NAME;, when( dvarBool( hiDef) ) )
			#endif
		#endif
	#endif
#endif
	
	#include "ui/safearea.menu"
}

// THUMBSTICK LAYOUT MENU
menuDef 
{
	name			CONTROL_THUMBSTICK_NAME
#ifdef	CONTROL_IN_GAME	
	rect			0 0 640 480
	focuscolor		COLOR_FOCUSED
	style			WINDOW_STYLE_EMPTY
	blurWorld		6.0
	legacySplitScreenScale
	onOpen 			{ setdvar cg_drawhud "0"; }	
	onClose			{ setdvar cg_drawhud "1"; }
	execkeyint BUTTON_START{close self;exec "updategamerprofile";}
	onEsc 			{ close CONTROL_THUMBSTICK_NAME; open CONTROL_MENU_NAME; }
	LOCAL_BG
#else
	rect			0 0 640 480
	focuscolor		COLOR_FOCUSED
	soundloop 		"music_mainmenu_mp"
	style			WINDOW_STYLE_EMPTY
	legacySplitScreenScale
	onClose			{ ; }
	onEsc 			{ close CONTROL_THUMBSTICK_NAME; open CONTROL_MENU_NAME; }
	#include 		"ui/bg.inc"
#endif

	// ------------------ TREE TITLE ------------------
	#ifdef	CONTROL_IN_GAME_SPLITSCREEN
		CHOICE_MENU_TITLE_SS( "@MENU_STICK_LAYOUT_CAP" )
	#else
		CHOICE_MENU_TITLE( "@MENU_STICK_LAYOUT_CAP" )
	#endif
	// ------------------ buttons ---------------------
	#undef	LOCAL_NOT_IN_CAC
	#undef	LOCAL_IN_CAC
	#include "ui_mp/navcontrols.inc"
	
	#define SETUP_ACTION( pconfig ) \
		setDvar gpad_sticksConfig pconfig \
		close CONTROL_THUMBSTICK_NAME; \
		open CONTROL_MENU_NAME;

#ifndef	CONTROL_IN_GAME_SPLITSCREEN

	#include "ui/controls_thumbstick_set.menu"
	
	#define SETUP_FOCUS( pnum ) \
		show "controls_thumbstick_set"pnum;
	
	#define SETUP_UNFOCUS( pnum ) \
		hide "controls_thumbstick_set"pnum;
#else
	#define SETUP_FOCUS( pnum ) ;
	#define SETUP_UNFOCUS( pnum ) ;
#endif
	
	CHOICE_BUTTON_FOCUS( 1, "@MENU_DEFAULT", SETUP_ACTION( "thumbstick_default" ), SETUP_FOCUS( "1" ), SETUP_UNFOCUS( "1" ) )
	CHOICE_BUTTON_FOCUS( 2, "@MENU_SOUTHPAW", SETUP_ACTION( "thumbstick_southpaw" ), SETUP_FOCUS( "2" ), SETUP_UNFOCUS( "2" ) )
	CHOICE_BUTTON_FOCUS( 3, "@MENU_LEGACY", SETUP_ACTION( "thumbstick_legacy" ), SETUP_FOCUS( "3" ), SETUP_UNFOCUS( "3" ) )
	CHOICE_BUTTON_FOCUS( 4, "@MENU_LEGACY_SOUTHPAW", SETUP_ACTION( "thumbstick_legacysouthpaw" ), SETUP_FOCUS( "4" ), SETUP_UNFOCUS( "4" ) )

	#include "ui/safearea.menu"
}

// BUTTON LAYOUT MENU
menuDef 
{
	name			CONTROL_BUTTONS_NAME
#ifdef	CONTROL_IN_GAME	
	rect			0 0 640 480
	focuscolor		COLOR_FOCUSED
	style			WINDOW_STYLE_EMPTY
	blurWorld		6.0
	legacySplitScreenScale
	onOpen 	{setdvar cg_drawhud "0";}	
	onClose	{setdvar cg_drawhud "1";}
	execkeyint BUTTON_START{close self;exec "updategamerprofile";}
	onEsc 	{close CONTROL_BUTTONS_NAME;open CONTROL_MENU_NAME;}
	LOCAL_BG
#else
	rect			0 0 640 480
	focuscolor		COLOR_FOCUSED
	soundloop 		"music_mainmenu_mp"
	style			WINDOW_STYLE_EMPTY
	legacySplitScreenScale
	onClose	{;}
	onEsc 	{close CONTROL_BUTTONS_NAME;open CONTROL_MENU_NAME;}
	#include "ui/bg.inc"
#endif

	// ------------------ TREE TITLE ------------------
	#ifdef	CONTROL_IN_GAME_SPLITSCREEN
		CHOICE_MENU_TITLE_SS( "@MENU_BUTTON_LAYOUT_CAP" )
	#else
		CHOICE_MENU_TITLE( "@MENU_BUTTON_LAYOUT_CAP" )
	#endif
	// ------------------ buttons ---------------------
	#undef	LOCAL_NOT_IN_CAC
	#undef	LOCAL_IN_CAC
	#include "ui_mp/navcontrols.inc"
	
	#define SETUP_ACTION2( pconfig ) \
		setDvar gpad_buttonsConfig pconfig \
		close CONTROL_BUTTONS_NAME; \
		open CONTROL_MENU_NAME;
		
#ifndef	CONTROL_IN_GAME_SPLITSCREEN

	#include "ui_mp/controls_buttons_set.menu"

	#define SETUP_FOCUS2( pnum ) \
		show "controls_buttons_set"pnum;
	
	#define SETUP_UNFOCUS2( pnum ) \
		hide "controls_buttons_set"pnum;
#else
	#define SETUP_FOCUS2( pnum ) ;
	#define SETUP_UNFOCUS2( pnum ) ;
#endif

	CHOICE_BUTTON_FOCUS( 1, "@MENU_DEFAULT", SETUP_ACTION2( "buttons_default" ), SETUP_FOCUS2( "1" ), SETUP_UNFOCUS2( "1" ) )
	CHOICE_BUTTON_FOCUS( 2, "@MENU_TACTICAL", SETUP_ACTION2( "buttons_experimental" ), SETUP_FOCUS2( "2" ), SETUP_UNFOCUS2( "2" ) )
	CHOICE_BUTTON_FOCUS( 3, "@MENU_LEFTY", SETUP_ACTION2( "buttons_lefty" ), SETUP_FOCUS2( "3" ), SETUP_UNFOCUS2( "3" ) )
	#ifdef PS3
	CHOICE_BUTTON_FOCUS( 4, "@MENU_DEFAULT_ALT", SETUP_ACTION2( "buttons_default_alt" ), SETUP_FOCUS2( "4" ), SETUP_UNFOCUS2( "4" ) )
	CHOICE_BUTTON_FOCUS( 5, "@MENU_TACTICAL_ALT", SETUP_ACTION2( "buttons_experimental_alt" ), SETUP_FOCUS2( "5" ), SETUP_UNFOCUS2( "5" ) )
	CHOICE_BUTTON_FOCUS( 6, "@MENU_LEFTY_ALT", SETUP_ACTION2( "buttons_lefty_alt" ), SETUP_FOCUS2( "6" ), SETUP_UNFOCUS2( "6" ) )
	#endif

	#include "ui/safearea.menu"
}

// LOOK SENSITIVITY MENU
menuDef 
{
	name			CONTROL_SENSITIVITY_NAME
#ifdef	CONTROL_IN_GAME	
	rect			0 0 640 480
	focuscolor		COLOR_FOCUSED
	style			WINDOW_STYLE_EMPTY
	blurWorld		6.0
	legacySplitScreenScale
	onClose	{setdvar cg_drawhud "1";}
	execkeyint BUTTON_START{close self;exec "updategamerprofile";}
	onOpen 	{setfocus "sensitivity_medium";setfocusbydvar "input_viewSensitivity";setdvar cg_drawhud "0";}
	onEsc {	close CONTROL_SENSITIVITY_NAME;	open CONTROL_MENU_NAME;}
	LOCAL_BG
#else
	rect			0 0 640 480
	focuscolor		COLOR_FOCUSED
	soundloop 		"music_mainmenu_mp"
	style			WINDOW_STYLE_EMPTY
	legacySplitScreenScale
	onOpen 	{setfocus "sensitivity_custom";setfocusbydvar "input_viewSensitivity";}
	onClose	{;}
	onEsc {	close CONTROL_SENSITIVITY_NAME;	open CONTROL_MENU_NAME;}
	#include "ui/bg.inc"
#endif
	
	// ------------------ TREE TITLE ------------------
	#ifdef	CONTROL_IN_GAME_SPLITSCREEN
		CHOICE_MENU_TITLE_SS( "@MENU_SENSITIVITY_CAP" )
	#else
		CHOICE_MENU_TITLE( "@MENU_SENSITIVITY_CAP" )
	#endif
	// ------------------ buttons ---------------------
	#undef	LOCAL_NOT_IN_CAC
	#undef	LOCAL_IN_CAC
	#include "ui_mp/navcontrols.inc"

	#define SETUP_ACTION3( pconfig ) \
		exec pconfig \
		close CONTROL_SENSITIVITY_NAME; \
		open CONTROL_MENU_NAME;

	#define SETUP_EXTRA( pnum ) \
		dvartest "input_viewSensitivity" focusdvar { pnum }

	//CHOICE_BUTTON_FOCUS_VIS_EX( 1, "@MENU_LOW", actionArg, onFocusArg, leaveFocusArg, visArg, extraArgs )	
	
	CHOICE_BUTTON_FOCUS_VIS_EX( 1, "@MENU_LOW", SETUP_ACTION3( "exec viewSensitivity_low" ), ;, ;, when( 1 ), SETUP_EXTRA( SENSITIVITY_1_S ) )
	CHOICE_BUTTON_FOCUS_VIS_EX( 2, "@MENU_MEDIUM", SETUP_ACTION3( "exec viewSensitivity_med" ), ;, ;, when( 1 ), SETUP_EXTRA( SENSITIVITY_2_S ) )
	CHOICE_BUTTON_FOCUS_VIS_EX( 3, "@MENU_HIGH", SETUP_ACTION3( "exec viewSensitivity_high" ), ;, ;, when( 1 ), SETUP_EXTRA( SENSITIVITY_4_S ) )
	CHOICE_BUTTON_FOCUS_VIS_EX( 4, "@MENU_CUSTOM", close CONTROL_SENSITIVITY_NAME; open CONTROL_SENSITIVITY_CUSTOM_NAME, ;, ;, when( 1 ), name sensitivity_custom; )	

	#include "ui/safearea.menu"
}



// CUSTOM LOOK SENSITIVITY MENU
menuDef 
{
	name			CONTROL_SENSITIVITY_CUSTOM_NAME
#ifdef	CONTROL_IN_GAME	
	rect			0 0 640 480
	focuscolor		COLOR_FOCUSED
	style			WINDOW_STYLE_EMPTY
	blurWorld		6.0
	legacySplitScreenScale
	onClose	{setdvar cg_drawhud "1";}
	execkeyint BUTTON_START{close self;exec "updategamerprofile";}
	onOpen 	{setfocus "sensitivity_medium";setfocusbydvar "input_viewSensitivity";setdvar cg_drawhud "0";}
	onEsc {	close CONTROL_SENSITIVITY_CUSTOM_NAME;	open CONTROL_SENSITIVITY_NAME;}
	LOCAL_BG
#else
	rect			0 0 640 480
	focuscolor		COLOR_FOCUSED
	soundloop 		"music_mainmenu_mp"
	style			WINDOW_STYLE_EMPTY
	legacySplitScreenScale
	onOpen 	{setfocus "sensitivity_medium";setfocusbydvar "input_viewSensitivity";}
	onClose	{;}
	onEsc {	close CONTROL_SENSITIVITY_CUSTOM_NAME;	open CONTROL_SENSITIVITY_NAME;}
	#include "ui/bg.inc"
#endif
	
	// ------------------ TREE TITLE ------------------
	#ifdef	CONTROL_IN_GAME_SPLITSCREEN
		CHOICE_MENU_TITLE_SS( "@MENU_SENSITIVITY_CUSTOM_CAP" )
	#else
		CHOICE_MENU_TITLE( "@MENU_SENSITIVITY_CUSTOM_CAP" )
	#endif
	// ------------------ buttons ---------------------
	#undef	LOCAL_NOT_IN_CAC
	#undef	LOCAL_IN_CAC
	#include "ui_mp/navcontrols.inc"

	#define SETUP_CUSTOM_ACTION( pval ) \
		setDvar input_viewSensitivity pval; \
		close CONTROL_SENSITIVITY_CUSTOM_NAME; \
		open CONTROL_MENU_NAME;

	#define SETUP_CUSTOM_EXTRA( pnum ) \
		dvartest "input_viewSensitivity" focusdvar { pnum }

	//CHOICE_BUTTON_FOCUS_VIS_EX( 1, "@MENU_LOW", actionArg, onFocusArg, leaveFocusArg, visArg, extraArgs )	
	
	#undef CHOICE_TEXTSIZE
	#define CHOICE_TEXTSIZE			TEXTSIZE_SMALL

	#undef CHOICE_SIZE_Y
	#define CHOICE_SIZE_Y			18
		
	#undef A_BUTTON_SIZE
	#define A_BUTTON_SIZE			0.3
		
	#undef CHOICE_Y_SPACING
	#define CHOICE_Y_SPACING		(CHOICE_SIZE_Y+2)

	CHOICE_BUTTON_FOCUS_VIS_EX( 1, locString( "@MENU_SENSITIVITY_LOW_N", 1 ), SETUP_CUSTOM_ACTION( SENSITIVITY_1 ), ;, ;, when( 1 ), SETUP_CUSTOM_EXTRA( SENSITIVITY_1_S ) )
	CHOICE_BUTTON_FOCUS_VIS_EX( 2, locString( "@MENU_SENSITIVITY_MEDIUM_N", 2 ), SETUP_CUSTOM_ACTION( SENSITIVITY_2 ), ;, ;, when( 1 ), SETUP_CUSTOM_EXTRA( SENSITIVITY_2_S ) )
	CHOICE_BUTTON_FOCUS_VIS_EX( 3, 3, SETUP_CUSTOM_ACTION( SENSITIVITY_3 ), ;, ;, when( 1 ), SETUP_CUSTOM_EXTRA( SENSITIVITY_3_S ) )
	CHOICE_BUTTON_FOCUS_VIS_EX( 4, locString( "@MENU_SENSITIVITY_HIGH_N", 4 ), SETUP_CUSTOM_ACTION( SENSITIVITY_4 ), ;, ;, when( 1 ), SETUP_CUSTOM_EXTRA( SENSITIVITY_4_S ) )
	CHOICE_BUTTON_FOCUS_VIS_EX( 5, 5, SETUP_CUSTOM_ACTION( SENSITIVITY_5 ), ;, ;, when( 1 ), SETUP_CUSTOM_EXTRA( SENSITIVITY_5_S ) )
	CHOICE_BUTTON_FOCUS_VIS_EX( 6, 6, SETUP_CUSTOM_ACTION( SENSITIVITY_6 ), ;, ;, when( 1 ), SETUP_CUSTOM_EXTRA( SENSITIVITY_6_S ) )
	CHOICE_BUTTON_FOCUS_VIS_EX( 7, locString( "@MENU_SENSITIVITY_VERY_HIGH_N", 7 ), SETUP_CUSTOM_ACTION( SENSITIVITY_7 ), ;, ;, when( 1 ), SETUP_CUSTOM_EXTRA( SENSITIVITY_7_S ) )
	CHOICE_BUTTON_FOCUS_VIS_EX( 8, 8, SETUP_CUSTOM_ACTION( SENSITIVITY_8 ), ;, ;, when( 1 ), SETUP_CUSTOM_EXTRA( SENSITIVITY_8_S ) )
	CHOICE_BUTTON_FOCUS_VIS_EX( 9, 9, SETUP_CUSTOM_ACTION( SENSITIVITY_9 ), ;, ;, when( 1 ), SETUP_CUSTOM_EXTRA( SENSITIVITY_9_S ) )
	CHOICE_BUTTON_FOCUS_VIS_EX( 10, locString( "@MENU_SENSITIVITY_INSANE_N", 10 ), SETUP_CUSTOM_ACTION( SENSITIVITY_10 ), ;, ;, when( 1 ), SETUP_CUSTOM_EXTRA( SENSITIVITY_10_S ) )

	#undef CHOICE_TEXTSIZE
	#define CHOICE_TEXTSIZE			TEXTSIZE_DEFAULT

	#undef CHOICE_SIZE_Y
	#define CHOICE_SIZE_Y			22
	
	#undef A_BUTTON_SIZE
	#define A_BUTTON_SIZE			0.33
	
	#undef CHOICE_Y_SPACING
	#define CHOICE_Y_SPACING		(CHOICE_SIZE_Y+2)

	#include "ui/safearea.menu"
}



// BRIGHTNESS MENU
menuDef 
{
	name			CONTROL_BRIGHTNESS_NAME
#ifdef	CONTROL_IN_GAME	
	rect			0 0 640 480
	focuscolor		COLOR_FOCUSED
	style			WINDOW_STYLE_EMPTY
	#ifndef PS3
	blurWorld		2.0
	#endif
	legacySplitScreenScale
	onClose	{setdvar cg_drawhud "1";}
	execkeyint BUTTON_START{close self;exec "updategamerprofile";}
	onOpen 	{setdvar cg_drawhud "0";}
	onEsc {	
		close CONTROL_BRIGHTNESS_NAME;			
		#ifndef CONTROL_IN_GAME_SPLITSCREEN
			#ifndef SINGLE_PLAYER
				open CONTROL_MENU_NAME;
			#else
				open ingameoptions;
			#endif
		#endif
	}
	#ifndef PS3
	itemDef	
	{
		style			WINDOW_STYLE_FILLED
		rect			0 0 640 480 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN
		backcolor		BG_SHADE_COLOR
		visible			when( dvarBool( hiDef ) )
		decoration
	}
	#endif
	itemDef	
	{
		style			WINDOW_STYLE_SHADER
		rect			0 0 854 75 HORIZONTAL_ALIGN_FULLSCREEN 0
		background		"gradient_top"
		visible			when( dvarBool( hiDef ) )
		decoration
	}
	itemDef	
	{
		style			WINDOW_STYLE_SHADER
		rect			0 400 854 75 HORIZONTAL_ALIGN_FULLSCREEN 0
		background		"gradient_bottom"
		visible			when( dvarBool( hiDef ) )
		decoration
	}
#else
	rect			0 0 640 480
	focuscolor		COLOR_FOCUSED
	soundloop 		"music_mainmenu_mp"
	style			WINDOW_STYLE_EMPTY
	legacySplitScreenScale
	onOpen 	{}
	onClose	{;}
	onEsc {	
		close CONTROL_BRIGHTNESS_NAME;	
		#ifndef CONTROL_IN_GAME_SPLITSCREEN
			#ifndef SINGLE_PLAYER
				open CONTROL_MENU_NAME;
			#endif
		#endif
	}
	#include "ui/bg.inc"
#endif
	
	// ------------------ TREE TITLE ------------------
	#ifdef	CONTROL_IN_GAME_SPLITSCREEN
		CHOICE_MENU_TITLE_SS( "@MENU_BRIGHTNESS_CAP" )
	#else
		CHOICE_MENU_TITLE( "@MENU_BRIGHTNESS_CAP" )
	#endif
	// ------------------ buttons ---------------------
	#undef	LOCAL_NOT_IN_CAC
	#undef	LOCAL_IN_CAC
	#include "ui_mp/navcontrols.inc"

	/*
	#define SETUP_BRIGHTNESS( pconfig ) \
		play "mouse_click"; \
		exec pconfig \
		close CONTROL_SENSITIVITY_NAME; \
		open CONTROL_MENU_NAME;

	#define SETUP_EXTRA( pnum ) \
		dvartest "input_viewSensitivity" focusdvar { pnum }
	*/
	//#define CHOICE_DVARSLIDER( itemIndex, textArg, dvarArg, defaultArg, minArg, maxArg, actionArg ) \
	//#define CHOICE_DVARSLIDER_VIS_EX( itemIndex, textArg, dvarArg, defaultArg, minArg, maxArg, actionArg, extraArg, visArg ) \

	#define SETUP_BRIGHNESS_EXTRA \
		execKeyInt DPAD_LEFT { \
			execOnDvarFloatValue r_gamma 1.50 "set r_gamma 1.33"; \
			execOnDvarFloatValue r_gamma 1.33 "set r_gamma 1.21"; \
			execOnDvarFloatValue r_gamma 1.21 "set r_gamma 1.10"; \
			execOnDvarFloatValue r_gamma 1.10 "set r_gamma 1.00"; \
			execOnDvarFloatValue r_gamma 1.00 "set r_gamma 0.90"; \
			execOnDvarFloatValue r_gamma 0.90 "set r_gamma 0.82"; \
			execOnDvarFloatValue r_gamma 0.82 "set r_gamma 0.75"; \
			execOnDvarFloatValue r_gamma 0.75 "set r_gamma 0.68"; \
			execOnDvarFloatValue r_gamma 0.68 "set r_gamma 0.62"; \
			execOnDvarFloatValue r_gamma 0.62 "set r_gamma 0.56"; \
			execOnDvarFloatValue r_gamma 0.56 "set r_gamma 0.50"; \
		} \
		execKeyInt APAD_LEFT { \
			execOnDvarFloatValue r_gamma 1.50 "set r_gamma 1.33"; \
			execOnDvarFloatValue r_gamma 1.33 "set r_gamma 1.21"; \
			execOnDvarFloatValue r_gamma 1.21 "set r_gamma 1.10"; \
			execOnDvarFloatValue r_gamma 1.10 "set r_gamma 1.00"; \
			execOnDvarFloatValue r_gamma 1.00 "set r_gamma 0.90"; \
			execOnDvarFloatValue r_gamma 0.90 "set r_gamma 0.82"; \
			execOnDvarFloatValue r_gamma 0.82 "set r_gamma 0.75"; \
			execOnDvarFloatValue r_gamma 0.75 "set r_gamma 0.68"; \
			execOnDvarFloatValue r_gamma 0.68 "set r_gamma 0.62"; \
			execOnDvarFloatValue r_gamma 0.62 "set r_gamma 0.56"; \
			execOnDvarFloatValue r_gamma 0.56 "set r_gamma 0.50"; \
		} \
		execKeyInt DPAD_RIGHT { \
			execOnDvarFloatValue r_gamma 0.50 "set r_gamma 0.56"; \
			execOnDvarFloatValue r_gamma 0.56 "set r_gamma 0.62"; \
			execOnDvarFloatValue r_gamma 0.62 "set r_gamma 0.68"; \
			execOnDvarFloatValue r_gamma 0.68 "set r_gamma 0.75"; \
			execOnDvarFloatValue r_gamma 0.75 "set r_gamma 0.82"; \
			execOnDvarFloatValue r_gamma 0.82 "set r_gamma 0.90"; \
			execOnDvarFloatValue r_gamma 0.90 "set r_gamma 1.00"; \
			execOnDvarFloatValue r_gamma 1.00 "set r_gamma 1.10"; \
			execOnDvarFloatValue r_gamma 1.10 "set r_gamma 1.21"; \
			execOnDvarFloatValue r_gamma 1.21 "set r_gamma 1.33"; \
			execOnDvarFloatValue r_gamma 1.33 "set r_gamma 1.50"; \
		} \
		execKeyInt APAD_RIGHT { \
			execOnDvarFloatValue r_gamma 0.50 "set r_gamma 0.56"; \
			execOnDvarFloatValue r_gamma 0.56 "set r_gamma 0.62"; \
			execOnDvarFloatValue r_gamma 0.62 "set r_gamma 0.68"; \
			execOnDvarFloatValue r_gamma 0.68 "set r_gamma 0.75"; \
			execOnDvarFloatValue r_gamma 0.75 "set r_gamma 0.82"; \
			execOnDvarFloatValue r_gamma 0.82 "set r_gamma 0.90"; \
			execOnDvarFloatValue r_gamma 0.90 "set r_gamma 1.00"; \
			execOnDvarFloatValue r_gamma 1.00 "set r_gamma 1.10"; \
			execOnDvarFloatValue r_gamma 1.10 "set r_gamma 1.21"; \
			execOnDvarFloatValue r_gamma 1.21 "set r_gamma 1.33"; \
			execOnDvarFloatValue r_gamma 1.33 "set r_gamma 1.50"; \
		}

	#define CHOICE_BG_BOX( itemIndex, blackLevel, visArg ) \
		itemDef \
		{ \
			style			WINDOW_STYLE_SHADER \
			rect			CHOICE_ORIGIN( itemIndex ) (CHOICE_SIZE_X-(CHOICE_SIZE_Y/4)) CHOICE_SIZE_Y CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN \
			exp				material( "white" ); \
			forecolor		blackLevel blackLevel blackLevel 1 \
			visible			visArg \
			decoration \
		}

	#undef A_BUTTON_OFFSET_X
	#define A_BUTTON_OFFSET_X 100000
	
	CHOICE_DVARSLIDER_VIS_EX( 1, "@MENU_BRIGHTNESS", r_gamma, 1, 0.5, 1.50, ;, SETUP_BRIGHNESS_EXTRA, 1 )

	#undef CHOICE_TEXTSIZE
	#define CHOICE_TEXTSIZE			TEXTSIZE_SMALL

	#undef CHOICE_HORIZONTAL_ALIGN
	#define CHOICE_HORIZONTAL_ALIGN HORIZONTAL_ALIGN_CENTER

	#undef CHOICE_TEXTALIGN
	#define	CHOICE_TEXTALIGN		ITEM_ALIGN_MIDDLE_LEFT

	#undef CHOICE_X_START
	#define CHOICE_X_START			(0-(CHOICE_SIZE_X/2))

	CHOICE_CAPTION_COLOR_VIS( 3, "@MENU_BRIGHTNESS_DESC1", CHOICE_TEXTCOLOR, 1 );
#ifndef PS3
	CHOICE_CAPTION_COLOR_VIS( 4, "@MENU_BRIGHTNESS_DESC2", CHOICE_TEXTCOLOR, when( dvarBool( hiDef ) ) );

	#undef CHOICE_HORIZONTAL_ALIGN
	#define CHOICE_HORIZONTAL_ALIGN HORIZONTAL_ALIGN_CENTER

	#undef CHOICE_TEXTALIGN
	#define	CHOICE_TEXTALIGN		ITEM_ALIGN_MIDDLE_CENTER

	#undef CHOICE_TEXTSIZE
	#define CHOICE_TEXTSIZE			TEXTSIZE_DEFAULT

	#undef CHOICE_SIZE_X
	#define CHOICE_SIZE_X			300

	#undef CHOICE_X_START
	#define CHOICE_X_START			(0-(CHOICE_SIZE_X/2))

	#undef CHOICE_SIZE_Y
	#define CHOICE_SIZE_Y			60

	#undef CHOICE_Y_SPACING
	#define CHOICE_Y_SPACING		60

	#undef CHOICE_TEXT_OFFSET_X
	#define CHOICE_TEXT_OFFSET_X	0

	#undef CHOICE_TEXTSTYLE
	#define CHOICE_TEXTSTYLE	0

	CHOICE_BG_BOX( 3, 0.062, when( dvarBool( hiDef ) ) );
	CHOICE_BG_BOX( 4, 0.125, when( dvarBool( hiDef ) ) );
	CHOICE_BG_BOX( 5, 0.250, when( dvarBool( hiDef ) ) );

	CHOICE_CAPTION_COLOR_VIS( 3, "@MENU_BRIGHTNESS_NOT_VISIBLE", 0 0 0 1, when( dvarBool( hiDef ) ) );
	CHOICE_CAPTION_COLOR_VIS( 4, "@MENU_BRIGHTNESS_BARELY_VISIBLE", 0 0 0 1, when( dvarBool( hiDef ) ) );
	CHOICE_CAPTION_COLOR_VIS( 5, "@MENU_BRIGHTNESS_EASILY_VISIBLE", 0 0 0 1, when( dvarBool( hiDef ) ) );
#endif
	#include "ui/safearea.menu"
}