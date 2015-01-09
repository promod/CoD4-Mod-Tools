main()
{
	level._effect[ "thin_black_smoke_M" ]		 	= loadfx( "smoke/thin_black_smoke_M" );
	level._effect[ "thin_black_smoke_L" ]		 	= loadfx( "smoke/thin_black_smoke_L" );
	level._effect[ "battlefield_smokebank_S" ]	 	= loadfx( "smoke/battlefield_smokebank_S" );
	level._effect[ "firelp_small_pm" ]			 	= loadfx( "fire/firelp_small_pm" );
	level._effect[ "firelp_small_pm_a" ]		 	= loadfx( "fire/firelp_small_pm_a" );
	level._effect[ "firelp_med_pm" ]			 	= loadfx( "fire/firelp_med_pm_nodistort" );
//	level._effect[ "leaves_ground_gentlewind" ]	 	= loadfx( "misc/leaves_ground_gentlewind" );	
//	level._effect[ "leaves_fall_gentlewind" ]	 	= loadfx( "misc/leaves_fall_gentlewind" );
// 	level._effect[ "insects_carcass_runner" ]	 	= loadfx( "misc/insects_carcass_runner" );
// 	level._effect[ "fog_daytime" ]					 = loadfx( "weather/fog_daytime" );

	//ambient runners
	level._effect[ "mp_overgrown_insects01" ]	 	= loadfx( "ambient_runners/mp_overgrown_insects01" );
	level._effect[ "mp_overgrown_insects02" ]	 	= loadfx( "ambient_runners/mp_overgrown_insects02" );
	level._effect[ "mp_overgrown_insects03" ]	 	= loadfx( "ambient_runners/mp_overgrown_insects03" );
	level._effect[ "mp_overgrown_insects04" ]	 	= loadfx( "ambient_runners/mp_overgrown_insects04" );
	level._effect[ "mp_overgrown_insects05" ]	 	= loadfx( "ambient_runners/mp_overgrown_insects05" );
	level._effect[ "mp_overgrown_fog_daytime01" ]	= loadfx( "ambient_runners/mp_overgrown_fog_daytime01" );
	level._effect[ "mp_overgrown_leavesfall01" ]	= loadfx( "ambient_runners/mp_overgrown_leavesfall01" );
	level._effect[ "mp_overgrown_leavesground01" ]	= loadfx( "ambient_runners/mp_overgrown_leavesground01" );

/#		
	if ( getdvar( "clientSideEffects" ) != "1" )
		maps\createfx\mp_overgrown_fx::main();
#/		
}
