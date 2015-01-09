#include maps\_utility;

main()
{
	/* -- -- -- -- -- -- -- -- -- -- -- - 
	PARTICLE EFFECTS
	 -- -- -- -- -- -- -- -- -- -- -- -- -*/ 	
	level._effect[ "water_stop" ]						 = loadfx( "misc/parabolic_water_stand" );
	level._effect[ "water_movement" ]					 = loadfx( "misc/parabolic_water_movement" );
	level._effect[ "spotlight" ]						 = loadfx( "misc/flashlight_spotlight" );
	level._effect[ "flashlight" ]						 = loadfx( "misc/flashlight" );
	level._effect[ "pistol_muzzleflash" ]				 = loadfx( "muzzleflashes/pistolflash" );
	
	//level._effect[ "knife_stab" ]						 = loadfx( "misc/parabolic_knife_stab" );
	
	// Ambient
	level._effect[ "firelp_med_pm" ]					 = loadfx( "fire/firelp_med_pm" );
 	level._effect[ "fog_river_200" ]					 = loadfx( "weather/fog_river_200" );
 	level._effect[ "insects_firefly_a" ]				 = loadfx( "misc/insects_firefly_a" );
	level._effect[ "dust_ceiling_ash_small" ]			 = loadfx( "dust/dust_ceiling_ash_small" );	
	level._effect[ "light_shaft_dust_med" ]				 = loadfx( "dust/light_shaft_dust_med" );	
	level._effect[ "light_shaft_dust_field" ]			 = loadfx( "dust/light_shaft_dust_field" );	
	level._effect[ "moth_runner" ]						 = loadfx( "misc/moth_runner" );
	level._effect[ "insects_carcass_runner" ]			 = loadfx( "misc/insects_carcass_runner" );
	level._effect[ "hallway_smoke_dark" ]				 = loadfx( "smoke/hallway_smoke_dark" );

	// Fire House
	level._effect[ "lava" ]								 = loadfx( "misc/lava" );	
	level._effect[ "lava_large" ]						 = loadfx( "misc/lava_large" );	
	level._effect[ "lava_a" ]							 = loadfx( "misc/lava_a" );
	level._effect[ "lava_a_large" ]						 = loadfx( "misc/lava_a_large" );	
	level._effect[ "lava_b" ]							 = loadfx( "misc/lava_b" );	
	level._effect[ "lava_c" ]							 = loadfx( "misc/lava_c" );
	level._effect[ "lava_d" ]							 = loadfx( "misc/lava_d" );
	level._effect[ "lava_ash_runner" ]					 = loadfx( "misc/lava_ash_runner" );		
	level._effect[ "village_smolder_slow" ]				 = loadfx( "smoke/village_smolder_slow" );	
	level._effect[ "firelp_small_streak_pm_v" ]			 = loadfx( "fire/firelp_small_streak_pm_v" );
	level._effect[ "firelp_small_streak_pm_h" ]			 = loadfx( "fire/firelp_small_streak_pm_h" );
	
	level._effect[ "mortar" ]							 = loadfx( "explosions/grenadeExp_mud_1" );

	// footstep fx
	animscripts\utility::setFootstepEffect( "asphalt", 		loadfx( "impacts/footstep_dust_dark" ) );
	animscripts\utility::setFootstepEffect( "brick", 		loadfx( "impacts/footstep_dust_dark" ) );
	animscripts\utility::setFootstepEffect( "carpet", 		loadfx( "impacts/footstep_dust_dark" ) );
	animscripts\utility::setFootstepEffect( "cloth", 		loadfx( "impacts/footstep_dust_dark" ) );
	animscripts\utility::setFootstepEffect( "concrete", 	loadfx( "impacts/footstep_dust_dark" ) );
	animscripts\utility::setFootstepEffect( "dirt", 		loadfx( "impacts/footstep_dust_dark" ) );
	animscripts\utility::setFootstepEffect( "foliage", 		loadfx( "impacts/footstep_dust_dark" ) );
	animscripts\utility::setFootstepEffect( "grass", 		loadfx( "impacts/footstep_dust_dark" ) );
	animscripts\utility::setFootstepEffect( "metal", 		loadfx( "impacts/footstep_dust_dark" ) );
	animscripts\utility::setFootstepEffect( "mud", 			loadfx( "impacts/footstep_mud_dark" ) );
	animscripts\utility::setFootstepEffect( "rock", 		loadfx( "impacts/footstep_dust_dark" ) );
	animscripts\utility::setFootstepEffect( "sand", 		loadfx( "impacts/footstep_dust_dark" ) );
//	animscripts\utility::setFootstepEffect( "water", 		loadfx( "impacts/footstep_water_dark" ) );
	animscripts\utility::setFootstepEffect( "wood", 		loadfx( "impacts/footstep_dust_dark" ) );
	

	/* -- -- -- -- -- -- -- -- -- -- -- - 
	SOUND EFFECTS
	 -- -- -- -- -- -- -- -- -- -- -- -- -*/ 		
	level.scr_sound[ "fortress_artillery_intro_01" ]	 = "parabolic_artillery_intro_01";
	level.scr_sound[ "fortress_artillery_intro_02" ]	 = "parabolic_artillery_intro_02";
	level.scr_sound[ "truck_engine_start" ]				 = "technical_start";
	level.scr_sound[ "parabolic_guardrail_scrape" ]		 = "parabolic_guardrail_scrape";
	level.scr_sound[ "parabolic_truck_fenderbender" ]	 = "parabolic_truck_fenderbender";
	level.scr_sound[ "parabolic_truck_peelout" ]		 = "parabolic_truck_peelout";
	level.scr_sound[ "spotlight_on" ]					 = "parabolic_spotlight_on";
	level.scr_sound[ "snd_breach_balcony_door" ] 		 = "detpack_explo_concrete";
	level.scr_sound[ "snd_breach_wooden_door" ] 		 = "detpack_explo_main";
	level.scr_sound[ "snd_wood_door_kick" ] 			 = "wood_door_kick";
	level.scr_sound[ "window_shutters_open" ] 			 = "wood_door_kick";
	
	level.scr_sound[ "knife_sequence" ] 				 = "parabolic_knife_sequence";
	level.scr_sound[ "muffled_voices" ] 				 = "parabolic_muffled_voices";
	// level.scr_sound[ "water_move_loop" ] 			 = "parabolic_water_move_loop";
	// level.scr_sound[ "gate_open" ] 					 = "parabolic_gate_open";			// \Doors\gate_iron_open.wav
	
	treadfx_override();
	
	maps\createfx\blackout_fx::main();
	
}

