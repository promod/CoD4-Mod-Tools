#include maps\_anim;
#include maps\_utility;
#using_animtree("generic_human");

main()
{
	level.scr_model[ "tank_draw" ] = "vehicle_m1a1_abrams_drawing";
	precachemodel( getmodel( "tank_draw" ) );
	
	level.scr_anim[ "paulsen" ][ "melee" ]					= %bog_melee_R_defend;
	level.scr_sound[ "paulsen" ][ "melee" ]					= "bog_scn_melee_struggle";
	level.scr_sound[ "paulsen" ][ "melee_sound_stop" ]		= "bog_scn_melee_struggle_end";

	level.scr_anim[ "paulsen" ][ "back_death1" ]	= %bog_melee_R_backdeath1; // gets back up off the ground
	level.scr_anim[ "paulsen" ][ "back_death2" ]	= %bog_melee_R_backdeath2;
	level.scr_anim[ "paulsen" ][ "stand_death" ]	= %bog_melee_R_standdeath;
	addNotetrack_customFunction( "paulsen", "fire", maps\bog_a_code::paulsen_end_fire, "stand_death" );
	
	
	addNotetrack_customFunction( "paulsen", "end standdeath", maps\bog_a_code::paulsen_end_standDeath );
	addNotetrack_customFunction( "paulsen", "start backdeath1", maps\bog_a_code::paulsen_start_backDeath1 );
	addNotetrack_customFunction( "paulsen", "start backdeath2", maps\bog_a_code::paulsen_start_backDeath2 );

	level.scr_anim[ "price" ][ "tank_is_stuck" ]		= %bog_a_start_briefing;

	// Alpha Company's tank is stuck half a click north of here, let's go let's go!
	addNotetrack_sound( "price", "dialog", "tank_is_stuck", "bog_vsq_halfaclick" );
//	addNotetrack_flag( "price", "ambush", "alley_first_shot", "javelin_briefing" );

	thread saw_ac_unit();

	level.scr_anim[ "saw" ][ "setup" ] = %bog_a_saw_setup;
	level.scr_anim[ "saw" ][ "fire_loop" ][ 0 ]= %bog_a_saw_fire;
	addNotetrack_customFunction( "saw", "kick", maps\bog_a::kick_ac_unit );

	level.scr_anim[ "emslie" ][ "melee" ]		= %bog_melee_R_attack;
	level.scr_anim[ "emslie" ][ "melee_done" ]	= %pistol_stand_switch;
	level.scr_anim[ "emslie" ][ "death" ]	= %exposed_death_groin;

	level.scr_anim[ "generic" ][ "spin" ] = 			%combatwalk_F_spin;

	level.scr_anim[ "price" ][ "wait_approach" ]		= %bog_price_wait_idle_approach;
	level.scr_anim[ "price" ][ "wait_idle" ][ 0 ]		= %bog_price_wait_idle;
	level.scr_anim[ "price" ][ "wave1" ]				= %bog_price_wait_wave_A;
	level.scr_anim[ "price" ][ "wave2" ]				= %bog_price_wait_wave_B;

//	level.scr_anim[ "price" ][ "javelin_briefing" ]				= %bog_javelin_dialogue_briefing;
//	level.scr_anim[ "price" ][ "javelin_briefing_idle" ][ 0 ]	= %bog_javelin_dialogue_briefingidle;
	// UAV recon’s spotted enemy APCs headed this way! 
	// Private West, get on the roof and hit ‘em with the Javelin!
//	addNotetrack_dialogue( "price", "dialog", "javelin_briefing", "bog_pri_hitemwithjavelin" );
	level.scr_sound[ "price" ][ "javelin_briefing" ]				= "bog_vsq_hitemwithjavelin";
	
//	level.scr_anim[ "price" ][ "javelin_take" ]					= %bog_javelin_dialogue_takejavelin;

	level.scr_anim[ "javelin_guy" ][ "hangout_arrival" ]			= %bog_a_javelin_jog_2_idle;
	level.scr_anim[ "javelin_guy" ][ "hangout_idle" ][ 0 ]			= %bog_a_javelin_idle;
	level.scr_anim[ "javelin_guy" ][ "run" ]						= %bog_a_javelin_jog;
	level.scr_anim[ "javelin_guy" ][ "death" ]						= %bog_a_javelin_death; //exposed_crouch_death_fetal;

	level.scr_anim[ "generic" ][ "sprint" ]							= %sprint1_loop;
	level.scr_anim[ "price" ][ "sprint" ]								= %sprint1_loop;
	
	// right away s--"
	level.scr_sound[ "javelin_guy" ][ "right_away" ]				= "bog_gm2_rightaways_alt";

	// jackson! Pick up the Javelin! Get to the second floor and take out those APCs!!
	level.scr_sound[ "price" ][ "get_jav" ] 						= "bog_a_vsq_takeouttanks";

	// jackson! Pick up the Javelin and get to the second floor!! Move!!!
	level.scr_sound[ "price" ][ "jav_reminder_1" ] 					= "bog_vsq_javelinsecondfloormove";

	// jackson! Get to the second floor and take out those APCs!
	level.scr_sound[ "price" ][ "jav_reminder_2" ] 					= "bog_vsq_jacksonpickupjavelin";
	
/*
	level.scr_anim[ "third_floor_right_guy" ][ "door_breach" ]			= %explosivebreach_v1_detcord;
	level.scr_anim[ "third_floor_right_guy" ][ "door_breach_idle" ][0]	= %explosivebreach_v1_detcord_idle;
	level.scr_anim[ "third_floor_left_guy" ][ "door_breach" ]			= %explosivebreach_v1_stackL;
	level.scr_anim[ "third_floor_left_guy" ][ "door_breach_idle" ][0]	= %explosivebreach_v1_stackL_idle;
*/


	level.scr_anim[ "second_floor_right_guy" ][ "door_breach_setup" ]			= %shotgunbreach_v1_shoot_hinge;
	level.scr_anim[ "second_floor_right_guy" ][ "door_breach_setup_idle" ][0]	= %shotgunbreach_v1_shoot_hinge_idle;
	level.scr_anim[ "second_floor_right_guy" ][ "door_breach_idle" ][0]			= %shotgunbreach_v1_shoot_hinge_ready_idle;
	level.scr_anim[ "second_floor_right_guy" ][ "door_breach" ]					= %shotgunbreach_v1_shoot_hinge_runin;

	level.scr_anim[ "second_floor_left_guy" ][ "door_breach_setup" ]			= %shotgunbreach_v1_stackB;
	level.scr_anim[ "second_floor_left_guy" ][ "door_breach_setup_idle" ][0]	= %shotgunbreach_v1_stackB_idle;
	level.scr_anim[ "second_floor_left_guy" ][ "door_breach_idle" ][0]			= %shotgunbreach_v1_stackB_ready_idle;
	level.scr_anim[ "second_floor_left_guy" ][ "door_breach" ]					= %shotgunbreach_v1_stackB_runin;

	level.scr_anim[ "fence_guy1" ][ "fence_cut" ]		= %icbm_fence_cutting_guy1;
	level.scr_anim[ "fence_guy2" ][ "fence_cut" ]			= %icbm_fence_cutting_guy2;	

	addNotetrack_attach(  "fence_guy1", "can_in_hand", "com_spray_can01", "tag_inhand", "fence_cut" );
    precacheModel( "com_spray_can01" );

	
	//addNotetrack_detach( animname, notetrack, model, tag, anime )
	addNotetrack_detach( "fence_guy1", "can_out_hand", "com_spray_can01", "tag_inhand", "fence_cut" );
	
	//addNotetrack_animSound( animname, anime, notetrack, soundalias )
	addNotetrack_animSound( "fence_guy1", "fence_cut", "scn_icbm_fence_cut", "scn_bog_a_fence_cut" );
	addNotetrack_animSound( "fence_guy1", "fence_cut", "scn_icbm_fence_pull", "scn_bog_a_fence_pull" );
	
	//addNotetrack_customFunction( animname, notetrack, function, anime )
	addNotetrack_customFunction( "fence_guy1", "can_start_spray", ::spraycan_fx, "fence_cut" );
	addNotetrack_customFunction( "fence_guy1", "can_stop_spray", ::spraycan_fx_stop, "fence_cut" );


/*
- shotgunbreach_v1_shoot_hinge_ready_idle
- shotgunbreach_v1_shoot_hinge_runin
- shotgunbreach_v1_stackB_ready_idle
- shotgunbreach_v1_stackB_runin


- shotgunbreach_v1_shotgun_ready_idle
- shotgunbreach_v1_shotgun_runin
*/


	// move it! move it!
	level.scr_sound[ "generic" ][ "move_it" ]							= "bog_gm2_moveit";

	// Clear! Keep moving up!
	level.scr_sound[ "generic" ][ "keep_moving_up" ]					= "bog_gm3_clearkeepmoving";

	// Ambush!
	level.scr_sound[ "generic" ][ "ambush1" ]							= "bog_gm2_ambush1";

	// Ambush!
	level.scr_sound[ "generic" ][ "ambush2" ]							= "bog_gm2_ambush2";
	
	// Contact left!
	level.scr_sound[ "guy_two" ][ "contact_left" ]						= "bog_gm2_contactleft";

	// Contact right! Switch to night vision now!
	level.scr_sound[ "price" ][ "switch_to_night_vision" ]				= "bog_vsq_contactright";

	// Contact right! Contact right!
	level.scr_sound[ "generic" ][ "contact_right" ]						= "bog_gm1_contactright";


	// Get suppression fire on that building! We have to move forward!
	level.scr_sound[ "price" ][ "suppress_building" ]					= "bog_vsq_suppressionbuilding";
	
	// Keep moving forward!
	level.scr_sound[ "price" ][ "keep_moving" ]							= "bog_vsq_keepforward";
	
	// Alpha, let’s take the stairs and hit their flank! Bravo, give us covering fire!
	level.scr_sound[ "price" ][ "take_the_stairs" ]						= "bog_vsq_alphatakestairs";
	
	// Let’s go jackson, follow me!
	level.scr_sound[ "price" ][ "follow_me" ]							= "bog_vsq_letsgojackson";
	
	// Come on jackson, move it!
	level.scr_sound[ "price" ][ "move_it" ]								= "bog_vsq_comeonjackson";
	
	// jackson! This way!
	level.scr_sound[ "price" ][ "this_way" ]							= "bog_vsq_jacksonthisway";
	
	// jackson, you and Roycewicz head upstairs. We’ll cover this entrance. Go!
	level.scr_sound[ "price" ][ "head_upstairs" ]						= "bog_vsq_jacksonheadupstairs";
	
	
	// Hit their flank with their machine gun!
	level.scr_sound[ "price" ][ "hit_their_flank" ]						= "bog_vsq_hittheirflank";
	
	// jackson, use their machine gun!
	level.scr_sound[ "price" ][ "use_their_gun" ]						= "bog_vsq_usemachinegun";
	
	// Cut ‘em down!! Shoot ‘em through the wall!!!
	level.scr_sound[ "price" ][ "shoot_through_wall" ]					= "bog_vsq_cutemdown";
	
	// Good job!
	level.scr_sound[ "price" ][ "good_job" ]							= "bog_vsq_goodjob";

	// All right let’s move out!
	level.scr_sound[ "price" ][ "move_out" ]							= "bog_vsq_letsmoveout";


	// Squad! This way! Let's go!! We'll flank them from the right!
	level.scr_sound[ "price" ][ "flank_right" ]							= "bog_vsq_squadthisway";

	// jackson! Paulsen! Secure the upper floors! We'll give you covering fire! Move!!!
	level.scr_sound[ "price" ][ "secure_the_upper_floors" ]				= "bog_vsq_gowithsgtpaulsen";

	// Clear!
	level.scr_sound[ "second_floor_left_guy" ][ "clear" ]				= "bog_gm1_clear";

	// Clear!
	level.scr_sound[ "second_floor_right_guy" ][ "clear" ]				= "bog_gm2_clear1";

	// Clear!
	level.scr_sound[ "third_floor_left_guy" ][ "clear" ]				= "bog_gm2_clear2";

	// Clear!
	level.scr_sound[ "third_floor_right_guy" ][ "clear" ]				= "bog_gm2_clear3";

	// There's more holed upon the next floor! Keep moving!!
	level.scr_sound[ "guy_one" ][ "more_holed_up" ]						= "bog_gm1_moreholedup";

	// Second squad coming back down the stairs, hold your fire!
	level.scr_sound[ "guy_three" ][ "coming_back_down" ]				= "bog_gm3_secondsquad";

	// Roger that!
	level.scr_sound[ "price" ][ "roger_that" ]							= "bog_gm2_rogerthat";

	// Roger that, we're working on it! Out!
	level.scr_sound[ "price" ][ "working_on_it" ]						= "bog_vsq_workingonit";
	

	// Three coming out!
	level.scr_sound[ "second_floor_left_guy" ][ "three_coming_out" ]	= "bog_gm1_threecomin";

	// Squad regroup!
	level.scr_sound[ "price" ][ "squad_regroup" ]						= "bog_vsq_squadregroup";

	// Contact on the overpass!
	level.scr_sound[ "guy_one" ][ "contact_overpass" ]					= "bog_gm1_contactoverpass";

	// jackson, Rusedski, get on the roof! Go!
	level.scr_sound[ "price" ][ "get_on_the_roof" ]						= "bog_vsq_skigettoroof";

	// jackson! I've got the Javelin! Let's go!
	level.scr_sound[ "guy_two" ][ "got_the_javelin"	]					= "bog_gm2_ivegotjavelin";
	
	// jackson! Pick up the Javelin so you can take out those tanks!
	level.scr_sound[ "price" ][ "pickup_hint_1" ]						= "bog_a_vsq_takeouttanks";
	
	// jackson! Pick up the Javelin, NOW!
	level.scr_sound[ "price" ][ "pickup_hint_2" ]						= "bog_a_vsq_pickupjavnow";
	
	// jackson! Pick up the Javelin!
	level.scr_sound[ "price" ][ "pickup_hint_3" ]						= "bog_a_vsq_pickupjav";
	
	// jackson! Get to the second floor and take out those tanks!
	level.scr_sound[ "price" ][ "second_floor_hint_1" ]					= "bog_a_vsq_secondfloor";
	
	// Hit those targets at the far end of the bridge! Hurry!
	level.scr_sound[ "price" ][ "second_floor_hint_2" ]					= "bog_gm1_vehiclesbridge";
	
	// Right away s--
	level.scr_sound[ "price" ][ "right_away_s" ]						= "bog_gm2_rightaways";

	// We're on the second floor! Watch your fire!
	level.scr_sound[ "price" ][ "watch_your_fire" ]					= "bog_pls_onsecondfloor";

	// Gah!
	level.scr_sound[ "paulsen" ][ "gah" ]								= "bog_pls_gah";
	

	// Shoot him! Shoot him!
	level.scr_sound[ "paulsen" ][ "shoot_him" ]							= "bog_pls_shoothim";

	// Thanks jackson
	level.scr_sound[ "paulsen" ][ "thanks_jackson" ]						= "bog_pls_thanksjackson";



	// Sir! There's a ton of them out there!!
	level.scr_sound[ "saw" ][ "ton_of_them" ]							= "bog_ems_tonofem";

	// Shut up and keep them pinned down!
	level.scr_sound[ "price" ][ "shut_up" ]								= "bog_vsq_shutup";

	// Roger that! Suppressing fire!
	level.scr_sound[ "saw" ][ "suppressing_fire" ]						= "bog_ems_suppressingfire";







	// ************************************************************************************
	// RADIO
	// ************************************************************************************

	// Shifting fire!
	level.scr_radio[ "shifting_fire" ]						= "bog_gm2_shiftingfire";
	
	// Be advised, more enemy troops are converging on the tank. Recommend you get there ASAP!
	level.scr_radio[ "get_there_asap" ]						= "bog_hqr_moreenemytroops";

	// We're coming in from the south, hold your fire!
	level.scr_radio[ "coming_from_south" ]					= "bog_vsq_cominginfromsouth";

	// Switching off night vision
	level.scr_radio[ "switch_off_nightvision" ]				= "bog_gm1_offnightvision";

	// Roger that! We could really use your help for taking out the enemy mortarsin the buildings to the west!
	level.scr_radio[ "could_use_help" ]						= "bog_gm3_rogerthat";

	// Hit those targets at the far end of the bridge, hurry!
	level.scr_sound[ "generic" ][ "hit_vehicles" ] 			= "bog_gm2_hitvehicles";

	// Backblast area clear! Fire!
	level.scr_sound[ "generic" ][ "backblast_clear" ]		= "bog_gm2_backblastclear";

	// Target destroyed!
	level.scr_sound[ "generic" ][ "hit_target_1" ]	 		= "bog_gm2_targetdestroyed";

	// Nice one!
	level.scr_sound[ "generic" ][ "hit_target_2" ] 			= "bog_gm2_niceone";

	// Good shot man!
	level.scr_sound[ "generic" ][ "hit_target_3" ]		 	= "bog_gm2_goodshotman";

	// Ok that’s the last of ‘em.	
	level.scr_sound[ "generic" ][ "hit_target_4" ]			= "bog_gm2_lastofem";

	// Bravo Six we’re taking heavy fire on our position north of the overpass! Where the hell are you?!
	level.scr_radio[ "where_are_you" ]								= "bog_gm3_bravosix";

	// We’re almost there! Hang on!
	level.scr_sound[ "price" ][ "almost_there" ]					= "bog_vsq_almostthere";

	// The tank’s on the other side of that overpass! Come on - let’s get back to the squad!
	level.scr_sound[ "generic" ][ "other_side" ]					= "bog_gm2_tanksotherside";

	// This way let’s go!
	level.scr_sound[ "price" ][ "this_way" ]						= "bog_vsq_thiswayletsgo";

	
	door_setup();
	animated_model_setup();
	script_models();
}


