// Must be included AFTER all the #defines in the menu, AND before the actual usage of any macros in this file


// generic shader draw
#define SHADER_DRAW( px, py, pw, ph, pshader, pcolor, pborder, pbordersize, pbordercolor ) \
itemDef { \
	style			WINDOW_STYLE_SHADER \
	exp				rect X( px ) \
	exp				rect Y( py ) \
	exp				rect W( pw ) \
	exp				rect H( ph ) \
	forecolor		pcolor \
	exp				material( pshader ); \
	border			pborder \
	bordersize		pbordersize \
	bordercolor		pbordercolor \
	visible			1 decoration }		

// generic text draw
#define TEXT_DRAW( px, py, pw, ph, ptext, psize, palign, pcolor ) \
itemDef { \
	exp				rect X( px ) \
	exp				rect Y( py ) \
	exp				rect W( pw ) \
	exp				rect H( ph ) \
	textstyle		ITEM_TEXTSTYLE_SHADOWED \
	textalign		palign \
	textscale		psize \
	forecolor		pcolor \
	exp				text(ptext); \
	visible			1 decoration }
	
// single perforation texture
#define PERFORATION( px, py, pw, ph, px2, py2, px3, py3 ) \
itemDef { \
	style			WINDOW_STYLE_SHADER \
	exp				rect X((px)+(px2)) \
	exp				rect Y((py)+(py2)) \
	exp				rect W(pw) \
	exp				rect H(ph) \
	origin 			px3 py3 \
	forecolor		1 1 1 1 \
	exp				material( "ui_perforation" ); \
	visible			1 decoration }		

// art bar with perforation texture on both ends
#define PERFORATIONBAR( px, py, pw, ph, px2, py2 ) \
	PREPROC_PERFORATION( px, py, (ph)*4, ph, px2, py2, 0, 0 ) \
	PREPROC_PERFORATION( (px)+(pw)-(ph)*4, py, -4*(ph), ph, px2, py2, 0, 0 )

// ------------------ preprocessing function definitions ------------------

#ifndef BUTTON_HL_OFFSET
#define BUTTON_HL_OFFSET 	-26 -19
#endif

#ifndef BUTTON_A_OFFSET
#define BUTTON_A_OFFSET 	-20 -3
#endif

#ifndef BUTTON_TEXTCOLOR
#define BUTTON_TEXTCOLOR 	0.6 0.6 0.6 1
#endif

#ifndef BUTTON_LOCKEDCOLOR
#define BUTTON_LOCKEDCOLOR 	0.25 0.25 0.25 1
#endif

#ifndef BUTTON_TEXTSIZE
#define BUTTON_TEXTSIZE 	TEXTSIZE_DEFAULT
#endif

#ifndef BUTTON_SHADER
#define BUTTON_SHADER 		"white"
#endif

#ifndef BUTTON_SHADERCOLOR
#define BUTTON_SHADERCOLOR	1 1 1 0
#endif

#ifndef BUTTON_SHADER_OFFSET
#define BUTTON_SHADER_OFFSET	0 0
#endif

#ifndef BUTTON_SHADERSIZE
#define BUTTON_SHADERSIZE	200 20
#endif

#ifndef BUTTON_DESCCOLOR
#define BUTTON_DESCCOLOR	0.6 0.6 0.6 1
#endif

