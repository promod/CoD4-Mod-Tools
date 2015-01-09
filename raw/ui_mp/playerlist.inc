#define ORIGIN_COLUMN_RANK_X 0
#define ORIGIN_COLUMN_NAME_X 32
#define ORIGIN_COLUMN_SCORE_X 236
#define COLUMN_RANK_WIDTH 36
#define COLUMN_NAME_WIDTH 256
#define COLUMN_SCORE_WIDTH 34

#define LIST_BOX_WIDTH		278
#define LIST_BOX_HEIGHT		334//326
#define LIST_BOX_SIZE 		LIST_BOX_WIDTH LIST_BOX_HEIGHT

#define COLUMN_HEADER_COLOR 0.6 0.6 0.6 1

#ifndef PLAYERLIST_SELECTED_ACTIONS
	#define PLAYERLIST_SELECTED_ACTIONS ;
#endif

#ifndef PLAYERLIST_SCOREVIS
	#define PLAYERLIST_SCOREVIS ((!dvarbool( party_timerVisible ) || !dvarbool( party_teambased ) || !dvarbool( party_autoteams )) && !dvarInt( splitscreen ))
#endif

#ifdef PARTY_THEME
	#define PLATING_COLOR		0.3 0.225 0.2 1
	#define HL_COLOR			1 0.85 0.825 0.2
	#define PARTY_LABEL_COLOR	1 0.925 0.7 0.07
	#define PARTY_LABEL			"@MENU_PARTY"
	#define PARTY_LABEL_SCALE	1.75
#else
	#define PLATING_COLOR		0.175 0.2 0.25 1
	#define HL_COLOR			0.85 0.85 0.925 0.2
	#define PARTY_LABEL_COLOR	0.9 0.925 1 0.07
	#define PARTY_LABEL			"@MENU_LOBBY"
	#define PARTY_LABEL_SCALE	1.75
#endif

#ifdef SPLITSCREEN_PLAYERLIST

	#undef PLATING_COLOR		
	#undef HL_COLOR			
	#undef PARTY_LABEL_COLOR	
	#undef PARTY_LABEL			
	#undef PARTY_LABEL_SCALE	
	#define PLATING_COLOR		0.2 0.2 0.225 1
	#define HL_COLOR			0.85 0.85 0.925 0.2
	#define PARTY_LABEL_COLOR	0.9 0.925 1 0.07
	#define PARTY_LABEL			""
	#define PARTY_LABEL_SCALE	1.75
	
	#ifndef PS3
		#undef	LIST_BOX_HEIGHT
		#define LIST_BOX_HEIGHT		149
	#else
		#undef	LIST_BOX_HEIGHT
		#define LIST_BOX_HEIGHT		310
	#endif
#endif

#ifdef XENON

#define PLAYERLIST_PLAYERFEEDER( feederName, feederArg, yOffsetArg, heightArg, backColorArg, actionsArg, visArg ) \	
	itemDef	{ \
		name			feederName \
		feeder			feederArg \
		type			ITEM_TYPE_LISTBOX \
		rect			ORIGIN_COLUMN_NAME_X yOffsetArg COLUMN_NAME_WIDTH heightArg RIGHTITEM_ALIGN VERTICAL_ALIGN_TOP \
		origin			ORIGIN_PLAYERLIST \
		elementwidth	COLUMN_NAME_WIDTH \
		elementheight	18 \
		textfont		UI_FONT_DEFAULT \
		textscale		TEXTSIZE_SMALL \
		backcolor		backColorArg \
			forecolor		CHOICE_TEXTCOLOR \
			outlinecolor	HL_COLOR \
			selectBorder	0.8 0.95 1 0 \
		visible			when( visArg ) \
		columns			1		6		(PLAYERLIST_WIDTH-COLUMN_NAME_WIDTH) 40			0 \
		noscrollbars \
		onFocus	{ \
			play "mouse_over"; \
			exec "set ui_hint_text @MPUI_DESC_PLAYER_OPTIONS"; \
			hide selection_left; \
			show selection_right; \
		} \
		actionsArg \
	}
