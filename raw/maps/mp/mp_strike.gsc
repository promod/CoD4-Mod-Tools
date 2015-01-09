main()
{
	maps\mp\mp_strike_fx::main();
	maps\createart\mp_strike_art::main();
	maps\mp\_load::main();
	
	maps\mp\_compass::setupMiniMap("compass_map_mp_strike");

	//setExpFog(500, 2700, .46, 0.49, 0.47, 0);
	//setExpFog(0, 7000, 168/255, 158/255, 135/255, 3.0);	
	ambientPlay("ambient_strike_day");
	//VisionSetNaked( "mp_strike" );

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	setdvar( "r_specularcolorscale", "1" );

	setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");
	setdvar("compassmaxrange","1900");

	setdvar( "r_specularcolorscale", "1.86" );
}