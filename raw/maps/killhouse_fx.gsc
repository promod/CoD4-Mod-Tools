main()

{
	level._effect[ "watermelon" ]					 = loadfx( "props/watermelon" );
 	level._effect[ "fog_river_200" ]				 = loadfx( "weather/fog_river_200" );
	level._effect[ "insect_trail_runner" ]			 = loadfx( "misc/insect_trail_runner" );	
	level._effect[ "moth_runner" ]					 = loadfx( "misc/moth_runner" );	
	level._effect[ "insects_carcass_runner" ]		 = loadfx( "misc/insects_carcass_runner" );
	level._effect[ "amb_dust_hangar" ]				 = loadfx( "dust/amb_dust_hangar" );
	level._effect[ "light_shaft_dust_large" ]		 = loadfx( "dust/light_shaft_dust_large" );
	level._effect[ "light_shaft_dust_med" ]			 = loadfx( "dust/light_shaft_dust_med" );

	//footstep fx	                                                                                                   
	animscripts\utility::setFootstepEffect ("asphalt",		loadfx ("impacts/footstep_water"));                         
	animscripts\utility::setFootstepEffect ("brick",		loadfx ("impacts/footstep_dust"));                         
	animscripts\utility::setFootstepEffect ("carpet",		loadfx ("impacts/footstep_dust"));                         
	animscripts\utility::setFootstepEffect ("cloth",		loadfx ("impacts/footstep_dust"));                         
	animscripts\utility::setFootstepEffect ("concrete",		loadfx ("impacts/footstep_dust"));                         
	animscripts\utility::setFootstepEffect ("dirt",			loadfx ("impacts/footstep_dust"));                         
	animscripts\utility::setFootstepEffect ("foliage",		loadfx ("impacts/footstep_dust"));                         
	animscripts\utility::setFootstepEffect ("grass",		loadfx ("impacts/footstep_dust"));                         
	animscripts\utility::setFootstepEffect ("metal",		loadfx ("impacts/footstep_dust"));                         
	animscripts\utility::setFootstepEffect ("mud",			loadfx ("impacts/footstep_mud_dark"));                     
	animscripts\utility::setFootstepEffect ("rock",			loadfx ("impacts/footstep_dust"));                         
	animscripts\utility::setFootstepEffect ("sand",			loadfx ("impacts/footstep_dust"));                         
	animscripts\utility::setFootstepEffect ("water",		loadfx ("impacts/footstep_water"));                        
	animscripts\utility::setFootstepEffect ("wood",			loadfx ("impacts/footstep_dust"));                         
	

// 	maps\_treadfx::setallvehiclefx( "cobra", undefined );// disables cobras treads
// 	setExpFog( 800, 6000, .583, .644, .587, 0 );



	maps\createfx\killhouse_fx::main();

}









