#include maps\_anim;
#using_animtree("generic_human");

main()
{
	anims();
	dialogue();
	player_rappel();
	script_models();
}

anims()
{
	level.scr_anim[ "frnd" ][ "spin" ] 								= %combatwalk_F_spin;
	
	/*-----------------------
	HELI RPG SEQUENCE
	-------------------------*/	
	level.scr_anim[ "frnd" ][ "AT4_fire_start" ]					= %launchfacility_a_at4_fire;
	level.scr_anim[ "frnd" ][ "AT4_fire" ]							= %launchfacility_a_at4_fire;
	level.scr_anim[ "frnd" ][ "AT4_idle" ][0]						= %corner_standr_alert_idle;
	
	level.scr_anim[ "frnd" ][ "RPG_conceal_idle_start" ]			= %RPG_conceal_idle;
	level.scr_anim[ "frnd" ][ "RPG_conceal_idle" ][0]				= %RPG_conceal_idle;
	level.scr_anim[ "frnd" ][ "RPG_conceal_2_standR" ]				= %RPG_conceal_2_standR;
	level.scr_anim[ "frnd" ][ "RPG_stand_idle" ][0]					= %RPG_stand_idle;
	level.scr_anim[ "frnd" ][ "RPG_stand_fire" ]					= %RPG_stand_fire;
	level.scr_anim[ "frnd" ][ "RPG_standR_2_conceal" ]				= %RPG_standR_2_conceal;

	level.scr_anim[ "frnd" ][ "RPG_stand_aim_2" ]					= %RPG_stand_aim_2;
	level.scr_anim[ "frnd" ][ "RPG_stand_aim_4" ]					= %RPG_stand_aim_4;
	level.scr_anim[ "frnd" ][ "RPG_stand_aim_5" ]					= %RPG_stand_aim_5;
	level.scr_anim[ "frnd" ][ "RPG_stand_aim_6" ]					= %RPG_stand_aim_6;
	level.scr_anim[ "frnd" ][ "RPG_stand_aim_8" ]					= %RPG_stand_aim_8;
	
	/*-----------------------
	GATE EXPLOSION
	-------------------------*/		
	
	level.scr_anim[ "frnd" ][ "C4_gate_plant_start" ]				= %launchfacility_a_c4_plant;
	level.scr_anim[ "frnd" ][ "C4_gate_plant" ]						= %launchfacility_a_c4_plant;	
	level.scr_anim[ "frnd" ][ "C4_plant_start" ]					= %explosive_plant_knee;
	level.scr_anim[ "frnd" ][ "C4_plant" ]							= %explosive_plant_knee;

	/*-----------------------
	SAW SEQUENCE
	-------------------------*/		
	level.scr_anim[ "frnd" ]["saw_1_start"]							= %launchfacility_a_saw_1;
	level.scr_anim[ "frnd" ]["saw_2_start"]							= %launchfacility_a_saw_2;
	
	level.scr_anim[ "frnd" ]["saw_1"]								= %launchfacility_a_saw_1;
	level.scr_anim[ "frnd" ]["saw_2"]								= %launchfacility_a_saw_2;
	addNotetrack_customFunction( "frnd", "start", maps\launchfacility_a::saw_notify_start, "saw_1" );
	addNotetrack_customFunction( "frnd", "stop", maps\launchfacility_a::saw_notify_stop, "saw_1" );
	addNotetrack_customFunction( "frnd", "switch", maps\launchfacility_a::saw_notify_switch, "saw_1" );
	addNotetrack_customFunction( "frnd", "start", maps\launchfacility_a::saw_notify_start, "saw_2" );
	addNotetrack_customFunction( "frnd", "stop", maps\launchfacility_a::saw_notify_stop, "saw_2" );
	addNotetrack_customFunction( "frnd", "switch", maps\launchfacility_a::saw_notify_switch, "saw_2" );
		
	/*-----------------------
	AIR VENT 
	-------------------------*/		
	level.scr_anim[ "frnd" ]["rappel_setup_start"]					= %launchfacility_a_setup_idle_1;
	level.scr_anim[ "frnd" ]["rappel_setup_to_stand_1"]				= %launchfacility_a_setup_2_rappel_1;
	level.scr_anim[ "frnd" ]["rappel_setup_to_stand_2"]				= %launchfacility_a_setup_2_rappel_2;
	level.scr_anim[ "frnd" ]["rappel_stand_idle_1"][0]				= %launchfacility_a_rappel_idle_1;
	level.scr_anim[ "frnd" ]["rappel_stand_idle_2"][0]				= %launchfacility_a_rappel_idle_2;
	level.scr_anim[ "frnd" ]["rappel_stand_idle_3"][0]				= %launchfacility_a_rappel_idle_3;
	level.scr_anim[ "frnd" ]["rappel_drop"]							= %launchfacility_a_rappel_1;

}