#else // #ifdef XENON

#define PLAYERLIST_PLAYERFEEDER( feederName, feederArg, yOffsetArg, heightArg, backColorArg, actionsArg, visArg ) \	
	itemDef	{ \
		name			feederName \
		feeder			feederArg \
		type			ITEM_TYPE_LISTBOX \
		rect			ORIGIN_COLUMN_NAME_X yOffsetArg COLUMN_NAME_WIDTH heightArg RIGHTITEM_ALIGN VERTICAL_ALIGN_TOP \
		origin			ORIGIN_PLAYERLIST \
		elementwidth	COLUMN_NAME_WIDTH \
		elementheight	18 \
		textfont		UI_FONT_DEFAULT \
		textscale		TEXTSIZE_SMALL \
		backcolor		backColorArg \
			forecolor		CHOICE_TEXTCOLOR \
			outlinecolor	HL_COLOR \
			selectBorder	0.8 0.95 1 0 \
		visible			when( visArg ) \
		columns			1		6		(PLAYERLIST_WIDTH-COLUMN_NAME_WIDTH) 40			0 \
		noscrollbars \
		actionsArg \
		onFocus	{ \
			hide selection_left; \
			show selection_right; \
		} \
	}
#endif // #else #ifdef XENON
	


#define PLAYERLIST_SCOREFEEDER( feederArg, yOffsetArg, heightArg, visArg ) \	
	itemDef { \
		feeder			feederArg \
		type			ITEM_TYPE_LISTBOX \
		rect			ORIGIN_COLUMN_SCORE_X yOffsetArg COLUMN_SCORE_WIDTH heightArg RIGHTITEM_ALIGN VERTICAL_ALIGN_TOP \
		origin			ORIGIN_PLAYERLIST \
		elementwidth	COLUMN_SCORE_WIDTH \
		elementheight	18 \
		textfont		UI_FONT_NORMAL \
		textscale		TEXTSIZE_SMALL \
		forecolor		1 1 1 0.65 \	
		noscrollbars \
		columns			1		-4		COLUMN_SCORE_WIDTH		5		ITEM_ALIGN_RIGHT \
		visible 		when( visArg ) \
		decoration \
		onFocus	{ \
			hide selection_left; \
			show selection_right; \
		} \
	}

#define PLAYERLIST_TALKFEEDER( feederArg, yOffsetArg, heightArg, visArg ) \	
	itemDef	{ \
		feeder			feederArg \
		type			ITEM_TYPE_LISTBOX \
		rect			-16 yOffsetArg 16 heightArg RIGHTITEM_ALIGN VERTICAL_ALIGN_TOP \
		origin			ORIGIN_PLAYERLIST \
		elementwidth	18 \
		elementheight	18 \
		visible			when( visArg ) \
		noscrollbars \
		decoration \
		onFocus	{ \
			hide selection_left; \
			show selection_right; \
		} \
	}
