#include common_scripts\utility;
#include maps\_utility;
#include maps\_anim;

main()
{
	anim_human();
	anim_playerview();
	anim_vehicles();
	anim_door();
	anim_trashcan();
	anim_dumpster();
	anim_props();
	anim_chickens();
	anim_dogs();
}

#using_animtree( "player" );
anim_playerview()
{
	level.scr_animtree[ "playerview" ] 							 	 = #animtree;
	level.scr_model[ "playerview" ] 							 	 = "viewhands_player_usmc";
	level.scr_anim[ "playerview" ][ "intro" ]					 	 = %coup_opening_playerview;
	level.scr_anim[ "playerview" ][ "car_idle" ][ 0 ]			 	 = %coup_opening_playerview_idle;
	level.scr_anim[ "playerview" ][ "car_idle_firstframe" ]		 	 = %coup_opening_playerview_idle;
	level.scr_anim[ "playerview" ][ "carexit" ]				 	 	 = %coup_ending_drag_playerview;
	level.scr_anim[ "playerview" ][ "endtaunt" ]					 = %coup_ending_zakhaev_intro_playerview;
	level.scr_anim[ "playerview" ][ "ending" ]			 		 	 = %coup_ending_player;
                                                                 		 
	level.scr_anim[ "playerview" ][ "playerview_idle_normal" ]	 	 = %coup_opening_playerview_idle_normal;
	level.scr_anim[ "playerview" ][ "playerview_idle_smooth" ]	 	 = %coup_opening_playerview_idle_smooth;
	level.scr_anim[ "playerview" ][ "playerview_idle_bumpy" ]	 	 = %coup_opening_playerview_idle_bumpy;
	level.scr_anim[ "playerview" ][ "playerview_idle_static" ]	 	 = %coup_opening_playerview_idle_static;
	
	// addNotetrack_customFunction( animname, notetrack, function, anime )
	addNotetrack_customFunction( "playerview", "throw_in_car", ::playerThrownInCar, "intro" );
	addNotetrack_customFunction( "playerview", "hit", ::playerHit, "intro" );
	addNotetrack_customFunction( "playerview", "pulled_from_car", ::playerPulledFromCar, "carexit" );
	addNotetrack_customFunction( "playerview", "kick", ::playerKicked, "carexit" );
}

