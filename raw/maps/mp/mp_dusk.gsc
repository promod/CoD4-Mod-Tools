main()
{
	//maps\mp\mp_crash_fx::main();
	maps\mp\_load::main();
	
	maps\mp\_compass::setupMiniMap("compass_map_mp_dusk");
	
	//setExpFog(300, 3500, .5, 0.5, 0.45, 0);
	ambientPlay("ambient_dusk");
	VisionSetNaked( "armada_ground" );

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	setdvar( "r_specularcolorscale", "1" );

	maps\mp\_explosive_barrels::main();
}


