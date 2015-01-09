#include maps\_anim;
#using_animtree("generic_human");

main()
{
	anims();
	run_anims();
	dialogue();
}

anims()
{
	// Crash
	level.scr_anim[ "price" ][ "hunted_opening_price" ] =					%hunted_opening_price;
	addNotetrack_dialogue( "price", "dialog" ,"hunted_opening_price", "hunted_pri_onepiece" );
	addNotetrack_dialogue( "price", "dialog" ,"hunted_opening_price", "hunted_pri_getup" );
	addNotetrack_dialogue( "price", "dialog" ,"hunted_opening_price", "hunted_pri_comeonsearchparties" );

	level.scr_anim[ "dead_guy" ][ "hunted_dying" ] =				%hunted_dying_deadguy;
	level.scr_anim[ "dead_guy" ][ "hunted_dying_endidle" ][0] =		%hunted_dying_deadguy_endidle;
	level.scr_anim[ "steve" ][ "hunted_dying" ] =					%hunted_dying_soldier;

	// Dirt path 
	level.scr_anim[ "price" ][ "hunted_wave_chat" ] =				%hunted_wave_chat;
	addNotetrack_dialogue( "price", "dialog" ,"hunted_wave_chat", "hunted_pri_underbridge" );
	level.scr_anim[ "charlie" ][ "hunted_wave_chat" ] =				%hunted_spotter_wave_chat;
	addNotetrack_dialogue( "charlie", "dialog" ,"hunted_wave_chat", "hunted_sas2_vehiclesnorth" );
	level.scr_anim[ "charlie" ][ "hunted_spotter_idle" ][0] =		%hunted_spotter_idle;
	level.scr_anim[ "charlie" ][ "hunted_spotter_idle" ][1] =		%hunted_spotter_twitch;

	// Tunnel
	level.scr_anim[ "mark" ][ "hunted_tunnel_guy1_runin" ] =		%hunted_tunnel_guy1_runin;
	level.scr_anim[ "mark" ][ "hunted_tunnel_guy1_idle" ][0] =		%hunted_tunnel_guy1_idle;
	level.scr_anim[ "mark" ][ "hunted_tunnel_guy1_lookup" ] =		%hunted_tunnel_guy1_lookup;
	level.scr_anim[ "mark" ][ "hunted_tunnel_guy1_runout" ] =		%hunted_tunnel_guy1_runout;
	level.scr_anim[ "price" ][ "hunted_tunnel_guy2_runin" ] =		%hunted_tunnel_guy2_runin;
	level.scr_anim[ "price" ][ "hunted_tunnel_guy2_idle" ][0] =		%hunted_tunnel_guy2_idle;
	level.scr_anim[ "price" ][ "hunted_tunnel_guy2_runout" ] =		%hunted_tunnel_guy2_runout;
	level.scr_sound[ "price" ][ "hunted_tunnel_guy2_runout" ]		= "hunted_pri_letsmove";
	level.scr_anim[ "price" ][ "hunted_tunnel_guy2_runout_interrupt" ] =		%hunted_tunnel_guy2_runout;

	// Barn and small farm
	level.scr_anim[ "price" ][ "hunted_open_barndoor" ] =			%hunted_open_barndoor;
	level.scr_sound[ "price" ][ "hunted_open_barndoor" ]			= "hunted_pri_holdup";
	level.scr_anim[ "price" ][ "hunted_open_barndoor_stop" ] =		%hunted_open_barndoor_stop;
	level.scr_anim[ "price" ][ "hunted_open_barndoor_idle" ][0] =	%hunted_open_barndoor_idle;
	level.scr_anim[ "price" ][ "hunted_open_barndoor_nodialogue" ] =	%hunted_open_barndoor;

	level.scr_anim[ "mark" ][ "door_kick_in" ] =					%doorkick_2_cqbwalk;

	level.scr_anim[ "leader" ][ "hunted_farmsequence" ] =			%hunted_farmsequence_leader;
	level.scr_anim[ "farmer" ][ "hunted_farmsequence" ] =			%hunted_farmsequence_farmer;
	level.scr_anim[ "thug" ][ "hunted_farmsequence" ] =				%hunted_farmsequence_brute1;
	level.scr_anim[ "thug2" ][ "hunted_farmsequence" ] =			%hunted_farmsequence_brute2;

	level.scr_anim[ "farmer" ][ "farmer_deathpose" ][0] =			%hunted_farmsequence_farmer_deathpose;

	level.scr_anim[ "farmer" ][ "farmer_altending" ] =				%hunted_farmsequence_farmer_altending;

	level.scr_anim[ "farmer" ][ "hack_idle" ][0] =					%hunted_pronehide_idle_v3;

	addNotetrack_dialogue( "leader", "dialog" ,"hunted_farmsequence", "hunted_ru1_dontplaystupid" );
	addNotetrack_dialogue( "leader", "dialog" ,"hunted_farmsequence", "hunted_ru1_hidingsoldiers" );
	addNotetrack_dialogue( "leader", "dialog" ,"hunted_farmsequence", "hunted_ru1_forgetit" );

	addNotetrack_dialogue( "farmer", "dialog" ,"hunted_farmsequence", "hunted_ruf_whatsgoingon" );
	addNotetrack_dialogue( "farmer", "dialog" ,"hunted_farmsequence", "hunted_ruf_hidingwho" );
	addNotetrack_dialogue( "farmer", "dialog" ,"hunted_farmsequence", "hunted_ruf_british" );

	// Field
	level.scr_anim[ "price" ][ "hunted_dive_2_pronehide" ] =		%hunted_dive_2_pronehide_v1;
	level.scr_anim[ "price" ][ "hunted_pronehide_idle" ][0] =		%hunted_pronehide_idle_v1;
	level.scr_anim[ "price" ][ "hunted_pronehide_2_stand" ] =		%hunted_pronehide_2_stand_v1;
	level.scr_anim[ "mark" ][ "hunted_dive_2_pronehide" ] =			%hunted_dive_2_pronehide_v1;
	level.scr_anim[ "mark" ][ "hunted_pronehide_idle" ][0] =		%hunted_pronehide_idle_v1;
	level.scr_anim[ "mark" ][ "hunted_pronehide_2_stand" ] =		%hunted_pronehide_2_stand_v1;
	level.scr_anim[ "steve" ][ "hunted_dive_2_pronehide" ] =		%hunted_dive_2_pronehide_v2;
	level.scr_anim[ "steve" ][ "hunted_pronehide_idle" ][0] =		%hunted_pronehide_idle_v2;
	level.scr_anim[ "steve" ][ "hunted_pronehide_2_stand" ] =		%hunted_pronehide_2_stand_v2;
	level.scr_anim[ "charlie" ][ "hunted_dive_2_pronehide" ] =		%hunted_dive_2_pronehide_v3;
	level.scr_anim[ "charlie" ][ "hunted_pronehide_idle" ][0] =		%hunted_pronehide_idle_v3;
	level.scr_anim[ "charlie" ][ "hunted_pronehide_2_stand" ] =		%hunted_pronehide_2_stand_v3;

	level.scr_anim[ "mark" ][ "hunted_open_basement_door_kick" ] =		%hunted_open_basement_door_kick;

	// Basement
	level.scr_anim[ "price" ][ "hunted_basement_door_block" ] =		%hunted_basement_door_block;

	// creek
	level.scr_anim[ "price" ][ "hunted_open_creek_gate_stop" ] =	%hunted_open_barndoor_stop;
	level.scr_anim[ "price" ][ "hunted_open_creek_gate" ] =			%hunted_open_barndoor;

	level.scr_anim[ "guard1" ][ "roadblock_sequence" ] =			%hunted_roadblock_guy1_sequence;
	level.scr_anim[ "guard1" ][ "roadblock_startidle" ][0] =		%hunted_roadblock_guy1_startidle;
	level.scr_anim[ "guard2" ][ "roadblock_sequence" ] =			%hunted_roadblock_guy2_sequence;
	level.scr_anim[ "guard2" ][ "roadblock_startidle" ][0] =		%hunted_roadblock_guy2_startidle;

	// greenhouse
	level.scr_anim[ "price" ][ "hunted_open_big_barn_gate_stop" ] =	%hunted_open_barndoor_stop;
	level.scr_anim[ "price" ][ "hunted_open_big_barn_gate" ] = %hunted_open_barndoor;

	// ac130
	level.scr_anim[ "mark" ][ "hunted_celebrate" ] =	%hunted_celebrate;
	level.scr_sound[ "mark" ][ "hunted_celebrate" ] =	"hunted_uk2_outrageous";

	level.scr_anim[ "steve" ][ "hunted_celebrate" ] =	%hunted_celebrate_v2;

	level.scr_anim[ "charlie" ][ "hunted_celebrate" ] =	%hunted_celebrate_v3;

	level.scr_anim[ "dead_guy" ][ "death1" ]				= %exposed_death_nerve;
	level.scr_anim[ "dead_guy" ][ "death2" ]				= %exposed_death_falltoknees;
	level.scr_anim[ "dead_guy" ][ "death3" ]				= %exposed_death_headtwist;
	level.scr_anim[ "dead_guy" ][ "death4" ]				= %exposed_crouch_death_twist;
	level.scr_anim[ "dead_guy" ][ "death5" ]				= %exposed_crouch_death_fetal;
	level.scr_animtree[ "dead_guy" ] 						= #animtree;	

}