#using_animtree( "generic_human" );
anim_human()
{
	// merge into this animname when possible
	level.scr_animtree[ "human" ]						 	 		 = #animtree;
	level.scr_anim[ "human" ][ "stand_and_crouch" ]					 = %stand_and_crouch;
	
	level.scr_anim[ "human" ][ "cardriver_idle" ][ 0 ]				 = %coup_driver_idle;
	level.scr_anim[ "human" ][ "cardriver_bigleft2center" ]	 		 = %coup_driver_bigleft2center;
	level.scr_anim[ "human" ][ "cardriver_bigleft_idle" ][ 0 ] 		 = %coup_driver_bigleft_idle;
	level.scr_anim[ "human" ][ "cardriver_bigleftloop" ] 			 = %coup_driver_bigleft_loop;
	level.scr_anim[ "human" ][ "cardriver_center2smallleft" ]		 = %coup_driver_center2smallleft;
	level.scr_anim[ "human" ][ "cardriver_center2smallright" ] 		 = %coup_driver_center2smallright;
	level.scr_anim[ "human" ][ "cardriver_lookright" ]	 	 		 = %coup_driver_lookright;
	level.scr_anim[ "human" ][ "cardriver_smallleft2bigleft" ] 		 = %coup_driver_smallleft2bigleft;
	level.scr_anim[ "human" ][ "cardriver_smallleft2center" ]		 = %coup_driver_smallleft2center;
	level.scr_anim[ "human" ][ "cardriver_smallleft_idle" ][ 0 ]	 = %coup_driver_smallleft_idle;
	level.scr_anim[ "human" ][ "cardriver_smallright2center" ] 		 = %coup_driver_smallright2center;
	level.scr_anim[ "human" ][ "cardriver_smallright_idle" ][ 0 ]	 = %coup_driver_smallright_idle;
	level.scr_anim[ "human" ][ "cardriver_wave1" ]			 		 = %coup_driver_wave1;
	level.scr_anim[ "human" ][ "cardriver_wave2" ]			 		 = %coup_driver_wave2;

	level.scr_anim[ "human" ][ "carpassenger_idle" ][ 0 ]			 = %coup_passenger_idle;
	level.scr_anim[ "human" ][ "carpassenger_phone" ]				 = %coup_passenger_phone;
	level.scr_anim[ "human" ][ "carpassenger_point" ]				 = %coup_passenger_point;
	level.scr_anim[ "human" ][ "carpassenger_pointturn" ]			 = %coup_passenger_pointturn;
	level.scr_anim[ "human" ][ "carpassenger_lookback" ]			 = %coup_passenger_lookback;
	level.scr_anim[ "human" ][ "carpassenger_lookright" ]			 = %coup_passenger_lookright;
	level.scr_anim[ "human" ][ "carpassenger_shiftweight" ]	 		 = %coup_passenger_shiftweight;

	level.scr_anim[ "human" ][ "intro_leftguard" ]			 		 = %coup_opening_guyL;
	level.scr_anim[ "human" ][ "intro_rightguard" ]			 		 = %coup_opening_guyR;
	level.scr_anim[ "human" ][ "carexit_leftguard" ]				 = %coup_ending_drag_guyL;
	level.scr_anim[ "human" ][ "carexit_rightguard" ]				 = %coup_ending_drag_guyR;
	level.scr_anim[ "human" ][ "close_garage_a" ]	 				 = %unarmed_close_garage;
	level.scr_anim[ "human" ][ "close_garage_b" ]	 				 = %unarmed_close_garage_v2;
	level.scr_anim[ "human" ][ "window_shout_a" ]	 				 = %unarmed_shout_window;
	level.scr_anim[ "human" ][ "window_shout_b" ]					 = %unarmed_shout_window_v2;
	level.scr_anim[ "human" ][ "leaning_smoking_idle" ][ 0 ]		 = %parabolic_leaning_guy_smoking_idle;
	level.scr_anim[ "human" ][ "radio" ]							 = %casual_stand_v2_twitch_radio;
	level.scr_anim[ "human" ][ "talkingguards_leftguard" ]			 = %coup_talking_patrol_guy1;
	level.scr_anim[ "human" ][ "talkingguards_rightguard" ]			 = %coup_talking_patrol_guy2;
	level.scr_anim[ "human" ][ "ending_leftguard" ]					 = %coup_ending_guyL;
	level.scr_anim[ "human" ][ "ending_rightguard" ] 				 = %coup_ending_guyR;
	level.scr_anim[ "human" ][ "ending_alasad" ]	 				 = %coup_ending_alasad;
	level.scr_anim[ "human" ][ "ending_zakhaev" ] 					 = %coup_ending_zakhaev;
	level.scr_anim[ "human" ][ "endtaunt" ]							 = %coup_ending_zakhaev_intro;
	level.scr_anim[ "human" ][ "ziptie_civilian_idle" ][ 0 ]		 = %ziptie_suspect_idle;
	level.scr_anim[ "human" ][ "crowdmember_gunup_idle" ]	 		 = %coup_guard1_idle;
	level.scr_anim[ "human" ][ "crowdmember_gunup_fire" ]	 		 = %coup_guard1_jeer;
	level.scr_anim[ "human" ][ "crowdmember_gundown_idle" ]	 		 = %coup_guard2_idle;
	level.scr_anim[ "human" ][ "crowdmember_gundown_jeer" ]	 		 = %coup_guard2_jeera;
	level.scr_anim[ "human" ][ "crowdmember_gundown_fire_a" ]		 = %coup_guard2_jeerb;
	level.scr_anim[ "human" ][ "crowdmember_gundown_fire_b" ]		 = %coup_guard2_jeerc;	
	level.scr_anim[ "human" ][ "run_panicked1" ] 					 = %unarmed_panickedrun_loop_V1;
	level.scr_anim[ "human" ][ "run_panicked2" ] 					 = %unarmed_panickedrun_loop_V2;
	level.scr_anim[ "human" ][ "runinto_garage_left" ]	  			 = %unarmed_runinto_garage_left;
	level.scr_anim[ "human" ][ "runinto_garage_right" ]	 			 = %unarmed_runinto_garage_right;
	level.scr_anim[ "human" ][ "spraypainting" ]					 = %coup_spraypainting_sequence;
	level.scr_anim[ "human" ][ "trash_stumble" ]					 = %unarmed_stumble_trashcan;
	level.scr_anim[ "human" ][ "wall_climb" ]						 = %unarmed_climb_wall_v2;
	level.scr_anim[ "human" ][ "sneakattack_attack_side" ]			 = %melee_L_attack;
	level.scr_anim[ "human" ][ "sneakattack_defend_side" ]			 = %melee_L_defend;
	level.scr_anim[ "human" ][ "sneakattack_attack_behind" ]		 = %melee_B_attack;
	level.scr_anim[ "human" ][ "sneakattack_defend_behind" ]	 	 = %melee_B_defend;
	level.scr_anim[ "human" ][ "patrol_walk" ]					 	 = %patrol_bored_patrolwalk;
	level.scr_anim[ "human" ][ "aim_straight" ][ 0 ]			 	 = %stand_aim_straight;
	level.scr_anim[ "human" ][ "cowerstand_idle" ][ 0 ]			 	 = %unarmed_cowerstand_idle;
	level.scr_anim[ "human" ][ "cowerstand_pointidle" ][ 0 ] 	 	 = %unarmed_cowerstand_pointidle;
	level.scr_anim[ "human" ][ "cowerstand_point_to_idle" ]		 	 = %unarmed_cowerstand_point2idle;
	level.scr_anim[ "human" ][ "cowerstand_idle_to_point" ]		 	 = %unarmed_cowerstand_idle2point;
	level.scr_anim[ "human" ][ "cowerstand_react" ]	 			 	 = %unarmed_cowerstand_react;
	level.scr_anim[ "human" ][ "cowerstand_react_to_crouch" ]	 	 = %unarmed_cowerstand_react_2_crouch;
	level.scr_anim[ "human" ][ "cowercrouch_idle" ][ 0 ]		 	 = %unarmed_cowercrouch_idle;
	level.scr_anim[ "human" ][ "cowercrouch_idle_duck" ] 		 	 = %unarmed_cowercrouch_idle_duck;
	level.scr_anim[ "human" ][ "cowercrouch_react_a" ] 			 	 = %unarmed_cowercrouch_react_A;
	level.scr_anim[ "human" ][ "cowercrouch_react_b" ] 			 	 = %unarmed_cowercrouch_react_B;
	level.scr_anim[ "human" ][ "cowercrouch_to_stand" ]			 	 = %unarmed_cowercrouch_crouch_2_stand;
	level.scr_anim[ "human" ][ "ziptie_guard" ]					 	 = %ziptie_soldier;
	level.scr_anim[ "human" ][ "ziptie_civilian" ]				 	 = %ziptie_suspect;
	level.scr_anim[ "human" ][ "doorkick_left_idle" ]			 	 = %shotgunbreach_v1_shoot_hinge_idle;
	level.scr_anim[ "human" ][ "doorkick_left_stepout" ]		 	 = %shotgunbreach_v1_shoot_hinge;
	level.scr_anim[ "human" ][ "doorkick_left_runin" ]			 	 = %shotgunbreach_v1_shoot_hinge_runin;
	level.scr_anim[ "human" ][ "doorkick_right_idle" ]			 	 = %shotgunbreach_v1_stackB_idle;
	level.scr_anim[ "human" ][ "doorkick_right_stepout_runin" ]	 	 = %shotgunbreach_v1_stackB;
	level.scr_anim[ "human" ][ "carjack_victim" ]				 	 = %ac130_carjack_driver_1a;
	level.scr_anim[ "human" ][ "carjack_driver" ]				 	 = %ac130_carjack_1a;
	level.scr_anim[ "human" ][ "carjack_frontright" ]			 	 = %ac130_carjack_2;
	level.scr_anim[ "human" ][ "carjack_backright" ]			 	 = %ac130_carjack_3;
	level.scr_anim[ "human" ][ "carjack_backleft" ]				 	 = %ac130_carjack_4;
	level.scr_anim[ "human" ][ "stand_idle" ][ 0 ]				 	 = %casual_stand_idle;
	level.scr_anim[ "human" ][ "dumpster_open" ]					 = %coup_dumpster_man;
	level.scr_anim[ "human" ][ "interrogation_suspect_a" ]			 = %coup_civilians_interrogated_civilian_v1;
	level.scr_anim[ "human" ][ "interrogation_suspect_b" ]			 = %coup_civilians_interrogated_civilian_v2;
	level.scr_anim[ "human" ][ "interrogation_suspect_c" ]			 = %coup_civilians_interrogated_civilian_v3;
	level.scr_anim[ "human" ][ "interrogation_suspect_d" ]			 = %coup_civilians_interrogated_civilian_v4;
	level.scr_anim[ "human" ][ "interrogation_guard_a" ]			 = %coup_civilians_interrogated_guard_v1;
	level.scr_anim[ "human" ][ "interrogation_guard_b" ]			 = %coup_civilians_interrogated_guard_v2;
	//level.scr_anim[ "human" ][ "interrogation_guard_wave" ]			 = %coup_civilians_interrogated_guard_wave;

	level.scr_animtree[ "generic" ]							 	 	 = #animtree;
	level.scr_anim[ "generic" ][ "patrol_walk" ]					 = %patrol_bored_patrolwalk;
	level.scr_anim[ "generic" ][ "patrol_walk_twitch" ]				 = %patrol_bored_patrolwalk_twitch;
	level.scr_anim[ "generic" ][ "patrol_stop" ]					 = %patrol_bored_walk_2_bored;
	level.scr_anim[ "generic" ][ "patrol_start" ]					 = %patrol_bored_2_walk;
	level.scr_anim[ "generic" ][ "patrol_turn180" ]					 = %patrol_bored_2_walk_180turn;
	level.scr_anim[ "generic" ][ "patrol_idle_1" ]					 = %patrol_bored_idle;
	level.scr_anim[ "generic" ][ "patrol_idle_2" ]					 = %patrol_bored_idle_smoke;
	level.scr_anim[ "generic" ][ "patrol_idle_3" ]					 = %patrol_bored_idle_cellphone;
	level.scr_anim[ "generic" ][ "patrol_idle_4" ]					 = %patrol_bored_twitch_bug;
	level.scr_anim[ "generic" ][ "patrol_idle_5" ]					 = %patrol_bored_twitch_checkphone;
	level.scr_anim[ "generic" ][ "patrol_idle_6" ]					 = %patrol_bored_twitch_stretch;
	level.scr_anim[ "generic" ][ "patrol_idle_smoke" ]				 = %patrol_bored_idle_smoke;
	level.scr_anim[ "generic" ][ "patrol_idle_checkphone" ]			 = %patrol_bored_twitch_checkphone;
	level.scr_anim[ "generic" ][ "patrol_idle_stretch" ]			 = %patrol_bored_twitch_stretch;
	level.scr_anim[ "generic" ][ "patrol_idle_phone" ]				 = %patrol_bored_idle_cellphone;

	// sneak attack rag doll deaths
	addNotetrack_customFunction( "human", "melee", ::melee_kill, "sneakattack_attack_side" );
	addNotetrack_customFunction( "human", "no death", ::rag_doll_death, "sneakattack_defend_side" );
	addNotetrack_customFunction( "human", "end", ::kill_self, "sneakattack_defend_side" );

	addNotetrack_customFunction( "human", "melee", ::melee_kill, "sneakattack_attack_behind" );
	addNotetrack_customFunction( "human", "no death", ::rag_doll_death, "sneakattack_defend_behind" );
	addNotetrack_customFunction( "human", "end", ::kill_self, "sneakattack_defend_behind" );

	// addNotetrack_attach / detach( animname, notetrack, model, tag, anime )
	addNotetrack_detach( "human", "detach gun", "weapon_desert_eagle_silver_HR_promo", "tag_inhand", "ending_zakhaev" );
	addNotetrack_attach( "human", "attach gun", "weapon_desert_eagle_silver_HR_promo", "tag_inhand", "ending_alasad" );
	addNotetrack_attach( "human", "attach_cellphone", "com_cellphone_on", "tag_inhand", "carpassenger_phone" );
	addNotetrack_detach( "human", "detach_cellphone", "com_cellphone_on", "tag_inhand", "carpassenger_phone" );
	
	// addNotetrack_customFunction( animname, notetrack, function, anime )
	addNotetrack_customFunction( "human", "fire_renamed", ::crowdFireWeapon, "crowdmember_gunup_fire" );
	addNotetrack_customFunction( "human", "fire_renamed", ::crowdFireWeapon, "crowdmember_gundown_fire_a" );
	addNotetrack_customFunction( "human", "fire_renamed", ::crowdFireWeapon, "crowdmember_gundown_fire_b" );
	addNotetrack_customFunction( "human", "door_close", ::passengerLookBack, "intro_leftguard" );
	addNotetrack_customFunction( "human", "door_close", ::ambientCarInterior, "intro_leftguard" );
	addNotetrack_customFunction( "human", "door_open", ::ambientCarExterior, "carexit_leftguard" );
	addNotetrack_customFunction( "human", "fire_gun", ::playerDeath, "ending_alasad" );
}

