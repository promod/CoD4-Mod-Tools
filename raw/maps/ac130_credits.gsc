/*
	aimViewAtEnt( entity )
	
	setWeapon( weaponName )			// weaponName can be "105", "40", or "25"
	shootWeapon( numberOfShots )	// shoots the curently selected weapon, optional param that defaults to 1
*/


#include common_scripts\utility;
#include maps\_utility;
#include maps\_ac130;
#include maps\ac130_credits_code;
#include maps\_credits;

credits_main()
{	
	thread initCredits();
	
	setdvar( "credits_load", "0" ); 
	setdvar( "credits_active", "1" );
	level.credits_active = true;
	
	if ( getdvar( "credits_frommenu" ) == "1" )
		level.credits_frommenu = true;
	else
		setdvar( "credits_frommenu", "0" ); 

	thread fadeOverlay( "black" );

	setExpFog( 1000, 17300, 0/255, 0/255, 0/255, 0 );
	setsaveddvar( "scr_dof_enable", "0" );
	//setdvar( "cg_subtitles", "0" );

	precacheshader("black");
	flag_init( "iw_credits_ended" );
	flag_init( "credits_ended" );
	
	precacheLevelStuff();
	scriptCalls();
	spawn_vehicles();
	
	array_thread( getentarray( "destructible_building", "targetname" ), maps\ac130_code::destructible_building );
	
	thread endlevel_transition();
	thread stopClouds();
	thread playCredits();
	thread group1();
}

fadeOverlay( material )
{
	duration = 5;
	
	overlay = newHudElem();
	overlay.x = 0;
	overlay.y = 0;
	overlay setshader ( material, 640, 480);
	overlay.alignX = "left";
	overlay.alignY = "top";
	overlay.horzAlign = "fullscreen";
	overlay.vertAlign = "fullscreen";
	overlay.alpha = 1;
	
	overlay fadeOverTime( duration );
	overlay.alpha = 0;
	MusicStop( duration );
	
	wait duration;
	overlay destroy();
}

stopClouds()
{
	wait 2;
	level notify( "stop_clounds" );
}

spawn_vehicles()
{
	// spawn the vehicle
	vehicleArray = maps\_vehicle::spawn_vehicles_from_targetname( "credits_vehicle_1" );
	level.vehicle1 = vehicleArray[ 0 ];
	
	vec = anglesToForward( level.vehicle1.angles );
	level.vehicle1.forwardEnt = spawn( "script_origin", ( level.vehicle1.origin + vectorscale( vec, 500 ) ) );
	level.vehicle1.forwardEnt linkto( level.vehicle1 );
}

group1()
{
	focalPoint = getent( "credits_focus_1", "targetname" );
	thread aimViewAtEnt( focalPoint );
	
	// Vince
	guy1 = spawnAI( "credits_spawner_1" );
	guy1.animname = "guy";
	wait 3;
	guy1 set_run_anim( "patrol_walk" );
	thread aimViewAtEnt( guy1, true );
	thread setWeapon( "40" );
	wait 3;
	thread setWeapon( "25" );

	// Recalibrate azimuth sweep angle. Adjust elevation scan.
	thread radio_dialogue_queue( "ac130_plt_azimuthsweep" );
	
	// Jason
	guy3 = spawnAI( "credits_spawner_3" );
	guy3.animname = "guy";
	wait 3;
	thread aimViewAtEnt( guy3, true );
	guy3 set_run_anim( "patrol_walk" );
	wait 2.6;
	
	thread music();
	
	wait 0.4;
	
	// Set scan range.
	thread radio_dialogue_queue( "ac130_plt_scanrange" );
	
	// Roger that.
	thread radio_dialogue_queue( "ac130_tvo_rogerthat" );
	
	// Grant
	guy2 = spawnAI( "credits_spawner_2" );
	guy2.animname = "guy";
	wait 3;
	guy2 set_run_anim( "patrol_walk" );
	thread aimViewAtEnt( guy2, true );
	wait 4;
	thread setWeapon( "40" );
	
	wait 3;
	
	// back to center
	thread aimViewAtEnt( focalPoint );
	
	// Cleared to engage all of those.
	thread radio_dialogue_queue( "ac130_plt_clearedtoengage" );
	
	// Copy, smoke ‘em.
	thread radio_dialogue_queue( "ac130_plt_copysmoke" );
	
	wait 4;
	thread shootWeapon( 2 );
	wait 2.0;
	
	// Kaboom!
	thread radio_dialogue_queue( "ac130_fco_kaboom" );
	
	thread group2();
}

