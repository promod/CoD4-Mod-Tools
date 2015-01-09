#include maps\_ambient;

main()
{
	// Set the underlying ambient track
	level.ambient_track ["exterior"] = "ambient_village_assault_ext0";
	level.ambient_track ["exterior1"] = "ambient_village_assault_ext1";
	level.ambient_track ["exterior2"] = "ambient_village_assault_ext2";
	level.ambient_track ["exterior3"] = "ambient_village_assault_ext3";

	thread maps\_utility::set_ambient("exterior2");

	ambientDelay("exterior", 2.0, 8.0); // Trackname, min and max delay between ambient events
	ambientEvent("exterior", "elm_wind_leafy",	12.0);
	ambientEvent("exterior", "elm_anml_wolf",	1.5);
	ambientEvent("exterior", "elm_anml_owl",	2.0);
	ambientEvent("exterior", "elm_anml_nocturnal_birds",	1.0);
	ambientEvent("exterior", "elm_dog",		0.5);
	ambientEvent("exterior", "null",			0.3);

	ambientDelay("exterior1", 2.0, 8.0); // Trackname, min and max delay between ambient events
	ambientEvent("exterior1", "elm_wind_leafy",	12.0);
	ambientEvent("exterior1", "elm_anml_wolf",	0.5);
	ambientEvent("exterior1", "elm_anml_owl",	1.0);
	ambientEvent("exterior1", "elm_anml_nocturnal_birds",	0.5);
	ambientEvent("exterior1", "elm_dog",		0.25);
	ambientEvent("exterior1", "elm_jet_flyover_dist",	0.1);
	ambientEvent("exterior1", "elm_explosions_dist",	3.0);
	ambientEvent("exterior1", "elm_gunfire_50cal_dist",	3.0);
	ambientEvent("exterior1", "elm_gunfire_ak47_dist",	3.0);
	ambientEvent("exterior1", "elm_gunfire_m16_dist",	3.0);
	ambientEvent("exterior1", "null",			0.3);

	ambientDelay("exterior2", 2.0, 8.0); // Trackname, min and max delay between ambient events
	ambientEvent("exterior2", "elm_wind_leafy",	12.0);
	ambientEvent("exterior2", "elm_anml_wolf",	0.5);
	ambientEvent("exterior2", "elm_anml_owl",	1.0);
	ambientEvent("exterior2", "elm_anml_nocturnal_birds",	0.5);
	ambientEvent("exterior2", "elm_dog",		0.25);
	ambientEvent("exterior2", "elm_jet_flyover_dist",	0.1);
	ambientEvent("exterior2", "elm_explosions_dist",	3.0);
	ambientEvent("exterior2", "elm_gunfire_50cal_dist",	3.0);
	ambientEvent("exterior2", "elm_gunfire_ak47_dist",	3.0);
	ambientEvent("exterior2", "elm_gunfire_m16_dist",	3.0);
	ambientEvent("exterior2", "walla_rus_mountain_conv",	1.0);
	ambientEvent("exterior2", "null",			0.3);

	ambientDelay("exterior3", 2.0, 8.0); // Trackname, min and max delay between ambient events
	ambientEvent("exterior3", "elm_wind_leafy",	12.0);
	ambientEvent("exterior3", "elm_anml_wolf",	0.5);
	ambientEvent("exterior3", "elm_anml_owl",	1.0);
	ambientEvent("exterior3", "elm_anml_nocturnal_birds",	0.5);
	ambientEvent("exterior3", "elm_dog",		0.25);
	ambientEvent("exterior3", "elm_jet_flyover_dist",	0.1);
	ambientEvent("exterior3", "elm_explosions_dist",	3.0);
	ambientEvent("exterior3", "elm_explosions_med",	3.0);
	ambientEvent("exterior3", "elm_artillery_med",	1.0);
	ambientEvent("exterior3", "elm_gunfire_50cal_dist",	3.0);
	ambientEvent("exterior3", "elm_gunfire_50cal_med",	3.0);
	ambientEvent("exterior3", "elm_gunfire_ak47_dist",	3.0);
	ambientEvent("exterior3", "elm_gunfire_ak47_med",	3.0);
	ambientEvent("exterior3", "elm_gunfire_m16_dist",	3.0);
	ambientEvent("exterior3", "elm_gunfire_m16_med",	3.0);
	ambientEvent("exterior2", "walla_rus_mountain_battle",	1.0);
	ambientEvent("exterior2", "walla_rus_mountain_chatter",	1.0);
	ambientEvent("exterior3", "null",			0.3);


	ambientEventStart("exterior2");

	level waittill ("action moment");

	ambientEventStart("action ambient");
}	
	
	