#using_animtree( "vehicles" );
anim_vehicles()
{
	level.scr_animtree[ "car" ] 							 = #animtree;
	level.scr_model[ "car" ] 								 = "vehicle_luxurysedan_viewmodel";

	level.scr_anim[ "car" ][ "intro" ]						 = %coup_opening_car;
	level.scr_anim[ "car" ][ "coup_car_driving" ]			 = %coup_opening_car_driving;
	level.scr_anim[ "car" ][ "car_idle_normal" ]			 = %coup_opening_car_driving_idle_normal;
	level.scr_anim[ "car" ][ "car_idle_smooth" ]			 = %coup_opening_car_driving_idle_smooth;
	level.scr_anim[ "car" ][ "car_idle_bumpy" ]				 = %coup_opening_car_driving_idle_bumpy;
	level.scr_anim[ "car" ][ "car_idle_static" ]			 = %coup_opening_car_driving_idle_static;
	level.scr_anim[ "car" ][ "carexit" ]					 = %coup_ending_drag_cardoor;

	level.scr_anim[ "car" ][ "wheel_bigleft2center" ]		 = %coup_driver_bigleft2center_car;
	level.scr_anim[ "car" ][ "wheel_bigleft_idle" ]			 = %coup_driver_bigleft_idle_car;
	level.scr_anim[ "car" ][ "wheel_bigleftloop_idle" ]		 = %coup_driver_bigleftloop_idle_car;
	level.scr_anim[ "car" ][ "wheel_bigleftloop" ]			 = %coup_driver_bigleft_loop_car;
	level.scr_anim[ "car" ][ "wheel_bigleftloop2center" ]	 = %coup_driver_bigleftloop2center_car;
	level.scr_anim[ "car" ][ "wheel_center2smallleft" ]		 = %coup_driver_center2smallleft_car;
	level.scr_anim[ "car" ][ "wheel_center2smallright" ]	 = %coup_driver_center2smallright_car;
	level.scr_anim[ "car" ][ "wheel_idle" ]					 = %coup_driver_idle_car;
	level.scr_anim[ "car" ][ "wheel_smallleft2bigleft" ]	 = %coup_driver_smallleft2bigleft_car;
	level.scr_anim[ "car" ][ "wheel_smallleft2center" ]	 	 = %coup_driver_smallleft2center_car;
	level.scr_anim[ "car" ][ "wheel_smallleft_idle" ]		 = %coup_driver_smallleft_idle_car;
	level.scr_anim[ "car" ][ "wheel_smallright2center" ]	 = %coup_driver_smallright2center_car;
	level.scr_anim[ "car" ][ "wheel_smallright_idle" ]	 	 = %coup_driver_smallright_idle_car;
	
	level.scr_animtree[ "uaz" ] 							 = #animtree;
	level.scr_anim[ "uaz" ][ "carjack_driver_door" ] 	 	 = %ac130_carjack_door_1a;
	level.scr_anim[ "uaz" ][ "carjack_others_door" ] 	 	 = %ac130_carjack_door_others;

	// addNotetrack_customFunction( animname, notetrack, function, anime )
	addNotetrack_customFunction( "car", "idle_normal_start", ::car_normal, "coup_car_driving" );
	addNotetrack_customFunction( "car", "idle_smooth_start", ::car_smooth, "coup_car_driving" );
	addNotetrack_customFunction( "car", "idle_bumpy_start", ::car_bumpy, "coup_car_driving" );
	addNotetrack_customFunction( "car", "idle_static_start", ::car_static, "coup_car_driving" );
	
	// turn events
	addNotetrack_customFunction( "car", "turnright_1", ::driver_turnright1, "coup_car_driving" );
	addNotetrack_customFunction( "car", "turnleft_1", ::driver_turnleft1, "coup_car_driving" );
	addNotetrack_customFunction( "car", "turnleft_2", ::driver_turnleft2, "coup_car_driving" );
	addNotetrack_customFunction( "car", "turnleft_3", ::driver_turnleft3, "coup_car_driving" );
	addNotetrack_customFunction( "car", "turnleft_1_special", ::driver_turnspecial, "coup_car_driving" );
}

