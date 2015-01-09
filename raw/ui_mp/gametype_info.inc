
#include "ui_mp/navcontrols.inc"

#ifndef GAMETYPE_LIST
#error "GAMETYPE undefined"
#endif

#ifndef GAMETYPE_TABLE
#error "GAMETYPE_TABLE undefined"
#endif

//--- style override ---

#undef CHOICE_SIZE_Y
#define CHOICE_SIZE_Y			18
	
#undef CHOICE_Y_SPACING
#define CHOICE_Y_SPACING		20

#undef CHOICE_TEXTSIZE
#define CHOICE_TEXTSIZE			TEXTSIZE_SMALL

#undef CHOICE_TEXT_OFFSET_X
#define CHOICE_TEXT_OFFSET_X	-21

#undef ALT_HINT_X_OFFSET
#define ALT_HINT_X_OFFSET		-14

#undef HIGHLIGHT_COLOR
#define HIGHLIGHT_COLOR			0.9 0.95 1 0.25

#undef NEW_X_OFFSET			
#define NEW_X_OFFSET			(-(CHOICE_SIZE_X+4))

#undef NEW_Y_OFFSET			
#define NEW_Y_OFFSET			-3
//--- end style override ---

// ----------------------------map images------------------------------------
#define GAMEINFO_WIDTH			270
#define GAMEINFO_WIDTH2			275
#define GAMEINFO_HEIGHT			200
#define GAMEINFO_HEIGHT2		120
#define GAMEINFO_ORIGIN			4 -160

PREPROC_SHADER_DRAW_ALIGNED( GAMEINFO_ORIGIN GAMEINFO_WIDTH2 GAMEINFO_HEIGHT HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER, 0 5, "white", 0 0 0 0.3, 0, 0, 0 0 0 0 )

PREPROC_SHADER_DRAW_ALIGNED( GAMEINFO_ORIGIN GAMEINFO_WIDTH 20 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER, 5 0, "white", 0.1 0.1 0.1 1, 0, 0, 0 0 0 0 )
PREPROC_SHADER_DRAW_ALIGNED( GAMEINFO_ORIGIN (-(GAMEINFO_WIDTH)) 20 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER, 5 0, "gradient_fadein", 0.9 0.95 1 0.4, 0, 0, 0 0 0 0 )
PREPROC_SHADER_DRAW_ALIGNED( GAMEINFO_ORIGIN -80 20 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER, (GAMEINFO_WIDTH-76) 0, "ui_perforation", 1 1 1 1, 0, 0, 0 0 0 0 )

// ------------------------------------------------
// -------------- gametype list -------------------
// ------------------------------------------------

#define LOCAL_GAMETYPE_SHOW( p_gametype, p_gametype2 ) \
	hide "gametype_image_group"; \
	hide "gametype_name_group"; \
	hide "gametype_desc_group"; \
	show "image_"p_gametype; \
	show "name_"p_gametype; \
	show "desc_"p_gametype;

#define LOCAL_GAMETYPE_ACTION( p_gametype, p_gametype_text ) \
	play "mouse_click";	\
	setdvar ui_gametype p_gametype;	\
	execOnDvarIntValue splitscreen 1 "exec "SPLITSCREEN_MP_CFG; \
	execOnDvarIntValue systemlink 1 "exec "SYSTEMLINK_MP_CFG; \
	execOnDvarIntValue xblive_privatematch 1 "exec "XBOXLIVE_MP_CFG; \
	close self;

#define LOCAL_GAMETYPE_SELECTION( itemNum, p_gametype_text, p_gametype )\
	CHOICE_BUTTON_FOCUS_VIS_EX( itemNum, p_gametype_text, LOCAL_GAMETYPE_ACTION( p_gametype, p_gametype_text ), LOCAL_GAMETYPE_SHOW( p_gametype, p_gametype_text ), ;, 1, dvartest "ui_gametype" focusdvar { p_gametype } ) \
	PREPROC_TEXT_DRAW_ALIGNED_EXP( GAMEINFO_ORIGIN (GAMEINFO_WIDTH-20) 16 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER, 4 18, "@"+tablelookup(GAMETYPE_TABLE,0,p_gametype,1), TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_LEFT, COLOR_TITLE name "name_"p_gametype group "gametype_name_group" )\
	PREPROC_TEXT_DRAW_ALIGNED_EXP( GAMEINFO_ORIGIN (GAMEINFO_WIDTH-8) GAMEINFO_HEIGHT2 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER, 4 40, "@"+tablelookup(GAMETYPE_TABLE,0,p_gametype,2), TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_LEFT, CHOICE_TEXTCOLOR name "desc_"p_gametype group "gametype_desc_group" autowrapped )\
	PREPROC_SHADER_DRAW_ALIGNED( GAMEINFO_ORIGIN GAMEINFO_WIDTH2 (GAMEINFO_HEIGHT-26) HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER, 0 20, tablelookup(GAMETYPE_TABLE,0,p_gametype,3), 1 1 1 1, 0, 0, 0 0 0 0 name "image_"p_gametype group "gametype_image_group" )

GAMETYPE_LIST

UI_EDGE_REVERSE( GAMEINFO_ORIGIN,HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER, 0, 0, 0.1 0.1 0.1 1 ) 
UI_EDGE_REVERSE( GAMEINFO_ORIGIN,HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER, 0, 0, 0.9 0.95 1 0.4 )

PREPROC_SHADER_DRAW_ALIGNED( GAMEINFO_ORIGIN GAMEINFO_WIDTH2 8 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER, 0 GAMEINFO_HEIGHT, "white", 0.1 0.1 0.1 1, 0, 0, 0 0 0 0 )
PREPROC_SHADER_DRAW_ALIGNED( GAMEINFO_ORIGIN (-(GAMEINFO_WIDTH2)) 8 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER, 0 GAMEINFO_HEIGHT, "gradient_fadein",0.9 0.95 1 0.35, 0, 0, 0 0 0 0 )
