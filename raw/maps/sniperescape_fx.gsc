#include maps\_utility;

main()
{
	add_earthquake( "large", 0.3, 0.6, 6000 );


	//Scripted FX
	level._effect[ "bird_pm" ]					 	= loadfx( "misc/bird_pm" );
	level._effect[ "bird_takeoff_pm" ]			 	= loadfx( "misc/bird_takeoff_pm" );
	level._effect[ "blood" ]					 	= loadfx( "impacts/sniper_escape_blood" );
	level._effect[ "tread_burnout" ]			 	= loadfx( "treadfx/tread_burnout_default" );
	level._effect[ "bullet_geo" ]					= loadfx( "smoke/smoke_geotrail_barret" );
	level._effect[ "rocket_geo" ]					= loadfx( "smoke/smoke_geotrail_rocket" );
	level._effect[ "wind_controlled_leaves" ]		= loadfx( "misc/wind_controlled_leaves" );
	level._effect[ "blood_pool" ]					= loadfx( "impacts/deathfx_bloodpool" );
	level._effect[ "ghillie_leaves" ]				= loadfx( "misc/gilli_leaves" );	
	level._effect[ "wall_explosion" ]				= loadfx( "explosions/wall_explosion_sniperescape" );
	level._effect[ "hind_fire" ]					= loadfx( "muzzleflashes/bmp_flash_wv" );
	

	//Ambient FX
	level._effect[ "snow_wind" ]						= loadfx( "weather/snow_wind" );
	level._effect[ "ground_smoke" ]						= loadfx( "smoke/ground_smoke_launch_a" );
	level._effect[ "firelp_med_pm" ]					= loadfx( "fire/firelp_med_pm" );
	level._effect[ "village_smolder_slow" ]				= loadfx( "smoke/village_smolder_slow" );	
	level._effect[ "village_smolder_hall" ]				= loadfx( "smoke/village_smolder_hall" );	
	level._effect[ "firelp_small_streak_pm_v" ]			= loadfx( "fire/firelp_small_streak_pm_v" );
	level._effect[ "firelp_small_streak_pm_h" ]			= loadfx( "fire/firelp_small_streak_pm_h" );
	level._effect[ "fire_wall_50" ]						= loadfx( "fire/fire_wall_50" );
	level._effect[ "lava" ]								= loadfx( "misc/lava" );	
	level._effect[ "lava_large" ]						= loadfx( "misc/lava_large" );	
	level._effect[ "lava_a" ]							= loadfx( "misc/lava_a" );
	level._effect[ "lava_a_large" ]						= loadfx( "misc/lava_a_large" );	
	level._effect[ "lava_b" ]							= loadfx( "misc/lava_b" );	
	level._effect[ "lava_c" ]							= loadfx( "misc/lava_c" );
	level._effect[ "lava_d" ]							= loadfx( "misc/lava_d" );
	level._effect[ "lava_ash_runner" ]					= loadfx( "misc/lava_ash_runner" );		
	
	// main building fx
	level._effect[ "aerial_explosion" ]					 = loadfx( "explosions/aerial_explosion" );
	level._effect[ "window_explosion" ]					 = loadfx( "explosions/window_explosion" );
	level._effect[ "window_rock" ]						 = loadfx( "explosions/window_rock" );
	level._effect[ "window_fire_large" ]				 = loadfx( "fire/window_fire_large" );
	level._effect[ "dust_ceiling_ash_large" ]			 = loadfx( "dust/dust_ceiling_ash_large" );
	level._effect[ "dust_ceiling_ash_large_stairwell" ]	 = loadfx( "dust/dust_ceiling_ash_large_stairwell" );
	level._effect[ "light_shaft_dust_med" ]				 = loadfx( "dust/light_shaft_dust_med" );	
	level._effect[ "light_shaft_dust_large" ]			 = loadfx( "dust/light_shaft_dust_large" );	
	level._effect[ "room_dust_200" ]					 = loadfx( "dust/room_dust_200" );	

	level._effect[ "heli_explosion" ]					= loadfx( "explosions/helicopter_explosion" );
	level._effect[ "aerial_explosion_heli" ]			= loadfx( "explosions/aerial_explosion_heli" );
	level._effect[ "helicopter_crash_dirt" ]			= loadfx( "explosions/helicopter_crash_dirt" );
	level._effect[ "aerial_explosion_large" ]			= loadfx( "explosions/aerial_explosion_large" );
	level._effect[ "detpack_explosion" ]				= loadfx( "explosions/exp_pack_hallway" );
	level._effect[ "heli_missile_launch" ]				= loadfx( "muzzleflashes/cobra_rocket_flash_wv" );
	level._effect[ "heli_engine_smolder" ]				= loadfx( "smoke/heli_engine_smolder" );	
	level._effect[ "fire_trail_heli" ]					= loadfx( "fire/fire_smoke_trail_L" );	
	level._effect[ "smoke_trail_heli" ]					= loadfx( "smoke/smoke_trail_black_heli" );	
	level._effect[ "brick_chunk" ]						= loadfx( "explosions/brick_chunk" );	
	level._effect[ "helicopter_tail_sparks" ]			= loadfx( "misc/helicopter_tail_sparks" );
	level._effect[ "rotor_smash" ]						= loadfx( "misc/rotor_smash" );
	level._effect[ "heli_dirt" ]						= loadfx( "explosions/heli_dirt" );
	level._effect[ "heli_dirt_rear" ]					= loadfx( "explosions/heli_dirt_rear" );
	level._effect[ "heli_rotor_dirt" ]					= loadfx( "explosions/heli_rotor_dirt" );
	level._effect[ "heli_crash_dust" ]					= loadfx( "dust/heli_crash_dust" );

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
	animscripts\utility::setFootstepEffect ("snow",			loadfx ("impacts/footstep_snow"));
	animscripts\utility::setFootstepEffect ("water",		loadfx ("impacts/footstep_water"));
	animscripts\utility::setFootstepEffect ("wood",			loadfx ("impacts/footstep_dust_dark"));

	level thread treadfx_override();

	maps\createfx\sniperescape_fx::main();

}

