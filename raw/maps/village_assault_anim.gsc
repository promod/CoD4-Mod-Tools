#include maps\_anim;
#using_animtree( "generic_human" );
main()
{
	//--------------------
	// OPENING ANIMS
	//--------------------
	level.scr_anim[ "price" ][ "opening" ] 					= %village_intro_price;
	level.scr_anim[ "opening_guy" ][ "opening" ] 			= %village_intro_contact;
	
	//--------------------
	// OPENING DIALOG
	//--------------------
	
	//There's Kamarov's man, let's go.
	level.scr_sound[ "price" ][ "kamarovsman" ]				= "vassault_pri_kamarovsman";
	
	//Al-Asad is in the village. The Ultranationalists are protecting him.
	level.scr_sound[ "opening_guy" ][ "asadinvillage" ]		= "vassault_ru4_asadinvillage";
	
	//Perfect. Move out.
	level.scr_sound[ "price" ][ "perfect" ]					= "vassault_pri_perfect";
	
	//What the bloody hell's going on up there?
	level.scr_sound[ "gaz" ][ "whatsgoingon" ]				= "vassault_gaz_whatsgoingon";
	
	//It's the Ultranationalists. They're killing the villagers.
	level.scr_sound[ "opening_guy" ][ "killingvillagers" ]	= "vassault_ru4_killingvillagers";
	
	//Not for long they're not.
	level.scr_sound[ "gaz" ][ "notforlong" ]				= "vassault_gaz_notforlong";
	
	//--------------------
	// Scene A
	//--------------------
	level.scr_anim[ "price" ][ "interrogationA" ] 			= %village_interrogationA_Price;
	level.scr_anim[ "alasad" ][ "interrogationA" ] 			= %village_interrogationA_Zak;
	addNotetrack_customFunction( "price", "gun_2_chest", maps\village_assault_code::alasad_notetracks );
	
	//--------------------
	// Scene B
	//--------------------
	level.scr_anim[ "price" ][ "interrogationB" ] 			= %village_interrogationB_Price;
	level.scr_anim[ "gaz" ][ "interrogationB" ] 			= %village_interrogationB_Gaz;
	level.scr_anim[ "alasad" ][ "interrogationB" ] 			= %village_interrogationB_Zak;
	
	script_model_anims();
	dialog();
}

#using_animtree( "script_model" );
script_model_anims()
{
	//--------------------
	// Scene A
	//--------------------
	level.scr_anim[ "door" ][ "interrogationA" ]			= %village_interrogationA_door;
	level.scr_animtree[ "door" ] 							= #animtree;	
	level.scr_model[ "door" ] 								= "com_door_01_handleleft_brown";
	
	level.scr_anim[ "phone" ][ "interrogationA" ]			= %village_interrogationA_phone;
	level.scr_animtree[ "phone" ] 							= #animtree;	
	level.scr_model[ "phone" ] 								= "com_cellphone_on_ANIM";
	
	//--------------------
	// Scene B
	//--------------------
	level.scr_anim[ "chair" ][ "interrogationB" ]			= %village_interrogationB_chair;
	level.scr_animtree[ "chair" ] 							= #animtree;	
	level.scr_model[ "chair" ] 								= "com_folding_chair";
	
	level.scr_anim[ "phone" ][ "interrogationB" ]			= %village_interrogationB_phone;
	level.scr_animtree[ "phone" ] 							= #animtree;	
	level.scr_model[ "phone" ] 								= "com_cellphone_on_ANIM";
}

dialog()
{
	//-------------------------
	// PRICE
	//-------------------------
	
	// Remember, we want Al-Asad alive. He's no good to us dead. Let's go.
	level.scr_sound[ "price" ][ "nogooddead" ] = "vassault_pri_nogooddead";
	
	// Soap! Call in air support on that building!	
	level.scr_sound[ "price" ][ "airsupport" ] = "vassault_pri_airsupport";
	
	// Use our air support to soften up that building!
	level.scr_sound[ "price" ][ "softenup" ] = "vassault_pri_softenup";
	
	//-------------------------
	// GAZ
	//-------------------------
	
	// Building clear. No sign of Al-Asad. Move on.
	level.scr_sound[ "gaz" ][ "nosign" ] = "vassault_gaz_nosign";
	
	// Building is clear. Move on to the next one.
	level.scr_sound[ "gaz" ][ "nextone" ] = "vassault_gaz_nextone";
	
	// This building's clear! Let's check the other buildings!
	level.scr_sound[ "gaz" ][ "checkother" ] = "vassault_gaz_checkother";
	
	// Building clear. Let's check the next one.
	level.scr_sound[ "gaz" ][ "checknext" ] = "vassault_gaz_checknext";
	
	//-------------------------
	// RUSSIAN HELICOPTER PILOT
	//-------------------------
	
	// Mosin Two-Five here. We're on the way. Standby for air support.
	level.scr_radio[ "ontheway" ] 			= "vassault_rhp_ontheway";
	
	// Helicopter is on the way. We'll handle it. Out.
	level.scr_radio[ "helicopteronway" ] 	= "vassault_rhp_helicopteronway";
	
	// This is Mosin Two-Five, we have the target. Standby.
	level.scr_radio[ "wehavetarget" ] 		= "vassault_rhp_wehavetarget";
	
	// This is Two-Five. We have to refuel and rearm. We will not be available for some time.
	level.scr_radio[ "refuelandrearm" ] 	= "vassault_rhp_refuelandrearm";
	
	// Mosin Two-Five here. We are ready to attack and are standing by for new orders.
	level.scr_radio[ "readytoattack" ] 		= "vassault_rhp_readytoattack";
	
	// Negative, we are refueling at this time. Standby.
	level.scr_radio[ "refueling" ] 			= "vassault_rhp_refueling";
	
	// We are rearming at this time. Standby.
	level.scr_radio[ "rearming" ] 			= "vassault_rhp_rearming";
	
	//-------------------------
	// END SEQUENCE
	//-------------------------
	
	// Why'd you do it? Where did you get the bomb?
	level.scr_sound[ "price" ][ "whydyoudoit" ] 	= "vassault_pri_whydyoudoit";
	
	// It wasn't me!!
	level.scr_sound[ "alasad" ][ "wasntme1" ] 		= "vassault_kaa_wasntme1";
	
	// Who then?
	level.scr_sound[ "price" ][ "whothen" ] 		= "vassault_pri_whothen";
	
	// It wasn't me!!
	level.scr_sound[ "alasad" ][ "wasntme2" ] 		= "vassault_kaa_wasntme2";
	
	
	// Who!? Give me a name!
	level.scr_sound[ "price" ][ "givemeaname" ] 	= "vassault_pri_givemeaname";
	
	// A name! I - want - his - name!
	level.scr_sound[ "price" ][ "aname" ] 			= "vassault_pri_aname";
	
	// Sir. It's his cell phone.
	level.scr_sound[ "gaz" ][ "cellphone" ] 		= "vassault_gaz_cellphone";
	
	// Who was that sir?
	level.scr_sound[ "gaz" ][ "whowasthat" ] 		= "vassault_gaz_whowasthat";
	
	// Zakhaev.
	level.scr_sound[ "price" ][ "zakhaev" ] 		= "vassault_pri_zakhaev";
	
	// Imran Zakhaev.
	level.scr_sound[ "price" ][ "imran" ] 			= "vassault_pri_imran";
}