dialogue()
{
	//Facility perimeter has been compromised. All units proceed to defensive positions. Unknown enemy force moving in from the South or West. Facility is now on high alert.
	level.scr_sound["launchfacility_a_rul_highalert"] = "launchfacility_a_rul_highalert";
	
	//Russian Loudspeaker
	//We are under attack! Lock down all points of entry immediately. 	megaphone/loudspeaker									
	level.scr_sound["launchfacility_a_rul_underattack"] = "launchfacility_a_rul_underattack";
	
	//Russian Loudspeaker
	//Enemy units confirmed to be American special forces. Exercise extreme caution. Red Spetznaz units are en route to intercept.	megaphone/loudspeaker									
	level.scr_sound["launchfacility_a_rul_redspentznaz"] = "launchfacility_a_rul_redspentznaz";
	
	//Russian Loudspeaker
	//Preparing launch tubes 2 through 6 for firing. Standby. 	megaphone/loudspeaker									
	level.scr_sound["launchfacility_a_rul_preptubes"] = "launchfacility_a_rul_preptubes";
	
	//Russian Loudspeaker
	//Fight for the glory of the Motherland! Fight the corruption of our once great nation!	loudspeaker									
	level.scr_sound["launchfacility_a_rul_motherland"] = "launchfacility_a_rul_motherland";
	
	//Russian Loudspeaker
	//Comrades! Remember the fallen and avenge them! Let us ensure that their sacrifices were not made in vain!	loudspeaker									
	level.scr_sound["launchfacility_a_rul_avengefallen"] = "launchfacility_a_rul_avengefallen";
	
	//Russian Loudspeaker	
	//We shall restore the honor of the days when this nation was feared by all others! We will not be stopped! We will not be turned aside so easily!	loudspeaker									
	level.scr_sound["launchfacility_a_rul_restorehonor"] = "launchfacility_a_rul_restorehonor";

	//HQ Radio Voice
	//Uh, Bravo Six, we're still working with the Russians to get the launch codes. We should have them shortly. Keep moving. Out.								
	level.scr_radio["launchfacility_a_hqr_stillworking"] = "launchfacility_a_hqr_stillworking";

	//HQ Radio
	//"Bravo Six, we're picking up heavy activity inside the facility. Enemy air is running search patterns. What's your status over?"
	level.scr_radio["launchfacility_a_hqradio_activity"] = "launchfacility_a_hqr_heavyactivity";
	//radio_dialogue("launchfacility_a_hqradio_activity");
	
	//Price
	//"Status is TARFU and we're workin' on it, out!"
	level.scr_sound["frnd"]["launchfacility_a_price_tarfu"] = "launchfacility_a_us_lead_statustarfu";
	//level.price dialogue_execute("launchfacility_a_price_tarfu");
	
	//Price
	//"All right our cover’s blown! Grenier! Prep the AT4!"
	level.scr_sound["frnd"]["launchfacility_a_price_at4_prep"] = "launchfacility_a_us_lead_coversblown";
	//level.price dialogue_execute("launchfacility_a_price_at4_prep");
	
	//Marine 01
	//"Roger that. Last round sir."
	level.scr_radio["launchfacility_a_marine_01_at4_prep"] = "launchfacility_a_gm2_lastround";
	//radio_dialogue("launchfacility_a_marine_01_at4_prep");
	
	//HQ Radio
	//"Uh, Bravo Six, we're still working with the Russians to get those codes. We should have them shortly. Keep moving. Out."
	level.scr_radio["launchfacility_a_cmd_highalert"] = "launchfacility_a_hqr_stillworking";
	//radio_dialogue("launchfacility_a_cmd_highalert");
	
//Marine 01
//*****"Hind!!! 12 o'clock high!!!"
level.scr_sound["frnd"]["launchfacility_a_marine1_chopper"] = "launchfacility_a_gm1_hind12oclock";
//guy dialogue_execute("launchfacility_a_marine1_chopper");
	
//Marine 02
//****"I got him…"
level.scr_radio["launchfacility_a_marine2_killchopper"] = "launchfacility_a_gm2_igothim";
//radio_dialogue("launchfacility_a_marine2_killchopper");
	
	//Price
	//"Go go go!!!"
	level.scr_sound["frnd"]["launchfacility_a_price_gogogo1"] = "launchfacility_a_us_lead_gogogo";
	//level.price dialogue_execute("launchfacility_a_price_gogogo1");
	
	//Grigsby
	//"We're gonna need some more ground support sir!!!!"
	level.scr_sound["frnd"]["launchfacility_a_griggs_moreground"] = "launchfacility_a_grg_groundsupport";
	//level.grigsby dialogue_execute("launchfacility_a_griggs_moreground");
	
	//Price
	//"Already got it covered Griggs!!!"
	level.scr_sound["frnd"]["launchfacility_a_price_alreadygot"] = "launchfacility_a_us_lead_alreadygot";
	//level.price dialogue_execute("launchfacility_a_price_alreadygot");
	
	//Sniper team
	//"Bravo Six, Sniper Team Two is now in position.  We'll give ya sniper cover and recon from where we are, over."
	level.scr_radio["launchfacility_a_recon_sniperteamtwo"] = "launchfacility_a_gm4_team2inposition";
	//radio_dialogue("launchfacility_a_recon_sniperteamtwo");
	
	//Price
	//"Copy!!! Keep us posted!!! Out!!!!"
	level.scr_sound["frnd"]["launchfacility_a_price_keepposted"] = "launchfacility_a_us_lead_keepposted";
	//level.price dialogue_execute("launchfacility_a_price_keepposted");
	
	//Sniper team
	//"This is Sniper Team Two. You've got hostiles and light armor coming to you from the north. Suggest you get some C4 out there or find some heavy weapons, over."
	level.scr_radio["launchfacility_a_recon_enemiestonorth"] = "launchfacility_a_gm4_hostileslightarmor";
	//radio_dialogue("launchfacility_a_recon_enemiestonorth");
	
	//Price
	//"Throw some smoooke!!!!"
	level.scr_sound["frnd"]["launchfacility_a_price_smoke_nag_01"] = "launchfacility_a_us_lead_throwsmoke";
	//level.price dialogue_execute("launchfacility_a_price_smoke_nag_01");
	
	//Grigsby
	//"We gotta cover our advaaaance! Everyone pop smooooke!"
	level.scr_sound["frnd"]["launchfacility_a_grigsby_smoke_nag_01"] = "launchfacility_a_grg_popsmoke";
	//level.grigsby dialogue_execute("launchfacility_a_grigsby_smoke_nag_01");
	
	//Marine 01
	//"Poppin' smooke!!!"
	level.scr_sound["frnd"]["launchfacility_a_marine_01_throwing_smoke"] = "launchfacility_a_gm2_poppinsmoke";
	//guy dialogue_execute("launchfacility_a_marine_01_throwing_smoke");
	
	//Marine 01
	//"Charges placed! We’re blowing the BMP! Take cover! Move Move!!!"
	level.scr_radio["launchfacility_a_marine_01_blowing_bmp"] = "launchfacility_a_gm1_chargesplaced";
	//radio_dialogue("launchfacility_a_marine_01_blowing_bmp");

//Sniper team
//****"This is Sniper Team Two. At least a full platoon moving in from the tarmac up ahead. We'll try to thin 'em out before they reach your position, out."
level.scr_radio["launchfacility_a_recon_enemies_coming"] = "launchfacility_a_gm4_fullplatoon";
//radio_dialogue("launchfacility_a_recon_enemies_coming");

	//HQ radio
	//"Bravo Six, this is command, gimme a sit-rep over."
	level.scr_radio["launchfacility_a_cmd_sitrep"] = "launchfacility_a_hqr_sitrep";
	//radio_dialogue("launchfacility_a_cmd_sitrep");
	
	//Price
	//"We're inside the perimeter, approaching the gates to the silos!!! Out!!!"
	level.scr_sound["frnd"]["launchfacility_a_price_were_inside"] = "launchfacility_a_us_lead_wereinside";
	//level.price dialogue_execute("launchfacility_a_price_were_inside");

	//Captain Price
	//We've got to breach the gate to the tarmac! Keep pushing forward!										
	level.scr_sound["frnd"]["launchfacility_a_pri_breachgate"] = "launchfacility_a_pri_breachgate";

	//Marine 01
	//"Cover me! I'm gonna blow the gate!"
	level.scr_sound["frnd"]["launchfacility_a_marine1_gate_blow"] = "launchfacility_a_gm1_coverme";
	//guy dialogue_execute("launchfacility_a_marine1_gate_blow");
	
	//Marine 02
	//"Charges set!!!!! Get back get back!!!"
	level.scr_sound["frnd"]["launchfacility_a_marine2_gate_getback"] = "launchfacility_a_gm1_getback";
	//guy dialogue_execute("launchfacility_a_marine2_gate_getback");
	
	//Marine 02
	//"Fire in the hole!!!"
	level.scr_sound["frnd"]["launchfacility_a_marine2_fireinhole"] = "launchfacility_a_gm1_fireinthehole";
	//guy dialogue_execute("launchfacility_a_marine2_fireinhole");
	
	//Price
	//"Through the gate! Let's go!!!"
	level.scr_sound["frnd"]["launchfacility_a_price_tothetarmac"] = "launchfacility_a_us_lead_throughthegate";
	//level.price dialogue_execute("launchfacility_a_price_tothetarmac");
	
	//Grigsby
	//"Shit we got more BMPs!!!  Take cover!!!!"
	level.scr_sound["frnd"]["launchfacility_a_griggs_morebmps"] = "launchfacility_a_grg_morebmps";
	//level.grigsby dialogue_execute("launchfacility_a_griggs_morebmps");
	
	//Price
	//"Jackson!!! Griggs!!! Knock 'em out, GO!!!!"
	level.scr_sound["frnd"]["launchfacility_a_price_knockemout"] = "launchfacility_a_us_lead_knockemout";
	//level.price dialogue_execute("launchfacility_a_price_knockemout");
	
	//Grigsby
	//"Yo Jackson!! Keep your eyes open for RPGs!! We can use 'em to take out the armor from long range!!!"
	level.scr_sound["frnd"]["launchfacility_a_griggs_userpghint"] = "launchfacility_a_grg_eyesopen";
	//level.grigsby dialogue_execute("launchfacility_a_griggs_userpghint");
	
	//Grigsby
	//"We need to take out the BMPs! "
	level.scr_sound["frnd"]["launchfacility_a_griggs_vehicles_hint_01"] = "launchfacility_a_grg_takeoutbmps";
	//level.grigsby dialogue_execute("launchfacility_a_griggs_vehicles_hint_01");
	
	//HQ radio
	//"Bravo Six, this is Strike Team Three inserting from the east. Repeat, we're movin' in from the east. Check your targets and confirm, over."
	level.scr_radio["launchfacility_a_friendlies_east"] = "launchfacility_a_gm3_checktargets";
	//radio_dialogue("launchfacility_a_friendlies_east");
	
	//Price
	//"Copy Team Three! We'll meet you at the north end of the tarmac, out!!"
	level.scr_sound["frnd"]["launchfacility_a_price_copyteamthree"] = "launchfacility_a_us_lead_northtarmac";
	//level.price dialogue_execute("launchfacility_a_price_copyteamthree");

	//Marine 3
	//Team, give us few seconds to cut through the vents.
	level.scr_radio["launchfacility_a_gm3_cutvents"] = "launchfacility_a_gm3_cutvents";
	
	//****Marine 01
	//Cutting. Standby.
	level.scr_radio["launchfacility_a_gm1_cutting"] = "launchfacility_a_gm1_cutting";

	//	Marine 1 	INCOMING!!!!										
	level.scr_sound["frnd"]["launchfacility_a_gm1_incoming"] = "launchfacility_a_gm1_incoming";

	//Sniper team
	//"Bravo Six, Two Hinds closing fast on your position. You gotta get outta sight, now!"
	level.scr_radio["launchfacility_a_recon_two_helis"] = "launchfacility_a_gm4_getouttasight";
	//radio_dialogue("launchfacility_a_recon_two_helis");
	
	//Price
	//"Squad, hook up! "
	level.scr_sound["frnd"]["launchfacility_a_price_ropesout_01"] = "launchfacility_a_us_lead_hookup";
	//level.price dialogue_execute("launchfacility_a_price_ropesout_01");

	
	//Marine 02
	//"Team Two rappelling now."
	level.scr_radio["launchfacility_a_marine2_rappelling"] = "launchfacility_a_gm2_rappellingnow";
	//radio_dialogue("launchfacility_a_marine2_rappelling");
	
	//Marine 03
	//"Team Three is inside."
	level.scr_radio["launchfacility_a_marine3_teamin"] = "launchfacility_a_gm3_teaminside";
	//radio_dialogue("launchfacility_a_marine3_teamin");

	//Team Three rapelling now.								
	level.scr_radio["launchfacility_a_gm3_rapellingnow"] = "launchfacility_a_gm3_rapellingnow";

	
	
	
	/*-----------------------
	RANDOMIZED BMP NAGS
	-------------------------*/
	level.launchfacility_a_price_bmp_nag_MAX = 8;
	level.launchfacility_a_price_bmp_nag_number = randomintrange(1, level.launchfacility_a_price_bmp_nag_MAX + 1);
	
	
	//Price
	//"Jackson! Get a C4 charge on that BMP!!!"
	level.scr_sound["frnd"]["launchfacility_a_price_bmp_nag_01"] = "launchfacility_a_us_lead_c4chargebmp";
	//level.price dialogue_execute("launchfacility_a_price_bmp_nag_01");

	//Price
	//"We gotta take out that BMP! Use your C4!"
	level.scr_sound["frnd"]["launchfacility_a_price_bmp_nag_02"] = "launchfacility_a_us_lead_takeoutbmp";
	//level.price dialogue_execute("launchfacility_a_price_bmp_nag_02");

	//Captain Price	launchfacility_a	We’re pinned down until we take out that armor! Use your C4!										
	level.scr_sound["frnd"]["launchfacility_a_price_bmp_nag_03"] = "launchfacility_a_pri_pinneddown";
	
	//SAS 1	launchfacility_a	That armor is killing us! Use your C4!				
	level.scr_sound["frnd"]["launchfacility_a_price_bmp_nag_04"] = "launchfacility_a_sas1_killingus";
							
	//Captain Price	launchfacility_a	Plant some C4 on that armor!				
	level.scr_sound["frnd"]["launchfacility_a_price_bmp_nag_05"] = "launchfacility_a_pri_c4onarmor";
														
	//Captain Price	launchfacility_a	Find an enemy RPG or plant some C4!!!		
	level.scr_sound["frnd"]["launchfacility_a_price_bmp_nag_06"] = "launchfacility_a_pri_findrpg";		
	
	
	//ONLY 07 and 08 are GRIGGS
	level.scr_sound["frnd"]["launchfacility_a_price_bmp_nag_07"] = "launchfacility_a_grg_bulletsgrenades";	
	
	level.scr_sound["frnd"]["launchfacility_a_price_bmp_nag_08"] = "launchfacility_a_grg_getclose";	
	

	/*-----------------------
	RANDOMIZED HOOK UP NAGS
	-------------------------*/
	level.launchfacility_a_price_ropenag_MAX = 6;
	level.launchfacility_a_price_ropenag_number = randomintrange(1, level.launchfacility_a_price_ropenag_MAX + 1);
		
	//Price
	//"Jackson! Hook up! Let's go!"
	level.scr_sound["frnd"]["launchfacility_a_price_ropenag_01"] = "launchfacility_a_us_lead_hookupgo";

	//Captain Price		
	//Jackson! Hook up on the middle vent!				
	level.scr_sound["frnd"]["launchfacility_a_price_ropenag_02"] = "launchfacility_a_pri_hookupmidvent";
							
	//Captain Price		
	//Let’s move! Middle vent! Hook up!			
	level.scr_sound["frnd"]["launchfacility_a_price_ropenag_03"] = "launchfacility_a_pri_letsmovemidvent";
								
	//Captain Price		
	//Over here Jackson! We’re rappelling down the middle vent!										
	level.scr_sound["frnd"]["launchfacility_a_price_ropenag_04"] = "launchfacility_a_pri_overhere";
	
	//Captain Price		
	//Hook up on the second vent! Let’s go!										
	level.scr_sound["frnd"]["launchfacility_a_price_ropenag_05"] = "launchfacility_a_pri_hookupsecvent";

	//Gaz
	//Get down the vents! Move!!!!								
	level.scr_sound["frnd"]["launchfacility_a_price_ropenag_06"] = "launch_a_gaz_downvents";


	
	

	//launchfacility_a_grg_getdownvents


//*****Bloody hell, that was close.	radio	launchfacility_a_sas2_bloodyhell								
level.scr_radio["launchfacility_a_sas2_bloodyhell"] = "launchfacility_a_sas2_bloodyhell";
	
	//Price
	//"Ok, we're in."
	level.scr_radio["launchfacility_a_price_inside_facility"] = "launchfacility_a_us_lead_okwerein";
	//radio_dialogue("launchfacility_a_price_inside_facility");

	/*-----------------------
	RANDOMIZED SNIPER CONFIRM DIALOGUE
	-------------------------*/
	level.dialogueSniperConfirm_MAX = 6;
	level.dialogueSniperConfirm_number = randomintrange(1, level.dialogueSniperConfirm_MAX + 1);
	
	//Sniper Team Two
	//That got him. Headshot.	
	level.scr_radio["launchfacility_a_sniper_confirm_01"] = "launchfacility_a_sn1_gothim";
	
	//Sniper Team Two
	//Sniper Team Two, we’ve got your back.	
	level.scr_radio["launchfacility_a_sniper_confirm_02"] = "launchfacility_a_sn1_gotyourback";
	
	//Sniper Team Two
	//That’s a kill.	
	level.scr_radio["launchfacility_a_sniper_confirm_03"] = "launchfacility_a_sn1_thatsakill";
	
	//Sniper Team Two
	//This is sniper team two…target down.	
	level.scr_radio["launchfacility_a_sniper_confirm_04"] = "launchfacility_a_sn2_targetdown";
	
	//Sniper Team Two
	//Got him. We’ll try to keep you covered from out here Bravo Six.	
	level.scr_radio["launchfacility_a_sniper_confirm_05"] = "launchfacility_a_sn2_keepyoucovered";
	
	//Sniper Team Two
	//He’s down. Confirmed headshot.	
	level.scr_radio["launchfacility_a_sniper_confirm_06"] = "launchfacility_a_sn2_confirmed";

	/*-----------------------
	RANDOMIZED GO RIGHT DIALOGUE
	-------------------------*/
	level.dialogueGateHint_MAX = 9;
	level.dialogueGateHint_number = randomintrange(1, level.dialogueGateHint_MAX + 1);

	//Marine 01
	//"The northeast gate is blocked! We gotta cut to the right!
	level.scr_radio["launchfacility_a_gate_hint_01"] = "launchfacility_a_gm1_gateblocked";	

	//Marine 01
	//"The northeast gate is blocked! We gotta cut to the right!
	level.scr_radio["launchfacility_a_gate_hint_02"] = "launchfacility_a_gm1_gateblocked";	

	//Marine 1	We can’t go this way, we gotta head right!										
	level.scr_radio["launchfacility_a_gate_hint_03"] = "launchfacility_a_gm1_headright";	
	
	//SAS 1		We can’t go this way, we gotta head right!										
	level.scr_radio["launchfacility_a_gate_hint_04"] = "launchfacility_a_sas1_headright";	
	
	//Captain Price		We’re pushing up the right side!								
	level.scr_radio["launchfacility_a_gate_hint_05"] = "launchfacility_a_pri_uprightside";	
	
	//Marine 1		This way is blocked! Go right! Head over to the right side! Move!										
	level.scr_radio["launchfacility_a_gate_hint_06"] = "launchfacility_a_gm1_wayisblocked";	
	
	//SAS 1		The left gate is blocked! Go right! Head over to the right side! Move!										
	level.scr_radio["launchfacility_a_gate_hint_07"] = "launchfacility_a_sas1_leftblocked";	
	
	//Captain Price		Team one, we’re headed up through the gate on the right side!								
	level.scr_radio["launchfacility_a_gate_hint_08"] = "launchfacility_a_pri_throughgate";	
	
	//Captain Price		Everyone advance up the right side! The left gate is blocked I repeat, the left gate is blocked!				
	level.scr_radio["launchfacility_a_gate_hint_09"] = "launchfacility_a_pri_leftgateblocked";	
		
	/*-----------------------
	RANDOMIZED RPG HIT DIALOGUE
	-------------------------*/
	level.dialogueRpgHit_MAX = 2;
	level.dialogueRpgHit_number = randomintrange(1, level.dialogueRpgHit_MAX + 1);
	
	//marine 2
	//That's a hit! One more oughta do it!
	level.scr_radio["launchfacility_a_rpg_hit_01"] = "launchfacility_a_gm2_thatsahit";
	
	//marine 03
	//It's still operational! Hit it again! 
	level.scr_radio["launchfacility_a_rpg_hit_02"] = "launchfacility_a_gm3_hitagain";

	/*-----------------------
	RANDOMIZED RPG KILL DIALOGUE
	-------------------------*/
	level.dialogueRpgGoodShot_MAX = 4;
	level.dialogueRpgGoodShot_number = randomintrange(1, level.dialogueRpgHit_MAX + 1);
	
	//Marine 01
	//Nice work Jackson, good shot.
	level.scr_radio["launchfacility_a_rpg_kill_01"] = "launchfacility_a_gm1_nicework";
	
	//Marine 02
	//That BMP's history. Nice shot.
	level.scr_radio["launchfacility_a_rpg_kill_02"] = "launchfacility_a_gm2_bmpshistory";

	//GAZ
	//Good shot!
	level.scr_radio["launchfacility_a_rpg_kill_03"] = "launch_a_gaz_goodshot";

	//GAZ
	//Niice one mate.
	level.scr_radio["launchfacility_a_rpg_kill_04"] = "launch_a_gaz_niceone";	
	

	/*-----------------------
	RANDOMIZED JAVELIN KILL DIALOGUE
	-------------------------*/
	level.dialogueJavelinGoodShot_MAX = 2;
	level.dialogueJavelinGoodShot_number = randomintrange(1, level.dialogueJavelinGoodShot_MAX + 1);
	
	//Marine 01
	//Hell yeah!
	level.scr_radio["launchfacility_a_javelin_kill_01"] = "launchfacility_a_gm3_hellyeah";
	
	//Marine 02
	//Fuckin nice shot, Jackson!
	level.scr_radio["launchfacility_a_javelin_kill_02"] = "launchfacility_a_gm3_fniceshot";
}