#using_animtree( "door" );
anim_door()
{
	level.scr_animtree[ "door" ]							 = #animtree;	
	level.scr_anim[ "door" ][ "doorkick" ]					 = %shotgunbreach_door_immediate;
	level.scr_model[ "door" ]								 = "com_door_01_handleright";
}

#using_animtree( "trash_can" );
anim_trashcan()
{
	level.scr_animtree[ "trashcan_rig" ]					 = #animtree;
	level.scr_model[ "trashcan_rig" ]						 = "prop_rig";
	level.scr_anim[ "trashcan_rig" ][ "trash_stumble" ]		 = %prop_stumble_trashcan;
}


#using_animtree( "script_model" );
anim_dumpster()
{
	level.scr_animtree[ "dumpster" ]						 = #animtree;
	level.scr_anim[ "dumpster" ][ "dumpster_open" ]			 = %coup_dumpster_lid;
}

#using_animtree( "animated_props" );
anim_props()
{
	level.anim_prop_models[ "foliage_tree_palm_bushy_2" ][ "still" ]	 = %palmtree_bushy2_still;
	level.anim_prop_models[ "foliage_tree_palm_bushy_2" ][ "strong" ]	 = %palmtree_bushy2_sway;
	level.anim_prop_models[ "foliage_tree_palm_bushy_1" ][ "still" ]	 = %palmtree_bushy1_still;
	level.anim_prop_models[ "foliage_tree_palm_bushy_1" ][ "strong" ]	 = %palmtree_bushy1_sway;
	level.anim_prop_models[ "foliage_tree_palm_bushy_3" ][ "still" ]	 = %palmtree_bushy3_still;
	level.anim_prop_models[ "foliage_tree_palm_bushy_3" ][ "strong" ]	 = %palmtree_bushy3_sway;
	level.anim_prop_models[ "foliage_tree_palm_med_2" ][ "still" ]		 = %palmtree_med2_still;
	level.anim_prop_models[ "foliage_tree_palm_med_2" ][ "strong" ]		 = %palmtree_med2_sway;
	level.anim_prop_models[ "foliage_tree_palm_med_1" ][ "still" ]		 = %palmtree_med1_still;
	level.anim_prop_models[ "foliage_tree_palm_med_1" ][ "strong" ]		 = %palmtree_med1_sway;
	level.anim_prop_models[ "foliage_tree_palm_tall_1" ][ "still" ]		 = %palmtree_tall1_still;
	level.anim_prop_models[ "foliage_tree_palm_tall_1" ][ "strong" ]	 = %palmtree_tall1_sway;
	level.anim_prop_models[ "foliage_tree_palm_tall_3" ][ "still" ]		 = %palmtree_tall3_still;
	level.anim_prop_models[ "foliage_tree_palm_tall_3" ][ "strong" ]	 = %palmtree_tall3_sway;
	level.anim_prop_models[ "foliage_tree_palm_tall_2" ][ "still" ]		 = %palmtree_tall2_still;
	level.anim_prop_models[ "foliage_tree_palm_tall_2" ][ "strong" ]	 = %palmtree_tall2_sway;
}

