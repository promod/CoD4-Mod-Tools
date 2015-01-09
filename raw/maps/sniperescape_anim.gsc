#include maps\_anim;
#include maps\_utility;
#include maps\_props;
#include maps\sniperescape_code;
#include maps\sniperescape_exchange;
#include maps\sniperescape_wounding;
#using_animtree( "generic_human" );

main()
{
	if ( !level.sniperescape_fastload )	
	{
		add_smoking_notetracks( "generic" );
		add_cellphone_notetracks( "generic" );
	}
	
	level.scr_model[ "stone_block_1" ] = "me_stone_block01";
	level.scr_model[ "stone_block_2" ] = "me_stone_block02";
	level.scr_model[ "stone_block_3" ] = "me_stone_block03";

	level.scr_anim[ "price" ][ "rappel_end" ]					= %sniper_escape_rappel_finish;
	level.scr_anim[ "price" ][ "rappel_start" ]					= %sniper_escape_rappel_start;
	level.scr_anim[ "price" ][ "rappel_idle" ][ 0 ]				= %sniper_escape_rappel_idle;

	level.scr_anim[ "dead_guy" ][ "pool_death" ]					= %exposed_death_nerve;
	level.scr_animtree[ "dead_guy" ] 							= #animtree;	
	
	// We値l have to take the short cut! Follow my lead!	
	level.scr_sound[ "price" ][ "rappel_start" ] = "sniperescape_mcm_shortcut";

	level.scr_anim[ "generic" ][ "pilot_idle_ff" ]				= %helicopter_pilot1_idle;
	
	level.scr_anim[ "price" ][ "smooth_door_open" ]			= %hunted_open_barndoor_flathand;
	

	level.scr_anim[ "price" ][ "crash_pickup" ]					= %sniper_escape_crash_pickup_macmillan;
	
	level.scr_anim[ "price" ][ "precrash_idle" ][ 0 ]			= %sniper_escape_crash_macmillan_aim;
	level.scr_anim[ "price" ][ "fire_idle" ][ 0 ]				= %sniper_escape_crash_macmillan_fire;
	level.scr_anim[ "price" ][ "fire_idle" ][ 1 ]				= %sniper_escape_crash_macmillan_aim;
	level.scr_anim[ "price" ][ "crash" ]						= %sniper_escape_crash_macmillan_runaway;
	level.scr_anim[ "price" ][ "crash_idle" ][ 0 ]				= %sniper_escape_crash_macmillan_wounded_idle;

	level.scr_anim[ "generic" ][ "pilot_idle" ][ 0 ]			= %helicopter_pilot1_idle;
	level.scr_anim[ "generic" ][ "pilot_idle" ][ 1 ]			= %helicopter_pilot1_twitch_clickpannel;
	level.scr_anim[ "generic" ][ "pilot_idle" ][ 2 ]			= %helicopter_pilot1_twitch_lookback;
	level.scr_anim[ "generic" ][ "pilot_idle" ][ 3 ]			= %helicopter_pilot1_twitch_lookoutside;

	level.scr_anim[ "generic" ][ "gunner_idle" ][ 0 ]			= %helicopter_pilot2_idle;
	level.scr_anim[ "generic" ][ "gunner_idle" ][ 1 ]			= %helicopter_pilot2_twitch_clickpannel;
	level.scr_anim[ "generic" ][ "gunner_idle" ][ 2 ]			= %helicopter_pilot2_twitch_radio;
	level.scr_anim[ "generic" ][ "gunner_idle" ][ 3 ]			= %helicopter_pilot2_twitch_lookoutside;
	

//	level.scr_anim[ "zakhaev" ][ "zak_pain" ]					= %exposed_death_twist; //exposed_pain_2_crouch;
	level.scr_anim[ "zakhaev" ][ "zak_pain" ]					= %sniper_escape_meeting_zakhaev_hit_front; //exposed_pain_2_crouch;
	level.scr_anim[ "zakhaev" ][ "zak_pain_back" ]				= %sniper_escape_meeting_zakhaev_hit_back; //exposed_pain_2_crouch;
	
	level.scr_anim[ "zakhaev" ][ "run" ]						= %unarmed_run_russian;
	level.scr_anim[ "zakhaev" ][ "exchange" ]					= %sniper_escape_meeting_zakhaev;
	level.scr_anim[ "guard" ][ "exchange" ]						= %sniper_escape_meeting_guard;
	level.scr_anim[ "dealer" ][ "exchange" ]					= %sniper_escape_meeting_dealer;

	level.scr_anim[ "guard" ][ "exchange_idle" ][ 0 ]			= %sniper_escape_meeting_guard_idle;
	level.scr_anim[ "dealer" ][ "exchange_idle" ][ 0 ]			= %sniper_escape_meeting_dealer_idle;
	

	level.scr_anim[ "price" ][ "spin" ]							= %combatwalk_f_spin;
	level.scr_anim[ "price" ][ "halt" ]							= %stand_exposed_wave_halt_v2;
	
	level.scr_anim[ "price" ][ "wounded_turn_left" ] 			= %sniper_escape_price_turn_L;
	level.scr_anim[ "price" ][ "wounded_turn_right" ] 			= %sniper_escape_price_turn_R;

	level.scr_anim[ "price" ][ "spotter_exit" ] 				= %sniper_escape_spotter_exit;
	level.scr_anim[ "price" ][ "spotter_idle" ][ 0 ]			= %sniper_escape_spotter_idle;
	level.scr_anim[ "price" ][ "spotter_wave" ] 				= %sniper_escape_spotter_wave;

	// Chopper!!! Get back! I'll cover you!	sniperescape_mcm_choppergetback
	addNotetrack_dialogue( "price", "dialog", "wounded_begins", "sniperescape_mcm_choppergetback" );

	level.scr_anim[ "price" ][ "wounded_begins" ]				= %sniper_escape_price_hit;
	level.scr_anim[ "price" ][ "wounded_idle_reach" ]			= %sniper_escape_price_hit_idle;
	level.scr_anim[ "price" ][ "wounded_idle" ][ 0 ]			= %sniper_escape_price_hit_idle;
	level.scr_anim[ "price" ][ "wounded_idle" + "weight" ][ 0 ]	= 100;
	level.scr_anim[ "price" ][ "wounded_idle" ][ 1 ]			= %sniper_escape_price_hit_idle;
	level.scr_anim[ "price" ][ "wounded_idle" + "weight" ][ 1 ]	= 35;
	level.scr_anim[ "price" ][ "wounded_fire" ]					= %sniper_escape_price_hit_fire;

	level.scr_anim[ "price" ][ "wounded_crawl_start" ]			= %sniper_escape_price_crawl_start;
	level.scr_anim[ "price" ][ "wounded_crawl_end" ]			= %sniper_escape_price_crawl_end;
	level.scr_anim[ "price" ][ "wounded_crawl" ]				= %sniper_escape_price_crawl;
	

	level.scr_anim[ "generic" ][ "stealth_jog" ]	= %patrol_jog;
	level.scr_anim[ "generic" ][ "stealth_walk" ]	= %patrol_bored_patrolwalk;
	level.scr_anim[ "generic" ][ "combat_jog" ]		= %combat_jog;
	

	level.scr_anim[ "price" ][ "wounded_death" ]				= %sniper_escape_price_killed;

	level.scr_anim[ "price" ][ "wounded_base" ]					= %wounded_aim;
	level.scr_anim[ "price" ][ "wounded_aim_left" ]				= %sniper_escape_price_aim_L;
	level.scr_anim[ "price" ][ "wounded_aim_right" ]			= %sniper_escape_price_aim_R;

	level.scr_anim[ "price" ][ "wounded_carry" ][ 0 ]			= %sniper_escape_price_walk;
	level.scr_anim[ "player" ][ "wounded_carry" ][ 0 ]			= %sniper_escape_playerview_walk;

	level.scr_anim[ "price" ][ "wounded_pickup" ]				= %sniper_escape_price_getup;
	level.scr_anim[ "price" ][ "wounded_putdown" ]				= %sniper_escape_price_putdown;
	level.scr_anim[ "price" ][ "wounded_seaknight_putdown" ]	= %airlift_pilot_putdown;

	level.scr_anim[ "price" ][ "pickup_idle" ][ 0 ]				= %sniper_escape_price_wounded_idle;

	level.scr_anim[ "price" ][ "pickup_idle" ][ 0 ]				= %sniper_escape_price_wounded_idle;


	level.scr_anim[ "generic" ][ "patrol_look_up" ]					= %patrol_jog_look_up;
	level.scr_anim[ "generic" ][ "patrol_360" ] 					= %patrol_jog_360;
	level.scr_anim[ "generic" ][ "patrol_jog" ] 					= %patrol_jog;
	level.scr_anim[ "generic" ][ "patrol_orders" ] 					= %patrol_jog_orders;

	level.scr_anim[ "generic" ][ "patrol_look_up_once" ]			= %patrol_jog_look_up_once;
	level.scr_anim[ "generic" ][ "patrol_360_once" ] 				= %patrol_jog_360_once;
	level.scr_anim[ "generic" ][ "patrol_jog_once" ] 				= %patrol_jog_once;
	level.scr_anim[ "generic" ][ "patrol_orders_once" ]				= %patrol_jog_orders_once;

	
	level.scr_anim[ "generic" ][ "exchange_surprise_zakhaev" ]		= %unarmed_cowerstand_react;


	level.scr_anim[ "generic" ][ "exchange_surprise_0" ]			= %exposed_idle_reactA;
	level.scr_anim[ "generic" ][ "exchange_surprise_1" ]			= %exposed_idle_reactB;
	level.scr_anim[ "generic" ][ "exchange_surprise_2" ]			= %exposed_idle_twitch;
	level.scr_anim[ "generic" ][ "exchange_surprise_3" ]			= %exposed_idle_twitch_v4;
	addNotetrack_customFunction( "generic", "ready_to_run", ::exchange_ready_to_run );

	/*
	level.scr_anim[ "generic" ][ "exchange_surprise_0" ]			= %patrol_bored_react_look_v1;
	level.scr_anim[ "generic" ][ "exchange_surprise_1" ]			= %patrol_bored_react_look_v2;
	level.scr_anim[ "generic" ][ "exchange_surprise_3" ]			= %patrol_bored_react_walkstop;
	level.scr_anim[ "generic" ][ "exchange_surprise_4" ]			= %patrol_bored_react_walkstop_short;
	level.scr_anim[ "generic" ][ "exchange_surprise_5" ]			= %patrol_bored_react_look_advance;
	level.scr_anim[ "generic" ][ "exchange_surprise_6" ]			= %patrol_bored_react_look_retreat;
	*/
 	level.surprise_anims = 4;

	level.scr_anim[ "generic" ][ "_stealth_behavior_whizby_0" ]			= %exposed_idle_reactA;
	level.scr_anim[ "generic" ][ "_stealth_behavior_whizby_1" ]			= %exposed_idle_reactB;
	level.scr_anim[ "generic" ][ "_stealth_behavior_whizby_2" ]			= %exposed_idle_twitch;
	level.scr_anim[ "generic" ][ "_stealth_behavior_whizby_3" ]			= %exposed_idle_twitch_v4;
	level.scr_anim[ "generic" ][ "_stealth_behavior_whizby_4" ]			= %run_pain_stumble;
	
	level.scr_anim[ "generic" ][ "_stealth_behavior_spotted_short" ]		= %exposed_idle_twitch_v4;//patrol_bored_2_combat_alarm_short;
	level.scr_anim[ "generic" ][ "_stealth_behavior_spotted_long" ]			= %exposed_idle_twitch_v4;
	
	
	level.scr_anim[ "generic" ][ "sprint" ] = %sprint1_loop;
	level.scr_anim[ "generic" ][ "prone_dive" ] = %hunted_dive_2_pronehide_v1;
	level.scr_anim[ "generic" ][ "prone_idle" ][ 0 ] = %hunted_pronehide_idle_relative;


	level.scr_anim[ "generic" ][ "bored_cell_loop" ][ 0 ]		= %patrol_bored_idle_cellphone;
	level.scr_anim[ "generic" ][ "smoking" ][ 0 ]				= %parabolic_leaning_guy_smoking_idle;
	level.scr_anim[ "generic" ][ "smoking" ][ 1 ]				= %parabolic_leaning_guy_smoking_twitch;
	level.scr_anim[ "generic" ][ "bored_idle" ][ 0 ]			= %patrol_bored_idle;
	level.scr_anim[ "generic" ][ "bored_idle" ][ 1 ]			= %patrol_bored_twitch_bug;
	level.scr_anim[ "generic" ][ "bored_idle" ][ 2 ]			= %patrol_bored_twitch_stretch;
	level.scr_anim[ "generic" ][ "smoke_idle" ][ 0 ]			= %patrol_bored_idle_smoke;


	level.scr_anim[ "guy1" ][ "load" ] = %ch46_load_1;
	level.scr_anim[ "guy1" ][ "unload" ] = %ch46_unload_1;
	level.scr_anim[ "guy2" ][ "load" ] = %ch46_load_2;
	level.scr_anim[ "guy2" ][ "unload" ] = %ch46_unload_2;
	level.scr_anim[ "guy3" ][ "load" ] = %ch46_load_3;
	level.scr_anim[ "guy3" ][ "unload" ] = %ch46_unload_3;
	level.scr_anim[ "guy4" ][ "load" ] = %ch46_load_4;
	level.scr_anim[ "guy4" ][ "unload" ] = %ch46_unload_4;
/*	
 			hunted_pronehide_2_stand_v1
 			hunted_dive_2_pronehide_v2
 			hunted_pronehide_idle_v2
 			hunted_pronehide_2_stand_v2
 			hunted_dive_2_pronehide_v3
 			hunted_pronehide_idle_v3
 			hunted_pronehide_2_stand_v3
*/

	level.scr_anim[ "price" ][ "crouch" ] = %exposed_stand_2_crouch;

	// Incoming helicopter! Snipe the bastard!		
	level.scr_radio[ "incoming_helicopter" ] = "sniperescape_mcm_incomingheli";

	// Take out that helicopter! Hit the rotor!		
	level.scr_radio[ "hit_the_rotor" ] = "sniperescape_mcm_hittherotor";

	// Price, shoot the helicopter! We'll take it down together!		
	level.scr_radio[ "shoot_the_helicopter" ] = "sniperescape_mcm_downtogether";

	// Fire! Fire!		
	level.scr_radio[ "fire_fire" ] = "sniperescape_mcm_firefire";

	// Gooodnight ya bastard...		
	level.scr_radio[ "goodnight_ya_bastard" ] = "sniperescape_mcm_goodnight";

	// Aw shite - RUUN!		
	level.scr_radio[ "aw_shite" ] = "sniperescape_mcm_run";

	// Ahhh...CRAP! - RUUN!		
	level.scr_radio[ "ahh_crap" ] = "sniperescape_mcm_run";

	// (coughing) Crap, I can't move! (coughing)		
	level.scr_radio[ "cant_move_1" ] = "sniperescape_mcm_cantmove";

	// (coughing) Bloody hell, I can't move! (coughing)		
	level.scr_radio[ "cant_move_2" ] = "sniperescape_mcm_cantmove";

	// (coughing) Damn! My leg's all messed up, I can't move! (coughing)		
	level.scr_radio[ "cant_move_3" ] = "sniperescape_mcm_cantmove";



	addNotetrack_customFunction( "price", "fire", maps\sniperescape_code::price_fires, "wounded_fire" );

	//*	Leftenant Price, the meeting is underway. Enemy transport sighted entering the target area.
	level.scr_radio[ "transport_sighted" ] = "sniperescape_mcm_enemysighted";

	//* Now get on the Barrett rifle and wait for my signal. Do not engage until I give the word.
	// the wind's gettin a big choppy, you can compensate for it or wait it out but he might leave, it's your call
	level.scr_radio[ "get_on_barrett" ] = "sniperescape_mcm_getonbarrett";

	//* Remember what I've taught you. Keep in mind variable humidity and wind speed along the bullet's flight path. At this distance you値l also have to take the Coriolis effect into account.
	level.scr_radio[ "remember_my_teaching" ] = "sniperescape_mcm_corioliseffect";

	//* Prepare for ranging. Standby.
	level.scr_radio[ "prepare_for_ranging" ] = "sniperescape_mcm_prepranging";

	//* White truck on the left, range, 1203.5 meters.
	level.scr_radio[ "white_truck" ] = "sniperescape_mcm_whitetruck";

	//* Range to BMP, 1207 meters.
	level.scr_radio[ "range_to_bmp" ] = "sniperescape_mcm_bmprange";

	//* The table with the briefcase, range, 1206 meters.
	level.scr_radio[ "table_with_case" ] = "sniperescape_mcm_table";

	//* Ok... I think I see him. Wait for my mark.
	level.scr_radio[ "i_see_him" ] = "sniperescape_mcm_mymark";

	//* Target...acquired. I have a positive I.D. on Imran Zakhaev.
	level.scr_radio[ "target_acquired" ] = "sniperescape_mcm_positiveid";


 
//sniperescape_mcm_abouttobegin
 
//sniperescape_mcm_eyeonflag
 


	//* Ach, where did he come from? Patience laddie... Wait for a clear shot�.
	level.scr_radio[ "where_did_he_come_from" ] = "sniperescape_mcm_clearshot";

	// steady, keep an eye on that flag
	//* Wait - the wind's picked up. Let it die down before you take the shot. Don稚 rush it.
	level.scr_radio[ "wind_picked_up" ] = "sniperescape_mcm_eyeonflag";

	//* Ok take the shot.
	level.scr_radio[ "take_the_shot" ] = "sniperescape_mcm_taketheshot";

	//* Damn, my line of sight was blocked. Did you take him out? I thought I saw his arm fly off! Can you see him?
	level.scr_radio[ "did_you_take_him_out" ] = "sniperescape_mcm_armflyoff";

	//* Shit... they池e on to us! Take out that helicopter, it値l buy us some time!
	level.scr_radio[ "take_out_that_heli" ] = "sniperescape_mcm_buysometime";

	//* Great shot Leftenant! Now let's go! They'll be searching for us!
	level.scr_radio[ "great_shot_now_go" ] = "sniperescape_mcm_greatshot";
	
	//* Delta Two Four, this is Alpha Six! We have been compromised, I repeat we have been compromised, now heading to Extraction Point four!	
	level.scr_radio[ "compromised" ] = "sniperescape_mcm_comrpomised";
	
	//* Alpha Six, Seaknight Five-Niner is en route, E.T.A. - 20 minutes. Don't be late. We're stretchin' our fuel as it is. Out.	
	level.scr_radio[ "eta_20_min" ] = "sniperescape_hqr_stretchingourfuel";
	
	//* Leftenant Price, follow me!	
	level.scr_sound[ "price" ][ "follow_me" ] = "sniperescape_mcm_followme";

	//* We've got to head for the extraction point! Move!	
	level.scr_radio[ "head_for_extract" ] = "sniperescape_mcm_headforpoint";
	
	// More behind us!	
	level.scr_sound[ "price" ][ "more_behind" ] = "sniperescape_mcm_morebehind";
	
	// In the bushes, behind us to the north.	
	level.scr_sound[ "price" ][ "bushes_north" ] = "sniperescape_mcm_bushesnorth";
	
	// More enemies behind us, in the bushes to the northwest.	
	level.scr_sound[ "price" ][ "bushes_northwest" ] = "sniperescape_mcm_bushesNW";

	// In the woods!	
	level.scr_sound[ "price" ][ "woods_north" ] = "sniperescape_mcm_inthewoods";
	
	// Behind us! Movement in the woods to the northeast.	
	level.scr_sound[ "price" ][ "woods_northeast" ] = "sniperescape_mcm_woodsNE";
	
	// More in the woods behind us to the east.	
	level.scr_sound[ "price" ][ "woods_east" ] = "sniperescape_mcm_woodseast";
	
	// In the woods!	
	level.scr_sound[ "price" ][ "woods_southeast" ] = "sniperescape_mcm_inthewoods";
	
	// Enemies behind us in the woods to the south.	
	level.scr_sound[ "price" ][ "woods_south" ] = "sniperescape_mcm_woodssouth";
	
	// Behind us! In the woods to the southwest.	
	level.scr_sound[ "price" ][ "woods_southwest" ] = "sniperescape_mcm_woodsSW";
	
	// In the woods!	
	level.scr_sound[ "price" ][ "woods_west" ] = "sniperescape_mcm_inthewoods";
	
	// In the woods!	
	level.scr_sound[ "price" ][ "woods_northwest" ] = "sniperescape_mcm_inthewoods";
	
	// Movement behind us. Coming through the bushes to the west.	
	level.scr_sound[ "price" ][ "bushes_west" ] = "sniperescape_mcm_busheswest";
	
	// More coming from the north.	
	level.scr_sound[ "price" ][ "enemies_north" ] = "sniperescape_mcm_comingnorth";
	
	// Movement. Northeast.	
	level.scr_sound[ "price" ][ "enemies_northeast" ] = "sniperescape_mcm_movementNE";
	
	// Tangos moving to the east.	
	level.scr_sound[ "price" ][ "enemies_east" ] = "sniperescape_mcm_tangoseast";
	
	// Targets southeast.	
	level.scr_sound[ "price" ][ "enemies_southeast" ] = "sniperescape_mcm_targetsSE";
	
	// More of them moving in from the south.	
	level.scr_sound[ "price" ][ "enemies_south" ] = "sniperescape_mcm_morefromsouth";
	
	// Contact southwest.	
	level.scr_sound[ "price" ][ "enemies_southwest" ] = "sniperescape_mcm_contactSW";
	
	// Hostiles closing from the west.	
	level.scr_sound[ "price" ][ "enemies_west" ] = "sniperescape_mcm_hostileswest";
	
	// More tangos to the northwest.	
	level.scr_sound[ "price" ][ "enemies_northwest" ] = "sniperescape_mcm_tangosNW";
	
	//* We'll lose 'em in that apartment! Come on!	
	level.scr_sound[ "price" ][ "lose_them_in_apartment" ] = "sniperescape_mcm_apartmentcomeon";
	
	// Quickly - plant a claymore in case they come this way!	
	level.scr_sound[ "price" ][ "place_claymore" ] = "sniperescape_mcm_plantclaymore";
	
	//* Standby�!	
	level.scr_sound[ "price" ][ "standby" ] = "sniperescape_mcm_standby";
	
	//* Now!	
	level.scr_sound[ "price" ][ "now" ] = "sniperescape_mcm_now";
	
	//* Bloody 'ell I知 hit, I can't move!!!!	
	level.scr_sound[ "price" ][ "im_hit" ] = "sniperescape_mcm_imhit";
	
	//* Sorry mate, you're gonna have to carry me!	
	level.scr_sound[ "price" ][ "carry_me" ] = "sniperescape_mcm_sorrymate";
	
	//* Price! Put me down where I can cover you!	
	level.scr_radio[ "put_me_down_1" ] = "sniperescape_mcm_coveryou";
	
	//* Oi! Sit me down where I can cover your back!	
	level.scr_radio[ "put_me_down_2" ] = "sniperescape_mcm_oisit";
	
	//* You'd better put me down quick so I can fight back�	
	level.scr_radio[ "put_me_down_quick" ] = "sniperescape_mcm_fightback";
	
	//* Leftenant Price! Don't get too far ahead.	
	level.scr_sound[ "price" ][ "dont_go_far" ] = "sniperescape_mcm_toofarahead";
	
	// plays after you pick him up so its on the "radio" ie in your head
	// The extraction point is to the southwest. We can still make it if we hurry.	
	level.scr_radio[ "extraction_is_southwest" ] = "sniperescape_mcm_makeithurry";
	
	//* Got one.	
	level.scr_sound[ "price" ][ "got_one" ] = "sniperescape_mcm_gotone";
	
	//* Tango down.	
	level.scr_sound[ "price" ][ "tango_down" ] = "sniperescape_mcm_tangodown";
	
	//* He's down.	
	level.scr_sound[ "price" ][ "he_is_down" ] = "sniperescape_mcm_hesdown";
	
	//* Got another.	
	level.scr_sound[ "price" ][ "got_another" ] = "sniperescape_mcm_gotanother";
	
	//*  Got him.	
	level.scr_sound[ "price" ][ "got_him" ] = "sniperescape_mcm_gothim";
	
	//* Target neutralized.	
	level.scr_sound[ "price" ][ "target_neutralized" ] = "sniperescape_mcm_targetneutralized";
	
	//* Head for that apartment, we'll try to lose 'em in there..	
	level.scr_sound[ "price" ][ "head_for_apartment" ] = "sniperescape_mcm_headforapartment";
	
	// We're almost there. The extraction point is on the other side of that building.	
	level.scr_radio[ "almost_there" ] = "sniperescape_mcm_otherside";

	// Leftenant Price, the meeting is underway. Enemy transport sighted entering the target area.	
	level.scr_sound[ "price" ][ "transport_inbound" ] = "sniperescape_mcm_enemysighted";
	

	// Enemy contact up ahead. Let's cut through the woods.	
	level.scr_sound[ "price" ][ "cut_through_woods" ] = "sniperescape_mcm_cutthruwoods";
	
	// The extraction point is to the southwest. We can still make it if we hurry.	
	level.scr_sound[ "price" ][ "extract_southwest" ] = "sniperescape_mcm_makeithurry";
	
	// Head for that apartment, we'll try to lose 'em in there..	
	level.scr_radio[ "head_for_apartment" ] = "sniperescape_mcm_headforapartment";
	
	// Alright, go!	
	level.scr_sound[ "price" ][ "alright_go" ] = "sniperescape_mcm_alrightgo";
	
	// Get ready�	
	level.scr_sound[ "price" ][ "get_ready" ] = "sniperescape_mcm_getready";
	
	// Go!	
	level.scr_sound[ "price" ][ "go!" ] = "sniperescape_mcm_go";
	
	// Come on let's go!	
	level.scr_sound[ "price" ][ "come_on_lets_go" ] = "sniperescape_mcm_comeon";
	
	// It's time to move.	
	level.scr_sound[ "price" ][ "time_to_move" ] = "sniperescape_mcm_timetomove";

	// It's time to move.	
	level.scr_sound[ "price" ][ "spotter_exit" ] = "sniperescape_mcm_timetomove";
	
	
	// You'd better put me down and sweep the rooms, I'll cover the entrance.	
	level.scr_radio[ "sweep_the_rooms" ] = "sniperescape_mcm_putmedown";
	
	// Easy does it�	
	level.scr_sound[ "price" ][ "put_down_1" ] = "sniperescape_mcm_easydoesit";
	
	// Easy now�	
	level.scr_sound[ "price" ][ "put_down_2" ] = "sniperescape_mcm_easynow";
	
	// Careful�	
	level.scr_sound[ "price" ][ "put_down_3" ] = "sniperescape_mcm_careful";
	
	// It's time to move, give me a lift.	
	level.scr_sound[ "price" ][ "lets_get_moving_1" ] = "sniperescape_mcm_givemealift";
	
	// Looks like we're in the clear, we should get moving.	
	level.scr_sound[ "price" ][ "lets_get_moving_2" ] = "sniperescape_mcm_intheclear";
	
	// Leftenant, put me down in a good sniping position.	
	level.scr_sound[ "price" ][ "good_sniping_position" ] = "sniperescape_mcm_snipingposition";

	
// Great shot Leftenant! Now let's go! They'll be searching for us!	
//sniperescape_mcm_greatshot


	

	//* Enemy troops approaching. Find a spot where I can cover you and put me down.
	level.scr_radio[ "new_put_me_down_1" ] = "sniperescape_mcm_enemytroops";
	
	//* Enemies closing in. Put me in a good spot where I can cover you.
	level.scr_radio[ "new_put_me_down_2" ] = "sniperescape_mcm_closingin";
	
	//* Tangos closing fast! Put me in a good spot to cover you!
	level.scr_radio[ "new_put_me_down_3" ] = "sniperescape_mcm_tangosfast";
	
	//* Tangos moving in! Find a spot where I can cover you and put me down!
	level.scr_radio[ "new_put_me_down_4" ] = "sniperescape_mcm_movingin";
	
	//* If we run into trouble, you値l have to find a good spot to put me down so I can cover you.
	level.scr_radio[ "find_good_spot" ] = "sniperescape_mcm_findgoodspot";
	
	//* Alpha Six, this is Big Bird. Standing by for your signal, over.
	level.scr_radio[ "waiting_for_signal" ] = "sniperescape_hp1_yoursignal";
	
	
	//* Good. Our helicopter is standing by at a safe distance. The enemy will try to overrun our LZ once they pick him up on radar, so find a good sniping spot and go prone. Once you're in position, I'll call in the helicopter. Go.
	level.scr_radio[ "find_sniping_spot" ] = "sniperescape_mcm_overrunlz";
	
	
	//* And if you have any claymores left, now is the time to use them.
	level.scr_radio[ "use_claymores" ] = "sniperescape_mcm_claymores";
	
	
	//* Find a good spot to snipe from and go prone.
	level.scr_radio[ "find_spot_go_prone" ] = "sniperescape_mcm_goprone";
	
	//* Alright lad, I've activated the beacon. Good luck.
	level.scr_radio[ "activated_beacon" ] = "sniperescape_mcm_beacon";
	
	
	//* Alpha Six, we have a fix on your position. Hang tight. Big Bird out.
	level.scr_radio[ "have_a_fix" ] = "sniperescape_hp1_hangtight";
	
	
	//* Tangos in sight. Let them get closer.
	level.scr_radio[ "let_them_get_closer" ] = "sniperescape_mcm_getcloser";
	
	
	//* Standby to engage�
	level.scr_radio[ "standby_to_engage" ] = "sniperescape_mcm_standbyengage";
	
	
	//* Open fire.
	level.scr_radio[ "open_fire" ] = "sniperescape_mcm_openfire";
	
	
	//* WHERE'S MACMILLAAAN?!!!
	level.scr_radio[ "where_is_he" ] = "sniperescape_sas2_wheresmac";
	
	
	
	//* Alpha Team, we're at the LZ. Standing by.
	level.scr_radio[ "heli_at_the_lz" ] = "sniperescape_hp1_atthelz";
	
	
	//* Alpha Team, we're at bingo fuel! You got thirty seconds!
	level.scr_radio[ "heli_got_thirty_seconds" ] = "sniperescape_hp1_bingofuel";
	
	
	//* Alpha Team, we are too low on fuel. We're outta here.
	level.scr_radio[ "heli_goodbye" ] = "sniperescape_hp1_toolow";
	
	
	
	// Forget these guys, we're going to get left behind! Let's get to the extraction point!
	level.scr_sound[ "price" ][ "gotta_go_1" ] = "sniperescape_mcm_leftbehind";
	
	
	// We've got to reach the extraction point before we run out of time! Keep moving!
	level.scr_sound[ "price" ][ "gotta_go_2" ] = "sniperescape_mcm_outoftime";
	
	// We're going to get trapped if we stay here! Head for the extraction point! 
	level.scr_sound[ "price" ][ "gotta_go_3" ] = "sniperescape_mcm_gettrapped";
	
	// We've got to get to the LZ before time runs out! I'll watch your back! Go!
	level.scr_sound[ "price" ][ "gotta_go_4" ] = "sniperescape_mcm_gettolz";
	
	
	// Keep moving towards the extraction point! Go go go!
	level.scr_sound[ "price" ][ "gotta_go_5" ] = "sniperescape_mcm_keepmoving";
	
	
	// Price! We're wasting time here! We've got to head for the extraction point, now!
	level.scr_sound[ "price" ][ "gotta_go_6" ] = "sniperescape_mcm_wastingtime";
	
	// We're running out of time! We've got to go!! We've got to go!!!!
	level.scr_sound[ "price" ][ "gotta_go_7" ] = "sniperescape_mcm_gottogo";
	
	// Time's running out! Head for the LZ! I'll cover the rear!
	level.scr_sound[ "price" ][ "gotta_go_8" ] = "sniperescape_mcm_coverrear";
	
	// Price! I'll cover your back! Head for the extraction point!!
	level.scr_sound[ "price" ][ "gotta_go_9" ] = "sniperescape_mcm_coverback";
	
	// Price, forget it! We've got to move! We're running out of time!!!
	level.scr_sound[ "price" ][ "gotta_go_10" ] = "sniperescape_mcm_forgetit";
	
	// We have fifteen minutes left to get to the extraction point.
	level.scr_sound[ "price" ][ "fifteen_minutes" ] = "sniperescape_mcm_15mins";
	
	// We've got ten minutes left.
	level.scr_sound[ "price" ][ "ten_minuets" ] = "sniperescape_mcm_10mins";
	
	// Eight minutes.
	level.scr_sound[ "price" ][ "eight_minutes" ] = "sniperescape_mcm_8mins";
	
	// Six minutes left, let's keep moving.
	level.scr_sound[ "price" ][ "six_minutes" ] = "sniperescape_mcm_6mins";
	
	// Five minutes.
	level.scr_sound[ "price" ][ "five_minutes" ] = "sniperescape_mcm_5mins";


	//*	Wait. Make sure these rooms are clear first.
	level.scr_sound[ "price" ][ "wait_make_sure" ] = "sniperescape_mcm_makesureclear";

	//* I will signal our transport in thirty seconds.	
	level.scr_sound[ "price" ][ "signal_transport" ] = "sniperescape_mcm_signaltransport";

	//* Put me down behind the Ferris wheel, where I can provide sniper support.
	level.scr_sound[ "price" ][ "put_down_behind_wheel" ] = "sniperescape_mcm_snipersupport";

	//* This'll be fine.
	level.scr_sound[ "price" ][ "this_is_fine" ] = "sniperescape_mcm_thisllbefine";

	//* A bit farther to the north, so I can get a clear shot.
	level.scr_sound[ "price" ][ "a_bit_farther_north" ] = "sniperescape_mcm_getaclearshot";

	//* Get me over to that hill so I have a clear field of view.
	level.scr_sound[ "price" ][ "over_to_that_hill" ] = "sniperescape_mcm_clearview";
	
	//* The enemy is bound to enter this area, so find a good sniping position.
	level.scr_sound[ "price" ][ "find_a_good_snipe" ] = "sniperescape_mcm_enterthisarea";
	
	//* I will signal the helicopter in thirty seconds.
	level.scr_sound[ "price" ][ "i_will_signal_in_30" ] = "sniperescape_mcm_thirtysec";
	
	// Prep the killzone by planting the rest of your claymores. Move.
	level.scr_sound[ "price" ][ "prep_the_killzone" ] = "sniperescape_mcm_prepkillzone";
	
	//* Our helicopter is standing by at a safe distance.
	level.scr_sound[ "price" ][ "helicopter_is_standing_by" ] = "sniperescape_mcm_safedistance";
	
	// Price, move me to a better position.
	level.scr_sound[ "price" ][ "move_me" ] = "sniperescape_mcm_betterposition";

	//* Check your compass for the best location.	
	level.scr_sound[ "price" ][ "check_your_compass" ] = "sniperescape_mcm_checkcompass";

	//* Pick me up and move me a bit farther to the north.
	level.scr_sound[ "price" ][ "pick_me_up_and_move_me" ] = "sniperescape_mcm_pickupnorth";

	//* A bit farther to the north�	
	level.scr_sound[ "price" ][ "a_bit_farther_north_2" ] = "sniperescape_mcm_farthernorth";

	//* Over there. Put me down on the rise behind the Ferris wheel.
	level.scr_sound[ "price" ][ "over_there_behind_ferris_wheel" ] = "sniperescape_mcm_behindferris";

	level.heli_flag[ "cant_pick_up_price" ] = "near_pool";
	// The fugitives are near the swimming pool complex! Send Groups A and B to cut them off now!	
	level.scr_sound[ "heli" ][ "near_pool" ] 			= "sniperescape_rul_nearpool";

	level.heli_flag[ "player_abandon_protection" ] = "amusement_park";
	// They are heading towards the amusement park! We need reinforcements in sector three!	
	level.scr_sound[ "heli" ][ "amusement_park" ] 			= "sniperescape_rul_amusementpk";

	level.heli_flag[ "start_heat_spawners" ] = "hotel_police";
	// Enemy sighted near the Hotel Polissia! I repeat, enemy soldiers are moving from the Hotel Polissia!	
	level.scr_sound[ "heli" ][ "hotel_police" ] 			= "sniperescape_rul_hotelpolissa";

	level.heli_flag[ "stop_east_spawners" ] = "cut_exits";
	// They've moved into Apartment Block D, we can't follow them in there. Cut off all the exits and stop them at the park.	
	level.scr_sound[ "heli" ][ "cut_exits" ] 			= "sniperescape_rul_cutoffexits";

	level.heli_flag[ "enter_burnt" ] = "snipers_in_area";
	// Enemy snipers are in the area! They are hiding in the apartment blocks! Find them!	
	level.scr_sound[ "heli" ][ "snipers_in_area" ] 			= "sniperescape_rul_snipersinarea";

	level.heli_flag[ "to_the_pool" ] = "south_of_city";
	// Team five, search the swimming pool area! Team six, search the buildings to the south of the city!	
	level.scr_sound[ "heli" ][ "south_of_city" ] 			= "sniperescape_rul_southofcity";

	level.heli_flag[ "player_leaves_price_wounding" ] = "cover_woods";
	// They may be moving towards the northern end of the city! Send two more teams to cover the woods to the north!	
	level.scr_sound[ "heli" ][ "cover_woods" ] 			= "sniperescape_rul_coverwoods";

	level.heli_flag[ "plant_claymore" ] = "move_move";
	// The enemy snipers have been spotted moving through the courtyards between the apartment buildings! Move! Move!	
	level.scr_sound[ "heli" ][ "move_move" ] 			= "sniperescape_rul_movemove";
	 	

	//* Quick, plant a claymore by the door up ahead!		
	level.scr_radio[ "plant_claymore_by_door" ] 	= "sniperescape_mcm_bydoor";
 
	// Enemy moving on your left flank!		
	level.scr_radio[ "enemy_left_flank" ] 			= "snescape_mcm_movinglt";

	// Enemy moving on your right flank!		
	level.scr_radio[ "enemy_right_flank" ] 			= "snescape_mcm_movingrt";

	// Enemy flanking on your left!		
	level.scr_radio[ "enemy_left_flank_2" ] 		= "snescape_mcm_ltflank";

	// Enemy flanking on your right!		
	level.scr_radio[ "enemy_right_flank_2" ] 		= "snescape_mcm_rtflank";
 
	//* Damn, it went wide! Probably should've waited for the wind to die down.		
	level.scr_radio[ "went_wide" ]		 			= "snescape_mcm_wentwide";

	//* The target's still standing! Keep firing!		
	level.scr_radio[ "target_still_standing" ] 		= "snescape_mcm_stillstand";

	//* Target down. I think I saw his arm fly off. Nice work Leftenant. We got him.		
	level.scr_radio[ "target_down_1" ] 				= "snescape_mcm_wegothim";

	//* Target down. I think you blew off his arm. Shock and blood loss'll take care of the rest.		
	level.scr_radio[ "target_down_2" ] 				= "snescape_mcm_shock";

	//* Target is down! Nice shot Leftenant. 		
	level.scr_radio[ "target_down_3" ] 				= "snescape_mcm_niceshotlt";

	//* It's now or never, take the shot!		
	level.scr_radio[ "now_or_never" ] 				= "snescape_mcm_nownever";

	//* (labored breathing reactions)		
	level.scr_radio[ "pickup_breathing" ] 			= "sniperescape_mcm_breathing";

	//* Take the rest of my claymores, now is the time to use them.		
	level.scr_radio[ "take_my_claymores" ] 			= "snescape_mcm_takemy";

	//* Enemy choppers inbound! 		
	level.scr_radio[ "enemy_choppers" ] 			= "snescape_mcm_enemychop";

	//* Watch out!		
	level.scr_radio[ "watch_out_1" ] 				= "snescape_mcm_watchout";

	//* Pay attention!		
	level.scr_radio[ "watch_out_2" ] 				= "snescape_mcm_payattention";
 
	//* Big Bird we are heavily out numbered, where are you?		
	level.scr_radio[ "where_are_you" ] 				= "sniperescape_mcm_bigbird";

	//* Copy that Alpha, we'll be there ASAP. Hold tight.		
	level.scr_radio[ "be_there_asap" ] 				= "sniperescape_hp1_holdtight";

	//* Are you insane?		
	level.scr_radio[ "are_you_insane" ] 			= "scoutsniper_mcm_youinsane";

	level.scr_radio[ "scoutsniper_mcm_youdaft" ]	= "scoutsniper_mcm_youdaft";
	
 
	

	/*
	level.scr_anim[ "axis" ][ "patrolwalk_1" ] 					= %huntedrun_2;
	level.scr_anim[ "axis" ][ "patrolwalk_2" ] 					= %huntedrun_2;
	level.scr_anim[ "axis" ][ "patrolwalk_3" ] 					= %huntedrun_2;
	level.scr_anim[ "axis" ][ "patrolwalk_4" ] 					= %huntedrun_2;
	level.scr_anim[ "axis" ][ "patrolwalk_5" ] 					= %huntedrun_2;
	*/
	
	player_rappel();
	dog_anims();
	seaknight_anims();
	script_models();
}



