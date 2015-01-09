#include maps\_ambient;

main()
{
	// Set the underlying ambient track
	level.ambient_track ["amb_int_helicopter_intensity5"] = "ambient_airlift_helicopter5";
	level.ambient_track ["amb_ext_ground_intensity3"] = "ambient_airlift_ext3";
	level.ambient_track ["amb_ext_ground_intensity4"] = "ambient_airlift_ext4";
	level.ambient_track ["amb_ext_ground_intensity5"] = "ambient_airlift_ext5";

	thread maps\_utility::set_ambient("amb_int_helicopter_intensity5");

	ambientDelay("city", 2.0, 8.0); // Trackname, min and max delay between ambient events
	ambientEvent("city", "elm_windgust1",	3.0);
	ambientEvent("city", "elm_windgust2",	3.0);
	ambientEvent("city", "elm_windgust3",	3.0);
	ambientEvent("city", "elm_windgust4",	3.0);
	ambientEvent("city", "elm_explosions_dist",	3.0);
	ambientEvent("city", "elm_gunfire_50cal_dist",	3.0);
	ambientEvent("city", "elm_gunfire_ak47_dist",	3.0);
	ambientEvent("city", "elm_gunfire_m16_dist",	3.0);
	ambientEvent("city", "elm_jet_flyover_dist",	2.0);
	ambientEvent("city", "null",			0.3);
	
	ambientEventStart("city");

	level waittill ("action moment");

	ambientEventStart("action ambient");
}	
	
	
