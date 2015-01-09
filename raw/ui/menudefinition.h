// Update menudefinition.h in the code source if you change this file.

#define ITEM_TYPE_TEXT				0		// simple text
#define ITEM_TYPE_BUTTON			1		// button, basically text with a border
#define ITEM_TYPE_RADIOBUTTON		2		// toggle button, may be grouped
#define ITEM_TYPE_CHECKBOX			3		// check box
#define ITEM_TYPE_EDITFIELD 		4		// editable text, associated with a dvar
#define ITEM_TYPE_COMBO 			5		// drop down list
#define ITEM_TYPE_LISTBOX			6		// scrollable list
#define ITEM_TYPE_MODEL 			7		// model
#define ITEM_TYPE_OWNERDRAW 		8		// owner draw, name specs what it is
#define ITEM_TYPE_NUMERICFIELD		9		// editable text, associated with a dvar
#define ITEM_TYPE_SLIDER			10		// mouse speed, volume, etc.
#define ITEM_TYPE_YESNO 			11		// yes no dvar setting
#define ITEM_TYPE_MULTI 			12		// multiple list setting, enumerated
#define ITEM_TYPE_DVARENUM 			13		// multiple list setting, enumerated from a dvar
#define ITEM_TYPE_BIND				14		// bind
#define ITEM_TYPE_MENUMODEL 		15		// special menu model
#define ITEM_TYPE_VALIDFILEFIELD	16		// text must be valid for use in a dos filename
#define ITEM_TYPE_DECIMALFIELD		17		// editable text, associated with a dvar, which allows decimal input
#define ITEM_TYPE_UPREDITFIELD		18		// editable text, associated with a dvar
#define ITEM_TYPE_GAME_MESSAGE_WINDOW 19	// game message window

#define ITEM_ALIGN_LEFT 			0		// aligns left of text to left of containing rectangle
#define ITEM_ALIGN_CENTER			1		// aligns center of text to center of containing rectangle
#define ITEM_ALIGN_RIGHT			2		// aligns right of text to right of containing rectangle
#define ITEM_ALIGN_X_MASK			3

#define ITEM_ALIGN_LEGACY 			0		// aligns bottom of text to top of containing rectangle
#define ITEM_ALIGN_TOP	 			4		// aligns top of text to top of containing rectangle
#define ITEM_ALIGN_MIDDLE			8		// aligns middle of text to middle of containing rectangle
#define ITEM_ALIGN_BOTTOM			12		// aligns bottom of text to bottom of containing rectangle
#define ITEM_ALIGN_Y_MASK			12

#define ITEM_ALIGN_LEGACY_LEFT		0
#define ITEM_ALIGN_LEGACY_CENTER	1
#define ITEM_ALIGN_LEGACY_RIGHT		2
#define ITEM_ALIGN_TOP_LEFT			4
#define ITEM_ALIGN_TOP_CENTER		5
#define ITEM_ALIGN_TOP_RIGHT		6
#define ITEM_ALIGN_MIDDLE_LEFT		8
#define ITEM_ALIGN_MIDDLE_CENTER	9
#define ITEM_ALIGN_MIDDLE_RIGHT		10
#define ITEM_ALIGN_BOTTOM_LEFT		12
#define ITEM_ALIGN_BOTTOM_CENTER	13
#define ITEM_ALIGN_BOTTOM_RIGHT		14

#define ITEM_TEXTSTYLE_NORMAL			0	// normal text
#define ITEM_TEXTSTYLE_BLINK			1	// fast blinking
#define ITEM_TEXTSTYLE_SHADOWED 		3	// drop shadow ( need a color for this )
#define ITEM_TEXTSTYLE_SHADOWEDMORE 	6	// drop shadow ( need a color for this )
#define ITEM_TEXTSTYLE_MONOSPACE		128

#define WINDOW_BORDER_NONE			0		// no border
#define WINDOW_BORDER_FULL			1		// full border based on border color ( single pixel )
#define WINDOW_BORDER_HORZ			2		// horizontal borders only
#define WINDOW_BORDER_VERT			3		// vertical borders only
#define WINDOW_BORDER_KCGRADIENT	4		// horizontal border using the gradient bars
#define WINDOW_BORDER_RAISED		5		// darken the bottom and right sides of the border
#define WINDOW_BORDER_SUNKEN		6		// darken the top and left sides of the border

