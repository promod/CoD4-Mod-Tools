//_createart generated.  modify at your own risk. Changing values should be fine.
main()
{

	level.tweakfile = true;
 
	// *depth of field section* 

	level.dofDefault["nearStart"] = 0;
	level.dofDefault["nearEnd"] = 1;
	level.dofDefault["farStart"] = 1050;
	level.dofDefault["farEnd"] = 13500;
	level.dofDefault["nearBlur"] = 6;
	level.dofDefault["farBlur"] = 2.4;
	getent("player","classname") maps\_art::setdefaultdepthoffield();

	//

	setExpFog(0, 5049.45, 0.479631, 0.508939, 0.570905, 0);
	maps\_utility::set_vision_set( "scoutsniper", 0 );

}
