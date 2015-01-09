main()
{
	maps\mp\mp_convoy_fx::main();
	maps\createart\mp_convoy_art::main();
	maps\mp\_load::main();

	maps\mp\_compass::setupMiniMap("compass_map_mp_convoy");

	setExpFog(800, 20000, 0.583, 0.631569, 0.553078, 0);
    //setcullfog (128, 16000, 1, .8, .4, 0);
	ambientPlay("ambient_convoy");

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";

	setdvar( "r_specularcolorscale", "1" );

	setdvar("compassmaxrange","2000");
}