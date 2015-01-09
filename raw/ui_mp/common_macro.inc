// generic shader draw, text draw, ui art elements to be included by menu scripts that use such

#define PREPROC_SHADER_DRAW_ALIGNED( prect, porigin, pshader, pcolor, pborder, pbordersize, pbordercolor ) \
		PREPROC_SHADER_DRAW_ALIGNED_VIS( prect, porigin, pshader, pcolor, pborder, pbordersize, pbordercolor, 1 )
		
#define PREPROC_SHADER_DRAW_ALIGNED_VIS( prect, porigin, pshader, pcolor, pborder, pbordersize, pbordercolor, visArg ) \
itemDef { \
	style			WINDOW_STYLE_SHADER \
	rect			prect \
	origin 			porigin \
	forecolor		pcolor \
	exp				material( pshader ); \
	border			pborder \
	bordersize		pbordersize \
	bordercolor		pbordercolor \
	visible			visArg decoration }		

// generic shader draw
#define PREPROC_SHADER_DRAW( prect, porigin, pshader, pcolor, pborder, pbordersize, pbordercolor ) \
itemDef { \
	style			WINDOW_STYLE_SHADER \
	rect			prect 0 0 origin porigin \
	forecolor		pcolor \
	exp				material( pshader ); \
	border			pborder \
	bordersize		pbordersize \
	bordercolor		pbordercolor \
	visible			1 decoration }		

#define PREPROC_SHADER_DRAW_VIS( prect, porigin, pshader, pcolor, pborder, pbordersize, pbordercolor, visArg ) \
itemDef { \
	style			WINDOW_STYLE_SHADER \
	rect			prect 0 0 origin porigin \
	forecolor		pcolor \
	exp				material( pshader ); \
	border			pborder \
	bordersize		pbordersize \
	bordercolor		pbordercolor \
	visible			1 decoration }		

// generic text draw
#define PREPROC_TEXT_DRAW( prect, porigin, ptext, psize, palignx, paligny, palign, pcolor ) \
itemDef { \
	rect			prect 0 0 origin porigin \
	textalignx		palignx textaligny paligny \
	textstyle		ITEM_TEXTSTYLE_SHADOWED \
	textalign		palign \
	textscale		psize \
	forecolor		pcolor \
	ptext \
	visible			1 decoration }
	
// generic text draw
#define PREPROC_TEXT_DRAW_ALIGNED( prect, porigin, ptext, psize, palignx, paligny, palign, pcolor ) \
itemDef { \
	rect			prect \
	origin 			porigin \
	textalignx		palignx textaligny paligny \
	textstyle		ITEM_TEXTSTYLE_SHADOWED \
	textalign		palign \
	textscale		psize \
	forecolor		pcolor \
	ptext \
	visible			1 decoration autowrapped }

// generic text draw
#define PREPROC_TEXT_DRAW_ALIGNED_EXP( prect, porigin, ptext, psize, palignx, paligny, palign, pcolor ) \
itemDef { \
	rect			prect \
	origin 			porigin \
	textalignx		palignx textaligny paligny \
	textstyle		ITEM_TEXTSTYLE_SHADOWED \
	textalign		palign \
	textscale		psize \
	forecolor		pcolor \
	exp				text( ptext ); \
	visible			1 decoration autowrapped }

#define PREPROC_TEXT_DRAW_ALIGNED_EXP2( prect, porigin, ptext, pfont, psize, palignx, paligny, palign, pcolor ) \
itemDef { \
	rect			prect \
	origin 			porigin \
	textalignx		palignx textaligny paligny \
	textfont		pfont \
	textstyle		ITEM_TEXTSTYLE_SHADOWED \
	textalign		palign \
	textscale		psize \
	forecolor		pcolor \
	exp				text( ptext ); \
	visible			1 decoration autowrapped }
		
// generic shader draw using exp
#define PREPROC_SHADER_DRAW_EXP( prect, porigin, pshader, pcolor, pborder, pbordersize, pbordercolor ) \
itemDef { \
	style			WINDOW_STYLE_SHADER \
	rect			prect 0 0 origin porigin \
	forecolor		pcolor \
	pshader;\
	border			pborder \
	bordersize		pbordersize \
	bordercolor		pbordercolor \
	visible			1 decoration }		