#define PLAYERLIST_RANKFEEDER( feederArg, yOffsetArg, heightArg, visArg ) \
	itemDef	{ \
		feeder			feederArg \
		type			ITEM_TYPE_LISTBOX \
		rect			ORIGIN_COLUMN_RANK_X yOffsetArg 36 heightArg RIGHTITEM_ALIGN VERTICAL_ALIGN_TOP \
		origin			ORIGIN_PLAYERLIST \
		elementwidth	18 \
		elementheight	18 \
		textfont		UI_FONT_DEFAULT \
		textscale		TEXTSIZE_SMALL \
		textstyle 		ITEM_TEXTSTYLE_SHADOWED \
		textaligny		0 \
		textalignx		16 \
		forecolor		1 1 1 1 \
		noscrollbars \
		columns	2		0		18		3		ITEM_ALIGN_RIGHT \
						0		18		2		ITEM_ALIGN_CENTER \				
		visible			when( visArg ) \
		decoration \
		onFocus	{ \
			hide selection_left; \
			show selection_right; \
		} \
	}
			
		itemDef
		{
			type			ITEM_TYPE_TEXT
			visible			1
			rect			0 352 0 0 RIGHTITEM_ALIGN VERTICAL_ALIGN_TOP
			origin			ORIGIN_PLAYERLIST
			text			PARTY_LABEL
			align			ITEM_ALIGN_LEFT
			textstyle		ITEM_TEXTSTYLE_SHADOWED
			textfont		UI_FONT_DEFAULT
			textscale		PARTY_LABEL_SCALE
			forecolor		PARTY_LABEL_COLOR
			visible 		1
			decoration
		}
			
		// UI art
		PREPROC_SHADER_DRAW_ALIGNED( -4 12 LIST_BOX_SIZE RIGHTITEM_ALIGN VERTICAL_ALIGN_TOP, ORIGIN_PLAYERLIST, "gradient_center", 0.3 0.3 0.325 0.6, 0, 0, 0 0 0 0 )
	#ifdef SPLITSCREEN_PLAYERLIST
		PREPROC_SHADER_DRAW_ALIGNED( -24 -4 -20 (326+16) RIGHTITEM_ALIGN VERTICAL_ALIGN_TOP, ORIGIN_PLAYERLIST, "gradient", 1 1 1 0.65, 0, 0, 0 0 0 0 )
		PREPROC_SHADER_DRAW_ALIGNED( 274 -4 20 (326+16) RIGHTITEM_ALIGN VERTICAL_ALIGN_TOP, ORIGIN_PLAYERLIST, "gradient", 1 1 1 0.65, 0, 0, 0 0 0 0 )
	#else
		PREPROC_SHADER_DRAW_ALIGNED( -24 -4 -20 (LIST_BOX_HEIGHT+8) RIGHTITEM_ALIGN VERTICAL_ALIGN_TOP, ORIGIN_PLAYERLIST, "gradient", 1 1 1 0.65, 0, 0, 0 0 0 0 )
		PREPROC_SHADER_DRAW_ALIGNED( 274 -4 20 (LIST_BOX_HEIGHT+24) RIGHTITEM_ALIGN VERTICAL_ALIGN_TOP, ORIGIN_PLAYERLIST, "gradient", 1 1 1 0.65, 0, 0, 0 0 0 0 )
	#endif
		
		PREPROC_SHADER_DRAW_ALIGNED( -4 -4 278 16 RIGHTITEM_ALIGN VERTICAL_ALIGN_TOP, ORIGIN_PLAYERLIST, "white", PLATING_COLOR, 0, 0, 0 0 0 0 )
		PREPROC_SHADER_DRAW_ALIGNED( -4 -4 278 16 RIGHTITEM_ALIGN VERTICAL_ALIGN_TOP, ORIGIN_PLAYERLIST, "line_horizontal", 0.9 0.9 0.95 0.5, 0, 0, 0 0 0 0 )
		PREPROC_SHADER_DRAW_ALIGNED( -4 12 278 16 RIGHTITEM_ALIGN VERTICAL_ALIGN_TOP, ORIGIN_PLAYERLIST, "gradient_top", 1 1 1 0.2, 0, 0, 0 0 0 0 )
	
	#ifdef SPLITSCREEN_PLAYERLIST	
		PREPROC_SHADER_DRAW_ALIGNED( -4 (LIST_BOX_HEIGHT+12) 278 16 RIGHTITEM_ALIGN VERTICAL_ALIGN_TOP, ORIGIN_PLAYERLIST, "white", PLATING_COLOR, 0, 0, 0 0 0 0 )
		PREPROC_SHADER_DRAW_ALIGNED( -4 (LIST_BOX_HEIGHT+12) 278 16 RIGHTITEM_ALIGN VERTICAL_ALIGN_TOP, ORIGIN_PLAYERLIST, "line_horizontal", 0.9 0.9 0.95 0.5, 0, 0, 0 0 0 0 )
	#else	
		PREPROC_SHADER_DRAW_ALIGNED( -4 (LIST_BOX_HEIGHT+12) 278 8 RIGHTITEM_ALIGN VERTICAL_ALIGN_TOP, ORIGIN_PLAYERLIST, "white", PLATING_COLOR, 0, 0, 0 0 0 0 )
		PREPROC_SHADER_DRAW_ALIGNED( -4 (LIST_BOX_HEIGHT+12) 278 8 RIGHTITEM_ALIGN VERTICAL_ALIGN_TOP, ORIGIN_PLAYERLIST, "line_horizontal", 0.9 0.9 0.95 0.5, 0, 0, 0 0 0 0 )
	#endif	
		PREPROC_SHADER_DRAW_ALIGNED( -4 (LIST_BOX_HEIGHT-4) 278 16 RIGHTITEM_ALIGN VERTICAL_ALIGN_TOP, ORIGIN_PLAYERLIST, "gradient_bottom", 1 1 1 0.2, 0, 0, 0 0 0 0 )
		
