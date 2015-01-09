#include maps\_anim;
#include maps\_props;
#include maps\_utility;
#include maps\blackout_code;
#using_animtree("generic_human");

main()
{
	add_smoking_notetracks( "generic" );
	add_cellphone_notetracks( "generic" );

	/#	
	level.scr_anim[ "generic" ][ "exposed_headshot" ]			= %exposed_death_headshot;
	#/

	level.scr_anim[ "generic" ][ "rappel_end" ]					= %sniper_escape_rappel_finish;
	level.scr_anim[ "generic" ][ "rappel_start" ]				= %blackout_rappel_start;
	level.scr_anim[ "generic" ][ "rappel_idle" ][ 0 ]			= %sniper_escape_rappel_idle;

	level.scr_anim[ "generic" ][ "grenade_throw" ]				= %corner_standL_grenade_B;//exposed_grenadeThrowB//

	level.scr_anim[ "generic" ][ "moveout_cqb" ]				= %CQB_stand_signal_move_out;
	level.scr_anim[ "generic" ][ "moveup_cqb" ]					= %CQB_stand_signal_move_up;
	level.scr_anim[ "generic" ][ "stop_cqb" ]					= %CQB_stand_signal_stop;
	level.scr_anim[ "generic" ][ "onme_cqb" ]					= %CQB_stand_wave_on_me;
	
	level.scr_anim[ "generic" ][ "moveout_exposed" ]			= %stand_exposed_wave_move_out;
	level.scr_anim[ "generic" ][ "moveup_exposed" ]				= %stand_exposed_wave_move_up;
	level.scr_anim[ "generic" ][ "stop_exposed" ]				= %stand_exposed_wave_halt;
	level.scr_anim[ "generic" ][ "stop2_exposed" ]				= %stand_exposed_wave_halt_v2;
	level.scr_anim[ "generic" ][ "onme_exposed" ]				= %stand_exposed_wave_on_me;
	level.scr_anim[ "generic" ][ "onme2_exposed" ]				= %stand_exposed_wave_on_me_v2;
	level.scr_anim[ "generic" ][ "enemy_exposed" ]				= %stand_exposed_wave_target_spotted;
	level.scr_anim[ "generic" ][ "down_exposed" ]				= %stand_exposed_wave_down;
	level.scr_anim[ "generic" ][ "go_exposed" ]					= %stand_exposed_wave_go;
	
	level.scr_anim[ "generic" ][ "walk_1" ]						= %patrolwalk_tired;
	level.scr_anim[ "generic" ][ "walk_2" ]						= %patrol_bored_patrolwalk;
	level.scr_anim[ "generic" ][ "walk_3" ]						= %patrolwalk_bounce;
	level.scr_anim[ "generic" ][ "walk_4" ]						= %patrolwalk_swagger;
	level.scr_anim[ "generic" ][ "walk_5" ]						= %walk_lowready_F;
	
	level.scr_anim[ "kamarov" ][ "binoc_idle" ][ 0 ]			= %blackout_binoc_idle;
	
	level.scr_model[ "binocs" ] 								= "weapon_binocular";


	addNotetrack_flag( "price", "start_gaz", "start_cliff_scene_gaz" );
	addNotetrack_flag( "price", "start_kam", "start_cliff_scene_kamarov" );
	addNotetrack_flag( "kamarov", "drop binoculars", "kamarov_drops_binocs" );
	
	level.scr_anim[ "price" ]	[ "cliff_start" ]				= %blackout_price_cliff;
	level.scr_anim[ "kamarov" ]	[ "cliff_start" ]				= %blackout_kam_cliff;
	level.scr_anim[ "gaz" ]		[ "cliff_start" ]				= %blackout_gaz_cliff;

	level.scr_anim[ "kamarov" ]	[ "cliff_start_idle" ][ 0 ]		= %blackout_kam_start;
	level.scr_anim[ "gaz" ]		[ "cliff_start_idle" ][ 0 ]		= %blackout_gaz_cliff_start;

	level.scr_anim[ "kamarov" ]	[ "cliff_end_idle" ][ 0 ]		= %blackout_kam_cliff_endidle;
	
	level.scr_anim[ "price" ][ "meeting" ]						= %blackout_meeting_price;
	//* What's the target Kamarov? We've got an informant to recover.                                     
	addNotetrack_dialogue( "price", "dialog", "meeting", "blackout_pri_whattarget" );
	//* Not so fast. Remember Beirut? You're with us.	
	addNotetrack_dialogue( "price", "dialog", "meeting", "blackout_pri_beirut" );

	//* Move out.	
	level.scr_sound[ "price" ][ "move_out" ] 			= "blackout_pri_moveout";

	//* Welcome to the new Russia, Captain Price.	
	addNotetrack_dialogue( "kamarov", "dialog", "meeting", "blackout_kmr_welcome" );
	//* The Ultranationalists have BM21s on the other side of the hill. Their rockets have killed hundreds of civilians in the valley below.	
	addNotetrack_dialogue( "kamarov", "dialog", "meeting", "blackout_kmr_valleybelow" );
	//* Hmm…I guess I owe you one.	
	addNotetrack_dialogue( "kamarov", "dialog", "meeting", "blackout_kmr_oweyouone" );
	
	
	level.scr_anim[ "kamarov" ][ "meeting" ]					= %blackout_meeting_kamarov;
                                         
	level.scr_anim[ "frnd" ][ "signal_assault_coverstand" ]		= %coverstand_hide_idle_wave02;
	level.scr_anim[ "frnd" ][ "signal_forward_coverstand" ]		= %coverstand_hide_idle_wave01;

	level.scr_anim[ "generic" ][ "surprise_1" ]					= %parabolic_chessgame_surprise_a;
	level.scr_anim[ "generic" ][ "surprise_2" ]					= %parabolic_chessgame_surprise_b;
	level.scr_anim[ "generic" ][ "idle_1" ][ 0 ]				= %parabolic_chessgame_idle_a;
	level.scr_anim[ "generic" ][ "idle_2" ][ 0 ]				= %parabolic_chessgame_idle_b;
	level.scr_anim[ "chess_guy1" ][ "death" ]					= %parabolic_chessgame_death_a;
	level.scr_anim[ "chess_guy2" ][ "death" ]					= %parabolic_chessgame_death_b;

	/*
	level.scr_anim[ "vip" ][ "death" ]							= %blackout_vip_cower_idle;
	*/

	level.scr_anim[ "vip" ][ "evac" ]							= %blackout_bh_evac_1;
	level.scr_anim[ "gaz" ][ "evac" ]							= %blackout_bh_evac_2;
	level.scr_anim[ "price" ][ "evac" ]							= %blackout_bh_evac_price;
	level.scr_anim[ "price" ][ "evac_flyaway" ]					= %blackout_bh_evac_price_flyaway;
	level.scr_anim[ "price" ][ "evac_idle" ][ 0 ]				= %blackout_bh_evac_price_idle;

	addNotetrack_dialogue( "vip", "dialog", "evac", "blackout_nkd_americansattacked" );
	addNotetrack_dialogue( "vip", "dialog", "evac", "blackout_nkd_makingamistake" );
	addNotetrack_dialogue( "price", "dialog", "evac_flyaway", "blackout_pri_invasion" );

	
	
	level.scr_anim[ "price" ][ "rescue" ]						= %blackout_rescue_price;
	//* It's him.                                                                                             
//	addNotetrack_dialogue( "price", "dialog", "rescue", "blackout_pri_itshim" );
	addNotetrack_customFunction( "price", "dialog",		 		::vip_rescue_dialogue, "rescue" );
	

	level.scr_anim[ "vip" ][ "idle" ][ 0 ]						= %blackout_vip_cower_idle;
	level.scr_anim[ "vip" ][ "rescue" ]							= %blackout_rescue_vip;
	level.scr_sound[ "vip" ][ "rescue" ]						= "scn_blackout_vip_rescue";
	
		

//	addNotetrack_customFunction( "price", "attach_flashlight", 	::flashlight_fx_change, "rescue" );

	level.scr_anim[ "flashlight_guy" ][ "fl_death" ]			= %blackout_flashlightguy_death_only;
	level.scr_anim[ "flashlight_guy" ][ "fl_death_local" ]		= %blackout_flashlightguy_death_local;
	level.scr_anim[ "flashlight_guy" ][ "search" ]				= %blackout_flashlightguy_moment2death;
	addNotetrack_customFunction( "flashlight_guy", "fire", 		::flashlight_fire );
	
	
	

	level.scr_anim[ "generic" ][ "casual_patrol_jog" ]			= %patrol_jog;
	level.scr_anim[ "generic" ][ "casual_patrol_walk" ]			= %patrolwalk_tired; // patrolwalk_swagger;
	level.scr_anim[ "generic" ][ "combat_jog" ]					= %combat_jog;
	level.scr_anim[ "generic" ][ "smoke" ]						= %patrol_bored_idle_smoke;
	level.scr_anim[ "generic" ][ "smoke_idle" ][ 0 ]			= %patrol_bored_idle_smoke;
	


	level.scr_anim[ "generic" ][ "moveout_cqb" ]				= %CQB_stand_signal_move_out;
	level.scr_anim[ "generic" ][ "moveup_cqb" ]					= %CQB_stand_signal_move_up;
	level.scr_anim[ "generic" ][ "stop_cqb" ]					= %CQB_stand_signal_stop;
	level.scr_anim[ "generic" ][ "onme_cqb" ]					= %CQB_stand_wave_on_me;
	
	level.scr_anim[ "generic" ][ "signal_moveup" ]				= %CQB_stand_signal_move_up;
	level.scr_anim[ "generic" ][ "signal_onme" ]				= %CQB_stand_wave_on_me;
	level.scr_anim[ "generic" ][ "signal_go" ]					= %CQB_stand_wave_go_v1;
	level.scr_anim[ "generic" ][ "signal_stop" ]				= %CQB_stand_signal_stop;

	level.scr_anim[ "generic" ][ "bored_idle_reach" ]			= %patrol_bored_idle;
	level.scr_anim[ "generic" ][ "bored_idle" ][ 0 ]			= %patrol_bored_idle;
	level.scr_anim[ "generic" ][ "bored_idle" ][ 1 ]			= %patrol_bored_twitch_bug;
	level.scr_anim[ "generic" ][ "bored_idle" ][ 2 ]			= %patrol_bored_twitch_stretch;
	
	
	
	level.scr_anim[ "generic" ][ "bored_alert" ]				= %exposed_idle_twitch_v4; // %patrol_bored_2_combat_alarm;
	level.scr_anim[ "generic" ][ "bored_smoke" ]				= %patrol_bored_idle_smoke;
	level.scr_anim[ "generic" ][ "bored_cell" ]					= %patrol_bored_idle_cellphone;
	level.scr_anim[ "generic" ][ "bored_salute" ]				= %patrol_bored_twitch_salute;
	level.scr_anim[ "generic" ][ "bored_checkphone" ]			= %patrol_bored_twitch_checkphone;

	level.scr_anim[ "generic" ][ "bored_cell_loop" ][ 0 ]		= %patrol_bored_idle_cellphone;


	level.scr_anim[ "generic" ][ "sleep_idle" ][ 0 ]			= %parabolic_guard_sleeper_idle;
	level.scr_anim[ "generic" ][ "sleep_react" ]				= %parabolic_guard_sleeper_react;
	
	level.scr_anim[ "generic" ][ "stealth_jog" ]				= %patrol_jog;
	level.scr_anim[ "generic" ][ "stealth_walk" ]				= %patrol_bored_patrolwalk;
	level.scr_anim[ "generic" ][ "combat_jog" ]					= %combat_jog;

	level.scr_anim[ "generic" ][ "prone_to_stand_1" ]			= %hunted_pronehide_2_stand_v1;
	level.scr_anim[ "generic" ][ "prone_to_stand_2" ]			= %hunted_pronehide_2_stand_v2;
	level.scr_anim[ "generic" ][ "prone_to_stand_3" ]			= %hunted_pronehide_2_stand_v3;

	level.scr_anim[ "generic" ][ "smoking_reach" ]				= %parabolic_leaning_guy_smoking_idle;
	level.scr_anim[ "generic" ][ "smoking" ][ 0 ]				= %parabolic_leaning_guy_smoking_idle;
	level.scr_anim[ "generic" ][ "smoking" ][ 1 ]				= %parabolic_leaning_guy_smoking_twitch;
	level.scr_anim[ "generic" ][ "smoking_react" ]				= %parabolic_leaning_guy_react;
	

	

	level.scr_anim[ "generic" ][ "prone_dive" ] 				= %hunted_dive_2_pronehide_v1;
	
	level.scr_anim[ "generic" ][ "_stealth_behavior_whizby_0" ]			= %exposed_idle_reactA;
	level.scr_anim[ "generic" ][ "_stealth_behavior_whizby_1" ]			= %exposed_idle_reactB;
	level.scr_anim[ "generic" ][ "_stealth_behavior_whizby_2" ]			= %exposed_idle_twitch;
	level.scr_anim[ "generic" ][ "_stealth_behavior_whizby_3" ]			= %exposed_idle_twitch_v4;
	level.scr_anim[ "generic" ][ "_stealth_behavior_whizby_4" ]			= %run_pain_stumble;
	
	level.scr_anim[ "generic" ][ "_stealth_behavior_spotted_short" ]		= %exposed_idle_twitch_v4;//patrol_bored_2_combat_alarm_short;
	level.scr_anim[ "generic" ][ "_stealth_behavior_spotted_long" ]			= %exposed_idle_twitch_v4;
	level.scr_anim[ "generic" ][ "_stealth_behavior_heard_scream" ]			= %exposed_idle_twitch_v4;

	level.scr_anim[ "generic" ][ "patrol_walk" ]				= %patrol_bored_patrolwalk;
	level.scr_anim[ "generic" ][ "patrol_walk_twitch" ]			= %patrol_bored_patrolwalk_twitch;
	level.scr_anim[ "generic" ][ "patrol_stop" ]				= %patrol_bored_walk_2_bored;
	level.scr_anim[ "generic" ][ "patrol_start" ]				= %patrol_bored_2_walk;
	level.scr_anim[ "generic" ][ "patrol_turn180" ]				= %patrol_bored_2_walk_180turn;


	level.scr_anim[ "generic" ][ "blind_fire_pistol" ]			= %blackout_blind_fire_pistol;
	level.scr_anim[ "generic" ][ "blind_fire_pistol_death" ]	= %blackout_blind_fire_pistol_death;

	// russian screams
	addOnStart_animSound( "generic", "blind_hide_fire", "blackout_ru1_scream" );
	level.scr_anim[ "generic" ][ "blind_hide_fire" ]			= %blackout_blind_hide_fire;
	level.scr_anim[ "generic" ][ "blind_hide_fire_death" ]		= %blackout_blind_hide_fire_death;


	addOnStart_animSound( "generic", "blind_lightswitch", "blackout_ru1_electrician" );
	level.scr_anim[ "generic" ][ "blind_lightswitch" ]			= %blackout_blind_lightswitch;
	level.scr_anim[ "generic" ][ "blind_lightswitch_death" ]	= %blackout_blind_lightswitch_death;
	addNotetrack_sound( "generic", "switch_up", "blind_lightswitch", "scn_blackout_lightswitch_on" );
	addNotetrack_sound( "generic", "switch_down", "blind_lightswitch", "scn_blackout_lightswitch_off" );
	

	addOnStart_animSound( "generic", "blind_wall_feel", "blackout_ru1_sasha" );
	level.scr_anim[ "generic" ][ "blind_wall_feel" ]			= %blackout_blind_wall_feel;
	level.scr_anim[ "generic" ][ "blind_wall_feel_death" ]		= %blackout_blind_wall_feel_death;


	level.scr_sound[ "generic" ][ "breathing" ]					= "blackout_ru4_breathing";
	
	level.scr_anim[ "generic" ][ "smooth_door_open" ]				= %hunted_open_barndoor_flathand;

	level.scr_anim[ "generic" ][ "standup" ] = %exposed_crouch_2_stand;
	

	// Do it
	level.scr_sound[ "price" ][ "do_it" ]							= "villagedef_pri_doit";


	// This night vision makes it too easy
	level.scr_sound[ "price" ][ "this_night_vision" ]							= "blackout_pri_nightvision";

	// Lets go
	level.scr_sound[ "price" ][ "lets_go" ]							= "blackout_pri_letsgo2";
	
	//* The Loyalists are expecting us half a klick to the north. Move out.
	level.scr_sound[ "price" ][ "expecting_us" ]							= "blackout_pri_halfaclick";
	level.scr_face[ "price" ][ "expecting_us" ]								= %blackout_price_facial_moveout;
	
	
	//* Well, they won't shoot at us on sight, if that's what you're asking.                               
	level.scr_sound[ "price" ][ "wont_shoot_us" ]						= "blackout_pri_shootatus";
	
	//* Then let's get to it.                                                                                
	level.scr_sound[ "price" ][ "lets_get_to_it" ]						= "blackout_pri_gettoit";
	
	//* Soap, over here.                                                                                    
	level.scr_sound[ "price" ][ "over_here" ]							= "blackout_pri_overhere";
	
	//* Sniper team in position. Gaz, cover the left flank.                                                
	level.scr_sound[ "price" ][ "in_position" ]							= "blackout_pri_leftflank";
	
	// Soap! Hit those machine gunners in the windows!                         
	//* Soap, take out the machine gunners in the windows so Kamarov's men can storm the building!          
	level.scr_sound[ "price" ][ "machine_gunners_in_windows" ]			= "blackout_pri_takeoutmgs";
	
	//* Not a problem. We'll take care of it. Soap, Gaz, let's go!                                        
	level.scr_sound[ "price" ][ "not_a_problem" ]						= "blackout_pri_takecare";
	
	// Soap, watch the BMP and take out any hostiles you see.                                              
	level.scr_sound[ "price" ][ "watch_bmp" ]							= "blackout_pri_watchbmp";
	
	// Go - go - go!                                                                                         
	level.scr_sound[ "price" ][ "go_go_go" ]								= "blackout_pri_gogogo";
	
	//* Soap, get to the edge of the cliff and cover Kamarov's men! Move!                                
	level.scr_sound[ "price" ][ "cover_cliff" ]							= "blackout_pri_edgeofcliff";
	
	// Nice work Soap.                                                                                     
	level.scr_sound[ "price" ][ "nice_work" ]							= "blackout_pri_nicework";
	
	//* Kamarov, we've completed our end of the bargain. Now where is the informant?                      
	level.scr_sound[ "price" ][ "where_is_informant" ]					= "blackout_pri_ourbargain";
	
	//* Bloody hell let's move. He may still be alive.                                                  
	level.scr_sound[ "price" ][ "lets_move" ]							= "blackout_pri_stillbealive";
	
	//* Gaz, go around the back and cut the power. Everyone else, get ready!                                
	level.scr_sound[ "price" ][ "cut_the_power" ]						= "blackout_pri_cutpower";
	
	//* It's him.                                                                                             
	level.scr_sound[ "price" ][ "its_him" ]								= "blackout_pri_itshim";
	
	//* Big Bird this Bravo Six. We have the package. Meet us at LZ one. Over.                              
	level.scr_sound[ "price" ][ "have_the_package" ]						= "blackout_pri_meetatlz";
	
	//* Let's go! Let's go!                                                                                   
	level.scr_sound[ "price" ][ "lets_go_lets_go" ]						= "blackout_pri_letsgo";
	
	//* No, their invasion begins in a few hours! Why?                                                      
//	level.scr_sound[ "price" ][ "invasion_begins" ]						= "blackout_pri_invasion";
	
	//* Loyalists eh? Are those are the good Russians or the bad Russians?                              
	level.scr_sound[ "gaz" ][ "loyalists_eh" ]							= "blackout_gaz_loyalistseh";
	
	//* That's good enough for me sir.                                                                   
	level.scr_sound[ "gaz" ][ "good_enough" ]							= "blackout_gaz_goodenough";
	
	//* Roger. Covering left flank.                                                                       
	level.scr_sound[ "gaz" ][ "cover_left_flank" ]						= "blackout_gaz_leftflank";
	
	// Target of opportunity sir. We got a BMP down there.                                             
	level.scr_sound[ "gaz" ][ "got_a_bmp" ]								= "blackout_gaz_opportunity";
	
	//* Sir, we've got company! Helicopter troops closing in fast!                                       
	level.scr_sound[ "gaz" ][ "helicopter_troops" ]						= "blackout_gaz_helitroops";
	
	//* Tangos neutralized! All clear!                                                                     
	level.scr_sound[ "gaz" ][ "tangos_neutralized" ]					= "blackout_gaz_allclear";
	
	//* May be alive?? I hate bargaining with Kamarov. There's always a bloody catch.                    
	level.scr_sound[ "gaz" ][ "hate_bargaining" ]						= "blackout_gaz_maybealive";
	
	//* Soap! Regroup with Captain Price! You can storm the building when I cut the power. Go!         
	level.scr_sound[ "gaz" ][ "regroup_with_price" ]					= "blackout_gaz_regroupprice";
	
	//* Nikolai - are you all right? Can you walk?														    
	level.scr_sound[ "gaz" ][ "are_you_all_right" ]						= "blackout_gaz_allright";

	// Gaz, do it.	
	level.scr_sound[ "price" ][ "gaz_do_it" ] 							= "blackout_pri_gazdoit";

	// All right I've cut the power. Go.	
	level.scr_sound[ "gaz" ][ "i_cut_the_power" ]			 			= "blackout_gaz_ivecutthepower";


	
	//* Bravo Six this is Big Bird. We're on our way. Out.	
	level.scr_radio[ "on_our_way" ] = "blackout_mhp_onourway";
	
	
	//* Yes...and I can still fight. Thank you for getting me out of here.	
	level.scr_sound[ "vip" ][ "yes_can_still_fight" ]							= "blackout_nkd_icanstillfight";

	//* Have the Americans already attacked Al-Asad?	
//	level.scr_sound[ "vip" ][ "have_americans_attacked" ]						= "blackout_nkd_americansattacked";

	//* The Americans are making a mistake. They will never take Al-Asad alive.	
//	level.scr_sound[ "vip" ][ "making_a_mistake" ]								= "blackout_nkd_makingamistake";

	// Go! Go!	blackout_ru1_gogo


	// Understood. Moving into position.	
	level.scr_sound[ "kamarov" ][ "moving_into_position" ]						= "blackout_ru2_movingintoposition";

	//* It's all right. It is the SAS. Welcome to the new Russia, Captain Price.	
	level.scr_sound[ "kamarov" ][ "welcome_to_new_russia" ]						= "blackout_kmr_newrussia";

	//* I need you and your men to provide us with sniper support.	
	level.scr_sound[ "kamarov" ][ "provide_sniper" ]							= "blackout_kmr_snipersupprt";

	//* The Ultranationalists have BM21s on the other side of the hill. Their rockets have killed hundreds of civilians in the valley below.	
	level.scr_sound[ "kamarov" ][ "bm21s_on_other_side" ]						= "blackout_kmr_valleybelow";

	//* In return, we will give you the location of your informant.	
	level.scr_sound[ "kamarov" ][ "give_informant_location" ]					= "blackout_kmr_givelocation";

	//* Da. This way.	
	level.scr_sound[ "kamarov" ][ "this_way" ]									= "blackout_kmr_thisway";

	//* Vanya, move in and prepare to attack. Wait for my signal.	
	level.scr_sound[ "kamarov" ][ "prepare_to_attack" ]							= "blackout_kmr_prepareattack";

	//* You should be able to find a good vantage point down that path. Go. Be ready.	
	level.scr_sound[ "kamarov" ][ "find_good_vantage" ]							= "blackout_kmr_beready";

	//* Vanya, standby to attack. Sniper team, report.	
	level.scr_sound[ "kamarov" ][ "standby_to_attack" ]							= "blackout_kmr_sniperteam";

	//* All units, commence the attack.	
	level.scr_sound[ "kamarov" ][ "commence_attack" ]							= "blackout_kmr_commence";

	//* Captain Price, we have an enemy helicopter circling around to the east. Can you hold them off?	
	level.scr_sound[ "kamarov" ][ "enemy_heli_circling" ]						= "blackout_kmr_holdthemoff";

	//* Very well. Your informant is being held in the house at the northeast end of the village. Dead or alive you will find him there. Good luck.	
	level.scr_radio[ "informant_held_in_house" ]					= "blackout_kmr_deadoralive";

	//* Very well. Your informant is being held in the house at the northeast end of the village. Dead or alive you will find him there. Good luck.	
	level.scr_sound[ "price" ][ "tango_down" ]					= "UK_pri_inform_killfirm_generic_s";
	level.scr_sound[ "gaz" ][ "tango_down" ]					= "UK_2_inform_killfirm_generic_s";
//	dialog[ "generic" ] = "UK_0_inform_killfirm_generic_s"; 



	new_dialogue();


	maps\_breach_explosive_left::main(); 

//  patrol_bored_patrolwalk // loping, slow look left and right
//	walk_lowready_F  // aiming
//	patrolwalk_swagger // walks with gun held low
//	patrolwalk_bounce
//	patrolwalk_tired
//  stand_walk_combat_loop
//	sniper_escape_price_walk

	//level.scr_anim[ "frnd" ][ "signal_cqb_rally_on_me" ]		= %cqb_stand_wave_go_v1;
/*
guard_sleeper_idle
guard_sleeper_react
leaning_guy_idle
leaning_guy_smoking_idle
leaning_guy_smoking_twitch
leaning_guy_talk
leaning_guy_trans2idle
leaning_guy_trans2smoke
leaning_guy_twitch
*/   
	script_models();
	player_rappel();
	blackhawk_anims();
	radio_prec();
}