#define WINDOW_STYLE_EMPTY				0	// no background
#define WINDOW_STYLE_FILLED 			1	// filled with background color
#define WINDOW_STYLE_GRADIENT			2	// gradient bar based on background color
#define WINDOW_STYLE_SHADER 			3	// shader based on background color
#define WINDOW_STYLE_TEAMCOLOR			4	// team color
#define WINDOW_STYLE_DVAR_SHADER		5	// draws the shader specified by the dvar
#define WINDOW_STYLE_LOADBAR 			6	// shader based on background color

#define MODE_BOTTOMUP_ALIGN_TOP		0 // text appears on bottom of list and moves up to specified Y coordinate as old text fades out
#define MODE_BOTTOMUP_ALIGN_BOTTOM	1 // text appears on bottom of list and moves away from specified Y coordinate as new text pushes it up
#define MODE_TOPDOWN_ALIGN_TOP		2 // text appears on top of list and moves away from specified Y coordinate as new text pushes it down
#define MODE_TOPDOWN_ALIGN_BOTTOM	3 // text appears on top of list and moves down to specified Y coordinate as old text fades out

#define MENU_TRUE			1
#define MENU_FALSE			0

#define HUD_VERTICAL			0x00
#define HUD_HORIZONTAL			0x01

#define RANGETYPE_ABSOLUTE		0
#define RANGETYPE_RELATIVE		1

// list box element types
#define LISTBOX_TEXT				0x00
#define LISTBOX_IMAGE				0x01

// list feeders
#define FEEDER_HEADS				0x00	// model heads
#define FEEDER_MAPS 				0x01	// text maps based on game type
#define FEEDER_SERVERS				0x02	// servers
#define FEEDER_CLAN_MEMBERS			0x03	// clan names
#define FEEDER_ALLMAPS				0x04	// all maps available, in graphic format
#define FEEDER_REDTEAM_LIST 		0x05	// red team members
#define FEEDER_BLUETEAM_LIST		0x06	// blue team members
#define FEEDER_PLAYER_LIST			0x07	// players
#define FEEDER_TEAM_LIST			0x08	// team members for team voting
#define FEEDER_MODS 				0x09	// team members for team voting
#define FEEDER_DEMOS				0x0a	// team members for team voting
#define FEEDER_SCOREBOARD			0x0b	// team members for team voting
#define FEEDER_Q3HEADS				0x0c	// model heads
#define FEEDER_SERVERSTATUS 		0x0d	// server status
#define FEEDER_FINDPLAYER			0x0e	// find player
#define FEEDER_CINEMATICS			0x0f	// cinematics
#define FEEDER_SAVEGAMES			0x10	// savegames
#define FEEDER_PICKSPAWN			0x11
#define FEEDER_LOBBY_MEMBERS		0x12	// list of players in your party
#define FEEDER_LOBBY_MEMBERS_TALK	0x13	// icon for whether they are speaking or not
#define FEEDER_MUTELIST				0x14	// list of musted players
#define FEEDER_PLAYERSTALKING		0x15	// list of players who are currently talking
#define FEEDER_SPLITSCREENPLAYERS	0x16	// list of all players who are playing splitscreen
#define FEEDER_LOBBY_MEMBERS_READY	0x17	// icon for whether they are ready or not
#define FEEDER_PLAYER_PROFILES		0x18	// player profiles
#define FEEDER_PARTY_MEMBERS		0x19	// list of players in your party
#define FEEDER_PARTY_MEMBERS_TALK	0x1a	// icon for whether they are speaking or not
#define FEEDER_PARTY_MEMBERS_READY	0x1b	// icon for whether they are ready or not
#define FEEDER_PLAYLISTS			0x1c	// list of all playlists
#define FEEDER_GAMEMODES			0x1d    // list of all game type modes, including any player custom modes
#define FEEDER_LEADERBOARD			0x1e	// list of rows for a leaderboard
#define FEEDER_MYTEAM_MEMBERS		0x20	// list of marine team members
#define FEEDER_MYTEAM_MEMBERS_TALK	0x21	// icon for whether they are speaking
#define FEEDER_ENEMY_MEMBERS		0x22	// list of opfor team members
#define FEEDER_ENEMY_MEMBERS_TALK	0x23	// icon for whether they are speaking
#define FEEDER_LOBBY_MEMBERS_STAT	0x24	// last round stats for lobby members
#define FEEDER_MYTEAM_MEMBERS_STAT	0x25	// last round stats for marine team members
#define FEEDER_ENEMY_MEMBERS_STAT	0x26	// last round stats for opfor team members
#define FEEDER_ONLINEFRIENDS			0x27	// list of your online friends
#define FEEDER_LOBBY_MEMBERS_RANK	0x28	// rank icon
#define FEEDER_PARTY_MEMBERS_RANK	0x29	// rank icon
#define FEEDER_ENEMY_MEMBERS_RANK	0x30	// rank icon
#define FEEDER_MYTEAM_MEMBERS_RANK  0x31	// rank icon

