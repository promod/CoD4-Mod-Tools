#include maps\_anim;
#using_animtree("generic_human");

main()
{	
	level.scr_anim[ "price" ][ "tank_talk" ] 				= %bog_a_tank_dialogue;
	level.scr_anim[ "left_guy" ][ "tank_talk" ] 			= %bog_a_tank_dialogue_guyL;
	level.scr_anim[ "right_guy" ][ "tank_talk" ] 			= %bog_a_tank_dialogue_guyR;

	level.scr_anim[ "price" ][ "tank_talk_idle" ][ 0 ]		= %bog_a_tank_dialogue_idle;
	level.scr_anim[ "left_guy" ][ "tank_talk_idle" ][ 0 ]	= %bog_a_tank_dialogue_guyL_idle;
	level.scr_anim[ "right_guy" ][ "tank_talk_idle" ][ 0 ]	= %bog_a_tank_dialogue_guyR_idle;
	
	//Listen up. We don’t have much time to get this tank outta here. 
	//We’ll take up defensive positions around the bog here, here, and here, and buy 
	//the engineers some time to get the tank moving. Oorah?
//	level.scr_sound[ "price" ][ "tank_talk" ]				= "bog_vsq_donthavemuchtime";

	addNotetrack_dialogue( "price", "dialog", "tank_talk", "bog_vsq_listenup" );
	addNotetrack_dialogue( "price", "dialog", "tank_talk", "bog_vsq_donthavemuchtime" );
	addNotetrack_dialogue( "price", "dialog", "tank_talk", "bog_vsq_defensivepositions" );
	addNotetrack_dialogue( "price", "dialog", "tank_talk", "bog_vsq_oorah" );
	
	
	// Alpha Six what's your status over?
	level.scr_radio[ "alphasixstatus" ]						= "bog_a_vsq_alphasixstatus";
	
	//All right let’s move out! Secure the southern approach, move!
	level.scr_sound[ "price" ][ "letsmoveout" ]				= "bog_a_vsq_letsmoveout";
	
	//Two Charlie, Bravo Six! Requesting air support for fire mission, over!
	level.scr_sound[ "price" ][ "twocharliebravosix" ]			= "bog_a_vsq_twocharliebravosix";
	
	// Carver! Find that ZPU and take it out so we can get some air support! Lopez! Gaines! Cover him!
	level.scr_sound[ "price" ][ "jacksonfindzpu" ]					= "bog_a_vsq_Jacksonfindzpu";
	
	//Roger that!
	level.scr_sound[ "marine" ][ "rogerthat" ]				= "bog_a_gm1_rogerthat";
	
	//Carver, plant the C4 on the gun, move!	
	level.scr_sound[ "marine" ][ "plantc4" ]				= "bog_gm1_plantc4";
	
	//Good job, let's get to a safe distance!
	level.scr_sound[ "marine" ][ "goodjob" ]				= "bog_gm1_goodjob";
	
	//We're good to go! Carver - do it!	
	level.scr_sound[ "marine" ][ "jacksondoit" ]				= "bog_gm1_Jacksondoit";
	
	//Vampire Six-Four! Fire mission at grid 238165! We’re lightin’ up the target!! Confirm!
	level.scr_sound[ "price" ][ "vampiresixfour" ]				= "bog_vsq_vampiresixfour";
	
	//Command, LZ is secure. Bring in the engineers and let’s get this tank moving.
	level.scr_sound[ "price" ][ "lzissecure" ]				= "bog_vsq_lzissecure";
	
	//Squad, regroup at the tank, let’s go!
	level.scr_sound[ "left_guy" ][ "regroupattank" ]				= "bog_blk_regroupattank";
	//level.scr_radio[ "regroupattank" ]							= "bog_blk_regroupattank";
	
	//Listen up. We don’t have much time to get this tank outta here. 
	//We’ll take up defensive positions around the bog here, here, and here, and buy 
	//the engineers some time to get the tank moving. Oorah?
	level.scr_sound[ "price" ][ "donthavemuchtime" ]				= "bog_vsq_donthavemuchtime";
	
	//Listen up.
	level.scr_sound[ "price" ][ "listen_up" ]				= "bog_vsq_listenup";
	
	//we don't have much time to get this tank outta here
	level.scr_sound[ "price" ][ "dont_have_much_time" ]				= "bog_vsq_donthavemuchtime";
	
	//we'll take up defensive positions around the bog here, here, and here, and buy the engineers some time to get the tank moving.
	level.scr_sound[ "price" ][ "defensive_positions" ]				= "bog_vsq_defensivepositions";
	
	//oorah
	level.scr_sound[ "price" ][ "oorah" ]				= "bog_vsq_oorah";
	
	
	
	//Oorah.
	level.scr_sound[ "gm1" ][ "oorah" ]								= "bog_gm1_oorah";
	
	//Oorah.
	level.scr_sound[ "gm2" ][ "oorah" ]								= "bog_gm2_oorah";
	
	//Oorah.
	level.scr_sound[ "gm3" ][ "oorah" ]								= "bog_gm3_oorah";
	
	//All right, move out!
	level.scr_sound[ "price" ][ "allrightmoveout" ]					= "bog_vsq_allrightmoveout";
	
	// ************************************************************************************
	// RADIO
	// ************************************************************************************

	// We're still surrounded sir! There's just the four of us left but the tank's still ok Over!
	level.scr_radio[ "stillsurrounded" ]					= "bog_a_gm1_stillsurrounded";

	// Contacts to the east and more flanking to the south! Hold the perimeter!!!
	level.scr_radio[ "contactseast" ]						= "bog_a_vsq_contactseast";

	// They're movin' in with detpacks! Don't let 'em get close to the tank!
	level.scr_radio[ "movingindetpacks" ]					= "bog_a_vsq_movingindetpacks";

	// Be advised, our main gun is offline but we still have the co-ax machine gun, out.
	level.scr_radio[ "maingunsoffline" ]					= "bog_tcm_maingunsoffline";
	
	// Carver this is Price. We're in danger of being overrun. Pull back to the tank now!
	level.scr_radio[ "dangeroverrun" ]					= "bog_a_vsq_dangeroverrun";
	
	// Carver this is Price! You tryin' to go AWOL? Pull back to the tank, now!
	level.scr_radio[ "jacksonawol" ]						= "bog_a_vsq_Jacksonawol";
	
	// Carver this is Price. Fall back to the tank, that's an order.
	level.scr_radio[ "fallbacktank" ]					= "bog_a_vsq_fallbacktank";
	
	// Bravo Six, be advised, more hostiles assembling to the west of your position over.
	level.scr_radio[ "morewest" ]					= "bog_a_hqr_morewest";
	
	// All right let’s move out! Secure the western approach, move!
	level.scr_radio[ "securewest" ]					= "bog_a_vsq_securewest";
	
	// Uh, negative Bravo Six, there's an enemy ZPU to the south of your position. 
	// Until you take it out, we can NOT risk sending in any more choppers over.
	level.scr_radio[ "negativebravo" ]					= "bog_a_hqr_negativebravo";
	
	// Carver, I've got air support on the way but they need our exact location. 
	// Plant the IR beacon and get their attention. Out.
	level.scr_radio[ "plantbeacon" ]					= "bog_a_vsq_plantbeacon";
	
	//They've got that building buttoned up! We need to call in the air support!! Jackson! Plant the IR beacon!!
	level.scr_radio[ "buttonedup" ]					= "bog_a_vsq_buttonedup";
	
	//Where - is - the - air suppooort???!
	level.scr_radio[ "whereistheairsupport" ]			= "bog_gm1_airsupport";
	
	//We can't take that building without some air support! Jackson! Plant the beacon!!!
	level.scr_radio[ "canttakebuilding" ]			= "bog_gm2_plantbeacon";
	
	//Those machine guns are rippin' us apart! Jackson! Plant the IR beacon and get those choppers over here! Now!
	level.scr_radio[ "rippingusapart" ]			= "bog_a_vsq_rippingusapart";
	
	// Standby.
	level.scr_radio[ "standby" ]						= "bog_plt_standby";
	
	// Ok, positive ID on your sparkle. We’re comin’ in hot from the northeast.
	level.scr_radio[ "cominhot" ]						= "bog_plt_cominhot";
	
	//Uh, two, you see anyone left down there?
	level.scr_radio[ "seeanyoneleft" ]					= "bog_cop_negative";
	
	//Negative, we got ‘em.
	level.scr_radio[ "negative" ]						= "bog_plt_seeanyoneleft";
	
	//Roger that. All targets destroyed and we’re outta here. Good luck boys. Out.
	level.scr_radio[ "alltargetsdestroyed" ]						= "bog_plt_alltargetsdestroyed";
	
	//Roger that. They’re on the way. Good work. Out.
	level.scr_radio[ "goodworkout" ]						= "bog_hqr_goodworkout";
	
	//Price on headset
	//bog_radio_dialogue
	
	//Price next to tank standing idle
	//bog_a_tank_dialogue_idle
	
	//Price talking
	//bog_a_tank_dialogue
	
	//Friendly stepping out of the way as player approaches
	//bog_a_tank_dialogue_guyL
	//bog_a_tank_dialogue_guyL_idle
	
	//Friendly stepping out of the way as player approaches
	//bog_a_tank_dialogue_guyR
	//bog_a_tank_dialogue_guyR_idle
}