#using_animtree( "script_model" );
script_models()
{
	level.scr_anim[ "chair" ][ "sleep_react" ]					= %parabolic_guard_sleeper_react_chair;
	level.scr_animtree[ "chair" ] 								= #animtree;	
	level.scr_model[ "chair" ] 									= "com_folding_chair";

	

	level.scr_animtree[ "rope" ] 								= #animtree;
	level.scr_model[ "rope" ] 									= "rappelrope100_ri";

	level.scr_anim[ "player_rope" ][ "rappel_for_player" ]		= %sniper_escape_player_start_rappelrope100;
	level.scr_animtree[ "player_rope" ] 						= #animtree;
	level.scr_model[ "player_rope" ] 							= "rappelrope100_le";

	level.scr_anim[ "rope" ][ "rappel_end" ]					= %sniper_escape_rappel_finish_rappelrope100;
	level.scr_anim[ "rope" ][ "rappel_start" ]					= %blackout_rappel_start_rappelrope100;
	level.scr_anim[ "rope" ][ "rappel_idle" ][ 0 ]				= %sniper_escape_rappel_idle_rappelrope100;
	
	level.scr_anim[ "flashlight" ][ "fl_death" ]				= %blackout_flashlightguy_death_flashlight;
	level.scr_sound[ "flashlight" ][ "fl_death" ]				= "scn_blackout_drop_flashlight";

	level.scr_anim[ "flashlight" ][ "search" ]					= %blackout_flashlightguy_moment2death_flashlight;
	level.scr_sound[ "flashlight" ][ "search" ]					= "scn_blackout_drop_flashlight_draw";
	
	level.scr_anim[ "flashlight" ][ "rescue" ]					= %blackout_rescue_price_flashlight;
	
	level.scr_animtree[ "flashlight" ] 							= #animtree;	
	level.scr_model[ "flashlight" ] 							= "com_flashlight_on";
	
	level.scr_anim[ "player_rope_obj" ][ "rappel_for_player" ]	= %sniper_escape_player_start_rappelrope100;
	level.scr_animtree[ "player_rope_obj" ] 					= #animtree;
	level.scr_model[ "player_rope_obj" ] 						= "rappelrope100_le_obj";
}

