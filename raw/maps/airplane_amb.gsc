#include maps\_ambient;

main()
{
	// Set the underlying ambient track
	level.ambient_track ["amb_int_airplane_default"] = "ambient_airplane_int0";
	level.ambient_track ["amb_int_airplane_intensity5"] = "ambient_airplane_int1";

	thread maps\_utility::set_ambient("amb_int_airplane_default");
	
	

}	
	
	
