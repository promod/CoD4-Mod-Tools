#include maps\_ambient;

main()
{
	// Set the underlying ambient track
	level.ambient_track ["exterior"] = "ambient_launchfacility_b_int0";

	thread maps\_utility::set_ambient("exterior");
		
	ambientDelay("exterior", 3.0, 6.0); // Trackname, min and max delay between ambient events
	ambientEvent("exterior", "elm_quake_sub_rumble",	0.3);
	ambientEvent("exterior", "elm_industry",	0.5);
	ambientEvent("exterior", "elm_stress",	0.5);
	ambientEvent("exterior", "null",			1.0);

	ambientEventStart("exterior");

	level waittill ("action moment");

	ambientEventStart("action ambient");
}	
	
	