#using_animtree( "player" );
player_rappel()
{
	level.scr_animtree[ "player_rig" ] 							= #animtree;	
	level.scr_model[ "player_rig" ] 							= "viewhands_player_sas_woodland";
	level.scr_anim[ "player_rig" ][ "rappel" ]					= %sniper_escape_player_rappel;
	level.scr_anim[ "player_rig" ][ "player_evac" ]				= %blackout_bh_evac_player;
}

#using_animtree( "vehicles" );
blackhawk_anims()
{
	level.scr_anim[ "blackhawk" ][ "idle" ][ 0 ] 				= %blackout_bh_evac_heli_idle;
	level.scr_anim[ "blackhawk" ][ "landing" ] 					= %blackout_bh_evac_heli_land;
	level.scr_anim[ "blackhawk" ][ "take_off" ] 				= %blackout_bh_evac_heli_takeoff;
	addNotetrack_customFunction( "blackhawk", "fade", 	::blackout_missionsuccess );
	
	level.scr_anim[ "blackhawk" ][ "rotors" ] 					= %bh_rotors;
	level.scr_animtree[ "blackhawk" ] 							= #animtree;
}

blackout_missionsuccess( guy )
{
	maps\_utility::nextmission();
}


radio_prec()
{
	// Price: weapons free
	level.scr_radio[ "weapons_free" ]						= "cargoship_pri_weaponsfree";
	
	// Gaz: roger that
	level.scr_radio[ "roger_that" ]							= "cargoship_grg_rogerthatradio";

	// Price: Go.
	level.scr_radio[ "go!" ]								= "cargoship_pri_go";
	
	// Price: Watch for movement.
	level.scr_radio[ "watch_for_movement" ]					= "cargoship_pri_watchmovement";

	// Gaz: what's that noise?
	level.scr_radio[ "whats_noise" ]						= "cargoship_grg_whatsnoise";

	
}




