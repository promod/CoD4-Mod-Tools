// Shared left side buttons, included by everywhere vote sub-menu
#undef	CHOICE_SIZE_X
#define CHOICE_SIZE_X		220

#undef CHOICE_X_START
#define CHOICE_X_START		-324

#undef CHOICE_HORIZONTAL_ALIGN
#define CHOICE_HORIZONTAL_ALIGN HORIZONTAL_ALIGN_CENTER

#undef CHOICE_VERTICAL_ALIGN
#define CHOICE_VERTICAL_ALIGN VERTICAL_ALIGN_TOP

CHOICE_BUTTON( 2, "@MPUI_RESTART_MAP", exec "cmd callvote map_restart"; close self; )
CHOICE_BUTTON( 3, "@MPUI_NEXT_MAP", exec "cmd callvote map_rotate"; close self; )
CHOICE_BUTTON( 4, "@MPUI_CHANGE_MAP", open changemap; close changegametype; close kickplayer; close callvote; )
CHOICE_BUTTON( 5, "@MPUI_CHANGE_GAME_TYPEMAP", open changegametype; close changemap; close kickplayer; close callvote; )
CHOICE_BUTTON( 6, "@MPUI_KICK_PLAYER", open kickplayer; close changemap; close changegametype; close callvote; )

// restoring position/size
#undef	CHOICE_SIZE_X
#define CHOICE_SIZE_X		200

#undef  SECTION_X_OFFSET
#define SECTION_X_OFFSET 	60
