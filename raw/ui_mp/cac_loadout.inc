#define LOADOUT_WIDTH 			270

#ifdef PC
	#define ORIGIN_LOADOUT			((-(LOADOUT_WIDTH - RIGHTITEM_OFFSET))-80) 38
#else
	#define ORIGIN_LOADOUT			(-(LOADOUT_WIDTH - RIGHTITEM_OFFSET)) 38
#endif

#define RATEBAR_FRAME_BORDER		0//WINDOW_BORDER_SUNKEN
#define RATEBAR_FRAME_BORDERSIZE	2
#define RATEBAR_FRAME_BORDERCOLOR	0.4 0.4 0.425 1

#define RATEBAR_BAR_SHADER			"gradient_fadein"
#define RATEBAR_BAR_COLOR			1 1 1 0.3

#define RATE_BAR_WIDTH				98
#define RATE_BAR_HEIGHT				12
	
#define VIS_WHEN_ATTACH_PLUS(pweapon,pattribute) visible when( (STAT_CAC_PRIMARY_ATTACHMENT != 0) && (int(tablelookup("mp/attributesTable.csv",1,pweapon,pattribute)) > 0) )
#define VIS_WHEN_ATTACH_MINUS(pweapon,pattribute) visible when( (STAT_CAC_PRIMARY_ATTACHMENT != 0) && (int(tablelookup("mp/attributesTable.csv",1,pweapon,pattribute)) < 0) ) 

#define VIS_WHEN_ATTACH_PLUS_PREVIEW(pweapon,pattribute,extraArg) visible when( (int(tablelookup("mp/attributesTable.csv",1,pweapon,pattribute)) > 0) && extraArg )
#define VIS_WHEN_ATTACH_MINUS_PREVIEW(pweapon,pattribute,extraArg) visible when( (int(tablelookup("mp/attributesTable.csv",1,pweapon,pattribute)) < 0) && extraArg ) 

#define VIS_WHEN_ONE_PRIME visible when( "specialty_twoprimaries" != tablelookup( "mp/statstable.csv", 1, STAT_CAC_SPECIALTY_WEAPON, 4 ) ) 
#define VIS_WHEN_TWO_PRIME visible when( "specialty_twoprimaries" == tablelookup( "mp/statstable.csv", 1, STAT_CAC_SPECIALTY_WEAPON , 4 ) ) 

/* ================================================================================= */
/* ================================ LOADOUT DISPLAY ================================ */
/* ================================================================================= */
// UI art: Julian version 2 - first pass

// CAC loadout main frame =================

	#define LOADOUT_ALIGN 	RIGHTITEM_ALIGN VERTICAL_ALIGN_TOP
	#define PERK_ALIGN		
	
	#define LOADOUT_PLATING( py, ph, vis_gradient_top, vis_gradient_bottom ) \
			LOADOUT_PLATING_RAW( ORIGIN_LOADOUT, 0, py, (LOADOUT_WIDTH+8), ph, LOADOUT_ALIGN, vis_gradient_top, vis_gradient_bottom )
		
/*	#define LOADOUT_PLATING_RAW( porigin, px, py, pw, ph, palign, vis_gradient_top, vis_gradient_bottom ) \
		PREPROC_SHADER_DRAW_ALIGNED( (px-4) (py-8) pw ph palign, porigin, "white", 0.2 0.2 0.225 1, 0, 0, 0 0 0 0 ) \
		PREPROC_SHADER_DRAW_ALIGNED( (px-4) (py-8) pw ph palign, porigin, "line_horizontal", 0.9 0.9 0.95 0.5, 0, 0, 0 0 0 0 ) \
		PREPROC_SHADER_DRAW_ALIGNED( (px-4) (py+ph-8) pw 16 palign, porigin, "gradient_top", 1 1 1 0.4, 0, 0, 0 0 0 0 visible when( vis_gradient_bottom ) ) \
		PREPROC_SHADER_DRAW_ALIGNED( (px-4) (py-24) pw 16 palign, porigin, "gradient_bottom", 1 1 1 0.4, 0, 0, 0 0 0 0 visible when( vis_gradient_top ) )
*/
	// background frame --------
	PREPROC_SHADER_DRAW_ALIGNED( -4 12 (LOADOUT_WIDTH+8) 326 LOADOUT_ALIGN, ORIGIN_LOADOUT, "gradient_center", 0.3 0.3 0.325 0.6, 0, 0, 0 0 0 0 )
//	PREPROC_SHADER_DRAW_ALIGNED( -4 12 (LOADOUT_WIDTH+8) 326 LOADOUT_ALIGN, ORIGIN_LOADOUT, "gradient_center", 1 1 1 0.425, 0, 0, 0 0 0 0 )
//	PREPROC_SHADER_DRAW_ALIGNED( -4 12 (LOADOUT_WIDTH+8) 326 LOADOUT_ALIGN, ORIGIN_LOADOUT, "white", 0 0 0 0.65, 0, 0, 0 0 0 0 )