#using_animtree( "ac" );
saw_ac_unit()
{

	level.scr_anim[ "ac" ][ "setup" ] = %bog_a_ac_falldown;
	level.scr_animtree[ "ac" ] = #animtree;	
//	level.scr_model[ "door" ] = "com_door_01_handleright";
//	precachemodel( level.scr_model[ "door" ] );
	
}


	
/*	
bog_plt_seeanyoneleft


bog_gm1_letsgo




bog_gm1_oorah


bog_gm2_jacksonletsgo





bog_gm2_oorah

bog_gm3_rpg
bog_gm3_clear
bog_gm3_allclear
bog_gm3_bravosix

bog_gm3_oorah

bog_hqr_enemyaircraft
bog_hqr_goodworkout

bog_plt_standby
bog_plt_positiveid
bog_cop_negative
bog_plt_alltargetsdestroyed




bog_pri_sweepthearea



bog_pri_keepeyeopen

bog_pri_keepofftank
bog_pri_antiaircraftguntakeout
bog_pri_vampiresixfour
bog_pri_lzissecure
bog_pri_regroupattank
bog_pri_donthavemuchtime
bog_pri_allrightmoveout
*/	

//	level.scr_anim[ "right_guy" ][ "wave" ]					= %cqb_stand_wave_go_v1;

