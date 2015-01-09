#include maps\_anim;
#using_animtree("generic_human");

main()
{
	anims();
	dialogue();
}

anims()
{
	level.scr_anim[ "frnd" ][ "spin" ] 								= %combatwalk_F_spin;

	level.scr_anim[ "drone" ][ "pilot_idle" ][ 0 ]			= %helicopter_pilot1_idle;
	level.scr_anim[ "drone" ][ "pilot_idle" ][ 1 ]			= %helicopter_pilot1_twitch_clickpannel;
	level.scr_anim[ "drone" ][ "pilot_idle" ][ 2 ]			= %helicopter_pilot1_twitch_lookback;
	level.scr_anim[ "drone" ][ "pilot_idle" ][ 3 ]			= %helicopter_pilot1_twitch_lookoutside;

	level.scr_anim[ "drone" ][ "copilot_idle" ][ 0 ]			= %helicopter_pilot2_idle;
	level.scr_anim[ "drone" ][ "copilot_idle" ][ 1 ]			= %helicopter_pilot2_twitch_clickpannel;
	level.scr_anim[ "drone" ][ "copilot_idle" ][ 2 ]			= %helicopter_pilot2_twitch_radio;
	level.scr_anim[ "drone" ][ "copilot_idle" ][ 3 ]			= %helicopter_pilot2_twitch_lookoutside;
	
	/*-----------------------
	TEMP SEAKNIGHT LOADS/UNLOADS
	-------------------------*/	
	level.scr_anim[ "generic" ][ "ch46_load_1" ]					= %ch46_load_1;
	level.scr_anim[ "generic" ][ "ch46_load_2" ]					= %ch46_load_2;		
	level.scr_anim[ "generic" ][ "ch46_load_3" ]					= %ch46_load_3;
	level.scr_anim[ "generic" ][ "ch46_load_4" ]					= %ch46_load_4;	
	
	level.scr_anim[ "generic" ][ "ch46_unload_1" ]					= %ch46_unload_1;
	level.scr_anim[ "generic" ][ "ch46_unload_2" ]					= %ch46_unload_2;		
	level.scr_anim[ "generic" ][ "ch46_unload_3" ]					= %ch46_unload_3;	
	level.scr_anim[ "generic" ][ "ch46_unload_4" ]					= %ch46_unload_4;

	level.scr_anim[ "generic" ][ "ch46_unload_idle" ][0]			= %exposed_crouch_idle_alert_v1;
	//level.scr_anim[ "generic" ][ "ch46_unload_idle" ][0]			= %exposed_crouch_idle_alert_v2;
	//level.scr_anim[ "generic" ][ "ch46_unload_idle" ][0]			= %crouch_exposed_idleB;

	/*-----------------------
	RPG SEQUENCE
	-------------------------*/	
	level.scr_anim[ "frnd" ][ "AT4_fire_start" ]					= %launchfacility_a_at4_fire;
	level.scr_anim[ "frnd" ][ "AT4_fire" ]							= %launchfacility_a_at4_fire;
	level.scr_anim[ "frnd" ][ "AT4_idle" ][0]						= %corner_standr_alert_idle;
	

	/*-----------------------
	RPG SEQUENCE 2
	-------------------------*/	
	level.scr_anim[ "frnd" ][ "RPG_conceal_idle_start" ]			= %RPG_conceal_idle;
	level.scr_anim[ "frnd" ][ "RPG_conceal_idle" ][0]				= %RPG_conceal_idle;
	level.scr_anim[ "frnd" ][ "RPG_conceal_2_standR" ]				= %RPG_conceal_2_standR;
	level.scr_anim[ "frnd" ][ "RPG_stand_idle" ][0]					= %RPG_stand_idle;
	level.scr_anim[ "frnd" ][ "RPG_stand_fire" ]					= %RPG_stand_fire;
	level.scr_anim[ "frnd" ][ "RPG_standR_2_conceal" ]				= %RPG_standR_2_conceal;
	
	level.scr_anim[ "frnd" ][ "AT4_fire_short_start" ]				= %launchfacility_a_at4_short;
	level.scr_anim[ "frnd" ][ "AT4_fire_short" ]					= %launchfacility_a_at4_short;
	level.scr_anim[ "frnd" ][ "AT4_idle_short" ][0]					= %corner_standr_alert_idle;

	
	/*-----------------------
	SEAKNIGHT CREWCHIEF
	-------------------------*/	
	level.scr_anim[ "frnd" ][ "crewchief_idle" ][0]				= %airlift_crewchief_idle;
	level.scr_anim[ "frnd" ][ "crewchief_getin" ][0]			= %airlift_crewchief_getin;
	level.scr_anim[ "frnd" ][ "crewchief_getin_lookback" ][0]	= %airlift_crewchief_getin_lookback;
	level.scr_anim[ "frnd" ][ "crewchief_getin_quick" ][0]		= %airlift_crewchief_getin_quick;
	level.scr_anim[ "frnd" ][ "crewchief_getout" ][0]			= %airlift_crewchief_getout;
	level.scr_anim[ "frnd" ][ "crewchief_gun_idle" ][0]			= %airlift_crewchief_gun_idle;
	level.scr_anim[ "frnd" ][ "crewchief_gun_shoot" ][0]		= %airlift_crewchief_gun_shoot;	
	level.scr_anim[ "frnd" ][ "crewchief_gun_getin" ][0]		= %airlift_crewchief_gun_getin;	
	level.scr_anim[ "frnd" ][ "crewchief_sucked_out" ]			= %airlift_crewchief_sucked_out;
	
	level.scr_anim[ "frnd" ][ "airlift_crewchief_stepout" ]		= %airlift_crewchief_stepout;
	level.scr_anim[ "frnd" ][ "airlift_crewchief_stepout_fire" ] = %airlift_crewchief_stepout_fire;
	level.scr_anim[ "frnd" ][ "airlift_crewchief_stepout_fire_2_idle" ]	= %airlift_crewchief_stepout_fire_2_idle;
	level.scr_anim[ "frnd" ][ "airlift_crewchief_stepout_idle" ][0]	= %airlift_crewchief_stepout_idle;
	

	/*-----------------------
	WOUNDED PILOT
	-------------------------*/	
	level.scr_anim[ "frnd" ][ "wounded_pullout" ]				= %airlift_pilot_getout;
	level.scr_anim[ "frnd" ][ "wounded_cockpit_shoot" ][ 0 ]	= %airlift_pilot_shooting;
	level.scr_anim[ "frnd" ][ "wounded_cockpit_wave_over" ] 	= %airlift_pilot_seeyou;
	level.scr_anim[ "frnd" ][ "wounded_cockpit_idle" ][ 0 ]		= %airlift_pilot_idle;
	level.scr_anim[ "frnd" ][ "wounded_putdown" ]				= %airlift_pilot_putdown;
	
	/*-----------------------
	DEAD PILOT
	-------------------------*/	
	level.scr_anim[ "frnd" ][ "deadpilot_idle" ][ 0 ]			= %airlift_copilot_dead;

}