//		PREPROC_SHADER_DRAW_ALIGNED( ORIGIN_PLAYERLIST 274 400 RIGHTITEM_ALIGN VERTICAL_ALIGN_TOP, -4 16, "gradient_center", 0.3 0.3 0.3 0.65, 0, 0, 0 0 0 0 )
//		PREPROC_SHADER_DRAW_ALIGNED( ORIGIN_PLAYERLIST -16 400 RIGHTITEM_ALIGN VERTICAL_ALIGN_TOP, -20 16, "gradient", 1 1 1 0.5, 0, 0, 0 0 0 0 )
//		PREPROC_SHADER_DRAW_ALIGNED( ORIGIN_PLAYERLIST 16 400 RIGHTITEM_ALIGN VERTICAL_ALIGN_TOP, 290 16, "gradient", 1 1 1 0.5, 0, 0, 0 0 0 0 )

		//PREPROC_SHADER_DRAW_ALIGNED( ORIGIN_PLAYERLIST 80 20 RIGHTITEM_ALIGN VERTICAL_ALIGN_TOP, 0 0, "ui_perforation", 1 1 1 1, 0, 2, 1 1 1 1 )
		//PREPROC_SHADER_DRAW_ALIGNED( ORIGIN_PLAYERLIST -80 20 RIGHTITEM_ALIGN VERTICAL_ALIGN_TOP, 0 0, "ui_perforation", 1 1 1 1, 0, 2, 1 1 1 1 )
	
	#ifndef SPLITSCREEN_PLAYERLIST
		itemDef
		{
			type			ITEM_TYPE_TEXT
			visible			1
			rect			ORIGIN_COLUMN_RANK_X 0 0 0 RIGHTITEM_ALIGN VERTICAL_ALIGN_TOP
			origin			ORIGIN_PLAYERLIST
			text			"@MPUI_RANK"
			align			ITEM_ALIGN_LEFT
			textstyle		ITEM_TEXTSTYLE_SHADOWED
			textfont		UI_FONT_DEFAULT
			textscale		TEXTSIZE_SMALL
			textaligny 		12
			forecolor		COLUMN_HEADER_COLOR
			visible 		1
			decoration
		}
	
		itemDef
		{
			type			ITEM_TYPE_TEXT
			rect			ORIGIN_COLUMN_NAME_X 0 0 0 RIGHTITEM_ALIGN VERTICAL_ALIGN_TOP
			origin			ORIGIN_PLAYERLIST
			text			"@MPUI_NAME"
			align			ITEM_ALIGN_LEFT
			textstyle		ITEM_TEXTSTYLE_SHADOWED
			textfont		UI_FONT_DEFAULT
			textscale		TEXTSIZE_SMALL
			textalignx		6
			textaligny 		12
			forecolor		COLUMN_HEADER_COLOR
			visible 		1
			decoration
		}		
		itemDef
		{
			type			ITEM_TYPE_TEXT
			rect			ORIGIN_COLUMN_SCORE_X 0 30 0 RIGHTITEM_ALIGN VERTICAL_ALIGN_TOP
			origin			ORIGIN_PLAYERLIST
			text			"@MPUI_SCORE"
			align			ITEM_ALIGN_RIGHT
			textstyle		ITEM_TEXTSTYLE_SHADOWED
			textfont		UI_FONT_DEFAULT
			textscale		TEXTSIZE_SMALL
			textaligny 		12
			forecolor		COLUMN_HEADER_COLOR
			visible 		when( PLAYERLIST_SCOREVIS )
			decoration
		}
	#else
		itemDef
		{
			type			ITEM_TYPE_TEXT
			rect			ORIGIN_COLUMN_NAME_X 0 0 0 RIGHTITEM_ALIGN VERTICAL_ALIGN_TOP
			origin			ORIGIN_PLAYERLIST
			text			"@MPUI_NAME"
			align			ITEM_ALIGN_LEFT
			textstyle		ITEM_TEXTSTYLE_SHADOWED
			textfont		UI_FONT_DEFAULT
			textscale		TEXTSIZE_SMALL
			textalignx		-20//6
			textaligny 		12
			forecolor		COLUMN_HEADER_COLOR
			visible 		1
			decoration
		}		
		itemDef
		{
			type			ITEM_TYPE_TEXT
			rect			ORIGIN_COLUMN_SCORE_X 0 30 0 RIGHTITEM_ALIGN VERTICAL_ALIGN_TOP
			origin			ORIGIN_PLAYERLIST
			text			"@MPUI_SCORE"
			align			ITEM_ALIGN_RIGHT
			textstyle		ITEM_TEXTSTYLE_SHADOWED
			textfont		UI_FONT_DEFAULT
			textscale		TEXTSIZE_SMALL
			textalignx		-26
			textaligny 		12
			forecolor		COLUMN_HEADER_COLOR
			visible 		when( PLAYERLIST_SCOREVIS )
			decoration
		}
	#endif


		
	#ifndef SPLITSCREEN_PLAYERLIST
	
		#define PLAYERLIST_PARTYVIS ((!dvarbool( party_timerVisible ) || !dvarbool( party_teambased ) || !dvarbool( party_autoteams )) && !InLobby())
		#define PLAYERLIST_MEMBERVIS ((!dvarbool( party_timerVisible ) || !dvarbool( party_teambased ) || !dvarbool( party_autoteams )) && InLobby())
		#define PLAYERLIST_TEAMSVIS (dvarbool( party_timerVisible ) && dvarbool( party_teambased ) && dvarbool( party_autoteams ))
		// && (tableLookup( "mp/mapsTable.csv", 0, dvarString( "ui_mapname" ), 1 ) == setting) && player( teamname ) == "TEAM_ALLIES" ); \

		PLAYERLIST_PLAYERFEEDER( "partyList", FEEDER_PARTY_MEMBERS, 14, 324, 0.5 0.5 0.5 0, PLAYERLIST_SELECTED_ACTIONS, PLAYERLIST_PARTYVIS )
		PLAYERLIST_TALKFEEDER( FEEDER_PARTY_MEMBERS_TALK, 14, 324, PLAYERLIST_PARTYVIS )
		PLAYERLIST_RANKFEEDER( FEEDER_PARTY_MEMBERS_RANK, 14, 324, PLAYERLIST_PARTYVIS )

		PLAYERLIST_SCOREFEEDER( FEEDER_LOBBY_MEMBERS_STAT, 14, 324, PLAYERLIST_SCOREVIS && PLAYERLIST_MEMBERVIS )
		PLAYERLIST_PLAYERFEEDER( "lobbyList", FEEDER_LOBBY_MEMBERS, 14, 324, 0.5 0.5 0.5 0, PLAYERLIST_SELECTED_ACTIONS, PLAYERLIST_MEMBERVIS )
		PLAYERLIST_TALKFEEDER( FEEDER_LOBBY_MEMBERS_TALK, 14, 324, PLAYERLIST_MEMBERVIS )
		PLAYERLIST_RANKFEEDER( FEEDER_LOBBY_MEMBERS_RANK, 14, 324, PLAYERLIST_MEMBERVIS )

		PLAYERLIST_SCOREFEEDER( FEEDER_MYTEAM_MEMBERS_STAT, 14, 162, PLAYERLIST_SCOREVIS && PLAYERLIST_TEAMSVIS )
		PLAYERLIST_PLAYERFEEDER( "myMembersList", FEEDER_MYTEAM_MEMBERS, 14, 162, COLOR_USMC 0.5, PLAYERLIST_SELECTED_ACTIONS, PLAYERLIST_TEAMSVIS && ((tableLookup( "mp/mapsTable.csv", 0, dvarString( "ui_mapname" ), 1 ) == "desert") && player( teamname ) == "TEAM_ALLIES") )
		PLAYERLIST_PLAYERFEEDER( "myMembersList", FEEDER_MYTEAM_MEMBERS, 14, 162, COLOR_SAS 0.5, PLAYERLIST_SELECTED_ACTIONS, PLAYERLIST_TEAMSVIS && ((tableLookup( "mp/mapsTable.csv", 0, dvarString( "ui_mapname" ), 1 ) != "desert") && player( teamname ) == "TEAM_ALLIES") )
		PLAYERLIST_PLAYERFEEDER( "myMembersList", FEEDER_MYTEAM_MEMBERS, 14, 162, COLOR_ARAB 0.5, PLAYERLIST_SELECTED_ACTIONS, PLAYERLIST_TEAMSVIS && ((tableLookup( "mp/mapsTable.csv", 0, dvarString( "ui_mapname" ), 1 ) == "desert") && player( teamname ) == "TEAM_AXIS") )
		PLAYERLIST_PLAYERFEEDER( "myMembersList", FEEDER_MYTEAM_MEMBERS, 14, 162, COLOR_USSR 0.5, PLAYERLIST_SELECTED_ACTIONS, PLAYERLIST_TEAMSVIS && ((tableLookup( "mp/mapsTable.csv", 0, dvarString( "ui_mapname" ), 1 ) != "desert") && player( teamname ) == "TEAM_AXIS") )
		PLAYERLIST_TALKFEEDER( FEEDER_MYTEAM_MEMBERS_TALK, 14, 162, PLAYERLIST_TEAMSVIS )
		PLAYERLIST_RANKFEEDER( FEEDER_MYTEAM_MEMBERS_RANK, 14, 162, PLAYERLIST_TEAMSVIS )

		PLAYERLIST_SCOREFEEDER( FEEDER_ENEMY_MEMBERS_STAT, (14 + 0 + 162), 162, PLAYERLIST_SCOREVIS && PLAYERLIST_TEAMSVIS )
		PLAYERLIST_PLAYERFEEDER( "enemyMembersList", FEEDER_ENEMY_MEMBERS, (14 + 0 + 162), 162, COLOR_ARAB 0.5, PLAYERLIST_SELECTED_ACTIONS, PLAYERLIST_TEAMSVIS && ((tableLookup( "mp/mapsTable.csv", 0, dvarString( "ui_mapname" ), 1 ) == "desert") && player( teamname ) == "TEAM_ALLIES") )
		PLAYERLIST_PLAYERFEEDER( "enemyMembersList", FEEDER_ENEMY_MEMBERS, (14 + 0 + 162), 162, COLOR_USSR 0.5, PLAYERLIST_SELECTED_ACTIONS, PLAYERLIST_TEAMSVIS && ((tableLookup( "mp/mapsTable.csv", 0, dvarString( "ui_mapname" ), 1 ) != "desert") && player( teamname ) == "TEAM_ALLIES") )
		PLAYERLIST_PLAYERFEEDER( "enemyMembersList", FEEDER_ENEMY_MEMBERS, (14 + 0 + 162), 162, COLOR_USMC 0.5, PLAYERLIST_SELECTED_ACTIONS, PLAYERLIST_TEAMSVIS && ((tableLookup( "mp/mapsTable.csv", 0, dvarString( "ui_mapname" ), 1 ) == "desert") && player( teamname ) == "TEAM_AXIS") )
		PLAYERLIST_PLAYERFEEDER( "enemyMembersList", FEEDER_ENEMY_MEMBERS, (14 + 0 + 162), 162, COLOR_SAS 0.5, PLAYERLIST_SELECTED_ACTIONS, PLAYERLIST_TEAMSVIS && ((tableLookup( "mp/mapsTable.csv", 0, dvarString( "ui_mapname" ), 1 ) != "desert") && player( teamname ) == "TEAM_AXIS") )
		PLAYERLIST_TALKFEEDER( FEEDER_ENEMY_MEMBERS_TALK, (14 + 0 + 162), 162, PLAYERLIST_TEAMSVIS )
		PLAYERLIST_RANKFEEDER( FEEDER_ENEMY_MEMBERS_RANK, (14 + 0 + 162), 162, PLAYERLIST_TEAMSVIS )

		// && (tableLookup( "mp/mapsTable.csv", 0, dvarString( "ui_mapname" ), 1 ) == setting) && player( teamname ) == "TEAM_ALLIES" ); \


	#else

		#undef ORIGIN_COLUMN_NAME_X
		#define ORIGIN_COLUMN_NAME_X 6
		PLAYERLIST_PLAYERFEEDER( "splitscreen_playerlist", FEEDER_SPLITSCREENPLAYERS, 14, 324, 0.5 0.5 0.5 0, decoration, 1 )
		
	#endif
	
	// private party host icon
	
	#ifdef SHOW_PRIVATE_PARTY_HOST
		PREPROC_SHADER_DRAW_ALIGNED( 252 17 18 18 RIGHTITEM_ALIGN VERTICAL_ALIGN_TOP, ORIGIN_PLAYERLIST, "ui_host", 0.825 0.825 0.825 0.7, 0, 0, 0 0 0 0 )
	#endif	
	
