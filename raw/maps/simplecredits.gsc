#include common_scripts\utility;
#include maps\_utility;
#include maps\simplecredits_code;
#include maps\_credits;

main()
{
	thread initCredits();
	thread playCredits();
	thread createBlackOverlay();
	//MusicPlayWrapper( "endcredits_music" );
	
	thread music();

	setdvar( "credits_load", "0" );
	setdvar( "credits_active", "1" );
	level.credits_active = true;

	flag_init( "credits_ended" );

	maps\_load::main();
	setSavedDvar( "sv_saveOnStartMap", false );

	level.player freezeControls( true );
	level.player takeAllWeapons();

	wait 0.05;// can't set dvars on the first frame
	SetSavedDvar( "g_friendlyfiredist", 0 );
	SetSavedDvar( "g_friendlynamedist", 0 );
	SetSavedDvar( "compass", 0 );
	SetSavedDvar( "ammoCounterHide", 1 );
	SetSavedDvar( "hud_showStance", 0 );

	thread endlevel_transition();
}


endlevel_transition()
{
	flag_wait( "credits_ended" );
	wait 14;

	duration = 5;

	// Fade screen and music, then end level
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

	MusicStop( duration );

	wait duration;

	setdvar( "credits_active", "0" );

	changelevel( "" );
}

music()
{
	MusicPlayWrapper( "simplecredits_rocking" );
	wait 155;
	musicStop( 6 );
	wait 6.1;
	
	MusicPlayWrapper( "simplecredits_abandoned" );
	wait 110;
	musicStop( 7 );
	wait 7.1;
	
	MusicPlayWrapper( "simplecredits_abandoned" );
	wait 85;
	musicStop( 6 );
}