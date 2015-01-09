#define OPTIONS_HEADING_JOIN_COLOR	0.9 0.9 0.95 0.175

#define		FILTER_Y_SPACING	20
#define		FILTER_WIDTH		254
#define		X_FILTER			-58 //300
#define		X_FILTERB			(X_FILTER+FILTER_WIDTH)
#define		Y_FILTER			2
#define 	ORIGIN_FILTER1		X_FILTER Y_FILTER
#define 	ORIGIN_FILTER2		X_FILTER (Y_FILTER+FILTER_Y_SPACING)
#define 	ORIGIN_FILTER3		X_FILTER (Y_FILTER+(FILTER_Y_SPACING*2))
#define 	ORIGIN_FILTER4		8 (Y_FILTER+(FILTER_Y_SPACING*2))

#define 	ORIGIN_FILTER1B		X_FILTERB Y_FILTER
#define 	ORIGIN_FILTER2B		X_FILTERB (Y_FILTER+FILTER_Y_SPACING)
#define 	ORIGIN_FILTER3B		X_FILTERB (Y_FILTER+(FILTER_Y_SPACING*2))
#define 	ORIGIN_FILTER4B		X_FILTERB (Y_FILTER+(FILTER_Y_SPACING*3))

#define 	TAB_NAME_Y			68

#define		TAB_BG_COLOR		OPTIONS_HEADING_JOIN_COLOR
#define		TAB_BORDER_COLOR	0.1 0.1 0.12 0.5

#define		CUSTOM_BUTTON_TEXT_SIZE	0.33

#undef CHOICE_HORIZONTAL_ALIGN 
#define CHOICE_HORIZONTAL_ALIGN HORIZONTAL_ALIGN_CENTER 

#undef CHOICE_VERTICAL_ALIGN
#define CHOICE_VERTICAL_ALIGN VERTICAL_ALIGN_TOP

// custom button highlights
CHOICE_HIGHLIGHT_CUSTOM_2( (X_FILTER-10), Y_FILTER, (FILTER_WIDTH-20), (FILTER_Y_SPACING-2), when( localVarString( ui_choicegroup ) == CHOICE_GROUP && localVarInt( ui_highlight ) == 1 ); )
CHOICE_HIGHLIGHT_CUSTOM_2( (X_FILTER-10), (Y_FILTER+FILTER_Y_SPACING), (FILTER_WIDTH-20), (FILTER_Y_SPACING-2), when( localVarString( ui_choicegroup ) == CHOICE_GROUP && localVarInt( ui_highlight ) == 2 ); )
CHOICE_HIGHLIGHT_CUSTOM_2( (X_FILTER-10), (Y_FILTER+(FILTER_Y_SPACING*2)), (FILTER_WIDTH-20), (FILTER_Y_SPACING-2), when( localVarString( ui_choicegroup ) == CHOICE_GROUP && localVarInt( ui_highlight ) == 3 ); )
CHOICE_HIGHLIGHT_CUSTOM_2( (X_FILTERB-10), Y_FILTER, (FILTER_WIDTH-20), (FILTER_Y_SPACING-2), when( localVarString( ui_choicegroup ) == CHOICE_GROUP && localVarInt( ui_highlight ) == 4 ); )
CHOICE_HIGHLIGHT_CUSTOM_2( (X_FILTERB-10), (Y_FILTER+FILTER_Y_SPACING), (FILTER_WIDTH-20), (FILTER_Y_SPACING-2), when( localVarString( ui_choicegroup ) == CHOICE_GROUP && localVarInt( ui_highlight ) == 5 ); )
CHOICE_HIGHLIGHT_CUSTOM_2( (X_FILTERB-10), (Y_FILTER+(FILTER_Y_SPACING*2)), (FILTER_WIDTH-20), (FILTER_Y_SPACING-2), when( localVarString( ui_choicegroup ) == CHOICE_GROUP && localVarInt( ui_highlight ) == 6 ); )

