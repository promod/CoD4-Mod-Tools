main()
{
	//maps\mp\mp_hill_fx::main();
	maps\mp\_load::main();

	maps\mp\_compass::setupMiniMap("compass_map_mp_hill");

	VisionSetNaked( "mp_hill" );
	ambientPlay("ambient_hill");

	game["allies"] = "sas";
	game["axis"] = "russian";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

	setdvar( "r_specularcolorscale", "1" );
}