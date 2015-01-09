#define STAT_CAC			260
#define	STAT_CHALLENGES		263
#define STAT_CLAN_TAG		261
#define STAT_PRESTIGE		259

#define STAT_CHALLENGE_TIER1	270
#define STAT_CHALLENGE_TIER2	271
#define STAT_CHALLENGE_TIER3	272
#define STAT_CHALLENGE_TIER4	273
#define STAT_CHALLENGE_TIER5	274
#define STAT_CHALLENGE_TIER6	275
#define STAT_CHALLENGE_TIER7	276
#define STAT_CHALLENGE_TIER8	277
#define STAT_CHALLENGE_TIER9	278
#define STAT_CHALLENGE_TIER10	279

#define WEAPON_NEW_BITMASK		65536
#define NEW_WEAPON_BITMASK		65536
#define ACOG_NEW_BITMASK		131072
#define REDDOT_NEW_BITMASK		262144
#define SILENCER_NEW_BITMASK	524288
#define GRIP_NEW_BITMASK		1048576
#define GL_NEW_BITMASK			2097152

#define DESERT_NEW_BITMASK		16777216
#define WOODLAND_NEW_BITMASK	33554432	
#define DIGITAL_NEW_BITMASK		67108864
#define REDTIGER_NEW_BITMASK	134217728	
#define BLUETIGER_NEW_BITMASK	268435456	
#define GOLDEN_NEW_BITMASK		536870912
#define PRESTIGE_NEW_BITMASK	1073741824	

#define NEW_ATTACHMENTS_MASK	(ACOG_NEW_BITMASK + REDDOT_NEW_BITMASK + SILENCER_NEW_BITMASK + GRIP_NEW_BITMASK + GL_NEW_BITMASK)
#define NEW_CAMO_MASK			(DESERT_NEW_BITMASK + WOODLAND_NEW_BITMASK + DIGITAL_NEW_BITMASK + REDTIGER_NEW_BITMASK + BLUETIGER_NEW_BITMASK + GOLDEN_NEW_BITMASK + PRESTIGE_NEW_BITMASK)
#define NEW_ITEMS_MASK			(NEW_ATTACHMENTS_MASK+NEW_CAMO_MASK)

#define ANY_NEW_WEAPONS_ITEMS	(statRangeAnyBitsSet( 3000, 3089, NEW_ITEMS_MASK ))
#define ANY_NEW_WEAPONS			(statRangeAnyBitsSet( 3000, 3089, WEAPON_NEW_BITMASK ))

#define ANY_NEW_PERK1			( statRangeAnyBitsSet( 173, 189, 2 ) || stat(165) > 1 || stat(155) > 1 )
#define ANY_NEW_PERK2			( stat(160) > 1 || stat(167) > 1 || stat(166) > 1 || stat(164) > 1 || stat(163) > 1 || stat(156) > 1 || stat(151) > 1 )
#define ANY_NEW_PERK3			( stat(154) > 1 || stat(162) > 1 || stat(157) > 1 || stat(158) > 1 || stat(161) > 1 || stat(152) > 1 || stat(150) > 1 || stat(153) > 1 )
#define ANY_NEW_PERKS			(ANY_NEW_PERK1 || ANY_NEW_PERK2 || ANY_NEW_PERK3)

#define ANY_NEW_CAC				(ANY_NEW_WEAPONS || ANY_NEW_PERKS || stat(260) > 1)

#define ANY_NEW_CHALLENGES		(statRangeAnyBitsSet(270, 279, 2) || stat(263) > 1)

#define ANY_NEW_BARRACKS		( ANY_NEW_CHALLENGES || stat( 261 )>1 || stat( 259 )>1 || ( PRESTIGE_AVAIL && stat( 267 )==0 ) )

#define CAC_PRIMARY_STORAGE		2400
#define CAC_SECONDARY_STORAGE	2401
#define CAC_S_PRIMARY_STORAGE	"2400"
#define CAC_S_SECONDARY_STORAGE	"2401"
#define CAC_TEMP_STORAGE		2402
#define CAC_S_TEMP_STORAGE		"2402"

/* 	refString: "m16", "m4", etc...
	Puts the weapons stat index (3000 to 3089) into temp storage stat.
	Puts that into a temp dvar.
	Clear the weapon new bit at that stat address.
	Clears the temp storage stat good measure.
*/
#define CLEAR_WEAP_NEW( refString ) \
	statsetusingtable( CAC_TEMP_STORAGE, tableLookup( "mp/statstable.csv", 4, refString, 1 ) ); \
	execNow "statGetInDvar "CAC_S_TEMP_STORAGE" ui_tempStorage"; \
	CLEAR_NEW( ui_tempStorage, WEAPON_NEW_BITMASK ); \
	setDvar ui_tempStorage "";

#define CLEAR_PERK_NEW( refString ) \
	statClearPerkNew( refString );

#define CLEAR_NEW( statDvar, bitMask ) \
	setDvar ui_tempMask bitMask; \
	statClearBitMask statDvar ui_tempMask;