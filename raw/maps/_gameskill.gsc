#include maps\_utility;
#include animscripts\utility;
#include common_scripts\utility;
// this script handles all major global gameskill considerations
setSkill( reset, skill_override )
{
	if ( !isdefined( level.script ) )
		level.script = tolower( getdvar( "mapname" ) );


	if ( !isdefined( reset ) || reset == false )
	{
		if ( isdefined( level.gameSkill ) )
			return;
			
		if ( !isdefined( level.custom_player_attacker ) )
			level.custom_player_attacker = ::return_false;
			
		level.global_damage_func_ads = ::empty_kill_func; 
		level.global_damage_func = ::empty_kill_func; 
		level.global_kill_func = ::empty_kill_func; 
		if ( getdvar( "arcademode" ) == "1" )
			thread maps\_arcademode::main();
			
		// first init stuff
		set_console_status();
		flag_init( "player_has_red_flashing_overlay" );
		flag_init( "player_is_invulnerable" );
		flag_clear( "player_has_red_flashing_overlay" );
		flag_clear( "player_is_invulnerable" );
		level.difficultyType[ 0 ] = "easy";
		level.difficultyType[ 1 ] = "normal";
		level.difficultyType[ 2 ] = "hardened";
		level.difficultyType[ 3 ] = "veteran";
		
		level.difficultyString[ "easy" ] = &"GAMESKILL_EASY";
		level.difficultyString[ "normal" ] = &"GAMESKILL_NORMAL";
		level.difficultyString[ "hardened" ] = &"GAMESKILL_HARDENED";
		level.difficultyString[ "veteran" ] = &"GAMESKILL_VETERAN";
//		thread update_skill_on_change();
		/#
		thread playerHealthDebug();
		#/ 
	}

	level.gameSkill = getdvarint( "g_gameskill" );
	if ( isdefined( skill_override ) )
		level.gameSkill = skill_override;
	setdvar( "saved_gameskill", level.gameSkill );


// 	createprintchannel( "script_autodifficulty" );
	
	if ( getdvar( "autodifficulty_playerDeathTimer" ) == "" )
		setdvar( "autodifficulty_playerDeathTimer", 0 );
	
	anim.run_accuracy = 0.5;
		
	logString( "difficulty: " + level.gameSkill );
		
	// if ( getdvar( "autodifficulty_frac" ) == "" )
	setdvar( "autodifficulty_frac", 0 );// disabled for now
	
	level.difficultySettings_stepFunc_percent = [];
	level.difficultySettings_frac_data_points = [];
	level.auto_adjust_threatbias = true;
	
	setTakeCoverWarnings();
	thread increment_take_cover_warnings_on_death();
	
	level.mg42badplace_mintime = 8;// minimum # of seconds a badplace is created on an mg42 after its operator dies
	level.mg42badplace_maxtime = 16;// maximum # of seconds a badplace is created on an mg42 after its operator dies

	// anim.playerGrenadeBaseTime
	add_fractional_data_point( "playerGrenadeBaseTime", 0.0, 50000 );
	add_fractional_data_point( "playerGrenadeBaseTime", 0.25, 40000 ); // original easy
	add_fractional_data_point( "playerGrenadeBaseTime", 0.75, 25000 ); // original normal
	add_fractional_data_point( "playerGrenadeBaseTime", 1.0, 13500 );
	level.difficultySettings[ "playerGrenadeBaseTime" ][ "hardened" ] = 10000;
	level.difficultySettings[ "playerGrenadeBaseTime" ][ "veteran" ] = 0;

	// anim.playerGrenadeRangeTime
	add_fractional_data_point( "playerGrenadeRangeTime", 0.0, 22000 );
	add_fractional_data_point( "playerGrenadeRangeTime", 0.25, 20000 ); // original easy
	add_fractional_data_point( "playerGrenadeRangeTime", 0.75, 15000 ); // original normal
	add_fractional_data_point( "playerGrenadeRangeTime", 1.0, 7500 );
	level.difficultySettings[ "playerGrenadeRangeTime" ][ "hardened" ] = 5000;
	level.difficultySettings[ "playerGrenadeRangeTime" ][ "veteran" ] = 1;
	
	// time between instances where 2 grenades land near player at once( hardcoded to never happen in easy )
	add_fractional_data_point( "playerDoubleGrenadeTime", 0.25, 60 * 60 * 1000 ); // original easy
	add_fractional_data_point( "playerDoubleGrenadeTime", 0.75, 120 * 1000 ); // original normal
	add_fractional_data_point( "playerDoubleGrenadeTime", 1.0, 20 * 1000 );
	level.difficultySettings[ "playerDoubleGrenadeTime" ][ "hardened" ] = 15 * 1000;
	level.difficultySettings[ "playerDoubleGrenadeTime" ][ "veteran" ] = 0;

	level.difficultySettings[ "double_grenades_allowed" ][ "easy" ] = false;
	level.difficultySettings[ "double_grenades_allowed" ][ "normal" ] = true;
	level.difficultySettings[ "double_grenades_allowed" ][ "hardened" ] = true;
	level.difficultySettings[ "double_grenades_allowed" ][ "veteran" ] = true;
	level.difficultySettings_stepFunc_percent[ "double_grenades_allowed" ] = 0.75;


	add_fractional_data_point( "player_deathInvulnerableTime", 0.25, 4000 ); // original easy
	add_fractional_data_point( "player_deathInvulnerableTime", 0.75, 1700 ); // original normal
	add_fractional_data_point( "player_deathInvulnerableTime", 1.0, 850 );
	level.difficultySettings[ "player_deathInvulnerableTime" ][ "hardened" ] = 600;
	level.difficultySettings[ "player_deathInvulnerableTime" ][ "veteran" ] = 100;
	
	add_fractional_data_point( "threatbias", 0.0, 80 );
	add_fractional_data_point( "threatbias", 0.25, 100 ); // original easy
	add_fractional_data_point( "threatbias", 0.75, 150 ); // original normal
	add_fractional_data_point( "threatbias", 1.0, 165 );
	level.difficultySettings[ "threatbias" ][ "hardened" ] = 200;
	level.difficultySettings[ "threatbias" ][ "veteran" ] = 400;
	
	// level.longRegenTime
	/* 
 	redFlashingOverlay() controls how long the overlay flashes, this var controls how long it takes
 	before your health comes back
	*/ 
	add_fractional_data_point( "longRegenTime", 1.0, 5000 );
	level.difficultySettings[ "longRegenTime" ][ "hardened" ] = 5000;
	level.difficultySettings[ "longRegenTime" ][ "veteran" ] = 5000;

	// level.healthOverlayCutoff
	add_fractional_data_point( "healthOverlayCutoff", 0.25, 0.01 ); // original easy
	add_fractional_data_point( "healthOverlayCutoff", 0.75, 0.2 ); // original normal
	add_fractional_data_point( "healthOverlayCutoff", 1.0, 0.25 );
	level.difficultySettings[ "healthOverlayCutoff" ][ "hardened" ] = 0.3;
	level.difficultySettings[ "healthOverlayCutoff" ][ "veteran" ] = 0.5;

	// level.healthOverlayCutoff
	add_fractional_data_point( "base_enemy_accuracy", 0.25, 1 ); // original easy
	add_fractional_data_point( "base_enemy_accuracy", 0.75, 1 ); // original normal
	level.difficultySettings[ "base_enemy_accuracy" ][ "hardened" ] = 1.3;
	level.difficultySettings[ "base_enemy_accuracy" ][ "veteran" ] = 1.3;
	
	// lower numbers = higher accuracy for AI at a distance
	add_fractional_data_point( "accuracyDistScale", 0.25, 1.0 ); // original easy
	add_fractional_data_point( "accuracyDistScale", 0.75, 1.0 ); // original normal
	level.difficultySettings[ "accuracyDistScale" ][ "hardened" ] = 1.0;
	level.difficultySettings[ "accuracyDistScale" ][ "veteran" ]  = 0.5;
	
	// level.playerDifficultyHealth
	add_fractional_data_point( "playerDifficultyHealth", 0.0, 550 );
	add_fractional_data_point( "playerDifficultyHealth", 0.25, 475 ); // original easy
	add_fractional_data_point( "playerDifficultyHealth", 0.75, 275 ); // original normal
	add_fractional_data_point( "playerDifficultyHealth", 1.0, 210 );
	level.difficultySettings[ "playerDifficultyHealth" ][ "hardened" ] = 165;
	level.difficultySettings[ "playerDifficultyHealth" ][ "veteran" ] = 115;

	// anim.min_sniper_burst_delay_time
	add_fractional_data_point( "min_sniper_burst_delay_time", 0.0, 3.5 );
	add_fractional_data_point( "min_sniper_burst_delay_time", 0.25, 3.0 ); // original easy
	add_fractional_data_point( "min_sniper_burst_delay_time", 0.75, 2.0 ); // original normal
	add_fractional_data_point( "min_sniper_burst_delay_time", 1.0, 1.80 );
	level.difficultySettings[ "min_sniper_burst_delay_time" ][ "hardened" ] = 1.5;
	level.difficultySettings[ "min_sniper_burst_delay_time" ][ "veteran" ] = 1.1;

	// anim.max_sniper_burst_delay_time
	add_fractional_data_point( "max_sniper_burst_delay_time", 0.0, 4.5 );
	add_fractional_data_point( "max_sniper_burst_delay_time", 0.25, 4.0 ); // original easy
	add_fractional_data_point( "max_sniper_burst_delay_time", 0.75, 3.0 ); // original normal
	add_fractional_data_point( "max_sniper_burst_delay_time", 1.0, 2.5 );
	level.difficultySettings[ "max_sniper_burst_delay_time" ][ "hardened" ] = 2.0;
	level.difficultySettings[ "max_sniper_burst_delay_time" ][ "veteran" ] = 1.5;


	add_fractional_data_point( "dog_health", 0.0, 0.2 );
	add_fractional_data_point( "dog_health", 0.25, 0.25 ); // original easy
	add_fractional_data_point( "dog_health", 0.75, 0.75 ); // original normal
	add_fractional_data_point( "dog_health", 1.0, 0.8 );
	level.difficultySettings[ "dog_health" ][ "hardened" ] = 1.0;
	level.difficultySettings[ "dog_health" ][ "veteran" ] = 1.0;


	add_fractional_data_point( "dog_presstime", 0.25, 415 ); // original easy
	add_fractional_data_point( "dog_presstime", 0.75, 375 ); // original normal
	level.difficultySettings[ "dog_presstime" ][ "hardened" ] = 250;
	level.difficultySettings[ "dog_presstime" ][ "veteran" ] = 225;
	
	level.difficultySettings[ "dog_hits_before_kill" ][ "easy" ] = 2;
	level.difficultySettings[ "dog_hits_before_kill" ][ "normal" ] = 1;
	level.difficultySettings[ "dog_hits_before_kill" ][ "hardened" ] = 0;
	level.difficultySettings[ "dog_hits_before_kill" ][ "veteran" ] = 0;
	level.difficultySettings_stepFunc_percent[ "dog_hits_before_kill" ] = 0.5;
	

	// anim.pain_test
	level.difficultySettings[ "pain_test" ][ "easy" ] = ::always_pain;
	level.difficultySettings[ "pain_test" ][ "normal" ] = ::always_pain;
	level.difficultySettings[ "pain_test" ][ "hardened" ] = ::pain_protection;
	level.difficultySettings[ "pain_test" ][ "veteran" ] = ::pain_protection;
	anim.pain_test = level.difficultySettings[ "pain_test"  ][ get_skill_from_index( level.gameskill ) ];

	// missTime is a number based on the distance from the AI to the player + some baseline
	// it simulates bad aim as the AI starts shooting, and helps give the player a warning before they get hit.
	// this is used for auto and semi auto.
	// missTime = missTimeConstant + distance * missTimeDistanceFactor
	
	level.difficultySettings[ "missTimeConstant" ][ "easy" ]     = 1.0; // 0.2;// 0.3;
	level.difficultySettings[ "missTimeConstant" ][ "normal" ]   = 0.05;// 0.1;
	level.difficultySettings[ "missTimeConstant" ][ "hardened" ] = 0;// 0.04;
	level.difficultySettings[ "missTimeConstant" ][ "veteran" ]  = 0;// 0.03;
	// determines which misstime constant to use based on difficulty frac. Hard and Vet use their own settings.
	level.difficultySettings_stepFunc_percent[ "missTimeConstant" ] = 0.5;
	
	
	level.difficultySettings[ "missTimeDistanceFactor" ][ "easy" ]     = 0.8  / 1000; // 0.4
	level.difficultySettings[ "missTimeDistanceFactor" ][ "normal" ]   = 0.1  / 1000;
	level.difficultySettings[ "missTimeDistanceFactor" ][ "hardened" ] = 0.05 / 1000;
	level.difficultySettings[ "missTimeDistanceFactor" ][ "veteran" ]  = 0;
	// determines which missTimeDistanceFactor to use based on difficulty frac. Hard and Vet use their own settings.
	level.difficultySettings_stepFunc_percent[ "missTimeDistanceFactor" ] = 0.5;
	
	add_fractional_data_point( "flashbangedInvulFactor", 0.25, 0.25 ); // original easy
	add_fractional_data_point( "flashbangedInvulFactor", 0.75, 0.0 ); // original normal
	level.difficultySettings[ "flashbangedInvulFactor" ][ "easy" ]     = 0.25;
	level.difficultySettings[ "flashbangedInvulFactor" ][ "normal" ]   = 0;
	level.difficultySettings[ "flashbangedInvulFactor" ][ "hardened" ] = 0;
	level.difficultySettings[ "flashbangedInvulFactor" ][ "veteran" ]  = 0;
	
	// level.invulTime_preShield: time player is invulnerable when hit before their health is low enough for a red overlay( should be very short )
	add_fractional_data_point( "invulTime_preShield", 0.0, 0.7 );
	add_fractional_data_point( "invulTime_preShield", 0.25, 0.6 ); // original easy
	add_fractional_data_point( "invulTime_preShield", 0.75, 0.35 ); // original normal
	add_fractional_data_point( "invulTime_preShield", 1.0, 0.3 );
	level.difficultySettings[ "invulTime_preShield" ][ "hardened" ] = 0.1;
	level.difficultySettings[ "invulTime_preShield" ][ "veteran" ] = 0.0;
	
	// level.invulTime_onShield: time player is invulnerable when hit the first time they get a red health overlay( should be reasonably long )
	add_fractional_data_point( "invulTime_onShield", 0.0, 1.0 );
	add_fractional_data_point( "invulTime_onShield", 0.25, 0.8 ); // original easy
	add_fractional_data_point( "invulTime_onShield", 0.75, 0.5 ); // original normal
	add_fractional_data_point( "invulTime_onShield", 1.0, 0.3 );
	level.difficultySettings[ "invulTime_onShield"  ][ "hardened" ] = 0.1;
	level.difficultySettings[ "invulTime_onShield"  ][ "veteran" ] = 0.05;
	
	// level.invulTime_postShield: time player is invulnerable when hit after the red health overlay is already up( should be short )
	add_fractional_data_point( "invulTime_postShield", 0.0, 0.6 );
	add_fractional_data_point( "invulTime_postShield", 0.25, 0.5 ); // original easy
	add_fractional_data_point( "invulTime_postShield", 0.75, 0.3 ); // original normal
	add_fractional_data_point( "invulTime_postShield", 1.0, 0.2 );
	level.difficultySettings[ "invulTime_postShield" ][ "hardened" ] = 0.1;
	level.difficultySettings[ "invulTime_postShield" ][ "veteran" ] = 0.0;
	
	// level.playerHealth_RegularRegenDelay
	// The delay before you regen health after getting hurt
	add_fractional_data_point( "playerHealth_RegularRegenDelay", 0.0, 3500 );
	add_fractional_data_point( "playerHealth_RegularRegenDelay", 0.25, 3000 ); // original easy
	add_fractional_data_point( "playerHealth_RegularRegenDelay", 0.75, 2000 ); // original normal
	add_fractional_data_point( "playerHealth_RegularRegenDelay", 1.0, 1500 );
	level.difficultySettings[ "playerHealth_RegularRegenDelay" ][ "hardened" ] = 1200;
	level.difficultySettings[ "playerHealth_RegularRegenDelay" ][ "veteran" ] = 1200;
	
	// level.worthyDamageRatio( player must recieve this much damage as a fraction of maxhealth to get invulTime. )
	add_fractional_data_point( "worthyDamageRatio", 0.25, 0.0 ); // original easy
	add_fractional_data_point( "worthyDamageRatio", 0.75, 0.1 ); // original normal
	level.difficultySettings[ "worthyDamageRatio" ][ "hardened" ] = 0.1;
	level.difficultySettings[ "worthyDamageRatio" ][ "veteran" ] = 0.1;

	// level.explosiveplanttime
	level.difficultySettings[ "explosivePlantTime" ][ "easy" ] = 10;
	level.difficultySettings[ "explosivePlantTime" ][ "normal" ] = 10; 
	level.difficultySettings[ "explosivePlantTime" ][ "hardened" ] = 5; 
	level.difficultySettings[ "explosivePlantTime" ][ "veteran" ] = 5; 
	level.explosiveplanttime = level.difficultySettings[ "explosivePlantTime"  ][ get_skill_from_index( level.gameskill ) ];

	// anim.difficultyBasedAccuracy
	level.difficultySettings[ "difficultyBasedAccuracy" ][ "easy" ] = 1;
	level.difficultySettings[ "difficultyBasedAccuracy" ][ "normal" ] = 1;
	level.difficultySettings[ "difficultyBasedAccuracy" ][ "hardened" ] = 1;
	level.difficultySettings[ "difficultyBasedAccuracy" ][ "veteran" ] = 1.25;
	anim.difficultyBasedAccuracy = getRatio( "difficultyBasedAccuracy", level.gameskill, level.gameskill );
	
	// in case there are no enties in the map. 
	level.lastPlayerSighted = 0;
	
	// only easy and normal do adjusting
	difficulty_starting_frac[ "easy" ] = 0.25;
	difficulty_starting_frac[ "normal" ] = 0.75;
	
	if ( level.gameskill <= 1 )
	{
//		if ( aa_should_start_fresh() )
		{
			// started over so reset difficulty evaluation
			dif_frac = difficulty_starting_frac[ get_skill_from_index( level.gameskill ) ];
			dif_frac = int( dif_frac * 100 );
			setdvar( "autodifficulty_frac", dif_frac );
		}

		set_difficulty_from_current_aa_frac();
	}
	else
	{
		set_difficulty_from_locked_settings();
	}

	setdvar( "autodifficulty_original_setting", level.gameskill );
	setsaveddvar( "player_meleeDamageMultiplier", 100 / 250 );
}

