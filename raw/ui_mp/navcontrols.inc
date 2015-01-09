#ifndef ALT_PANEL
#define ALT_PANEL		0
#endif

#ifdef	SPLITSCREEN_ENABLED
	itemDef 	{ 
		style			WINDOW_STYLE_SHADER 
		rect			-320 0 500 64 0 0 
		background		"white" 
		forecolor		0.9 0.9 0.95 0.175 
		visible			1	decoration 	} 
	itemDef 	{ 
		style			WINDOW_STYLE_SHADER 
		rect			180 0 16 -64 0 0 
		origin			0 0 
		background		HIGHLIGHT_SHADER_ART 
		forecolor		0.9 0.9 0.95 0.175 
		visible			1	decoration	}
#endif

#ifdef	PC
	itemDef 	{ 
		style			WINDOW_STYLE_SHADER 
		rect			-120 -32 378 64 0 0 
		background		"white" 
		forecolor		0.9 0.9 0.95 0.175 
		visible			1
		decoration 	} 
	itemDef 	{ 
		style			WINDOW_STYLE_SHADER 
		rect			258 -32 16 -64 0 0 
		origin			0 0 
		background		HIGHLIGHT_SHADER_ART 
		forecolor		0.9 0.9 0.95 0.175 
		visible			1
		decoration	}
		
	itemDef		{
		style			WINDOW_STYLE_SHADER
		rect			56 448 528 40 0 0
		background		"white"
		forecolor		0.9 0.9 0.95 0.175
		visible			1
		decoration	}
	itemDef		{
		style			WINDOW_STYLE_SHADER
		rect			584 448 16 64 0 0
		origin			0 0
		background		HIGHLIGHT_SHADER_ART
		forecolor		0.9 0.9 0.95 0.175
		visible			1
		decoration	}
	itemDef		{
		style			WINDOW_STYLE_SHADER
		rect			40 448 -16 64 0 0
		origin			0 0
		background		HIGHLIGHT_SHADER_ART
		forecolor		0.9 0.9 0.95 0.175
		visible			1
		decoration	}
	itemDef		{
		style			WINDOW_STYLE_SHADER
		rect			-120 464 160 32 0 0
		background		"white"
		forecolor		0.9 0.9 0.95 0.175
		visible			1
		decoration	}
	itemDef		{
		style			WINDOW_STYLE_SHADER
		rect			600 464 160 32 0 0
		background		"white"
		forecolor		0.9 0.9 0.95 0.175
		visible			1
		decoration	}
#endif

#ifndef SPLITSCREEN_ENABLED
#ifndef PC
	itemDef 	{ 
		style			WINDOW_STYLE_SHADER 
		rect			-120 0 420 68 0 0 
		background		"white" 
		forecolor		0.9 0.9 0.95 0.175 
		visible			when( ENABLE_TITLE_BG ); 
		decoration 	} 
	itemDef 	{ 
		style			WINDOW_STYLE_SHADER 
		rect			300 0 16 -68 0 0 
		origin			0 0 
		background		HIGHLIGHT_SHADER_ART 
		forecolor		0.9 0.9 0.95 0.175 
		visible			when( ENABLE_TITLE_BG );
		decoration	}
	itemDef		{
		style			WINDOW_STYLE_SHADER
		rect			-120 414 1200 64 0 0
		background		"white"
		forecolor		0.9 0.9 0.95 0.175
		visible			when( ENABLE_TITLE_BG && ALT_PANEL );
		decoration	}
	itemDef		{
		style			WINDOW_STYLE_SHADER
		rect			-120 416 420 64 0 0
		background		"white"
		forecolor		0.9 0.9 0.95 0.175
		visible			when( ENABLE_TITLE_BG && (ALT_PANEL == 0) );
		decoration	}
	itemDef		{
		style			WINDOW_STYLE_SHADER
		rect			300 416 16 64 0 0
		origin			0 0
		background		HIGHLIGHT_SHADER_ART
		forecolor		0.9 0.9 0.95 0.175
		visible			when( ENABLE_TITLE_BG && (ALT_PANEL == 0) );
		decoration	}
	itemDef		{
		style			WINDOW_STYLE_SHADER
		rect			316 432 440 64 0 0
		background		"white"
		forecolor		0.9 0.9 0.95 0.175
		visible			when( ENABLE_TITLE_BG && (ALT_PANEL == 0) );
		decoration	}
#endif
#endif

