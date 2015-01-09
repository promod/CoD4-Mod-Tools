#include maps\_anim;
#using_animtree("generic_human");

main()
{
	anims();
	dialogue();
}

anims()
{
	/*-----------------------
	C4 PLANT
	-------------------------*/	
	level.scr_anim[ "frnd" ][ "C4_plant_start" ]					= %explosive_plant_knee;
	level.scr_anim[ "frnd" ][ "C4_plant" ]							= %explosive_plant_knee;

	/*-----------------------
	GENERIC HAND SIGNALS
	-------------------------*/	
	level.scr_anim[ "generic" ][ "signal_onme" ]				= %CQB_stand_wave_on_me;
	level.scr_anim[ "generic" ][ "signal_go" ]					= %CQB_stand_wave_go_v1;
	level.scr_anim[ "generic" ][ "signal_stop" ]				= %CQB_stand_signal_stop;
	
	level.scr_anim[ "generic" ][ "signal_moveup" ]				= %CQB_stand_signal_move_up;
	level.scr_anim[ "generic" ][ "signal_moveout" ]				= %CQB_stand_signal_move_out;
	level.scr_anim[ "generic" ][ "signal_check" ]				= %CQB_stand_signal_twitch_check;
	level.scr_anim[ "generic" ][ "signal_look" ]				= %CQB_stand_signal_twitch_look;
	level.scr_anim[ "generic" ][ "signal_quicklook" ]			= %CQB_stand_signal_twitch_quicklook;
	level.scr_anim[ "generic" ][ "signal_shift" ]				= %CQB_stand_signal_twitch_shift;
	level.scr_anim[ "generic" ][ "signal_twitch" ]				= %CQB_stand_twitch;

	level.scr_anim[ "generic" ][ "moveout_exposed" ]			= %stand_exposed_wave_move_out;
	level.scr_anim[ "generic" ][ "moveup_exposed" ]				= %stand_exposed_wave_move_up;
	level.scr_anim[ "generic" ][ "stop_exposed" ]				= %stand_exposed_wave_halt;
	level.scr_anim[ "generic" ][ "stop2_exposed" ]				= %stand_exposed_wave_halt_v2;
	level.scr_anim[ "generic" ][ "onme_exposed" ]				= %stand_exposed_wave_on_me;
	level.scr_anim[ "generic" ][ "onme2_exposed" ]				= %stand_exposed_wave_on_me_v2;
	level.scr_anim[ "generic" ][ "enemy_exposed" ]				= %stand_exposed_wave_target_spotted;
	level.scr_anim[ "generic" ][ "down_exposed" ]				= %stand_exposed_wave_down;
	level.scr_anim[ "generic" ][ "go_exposed" ]					= %stand_exposed_wave_go;
	
	level.scr_anim[ "generic" ][ "moveout_cornerR" ]			= %CornerStndR_alert_signal_move_out;
	level.scr_anim[ "generic" ][ "stop_cornerR" ]				= %CornerStndR_alert_signal_stopStay_down;
	level.scr_anim[ "generic" ][ "onme_cornerR" ]				= %CornerStndR_alert_signal_on_me;
	level.scr_anim[ "generic" ][ "enemy_cornerR" ]				= %CornerStndR_alert_signal_enemy_spotted;


	/*-----------------------
	PATROL
	-------------------------*/	

	level.scr_anim[ "generic" ][ "patrol_walk" ]			= %patrol_bored_patrolwalk;
	level.scr_anim[ "generic" ][ "patrol_walk_twitch" ]		= %patrol_bored_patrolwalk_twitch;
	level.scr_anim[ "generic" ][ "patrol_stop" ]			= %patrol_bored_walk_2_bored;
	level.scr_anim[ "generic" ][ "patrol_start" ]			= %patrol_bored_2_walk;
	level.scr_anim[ "generic" ][ "patrol_turn180" ]			= %patrol_bored_2_walk_180turn;
	
	level.scr_anim[ "generic" ][ "patrol_idle_1" ]			= %patrol_bored_idle;
	level.scr_anim[ "generic" ][ "patrol_idle_2" ]			= %patrol_bored_idle_smoke;
	level.scr_anim[ "generic" ][ "patrol_idle_3" ]			= %patrol_bored_idle_cellphone;
	level.scr_anim[ "generic" ][ "patrol_idle_4" ]			= %patrol_bored_twitch_bug;
	level.scr_anim[ "generic" ][ "patrol_idle_5" ]			= %patrol_bored_twitch_checkphone;
	level.scr_anim[ "generic" ][ "patrol_idle_6" ]			= %patrol_bored_twitch_stretch;	
	
	level.scr_anim[ "generic" ][ "patrol_idle_smoke" ]		= %patrol_bored_idle_smoke;
	level.scr_anim[ "generic" ][ "patrol_idle_checkphone" ]	= %patrol_bored_twitch_checkphone;
	level.scr_anim[ "generic" ][ "patrol_idle_stretch" ]	= %patrol_bored_twitch_stretch;
	level.scr_anim[ "generic" ][ "patrol_idle_phone" ]		= %patrol_bored_idle_cellphone;
	
	level.scr_anim[ "generic" ][ "patrol_jog" ]				= %patrol_jog;	
	level.scr_anim[ "generic" ][ "combat_jog" ]				= %combat_jog;		
	level.scr_anim[ "generic" ][ "patrol_jog_turn180" ]		= %patrol_jog_360;
	
	level.scr_anim[ "generic" ][ "stealth_jog" ]			= %patrol_jog;				
	level.scr_anim[ "generic" ][ "stealth_walk" ]			= %patrol_bored_patrolwalk;	


	
	/*-----------------------
	DEATH POSES
	-------------------------*/		
	level.scr_anim[ "generic" ][ "death_pose_sit_1" ][0]			= %death_sitting_pose_v1;
	level.scr_anim[ "generic" ][ "death_pose_sit_2" ][0]			= %death_sitting_pose_v2;
	level.scr_anim[ "generic" ][ "death_pose_chair_1" ][0]			= %airlift_copilot_dead;
	level.scr_anim[ "generic" ][ "death_pose_floor_1" ][0]			= %cargoship_sleeping_guy_idle_1;
	level.scr_anim[ "generic" ][ "death_pose_floor_2" ][0]			= %cargoship_sleeping_guy_idle_2;
	level.scr_anim[ "generic" ][ "death_pose_desk" ][0]				= %death_pose_on_desk;
	level.scr_anim[ "generic" ][ "death_pose_window" ][0]			= %death_pose_on_window;

	/*-----------------------
	HUMAN SHIELD
	-------------------------*/		
	level.scr_anim[ "hostage" ][ "unarmed_run1" ]					= %unarmed_run_russian;	
	level.scr_anim[ "hostage" ][ "unarmed_run2" ] 					 = %unarmed_panickedrun_loop_V1;
	level.scr_anim[ "hostage" ][ "unarmed_run3" ] 					 = %unarmed_panickedrun_loop_V2;
		
	//IDLE
	level.scr_anim["hostage"]["human_shield_idle"][0]		= %human_shield_idle_1_H;	//Human shield idle
	level.scr_anim["terrorist"]["human_shield_idle"][0]		= %human_shield_idle_1_T;	//Human shield idle
	
	//DEATH ANIMS
	level.scr_anim["terrorist"]["human_shield_death"]		= %human_shield_death_1_T;	//terrorist killed
	level.scr_anim["hostage"]["human_shield_death"]			= %hostage_human_shield_host_death;		//TEMP ANIM!!!!
	
	//WOUNDED ANIMS
	level.scr_anim["terrorist"]["human_shield_pain"]		= %human_shield_wounded_1_T;		//TEMP ANIM!!!!
	//level.scr_anim["hostage"]["human_shield_pain"]			= %human_shield_wounded_1_H;		//TEMP ANIM!!!!
	//level.scr_anim["terrorist"]["human_shield_pain"]		= %terrorist_human_shield_ter_pain;		//TEMP ANIM!!!!
	//level.scr_anim["hostage"]["human_shield_pain"]		= %terrorist_human_shield_ter_pain;		//TEMP ANIM!!!!

	//BREAK FREE ANIMS (ONE OR THE OTHER IS KILLED....PARTNER REACTS
	level.scr_anim["hostage"]["human_shield_breakfree_partner_dead"]		= %human_shield_death_1_H;	//terrorist killed, hostage runs away
	level.scr_anim["terrorist"]["human_shield_breakfree_partner_dead"]		= %terrorist_human_shield_host_death;		//HOSTAGE KILLED
	
	//ONE PARTNER WOUNDED HOSTAGE BREAKS FREE
	level.scr_anim["hostage"]["human_shield_breakfree_partner_wounded"]		= %human_shield_wounded_1_H;		//TEMP ANIM!!!!  
	
	//FLASHED	
	//level.scr_anim["hostage"]["human_shield_flashed"]		= %human_shield_flashbang_1_H;
	//level.scr_anim["terrorist"]["human_shield_flashed"]		= %human_shield_flashbang_1_T;	

	level.scr_anim["bridge_stand1"]["idle"][0]		= %cargoship_stunned_react_v2_idle;
	level.scr_anim["bridge_stand1"]["react"]		= %cargoship_stunned_react_v2;
	level.scr_anim["bridge_stand1"]["death"]		= %cargoship_stunned_react_v2_death;

	/*-----------------------
	VIP
	-------------------------*/	
	level.scr_anim[ "hostage" ][ "standunarmed_idle_loop" ][0]	= %standunarmed_idle_loop;
	level.scr_anim[ "hostage" ][ "unarmed_crouch_idle1" ][0]	= %unarmed_crouch_idle1;
	level.scr_anim[ "hostage" ][ "unarmed_crouch_twitch1" ]	= %unarmed_crouch_twitch1;

	//idle cowering on ground
	level.scr_anim[ "hostage" ][ "airplane_end_VIP_idle" ][0]	= %airplane_end_VIP_idle;
	
	//anim_reach start point
	level.scr_anim[ "hostage" ][ "airplane_end_VIP_start" ]	= %airplane_end_VIP;
	level.scr_anim[ "frnd" ][ "airplane_end_VIP_start" ]	= %airplane_end_soldier;
	
	//vip grab and jump out door
	level.scr_anim[ "hostage" ][ "airplane_end_VIP" ]	= %airplane_end_VIP;
	level.scr_anim[ "frnd" ][ "airplane_end_VIP" ]	= %airplane_end_soldier;

}

