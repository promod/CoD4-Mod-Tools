//_createart generated.  modify at your own risk. Changing values should be fine.
main()
{

	level.tweakfile = true;
 
	// *depth of field section* 

	level.dofDefault["nearStart"] = 0;
	level.dofDefault["nearEnd"] = 1;
	level.dofDefault["farStart"] = 6354;
	level.dofDefault["farEnd"] = 10000;
	level.dofDefault["nearBlur"] = 6;
	level.dofDefault["farBlur"] = 0.314635;
	getent("player","classname") maps\_art::setdefaultdepthoffield();

	//

	setExpFog(477.057, 4556.45, 0.544852, 0.394025, 0.221177, 0);
	maps\_utility::set_vision_set( "bog_a", 0 );

}