group2()
{
	// some leads try to get away in a vehicle
	
	guy1 = spawnAI( "credits_spawner_4" );
	guy2 = spawnAI( "credits_spawner_5" );
	guy3 = spawnAI( "credits_spawner_6" );
	
	guysArray = [];
	guysArray[ 0 ] = guy1;
	guysArray[ 1 ] = guy2;
	guysArray[ 2 ] = guy3;
	
	level.vehicle1 maps\_vehicle::vehicle_load_ai( guysArray );
	
	wait 3.0;
	
	thread aimViewAtEnt( level.vehicle1 );
	wait 1.0;
	thread setWeapon( "25" );
	
	// We got a vehicle on the move.
	thread radio_dialogue_queue( "ac130_fco_vehicleonmove" );
	
	level.vehicle1 waittill( "loaded" );
	
	// You are cleared to engage the moving vehicle.
	thread radio_dialogue_queue( "ac130_plt_engvehicle" );

	// Roger that.
	thread radio_dialogue_queue( "ac130_tvo_rogerthat" );
	
	thread maps\_vehicle::gopath( level.vehicle1 );
	
	wait 2.0;
	thread setWeapon( "40" );
	thread aimViewAtEnt( level.vehicle1.forwardEnt, true, 1.4 );
	wait 4;
	thread shootWeapon( 3 );
	wait 3;
	if ( isdefined( level.vehicle1 ) )
		level.vehicle1 notify( "death" );
	
	// Confirmed, vehicle neutralized.
	thread radio_dialogue_queue( "ac130_fco_confirmed" );
	
	thread group3();
}

group3()
{
	guy1 = spawnAI( "credits_spawner_7" );
	guy2 = spawnAI( "credits_spawner_8" );
	guy3 = spawnAI( "credits_spawner_9" );
	
	wait 4;
	
	focalPoint = getent( "credits_focus_2", "targetname" );
	thread movePlaneToPoint( focalPoint.origin, false );
	
	thread aimViewAtEnt( guy1, true );
	wait 3;
	thread setWeapon( "25" );
	wait 2;
	thread setWeapon( "40" );
	
	aimViewAtEnt( getent( "credits_group3_aim1", "targetname" ), undefined, 0.8 );
	thread shootWeapon( 1 );
	
	aimViewAtEnt( getent( "credits_group3_aim2", "targetname" ), undefined, 0.8 );
	thread shootWeapon( 1 );
	
	aimViewAtEnt( getent( "credits_group3_aim3", "targetname" ), undefined, 0.8 );
	thread shootWeapon( 1 );
	
	aimViewAtEnt( getent( "credits_group3_aim4", "targetname" ), undefined, 0.8 );
	thread shootWeapon( 1 );
	
	aimViewAtEnt( getent( "credits_group3_aim5", "targetname" ), undefined, 0.8 );
	thread shootWeapon( 1 );
	
	wait 1;
	
	focalPoint = getent( "credits_focus_3", "targetname" );
	thread movePlaneToPoint( focalPoint.origin, false );
	
	aimViewAtEnt( getent( "credits_group3_aim6", "targetname" ), undefined, 0.8 );
	thread shootWeapon( 1 );
	
	aimViewAtEnt( getent( "credits_group3_aim7", "targetname" ), undefined, 0.8 );
	thread shootWeapon( 1 );
	
	aimViewAtEnt( getent( "credits_group3_aim8", "targetname" ), undefined, 0.8 );
	thread shootWeapon( 1 );
	
	thread forceKillAI( guy1 );
	thread forceKillAI( guy2 );
	thread forceKillAI( guy3 );
	
	thread group4();
}

group4()
{
	guy1 = spawnAI( "credits_spawner_10" );
	guy2 = spawnAI( "credits_spawner_11" );
	guy3 = spawnAI( "credits_spawner_12" );
	guy4 = spawnAI( "credits_spawner_13" );
	guy5 = spawnAI( "credits_spawner_14" );
	guy6 = spawnAI( "credits_spawner_15" );
	wait 4;
	thread aimViewAtEnt( guy1, true );
	wait 4;
	thread setWeapon( "25" );
	
	// More enemy personnel.
	thread radio_dialogue_queue( "ac130_fco_moreenemy" );
	
	// Cleared to engage all of those.
	thread radio_dialogue_queue( "ac130_plt_clearedtoengage" );
	
	wait 2;
	thread aimViewAtEnt( guy5, true );
	wait 4;
	thread aimViewAtEnt( getent( "credits_group4_aim1", "targetname" ) );
	thread setWeapon( "105" );
	wait 2;
	thread shootWeapon( 1 );
	
	focalPoint = getent( "credits_focus_4", "targetname" );
	thread movePlaneToPoint( focalPoint.origin, false );
	
	wait 3;
	
	// Hot damn!
	thread radio_dialogue_queue( "ac130_fco_hotdamn3" );
	
	wait 1;
	
	thread forceKillAI( guy1 );
	thread forceKillAI( guy2 );
	thread forceKillAI( guy3 );
	thread forceKillAI( guy4 );
	thread forceKillAI( guy5 );
	thread forceKillAI( guy6 );

	thread group5();
}

