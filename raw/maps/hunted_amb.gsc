#include maps\_ambient;

main()
{
	// Set the underlying ambient track
	level.ambient_track ["exterior_level0"] = "ambient_hunted_ext0";
	level.ambient_track ["exterior_level1"] = "ambient_hunted_ext1";
	level.ambient_track ["exterior_level2"] = "ambient_hunted_ext2";

	thread maps\_utility::set_ambient("exterior_level0");

	ambientDelay("exterior", 2.0, 8.0); // Trackname, min and max delay between ambient events
	ambientEvent("exterior", "elm_wind_leafy",	12.0);
	ambientEvent("exterior", "elm_anml_wolf",	1.5);
	ambientEvent("exterior", "elm_anml_owl",	2.0);
	ambientEvent("exterior", "elm_anml_nocturnal_birds",	1.0);
	ambientEvent("exterior", "elm_dog",		0.5);


	ambientEvent("exterior", "null",			0.3);
	
	ambientEventStart("exterior");
	
	level waittill ("action moment");

	ambientEventStart("action ambient");
}