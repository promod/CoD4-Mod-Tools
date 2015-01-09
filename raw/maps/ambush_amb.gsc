#include maps\_ambient;

main()
{
	// Set the underlying ambient track
	level.ambient_track ["exterior_rain"] = "ambient_ambush_ext0";
	level.ambient_track ["exterior_norain"] = "ambient_ambush_ext1";

	//thread maps\_utility::set_ambient("exterior_rain");
	thread maps\_utility::set_ambient("exterior_norain");

	ambientDelay("mountains", 2.0, 8.0); // Trackname, min and max delay between ambient events
	ambientEvent("mountains", "elm_wind_leafy",	8.0);
	ambientEvent("mountains", "elm_jet_flyover_dist",	0.5);
	ambientEvent("mountains", "elm_helicopter_flyover_med",	0.3);
	ambientEvent("mountains", "elm_explosions_dist",	1.0);
	ambientEvent("mountains", "elm_gunfire_50cal_dist",	1.0);
	ambientEvent("mountains", "elm_gunfire_ak47_dist",	3.0);
	ambientEvent("mountains", "elm_gunfire_miniuzi_dist",	1.0);
	ambientEvent("mountains", "elm_gunfire_m16_dist",	1.0);
	ambientEvent("mountains", "elm_gunfire_m240_dist",	1.0);
	ambientEvent("mountains", "elm_gunfire_mp5_dist",	1.0);
	ambientEvent("mountains", "walla_rus_mountain_conv",	0.5);
	ambientEvent("mountains", "null",			0.3);
	
	ambientEventStart("mountains");

	level waittill ("action moment");

	ambientEventStart("action ambient");
}	
	
	