itemDef	{
	name sourcefield
	style WINDOW_STYLE_FILLED
	textfont	UI_FONT_NORMAL
	ownerdraw UI_NETSOURCE
	rect ORIGIN_FILTER1 170 15 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN
	textstyle 3
	textalign ITEM_ALIGN_LEFT
	textalignx 0
	textaligny 16
	textstyle 3
	textscale CUSTOM_BUTTON_TEXT_SIZE
	forecolor 1 1 1 1
	backcolor 0 0 0 0
	visible 1
	onfocus{ setLocalVarInt ui_highlight 1; setLocalVarString ui_choicegroup CHOICE_GROUP }
	leavefocus{ setLocalVarInt ui_highlight 0; setLocalVarString ui_choicegroup "" }
	action { play "mouse_click" }
	mouseEnter { show message_source ; play "mouse_over" }
	mouseExit { hide message_source }
}
itemDef	{
	name gametypefield
	style WINDOW_STYLE_FILLED
	textstyle 3
	text "@MENU_GAME_TYPE"
	ownerdraw UI_JOINGAMETYPE
	textfont	UI_FONT_NORMAL
	rect ORIGIN_FILTER2 170 15 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN
	textalign ITEM_ALIGN_LEFT
	textalignx 0
	textaligny 16
	textscale CUSTOM_BUTTON_TEXT_SIZE
	forecolor 1 1 1 1
	border 0
	bordercolor 0 0 0 0
	backcolor 0 0 0 0
	visible 1
	action { play "mouse_click" }
	onfocus{ setLocalVarInt ui_highlight 2; setLocalVarString ui_choicegroup CHOICE_GROUP }
	leavefocus{ setLocalVarInt ui_highlight 0; setLocalVarString ui_choicegroup "" }
	mouseEnter { show message_typefilter ; play "mouse_over"}
	mouseExit { hide message_typefilter }
}
itemDef {
	name		filterServers
	text		"@MENU_FILTER_SERVERS"
	type		ITEM_TYPE_BUTTON
	textfont	UI_FONT_NORMAL
	textscale	CUSTOM_BUTTON_TEXT_SIZE
	textstyle	ITEM_TEXTSTYLE_SHADOWED
	style		WINDOW_STYLE_FILLED
	rect		ORIGIN_FILTER3 130 15  CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN
	textalign	ITEM_ALIGN_LEFT
	textalignx	0
	textaligny	16
	forecolor	.9 .9 .95 1
	visible		1
	onfocus{ setLocalVarInt ui_highlight 3; setLocalVarString ui_choicegroup CHOICE_GROUP }
	leavefocus{ setLocalVarInt ui_highlight 0; setLocalVarString ui_choicegroup "" }
	action {
		play "mouse_click" ;
		open filter_popmenu
	}

	mouseEnter		{ show message_filterServers; play "mouse_over"; }
	mouseExit		{ hide message_filterServers; }
}
itemDef	{
	name refreshdate
	ownerdraw UI_SERVERREFRESHDATE
	textstyle		ITEM_TEXTSTYLE_SHADOWED
	textfont	UI_FONT_NORMAL
	textscale 0.25
	rect ORIGIN_FILTER4 265 18
	textalign ITEM_ALIGN_LEFT
	textalignx 0
	textaligny 16
	forecolor 1 1 1 1
	visible 1
	decoration
}
itemDef {
	name		refreshSource
	text		"@MENU_REFRESH_LIST"
	type		ITEM_TYPE_BUTTON
	textscale	CUSTOM_BUTTON_TEXT_SIZE
	textstyle	ITEM_TEXTSTYLE_SHADOWED
	style		WINDOW_STYLE_FILLED
	rect		ORIGIN_FILTER1B 130 15  CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN
	textalign	ITEM_ALIGN_LEFT
	textalignx	0
	textaligny	16
	textfont	UI_FONT_NORMAL
	forecolor	.9 .9 .95 1
	visible		1
	onfocus{ setLocalVarInt ui_highlight 4; setLocalVarString ui_choicegroup CHOICE_GROUP }
	leavefocus{ setLocalVarInt ui_highlight 0; setLocalVarString ui_choicegroup "" }
	mouseEnter { show message_refreshSOurce; play "mouse_over"; }
	mouseExit { hide message_refreshSource; }
	action { play "mouse_click" ; uiScript RefreshServers }
}
itemDef {
	name		refreshFilter
	text		"@MENU_QUICK_REFRESH"
	textscale	CUSTOM_BUTTON_TEXT_SIZE
	textstyle	ITEM_TEXTSTYLE_SHADOWED
	style		WINDOW_STYLE_FILLED
	textfont	UI_FONT_NORMAL
	type		ITEM_TYPE_BUTTON
  	rect		ORIGIN_FILTER2B 130 15  CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN
	textalign	ITEM_ALIGN_LEFT
	textalignx	0
	textaligny	16
	forecolor	.9 .9 .95 1
	visible		1
	onfocus{ setLocalVarInt ui_highlight 5; setLocalVarString ui_choicegroup CHOICE_GROUP }
	leavefocus{ setLocalVarInt ui_highlight 0; setLocalVarString ui_choicegroup "" }
	mouseEnter { show message_refreshFilter; play "mouse_over"; }
	mouseExit { hide message_refreshFilter; }
	action { play "mouse_click"; uiScript RefreshFilter }
}