#using_animtree( "chicken" );
anim_chickens()
{
	level.scr_animtree[ "chicken" ] 				 = #animtree;
	level.scr_model[ "chicken" ] 					 = "chicken";
	level.scr_anim[ "chicken" ][ "walk_basic" ]		 = %chicken_walk_basic;
	level.scr_anim[ "chicken" ][ "cage_freakout" ]	 = %chicken_cage_freakout;
}

#using_animtree( "dog" );
anim_dogs()
{
	level.scr_animtree[ "dog" ] 					 = #animtree;
	level.scr_anim[ "dog" ][ "idle" ]				 = %german_shepherd_idle;
	level.scr_anim[ "dog" ][ "walk" ]				 = %german_shepherd_walk;
	level.scr_anim[ "dog" ][ "eating" ][ 0 ]		 = %german_shepherd_eating_loop;
	level.scr_anim[ "dog" ][ "sleeping" ][ 0 ]		 = %german_shepherd_sleeping;
	level.scr_anim[ "dog" ][ "wakeup_slow" ]		 = %german_shepherd_wakeup_slow;
	level.scr_anim[ "dog" ][ "wakeup_fast" ]		 = %german_shepherd_wakeup_fast;
	level.scr_anim[ "dog" ][ "fence_attack" ] 		 = %sniper_escape_dog_fence;
	
	addNotetrack_sound( "dog", "fence", "fence_attack", "fence_smash" );
}

car_normal( car )
{
	car setanimknob( car getanim( "car_idle_normal" ), 1, 0, 1 );
	car.playerview setanimknob( car.playerview getanim( "playerview_idle_normal" ), 1, 0, 1 );
}

