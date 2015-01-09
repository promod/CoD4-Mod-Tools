#include maps\_utility;

main()
{
	level._effect["fog_villassault"]				= loadfx ("weather/fog_villassault");
	level._effect["firelp_med_pm"]					= loadfx ("fire/firelp_med_pm");
	level._effect["fire_med_nosmoke"]				= loadfx("fire/ground_fire_med_nosmoke"); 
	level._effect["fire_sm_trail"]					= loadfx ("props/barrel_fire"); 
	level._effect["headlights"]						= loadfx ("misc/lighthaze");
	level._effect["lighthaze_villassault"]			= loadfx ("misc/lighthaze_villassault");
	level._effect["firelp_small_streak_pm_v"]		= loadfx ("fire/firelp_small_streak_pm_v");
	level._effect["firelp_small_streak_pm_h"]		= loadfx ("fire/firelp_small_streak_pm_h");
	level._effect["firelp_small_streak_pm1_h"]		= loadfx ("fire/firelp_small_streak_pm1_h");
	level._effect["firelp_med_streak_pm_h"]			= loadfx ("fire/firelp_med_streak_pm_h");
	level._effect["firelp_large_pm"]				= loadfx ("fire/firelp_large_pm");
	level._effect["embers_burst_runner"]			= loadfx ("fire/embers_burst_runner");
	level._effect["emb_burst_a"]					= loadfx ("fire/emb_burst_a");
	level._effect["emb_burst_b"]					= loadfx ("fire/emb_burst_b");
	level._effect["emb_burst_c"]					= loadfx ("fire/emb_burst_c");	
	level._effect["fire_fallingdebris"]				= loadfx ("fire/fire_fallingdebris");
	level._effect["fire_fallingdebris_a"]			= loadfx ("fire/fire_fallingdebris_a");
	level._effect["fire_debris_child"]				= loadfx ("fire/fire_debris_child");
	level._effect["fire_debris_child_a"]			= loadfx ("fire/fire_debris_child_a");
	level._effect["leaves_va"]						= loadfx ("misc/leaves_va");
	level._effect["moth_runner"]					= loadfx ("misc/moth_runner");
	level._effect["moth_a"]							= loadfx ("misc/moth_a");
	level._effect["moth"]							= loadfx ("misc/moth");
	level._effect["insect_trail_a"]					= loadfx ("misc/insect_trail_a");
	level._effect["insect_trail_b"]					= loadfx ("misc/insect_trail_b");
	level._effect["insect_trail_runner"]			= loadfx ("misc/insect_trail_runner");
	level._effect["village_ash"]					= loadfx ("smoke/village_ash");
	
	level.flare_fx["mi28"] 							= loadfx( "misc/flares_cobra" );
	
	
	level._effect["air_support_fx_yellow"] 			= loadfx( "misc/ui_pickup_available" );
	level._effect["air_support_fx_red"] 			= loadfx( "misc/ui_pickup_unavailable" );
	level._effect["ffar_mi28_muzzleflash"] 			= loadfx( "muzzleflashes/cobra_rocket_flash_wv" );
	level._effect["alasad_flash"] 					= loadfx( "misc/village_assault_alasad_flash" );
	
	level._effect[ "headshot" ]						= loadfx ( "impacts/flesh_hit_head_fatal_exit" );
	level._effect[ "flashlight" ]					= loadfx( "misc/flashlight" );
	
	//footstep fx
	animscripts\utility::setFootstepEffect ("asphalt",		loadfx ("impacts/footstep_dust_dark"));
	animscripts\utility::setFootstepEffect ("brick",		loadfx ("impacts/footstep_dust_dark"));
	animscripts\utility::setFootstepEffect ("carpet",		loadfx ("impacts/footstep_dust_dark"));
	animscripts\utility::setFootstepEffect ("cloth",		loadfx ("impacts/footstep_dust_dark"));
	animscripts\utility::setFootstepEffect ("concrete",		loadfx ("impacts/footstep_dust_dark"));
	animscripts\utility::setFootstepEffect ("dirt",			loadfx ("impacts/footstep_dust_dark"));
	animscripts\utility::setFootstepEffect ("foliage",		loadfx ("impacts/footstep_dust_dark"));
	animscripts\utility::setFootstepEffect ("grass",		loadfx ("impacts/footstep_dust_dark"));
	animscripts\utility::setFootstepEffect ("mud",			loadfx ("impacts/footstep_mud_dark"));
	animscripts\utility::setFootstepEffect ("rock",			loadfx ("impacts/footstep_dust_dark"));
	animscripts\utility::setFootstepEffect ("sand",			loadfx ("impacts/footstep_dust_dark"));
	animscripts\utility::setFootstepEffect ("water",		loadfx ("impacts/footstep_water_dark"));
	animscripts\utility::setFootstepEffect ("wood",			loadfx ("impacts/footstep_dust_dark"));
	
	treadfx_override();
	
	maps\createfx\village_assault_fx::main();
}


treadfx_override()
{
	maps\_treadfx::setvehiclefx( "bmp", "brick" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "bmp", "bark" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "bmp", "carpet" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "bmp", "cloth" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "bmp", "concrete" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "bmp", "dirt" ,"treadfx/tread_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "bmp", "flesh" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "bmp", "foliage" ,"treadfx/tread_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "bmp", "glass" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "bmp", "grass" ,"treadfx/tread_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "bmp", "gravel" ,"treadfx/tread_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "bmp", "ice" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "bmp", "metal" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "bmp", "mud" ,"treadfx/tread_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "bmp", "paper" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "bmp", "plaster" ,"treadfx/tread_road_hunted" );
	maps\_treadfx::setvehiclefx( "bmp", "road" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "bmp", "rock" ,"treadfx/tread_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "bmp", "sand" ,"treadfx/tread_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "bmp", "snow" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "bmp", "water" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "bmp", "wood" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "bmp", "asphalt" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "bmp", "ceramic" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "bmp", "plastic" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "bmp", "rubber" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "bmp", "cushion" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "bmp", "fruit" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "bmp", "painted metal" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "bmp", "default" ,"treadfx/tread_road_hunted" );
	maps\_treadfx::setvehiclefx( "bmp", "none" ,"treadfx/tread_road_hunted" );

	maps\_treadfx::setvehiclefx( "mi28", "brick" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "mi28", "bark" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "mi28", "carpet" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "mi28", "cloth" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "mi28", "concrete" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "mi28", "dirt" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "mi28", "flesh" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "mi28", "foliage" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "mi28", "glass" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "mi28", "grass" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "mi28", "gravel" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "mi28", "ice" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "mi28", "metal" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "mi28", "mud" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "mi28", "paper" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "mi28", "plaster" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "mi28", "rock" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "mi28", "sand" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "mi28", "snow" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "mi28", "wood" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "mi28", "asphalt" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "mi28", "ceramic" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "mi28", "plastic" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "mi28", "rubber" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "mi28", "cushion" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "mi28", "fruit" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "mi28", "painted metal" ,"treadfx/heli_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "mi28", "default" ,"treadfx/heli_dust_hunted" );
	maps\_treadfx::setvehiclefx( "mi28", "none" ,"treadfx/heli_dust_hunted" );
	
}
