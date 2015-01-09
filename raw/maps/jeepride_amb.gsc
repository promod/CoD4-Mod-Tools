#include maps\_ambient;

main()
{
	// Set the underlying ambient track
	level.ambient_track ["exterior"] = "ambient_jeepride_ext1";

	ambientDelay("exterior", 2.0, 8.0); // Trackname, min and max delay between ambient events
	ambientEvent("exterior", "elm_windgust1",	3.0);
	ambientEvent("exterior", "elm_windgust2",	3.0);
	ambientEvent("exterior", "elm_windgust3",	3.0);
	ambientEvent("exterior", "elm_windgust4",	3.0);
	ambientEvent("exterior", "null",			0.3);

	level.ambient_track ["interior"] = "ambient_jeepride_int1";

	ambientDelay("interior", .5, 1.0); // Trackname, min and max delay between ambient events
	ambientEvent("interior", "null",			0.3);
	ambientEvent("interior", "null",			0.3);


	thread maps\_utility::set_ambient("exterior");

	ambientEventStart("exterior");

}	
	
	