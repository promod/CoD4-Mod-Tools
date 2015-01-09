main()
{
	

	level._effect["firelp_med_pm"]					= loadfx ("fire/firelp_med_pm_nodistort");	
	level._effect["firelp_small_pm"]				= loadfx ("fire/firelp_small_pm");
	level._effect["firelp_small_pm_a"]				= loadfx ("fire/firelp_small_pm_a");
	level._effect["dust_wind_fast"]					= loadfx ("weather/snow_wind");
	level._effect["dust_wind_slow"]					= loadfx ("weather/snow_wind");
	level._effect["dust_wind_spiral"]				= loadfx ("weather/snow_wind_spiral_runner");
	level._effect["battlefield_smokebank_S"]		= loadfx ("smoke/battlefield_smokebank_S");
	level._effect["hallway_smoke_light"]			= loadfx ("smoke/hallway_smoke_light");
	level._effect["snow_light"]		 				= loadfx ("weather/snow_light_mp_crash");

/#
	if ( getdvar( "clientSideEffects" ) != "1" )
		maps\createfx\mp_crash_snow_fx::main();
#/

	thread swapAirstrikeFX();
}

swapAirstrikeFX()
{
	level.newairstrike = loadfx ("explosions/clusterbomb_christmas");
	
	wait .05;
	
	level.airstrikefx = level.newairstrike;
	
}