// display flags
#define CG_SHOW_BLUE_TEAM_HAS_REDFLAG		0x00000001
#define CG_SHOW_RED_TEAM_HAS_BLUEFLAG		0x00000002
#define CG_SHOW_ANYTEAMGAME					0x00000004
#define CG_SHOW_CTF 						0x00000020
#define CG_SHOW_OBELISK 					0x00000040
#define CG_SHOW_HEALTHCRITICAL				0x00000080
#define CG_SHOW_SINGLEPLAYER				0x00000100
#define CG_SHOW_TOURNAMENT					0x00000200
#define CG_SHOW_DURINGINCOMINGVOICE 		0x00000400
#define CG_SHOW_IF_PLAYER_HAS_FLAG			0x00000800
#define CG_SHOW_LANPLAYONLY 				0x00001000
#define CG_SHOW_MINED						0x00002000
#define CG_SHOW_HEALTHOK					0x00004000
#define CG_SHOW_TEAMINFO					0x00008000
#define CG_SHOW_NOTEAMINFO					0x00010000
#define CG_SHOW_OTHERTEAMHASFLAG			0x00020000
#define CG_SHOW_YOURTEAMHASENEMYFLAG		0x00040000
#define CG_SHOW_ANYNONTEAMGAME				0x00080000
#define CG_SHOW_TEXTASINT					0x00200000
#define CG_SHOW_HIGHLIGHTED					0x00100000

#define CG_SHOW_NOT_V_CLEAR					0x02000000

#define CG_SHOW_2DONLY						0x10000000


#define UI_SHOW_LEADER						0x00000001
#define UI_SHOW_NOTLEADER					0x00000002
#define UI_SHOW_FAVORITESERVERS 			0x00000004
#define UI_SHOW_ANYNONTEAMGAME				0x00000008
#define UI_SHOW_ANYTEAMGAME 				0x00000010
#define UI_SHOW_NEWHIGHSCORE				0x00000020
#define UI_SHOW_DEMOAVAILABLE				0x00000040
#define UI_SHOW_NEWBESTTIME 				0x00000080
#define UI_SHOW_FFA				 			0x00000100
#define UI_SHOW_NOTFFA						0x00000200
#define UI_SHOW_NETANYNONTEAMGAME			0x00000400
#define UI_SHOW_NETANYTEAMGAME				0x00000800
#define UI_SHOW_NOTFAVORITESERVERS			0x00001000

// font types
#define UI_FONT_DEFAULT			0	// auto-chose betwen big/reg/small
#define UI_FONT_NORMAL			1
#define UI_FONT_BIG				2
#define UI_FONT_SMALL			3
#define UI_FONT_BOLD			4
#define UI_FONT_CONSOLE			5
#define UI_FONT_OBJECTIVE		6

// owner draw types
// ideally these should be done outside of this file but
// this makes it much easier for the macro expansion to
// convert them for the designers ( from the .menu files )
#define CG_OWNERDRAW_BASE			1
#define CG_PLAYER_AMMO_VALUE		5
#define CG_PLAYER_AMMO_BACKDROP		6

#define CG_PLAYER_STANCE			20

#define CG_SPECTATORS				60