group5()
{
	guy1 = spawnAI( "credits_spawner_16" );
	guy2 = spawnAI( "credits_spawner_17" );
	guy3 = spawnAI( "credits_spawner_18" );
	guy4 = spawnAI( "credits_spawner_19" );
	guy5 = spawnAI( "credits_spawner_20" );
	guy6 = spawnAI( "credits_spawner_21" );
	guy7 = spawnAI( "credits_spawner_22" );
	guy8 = spawnAI( "credits_spawner_23" );
	
	thread aimViewAtEnt( guy3, true );
	
	wait 4;
	
	thread setWeapon( "25" );
	
	wait 3;
	
	//Man these guys are goin' to town!
	thread radio_dialogue_queue( "ac130_fco_gointotown" );
	
	thread aimViewAtEnt( guy2, true );
	
	wait 3;
	
	//Crew, go ahead and smoke ‘em.
	thread radio_dialogue_queue( "ac130_fco_smokeem" );
	
	// Roger that.
	thread radio_dialogue_queue( "ac130_tvo_rogerthat" );
	
	thread aimViewAtEnt( getent( "credits_group5_aim1", "targetname" ) );
	
	wait 2;
	
	thread setWeapon( "105" );
	
	wait 3;
	
	thread shootWeapon( 1 );
	
	thread group6();
	
	wait 3;
	
	// Kaboom!
	thread radio_dialogue_queue( "ac130_fco_kaboom" );
	
	thread forceKillAI( guy1 );
	thread forceKillAI( guy2 );
	thread forceKillAI( guy3 );
	thread forceKillAI( guy4 );
	thread forceKillAI( guy5 );
	thread forceKillAI( guy6 );
	thread forceKillAI( guy7 );
	thread forceKillAI( guy8 );
}

group6()
{
	guy1 = spawnAI( "credits_spawner_24" );
	guy2 = spawnAI( "credits_spawner_25" );
	guy3 = spawnAI( "credits_spawner_26" );
	guy4 = spawnAI( "credits_spawner_27" );
	guy5 = spawnAI( "credits_spawner_28" );
	guy6 = spawnAI( "credits_spawner_29" );
	
	focalPoint = getent( "credits_focus_5", "targetname" );
	thread movePlaneToPoint( focalPoint.origin, false );
	
	wait 6;
	
	// There's armed personnel running out of the church.
	thread radio_dialogue_queue( "ac130_fco_outofchurch" );
	
	thread aimViewAtEnt( guy3, true );
	
	wait 3;
	
	thread setWeapon( "40" );
	
	// Recalibrate azimuth sweep angle. Adjust elevation scan.
	thread radio_dialogue_queue( "ac130_plt_azimuthsweep" );
	
	wait 10;
	
	// Right there...tracking.
	thread radio_dialogue_queue( "ac130_fco_rightthere" );
	
	// Rollin' in
	thread radio_dialogue_queue( "ac130_plt_rollinin" );
	
	thread setWeapon( "40" );
	
	wait 10;
	
	thread shootWeapon( 6 );
	
	aimViewAtEnt( getent( "credits_group6_aim1", "targetname" ) );
	aimViewAtEnt( getent( "credits_group6_aim3", "targetname" ) );
	aimViewAtEnt( getent( "credits_group6_aim5", "targetname" ) );
	aimViewAtEnt( getent( "credits_group6_aim6", "targetname" ) );
	
	thread forceKillAI( guy1 );
	thread forceKillAI( guy2 );
	thread forceKillAI( guy3 );
	thread forceKillAI( guy4 );
	thread forceKillAI( guy5 );
	thread forceKillAI( guy6 );
	
	wait 2;
	
	//Hehe, this is gonna be one helluva highlight reel.
	thread radio_dialogue_queue( "ac130_fco_highlightreel" );
	
	wait 3;
	
	flag_set( "iw_credits_ended" );
	
	// Roger that. Returning to base.
	thread radio_dialogue_queue( "ac130_plt_returningbase" );
}

endlevel_transition()
{
	duration = 5;
	
	flag_wait( "iw_credits_ended" );
	
	// Fade screen
	overlay = newHudElem();
	overlay.x = 0;
	overlay.y = 0;
	overlay setshader( "black", 640, 480 );
	overlay.alignX = "left";
	overlay.alignY = "top";
	overlay.horzAlign = "fullscreen";
	overlay.vertAlign = "fullscreen";
	overlay.alpha = 0;
	overlay.sort = 1;
	
	overlay fadeOverTime( duration );
	overlay.alpha = 1;
	
	AmbientStop( duration );
	
	flag_wait( "credits_ended" );
	
	wait 14;
	
	// Fade music, then end level
	MusicStop( duration );
	
	wait duration;

	setdvar( "credits_active", "0" ); 
		
	if ( isdefined( level.credits_frommenu ) )
		changelevel( "" );
	else
		maps\_endmission::credits_end();
}

music()
{
	wait 2;
	
	MusicPlayWrapper( "credits_jeepride_defend_music" );
	
	wait 120;
	musicStop( 4 );
	wait 4.1;
	
	MusicPlayWrapper( "credits_bog_victory" );
	
	wait 80;
	musicStop( 6 );
	wait 6.1;
	
	MusicPlayWrapper( "deepandhard_music" );
	
	wait 218;
	musicStop( 5 );
}