// generic text draw using exp
#define PREPROC_TEXT_DRAW_EXP( prect, porigin, ptext, psize, palignx, paligny, palign, pcolor ) \
itemDef { \
	rect			prect 0 0 origin porigin \
	textalignx		palignx textaligny paligny \
	textstyle		ITEM_TEXTSTYLE_SHADOWED \
	textalign		palign \
	textscale		psize \
	forecolor		pcolor \
	ptext; \
	visible			1 decoration }

// generic shader draw
#define PREPROC_SHADER_DRAW_ADV( px, py, pw, ph, pshader, pcolor, pborder, pbordersize, pbordercolor ) \
		PREPROC_SHADER_DRAW_ADV_VIS( px, py, pw, ph, pshader, pcolor, pborder, pbordersize, pbordercolor, 1 )
		
#define PREPROC_SHADER_DRAW_ADV_VIS( px, py, pw, ph, pshader, pcolor, pborder, pbordersize, pbordercolor, visArg ) \
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
	visible			visArg \
	decoration }		

// generic text draw
#define PREPROC_TEXT_DRAW_ADV( px, py, pw, ph, ptext, psize, palignx, paligny, palign, pcolor ) \
itemDef { \
	exp				rect X( px ) \
	exp				rect Y( py ) \
	exp				rect W( pw ) \
	exp				rect H( ph ) \
	textalignx		palignx textaligny paligny \
	textstyle		ITEM_TEXTSTYLE_SHADOWED \
	textalign		palign \
	textscale		psize \
	forecolor		pcolor \
	ptext; \
	visible			1 decoration }
	
#define PREPROC_PERFORATION( px, py, pw, ph, px2, py2, px3, py3 ) \
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

#define PREPROC_PERFORATION_ALIGNED( px, py, pw, ph, px2, py2, palign ) \
itemDef { \
	style			WINDOW_STYLE_SHADER \
	exp				rect X((px)+(px2)) \
	exp				rect Y((py)+(py2)) \
	exp				rect W(pw) \
	exp				rect H(ph) \
	rect			0 0 0 0 palign \
	forecolor		1 1 1 1 \
	exp				material( "ui_perforation" ); \
	visible			1 decoration }	

// art bar with perforation texture
#define PERFORATIONBAR( px, py, pw, ph, px2, py2 ) \
	PREPROC_PERFORATION( px, py, (ph)*4, ph, px2, py2, 0, 0 ) \
	PREPROC_PERFORATION( (px)+(pw)-(ph)*4, py, -4*(ph), ph, px2, py2, 0, 0 )

// ------------------ preprocessing function definitions ------------------
#define SINGULAR_HIDEALL \
	hide description_choice1;	\
	hide description2_choice1;	\
	hide highlight_choice1;		\
	hide a_button_choice1;		\
	hide description_choice2;	\
	hide description2_choice2;	\
	hide highlight_choice2;		\
	hide a_button_choice2;		\
	hide description_choice3;	\
	hide description2_choice3;	\
	hide highlight_choice3;		\
	hide a_button_choice3;		\
	hide description_choice4;	\
	hide description2_choice4;	\
	hide highlight_choice4;		\
	hide a_button_choice4;		\
	hide description_choice5;	\
	hide description2_choice5;	\
	hide highlight_choice5;		\
	hide a_button_choice5;		\
	hide description_choice6;	\
	hide description2_choice6;	\
	hide highlight_choice6;		\
	hide a_button_choice6;		\
	hide description_choice7;	\
	hide description2_choice7;	\
	hide highlight_choice7;		\
	hide a_button_choice7;		\
	hide description_choice8;	\
	hide description2_choice8;	\
	hide highlight_choice8;		\
	hide a_button_choice8;		\
	hide description_choice9;	\
	hide description2_choice9;	\
	hide highlight_choice9;		\
	hide a_button_choice9;		\
	hide description_choice10;	\
	hide description2_choice10;	\
	hide highlight_choice10;	\
	hide a_button_choice10;		\
	hide description_choice11;	\
	hide description2_choice11;	\
	hide highlight_choice11;	\
	hide a_button_choice11;		\
	hide description_choice12;	\
	hide description2_choice12;	\
	hide highlight_choice12;	\
	hide a_button_choice12;		\
	hide description_choice13;	\
	hide description2_choice13;	\
	hide highlight_choice13;	\
	hide a_button_choice13;		\
	hide description_choice14;	\
	hide description2_choice14;	\
	hide highlight_choice14;	\
	hide a_button_choice14;		\
	hide description_choice15;	\
	hide description2_choice15;	\
	hide highlight_choice15;	\
	hide a_button_choice15;		\
	hide description_choice16;	\
	hide description2_choice16;	\
	hide highlight_choice16;	\
	hide a_button_choice16;		\
	hide description_choice17;	\
	hide description2_choice17;	\
	hide highlight_choice17;	\
	hide a_button_choice17;	
		
