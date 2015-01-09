#include common_scripts\utility;
#include maps\_utility;

main()

{
	level._effect["firelp_vhc_lrg_pm_farview"]		= loadfx ("fire/firelp_vhc_lrg_pm_farview");
	level._effect["lighthaze"]						= loadfx ("misc/lighthaze"); 
	level._effect["firelp_med_pm"]					= loadfx ("fire/firelp_med_pm");
	level._effect["firelp_small_pm"]				= loadfx ("fire/firelp_small_pm");
	level._effect["firelp_small_pm_a"]				= loadfx ("fire/firelp_small_pm_a");
	level._effect["fog_hunted"]						= loadfx ("weather/fog_hunted");
	level._effect["fog_hunted_a"]					= loadfx ("weather/fog_hunted_a");
	level._effect["bird_pm"]						= loadfx ("misc/bird_pm");
	level._effect["bird_takeoff_pm"]				= loadfx ("misc/bird_takeoff_pm");
	level._effect["leaves"]							= loadfx ("misc/leaves");
	level._effect["leaves_runner"]					= loadfx ("misc/leaves_runner");
	level._effect["leaves_runner_1"]				= loadfx ("misc/leaves_runner_1");
	level._effect["leaves_lp"]						= loadfx ("misc/leaves_lp");
	level._effect["leaves_gl"]						= loadfx ("misc/leaves_gl");
	level._effect["leaves_gl_a"]					= loadfx ("misc/leaves_gl_a");
	level._effect["leaves_gl_b"]					= loadfx ("misc/leaves_gl_b");	
	level._effect["hunted_vl"]						= loadfx ("misc/hunted_vl");	
	level._effect["hunted_vl_sm"]					= loadfx ("misc/hunted_vl_sm");
	level._effect["hunted_vl_od_lrg"]				= loadfx ("misc/hunted_vl_od_lrg");	
	level._effect["hunted_vl_od_lrg_a"]				= loadfx ("misc/hunted_vl_od_lrg_a");	
	level._effect["hunted_vl_od_sml"]				= loadfx ("misc/hunted_vl_od_sml");	
	level._effect["hunted_vl_od_sml_a"]				= loadfx ("misc/hunted_vl_od_sml_a");
	level._effect["hunted_vl_od_dtl_a"]				= loadfx ("misc/hunted_vl_od_dtl_a");
	level._effect["hunted_vl_od_dtl_b"]				= loadfx ("misc/hunted_vl_od_dtl_b");			
	level._effect["mist_hunted_add"]				= loadfx ("weather/mist_hunted_add");	
	level._effect["insects_light_hunted"]			= loadfx ("misc/insects_light_hunted");	
	level._effect["insects_light_hunted_a"]			= loadfx ("misc/insects_light_hunted_a");	
	level._effect["hunted_vl_white_eql"]			= loadfx ("misc/hunted_vl_white_eql");	
	level._effect["hunted_vl_white_eql_flare"]		= loadfx ("misc/hunted_vl_white_eql_flare");
	level._effect["hunted_vl_white_eql_a"]			= loadfx ("misc/hunted_vl_white_eql_a");	
	level._effect["grenadeexp_fuel"]				= loadfx ("explosions/grenadeexp_fuel");
	level._effect["hunted_fel"]						= loadfx ("misc/hunted_fel");	
	level._effect["greenhouse_fog_spot_lit"]		= loadfx ("smoke/greenhouse_fog_spot_lit");	
	level._effect["waterfall_hunted"]				= loadfx ("misc/waterfall_hunted");	
	level._effect["stream_hunted"]					= loadfx ("misc/stream_hunted");

	//footstep fx
	animscripts\utility::setFootstepEffect ("asphalt",		loadfx ("impacts/footstep_dust_dark"));
	animscripts\utility::setFootstepEffect ("brick",		loadfx ("impacts/footstep_dust_dark"));
	animscripts\utility::setFootstepEffect ("carpet",		loadfx ("impacts/footstep_dust_dark"));
	animscripts\utility::setFootstepEffect ("cloth",		loadfx ("impacts/footstep_dust_dark"));
	animscripts\utility::setFootstepEffect ("concrete",		loadfx ("impacts/footstep_dust_dark"));
	animscripts\utility::setFootstepEffect ("dirt",			loadfx ("impacts/footstep_dust_dark"));
	animscripts\utility::setFootstepEffect ("foliage",		loadfx ("impacts/footstep_dust_dark"));
	animscripts\utility::setFootstepEffect ("grass",		loadfx ("impacts/footstep_dust_dark"));
	animscripts\utility::setFootstepEffect ("metal",		loadfx ("impacts/footstep_dust_dark"));
	animscripts\utility::setFootstepEffect ("mud",			loadfx ("impacts/footstep_mud_dark"));
	animscripts\utility::setFootstepEffect ("rock",			loadfx ("impacts/footstep_dust_dark"));
	animscripts\utility::setFootstepEffect ("sand",			loadfx ("impacts/footstep_dust_dark"));
	animscripts\utility::setFootstepEffect ("water",		loadfx ("impacts/footstep_water_dark"));
	animscripts\utility::setFootstepEffect ("wood",			loadfx ("impacts/footstep_dust_dark"));
			
	
	// level script effects
	level._effect["truck_smoke"]					= loadfx ("smoke/car_damage_blacksmoke");
	level._effect["flashlight"]						= loadfx ("misc/flashlight");

	// "hunted light" required zfeather == 1 and r_zfeather is undefined on console.  So, test for != "0".
	if ( getdvarint( "sm_enable" ) && getdvar( "r_zfeather" ) != "0" )
		level._effect["spotlight"]						= loadfx ("misc/hunted_spotlight_model");
	else
		level._effect["spotlight"]						= loadfx ("misc/spotlight_large");

	level.flare_fx["mi17"] 							= loadfx( "misc/flares_cobra" );

	//gas station destruction
	level._effect["gasstation_explosion"]			= loadfx ("explosions/hunted_gasstation_explosion");
	level._effect["big_explosion"]					= loadfx ("explosions/helicopter_explosion");
	level._effect["small_explosion"]				= loadfx ("explosions/small_vehicle_explosion");
	level._effect["tracer_incoming"]				= loadfx ("misc/tracer_incoming");
	level._effect["gas_pump_fire"]					= loadfx ("fire/gas_pump_fire");
	level._effect["thin_black_smoke_M"]				= loadfx ("smoke/thin_black_smoke_M");
	level._effect["tire_fire_med"]					= loadfx ("fire/tire_fire_med");

	level._effect["heli_dlight_blue"]					= loadfx ("misc/aircraft_light_cockpit_blue");
	level._effect["heli_dlight_red"]					= loadfx ("misc/aircraft_light_cockpit_red");
	level._effect["missile_explosion"]				= loadfx ("explosions/small_vehicle_explosion");
	
	//Temporarly added to make fx placement easier	
	//ac130_gas_station();
	treadfx_override();
	maps\createfx\hunted_fx::main();
}

