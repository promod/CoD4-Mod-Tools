		// -------------------- left or right menu selection -----------------------
		itemDef	{
			name			selection_left
			style			WINDOW_STYLE_SHADER
			rect			-120 70 -320 342
			background		"gradient_fadein"
			forecolor		0.9 0.9 0.95 0.15
			visible			1
			decoration
		}
		
		#define LOCAL_FLASH			(sin(milliseconds()*0.0065)+1)
		#define LOCAL_FLASH_LO		LOCAL_FLASH*0.07
		#define LOCAL_FLASH_HI		LOCAL_FLASH*0.35
		#define LOCAL_GLOW_COLOR	0.9 0.95 1 1
		
		//PREPROC_SHADER_DRAW_ALIGNED( -4 12 278 334 RIGHTITEM_ALIGN VERTICAL_ALIGN_TOP, ORIGIN_PLAYERLIST, "gradient_center", LOCAL_GLOW_COLOR, 0, 0, 0 0 0 0 group selection_right exp forecolor A(LOCAL_FLASH_LO) )
		
		PREPROC_SHADER_DRAW_ALIGNED_VIS( -4 14 2 330 RIGHTITEM_ALIGN VERTICAL_ALIGN_TOP, ORIGIN_PLAYERLIST, "white", LOCAL_GLOW_COLOR, 0, 0, 0 0 0 0 group selection_right exp forecolor A(LOCAL_FLASH_HI), 0 )
		PREPROC_SHADER_DRAW_ALIGNED_VIS( 272 14 2 330 RIGHTITEM_ALIGN VERTICAL_ALIGN_TOP, ORIGIN_PLAYERLIST, "white", LOCAL_GLOW_COLOR, 0, 0, 0 0 0 0 group selection_right exp forecolor A(LOCAL_FLASH_HI), 0 )

		PREPROC_SHADER_DRAW_ALIGNED_VIS( -4 12 278 2 RIGHTITEM_ALIGN VERTICAL_ALIGN_TOP, ORIGIN_PLAYERLIST, "gradient_center", LOCAL_GLOW_COLOR, 0, 0, 0 0 0 0 group selection_right exp forecolor A(LOCAL_FLASH_HI), 0 )
		PREPROC_SHADER_DRAW_ALIGNED_VIS( -4 344 278 2 RIGHTITEM_ALIGN VERTICAL_ALIGN_TOP, ORIGIN_PLAYERLIST, "gradient_center", LOCAL_GLOW_COLOR, 0, 0, 0 0 0 0 group selection_right exp forecolor A(LOCAL_FLASH_HI), 0 )
		/*
		PREPROC_SHADER_DRAW_ALIGNED_VIS( -2 324 -20 20 RIGHTITEM_ALIGN VERTICAL_ALIGN_TOP, ORIGIN_PLAYERLIST, "white", LOCAL_GLOW_COLOR, 0, 0, 0 0 0 0 group selection_right exp forecolor A(LOCAL_FLASH_HI), 0 )

		itemDef	{
			group			selection_right
			rect			-2 324 -20 20 RIGHTITEM_ALIGN VERTICAL_ALIGN_TOP
			origin			ORIGIN_PLAYERLIST
			exp 			forecolor A(LOCAL_FLASH)
			text			"@PLATFORM_UI_SELECTBUTTON"
			textalign		ITEM_ALIGN_MIDDLE_LEFT
			textscale		0.33
			forecolor		1 1 1 1
			visible			1
			decoration
		}
		*/
		
/*		itemDef	{
			name			selection_right
			style			WINDOW_STYLE_SHADER
			rect			-20 70 -160 342 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_FULLSCREEN
			origin			0 0
			background		"gradient_fadein"
			forecolor		0.9 0.9 0.95 0.1
			visible			1
			decoration
		}
		itemDef	{
			name			selection_left
			style			WINDOW_STYLE_SHADER
			rect			-32 70 16 342 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_FULLSCREEN
			origin			0 0
			background		"line_horizontal" //"gradient_fadein"
			forecolor		0.8 0.8 1 0.1
			visible			1
			decoration
		}
		itemDef	{
			name			selection_right
			style			WINDOW_STYLE_SHADER
			rect			-24 70 -16 342 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_FULLSCREEN
			origin			0 0
			background		"line_horizontal" //"gradient_fadein"
			forecolor		0.8 0.8 1 0.1
			visible			1
			decoration
		}
		
		itemDef	{
			name			dpad_back
			style			WINDOW_STYLE_SHADER
			rect			-40 -18 40 40 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER
			origin			0 0
			background		"button_dpad_right"
			forecolor		0.7 0.7 0.8 0.175
			visible			1
			decoration
		}
		itemDef	{
			name			dpad_right
			style			WINDOW_STYLE_SHADER
			rect			-36 -14 32 32 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER
			origin			0 0
			background		"button_dpad_right"
			forecolor		0.5 0.5 0.5 1
			visible			1
			decoration
		}
		itemDef	{
			name			dpad_left
			style			WINDOW_STYLE_SHADER
			rect			-36 -14 32 32 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_CENTER
			origin			0 0
			background		"button_dpad_left"
			forecolor		0.5 0.5 0.5 1
			visible			1
			decoration
		}
*/