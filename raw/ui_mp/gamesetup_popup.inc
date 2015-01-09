//===========================================================
//=================== game setup popup ======================
//===========================================================

#undef CHOICE_SIZE_X
#define CHOICE_SIZE_X			216 //178

#define GAMESETUP_POPUP_X				(0)
#define GAMESETUP_POPUP_Y				(CHOICE_Y( 2 )+4)

#define LOCAL_GAMERULES_ACTION \
	uiScript openMenuOnDvar "ui_gametype" war "settings_quick_war"; \
	uiScript openMenuOnDvar "ui_gametype" sd "settings_quick_sd"; \
	uiScript openMenuOnDvar "ui_gametype" sab "settings_quick_sab"; \
	uiScript openMenuOnDvar "ui_gametype" dm "settings_quick_dm"; \
	uiScript openMenuOnDvar "ui_gametype" dom "settings_quick_dom"; \
	uiScript openMenuOnDvar "ui_gametype" ctf "settings_quick_ctf"; \
	uiScript openMenuOnDvar "ui_gametype" koth "settings_quick_koth";

#define GAMESETUP_POPUP( pname, ptype, pconfig ) \
menuDef	{\
	IMPROVED_POPUP_SETUP( pname, 3, GAMESETUP_POPUP_X, GAMESETUP_POPUP_Y, ;, 1 )\
	/*PREPROC_SHADER_DRAW_ALIGNED( (CHOICE_POPUP_WIDTH-6) -4 260 CHOICE_POPUP_HEIGHT( 3 ) CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0 0, "white", CHOICE_POPUP_BORDER_COLOR, 1, 2, CHOICE_POPUP_BORDER_COLOR )*/\
	/*LOADOUT_PLATING_RAW( CHOICE_POPUP_WIDTH 8, -2, 0, 260, (CHOICE_POPUP_HEIGHT( 3 )-4), CHOICE_HORIZONTAL_ALIGN CHOICE_VERTICAL_ALIGN, 0, 0 ) */\
	CHOICE_BUTTON_FOCUS( 1, "@MPUI_CHANGE_MAP", open "settings_map"ptype;, exec "set ui_hint_text @MPUI_DESC_CHANGE_MAP", exec "set ui_hint_text @NULL_EMPTY" )\
	CHOICE_BUTTON_FOCUS( 2, "@MPUI_CHANGE_GAME_MODE", open "settings_gametype";, exec "set ui_hint_text @MPUI_DESC_CHANGE_GAMETYPE", exec "set ui_hint_text @NULL_EMPTY" )\
	CHOICE_BUTTON_FOCUS( 3, "@MPUI_GAME_RULES", LOCAL_GAMERULES_ACTION, exec "set ui_hint_text @MPUI_DESC_CHANGE_RULES", exec "set ui_hint_text @NULL_EMPTY" )\
	/* description*/\
	/*PREPROC_TEXT_DRAW_EXP( 160 4 200 80, 0 0, exp text( dvarString(ui_hint_text) ), TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_LEFT, CHOICE_TEXTCOLOR autowrapped )*/\
}

#define GAMESETUP_POPUP_PRIVATE( pname, ptype, pconfig ) \
menuDef	{\
	IMPROVED_POPUP_SETUP_ONOPEN( pname, 4, GAMESETUP_POPUP_X, GAMESETUP_POPUP_Y, ;, \
	execondvarintvalue sv_privateClients 18 "set ui_jip_button_name @MPUI_JOININPROGRESS_NOT_ALLOWED";\
	execondvarintvalue sv_privateClients 1 "set ui_jip_button_name @MPUI_JOININPROGRESS_ALLOWED";, 1 )\
	CHOICE_BUTTON_FOCUS( 1, "@MPUI_CHANGE_MAP", open "settings_map"ptype;, exec "set ui_hint_text @MPUI_DESC_CHANGE_MAP", exec "set ui_hint_text @NULL_EMPTY" )\
	CHOICE_BUTTON_FOCUS( 2, "@MPUI_CHANGE_GAME_MODE", open "settings_gametype";, exec "set ui_hint_text @MPUI_DESC_CHANGE_GAMETYPE", exec "set ui_hint_text @NULL_EMPTY" )\
	CHOICE_BUTTON_FOCUS( 3, "@MPUI_GAME_RULES", LOCAL_GAMERULES_ACTION, exec "set ui_hint_text @MPUI_DESC_CHANGE_RULES", exec "set ui_hint_text @NULL_EMPTY" )\
	CHOICE_BUTTON_FOCUS( 4, dvarString( ui_jip_button_name ), execnow "toggle sv_privateClients 1 18; xsessionupdate;"; \
	execondvarintvalue sv_privateClients 18 "set ui_jip_button_name @MPUI_JOININPROGRESS_NOT_ALLOWED";\
	execondvarintvalue sv_privateClients 1 "set ui_jip_button_name @MPUI_JOININPROGRESS_ALLOWED";,\
	exec "set ui_hint_text @MPUI_DESC_PRIVATE_JIP", exec "set ui_hint_text @NULL_EMPTY" )\
}