new_dialogue()
{
	//* Good work. There should be a few more guard posts up ahead. Kamarov and his men will be waiting for us in a field to the northwest.	
	level.scr_sound[ "price" ][ "guard_posts_ahead" ] 			= "blackout_pri_guardpostsahead";
	// 
	//* You smell that Gaz?	
	level.scr_sound[ "price" ][ "smell_that" ] 			= "blackout_pri_smellthatgaz";
	// 
	//* Yeah. Kamarov.	
	level.scr_sound[ "gaz" ][ "yeah_kam" ] 			= "blackout_gaz_yeahkamarov";
	// 
	// 
	// 
	//* Bloody right you do.	
	level.scr_sound[ "gaz" ][ "bloody_right" ] 			= "blackout_gaz_bloodyrightyoudo";
	// 
	// 
	//* What's the target Kamarov? We've got an informant to recover.	
	level.scr_sound[ "price" ][ "what_target" ] 			= "blackout_pri_whattarget";
	
	
	//* This way. There's a good spot where your sniper can cover my men.	
	level.scr_sound[ "kamarov" ][ "good_spot" ] 			= "blackout_kmr_goodspot";
	//* Soap, switch to your sniper rifle.	
	level.scr_sound[ "price" ][ "switch_sniper" ] 			= "blackout_pri_switchtosniper";
	//* Soap, take out the machine gunners in the windows, 10 o'clock low!	
	level.scr_sound[ "price" ][ "mg_windows" ] 			= "blackout_pri_mgwindows";
	// Shoot those machine gunners through the wall. They're in the near building, below on the left.	
	level.scr_sound[ "price" ][ "mg_walls" ] 			= "blackout_pri_mgwalls";
	// Hit the other machine gunner through the wall.	
	level.scr_sound[ "price" ][ "other_mg_wall" ] 			= "blackout_pri_othermgwall";
	// Soap, hit those machine gunners, 10 o'clock low!	
	level.scr_sound[ "price" ][ "mg_low" ] 			= "blackout_pri_mglow";
	// Nice shot. MacMillan would be impressed.	
	level.scr_sound[ "price" ][ "macmillan_impressed" ] 			= "blackout_pri_impressed";

	// Damn, enemy helicopters!	
	level.scr_sound[ "kamarov" ][ "damn_helis" ] 			= "blackout_kmr_damnhelis";
	// You didn't say there would be helicopters Kamarov.	
	level.scr_sound[ "price" ][ "you_didnt_say" ] 			= "blackout_pri_youdidntsay";
	// I didn't say there wouldn't be any either. We need to protect my men from those helicopter troops. This way!	
	level.scr_sound[ "kamarov" ][ "need_protect" ] 			= "blackout_kmr_needtoprotect";
	// Make it quick Kamarov, I want that informant…	
	level.scr_sound[ "price" ][ "make_quick" ] 			= "blackout_pri_makeitquick";
	// You have nothing to worry about. We'll take out the BM21s and carve a path straight to your informant Captain Price.	
	level.scr_sound[ "kamarov" ][ "nothing_to_worry" ] 			= "blackout_kmr_nothingtoworry";

	

	// We should just beat it out of him sir.	
	level.scr_sound[ "gaz" ][ "beat_it_out" ] 			= "blackout_gaz_beatitoutofhim";
	// Not yet.	
	level.scr_sound[ "price" ][ "not_yet" ] 			= "blackout_pri_notyet";
	// What is your status? How much longer do you need? All right, I'll keep stalling them.	
	level.scr_sound[ "kamarov" ][ "stalling" ] 			= "blackout_kmr_stalling";
	// Captain Price, my men have run into heavy resistance. Help me support them from the cliffs.	
	level.scr_sound[ "kamarov" ][ "heavy_resistance" ] 			= "blackout_kmr_heavyresistance";
	// What about our informant? He's running out of time!	
	level.scr_sound[ "price" ][ "our_informant" ] 			= "blackout_pri_ourinformant";
	// Then help us! The further my men can get into this village, the closer we will be to securing your informant!	
	level.scr_sound[ "kamarov" ][ "then_help" ] 			= "blackout_kmr_thenhelpus";
	// Good! Now we are making progress. Follow me to the power station.	
	level.scr_sound[ "kamarov" ][ "making_progress" ] 			= "blackout_kmr_makingprogress";
	// Look. The final assault has already begun. With a little more of your sniper support we are sure to be victorious. Captain Price, I need to ask one more favor of you and your men - (gets cut off)	
	level.scr_sound[ "kamarov" ][ "final_assault" ] 			= "blackout_kmr_finalassault";
	// Enough sniping! Where is the informant?	
	level.scr_sound[ "gaz" ][ "enough_sniping" ] 			= "blackout_gaz_enoughsniping";
	// What are you doing - are you out of your mind? Who do you think you are you - (cut off by Gaz)	
	level.scr_sound[ "kamarov" ][ "russian_out_of_mind" ] 			= "blackout_kmr_outofmind";
	// What are you doing - are you out of your mind? Who do you think you are you - (cut off by Gaz)	
	level.scr_sound[ "kamarov" ][ "english_out_of_mind" ] 			= "blackout_kmr_areyououteng";
	// Where..IS he?	
	level.scr_sound[ "gaz" ][ "where_is" ] 			= "blackout_gaz_whereishe";
	// The house (cough)... the house at the northeast end of the village! 	
	level.scr_sound[ "kamarov" ][ "the_house" ] 			= "blackout_kmr_thehouse";
	// Well that wasn't so hard was it? Now go sit in the corner.	
	level.scr_sound[ "gaz" ][ "wasnt_that_hard" ] 			= "blackout_gaz_thatwasntsohard";
	// Soap, Gaz. We've got to reach that house before anything happens to the informant. Let's go!	
	level.scr_sound[ "price" ][ "reach_that_house" ] 			= "blackout_pri_reachthathouse";
	// Soap, get down here, move!	
	level.scr_sound[ "price" ][ "get_down_here" ] 			= "blackout_pri_getdownhere";
	
	//	Soap - plant some claymores in front of the door, then get their attention.	
	level.scr_sound[ "price" ][ "plant_claymore" ] 			= "blackout_gaz_plantsomeclaymores";

}