#ifdef PC
	PREPROC_SHADER_DRAW_ALIGNED( -24 -4 -20 358 LOADOUT_ALIGN, ORIGIN_LOADOUT, "gradient", 1 1 1 0.65, 0, 0, 0 0 0 0 )
#else
	PREPROC_SHADER_DRAW_ALIGNED( -24 -4 -20 342 LOADOUT_ALIGN, ORIGIN_LOADOUT, "gradient", 1 1 1 0.65, 0, 0, 0 0 0 0 )
#endif
	PREPROC_SHADER_DRAW_ALIGNED( (LOADOUT_WIDTH+4) -4 20 358 LOADOUT_ALIGN, ORIGIN_LOADOUT, "gradient", 1 1 1 0.65, 0, 0, 0 0 0 0 )
	
	// primary weapon camo
	PREPROC_SHADER_DRAW_ALIGNED( -4 16 ((LOADOUT_WIDTH+8)/4) 80 LOADOUT_ALIGN, ORIGIN_LOADOUT, tablelookup( "mp/attachmenttable.csv", 11, STAT_CAC_CAMO, 6 ), 1 1 1 0.5, 0, 1, 1 1 1 1) 
	PREPROC_SHADER_DRAW_ALIGNED( (((LOADOUT_WIDTH+8)/4)-4) 16 ((LOADOUT_WIDTH+8)/4) 80 LOADOUT_ALIGN, ORIGIN_LOADOUT, tablelookup( "mp/attachmenttable.csv", 11, STAT_CAC_CAMO, 6 ), 1 1 1 0.5, 0, 1, 1 1 1 1) 
	PREPROC_SHADER_DRAW_ALIGNED( (((LOADOUT_WIDTH+8)/2)-4) 16 ((LOADOUT_WIDTH+8)/4) 80 LOADOUT_ALIGN, ORIGIN_LOADOUT, tablelookup( "mp/attachmenttable.csv", 11, STAT_CAC_CAMO, 6 ), 1 1 1 0.5, 0, 1, 1 1 1 1) 
	PREPROC_SHADER_DRAW_ALIGNED( ((((LOADOUT_WIDTH+8)/4)*3)-4) 16 ((LOADOUT_WIDTH+8)/4) 80 LOADOUT_ALIGN, ORIGIN_LOADOUT, tablelookup( "mp/attachmenttable.csv", 11, STAT_CAC_CAMO, 6 ), 1 1 1 0.5, 0, 1, 1 1 1 1) 
	
	/* top bar */ 			LOADOUT_PLATING( 4, 20, 0, 1 )
	/* bottom bar */		LOADOUT_PLATING( 346, 16, 1, 0 )
	/* weapon divider */ 	LOADOUT_PLATING( 104, 8, 1, 1 )
	/* perk plate */ 		LOADOUT_PLATING( 192, 16, 1, 1 )
	// perks //
	PREPROC_TEXT_DRAW_ALIGNED_EXP( -4 181 (LOADOUT_WIDTH+8) 20 LOADOUT_ALIGN, ORIGIN_LOADOUT, "@MPUI_PERKS_AND_INVENTORY", TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_CENTER, CHOICE_TEXTCOLOR )
	
	// custom class name
	PREPROC_TEXT_DRAW_ALIGNED_EXP( -4 -4 (LOADOUT_WIDTH+8) 20 LOADOUT_ALIGN, ORIGIN_LOADOUT, dvarString(CAC_CUSTOM_NAME), TEXTSIZE_DEFAULT, 0, 0, ITEM_ALIGN_MIDDLE_CENTER, CHOICE_TEXTCOLOR )

// attributes box ======================