#ifdef CONSOLE
		#define LOCAL_NOT_IN_CAC ( !menuisopen("menu_cac_assault") && !menuisopen("menu_cac_heavygunner") && !menuisopen("menu_cac_sniper") && !menuisopen("menu_cac_specops") && !menuisopen("menu_cac_demolitions") )
		#define LOCAL_IN_CAC ( menuisopen("menu_cac_assault") || menuisopen("menu_cac_heavygunner") || menuisopen("menu_cac_sniper") || menuisopen("menu_cac_specops") || menuisopen("menu_cac_demolitions") )
		
		#ifndef BUTTON_Y_FILTER
		#define BUTTON_Y_FILTER		0
		#endif
		
		#undef NAV_FONT
		#ifdef SPLITSCREEN_ENABLED
			#define NAV_FONT	UI_FONT_SMALL
		#else
			#define NAV_FONT	UI_FONT_NORMAL
		#endif	
		
		// change filter Y button for leaderboards
		itemDef
		{
			name			change_filter
			text			"@PLATFORM_CHANGE_FILTER"
			textfont		UI_FONT_NORMAL
			textscale		TEXTSIZE_SMALL
			rect			100 -4 0 0 CHOICE_HORIZONTAL_ALIGN VERTICAL_ALIGN_BOTTOM
			visible			when( BUTTON_Y_FILTER );
			decoration
			execKeyInt BUTTON_Y
			{
				play "mouse_click";
				execNow "toggle lb_filter 0 1";
			}
		}

		#ifndef BUTTON_X_GOTOTOP
		#define BUTTON_X_GOTOTOP	0
		#endif
		
		// jump to top X button for leaderboards
		itemDef
		{
			name			change_filter
			text			"@PLATFORM_GOTOTOP"
			textfont		NAV_FONT
			textscale		TEXTSIZE_SMALL
			textalign		ITEM_ALIGN_CENTER
			rect			0 -4 0 0 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_BOTTOM
			visible			when( BUTTON_X_GOTOTOP );
			decoration
		}
		
		#ifndef BUTTON_PGUP
		#define BUTTON_PGUP		0
		#endif
		#ifndef BUTTON_PGDOWN
		#define BUTTON_PGDOWN	0
		#endif
				
		#ifndef	BUTTON_REFRESH
		#define BUTTON_REFRESH	0
		#endif
				
		// refresh button for systemlink 
		itemDef
		{
			name			refresh
			text			"@PLATFORM_REFRESH"
			textfont		NAV_FONT
			textscale		TEXTSIZE_SMALL
			textalign		ITEM_ALIGN_RIGHT
			rect			-20 -4 0 0 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_BOTTOM
			visible			when( BUTTON_REFRESH );
			decoration
		}		

		// page up and down 
		itemDef
		{
			name			pgup
			text			"@PLATFORM_PGUP"
			textfont		NAV_FONT
			textscale		TEXTSIZE_SMALL
			textalign		ITEM_ALIGN_LEFT
			rect			-190 -4 0 0 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_BOTTOM
			visible			when( BUTTON_PGUP );
			decoration
		}
		itemDef
		{
			name			pgdown
			text			"@PLATFORM_PGDOWN"
			textfont		NAV_FONT
			textscale		TEXTSIZE_SMALL
			textalign		ITEM_ALIGN_LEFT
			rect			-90 -4 0 0 HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_BOTTOM
			visible			when( BUTTON_PGDOWN );
			decoration
		}
		
		
		itemDef {
			style			WINDOW_STYLE_SHADER
			rect			0 -20 16 16 HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_BOTTOM
			origin			0 0
			background		"ui_arrow_left"
			forecolor		1 1 1 1
			visible			1
			decoration
		}
		itemDef
		{
			rect			18 -4 0 0 HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_BOTTOM
			origin			0 0
			text			"@PLATFORM_BACK"
			textfont		NAV_FONT
			textscale		TEXTSIZE_SMALL
			textalign		ITEM_ALIGN_BOTTOM_LEFT
			visible			WHEN( LOCAL_NOT_IN_CAC );
			decoration
		}
		itemDef
		{
			rect			18 -4 0 0 HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_BOTTOM
			origin			0 0
			text			"@PLATFORM_SAVECUSTOMMODE"
			textfont		NAV_FONT
			textscale		TEXTSIZE_SMALL
			textalign		ITEM_ALIGN_BOTTOM_LEFT
			visible			when( LOCAL_IN_CAC );
			decoration
		}		
		
#endif // #ifdef CONSOLE

#ifdef PC

	#ifndef BACK_ENABLE
	#define BACK_ENABLE	1
	#endif

	#ifndef BACK_OPEN
	#define BACK_OPEN	open main_text;
	#endif
	
	itemDef 
	{
		name			back
		text			"@MENU_BACK"
		type			1
		style			WINDOW_STYLE_FILLED
		textstyle		ITEM_TEXTSTYLE_SHADOWED
		rect			-250 -26 40 20 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_BOTTOM
		textfont		UI_FONT_NORMAL
		textalign		ITEM_ALIGN_LEFT
		textscale		TEXTSIZE_SMALL
		textaligny		18
		visible			when(BACK_ENABLE);
		mouseEnter		{ play "mouse_over"; }
		action 
		{
			play "mouse_click";
			close self;
			BACK_OPEN
		}	
	}
	
#endif // #ifdef PC