get_skill_from_index( index )
{
	return level.difficultyType[ index ];
}

aa_should_start_fresh()
{
	if ( level.script == "killhouse" )
		return true;
	return level.gameskill == getdvarint( "autodifficulty_original_setting" );
}

apply_difficulty_frac_with_func( difficulty_func, current_frac )
{
	//prof_begin( "apply_difficulty_frac_with_func" );
	
	level.invulTime_preShield = [[ difficulty_func ]]( "invulTime_preShield", current_frac );
	level.invulTime_onShield = [[ difficulty_func ]]( "invulTime_onShield", current_frac );
	level.invulTime_postShield = [[ difficulty_func ]]( "invulTime_postShield", current_frac );
	level.playerHealth_RegularRegenDelay = [[ difficulty_func ]]( "playerHealth_RegularRegenDelay", current_frac );
	level.worthyDamageRatio = [[ difficulty_func ]]( "worthyDamageRatio", current_frac );

	if ( level.auto_adjust_threatbias )
		level.player.threatbias = int( [[ difficulty_func ]]( "threatbias", current_frac ) );
		
	level.longRegenTime = [[ difficulty_func ]]( "longRegenTime", current_frac );
	level.healthOverlayCutoff = [[ difficulty_func ]]( "healthOverlayCutoff", current_frac );

	anim.player_attacker_accuracy = [[ difficulty_func ]]( "base_enemy_accuracy", current_frac );
	level.attackeraccuracy = anim.player_attacker_accuracy;

	anim.playerGrenadeBaseTime = int( [[ difficulty_func ]]( "playerGrenadeBaseTime", current_frac ) );
	anim.playerGrenadeRangeTime = int( [[ difficulty_func ]]( "playerGrenadeRangeTime", current_frac ) );
	anim.playerDoubleGrenadeTime = int( [[ difficulty_func ]]( "playerDoubleGrenadeTime", current_frac ) );

	anim.min_sniper_burst_delay_time = [[ difficulty_func ]]( "min_sniper_burst_delay_time", current_frac );
	anim.max_sniper_burst_delay_time = [[ difficulty_func ]]( "max_sniper_burst_delay_time", current_frac );

	anim.dog_health = [[ difficulty_func ]]( "dog_health", current_frac );
	anim.dog_presstime = [[ difficulty_func ]]( "dog_presstime", current_frac );
	

	// we kill the player manually in script when we're ready to do so.
	setsaveddvar( "player_deathInvulnerableTime", int( [[ difficulty_func ]]( "player_deathInvulnerableTime", current_frac ) ) );
	setsaveddvar( "player_damageMultiplier", 100 / [[ difficulty_func ]]( "playerDifficultyHealth", current_frac ) );
	setsaveddvar( "ai_accuracyDistScale", [[ difficulty_func ]]( "accuracyDistScale", current_frac ) );
	
	//prof_end( "apply_difficulty_frac_with_func" );
}