itemDef {
	text		"@MENU_NEW_FAVORITE"
	type		ITEM_TYPE_BUTTON
	textfont	UI_FONT_NORMAL
	textscale	CUSTOM_BUTTON_TEXT_SIZE
	textstyle	ITEM_TEXTSTYLE_SHADOWED
	style		WINDOW_STYLE_FILLED
	rect		ORIGIN_FILTER3B 130 15  CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN
	textalign	ITEM_ALIGN_LEFT
	textalignx	0
	textaligny	16
	forecolor	CHOICE_TEXTCOLOR_DISABLED
	visible		when( dvarint("ui_netSource")!=2 )
	decoration
}
itemDef {
	name		createFavorite
	text		"@MENU_NEW_FAVORITE"
	type		ITEM_TYPE_BUTTON
	textfont	UI_FONT_NORMAL
	textscale	CUSTOM_BUTTON_TEXT_SIZE
	textstyle	ITEM_TEXTSTYLE_SHADOWED
	style		WINDOW_STYLE_FILLED
	rect		ORIGIN_FILTER3B 130 15  CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN
	textalign	ITEM_ALIGN_LEFT
	textalignx	0
	textaligny	16
	forecolor	.9 .9 .95 1
	visible		1
	// Only show when view favorite servers list
	dvarTest "ui_netSource"
	showDvar { "2" }
	onfocus{ setLocalVarInt ui_highlight 6; setLocalVarString ui_choicegroup CHOICE_GROUP }
	leavefocus{ setLocalVarInt ui_highlight 0; setLocalVarString ui_choicegroup "" }
	action {
		play "mouse_click" ;
		open createfavorite_popmenu
	}

	mouseEnter		{ show message_createFavorite; play "mouse_over"; }
	mouseExit		{ hide message_createFavorite; }
}

#define WIDTH_PASSWORD		20 
#define WIDTH_HARDWARE		20 
#define WIDTH_SERVER		208
#define WIDTH_MAP			70
#define WIDTH_PLAYER		50
#define WIDTH_TYPE			102
#define WIDTH_VOICE			20 
#define WIDTH_PURE			20 
#define WIDTH_MOD			20 
#define WIDTH_PB			20
#define WIDTH_PING			40 

#define TAB_HEIGHT			16
#define TAB_LABEL_OFFSET	\
	textalignx 4			\
	textaligny (TAB_HEIGHT-2)

#define TABLE_X				4
#define TABLE_Y				64

#define PASSWORD_X			(TABLE_X+0) 			
#define HARDWARE_X			(TABLE_X+WIDTH_PASSWORD+2)
#define SERVER_X			(HARDWARE_X+WIDTH_HARDWARE+2)
#define MAP_X				(SERVER_X+WIDTH_SERVER+2) 	
#define PLAYER_X			(MAP_X+WIDTH_MAP+2) 	
#define TYPE_X				(PLAYER_X+WIDTH_PLAYER+2) 	
#define VOICE_X				(TYPE_X+WIDTH_TYPE+2) 	
#define PURE_X				(VOICE_X+WIDTH_VOICE+2) 	
#define MOD_X				(PURE_X+WIDTH_PURE+2) 	
#define PB_X				(MOD_X+WIDTH_MOD+2) 
#define PING_X				(PB_X+WIDTH_PB+2) 	

#define TABLE_HEIGHT		380
#define TABLE_WIDTH			(PING_X+WIDTH_PING+20)

// table bg color
itemDef	{
	name window
	group grpSystembutton
	rect TABLE_X TABLE_Y TABLE_WIDTH TABLE_HEIGHT
	style WINDOW_STYLE_FILLED
	forecolor 1 1 1 1
	backcolor 0 0 0 .3
	visible 1
	decoration
}

#define ORIGIN_PASSWORD   	PASSWORD_X	TABLE_Y
#define ORIGIN_HARDWARE    	HARDWARE_X	TABLE_Y
#define ORIGIN_SERVER 	   	SERVER_X	TABLE_Y
#define ORIGIN_MAP 		   	MAP_X		TABLE_Y
#define ORIGIN_PLAYER 	   	PLAYER_X	TABLE_Y
#define ORIGIN_TYPE 	   	TYPE_X		TABLE_Y
#define ORIGIN_VOICE 	   	VOICE_X		TABLE_Y
#define ORIGIN_PURE 	   	PURE_X		TABLE_Y
#define ORIGIN_MOD 		   	MOD_X		TABLE_Y
#define ORIGIN_PB			PB_X		TABLE_Y
#define ORIGIN_PING 	   	PING_X		TABLE_Y