/*

// Now get on the Barrett rifle and wait for my signal. Do not engage until I give the word.	
sniperescape_mcm_getonrifle

// Remember what I've taught you. Keep in mind variable humidity and wind speed along the bullet's flight path. At this distance you値l also have to take the Coriolis effect into account.	
sniperescape_mcm_corioliseffect

// Prepare for ranging. Standby.	
sniperescape_mcm_prepranging

// White truck on the left, range, 1203.5 meters.	
sniperescape_mcm_whitetruck

// Range to BMP, 1207 meters.	
sniperescape_mcm_bmprange

// The table with the briefcase, range, 1206 meters.	
sniperescape_mcm_table

// Ok... I think I see him. Wait for my mark.	
sniperescape_mcm_mymark

// Target...acquired. I have a positive I.D. on Imran Zakhaev.	
sniperescape_mcm_positiveid

// Ach, where did he come from? Patience laddie... Wait for a clear shot�.	
sniperescape_mcm_clearshot

// Ok take the shot.	
sniperescape_mcm_taketheshot

// Damn, my line of sight was blocked. Did you take him out? I thought I saw his arm fly off! Can you see him?	
sniperescape_mcm_armflyoff

// Shit... they池e on to us! Take out that helicopter, it値l buy us some time!	
sniperescape_mcm_buysometime

// Great shot Leftenant! Now let's go! They'll be searching for us!	
sniperescape_mcm_greatshot

// We値l have to take the short cut! Follow my lead!	
sniperescape_mcm_shortcut


// Delta Two Four, this is Alpha Six! We have been compromised, I repeat we have been compromised, now heading to Extraction Point four!	
sniperescape_mcm_comrpomised

Contact north.	sniperescape_mcm_contactnorth
Movement. Northeast.	sniperescape_mcm_movementNE
Tangos moving to the east.	sniperescape_mcm_tangoseast
Targets southeast.	sniperescape_mcm_targetsSE
Contact south.	sniperescape_mcm_contactsouth
Contact southwest.	sniperescape_mcm_contactSW
Hostiles closing from the west.	sniperescape_mcm_hostileswest
Contact northwest.	sniperescape_mcm_contactNW
More coming from the north.	sniperescape_mcm_comingnorth
More coming from the northeast.	sniperescape_mcm_moreNE
More to the east.	sniperescape_mcm_moreeast
More hostiles to the southeast.	sniperescape_mcm_hostilesSE
More of them moving in from the south.	sniperescape_mcm_morefromsouth
More to the southwest.	sniperescape_mcm_moreSW
More tangos to the west.	sniperescape_mcm_tangoswest
More tangos to the northwest.	sniperescape_mcm_tangosNW
In the woods to the north!	sniperescape_mcm_woodsnorth
Movement in the woods to the northeast.	sniperescape_mcm_woodsNE
More in the woods to the east.	sniperescape_mcm_woodseast
In the woods to the southeast!	sniperescape_mcm_woodsSE
Enemies in the woods to the south.	sniperescape_mcm_woodssouth
In the woods to the southwest.	sniperescape_mcm_woodsSW
In the woods to the west!	sniperescape_mcm_woodswest
They're in the woods to the northwest!	sniperescape_mcm_woodsNW
In the bushes to the north.	sniperescape_mcm_bushesnorth
In the bushes to the northeast.	sniperescape_mcm_bushesNE
In the bushes to the east.	sniperescape_mcm_busheseast
To the southeast, in the bushes.	sniperescape_mcm_bushesSE
More tangos in the bushes to the south.	sniperescape_mcm_tangosbushesS
Enemies moving in the bushes to the southeast.	sniperescape_mcm_enemiesSE
Movement behind us. Coming through the bushes to the west.	sniperescape_mcm_busheswest
More enemies behind us, in the bushes to the northwest.	sniperescape_mcm_bushesNW
In the woods!	sniperescape_mcm_inthewoods
More behind us!	sniperescape_mcm_morebehind


Price! Put me down where I can cover you!	sniperescape_mcm_coveryou

Oi! Sit me down where I can cover your back!	sniperescape_mcm_oisit

You'd better put me down quick so I can fight back�	sniperescape_mcm_fightback


Leftenant Price! Don't get too far ahead.	sniperescape_mcm_toofarahead

Got one.	sniperescape_mcm_gotone

Tango down.	sniperescape_mcm_tangodown

He's down.	sniperescape_mcm_hesdown

Got another.	sniperescape_mcm_gotanother

Target neutralized.	sniperescape_mcm_targetneutralized

Got him.	sniperescape_mcm_gothim

// We're almost there. The extraction point is on the other side of that building.	
sniperescape_mcm_otherside

// The fugitives are near the swimming pool complex! Send Groups A and B to cut them off now!	
sniperescape_rul_nearpool

// They are heading towards the amusement park! We need reinforcements in sector three!	
sniperescape_rul_amusementpk

// Enemy sighted near the Hotel Polissia! I repeat, enemy soldiers are moving from the Hotel Polissia!	
sniperescape_rul_hotelpolissa

// They've moved into Apartment Block D, we can't follow them in there. Cut off all the exits and stop them at the park.	
sniperescape_rul_cutoffexits

*/