run_anims()
{
	level.scr_anim[ "price" ][ "path_slow" ] =				%huntedrun_1_idle;
	level.scr_anim[ "price" ][ "path_slow_left" ] =			%huntedrun_1_look_left;
	level.scr_anim[ "price" ][ "path_slow_right" ] =		%huntedrun_1_look_right;
	level.scr_anim[ "price" ][ "sprint" ] =					%sprint1_loop;

	level.scr_anim[ "mark" ][ "path_slow" ] =				%huntedrun_1_idle;
	level.scr_anim[ "mark" ][ "sprint" ] =					%sprint1_loop;

	level.scr_anim[ "steve" ][ "path_slow" ] =				%huntedrun_2;
	level.scr_anim[ "steve" ][ "sprint" ] =					%sprint1_loop;

	level.scr_anim[ "charlie" ][ "path_slow" ] =			%huntedrun_1_idle;
	level.scr_anim[ "charlie" ][ "sprint" ] =				%sprint1_loop;

	level.scr_anim[ "thug" ][ "walk_slow" ] =				%huntedrun_2;

	level.scr_anim[ "farmer" ][ "walk" ] =					%huntedrun_1_idle;

	level.scr_anim[ "guard1" ][ "patrolwalk" ] =			%active_patrolwalk_v1;
	level.scr_anim[ "guard2" ][ "patrolwalk" ] =			%active_patrolwalk_v2;

	level.scr_anim[ "axis" ][ "patrolwalk_1" ] =			%active_patrolwalk_v1;
	level.scr_anim[ "axis" ][ "patrolwalk_2" ] =			%active_patrolwalk_v2;
	level.scr_anim[ "axis" ][ "patrolwalk_3" ] =			%active_patrolwalk_v3;
	level.scr_anim[ "axis" ][ "patrolwalk_4" ] =			%active_patrolwalk_v4;
	level.scr_anim[ "axis" ][ "patrolwalk_5" ] =			%active_patrolwalk_v5;
	level.scr_anim[ "axis" ][ "patrolwalk_pause" ] =		%active_patrolwalk_pause;
	level.scr_anim[ "axis" ][ "patrolwalk_turn" ] =			%active_patrolwalk_turn_180;

	level.scr_anim[ "axis" ][ "patrolwalk_nolight" ] =		%huntedrun_1_idle;

	level.scr_anim[ "axis" ][ "dazed_0" ] =					%hunted_dazed_walk_A_zombie;
	level.scr_anim[ "axis" ][ "dazed_1" ] =					%hunted_dazed_walk_A_zombie;
	level.scr_anim[ "axis" ][ "dazed_2" ] =					%hunted_dazed_walk_B_blind;
	level.scr_anim[ "axis" ][ "dazed_3" ] =					%hunted_dazed_walk_B_blind;
	level.scr_anim[ "axis" ][ "dazed_4" ] =					%hunted_dazed_walk_C_limp;
}

