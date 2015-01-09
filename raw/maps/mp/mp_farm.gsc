main()
{
	maps\mp\mp_farm_fx::main();
	maps\createart\mp_farm_art::main();
	maps\mp\_load::main();

	maps\mp\_compass::setupMiniMap("compass_map_mp_farm");

	//setExpFog(300, 1400, 0.5, 0.5, 0.5, 0);
	ambientPlay("ambient_farm");
	//VisionSetNaked( "mp_farm" );
	
	game["allies"] = "sas";
	game["axis"] = "russian";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

	setdvar( "r_specularcolorscale", "5" );

	setdvar("compassmaxrange","2000");
}


