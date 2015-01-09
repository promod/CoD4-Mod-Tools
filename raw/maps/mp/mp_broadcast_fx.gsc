main()
{

	level._effect["dust_wind_fast"]					= loadfx ("dust/dust_wind_fast");
	level._effect["dust_wind_slow"]					= loadfx ("dust/dust_wind_slow_broadcast");
	level._effect["dust_wind_spiral"]				= loadfx ("dust/dust_spiral_runner");
	level._effect["hallway_smoke_light"]			= loadfx ("smoke/hallway_smoke_light");
	level._effect["dust_ceiling_ash_large"]			= loadfx ("dust/dust_ceiling_ash_large");
	level._effect["light_dust_particles"]			= loadfx ("dust/light_dust_particles");
	level._effect["power_tower_light_red_blink"]	= loadfx ("misc/power_tower_light_red_blink");

/#
	if ( getdvar( "clientSideEffects" ) != "1" )
		maps\createfx\mp_broadcast_fx::main();
#/

}