apply_difficulty_step_with_func( difficulty_func, current_frac )
{
	//prof_begin( "apply_difficulty_step_with_func" );
	
	// sets the value of difficulty settings that can't blend between two 
	anim.missTimeConstant = [[ difficulty_func ]]( "missTimeConstant", current_frac );
	anim.missTimeDistanceFactor = [[ difficulty_func ]]( "missTimeDistanceFactor", current_frac );
	anim.dog_hits_before_kill = [[ difficulty_func ]]( "dog_hits_before_kill", current_frac );
	anim.double_grenades_allowed = [[ difficulty_func ]]( "double_grenades_allowed", current_frac );
	
	//prof_end( "apply_difficulty_step_with_func" );
}

set_difficulty_from_locked_settings()
{
	apply_difficulty_frac_with_func( ::get_locked_difficulty_val, 1 );
	apply_difficulty_step_with_func( ::get_locked_difficulty_step_val, 1 );
}

set_difficulty_from_current_aa_frac()
{
	//prof_begin( "set_difficulty_from_current_aa_frac" );
	
	// sets the difficulty to be a degree between two difficulty step values
	level.auto_adjust_difficulty_frac = getdvarint( "autodifficulty_frac" );
	current_frac = level.auto_adjust_difficulty_frac * 0.01;
	assert( level.auto_adjust_difficulty_frac >= 0 );
	assert( level.auto_adjust_difficulty_frac <= 100 );
	
	apply_difficulty_frac_with_func( ::get_blended_difficulty, current_frac );
	apply_difficulty_step_with_func( ::get_stepped_difficulty, current_frac );
	
	//prof_end( "set_difficulty_from_current_aa_frac" );
}

get_stepped_difficulty( system, current_frac )
{
	// returns the Normal val if the difficulty is above specified percent
	if ( current_frac >= level.difficultySettings_stepFunc_percent[ system ] )
	{
		return level.difficultySettings[ system ][ "normal" ];
	}
	
	return level.difficultySettings[ system ][ "easy" ];
}

get_locked_difficulty_step_val( system, ignored )
{
	return level.difficultySettings[ system ][ get_skill_from_index( level.gameskill ) ];
}

get_blended_difficulty( system, current_frac )
{
	//prof_begin( "get_blended_difficulty" );

	// get the value from the available data points
	difficulty_array = level.difficultySettings_frac_data_points[ system ];

	for ( i = 1; i < difficulty_array.size; i++ )
	{
		high_frac = difficulty_array[ i ][ "frac" ];
		high_val = difficulty_array[ i ][ "val" ];
		
		if ( current_frac <= high_frac )
		{
			low_frac = difficulty_array[ i - 1 ][ "frac" ];
			low_val = difficulty_array[ i - 1 ][ "val" ];
			
			frac_range = high_frac - low_frac;
			val_range = high_val - low_val;
			
			base_frac = current_frac - low_frac;

			result_frac = base_frac / frac_range;

			return low_val + result_frac * val_range;

/*
			0.5		10		0.7
			0.75	100

frac_range		0.25
base_frac		0.2

val_range		90
*/			
		}
	}
	
	assertex( difficulty_array.size == 1, "Shouldnt be multiple data points if we're here." );
	
	//prof_end( "get_blended_difficulty" );
	
	return difficulty_array[ 0 ][ "val" ];
}

is_double_grenades_allowed()
{
	return level.auto_adjust_difficulty_frac > 0.75;
}


getCurrentDifficultySetting( msg )
{
	return level.difficultySettings[ msg ][ get_skill_from_index( level.gameskill ) ];
}

getRatio( msg, min, max )
{
	return( level.difficultySettings[ msg ][ level.difficultyType[ min ] ] * ( 100 - getdvarint( "autodifficulty_frac" ) ) + level.difficultySettings[ msg ][ level.difficultyType[ max ] ] * getdvarint( "autodifficulty_frac" ) ) * 0.01;
}

get_locked_difficulty_val( msg, ignored ) // ignored is there because this is used as a function pointer with another function that does have a second parm
{
	return level.difficultySettings[ msg ][ level.difficultyType[ level.gameskill ] ];
}

always_pain()
{
	return false;
}

pain_protection()
{
	if ( !pain_protection_check() )
		return false;

	return( randomint( 100 ) > 25 );
}

pain_protection_check()
{
	if ( !isalive( self.enemy ) )
		return false;
		
	if ( self.enemy != level.player )
		return false;
		
	if ( !isalive( level.painAI ) || level.painAI.a.script != "pain" )
		level.painAI = self;

	// The pain AI can always take pain, so if the player focuses on one guy he'll see pain animations.	
	if ( self == level.painAI )
		return false;

	if ( self.damageWeapon != "none" && weaponIsBoltAction( self.damageWeapon ) )
		return false;

	return true;
}

 /#
playerHealthDebug()
{
	waittillframeend; // for init to finish
	if ( getdvar( "scr_health_debug" ) == "" )
		setdvar( "scr_health_debug", "0" );
	
	while ( 1 )
	{
		while ( 1 )
		{
			if ( getdebugdvar( "scr_health_debug" ) != "0" )
				break;
			wait .5;
		}
		thread printHealthDebug();
		while ( 1 )
		{
			if ( getdebugdvar( "scr_health_debug" ) == "0" )
				break;
			wait .5;
		}
		level notify( "stop_printing_grenade_timers" );
		destroyHealthDebug();
	}
}

printHealthDebug()
{
	level notify( "stop_printing_health_bars" );
	level endon( "stop_printing_health_bars" );
	
	x = 40;
	y = 40;
	
	level.healthBarHudElems = [];
	
	level.healthBarKeys[ 0 ] = "Health";
	level.healthBarKeys[ 1 ] = "No Hit Time";
	level.healthBarKeys[ 2 ] = "No Die Time";
	
	if ( !isDefined( level.playerInvulTimeEnd ) )
		level.playerInvulTimeEnd = 0;
	if ( !isDefined( level.player_deathInvulnerableTimeout ) )
		level.player_deathInvulnerableTimeout = 0;
	
	for ( i = 0; i < level.healthBarKeys.size; i++ )
	{
		key = level.healthBarKeys[ i ];
		
		textelem = newHudElem();
		textelem.x = x;
		textelem.y = y;
		textelem.alignX = "left";
		textelem.alignY = "top";
		textelem.horzAlign = "fullscreen";
		textelem.vertAlign = "fullscreen";
		textelem setText( key );
		
		bar = newHudElem();
		bar.x = x + 80;
		bar.y = y + 2;
		bar.alignX = "left";
		bar.alignY = "top";
		bar.horzAlign = "fullscreen";
		bar.vertAlign = "fullscreen";
		bar setshader( "black", 1, 8 );
		
		textelem.bar = bar;
		textelem.key = key;
		
		y += 10;
		
		level.healthBarHudElems[ key ] = textelem;
	}
	
	while ( 1 )
	{
		wait .05;
		
		for ( i = 0; i < level.healthBarKeys.size; i++ )
		{
			key = level.healthBarKeys[ i ];
			
			width = 0;
			if ( i == 0 )
				width = level.player.health / level.player.maxhealth * 300;
			else if ( i == 1 )
				width = ( level.playerInvulTimeEnd - gettime() ) / 1000 * 40;
			else if ( i == 2 )
				width = ( level.player_deathInvulnerableTimeout - gettime() ) / 1000 * 40;
			
			width = int( max( width, 1 ) );
			
			bar = level.healthBarHudElems[ key ].bar;
			bar setShader( "black", width, 8 );
		}
	}
}

destroyHealthDebug()
{
	if ( !isdefined( level.healthBarHudElems ) )
		return;
	for ( i = 0; i < level.healthBarKeys.size; i++ )
	{
		level.healthBarHudElems[ level.healthBarKeys[ i ] ].bar destroy();
		level.healthBarHudElems[ level.healthBarKeys[ i ] ] destroy();
	}
}
#/ 

/* 
// this is run on each enemy AI.
axisAccuracyControl()
{
	self endon( "long_death" );
	self endon( "death" );
	
	//prof_begin( "axisAccuracyControl" );
	
	if ( getdvar( "scr_dynamicaccuracy" ) == "" )
		setdvar( "scr_dynamicaccuracy", "off" );
	if ( getdvar( "scr_dynamicaccuracy" ) != "on" )
	{
// 		self simpleAccuracyControl();
	}
	else
	{
		for ( ;; )
		{
			wait( 0.05 );
			waittillframeend;// in case our accuracy changed this frame
			
			//prof_begin( "axisAccuracyControl" );
			
			if ( isDefined( self.enemy ) && isPlayer( self.enemy ) && self canSee( self.enemy ) )
			{
				self.a.accuracyGrowthMultiplier += 0.05 * anim.accuracyGrowthRate;
				if ( self.a.accuracyGrowthMultiplier > anim.accuracyGrowthMax )
					self.a.accuracyGrowthMultiplier = anim.accuracyGrowthMax;
			}
			else
			{
				self.a.accuracyGrowthMultiplier = 1;
			}
			
			self setEnemyAccuracy();
			
			//prof_end( "axisAccuracyControl" );
		}
	}
	
	//prof_end( "axisAccuracyControl" );
}

alliesAccuracyControl()
{
	self endon( "long_death" );
	self endon( "death" );
	
// 	self simpleAccuracyControl();
}
*/ 

