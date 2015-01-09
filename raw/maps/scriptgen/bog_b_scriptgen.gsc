//script generated script do not write your own script here it will go away if you do.
main()
{

	level.script_gen_dump = [];

	maps\_m1a1::main("vehicle_m1a1_abrams");
	maps\_t72::main("vehicle_t72_tank");
	maps\_blackhawk::main("vehicle_blackhawk");
	maps\createart\bog_b_art::main();
	maps\createfx\bog_b_fx::main();
	level.script_gen_dump["vehicle_m1a1_abrams"] = "vehicle_m1a1_abrams";
	level.script_gen_dump["vehicle_blackhawk"] = "vehicle_blackhawk";
	level.script_gen_dump["bog_b_art"] = "bog_b_art";
	level.script_gen_dump["bog_b_fx"] = "bog_b_fx";

	maps\_load::main(1);
}