#using_animtree( "player" );
player_rappel()
{
	level.scr_anim[ "player_rappel" ][ "rappel" ]						= %launchfacility_a_player_rappel;
	level.scr_animtree[ "player_rappel" ] 								= #animtree;	
	level.scr_model[ "player_rappel" ] 									= "viewmodel_base_fastrope_character";
}

#using_animtree( "script_model" );
script_models()
{
	precacheModel( "rappelrope110_le" );
	level.scr_anim[ "player_rope" ][ "rappel_for_player_start" ]		= %launchfacility_a_player_rappel_100ft_rope;
	level.scr_anim[ "player_rope" ][ "rappel_idle_for_player" ][0]		= %launchfacility_a_player_rappel_idle_100ft_rope;
	level.scr_anim[ "player_rope" ][ "rappel_for_player" ]				= %launchfacility_a_player_rappel_100ft_rope;
	level.scr_animtree[ "player_rope" ] 						= #animtree;
	level.scr_model[ "player_rope" ] 							= "rappelrope110_le";

	precacheModel( "rappelrope100_ri" );
	level.scr_animtree[ "rope" ] 								= #animtree;
	level.scr_model[ "rope" ] 									= "rappelrope100_ri";
	level.scr_anim[ "rope" ][ "rappel_setup_start" ]			= %launchfacility_a_setup_2_rappel_1_100ft_rope;
	level.scr_anim[ "rope" ]["rappel_setup_to_stand_1"]			= %launchfacility_a_setup_2_rappel_1_100ft_rope;
	level.scr_anim[ "rope" ]["rappel_setup_to_stand_2"]			= %launchfacility_a_setup_2_rappel_2_100ft_rope;
	level.scr_anim[ "rope" ]["rappel_stand_idle_1"][0]			= %launchfacility_a_rappel_idle_1_100ft_rope;
	level.scr_anim[ "rope" ]["rappel_stand_idle_2"][0]			= %launchfacility_a_rappel_idle_2_100ft_rope;
	level.scr_anim[ "rope" ]["rappel_stand_idle_3"][0]			= %launchfacility_a_rappel_idle_3_100ft_rope;
	level.scr_anim[ "rope" ]["rappel_drop"]						= %launchfacility_a_rappel_1_100ft_rope;

}

        
        
        