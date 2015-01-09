main()
{
	maps\mp\mp_countdown_fx::main();
	maps\createart\mp_countdown_art::main();
	maps\mp\_load::main();

	maps\mp\_compass::setupMiniMap("compass_map_mp_countdown");

	ambientPlay("ambient_crossfire");

	game["allies"] = "sas";
	game["axis"] = "russian";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";
	
	setdvar( "r_specularcolorscale", "1.5" );
	
	setdvar("compassmaxrange","2000");
}