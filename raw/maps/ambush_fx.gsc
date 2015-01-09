#include maps\_utility;

main()
{
	level thread precacheFX();
	level thread treadfx_override();

	maps\createfx\ambush_fx::main();

}

precacheFX()
{
	
	level._effect["ambush_vl"]						= loadfx ("misc/ambush_vl");
	level._effect["ambush_vl_far"]					= loadfx ("misc/ambush_vl_far");
	level._effect["amb_dust"]						= loadfx ("smoke/amb_dust");
	level._effect["amb_ash"]						= loadfx ("smoke/amb_ash");
	level._effect["amb_smoke_add"]					= loadfx ("smoke/amb_smoke_add");
	level._effect["amb_smoke_add_1"]				= loadfx ("smoke/amb_smoke_add_1");
	level._effect["amb_smoke_add_1_far"]			= loadfx ("smoke/amb_smoke_add_1_far");
	level._effect["amb_smoke_blend"]				= loadfx ("smoke/amb_smoke_blend");
	level._effect["firelp_small_pm"]				= loadfx ("fire/firelp_small_pm");
	level._effect["firelp_small_pm_a"]				= loadfx ("fire/firelp_small_pm_a");
	level._effect["firelp_small_streak_pm_h"]		= loadfx ("fire/firelp_small_streak_pm_h");
	level._effect["hallways_smoke_light"]			= loadfx ("smoke/hallway_smoke_light");
	level._effect["thin_black_smoke_L"]				= loadfx ("smoke/thin_black_smoke_L");
	level._effect["thin_black_smoke_M"]				= loadfx ("smoke/thin_black_smoke_M");

	// gameplay
	level._effect["mg_nest_expl"]			= loadfx ("explosions/small_vehicle_explosion");
	level._effect["bullet_spark"]			= loadfx ("impacts/large_metalhit_1");
	level._effect["head_fatal"]				= loadfx ("impacts/flesh_hit_head_fatal_exit");
	level._effect["bloodpool"]				= loadfx ("impacts/deathfx_bloodpool_ambush");

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

}

treadfx_override()
{
	maps\_treadfx::setvehiclefx( "bmp", "brick" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "bmp", "bark" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "bmp", "carpet" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "bmp", "cloth" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "bmp", "concrete" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "bmp", "dirt" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "bmp", "flesh" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "bmp", "foliage" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "bmp", "glass" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "bmp", "grass" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "bmp", "gravel" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "bmp", "ice" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "bmp", "metal" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "bmp", "mud" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "bmp", "paper" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "bmp", "plaster" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "bmp", "rock" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "bmp", "sand" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "bmp", "snow" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "bmp", "water" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "bmp", "wood" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "bmp", "asphalt" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "bmp", "ceramic" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "bmp", "plastic" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "bmp", "rubber" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "bmp", "cushion" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "bmp", "fruit" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "bmp", "painted metal" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "bmp", "default" ,"treadfx/tread_dust_ambush" );
	maps\_treadfx::setvehiclefx( "bmp", "none" ,"treadfx/tread_dust_ambush" );

	maps\_treadfx::setvehiclefx( "bm21_troops", "brick" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "bm21_troops", "bark" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "bm21_troops", "carpet" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "bm21_troops", "cloth" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "bm21_troops", "concrete" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "bm21_troops", "dirt" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "bm21_troops", "flesh" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "bm21_troops", "foliage" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "bm21_troops", "glass" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "bm21_troops", "grass" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "bm21_troops", "gravel" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "bm21_troops", "ice" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "bm21_troops", "metal" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "bm21_troops", "mud" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "bm21_troops", "paper" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "bm21_troops", "plaster" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "bm21_troops", "rock" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "bm21_troops", "sand" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "bm21_troops", "snow" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "bm21_troops", "water" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "bm21_troops", "wood" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "bm21_troops", "asphalt" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "bm21_troops", "ceramic" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "bm21_troops", "plastic" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "bm21_troops", "rubber" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "bm21_troops", "cushion" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "bm21_troops", "fruit" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "bm21_troops", "painted metal" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "bm21_troops", "default" ,"treadfx/tread_dust_ambush" );
	maps\_treadfx::setvehiclefx( "bm21_troops", "none" ,"treadfx/tread_dust_ambush" );
	
	maps\_treadfx::setvehiclefx( "uaz", "brick" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "uaz", "bark" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "uaz", "carpet" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "uaz", "cloth" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "uaz", "concrete" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "uaz", "dirt" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "uaz", "flesh" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "uaz", "foliage" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "uaz", "glass" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "uaz", "grass" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "uaz", "gravel" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "uaz", "ice" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "uaz", "metal" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "uaz", "mud" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "uaz", "paper" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "uaz", "plaster" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "uaz", "rock" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "uaz", "sand" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "uaz", "snow" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "uaz", "water" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "uaz", "wood" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "uaz", "asphalt" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "uaz", "ceramic" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "uaz", "plastic" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "uaz", "rubber" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "uaz", "cushion" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "uaz", "fruit" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "uaz", "painted metal" ,"treadfx/tread_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "uaz", "default" ,"treadfx/tread_dust_ambush" );
	maps\_treadfx::setvehiclefx( "uaz", "none" ,"treadfx/tread_dust_ambush" );

	maps\_treadfx::setvehiclefx( "blackhawk", "brick" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "bark" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "carpet" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "cloth" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "concrete" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "dirt" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "flesh" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "foliage" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "glass" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "grass" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "gravel" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "ice" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "metal" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "mud" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "paper" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "plaster" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "rock" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "sand" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "snow" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "water" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "wood" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "asphalt" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "ceramic" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "plastic" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "rubber" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "cushion" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "fruit" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "painted metal" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "default" ,"treadfx/heli_dust_ambush" );
	maps\_treadfx::setvehiclefx( "blackhawk", "none" ,"treadfx/heli_dust_ambush" );

}