//	level.scr_anim[ "miller" ][ "door_hang" ]			= %shotgunbreach_v1_stackB_idle;
	//level.scr_anim[ "miller" ][ "door_hang_idle" ][0]	= %shotgunbreach_v1_stackB_idle;
	
	/*
	level.scr_sound[ "black" ][ "save_m1a1" ]			= "bog_co_save_m1a1";
	level.scr_sound[ "black" ][ "off_the_street" ]		= "bog_co_off_the_street";
	level.scr_sound[ "black" ][ "bang_doors" ]			= "bog_co_bang_some_doors";
	level.scr_sound[ "black" ][ "night_vision" ]		= "bog_co_night_vision";
	level.scr_sound[ "black" ][ "go_around_back" ]		= "bog_co_go_around_back";
	level.scr_sound[ "black" ][ "emslie" ]				= "bog_co_emslie";
	*/
	
//	level.scr_sound[ "miller" ][ "no_shot" ]			= "bog_miller_cant_get_a_shot";

//	level.scr_sound[ "emslie" ][ "yes_sir" ]			= "bog_emslie_yes_sir";

//	level.scr_radio[ "rooftop_movement" ] 		= "bog_cobra_rooftop_movement";
//	level.scr_radio[ "in_persuit" ] 			= "bog_cobra_in_pursuit";
//	level.scr_radio[ "permission_granted" ] 	= "bog_hq_permission_granted";



