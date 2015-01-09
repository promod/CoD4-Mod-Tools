#include maps\_anim;
#include maps\_props;

main()
{
	add_smoking_notetracks( "generic" );
	add_cellphone_notetracks( "generic" );
		
	anims();
	dialog();
	patrol();
	dog();
	script_models();
}

#using_animtree( "script_model" );
script_models()
{
	level.scr_anim[ "chair" ][ "sleep_react" ]					= %parabolic_guard_sleeper_react_chair;
	level.scr_animtree[ "chair" ] 								= #animtree;	
	level.scr_model[ "chair" ] 									= "com_folding_chair"; 	
}

#using_animtree("generic_human");
anims()
{	
	//GENERIC
	level.scr_anim[ "generic" ][ "pronehide_dive" ]				= %hunted_dive_2_pronehide_v1;
	level.scr_anim[ "generic" ][ "pronehide_idle" ][0]			= %hunted_pronehide_idle_v1;
	level.scr_anim[ "generic" ][ "pronehide_idle_frame" ]		= %hunted_pronehide_idle_v1;
	level.scr_anim[ "generic" ][ "prone_2_run_roll" ]			= %hunted_pronehide_2_stand_v1;
		
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
	
	level.scr_anim[ "generic" ][ "moveout_cornerR" ]			= %CornerStndR_alert_signal_move_out;
	level.scr_anim[ "generic" ][ "stop_cornerR" ]				= %CornerStndR_alert_signal_stopStay_down;
	level.scr_anim[ "generic" ][ "onme_cornerR" ]				= %CornerStndR_alert_signal_on_me;
	level.scr_anim[ "generic" ][ "enemy_cornerR" ]				= %CornerStndR_alert_signal_enemy_spotted;
	
	level.scr_anim[ "generic" ][ "alert2look_cornerR" ]				= %corner_standr_alert_2_look;
	level.scr_anim[ "generic" ][ "look_idle_cornerR" ][0]			= %corner_standR_look_idle;
	level.scr_anim[ "generic" ][ "look2alert_cornerR" ]				= %corner_standR_look_2_alert;
	
	level.scr_anim[ "generic" ][ "look_up_stand" ]					= %coverstand_look_moveup;
	level.scr_anim[ "generic" ][ "look_idle_stand" ][0]				= %coverstand_look_idle;
	level.scr_anim[ "generic" ][ "look_down_stand" ]				= %coverstand_look_movedown;
	
	level.scr_anim[ "generic" ][ "alert2look_cornerL" ]				= %corner_standl_alert_2_look;
	level.scr_anim[ "generic" ][ "look_idle_cornerL" ][0]			= %corner_standl_look_idle;
	level.scr_anim[ "generic" ][ "look2alert_cornerL" ]				= %corner_standl_look_2_alert;
	
	level.scr_anim[ "generic" ][ "coverstand_hide_2_aim" ]				= %coverstand_hide_2_aim;
	level.scr_anim[ "generic" ][ "cornerstandL_hide_2_aim" ]			= %corner_standL_trans_alert_2_A;
	level.scr_anim[ "generic" ][ "cornerstandR_hide_2_aim" ]			= %corner_standR_trans_alert_2_A;
	level.scr_anim[ "generic" ][ "cornercrouchL_hide_2_aim" ]			= %CornerCrL_trans_alert_2_A;
	level.scr_anim[ "generic" ][ "cornercrouchR_hide_2_aim" ]			= %CornerCrR_trans_alert_2_A;
	
	level.scr_anim[ "generic" ][ "stand_aim" ][0]						= %stand_aim_straight;
	level.scr_anim[ "generic" ][ "stand_aim_add" ]						= %exposed_idle_alert_v1;
	level.scr_anim[ "generic" ][ "crouch_aim" ][0]						= %crouch_aim_straight;	
	level.scr_anim[ "generic" ][ "crouch_aim_add" ]						= %exposed_crouch_idle_alert_v1;		
		
	
	level.scr_anim[ "generic" ][ "flash_cornerL" ]				= %corner_standL_grenade_B;
	level.scr_anim[ "generic" ][ "flash_cornerR" ]				= %corner_standR_grenade_B;
		
	level.scr_anim[ "generic" ][ "sprint" ]						= %sprint1_loop;		
	level.scr_anim[ "generic" ][ "crawl_loop" ]					= %prone_crawl;
	level.scr_anim[ "generic" ][ "prone_idle" ]					= %prone_aim_idle;
	level.scr_anim[ "generic" ][ "stand2prone" ]				= %stand_2_prone;
	level.scr_anim[ "generic" ][ "prone2stand" ]				= %prone_2_stand;
	
	level.scr_anim[ "generic" ][ "run_2_stop" ]					= %run_2_stand_F_6;		
	level.scr_anim[ "generic" ][ "combat_idle" ][0]				= %stand_aim_straight;	//casual_stand_idle
	level.scr_anim[ "generic" ][ "stand2run" ]					= %stand_2_run_F_2;
	
	
	//INTRO 
	level.scr_anim[ "price" ][ "scoutsniper_opening_price" ]	= %scout_sniper_price_prone_opening;
//	level.scr_anim[ "price" ][ "wave" ] 						= %scout_sniper_price_wave;
//	level.scr_anim[ "price" ][ "wave_idle" ]					= %scout_sniper_price_wave_idle;
	
	level.scr_anim[ "generic" ][ "cellphone_idle" ][0]			= %patrol_bored_idle_cellphone;
	level.scr_anim[ "generic" ][ "smoke_idle" ][0]				= %patrol_bored_idle_smoke;
	level.scr_anim[ "generic" ][ "lean_smoke_idle" ][0]			= %parabolic_leaning_guy_smoking_idle;
	level.scr_anim[ "generic" ][ "lean_smoke_idle" ][1]			= %parabolic_leaning_guy_smoking_twitch;
	level.scr_anim[ "generic" ][ "coffee_idle" ][0]				= %parabolic_guard_sleeper_idle;
	level.scr_anim[ "generic" ][ "sleep_idle" ][0]				= %parabolic_guard_sleeper_idle;
	
	level.scr_anim[ "generic" ][ "cellphone_reach" ]			= %patrol_bored_idle_cellphone;
	level.scr_anim[ "generic" ][ "smoke_reach" ]				= %patrol_bored_idle_smoke;
	level.scr_anim[ "generic" ][ "lean_smoke_reach" ]			= %parabolic_leaning_guy_smoking_idle;
	level.scr_anim[ "generic" ][ "coffee_reach" ]				= %parabolic_guard_sleeper_idle;
	level.scr_anim[ "generic" ][ "sleep_reach" ]				= %parabolic_guard_sleeper_idle;
	
	level.scr_anim[ "generic" ][ "cellphone_react" ]			= %patrol_bored_react_look_retreat;
	level.scr_anim[ "generic" ][ "smoke_react" ]				= %patrol_bored_react_look_advance;
	level.scr_anim[ "generic" ][ "lean_smoke_react" ]			= %patrol_bored_react_walkstop_short;
	level.scr_anim[ "generic" ][ "coffee_react" ]				= %parabolic_guard_sleeper_react;
	level.scr_anim[ "generic" ][ "sleep_react" ]				= %parabolic_guard_sleeper_react;
		
	//CHURCH
	level.scr_anim[ "generic" ][ "open_door_slow" ]				= %hunted_open_barndoor;
	level.scr_anim[ "generic" ][ "open_door_slow_stop" ]		= %hunted_open_barndoor_stop;
	level.scr_anim[ "generic" ][ "open_door_kick" ]				= %doorkick_2_cqbwalk;	
	level.scr_anim[ "generic" ][ "cqb_look_around" ]			= %combatwalk_f_spin;
	level.scr_anim[ "generic" ][ "ladder_slide" ]				= %scout_sniper_ladder_slide;
		
	//GRAVEYARD
	level.scr_anim[ "generic" ][ "corner_crouch" ]				= %cornercrr_stand_2_alert;
	level.scr_anim[ "generic" ][ "corner_idle" ][0]				= %cornercrr_alert_idle;
	level.scr_anim[ "generic" ][ "corner_stand" ]				= %cornercrr_alert_2_stand;
	
	//CARGO
	level.scr_anim[ "generic" ][ "cargo_attack_1" ]				= %melee_B_attack;
	addNotetrack_customFunction( "generic", "melee", maps\scoutsniper_code::melee_kill, "cargo_attack_1" );
	level.scr_anim[ "generic" ][ "cargo_defend_1" ]				= %melee_B_defend;
	addNotetrack_customFunction( "generic", "no death", maps\scoutsniper_code::rag_doll_death, "cargo_defend_1" );
	addNotetrack_customFunction( "generic", "end", maps\scoutsniper_code::kill_self, "cargo_defend_1" );
	
	level.scr_anim[ "generic" ][ "cargo_attack_2" ]				= %melee_L_attack;
	addNotetrack_customFunction( "generic", "melee", maps\scoutsniper_code::melee_kill, "cargo_attack_2" );
	level.scr_anim[ "generic" ][ "cargo_defend_2" ]				= %melee_L_defend;
	addNotetrack_customFunction( "generic", "no death", maps\scoutsniper_code::rag_doll_death, "cargo_defend_2" );
	addNotetrack_customFunction( "generic", "end", maps\scoutsniper_code::kill_self, "cargo_defend_2" );
	
	//DASH
	level.scr_anim[ "generic" ][ "bm21_unload1" ]				= %bm21_guy4_climbout;
	level.scr_anim[ "generic" ][ "bm21_unload2" ]				= %bm21_guy8_climbout;
	level.scr_anim[ "generic" ][ "balcony_death" ]				= %scout_sniper_balcony_death;	
	addNotetrack_customFunction( "generic", "start_ragdoll", maps\scoutsniper_code::rag_doll, "balcony_death" );
	
	level.scr_anim[ "generic" ][ "deadguy_throw1" ]				= %scout_sniper_bodydump_deadguy_throw1;
	addNotetrack_customFunction( "generic", "body_splash", maps\scoutsniper_code::body_splash, "deadguy_throw1" );
	level.scr_anim[ "generic" ][ "deadguy_throw2" ]				= %scout_sniper_bodydump_deadguy_throw2;
	addNotetrack_customFunction( "generic", "body_splash", maps\scoutsniper_code::body_splash, "deadguy_throw2" );
	level.scr_anim[ "generic" ][ "bodydump_guy1" ]				= %scout_sniper_bodydump_guy1;	
	level.scr_anim[ "generic" ][ "bodydump_guy2" ]				= %scout_sniper_bodydump_guy2;
}

