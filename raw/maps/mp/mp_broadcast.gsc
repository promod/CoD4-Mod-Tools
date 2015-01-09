main()
{
	maps\mp\mp_broadcast_fx::main();
	maps\createart\mp_broadcast_art::main();
	maps\mp\_load::main();
	
	maps\mp\_compass::setupMiniMap("compass_map_mp_broadcast");
	
	ambientPlay("ambient_broadcast_ext1");

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";
	
	setdvar( "r_specularcolorscale", "1" );
	
	setdvar("compassmaxrange","1600");
}
