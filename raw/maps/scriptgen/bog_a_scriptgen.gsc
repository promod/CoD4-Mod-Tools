//script generated script do not write your own script here it will go away if you do.
main()
{

	level.script_gen_dump = [];

	maps\_seaknight::main("vehicle_ch46e_low");
	maps\_cobra::main("vehicle_cobra_helicopter_fly_low");
	maps\_m1a1::main("vehicle_m1a1_abrams");
	maps\createart\bog_a_art::main();
	maps\createfx\bog_a_fx::main();
	maps\_flare::main("tag_flash");
	level.script_gen_dump["vehicle_ch46e_low"] = "vehicle_ch46e_low";
	level.script_gen_dump["vehicle_cobra_helicopter_fly_low"] = "vehicle_cobra_helicopter_fly_low";
	level.script_gen_dump["vehicle_m1a1_abrams"] = "vehicle_m1a1_abrams";
	level.script_gen_dump["bog_a_art"] = "bog_a_art";
	level.script_gen_dump["bog_a_fx"] = "bog_a_fx";
	level.script_gen_dump["tag_flash"] = "tag_flash";

	maps\_load::main(1);
}
