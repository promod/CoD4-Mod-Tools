#define CAC_POPUP( nameArg, xArg, yArg ) \
	menuDef	 \
	{ \
		IMPROVED_POPUP_SETUP_ONOPEN( nameArg, 5, xArg, yArg, ;, ;, 1 ) \
		PREPROC_SHADER_DRAW_ALIGNED( -4 -24 (CHOICE_POPUP_WIDTH) 22 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "white", 0.15 0.15 0.17 1, 1, 2, CHOICE_POPUP_BORDER_COLOR ) \
		PREPROC_TEXT_DRAW_ALIGNED_EXP( 8 -22 (CHOICE_POPUP_WIDTH-4) 22 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, -32 0, "@MPUI_YOUR_CLASSES", TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_RIGHT, CHOICE_TEXTCOLOR ) \
		/* pointer icon */ \
		PREPROC_SHADER_DRAW_ALIGNED( 200 -14 16 8 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "hitech_arrow_down", 0.9 0.9 0.95 0.4, 0, 2, CHOICE_POPUP_BORDER_COLOR ) \
		CHOICE_BUTTON( 1, dvarString(customclass1), open "menu_cac_assault"; ) \
		CHOICE_BUTTON( 2, dvarString(customclass2), open "menu_cac_specops"; exec "statset 210 1"; ) \
		CHOICE_NEWICON_VIS( 2, "specialty_new", when( stat(210) == 0 ) ) \
		CHOICE_BUTTON( 3, dvarString(customclass3), open "menu_cac_heavygunner"; exec "statset 220 1"; ) \
		CHOICE_NEWICON_VIS( 3, "specialty_new", when( stat(220) == 0 ) ) \
		CHOICE_BUTTON( 4, dvarString(customclass4), open "menu_cac_demolitions"; exec "statset 230 1"; ) \
		CHOICE_NEWICON_VIS( 4, "specialty_new", when( stat(230) == 0 ) ) \
		CHOICE_BUTTON( 5, dvarString(customclass5), open "menu_cac_sniper"; exec "statset 240 1"; ) \
		CHOICE_NEWICON_VIS( 5, "specialty_new", when( stat(240) == 0 ) ) \
	}