/*
#ifndef PC_IN_GAME
	#include "ui/bg.inc"
#endif
*/
blurWorld		7.0

PREPROC_SHADER_DRAW( -120 0 880 480, 0 0, "white", 0 0 0 0.75, 0, 1, 0 0 0 0 )

//PREPROC_SHADER_DRAW( 0 0 640 480, 0 0, "white", 0 0 0 0.75, 0, 1, 0 0 0 0 )
//PREPROC_SHADER_DRAW( ORIGIN_OPTIONS_FRAME 100 480, 0 0, "gradient_fadein", 0 0 0 0.1, 0, 1, 0 0 0 0 )
//PREPROC_SHADER_DRAW( ORIGIN_OPTIONS_FRAME 600 480, 100 0, "gradient_fadein", 0 0 0 0.5, 0, 1, 0 0 0 0 )

#undef BACK_OPEN
#define BACK_OPEN exec "wait";
#include "ui_mp/navcontrols.inc"
CHOICE_MENU_TITLE( "@MENU_CONTROLS" )

#undef CHOICE_X_START
#define CHOICE_X_START		-324

#undef CHOICE_HORIZONTAL_ALIGN
#define CHOICE_HORIZONTAL_ALIGN HORIZONTAL_ALIGN_CENTER

#undef CHOICE_VERTICAL_ALIGN
#define CHOICE_VERTICAL_ALIGN VERTICAL_ALIGN_TOP

//CHOICE_SECTION_TITLE( 1, "@MENU_CONTROLS" )
CHOICE_BUTTON( 2, "@MENU_LOOK", LOCAL_CLOSE_ALL open options_look )
CHOICE_BUTTON( 3, "@MENU_MOVE", LOCAL_CLOSE_ALL open options_move )
CHOICE_BUTTON( 4, "@MENU_COMBAT", LOCAL_CLOSE_ALL open options_shoot )
CHOICE_BUTTON( 5, "@MENU_INTERACT", LOCAL_CLOSE_ALL open options_misc )
CHOICE_BUTTON_VIS( 6, "@MENU_MULTIPLAYER_CONTROLS", LOCAL_CLOSE_ALL open controls_multi, when( dvarint( ui_multiplayer ) ) )
CHOICE_DBUTTON_VIS( 6, "@MENU_MULTIPLAYER_CONTROLS", when( !dvarint( ui_multiplayer ) ); )
CHOICE_BUTTON( 7, "@MENU_SET_DEFAULT_CONTROLS", LOCAL_CLOSE_ALL open options_control_defaults )		

// ---
/*
#undef TEXTSIZE_BUTTON_PC
#define TEXTSIZE_BUTTON_PC	0.33

#undef CHOICE_SIZE_Y
#define CHOICE_SIZE_Y 		20
*/

#undef	CHOICE_SIZE_X
#define CHOICE_SIZE_X		180

#undef  SECTION_X_OFFSET
#define SECTION_X_OFFSET 	60
// ---