car_smooth( car )
{
	car setanimknob( car getanim( "car_idle_smooth" ), 1, 0, 1 );
	car.playerview setanimknob( car.playerview getanim( "playerview_idle_smooth" ), 1, 0, 1 );
}

car_bumpy( car )
{
	car setanimknob( car getanim( "car_idle_bumpy" ), 1, 0, 1 );
	car.playerview setanimknob( car.playerview getanim( "playerview_idle_bumpy" ), 1, 0, 1 );
}

car_static( car )
{
	car setanimknob( car getanim( "car_idle_static" ), 1, 0, 1 );
	car.playerview setanimknob( car.playerview getanim( "playerview_idle_static" ), 1, 0, 1 );
}

driver_turnright1( car )
{
	printturnanim( " --- STARTED  turnright1" );
	car playDriverAnim( "center2smallright", "turnright1" );
	car loopDriverAnim( "smallright_idle", "turnright1", "return" );
	car playDriverAnim( "smallright2center", "turnright1" );
	car loopDriverAnim( "idle", "turnright1" );
	printturnanim( " --- FINISHED turnright1" );
}

driver_turnleft1( car )
{
	printturnanim( " --- STARTED  turnleft1" );
	car playDriverAnim( "center2smallleft", "turnleft1" );
	car loopDriverAnim( "smallleft_idle", "turnleft1", "return" );
	car playDriverAnim( "smallleft2center", "turnleft1" );
	car loopDriverAnim( "idle", "turnleft1" );
	printturnanim( " --- FINISHED turnleft1" );
}

driver_turnleft2( car )
{
	printturnanim( " --- STARTED  turnleft2" );
	car playDriverAnim( "center2smallleft", "turnleft2" );
	car playDriverAnim( "smallleft2bigleft", "turnleft2" );
	car loopDriverAnim( "bigleft_idle", "turnleft2", "return" );
	car playDriverAnim( "bigleft2center", "turnleft2" );
	car loopDriverAnim( "idle", "turnleft2" );
	printturnanim( " --- FINISHED turnleft2" );
}

driver_turnleft3( car )
{
	printturnanim( " --- STARTED  turnleft3" );
	car playDriverAnim( "center2smallleft", "turnleft3" );
	car playDriverAnim( "smallleft2bigleft", "turnleft3" );
	car playDriverAnim( "bigleftloop", "turnleft3" );
	car loopDriverAnim( "bigleft_idle", "turnleft3", "return" );
	car playDriverAnim( "bigleft2center", "turnleft3" );
	car loopDriverAnim( "idle", "turnleft3" );
	printturnanim( " --- FINISHED turnleft3" );
}

driver_turnspecial( car )
{
	printturnanim( " --- STARTED  turnspecial" );
	car playDriverAnim( "center2smallleft", "turnspecial" );
	car loopDriverAnim( "smallleft_idle", "turnspecial", "turnleft_2_special" );
	car playDriverAnim( "smallleft2bigleft", "turnspecial" );
	car loopDriverAnim( "bigleft_idle", "turnspecial", "return" );
	car playDriverAnim( "bigleft2center", "turnspecial" );
	car loopDriverAnim( "idle", "turnspecial" );
	printturnanim( " --- FINISHED turnspecial" );
}

playerDeath( guy )
{
	playfxontag( getfx( "execution_muzzleflash" ), guy, "tag_flash" );
	playfxontag( getfx( "execution_shell_eject" ), guy, "tag_brass" );
	level.player PlayRumbleOnEntity( "grenade_rumble" );
	level.player thread play_sound_on_entity( "assassination_shot" );

	wait .1;

	//set_vision_set( "coup_death", .5 );
	overlay = newHudElem();
	overlay.x = 0;
	overlay.y = 0;
	overlay setshader( "black", 640, 480 );
	overlay.alignX = "left";
	overlay.alignY = "top";
	overlay.horzAlign = "fullscreen";
	overlay.vertAlign = "fullscreen";
	overlay.alpha = 1;
	overlay.sort = 1;
	
	level notify( "player_death" );
	
	level.player shellshock( "coup_death", 10 ); // kill ambient track
	// TODO: make sure other sounds aren't playing also

	wait 4.5;
	nextmission();
	// changelevel( "coup", false );
}

playerThrownInCar( unused )
{
	wait 0.55;
	level.player PlayRumbleOnEntity( "grenade_rumble" );
}

playerHit( unused )
{
//	takeCoverWarnings = getdvarint( "takeCoverWarnings" );
//	setdvar( "takeCoverWarnings", "0" );

	wait 0.15;
	level.player PlayRumbleOnEntity( "grenade_rumble" );
	set_vision_set( "coup_hit", 0 );

	// Revert glow to user settings
	SetSavedDvar( "r_glow_allowed_script_forced", "0" );
	
	wait 0.05;
	set_vision_set( "coup", 0.2 );
	
	// thread playerBreathingSound( level.player.maxHealth * 0.35 );
	// thread playerBreathingSound( 100 * 0.35 );
	thread playerBreathingSound( 100 * 0.35, 25 );
	
//	overlay = newHudElem();
//	overlay.x = 0;
//	overlay.y = 0;
//	overlay setshader( "overlay_low_health", 640, 480 );
//	overlay.alignX = "left";
//	overlay.alignY = "top";
//	overlay.horzAlign = "fullscreen";
//	overlay.vertAlign = "fullscreen";
//	overlay.alpha = 0;
//
//	thread maps\_gameskill::healthOverlay_remove( overlay );
//	
//	// for ( ;; )
//	// {
//		overlay fadeOverTime( 0.5 );
//		overlay.alpha = 0;
//		// flag_wait( "player_has_red_flashing_overlay" );
//		maps\_gameskill::redFlashingOverlay( overlay );
//		// redFlashingOverlay( overlay );
//	// }*/ 
//	
//	setdvar( "takeCoverWarnings", takeCoverWarnings );
}