dialogue()
{
	/*-----------------------
	SAS CHATTER - MOVE
	-------------------------*/	
	level.dialogueMoveLines = 3;
	//Gaz	
	//Move.		
	//HR2	
	level.scr_radio["airplane_gaz_keepmoving_1"] = "airplane_gaz_move";
	
	//Gaz	
	//Move up!		
	//HR2	
	level.scr_radio["airplane_gaz_keepmoving_2"] = "airplane_gaz_moveup";
	
	//Gaz	
	//Keep moving!
	//HR2
	level.scr_radio["airplane_gaz_keepmoving_3"] = "airplane_gaz_keepmoving";
	
	/*-----------------------
	SAS CHATTER - HOSTILE DOWN
	-------------------------*/	
	level.dialogueHostileDown = 12;
	//Gaz
	//Tango down!		
	//HR2	
	level.scr_radio["airplane_killfirm_1"] = "airplane_gaz_tangodown";
	
	//Gaz	
	//Xray down!		
	//HR2	
	level.scr_radio["airplane_killfirm_2"] = "airplane_gaz_xraydown";
	
	//Gaz	
	//Hostile neutralized!		
	//HR2	
	level.scr_radio["airplane_killfirm_3"] = "airplane_gaz_hostileneut";
	
	//Gaz	
	//Target neutralized!		
	//HR2	
	level.scr_radio["airplane_killfirm_4"] = "airplane_gaz_targneut";

	//SAS 1	s
	//Tango down!		
	//HR2	
	level.scr_radio["airplane_killfirm_5"] = "airplane_sas1_tangodown";
	
	//SAS 1
	//Xray down!		
	//HR2	
	level.scr_radio["airplane_killfirm_6"] = "airplane_sas1_xraydown";
	
	//SAS 1	
	//Hostile neutralized!		
	//HR2	
	level.scr_radio["airplane_killfirm_7"] = "airplane_sas1_hostileneut";
	
	//SAS 1	
	//Target neutralized!		
	//HR2	
	level.scr_radio["airplane_killfirm_8"] = "airplane_sas1_targneut";
		
	//SAS 4	
	//Tango down!		
	//HR2	
	level.scr_radio["airplane_killfirm_9"] = "airplane_sas4_tangodown";
	
	//SAS 4	
	//Xray down!		
	//HR2	
	level.scr_radio["airplane_killfirm_10"] = "airplane_sas4_xraydown";
	
	//SAS 4	
	//Hostile neutralized!		
	//HR2	
	level.scr_radio["airplane_killfirm_11"] = "airplane_sas4_hostileneut";
	
	//SAS 4	
	//Target neutralized!		
	//HR2	
	level.scr_radio["airplane_killfirm_12"] = "airplane_sas4_targneut";
	
	/*-----------------------
	SAS CHATTER - AREA CLEAR
	-------------------------*/		
	level.dialogueAreaClear = 9;
	//Gaz	
	//Area clear!		
	//HR2	
	level.scr_radio["airplane_areaclear_1"] = "airplane_gaz_areaclear";
	
	//Gaz	
	//Section clear!		
	//HR2	
	level.scr_radio["airplane_areaclear_2"] = "airplane_gaz_sectionclear";
	
	//Gaz	
	//Clear!		
	//HR2	
	level.scr_radio["airplane_areaclear_3"] = "airplane_gaz_clear";
	
	//SAS 1	
	//Area clear!		
	//HR2	
	level.scr_radio["airplane_areaclear_4"] = "airplane_sas1_areaclear";
	
	//SAS 1	
	//Section clear!		
	//HR2	
	level.scr_radio["airplane_areaclear_5"] = "airplane_sas1_sectionclear";
	
	//SAS 1	
	//Clear!		
	//HR2	
	level.scr_radio["airplane_areaclear_6"] = "airplane_sas1_clear";
	
	//SAS 4	
	//Area clear!		
	//HR2	
	level.scr_radio["airplane_areaclear_7"] = "airplane_sas4_areaclear";
	
	//SAS 4	
	//Section clear!		
	//HR2	
	level.scr_radio["airplane_areaclear_8"] = "airplane_sas4_sectionclear";
	
	//SAS 4	
	//Clear!		
	//HR2	
	level.scr_radio["airplane_areaclear_9"] = "airplane_sas4_clear";	
	

	/*-----------------------
	DIALOGUE
	-------------------------*/	
	
//Gaz	
//Remember - the objective is to capture Kriegler. I repeat: capture - Kriegler - alive. He's no good to us dead.		
//HR2
level.scr_radio["airplane_gaz_capturekriegler"] = "airplane_gaz_capturekriegler";

//Gaz	
//We're goin' deep…...and we're goin' hard.		
//HR2	
level.scr_radio["airplane_gaz_goindeep"] = "airplane_gaz_goindeep";

//SAS 1	
//Surely you can't be serious.		
//HR2	
level.scr_radio["airplane_sas1_surely"] = "airplane_sas1_surely";

//Gaz
//I am serious...and don't call me Shirley.		
//HR2
level.scr_radio["airplane_gaz_shirley"] = "airplane_gaz_shirley";
	
//Gaz	
//Ok, get ready.		
//HR2	
level.scr_radio["airplane_gaz_okgetready"] = "airplane_gaz_okgetready";

	//SAS 4	
	//Tango down in section one alpha.		
	//HR2	
	level.scr_radio["airplane_first_hostile_killed_1"] = "airplane_sas4_onealpha";
	
	//Gaz	
	//Weapons free.		
	//HR2	
	level.scr_radio["airplane_first_hostile_killed_2"] = "airplane_gaz_weaponsfree";
	
	//SAS 4	
	//Multiple contacts.		
	//HR2	
	level.scr_radio["airplane_sas4_multiplecont"] = "airplane_sas4_multiplecont";

	//Gaz	
	//Stairway clear!		
	//HR2	
	level.scr_radio["airplane_gaz_stairwayclear"] = "airplane_gaz_stairwayclear";
		
//Gaz	
//Standby….standby…go!		
//HR2	
level.scr_radio["airplane_gaz_standby"] = "airplane_gaz_standby";
	
	
	//Gaz	
	//We've got a hull breaach! Get doown!! Get dooown!!		
	//HR2	
	level.scr_radio["airplane_gaz_hullbreach"] = "airplane_gaz_hullbreach";
	
	//Gaz	
	//Watch your fire up here. We're looking for a civilian.		
	//HR2	
	level.scr_radio["airplane_gaz_watchyourfire"] = "airplane_gaz_watchyourfire";
	
//Gaz	
//Watch your fire up here. We need Kriegler alive.		
//HR2	
level.scr_radio["airplane_gaz_needkriegleralive"] = "airplane_gaz_needkriegleralive";

//Gaz	
//Watch your fire up here. We need the VIP alive!		
//HR2	
level.scr_radio["airplane_gaz_needvipalive"] = "airplane_gaz_needvipalive";
	
	//Gaz	
	//Drop the weapon!!! Down on the floor now
	//!!!!			
	level.scr_radio["airplane_gaz_downonfloor"] = "airplane_gaz_downonfloor";
	
//Gaz	
//Take him.		
//HR2	
level.scr_radio["airplane_gaz_takehim"] = "airplane_gaz_takehim";
	
	//Russian 1	
	//Get back! I'll blow his fucking head off! I said get back
	//!			
	level.scr_sound[ "terrorist" ]["airplane_ter_illkillhim"] = "airplane_ter_illkillhim";
	
//Gaz	
//Nice one, Soap.		
//HR2	
level.scr_radio["airplane_gaz_niceone"] = "airplane_gaz_niceone";

	//SAS 4	
	//Shite, someone's armed the bomb. We don't have much time. We've got to go - now.		
	//HR2	
	level.scr_radio["airplane_sas4_armedbomb"] = "airplane_sas4_armedbomb";
	
//Gaz	
//Get that door open
//!			
level.scr_sound[ "frnd" ]["airplane_gaz_dooropen"] = "airplane_gaz_dooropen";

	//Gaz	
	//Roger that. Prepare to breach.		
	//HR2	
	level.scr_radio["airplane_gaz_preptobreach"] = "airplane_gaz_preptobreach";
		
	//Russian 4	
	//Please! Just don't hurt me. I want to go home. I just want to get out of here
	//. 			
	level.scr_sound[ "hostage" ]["airplane_ru4_donthurtme"] = "airplane_ru4_donthurtme";
	
//Russian 4	
//I need to get to a phone. What's happening here? I don't deserve this...any of this
//...			
level.scr_sound[ "hostage" ]["airplane_ru4_gettoaphone"] = "airplane_ru4_gettoaphone";
	
//Gaz	
//We're goin' for a little freefall Kriegler - on your feet…(slight exertion from shoving protesting VIP)		
//HR2	
level.scr_radio["airplane_gaz_littlefreefall"] = "airplane_gaz_littlefreefall";
	
	//Gaz	
	//We're goin' for a little freefall mate! On your feet! (slight exertion from shoving protesting VIP)		
	//HR2	
	level.scr_radio["airplane_gaz_onyourfeet"] = "airplane_gaz_onyourfeet";
	
	//Russian 4	
	//What? No!... Wait! What are you doing? I don't have a parachuuuuuuute
	//......			
	level.scr_sound[ "hostage" ]["airplane_ru4_noparachute"] = "airplane_ru4_noparachute";
	
//SAS 4	
//(chuckle) That's one way to do it. See ya on the ground mate.		
//HR2	
level.scr_radio["airplane_sas4_thatsoneway"] = "airplane_sas4_thatsoneway";
	
	//SAS 1	
	//Let's go! Let's go! Out the door before this thing blows!		
	//HR2	
	level.scr_radio["airplane_sas1_letsgo"] = "airplane_sas1_letsgo";
	
	//Gaz	
	//Mission accomplished! See ya next time mate!		
	//HR2
	level.scr_radio["airplane_gaz_seeya"] = "airplane_gaz_seeya";
	
	player_view();
}

#using_animtree( "player" );
player_view()
{
	//the animtree to use with the invisible model with animname "player_view"
	level.scr_animtree[ "player_view" ] 								= #animtree;	
	//the invisible model with the animname "player_view" that the anims will be played on
	level.scr_model[ "player_view" ] 									= "viewhands_player_usmc";
}	