#define CG_HOLD_BREATH_HINT			71
#define CG_CURSORHINT				72
#define CG_PLAYER_POWERUP			73
#define CG_PLAYER_HOLDABLE			74
#define CG_PLAYER_INVENTORY			75
#define CG_CURSORHINT_STATUS		78	// like 'health' bar when pointing at a func_explosive

#define CG_PLAYER_BAR_HEALTH		79
#define CG_MANTLE_HINT				80

#define CG_PLAYER_WEAPON_NAME		81
#define CG_PLAYER_WEAPON_NAME_BACK	82

#define CG_CENTER_MESSAGE			90	// for things like "You were killed by ..."

#define CG_TANK_BODY_DIR			95
#define CG_TANK_BARREL_DIR			96

#define CG_DEADQUOTE				97

#define CG_PLAYER_BAR_HEALTH_BACK	98

#define CG_MISSION_OBJECTIVE_HEADER		99
#define CG_MISSION_OBJECTIVE_LIST		100
#define CG_MISSION_OBJECTIVE_BACKDROP	101
#define CG_PAUSED_MENU_LINE				102

#define CG_OFFHAND_WEAPON_ICON_FRAG			103
#define CG_OFFHAND_WEAPON_ICON_SMOKEFLASH	104
#define CG_OFFHAND_WEAPON_AMMO_FRAG			105
#define CG_OFFHAND_WEAPON_AMMO_SMOKEFLASH	106
#define CG_OFFHAND_WEAPON_NAME_FRAG			107
#define CG_OFFHAND_WEAPON_NAME_SMOKEFLASH	108
#define CG_OFFHAND_WEAPON_SELECT_FRAG		109
#define CG_OFFHAND_WEAPON_SELECT_SMOKEFLASH	110
#define CG_SAVING							111
#define	CG_PLAYER_LOW_HEALTH_OVERLAY		112

#define CG_INVALID_CMD_HINT				113
#define CG_PLAYER_SPRINT_METER			114
#define CG_PLAYER_SPRINT_BACK			115

#define CG_PLAYER_WEAPON_BACKGROUND			116
#define CG_PLAYER_WEAPON_AMMO_CLIP_GRAPHIC	117
#define CG_PLAYER_WEAPON_PRIMARY_ICON		118
#define CG_PLAYER_WEAPON_AMMO_STOCK			119
#define CG_PLAYER_WEAPON_LOW_AMMO_WARNING	120

#define CG_PLAYER_COMPASS_TICKERTAPE		145
#define CG_PLAYER_COMPASS_TICKERTAPE_NO_OBJ	146

#define CG_PLAYER_COMPASS_PLAYER		150
#define CG_PLAYER_COMPASS_BACK			151
#define CG_PLAYER_COMPASS_POINTERS		152
#define CG_PLAYER_COMPASS_ACTORS		153
#define CG_PLAYER_COMPASS_TANKS			154
#define CG_PLAYER_COMPASS_HELICOPTERS	155
#define CG_PLAYER_COMPASS_PLANES		156
#define CG_PLAYER_COMPASS_AUTOMOBILES	157
#define CG_PLAYER_COMPASS_FRIENDS		158
#define CG_PLAYER_COMPASS_MAP			159
#define CG_PLAYER_COMPASS_NORTHCOORD	160
#define CG_PLAYER_COMPASS_EASTCOORD		161
#define CG_PLAYER_COMPASS_NCOORD_SCROLL	162
#define CG_PLAYER_COMPASS_ECOORD_SCROLL	163
#define CG_PLAYER_COMPASS_GOALDISTANCE	164

#define CG_PLAYER_ACTIONSLOT_DPAD		165
#define CG_PLAYER_ACTIONSLOT_1			166
#define CG_PLAYER_ACTIONSLOT_2			167
#define CG_PLAYER_ACTIONSLOT_3			168
#define CG_PLAYER_ACTIONSLOT_4			169
#define CG_PLAYER_COMPASS_ENEMIES		170

