#include maps\_ambient;

main()
{
	// Set the underlying ambient track
	level.ambient_track ["ac130"] = "ambient_ac130_int1";
	thread maps\_utility::set_ambient("ac130");
		
	ambientDelay("ac130", 3.0, 6.0); // Trackname, min and max delay between ambient events
	ambientEvent("ac130", "elm_ac130_rattles",		4.0);
	ambientEvent("ac130", "elm_ac130_beeps",		0.3);
	ambientEvent("ac130", "elm_ac130_hydraulics",	1.0);
	ambientEvent("ac130", "elm_ac130_metal_stress",	0.3);
	ambientEvent("ac130", "null",			1.0);	

	
	ambientEventStart("ac130");

	level waittill ("action moment");

	ambientEventStart("action ambient");
}	
	
	