#using_animtree( "player" );
player_rappel()
{
	level.scr_anim[ "player_rappel" ][ "rappel" ]						= %sniper_escape_player_rappel;
	level.scr_animtree[ "player_rappel" ] 								= #animtree;	
	level.scr_model[ "player_rappel" ] 									= "viewhands_player_marines";

	level.scr_anim[ "player_carry" ][ "wounded_putdown" ]				= %sniper_escape_player_putdown;
	level.scr_anim[ "player_carry" ][ "wounded_pickup" ]				= %sniper_escape_player_getup;
	level.scr_animtree[ "player_carry" ] 								= #animtree;	
	level.scr_model[ "player_carry" ] 									= "viewhands_player_marines";

	level.scr_anim[ "player_carry" ][ "wounded_seaknight_putdown" ]		= %airlift_player_putdown;
	level.scr_anim[ "player_carry" ][ "crash_pickup" ]					= %sniper_escape_crash_pickup_player;
}

#using_animtree( "dog" );

dog_anims()
{
	level.scr_anim[ "dog" ][ "fence_attack" ] 					= %sniper_escape_dog_fence;
	level.scr_anim[ "generic" ][ "dog_food" ][ 0 ]				= %german_shepherd_eating;
	level.scr_anim[ "generic" ][ "dog_food_w_sound" ][ 0 ]		= %german_shepherd_eating;
	level.scr_anim[ "generic" ][ "dog_food_nonidle" ]			= %german_shepherd_eating;

	level.scr_sound[ "generic" ][ "dog_food_w_sound" ][ 0 ]		= "anml_dog_eating_body";


//	addNotetrack_sound( "dog", "sound_dog_attack_fence", "fence_attack", "anml_dog_attack_jump" );
	addNotetrack_sound( "dog", "fence", "fence_attack", "fence_smash" );
}

