main()
{
	//----------------------------
	// Placed Effects Declarations
	//----------------------------
	level._effect["paper_falling_burning"]				= loadfx( "misc/paper_falling_burning" );
	level._effect["battlefield_smokebank_S"]			= loadfx( "smoke/battlefield_smokebank_S" );
	level._effect["thin_black_smoke_M"]					= loadfx( "smoke/thin_black_smoke_M" );
	level._effect["thin_black_smoke_L"]					= loadfx( "smoke/thin_black_smoke_L" );
	level._effect["dust_wind_slow"]						= loadfx( "dust/dust_wind_slow_yel_loop" );

	
	//-----------------------
	//Mortar effects & sounds
	//-----------------------
	
	level._effect["mortar"]["dirt"]						= loadfx( "explosions/grenadeExp_dirt" );
	level._effect["mortar"]["mud"]						= loadfx( "explosions/grenadeExp_mud" );
	
	level.scr_sound["mortar"]["incomming"]				= "mortar_incoming";
	level.scr_sound["mortar"]["dirt"]					= "mortar_explosion_dirt";
	level.scr_sound["mortar"]["mud"]					= "mortar_explosion_water";
	
	level._effect["wall_explosion_small"]				= loadfx( "explosions/wall_explosion_small" );
	level._effect["wall_explosion_grnd"]				= loadfx( "explosions/wall_explosion_grnd" );
	level._effect["wall_explosion_draft"]				= loadfx( "explosions/wall_explosion_draft" );
	level._effect["wall_explosion_round"]				= loadfx( "explosions/wall_explosion_round" );
	level._effect["tank_round_spark"]					= loadfx( "impacts/tank_round_spark" );
	
	level._effect["exploder"]["100"]					= loadfx( "explosions/wall_explosion_small" );
	level._effect["exploder"]["101"]					= loadfx( "explosions/wall_explosion_small" );
	level._effect["exploder"]["102"]					= loadfx( "explosions/wall_explosion_small" );
	level._effect["exploder"]["102"]					= loadfx( "explosions/wall_explosion_draft" );
	level._effect["exploder"]["103"]					= loadfx( "explosions/wall_explosion_small" );
	level._effect["exploder"]["104"]					= loadfx( "explosions/wall_explosion_small" );
	level._effect["exploder"]["105"]					= loadfx( "explosions/wall_explosion_grnd" );
	level._effect["exploder"]["400"]					= loadfx( "explosions/wall_explosion_round" );

	
	level._vehicle_effect["tankcrush"]["window_med"]	= loadfx( "props/car_glass_med");
	level._vehicle_effect["tankcrush"]["window_large"]	= loadfx( "props/car_glass_large");
	
	level._effect[ "mg_kill_grenade" ]					= loadfx( "explosions/grenadeExp_wood" );
	level.scr_sound[ "mg_kill_grenade_bounce" ]			= "grenade_bounce_wood";
	level.scr_sound[ "mg_kill_grenade_explode" ]		= "grenade_explode_wood";
	
	level._effect["afterburner"]						= loadfx ("fire/jet_afterburner");
	level._effect[ "contrail" ]							= loadfx( "smoke/jet_contrail" );
	level._effect["abrams_exhaust"]						= loadfx ("distortion/abrams_exhaust");
	
	//End Tank Destruction
	level._effect["t72_explosion"]						= loadfx ("explosions/large_vehicle_explosion");
	level._effect["t72_ammo_breach"]					= loadfx ("explosions/tank_ammo_breach");
	level._effect["t72_ammo_explosion"]					= loadfx ("explosions/t72_ammo_explosion");
	level._effect["firelp_large_pm"]					= loadfx ("fire/firelp_large_pm");

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
	animscripts\utility::setFootstepEffect ("mud",			loadfx ("impacts/footstep_mud"));
	animscripts\utility::setFootstepEffect ("rock",			loadfx ("impacts/footstep_dust"));
	animscripts\utility::setFootstepEffect ("sand",			loadfx ("impacts/footstep_dust"));
	animscripts\utility::setFootstepEffect ("water",		loadfx ("impacts/footstep_water"));
	animscripts\utility::setFootstepEffect ("wood",			loadfx ("impacts/footstep_dust"));
	

	//Override Tread FX
	maps\_treadfx::setvehiclefx( "m1a1", "brick" ,"treadfx/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "m1a1", "bark" ,"treadfx/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "m1a1", "carpet" ,"treadfx/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "m1a1", "cloth" ,"treadfx/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "m1a1", "concrete" ,"treadfx/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "m1a1", "dirt" ,"treadfx/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "m1a1", "flesh" ,"treadfx/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "m1a1", "foliage" ,"treadfx/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "m1a1", "glass" ,"treadfx/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "m1a1", "grass" ,"treadfx/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "m1a1", "gravel" ,"treadfx/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "m1a1", "ice" ,"treadfx/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "m1a1", "metal" ,"treadfx/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "m1a1", "mud" ,"treadfx/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "m1a1", "paper" ,"treadfx/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "m1a1", "plaster" ,"treadfx/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "m1a1", "rock" ,"treadfx/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "m1a1", "sand" ,"treadfx/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "m1a1", "snow" ,"treadfx/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "m1a1", "water" ,"treadfx/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "m1a1", "wood" ,"treadfx/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "m1a1", "asphalt" ,"treadfx/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "m1a1", "ceramic" ,"treadfx/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "m1a1", "plastic" ,"treadfx/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "m1a1", "rubber" ,"treadfx/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "m1a1", "cushion" ,"treadfx/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "m1a1", "fruit" ,"treadfx/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "m1a1", "painted metal" ,"treadfx/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "m1a1", "default" ,"treadfx/tread_dust_bog_b" );
	maps\_treadfx::setvehiclefx( "m1a1", "none" ,"treadfx/tread_dust_bog_b" );

	maps\_treadfx::setvehiclefx( "t72", "brick" ,"treadfx/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "t72", "bark" ,"treadfx/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "t72", "carpet" ,"treadfx/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "t72", "cloth" ,"treadfx/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "t72", "concrete" ,"treadfx/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "t72", "dirt" ,"treadfx/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "t72", "flesh" ,"treadfx/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "t72", "foliage" ,"treadfx/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "t72", "glass" ,"treadfx/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "t72", "grass" ,"treadfx/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "t72", "gravel" ,"treadfx/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "t72", "ice" ,"treadfx/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "t72", "metal" ,"treadfx/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "t72", "mud" ,"treadfx/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "t72", "paper" ,"treadfx/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "t72", "plaster" ,"treadfx/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "t72", "rock" ,"treadfx/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "t72", "sand" ,"treadfx/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "t72", "snow" ,"treadfx/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "t72", "water" ,"treadfx/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "t72", "wood" ,"treadfx/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "t72", "asphalt" ,"treadfx/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "t72", "ceramic" ,"treadfx/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "t72", "plastic" ,"treadfx/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "t72", "rubber" ,"treadfx/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "t72", "cushion" ,"treadfx/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "t72", "fruit" ,"treadfx/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "t72", "painted metal" ,"treadfx/tread_dust_bog_b" );
 	maps\_treadfx::setvehiclefx( "t72", "default" ,"treadfx/tread_dust_bog_b" );
	maps\_treadfx::setvehiclefx( "t72", "none" ,"treadfx/tread_dust_bog_b" );

	maps\createfx\bog_b_fx::main();

}