dialogue()
{
	/*-----------------------
	DIALOGUE
	-------------------------*/	
	//Male Helicopter Pilot
	//In formation. Approaching objective. 30 seconds.
	level.scr_radio[ "airlift_mhp_information" ] = "airlift_mhp_information";

	//HQ Radio Voice
	//All callsigns this is Overlook. We're seeing enemy armor in the palm grove west of the river.
	level.scr_radio[ "airlift_hqr_allcallsigns" ] = "airlift_hqr_allcallsigns";
	
	//Female Helicopter Pilot
	//Outlaw, this is Deadly. We'll take out the big targets, mop up any troublemakers with the Mark 19.
	level.scr_radio[ "airlift_fhp_bigtargets" ] = "airlift_fhp_bigtargets";

	//Male Helicopter Pilot
	//Taking fire.
	level.scr_radio[ "airlift_mhp_takingfire" ] = "airlift_mhp_takingfire";
	
	//Male Helicopter Pilot
	//RPGs on the rooftops.
	level.scr_radio[ "airlift_mhp_rpgrooftops" ] = "airlift_mhp_rpgrooftops";
	
	//Male Helicopter Pilot
	//Hostiles with RPGs.
	level.scr_radio[ "airlift_mhp_hostilesrpgs" ] = "airlift_mhp_hostilesrpgs";
	
	//Male Helicopter Pilot
	//More ground infantry, watch it
	level.scr_radio[ "airlift_mhp_groundinfantry" ] = "airlift_mhp_groundinfantry";
	
	//Male Helicopter Pilot
	//We've got RPG's on the rooftops.
	level.scr_radio[ "airlift_mhp_wevegotrpgs" ] = "airlift_mhp_wevegotrpgs";
	
	//Male Helicopter Pilot
	//Light armor. Take it out, Jackson
	level.scr_radio[ "airlift_mhp_lightarmor" ] = "airlift_mhp_lightarmor";
	
	//Male Helicopter Pilot
	//Anti-air battery, rooftop.
	level.scr_radio[ "airlift_mhp_antiairrooftop" ] = "airlift_mhp_antiairrooftop";
	
//Male Helicopter Pilot
//Anti-air on the ground
level.scr_radio[ "airlift_mhp_antiairground" ] = "airlift_mhp_antiairground";
	
	//Male Helicopter Pilot
	//Command this is Outlaw Two-Five. Infantry is making a run for it. We are clear to land.
	level.scr_radio[ "airlift_mhp_makingarun" ] = "airlift_mhp_makingarun";
	
	//HQ Radio Voice
	//Uh...Roger that. Ok. Bachelor Two-Seven, let's get those Abrams to the front.
	level.scr_radio[ "airlift_hqr_getabramsfront" ] = "airlift_hqr_getabramsfront";

	//Helicopter Crew Chief
	//Down the ramp! Move out! Go! Go! Go!		
	level.scr_sound[ "airlift_hcc_downramp" ] = "airlift_hcc_downramp";

	//HQ Radio Voice
	//Outlaw, this is command, unload half your chalk here and take the rest 2 clicks west. We need you to evac an advance team pinned down in the city.
	level.scr_radio[ "airlift_hqr_2clickswest" ] = "airlift_hqr_2clickswest";
	
	//HQ Radio Voice
	//Roger that command. Outlaw 2-5 is en route
	level.scr_radio[ "airlift_hqr_enroute" ] = "airlift_hqr_enroute";
	
	//Female Helicopter Pilot
	//Outlaw this is Deadly. Returning to base to refit and refuel. You’re on your own for now 2-5.
	level.scr_radio[ "airlift_fhp_refitandrefuel" ] = "airlift_fhp_refitandrefuel";
	
	//HQ Radio Voice
	//Advance team is pinned down in a hot area. They're popping blue smoke to indicate position.
	level.scr_radio[ "airlift_hqr_bluesmoke" ] = "airlift_hqr_bluesmoke";

	//Male Helicopter Pilot
	//Roger we have a visual. Outlaw 2-5 out.
	level.scr_radio[ "airlift_mhp_havevisual" ] = "airlift_mhp_havevisual";
	
//Helicopter Crew Chief
//Move! Move! Heads up! Let's go!
level.scr_sound[ "frnd" ][ "airlift_hcc_letsgo" ] = "airlift_hcc_letsgo";

	//Lt. Vasquez
	//Marines, listen up! One of our forward recon teams has gotten pinned down and needs our help!
	level.scr_radio[ "airlift_vsq_forwardrecon" ] = "airlift_vsq_forwardrecon";

//Lt. Vasquez
//These guys lasered eleven anti-aircraft positions last night for the pre-invasion bombing. If anyone deserves a ticket outta here, it's them!	HR1	
level.scr_radio[ "airlift_vsq_desevresaticket" ] = "airlift_vsq_desevresaticket";

//Lt. Vasquez
//We're gonna land, and then fight our way to their position. Once we've linked up with them, we'll escort them back to the Sea Knight! 	HR1	
level.scr_radio[ "airlift_vsq_escortback" ] = "airlift_vsq_escortback";

	//Lt. Vasquez
	//Watch for friendlies near the colored smoke! Let's get our boys evac'ed and get the hell out of here!	HR1	
	level.scr_radio[ "airlift_vsq_watchcoloredsmoke" ] = "airlift_vsq_watchcoloredsmoke";

	//Lt. Vasquez
	//Watch for friendlies near the green smoke on the second floor! Let's get our boys outta there! Move!	HR1	
	level.scr_radio[ "airlift_vsq_greensmoke" ] = "airlift_vsq_greensmoke";

	//Marine 1
	//Mortar fire! Incoming!
	level.scr_sound[ "frnd" ][ "airlift_gm1_firebalcony" ] = "airlift_gm1_firebalcony";
	
	//Male Helicopter Pilot
	//LZ is too hot. We'll circle back in 3 minutes. 
	level.scr_radio[ "airlift_mhp_lztoohot" ] = "airlift_mhp_lztoohot";

	//Marine 1
	//Hold your fire! Hold your fire! Friendlies up on the second floor! I repeat, we're up on the second floor!	HR1	
	level.scr_radio[ "airlift_gm1_holdyourfire" ] = "airlift_gm1_holdyourfire";

	//Marine 2
	//Put some fire on that balcony!
	level.scr_sound[ "frnd" ][ "airlift_gm2_firebalcony" ] = "airlift_gm2_firebalcony";
	
	//Marine 3
	//Reinforcements! Fastroping to the east!
	level.scr_sound[ "frnd" ][ "airlift_gm3_reinforcements" ] = "airlift_gm3_reinforcements";
	
	//Marine 4
	//So you're our ride out of here?
	level.scr_sound[ "frnd" ][ "airlift_gm4_reinforcements" ] = "airlift_gm4_reinforcements";
	
//Lt. Vasquez
//We're it, Captain. Let's move out before they regroup.
level.scr_radio[ "airlift_vsq_moveout" ] = "airlift_vsq_moveout";

	//Lt. Vasquez
	//We're it, Captain. Let's move out before they regroup.
	level.scr_sound[ "frnd" ][ "airlift_vsq_wereit" ] = "airlift_vsq_wereit";

	//Female Helicopter Pilot
	//Outlaw this is Deadly. Refueled and fully loaded. You guys miss me?
	level.scr_radio[ "airlift_fhp_missme" ] = "airlift_fhp_missme";

	//Marine 3
	//Hell yeah!
	level.scr_sound[ "frnd" ][ "airlift_gm3_hellyeah" ] = "airlift_gm3_hellyeah";
	
	//Lt. Vasquez
	//Move out! Let's go let's go!
	level.scr_sound[ "frnd" ][ "airlift_vsq_letsgo" ] = "airlift_vsq_letsgo";
	
//Lt. Vasquez
//Get to the LZ! Let's move!
level.scr_radio[ "airlift_vsq_gettolz" ] = "airlift_vsq_gettolz";

	//Lt. Vasquez
	//Get to the LZ! Let's move!
	level.scr_radio[ "airlift_vsq_gettolz2" ] = "airlift_vsq_gettolz2";

//Helicopter Crew Chief
//Move it! We've gotta be wheels up in 10 seconds! Move!
level.scr_sound[ "frnd" ][ "airlift_hcc_wheelsup" ] = "airlift_hcc_wheelsup";
	
	//Helicopter Crew Chief
	//Jackson! Get back on the Mark 19!
	level.scr_sound[ "frnd" ][ "airlift_hcc_backonmark19" ] = "airlift_hcc_backonmark19";
	
	//Marine 4
	//Thanks for the lift!
	level.scr_radio[ "airlift_gm4_hellyeah" ] = "airlift_gm4_hellyeah";
	
	//HQ Radio Voice
	//Outlaw, be advised, we have a situation here, over.
	level.scr_radio[ "airlift_hqr_situation" ] = "airlift_hqr_situation";
	
	//Male Helicopter Pilot
	//Go ahead Command, over.
	level.scr_radio[ "airlift_mhp_goahead" ] = "airlift_mhp_goahead";
	
	//HQ Radio Voice
	//Seal Team Six has located a possible nuclear device at Al-Asad's palace to the west. NEST teams are on the way. Until the device is verified safe, all forces are to fall back to the east, over.
	level.scr_radio[ "airlift_hqr_nestteams" ] = "airlift_hqr_nestteams";

	//Seal Team Six has located a possible nuclear device at Al-Asad's palace to the west. NEST teams are on the way. Until the device is verified safe, all forces are to fall back to the east, over.
	level.scr_radio[ "airlift_hqr_nestteams" ] = "airlift_hqr_nestteams";
	
	//Male Helicopter Pilot
	//What's the minimum safe distance over?
	level.scr_radio[ "airlift_mhp_safedistance" ] = "airlift_mhp_safedistance";

	//What's the minimum safe distance over?
	level.scr_radio[ "airlift_mhp_safedistance" ] = "airlift_mhp_safedistance";
	
	//HQ Radio Voice
	//Minimum safe distance is ten miles. Get your asses outta there now! Out!
	level.scr_radio[ "airlift_hqr_outtathere" ] = "airlift_hqr_outtathere";

	//Minimum safe distance is ten miles. Get your asses outta there now! Out!
	level.scr_radio[ "airlift_hqr_outtathere" ] = "airlift_hqr_outtathere";
	
	//Male Helicopter Pilot
	//Deadly this is Outlaw. Al-Asad's got a nuke. We're buggin' out. Lead the way.
	level.scr_radio[ "airlift_mhp_leadtheway" ] = "airlift_mhp_leadtheway";

	//Deadly this is Outlaw. Al-Asad's got a nuke. We're buggin' out. Lead the way.
	level.scr_radio[ "airlift_mhp_leadtheway" ] = "airlift_mhp_leadtheway";
	
	//Female Helicopter Pilot
	//Roger that. Let's get outta (KABOOM helicopter is hit)
	level.scr_radio[ "airlift_fhp_getoutta" ] = "airlift_fhp_getoutta";
	
	//Female Helicopter Pilot
	//We're hit we're hit!! I've lost the tail rotor!
	level.scr_radio[ "airlift_fhp_werehit" ] = "airlift_fhp_werehit";
	
	//Female Helicopter Pilot
	//Mayday mayday, this is Deadly, going in hard!
	level.scr_radio[ "airlift_fhp_mayday" ] = "airlift_fhp_mayday";

	//Female Helicopter Pilot
	//We're going down.
	level.scr_radio[ "airlift_fhp_goingdown" ] = "airlift_fhp_goingdown";

	
//Female Helicopter Pilot
//***Keating hang on - ! (static)
level.scr_radio[ "airlift_fhp_hangon" ] = "airlift_fhp_hangon";

	//Keating hang on - ! (static)
	level.scr_radio[ "airlift_fhp_hangon" ] = "airlift_fhp_hangon";
	
	//Male Helicopter Pilot
	//We have a Cobra down. I repeat, we have a Cobra down.
	level.scr_radio[ "airlift_mhp_cobradown" ] = "airlift_mhp_cobradown";
	
	//Male Helicopter Pilot
	//Deadly this Outlaw Two-Five, do you copy?
	level.scr_radio[ "airlift_mhp_doyoucopy" ] = "airlift_mhp_doyoucopy";
	
	//Male Helicopter Pilot
	//Deadly this Outlaw Two-Five, come in, over!
	level.scr_radio[ "airlift_mhp_comein" ] = "airlift_mhp_comein";

	//Male Helicopter Pilot
	//Command, I have a visual on the crash site. I see small arms fire coming from the cockpit. Request permission to initiate search and rescue.
	level.scr_radio[ "airlift_mhp_smallarmsfire" ] = "airlift_mhp_smallarmsfire";

	//Copy Two-Five, be advised, you will NOT be at a safe distance in the event that nuke goes off. Do you understand?
	level.scr_radio[ "airlift_hqr_notsafe" ] = "airlift_hqr_notsafe";
	
	//Male Helicopter Pilot
	//Roger that. We know what we're getting into.
	level.scr_radio[ "airlift_mhp_weknow" ] = "airlift_mhp_weknow";
	
	//HQ Radio Voice
	//All right Two-Five, it's your call. Retrieve that pilot if you can. Out.
	level.scr_radio[ "airlift_hqr_youcall" ] = "airlift_hqr_youcall";
	
//Male Helicopter Pilot
//Deadly do you copy? What's your status, over?
level.scr_radio[ "airlift_mhp_youstatus" ] = "airlift_mhp_youstatus";
	
//Female Helicopter Pilot
//(cough) I'm here!...(coughing, firing) Keating is KIA!!! Hostiles moving in fast!! (gunfire gunfire) I could sure use some help down here!! (gunfire)
level.scr_radio[ "airlift_fhp_usesomehelp" ] = "airlift_fhp_usesomehelp";

//Male Helicopter Pilot
//Hold on, we're coming to ya.
level.scr_radio[ "airlift_mhp_werecoming" ] = "airlift_mhp_werecoming";
	
	//Be advised Two-Five, hostiles advancing parallel southwest of your position towards the crash site.
	level.scr_radio[ "airlift_hqr_hostilesadvancing" ] = "airlift_hqr_hostilesadvancing";

//Lt. Vasquez
//We got 90 seconds Jackson! Get the pilot! NO ONE gets left behind!	HR1	
level.scr_radio[ "airlift_vsq_90sec" ] = "airlift_vsq_90sec";


	//HQ Radio Voice
	//Outlaw Two-Five, hundreds of enemy troops are bearing down on the crash site! Estimate your position WILL be overrun in 90 seconds!	HQ	
	level.scr_radio[ "airlift_hqr_willbeoverrun" ] = "airlift_hqr_willbeoverrun";

	//Lt. Vasquez
	//We’ve got hostiles converging on the crash site! Move!
	level.scr_radio[ "airlift_vsq_crashsite" ] = "airlift_vsq_crashsite";

	//Lt. Vasquez
	//Jackson! Pull her out of there and get back to the LZ! Do it!
	level.scr_sound[ "frnd" ][ "airlift_vsq_pullherout" ] = "airlift_vsq_pullherout";
	
	//Lt. Vasquez
	//Jackson! We're running out of time! Get her out of there! We'll cover you! Move!
	level.scr_sound[ "frnd" ][ "airlift_vsq_getherout" ] = "airlift_vsq_getherout";

	//Lt. Vasquez
	//Jackson! Get the pilot! Get the pilot! Hurry!!		
	level.scr_sound[ "frnd" ][ "airlift_gm2_getpilot" ] = "airlift_gm2_getpilot";
	
	//Lt. Vasquez
	//Jackson! Get the pilot back outta that helo! Move!!!		
	level.scr_sound[ "frnd" ][ "airlift_gm2_outofhelo" ] = "airlift_gm2_outofhelo";
	
	
	//Lt. Vasquez
	//Sgt. Jackson! Grab the pilot, we'll hold 'em off!!		
	level.scr_sound[ "frnd" ][ "airlift_gm2_holdemoff" ] = "airlift_gm2_holdemoff";
	
	
	//Lt. Vasquez
	//Pull that pilot out of the cockpit while we cover you, Jackson! Move it!		
	level.scr_sound[ "frnd" ][ "airlift_gm2_coveryou" ] = "airlift_gm2_coveryou";

//Lt. Vasquez
//Get that pilot outta there! Move!!!	HR1	
level.scr_radio[ "airlift_vsq_getpilot" ] = "airlift_vsq_getpilot";

//Lt. Vasquez
//Jackson, pull the pilot outta the cockpit! Now!!	HR1	
level.scr_radio[ "airlift_vsq_outtacockpit" ] = "airlift_vsq_outtacockpit";

//Lt. Vasquez
//We're running outta time! Get the pilot back to the Sea Knight! Hurry!	HR1	
level.scr_radio[ "airlift_vsq_backtoseaknight" ] = "airlift_vsq_backtoseaknight";


	//Lt. Vasquez
	//Get to the seaknight! We’ll hold down these corners. Go!
	level.scr_sound[ "frnd" ][ "airlift_vsq_holddown" ] = "airlift_vsq_holddown";
	
//Lt. Vasquez
//*****I'm gonna scuttle the Cobra! Get clear!
level.scr_sound[ "frnd" ][ "airlift_vsq_scuttlecobra" ] = "airlift_vsq_scuttlecobra";
	
	//Lt. Vasquez
	//Go! Go!
	level.scr_radio[ "airlift_vsq_gogo" ] = "airlift_vsq_gogo";
	
	//Male Helicopter Pilot
	//Lt. Vasquez, this is Outlaw Two-Five, now would be a good time to get the hell outta here over.
	level.scr_radio[ "airlift_mhp_goodtime" ] = "airlift_mhp_goodtime";
	
	//Male Helicopter Pilot
	//Lt. Vasquez, this is Outlaw Two-Five, now would be a good time to get the hell outta here over.
	
	//Lt. Vasquez
	//Roger that we're on our way!
	level.scr_radio[ "airlift_vsq_onourway" ] = "airlift_vsq_onourway";

	//HQ Radio Voice
	//Outlaw this is Command. We have a probable nuclear threat in the capital. Proceed to the minimum safe distance until the all clear is given by the NEST team.
	level.scr_radio[ "airlift_hqr_nuclearthreat" ] = "airlift_hqr_nuclearthreat";

	//Male Helicopter Pilot
	//Ladies and gentlemen this is your Captain speaking. We're in for some chop! Hang on! Jake gimme max power.
	level.scr_radio[ "airlift_mhp_inforchop" ] = "airlift_mhp_inforchop";
	
	//Co Pilot
	//Roger that.
	level.scr_radio[ "airlift_cop_rogerthat" ] = "airlift_cop_rogerthat";
	
	//HQ Radio Voice
	//All U.S. forces, be advised, we have a confirmed nuclear threat in the city. NEST teams are on site and attempting to disarm. I repeat, we have a confirmed nu-(BOOM)
	level.scr_radio[ "airlift_hqr_confirmed" ] = "airlift_hqr_confirmed";
	
	//Lt. Vasquez
	//Everyone hang onnnn!!!
	level.scr_radio[ "airlift_vsq_hangon" ] = "airlift_vsq_hangon";


	//Female pilot
	//sounds of pain
	level.scr_sound[ "airlift_fhp_pains" ] = "airlift_fhp_pains";

	player_carry();
	tank_crush_anims();
	seaknight_anims();
	statue_anims();
}

