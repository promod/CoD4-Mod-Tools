#include maps\_utility;

main()
{
	level.airstrikefx = loadfx ("explosions/clusterbomb");
	level.mortareffect = loadfx ("explosions/artilleryExp_dirt_brown");
	level.bombstrike = loadfx ("explosions/wall_explosion_pm_a");
	
	level.fx_airstrike_afterburner = loadfx ("fire/jet_afterburner");
	level.fx_airstrike_contrail = loadfx ("smoke/jet_contrail");
	
	level.smokegrenade 							= loadfx ("smoke/smoke_grenade_low");
	level.megaExplosion							= loadfx ("explosions/powerTower_explosion");
	
	level._effect["village_smolder"]			= loadfx ("smoke/village_smolder");
	level._effect["village_smolder_alt"]		= loadfx ("smoke/village_smolder_alt");	
	level._effect["firelp_small_dl"]			= loadfx ("fire/firelp_small_dl");	
	level._effect["insect_trail_runner"]		= loadfx ("misc/insect_trail_runner");	
	level._effect["moth_runner"]				= loadfx ("misc/moth_runner");	
	level._effect["insects_carcass_runner"]		= loadfx ("misc/insects_carcass_runner");
	level._effect["insects_carcass_runner_far"]	= loadfx ("misc/insects_carcass_runner_far");			
	level._effect["lava"]						= loadfx ("misc/lava");	
	level._effect["lava_a"]						= loadfx ("misc/lava_a");
	level._effect["lava_b"]						= loadfx ("misc/lava_b");	
	level._effect["lava_c"]						= loadfx ("misc/lava_c");
	level._effect["lava_d"]						= loadfx ("misc/lava_d");
	level._effect["lava_ash_runner"]			= loadfx ("misc/lava_ash_runner");		
	level._effect["firelp_small_dl_h"]			= loadfx ("fire/firelp_small_dl_h");
	level._effect["firelp_small_dl"]			= loadfx ("fire/firelp_small_dl");		
	level._effect["village_def_vl_sml"]			= loadfx ("misc/village_def_vl_sml");
	level._effect["village_def_vl_sml_a"]		= loadfx ("misc/village_def_vl_sml_a");	
	level._effect["village_vl_sml"]				= loadfx ("misc/village_vl_sml");
	level._effect["village_vl_int"]				= loadfx ("misc/village_vl_int");
	level._effect["village_vl_int_a"]			= loadfx ("misc/village_vl_int_a");	
	level._effect["village_vl_lrg"]				= loadfx ("misc/village_vl_lrg");	
	level._effect["village_cloud_far"]			= loadfx ("weather/village_cloud_far");
	level._effect["icbm_dust_int"]				= loadfx ("smoke/icbm_dust_int");
	level._effect["village_bounce"]				= loadfx ("misc/village_bounce");	
	level._effect["hawks"]						= loadfx ("misc/hawks");
	level._effect["leaves_runner_pine"]			= loadfx ("misc/leaves_runner_pine");
	level._effect["birds_village_runner"]		= loadfx ("misc/birds_village_runner");
	level._effect["birds_village_runner_far"]	= loadfx ("misc/birds_village_runner_far");
	level._effect["sewer_stream_village"]		= loadfx ("distortion/sewer_stream_village");
	level._effect["sewer_stream_village_far"]	= loadfx ("distortion/sewer_stream_village_far");
	
	level._effect["belltower_explosion"]		= loadfx ("explosions/belltower_explosion");
	level._effect["tracer_incoming"]			= loadfx ("misc/tracer_incoming");
	level._effect["killzone_marker"]			= loadfx ("misc/ui_flagbase_gold");
	
	level._effect[ "turret_overheat_haze" ]		= loadfx ( "distortion/abrams_exhaust" );
	level._effect[ "turret_overheat_smoke" ]	= loadfx ( "distortion/armored_car_overheat" );

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
	animscripts\utility::setFootstepEffect ("mud",			loadfx ("impacts/footstep_mud_dark"));
	animscripts\utility::setFootstepEffect ("rock",			loadfx ("impacts/footstep_dust"));
	animscripts\utility::setFootstepEffect ("sand",			loadfx ("impacts/footstep_dust"));
	animscripts\utility::setFootstepEffect ("water",		loadfx ("impacts/footstep_water"));
	animscripts\utility::setFootstepEffect ("wood",			loadfx ("impacts/footstep_dust"));
	
	treadfx_override();
	
	maps\createfx\village_defend_fx::main();
}

