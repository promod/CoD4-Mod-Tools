main()
{
	level._effect[ "wood" ]				 = loadfx( "explosions/grenadeExp_wood" );
	level._effect[ "dust" ]				 = loadfx( "explosions/grenadeExp_dirt_1" );
	level._effect[ "brick" ]			 = loadfx( "explosions/grenadeExp_concrete_1" );

	level._effect["firelp_med_pm"]					= loadfx ("fire/firelp_med_pm_nodistort");	
	level._effect["firelp_small_pm"]				= loadfx ("fire/firelp_small_pm");
	level._effect["firelp_small_pm_a"]				= loadfx ("fire/firelp_small_pm_a");
	level._effect["dust_wind_fast"]					= loadfx ("dust/dust_wind_fast");
	level._effect["dust_wind_slow"]					= loadfx ("dust/dust_wind_slow_yel_loop");
	level._effect["dust_wind_spiral"]				= loadfx ("dust/dust_spiral_runner");
	level._effect["hawk"]							= loadfx ("weather/hawk");
	level._effect["hallway_smoke_light"]							= loadfx ("smoke/hallway_smoke_light");

/#		
	if ( getdvar( "clientSideEffects" ) != "1" )
		maps\createfx\mp_showdown_fx::main();
#/
}