#using_animtree ("animated_props");
animated_model_setup()
{
	level.anim_prop_models[ "foliage_tree_palm_bushy_2" ][ "still" ] = %palmtree_bushy2_still;
	level.anim_prop_models[ "foliage_tree_palm_bushy_2" ][ "strong" ] = %palmtree_bushy2_sway;
	level.anim_prop_models[ "foliage_tree_palm_bushy_1" ][ "still" ] = %palmtree_bushy1_still;
	level.anim_prop_models[ "foliage_tree_palm_bushy_1" ][ "strong" ] = %palmtree_bushy1_sway;
}



#using_animtree( "door" );
door_setup()
{
//	level.scr_anim[ "door" ][ "door_breach" ] = 	%shotgunbreach_v1_shoot_hinge_door;
	level.scr_anim[ "door" ][ "door_breach" ] = 	%shotgunbreach_door_immediate;
//	level.scr_anim[ "door" ][ "door_breach" ] = 	%explosivebreach_v1_door;
	
	level.scr_animtree[ "door" ] = #animtree;	
	level.scr_model[ "door" ] = "com_door_01_handleleft2";
//	level.scr_model[ "door" ] = "com_door_01_handleleft";
	precachemodel( level.scr_model[ "door" ] );
}

#using_animtree( "script_model" );
script_models()
{
	level.scr_animtree[ "fence" ]						= #animtree;
	level.scr_anim[ "fence" ][ "fence_cut" ]			= %icbm_fence_cutting_guy1_fence;
	level.scr_model[ "fence" ]							= "icbm_fence_cut";
	precacheModel( getmodel( "fence" ) );
}

spraycan_fx( guy )
{
	level endon( "stop_spray_fx" );
	level endon( "death" );
	while ( true )
	{
		playfxontag( getfx( "freezespray" ), guy, "tag_spraycan_fx" );
		wait .1;	
	}
}

spraycan_fx_stop( empty )
{
	level notify( "stop_spray_fx" );
}