playerPulledFromCar( unused )
{
	wait 4.15;
	level.player PlayRumbleOnEntity( "grenade_rumble" );
}

playerKicked( unused )
{
	wait 0.65;
	
	level.player PlayRumbleOnEntity( "grenade_rumble" );
}

playerHitDamage( unused )
{
	newHealth = level.player.health * 0.10;
    healthDiff = level.player.health - newHealth;

    damage = healthDiff / getdvarfloat( "player_damageMultiplier" );
	// iprintln( level.player.health );
    level.player doDamage( damage, level.player.origin );
	// iprintln( level.player.health );
}

playerBreathingSound( maxhealth, hurthealth )
{
	wait( 2 );
	for ( ;; )
	{
		wait( 0.2 );
		if ( hurthealth <= 0 )
			return;
			
		// Player still has a lot of health so no breathing sound
		ratio = hurthealth / maxhealth;
		if ( ratio > level.healthOverlayCutoff )
			continue;
			
		level.player play_sound_on_entity( "breathing_hurt" );
		wait( 0.1 + randomfloat( 0.8 ) );
	}
}

/* playerHealthRegen()
{
	thread healthOverlay();
	oldratio = 1;
	player = level.player;
	health_add = 0;
	
	regenRate = 0.1;
	veryHurt = false;
	playerJustGotRedFlashing = false;
	
	level.hurtTime = -10000;
	thread playerBreathingSound( level.player.maxHealth * 0.35 );
	invulTime = 0;
	hurtTime = 0;
	newHealth = 0;
	lastinvulratio = 1;
	
	player.boltHit = false;
	
	if ( getdvar( "scr_playerInvulTimeScale" ) == "" )
		setdvar( "scr_playerInvulTimeScale", 1.0 );
	
	for ( ;; )
	{
		wait( 0.05 );
		if ( player.health == level.player.maxHealth )
		{
			if ( flag( "player_has_red_flashing_overlay" ) )
			{
				flag_clear( "player_has_red_flashing_overlay" );
				level notify( "take_cover_done" );
			}
			
			lastinvulratio = 1;
			playerJustGotRedFlashing = false;
			veryHurt = false;
			continue;
		}
		
		if ( player.health <= 0 )
		{
			 /#showHitLog();#/ 
			return;
		}
		
		wasVeryHurt = veryHurt;
		ratio = player.health / level.player.maxHealth;
		if ( ratio <= level.healthOverlayCutoff )
		{
			veryHurt = true;
			if ( !wasVeryHurt )
			{
				hurtTime = gettime();
				level.hurtTime = hurtTime;
				thread blurView( 3.6, 2 );
				
				flag_set( "player_has_red_flashing_overlay" );
				playerJustGotRedFlashing = true;
			}
		}
	
		if ( player.health / player.maxHealth >= oldratio )
		{
			if ( gettime() - hurttime < level.playerHealth_RegularRegenDelay )
				continue;

			if ( veryHurt )
			{
				newHealth = ratio;
				if ( gettime() > hurtTime + level.longRegenTime )
					newHealth += regenRate;
			}
			else
				newHealth = 1;
							
			if ( newHealth > 1.0 )
				newHealth = 1.0;
			
			if ( newHealth <= 0 )
			{
				// Player is dead
				return;
			}
			
			 /#
			if ( newHealth > player.health / player.maxHealth )
				logRegen( newHealth );
			#/ 
			player setnormalhealth( newHealth );
			oldRatio = player.health / player.maxHealth;
			continue;
		}
		
		oldratio = lastinvulRatio;
		invulWorthyHealthDrop = oldratio - ratio >= level.worthyDamageRatio;
		
		if ( player.health <= 1 )
		{
			// if player's health is <= 1, code's player_deathInvulnerableTime has kicked in and the player won't lose health for a while.
			// set the health to 2 so we can at least detect when they're getting hit.
			player setnormalhealth( 2 / player.maxHealth );
			invulWorthyHealthDrop = true;
		}

		oldRatio = player.health / player.maxHealth;
		level notify( "hit_again" );
			
		health_add = 0;
		hurtTime = gettime();
		level.hurtTime = hurtTime;
		thread blurView( 3, 0.8 );
		
		if ( !invulWorthyHealthDrop || getdvarfloat( "scr_playerInvulTimeScale" ) <= 0.0 )
		{
			 /#logHit( player.health, 0 );#/ 
			continue;
		}
		if ( flag( "player_is_invulnerable" ) )
			continue;
		flag_set( "player_is_invulnerable" );
		level notify( "player_becoming_invulnerable" );// because "player_is_invulnerable" notify happens on both set * and * clear
		
		level.conserveAmmoAgainstInvulPlayer = false;
		level.conserveAmmoAgainstInvulPlayerTime = gettime();
		
		if ( playerJustGotRedFlashing )
		{
			invulTime = level.invulTime_onShield;
			playerJustGotRedFlashing = false;
		}
		else if ( veryHurt )
		{
			invulTime = level.invulTime_postShield;
		}
		else
		{
			invulTime = level.invulTime_preShield;
		}
		
		invulTime *= getdvarfloat( "scr_playerInvulTimeScale" );
		
		 /#logHit( player.health, invulTime );#/ 
		lastinvulratio = player.health / player.maxHealth;
		
		level.player.attackerAccuracy = 0;
		thread invulEnd( invulTime );
	}
}*/ 