// singular button macro
#define SINGULAR_BUTTON( pnum, porigin, phighlight_size, ptext, paction ) \
	SINGULAR_BUTTON_RAW( pnum, porigin, phighlight_size, ptext, paction, 1 )

#define SINGULAR_BUTTON_RAW( pnum, porigin, phighlight_size, ptext, paction, p_vis ) \
itemDef{											\
	type			ITEM_TYPE_BUTTON				\
	origin			porigin							\
	textfont		UI_FONT_NORMAL					\
	textstyle 		ITEM_TEXTSTYLE_SHADOWED			\
	exp				text( ptext );					\
	textscale		TEXTSIZE_DEFAULT				\
	forecolor		1 1 1 0.5						\
	visible			when( p_vis );					\
	onFocus{										\
		play "mouse_over";							\
		SINGULAR_HIDEALL							\
		show "description_choice"#pnum;				\
		show "description2_choice"#pnum;			\
		show "highlight_choice"#pnum;				\
		show "a_button_choice"#pnum; }				\
	leaveFocus{										\
		hide "description_choice"#pnum;				\
		hide "description2_choice"#pnum;			\
		hide "highlight_choice"#pnum;				\
		hide "a_button_choice"#pnum; }				\
	action{											\
		play "mouse_click";							\
		paction	}}									\
itemDef { 											\
	name			"highlight_choice"#pnum 		\
	style			WINDOW_STYLE_SHADER 			\
	rect			porigin phighlight_size 0 0 	\
	origin			-26 -19 						\
	background		"white"			 				\
	forecolor		0.2 0.25 0.35 0.25 				\
	border			1				 				\
	bordersize		1 								\
	bordercolor		0.8 0.95 1 0.4		 			\
	visible			1 								\
	decoration }									\
itemDef { 											\
	name			"a_button_choice"#pnum 			\
	text			"@XBOXLIVE_SELECTBUTTON" 		\
	textfont		UI_FONT_NORMAL 					\
	textscale		0.27		 					\
	rect			porigin 20 20 0 0				\
	origin			-20 -3							\
	forecolor		0 0 0 0.5	 					\
	visible			1 								\
	decoration }		
	
// full button that show/hides highlight, a button, description and gray out if locked
#define SINGULAR_BUTTON_FULL( pnum, porigin, phighlight_size, ptext, paction, pvis ) \
itemDef{											\
	type			ITEM_TYPE_BUTTON				\
	origin			porigin							\
	textfont		UI_FONT_NORMAL					\
	textstyle 		ITEM_TEXTSTYLE_SHADOWED			\
	exp				text( ptext );					\
	textscale		TEXTSIZE_DEFAULT				\
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
SINGULAR_BUTTON_RAW( pnum, porigin, phighlight_size, ptext, paction, pvis )

#define LOADOUT_PLATING_RAW( porigin, px, py, pw, ph, palign, vis_gradient_top, vis_gradient_bottom ) \
	PREPROC_SHADER_DRAW_ALIGNED( (px-4) (py-8) pw ph palign, porigin, "white", 0.2 0.2 0.225 1, 0, 0, 0 0 0 0 ) \
	PREPROC_SHADER_DRAW_ALIGNED( (px-4) (py-8) pw ph palign, porigin, "line_horizontal", 0.9 0.9 0.95 0.5, 0, 0, 0 0 0 0 ) \
	PREPROC_SHADER_DRAW_ALIGNED( (px-4) (py+ph-8) pw 16 palign, porigin, "gradient_top", 1 1 1 0.4, 0, 0, 0 0 0 0 visible when( vis_gradient_bottom ) ) \
	PREPROC_SHADER_DRAW_ALIGNED( (px-4) (py-24) pw 16 palign, porigin, "gradient_bottom", 1 1 1 0.4, 0, 0, 0 0 0 0 visible when( vis_gradient_top ) )