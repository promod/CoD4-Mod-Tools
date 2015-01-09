#ifdef PC
	#ifndef STYLE2_NOPOSITION
		#undef CHOICE_SIZE_X
		#define CHOICE_SIZE_X 				220
		
		#undef CHOICE_SIZE_Y
		#define CHOICE_SIZE_Y 				22
	
		#define CHOICE_TEXT_OFFSET_X		(-(CHOICE_SIZE_Y-12))
		#define CHOICE_ACCEPT_ALIGN_X		-2
	
		#define	CHOICE_TEXTALIGN			ITEM_ALIGN_MIDDLE_RIGHT
		
		#undef CHOICE_SEP_OFFSET_Y
		#define CHOICE_SEP_OFFSET_Y			-2
		
		#define TEXTBUTTON_COLOR			0.9 0.9 0.92 0.75
		
		#define TEXTSIZE_BUTTON_PC			0.4
		
		#define ORIGIN_OPTIONS_FRAME		220 0
		
		#define CHOICE_DVAR_TEXTALIGN		ITEM_ALIGN_MIDDLE_LEFT
		#define	CHOICE_DVAR_OFFSET_X		(CHOICE_SIZE_X+20)
		#define CHOICE_DVAR_WIDTH_OFFSET	120
		
		#ifdef OPTIONS_STYLE
			#undef	CHOICE_X_START
			#define CHOICE_X_START			0
			#undef  CHOICE_Y_START
			#define CHOICE_Y_START			10
	
			#define LOCAL_CLOSE_ALL \
				close options_look; \
				close options_move; \
				close options_shoot; \
				close options_misc; \
				close options_graphics; \
				close options_sound; \
				close options_game; \
				close options_view; \
				close options_defaults; \
				close options_driverinfo; \
				close options_credits; \
				close options_multi; \
				close options_graphics_defaults; \
				close options_graphics_texture; \
				close options_control_defaults; \
				close options_voice; \
				close options_multi; \
				close controls_multi; \
				close main_options; \
				close main_controls;
		#endif
		
		// disable the other positioning overrides
		#undef STYLE2_NOPOSITION
		#define STYLE2_NOPOSITION			1
		#undef SPLITSCREEN_ENABLED
		
	#endif

	#define TITLE_X_OFFSET				-36
	#define TITLE_Y_OFFSET				-36	
	
#endif

// position setting
#ifndef STYLE2_NOPOSITION
	#undef CHOICE_SIZE_X
	#define CHOICE_SIZE_X 224
	#undef CHOICE_SIZE_Y
	#define CHOICE_SIZE_Y 22
	#define CHOICE_TEXT_OFFSET_X	(0 - (4+CHOICE_SIZE_Y))
	#define CHOICE_ACCEPT_ALIGN_X	-2
	#define CHOICE_ACCEPT_ALIGN_Y	0
	
	#define	A_BUTTON_OFFSET_Y		1
	
	#define	CHOICE_TEXTALIGN		ITEM_ALIGN_MIDDLE_RIGHT
	#define ALT_HINT_X_OFFSET		-(CHOICE_SIZE_Y)
	#undef CHOICE_SEP_OFFSET_Y
	#define CHOICE_SEP_OFFSET_Y		-2
	#define NEW_X_OFFSET			2
#endif

#ifdef PC
	#undef CHOICE_TEXTSIZE
	#define CHOICE_TEXTSIZE			TEXTSIZE_BUTTON_PC
#else
	#undef CHOICE_TEXTSIZE
	#define CHOICE_TEXTSIZE			TEXTSIZE_DEFAULT
#endif

// position setting for splitscreen
#ifdef SPLITSCREEN_ENABLED
	#undef CHOICE_SIZE_X
	#define CHOICE_SIZE_X 120
	#undef CHOICE_SIZE_Y
	#define CHOICE_SIZE_Y 18
	#define CHOICE_TEXT_OFFSET_X	(0 - (4+CHOICE_SIZE_Y))
	#define CHOICE_ACCEPT_ALIGN_X	-2
	#define CHOICE_ACCEPT_ALIGN_Y	0
	#define	CHOICE_TEXTALIGN		ITEM_ALIGN_MIDDLE_RIGHT
	#define ALT_HINT_X_OFFSET		-(CHOICE_SIZE_Y)
	#undef CHOICE_SEP_OFFSET_Y
	#define CHOICE_SEP_OFFSET_Y		-2
	#define NEW_X_OFFSET			2
	
	#undef CHOICE_TEXTSIZE
	#define CHOICE_TEXTSIZE		TEXTSIZE_SMALL
	
	#define BUTTON_BG_COLOR			0.9 0.9 1 0.12
#endif

#undef CHOICE_TEXTCOLOR
#define CHOICE_TEXTCOLOR		0.69 0.69 0.69 1

#undef CHOICE_TEXTSTYLE
#define CHOICE_TEXTSTYLE		ITEM_TEXTSTYLE_SHADOWEDMORE

#undef HIGHLIGHT_BORDER
#define HIGHLIGHT_BORDER		0

#undef HIGHLIGHT_SHADER
#define HIGHLIGHT_SHADER		"gradient_fadein"

#undef HIGHLIGHT_COLOR
#define HIGHLIGHT_COLOR			0.9 0.95 1 0.35

#undef A_BUTTON_COLOR
#define A_BUTTON_COLOR			1 1 1 1

#undef CHOICE_HORIZONTAL_ALIGN
#define CHOICE_HORIZONTAL_ALIGN	HORIZONTAL_ALIGN_LEFT

#undef CHOICE_VERTICAL_ALIGN
#define CHOICE_VERTICAL_ALIGN	VERTICAL_ALIGN_TOP

#undef RIGHTITEM_ALIGN
#define RIGHTITEM_ALIGN			HORIZONTAL_ALIGN_RIGHT

#undef RIGHTITEM_OFFSET
#define RIGHTITEM_OFFSET		0

#undef CHOICE_FONT
#define CHOICE_FONT				UI_FONT_NORMAL

#undef CHOICE_Y_SPACING
#define CHOICE_Y_SPACING		(CHOICE_SIZE_Y+2)

#undef CHOICE_SEP_SPACING
#define CHOICE_SEP_SPACING		10

#undef CHOICE_SEP_WIDTH
#define CHOICE_SEP_WIDTH		(CHOICE_SIZE_X - (CHOICE_SIZE_Y/4))