set_accuracy_based_on_situation()
{
	if ( self animscripts\combat_utility::isSniper() && isAlive( self.enemy ) )
	{
		self setSniperAccuracy();
		return;
	}
	
	if ( isPlayer( self.enemy ) )
	{
		resetMissDebounceTime();
		if ( self.a.missTime > gettime() )
		{
			self.accuracy = 0;
			return;
		}
		
		if ( self.a.script == "move"  )
		{
			self.accuracy = anim.run_accuracy * self.baseAccuracy;
			return;
		}
	}
	else
	{
		if ( self.a.script == "move"  )
		{
			self.accuracy = anim.run_accuracy * self.baseAccuracy;
			return;
		}
	}
	
	self.accuracy = self.baseAccuracy;
}

setSniperAccuracy()
{
	/*
	// if sniperShotCount isn't defined, a sniper is shooting from some place that's not in normal shoot behavior.
	// that probably means they're doing some sort of blindfire or something that would look stupid for a sniper to do.
	assert( isdefined( self.sniperShotCount ) );
	*/
	if ( !isdefined( self.sniperShotCount ) )
	{
		// snipers get this error if a dog attacks them
		self.sniperShotCount = 0;
		self.sniperHitCount = 0;
	}
		
	self.sniperShotCount++ ;
	
	if ( ( !isDefined( self.lastMissedEnemy ) || self.enemy != self.lastMissedEnemy ) && distanceSquared( self.origin, self.enemy.origin ) > 500 * 500 )
	{
		// miss
		self.accuracy = 0;
		if ( level.gameSkill > 0 || self.sniperShotCount > 1 )
			self.lastMissedEnemy = self.enemy;
		return;
	}
	
	// guarantee a hit unless baseAccuracy is 0
	self.accuracy = ( 1 + 1 * self.sniperHitCount ) * self.baseAccuracy;
	
	self.sniperHitCount++ ;
	
	if ( level.gameSkill < 1 && self.sniperHitCount == 1 )
		self.lastMissedEnemy = undefined;// miss again
}

shotsAfterPlayerBecomesInvul()
{
	return( 1 + randomfloat( 4 ) );
}

didSomethingOtherThanShooting()
{
	// make sure the next time resetAccuracyAndPause() is called, we reset our misstime for sure
	self.a.missTimeDebounce = 0;
}

// called when we start a volley of shots.
resetAccuracyAndPause()
{
	self resetMissTime();
	
	// self conserveAmmoWhilePlayerIsInvulnerable();
}

waitTimeIfPlayerIsHit()
{
	waittime = 0;
	waittillframeend;
	if ( !isalive( self.enemy ) )
		return waittime;
		
	if ( self.enemy != level.player )
		return waittime;

	if ( flag( "player_is_invulnerable" ) && !self.a.nonstopFire )
		waittime = ( 0.3 + randomfloat( 0.4 ) );
	return waittime;
}

print3d_time( org, text, color, timer )
{
	timer *= 20;
	for ( i = 0; i < timer; i++ )
	{
		print3d( org, text, color );
		wait( 0.05 );
	}
}


resetMissTime()
{
	//prof_begin( "resetMissTime" );
	if ( self.team != "axis" )
		return;
	
	if ( self.weapon == "none" )
		return;
		
	if ( !self animscripts\weaponList::usingAutomaticWeapon() && !self animscripts\weaponList::usingSemiAutoWeapon() )
	{
		self.missTime = 0;
		//prof_end( "resetMissTime" );
		return;
	}
	
	self.a.nonstopFire = false;
	
	if ( !isalive( self.enemy ) )
	{
		//prof_end( "resetMissTime" );
		return;
	}
	
	if ( self.enemy != level.player )
	{
		self.accuracy = self.baseAccuracy;
		//prof_end( "resetMissTime" );
		return;
	}
	
	dist = distance( self.enemy.origin, self.origin );
	self setMissTime( anim.missTimeConstant + dist * anim.missTimeDistanceFactor );
	//prof_end( "resetMissTime" );
}

resetMissDebounceTime()
{
	self.a.missTimeDebounce = gettime() + 3000;
}

setMissTime( howLong )
{
	assertex( self.team == "axis", "Non axis tried to set misstime" );
	
	// we can only start missing again if it's been a few seconds since we last shot
	if ( self.a.missTimeDebounce > gettime() )
	{
		return;
	}
	
	if ( howLong > 0 )
		self.accuracy = 0;
	
	howLong *= 1000;// convert to milliseconds

	self.a.missTime = gettime() + howLong;
	self.a.accuracyGrowthMultiplier = 1;
//	thread print3d_time( self.origin + (0,0,32 ), "Aiming..", (1,1,0), howLong * 0.001 );
	//thread player_aim_debug();
}

player_aim_debug()
{
	self endon( "death" );
	self notify( "playeraim" );
	self endon( "playeraim" );
	
	for ( ;; )
	{
		color = (0,1,0);
		if ( self.a.misstime > gettime() )
			color = (1,0,0);
		print3d( self.origin + (0,0,32), self.finalaccuracy, color );
		wait( 0.05 );
	}
}

playerHurtcheck()
{
	self.hurtAgain = false;
	for ( ;; )
	{
		self waittill( "damage", amount, attacker, dir, point );
		self.hurtAgain = true;
		self.damagePoint = point;
		self.damageAttacker = attacker;
	}
}

/* boltCheck()
{
	// on hard, kar98s dont do quite enough damage to put you into red flashing, so we bias it a bit )
	self endon( "death" );
	for ( ;; )
	{
		self waittill( "damage", damage, attacker, direction_vec, point, cause );
		if ( level.gameSkill != 2 )
			continue;
		if ( cause != "MOD_RIFLE_BULLET" )
			continue;
		
		ratio = self.health / self.maxHealth;
		if ( ratio > level.healthOverlayCutoff )
			self setnormalhealth( level.healthOverlayCutoff - 0.005 );
	}
}*/ 

/*draw_player_health_packets()
{
	packets = [];
	red = ( 1, 0, 0 );
	orange = ( 1, 0.5, 0 );
	green = ( 0, 1, 0 );
	
	for ( i = 0; i < 3; i++ )
	{
		overlay = newHudElem();
		overlay.x = 5 + 20 * i;
		overlay.y = 20;
		overlay setshader( "white", 16, 16 );
		overlay.alignX = "left";
		overlay.alignY = "top";
		overlay.alpha = 1;
		overlay.color = ( 0, 1, 0 );
		packets[ packets.size ] = overlay;
	}
	
	for ( ;; )
	{
		level waittill( "update_health_packets" );
		if ( flag( "player_has_red_flashing_overlay" ) )
		{
			packetBase = 1;
			for ( i = 0; i < packetBase; i++ )
			{
				packets[ i ] fadeOverTime( 0.5 );
				packets[ i ].alpha = 1;
				packets[ i ].color = red;
			}

			for ( i = packetBase; i < 3; i++ )
			{
				packets[ i ] fadeOverTime( 0.5 );
				packets[ i ].alpha = 0;
				packets[ i ].color = red;
			}
			
			flag_waitopen( "player_has_red_flashing_overlay" );
		}
		
		packetBase = level.player_health_packets;
		if ( packetBase <= 0 )
			packetBase = 0;
		
		color = red; 
		if ( packetBase == 2 )
			color = orange;
		if ( packetBase == 3 )
			color = green;
			
		for ( i = 0; i < packetBase; i++ )
		{
			packets[ i ] fadeOverTime( 0.5 );
			packets[ i ].alpha = 1;
			packets[ i ].color = color;
		}
			
		for ( i = packetBase; i < 3; i++ )
		{
			packets[ i ] fadeOverTime( 0.5 );
			packets[ i ].alpha = 0;
			packets[ i ].color = red;
		}
	}
}*/

player_health_packets()
{
// 	thread draw_player_health_packets();
	level.player_health_packets = 3;
	for ( ;; )
	{
		flag_wait( "player_has_red_flashing_overlay" );
// 		change_player_health_packets( - 1 );
		flag_waitopen( "player_has_red_flashing_overlay" );
	}
}

