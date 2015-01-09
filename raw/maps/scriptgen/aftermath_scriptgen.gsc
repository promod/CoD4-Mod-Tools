//script generated script do not write your own script here it will go away if you do.
main()
{

	level.script_gen_dump = [];

	maps\_humvee::main("vehicle_humvee_camo");
	maps\createart\aftermath_art::main();
	maps\createfx\aftermath_fx::main();
	level.script_gen_dump["vehicle_humvee_camo"] = "vehicle_humvee_camo";
	level.script_gen_dump["aftermath_art"] = "aftermath_art";
	level.script_gen_dump["aftermath_fx"] = "aftermath_fx";

	maps\_load::main(1);
}