treadfx_override()
{
	maps\_treadfx::setvehiclefx( "uaz", "brick" ,"treadfx/tread_road_sniperescape" );
 	maps\_treadfx::setvehiclefx( "uaz", "bark" ,"treadfx/tread_dust_sniperescape" );
 	maps\_treadfx::setvehiclefx( "uaz", "carpet" ,"treadfx/tread_dust_sniperescape" );
 	maps\_treadfx::setvehiclefx( "uaz", "cloth" ,"treadfx/tread_dust_sniperescape" );
 	maps\_treadfx::setvehiclefx( "uaz", "concrete" ,"treadfx/tread_road_sniperescape" );
 	maps\_treadfx::setvehiclefx( "uaz", "dirt" ,"treadfx/tread_dust_sniperescape" );
 	maps\_treadfx::setvehiclefx( "uaz", "flesh" ,"treadfx/tread_dust_sniperescape" );
 	maps\_treadfx::setvehiclefx( "uaz", "foliage" ,"treadfx/tread_dust_sniperescape" );
 	maps\_treadfx::setvehiclefx( "uaz", "glass" ,"treadfx/tread_dust_sniperescape" );
 	maps\_treadfx::setvehiclefx( "uaz", "grass" ,"treadfx/tread_dust_sniperescape" );
 	maps\_treadfx::setvehiclefx( "uaz", "gravel" ,"treadfx/tread_dust_sniperescape" );
 	maps\_treadfx::setvehiclefx( "uaz", "ice" ,"treadfx/tread_dust_sniperescape" );
 	maps\_treadfx::setvehiclefx( "uaz", "metal" ,"treadfx/tread_road_sniperescape" );
 	maps\_treadfx::setvehiclefx( "uaz", "mud" ,"treadfx/tread_dust_sniperescape" );
 	maps\_treadfx::setvehiclefx( "uaz", "paper" ,"treadfx/tread_dust_sniperescape" );
 	maps\_treadfx::setvehiclefx( "uaz", "plaster" ,"treadfx/tread_dust_sniperescape" );
 	maps\_treadfx::setvehiclefx( "uaz", "rock" ,"treadfx/tread_dust_sniperescape" );
 	maps\_treadfx::setvehiclefx( "uaz", "sand" ,"treadfx/tread_dust_sniperescape" );
 	maps\_treadfx::setvehiclefx( "uaz", "snow" ,"treadfx/tread_dust_sniperescape" );
 	maps\_treadfx::setvehiclefx( "uaz", "water" ,"treadfx/tread_dust_sniperescape" );
 	maps\_treadfx::setvehiclefx( "uaz", "wood" ,"treadfx/tread_dust_sniperescape" );
 	maps\_treadfx::setvehiclefx( "uaz", "asphalt" ,"treadfx/tread_road_sniperescape" );
 	maps\_treadfx::setvehiclefx( "uaz", "ceramic" ,"treadfx/tread_dust_sniperescape" );
 	maps\_treadfx::setvehiclefx( "uaz", "plastic" ,"treadfx/tread_dust_sniperescape" );
 	maps\_treadfx::setvehiclefx( "uaz", "rubber" ,"treadfx/tread_dust_sniperescape" );
 	maps\_treadfx::setvehiclefx( "uaz", "cushion" ,"treadfx/tread_dust_sniperescape" );
 	maps\_treadfx::setvehiclefx( "uaz", "fruit" ,"treadfx/tread_dust_sniperescape" );
 	maps\_treadfx::setvehiclefx( "uaz", "painted metal" ,"treadfx/tread_dust_sniperescape" );
 	maps\_treadfx::setvehiclefx( "uaz", "default" ,"treadfx/tread_road_sniperescape" );
	maps\_treadfx::setvehiclefx( "uaz", "none" ,"treadfx/tread_road_sniperescape" );

	maps\_treadfx::setvehiclefx( "seaknight", "brick" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "seaknight", "bark" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "seaknight", "carpet" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "seaknight", "cloth" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "seaknight", "concrete" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "seaknight", "dirt" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "seaknight", "flesh" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "seaknight", "foliage" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "seaknight", "glass" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "seaknight", "grass" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "seaknight", "gravel" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "seaknight", "ice" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "seaknight", "metal" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "seaknight", "mud" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "seaknight", "paper" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "seaknight", "plaster" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "seaknight", "rock" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "seaknight", "sand" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "seaknight", "snow" ,"treadfx/heli_snow_default" );
 	maps\_treadfx::setvehiclefx( "seaknight", "water" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "seaknight", "wood" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "seaknight", "asphalt" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "seaknight", "ceramic" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "seaknight", "plastic" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "seaknight", "rubber" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "seaknight", "cushion" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "seaknight", "fruit" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "seaknight", "painted metal" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "seaknight", "default" ,"treadfx/heli_dust_ambush" );
	maps\_treadfx::setvehiclefx( "seaknight", "none" ,"treadfx/heli_dust_ambush" );

	maps\_treadfx::setvehiclefx( "mi17", "brick" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "mi17", "bark" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "mi17", "carpet" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "mi17", "cloth" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "mi17", "concrete" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "mi17", "dirt" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "mi17", "flesh" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "mi17", "foliage" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "mi17", "glass" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "mi17", "grass" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "mi17", "gravel" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "mi17", "ice" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "mi17", "metal" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "mi17", "mud" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "mi17", "paper" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "mi17", "plaster" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "mi17", "rock" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "mi17", "sand" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "mi17", "snow" ,"treadfx/heli_snow_default" );
 	maps\_treadfx::setvehiclefx( "mi17", "water" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "mi17", "wood" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "mi17", "asphalt" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "mi17", "ceramic" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "mi17", "plastic" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "mi17", "rubber" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "mi17", "cushion" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "mi17", "fruit" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "mi17", "painted metal" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "mi17", "default" ,"treadfx/heli_dust_ambush" );
	maps\_treadfx::setvehiclefx( "mi17", "none" ,"treadfx/heli_dust_ambush" );

	maps\_treadfx::setvehiclefx( "mi28", "brick" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "mi28", "bark" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "mi28", "carpet" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "mi28", "cloth" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "mi28", "concrete" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "mi28", "dirt" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "mi28", "flesh" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "mi28", "foliage" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "mi28", "glass" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "mi28", "grass" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "mi28", "gravel" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "mi28", "ice" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "mi28", "metal" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "mi28", "mud" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "mi28", "paper" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "mi28", "plaster" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "mi28", "rock" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "mi28", "sand" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "mi28", "snow" ,"treadfx/heli_snow_default" );
 	maps\_treadfx::setvehiclefx( "mi28", "water" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "mi28", "wood" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "mi28", "asphalt" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "mi28", "ceramic" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "mi28", "plastic" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "mi28", "rubber" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "mi28", "cushion" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "mi28", "fruit" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "mi28", "painted metal" ,"treadfx/heli_dust_ambush" );
 	maps\_treadfx::setvehiclefx( "mi28", "default" ,"treadfx/heli_dust_ambush" );
	maps\_treadfx::setvehiclefx( "mi28", "none" ,"treadfx/heli_dust_ambush" );


}