#define RECT_PASSWORD		ORIGIN_PASSWORD 	WIDTH_PASSWORD 		TABLE_HEIGHT
#define RECT_HARDWARE		ORIGIN_HARDWARE 	WIDTH_HARDWARE 		TABLE_HEIGHT
#define RECT_SERVER			ORIGIN_SERVER 		WIDTH_SERVER 		TABLE_HEIGHT
#define RECT_MAP			ORIGIN_MAP 			WIDTH_MAP 			TABLE_HEIGHT
#define RECT_PLAYER			ORIGIN_PLAYER 		WIDTH_PLAYER 		TABLE_HEIGHT
#define RECT_TYPE			ORIGIN_TYPE 		WIDTH_TYPE 			TABLE_HEIGHT
#define RECT_VOICE			ORIGIN_VOICE 		WIDTH_VOICE 		TABLE_HEIGHT
#define RECT_PURE			ORIGIN_PURE 		WIDTH_PURE 			TABLE_HEIGHT
#define RECT_MOD			ORIGIN_MOD 			WIDTH_MOD 			TABLE_HEIGHT
#define RECT_PB				ORIGIN_PB			WIDTH_PB			TABLE_HEIGHT
#define RECT_PING			ORIGIN_PING 		WIDTH_PING 			TABLE_HEIGHT

//	SERVER LIST COLUMN OUTLINES	=====================================================================
#define PREPROC_COLUMN_BOX( pname, prect ) PREPROC_COLUMN_BOX_RAW( pname, prect, 0 0 0 0 )
#define PREPROC_COLUMN_BOX_RAW( pname, prect, pcolor )\
	itemDef	{\
		name pname\
		group grpColumn\
		rect prect 0 0 \
		origin -2 -2 \
		style WINDOW_STYLE_FILLED\
		border 1\
		backcolor pcolor\
		bordercolor TAB_BORDER_COLOR\
		visible 1	decoration\
	}
	
PREPROC_COLUMN_BOX( passwordColumn, ORIGIN_PASSWORD 	(WIDTH_PASSWORD+2) 		TABLE_HEIGHT)
PREPROC_COLUMN_BOX( hardwareColumn, ORIGIN_HARDWARE 	(WIDTH_HARDWARE+2) 		TABLE_HEIGHT)
PREPROC_COLUMN_BOX( serverColumn,  	ORIGIN_SERVER 		(WIDTH_SERVER+2) 		TABLE_HEIGHT)
PREPROC_COLUMN_BOX( mapColumn,  	ORIGIN_MAP 			(WIDTH_MAP+2) 			TABLE_HEIGHT)
PREPROC_COLUMN_BOX( playerColumn,  	ORIGIN_PLAYER 		(WIDTH_PLAYER+2) 		TABLE_HEIGHT)
PREPROC_COLUMN_BOX( typeColumn,  	ORIGIN_TYPE 		(WIDTH_TYPE+2) 			TABLE_HEIGHT)
PREPROC_COLUMN_BOX( voiceColumn,  	ORIGIN_VOICE 		(WIDTH_VOICE+2) 		TABLE_HEIGHT)
PREPROC_COLUMN_BOX( pureColumn,  	ORIGIN_PURE 		(WIDTH_PURE+2) 			TABLE_HEIGHT)
PREPROC_COLUMN_BOX( modColumn,  	ORIGIN_MOD 			(WIDTH_MOD+2) 			TABLE_HEIGHT)
PREPROC_COLUMN_BOX( pbColumn,  		ORIGIN_PB 			(WIDTH_PB+2) 			TABLE_HEIGHT)
PREPROC_COLUMN_BOX_RAW( pingColumn, ORIGIN_PING 		(WIDTH_PING+2)			TABLE_HEIGHT, 0 0 0.4 .15)
		

// SERVER LIST TEXT ===========================================================
itemDef
{
	name 			serverlist
	rect 			TABLE_X TABLE_Y (TABLE_WIDTH-8) (TABLE_HEIGHT-17)
	origin			0 16
	type 			ITEM_TYPE_LISTBOX
	style 			WINDOW_STYLE_FILLED
	elementwidth 	120
	elementheight 	16
	textfont		UI_FONT_NORMAL
	textalign 		1
	textaligny 		0
	textscale 		0.25
	elementtype 	LISTBOX_TEXT
	feeder 			FEEDER_SERVERS
	forecolor 		1 1 1 1
	backcolor 		0 0 0 0
	outlinecolor 	OPTIONS_HEADING_JOIN_COLOR
	visible 		1
	//		numcols	xpos			xwidth			textlen
	columns	11		(PASSWORD_X-3)	16				20
					(HARDWARE_X-3)	16				10
					SERVER_X		WIDTH_SERVER	22
					MAP_X			WIDTH_MAP		25
					PLAYER_X		WIDTH_PLAYER	10
					TYPE_X			WIDTH_TYPE		22
					VOICE_X			16				14
					PURE_X			16				10
					MOD_X			16				20
					PB_X			WIDTH_PB		20
					PING_X			WIDTH_PING		20
	doubleClick 	{ uiScript JoinServer }
	execkeyint 		13	{ uiScript JoinServer }
}

