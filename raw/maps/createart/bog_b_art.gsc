//_createart generated.  modify at your own risk. Changing values should be fine.
main()
{

	level.tweakfile = true;
 

	// *depth of field section* 

	level.dofDefault["nearStart"] = 0;
	level.dofDefault["nearEnd"] = 8;
	level.dofDefault["farStart"] = 2000;
	level.dofDefault["farEnd"] = 6000;
	level.dofDefault["nearBlur"] = 6.75;
	level.dofDefault["farBlur"] = 1.4;
	getent("player","classname") maps\_art::setdefaultdepthoffield();

	//

	setExpFog(156.105, 2664.25, 0.627076, 0.611153, 0.5, 0);
	maps\_utility::set_vision_set( "bog_b", 0 );

}