treadfx_override()
{
	maps\_treadfx::setvehiclefx( "t72", "brick" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "t72", "bark" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "t72", "carpet" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "t72", "cloth" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "t72", "concrete" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "t72", "dirt" ,"treadfx/tread_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "t72", "flesh" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "t72", "foliage" ,"treadfx/tread_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "t72", "glass" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "t72", "grass" ,"treadfx/tread_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "t72", "gravel" ,"treadfx/tread_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "t72", "ice" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "t72", "metal" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "t72", "mud" ,"treadfx/tread_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "t72", "paper" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "t72", "plaster" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "t72", "rock" ,"treadfx/tread_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "t72", "sand" ,"treadfx/tread_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "t72", "snow" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "t72", "water" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "t72", "wood" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "t72", "asphalt" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "t72", "ceramic" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "t72", "plastic" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "t72", "rubber" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "t72", "cushion" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "t72", "fruit" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "t72", "painted metal" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "t72", "default" ,"treadfx/tread_road_hunted" );
	maps\_treadfx::setvehiclefx( "t72", "none" ,"treadfx/tread_road_hunted" );

	maps\_treadfx::setvehiclefx( "bm21_troops", "brick" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "bm21_troops", "bark" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "bm21_troops", "carpet" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "bm21_troops", "cloth" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "bm21_troops", "concrete" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "bm21_troops", "dirt" ,"treadfx/tread_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "bm21_troops", "flesh" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "bm21_troops", "foliage" ,"treadfx/tread_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "bm21_troops", "glass" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "bm21_troops", "grass" ,"treadfx/tread_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "bm21_troops", "gravel" ,"treadfx/tread_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "bm21_troops", "ice" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "bm21_troops", "metal" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "bm21_troops", "mud" ,"treadfx/tread_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "bm21_troops", "paper" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "bm21_troops", "plaster" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "bm21_troops", "rock" ,"treadfx/tread_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "bm21_troops", "sand" ,"treadfx/tread_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "bm21_troops", "snow" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "bm21_troops", "water" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "bm21_troops", "wood" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "bm21_troops", "asphalt" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "bm21_troops", "ceramic" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "bm21_troops", "plastic" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "bm21_troops", "rubber" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "bm21_troops", "cushion" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "bm21_troops", "fruit" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "bm21_troops", "painted metal" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "bm21_troops", "default" ,"treadfx/tread_road_hunted" );
	maps\_treadfx::setvehiclefx( "bm21_troops", "none" ,"treadfx/tread_road_hunted" );
	
	maps\_treadfx::setvehiclefx( "truck", "brick" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "truck", "bark" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "truck", "carpet" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "truck", "cloth" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "truck", "concrete" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "truck", "dirt" ,"treadfx/tread_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "truck", "flesh" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "truck", "foliage" ,"treadfx/tread_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "truck", "glass" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "truck", "grass" ,"treadfx/tread_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "truck", "gravel" ,"treadfx/tread_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "truck", "ice" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "truck", "metal" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "truck", "mud" ,"treadfx/tread_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "truck", "paper" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "truck", "plaster" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "truck", "rock" ,"treadfx/tread_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "truck", "sand" ,"treadfx/tread_dust_hunted" );
 	maps\_treadfx::setvehiclefx( "truck", "snow" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "truck", "water" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "truck", "wood" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "truck", "asphalt" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "truck", "ceramic" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "truck", "plastic" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "truck", "rubber" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "truck", "cushion" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "truck", "fruit" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "truck", "painted metal" ,"treadfx/tread_road_hunted" );
 	maps\_treadfx::setvehiclefx( "truck", "default" ,"treadfx/tread_road_hunted" );
	maps\_treadfx::setvehiclefx( "truck", "none" ,"treadfx/tread_road_hunted" );

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

fuel_explosion()
{
	maps\_utility::exploder(20);

	maps\_utility::play_sound_in_space ( "hunted_fuel_explosion", (2577.57, -8615.74, 373.73) );

   	ent = maps\_utility::createOneshotEffect("firelp_vhc_lrg_pm_farview");
   	ent.v["origin"] = (2577.57,-8615.74,373.73);
   	ent.v["angles"] = (270,0,0);
   	ent.v["fxid"] = "firelp_vhc_lrg_pm_farview";
   	ent.v["delay"] = -15;
	ent maps\_createfx::set_forward_and_up_vectors();

	ent thread maps\_fx::OneShotfxthread();
}

//Temporarly added to make fx placement easier
ac130_gas_station()
{
	gas_station = getentarray( "gas_station" ,"targetname" );
	gas_station_d = getentarray( "gas_station_d" ,"targetname" );
	big_explosion = getentarray( "big_explosion" ,"targetname" );
	small_explosion = getentarray( "small_explosion" ,"targetname" );

	array_thread( gas_station, ::hide_ent );
	array_thread( gas_station_d, ::swap_ent, (7680,0, 0) );
}

//Temporarly added to make fx placement easier
hide_ent( nodelay )
{
	self hide();
}

//Temporarly added to make fx placement easier
swap_ent( offset )
{
	self.origin = self.origin + offset;
	self show();
}