#undef	TABLE_HEIGHT
#define TABLE_HEIGHT TAB_HEIGHT

		// PASSWORD ==============================================================
		itemDef
		{
			name password
			group grpTabs
			type ITEM_TYPE_BUTTON
			style WINDOW_STYLE_FILLED
			rect RECT_PASSWORD
			forecolor 1 1 1 1
			backcolor OPTIONS_HEADING_JOIN_COLOR
			visible 1
			action
			{
				play "mouse_click" ;
				uiScript ServerSort 0 ;
				setitemcolor grpTabs backcolor TAB_BG_COLOR ;
				setitemcolor password backcolor .1 .2 .37 1 ;
				setitemcolor grpColumn backcolor 0 0 0 0 ;
				setitemcolor passwordColumn backcolor 0 0 0.4 .15
			}
			mouseEnter { show message_sort ; setitemcolor passwordColumn bordercolor 1 1 1 1 ; play "mouse_over" }
			mouseExit { hide message_sort ; setitemcolor passwordColumn bordercolor TAB_BORDER_COLOR }
		}
		itemDef
		{
			name passwordicon
			style WINDOW_STYLE_SHADER
			rect ORIGIN_PASSWORD 16 16
			origin 3 0
			background "hud_server_locked"
			visible 1
			decoration
		}

		// HARDWARE ==============================================================
		itemDef
		{
			name hardware
			group grpTabs
			type ITEM_TYPE_BUTTON
			style WINDOW_STYLE_FILLED
			rect RECT_HARDWARE
			forecolor 1 1 1 1
			backcolor OPTIONS_HEADING_JOIN_COLOR
			visible 1
			action
			{
				play "mouse_click" ;
				uiScript ServerSort 1 ;
				setitemcolor grpTabs backcolor TAB_BG_COLOR ;
				setitemcolor hardware backcolor .1 .2 .37 1 ;
				setitemcolor grpColumn backcolor 0 0 0 0 ;
				setitemcolor hardwareColumn backcolor 0 0 0.4 .15
			}
			mouseEnter { show message_sort ; setitemcolor hardwareColumn bordercolor 1 1 1 1 ; play "mouse_over" }
			mouseExit { hide message_sort ; setitemcolor hardwareColumn bordercolor TAB_BORDER_COLOR }
		}
		itemDef
		{
			name hardwareicon
			style WINDOW_STYLE_SHADER
			rect ORIGIN_HARDWARE 16 16
			origin 3 0
			background "server_hardware_header"
			visible 1
			decoration
		}
		
		// SERVER ================================================================
		itemDef
		{
			name server
			group grpTabs
			text "@MENU_SERVER NAME"
			TAB_LABEL_OFFSET
			type ITEM_TYPE_BUTTON
			textscale 0.25
			textfont	UI_FONT_NORMAL
			style WINDOW_STYLE_FILLED
			rect RECT_SERVER
			textalign ITEM_ALIGN_LEFT
			forecolor 1 1 1 1
			backcolor OPTIONS_HEADING_JOIN_COLOR
			visible 1
			action
			{
				play "mouse_click" ;
				uiScript ServerSort 2 ;
				setitemcolor grpTabs backcolor TAB_BG_COLOR ;
				setitemcolor server backcolor .1 .2 .37 1 ;
				setitemcolor grpColumn backcolor 0 0 0 0 ;
				setitemcolor serverColumn backcolor 0 0 0.4 .15
			}
			mouseEnter { show message_sort ; setitemcolor serverColumn bordercolor 1 1 1 1 ; play "mouse_over" }
			mouseExit { hide message_sort ; setitemcolor serverColumn bordercolor TAB_BORDER_COLOR }
		}

		// MAP ===================================================================
		itemDef
		{
			name map
			group grpTabs
			type ITEM_TYPE_BUTTON
			text "@MENU_MAP_NAME"
			TAB_LABEL_OFFSET
			textscale 0.25
			textfont	UI_FONT_NORMAL
			style WINDOW_STYLE_FILLED
			rect RECT_MAP
			textalign ITEM_ALIGN_LEFT
			backcolor OPTIONS_HEADING_JOIN_COLOR
			forecolor 1 1 1 1
			visible 1
			action
			{
				play "mouse_click" ;
				uiScript ServerSort 3 ;
				setitemcolor grpTabs backcolor TAB_BG_COLOR ;
				setitemcolor map backcolor .1 .2 .37 1 ;
				setitemcolor grpColumn backcolor 0 0 0 0 ;
				setitemcolor mapColumn backcolor 0 0 .4 .15
			}
			mouseEnter { show message_sort ; setitemcolor mapColumn bordercolor 1 1 1 1 ; play "mouse_over"}
			mouseExit { hide message_sort ; setitemcolor mapColumn bordercolor TAB_BORDER_COLOR }
		}

		// PLAYERS ===============================================================
		itemDef
		{
			name Players
			group grpTabs
			text "@MENU_NUMPLAYERS"
			TAB_LABEL_OFFSET
			type ITEM_TYPE_BUTTON
			textscale 0.25
			style WINDOW_STYLE_FILLED
			textfont	UI_FONT_NORMAL
			rect RECT_PLAYER
			textalign ITEM_ALIGN_LEFT
			forecolor 1 1 1 1
			backcolor OPTIONS_HEADING_JOIN_COLOR
			visible 1
			action
			{
				play "mouse_click" ;
				uiScript ServerSort 4 ;
				setitemcolor grpTabs backcolor TAB_BG_COLOR ;
				setitemcolor Players backcolor .1 .2 .37 1 ;
				setitemcolor grpColumn backcolor 0 0 0 0 ;
				setitemcolor playerColumn backcolor 0 0 .4 .15
			}
			mouseEnter { show message_sort ; setitemcolor playerColumn bordercolor 1 1 1 1 ; play "mouse_over"}
			mouseExit { hide message_sort ; setitemcolor playerColumn bordercolor TAB_BORDER_COLOR }
		}

		// TYPE ==================================================================
		itemDef
		{
			name Type
			group grpTabs
			text "@MENU_TYPE1"
			TAB_LABEL_OFFSET
			textfont	UI_FONT_NORMAL
			textscale 0.25
			type ITEM_TYPE_BUTTON
			style WINDOW_STYLE_FILLED
			rect RECT_TYPE
			textalign ITEM_ALIGN_LEFT
			backcolor OPTIONS_HEADING_JOIN_COLOR
			forecolor 1 1 1 1
			visible 1
			action
			{
				play "mouse_click" ;
				uiScript ServerSort 5 ;
				setitemcolor grpTabs backcolor TAB_BG_COLOR ;
				setitemcolor Type backcolor .1 .2 .37 1 ;
				setitemcolor grpColumn backcolor 0 0 0 0 ;
				setitemcolor typeColumn backcolor 0 0 .4 .15
			}
			mouseEnter { show message_sort ; setitemcolor typeColumn bordercolor 1 1 1 1 ; play "mouse_over"}
			mouseExit { hide message_sort ; setitemcolor typeColumn bordercolor TAB_BORDER_COLOR }
		}

		// VOICE =================================================================
		itemDef
		{
			name voice
			group grpTabs
			type ITEM_TYPE_BUTTON
			style WINDOW_STYLE_FILLED
			rect RECT_VOICE
			backcolor OPTIONS_HEADING_JOIN_COLOR
			forecolor 1 1 1 1
			visible 1
			action
			{
				play "mouse_click" ;
				uiScript ServerSort 6;
				setitemcolor grpTabs backcolor TAB_BG_COLOR ;
				setitemcolor voice backcolor .1 .2 .37 1 ;
				setitemcolor grpColumn backcolor 0 0 0 0 ;
				setitemcolor voiceColumn backcolor 0 0 .4 .15
			}
			mouseEnter { show message_sort ; setitemcolor voiceColumn bordercolor 1 1 1 1 ; play "mouse_over"}
			mouseExit { hide message_sort ; setitemcolor voiceColumn bordercolor TAB_BORDER_COLOR }
		}
		itemDef
		{
			name voiceicon
			style WINDOW_STYLE_SHADER
			rect ORIGIN_VOICE 16 16
			origin 3 0
			background "voice_on"
			visible 1
			decoration
		}

		// PURE ==================================================================
		itemDef
		{
			name pure
			group grpTabs
			type ITEM_TYPE_BUTTON
			style WINDOW_STYLE_FILLED
			rect RECT_PURE
			backcolor OPTIONS_HEADING_JOIN_COLOR
			forecolor 1 1 1 1
			visible 1
			action
			{
				play "mouse_click" ;
				uiScript ServerSort 7 ;
				setitemcolor grpTabs backcolor TAB_BG_COLOR ;
				setitemcolor pure backcolor .1 .2 .37 1 ;
				setitemcolor grpColumn backcolor 0 0 0 0 ;
				setitemcolor pureColumn backcolor 0 0 .4 .15
			}
			mouseEnter { show message_sort ; setitemcolor pureColumn bordercolor 1 1 1 1 ; play "mouse_over"}
			mouseExit { hide message_sort ; setitemcolor pureColumn bordercolor TAB_BORDER_COLOR }
		}
		itemDef
		{
			name pureicon
			style WINDOW_STYLE_SHADER
			rect ORIGIN_PURE 16 16
			origin 2 0
			background "hud_server_pure"
			visible 1
			decoration
		}

		// MOD ===================================================================
		itemDef
		{
			name Mod
			group grpTabs
			type ITEM_TYPE_BUTTON
			style WINDOW_STYLE_FILLED
			rect RECT_MOD
			backcolor OPTIONS_HEADING_JOIN_COLOR
			forecolor 1 1 1 1
			visible 1
			action
			{
				play "mouse_click" ;
				uiScript ServerSort 8 ;
				setitemcolor grpTabs backcolor TAB_BG_COLOR ;
				setitemcolor Mod backcolor .1 .2 .37 1 ;
				setitemcolor grpColumn backcolor 0 0 0 0 ;
				setitemcolor modColumn backcolor 0 0 .4 .15
			}
			mouseEnter { show message_sort ; setitemcolor modColumn bordercolor 1 1 1 1 ; play "mouse_over"}
			mouseExit { hide message_sort ; setitemcolor modColumn bordercolor TAB_BORDER_COLOR }
		}
		itemDef
		{
			name modicon
			style WINDOW_STYLE_SHADER
			rect ORIGIN_MOD 16 16
			origin 2 0
			background "mod_header"
			visible 1
			decoration
		}

		// PB ====================================================================		
		itemDef 
		{
			name pb
			group grpTabs
			type ITEM_TYPE_BUTTON
			style WINDOW_STYLE_FILLED	
			rect RECT_PB
			backcolor OPTIONS_HEADING_JOIN_COLOR
			forecolor 1 1 1 1
			visible 1 
			action 
			{
				play "mouse_click" ; 
				uiScript ServerSort 9 ;
				setitemcolor grpTabs backcolor TAB_BG_COLOR ; 
				setitemcolor pb backcolor .1 .2 .37 1 ;  
				setitemcolor grpColumn backcolor 0 0 0 0 ; 
				setitemcolor pbColumn backcolor 0 0 .4 .15 
			}
			mouseEnter { show message_sort ; setitemcolor pbColumn bordercolor 1 1 1 1 ; play "mouse_over"}
			mouseExit { hide message_sort ; setitemcolor pbColumn bordercolor TAB_BORDER_COLOR }	  	  
		}
		itemDef 
		{
			name pbicon
			style WINDOW_STYLE_SHADER
			rect ORIGIN_PB 16 16
			origin 2 0
			background "punkbusterlogo"
			visible 1
			decoration
		}
				
		// PING ==================================================================
		itemDef
		{
			name Ping
			group grpTabs
			text "@MENU_PING"
			TAB_LABEL_OFFSET
			type ITEM_TYPE_BUTTON
			textscale 0.25
			textfont	UI_FONT_NORMAL
			style WINDOW_STYLE_FILLED
			rect RECT_PING
			textalign ITEM_ALIGN_LEFT
			backcolor .1 .2 .37 1 // Start highlighted
			forecolor 1 1 1 1
			visible 1
			action
			{
				play "mouse_click" ;
				uiScript ServerSort 10 ;
				setitemcolor grpTabs backcolor TAB_BG_COLOR ;
				setitemcolor Ping backcolor .1 .2 .37 1 ;
				setitemcolor grpColumn backcolor 0 0 0 0 ;
				setitemcolor pingColumn backcolor 0 0 .4 .15
			}
			mouseEnter { show message_sort ; setitemcolor pingColumn bordercolor 1 1 1 1 ; play "mouse_over"}
			mouseExit { hide message_sort ; setitemcolor pingColumn bordercolor TAB_BORDER_COLOR }
		}