dialog()
{
//SPOTTED
	//We're spotted! Take cover!
	level.scr_radio[ "scoutsniper_mcm_spotted" ]				= "scoutsniper_mcm_spotted";
	//Dogs in the tall grass!
	level.scr_radio[ "scoutsniper_mcm_dogsingrass" ]			= "scoutsniper_mcm_dogsingrass";

//SPOTTED LIVE
	//What the bloody hell was that? You trying to get us killed? Move up...and don't do that again.
	level.scr_radio[ "scoutsniper_mcm_getuskilled" ]			= "scoutsniper_mcm_getuskilled";
	//The word stealth doesn't mean anything to you does it? Move up.
	level.scr_radio[ "scoutsniper_mcm_thewordstealth" ]			= "scoutsniper_mcm_thewordstealth";
	//All right, now you're just showin' off. Lets go.
	level.scr_radio[ "scoutsniper_mcm_showinoff" ]				= "scoutsniper_mcm_showinoff";

//EVENTS
	//They've found a body. There's no quiet way out of this one. Your move.
	level.scr_radio[ "scoutsniper_mcm_goloud" ]					= "scoutsniper_mcm_goloud";
	//He can call for help all he likes, good thing there's no one left.
	level.scr_radio[ "scoutsniper_mcm_nooneleft" ]				= "scoutsniper_mcm_nooneleft";	
	//Just wait...let them move on...
	level.scr_radio[ "scoutsniper_mcm_letthemmove" ]			= "scoutsniper_mcm_letthemmove";	
	//Patience...Don't do anything stupid.
	level.scr_radio[ "scoutsniper_mcm_anythingstupid" ]			= "scoutsniper_mcm_anythingstupid";	
	//Don't move...They're not onto us...yet.
	level.scr_radio[ "scoutsniper_mcm_notontous" ]				= "scoutsniper_mcm_notontous";	
	
//ENEMY
	//Contact.
	level.scr_radio[ "scoutsniper_mcm_contact" ]				= "scoutsniper_mcm_contact";
	//Target approaching from the north.
	level.scr_radio[ "scoutsniper_mcm_targetnorth" ]			= "scoutsniper_mcm_targetnorth";
	//Target approaching from the south.
	level.scr_radio[ "scoutsniper_mcm_targetsouth" ]			= "scoutsniper_mcm_targetsouth";
	//Target approaching from the east.
	level.scr_radio[ "scoutsniper_mcm_targeteast" ]				= "scoutsniper_mcm_targeteast";
	//Target approaching from the west.
	level.scr_radio[ "scoutsniper_mcm_targetwest" ]				= "scoutsniper_mcm_targetwest";	

//STOP
	//standby
	level.scr_radio[ "scoutsniper_mcm_standby" ]				= "scoutsniper_mcm_standby";
	//Wait.
	level.scr_radio[ "scoutsniper_mcm_wait" ]					= "scoutsniper_mcm_wait";	
	//wait here!!!
	level.scr_radio[ "scoutsniper_mcm_waithere" ]				= "scoutsniper_mcm_waithere";
	//wait here
	level.scr_radio[ "scoutsniper_mcm_waithere2" ]				= "scoutsniper_mcm_waithere2";
	//stay back
	level.scr_radio[ "scoutsniper_mcm_stayback" ]				= "scoutsniper_mcm_stayback";
	//get down! now!
	level.scr_radio[ "scoutsniper_mcm_getdown" ]				= "scoutsniper_mcm_getdown";	
	//Get down.
	level.scr_radio[ "scoutsniper_mcm_getdown2" ]				= "scoutsniper_mcm_getdown2";	
	//stop
	level.scr_radio[ "scoutsniper_mcm_stop" ]					= "scoutsniper_mcm_stop";	
	//hold
	level.scr_radio[ "scoutsniper_mcm_hold" ]					= "scoutsniper_mcm_hold";	
	//hold up
	level.scr_radio[ "scoutsniper_mcm_holdup" ]					= "scoutsniper_mcm_holdup";	
	//Hold fast.
	level.scr_radio[ "scoutsniper_mcm_holdfast" ]				= "scoutsniper_mcm_holdfast";	
	//dont move
	level.scr_radio[ "scoutsniper_mcm_dontmove" ]				= "scoutsniper_mcm_dontmove";	
	//Stay low.
	level.scr_radio[ "scoutsniper_mcm_staylow2" ]				= "scoutsniper_mcm_staylow2";
	//Keep a low profile.
	level.scr_radio[ "scoutsniper_mcm_lowprofile" ]				= "scoutsniper_mcm_lowprofile";
	//Stay in the shadows.
	level.scr_radio[ "scoutsniper_mcm_inshadows" ]				= "scoutsniper_mcm_inshadows";
	//Shhh.
	level.scr_radio[ "scoutsniper_mcm_shhh" ]					= "scoutsniper_mcm_shhh";
	//Stay hidden.
	level.scr_radio[ "scoutsniper_mcm_stayhidden" ]				= "scoutsniper_mcm_stayhidden";
	
//CLEAR
	//Area clear.
	level.scr_radio[ "scoutsniper_mcm_areaclear" ]				= "scoutsniper_mcm_areaclear";
	//The coast is clear.
	level.scr_radio[ "scoutsniper_mcm_coastclear" ]				= "scoutsniper_mcm_coastclear";
	//Forward area clear.
	level.scr_radio[ "scoutsniper_mcm_forwardclear" ]			= "scoutsniper_mcm_forwardclear";
	//Clear right.
	level.scr_radio[ "scoutsniper_mcm_clearright" ]				= "scoutsniper_mcm_clearright";
	//Clear left.
	level.scr_radio[ "scoutsniper_mcm_clearleft" ]				= "scoutsniper_mcm_clearleft";
	
//GO
	//Move.
	level.scr_radio[ "scoutsniper_mcm_move" ]					= "scoutsniper_mcm_move";
	//Move up.
	level.scr_radio[ "scoutsniper_mcm_moveout" ]				= "scoutsniper_mcm_moveout";
	//Move out
	level.scr_radio[ "scoutsniper_mcm_moveup" ]					= "scoutsniper_mcm_moveup";
	//ok go
	level.scr_radio[ "scoutsniper_mcm_okgo" ]					= "scoutsniper_mcm_okgo";
	//go
	level.scr_radio[ "scoutsniper_mcm_go" ]						= "scoutsniper_mcm_go";
	//Let's go.
	level.scr_radio[ "scoutsniper_mcm_letsgo2" ]				= "scoutsniper_mcm_letsgo2";
	//this way lets go
	level.scr_radio[ "scoutsniper_mcm_letsgo" ]					= "scoutsniper_mcm_letsgo";	
	//Ready? Go!
	level.scr_radio[ "scoutsniper_mcm_readygo" ]				= "scoutsniper_mcm_readygo";	
	//On me.
	level.scr_radio[ "scoutsniper_mcm_onme" ]					= "scoutsniper_mcm_onme";
	//Follow me.
	level.scr_radio[ "scoutsniper_mcm_followme2" ]				= "scoutsniper_mcm_followme2";
	//ok lets move, nice and slow
	level.scr_radio[ "scoutsniper_mcm_niceandslow" ]			= "scoutsniper_mcm_niceandslow";

//KILLS
	//He's down.
	level.scr_radio[ "scoutsniper_mcm_hesdown" ]				= "scoutsniper_mcm_hesdown";
	//got him
	level.scr_radio[ "scoutsniper_mcm_gothim" ]					= "scoutsniper_mcm_gothim";
	//Good night.
	level.scr_radio[ "scoutsniper_mcm_goodnight" ]				= "scoutsniper_mcm_goodnight";
	//target eliminated
	level.scr_radio[ "scoutsniper_mcm_targetelim" ]				= "scoutsniper_mcm_targetelim";	
	//tango down
	level.scr_radio[ "scoutsniper_mcm_tangodown" ]				= "scoutsniper_mcm_tangodown";	
	//Beautiful.
	level.scr_radio[ "scoutsniper_mcm_beautiful" ]				= "scoutsniper_mcm_beautiful";	
	//topped him
	level.scr_radio[ "scoutsniper_mcm_toppedhim" ]				= "scoutsniper_mcm_toppedhim";	

//INTRO
	//theres too much radiation, we'll have to go around
	level.scr_radio[ "scoutsniper_mcm_radiation" ]				= "scoutsniper_mcm_radiation";
	//Follow me, and keep low.
	level.scr_radio[ "scoutsniper_mcm_followme" ]				= "scoutsniper_mcm_followme";
	//keep an eye on your dosimeter, if you're exposed too long you're dead
	level.scr_radio[ "scoutsniper_mcm_dosimeter" ]				= "scoutsniper_mcm_dosimeter";
	//Careful…there's pockets of radiation all over this area. If you absorb too much, you're a dead man.
	level.scr_radio[ "scoutsniper_mcm_deadman" ]				= "scoutsniper_mcm_deadman";
	//Are you daft? Stay out of the radioactive areas.
	level.scr_radio[ "scoutsniper_mcm_youdaft" ]				= "scoutsniper_mcm_youdaft";
	
	//Contact.  Enemy patrol dead ahead.  
	level.scr_radio[ "scoutsniper_mcm_deadahead" ]				= "scoutsniper_mcm_deadahead";
	//Stay low and move slowly, we'll be impossible to spot in our ghillie suits.
	level.scr_radio[ "scoutsniper_mcm_staylow" ]				= "scoutsniper_mcm_staylow";
	//Take one out when the other's not looking.
	level.scr_radio[ "scoutsniper_mcm_notlooking" ]				= "scoutsniper_mcm_notlooking";
	//There's more cover if we go around.
	level.scr_radio[ "scoutsniper_mcm_goaround" ]				= "scoutsniper_mcm_goaround";
	//Four tangos inside. 
	level.scr_radio[ "scoutsniper_mcm_4tangos" ]				= "scoutsniper_mcm_4tangos";
	//Don't even think about it…
	level.scr_radio[ "scoutsniper_mcm_donteven" ]				= "scoutsniper_mcm_donteven";
	//Wait there. Tango by the car.
	level.scr_radio[ "scoutsniper_mcm_tangobycar" ]				= "scoutsniper_mcm_tangobycar";
	//Take him out quietly, or just let him pass. Your call.
	level.scr_radio[ "scoutsniper_mcm_yourcall" ]				= "scoutsniper_mcm_yourcall";
	//He's going back inside.
	level.scr_radio[ "scoutsniper_mcm_backinside" ]				= "scoutsniper_mcm_backinside"; 

//CHURCH
	//We've got a lookout in the church tower…
	level.scr_radio[ "scoutsniper_mcm_churchtower" ]			= "scoutsniper_mcm_churchtower"; 
	//...and a patrol coming from the north.
	level.scr_radio[ "scoutsniper_mcm_patrolnorth" ]			= "scoutsniper_mcm_patrolnorth"; 
	//Nice shot. But there's still a patrol coming from the north.
	level.scr_radio[ "scoutsniper_mcm_niceshot" ]				= "scoutsniper_mcm_niceshot";
	//Let's move up for a better view.
	level.scr_radio[ "scoutsniper_mcm_betterview" ]				= "scoutsniper_mcm_betterview";
	//Do you have a shot on the lookout?
	level.scr_radio[ "scoutsniper_mcm_haveashot" ]				= "scoutsniper_mcm_haveashot";
	//He's in the tower.
	level.scr_radio[ "scoutsniper_mcm_inthetower" ]				= "scoutsniper_mcm_inthetower";
	//The other tower. // wrong tower // square tower
	level.scr_radio[ "scoutsniper_mcm_wrongtower" ]				= "scoutsniper_mcm_wrongtower";	
	//Bloody hell, the lookout's gonna see the body.
	level.scr_radio[ "scoutsniper_mcm_seethebody" ]				= "scoutsniper_mcm_seethebody";
	//I guess he can't see the body from there. Whooh, that was a close one.
	level.scr_radio[ "scoutsniper_mcm_closeone" ]				= "scoutsniper_mcm_closeone";
	//The patrol won't be back for a while, here's our chance.
	level.scr_radio[ "scoutsniper_mcm_ourchance" ]				= "scoutsniper_mcm_ourchance";
	//Get ready to move. Wait for the spotter to turn around.
	level.scr_radio[ "scoutsniper_mcm_turnaround" ]				= "scoutsniper_mcm_turnaround";
	
//GRAVE
	//you hear that?
	level.scr_radio[ "scoutsniper_mcm_hearthat" ]				= "scoutsniper_mcm_hearthat";
	//Enemy helicopter, get down!
	level.scr_radio[ "scoutsniper_mcm_enemyheli" ]				= "scoutsniper_mcm_enemyheli";	
	//He's circling back around. Don't...move.
	level.scr_radio[ "scoutsniper_mcm_circlingback" ]			= "scoutsniper_mcm_circlingback";
	
//FIELD
	//Easy lad... There’s too many of them, let them go. Keep a low profile and hold your fire.
	level.scr_radio[ "scoutsniper_mcm_holdyourfire" ]			= "scoutsniper_mcm_holdyourfire";	
	//Try to anticipate their paths.
	level.scr_radio[ "scoutsniper_mcm_anticipatepaths" ]		= "scoutsniper_mcm_anticipatepaths";	
	//If you have to maneuver, do it slow and steady, no quick movements.
	level.scr_radio[ "scoutsniper_mcm_slowandsteady" ]			= "scoutsniper_mcm_slowandsteady";	
	
	
//POND
	//Looks like they’ve already eliminated the men they couldn’t buy out.
	level.scr_radio[ "scoutsniper_mcm_buyout" ]					= "scoutsniper_mcm_buyout";	
	//Taking 'em out without alerting the rest isn't going to be easy...
	level.scr_radio[ "scoutsniper_mcm_withoutalerting" ]		= "scoutsniper_mcm_withoutalerting";
	//...But then again, neither is sneaking past them.
	level.scr_radio[ "scoutsniper_mcm_sneakingpast" ]			= "scoutsniper_mcm_sneakingpast";
	//Your call.
	level.scr_radio[ "scoutsniper_mcm_yourcall2" ]				= "scoutsniper_mcm_yourcall2";
	//Don't fire on the two by the truck.
	level.scr_radio[ "scoutsniper_mcm_dontfire" ]				= "scoutsniper_mcm_dontfire";
	//We'll have to take 'em out at the same time.
	level.scr_radio[ "scoutsniper_mcm_sametime" ]				= "scoutsniper_mcm_sametime";
	//Wait for me to get into position.
	level.scr_radio[ "scoutsniper_mcm_waitforme" ]				= "scoutsniper_mcm_waitforme";
	//wait for me
	level.scr_radio[ "scoutsniper_mcm_waitforme2" ]				= "scoutsniper_mcm_waitforme2";
	//I'm in position - take the shot when you're ready.
	level.scr_radio[ "scoutsniper_mcm_whenyoureready" ]			= "scoutsniper_mcm_whenyoureready";
	//Hold your fire. I'm moving to a new position.
	level.scr_radio[ "scoutsniper_mcm_holdyourfiremoving" ]		= "scoutsniper_mcm_holdyourfiremoving";
	//In position.
	level.scr_radio[ "scoutsniper_mcm_inposition" ]				= "scoutsniper_mcm_inposition";
	level.scr_radio[ "scoutsniper_mcm_ateam" ]					= "scoutsniper_mcm_ateam";
	
	
//CARGO
	//Wait a moment, and observe the situation	
	level.scr_radio[ "scoutsniper_mcm_observe" ]				= "scoutsniper_mcm_observe";
	//Are you insane?
	level.scr_radio[ "scoutsniper_mcm_youinsane" ]				= "scoutsniper_mcm_youinsane";
	//I'll say one thing, you certainly got the minerals.
	level.scr_radio[ "scoutsniper_mcm_gotminerals" ]			= "scoutsniper_mcm_gotminerals";
	//Oi, Suzy!
	level.scr_radio[ "scoutsniper_mcm_oisuzy" ]					= "scoutsniper_mcm_oisuzy";
	//Patrol coming this way, stay back.
	level.scr_radio[ "scoutsniper_mcm_patrolthisway" ]			= "scoutsniper_mcm_patrolthisway";
	//We should wait a bit, let's see if the patroller makes another pass…
	level.scr_radio[ "scoutsniper_mcm_anotherpass" ]			= "scoutsniper_mcm_anotherpass";
	//That's how it's done, lets go.
	level.scr_radio[ "scoutsniper_mcm_howitsdone" ]				= "scoutsniper_mcm_howitsdone";
	//Stay low, he's mine.
	level.scr_radio[ "scoutsniper_mcm_hesmine" ]				= "scoutsniper_mcm_hesmine";
	
//DASH
	//hooooold....
	level.scr_radio[ "scoutsniper_mcm_hoooold" ]				= "scoutsniper_mcm_hoooold";
	//It's a bloody convention out there. Get ready to move on my signal. Stay right behind me.
	level.scr_radio[ "scoutsniper_mcm_mysignal" ]				= "scoutsniper_mcm_mysignal";	
	//Standby. Standby... Go!
	level.scr_radio[ "scoutsniper_mcm_standbygo" ]				= "scoutsniper_mcm_standbygo";
	//Get ready to move. Stick with me.
	level.scr_radio[ "scoutsniper_mcm_stickwithme" ]			= "scoutsniper_mcm_stickwithme";
	//There's a truck coming...we'll use it as cover, keep moving.
	level.scr_radio[ "scoutsniper_mcm_useascover" ]				= "scoutsniper_mcm_useascover";
	//Just wait here a moment.  When they leave, crawl out and stay low.
	level.scr_radio[ "scoutsniper_mcm_crawlout" ]				= "scoutsniper_mcm_crawlout";
	//Sniper. Fire escape, 4th floor, dead ahead.
	level.scr_radio[ "scoutsniper_mcm_sniperahead" ]			= "scoutsniper_mcm_sniperahead";
	//Take him out, or he'll give away our position
	level.scr_radio[ "scoutsniper_mcm_giveaway" ]				= "scoutsniper_mcm_giveaway";
	//Do you see the sniper?  4th floor, fire escape. (nags)
	level.scr_radio[ "scoutsniper_mcm_topbalcony" ]				= "scoutsniper_mcm_topbalcony";
	level.scr_radio[ "scoutsniper_mcm_noonesaw" ]				= "scoutsniper_mcm_noonesaw";
	
	
	

//TOWN
	//Look at this place... Fifty thousand people used to live in this city. 
	//Now it's a ghost town... I've never seen anything like it.
	level.scr_radio[ "scoutsniper_mcm_ghosttown" ]				= "scoutsniper_mcm_ghosttown";
	//Don't let your guard down. We're not there yet.
	level.scr_radio[ "scoutsniper_mcm_notthereyet" ]			= "scoutsniper_mcm_notthereyet";

//DOGS
	//That doesn't sound good…
	level.scr_radio[ "scoutsniper_mcm_soundgood" ]				= "scoutsniper_mcm_soundgood";
	//Whew, that was close.
	level.scr_radio[ "scoutsniper_mcm_whew" ]					= "scoutsniper_mcm_whew";
	//Leave it alone. It's a wild dog. 
	level.scr_radio[ "scoutsniper_mcm_wilddog" ]				= "scoutsniper_mcm_wilddog";
	level.scr_radio[ "scoutsniper_mcm_pooch" ]					= "scoutsniper_mcm_pooch";
	level.scr_radio[ "scoutsniper_mcm_noneed" ]					= "scoutsniper_mcm_noneed";
	
	
//END
	//There's the hotel. We should be able to observe the exchange from the top floor up there. Let's move.
	
	level.scr_radio[ "scoutsniper_mcm_thereshotel" ]			= "scoutsniper_mcm_thereshotel";
}