dialogue()
{
	// crash
	level.scr_sound[ "price" ][ "youallright" ] =			"hunted_pri_youallright";
	level.scr_sound[ "price" ][ "casualtyreport" ] =		"hunted_pri_casualtyreport";
	level.scr_sound[ "mark" ][ "bothpilotsdead" ] =			"hunted_uk2_bothpilotsdead";
	level.scr_sound[ "price" ][ "bugger" ] =				"hunted_pri_bugger";
	level.scr_sound[ "price" ][ "extractionpoint" ] =		"hunted_pri_extractionpoint";

	level.scr_radio[ "hunted_price_ac130_inbound" ] =		"hunted_price_ac130_inbound";
	level.scr_sound[ "price" ][ "hunted_pri_copy" ] =		"hunted_pri_copy";
	level.scr_sound[ "mark" ][ "hunted_uk2_ac130" ] =		"hunted_uk2_ac130";

	// path
	level.scr_sound[ "price" ][ "lowprofile" ] =			"hunted_pri_lowprofile";

	// barn
	level.scr_sound[ "price" ][ "killoldman" ] =			"hunted_pri_killoldman";
	level.scr_sound[ "price" ][ "keepmoving" ] =			"hunted_pri_keepmoving";
	level.scr_sound[ "mark" ][ "areaclear" ] =				"hunted_uk2_areaclear";

	level.scr_sound[ "price" ][ "holdfire" ] =				"hunted_pri_holdfire";

	level.scr_sound[ "generic" ][ "hunted_ru1_isadump" ] =	"hunted_ru1_isadump";
	level.scr_sound[ "generic" ][ "laugh1" ] =				"hunted_ru1_laugh";
	level.scr_sound[ "generic" ][ "laugh2" ] =				"hunted_ru2_laugh";

	// field
	level.scr_sound[ "price" ][ "hitdeck" ] =				"hunted_pri_hitdeck";

	level.scr_sound[ "generic" ][ "bythehouse" ] =			"hunted_ru1_bythehouse";		

	level.scr_sound[ "price" ][ "staydown" ] =				"hunted_pri_staydown";
	level.scr_sound[ "price" ][ "helismoving" ] =			"hunted_pri_helismoving";
	level.scr_sound[ "price" ][ "ontous" ] =				"hunted_pri_ontous";

	level.scr_sound[ "price" ][ "returnfire2" ] =			"hunted_pri_returnfire2";

	level.scr_sound[ "price" ][ "basementdooropen2" ] =		"hunted_pri_basementdooropen2";

	level.scr_sound[ "price" ][ "getinhouse" ] =			"hunted_pri_getinhouse";
	level.scr_sound[ "price" ][ "whatwaitingfor" ] =		"hunted_pri_whatwaitingfor";
	level.scr_sound[ "price" ][ "getinbasement" ] =			"hunted_pri_getinbasement";

	level.scr_sound[ "mark" ][ "contact6oclock" ] =			"hunted_uk2_contact6oclock";
	level.scr_sound[ "mark" ][ "imonit" ] =					"hunted_uk2_imonit";
	level.scr_sound[ "mark" ][ "doorsopen" ] =				"hunted_uk2_doorsopen";

	// basement
	level.scr_sound[ "price" ][ "takepoint" ] =				"hunted_pri_takepoint";
	level.scr_sound[ "mark" ][ "warn_flashbang" ] =			"hunted_uk2_flashbang";

	// farm
	level.scr_sound[ "charlie" ][ "tooquiet" ] =			"hunted_sas2_tooquiet";
	level.scr_sound[ "mark" ][ "regrouping" ] =				"hunted_uk2_regrouping";
	level.scr_sound[ "price" ][ "staysharp" ] =				"hunted_pri_staysharp";
	// hunted_sas2_tooquiet

	// creek
	level.scr_sound[ "mark" ][ "helicoptersback" ] =		"hunted_uk2_helicoptersback";
	level.scr_sound[ "price" ][ "keepitthatway" ] =			"hunted_pri_keepitthatway";
	level.scr_sound[ "price" ][ "presson" ] =				"hunted_pri_presson";
	level.scr_sound[ "price" ][ "sentriesatbridge" ]		= "hunted_pri_sentriesatbridge";
	level.scr_sound[ "price" ][ "outofspotlight" ]			= "hunted_pri_outofspotlight";
	level.scr_sound[ "price" ][ "staylow" ]					= "hunted_pri_staylow";
	level.scr_sound[ "price" ][ "moveit" ]					= "hunted_pri_moveit";
	level.scr_sound[ "price" ][ "endoffield" ]				= "hunted_pri_endoffield";
	level.scr_sound[ "price" ][ "watchhelicopter" ]			= "hunted_pri_watchhelicopter";

	level.scr_sound[ "mark" ][ "hunted_uk2_werecompromised" ] =	"hunted_uk2_werecompromised";

//	russian dialogue
	level.scr_sound[ "generic" ][ "hunted_ru2_bythecreek" ]	= "hunted_ru2_bythecreek";
	level.scr_sound[ "generic" ][ "hunted_ru1_inthefield" ]	= "hunted_ru1_inthefield";
	level.scr_sound[ "generic" ][ "hunted_ru4_outonfield" ]	= "hunted_ru4_outonfield";

	// greenhouse
	level.scr_sound[ "price" ][ "anotherpass" ] =			"hunted_pri_anotherpass";
	level.scr_sound[ "mark" ][ "missilesinbarn" ] =			"hunted_uk2_missilesinbarn";
	level.scr_sound[ "price" ][ "takeoutchopper" ] =		"hunted_pri_takeoutchopper";

	level.scr_sound[ "mark" ][ "hunted_uk2_poppingflares" ] =	"hunted_uk2_poppingflares";
	level.scr_sound[ "mark" ][ "hunted_uk2_fireagain" ] =		"hunted_uk2_fireagain";

	level.scr_sound[ "mark" ][ "niceshooting" ] =			"hunted_uk2_niceshooting";
	level.scr_sound[ "price" ][ "everyoneonme" ] =			"hunted_pri_everyoneonme";

	// ac130
	level.scr_sound[ "mark" ][ "bringingintanks" ] =		"hunted_uk2_bringingintanks";
	level.scr_sound[ "price" ][ "blockedpath" ] =			"hunted_pri_blockedpath";
	level.scr_radio[ "requestfire" ] =						"hunted_hqr_requestfire";
//	level.scr_sound[ "mark" ][ "airsupport" ] =				"hunted_uk2_airsupport";

	level.scr_radio[ "usesomehelp" ] =						"hunted_acc_usesomehelp";
	level.scr_sound[ "price" ][ "100metres" ] =				"hunted_pri_100metres";
	level.scr_radio[ "comindown" ] =						"hunted_acc_comindown";

	level.scr_radio[ "getmovin" ] =							"hunted_acc_getmovin";
	level.scr_sound[ "price" ][ "comeonletsgo" ] =			"hunted_pri_comeonletsgo";

}


/*
// These lines are not needed as the crash drowns out any dialogue when they would play.
hunted_hp1_maydaymayday
hunted_hp1_goingdown

*/