#using_animtree( "player" );
player_carry()
{
	//animations that will be played by the player (actually played by an invisible model the player is linked to)
	//animname will be "player_carry"
	level.scr_anim[ "player_carry" ][ "wounded_pullout" ]				= %airlift_player_getout;
	level.scr_anim[ "player_carry" ][ "wounded_putdown" ]				= %airlift_player_putdown;

	//the animtree to use with the invisible model with animname "player_carry"
	level.scr_animtree[ "player_carry" ] 								= #animtree;	
	//the invisible model with the animname "player_carry" that the anims will be played on
	level.scr_model[ "player_carry" ] 									= "viewhands_player_usmc";
}	

#using_animtree( "vehicles" );
tank_crush_anims()
{
	level.scr_animtree[ "tank_crush" ]			= #animtree;
	level.scr_anim[ "sedan" ][ "tank_crush" ]	= %sedan_tankcrush_side;
	level.scr_anim[ "tank" ][ "tank_crush" ] 	= %tank_tankcrush_side;
	level.scr_sound[ "tank_crush" ]				= "airlift_tank_crush_car";
}

#using_animtree( "vehicles" );
seaknight_anims()
{
	level.scr_anim[ "seaknight" ][ "idle" ][ 0 ] 				= %sniper_escape_ch46_idle;
	level.scr_anim[ "seaknight" ][ "landing" ] 					= %sniper_escape_ch46_land;
	level.scr_anim[ "seaknight" ][ "take_off" ] 				= %sniper_escape_ch46_take_off;
	level.scr_anim[ "seaknight" ][ "rotors" ]					= %sniper_escape_ch46_rotors;
	level.scr_anim[ "seaknight" ][ "turret_settle_anim" ]		= %ch46_turret_idle;
	level.scr_anim[ "seaknight" ][ "turret_fire_anim" ]			= %ch46_turret_fire;
	level.scr_anim[ "seaknight" ][ "doors_open" ]				= %ch46_doors_open;
	
	
	level.scr_animtree[ "seaknight" ] 							= #animtree;
}

