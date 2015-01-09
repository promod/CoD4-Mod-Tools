
#include "ui_mp/navcontrols.inc"

#ifndef MAP_LIST
#error "MAP_LIST undefined"
#endif

#ifndef MAP_TABLE
#error "MAP_TABLE undefined"
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

PREPROC_SHADER_DRAW_ALIGNED( GAMEINFO_ORIGIN GAMEINFO_WIDTH2 (GAMEINFO_HEIGHT+GAMEINFO_HEIGHT2) HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER, 0 5, "white", 0 0 0 0.3, 0, 0, 0 0 0 0 )

PREPROC_SHADER_DRAW_ALIGNED( GAMEINFO_ORIGIN GAMEINFO_WIDTH 20 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER, 5 0, "white", 0.1 0.1 0.1 1, 0, 0, 0 0 0 0 )
PREPROC_SHADER_DRAW_ALIGNED( GAMEINFO_ORIGIN (-(GAMEINFO_WIDTH)) 20 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER, 5 0, "gradient_fadein", 0.9 0.95 1 0.4, 0, 0, 0 0 0 0 )
PREPROC_SHADER_DRAW_ALIGNED( GAMEINFO_ORIGIN -80 20 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER, (GAMEINFO_WIDTH-76) 0, "ui_perforation", 1 1 1 1, 0, 0, 0 0 0 0 )

// ------------------------------------------------
// ------------------ map list --------------------
// ------------------------------------------------

#define LOCAL_MAP_SHOW( p_mapname, p_mapname2 ) \
	hide "map_image_group"; \
	hide "map_name_group"; \
	hide "map_desc_group"; \
	setdvar ui_mapname2_text p_mapname2; \
	show "image_"p_mapname; \
	show "name_"p_mapname; \
	show "desc_"p_mapname;

#define LOCAL_MAP_ACTION( p_mapname, p_mapname_text ) \
	play "mouse_click";	\
	setdvar ui_mapname p_mapname;	\
	setdvar ui_mapname_text p_mapname_text; \
	close self;

#define LOCAL_MAP_SELECTION( itemNum, p_mapname_text, p_mapname )\
	CHOICE_BUTTON_FOCUS_VIS_EX( itemNum, p_mapname_text, LOCAL_MAP_ACTION( p_mapname, p_mapname_text ), LOCAL_MAP_SHOW( p_mapname, p_mapname_text ), ;, 1, dvartest "ui_mapname" focusdvar { p_mapname } ) \
	PREPROC_TEXT_DRAW_ALIGNED_EXP( GAMEINFO_ORIGIN (GAMEINFO_WIDTH-20) 16 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER, 4 18, "@"+tablelookup(MAP_TABLE,0,p_mapname,3), TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_LEFT, COLOR_TITLE name "name_"p_mapname group "map_name_group" )\
	PREPROC_TEXT_DRAW_ALIGNED_EXP( GAMEINFO_ORIGIN (GAMEINFO_WIDTH-8) GAMEINFO_HEIGHT2 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER, 4 (GAMEINFO_HEIGHT+20), "@"+tablelookup(MAP_TABLE,0,p_mapname,6), TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_LEFT, CHOICE_TEXTCOLOR name "desc_"p_mapname group "map_desc_group" autowrapped )\
	PREPROC_SHADER_DRAW_ALIGNED( GAMEINFO_ORIGIN GAMEINFO_WIDTH2 (GAMEINFO_HEIGHT-26) HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER, 0 20, tablelookup(MAP_TABLE,0,p_mapname,4), 1 1 1 1, 0, 0, 0 0 0 0 name "image_"p_mapname group "map_image_group" )

MAP_LIST

UI_EDGE_REVERSE( GAMEINFO_ORIGIN,HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER, 0, 0, 0.1 0.1 0.1 1 ) 
UI_EDGE_REVERSE( GAMEINFO_ORIGIN,HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER, 0, 0, 0.9 0.95 1 0.4 )

PREPROC_SHADER_DRAW_ALIGNED( GAMEINFO_ORIGIN GAMEINFO_WIDTH2 8 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER, 0 (GAMEINFO_HEIGHT-6), "white", 0.1 0.1 0.1 1, 0, 0, 0 0 0 0 )
PREPROC_SHADER_DRAW_ALIGNED( GAMEINFO_ORIGIN (-(GAMEINFO_WIDTH2)) 8 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER, 0 (GAMEINFO_HEIGHT-6), "gradient_fadein",0.9 0.95 1 0.35, 0, 0, 0 0 0 0 )

PREPROC_SHADER_DRAW_ALIGNED( GAMEINFO_ORIGIN GAMEINFO_WIDTH2 20 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER, 0 (GAMEINFO_HEIGHT+GAMEINFO_HEIGHT2-20), "white", 0.1 0.1 0.1 1, 0, 0, 0 0 0 0 )
PREPROC_SHADER_DRAW_ALIGNED( GAMEINFO_ORIGIN (-(GAMEINFO_WIDTH2)) 20 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER, 0 (GAMEINFO_HEIGHT+GAMEINFO_HEIGHT2-20), "gradient_fadein",0.9 0.95 1 0.35, 0, 0, 0 0 0 0 )
		
PREPROC_SHADER_DRAW_ALIGNED( GAMEINFO_ORIGIN GAMEINFO_WIDTH2 16 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER, 0 20, "gradient_top", 0 0 0 .75, 0, 0, 0 0 0 0 )
PREPROC_SHADER_DRAW_ALIGNED( GAMEINFO_ORIGIN GAMEINFO_WIDTH2 16 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER, 0 (GAMEINFO_HEIGHT-22), "gradient_bottom", 0 0 0 .75, 0, 0, 0 0 0 0 )
