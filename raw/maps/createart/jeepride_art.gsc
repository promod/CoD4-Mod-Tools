// _createart generated.  modify at your own risk. Changing values should be fine.
main()
{

	level.tweakfile = true;
 
	//* depth of field section * 

	level.dofDefault[ "nearStart" ] = 6;
	level.dofDefault[ "nearEnd" ] = 15;
	level.dofDefault[ "farStart" ] = 10391;
	level.dofDefault[ "farEnd" ] = 19999;
	level.dofDefault[ "nearBlur" ] = 8.82018;
	level.dofDefault[ "farBlur" ] = 0.142125;
	getent( "player", "classname" ) maps\_art::setdefaultdepthoffield();

	//* Fog section * 

	setdvar( "scr_fog_disable", "0" );

	setExpFog( 1002.96, 211520, 0.952941, 0.980392, 1, 0 );
	maps\_utility::set_vision_set( "jeepride", 0 );

}