#undef TABLE_HEIGHT
#define TABLE_HEIGHT	360

// 	BUTTONS	===============================================================

itemDef {
    name serverinfo
    text "@MENU_SERVER_INFO"
	type ITEM_TYPE_BUTTON
	textfont	UI_FONT_NORMAL
    textscale TEXTSIZE_SMALL
	style WINDOW_STYLE_FILLED
	border 1
	bordercolor .1 .1 .1 .25
    rect  70 -26 92 20 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_BOTTOM // 384 270 92 15
	textalign ITEM_ALIGN_CENTER
    textalignx 9		// center
    textaligny 18
	backcolor TAB_BG_COLOR
    forecolor TEXTBUTTON_COLOR
    visible 0
    action { play "mouse_click" ;
	open serverinfo_popmenu }
	mouseEnter { show message_serverinfo ; setitemcolor serverinfo backcolor .1 .2 .37 1 ; play "mouse_over"}
    mouseExit { hide message_serverinfo ; setitemcolor serverinfo backcolor TAB_BG_COLOR }
}

itemDef {
    name findplayer
    text "@MENU_FIND_FRIEND"
	type ITEM_TYPE_BUTTON
	textfont	UI_FONT_NORMAL
    textscale TEXTSIZE_SMALL
	style WINDOW_STYLE_FILLED
	border 1
	bordercolor .1 .1 .1 .25
    rect 160 -26 92 20 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_BOTTOM // 502 270 92 15
	textalign ITEM_ALIGN_CENTER
    textalignx 0		// center
    textaligny 18
	backcolor TAB_BG_COLOR
    forecolor TEXTBUTTON_COLOR
    visible 0
    action { play "mouse_click" ;
	open findplayer_popmenu }
	mouseEnter { show message_findplayer ; setitemcolor findplayer backcolor .1 .2 .37 1 ; play "mouse_over"}
    mouseExit { hide message_findplayer ; setitemcolor findplayer backcolor TAB_BG_COLOR }
}

