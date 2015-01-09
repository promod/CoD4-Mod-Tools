#include maps\_ambient;

main()
{
	// Set the underlying ambient track
	level.ambient_track ["exterior"] = "ambient_cargoship_ext";
	level.ambient_track ["interior"] = "ambient_cargoship_int";

	thread maps\_utility::set_ambient("exterior");
		
	ambientDelay("exterior", 1.0, 5.0); // Trackname, min and max delay between ambient events
	ambientEvent("exterior", "elm_windgust1",	0.4);
	ambientEvent("exterior", "elm_windgust2",	0.4);
	ambientEvent("exterior", "elm_windgust3",	0.4);
	ambientEvent("exterior", "elm_windgust4",	0.4);
	ambientEvent("exterior", "elm_wind_buffet",	2.0);
	ambientEvent("exterior", "elm_metal_rattle",	4.0);
	ambientEvent("exterior", "elm_metal_stress",	4.0);
	ambientEvent("exterior", "null",			0.3);

	ambientDelay("interior_metal", 1.0, 5.0); // Trackname, min and max delay between ambient events
	ambientEvent("interior_metal", "elm_metal_rattle",	4.0);
	ambientEvent("interior_metal", "elm_metal_stress",	4.0);
	ambientEvent("interior_metal", "elm_cargo_metal_stress",	4.0);
	ambientEvent("interior_metal", "null",			0.3);
	
	ambientEventStart("exterior");

	level waittill ("action moment");

	ambientEventStart("action ambient");
}	
	
	