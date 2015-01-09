#include maps\_ambient;

main()
{
	// Set the underlying ambient track
	level.ambient_track ["exterior"] = "ambient_aftermath_ext0";

	thread maps\_utility::set_ambient("exterior");

	ambientDelay("exterior", 8.0, 20.0); // Trackname, min and max delay between ambient events
	ambientEvent("exterior", "elm_wind_leafy",	6.0);
	ambientEvent("exterior", "elm_rubble",	6.0);
	ambientEvent("exterior", "elm_industry",	6.0);
	ambientEvent("exterior", "elm_stress",	6.0);
	ambientEvent("exterior", "elm_metal_stress",	6.0);
	ambientEvent("exterior", "null",			1.0);
	
	ambientEventStart("interior_vehicle");

	level waittill ("action moment");

	ambientEventStart("action ambient");
}	
	
	
	