patrol()
{
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
	
	/*
	level.scr_anim[ "generic" ][ "_stealth_behavior_whizby_0" ]			= %exposed_idle_reactA;
	level.scr_anim[ "generic" ][ "_stealth_behavior_whizby_1" ]			= %exposed_idle_reactB;
	level.scr_anim[ "generic" ][ "_stealth_behavior_whizby_2" ]			= %exposed_idle_twitch;
	level.scr_anim[ "generic" ][ "_stealth_behavior_whizby_3" ]			= %exposed_idle_twitch_v4;
	level.scr_anim[ "generic" ][ "_stealth_behavior_whizby_4" ]			= %run_pain_stumble;
	
	level.scr_anim[ "generic" ][ "_stealth_behavior_spotted_short" ]		= %exposed_idle_twitch_v4;//patrol_bored_2_combat_alarm_short;
	level.scr_anim[ "generic" ][ "_stealth_behavior_spotted_long" ]			= %exposed_idle_twitch_v4;
	
	level.scr_anim[ "generic" ][ "_stealth_behavior_heard_scream" ]			= %exposed_idle_twitch_v4;
	*/	
}

#using_animtree("dog");
dog()
{
	level.scr_anim[ "generic" ][ "dog_idle" ][0]			= %german_shepherd_attackidle;		
	level.scr_anim[ "generic" ][ "dog_eating" ][0]			= %german_shepherd_eating;		
	level.scr_anim[ "generic" ][ "dog_eating_single" ]		= %german_shepherd_eating;		
	level.scr_anim[ "generic" ][ "dog_growling" ][0]		= %german_shepherd_attackidle_growl;	
	
	level.scr_anim[ "generic" ][ "dog_barking" ][0]			= %german_shepherd_attackidle_growl;
	level.scr_anim[ "generic" ][ "dog_barking" ][1]			= %german_shepherd_attackidle_bark;	
	level.scr_anim[ "generic" ][ "dog_barking" ][2]			= %german_shepherd_attackidle_bark;	
	level.scr_anim[ "generic" ][ "dog_barking" ][3]			= %german_shepherd_attackidle_bark;	
}