#ifndef HIDE_WEAPON_ATTRIBUTE		

	#define INFO_BOX_ORIENT			0
	#define INFO_BOX_WIDTH			222
	#define INFO_BOX_HEIGHT			126
	#define INFO_BOX_X				(CHOICE_X_START+CHOICE_SIZE_X-INFO_BOX_WIDTH)

	#ifdef PC  
		#define INFO_BOX_Y				320
	#else     
		#define INFO_BOX_Y				274
	#endif     

	#define INFO_TEXT				""
	#define INFO_TITLE				"@MENU_PRIMARY_ATTRIBUTES" //"Primary Attributes"
	#define INFO_TITLE_COLOR		CHOICE_TEXTCOLOR
	#include "ui_mp/info_box.inc"
	
	#define ORIGIN_ATTRIBUTE_LABEL	(INFO_BOX_X) (INFO_BOX_Y+2)
		
	PREPROC_TEXT_DRAW_ALIGNED( ORIGIN_ATTRIBUTE_LABEL INFO_BOX_WIDTH 20 CHOICE_HORIZONTAL_ALIGN VERTICAL_ALIGN_TOP, -60 0, text "@MENU_ACCURACY1", TEXTSIZE_SMALL, -68, 16, ITEM_ALIGN_RIGHT, CHOICE_TEXTCOLOR )
	PREPROC_TEXT_DRAW_ALIGNED( ORIGIN_ATTRIBUTE_LABEL INFO_BOX_WIDTH 20 CHOICE_HORIZONTAL_ALIGN VERTICAL_ALIGN_TOP, -60 20, text "@MENU_DAMAGE", TEXTSIZE_SMALL, -68, 16, ITEM_ALIGN_RIGHT, CHOICE_TEXTCOLOR )
	PREPROC_TEXT_DRAW_ALIGNED( ORIGIN_ATTRIBUTE_LABEL INFO_BOX_WIDTH 20 CHOICE_HORIZONTAL_ALIGN VERTICAL_ALIGN_TOP, -60 40, text "@MENU_RANGE", TEXTSIZE_SMALL, -68, 16, ITEM_ALIGN_RIGHT, CHOICE_TEXTCOLOR )
	PREPROC_TEXT_DRAW_ALIGNED( ORIGIN_ATTRIBUTE_LABEL INFO_BOX_WIDTH 20 CHOICE_HORIZONTAL_ALIGN VERTICAL_ALIGN_TOP, -60 60, text "@MENU_FIRE_RATE", TEXTSIZE_SMALL, -68, 16, ITEM_ALIGN_RIGHT, CHOICE_TEXTCOLOR )
	PREPROC_TEXT_DRAW_ALIGNED( ORIGIN_ATTRIBUTE_LABEL INFO_BOX_WIDTH 20 CHOICE_HORIZONTAL_ALIGN VERTICAL_ALIGN_TOP, -60 80, text "@MENU_MOBILITY", TEXTSIZE_SMALL, -68, 16, ITEM_ALIGN_RIGHT, CHOICE_TEXTCOLOR )

	// meter bar unit dividers
	#define ATTRIBUTE_UNITS( px, py ) \
		PREPROC_SHADER_DRAW_ALIGNED( (px+(RATE_BAR_WIDTH/4)) py 1 3 CHOICE_HORIZONTAL_ALIGN VERTICAL_ALIGN_TOP, 0 RATE_BAR_HEIGHT, "line_vertical", 1 1 1 0.2, 0, 0, 0 0 0 0 ) \
		PREPROC_SHADER_DRAW_ALIGNED( (px+(RATE_BAR_WIDTH/2)) py 1 3 CHOICE_HORIZONTAL_ALIGN VERTICAL_ALIGN_TOP, 0 RATE_BAR_HEIGHT, "line_vertical", 1 1 1 0.2, 0, 0, 0 0 0 0 ) \
		PREPROC_SHADER_DRAW_ALIGNED( (px+((RATE_BAR_WIDTH/4)*3)) py 1 3 CHOICE_HORIZONTAL_ALIGN VERTICAL_ALIGN_TOP, 0 RATE_BAR_HEIGHT, "line_vertical", 1 1 1 0.2, 0, 0, 0 0 0 0 )
		
	// weapon attribut meter bars
	#define ATTRIBUTE_BAR_FORMAT( px, py, pnum ) \
		ATTRIBUTE_UNITS( px, py )\
		PREPROC_SHADER_DRAW_ALIGNED( px py (-(RATE_BAR_WIDTH)) RATE_BAR_HEIGHT CHOICE_HORIZONTAL_ALIGN VERTICAL_ALIGN_TOP, 0 0, "gradient", 1 1 1 0.5, 0, 0, 0 0 0 0 ) \
		PREPROC_SHADER_DRAW_ADV( px, py, \
		(int(tablelookup("mp/attributestable.csv", 1, tablelookup("mp/statsTable.csv",0,STAT_CAC_PRIMARY,4), pnum ))+ \
		(int(tablelookup("mp/attributestable.csv", 1, tablelookup("mp/statsTable.csv",0,STAT_CAC_PRIMARY,4)+"_"+ \
		tablelookup("mp/attachmentTable.csv",9,STAT_CAC_PRIMARY_ATTACHMENT,4), pnum ))))*RATE_BAR_WIDTH/100, RATE_BAR_HEIGHT, \
		"white", 0.25 0.3 0.35 1, RATEBAR_FRAME_BORDER, RATEBAR_FRAME_BORDERSIZE, RATEBAR_FRAME_BORDERCOLOR rect 0 0 0 0 CHOICE_HORIZONTAL_ALIGN VERTICAL_ALIGN_TOP )\
		PREPROC_SHADER_DRAW_ADV( px, py, \
		(int(tablelookup("mp/attributestable.csv", 1, tablelookup("mp/statsTable.csv",0,STAT_CAC_PRIMARY,4), pnum ))+ \
		(int(tablelookup("mp/attributestable.csv", 1, tablelookup("mp/statsTable.csv",0,STAT_CAC_PRIMARY,4)+"_"+ \
		tablelookup("mp/attachmentTable.csv",9,STAT_CAC_PRIMARY_ATTACHMENT,4), pnum ))))*RATE_BAR_WIDTH/100, RATE_BAR_HEIGHT, \
		RATEBAR_BAR_SHADER, RATEBAR_BAR_COLOR, RATEBAR_FRAME_BORDER, RATEBAR_FRAME_BORDERSIZE, RATEBAR_FRAME_BORDERCOLOR rect 0 0 0 0 CHOICE_HORIZONTAL_ALIGN VERTICAL_ALIGN_TOP ) \
		/* attachment delta bar -*/ \
		PREPROC_SHADER_DRAW_ADV( px+(int(tablelookup("mp/attributestable.csv", 1, tablelookup("mp/statsTable.csv",0,STAT_CAC_PRIMARY,4), pnum )))*RATE_BAR_WIDTH/100+\
		((int(tablelookup("mp/attributestable.csv", 1, tablelookup("mp/statsTable.csv",0,STAT_CAC_PRIMARY,4)+"_"+ \
		tablelookup("mp/attachmentTable.csv",9,STAT_CAC_PRIMARY_ATTACHMENT,4), pnum )))*RATE_BAR_WIDTH/100), py, \
		(int(tablelookup("mp/attributestable.csv", 1, tablelookup("mp/statsTable.csv",0,STAT_CAC_PRIMARY,4)+"_"+ \
		tablelookup("mp/attachmentTable.csv",9,STAT_CAC_PRIMARY_ATTACHMENT,4), pnum )))*RATE_BAR_WIDTH/100, RATE_BAR_HEIGHT, \
		"white", 0.4 0.15 0.15 1, RATEBAR_FRAME_BORDER, RATEBAR_FRAME_BORDERSIZE, RATEBAR_FRAME_BORDERCOLOR VIS_WHEN_ATTACH_MINUS(tablelookup("mp/statsTable.csv",0,STAT_CAC_PRIMARY,4)+"_"+ \
		tablelookup("mp/attachmentTable.csv",9,STAT_CAC_PRIMARY_ATTACHMENT,4),pnum) rect 0 0 0 0 CHOICE_HORIZONTAL_ALIGN VERTICAL_ALIGN_TOP )\
		/* attachment delta bar +*/ \
		PREPROC_SHADER_DRAW_ADV( px+(int(tablelookup("mp/attributestable.csv", 1, tablelookup("mp/statsTable.csv",0,STAT_CAC_PRIMARY,4), pnum )))*RATE_BAR_WIDTH/100, py, \
		(int(tablelookup("mp/attributestable.csv", 1, tablelookup("mp/statsTable.csv",0,STAT_CAC_PRIMARY,4)+"_"+ \
		tablelookup("mp/attachmentTable.csv",9,STAT_CAC_PRIMARY_ATTACHMENT,4), pnum )))*RATE_BAR_WIDTH/100, RATE_BAR_HEIGHT, \
		"white", 0.3 0.8 0.3 0.5, RATEBAR_FRAME_BORDER, RATEBAR_FRAME_BORDERSIZE, RATEBAR_FRAME_BORDERCOLOR VIS_WHEN_ATTACH_PLUS(tablelookup("mp/statsTable.csv",0,STAT_CAC_PRIMARY,4)+"_"+ \
		tablelookup("mp/attachmentTable.csv",9,STAT_CAC_PRIMARY_ATTACHMENT,4),pnum) rect 0 0 0 0 CHOICE_HORIZONTAL_ALIGN VERTICAL_ALIGN_TOP )\

	#define PREVIEW_VIS_CONDITION visible when( PREVIEW_VIS_CONDITION_RAW );
	#define PREVIEW_VIS_CONDITION_RAW dvarInt( ui_show_preview )

	#define ATTRIBUTE_BAR_FORMAT_PREVIEW( px, py, pnum ) \
		ATTRIBUTE_UNITS( px, py )\
		PREPROC_SHADER_DRAW_ALIGNED( px py (-(RATE_BAR_WIDTH)) RATE_BAR_HEIGHT CHOICE_HORIZONTAL_ALIGN VERTICAL_ALIGN_TOP, 0 0, "white", 0 0 0 1, 0, 0, 0 0 0 0 PREVIEW_VIS_CONDITION ) \
		PREPROC_SHADER_DRAW_ADV( px, py, \
		(int(tablelookup("mp/attributestable.csv", 1, dvarString(ui_primary_highlighted), pnum ))+ \
		(int(tablelookup("mp/attributestable.csv", 1, dvarString(ui_primary_highlighted)+"_"+ \
		dvarString(ui_attachment_highlighted), pnum ))))*RATE_BAR_WIDTH/100, RATE_BAR_HEIGHT, \
		"white", 0.25 0.3 0.35 1, RATEBAR_FRAME_BORDER, RATEBAR_FRAME_BORDERSIZE, RATEBAR_FRAME_BORDERCOLOR rect 0 0 0 0 CHOICE_HORIZONTAL_ALIGN VERTICAL_ALIGN_TOP PREVIEW_VIS_CONDITION )\
		PREPROC_SHADER_DRAW_ADV( px, py, \
		(100)*RATE_BAR_WIDTH/100, RATE_BAR_HEIGHT, \
		RATEBAR_BAR_SHADER, RATEBAR_BAR_COLOR, RATEBAR_FRAME_BORDER, RATEBAR_FRAME_BORDERSIZE, RATEBAR_FRAME_BORDERCOLOR rect 0 0 0 0 CHOICE_HORIZONTAL_ALIGN VERTICAL_ALIGN_TOP PREVIEW_VIS_CONDITION ) \
		/* attachment delta bar -*/ \
		PREPROC_SHADER_DRAW_ADV( px+(int(tablelookup("mp/attributestable.csv", 1, dvarString(ui_primary_highlighted), pnum )))*RATE_BAR_WIDTH/100+\
		((int(tablelookup("mp/attributestable.csv", 1, dvarString(ui_primary_highlighted)+"_"+ \
		dvarString(ui_attachment_highlighted), pnum )))*RATE_BAR_WIDTH/100), py, \
		(int(tablelookup("mp/attributestable.csv", 1, dvarString(ui_primary_highlighted)+"_"+ \
		dvarString(ui_attachment_highlighted), pnum )))*RATE_BAR_WIDTH/100, RATE_BAR_HEIGHT, \
		"white", 0.4 0.15 0.15 1, RATEBAR_FRAME_BORDER, RATEBAR_FRAME_BORDERSIZE, RATEBAR_FRAME_BORDERCOLOR \
		VIS_WHEN_ATTACH_MINUS_PREVIEW(dvarString(ui_primary_highlighted)+"_"+dvarString(ui_attachment_highlighted),pnum, PREVIEW_VIS_CONDITION_RAW ) \
		rect 0 0 0 0 CHOICE_HORIZONTAL_ALIGN VERTICAL_ALIGN_TOP )\
		/* attachment delta bar +*/ \
		PREPROC_SHADER_DRAW_ADV( px+(int(tablelookup("mp/attributestable.csv", 1, dvarString(ui_primary_highlighted), pnum )))*RATE_BAR_WIDTH/100, py, \
		(int(tablelookup("mp/attributestable.csv", 1, dvarString(ui_primary_highlighted)+"_"+ \
		dvarString(ui_attachment_highlighted), pnum )))*RATE_BAR_WIDTH/100, RATE_BAR_HEIGHT, \
		"white", 0.3 0.8 0.3 0.5, RATEBAR_FRAME_BORDER, RATEBAR_FRAME_BORDERSIZE, RATEBAR_FRAME_BORDERCOLOR \
		VIS_WHEN_ATTACH_PLUS_PREVIEW(dvarString(ui_primary_highlighted)+"_"+dvarString(ui_attachment_highlighted),pnum, PREVIEW_VIS_CONDITION_RAW ) \
		rect 0 0 0 0 CHOICE_HORIZONTAL_ALIGN VERTICAL_ALIGN_TOP )
		
	ATTRIBUTE_BAR_FORMAT( (INFO_BOX_X+100), (INFO_BOX_Y+6), 2 )
	ATTRIBUTE_BAR_FORMAT( (INFO_BOX_X+100), (INFO_BOX_Y+26), 3 )
	ATTRIBUTE_BAR_FORMAT( (INFO_BOX_X+100), (INFO_BOX_Y+46), 4 ) 
	ATTRIBUTE_BAR_FORMAT( (INFO_BOX_X+100), (INFO_BOX_Y+66), 5 )
	ATTRIBUTE_BAR_FORMAT( (INFO_BOX_X+100), (INFO_BOX_Y+86), 6 )
	
	ATTRIBUTE_BAR_FORMAT_PREVIEW( (INFO_BOX_X+100), (INFO_BOX_Y+6), 2 )
	ATTRIBUTE_BAR_FORMAT_PREVIEW( (INFO_BOX_X+100), (INFO_BOX_Y+26), 3 )
	ATTRIBUTE_BAR_FORMAT_PREVIEW( (INFO_BOX_X+100), (INFO_BOX_Y+46), 4 ) 
	ATTRIBUTE_BAR_FORMAT_PREVIEW( (INFO_BOX_X+100), (INFO_BOX_Y+66), 5 )
	ATTRIBUTE_BAR_FORMAT_PREVIEW( (INFO_BOX_X+100), (INFO_BOX_Y+86), 6 )
	