playerHealthRegen()
{
	// sarah - readd when SP is using code - driven low health overlay
	// if ( getcvarfloat( "hud_healthOverlay_pulseStart" ) == 0 )
	// 	setcvar( "hud_healthOverlay_pulseStart", 0.35 );
	// level.healthOverlayCutoff = getcvarfloat( "hud_healthOverlay_pulseStart" );	
	
	//prof_begin( "playerHealthRegen" );
	
	thread healthOverlay();
	oldratio = 1;
	player = level.player;
	health_add = 0;
	
	thread player_health_packets();
	
	/* 
	if ( level.console )
		regenRate = 0.01;// 0.017;
	else
	*/ 
	regenRate = 0.1;// 0.017;
// 	regenRate = 0.01;// 0.017;
	veryHurt = false;
	playerJustGotRedFlashing = false;
	
	level.hurtTime = -10000;
	thread playerBreathingSound( level.player.maxHealth * 0.35 );
	invulTime = 0;
	hurtTime = 0;
	newHealth = 0;
	lastinvulratio = 1;
	player thread playerHurtcheck();
	
	player.boltHit = false;
	// player thread boltCheck();
	
	if ( getdvar( "scr_playerInvulTimeScale" ) == "" )
		setdvar( "scr_playerInvulTimeScale", 1.0 );
	
	for ( ;; )
	{
		wait( 0.05 );
		waittillframeend;// if we're on hard, we need to wait until the bolt damage check before we decide what to do
		//prof_begin( "playerHealthRegen" );
		
		if ( player.health == level.player.maxHealth )
		{
			if ( flag( "player_has_red_flashing_overlay" ) )
			{
				flag_clear( "player_has_red_flashing_overlay" );
				level notify( "take_cover_done" );
// 				level notify( "hit_again" ); was cutting off the overlay fadeout
			}
			
			lastinvulratio = 1;
			playerJustGotRedFlashing = false;
			veryHurt = false;
			continue;
		}
		
		if ( player.health <= 0 )
		{
			 /#showHitLog();#/ 
			//prof_end( "playerHealthRegen" );
			return;
		}
		
		wasVeryHurt = veryHurt;
		ratio = player.health / level.player.maxHealth;
		if ( ratio <= level.healthOverlayCutoff && level.player_health_packets > 1 )
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
		
		/* 
		if ( !wasVeryHurt && veryHurt )
			nearAIRushesPlayer();
		*/ 
		if ( player.hurtAgain )
		{
			hurtTime = gettime();
			player.hurtAgain = false;
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
				if ( newHealth >= 1 )
					reduceTakeCoverWarnings();
			}
			else
			{
				newHealth = 1;
			}
							
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
			 /#
			if ( !isDefined( level.player_deathInvulnerableTimeout ) )
				level.player_deathInvulnerableTimeout = 0;
			if ( level.player_deathInvulnerableTimeout < gettime() )
				level.player_deathInvulnerableTimeout = gettime() + getdvarint( "player_deathInvulnerableTime" );
			#/ 
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
		
		thread playerInvul( invulTime );
	}
	
	//prof_end( "playerHealthRegen" );
}

reduceTakeCoverWarnings()
{
	//prof_begin( "reduceTakeCoverWarnings" );
	
	if ( isAlive( level.player ) )
	{
		takeCoverWarnings = getdvarint( "takeCoverWarnings" );
		if ( takeCoverWarnings > 0 )
		{
			takeCoverWarnings -- ;
			setdvar( "takeCoverWarnings", takeCoverWarnings );
			 /#DebugTakeCoverWarnings();#/ 
		}
	}
	
	//prof_end( "reduceTakeCoverWarnings" );
}

 /#
DebugTakeCoverWarnings()
{
	if ( getdvar( "scr_debugtakecover" ) == "" )
		setdvar( "scr_debugtakecover", "0" );
	if ( getdebugdvar( "scr_debugtakecover" ) == "1" )
	{
		iprintln( "Warnings remaining: ", getdebugdvarint( "takeCoverWarnings" ) - 3 );
	}
}
#/ 

 /#
logHit( newhealth, invulTime )
{
	/* if ( !isdefined( level.hitlog ) )
	{
		level.hitlog = [];
		thread showHitLog();
	}
	
	data = spawnstruct();
	data.regen = false;
	data.time = gettime();
	data.health = newhealth / level.player.maxhealth;
	data.invulTime = invulTime;
	
	level.hitlog[ level.hitlog.size ] = data;*/ 
}

logRegen( newhealth )
{
	/* if ( !isdefined( level.hitlog ) )
	{
		level.hitlog = [];
		thread showHitLog();
	}
	
	data = spawnstruct();
	data.regen = true;
	data.time = gettime();
	data.health = newhealth / level.player.maxhealth;
	
	level.hitlog[ level.hitlog.size ] = data;*/ 
}

showHitLog()
{
	/* level.player waittill( "death" );
	
	println( "" );
	println( "^3Hit Log:" );
	
	prevhealth = 1;
	prevtime = 0;
	for ( i = 0; i < level.hitlog.size; i++ )
	{
		timepassed = ( level.hitlog[ i ].time - prevtime ) / 1000;
		healthlost = prevhealth - level.hitlog[ i ].health;
		println( "^0[ " + timepassed + " seconds passed ]" );
		if ( level.hitlog[ i ].regen )
		{
			println( "^0Regen at time ^3" + level.hitlog[ i ].time / 1000 + "^0 for ^3" + -1 * healthlost + "^0 damage. Health is now " + level.hitlog[ i ].health );
		}
		else
		{
			damage = healthlost;
			if ( damage == 0 )
				damage = "unknown";
			println( "^0Hit at time ^3" + level.hitlog[ i ].time / 1000 + "^0 for ^3" + damage + "^0 damage; invul for ^3" + level.hitlog[ i ].invulTime + "^0 seconds. Health is now " + level.hitlog[ i ].health );
		}
		
		prevtime = level.hitlog[ i ].time;
		prevhealth = level.hitlog[ i ].health;
	}
	
	println( "" );*/ 
}
#/ 

playerInvul( timer )
{
	if ( isdefined( level.player.flashendtime ) && level.player.flashendtime > gettime() )
		timer = timer * getCurrentDifficultySetting( "flashbangedInvulFactor" );

	if ( timer > 0 )
	{
		level.player.attackerAccuracy = 0;
		level.player.ignoreRandomBulletDamage = true;
		/#
		level.playerInvulTimeEnd = gettime() + timer * 1000;
		#/ 
	
		wait( timer );
	}
	
	level.player.attackerAccuracy = anim.player_attacker_accuracy;
	level.player.ignoreRandomBulletDamage = false;
	flag_clear( "player_is_invulnerable" );
}


grenadeAwareness()
{
	if ( self.team == "allies" )
	{
		self.grenadeawareness  = 0.9;
		return;
	}
		
	if ( self.team == "axis" )
	{
		if ( level.gameSkill >= 2 )
		{
			// hard and fu
			if ( randomint( 100 ) < 33 )
				self.grenadeawareness = 0.2;
			else
				self.grenadeawareness = 0.5;
		}
		else
		{
			// normal
			if ( randomint( 100 ) < 33 )
				self.grenadeawareness = 0;
			else
				self.grenadeawareness = 0.2;
		}
	}
}

blurView( blur, timer )
{
	level notify( "blurview_stop" );
	level endon( "blurview_stop" );
	setblur( blur, 0 );
	wait( 0.05 );
	setblur( 0, timer );
}
	
playerBreathingSound( healthcap )
{
	wait( 2 );
	player = level.player;
	for ( ;; )
	{
		wait( 0.2 );
		if ( player.health <= 0 )
			return;
			
		// Player still has a lot of health so no breathing sound
		ratio = player.health / level.player.maxHealth;
		if ( ratio > level.healthOverlayCutoff )
			continue;
			
		level.player play_sound_on_entity( "breathing_hurt" );
		wait( 0.1 + randomfloat( 0.8 ) );
	}
}

healthOverlay()
{
	level.player endon( "noHealthOverlay" );
	//prof_begin( "healthOverlay" );
	
	thread compassHealthOverlay();
	
	overlay = newHudElem();
	overlay.x = 0;
	overlay.y = 0;
	overlay setshader( "overlay_low_health", 640, 480 );
	overlay.alignX = "left";
	overlay.alignY = "top";
	overlay.horzAlign = "fullscreen";
	overlay.vertAlign = "fullscreen";
	overlay.alpha = 0;

	wait( 0.05 );// to give a chance for moscow to init level.strings so it doesnt clear ours
	//prof_begin( "healthOverlay" );
	level.strings[ "take_cover" ] 				 = spawnstruct();
	level.strings[ "take_cover" ].text			 = &"GAME_GET_TO_COVER";

	thread healthOverlay_remove( overlay );
	
	thread compassHealthOverlay();
	
	pulseTime = 0.8;
	for ( ;; )
	{
		overlay fadeOverTime( 0.5 );
		overlay.alpha = 0;
		flag_wait( "player_has_red_flashing_overlay" );

		//prof_begin( "healthOverlay" );
		redFlashingOverlay( overlay );
	}
}

compassHealthOverlay()
{
	level.player endon( "noHealthOverlay" );
	
	//prof_begin( "compassHealthOverlay" );

	overlay = newHudElem();
	overlay.x = 0;
	overlay.y = 35;
	overlay setshader( "overlay_low_health_compass", 336, 168 );
	overlay.alignX = "center";
	overlay.alignY = "bottom";
	overlay.horzAlign = "center";
	overlay.vertAlign = "bottom";
	overlay.alpha = 0;
	
	for ( ;; )
	{
		//prof_begin( "compassHealthOverlay" );
		
		overlay fadeOverTime( 0.2 );
		overlay.alpha = 0;
		
		if ( !isAlive( level.player ) )
			break;
		
		flag_wait( "player_has_red_flashing_overlay" );
		
		if( getdvar( "compass" ) == "0" )
			wait .5;
		else
			compassFlashingOverlay( overlay );
		
			
	}
}

compassFlashingOverlay( overlay )
{
	level endon( "hit_again" );
	level.player endon( "damage" );
	
	//prof_begin( "compassFlashingOverlay" );
	
	fullAlphaTime = gettime() + level.longRegenTime;
	zeroAlphaTime = fullAlphaTime + 500;
	
	fadeTime = .2;
	fadeFullInterval = .2;
	
	
	while( isalive( level.player ) )
	{
		alpha = 1;
		if ( gettime() > fullAlphaTime )
		{
			alpha = 1 - ((gettime() - fullAlphaTime) / (zeroAlphaTime - fullAlphaTime));
			if ( alpha < 0 )
				alpha = 0;
		}
		
		overlay fadeOverTime( fadeTime );
		overlay.alpha = alpha;
		wait fadeTime + fadeFullInterval;
		
		overlay fadeOverTime( fadeTime );
		overlay.alpha = alpha * .8;
		wait fadeTime;
		
		//prof_begin( "compassFlashingOverlay" );
		
		if ( alpha <= 0 )
			break;
	}
}


add_hudelm_position_internal( alignY )
{
	//prof_begin( "add_hudelm_position_internal" );
	
	if ( level.console )
		self.fontScale = 2;
	else
		self.fontScale = 1.6;
		
	self.x = 0;// 320;
	self.y = -36;// 200;
	self.alignX = "center";
	
	/* if ( 0 )// if we ever get the chance to localize or find a way to dynamically find how many lines in a string
	{
		if ( isdefined( alignY ) )
			self.alignY = alignY;
		else
			self.alignY = "middle";	
	}
	else
	{*/ 
		self.alignY = "bottom";	
	// }
	
	self.horzAlign = "center";
	self.vertAlign = "middle";
	
	if ( !isdefined( self.background ) )
		return;
	self.background.x = 0;// 320;
	self.background.y = -40;// 200;
	self.background.alignX = "center";
	self.background.alignY = "middle";
	self.background.horzAlign = "center";
	self.background.vertAlign = "middle";
	if ( level.console )
		self.background setshader( "popmenu_bg", 650, 52 );
	else
		self.background setshader( "popmenu_bg", 650, 42 );
	self.background.alpha = .5;
	
	//prof_end( "add_hudelm_position_internal" );
}