itemDef {
	name			addFavorite
	text			"@MENU_ADD_TO_FAVORITES"
	type			ITEM_TYPE_BUTTON
	textscale		TEXTSIZE_SMALL
	style			WINDOW_STYLE_FILLED
	textstyle		ITEM_TEXTSTYLE_SHADOWED
	ownerdrawFlag	UI_SHOW_NOTFAVORITESERVERS
	rect			-176 -26 92 20 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_BOTTOM // 140 420 120 14
	textfont		UI_FONT_NORMAL
	textalign		ITEM_ALIGN_CENTER
	textaligny		18
	forecolor		TEXTBUTTON_COLOR
	action {
		play "mouse_click" ;
		uiScript addFavorite;
		open fav_message_popmenu
	}
	visible			0
	mouseEnter		{ show message_addFavorite; play "mouse_over"; }
	mouseExit		{ hide message_addFavorite; }
}

itemDef {
	name			delfavorite
	text			"@MENU_DEL_FAVORITE"
	type			ITEM_TYPE_BUTTON
	textscale		TEXTSIZE_SMALL
	style			WINDOW_STYLE_FILLED
	textstyle		ITEM_TEXTSTYLE_SHADOWED
	textfont		UI_FONT_NORMAL
	ownerdrawFlag	UI_SHOW_FAVORITESERVERS
	rect			-176 -26 92 20 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_BOTTOM // 140 420 120 14
	textalign		ITEM_ALIGN_CENTER
	textaligny		18
	forecolor		TEXTBUTTON_COLOR
	visible			1
	action {
		play		"mouse_click" ;
//			uiScript	DeleteFavorite ;
//			uiScript	UpdateFilter
		open del_fav_popmenu;
	}
	mouseEnter		{ show message_delFavorite; play "mouse_over"; }
	mouseExit		{ hide message_delFavorite; }
}

