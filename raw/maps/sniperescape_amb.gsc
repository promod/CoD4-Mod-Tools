#include maps\_ambient;

main()
{
	// Set the underlying ambient track
	level.ambient_track ["city"] = "ambient_sniperescape_ext0";

	thread maps\_utility::set_ambient("city");

	ambientDelay("city", 2.0, 8.0); // Trackname, min and max delay between ambient events
	ambientEvent("city", "elm_wind_leafy",	12.0);
	ambientEvent("city", "null",		0.3);
	
	ambientEventStart("city");

	level waittill ("action moment");

	ambientEventStart("action ambient");
}	
	
	