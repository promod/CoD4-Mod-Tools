#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\village_assault_code;

main()
{
	/#
	if ( getdvar( "r_reflectionProbeGenerate" ) == "1" )
		return;
	
	if ( getdvar( "village_assault_disable_gameplay") == "" )
		setdvar( "village_assault_disable_gameplay", "0" );
	#/
	
	precacheLevelStuff();
	setLevelDVars();
	
	add_start( "town", 	::start_town, &"STARTS_TOWN" );
	add_start( "alasad_barn",::start_alasad_barn, &"STARTS_ALASADBARN" );
	add_start( "alasad_house",::start_alasad_house, &"STARTS_ALASADHOUSE" );
	default_start( ::start_start );
	
	maps\_mi28::main( "vehicle_mi-28_flying" );
	maps\_bmp::main( "vehicle_bmp_woodland" );
	maps\createart\village_assault_art::main();
	maps\village_assault_fx::main();
	maps\_c4::main();
	maps\_hiding_door::main();
	thread maps\_pipes::main();
	thread maps\_leak::main();
	maps\_load::main();
	maps\_nightvision::main();
	maps\_load::set_player_viewhand_model( "viewhands_player_sas_woodland" );
	maps\_javelin::init();
	animscripts\dog_init::initDogAnimations();
	thread scriptCalls();
	
	add_hint_string( "armor_damage", &"SCRIPT_ARMOR_DAMAGE", undefined );
	thread add_objective_building( "1" );
	thread add_objective_building( "2" );
	thread add_objective_building( "3" );
	thread add_objective_building( "4" );
	thread add_objective_building( "5" );
	thread add_objective_building( "6" );
	thread objective_updateNextWaypoints();
	
	wait 0.05;
	
	setSavedDvar( "compassObjectiveMaxHeight", "800" );
	setSavedDvar( "compassObjectiveMinHeight", "-800" );
}

start_start()
{
	spawn_starting_friendlies( "friendly_start" );
	thread gameplay_start();
}

start_town()
{
	spawn_starting_friendlies( "friendly_town" );
	movePlayerToLocation( "player_start_town" );
}

start_alasad_barn()
{
	spawn_starting_friendlies( "friendly_alasad_barn" );
	movePlayerToLocation( "player_start_alasad_barn" );
	thread do_alasad( "barn" );
}

start_alasad_house()
{
	spawn_starting_friendlies( "friendly_alasad_house" );
	movePlayerToLocation( "player_start_alasad_house" );
	thread do_alasad( "house" );
}

gameplay_start()
{
	friendly_stance( "crouch" );
	
	thread battlechatter_trigger_on();
	opening_sequence();
	
	friendly_stance( "stand", "crouch", "prone" );
	getent( "first_trigger_after_gas_station", "script_noteworthy" ) notify( "trigger" );
	
	for( i = 0 ; i < level.friendlies.size ; i++ )
		level.friendlies[ i ] pushplayer( true );
	
	getent( "pushplayer_off", "targetname" ) waittill( "trigger" );
	
	for( i = 0 ; i < level.friendlies.size ; i++ )
		level.friendlies[ i ] pushplayer( false );
}

battlechatter_trigger_on()
{
	battlechatter_off( "allies" );
	battlechatter_off( "axis" );
	
	getent( "battlechatter_on_trigger", "targetname" ) waittill( "trigger" );
	
	battlechatter_on( "allies" );
	battlechatter_on( "axis" );
	
	// Autosave the game at this point
	thread doAutoSave( "entered_town" );
	
	wait 60;
	thread air_support_hint_print_activate();
}