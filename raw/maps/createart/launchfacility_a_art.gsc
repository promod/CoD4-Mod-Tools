// _createart generated.  modify at your own risk. Changing values should be fine.
main()
{

	level.tweakfile = true;
 
	//* depth of field section * 

	level.dofDefault[ "nearStart" ] = 0;
	level.dofDefault[ "nearEnd" ] = 1;
	level.dofDefault[ "farStart" ] = 499;
	level.dofDefault[ "farEnd" ] = 500;
	level.dofDefault[ "nearBlur" ] = 4.5;
	level.dofDefault[ "farBlur" ] = 0.05;
	getent( "player", "classname" ) maps\_art::setdefaultdepthoffield();

	//* Fog section * 

	setdvar( "scr_fog_disable", "0" );

	setExpFog( 0, 7562.12, 0.168627, 0.168627, 0.188814, 0 );
	maps\_utility::set_vision_set( "launchfacility_a", 0 );

}
