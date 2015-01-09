main()
{
	maps\mp\mp_vacant_fx::main();
	maps\createart\mp_vacant_art::main();
	maps\mp\_load::main();
	
	maps\mp\_compass::setupMiniMap("compass_map_mp_vacant");
	
	//setExpFog(500, 3500, .5, 0.5, 0.45, 0);
	ambientPlay("ambient_middleeast_ext");
	//VisionSetNaked( "mp_vacant" );
	
	game["allies"] = "sas";
	game["axis"] = "russian";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";

	setdvar( "r_specularcolorscale", "1" );

	setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");
	setdvar("compassmaxrange","1500");
}