itemDef {
	name			passwordenter
	text			"@MENU_PASSWORD"
	type			ITEM_TYPE_BUTTON
	textscale		TEXTSIZE_SMALL
	style			WINDOW_STYLE_FILLED
	textstyle		ITEM_TEXTSTYLE_SHADOWED
	textfont		UI_FONT_NORMAL
	rect			-46 -26 80 20 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_BOTTOM // 280 420 90 14
	textalign		ITEM_ALIGN_CENTER
	textaligny		18
	forecolor		TEXTBUTTON_COLOR
	visible			1
	action {
		play "mouse_click" ;
		open password_popmenu
	}
	mouseEnter		{ show message_password; play "mouse_over"; }
	mouseExit		{ hide message_password; }
}
itemDef {
	name			serverinfo
	text			"@MENU_SERVER_INFO"
	type			ITEM_TYPE_BUTTON
	textscale		TEXTSIZE_SMALL
	style			WINDOW_STYLE_FILLED
	textstyle		ITEM_TEXTSTYLE_SHADOWED
	textfont		UI_FONT_NORMAL
	rect			50 -26 92 20 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_BOTTOM // 390 420 100 14
	textalign		ITEM_ALIGN_CENTER
	textaligny		18
	forecolor		TEXTBUTTON_COLOR
	visible			1
	action {
		play "mouse_click" ;
		open serverinfo_popmenu
	}
	mouseEnter		{ show message_password; play "mouse_over"; }
	mouseExit		{ hide message_password; }
}


itemDef {
	name			accept
	text			"@MENU_JOIN_SERVER"
	type			1
	textfont		UI_FONT_NORMAL
	style			WINDOW_STYLE_FILLED
	textstyle		ITEM_TEXTSTYLE_SHADOWED
	rect			160 -26 92 20 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_BOTTOM // 510 420 90 14
	textalign		ITEM_ALIGN_CENTER
	textscale		TEXTSIZE_SMALL
	textaligny		18
	forecolor		TEXTBUTTON_COLOR
	visible			1
	mouseEnter		{ play "mouse_over"}
	action { play "mouse_click"; uiScript JoinServer; }
}
    
itemDef {
	name			back
	text			"@MENU_BACK"
	type			1
	style			WINDOW_STYLE_FILLED
	forecolor		TEXTBUTTON_COLOR
	textstyle		ITEM_TEXTSTYLE_SHADOWED
	rect			-250 -26 40 20 HORIZONTAL_ALIGN_CENTER VERTICAL_ALIGN_BOTTOM
	textfont		UI_FONT_NORMAL
	textalign		ITEM_ALIGN_LEFT
	textscale		TEXTSIZE_SMALL
	textaligny		18
	visible			1
	mouseEnter		{ play "mouse_over"; }
	action 
	{
		play "mouse_click";
		close self;
		close createserver ;
		close joinserver ;
		close multi_menu ;
		open main
	}	
}    