#endif

// weapon loadout info display ============
	
	// primary weapon name
	PREPROC_TEXT_DRAW_ALIGNED_EXP( 0 20 (LOADOUT_WIDTH+8) 20 LOADOUT_ALIGN, ORIGIN_LOADOUT, "@"+tablelookup("mp/statstable.csv", 0, STAT_CAC_PRIMARY, 3), TEXTSIZE_DEFAULT, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, COLOR_TITLE )
	// primary weapon attachment name
	PREPROC_TEXT_DRAW_ALIGNED_EXP( 0 74 (LOADOUT_WIDTH+8) 20 LOADOUT_ALIGN, ORIGIN_LOADOUT, "@"+tablelookup("mp/attachmenttable.csv", 9, STAT_CAC_PRIMARY_ATTACHMENT, 3), TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, CHOICE_TEXTCOLOR )
	// primary weapon image
	PREPROC_SHADER_DRAW_ALIGNED( 74 10 180 90 LOADOUT_ALIGN, ORIGIN_LOADOUT, tablelookup( "mp/statstable.csv", 0, STAT_CAC_PRIMARY, 6 ), 1 1 1 1, 0, 1, 1 1 1 1) 
	// primary weapon attachment image
	PREPROC_SHADER_DRAW_ALIGNED( 2 42 32 32 LOADOUT_ALIGN, ORIGIN_LOADOUT, tablelookup( "mp/attachmenttable.csv", 9, STAT_CAC_PRIMARY_ATTACHMENT, 6 ), 1 1 1 1, 0, 1, 1 1 1 1) 	
	
	// second weapon name
	PREPROC_TEXT_DRAW_ALIGNED_EXP( 0 (20+88) (LOADOUT_WIDTH+8) 20 LOADOUT_ALIGN, ORIGIN_LOADOUT, "@" + tablelookup("mp/statstable.csv", 0, STAT_CAC_SECONDARY, 3), TEXTSIZE_DEFAULT, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, COLOR_TITLE )
	// second weapon attachment name
	PREPROC_TEXT_DRAW_ALIGNED_EXP( 0 (74+88) (LOADOUT_WIDTH+8) 20 LOADOUT_ALIGN, ORIGIN_LOADOUT, "@"+tablelookup("mp/attachmenttable.csv", 9, STAT_CAC_SECONDARY_ATTACHMENT, 3), TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, CHOICE_TEXTCOLOR )
	// second weapon image
	PREPROC_SHADER_DRAW_ALIGNED( 74 (6+92) 180 90 LOADOUT_ALIGN, ORIGIN_LOADOUT, tablelookup( "mp/statstable.csv", 0, STAT_CAC_SECONDARY, 6 ), 1 1 1 1, 0, 1, 1 1 1 1 VIS_WHEN_TWO_PRIME ) 
	PREPROC_SHADER_DRAW_ALIGNED( 160 (6+92) 90 90 LOADOUT_ALIGN, ORIGIN_LOADOUT, tablelookup( "mp/statstable.csv", 0, STAT_CAC_SECONDARY, 6 ), 1 1 1 1, 0, 1, 1 1 1 1 VIS_WHEN_ONE_PRIME ) 
	// second weapon attachment image
	PREPROC_SHADER_DRAW_ALIGNED( 2 130 32 32 LOADOUT_ALIGN, ORIGIN_LOADOUT, tablelookup( "mp/attachmenttable.csv", 9, STAT_CAC_SECONDARY_ATTACHMENT, 6 ), 1 1 1 1, 0, 1, 1 1 1 1) 	
	
