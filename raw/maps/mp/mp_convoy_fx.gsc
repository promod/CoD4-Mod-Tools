main()
{

	// ambient fx
	level._effect[ "dust_wind_fast" ]					 = loadfx( "dust/dust_wind_fast" );
	level._effect[ "dust_wind_spiral" ]					 = loadfx( "dust/dust_spiral_runner" );
	level._effect[ "firelp_small_pm" ]					 = loadfx( "fire/firelp_small_pm" );
	level._effect[ "firelp_small_pm_a" ]				 = loadfx( "fire/firelp_small_pm_a" );
	level._effect[ "thin_black_smoke_L" ]				 = loadfx( "smoke/thin_black_smoke_L" );
	level._effect[ "battlefield_smokebank_S" ]	 		 = loadfx( "smoke/battlefield_smokebank_S" );
	level._effect[ "tank_fire_turret_abrams" ]	 		 = loadfx( "fire/tank_fire_turret_abrams" );
	level._effect[ "tank_fire_hatch" ]			 		 = loadfx( "fire/tank_fire_hatch" );

/#
	if ( getdvar( "clientSideEffects" ) != "1" )
		maps\createfx\mp_convoy_fx::main();
#/
}