create_warning_elem( ender )
{
	level.hudelm_unpause_ender = ender;
	level notify( "hud_elem_interupt" );
	hudelem = newHudElem();
	hudelem add_hudelm_position_internal();
	hudelem thread destroy_warning_elem_when_hit_again();
	hudelem thread destroy_warning_elem_when_mission_failed();
	hudelem setText( &"GAME_GET_TO_COVER" );
	hudelem.fontscale = 2;
	hudelem.alpha = 1;
	hudelem.color = ( 1, 0.9, 0.9 );

	return hudelem;
}

waitTillPlayerIsHitAgain()
{
	level endon( "hit_again" );
	level.player waittill( "damage" );
}


destroy_warning_elem_when_hit_again()
{
	self endon( "being_destroyed" );
	
	waitTillPlayerIsHitAgain();
	
	fadeout = ( !isalive( level.player ) );
	self thread destroy_warning_elem( fadeout );
}

destroy_warning_elem_when_mission_failed()
{
	self endon( "being_destroyed" );
	
	flag_wait( "missionfailed" );
	
	self thread destroy_warning_elem( true );
}

destroy_warning_elem( fadeout )
{
	self notify( "being_destroyed" );
	self.beingDestroyed = true;
	
	if ( fadeout )
	{
		self fadeOverTime( 0.5 );
		self.alpha = 0;
		wait 0.5;
	}
	self notify( "death" );
	self destroy();
}

mayChangeCoverWarningAlpha( coverWarning )
{
	if ( !isdefined( coverWarning ) )
		return false;
	if ( isdefined( coverWarning.beingDestroyed ) )
		return false;
	return true;
}

fontScaler( scale, timer )
{
	self endon( "death" );
	scale *= 2;
	dif = scale - self.fontscale;
	self changeFontScaleOverTime( timer );
	self.fontscale += dif;
}

fadeFunc( overlay, coverWarning, severity, mult, hud_scaleOnly )
{
	pulseTime = 0.8;
	scaleMin = 0.5;
	
	fadeInTime = pulseTime * 0.1;
	stayFullTime = pulseTime * ( .1 + severity * .2 );
	fadeOutHalfTime = pulseTime * ( 0.1 + severity * .1 );
	fadeOutFullTime = pulseTime * 0.3;
	remainingTime = pulseTime - fadeInTime - stayFullTime - fadeOutHalfTime - fadeOutFullTime;
	assert( remainingTime >= -.001 );
	if ( remainingTime < 0 )
		remainingTime = 0;
	
	halfAlpha = 0.8 + severity * 0.1;
	leastAlpha = 0.5 + severity * 0.3;
	
	overlay fadeOverTime( fadeInTime );
	overlay.alpha = mult * 1.0;
	if ( mayChangeCoverWarningAlpha( coverWarning ) )
	{
		if ( !hud_scaleOnly )
		{
			coverWarning fadeOverTime( fadeInTime );
			coverWarning.alpha = mult * 1.0;
		}
	}
	if ( isDefined( coverWarning ) )
		coverWarning thread fontScaler( 1.0, fadeInTime );
	wait fadeInTime + stayFullTime;
	
	overlay fadeOverTime( fadeOutHalfTime );
	overlay.alpha = mult * halfAlpha;
	if ( mayChangeCoverWarningAlpha( coverWarning ) )
	{
		if ( !hud_scaleOnly )
		{
			coverWarning fadeOverTime( fadeOutHalfTime );
			coverWarning.alpha = mult * halfAlpha;
		}
	}
	
	wait fadeOutHalfTime;
	
	overlay fadeOverTime( fadeOutFullTime );
	overlay.alpha = mult * leastAlpha;
	if ( mayChangeCoverWarningAlpha( coverWarning ) )
	{
		if ( !hud_scaleOnly )
		{
			coverWarning fadeOverTime( fadeOutFullTime );
			coverWarning.alpha = mult * leastAlpha;
		}
	}
	if ( isDefined( coverWarning ) )
		coverWarning thread fontScaler( 0.9, fadeOutFullTime );
	wait fadeOutFullTime;

	wait remainingTime;
}

shouldShowCoverWarning()
{
	if ( !isAlive( level.player ) )
		return false;
	
	if ( level.gameskill > 1 )
		return false;
	
	if ( level.missionfailed )
		return false;
	
	if ( !maps\_load::map_is_early_in_the_game() )
		return false;
	
	// note: takeCoverWarnings is 3 more than the number of warnings left.
	// this lets it stay away for a while unless we die 3 times in a row without taking cover successfully.
	takeCoverWarnings = getdvarint( "takeCoverWarnings" );
	if ( takeCoverWarnings <= 3 )
		return false;
	
	return true;
}


// &"GAME_GET_TO_COVER";
redFlashingOverlay( overlay )
{
	level endon( "hit_again" );
	level.player endon( "damage" );

	//prof_begin( "redFlashingOverlay" );
	
	coverWarning = undefined;
	
	if ( shouldShowCoverWarning() )
	{
		// get to cover!
		coverWarning = create_warning_elem( "take_cover_done" );
		// coverWarning may be destroyed at any time if we fail the mission.
	}
	
	// if severity isn't very high, the overlay becomes very unnoticeable to the player.
	// keep it high while they haven't regenerated or they'll feel like their health is nearly full and they're safe to step out.
	
	stopFlashingBadlyTime = gettime() + level.longRegenTime;
	
	fadeFunc( overlay, coverWarning, 1, 1, false );
	while ( gettime() < stopFlashingBadlyTime && isalive( level.player ) )
		fadeFunc( overlay, coverWarning, .9, 1, false );
	
	if ( isalive( level.player ) )
		fadeFunc( overlay, coverWarning, .65, 0.8, false );
	
	if ( mayChangeCoverWarningAlpha( coverWarning ) )
	{
		coverWarning fadeOverTime( 1.0 );
		coverWarning.alpha = 0;
	}
	
	fadeFunc( overlay, coverWarning, 0, 0.6, true );
	
	overlay fadeOverTime( 0.5 );
	overlay.alpha = 0;
	
	flag_clear( "player_has_red_flashing_overlay" );
	level.player thread play_sound_on_entity( "breathing_better" );
	
	//prof_end( "redFlashingOverlay" );
	
	wait( 0.5 );// for fade out
	level notify( "take_cover_done" );
	level notify( "hit_again" );
}

healthOverlay_remove( overlay )
{
	level.player waittill( "noHealthOverlay" );
	overlay destroy();
}

resetSkill()
{
	setskill( true );
}

setTakeCoverWarnings()
{
	// generates "Get to Cover" x number of times when you first get hurt
	// dvar defaults to - 1
	
	isPreGameplayLevel = ( level.script == "training" || level.script == "cargoship" || level.script == "coup" );
	
	if ( getdvarint( "takeCoverWarnings" ) == -1 || isPreGameplayLevel )
	{
		// takeCoverWarnings is 3 more than the number of warnings we want to occur.
		setdvar( "takeCoverWarnings", 3 + 6 );
	}
	 /#DebugTakeCoverWarnings();#/ 
}

increment_take_cover_warnings_on_death()
{
	level notify( "new_cover_on_death_thread" );	
	level endon( "new_cover_on_death_thread" );	
	level.player waittill( "death" );
	
	// dont increment if player died to grenades, explosion, etc
	if ( !flag( "player_has_red_flashing_overlay" ) )
		return;
	
	if ( level.gameSkill > 1 )
		return;
	
	warnings = getdvarint( "takeCoverWarnings" );
	if ( warnings < 10 )
		setdvar( "takeCoverWarnings", warnings + 1 );
	 /#DebugTakeCoverWarnings();#/ 
}

auto_adjust_difficulty_player_positioner()
{
	org = level.player.origin;
// 	thread debug_message( ".", org, 6 );
	wait( 5 );
	if ( autospot_is_close_to_player( org ) )
		level.autoAdjust_playerSpots[ level.autoAdjust_playerSpots.size ] = org;
}

autospot_is_close_to_player( org )
{
	return distanceSquared( level.player.origin, org ) < ( 140 * 140 );
}


auto_adjust_difficulty_player_movement_check()
{
	level.autoAdjust_playerSpots = [];
	level.player.movedRecently = true;
	wait( 1 );// for lvl start precaching of debug strings
	
	for ( ;; )
	{
		thread auto_adjust_difficulty_player_positioner();
		level.player.movedRecently = true;
		newSpots = [];
		start = level.autoAdjust_playerSpots.size - 5;
		if ( start < 0 )
			start = 0;
			
		for ( i = start; i < level.autoAdjust_playerSpots.size;i++ )
		{
			if ( !autospot_is_close_to_player( level.autoAdjust_playerSpots[ i ] ) )
				continue;
				
			newSpots[ newSpots.size ] = level.autoAdjust_playerSpots[ i ];
			level.player.movedRecently = false;
		// 	thread debug_message( "!", newSpots[ newSpots.size - 1 ], 1 );
		}
		
		level.autoAdjust_playerSpots = newSpots;
		
		wait( 1 );
	}
}


auto_adjust_difficulty_track_player_death()
{
	// reduce the difficulty timer when you die
	level.player waittill( "death" );
	num = getdvarint( "autodifficulty_playerDeathTimer" );
	num -= 60;
	setdvar( "autodifficulty_playerDeathTimer", num );
// 	scriptPrintln( "script_autodifficulty", "Set deathtimer to " + num );
}