// perk loadout info display =============
	
	#ifdef PC
		#define PERK_DESC_TEXTSIZE	0.25
	#else
		#define PERK_DESC_TEXTSIZE 	TEXTSIZE_SMALL
	#endif
	
	#define PERK_Y_OFFSET	206
	#define PERK_Y_SPACING	36

  // perk 1 name -------------
	#define LOCAL_PERK1( ptext, visArg ) \
	PREPROC_TEXT_DRAW_ALIGNED_EXP( 36 PERK_Y_OFFSET (LOADOUT_WIDTH+8) 20 LOADOUT_ALIGN, \
	ORIGIN_LOADOUT, ptext, TEXTSIZE_SMALL, 0, -2, ITEM_ALIGN_MIDDLE_LEFT, COLOR_TITLE visible when( visArg ); )

	LOCAL_PERK1( "@" + tablelookup( "mp/statstable.csv", 1, STAT_CAC_SPECIALTY_EQUIPMENT, 3 ), tablelookup( "mp/statstable.csv", 1, STAT_CAC_SPECIALTY_EQUIPMENT, 4 ) != "specialty_specialgrenade" )
	LOCAL_PERK1( "@PERKS_3X_" + tablelookup("mp/statstable.csv",0,STAT_CAC_SPECIAL_GRENADE,3), tablelookup( "mp/statstable.csv", 1, STAT_CAC_SPECIALTY_EQUIPMENT, 4 ) == "specialty_specialgrenade" )
	
	// perk 1 icon
	PREPROC_SHADER_DRAW_ALIGNED( 0 PERK_Y_OFFSET 32 32 LOADOUT_ALIGN, ORIGIN_LOADOUT, tablelookup( "mp/statstable.csv", 1, STAT_CAC_SPECIALTY_EQUIPMENT, 6 ), 1 1 1 0.65, 0, 1, 1 1 1 1) 
	PREPROC_SHADER_DRAW_ALIGNED( -4 (PERK_Y_OFFSET+34) (LOADOUT_WIDTH+8) 1 LOADOUT_ALIGN, ORIGIN_LOADOUT, "white", 1 1 1 0.1, 0, 1, 1 1 1 1) 

	// perk 1 desc
	PREPROC_SHADER_DRAW_ALIGNED( 32 (PERK_Y_OFFSET+16) 14 14 LOADOUT_ALIGN, ORIGIN_LOADOUT, "ui_arrow_right", 1 1 1 0.4, 0, 1, 1 1 1 1) 
	PREPROC_TEXT_DRAW_ALIGNED_EXP( 48 (PERK_Y_OFFSET+15) (LOADOUT_WIDTH+8) 20 LOADOUT_ALIGN, ORIGIN_LOADOUT, "@" + tablelookup("mp/statstable.csv", 1, STAT_CAC_SPECIALTY_EQUIPMENT, 7), PERK_DESC_TEXTSIZE, 0, -2, ITEM_ALIGN_MIDDLE_LEFT, CHOICE_TEXTCOLOR )		
	
  // perk 2 name -------------
	PREPROC_TEXT_DRAW_ALIGNED_EXP( 36 (PERK_Y_OFFSET+PERK_Y_SPACING) (LOADOUT_WIDTH+8) 20 LOADOUT_ALIGN, ORIGIN_LOADOUT, "@" + tablelookup( "mp/statstable.csv", 1, STAT_CAC_SPECIALTY_WEAPON, 3 ), TEXTSIZE_SMALL, 0, -2, ITEM_ALIGN_MIDDLE_LEFT, COLOR_TITLE )
	
	// perk 2 icon
	PREPROC_SHADER_DRAW_ALIGNED( 0 (PERK_Y_OFFSET+PERK_Y_SPACING) 32 32 LOADOUT_ALIGN, ORIGIN_LOADOUT, tablelookup( "mp/statstable.csv", 1, STAT_CAC_SPECIALTY_WEAPON, 6 ), 1 1 1 0.65, 0, 1, 1 1 1 1) 
	PREPROC_SHADER_DRAW_ALIGNED( -4 (PERK_Y_OFFSET+PERK_Y_SPACING+34) (LOADOUT_WIDTH+8) 1 LOADOUT_ALIGN, ORIGIN_LOADOUT, "white", 1 1 1 0.1, 0, 1, 1 1 1 1) 

	// perk 2 desc
	PREPROC_SHADER_DRAW_ALIGNED( 32 (PERK_Y_OFFSET+PERK_Y_SPACING+16) 14 14 LOADOUT_ALIGN, ORIGIN_LOADOUT, "ui_arrow_right", 1 1 1 0.4, 0, 1, 1 1 1 1) 
	PREPROC_TEXT_DRAW_ALIGNED_EXP( 48 (PERK_Y_OFFSET+PERK_Y_SPACING+15) (LOADOUT_WIDTH+8) 20 LOADOUT_ALIGN, ORIGIN_LOADOUT, "@" + tablelookup("mp/statstable.csv", 1, STAT_CAC_SPECIALTY_WEAPON, 7), PERK_DESC_TEXTSIZE, 0, -2, ITEM_ALIGN_MIDDLE_LEFT, CHOICE_TEXTCOLOR )		
	
  // perk 3 name -------------
	PREPROC_TEXT_DRAW_ALIGNED_EXP( 36 (PERK_Y_OFFSET+(PERK_Y_SPACING*2)) (LOADOUT_WIDTH+8) 20 LOADOUT_ALIGN, ORIGIN_LOADOUT, "@" + tablelookup( "mp/statstable.csv", 1, STAT_CAC_SPECIALTY_ABILITY, 3 ), TEXTSIZE_SMALL, 0, -2, ITEM_ALIGN_MIDDLE_LEFT, COLOR_TITLE )
	
	// perk 3 icon
	PREPROC_SHADER_DRAW_ALIGNED( 0 (PERK_Y_OFFSET+(PERK_Y_SPACING*2)) 32 32 LOADOUT_ALIGN, ORIGIN_LOADOUT, tablelookup( "mp/statstable.csv", 1, STAT_CAC_SPECIALTY_ABILITY, 6 ), 1 1 1 0.65, 0, 1, 1 1 1 1) 
	PREPROC_SHADER_DRAW_ALIGNED( -4 (PERK_Y_OFFSET+34+(PERK_Y_SPACING*2)) (LOADOUT_WIDTH+8) 1 LOADOUT_ALIGN, ORIGIN_LOADOUT, "white", 1 1 1 0.1, 0, 1, 1 1 1 1) 

	// perk 3 desc
	PREPROC_SHADER_DRAW_ALIGNED( 32 (PERK_Y_OFFSET+(PERK_Y_SPACING*2)+16) 14 14 LOADOUT_ALIGN, ORIGIN_LOADOUT, "ui_arrow_right", 1 1 1 0.4, 0, 1, 1 1 1 1) 
	PREPROC_TEXT_DRAW_ALIGNED_EXP( 48 (PERK_Y_OFFSET+(PERK_Y_SPACING*2)+15) (LOADOUT_WIDTH+8) 20 LOADOUT_ALIGN, ORIGIN_LOADOUT, "@" + tablelookup("mp/statstable.csv", 1, STAT_CAC_SPECIALTY_ABILITY, 7), PERK_DESC_TEXTSIZE, 0, -2, ITEM_ALIGN_MIDDLE_LEFT, CHOICE_TEXTCOLOR )		
	
  // grenade name -------------
	#define LOCAL_GRENADE( ptext, visArg ) \
	PREPROC_TEXT_DRAW_ALIGNED_EXP( 36 (PERK_Y_OFFSET+(PERK_Y_SPACING*3)) (LOADOUT_WIDTH+8) 20 LOADOUT_ALIGN, \
	ORIGIN_LOADOUT, ptext, TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, COLOR_TITLE visible when( visArg ); )


	LOCAL_GRENADE( "@PERKS_FRAG_1_" + tablelookup( "mp/statstable.csv" , 0 , STAT_CAC_SPECIAL_GRENADE , 3 ) , tablelookup( "mp/statstable.csv", 1, STAT_CAC_SPECIALTY_EQUIPMENT, 4 ) != "specialty_specialgrenade" && tablelookup( "mp/statstable.csv", 1, STAT_CAC_SPECIALTY_EQUIPMENT, 4 ) != "specialty_fraggrenade" )
	LOCAL_GRENADE( "@PERKS_FRAG_X_1", tablelookup( "mp/statstable.csv", 1, STAT_CAC_SPECIALTY_EQUIPMENT, 4 ) == "specialty_specialgrenade" )
	LOCAL_GRENADE( "@"+tablelookup("mp/statstable.csv",0,STAT_CAC_SPECIAL_GRENADE,3), tablelookup( "mp/statstable.csv", 1, STAT_CAC_SPECIALTY_EQUIPMENT, 4 ) == "specialty_fraggrenade" )

	// grenade icons ------------
	PREPROC_SHADER_DRAW_ALIGNED( 0 (PERK_Y_OFFSET-5+(PERK_Y_SPACING*3)) 32 32 LOADOUT_ALIGN, ORIGIN_LOADOUT, "weapon_fraggrenade", 1 1 1 1, 0, 1, 1 1 1 1 visible when( tablelookup( "mp/statstable.csv", 1, STAT_CAC_SPECIALTY_EQUIPMENT, 4 ) == "specialty_specialgrenade" ) ) 

	PREPROC_SHADER_DRAW_ALIGNED( 0 (PERK_Y_OFFSET-5+(PERK_Y_SPACING*3)) 32 32 LOADOUT_ALIGN, ORIGIN_LOADOUT, "weapon_smokegrenade", 1 1 1 1, 0, 1, 1 1 1 1 visible when( tablelookup("mp/statstable.csv",1,STAT_CAC_SPECIALTY_EQUIPMENT,4)=="specialty_fraggrenade" ) ) 
	
	PREPROC_SHADER_DRAW_ALIGNED( -6 (PERK_Y_OFFSET-5+(PERK_Y_SPACING*3)) 32 32 LOADOUT_ALIGN, ORIGIN_LOADOUT, "weapon_fraggrenade", 1 1 1 1, 0, 1, 1 1 1 1 visible when( tablelookup( "mp/statstable.csv", 1, STAT_CAC_SPECIALTY_EQUIPMENT, 4 ) != "specialty_specialgrenade" && tablelookup( "mp/statstable.csv", 1, STAT_CAC_SPECIALTY_EQUIPMENT, 4 ) != "specialty_fraggrenade" ) ) 
	PREPROC_SHADER_DRAW_ALIGNED( 8 (PERK_Y_OFFSET-5+(PERK_Y_SPACING*3)) 32 32 LOADOUT_ALIGN, ORIGIN_LOADOUT, "weapon_smokegrenade", 1 1 1 1, 0, 1, 1 1 1 1 visible when( tablelookup( "mp/statstable.csv", 1, STAT_CAC_SPECIALTY_EQUIPMENT, 4 ) != "specialty_specialgrenade" && tablelookup( "mp/statstable.csv", 1, STAT_CAC_SPECIALTY_EQUIPMENT, 4 ) != "specialty_fraggrenade" ) )  