/*
#define TEAM_LIST( setting, alliesColor, axisColor ) \
	itemDef \
	{ \
		type			ITEM_TYPE_LISTBOX \
		feeder			FEEDER_MYTEAM_MEMBERS \
		rect			362 MEMBER_LIST_Y 240 MEMBER_LIST_HEIGHT2 HORIZONTAL_ALIGN_DEFAULT VERTICAL_ALIGN_DEFAULT \
		origin			0 -2 \
		elementwidth	208 \
		elementheight	ELEMENT_HEIGHT \
		textfont		UI_FONT_NORMAL \
		textscale		TEXTSIZE_SMALL \
		forecolor		1 1 1 0.65 \
		outlinecolor	0.3 0.35 0.55 0.25 \
		backcolor		alliesColor 0.5 \
		visible when ( dvarbool( party_timerVisible ) && dvarbool( party_teambased ) && dvarbool( party_autoteams ) && (tableLookup( "mp/mapsTable.csv", 0, dvarString( "ui_mapname" ), 1 ) == setting) && player( teamname ) == "TEAM_ALLIES" ); \
		columns	1		50		170			40 0\
		noscrollbars \
		doubleClick \
		{ \
			open player_popup; \
		} \
	} \
	itemDef \
	{ \
		type			ITEM_TYPE_LISTBOX \
		feeder			FEEDER_MYTEAM_MEMBERS \
		rect			362 MEMBER_LIST_Y 240 MEMBER_LIST_HEIGHT2 HORIZONTAL_ALIGN_DEFAULT VERTICAL_ALIGN_DEFAULT \
		origin			0 -2 \
		elementwidth	208 \
		elementheight	ELEMENT_HEIGHT \
		textfont		UI_FONT_NORMAL \
		textscale		TEXTSIZE_SMALL \
		textaligny	0 \
		forecolor		1 1 1 0.65 \
		outlinecolor	0.3 0.35 0.55 0.25 \
		backcolor		axisColor 0.5 \
		visible when ( dvarbool( party_timerVisible ) && dvarbool( party_teambased ) && dvarbool( party_autoteams ) && (tableLookup( "mp/mapsTable.csv", 0, dvarString( "ui_mapname" ), 1 ) == setting) && player( teamname ) == "TEAM_AXIS" ); \
		columns	1		50		170			40 0\
		noscrollbars \
		doubleClick \
		{ \
			open player_popup; \
		} \
	}

#define OTHERTEAM_LIST( setting, alliesColor, axisColor ) \
	itemDef \
	{ \
		type			ITEM_TYPE_LISTBOX \
		feeder			FEEDER_ENEMY_MEMBERS \
		rect			362 MEMBER_LIST_Y2 240 MEMBER_LIST_HEIGHT2 HORIZONTAL_ALIGN_DEFAULT VERTICAL_ALIGN_DEFAULT \
		elementwidth	208 \
		elementheight	ELEMENT_HEIGHT \
		textfont		UI_FONT_NORMAL \
		textscale		TEXTSIZE_SMALL \
		textaligny	0 \
		forecolor		1 1 1 0.65 \
		outlinecolor	0.3 0.35 0.55 0.25 \
		backcolor		axisColor 0.5 \
		visible when ( dvarbool( party_timerVisible ) && dvarbool( party_teambased ) && dvarbool( party_autoteams ) && (tableLookup( "mp/mapsTable.csv", 0, dvarString( "ui_mapname" ), 1 ) == setting) && player( teamname ) == "TEAM_ALLIES" ); \
		columns	1		50		170			40 0 \
		noscrollbars \
		doubleClick \
		{ \
			open player_popup; \
		} \
	} \
	itemDef \
	{ \
		type			ITEM_TYPE_LISTBOX \
		feeder			FEEDER_ENEMY_MEMBERS \
		rect			362 MEMBER_LIST_Y2 240 MEMBER_LIST_HEIGHT2 HORIZONTAL_ALIGN_DEFAULT VERTICAL_ALIGN_DEFAULT \
		elementwidth	208 \
		elementheight	ELEMENT_HEIGHT \
		textfont		UI_FONT_NORMAL \
		textscale		TEXTSIZE_SMALL \
		forecolor		1 1 1 0.65 \
		outlinecolor	0.3 0.35 0.55 0.25 \
		backcolor		alliesColor 0.5 \
		visible when ( dvarbool( party_timerVisible ) && dvarbool( party_teambased ) && dvarbool( party_autoteams ) && (tableLookup( "mp/mapsTable.csv", 0, dvarString( "ui_mapname" ), 1 ) == setting) && player( teamname ) == "TEAM_AXIS" ); \
		columns	1		50		170			40 0 \
		noscrollbars \
		doubleClick \
		{ \
			open player_popup; \
		} \
	}
*/

		/*
		TEAM_LIST( "desert", COLOR_USMC, COLOR_ARAB )
		TEAM_LIST( "woodland", COLOR_SAS, COLOR_USSR)
		TEAM_LIST( "urban", COLOR_SAS, COLOR_USSR )
		OTHERTEAM_LIST( "desert", COLOR_USMC, COLOR_ARAB )
		OTHERTEAM_LIST( "woodland", COLOR_SAS, COLOR_USSR)
		OTHERTEAM_LIST( "urban", COLOR_SAS, COLOR_USSR )
		*/
		