#using_animtree( "vehicles" );
seaknight_turret_anim_init()
{
	self useanimtree( #animtree );
	self setanim( %ch46_turret_idle );
	self setanim( %ch46_doors_close );
	
}

#using_animtree( "vehicles" );
seaknight_turret_anim()
{
	self endon ( "death" );
	self endon ( "turret_fire" );
	self useanimtree( #animtree );
	self setanimknobrestart( %ch46_turret_fire, 1, 0, 1 );
}

#using_animtree( "vehicles" );
seaknight_open_doors()
{
	self useanimtree( #animtree );
	self playsound ( "seaknight_door_open" );
	self setanimknobrestart( %ch46_doors_open, 1, 0, 1 );
	//self thread maps\_vehicle_aianim::setanimrestart_once( %ch46_doors_open, false );
}
	
#using_animtree( "vehicles" );
seaknight_close_doors()
{
	self useanimtree( #animtree );
	self playsound ( "seaknight_door_close" );
	self setanimknobrestart( %ch46_doors_close, 1, 0, 1 );
	//self thread maps\_vehicle_aianim::setanimrestart_once( %ch46_doors_close, false );
}

#using_animtree( "animated_props" );
statue_anims()
{
	level.scr_animtree[ "statue" ]			= #animtree;
	level.scr_anim[ "statue" ][ "statue_collapse" ] 	= %me_statue_destroy_base_01;
}