#using_animtree( "vehicles" );
seaknight_anims()
{
	level.scr_anim[ "seaknight" ][ "idle" ][ 0 ] 				= %sniper_escape_ch46_idle;
	level.scr_anim[ "seaknight" ][ "landing" ] 					= %sniper_escape_ch46_land;
	level.scr_anim[ "seaknight" ][ "take_off" ] 				= %sniper_escape_ch46_take_off;

	addNotetrack_customFunction( "seaknight", "fade", maps\sniperescape::end_level, "take_off" );

	addNotetrack_customFunction( "mi28", "rotor", maps\sniperescape_wounding::rotor_blades );
	
	level.scr_anim[ "seaknight" ][ "rotors" ] 					= %sniper_escape_ch46_rotors;
	level.scr_animtree[ "seaknight" ] 							= #animtree;

	level.scr_anim[ "mi28" ][ "entrance" ]						= %sniper_escape_crash_mi28_entrance;
	level.scr_anim[ "mi28" ][ "idle" ][ 0 ]						= %sniper_escape_crash_mi28_idle;
	level.scr_anim[ "mi28" ][ "crash" ]							= %sniper_escape_crash_mi28_crash;


}

#using_animtree( "script_model" );
script_models()
{
	level.scr_anim[ "zakhaev" ][ "zak_pain" ]					= %sniper_escape_meeting_zakhaev_hit_front; //exposed_pain_2_crouch;
	level.scr_anim[ "generic" ][ "zak_pain_back" ]				= %sniper_escape_meeting_zakhaev_hit_back; //exposed_pain_2_crouch;
	level.scr_animtree[ "zakhaev" ] 							= #animtree;


	level.scr_anim[ "curtain" ][ "curtain_right" ]				= %chechnya_curtain_sway_le;
	level.scr_anim[ "curtain" ][ "curtain_left" ]				= %chechnya_curtain_sway_ri;
	level.scr_animtree[ "curtain" ] 							= #animtree;	
	level.scr_model[ "curtain" ] 								= "ch_curtain01";

	level.scr_animtree[ "rope" ] 								= #animtree;
	level.scr_model[ "rope" ] 									= "rappelrope100_ri";

	level.scr_anim[ "player_rope" ][ "rappel_for_player" ]		= %sniper_escape_player_start_rappelrope100;
	level.scr_animtree[ "player_rope" ] 						= #animtree;
	level.scr_model[ "player_rope" ] 							= "rappelrope100_le";

	level.scr_anim[ "player_rope_obj" ][ "rappel_for_player" ]	= %sniper_escape_player_start_rappelrope100;
	level.scr_animtree[ "player_rope_obj" ] 					= #animtree;
	level.scr_model[ "player_rope_obj" ] 						= "rappelrope100_le_obj";

	level.scr_anim[ "rope" ][ "rappel_end" ]					= %sniper_escape_rappel_finish_rappelrope100;
	level.scr_anim[ "rope" ][ "rappel_start" ]					= %sniper_escape_rappel_start_rappelrope100;
	level.scr_anim[ "rope" ][ "rappel_idle" ][ 0 ]				= %sniper_escape_rappel_idle_rappelrope100;

	level.scr_anim[ "briefcase" ][ "exchange" ]					= %sniper_escape_meeting_briefcase;
	level.scr_animtree[ "briefcase" ] 							= #animtree;
	
	level.scr_anim[ "brick" ][ "exchange" ]						= %sniper_escape_meeting_briefcase;
	level.scr_animtree[ "brick" ] 								= #animtree;
	
	level.scr_anim[ "flag" ][ "up" ]							= %sniper_escape_flag_wave_up;
	level.scr_anim[ "flag" ][ "down" ]							= %sniper_escape_flag_wave_down;
	level.scr_animtree[ "flag" ] 								= #animtree;

	if ( !level.sniperescape_fastload )	
	{
		level.scr_model[ "binocs" ] 								= "weapon_binocular";
		level.scr_model[ "flag" ] 									= "prop_car_flag";
		level.scr_model[ "brick" ] 									= "com_golden_brick";
		level.scr_model[ "briefcase" ] 								= "com_gold_brick_case";
		level.scr_model[ "zak_one_arm" ] 							= "body_complete_onearm_sp_zakhaev";
		level.scr_model[ "zak_left_arm" ] 							= "zakhaev_left_arm";
	}

	level.scr_animtree[ "zak_left_arm" ] 							= #animtree;
	level.scr_anim[ "zak_left_arm" ][ "zak_pain" ] 					= %sniper_escape_meeting_zakhaev_hit_arm_front;

	addNotetrack_flag( "briefcase", "dust", "briefcase_placed", "exchange" );
	
	
	level.scr_model[ "tag_gunner" ] 							= "vehicle_mi-28_window_front";
	
	level.scr_model[ "tag_pilot" ] 								= "vehicle_mi-28_window_back";
	


	level.scr_model[ "blade1" ]	 							= "vehicle_mi-28_hub";
	level.scr_model[ "blade2" ]		 						= "vehicle_mi-28_blade1";
	level.scr_model[ "blade3" ]		 						= "vehicle_mi-28_blade2";
	level.scr_model[ "blade4" ]		 						= "vehicle_mi-28_blade3";
	level.scr_model[ "blade5" ]		 						= "vehicle_mi-28_blade4";
	
	addNotetrack_customFunction( "blade1", "blade", ::remove_blade );
	addNotetrack_customFunction( "blade2", "blade", ::remove_blade );
	addNotetrack_customFunction( "blade3", "blade", ::remove_blade );
	addNotetrack_customFunction( "blade4", "blade", ::remove_blade );
	addNotetrack_customFunction( "blade5", "blade", ::remove_blade );

	level.scr_animtree[ "blade1" ] 							= #animtree;
	level.scr_animtree[ "blade2" ] 							= #animtree;
	level.scr_animtree[ "blade3" ] 							= #animtree;
	level.scr_animtree[ "blade4" ] 							= #animtree;
	level.scr_animtree[ "blade5" ] 							= #animtree;

	level.scr_anim[ "blade1" ][ "spin" ]	 					= %sniper_escape_crash_mi28_rotor_1;
	level.scr_anim[ "blade2" ][ "spin" ]	 					= %sniper_escape_crash_mi28_rotor_2;
	level.scr_anim[ "blade3" ][ "spin" ]	 					= %sniper_escape_crash_mi28_rotor_3;
	level.scr_anim[ "blade4" ][ "spin" ]	 					= %sniper_escape_crash_mi28_rotor_4;
	level.scr_anim[ "blade5" ][ "spin" ]	 					= %sniper_escape_crash_mi28_rotor_5;


	level.scr_anim[ "generic" ][ "dead_pilot" ]					= %sniper_escape_crash_mi28_pilot;
	level.scr_anim[ "generic" ][ "dead_gunner" ]				= %sniper_escape_crash_mi28_copilot;
	level.scr_animtree[ "dead_heli_pilot" ] 								= #animtree;
}