#define CG_PLAYER_FULLMAP_BACK			180
#define CG_PLAYER_FULLMAP_MAP			181
#define CG_PLAYER_FULLMAP_POINTERS		182
#define CG_PLAYER_FULLMAP_PLAYER		183
#define CG_PLAYER_FULLMAP_ACTORS		184
#define CG_PLAYER_FULLMAP_FRIENDS		185
#define CG_PLAYER_FULLMAP_LOCATION_SELECTOR 186
#define CG_PLAYER_FULLMAP_BORDER		187
#define CG_PLAYER_FULLMAP_ENEMIES		188

#define CG_VEHICLE_RETICLE			190
#define CG_HUD_TARGETS_VEHICLE		191
#define CG_HUD_TARGETS_JAVELIN		192

#define CG_TALKER1					193
#define CG_TALKER2					194
#define CG_TALKER3					195
#define CG_TALKER4					196

#define UI_OWNERDRAW_BASE			200
#define UI_HANDICAP 				200
#define UI_EFFECTS					201
#define UI_PLAYERMODEL				202
#define UI_GAMETYPE 				205
#define UI_SKILL					207
#define UI_NETSOURCE				220
#define UI_NETFILTER				222
#define UI_VOTE_KICK				238
#define UI_NETGAMETYPE				245
#define UI_SERVERREFRESHDATE		247
#define UI_SERVERMOTD				248
#define UI_GLINFO					249
#define UI_KEYBINDSTATUS			250
#define UI_JOINGAMETYPE 			253
#define UI_MAPPREVIEW				254
#define UI_MENUMODEL				257
#define	UI_SAVEGAME_SHOT			258
#define UI_SAVEGAMENAME				262
#define UI_SAVEGAMEINFO				263
#define UI_LOADPROFILING			264
#define UI_RECORDLEVEL				265
#define UI_AMITALKING				266
#define UI_TALKER1					267
#define UI_TALKER2					268
#define UI_TALKER3					269
#define UI_TALKER4					270
#define UI_PARTYSTATUS				271
#define UI_LOGGEDINUSER				272
#define UI_RESERVEDSLOTS			273
#define UI_PLAYLISTNAME				274
#define UI_PLAYLISTDESCRIPTION			275
#define UI_USERNAME					276
#define UI_CINEMATIC				277

// Edge relative placement values for rect->h_align and rect->v_align
#define HORIZONTAL_ALIGN_SUBLEFT		0	// left edge of a 4:3 screen (safe area not included)
#define HORIZONTAL_ALIGN_LEFT			1	// left viewable (safe area) edge
#define HORIZONTAL_ALIGN_CENTER			2	// center of the screen (reticle)
#define HORIZONTAL_ALIGN_RIGHT			3	// right viewable (safe area) edge
#define HORIZONTAL_ALIGN_FULLSCREEN		4	// disregards safe area
#define HORIZONTAL_ALIGN_NOSCALE		5	// uses exact parameters - neither adjusts for safe area nor scales for screen size
#define HORIZONTAL_ALIGN_TO640			6	// scales a real-screen resolution x down into the 0 - 640 range
#define HORIZONTAL_ALIGN_CENTER_SAFEAREA 7	// center of the safearea
#define HORIZONTAL_ALIGN_MAX			HORIZONTAL_ALIGN_CENTER_SAFEAREA
#define HORIZONTAL_ALIGN_DEFAULT		HORIZONTAL_ALIGN_SUBLEFT

#define VERTICAL_ALIGN_SUBTOP			0	// top edge of the 4:3 screen (safe area not included)
#define VERTICAL_ALIGN_TOP				1	// top viewable (safe area) edge
#define VERTICAL_ALIGN_CENTER			2	// center of the screen (reticle)
#define VERTICAL_ALIGN_BOTTOM			3	// bottom viewable (safe area) edge
#define VERTICAL_ALIGN_FULLSCREEN		4	// disregards safe area
#define VERTICAL_ALIGN_NOSCALE			5	// uses exact parameters - neither adjusts for safe area nor scales for screen size
#define VERTICAL_ALIGN_TO480			6	// scales a real-screen resolution y down into the 0 - 480 range
#define VERTICAL_ALIGN_CENTER_SAFEAREA	7	// center of the save area
#define VERTICAL_ALIGN_MAX				VERTICAL_ALIGN_CENTER_SAFEAREA
#define VERTICAL_ALIGN_DEFAULT			VERTICAL_ALIGN_SUBTOP
