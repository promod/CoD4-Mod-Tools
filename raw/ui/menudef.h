#include "ui/menudefinition.h"

// Size define for the hud compass
// These are used for both the dynamic & non-dynamic compass drawing
// If these are changed, the cgame should be recompiled
#define COMPASS_SIZE		109
#define MINIMAP_X			11.5
#define MINIMAP_Y			5 
#define MINIMAP_W			89.5
#define	MINIMAP_H			89.5

#define COMPASS_SIZE_MP		125
#define MINIMAP_X_MP			0
#define MINIMAP_Y_MP			12
#define MINIMAP_W_MP			102
#define	MINIMAP_H_MP			102

#define FULLSCREEN			0 0 640 480
#define FULLSCREEN_WIDE		-107 0 854 480

#define ORIGIN_TITLE		48 40
#define ORIGIN_TITLE_SS		104 120

//#define FONTSCALE_SMALL		0.3125 // 15
//#define FONTSCALE_SMALL		0.3333 // 16
#define FONTSCALE_SMALL		0.3750 // 18
#define FONTSCALE_NORMAL	0.4583
#define FONTSCALE_BOLD		0.4583
#define FONTSCALE_BIG		0.5833
#define FONTSCALE_EXTRABIG	1.0000

// new settings
#define TEXTSIZE_SMALL		FONTSCALE_SMALL
#define TEXTSIZE_SMALL_SS	(FONTSCALE_SMALL*2)
#define TEXTSIZE_DEFAULT	FONTSCALE_NORMAL
#define TEXTSIZE_DEFAULT_SS	(FONTSCALE_NORMAL*2)
#define TEXTSIZE_TITLE		FONTSCALE_BIG
#define TEXTSIZE_TITLE_SS	1
// end new settings
/*
// old settings
#define TEXTSIZE_SMALL		0.333
#define TEXTSIZE_SMALL_SS	0.666
#define TEXTSIZE_DEFAULT	0.45
#define TEXTSIZE_DEFAULT_SS	0.9
#define TEXTSIZE_TITLE		0.5
#define TEXTSIZE_TITLE_SS	1
// end old settings
*/

#define TEXTSIZE_BOLD		TEXTSIZE_DEFAULT
#define TEXTSIZE_BIG		TEXTSIZE_TITLE

#define COLOR_TITLE			1 0.8 0.4 1
#define COLOR_FOCUSED		1 1 1 1
#define COLOR_UNFOCUSED		0.4823 0.4823 0.4823 1
#define COLOR_DISABLED		0.35 0.35 0.35 1
#define COLOR_SAFEAREA		0 0 1 1

#define	BUTTON_A			1
#define	BUTTON_B			2
#define	BUTTON_X			3
#define	BUTTON_Y			4
#define	BUTTON_LSHLDR		5
#define	BUTTON_RSHLDR		6
#define	BUTTON_START		14
#define	BUTTON_BACK			15
#define	BUTTON_LSTICK		16
#define	BUTTON_RSTICK		17
#define	BUTTON_LTRIG		18
#define	BUTTON_RTRIG		19
#define	DPAD_UP				20
#define	DPAD_DOWN			21
#define	DPAD_LEFT			22
#define	DPAD_RIGHT			23
#define APAD_UP			28
#define APAD_DOWN		29
#define APAD_LEFT		30
#define APAD_RIGHT		31

#define	COLOR_USMC		0.6 0.64 0.69
#define COLOR_ARAB		0.65 0.57 0.41
#define COLOR_USSR		0.52 0.28 0.28
#define COLOR_SAS		0 0 0

#define DEFAULT_MP_CFG			"default_mp.cfg"
#define SPLITSCREEN_MP_CFG		"default_splitscreen.cfg"
#define SYSTEMLINK_MP_CFG		"default_systemlink.cfg"
#define XBOXLIVE_MP_CFG			"default_xboxlive.cfg"

#define MAX_RANK		int(tableLookup( "mp/rankTable.csv", 0, "maxrank", 1))
#define MAX_PRESTIGE	int(tableLookup( "mp/rankIconTable.csv", 0, "maxprestige", 1))

#define PRESTIGE_AVAIL (stat(2326) < MAX_PRESTIGE && stat(2301) == int(tableLookup("mp/rankTable.csv",0,MAX_RANK,7)))
#define PRESTIGE_NEXT (stat(2326) < MAX_PRESTIGE && stat(252) == MAX_RANK)
#define PRESTIGE_FINISH (stat(2326) == MAX_PRESTIGE)

#define CAN_RANK_UP	(stat(252) < MAX_RANK || stat(2326) < MAX_PRESTIGE)

