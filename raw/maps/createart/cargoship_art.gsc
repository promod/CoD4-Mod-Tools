//_createart generated.  modify at your own risk. Changing values should be fine.
main()
{

	level.tweakfile = true;
 
	// *Fog section* 

	setdvar("scr_fog_disable", "1");

	// *depth of field section* 

	level.dofDefault["nearStart"] = 0;
	level.dofDefault["nearEnd"] = 1;
	level.dofDefault["farStart"] = 1000;
	level.dofDefault["farEnd"] = 7000;
	level.dofDefault["nearBlur"] = 6;
	level.dofDefault["farBlur"] = 1.8;
	getent("player","classname") maps\_art::setdefaultdepthoffield();

	//

	maps\_utility::set_vision_set( "cargoship", 0 );

}