treadfx_override()
{
	maps\_treadfx::setvehiclefx( "t72", "brick" ,"treadfx/tread_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "t72", "bark" ,"treadfx/tread_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "t72", "carpet" ,"treadfx/tread_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "t72", "cloth" ,"treadfx/tread_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "t72", "concrete" ,"treadfx/tread_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "t72", "dirt" ,"treadfx/tread_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "t72", "flesh" ,"treadfx/tread_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "t72", "foliage" ,"treadfx/tread_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "t72", "glass" ,"treadfx/tread_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "t72", "grass" ,"treadfx/tread_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "t72", "gravel" ,"treadfx/tread_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "t72", "ice" ,"treadfx/tread_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "t72", "metal" ,"treadfx/tread_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "t72", "mud" ,"treadfx/tread_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "t72", "paper" ,"treadfx/tread_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "t72", "plaster" ,"treadfx/tread_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "t72", "rock" ,"treadfx/tread_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "t72", "sand" ,"treadfx/tread_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "t72", "snow" ,"treadfx/tread_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "t72", "water" ,"treadfx/tread_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "t72", "wood" ,"treadfx/tread_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "t72", "asphalt" ,"treadfx/tread_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "t72", "ceramic" ,"treadfx/tread_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "t72", "plastic" ,"treadfx/tread_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "t72", "rubber" ,"treadfx/tread_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "t72", "cushion" ,"treadfx/tread_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "t72", "fruit" ,"treadfx/tread_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "t72", "painted metal" ,"treadfx/tread_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "t72", "default" ,"treadfx/tread_dust_village_defend" );
	maps\_treadfx::setvehiclefx( "t72", "none" ,"treadfx/tread_dust_village_defend" );

	maps\_treadfx::setvehiclefx( "seaknight", "brick" ,"treadfx/heli_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "seaknight", "bark" ,"treadfx/heli_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "seaknight", "carpet" ,"treadfx/heli_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "seaknight", "cloth" ,"treadfx/heli_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "seaknight", "concrete" ,"treadfx/heli_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "seaknight", "dirt" ,"treadfx/heli_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "seaknight", "flesh" ,"treadfx/heli_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "seaknight", "foliage" ,"treadfx/heli_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "seaknight", "glass" ,"treadfx/heli_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "seaknight", "grass" ,"treadfx/heli_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "seaknight", "gravel" ,"treadfx/heli_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "seaknight", "ice" ,"treadfx/heli_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "seaknight", "metal" ,"treadfx/heli_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "seaknight", "mud" ,"treadfx/heli_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "seaknight", "paper" ,"treadfx/heli_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "seaknight", "plaster" ,"treadfx/heli_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "seaknight", "rock" ,"treadfx/heli_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "seaknight", "sand" ,"treadfx/heli_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "seaknight", "snow" ,"treadfx/heli_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "seaknight", "water" ,"treadfx/seaknight_water" );
 	maps\_treadfx::setvehiclefx( "seaknight", "wood" ,"treadfx/heli_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "seaknight", "asphalt" ,"treadfx/heli_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "seaknight", "ceramic" ,"treadfx/heli_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "seaknight", "plastic" ,"treadfx/heli_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "seaknight", "rubber" ,"treadfx/heli_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "seaknight", "cushion" ,"treadfx/heli_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "seaknight", "fruit" ,"treadfx/heli_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "seaknight", "painted metal" ,"treadfx/heli_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "seaknight", "default" ,"treadfx/heli_dust_village_defend" );
	maps\_treadfx::setvehiclefx( "seaknight", "none" ,"treadfx/heli_dust_village_defend" );

	maps\_treadfx::setvehiclefx( "mi17", "brick" ,"treadfx/heli_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "mi17", "bark" ,"treadfx/heli_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "mi17", "carpet" ,"treadfx/heli_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "mi17", "cloth" ,"treadfx/heli_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "mi17", "concrete" ,"treadfx/heli_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "mi17", "dirt" ,"treadfx/heli_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "mi17", "flesh" ,"treadfx/heli_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "mi17", "foliage" ,"treadfx/heli_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "mi17", "glass" ,"treadfx/heli_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "mi17", "grass" ,"treadfx/heli_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "mi17", "gravel" ,"treadfx/heli_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "mi17", "ice" ,"treadfx/heli_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "mi17", "metal" ,"treadfx/heli_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "mi17", "mud" ,"treadfx/heli_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "mi17", "paper" ,"treadfx/heli_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "mi17", "plaster" ,"treadfx/heli_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "mi17", "rock" ,"treadfx/heli_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "mi17", "sand" ,"treadfx/heli_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "mi17", "snow" ,"treadfx/heli_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "mi17", "wood" ,"treadfx/heli_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "mi17", "asphalt" ,"treadfx/heli_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "mi17", "ceramic" ,"treadfx/heli_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "mi17", "plastic" ,"treadfx/heli_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "mi17", "rubber" ,"treadfx/heli_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "mi17", "cushion" ,"treadfx/heli_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "mi17", "fruit" ,"treadfx/heli_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "mi17", "painted metal" ,"treadfx/heli_dust_village_defend" );
 	maps\_treadfx::setvehiclefx( "mi17", "default" ,"treadfx/heli_dust_village_defend" );
	maps\_treadfx::setvehiclefx( "mi17", "none" ,"treadfx/heli_dust_village_defend" );


}