treadfx_override()
{

	maps\_treadfx::setvehiclefx( "blackhawk", "brick" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "bark" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "carpet" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "cloth" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "concrete" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "dirt" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "flesh" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "foliage" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "glass" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "grass" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "gravel" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "ice" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "metal" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "mud" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "paper" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "plaster" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "rock" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "sand" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "snow" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "water" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "wood" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "asphalt" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "ceramic" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "plastic" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "rubber" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "cushion" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "fruit" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "painted metal" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "default" ,"treadfx/heli_dust_hunted" );
	maps\_treadfx::setvehiclefx( "blackhawk", "none" ,"treadfx/heli_dust_hunted" );

	maps\_treadfx::setvehiclefx( "mi17", "brick" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "mi17", "bark" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "mi17", "carpet" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "mi17", "cloth" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "mi17", "concrete" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "mi17", "dirt" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "mi17", "flesh" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "mi17", "foliage" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "mi17", "glass" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "mi17", "grass" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "mi17", "gravel" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "mi17", "ice" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "mi17", "metal" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "mi17", "mud" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "mi17", "paper" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "mi17", "plaster" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "mi17", "rock" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "mi17", "sand" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "mi17", "snow" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "mi17", "water" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "mi17", "wood" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "mi17", "asphalt" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "mi17", "ceramic" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "mi17", "plastic" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "mi17", "rubber" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "mi17", "cushion" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "mi17", "fruit" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "mi17", "painted metal" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "mi17", "default" ,"treadfx/heli_dust_hunted" );
	maps\_treadfx::setvehiclefx( "mi17", "none" ,"treadfx/heli_dust_hunted" );
	
}