#define BUTTON_DESC_RAW( pnum, plock, porigin, psize, ptext ) \
itemDef{											\
	group			"button_hide"					\
	name			"description"plock"_choice"#pnum		\
	type			ITEM_TYPE_BUTTON				\
	origin			porigin							\
	textfont		UI_FONT_NORMAL					\
	textstyle 		ITEM_TEXTSTYLE_SHADOWED			\
	exp				text( ptext );					\
	textscale		BUTTON_TEXTSIZE					\
	forecolor		BUTTON_DESCCOLOR				\
	visible			1
	
#define BUTTON_LOCKED_DESC( pnum, porigin, psize, ptext ) \
	BUTTON_DESC_RAW( pnum, "2", porigin, psize, ptext )
	
#define BUTTON_UNLOCKED_DESC( pnum, porigin, psize, ptext ) \
	BUTTON_DESC_RAW( pnum, "1", porigin, psize, ptext )

// singular button macro
#define BUTTON( pnum, porigin, phighlight_size, ptext, paction ) \
	BUTTON_RAW( pnum, porigin, phighlight_size, ptext, ;, ;, paction, 1 )

#define BUTTON_RAW( pnum, porigin, phighlight_size, ptext, ponfocus, pleavefocus, paction, p_vis ) \
itemDef{											\
	type			ITEM_TYPE_BUTTON				\
	origin			porigin							\
	textfont		UI_FONT_NORMAL					\
	textstyle 		ITEM_TEXTSTYLE_SHADOWED			\
	exp				text( ptext );					\
	textscale		BUTTON_TEXTSIZE					\
	forecolor		1 1 1 0.5						\
	visible			when( p_vis );					\
	onFocus{										\
		play "mouse_over";							\
		hide "button_hide"							\
		show "description1_choice"#pnum;			\
		show "description2_choice"#pnum;			\
		show "highlight_choice"#pnum;				\
		show "a_button_choice"#pnum; 				\
		ponfocus }									\
	leaveFocus{										\
		hide "description1_choice"#pnum;			\
		hide "description2_choice"#pnum;			\
		hide "highlight_choice"#pnum;				\
		hide "a_button_choice"#pnum; 				\
		pleavefocus }								\
	action{											\
		play "mouse_click";							\
		paction	}}									\
itemDef { 											\
	style			WINDOW_STYLE_SHADER 			\
	rect			porigin BUTTON_SHADERSIZE 0 0 	\
	origin			BUTTON_SHADER_OFFSET			\
	exp				material( BUTTON_SHADER )		\
	forecolor		BUTTON_SHADERCOLOR 				\
	visible			1 								\
	decoration }									\
itemDef { 											\
	group			"button_hide"					\
	name			"highlight_choice"#pnum 		\
	style			WINDOW_STYLE_SHADER 			\
	rect			porigin phighlight_size 0 0 	\
	origin			BUTTON_HL_OFFSET				\
	exp				material( BUTTON_HL_SHADER )	\
	forecolor		0.2 0.25 0.35 0.25 				\
	border			1				 				\
	bordersize		1 								\
	bordercolor		0.8 0.95 1 0.4		 			\
	visible			1 								\
	decoration }									\
itemDef { 											\
	group			"button_hide"					\
	name			"a_button_choice"#pnum 			\
	text			"@XBOXLIVE_SELECTBUTTON" 		\
	textfont		UI_FONT_NORMAL 					\
	textscale		0.27		 					\
	rect			porigin 20 20 0 0				\
	origin			BUTTON_A_OFFSET					\
	forecolor		0 0 0 0.5	 					\
	visible			1 								\
	decoration }		
	
// full button that show/hides highlight, a button, description and gray out if locked
#define BUTTON_FULL( pnum, porigin, phighlight_size, ptext, paction, pvis ) \
itemDef{											\
	type			ITEM_TYPE_BUTTON				\
	origin			porigin							\
	textfont		UI_FONT_NORMAL					\
	textstyle 		ITEM_TEXTSTYLE_SHADOWED			\
	exp				text( ptext );					\
	textscale		BUTTON_TEXTSIZE					\
	forecolor		0.25 0.25 0.25 1				\
	visible			when( !( pvis ) );				\
	decoration }									\
itemDef{											\
	type			ITEM_TYPE_BUTTON				\
	origin			porigin							\
	textfont		UI_FONT_NORMAL					\
	textstyle 		ITEM_TEXTSTYLE_SHADOWED			\
	exp				text( "" );						\
	visible			when( !( pvis ) );				\
	onFocus{										\
		play "mouse_over";							\
		SINGULAR_HIDEALL							\
		show "description2_choice"#pnum;			\
		show "highlight_choice"#pnum;				\
		hide "description_choice"#pnum; }			\
	leaveFocus{										\
		hide "description2_choice"#pnum;			\
		hide "highlight_choice"#pnum; } }			\
BUTTON_RAW( pnum, porigin, phighlight_size, ptext, paction, pvis )