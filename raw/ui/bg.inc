#undef	FOG_SCROLL_TIME
#define FOG_SCROLL_TIME 60000 //30000

#undef	THINFOG_SCROLL_TIME
#define THINFOG_SCROLL_TIME 100000 //50000

itemDef
{
	style			WINDOW_STYLE_SHADER
	rect			FULLSCREEN_WIDE
	background		"animbg_back"
	visible			when( dvarString( fs_game ) == "" )
	decoration
}

itemDef
{
	style			WINDOW_STYLE_SHADER
	rect			-107 0 1708 480
	exp				rect X((-107) - ((float(milliseconds() % FOG_SCROLL_TIME) / FOG_SCROLL_TIME) * (854)))
	background		"animbg_fogscroll"
	visible			when( dvarString( fs_game ) == "" )
	decoration
}
itemDef
{
	style			WINDOW_STYLE_SHADER
	rect			-107 0 1708 480
	exp				rect X((-961) + ((float(milliseconds() % THINFOG_SCROLL_TIME) / THINFOG_SCROLL_TIME) * (854)))
	background		"animbg_fogscrollthin"
	visible			when( dvarString( fs_game ) == "" )
	decoration
}
itemDef
{
	style			WINDOW_STYLE_SHADER
	rect			FULLSCREEN_WIDE
	background		"animbg_front"
	visible			when( dvarString( fs_game ) == "" )
	decoration
}

itemDef
{
	style			WINDOW_STYLE_SHADER
	rect			FULLSCREEN_WIDE
	background		"animbg_front2"
	visible			when( dvarString( fs_game ) == "" )
	decoration
}


itemDef
{
	style			WINDOW_STYLE_SHADER
	rect			FULLSCREEN_WIDE
	background		"animbg_back"
	forecolor		0.8 0.8 1 1
	visible			when( dvarString( fs_game ) != "" )
	decoration
}

itemDef
{
	style			WINDOW_STYLE_SHADER
	rect			-107 0 1708 480
	exp				rect X((-107) - ((float(milliseconds() % FOG_SCROLL_TIME) / FOG_SCROLL_TIME) * (854)))
	forecolor		0.8 0.8 1 1
	background		"animbg_fogscroll"
	visible			when( dvarString( fs_game ) != "" )
	decoration
}
itemDef
{
	style			WINDOW_STYLE_SHADER
	rect			-107 0 1708 480
	exp				rect X((-961) + ((float(milliseconds() % THINFOG_SCROLL_TIME) / THINFOG_SCROLL_TIME) * (854)))
	background		"animbg_fogscrollthin"
	forecolor		0.8 0.8 1 1
	visible			when( dvarString( fs_game ) != "" )
	decoration
}
itemDef
{
	style			WINDOW_STYLE_SHADER
	rect			FULLSCREEN_WIDE
	background		"animbg_front"
	forecolor		0.8 0.8 1 1
	visible			when( dvarString( fs_game ) != "" )
	decoration
}

itemDef
{
	style			WINDOW_STYLE_SHADER
	rect			FULLSCREEN_WIDE
	background		"animbg_front2"
	forecolor		0.8 0.8 1 1
	visible			when( dvarString( fs_game ) != "" )
	decoration
}

