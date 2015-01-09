#include maps\_ambient;

main()
{
	// Set the underlying ambient track
	level.ambient_track ["ambient_ext_level0"] = "ambient_blackout_ext0";
	level.ambient_track ["ambient_ext_level1"] = "ambient_blackout_ext1";
	level.ambient_track ["ambient_ext_level3"] = "ambient_blackout_ext3";
	level.ambient_track ["ambient_ext_level5"] = "ambient_blackout_ext5";

	thread maps\_utility::set_ambient("ambient_ext_level0");

	ambientDelay("mountains", 2.0, 8.0); // Trackname, min and max delay between ambient events
	ambientEvent("mountains", "elm_wind_leafy",	12.0);
	ambientEvent("mountains", "elm_anml_wolf",	0.5);
	ambientEvent("mountains", "elm_anml_owl",	1.0);
	ambientEvent("mountains", "elm_anml_nocturnal_birds",	0.5);
	ambientEvent("mountains", "elm_dog",		0.25);
	ambientEvent("mountains", "null",			0.3);
	
	ambientEventStart("mountains");
}	
	