melee_kill( guy )
{
	guy playsound( "melee_swing_large" );
	
	// alias = "generic_pain_russian_" + guy.favoriteenemy._stealth.behavior.sndnum;
	
	// guy.favoriteenemy playsound( alias );
	guy.favoriteenemy playsound( "melee_hit" );
	guy.favoriteenemy.allowdeath = false;
	guy.favoriteenemy notify( "anim_death" );
	
	thread kill_self( guy.favoriteenemy );
}

rag_doll_death( guy )
{		
	guy thread killed_by_player( true );	
}

kill_self( guy )
{
	guy endon( "death" );
	
	wait .1;// for no death to be sent
	guy.allowdeath = true;
	guy dodamage( guy.health + 200, guy.origin );
}

killed_by_player( ragdoll )
{
	self endon( "anim_death" );
	
	self notify( "killed_by_player_func" );
	self endon( "killed_by_player_func" );
	
	while ( 1 )
	{
		self waittill( "death", other );
		if ( isdefined( other ) && other == level.player )
			break;
	}
	self notify( "killed_by_player" );	
	if ( isdefined( ragdoll ) )
	{
		self animscripts\shared::DropAllAIWeapons();
		self startragdoll();	
	}
}

playDriverAnim( animsuffix, printname )
{
	if ( isdefined( printname ) )
		printturnanim( " ---          " + printname + ", " + animsuffix );
	else
		printturnanim( " ---          , " + animsuffix );

	if( animsuffix == "bigleft2center" && printname == "turnleft3" )
		self setanimknob( self getanim( "wheel_bigleftloop2center" ), 1, 0, 1 );
	else
		self setanimknob( self getanim( "wheel_" + animsuffix ), 1, 0, 1 );
	
	self anim_single_solo( self.driver, "cardriver_" + animsuffix, "tag_driver" );
}

loopDriverAnim( animsuffix, printname, matchname )
{
	if ( isdefined( printname ) )
		printturnanim( " --- ( loop ) " + printname + ", " + animsuffix );
	else
		printturnanim( " --- ( loop ) , " + animsuffix );

	self notify( "stop_driver_loop" );
	
	if( animsuffix == "bigleft_idle" && printname == "turnleft3" )
		self setanimknob( self getanim( "wheel_bigleftloop_idle" ), 1, 0, 1 );
	else
		self setanimknob( self getanim( "wheel_" + animsuffix ), 1, 0, 1 );
		
	self thread anim_loop_solo( self.driver, "cardriver_" + animsuffix, "tag_driver", "stop_driver_loop" );

	if ( isdefined( matchname ) )
	{
		self waittillmatch( "single anim", matchname );
		printturnanim( " --- MATCHED  " + printname + ", " + animsuffix + ", " + matchname );
	}
}

playPassengerAnim( anime )
{
	//printpassengeranim( " ---          " + animsuffix );
	
	self anim_single_solo( self.passenger, anime, "tag_passenger" );
}

loopPassengerAnim( anime, matchname )
{
	//printpassengeranim( " --- ( loop ) " + animsuffix );

	self notify( "stop_passenger_loop" );
	self thread anim_loop_solo( self.passenger, anime, "tag_passenger", "stop_passenger_loop" );

	if ( isdefined( matchname ) )
	{
		self waittillmatch( "single anim", matchname );
		//printpassengeranim( " --- MATCHED  " + animsuffix + ", " + matchname );
	}
}

printturnanim( string )
{
	if ( isdefined( level.debug_turnanims ) && level.debug_turnanims )
		println( string );
}

printpassengeranim( string )
{
	if ( isdefined( level.debug_passengeranims ) && level.debug_passengeranims )
		println( string );
}

ambientCarInterior( guy )
{
	delaythread( 0.6, maps\_ambient::set_ambience_blend_over_time, 0, "exterior", "interior_vehicle" );
}

ambientCarExterior( guy )
{
	delaythread( 0.1, maps\_ambient::set_ambience_blend_over_time, 0, "interior_vehicle", "exterior" );
}

passengerLookBack( guy )
{
	wait 5.45;
	level.car.passenger StopAnimScripted();
	level.car playPassengerAnim( "carpassenger_lookback" );
	level.car loopPassengerAnim( "carpassenger_idle" );
}

crowdFireWeapon( guy )
{
	guy thread play_sound_on_tag( "weap_ak47_fire_npc", "tag_flash" );
	PlayFXOnTag( getfx( "ak47_muzzleflash" ), guy, "tag_flash" );
	//PlayFXOnTag( getfx( "ak47_shelleject" ), guy, "tag_flash" );
}