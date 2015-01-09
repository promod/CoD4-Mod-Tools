#include maps\_utility;

main()
{
	level._effect["saw_sparks"]						= loadfx ("misc/rescuesaw_sparks");
	level._effect["headshot"]						= loadfx ("impacts/flesh_hit_head_fatal_exit");
	level._effect["c4_secondary_explosion_01"]		= loadfx ("explosions/exp_pack_hallway");  																																																																																																																																	
	level._effect["c4_secondary_explosion_02"]	 	= loadfx ("explosions/grenadeExp_metal");
	level._effect["hind_explosion"]					= loadfx ("explosions/helicopter_explosion");
	level._effect["heli_aerial_explosion"]			= loadfx ("explosions/aerial_explosion");
	level._effect["heli_aerial_explosion_large"]	= loadfx ("explosions/aerial_explosion_large");
	level._effect["smoke_trail_heli"]				= loadfx ("fire/fire_smoke_trail_L");
	level._effect["smoke_trail_bmp"]				= loadfx ("smoke/damaged_vehicle_smoke");
	level._effect["tree_fire_fx"][0]				= loadfx ("smoke/thin_black_smoke_L");
	level._effect["tree_fire_fx"][1]				= loadfx ("fire/firelp_large_pm");
	level._effect["tree_fire_fx"][2]				= loadfx ("fire/firelp_large_pm");
	level._effect["tree_fire_fx"][3]				= loadfx ("smoke/smoke_large");
	level._effect["tree_fire_fx"][4]				= loadfx ("fire/firelp_large_pm");
	level._effect["tree_fire_fx"][5]				= loadfx ("fire/firelp_med_pm");
	level._effect["tree_fire_fx"][6]				= loadfx ("smoke/smoke_large");
	level._effect["tree_fire_fx"][7]				= loadfx ("fire/firelp_med_pm");
	level._effect["tree_fire_fx"][8]				= loadfx ("fire/firelp_large_pm");
	level._effect["launchtube_steam"]				= loadfx ("smoke/launchTube_steam");
	level._effect["rappel_objective"]				= loadfx ("misc/ui_pickup_available");

	//ambient fx
	level._effect["smoke_missile_launched_01"] 		= loadfx ("smoke/smoke_launchtubes");
	level._effect["smoke_missile_launched_02"] 		= loadfx ("smoke/smoke_launchtubes");
	level._effect["steam_large_vent"]				= loadfx ("smoke/steam_large_vent");
	level._effect["steam_large_vent_shaft"]			= loadfx ("smoke/steam_large_vent_shaft");
	level._effect["firelp_large_pm"]				= loadfx ("fire/firelp_large_pm");
	level._effect["snow_wind"]						= loadfx("weather/snow_wind");
	level._effect["ground_smoke_launch_a"]			= loadfx("smoke/ground_smoke_launch_a");


	//footstep fx	
	animscripts\utility::setFootstepEffect ("asphalt",		loadfx ("impacts/footstep_dust"));
	animscripts\utility::setFootstepEffect ("brick",		loadfx ("impacts/footstep_dust"));
	animscripts\utility::setFootstepEffect ("carpet",		loadfx ("impacts/footstep_dust"));
	animscripts\utility::setFootstepEffect ("cloth",		loadfx ("impacts/footstep_dust"));
	animscripts\utility::setFootstepEffect ("concrete",		loadfx ("impacts/footstep_dust"));
	animscripts\utility::setFootstepEffect ("dirt",			loadfx ("impacts/footstep_dust"));
	animscripts\utility::setFootstepEffect ("foliage",		loadfx ("impacts/footstep_dust"));
	animscripts\utility::setFootstepEffect ("grass",		loadfx ("impacts/footstep_dust"));
	animscripts\utility::setFootstepEffect ("metal",		loadfx ("impacts/footstep_dust"));
	animscripts\utility::setFootstepEffect ("mud",			loadfx ("impacts/footstep_snow"));
	animscripts\utility::setFootstepEffect ("rock",			loadfx ("impacts/footstep_dust"));
	animscripts\utility::setFootstepEffect ("sand",			loadfx ("impacts/footstep_dust"));
	animscripts\utility::setFootstepEffect ("snow",			loadfx ("impacts/footstep_snow"));
	animscripts\utility::setFootstepEffect ("water",		loadfx ("impacts/footstep_water"));
	animscripts\utility::setFootstepEffect ("wood",			loadfx ("impacts/footstep_dust"));
	
	/*-----------------------
	SOUND EFFECTS
	-------------------------*/
	//level.scr_sound["vent_fall"]					= "XXX";
	level.scr_sound["launch_chopsaw1"]				= "launch_chopsaw1";
	level.scr_sound["launch_chopsaw2"]				= "launch_chopsaw2";
	level.scr_sound["launch_heli_dying_loop"]		= "launch_heli_dying_loop";
	level.scr_sound["launch_heli_alarm_loop"]		= "launch_heli_alarm_loop";
	level.scr_sound["launch_alarm_buzzer"]			= "launch_alarm_buzzer";
	level.scr_sound["launch_tube_prepare"]			= "launch_tube_prepare";
	level.scr_sound["launch_tube_open_start"]		= "launch_tube_open_start";
	level.scr_sound["launch_tube_open_loop"]		= "launch_tube_open_loop";
	level.scr_sound["launch_tube_open_end"]			= "launch_tube_open_end";


	//Hind Deathfx override
	maps\_vehicle::build_deathfx_override( "hind",  "explosions/grenadeexp_default" , 	"tag_engine_left", 	"hind_helicopter_hit", 				undefined, 			undefined, 		undefined, 		0.2, 		true );
	maps\_vehicle::build_deathfx_override( "hind",  "explosions/grenadeexp_default" , 	"tail_rotor_jnt", 	"hind_helicopter_hit", 				undefined, 			undefined, 		undefined, 		0.5, 		true );
	maps\_vehicle::build_deathfx_override( "hind",  "fire/fire_smoke_trail_L" , 		"tail_rotor_jnt", 	"hind_helicopter_dying_loop", 		true, 				0.05, 			true, 			0.5, 		true );
	maps\_vehicle::build_deathfx_override( "hind",  "explosions/aerial_explosion" , 	"tag_engine_right", "hind_helicopter_hit", 				undefined, 			undefined, 		undefined, 		2.5, 		true );
	maps\_vehicle::build_deathfx_override( "hind",  "explosions/aerial_explosion" , 	"tag_deathfx", 		"hind_helicopter_hit", 		 		undefined, 			undefined, 		undefined, 		4.0 );
	maps\_vehicle::build_deathfx_override( "hind",  "explosions/aerial_explosion_large" , 	undefined, 	"hind_helicopter_crash", 			undefined, 			undefined, 		undefined, 		8.5, 		undefined, 	"stop_crash_loop_sound" );

	maps\createfx\launchfacility_a_fx::main();
}