auto_adjust_difficulty_track_player_shots()
{
	// reduce the "time spent alive" by the time between shots fired if there has been significant time between shots
	lastShotTime = gettime();
	for ( ;; )
	{
		if ( level.player attackButtonPressed() )
			lastShotTime = gettime();
			
		level.timeBetweenShots = gettime() - lastShotTime;
		wait( 0.05 );
		/* 
		if ( lastShotTime < 10000 )
			continue;

		playerDeathTimer = getcvarint( "playerDeathTimer" );
		playerDeathTimer = int( playerDeathTimer - lastShotTime * 0.001 );
		setcvar( "playerDeathTimer", playerDeathTimer );
		*/ 
	}
}


hud_debug_add_frac( msg, num )
{
	hud_debug_add_display( msg, num * 100, true );
}

hud_debug_add( msg, num )
{
	hud_debug_add_display( msg, num, false );
}

hud_debug_clear()
{
	level.hudNum = 0;
	if ( isdefined( level.hudDebugNum ) )
	{
		for ( i = 0;i < level.hudDebugNum.size;i++ )
			level.hudDebugNum[ i ] destroy();	
	}
	
	level.hudDebugNum = [];
}

hud_debug_add_message( msg )
{
	if ( !isdefined( level.hudMsgShare ) )
		level.hudMsgShare = [];
	if ( !isdefined( level.hudMsgShare[ msg ] ) )
	{
		hud = newHudElem();
		hud.x = level.debugLeft;
		hud.y = level.debugHeight + level.hudNum * 15;
		hud.foreground = 1;
		hud.sort = 100;
		hud.alpha = 1.0;
		hud.alignX = "left";
		hud.horzAlign = "left";
		hud.fontScale = 1.0;
		hud setText( msg );
		level.hudMsgShare[ msg ] = true;
	}
}

hud_debug_add_display( msg, num, isfloat )
{
	hud_debug_add_message( msg );
			
	num = int( num );
	negative = false;
	if ( num < 0 )
	{
		negative = true;
		num *= -1;
	}

	thousands = 0;
	hundreds = 0;
	tens = 0;
	ones = 0;
	while ( num >= 10000 )
		num -= 10000;
	
	while ( num >= 1000 )
	{
		num -= 1000;
		thousands++ ;
	}
	while ( num >= 100 )
	{
		num -= 100;
		hundreds++ ;
	}
	while ( num >= 10 )
	{
		num -= 10;
		tens++ ;
	}
	while ( num >= 1 )
	{
		num -= 1;
		ones++ ;
	}
	
	offset = 0;
	offsetSize = 10;
	if ( thousands > 0 )
	{
		hud_debug_add_num( thousands, offset );
		offset += offsetSize;
		hud_debug_add_num( hundreds, offset );
		offset += offsetSize;
		hud_debug_add_num( tens, offset );
		offset += offsetSize;
		hud_debug_add_num( ones, offset );
		offset += offsetSize;
	}
	else
	if ( hundreds > 0 || isFloat )
	{
		hud_debug_add_num( hundreds, offset );
		offset += offsetSize;
		hud_debug_add_num( tens, offset );
		offset += offsetSize;
		hud_debug_add_num( ones, offset );
		offset += offsetSize;
	}
	else
	if ( tens > 0 )
	{
		hud_debug_add_num( tens, offset );
		offset += offsetSize;
		hud_debug_add_num( ones, offset );
		offset += offsetSize;
	}
	else
	{
		hud_debug_add_num( ones, offset );
		offset += offsetSize;
	}

	if ( isFloat )
	{
		decimalHud = newHudElem();
		decimalHud.x = 204.5;
		decimalHud.y = level.debugHeight + level.hudNum * 15;
		decimalHud.foreground = 1;
		decimalHud.sort = 100;
		decimalHud.alpha = 1.0;
		decimalHud.alignX = "left";
		decimalHud.horzAlign = "left";
		decimalHud.fontScale = 1.0;
		decimalHud setText( "." );
		level.hudDebugNum[ level.hudDebugNum.size ] = decimalHud;
	}

	if ( negative )
	{
		negativeHud = newHudElem();
		negativeHud.x = 195.5;
		negativeHud.y = level.debugHeight + level.hudNum * 15;
		negativeHud.foreground = 1;
		negativeHud.sort = 100;
		negativeHud.alpha = 1.0;
		negativeHud.alignX = "left";
		negativeHud.horzAlign = "left";
		negativeHud.fontScale = 1.0;
		negativeHud setText( " - " );
		level.hudDebugNum[ level.hudNum ] = negativeHud;
	}
	
// 	level.hudDebugNum[ level.hudNum ] = hud;
	level.hudNum++ ;
}

hud_debug_add_string( msg, msg2 )
{
	hud_debug_add_message( msg );
	hud_debug_add_second_string( msg2, 0 );
	level.hudNum++ ;
}

hud_debug_add_num( num, offset )
{
	hud = newHudElem();
	hud.x = 200 + offset * 0.65;
	hud.y = level.debugHeight + level.hudNum * 15;
	hud.foreground = 1;
	hud.sort = 100;
	hud.alpha = 1.0;
	hud.alignX = "left";
	hud.horzAlign = "left";
	hud.fontScale = 1.0;
	hud setText( num + "" );
	level.hudDebugNum[ level.hudDebugNum.size ] = hud;
}

hud_debug_add_second_string( num, offset )
{
	hud = newHudElem();
	hud.x = 200 + offset * 0.65;
	hud.y = level.debugHeight + level.hudNum * 15;
	hud.foreground = 1;
	hud.sort = 100;
	hud.alpha = 1.0;
	hud.alignX = "left";
	hud.horzAlign = "left";
	hud.fontScale = 1.0;
	hud setText( num );
	level.hudDebugNum[ level.hudDebugNum.size ] = hud;
}

aa_init_stats()
{
	/#
	if ( getdvar( "createfx" ) == "on" )
		return;
	if ( getdvar( "r_reflectionProbeGenerate" ) == "1" )
	{
		return;
	}	
	#/
	//prof_begin( "aa_init_stats" );

	level.sp_stat_tracking_func = maps\_gameskill::auto_adjust_new_zone;
	
	setdvar( "aa_player_kills", "0" );
	setdvar( "aa_enemy_deaths", "0" );
	setdvar( "aa_enemy_damage_taken", "0" );
	setdvar( "aa_player_damage_taken", "0" );
	setdvar( "aa_player_damage_dealt", "0" );
	setdvar( "aa_ads_damage_dealt", "0" );
	setdvar( "aa_time_tracking", "0" );
	setdvar( "aa_deaths", "0" );
	
	setdvar( "player_cheated", 0 );
	
	level.auto_adjust_results = [];
	thread aa_time_tracking();
	thread aa_player_health_tracking();
	thread aa_player_ads_tracking();
	flag_set( "auto_adjust_initialized" );

	flag_init( "aa_main_" + level.script );
	flag_set( "aa_main_" + level.script );

	//prof_end( "aa_init_stats" );
}

command_used( cmd )
{	
	//prof_begin( "command_used" );
	
	binding = getKeyBinding( cmd );
	if ( binding[ "count" ] <= 0 )
	{
		//prof_end( "command_used" );
		return false;
	}
		
	for ( i = 1; i < binding[ "count" ] + 1; i++ )
	{
		if ( level.player buttonpressed( binding[ "key" + i ] ) )
		{
			//prof_end( "command_used" );
			return true;
		}
	}
	
	//prof_end( "command_used" );
	return false;
}

aa_time_tracking()
{
	/#
	if ( getdvar( "createfx" ) != "" )
		return;
	#/
	waittillframeend; // so level.start_point is defined
	for ( ;; )
	{
		//prof_begin( "aa_time_tracking" );
		
		aa_add_event_float( "aa_time_tracking", 0.2 );
		/#
		if ( IsGodMode( level.player ) || level.start_point != "default" || getdvar( "timescale" ) != "1" )
		{
			setdvar( "player_cheated", 1 );
		}
		#/
		/*
		level.sprint_key = getKeyBinding( "+breath_sprint" );
		sprinting = false;
		sprinting = command_used( "+sprint" );
		if ( !sprinting )
		{
			sprinting = command_used( "+breath_sprint" );
		}
		if ( sprinting )
		{
			aa_add_event_float( "aa_sprint_time", 0.2 );
		}
		*/
		wait( 0.2 );
	}	
}

aa_player_ads_tracking()
{
	level.player endon( "death" );
	level.player_ads_time = 0;
	for ( ;; )
	{
		if ( isADS() )
		{
			level.player_ads_time = gettime();
			while ( isADS() )
			{
				wait( 0.05 );
			}
			continue;
		}
		wait( 0.05 );
	}
}

aa_player_health_tracking()
{
	for ( ;; )
	{
		level.player waittill( "damage", amount );
		aa_add_event( "aa_player_damage_taken", amount );
		if ( !isalive( level.player ) )
		{
			aa_add_event( "aa_deaths", 1 );
			return;
		}
	}
}

auto_adjust_new_zone( zone )
{

		
	/#
	if ( getdvar( "createfx" ) == "on" )
		return;
	#/
	if ( !isdefined( level.auto_adjust_flags ) )
	{
		level.auto_adjust_flags = [];
	}
	
	flag_wait( "auto_adjust_initialized" );

	//prof_begin( "auto_adjust_new_zone" );
		
	level.auto_adjust_results[ zone ] = [];
	level.auto_adjust_flags[ zone ] = 0;
	flag_wait( zone );

	//prof_begin( "auto_adjust_new_zone" );

	// already processing this zone?
	if ( getdvar( "aa_zone" + zone ) == "" )
	{
		setdvar( "aa_zone" + zone, "on" );
		level.auto_adjust_flags[ zone ] = 1;
		aa_update_flags();
	
		setdvar( "start_time" + zone, getdvar( "aa_time_tracking" ) );
		
		// measure always
		setdvar( "starting_player_kills" + zone, getdvar( "aa_player_kills" ) );
		setdvar( "starting_deaths" + zone, getdvar( "aa_deaths" ) );
		setdvar( "starting_ads_damage_dealt" + zone, getdvar( "aa_ads_damage_dealt" ) );
		setdvar( "starting_player_damage_dealt" + zone, getdvar( "aa_player_damage_dealt" ) );
		setdvar( "starting_player_damage_taken" + zone, getdvar( "aa_player_damage_taken" ) );
		setdvar( "starting_enemy_damage_taken" + zone, getdvar( "aa_enemy_damage_taken" ) );
		setdvar( "starting_enemy_deaths" + zone, getdvar( "aa_enemy_deaths" ) );
	}
	else
	{
		if ( getdvar( "aa_zone" + zone ) == "done" )
		{
			//prof_end( "auto_adjust_new_zone" );
			return;
		}
	}

	//prof_end( "auto_adjust_new_zone" );
	flag_waitopen( zone );
	auto_adust_zone_complete( zone );
}

