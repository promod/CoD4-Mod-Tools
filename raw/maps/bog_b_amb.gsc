#include maps\_ambient;

main()
{
	// Set the underlying ambient track
	level.ambient_track ["exterior_level1"] = "ambient_bog_ext1";
	level.ambient_track ["exterior_level2"] = "ambient_bog_ext2";
	level.ambient_track ["exterior_level3"] = "ambient_bog_ext3";
	level.ambient_track ["exterior_level4"] = "ambient_bog_ext4";
	level.ambient_track ["exterior_level5"] = "ambient_bog_ext5";

	thread maps\_utility::set_ambient("exterior_level3");

	ambientDelay("exterior", 2.0, 8.0); // Trackname, min and max delay between ambient events
	ambientEvent("exterior", "elm_windgust1",	3.0);
	ambientEvent("exterior", "elm_windgust2",	3.0);
	ambientEvent("exterior", "elm_windgust3",	3.0);
	ambientEvent("exterior", "elm_windgust4",	3.0);
	ambientEvent("exterior", "elm_insect_fly", 6.0);
	ambientEvent("exterior", "elm_explosions_dist",	3.0);
	ambientEvent("exterior", "elm_explosions_med",	3.0);
	ambientEvent("exterior", "elm_artillery_med",	3.0);
	ambientEvent("exterior", "elm_gunfire_50cal_dist",	3.0);
	ambientEvent("exterior", "elm_gunfire_50cal_med",	3.0);
	ambientEvent("exterior", "elm_gunfire_ak47_dist",	3.0);
	ambientEvent("exterior", "elm_gunfire_ak47_med",	3.0);
	ambientEvent("exterior", "elm_gunfire_m16_dist",	3.0);
	ambientEvent("exterior", "elm_gunfire_m16_med",	3.0);
	ambientEvent("exterior", "elm_jet_flyover_med",	2.0);
	ambientEvent("exterior", "elm_jet_flyover_dist",	2.0);

	ambientEvent("exterior", "null",			0.3);
	
	ambientEventStart("exterior");

	level waittill ("action moment");

	ambientEventStart("action ambient");
}	
	
	