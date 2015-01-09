#include maps\_ambient;
#include maps\_equalizer;
#include maps\_utility;

main()
{
	// Setup the underlying ambient tracks
	level.ambient_track [ "exterior" ] = "ambient_bog_ext3aa";
	level.ambient_track [ "exterior1" ] = "ambient_bog_ext1";

	set_ambient( "exterior" );
	set_reverb_wetlevel( "interior_stone", 	0.3 );

	ambientDelay( "exterior", 10.0, 20.0 ); // Trackname, min and max delay between ambient events
	ambientEvent( "exterior", "elm_windgust1", 	2.0 );
	ambientEvent( "exterior", "elm_windgust2", 	2.0 );
	ambientEvent( "exterior", "elm_windgust3", 	2.0 );
	ambientEvent( "exterior", "elm_windgust4", 	2.0 );
	ambientEvent( "exterior", "elm_insect_fly", 3.0 );
	ambientEvent( "exterior", "elm_explosions_dist", 	1.0 );
	ambientEvent( "exterior", "elm_explosions_med", 	1.0 );
	ambientEvent( "exterior", "elm_artillery_med", 	1.0 );
	ambientEvent( "exterior", "elm_gunfire_50cal_dist", 	1.0 );
	ambientEvent( "exterior", "elm_gunfire_50cal_med", 	1.0 );
	ambientEvent( "exterior", "elm_gunfire_ak47_dist", 	1.0 );
	ambientEvent( "exterior", "elm_gunfire_ak47_med", 	1.0 );
	ambientEvent( "exterior", "elm_gunfire_m16_dist", 	1.0 );
	ambientEvent( "exterior", "elm_gunfire_m16_med", 	1.0 );
	ambientEvent( "exterior", "elm_gunfire_m240_med", 	1.0 );
	ambientEvent( "exterior", "elm_gunfire_m240_dist", 	1.0 );
	ambientEvent( "exterior", "elm_gunfire_miniuzi_med", 	1.0 );
	ambientEvent( "exterior", "elm_gunfire_miniuzi_dist", 	1.0 );
	ambientEvent( "exterior", "elm_gunfire_usassault_med", 	1.0 );
	ambientEvent( "exterior", "elm_jet_flyover_med", 	2.0 );
	ambientEvent( "exterior", "elm_jet_flyover_dist", 	2.0 );
	ambientEvent( "exterior", "null", 			0.3 );
	

	ambientDelay( "exterior1", 2.0, 8.0 ); // Trackname, min and max delay between ambient events
	ambientEvent( "exterior1", "elm_windgust1", 	3.0 );
	ambientEvent( "exterior1", "elm_windgust2", 	3.0 );
	ambientEvent( "exterior1", "elm_windgust3", 	3.0 );
	ambientEvent( "exterior1", "elm_windgust4", 	3.0 );
	ambientEvent( "exterior1", "elm_insect_fly", 6.0 );
	ambientEvent( "exterior1", "elm_explosions_dist", 	3.0 );
	ambientEvent( "exterior1", "elm_explosions_med", 	3.0 );
	ambientEvent( "exterior1", "elm_artillery_med", 	3.0 );
	ambientEvent( "exterior1", "elm_gunfire_50cal_dist", 	3.0 );
	ambientEvent( "exterior1", "elm_gunfire_50cal_med", 	3.0 );
	ambientEvent( "exterior1", "elm_gunfire_ak47_dist", 	3.0 );
	ambientEvent( "exterior1", "elm_gunfire_ak47_med", 	3.0 );
	ambientEvent( "exterior1", "elm_gunfire_m16_dist", 	3.0 );
	ambientEvent( "exterior1", "elm_gunfire_m16_med", 	3.0 );
	ambientEvent( "exterior1", "null", 			0.3 );
	ambientEventStart( "exterior" );
}	
	
	