auto_adust_zone_complete( zone )
{
	//prof_begin( "auto_adust_zone_complete" );

	setdvar( "aa_zone" + zone, "done" );
	
	start_time = getdvarfloat( "start_time" + zone );
	starting_player_kills = getdvarint( "starting_player_kills" + zone );
	starting_enemy_deaths = getdvarint( "aa_enemy_deaths" + zone );
	starting_enemy_damage_taken = getdvarint( "aa_enemy_damage_taken" + zone );
	starting_player_damage_taken = getdvarint( "aa_player_damage_taken" + zone );
	starting_player_damage_dealt = getdvarint( "aa_player_damage_dealt" + zone );
	starting_ads_damage_dealt = getdvarint( "aa_ads_damage_dealt" + zone );
	starting_deaths = getdvarint( "aa_deaths" + zone );
	level.auto_adjust_flags[ zone ] = 0;
	aa_update_flags();

	total_time = getdvarfloat( "aa_time_tracking" ) - start_time;
	total_player_kills = getdvarint( "aa_player_kills" ) - starting_player_kills;
	total_enemy_deaths = getdvarint( "aa_enemy_deaths" ) - starting_enemy_deaths;

	player_kill_ratio = 0;
	if ( total_enemy_deaths > 0 )
	{
		player_kill_ratio = total_player_kills / total_enemy_deaths;
		player_kill_ratio *= 100;
		player_kill_ratio = int( player_kill_ratio );
	}
	
	total_enemy_damage_taken = getdvarint( "aa_enemy_damage_taken" ) - starting_enemy_damage_taken;
	total_player_damage_dealt = getdvarint( "aa_player_damage_dealt" ) - starting_player_damage_dealt;
	player_damage_dealt_ratio = 0;
	player_damage_dealt_per_minute = 0;
	if ( total_enemy_damage_taken > 0 && total_time > 0 )
	{
		player_damage_dealt_ratio = total_player_damage_dealt / total_enemy_damage_taken;
		player_damage_dealt_ratio *= 100;
		player_damage_dealt_ratio = int( player_damage_dealt_ratio );

		player_damage_dealt_per_minute = total_player_damage_dealt / total_time;
		player_damage_dealt_per_minute = player_damage_dealt_per_minute * 60;
		player_damage_dealt_per_minute = int( player_damage_dealt_per_minute );
	}

	total_ads_damage_dealt = getdvarint( "aa_ads_damage_dealt" ) - starting_ads_damage_dealt;
	player_ads_damage_ratio = 0;
	if ( total_player_damage_dealt > 0 )
	{
		player_ads_damage_ratio = total_ads_damage_dealt / total_player_damage_dealt;
		player_ads_damage_ratio *= 100;
		player_ads_damage_ratio = int( player_ads_damage_ratio );
	}
		
	
	total_player_damage_taken = getdvarint( "aa_player_damage_taken" ) - starting_player_damage_taken;
	
	player_damage_taken_ratio = 0;
	if ( total_time > 0 )
	{
		player_damage_taken_ratio = total_player_damage_taken / total_time;
	}
	
	player_damage_taken_per_minute = player_damage_taken_ratio * 60;
	player_damage_taken_per_minute = int( player_damage_taken_per_minute );

	
	total_deaths = getdvarint( "aa_deaths" ) - starting_deaths;
	
	aa_array = [];
	aa_array[ "player_damage_taken_per_minute" ] = player_damage_taken_per_minute;
	aa_array[ "player_damage_dealt_per_minute" ] = player_damage_dealt_per_minute;
	aa_array[ "minutes" ] = total_time / 60;
	aa_array[ "deaths" ] = total_deaths;
	aa_array[ "gameskill" ] = level.gameskill;
	
	level.auto_adjust_results[ zone ] = aa_array;

	msg = "Completed AA sequence: ";
	/#
	if ( getdvar( "player_cheated" ) == "1" )
	{
		msg = "Cheated in AA sequence: ";
	}
	#/
	
	msg += level.script + " / " + zone;
	keys = getarraykeys( aa_array );
//	array_levelthread( keys, ::aa_print_vals, aa_array );
	
	for ( i = 0; i < keys.size; i++ )
	{
		msg = msg + ", " + keys[ i ] + ": " + aa_array[ keys[ i ] ];
	}

	logstring( msg );
	println( "^6" + msg );
	
	//prof_end( "auto_adust_zone_complete" );
}

aa_print_vals( key, aa_array )
{
	logstring( key + ": " + aa_array[ key ] );
	println( "^6" + key + ": " + aa_array[ key ] );
}

/*
aa_print_vals( key, aa_array, file )
{
	fprintln( file, key + ": " + aa_array[ key ] );
}
*/

aa_update_flags()
{
}

aa_add_event( event, amount )
{
	old_amount = getdvarint( event );
	setdvar( event, old_amount + amount );
}

aa_add_event_float( event, amount )
{
	old_amount = getdvarfloat( event );
	setdvar( event, old_amount + amount );
}

return_false( attacker )
{
	return false;
}

player_attacker( attacker )
{
	if ( [[ level.custom_player_attacker ]]( attacker ) )
		return true;
	
	if ( attacker == level.player )
		return true;
		
	if ( !isdefined( attacker.car_damage_owner_recorder ) )
		return false;
	
	return attacker player_did_most_damage();
}

player_did_most_damage()
{
	return self.player_damage * 1.75 > self.non_player_damage;
}

empty_kill_func( type, loc, point )
{
	
}

auto_adjust_enemy_died( amount, attacker, type, point )
{
	//prof_begin( "auto_adjust_enemy_died" );
	
	/*
	Not worth effecting the speed of the game for one spot in one map in one mode
	// in case the team got changed.
	if ( self.team != "axis" )
		return;
	if ( isdefined( self.civilian ) )
		return;
	*/

	aa_add_event( "aa_enemy_deaths", 1 );
	if ( !isdefined( attacker ) )
	{
		//prof_end( "auto_adjust_enemy_died" );
		return;
	}
	if ( !player_attacker( attacker ) )
	{
		//prof_end( "auto_adjust_enemy_died" );
		return;
	}
	
	// defaults to empty_kill_func, for arcademode
	[[ level.global_kill_func ]]( type, self.damagelocation, point );
	
	aa_add_event( "aa_player_kills", 1 );
	
	//prof_end( "auto_adjust_enemy_died" );
}

auto_adjust_enemy_death_detection()
{
	for ( ;; )
	{
		self waittill( "damage", amount, attacker, direction_vec, point, type );
		aa_add_event( "aa_enemy_damage_taken", amount );

		if ( !isalive( self ) || self.delayeddeath )
		{
			self auto_adjust_enemy_died( amount, attacker, type, point );
			return;
		}
		
		if ( !player_attacker( attacker ) )
			continue;
		aa_player_attacks_enemy_with_ads( amount, type, point );
	}
}

aa_player_attacks_enemy_with_ads( amount, type, point )
{
	aa_add_event( "aa_player_damage_dealt", amount );
	assertex( getdvarint( "aa_player_damage_dealt" ) > 0 );
	if ( !isADS() )
	{
		// defaults to empty_kill_func, for arcademode
		[[ level.global_damage_func ]]( type, self.damagelocation, point );
		return false;
	}
		
	if ( !bullet_attack( type ) )
	{
		// defaults to empty_kill_func, for arcademode
		[[ level.global_damage_func ]]( type, self.damagelocation, point );
		return false;
	}

	// defaults to empty_kill_func, for arcademode
	[[ level.global_damage_func_ads ]]( type, self.damagelocation, point );
		
	// ads only matters for bullet attacks. Otherwise you could throw a grenade then go ads and get a bunch of ads damage
	aa_add_event( "aa_ads_damage_dealt", amount );
	return true;
}

bullet_attack( type )
{
	if ( type == "MOD_PISTOL_BULLET" )
		return true;
	return type == "MOD_RIFLE_BULLET";
}

/*
=============
///ScriptDocBegin
"Name: add_fractional_data_point( <name> , <frac> , <val> )"
"Summary: Adds difficulty setting data for a specific system at a specified fraction. The in game difficulty will be blended between this and the other data points."
"Module: gameskill"
"MandatoryArg: <name>: The system being adjusted."
"MandatoryArg: <frac>: Which fraction from 0 to 1 that this difficulty value exists at."
"MandatoryArg: <val>: The value that this system should be set at when the difficulty is at the specified frac."
"Example: 	add_fractional_data_point( "playerGrenadeRangeTime", 1.0, 7500 );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
add_fractional_data_point( name, frac, val )
{
	//prof_begin( "add_fractional_data_point" );
	
	if ( !isdefined( level.difficultySettings_frac_data_points[ name ] ) )
	{
		level.difficultySettings_frac_data_points[ name ] = [];
	}
	
	array = [];
	array[ "frac" ] = frac;
	array[ "val" ] = val;
	assertex( frac >= 0, "Tried to set a difficulty data point less than 0." );
	assertex( frac <= 1, "Tried to set a difficulty data point greater than 1." );
	
	level.difficultySettings_frac_data_points[ name ][ level.difficultySettings_frac_data_points[ name ].size ] = array;
	
	//prof_end( "add_fractional_data_point" );
}

update_skill_on_change()
{
	waittillframeend; // for everything to be defined	
	for ( ;; )
	{
		lowest_current_skill = getdvarint( "saved_gameskill" );
		gameskill = getdvarint( "g_gameskill" );
		if ( gameskill < lowest_current_skill )
			lowest_current_skill = gameskill;
			
		if ( lowest_current_skill < level.gameskill )
		{
			setSkill( true, lowest_current_skill );
		}
		
		wait( 2 );
	}
}
