#include maps\_ambient;

main()
{
	// Set the underlying ambient track
	level.ambient_track ["amb_snow_intensity0"] = "ambient_icbm_snow_ext0";
	level.ambient_track ["amb_day_intensity0"] = "ambient_icbm_ext0";

	thread maps\_utility::set_ambient("amb_snow_intensity0");

	ambientDelay("mountains", 2.0, 8.0); // Trackname, min and max delay between ambient events
	ambientEvent("mountains", "elm_wind_leafy",	12.0);
	ambientEvent("mountains", "null",		0.3);
	
	ambientEventStart("mountains");

	level waittill ("action moment");

	ambientEventStart("action ambient");
}	
