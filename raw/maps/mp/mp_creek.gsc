#include maps\mp\_utility;
#include common_scripts\utility;

main()
{
	setExpFog(612, 25000, 0.613, 0.671, 0.75, 0);
	VisionSetNaked( "mp_creek", 0 );

	maps\mp\mp_creek_fx::main();

	maps\mp\_load::main();
	ambientPlay("ambient_creek_ext0");
	
	maps\mp\_compass::setupMiniMap("compass_map_mp_creek");
	
	game["allies"] = "sas";
	game["axis"] = "russian";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "woodland";
	game["axis_soldiertype"] = "woodland";
}