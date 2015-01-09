//script generated script do not write your own script here it will go away if you do.
main()
{

	level.script_gen_dump = [];

	maps\createart\cargoship_art::main();
	maps\createfx\cargoship_fx::main();
	level.script_gen_dump["cargoship_art"] = "cargoship_art";
	level.script_gen_dump["cargoship_fx"] = "cargoship_fx";

	maps\_load::main(1);
}
