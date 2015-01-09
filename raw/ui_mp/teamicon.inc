#ifndef SPLITSCREEN_ENABLED
	#define RECT_TEAMICON		10 58 128 128 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN
	#define RECT_TEAMICON2		10 196 128 128 CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN
	#define LOCAL_FORECOLOR		1 1 1 0.275
	#define LOCAL_FORECOLOR2	1 1 1 0.2
#else
	#define RECT_TEAMICON		-66 6 64 64 RIGHTITEM_ALIGN VERTICAL_ALIGN_TOP
	#define RECT_TEAMICON2		-66 100 64 64 RIGHTITEM_ALIGN VERTICAL_ALIGN_TOP
	#define LOCAL_FORECOLOR		1 1 1 0.4
	#define LOCAL_FORECOLOR2	1 1 1 0
#endif

//---------------- icon ----------------
itemDef	{
	style			WINDOW_STYLE_SHADER
	rect			RECT_TEAMICON
	exp				material( dvarString( "g_TeamIcon_Allies" ) );
	forecolor		LOCAL_FORECOLOR
	visible			when ( localVarString( ui_team ) == "marines" ); 
	decoration
}

itemDef	{
	style			WINDOW_STYLE_SHADER
	rect			RECT_TEAMICON
	exp				material( dvarString( "g_TeamIcon_Axis" ) );
	visible			when ( localVarString( ui_team ) == "opfor" );
	forecolor		LOCAL_FORECOLOR
	decoration
}

itemDef	{
	style			WINDOW_STYLE_SHADER
	rect			RECT_TEAMICON
	exp				material( dvarString( "g_TeamIcon_Allies" ) );
	visible			when ( team( name ) == "TEAM_FREE" && localVarString( ui_team ) == "marines" ); 
	forecolor		LOCAL_FORECOLOR
	decoration
}
itemDef	{
	style			WINDOW_STYLE_SHADER
	rect			RECT_TEAMICON
	exp				material( dvarString( "g_TeamIcon_Axis" ) );
	visible			when ( team( name ) == "TEAM_FREE" && localVarString( ui_team ) == "opfor" ); 
	forecolor		LOCAL_FORECOLOR
	decoration
}

//--------------- name -----------------
itemDef 
{
	rect		RECT_TEAMICON2
	exp 		text( "@"+dvarString( "g_TeamName_Allies" ) );
	textfont	UI_FONT_OBJECTIVE
	textscale	TEXTSIZE_DEFAULT
	textalign	ITEM_ALIGN_LEFT
	textstyle	ITEM_TEXTSTYLE_SHADOWEDMORE
	forecolor	LOCAL_FORECOLOR2
	visible 	when ( team( name ) == "TEAM_ALLIES" )
	decoration 
}

itemDef 
{
	rect		RECT_TEAMICON2
	exp 		text( "@"+dvarString( "g_TeamName_Allies" ) );
	textfont	UI_FONT_OBJECTIVE
	textscale	TEXTSIZE_DEFAULT
	textalign	ITEM_ALIGN_LEFT
	textstyle	ITEM_TEXTSTYLE_SHADOWEDMORE
	forecolor	LOCAL_FORECOLOR2
	visible 	when ( team( name ) == "TEAM_FREE" && localVarString( ui_team ) == "marines" )
	decoration 
}
itemDef 
{
	rect		RECT_TEAMICON2
	exp 		text( "@"+dvarString( "g_TeamName_Axis" ) );
	textfont	UI_FONT_OBJECTIVE
	textscale	TEXTSIZE_DEFAULT
	textalign	ITEM_ALIGN_LEFT
	textstyle	ITEM_TEXTSTYLE_SHADOWEDMORE
	forecolor	LOCAL_FORECOLOR2
	visible 	when ( team( name ) == "TEAM_AXIS" )
	decoration 
}
itemDef 
{
	rect		RECT_TEAMICON2
	exp 		text( "@"+dvarString( "g_TeamName_Axis" ) );
	textfont	UI_FONT_OBJECTIVE
	textscale	TEXTSIZE_DEFAULT
	textalign	ITEM_ALIGN_LEFT
	textstyle	ITEM_TEXTSTYLE_SHADOWEDMORE
	forecolor	LOCAL_FORECOLOR2
	visible 	when ( team( name ) == "TEAM_FREE" && localVarString( ui_team ) == "opfor" )
	decoration 
}
