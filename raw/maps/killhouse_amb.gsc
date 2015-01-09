#include maps\_ambient;

main()
{

	// Set the underlying ambient track
	level.ambient_track ["exterior"] = "ambient_killhouse_ext0";

	thread maps\_utility::set_ambient("exterior");

	ambientDelay("mountains", 5.0, 20.0); // Trackname, min and max delay between ambient events
	ambientEvent("mountains", "elm_wind_leafy",	3.0);
	ambientEvent("mountains", "elm_insect_fly", 1.0);
	ambientEvent("mountains", "elm_helicopter_flyover_med",	5.0);
	ambientEvent("mountains", "elm_jet_flyover_med",	5.0);
	ambientEvent("mountains", "elm_jet_flyover_dist",	5.0);
	ambientEvent("mountains", "null",			0.3);
	
	ambientEventStart("mountains");

	level waittill ("action moment");

	ambientEventStart("action ambient");

}	
	
	