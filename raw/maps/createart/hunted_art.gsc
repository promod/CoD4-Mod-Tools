//_createart generated.  modify at your own risk. Changing values should be fine.
main()
{

	level.tweakfile = true;
 
	// *Fog section* 

	// *depth of field section* 

	level.dofDefault["nearStart"] = 0;
	level.dofDefault["nearEnd"] = 1;
	level.dofDefault["farStart"] = 8000;
	level.dofDefault["farEnd"] = 10000;
	level.dofDefault["nearBlur"] = 6;
	level.dofDefault["farBlur"] = 0;
	getent("player","classname") maps\_art::setdefaultdepthoffield();

	//

	setExpFog(512, 6145, 0.132176, 0.192839, 0.238414, 0);
	maps\_utility::set_vision_set( "hunted", 0 );

}
