#include maps\_utility;
#include animscripts\Combat_utility;
#include animscripts\utility;
#using_animtree ("generic_human");

// (Note that animations called left are used with right corner nodes, and vice versa.)

main()
{
	self.animArrayFuncs = [];
	self.animArrayFuncs["hiding"]["stand"] = ::set_animarray_standing_right;
	self.animArrayFuncs["hiding"]["crouch"] = ::set_animarray_crouching_right;
	
    self trackScriptState( "Cover Right Main", "code" );
	self endon("killanimscript");
    animscripts\utility::initialize("cover_right");

	animscripts\corner::corner_think( "right" );
}


set_animarray_standing_right() /* void */
{
	array = [];

	array["alert_idle"] = %corner_standR_alert_idle;
	array["alert_idle_twitch"] = array(
		%corner_standR_alert_twitch01,
		%corner_standR_alert_twitch02,
		%corner_standR_alert_twitch03,
		%corner_standR_alert_twitch04,
		%corner_standR_alert_twitch05,
		%corner_standR_alert_twitch06,
		%corner_standR_alert_twitch07
	);
	array["alert_idle_flinch"] = array( %corner_standR_flinch, %corner_standR_flinchB );
	
	//array["alert_to_C"] = %corner_standR_trans_alert_2_C;
	//array["B_to_C"] = %corner_standR_trans_B_2_C;
	//array["C_to_alert"] = %corner_standR_trans_C_2_alert;
	//array["C_to_B"] = %corner_standR_trans_C_2_B;
	array["alert_to_A"] = array( %corner_standR_trans_alert_2_A, %corner_standR_trans_alert_2_A_v2 );
	array["alert_to_B"] = array( %corner_standR_trans_alert_2_B, %corner_standR_trans_alert_2_B_v2, %corner_standR_trans_alert_2_B_v3 );
	array["A_to_alert"] = array( %corner_standR_trans_A_2_alert, %corner_standR_trans_A_2_alert_v2 );
	array["A_to_alert_reload"] = array();
	array["A_to_B"    ] = array( %corner_standR_trans_A_2_B    , %corner_standR_trans_A_2_B_v2     );
	array["B_to_alert"] = array( %corner_standR_trans_B_2_alert, %corner_standR_trans_B_2_alert_v2, %corner_standR_trans_B_2_alert_v3 );
 	array["B_to_alert_reload"] = array( %corner_standR_reload_B_2_alert );
	array["B_to_A"    ] = array( %corner_standR_trans_B_2_A    , %corner_standR_trans_B_2_A_v2     );
	array["lean_to_alert"] = array( %CornerStndR_lean_2_alert );
	array["alert_to_lean"] = array( %CornerStndR_alert_2_lean );
	array["look"] = %corner_standR_look;
	array["reload"] = array( %corner_standR_reload_v1 ); // , %corner_standR_reload_v2 ); // v2 isn't finished, it seems
	array["grenade_exposed"] = %corner_standR_grenade_A;
	array["grenade_safe"] = %corner_standR_grenade_B;
	
	array["blind_fire"] = array( %corner_standR_blindfire_v1, %corner_standR_blindfire_v2 );
	
	array["rambo"] = array( %corner_standR_rambo_dive_v1, %corner_standR_rambo_dive_v2, %corner_standR_rambo_jam, %corner_standR_rambo_short, %corner_standR_rambo_med );

	array["alert_to_look"] = %corner_standR_alert_2_look;
	array["look_to_alert"] = %corner_standR_look_2_alert;
	array["look_to_alert_fast"] = %corner_standR_look_2_alert_fast;
	array["look_idle"] = %corner_standR_look_idle;
	array["stance_change"] = %CornerCrR_stand_2_alert;

	array["lean_aim_down"] = %CornerStndR_lean_aim_2;
	array["lean_aim_left"] = %CornerStndR_lean_aim_4;
	array["lean_aim_straight"] = %CornerStndR_lean_aim_5;
	array["lean_aim_right"] = %CornerStndR_lean_aim_6;
	array["lean_aim_up"] = %CornerStndR_lean_aim_8;
	array["lean_reload"] = %CornerStndR_lean_reload;
	
	array["lean_idle"] = array( %CornerStndR_lean_idle );

	array["lean_single"] = %CornerStndR_lean_fire;
	//array["lean_burst"] = %CornerStndR_lean_autoburst;
	array["lean_fire"] = %CornerStndR_lean_auto;

	self.hideYawOffset = -90;
	self.a.array = array;
}

set_animarray_crouching_right()
{
	array = [];
	
	array["alert_idle"] = %CornerCrR_alert_idle;
	array["alert_idle_twitch"] = array(
		%CornerCrR_alert_twitch_v1,
		%CornerCrR_alert_twitch_v2,
		%CornerCrR_alert_twitch_v3
	);
	array["alert_idle_flinch"] = array();

	//array["alert_to_C"] = %CornerCrR_trans_alert_2_C;
	//array["B_to_C"] = %CornerCrR_trans_B_2_C;
	//array["C_to_alert"] = %CornerCrR_trans_C_2_alert;
	//array["C_to_B"] = %CornerCrR_trans_C_2_B;
	array["alert_to_A"] = array( %CornerCrR_trans_alert_2_A );
	array["alert_to_B"] = array( %CornerCrR_trans_alert_2_B );
	array["A_to_alert"] = array( %CornerCrR_trans_A_2_alert );
	array["A_to_alert_reload"] = array();
	array["A_to_B"    ] = array( %CornerCrR_trans_A_2_B     );
	array["B_to_alert"] = array( %CornerCrR_trans_B_2_alert );
 	array["B_to_alert_reload"] = array( %CornerCrR_reload_B_2_alert );
	array["B_to_A"    ] = array( %CornerCrR_trans_B_2_A     );
	array["reload"] = array( %CornerCrR_reloadA, %CornerCrR_reloadB );
	array["grenade_exposed"] = %CornerCrR_grenadeA;
	array["grenade_safe"] = %CornerCrR_grenadeA; // TODO: need a unique animation for this; use the exposed throw because not having it limits the options of the AI too much
	
	array["blind_fire"] = array();

	array["rambo"] = array();
	
	array["alert_to_look"] = %CornerCrR_alert_2_look;
	array["look_to_alert"] = %CornerCrR_look_2_alert;
	array["look_to_alert_fast"] = %CornerCrR_look_2_alert_fast; // there's a v2 we could use for this also if we want
	array["look_idle"] = %CornerCrR_look_idle;
	array["stance_change"] = %CornerCrR_alert_2_stand;

	
	self.hideYawOffset = -90;
	self.a.array = array;
}


